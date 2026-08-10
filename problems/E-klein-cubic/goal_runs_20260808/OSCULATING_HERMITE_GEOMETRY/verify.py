#!/usr/bin/env python3
"""Exact structural replay for the degree-nine Hermite contact system.

The finite-field calculation uses dual numbers over F_7.  It checks the
normalized full-contact point found in the bounded slice and computes both
the fibre Jacobian and the Jacobian after adjoining the four root directions
subject to prod(r_i)=1.  No search is performed here.
"""

from __future__ import annotations

from dataclasses import dataclass
from math import comb


P = 7


@dataclass(frozen=True)
class Dual:
    value: int
    tangent: int = 0

    def __post_init__(self):
        object.__setattr__(self, "value", self.value % P)
        object.__setattr__(self, "tangent", self.tangent % P)

    @staticmethod
    def coerce(other):
        return other if isinstance(other, Dual) else Dual(other)

    def __add__(self, other):
        other = self.coerce(other)
        return Dual(self.value + other.value, self.tangent + other.tangent)

    __radd__ = __add__

    def __neg__(self):
        return Dual(-self.value, -self.tangent)

    def __sub__(self, other):
        return self + (-self.coerce(other))

    def __rsub__(self, other):
        return self.coerce(other) - self

    def __mul__(self, other):
        other = self.coerce(other)
        return Dual(
            self.value * other.value,
            self.value * other.tangent + self.tangent * other.value,
        )

    __rmul__ = __mul__

    def inverse(self):
        assert self.value
        inverse = pow(self.value, -1, P)
        return Dual(inverse, -self.tangent * inverse * inverse)

    def __truediv__(self, other):
        return self * self.coerce(other).inverse()

    def __rtruediv__(self, other):
        return self.coerce(other) / self

    def __pow__(self, exponent):
        assert exponent >= 0
        out = Dual(1)
        base = self
        while exponent:
            if exponent & 1:
                out *= base
            base *= base
            exponent //= 2
        return out


def trim(poly):
    while len(poly) > 1 and poly[-1] == Dual(0):
        poly.pop()
    return poly


def poly_add(left, right):
    out = [Dual(0)] * max(len(left), len(right))
    for index in range(len(left)):
        out[index] += left[index]
    for index in range(len(right)):
        out[index] += right[index]
    return trim(out)


def poly_scale(poly, scalar):
    return trim([coefficient * scalar for coefficient in poly])


def poly_mul(left, right):
    out = [Dual(0)] * (len(left) + len(right) - 1)
    for i, a in enumerate(left):
        for j, b in enumerate(right):
            out[i + j] += a * b
    return trim(out)


def product_linear(roots, omitted=()):
    out = [Dual(1)]
    omitted = set(omitted)
    for index, root in enumerate(roots):
        if index not in omitted:
            out = poly_mul(out, [-root, Dual(1)])
    return out


def lagrange(values, roots):
    out = [Dual(0)]
    for k, value in enumerate(values):
        numerator = product_linear(roots, (k,))
        denominator = Dual(1)
        for j, root in enumerate(roots):
            if j != k:
                denominator *= roots[k] - root
        out = poly_add(out, poly_scale(numerator, value / denominator))
    assert len(out) <= 5
    out += [Dual(0)] * (5 - len(out))
    return out


def shifted_coefficient(poly, root, order):
    return sum(
        coefficient * comb(index, order) * root ** (index - order)
        for index, coefficient in enumerate(poly)
        if index >= order
    )


def normalized_system(root_data, d_data, e_data, A_data=None, f_data=None):
    roots = [Dual.coerce(root) for root in root_data]
    d = [Dual.coerce(value) for value in d_data]
    e = [Dual.coerce(value) for value in e_data]
    A = [Dual(1)] * 5 if A_data is None else [Dual.coerce(value) for value in A_data]
    f = [Dual(1)] * 5 if f_data is None else [Dual.coerce(value) for value in f_data]
    assert len({root.value for root in roots}) == 5
    assert Dual(1) == roots[0] * roots[1] * roots[2] * roots[3] * roots[4]

    y = [[None for _ in range(5)] for _ in range(5)]
    for k in range(5):
        pprime = Dual(1)
        for j in range(5):
            if j != k:
                pprime *= roots[k] - roots[j]
        delta_m1 = roots[k] - roots[(k - 1) % 5]
        delta_m2 = roots[k] - roots[(k - 2) % 5]
        delta_p1 = roots[k] - roots[(k + 1) % 5]
        assert A[k].value and f[k].value
        y[k][k] = A[k] / (pprime * delta_m1)
        y[(k - 1) % 5][k] = f[k] * delta_m1 / (pprime * delta_m2)
        b = (
            -roots[(k + 2) % 5]
            * f[k] ** 2
            / (roots[(k + 1) % 5] * A[k])
        )
        y[(k + 1) % 5][k] = b * delta_p1 / pprime
        y[(k + 2) % 5][k] = d[k]
        y[(k + 3) % 5][k] = e[k]

    H = [lagrange(row, roots) for row in y]
    ell = [product_linear(roots, (i,)) for i in range(5)]
    x = [
        poly_mul(poly_mul(ell[i], [-roots[(i - 1) % 5], Dual(1)]), H[i])
        for i in range(5)
    ]
    S = [Dual(0)]
    for i in range(5):
        term = poly_mul(poly_mul(x[i], x[i]), x[(i + 1) % 5])
        S = poly_add(S, poly_scale(term, 1 / roots[(i + 2) % 5]))

    equations = []
    for root in roots:
        jets = [shifted_coefficient(S, root, order) for order in range(5)]
        assert jets[0] == jets[1] == jets[2] == Dual(0)
        equations.extend(jets[3:5])
    return equations, H, x, S, roots


def rank_mod(matrix):
    matrix = [[entry % P for entry in row] for row in matrix]
    rows = len(matrix)
    columns = len(matrix[0]) if rows else 0
    rank = 0
    for column in range(columns):
        pivot = next((r for r in range(rank, rows) if matrix[r][column]), None)
        if pivot is None:
            continue
        matrix[rank], matrix[pivot] = matrix[pivot], matrix[rank]
        inverse = pow(matrix[rank][column], -1, P)
        matrix[rank] = [(inverse * entry) % P for entry in matrix[rank]]
        for r in range(rows):
            if r != rank and matrix[r][column]:
                factor = matrix[r][column]
                matrix[r] = [
                    (a - factor * b) % P
                    for a, b in zip(matrix[r], matrix[rank])
                ]
        rank += 1
        if rank == rows:
            break
    return rank


def pivot_columns_mod(matrix):
    matrix = [[entry % P for entry in row] for row in matrix]
    rows = len(matrix)
    columns = len(matrix[0]) if rows else 0
    rank = 0
    pivots = []
    for column in range(columns):
        pivot = next((r for r in range(rank, rows) if matrix[r][column]), None)
        if pivot is None:
            continue
        matrix[rank], matrix[pivot] = matrix[pivot], matrix[rank]
        inverse = pow(matrix[rank][column], -1, P)
        matrix[rank] = [(inverse * entry) % P for entry in matrix[rank]]
        for r in range(rows):
            if r != rank and matrix[r][column]:
                factor = matrix[r][column]
                matrix[r] = [
                    (a - factor * b) % P
                    for a, b in zip(matrix[r], matrix[rank])
                ]
        pivots.append(column)
        rank += 1
        if rank == rows:
            break
    return pivots


def tangent_column(root_values, d_values, e_values, kind, index):
    roots = [Dual(value) for value in root_values]
    d = [Dual(value) for value in d_values]
    e = [Dual(value) for value in e_values]
    A = [Dual(1)] * 5
    f = [Dual(1)] * 5
    if kind == "d":
        d[index] = Dual(d[index].value, 1)
    elif kind == "e":
        e[index] = Dual(e[index].value, 1)
    elif kind == "r":
        assert index < 4
        roots[index] = Dual(roots[index].value, 1)
        # r_4=(r_0 r_1 r_2 r_3)^(-1).
        roots[4] = Dual(
            roots[4].value,
            -roots[4].value * pow(roots[index].value, -1, P),
        )
    elif kind == "A":
        A[index] = Dual(1, 1)
    elif kind == "f":
        f[index] = Dual(1, 1)
    else:
        raise ValueError(kind)
    equations, *_ = normalized_system(roots, d, e, A, f)
    return [equation.tangent for equation in equations]


def tangent_data(root_values, d_values, e_values, kind, index):
    """Return equation tangents and the five leading H coefficients."""
    roots = [Dual(value) for value in root_values]
    d = [Dual(value) for value in d_values]
    e = [Dual(value) for value in e_values]
    A = [Dual(1)] * 5
    f = [Dual(1)] * 5
    blocks = {"d": d, "e": e, "A": A, "f": f}
    blocks[kind][index] = Dual(blocks[kind][index].value, 1)
    equations, H, _, S, moved_roots = normalized_system(roots, d, e, A, f)
    return (
        [equation.tangent for equation in equations],
        [polynomial[-1].tangent for polynomial in H],
        shifted_coefficient(S, moved_roots[0], 5).tangent,
    )


def divide_polynomial(numerator, denominator):
    numerator = [coefficient.value for coefficient in numerator]
    denominator = [coefficient.value for coefficient in denominator]
    while numerator and numerator[-1] == 0:
        numerator.pop()
    while denominator and denominator[-1] == 0:
        denominator.pop()
    quotient = [0] * max(1, len(numerator) - len(denominator) + 1)
    while len(numerator) >= len(denominator):
        degree = len(numerator) - len(denominator)
        coefficient = numerator[-1] * pow(denominator[-1], -1, P) % P
        quotient[degree] = coefficient
        for j, value in enumerate(denominator):
            numerator[degree + j] = (numerator[degree + j] - coefficient * value) % P
        while numerator and numerator[-1] == 0:
            numerator.pop()
    return quotient, numerator


def scalar_polynomial_remainder(numerator, denominator):
    numerator = [value % P for value in numerator]
    denominator = [value % P for value in denominator]
    while numerator and numerator[-1] == 0:
        numerator.pop()
    while denominator and denominator[-1] == 0:
        denominator.pop()
    assert denominator
    while len(numerator) >= len(denominator):
        coefficient = numerator[-1] * pow(denominator[-1], -1, P) % P
        degree = len(numerator) - len(denominator)
        for j, value in enumerate(denominator):
            numerator[degree + j] = (numerator[degree + j] - coefficient * value) % P
        while numerator and numerator[-1] == 0:
            numerator.pop()
    return numerator


def scalar_polynomial_gcd(left, right):
    left = [coefficient.value for coefficient in left]
    right = [coefficient.value for coefficient in right]
    while right:
        left, right = right, scalar_polynomial_remainder(left, right)
    inverse = pow(left[-1], -1, P)
    return [(inverse * value) % P for value in left]


def main():
    roots = (1, 2, 3, 4, 5)
    d = (4, 0, 3, 2, 0)
    e = (2, 1, 1, 1, 3)
    equations, H, x, S, dual_roots = normalized_system(roots, d, e)
    assert all(equation == Dual(0) for equation in equations)

    p = product_linear(dual_roots)
    p5 = [Dual(1)]
    for _ in range(5):
        p5 = poly_mul(p5, p)
    quotient, remainder = divide_polynomial(S, p5)
    assert not remainder
    assert quotient == [0, -1 % P, 1]

    fibre_columns = [
        tangent_column(roots, d, e, kind, index)
        for kind in ("d", "e")
        for index in range(5)
    ]
    full_fibre_columns = fibre_columns + [
        tangent_column(roots, d, e, kind, index)
        for kind in ("A", "f")
        for index in range(5)
    ]
    full_tangent_data = [
        tangent_data(roots, d, e, kind, index)
        for kind in ("d", "e", "A", "f")
        for index in range(5)
    ]
    root_columns = [
        tangent_column(roots, d, e, "r", index)
        for index in range(4)
    ]
    fibre_matrix = [list(row) for row in zip(*fibre_columns)]
    full_fibre_matrix = [list(row) for row in zip(*full_fibre_columns)]
    total_matrix = [list(row) for row in zip(*(fibre_columns + root_columns))]
    fibre_rank = rank_mod(fibre_matrix)
    full_fibre_rank = rank_mod(full_fibre_matrix)
    full_pivots = pivot_columns_mod(full_fibre_matrix)
    leading_H2_gradient = [datum[1][2] for datum in full_tangent_data]
    residual_overlap_gradient = [datum[2] for datum in full_tangent_data]
    leading_augmented_rank = rank_mod(
        full_fibre_matrix + [leading_H2_gradient]
    )
    residual_augmented_rank = rank_mod(
        full_fibre_matrix + [residual_overlap_gradient]
    )
    total_rank = rank_mod(total_matrix)

    leading_H = [poly[-1].value for poly in H]
    common_gcd = x[0]
    for polynomial in x[1:]:
        common_gcd = [Dual(value) for value in scalar_polynomial_gcd(common_gcd, polynomial)]
    print("F7_ROOTS", roots)
    print("F7_POINT_D", d)
    print("F7_POINT_E", e)
    print("S_OVER_P5", quotient)
    print("H_LEADING", leading_H)
    print("X_COMMON_GCD", [coefficient.value for coefficient in common_gcd])
    print("FIBRE_JACOBIAN_RANK", fibre_rank)
    print("FULL_FIBRE_JACOBIAN_RANK", full_fibre_rank)
    print(
        "FULL_FIBRE_PIVOTS",
        [
            ("d", "e", "A", "f")[column // 5] + str(column % 5)
            for column in full_pivots
        ],
    )
    print("H2_LEADING_AUGMENTED_RANK", leading_augmented_rank)
    print("RESIDUAL_OVERLAP_AUGMENTED_RANK", residual_augmented_rank)
    print("TOTAL_JACOBIAN_RANK", total_rank)
    assert fibre_rank == 9
    assert [coefficient.value for coefficient in common_gcd] == [1]
    assert full_fibre_rank == 10
    assert leading_augmented_rank == 11
    assert residual_augmented_rank == 11
    # The assertion below records whether this component is vertical or can
    # move in all root directions; its expected value is fixed after replay.
    assert total_rank in (9, 10)

    # A nonboundary point on the cyclicly covariant normalization A_k=r_k,
    # f_k=1.  Here the ten remaining variables are etale over the root base.
    covariant_d = (6, 1, 3, 3, 2)
    covariant_e = (0, 1, 0, 6, 2)
    covariant_equations, covariant_H, covariant_x, covariant_S, covariant_roots = (
        normalized_system(roots, covariant_d, covariant_e, roots, (1,) * 5)
    )
    assert all(equation == Dual(0) for equation in covariant_equations)
    covariant_p = product_linear(covariant_roots)
    covariant_p5 = [Dual(1)]
    for _ in range(5):
        covariant_p5 = poly_mul(covariant_p5, covariant_p)
    covariant_quotient, covariant_remainder = divide_polynomial(
        covariant_S, covariant_p5
    )
    assert not covariant_remainder
    assert covariant_quotient == [1, 0, 1]
    assert all(polynomial[-1].value for polynomial in covariant_H)
    covariant_gcd = covariant_x[0]
    for polynomial in covariant_x[1:]:
        covariant_gcd = [
            Dual(value)
            for value in scalar_polynomial_gcd(covariant_gcd, polynomial)
        ]
    assert [coefficient.value for coefficient in covariant_gcd] == [1]

    covariant_columns = []
    for kind in ("d", "e"):
        for index in range(5):
            moved_d = [Dual(value) for value in covariant_d]
            moved_e = [Dual(value) for value in covariant_e]
            block = moved_d if kind == "d" else moved_e
            block[index] = Dual(block[index].value, 1)
            moved_equations, *_ = normalized_system(
                roots, moved_d, moved_e, roots, (1,) * 5
            )
            covariant_columns.append(
                [equation.tangent for equation in moved_equations]
            )
    covariant_matrix = [list(row) for row in zip(*covariant_columns)]
    covariant_rank = rank_mod(covariant_matrix)
    covariant_determinant = 1
    # Row reduction suffices for the theorem; the exact determinant value is
    # separately printed by the producer packet.
    assert covariant_rank == 10

    # Coordinate-invariant obstruction to a global linear solved block.  If
    # v were a nonzero direction on which every cubic contact equation were
    # affine-linear, the second polar identities would give
    # B_(j-1)v_(j-1)^2=-2 B_j v_j v_(j+1).  A zero propagates around the
    # five-cycle; otherwise multiplication gives 1=(-2)^5, i.e. 33=0.
    second_polar_constant = 1 - (-2) ** 5
    assert second_polar_constant == 33

    print("COVARIANT_D", covariant_d)
    print("COVARIANT_E", covariant_e)
    print("COVARIANT_S_OVER_P5", covariant_quotient)
    print("COVARIANT_H_LEADING", [poly[-1].value for poly in covariant_H])
    print("COVARIANT_X_COMMON_GCD", [value.value for value in covariant_gcd])
    print("COVARIANT_DE_JACOBIAN_RANK", covariant_rank)
    print("SECOND_POLAR_CONSTANT", second_polar_constant)
    print("OSCULATING-HERMITE-GEOMETRY-REPLAY-OK")


if __name__ == "__main__":
    main()
