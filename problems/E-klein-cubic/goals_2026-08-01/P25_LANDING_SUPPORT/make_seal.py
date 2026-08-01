#!/usr/bin/env python3
"""Seal the load-bearing files of the terminal P25 packet."""

from __future__ import annotations

import hashlib
import json
from pathlib import Path


HERE = Path(__file__).resolve().parent
REQUIRED = [
    "STATUS.md",
    "SUPPORT.md",
    "candidate_or_empty.json",
    "produce_msolve_input.py",
    "produce_standard_input.py",
    "run_msolve.py",
    "verify_p25_empty.py",
    "verify_seal.py",
    "make_seal.py",
    "msolve_standard_input.json",
    "landing_746_standard.ms",
    "landing_746_standard_leading.out",
    "landing_746_standard_msolve.log",
    "landing_746_standard_msolve_result.json",
    "landing_746_replay_leading.out",
    "landing_746_replay_msolve.log",
    "verify_result.json",
    "rowrank_replay.log",
    "rowrank_replay_report.json",
    "border_replay.log",
    "dvr_replay.log",
]


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        while block := handle.read(2**20):
            digest.update(block)
    return digest.hexdigest()


def main() -> None:
    missing = [name for name in REQUIRED if not (HERE / name).is_file()]
    if missing:
        raise SystemExit(f"cannot seal; missing {missing}")
    payload = {
        "exit": "P25-DEGREE25-EMPTY",
        "scope": "exact degree-25 landing scheme; headline remains OPEN",
        "files": {
            name: {
                "bytes": (HERE / name).stat().st_size,
                "sha256": sha256(HERE / name),
            }
            for name in REQUIRED
        },
    }
    (HERE / "SEAL.json").write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n")
    print(f"sealed {len(REQUIRED)} files")


if __name__ == "__main__":
    main()
