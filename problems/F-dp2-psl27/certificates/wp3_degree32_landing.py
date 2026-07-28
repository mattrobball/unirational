#!/usr/bin/env python3
"""Exact landing/support exclusion of the degree-32 covariant space.

Modulo the Klein quartic F=0, the complete degree-32 covariant depends
only on the coefficients P,U of D^4*psi and C*f18.  The pullback F(p)
has weight 128.  Its F-free invariant space has basis

    D^19*C, D^12*C^4, D^5*C^7.

This script reconstructs all three coefficients exactly in the field
Q[z]/(z^3+z+1), obtained by restricting to x=y=1 on F=0.  The displayed
3-by-3 restriction matrix is invertible, so this determines the global
F-free invariant coefficients, not merely their values at sample points.

SymPy is the only non-standard dependency.
"""

from __future__ import annotations

import sympy as sp

import wp3_covariant_exclusions as base


A, B, P, Q, R, S, T, U = sp.symbols("A B P Q R S T U")
PARAMETERS = (P, U)

# On the exact slice x=y=1, the equation F=0 becomes z^3+z+1=0.
MODULUS = sp.Poly(base.z**3 + base.z + 1, base.z, domain=sp.QQ)
DOMAIN = sp.QQ.frac_field(*PARAMETERS)


def reduce_on_quartic(expression: sp.Expr, domain=DOMAIN) -> sp.Expr:
    specialized = sp.expand(expression.subs({base.x: 1, base.y: 1}))
    return sp.rem(
        sp.Poly(specialized, base.z, domain=domain), MODULUS
    ).as_expr()


def coefficient_vector(expression: sp.Expr) -> sp.Matrix:
    polynomial = sp.Poly(reduce_on_quartic(expression), base.z)
    return sp.Matrix([
        polynomial.coeff_monomial(base.z**degree) for degree in range(3)
    ])


def q4(vector: sp.Matrix) -> sp.Expr:
    return sp.expand(
        vector[0]**3 * vector[1]
        + vector[1]**3 * vector[2]
        + vector[2]**3 * vector[0]
    )


def main() -> None:
    restricted_covariant = P * base.D**4 * base.psi + U * base.C * base.f18
    coordinates = [
        reduce_on_quartic(restricted_covariant[index]) for index in range(3)
    ]
    pullback = reduce_on_quartic(q4(sp.Matrix(coordinates)))

    D0 = reduce_on_quartic(base.D)
    C0 = reduce_on_quartic(base.C)
    invariant_basis = [
        reduce_on_quartic(D0**19 * C0),
        reduce_on_quartic(D0**12 * C0**4),
        reduce_on_quartic(D0**5 * C0**7),
    ]
    restriction_matrix = sp.Matrix.hstack(*[
        coefficient_vector(item) for item in invariant_basis
    ])
    assert restriction_matrix.det() != 0

    solved = restriction_matrix.inv() * coefficient_vector(pullback)
    expected = sp.Matrix([
        -108 * P**3 * (P + 1568 * U),
        14 * U * (
            P**3 - 3024 * P**2 * U + 1016064 * P * U**2
            + 303464448 * U**3
        ),
        -2744 * U**3 * (5 * P + 1064 * U),
    ])
    assert all(sp.expand(left - right) == 0 for left, right in zip(solved, expected))
    assert coefficient_vector(
        pullback - sum(
            (coefficient * invariant for coefficient, invariant in zip(
                solved, invariant_basis
            )),
            sp.S.Zero,
        )
    ) == sp.zeros(3, 1)
    print("EXACT d=32: F-free pullback coefficients reconstructed")
    print("  [D^19*C]   =", sp.factor(solved[0]))
    print("  [D^12*C^4] =", sp.factor(solved[1]))
    print("  [D^5*C^7]  =", sp.factor(solved[2]))

    # Modulo F, an invariant square root of weight 64 is a scalar multiple
    # of D^6*C^2.  Hence the first and third displayed coefficients vanish.
    outer_first, outer_last = expected[0], expected[2]
    patch_p = sp.groebner(
        [outer_first.subs(P, 1), outer_last.subs(P, 1)], U, domain=sp.QQ
    )
    patch_u = sp.groebner(
        [outer_first.subs(U, 1), outer_last.subs(U, 1)], P, domain=sp.QQ
    )
    assert patch_p.polys == [sp.Poly(1, U, domain=sp.QQ)]
    assert patch_u.polys == [sp.Poly(1, P, domain=sp.QQ)]
    print("EXACT d=32: projective landing branches force P=U=0")

    complete_covariant = (
        A * base.F**6 * base.psi
        + B * base.F**3 * base.D**2 * base.psi
        + P * base.D**4 * base.psi
        + Q * base.F * base.D * base.C * base.psi
        + R * base.F**4 * base.phi
        + S * base.F * base.D**2 * base.phi
        + T * base.F**2 * base.D * base.f18
        + U * base.C * base.f18
    )
    reduced_degree_28 = (
        A * base.F**5 * base.psi
        + B * base.F**2 * base.D**2 * base.psi
        + Q * base.D * base.C * base.psi
        + R * base.F**3 * base.phi
        + S * base.D**2 * base.phi
        + T * base.F * base.D * base.f18
    )
    assert all(
        sp.expand(
            complete_covariant[index].subs({P: 0, U: 0})
            - base.F * reduced_degree_28[index]
        ) == 0
        for index in range(3)
    )
    print("EXACT d=32: remaining branch is F times the complete degree-28 space")
    print("WP3_DEGREE32_EXCLUSION_OK")


if __name__ == "__main__":
    main()
