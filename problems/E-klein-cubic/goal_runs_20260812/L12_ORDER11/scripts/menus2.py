"""Exact, unbounded fibre-trace menu membership at order 11.

A trace coming from a smooth 11-curve fibre with fixed points of rotation
numbers u (multiplicity n_u >= 0) is

        tr = sum_{u=1}^{10} n_u / (1 - zeta^{-u}) ,    b = sum_u n_u .

The ten elements 1/(1 - zeta^{-u}) span a 6-dimensional Q-space; the kernel of
(n_u) -> tr is spanned by  (e_u + e_{-u}) - (e_v + e_{-v}),  so BOTH

        b = sum_u n_u          and      D_u = n_u - n_{-u}

are DETERMINED by tr.  Membership is therefore decidable with no bound on b:

  tr in some MENU_b   <=>   tr lies in the 6-dim span, the resulting b and
                            D_u are integers, and there are integers
                            p_i >= |D_i| with p_i = D_i (mod 2), sum p_i = b
                        <=>  b >= sum_i |D_i|  and  b = sum_i D_i (mod 2).

and then the b is unique.  This replaces the naive C(b+9,9) enumeration and
makes the C7 Riemann-Hurwitz menu finite WITHOUT a genus bound (FLAG-M is
thereby resolved for the smooth-fibre model; the derived/singular fibre model
is still carried as an unknown).
"""
from fractions import Fraction as Fr

import cyclo as C

N = 11
PAIRS = [(1, 10), (2, 9), (3, 8), (4, 7), (5, 6)]
_E = [C.inv(C.one_minus_zpow(-u)) for u in range(1, N)]


def _solve_general(t):
    """Any rational solution n of sum n_u E_u = t, or None."""
    rows = []
    for i in range(10):
        rows.append([_E[j][i] for j in range(10)] + [t[i]])
    n = 10
    piv_cols = []
    r = 0
    for c in range(n):
        p = None
        for rr in range(r, n):
            if rows[rr][c] != 0:
                p = rr
                break
        if p is None:
            continue
        rows[r], rows[p] = rows[p], rows[r]
        pv = rows[r][c]
        rows[r] = [v / pv for v in rows[r]]
        for rr in range(n):
            if rr != r and rows[rr][c] != 0:
                f = rows[rr][c]
                rows[rr] = [a - f * b for a, b in zip(rows[rr], rows[r])]
        piv_cols.append(c)
        r += 1
    # consistency
    for rr in range(r, n):
        if rows[rr][n] != 0 and all(rows[rr][c] == 0 for c in range(n)):
            return None
    sol = [Fr(0)] * n
    for i, c in enumerate(piv_cols):
        sol[c] = rows[i][n]
    return sol


def menu_data(t):
    """(in_span, b, D) with D indexed by PAIRS; b and D are invariants of t."""
    sol = _solve_general(t)
    if sol is None:
        return False, None, None
    b = sum(sol)
    D = [sol[u - 1] - sol[v - 1] for (u, v) in PAIRS]
    return True, b, D


def in_menu(t, b_required=None):
    ok, b, D = menu_data(t)
    if not ok:
        return False, None, "not in the span of the local terms"
    if b.denominator != 1 or any(x.denominator != 1 for x in D):
        return False, b, "b or the antisymmetric parts are not integers"
    b = int(b)
    Di = [int(x) for x in D]
    if b < sum(abs(x) for x in Di):
        return False, b, f"b={b} < sum|D|={sum(abs(x) for x in Di)}"
    if (b - sum(Di)) % 2 != 0:
        return False, b, "parity obstruction"
    if b_required is not None and b != b_required:
        return False, b, f"forced b={b} != tower n_x={b_required}"
    return True, b, "ok"
