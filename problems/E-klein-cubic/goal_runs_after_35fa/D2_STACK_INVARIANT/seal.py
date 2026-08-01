#!/usr/bin/env python3
"""Create a deterministic Goal D2 seal with no self-hash or timestamp."""

from __future__ import annotations

import hashlib
import json
from pathlib import Path


ROOT = Path(__file__).resolve().parent
SEALED = [
    "STATUS.md",
    "INVARIANT_DEFINITION.md",
    "SYLOW_DETECTION.md",
    "THEOREM_AUDIT.md",
    "COUNTERMODELS.md",
    "ADMISSIBLE_CENTRE_CLOSURE.md",
    "COMPLETION_AUDIT.md",
    "invariant_payload.json",
    "produce.py",
    "seal.py",
    "verify.py",
]


def digest(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def main() -> None:
    missing = [name for name in SEALED if not (ROOT / name).is_file()]
    if missing:
        raise SystemExit(f"cannot seal; missing files: {missing}")
    data = {
        "schema": "D2_STACK_INVARIANT.SEAL.v1",
        "exit": "D2-NO-VALID-BRIDGE",
        "self_hash_included": False,
        "source_commit": "37d61c19a108781cf74af837e24810a9f7f7c3be",
        "produced_commit": None,
        "files": {name: digest(ROOT / name) for name in SEALED},
    }
    (ROOT / "SEAL.json").write_text(
        json.dumps(data, indent=2, sort_keys=True) + "\n", encoding="utf-8"
    )
    print("D2_STACK_INVARIANT_SEAL_OK")


if __name__ == "__main__":
    main()
