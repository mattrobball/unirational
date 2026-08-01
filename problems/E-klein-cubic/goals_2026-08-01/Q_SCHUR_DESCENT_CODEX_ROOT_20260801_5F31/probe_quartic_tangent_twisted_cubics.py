#!/usr/bin/env python3
"""Test the four-point tangent-twisted-cubic descent construction.

Four linearly independent geometric points are moved to the coordinate
vertices of P3.  Twisted cubics through them are parametrized by their cross
ratio and four coordinate scales.  Tangency to a cubic surface at all four
vertices is a 4x4 linear system in the scales; its determinant is the exact
finite tangency equation.  For deterministic cubic surfaces this script
computes that equation, the four residual ninth-intersection points, and
tests whether those residual points are forced into a plane.

This is a discovery/audit calculation.  A nonzero span determinant refutes
the proposed automatic coplanarity shortcut; it is not a statement about the
specific generic Schur quartic, whose coordinates are not installed.
"""

from __future__ import annotations

import argparse
import json
import random
from pathlib import Path

import sympy as sp


HERE = Path(__file__).resolve().parent
s, v, t = sp.symbols("s v t")
lam = sp.symbols("l0:4")
x = sp.symbols("x0:4")


def compositions(total: int, slots: int):
    if slots == 1:
        yield (total,)
        return
    for first in range(total + 1):
        for tail in compositions(total - first, slots - 1):
            yield (first,) + tail


def reduce_t(expression, modulus):
    return sp.rem(sp.Poly(sp.expand(expression), t, domain=sp.QQ), modulus).as_expr()


def cubic(seed: int):
    rng = random.Random(seed)
    terms = []
    coefficients = {}
    for exponents in compositions(3, 4):
        if 3 in exponents:
            coefficient = 0
        else:
            coefficient = rng.choice(tuple(range(-7, 0)) + tuple(range(1, 8)))
        coefficients[exponents] = coefficient
        if coefficient:
            terms.append(
                coefficient
                * sp.prod(variable**exponent for variable, exponent in zip(x, exponents))
            )
    return sp.expand(sum(terms)), coefficients


def tangent_rows(pullback):
    local = (
        sp.diff(pullback.subs(s, 1), v).subs(v, 0),
        sp.diff(pullback.subs(v, 1), s).subs(s, 0),
        sp.diff(pullback.subs({s: 1 + sp.Symbol("w"), v: 1}), sp.Symbol("w")).subs(sp.Symbol("w"), 0),
        sp.diff(pullback.subs({s: t + sp.Symbol("w"), v: 1}), sp.Symbol("w")).subs(sp.Symbol("w"), 0),
    )
    rows = []
    for index, equation in enumerate(local):
        divided = sp.cancel(equation / lam[index] ** 2)
        polynomial = sp.Poly(sp.expand(divided), *lam)
        assert polynomial.total_degree() == 1
        rows.append([polynomial.coeff_monomial(variable) for variable in lam])
    return sp.Matrix(rows)


def kernel_minors(matrix):
    first_three = matrix[:3, :]
    return [
        sp.factor((-1) ** column * first_three[:, [j for j in range(4) if j != column]].det(method="berkowitz"))
        for column in range(4)
    ]


def homogeneous_coefficients(polynomial, degree):
    expanded = sp.Poly(sp.expand(polynomial), s, v)
    return [expanded.coeff_monomial(s**power * v ** (degree - power)) for power in range(degree + 1)]


def one_case(seed: int):
    form, coefficients = cubic(seed)
    partials = [sp.diff(form, variable) for variable in x]
    smooth_charts = []
    for chart, coordinate in enumerate(x):
        remaining = [variable for variable in x if variable != coordinate]
        equations = [sp.expand(value.subs(coordinate, 1)) for value in (form, *partials)]
        groebner = sp.groebner(equations, *remaining, order="grevlex", domain=sp.QQ)
        smooth_charts.append(groebner.contains(sp.Integer(1)))
    assert all(smooth_charts)
    basis = (
        lam[0] * s * (s - v) * (s - t * v),
        lam[1] * v * (s - v) * (s - t * v),
        lam[2] * s * v * (s - t * v),
        lam[3] * s * v * (s - v),
    )
    pullback = sp.expand(form.subs(dict(zip(x, basis)), simultaneous=True))
    matrix = tangent_rows(pullback)
    determinant = sp.factor(matrix.det(method="berkowitz"))
    determinant_numerator = sp.Poly(sp.cancel(determinant).as_numer_denom()[0], t, domain=sp.QQ)
    determinant_numerator = determinant_numerator.primitive()[1]
    boundary = sp.Poly(t**4 * (t - 1) ** 4, t, domain=sp.QQ)
    determinant_numerator, boundary_remainder = sp.div(determinant_numerator, boundary)
    assert boundary_remainder.is_zero
    determinant_numerator = determinant_numerator.primitive()[1]
    assert determinant_numerator.degree() == 4
    galois_group = sp.polys.numberfields.galois_group(
        determinant_numerator, t, by_name=True
    )[0]

    scales = kernel_minors(matrix)
    specialized_basis = [sp.expand(value.subs(dict(zip(lam, scales)))) for value in basis]
    specialized_pullback = sp.expand(form.subs(dict(zip(x, specialized_basis)), simultaneous=True))
    modulus = determinant_numerator
    affine_coefficients = [
        reduce_t(sp.Poly(specialized_pullback.subs(v, 1), s).coeff_monomial(s**power), modulus)
        for power in range(10)
    ]
    base = sp.Poly(s**2 * (s - 1) ** 2 * (s - t) ** 2, s)
    base_coefficients = [base.coeff_monomial(s**power) for power in range(7)]
    leading = affine_coefficients[7]
    after_linear = [affine_coefficients[power] for power in range(10)]
    for power, coefficient in enumerate(base_coefficients):
        after_linear[power + 1] = reduce_t(
            after_linear[power + 1] - leading * coefficient, modulus
        )
    constant = after_linear[6]
    for power, coefficient in enumerate(base_coefficients):
        after_linear[power] = reduce_t(
            after_linear[power] - constant * coefficient, modulus
        )
    assert all(reduce_t(value, modulus) == 0 for value in after_linear)

    # The residual affine parameter is the root of leading*s+constant.  Use
    # homogeneous coordinates [-constant:leading] to avoid inversion.
    residual_coordinates = [
        reduce_t(
            value.subs({s: -constant, v: leading}),
            modulus,
        )
        for value in specialized_basis
    ]
    coefficient_matrix = sp.Matrix(
        [
            [sp.Poly(value, t, domain=sp.QQ).coeff_monomial(t**power) for value in residual_coordinates]
            for power in range(4)
        ]
    )
    span_determinant = sp.factor(coefficient_matrix.det(method="berkowitz"))
    return {
        "seed": seed,
        "smooth_projective_surface_charts": smooth_charts,
        "cubic_coefficients": {"".join(map(str, key)): value for key, value in coefficients.items()},
        "tangency_polynomial": [int(value) for value in determinant_numerator.all_coeffs()],
        "tangency_polynomial_degree": determinant_numerator.degree(),
        "tangency_polynomial_discriminant": int(sp.discriminant(determinant_numerator.as_expr(), t)),
        "tangency_polynomial_galois_group": galois_group.name,
        "residual_coordinate_coefficients": [
            [str(sp.Poly(value, t, domain=sp.QQ).coeff_monomial(t**power)) for power in range(4)]
            for value in residual_coordinates
        ],
        "residual_span_determinant": str(span_determinant),
        "residual_points_coplanar": span_determinant == 0,
    }


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--seeds", type=int, default=3)
    args = parser.parse_args()
    results = [one_case(202608011300 + index) for index in range(args.seeds)]
    payload = {
        "format": "Q-SCHUR-QUARTIC-TANGENT-TWISTED-CUBIC-PROBE-v1",
        "scope": "deterministic cubic surfaces through four coordinate vertices",
        "construction": "twisted cubics double-contacting the surface at all four vertices",
        "results": results,
        "verdict": (
            "AUTOMATIC_COPLANARITY_SURVIVES"
            if all(result["residual_points_coplanar"] for result in results)
            else "AUTOMATIC_COPLANARITY_REFUTED"
        ),
        "boundary": (
            "these three serialized examples have split marked input vertices; "
            "the separate PARI/GP audit treats a primitive S4 input quartic; "
            "neither instantiates the unknown Schur quartic"
        ),
    }
    (HERE / "quartic_tangent_twisted_cubic_probe.json").write_text(
        json.dumps(payload, indent=2) + "\n"
    )
    print(json.dumps(payload, indent=2))


if __name__ == "__main__":
    main()
