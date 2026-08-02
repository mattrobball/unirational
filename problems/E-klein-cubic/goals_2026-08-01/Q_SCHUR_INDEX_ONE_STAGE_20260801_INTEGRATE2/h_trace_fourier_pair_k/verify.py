#!/usr/bin/env python3
"""Exact support and Newton-hull replay for all two-Kummer-basis pairs."""

from __future__ import annotations

from dataclasses import dataclass
from fractions import Fraction
from hashlib import sha256
import json
import math
from pathlib import Path


HERE = Path(__file__).resolve().parent
# Installed/staged packet layout:
#   <problem>/(goal_runs_after_35fa|goals_2026-08-01)/<packet>/<this dir>.
PROBLEM = HERE.parents[2]
SOURCE = PROBLEM / "goal_runs_after_35fa" / "H_11_5_TWIST"


@dataclass(frozen=True)
class Qz:
    """Q[z]/(z^4+z^3+z^2+z+1), represented in the power basis."""

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
        return Qz(tuple(-value for value in self.coefficients))

    def __sub__(self, other):
        return self+(-Qz.of(other))

    def __mul__(self, other):
        other = Qz.of(other)
        raw = [Fraction(0)]*7
        for i, left in enumerate(self.coefficients):
            for j, right in enumerate(other.coefficients):
                raw[i+j] += left*right
        # z^degree = -(z^(degree-1)+...+z^(degree-4)).
        for degree in range(6, 3, -1):
            leading = raw[degree]
            for step in range(1, 5):
                raw[degree-step] -= leading
        return Qz(tuple(raw[:4]))

    __rmul__ = __mul__

    def __pow__(self, exponent):
        assert exponent >= 0
        answer = Qz.of(1)
        base = self
        while exponent:
            if exponent & 1:
                answer *= base
            base *= base
            exponent //= 2
        return answer


ZERO = Qz.of(0)
ONE = Qz.of(1)
Z = Qz((Fraction(0), Fraction(1), Fraction(0), Fraction(0)))
assert Z**4+Z**3+Z**2+Z+ONE == ZERO
assert Z**5 == ONE and Z != ONE


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
    """R_i, with exponents ordered as (alpha,U2,U3,U4)."""
    answer = {}
    for alpha_degree in range(5):
        invariants = [0, 0, 0]
        if alpha_degree >= 2:
            invariants[alpha_degree-2] = 1
        answer[(alpha_degree, *invariants)] = Z**(index*alpha_degree)
    return answer


H = multiply(
    fourier_coordinate(2),
    multiply(fourier_coordinate(3), fourier_coordinate(3)),
)


def trace_component(alpha_shift, scalar):
    """Trace(H*scalar*alpha^alpha_shift), exponents (U1,U2,U3,U4)."""
    answer = {}
    for (alpha_degree, u2, u3, u4), coefficient in H.items():
        degree = alpha_degree+alpha_shift
        if degree % 5:
            continue
        add_term(answer, (degree//5, u2, u3, u4), 5*scalar*coefficient)
    return answer


def pair_components(p, q):
    alpha_shifts = (3*p, 2*p+q, p+2*q, 3*q)
    cyclotomic_scalars = (
        Z**p,
        Z**q+2*(Z**p),
        2*(Z**q)+Z**p,
        Z**q,
    )
    return [
        trace_component(alpha_shift, scalar)
        for alpha_shift, scalar in zip(alpha_shifts, cyclotomic_scalars)
    ]


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


def digest_json(value):
    data = json.dumps(value, sort_keys=True, separators=(",", ":")).encode()
    return sha256(data).hexdigest()


def digest_file(path):
    return sha256(path.read_bytes()).hexdigest()


def coefficient_valuation(polynomial, weight):
    # Every dictionary coefficient is already exact and nonzero.  Distinct
    # exponents remain distinct in the associated graded Laurent ring.
    return min(
        sum(a*b for a, b in zip(weight, exponent))
        for exponent in polynomial
    )


def lower_hull(values):
    hull = []
    for x, y in enumerate(values):
        while len(hull) >= 2:
            x0, y0 = hull[-2]
            x1, y1 = hull[-1]
            old_slope = Fraction(y1-y0, x1-x0)
            new_slope = Fraction(y-y1, x-x1)
            if old_slope >= new_slope:
                hull.pop()
            else:
                break
        hull.append((x, y))
    return hull


def main() -> None:
    payload = json.loads((HERE/"payload.json").read_text())
    assert payload["format"] == "H-11_5-FOURIER-TWO-BASIS-FULL-K-v1"

    source_paths = {
        "field_model.json": SOURCE/"field_model.json",
        "FIELD_MODEL.md": SOURCE/"FIELD_MODEL.md",
        "NORM_MODEL.md": SOURCE/"NORM_MODEL.md",
        "TWIST_MODEL.md": SOURCE/"TWIST_MODEL.md",
    }
    assert {name: digest_file(path) for name, path in source_paths.items()} == payload["source_hashes"]

    assert len(H) == 35
    assert digest_json(serialize_polynomial(H)) == payload["h_polynomial_hash"]

    records = {(record["p"], record["q"]): record for record in payload["pair_records"]}
    excluded = 0
    for p in range(5):
        for q in range(p+1, 5):
            record = records[p, q]
            components = pair_components(p, q)
            assert [len(component) for component in components] == [7, 7, 7, 7]
            assert digest_json([serialize_polynomial(component) for component in components]) == record["component_hash"]

            weight = tuple(record["weight"])
            assert math.gcd(*(abs(value) for value in weight)) == 1
            valuations = [coefficient_valuation(component, weight) for component in components]
            assert valuations == record["valuations"]

            hull = lower_hull(valuations)
            assert hull == [(0, valuations[0]), (3, valuations[3])]
            slope = Fraction(valuations[3]-valuations[0], 3)
            expected_slope = Fraction(*record["slope"])
            expected_root_valuation = Fraction(*record["root_valuation"])
            assert slope == expected_slope
            assert -slope == expected_root_valuation
            assert slope.denominator == expected_root_valuation.denominator == 3

            # An integral m can give two equal term values only at one of
            # the finitely many pairwise tie values below.  Check every
            # integral tie exactly; none is a repeated global minimum.  At
            # all other integral m every term value is already distinct.
            integral_ties = set()
            for i in range(4):
                for j in range(i+1, 4):
                    tie = Fraction(valuations[i]-valuations[j], j-i)
                    if tie.denominator == 1:
                        integral_ties.add(int(tie))
            for m in integral_ties:
                term_values = [value+k*m for k, value in enumerate(valuations)]
                assert term_values.count(min(term_values)) == 1

            excluded += 1
            print(
                "PAIR", p, q,
                "WEIGHT", ",".join(map(str, weight)),
                "VALUES", ",".join(map(str, valuations)),
                "ROOT_VALUATION", str(expected_root_valuation),
                "EXCLUDED",
            )

    assert len(records) == excluded == 10
    assert payload["counts"] == {
        "H_nonzero_terms": len(H),
        "basis_pairs": len(records),
        "excluded_pairs": excluded,
        "support_terms_per_coefficient": 7,
    }
    print("H_NONZERO_TERMS", len(H))
    print("EXCLUDED_PAIRS", excluded)
    print("H_TRACE_FOURIER_TWO_BASIS_FULL_K_NEWTON_EXCLUSION_OK")


if __name__ == "__main__":
    main()
