#!/usr/bin/env python3
"""Substitute the four-atom Vandermonde recurrence into low norm moments."""

import importlib.util
from pathlib import Path

import sympy as sp


HERE = Path(__file__).resolve().parent
SPEC = importlib.util.spec_from_file_location(
    "norm_moments", HERE / "derive_norm_moment_recurrence.py"
)
NM = importlib.util.module_from_spec(SPEC)
assert SPEC.loader is not None
SPEC.loader.exec_module(NM)

e1, e2, e3, e4 = sp.symbols("e1 e2 e3 e4", nonzero=True)


def barycentric_sums(bound=18):
    # S_n=sum_j u_j^n/P'(u_j), P=t^4-e1*t^3+e2*t^2-e3*t+e4.
    S = {0: sp.Integer(0), 1: sp.Integer(0), 2: sp.Integer(0), 3: sp.Integer(1)}
    for n in range(4, bound + 1):
        S[n] = sp.factor(e1 * S[n - 1] - e2 * S[n - 2] + e3 * S[n - 3] - e4 * S[n - 4])
    for n in range(-1, -bound - 1, -1):
        S[n] = sp.factor(
            (-S[n + 4] + e1 * S[n + 3] - e2 * S[n + 2] + e3 * S[n + 1]) / e4
        )
    return S


def cleared_constraint(P, Q, S):
    expression = NM.coefficient(P, Q)
    substitutions = {NM.m[n]: S[n + 1] for n in range(-NM.MAX_TOTAL, NM.MAX_TOTAL + 1)}
    expression = sp.factor(NM.reduce_z(expression.subs(substitutions)))
    numerator = sp.together(expression).as_numer_denom()[0]
    return sp.factor(NM.reduce_z(numerator))


def main():
    S = barycentric_sums()
    assert S[-1] == -1 / e4
    assert sp.factor(S[-2] + e3 / e4**2) == 0
    assert sp.factor(S[-3] - (e2 * e4 - e3**2) / e4**3) == 0
    assert S[4] == e1
    assert sp.factor(S[5] - (e1**2 - e2)) == 0

    print("BARYCENTRIC_MOMENTS", "m_n=S_(n+1)")
    for total in (8, 9, 10):
        for P in range(total + 1):
            Q = total - P
            value = NM.coefficient(P, Q)
            if value == 0:
                continue
            constraint = cleared_constraint(P, Q, S)
            print("QUARTIC_CONSTRAINT", P, Q, constraint)


if __name__ == "__main__":
    main()
