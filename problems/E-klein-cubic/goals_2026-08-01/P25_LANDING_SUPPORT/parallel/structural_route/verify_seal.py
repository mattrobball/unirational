#!/usr/bin/env python3
"""Verify hashes and rerun both low-memory structural checks."""

from __future__ import annotations

import hashlib
import json
from pathlib import Path
import subprocess


HERE = Path(__file__).resolve().parent


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        while block := handle.read(1 << 20):
            digest.update(block)
    return digest.hexdigest()


def main() -> None:
    seal = json.loads((HERE / "SEAL.json").read_text())
    for entry in seal["files"]:
        path = HERE / entry["file"]
        if path.stat().st_size != entry["bytes"] or sha256(path) != entry["sha256"]:
            raise AssertionError(f"seal mismatch: {path.name}")
    markers = []
    for script, marker in [
        ("verify_mds_cover.py", "PASS_INDEPENDENT_STAGEB_H8_MDS_COVER"),
        ("audit_structure.py", "PASS_EXACT_LOW_MEMORY_STRUCTURAL_AUDIT"),
    ]:
        completed = subprocess.run(
            ["/opt/homebrew/bin/python3", "-u", str(HERE / script)],
            text=True,
            capture_output=True,
            timeout=120,
            check=False,
        )
        output = completed.stdout + completed.stderr
        if completed.returncode != 0 or marker not in output:
            raise AssertionError(f"replay failed for {script}:\n{output[-4000:]}")
        markers.append(marker)
    payload = {
        "status": "PASS_INDEPENDENT_STRUCTURAL_ROUTE_SEAL",
        "sealed_files": len(seal["files"]),
        "replay_markers": markers,
        "stageB_decided": False,
        "stageC_decided": False,
        "p25_decided": False,
    }
    (HERE / "verify_seal_result.json").write_text(
        json.dumps(payload, indent=2, sort_keys=True) + "\n"
    )
    print(json.dumps(payload, sort_keys=True))


if __name__ == "__main__":
    main()

