#!/usr/bin/env python3
"""Exact Hilbert-series ranking for the selected structured degrees."""

from __future__ import annotations

import json
from pathlib import Path


HERE = Path(__file__).resolve().parent
HSOP = (3, 5, 6, 8, 11)
COV_NUMERATOR = {
    1: 1, 4: 1, 5: 1, 6: 1, 7: 1, 8: 4, 9: 2, 10: 4,
    11: 4, 12: 5, 13: 4, 14: 5, 15: 5, 16: 3, 17: 4,
    18: 3, 19: 3, 20: 2, 21: 2, 22: 2, 23: 1, 24: 1, 26: 1,
}
INV_NUMERATOR = {
    0: 1, 7: 1, 9: 1, 10: 1, 12: 1, 14: 2,
    16: 1, 18: 1, 19: 1, 21: 1, 28: 1,
}
SELECTED = (25, 31, 35)


def denominator_coefficients(maximum: int):
    values = [0] * (maximum + 1)
    values[0] = 1
    for weight in HSOP:
        for degree in range(weight, maximum + 1):
            values[degree] += values[degree - weight]
    return values


def coefficient(numerator, degree: int, denominator):
    return sum(
        multiplicity * denominator[degree - shift]
        for shift, multiplicity in numerator.items()
        if shift <= degree
    )


def residuals(degree: int):
    return [
        {"plane_order_m": order, "residual_e": degree - 6 * order}
        for order in range(1, degree // 6 + 1, 2)
        if degree - 6 * order >= 1
    ]


def main() -> None:
    maximum = 3 * max(SELECTED)
    denominator = denominator_coefficients(maximum)
    modules = json.loads((HERE / "global_modules_summary.json").read_text())
    ansatze = json.loads((HERE / "ansatz_summary.json").read_text())
    crosses = json.loads((HERE / "cross_ansatz_summary.json").read_text())
    combined = json.loads((HERE / "combined_ansatz_summary.json").read_text())
    degrees = []
    for degree in SELECTED:
        modular = modules[str(degree)]["prime_results"]
        assert len({record["arrangement_kernel_dimension"] for record in modular}) == 1
        assert len({record["strict_dimension"] for record in modular}) == 1
        ansatz = ansatze[str(degree)]
        cross = crosses[str(degree)]
        mixed = combined[str(degree)]
        degrees.append(
            {
                "degree": degree,
                "self_covariants": coefficient(COV_NUMERATOR, degree, denominator),
                "scalar_invariants": coefficient(INV_NUMERATOR, degree, denominator),
                "landing_target_invariants_degree_3d": coefficient(
                    INV_NUMERATOR, 3 * degree, denominator
                ),
                "hsop_secondary_covariants_born_in_degree": COV_NUMERATOR.get(degree, 0),
                "residual_classes": residuals(degree),
                "arrangement_dimension_good_fibres": modular[0]["arrangement_kernel_dimension"],
                "common_order2_rank_good_fibres": modular[0]["common_order2_rank_on_arrangement"],
                "strict_dimension_good_fibres": modular[0]["strict_dimension"],
                "plane_order_at_least_3_dimensions": [
                    record["plane_order_at_least_3_dimension"] for record in modular
                ],
                "plane_order_at_least_3_char0": "excluded_by_integral_good_fibre_injectivity",
                "agreement_primes": [record["prime"] for record in modular],
                "composition_ansatz_dimension": ansatz["direction_count"],
                "composition_ansatz_symmetric_cube": ansatz["symmetric_cube_dimension"],
                "composition_ansatz_cubic_ranks": [
                    record["rank"] for record in ansatz["prime_records"]
                ],
                "composition_ansatz_quartic_closure": [
                    None if record["quartic_closure"] is None
                    else record["quartic_closure"]["rank"]
                    for record in ansatz["prime_records"]
                ],
                "composition_ansatz_char0": ansatz["characteristic_zero_conclusion"],
                "cross_ansatz_dimension": cross["direction_count"],
                "cross_ansatz_cubic_ranks": [
                    record["rank"] for record in cross["prime_records"]
                ],
                "cross_ansatz_primes": [
                    record["prime"] for record in cross["prime_records"]
                ],
                "cross_ansatz_char0": cross["characteristic_zero_conclusion"],
                "combined_ansatz_dimension": mixed["direction_count"],
                "combined_ansatz_cubic_ranks": [
                    record["landing_rank"] for record in mixed["prime_records"]
                ],
                "combined_ansatz_cubic_coranks": [
                    mixed["symmetric_cube_dimension"] - record["landing_rank"]
                    for record in mixed["prime_records"]
                ],
                "combined_ansatz_quartic_dual_nullities": [
                    record["quartic_dual_nullity"] for record in mixed["prime_records"]
                ],
                "combined_ansatz_primes": [
                    record["prime"] for record in mixed["prime_records"]
                ],
                "combined_ansatz_char0": mixed["characteristic_zero_conclusion"],
            }
        )

    # Ranking balances the first residual representative with system size.
    # Degree 31 is the first unresolved e=1 class; 35 is the first unresolved
    # e=5 class; 25 is the first unrestricted e>=7 class and already has a
    # dedicated, substantially deeper support route.
    ranking = [31, 35, 25]
    payload = {
        "hsop_degrees": list(HSOP),
        "covariant_hsop_numerator": COV_NUMERATOR,
        "invariant_hsop_numerator": INV_NUMERATOR,
        "selected_degrees": degrees,
        "ranking": ranking,
        "ranking_reason": {
            "31": "first unresolved residual e=1 representative; smaller strict module than degree 35",
            "35": "first unresolved residual e=5 representative; favorable new residual class despite larger module",
            "25": "first unrestricted residual e>=7 representative; smallest module, but its dedicated exact support route is already unresolved after much stronger work",
        },
        "primitive_note": (
            "The Hironaka numerator has no new A-secondary in degrees 25,31,35 "
            "(the last occurs in degree 26). This is not a proof that every "
            "map has a common invariant factor: sums of invariant multiples "
            "need not share a factor. It is used only as a composition/module "
            "ranking datum."
        ),
        "scope_note": (
            "Arrangement and strict dimensions are exact in both displayed "
            "good fibres. Their agreement is ranking evidence, not by itself "
            "a characteristic-zero kernel reconstruction. In contrast, zero "
            "higher normal-jet kernel in either integral good fibre does "
            "exclude a characteristic-zero order-at-least-three covariant."
        ),
    }
    (HERE / "degree_ranking.json").write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n")
    print(json.dumps(payload, sort_keys=True))
    print("COV_DEGREE_RANKING_PRODUCED")


if __name__ == "__main__":
    main()
