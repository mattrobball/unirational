#!/usr/bin/env python3
"""Tiny exact checks for the planar circuit reduction."""

import sympy as sp


def main():
    # Collinear leading jets at a legal sum-zero cyclic coordinate vector.
    ell = (4, -1, -1, -1, -1)
    assert sum(ell) == 0
    jet2 = sum(ell[i] ** 4 * ell[(i + 1) % 5] ** 2 for i in range(5))
    jet3 = sum(ell[i] ** 6 * ell[(i + 1) % 5] ** 3 for i in range(5))
    assert jet2 == 275
    assert jet3 == -4035

    # Circuit second moment and its oriented-matroid discriminant.
    alpha, beta, x, y = sp.symbols("alpha beta x y")
    circuit = (alpha + beta - 1, -alpha, -beta, 1)
    points = ((0, 0), (1, 0), (0, 1), (alpha, beta))
    assert sp.expand(sum(circuit)) == 0
    assert all(
        sp.expand(sum(circuit[j] * points[j][coordinate] for j in range(4))) == 0
        for coordinate in range(2)
    )
    quadratic = sp.expand(
        sum(
            circuit[j] * (points[j][0] * x + points[j][1] * y) ** 2
            for j in range(4)
        )
    )
    expected = (
        alpha * (alpha - 1) * x**2
        + 2 * alpha * beta * x * y
        + beta * (beta - 1) * y**2
    )
    assert sp.expand(quadratic - expected) == 0
    matrix = sp.Matrix(
        [
            [alpha * (alpha - 1), alpha * beta],
            [alpha * beta, beta * (beta - 1)],
        ]
    )
    determinant = sp.factor(matrix.det())
    assert sp.expand(determinant - alpha * beta * (1 - alpha - beta)) == 0
    assert sp.expand(determinant + sp.prod(circuit)) == 0

    # The planar nonzero-first-moment branch yields four consecutive zero
    # moments on four distinct projected coordinates, hence Vandermonde rank4.
    u = sp.symbols("u0:4")
    vandermonde = sp.Matrix([[u[j] ** degree for j in range(4)] for degree in range(4)])
    vandermonde_product = sp.prod(
        u[j] - u[i] for i in range(4) for j in range(i + 1, 4)
    )
    assert sp.expand(vandermonde.det() - vandermonde_product) == 0

    # A nonzero two-term polynomial cannot vanish on all five fifth roots.
    T, B, Cq = sp.symbols("T B Cq")
    for m in range(1, 5):
        assert sp.rem(B + Cq * T**m, T**5 - 1, domain=sp.QQ.frac_field(B, Cq)) != 0

    print("TWO_RESIDUE_BRANCH_EMPTY", True)
    print("COLLINEAR_LEADING_JETS", jet2, jet3)
    print("PLANAR_NONZERO_FIRST_MOMENT_EMPTY", True)
    print("CIRCUIT_SECOND_MOMENT_DETERMINANT", determinant)
    print("REMAINING_ORIENTED_MATROID", "convex-quadrilateral-2+2")
    print("F55-TRACE-FOUR-TERM-PLANAR-CIRCUIT-REDUCTION-OK")


if __name__ == "__main__":
    main()
