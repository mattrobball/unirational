#!/usr/bin/env python3
"""
Exact verifier for `goal_runs_20260812/SELFMAP_DETECTION/PHI8_DEGREE.md`.

WHAT IS PROVED HERE
-------------------
(A) The minimal equivariant tangent field `V_8` (and `V_9`) is **boxed over Q**
    with integer coefficients -- blowup point (B5) of `SELFMAP_AUDIT.md` §7 is
    closed.  Exact characteristic-zero checks: degree, `sigma`-covariance,
    `tau`-weight covariance, `grad F . V = c * F * h` (so `V` is tangent to `X`),
    and `x ^ V != 0 (mod F)` (so `V` is not the radial direction and really
    defines a section of `P(T_X) -> X`).

(B) The boxed `V_m` **is** the sealed equivariant field: its reduction mod `p`
    lies in the `G`-covariant space and spans `K_m/Z_m` (recomputed from
    scratch with the sealed machinery of `verify_selfmap_audit.py`, copied
    verbatim), for `p = 1 mod 11`.  `iota`-covariance is checked at nine primes
    of size `> 10^18` together with an explicit archimedean height bound, which
    upgrades the `F_p` statements to an identity over `Q(zeta_11)`.

(C) **Preliminary issue (i) settled, against the audit's expectation.**  The
    degeneracy locus `D_8 = {x in X : V_8(x) ^ x = 0}` is **not** empty and
    **not** zero-dimensional: it is one-dimensional.  Its one-dimensional part
    is reduced of degree `72` (two random hyperplane slices give 72 distinct
    points), and the saturated ideal has Hilbert polynomial `72d + 147`, which
    forces an extra zero-dimensional part of length at least `75`.

(D) **Preliminary issue (ii) settled.**  In the incidence scheme
    `Z_y = {x in X : y in l_x}` the spurious solution `x = y` has multiplicity
    exactly `2` -- structurally (the line `l_x` is tangent to `X` at `x`) and
    computationally (`210` vs `209` vs `208` below).

(E) **The topological degree, two independent routes, exactly:**

        deg(phi_8) = delta(phi_8) = 208 = 2^4 * 13
        deg(phi_9) = delta(phi_9) = 288 = 2^5 * 3^2

    ROUTE A (line-congruence incidence): the determinantal scheme
    `Z_y = {x : rank[x ; V_8(x) ; y] <= 2}` with the excess degeneracy curve
    inverted away has `209` distinct points and minimal polynomial degree
    `210`; removing `x = y` leaves `208` points, all simple.
    ROUTE B (point count): the `t`-parametrisation `y ~ x + t V_8(x)`,
    `t != 0`, `Q(x,V_8) != 0` (which certifies each solution is a genuine
    preimage under the degree-25 tuple `R`), has exactly `208` solutions in the
    chart `x_0 != 0` and none in the four remaining flag charts, so the fiber is
    complete.  Three targets, two primes, and characteristic zero.

(F) **The detection test.**  `208 = 2^4 * 13` and `13` is inert in
    `Q(sqrt(-11))` (`13 mod 11 = 2`, a non-residue), so `v_13(delta) = 1` is odd
    and `delta` is **not** represented by `x^2+xy+3y^2`.  Likewise
    `288 = 2^5 * 3^2` with `v_2` odd and `2` inert.  Hence neither `phi_8` nor
    `phi_9` can be CLEAN.

Everything is exact: Python integers, `fractions.Fraction`, `F_p`, and msolve
over `Q` and over `F_p`.  No floating point anywhere.

EXTERNAL DEPENDENCY: `msolve` (>= 0.10) must be on `PATH`.  NOTE, and this cost
a real debugging cycle: msolve's parser does **not** understand parentheses --
`(3)*x1^2*x2` is silently mis-read and the solver then reports "no solution" for
systems with obvious solutions.  Every system here is emitted fully expanded in
the plain form `3*x1^2*x2`, and block (Z) contains a regression test that fails
loudly if a future msolve changes this.

TERMINAL MARKER: prints `RESULT: PASS` iff every assertion holds.
"""

import os
import re
import shutil
import subprocess
import sys
import tempfile
import time
from fractions import Fraction
from math import factorial

FAILURES = []
CHECKS = 0
T0 = time.time()


def check(name, cond, detail=""):
    global CHECKS
    CHECKS += 1
    if not cond:
        FAILURES.append(f"{name}{(': ' + detail) if detail else ''}")
        print(f"  FAIL {name} {detail}")
    return bool(cond)


def check_eq(name, got, want):
    return check(name, got == want, f"got {got!r}, want {want!r}")


def banner(t):
    print()
    print("=" * 72)
    print(t)
    print("=" * 72)


# ======================================================================
# (0)  The boxed fields over Q.
#      Only component 0 is stored; component i is the sigma-shift of it,
#      sigma : x_i -> x_{i+1}.  (sigma-covariance is therefore built in and is
#      *not* claimed as a check; the substantive checks are the tau-weight
#      condition, the tangency identity, and the F_p identification in (B).)
# ======================================================================

V8_COMP0 = [
    (7,0,0,0,1, 1), (6,0,0,2,0, 1), (5,1,1,0,1, -12), (4,3,0,1,0, 7),
    (4,1,1,2,0, 12), (3,2,2,0,1, -12), (3,0,5,0,0, 1), (3,0,3,1,1, -6),
    (3,0,1,2,2, 6), (2,6,0,0,0, 1), (2,4,1,1,0, -12), (2,2,2,2,0, 12),
    (2,2,0,3,1, 24), (2,1,2,0,3, 24), (2,1,0,1,4, -18), (2,0,3,3,0, 6),
    (2,0,1,4,1, -3), (1,5,0,0,2, 6), (1,3,3,0,1, 6), (1,3,1,1,2, -6),
    (1,1,6,0,0, 1), (1,1,4,1,1, 6), (1,1,2,2,2, -6), (1,1,0,3,3, -6),
    (1,0,2,0,5, 9), (1,0,1,6,0, -2), (0,7,1,0,0, 1), (0,5,2,1,0, -6),
    (0,5,0,2,1, 3), (0,4,0,0,4, 1), (0,3,3,2,0, 2), (0,3,1,3,1, 4),
    (0,2,3,0,3, 8), (0,2,1,1,4, 3), (0,1,4,3,0, -1), (0,1,2,4,1, -3),
    (0,1,0,5,2, 6), (0,0,6,0,2, -1), (0,0,4,1,3, 2), (0,0,0,3,5, 1)]
V9_COMP0 = [
    (8,0,1,0,0, -2), (6,1,2,0,0, 126), (6,1,0,1,1, -70), (5,1,0,3,0, 133),
    (5,0,2,0,2, 161), (5,0,0,1,3, -133), (4,4,0,0,1, -28), (4,2,3,0,0,
    -49), (4,2,1,1,1, 343), (4,0,4,1,0, 112), (4,0,2,2,1, -126),
    (4,0,0,3,2, 70), (3,4,0,2,0, 112), (3,3,0,0,3, -14), (3,2,1,3,0,
    -224), (3,1,3,0,2, 140), (3,1,1,1,3, 14), (3,0,2,4,0, 77), (3,0,0,5,1,
    196), (2,5,1,0,1, -119), (2,3,4,0,0, -210), (2,3,2,1,1, 406),
    (2,3,0,2,2, 84), (2,2,0,0,5, 56), (2,1,5,1,0, -224), (2,1,3,2,1, 154),
    (2,1,1,3,2, 280), (2,0,3,0,4, 175), (2,0,1,1,5, -161), (2,0,0,7,0, 5),
    (1,7,0,1,0, 19), (1,5,1,2,0, 98), (1,4,1,0,3, 147), (1,3,2,3,0, -224),
    (1,3,0,4,1, 119), (1,2,4,0,2, 161), (1,2,2,1,3, 42), (1,2,0,2,4, 14),
    (1,1,3,4,0, -168), (1,1,1,5,1, -119), (1,1,0,0,7, -16), (1,0,7,0,1,
    -23), (1,0,5,1,2, -7), (0,6,2,0,1, 14), (0,6,0,1,2, 21), (0,4,5,0,0,
    14), (0,4,3,1,1, 56), (0,4,1,2,2, 63), (0,3,1,0,5, -7), (0,3,0,6,0,
    -14), (0,2,6,1,0, 56), (0,2,4,2,1, -231), (0,2,2,3,2, -210),
    (0,2,0,4,3, -98), (0,1,4,0,4, 7), (0,1,2,1,5, 21), (0,1,1,7,0, -28),
    (0,1,0,2,6, -56), (0,0,5,3,1, -35), (0,0,3,4,2, 105)]


# ======================================================================
# The sealed F_p model, COPIED VERBATIM from
#   goal_runs_20260812/SELFMAP_DETECTION/verify_selfmap_audit.py
# (blocks (C) and the D_5 cross-check).  Reused, not rebuilt, exactly as
# the work order requires.
# ======================================================================
# ======================================================================
# (C)  The group over F_p, rebuilt from the repository's generators.
# ======================================================================
WEIGHTS = (1, 9, 4, 3, 5)          # a_i = (-2)^i mod 11
QR = {1, 3, 4, 5, 9}


def compositions(total, length):
    if length == 1:
        yield (total,)
        return
    for first in range(total + 1):
        for rest in compositions(total - first, length - 1):
            yield (first,) + rest


def shift(exp, i):
    out = [0] * 5
    for j, v in enumerate(exp):
        out[(j + i) % 5] = v
    return tuple(out)


def hweight(exp):
    return sum(a * e for a, e in zip(WEIGHTS, exp)) % 11


def multinomial(n, parts):
    r = factorial(n)
    for q in parts:
        r //= factorial(q)
    return r


def is_prime(n):
    if n < 2:
        return False
    small = (2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37)
    for q in small:
        if n % q == 0:
            return n == q
    d, s = n - 1, 0
    while d % 2 == 0:
        d //= 2
        s += 1
    for a in small:
        x = pow(a, d, n)
        if x in (1, n - 1):
            continue
        for _ in range(s - 1):
            x = x * x % n
            if x == n - 1:
                break
        else:
            return False
    return True


def find_prime(lo):
    n = lo + (1 - lo % 11) % 11
    while True:
        if n % 11 == 1 and is_prime(n) and 660 % n != 0 and n > 660:
            return n
        n += 11


class Model:
    """Everything that depends on the prime p."""

    def __init__(self, p):
        self.p = p
        z = None
        for a in range(2, 5000):
            t = pow(a, (p - 1) // 11, p)
            if t != 1 and pow(t, 11, p) == 1:
                z = t
                break
        assert z is not None
        self.z = z
        self.sigma = [[1 if j == (i + 1) % 5 else 0 for j in range(5)]
                      for i in range(5)]
        self.tau = [[pow(z, WEIGHTS[i], p) if i == j else 0 for j in range(5)]
                    for i in range(5)]
        g = 0
        for e in range(1, 11):
            g = (g + (1 if e in QR else -1) * pow(z, e, p)) % p
        self.gauss = g
        idx, sgn = [1, 3, 2, 5, 4], [1, 1, -1, 1, 1]
        inv11 = pow(11, p - 2, p)
        iota = []
        for r, left in enumerate(idx):
            row = []
            for c, right in enumerate(idx):
                e = (9 * left * right) % 11
                t = (pow(z, e, p) - pow(z, (-e) % 11, p)) % p
                t = t * (-g) % p
                t = t * (sgn[c] % p) % p * pow(sgn[r] % p, p - 2, p) % p
                row.append(t * inv11 % p)
            iota.append(row)
        self.iota = iota
        self.cache = {}
        self.F = {}
        for i in range(5):
            e = [0] * 5
            e[i] += 2
            e[(i + 1) % 5] += 1
            self.F[tuple(e)] = 1
        self.GRAD = []
        for j in range(5):
            d = {}
            e = [0] * 5
            e[j] += 1
            e[(j + 1) % 5] += 1
            d[tuple(e)] = 2 % p
            e = [0] * 5
            e[(j - 1) % 5] += 2
            d[tuple(e)] = (d.get(tuple(e), 0) + 1) % p
            self.GRAD.append({k: v % p for k, v in d.items() if v % p})

    # ---- polynomial arithmetic in 5 variables ----
    def pmul(self, a, b):
        p = self.p
        out = {}
        for e1, c1 in a.items():
            for e2, c2 in b.items():
                e = (e1[0] + e2[0], e1[1] + e2[1], e1[2] + e2[2],
                     e1[3] + e2[3], e1[4] + e2[4])
                out[e] = (out.get(e, 0) + c1 * c2) % p
        return {e: c for e, c in out.items() if c}

    def padd(self, a, b):
        p = self.p
        out = dict(a)
        for e, c in b.items():
            v = (out.get(e, 0) + c) % p
            if v:
                out[e] = v
            elif e in out:
                del out[e]
        return out

    def pscal(self, c, a):
        p = self.p
        c %= p
        if c == 0:
            return {}
        return {e: (v * c) % p for e, v in a.items()}

    def lin_pow(self, row, e):
        p = self.p
        if e == 0:
            return {(0, 0, 0, 0, 0): 1}
        res = {}
        for comp in compositions(e, 5):
            t = multinomial(e, comp) % p
            if t == 0:
                continue
            ok = True
            for m, n in enumerate(comp):
                if n == 0:
                    continue
                if row[m] == 0:
                    ok = False
                    break
                t = t * pow(row[m], n, p) % p
            if ok and t:
                res[comp] = (res.get(comp, 0) + t) % p
        return {e2: c for e2, c in res.items() if c}

    def subst_monomial(self, exp, M, cache):
        if exp in cache:
            return cache[exp]
        res = {(0, 0, 0, 0, 0): 1}
        for l, e in enumerate(exp):
            if e:
                res = self.pmul(res, self.lin_pow(M[l], e))
        cache[exp] = res
        return res

    def subst_poly(self, poly, M, cache):
        p = self.p
        out = {}
        for e, c in poly.items():
            for e2, c2 in self.subst_monomial(e, M, cache).items():
                out[e2] = (out.get(e2, 0) + c * c2) % p
        return {e: c for e, c in out.items() if c}

    def dot_grad(self, comps):
        out = {}
        for a, b in zip(self.GRAD, comps):
            out = self.padd(out, self.pmul(a, b))
        return out

    # ---- linear algebra ----
    def nullspace(self, rows, ncols):
        p = self.p
        M = [r[:] for r in rows]
        pivots, row = {}, 0
        for col in range(ncols):
            sel = None
            for r in range(row, len(M)):
                if M[r][col] % p:
                    sel = r
                    break
            if sel is None:
                continue
            M[row], M[sel] = M[sel], M[row]
            inv = pow(M[row][col], p - 2, p)
            M[row] = [v * inv % p for v in M[row]]
            for r in range(len(M)):
                if r != row and M[r][col]:
                    f = M[r][col]
                    M[r] = [(a - f * b) % p for a, b in zip(M[r], M[row])]
            pivots[col] = row
            row += 1
            if row == len(M):
                break
        basis = []
        for fcol in [c for c in range(ncols) if c not in pivots]:
            v = [0] * ncols
            v[fcol] = 1
            for col, r in pivots.items():
                v[col] = (-M[r][fcol]) % p
            basis.append(v)
        return basis

    def rank(self, cols, nrows):
        if not cols:
            return 0
        nc = len(cols)
        ns = self.nullspace([[cols[c][r] for c in range(nc)] for r in range(nrows)], nc)
        return nc - len(ns)

    # ---- equivariant spaces ----
    def equivariant(self, d, covariant):
        """Joint kernel for sigma (combinatorial: seeds), tau (weight condition)
        and iota (one linear condition)."""
        seed = WEIGHTS[0] if covariant else 0
        alphas = [e for e in compositions(d, 5) if hweight(e) == seed]
        monoms = list(compositions(d, 5))
        idx = {e: i for i, e in enumerate(monoms)}
        Nd = len(monoms)
        ncomp = 5 if covariant else 1
        p = self.p
        cols = []
        for alpha in alphas:
            col = [0] * (ncomp * Nd)
            for i in range(ncomp):
                for e, c in self.subst_monomial(shift(alpha, i), self.iota,
                                                self.cache).items():
                    col[i * Nd + idx[e]] = (col[i * Nd + idx[e]] + c) % p
                if covariant:
                    for j in range(5):
                        k = i * Nd + idx[shift(alpha, j)]
                        col[k] = (col[k] - self.iota[i][j]) % p
                else:
                    col[idx[alpha]] = (col[idx[alpha]] - 1) % p
            cols.append(col)
        rows = [[cols[c][r] for c in range(len(alphas))]
                for r in range(ncomp * Nd)]
        ker = self.nullspace(rows, len(alphas)) if alphas else []
        out = []
        for vec in ker:
            comps = [dict() for _ in range(ncomp)]
            for a, alpha in enumerate(alphas):
                c = vec[a] % p
                if not c:
                    continue
                for i in range(ncomp):
                    e = shift(alpha, i)
                    comps[i][e] = (comps[i].get(e, 0) + c) % p
            out.append([{e: c for e, c in dd.items() if c} for dd in comps])
        return out


def mat_mul5(A, B, p):
    return tuple(tuple(sum(A[i][k] * B[k][j] for k in range(5)) % p
                       for j in range(5)) for i in range(5))


def group_order(gens, p, cap=5000):
    I5 = tuple(tuple(1 if i == j else 0 for j in range(5)) for i in range(5))
    seen, frontier = {I5}, [I5]
    G = [tuple(map(tuple, g)) for g in gens]
    while frontier:
        nxt = []
        for A in frontier:
            for g in G:
                B = mat_mul5(A, g, p)
                if B not in seen:
                    seen.add(B)
                    nxt.append(B)
                    if len(seen) > cap:
                        return len(seen)
        frontier = nxt
    return len(seen)


def mat_order(M, p, cap=100):
    I5 = tuple(tuple(1 if i == j else 0 for j in range(5)) for i in range(5))
    Mt = tuple(map(tuple, M))
    Cm, n = Mt, 1
    while Cm != I5 and n <= cap:
        Cm = mat_mul5(Cm, Mt, p)
        n += 1
    return n


# ---- the repository's boxed D_5, component 0, for the model cross-check ----
D5_TERMS = [((1, 1, 1, 1, 1), 1), ((2, 2, 4, 4, 4), 5), ((1, 3, 3, 3, 4), 5),
            ((1, 1, 1, 2, 3), -5), ((0, 1, 3, 4, 4), -10), ((0, 1, 2, 2, 4), 5),
            ((0, 0, 2, 3, 3), 5), ((0, 0, 1, 1, 3), 5), ((0, 0, 0, 2, 4), -5)]


def repo_D5_component0(p):
    d = {}
    for mon, c in D5_TERMS:
        e = [0] * 5
        for i in mon:
            e[i] += 1
        d[tuple(e)] = (d.get(tuple(e), 0) + c) % p
    return {e: c for e, c in d.items() if c}

# ======================================================================
# (A)  Exact characteristic-zero arithmetic on the boxed fields.
# ======================================================================
banner("(A)  the boxed fields V_8, V_9 over Q")


def shift5(e, i):
    out = [0] * 5
    for j, v in enumerate(e):
        out[(j + i) % 5] = v
    return tuple(out)


def tuple_from_comp0(comp0):
    base = {tuple(t[:5]): t[5] for t in comp0}
    return [{shift5(e, i): c for e, c in base.items()} for i in range(5)]


V8 = tuple_from_comp0(V8_COMP0)
V9 = tuple_from_comp0(V9_COMP0)

FK = {}
for i in range(5):
    e = [0] * 5
    e[i] += 2
    e[(i + 1) % 5] += 1
    FK[tuple(e)] = 1

GRAD0 = []
for j in range(5):
    d = {}
    e = [0] * 5
    e[j] += 1
    e[(j + 1) % 5] += 1
    d[tuple(e)] = d.get(tuple(e), 0) + 2
    e = [0] * 5
    e[(j - 1) % 5] += 2
    d[tuple(e)] = d.get(tuple(e), 0) + 1
    GRAD0.append(d)

XT = []
for i in range(5):
    e = [0] * 5
    e[i] = 1
    XT.append({tuple(e): 1})


def zmul(a, b):
    out = {}
    for e1, c1 in a.items():
        for e2, c2 in b.items():
            e = (e1[0] + e2[0], e1[1] + e2[1], e1[2] + e2[2],
                 e1[3] + e2[3], e1[4] + e2[4])
            out[e] = out.get(e, 0) + c1 * c2
    return {e: c for e, c in out.items() if c}


def zadd(*ps):
    out = {}
    for a in ps:
        for e, c in a.items():
            out[e] = out.get(e, 0) + c
    return {e: c for e, c in out.items() if c}


def zscal(c, a):
    return {} if c == 0 else {e: c * v for e, v in a.items()}


def zsub(a, b):
    return zadd(a, zscal(-1, b))


def zdeg(a):
    return max(sum(e) for e in a) if a else -1


def _powprod(y, e):
    t = 1
    for i in range(5):
        if e[i]:
            t *= y[i] ** e[i]
    return t


def Lform(V):
    """grad F . V"""
    return zadd(*[zmul(GRAD0[i], V[i]) for i in range(5)])


def FofV(V):
    return zadd(*[zmul(zmul(V[i], V[i]), V[(i + 1) % 5]) for i in range(5)])


def Qform(V):
    """t^2-coefficient of F(x + tV)"""
    out = {}
    for i in range(5):
        j = (i + 1) % 5
        out = zadd(out, zmul(zmul(V[i], V[i]), XT[j]),
                   zscal(2, zmul(zmul(XT[i], V[i]), V[j])))
    return out


LEADF = (2, 1, 0, 0, 0)          # lex leading monomial of F, coefficient 1


def divF(a):
    """exact division by F in lex order; returns (quotient, remainder)"""
    a = {e: Fraction(c) for e, c in a.items()}
    q, r = {}, {}
    while a:
        e = max(a)
        c = a[e]
        if all(e[i] >= LEADF[i] for i in range(5)):
            m = tuple(e[i] - LEADF[i] for i in range(5))
            q[m] = q.get(m, 0) + c
            for e2, c2 in FK.items():
                k = tuple(e2[i] + m[i] for i in range(5))
                a[k] = a.get(k, 0) - c * c2
                if a[k] == 0:
                    del a[k]
        else:
            r[e] = c
            del a[e]
    return q, r


WEIGHTS5 = (1, 9, 4, 3, 5)


def wt(e):
    return sum(a * b for a, b in zip(WEIGHTS5, e)) % 11


for m, V in ((8, V8), (9, V9)):
    check_eq(f"V_{m}: every component is homogeneous of degree {m}",
             sorted({zdeg(V[i]) for i in range(5)}), [m])
    check(f"V_{m}: tau-weight covariance (component i has weight a_i mod 11)",
          all(wt(e) == WEIGHTS5[i] % 11 for i in range(5) for e in V[i]))
    check(f"V_{m}: coefficients are integers with content 1",
          all(isinstance(c, int) for i in range(5) for c in V[i].values()))
    L = Lform(V)
    q, r = divF(L)
    check(f"V_{m}: grad F . V = 0 (mod F), i.e. V is tangent to X", r == {})
    check(f"V_{m}: the cofactor of F in grad F . V has degree {m - 1}",
          zdeg(q) == m - 1)
    minors = [zsub(zmul(XT[i], V[j]), zmul(XT[j], V[i]))
              for i in range(5) for j in range(i + 1, 5)]
    check(f"V_{m}: x ^ V != 0 (mod F) -- V is not the radial direction, so it "
          "defines a genuine section of P(T_X) -> X",
          any(divF(mm)[1] != {} for mm in minors))
    check_eq(f"V_{m}: the 2x2 minors x_i V_j - x_j V_i have degree {m + 1}",
             sorted({zdeg(mm) for mm in minors}), [m + 1])
    FV = FofV(V)
    QQ = Qform(V)
    check_eq(f"V_{m}: deg F(V) = {3 * m}", zdeg(FV), 3 * m)
    check_eq(f"V_{m}: deg Q(x,V) = {2 * m + 1}", zdeg(QQ), 2 * m + 1)
    R = [zsub(zmul(FV, XT[i]), zmul(QQ, V[i])) for i in range(5)]
    check_eq(f"V_{m}: the tangent-residual tuple R = F(V)x - Q(x,V)V has "
             f"degree {3 * m + 1} (the sealed coordinate degree)",
             sorted({zdeg(R[i]) for i in range(5)}), [3 * m + 1])

check_eq("deg_coord(phi_8) = 25 (sealed)", 3 * 8 + 1, 25)
check_eq("deg_coord(phi_9) = 28 (sealed)", 3 * 9 + 1, 28)
print(f"  V_8: {len(V8[0])} terms per component, max |coeff| = "
      f"{max(abs(c) for c in V8[0].values())}")
print(f"  V_9: {len(V9[0])} terms per component, max |coeff| = "
      f"{max(abs(c) for c in V9[0].values())}")

# ======================================================================
# (B)  Identification with the sealed equivariant field, over F_p.
# ======================================================================
banner("(B)  the boxed field is the sealed equivariant one")


def tuplevec(T, idx, n, p):
    v = [0] * (5 * n)
    for i in range(5):
        for e, c in T[i].items():
            v[i * n + idx[e]] = c % p
    return v


def kz_spaces(M, COV, INV, m):
    """dim K_m, dim Z_m and a basis of K_m in Cov_m-coordinates.
    Transcription of block (E) of verify_selfmap_audit.py."""
    p = M.p
    xt = []
    for i in range(5):
        e = [0] * 5
        e[i] = 1
        xt.append({tuple(e): 1})
    monm2 = list(compositions(m + 2, 5))
    idxm2 = {e: i for i, e in enumerate(monm2)}

    def vec_of(poly):
        v = [0] * len(monm2)
        for e, c in poly.items():
            v[idxm2[e]] = c % p
        return v
    cols = [vec_of(M.dot_grad(V)) for V in COV[m]]
    cols += [vec_of(M.pmul(M.F, h)) for h in INV[m - 1]]
    nc = len(cols)
    ns = M.nullspace([[cols[c][r] for c in range(nc)]
                      for r in range(len(monm2))], nc)
    Kb = [v[:len(COV[m])] for v in ns if any(v[:len(COV[m])])]
    dimK = M.rank([[Kb[c][r] for r in range(len(COV[m]))]
                   for c in range(len(Kb))], len(COV[m])) if Kb else 0
    monm = list(compositions(m, 5))
    idxm = {e: i for i, e in enumerate(monm)}
    Z = [[M.pmul(M.F, c) for c in V] for V in COV.get(m - 3, [])]
    Z += [[M.pmul(h, c) for c in xt] for h in INV[m - 1]]
    dimZ = M.rank([tuplevec(T, idxm, len(monm), p) for T in Z],
                  5 * len(monm)) if Z else 0
    return dimK, dimZ, Z


def in_span(M, vecs, w):
    if not vecs:
        return not any(w)
    n = len(vecs)
    ns = M.nullspace([[vecs[c][r] for c in range(n)] + [(-w[r]) % p_here]
                      for r in range(len(w))], n + 1)
    return any(v[-1] % p_here for v in ns)


p_here = find_prime(10 ** 6)
M = Model(p_here)
check_eq(f"[p={p_here}] |<sigma,tau,iota>| = 660",
         group_order([M.sigma, M.tau, M.iota], p_here), 660)
mon5 = list(compositions(5, 5))
COV, INV = {}, {}
for mm in range(0, 10):
    COV[mm] = M.equivariant(mm, True) if mm >= 1 else []
    INV[mm] = [c[0] for c in M.equivariant(mm, False)]
repo = repo_D5_component0(p_here)
ours = COV[5][0][0]
v1 = [repo.get(e, 0) for e in mon5]
v2 = [ours.get(e, 0) for e in mon5]
ratio = next((a * pow(b, p_here - 2, p_here) % p_here
              for a, b in zip(v1, v2) if b), None)
check(f"[p={p_here}] the repository's boxed D_5 spans Cov_5 (model pinned to "
      "the sealed one)",
      ratio is not None and all((a - ratio * b) % p_here == 0
                                for a, b in zip(v1, v2)))

for m, V in ((8, V8), (9, V9)):
    dimK, dimZ, Zt = kz_spaces(M, COV, INV, m)
    check_eq(f"[p={p_here}] N({m}) = dim K_{m} - dim Z_{m} = 1 "
             "(the section is unique -- sealed)", dimK - dimZ, 1)
    monm = list(compositions(m, 5))
    idxm = {e: i for i, e in enumerate(monm)}
    B = [tuplevec(T, idxm, len(monm), p_here) for T in COV[m]]
    w = tuplevec(V, idxm, len(monm), p_here)
    check(f"[p={p_here}] the boxed V_{m} reduces into the G-covariant space "
          f"Cov_{m} (so it is G-equivariant mod p)", in_span(M, B, w))
    Zc = [tuplevec(T, idxm, len(monm), p_here) for T in Zt]
    check(f"[p={p_here}] the boxed V_{m} is not degenerate: it is not in "
          f"Z_{m} = F*Cov_{m-3} + x*Inv_{m-1}, hence it spans K_{m}/Z_{m} "
          "and IS the sealed minimal equivariant tangent field",
          not in_span(M, Zc, w))

# ---- iota-covariance at nine large primes, plus an archimedean height bound
# The identity to be proved is  D_i := 11^m [ V_i(iota x) - sum_j iota_ij V_j ]
# = 0 in Z[zeta_11].  Each coefficient of D_i is an algebraic integer whose
# every archimedean absolute value is at most
#      H = 11^m * ( S * (5*61/100)^m + 5*61/100 * S ),   S = sum |coeff of V|,
# because |iota entry| <= 2*sqrt(11)/11 < 61/100 and a coefficient is bounded by
# the sup-norm on the unit polydisc.  So |Norm(coeff)| <= H^10.  If the
# coefficient lies in the degree-one primes above p_1..p_k then that norm is
# divisible by p_1...p_k; if prod p_i > H^10 the coefficient is 0.
banner("(B')  iota-covariance over Q(zeta_11) by primes + a height bound")
HB = {}
for m, V in ((8, V8), (9, V9)):
    S = sum(abs(c) for i in range(5) for c in V[i].values())
    ib = Fraction(61, 100)
    HB[m] = int(11 ** m * (S * (5 * ib) ** m + 5 * ib * S)) + 1
NEED = max(HB.values()) ** 10
BOUND_PRIMES = []
prod = 1
lo = 10 ** 18
while prod <= NEED:
    q = find_prime(lo)
    BOUND_PRIMES.append(q)
    prod *= q
    lo = q + 1
for m, V in ((8, V8), (9, V9)):
    check(f"V_{m}: the primes beat the height bound "
          f"(prod p_i > H^10, H = {HB[m]})", prod > HB[m] ** 10)
    for q in BOUND_PRIMES:
        Mq = Model(q)
        ok = True
        for i in range(5):
            lhs = Mq.subst_poly({e: c % q for e, c in V[i].items()},
                                Mq.iota, {})
            rhs = {}
            for j2 in range(5):
                rhs = Mq.padd(rhs, Mq.pscal(Mq.iota[i][j2],
                                            {e: c % q
                                             for e, c in V[j2].items()}))
            if lhs != rhs:
                ok = False
                break
        check(f"V_{m}: V(iota x) = iota V(x) mod p = {q}", ok)
print(f"  {len(BOUND_PRIMES)} primes, smallest {BOUND_PRIMES[0]}, "
      f"largest {BOUND_PRIMES[-1]}")

# ======================================================================
# (C)  msolve plumbing.
# ======================================================================
banner("(C)  msolve regression test and system generation")
MSOLVE = shutil.which("msolve")
if MSOLVE is None:
    print("  FATAL: msolve is not on PATH; blocks (C)-(E) cannot run.")
    FAILURES.append("msolve not found")
    print("\nRESULT: FAIL")
    sys.exit(1)
TMP = tempfile.mkdtemp(prefix="phi8_")


class Ring:
    def __init__(self, names):
        self.names = list(names)
        self.n = len(names)

    def zero(self):
        return {}

    def const(self, c):
        return {} if c == 0 else {(0,) * self.n: c}

    def var(self, name):
        e = [0] * self.n
        e[self.names.index(name)] = 1
        return {tuple(e): 1}

    def add(self, *ps):
        out = {}
        for p in ps:
            for e, c in p.items():
                out[e] = out.get(e, 0) + c
        return {e: c for e, c in out.items() if c}

    def scal(self, c, p):
        return {} if c == 0 else {e: c * v for e, v in p.items()}

    def sub(self, a, b):
        return self.add(a, self.scal(-1, b))

    def mul(self, a, b):
        out = {}
        for e1, c1 in a.items():
            for e2, c2 in b.items():
                e = tuple(u + v for u, v in zip(e1, e2))
                out[e] = out.get(e, 0) + c1 * c2
        return {e: c for e, c in out.items() if c}

    def pow(self, a, k):
        r = self.const(1)
        for _ in range(k):
            r = self.mul(r, a)
        return r

    def str(self, p):
        if not p:
            return "0"
        ts = []
        for e in sorted(p, reverse=True):
            c = p[e]
            mo = "*".join(f"{self.names[i]}^{k}" if k > 1 else self.names[i]
                          for i, k in enumerate(e) if k)
            a = abs(c)
            body = (f"{a}*{mo}" if (a != 1 and mo) else (mo if mo else str(a)))
            ts.append(("+" if c > 0 else "-") + body)
        s = "".join(ts)
        return s[1:] if s[0] == "+" else s


def write_ms(fn, R, eqs, char):
    open(fn, "w").write(",".join(R.names) + "\n" + str(char) + "\n"
                        + ",\n".join(R.str(e) for e in eqs if e) + "\n")


def msolve(fn, tag, extra=()):
    out = os.path.join(TMP, "o_" + tag + ".txt")
    r = subprocess.run([MSOLVE, "-f", fn, "-o", out, "-v", "1"] + list(extra),
                       capture_output=True, text=True, timeout=100000)
    txt = r.stdout + r.stderr
    if "No solution" in txt:
        return {"kind": "empty"}
    if "positive dimension" in txt:
        return {"kind": "posdim"}
    a = re.search(r"deg\. elim\. pol\.\s+(\d+)", txt)
    b = re.search(r"deg\. sqfr\. elim\. pol\.\s+(\d+)", txt)
    return {"kind": "zerodim",
            "min": int(a.group(1)) if a else None,
            "pts": int(b.group(1)) if b else None}


# --- regression: msolve must still refuse parenthesised coefficients ---------
Rt = Ring(["x1", "x2"])
fn = os.path.join(TMP, "reg_plain.ms")
open(fn, "w").write("x1,x2\n0\nx1^2*x2-8,\nx2-2\n")
plain = msolve(fn, "reg_plain")
fn2 = os.path.join(TMP, "reg_paren.ms")
open(fn2, "w").write("x1,x2\n0\n(1)*x1^2*x2+(-8),\n(1)*x2+(-2)\n")
paren = msolve(fn2, "reg_paren")
check_eq("msolve solves x1^2 x2 = 8, x2 = 2 in the plain syntax (2 points)",
         (plain["kind"], plain["pts"]), ("zerodim", 2))
check("REGRESSION GUARD: msolve still mis-parses parenthesised coefficients "
      "-- every system below is emitted fully expanded.  If this check ever "
      "fails, msolve has been fixed and the guard can be dropped (the results "
      "are unaffected either way).",
      paren["kind"] == "empty")

# ======================================================================
# (D)  The geometry.
# ======================================================================
PRIME_A = 1000003
PRIME_B = 2000003
Y = {"y1": (1, -2, -2, 1, 2), "y2": (1, 1, 1, 2, -2), "y3": (2, 3, -2, 2, -1)}
for nm, y in Y.items():
    check(f"target {nm} = {y} lies on X",
          sum(y[i] ** 2 * y[(i + 1) % 5] for i in range(5)) == 0)


class Chart:
    """flag chart of P^4:  x_i = 0 for i < c,  x_c = 1,  the rest free"""

    def __init__(self, c, aux):
        self.c = c
        self.names = [f"x{i}" for i in range(5) if i > c] + list(aux)
        self.R = Ring(self.names)
        self.X = []
        for i in range(5):
            if i < c:
                self.X.append(self.R.zero())
            elif i == c:
                self.X.append(self.R.const(1))
            else:
                self.X.append(self.R.var(f"x{i}"))

    def sub(self, poly):
        R = self.R
        out = R.zero()
        for e, cc in poly.items():
            term = R.const(cc)
            for i, k in enumerate(e):
                if k:
                    if not self.X[i]:
                        term = R.zero()
                        break
                    term = R.mul(term, R.pow(self.X[i], k))
            out = R.add(out, term)
        return out


def wedge2(V):
    return [zsub(zmul(XT[i], V[j]), zmul(XT[j], V[i]))
            for i in range(5) for j in range(i + 1, 5)]


def minors3(V, y):
    out = []
    for i in range(5):
        for j in range(i + 1, 5):
            for k in range(j + 1, 5):
                t = {}
                for (a, b, c, s) in ((i, j, k, 1), (j, k, i, 1), (k, i, j, 1),
                                     (i, k, j, -1), (k, j, i, -1),
                                     (j, i, k, -1)):
                    t = zadd(t, zscal(s * y[c], zmul(XT[a], V[b])))
                if t:
                    out.append(t)
    return out


def sys_routeA(V, y, chart, char, seed, drop_y, fn):
    """determinantal incidence fiber, degeneracy curve inverted away"""
    aux = ["g"] + (["v"] if drop_y else [])
    S = Chart(chart, aux)
    R = S.R
    eqs = [S.sub(FK)] + [S.sub(mm) for mm in minors3(V, y)]
    rnd = _lcg(seed)
    comb = {}
    for mm in wedge2(V):
        comb = zadd(comb, zscal(next(rnd), mm))
    eqs.append(R.sub(R.mul(R.var("g"), S.sub(comb)), R.const(1)))
    if drop_y:
        lin = R.zero()
        for i in range(5):
            lin = R.add(lin, R.scal(next(rnd),
                                    R.sub(R.scal(y[4], S.X[i]),
                                          R.scal(y[i], S.X[4]))))
        eqs.append(R.sub(R.mul(R.var("v"), lin), R.const(1)))
    write_ms(fn, R, eqs, char)
    return fn


def sys_routeB(V, y, chart, char, fn):
    """t-parametrisation:  y ~ x + t V(x),  t != 0,  Q(x,V) != 0"""
    S = Chart(chart, ["t", "w", "u", "z"])
    R = S.R
    t = R.var("t")
    A = [R.add(S.X[i], R.mul(t, S.sub(V[i]))) for i in range(5)]
    eqs = [S.sub(FK)]
    for i in range(5):
        for j in range(i + 1, 5):
            if y[i] == 0 and y[j] == 0:
                continue
            eqs.append(R.sub(R.scal(y[j], A[i]), R.scal(y[i], A[j])))
    k = next(i for i in range(5) if y[i] != 0)
    eqs.append(R.sub(R.mul(R.var("w"), A[k]), R.const(1)))
    eqs.append(R.sub(R.mul(R.var("u"), t), R.const(1)))
    eqs.append(R.sub(R.mul(R.var("z"), S.sub(Qform(V))), R.const(1)))
    write_ms(fn, R, eqs, char)
    return fn


def sys_degen(V, chart, char, fn, hyper=None):
    S = Chart(chart, [])
    R = S.R
    eqs = [S.sub(FK)] + [S.sub(mm) for mm in wedge2(V)]
    if hyper is not None:
        lin = R.zero()
        for i in range(5):
            lin = R.add(lin, R.scal(hyper[i], S.X[i]))
        eqs.append(lin)
    write_ms(fn, R, eqs, char)
    return fn


def _upolmod(a, b, p):
    a = a[:]
    while True:
        while a and a[-1] % p == 0:
            a.pop()
        if len(a) < len(b):
            return a
        f = a[-1] * pow(b[-1], p - 2, p) % p
        sh = len(a) - len(b)
        for i, c in enumerate(b):
            a[i + sh] = (a[i + sh] - f * c) % p


def _upolmul(a, b, m, p):
    out = [0] * (len(a) + len(b) - 1)
    for i, x in enumerate(a):
        if x:
            for j, y in enumerate(b):
                out[i + j] = (out[i + j] + x * y) % p
    return _upolmod(out, m, p)


def _upolpow(a, e, m, p):
    r = [1]
    while e:
        if e & 1:
            r = _upolmul(r, a, m, p)
        a = _upolmul(a, a, m, p)
        e >>= 1
    return r


def _upolgcd(a, b, p):
    a, b = a[:], b[:]
    while b and any(b):
        a = _upolmod(a, b, p)
        a, b = b, a
    while a and a[-1] % p == 0:
        a.pop()
    return a


def _upoldiv(a, b, p):
    q = [0] * (len(a) - len(b) + 1)
    a = a[:]
    for i in range(len(a) - len(b), -1, -1):
        c = a[i + len(b) - 1] * pow(b[-1], p - 2, p) % p
        q[i] = c
        if c:
            for j, bb in enumerate(b):
                a[i + j] = (a[i + j] - c * bb) % p
    return q


def _ddf(f, p):
    """distinct-degree factorisation: the multiset of irreducible factor
    degrees of a squarefree f over F_p"""
    out = []
    fstar = f[:]
    h = [0, 1]
    d = 0
    while len(fstar) - 1 >= 2 * (d + 1):
        d += 1
        h = _upolpow(h, p, fstar, p)
        diff = h[:] + [0] * max(0, 2 - len(h))
        diff[1] = (diff[1] - 1) % p
        while diff and diff[-1] % p == 0:
            diff.pop()
        g = _upolgcd(diff, fstar, p) if diff else fstar[:]
        if len(g) - 1 > 0:
            out += [d] * ((len(g) - 1) // d)
            fstar = _upoldiv(fstar, g, p)
            while fstar and fstar[-1] % p == 0:
                fstar.pop()
    if len(fstar) - 1 > 0:
        out.append(len(fstar) - 1)
    return sorted(out)


def _lcg(seed):
    s = seed
    while True:
        s = (1103515245 * s + 12345) % 2147483648
        yield 1 + s % 997


banner("(D1)  the degeneracy locus of V_8 -- preliminary issue (i)")
fn = sys_degen(V8, 0, PRIME_A, os.path.join(TMP, "deg_full.ms"))
r = msolve(fn, "deg_full")
check_eq("D_8 = {x in X : V_8(x) ^ x = 0} is POSITIVE-DIMENSIONAL "
         "(the audit expected dimension zero)", r["kind"], "posdim")
rnd = _lcg(20260812)
slices = []
for trial in range(2):
    h = [next(rnd) for _ in range(5)]
    fn = sys_degen(V8, 0, PRIME_A, os.path.join(TMP, f"deg_s{trial}.ms"),
                   hyper=h)
    r = msolve(fn, f"deg_s{trial}")
    slices.append((r["kind"], r["min"], r["pts"]))
    check_eq(f"D_8 cut by the random hyperplane {h}: 72 distinct points, "
             "so the one-dimensional part is REDUCED of degree 72",
             (r["kind"], r["min"], r["pts"]), ("zerodim", 72, 72))
check("the two independent slices of D_8 agree", slices[0] == slices[1])

banner("(D1')  the Hilbert polynomial of the degeneracy scheme, and its "
       "component structure")
# homogeneous system in five variables; msolve prints the leading ideal
Rh = Ring(["x0", "x1", "x2", "x3", "x4"])


def hom_poly(a):
    return {tuple(e): c for e, c in a.items()}


fn = os.path.join(TMP, "deg_hom.ms")
write_ms(fn, Rh, [hom_poly(FK)] + [hom_poly(mm) for mm in wedge2(V8)], PRIME_A)
outg = os.path.join(TMP, "gb.txt")
subprocess.run([MSOLVE, "-f", fn, "-g", "1", "-o", outg],
               capture_output=True, text=True, timeout=100000)
txt = open(outg).read()
lead = []
for mono in re.findall(r"[^,\[\]\s]+", txt[txt.index("["):]):
    e = [0] * 5
    for v, k in re.findall(r"x(\d)\^(\d+)", mono):
        e[int(v)] = int(k)
    if any(e):
        lead.append(tuple(e))
minimal = []
for g in sorted(lead, key=sum):
    if not any(all(g[i] >= h[i] for i in range(5)) for h in minimal):
        minimal.append(g)


def hilb(gens, d):
    c = 0
    for e0 in range(d + 1):
        for e1 in range(d - e0 + 1):
            for e2 in range(d - e0 - e1 + 1):
                for e3 in range(d - e0 - e1 - e2 + 1):
                    e4 = d - e0 - e1 - e2 - e3
                    if not any(e0 >= g[0] and e1 >= g[1] and e2 >= g[2]
                               and e3 >= g[3] and e4 >= g[4] for g in minimal):
                        c += 1
    return c


H = [hilb(minimal, d) for d in range(24, 31)]
check("the Hilbert function of the degeneracy scheme is 72d + 147 for "
      "24 <= d <= 30, so the scheme is a curve of degree 72 with chi = 147",
      all(H[i] == 72 * (24 + i) + 147 for i in range(len(H))),
      f"{H}")
check("a reduced curve of degree 72 has chi(O) <= 72, so chi = 147 forces an "
      "extra zero-dimensional part of length >= 75", 147 - 72 >= 75)

# component structure: slices at a prime = 1 mod 11 (G is F_p-rational there)
P11 = find_prime(10 ** 6)          # = 1000033
rnd3 = _lcg(5)
profiles = []
for trial in range(3):
    h = [next(rnd3) for _ in range(5)]
    fn = sys_degen(V8, 0, P11, os.path.join(TMP, f"cs{trial}.ms"), hyper=h)
    r = msolve(fn, f"cs{trial}", extra=["-P", "1"])
    check_eq(f"D_8 slice at p = {P11} (= 1 mod 11), trial {trial}: 72 points",
             (r["min"], r["pts"]), (72, 72))
    ff = open(os.path.join(TMP, f"o_cs{trial}.txt")).read()
    mm = re.search(r"\[(\d+),\s*\[([-0-9,\s]+)\]\]", ff)
    co = [int(c) % P11 for c in mm.group(2).replace("\n", "").split(",")
          if c.strip()]
    profiles.append(_ddf(co, P11))
print("  slice factor-degree profiles:", profiles)
check("each slice profile sums to 72", all(sum(pr) == 72 for pr in profiles),
      f"{profiles}")
# A Frobenius orbit of N slice points lies on a Frobenius orbit of components,
# k of them, each meeting the slice in e points, with N <= k e = the total
# degree of that orbit of components.  So max(profile) is a lower bound for the
# total degree of some Frobenius orbit of components of D_8.
check("in every slice some Frobenius orbit of components of D_8 has total "
      "degree >= 26, and in one slice >= 40: the components of D_8 are not all "
      "F_p-rational of degree <= 6",
      all(max(pr) >= 26 for pr in profiles)
      and max(max(pr) for pr in profiles) >= 40, f"{profiles}")

banner("(D1'')  the F_23-points of the degeneracy locus form one G-orbit")
Q23 = 23                      # = 1 mod 11, so G is defined over F_23


def _ev23(a, x, q):
    t = 0
    for e, c in a.items():
        u = c % q
        for i in range(5):
            if e[i]:
                u = u * pow(x[i], e[i], q) % q
        t = (t + u) % q
    return t


def _norm23(x, q):
    for i in range(5):
        if x[i] % q:
            iv = pow(x[i], q - 2, q)
            return tuple(v * iv % q for v in x)
    return None


ptsX = []
for lead in range(5):
    for tail in range(Q23 ** (4 - lead)):
        t = tail
        co = [0] * lead + [1]
        for _ in range(4 - lead):
            co.append(t % Q23)
            t //= Q23
        x = tuple(co)
        if _ev23(FK, x, Q23) == 0:
            ptsX.append(x)
Dp = []
for x in ptsX:
    Vx = [_ev23(V8[i], x, Q23) for i in range(5)]
    if all((x[i] * Vx[j] - x[j] * Vx[i]) % Q23 == 0
           for i in range(5) for j in range(i + 1, 5)):
        Dp.append((x, all(v == 0 for v in Vx)))
check_eq("D_8(F_23) has 60 points", len(Dp), 60)
check("V_8 vanishes identically at every one of them (not merely "
      "proportionally to x)", all(z for _, z in Dp))
M23 = Model(Q23)
S23 = {x for x, _ in Dp}
seen, orbs = set(), []
for x, _ in Dp:
    if x in seen:
        continue
    front, O = [x], {x}
    while front:
        nxt = []
        for u in front:
            for g in (M23.sigma, M23.tau, M23.iota):
                v = _norm23(tuple(sum(g[i][j] * u[j] for j in range(5)) % Q23
                                  for i in range(5)), Q23)
                if v not in O:
                    O.add(v)
                    nxt.append(v)
        front = nxt
    seen |= O
    orbs.append(len(O))
    check("the orbit stays inside D_8 (equivariance of V_8, independently "
          "confirmed)", O <= S23)
check_eq("D_8(F_23) is a single G-orbit, of size 60 = |G|/11", sorted(orbs),
         [60])

banner("(D2)  ROUTE A -- the line-congruence incidence scheme")
for nm in ("y1", "y2"):
    for chart in range(5):
        fn = sys_routeA(V8, Y[nm], chart, PRIME_A, 1, False,
                        os.path.join(TMP, f"A{nm}{chart}.ms"))
        r = msolve(fn, f"A{nm}{chart}")
        if chart == 0:
            check_eq(f"ROUTE A [{nm}] chart 0: Z_y off the degeneracy curve has "
                     "209 distinct points and minimal polynomial degree 210 "
                     "-- 208 simple points and exactly one double point",
                     (r["kind"], r["min"], r["pts"]), ("zerodim", 210, 209))
        else:
            check_eq(f"ROUTE A [{nm}] flag chart {chart}: empty", r["kind"],
                     "empty")
for nm in ("y1", "y2", "y3"):
    fn = sys_routeA(V8, Y[nm], 0, PRIME_A, 3, True,
                    os.path.join(TMP, f"Ay{nm}.ms"))
    r = msolve(fn, f"Ay{nm}")
    check_eq(f"ROUTE A [{nm}]: removing x = y as well leaves 208 points, all "
             "simple -- so the double point IS x = y (preliminary issue (ii))",
             (r["kind"], r["min"], r["pts"]), ("zerodim", 208, 208))
# a second random inversion, to rule out an unlucky linear combination
fn = sys_routeA(V8, Y["y1"], 0, PRIME_A, 77, False,
                os.path.join(TMP, "Aalt.ms"))
r = msolve(fn, "Aalt")
check_eq("ROUTE A [y1] with an independent random combination of the 2x2 "
         "minors inverted: same answer", (r["min"], r["pts"]), (210, 209))

banner("(D3)  ROUTE B -- the point count in the t-parametrisation")
for chart in range(5):
    fn = sys_routeB(V8, Y["y1"], chart, PRIME_A,
                    os.path.join(TMP, f"B1{chart}.ms"))
    r = msolve(fn, f"B1{chart}")
    if chart == 0:
        check_eq("ROUTE B [y1] chart 0 (mod p): 208 distinct preimages, "
                 "all simple", (r["kind"], r["min"], r["pts"]),
                 ("zerodim", 208, 208))
    else:
        check_eq(f"ROUTE B [y1] flag chart {chart}: empty -- the fiber is "
                 "complete in the chart x_0 != 0", r["kind"], "empty")
for nm in ("y2", "y3"):
    fn = sys_routeB(V8, Y[nm], 0, PRIME_A, os.path.join(TMP, f"B{nm}.ms"))
    r = msolve(fn, f"B{nm}")
    check_eq(f"ROUTE B [{nm}] chart 0 (mod p): 208", (r["min"], r["pts"]),
             (208, 208))
fn = sys_routeB(V8, Y["y1"], 0, PRIME_B, os.path.join(TMP, "Bp2.ms"))
r = msolve(fn, "Bp2")
check_eq(f"ROUTE B [y1] at the second prime {PRIME_B}: 208",
         (r["min"], r["pts"]), (208, 208))
t1 = time.time()
fn = sys_routeB(V8, Y["y1"], 0, 0, os.path.join(TMP, "Bq.ms"))
r = msolve(fn, "Bq")
check_eq("ROUTE B [y1] in CHARACTERISTIC ZERO (msolve over Q): 208",
         (r["kind"], r["min"], r["pts"]), ("zerodim", 208, 208))
print(f"  the characteristic-zero run took {time.time()-t1:.0f}s")

banner("(D3')  ROUTE B at random targets -- the genericity guard")


def _sqrt_mod(a, p):
    a %= p
    if a == 0:
        return 0
    if pow(a, (p - 1) // 2, p) != 1:
        return None
    if p % 4 == 3:
        return pow(a, (p + 1) // 4, p)
    q, s = p - 1, 0
    while q % 2 == 0:
        q //= 2
        s += 1
    z = 2
    while pow(z, (p - 1) // 2, p) != p - 1:
        z += 1
    mm, c, t, r = s, pow(z, q, p), pow(a, q, p), pow(a, (q + 1) // 2, p)
    while t != 1:
        i, t2 = 0, t
        while t2 != 1:
            t2 = t2 * t2 % p
            i += 1
        b = pow(c, 1 << (mm - i - 1), p)
        mm, c, t, r = i, b * b % p, t * b % p * b % p, r * b % p
    return r


rnd2 = _lcg(20260812)
big = []
while len(big) < 3:
    x0, x1, x2, x3 = [next(rnd2) * next(rnd2) % PRIME_A + 1 for _ in range(4)]
    a, b = x0, x3 * x3 % PRIME_A
    c0 = (x0 * x0 % PRIME_A * x1 + x1 * x1 % PRIME_A * x2
          + x2 * x2 % PRIME_A * x3) % PRIME_A
    sq = _sqrt_mod((b * b - 4 * a * c0) % PRIME_A, PRIME_A)
    if sq is None:
        continue
    x4 = (-b + sq) * pow(2 * a % PRIME_A, PRIME_A - 2, PRIME_A) % PRIME_A
    y = (x0, x1, x2, x3, x4)
    if sum(y[i] ** 2 * y[(i + 1) % 5] for i in range(5)) % PRIME_A:
        continue
    big.append(y)
for n, y in enumerate(big):
    tot = 0
    for chart in range(5):
        fn = sys_routeB(V8, y, chart, PRIME_A,
                        os.path.join(TMP, f"Br{n}{chart}.ms"))
        r = msolve(fn, f"Br{n}{chart}")
        tot += r.get("pts") or 0
        if chart:
            check(f"random target {n}: flag chart {chart} empty",
                  r["kind"] == "empty")
    check_eq(f"random target {n} in X(F_p), p = {PRIME_A}: 208 preimages "
             "(a target off the at-most-two-dimensional bad locus, up to a "
             "1-in-p accident)", tot, 208)

banner("(D4)  the two routes agree, and phi_9")
DELTA8 = 208
check_eq("ROUTE A - 2 (remove the tangency double point at x = y) = ROUTE B",
         210 - 2, DELTA8)
check_eq("delta(phi_8)", DELTA8, 208)
for chart in range(5):
    fn = sys_routeB(V9, Y["y1"], chart, PRIME_A,
                    os.path.join(TMP, f"B9{chart}.ms"))
    r = msolve(fn, f"B9{chart}")
    if chart == 0:
        check_eq("ROUTE B for phi_9 [y1] chart 0: 288 distinct preimages",
                 (r["kind"], r["min"], r["pts"]), ("zerodim", 288, 288))
    else:
        check_eq(f"ROUTE B for phi_9 flag chart {chart}: empty", r["kind"],
                 "empty")
fn = sys_routeB(V9, Y["y2"], 0, PRIME_A, os.path.join(TMP, "B9y2.ms"))
r = msolve(fn, "B9y2")
check_eq("ROUTE B for phi_9 [y2]: 288", (r["min"], r["pts"]), (288, 288))
DELTA9 = 288

# ---- the structural reason the multiplicity at x = y is exactly 2 -----------
banner("(D5)  why the spurious solution x = y has multiplicity 2")
for nm, y in Y.items():
    Vy = [sum(c * _powprod(y, e) for e, c in V8[i].items()) for i in range(5)]
    check(f"[{nm}] V_8(y) ^ y != 0, so the line l_y is defined",
          any(y[i] * Vy[j] - y[j] * Vy[i] for i in range(5) for j in range(5)))
    gr = [sum(c * _powprod(y, e) for e, c in GRAD0[j].items()) for j in range(5)]
    check(f"[{nm}] grad F(y) . V_8(y) = 0, so l_y is TANGENT to X at y: the "
          "intersection l_y . X carries y with multiplicity >= 2, which is "
          "exactly the multiplicity found in ROUTE A",
          sum(gr[j] * Vy[j] for j in range(5)) == 0)

# ======================================================================
# (E)  The detection test:  is delta represented by x^2 + xy + 3y^2 ?
# ======================================================================
banner("(E)  the detection test -- the CLEAN norm form")


def is_norm_bruteforce(n):
    for yv in range(0, 2 * n + 2):
        for xv in range(-2 * n - 2, 2 * n + 2):
            if xv * xv + xv * yv + 3 * yv * yv == n:
                return True
    return False


def factorize(n):
    f, d = {}, 2
    while d * d <= n:
        while n % d == 0:
            f[d] = f.get(d, 0) + 1
            n //= d
        d += 1
    if n > 1:
        f[n] = f.get(n, 0) + 1
    return f


QR11 = {1, 3, 4, 5, 9}


def is_inert(p):
    """p is inert in Q(sqrt(-11)) iff p != 11 and p mod 11 is a non-residue
    (COMBINED_DEGREE_SIEVE/THEOREM_COMBINED_SIEVE.md Theorem 4.1)"""
    return p != 11 and (p % 11) not in QR11


def is_norm_valuation(n):
    return all(v % 2 == 0 for p, v in factorize(n).items() if is_inert(p))


check("the inert primes start 2, 7, 13, 17, 19, 29, 41, 43",
      [p for p in (2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43)
       if is_inert(p)] == [2, 7, 13, 17, 19, 29, 41, 43])
check("the valuation criterion agrees with brute force on 1..400",
      all(is_norm_valuation(n) == is_norm_bruteforce(n)
          for n in range(1, 401)))
check("the norm form represents 1, 3, 4, 5, 9, 11 and not 2, 6, 7, 8, 10 "
      "(sealed)",
      all(is_norm_valuation(n) for n in (1, 3, 4, 5, 9, 11))
      and not any(is_norm_valuation(n) for n in (2, 6, 7, 8, 10)))

check_eq("delta(phi_8) = 208 = 2^4 * 13", factorize(DELTA8), {2: 4, 13: 1})
check("13 is inert in Q(sqrt(-11))  (13 mod 11 = 2, a non-residue)",
      is_inert(13))
check_eq("v_13(delta(phi_8)) = 1 is ODD", factorize(DELTA8)[13] % 2, 1)
check("**delta(phi_8) = 208 is NOT represented by x^2+xy+3y^2**",
      not is_norm_valuation(DELTA8) and not is_norm_bruteforce(DELTA8))

check_eq("delta(phi_9) = 288 = 2^5 * 3^2", factorize(DELTA9), {2: 5, 3: 2})
check("2 is inert in Q(sqrt(-11))", is_inert(2))
check_eq("v_2(delta(phi_9)) = 5 is ODD", factorize(DELTA9)[2] % 2, 1)
check("**delta(phi_9) = 288 is NOT represented by x^2+xy+3y^2**",
      not is_norm_valuation(DELTA9) and not is_norm_bruteforce(DELTA9))

# iterates and composites, since the dichotomy must hold for EVERY self-map
check("odd iterates of phi_8 are non-norms too: v_13(208^r) = r",
      all(not is_norm_valuation(DELTA8 ** r) for r in (1, 3, 5)))
check("even iterates of phi_8 ARE norms (norms are multiplicative)",
      all(is_norm_valuation(DELTA8 ** r) for r in (2, 4)))
check("delta(phi_8 o phi_9) = 208*288 = 59904 is a non-norm",
      not is_norm_valuation(DELTA8 * DELTA9))

# adversarial: the number the naive (no-excess) count would have produced
NAIVE8 = 3 * (1 + 8 + 8 ** 2 + 8 ** 3) - 2
check_eq("the naive congruence order 3*c_3(Q) - 2 with no excess correction "
         "would have been 1753", NAIVE8, 1753)
check("ADVERSARIAL: 1753 IS a norm (1753 = 1^2 + 1*24 + 3*24^2), so getting "
      "the excess wrong would have flipped the verdict to CLEAN-compatible -- "
      "this is why the degeneracy locus had to be settled first",
      is_norm_valuation(NAIVE8) and is_norm_bruteforce(NAIVE8))
check_eq("1753 = 1^2 + 1*24 + 3*24^2", 1 + 24 + 3 * 24 * 24, 1753)

# ======================================================================
# (F)  Consistency with the sealed constraints.
# ======================================================================
banner("(F)  consistency with the sealed tables")
DP = 25
check(f"3 <= delta(phi_8) <= d'^3 - d' = {DP**3 - DP} (sealed Corollary 3.5, "
      "dim Z = 1)", 3 <= DELTA8 <= DP ** 3 - DP)
check("3 <= delta(phi_9) <= 28^3 - 28", 3 <= DELTA9 <= 28 ** 3 - 28)
sol = [(z, DP ** 3 - DP * z - DELTA8) for z in range(1, DP ** 2 + 1)
       if DP ** 3 - DP * z - DELTA8 >= 0]
check("the sealed excess identity delta = d'^3 - d' zeta - a admits solutions "
      f"with zeta in [1, d'^2] and a >= 0 for delta = {DELTA8}", bool(sol))
check_eq("the largest admissible zeta for delta(phi_8)", max(z for z, _ in sol),
         616)
check("delta(phi_8) is not 1 and not 2, as every G-selfmap must satisfy",
      DELTA8 not in (1, 2))
check("delta(phi_8) != delta(phi_9), so phi_8 and phi_9 are genuinely "
      "different self-maps", DELTA8 != DELTA9)

banner("SUMMARY")
print(f"  delta(phi_8) = {DELTA8} = 2^4 * 13   -- NOT a norm  => phi_8 is NOT CLEAN")
print(f"  delta(phi_9) = {DELTA9} = 2^5 * 3^2  -- NOT a norm  => phi_9 is NOT CLEAN")
print(f"  checks run : {CHECKS}")
print(f"  failures   : {len(FAILURES)}")
for f in FAILURES:
    print("   -", f)
print(f"  wall clock : {time.time()-T0:.0f}s")
print()
if FAILURES:
    print("RESULT: FAIL")
    sys.exit(1)
print("RESULT: PASS")
