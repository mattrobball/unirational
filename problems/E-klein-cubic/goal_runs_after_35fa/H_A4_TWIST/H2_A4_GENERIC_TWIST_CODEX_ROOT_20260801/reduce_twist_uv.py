#!/usr/bin/env python3
"""Expand the adapted A4 twist and reduce every coefficient to C(u,v)."""

from __future__ import annotations

import itertools
import json
from pathlib import Path

import sympy as sp


HERE = Path(__file__).resolve().parent
x, y, z, ell, emm, u, v, omega = sp.symbols("x y z ell m u v omega")
a, b, c, d, e = sp.symbols("a b c d e")
fiber = sp.symbols("Z0:5")
q = x * y * z


def reduce_omega(value):
    numerator, denominator = sp.fraction(sp.cancel(value))
    modulus = sp.Poly(omega**2 + omega + 1, omega)
    numerator = sp.rem(sp.Poly(numerator, omega), modulus).as_expr()
    denominator = sp.rem(sp.Poly(denominator, omega), modulus).as_expr()
    return sp.cancel(numerator / denominator)


def even_laurent_to_squares(value):
    """Divide by q^3, then replace even x,y,z exponents by X,Y,Z."""
    X, Y, Z = sp.symbols("X Y Z")
    result = 0
    for exponents, coefficient in sp.Poly(sp.expand(value), x, y, z).terms():
        shifted = tuple(power - 3 for power in exponents)
        assert all(power % 2 == 0 for power in shifted)
        result += coefficient * X**(shifted[0] // 2) * Y**(shifted[1] // 2) * Z**(shifted[2] // 2)
    fourier = {
        X: (1 + ell + emm) / 3,
        Y: (1 + omega**2 * ell + omega * emm) / 3,
        Z: (1 + omega * ell + omega**2 * emm) / 3,
    }
    return reduce_omega(result.subs(fourier))


def replace_l_cubes(polynomial):
    polynomial = sp.Poly(sp.expand(polynomial), ell)
    powers = [term[0][0] for term in polynomial.terms()]
    residue = powers[0] % 3
    assert all(power % 3 == residue for power in powers)
    result = sum(coefficient * u**((exponent[0] - residue) // 3)
                 for exponent, coefficient in polynomial.terms())
    return sp.factor(result), residue


def invariant_to_uv(value):
    value = reduce_omega(value.subs(emm, v / ell))
    numerator, denominator = sp.fraction(value)
    numerator, numerator_residue = replace_l_cubes(numerator)
    denominator, denominator_residue = replace_l_cubes(denominator)
    assert numerator_residue == denominator_residue
    result = reduce_omega(numerator / denominator)
    assert not result.has(ell, emm, omega)
    return sp.factor(result)


def main():
    Q = sp.Matrix([
        [x / q, y * z, x**3 / q],
        [y / q, z * x, y**3 / q],
        [z / q, x * y, z**3 / q],
    ])
    r = Q * sp.Matrix(fiber[2:])
    norm_form = (
        a * (ell * fiber[0])**3
        + b * (emm * fiber[1])**3
        + c * ell * fiber[0] * (r[0]**2 + omega**2 * r[1]**2 + omega * r[2]**2)
        + d * emm * fiber[1] * (r[0]**2 + omega * r[1]**2 + omega**2 * r[2]**2)
        + e * r[0] * r[1] * r[2]
    )
    cleared = sp.Poly(sp.expand(norm_form * q**3), *fiber)
    coefficients = {}
    for exponent, coefficient in cleared.terms():
        reduced = invariant_to_uv(even_laurent_to_squares(coefficient))
        if reduced != 0:
            coefficients[",".join(map(str, exponent))] = str(reduced).replace("**", "^")
    all_exponents = [exponent for exponent in itertools.product(range(4), repeat=5) if sum(exponent) == 3]
    complete = {
        ",".join(map(str, exponent)): coefficients.get(",".join(map(str, exponent)), "0")
        for exponent in all_exponents
    }
    denominator = u**2 - 3*u*v + u + v**3
    assert len(complete) == 35 and sum(value != "0" for value in complete.values()) == 22
    payload = {
        "format": "H2-A4-TWIST-OVER-CUV-v1",
        "base_field": "C(u,v)",
        "constant_parameters": "a,b,c,d,e are the five nonzero constants serialized in exact_degree3_map.json",
        "fiber_variables": [str(variable) for variable in fiber],
        "equation": "sum_exponent coefficient[exponent]*Z^exponent=0",
        "coefficient_count_total": 35,
        "coefficient_count_nonzero": 22,
        "coefficients": complete,
        "common_denominator_D0": str(denominator).replace("**", "^"),
        "identities": {
            "D0": "27*u*(x^2*y^2*z^2/S^3)",
            "Delta_over_S3": "-(2*omega+1)*(u^2-v^3)/(9*u)",
            "m_cubed": "v^3/u",
        },
        "equivalence_open_over_Cuv": "u*v*(u^2-v^3)*(u^2-3*u*v+u+v^3) != 0",
    }
    (HERE / "twist_over_Cuv.json").write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n")
    print("PASS 35 coefficients reduced; 22 are nonzero")
    print("PASS every coefficient lies in C(u,v)")
    print("H2_A4_TWIST_CUV_MODEL_OK")


if __name__ == "__main__":
    main()
