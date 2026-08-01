#!/usr/bin/env python3
"""Seal the isolated T target-branch route-refutation packet."""

from __future__ import annotations

import hashlib
import json
import subprocess
from pathlib import Path


HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]

ARTIFACTS = [
    "WORK_SCOPE.md",
    "T0_BRIDGE_LEDGER.md",
    "THEOREM.md",
    "STATUS.md",
    "produce_bridge_scope.py",
    "verify_bridge_scope.py",
    "proof_payload.json",
    "verify_result.json",
    "produce_seal.py",
    "verify_seal.py",
]


def sha256(path: Path) -> str:
    h = hashlib.sha256()
    with path.open("rb") as stream:
        for block in iter(lambda: stream.read(1024 * 1024), b""):
            h.update(block)
    return h.hexdigest()


def main() -> None:
    payload = json.loads((HERE / "proof_payload.json").read_text(encoding="utf-8"))
    head = subprocess.check_output(
        ["git", "rev-parse", "HEAD"], cwd=ROOT, text=True
    ).strip()
    if payload["consumed_head"] != head:
        raise RuntimeError("HEAD moved; rerun producer and verifier before sealing")

    seal = {
        "schema": "t-target-branch-t0-seal-v1",
        "exit": "T-ROUTE-REFUTED",
        "t0_subexit": "T-BRIDGE-BLOCKED",
        "problem_e_headline": "OPEN",
        "pinned_mathematical_baseline": payload["pinned_mathematical_baseline"],
        "consumed_head": head,
        "artifacts": {name: sha256(HERE / name) for name in ARTIFACTS},
        "upstream_sources": {
            item["path"]: item["sha256"] for item in payload["sources"].values()
        },
    }
    (HERE / "SEAL.json").write_text(
        json.dumps(seal, indent=2, sort_keys=True) + "\n", encoding="utf-8"
    )
    print("T_TARGET_BRANCH_SEAL_PRODUCER_ACCEPT")


if __name__ == "__main__":
    main()
