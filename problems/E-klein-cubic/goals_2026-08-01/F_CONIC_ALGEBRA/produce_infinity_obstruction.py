#!/usr/bin/env python3
"""Produce the exact residue-degree-one/index-three obstruction packet."""

from __future__ import annotations

from dataclasses import dataclass
from fractions import Fraction
from functools import reduce
from hashlib import sha256
import json
from math import gcd
from pathlib import Path

import sympy as sp

from build_coefficient_divisor_factors import A, B, Y, Z, coefficients
from build_infinity_divisor_smoothness import primitive_infinity_divisor
from model import FORMS


HERE = Path(__file__).resolve().parent
PAYLOAD = HERE / "payload/global_primitive_u_sextic_exact.tsv"
PHI = sp.Poly(sum(sp.Symbol("z") ** i for i in range(11)), sp.Symbol("z"), domain=sp.QQ)
z = PHI.gens[0]


@dataclass(frozen=True)
class Cyc:
    c: tuple[Fraction, ...]

    @staticmethod
    def make(values=()) -> "Cyc":
        data = [Fraction(value) for value in values]
        data.extend([Fraction(0)] * (10 - len(data)))
        return Cyc(tuple(data[:10]))

    def __add__(self, other) -> "Cyc":
        other = other if isinstance(other, Cyc) else Cyc.make([other])
        return Cyc(tuple(a + b for a, b in zip(self.c, other.c)))

    __radd__ = __add__

    def __neg__(self) -> "Cyc":
        return Cyc(tuple(-a for a in self.c))

    def __sub__(self, other) -> "Cyc":
        return self + (-other)

    def __rsub__(self, other) -> "Cyc":
        return Cyc.make([other]) - self

    def __mul__(self, other) -> "Cyc":
        other = other if isinstance(other, Cyc) else Cyc.make([other])
        raw = [Fraction(0)] * 19
        for i, a in enumerate(self.c):
            for j, b in enumerate(other.c):
                raw[i + j] += a * b
        for degree in range(18, 9, -1):
            lead = raw[degree]
            if lead:
                for lower in range(degree - 10, degree):
                    raw[lower] -= lead
                raw[degree] = 0
        return Cyc(tuple(raw[:10]))

    __rmul__ = __mul__

    def inverse(self) -> "Cyc":
        assert self
        expression = sum(value * z**i for i, value in enumerate(self.c))
        inverse = sp.invert(sp.Poly(expression, z, domain=sp.QQ), PHI)
        poly = sp.Poly(inverse, z, domain=sp.QQ)
        return Cyc.make([poly.nth(i) for i in range(10)])

    def __truediv__(self, other) -> "Cyc":
        other = other if isinstance(other, Cyc) else Cyc.make([other])
        return self * other.inverse()

    def __bool__(self) -> bool:
        return any(self.c)

    def mod(self, prime: int, zeta: int) -> int:
        return sum(
            value.numerator * pow(value.denominator, -1, prime) * pow(zeta, i, prime)
            for i, value in enumerate(self.c)
        ) % prime

    def serial(self) -> list[list[int]]:
        return [[value.numerator, value.denominator] for value in self.c]


def trim(poly: list[Cyc]) -> list[Cyc]:
    while poly and not poly[-1]:
        poly.pop()
    return poly


def divrem(left: list[Cyc], right: list[Cyc]) -> tuple[list[Cyc], list[Cyc]]:
    left = trim(left[:])
    right = trim(right[:])
    assert right
    quotient = [Cyc.make()] * max(0, len(left) - len(right) + 1)
    while len(left) >= len(right):
        shift = len(left) - len(right)
        scalar = left[-1] / right[-1]
        quotient[shift] = scalar
        for index, value in enumerate(right):
            left[index + shift] = left[index + shift] - scalar * value
        trim(left)
    return trim(quotient), left


def poly_gcd(left: list[Cyc], right: list[Cyc]) -> list[Cyc]:
    left, right = trim(left[:]), trim(right[:])
    while right:
        _, remainder = divrem(left, right)
        left, right = right, remainder
    scale = left[-1].inverse()
    return [value * scale for value in left]


def poly_eval(poly: list[Cyc], value: Cyc) -> Cyc:
    answer = Cyc.make()
    for coefficient in reversed(poly):
        answer = answer * value + coefficient
    return answer


def rows() -> dict[str, list[Cyc]]:
    raw = json.loads(FORMS.read_text())["binary_slots"]
    result = {}
    for name, entries in raw.items():
        result[name] = [
            Cyc.make(Fraction(int(a), int(b)) for a, b in entry)
            for entry in entries
        ]
    return result


def qpoly(values: list[Cyc]) -> list[Cyc]:
    return [values[2], values[1], values[0]]


def rpoly(values: list[Cyc]) -> list[Cyc]:
    return [values[3], values[2], values[1], values[0]]


def file_hash(path: Path) -> str:
    return sha256(path.read_bytes()).hexdigest()


def sparse(poly: sp.Poly) -> list[list[int]]:
    return [list(monomial) + [int(coefficient)] for monomial, coefficient in poly.terms()]


def main() -> None:
    forms = rows()
    common = poly_gcd(poly_gcd(rpoly(forms["rB"]), rpoly(forms["rY"])), rpoly(forms["rZ"]))
    assert len(common) == 2 and common[1] == Cyc.make([1])
    c = -common[0]
    assert not poly_eval(qpoly(forms["qY"]), c)
    for name in ("rB", "rY", "rZ"):
        assert not poly_eval(rpoly(forms[name]), c)

    q0 = poly_eval(qpoly(forms["q0"]), c)
    qA = poly_eval(qpoly(forms["qA"]), c)
    r0 = poly_eval(rpoly(forms["r0"]), c)
    rA = poly_eval(rpoly(forms["rA"]), c)
    g = {
        "a0": q0 + Fraction(33, 2) * qA,
        "a2": -3750 * qA,
        "b0": r0 + Fraction(33, 2) * rA,
        "b2": -3750 * rA,
    }

    prime, zeta = 89, 2
    assert c.mod(prime, zeta) == 2
    expected = {"a0": -31, "a2": 19, "b0": 14, "b2": -26}
    for name, value in g.items():
        assert value.mod(prime, zeta) == expected[name] % prime
    linear_root = -g["b2"] / g["a2"]
    numerator_at_linear_root = (
        linear_root * linear_root * linear_root + g["a0"] * linear_root + g["b0"]
    )
    assert numerator_at_linear_root and numerator_at_linear_root.mod(prime, zeta) == 17

    L, T, rr, rho = sp.symbols("L T r rho")
    Dhom = primitive_infinity_divisor()
    Daff = sp.Poly(Dhom.as_expr().subs({L: 1}), A, B, Y, T, domain=sp.QQ)
    c6_shift = sp.Poly(
        coefficients()[6].as_expr().subs({Z: T + sp.Rational(11, 18) * A**2}),
        A,
        B,
        Y,
        T,
        domain=sp.QQ,
    )
    quotient = sp.cancel(c6_shift.as_expr() / (B**2 * (A - 15) * Daff.as_expr()))
    assert quotient.is_Integer and quotient != 0

    Aparam = sp.Rational(33, 2) - 3750 * rr**2
    Yparam = 33125 * rr**2 - sp.Rational(9, 4) + rho / 600
    Bparam = -5625 * rr**2 - T / 2 + (rr / 4 - sp.Rational(1, 200)) * rho
    assert sp.expand(Daff.as_expr().subs({A: Aparam, B: Bparam, Y: Yparam})) == 0
    pnormal = 100 * A + 4 * B + 2 * T + 12 * Y - 1623
    qnormal = 212 * B + 106 * T + 36 * Y + 81
    dnormal = 53 * pnormal - qnormal
    assert sp.factor(pnormal.subs({A: Aparam, B: Bparam, Y: Yparam})) == rho * rr
    assert sp.factor(qnormal.subs({A: Aparam, B: Bparam, Y: Yparam})) == rho * (53 * rr - 1)
    assert sp.factor(dnormal.subs({A: Aparam, B: Bparam, Y: Yparam})) == rho

    witness = {rr: 0, rho: 1, T: 0}
    Aw, Bw, Yw = (sp.factor(value.subs(witness)) for value in (Aparam, Bparam, Yparam))
    Zw = sp.factor(sp.Rational(11, 18) * Aw**2)
    c5_value = sp.factor(coefficients()[5].as_expr().subs({A: Aw, B: Bw, Y: Yw, Z: Zw}))
    assert c5_value == sp.Rational(4782969, 625000000)

    data = {
        "format": "goal-F-infinity-obstruction-v1",
        "exit": "F-CONIC-CRITERION-EMPTY",
        "field": "Q(zeta_11)(A,B,Y,T), T=Z-11*A^2/18",
        "primitive_sha256": file_hash(PAYLOAD),
        "forms_sha256": file_hash(FORMS),
        "leading_coefficient": {
            "factorization": f"c6={int(quotient)}*B^2*(A-15)*D",
            "D_variables": ["A", "B", "Y", "T"],
            "D_sparse": sparse(Daff),
            "c5_nondivisibility_witness": {
                "A": str(Aw),
                "B": str(Bw),
                "Y": str(Yw),
                "T": "0",
                "Z": str(Zw),
                "c5": str(c5_value),
            },
        },
        "normalization": {
            "p": "100*A+4*B+2*T+12*Y-1623",
            "q": "212*B+106*T+36*Y+81",
            "rho": "53*p-q",
            "r": "p/(53*p-q)",
            "A": "33/2-3750*r^2",
            "Y": "33125*r^2-9/4+rho/600",
            "B": "-5625*r^2-T/2+(r/4-1/200)*rho",
            "function_field": "Q(zeta_11)(r,rho,T)",
        },
        "net": {
            "C0": "F0+(33/2-3750*r^2)*FA-5625*r^2*FB+(33125*r^2-9/4)*FY",
            "Crho": "(r/4-1/200)*FB+FY/600",
            "CT": "-FB/2+FZ",
            "base_line": "y-c*w",
            "c_qzeta11": c.serial(),
            "base_cubic": "X^3+(a0+a2*r^2)*X*w^2+(b0+b2*r^2)*w^3",
            "base_cubic_coefficients": {name: value.serial() for name, value in g.items()},
            "geometric_irreducibility": {
                "rewrite": "r^2=-(X^3+a0*X+b0)/(a2*X+b2)",
                "a2_nonzero": True,
                "numerator_at_root_of_denominator": numerator_at_linear_root.serial(),
                "good_reduction_value": 17,
                "reason": "the rational function has a simple pole, hence is not a square over the algebraic closure of the constant field",
            },
            "exact_remainders_zero": ["qY(c)", "rB(c)", "rY(c)", "rZ(c)"],
        },
        "good_reduction": {
            "prime": prime,
            "zeta": zeta,
            "c": 2,
            "base_ideal_affine_w1": ["y-2", "X^3+(19*r^2-31)*X+(-26*r^2+14)"],
            "base_cubic_irreducible": True,
            "smooth_member": {"r": 1, "rho": 0, "T": 0},
        },
        "class_group": {
            "universal_incidence": "X_net subset P2_z x P2_lambda over k=Q(zeta_11)(r)",
            "boundary": "E=B_net x P2_lambda, B_net=V(y-c*w,G), degree 3 field",
            "open": "P1-bundle over P2_z minus B_net",
            "generators": ["H_z", "H_lambda", "E"],
            "generic_degrees": [3, 0, 3],
            "index": 3,
        },
        "valuation": {
            "uniformizer": "D",
            "reciprocal": "s^6*P(1/s)=c6+c5*s+...+c0*s^6",
            "residual_factor": "s",
            "ramification_index": 1,
            "residue_degree": 1,
            "residue_field": "Q(zeta_11)(r,rho,T)",
        },
        "terminal_marker": "GOAL_F_CONIC_CRITERION_EMPTY_ACCEPT",
    }
    output = HERE / "infinity_obstruction.json"
    output.write_text(json.dumps(data, indent=2) + "\n")
    print(f"wrote {output}")
    print("GOAL_F_INFINITY_OBSTRUCTION_PRODUCED")


if __name__ == "__main__":
    main()
