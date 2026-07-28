#!/usr/bin/env python3
"""Exact residue/Jacobian exclusion of the degree-34 covariant space.

The proof has three exact computational inputs:

* the cached 15-term universal tensor F(u*psi+v*phi+w*f18);
* an exact full-rank interpolation of J_p/X in Q[F,D,C];
* saturated Groebner eliminations on the five surviving residue ratios.

Every interpolation and Groebner computation is over Q.  Absence of a
solution is asserted only after adjoining Z with rho*Z-1, so the scalar
rho relating (J_p/(XFD))^2 to F(p) is genuinely nonzero.

SymPy is the only non-standard dependency.  Runtime is about one minute.
"""

from __future__ import annotations

from itertools import product
from random import Random
from time import monotonic

import sympy as sp

import even_quartic_tensor as tensor_cache
import wp3_covariant_exclusions as base


A, B, Q, R, S, T, U, V, W, rho, Z = sp.symbols(
    "A B Q R S T U V W rho Z"
)
PARAMETERS = (A, B, Q, R, S, T, U, V, W)

BASIS = [
    base.F**5 * base.D * base.psi,
    base.F**2 * base.D**3 * base.psi,
    base.F**3 * base.C * base.psi,
    base.D**2 * base.C * base.psi,
    base.F**3 * base.D * base.phi,
    base.D**3 * base.phi,
    base.F * base.C * base.phi,
    base.F**4 * base.f18,
    base.F * base.D**2 * base.f18,
]

J_WEIGHT = 78
K_WEIGHT = 68
INTERPOLATION_PRIME = 1_000_003


def rank_mod_prime(rows: list[list[int]], prime: int = INTERPOLATION_PRIME) -> int:
    matrix = [[entry % prime for entry in row] for row in rows]
    row_count = len(matrix)
    column_count = len(matrix[0]) if matrix else 0
    rank = 0
    for column in range(column_count):
        pivot = next(
            (row for row in range(rank, row_count) if matrix[row][column]),
            None,
        )
        if pivot is None:
            continue
        matrix[rank], matrix[pivot] = matrix[pivot], matrix[rank]
        inverse = pow(matrix[rank][column], -1, prime)
        matrix[rank] = [(entry * inverse) % prime for entry in matrix[rank]]
        for row in range(row_count):
            if row == rank or not matrix[row][column]:
                continue
            multiplier = matrix[row][column]
            matrix[row] = [
                (matrix[row][index] - multiplier * matrix[rank][index]) % prime
                for index in range(column_count)
            ]
        rank += 1
        if rank == row_count:
            return rank
    return rank


def interpolation_points(
    labels: list[tuple[int, int, int]], seed: int
) -> tuple[list[tuple[int, int, int]], sp.Matrix, list[tuple[int, int, int, int]]]:
    X = sp.expand(sp.Matrix([
        [sp.diff(invariant, variable) for variable in base.XYZ]
        for invariant in (base.F, base.D, base.C)
    ]).det() / 14)
    evaluators = [
        sp.lambdify(base.XYZ, expression, "math")
        for expression in (base.F, base.D, base.C, X)
    ]
    candidates = list(product(range(-3, 4), repeat=3))
    Random(seed).shuffle(candidates)

    points: list[tuple[int, int, int]] = []
    rows: list[list[int]] = []
    values: list[tuple[int, int, int, int]] = []
    for point in candidates:
        F_value, D_value, C_value, X_value = (
            int(evaluator(*point)) for evaluator in evaluators
        )
        if not F_value or not D_value or not X_value:
            continue
        row = [
            F_value**i * D_value**j * C_value**k for i, j, k in labels
        ]
        if rank_mod_prime(rows + [row]) > len(rows):
            points.append(point)
            rows.append(row)
            values.append((F_value, D_value, C_value, X_value))
        if len(rows) == len(labels):
            break

    assert len(rows) == len(labels)
    # Nonzero determinant modulo a prime proves the integer determinant is
    # nonzero, and hence that the characteristic-zero evaluation map is exact.
    assert rank_mod_prime(rows) == len(labels)
    return points, sp.Matrix(rows), values


def jacobian_over_x_coefficients() -> dict[tuple[int, int, int], sp.Expr]:
    labels = base.invariant_monomials(J_WEIGHT)
    points, evaluation_matrix, values = interpolation_points(labels, seed=3478)
    derivative_basis = [
        sp.Matrix([
            [sp.diff(vector[row], variable) for variable in base.XYZ]
            for row in range(3)
        ])
        for vector in BASIS
    ]

    right_hand_side = []
    for point, (_, _, _, X_value) in zip(points, values):
        substitutions = dict(zip(base.XYZ, point))
        evaluated = [matrix.subs(substitutions) for matrix in derivative_basis]
        jacobian = sum(
            (parameter * matrix for parameter, matrix in zip(PARAMETERS, evaluated)),
            sp.zeros(3),
        ).det()
        right_hand_side.append(sp.expand(jacobian / X_value))

    solved = evaluation_matrix.inv() * sp.Matrix(right_hand_side)
    coefficients = {
        label: sp.factor(coefficient) for label, coefficient in zip(labels, solved)
    }

    assert sp.factor(coefficients[(16, 0, 1)].subs(V, 0)) == 0
    assert sp.factor(coefficients[(2, 0, 5)].subs(V, 0)) == 0
    middle_d_free = sp.factor(coefficients[(9, 0, 3)].subs(V, 0))
    expected_middle_d_free = 102 * (Q - 48 * U) * (
        -14 * A * U + 5 * Q**2 + 14 * Q * S - 312 * Q * U - 2816 * U**2
    )
    assert sp.expand(middle_d_free - expected_middle_d_free) == 0
    assert coefficients[(0, 13, 0)] == (
        2239104 * T * (6 * R + 13 * T) * (T + 2 * W)
    )
    assert coefficients[(0, 6, 3)] == 34 * R * (
        15 * R**2 + 42 * R * T + 504 * R * U - 70 * R * W
        + 1176 * T * U - 196 * T * W
    )
    print("EXACT d=34: J_p/X invariant interpolation full rank (24/24)")
    print("EXACT d=34: F-free and D-free Jacobian coefficients verified")
    return coefficients


def complete_landing() -> sp.Poly:
    universal = tensor_cache.load_tensor()
    psi_coefficient = (
        A * tensor_cache.F**5 * tensor_cache.D
        + B * tensor_cache.F**2 * tensor_cache.D**3
        + Q * tensor_cache.F**3 * tensor_cache.C
        + R * tensor_cache.D**2 * tensor_cache.C
    )
    phi_coefficient = (
        S * tensor_cache.F**3 * tensor_cache.D
        + T * tensor_cache.D**3
        + U * tensor_cache.F * tensor_cache.C
    )
    f_coefficient = V * tensor_cache.F**4 + W * tensor_cache.F * tensor_cache.D**2
    return sp.Poly(
        sp.expand(universal.subs({
            tensor_cache.u: psi_coefficient,
            tensor_cache.v: phi_coefficient,
            tensor_cache.w: f_coefficient,
        })),
        tensor_cache.F,
        tensor_cache.D,
        tensor_cache.C,
    )


def verify_residue_reductions(landing: sp.Poly) -> None:
    coefficients = landing.as_dict()
    assert coefficients.get((34, 0, 0), 0) == 0
    assert sp.factor(coefficients[(27, 0, 2)]) == 9834496 * V**4
    assert sp.factor(coefficients[(6, 0, 8)]) == -2744 * U**3 * (Q - 34 * U)

    d_middle = sp.factor(coefficients[(13, 0, 6)].subs(V, 0))
    d_outer = sp.factor(coefficients[(20, 0, 4)].subs(V, 0))
    d_last = sp.factor(coefficients[(6, 0, 8)].subs(V, 0))
    discriminant = sp.factor(d_middle**2 - 4 * d_outer * d_last)
    expected_discriminant = (
        (Q - 48 * U)**4
        * (Q**2 - 320 * Q * U + 19328 * U**2)
        * (9 * Q**2 - 192 * Q * U + 19840 * U**2)
    )
    assert discriminant == expected_discriminant

    assert sp.factor(coefficients[(0, 18, 2)]) == (
        -112896 * T**2 * (3 * R + 7 * T)**2
    )
    assert sp.factor(coefficients[(0, 11, 5)]) == (
        -4 * R * (3 * R + 7 * T)**2 * (3 * R + 14 * T)
    )

    # Once V=0 and U != 0, the top C-support of a square forces R=0:
    # the two weight-68 C^4 root monomials square to exponents (6,0,8),
    # (3,2,8), (0,4,8), while the last landing coefficient is zero.
    top_substitution = {V: 0}
    assert sp.factor(coefficients[(3, 2, 8)].subs(top_substitution)) == -2744 * R * U**3
    assert coefficients.get((0, 4, 8), 0) == 0

    # None of the five nonzero residue ratios has Q/U=34.
    q = sp.symbols("q")
    for ratio_polynomial in (
        q - 48,
        q**2 - 320 * q + 19328,
        9 * q**2 - 192 * q + 19840,
    ):
        assert sp.gcd(sp.Poly(ratio_polynomial, q), sp.Poly(q - 34, q)).degree() == 0

    print("EXACT d=34: D=0 square support gives V=0 and five Q/U ratios")
    print("EXACT d=34: top C^8 support forces R=0 when U is nonzero")


def reduced_degree_28() -> sp.Matrix:
    return (
        A * base.F**5 * base.psi
        + B * base.F**2 * base.D**2 * base.psi
        + R * base.D * base.C * base.psi
        + S * base.F**3 * base.phi
        + T * base.D**2 * base.phi
        + W * base.F * base.D * base.f18
    )


def reduced_degree_30() -> sp.Matrix:
    return (
        A * base.F**4 * base.D * base.psi
        + B * base.F * base.D**3 * base.psi
        + Q * base.F**2 * base.C * base.psi
        + S * base.F**2 * base.D * base.phi
        + U * base.C * base.phi
        + W * base.D**2 * base.f18
    )


def verify_common_factor_reductions() -> None:
    complete = sum(
        (parameter * vector for parameter, vector in zip(PARAMETERS, BASIS)),
        sp.zeros(3, 1),
    )
    assert all(
        sp.expand(
            complete[index].subs({Q: 0, U: 0, V: 0})
            - base.D * reduced_degree_28()[index]
        ) == 0
        for index in range(3)
    )
    assert all(
        sp.expand(
            complete[index].subs({R: 0, T: 0, V: 0})
            - base.F * reduced_degree_30()[index]
        ) == 0
        for index in range(3)
    )
    print("EXACT d=34: Q=U=0 reduces by D to degree 28")
    print("EXACT d=34: R=T=V=0 reduces by F to degree 30")


def branch_polynomials(
    jacobian_coefficients: dict[tuple[int, int, int], sp.Expr],
    landing: sp.Poly,
    ratio: str,
) -> tuple[sp.Poly, sp.Poly, tuple[sp.Symbol, ...], tuple[sp.Expr, ...]]:
    common = {R: 0, V: 0, U: 1, W: -T / 2}
    if ratio == "48":
        substitution = {**common, Q: 48}
        variables = (A, B, S, T, rho, Z)
        extra: tuple[sp.Expr, ...] = ()
    else:
        a_relation = (5 * Q**2 + 14 * Q * S - 312 * Q - 2816) / 14
        substitution = {**common, A: a_relation}
        variables = (B, S, T, rho, Q, Z)
        if ratio == "quadratic_1":
            extra = (Q**2 - 320 * Q + 19328,)
        elif ratio == "quadratic_2":
            extra = (9 * Q**2 - 192 * Q + 19840,)
        else:
            raise ValueError(ratio)

    K = sp.S.Zero
    for (i, j, k), coefficient in jacobian_coefficients.items():
        if i >= 1 and j >= 1:
            K += (
                coefficient.subs(substitution)
                * tensor_cache.F**(i - 1)
                * tensor_cache.D**(j - 1)
                * tensor_cache.C**k
            )
    K_polynomial = sp.Poly(
        sp.expand(K), tensor_cache.F, tensor_cache.D, tensor_cache.C
    )
    landing_polynomial = sp.Poly(
        sp.expand(landing.as_expr().subs(substitution)),
        tensor_cache.F,
        tensor_cache.D,
        tensor_cache.C,
    )
    return K_polynomial, landing_polynomial, variables, extra


def saturated_unit_check(
    name: str,
    K: sp.Poly,
    landing: sp.Poly,
    variables: tuple[sp.Symbol, ...],
    extra_equations: tuple[sp.Expr, ...],
) -> int:
    K_squared = sp.Poly(
        K.as_expr()**2, tensor_cache.F, tensor_cache.D, tensor_cache.C
    )
    monomials = set(K_squared.as_dict()) | set(landing.as_dict())
    coefficient_variables = variables[:-1]
    equations: list[sp.Expr] = []
    for monomial in monomials:
        equation = sp.together(
            K_squared.as_dict().get(monomial, 0)
            - rho * landing.as_dict().get(monomial, 0)
        )
        polynomial = sp.Poly(equation, *coefficient_variables).clear_denoms()[1]
        polynomial = sp.Poly(polynomial, *coefficient_variables).primitive()[1]
        if polynomial.as_expr() != 0:
            equations.append(polynomial.as_expr())
    equations.extend(extra_equations)
    equations.append(rho * variables[-1] - 1)
    equations = sorted(set(equations), key=lambda equation: (
        sp.Poly(equation, *variables).total_degree(),
        len(sp.Poly(equation, *variables).terms()),
        sp.sstr(equation),
    ))

    selected: list[sp.Expr] = []
    for equation in equations:
        selected.append(equation)
        if len(selected) < 3:
            continue
        groebner = sp.groebner(selected, *variables, order="grevlex")
        if len(groebner.polys) == 1 and groebner.polys[0].as_expr() == 1:
            print(
                f"EXACT d=34: {name} saturated unit ideal "
                f"after {len(selected)} coefficient equations"
            )
            return len(selected)
    raise AssertionError(f"branch {name} was not excluded")


def main() -> None:
    started = monotonic()
    landing = complete_landing()
    verify_residue_reductions(landing)
    verify_common_factor_reductions()
    jacobian_coefficients = jacobian_over_x_coefficients()

    counts = {}
    for name in ("48", "quadratic_1", "quadratic_2"):
        K, branch_landing, variables, extra = branch_polynomials(
            jacobian_coefficients, landing, name
        )
        counts[name] = saturated_unit_check(
            name, K, branch_landing, variables, extra
        )
    assert all(count >= 3 for count in counts.values())
    print(f"EXACT d=34: elapsed_seconds={monotonic() - started:.2f}")
    print("WP3_DEGREE34_EXCLUSION_OK")


if __name__ == "__main__":
    main()
