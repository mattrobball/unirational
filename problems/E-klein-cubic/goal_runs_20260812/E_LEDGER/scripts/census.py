#!/usr/bin/env python3
"""
E_LEDGER -- the census layer.

Two jobs.

(1) CONSUMED BY CITATION: the 14 census orbits with their setwise
    stabilizers and orbit sizes.  Source
    `goal_runs_20260810/TERMINUS_STRATA_PW/results/t3_localmodels.txt`
    section (1) (identical at p = 331 and p = 661), cross-checked against
    `goal_runs_20260810/STANDARD_FORM_PW/THEOREM.md` lines 81-99 and
    `goal_runs_20260810/STANDARD_FORM_PW/results/s1_level0.json`.

(2) REBUILT INDEPENDENTLY here, because E3 needs incidence facts that no
    sealed artefact records: the arrangement `A` of eigen-subspaces of
    non-trivial subgroups of G = PSL(2,11) acting on W = C^5, at the two
    split primes 331 and 661, from the shared raw 660-matrix group model
    `psl211.py` (byte-identical copy of
    `goal_runs_20260811/ODDZERO_AUDIT/scripts/psl211.py`, itself a
    reduction of `certificates/exact_weil_check.py`).  The rebuild must
    reproduce 940 / 220 / 55 in 14 G-orbits with the cited stabilizer
    orders -- that is check group B of the verifier.

WHY EIGENSPACES AND NOT FIXED SPACES.  A point of P(W) is fixed by g iff its
line in W is g-STABLE, i.e. an eigenline.  So the stabilizer stratification
of P(W) is by eigenspaces of subgroups, not by W^H.  (Concretely: an
order-3 element has eigenvalue multiplicities (1,2,2), giving one fixed
point and two fixed lines in P^4 -- the "C3-eigenlines", 55 x 2 = 110.)

python3 standard library only; all arithmetic exact mod p.
"""

import os
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)

from psl211 import Model, SPLIT_PRIMES        # noqa: E402


# ======================================================================
#  (1) CITED CONSTANTS
# ======================================================================

# label -> (centre dimension in P^4, orbit size, pointwise stab, setwise stab,
#           |setwise stab|)
CENSUS = {
    "pt_C11":        (0,  60, "C11", "C11", 11),
    "pt_D10":        (0,  66, "D10", "D10", 10),
    "pt_A4(a)":      (0,  55, "A4",  "A4",  12),
    "pt_A4(b)":      (0,  55, "A4",  "A4",  12),
    "pt_V4I":        (0, 165, "V4",  "V4",   4),
    "pt_C5(a)":      (0, 132, "C5",  "C5",   5),
    "pt_C5(b)":      (0, 132, "C5",  "C5",   5),
    "pt_C6(a)":      (0, 110, "C6",  "C6",   6),
    "pt_C6(b)":      (0, 110, "C6",  "C6",   6),
    "pt_D12":        (0,  55, "D12", "D12", 12),
    "C3line":        (1, 110, "C3",  "C6",   6),
    "Lminus_sigma":  (1,  55, "C2",  "D12", 12),
    "ell_V":         (1,  55, "V4",  "A4",  12),
    "P_sigma":       (2,  55, "C2",  "D12", 12),
}
CENSUS_SRC = ("goal_runs_20260810/TERMINUS_STRATA_PW/results/t3_localmodels.txt "
              "section (1), both primes; = STANDARD_FORM_PW/THEOREM.md:81-99")

GROUP_ORDER = 660

# The complete list of conjugacy classes of subgroups of PSL(2,11) with
# their orders.  Source: STANDARD_FORM_PW/THEOREM.md:75-76 ("16 conjugacy
# classes of subgroups") + certificates/STRATA_EXACT.md:41-58; the ORDERS
# below are re-derived in filter_lemma_support() from the 660 matrices.
SUBGROUP_CLASSES = [
    ("1",    1,  1),      # (name, order, number of conjugacy classes)
    ("C2",   2,  1),
    ("C3",   3,  1),
    ("V4",   4,  1),
    ("C5",   5,  1),
    ("C6",   6,  1),
    ("S3",   6,  2),
    ("D10", 10,  1),
    ("C11", 11,  1),
    ("A4",  12,  2),
    ("D12", 12,  1),
    ("F55", 55,  1),
    ("A5",  60,  2),
    ("G",  660,  1),
]


def census_totals():
    pts = sum(v[1] for v in CENSUS.values() if v[0] == 0)
    lns = sum(v[1] for v in CENSUS.values() if v[0] == 1)
    pls = sum(v[1] for v in CENSUS.values() if v[0] == 2)
    return pts, lns, pls


# ======================================================================
#  (2) THE INDEPENDENT REBUILD
# ======================================================================

class Arrangement:
    """The arrangement A of eigen-subspaces of non-trivial elements of G,
    closed under intersection, inside W = F_p^5."""

    def __init__(self, p, verbose=False):
        self.m = Model(p)
        self.p = p
        self._build(verbose)

    # ---- subspace bookkeeping: a subspace is its canonical rref tuple ----
    def _eigenspaces_of(self, A, n):
        """All eigenspaces of A (of order n) for n-th roots of unity."""
        m = self.m
        p = self.p
        out = []
        zeta = m._root(n) if n > 1 else 1
        seen = set()
        for k in range(n):
            lam = pow(zeta, k, p)
            if lam in seen:
                continue
            seen.add(lam)
            U = m.eigsp(A, lam)
            if U and 1 <= len(U) <= 4:
                out.append(m.canon(U))
        return out

    def _build(self, verbose):
        m = self.m
        base = set()
        for A in m.G:
            n = m.order[A]
            if n == 1:
                continue
            for U in self._eigenspaces_of(A, n):
                base.add(U)
        # close under intersection
        cur = set(base)
        while True:
            new = set()
            for U in list(cur):
                for V in list(base):
                    I = m.inter(U, V)
                    if I and len(I) >= 1 and I not in cur:
                        new.add(I)
            if not new:
                break
            cur |= new
        self.spaces = {U for U in cur if 1 <= len(U) <= 3}
        # G-orbits
        self.orbits = self._orbits(self.spaces)

    def _orbits(self, spaces):
        m = self.m
        remaining = set(spaces)
        orbits = []
        while remaining:
            U = next(iter(remaining))
            orb = set()
            frontier = [U]
            orb.add(U)
            while frontier:
                nf = []
                for V in frontier:
                    for A in m.G:
                        Wv = m.canon([list(m.act(A, v)) for v in V])
                        if Wv not in orb:
                            orb.add(Wv)
                            nf.append(Wv)
                frontier = nf
            orbits.append(frozenset(orb))
            remaining -= orb
        return orbits

    # ---- reporting ----
    def profile(self):
        """dim-in-W -> count, and the orbit-size multiset per dim."""
        by_dim = {1: [], 2: [], 3: []}
        for orb in self.orbits:
            d = len(next(iter(orb)))
            by_dim[d].append(len(orb))
        return {d: (sum(v), sorted(v)) for d, v in by_dim.items()}

    def orbit_of(self, U):
        for i, orb in enumerate(self.orbits):
            if U in orb:
                return i
        return None

    def orbit_label_by_size(self):
        """
        Attach a census label to each orbit using (dim, orbit size).  Where
        two census orbits share (dim, size) -- pt_A4(a)/pt_A4(b) (0,55) with
        pt_D12 (0,55); pt_C5(a)/(b) (0,132); pt_C6(a)/(b) (0,110);
        Lminus_sigma/ell_V (1,55) -- the label is the SET of candidates.
        E3 only uses (dim, size), and m is orbit-constant, so no
        disambiguation is needed; this is recorded, not resolved.
        """
        out = []
        for i, orb in enumerate(self.orbits):
            d = len(next(iter(orb))) - 1      # dim in P^4
            n = len(orb)
            cands = [k for k, v in CENSUS.items() if v[0] == d and v[1] == n]
            out.append({"orbit": i, "dim_P4": d, "size": n, "candidates": cands})
        return out


# ======================================================================
#  (3) THE E3 INCIDENCE ORACLE
# ======================================================================
#
#  A line in P^4 through a point z, with direction w (w not in <z>), meets a
#  linear subspace P(V) if and only if  <z,w> cap V != 0, i.e. iff
#  w in V + <z>.  Hence, for a set S of centres,
#
#      { lines through z meeting every member of S }
#        = P( cap_{V in S} (V + <z>) / <z> ),
#
#  which is non-empty iff  dim cap_{V in S} (V + <z>) >= 2.
#
#  For a GENERAL z this is the exact criterion for the family "lines meeting
#  every member of S" to be a COVERING family of P^4 (it sweeps a dense set
#  precisely when a member passes through a general point).  Everything E3
#  needs is therefore ordinary linear algebra over the field.

def _sum_with(m, V, z):
    """V + <z> as a canonical subspace."""
    return m.canon([list(v) for v in V] + [list(z)])


def lines_through_z_meeting(m, z, Vs):
    """cap_i (V_i + <z>); returns the canonical subspace."""
    cur = None
    for V in Vs:
        S = _sum_with(m, V, z)
        cur = S if cur is None else m.inter(cur, S)
        if not cur or len(cur) < 2:
            return cur
    return cur


def line_span(m, z, w):
    return m.canon([list(z), list(w)])


def incidence_vector(m, L, spaces_by_orbit):
    """
    For a line L (2-dim subspace of W), return {orbit index -> number of
    members of that orbit that L meets}, and whether L is CONTAINED in any
    member (which would invalidate the covering-family inequality).
    """
    counts = {}
    contained = []
    for i, orb in enumerate(spaces_by_orbit):
        c = 0
        for V in orb:
            I = m.inter(L, V)
            if I and len(I) >= 1:
                c += 1
                if len(I) == 2:
                    contained.append(i)
        if c:
            counts[i] = c
    return counts, contained


def random_point(m, seed):
    """A pseudo-random point of P(W)(F_p) from a fixed deterministic seed."""
    p = m.p
    x = (seed * 1103515245 + 12345) % (2 ** 31)
    v = []
    for _ in range(5):
        x = (x * 1103515245 + 12345) % (2 ** 31)
        v.append(x % p)
    if all(c == 0 for c in v):
        v = [1, 0, 0, 0, 0]
    return tuple(v)


def _stab_type(m, U):
    """Isomorphism type of the SETWISE stabilizer, by order + order profile."""
    S = m.setstab(U)
    n = len(S)
    prof = {}
    for A in S:
        prof[m.order[A]] = prof.get(m.order[A], 0) + 1
    if n == 12:
        # A4: 3 involutions, 8 elements of order 3.  D12: 7 involutions,
        # 2 of order 3, 2 of order 6.
        return "A4" if prof.get(2, 0) == 3 else "D12"
    return {1: "1", 2: "C2", 3: "C3", 4: "V4", 5: "C5", 6: "C6",
            10: "D10", 11: "C11", 55: "F55", 60: "A5", 660: "G"}.get(n, "?%d" % n)


def label_orbits(A):
    """
    Attach the census label of CENSUS to every rebuilt orbit, using only
    intrinsic data (dimension, orbit size, setwise stabilizer type, whether
    the members lie on the Klein cubic, and containment in the plane orbit).
    Orbits that the census itself does not separate by any of these -- the
    two C5 orbits, the two A4 orbits -- get the (a)/(b) tags in the rebuild's
    own order; nothing downstream distinguishes them (identical dimension,
    identical orbit size, identical pinned bound).
    """
    m = A.m
    orbits = {i: sorted(o) for i, o in enumerate(A.orbits)}
    dims = {i: len(next(iter(o))) - 1 for i, o in enumerate(A.orbits)}
    sizes = {i: len(o) for i, o in enumerate(A.orbits)}
    planeorb = [i for i in orbits if dims[i] == 2]
    assert len(planeorb) == 1
    Pi = planeorb[0]
    lab = {Pi: "P_sigma"}
    used = set()

    def take(name):
        assert name not in used, name
        used.add(name)
        return name

    take("P_sigma")
    for i in sorted(orbits):
        if i == Pi:
            continue
        d, n = dims[i], sizes[i]
        rep = orbits[i][0]
        if d == 1:
            if n == 110:
                lab[i] = take("C3line")
            else:
                inside = any(m.inter(rep, Q) == rep for Q in orbits[Pi])
                lab[i] = take("ell_V" if inside else "Lminus_sigma")
        else:
            st = _stab_type(m, rep)
            if n == 165:
                lab[i] = take("pt_V4I")
            elif n == 66:
                lab[i] = take("pt_D10")
            elif n == 60:
                lab[i] = take("pt_C11")
            elif n == 132:
                lab[i] = take("pt_C5(a)" if "pt_C5(a)" not in used else "pt_C5(b)")
            elif n == 110:
                on_X = (m.F(rep[0]) == 0)
                lab[i] = take("pt_C6(b)" if on_X else "pt_C6(a)")
            elif n == 55:
                if st == "D12":
                    lab[i] = take("pt_D12")
                else:
                    lab[i] = take("pt_A4(a)" if "pt_A4(a)" not in used
                                  else "pt_A4(b)")
            else:
                raise RuntimeError("unlabelled orbit size %d" % n)
    assert set(lab.values()) == set(CENSUS), sorted(set(CENSUS) - set(lab.values()))
    return lab


if __name__ == "__main__":
    import json
    for p in SPLIT_PRIMES:
        A = Arrangement(p)
        print(p, A.profile())
        print(json.dumps(A.orbit_label_by_size(), indent=0))
