#!/usr/bin/env python3
"""Produce exact arithmetic for the Goal D2 bridge audit."""

from __future__ import annotations

import json
from math import gcd
from pathlib import Path


ROOT = Path(__file__).resolve().parent
OUT = ROOT / "invariant_payload.json"


def egcd_inverse(a: int, modulus: int) -> int:
    return pow(a, -1, modulus)


def crt_idempotents(moduli: list[int]) -> list[int]:
    total = 1
    for modulus in moduli:
        total *= modulus
    result = []
    for modulus in moduli:
        quotient = total // modulus
        result.append((quotient * egcd_inverse(quotient % modulus, modulus)) % total)
    return result


def payload() -> dict:
    group_order = 11 * (11**2 - 1) // 2
    primes = [2, 3, 5, 11]
    sylow_orders = [4, 3, 5, 11]
    sylow_indices = [group_order // value for value in sylow_orders]
    primary_moduli = sylow_orders
    idempotents = crt_idempotents(primary_moduli)
    inverses = [egcd_inverse(index % modulus, modulus) for index, modulus in zip(sylow_indices, primary_moduli)]

    cycle_degrees = [60, 132, 165, 220]
    cycle_coefficients = [-13, 3, 1, 1]

    candidates = [
        {
            "name": "additive_torsion_mackey_stack_class",
            "d2_requirements_failed": [5],
            "verdict": "zero_by_sylow_detection",
        },
        {
            "name": "mod_p_equivariant_motive_extension",
            "d2_requirements_failed": [2, 4],
            "verdict": "no_multiplier_independent_retraction",
        },
        {
            "name": "stack_steenrod_power_operation",
            "d2_requirements_failed": [3, 4, 5],
            "verdict": "no_blowup_stable_injective_bridge",
        },
        {
            "name": "integral_polarized_G_lattice",
            "d2_requirements_failed": [4],
            "verdict": "uncontrolled_similitude_multiplier",
        },
        {
            "name": "admissible_centre_cobordism_quotient",
            "d2_requirements_failed": [2, 3],
            "verdict": "all_degree_centre_theorem_missing",
        },
        {
            "name": "canonical_essential_dimension",
            "d2_requirements_failed": [],
            "precondition_failed": "genuinely_new_invariant",
            "verdict": "tautological_restates_headline",
        },
        {
            "name": "nonabelian_mixed_descent",
            "d2_requirements_failed": [1, 2, 3, 4, 5],
            "verdict": "no_defined_candidate",
        },
    ]

    return {
        "schema": "D2_STACK_INVARIANT.v1",
        "exit": "D2-NO-VALID-BRIDGE",
        "headline_problem": "OPEN",
        "repository": {
            "pinned_state": "35fa8f59b6a1423cc89300aeaceefe91552be5ba",
            "consumed_commit": "37d61c19a108781cf74af837e24810a9f7f7c3be",
            "goal_d_commit": "fc4e4900c70101d27ae5facef3bf6a706bdb9e11",
            "produced_commit": None,
        },
        "group": {
            "name": "PSL(2,11)",
            "order": group_order,
            "primes": primes,
            "sylow_orders": sylow_orders,
            "sylow_indices": sylow_indices,
            "all_sylow_fixed_points": True,
        },
        "crt": {
            "primary_moduli": primary_moduli,
            "idempotents_mod_660": idempotents,
            "idempotent_sum_mod_660": sum(idempotents) % group_order,
        },
        "sylow_detection": {
            "indices": sylow_indices,
            "inverse_mod_primary_part": inverses,
            "restriction_zero_implies_global_primary_zero": True,
        },
        "index_one": {
            "cycle_degrees": cycle_degrees,
            "bezout_coefficients": cycle_coefficients,
            "bezout_value": sum(a * b for a, b in zip(cycle_coefficients, cycle_degrees)),
            "gcd": gcd(gcd(gcd(*cycle_degrees[:2]), cycle_degrees[2]), cycle_degrees[3]),
        },
        "multisection_countermodel": {
            "realized_multipliers": [1, 2, 3, 5, 11, 660],
            "identity": "f_*(c1(O_P1(n))*f^*(-))=n*(-)",
            "target_H3_rank": 10,
            "polarization_discriminant_scaling_exponent": 10,
        },
        "free_orbit_test": {
            "component_stabilizer_order": 1,
            "orbit_components": group_order,
            "quotient_stack": "[coprod_g gC / G] = C",
            "declared_admissible_base_locus": False,
        },
        "candidates": candidates,
        "valid_new_bridge_found": False,
    }


def main() -> None:
    OUT.write_text(json.dumps(payload(), indent=2, sort_keys=True) + "\n", encoding="utf-8")
    print("D2_STACK_INVARIANT_PRODUCE_OK")


if __name__ == "__main__":
    main()
