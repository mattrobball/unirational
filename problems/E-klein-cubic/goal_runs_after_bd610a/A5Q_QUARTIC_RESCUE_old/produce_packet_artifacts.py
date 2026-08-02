#!/usr/bin/env python3
"""Produce the manifest and class-specific A5Q index-eleven point records.

The large finite-field matrices are retained in ``modular_index11_discovery.json``.
This producer extracts the load-bearing witnesses without replacing that raw
record, and binds them to the exact fixed-field and characteristic-zero
straight-line formulas.
"""

from __future__ import annotations

from hashlib import sha256
import json
from pathlib import Path
import subprocess


HERE = Path(__file__).resolve().parent
PROBLEM = HERE.parents[1]
GOALS = PROBLEM / "goals_after_bd610a"

MODULAR = HERE / "modular_index11_discovery.json"
FIELD_PATHS = {
    1: HERE / "FIELD_L1.json",
    2: HERE / "FIELD_L2.json",
}
POINT_OUTPUTS = {
    1: HERE / "INDEX11_POINT_CLASS1.json",
    2: HERE / "INDEX11_POINT_CLASS2.json",
}

PINNED_STATE = "bd610a032bb9561d2daeb91a2cb60c48c082ca2f"


INPUT_SPECS = {
    "binding_goal": (
        GOALS / "GOAL_A5Q_INDEX11_QUARTIC_RESCUE.md",
        "authoritative work order",
    ),
    "director_review": (
        PROBLEM / "DIRECTOR_REVIEW_AFTER_BD610A.md",
        "post-pinned program boundary",
    ),
    "problem_spec": (PROBLEM / "SPEC.md", "Problem E theorem boundary"),
    "repair_status": (PROBLEM / "REPAIR.md", "current repair boundary"),
    "installed_subgroup_records": (
        PROBLEM
        / "goals_2026-08-01"
        / "H_SUBGROUP_TWISTS_ROOT_019FBE10"
        / "twists.json",
        "two installed maximal A5 classes and representation conventions",
    ),
    "a5_packet_seal": (
        PROBLEM / "goal_runs_after_35fa" / "H_A5_TWISTS" / "SEAL.json",
        "sealed exact A5 packet",
    ),
    "degree11_covariants": (
        PROBLEM
        / "goal_runs_after_35fa"
        / "H_A5_TWISTS"
        / "common"
        / "degree11_covariants_raw_exact.json",
        "exact Reynolds covariant coefficients",
    ),
    "a5_point_class_1": (
        PROBLEM
        / "goal_runs_after_35fa"
        / "H_A5_TWISTS"
        / "A5_class_1"
        / "point.json",
        "exact class-1 landing covariant",
    ),
    "a5_point_class_2": (
        PROBLEM
        / "goal_runs_after_35fa"
        / "H_A5_TWISTS"
        / "A5_class_2"
        / "point.json",
        "exact class-2 landing covariant",
    ),
    "a5_exact_landing_verifier": (
        PROBLEM
        / "goal_runs_after_35fa"
        / "H_A5_TWISTS"
        / "common"
        / "verify_exact_points_direct.py",
        "independent exact characteristic-zero landing replay",
    ),
    "schur_frame_seal": (
        PROBLEM
        / "goal_runs_after_35fa"
        / "Q_SCHUR_INDEX_ONE"
        / "exact_schur_frame"
        / "SEAL.json",
        "sealed authoritative Schur-frame packet",
    ),
    "schur_exact_frame": (
        PROBLEM
        / "goal_runs_after_35fa"
        / "Q_SCHUR_INDEX_ONE"
        / "exact_schur_frame"
        / "exact_frame.json",
        "exact full degree-eight Reynolds frame",
    ),
    "schur_representation_core": (
        PROBLEM
        / "goal_runs_after_35fa"
        / "Q_SCHUR_INDEX_ONE"
        / "exact_schur_frame"
        / "exact_representation_core.py",
        "exact Schur and Weil representation conventions",
    ),
    "schur_exact_frame_verifier": (
        PROBLEM
        / "goal_runs_after_35fa"
        / "Q_SCHUR_INDEX_ONE"
        / "exact_schur_frame"
        / "verify_exact_frame.py",
        "independent exact frame replay",
    ),
}


def digest(path: Path) -> str:
    return sha256(path.read_bytes()).hexdigest()


def relative(path: Path) -> str:
    return str(path.relative_to(PROBLEM))


def load_json(path: Path):
    with path.open() as handle:
        return json.load(handle)


def dump_json(path: Path, payload) -> None:
    path.write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n")


def class_runs(modular, class_index: int):
    label = f"A5_class_{class_index}"
    records = []
    for prime_record in modular["primes"]:
        matches = []
        for witness_run in prime_record["class_witness_runs"]:
            for class_record in witness_run["classes"]:
                if class_record["class"] == label:
                    matches.append((witness_run, class_record))
        assert len(matches) == 1, (label, prime_record["prime"], len(matches))
        witness_run, record = matches[0]
        records.append((prime_record, witness_run, record))
    return records


def modular_summary(prime_record, witness_run, record):
    coordinate_minor = record["coordinate_rank_minor"]
    product_minor = record["pairwise_product_rank_minor"]
    separation = record["projective_noncollision"]
    source_free = record["base_source_free_locus"]
    return {
        "prime": prime_record["prime"],
        "role": prime_record["role"],
        "zeta11": witness_run["zeta11"],
        "sqrt5": witness_run["sqrt5"],
        "sqrt_minus11_induced_by_zeta11": witness_run["sqrt_minus11"],
        "schur_vector_v0_through_v5": witness_run["integer_witness_reduced"],
        "selected_alpha": record["selected_alpha"],
        "input_denominators": {
            "covariant_basis": witness_run[
                "degree11_covariant_input_denominators"
            ],
            "point_packet": record["point_input_denominators"],
        },
        "nonzero_determinants": {
            "full_schur_frame_Q": witness_run[
                "full_schur_frame_determinant"
            ],
            "source_reynolds_frame_B": record[
                "base_quartic_frame_determinant"
            ],
            "canonical_to_installed_intertwiner_J": record[
                "intertwiner_determinant"
            ],
        },
        "source_projective_stabilizer_order": source_free[
            "projective_stabilizer_order"
        ],
        "source_nonidentity_stabilizer_checks": source_free[
            "nonidentity_checks"
        ],
        "all_60_H_invariance_checks": record[
            "all_60_H_invariance_checks"
        ],
        "all_11_cubic_landings": record[
            "all_11_canonical_and_installed_cubic_landings"
        ],
        "projective_conjugate_count": 11,
        "projective_noncollision_pair_count": separation["pair_count"],
        "all_projectively_distinct": separation[
            "all_projectively_distinct"
        ],
        "coordinate_rank": record["coordinate_rank"],
        "coordinate_rank_minor": coordinate_minor,
        "pairwise_product_rank": record["pairwise_product_rank"],
        "pairwise_product_rank_minor": product_minor,
        "raw_matrix_record": {
            "path": "modular_index11_discovery.json",
            "selector": (
                f"primes[prime={prime_record['prime']}].class_witness_runs"
                f"[].classes[class={record['class']}]"
            ),
        },
    }


def make_point_payload(class_index: int, modular, field):
    label = f"A5_class_{class_index}"
    runs = [
        modular_summary(prime_record, witness_run, record)
        for prime_record, witness_run, record in class_runs(modular, class_index)
    ]
    assert all(run["coordinate_rank"] == 5 for run in runs)
    assert all(run["pairwise_product_rank"] == 11 for run in runs)
    assert all(run["all_projectively_distinct"] for run in runs)
    assert all(run["all_11_cubic_landings"] for run in runs)
    assert all(run["all_60_H_invariance_checks"] for run in runs)

    return {
        "format": "a5q-exact-index11-transported-point-v1",
        "class": label,
        "scope": {
            "proved": (
                f"an exact reduced degree-11 closed point Z_{class_index} on "
                "the authoritative full Schur twist and emptiness of the "
                "degree-four interpolation incidence for this point"
            ),
            "not_proved": [
                "a K-rational residual point",
                "a rational curve on the twist",
                "pointlessness of the full twist",
                "a positive or negative Problem E headline",
            ],
        },
        "fixed_field": {
            "definition": f"L_{class_index}=E^H_{class_index}",
            "degree_over_K": 11,
            "primitive_element": field["primitive_element"],
            "exact_resolvent": field["exact_resolvent"],
            "field_certificate": f"FIELD_L{class_index}.json",
        },
        "exact_transport": {
            "source_frame": (
                f"B_{class_index}(v)=sum_(h in H_{class_index}) "
                f"sigma_{class_index}(h)^(-1)*((rho6(h)v)_5)^4"
            ),
            "source_point": f"Y_{class_index}(v)=B_{class_index}(v)e_0",
            "landing_covariant": (
                f"Phi_{class_index} from "
                f"goal_runs_after_35fa/H_A5_TWISTS/{label}/point.json"
            ),
            "installed_point_upstairs": (
                f"x_{class_index}(v)=J_{class_index}"
                f"*Phi_{class_index}(Y_{class_index}(v))"
            ),
            "full_schur_frame": (
                "Q(v)=sum_(g in G) rho5(g)^(-1)*((rho6(g)v)_5)^8"
            ),
            "descended_point": (
                f"P_{class_index}(v)=Q(v)^(-1)x_{class_index}(v)"
            ),
            "H_invariance": (
                f"P_{class_index}(rho6(h)v)=P_{class_index}(v) for "
                f"all h in H_{class_index}"
            ),
            "authoritative_equation": "F(Q(v)P(v))=0",
            "klein_cubic": "F(x)=sum_(j mod 5) x_j^2*x_(j+1)",
            "exact_identity_source": (
                "the upstream exact polynomial landing identity for Phi, "
                "followed by the exact intertwiner J and exact Schur frame Q"
            ),
            "coordinate_representation": (
                "the displayed straight-line rational-function circuit; "
                "power-basis coordinates are obtained by the certified "
                "11-by-11 Vandermonde solve in FIELD_Li.json"
            ),
        },
        "conjugate_closed_point": {
            "conjugates": (
                f"P_{class_index}(rho6(g)v), one for each left coset "
                f"H_{class_index}*g in H_{class_index}\\G"
            ),
            "orbit_size": 11,
            "residue_field": f"L_{class_index}",
            "reduced_reason": "L_i/K is separable in characteristic zero",
            "effective_closed_subscheme": f"Z_{class_index}=Spec(L_{class_index}) -> X_T",
        },
        "multiplication_trace_norm_interface": field["power_basis_interface"],
        "modular_nonzero_minor_certificates": runs,
        "characteristic_zero_lift": {
            "coordinate_span_dimension": 5,
            "pairwise_product_span_dimension": 11,
            "argument": (
                "each stored nonzero minor is the good reduction of a minor "
                "of the exact straight-line matrix, hence that characteristic-"
                "zero minor is nonzero; row counts give the matching upper bounds"
            ),
            "reference": "CHARACTERISTIC_ZERO_LIFT.md",
        },
        "degree_four_incidence": {
            "necessary_dimension_for_quartic_interpolation": 9,
            "actual_dimension": 11,
            "empty": True,
            "reference": "INTERPOLATION_INCIDENCE.md",
            "exit": "A5Q-DEGREE4-RESCUE-EMPTY-SCOPED",
        },
        "markers": [
            "A5Q_INDEX11_CLOSED_POINT_OK",
            "A5Q-INDEX11-CLOSED-POINT-PASS",
            "A5Q-DEGREE4-RESCUE-EMPTY-SCOPED",
        ],
    }


def make_manifest():
    entries = {}
    for name, (path, role) in INPUT_SPECS.items():
        assert path.is_file(), path
        entries[name] = {
            "path_relative_to_problem": relative(path),
            "sha256": digest(path),
            "bytes": path.stat().st_size,
            "role": role,
        }
    try:
        actual_head = subprocess.check_output(
            ["git", "rev-parse", "HEAD"], cwd=PROBLEM, text=True
        ).strip()
    except (OSError, subprocess.CalledProcessError):
        actual_head = "unavailable"
    return {
        "format": "a5q-input-manifest-v1",
        "binding_goal": "goals_after_bd610a/GOAL_A5Q_INDEX11_QUARTIC_RESCUE.md",
        "pinned_state": PINNED_STATE,
        "actual_head_at_production": actual_head,
        "provenance_note": (
            "The work order pins bd610a and explicitly consumes post-pinned "
            "immutable packets. Every load-bearing consumed file is bound by "
            "content hash; unrelated worktree state is outside this packet."
        ),
        "inputs": entries,
    }


def main():
    modular = load_json(MODULAR)
    assert modular["terminal_marker"] == "A5Q_MODULAR_INDEX11_DISCOVERY_REPLAY_OK"
    for class_index in (1, 2):
        field = load_json(FIELD_PATHS[class_index])
        assert field["class"] == f"A5_class_{class_index}"
        dump_json(
            POINT_OUTPUTS[class_index],
            make_point_payload(class_index, modular, field),
        )
    dump_json(HERE / "INPUT_MANIFEST.json", make_manifest())
    print("A5Q_PACKET_ARTIFACTS_PRODUCED")


if __name__ == "__main__":
    main()
