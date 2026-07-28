#!/usr/bin/env python3
"""Exact Jacobian/support exclusion of the degree-24 covariant space.

WP3_STRUCTURAL_BOUND.md proves that a primitive degree-24 landing
covariant must satisfy det(Dp) = constant * X * h.  This checker verifies
the two invariant coefficients that make that identity impossible.

SymPy is the only non-standard dependency.  Runtime is a few minutes.
"""

from __future__ import annotations

from math import prod

import sympy as sp

import wp3_covariant_exclusions as base


A, B, Q, R = sp.symbols("A B Q R")
PARAMETERS = (A, B, Q, R)


def decompose_scalar_blocks(
    polynomial: sp.Expr,
    parameter_degree: int,
    invariant_weight: int,
) -> dict[tuple[int, int, int], sp.Expr]:
    """Decompose a parameter-polynomial scalar invariant in Q[F,D,C].

    Each parameter block is reconstructed from a triangular exact solve,
    and the full polynomial is reconstructed afterward.
    """
    labels = base.invariant_monomials(invariant_weight)
    invariant_dicts = [
        base.xyz_dict(base.invariant_expr(label)) for label in labels
    ]
    leading_xyz = [max(item) for item in invariant_dicts]
    leading_matrix = sp.Matrix([
        [item.get(monomial, 0) for item in invariant_dicts]
        for monomial in leading_xyz
    ])
    leading_inverse = leading_matrix.inv()

    answer = {label: sp.S.Zero for label in labels}
    reconstructed = sp.S.Zero
    blocks = sp.Poly(polynomial, *PARAMETERS)
    for parameter_exp, coefficient in blocks.terms():
        assert sum(parameter_exp) == parameter_degree
        coefficient_dict = base.xyz_dict(coefficient)
        solved = leading_inverse * sp.Matrix([
            coefficient_dict.get(monomial, 0) for monomial in leading_xyz
        ])
        block_reconstruction = sp.S.Zero
        parameter_monomial = prod(
            variable**power
            for variable, power in zip(PARAMETERS, parameter_exp)
        )
        for label, scalar in zip(labels, solved):
            scalar = sp.Rational(scalar)
            assert scalar.q == 1
            if scalar:
                answer[label] += int(scalar) * parameter_monomial
                block_reconstruction += int(scalar) * base.invariant_expr(label)
        assert sp.expand(block_reconstruction - coefficient) == 0
        reconstructed += parameter_monomial * block_reconstruction
    assert sp.expand(reconstructed - polynomial) == 0
    return {label: sp.factor(value) for label, value in answer.items()}


def main() -> None:
    basis = [
        base.F**4 * base.psi,
        base.F * base.D**2 * base.psi,
        base.F**2 * base.phi,
        base.D * base.f18,
    ]
    p = sum(
        (parameter * vector for parameter, vector in zip(PARAMETERS, basis)),
        sp.zeros(3, 1),
    )

    # X is independently reconstructed and checked by the existing exact
    # generator/syzygy routine.
    X = base.reconstruct_odd_covariants_and_syzygy()

    jacobian = sp.expand(sp.Matrix([
        [sp.diff(p[i], variable) for variable in base.XYZ]
        for i in range(3)
    ]).det())

    # Divide each cubic parameter block by X exactly.  Blockwise division
    # avoids relying on a multivariate factorization heuristic.
    jacobian_over_x = sp.S.Zero
    for parameter_exp, coefficient in sp.Poly(
        jacobian, *PARAMETERS
    ).terms():
        quotient, remainder = sp.div(
            sp.Poly(coefficient, *base.XYZ),
            sp.Poly(X, *base.XYZ),
        )
        assert remainder.is_zero
        parameter_monomial = prod(
            variable**power
            for variable, power in zip(PARAMETERS, parameter_exp)
        )
        jacobian_over_x += parameter_monomial * quotient.as_expr()

    jacobian_coefficients = decompose_scalar_blocks(
        sp.expand(jacobian_over_x),
        parameter_degree=3,
        invariant_weight=48,
    )
    # The load-bearing missing square-root coefficient.
    assert jacobian_coefficients[(0, 1, 3)] == 0
    assert sp.expand(X * jacobian_over_x - jacobian) == 0
    print("EXACT d=24: coeff_(D*C^3)(J_p/X) = 0")

    pullback = base.pullback_coefficients(basis, 24)
    obstructing = base.coefficient_expr(
        pullback[(0, 9, 3)], PARAMETERS
    )
    assert obstructing == -2919616 * R**4
    print("EXACT d=24: coeff_(D^9*C^3)(F(p)) = -2919616*R^4")

    # Once R=0, every remaining coordinate has the common invariant factor
    # F, and removing it lowers the landing degree from 24 to 20.
    reduced = (
        A * base.F**3 * base.psi
        + B * base.D**2 * base.psi
        + Q * base.F * base.phi
    )
    assert all(
        sp.expand(p[i].subs(R, 0) - base.F * reduced[i]) == 0
        for i in range(3)
    )
    print("EXACT d=24: R=0 branch has common factor F and reduces to degree 20")
    print("WP3_DEGREE24_EXCLUSION_OK")


if __name__ == "__main__":
    main()

