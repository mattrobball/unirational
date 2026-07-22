#!/usr/bin/env python3
"""Exact multiplication-map ranks used in square_line_theorem.md.

The matrices have integer entries and SymPy computes their ranks over Q.
These checks corroborate the uniform polynomial arguments in the theorem;
they are not a finite-field specialization certificate.
"""

from __future__ import annotations

import sympy as sp


s, t = sp.symbols("s t")
x0, x1, x2, y0, y1, y2 = sp.symbols("x0 x1 x2 y0 y1 y2")


def basis(degree: int) -> list[sp.Expr]:
    return [s**i * t ** (degree - i) for i in range(degree + 1)]


def map_rank(columns: list[sp.Expr], target_degree: int) -> int:
    rows: list[list[sp.Expr]] = []
    expanded = [sp.Poly(sp.expand(f), s, t, domain=sp.QQ) for f in columns]
    for monomial in basis(target_degree):
        powers = sp.Poly(monomial, s, t).monoms()[0]
        rows.append([f.coeff_monomial(powers) for f in expanded])
    return int(sp.Matrix(rows).rank())


def compositions(total: int, length: int) -> list[tuple[int, ...]]:
    if length == 1:
        return [(total,)]
    return [
        (first,) + tail
        for first in range(total + 1)
        for tail in compositions(total - first, length - 1)
    ]


def bidegree_basis(x_degree: int, y_degree: int) -> list[sp.Expr]:
    xs = (x0, x1, x2)
    ys = (y0, y1, y2)
    return [
        sp.prod(var**power for var, power in zip(xs, xp))
        * sp.prod(var**power for var, power in zip(ys, yp))
        for xp in compositions(x_degree, 3)
        for yp in compositions(y_degree, 3)
    ]


def multivariate_span_rank(columns: list[sp.Expr], target: list[sp.Expr]) -> int:
    variables = (x0, x1, x2, y0, y1, y2)
    polys = [sp.Poly(sp.expand(f), *variables, domain=sp.QQ) for f in columns]
    rows: list[list[sp.Expr]] = []
    for monomial in target:
        powers = sp.Poly(monomial, *variables).monoms()[0]
        rows.append([f.coeff_monomial(powers) for f in polys])
    return int(sp.Matrix(rows).rank())


def main() -> None:
    # Rank-three sigma, line not involving any basepoint.
    # Factor type d=1: u has degree 2, v degree 1, and they are coprime.
    u, v = t**2, s
    cols = (
        [v**2 * m for m in basis(4)]
        + [-2 * u * v * m for m in basis(3)]
        + [u**2 * m for m in basis(2)]
    )
    assert map_rank(cols, 6) == 7
    print("rank-3 d=1 normal map: rank 7")

    # Factor type d=3: u has degree 1 and v is a nonzero constant.
    u, v = t, sp.Integer(1)
    cols = (
        [v**2 * m for m in basis(4)]
        + [-2 * u * v * m for m in basis(3)]
        + [u**2 * m for m in basis(2)]
    )
    assert map_rank(cols, 4) == 5
    print("rank-3 d=3 normal map: rank 5")

    # Boundary components diag(a,0) and diag(0,c).
    assert map_rank([t**5 * m for m in basis(2)], 7) == 3
    assert map_rank([t**3 * m for m in basis(4)], 7) == 5
    print("rank-3 diagonal boundaries: ranks 3 and 5")

    # Rank-two sigma and a line through its basepoint.
    # d=1 has u,v a basis of H^0(O(1)).  The minimum occurs when y0 is
    # proportional to v; a nonproportional y0 gives rank 6.
    u, v = t, s
    for line_coordinate, expected in ((s, 5), (s + t, 6)):
        cols = (
            [line_coordinate * v**2 * m for m in basis(2)]
            + [-2 * line_coordinate * u * v * m for m in basis(2)]
            + [line_coordinate * u**2 * m for m in basis(2)]
            + [-2 * v**2 * m for m in basis(3)]
            + [2 * u * v * m for m in basis(3)]
        )
        assert map_rank(cols, 5) == expected
    print("rank-2 through-basepoint d=1 normal map: minimum rank 5")

    # d=3 with v nonzero: the A01/A02 terms already span H^0(O(3)).
    u, v, line_coordinate = sp.Integer(1), sp.Integer(1), s
    cols = (
        [line_coordinate * v**2 * m for m in basis(2)]
        + [-2 * line_coordinate * u * v * m for m in basis(2)]
        + [line_coordinate * u**2 * m for m in basis(2)]
        + [-2 * v**2 * m for m in basis(3)]
        + [2 * u * v * m for m in basis(3)]
    )
    assert map_rank(cols, 3) == 4
    print("rank-2 through-basepoint d=3 normal map: rank 4")

    # Boundary diag(a,0): y0*a*gamma.  Boundary diag(0,c): the A01 term
    # alone spans c*H^0(O(3)).
    assert map_rank([s * t**3 * m for m in basis(2)], 6) == 3
    assert map_rank([t**3 * m for m in basis(3)], 6) == 4
    print("rank-2 through-basepoint diagonal boundaries: ranks 3 and 4")

    # Compute the bidegree-(2,3) quotient by the canonical incidence equation
    # H and the doubled-line equation y2^2.  This directly checks the target
    # dimension used in the rank-three restriction argument.
    H = x0 * y0 + x1 * y1 + x2 * y2
    ambient = bidegree_basis(2, 3)
    ideal_columns = (
        [H * m for m in bidegree_basis(1, 2)]
        + [y2**2 * m for m in bidegree_basis(2, 1)]
    )
    ideal_rank = multivariate_span_rank(ideal_columns, ambient)
    assert len(ambient) == 60
    assert ideal_rank == 33
    assert len(ambient) - ideal_rank == 27
    print("double-line restriction dimension: 27")
    print("all squared-line local checks passed")


if __name__ == "__main__":
    main()
