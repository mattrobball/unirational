#!/usr/bin/env python3
"""Regenerate the external-source manifest and local packet seal."""

from __future__ import annotations

import hashlib
import json
from pathlib import Path


HERE = Path(__file__).resolve().parent
REPOSITORY = HERE.parents[3]
MARKER = "A5_DEGREE11_ALL_SIX_SECANT_DESCENT_AUDIT_OK"


def sha256(path: Path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


SOURCE_FILES = [
    "goals_2026-08-01/Q_SCHUR_DESCENT/parallel/a5_orbit_rnc_agent/probe_rnc_rank.py",
    "goals_2026-08-01/Q_SCHUR_DESCENT/parallel/a5_orbit_rnc_agent/source_manifest.json",
    "goals_2026-08-01/Q_SCHUR_DESCENT/parallel/a5_orbit_rnc_agent/SEAL.json",
    "goals_2026-08-01/Q_SCHUR_DESCENT/parallel/a5_orbit_rnc_agent/verify.py",
    "goals_2026-08-01/H_SUBGROUP_TWISTS_ROOT_019FBE10/produce.py",
    "goals_2026-08-01/H_SUBGROUP_TWISTS_ROOT_019FBE10/twists.json",
    "certificates/exact_weil_check.py",
    "goals_after_35fa8f/point_attack_degree11_20260801/degree11_covariants_raw_exact.json",
    "goals_after_35fa8f/point_attack_degree11_20260801/degree11_reconstructed_relations.json",
    "goals_after_35fa8f/point_attack_degree11_20260801/verify_exact_point.py",
]

LOCAL_FILES = [
    "REPORT.md",
    "REPLAY.md",
    "analyze.py",
    "computed.json",
    "make_packet.py",
    "source_manifest.json",
    "verify.py",
]


def main():
    manifest = {name: sha256(REPOSITORY / name) for name in SOURCE_FILES}
    (HERE / "source_manifest.json").write_text(
        json.dumps(manifest, indent=2, sort_keys=True) + "\n"
    )
    seal = {
        "format": "a5-degree11-all-six-secant-descent-seal-v1",
        "marker": MARKER,
        "files": {name: sha256(HERE / name) for name in LOCAL_FILES},
        "strict_scope": (
            "All six transferred A5 point orbits, their exact good-fibre ranks, "
            "proper pair secants, D12 residual orbit, corresponding-line "
            "nonincidence, and the signed CH0 relation only; no K-point and no "
            "pointlessness theorem."
        ),
    }
    (HERE / "SEAL.json").write_text(json.dumps(seal, indent=2, sort_keys=True) + "\n")
    print("WROTE source_manifest.json", len(manifest))
    print("WROTE SEAL.json", len(seal["files"]))


if __name__ == "__main__":
    main()

