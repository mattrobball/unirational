#!/usr/bin/env python3
"""Certify that the linear R_+K1 quotient deletes primitive covariants.

Each selected summand is an invariant multiple of a lower-degree K1
covariant.  Their sum therefore lies in the linear span N_d=(R_+K1)_d.
Nevertheless, its five components have gcd one.  We prove this by restricting
to one fixed projective line over F_419 and writing an explicit univariate
Bezout identity.  A nonconstant homogeneous common factor over
Q(zeta_11) would reduce to a nonconstant common factor and then restrict to a
nonconstant common divisor (or vanish identically) on every projective line,
contradicting the certificate.
"""

from __future__ import annotations

import hashlib
import json
from pathlib import Path
import sys

import numpy as np


HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE))
import produce_cross_basis as basis  # noqa: E402
import produce_primitive_module as primitive  # noqa: E402


P = 419
ZETA = 13
SELECTED = {31: (0, 9), 35: (0, 18)}


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as stream:
        for block in iter(lambda: stream.read(1024 * 1024), b""):
            digest.update(block)
    return digest.hexdigest()


def inverse_mod(matrix: np.ndarray, prime: int) -> np.ndarray:
    n = len(matrix)
    value = np.concatenate([
        np.asarray(matrix, dtype=np.int64) % prime,
        np.eye(n, dtype=np.int64),
    ], axis=1)
    for column in range(n):
        choices = np.flatnonzero(value[column:, column])
        assert len(choices)
        pivot = column + int(choices[0])
        value[[column, pivot]] = value[[pivot, column]]
        value[column] = value[column] * pow(
            int(value[column, column]), -1, prime
        ) % prime
        for row in range(n):
            if row != column and value[row, column]:
                value[row] = (
                    value[row] - value[row, column] * value[column]
                ) % prime
    return value[:, n:]


def trim(polynomial, prime=P):
    value = [int(item) % prime for item in polynomial]
    while len(value) > 1 and value[-1] == 0:
        value.pop()
    return value


def add(left, right, prime=P):
    result = [0] * max(len(left), len(right))
    for index in range(len(result)):
        result[index] = (
            (left[index] if index < len(left) else 0)
            + (right[index] if index < len(right) else 0)
        ) % prime
    return trim(result, prime)


def subtract(left, right, prime=P):
    return add(left, [(-item) % prime for item in right], prime)


def multiply(left, right, prime=P):
    result = [0] * (len(left) + len(right) - 1)
    for i, a in enumerate(left):
        for j, b in enumerate(right):
            result[i + j] = (result[i + j] + a * b) % prime
    return trim(result, prime)


def divide(dividend, divisor, prime=P):
    remainder = trim(dividend, prime)
    divisor = trim(divisor, prime)
    assert divisor != [0]
    quotient = [0] * max(1, len(remainder) - len(divisor) + 1)
    inverse = pow(divisor[-1], -1, prime)
    while remainder != [0] and len(remainder) >= len(divisor):
        shift = len(remainder) - len(divisor)
        coefficient = remainder[-1] * inverse % prime
        quotient[shift] = coefficient
        subtraction = [0] * shift + [coefficient * item % prime for item in divisor]
        remainder = subtract(remainder, subtraction, prime)
    return trim(quotient, prime), trim(remainder, prime)


def xgcd(left, right, prime=P):
    old_r, r = trim(left, prime), trim(right, prime)
    old_s, s = [1], [0]
    old_t, t = [0], [1]
    while r != [0]:
        quotient, remainder = divide(old_r, r, prime)
        old_r, r = r, remainder
        old_s, s = s, subtract(old_s, multiply(quotient, s, prime), prime)
        old_t, t = t, subtract(old_t, multiply(quotient, t, prime), prime)
    inverse = pow(old_r[-1], -1, prime)
    scale = [inverse]
    return (
        multiply(old_r, scale, prime),
        multiply(old_s, scale, prime),
        multiply(old_t, scale, prime),
    )


def bezout(polynomials):
    gcd = trim(polynomials[0])
    coefficients = [[1]]
    for polynomial in polynomials[1:]:
        new_gcd, left, right = xgcd(gcd, polynomial)
        coefficients = [multiply(left, item) for item in coefficients] + [right]
        gcd = new_gcd
    total = [0]
    for coefficient, polynomial in zip(coefficients, polynomials):
        total = add(total, multiply(coefficient, polynomial))
    assert total == gcd == [1]
    return coefficients


def main() -> None:
    module = basis.module_at(P, ZETA)
    generator_path = HERE / "dual_hironaka_generators.json"
    generators = json.loads(generator_path.read_text())["generators"]
    line_a, line_b = basis.fixed_points(2) % P
    output = {
        "schema": "cov-m1-primitive-quotient-counterexample-v1",
        "prime": P,
        "zeta11": ZETA,
        "line": {
            "formula": "x(u)=u*a+b on the chart t=1 of P(span(a,b))",
            "a": line_a.tolist(),
            "b": line_b.tolist(),
        },
        "dual_generators_sha256": sha256(generator_path),
        "degrees": {},
        "theorem": (
            "For d=31 and d=35, the displayed exact sum belongs to the "
            "linear invariant-multiple span N_d but has component gcd one. "
            "Thus K1_d/N_d is not a primitive-covariant quotient; in degree "
            "35 it kills a primitive covariant even though the linear quotient "
            "is zero. Landing equations may not be transferred to it."
        ),
    }
    for degree, indices in SELECTED.items():
        positive_path = HERE / f"degree_{degree}/fixed_invariant_multiple_basis.json"
        positive = json.loads(positive_path.read_text())
        records = [positive["basis"][index] for index in indices]
        points = np.asarray([
            (parameter * line_a + line_b) % P
            for parameter in range(degree + 1)
        ], dtype=np.int64)
        evaluator = basis.DualEvaluator(module, points, P)
        dual_values = basis.evaluate_fixed_dual_generators(evaluator, generators)
        values = sum(
            primitive.fixed_direction_value(record, dual_values, points, P)
            for record in records
        ) % P
        vandermonde = np.asarray([
            [pow(parameter, exponent, P) for exponent in range(degree + 1)]
            for parameter in range(degree + 1)
        ], dtype=np.int64)
        coefficients = inverse_mod(vandermonde, P) @ values % P
        polynomials = [
            trim(coefficients[:, component].tolist()) for component in range(5)
        ]
        assert any(int(coefficients[degree, component]) for component in range(5))
        bezout_coefficients = bezout(polynomials)
        output["degrees"][str(degree)] = {
            "positive_basis": str(positive_path.relative_to(HERE)),
            "positive_basis_sha256": sha256(positive_path),
            "summand_indices": list(indices),
            "summand_circuits": records,
            "sum_membership": "p=p_i+p_j lies in N_d=(R_+ K1)_d",
            "component_polynomials_coefficients_ascending": polynomials,
            "bezout_coefficients_ascending": bezout_coefficients,
            "bezout_identity": "sum_k A_k(u) p_k(u)=1 in F_419[u]",
            "nonzero_at_infinity": True,
            "characteristic_zero_conclusion": (
                "The exact cyclotomic circuit p has no nonconstant homogeneous "
                "common scalar factor: such a factor has nonzero homogeneous "
                "reduction at the good prime and would contradict the line "
                "Bezout identity."
            ),
        }
        print(f"primitive counterexample d={degree}: summands={indices} gcd=1")
    path = HERE / "primitive_quotient_counterexample.json"
    path.write_text(json.dumps(output, indent=2, sort_keys=True) + "\n")
    print("COV_M1_PRIMITIVE_QUOTIENT_COUNTEREXAMPLE_PRODUCED")


if __name__ == "__main__":
    main()
