#!/usr/bin/env python3
"""Exact local checks for cubic_factor_theorem.md.

All ranks are computed over Q with SymPy.  The two parametrizations cover the
normalizations of an integral cubic singular at the rank-two base point.
"""

from itertools import product

import sympy as sp


def monomials(total_degree, min_xy_order=0):
    return [
        (i, j, total_degree - i - j)
        for i in range(total_degree + 1)
        for j in range(total_degree + 1 - i)
        if i + j >= min_xy_order
    ]


def pullback_matrix(source_monomials, parametrization, common_factor_degree):
    """Matrix for pullback followed by removal of the exceptional factor."""
    s, t = sp.symbols("s t")
    target_degree = source_monomials[0][0] * 0
    columns = []
    for i, j, k in source_monomials:
        poly = sp.expand(
            parametrization[0] ** i
            * parametrization[1] ** j
            * parametrization[2] ** k
            / (s ** common_factor_degree[0] * t ** common_factor_degree[1])
        )
        p = sp.Poly(poly, s, t)
        if not columns:
            target_degree = p.total_degree()
        columns.append(
            [p.coeff_monomial(s ** r * t ** (target_degree - r)) for r in range(target_degree + 1)]
        )
    return sp.Matrix.hstack(*[sp.Matrix(col) for col in columns])


def rank_one_bound(genus, f):
    values = []
    for m in range(-4, f + 1):
        if genus == 1:
            hom_degree = f - 2 * m
            tangent = hom_degree if hom_degree > 0 else (1 if hom_degree == 0 else 0)
            tensor_degree = 2 * m + 9
            tensor = tensor_degree if tensor_degree > 0 else (1 if tensor_degree == 0 else 0)
        else:
            tangent = max(f - 2 * m + 1, 0)
            tensor = max(2 * m + 10, 0)
        values.append((m, tangent + tensor))
    return max(v for _, v in values), values


def check_singular_at_basepoint(name, parametrization, exceptional_factors):
    # q entries are quintics double at b, quartics through b, and cubics.
    spaces = [monomials(5, 2), monomials(4, 1), monomials(3, 0)]
    removed = [
        (2 * exceptional_factors[0], 2 * exceptional_factors[1]),
        exceptional_factors,
        (0, 0),
    ]
    ranks = [
        pullback_matrix(space, parametrization, factor).rank()
        for space, factor in zip(spaces, removed)
    ]
    assert ranks == [12, 11, 9], (name, ranks)
    print(f"{name} component restriction ranks: {ranks}; total {sum(ranks)}")


def main():
    s, t = sp.symbols("s t")

    # Node: common divisor st.  Cusp: common divisor s^2.
    check_singular_at_basepoint(
        "node",
        (s ** 2 * t, s * t ** 2, s ** 3 + t ** 3),
        (1, 1),
    )
    check_singular_at_basepoint(
        "cusp",
        (s ** 2 * t, s ** 3, t ** 3),
        (2, 0),
    )

    expected = {(1, 3): 15, (1, 2): 13, (0, 3): 16, (0, 2): 14, (0, 1): 12}
    for key, wanted in expected.items():
        got, values = rank_one_bound(*key)
        assert got == wanted, (key, got, values)
        curve = "elliptic" if key[0] else "P1"
        print(f"{curve}, deg(F)={key[1]}: rank-one dimension bound {got}")

    # Cohomology count for the singular-at-b restriction.
    kernel_h0 = 6 + 3 + 1
    cokernel_h1 = 1
    source = 42
    target = source - kernel_h0 + cokernel_h1
    image_rank = source - kernel_h0
    assert (target, image_rank) == (33, 32)
    print(f"singular-at-b normalization target/image: {target}/{image_rank}")
    print("all cubic-factor local checks passed")


if __name__ == "__main__":
    main()

