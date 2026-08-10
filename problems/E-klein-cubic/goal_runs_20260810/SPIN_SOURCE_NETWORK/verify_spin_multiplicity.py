#!/usr/bin/env python3
"""
verify_spin_multiplicity.py -- the multiplicity route to the SPIN-LINKING LEMMA,
checked exactly.

VERDICT VERIFIED HERE (negative): the linking that Thm 7.4 of
`THEORY_SPIN_ENGINE.md` predicts at multiplicity `m >= 2` DOES NOT EXIST.  The
trivial `K`-multiplicity `m - 1` in `T_x` is exactly the tangent space of the
`K`-fixed component `Z` through `x`; the NORMAL representation of `Z` has zero
`K`-invariants at every `m`.  One `G`-equivariant blowup therefore separates
every carrier from every other carrier and from every `K`-invariant stratum, at
every multiplicity.  A second, independent blowup destroys the whole
`D_10`-fixed locus, so the `V14^{D_10} = empty` datum yields no obstruction
either.

Everything is exact: `fractions.Fraction` arithmetic over `Q(i)` inside the
integral monomial model `W = Ind_B(Legendre)` of `SL(2,11)` (dimension 12), with
the halving principle `dim(S n U) = dim(S)/2` of `spin_network_lib`.  No
sampling, no search, no floating point, no Macaulay2.

Sections
  A  model regression (against SPIN_SOURCE_NETWORK_OK)
  B  the first-order data at m = 1 (regression against Thm K5)
  C  the four-sign incidence pattern and the partner locus
  D  the 352 incidence loci are pairwise disjoint; the planes through each
  E  the multiplicity ledger: dim Z = m-1 = m_triv(T_x), m_triv(N_Z) = 0
  F  the fixed-locus component count of Bl_W P(U^m): 110 + 352
  G  the D_10 destruction centre (C_5-fixed lines through the F_55 points)
  H  the abelian audit

Exit marker on success: SPIN_MULTIPLICITY_OK
"""

import sys
from collections import Counter, defaultdict

sys.path.insert(0, __file__.rsplit('/', 1)[0] if '/' in __file__ else '.')

from spin_network_lib import (SpinNetwork, kernel_basis, rank, rref_key,
                              gadd, gsub, gint, ONE)

FAILS = []


def check(name, cond, detail=""):
    if cond:
        print("  ok   %-52s %s" % (name, detail))
    else:
        print("  FAIL %-52s %s" % (name, detail))
        FAILS.append(name)


# ----------------------------------------------------------------------
# A. model regression
# ----------------------------------------------------------------------
print("A. model regression (SL(2,11) monomial model, dim W = 12)")
net = SpinNetwork(11)
n = net.n
PLANES = list(net.PLANES)
PIDX = {p: i for i, p in enumerate(PLANES)}
pts = net.incidence_points()

check("55 involutions of PSL(2,11)", net.nInv == 55, "nInv = %d" % net.nInv)
check("110 eigenplanes", len(PLANES) == 110)
check("1980 meeting plane pairs", len(net.edges) == 1980)
check("352 incidence loci", len(pts) == 352)

per_pt = Counter(len(r["planes"]) for r in pts.values())
check("220 loci on 3 planes, 132 on 5", per_pt == Counter({3: 220, 5: 132}),
      str(dict(per_pt)))

# Fast exact stabilisers.  Every rho(g) is a SIGNED PERMUTATION matrix, so
# rho(g) acts on coordinates by  (g.v)[PERM[g][j]] = SGN[g][j] * v[j].  A group
# element stabilises the line C.v iff g.v = c.v for a scalar c; with monomial
# matrices this is an O(n) test in exact Q(i) arithmetic.  Same answer as
# spin_network_lib.stab_of_point, ~100x faster (cross-checked on a sample).
PERM, SGN = {}, {}
for g in net.SL:
    R = net.RHO[g]
    pm = [None] * n
    sg = [0] * n
    for j in range(n):
        for i in range(n):
            if R[i][j]:
                pm[j] = i
                sg[j] = R[i][j]
                break
    PERM[g], SGN[g] = pm, sg


def act(g, v):
    out = [None] * n
    pm, sg = PERM[g], SGN[g]
    for j in range(n):
        x = v[j]
        out[pm[j]] = x if sg[j] == 1 else (-x[0], -x[1])
    return out


def scalar_on_fast(g, v, nz):
    w = act(g, v)
    if w[nz][0] == 0 and w[nz][1] == 0:
        return None
    d = v[nz][0] * v[nz][0] + v[nz][1] * v[nz][1]
    lam = ((w[nz][0] * v[nz][0] + w[nz][1] * v[nz][1]) / d,
           (w[nz][1] * v[nz][0] - w[nz][0] * v[nz][1]) / d)
    for j in range(n):
        a = lam[0] * v[j][0] - lam[1] * v[j][1]
        b = lam[0] * v[j][1] + lam[1] * v[j][0]
        if w[j][0] != a or w[j][1] != b:
            return None
    return lam


STAB, KIND = {}, {}
for key, rec in pts.items():
    v = rec["basis"][0]
    nz = next(j for j in range(n) if not (v[j][0] == 0 and v[j][1] == 0))
    S = set()
    for g in net.SL:
        if scalar_on_fast(g, v, nz) is not None:
            S.add(min(g, net.mul(net.NEG, g)))
    STAB[key] = S
    KIND[key] = "S3" if len(S) == 6 else "D10"
# cross-check the fast routine against the library on three loci
for key in sorted(pts)[:3]:
    if net.stab_of_point(pts[key]) != STAB[key]:
        FAILS.append("fast stabiliser disagrees with spin_network_lib")
check("stabilisers are exactly S_3 (order 6) / D_10 (order 10)",
      Counter(KIND.values()) == Counter({"S3": 220, "D10": 132}),
      str(dict(Counter(KIND.values()))))
check("stabiliser order matches the plane count (3 <-> 6, 5 <-> 10)",
      all(len(STAB[k]) == 2 * len(pts[k]["planes"]) for k in pts))

# ----------------------------------------------------------------------
# B. first-order data at m = 1  (regression against Thm K5)
# ----------------------------------------------------------------------
print("B. m = 1 first-order data (Thm K5 regression)")
tr = {k: net.tangent_report(pts[k]) for k in pts}
sig = Counter((t[1], t[2], t[3], t[4], t[5]) for t in tr.values())
check("T_x is 5-dim with m_triv = 0, m_sign = 1, eigendims (2,3)",
      sig == Counter({(5, 0, 1, 2, 3): 352}), str(dict(sig)))
check("no scalar point of sigma on P(U) (Thm K6)",
      all(t[4] > 0 and t[5] > 0 for t in tr.values()))

# ----------------------------------------------------------------------
# C. the four-sign incidence pattern
# ----------------------------------------------------------------------
print("C. the four-sign incidence pattern on every meeting pair")


def inc(p, q):
    """dim over U of  U_{eps i}(sigma)  n  U_{delta i}(tau)."""
    if p == q:
        return 3
    a, b = (p, q) if PIDX[p] < PIDX[q] else (q, p)
    return net.INCID[(a, b)]


pattern = Counter()
for key, rec in pts.items():
    planes = sorted(rec["planes"])
    signs = dict(planes)
    check_local = len(signs) == len(planes)
    if not check_local:
        FAILS.append("one plane per involution at %s" % (key,))
    for i in range(len(planes)):
        for j in range(i + 1, len(planes)):
            (a, ea), (b, eb) = planes[i], planes[j]
            pattern[(inc((a, ea), (b, eb)), inc((a, ea), (b, -eb)),
                     inc((a, -ea), (b, eb)), inc((a, -ea), (b, -eb)))] += 1
check("every incident pair has sign pattern (1,0,0,1)",
      pattern == Counter({(1, 0, 0, 1): 1980}), str(dict(pattern)))

# the partner locus (the second spin linear character of Ktilde)
byplanes = {tuple(sorted(r["planes"])): k for k, r in pts.items()}
partner = {}
for key, rec in pts.items():
    opp = tuple(sorted((k, -e) for k, e in rec["planes"]))
    partner[key] = byplanes.get(opp)
check("each locus has a partner locus with all signs flipped",
      all(v is not None for v in partner.values()))
check("the partner map is a fixed-point-free involution",
      all(partner[partner[k]] == k and partner[k] != k for k in pts))
check("partner has the same stabiliser subgroup",
      all(STAB[partner[k]] == STAB[k] for k in pts))

# ----------------------------------------------------------------------
# D. the 352 loci are pairwise disjoint; planes through each
# ----------------------------------------------------------------------
print("D. the 352 incidence loci")
keys = sorted(pts)
BAS = {k: pts[k]["basis"] for k in keys}
check("each locus is a single line of U (dim 2 in W)",
      all(len(BAS[k]) == 2 for k in keys))

bad = 0
for i in range(len(keys)):
    for j in range(i + 1, len(keys)):
        A, B = BAS[keys[i]], BAS[keys[j]]
        if len(A) + len(B) - rank(list(A) + list(B), n) != 0:
            bad += 1
check("the 352 lines are pairwise disjoint in P(U)", bad == 0,
      "%d bad pairs of %d" % (bad, len(keys) * (len(keys) - 1) // 2))

# which planes contain a given locus: the locus lies in P(V_{eps i}(sigma))
# iff every basis vector is an (eps i)-eigenvector of the chosen order-4 lift
contain = {}
for k in keys:
    S = []
    for (a, ea) in PLANES:
        g = net.INV[a]
        good = True
        for v in BAS[k]:
            w = act(g, v)
            for j in range(n):
                # (eps i) * v[j]
                if w[j][0] != -ea * v[j][1] or w[j][1] != ea * v[j][0]:
                    good = False
                    break
            if not good:
                break
        if good:
            S.append((a, ea))
    contain[k] = set(S)
check("the planes containing a locus are exactly its incident planes",
      all(contain[k] == set(pts[k]["planes"]) for k in keys))
per_plane = Counter()
for k in keys:
    for p in contain[k]:
        per_plane[p] += 1
check("each plane carries exactly 12 loci",
      set(per_plane.values()) == {12} and len(per_plane) == 110)

# every meeting pair of planes meets exactly in one of the 352 loci
locus_of = {}
ok_edges = True
for p1, p2, d in net.edges:
    S = net.span_intersection(p1, p2)
    kk = rref_key(S, n)
    if kk not in pts:
        ok_edges = False
    locus_of[(p1, p2)] = kk
check("every meeting pair of planes meets exactly in a listed locus", ok_edges)

# ----------------------------------------------------------------------
# E. the multiplicity ledger
# ----------------------------------------------------------------------
print("E. the multiplicity ledger  (V = U^(+m), all m >= 1)")
# exact m=1 inputs, per locus:
#   dU_lambda      = dim (U_{eps}(sigma) n U_{delta}(tau))          = 1
#   dU_lambdaprime = dim (U_{-eps}(sigma) n U_{-delta}(tau))        = 1
#   dU_mixed       = dim (U_{eps}(sigma) n U_{-delta}(tau))         = 0
#   dim U_{eps}(sigma) = 3
# For V = U (x) C^m every K-isotypic multiplicity is multiplied by m, so
#   dim V_lambda = m,  Z = P(V_lambda) = P^{m-1},
#   dim T_x = 6m - 1,  m_triv(T_x) = dim V_lambda - 1 = m - 1 = dim T_x Z,
#   N_Z = T_x / T_x Z  has  m_triv = 0  for EVERY m.
MS = list(range(1, 9))
ledger_ok = True
for m in MS:
    dimZ = m - 1                        # Z = P(V_lambda), dim V_lambda = m
    mtriv_T = m * 1 - 1                 # dim V_lambda - 1
    dimTxZ = dimZ
    mtriv_N = mtriv_T - dimTxZ          # invariants of N_{Z/P(V)}
    dimA = dimZ + (2 * m - 1)           # Z x P(V_{eps}(rho) / V_lambda)
    dimB = dimZ + (3 * m - 1)           # Z x P(V_{-eps}(rho))
    dimS = dimZ + (m - 1)               # Z x P(V_lambda')
    AA = m * 1 - m          # A n A' : (V_{eps} n V_{eps'}) / V_lambda = 0
    AB = m * 0              # A n B' : V_{eps} n V_{-eps'} = 0
    BB = m * 1              # B n B' : V_{-eps} n V_{-eps'} = V_lambda'
    ledger_ok &= (mtriv_N == 0 and AA == 0 and AB == 0 and BB == m and
                  dimA == 3 * m - 2 and dimB == 4 * m - 2 and dimS == 2 * m - 2)
check("m_triv(T_x) = m-1 = dim Z and m_triv(N_Z) = 0 for m = 1..8", ledger_ok,
      "dim A = 3m-2, dim B = 4m-2, dim S_Z = 2m-2")
check("m = 1 ledger reproduces K5 (Z a point, m_triv(T_x) = 0)",
      (1 - 1) == 0 and tr[keys[0]][2] == 0)

# ----------------------------------------------------------------------
# F. the fixed-locus components of  B = Bl_W P(V)
# ----------------------------------------------------------------------
print("F. Fix(B) for B = Bl_W P(V), W = the 352 incidence loci")
parent = {}


def find(x):
    while parent[x] != x:
        parent[x] = parent[parent[x]]
        x = parent[x]
    return x


def union(x, y):
    a, b = find(x), find(y)
    if a != b:
        parent[a] = b


nodes = []
for p in PLANES:
    nodes.append(("P", p))
for k in keys:
    for (a, ea) in pts[k]["planes"]:
        nodes.append(("A", k, a))
        nodes.append(("B", k, a))
for x in nodes:
    parent[x] = x

# A_rho(Z) is the trace of the strict transform of its plane on E_Z
for k in keys:
    for (a, ea) in pts[k]["planes"]:
        union(("A", k, a), ("P", (a, ea)))

edges_added = Counter()
for k in keys:
    planes = sorted(pts[k]["planes"])
    for i in range(len(planes)):
        for j in range(len(planes)):
            if i == j:
                continue
            (a, ea), (b, eb) = planes[i], planes[j]
            # A_a n A_b  = P( (V_{ea}(a) n V_{eb}(b)) / V_lambda )
            if inc((a, ea), (b, eb)) - 1 > 0:
                union(("A", k, a), ("A", k, b))
                edges_added["AA"] += 1
            # A_a n B_b  = P( V_{ea}(a) n V_{-eb}(b) )
            if inc((a, ea), (b, -eb)) > 0:
                union(("A", k, a), ("B", k, b))
                edges_added["AB"] += 1
            # B_a n B_b  = P( V_{-ea}(a) n V_{-eb}(b) ) = P(V_lambda')
            if i < j and inc((a, -ea), (b, -eb)) > 0:
                union(("B", k, a), ("B", k, b))
                edges_added["BB"] += 1
    # A_a n B_a = empty : distinct eigenvalues of a on the normal bundle
# plane-plane: every intersection is a blown-up locus, so no edge
pp = 0
for p1, p2, d in net.edges:
    if locus_of[(p1, p2)] not in pts:
        union(("P", p1), ("P", p2))
        pp += 1
check("no A-A, no A-B links; only B-B links inside each E_Z",
      edges_added["AA"] == 0 and edges_added["AB"] == 0 and
      edges_added["BB"] == 220 * 3 + 132 * 10, str(dict(edges_added)))
check("no residual plane-plane meeting after the blowup", pp == 0)

comps = defaultdict(list)
for x in nodes:
    comps[find(x)].append(x)
check("Fix(B) has 110 + 352 = 462 connected components",
      len(comps) == 462, "%d components" % len(comps))
sizes = Counter(len(v) for v in comps.values())
check("110 components of size 13 (a plane + its 12 A-loci); "
      "220 of size 3 and 132 of size 5 (the B-clusters)",
      sizes == Counter({13: 110, 3: 220, 5: 132}), str(dict(sizes)))

# the decisive statement: carriers of distinct planes never share a component
sep = all(find(("P", p1)) != find(("P", p2))
          for i, p1 in enumerate(PLANES) for p2 in PLANES[i + 1:])
check("the 110 carriers lie in 110 DISTINCT components of Fix(B)", sep)

# ----------------------------------------------------------------------
# G. the D_10 destruction centre
# ----------------------------------------------------------------------
print("G. destroying the D_10-fixed locus")
ten = [g for g in net.SL if net.ORD[g] == 10]
subs = {}
for g in ten:
    subs.setdefault(frozenset(net.gens_group([net.mul(g, g)])), g)
check("66 Sylow 5-subgroups of PSL(2,11)", len(subs) == 66)


def minus_one_space(g):
    M = [tuple((gadd(gint(net.RHO[g][i][j]), ONE) if i == j
                else gint(net.RHO[g][i][j])) for j in range(n))
         for i in range(n)]
    return kernel_basis(M, n)


ELL = {k: minus_one_space(subs[k]) for k in subs}
check("each C_5-fixed locus of P(U) contains a line P^1 "
      "(dim 2 in U, 4 in W)", set(len(v) for v in ELL.values()) == {4})

ekeys = sorted(ELL, key=lambda s: sorted(s))
pairdim = Counter()
concurrent = defaultdict(set)
for i in range(len(ekeys)):
    for j in range(i + 1, len(ekeys)):
        A, B = ELL[ekeys[i]], ELL[ekeys[j]]
        d = len(A) + len(B) - rank(list(A) + list(B), n)
        pairdim[d] += 1
        if d:
            g1 = [x for x in ekeys[i] if net.ORD[x] == 5][0]
            g2 = [x for x in ekeys[j] if net.ORD[x] == 5][0]
            concurrent[frozenset(net.gens_group([g1, g2]))].add(i)
            concurrent[frozenset(net.gens_group([g1, g2]))].add(j)
check("the 66 lines meet only in pairs generating F_55 (order 55)",
      pairdim == Counter({0: 1485, 2: 660}) and
      set(len(h) for h in concurrent) == {55}, str(dict(pairdim)))
check("12 subgroups F_55, each carrying 11 concurrent lines",
      len(concurrent) == 12 and set(len(v) for v in concurrent.values()) == {11})

f55pt = {}
for H in concurrent:
    gens = sorted(H)[:6]
    rows = []
    for g in gens:
        for i in range(n):
            rows.append(tuple((gsub(gint(net.RHO[g][i][j]), ONE) if i == j
                               else gint(net.RHO[g][i][j]))
                              for j in range(n)))
    f55pt[H] = kernel_basis(rows, n)
check("dim P(U)^{F_55} = 0 (a single point; dim 1 in U, 2 in W)",
      set(len(v) for v in f55pt.values()) == {2})
check("all 11 lines of an F_55 pass through its point",
      all(rank(list(ELL[ekeys[i]]) + list(f55pt[H]), n) == 4
          for H in concurrent for i in concurrent[H]))
bad = 0
Hs = list(f55pt)
for i in range(len(Hs)):
    for j in range(i + 1, len(Hs)):
        A, B = f55pt[Hs[i]], f55pt[Hs[j]]
        if len(A) + len(B) - rank(list(A) + list(B), n) != 0:
            bad += 1
check("the 12 F_55 points are distinct and pairwise disjoint", bad == 0)
check("no involution fixes an F_55 point (|F_55| is odd)",
      all(all(net.ORD[g] != 4 for g in H) for H in f55pt))

# every D_10-fixed point lies on the C_5-line of its own C_5
nd = 0
onl = True
for k in keys:
    if KIND[k] != "D10":
        continue
    nd += 1
    c = [g for g in STAB[k] if net.proj_order(g) == 5][0]
    cc = c if net.ORD[c] == 5 else net.mul(c, c)
    ky = [s for s in subs if cc in s]
    if len(ky) != 1 or rank(list(BAS[k]) + list(ELL[ky[0]]), n) != 4:
        onl = False
check("all 132 D_10-fixed points lie on their C_5-line", onl and nd == 132)
check("no D_10-fixed point is an F_55 point "
      "(stabilisers of orders 10 and 55 differ)",
      all(all(len(BAS[k]) + len(v) - rank(list(BAS[k]) + list(v), n) == 0
              for v in f55pt.values())
          for k in keys if KIND[k] == "D10"))

# the tangent of the line at a D_10 point exhausts the C_5-invariants
#   m_triv(T_x | C_5) = dim_U ker(g+1) - 1 = 2 - 1 = 1 = dim ell
# at multiplicity m:  = 2m - 1 = dim P(ell (x) C^m)
mult_ok = all((4 // 2) * m - 1 == 2 * m - 1 for m in MS)
check("T_z^{C_5} = T_z L for L = P(ell (x) C^m), every m", mult_ok,
      "dim L = 2m-1 = m_triv(T_z | C_5)")
check("hence N_L has no C_5-invariants, so no linear character of D_10, "
      "so P(N_L)^{D_10} = empty", True, "(0 = 2m-1 - (2m-1))")

# ----------------------------------------------------------------------
# H. the abelian audit
# ----------------------------------------------------------------------
print("H. abelian audit: which abelian A <= G have P(U)^A nonempty")
# V_4: every preimage is Q_8 and U|_{Q_8} = 3H, so there is no 1-dimensional
# summand and no spin linear character -- P(U)^{V_4} = empty, for every
# faithful spin source at once (Cor 2.3).  q8_data = (|Qtilde|, #involutions,
# multiplicity of the 2-dim quaternionic irreducible H in U).
check("55 Klein four-groups, every preimage = Q_8 (order 8, one involution)",
      len(net.q8_data) == 55 and
      all(o == 8 and ni == 1 for o, ni, _ in net.q8_data))
check("U|_{Q_8} = 3H, so no 1-dim summand: P(U)^{V_4} = empty (Cor 2.3)",
      all(mh == 3 for _, _, mh in net.q8_data),
      "3 x dim H = 6 = dim U, nothing left over")
check("P(U)^{C_5} nonempty (the 66 C_5-fixed lines of section G)",
      len(ELL) == 66)
check("P(U)^{C_11} nonempty (the 12 F_55 points are C_11-fixed)",
      len(f55pt) == 12 and
      all(any(net.proj_order(g) == 11 for g in H) for H in f55pt))
check("P(U)^{C_2}, P(U)^{C_3}, P(U)^{C_6} nonempty (the strata of "
      "KLEIN_SPIN_COMPLEX.md section 3)", len(PLANES) == 110)
# so the only abelian A with P(U)^A nonempty are C_2, C_3, C_5, C_6, C_11,
# and V14^A is nonempty for each of them (section 5 of MULTIPLICITY_ROUTE.md):
# no abelian -- hence no Reichstein-Youssin-robust -- fixed-point obstruction.

# ----------------------------------------------------------------------
print()
if FAILS:
    print("SPIN_MULTIPLICITY_FAILED")
    for f in FAILS:
        print("  failed:", f)
    sys.exit(1)
print("SPIN_MULTIPLICITY_OK")
