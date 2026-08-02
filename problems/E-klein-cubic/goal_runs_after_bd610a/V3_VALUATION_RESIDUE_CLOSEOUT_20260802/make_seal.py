#!/usr/bin/env python3
"""Write the recursive SHA-256 seal for the V3 packet."""

from __future__ import annotations

import hashlib
import json
from pathlib import Path


HERE = Path(__file__).resolve().parent


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def main() -> None:
    files = {
        str(path.relative_to(HERE)): sha256(path)
        for path in sorted(HERE.rglob("*"))
        if path.is_file() and path.name != "SEAL.json" and "__pycache__" not in path.parts
    }
    seal = {
        "schema": "klein-v3-valuation-residue-seal-v1",
        "goal_exit": "V-UNDECIDED",
        "scoped_exit": "V3-RESIDUE-NORMAL-FORM-PASS",
        "finite_exit": "V-F5-DEGREE16-SUPPORT-LE5-EMPTY",
        "problem_e_headline": "OPEN",
        "files_sha256": files,
    }
    (HERE / "SEAL.json").write_text(json.dumps(seal, indent=2, sort_keys=True) + "\n")
    print(f"V3_SEAL_WRITTEN files={len(files)}")


if __name__ == "__main__":
    main()
