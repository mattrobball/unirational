#!/usr/bin/env python3
"""Exact certificate for the nondegenerate mod-7 osculating component."""

from __future__ import annotations

import sympy as sp

from probe_normalized_slice import build_system


P = 7
T = sp.Symbol("T")
ROOTS_Q = (1, 2, 3, 4, sp.Rational(1, 24))
ROOTS = (1, 2, 3, 4, 5)  # reduction of ROOTS_Q modulo 7
A_VALUES = ROOTS_Q         # the cyclic-equivariant normalization A_k=r_k
F_VALUES = (1, 1, 1, 1, 1)
POINTS = (
    (6, 1, 3, 3, 2, 0, 1, 0, 6, 2),
    (3, 0, 4, 0, 4, 2, 3, 6, 2, 6),
    (0, 3, 3, 6, 0, 0, 5, 0, 6, 1),
)
EXPECTED_DETERMINANTS = (5, 1, 4)
EXPECTED_QUOTIENTS = (T**2 + 1, 3 - T, -3 * T**2 + 3 * T + 1)


def inverse(value):
    return pow(int(value) % P, -1, P)


def rational_mod(value):
    return int(value.p) * inverse(value.q) % P


def reconstruct(point):
    """Reconstruct H_i, x_i, S from d,e over F_7."""
    d, e = point[:5], point[5:]
    p = sp.Poly(sp.prod(T - root for root in ROOTS), T, modulus=P)
    y = [[None] * 5 for _ in range(5)]
    for k, root in enumerate(ROOTS):
        pprime = int(p.diff().eval(root)) % P
        delta_m1 = (root - ROOTS[(k - 1) % 5]) % P
        delta_m2 = (root - ROOTS[(k - 2) % 5]) % P
        delta_p1 = (root - ROOTS[(k + 1) % 5]) % P

        # A_k=r_k and f_k=1.
        y[k][k] = root * inverse(pprime * delta_m1) % P
        y[(k - 1) % 5][k] = delta_m1 * inverse(pprime * delta_m2) % P

        # J2 determines b_k=-(c_(k-1)/c_k)f_k^2/A_k.
        b_leading = (
            -ROOTS[(k + 2) % 5]
            * inverse(ROOTS[(k + 1) % 5] * root)
        ) % P
        y[(k + 1) % 5][k] = b_leading * delta_p1 * inverse(pprime) % P
        y[(k + 2) % 5][k] = d[k]
        y[(k + 3) % 5][k] = e[k]

    H = []
    for i in range(5):
        polynomial = sp.Poly(0, T, modulus=P)
        for k, root in enumerate(ROOTS):
            cardinal = sp.Poly(1, T, modulus=P)
            denominator = 1
            for j, other in enumerate(ROOTS):
                if j == k:
                    continue
                cardinal *= sp.Poly(T - other, T, modulus=P)
                denominator = denominator * (root - other) % P
            polynomial += cardinal.mul_ground(y[i][k] * inverse(denominator) % P)
        H.append(polynomial)

    ell = [
        p.exquo(sp.Poly(T - ROOTS[i], T, modulus=P))
        for i in range(5)
    ]
    x = [
        ell[i] * sp.Poly(T - ROOTS[(i - 1) % 5], T, modulus=P) * H[i]
        for i in range(5)
    ]
    S = sp.Poly(0, T, modulus=P)
    for i in range(5):
        S += (x[i] ** 2 * x[(i + 1) % 5]).mul_ground(
            inverse(ROOTS[(i + 2) % 5])
        )
    return p, y, H, x, S


def evaluate_mod(poly, variables, point):
    value = poly.eval(dict(zip(variables, point)))
    return rational_mod(value)


def resultant_mod(left, right):
    """Sylvester determinant over F_7, avoiding a second CAS elimination."""
    m, n = left.degree(), right.degree()
    left_coefficients = [int(value) % P for value in left.all_coeffs()]
    right_coefficients = [int(value) % P for value in right.all_coeffs()]
    matrix = [[0] * (m + n) for _ in range(m + n)]
    for row in range(n):
        matrix[row][row:row + m + 1] = left_coefficients
    for row in range(m):
        matrix[n + row][row:row + n + 1] = right_coefficients

    determinant = 1
    for column in range(m + n):
        pivot = next(row for row in range(column, m + n) if matrix[row][column])
        if pivot != column:
            matrix[column], matrix[pivot] = matrix[pivot], matrix[column]
            determinant = -determinant
        value = matrix[column][column] % P
        determinant = determinant * value % P
        scale = inverse(value)
        matrix[column] = [entry * scale % P for entry in matrix[column]]
        for row in range(column + 1, m + n):
            scale = matrix[row][column]
            if scale:
                matrix[row] = [
                    (entry - scale * pivot_entry) % P
                    for entry, pivot_entry in zip(matrix[row], matrix[column])
                ]
    return determinant % P


def main():
    assert sp.prod(ROOTS_Q) == 1
    assert len(set(ROOTS)) == 5

    variables, equations, _, _, _, _, contact = build_system(
        ROOTS_Q,
        A_values=A_VALUES,
        f_values=F_VALUES,
    )
    assert len(variables) == len(equations) == 10

    jacobian = sp.Matrix([poly.as_expr() for poly in equations]).jacobian(variables)
    jacobian_polys = [
        [sp.Poly(jacobian[i, j], *variables, domain=sp.QQ) for j in range(10)]
        for i in range(10)
    ]

    for number, (point, expected_det, expected_quotient) in enumerate(zip(
        POINTS, EXPECTED_DETERMINANTS, EXPECTED_QUOTIENTS
    ), start=1):
        assert all(evaluate_mod(poly, variables, point) == 0 for poly in equations)

        # All coefficients through order four vanish at every marked root.
        for row in contact:
            for coefficient in row:
                poly = sp.Poly(coefficient, *variables, domain=sp.QQ)
                assert evaluate_mod(poly, variables, point) == 0

        matrix = [
            [evaluate_mod(jacobian_polys[i][j], variables, point) for j in range(10)]
            for i in range(10)
        ]
        determinant = int(sp.Matrix(matrix).det()) % P
        assert determinant == expected_det != 0

        p, _, H, x, S = reconstruct(point)
        assert all(polynomial.degree() == 4 for polynomial in H)
        assert all(polynomial.degree() == 9 for polynomial in x)
        gcd = x[0]
        for polynomial in x[1:]:
            gcd = sp.gcd(gcd, polynomial)
        assert gcd.degree() == 0
        sum_x = sum(x, sp.Poly(0, T, modulus=P))
        basepoint_resultant = resultant_mod(x[4], sum_x)
        assert basepoint_resultant == 3

        quotient, remainder = S.div(p**5)
        assert remainder.is_zero
        assert quotient == sp.Poly(expected_quotient, T, modulus=P)
        assert quotient.degree() >= 1
        print(
            f"PASS point {number}: det={determinant}, "
            f"degrees=9, resultant=3, residual={quotient.as_expr()}"
        )

    print("F55-OSCULATING-GENERAL-H-NONDEGENERATE-COMPONENT-MOD7")


if __name__ == "__main__":
    main()
