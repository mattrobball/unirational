#!/usr/bin/env python3
"""Exact/specialized models used by the Goal F search.

This module reads the sealed upstream JSON payloads but does not import an
upstream producer.  Its finite-field routines are discovery tools only; a
terminal payload must be reconstructed over the characteristic-zero function
field and checked independently.
"""

from __future__ import annotations

from dataclasses import dataclass
from fractions import Fraction
from functools import lru_cache
import json
from pathlib import Path

import sympy as sp


HERE = Path(__file__).resolve().parent
PROBLEM = HERE.parents[1]
BKK = PROBLEM / "tmp/full_scaled_frame_degree_attack/sparse_bkk_certificate.json"
FORMS = PROBLEM / "certificates/fixed_frame_arithmetic/five_forms.json"


def _fraction(record: dict) -> Fraction:
    return Fraction(int(record["numerator"]), int(record["denominator"]))


def specialized_consequences(values: dict[str, int], prime: int) -> list[sp.Poly]:
    """Return the three sparse consequences in F_p[t,u,v]."""

    payload = json.loads(BKK.read_text())
    t, u, v = sp.symbols("t u v")
    result = []
    for records in payload["consequences"]["serialized"]:
        expression = 0
        for record in records:
            eA, eB, eY, eZ, et, eu, ev = map(int, record["exponents"])
            coefficient = _fraction(record)
            residue = (
                coefficient.numerator
                * pow(coefficient.denominator, -1, prime)
                * pow(values["A"], eA, prime)
                * pow(values["B"], eB, prime)
                * pow(values["Y"], eY, prime)
                * pow(values["Z"], eZ, prime)
            ) % prime
            expression += residue * t**et * u**eu * v**ev
        result.append(sp.Poly(expression, t, u, v, modulus=prime))
    return result


def _univariate_coefficient(poly: sp.Poly, et: int, ev: int, prime: int) -> sp.Poly:
    t, u, v = poly.gens
    expression = 0
    for (mt, mu, mv), coefficient in poly.terms():
        if mt == et and mv == ev:
            expression += int(coefficient) * u**mu
    return sp.Poly(expression, u, modulus=prime)


@dataclass(frozen=True)
class SpecializedField:
    prime: int
    values: dict[str, int]
    modulus: sp.Poly
    t_element: sp.Poly
    u_element: sp.Poly
    v_element: sp.Poly
    cramer_denominator: sp.Poly | None

    def element(self, value=0) -> sp.Poly:
        u = self.modulus.gens[0]
        return sp.rem(sp.Poly(value, u, modulus=self.prime), self.modulus)

    def add(self, left: sp.Poly, right: sp.Poly) -> sp.Poly:
        return sp.rem(left + right, self.modulus)

    def mul(self, left: sp.Poly, right: sp.Poly) -> sp.Poly:
        return sp.rem(left * right, self.modulus)

    def pow(self, value: sp.Poly, exponent: int) -> sp.Poly:
        answer = self.element(1)
        base = value
        while exponent:
            if exponent & 1:
                answer = self.mul(answer, base)
            base = self.mul(base, base)
            exponent >>= 1
        return answer

    def scale(self, scalar: int, value: sp.Poly) -> sp.Poly:
        return self.mul(self.element(scalar), value)

    def is_zero(self, value: sp.Poly) -> bool:
        return self.element(value).is_zero


def specialized_field(values: dict[str, int], prime: int = 67) -> SpecializedField:
    """Build F_p[u]/(mu), with exact Cramer reconstructions of t and v."""

    t, u, v = sp.symbols("t u v")
    rows = specialized_consequences(values, prime)
    abc = []
    for row in rows:
        a = _univariate_coefficient(row, 0, 0, prime)
        b = _univariate_coefficient(row, 0, 1, prime)
        c = _univariate_coefficient(row, 1, 0, prime)
        rebuilt = sp.Poly(a.as_expr() + b.as_expr() * v + c.as_expr() * t, t, u, v, modulus=prime)
        assert rebuilt == row
        abc.append((a, b, c))

    matrix = sp.Matrix([[entry.as_expr() for entry in row] for row in abc])
    raw_modulus = sp.Poly(sp.expand(matrix.det()), u, modulus=prime)
    modulus, remainder = sp.div(raw_modulus, sp.Poly(u, u, modulus=prime))
    assert remainder.is_zero
    assert modulus.degree() == 6
    modulus = modulus.monic()

    # A fixed two-row Cramer chart need not cover all six residue factors at
    # a finite specialization.  Solve globally in the quotient algebra for
    # v=sum(v_i*u^i) and t=sum(t_i*u^i), using all three equations.
    unknown_count = 12
    equations: list[list[int]] = []
    right_hand_side: list[int] = []

    def vector(poly: sp.Poly) -> list[int]:
        reduced = sp.rem(poly, modulus)
        return [int(reduced.nth(index)) % prime for index in range(6)]

    powers = [sp.Poly(1, u, modulus=prime)]
    for _ in range(1, 6):
        powers.append(sp.Poly(powers[-1] * sp.Poly(u, u, modulus=prime), u, modulus=prime))
    for a, b, c in abc:
        b_columns = [vector(b * power) for power in powers]
        c_columns = [vector(c * power) for power in powers]
        rhs = vector(-a)
        for coefficient_index in range(6):
            equations.append(
                [column[coefficient_index] for column in b_columns]
                + [column[coefficient_index] for column in c_columns]
            )
            right_hand_side.append(rhs[coefficient_index])

    augmented = [
        [value % prime for value in row] + [rhs % prime]
        for row, rhs in zip(equations, right_hand_side)
    ]
    pivot_row = 0
    pivot_columns = []
    for column in range(unknown_count):
        pivot = next((row for row in range(pivot_row, len(augmented)) if augmented[row][column]), None)
        if pivot is None:
            continue
        augmented[pivot_row], augmented[pivot] = augmented[pivot], augmented[pivot_row]
        inverse = pow(augmented[pivot_row][column], -1, prime)
        augmented[pivot_row] = [(inverse * value) % prime for value in augmented[pivot_row]]
        for row in range(len(augmented)):
            if row == pivot_row or not augmented[row][column]:
                continue
            scalar = augmented[row][column]
            augmented[row] = [
                (left - scalar * right) % prime
                for left, right in zip(augmented[row], augmented[pivot_row])
            ]
        pivot_columns.append(column)
        pivot_row += 1
    assert pivot_columns == list(range(unknown_count))
    assert all(not any(row[:unknown_count]) and row[-1] == 0 for row in augmented[pivot_row:])
    solution = [augmented[index][-1] for index in range(unknown_count)]
    v_element = sp.Poly(sum(solution[index] * u**index for index in range(6)), u, modulus=prime)
    t_element = sp.Poly(sum(solution[6 + index] * u**index for index in range(6)), u, modulus=prime)
    denominator = None
    u_element = sp.rem(sp.Poly(u, u, modulus=prime), modulus)

    # All three original equations vanish in the quotient.
    for a, b, c in abc:
        residual = sp.rem(a + b * v_element + c * t_element, modulus)
        assert residual.is_zero

    return SpecializedField(
        prime=prime,
        values={key: int(value) % prime for key, value in values.items()},
        modulus=modulus,
        t_element=t_element,
        u_element=u_element,
        v_element=v_element,
        cramer_denominator=denominator,
    )


def _cyclotomic_residue(pairs: list[list[int]], prime: int, zeta: int) -> int:
    answer = 0
    for exponent, (numerator, denominator) in enumerate(pairs):
        answer += int(numerator) * pow(int(denominator), -1, prime) * pow(zeta, exponent, prime)
    return answer % prime


@lru_cache(maxsize=None)
def _specialized_cubic_cached(A: int, B: int, Y: int, Z: int, prime: int, zeta: int):
    payload = json.loads(FORMS.read_text())["binary_slots"]

    def row(name: str) -> list[int]:
        return [_cyclotomic_residue(item, prime, zeta) for item in payload[name]]

    A, B, Y, Z = (value % prime for value in (A, B, Y, Z))
    q0, qA, qY = row("q0"), row("qA"), row("qY")
    r0, rA, rB, rY, rZ = row("r0"), row("rA"), row("rB"), row("rY"), row("rZ")
    q = [(q0[i] + A * qA[i] + Y * qY[i]) % prime for i in range(3)]
    r = [(r0[i] + A * rA[i] + B * rB[i] + Y * rY[i] + Z * rZ[i]) % prime for i in range(4)]
    return tuple(q), tuple(r)


def specialized_cubic(values: dict[str, int], prime: int = 67, zeta: int = 9) -> tuple[tuple[int, ...], tuple[int, ...]]:
    """Return q[0..2], r[0..3] for X^3+X*q(y,w)+r(y,w)."""

    return _specialized_cubic_cached(
        values["A"], values["B"], values["Y"], values["Z"], prime, zeta
    )


def cubic_value(field: SpecializedField, xyz: tuple[sp.Poly, sp.Poly, sp.Poly], zeta: int = 9) -> sp.Poly:
    """Evaluate the homogeneous fixed-frame cubic in the specialized algebra."""

    X, y, w = xyz
    q, r = specialized_cubic(field.values, field.prime, zeta)
    add, mul, power, scale = field.add, field.mul, field.pow, field.scale
    value = power(X, 3)
    quadratic = add(add(scale(q[0], power(y, 2)), scale(q[1], mul(y, w))), scale(q[2], power(w, 2)))
    value = add(value, mul(X, quadratic))
    cubic = add(
        add(scale(r[0], power(y, 3)), scale(r[1], mul(power(y, 2), w))),
        add(scale(r[2], mul(y, power(w, 2))), scale(r[3], power(w, 3))),
    )
    return add(value, cubic)


if __name__ == "__main__":
    sample = {"A": 1, "B": 2, "Y": 3, "Z": 4}
    field = specialized_field(sample)
    print(f"modulus={field.modulus.as_expr()}")
    print(f"t={field.t_element.as_expr()}")
    print(f"v={field.v_element.as_expr()}")
    print("SPECIALIZED_DEGREE6_FIELD_MODEL_ACCEPT")
