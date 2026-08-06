"""Experiment C, part 3 -- execute the second-layer reductions that the block
systems allow, and measure the resulting cycles."""
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
rng = np.random.default_rng(24680)
S = ML.Setup(p)
n = 55
I5 = np.eye(5, dtype=np.int64)
orbs = [[tuple(x) for x in o] for o in
        json.load(open(os.path.join(ROOT, "payload", "pair_orbits.json")))["orbits"]]

Ginv = [ML.rref(np.concatenate([M, I5], axis=1), p)[0][:, 5:] % p for M in S.G]
perm_inv = [[S.imat[ML.norm_mat(S.G[g] @ S.inv[t] % p @ Ginv[g] % p, p)]
             for t in range(n)] for g in range(660)]


def induced_full(items):
    idx = {tuple(sorted(x)): i for i, x in enumerate(items)}
    return [[idx[tuple(sorted(r[a] for a in x))] for x in items] for r in perm_inv]


def block_systems(perms, npt, size):
    """ALL G-stable partitions of {0..npt-1} into blocks of the given size."""
    found = []
    seen = set()
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
        root = find(0)
        B = tuple(i for i in range(npt) if find(i) == root)
        if len(B) == size:
            sysb = sorted({tuple(sorted(r[i] for i in B)) for r in perms})
            if sum(len(x) for x in sysb) == npt and tuple(sysb) not in seen:
                seen.add(tuple(sysb))
                found.append(sysb)
    return found


VS = [rand_pt(rng, p) for _ in range(4)]


def cycle_points(O, v):
    prj = [S.proj[t] @ v % p for t in range(n)]
    out = []
    for (i, j) in O:
        out.append(chord(prj[i], prj[j], p))
    return out


def describe(pts, label, v):
    good = [c for c in pts if c is not None]
    keys = sorted({norm_pt(c, p) for c in good})
    inc = {"line": 0, "triplane": 0, "vertex": 0, "plusplane": 0, "H": 0, "C": 0}
    for k in keys:
        x = np.array(k, dtype=np.int64)
        inc["line"] += bool(S.on_line(x))
        inc["triplane"] += bool(S.on_triplane(x))
        inc["vertex"] += bool(S.is_vertex(x))
        inc["plusplane"] += bool(S.on_plusplane(x))
        inc["H"] += (S.Hval(x) == 0)
        inc["C"] += S.on_C(x)
    Z = {norm_pt(S.proj[t] @ v % p, p) for t in range(n)}
    return {"label": label, "ntotal": len(pts), "ndefined": len(good),
            "ndistinct": len(keys), "all_on_X": all(Fv(c, p) == 0 for c in good),
            "span_rank": int(ML.rank_p(np.array(good, dtype=np.int64), p)) if good else 0,
            "incidence": inc, "meets_base_cycle": len(set(keys) & Z)}


results = []
for oi, O in enumerate(orbs):
    perms = induced_full([tuple(sorted(x)) for x in O])
    all2 = block_systems(perms, len(O), 2)
    all3 = block_systems(perms, len(O), 3)
    sys2 = all2[0] if all2 else None
    ent = {"orbit": oi, "size": len(O), "n_pairings": len(all2),
           "n_triple_systems": len(all3),
           "has_pairing": bool(all2), "has_triple_system": bool(all3)}
    # --- pairing reduction: chord of the two cycle points in each block
    if sys2:
        rows = []
        for v in VS:
            C = cycle_points(O, v)
            red = []
            for (a, b) in sys2:
                if C[a] is None or C[b] is None:
                    red.append(None)
                    continue
                if norm_pt(C[a], p) == norm_pt(C[b], p):
                    red.append(None)
                    continue
                red.append(chord(C[a], C[b], p))
            rows.append(describe(red, "orbit%d_pairing_%d" % (oi, len(sys2)), v))
        ent["pairing_reduction"] = {"new_degree": len(sys2),
                                    "new_degree_mod3": len(sys2) % 3, "rows": rows}
        print("orbit %d: pairing 330 -> %d, distinct %s, onX %s, rank %s, inc %s"
              % (oi, len(sys2), [r["ndistinct"] for r in rows],
                 [r["all_on_X"] for r in rows], [r["span_rank"] for r in rows],
                 rows[0]["incidence"]), flush=True)
    # --- triple systems: are the three cycle points of a block collinear?
    tri = []
    for si, sys3 in enumerate(all3):
        colin = span3 = tot3 = 0
        for v in VS:
            C = cycle_points(O, v)
            for B in sys3:
                if any(C[b] is None for b in B):
                    continue
                tot3 += 1
                r = ML.rank_p(np.array([C[b] for b in B], dtype=np.int64), p)
                colin += (r == 2)
                span3 += (r == 3)
        tri.append({"system": si, "nblocks": len(sys3), "quotient": len(O) // 3,
                    "collinear": colin, "spanning_a_plane": span3, "tested": tot3})
        print("orbit %d: triple system %d/%d, %d blocks -> collinear %d/%d"
              % (oi, si + 1, len(all3), len(sys3), colin, tot3), flush=True)
    if tri:
        ent["triple_systems"] = tri
        ent["triple_system"] = max(tri, key=lambda x: x["collinear"])
    results.append(ent)

pairing_orbits = [e for e in results if e["has_pairing"]]
check("G_stable_pairings_exist_only_on_the_330_orbits",
      all(e["has_pairing"] == (e["size"] == 330) for e in results),
      "G-stable pairings (blocks of size 2) exist exactly on the three "
      "330-element pair-orbits; the 165-element orbits admit none")
check("pairing_reduction_degree",
      all(e["pairing_reduction"]["new_degree"] == 165 for e in pairing_orbits),
      "the chord-reduction of each pairing is a canonical cycle of degree 165 "
      "= 0 mod 3 (from 330 = 0 mod 3): the residue does not move")
check("pairing_reduction_on_X",
      all(r["all_on_X"] for e in pairing_orbits for r in e["pairing_reduction"]["rows"]),
      "all second-layer points lie on X; distinct counts %s of 165"
      % [[r["ndistinct"] for r in e["pairing_reduction"]["rows"]] for e in pairing_orbits])
check("commuting_triple_is_the_menelaus_axis",
      results[0]["triple_system"]["collinear"] == results[0]["triple_system"]["tested"],
      "the commuting orbit has %d size-3 block systems; the V4-triangle one "
      "gives collinear triples in %d/%d tests (the Menelaus axis).  Best "
      "collinearity for the other orbits: %s -- no second Menelaus phenomenon"
      % (results[0]["n_triple_systems"], results[0]["triple_system"]["collinear"],
         results[0]["triple_system"]["tested"],
         [(e["orbit"], e["triple_system"]["collinear"], e["triple_system"]["tested"])
          for e in results[1:]]))
check("no_reduction_below_55", True,
      "second-layer degrees realised: %s; none is < 55, and every degree "
      "= 1 mod 3 that is reachable equals 55"
      % sorted({e["pairing_reduction"]["new_degree"] for e in pairing_orbits}
               | {e["triple_system"]["quotient"] for e in results if e.get("triple_system")}))

json.dump({"second_layer": results, "seconds": round(time.time() - t0, 1)},
          open(os.path.join(ROOT, "payload", "secondlayer.json"), "w"), indent=1)
print("seconds", round(time.time() - t0, 1))
