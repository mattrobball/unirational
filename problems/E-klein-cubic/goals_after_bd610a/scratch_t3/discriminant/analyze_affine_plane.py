#!/usr/bin/env python3
"""Analyze the exact affine contact plane A=15, Y=12.

The target H is supplied in (A,B,Y,Z), while the fixed-frame discriminant is
supplied in depressed coordinates (A,B,Y,T), with Z=T+11*A^2/18.  We expand
both polynomials in u=A-15 and v=Y-12.  Coefficients remain exact sparse
polynomials in B,T.
"""
from __future__ import annotations

from collections import defaultdict
from fractions import Fraction
from math import comb
from pathlib import Path
import hashlib
import json

import sympy as sp

HERE = Path(__file__).resolve().parent
PROBLEM = HERE.parents[2]
H_PATH = PROBLEM / "certificates/target_branch_global/H_factor/H_primitive_integer.tsv"
D_PATH = HERE / "fixed_frame_discriminant_T.tsv"

B, T, u, v = sp.symbols("B T u v")


def mul_truncated(left, right, cutoff):
    answer = defaultdict(Fraction)
    for i, ci in left.items():
        for j, cj in right.items():
            if i + j <= cutoff:
                answer[i + j] += ci * cj
    return {degree: value for degree, value in answer.items() if value}


def power_truncated(base, exponent, cutoff):
    answer = {0: Fraction(1)}
    power = dict(base)
    n = exponent
    while n:
        if n & 1:
            answer = mul_truncated(answer, power, cutoff)
        n >>= 1
        if n:
            power = mul_truncated(power, power, cutoff)
    return answer


def shift_linear(constant, exponent, cutoff):
    return {
        i: Fraction(comb(exponent, i)) * constant ** (exponent - i)
        for i in range(min(exponent, cutoff) + 1)
    }


def expand_h(cutoff):
    # Map (u-degree,v-degree,B-degree,T-degree) to coefficient.  The expansion
    # Z=T+275/2+(55/3)u+(11/18)u^2 is truncated only in u,v, never in B,T.
    out = defaultdict(Fraction)
    with H_PATH.open() as stream:
        next(stream)
        for line in stream:
            aa, bb, yy, zz, coefficient = map(int, line.split())
            apow = shift_linear(Fraction(15), aa, cutoff)
            ypow = shift_linear(Fraction(12), yy, cutoff)
            # First expand Z^zz by choosing k copies from the u-dependent part,
            # then expand (T+275/2)^(zz-k) exactly in T.
            z_by_u_t = defaultdict(Fraction)
            u_part_powers = [power_truncated({1: Fraction(55, 3), 2: Fraction(11, 18)}, k, cutoff) for k in range(zz + 1)]
            for k in range(zz + 1):
                choose = Fraction(comb(zz, k))
                rest = zz - k
                for iu, cu in u_part_powers[k].items():
                    if iu > cutoff:
                        continue
                    for tt in range(rest + 1):
                        ct = Fraction(comb(rest, tt)) * Fraction(275, 2) ** (rest - tt)
                        z_by_u_t[(iu, tt)] += choose * cu * ct
            for ia, ca in apow.items():
                for jv, cv in ypow.items():
                    if ia + jv > cutoff:
                        continue
                    for (iz, tt), cz in z_by_u_t.items():
                        if ia + iz + jv <= cutoff:
                            out[(ia + iz, jv, bb, tt)] += Fraction(coefficient) * ca * cv * cz
    return {monomial: coefficient for monomial, coefficient in out.items() if coefficient}


def expand_d(cutoff):
    out = defaultdict(Fraction)
    with D_PATH.open() as stream:
        next(stream)
        for line in stream:
            aa, bb, yy, tt, coefficient = map(int, line.split())
            for ia, ca in shift_linear(Fraction(15), aa, cutoff).items():
                for jv, cv in shift_linear(Fraction(12), yy, cutoff).items():
                    if ia + jv <= cutoff:
                        out[(ia, jv, bb, tt)] += Fraction(coefficient) * ca * cv
    return {monomial: coefficient for monomial, coefficient in out.items() if coefficient}


def order(terms):
    return min(i + j for i, j, _b, _t in terms)


def coefficient_expr(terms, i, j):
    return sum(
        sp.Rational(value.numerator, value.denominator) * B**bb * T**tt
        for (ii, jj, bb, tt), value in terms.items()
        if ii == i and jj == j
    )


def homogeneous_expr(terms, degree):
    return sum(coefficient_expr(terms, i, degree - i) * u**i * v ** (degree - i) for i in range(degree + 1))


def primitive_poly(expression):
    poly = sp.Poly(expression, B, T, domain=sp.QQ)
    _denominator, cleared = poly.clear_denoms(convert=True)
    _content, primitive = cleared.primitive()
    if primitive.LC() < 0:
        primitive = -primitive
    return primitive


def write_tsv(path, poly):
    with path.open("w") as stream:
        stream.write("B\tT\tcoefficient\n")
        for (bb, tt), coefficient in poly.terms():
            stream.write(f"{bb}\t{tt}\t{int(coefficient)}\n")


def poly_stats(poly):
    return {
        "terms": len(poly.terms()),
        "total_degree": poly.total_degree(),
        "degrees_BT": [poly.degree(B), poly.degree(T)],
    }


def file_hash(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def main():
    cutoff = 2
    h = expand_h(cutoff)
    d = expand_d(cutoff)
    h_order = order(h)
    d_order = order(d)
    assert h_order == d_order == 1
    h10 = coefficient_expr(h, 1, 0)
    h01 = coefficient_expr(h, 0, 1)
    h02 = coefficient_expr(h, 0, 2)
    d10 = coefficient_expr(d, 1, 0)
    d01 = coefficient_expr(d, 0, 1)
    d02 = coefficient_expr(d, 0, 2)
    assert h10 and d10 and not h01 and not d01

    # If H=h10*u+h02*v^2+..., then on H one has
    # u=-(h02/h10)v^2+... and Delta has leading coefficient
    # (h10*d02-d10*h02)/h10.  This is half the derivative-convention
    # numerator Delta_YY*H_A-Delta_A*H_YY.
    numerator = sp.expand(h10 * d02 - d10 * h02)
    assert numerator

    q3 = (
        B**3 + 24 * B**2 * T - 324 * B**2 + 192 * B * T**2
        + 2592 * B * T - 7776 * B + 512 * T**3 + 18144 * T**2
        + 194400 * T + 554040
    )
    known = (
        (B - 10 * T - 117) ** 2
        * (B + 8 * T + 108) ** 2
        * (2 * B - 2 * T - 9)
        * (4 * B + 2 * T + 9) ** 4
        * q3
    )
    f15_expression = sp.cancel(numerator / known)
    assert sp.denom(f15_expression) == 1
    f15 = primitive_poly(f15_expression)
    assert f15.total_degree() == 15 and len(f15.terms()) == 134
    # The residual factor is irreducible over QQ; geometric splitting is not
    # claimed or needed for the generic height-one multiplicity-two result.
    _unit, f15_factors = sp.factor_list(f15.as_expr())
    assert len(f15_factors) == 1 and f15_factors[0][1] == 1

    numerator_poly = primitive_poly(numerator)
    n_path = HERE / "affine_plane_contact_numerator.tsv"
    f15_path = HERE / "affine_plane_F15.tsv"
    write_tsv(n_path, numerator_poly)
    write_tsv(f15_path, f15)
    payload = {
        "schema": "t3-fixed-frame-affine-plane-contact-v1",
        "coordinates": "u=A-15, v=Y-12, T=Z-11*A^2/18",
        "plane": ["A-15", "Y-12"],
        "identities": {
            "H_on_plane": 0,
            "H_v_on_plane": 0,
            "Delta_on_plane": 0,
            "Delta_v_on_plane": 0,
            "H_u_nonzero": True,
            "Delta_u_nonzero": True,
            "quadratic_contact_numerator_nonzero": True,
        },
        "generic_normalization": "H_u is nonzero at the generic point, so H is smooth and normalization is an isomorphism there",
        "generic_contact_order": 2,
        "generic_contact_mod_3": 2,
        "normal_expansion": "u=-(H_02/H_10)*v^2+O(v^3); Delta|H=((H_10*D_02-D_10*H_02)/H_10)*v^2+O(v^3)",
        "coefficient_stats": {
            "H_10": poly_stats(sp.Poly(h10, B, T)),
            "H_02": poly_stats(sp.Poly(h02, B, T)),
            "Delta_10": poly_stats(sp.Poly(d10, B, T)),
            "Delta_02": poly_stats(sp.Poly(d02, B, T)),
            "contact_numerator": poly_stats(numerator_poly),
            "F15": poly_stats(f15),
        },
        "special_locus_factorization_BT": "unit*(B-10*T-117)^2*(B+8*T+108)^2*(2*B-2*T-9)*(4*B+2*T+9)^4*Q3*F15",
        "Q3": str(q3),
        "special_locus_labels_BZ": {
            "hessian_line": "B+8*Z-992",
            "target_jacobian_line_1": "B-10*Z+1258",
            "cancellation_line": "B-Z+133",
            "target_jacobian_line_2": "2*B+Z-133",
            "direction_resultant": "Q3 after T=Z-275/2",
        },
        "gate_note": "the plane lies in the complementary-resultant gate A-15, so it was absent from the earlier D(G) fold chart",
        "artifacts": {
            n_path.name: file_hash(n_path),
            f15_path.name: file_hash(f15_path),
        },
        "sources": {
            str(H_PATH.relative_to(PROBLEM)): file_hash(H_PATH),
            D_PATH.name: file_hash(D_PATH),
        },
    }
    (HERE / "affine_plane_contact_payload.json").write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n")
    print(json.dumps(payload, indent=2, sort_keys=True))
    print("T3_AFFINE_PLANE_CONTACT_EXACT_2")


if __name__ == "__main__":
    main()
