#!/usr/bin/env python3
"""Independent exact audit of the tangent-twisted-cubic counterexample."""

from __future__ import annotations

import json
from pathlib import Path

import sympy as sp


HERE = Path(__file__).resolve().parent
DATA = json.loads((HERE / "quartic_tangent_twisted_cubic_probe.json").read_text())

assert DATA["format"] == "Q-SCHUR-QUARTIC-TANGENT-TWISTED-CUBIC-PROBE-v1"
assert DATA["verdict"] == "AUTOMATIC_COPLANARITY_REFUTED"
assert len(DATA["results"]) == 3
for result in DATA["results"]:
    assert result["smooth_projective_surface_charts"] == [True] * 4
    assert result["tangency_polynomial_degree"] == 4
    assert result["tangency_polynomial_discriminant"] != 0
    assert result["tangency_polynomial_galois_group"] == "S4"
    assert result["residual_points_coplanar"] is False
    assert sp.Rational(result["residual_span_determinant"]) != 0

# Rebuild the first example without importing the producer.
record = DATA["results"][0]
s, v, t, w = sp.symbols("s v t w")
lam = sp.symbols("l0:4")
x = sp.symbols("x0:4")

form = sp.Integer(0)
for key, coefficient in record["cubic_coefficients"].items():
    exponents = tuple(int(value) for value in key)
    form += coefficient * sp.prod(
        variable**exponent for variable, exponent in zip(x, exponents)
    )
form = sp.expand(form)
assert all(form.subs({variable: int(variable == x[index]) for variable in x}) == 0 for index in range(4))

partials = [sp.diff(form, variable) for variable in x]
for coordinate in x:
    remaining = [variable for variable in x if variable != coordinate]
    equations = [sp.expand(value.subs(coordinate, 1)) for value in (form, *partials)]
    assert sp.groebner(equations, *remaining, order="grevlex", domain=sp.QQ).contains(sp.Integer(1))

basis = (
    lam[0] * s * (s - v) * (s - t * v),
    lam[1] * v * (s - v) * (s - t * v),
    lam[2] * s * v * (s - t * v),
    lam[3] * s * v * (s - v),
)
pullback = sp.expand(form.subs(dict(zip(x, basis)), simultaneous=True))
locals_at_vertices = (
    sp.diff(pullback.subs(s, 1), v).subs(v, 0),
    sp.diff(pullback.subs(v, 1), s).subs(s, 0),
    sp.diff(pullback.subs({s: 1 + w, v: 1}), w).subs(w, 0),
    sp.diff(pullback.subs({s: t + w, v: 1}), w).subs(w, 0),
)
rows = []
for index, equation in enumerate(locals_at_vertices):
    polynomial = sp.Poly(sp.expand(sp.cancel(equation / lam[index] ** 2)), *lam)
    assert polynomial.total_degree() == 1
    rows.append([polynomial.coeff_monomial(variable) for variable in lam])
matrix = sp.Matrix(rows)

raw = sp.Poly(sp.cancel(matrix.det(method="berkowitz")).as_numer_denom()[0], t, domain=sp.QQ)
quotient, remainder = sp.div(raw.primitive()[1], sp.Poly(t**4 * (t - 1) ** 4, t, domain=sp.QQ))
assert remainder.is_zero
modulus = quotient.primitive()[1]
stored_modulus = sp.Poly.from_list(record["tangency_polynomial"], t, domain=sp.QQ)
assert modulus == stored_modulus
assert sp.discriminant(modulus.as_expr(), t) == record["tangency_polynomial_discriminant"]
assert sp.polys.numberfields.galois_group(modulus, t, by_name=True)[0].name == "S4"

def reduce_t(expression):
    return sp.rem(sp.Poly(sp.expand(expression), t, domain=sp.QQ), modulus).as_expr()

first_three = matrix[:3, :]
scales = [
    sp.factor((-1) ** column * first_three[:, [j for j in range(4) if j != column]].det(method="berkowitz"))
    for column in range(4)
]
specialized_basis = [sp.expand(value.subs(dict(zip(lam, scales)))) for value in basis]
specialized_pullback = sp.expand(form.subs(dict(zip(x, specialized_basis)), simultaneous=True))
affine = sp.Poly(specialized_pullback.subs(v, 1), s)
coefficients = [reduce_t(affine.coeff_monomial(s**power)) for power in range(10)]
base = sp.Poly(s**2 * (s - 1) ** 2 * (s - t) ** 2, s)
base_coefficients = [base.coeff_monomial(s**power) for power in range(7)]
leading = coefficients[7]
remainder_coefficients = list(coefficients)
for power, coefficient in enumerate(base_coefficients):
    remainder_coefficients[power + 1] = reduce_t(
        remainder_coefficients[power + 1] - leading * coefficient
    )
constant = remainder_coefficients[6]
for power, coefficient in enumerate(base_coefficients):
    remainder_coefficients[power] = reduce_t(
        remainder_coefficients[power] - constant * coefficient
    )
assert all(reduce_t(value) == 0 for value in remainder_coefficients)

computed_residual = [
    reduce_t(value.subs({s: -constant, v: leading})) for value in specialized_basis
]
stored_residual = []
for coordinate_coefficients in record["residual_coordinate_coefficients"]:
    stored_residual.append(
        sum(sp.Rational(value) * t**power for power, value in enumerate(coordinate_coefficients))
    )
assert all(reduce_t(left - right) == 0 for left, right in zip(computed_residual, stored_residual))
assert reduce_t(form.subs(dict(zip(x, stored_residual)), simultaneous=True)) == 0

coefficient_matrix = sp.Matrix(
    [
        [sp.Poly(value, t, domain=sp.QQ).coeff_monomial(t**power) for value in stored_residual]
        for power in range(4)
    ]
)
span_determinant = sp.factor(coefficient_matrix.det(method="berkowitz"))
assert span_determinant == sp.Rational(record["residual_span_determinant"])
assert span_determinant != 0

print("PASS exact cubic surface counterexample is projectively smooth")
print("PASS tangent twisted-cubic scheme is primitive S4 quartic")
print("PASS double contact leaves the serialized residual quartic")
print("PASS residual quartic spans P3 and is not automatically coplanar")
print("Q_SCHUR_TANGENT_TWISTED_CUBIC_SHORTCUT_REFUTED")
