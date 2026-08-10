#!/usr/bin/env python3
"""V14^{S3} and V14^{D10} (and, in the same framework, V14^{A4}, V14^{A5}).

Measures the fixed loci of the nonabelian subgroups S3, D10, A4, A5 of
G = PSL(2,F_11) on the V14 twin of Problem E, exactly and as schemes.

Machinery reused, not rebuilt: the sealed FIX-IX model
(`goal_runs_after_c53d89a/FIX_IX_SEAL/scripts/seal.py`, exit
FIX-IX-SEAL-PASS).  The field layer, the even-Weil generators T6/S6, the
1320-closure, the 10'-isotypic projector on Lambda^2 U and the Pluecker
restriction routine are the seal's; this file adds the subgroup layer.  A
regression block recomputes the sealed sigma-fixed numbers through this
pipeline, so the new numbers are known to come out of the same machine.

Mathematical contract
---------------------
V14 = Gr(2,U) cap P(M), where U is the 6-dimensional even Weil (spin)
representation of SL(2,11) and M is the 10-dimensional 10'-summand of
Lambda^2 U.  G = PSL(2,11) acts on M (Lambda^2 kills -I), and V14 is cut out
of P(M) = P^9 by the 15 Pluecker quadrics restricted to M.

LEMMA (fixed loci split by character).  For a finite subgroup H <= G acting
linearly on M, in characteristic 0 or characteristic prime to |H|,

    P(M)^H  =  | |_chi  P(M_chi),   M_chi = {m : h.m = chi(h) m for all h},

the disjoint union over the linear characters chi of H, AS SCHEMES; hence

    V14^H  =  | |_chi  ( V14 cap P(M_chi) ),

each piece cut out by the 15 Pluecker quadrics restricted to M_chi.
(Proof: a point [m] is H-fixed iff the line k.m is H-stable iff H acts on it
by a linear character.  Scheme-theoretically, the fixed locus of a single
diagonalisable g is V(2x2 minors of [v ; g.v]), and in eigencoordinates that
ideal is ((lam_i - lam_j) x_i x_j), the radical ideal of the union of the
eigen-subspaces; intersecting over generators gives the joint eigenspaces.)

Linear characters used: S3 -> {triv, sign}; D10 -> {triv, sign};
A5 -> {triv}; A4 -> {triv, omega, omega^2}.  The two omega-characters of A4
are handled WITHOUT adjoining zeta_3: they live in the rational
2-dimensional A4-stable plane N = M^{V4} / M^{A4}, and inside P(N) = P^1 the
two eigenpoints are cut by the rational binary quadratic det[v ; r.v].

Emptiness is certified twice, independently:
  (1) RANK CERTIFICATE (this file, exact, every mode): if the restricted
      quadrics span the whole space of quadratic forms on M_chi, the ideal
      contains every quadric, so its saturation is the unit ideal and
      V14 cap P(M_chi) is empty as a scheme.
  (2) MACAULAY2 (emitted drivers): saturate(I, irrelevant) == ideal 1, with
      dim / degree / primaryDecomposition whenever a locus is nonempty; plus
      the definition-level check in the ambient P^9,
          I_V14 + minors(2, {{x},{g.x}}) + minors(2, {{x},{h.x}}),
      for H = <g,h>, which never uses the character decomposition at all.

Verification standard (matches FIX-IX-SEAL): exact characteristic 0 over
K = Q(z)/Phi_11 AND two independent primes p = 397, 199 (p = 1 mod 11), with
a third prime 353 as an end-to-end replay.

Usage
-----
    python3 verify_v14_s3_d10.py              # all modes, python + Macaulay2
    python3 verify_v14_s3_d10.py 397          # one mode
    python3 verify_v14_s3_d10.py --no-m2      # skip Macaulay2
    python3 verify_v14_s3_d10.py --no-ambient # skip the P^9 cross-check

The ambient-P^9 cross-check (105 quadrics in 10 variables) is on by default in
every mode.  Over K it dominates the runtime -- about a quarter of an hour --
while the character-piece computation, which is already the complete
scheme-theoretic answer there, takes seconds; `--no-ambient` drops it.
"""
import os
import subprocess
import sys
from fractions import Fraction
from itertools import combinations

HERE = os.path.dirname(os.path.abspath(__file__))
OUTDIR = os.path.join(HERE, "v14_fixed")
ALLMODES = ["397", "199", "353", "K"]

PAIRS = list(combinations(range(6), 2))     # Lambda^2 basis, lex
QUADS = list(combinations(range(6), 4))     # Lambda^4 basis, lex

# expected subgroup inventory of PSL(2,11) (Dickson); asserted below
EXPECTED = {"S3": (110, [55, 55]), "D10": (66, [66]),
            "A4": (55, [55]), "A5": (22, [11, 11])}


def perm_sign(P):
    s = 1
    P = list(P)
    for i in range(len(P)):
        for j in range(i + 1, len(P)):
            if P[i] > P[j]:
                s = -s
    return s


class Model(object):
    """The sealed V14 model over F_p (p = 1 mod 11) or K = Q(z)/Phi_11."""

    def __init__(self, mode, check):
        self.mode = mode
        self.CHECK = check
        self._field()
        self._weil()
        self._groupindex()
        self._Mspace()

    # ------------------------------------------------------------------
    # field layer (verbatim in structure from FIX_IX_SEAL/scripts/seal.py)
    # ------------------------------------------------------------------
    def _field(self):
        mode = self.mode
        if mode == "K":
            def nf(c):
                return tuple(c)
            self.ZERO = nf([Fraction(0)] * 10)
            self.ONE = nf([Fraction(1)] + [Fraction(0)] * 9)

            def fadd(a, b):
                return nf([x + y for x, y in zip(a, b)])

            def fsub(a, b):
                return nf([x - y for x, y in zip(a, b)])

            def fneg(a):
                return nf([-x for x in a])

            def fmul(a, b):
                c = [Fraction(0)] * 19
                for i, x in enumerate(a):
                    if x:
                        for j, y in enumerate(b):
                            if y:
                                c[i + j] += x * y
                for k in range(18, 9, -1):
                    if c[k]:
                        v = c[k]
                        c[k] = Fraction(0)
                        for t in range(k - 10, k):
                            c[t] -= v
                return nf(c[:10])

            def fisz(a):
                return all(x == 0 for x in a)

            def finv(a):
                phi = [Fraction(1)] * 11

                def deg(P):
                    d = len(P) - 1
                    while d >= 0 and P[d] == 0:
                        d -= 1
                    return d

                def pm(P, Q):
                    R = [Fraction(0)] * (len(P) + len(Q) - 1)
                    for i, x in enumerate(P):
                        if x:
                            for j, y in enumerate(Q):
                                if y:
                                    R[i + j] += x * y
                    return R

                def ps(P, Q):
                    n = max(len(P), len(Q))
                    R = [Fraction(0)] * n
                    for i, x in enumerate(P):
                        R[i] += x
                    for i, y in enumerate(Q):
                        R[i] -= y
                    return R

                r0, r1 = phi[:], list(a)
                s0, s1 = [Fraction(0)], [Fraction(1)]
                while deg(r1) >= 0:
                    d0, d1 = deg(r0), deg(r1)
                    if d0 < d1:
                        r0, r1, s0, s1 = r1, r0, s1, s0
                        continue
                    q = [Fraction(0)] * (d0 - d1) + [r0[d0] / r1[d1]]
                    r0 = ps(r0, pm(q, r1))
                    s0 = ps(s0, pm(q, s1))
                    if deg(r0) < deg(r1):
                        r0, r1, s0, s1 = r1, r0, s1, s0
                c0 = r0[deg(r0)]
                inv = [x / c0 for x in s0] + [Fraction(0)] * 11
                red = [Fraction(0)] * 19
                for i, x in enumerate(inv[:19]):
                    red[i] = x
                for k in range(18, 9, -1):
                    if red[k]:
                        v = red[k]
                        red[k] = Fraction(0)
                        for t in range(k - 10, k):
                            red[t] -= v
                return nf(red[:10])

            Z = nf([Fraction(0), Fraction(1)] + [Fraction(0)] * 8)

            def zpow(k):
                k = k % 11
                r = self.ONE
                for _ in range(k):
                    r = fmul(r, Z)
                return r

            def fint(n):
                return nf([Fraction(n)] + [Fraction(0)] * 9)

            def fstr(a):
                terms = []
                for i, x in enumerate(a):
                    if x:
                        terms.append("(%d/%d)" % (x.numerator, x.denominator)
                                     + ("" if i == 0 else "*z^%d" % i))
                return "+".join(terms) if terms else "0"

            self.header = ("kk = toField(QQ[z]/(z^10+z^9+z^8+z^7+z^6+z^5"
                           "+z^4+z^3+z^2+z+1));\n")
            self.charzero = True
        else:
            p = int(mode)
            assert p % 11 == 1, "need p = 1 mod 11"
            self.ZERO, self.ONE = 0, 1

            def fadd(a, b):
                return (a + b) % p

            def fsub(a, b):
                return (a - b) % p

            def fneg(a):
                return (-a) % p

            def fmul(a, b):
                return (a * b) % p

            def fisz(a):
                return a % p == 0

            def finv(a):
                return pow(a, p - 2, p)

            g11 = next(t for t in range(2, p) if pow(t, 11, p) == 1 and t != 1)

            def zpow(k):
                return pow(g11, k % 11, p)

            def fint(n):
                return n % p

            def fstr(a):
                return str(a % p)

            self.header = "kk = ZZ/%d;\n" % p
            self.charzero = False
        self.fadd, self.fsub, self.fneg, self.fmul = fadd, fsub, fneg, fmul
        self.fisz, self.finv, self.zpow = fisz, finv, zpow
        self.fint, self.fstr = fint, fstr

    def frac(self, n, d=1):
        return self.fmul(self.fint(n), self.finv(self.fint(d)))

    # ------------------------------------------------------------------
    # linear algebra
    # ------------------------------------------------------------------
    def dot(self, r, c):
        s = self.ZERO
        for x, y in zip(r, c):
            if not self.fisz(x) and not self.fisz(y):
                s = self.fadd(s, self.fmul(x, y))
        return s

    def mmul(self, A, B):
        n = len(A)
        Bt = list(zip(*B))
        return tuple(tuple(self.dot(A[i], Bt[j]) for j in range(n))
                     for i in range(n))

    def meye(self, n=6):
        return tuple(tuple(self.ONE if i == j else self.ZERO
                           for j in range(n)) for i in range(n))

    def mneg(self, A):
        return tuple(tuple(self.fneg(x) for x in r) for r in A)

    def echelon(self, rows):
        R = [list(r) for r in rows]
        piv = []
        rr = 0
        ncol = len(R[0]) if R else 0
        for cidx in range(ncol):
            pr = next((r for r in range(rr, len(R))
                       if not self.fisz(R[r][cidx])), None)
            if pr is None:
                continue
            R[rr], R[pr] = R[pr], R[rr]
            iv = self.finv(R[rr][cidx])
            R[rr] = [self.fmul(iv, x) for x in R[rr]]
            for r in range(len(R)):
                if r != rr and not self.fisz(R[r][cidx]):
                    fct = R[r][cidx]
                    R[r] = [self.fsub(x, self.fmul(fct, y))
                            for x, y in zip(R[r], R[rr])]
            piv.append(cidx)
            rr += 1
            if rr == len(R):
                break
        return [tuple(r) for r in R[:rr]], piv

    def rank(self, rows):
        if not rows:
            return 0
        return len(self.echelon(rows)[0])

    # ------------------------------------------------------------------
    # even Weil representation and the 1320-closure (seal's layer 1)
    # ------------------------------------------------------------------
    def _weil(self):
        f = self
        gauss = f.ZERO
        for k in range(11):
            gauss = f.fadd(gauss, f.zpow(k * k))
        f.CHECK("gauss_sq_m11",
                f.fisz(f.fadd(f.fmul(gauss, gauss), f.fint(11))),
                "gauss^2 = -11")
        c = f.finv(gauss)
        T6 = tuple(tuple((f.zpow(j * j) if i == j else f.ZERO)
                         for j in range(6)) for i in range(6))

        def cosentry(i, j):
            if j == 0:
                return c
            return f.fmul(c, f.fadd(f.zpow(i * j), f.zpow(-i * j)))

        S6 = tuple(tuple(cosentry(i, j) for j in range(6)) for i in range(6))
        f.CHECK("S_sq_minusI", f.mmul(S6, S6) == f.mneg(f.meye()), "S^2 = -I")
        self.gens6 = (T6, S6)
        # BFS closure, recording the right-multiplication permutations and a
        # word for every element: all later group theory is index arithmetic
        I6 = f.meye()
        idx = {I6: 0}
        elts = [I6]
        word = [()]
        perm = [[None] * 1, [None] * 1]
        frontier = [0]
        while frontier:
            nxt = []
            for i in frontier:
                for g, G in enumerate(self.gens6):
                    N = f.mmul(elts[i], G)
                    j = idx.get(N)
                    if j is None:
                        j = len(elts)
                        idx[N] = j
                        elts.append(N)
                        word.append(word[i] + (g,))
                        perm[0].append(None)
                        perm[1].append(None)
                        nxt.append(j)
                    perm[g][i] = j
            frontier = nxt
            assert len(elts) <= 1400
        f.CHECK("group_order_SL", len(elts) == 1320,
                "|<T6,S6>| = %d" % len(elts))
        self.elts, self.idx, self.word, self.perm = elts, idx, word, perm

    def gmul(self, i, j):
        for g in self.word[j]:
            i = self.perm[g][i]
        return i

    def gpow(self, i, k):
        r = 0
        for _ in range(k):
            r = self.gmul(r, i)
        return r

    def ginv(self, i):
        j = i
        while self.gmul(j, i) != 0:
            j = self.gmul(j, i)
        return j

    # ------------------------------------------------------------------
    # projective group PSL(2,11) and its subgroup lattice, by index
    # ------------------------------------------------------------------
    def _groupindex(self):
        f = self
        self.mI = self.idx[f.mneg(f.meye())]
        self.neg = [self.gmul(i, self.mI) for i in range(len(self.elts))]
        self.pk = [min(i, self.neg[i]) for i in range(len(self.elts))]
        PSL = sorted(set(self.pk))
        f.CHECK("PSL_order", len(PSL) == 660, "|G| = %d" % len(PSL))
        self.PSL = PSL
        self.PID = self.pk[0]

        def pmul(a, b):
            return self.pk[self.gmul(a, b)]

        self.pmul = pmul

        def porder(a):
            k, x = 1, a
            while x != self.PID:
                x = pmul(x, a)
                k += 1
            return k

        self.PORD = {a: porder(a) for a in PSL}
        prof = {}
        for a in PSL:
            prof[self.PORD[a]] = prof.get(self.PORD[a], 0) + 1
        f.CHECK("PSL_order_profile",
                prof == {1: 1, 2: 55, 3: 110, 5: 264, 6: 110, 11: 120},
                "projective order counts %s" % sorted(prof.items()))

        def pinv(a):
            b = a
            while pmul(b, a) != self.PID:
                b = pmul(b, a)
            return b

        self.pinv = pinv

    def closure(self, gens, cap=660):
        S = {self.PID}
        frontier = [self.PID]
        while frontier:
            nxt = []
            for a in frontier:
                for g in gens:
                    b = self.pmul(a, g)
                    if b not in S:
                        S.add(b)
                        nxt.append(b)
            frontier = nxt
            if len(S) > cap:
                break
        return frozenset(S)

    def subgroup_lattice(self):
        """All S3, D10, A4, A5 subgroups of G, grouped into G-classes."""
        f = self
        invs = [a for a in self.PSL if self.PORD[a] == 2]
        o3 = [a for a in self.PSL if self.PORD[a] == 3]
        o5 = [a for a in self.PSL if self.PORD[a] == 5]
        # one generator per cyclic subgroup
        c3, c5 = [], []
        seen3, seen5 = set(), set()
        for a in o3:
            if a not in seen3:
                c3.append(a)
                seen3 |= set(self.closure([a]))
        for a in o5:
            if a not in seen5:
                c5.append(a)
                seen5 |= set(self.closure([a]))
        f.CHECK("cyclic_counts", (len(c3), len(c5)) == (55, 66),
                "C3 subgroups %d, C5 subgroups %d" % (len(c3), len(c5)))
        found = {"S3": {}, "D10": {}, "A4": {}, "A5": {}}
        for r in c3:
            for s in invs:
                S = self.closure([r, s], cap=12)
                n = len(S)
                ninv = sum(1 for x in S if self.PORD[x] == 2)
                if n == 6 and ninv == 3:            # S3 (ninv == 1 is C6)
                    found["S3"].setdefault(S, (r, s))
                elif n == 12 and all(self.PORD[x] != 6 for x in S):
                    found["A4"].setdefault(S, (r, s))
        for r in c5:
            for s in invs:
                S = self.closure([r, s], cap=60)
                n = len(S)
                if n == 10:
                    found["D10"].setdefault(S, (r, s))
                elif n == 60:
                    found["A5"].setdefault(S, (r, s))
        gens = [self.pk[self.idx[self.gens6[0]]],
                self.pk[self.idx[self.gens6[1]]]]
        out = {}
        for nm, d in found.items():
            subs = list(d.keys())
            index = {S: i for i, S in enumerate(subs)}
            unseen = set(range(len(subs)))
            cls = []
            while unseen:
                i0 = min(unseen)
                orb = {i0}
                frontier = [i0]
                while frontier:
                    nxt = []
                    for i in frontier:
                        S = subs[i]
                        for g in gens:
                            gi = self.pinv(g)
                            T = frozenset(self.pmul(self.pmul(g, x), gi)
                                          for x in S)
                            j = index[T]
                            if j not in orb:
                                orb.add(j)
                                nxt.append(j)
                    frontier = nxt
                cls.append(sorted(orb))
                unseen -= orb
            n_exp, cls_exp = EXPECTED[nm]
            f.CHECK("lattice_%s" % nm,
                    len(subs) == n_exp
                    and sorted(len(x) for x in cls) == sorted(cls_exp),
                    "%d subgroups in G-classes %s (expected %d, %s)"
                    % (len(subs), [len(x) for x in cls], n_exp, cls_exp))
            out[nm] = (subs, d, cls)
        return out

    # ------------------------------------------------------------------
    # Lambda^2 and the 10-dimensional target space M
    # ------------------------------------------------------------------
    def lam2(self, M):
        f = self
        return tuple(tuple(f.fsub(f.fmul(M[i][k], M[j][l]),
                                  f.fmul(M[i][l], M[j][k]))
                           for (k, l) in PAIRS) for (i, j) in PAIRS)

    def L2(self, a):
        """Lambda^2 of (a lift of) the projective element a; cached."""
        v = self._l2cache.get(a)
        if v is None:
            v = self.lam2(self.elts[a])
            self._l2cache[a] = v
        return v

    def _Mspace(self):
        f = self
        self._l2cache = {}
        CHIV = {1: f.frac(10), 2: f.frac(2), 3: f.frac(1), 5: f.ZERO,
                6: f.frac(-1), 11: f.frac(-1)}
        PM = [[f.ZERO] * 15 for _ in range(15)]
        for a in self.PSL:
            w = CHIV[self.PORD[a]]
            if f.fisz(w):
                continue
            L2 = self.L2(a)
            for i in range(15):
                Li = L2[i]
                for j in range(15):
                    if not f.fisz(Li[j]):
                        PM[i][j] = f.fadd(PM[i][j], f.fmul(w, Li[j]))
        # the seal averages over all 1320 lifts; Lambda^2(-g) = Lambda^2(g),
        # so summing over the 660 projective classes halves the count
        scale = f.fmul(f.frac(10), f.finv(f.frac(660)))
        PM = [[f.fmul(scale, x) for x in row] for row in PM]
        MB, piv = f.echelon([tuple(PM[i][j] for i in range(15))
                             for j in range(15)])
        f.CHECK("M_rank10", len(MB) == 10,
                "rank of the 10'-isotypic projector = %d" % len(MB))
        ok = all(tuple(f.dot(PM[i], list(m)) for i in range(15)) == m
                 for m in MB)
        f.CHECK("PM_idempotent_on_M", ok,
                "the projector fixes its column space pointwise")
        self.MB, self.MBpiv = MB, piv

    def coords(self, v):
        """Coordinates of v in M in the (row-reduced) basis MB."""
        return tuple(v[c] for c in self.MBpiv)

    def act_on_M(self, a):
        """10x10 matrix of the projective element a acting on M, MB basis."""
        f = self
        L2 = self.L2(a)
        cols = []
        for m in self.MB:
            im = tuple(f.dot(L2[i], list(m)) for i in range(15))
            cv = self.coords(im)
            rec = [f.ZERO] * 15
            for ci, b in zip(cv, self.MB):
                if not f.fisz(ci):
                    for j in range(15):
                        rec[j] = f.fadd(rec[j], f.fmul(ci, b[j]))
            assert tuple(rec) == im, "M is not G-stable: model error"
            cols.append(cv)
        return tuple(tuple(cols[j][i] for j in range(10)) for i in range(10))

    def char_piece(self, elts, chi):
        """Basis of {m in M : g.m = chi(g) m for all g}, Lambda^2 coords."""
        f = self
        R = [[f.ZERO] * 15 for _ in range(15)]
        for a in elts:
            cv = chi[a]
            L2 = self.L2(a)
            for i in range(15):
                Li = L2[i]
                for j in range(15):
                    if not f.fisz(Li[j]):
                        v = Li[j] if cv > 0 else f.fneg(Li[j])
                        R[i][j] = f.fadd(R[i][j], v)
        sc = f.finv(f.frac(len(elts)))
        R = [[f.fmul(sc, x) for x in row] for row in R]
        vecs = [tuple(f.dot(R[i], list(m)) for i in range(15))
                for m in self.MB]
        V, _ = f.echelon(vecs)
        return V

    def restrict_quads(self, B):
        """The 15 Pluecker quadrics restricted to span(B)."""
        f = self
        n = len(B)

        def wedge22(a, b):
            if set(a) & set(b):
                return None
            s = tuple(sorted(set(a) | set(b)))
            return (QUADS.index(s), perm_sign(list(a) + list(b)))

        Q = [dict() for _ in range(15)]
        for i in range(n):
            for j in range(i, n):
                acc = {}
                for a in range(15):
                    if f.fisz(B[i][a]):
                        continue
                    for b in range(15):
                        if f.fisz(B[j][b]):
                            continue
                        w = wedge22(PAIRS[a], PAIRS[b])
                        if w is None:
                            continue
                        Kx, sgn = w
                        v = f.fmul(B[i][a], B[j][b])
                        if sgn < 0:
                            v = f.fneg(v)
                        acc[Kx] = f.fadd(acc.get(Kx, f.ZERO), v)
                mult = f.frac(2) if i != j else f.ONE
                for Kx, v in acc.items():
                    vv = f.fmul(mult, v)
                    if not f.fisz(vv):
                        Q[Kx][(i, j)] = vv
        return Q

    def quad_rows(self, Q, n):
        mon = [(i, j) for i in range(n) for j in range(i, n)]
        rows = [tuple(Q[Kx].get(m, self.ZERO) for m in mon)
                for Kx in range(15)]
        return rows, mon

    def eig_quadric(self, B, r):
        """The binary quadratic det[v ; r.v] on a 2-dimensional space B."""
        f = self
        L2 = self.L2(r)
        _, piv = f.echelon(list(B))
        cols = []
        for b in B:
            im = tuple(f.dot(L2[i], list(b)) for i in range(15))
            cols.append(tuple(im[c] for c in piv))
        A = [[cols[j][i] for j in range(2)] for i in range(2)]
        return (A[1][0], f.fsub(A[1][1], A[0][0]), f.fneg(A[0][1]))

    def m2quads(self, Q, var):
        out = []
        for Kx in range(15):
            terms = ["(%s)*%s%d*%s%d" % (self.fstr(cf), var, i, var, j)
                     for (i, j), cf in sorted(Q[Kx].items())]
            out.append("+".join(terms) if terms else "0")
        return out


# ----------------------------------------------------------------------
def linear_characters(nm, S, gen, mdl):
    """The rational (+-1-valued) linear characters of S."""
    r, s = gen
    if nm in ("S3", "D10"):
        rot = mdl.closure([r])
        return [("triv", {a: 1 for a in S}),
                ("sign", {a: (1 if a in rot else -1) for a in S})]
    if nm in ("A4", "A5"):
        return [("triv", {a: 1 for a in S})]
    raise ValueError(nm)


def measure(mdl, lattice, CHECK):
    """All character pieces of all subgroup classes, with rank certificates."""
    f = mdl
    out = []
    for nm in ("S3", "D10", "A4", "A5"):
        subs, gend, cls = lattice[nm]
        for ci, orb in enumerate(cls):
            S = subs[orb[0]]
            gen = gend[S]
            tag = "%s_c%d" % (nm, ci)
            pieces = [(cname, mdl.char_piece(list(S), chi))
                      for cname, chi in linear_characters(nm, S, gen, mdl)]
            if nm == "A4":
                V4 = frozenset(a for a in S if mdl.PORD[a] in (1, 2))
                W = mdl.char_piece(list(V4), {a: 1 for a in V4})
                CHECK("A4_dims_%s" % tag,
                      (len(W), len(pieces[0][1])) == (4, 2),
                      "dim M^{V4} = %d, dim M^{A4} = %d (character theory: 4, 2)"
                      % (len(W), len(pieces[0][1])))
                comp = []
                for w in W:
                    acc = [f.ZERO] * 15
                    for a in S:
                        L2 = mdl.L2(a)
                        im = tuple(f.dot(L2[i], list(w)) for i in range(15))
                        for j in range(15):
                            acc[j] = f.fadd(acc[j], im[j])
                    sc = f.finv(f.frac(len(S)))
                    acc = [f.fmul(sc, x) for x in acc]
                    comp.append(tuple(f.fsub(w[j], acc[j]) for j in range(15)))
                N, _ = f.echelon(comp)
                CHECK("A4_omega_plane_%s" % tag, len(N) == 2,
                      "dim (M^{V4} / M^{A4}) = %d (expected 2)" % len(N))
                pieces.append(("omegapair", N))
            data = []
            for cname, B in pieces:
                n = len(B)
                rec = {"piece": cname, "n": n, "B": B, "extra": None}
                if n:
                    Q = mdl.restrict_quads(B)
                    rows, mon = mdl.quad_rows(Q, n)
                    if cname == "omegapair":
                        eq = mdl.eig_quadric(B, gen[0])
                        rec["extra"] = eq
                        rows = rows + [eq]
                    rec["Q"] = Q
                    rec["rank"] = f.rank(rows)
                    rec["full"] = len(mon)
                else:
                    rec["Q"] = None
                    rec["rank"] = 0
                    rec["full"] = 0
                data.append(rec)
            out.append({"name": nm, "class": ci, "tag": tag, "S": S,
                        "gen": gen, "orbit": len(orb), "pieces": data})
    return out




# ----------------------------------------------------------------------
# what the answer is: asserted identically in every mode
# ----------------------------------------------------------------------
# key: (subgroup, character piece)
#   dim   = dim M_chi = <Res_H chi_{10'}, chi>, from the character table
#   verdict: "empty", or ("points", d) = d reduced points
#            (Macaulay2 affine dim 1, degree d, radical, d components)
EXPECT_PIECE = {
    ("S3", "triv"): (3, ("points", 2)),
    ("S3", "sign"): (1, "empty"),
    ("D10", "triv"): (2, "empty"),
    ("D10", "sign"): (0, "empty"),
    ("A4", "triv"): (2, ("points", 1)),
    ("A4", "omegapair"): (2, "empty"),
    ("A5", "triv"): (1, "empty"),
}
# the whole fixed locus V14^H, checked again in the ambient P^9 from the
# definition (2x2 minors of [x ; g.x]), with no character theory
EXPECT_LOCUS = {"S3": ("points", 2), "D10": "empty",
                "A4": ("points", 1), "A5": "empty"}


def emit_m2(mdl, results, mode, sigma_pieces, ambient=True):
    """Write the Macaulay2 driver for this mode."""
    lines = [mdl.header]
    # --- regression against FIX-IX-SEAL: the sigma fixed locus, and V14 ---
    for nm, B, var in (("SIGPLUS", sigma_pieces[0], "x"),
                       ("SIGMINUS", sigma_pieces[1], "y")):
        n = len(B)
        Q = mdl.restrict_quads(B)
        vs = ",".join("%s%d" % (var, i) for i in range(n))
        lines.append("R%s = kk[%s];" % (nm, vs))
        lines.append("I%s = ideal(%s);" % (nm, ",".join(mdl.m2quads(Q, var))))
        lines.append("J%s = saturate(I%s, ideal vars R%s);" % (nm, nm, nm))
        lines.append('<< "REG %s dim " << dim J%s << " degree " '
                     '<< degree J%s << endl;' % (nm, nm, nm))
    # --- the character pieces ---
    for r in results:
        tag = r["tag"]
        for rec in r["pieces"]:
            n = rec["n"]
            lbl = "%s_%s" % (tag, rec["piece"])
            vn = lbl.replace("_", "")
            if n == 0:
                lines.append('<< "PIECE %s ndim 0" << endl;' % lbl)
                lines.append('<< "PIECE %s empty true" << endl;' % lbl)
                continue
            vs = ",".join("t%d" % i for i in range(n))
            R, I = "R%s" % vn, "I%s" % vn
            lines.append("%s = kk[%s];" % (R, vs))
            gl = mdl.m2quads(rec["Q"], "t")
            if rec["extra"] is not None:
                c00, c01, c11 = rec["extra"]
                gl = gl + ["(%s)*t0*t0+(%s)*t0*t1+(%s)*t1*t1"
                           % (mdl.fstr(c00), mdl.fstr(c01), mdl.fstr(c11))]
            lines.append("%s = ideal(%s);" % (I, ",".join(gl)))
            lines.append("%ss = saturate(%s, ideal vars %s);" % (I, I, R))
            lines.append('<< "PIECE %s ndim %d" << endl;' % (lbl, n))
            lines.append('<< "PIECE %s empty " << (%ss == ideal(1_%s)) '
                         '<< endl;' % (lbl, I, R))
            lines.append('if %ss != ideal(1_%s) then (' % (I, R))
            lines.append('  << "PIECE %s dim " << dim %ss << " degree " '
                         '<< degree %ss << endl;' % (lbl, I, I))
            # smoothness of a 0-dimensional scheme = reducedness, and it is
            # available over K where radical / primaryDecomposition are not
            lines.append('  jc%s = %ss + minors(codim %ss, jacobian %ss);'
                         % (vn, I, I, I))
            lines.append('  << "PIECE %s smooth " '
                         '<< (saturate(jc%s, ideal vars %s) == ideal(1_%s)) '
                         '<< endl;' % (lbl, vn, R, R))
            if not mdl.charzero:
                lines.append('  << "PIECE %s radical " << (%ss == radical %ss) '
                             '<< endl;' % (lbl, I, I))
                lines.append('  cm%s = primaryDecomposition %ss;' % (vn, I))
                lines.append('  << "PIECE %s ncomp " << #cm%s << endl;'
                             % (lbl, vn))
                lines.append('  scan(cm%s, c -> << "PIECE %s comp dim " '
                             '<< dim c << " degree " << degree c << endl);'
                             % (vn, lbl))
            lines.append(');')
    # --- the definition-level computation in the ambient P^9 ---
    lines.append("R9 = kk[x0,x1,x2,x3,x4,x5,x6,x7,x8,x9];")
    lines.append("xv = matrix{{x0,x1,x2,x3,x4,x5,x6,x7,x8,x9}};")
    Qfull = mdl.restrict_quads(mdl.MB)
    lines.append("IV14 = ideal(%s);" % ",".join(mdl.m2quads(Qfull, "x")))
    lines.append("IV14s = saturate(IV14, ideal vars R9);")
    lines.append('<< "REG V14 dim " << dim IV14s << " degree " '
                 '<< degree IV14s << endl;')
    for r in results:
        if not ambient:
            break
        tag = r["tag"]
        vn = tag.replace("_", "")
        mats = []
        for k, a in enumerate(r["gen"]):
            A = mdl.act_on_M(a)
            rows = ",".join("{" + ",".join(mdl.fstr(A[i][j])
                                           for j in range(10)) + "}"
                            for i in range(10))
            nm = "A%s%d" % (vn, k)
            lines.append("%s = matrix{%s};" % (nm, rows))
            mats.append(nm)
        lines.append("IF%s = IV14 + %s;"
                     % (vn, " + ".join("minors(2, xv || (xv * transpose %s))"
                                       % m for m in mats)))
        lines.append("IF%ss = saturate(IF%s, ideal vars R9);" % (vn, vn))
        lines.append('<< "AMBIENT %s empty " << (IF%ss == ideal(1_R9)) '
                     '<< endl;' % (tag, vn))
        lines.append('if IF%ss != ideal(1_R9) then ('
                     '<< "AMBIENT %s dim " << dim IF%ss << " degree " '
                     '<< degree IF%ss << endl;' % (vn, tag, vn, vn))
        lines.append('  jf%s = IF%ss + minors(codim IF%ss, jacobian IF%ss);'
                     % (vn, vn, vn, vn))
        lines.append('  << "AMBIENT %s smooth " '
                     '<< (saturate(jf%s, ideal vars R9) == ideal(1_R9)) '
                     '<< endl;);' % (tag, vn))
    lines.append('<< "M2 DONE" << endl;')
    path = os.path.join(OUTDIR, "m2_v14fixed_%s.m2" % mode)
    with open(path, "w") as fh:
        fh.write("\n".join(lines) + "\n")
    return path


def run_m2(path, timeout=14400):
    out = subprocess.run(["M2", "--script", path], capture_output=True,
                         text=True, timeout=timeout)
    return out.stdout + out.stderr


def verdict_lines(m2out, kind, lbl):
    return [l.strip() for l in m2out.splitlines()
            if l.strip().startswith("%s %s " % (kind, lbl))]


def check_verdict(CHECK, m2out, kind, lbl, want, extra=""):
    """Assert the Macaulay2 verdict for one locus against EXPECT_*."""
    got = verdict_lines(m2out, kind, lbl)
    txt = " | ".join(got)
    if want == "empty":
        ok = ("%s %s empty true" % (kind, lbl)) in m2out
        CHECK("m2_%s_%s" % (kind.lower(), lbl), ok,
              "EMPTY as a scheme (saturation = unit ideal)%s" % extra
              if ok else "expected empty, got: %s" % txt)
        return ok
    _, d = want
    ok = (("%s %s empty false" % (kind, lbl)) in m2out
          and ("%s %s dim 1 degree %d" % (kind, lbl, d)) in m2out
          and ("%s %s smooth true" % (kind, lbl)) in m2out)
    ncomp = None
    for l in got:
        w = l.split()
        if "ncomp" in w:
            ncomp = int(w[w.index("ncomp") + 1])
    CHECK("m2_%s_%s" % (kind.lower(), lbl), ok,
          ("%d reduced points over the algebraic closure (affine dim 1, "
           "degree %d, radical; %s over this field)%s"
           % (d, d, "split into %d rational points" % ncomp if ncomp == d
              else ("one closed point of degree %d" % d if ncomp == 1
                    else "primary decomposition not run here"), extra)) if ok
          else "expected %d points, got: %s" % (d, txt))
    return ok


# ----------------------------------------------------------------------
def fp_points_and_stabilisers(mdl, results, CHECK):
    """At a prime: find the F_p-points of each nonempty piece and measure
    their G-stabilisers directly (independent of the subgroup lattice)."""
    f = mdl
    p = int(mdl.mode)
    for r in results:
        want = EXPECT_LOCUS[r["name"]]
        if want == "empty":
            continue
        for rec in r["pieces"]:
            if rec["n"] < 2 or rec["rank"] == rec["full"]:
                continue
            n, Q = rec["n"], rec["Q"]
            qs = []
            for Kx in range(15):
                if Q[Kx]:
                    qs.append(sorted(Q[Kx].items()))
            pts = []
            # projective points of P^{n-1}(F_p), normalised first-nonzero = 1
            def gen_pts(n):
                for lead in range(n):
                    for rest in range(p ** (n - 1 - lead)):
                        v = [0] * n
                        v[lead] = 1
                        t = rest
                        for k in range(lead + 1, n):
                            v[k] = t % p
                            t //= p
                        yield v
            for v in gen_pts(n):
                ok = True
                for q in qs:
                    s = 0
                    for (i, j), cf in q:
                        s += cf * v[i] * v[j]
                    if s % p:
                        ok = False
                        break
                if ok:
                    pts.append(tuple(v))
            _, d = want
            CHECK("fp_points_%s_%s" % (r["tag"], rec["piece"]),
                  len(pts) in (0, d),
                  "%d F_p-points found in P(M_chi) by exhaustive search "
                  "(%d geometric points; %s)"
                  % (len(pts), d,
                     "all rational at this prime" if len(pts) == d
                     else "Galois-conjugate over F_p at this prime"))
            if len(pts) != d:
                continue
            # lift to Lambda^2 coordinates and measure stabilisers
            lifts = []
            for v in pts:
                w = [f.ZERO] * 15
                for ci, b in zip(v, rec["B"]):
                    if ci:
                        for j in range(15):
                            w[j] = f.fadd(w[j], f.fmul(f.fint(ci), b[j]))
                lifts.append(tuple(w))

            def same_point(u, v):
                lam = None
                for x, y in zip(u, v):
                    if (x == 0) != (y == 0):
                        return False
                    if x:
                        l2 = x * pow(y, p - 2, p) % p
                        if lam is None:
                            lam = l2
                        elif l2 != lam:
                            return False
                return True

            for pi, w in enumerate(lifts):
                stab = []
                for a in mdl.PSL:
                    L2 = mdl.L2(a)
                    im = tuple(f.dot(L2[i], list(w)) for i in range(15))
                    if same_point(im, w):
                        stab.append(a)
                setstab = 0
                for a in mdl.PSL:
                    L2 = mdl.L2(a)
                    im = tuple(f.dot(L2[i], list(w)) for i in range(15))
                    if any(same_point(im, u) for u in lifts):
                        setstab += 1
                exp = len(r["S"])
                CHECK("stab_%s_%s_pt%d" % (r["tag"], rec["piece"], pi),
                      frozenset(stab) == r["S"],
                      "Stab_G(y) has order %d and equals the subgroup %s "
                      "exactly (orbit length %d); set-stabiliser of the %d "
                      "points has order %d"
                      % (len(stab), r["name"], 660 // max(len(stab), 1),
                         len(pts), setstab))
                if d > 1:
                    CHECK("setstab_%s_%s_pt%d" % (r["tag"], rec["piece"], pi),
                          setstab == 2 * exp,
                          "N_G(%s) of order %d permutes the %d points "
                          "transitively (point stabiliser of index 2)"
                          % (r["name"], setstab, d))


# ----------------------------------------------------------------------
def run_mode(mode, do_m2=True, ambient=True):
    log = []
    fails = []

    def CHECK(name, ok, detail):
        log.append((name, bool(ok), detail))
        if not ok:
            fails.append(name)
        return ok

    mdl = Model(mode, CHECK)
    lattice = mdl.subgroup_lattice()

    # regression: the sealed sigma-fixed locus, through this pipeline
    sigma = next(a for a in mdl.PSL if mdl.PORD[a] == 2)
    cs = mdl.closure([sigma])
    Mplus = mdl.char_piece(list(cs), {a: 1 for a in cs})
    Mminus = mdl.char_piece(list(cs),
                            {a: (1 if a == mdl.PID else -1) for a in cs})
    CHECK("regression_sigma_split", (len(Mplus), len(Mminus)) == (6, 4),
          "dims (M+, M-) = (%d, %d); FIX-IX-SEAL: (6, 4)"
          % (len(Mplus), len(Mminus)))

    results = measure(mdl, lattice, CHECK)
    for r in results:
        for rec in r["pieces"]:
            dexp, want = EXPECT_PIECE[(r["name"], rec["piece"])]
            CHECK("dim_%s_%s" % (r["tag"], rec["piece"]), rec["n"] == dexp,
                  "dim M_chi = %d (character theory: %d)" % (rec["n"], dexp))
            if rec["n"]:
                cert = rec["rank"] == rec["full"]
                CHECK("rankcert_%s_%s" % (r["tag"], rec["piece"]),
                      (not cert) or want == "empty",
                      "restricted quadrics span %d of %d quadratic forms on "
                      "P^%d -- %s" % (rec["rank"], rec["full"], rec["n"] - 1,
                                      "EMPTY by the rank certificate" if cert
                                      else "no rank certificate, decided by "
                                           "Macaulay2"))
            # the S3-trivial and A4-trivial pieces sit inside the sealed
            # sigma-plus piece: their points lie on the genus-1 sextic
            if rec["n"] and rec["piece"] == "triv" and want != "empty":
                sig_in = [a for a in r["S"] if mdl.PORD[a] == 2]
                inside = True
                for b in rec["B"]:
                    for a in sig_in:
                        L2 = mdl.L2(a)
                        im = tuple(mdl.dot(L2[i], list(b)) for i in range(15))
                        if im != b:
                            inside = False
                CHECK("in_sigma_plus_%s" % r["tag"], inside,
                      "M_chi lies in the +1 eigenspace of every involution of "
                      "%s: the fixed points lie on the sealed genus-1 sextics"
                      % r["name"])

    if mode != "K":
        fp_points_and_stabilisers(mdl, results, CHECK)

    os.makedirs(OUTDIR, exist_ok=True)
    path = emit_m2(mdl, results, mode, (Mplus, Mminus), ambient)
    m2out = None
    if do_m2:
        m2out = run_m2(path)
        with open(os.path.join(OUTDIR, "m2_v14fixed_%s.out" % mode), "w") as fh:
            fh.write(m2out)
        CHECK("m2_completed", "M2 DONE" in m2out,
              "the Macaulay2 driver ran to the end")
        CHECK("m2_regression_sigma",
              "REG SIGPLUS dim 2 degree 6" in m2out
              and "REG SIGMINUS dim 1 degree 2" in m2out,
              "sigma-plus: affine dim 2, degree 6 (the genus-1 sextic); "
              "sigma-minus: affine dim 1, degree 2 (two points) -- both as "
              "sealed by FIX-IX-SEAL")
        CHECK("m2_regression_V14", "REG V14 dim 4 degree 14" in m2out,
              "V14 itself: affine dim 4 (projective 3), degree 14 -- as "
              "sealed by FIX-IX-SEAL")
        for r in results:
            for rec in r["pieces"]:
                lbl = "%s_%s" % (r["tag"], rec["piece"])
                want = EXPECT_PIECE[(r["name"], rec["piece"])][1]
                if rec["n"] == 0:
                    CHECK("m2_piece_%s" % lbl,
                          "PIECE %s empty true" % lbl in m2out,
                          "the character piece is 0-dimensional: empty")
                else:
                    check_verdict(CHECK, m2out, "PIECE", lbl, want)
            if ambient:
                check_verdict(CHECK, m2out, "AMBIENT", r["tag"],
                              EXPECT_LOCUS[r["name"]],
                              extra="  [from the 2x2 minors of [x ; g.x] in "
                                    "P^9, no character theory]")
    return mdl, lattice, results, log, fails, m2out


def main():
    args = sys.argv[1:]
    do_m2 = "--no-m2" not in args
    ambient = "--no-ambient" not in args
    modes = [a for a in args if not a.startswith("-")] or ALLMODES
    allfails = []
    for mode in modes:
        print("=" * 70)
        print("MODE %s" % mode)
        print("=" * 70)
        mdl, lattice, results, log, fails, m2out = run_mode(
            mode, do_m2, ambient=ambient)
        for name, ok, detail in log:
            print("  %-4s %-32s %s" % ("PASS" if ok else "FAIL", name, detail))
        for r in results:
            print("  %-8s (G-class of %3d subgroups of order %d)"
                  % (r["tag"], r["orbit"], len(r["S"])))
            for rec in r["pieces"]:
                want = EXPECT_PIECE[(r["name"], rec["piece"])][1]
                print("      %-10s dim %d  ->  %s"
                      % (rec["piece"], rec["n"],
                         "empty" if want == "empty"
                         else "%d reduced points" % want[1]))
        allfails += [(mode, x) for x in fails]
        sys.stdout.flush()
    print("=" * 70)
    if allfails:
        print("FAILED CHECKS: %s" % allfails)
        print("V14-S3-D10-MEASUREMENT-FAILED")
        return 1
    print("modes verified: %s" % ", ".join(modes))
    print("")
    print("V14-S3-NONEMPTY   V14^{S3} = 2 reduced points for each of the 110 "
          "S3 subgroups")
    print("                  (both G-classes); Stab_G = S3 exactly; the two "
          "points are")
    print("                  swapped by N_G(S3) = D12; 2 G-orbits of 110 "
          "points in all;")
    print("                  every such point lies on the genus-1 sextic of "
          "each of the")
    print("                  three involutions of its S3.")
    print("V14-D10-EMPTY     V14^{D10} = empty (both character pieces; all 66 "
          "subgroups).")
    print("V14-A4-NONEMPTY   V14^{A4} = 1 reduced point for each of the 55 A4 "
          "subgroups;")
    print("                  Stab_G = A4 exactly; 1 G-orbit of 55 points.")
    print("V14-A5-EMPTY      V14^{A5} = empty (both G-classes).")
    print("")
    print("V14-S3-D10-MEASUREMENT-OK")
    return 0


if __name__ == "__main__":
    sys.exit(main())
