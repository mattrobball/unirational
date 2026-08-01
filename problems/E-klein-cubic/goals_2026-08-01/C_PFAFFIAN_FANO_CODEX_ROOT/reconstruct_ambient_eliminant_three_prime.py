#!/usr/bin/env python3
"""Reconstruct the auxiliary degree-12 eliminant over Q(c) from three primes.

Here c^2+c+3=0.  Both embeddings at every split prime are consumed, and the
resulting A+B*c coordinates are reconstructed independently over Q.  This is
still only an eliminant-level certificate for an auxiliary projector chart.
"""

from __future__ import annotations

import ast
import json
from pathlib import Path

from sympy import Poly, QQ, Rational, Symbol, factor, sqrt
from sympy.polys.modulargcd import _integer_rational_reconstruction


HERE = Path(__file__).resolve().parent
SIBLING = HERE.parent / "C_PFAFFIAN_FANO_CODEX_ROOT_20260801_A7C3"
T = Symbol("T")


def eliminant(path: Path) -> list[int]:
    data = ast.literal_eval(path.read_text().strip().rstrip(":"))
    assert data[0] == 0
    _prime, _nvars, degree, _names, _linear, tail = data[1]
    assert degree == 3 and tail[0] == 1
    coefficients = [int(value) for value in tail[1][0][1]]
    assert len(coefficients) == 4 and coefficients[-1] == 1
    return coefficients


def period(zeta: int, prime: int) -> int:
    return sum(pow(zeta, exponent, prime) for exponent in (1, 3, 4, 5, 9)) % prime


def quadratic_coordinates(value: int, conjugate: int, c: int, cbar: int, prime: int):
    b = (value - conjugate) * pow((c - cbar) % prime, -1, prime) % prime
    return (value - b * c) % prime, b


def crt_pair(left: int, left_modulus: int, right: int, right_modulus: int) -> int:
    multiplier = (right - left) * pow(left_modulus, -1, right_modulus) % right_modulus
    return (left + left_modulus * multiplier) % (left_modulus * right_modulus)


def reconstruct(residue: int, modulus: int) -> Rational:
    answer = _integer_rational_reconstruction(residue, modulus, QQ.get_ring())
    if answer is None:
        raise AssertionError(f"no unique rational reconstruction for {residue} mod {modulus}")
    return Rational(answer.numerator, answer.denominator)


def reduce_rational(value: Rational, prime: int) -> int:
    denominator = int(value.q) % prime
    assert denominator
    return int(value.p) * pow(denominator, -1, prime) % prime


def main() -> None:
    fibres = [
        (23, 2, 4, SIBLING / "ambient_degree12_a47_chart.rur", HERE / "ambient_degree12_p23_zeta4_a47.rur"),
        (67, 9, 14, HERE / "ambient_degree12_p67_a47.rur", HERE / "ambient_degree12_p67_zeta14_a47.rur"),
        (89, 2, 4, HERE / "ambient_degree12_p89_a47.rur", HERE / "ambient_degree12_p89_zeta4_a47.rur"),
    ]
    records = []
    for prime, zeta, zeta_bar, first_path, second_path in fibres:
        c = period(zeta, prime)
        cbar = period(zeta_bar, prime)
        assert (c + cbar + 1) % prime == 0
        assert c * cbar % prime == 3
        first = eliminant(first_path)
        second = eliminant(second_path)
        coordinates = [
            quadratic_coordinates(value, conjugate, c, cbar, prime)
            for value, conjugate in zip(first, second)
        ]
        records.append({
            "prime": prime,
            "zeta11": zeta,
            "conjugate_zeta11": zeta_bar,
            "c": c,
            "conjugate_c": cbar,
            "first_eliminant": first,
            "conjugate_eliminant": second,
            "A_B_residues": coordinates,
        })

    modulus = 1
    combined = [[0, 0] for _ in range(4)]
    for record in records:
        prime = record["prime"]
        for index, pair in enumerate(record["A_B_residues"]):
            for coordinate in range(2):
                combined[index][coordinate] = crt_pair(
                    combined[index][coordinate], modulus, pair[coordinate], prime
                )
        modulus *= prime

    coefficients = [
        [reconstruct(pair[0], modulus), reconstruct(pair[1], modulus)]
        for pair in combined
    ]
    assert coefficients[-1] == [1, 0]

    for record in records:
        prime = record["prime"]
        for exact_pair, residue_pair in zip(coefficients, record["A_B_residues"]):
            assert tuple(reduce_rational(value, prime) for value in exact_pair) == tuple(residue_pair)

    c_exact = (-1 + sqrt(-11)) / 2
    polynomial = Poly(
        sum((a + b * c_exact) * T**index for index, (a, b) in enumerate(coefficients)),
        T,
        extension=sqrt(-11),
    )
    factorization = factor(polynomial.as_expr(), extension=sqrt(-11))
    factor_data = polynomial.factor_list()
    factor_degrees = [factor_poly.degree() for factor_poly, multiplicity in factor_data[1]
                      for _ in range(multiplicity)]
    payload = {
        "format": "ambient-eliminant-three-prime-rational-reconstruction-v1",
        "scope": "exact eliminant candidate; auxiliary chart only",
        "quadratic_field": "Q(c), c^2+c+3=0",
        "fibres": records,
        "crt_modulus": modulus,
        "coefficients_ascending_A_plus_Bc": [
            [[int(value.p), int(value.q)] for value in pair] for pair in coefficients
        ],
        "sympy_factorization": str(factorization),
        "factor_degrees_over_quadratic_field": factor_degrees,
        "irreducible_over_quadratic_field": factor_degrees == [3],
        "theorem_boundary": (
            "an exact eliminant does not reconstruct its 47 coordinate functions, "
            "prove flat characteristic-zero lifting, or give a K_proj-rational projector"
        ),
    }
    (HERE / "ambient_eliminant_three_prime.json").write_text(
        json.dumps(payload, indent=2) + "\n"
    )
    print(json.dumps({
        "modulus": modulus,
        "coefficients": payload["coefficients_ascending_A_plus_Bc"],
        "factorization": payload["sympy_factorization"],
    }, indent=2))
    print("AMBIENT-ELIMINANT-THREE-PRIME-RATIONAL-RECONSTRUCTED")


if __name__ == "__main__":
    main()
