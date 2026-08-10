#!/usr/bin/env python3
"""Fixed symbolic checks for the rank-three cyclic-cover audit.

There is no curve-degree or Laurent-support search.  The only elimination
checks are the analytically unique degree-two contact matrix and one
distinguished fully adjacent degree-three matrix.
"""

from itertools import combinations

import sympy as sp


zeta = sp.symbols("zeta")
phi5 = zeta**4 + zeta**3 + zeta**2 + zeta + 1


def reduce_zeta(expression):
    return sp.Poly(sp.expand(expression), zeta, domain="EX").rem(
        sp.Poly(phi5, zeta, domain="EX")
    ).as_expr()


def maximal_minors(matrix):
    row_count, column_count = matrix.shape
    assert row_count >= column_count
    answer = []
    for rows in combinations(range(row_count), column_count):
        determinant = sp.factor(
            reduce_zeta(matrix.extract(rows, range(column_count)).det())
        )
        if determinant != 0:
            answer.append(determinant)
    return answer


def main():
    # Projective-torus determinant: Phi_5(-2)=11.
    assert sp.expand(phi5.subs(zeta, -2)) == 11

    # The local D5 principal part has all required coefficients nonzero for
    # every cyclotomic conjugate q.
    for q in range(1, 5):
        A = reduce_zeta(zeta ** ((4 * q) % 5) - 1)
        B = reduce_zeta(zeta ** ((2 * q) % 5) - 1)
        C = reduce_zeta(zeta ** ((3 * q) % 5) - 1)
        assert A != 0 and B != 0 and C != 0

    # Exact rational boundary quartic for q=1.
    s, t, rho, kappa = sp.symbols("s t rho kappa")
    x = (0, kappa * s**3 * t, rho * s**2 * t**2, s**4, t**4)
    b = tuple(sp.expand(x[i] ** 2 * x[(i + 1) % 5]) for i in range(5))
    substitutions = {rho**2: -(1 + zeta), kappa**2 * rho: zeta}
    # Apply the two defining scalar relations directly.
    b_reduced = (
        0,
        zeta * s**8 * t**4,
        -(1 + zeta) * s**8 * t**4,
        s**8 * t**4,
        0,
    )
    assert sp.expand(b[0]) == 0 and sp.expand(b[4]) == 0
    assert sp.expand(b[1].subs(kappa**2 * rho, zeta) - b_reduced[1]) == 0
    assert sp.expand(b[2].subs(rho**2, -(1 + zeta)) - b_reduced[2]) == 0
    assert sp.expand(b[3] - b_reduced[3]) == 0
    assert reduce_zeta(sum(b_reduced)) == 0
    assert reduce_zeta(sum(zeta**i * b_reduced[i] for i in range(5))) == 0

    # Analytically unique degree-two contact type.
    lam = sp.symbols("lam")
    conic_columns = (
        (0, 0, 1),
        (-1, 1, 0),
        (1, -2, 1),
        (-lam, 1, 0),
        (lam**2, -2 * lam, 1),
    )
    conic_matrix = sp.Matrix(
        [[conic_columns[j][r] for j in range(5)] for r in range(3)]
        + [
            [zeta**j * conic_columns[j][r] for j in range(5)]
            for r in range(3)
        ]
    )
    conic_ideal = sp.groebner(
        [phi5, *maximal_minors(conic_matrix)], lam, zeta, order="lex"
    )
    assert any(polynomial.as_expr() == 1 for polynomial in conic_ideal.polys)

    # Distinguished fully adjacent cubic contact pattern.
    X, Y, u, v = sp.symbols("X Y u v")
    roots = (Y, Y - X, X, Y - u * X, Y - v * X)
    cubics = tuple(
        sp.expand(roots[i] * roots[(i - 1) % 5] ** 2) for i in range(5)
    )
    monomials = (X**3, X**2 * Y, X * Y**2, Y**3)
    cubic_columns = tuple(
        tuple(sp.Poly(cubic, X, Y).coeff_monomial(monomial) for monomial in monomials)
        for cubic in cubics
    )
    cubic_matrix = sp.Matrix(
        [[cubic_columns[j][r] for j in range(5)] for r in range(4)]
        + [
            [zeta**j * cubic_columns[j][r] for j in range(5)]
            for r in range(4)
        ]
    )
    cubic_ideal = sp.groebner(
        [phi5, *maximal_minors(cubic_matrix)], u, v, zeta, order="lex"
    )
    assert any(polynomial.as_expr() == 1 for polynomial in cubic_ideal.polys)

    print("RANK3_COVER_PROJECTIVE_TORUS_DEGREE", 11)
    print("RANK3_COVER_LOCAL_SINGULARITY", "D5", "COUNT", 5)
    print("RANK3_COVER_BOUNDARY_QUARTIC_OK")
    print("RANK3_COVER_MINIMAL_CONIC_CONTACT_EMPTY")
    print("RANK3_COVER_FULLY_ADJACENT_CUBIC_EMPTY_SCOPED")
    print("F55-TRACE-RANK3-COVER-STRUCTURAL-AUDIT-OK")


if __name__ == "__main__":
    main()
