"""Referee menu criterion (independent of the packet's menus2.py).

Solves  sum_u n_u E_u = t,  E_u = 1/(1 - z^{-u}),  over Q by Gaussian
elimination in the referee's canonical basis; extracts the invariants
b = sum n_u and D_i = n_u - n_{-u}; decides membership over the nonnegative
integers by the pairing argument (p_i = n_u + n_{-u} free >= |D_i| with
p_i = D_i mod 2 and sum p_i = b)."""
import sys
import os
from fractions import Fraction as Fr

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import referee_lib as R  # noqa: E402

E = [R.inv(R.one_minus_zpow(-u)) for u in range(1, 11)]
PAIRS = [(1, 10), (2, 9), (3, 8), (4, 7), (5, 6)]


def span_rank_and_kernel():
    """Rank of {E_1..E_10} in Q^10 and a basis check of the claimed kernel."""
    rows = [list(E[u]) for u in range(10)]
    rank = _rank([r[:] for r in rows])
    # claimed kernel generators: (e_u + e_{-u}) - (e_1 + e_{10})
    kern_ok = True
    for (u, v) in PAIRS[1:]:
        w = R.sub(R.add(E[u - 1], E[v - 1]), R.add(E[0], E[9]))
        kern_ok &= R.is_zero(w)
    one_ok = all(R.eq(R.add(E[u - 1], E[v - 1]), R.ONE) for (u, v) in PAIRS)
    return rank, kern_ok, one_ok


def _rank(rows):
    n = len(rows)
    m = len(rows[0])
    r = 0
    for c in range(m):
        p = None
        for i in range(r, n):
            if rows[i][c] != 0:
                p = i
                break
        if p is None:
            continue
        rows[r], rows[p] = rows[p], rows[r]
        pv = rows[r][c]
        rows[r] = [x / pv for x in rows[r]]
        for i in range(n):
            if i != r and rows[i][c] != 0:
                f = rows[i][c]
                rows[i] = [x - f * y for x, y in zip(rows[i], rows[r])]
        r += 1
        if r == n:
            break
    return r


def solve_particular(t):
    """One rational solution n in Q^10 of sum n_u E_u = t, or None."""
    # 10 coordinate equations, 10 unknowns; system is rank 6
    rows = [[E[u][i] for u in range(10)] + [t[i]] for i in range(10)]
    n = 10
    r = 0
    piv = []
    for c in range(n):
        p = None
        for i in range(r, n):
            if rows[i][c] != 0:
                p = i
                break
        if p is None:
            continue
        rows[r], rows[p] = rows[p], rows[r]
        pv = rows[r][c]
        rows[r] = [x / pv for x in rows[r]]
        for i in range(n):
            if i != r and rows[i][c] != 0:
                f = rows[i][c]
                rows[i] = [x - f * y for x, y in zip(rows[i], rows[r])]
        piv.append(c)
        r += 1
    for i in range(r, n):
        if rows[i][n] != 0 and all(rows[i][c] == 0 for c in range(n)):
            return None
    sol = [Fr(0)] * n
    for i, c in enumerate(piv):
        sol[c] = rows[i][n]
    return sol


def in_menu(t, b_required=None):
    """(passes, b, reason). Membership of t in the smooth-11-curve trace menu."""
    sol = solve_particular(t)
    if sol is None:
        return False, None, "not in span"
    b = sum(sol)
    D = [sol[u - 1] - sol[v - 1] for (u, v) in PAIRS]
    if b.denominator != 1 or any(x.denominator != 1 for x in D):
        return False, b, "b or D not integral"
    b = int(b)
    D = [int(x) for x in D]
    if b < sum(abs(x) for x in D):
        return False, b, "b < sum|D|"
    if (b - sum(D)) % 2:
        return False, b, "parity"
    if b_required is not None and b != b_required:
        return False, b, "b != n_x"
    return True, b, "ok"


def brute_menu(b):
    """All traces of b fixed points (combinations with repetition), exact."""
    from itertools import combinations_with_replacement
    out = {}
    for combo in combinations_with_replacement(range(1, 11), b):
        s = R.total([E[u - 1] for u in combo])
        out.setdefault(s, []).append(combo)
    return out
