#!/usr/bin/env python3
"""Independently audit the recorded finite-fibre msolve outputs.

This verifier intentionally does not import the producer.  It checks the
input metadata and lambda saturation, parses the msolve RUR payload, and
refactors its separating polynomial over GF(67).
"""

from __future__ import annotations

import ast
from pathlib import Path

import sympy as sp


HERE = Path(__file__).resolve().parent
PRIME = 67
EXPECTED = {
    0: ([1, 24, 119], [9]),
    1: ([4, 4, 6, 19, 20, 23, 27, 41], []),
    2: ([1, 1, 1, 4, 15, 34, 88], [26, 60, 66]),
    3: ([2, 7, 9, 32, 34, 60], []),
}


def parse_msolve(path: Path):
    text = path.read_text().strip()
    if text.endswith(":"):
        text = text[:-1]
    return ast.literal_eval(text)


def main() -> None:
    z = sp.symbols("z")
    for index, (expected_degrees, expected_roots) in EXPECTED.items():
        input_path = HERE / f"quadratic_u_param_{index}_p{PRIME}.ms"
        output_path = HERE / f"quadratic_u_param_{index}_p{PRIME}.out"

        lines = input_path.read_text().splitlines()
        assert lines[0] == "a0,a1,a2,b0,b1,b2,lam,invlam"
        assert lines[1] == str(PRIME)
        assert len(lines[2:]) == 8
        assert lines[-1] == "lam*invlam+66"

        payload = parse_msolve(output_path)
        assert payload[0] == 0
        data = payload[1]
        assert data[0] == PRIME
        assert data[1] == 8
        assert data[2] == 144
        assert data[3] == lines[0].split(",")
        assert data[4] == [0, 0, 0, 0, 0, 0, 0, 1]

        degree, coefficients = data[5][1][0]
        assert degree == 144
        assert len(coefficients) == 145
        polynomial = sp.Poly(
            sum(coefficient * z**power for power, coefficient in enumerate(coefficients)),
            z,
            modulus=PRIME,
        )
        factorization = sp.factor_list(polynomial)[1]
        factor_degrees = sorted(
            factor.degree() for factor, multiplicity in factorization for _ in range(multiplicity)
        )
        roots = [value for value in range(PRIME) if int(polynomial.eval(value)) % PRIME == 0]
        assert factor_degrees == expected_degrees
        assert roots == expected_roots
        assert sum(factor_degrees) == 144
        print(
            f"sample {index}: degree=144 factors={factor_degrees} "
            f"Fp_roots={roots}"
        )

    print("ALL CHECKS PASS -- FINITE ANSATZ PACKET VERIFIED")


if __name__ == "__main__":
    main()
