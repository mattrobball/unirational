#!/usr/bin/env python3
"""Exact certificate for the two A4-character surface parameters.

The script reconstructs a representative V4 and its A4 normalizer directly
inside the exact Q(zeta_11) Weil representation, extends scalars by a root
omega of omega^2+omega+1, diagonalizes the residual C3 action, restricts the
Klein cubic, and computes the scale-invariant surface parameters kappa_+ and
kappa_-.  It verifies

    kappa_+ + kappa_- = 13/8,
    kappa_+ * kappa_- = -1/2,
    (kappa_+ - kappa_-)^2 = 297/64.

It then verifies the discriminant formula for the reciprocal trisection
quotient and the resultant showing that its degree-six branch polynomial is
squarefree.
"""

from __future__ import annotations

import importlib.util
from collections import defaultdict
from fractions import Fraction
from pathlib import Path

import sympy as sp


HERE = Path(__file__).resolve().parent
PROBLEM = HERE.parents[1]
EXACT = PROBLEM / "certificates" / "exact_weil_check.py"


def load(name: str, path: Path):
    spec = importlib.util.spec_from_file_location(name, path)
    assert spec and spec.loader
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


ew = load("v4_kappa_exact_weil", EXACT)
C = ew.C


def cinv(value: C) -> C:
    assert value != 0
    Z = sp.Symbol("Z")
    polynomial = sp.Poly(
        sum(sp.Rational(c.numerator, c.denominator) * Z**i
            for i, c in enumerate(value.a)),
        Z,
        domain=sp.QQ,
    )
    cyclotomic = sp.Poly(sum(Z**i for i in range(11)), Z, domain=sp.QQ)
    inverse = sp.invert(polynomial, cyclotomic)
    coefficients = [Fraction(0)] * 10
    for (exponent,), coefficient in sp.Poly(inverse, Z, domain=sp.QQ).terms():
        coefficients[exponent] = Fraction(int(coefficient.p), int(coefficient.q))
    return C(coefficients)


class E:
    """Q(zeta_11, omega), represented as a+b*omega, omega^2+omega+1=0."""

    __slots__ = ("a", "b")

    def __init__(self, a=0, b=0):
        if isinstance(a, E) and b == 0:
            self.a, self.b = a.a, a.b
        else:
            self.a, self.b = C(a), C(b)

    def __add__(self, other):
        other = E(other)
        return E(self.a + other.a, self.b + other.b)

    __radd__ = __add__

    def __neg__(self):
        return E(-self.a, -self.b)

    def __sub__(self, other):
        return self + (-E(other))

    def __rsub__(self, other):
        return E(other) - self

    def __mul__(self, other):
        other = E(other)
        return E(
            self.a * other.a - self.b * other.b,
            self.a * other.b + self.b * other.a - self.b * other.b,
        )

    __rmul__ = __mul__

    def conjugate_omega(self):
        return E(self.a - self.b, -self.b)

    def inverse(self):
        conjugate = self.conjugate_omega()
        norm = self * conjugate
        assert norm.b == 0 and norm.a != 0
        inverse_norm = cinv(norm.a)
        return E(conjugate.a * inverse_norm, conjugate.b * inverse_norm)

    def __truediv__(self, other):
        if isinstance(other, (int, Fraction, C)):
            return E(self.a / other, self.b / other)
        return self * E(other).inverse()

    def __pow__(self, exponent: int):
        if exponent < 0:
            return self.inverse() ** (-exponent)
        result, base = E(1), self
        while exponent:
            if exponent & 1:
                result *= base
            base *= base
            exponent //= 2
        return result

    def __eq__(self, other):
        other = E(other)
        return self.a == other.a and self.b == other.b

    def __repr__(self):
        return f"E({self.a!r}, {self.b!r})"


OMEGA = E(0, 1)
assert OMEGA**2 + OMEGA + 1 == 0


def group_order(key) -> int:
    current = ew.fone
    for order in range(1, 13):
        current = ew.fcanon(ew.fmul(current, key))
        if current == ew.fone:
            return order
    raise AssertionError(key)


def group_inverse(key):
    order = group_order(key)
    current = ew.fone
    for _ in range(order - 1):
        current = ew.fcanon(ew.fmul(current, key))
    return current


def conjugate(g, h):
    return ew.fcanon(ew.fmul(ew.fmul(g, h), group_inverse(g)))


def matmul(left, right):
    return [
        [sum(left[i][k] * right[k][j] for k in range(len(right)))
         for j in range(len(right[0]))]
        for i in range(len(left))
    ]


def matvec(matrix, vector):
    return [
        sum(matrix[i][j] * vector[j] for j in range(len(vector)))
        for i in range(len(matrix))
    ]


def rref(matrix, inverse):
    answer = [list(row) for row in matrix]
    rows = len(answer)
    columns = len(answer[0]) if rows else 0
    pivots = []
    target = 0
    for column in range(columns):
        pivot = next(
            (row for row in range(target, rows) if answer[row][column] != 0),
            None,
        )
        if pivot is None:
            continue
        answer[target], answer[pivot] = answer[pivot], answer[target]
        scale = inverse(answer[target][column])
        answer[target] = [scale * value for value in answer[target]]
        for row in range(rows):
            if row == target or answer[row][column] == 0:
                continue
            scale = answer[row][column]
            answer[row] = [
                value - scale * pivot_value
                for value, pivot_value in zip(answer[row], answer[target])
            ]
        pivots.append(column)
        target += 1
        if target == rows:
            break
    return answer, pivots


def nullspace(matrix, zero, one, inverse):
    reduced, pivots = rref(matrix, inverse)
    columns = len(matrix[0])
    free = [column for column in range(columns) if column not in pivots]
    result = []
    for free_column in free:
        vector = [zero for _ in range(columns)]
        vector[free_column] = one
        for row, pivot in enumerate(pivots):
            vector[pivot] = -reduced[row][free_column]
        result.append(vector)
    return result


def c_nullspace(matrix):
    return nullspace(matrix, C(0), C(1), cinv)


def e_rref(matrix):
    return rref(matrix, E(0).inverse if False else lambda value: value.inverse())


def lift_matrix(matrix):
    return [[E(value) for value in row] for row in matrix]


def add_matrices(*matrices):
    return [
        [sum(matrix[i][j] for matrix in matrices)
         for j in range(len(matrices[0][0]))]
        for i in range(len(matrices[0]))
    ]


def scale_matrix(scalar, matrix):
    return [[scalar * value for value in row] for row in matrix]


def product(values):
    answer = E(1)
    for value in values:
        answer *= value
    return answer


def representative_v4_and_normalizer():
    involutions = sorted(key for key in ew.rho if group_order(key) == 2)
    first = involutions[0]
    second = next(
        key for key in involutions
        if key != first
        and ew.fcanon(ew.fmul(first, key)) == ew.fcanon(ew.fmul(key, first))
    )
    third = ew.fcanon(ew.fmul(first, second))
    subgroup = {ew.fone, first, second, third}
    normalizer = [
        key for key in ew.rho
        if {conjugate(key, element) for element in subgroup} == subgroup
    ]
    assert len(normalizer) == 12
    generator = next(key for key in normalizer if group_order(key) == 3)
    return first, second, subgroup, normalizer, generator


def simultaneous_eigenspace(first, second, sign_first, sign_second):
    equations = []
    for key, sign in ((first, sign_first), (second, sign_second)):
        matrix = ew.rho[key]
        equations.extend([
            [matrix[i][j] - C(sign if i == j else 0) for j in range(5)]
            for i in range(5)
        ])
    return c_nullspace(equations)


def main():
    first, second, subgroup, normalizer, generator = representative_v4_and_normalizer()
    assert len(subgroup) == 4 and len(normalizer) == 12

    fixed = simultaneous_eigenspace(first, second, 1, 1)
    nontrivial = simultaneous_eigenspace(first, second, 1, -1)
    assert len(fixed) == 2 and len(nontrivial) == 1

    action = lift_matrix(ew.rho[generator])
    action_squared = matmul(action, action)
    identity = [[E(1 if i == j else 0) for j in range(5)] for i in range(5)]

    projector_omega = scale_matrix(
        E(1) / 3,
        add_matrices(
            identity,
            scale_matrix(OMEGA**2, action),
            scale_matrix(OMEGA, action_squared),
        ),
    )
    projector_omega_squared = scale_matrix(
        E(1) / 3,
        add_matrices(
            identity,
            scale_matrix(OMEGA, action),
            scale_matrix(OMEGA**2, action_squared),
        ),
    )

    fixed_lifted = [[E(value) for value in vector] for vector in fixed]
    plus_candidates = [matvec(projector_omega, vector) for vector in fixed_lifted]
    minus_candidates = [matvec(projector_omega_squared, vector) for vector in fixed_lifted]
    a_plus = next(vector for vector in plus_candidates if any(value != 0 for value in vector))
    a_minus = next(vector for vector in minus_candidates if any(value != 0 for value in vector))
    assert matvec(action, a_plus) == [OMEGA * value for value in a_plus]
    assert matvec(action, a_minus) == [OMEGA**2 * value for value in a_minus]

    u0 = [E(value) for value in nontrivial[0]]
    u1 = matvec(action, u0)
    u2 = matvec(action, u1)
    basis = [[a_plus[i], a_minus[i], u0[i], u1[i], u2[i]] for i in range(5)]
    _, pivots = rref(basis, lambda value: value.inverse())
    assert pivots == [0, 1, 2, 3, 4]

    coefficients = defaultdict(lambda: E(0))
    for index in range(5):
        for left in range(5):
            for middle in range(5):
                for right in range(5):
                    exponents = [0] * 5
                    exponents[left] += 1
                    exponents[middle] += 1
                    exponents[right] += 1
                    monomial = tuple(exponents)
                    coefficients[monomial] += (
                        basis[index][left]
                        * basis[index][middle]
                        * basis[(index + 1) % 5][right]
                    )

    nonzero = {monomial: value for monomial, value in coefficients.items() if value != 0}
    expected_support = {
        (3, 0, 0, 0, 0),
        (0, 3, 0, 0, 0),
        (1, 0, 2, 0, 0),
        (1, 0, 0, 2, 0),
        (1, 0, 0, 0, 2),
        (0, 1, 2, 0, 0),
        (0, 1, 0, 2, 0),
        (0, 1, 0, 0, 2),
        (0, 0, 1, 1, 1),
    }
    assert set(nonzero) == expected_support

    product_coefficient = nonzero[(0, 0, 1, 1, 1)]
    plus_quadratics = [
        nonzero[(1, 0, 2, 0, 0)],
        nonzero[(1, 0, 0, 2, 0)],
        nonzero[(1, 0, 0, 0, 2)],
    ]
    minus_quadratics = [
        nonzero[(0, 1, 2, 0, 0)],
        nonzero[(0, 1, 0, 2, 0)],
        nonzero[(0, 1, 0, 0, 2)],
    ]
    kappa_plus = (
        nonzero[(3, 0, 0, 0, 0)]
        * product_coefficient**2
        / product(plus_quadratics)
    )
    kappa_minus = (
        nonzero[(0, 3, 0, 0, 0)]
        * product_coefficient**2
        / product(minus_quadratics)
    )

    assert kappa_plus + kappa_minus == E(C(Fraction(13, 8)))
    assert kappa_plus * kappa_minus == E(C(Fraction(-1, 2)))
    assert (kappa_plus - kappa_minus)**2 == E(C(Fraction(297, 64)))
    assert kappa_plus != kappa_minus
    assert kappa_plus not in (E(0), E(-4))
    assert kappa_minus not in (E(0), E(-4))

    t, k_plus, k_minus = sp.symbols("t k_plus k_minus")
    rational_trace = 2 + (k_plus * t**3 + k_minus) / (t**3 + 1)
    branch_product = (
        (k_plus * t**3 + k_minus)
        * ((k_plus + 4) * t**3 + k_minus + 4)
    )
    assert sp.factor(
        rational_trace**2 - 4 - branch_product / (t**3 + 1)**2
    ) == 0
    resultant = sp.factor(sp.resultant(
        k_plus * t**3 + k_minus,
        (k_plus + 4) * t**3 + k_minus + 4,
        t,
    ))
    assert resultant == 64 * (k_plus - k_minus)**3

    print("PASS representative V4 and A4 normalizer reconstructed exactly")
    print("PASS exact A4-character Klein-cubic normal form support")
    print("PASS kappa sum=13/8 product=-1/2 difference^2=297/64")
    print("PASS reciprocal-cover discriminant and squarefree resultant")
    print("V4_KAPPA_GENUS2_VERIFY_OK")


if __name__ == "__main__":
    main()
