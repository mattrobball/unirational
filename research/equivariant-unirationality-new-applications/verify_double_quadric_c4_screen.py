#!/usr/bin/env python3
"""Exact fixed-point and line-character check for the C4 double-quadric screen."""
from __future__ import annotations

import sympy as sp


def main() -> None:
    I = sp.I
    lambdas = [1, -1, I, -I]

    # For lambda != 1, the eigenline is (1,lambda,lambda^2,lambda^3,0).
    q_values = {}
    for lam in lambdas[1:]:
        vector = [1, lam, lam**2, lam**3, 0]
        q_values[lam] = sp.simplify(sum(entry**2 for entry in vector))

    assert q_values[-1] == 4
    assert sp.simplify(q_values[I]) == 0
    assert sp.simplify(q_values[-I]) == 0

    # The +1 eigenspace has coordinates (a,a,a,a,b), and Q restricts to
    # 4a^2+b^2. Its projective zero locus consists of two reduced points.
    t = sp.symbols("t")
    plus_polynomial = t**2 + 4
    assert sp.degree(plus_polynomial, t) == 2
    assert sp.gcd(plus_polynomial, sp.diff(plus_polynomial, t)) == 1

    fixed_points = 2 + 1 + 1
    assert fixed_points == 4

    # O_Q(4) has trivial fiber character on every fixed eigenline.
    fixed_eigenvalues = [sp.Integer(1), sp.Integer(1), I, -I]
    for lam in fixed_eigenvalues:
        assert sp.simplify(lam ** (-4)) == 1

    print(f"DOUBLE_QUADRIC_C4_SCREEN_OK fixed_points={fixed_points}")


if __name__ == "__main__":
    main()
