#!/usr/bin/env python3
"""Build the authoritative fixed-frame cubic discriminant exactly.

This is intentionally separate from the xCD discriminant.  It consumes the
depressed fixed-frame cubic in certificates/fixed_frame_arithmetic/five_forms.json,
uses the universal Aronhold convention (c4^3-c6^2)/1728, and writes the
primitive rational descents in both T and Z coordinates.
"""
from __future__ import annotations

import hashlib
import json
from fractions import Fraction
from math import comb, gcd, lcm
from pathlib import Path

import sympy as sp

HERE = Path(__file__).resolve().parent
PROBLEM = HERE.parents[2]
FORMS = PROBLEM / "certificates/fixed_frame_arithmetic/five_forms.json"
UNIVERSAL = PROBLEM / "tmp/xcd_descent_algebra/universal_invariants.json"


def sha(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


z = sp.symbols("z")
K = sp.QQ.alg_field_from_poly(sp.Poly(sum(z**i for i in range(11)), z))
RT = K.poly_ring("A", "B", "Y", "T")
A, B, Y, T = RT.gens


def kval(row):
    ans = K.zero
    for numerator, denominator in reversed(row):
        ans = ans * K.unit + K(Fraction(int(numerator), int(denominator)))
    return ans


source = json.loads(FORMS.read_text())
slots = {
    name: [kval(value) for value in values]
    for name, values in source["binary_slots"].items()
}
q = [slots["q0"][i] + A * slots["qA"][i] + Y * slots["qY"][i] for i in range(3)]
r = [
    slots["r0"][i]
    + A * slots["rA"][i]
    + B * slots["rB"][i]
    + Y * slots["rY"][i]
    + T * slots["rZ"][i]
    for i in range(4)
]

# Universal coefficient convention:
# U=a^3+B*b^3+B1*a*b^2+B3*b^2*c+C*c^3+C1*a*c^2+C2*b*c^2+M*a*b*c.
Bc, B1, B3, Cc, C1, C2, M = r[0], q[0], r[1], r[3], q[2], r[2], q[1]
c4 = (
    -216 * Bc * Cc * M
    + 144 * Bc * C1 * C2
    + 16 * B1**2 * C1**2
    + 144 * B1 * B3 * Cc
    - 8 * B1 * C1 * M**2
    - 48 * B1 * C2**2
    - 48 * B3**2 * C1
    + 24 * B3 * C2 * M
    + M**4
)
c6 = (
    5832 * Bc**2 * Cc**2
    + 864 * Bc**2 * C1**3
    + 1296 * Bc * B1 * Cc * C1 * M
    - 864 * Bc * B1 * C1**2 * C2
    - 3888 * Bc * B3 * Cc * C2
    - 864 * Bc * B3 * C1**2 * M
    - 540 * Bc * Cc * M**3
    + 648 * Bc * C1 * C2 * M**2
    + 864 * Bc * C2**3
    + 864 * B1**3 * Cc**2
    + 64 * B1**3 * C1**3
    - 864 * B1**2 * B3 * Cc * C1
    - 864 * B1**2 * Cc * C2 * M
    - 48 * B1**2 * C1**2 * M**2
    + 576 * B1**2 * C1 * C2**2
    + 576 * B1 * B3**2 * C1**2
    + 648 * B1 * B3 * Cc * M**2
    - 720 * B1 * B3 * C1 * C2 * M
    + 12 * B1 * C1 * M**4
    + 72 * B1 * C2**2 * M**2
    + 864 * B3**3 * Cc
    + 72 * B3**2 * C1 * M**2
    - 216 * B3**2 * C2**2
    - 36 * B3 * C2 * M**3
    - M**6
)
delta_t = (c4**3 - c6**2).quo_ground(K(1728))


def ground_fraction(value) -> Fraction:
    assert value.is_ground and len(value.rep) == 1
    qv = value.rep[0]
    return Fraction(int(qv.numerator), int(qv.denominator))


def primitive_descent(poly):
    terms = poly.terms()
    anchor = terms[0][1]
    ratios = [(mon, coefficient / anchor) for mon, coefficient in terms]
    assert all(value.is_ground for _, value in ratios)
    rational = [(mon, ground_fraction(value)) for mon, value in ratios]
    denominator = 1
    for _, value in rational:
        denominator = lcm(denominator, value.denominator)
    integer = [
        (mon, value.numerator * (denominator // value.denominator))
        for mon, value in rational
    ]
    content = 0
    for _, coefficient in integer:
        content = gcd(content, abs(coefficient))
    integer = [(mon, coefficient // content) for mon, coefficient in integer]
    if integer[0][1] < 0:
        integer = [(mon, -coefficient) for mon, coefficient in integer]
    return integer


primitive_t = primitive_descent(delta_t)

# T=Z-11*A^2/18, hence substitute T by Z-11*A^2/18.
RZ = K.poly_ring("A", "B", "Y", "Z")
AZ, BZ, YZ, Z = RZ.gens
delta_z = RZ.zero
minus = K(Fraction(-11, 18))
for (ea, eb, ey, et), coefficient in delta_t.terms():
    for j in range(et + 1):
        delta_z += (
            coefficient
            * K(comb(et, j))
            * minus ** (et - j)
            * AZ ** (ea + 2 * (et - j))
            * BZ**eb
            * YZ**ey
            * Z**j
        )
primitive_z = primitive_descent(delta_z)


def write_tsv(path: Path, variables: tuple[str, ...], terms) -> None:
    with path.open("w") as stream:
        stream.write("\t".join((*variables, "coefficient")) + "\n")
        for monomial, coefficient in terms:
            stream.write("\t".join(map(str, (*monomial, coefficient))) + "\n")


t_path = HERE / "fixed_frame_discriminant_T.tsv"
z_path = HERE / "fixed_frame_discriminant_Z.tsv"
write_tsv(t_path, ("A", "B", "Y", "T"), primitive_t)
write_tsv(z_path, ("A", "B", "Y", "Z"), primitive_z)


def stats(terms):
    return {
        "terms": len(terms),
        "degree": max(sum(monomial) for monomial, _ in terms),
        "max_exponents": [max(monomial[i] for monomial, _ in terms) for i in range(4)],
        "max_coefficient_bits": max(abs(coefficient).bit_length() for _, coefficient in terms),
    }


# Exact irreducibility over QQ; the primitive polynomial has only 719 terms.
aa, bb, yy, zz = sp.symbols("A B Y Z")
z_expr = sum(
    coefficient * aa**monomial[0] * bb**monomial[1] * yy**monomial[2] * zz**monomial[3]
    for monomial, coefficient in primitive_z
)
factor_unit, factors = sp.factor_list(z_expr)
assert factor_unit == 1 and len(factors) == 1 and factors[0][1] == 1

payload = {
    "schema": "t3-authoritative-fixed-frame-discriminant-v1",
    "object": "fixed-frame depressed plane cubic, not xCD",
    "equation": "F0+A*FA+B*FB+Y*FY+(Z-11*A^2/18)*FZ",
    "delta_convention": "(c4^3-c6^2)/1728",
    "coefficient_field_before_descent": "QQ(zeta_11)",
    "rational_descent": "one nonzero QQ(zeta_11) scalar times a primitive ZZ polynomial",
    "T_coordinate": "T=Z-11*A^2/18",
    "T": {**stats(primitive_t), "sha256": sha(t_path)},
    "Z": {**stats(primitive_z), "sha256": sha(z_path), "factorization_over_QQ": "irreducible, exponent 1"},
    "sources": {str(FORMS.relative_to(PROBLEM)): sha(FORMS), str(UNIVERSAL.relative_to(PROBLEM)): sha(UNIVERSAL)},
}
(HERE / "discriminant_payload.json").write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n")
print("T3_FIXED_FRAME_DISCRIMINANT_PRODUCED")
