"""STAGE1_COMPLEX_MAPS -- the SOURCE complex, rebuilt at COMPONENT level.

Independently reconstructs the stabilized-strata complex of the terminus `Z` of
the STANDARD_FORM_PW tower over `P(W) = P^4`, following the chart form of
TERMINUS_STRATA_PW Theorems 1-3 (`Z` = the maximal De Concini-Procesi wonderful
model of the level-0 subspace arrangement `A`), but at component level: each of
the 11076 components is produced as an explicit flag + eigen datum over `F_p`,
with its exact pointwise stabilizer, its setwise stabilizer, an orbit
transversal, and its closure incidences.

Not a char-0 proof on its own: pure group theory / linear algebra with the 660
matrices of the Klein 5-representation reduced at a split prime, replayed at two
primes and cross-checked row-for-row against the sealed TERMINUS_STRATA_PW
census (`inputs/terminus_*.json`).
"""
import itertools
import os
import sys
from collections import defaultdict

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from psl211 import Model  # noqa: E402

FULL = None  # set per model


def gname(m, H):
    n = len(H)
    if n == 1:
        return "1"
    if n == 4:
        return "V4"
    if n == 12:
        return "D12"
    if n == 660:
        return "PSL(2,11)"
    if n in (2, 3, 5, 6, 11):
        return "C%d" % n
    return "?%d" % n


class Source:
    def __init__(self, p, verbose=False):
        self.m = Model(p)
        self.p = p
        self.verbose = verbose
        self.W = tuple(tuple(int(i == j) for j in range(5)) for i in range(5))
        self._log("|G| = %d" % len(self.m.G))
        self._arrangement()
        self._abelian()
        self._chains()
        self._components()
        self._orbits()

    def _log(self, s):
        if self.verbose:
            print("  [p=%d] %s" % (self.p, s), flush=True)

    # -------------------------------------------------- level-0 arrangement
    def _arrangement(self):
        m, p = self.m, self.p
        roots = {}
        for n in (2, 3, 5, 6, 11):
            roots[n] = [x for x in range(1, p) if pow(x, n, p) == 1]
        sp = set()
        for A in m.G:
            n = m.order[A]
            if n == 1:
                continue
            for lam in roots[n]:
                E = m.eigsp(A, lam)
                if E and len(E) < 5:
                    sp.add(E)
        changed = True
        while changed:
            changed = False
            for U, V in itertools.combinations(sorted(sp), 2):
                I = m.inter(U, V)
                if I and I not in sp:
                    sp.add(I)
                    changed = True
        self.A = sorted(sp)
        self.Aset = set(self.A)
        self.byd = defaultdict(list)
        for U in self.A:
            self.byd[len(U)].append(U)
        self._log("arrangement A: " + str({d: len(v) for d, v in sorted(self.byd.items())}))
        # containment poset on A u {0, W}
        self.inside = {}
        for U in self.A:
            for V in self.A:
                self.inside[(U, V)] = (len(U) <= len(V) and
                                       m.rank(list(U) + list(V)) == len(V))

    def sub(self, U, V):
        """U subset of V, for arbitrary subspaces given as canonical bases."""
        if not U:
            return True
        if not V:
            return False
        return self.m.rank(list(U) + list(V)) == len(V)

    # -------------------------------------------------- abelian subgroups
    def _abelian(self):
        m = self.m
        abel = set()
        for A in m.G:
            H, B = [m.Id], A
            while B != m.Id:
                H.append(B)
                B = m.mm(B, A)
            abel.add(frozenset(H))
        inv = [A for A in m.G if m.order[A] == 2]
        for a, b in itertools.combinations(inv, 2):
            if m.mm(a, b) == m.mm(b, a):
                abel.add(frozenset([m.Id, a, b, m.mm(a, b)]))
        self.abelian = sorted(abel, key=lambda H: (len(H), sorted(H)))
        cnt = defaultdict(int)
        for H in self.abelian:
            cnt[gname(m, H)] += 1
        self._log("abelian subgroups: %d %s" % (len(self.abelian), dict(cnt)))
        # character decomposition of W under each abelian H
        self.chardec = {}
        for H in self.abelian:
            self.chardec[H] = self._decomp(H)

    def _decomp(self, H):
        """W = sum_chi W_chi ; returns list of (chi, subspace) with chi a tuple of
        eigenvalues indexed by sorted(H)."""
        m = self.m
        gens = sorted(H)
        pieces = [((), self.W)]
        for g in gens:
            if g == m.Id:
                continue
            new = []
            for chi, U in pieces:
                for lam in range(1, self.p):
                    if pow(lam, m.order[g], self.p) != 1:
                        continue
                    E = m.inter(U, m.eigsp(g, lam))
                    if E:
                        new.append((chi + (lam,), E))
            pieces = new
        return pieces

    def slot_pieces(self, H, lo, hi):
        """character eigenspaces of hi/lo, returned LIFTED (each contains lo)."""
        m = self.m
        out = []
        for chi, Wc in self.chardec[H]:
            I = m.inter(Wc, hi) if hi != self.W else Wc
            up = m.canon(list(I) + list(lo)) if (I or lo) else ()
            lodim = len(lo)
            if up and len(up) > lodim:
                out.append((chi, up))
        return out

    # -------------------------------------------------- flags in A
    def _chains(self):
        cont = defaultdict(list)
        for U in self.A:
            for V in self.A:
                if len(V) > len(U) and self.inside[(U, V)]:
                    cont[U].append(V)
        self.cont = cont
        chains = [()]
        frontier = [(U,) for U in self.A]
        while frontier:
            chains.extend(frontier)
            nf = []
            for C in frontier:
                for V in cont[C[-1]]:
                    nf.append(C + (V,))
            frontier = nf
        self.chains = chains
        self._log("flags in A: %d %s" %
                  (len(chains),
                   {k: sum(1 for c in chains if len(c) == k) for k in range(4)}))

    # -------------------------------------------------- components
    def _components(self):
        m = self.m
        comps = {}
        for C in self.chains:
            k = len(C)
            Us = [()] + list(C)
            His = list(C) + [self.W]
            # elements of A strictly between U_i and U_{i+1}, LIFTED by U_i
            between = []
            for i in range(k + 1):
                lo, hi = Us[i], His[i]
                bs = []
                for V in self.A:
                    if hi != self.W and not self.inside[(V, hi)]:
                        continue
                    if V == hi:
                        continue
                    if lo and not self.inside[(lo, V)]:
                        continue          # only elements strictly BETWEEN U_i and U_{i+1}
                    if lo and V == lo:
                        continue
                    bs.append(V)
                between.append(bs)
            if k == 0:
                stabC = list(m.G)
            else:
                stabC = [g for g in m.G
                         if all(m.canon([list(m.act(g, v)) for v in U]) == U for U in C)]
            sset = frozenset(stabC)
            for H in self.abelian:
                if not H <= sset:
                    continue
                slots = []
                for i in range(k + 1):
                    slots.append(self.slot_pieces(H, Us[i], His[i]))
                if any(not s for s in slots):
                    continue
                for choice in itertools.product(*slots):
                    chis = [c[0] for c in choice]
                    lifted = tuple(c[1] for c in choice)
                    if any(chis[i - 1] == chis[i] for i in range(1, k + 1)):
                        continue                      # openness
                    ok = True
                    for i in range(k + 1):
                        Ai = lifted[i]
                        for V in between[i]:
                            if self.sub(Ai, V):
                                ok = False
                                break
                        if not ok:
                            break
                    if not ok:
                        continue                      # validity
                    comps[(C, lifted)] = H
        # exactness: `lifted` must be the eigen-datum of the EXACT stabilizer
        final = []
        for (C, lifted), H in comps.items():
            Hx = frozenset(self.exact_stab(C, lifted))
            if Hx == H:
                final.append((C, lifted, Hx))
                continue
            if Hx not in self.chardec:
                continue                              # non-abelian: cannot occur
            Us = [()] + list(C)
            His = list(C) + [self.W]
            ok = True
            for i in range(len(lifted)):
                if lifted[i] not in [q[1] for q in self.slot_pieces(Hx, Us[i], His[i])]:
                    ok = False
                    break
            if ok:
                final.append((C, lifted, Hx))
        self.comps = sorted(final, key=lambda t: (len(t[0]), t[0], t[1]))
        self.cindex = {(C, L): i for i, (C, L, _) in enumerate(self.comps)}
        self._log("components: %d" % len(self.comps))

    def exact_stab(self, C, lifted):
        m = self.m
        Us = [()] + list(C)
        out = []
        for g in m.G:
            if any(m.canon([list(m.act(g, v)) for v in U]) != U for U in C):
                continue
            good = True
            for i, Ai in enumerate(lifted):
                if m.canon([list(m.act(g, v)) for v in Ai]) != Ai:
                    good = False
                    break
                if not self.scalar_on(g, Us[i], Ai):
                    good = False
                    break
            if good:
                out.append(g)
        return out

    def scalar_on(self, g, lo, Ai):
        """g acts by a scalar on Ai/lo?"""
        m = self.m
        if len(Ai) - len(lo) <= 0:
            return True
        for chi, Wc in self._gdec(g):
            pass
        # decompose Ai as lo + complement, test via eigen-structure of g on Ai
        basis = [list(v) for v in lo]
        comp = []
        for v in Ai:
            if m.rank(basis + [list(v)]) > len(basis):
                basis.append(list(v))
                comp.append(list(v))
        for lam in self._eigvals(g):
            E = m.eigsp(g, lam)
            # candidate: g == lam on Ai/lo  <=>  Ai subset of E + lo
            EL = m.canon(list(E) + list(lo)) if lo else E
            if self.sub(Ai, EL):
                return True
        return False

    def _gdec(self, g):
        return []

    def _eigvals(self, g):
        m = self.m
        if not hasattr(self, "_evc"):
            self._evc = {}
        if g not in self._evc:
            n = m.order[g]
            self._evc[g] = [x for x in range(1, self.p) if pow(x, n, self.p) == 1
                            and m.eigsp(g, x)]
        return self._evc[g]

    # -------------------------------------------------- orbits
    def _orbits(self):
        m = self.m
        gens = []
        for g in m.G:
            if m.order[g] == 11:
                gens.append(g)
                break
        for g in m.G:
            if m.order[g] == 2:
                gens.append(g)
                break
        cl, fr = {m.Id}, [m.Id]
        while fr:
            nf = []
            for a in fr:
                for g in gens:
                    b = m.mm(a, g)
                    if b not in cl:
                        cl.add(b)
                        nf.append(b)
            fr = nf
        assert len(cl) == 660
        self.gens = gens
        self.orbit_of = {}
        self.transversal = {}
        self.reps = []
        for idx in range(len(self.comps)):
            if idx in self.orbit_of:
                continue
            oid = len(self.reps)
            self.reps.append(idx)
            self.orbit_of[idx] = oid
            self.transversal[idx] = m.Id
            fr = [idx]
            while fr:
                nf = []
                for j in fr:
                    C, L, _ = self.comps[j]
                    for g in gens:
                        t = self.cindex[self.act(g, C, L)]
                        if t not in self.orbit_of:
                            self.orbit_of[t] = oid
                            self.transversal[t] = m.mm(g, self.transversal[j])
                            nf.append(t)
                fr = nf
        self._log("G-orbits of components: %d" % len(self.reps))

    def act(self, g, C, L):
        m = self.m
        return (tuple(m.canon([list(m.act(g, v)) for v in U]) for U in C),
                tuple(m.canon([list(m.act(g, v)) for v in Ai]) for Ai in L))

    # -------------------------------------------------- closure incidences
    def closure_le(self, i, j):
        """component i lies in the closure of component j."""
        if i == j:
            return False
        m = self.m
        C, L, _ = self.comps[i]
        Cp, Lp, _ = self.comps[j]
        if not set(Cp) <= set(C):
            return False
        Us = [()] + list(C)
        His = list(C) + [self.W]
        for r in range(len(C) + 1):
            lo, hi = Us[r], His[r]
            # the slot of C' covering the r-th slot of C
            s = sum(1 for U in Cp if self.sub(U, lo))
            Ap = Lp[s]
            I = m.inter(Ap, hi) if hi != self.W else Ap
            Ind = m.canon(list(I) + list(lo)) if (I or lo) else ()
            if not self.sub(L[r], Ind):
                return False
        return True

    def above(self, i):
        return [j for j in range(len(self.comps)) if self.closure_le(i, j)]

    # -------------------------------------------------- row summary
    def rowdata(self):
        m = self.m
        rows = []
        for oid, r in enumerate(self.reps):
            C, L, H = self.comps[r]
            Us = [()] + list(C)
            dim = sum(len(L[i]) - len(Us[i]) - 1 for i in range(len(L)))
            size = sum(1 for v in self.orbit_of.values() if v == oid)
            stab = [g for g in m.G if self.act(g, C, L) == (C, L)]
            rows.append(dict(oid=oid, rep=r, K=gname(m, H), K_order=len(H), dim=dim,
                             n_orbit=size, setwise=gname(m, frozenset(stab)),
                             setwise_order=len(stab),
                             chain=[len(U) for U in C]))
        return rows
