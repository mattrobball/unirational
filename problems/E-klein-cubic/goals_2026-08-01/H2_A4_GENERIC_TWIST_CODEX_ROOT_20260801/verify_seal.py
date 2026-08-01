#!/usr/bin/env python3
"""Verify the H2 content manifest without modifying it."""

from __future__ import annotations

import hashlib
import json
from pathlib import Path


HERE = Path(__file__).resolve().parent
PROJECT = next(
    parent for parent in HERE.parents
    if (parent / "certificates" / "exact_weil_check.py").is_file()
    and (parent / "goals_2026-08-01" / "H_SUBGROUP_TWISTS_ROOT_019FBE10" / "twists.json").is_file()
)
INPUTS = {
    "GOAL_H2_A4_GENERIC_TWIST.md": PROJECT / "goals_after_35fa8f" / "GOAL_H2_A4_GENERIC_TWIST.md",
    "H_SUBGROUP_TWISTS_ROOT_019FBE10/twists.json": PROJECT / "goals_2026-08-01" / "H_SUBGROUP_TWISTS_ROOT_019FBE10" / "twists.json",
    "H_SUBGROUP_TWISTS_ROOT_019FBE10/produce.py": PROJECT / "goals_2026-08-01" / "H_SUBGROUP_TWISTS_ROOT_019FBE10" / "produce.py",
    "H_SUBGROUP_TWISTS_ROOT_019FBE10/a4_direct_search.py": PROJECT / "goals_2026-08-01" / "H_SUBGROUP_TWISTS_ROOT_019FBE10" / "a4_direct_search.py",
    "certificates/exact_weil_check.py": PROJECT / "certificates" / "exact_weil_check.py",
}


def main():
    payload = json.loads((HERE / "SEAL.json").read_text())
    assert payload["format"] == "H2-A4-GENERIC-TWIST-SEAL-v1"
    assert payload["decision"] == ["H-A4-RATIONAL-POINT", "H-A4-STRUCTURAL-MODEL-PASS"]
    for relative, expected in payload["files"].items():
        path = HERE / relative
        assert path.is_file(), relative
        data = path.read_bytes()
        assert len(data) == expected["bytes"], relative
        assert hashlib.sha256(data).hexdigest() == expected["sha256"], relative
    for relative, expected in payload["inputs"].items():
        path = INPUTS[relative]
        assert path.is_file(), relative
        data = path.read_bytes()
        assert len(data) == expected["bytes"], relative
        assert hashlib.sha256(data).hexdigest() == expected["sha256"], relative
    top_level = {path.name for path in HERE.iterdir() if path.is_file()}
    assert top_level == set(payload["files"]) | {"SEAL.json"}
    assert "INVALID_TRANSPOSED_DEGREE5" not in payload["files"]
    print(f"PASS {len(payload['files'])} sealed file hashes and {len(payload['inputs'])} input hashes")
    print("PASS H-A4-RATIONAL-POINT scope")
    print("H2_A4_SEAL_VERIFIED")


if __name__ == "__main__":
    main()
