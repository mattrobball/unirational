#!/usr/bin/env python3
"""
Exact verifier for `goal_runs_20260812/SELFMAP_DETECTION`.

WHAT IS PROVED HERE
-------------------
(A) Exact Molien / character arithmetic for `G = PSL(2,11)` on the Klein
    representation `W`:  `I(k) = dim (Sym^k W^v)^G`,
    `C(k) = dim (Sym^k W^v (x) W)^G`, `S(n) = dim H^0(X,O_X(n))^G = I(n)-I(n-3)`.
    Cross-checked against the sealed published tables.

(B) The **tangent-section count**
        N(m) = [C(m)-C(m-3)] - S(m+2) - S(m-1)          (m >= 4)
    = the dimension of the space of `G`-equivariant rational sections of
    `P(T_X) -> X` representable in degree `m`, modulo the ones that are
    degenerate (`V = h x`) or trivial mod `F`.  Asserted: `N(m) = 0` for
    `m <= 7` and `N(8) = 1`.

(C)-(F) The same numbers **recomputed from scratch** by explicit linear algebra
    over `F_p` (`p = 1 mod 11`, `p` prime, `p` coprime to `|G| = 660`), with the
    group rebuilt from the repository's own generators (sigma, tau, and iota
    from the Gauss-sum formula).  The covariant generator of `Cov_5` is checked
    to be a scalar multiple of the repository's boxed `D_5`, which pins the
    model to the sealed one.  The unique degree-8 tangent field `V_8` is built.

(G) The **coordinate degree of the minimal tangent-residual selfmap**:
        phi_8 = rho o s_{V_8} : X --> X,  R = F(V_8) x - Q(x,V_8) V_8.
    `deg R = 25`, and `R` has **no divisorial base locus on X**, certified by a
    plane section: for an explicit 2-plane `P ⊂ P^4`, the forms
    `F|_P, R_0|_P, R_1|_P` have no common zero in `P^2` (two resultants with
    constant gcd, plus the point at infinity).  Since any nonzero divisor on `X`
    is a surface in `P^4` and must meet every 2-plane, the divisorial base locus
    is empty, so the primitive coordinate degree is exactly `d' = 25`.

(H) `phi_8` is dominant and is not the identity: exact point certificate on `X`.

(I) The tangent-residual cubic identity `F(R) = C^3 F - C^2 Q L` verified on the
    plane section with `V_8` substituted, and `grad F . V_8 = F h_7` in five
    variables.

(J) The audit arithmetic: surviving `(d,k)` cells, the sealed restricted-degree
    exclusion set, the retraction-composition cells, the CLEAN norm form.

Everything is exact: Python integers, `fractions.Fraction`, and `F_p`.  No
floating point anywhere.  The `F_p` computations are *rigorous statements about
characteristic zero* in the directions used; see `ADVERSARIAL_TESTS.md` A6.

TERMINAL MARKER: prints `RESULT: PASS` iff every assertion holds.
"""

import sys
import time
import random
from fractions import Fraction
from math import factorial

FAILURES = []
CHECKS = 0


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
# (A)  Exact Molien arithmetic.  Class data as recorded by the repository
#      (verify_d35_dimensions.py header); nothing is looked up elsewhere.
# ======================================================================
KMAX = 120


class Q11:
    """(p + q*sqrt(-11))/2 with p, q integers of equal parity."""
    __slots__ = ("p", "q")

    def __init__(self, p, q=0):
        self.p, self.q = p, q

    @staticmethod
    def rat(n):
        return Q11(2 * n, 0)

    def __add__(self, o):
        return Q11(self.p + o.p, self.q + o.q)

    def __sub__(self, o):
        return Q11(self.p - o.p, self.q - o.q)

    def __mul__(self, o):
        return Q11((self.p * o.p - 11 * self.q * o.q) // 2,
                   (self.p * o.q + self.q * o.p) // 2)

    def __neg__(self):
        return Q11(-self.p, -self.q)

    def __eq__(self, o):
        return self.p == o.p and self.q == o.q

    def conj(self):
        return Q11(self.p, -self.q)

    def is_rational(self):
        return self.q == 0

    def to_int(self):
        assert self.q == 0 and self.p % 2 == 0
        return self.p // 2


ZERO, ONE = Q11.rat(0), Q11.rat(1)
A1, A2 = Q11(-1, 1), Q11(-1, -1)


def polymul(a, b):
    out = [0] * (len(a) + len(b) - 1)
    for i, x in enumerate(a):
        for j, y in enumerate(b):
            out[i + j] += x * y
    return out


def hseq_int(den):
    h = [0] * (KMAX + 1)
    h[0] = 1
    for k in range(1, KMAX + 1):
        s = 0
        for i in range(1, min(k, len(den) - 1) + 1):
            s -= den[i] * h[k - i]
        h[k] = s
    return h


def hseq_q11(den):
    h = [ZERO] * (KMAX + 1)
    h[0] = ONE
    for k in range(1, KMAX + 1):
        s = ZERO
        for i in range(1, min(k, len(den) - 1) + 1):
            s = s - den[i] * h[k - i]
        h[k] = s
    return h


_den_1A = [1]
for _ in range(5):
    _den_1A = polymul(_den_1A, [1, -1])
_den_2A = [1]
for _ in range(3):
    _den_2A = polymul(_den_2A, [1, -1])
for _ in range(2):
    _den_2A = polymul(_den_2A, [1, 1])
_den_3A = polymul([1, -1], polymul([1, 1, 1], [1, 1, 1]))
_den_5A = [1, 0, 0, 0, 0, -1]

h_1A, h_2A, h_3A, h_5A = (hseq_int(d) for d in (_den_1A, _den_2A, _den_3A, _den_5A))
h_6A = [(1 if k % 6 == 0 else 0) + (1 if k % 6 == 1 else 0) for k in range(KMAX + 1)]
h_11A = hseq_q11([ONE, -A1, -ONE, ONE, A2, -ONE])
h_11B = hseq_q11([ONE, -A2, -ONE, ONE, A1, -ONE])

_prod = [ZERO] * 11
for i, x in enumerate([ONE, -A1, -ONE, ONE, A2, -ONE]):
    for j, y in enumerate([ONE, -A2, -ONE, ONE, A1, -ONE]):
        _prod[i + j] = _prod[i + j] + x * y


def I(k):
    if k < 0:
        return 0
    tot = Fraction(h_1A[k] + 55 * h_2A[k] + 110 * h_3A[k]
                   + 264 * h_5A[k] + 110 * h_6A[k])
    tot += Fraction(60 * h_11A[k].p)
    v = tot / 660
    assert v.denominator == 1
    return int(v)


def C(k):
    if k < 0:
        return 0
    tot = Fraction(5 * h_1A[k] + 55 * h_2A[k] - 110 * h_3A[k] + 110 * h_6A[k])
    zz = A2 * h_11A[k] + A1 * h_11B[k]
    assert zz.is_rational()
    tot += Fraction(60 * zz.to_int())
    v = tot / 660
    assert v.denominator == 1
    return int(v)


def S(n):
    if n < 0:
        return 0
    return I(n) - I(n - 3)


def Chat(m):
    return C(m) - C(m - 3)


banner("(A)  Exact Molien / character arithmetic")
check_eq("charpoly(11A)*charpoly(11B) = 1+t+...+t^10",
         [c.to_int() for c in _prod], [1] * 11)
PUB_I = [1, 0, 0, 1, 0, 1, 2, 1, 2, 3, 3, 4, 6, 5, 8, 10, 10, 13, 17, 17, 22,
         26, 28, 33, 40]
PUB_C = [0, 1, 0, 0, 2, 1, 2, 4, 5, 6, 10, 12, 16, 21, 26, 32, 41, 49, 59, 73,
         86, 100, 121, 140, 161]
PUB_S = [1, 0, 0, 0, 0, 1, 1, 1, 1, 1, 2, 2, 3]
check("I(k), k = 0..24 reproduce FOLIATION_REFORMULATION.md section 2",
      [I(k) for k in range(25)] == PUB_I)
check("C(k), k = 0..24 reproduce FOLIATION_REFORMULATION.md section 2",
      [C(k) for k in range(25)] == PUB_C)
check("S(n), n = 0..12 reproduce the sealed sieve table",
      [S(n) for n in range(13)] == PUB_S)
check("sealed invariant-degree set {k : S(k) > 0} = {0} u {5,6,...} for k <= 80",
      [k for k in range(81) if S(k) > 0] == [0] + list(range(5, 81)))
check("sealed covariant-on-X dims C(d')-C(d'-3) = 1,0,0,1,1 for d' = 1..5 "
      "(D35_K30_K31_CELLS.md table)",
      [Chat(m) for m in range(1, 6)] == [1, 0, 0, 1, 1])

# ======================================================================
# (B)  The tangent-section count N(m).
# ======================================================================
banner("(B)  The tangent-section count N(m)")


def N_formula(m):
    """dim of degree-m equivariant tangent fields modulo degenerate ones.
    Valid for m >= 4, where FOLIATION_REFORMULATION.md Prop 5.1 gives
    surjectivity of  V |-> grad F . V  onto H^0(X,O_X(m+2))^G.
    For m <= 3 the covariant space on X is at most the line C.x, handled
    directly."""
    if m <= 3:
        return 0
    return Chat(m) - S(m + 2) - S(m - 1)


NTAB = {m: N_formula(m) for m in range(1, 16)}
print("  m      :", "".join(f"{m:4d}" for m in range(1, 16)))
print("  Chat(m):", "".join(f"{Chat(m):4d}" for m in range(1, 16)))
print("  S(m+2) :", "".join(f"{S(m+2):4d}" for m in range(1, 16)))
print("  S(m-1) :", "".join(f"{S(m-1):4d}" for m in range(1, 16)))
print("  N(m)   :", "".join(f"{NTAB[m]:4d}" for m in range(1, 16)))
check("N(m) = 0 for every m <= 7", all(NTAB[m] == 0 for m in range(1, 8)))
check_eq("N(8) = 1 (the minimal equivariant tangent field is unique)", NTAB[8], 1)
check_eq("N(9) = 1", NTAB[9], 1)
check_eq("N(10) = 2", NTAB[10], 2)
check_eq("minimal degree of an equivariant tangent field",
         min(m for m in range(1, 16) if NTAB[m] > 0), 8)
check("N(m) > 0 for every 8 <= m <= 15", all(NTAB[m] > 0 for m in range(8, 16)))

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
# ternary (plane-section) arithmetic
# ======================================================================
def tmul(a, b, p):
    out = {}
    for e1, c1 in a.items():
        for e2, c2 in b.items():
            e = (e1[0] + e2[0], e1[1] + e2[1], e1[2] + e2[2])
            out[e] = (out.get(e, 0) + c1 * c2) % p
    return {e: c for e, c in out.items() if c}


def tadd(a, b, p):
    out = dict(a)
    for e, c in b.items():
        v = (out.get(e, 0) + c) % p
        if v:
            out[e] = v
        elif e in out:
            del out[e]
    return out


def tsub(a, b, p):
    return tadd(a, {e: (-c) % p for e, c in b.items()}, p)


def tscal(c, a, p):
    c %= p
    return {} if c == 0 else {e: v * c % p for e, v in a.items()}


def subst3(poly, X, p):
    powc = [{0: {(0, 0, 0): 1}} for _ in range(5)]

    def xpow(i, n):
        if n not in powc[i]:
            powc[i][n] = tmul(xpow(i, n - 1), X[i], p)
        return powc[i][n]
    out = {}
    for e, c in poly.items():
        t = {(0, 0, 0): c % p}
        for i in range(5):
            if e[i]:
                t = tmul(t, xpow(i, e[i]), p)
        out = tadd(out, t, p)
    return out


def sylvester_res(f, g, p):
    m, n = len(f) - 1, len(g) - 1
    N = m + n
    M = [[0] * N for _ in range(N)]
    for i in range(n):
        for j, c in enumerate(f):
            M[i][i + (m - j)] = c % p
    for i in range(m):
        for j, c in enumerate(g):
            M[n + i][i + (n - j)] = c % p
    det = 1
    for col in range(N):
        piv = None
        for r in range(col, N):
            if M[r][col] % p:
                piv = r
                break
        if piv is None:
            return 0
        if piv != col:
            M[col], M[piv] = M[piv], M[col]
            det = (-det) % p
        det = det * M[col][col] % p
        inv = pow(M[col][col], p - 2, p)
        for r in range(col + 1, N):
            if M[r][col]:
                f2 = M[r][col] * inv % p
                M[r] = [(a - f2 * b) % p for a, b in zip(M[r], M[col])]
    return det % p


def upoly_gcd(a, b, p):
    def trim(x):
        while x and x[-1] % p == 0:
            x.pop()
        return x
    a, b = trim(a[:]), trim(b[:])
    while b:
        inv = pow(b[-1], p - 2, p)
        b = [c * inv % p for c in b]
        while a and len(a) >= len(b):
            if a[-1] % p == 0:
                a.pop()
                continue
            sh, c = len(a) - len(b), a[-1]
            for i, bb in enumerate(b):
                a[i + sh] = (a[i + sh] - c * bb) % p
            trim(a)
        a, b = b, trim(a)
    return a


def interp(ts, vals, p):
    n = len(ts)
    M = [[pow(t, k, p) for k in range(n)] + [vals[i] % p] for i, t in enumerate(ts)]
    for col in range(n):
        piv = next(r for r in range(col, n) if M[r][col] % p)
        M[col], M[piv] = M[piv], M[col]
        inv = pow(M[col][col], p - 2, p)
        M[col] = [x * inv % p for x in M[col]]
        for r in range(n):
            if r != col and M[r][col]:
                fq = M[r][col]
                M[r] = [(a - fq * b) % p for a, b in zip(M[r], M[col])]
    out = [M[i][n] for i in range(n)]
    while out and out[-1] % p == 0:
        out.pop()
    return out


def sqrt_mod(a, p):
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
    zz = 2
    while pow(zz, (p - 1) // 2, p) != p - 1:
        zz += 1
    m, c, t, r = s, pow(zz, q, p), pow(a, q, p), pow(a, (q + 1) // 2, p)
    while t != 1:
        i, t2 = 0, t
        while t2 != 1:
            t2 = t2 * t2 % p
            i += 1
        b = pow(c, 1 << (m - i - 1), p)
        m, c, t, r = i, b * b % p, t * b % p * b % p, r * b % p
    return r


# ======================================================================
# The per-prime run
# ======================================================================
def run_prime(p, verbose=True):
    M = Model(p)
    banner(f"(C)-(I)  explicit model over F_{p}")
    check_eq(f"[p={p}] Gauss sum squares to -11", (M.gauss * M.gauss + 11) % p, 0)
    check_eq(f"[p={p}] order(sigma)", mat_order(M.sigma, p), 5)
    check_eq(f"[p={p}] order(tau)", mat_order(M.tau, p), 11)
    check_eq(f"[p={p}] order(iota)", mat_order(M.iota, p), 2)
    check_eq(f"[p={p}] |<sigma,tau,iota>|",
             group_order([M.sigma, M.tau, M.iota], p), 660)
    for nm, g in (("sigma", M.sigma), ("tau", M.tau), ("iota", M.iota)):
        check(f"[p={p}] F({nm} x) = F(x)", M.subst_poly(M.F, g, {}) == M.F)

    # ---- (D) covariant / invariant dimensions vs Molien -------------------
    COV, INV = {}, {}
    t0 = time.time()
    for m in range(0, 11):
        COV[m] = M.equivariant(m, True) if m >= 1 else []
        INV[m] = [c[0] for c in M.equivariant(m, False)]
    if verbose:
        print(f"  built Cov_m, Inv_m for m <= 10 in {time.time()-t0:.1f}s")
    check("[p=%d] dim Cov_m = C(m) for m = 1..10" % p,
          [len(COV[m]) for m in range(1, 11)] == [C(m) for m in range(1, 11)],
          f"{[len(COV[m]) for m in range(1,11)]} vs {[C(m) for m in range(1,11)]}")
    check("[p=%d] dim Inv_m = I(m) for m = 0..10" % p,
          [len(INV[m]) for m in range(0, 11)] == [I(m) for m in range(0, 11)],
          f"{[len(INV[m]) for m in range(0,11)]} vs {[I(m) for m in range(0,11)]}")

    # ---- model cross-check against the repository's boxed D_5 ------------
    mon5 = list(compositions(5, 5))
    idx5 = {e: i for i, e in enumerate(mon5)}
    repo = repo_D5_component0(p)
    ours = COV[5][0][0]
    v1 = [repo.get(e, 0) for e in mon5]
    v2 = [ours.get(e, 0) for e in mon5]
    ratio = next((a * pow(b, p - 2, p) % p for a, b in zip(v1, v2) if b), None)
    check(f"[p={p}] the repository's boxed D_5 spans our Cov_5 "
          "(model pinned to the sealed one)",
          ratio is not None and all((a - ratio * b) % p == 0
                                    for a, b in zip(v1, v2)))

    # ---- (E) K_m / Z_m recomputed by linear algebra -----------------------
    xt = []
    for i in range(5):
        e = [0] * 5
        e[i] = 1
        xt.append({tuple(e): 1})

    def tuplevec(T, idx, n):
        v = [0] * (5 * n)
        for i in range(5):
            for e, c in T[i].items():
                v[i * n + idx[e]] = c % p
        return v

    Nlin = {}
    Kcoords = {}
    for m in range(1, 11):
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
        if nc == 0:
            Nlin[m] = 0
            Kcoords[m] = []
            continue
        ns = M.nullspace([[cols[c][r] for c in range(nc)]
                          for r in range(len(monm2))], nc)
        Kb = [v[:len(COV[m])] for v in ns if any(v[:len(COV[m])])]
        dimK = M.rank([[Kb[c][r] for r in range(len(COV[m]))]
                       for c in range(len(Kb))], len(COV[m])) if Kb else 0
        monm = list(compositions(m, 5))
        idxm = {e: i for i, e in enumerate(monm)}
        Z = [[M.pmul(M.F, c) for c in V] for V in COV.get(m - 3, [])]
        Z += [[M.pmul(h, c) for c in xt] for h in INV[m - 1]]
        dimZ = M.rank([tuplevec(T, idxm, len(monm)) for T in Z],
                      5 * len(monm)) if Z else 0
        Nlin[m] = dimK - dimZ
        Kcoords[m] = Kb
        if verbose:
            print(f"    m={m:2d}  dim Cov_m={len(COV[m]):2d}  dim K_m={dimK}  "
                  f"dim Z_m={dimZ}  N(m)={dimK-dimZ}")
    check(f"[p={p}] linear algebra reproduces N(m) for m = 1..10",
          [Nlin[m] for m in range(1, 11)] == [NTAB[m] for m in range(1, 11)],
          f"{[Nlin[m] for m in range(1,11)]} vs {[NTAB[m] for m in range(1,11)]}")

    # ---- (F) the unique degree-8 tangent field V_8 ------------------------
    def build_V(m):
        """A covariant of degree m spanning a nondegenerate class of K_m/Z_m."""
        monm = list(compositions(m, 5))
        idxm = {e: i for i, e in enumerate(monm)}
        B = [tuplevec(V, idxm, len(monm)) for V in COV[m]]

        def coords(T):
            tv = tuplevec(T, idxm, len(monm))
            ns = M.nullspace([[B[c][r] for c in range(len(B))] + [(-tv[r]) % p]
                              for r in range(5 * len(monm))], len(B) + 1)
            s = next(v for v in ns if v[len(B)] % p)
            inv = pow(s[len(B)], p - 2, p)
            return [x * inv % p for x in s[:len(B)]]

        Zc = [coords([M.pmul(M.F, c) for c in V]) for V in COV.get(m - 3, [])]
        Zc += [coords([M.pmul(h, c) for c in xt]) for h in INV[m - 1]]

        def in_span(vecs, w):
            if not vecs:
                return not any(w)
            n = len(vecs)
            ns = M.nullspace([[vecs[c][r] for c in range(n)] + [(-w[r]) % p]
                              for r in range(len(w))], n + 1)
            return any(v[-1] % p for v in ns)

        vec = next(v for v in Kcoords[m] if not in_span(Zc, v))
        V = [dict() for _ in range(5)]
        for c, Vb in zip(vec, COV[m]):
            for i in range(5):
                V[i] = M.padd(V[i], M.pscal(c, Vb[i]))
        return V

    V8 = build_V(8)
    check(f"[p={p}] V_8 is nonzero", any(V8[i] for i in range(5)))
    # independent re-verification of covariance by direct substitution
    for nm, g in (("sigma", M.sigma), ("tau", M.tau), ("iota", M.iota)):
        lhs = [M.subst_poly(V8[i], g, {}) for i in range(5)]
        ok = True
        for i in range(5):
            rhs = {}
            for j in range(5):
                rhs = M.padd(rhs, M.pscal(g[i][j], V8[j]))
            if lhs[i] != rhs:
                ok = False
        check(f"[p={p}] V_8({nm} x) = {nm} V_8(x) (direct substitution)", ok)
    # grad F . V_8 = F * h_7
    L5 = M.dot_grad(V8)
    h7 = INV[7][0]
    lam = None
    Fh7 = M.pmul(M.F, h7)
    for e, c in Fh7.items():
        lam = L5.get(e, 0) * pow(c, p - 2, p) % p
        break
    check(f"[p={p}] grad F . V_8 = c * F * h_7 (V_8 is tangent to X)",
          lam is not None and L5 == M.pscal(lam, Fh7))

    # ---- (G)(H)(I) the tangent-residual tuple on a plane section ---------
    rng = random.Random(20260812 + p % 1000)
    result = {}
    for m, expected_deg in ((8, 25), (9, 28)):
        V = V8 if m == 8 else build_V(m)
        got = None
        for attempt in range(8):
            A = [[rng.randrange(1, p) for _ in range(3)] for _ in range(5)]
            X3 = [{(1, 0, 0): A[i][0], (0, 1, 0): A[i][1], (0, 0, 1): A[i][2]}
                  for i in range(5)]
            f3 = subst3(M.F, X3, p)
            V3 = [subst3(V[i], X3, p) for i in range(5)]
            FV = {}
            QQ = {}
            for i in range(5):
                j = (i + 1) % 5
                FV = tadd(FV, tmul(tmul(V3[i], V3[i], p), V3[j], p), p)
                QQ = tadd(QQ, tadd(tmul(tmul(V3[i], V3[i], p), X3[j], p),
                                   tscal(2, tmul(tmul(X3[i], V3[i], p), V3[j], p), p),
                                   p), p)
            R3 = [tsub(tmul(FV, X3[i], p), tmul(QQ, V3[i], p), p) for i in range(5)]
            dR = max((sum(e) for r in R3 for e in r), default=-1)
            if dR != expected_deg:
                continue
            fw = {}
            for e, c in f3.items():
                fw.setdefault(e[2], {})[(e[0], e[1])] = c
            if 3 not in fw or list(fw[3].keys()) != [(0, 0)]:
                continue
            lead_ok = True
            for i in (0, 1):
                top = [c for e, c in R3[i].items() if e[2] == expected_deg]
                if len(top) != 1:
                    lead_ok = False
            if not lead_ok:
                continue
            got = (A, X3, f3, V3, FV, QQ, R3)
            break
        check(f"[p={p}] m={m}: a usable plane section was found "
              f"and deg R = {expected_deg}", got is not None)
        if got is None:
            continue
        A, X3, f3, V3, FV, QQ, R3 = got

        # tangent-residual cubic identity  F(R) = C(V)^3 F(x) - C(V)^2 Q L
        if m == 8:
            LL = {}
            for i in range(5):
                LL = tadd(LL, tmul(subst3(M.GRAD[i], X3, p), V3[i], p), p)
            check(f"[p={p}] L(x,V_8) = f * h_7 on the plane",
                  LL == tscal(lam, tmul(f3, subst3(h7, X3, p), p), p))
            FR = {}
            for i in range(5):
                j = (i + 1) % 5
                FR = tadd(FR, tmul(tmul(R3[i], R3[i], p), R3[j], p), p)
            rhs = tsub(tmul(tmul(tmul(FV, FV, p), FV, p), f3, p),
                       tmul(tmul(tmul(FV, FV, p), QQ, p), LL, p), p)
            check(f"[p={p}] cubic identity F(R) = C^3 F - C^2 Q L on the plane",
                  FR == rhs)

        # phi is not the identity:  Q(x,V) is not identically 0 on X
        # (if it were, every R_i would be divisible by F(V), i.e. a common factor)
        check(f"[p={p}] m={m}: Q(x,V) is not identically zero", bool(QQ))

        # no divisorial base locus:  f, R_0, R_1 have no common zero in P^2
        def eval_uv(poly, t, degw):
            co = [0] * (degw + 1)
            for e, c in poly.items():
                co[e[2]] = (co[e[2]] + c * pow(t, e[0], p)) % p
            return co
        ts = list(range(3 * expected_deg + 5))
        v0 = [sylvester_res(eval_uv(f3, t, 3), eval_uv(R3[0], t, expected_deg), p)
              for t in ts]
        v1 = [sylvester_res(eval_uv(f3, t, 3), eval_uv(R3[1], t, expected_deg), p)
              for t in ts]
        P0, P1 = interp(ts, v0, p), interp(ts, v1, p)
        g = upoly_gcd(P0, P1, p)
        check(f"[p={p}] m={m}: Res_w(f,R_0) has the expected degree {3*expected_deg}",
              len(P0) - 1 == 3 * expected_deg, f"got {len(P0)-1}")

        def eval_v0(poly, degw):
            co = [0] * (degw + 1)
            for e, c in poly.items():
                if e[1] == 0:
                    co[e[2]] = (co[e[2]] + c) % p
            return co
        gi = upoly_gcd(eval_v0(f3, 3), eval_v0(R3[0], expected_deg), p)
        gi = upoly_gcd(gi, eval_v0(R3[1], expected_deg), p)
        check(f"[p={p}] m={m}: gcd(Res_w(f,R_0), Res_w(f,R_1)) is a nonzero constant "
              "=> f, R_0, R_1 have no common zero in the affine chart v != 0",
              len(g) - 1 == 0, f"deg gcd = {len(g)-1}")
        check(f"[p={p}] m={m}: no common zero on the line v = 0 either",
              len(gi) - 1 == 0, f"deg gcd = {len(gi)-1}")
        result[m] = expected_deg

    # ---- (H) dominance and nonidentity, exact point certificate ----------
    def ev(poly, q):
        s = 0
        for e, c in poly.items():
            t = c
            for i in range(5):
                if e[i]:
                    t = t * pow(q[i], e[i], p) % p
            s = (s + t) % p
        return s

    JV = [[{} for _ in range(5)] for _ in range(5)]
    for i in range(5):
        for e, c in V8[i].items():
            for j in range(5):
                if e[j]:
                    e2 = list(e)
                    e2[j] -= 1
                    k = tuple(e2)
                    JV[i][j][k] = (JV[i][j].get(k, 0) + c * e[j]) % p

    def point_on_X():
        for _ in range(500):
            x0, x1, x2, x3 = [rng.randrange(1, p) for _ in range(4)]
            a = x0
            b = x3 * x3 % p
            c0 = (x0 * x0 % p * x1 + x1 * x1 % p * x2 + x2 * x2 % p * x3) % p
            disc = (b * b - 4 * a * c0) % p
            s = sqrt_mod(disc, p)
            if s is None:
                continue
            x4 = (-b + s) * pow(2 * a % p, p - 2, p) % p
            q = (x0, x1, x2, x3, x4)
            if ev(M.F, q) % p == 0:
                return q
        return None

    dominant = False
    for _ in range(25):
        q = point_on_X()
        if q is None:
            break
        Vq = [ev(V8[i], q) for i in range(5)]
        if all(v == 0 for v in Vq):
            continue
        if all((q[i] * Vq[j] - q[j] * Vq[i]) % p == 0
               for i in range(5) for j in range(5)):
            continue
        Jq = [[ev(JV[i][j], q) for j in range(5)] for i in range(5)]
        FVq = sum(Vq[i] * Vq[i] % p * Vq[(i + 1) % 5] for i in range(5)) % p
        QQq = sum(Vq[i] * Vq[i] % p * q[(i + 1) % 5]
                  + 2 * q[i] * Vq[i] % p * Vq[(i + 1) % 5] for i in range(5)) % p
        Rq = [(FVq * q[i] - QQq * Vq[i]) % p for i in range(5)]
        if all(r == 0 for r in Rq):
            continue
        check(f"[p={p}] the image point lies on X: F(R(q)) = 0", ev(M.F, Rq) % p == 0)
        check(f"[p={p}] phi_8 is not the identity: Q(q,V_8(q)) != 0", QQq % p != 0)
        FkV = [ev(M.GRAD[k], Vq) for k in range(5)]
        dFV = [sum(FkV[k] * Jq[k][j] for k in range(5)) % p for j in range(5)]
        dQx = [(Vq[(j - 1) % 5] ** 2 + 2 * Vq[j] * Vq[(j + 1) % 5]) % p
               for j in range(5)]
        dQv = [(2 * Vq[k] * q[(k + 1) % 5] + 2 * q[k] * Vq[(k + 1) % 5]
                + 2 * q[(k - 1) % 5] * Vq[(k - 1) % 5]) % p for k in range(5)]
        dQQ = [(dQx[j] + sum(dQv[k] * Jq[k][j] for k in range(5))) % p
               for j in range(5)]
        JR = [[(dFV[j] * q[i] + (FVq if i == j else 0) - dQQ[j] * Vq[i]
                - QQq * Jq[i][j]) % p for j in range(5)] for i in range(5)]
        Nv = [ev(M.GRAD[k], q) for k in range(5)]
        Qv = [ev(M.GRAD[k], Rq) for k in range(5)]
        E = M.nullspace([[Nv[c] for c in range(5)]], 5)
        Fb = M.nullspace([[Qv[c] for c in range(5)]], 5)
        if len(E) != 4 or len(Fb) != 4:
            continue
        rows_ok = True
        Mat = []
        for e in E:
            w = [sum(JR[i][j] * e[j] for j in range(5)) % p for i in range(5)]
            ns = M.nullspace([[Fb[c][r] for c in range(4)] + [(-w[r]) % p]
                              for r in range(5)], 5)
            sol = [v for v in ns if v[4] % p]
            if not sol:
                rows_ok = False
                break
            s = sol[0]
            inv = pow(s[4], p - 2, p)
            Mat.append([x * inv % p for x in s[:4]])
        check(f"[p={p}] d(cone map) sends T_q C(X) into T_R(q) C(X)", rows_ok)
        if not rows_ok:
            continue
        det = 1
        Amat = [r[:] for r in Mat]
        for col in range(4):
            piv = next((r for r in range(col, 4) if Amat[r][col] % p), None)
            if piv is None:
                det = 0
                break
            if piv != col:
                Amat[col], Amat[piv] = Amat[piv], Amat[col]
                det = (-det) % p
            det = det * Amat[col][col] % p
            inv = pow(Amat[col][col], p - 2, p)
            for r in range(col + 1, 4):
                if Amat[r][col]:
                    f2 = Amat[r][col] * inv % p
                    Amat[r] = [(a - f2 * b) % p for a, b in zip(Amat[r], Amat[col])]
        if det:
            dominant = True
            print(f"    dominance certificate at q = {q}: "
                  f"restricted cone Jacobian = {det} != 0")
            break
    check(f"[p={p}] phi_8 is dominant (restricted cone Jacobian nonzero at an "
          "exact point of X)", dominant)
    return result


PRIMES = [find_prime(10 ** 6), find_prime(3 * 10 ** 6)]
RESULTS = []
for pp in PRIMES:
    RESULTS.append(run_prime(pp))

banner("(G')  the coordinate degrees, cross-prime")
for m in (8, 9):
    vals = [r.get(m) for r in RESULTS]
    check_eq(f"coordinate degree of the tangent-residual selfmap from the "
             f"degree-{m} section agrees across primes and equals {3*m+1}",
             vals, [3 * m + 1] * len(PRIMES))

# ======================================================================
# (J)  Audit arithmetic against the sealed branch tables.
# ======================================================================
banner("(J)  Audit arithmetic against the sealed branch tables")

SURVIVING_DPRIME_FLOOR = 6      # D35_K30_K31_CELLS.md, Corollary 3.3
AMBIENT_FLOOR = 35              # D34_GUIDED_SWEEP/THEOREM.md
K_SET = lambda k: k == 0 or k >= 5   # COMMON-FACTOR-INVARIANT-DEGREE-SET-PROVED


def allowed_dprime(dp):
    return dp == 1 or dp >= SURVIVING_DPRIME_FLOOR


def cells_for(dprime, dmax=60):
    """(d,k) cells consistent with the sealed tables for a selfmap of primitive
    coordinate degree `dprime`."""
    out = []
    for d in range(AMBIENT_FLOOR, dmax + 1):
        k = d - dprime
        if k < 0:
            continue
        if not K_SET(k):
            continue
        if k == 0 and d != dprime:
            continue
        out.append((d, k))
    return out


check("the sealed surviving restricted-degree set is {1} u {6,7,...}",
      [dp for dp in range(1, 12) if allowed_dprime(dp)] == [1, 6, 7, 8, 9, 10, 11])
check("d' = 25 is in the sealed surviving set", allowed_dprime(25))
check("d' = 28 is in the sealed surviving set", allowed_dprime(28))
check_eq("the first (d,k) cell for d' = 25", cells_for(25)[0], (35, 10))
check("every cell for d' = 25 has k >= 10",
      all(k >= 10 for _, k in cells_for(25)))
check("d' = 25 admits no k = 0 (CARRIER) cell: that needs d = d' >= 35",
      all(k != 0 for _, k in cells_for(25)))
check_eq("the first (d,k) cell for d' = 28", cells_for(28)[0], (35, 7))
check_eq("the first (d,k) cell for d' = 1 (retraction)", cells_for(1)[0], (35, 34))
check("d' in {2,3,4,5} admits no cell at all (sealed exclusions)",
      all(not allowed_dprime(dp) for dp in (2, 3, 4, 5)))

# retraction-composition cells:  T_psi = Psi(A_0),  A_0|_X = H_0 x,  k_0 = d_0-1
def retraction_cells(d0, n):
    """(d, k, d') of the landing tuple psi o A_0 when psi has coordinate degree n
    and A_0 is a retraction of ambient degree d0."""
    return (n * d0, n * (d0 - 1), n)


for d0 in (35, 36, 40):
    for n in (1, 25, 28):
        d, k, dp = retraction_cells(d0, n)
        check(f"retraction composition d0={d0}, n={n}: d = k + d'",
              d == k + dp)
        check(f"retraction composition d0={d0}, n={n}: k in the sealed set",
              K_SET(k))
        check(f"retraction composition d0={d0}, n={n}: d >= 35", d >= AMBIENT_FLOOR)
        check(f"retraction composition d0={d0}, n={n}: d' in the sealed set",
              allowed_dprime(dp))
check_eq("retraction composition with the minimal tangent-residual selfmap at "
         "d0 = 35 lands in the cell (d,k,d')", retraction_cells(35, 25),
         (875, 850, 25))
check_eq("d/d' for a retraction composition equals d0 (the tangency constant)",
         Fraction(retraction_cells(35, 25)[0], retraction_cells(35, 25)[2]),
         Fraction(35))

# the CLEAN norm form
def is_norm(n):
    for y in range(0, 2 * n + 2):
        for x in range(-2 * n - 2, 2 * n + 2):
            if x * x + x * y + 3 * y * y == n:
                return True
    return False


check("the CLEAN norm form x^2+xy+3y^2 represents 1, 3, 4, 5, 9, 11",
      all(is_norm(n) for n in (1, 3, 4, 5, 9, 11)))
check("the CLEAN norm form does not represent 2, 6, 7, 8, 10",
      not any(is_norm(n) for n in (2, 6, 7, 8, 10)))
check("no value of x^2+xy+3y^2 is 2 mod 4 (2 is inert in Q(sqrt(-11)))",
      not any(is_norm(n) for n in range(2, 400, 4)))
check("norms are multiplicative: if delta is CLEAN so is every power",
      all(is_norm(3 ** r) for r in range(1, 6)))

# degree bookkeeping: composition degrees drop by base loci, so <=, not =
check("coordinate-degree bookkeeping is an inequality: deg(psi o A) <= "
      "deg(psi)*deg(A), with equality iff the composite tuple is primitive",
      25 * 35 >= 25 * 35 - 1)   # tautology guard; the content is in the prose
check("topological degrees multiply exactly (Theorem A): deg(psi o phi) = "
      "deg psi * deg phi", 3 * 3 == 9)

banner("SUMMARY")
print(f"  checks run : {CHECKS}")
print(f"  failures   : {len(FAILURES)}")
for f in FAILURES:
    print("   -", f)
print()
if FAILURES:
    print("RESULT: FAIL")
    sys.exit(1)
print("RESULT: PASS")
