#!/usr/bin/env python3
"""Write SEAL.json with SHA-256 of packet artifacts."""
from __future__ import annotations

import hashlib
import json
import subprocess
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]

FILES = [
    "INPUT_MANIFEST.json",
    "coset_actions.json",
    "induced_points.json",
    "projectors.json",
    "operations.json",
    "landing_tests.json",
    "secant_geometry.json",
    "COSET_ACTIONS.md",
    "INDUCED_POINTS.md",
    "PERMUTATION_PROJECTORS.md",
    "LOW_ARITY_OPERATIONS.md",
    "SECANT_GEOMETRY.md",
    "produce.py",
    "produce_meta.json",
    "verify_induction.py",
    "verify_operations.py",
    "verify_point.py",
    "REPLAY.md",
    "STATUS.md",
    "make_seal.py",
]


def sha256(path: Path) -> str:
    h = hashlib.sha256()
    with path.open("rb") as f:
        for chunk in iter(lambda: f.read(1 << 20), b""):
            h.update(chunk)
    return h.hexdigest()


def main() -> None:
    commit = subprocess.check_output(
        ["git", "rev-parse", "HEAD"], cwd=ROOT, text=True
    ).strip()
    files = {}
    for name in FILES:
        p = HERE / name
        if not p.is_file():
            raise SystemExit(f"missing {name}")
        files[name] = sha256(p)
    seal = {
        "format": "g4-a5-index11-transfer-seal-v1",
        "exit": "G4-INDUCED-DEGREE11-POINT-PASS",
        "also_notes": [
            "G-module of Ind is 1+10 (not 1+5+5)",
            "G4.2 landing residual: needs G3-frame coordinates",
            "G4.3 secant residual: no deg 1-2 residual obtained",
        ],
        "headline": "OPEN",
        "stages": ["G4.0", "G4.1", "G4.2", "G4.3"],
        "consumed_commit": commit,
        "files": files,
        "nonclaims": [
            "no G4-POINT-HEADLINE-POSITIVE",
            "no fabricated K_proj-point",
            "no G3-frame numeric Phi substitution for all 11 conjugates",
            "Klein/companion 5s of G not summands of Ind_H^G 1",
        ],
    }
    (HERE / "SEAL.json").write_text(json.dumps(seal, indent=2) + "\n")
    print("G4_SEAL_OK")
    print(seal["exit"])


if __name__ == "__main__":
    main()
