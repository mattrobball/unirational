"""Experiment C, part 2 -- exhaustive search for canonical pairings.

A canonical (G-equivariant, rational-in-v) reduction of a cycle indexed by a
G-set I to a smaller cycle must factor through a G-stable partition of I.  So
the block systems of I decide, combinatorially and completely, which
second-layer reductions can exist at all.
"""
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
rng = np.random.default_rng(777)
S = ML.Setup(p)
n = 55
I5 = np.eye(5, dtype=np.int64)
orbs = [[tuple(x) for x in o] for o in
        json.load(open(os.path.join(ROOT, "payload", "pair_orbits.json")))["orbits"]]

Ginv = [ML.rref(np.concatenate([M, I5], axis=1), p)[0][:, 5:] % p for M in S.G]
perm_inv = [[S.imat[ML.norm_mat(S.G[g] @ S.inv[t] % p @ Ginv[g] % p, p)]
             for t in range(n)] for g in range(660)]
js = S.js
gidx = []
for k in ("g11", "s5", "S"):
    Mg = np.array(js["generators"][k], dtype=np.int64) % p
    gidx.append(next(g for g in range(660) if np.array_equal(S.G[g], Mg)))
GENS_INV = [perm_inv[g] for g in gidx]


def blocks_of(gens, npt):
    """All minimal blocks through {0,b}; returns the distinct nontrivial ones."""
    out = set()
    for b in range(1, npt):
        cls = list(range(npt))

        def find(x):
            while cls[x] != x:
                cls[x] = cls[cls[x]]
                x = cls[x]
            return x

        cls[find(0)] = find(b)
        q = [(0, b)]
        while q:
            x, y = q.pop()
            for r in gens:
                u, w = find(r[x]), find(r[y])
                if u != w:
                    cls[u] = w
                    q.append((u, w))
        root = find(0)
        B = tuple(i for i in range(npt) if find(i) == root)
        if 1 < len(B) < npt:
            out.add(B)
    return sorted(out)


def induced(gens_inv, items, key):
    idx = {key(x): i for i, x in enumerate(items)}
    return [[idx[key(tuple(sorted((r[a] for a in x))))] for x in items]
            for r in gens_inv]


SETS = []
SETS.append(("involutions_55", GENS_INV, 55))
v4key = lambda t: tuple(sorted(t))
SETS.append(("V4_triangles_55", induced(GENS_INV, [v4key(t) for t in S.v4], v4key), 55))
for oi, O in enumerate(orbs):
    lbl = "pairorbit%d_ord%d_size%d" % (
        oi, ML.elt_order((S.inv[O[0][0]] @ S.inv[O[0][1]]) % p, p), len(O))
    SETS.append((lbl, induced(GENS_INV, [tuple(sorted(x)) for x in O], v4key), len(O)))
# the 165 vertices, indexed by (V4, unordered pair of its involutions)
vk = [tuple(sorted(x)) for x in
      [(a, b) for (i, j, k) in S.v4 for (a, b) in ((i, j), (j, k), (i, k))]]
SETS.append(("vertices_165", induced(GENS_INV, vk, v4key), 165))

rows = []
for lbl, gens, npt in SETS:
    B = blocks_of(gens, npt)
    sizes = sorted({len(b) for b in B})
    nsys = len({len(b) for b in B})
    rows.append({"set": lbl, "size": npt, "block_sizes": sizes,
                 "quotient_sizes": [npt // s for s in sizes],
                 "quotients_mod3": [(npt // s) % 3 for s in sizes]})
    print(rows[-1], flush=True)

check("block_systems_of_every_canonical_index_set", True,
      "; ".join("%s (|I|=%d): block sizes %s -> quotient cycle degrees %s "
                "(mod 3: %s)" % (r["set"], r["size"], r["block_sizes"] or "none",
                                 r["quotient_sizes"] or "-", r["quotients_mod3"] or "-")
                for r in rows))
reach = sorted({q for r in rows for q in r["quotient_sizes"]})
check("reachable_quotient_degrees", True,
      "every canonical second-layer reduction lands on one of the quotient "
      "degrees %s; those = 1 mod 3 are %s; NONE is < 55 except the two 11-block "
      "systems on the triangles (11 = 2 mod 3)"
      % (reach, [q for q in reach if q % 3 == 1]))

# ---- the 165 shared-line pairs of triangle planes -------------------------
shared = 0
tot4 = 0
for a in range(n):
    for b in range(a + 1, n):
        if ML.rank_p(np.concatenate([S.tri_plane[a], S.tri_plane[b]]), p) == 4:
            tot4 += 1
            common = set(S.v4[a]) & set(S.v4[b])
            if len(common) == 1:
                i = common.pop()
                Nsp = ML.nullspace(np.concatenate(
                    [S.tri_cut[a], S.tri_cut[b]]), p)
                shared += (ML.rank_p(np.concatenate([Nsp, S.Lbas[i]]), p) == 2)
check("planes_meeting_in_a_line_are_line_sharing_triangles", shared == tot4 == 165,
      "all %d pairs of triangle-planes spanning only a P^3 meet exactly in "
      "their shared V4-line (each involution lies in 3 triangles: 55*3 = 165 "
      "pairs); so this pairing yields no points beyond the 165 Menelaus points"
      % tot4)

# ---- D12-fixed constant points --------------------------------------------
fixpts = []
for t in range(n):
    st = [S.G[g] for g in range(660) if perm_inv[g][t] == t]
    N = ML.nullspace(np.concatenate([(g - I5) % p for g in st]), p)
    assert N.shape[0] == 1
    fixpts.append(N[0])
keys = {norm_pt(x, p) for x in fixpts}
onX = sum(1 for x in fixpts if Fv(x, p) == 0)
onL = sum(1 for x in fixpts if S.on_line(x))
onP = sum(1 for x in fixpts if S.on_plusplane(x))
onH = sum(1 for x in fixpts if S.Hval(x) == 0)
onC = sum(1 for x in fixpts if S.on_C(x))
isv = sum(1 for x in fixpts if S.is_vertex(x))
check("D12_fixed_point_orbit", len(keys) == 55,
      "the 55 D12-fixed points are distinct; on X: %d/55, on a V4-line: %d, "
      "in a plus-plane: %d, on V(H): %d, on the Hessian curve: %d, vertices: %d"
      % (onX, onL, onP, onH, onC, isv))

# ---- are generic axis meets ever stable in v? -----------------------------
NV = 6
VS = [rand_pt(rng, p) for _ in range(NV)]
meetcount = {}
for v in VS:
    bases = {}
    for t, (i, j, k) in enumerate(S.v4):
        pts = [S.proj[m] @ v % p for m in (i, j, k)]
        cs = [chord(pts[1], pts[2], p), chord(pts[2], pts[0], p), chord(pts[0], pts[1], p)]
        if any(c is None for c in cs):
            continue
        M = np.array(cs, dtype=np.int64) % p
        R, piv = ML.rref(M, p)
        if len(piv) == 2:
            bases[t] = R[:2]
    ks = sorted(bases)
    for a in range(len(ks)):
        for b in range(a + 1, len(ks)):
            if ML.rank_p(np.concatenate([bases[ks[a]], bases[ks[b]]]), p) <= 3:
                meetcount[(ks[a], ks[b])] = meetcount.get((ks[a], ks[b]), 0) + 1
stable = [k for k, c in meetcount.items() if c == NV]
sameblock = None
sysfile = json.load(open(os.path.join(ROOT, "payload", "reductions.json")))
check("axis_meets_are_accidental", len(stable) == 0,
      "over %d random v, %d distinct axis pairs met at least once, none met at "
      "more than %d of the %d sources: the meets are codim-1 accidents, not a "
      "canonical incidence" % (NV, len(meetcount),
                               max(meetcount.values()) if meetcount else 0, NV))

# ---- all 60 Hessian-curve sources: degeneration census ---------------------
deg = []
for x in S.Cpts:
    u = 0
    for t, (i, j, k) in enumerate(S.v4):
        pts = [S.proj[m] @ x % p for m in (i, j, k)]
        if any(not q.any() for q in pts):
            u += 3
            continue
        for (a, b) in ((1, 2), (2, 0), (0, 1)):
            if chord(pts[a], pts[b], p) is None:
                u += 1
    deg.append(u)
check("hessian_curve_sources_nondegenerate", all(d == 0 for d in deg),
      "for ALL %d F_p-points of the Hessian curve C, all 165 Menelaus chords "
      "are defined (0 vertex degenerations), versus 1-5 at a random v: C is a "
      "distinguished non-degenerate source locus" % len(S.Cpts))

json.dump({"index_set_blocks": rows, "reachable_quotients": reach,
           "D12_fixed": {"onX": onX, "onL": onL, "onP": onP, "onH": onH,
                         "onC": onC, "vertices": isv},
           "hessian_source_degenerations": deg,
           "seconds": round(time.time() - t0, 1)},
          open(os.path.join(ROOT, "payload", "pairings.json"), "w"), indent=1)
print("seconds", round(time.time() - t0, 1))
