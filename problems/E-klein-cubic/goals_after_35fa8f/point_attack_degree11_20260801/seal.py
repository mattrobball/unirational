#!/usr/bin/env python3
"""Seal the exact H3 point-certificate trust boundary."""

from __future__ import annotations

import hashlib
import json
from pathlib import Path


HERE = Path(__file__).resolve().parent
ROOT = HERE.parent
PROJECT = ROOT.parent

FILES = (
    HERE / "STATUS.md",
    HERE / "PROOF.md",
    HERE / "REPLAY.md",
    HERE / "NONVERDICT.md",
    HERE / "exact_reynolds.py",
    HERE / "exact_eval_singular.py",
    HERE / "reconstruct_relations.py",
    HERE / "make_payloads.py",
    HERE / "verify_exact_point.py",
    HERE / "degree11_reconstructed_relations.json",
    HERE / "degree11_covariants_raw_exact.json",
    HERE / "class_1" / "POINT.json",
    HERE / "class_2" / "POINT.json",
    ROOT / "canonical_a5_pencil.py",
    PROJECT / "goals_2026-08-01" / "H_SUBGROUP_TWISTS_ROOT_019FBE10" / "twists.json",
)


def main():
    hashes = {}
    for path in FILES:
        assert path.is_file(), path
        try:
            label = str(path.relative_to(HERE))
        except ValueError:
            label = str(path)
        hashes[label] = hashlib.sha256(path.read_bytes()).hexdigest()
    payload = {
        "format": "klein-h3-two-a5-exact-points-seal-v1",
        "exits": [
            "H-A5-CLASS1-RATIONAL-POINT",
            "H-A5-CLASS2-RATIONAL-POINT",
        ],
        "verifier": {
            "command": "/opt/homebrew/bin/python3 -u point_attack_degree11_20260801/verify_exact_point.py",
            "marker": "H3_EXACT_BOTH_A5_POINTS_VERIFIED",
        },
        "files": hashes,
    }
    path = HERE / "SEAL.json"
    path.write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n")
    print("H3_POINT_SEAL_OK")


if __name__ == "__main__":
    main()
