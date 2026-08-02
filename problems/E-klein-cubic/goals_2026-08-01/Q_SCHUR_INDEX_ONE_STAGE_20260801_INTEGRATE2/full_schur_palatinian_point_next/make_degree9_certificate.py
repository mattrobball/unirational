#!/usr/bin/env python3
"""Freeze hashes and deterministic semantic data for the degree-nine proof."""
from __future__ import annotations

import hashlib
import json
from pathlib import Path


HERE = Path(__file__).resolve().parent
ROOT = Path("/Users/worker/unirational/problems/E-klein-cubic")
OUTPUT = HERE / "degree9_projective_emptiness_certificate.json"


def sha256(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def semantic_sha256(path, ignored=()):
    payload = json.loads(path.read_text())
    for key in ignored:
        payload.pop(key, None)
    encoded = json.dumps(payload, sort_keys=True, separators=(",", ":")).encode()
    return hashlib.sha256(encoded).hexdigest()


def main():
    local_sources = [
        "pencil_mod23.py",
        "degree9_full_landing.py",
        "eigenline_rank_one_probe.py",
        "degree9_binary_factor_sat.py",
        "degree9_binary_factor_sat_exhaustive.py",
        "degree9_fast_linear_sat.py",
    ]
    external_sources = [
        "tmp/pfaffian_representation_alignment/core.py",
        "tmp/fano14_twist/fano_covariant_scan.py",
        "tmp/projective_source/character_scan.py",
        "goal_runs_after_35fa/Q_SCHUR_INDEX_ONE/full_schur_palatinian/probe_self_covariants_palatinian.py",
        "goal_runs_after_35fa/Q_SCHUR_INDEX_ONE/full_schur_palatinian/schur_self_molien.py",
        "goal_runs_after_35fa/Q_SCHUR_INDEX_ONE/full_schur_palatinian/verify_palatinian_equation.py",
        "goal_runs_after_35fa/Q_SCHUR_INDEX_ONE/full_schur_palatinian/verify_char0_palatinian_lift.py",
    ]
    eigenlines = HERE / "degree9_rank_one_eigenlines_f529.json"
    clauses = HERE / "degree9_binary_clauses_f529.json"
    result = HERE / "degree9_fast_linear_sat_f529.json"
    result_payload = json.loads(result.read_text())
    assert result_payload["projective_emptiness_over_algebraic_closure"]
    assert result_payload["sat"]["status"] == "closed"
    payload = {
        "schema": "full-schur-degree9-projective-emptiness-v1",
        "prime": 23,
        "quadratic_extension": "F_23[u]/(u^2-5)",
        "coefficient_dimension": 19,
        "quartic_coefficient_monomials": 7315,
        "degree36_invariant_dimension": 1157,
        "theorem": (
            "no nonzero degree-nine polynomial self-covariant over "
            "Q(zeta_11) lands identically on the Palatini quartic"
        ),
        "special_fibre_geometry": (
            "the projective landing locus in P^18 over algebraic closure of F_23 is empty"
        ),
        "local_source_sha256": {
            name: sha256(HERE / name) for name in local_sources
        },
        "external_source_sha256": {
            name: sha256(ROOT / name) for name in external_sources
        },
        "artifacts": {
            eigenlines.name: {
                "sha256": sha256(eigenlines),
                "record_count": 108,
            },
            clauses.name: {
                "sha256": sha256(clauses),
                "mandatory_rank": 8,
                "clause_count": 395,
                "exhausted_projective_lines": 3180,
            },
            result.name: {
                "semantic_sha256_ignoring_elapsed_seconds": semantic_sha256(
                    result, ("elapsed_seconds",)
                ),
                "sat_status": result_payload["sat"]["status"],
                "nodes": result_payload["sat"]["nodes"],
                "memoized_closed_states": result_payload["sat"]["memoized_closed_states"],
                "adaptive_state_count": result_payload["sat"]["adaptive_state_count"],
            },
        },
        "strict_scope": [
            "constant-coefficient degree-nine polynomial self-covariants only",
            "not arbitrary rational-function coefficients in the seven-frame Palatini equation",
            "not a K_Schur pointlessness theorem",
            "not either binary Q headline",
        ],
    }
    OUTPUT.write_text(json.dumps(payload, indent=2) + "\n")
    print(f"DEGREE9_CERTIFICATE_FROZEN sha256={sha256(OUTPUT)}")


if __name__ == "__main__":
    main()
