#!/usr/bin/env python3
"""Verify the primitive-S4 input tangent-twisted-cubic counterexample."""

from __future__ import annotations

import subprocess
from pathlib import Path

import sympy as sp


HERE = Path(__file__).resolve().parent
u = sp.symbols("u")
x = sp.symbols("x0:4")
q = sp.Poly(u**4 - u + 1, u, domain=sp.QQ)

assert q.is_irreducible
assert sp.discriminant(q.as_expr(), u) == 229
assert sp.polys.numberfields.galois_group(q, u, by_name=True)[0].name == "S4"

F = (
    x[0] ** 3
    - x[0] ** 2 * x[1]
    + x[0] ** 2 * x[2]
    - x[0] ** 2 * x[3]
    - x[0] * x[1] ** 2
    + 3 * x[0] * x[1] * x[2]
    + x[0] * x[1] * x[3]
    - 3 * x[0] * x[2] ** 2
    + x[0] * x[2] * x[3]
    + x[0] * x[3] ** 2
    - 2 * x[1] ** 3
    + 3 * x[1] ** 2 * x[2]
    + 2 * x[1] ** 2 * x[3]
    - 3 * x[1] * x[2] ** 2
    + 3 * x[1] * x[3] ** 2
    - x[2] ** 3
    - 3 * x[2] ** 2 * x[3]
)
assert sp.expand(F.subs(dict(zip(x, (1, u, u**2, u**3))))) == q.as_expr()

# Power-basis coordinates make the four conjugates linearly independent.
# Check projective smoothness independently in all four standard charts.
partials = [sp.diff(F, variable) for variable in x]
for coordinate in x:
    remaining = [variable for variable in x if variable != coordinate]
    equations = [sp.expand(value.subs(coordinate, 1)) for value in (F, *partials)]
    assert sp.groebner(
        equations, *remaining, order="grevlex", domain=sp.QQ
    ).contains(sp.Integer(1))

# This counterexample isolates the operation rather than pointlessness.
assert F.subs({x[0]: 0, x[1]: 0, x[2]: 0, x[3]: 1}) == 0

completed = subprocess.run(
    ["gp", "-q", "-s", "512M", "probe_primitive_quartic_tangent.gp"],
    cwd=HERE,
    text=True,
    stdout=subprocess.PIPE,
    stderr=subprocess.STDOUT,
    check=True,
)
marker = "Q_SCHUR_PRIMITIVE_INPUT_TANGENT_COPLANARITY_REFUTED"
assert "***" not in completed.stdout, completed.stdout
assert marker in completed.stdout, completed.stdout
expected_log = [
    "q=x^4-x+1",
    "splitting_field_degree=24",
    "tangency_degree=4",
    "tangency_discriminant_nonzero=1",
    "residual_span_nonzero=1",
    marker,
]
assert (HERE / "primitive_quartic_tangent_probe.log").read_text().splitlines() == expected_log

print("PASS q=x^4-x+1 is primitive with S4 Galois closure")
print("PASS quartic power-basis point lies on the exact smooth cubic surface")
print("PASS clean degree-24 splitting-field tangent computation")
print("PASS primitive-input residual quartic spans P3")
print(marker)
