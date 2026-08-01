#!/usr/bin/env python3
"""Create a deterministic hash manifest, excluding the seal itself."""

from __future__ import annotations

import hashlib
import json
from pathlib import Path


HERE = Path(__file__).resolve().parent
FILES = [
    "STATUS.md",
    "D_COUNTERMODEL_AUDIT.md",
    "FIXED_CENTRE_1MOTIVE.md",
    "BASE_IDEAL_CONSTRAINTS.md",
    "POLARIZATION_ISOGENY.md",
    "COMPLETION_AUDIT.md",
    "SOURCES.md",
    "payload.json",
    "produce.py",
    "verify.py",
    "make_seal.py",
]


def digest(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def main() -> None:
    missing = [name for name in FILES if not (HERE / name).is_file()]
    if missing:
        raise SystemExit(f"missing files: {missing}")
    data = {
        "packet": "J_BASELOCUS_PRYM",
        "exit": "J2-UNRESTRICTED-COUNTERMODEL-EXTENDS",
        "hash_algorithm": "sha256",
        "self_hash": "omitted by design",
        "files": {name: digest(HERE / name) for name in FILES},
    }
    (HERE / "SEAL.json").write_text(json.dumps(data, indent=2, sort_keys=True) + "\n")
    print("J_BASELOCUS_PRYM_SEAL_OK")


if __name__ == "__main__":
    main()

