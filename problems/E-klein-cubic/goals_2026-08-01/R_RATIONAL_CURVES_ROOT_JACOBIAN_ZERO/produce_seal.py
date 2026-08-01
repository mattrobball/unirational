#!/usr/bin/env python3
"""Create the timing-independent content seal for the Goal R packet."""

from __future__ import annotations

import hashlib
import json
from pathlib import Path


HERE = Path(__file__).resolve().parent
FILES = [
    "STATUS.md",
    "COMPLETION_AUDIT.md",
    "THEOREM.md",
    "HILBERT_INVENTORY.md",
    "SOURCES.md",
    "source_manifest.json",
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
        "packet": "R_RATIONAL_CURVES_ROOT_JACOBIAN_ZERO",
        "exit": "R-HILBERT-COMPONENT-STRUCTURAL",
        "headline": "OPEN",
        "pinned_baseline": "715faf441289e2589b9325311b6613ea0331bf88",
        "repository_commit_consumed": "9f58d6cbe889997fbd8af2fc23bf9ef0e28a55e2",
        "theorems": [
            "J_T(K_proj) = {0}",
            "no geometrically integral K_proj-conic on the genuine generic twist",
            "a K_proj-point of the generalized twisted-cubic Hilbert component forces a K_proj-point of the original twist",
            "every geometrically integral K_proj-curve with genus-zero normalization forces a K_proj-point by cubic secant residuation",
            "rational quartic and quintic components are reduced to their distinguished canonical Abel-Jacobi zero fibres",
            "no smooth K_proj-defined degree-5 genus-2 curve on the genuine generic twist",
            "no smooth K_proj-defined quartic elliptic curve on the genuine generic twist",
        ],
        "strict_nonclaims": [
            "no point of the original generic twist was constructed",
            "pointlessness was not proved",
            "quartics and higher rational curves were not excluded and their distinguished canonical zero fibres were not pointed",
        ],
        "acceptance": {
            "structural_exit_complete": True,
            "headline_positive": False,
            "problem_e_headline": "OPEN",
        },
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
