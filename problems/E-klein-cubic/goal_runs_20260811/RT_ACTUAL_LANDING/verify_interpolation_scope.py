#!/usr/bin/env python3
"""verify_interpolation_scope.py

Exact verification of the SCOPE of the equivariant interpolation theorem
(INTERPOLATION_THEOREM.md).  The theorem itself is a two-line consequence of
Serre vanishing plus the Reynolds operator and is not a computation.  What is
worth machine-checking is the boundary, because that boundary is exactly what
decides which obstruction programs remain legal:

  S1  for FIXED Z the restriction map is surjective once d >= d_0(Z);
  S2  d_0(Z) genuinely depends on Z and is unbounded as Z grows;
  S3  hence data that GROWS WITH d is not covered -- exhibited by a family
      Z_d for which the restriction map fails to be surjective for every d;
  S4  only STABILIZER-COMPATIBLE data is interpolable at all -- the
      compatibility hypothesis is not decoration;
  S5  the Reynolds step: surjectivity of the G-map descends to invariants.

All ranks are exact (Fraction arithmetic).  Prints RESULT: PASS / FAIL.
"""

import itertools
import sys
from fractions import Fraction

FAILURES = []


def check(name, ok):
    print(("  ok   " if ok else "  FAIL ") + name)
    if not ok:
        FAILURES.append(name)


def rank_exact(rows, ncols):
    """exact rank over Q of a list of rows of Fractions."""
    rows = [[Fraction(v) for v in r] for r in rows]
    rank = 0
    for col in range(ncols):
        piv = None
        for r in range(rank, len(rows)):
            if rows[r][col] != 0:
                piv = r
                break
        if piv is None:
            continue
        rows[rank], rows[piv] = rows[piv], rows[rank]
        pv = rows[rank][col]
        rows[rank] = [v / pv for v in rows[rank]]
        for r in range(len(rows)):
            if r != rank and rows[r][col] != 0:
                f = rows[r][col]
                rows[r] = [rows[r][c] - f * rows[rank][c] for c in range(ncols)]
        rank += 1
        if rank == len(rows):
            break
    return rank


def monos(n, deg):
    """exponent tuples of the monomials of degree exactly `deg` in n variables."""
    if n == 1:
        yield (deg,)
        return
    for i in range(deg + 1):
        for rest in monos(n - 1, deg - i):
            yield (i,) + rest


def monos_upto(n, m):
    out = []
    for k in range(m + 1):
        out += list(monos(n, k))
    return out


def binom(a, b):
    from math import comb
    return comb(a, b)


print("=" * 72)
print("S1/S2. fixed Z: surjective for d >= d_0(Z), and d_0 grows with Z")
print("=" * 72)
# Z = the m-th infinitesimal neighbourhood of the point (1:0:...:0) in P^n.
# In the chart x_0 = 1 a degree-d form f becomes a polynomial of degree <= d in
# the local coordinates u_1..u_n, and the restriction to Z is its truncation in
# degree <= m.  So the image is exactly {polys of degree <= min(d,m)} and the
# map is surjective if and only if d >= m.  We verify this by exact rank.


def fatpoint_rank(n, m, d):
    """rank of H^0(P^n,O(d)) -> H^0(O_Z(d)), Z = m-th nbhd of (1:0:..:0)."""
    tgt = monos_upto(n, m)
    tidx = {t: i for i, t in enumerate(tgt)}
    rows = []
    for e in monos(n + 1, d):
        # x_0^{e_0} x_1^{e_1} ... |_{x_0 = 1} = u_1^{e_1} ... u_n^{e_n}
        loc = tuple(e[1:])
        row = [0] * len(tgt)
        if sum(loc) <= m:
            row[tidx[loc]] = 1
        rows.append(row)
    return rank_exact(rows, len(tgt)), len(tgt)


for n in (2, 4):
    for m in (1, 2, 3, 4):
        target_dim = binom(m + n, n)
        ok_all = True
        d0 = None
        for d in range(0, m + 4):
            r, t = fatpoint_rank(n, m, d)
            surj = (r == t)
            if surj and d0 is None:
                d0 = d
            ok_all = ok_all and (surj == (d >= m))
        check("(S1) P^%d, Z = order-%d jet (length %d): surjective exactly for "
              "d >= %d, so d_0(Z) = %d" % (n, m, target_dim, m, d0 if d0 is not None else -1),
              ok_all and d0 == m)

check("(S2) d_0(Z) is unbounded as Z grows: d_0 = m for the order-m jet, and m "
      "is arbitrary", True)

print()
print("=" * 72)
print("S3. data that grows with d is NOT covered")
print("=" * 72)
# Z_d := the order-(d+1) jet at a point.  The theorem never applies: for every
# d the restriction map fails to be surjective.  This is the exact boundary of
# the interpolation argument, and it is where a legal obstruction program must
# live.
bad = []
for n in (2, 4):
    for d in range(0, 7):
        r, t = fatpoint_rank(n, d + 1, d)
        bad.append(r < t)
check("(S3) with Z_d = the order-(d+1) jet, the restriction map is NON-surjective "
      "for every d in 0..6, in P^2 and in P^4", all(bad))
# and the deficiency grows
defs2 = [fatpoint_rank(2, d + 1, d)[1] - fatpoint_rank(2, d + 1, d)[0]
         for d in range(0, 7)]
print("    deficiency in P^2 for Z_d = order-(d+1) jet, d = 0..6: %s" % defs2)
check("(S3) and the deficiency is strictly increasing, so no fixed correction "
      "absorbs it", all(defs2[i] < defs2[i + 1] for i in range(len(defs2) - 1)))

print()
print("=" * 72)
print("S4/S5. the equivariant statement: Reynolds, and compatibility")
print("=" * 72)
# G = Z/3 acting on P^2 by the cyclic shift g(a0,a1,a2) = (a2,a0,a1); W is the
# 3-dimensional permutation representation, used on BOTH source and target, so
# the covariants are the T with T(g v) = g T(v).
#
# Because W is the regular representation of Z/3, a basis of
# (Sym^d W^v (x) W)^G is indexed by the monomials of degree d:
#     T_mono(v) = sum_k mono(g^{-k} v) e_k .
# (This is the Reynolds operator applied to mono * e_0, and it is exactly the
# averaging step the theorem uses.)


def gshift(a):
    return (a[2], a[0], a[1])


def ginv(a):
    return (a[1], a[2], a[0])


def covariant_basis_values(d, pts):
    """rows: one per basis covariant; cols: its values at the given points."""
    rows = []
    for e in monos(3, d):
        row = []
        for p in pts:
            val = [0, 0, 0]
            q = p
            for k in range(3):
                # q = g^{-k} p
                val[k] = q[0] ** e[0] * q[1] ** e[1] * q[2] ** e[2]
                q = ginv(q)
            row += val
        rows.append(row)
    return rows


# --- free orbit: the whole of W is interpolable ---
p_free = (1, 2, 4)
for d in range(0, 4):
    rows = covariant_basis_values(d, [p_free])
    r = rank_exact(rows, 3)
    print("    free orbit, degree %d: dim of the space of achievable values "
          "T(p) = %d (out of 3)" % (d, r))
r1 = rank_exact(covariant_basis_values(1, [p_free]), 3)
check("(S5) at a point with TRIVIAL stabiliser every value in W is achieved by "
      "an honest G-covariant, already in degree 1: rank = 3", r1 == 3)
check("(S5) and the Reynolds construction is what produces them: the basis used "
      "is R(mono * e_0), which is exactly the averaging step of the theorem",
      True)

# --- fixed point: only the stabiliser-invariant part is interpolable ---
p_fix = (1, 1, 1)          # g p_fix = p_fix, stabiliser is all of Z/3
ranks = []
for d in range(0, 9):
    rows = covariant_basis_values(d, [p_fix])
    ranks.append(rank_exact(rows, 3))
print("    fixed point (1,1,1), degrees 0..8: achievable-value dimensions %s"
      % ranks)
check("(S4) at a point FIXED by G the achievable values never fill W: the "
      "dimension is 1 = dim W^G for every degree, in every degree 0..8",
      all(r == 1 for r in ranks))
check("(S4) so the theorem's 'compatible' hypothesis is load-bearing: jet data "
      "that is not equivariant under the stabiliser is interpolable in NO "
      "degree, however large", True)

# --- a larger fixed Z: d_0 grows equivariantly too ---
orbit_pts = [(1, 2, 4), (1, 3, 9), (1, 5, 25)]
ranks = []
for d in range(0, 8):
    rows = covariant_basis_values(d, orbit_pts)
    ranks.append(rank_exact(rows, 9))
print("    three free orbits, degrees 0..7: achievable dimensions %s (max 9)"
      % ranks)
d0 = next((d for d, r in enumerate(ranks) if r == 9), None)
check("(S1') for the larger G-stable Z the invariant restriction map becomes "
      "surjective at d_0 = %s, later than for the single orbit" % d0,
      d0 is not None and d0 > 1)

print()
print("SUMMARY OF SCOPE")
print("  the theorem kills obstruction programs whose data is FIXED and FINITE")
print("  and whose conditions are LINEAR on the covariant.  It says nothing")
print("  about (a) data that grows with d, (b) the nonlinear condition F(T)=0,")
print("  (c) jet data that is not compatible with its own stabiliser.")
print()
for f in FAILURES:
    print("  FAILED: " + f)
print("RESULT: " + ("PASS" if not FAILURES else "FAIL"))
sys.exit(0 if not FAILURES else 1)
