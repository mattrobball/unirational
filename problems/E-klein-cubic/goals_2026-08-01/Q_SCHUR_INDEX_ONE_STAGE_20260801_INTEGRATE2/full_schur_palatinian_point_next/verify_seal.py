#!/usr/bin/env python3
"""Independently verify the strict retained-file theorem-packet seal."""
from __future__ import annotations

import hashlib
import json
from pathlib import Path

import make_seal


HERE = Path(__file__).resolve().parent
SEAL = HERE / "SEAL.json"


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def main() -> None:
    payload = json.loads(SEAL.read_text())
    assert payload["schema"] == "full-schur-palatinian-point-next-strict-seal-v1"
    assert payload["governing_status"] == "Q-UNDECIDED"
    assert "No arbitrary K_Schur-rational" in payload["strict_scope"]
    expected_groups = {
        key: list(value) for key, value in make_seal.GROUPS.items()
    }
    assert payload["groups"] == expected_groups
    names = [name for group in expected_groups.values() for name in group]
    assert set(payload["files"]) == set(names)
    for name in names:
        path = HERE / name
        assert path.is_file(), name
        record = payload["files"][name]
        assert path.stat().st_size == record["bytes"], name
        assert sha256(path) == record["sha256"], name
    print(f"PASS strict retained-file seal files={len(names)}")
    print("FULL_SCHUR_PALATINIAN_POINT_NEXT_STRICT_SEAL_OK")
    print("SCOPE: bounded pencil and constant-coefficient degree-nine theorems; Q remains undecided")


if __name__ == "__main__":
    main()
