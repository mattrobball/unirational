#!/usr/bin/env python3
"""Exact multiple-root analysis of the primitive sextic on A=15,Y=12.

The primitive polynomial loses its two highest ``u`` coefficients on this
plane.  Equivalently its reciprocal has a permanent double root at v=0.
This script factors the discriminant of the remaining quartic in ``u`` and
compares it with the residual F15 curve from the raw-target Jacobian.  It
also records the gcd/subresultant data needed to distinguish a second
double root from a triple root at infinity.
"""

from __future__ import annotations

from collections import defaultdict
from fractions import Fraction
from pathlib import Path
import hashlib
import json

import sympy as sp


HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[2]
P_PATH = (
    ROOT
    / "tmp/target_branch_delta_saturated_singularity/global_primitive_u_sextic_exact.tsv"
)
F15_PATH = HERE / "affine_plane_F15.tsv"
OUT = HERE / "reciprocal_plane_payload.json"

A0 = 15
Y0 = 12
A, B, Y, Z, u = sp.symbols("A B Y Z u")


def load_p_coefficients():
    terms = [defaultdict(int) for _ in range(7)]
    with P_PATH.open() as stream:
        assert next(stream).strip() == "A\tB\tY\tZ\tu\tcoefficient"
        for line in stream:
            a, b, y, z, upow, coefficient = map(int, line.split())
            terms[upow][(a, b, y, z)] += coefficient
    return [
        sum(
            coefficient * A**a * B**b * Y**y * Z**z
            for (a, b, y, z), coefficient in bucket.items()
            if coefficient
        )
        for bucket in terms
    ]


def plane_p(coefficients) -> sp.Poly:
    expression = sum(
        coefficient.subs({A: A0, Y: Y0}) * u**upow
        for upow, coefficient in enumerate(coefficients)
    )
    return sp.Poly(expression, u, B, Z, domain=sp.QQ)


def load_f15_original_z() -> sp.Poly:
    # The saved file uses T=Z-11*A^2/18=Z-275/2 on this plane.
    T = sp.symbols("T")
    expression = 0
    with F15_PATH.open() as stream:
        assert next(stream).strip() == "B\tT\tcoefficient"
        for line in stream:
            b, t, coefficient = map(int, line.split())
            expression += coefficient * B**b * T**t
    shifted = sp.expand(expression.subs(T, Z - sp.Rational(275, 2)))
    poly = sp.Poly(shifted, B, Z, domain=sp.QQ)
    _denominator, cleared = poly.clear_denoms(convert=True)
    _content, primitive = cleared.primitive()
    if primitive.LC() < 0:
        primitive = -primitive
    return primitive


def primitive(poly: sp.Poly) -> sp.Poly:
    _denominator, cleared = poly.clear_denoms(convert=True)
    _content, answer = cleared.primitive()
    if answer.LC() < 0:
        answer = -answer
    return answer


def factor_records(expression):
    unit, factors = sp.factor_list(expression, B, Z)
    records = []
    for factor, exponent in factors:
        poly = primitive(sp.Poly(factor, B, Z, domain=sp.QQ))
        records.append(
            {
                "exponent": int(exponent),
                "degree_B": int(poly.degree(B)),
                "degree_Z": int(poly.degree(Z)),
                "total_degree": int(poly.total_degree()),
                "terms": len(poly.terms()),
                "expression": str(poly.as_expr()),
            }
        )
    return str(unit), records


def sha(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def normal_form_mod(poly, modulus):
    return sp.rem(
        sp.Poly(poly, B, Z, domain=sp.QQ),
        modulus,
    )


def main():
    coefficient_expressions = load_p_coefficients()
    p = plane_p(coefficient_expressions)
    assert p.degree(u) == 4
    coefficients = [sp.Poly(p.as_expr(), u).nth(i) for i in range(7)]
    assert coefficients[5] == coefficients[6] == 0
    p4 = primitive(sp.Poly(coefficients[4], B, Z, domain=sp.QQ))
    p3 = primitive(sp.Poly(coefficients[3], B, Z, domain=sp.QQ))

    # Exact coefficient-chart Jacobian.  In reciprocal coordinates the first
    # three coefficients are c0=p6,c1=p5,c2=p4.  At J1 the two-by-two block
    # for (c0,c1) versus (A,Y), and the c2 derivative along B, are units.
    c0, c1, c2 = coefficient_expressions[6], coefficient_expressions[5], coefficient_expressions[4]
    plane_derivatives = {
        name: sp.Poly(sp.diff(poly, variable).subs({A: A0, Y: Y0}), B, Z, domain=sp.QQ)
        for name, poly, variable in (
            ("c0_A", c0, A),
            ("c0_Y", c0, Y),
            ("c1_A", c1, A),
            ("c1_Y", c1, Y),
        )
    }
    coefficient_block_det = primitive(
        plane_derivatives["c0_A"] * plane_derivatives["c1_Y"]
        - plane_derivatives["c0_Y"] * plane_derivatives["c1_A"]
    )
    j1_substitution = {B: 10 * Z - 1258}
    j1_c2_slope = sp.Poly(sp.diff(coefficients[4], B).subs(j1_substitution), Z, domain=sp.QQ)
    j1_c3 = sp.Poly(coefficients[3].subs(j1_substitution), Z, domain=sp.QQ)
    j1_block_det = sp.Poly(coefficient_block_det.as_expr().subs(j1_substitution), Z, domain=sp.QQ)
    assert j1_c2_slope and j1_c3 and j1_block_det
    print("QUARTIC_DISCRIMINANT_BEGIN", flush=True)
    discriminant = sp.Poly(sp.discriminant(p.as_expr(), u), B, Z, domain=sp.QQ)
    discriminant = primitive(discriminant)
    print("QUARTIC_DISCRIMINANT_DONE", discriminant.total_degree(), len(discriminant.terms()), flush=True)
    disc_unit, disc_factors = factor_records(discriminant.as_expr())
    p4_unit, p4_factors = factor_records(p4.as_expr())

    f15 = load_f15_original_z()
    f15_factorization = sp.factor_list(f15.as_expr(), B, Z)[1]
    assert len(f15_factorization) == 1 and f15_factorization[0][1] == 1
    f15_divides_discriminant = sp.rem(discriminant, f15) == 0
    f15_exponent = 0
    quotient = discriminant
    while sp.rem(quotient, f15) == 0:
        quotient = sp.exquo(quotient, f15)
        f15_exponent += 1

    # The quartic and derivative have gcd degree one over the F15 function
    # field exactly when the first subresultant is nonzero modulo F15 and the
    # resultant vanishes.  SymPy orders subresultants from the inputs down to
    # the last nonzero member.
    derivative = sp.diff(p.as_expr(), u)
    subresultants = sp.subresultants(p.as_expr(), derivative, u)
    reduced_subresultants = []
    for item in subresultants:
        poly_u = sp.Poly(item, u)
        reduced_coefficients = []
        for coefficient in poly_u.all_coeffs():
            rem = sp.rem(sp.Poly(coefficient, B, Z, domain=sp.QQ), f15)
            reduced_coefficients.append(rem.as_expr())
        reduced_subresultants.append(
            {
                "degree_u": int(poly_u.degree()),
                "zero_mod_F15": all(value == 0 for value in reduced_coefficients),
                "coefficients_mod_F15": [str(value) for value in reduced_coefficients],
            }
        )

    assert reduced_subresultants[-1]["degree_u"] == 0
    assert reduced_subresultants[-1]["zero_mod_F15"]
    assert reduced_subresultants[-2]["degree_u"] == 1
    assert not reduced_subresultants[-2]["zero_mod_F15"]

    linear_subresultant = sp.Poly(subresultants[-2], u)
    root_leading = linear_subresultant.nth(1)
    assert normal_form_mod(root_leading, f15)
    c0_a_mod_f15 = normal_form_mod(plane_derivatives["c0_A"], f15)
    assert c0_a_mod_f15
    p4_mod_f15 = normal_form_mod(p4, f15)
    assert p4_mod_f15

    payload = {
        "schema": "t3-reciprocal-plane-multiple-roots-v1",
        "plane": {"A": A0, "Y": Y0},
        "plane_polynomial_degree_u": int(p.degree(u)),
        "reciprocal_permanent_root": {"v": 0, "multiplicity_at_least": 2},
        "p4_factorization": {"unit": p4_unit, "factors": p4_factors},
        "p3_gcd_with_p4": str(sp.gcd(p3, p4).as_expr()),
        "J1_formal_coefficient_chart": {
            "coordinates": "a=A-15,y=Y-12,s=J1=B-10Z+1258 over QQ(Z)",
            "c0_c1_block_det_factorization": str(sp.factor(coefficient_block_det.as_expr())),
            "block_det_restricted_J1_factorization": str(sp.factor(j1_block_det.as_expr())),
            "dc2_ds_restricted_J1_factorization": str(sp.factor(j1_c2_slope.as_expr())),
            "c3_restricted_J1_factorization": str(sp.factor(j1_c3.as_expr())),
            "coefficient_chart_etale": True,
            "weierstrass_order": 3,
        },
        "quartic_discriminant": {
            "degree_B": int(discriminant.degree(B)),
            "degree_Z": int(discriminant.degree(Z)),
            "total_degree": int(discriminant.total_degree()),
            "terms": len(discriminant.terms()),
            "unit": disc_unit,
            "factors": disc_factors,
        },
        "F15": {
            "degree_B": int(f15.degree(B)),
            "degree_Z": int(f15.degree(Z)),
            "total_degree": int(f15.total_degree()),
            "terms": len(f15.terms()),
            "divides_quartic_discriminant": f15_divides_discriminant,
            "exponent_in_quartic_discriminant": f15_exponent,
            "residual_quotient_terms": len(quotient.terms()),
            "irreducible_over_QQ": True,
            "affine_double_root_residue_degree": 1,
            "linear_subresultant_leading_nonzero": True,
            "infinity_branch_c0_A_nonzero": True,
            "infinity_branch_c0_A_normal_form_terms": len(c0_a_mod_f15.terms()),
            "infinity_root_exactly_double": True,
            "p4_normal_form_terms": len(p4_mod_f15.terms()),
            "branch_tangent_hyperplanes_distinct": True,
            "branch_tangent_reason": "the infinity branch has tangent dc0=unit*dA, while the affine-fold branch restricts to the reduced equation F15 on the plane",
        },
        "subresultants_mod_F15": reduced_subresultants,
        "source_sha256": {P_PATH.name: sha(P_PATH), F15_PATH.name: sha(F15_PATH)},
    }
    OUT.write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n")
    print("T3_RECIPROCAL_PLANE_MULTIPLE_ROOTS_DONE")
    print("F15 exponent", f15_exponent)


if __name__ == "__main__":
    main()
