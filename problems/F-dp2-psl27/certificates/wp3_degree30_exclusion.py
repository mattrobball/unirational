#!/usr/bin/env python3
"""Exact exclusion of the complete degree-30 Klein-covariant space.

The structural theorem gives J_p = lambda*X*D*h in degree 30.  Reduction
modulo D first forces T=0 and leaves five possible ratios Q/R.  Seven
high-C coefficients of

    (J_p/(X*D))^2 = lambda^2 * F(p)

then exclude the ratio 48 and the two conjugate pairs.  All arithmetic is
exact over Q; the quadratic pairs are kept together by reduction modulo
their defining polynomials.

SymPy is the only non-standard dependency.  Runtime is about one minute.
"""

from __future__ import annotations

from math import prod

import sympy as sp

import even_quartic_tensor as even_tensor
import wp3_covariant_exclusions as base


A, B, Q, R, S, T, U = sp.symbols("A B Q R S T U")
PARAMETERS = (A, B, Q, R, S, T, U)


def q4(vector: sp.Matrix) -> sp.Expr:
    return sp.expand(
        vector[0]**3 * vector[1]
        + vector[1]**3 * vector[2]
        + vector[2]**3 * vector[0]
    )


def degree_30_basis() -> list[sp.Matrix]:
    return [
        base.F**4 * base.D * base.psi,
        base.F * base.D**3 * base.psi,
        base.F**2 * base.C * base.psi,
        base.C * base.phi,
        base.F**2 * base.D * base.phi,
        base.F**3 * base.f18,
        base.D**2 * base.f18,
    ]


MODULUS_D = sp.Poly(
    sp.expand(base.D.subs({base.x: 1, base.y: 1})),
    base.z,
    domain=sp.QQ,
)
PARAMETER_FIELD = sp.QQ.frac_field(*PARAMETERS)


def reduce_mod_d(expression: sp.Expr, domain=PARAMETER_FIELD) -> sp.Expr:
    """Restrict to x=y=1 and reduce exactly modulo D(1,1,z)."""
    specialized = sp.expand(expression.subs({base.x: 1, base.y: 1}))
    return sp.rem(
        sp.Poly(specialized, base.z, domain=domain), MODULUS_D
    ).as_expr()


def d_residue_vector(expression: sp.Expr) -> sp.Matrix:
    polynomial = sp.Poly(reduce_mod_d(expression), base.z)
    return sp.Matrix([
        polynomial.coeff_monomial(base.z**degree)
        for degree in range(MODULUS_D.degree())
    ])


def d_free_jacobian_coefficients(
    complete_covariant: sp.Matrix,
) -> tuple[sp.Expr, sp.Expr]:
    """Return the F^13*C and F^6*C^3 terms of J_p/X modulo D."""
    derivative = sp.Matrix([
        [reduce_mod_d(sp.diff(complete_covariant[i], variable))
         for variable in base.XYZ]
        for i in range(3)
    ])
    jacobian = reduce_mod_d(derivative.det())

    X = sp.expand(
        sp.Matrix([
            [sp.diff(invariant, variable) for variable in base.XYZ]
            for invariant in (base.F, base.D, base.C)
        ]).det() / 14
    )
    X_residue = reduce_mod_d(X, domain=sp.QQ)
    assert sp.gcd(
        sp.Poly(X_residue, base.z, domain=sp.QQ), MODULUS_D
    ).degree() == 0
    inverse_x = sp.invert(
        sp.Poly(X_residue, base.z, domain=sp.QQ), MODULUS_D
    ).as_expr()
    jacobian_over_x = reduce_mod_d(jacobian * inverse_x)

    F_residue = reduce_mod_d(base.F, domain=sp.QQ)
    C_residue = reduce_mod_d(base.C, domain=sp.QQ)
    invariant_basis = [
        reduce_mod_d(F_residue**13 * C_residue, domain=sp.QQ),
        reduce_mod_d(F_residue**6 * C_residue**3, domain=sp.QQ),
    ]
    matrix = sp.Matrix.hstack(*[
        d_residue_vector(item) for item in invariant_basis
    ])
    solutions = list(sp.linsolve((matrix, d_residue_vector(jacobian_over_x))))
    assert len(solutions) == 1
    alpha, beta = map(sp.factor, solutions[0])
    assert d_residue_vector(
        jacobian_over_x - alpha*invariant_basis[0] - beta*invariant_basis[1]
    ) == sp.zeros(MODULUS_D.degree(), 1)
    return alpha, beta


def d_free_landing_coefficients() -> list[sp.Expr]:
    """Reconstruct all invariant coefficients of F(p) modulo D."""
    restricted_covariant = (
        Q * base.F**2 * base.C * base.psi
        + R * base.C * base.phi
        + T * base.F**3 * base.f18
    )
    coordinates = [reduce_mod_d(restricted_covariant[i]) for i in range(3)]
    pullback = reduce_mod_d(q4(sp.Matrix(coordinates)))

    F_residue = reduce_mod_d(base.F, domain=sp.QQ)
    C_residue = reduce_mod_d(base.C, domain=sp.QQ)
    labels = [(30, 0), (23, 2), (16, 4), (9, 6), (2, 8)]
    invariant_basis = [
        reduce_mod_d(F_residue**f_power * C_residue**c_power, domain=sp.QQ)
        for f_power, c_power in labels
    ]
    matrix = sp.Matrix.hstack(*[
        d_residue_vector(item) for item in invariant_basis
    ])
    assert matrix.det() != 0
    solved = list(matrix.inv() * d_residue_vector(pullback))
    assert d_residue_vector(
        pullback - sum(
            (coefficient*item for coefficient, item in zip(solved, invariant_basis)),
            sp.S.Zero,
        )
    ) == sp.zeros(MODULUS_D.degree(), 1)
    return list(map(sp.factor, solved))


# The hard-coded points merely choose an invertible evaluation matrix in
# the 18-dimensional invariant space of weight 66.  The structural theorem
# already proves J_p/X is an invariant of that weight, so exact interpolation
# on this full-rank matrix determines it uniquely.
JACOBIAN_POINTS = [
    (-3, -3, 1), (2, 1, 1), (-1, -3, 0), (-1, 3, -1),
    (-3, -2, 1), (-2, -1, -2), (3, 0, 2), (-1, 1, 0),
    (-1, 2, -3), (1, -2, 1), (-1, -2, 0), (-2, -2, 0),
    (-1, 1, -2), (2, 1, 0), (1, 2, -3), (3, -3, 3),
    (1, -2, 2), (2, 0, -1),
]


def interpolate_jacobian_over_x(
    covariant_basis: list[sp.Matrix],
) -> dict[tuple[int, int, int], sp.Expr]:
    """Interpolate the exact Q[F,D,C]-coordinates of J_p/X."""
    labels = base.invariant_monomials(66)
    assert len(labels) == len(JACOBIAN_POINTS) == 18
    invariant_basis = [base.invariant_expr(label) for label in labels]

    X = sp.expand(
        sp.Matrix([
            [sp.diff(invariant, variable) for variable in base.XYZ]
            for invariant in (base.F, base.D, base.C)
        ]).det() / 14
    )
    derivative_basis = [
        sp.Matrix([
            [sp.diff(vector[i], variable) for variable in base.XYZ]
            for i in range(3)
        ])
        for vector in covariant_basis
    ]

    rows: list[list[sp.Expr]] = []
    right_hand_side: list[sp.Expr] = []
    for point in JACOBIAN_POINTS:
        substitution = dict(zip(base.XYZ, point))
        x_value = X.subs(substitution)
        assert x_value != 0
        rows.append([item.subs(substitution) for item in invariant_basis])
        derivative_values = [item.subs(substitution) for item in derivative_basis]
        jacobian_value = sum(
            (parameter*matrix for parameter, matrix in zip(
                PARAMETERS, derivative_values
            )),
            sp.zeros(3, 3),
        ).det()
        right_hand_side.append(sp.expand(jacobian_value / x_value))

    evaluation_matrix = sp.Matrix(rows)
    assert evaluation_matrix.det() != 0
    solved = evaluation_matrix.inv() * sp.Matrix(right_hand_side)
    return {
        label: sp.factor(coefficient)
        for label, coefficient in zip(labels, solved)
    }


def high_c_data(
    jacobian_coefficients: dict[tuple[int, int, int], sp.Expr],
) -> tuple[list[sp.Expr], list[sp.Expr]]:
    """Return the six K=J/(XD) and seven F(p) high-C coefficients."""
    # T=0 has already been forced before this routine is used.
    k4 = sp.factor(jacobian_coefficients[(1, 1, 4)].subs(T, 0))
    k31 = sp.factor(jacobian_coefficients[(3, 2, 3)].subs(T, 0))
    k30 = sp.factor(jacobian_coefficients[(0, 4, 3)].subs(T, 0))
    k20 = sp.factor(jacobian_coefficients[(8, 1, 2)].subs(T, 0))
    k21 = sp.factor(jacobian_coefficients[(5, 3, 2)].subs(T, 0))
    k22 = sp.factor(jacobian_coefficients[(2, 5, 2)].subs(T, 0))

    assert k4 == -23520*R*(Q - 34*R)*(3*R + U)
    assert k30 == -11760*R*(3*R + U)*(B - 728*R + 68*U)

    tensor = even_tensor.load_tensor()
    psi_scalar = (
        A*even_tensor.F**4*even_tensor.D
        + B*even_tensor.F*even_tensor.D**3
        + Q*even_tensor.F**2*even_tensor.C
    )
    phi_scalar = R*even_tensor.C + S*even_tensor.F**2*even_tensor.D
    f_scalar = U*even_tensor.D**2
    landing = sp.Poly(
        sp.expand(tensor.subs({
            even_tensor.u: psi_scalar,
            even_tensor.v: phi_scalar,
            even_tensor.w: f_scalar,
        })),
        even_tensor.F, even_tensor.D, even_tensor.C,
    )
    coefficient = landing.as_dict()
    labels = [
        (2, 0, 8), (4, 1, 7), (1, 3, 7),
        (9, 0, 6), (6, 2, 6), (3, 4, 6), (0, 6, 6),
    ]
    landing_high_c = [sp.factor(coefficient[label]) for label in labels]
    L8, _L41, L13, _L90, _L62, _L34, L06 = landing_high_c
    assert L8 == -2744*R**3*(Q - 34*R)
    assert L13 == -2744*R**3*(B - 728*R + 68*U)
    assert L06 == -38416*R*(144*R**3 + 40*R**2*U + 9*R*U**2 + U**3)
    return [k4, k31, k30, k20, k21, k22], landing_high_c


def proportionality_equations(
    k: list[sp.Expr], landing: list[sp.Expr]
) -> list[sp.Expr]:
    """Cross-multiply seven high-C coefficients of K^2=rho*F(p)."""
    k4, k31, k30, k20, k21, k22 = k
    L8, L41, L13, L90, L62, L34, L06 = landing
    return [
        sp.expand(2*k4*k31*L8 - k4**2*L41),
        sp.expand(2*k4*k30*L8 - k4**2*L13),
        sp.expand(2*k20*k4*L8 - k4**2*L90),
        sp.expand((k31**2 + 2*k21*k4)*L8 - k4**2*L62),
        sp.expand((2*k31*k30 + 2*k22*k4)*L8 - k4**2*L34),
        sp.expand(k30**2*L8 - k4**2*L06),
    ]


def same_up_to_constant(left: sp.Expr, right: sp.Expr) -> bool:
    ratio = sp.cancel(left / right)
    return ratio != 0 and not ratio.free_symbols


def exclude_ratio_48(equations: list[sp.Expr]) -> None:
    """Exclude Q/R=48 by a short exact elimination."""
    a, b, u = sp.symbols("a b u")
    shifted = {
        Q: 48, R: 1,
        A: a - 448, B: b + 2048, U: u - 12,
    }
    specialized = [sp.factor(item.subs(shifted)) for item in equations]

    # L8 is nonzero.  The leading K coefficient vanishes only at u=9,
    # so that value is impossible.  With u != 9, equations 2 and 0 give
    # a=48S and S(u-18)+28(u-6)=0.
    assert specialized[1] == 0
    assert same_up_to_constant(
        specialized[2], (u - 9)*(a - 48*S)**2
    )
    first_after_a = sp.factor(specialized[0].subs(a, 48*S))
    assert same_up_to_constant(
        first_after_a,
        (u - 9)*(S*(u - 18) + 28*(u - 6)),
    )
    # u=18 makes the second factor nonzero, so solve for S otherwise.
    assert (S*(u - 18) + 28*(u - 6)).subs(u, 18) == 336
    S_value = -28*(u - 6)/(u - 18)

    P = 11*u**4 - 312*u**3 + 414*u**2 + 41832*u - 264600
    G = (
        -9*b**2*u + 162*b**2 + 456*b*u**2 - 35256*b*u + 486864*b
        - 2352*u**4 + 216096*u**3 - 6887744*u**2
        + 62676096*u - 33191424
    )
    H = (
        -b**2 - 136*b*u - 1008*b + 784*u**3 - 25792*u**2
        + 132160*u - 856128
    )
    reduced = [
        sp.factor(item.subs(a, 48*S).subs(S, S_value))
        for item in specialized[3:]
    ]
    numerators = [sp.together(item).as_numer_denom()[0] for item in reduced]
    assert same_up_to_constant(numerators[0], (u - 9)*P)
    assert same_up_to_constant(numerators[1], (u - 9)*G)
    assert same_up_to_constant(numerators[2], (u - 9)**2*H)
    groebner = sp.groebner([P, G, H], b, u, order="lex")
    assert len(groebner.polys) == 1 and groebner.polys[0].as_expr() == 1
    print("EXACT d=30: ratio Q/R=48 has unit ideal")


def reduce_q(expression: sp.Expr, relation: sp.Expr) -> sp.Expr:
    """Reduce a rational expression's numerator modulo relation(Q)."""
    numerator = sp.together(expression).as_numer_denom()[0]
    return sp.rem(
        sp.Poly(sp.expand(numerator), Q), sp.Poly(relation, Q)
    ).as_expr()


def strip_u_plus_three(expression: sp.Expr) -> sp.Expr:
    """Cancel all polynomial factors U+3, already known to be nonzero."""
    answer = sp.expand(expression)
    while answer != 0:
        quotient, remainder = sp.div(sp.Poly(answer, U), sp.Poly(U + 3, U))
        if not remainder.is_zero:
            break
        answer = quotient.as_expr()
    return sp.factor(answer)


def exclude_quadratic_pair(
    equations: list[sp.Expr], relation: sp.Expr, name: str
) -> None:
    """Exclude both roots of one quadratic ratio exactly over Q[Q]/(rel)."""
    A_value = Q*S + (Q + 8)*(5*Q - 352)/14
    reduced = [
        strip_u_plus_three(reduce_q(
            item.subs({R: 1, A: A_value}), relation
        ))
        for item in equations
    ]
    e0, _e1, e2, e3, e4, e5 = reduced

    solutions = sp.solve([e0, e2], (B, S), dict=True)
    assert len(solutions) == 1
    solution = solutions[0]
    assert set(solution) == {B, S}

    # The solve step is valid at both roots: every denominator is coprime
    # to the quadratic relation.
    for value in solution.values():
        denominator = sp.factor(sp.together(value).as_numer_denom()[1])
        assert denominator.free_symbols <= {Q}
        assert sp.gcd(
            sp.Poly(denominator, Q, domain=sp.QQ),
            sp.Poly(relation, Q, domain=sp.QQ),
        ).degree() == 0

    final_equations = []
    for item in (e3, e4, e5):
        substituted = sp.together(item.subs(solution))
        denominator = sp.factor(substituted.as_numer_denom()[1])
        if denominator.free_symbols <= {Q}:
            assert sp.gcd(
                sp.Poly(denominator, Q, domain=sp.QQ),
                sp.Poly(relation, Q, domain=sp.QQ),
            ).degree() == 0
        final_equations.append(reduce_q(substituted, relation))

    assert all(item.free_symbols <= {Q, U} for item in final_equations)
    groebner = sp.groebner(
        [relation, *final_equations], Q, U, order="lex"
    )
    assert len(groebner.polys) == 1 and groebner.polys[0].as_expr() == 1
    print(f"EXACT d=30: {name} conjugate ratio pair has unit ideal")


def main() -> None:
    basis = degree_30_basis()
    complete_covariant = sum(
        (parameter*vector for parameter, vector in zip(PARAMETERS, basis)),
        sp.zeros(3, 1),
    )

    alpha, beta = d_free_jacobian_coefficients(complete_covariant)
    assert alpha.subs(T, 0) == 0
    beta_expected = -90*(Q - 48*R)*(
        14*A*R - 5*Q**2 + 312*Q*R - 14*Q*S + 2816*R**2
    )
    assert sp.expand(beta.subs(T, 0) - beta_expected) == 0

    landing_mod_d = d_free_landing_coefficients()
    assert landing_mod_d[0] == 0
    assert landing_mod_d[1] == 9834496*T**4
    L4 = sp.factor(landing_mod_d[2].subs(T, 0))
    L6 = sp.factor(landing_mod_d[3].subs(T, 0))
    L8 = sp.factor(landing_mod_d[4].subs(T, 0))
    assert L4 == -256*(Q + 8*R)**4
    assert L8 == -2744*R**3*(Q - 34*R)

    # The F^30 coefficient is the square of the F^15 coefficient of h.
    # It vanishes, so the F^23*C^2 coefficient must vanish as well; hence
    # T=0.  The remaining three coefficients are a binary quadratic square.
    square_discriminant = sp.factor(L6**2 - 4*L4*L8)
    expected_discriminant = (
        (Q - 48*R)**4
        * (Q**2 - 320*Q*R + 19328*R**2)
        * (9*Q**2 - 192*Q*R + 19840*R**2)
    )
    assert square_discriminant == expected_discriminant

    # If R=0, the discriminant forces Q=0; after T=0 every coordinate
    # then has the common factor D, contrary to primitive normalization.
    reduced_degree_24 = (
        A*base.F**4*base.psi
        + B*base.F*base.D**2*base.psi
        + S*base.F**2*base.phi
        + U*base.D*base.f18
    )
    assert all(
        sp.expand(
            complete_covariant[index].subs({Q: 0, R: 0, T: 0})
            - base.D*reduced_degree_24[index]
        ) == 0
        for index in range(3)
    )
    print("EXACT d=30: D-free equations leave ratio 48 and two quadratics")

    jacobian_coefficients = interpolate_jacobian_over_x(basis)
    k_coefficients, landing_coefficients = high_c_data(jacobian_coefficients)
    normalized_k4 = sp.factor(k_coefficients[0].subs({R: 1, U: -3}))
    normalized_L8 = sp.factor(landing_coefficients[0].subs(R, 1))
    assert normalized_k4 == 0
    assert normalized_L8.subs(Q, 48) != 0
    assert (Q**2 - 320*Q + 19328).subs(Q, 34) != 0
    assert (9*Q**2 - 192*Q + 19840).subs(Q, 34) != 0
    print("EXACT d=30: exceptional U=-3 has k4=0 while L8 is nonzero")
    equations = proportionality_equations(k_coefficients, landing_coefficients)

    exclude_ratio_48(equations)
    exclude_quadratic_pair(
        equations,
        Q**2 - 320*Q + 19328,
        "Q^2-320Q+19328",
    )
    exclude_quadratic_pair(
        equations,
        9*Q**2 - 192*Q + 19840,
        "9Q^2-192Q+19840",
    )
    print("WP3_DEGREE30_EXCLUSION_OK")


if __name__ == "__main__":
    main()
