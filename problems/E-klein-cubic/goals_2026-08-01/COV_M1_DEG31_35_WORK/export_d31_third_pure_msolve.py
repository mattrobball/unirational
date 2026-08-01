#!/usr/bin/env python3
"""Export one exact degree-31 third-pure normalization chart for msolve."""

from __future__ import annotations

import argparse
from pathlib import Path
import struct

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
        if not value:
            continue
        terms.append(monomial if value == 1 else f"{value}*{monomial}")
    return "+".join(terms) if terms else "0"


def linear_chart_text(form: np.ndarray) -> str:
    terms = []
    for variable, coefficient in enumerate(form):
        value = int(coefficient)
        if value:
            terms.append(f"{value}*x{variable}")
    terms.append(str(PRIME - 1))
    return "+".join(terms)


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--chart", type=int, choices=range(6), default=0)
    args = parser.parse_args()
    source = HERE / "degree_31/d31_third_pure_scalar_cubes_p463.npz"
    profile_path = HERE / "degree_31/d31_third_pure_scalar_cubes_p463.bin.rows"
    with np.load(source, allow_pickle=False) as frozen:
        coefficient_matrix = frozen["landing_cubic_coefficients"]
        monomial_array = frozen["cubic_monomials"].astype(np.int64)
        scalar_form = frozen["independent_scalar_forms"][args.chart]
    with profile_path.open("rb") as profile_input:
        count = struct.unpack("<Q", profile_input.read(8))[0]
        rows = np.frombuffer(profile_input.read(), dtype="<u8")
    assert len(rows) == count == 1198
    monomials = [monomial_text(tuple(map(int, item))) for item in monomial_array]
    output = HERE / f"degree_31/d31_third_pure_chart{args.chart}_p463.in"
    with output.open("w") as stream:
        stream.write(",".join(f"x{index}" for index in range(36)) + "\n")
        stream.write(f"{PRIME}\n")
        for position, row in enumerate(rows):
            stream.write(polynomial_text(coefficient_matrix[int(row)], monomials))
            stream.write(",\n")
            if (position + 1) % 100 == 0:
                print(f"wrote {position + 1}/{len(rows)} cubic rows", flush=True)
        stream.write(linear_chart_text(scalar_form) + "\n")
    print(f"wrote {output} ({output.stat().st_size} bytes)", flush=True)


if __name__ == "__main__":
    main()
