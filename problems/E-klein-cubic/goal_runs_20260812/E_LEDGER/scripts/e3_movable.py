#!/usr/bin/env python3
"""
E3 -- the movable-cone linear program.

AUTHORITY: theory/SCHEME_MAP_CONSEQUENCES_20260812.md section 3.1, "E3
systematically":  for every covering family of curves `c` on `Z`,
`d(H.c) >= sum_orbit m_i (D_i.c)`, and the executable step is to enumerate
the extremal covering families and emit ALL such inequalities as one LP
against the 14 orbit multiplicities.

----------------------------------------------------------------------
1.  WHICH LINE FAMILIES EXIST  (Lemma E3-L, unconditional)
----------------------------------------------------------------------
A line through `z` with direction `w` meets the centre with span `V` iff
`<z,w> cap V != 0` iff `w in V + <z>`.  So lines through `z` meeting all of
`C_1,...,C_k` exist iff

        dim ( cap_i (V_i + <z>) )  >=  2 .                          (*)

Since `dim(U cap U') >= dim U + dim U' - 5` and `dim(V_i + <z>) = dim V_i + 1`
for `z` off `C_i`, (*) holds for EVERY `z` as soon as
`sum_i (dim V_i + 1) - 5(k-1) >= 2`.  With `dim V = 1, 2, 3` for a point-,
line- and plane-centre this is satisfied by

        k = 1 : any single centre
        k = 2 : two planes (4+4-5 = 3);  a line-centre and a plane (3+4-5 = 2)
        k = 3 : three planes (4+4+4-10 = 2)

and by no other combination of census types.  Because the bound is valid at
every `z`, each of these families is COVERING with no genericity hypothesis.

----------------------------------------------------------------------
2.  WHAT A LINE'S STRICT TRANSFORM ACTUALLY MEETS  (Lemma E3-T)
----------------------------------------------------------------------
`Z` is the wonderful model: the 940 points are blown up, then the (strict
transforms of the) 220 lines, then the 55 planes.  Let `l` be a line not
contained in any member of the arrangement `A`, meeting `A` in the points
`y_1,...,y_s`.  `A` is closed under intersection, so each `y` lies in a
UNIQUE MINIMAL member `V_min(y)`.  Then for the strict transform `c`:

        D_V . c  =  #{ t : V_min(y_t) = V }.

*Proof.* Blow up in increasing dimension.  At a point `y` with
`V_min(y) = V0`, every member `V` containing `y` contains `V0`.  After the
centres of dimension `< dim V0` are blown up, `l` still meets `V0~`
transversally at the point over `y` (nothing separates them: `y` is a
generic point of `V0`), giving `D_{V0}.c = 1`.  For `V supsetneq V0`, at the
stage where `V~` is blown up the strict transform of `l` has already been
separated from `V~`: the direction of `l` at `y` does not lie in `V`
(otherwise `l subset V`, excluded), so the two strict transforms are
disjoint over `y`.  Hence `D_V.c` gets no contribution from `y`. QED

This is why "meets three plus-planes" must be read as "meets them at three
points each of which is a GENERIC point of a plus-plane", and why a line
through a `V4`-type-I point (which lies on a plus-plane) contributes to the
point orbit only.  The machine below applies exactly this rule.

----------------------------------------------------------------------
3.  FLAG E3-DEGREE  (recorded; branch STOPPED, not exercised)
----------------------------------------------------------------------
Covering families of curves of degree >= 2 are NOT enumerated here, and they
are strictly stronger.  Example: a general 2-plane `Pi` through `z` meets ALL
55 plus-planes (two 2-planes in P^4 always meet), so a plane curve of degree
`e` in `Pi` through `z` and through `min(55, e(e+3)/2 - 1)` of those 55
points is a covering family, giving `e.d >= min(55, e(e+3)/2 - 1) m_P`; at
`e = 9` that is `d >= (53/9) m_P`, better than the degree-1 bound
`d >= 3 m_P`.  Certifying it needs irreducibility of a member of a
0-dimensional linear system through 54 NON-general points, which this packet
does not establish.  CONSEQUENCE, stated everywhere the LP is used: the LP
below is an OUTER approximation -- its feasible set CONTAINS the true
movable-cone-constrained set.  Nothing here may be read as "the movable cone
permits x".

python3 standard library only; exact.
"""

import itertools
import os
import sys
from collections import Counter
from fractions import Fraction

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)

import census                                      # noqa: E402
from census import Arrangement, random_point       # noqa: E402


# ---------------------------------------------------------------- geometry

class Geometry:
    """The arrangement plus the fast predicates E3 needs."""

    def __init__(self, p):
        self.A = Arrangement(p)
        self.m = self.A.m
        self.orbits = {i: sorted(o) for i, o in enumerate(self.A.orbits)}
        self.dims = {i: len(next(iter(o))) - 1 for i, o in enumerate(self.A.orbits)}
        self.sizes = {i: len(o) for i, o in enumerate(self.A.orbits)}
        self.members = [(i, V) for i in sorted(self.orbits) for V in self.orbits[i]]
        self.planes = [i for i in self.orbits if self.dims[i] == 2]
        self.lines = [i for i in self.orbits if self.dims[i] == 1]
        self.points = [i for i in self.orbits if self.dims[i] == 0]
        # containment order on members (V contained in V'), for V_min
        self._index = {V: k for k, (i, V) in enumerate(self.members)}

    # --- fast tests -----------------------------------------------------
    def meet_dim(self, U, V):
        """dim(U cap V) via rank: dim U + dim V - rank(U + V)."""
        r = self.m.rank([list(x) for x in U] + [list(x) for x in V])
        return len(U) + len(V) - r

    def line_incidence(self, L):
        """
        Lemma E3-T applied to the line L (a 2-dim subspace of W).
        Returns (counts per orbit, list of orbits containing L).
        """
        contained = []
        hit = []                       # (member index, orbit, point)
        for k, (i, V) in enumerate(self.members):
            dd = self.meet_dim(L, V)
            if dd == 0:
                continue
            if dd >= 2:
                contained.append(i)
                continue
            hit.append((k, i, V))
        if contained:
            return None, contained
        # group the hits by the intersection point
        by_pt = {}
        for k, i, V in hit:
            I = self.m.inter(L, V)
            by_pt.setdefault(I, []).append((k, i, V))
        cnt = Counter()
        for pt, lst in by_pt.items():
            # the minimal member: the one contained in all the others
            best = None
            for k, i, V in lst:
                if all(self.meet_dim(V, V2) == len(V) for _, _, V2 in lst):
                    best = (k, i, V)
                    break
            if best is None:
                # the arrangement is closed under intersection, so this
                # cannot happen; surface it loudly rather than guess
                raise RuntimeError("no minimal member at a point: %r" % (pt,))
            cnt[best[1]] += 1
        return cnt, []

    def cap(self, z, Vs):
        return census.lines_through_z_meeting(self.m, z, list(Vs))

    def general_point(self, seed):
        z = random_point(self.m, seed)
        for i, V in self.members:
            if self.m.contains_pt(V, z):
                return None
        return z

    def directions(self, capsp, tries=8):
        out = list(capsp)
        k = len(capsp)
        coeffs = [(1, 1), (1, 2), (2, 1), (1, 3), (3, 1), (1, 5), (5, 2), (7, 3)]
        for a, b in coeffs[:tries]:
            for i in range(k):
                for j in range(i + 1, k):
                    out.append(tuple((a * capsp[i][t] + b * capsp[j][t]) % self.m.p
                                     for t in range(5)))
        return out

    def witness(self, z, Vs, target=None):
        """
        A clean line through z meeting all of Vs; returns (L, counts).
        If `target` is given (a Counter over orbit indices) the incidence
        vector must dominate it -- this is how we insist that each requested
        centre is met at a GENERIC point of itself (Lemma E3-T) rather than
        at a deeper stratum inside it.
        """
        c = self.cap(z, Vs)
        if not c or len(c) < 2:
            return None
        seen = set()
        for w in self.directions(c):
            if self.m.rank([list(z), list(w)]) != 2:
                continue
            L = self.m.canon([list(z), list(w)])
            if L in seen:
                continue
            seen.add(L)
            cnt, contained = self.line_incidence(L)
            if cnt is None:
                continue
            # the family must actually realise the requested incidences
            ok = all(self.meet_dim(L, V) == 1 for V in Vs)
            if ok and target is not None:
                # EXACT match: the generic member of the family meets the
                # arrangement in exactly the requested pattern, so the LP row
                # we emit is the one a generic member really satisfies.
                ok = (dict(cnt) == {k: v for k, v in target.items() if v})
            if ok:
                return L, cnt
        return None


# ------------------------------------------------------- family enumeration

def _spread(it, budget, cap=60000):
    """
    Deterministic, evenly-spread sample of an iterator.  Lexicographic
    prefixes of C(55,3) are highly correlated (they all share the first two
    planes), so a plain `islice` is a poor sample; this takes `budget`
    evenly spaced items out of the first `cap`.
    """
    items = list(itertools.islice(it, cap))
    if len(items) <= budget:
        return items
    step = len(items) / float(budget)
    return [items[int(i * step)] for i in range(budget)]


def enumerate_families(G, seeds=tuple(range(200, 260)), budget=120,
                       n_points=12):
    """
    Certify every degree-1 covering family of Lemma E3-L, record its true
    incidence vector (Lemma E3-T), and run the negative controls.
    """
    P = G.planes[0]
    out = {"prime": G.m.p, "certified": [], "controls": []}

    zs = [G.general_point(s) for s in seeds]
    zs = [z for z in zs if z is not None][:n_points]
    assert len(zs) >= 4, "not enough general points"

    def run(name, tuples, target):
        """
        A family is CERTIFIED only if ONE FIXED tuple of centres admits a
        clean witness line through EVERY sampled general point z.  That is
        the covering condition of section 3.1 taken literally: a single
        family, a member through a general point.  A tuple that works at
        some z but not all is NOT a covering family and is rejected.
        """
        best_partial = None
        for Vs in _spread(tuples(), budget):
            hits, wit = 0, None
            for z in zs:
                w = G.witness(z, list(Vs), target=target)
                if w is None:
                    break
                hits += 1
                if wit is None:
                    wit = (z, w)
            if hits == len(zs):
                z, (L, cnt) = wit
                return {"name": name, "status": "CERTIFIED", "target": target,
                        "n_general_points": len(zs), "z": list(z),
                        "line": [list(r) for r in L],
                        "incidence": {str(k): int(v) for k, v in sorted(cnt.items())}}
            if best_partial is None or hits > best_partial:
                best_partial = hits
        return {"name": name, "status": "NOT_COVERING", "target": target,
                "best_hits": best_partial, "n_general_points": len(zs)}

    # k = 1: every orbit
    for i in sorted(G.orbits):
        out["certified"].append(run("one_orbit_%d" % i,
                                    lambda i=i: ((V,) for V in G.orbits[i]),
                                    {i: 1}))
    # k = 2: two planes
    out["certified"].append(run(
        "two_planes",
        lambda: ((G.orbits[P][a], G.orbits[P][b])
                 for a, b in itertools.combinations(range(G.sizes[P]), 2)),
        {P: 2}))
    # k = 3: three planes
    out["certified"].append(run(
        "three_planes",
        lambda: ((G.orbits[P][a], G.orbits[P][b], G.orbits[P][c])
                 for a, b, c in itertools.combinations(range(G.sizes[P]), 3)),
        {P: 3}))
    # k = 2: line-centre + plane, per line orbit
    for j in G.lines:
        out["certified"].append(run(
            "line_orbit_%d_plus_plane" % j,
            lambda j=j: ((L, Q) for L in G.orbits[j] for Q in G.orbits[P]),
            {j: 1, P: 1}))

    # ---- negative controls: the combinations Lemma E3-L excludes --------
    def control(name, tuples, target, budget=budget):
        """
        For each candidate tuple, how many of the sampled general points
        admit a clean line?  A covering family needs ALL of them.
        """
        best = 0
        best_cap = 0
        for Vs in _spread(tuples(), budget):
            hits = 0
            for z in zs:
                c = G.cap(z, list(Vs))
                best_cap = max(best_cap, len(c) if c else 0)
                if c and len(c) >= 2 and G.witness(z, list(Vs), target=target):
                    hits += 1
            best = max(best, hits)
        return {"name": name, "target": target, "n_general_points": len(zs),
                "max_general_points_covered_by_one_tuple": best,
                "max_cap_dim_seen": best_cap,
                "is_covering_family": best == len(zs)}

    out["controls"].append(control(
        "four_planes",
        lambda: (tuple(G.orbits[P][k] for k in q)
                 for q in itertools.combinations(range(G.sizes[P]), 4)),
        {P: 4}))
    for j1 in G.lines:
        for j2 in G.lines:
            if j2 < j1:
                continue
            tgt = {j1: 2} if j1 == j2 else {j1: 1, j2: 1}
            out["controls"].append(control(
                "line_orbits_%d_%d" % (j1, j2),
                lambda j1=j1, j2=j2: ((L1, L2)
                                      for L1 in G.orbits[j1][:6]
                                      for L2 in G.orbits[j2][:6] if L1 != L2),
                tgt))
    out["controls"].append(control(
        "point_plus_plane",
        lambda: ((V, Q) for i in G.points for V in G.orbits[i][:4]
                 for Q in G.orbits[P][:6]),
        {P: 1}))
    for j in G.lines:
        out["controls"].append(control(
            "line_orbit_%d_plus_two_planes" % j,
            lambda j=j: ((L, Q1, Q2)
                         for L in G.orbits[j][:6]
                         for Q1, Q2 in itertools.combinations(G.orbits[P][:10], 2)),
            {j: 1, P: 2}))
    return out


# ---------------------------------------------------------------- the LP

# Sealed pinned lower bounds on the orbit multiplicities at d = 35.
# m_D := ord_D(q^*H_X) = ord_C(T) = the order of vanishing along the centre C
# of the ideal generated by the five coordinates of T.
PINNED_D35 = {
    "pt_C11":       (1, "STAGE2_ODD_ORDER_PINNING/THEOREM.md:155 B(C11): all 60 "
                        "C11-points in Bs(T) iff d is a non-residue mod 11; "
                        "35 = 2 mod 11, 2 not in {1,3,4,5,9}"),
    "pt_D10":       (1, "STAGE2_ODD_ORDER_PINNING/THEOREM.md:157 B(D10): the 66 "
                        "D10-points lie in Bs(T) for every d"),
    "pt_A4(a)":     (2, "STAGE2_SECOND_ORDER/THEOREM.md:129 Prop 2.1: "
                        "mult_q(T) >= 2 at every A4-point, every d"),
    "pt_A4(b)":     (2, "STAGE2_SECOND_ORDER/THEOREM.md:129 Prop 2.1"),
    "pt_V4I":       (0, "NONE FOUND -- no sealed pinning theorem addresses "
                        "pt_V4I; lower bound left at 0"),
    "pt_C5(a)":     (1, "STAGE2_ODD_ORDER_PINNING/THEOREM.md:156 B(C5): all 264 "
                        "C5-eigenpoints in Bs(T) iff 5 | d; 5 | 35"),
    "pt_C5(b)":     (1, "STAGE2_ODD_ORDER_PINNING/THEOREM.md:156 B(C5)"),
    "pt_C6(a)":     (0, "Cor 1.5: at d = 5 mod 6 the two X^{C6} points are "
                        "SWAPPED, not based -- no lower bound at d = 35"),
    "pt_C6(b)":     (0, "Cor 1.5"),
    "pt_D12":       (1, "STAGE2_ODD_ORDER_PINNING/THEOREM.md:158 B(D12): the 55 "
                        "D12-points lie in Bs(T) for every d.  (Row J3 'the "
                        "multiplicity is odd' of the same file is NOT in its "
                        "tier-1 list and is NOT used here.)"),
    "C3line":       (0, "B(C3): the 110 C3-eigenlines lie in Bs(T) iff 3 | d; "
                        "3 does not divide 35, and Prop 1.6 makes the order 0"),
    "Lminus_sigma": (0, "Prop 1.4: (i) fires only for d even; (ii) "
                        "ord_{L_sigma}(T) = d+1 = 0 mod 2 -- '0 allowed'"),
    "ell_V":        (6, "CONE_ORDER_AUDIT/THEOREM.md:6-9, verdict "
                        "CONFIRMED-AT-GENERAL-DEGREE: ord_{ell_V}(T) >= 6 for "
                        "every landing covariant at every degree"),
    "P_sigma":      (1, "STAGE2_ODD_ORDER_PINNING/THEOREM.md:171 Prop 1.3: "
                        "P(W^+_sigma) subset Bs(T) for every d, with ord(T^-) "
                        "odd (hence >= 1) and ord(T^+) even >= 2"),
}

CONE_COUPLING_SRC = ("theory/FIX_II_jets.md:42 Lemma 2.1 (order cone), k = 3: "
                     "ord_R >= ceil(3m/2) with R = ell_V and m the plus-plane "
                     "order; relaxed to the rational inequality 3 m_P <= 2 m_R")
