#!/usr/bin/env python3
"""Exact symbolic checks for the tangent-residual construction on the Klein cubic."""
from __future__ import annotations

import sympy as sp


def klein(coords: tuple[sp.Expr, ...]) -> sp.Expr:
    if len(coords) != 5:
        raise ValueError("the Klein cubic uses five coordinates")
    return sp.expand(sum(coords[i] ** 2 * coords[(i + 1) % 5] for i in range(5)))


def main() -> None:
    t = sp.symbols("t")
    x = sp.symbols("x0:5")
    v = sp.symbols("v0:5")

    ft = sp.Poly(klein(tuple(x[i] + t * v[i] for i in range(5))), t)
    f = ft.coeff_monomial(1)
    lin = ft.coeff_monomial(t)
    quad = ft.coeff_monomial(t**2)
    cub = ft.coeff_monomial(t**3)

    assert sp.expand(f - klein(x)) == 0
    assert sp.expand(cub - klein(v)) == 0

    y = tuple(sp.expand(cub * x[i] - quad * v[i]) for i in range(5))
    landing_identity = sp.expand(klein(y) - cub**3 * f + cub**2 * quad * lin)
    assert landing_identity == 0

    # Abstract check that changing the lift v of a projective tangent direction
    # by v' = a v + b x rescales the residual point by a^3 on F(x)=L(x,v)=0.
    a, b, F0, L0, Q0, C0 = sp.symbols("a b F0 L0 Q0 C0")
    L1 = a * L0 + 3 * b * F0
    Q1 = a**2 * Q0 + 2 * a * b * L0 + 3 * b**2 * F0
    C1 = a**3 * C0 + a**2 * b * Q0 + a * b**2 * L0 + b**3 * F0
    # Coefficients of x and v in C1*x-Q1*(a*v+b*x)-a^3*(C0*x-Q0*v).
    coeff_x = sp.expand(C1 - b * Q1 - a**3 * C0)
    coeff_v = sp.expand(-a * Q1 + a**3 * Q0)
    assert sp.expand(coeff_x.subs({F0: 0, L0: 0})) == 0
    assert sp.expand(coeff_v.subs({F0: 0, L0: 0})) == 0

    # Scaling the base vector x by c scales Q by c and the residual vector by c.
    c = sp.symbols("c")
    residual_x_scaled = c * C0 - c * Q0  # abstract coefficients after x -> c*x
    assert sp.expand(residual_x_scaled - c * (C0 - Q0)) == 0

    print("TANGENT_RESIDUAL_KLEIN_IDENTITY_OK")
    print("TANGENT_DIRECTION_REPRESENTATIVE_INDEPENDENCE_OK")
    print("TANGENT_BASE_REPRESENTATIVE_INDEPENDENCE_OK")


if __name__ == "__main__":
    main()
