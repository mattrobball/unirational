#!/usr/bin/env python3
"""Measure the new degree-three content beyond branch-A quadrics."""

from __future__ import annotations

import itertools
from pathlib import Path

import numpy as np

from probe_cubic_scalar_cubes import cube_coefficients
from produce_canonical_bases import rank_profile
from verify_all import rank_mod_ffpack_int32


HERE = Path(__file__).resolve().parent
PRIME = 463
VARIABLES = 51


def main() -> None:
    with np.load(
        HERE / "p25_branch_a_quadratic_span_p463.npz",
        allow_pickle=False,
    ) as frozen:
        quadratic = frozen["quadratic_coefficient_matrix"].astype(np.int64)
        quadratic_monomials = frozen["quadratic_monomials"].astype(np.int64)
    rows = rank_profile("RowRankProfile_modular_double", quadratic, PRIME)
    assert len(rows) == 29
    quadratic = quadratic[rows].astype(np.uint16)
    with np.load(
        HERE / "p25_branch_a_cubic_span_p463.npz",
        allow_pickle=False,
    ) as frozen:
        cubic_monomials = frozen["cubic_monomials"].astype(np.int64)
        cubic = frozen["independent_cubic_coefficients"].astype(np.uint16)
    with np.load(
        HERE / "p25_common_nonbased_branches_p463.npz",
        allow_pickle=False,
    ) as frozen:
        scalar_forms = frozen["branch_A_scalar_forms"].astype(np.int64)

    lookup = {
        tuple(map(int, monomial)): index
        for index, monomial in enumerate(cubic_monomials)
    }
    multiplication = np.empty(
        (VARIABLES, len(quadratic_monomials)), dtype=np.int64
    )
    for variable in range(VARIABLES):
        multiplication[variable] = [
            lookup[tuple(sorted((int(left), int(right), variable)))]
            for left, right in quadratic_monomials
        ]
    products = np.zeros(
        (len(quadratic) * VARIABLES, len(cubic_monomials)),
        dtype=np.uint16,
    )
    for row, coefficients in enumerate(quadratic):
        for variable in range(VARIABLES):
            products[row * VARIABLES + variable, multiplication[variable]] = (
                coefficients
            )
    print(f"quadratic multiples: {products.shape}", flush=True)
    product_rank = rank_mod_ffpack_int32(products, PRIME)
    print(f"quadratic-multiple rank: {product_rank}", flush=True)
    union = np.vstack([products, cubic])
    union_rank = rank_mod_ffpack_int32(union, PRIME)
    print(
        f"degree-three union rank: {union_rank}; "
        f"new cubic quotient rank: {union_rank - product_rank}",
        flush=True,
    )
    scalar_cubes = cube_coefficients(
        scalar_forms, cubic_monomials, PRIME
    )
    target_union_rank = rank_mod_ffpack_int32(
        np.vstack([union, scalar_cubes]), PRIME
    )
    individual = [
        rank_mod_ffpack_int32(np.vstack([union, cube]), PRIME)
        for cube in scalar_cubes
    ]
    print(
        f"scalar-cube augmented ranks: {individual}; "
        f"joint={target_union_rank}",
        flush=True,
    )


if __name__ == "__main__":
    main()
