"""STAGE1_COMPLEX_MAPS -- stratum-level EVALUATION coherence (the audit repair).

Layer 1 as first published imposed value-SET consistency (arc consistency):
`im(F) subset closure(im(F'))` whenever `F subset closure(F')`.  That is weaker
than what a single morphism forces.  If the parent row `S` sweeps its line via a
Layer-2 morphism `phi` in a component `M_S(a, psi)` of its moduli, then the value
of every deeper row `R` in `cl(S)` is not a free choice inside `L_sigma`: it is
the EVALUATION `phi|_R`, a determinate point.

This module computes those evaluations exactly, two ways:

  (1) CHARACTER RULE.  Let `Lambda = Stab_G(F_S) cap (pointwise stabilizer of the
      child component)`.  `Lambda` fixes each coordinate `q_r` of `pi(F_child)`
      projectively, acting on it by a character `mu_r`; and `phi` is
      `Gamma`-equivariant with character `psi`.  Writing `s` for the W^- valued
      multiform, `s(h.q) = psi(h) h.s(q)` and `h.q_r = mu_r(h) q_r` give

          h . s(q)  =  psi(h)^{-1} prod_r mu_r(h)^{a_r} . s(q) ,

      so `s(q)` lies in the `Lambda`-eigenline of `W^-_sigma` of character
      `psi^{-1} prod mu_r^{a_r}` -- INDEPENDENT of the coefficients of `s`.
      Hence `ev_R` is CONSTANT on each connected component of `M_S`.

  (2) EXPLICIT EVALUATION.  Build a basis of
      `(Sym^{a}(V^*) (x) W^-_sigma)^{Gamma, psi}` and evaluate it at a generic
      point of `pi(F_child)`; the span in `W^-_sigma` must be 0 (degenerate: phi
      is undefined along the child) or a single line (rigidity), never the whole
      plane.  Route (2) both confirms route (1) and settles nondegeneracy.

Convention (fixed here, and used for all evaluation work): a multiform is an
element of `Sym^{a_0}(V_0^*) (x) ... (x) W^-`, with `(g.s)(q) = g . s(g^{-1} q)`.
"""
import itertools
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))

W_FULL = None


# --------------------------------------------------------------------------
def monomials(n, d):
    if n == 0:
        yield ()
        return
    if n == 1:
        yield (d,)
        return
    for i in range(d + 1):
        for rest in monomials(n - 1, d - i):
            yield (i,) + rest


def matmul_inv(m, M):
    """inverse of a square matrix over F_p (M[i][j])."""
    p = m.p
    n = len(M)
    A = [list(M[i]) + [int(i == j) for j in range(n)] for i in range(n)]
    r = 0
    for c in range(n):
        pr = next(i for i in range(r, n) if A[i][c] % p)
        A[r], A[pr] = A[pr], A[r]
        iv = m.inv(A[r][c])
        A[r] = [x * iv % p for x in A[r]]
        for i in range(n):
            if i != r and A[i][c] % p:
                f = A[i][c]
                A[i] = [(x - f * y) % p for x, y in zip(A[i], A[r])]
        r += 1
    return [row[n:] for row in A]


def coords(S, basis_lo, comp, w):
    """coordinates of w modulo span(basis_lo) in the basis `comp`."""
    m = S.m
    p = m.p
    full = [list(v) for v in basis_lo] + [list(v) for v in comp]
    n = len(full)
    Aug = [[full[i][c] for i in range(n)] + [w[c]] for c in range(5)]
    r, piv = 0, []
    for c in range(n):
        pr = None
        for i in range(r, 5):
            if Aug[i][c] % p:
                pr = i
                break
        if pr is None:
            continue
        Aug[r], Aug[pr] = Aug[pr], Aug[r]
        iv = m.inv(Aug[r][c])
        Aug[r] = [x * iv % p for x in Aug[r]]
        for i in range(5):
            if i != r and Aug[i][c] % p:
                f = Aug[i][c]
                Aug[i] = [(x - f * y) % p for x, y in zip(Aug[i], Aug[r])]
        piv.append(c)
        r += 1
    x = [0] * n
    for i, c in enumerate(piv):
        x[c] = Aug[i][n] % p
    return x[len(basis_lo):]


# --------------------------------------------------------------------------
class SweepRow:
    """the Layer-2 data of one sweep-capable row, plus its children."""

    def __init__(self, E, rid, seed=1):
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
        self.Us = Us
        # projective factors of F_S: slots with dim >= 2
        self.slots = []
        for i in range(len(L)):
            if len(L[i]) - len(Us[i]) >= 2:
                lo = Us[i]
                comp = []
                b = [list(v) for v in lo]
                for v in L[i]:
                    if m.rank(b + [list(v)]) > len(b):
                        b.append(list(v))
                        comp.append(list(v))
                self.slots.append((i, lo, comp))
        self.nslot = len(self.slots)
        # matrices of Gamma on each slot and on W^-
        self.Mg = []
        for (i, lo, comp) in self.slots:
            d = {}
            for g in self.Gam:
                cols = [coords(S, lo, comp, list(m.act(g, tuple(v)))) for v in comp]
                d[g] = [[cols[j][i2] for j in range(len(comp))] for i2 in range(len(comp))]
            self.Mg.append(d)
        self.Mw = {}
        wb = [list(v) for v in self.Wm]
        for g in self.Gam:
            cols = [coords(S, (), wb, list(m.act(g, tuple(v)))) for v in wb]
            self.Mw[g] = [[cols[j][i2] for j in range(2)] for i2 in range(2)]
        self.lin = linear_characters(m, self.Gam)
        self._children(seed)

    # ---- children -------------------------------------------------------
    def _children(self, seed):
        """every component of every row whose closure relation puts it in cl(F_S)."""
        E, S, m = self.E, self.E.S, self.m
        rep = self.row["rep"]
        fc = frozenset(self.C)
        kids = []
        for j in range(len(S.comps)):
            Cj = S.comps[j][0]
            if not fc <= frozenset(Cj):
                continue
            if j == rep:
                continue
            if not S.closure_le(j, rep):
                continue
            kids.append(j)
        self.kid_idx = kids
        self.kids = []
        rnd = seed
        for j in kids:
            Cj, Lj, Hj = S.comps[j]
            qs = []
            ok = True
            for (r_, lo, comp) in self.slots:
                jr = sum(1 for U in Cj if S.sub(U, lo))
                Aj = Lj[jr]
                # generic vector of Aj, reduced mod lo, in the `comp` basis
                pts = []
                for trial in range(4):
                    rnd = (rnd * 1103515245 + 12345) % (2 ** 31)
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
            lam = [g for g in self.Gam if g in Hj]
            self.kids.append(dict(idx=j, row=E.byoid[S.orbit_of[j]]["id"],
                                  tr=S.transversal[j], qs=qs, Lam=lam, H=Hj))

    # ---- the module -----------------------------------------------------
    def module(self, degs):
        """action matrices of Gamma on Sym^degs(V^*) (x) W^-, and the basis index."""
        m, p = self.m, self.p
        mons = [list(monomials(len(self.slots[i][2]), degs[i])) for i in range(self.nslot)]
        idx = {}
        basis = []
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
                # substitute x_j -> sum_l Minv[j][l] x_l  in each slot
                poly = {(): 1}
                for i in range(self.nslot):
                    d = len(self.slots[i][2])
                    cur = {tuple([0] * d): 1}
                    for jv in range(d):
                        for _ in range(tup[i][jv]):
                            nw = {}
                            for mon, co in cur.items():
                                for l in range(d):
                                    c2 = Minv[i][jv][l]
                                    if c2 % p == 0:
                                        continue
                                    k = list(mon)
                                    k[l] += 1
                                    k = tuple(k)
                                    nw[k] = (nw.get(k, 0) + co * c2) % p
                            cur = nw
                    new = {}
                    for pm, pc in poly.items():
                        for mon, co in cur.items():
                            new[pm + (mon,)] = (new.get(pm + (mon,), 0) + pc * co) % p
                    poly = new
                for pm, pc in poly.items():
                    for w2 in range(2):
                        c3 = self.Mw[g][w2][w] * pc % p
                        if c3:
                            A[idx[(pm, w2)]][col] = (A[idx[(pm, w2)]][col] + c3) % p
            mats[g] = A
        return basis, idx, mats

    def eigenspace(self, mats, n, psi):
        p = self.p
        rows = []
        for g, M in mats.items():
            lam = psi[g]
            for i in range(n):
                rows.append([(M[i][j] - (lam if i == j else 0)) % p for j in range(n)])
        return nullspace(p, rows, n)

    def evaluate(self, basis, vec, q):
        """value in W^- coordinates of the multiform `vec` at the point q."""
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

    # ---- the evaluation classes ----------------------------------------
    def classes(self, maxdeg):
        """for every component (degs, psi) of M_S with non-zero module: the vector
        of child values (or DEGENERATE), plus the rigidity verdict."""
        out = {}
        rigid_fail = []
        for degs in itertools.product(range(maxdeg + 1), repeat=self.nslot):
            if sum(degs) == 0:
                continue
            basis, idx, mats = self.module(degs)
            n = len(basis)
            for name, psi in self.lin:
                V = self.eigenspace(mats, n, psi)
                if not V:
                    continue
                vals = {}
                for kid in self.kids:
                    spans = []
                    for t in range(len(kid["qs"][0]) if self.nslot else 1):
                        q = [kid["qs"][i][min(t, len(kid["qs"][i]) - 1)]
                             for i in range(self.nslot)]
                        ev = [self.evaluate(basis, v, q) for v in V]
                        spans.append(ev)
                    ev0 = spans[0]
                    rk = rank2(self.p, ev0)
                    if rk == 0:
                        vals[kid["idx"]] = "DEGENERATE"
                        continue
                    if rk == 2:
                        rigid_fail.append((degs, name, kid["idx"]))
                        vals[kid["idx"]] = "NONRIGID"
                        continue
                    w = next(v for v in ev0 if any(x % self.p for x in v))
                    # check the other generic points agree
                    good = True
                    for ev in spans[1:]:
                        for v in ev:
                            if any(x % self.p for x in v) and not prop(self.p, v, w):
                                good = False
                    if not good:
                        rigid_fail.append((degs, name, kid["idx"]))
                        vals[kid["idx"]] = "NONCONST"
                        continue
                    vals[kid["idx"]] = self.point_label(w)
                out[(degs, name)] = vals
        self.rigid_fail = rigid_fail
        return out

    def point_label(self, w):
        """the target component (cell, label) of the point [w] in L_sigma."""
        m, T = self.m, self.E.T
        vec = tuple(sum(w[i] * self.Wm[i][c] for i in range(2)) % self.p for c in range(5))
        U = m.canon([list(vec)])
        for cell in ("PI", "P6"):
            if U in T.comp[cell]:
                return (cell, U)
        return ("gen", U)

    # ---- character-rule prediction --------------------------------------
    def character_rule(self, degs, psi, kid):
        """the eigenline of W^- predicted by the character rule, or None."""
        m, p = self.m, self.p
        Lam = kid["Lam"]
        if len(Lam) < 2:
            return None
        # mu_r on each slot coordinate of the child
        mus = []
        for i in range(self.nslot):
            q = kid["qs"][i][0]
            mu = {}
            for h in Lam:
                Mh = self.Mg[i][h]
                img = [sum(Mh[a][b] * q[b] for b in range(len(q))) % p for a in range(len(q))]
                j0 = next(b for b in range(len(q)) if q[b] % p)
                lam = img[j0] * m.inv(q[j0]) % p
                if any((img[b] - lam * q[b]) % p for b in range(len(q))):
                    return None
                mu[h] = lam
            mus.append(mu)
        target = {}
        for h in Lam:
            v = m.inv(psi[h])
            for i in range(self.nslot):
                v = v * pow(mus[i][h], degs[i], p) % p
            target[h] = v
        # the W^- eigenline with that Lambda-character
        for lam0 in range(1, p):
            pass
        lines = eigenlines(m, Lam, self.Wm)
        for chi, U in lines:
            if all(chi[h] == target[h] for h in Lam):
                return U
        return None


# --------------------------------------------------------------------------
def eigenlines(m, Lam, Wm):
    """the Lambda-eigenlines of the 2-space Wm, with their characters."""
    p = m.p
    out = []
    seen = set()
    for h in Lam:
        for lam in range(1, p):
            if pow(lam, m.order[h], p) != 1:
                continue
            E = m.eigsp(h, lam)
            I = m.inter(E, Wm) if E else ()
            if I and len(I) == 1 and I not in seen:
                chi = {}
                ok = True
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


def prop(p, a, b):
    return (a[0] * b[1] - a[1] * b[0]) % p == 0


def rank2(p, vecs):
    rows = [v for v in vecs if any(x % p for x in v)]
    if not rows:
        return 0
    for i in range(len(rows)):
        for j in range(i + 1, len(rows)):
            if not prop(p, rows[i], rows[j]):
                return 2
    return 1


def nullspace(p, rows, n):
    R = [list(x) for x in rows]
    r, piv = 0, []
    for c in range(n):
        pr = None
        for i in range(r, len(R)):
            if R[i][c] % p:
                pr = i
                break
        if pr is None:
            continue
        R[r], R[pr] = R[pr], R[r]
        iv = pow(R[r][c], p - 2, p)
        R[r] = [x * iv % p for x in R[r]]
        for i in range(len(R)):
            if i != r and R[i][c] % p:
                f = R[i][c]
                R[i] = [(x - f * y) % p for x, y in zip(R[i], R[r])]
        piv.append(c)
        r += 1
        if r == n:
            break
    free = [c for c in range(n) if c not in piv]
    out = []
    for f in free:
        v = [0] * n
        v[f] = 1
        for i, c in enumerate(piv):
            v[c] = (-R[i][f]) % p
        out.append(v)
    return out


def linear_characters(m, Gam):
    p = m.p
    Gs = list(Gam)
    com = {m.Id}
    changed = True
    while changed:
        changed = False
        for a in list(com) + Gs:
            for b in Gs:
                c = m.mm(m.mm(a, b), m.mm(m.matinv(a), m.matinv(b)))
                if c not in com:
                    com.add(c)
                    changed = True
        cur = list(com)
        for a in cur:
            for b in cur:
                if m.mm(a, b) not in com:
                    com.add(m.mm(a, b))
                    changed = True
    cosets, seen = [], set()
    for g in Gs:
        c = frozenset(m.mm(g, x) for x in com)
        if c not in seen:
            seen.add(c)
            cosets.append(c)
    n = len(cosets)
    roots = [x for x in range(1, p) if pow(x, n, p) == 1]
    out = []
    for assign in itertools.product(roots, repeat=len(cosets)):
        ch = {}
        for i, c in enumerate(cosets):
            for g in c:
                ch[g] = assign[i]
        if all(ch[m.mm(a, b)] == ch[a] * ch[b] % p for a in Gs for b in Gs):
            out.append((tuple(assign), ch))
    return out
