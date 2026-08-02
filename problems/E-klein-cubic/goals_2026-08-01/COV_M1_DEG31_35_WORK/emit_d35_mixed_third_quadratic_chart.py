#!/usr/bin/env python3
"""Emit an exact Singular chart for the 39D mixed-third quadratic system."""

from __future__ import annotations

import argparse
from pathlib import Path

import numpy as np


HERE = Path(__file__).resolve().parent
PRIME = 463
VARIABLES = 39


def row_basis_indices(matrix: np.ndarray, prime: int):
    value = np.asarray(matrix, dtype=np.int64).copy() % prime
    row_ids = np.arange(len(value))
    pivot_row = 0
    for column in range(value.shape[1]):
        candidates = np.flatnonzero(value[pivot_row:, column])
        if not len(candidates):
            continue
        source = pivot_row + int(candidates[0])
        value[[pivot_row, source]] = value[[source, pivot_row]]
        row_ids[[pivot_row, source]] = row_ids[[source, pivot_row]]
        value[pivot_row] = (
            value[pivot_row]
            * pow(int(value[pivot_row, column]), -1, prime)
        ) % prime
        factors = value[pivot_row + 1:, column].copy()
        nonzero = np.flatnonzero(factors)
        if len(nonzero):
            rows = pivot_row + 1 + nonzero
            value[rows] = (
                value[rows]
                - factors[nonzero, None] * value[pivot_row]
            ) % prime
        pivot_row += 1
        if pivot_row == len(value):
            break
    return row_ids[:pivot_row]


def polynomial(coefficients, monomials):
    terms = []
    for coefficient, (left, right) in zip(coefficients, monomials):
        coefficient = int(coefficient) % PRIME
        if not coefficient:
            continue
        monomial = (
            f"x{int(left)}^2" if left == right
            else f"x{int(left)}*x{int(right)}"
        )
        terms.append(f"{coefficient}*{monomial}")
    return "+".join(terms) or "0"


def linear_form(coefficients):
    terms = [
        f"{int(coefficient) % PRIME}*x{index}"
        for index, coefficient in enumerate(coefficients)
        if int(coefficient) % PRIME
    ]
    return "+".join(terms) or "0"


def normalized_affine_coefficients(equations, monomials, scalar):
    """Substitute the chart equation scalar(x)=1 and remove one variable."""
    pivot = int(np.flatnonzero(scalar)[0])
    inverse = pow(int(scalar[pivot]), -1, PRIME)
    retained = [index for index in range(VARIABLES) if index != pivot]
    reduced_variables = len(retained)
    offset = np.zeros(VARIABLES, dtype=np.int64)
    transform = np.zeros((VARIABLES, reduced_variables), dtype=np.int64)
    offset[pivot] = inverse
    for reduced, original in enumerate(retained):
        transform[original, reduced] = 1
        transform[pivot, reduced] = -int(scalar[original]) * inverse % PRIME
    assert int(scalar @ offset % PRIME) == 1
    assert not np.any(scalar @ transform % PRIME)

    qleft, qright = np.triu_indices(reduced_variables)
    affine_transform = np.zeros(
        (len(monomials), 1 + reduced_variables + len(qleft)), dtype=np.int64
    )
    for row, (left, right) in enumerate(monomials):
        left = int(left)
        right = int(right)
        affine_transform[row, 0] = offset[left] * offset[right] % PRIME
        affine_transform[row, 1:1 + reduced_variables] = (
            offset[left] * transform[right]
            + offset[right] * transform[left]
        ) % PRIME
        products = transform[left, qleft] * transform[right, qright]
        distinct = qleft != qright
        products[distinct] += (
            transform[left, qright[distinct]]
            * transform[right, qleft[distinct]]
        )
        affine_transform[row, 1 + reduced_variables:] = products % PRIME
    reduced = equations @ affine_transform % PRIME
    for sample in range(3):
        point = (
            np.arange(reduced_variables, dtype=np.int64) * (sample + 2)
            + sample + 1
        ) % PRIME
        lifted = (offset + transform @ point) % PRIME
        original_values = (
            lifted[monomials[:, 0]] * lifted[monomials[:, 1]]
        ) % PRIME
        reduced_values = np.concatenate([
            np.ones(1, dtype=np.int64),
            point,
            point[qleft] * point[qright] % PRIME,
        ])
        assert np.array_equal(
            equations @ original_values % PRIME,
            reduced @ reduced_values % PRIME,
        )
    return retained, reduced, np.column_stack([qleft, qright])


def affine_polynomial(coefficients, quadratic_monomials):
    reduced_variables = 38
    terms = []
    constant = int(coefficients[0]) % PRIME
    if constant:
        terms.append(str(constant))
    for variable, coefficient in enumerate(
        coefficients[1:1 + reduced_variables]
    ):
        coefficient = int(coefficient) % PRIME
        if coefficient:
            terms.append(f"{coefficient}*y{variable}")
    for coefficient, (left, right) in zip(
        coefficients[1 + reduced_variables:], quadratic_monomials
    ):
        coefficient = int(coefficient) % PRIME
        if not coefficient:
            continue
        monomial = (
            f"y{int(left)}^2" if left == right
            else f"y{int(left)}*y{int(right)}"
        )
        terms.append(f"{coefficient}*{monomial}")
    return "+".join(terms) or "0"


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--chart", type=int, required=True, choices=range(9))
    parser.add_argument(
        "--format", choices=("singular", "msolve"), default="singular"
    )
    parser.add_argument("--eliminate-chart-form", action="store_true")
    parser.add_argument(
        "--cover", choices=("original", "vandermonde"), default="original"
    )
    args = parser.parse_args()
    with np.load(
        HERE / "degree_35/d35_mixed_third_quadratic_span_p463.npz",
        allow_pickle=False,
    ) as frozen:
        equations = frozen["quadratic_coefficient_matrix"].astype(np.int64)
        monomials = frozen["quadratic_monomials"].astype(np.int64)
    basis_rows = row_basis_indices(equations, PRIME)
    assert len(basis_rows) == 137
    equations = equations[basis_rows]
    with np.load(
        HERE / "degree_35/c3_third_mixed_nonbased_tangent_p463.npz",
        allow_pickle=False,
    ) as frozen:
        scalar_rows = frozen["leading_scalar_forms"].astype(np.int64)
    scalar_basis = row_basis_indices(scalar_rows, PRIME)
    assert len(scalar_basis) == 9
    scalar_rows = scalar_rows[scalar_basis] % PRIME
    if args.cover == "original":
        scalar = scalar_rows[args.chart]
        cover_stem = ""
    else:
        mix = np.asarray([
            [pow(point, exponent, PRIME) for exponent in range(9)]
            for point in range(1, 10)
        ], dtype=np.int64)
        assert len(row_basis_indices(mix, PRIME)) == 9
        scalar = mix[args.chart] @ scalar_rows % PRIME
        cover_stem = "vandermonde_"
    if args.eliminate_chart_form:
        assert args.format == "msolve"
        retained, reduced_equations, reduced_monomials = (
            normalized_affine_coefficients(equations, monomials, scalar)
        )
        variables = ",".join(f"y{index}" for index in range(len(retained)))
        generators = [
            affine_polynomial(row, reduced_monomials)
            for row in reduced_equations
        ]
    else:
        variables = ",".join(f"x{index}" for index in range(VARIABLES))
        generators = [
            polynomial(row, monomials) for row in equations
        ] + [f"({linear_form(scalar)})-1"]
    if args.format == "singular":
        text = "\n".join([
            f"ring r={PRIME},({variables}),dp;",
            "option(redSB);",
            "ideal I=" + ",\n".join(generators) + ";",
            "ideal G=std(I);",
            'if (reduce(1,G)==0) { "D35_MIXED_THIRD_QUADRATIC_CHART_UNIT"; }',
            'else { "D35_MIXED_THIRD_QUADRATIC_CHART_NONUNIT"; size(G); }',
        ]) + "\n"
        suffix = "sing"
    else:
        text = "\n".join([variables, str(PRIME), ",\n".join(generators)]) + "\n"
        suffix = "eliminated.in" if args.eliminate_chart_form else "in"
    output = HERE / (
        "degree_35/d35_mixed_third_quadratic_"
        f"{cover_stem}chart{args.chart}_p463.{suffix}"
    )
    output.write_text(text)
    print(
        f"wrote {output.name}: equations={len(equations)} chart={args.chart}"
    )


if __name__ == "__main__":
    main()
