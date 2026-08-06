"""Stage 0 -- rebuild and verify the setup (cheap checks from the brief)."""
import json
import os
import sys
import time

import numpy as np

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import movelib as ML
from movelib import check, note, Fv, chord, rand_pt, norm_pt

ROOT = ML.ROOT
p = 67
t0 = time.time()
rng = np.random.default_rng(20260806)

S = ML.Setup(p)
check("group_order_660", len(S.G) == 660, "BFS closure of g11,s5,S -> %d" % len(S.G))
prof = {}
for M in S.G:
    prof[ML.elt_order(M, p)] = prof.get(ML.elt_order(M, p), 0) + 1
check("order_profile", prof == {int(k): v for k, v in S.js["order_profile"].items()},
      "computed %s vs payload %s" % (sorted(prof.items()), S.js["order_profile"]))
check("involutions_55", len(S.inv) == 55, "%d elements of order 2" % len(S.inv))

# projectors land in X
ok = 0
for i in range(55):
    good = True
    for _ in range(12):
        v = rand_pt(rng, p)
        w = S.proj[i] @ v % p
        if not w.any() or Fv(w, p) != 0:
            good = False
            break
    ok += good
check("projectors_land_in_X", ok == 55, "%d/55 projectors pi_sigma=(I-sigma)/2 map into X (12 random v each)" % ok)

check("eigenspace_dims", all(b.shape[0] == 2 for b in S.Lbas) and all(b.shape[0] == 3 for b in S.Pbas),
      "dim V_-(sigma) = 2 (line L_sigma), dim V_+(sigma) = 3 (plus-plane) for all 55")

npairs = int(sum(S.commutes[i, j] for i in range(55) for j in range(i + 1, 55)))
check("commuting_pairs_165", npairs == 165, "%d commuting pairs of distinct involutions" % npairs)
check("v4_triples_55", len(S.v4) == 55, "%d V4-triples" % len(S.v4))
check("vertices_165", len(S.vertices) == 165, "%d distinct vertices (pairwise line meets)" % len(S.vertices))

# triangle = plane section of X:  X cap Pi_V4 = L1 u L2 u L3
# test: F restricted to the plane vanishes exactly on the 3 lines (F_p-points).
P2 = []
for a in range(p):
    for b in range(p):
        P2.append((1, a, b))
for b in range(p):
    P2.append((0, 1, b))
P2.append((0, 0, 1))
P2 = np.array(P2, dtype=np.int64)                # p^2+p+1 = 4557 points
assert len(P2) == p * p + p + 1


def Fvec(X, p):
    return sum((X[:, i] ** 2 % p) * X[:, (i + 1) % 5] for i in range(5)) % p


bad = 0
first = None
for t, (i, j, k) in enumerate(S.v4):
    B = S.tri_plane[t]
    X = P2 @ B % p
    onX_mask = Fvec(X, p) == 0
    Y = X[onX_mask]
    online = np.zeros(len(Y), dtype=bool)
    for m in (i, j, k):
        online |= ~(Y @ S.Lcut[m].T % p).any(axis=1)
    if not online.all():
        bad += 1
    if t == 0:
        first = (int(onX_mask.sum()), int(online.sum()))
note("triangle_plane_section_sample",
     "V4 #0: |X cap Pi (F_p)| = %d, of which on the three V4-lines: %d" % first)
check("triangles_are_plane_sections", bad == 0,
      "for all 55 V4-planes, every F_p-point of X cap Pi lies on one of the 3 V4-lines (%d bad)" % bad)

# chord map correctness on X-point pairs
okc = 0
tot = 0
deg = 0
degpairs = []
for _ in range(600):
    i, j = rng.integers(0, 55, size=2)
    if i == j:
        continue
    v = rand_pt(rng, p)
    a = S.proj[int(i)] @ v % p
    b = S.proj[int(j)] @ v % p
    if not a.any() or not b.any() or norm_pt(a, p) == norm_pt(b, p):
        continue
    c = chord(a, b, p)
    if c is None:                       # line(a,b) is contained in X
        deg += 1
        degpairs.append((int(i), int(j), bool(S.commutes[int(i), int(j)])))
        continue
    tot += 1
    # on X and collinear with a,b
    okc += (Fv(c, p) == 0 and ML.rank_p(np.stack([a, b, c]), p) == 2)
check("chord_third_point", okc == tot and tot > 400,
      "chord(a,b) on X and collinear with a,b in %d/%d random pi_sigma-pairs "
      "(+%d pairs where line(a,b) lies wholly on X, chord undefined)" % (okc, tot, deg))
note("chord_degenerate_pairs",
     "%d degenerate samples, commuting-flag multiset %s"
     % (deg, sorted({(x[2]) for x in degpairs})))

# chord symmetry (projective)
sym = True
for _ in range(50):
    v = rand_pt(rng, p)
    i, j = int(rng.integers(0, 55)), int(rng.integers(0, 55))
    if i == j:
        continue
    a, b = S.proj[i] @ v % p, S.proj[j] @ v % p
    c1, c2 = chord(a, b, p), chord(b, a, p)
    if c1 is None or c2 is None:
        continue
    sym &= (norm_pt(c1, p) == norm_pt(c2, p))
check("chord_symmetric", sym, "chord(a,b) = chord(b,a) projectively (unordered pairs well defined)")

# the base 55-cycle
v = rand_pt(rng, p)
Z = [S.proj[i] @ v % p for i in range(55)]
zn = {norm_pt(z, p) for z in Z}
check("base_cycle_55_distinct", len(zn) == 55,
      "Z(v) = {pi_sigma(v)} has %d distinct points, span rank %d" % (len(zn), ML.rank_p(np.stack(Z), p)))

# Hessian data sanity
check("hessian_degree_5", all(sum(m) == 5 for m in S.H), "H = det Hess F is a quintic, %d monomials" % len(S.H))
nC = sum(1 for x in S.Cpts if S.on_C(x))
check("cpoints_on_C", nC == len(S.Cpts),
      "%d/%d GATE cpoints satisfy all 5 partials of H = 0" % (nC, len(S.Cpts)))
onX = sum(1 for x in S.Cpts if Fv(x, p) == 0)
note("cpoints_on_X", "%d/%d Hessian-curve F_p-points also lie on X" % (onX, len(S.Cpts)))

out = {"p": p, "order": len(S.G), "profile": prof, "ninv": len(S.inv),
       "commuting_pairs": npairs, "v4": len(S.v4), "vertices": len(S.vertices),
       "cpoints": len(S.Cpts), "cpoints_on_X": onX,
       "seconds": round(time.time() - t0, 1)}
os.makedirs(os.path.join(ROOT, "payload"), exist_ok=True)
json.dump(out, open(os.path.join(ROOT, "payload", "setup.json"), "w"), indent=1)
print(json.dumps(out))
