#!/usr/bin/env python3
"""Independently replay the hashes and sibling-seal boundary in the manifest."""

from __future__ import annotations

import hashlib
import json
from pathlib import Path


HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
MANIFEST = HERE / "INPUT_MANIFEST.json"
RESULT = HERE / "verify_reported_inputs_result.json"


def sha256_file(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        while chunk := handle.read(1 << 22):
            digest.update(chunk)
    return digest.hexdigest()


def replay_seal(audit: dict[str, object]) -> list[dict[str, object]]:
    seal_path = ROOT / audit["seal"]
    directory = seal_path.parent
    payload = json.loads(seal_path.read_text())
    records = payload["files"]
    if isinstance(records, dict):
        records = [
            dict(
                path=path,
                sha256=(value["sha256"] if isinstance(value, dict) else value),
            )
            for path, value in records.items()
        ]
    mismatches = []
    for record in records:
        path = directory / record["path"]
        actual = sha256_file(path) if path.is_file() else None
        if actual != record["sha256"]:
            mismatches.append(
                {
                    "path": record["path"],
                    "sealed_sha256": record["sha256"],
                    "actual_sha256": actual,
                }
            )
    return mismatches


def main() -> int:
    manifest = json.loads(MANIFEST.read_text())
    for record in manifest["inputs"]:
        path = ROOT / record["path"]
        if not path.is_file():
            raise AssertionError(f"missing input: {record['path']}")
        if path.stat().st_size != record["bytes"]:
            raise AssertionError(f"size mismatch: {record['path']}")
        if sha256_file(path) != record["sha256"]:
            raise AssertionError(f"hash mismatch: {record['path']}")

    seal_results = {}
    for name, audit in manifest["sibling_seal_audits"].items():
        mismatches = replay_seal(audit)
        if mismatches != audit["mismatches"]:
            raise AssertionError(f"seal audit drift: {name}")
        seal_results[name] = {
            "records": audit["records"],
            "mismatches": len(mismatches),
            "intact": not mismatches,
        }

    result = {
        "ok": True,
        "status": "PASS_REPORTED_INPUT_REPLAY",
        "inputs": len(manifest["inputs"]),
        "sibling_seals": seal_results,
        "scope": (
            "This verifies file identity and current sibling-seal state. It does "
            "not reprove the mathematical contents of inherited PC.3 artifacts."
        ),
    }
    RESULT.write_text(json.dumps(result, indent=2, sort_keys=True) + "\n")
    print("PASS_REPORTED_INPUT_REPLAY")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
