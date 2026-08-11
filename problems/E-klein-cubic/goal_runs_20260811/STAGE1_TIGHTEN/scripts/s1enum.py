"""STAGE1_COMPLEX_MAPS -- Layer 1: the exact enumeration of Stage-1 assignments.

A Stage-1 assignment is a G-equivariant, band-injective, closure-monotone map
from the components of the source complex (terminus Z of the STANDARD_FORM_PW
tower over P(W)) to the components of the target complex (orbit-type strata of
the Klein cubic X), sending each source stratum to the target stratum that
receives its generic point.

Values a source row may take:
  ("dom", "X",  "X")     the free stratum, dominant onto X
  ("dom", "L",  sigma)   dominant (= surjective) onto the minus-line L_sigma
  ("gen", cell, sigma)   constant at an UNPINNED generic point of E_sigma / L_sigma
  ("pt",  cell, label)   constant at a specific point-component of the target

Constraints:
  (A1) band injectivity  : H_R fixes the image pointwise
  (A2) equivariance      : Stab_G(F_R) stabilizes the image
  (A3) rationality/genus : a rational source stratum cannot dominate a genus-1
                           target, so "dom" is available only for the L cell
  (A4) closure monotone  : im(F) subset closure(im(F')) whenever F subset closure(F')
"""
import os
import sys
from collections import defaultdict

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from s1source import Source, gname   # noqa: E402
from s1target import Target          # noqa: E402

POINT_CELLS = ("PI", "PII", "P6", "P3", "P5a", "P5b", "P11")


class Stage1:
    def __init__(self, p, verbose=False):
        self.verbose = verbose
        self.S = Source(p, verbose=verbose)
        self.T = Target(p, verbose=verbose)
        self.m = self.S.m
        self.p = p
        assert self.S.m.G == self.T.m.G, "the two models must share the group"
        self._rows()
        self._above()
        self._values()
        self._propagate()

    def _log(self, s):
        if self.verbose:
            print("  [p=%d] %s" % (self.p, s), flush=True)

    # ------------------------------------------------------------------
    def _rows(self):
        S = self.S
        m = self.m
        self.rows = S.rowdata()
        # order rows by (-dim, K) so that the labels match TERMINUS's poset order
        self.rows.sort(key=lambda r: (-r["dim"], ["1", "C2", "C3", "V4", "C5", "C6",
                                                  "C11"].index(r["K"]), r["n_orbit"],
                                      r["oid"]))
        for i, r in enumerate(self.rows):
            r["id"] = i
        self.byoid = {r["oid"]: r for r in self.rows}
        for r in self.rows:
            C, L, H = S.comps[r["rep"]]
            r["H"] = H
            r["S"] = frozenset(g for g in m.G if S.act(g, C, L) == (C, L))
            assert len(r["S"]) == r["setwise_order"]

    # ------------------------------------------------------------------
    def _above(self):
        """component-level list of strata above each row representative."""
        S = self.S
        bychain = defaultdict(list)
        for i, (C, L, H) in enumerate(S.comps):
            bychain[frozenset(C)].append(i)
        self.above = {}
        for r in self.rows:
            rep = r["rep"]
            C, L, H = S.comps[rep]
            out = []
            fc = frozenset(C)
            for sub, idxs in bychain.items():
                if not sub <= fc:
                    continue
                for j in idxs:
                    if S.closure_le(rep, j):
                        out.append(j)
            self.above[r["id"]] = out
        n = sum(len(v) for v in self.above.values())
        # orbit-level relation count (matches TERMINUS's 145)
        rel = set()
        for r in self.rows:
            for j in self.above[r["id"]]:
                rel.add((r["id"], self.byoid[S.orbit_of[j]]["id"]))
        self.orbit_relations = rel
        self._log("closure: %d component-level relations at the 80 representatives, "
                  "%d orbit-level relations" % (n, len(rel)))

    # ------------------------------------------------------------------
    def _values(self):
        m, T = self.m, self.T
        self.vals = {}
        for r in self.rows:
            H, Sg, dim = r["H"], r["S"], r["dim"]
            out = []
            if r["K"] == "1":
                out.append(("dom", "X", "X"))
                self.vals[r["id"]] = out
                continue
            sig = None
            if len(H) == 2:
                sig = [x for x in H if x != m.Id][0]
            # dominant onto L_sigma
            if sig is not None and dim >= 1 and Sg <= T.stab[("L", sig)]:
                out.append(("dom", "L", sig))
            # constant at an unpinned generic point of E_sigma / L_sigma
            if sig is not None and Sg == H:
                out.append(("gen", "E", sig))
                out.append(("gen", "L", sig))
            # constant at a point-component
            for cell in POINT_CELLS:
                for lab in T.comp[cell]:
                    st = T.stab[(cell, lab)]
                    if H <= st and Sg <= st:
                        out.append(("pt", cell, lab))
            self.vals[r["id"]] = out
        self._log("raw value-set sizes: " +
                  str(sorted(set(len(v) for v in self.vals.values()))))

    # ------------------------------------------------------------------
    def img_contains(self, va, ta, vb, tb):
        """does the image described by (vb at transversal tb) contain the image
        described by (va at transversal ta)?  i.e.  im_a subset im_b."""
        m, T = self.m, self.T
        kb, cb, lb = vb
        ka, ca, la = va
        if kb == "dom" and cb == "X":
            return True
        # move both to their actual positions
        if kb == "dom":                       # image is the curve  tb . L_sigma
            sb = T.act(tb, "L", lb)
            if ka == "dom":
                return T.act(ta, "L", la) == sb
            if ka == "gen":
                return ca == "L" and T.act(ta, "L", la) == sb
            lab = T.act(ta, ca, la)
            return sb in T.on_L[(ca, lab)]
        if kb == "gen":
            # image is a single, unpinned point p with G_p = <sigma> exactly
            sb = T.act(tb, cb, lb)
            if ka == "gen":
                return ca == cb and T.act(ta, ca, la) == sb
            return False                      # a pinned point is not the generic one
        # kb == "pt": image is the single point tb . lb
        pb = T.act(tb, cb, lb)
        if ka != "pt":
            return False
        return (ca, T.act(ta, ca, la)) == (cb, pb)

    # ------------------------------------------------------------------
    def _propagate(self):
        """arc consistency over the closure constraints."""
        S = self.S
        dom = {r["id"]: list(self.vals[r["id"]]) for r in self.rows}
        # constraint list: (child row id, child transversal=Id, parent row id, parent transversal)
        cons = []
        for r in self.rows:
            for j in self.above[r["id"]]:
                pid = self.byoid[S.orbit_of[j]]["id"]
                cons.append((r["id"], self.m.Id, pid, S.transversal[j]))
        self.cons = cons
        changed = True
        while changed:
            changed = False
            for (a, ta, b, tb) in cons:
                na = [va for va in dom[a]
                      if any(self.img_contains(va, ta, vb, tb) for vb in dom[b])]
                if len(na) != len(dom[a]):
                    dom[a] = na
                    changed = True
                nb = [vb for vb in dom[b]
                      if any(self.img_contains(va, ta, vb, tb) for va in dom[a])]
                if len(nb) != len(dom[b]):
                    dom[b] = nb
                    changed = True
        self.dom = dom
        self._log("after arc consistency: value-set sizes " +
                  str(sorted((r["id"], len(dom[r["id"]])) for r in self.rows)))

    # ------------------------------------------------------------------
    def blocks(self):
        """connected components of the constraint graph (rows with >1 value)."""
        par = {r["id"]: r["id"] for r in self.rows}

        def find(x):
            while par[x] != x:
                par[x] = par[par[x]]
                x = par[x]
            return x

        for (a, ta, b, tb) in self.cons:
            if len(self.dom[a]) > 1 and len(self.dom[b]) > 1:
                ra, rb = find(a), find(b)
                if ra != rb:
                    par[ra] = rb
        gs = defaultdict(list)
        for r in self.rows:
            if len(self.dom[r["id"]]) > 1:
                gs[find(r["id"])].append(r["id"])
        return list(gs.values())

    def count_block(self, ids):
        """exact number of joint assignments on one constraint block."""
        idset = set(ids)
        local = [(a, ta, b, tb) for (a, ta, b, tb) in self.cons
                 if a in idset and b in idset]
        ids = sorted(ids, key=lambda i: len(self.dom[i]))
        sols = 0
        assign = {}

        def rec(k):
            nonlocal sols
            if k == len(ids):
                sols += 1
                return
            i = ids[k]
            for v in self.dom[i]:
                assign[i] = v
                good = True
                for (a, ta, b, tb) in local:
                    if a in assign and b in assign:
                        if not self.img_contains(assign[a], ta, assign[b], tb):
                            good = False
                            break
                if good:
                    rec(k + 1)
            assign.pop(i, None)

        rec(0)
        return sols
