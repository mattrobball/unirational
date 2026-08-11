"""STAGE1_COMPLEX_MAPS -- the TARGET complex of the Klein cubic X.

The receiver side, as a decorated complex of groups: one cell per orbit-type
stratum of X, each cell a G-set of components with pointwise/setwise
stabilizers and an order-0 incidence relation (which point lies on which
curve).  Everything is read off RECEIVER_LEDGER_X and re-verified here at a
split prime, except the two cells that are not F_p-rational (type-II points,
exact-C3 points) and the C5/C11 point cells, which are carried as abstract
G-sets with their sealed incidence rules -- rules that are *proved*, not
sampled (a point of E_sigma or L_sigma is sigma-fixed, so a point whose exact
stabilizer has odd order lies on none of them).

Cells:
  X    dim 3   H=1     S=G        1 component
  E    dim 1   H=C2    S=D12     55   genus 1  (j = 8192/11, no CM)
  L    dim 1   H=C2    S=D12     55   genus 0  (P^1, the only rational receptor)
  PI   dim 0   H=V4    S=V4     165   type-I vertices  (on 2 L's and 1 E)
  PII  dim 0   H=V4    S=V4     165   type-II points   (on 3 E's, on no L)
  P6   dim 0   H=C6    S=C6     110   C6-points  (on L_t)
  P3   dim 0   H=C3    S=C3     220   exact-C3 points (on no E, no L)
  P5a  dim 0   H=C5    S=C5     132   C5-points, orbit a
  P5b  dim 0   H=C5    S=C5     132   C5-points, orbit b
  P11  dim 0   H=C11   S=C11     60   C11-points
"""
import itertools
import os
import sys
from collections import defaultdict

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from psl211 import Model  # noqa: E402


class Target:
    """Components are hashable labels; every cell is an explicit G-set."""

    def __init__(self, p, verbose=False):
        self.m = Model(p)
        self.p = p
        self.verbose = verbose
        self._build()

    def _log(self, s):
        if self.verbose:
            print("  [p=%d] %s" % (self.p, s), flush=True)

    # ------------------------------------------------------------------
    def _build(self):
        m = self.m
        p = self.p
        self.invols = [A for A in m.G if m.order[A] == 2]
        assert len(self.invols) == 55
        self.plus = {s: m.eigsp(s, 1) for s in self.invols}
        self.minus = {s: m.eigsp(s, p - 1) for s in self.invols}
        for s in self.invols:
            assert len(self.plus[s]) == 3 and len(self.minus[s]) == 2
        self.v4s = m.klein_fours()
        assert len(self.v4s) == 55
        # ---- cells ----
        self.comp = {}          # cell -> list of component labels
        self.stab = {}          # (cell, label) -> setwise stabilizer (frozenset)
        self.pstab = {}         # (cell, label) -> pointwise stabilizer
        self.comp["X"] = ["X"]
        self.stab[("X", "X")] = frozenset(m.G)
        self.pstab[("X", "X")] = frozenset([m.Id])
        self.comp["E"] = list(self.invols)
        self.comp["L"] = list(self.invols)
        for s in self.invols:
            D12 = frozenset(g for g in m.G if m.mm(g, s) == m.mm(s, g))
            assert len(D12) == 12
            for cell in ("E", "L"):
                self.stab[(cell, s)] = D12
                self.pstab[(cell, s)] = frozenset([m.Id, s])
        # type-I vertices: the three 1-dim V4-character eigenspaces, all on X
        self.comp["PI"] = []
        self.typeI_of = {}
        for K in self.v4s:
            (z, s, r), (A, B, C, D) = m.v4_decomp(K)
            assert len(A) == 2 and len(B) == len(C) == len(D) == 1
            for U, sig in ((B, z), (C, s), (D, r)):
                v = U[0]
                assert m.F(v) % p == 0, "type-I vertex off X"
                lab = U
                self.comp["PI"].append(lab)
                self.stab[("PI", lab)] = frozenset(K)
                self.pstab[("PI", lab)] = frozenset(K)
                self.typeI_of[lab] = (frozenset(K), sig)
        self.comp["PI"] = sorted(set(self.comp["PI"]))
        assert len(self.comp["PI"]) == 165, len(self.comp["PI"])
        # type-II: abstract G-set G/V4 (cosets), stabilizer the V4
        K0 = frozenset(self.v4s[0])
        self.comp["PII"] = self._cosets(K0)
        assert len(self.comp["PII"]) == 165
        for lab in self.comp["PII"]:
            S = self._coset_stab(lab, K0)
            self.stab[("PII", lab)] = S
            self.pstab[("PII", lab)] = S
        # C6-points on X: the C6-eigenpoints on the minus-line of the involution
        self.comp["P6"] = []
        self.c6_of = {}
        c6s = [frozenset(self._cyc(g)) for g in m.G if m.order[g] == 6]
        c6s = sorted(set(c6s), key=lambda H: sorted(H))
        assert len(c6s) == 55, len(c6s)
        for H in c6s:
            t = [x for x in H if m.order[x] == 2][0]
            g = [x for x in H if m.order[x] == 6][0]
            pts = []
            for lam in range(1, p):
                if pow(lam, 6, p) != 1:
                    continue
                E = m.eigsp(g, lam)
                if E and len(E) == 1 and self._in(E[0], self.minus[t]):
                    pts.append(E)
            assert len(pts) == 2, (len(pts),)
            for U in pts:
                assert m.F(U[0]) % p == 0
                self.comp["P6"].append(U)
                self.stab[("P6", U)] = H
                self.pstab[("P6", U)] = H
                self.c6_of[U] = (H, t)
        self.comp["P6"] = sorted(set(self.comp["P6"]))
        assert len(self.comp["P6"]) == 110, len(self.comp["P6"])
        # abstract point cells
        C30 = frozenset(self._cyc([g for g in m.G if m.order[g] == 3][0]))
        C50 = frozenset(self._cyc([g for g in m.G if m.order[g] == 5][0]))
        C110 = frozenset(self._cyc([g for g in m.G if m.order[g] == 11][0]))
        for cell, H0, n in (("P3", C30, 220), ("P5a", C50, 132),
                            ("P5b", C50, 132), ("P11", C110, 60)):
            labs = self._cosets(H0)
            assert len(labs) == n, (cell, len(labs))
            self.comp[cell] = [(cell, x) for x in labs]
            for x in labs:
                S = self._coset_stab(x, H0)
                self.stab[(cell, (cell, x))] = S
                self.pstab[(cell, (cell, x))] = S
        self._log("target cells: " + str({c: len(v) for c, v in self.comp.items()}))
        self._incidence()

    # ------------------------------------------------------------------
    def _cyc(self, g):
        m = self.m
        H, B = [m.Id], g
        while B != m.Id:
            H.append(B)
            B = m.mm(B, g)
        return H

    def _cosets(self, H0):
        m = self.m
        seen, out = set(), []
        for g in m.G:
            c = frozenset(m.mm(g, h) for h in H0)
            if c not in seen:
                seen.add(c)
                out.append(c)
        return sorted(out, key=lambda c: sorted(c))

    def _coset_stab(self, c, H0):
        """stabilizer of the coset gH0 under LEFT multiplication = g H0 g^-1."""
        m = self.m
        g = sorted(c)[0]
        gi = m.matinv(g)
        # gH0 = c  =>  the point stabilizer is g H0 g^-1
        return frozenset(m.mm(m.mm(g, h), gi) for h in H0)

    def _in(self, v, U):
        return self.m.rank([list(x) for x in U] + [list(v)]) == len(U)

    # ------------------------------------------------------------------
    def _incidence(self):
        """on_L[(cell,lab)] = set of sigma with the point on L_sigma; likewise on_E."""
        m = self.m
        self.on_L = defaultdict(set)
        self.on_E = defaultdict(set)
        for lab in self.comp["PI"]:
            K, sig = self.typeI_of[lab]
            for s in K:
                if s == m.Id:
                    continue
                if self._in(lab[0], self.minus[s]):
                    self.on_L[("PI", lab)].add(s)
                elif self._in(lab[0], self.plus[s]):
                    self.on_E[("PI", lab)].add(s)
            assert len(self.on_L[("PI", lab)]) == 2, self.on_L[("PI", lab)]
            assert len(self.on_E[("PI", lab)]) == 1
        for lab in self.comp["PII"]:
            K = self.stab[("PII", lab)]
            self.on_E[("PII", lab)] = set(x for x in K if x != m.Id)
            self.on_L[("PII", lab)] = set()
        for lab in self.comp["P6"]:
            H, t = self.c6_of[lab]
            self.on_L[("P6", lab)] = {t}
            self.on_E[("P6", lab)] = set()
        for cell in ("P3", "P5a", "P5b", "P11"):
            for lab in self.comp[cell]:
                self.on_L[(cell, lab)] = set()
                self.on_E[(cell, lab)] = set()

    # ------------------------------------------------------------------
    def act(self, g, cell, lab):
        m = self.m
        if cell == "X":
            return "X"
        if cell in ("E", "L"):
            return m.mm(m.mm(g, lab), m.matinv(g))
        if cell in ("PI", "P6"):
            return m.canon([list(m.act(g, v)) for v in lab])
        if cell == "PII":
            return frozenset(m.mm(g, x) for x in lab)
        return (cell, frozenset(m.mm(g, x) for x in lab[1]))

    def contains(self, cell_c, lab_c, cell_d, lab_d):
        """is the target component (cell_d,lab_d) contained in (cell_c,lab_c)?"""
        if (cell_c, lab_c) == (cell_d, lab_d):
            return True
        if cell_c == "X":
            return True
        if cell_c == "L":
            return lab_c in self.on_L[(cell_d, lab_d)]
        if cell_c == "E":
            return lab_c in self.on_E[(cell_d, lab_d)]
        return False
