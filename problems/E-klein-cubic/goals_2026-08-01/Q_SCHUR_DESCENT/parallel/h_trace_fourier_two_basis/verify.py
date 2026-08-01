#!/usr/bin/env python3
"""Standalone exact replay for the Fourier two-basis Laurent exclusion."""

from __future__ import annotations

from dataclasses import dataclass
from fractions import Fraction
from hashlib import sha256
import json
from pathlib import Path


HERE = Path(__file__).resolve().parent


@dataclass(frozen=True)
class Qz:
    """An element of Q[z]/(z^4+z^3+z^2+z+1)."""

    coefficients: tuple[Fraction, Fraction, Fraction, Fraction]

    @staticmethod
    def of(value=0):
        if isinstance(value, Qz):
            return value
        return Qz((Fraction(value), Fraction(0), Fraction(0), Fraction(0)))

    def __bool__(self):
        return any(self.coefficients)

    def __add__(self, other):
        other = Qz.of(other)
        return Qz(tuple(a+b for a, b in zip(self.coefficients, other.coefficients)))

    __radd__ = __add__

    def __neg__(self):
        return Qz(tuple(-a for a in self.coefficients))

    def __sub__(self, other):
        return self+(-Qz.of(other))

    def __mul__(self, other):
        other = Qz.of(other)
        raw = [Fraction(0)]*7
        for i, left in enumerate(self.coefficients):
            for j, right in enumerate(other.coefficients):
                raw[i+j] += left*right
        for degree in range(6, 3, -1):
            leading = raw[degree]
            for step in range(1, 5):
                raw[degree-step] -= leading
        return Qz(tuple(raw[:4]))

    __rmul__ = __mul__

    def __truediv__(self, other):
        return self*Qz.of(other).inverse()

    def __pow__(self, exponent: int):
        if exponent < 0:
            return self.inverse()**(-exponent)
        answer = Qz.of(1)
        base = self
        while exponent:
            if exponent & 1:
                answer *= base
            base *= base
            exponent //= 2
        return answer

    def inverse(self):
        if not self:
            raise ZeroDivisionError
        columns = []
        for j in range(4):
            basis = Qz(tuple(Fraction(int(i == j)) for i in range(4)))
            columns.append((self*basis).coefficients)
        augmented = [
            [columns[j][i] for j in range(4)]+[Fraction(int(i == 0))]
            for i in range(4)
        ]
        for column in range(4):
            pivot = next(row for row in range(column, 4) if augmented[row][column])
            augmented[column], augmented[pivot] = augmented[pivot], augmented[column]
            scale = augmented[column][column]
            augmented[column] = [entry/scale for entry in augmented[column]]
            for row in range(4):
                if row == column:
                    continue
                scale = augmented[row][column]
                augmented[row] = [
                    x-scale*y for x, y in zip(augmented[row], augmented[column])
                ]
        answer = Qz(tuple(augmented[i][4] for i in range(4)))
        assert self*answer == Qz.of(1)
        return answer


ZERO = Qz.of(0)
ONE = Qz.of(1)
Z = Qz((Fraction(0), Fraction(1), Fraction(0), Fraction(0)))
assert Z**4+Z**3+Z**2+Z+ONE == ZERO
assert Z**5 == ONE and Z != ONE


def trim(polynomial):
    polynomial = list(polynomial)
    while polynomial and not polynomial[-1]:
        polynomial.pop()
    return polynomial


def divide(dividend, divisor):
    dividend, divisor = trim(dividend), trim(divisor)
    if not divisor:
        raise ZeroDivisionError
    quotient = [ZERO]*max(0, len(dividend)-len(divisor)+1)
    while dividend and len(dividend) >= len(divisor):
        degree = len(dividend)-len(divisor)
        coefficient = dividend[-1]/divisor[-1]
        quotient[degree] += coefficient
        for i, value in enumerate(divisor):
            dividend[i+degree] -= coefficient*value
        dividend = trim(dividend)
    return trim(quotient), dividend


def gcd(left, right):
    left, right = trim(left), trim(right)
    while right:
        _, remainder = divide(left, right)
        left, right = right, remainder
    if not left:
        return []
    inverse_leading = left[-1].inverse()
    return [coefficient*inverse_leading for coefficient in left]


def remove_zero_root(polynomial):
    polynomial = trim(polynomial)
    while len(polynomial) > 1 and not polynomial[0]:
        polynomial = polynomial[1:]
    return polynomial


def add_term(polynomial, exponent, coefficient):
    polynomial[exponent] = polynomial.get(exponent, ZERO)+coefficient
    if not polynomial[exponent]:
        del polynomial[exponent]


def multiply(left, right):
    answer = {}
    for exponent1, coefficient1 in left.items():
        for exponent2, coefficient2 in right.items():
            exponent = tuple(a+b for a, b in zip(exponent1, exponent2))
            add_term(answer, exponent, coefficient1*coefficient2)
    return answer


def fourier_coordinate(index):
    # Exponents are (alpha,U2,U3,U4).
    answer = {}
    for alpha_degree in range(5):
        invariant_exponents = [0, 0, 0]
        if alpha_degree >= 2:
            invariant_exponents[alpha_degree-2] = 1
        answer[(alpha_degree, *invariant_exponents)] = Z**(index*alpha_degree)
    return answer


H = multiply(
    fourier_coordinate(2),
    multiply(fourier_coordinate(3), fourier_coordinate(3)),
)


def trace_component(alpha_shift, scalar):
    # Returned exponents are (U1,U2,U3,U4).
    answer = {}
    for (alpha_degree, u2, u3, u4), coefficient in H.items():
        total_degree = alpha_degree+alpha_shift
        if total_degree % 5:
            continue
        add_term(answer, (total_degree//5, u2, u3, u4), 5*scalar*coefficient)
    return answer


def components(p, q):
    alpha_shifts = (3*p, 2*p+q, p+2*q, 3*q)
    scalars = (
        Z**p,
        Z**q+2*(Z**p),
        2*(Z**q)+Z**p,
        Z**q,
    )
    return [
        trace_component(alpha_shift, scalar)
        for alpha_shift, scalar in zip(alpha_shifts, scalars)
    ]


def candidate_shifts(parts):
    candidates = set()
    for exponent0 in parts[0]:
        for k in range(1, 4):
            for exponentk in parts[k]:
                difference = tuple(a-b for a, b in zip(exponent0, exponentk))
                if all(value % k == 0 for value in difference):
                    candidates.add(tuple(value//k for value in difference))
    return sorted(candidates)


def common_scalar_gcd(parts, shift):
    groups = {}
    for k, part in enumerate(parts):
        translation = tuple(k*value for value in shift)
        for exponent, coefficient in part.items():
            target = tuple(a+b for a, b in zip(exponent, translation))
            polynomial = groups.setdefault(target, [ZERO]*4)
            polynomial[k] += coefficient
    common = None
    for polynomial in groups.values():
        polynomial = remove_zero_root(polynomial)
        common = polynomial if common is None else gcd(common, polynomial)
        if len(common) <= 1:
            return []
    return common or []


def serialize_coefficient(coefficient):
    return [
        [value.numerator, value.denominator]
        for value in coefficient.coefficients
    ]


def serialize_polynomial(polynomial):
    return [
        [list(exponent), serialize_coefficient(coefficient)]
        for exponent, coefficient in sorted(polynomial.items())
    ]


def digest(value):
    encoded = json.dumps(value, sort_keys=True, separators=(",", ":")).encode()
    return sha256(encoded).hexdigest()


def main() -> None:
    payload = json.loads((HERE/"payload.json").read_text())
    assert payload["format"] == "H-11_5-FOURIER-TWO-BASIS-LAURENT-v1"
    assert len(H) == 35
    assert digest(serialize_polynomial(H)) == payload["h_polynomial_hash"]

    records = {(item["p"], item["q"]): item for item in payload["pair_records"]}
    total_candidates = 0
    total_hits = 0
    for p in range(5):
        for q in range(p+1, 5):
            parts = components(p, q)
            assert [len(part) for part in parts] == [7, 7, 7, 7]
            candidates = candidate_shifts(parts)
            assert len(candidates) == 39
            hits = []
            for shift in candidates:
                common = common_scalar_gcd(parts, shift)
                if len(common) > 1:
                    hits.append((shift, common))
            record = records[p, q]
            assert record["component_hash"] == digest(
                [serialize_polynomial(part) for part in parts]
            )
            assert record["candidate_hash"] == digest(candidates)
            assert record["candidates"] == len(candidates)
            assert record["hits"] == len(hits) == 0
            total_candidates += len(candidates)
            total_hits += len(hits)
            print("PAIR", p, q, "SUPPORTS 7,7,7,7 CANDIDATES", len(candidates), "HITS", len(hits))

    assert len(records) == 10
    assert payload["counts"] == {
        "H_nonzero_terms": len(H),
        "basis_pairs": len(records),
        "candidate_shifts": total_candidates,
        "hits": total_hits,
        "support_terms_per_component": 7,
    }
    assert total_candidates == 390 and total_hits == 0
    print("H_NONZERO_TERMS", len(H))
    print("TOTAL_CANDIDATE_SHIFTS", total_candidates)
    print("TOTAL_HITS", total_hits)
    print("H_TRACE_FOURIER_TWO_BASIS_LAURENT_EXCLUSION_OK")


if __name__ == "__main__":
    main()

