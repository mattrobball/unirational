"""Experiment C, part 4 -- the 11-block route, the only combinatorial door
below degree 55.  Measure the geometry of a block of 5 triangles / 15 Menelaus
points: is there any canonical 15 -> 1 or 5 -> 1 rule in sight?"""
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
rng = np.random.default_rng(1111)
S = ML.Setup(p)
n = 55
I5 = np.eye(5, dtype=np.int64)
Ginv = [ML.rref(np.concatenate([M, I5], axis=1), p)[0][:, 5:] % p for M in S.G]
perm_inv = [[S.imat[ML.norm_mat(S.G[g] @ S.inv[t] % p @ Ginv[g] % p, p)]
             for t in range(n)] for g in range(660)]
v4index = {tuple(sorted(t)): i for i, t in enumerate(S.v4)}
perm_v4 = [[v4index[tuple(sorted((r[a], r[b], r[c])))] for (a, b, c) in S.v4]
           for r in perm_inv]


def block_systems(perms, npt, size):
    found, seen = [], set()
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
            for r in perms:
                u, w = find(r[x]), find(r[y])
                if u != w:
                    cls[u] = w
                    q.append((u, w))
        B = tuple(i for i in range(npt) if find(i) == find(0))
        if len(B) == size:
            sysb = sorted({tuple(sorted(r[i] for i in B)) for r in perms})
            if sum(len(x) for x in sysb) == npt and tuple(sysb) not in seen:
                seen.add(tuple(sysb))
                found.append(sysb)
    return found


SYS = block_systems(perm_v4, 55, 5)
check("two_11_block_systems_on_triangles", len(SYS) == 2 and all(len(s) == 11 for s in SYS),
      "the 55 V4-triangles carry exactly %d G-stable partitions into %s blocks "
      "of 5 (A4 < A5 < G, two classes of A5): the only canonical route to a "
      "cycle of degree 11 = 2 mod 3; two systems give 11+11 = 22 = 1 mod 3"
      % (len(SYS), [len(s) for s in SYS]))

mons2, idx2 = None, None
from itertools import combinations_with_replacement
MON2 = list(combinations_with_replacement(range(5), 2))


def veronese2(x, p):
    return np.array([x[a] * x[b] % p for (a, b) in MON2], dtype=np.int64)


rows = []
for si, sysb in enumerate(SYS):
    for vi in range(8):
        v = rand_pt(rng, p)
        lin, quad, axspan, meets = set(), set(), set(), 0
        for B in sysb:
            pts, bases = [], []
            for t in B:
                i, j, k = S.v4[t]
                q = [S.proj[m] @ v % p for m in (i, j, k)]
                cs = [chord(q[1], q[2], p), chord(q[2], q[0], p), chord(q[0], q[1], p)]
                if any(c is None for c in cs):
                    bases = None
                    break
                pts += cs
                R, piv = ML.rref(np.array(cs, dtype=np.int64) % p, p)
                bases.append(R[:2])
            if bases is None:
                continue
            M = np.array(pts, dtype=np.int64) % p
            lin.add(ML.rank_p(M, p))
            quad.add(ML.rank_p(np.array([veronese2(x, p) for x in M]), p))
            axspan.add(ML.rank_p(np.concatenate(bases), p))
            for a in range(len(bases)):
                for b in range(a + 1, len(bases)):
                    meets += (ML.rank_p(np.concatenate([bases[a], bases[b]]), p) <= 3)
        rows.append({"system": si, "v": vi, "linear_ranks": sorted(lin),
                     "veronese2_ranks": sorted(quad), "axis_span_ranks": sorted(axspan),
                     "meeting_axis_pairs_in_block": meets})
        print(rows[-1], flush=True)

ndrop = sum(1 for r in rows if 14 in r["veronese2_ranks"])
check("block_of_15_no_common_quadric", ndrop <= len(rows) // 4,
      "the 15 Menelaus points of an 11-block impose independent conditions on "
      "quadrics: Veronese rank 15/15; a rank-14 block (one canonical quadric) "
      "occurred in %d of %d (system, v) samples of 11 blocks each -- ~1/p "
      "accidents, not structure: no canonical quadric, no 15 -> 1 "
      "linear-algebra reduction" % (ndrop, len(rows)))
check("block_of_5_axes_generic",
      all(r["axis_span_ranks"] == [5] and r["meeting_axis_pairs_in_block"] == 0
          for r in rows),
      "the 5 Menelaus axes of an 11-block span all of P^4 and are pairwise "
      "disjoint at every tested v: no canonical 5 -> 1 incidence either")

json.dump({"rows": rows, "n_block_systems": len(SYS),
           "seconds": round(time.time() - t0, 1)},
          open(os.path.join(ROOT, "payload", "blocks11.json"), "w"), indent=1)
print("seconds", round(time.time() - t0, 1))
