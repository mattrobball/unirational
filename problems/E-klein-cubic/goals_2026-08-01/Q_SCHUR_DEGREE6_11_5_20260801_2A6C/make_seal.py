#!/usr/bin/env python3
"""Seal the curated bounded degree-six theorem packet."""

from __future__ import annotations

import hashlib
import json
from pathlib import Path


HERE = Path(__file__).resolve().parent


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def main() -> None:
    files = sorted(
        path for path in HERE.iterdir() if path.is_file() and path.name != "SEAL.json"
    )
    payload = {
        "schema": "klein-q-schur-degree6-f55-seal-v1",
        "governing_status": "Q-UNDECIDED",
        "bounded_theorem": (
            "all five projective-character 11:5 landing schemes are empty in degree six"
        ),
        "combined_predecessor_scope": (
            "the sealed predecessor plus this packet excludes degrees one through six"
        ),
        "strict_scope": (
            "No all-degree exclusion and no point or pointlessness theorem for the "
            "genuine generic Schur twist."
        ),
        "files": {path.name: sha256(path) for path in files},
    }
    (HERE / "SEAL.json").write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n")
    print(f"sealed_files={len(files)}")
    print("Q_SCHUR_DEGREE6_F55_SEAL_WRITTEN")


if __name__ == "__main__":
    main()
