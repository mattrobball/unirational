#!/usr/bin/env python3
"""Produce the deterministic SHA-256 seal for the Goal R packet."""

from __future__ import annotations

import hashlib
import json
from pathlib import Path


HERE = Path(__file__).resolve().parent
SEALED_FILES = [
    "STATUS.md",
    "THEOREM.md",
    "HILBERT_INVENTORY.md",
    "SOURCES.md",
    "component_inventory.json",
    "structural_payload.json",
    "produce_fixed_jacobian.py",
    "fixed_jacobian_payload.json",
    "verify_fixed_jacobian.py",
    "probe_full_group_h1_mod3.py",
    "group_cohomology_payload.json",
    "verify_group_cohomology.py",
    "verify_all.py",
    "produce_seal.py",
    "verify_seal.py",
]


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def main() -> None:
    hashes = {}
    for relative in SEALED_FILES:
        path = HERE / relative
        if not path.is_file():
            raise FileNotFoundError(path)
        hashes[relative] = sha256(path)
    payload = {
        "schema": "klein-rational-curve-seal-v2",
        "exit": "R-HILBERT-COMPONENT-STRUCTURAL",
        "headline": "OPEN",
        "hash_algorithm": "sha256",
        "files": hashes,
    }
    output = HERE / "SEAL.json"
    output.write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n", encoding="utf-8")
    print("wrote", output.name)
    print("R_RATIONAL_CURVES_SEAL_PRODUCED")


if __name__ == "__main__":
    main()
