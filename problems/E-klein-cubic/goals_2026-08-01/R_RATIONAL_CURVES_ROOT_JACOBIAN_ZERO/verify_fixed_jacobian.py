#!/usr/bin/env python3
"""Independent replay of the Klein intermediate-Jacobian fixed-point claim.

Unlike the producer, this verifier uses SymPy's quadratic number field
expressions and reconstructs both automorphisms directly from Roulleau's
five period vectors.  The JSON is used only as a comparison target after
the load-bearing determinant, Smith form, and quotient action are rebuilt.
"""

from __future__ import annotations

import json
from pathlib import Path

import sympy as sp
from sympy import Matrix, ZZ
from sympy.matrices.normalforms import smith_normal_form


HERE = Path(__file__).resolve().parent
PAYLOAD = HERE / "fixed_jacobian_payload.json"


def to_pair(x: sp.Expr, root: sp.Expr) -> tuple[int, int]:
    """Convert x to a+b*nu, nu=(-1+sqrt(-11))/2, and require a,b in Z."""
    x = sp.expand(x)
    c = sp.simplify(x.coeff(root))
    r = sp.simplify(x - c * root)
    b = sp.simplify(2 * c)
    a = sp.simplify(r + c)
    if not (a.is_Integer and b.is_Integer):
        raise AssertionError(f"not integral in Z[nu]: {x} -> ({a},{b})")
    return int(a), int(b)


def restrict_scalars(m: Matrix, root: sp.Expr) -> Matrix:
    z = sp.zeros(2 * m.rows)
    for i in range(m.rows):
        for j in range(m.cols):
            a, b = to_pair(m[i, j], root)
            z[2 * i, 2 * j] = a
            z[2 * i + 1, 2 * j] = b
            z[2 * i, 2 * j + 1] = -3 * b
            z[2 * i + 1, 2 * j + 1] = a - b
    return z


def main() -> None:
    data = json.loads(PAYLOAD.read_text())
    root = sp.sqrt(-11)
    nu = (-1 + root) / 2
    delta = 1 + 2 * nu

    t = sp.zeros(5)
    t[1, 0] = t[2, 1] = t[3, 2] = t[4, 3] = 1
    t[:, 4] = Matrix([1, 1 + nu, -1, 1, nu])

    e0 = Matrix([1, 0, 0, 0, 0])
    s = Matrix.hstack(*[(t**n) * e0 for n in (0, 5, 10, 4, 9)])
    b = Matrix.hstack(
        Matrix([1, -3, 3, -1, 0]) / delta,
        Matrix([0, 1, -3, 3, -1]) / delta,
        e0,
        Matrix([0, 1, 0, 0, 0]),
        Matrix([0, 0, 1, 0, 0]),
    )
    tl = sp.simplify(b.inv() * t * b)
    sl = sp.simplify(b.inv() * s * b)
    tz = restrict_scalars(tl, root)
    sz = restrict_scalars(sl, root)

    assert tz == Matrix(data["tau_Z_matrix"])
    assert sz == Matrix(data["sigma_Z_matrix"])
    ident = sp.eye(10)
    assert tz**11 == ident
    assert sz**5 == ident
    assert sz * tz * sz.inv() == tz**5

    a = tz - ident
    assert abs(int(a.det())) == 11
    smith = smith_normal_form(a, domain=ZZ)
    diag = [abs(int(smith[i, i])) for i in range(10)]
    assert diag == [1] * 9 + [11]

    # adj(A) A = det(A) I gives a nonzero quotient character modulo 11.
    adj = a.adjugate()
    ell = next(
        [int(adj[i, j]) % 11 for j in range(10)]
        for i in range(10)
        if any(int(adj[i, j]) % 11 for j in range(10))
    )
    assert all(sum(ell[i] * int(a[i, j]) for i in range(10)) % 11 == 0 for j in range(10))

    transport = sz * sum((tz**i for i in range(9)), sp.zeros(10))
    image = [sum(ell[i] * int(transport[i, j]) for i in range(10)) % 11 for j in range(10)]
    pivot = next(i for i, x in enumerate(ell) if x)
    scalar = image[pivot] * pow(ell[pivot], -1, 11) % 11
    assert image == [(scalar * x) % 11 for x in ell]
    assert scalar in {3, 4, 5, 9}
    assert scalar == data["sigma_on_J_tau"]["scalar_mod_11"]
    assert data["sigma_on_J_tau"]["fixed_subgroup_order"] == 1

    print(f"independent smith diagonal: {diag}")
    print(f"independent normalizer scalar on J^tau: {scalar} mod 11")
    print("R_FIXED_JACOBIAN_INDEPENDENT_VERIFY_OK")


if __name__ == "__main__":
    main()
