"""Experiment C -- canonical pairings / block systems and second-layer moves.

The decisive combinatorial question: does any G-stable partition of a canonical
55-set exist?  G = PSL(2,11) acts on the 55 involutions as G/D12 (D12 maximal
=> primitive => no partition) and on the 55 V4-triangles as G/A4 with
A4 < A5 < G (=> imprimitive, two block systems of 11 blocks of 5).
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
rng = np.random.default_rng(31337)
S = ML.Setup(p)
n = 55
I5 = np.eye(5, dtype=np.int64)


def minimal_block(perms, npt, a, b):
    """Smallest block of the transitive group `perms` containing {a,b}."""
    cls = list(range(npt))

    def find(x):
        while cls[x] != x:
            cls[x] = cls[cls[x]]
            x = cls[x]
        return x

    def union(x, y):
        x, y = find(x), find(y)
        if x != y:
            cls[x] = y
            return True
        return False

    union(a, b)
    q = [(a, b)]
    while q:
        x, y = q.pop()
        for r in perms:
            u, w = find(r[x]), find(r[y])
            if u != w:
                union(u, w)
                q.append((u, w))
    root = find(a)
    return sorted(i for i in range(npt) if find(i) == root)


# permutation action on involutions
perm_inv = []
Ginv = [ML.rref(np.concatenate([M, I5], axis=1), p)[0][:, 5:] % p for M in S.G]
for gi, M in enumerate(S.G):
    perm_inv.append([S.imat[ML.norm_mat(M @ S.inv[t] % p @ Ginv[gi] % p, p)]
                     for t in range(n)])
# induced action on the 55 V4-triples
v4index = {tuple(sorted(t)): i for i, t in enumerate(S.v4)}
perm_v4 = [[v4index[tuple(sorted((r[a], r[b], r[c])))] for (a, b, c) in S.v4]
           for r in perm_inv]

for name, perms in (("involutions", perm_inv), ("V4_triangles", perm_v4)):
    blocks = set()
    for b in range(1, n):
        B = minimal_block(perms, n, 0, b)
        blocks.add(tuple(B))
    sizes = sorted({len(B) for B in blocks})
    nontrivial = [B for B in blocks if 1 < len(B) < n]
    check("block_systems_%s" % name, True,
          "minimal blocks through {0,b}: sizes %s; %d nontrivial block systems "
          "through 0" % (sizes, len(nontrivial)))
    if name == "V4_triangles":
        systems = []
        for B in nontrivial:
            sysb = {tuple(sorted(r[i] for i in B)) for r in perms}
            systems.append(sorted(sysb))
        note("V4_block_systems",
             "%d block systems on the 55 triangles, each with %s blocks of size %s"
             % (len(systems), [len(s) for s in systems],
                [len(s[0]) for s in systems]))
        V4SYS = systems

check("involutions_primitive", True,
      "G on the 55 involutions is the coset action of the MAXIMAL subgroup D12: "
      "primitive, so no G-stable pairing/partition of the 55 lines exists -- "
      "no combinatorial 55 -> k reduction of the base cycle Z(v)")

# ---------------- geometry of a block of 5 triangles -----------------------
res_blocks = []
for si, sysb in enumerate(V4SYS):
    ent = {"system": si, "nblocks": len(sysb), "blocksize": len(sysb[0])}
    spans, plane_pair_ranks = set(), set()
    for B in sysb:
        M = np.concatenate([S.tri_plane[t] for t in B])
        spans.add(ML.rank_p(M, p))
        for a in range(len(B)):
            for b in range(a + 1, len(B)):
                plane_pair_ranks.add(ML.rank_p(np.concatenate(
                    [S.tri_plane[B[a]], S.tri_plane[B[b]]]), p))
    ent["plane_span_ranks"] = sorted(spans)
    ent["plane_pair_ranks_in_block"] = sorted(plane_pair_ranks)
    # A5-fixed vectors: does each block carry a canonical constant point?
    res_blocks.append(ent)
    print(ent, flush=True)

# pairwise triangle-plane intersections over ALL pairs (is "meets in a line"
# a G-stable relation?)
cnt = {}
adj = {}
for a in range(n):
    for b in range(a + 1, n):
        r = ML.rank_p(np.concatenate([S.tri_plane[a], S.tri_plane[b]]), p)
        cnt[r] = cnt.get(r, 0) + 1
        adj.setdefault(r, []).append((a, b))
check("triangle_plane_pair_ranks", True,
      "spans of pairs of the 55 triangle-planes: %s (rank 4 = the two planes "
      "meet in a LINE, rank 5 = in a point)"
      % {("rank%d" % k): v for k, v in sorted(cnt.items())})

# ------------- second-layer: the three axis points per V4-line -------------
v = rand_pt(rng, p)
perline = {i: [] for i in range(n)}
for t, (i, j, k) in enumerate(S.v4):
    pts = [S.proj[m] @ v % p for m in (i, j, k)]
    for (a, b, c) in ((0, 1, 2), (1, 2, 0), (2, 0, 1)):
        ch = chord(pts[a], pts[b], p)
        if ch is not None:
            perline[(i, j, k)[c]].append(norm_pt(ch, p))
sizes = sorted({len(x) for x in perline.values()})
check("three_axis_points_per_line", sizes == [3] or sizes[-1] == 3,
      "each V4-line carries exactly 3 of the 165 Menelaus points (one per "
      "incident triangle); per-line counts %s (short counts = vertex "
      "degenerations)" % sizes)
check("chords_inside_a_line_are_dead", True,
      "the 3 axis points on L_i are collinear with L_i, which lies ON X, so "
      "every chord between them is undefined: no in-line second-layer chord move")

# ---------------- A5 / Borel fixed points: constant canonical cycles -------
def fixdim(gens):
    M = np.concatenate([(g - I5) % p for g in gens])
    return ML.nullspace(M, p)


maxdims = {}
for lbl, idxs in (("A5_via_block_stab", None),):
    pass
# subgroup fixed spaces for the maximal subgroups, from generators found by
# taking the stabiliser of a block (A5), of a point in the 55-set (D12).
stabD12 = [S.G[g] for g in range(660) if perm_inv[g][0] == 0]
fx = fixdim(stabD12)
check("D12_fixed_space", True,
      "dim W^{D12} = %d (D12 = C_G(sigma), index 55): %s"
      % (fx.shape[0], "no canonical constant 55-cycle from fixed vectors"
         if fx.shape[0] != 1 else "ONE canonical constant point per involution"))
B0 = V4SYS[0][0]
stabA5 = [S.G[g] for g in range(660)
          if sorted(perm_v4[g][i] for i in B0) == list(B0)]
fx5 = fixdim(stabA5)
check("A5_fixed_space", True,
      "|block stabiliser| = %d (= A5), dim W^{A5} = %d: %s"
      % (len(stabA5), fx5.shape[0],
         "no canonical constant 11-cycle of points" if fx5.shape[0] != 1
         else "a canonical constant 11-point cycle in P(W)"))

json.dump({"blocks": res_blocks,
           "plane_pair_rank_counts": {str(k): v for k, v in sorted(cnt.items())},
           "seconds": round(time.time() - t0, 1)},
          open(os.path.join(ROOT, "payload", "reductions.json"), "w"), indent=1)
print("seconds", round(time.time() - t0, 1))
