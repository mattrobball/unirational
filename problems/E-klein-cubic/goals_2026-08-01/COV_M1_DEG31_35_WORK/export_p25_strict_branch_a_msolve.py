#!/usr/bin/env python3
"""Export directly eliminated strict P25 branch-A scalar charts."""

from __future__ import annotations

import argparse
from pathlib import Path

import numpy as np

from probe_cubic_scalar_cubes import cubic_coefficients
from produce_canonical_bases import rank_profile


HERE = Path(__file__).resolve().parent


def monomial_text(monomial: np.ndarray) -> str:
    variables = [int(index) - 1 for index in monomial if int(index)]
    if not variables:
        return "1"
    pieces = []
    for variable in sorted(set(variables)):
        exponent = variables.count(variable)
        pieces.append(
            f"y{variable}" + (f"^{exponent}" if exponent != 1 else "")
        )
    return "*".join(pieces)


def polynomial_text(coefficients: np.ndarray, monomials: list[str], prime: int) -> str:
    terms = []
    for coefficient, monomial in zip(coefficients, monomials):
        coefficient = int(coefficient) % prime
        if not coefficient:
            continue
        if monomial == "1":
            terms.append(str(coefficient))
        elif coefficient == 1:
            terms.append(monomial)
        else:
            terms.append(f"{coefficient}*{monomial}")
    return "+".join(terms) or "0"


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--prime", type=int, choices=(199, 331), default=199)
    parser.add_argument("--chart", type=int, choices=range(5), required=True)
    args = parser.parse_args()
    prime = args.prime
    source = HERE / f"p25_strict_branch_a_p{prime}.npz"
    with np.load(source, allow_pickle=False) as frozen:
        values = frozen["reduced_basis_values"].astype(np.int64)
        sample_rows = frozen["landing_fixed_row_profile"].astype(np.int64)
        scalars = frozen["independent_scalar_forms"].astype(np.int64)
    values = values[sample_rows]
    constraints = scalars[:args.chart + 1] % prime
    target = np.zeros(len(constraints), dtype=np.int64)
    target[-1] = 1

    # Solve the chart equations directly at the requested P25 prime.
    rows, columns = constraints.shape
    augmented = np.column_stack([constraints, target]).astype(np.int64)
    pivot_row = 0
    pivots = []
    for column in range(columns):
        candidates = np.flatnonzero(augmented[pivot_row:, column])
        if not len(candidates):
            continue
        source_row = pivot_row + int(candidates[0])
        augmented[[pivot_row, source_row]] = augmented[[source_row, pivot_row]]
        augmented[pivot_row] = (
            augmented[pivot_row]
            * pow(int(augmented[pivot_row, column]), -1, prime)
        ) % prime
        for row in range(rows):
            if row != pivot_row and augmented[row, column]:
                augmented[row] = (
                    augmented[row]
                    - augmented[row, column] * augmented[pivot_row]
                ) % prime
        pivots.append(column)
        pivot_row += 1
    assert pivot_row == rows
    particular = np.zeros(columns, dtype=np.int64)
    particular[pivots] = augmented[:, -1]
    from probe_c3_constant_gate import nullspace_mod
    kernel = nullspace_mod(constraints, prime).T
    assert np.array_equal(constraints @ particular % prime, target)
    assert not np.any(constraints @ kernel % prime)

    constant = np.einsum("pjn,n->pj", values, particular) % prime
    linear = np.einsum("pjn,nk->pjk", values, kernel) % prime
    affine_values = np.concatenate([constant[:, :, None], linear], axis=2)
    monomials, coefficients = cubic_coefficients(
        affine_values, prime, chunk=32
    )
    profile = rank_profile(
        "RowRankProfile_modular_double", coefficients, prime
    )
    stem = HERE / f"p25_strict_branch_a_chart{args.chart}_p{prime}"
    np.savez_compressed(
        stem.with_suffix(".npz"),
        scalar_constraints=constraints.astype(np.uint16),
        affine_particular=particular.astype(np.uint16),
        affine_kernel=kernel.astype(np.uint16),
        source_sample_rows=sample_rows.astype(np.uint16),
        affine_basis_values=affine_values.astype(np.uint16),
        cubic_monomials=monomials.astype(np.uint16),
        cubic_coefficients=coefficients[profile].astype(np.uint16),
        fixed_row_profile=profile.astype(np.uint16),
    )
    texts = [monomial_text(monomial) for monomial in monomials]
    output = stem.with_suffix(".in")
    with output.open("w") as stream:
        stream.write(",".join(f"y{i}" for i in range(kernel.shape[1])) + "\n")
        stream.write(f"{prime}\n")
        for position, row in enumerate(profile):
            stream.write(polynomial_text(coefficients[int(row)], texts, prime))
            stream.write("\n" if position + 1 == len(profile) else ",\n")
    print(
        f"wrote {output.name}: variables={kernel.shape[1]} "
        f"equations={len(profile)} bytes={output.stat().st_size}",
        flush=True,
    )


if __name__ == "__main__":
    main()
