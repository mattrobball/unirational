#!/usr/bin/env python3
"""Search for a reduced determinant in the three doubled-jet stratum.

This is an exact rational-arithmetic check for the ambient tangent-space
example in determinant_fiber_limits.md.  A symmetric 3 by 3 cubic matrix A
restricts to a section q of Sym^2(Omega^1(1))^vee(3); its determinant on the
Euler kernel is x^t adj(A) x.  We impose that q have vanishing 1-jet (hence
vanish to order at least two) at the three coordinate points, then search the
resulting rational linear space.
"""

import random
import sympy as sp


x, y, z = sp.symbols("x y z")
xyz = (x, y, z)
monoms = (
    x**3,
    x**2 * y,
    x**2 * z,
    x * y**2,
    x * y * z,
    x * z**2,
    y**3,
    y**2 * z,
    y * z**2,
    z**3,
)
coeffs = sp.symbols("c0:60")
forms = [sum(coeffs[10 * i + j] * monoms[j] for j in range(10)) for i in range(6)]
A00, A01, A02, A11, A12, A22 = forms


def one_jet(expr, substitutions, local_vars):
    local = sp.expand(expr.subs(substitutions))
    origin = {local_vars[0]: 0, local_vars[1]: 0}
    return [
        local.subs(origin),
        sp.diff(local, local_vars[0]).subs(origin),
        sp.diff(local, local_vars[1]).subs(origin),
    ]


conditions = []

# At [0:0:1], use the Euler-kernel frame (1,0,-x), (0,1,-y).
qz = (
    A00 - 2 * x * A02 + x**2 * A22,
    A01 - y * A02 - x * A12 + x * y * A22,
    A11 - 2 * y * A12 + y**2 * A22,
)
for entry in qz:
    conditions.extend(one_jet(entry, {z: 1}, (x, y)))

# At [1:0:0], use (-y,1,0), (-z,0,1).
qx = (
    y**2 * A00 - 2 * y * A01 + A11,
    y * z * A00 - z * A01 - y * A02 + A12,
    z**2 * A00 - 2 * z * A02 + A22,
)
for entry in qx:
    conditions.extend(one_jet(entry, {x: 1}, (y, z)))

# At [0:1:0], use (1,-x,0), (0,-z,1).
qy = (
    A00 - 2 * x * A01 + x**2 * A11,
    A02 - z * A01 - x * A12 + x * z * A11,
    A22 - 2 * z * A12 + z**2 * A11,
)
for entry in qy:
    conditions.extend(one_jet(entry, {y: 1}, (x, z)))

constraint_matrix, rhs = sp.linear_eq_to_matrix(conditions, coeffs)
assert rhs == sp.zeros(len(conditions), 1)
nullspace = constraint_matrix.nullspace()
print(f"doubled-jet constraint rank/nullity: {constraint_matrix.rank()}/{len(nullspace)}")


def specialize(vector):
    table = dict(zip(coeffs, vector))
    return [sp.expand(f.subs(table)) for f in forms]


def branch(polys):
    a00, a01, a02, a11, a12, a22 = polys
    return sp.expand(
        x**2 * (a11 * a22 - a12**2)
        + y**2 * (a00 * a22 - a02**2)
        + z**2 * (a00 * a11 - a01**2)
        + 2 * x * y * (a02 * a12 - a01 * a22)
        + 2 * x * z * (a01 * a12 - a02 * a11)
        + 2 * y * z * (a01 * a02 - a00 * a12)
    )


def is_squarefree(poly):
    base = sp.Poly(poly, *xyz, domain=sp.QQ)
    common = base
    for variable in xyz:
        common = sp.gcd(common, sp.Poly(sp.diff(poly, variable), *xyz, domain=sp.QQ))
    return common.total_degree() == 0


def multiplicity(poly, substitutions, local_vars):
    local = sp.Poly(sp.expand(poly.subs(substitutions)), *local_vars)
    return min(sum(exponents) for exponents, coefficient in local.terms() if coefficient)


rng = random.Random(20260722)
witness = None
for attempt in range(1, 101):
    weights = [rng.randint(-2, 2) for _ in nullspace]
    if not any(weights):
        continue
    vector = sp.zeros(60, 1)
    for weight, basis_vector in zip(weights, nullspace):
        vector += weight * basis_vector
    polys = specialize(vector)
    determinant = branch(polys)
    if determinant != 0 and is_squarefree(determinant):
        witness = (attempt, polys, determinant)
        break

assert witness is not None
attempt, polys, determinant = witness
print(f"first reduced witness attempt: {attempt}")
for label, poly in zip(("A00", "A01", "A02", "A11", "A12", "A22"), polys):
    print(f"{label} = {poly}")
print(f"B = {determinant}")
mults = [
    multiplicity(determinant, {z: 1}, (x, y)),
    multiplicity(determinant, {x: 1}, (y, z)),
    multiplicity(determinant, {y: 1}, (x, z)),
]
assert mults == [4, 4, 4]
print(f"coordinate-point multiplicities: {mults}")
print("gcd(B,dB/dx,dB/dy,dB/dz) = 1")
print("all doubled-jet and reducedness checks passed")
