#!/usr/bin/env python3
"""Exact checks for the dimension table and the twisted-cubic tangent minor."""

import sympy as sp


TARGETS = [
    (4, 4, 2, 5, 8),
    (4, 4, 3, 7, 10),
    (5, 5, 2, 6, 9),
    (5, 5, 3, 8, 11),
    (4, 5, 2, 3, 6),
    (4, 5, 3, 4, 7),
    (5, 6, 2, 4, 7),
]


def check_dimensions() -> None:
    for n, d, e, expected_curve, expected_maps in TARGETS:
        curve = e * (n + 2 - d) + n - 3
        maps = curve + 3
        assert (curve, maps) == (expected_curve, expected_maps)
        print(f"({n},{d},{e}): curve={curve}, projective_maps={maps}")


def check_twisted_cubic_minor() -> None:
    s, t = sp.symbols("s t")
    xs = sp.symbols("x0:6")
    x0, x1, x2, x3, x4, x5 = xs
    q1 = x0 * x2 - x1**2
    q3 = x1 * x3 - x2**2
    quintic = q1 * x0 * x2**2 + q3 * x2 * x3**2 + x4 * x0**4 + x5 * x3**4
    parametrization = {
        x0: s**3,
        x1: s**2 * t,
        x2: s * t**2,
        x3: t**3,
        x4: 0,
        x5: 0,
    }
    gs = [
        s**6 * t**6,
        -2 * s**7 * t**5 + s * t**11,
        s**8 * t**4 - 2 * s**2 * t**10,
        s**3 * t**9,
        s**12,
        t**12,
    ]
    assert sp.expand(quintic.subs(parametrization)) == 0
    restricted_partials = [
        sp.expand(sp.diff(quintic, variable).subs(parametrization))
        for variable in xs
    ]
    assert all(sp.expand(actual - expected) == 0 for actual, expected in zip(restricted_partials, gs))

    basis = [s ** (15 - k) * t**k for k in range(16)]
    columns = []
    labels = []
    for i, g in enumerate(gs):
        for j in range(4):
            polynomial = sp.Poly(sp.expand(g * s ** (3 - j) * t**j), s, t)
            columns.append([polynomial.coeff_monomial(m) for m in basis])
            labels.append((i, j))

    matrix = sp.Matrix(16, 24, lambda row, col: columns[col][row])
    selected_labels = (
        [(0, j) for j in range(4)]
        + [(1, j) for j in range(4)]
        + [(2, j) for j in range(2)]
        + [(3, 1)]
        + [(4, j) for j in range(4)]
        + [(5, 3)]
    )
    selected = [labels.index(label) for label in selected_labels]
    determinant = matrix[:, selected].det()
    assert determinant == -3
    assert matrix.rank() == 16
    print(f"twisted-cubic tangent minor determinant={determinant}, rank=16")


if __name__ == "__main__":
    check_dimensions()
    check_twisted_cubic_minor()
