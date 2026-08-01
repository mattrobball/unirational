#!/usr/bin/env python3
"""Create the timing-independent content seal for the Goal R packet."""

from __future__ import annotations

import hashlib
import json
from pathlib import Path


HERE = Path(__file__).resolve().parent
FILES = [
    "STATUS.md",
    "THEOREM.md",
    "HILBERT_INVENTORY.md",
    "SOURCES.md",
    "component_inventory.json",
    "fixed_jacobian_payload.json",
    "produce_fixed_jacobian.py",
    "verify_fixed_jacobian.py",
    "produce_seal.py",
    "verify.py",
]


def main() -> None:
    hashes = {name: hashlib.sha256((HERE / name).read_bytes()).hexdigest() for name in FILES}
    seal = {
        "packet": "R_RATIONAL_CURVES_CODEX",
        "exit": "R-HILBERT-COMPONENT-STRUCTURAL",
        "headline": "OPEN",
        "pinned_baseline": "715faf441289e2589b9325311b6613ea0331bf88",
        "repository_commit_consumed": "2140419410cfff2f7d7dcca166acef8c16a0d41b",
        "theorems": [
            "J_T(K_proj) = {0}",
            "no geometrically integral K_proj-conic on the genuine generic twist",
            "a K_proj-point of the generalized twisted-cubic Hilbert component forces a K_proj-point of the original twist",
        ],
        "strict_nonclaims": [
            "no point of the original generic twist was constructed",
            "pointlessness was not proved",
            "quartics and higher rational curves were not excluded",
        ],
        "replay": [
            "/opt/homebrew/bin/python3 produce_fixed_jacobian.py",
            "/opt/homebrew/bin/python3 produce_seal.py",
            "/opt/homebrew/bin/python3 verify.py",
        ],
        "sha256": hashes,
        "terminal_marker": "R_HILBERT_COMPONENT_STRUCTURAL_SEALED_HEADLINE_OPEN",
    }
    (HERE / "SEAL.json").write_text(json.dumps(seal, indent=2, sort_keys=True) + "\n")
    print("wrote SEAL.json")
    print(seal["terminal_marker"])


if __name__ == "__main__":
    main()
