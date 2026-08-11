"""STAGE1_TIGHTEN -- the sweep rows with ALL slots and the trivial character.

STAGE1_COMPLEX_MAPS computed the Layer-2 components of a sweep row S as pairs
(multidegree a on the POSITIVE-DIMENSIONAL slots, linear character psi of
Gamma = Stab_G(F_S)), taking the union over psi because a projective map only
needs equivariance up to a character.  Two sealed facts now remove that freedom
and index everything by the covariant degree d:

  * STAGE2_ODD_ORDER_PINNING Lemma 0.1 -- G is perfect, so a landing covariant
    is exactly G-INVARIANT: T in (Sym^d W* (x) W)^G, no character twist.  The
    leading datum of T along the flag of S is a multigraded piece of T, so it is
    Gamma-invariant with the TRIVIAL character.
  * the multidegree is not free either: the slot degrees are the jet orders and
    they sum to d.  Including the 1-dimensional (P^0) slots -- which STAGE1
    dropped, since they only contribute a character -- makes  sum_r a_r = d
    exact.

So a component is a multidegree a with sum a_r = d and psi = 1, and everything
becomes a function of d.  This module rebuilds the sweep rows with all slots,
provides the exact character-rule value, the exact module dimension by the trace
formula, and the saturation apparatus of THEOREM.md section 3.
"""
import itertools
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from s1coherence import coords, matmul_inv, nullspace, monomials, prop, rank2  # noqa: E402


class FullSweep:
    """a sweep-capable row with ALL its graded slots."""

    def __init__(self, E, rid, seed=7):
        self.E, self.rid = E, rid
        S, T, m = E.S, E.T, E.m
        self.m, self.p = m, m.p
        r = [q for q in E.rows if q["id"] == rid][0]
        self.row = r
        C, L, H = S.comps[r["rep"]]
        self.C, self.L = C, L
        self.Gam = sorted(r["S"])
        self.sig = [x for x in H if x != m.Id][0]
        self.Wm = T.minus[self.sig]
        Us = [()] + list(C)
        self.slots = []                      # (index, lo, comp basis)  -- ALL slots
        for i in range(len(L)):
            lo = Us[i]
            comp, b = [], [list(v) for v in lo]
            for v in L[i]:
                if m.rank(b + [list(v)]) > len(b):
                    b.append(list(v))
                    comp.append(list(v))
            self.slots.append((i, lo, comp))
        self.nslot = len(self.slots)
        self.dims = [len(c) for (_i, _lo, c) in self.slots]
        self.Mg = []
        for (i, lo, comp) in self.slots:
            self.Mg.append({g: self._mat(lo, comp, g) for g in self.Gam})
        wb = [list(v) for v in self.Wm]
        self.Mw = {g: self._mat((), wb, g) for g in self.Gam}
        self._children(seed)

    def _mat(self, lo, comp, g):
        m = self.m
        cols = [coords(self.E.S, lo, comp, list(m.act(g, tuple(v)))) for v in comp]
        n = len(comp)
        return [[cols[j][i] for j in range(n)] for i in range(n)]

    # ------------------------------------------------------------------
    def _children(self, seed):
        E, S = self.E, self.E.S
        rep = self.row["rep"]
        fc = frozenset(self.C)
        rnd = seed
        self.kids = []
        for j in range(len(S.comps)):
            if j == rep or not fc <= frozenset(S.comps[j][0]):
                continue
            if not S.closure_le(j, rep):
                continue
            Cj, Lj, Hj = S.comps[j]
            qs, ok = [], True
            for (r_, lo, comp) in self.slots:
                jr = sum(1 for U in Cj if S.sub(U, lo))
                Aj = Lj[jr]
                pts = []
                for _ in range(4):
                    w = [0] * 5
                    for b in Aj:
                        rnd = (rnd * 1103515245 + 12345) % (2 ** 31)
                        c = rnd % self.p
                        w = [(w[t] + c * b[t]) % self.p for t in range(5)]
                    cc = coords(S, lo, comp, w)
                    if any(x % self.p for x in cc):
                        pts.append(cc)
                if not pts:
                    ok = False
                    break
                qs.append(pts)
            if not ok:
                continue
            self.kids.append(dict(idx=j, row=E.byoid[S.orbit_of[j]]["id"],
                                  tr=S.transversal[j], qs=qs,
                                  Lam=[g for g in self.Gam if g in Hj]))
        # the Lambda-characters mu_r on each child's coordinate lines
        for kid in self.kids:
            mus = []
            good = True
            for i in range(self.nslot):
                q = kid["qs"][i][0]
                mu = {}
                for h in kid["Lam"]:
                    Mh = self.Mg[i][h]
                    img = [sum(Mh[a][b] * q[b] for b in range(len(q))) % self.p
                           for a in range(len(q))]
                    j0 = next(b for b in range(len(q)) if q[b] % self.p)
                    lam = img[j0] * self.m.inv(q[j0]) % self.p
                    if any((img[b] - lam * q[b]) % self.p for b in range(len(q))):
                        good = False
                    mu[h] = lam
                mus.append(mu)
            kid["mu"] = mus if good else None
            kid["lines"] = self.eigenlines(kid["Lam"])

    def eigenlines(self, Lam):
        m, p = self.m, self.p
        out, seen = [], set()
        for h in Lam:
            for lam in range(1, p):
                if pow(lam, m.order[h], p) != 1:
                    continue
                Ez = m.eigsp(h, lam)
                I = m.inter(Ez, self.Wm) if Ez else ()
                if I and len(I) == 1 and I not in seen:
                    chi, ok = {}, True
                    for h2 in Lam:
                        w = list(m.act(h2, I[0]))
                        j0 = next(b for b in range(5) if I[0][b] % p)
                        c = w[j0] * m.inv(I[0][j0]) % p
                        if any((w[b] - c * I[0][b]) % p for b in range(5)):
                            ok = False
                        chi[h2] = c
                    if ok:
                        seen.add(I)
                        out.append((chi, I))
        return out

    # ---------------- the character rule (psi = trivial) ----------------
    def value(self, a, kid, psi=None):
        """the eigenline of W^-_sigma carrying the value, by the character rule."""
        p = self.p
        if kid["mu"] is None or len(kid["Lam"]) < 2:
            return None
        target = {}
        for h in kid["Lam"]:
            v = 1 if psi is None else self.m.inv(psi[h])
            for i in range(self.nslot):
                v = v * pow(kid["mu"][i][h], a[i], p) % p
            target[h] = v
        for chi, U in kid["lines"]:
            if all(chi[h] == target[h] for h in kid["Lam"]):
                return U
        return None

    def own_frame(self, kid, U):
        """transport the target point into the child ROW's own frame."""
        T = self.E.T
        for cell in ("PI", "P6"):
            if U in T.comp[cell]:
                return ("pt", cell, T.act(self.m.matinv(kid["tr"]), cell, U))
        return None

    # ---------------- exact module dimension (trace formula) -------------
    def module_dim(self, a, psi=None):
        m, p = self.m, self.p
        tot = 0
        for g in self.Gam:
            t = 1
            for i in range(self.nslot):
                ev = self._eigs(i, g)
                t = t * self._h(a[i], [m.inv(x) for x in ev]) % p
            t = t * self._tr(self.Mw[g]) % p
            if psi is not None:
                t = t * m.inv(psi[g]) % p
            tot = (tot + t) % p
        return tot * m.inv(len(self.Gam) % p) % p

    def _tr(self, M):
        return sum(M[i][i] for i in range(len(M))) % self.p

    def _eigs(self, i, g):
        if not hasattr(self, "_ec"):
            self._ec = {}
        if (i, g) in self._ec:
            return self._ec[(i, g)]
        p, m = self.p, self.m
        M = self.Mg[i][g]
        n = len(M)
        ev = []
        for lam in range(1, p):
            if pow(lam, m.order[g], p) != 1:
                continue
            rows = [[(M[x][y] - (lam if x == y else 0)) % p for y in range(n)]
                    for x in range(n)]
            ev.extend([lam] * len(nullspace(p, rows, n)))
        assert len(ev) == n, (len(ev), n)
        self._ec[(i, g)] = ev
        return ev

    def _h(self, k, evs):
        """complete homogeneous h_k of the multiset evs, in F_p."""
        p = self.p
        den = [1] + [0] * k
        for e in evs:
            new = [0] * (k + 1)
            for x in range(k + 1):
                if den[x] == 0:
                    continue
                for y in range(k + 1 - x):
                    new[x + y] = (new[x + y] + den[x] * pow(e, y, p)) % p
            den = new
        return den[k]

    # ---------------- explicit module + evaluation (small a) -------------
    def explicit(self, a, psi=None):
        """basis of V(a,psi) and the evaluation span at each child."""
        m, p = self.m, self.p
        mons = [list(monomials(self.dims[i], a[i])) for i in range(self.nslot)]
        basis, idx = [], {}
        for tup in itertools.product(*mons):
            for w in range(2):
                idx[(tup, w)] = len(basis)
                basis.append((tup, w))
        n = len(basis)
        mats = {}
        for g in self.Gam:
            Minv = [matmul_inv(m, self.Mg[i][g]) for i in range(self.nslot)]
            A = [[0] * n for _ in range(n)]
            for col, (tup, w) in enumerate(basis):
                poly = {(): 1}
                for i in range(self.nslot):
                    dd = self.dims[i]
                    cur = {tuple([0] * dd): 1}
                    for jv in range(dd):
                        for _ in range(tup[i][jv]):
                            nw = {}
                            for mon, co in cur.items():
                                for l in range(dd):
                                    c2 = Minv[i][jv][l]
                                    if c2 % p == 0:
                                        continue
                                    k = list(mon)
                                    k[l] += 1
                                    nw[tuple(k)] = (nw.get(tuple(k), 0) + co * c2) % p
                            cur = nw
                    poly = {pm + (mon,): (poly[pm] * co) % p
                            for pm in poly for mon, co in cur.items()}
                for pm, pc in poly.items():
                    for w2 in range(2):
                        c3 = self.Mw[g][w2][w] * pc % p
                        if c3:
                            A[idx[(pm, w2)]][col] = (A[idx[(pm, w2)]][col] + c3) % p
            mats[g] = A
        rows = []
        for g, M in mats.items():
            lam = 1 if psi is None else psi[g]
            for i in range(n):
                rows.append([(M[i][j] - (lam if i == j else 0)) % p for j in range(n)])
        V = nullspace(p, rows, n)
        out = {}
        for kid in self.kids:
            q = [kid["qs"][i][0] for i in range(self.nslot)]
            ev = [self._eval(basis, v, q) for v in V]
            out[kid["idx"]] = (rank2(p, ev), next((v for v in ev
                                                   if any(x % p for x in v)), None))
        return len(V), out

    def _eval(self, basis, vec, q):
        p = self.p
        out = [0, 0]
        for c, (tup, w) in zip(vec, basis):
            if c % p == 0:
                continue
            t = c
            for i in range(self.nslot):
                for jv, e in enumerate(tup[i]):
                    if e:
                        t = t * pow(q[i][jv], e, p) % p
            out[w] = (out[w] + t) % p
        return out

    # ---------------- saturation apparatus -------------------------------
    def invariant_degree(self, i, maxdeg=13):
        """least g with a Gamma-invariant form of degree g on slot i not
        vanishing at any child's i-th coordinate (0 if the slot is a P^0)."""
        p, m = self.p, self.m
        if self.dims[i] == 1:
            return 1
        pts = [kid["qs"][i][0] for kid in self.kids]
        for g in range(1, maxdeg + 1):
            mons = list(monomials(self.dims[i], g))
            n = len(mons)
            idx = {e: k for k, e in enumerate(mons)}
            rows = []
            for gg in self.Gam:
                Minv = matmul_inv(m, self.Mg[i][gg])
                A = [[0] * n for _ in range(n)]
                for col, e in enumerate(mons):
                    cur = {tuple([0] * self.dims[i]): 1}
                    for jv in range(self.dims[i]):
                        for _ in range(e[jv]):
                            nw = {}
                            for mon, co in cur.items():
                                for l in range(self.dims[i]):
                                    c2 = Minv[jv][l]
                                    if c2 % p == 0:
                                        continue
                                    k = list(mon)
                                    k[l] += 1
                                    nw[tuple(k)] = (nw.get(tuple(k), 0) + co * c2) % p
                            cur = nw
                    for mon, co in cur.items():
                        A[idx[mon]][col] = (A[idx[mon]][col] + co) % p
                for x in range(n):
                    rows.append([(A[x][y] - (1 if x == y else 0)) % p for y in range(n)])
            V = nullspace(p, rows, n)
            for v in V:
                if all(self._evalmon(mons, v, q) % p for q in pts):
                    return g
        return None

    def _evalmon(self, mons, v, q):
        p = self.p
        s = 0
        for c, e in zip(v, mons):
            if c % p == 0:
                continue
            t = c
            for jv, k in enumerate(e):
                if k:
                    t = t * pow(q[jv], k, p) % p
            s = (s + t) % p
        return s

    def orbit_sizes(self):
        """|Gamma . q_j| for each child (bounds the interpolation degree)."""
        out = []
        for kid in self.kids:
            seen = set()
            for g in self.Gam:
                key = []
                for i in range(self.nslot):
                    q = kid["qs"][i][0]
                    M = self.Mg[i][g]
                    img = tuple(sum(M[a][b] * q[b] for b in range(len(q))) % self.p
                                for a in range(len(q)))
                    j0 = next(b for b in range(len(img)) if img[b] % self.p)
                    iv = self.m.inv(img[j0])
                    key.append(tuple(x * iv % self.p for x in img))
                seen.add(tuple(key))
            out.append(len(seen))
        return out
