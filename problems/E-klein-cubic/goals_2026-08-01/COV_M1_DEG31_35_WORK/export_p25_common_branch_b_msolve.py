#!/usr/bin/env python3
"""Export one normalized chart of the 20-variable common P25 branch B."""

from __future__ import annotations

import argparse
from pathlib import Path

import numpy as np


HERE = Path(__file__).resolve().parent
PRIME = 463


def monomial_text(exponents: tuple[int, int, int]) -> str:
    pieces = []
    for variable in sorted(set(exponents)):
        exponent = exponents.count(variable)
        pieces.append(f"x{variable}" + (f"^{exponent}" if exponent != 1 else ""))
    return "*".join(pieces)


def polynomial_text(coefficients: np.ndarray, monomials: list[str]) -> str:
    terms = []
    for coefficient, monomial in zip(coefficients, monomials):
        value = int(coefficient)
        if value:
            terms.append(monomial if value == 1 else f"{value}*{monomial}")
    return "+".join(terms) if terms else "0"


def linear_text(form: np.ndarray, constant: int = 0) -> str:
    terms = [f"{int(value)}*x{index}" for index, value in enumerate(form) if value]
    if constant % PRIME:
        terms.append(str(constant % PRIME))
    return "+".join(terms)


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--chart", type=int, choices=range(7), required=True)
    parser.add_argument("--triangular", action="store_true")
    args = parser.parse_args()
    source = HERE / "p25_common_nonbased_branches_p463.npz"
    with np.load(source, allow_pickle=False) as frozen:
        coefficients = frozen["d31_cubic_coefficients"].astype(np.int64)
        monomial_array = frozen["cubic_monomials"].astype(np.int64)
        rows = frozen["d31_fixed_row_profile"].astype(np.int64)
        scalars = frozen["branch_B_scalar_forms"].astype(np.int64)
    monomials = [monomial_text(tuple(map(int, item))) for item in monomial_array]
    stem = "triangular_" if args.triangular else ""
    output = HERE / f"p25_common_branch_b_{stem}chart{args.chart}_p463.in"
    with output.open("w") as stream:
        stream.write(",".join(f"x{index}" for index in range(20)) + "\n")
        stream.write(f"{PRIME}\n")
        for row in rows:
            stream.write(polynomial_text(coefficients[int(row)], monomials) + ",\n")
        if args.triangular:
            for form in scalars[:args.chart]:
                stream.write(linear_text(form) + ",\n")
        stream.write(linear_text(scalars[args.chart], PRIME - 1) + "\n")
    print(f"wrote {output} ({output.stat().st_size} bytes)")


if __name__ == "__main__":
    main()
