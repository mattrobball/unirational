#!/usr/bin/env python3
"""Seal the C5 convention audit and executable corrected incidence."""

from __future__ import annotations

import hashlib
import json
from pathlib import Path


HERE = Path(__file__).resolve().parent

LOCAL_FILES = (
    "INPUT_MANIFEST.json",
    "CONVENTION_AND_EQUIVALENCE.md",
    "CANONICAL_ALGEBRA.md",
    "PROJECTOR_INCIDENCE.md",
    "CORRECTED_INCIDENCE.md",
    "morita_generic.md",
    "morita_generic_split.md",
    "THEORETIC_DESCENT_BOUNDARY.md",
    "PROJECTIVE_MIXED_REDUCTION.md",
    "DESCENT_COMPATIBLE_ANSATZ_AUDIT.md",
    "DEGREE16_FANO_EXCLUSION.md",
    "MODULAR_SEED_P23.md",
    "MORITA_SEED_P23.md",
    "corrected_incidence.json",
    "corrected_incidence_geometry.json",
    "generic_pluecker_incidence.json",
    "morita_generic_dag.json",
    "morita_generic_split_dag.json",
    "projective_mixed_reduction.json",
    "descent_compatible_ansatz_audit.json",
    "degree16_fano_exclusion.json",
    "projector_incidence.json",
    "canonical_algebra_api.json",
    "EMPTY.md",
    "BRIDGE_FANO_POS.md",
    "STATUS.md",
    "README.md",
    "REPLAY.md",
    "VERIFY_TRANSCRIPT.txt",
    "COMPLETION_AUDIT.md",
    "canonical_algebra.py",
    "produce.py",
    "build_incidence.py",
    "build_corrected_incidence.py",
    "build_generic_pluecker_incidence.py",
    "morita_generic_build.py",
    "morita_generic_split_build.py",
    "verify.py",
    "verify_incidence.py",
    "verify_corrected_incidence.py",
    "verify_generic_pluecker_incidence.py",
    "morita_generic_verify.py",
    "morita_generic_split_verify.py",
    "verify_projective_mixed_reduction.py",
    "verify_descent_compatible_ansatz.py",
    "verify_degree16_fano_exclusion.py",
    "verify_modular_seed_p23.py",
    "verify_morita_seed_p23.py",
    "corrected_nilpotent_scheme_QQ.sing",
    "corrected_nilpotent_scheme_QQ.out",
    "corrected_fano_p331.sing",
    "corrected_fano_p331.out",
    "corrected_fano_smoothness_p331.sing",
    "corrected_fano_smoothness_p331.out",
    "corrected_fano_p463.sing",
    "corrected_fano_p463.out",
    "corrected_fano_smoothness_p463.sing",
    "corrected_fano_smoothness_p463.out",
    "corrected_fano_p419.sing",
    "corrected_fano_p419.out",
    "corrected_fano_smoothness_p419.sing",
    "corrected_fano_smoothness_p419.out",
    "make_seal.py",
)


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as stream:
        for block in iter(lambda: stream.read(1 << 20), b""):
            digest.update(block)
    return digest.hexdigest()


def main() -> None:
    manifest = json.loads((HERE / "INPUT_MANIFEST.json").read_text())
    missing = [name for name in LOCAL_FILES if not (HERE / name).is_file()]
    assert not missing, missing
    external = {
        entry["path"]: entry["sha256"]
        for section in ("authoritative_inputs", "audit_only_inputs")
        for entry in manifest[section].values()
    }
    payload = {
        "format": "c5-projector-incidence-seal-v2",
        "exit": "C5-UNDECIDED",
        "marker": "C5_CONVENTION_GATE_FAIL",
        "corrected_marker": "C5_CORRECTED_INCIDENCE_GEOMETRY_INDEPENDENTLY_VERIFIED",
        "generic_markers": [
            "C5_GENERIC_PLUECKER_INCIDENCE_INDEPENDENTLY_VERIFIED",
            "C5-MORITA-GENERIC-390-COEFFICIENT-DAG-INDEPENDENTLY-VERIFIED",
            "MORITA-GENERIC-SPLIT-DAG-VERIFIED",
            "C5_PROJECTIVE_MIXED_REDUCTION_OK",
        ],
        "finite_fibre_markers": [
            "C5_MODULAR_SEED_P23_OK",
            "C5-MORITA-SEED-P23-INDEPENDENTLY-VERIFIED",
        ],
        "bounded_markers": [
            "C5_DEGREE16_FANO_EXCLUSION_INDEPENDENTLY_VERIFIED",
            "ALL CHECKS PASS -- BOUNDED AUDIT ONLY; NO ALL-DEGREE VERDICT",
        ],
        "local_files": {name: sha256(HERE / name) for name in LOCAL_FILES},
        "external_inputs": dict(sorted(external.items())),
        "excluded": [
            "SEAL.json",
            "__pycache__/",
            "degree17_fano_p23.leading.work",
            "*.work",
            "mutable solver scratch",
            "wall-clock timings",
        ],
    }
    (HERE / "SEAL.json").write_text(json.dumps(payload, indent=2) + "\n")
    print("WROTE SEAL.json")
    print("C5-SEAL-OK")


if __name__ == "__main__":
    main()
