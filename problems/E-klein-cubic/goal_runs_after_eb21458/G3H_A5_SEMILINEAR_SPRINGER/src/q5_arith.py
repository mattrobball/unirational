#!/usr/bin/env python3
"""Exact arithmetic in Q(sqrt(5)) and the quartic Q(u), u^4+12u^2+256=0."""

from __future__ import annotations

from fractions import Fraction
from typing import Iterable, Sequence


Q5 = tuple[Fraction, Fraction]  # a + b*s, s^2 = 5
U4 = tuple[Fraction, Fraction, Fraction, Fraction]  # a0+a1*u+a2*u^2+a3*u^3

ZERO: Q5 = (Fraction(0), Fraction(0))
ONE: Q5 = (Fraction(1), Fraction(0))
S: Q5 = (Fraction(0), Fraction(1))


def q5(a=0, b=0) -> Q5:
    return Fraction(a), Fraction(b)


def qadd(x: Q5, y: Q5) -> Q5:
    return x[0] + y[0], x[1] + y[1]


def qneg(x: Q5) -> Q5:
    return -x[0], -x[1]


def qsub(x: Q5, y: Q5) -> Q5:
    return qadd(x, qneg(y))


def qmul(x: Q5, y: Q5) -> Q5:
    return x[0] * y[0] + 5 * x[1] * y[1], x[0] * y[1] + x[1] * y[0]


def qscale(c, x: Q5) -> Q5:
    c = Fraction(c)
    return c * x[0], c * x[1]


def qiszero(x: Q5) -> bool:
    return x[0] == 0 and x[1] == 0


def qeq(x: Q5, y: Q5) -> bool:
    return x == y


def qinv(x: Q5) -> Q5:
    d = x[0] * x[0] - 5 * x[1] * x[1]
    if d == 0:
        raise ZeroDivisionError("q5 inverse of zero")
    return x[0] / d, -x[1] / d


def qdiv(x: Q5, y: Q5) -> Q5:
    return qmul(x, qinv(y))


def qpow(x: Q5, n: int) -> Q5:
    out = ONE
    if n < 0:
        x = qinv(x)
        n = -n
    while n:
        if n & 1:
            out = qmul(out, x)
        x = qmul(x, x)
        n //= 2
    return out


def q5_to_json(x: Q5) -> dict:
    return {
        "rational": [int(x[0].numerator), int(x[0].denominator)],
        "sqrt5": [int(x[1].numerator), int(x[1].denominator)],
    }


def q5_from_json(obj: dict) -> Q5:
    return (
        Fraction(obj["rational"][0], obj["rational"][1]),
        Fraction(obj["sqrt5"][0], obj["sqrt5"][1]),
    )


def sum_q5(values: Iterable[Q5]) -> Q5:
    acc = ZERO
    for v in values:
        acc = qadd(acc, v)
    return acc


def mmul_q5(A: Sequence[Sequence[Q5]], B: Sequence[Sequence[Q5]]):
    n, p, m = len(A), len(B), len(B[0])
    out = [[ZERO] * m for _ in range(n)]
    for i in range(n):
        for j in range(m):
            s = ZERO
            for k in range(p):
                s = qadd(s, qmul(A[i][k], B[k][j]))
            out[i][j] = s
    return out


def mid_q5(n: int):
    return [[ONE if i == j else ZERO for j in range(n)] for i in range(n)]


def mpow_q5(A, e: int):
    R = mid_q5(len(A))
    while e:
        if e & 1:
            R = mmul_q5(R, A)
        A = mmul_q5(A, A)
        e //= 2
    return R


def conjugate_sqrt5(x: Q5) -> Q5:
    """s |-> -s automorphism."""
    return x[0], -x[1]
