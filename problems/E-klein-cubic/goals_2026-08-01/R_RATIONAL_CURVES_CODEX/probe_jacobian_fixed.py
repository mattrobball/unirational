#!/usr/bin/env python3
"""Exact probe for common fixed points on the Klein intermediate Jacobian.

The input lattice is Roulleau's O-basis, where
O = Z[nu], nu^2 + nu + 3 = 0.  We reconstruct the order-11 and order-5
actions, convert them to integral 10 x 10 matrices, and compute common
invariants modulo the only relevant primes 5 and 11.
"""

from __future__ import annotations

from dataclasses import dataclass
from fractions import Fraction


@dataclass(frozen=True)
class Qnu:
    """a + b*nu in Q(nu), with nu^2 + nu + 3 = 0."""

    a: Fraction = Fraction(0)
    b: Fraction = Fraction(0)

    def __add__(self, other: object) -> "Qnu":
        other = q(other)
        return Qnu(self.a + other.a, self.b + other.b)

    __radd__ = __add__

    def __neg__(self) -> "Qnu":
        return Qnu(-self.a, -self.b)

    def __sub__(self, other: object) -> "Qnu":
        return self + (-q(other))

    def __rsub__(self, other: object) -> "Qnu":
        return q(other) - self

    def __mul__(self, other: object) -> "Qnu":
        other = q(other)
        return Qnu(
            self.a * other.a - 3 * self.b * other.b,
            self.a * other.b + self.b * other.a - self.b * other.b,
        )

    __rmul__ = __mul__

    def inverse(self) -> "Qnu":
        norm = self.a * self.a - self.a * self.b + 3 * self.b * self.b
        if norm == 0:
            raise ZeroDivisionError
        return Qnu((self.a - self.b) / norm, -self.b / norm)

    def __truediv__(self, other: object) -> "Qnu":
        return self * q(other).inverse()

    def __pow__(self, exponent: int) -> "Qnu":
        if exponent < 0:
            return (self.inverse()) ** (-exponent)
        result = Qnu(Fraction(1), Fraction(0))
        base = self
        while exponent:
            if exponent & 1:
                result = result * base
            base = base * base
            exponent >>= 1
        return result


def q(value: object) -> Qnu:
    if isinstance(value, Qnu):
        return value
    return Qnu(Fraction(value), Fraction(0))


ZERO = q(0)
ONE = q(1)
NU = Qnu(Fraction(0), Fraction(1))


def identity(n: int) -> list[list[Qnu]]:
    return [[ONE if i == j else ZERO for j in range(n)] for i in range(n)]


def matmul(a: list[list[Qnu]], b: list[list[Qnu]]) -> list[list[Qnu]]:
    return [
        [sum((a[i][k] * b[k][j] for k in range(len(b))), ZERO) for j in range(len(b[0]))]
        for i in range(len(a))
    ]


def matvec(a: list[list[Qnu]], v: list[Qnu]) -> list[Qnu]:
    return [sum((a[i][j] * v[j] for j in range(len(v))), ZERO) for i in range(len(a))]


def inverse(a: list[list[Qnu]]) -> list[list[Qnu]]:
    n = len(a)
    aug = [row[:] + ident[:] for row, ident in zip(a, identity(n))]
    for col in range(n):
        pivot = next(row for row in range(col, n) if aug[row][col] != ZERO)
        aug[col], aug[pivot] = aug[pivot], aug[col]
        scale = aug[col][col].inverse()
        aug[col] = [scale * x for x in aug[col]]
        for row in range(n):
            if row == col:
                continue
            scale = aug[row][col]
            if scale != ZERO:
                aug[row] = [x - scale * y for x, y in zip(aug[row], aug[col])]
    return [row[n:] for row in aug]


def matpow(a: list[list[Qnu]], exponent: int) -> list[list[Qnu]]:
    result = identity(len(a))
    base = a
    while exponent:
        if exponent & 1:
            result = matmul(result, base)
        base = matmul(base, base)
        exponent >>= 1
    return result


def columns(cols: list[list[Qnu]]) -> list[list[Qnu]]:
    return [[cols[j][i] for j in range(len(cols))] for i in range(len(cols[0]))]


def integral_matrix(a: list[list[Qnu]]) -> list[list[int]]:
    """Restriction of scalars in basis (b0,nu*b0,b1,nu*b1,...)."""
    n = len(a)
    out = [[0 for _ in range(2 * n)] for _ in range(2 * n)]
    for i in range(n):
        for j in range(n):
            c = a[i][j]
            assert c.a.denominator == 1 and c.b.denominator == 1, c
            aa, bb = int(c.a), int(c.b)
            out[2 * i][2 * j] = aa
            out[2 * i + 1][2 * j] = bb
            out[2 * i][2 * j + 1] = -3 * bb
            out[2 * i + 1][2 * j + 1] = aa - bb
    return out


def rank_mod(matrix: list[list[int]], prime: int) -> int:
    a = [[x % prime for x in row] for row in matrix]
    rows = len(a)
    cols = len(a[0]) if rows else 0
    rank = 0
    for col in range(cols):
        pivot = next((r for r in range(rank, rows) if a[r][col]), None)
        if pivot is None:
            continue
        a[rank], a[pivot] = a[pivot], a[rank]
        inv = pow(a[rank][col], -1, prime)
        a[rank] = [(inv * x) % prime for x in a[rank]]
        for row in range(rows):
            if row != rank and a[row][col]:
                scale = a[row][col]
                a[row] = [(x - scale * y) % prime for x, y in zip(a[row], a[rank])]
        rank += 1
        if rank == rows:
            break
    return rank


def stack_fixed(a: list[list[int]], b: list[list[int]]) -> list[list[int]]:
    n = len(a)
    return [
        *[[a[i][j] - (1 if i == j else 0) for j in range(n)] for i in range(n)],
        *[[b[i][j] - (1 if i == j else 0) for j in range(n)] for i in range(n)],
    ]


def main() -> None:
    # v-basis: v0,...,v4.  Tau(v_k)=v_(k+1), with Roulleau's v5 relation.
    v5 = [ONE, ONE + NU, q(-1), ONE, NU]
    tau_v = columns([
        [ZERO, ONE, ZERO, ZERO, ZERO],
        [ZERO, ZERO, ONE, ZERO, ZERO],
        [ZERO, ZERO, ZERO, ONE, ZERO],
        [ZERO, ZERO, ZERO, ZERO, ONE],
        v5,
    ])

    delta = ONE + 2 * NU
    assert delta * delta == q(-11)
    b0 = [ONE / delta, q(-3) / delta, q(3) / delta, q(-1) / delta, ZERO]
    b1 = [ZERO, ONE / delta, q(-3) / delta, q(3) / delta, q(-1) / delta]
    b2 = [ONE, ZERO, ZERO, ZERO, ZERO]
    b3 = [ZERO, ONE, ZERO, ZERO, ZERO]
    b4 = [ZERO, ZERO, ONE, ZERO, ZERO]
    basis = columns([b0, b1, b2, b3, b4])
    basis_inv = inverse(basis)

    # Sigma(v_k)=v_(5k mod 11), as follows from Roulleau's coordinate cycle.
    v0 = [ONE, ZERO, ZERO, ZERO, ZERO]
    sigma_cols = [matvec(matpow(tau_v, (5 * k) % 11), v0) for k in range(5)]
    sigma_v = columns(sigma_cols)

    tau = matmul(matmul(basis_inv, tau_v), basis)
    sigma = matmul(matmul(basis_inv, sigma_v), basis)
    tau_z = integral_matrix(tau)
    sigma_z = integral_matrix(sigma)

    assert matpow(tau, 11) == identity(5)
    assert matpow(sigma, 5) == identity(5)
    assert matmul(matmul(sigma, tau), matpow(sigma, 4)) == matpow(tau, 5)

    # The norm endomorphism of H=<tau,sigma> vanishes analytically, so H-fixed
    # points are killed by |H|=55.  It therefore suffices to check 5- and
    # 11-primary torsion.
    stacked = stack_fixed(tau_z, sigma_z)
    rank5 = rank_mod(stacked, 5)
    rank11 = rank_mod(stacked, 11)
    assert rank5 == 10
    assert rank11 == 10

    tau_rank5 = rank_mod(stack_fixed(tau_z, tau_z)[:10], 5)
    tau_rank11 = rank_mod(stack_fixed(tau_z, tau_z)[:10], 11)
    assert tau_rank5 == 10
    assert tau_rank11 == 9

    print("tau_minus_one_rank_mod_5", tau_rank5)
    print("tau_minus_one_rank_mod_11", tau_rank11)
    print("common_fixed_equations_rank_mod_5", rank5)
    print("common_fixed_equations_rank_mod_11", rank11)
    print("KLEIN_JACOBIAN_COMMON_FIXED_SUBGROUP_TRIVIAL")


if __name__ == "__main__":
    main()
