#!/usr/bin/env python3
"""Produce the integral fixed-point certificate for the Klein Jacobian.

The input is Roulleau's period lattice (Theorem 2 / Theorem 13 in
arXiv:1001.4853).  Put nu^2 + nu + 3 = 0 and delta = 1 + 2 nu.  In the
vectors v_0,...,v_4, the lattice is the O=Z[nu]-span of

  (v0-3v1+3v2-v3)/delta,
  (v1-3v2+3v3-v4)/delta,
  v0, v1, v2.

The order-11 automorphism tau sends v_k to v_{k+1}; the order-5
normalizer sigma sends v_k to v_{5k}.  This script reconstructs their
integral 10 by 10 matrices, computes coker(tau-1), and computes sigma on
the order-11 fixed subgroup of the intermediate Jacobian.
"""

from __future__ import annotations

import hashlib
import json
from dataclasses import dataclass
from fractions import Fraction
from pathlib import Path

from sympy import Matrix, ZZ
from sympy.matrices.normalforms import smith_normal_form


HERE = Path(__file__).resolve().parent
OUT = HERE / "fixed_jacobian_payload.json"


@dataclass(frozen=True)
class K:
    """a+b*nu in Q(nu), where nu^2+nu+3=0."""

    a: Fraction = Fraction(0)
    b: Fraction = Fraction(0)

    def __add__(self, other: "K") -> "K":
        return K(self.a + other.a, self.b + other.b)

    def __neg__(self) -> "K":
        return K(-self.a, -self.b)

    def __sub__(self, other: "K") -> "K":
        return self + (-other)

    def __mul__(self, other: "K") -> "K":
        # nu^2=-nu-3
        return K(
            self.a * other.a - 3 * self.b * other.b,
            self.a * other.b + self.b * other.a - self.b * other.b,
        )

    def inverse(self) -> "K":
        # conjugate(nu)=-1-nu; norm(a+b nu)=a^2-a*b+3*b^2
        norm = self.a * self.a - self.a * self.b + 3 * self.b * self.b
        if norm == 0:
            raise ZeroDivisionError
        return K((self.a - self.b) / norm, -self.b / norm)

    def __truediv__(self, other: "K") -> "K":
        return self * other.inverse()

    def integral_pair(self) -> list[int]:
        if self.a.denominator != 1 or self.b.denominator != 1:
            raise ArithmeticError(f"nonintegral O coefficient: {self}")
        return [int(self.a), int(self.b)]


ZERO = K()
ONE = K(Fraction(1))
NU = K(Fraction(0), Fraction(1))


def kmat(rows: int, cols: int) -> list[list[K]]:
    return [[ZERO for _ in range(cols)] for _ in range(rows)]


def eye(n: int) -> list[list[K]]:
    ans = kmat(n, n)
    for i in range(n):
        ans[i][i] = ONE
    return ans


def mul(a: list[list[K]], b: list[list[K]]) -> list[list[K]]:
    n, r, m = len(a), len(b), len(b[0])
    assert len(a[0]) == r
    ans = kmat(n, m)
    for i in range(n):
        for k in range(r):
            if a[i][k] == ZERO:
                continue
            for j in range(m):
                ans[i][j] = ans[i][j] + a[i][k] * b[k][j]
    return ans


def add(a: list[list[K]], b: list[list[K]]) -> list[list[K]]:
    return [[a[i][j] + b[i][j] for j in range(len(a[0]))] for i in range(len(a))]


def power(a: list[list[K]], n: int) -> list[list[K]]:
    ans = eye(len(a))
    base = a
    while n:
        if n & 1:
            ans = mul(ans, base)
        base = mul(base, base)
        n //= 2
    return ans


def inverse(a: list[list[K]]) -> list[list[K]]:
    n = len(a)
    aug = [a[i][:] + eye(n)[i] for i in range(n)]
    for c in range(n):
        pivot = next(i for i in range(c, n) if aug[i][c] != ZERO)
        aug[c], aug[pivot] = aug[pivot], aug[c]
        unit = aug[c][c].inverse()
        aug[c] = [unit * x for x in aug[c]]
        for i in range(n):
            if i == c or aug[i][c] == ZERO:
                continue
            q = aug[i][c]
            aug[i] = [aug[i][j] - q * aug[c][j] for j in range(2 * n)]
    return [row[n:] for row in aug]


def as_z_matrix(a: list[list[K]]) -> Matrix:
    """Restrict an O-linear matrix to Z in basis (b_i, nu*b_i)."""
    n = len(a)
    z = [[0 for _ in range(2 * n)] for _ in range(2 * n)]
    for i in range(n):
        for j in range(n):
            aa, bb = a[i][j].integral_pair()
            # multiplication by aa+bb*nu in basis (1,nu)
            z[2 * i][2 * j] = aa
            z[2 * i + 1][2 * j] = bb
            z[2 * i][2 * j + 1] = -3 * bb
            z[2 * i + 1][2 * j + 1] = aa - bb
    return Matrix(z)


def left_null_vector_mod_p(a: Matrix, p: int) -> list[int]:
    """Return one nonzero vector ell with ell*a=0 mod p."""
    m = [[int(a[j, i]) % p for j in range(a.rows)] for i in range(a.cols)]
    rows, cols = len(m), len(m[0])
    pivots: list[int] = []
    r = 0
    for c in range(cols):
        pivot = next((i for i in range(r, rows) if m[i][c] % p), None)
        if pivot is None:
            continue
        m[r], m[pivot] = m[pivot], m[r]
        invp = pow(m[r][c], -1, p)
        m[r] = [(invp * x) % p for x in m[r]]
        for i in range(rows):
            if i != r and m[i][c] % p:
                q = m[i][c]
                m[i] = [(m[i][j] - q * m[r][j]) % p for j in range(cols)]
        pivots.append(c)
        r += 1
    free = next(c for c in range(cols) if c not in pivots)
    x = [0] * cols
    x[free] = 1
    for i in range(len(pivots) - 1, -1, -1):
        c = pivots[i]
        x[c] = (-sum(m[i][j] * x[j] for j in range(c + 1, cols))) % p
    assert any(x)
    assert all(sum(x[i] * int(a[i, j]) for i in range(a.rows)) % p == 0 for j in range(a.cols))
    return x


def main() -> None:
    # tau on V=(v0,...,v4), using Roulleau's v5 relation.
    t = kmat(5, 5)
    t[1][0] = ONE
    t[2][1] = ONE
    t[3][2] = ONE
    t[4][3] = ONE
    for i, x in enumerate([ONE, ONE + NU, -ONE, ONE, NU]):
        t[i][4] = x

    # sigma(v_k)=v_{5k}; columns correspond k=0,...,4.
    s = kmat(5, 5)
    for j, exponent in enumerate([0, 5, 10, 4, 9]):
        col = power(t, exponent)
        for i in range(5):
            s[i][j] = col[i][0]

    delta = ONE + K(Fraction(0), Fraction(2))
    inv_delta = delta.inverse()
    b = kmat(5, 5)
    for i, x in enumerate([1, -3, 3, -1, 0]):
        b[i][0] = K(Fraction(x)) * inv_delta
    for i, x in enumerate([0, 1, -3, 3, -1]):
        b[i][1] = K(Fraction(x)) * inv_delta
    b[0][2] = ONE
    b[1][3] = ONE
    b[2][4] = ONE

    binv = inverse(b)
    tl = mul(mul(binv, t), b)
    sl = mul(mul(binv, s), b)
    tz = as_z_matrix(tl)
    sz = as_z_matrix(sl)
    ident = Matrix.eye(10)

    assert tz**11 == ident
    assert sz**5 == ident
    assert sz * tz * sz.inv() == tz**5
    a = tz - ident
    det = abs(int(a.det()))
    snf = smith_normal_form(a, domain=ZZ)
    diag = [abs(int(snf[i, i])) for i in range(10)]
    assert det == 11 and diag == [1] * 9 + [11]

    q9 = sum((tz**i for i in range(9)), Matrix.zeros(10))
    action = sz * q9
    ell = left_null_vector_mod_p(a, 11)
    ell_action = [sum(ell[i] * int(action[i, j]) for i in range(10)) % 11 for j in range(10)]
    pivot = next(i for i, x in enumerate(ell) if x)
    scalar = ell_action[pivot] * pow(ell[pivot], -1, 11) % 11
    assert ell_action == [(scalar * x) % 11 for x in ell]
    assert pow(scalar, 5, 11) == 1 and scalar != 1

    payload = {
        "source": {
            "paper": "X. Roulleau, The Fano surface of the Klein cubic threefold, arXiv:1001.4853",
            "lattice_formula": "Theorem 2 / Theorem 13",
            "nu_polynomial": "nu^2+nu+3",
            "delta": "1+2*nu",
        },
        "basis": ["a0", "a1", "v0", "v1", "v2"],
        "tau_O_matrix": [[tl[i][j].integral_pair() for j in range(5)] for i in range(5)],
        "sigma_O_matrix": [[sl[i][j].integral_pair() for j in range(5)] for i in range(5)],
        "tau_Z_matrix": [[int(tz[i, j]) for j in range(10)] for i in range(10)],
        "sigma_Z_matrix": [[int(sz[i, j]) for j in range(10)] for i in range(10)],
        "relations": {"tau_order": 11, "sigma_order": 5, "sigma_tau_sigma_inverse": "tau^5"},
        "tau_minus_one": {"abs_det": det, "smith_diagonal": diag, "cokernel": "Z/11"},
        "quotient_character_mod_11": ell,
        "sigma_on_J_tau": {
            "transport_formula": "sigma*(1+tau+...+tau^8)",
            "scalar_mod_11": scalar,
            "fixed_subgroup_order": 1,
        },
        "conclusion": "J(Klein)^<tau,sigma> = 0, hence J(Klein)^PSL2(F11) = 0",
        "terminal_marker": "R_FIXED_JACOBIAN_ZERO_CERTIFIED",
    }
    encoded = json.dumps(payload, indent=2, sort_keys=True).encode()
    OUT.write_bytes(encoded + b"\n")
    print(f"wrote {OUT.name}")
    print(f"sha256={hashlib.sha256(encoded + b'\n').hexdigest()}")
    print(f"det(tau-1)={det}, smith={diag}, sigma_scalar={scalar} mod 11")
    print(payload["terminal_marker"])


if __name__ == "__main__":
    main()
