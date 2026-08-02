#!/usr/bin/env python3
"""Seal the Goal B exhaustiveness-refutation packet."""

from __future__ import annotations

import hashlib
import json
from pathlib import Path

HERE = Path(__file__).resolve().parent
FILES = [
    "README.md",
    "STATUS.md",
    "EXHAUSTIVENESS_THEOREM.md",
    "bridge_refutation.json",
    "produce.py",
    "verify.py",
    "produce_seal.py",
    "REPLAY.md",
]


def digest(path: Path) -> str:
    h = hashlib.sha256()
    with path.open("rb") as stream:
        for chunk in iter(lambda: stream.read(1 << 20), b""):
            h.update(chunk)
    return h.hexdigest()


def main() -> None:
    missing = [name for name in FILES if not (HERE / name).is_file()]
    if missing:
        raise FileNotFoundError(f"missing packet files: {missing}")
    seal = {
        "schema": "klein-goal-b-exhaustiveness-refutation-seal-v1",
        "exit": "B-BRIDGE-REFUTED",
        "headline": "OPEN",
        "files": {name: digest(HERE / name) for name in FILES},
    }
    (HERE / "SEAL.json").write_text(json.dumps(seal, indent=2, sort_keys=True) + "\n")
    print("B-EXHAUSTIVENESS-SEAL-PRODUCED")


if __name__ == "__main__":
    main()
