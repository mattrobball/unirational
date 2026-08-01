#!/usr/bin/env python3
"""Produce the exact finite payload for Goal J2."""

from __future__ import annotations

import hashlib
import json
from pathlib import Path


HERE = Path(__file__).resolve().parent
PROBLEM = HERE.parent.parent
GOAL_ROOT = PROBLEM / "goals_2026-08-01"

SOURCES = {
    "certificates/LOCAL_TRANSITION_MODULES.md": PROBLEM / "certificates/LOCAL_TRANSITION_MODULES.md",
    "certificates/strata/normal_characters.json": PROBLEM / "certificates/strata/normal_characters.json",
    "certificates/hodge_centers/character_screen.json": PROBLEM / "certificates/hodge_centers/character_screen.json",
    "goals_2026-08-01/G_ALL_DEGREE/FIRST_GATE.md": GOAL_ROOT / "G_ALL_DEGREE/FIRST_GATE.md",
    "goals_2026-08-01/D_EQUIVARIANT_MOTIVE/invariants.json": GOAL_ROOT / "D_EQUIVARIANT_MOTIVE/invariants.json",
    "goals_2026-08-01/J_FIXED_CENTRE_PRYM/payload.json": GOAL_ROOT / "J_FIXED_CENTRE_PRYM/payload.json",
    "goals_after_35fa8f/GOAL_J2_BASELOCUS_CONSTRAINED_PRYM.md": PROBLEM / "goals_after_35fa8f/GOAL_J2_BASELOCUS_CONSTRAINED_PRYM.md",
}


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def body_hash(data: dict) -> str:
    raw = json.dumps(data, sort_keys=True, separators=(",", ":")).encode()
    return hashlib.sha256(raw).hexdigest()


def main() -> None:
    normal = json.loads(SOURCES["certificates/strata/normal_characters.json"].read_text())
    screen = json.loads(SOURCES["certificates/hodge_centers/character_screen.json"].read_text())
    prior_j = json.loads(SOURCES["goals_2026-08-01/J_FIXED_CENTRE_PRYM/payload.json"].read_text())
    prior_d = json.loads(SOURCES["goals_2026-08-01/D_EQUIVARIANT_MOTIVE/invariants.json"].read_text())

    plane = normal["strata"]["C2_plane"]
    rows = {row["H_label"]: row for row in screen["subgroup_screen"]}

    group_order = prior_d["group"]["order"]
    stabilizer_order = plane["generic_stabilizer_H"]["order"]
    normalizer_order = plane["setwise_stabilizer_N"]["order"]
    orbit_size = group_order // stabilizer_order
    fixed_components = normalizer_order // stabilizer_order

    quintic_genus = 6
    prym_cover_genus = 2 * quintic_genus - 1
    degree_on_prym = 3
    degree_on_elliptic = 24
    curve_genus = 1 + degree_on_prym * (degree_on_elliptic + prym_cover_genus - 1)
    curve_h1_rank = 2 * curve_genus
    plane_model_degree = 2 * curve_genus + 1

    target_rank = prior_d["target"]["H3_rank"]
    c2_h21_invariants = rows["C2"]["restriction_H21_multiplicities"][0]
    c2_target_invariants = 2 * c2_h21_invariants
    averaging_scalar = orbit_size * c2_target_invariants // target_rank

    payload = {
        "schema": "J_BASELOCUS_PRYM.v1",
        "packet": "J_BASELOCUS_PRYM",
        "exit": "J2-UNRESTRICTED-COUNTERMODEL-EXTENDS",
        "overall_problem_headline": "OPEN",
        "pinned_state": "35fa8f59b6a1423cc89300aeaceefe91552be5ba",
        "consumed_repository_head": "37d61c19a108781cf74af837e24810a9f7f7c3be",
        "source_sha256": {name: sha256(path) for name, path in SOURCES.items()},
        "forced_base": {
            "stratum": "P(E_+(t)) = P^2",
            "all_55_planes_based": True,
            "symbolic_order": "m",
            "symbolic_order_parity": "odd",
            "ideal_chain": "I_p subset I_Pt^(m) = I_Pt^m subset I_Cbar^m",
            "generic_centre_order": "m",
            "covariant_changed": False,
            "primitive_minimality_changed": False,
        },
        "centre_curve": {
            "surface": "Prym_cover x E_t",
            "line_bundle_bidegrees": [degree_on_elliptic, degree_on_prym],
            "genus": curve_genus,
            "H1_rank": curve_h1_rank,
            "degree_to_prym_cover": degree_on_prym,
            "degree_to_fixed_elliptic": degree_on_elliptic,
            "plane_model_degree": plane_model_degree,
            "normalization_genus": curve_genus,
            "contains_target_prym_factor": True,
            "contains_fixed_elliptic_factor": True,
        },
        "orbit": {
            "group_order": group_order,
            "component_stabilizer": "C2",
            "component_stabilizer_order": stabilizer_order,
            "orbit_components": orbit_size,
            "normalizer": "D12",
            "normalizer_order": normalizer_order,
            "residual": "S3",
            "residual_order": fixed_components,
            "components_fixed_by_selected_involution": fixed_components,
            "fixed_component_permutation_character": [6, 0, 0],
            "fixed_component_decomposition": {"trivial": 1, "sign": 1, "standard": 2},
        },
        "normal_slice": {
            "plus_eigenrank": 1,
            "minus_eigenrank": plane["normal_bundle_fiber_as_H_module"]["rank"],
            "fixed_exceptional_fibres": ["P^0", "P^1"],
            "both_pic0_alb_equal_base_curve": True,
        },
        "hodge_prym_split": {
            "target_rank": target_rank,
            "C2_target_invariant_rank": c2_target_invariants,
            "induced_centre_H1_rank": orbit_size * curve_h1_rank,
            "averaging_scalar": averaging_scalar,
            "safe_localization": "Z[1/198]",
            "integral_injection_after_clearing_denominators": True,
            "primitive_integral_direct_factor_claimed": False,
            "integral_principal_polarization_claimed": False,
            "polarization_strength": "positive rational scalar",
            "CM_field": "Q(sqrt(-11))",
        },
        "fixed_one_motive": {
            "affine_class_group": prior_j["affine_S3_class"]["H1_isomorphism"],
            "affine_class_order": prior_j["affine_S3_class"]["selected_class_order"],
            "elliptic_map_degree": degree_on_elliptic,
            "degree_divisible_by_3": degree_on_elliptic % 3 == 0,
            "regular_S3_components_carry_affine_quotient": True,
            "resolution_invariant": False,
            "fixed_locus_dominance_forced": False,
        },
        "coefficient_coupling": {
            "new_F_of_p_equations": 0,
            "transition_divisors_changed": False,
            "point_link_multiplicities_changed": False,
            "plane_order_changed": False,
            "reason": "the source blowup tower changes but p does not",
        },
        "route_audit": {
            "ordinary_equivariant_log_resolutions_excluded": False,
            "canonical_minimal_principalization_supplied": False,
            "centre_inventory_invariant_under_refinement": False,
            "landing_covariant_constructed": False,
            "landing_covariant_refuted": False,
            "logical_conclusion": "base-locus Prym centre data do not obstruct all equivariant resolutions",
        },
    }
    payload["self_sha256"] = body_hash(payload)
    (HERE / "payload.json").write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n")
    print("J_BASELOCUS_PRYM_PRODUCE_OK")


if __name__ == "__main__":
    main()
