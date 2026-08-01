#!/usr/bin/env python3
"""Seal the isolated root worker's honest-stop audit."""

from __future__ import annotations

import hashlib
import json
from pathlib import Path


HERE = Path(__file__).resolve().parent
FILES = (
    "STATUS.md",
    "SOURCE_VALUATION_AUDIT.md",
    "REPLAY.md",
    "verify_root_audit.py",
    "verify_source_hyperplane_stabilizer.py",
    "../SEAL.json",
)


def digest(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def main() -> None:
    payload = {
        "format": "goal-F-root-honest-stop-audit-v1",
        "exit": "F-UNDECIDED",
        "headline": "OPEN",
        "sha256": {name: digest(HERE / name) for name in FILES},
    }
    (HERE / "SEAL.json").write_text(
        json.dumps(payload, indent=2, sort_keys=True) + "\n"
    )
    print("ROOT_GOAL_F_SEAL_WRITTEN")


if __name__ == "__main__":
    main()

