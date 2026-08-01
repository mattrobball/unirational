#!/usr/bin/env python3
"""Produce the exact Molien/Hironaka degree ranking and scope ledger."""

from __future__ import annotations

import hashlib
import json
import math
from pathlib import Path


HERE = Path(__file__).resolve().parent
PROBLEM = HERE.parents[1]
PRIMARY_DEGREES = (3, 5, 6, 8, 11)
SELECTED = (25, 31, 35)
COV_NUMERATOR = {
    1: 1, 4: 1, 5: 1, 6: 1, 7: 1, 8: 4, 9: 2, 10: 4,
    11: 4, 12: 5, 13: 4, 14: 5, 15: 5, 16: 3, 17: 4,
    18: 3, 19: 3, 20: 2, 21: 2, 22: 2, 23: 1, 24: 1, 26: 1,
}
INV_NUMERATOR = {
    0: 1, 7: 1, 9: 1, 10: 1, 12: 1, 14: 2,
    16: 1, 18: 1, 19: 1, 21: 1, 28: 1,
}


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def normalization_series(limit: int) -> list[int]:
    values = [0] * (limit + 1)
    values[0] = 1
    for degree in PRIMARY_DEGREES:
        for index in range(degree, limit + 1):
            values[index] += values[index - degree]
    return values


def module_series(numerator: dict[int, int], limit: int) -> list[int]:
    base = normalization_series(limit)
    return [
        sum(coefficient * base[degree - shift] for shift, coefficient in numerator.items() if shift <= degree)
        for degree in range(limit + 1)
    ]


def weighted_monomial_count(degree: int) -> int:
    return normalization_series(degree)[degree]


def arrangement_scope(degree: int) -> dict:
    p67 = json.loads((HERE / f"degree_{degree}" / "global_jets_p67.json").read_text())
    p89 = json.loads((HERE / f"degree_{degree}" / "global_jets_p89.json").read_text())
    assert p67["orders"] == p89["orders"]
    assert p67["selected_symbolic_kernel_dimension"] == 0
    assert p89["selected_symbolic_kernel_dimension"] == 0
    record = {
        "characteristic_zero_self_covariant_basis": True,
        "basis_circuit": f"degree_{degree}/covariant_basis_seeds.json",
        "basis_dimension": p67["self_covariant_dimension"],
        "basis_rank_split_F67": p67["basis_rank"],
        "basis_rank_holdout_F89": p89["basis_rank"],
        "selected_plane_order": p67["plane_order"],
        "selected_residual_degree": p67["residual_degree"],
        "jet_filtration_split_F67": p67["orders"],
        "jet_filtration_holdout_F89": p89["orders"],
        "selected_symbolic_kernel_characteristic_zero": 0,
        "primitive_quotient_dimension": 0,
        "landing_equation_count_after_linear_constraints": 0,
        "proof": (
            "the stacked order-0,1,2 Taylor matrix has full column rank modulo 89; "
            "therefore its exact characteristic-zero Reynolds-lattice matrix is injective"
        ),
        "scope": "every odd plane order m>=3 in this degree; plane order m=1 is not excluded",
    }
    if degree == 25:
        record["lower_order_live_space"] = {
            "plane_order": 1,
            "plus_plane_kernel_characteristic_zero": 59,
            "strict_common_line_kernel_characteristic_zero": 43,
            "landing_status": "open in the separate degree-25 support route",
        }
    else:
        record["lower_order_live_space"] = {
            "plane_order": 1,
            "plus_plane_kernel_split_F67_and_F89": p67["orders"][0]["kernel_dimension"],
            "characteristic_zero_intermediate_dimension": "not asserted",
            "landing_status": "not searched as a complete module in this packet",
        }
    return record


def main() -> None:
    limit = 3 * max(SELECTED)
    covariants = module_series(COV_NUMERATOR, limit)
    invariants = module_series(INV_NUMERATOR, limit)
    assert (covariants[25], covariants[31], covariants[35]) == (189, 410, 637)
    assert (invariants[25], invariants[31], invariants[35]) == (43, 89, 139)
    assert sum(COV_NUMERATOR.values()) == 60
    assert sum(INV_NUMERATOR.values()) == 12

    records = []
    for degree in SELECTED:
        orders = [
            {
                "m": order,
                "e": degree - 6 * order,
                "global_coefficient_status": (
                    "live lower-order branch" if order == 1
                    else "zero in characteristic zero by the full-rank p=89 Taylor minor"
                ),
            }
            for order in range(1, degree // 6 + 1, 2)
            if degree - 6 * order >= 1
        ]
        records.append(
            {
                "degree": degree,
                "priority": {25: 1, 31: 2, 35: 3}[degree],
                "selected_residual_class": {25: "e>=7", 31: "e=1", 35: "e=5"}[degree],
                "admissible_odd_orders": orders,
                "self_covariant_dimension": covariants[degree],
                "invariant_dimension": invariants[degree],
                "landing_target_invariant_dimension": invariants[3 * degree],
                "full_landing_parameter_cubics": math.comb(covariants[degree] + 2, 3),
                "known_quartic_precomposition": False,
                "known_quartic_reason": "degree is not divisible by four",
                "primary_frame_option_counts": [
                    weighted_monomial_count(degree - frame_degree)
                    for frame_degree in (1, 4, 5, 6, 7)
                ],
                "arrangement_scope": arrangement_scope(degree),
            }
        )

    source = PROBLEM / "certificates/exact_molien.py"
    payload = {
        "schema": "COV_DEGREE_RANKING_V1",
        "primary_degrees": list(PRIMARY_DEGREES),
        "covariant_hsop_numerator": COV_NUMERATOR,
        "invariant_hsop_numerator": INV_NUMERATOR,
        "source_exact_molien_sha256": sha256(source),
        "ranking": records,
        "decision": (
            "25 first as the first unresolved e>=7 representative, 31 next as the first "
            "unresolved e=1 representative, and 35 next as the first unresolved e=5 "
            "representative.  Exact Reynolds bases exist in all three degrees.  The selected "
            "m>=3 global coefficient modules are zero in characteristic zero; m=1 remains live."
        ),
    }
    out = HERE / "degree_ranking.json"
    out.write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n")

    lines = [
        "# Degree ranking",
        "",
        "The exact Hironaka/Molien dimensions and current arrangement scope are:",
        "",
        "| priority | d | class | covariants | invariants | landing invariant target | arrangement status |",
        "|---:|---:|---|---:|---:|---:|---|",
    ]
    for record in records:
        scope = record["arrangement_scope"]
        filtration = " -> ".join(
            str(item["kernel_dimension"]) for item in scope["jet_filtration_holdout_F89"]
        )
        status = (
            f"char-0 basis {scope['basis_dimension']}; selected m={scope['selected_plane_order']} "
            f"kernel 0 (holdout filtration {filtration})"
        )
        lines.append(
            f"| {record['priority']} | {record['degree']} | {record['selected_residual_class']} | "
            f"{record['self_covariant_dimension']} | {record['invariant_dimension']} | "
            f"{record['landing_target_invariant_dimension']} | {status} |"
        )
    lines.extend(
        [
            "",
            "The zero conclusions are characteristic-zero: full column rank of the exact stacked Taylor matrix after reduction modulo 89 supplies a nonzero maximal minor.  The matching split-67 ranks are discovery and cross-check data, not the lifting argument.",
            "",
            "In all three degrees the same third-normal-coefficient map is already injective, so every odd plane order `m>=3` is absent.  The `m=1` branches remain live and are outside the scoped empty-family exit.",
            "",
        ]
    )
    (HERE / "DEGREE_RANKING.md").write_text("\n".join(lines))
    print(f"degree_ranking_sha256={sha256(out)}")
    print("COV_DEGREE_RANKING_PRODUCED")


if __name__ == "__main__":
    main()
