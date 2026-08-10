#!/usr/bin/env python3
"""
spin_network_lib -- the spin-source fixed network of PSL(2,q), q = 3 mod 4.

Exact, characteristic 0, no sampling and no search.  Everything is built from
the INTEGRAL monomial model

    W_q  =  Ind_B^{SL_2(F_q)} (chi),        chi = the Legendre symbol,

realised on { f : F_q^2 minus 0 -> C : f(lam v) = chi(lam) f(v) }, with
(g.f)(v) = f(g^{-1}v).  Every rho(g) is a SIGNED PERMUTATION matrix of size
q+1.  Because q = 3 mod 4 we have chi(-1) = -1, so -I acts on W_q by -id:
W_q is a purely SPIN representation and

    W_q  =  U (+) U',      dim U = dim U' = (q+1)/2,

the two Galois-conjugate spin irreducibles (conjugate over Q(sqrt(-q))).

HALVING PRINCIPLE.  rho has entries in Z, hence every subspace of W_q cut out
by eigenvalue conditions with eigenvalues in Q(i) is defined over Q(i) and so
is stable under Gal(Q(i,sqrt(-q))/Q(i)) = {1,tau}; tau swaps U and U'.  For
such a subspace S,  dim(S n U) = dim(S)/2.  All 6- or 4-dimensional spin
questions therefore become exact INTEGER questions in dimension q+1.

Exported: SpinNetwork(q) with attributes documented in __init__.
"""

from fractions import Fraction as Fr
from itertools import combinations
from collections import deque

ZERO = (Fr(0), Fr(0))
ONE = (Fr(1), Fr(0))
IUNIT = (Fr(0), Fr(1))


def gadd(x, y):
    return (x[0] + y[0], x[1] + y[1])


def gsub(x, y):
    return (x[0] - y[0], x[1] - y[1])


def gmul(x, y):
    return (x[0] * y[0] - x[1] * y[1], x[0] * y[1] + x[1] * y[0])


def gdiv(x, y):
    d = y[0] * y[0] + y[1] * y[1]
    return ((x[0] * y[0] + x[1] * y[1]) / d, (x[1] * y[0] - x[0] * y[1]) / d)


def gz(x):
    return x[0] == 0 and x[1] == 0


def gint(n):
    return (Fr(n), Fr(0))


def _elim(rows, ncols, want_kernel=False):
    A = [list(r) for r in rows]
    nr = len(A)
    piv, r = [], 0
    for c in range(ncols):
        p = None
        for k in range(r, nr):
            if not gz(A[k][c]):
                p = k
                break
        if p is None:
            continue
        A[r], A[p] = A[p], A[r]
        iv = gdiv(ONE, A[r][c])
        A[r] = [gmul(iv, x) for x in A[r]]
        for k in range(nr):
            if k != r and not gz(A[k][c]):
                f = A[k][c]
                A[k] = [gsub(A[k][j], gmul(f, A[r][j])) for j in range(ncols)]
        piv.append(c)
        r += 1
        if r == nr:
            break
    return A, piv, r


def rank(rows, ncols):
    return _elim(rows, ncols)[2]


def kernel_basis(rows, ncols):
    A, piv, r = _elim(rows, ncols)
    out = []
    for fc in [c for c in range(ncols) if c not in piv]:
        v = [ZERO] * ncols
        v[fc] = ONE
        for i, pc in enumerate(piv):
            v[pc] = gsub(ZERO, A[i][fc])
        out.append(tuple(v))
    return out


def rref_key(rows, ncols):
    A, piv, r = _elim(rows, ncols)
    return tuple(tuple(A[i]) for i in range(r))


class SpinNetwork:
    def __init__(self, q, full_incidence=True):
        assert q % 4 == 3, "need q = 3 mod 4 so that chi(-1) = -1"
        self.q = q
        n = self.n = q + 1                      # dim of the ambient model W
        self.dimU = n // 2
        SQ = set((x * x) % q for x in range(1, q))

        def leg(a):
            a %= q
            return 0 if a == 0 else (1 if a in SQ else -1)

        def mul(g, h):
            a, b, c, d = g
            e, f, gg, hh = h
            return ((a * e + b * gg) % q, (a * f + b * hh) % q,
                    (c * e + d * gg) % q, (c * f + d * hh) % q)

        def inv(g):
            a, b, c, d = g
            return (d % q, (-b) % q, (-c) % q, a % q)

        self.mul, self.inv, self.leg = mul, inv, leg
        ID = self.ID = (1, 0, 0, 1)
        NEG = self.NEG = (q - 1, 0, 0, q - 1)

        SL = []
        for a in range(q):
            for b in range(q):
                for c in range(q):
                    for d in range(q):
                        if (a * d - b * c) % q == 1:
                            SL.append((a, b, c, d))
        self.SL = tuple(SL)

        def order(g):
            k, h = 1, g
            while h != ID:
                h = mul(h, g)
                k += 1
            return k

        self.ORD = {g: order(g) for g in SL}

        def proj_order(g):
            k, h = 1, g
            while h != ID and h != NEG:
                h = mul(h, g)
                k += 1
            return k

        self.proj_order = proj_order

        # ---- the monomial model ------------------------------------------
        VREP = [(j, 1) for j in range(q)] + [(1, 0)]

        def line_index(w):
            a, b = w[0] % q, w[1] % q
            return (a * pow(b, q - 2, q)) % q if b != 0 else q

        def rho(g):
            M = [[0] * n for _ in range(n)]
            for j in range(n):
                a, b, c, d = g
                w = ((a * VREP[j][0] + b * VREP[j][1]) % q,
                     (c * VREP[j][0] + d * VREP[j][1]) % q)
                i = line_index(w)
                M[i][j] = leg(w[1] if i < q else w[0])
            return M

        self.RHO = {g: rho(g) for g in SL}
        self.CHI = {g: sum(self.RHO[g][i][i] for i in range(n)) for g in SL}
        self.I = [[1 if i == j else 0 for j in range(n)] for i in range(n)]

        # ---- involutions of PSL(2,q) and canonical order-4 lifts ----------
        seen, INV = set(), []
        for g in sorted(x for x in SL if self.ORD[x] == 4):
            if g in seen:
                continue
            seen.add(g)
            seen.add(mul(NEG, g))
            INV.append(g)
        self.INV = tuple(sorted(INV))
        self.IDX = {s: k for k, s in enumerate(self.INV)}
        self.nInv = len(self.INV)

        def commute_proj(s, t):
            c = mul(mul(s, t), inv(s))
            return c == t or c == mul(NEG, t)

        self.commute_proj = commute_proj

        # ---- Klein four-groups and their preimages ------------------------
        V4S = set()
        for a, b in combinations(range(self.nInv), 2):
            s, t = self.INV[a], self.INV[b]
            if commute_proj(s, t):
                p = mul(s, t)
                c = self.IDX[p] if p in self.IDX else self.IDX[mul(NEG, p)]
                V4S.add(tuple(sorted((a, b, c))))
        self.V4S = sorted(V4S)

        def gens_group(mats):
            G0, fr = {ID}, [ID]
            while fr:
                nx = []
                for g in fr:
                    for s in mats:
                        h = mul(g, s)
                        if h not in G0:
                            G0.add(h)
                            nx.append(h)
                fr = nx
            return G0

        self.gens_group = gens_group

        self.q8_data = []
        for V in self.V4S:
            Q = gens_group([self.INV[V[0]], self.INV[V[1]]])
            ninv = sum(1 for g in Q if self.ORD[g] == 2)
            mH = Fr(0)
            for g in Q:
                cH = 2 if g == ID else (-2 if g == NEG else 0)
                mH += Fr(self.CHI[g], 2) * cH
            self.q8_data.append((len(Q), ninv, mH / 8))

        # ---- the 2*nInv eigen-strata -------------------------------------
        self.PLANES = []
        self.EB = {}
        for k, s in enumerate(self.INV):
            for eps in (1, -1):
                lam = IUNIT if eps == 1 else (Fr(0), Fr(-1))
                M = []
                for i in range(n):
                    row = []
                    for j in range(n):
                        x = gint(self.RHO[s][i][j])
                        if i == j:
                            x = gsub(x, lam)
                        row.append(x)
                    M.append(tuple(row))
                self.EB[(k, eps)] = kernel_basis(M, n)
                self.PLANES.append((k, eps))

        # ---- pair types ---------------------------------------------------
        self.PAIRTYPE = {}
        for a, b in combinations(range(self.nInv), 2):
            self.PAIRTYPE[(a, b)] = proj_order(mul(self.INV[a], self.INV[b]))

        def ptype(a, b):
            return self.PAIRTYPE[(min(a, b), max(a, b))]

        self.ptype = ptype

        # ---- incidence ----------------------------------------------------
        self.INCID, self.edges = {}, []
        if full_incidence:
            for p1, p2 in combinations(self.PLANES, 2):
                rows = list(self.EB[p1]) + list(self.EB[p2])
                dW = n - rank(rows, n)
                assert dW % 2 == 0
                d = dW // 2
                self.INCID[(p1, p2)] = d
                if d:
                    self.edges.append((p1, p2, d))
            self.adj = {p: set() for p in self.PLANES}
            for p1, p2, d in self.edges:
                self.adj[p1].add(p2)
                self.adj[p2].add(p1)

    # ------------------------------------------------------------------
    def span_intersection(self, p1, p2):
        n = self.n
        cols = [list(row) for row in zip(*(list(self.EB[p1]) +
                                           list(self.EB[p2])))]
        rel = kernel_basis([tuple(r) for r in cols], n)
        m = len(self.EB[p1])
        out = []
        for rl in rel:
            v = [ZERO] * n
            for t in range(m):
                if not gz(rl[t]):
                    for j in range(n):
                        v[j] = gadd(v[j], gmul(rl[t], self.EB[p1][t][j]))
            out.append(tuple(v))
        return out

    def incidence_points(self):
        pts = {}
        for p1, p2, d in self.edges:
            S = self.span_intersection(p1, p2)
            key = rref_key(S, self.n)
            pts.setdefault(key, {"planes": set(), "basis": S})
            pts[key]["planes"].update((p1, p2))
        return pts

    def apply_rho(self, g, v):
        A = self.RHO[g]
        return [(sum(Fr(A[i][j]) * v[j][0] for j in range(self.n)),
                 sum(Fr(A[i][j]) * v[j][1] for j in range(self.n)))
                for i in range(self.n)]

    def scalar_on(self, g, v, nz):
        w = self.apply_rho(g, v)
        if gz(w[nz]):
            return None
        lam = gdiv(w[nz], v[nz])
        if all(gz(gsub(w[j], gmul(lam, v[j]))) for j in range(self.n)):
            return lam
        return None

    def stab_of_point(self, rec):
        v = rec["basis"][0]
        nz = next(j for j in range(self.n) if not gz(v[j]))
        out = set()
        for g in self.SL:
            if self.scalar_on(g, v, nz) is not None:
                out.add(min(g, self.mul(self.NEG, g)))
        return out

    def tangent_report(self, rec):
        """T_x = Hom(L, U/L) as a K = Stab_G(x)-representation:
        returns (|K|, dim T, m_triv, m_sign, dim T^{sigma,+}, dim T^{sigma,-})."""
        v = rec["basis"][0]
        nz = next(j for j in range(self.n) if not gz(v[j]))
        invs = sorted(set(p[0] for p in rec["planes"]))
        Ktil = self.gens_group([self.INV[a] for a in invs])
        Kproj = {}
        for g in Ktil:
            lam = self.scalar_on(g, v, nz)
            assert lam is not None
            cu = (Fr(self.CHI[g], 2), Fr(0))
            Kproj[min(g, self.mul(self.NEG, g))] = gsub(
                gmul(gdiv(ONE, lam), cu), ONE)
        m = len(Kproj)
        at, asg = ZERO, ZERO
        for g, x in Kproj.items():
            at = gadd(at, x)
            asg = gadd(asg, gmul(x, gint(-1 if self.proj_order(g) == 2 else 1)))
        s0 = min(self.INV[invs[0]], self.mul(self.NEG, self.INV[invs[0]]))
        return (m, Kproj[self.ID][0], gdiv(at, gint(m))[0],
                gdiv(asg, gint(m))[0],
                gdiv(gadd(Kproj[self.ID], Kproj[s0]), gint(2))[0],
                gdiv(gsub(Kproj[self.ID], Kproj[s0]), gint(2))[0])

    def components(self, edge_subset=None):
        es = self.edges if edge_subset is None else edge_subset
        ad = {p: set() for p in self.PLANES}
        for e in es:
            ad[e[0]].add(e[1])
            ad[e[1]].add(e[0])
        sv, cs = set(), []
        for p in self.PLANES:
            if p in sv:
                continue
            st, comp = [p], []
            sv.add(p)
            while st:
                x = st.pop()
                comp.append(x)
                for y in ad[x]:
                    if y not in sv:
                        sv.add(y)
                        st.append(y)
            cs.append(comp)
        return cs

    def bfs(self, src):
        dist, dq = {src: 0}, deque([src])
        while dq:
            x = dq.popleft()
            for y in self.adj[x]:
                if y not in dist:
                    dist[y] = dist[x] + 1
                    dq.append(y)
        return dist
