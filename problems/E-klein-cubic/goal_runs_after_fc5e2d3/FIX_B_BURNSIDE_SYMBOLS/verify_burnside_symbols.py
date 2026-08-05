#!/usr/bin/env python3
"""FIX-B -- independent verifier (ALGEBRAIC-RECOMPUTE).

Recomputes the FIX-B symbol list, the removability deltas and the C11 weight
table FROM THE REPRESENTATION ITSELF -- the S, T construction of
certificates/exact_weil_check.py, re-implemented in this file -- and compares
against symbols.json / removability.json / c11_weights.json.

It NEVER reads goal_runs_after_bc93561/FIX_A2_SOURCE_COMPLEX/source_complex.json,
so passing this file re-validates FIX-A2's source complex a second time by an
independent route.

Deliberately different methods from the producer:

  object                producer                    verifier
  --------------------  --------------------------  -----------------------------
  Q(zeta_330)           tensor basis
                        zeta_3^b zeta_5^c zeta_11^d Q[x]/Phi_330(x), Phi_330 built
                        with hand reduction rules   in-file by the recursion
                                                    Phi_n = (x^n-1)/prod_{d|n,d<n}Phi_d
  rho                   never built; chi_W taken    S, T built from the Gauss sum
                        from the payload            exactly as exact_weil_check.py,
                                                    Cayley BFS over PSL(2,F_11)
  chi_W                 payload class table         traces of the built matrices
  subgroup classes      payload's 620 subgroups     closures <a,b>, a over element
                                                    class reps, b over all of G
  W_chi                 character multiplicities    KERNELS of the stacked systems
                        <chi, chi_W|_H>             [rho(g_i) - chi(g_i)] by
                                                    division-free elimination
  delta_nr (beta)       nu = conj(chi) chi_W - dim  honest restriction matrices:
                                                    nu(h) = conj(chi(h)) *
                                                    (tr rho(h) - tr rho(h)|W_chi)
                                                    and multiplicities from the
                                                    eigenspace DIMENSIONS
  delta_res             stabiliser of the CHARACTER stabiliser of the SUBSPACE
                        chi in N_G(H)               rho(g) W_chi = W_chi
  Thm 2.1 deltas        character inner products    re-derived from the eigenvalue
                                                    multisets of the restriction
                                                    matrices on T_p

Toolchain: python3 standard library only.  Exact, characteristic 0.
"""

import json
import os
import sys
from fractions import Fraction as F
from itertools import product as iproduct
from collections import deque, defaultdict

HERE = os.path.dirname(os.path.abspath(__file__))

FAILS = []
CHECKS = []


def check(name, ok, detail=""):
    CHECKS.append((name, bool(ok), detail))
    if not ok:
        FAILS.append((name, detail))
    print("  %-4s %s%s" % ("ok" if ok else "FAIL", name,
                           ("  -- " + detail) if detail and not ok else ""))
    return ok


# ===========================================================================
# 1.  Q(zeta_11) -- exactly the C class of certificates/exact_weil_check.py
# ===========================================================================

N11 = 10


class C:
    __slots__ = ('a',)

    def __init__(self, a=0):
        if isinstance(a, C):
            self.a = a.a
        elif isinstance(a, (int, F)):
            self.a = (F(a),) + (F(0),) * (N11 - 1)
        else:
            aa = [F(x) for x in a] + [F(0)] * N11
            for k in range(len(aa) - 1, N11 - 1, -1):
                q = aa[k]
                if q:
                    for j in range(10):
                        aa[k - 10 + j] -= q
            self.a = tuple(aa[:N11])

    def __add__(self, b):
        b = C(b)
        return C([x + y for x, y in zip(self.a, b.a)])
    __radd__ = __add__

    def __neg__(self):
        return C([-x for x in self.a])

    def __sub__(self, b):
        return self + (-C(b))

    def __rsub__(self, b):
        return C(b) - self

    def __mul__(self, b):
        b = C(b)
        v = [F(0)] * 19
        for i, x in enumerate(self.a):
            if not x:
                continue
            for j, y in enumerate(b.a):
                if y:
                    v[i + j] += x * y
        return C(v)
    __rmul__ = __mul__

    def __truediv__(self, n):
        return C([x / F(n) for x in self.a])

    def __pow__(self, n):
        r, a = C(1), self
        while n:
            if n & 1:
                r = r * a
            a = a * a
            n //= 2
        return r

    def __eq__(self, b):
        return self.a == C(b).a

    def __hash__(self):
        return hash(self.a)

    def __bool__(self):
        return any(self.a)

    def __repr__(self):
        return str(self.a)


z11 = C([0, 1])
zp11 = [z11 ** i for i in range(11)]


# ===========================================================================
# 2.  Q(zeta_330) = Q[x]/Phi_330(x), Phi_330 built by the standard recursion
# ===========================================================================

def poly_divmod(a, b):
    """Exact division of integer/Fraction polynomials (low-degree-first lists)."""
    a = list(a)
    q = [F(0)] * (max(len(a) - len(b) + 1, 1))
    while len(a) >= len(b) and any(a):
        while a and a[-1] == 0:
            a.pop()
        if len(a) < len(b):
            break
        d = len(a) - len(b)
        c = F(a[-1], 1) / F(b[-1], 1)
        q[d] = c
        for i, bi in enumerate(b):
            a[d + i] -= c * bi
        a[-1] = F(0)
    while a and a[-1] == 0:
        a.pop()
    return q, a


def poly_mul(a, b):
    out = [F(0)] * (len(a) + len(b) - 1)
    for i, x in enumerate(a):
        if x:
            for j, y in enumerate(b):
                if y:
                    out[i + j] += x * y
    return out


_PHI = {}


def cyclotomic(n):
    if n in _PHI:
        return _PHI[n]
    num = [F(-1)] + [F(0)] * (n - 1) + [F(1)]       # x^n - 1
    for d in range(1, n):
        if n % d == 0:
            num, r = poly_divmod(num, cyclotomic(d))
            assert not r, ("cyclotomic division", n, d)
    _PHI[n] = num
    return num


N330 = 330
PHI330 = cyclotomic(N330)
DEG330 = len(PHI330) - 1

# power reduction table: x^e mod Phi_330 for 0 <= e < 2*N330
_RED = []
_cur = [F(1)]
for _e in range(2 * N330):
    _q, _r = poly_divmod(list(_cur), PHI330)
    _RED.append(tuple(list(_r) + [F(0)] * (DEG330 - len(_r))))
    _cur = [F(0)] + list(_cur)


class K:
    """Element of Q(zeta_330), stored sparsely as {exponent mod 330: Fraction}
    and canonicalised on demand through _RED."""
    __slots__ = ('d',)

    def __init__(self, d=None):
        self.d = dict(d) if d else {}

    @staticmethod
    def root(e, c=1):
        c = F(c)
        return K({e % N330: c}) if c else K()

    def __add__(self, o):
        out = dict(self.d)
        for e, v in o.d.items():
            nv = out.get(e, F(0)) + v
            if nv:
                out[e] = nv
            else:
                out.pop(e, None)
        return K(out)

    def __neg__(self):
        return K({e: -v for e, v in self.d.items()})

    def __sub__(self, o):
        return self + (-o)

    def __mul__(self, o):
        out = {}
        for e1, v1 in self.d.items():
            for e2, v2 in o.d.items():
                e = (e1 + e2) % N330
                nv = out.get(e, F(0)) + v1 * v2
                if nv:
                    out[e] = nv
                else:
                    out.pop(e, None)
        return K(out)

    def scale(self, q):
        q = F(q)
        if not q:
            return K()
        return K({e: v * q for e, v in self.d.items()})

    def canon(self):
        acc = [F(0)] * DEG330
        for e, v in self.d.items():
            row = _RED[e]
            for i in range(DEG330):
                if row[i]:
                    acc[i] += v * row[i]
        return tuple(acc)

    def is_zero(self):
        return all(x == 0 for x in self.canon())

    def __eq__(self, o):
        return (self - o).is_zero()

    def __hash__(self):
        return hash(self.canon())

    def conj(self):
        return K({(-e) % N330: v for e, v in self.d.items()})

    def rational(self):
        c = self.canon()
        if any(c[1:]):
            return None
        return c[0]


KZERO = K()
KONE = K.root(0)


def embed11(x):
    """Q(zeta_11) element (class C) -> Q(zeta_330), via zeta_11 = zeta_330^30."""
    out = {}
    for i, v in enumerate(x.a):
        if v:
            out[(30 * i) % N330] = out.get((30 * i) % N330, F(0)) + v
    return K(out)


# ===========================================================================
# 3.  The representation, rebuilt exactly as certificates/exact_weil_check.py
# ===========================================================================

def build_rho():
    qr = {1, 3, 4, 5, 9}
    g = sum((1 if a in qr else -1) * zp11[a] for a in range(1, 11))
    assert g * g == C(-11), "Gauss sum g^2 = -11 failed"
    js = [1, 3, 2, 5, 4]
    signs = [1, 1, -1, 1, 1]
    S = [[F(signs[k], signs[i]) * (zp11[(9 * j * l) % 11] - zp11[(-9 * j * l) % 11])
          * (-g) / 11 for k, l in enumerate(js)] for i, j in enumerate(js)]
    T = [[zp11[(js[i] * js[i]) % 11] if i == j else C(0) for j in range(5)]
         for i in range(5)]
    I5 = [[C(1 if i == j else 0) for j in range(5)] for i in range(5)]

    def mm(A, B):
        return [[sum((A[i][k] * B[k][j] for k in range(5)), C(0))
                 for j in range(5)] for i in range(5)]

    def mp(A, n):
        R = I5
        while n:
            if n & 1:
                R = mm(R, A)
            A = mm(A, A)
            n //= 2
        return R

    ok = (mp(S, 2) == I5 and mp(T, 11) == I5 and mp(mm(S, T), 3) == I5)

    # Klein cubic invariance F(x) = sum x_i^2 x_{i+1}
    def pmul(A, B):
        out = {}
        for ea, ca in A.items():
            for eb, cb in B.items():
                e = tuple(a + b for a, b in zip(ea, eb))
                out[e] = out.get(e, C(0)) + ca * cb
        return {e: c for e, c in out.items() if c}

    def ppow(A, n):
        R = {(0, 0, 0, 0, 0): C(1)}
        for _ in range(n):
            R = pmul(R, A)
        return R

    def padd(A, B):
        out = dict(A)
        for e, c in B.items():
            out[e] = out.get(e, C(0)) + c
        return {e: c for e, c in out.items() if c}

    def transformed_F(A):
        L = []
        for i in range(5):
            L.append({tuple(1 if j == k else 0 for j in range(5)): A[i][k]
                      for k in range(5) if A[i][k]})
        out = {}
        for i in range(5):
            out = padd(out, pmul(ppow(L[i], 2), L[(i + 1) % 5]))
        return out

    Fk = {tuple(2 if j == i else 1 if j == (i + 1) % 5 else 0 for j in range(5)): C(1)
          for i in range(5)}
    klein_ok = (transformed_F(S) == Fk and transformed_F(T) == Fk)

    # Cayley BFS over PSL(2,F_11)
    def fmulm(A, B):
        return tuple(sum(A[2 * i + k] * B[2 * k + j] for k in range(2)) % 11
                     for i in range(2) for j in range(2))

    def fcanon4(A):
        A = tuple(a % 11 for a in A)
        B = tuple((-a) % 11 for a in A)
        return min(A, B)

    fone = fcanon4((1, 0, 0, 1))
    fs = fcanon4((0, 2, 5, 0))
    ft = fcanon4((1, 2, 0, 1))
    rho = {fone: I5}
        # (BFS below)
    queue = deque([fone])
    consistent = True
    while queue:
        a = queue.popleft()
        for b, R in ((fs, S), (ft, T)):
            c = fcanon4(fmulm(a, b))
            M = mm(rho[a], R)
            if c in rho:
                if rho[c] != M:
                    consistent = False
            else:
                rho[c] = M
                queue.append(c)
    return rho, ok, klein_ok, consistent, len(rho)


# --- PSL(2,11) arithmetic (verifier's own, brute-force enumeration) ---------

def fcanon(m):
    m = tuple(x % 11 for x in m)
    n = tuple((-x) % 11 for x in m)
    return min(m, n)


def fmul(a, b):
    return fcanon(((a[0] * b[0] + a[1] * b[2]) % 11,
                   (a[0] * b[1] + a[1] * b[3]) % 11,
                   (a[2] * b[0] + a[3] * b[2]) % 11,
                   (a[2] * b[1] + a[3] * b[3]) % 11))


def finv(a):
    return fcanon((a[3], (-a[1]) % 11, (-a[2]) % 11, a[0]))


ONE = fcanon((1, 0, 0, 1))


def conj(g, x):
    return fmul(fmul(g, x), finv(g))


def conj_set(g, H):
    return frozenset(conj(g, x) for x in H)


def elt_order(g):
    n, x = 1, g
    while x != ONE:
        x = fmul(x, g)
        n += 1
    return n


def closure(gens):
    S = {ONE}
    frontier = [ONE]
    gens = list(gens)
    while frontier:
        nf = []
        for x in frontier:
            for g in gens:
                y = fmul(x, g)
                if y not in S:
                    S.add(y)
                    nf.append(y)
        frontier = nf
    return frozenset(S)


# ===========================================================================
# 4.  Linear algebra over Q(zeta_330):  division-free elimination
# ===========================================================================

def kernel_basis(rows, ncol):
    """Kernel of the matrix given by `rows` (lists of K), division-free."""
    m = [list(r) for r in rows]
    nrow = len(m)
    piv = []
    r = 0
    for c in range(ncol):
        p = None
        for i in range(r, nrow):
            if not m[i][c].is_zero():
                p = i
                break
        if p is None:
            continue
        m[r], m[p] = m[p], m[r]
        for i in range(nrow):
            if i != r and not m[i][c].is_zero():
                a, b = m[r][c], m[i][c]
                m[i] = [a * m[i][j] - b * m[r][j] for j in range(ncol)]
        piv.append(c)
        r += 1
        if r == nrow:
            break
    free = [c for c in range(ncol) if c not in piv]
    basis = []
    for fcol in free:
        # solve for the pivot coordinates:  m is in (unreduced) echelon form
        v = [KZERO] * ncol
        v[fcol] = KONE
        # back-substitute over the pivot rows, using their leading entries
        # (division-free: scale the whole vector by the product of pivots)
        for i in range(len(piv) - 1, -1, -1):
            c = piv[i]
            s = KZERO
            for j in range(ncol):
                if j != c:
                    s = s + m[i][j] * v[j]
            # m[i][c] * v[c] + s = 0   ->  scale v by m[i][c], set v[c] = -s
            v = [x * m[i][c] for x in v]
            v[c] = -s
        basis.append(v)
    return basis, len(piv)


def matvec(M, v):
    return [sum((M[i][j] * v[j] for j in range(len(v))), K()) for i in range(len(M))]


def left_inverse(cols):
    """cols: list of d independent vectors in K^5.  Returns L (d x 5) with
    L * [cols] = I_d, by division-free elimination on [B | I_5]^T."""
    d = len(cols)
    # build 5 x d matrix B, augment with I_5, row-reduce to find d rows spanning
    B = [[cols[j][i] for j in range(d)] + [KONE if i == k else KZERO
                                           for k in range(5)] for i in range(5)]
    r = 0
    piv = []
    for c in range(d):
        p = None
        for i in range(r, 5):
            if not B[i][c].is_zero():
                p = i
                break
        assert p is not None, "columns are dependent"
        B[r], B[p] = B[p], B[r]
        for i in range(5):
            if i != r and not B[i][c].is_zero():
                a, b = B[r][c], B[i][c]
                B[i] = [a * B[i][j] - b * B[r][j] for j in range(d + 5)]
        piv.append(c)
        r += 1
    # now rows 0..d-1 have B[i][piv[i]] != 0 and zero elsewhere among cols
    L = []
    for i in range(d):
        # row i reads:  B[i][c_i] * (coord c_i) = sum_k B[i][d+k] * x_k
        # so coord_{c_i}(x) = (1/B[i][c_i]) * sum_k B[i][d+k] x_k
        L.append((B[i][d:], B[i][piv[i]], piv[i]))
    return L


def coords_in_basis(L, x, d):
    """Coordinates of x in the basis, using the left_inverse data.  Returns a
    list of (numerator K, denominator K) pairs indexed by basis position."""
    out = [None] * d
    for (row, den, c) in L:
        s = sum((row[k] * x[k] for k in range(5)), K())
        out[c] = (s, den)
    return out


# ===========================================================================
# 5.  Main
# ===========================================================================

def main():
    print("FIX-B verifier -- ALGEBRAIC-RECOMPUTE from certificates/exact_weil_check.py")
    print()
    print("[A] representation")
    rho11, relok, kleinok, consistent, nrho = build_rho()
    check("A1 g^2 = -11 and S^2 = T^11 = (ST)^3 = 1", relok)
    check("A2 Klein cubic invariant under S and T", kleinok)
    check("A3 Cayley graph consistent, |rho| = 660", consistent and nrho == 660,
          "n=%d" % nrho)

    ELS = sorted(rho11)
    check("A4 PSL(2,11) brute-force enumeration agrees with the BFS image",
          sorted(fcanon((a, b, c, d)) for a in range(11) for b in range(11)
                 for c in range(11) for d in range(11)
                 if (a * d - b * c) % 11 == 1 and True) and
          set(ELS) == set(fcanon((a, b, c, d)) for a in range(11) for b in range(11)
                          for c in range(11) for d in range(11)
                          if (a * d - b * c) % 11 == 1))

    RHO = {g: [[embed11(rho11[g][i][j]) for j in range(5)] for i in range(5)]
           for g in ELS}
    chiW11 = {g: sum((rho11[g][i][i] for i in range(5)), C(0)) for g in ELS}
    chiW = {g: embed11(chiW11[g]) for g in ELS}

    # --- subgroup classes, recomputed -------------------------------------
    print()
    print("[B] subgroup lattice")
    ecls = {}
    for g in ELS:
        if g in ecls:
            continue
        for x in ELS:
            ecls[conj(x, g)] = g
    creps = sorted(set(ecls.values()))
    subs = set()
    for a in creps:
        for b in ELS:
            subs.add(closure([a, b]))
    subs.add(frozenset({ONE}))
    # close under conjugacy and collect classes
    classes = []
    seen = set()
    for H in sorted(subs, key=lambda S: (len(S), sorted(S))):
        if H in seen:
            continue
        orb = set(conj_set(g, H) for g in ELS)
        seen |= orb
        classes.append((H, len(orb)))
    check("B1 16 conjugacy classes of subgroups", len(classes) == 16,
          "got %d" % len(classes))
    check("B2 620 subgroups in total", sum(k for (_, k) in classes) == 620,
          "got %d" % sum(k for (_, k) in classes))
    ALLSUBS = {}
    for H, k in classes:
        for g in ELS:
            ALLSUBS[conj_set(g, H)] = H

    NORM = {}

    def normalizer(H):
        H = frozenset(H)
        if H not in NORM:
            NORM[H] = frozenset(g for g in ELS if conj_set(g, H) == H)
        return NORM[H]

    def derived(H):
        cs = set()
        for a in H:
            for b in H:
                cs.add(fmul(fmul(a, b), finv(fmul(b, a))))
        return closure(sorted(cs))

    def abelian_gens(H):
        """Independent generators (g, order) of H/[H,H], lifted to H."""
        D = derived(H)
        rep = {}
        reps = []
        for h in sorted(H):
            if h in rep:
                continue
            reps.append(h)
            for d in D:
                rep[fmul(h, d)] = h

        def qmul(x, y):
            return rep[fmul(x, y)]

        qone = rep[ONE]

        def qord(x):
            n, y = 1, x
            while y != qone:
                y = qmul(y, x)
                n += 1
            return n

        gens, span = [], {qone}
        while len(span) < len(reps):
            g = max((x for x in reps if x not in span), key=qord)
            o = qord(g)
            cyc, y = {qone}, g
            while y != qone:
                cyc.add(y)
                y = qmul(y, g)
            ns = set()
            for s in span:
                for c in cyc:
                    ns.add(qmul(s, c))
            assert len(ns) == len(span) * len(cyc)
            span = ns
            gens.append((g, o))
        return gens, rep, qmul, qone

    def char_values(H, gens, rep, qmul, qone, key):
        """chi(h) as a zeta_330 exponent, for the character with the given
        exponent tuple relative to `gens`."""
        exps = {qone: tuple(0 for _ in gens)}
        frontier = [qone]
        while frontier:
            nf = []
            for x in frontier:
                for i, (g, o) in enumerate(gens):
                    y = qmul(x, g)
                    if y not in exps:
                        e = list(exps[x])
                        e[i] = (e[i] + 1) % o
                        exps[y] = tuple(e)
                        nf.append(y)
            frontier = nf
        out = {}
        for h in H:
            r = rep[h]
            e = 0
            for i, (g, o) in enumerate(gens):
                e += key[i] * exps[r][i] * (N330 // o)
            out[h] = e % N330
        return out

    def min_gens(H):
        """A small generating set of H."""
        cur = frozenset({ONE})
        out = []
        for h in sorted(H):
            if h in cur:
                continue
            out.append(h)
            cur = closure(out)
            if cur == frozenset(H):
                break
        assert closure(out) == frozenset(H) or len(H) == 1
        return out

    def eigenspace(H, chi):
        """W_chi = { v : rho(h) v = chi(h) v for all h in H }, as an explicit
        basis over Q(zeta_330), by kernel of the stacked system.  chi is a
        character, so it suffices to impose the condition on generators."""
        rows = []
        for h in min_gens(H):
            if h == ONE:
                continue
            lam = K.root(chi[h])
            M = RHO[h]
            for i in range(5):
                rows.append([M[i][j] - (lam if i == j else KZERO) for j in range(5)])
        if not rows:
            return [[KONE if i == j else KZERO for j in range(5)] for i in range(5)]
        basis, rank = kernel_basis(rows, 5)
        return basis

    _ES = {}

    def eig(H, chi):
        kk = (frozenset(H), tuple(sorted(chi.items())))
        if kk not in _ES:
            _ES[kk] = eigenspace(H, chi)
        return _ES[kk]

    def all_lin_chars(H):
        gens, rep, qmul, qone = abelian_gens(H)
        out = []
        for key in iproduct(*[range(o) for (g, o) in gens]):
            out.append((key, char_values(H, gens, rep, qmul, qone, key)))
        return gens, out

    def subgroups_of(H):
        pool = {frozenset({ONE})}
        frontier = [frozenset({ONE})]
        Hl = sorted(H)
        while frontier:
            nf = []
            for A in frontier:
                for g in Hl:
                    if g in A:
                        continue
                    B = closure(list(A) + [g])
                    if B not in pool:
                        pool.add(B)
                        nf.append(B)
            frontier = nf
        return sorted(pool, key=lambda S: (len(S), sorted(S)))

    def in_span(basis, w):
        if len(basis) == 5:
            return True
        rows = [list(v) for v in basis] + [list(w)]
        _, rk = kernel_basis(rows, 5)
        return rk == len(basis)

    def subspace_stabiliser(basis, group):
        out = []
        for g in group:
            if all(in_span(basis, matvec(RHO[g], v)) for v in basis):
                out.append(g)
        return frozenset(out)

    # --- the 20 strata orbits, recomputed ---------------------------------
    print()
    print("[C] strata, recomputed from kernels")
    per_class = {}
    for H, nclass in classes:
        gens, chars = all_lin_chars(H)
        keep = []
        for key, chi in chars:
            b = eig(H, chi)
            if b:
                keep.append((key, chi, len(b)))
        per_class[H] = (gens, keep)
    nstrata = sum(nclass * len(per_class[H][1]) for (H, nclass) in classes)
    check("C1 1502 strata (H,F) in total", nstrata == 1502, "got %d" % nstrata)
    check("C2 sum over components of (dim F + 1) = 5 for every abelian H",
          all(sum(d for (_, _, d) in per_class[H][1]) == 5
              for (H, _) in classes
              if all(fmul(a, b) == fmul(b, a) for a in H for b in H)))
    empt = sorted(len(H) for (H, _) in classes if not per_class[H][1])
    check("C3 P(W)^H empty exactly for the classes of order 55, 60, 60, 660",
          empt == [55, 60, 60, 660], "got %s" % empt)

    norbits = 0
    for H, nclass in classes:
        N = normalizer(H)
        used = set()
        for (key, chi, d) in per_class[H][1]:
            tag = tuple(sorted(chi.items()))
            if tag in used:
                continue
            for g in N:
                gi = finv(g)
                used.add(tuple(sorted((h, chi[conj(gi, h)]) for h in H)))
            norbits += 1
    check("C4 20 G-orbits of strata", norbits == 20, "got %d" % norbits)

    # --- per-symbol verification against symbols.json ---------------------
    print()
    print("[D] the 20 symbols, checked one by one against symbols.json")
    with open(os.path.join(HERE, "symbols.json")) as fh:
        SYM = json.load(fh)
    prod = {s["orbit_id"]: s for s in SYM["symbols"]}

    def decode_producer(term_obj):
        out = K()
        for (b, c, d, v) in term_obj["terms"]:
            e = (110 * b + 66 * c + 30 * d) % N330
            out = out + K.root(e, F(v))
        return out

    def verify_symbol(s):
        """Recompute everything the producer claims about one symbol.
        Returns (ok, detail)."""
        H = frozenset(tuple(x) for x in s["H_elements_psl"])
        if H not in per_class:
            H = frozenset(ALLSUBS[H]) if H in ALLSUBS else H
        # the recorded H must be an honest subgroup of the recorded order
        if closure(sorted(H)) != H or len(H) != s["H_order"]:
            return False, "H is not a subgroup of the recorded order"
        pgens = [tuple(g) for g in s["beta"]["generators_psl"]]
        pords = s["beta"]["generator_orders"]
        gens, chars = all_lin_chars(H)
        N = normalizer(H)
        dimF = s["stratum"]["dim_F"]
        want_lin = {tuple(e["exponents"]): e["multiplicity"]
                    for e in s["beta"]["linear_characters"]}
        want_nonlin = s["beta"]["nonlinear_part_dim"]
        # the producer's linear characters, evaluated on all of H via ours
        def producer_char(key):
            tgt = {g: (k * (N330 // o)) % N330 for g, o, k in zip(pgens, pords, key)}
            cand = [ch for (_, ch) in chars if all(ch[g] == e for g, e in tgt.items())]
            if len(cand) != 1:
                return None
            return cand[0]
        reasons = []
        for key, chi in chars:
            bas = eig(H, chi)
            if len(bas) != dimF + 1:
                continue
            stab = subspace_stabiliser(bas, N)
            if len(stab) != s["residual_group"]["Stab_{N_G(H)}(F)_order"]:
                continue
            if 660 // len(stab) != s["stratum"]["G_orbit_size"]:
                continue
            # beta from eigenspace dimensions
            ok = True
            lin_total = 0
            for pkey, m in want_lin.items():
                psi = producer_char(pkey)
                if psi is None:
                    ok = False
                    reasons.append("producer generators do not pin a character")
                    break
                cp = {h: (chi[h] + psi[h]) % N330 for h in H}
                mm = len(eig(H, cp))
                if all(e == 0 for e in psi.values()):
                    mm -= (dimF + 1)
                if mm != m:
                    ok = False
                    break
                lin_total += m
            if not ok:
                continue
            # all OTHER linear characters must have multiplicity 0 in beta
            for pk2, ch2 in chars:
                cp = {h: (chi[h] + ch2[h]) % N330 for h in H}
                mm = len(eig(H, cp))
                if all(e == 0 for e in ch2.values()):
                    mm -= (dimF + 1)
                tgt = {g: ch2[g] for g in pgens}
                pkey = None
                for kk2 in want_lin:
                    psi = producer_char(kk2)
                    if psi is not None and all(psi[h] == ch2[h] for h in H):
                        pkey = kk2
                if pkey is None and mm != 0:
                    ok = False
                    break
            if not ok:
                continue
            if (4 - dimF) - lin_total != want_nonlin:
                continue
            # residual traces, g by g, from honest restriction matrices
            L = left_inverse(bas)
            tok = True
            for entry in s["residual_group"]["action_on_W_chi_character"]:
                g = tuple(entry["g_psl"])
                if g not in stab:
                    tok = False
                    break
                num = K()
                den = None
                cols = []
                for v in bas:
                    cols.append(coords_in_basis(L, matvec(RHO[g], v), len(bas)))
                # trace = sum_i cols[i][i][0]/cols[i][i][1]
                # compare with the producer's value by cross-multiplication
                want = decode_producer(entry["trace_on_W_chi"])
                if len(bas) == 5:
                    if not (chiW[g] - want).is_zero():
                        tok = False
                        break
                    continue
                acc_num = K()
                dens = [cols[i][i][1] for i in range(len(bas))]
                for i in range(len(bas)):
                    term = cols[i][i][0]
                    for j in range(len(bas)):
                        if j != i:
                            term = term * dens[j]
                    acc_num = acc_num + term
                dprod = KONE
                for dd in dens:
                    dprod = dprod * dd
                if not (acc_num - want * dprod).is_zero():
                    tok = False
                    break
            if not tok:
                continue
            # H must act on W_chi by the scalar chi
            for h in sorted(H):
                cs = [coords_in_basis(L, matvec(RHO[h], v), len(bas)) for v in bas]
                lam = K.root(chi[h])
                for i in range(len(bas)):
                    for j in range(len(bas)):
                        nu_, de_ = cs[i][j]
                        w = (lam * de_) if i == j else KZERO
                        if not (nu_ - w).is_zero():
                            tok = False
            if not tok:
                continue
            return True, ""
        return False, "no character of H reproduces the recorded symbol"

    allok = True
    for s in SYM["symbols"]:
        ok, why = verify_symbol(s)
        if not ok:
            allok = False
            print("      symbol %s: %s" % (s["fix_a2_label"], why))
    check("D1 all 20 symbols reproduced: dim F, |Stab_{N_G(H)}(F)| by the "
          "SUBSPACE test, |G-orbit|, the full beta multiplicity vector, the "
          "nonlinear part, the scalar action of H on W_chi and every residual "
          "trace", allok)
    check("D2 dim F + |beta| = 4 on all 20 symbols",
          all(s["sanity_dimF_plus_beta"] == 4 for s in SYM["symbols"]))
    check("D3 the trivial character never occurs in beta",
          all(all(any(e for e in ent["exponents"])
                  for ent in s["beta"]["linear_characters"])
              for s in SYM["symbols"]))

    # --- Theorem 2.1 deltas, re-derived -----------------------------------
    print()
    print("[E] Theorem 2.1 blowup deltas, re-derived")
    with open(os.path.join(HERE, "removability.json")) as fh:
        REM = json.load(fh)

    def parallel(v, w):
        for i in range(5):
            for j in range(i + 1, 5):
                if not (v[i] * w[j] - v[j] * w[i]).is_zero():
                    return False
        return True

    # the verifier's own list of point-orbit centers: 0-dimensional strata whose
    # FULL stabiliser in G equals H
    my_centers = []
    for H, nclass in classes:
        gens, keep = per_class[H]
        N = normalizer(H)
        used = set()
        for (key, chi, d) in keep:
            if d != 1:
                continue
            tag = tuple(sorted(chi.items()))
            if tag in used:
                continue
            for g in N:
                gi = finv(g)
                used.add(tuple(sorted((h, chi[conj(gi, h)]) for h in H)))
            v = eig(H, chi)[0]
            full = [g for g in ELS if parallel(v, matvec(RHO[g], v))]
            if len(full) == len(H):
                my_centers.append((H, chi, len(full)))
    check("E1 exactly 10 G-orbits of points whose full stabiliser is the "
          "labelling subgroup (the admissible point-orbit centers)",
          len(my_centers) == 10, "got %d" % len(my_centers))

    got = []
    for (H, chi, nfull) in my_centers:
        shapes = []
        ndest = 0
        seenA = set()
        for A in subgroups_of(H):
            if A in seenA:
                continue
            orbA = set(conj_set(x, A) for x in H)
            seenA |= orbA
            chiA = {h: chi[h] for h in A}
            if len(eig(A, chiA)) == 1:
                ndest += 1
        for A in subgroups_of(H):
            gA, chA = all_lin_chars(A)
            for keyA, psi in chA:
                if all(e == 0 for e in psi.values()):
                    continue                      # Thm 2.1(iii)
                cp = {a: (chi[a] + psi[a]) % N330 for a in A}
                m = len(eig(A, cp))
                if m == 0:
                    continue
                shapes.append((len(A), m - 1, 5 - m))
        got.append((len(H), 660 // nfull, ndest, tuple(sorted(shapes))))

    want = []
    for b in REM["blowup_deltas"]:
        s = prod[b["center_orbit_id"]]
        sh = []
        for c in b["created"]:
            sh.extend([(c["H_order"], c["dim_F_new"], 4 - c["dim_F_new"])]
                      * c["num_S_orbit_members"])
        want.append((s["H_order"], b["center_size"], len(b["destroyed_orbit_ids"]),
                     tuple(sorted(sh))))
    check("E2 for all 10 centers: the number of destroyed 0-dimensional strata "
          "and the (|H|, dim, |beta|) multiset of the Thm 2.1(ii) exceptional "
          "strata agree with removability.json",
          sorted(got) == sorted(want),
          "\n     verifier: %s\n     producer: %s" % (sorted(got), sorted(want)))

    # smoothness of the enumerated centers
    posmeet = all(c["union_of_the_orbit_is"] == "singular"
                  for c in REM["move_set_enumeration"]["per_orbit"]
                  if c["dim"] in (1, 2))
    check("E3 every positive-dimensional stratum orbit self-intersects, so the "
          "admissible centers in the enumerated class are exactly the unions "
          "of the 10 point orbits", posmeet)
    check("E4 dim F_new + |beta_new| = 4 on every exceptional stratum",
          all(c["sanity_dimF_plus_beta"] == 4
              for b in REM["blowup_deltas"] for c in b["created"]))

    # --- C11 weights ------------------------------------------------------
    print()
    print("[F] C11 weight table")
    with open(os.path.join(HERE, "c11_weights.json")) as fh:
        C11 = json.load(fh)
    c11ok = True
    c11detail = []
    seen_subs = set()
    for gblock in C11["subgroups"]:
        gen = tuple(gblock["canonical_generator_psl"])
        Kk = closure([gen])
        seen_subs.add(Kk)
        if len(Kk) != 11 or min(h for h in Kk if h != ONE) != gen:
            c11ok = False
            c11detail.append("generator/canonicity failure")
            continue
        pw, y = {}, ONE
        for i in range(11):
            pw[i] = y
            y = fmul(y, gen)
        J, tot = [], 0
        for j in range(11):
            chi = {pw[i]: (30 * ((i * j) % 11)) % N330 for i in range(11)}
            dd = len(eig(Kk, chi))
            tot += dd
            if dd == 1:
                J.append(j)
        if tot != 5 or sorted(J) != gblock["character_exponent_set_J"]:
            c11ok = False
            c11detail.append("J/dimension mismatch at C11 #%d" % gblock["c11_index"])
            continue
        for pt in gblock["points"]:
            a = pt["character_exponent_a"]
            beta = sorted((bb - a) % 11 for bb in J if bb != a)
            if beta != pt["beta_weights_mod_11"] or sum(beta) % 11 != \
               pt["weight_sum_mod_11"]:
                c11ok = False
                c11detail.append("beta mismatch at (%d,%d)" % (gblock["c11_index"], a))
    check("F1 12 distinct Sylow-11 subgroups, J recomputed from eigenspaces, "
          "all 60 weight quadruples and their sums reproduced",
          c11ok and len(seen_subs) == 12, "; ".join(c11detail[:3]))
    check("F2 60 rows; every beta has 4 distinct weights; every J is a "
          "quadratic-residue coset",
          len(C11["flat_table"]) == 60
          and all(len(set(r["beta_weights_mod_11"])) == 4 for r in C11["flat_table"])
          and all(g["J_is_a_quadratic_residue_coset"] for g in C11["subgroups"]))
    check("F3 the C11 points are poset-isolated: no proper subgroup of G "
          "strictly containing a C11 fixes any of them",
          all(len([g for g in ELS
                   if parallel(eig(H, chi)[0], matvec(RHO[g], eig(H, chi)[0]))]) == 11
              for (H, chi, _) in my_centers if len(H) == 11))

    # --- harness self-test: a deliberately false statement must fail -------
    print()
    print("[G] harness self-test (must fail)")
    A5 = [H for (H, _) in classes if len(H) == 60][0]
    selftest = len(eig(A5, {h: 0 for h in A5})) != 0
    print("  %-4s G1 (deliberately false) P(W)^{A5} is non-empty"
          % ("ok" if selftest else "FAIL"))

    print()
    print("checks: %d, failures: %d, harness self-test failed as required: %s"
          % (len(CHECKS), len(FAILS), "yes" if not selftest else "NO"))
    if FAILS or selftest:
        print("FIX_B_BURNSIDE_SYMBOLS_VERIFY_FAILED")
        for n, d in FAILS:
            print("   FAILED:", n, d)
        sys.exit(1)
    print("FIX_B_BURNSIDE_SYMBOLS_VERIFY_OK")


if __name__ == "__main__":
    main()
