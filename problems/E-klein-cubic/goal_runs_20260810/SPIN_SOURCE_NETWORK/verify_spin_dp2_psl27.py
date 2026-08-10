#!/usr/bin/env python3
"""
Part 3 -- the NEW EXAMPLE: the spin flank of Problem F.

G      = PSL(2,F_7)  (order 168)
Gtilde = SL(2,F_7)   (order 336)
U      = a 4-dimensional faithful (spin) irreducible of SL(2,7)
source = P(U) = P^3, a projectively-linear (Severi-Brauer type) G-source
target = S, the Klein degree-two del Pezzo surface

Problem F (certificates/WP3_ALL_DEGREE_PATH_OBSTRUCTION.md) closes every
LINEAR source.  Its engine runs on the quadruple points of the 21-line Klein
arrangement, where the central involution z of the D_8 stabiliser acts on the
tangent space by the SCALAR -1, so the exceptional curve is pointwise
z-fixed.  This verifier shows exactly what the spin source does to that
engine, and computes the spin network of P(U) = P^3 in full.

Runs the q = 11 case too, as an independent cross-check of
verify_spin_klein_network.py (different code path, same numbers).

Replay:  python3 verify_spin_dp2_psl27.py
Marker :  SPIN_DP2_PSL27_OK
"""

import sys
import json
from fractions import Fraction as Fr
from spin_network_lib import SpinNetwork

FAILS, CHECKS = [], []


def CHECK(name, ok, detail=""):
    CHECKS.append((name, bool(ok), detail))
    if not ok:
        FAILS.append(name)


N = SpinNetwork(7)

CHECK("SL2_F7_order_336", len(N.SL) == 336, f"|SL(2,7)| = {len(N.SL)}")
CHECK("unique_involution",
      [g for g in N.SL if N.ORD[g] == 2] == [N.NEG],
      "-I is the only involution of SL(2,7): every V_4 of PSL(2,7) lifts "
      "to Q_8, and every C_4 lifts to C_8")
CHECK("W7_is_spin",
      N.RHO[N.NEG] == [[-1 if i == j else 0 for j in range(8)]
                       for i in range(8)],
      "rho(-I) = -id_8: W_7 = Ind_B(chi) is purely spin")
CHECK("W7_is_U_plus_Uprime",
      sum(N.CHI[g] * N.CHI[N.inv(g)] for g in N.SL) == 2 * 336,
      "<chi_W, chi_W> = 2, so W_7 = U (+) U' with dim U = 4: U is one of "
      "the two 4-dimensional spin irreducibles of SL(2,7)")
CHECK("21_involutions", N.nInv == 21,
      f"PSL(2,7) has {N.nInv} involutions (one class)")

# ---- (i) the Q_8 restriction -----------------------------------------
sizes = set(x[0] for x in N.q8_data)
ninvs = set(x[1] for x in N.q8_data)
mHs = set(x[2] for x in N.q8_data)
CHECK("V4_preimages_are_Q8",
      sizes == {8} and ninvs == {1},
      f"all {len(N.V4S)} Klein four-groups of PSL(2,7) have preimage of "
      "order 8 with a unique involution, i.e. Q_8")
CHECK("U_restricted_to_Q8_is_2H", mHs == {2},
      f"U|_{{Q_8}} = 2 * H (H the 2-dim quaternionic irreducible), "
      "NO 1-dimensional summand, hence P(U)^{V_4} = EMPTY")

# ---- (ii) the eigen-strata: 42 LINES in P^3 ---------------------------
CHECK("chi_vanishes_on_order4",
      all(N.CHI[g] == 0 for g in N.SL if N.ORD[g] == 4),
      "chi_W = 0 on the order-4 elements, so each lifted involution has "
      "eigenvalue multiplicities 2 and 2 on U")
CHECK("42_eigenlines",
      len(N.PLANES) == 42 and all(len(N.EB[p]) == 4 for p in N.PLANES),
      "P(U)^sigma = P(U_{+i}) disjoint-union P(U_{-i}) = P^1 disjoint-union "
      "P^1: the network has 42 LINES in P^3")

tc = {}
for v in N.PAIRTYPE.values():
    tc[v] = tc.get(v, 0) + 1
CHECK("pair_types_2_3_4",
      set(tc) == {2, 3, 4},
      "orders of sigma*tau over the 210 unordered pairs of involutions: "
      + json.dumps({str(k): v for k, v in sorted(tc.items())})
      + " -- only V_4, S_3 and D_8 occur (D_14 is not a subgroup of "
        "PSL(2,7): N_G(C_7) = F_21 has no involution)")

table = {}
for (p1, p2), d in N.INCID.items():
    key = ("same involution" if p1[0] == p2[0]
           else f"n = {N.ptype(p1[0], p2[0])}")
    table.setdefault(key, {}).setdefault(d, 0)
    table[key][d] += 1

CHECK("V4_pairs_disjoint",
      all(d == 0 for (p1, p2), d in N.INCID.items()
          if p1[0] != p2[0] and N.ptype(p1[0], p2[0]) == 2),
      "commuting involutions: lines disjoint (quaternionic mechanism, "
      "U = U_{+i}(sigma) (+) U_{eps i}(tau))")
CHECK("D8_pairs_disjoint",
      all(d == 0 for (p1, p2), d in N.INCID.items()
          if p1[0] != p2[0] and N.ptype(p1[0], p2[0]) == 4),
      "D_8-generating pairs: lines disjoint, i.e. P(U)^{D_8} = EMPTY "
      "(the preimage Q_16 has no linear character nontrivial on -I) -- "
      "the exact analogue of P(U)^{D_12} = EMPTY in the Klein case")
CHECK("S3_pairs_meet",
      any(d == 1 for (p1, p2), d in N.INCID.items()
          if p1[0] != p2[0] and N.ptype(p1[0], p2[0]) == 3),
      "S_3-generating pairs are the ONLY incidences")

PTS = N.incidence_points()
hist = {}
for rec in PTS.values():
    k = len(rec["planes"])
    hist[k] = hist.get(k, 0) + 1
CHECK("incidence_points_S3",
      set(hist) == {3},
      f"{len(PTS)} distinct incidence points, each on "
      + json.dumps({f"{k} lines": v for k, v in sorted(hist.items())}))

rep = next(iter(PTS.values()))
st = N.stab_of_point(rep)
CHECK("point_stabilizer_is_S3", len(st) == 6,
      f"|Stab_G(x)| = {len(st)} at an incidence point: exactly S_3")

TR = N.tangent_report(rep)
CHECK("tangent_has_no_trivial_summand",
      TR[2] == 0 and TR[1] == 3,
      f"T_x is a {TR[1]}-dimensional S_3-representation with m_triv = "
      f"{TR[2]}, m_sign = {TR[3]}; dim T^(sigma,+) = {TR[4]}, "
      f"dim T^(sigma,-) = {TR[5]}")
CHECK("no_scalar_birth",
      TR[4] != 0 and TR[5] != 0,
      "sigma acts on T_x with BOTH eigenvalues present, so it is never "
      "scalar: the Problem-F scalar-birth linking (WP3 Lemma T2.1, where "
      "dz|_q = -1 is scalar because dim E_+(z) = 1) has NO spin analogue")

comps = N.components()
CHECK("network_connected", len(comps) == 1,
      f"the 42-line incidence network is connected ({len(comps)} component)")
deg = sorted(set(len(N.adj[p]) for p in N.PLANES))
d0 = N.bfs(N.PLANES[0])
CHECK("network_regular", len(deg) == 1,
      f"the network is {deg[0]}-regular, eccentricity {max(d0.values())}")

# planes of a D_8-generating pair are non-adjacent: how far apart?
d8d = set()
a0 = N.PLANES[0][0]
for (b, e) in N.PLANES:
    if b != a0 and N.ptype(a0, b) == 4:
        d8d.add(d0[(b, e)])
CHECK("D8_pairs_never_adjacent", 1 not in d8d,
      f"lines of a D_8-generating pair are never adjacent; they sit at "
      f"graph distance {sorted(d8d)}")

# ---- cross-check against the Klein verifier ---------------------------
N11 = SpinNetwork(11)
h11 = {}
for rec in N11.incidence_points().values():
    k = len(rec["planes"])
    h11[k] = h11.get(k, 0) + 1
CHECK("crosscheck_q11",
      len(N11.PLANES) == 110 and len(N11.edges) == 1980 and
      h11 == {3: 220, 5: 132} and len(N11.components()) == 1 and
      set(x[2] for x in N11.q8_data) == {3},
      "independent recomputation of the q = 11 network by this library "
      "reproduces verify_spin_klein_network.py exactly: 110 planes, "
      "1980 edges, 220 S_3-points + 132 D_10-points, connected, "
      "U|_{Q_8} = 3H")


def main():
    print("=" * 72)
    print("SPIN FLANK OF PROBLEM F  --  P(U) = P^3, Gtilde = SL(2,F_7)")
    print("=" * 72)
    for name, ok, det in CHECKS:
        print(f"[{'OK ' if ok else 'FAIL'}] {name:34s} {det}")
    print()
    print("-" * 72)
    print("INCIDENCE TABLE of the 42 eigenlines (861 unordered pairs)")
    print("-" * 72)
    for key in sorted(table):
        row = table[key]
        dd = ", ".join(f"dim {k}: {v}" for k, v in sorted(row.items()))
        print(f"{key:22s} {sum(row.values()):6d}  {dd}")
    print()
    print(f"edges                     : {len(N.edges)}")
    print(f"distinct incidence points : {len(PTS)} (each on 3 lines, "
          f"Stab = S_3)")
    print(f"components / regularity   : {len(comps)} / {deg[0]}-regular, "
          f"eccentricity {max(d0.values())}")
    print(f"T_x at an incidence point : dim {TR[1]}, m_triv {TR[2]}, "
          f"m_sign {TR[3]}, T^(s,+) {TR[4]}, T^(s,-) {TR[5]}")
    print()
    if FAILS:
        print("FAILURES:", FAILS)
        print("SPIN_DP2_PSL27_FAILED")
        return 1
    print("SPIN_DP2_PSL27_OK")
    return 0


if __name__ == "__main__":
    sys.exit(main())
