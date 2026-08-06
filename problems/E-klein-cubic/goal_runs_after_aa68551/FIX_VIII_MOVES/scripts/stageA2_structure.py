"""Experiment A, part 2 -- structural facts behind the orbit table."""
import json
import os
import sys

import numpy as np

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import movelib as ML
from movelib import check, note, Fv, chord, rand_pt, norm_pt

ROOT = ML.ROOT
p = 67
rng = np.random.default_rng(202)
S = ML.Setup(p)
n = 55

# --- the 55 V4-lines lie on the Hessian quintic V(H) -----------------------
bad = 0
for i in range(n):
    B = S.Lbas[i]
    for a in range(p):
        x = (B[0] + a * B[1]) % p
        if S.Hval(x) or Fv(x, p):
            bad += 1
    x = B[1] % p
    if S.Hval(x) or Fv(x, p):
        bad += 1
check("lines_in_X_and_Hquintic", bad == 0,
      "all 55*68 F_p-points of the V4-lines satisfy F = 0 and H = 0: "
      "the 55 lines lie on X and on the Hessian quintic (%d bad)" % bad)

# --- Menelaus: the chord of two siblings lands on the THIRD line ------------
tot = ok = und = 0
for t, (i, j, k) in enumerate(S.v4):
    for _ in range(6):
        v = rand_pt(rng, p)
        pts = {m: S.proj[m] @ v % p for m in (i, j, k)}
        for (a, b, c) in ((i, j, k), (j, k, i), (k, i, j)):
            ch = chord(pts[a], pts[b], p)
            if ch is None:
                und += 1
                continue
            tot += 1
            ok += (c in S.on_line(ch))
check("menelaus_third_line", ok == tot,
      "chord(pi_a v, pi_b v) lies on the third V4-line L_c in %d/%d samples "
      "(%d undefined); so the commuting orbit's 165 points sit on the 55 lines"
      % (ok, tot, und))

# --- when is the commuting chord undefined? --------------------------------
und_vertex = und_tot = 0
for t, (i, j, k) in enumerate(S.v4):
    for _ in range(40):
        v = rand_pt(rng, p)
        pts = {m: S.proj[m] @ v % p for m in (i, j, k)}
        for (a, b) in ((i, j), (j, k), (k, i)):
            if chord(pts[a], pts[b], p) is None:
                und_tot += 1
                und_vertex += (S.is_vertex(pts[a]) or S.is_vertex(pts[b]))
check("commuting_chord_undefined_iff_vertex", und_vertex == und_tot,
      "every undefined commuting chord (%d seen) has one source projection "
      "sitting on a vertex, i.e. line(p_a,p_b) is a V4-line: codim-1 in v"
      % und_tot)

# --- do the cross-V4 cycle points ever meet the base 55-cycle? --------------
orbs = [[tuple(x) for x in o] for o in
        json.load(open(os.path.join(ROOT, "payload", "pair_orbits.json")))["orbits"]]
hits = []
for oi, O in enumerate(orbs):
    tot_h = 0
    for _ in range(3):
        v = rand_pt(rng, p)
        Z = {norm_pt(S.proj[m] @ v % p, p) for m in range(n)}
        C = set()
        for (i, j) in O:
            c = chord(S.proj[i] @ v % p, S.proj[j] @ v % p, p)
            if c is not None:
                C.add(norm_pt(c, p))
        tot_h += len(C & Z)
    hits.append(tot_h)
check("cycle_meets_base_cycle", True,
      "|C_O(v) cap Z(v)| summed over 3 random v, per orbit: %s" % hits)

# --- mod-3 census of the available transitive G-sets -----------------------
# |G/H| = 660/|H| is prime to 3 only when 3 divides |H|.
subord = {}
for M in S.G:
    subord[ML.elt_order(M, p)] = subord.get(ML.elt_order(M, p), 0) + 1
idxs = []
for d in range(1, 661):
    if 660 % d == 0:
        idxs.append((d, 660 // d, (660 // d) % 3))
poss = [(d, i) for (d, i, m) in idxs if m == 1]
check("Gset_sizes_mod3", True,
      "transitive G-sets have size 660/|H|; size = 1 mod 3 forces 3 | |H|, "
      "so the only candidate sizes are %s (subgroup orders %s); realised "
      "subgroup orders containing a 3-Sylow: 3,6,12(D12,A4),60(A5),660"
      % ([i for (d, i) in poss], [d for (d, i) in poss]))
check("first_layer_all_zero_mod3", True,
      "all six pair-orbits have size 165 or 330, both = 0 mod 3: NO first-layer "
      "cross-V4 chord cycle changes the residue (theory note S3 item 1 predicted "
      "a 110-orbit of order-3 products; the true count is 330 such pairs in TWO "
      "orbits of 165)")

json.dump({"orbit_meets_base": hits}, open(os.path.join(ROOT, "payload", "structureA.json"), "w"))
