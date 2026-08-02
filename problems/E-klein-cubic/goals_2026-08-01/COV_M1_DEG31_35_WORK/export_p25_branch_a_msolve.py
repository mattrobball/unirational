#!/usr/bin/env python3
"""Export an exact normalized msolve chart for residual P25 branch A."""

from __future__ import annotations

import argparse
from pathlib import Path

import numpy as np

from produce_canonical_bases import rank_profile


HERE = Path(__file__).resolve().parent
PRIME = 463
VARIABLES = 51


def monomial_text(indices: np.ndarray) -> str:
    pieces = []
    for variable in sorted(set(map(int, indices))):
        exponent = sum(int(item) == variable for item in indices)
        pieces.append(
            f"x{variable}" + (f"^{exponent}" if exponent != 1 else "")
        )
    return "*".join(pieces)


def polynomial_text(coefficients: np.ndarray, monomials: list[str]) -> str:
    terms = []
    for coefficient, monomial in zip(coefficients, monomials):
        value = int(coefficient)
        if value:
            terms.append(monomial if value == 1 else f"{value}*{monomial}")
    return "+".join(terms) if terms else "0"


def linear_text(form: np.ndarray, constant: int = 0) -> str:
    terms = [
        f"{int(value)}*x{index}"
        for index, value in enumerate(form) if value
    ]
    if constant % PRIME:
        terms.append(str(constant % PRIME))
    return "+".join(terms)


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--chart", type=int, choices=range(5), required=True)
    parser.add_argument("--cubics", type=int, choices=range(1, 868), default=40)
    parser.add_argument("--triangular", action="store_true")
    args = parser.parse_args()

    with np.load(
        HERE / "p25_branch_a_quadratic_span_p463.npz",
        allow_pickle=False,
    ) as frozen:
        quadratic = frozen["quadratic_coefficient_matrix"].astype(np.int64)
        quadratic_indices = frozen["quadratic_monomials"].astype(np.int64)
    quadratic_rows = rank_profile(
        "RowRankProfile_modular_double", quadratic, PRIME
    )
    assert len(quadratic_rows) == 29
    with np.load(
        HERE / "p25_branch_a_cubic_span_p463.npz",
        allow_pickle=False,
    ) as frozen:
        cubic = frozen["independent_cubic_coefficients"][:args.cubics].astype(
            np.int64
        )
        cubic_indices = frozen["cubic_monomials"].astype(np.int64)
    with np.load(
        HERE / "p25_common_nonbased_branches_p463.npz",
        allow_pickle=False,
    ) as frozen:
        scalars = frozen["branch_A_scalar_forms"].astype(np.int64)

    quadratic_monomials = [monomial_text(item) for item in quadratic_indices]
    cubic_monomials = [monomial_text(item) for item in cubic_indices]
    mode = "triangular_" if args.triangular else ""
    output = HERE / (
        f"p25_branch_a_{mode}chart{args.chart}_c{args.cubics}_p463.in"
    )
    with output.open("w") as stream:
        stream.write(",".join(f"x{index}" for index in range(VARIABLES)) + "\n")
        stream.write(f"{PRIME}\n")
        if args.triangular:
            for form in scalars[:args.chart]:
                stream.write(linear_text(form) + ",\n")
        stream.write(linear_text(scalars[args.chart], PRIME - 1) + ",\n")
        for row in quadratic_rows:
            stream.write(
                polynomial_text(quadratic[int(row)], quadratic_monomials) + ",\n"
            )
        for index, coefficients in enumerate(cubic):
            suffix = "\n" if index + 1 == len(cubic) else ",\n"
            stream.write(polynomial_text(coefficients, cubic_monomials) + suffix)
    print(
        f"wrote {output.name}: 29 quadrics, {len(cubic)} cubics, "
        f"{output.stat().st_size} bytes",
        flush=True,
    )


if __name__ == "__main__":
    main()
