#!/usr/bin/env python3
"""Exact Jacobian/leading-monomial exclusion in covariant degree 28.

The complete degree-28 family is

    A F^5 psi + B F^2 D^2 psi + Q D C psi
      + R F^3 phi + S D^2 phi + T F D f.

The structural theorem forces F to divide J_p/X.  Two exact Jacobian
coefficients, one impossible square-support coefficient, and a
C>D>F lexicographic leading-monomial descent exclude every branch.

SymPy is the only non-standard dependency.  Runtime is a few minutes.
"""

from __future__ import annotations

from math import prod

import sympy as sp

import klein_covariant_landing_search as generic
import wp3_covariant_exclusions as base


A, B, Q, R, S, T = sp.symbols("A B Q R S T")
PARAMETERS = (A, B, Q, R, S, T)


def decompose_scalar_blocks(
    polynomial: sp.Expr,
    parameters: tuple[sp.Symbol, ...],
    parameter_degree: int,
    invariant_weight: int,
) -> dict[tuple[int, int, int], sp.Expr]:
    """Decompose a parameter-polynomial scalar invariant in Q[F,D,C]."""
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
    for parameter_exp, coefficient in sp.Poly(
        polynomial, *parameters
    ).terms():
        assert sum(parameter_exp) == parameter_degree
        coefficient_dict = base.xyz_dict(coefficient)
        solved = leading_inverse * sp.Matrix([
            coefficient_dict.get(monomial, 0) for monomial in leading_xyz
        ])
        parameter_monomial = prod(
            variable**power
            for variable, power in zip(parameters, parameter_exp)
        )
        block_reconstruction = sp.S.Zero
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


def cdf_leading(
    polynomial: sp.Poly,
    substitutions: dict[sp.Symbol, sp.Expr],
) -> tuple[tuple[int, int, int], sp.Expr]:
    """Leading F,D,C label for lexicographic variable order C>D>F."""
    terms = {
        label: sp.factor(coefficient.subs(substitutions))
        for label, coefficient in polynomial.terms()
        if coefficient.subs(substitutions) != 0
    }
    label = max(terms, key=lambda item: (item[2], item[1], item[0]))
    return label, terms[label]


def main() -> None:
    basis = [
        base.F**5 * base.psi,
        base.F**2 * base.D**2 * base.psi,
        base.D * base.C * base.psi,
        base.F**3 * base.phi,
        base.D**2 * base.phi,
        base.F * base.D * base.f18,
    ]

    # Only Q,S,T can contribute to the F-exponent-zero part of J_p/X.
    # The A,B,R terms are divisible by F^2 before differentiation.
    boundary_parameters = (Q, S, T)
    boundary_p = (
        Q * basis[2]
        + S * basis[4]
        + T * basis[5]
    )
    derivative = [
        [sp.diff(boundary_p[i], variable) for variable in base.XYZ]
        for i in range(3)
    ]
    jacobian_boundary = sp.expand(
        derivative[0][0] * (
            derivative[1][1]*derivative[2][2]
            - derivative[1][2]*derivative[2][1]
        )
        - derivative[0][1] * (
            derivative[1][0]*derivative[2][2]
            - derivative[1][2]*derivative[2][0]
        )
        + derivative[0][2] * (
            derivative[1][0]*derivative[2][1]
            - derivative[1][1]*derivative[2][0]
        )
    )

    X = base.reconstruct_odd_covariants_and_syzygy()
    jacobian_over_x = sp.S.Zero
    for parameter_exp, coefficient in sp.Poly(
        jacobian_boundary, *boundary_parameters
    ).terms():
        quotient, remainder = sp.div(
            sp.Poly(coefficient, *base.XYZ),
            sp.Poly(X, *base.XYZ),
        )
        assert remainder.is_zero
        parameter_monomial = prod(
            variable**power
            for variable, power in zip(boundary_parameters, parameter_exp)
        )
        jacobian_over_x += parameter_monomial * quotient.as_expr()

    jacobian_coefficients = decompose_scalar_blocks(
        sp.expand(jacobian_over_x),
        boundary_parameters,
        parameter_degree=3,
        invariant_weight=60,
    )
    assert jacobian_coefficients[(0, 10, 0)] == (
        1843968 * S * (6*Q + 13*S) * (S + 2*T)
    )
    assert jacobian_coefficients[(0, 3, 3)] == (
        28 * Q * (3*Q - 14*T) * (5*Q + 14*S)
    )
    print("EXACT d=28: F|J_p/X branch equations PASS")

    # Construct the complete quartic pullback directly from the exact
    # invariant-coordinate tensor.
    u_psi = A*generic.F0**5 + B*generic.F0**2*generic.D0**2 + Q*generic.D0*generic.C0
    u_phi = R*generic.F0**3 + S*generic.D0**2
    u_f = T*generic.F0*generic.D0
    pullback = sp.Poly(sp.expand(
        generic.quartic_tensor("even").subs({
            generic.u0: u_psi,
            generic.u1: u_phi,
            generic.u2: u_f,
        })
    ), generic.F0, generic.D0, generic.C0)
    pullback_coefficients = dict(pullback.terms())

    # This is the unique monomial outside the square-support sumset in
    # degree 28.
    assert base.impossible_support(28) == [(1, 18, 0)]
    assert sp.factor(pullback_coefficients[(1, 18, 0)]) == (
        -265531392 * S**3 * (S + 2*T)
    )
    print("EXACT d=28: impossible-support equation PASS")

    # If S=Q=0, every term has a common factor F and reduces to degree 24.
    complete_p = sum(
        (parameter * vector for parameter, vector in zip(PARAMETERS, basis)),
        sp.zeros(3, 1),
    )
    assert all(
        sp.rem(
            sp.Poly(complete_p[i].subs({Q: 0, S: 0}), *base.XYZ),
            sp.Poly(base.F, *base.XYZ),
        ).is_zero
        for i in range(3)
    )

    # The remaining four normalized branches.  For a square polynomial,
    # the leading exponent in every monomial order is twice an exponent
    # and therefore even coordinatewise.
    branch_i = {Q: 1, S: 0, T: sp.Rational(3, 14)}
    assert cdf_leading(pullback, branch_i) == ((0, 7, 5), sp.Integer(-108))

    branch_ii = {Q: 0, S: 1, T: sp.Rational(-1, 2)}
    assert cdf_leading(pullback, branch_ii) == ((3, 5, 5), sp.Integer(4802))

    branch_iv = {
        Q: 1,
        S: sp.Rational(-5, 14),
        T: sp.Rational(5, 28),
    }
    assert cdf_leading(pullback, branch_iv) == (
        (1, 4, 6), sp.Rational(-1, 2)
    )
    print("EXACT d=28: three branches have odd leading exponent PASS")

    # On the last branch, successive odd leading exponents force
    # B=116/21, then A=196R^2+116R/3, then R=0 and A=0.
    branch_iii = {
        Q: 1,
        S: sp.Rational(-3, 7),
        T: sp.Rational(3, 14),
    }
    leading_label, leading_coefficient = cdf_leading(pullback, branch_iii)
    assert leading_label == (3, 5, 5)
    assert sp.expand(leading_coefficient + (21*B - 116)/7) == 0
    branch_iii[B] = sp.Rational(116, 21)
    leading_label, leading_coefficient = cdf_leading(pullback, branch_iii)
    assert leading_label == (6, 3, 5)
    assert sp.expand(
        leading_coefficient - (-3*A + 588*R**2 + 116*R)
    ) == 0
    branch_iii[A] = 196*R**2 + sp.Rational(116, 3)*R
    leading_label, leading_coefficient = cdf_leading(pullback, branch_iii)
    assert leading_label == (9, 1, 5)
    assert sp.expand(leading_coefficient + 2744*R**3) == 0

    final_substitution = {
        Q: 1,
        S: sp.Rational(-3, 7),
        T: sp.Rational(3, 14),
        B: sp.Rational(116, 21),
        A: 0,
        R: 0,
    }
    degree_22_direction = (
        42*base.C*base.psi
        + 232*base.F**2*base.D*base.psi
        - 18*base.D*base.phi
        + 9*base.F*base.f18
    )
    assert all(
        sp.expand(
            42*complete_p[i].subs(final_substitution)
            - base.D*degree_22_direction[i]
        ) == 0
        for i in range(3)
    )
    print("EXACT d=28: final branch has common factor D and reduces to degree 22")
    print("WP3_DEGREE28_EXCLUSION_OK")


if __name__ == "__main__":
    main()
