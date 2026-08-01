#!/usr/bin/env python3
"""CRT-reconstruct a provisional Q(c) degree-12 projector eliminant."""

from __future__ import annotations

import ast
import json
from pathlib import Path

from sympy import Poly, Symbol, factor, sqrt


HERE = Path(__file__).resolve().parent
SIBLING = HERE.parent / "C_PFAFFIAN_FANO_CODEX_ROOT_20260801_A7C3"
T = Symbol("T")


def eliminant(path: Path) -> list[int]:
    data = ast.literal_eval(path.read_text().strip().rstrip(":"))
    assert data[0] == 0
    _prime, _nvars, degree, _names, _linear, tail = data[1]
    assert degree == 3 and tail[0] == 1
    return [int(value) for value in tail[1][0][1]]


def period(zeta: int, prime: int) -> int:
    return sum(pow(zeta, exponent, prime) for exponent in (1, 3, 4, 5, 9)) % prime


def quadratic_coordinates(value, conjugate_value, c, conjugate_c, prime):
    b = (value - conjugate_value) * pow((c - conjugate_c) % prime, -1, prime) % prime
    a = (value - b * c) % prime
    return a, b


def crt(first, first_modulus, second, second_modulus):
    multiplier = (second - first) * pow(first_modulus, -1, second_modulus) % second_modulus
    return (first + first_modulus * multiplier) % (first_modulus * second_modulus)


def centered(value, modulus):
    return value if value <= modulus // 2 else value - modulus


def main() -> None:
    fibres = [
        {
            "prime": 23,
            "zeta": 2,
            "conjugate_zeta": 4,
            "first": SIBLING / "ambient_degree12_a47_chart.rur",
            "second": HERE / "ambient_degree12_p23_zeta4_a47.rur",
        },
        {
            "prime": 67,
            "zeta": 9,
            "conjugate_zeta": 14,
            "first": HERE / "ambient_degree12_p67_a47.rur",
            "second": HERE / "ambient_degree12_p67_zeta14_a47.rur",
        },
    ]
    residues = []
    for fibre in fibres:
        prime = fibre["prime"]
        c = period(fibre["zeta"], prime)
        conjugate_c = period(fibre["conjugate_zeta"], prime)
        assert (c + conjugate_c + 1) % prime == 0 and c * conjugate_c % prime == 3
        first = eliminant(fibre["first"])
        second = eliminant(fibre["second"])
        assert len(first) == len(second) == 4
        coordinates = [
            quadratic_coordinates(value, conjugate_value, c, conjugate_c, prime)
            for value, conjugate_value in zip(first, second)
        ]
        residues.append({
            "prime": prime,
            "c": c,
            "conjugate_c": conjugate_c,
            "first_eliminant": first,
            "conjugate_eliminant": second,
            "A_B_residues": coordinates,
        })

    modulus = residues[0]["prime"] * residues[1]["prime"]
    reconstructed = []
    for index in range(4):
        a = centered(crt(
            residues[0]["A_B_residues"][index][0], residues[0]["prime"],
            residues[1]["A_B_residues"][index][0], residues[1]["prime"],
        ), modulus)
        b = centered(crt(
            residues[0]["A_B_residues"][index][1], residues[0]["prime"],
            residues[1]["A_B_residues"][index][1], residues[1]["prime"],
        ), modulus)
        reconstructed.append([a, b])
    assert reconstructed[-1] == [1, 0]

    c_exact = (-1 + sqrt(-11)) / 2
    polynomial = sum((a + b * c_exact) * T**index for index, (a, b) in enumerate(reconstructed))
    factorization = factor(polynomial, extension=sqrt(-11))
    payload = {
        "format": "ambient-eliminant-two-prime-crt-v1",
        "scope": "provisional integer-height reconstruction; requires a third-prime holdout",
        "quadratic_field": "Q(c), c^2+c+3=0",
        "fibres": residues,
        "crt_modulus": modulus,
        "coefficients_ascending_A_plus_Bc": reconstructed,
        "maximum_centered_height": max(abs(value) for pair in reconstructed for value in pair),
        "sympy_factorization": str(factorization),
        "theorem_boundary": (
            "two-prime centered CRT is not exact rational reconstruction; no "
            "factor or projector is accepted until an unused-prime reduction and "
            "direct characteristic-zero substitution pass"
        ),
    }
    (HERE / "ambient_eliminant_reconstruction.json").write_text(
        json.dumps(payload, indent=2) + "\n"
    )
    print(json.dumps({
        "coefficients": reconstructed,
        "maximum_centered_height": payload["maximum_centered_height"],
        "factorization": payload["sympy_factorization"],
    }, indent=2))
    print("AMBIENT-ELIMINANT-TWO-PRIME-CRT-SCOPED")


if __name__ == "__main__":
    main()
