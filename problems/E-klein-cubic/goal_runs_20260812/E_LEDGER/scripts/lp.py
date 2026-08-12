#!/usr/bin/env python3
"""
Exact rational LP (max c.x subject to A x <= b, x >= 0) by a two-phase
simplex over `fractions.Fraction` with Bland's rule.

Discipline copied from `goal_runs_20260812/SMITH_I3/scripts/i3_semistability.py`
(`_phase1`): exact Fractions everywhere, Bland's rule so termination is
guaranteed, and a STORED CERTIFICATE that is re-checked independently of the
solver.  Here the certificate is the LP duality pair:

    primal x* >= 0 with A x* <= b and c.x* = v
    dual   y* >= 0 with A^T y* >= c and b.y* = v

Both are returned and both are re-verified by `check_certificate` using only
Fraction arithmetic -- so a solver bug cannot produce a wrong optimum that
survives the check (weak duality c.x <= b.y for any feasible pair pins v).

No floating point anywhere.  python3 standard library only.
"""

from fractions import Fraction


def _F(x):
    return x if isinstance(x, Fraction) else Fraction(x)


def solve_max(c, A, b):
    """
    maximise c.x  subject to  A x <= b,  x >= 0,  with b >= 0 (our LPs all
    have b = 1 vectors, so the slack basis is feasible and phase I is not
    needed).  Returns dict with 'status', 'value', 'x', 'y'.
    """
    n = len(c)
    m = len(A)
    c = [_F(v) for v in c]
    A = [[_F(v) for v in row] for row in A]
    b = [_F(v) for v in b]
    assert all(v >= 0 for v in b), "this driver assumes b >= 0"

    # tableau: rows 0..m-1 constraints with slacks; last row = -objective
    N = n + m
    T = [A[i] + [Fraction(int(k == i)) for k in range(m)] + [b[i]]
         for i in range(m)]
    obj = [-v for v in c] + [Fraction(0)] * m + [Fraction(0)]
    basis = [n + i for i in range(m)]

    while True:
        # Bland: smallest index with negative reduced cost
        pc = -1
        for j in range(N):
            if obj[j] < 0:
                pc = j
                break
        if pc < 0:
            break
        pr, best = -1, None
        for i in range(m):
            if T[i][pc] > 0:
                r = T[i][N] / T[i][pc]
                if best is None or r < best or (r == best and basis[i] < basis[pr]):
                    best, pr = r, i
        if pr < 0:
            return {"status": "UNBOUNDED", "value": None, "x": None, "y": None}
        pv = T[pr][pc]
        T[pr] = [v / pv for v in T[pr]]
        for i in range(m):
            if i != pr and T[i][pc] != 0:
                f = T[i][pc]
                T[i] = [T[i][j] - f * T[pr][j] for j in range(N + 1)]
        f = obj[pc]
        if f != 0:
            obj = [obj[j] - f * T[pr][j] for j in range(N + 1)]
        basis[pr] = pc

    value = obj[N]
    x = [Fraction(0)] * n
    for i in range(m):
        if basis[i] < n:
            x[basis[i]] = T[i][N]
    y = [obj[n + i] for i in range(m)]         # reduced costs of the slacks
    return {"status": "OPTIMAL", "value": value, "x": x, "y": y}


def check_certificate(c, A, b, res):
    """Independent exact re-verification of an LP certificate."""
    if res["status"] != "OPTIMAL":
        return {"ok": False, "reason": res["status"]}
    c = [_F(v) for v in c]
    A = [[_F(v) for v in row] for row in A]
    b = [_F(v) for v in b]
    x, y, v = res["x"], res["y"], res["value"]
    n, m = len(c), len(A)
    ok = True
    detail = {}
    detail["x_nonneg"] = all(xx >= 0 for xx in x)
    detail["primal_feasible"] = all(
        sum(A[i][j] * x[j] for j in range(n)) <= b[i] for i in range(m))
    detail["y_nonneg"] = all(yy >= 0 for yy in y)
    detail["dual_feasible"] = all(
        sum(A[i][j] * y[i] for i in range(m)) >= c[j] for j in range(n))
    detail["primal_value"] = sum(c[j] * x[j] for j in range(n)) == v
    detail["dual_value"] = sum(b[i] * y[i] for i in range(m)) == v
    ok = all(detail.values())
    return {"ok": ok, "detail": {k: bool(x_) for k, x_ in detail.items()},
            "value": str(v)}


def feasible(A, b, lower):
    """
    Is  { x : A x <= b,  x >= lower >= 0 }  non-empty?
    Substituting x = lower + u (u >= 0) turns it into A u <= b - A.lower.
    Feasible iff every component of b - A.lower is >= 0 is NOT required
    (u = 0 works iff that holds); in general run phase I.  Our systems have
    all-nonnegative A, so x = lower is the componentwise-smallest candidate
    and feasibility is exactly  A.lower <= b.
    """
    A = [[_F(v) for v in row] for row in A]
    b = [_F(v) for v in b]
    lower = [_F(v) for v in lower]
    assert all(v >= 0 for row in A for v in row), "sign assumption violated"
    viol = []
    for i in range(len(A)):
        s = sum(A[i][j] * lower[j] for j in range(len(lower)))
        if s > b[i]:
            viol.append((i, str(s), str(b[i])))
    return {"feasible": not viol, "violated_rows": viol}
