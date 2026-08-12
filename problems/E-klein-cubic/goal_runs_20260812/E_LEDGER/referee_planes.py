#!/usr/bin/env python3
"""
REFEREE spot-check R3 (machine part) -- the 55 plus-planes.

Independently of scripts/census.py (own rref / nullspace / intersection code;
only the 660 matrices are taken from the shared raw model psl211.py, which is
a byte-level copy of the sealed ODDZERO_AUDIT model):

  P1  there are exactly 55 involutions, each with a 3-dim (+1)-eigenspace
      ("plus-plane") and a 2-dim (-1)-eigenspace; the 55 plus-planes are
      pairwise distinct and form ONE G-orbit; |setwise stab| = 12.
  P2  ALL C(55,2) = 1485 pairs of plus-planes meet: 1320 in a point, 165 in
      a line.  (Meeting at all is automatic -- two 3-dim subspaces of a
      5-dim space intersect in dim >= 1 -- the packet's real content is the
      1320/165 split and the CONNECTEDNESS + G-stability it records.)
  P3  the union is therefore connected (complete meeting graph) and G-stable
      (single orbit).
  P4  facts feeding the R3 adjudication of REFEREE_REPORT.md:
      55 = 0 (mod 11), 55 = 0 (mod 5), 55 = 1 (mod 3); the minimal census
      orbit size is 55 > 4; G is SIMPLE (normal closure of every non-trivial
      conjugacy class is all of G).

Both split primes 331 and 661.  python3 stdlib only.
"""

import os
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, os.path.join(HERE, "scripts"))

from psl211 import Model, SPLIT_PRIMES   # raw 660-matrix model only

FAILS = []


def chk(name, ok, detail=""):
    print("[%s] %s %s" % ("PASS" if ok else "FAIL", name, detail))
    if not ok:
        FAILS.append(name)


# ---------------- own linear algebra over F_p (independent of psl211's) ----

def rref(rows, p):
    M = [list(r) for r in rows]
    n = len(M[0]) if M else 0
    r = 0
    for c in range(n):
        piv = None
        for i in range(r, len(M)):
            if M[i][c] % p:
                piv = i
                break
        if piv is None:
            continue
        M[r], M[piv] = M[piv], M[r]
        iv = pow(M[r][c], p - 2, p)
        M[r] = [x * iv % p for x in M[r]]
        for i in range(len(M)):
            if i != r and M[i][c] % p:
                f = M[i][c]
                M[i] = [(x - f * y) % p for x, y in zip(M[i], M[r])]
        r += 1
    return tuple(tuple(row) for row in M[:r])


def nullspace(rows, p):
    R = rref(rows, p)
    piv = []
    for row in R:
        for c in range(len(row)):
            if row[c] == 1 and all(rr[c] == 0 for rr in R if rr is not row):
                piv.append(c)
                break
    n = len(rows[0])
    free = [c for c in range(n) if c not in piv]
    basis = []
    for f in free:
        v = [0] * n
        v[f] = 1
        for i, c in enumerate(piv):
            v[c] = (-R[i][f]) % p
        basis.append(v)
    return rref(basis, p) if basis else ()


def inter_dim(U, V, p):
    """dim(U cap V) = dim U + dim V - rank(U stacked on V)."""
    return len(U) + len(V) - len(rref([list(x) for x in U]
                                      + [list(x) for x in V], p))


def main():
    for p in SPLIT_PRIMES:
        m = Model(p)
        chk("p%d_group_order_660" % p, len(m.G) == 660)
        invols = [A for A in m.G if m.order[A] == 2]
        chk("p%d_55_involutions" % p, len(invols) == 55, len(invols))

        planes = []
        for A in invols:
            plus = nullspace([[(A[i][j] - (1 if i == j else 0)) % p
                               for j in range(5)] for i in range(5)], p)
            minus = nullspace([[(A[i][j] + (1 if i == j else 0)) % p
                                for j in range(5)] for i in range(5)], p)
            if len(plus) != 3 or len(minus) != 2:
                chk("p%d_eigen_dims_3_2" % p, False,
                    "(%d,%d)" % (len(plus), len(minus)))
                break
            planes.append(plus)
        else:
            chk("p%d_eigen_dims_3_2_all" % p, True)
        planes_set = set(planes)
        chk("p%d_55_distinct_plus_planes" % p, len(planes_set) == 55,
            len(planes_set))

        # one G-orbit; setwise stabiliser order 12  (own orbit code)
        orb = {planes[0]}
        frontier = [planes[0]]
        while frontier:
            nf = []
            for U in frontier:
                for A in m.G:
                    V = rref([list(m.act(A, u)) for u in U], p)
                    if V not in orb:
                        orb.add(V)
                        nf.append(V)
            frontier = nf
        chk("p%d_planes_single_G_orbit_of_55" % p,
            orb == planes_set, len(orb))
        stab = sum(1 for A in m.G
                   if rref([list(m.act(A, u)) for u in planes[0]], p)
                   == planes[0])
        chk("p%d_setwise_stab_order_12" % p, stab == 12, stab)

        # pairwise intersections
        pt = ln = other = 0
        for i in range(55):
            for j in range(i + 1, 55):
                d = inter_dim(planes[i], planes[j], p)
                if d == 1:
                    pt += 1
                elif d == 2:
                    ln += 1
                else:
                    other += 1
        chk("p%d_1485_pairs_all_meet" % p, pt + ln == 1485 and other == 0,
            "point=%d line=%d other=%d" % (pt, ln, other))
        chk("p%d_split_1320_point_165_line" % p, (pt, ln) == (1320, 165),
            "(%d,%d)" % (pt, ln))
        chk("p%d_union_connected_and_G_stable" % p,
            other == 0 and orb == planes_set,
            "complete meeting graph on one orbit")

    # P4: arithmetic + simplicity (at one prime; group-theoretic, prime-free)
    chk("55_mod_11_5_3", (55 % 11, 55 % 5, 55 % 3) == (0, 0, 1))
    m = Model(SPLIT_PRIMES[0])
    inv = {A: m.matinv(A) for A in m.G}
    reps, seen = [], set()
    for A in m.G:
        if A in seen:
            continue
        cls = {m.mm(m.mm(X, A), inv[X]) for X in m.G}
        seen |= cls
        reps.append(A)
    simple = True
    for A in reps:
        if A == m.Id:
            continue
        cls = {m.mm(m.mm(X, A), inv[X]) for X in m.G}
        N = set(cls) | {m.Id}
        frontier = list(N)
        while frontier:
            nf = []
            for x in frontier:
                for y in cls:
                    z = m.mm(x, y)
                    if z not in N:
                        N.add(z)
                        nf.append(z)
            frontier = nf
        if len(N) != 660:
            simple = False
    chk("G_is_simple_normal_closures_all_660", simple)

    print()
    print("referee_planes: %d failures" % len(FAILS))
    return 1 if FAILS else 0


if __name__ == "__main__":
    sys.exit(main())
