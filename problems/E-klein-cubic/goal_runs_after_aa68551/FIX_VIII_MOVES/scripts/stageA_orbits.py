"""Experiment A -- cross-V4 chord cycles over the conjugation orbits of pairs."""
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
rng = np.random.default_rng(11)
S = ML.Setup(p)
n = 55

# ------------------------------------------------------- classify all pairs
pairs = [(i, j) for i in range(n) for j in range(i + 1, n)]
ordij = {}
for (i, j) in pairs:
    ordij[(i, j)] = ML.elt_order((S.inv[i] @ S.inv[j]) % p, p)
byord = {}
for k, o in ordij.items():
    byord.setdefault(o, []).append(k)
check("pair_count_1485", len(pairs) == 1485,
      "C(55,2) = %d unordered pairs of distinct involutions" % len(pairs))
check("pair_order_partition", sum(len(v) for v in byord.values()) == 1485,
      "orders of sigma*tau: %s" % {o: len(v) for o, v in sorted(byord.items())})
check("commuting_are_165", len(byord.get(2, [])) == 165,
      "order(sigma tau) = 2  <=>  commuting: %d pairs" % len(byord.get(2, [])))

# ------------------------------------------------- conjugation orbits of pairs
# conjugation permutation of the 55 involutions, for each g in G
perm = []
Ginv = [ML.rref(np.concatenate([M, np.eye(5, dtype=np.int64)], axis=1), p)[0][:, 5:] % p
        for M in S.G]
for gi, M in enumerate(S.G):
    Mi = Ginv[gi]
    perm.append([S.imat[ML.norm_mat(M @ S.inv[t] % p @ Mi % p, p)] for t in range(n)])
perm = np.array(perm, dtype=np.int64)
check("conjugation_action_ok", perm.shape == (660, 55) and
      len({tuple(r) for r in perm}) == 660,
      "G acts faithfully on the 55 involutions by conjugation")

pidx = {pr: t for t, pr in enumerate(pairs)}
seen = set()
orbits = []
for pr in pairs:
    if pr in seen:
        continue
    orb = set()
    for r in perm:
        a, b = int(r[pr[0]]), int(r[pr[1]])
        orb.add((min(a, b), max(a, b)))
    seen |= orb
    orbits.append(sorted(orb))
orbits.sort(key=lambda o: (ordij[o[0]], -len(o)))
summary = [(ordij[o[0]], len(o)) for o in orbits]
check("pair_orbits", sum(len(o) for o in orbits) == 1485,
      "conjugation orbits (order(sigma tau), size): %s" % summary)


# --------------------------------------------------------------- cycle probes
INVP = np.array([0] + [pow(t, p - 2, p) for t in range(1, p)], dtype=np.int64)
WKEY = np.array([p ** 4, p ** 3, p ** 2, p, 1], dtype=np.int64)


def orbit_keys(pts, p):
    """canonical G-orbit label (int) for each projective point, vectorised."""
    P = np.array(pts, dtype=np.int64) % p
    best = None
    for M in S.G:
        Q = (P @ M.T) % p
        first = np.argmax(Q != 0, axis=1)
        sc = INVP[Q[np.arange(len(Q)), first]]
        Q = (Q * sc[:, None]) % p
        k = Q @ WKEY
        best = k if best is None else np.minimum(best, k)
    return [int(t) for t in best]


def measure(O, vs, tag):
    """Measure the cycle C_O(v) = {chord(pi_s v, pi_t v)} for each v in vs."""
    p_ = p
    rows = []
    for vi, v in enumerate(vs):
        pts, undef, coincide = [], 0, 0
        prj = [S.proj[t] @ v % p_ for t in range(n)]
        for (i, j) in O:
            a, b = prj[i], prj[j]
            if not a.any() or not b.any():
                coincide += 1
                continue
            if norm_pt(a, p_) == norm_pt(b, p_):
                coincide += 1
                continue
            c = chord(a, b, p_)
            if c is None:
                undef += 1
                continue
            pts.append(c)
        keys = [norm_pt(c, p_) for c in pts]
        dist = sorted(set(keys))
        allX = all(Fv(c, p_) == 0 for c in pts)
        rk = ML.rank_p(np.array(pts, dtype=np.int64), p_) if pts else 0
        inc = {"line": 0, "triplane": 0, "vertex": 0, "plusplane": 0,
               "Hquintic": 0, "Hcurve": 0}
        for k in dist:
            x = np.array(k, dtype=np.int64)
            if S.on_line(x):
                inc["line"] += 1
            if S.on_triplane(x):
                inc["triplane"] += 1
            if S.is_vertex(x):
                inc["vertex"] += 1
            if S.on_plusplane(x):
                inc["plusplane"] += 1
            if S.Hval(x) == 0:
                inc["Hquintic"] += 1
            if S.on_C(x):
                inc["Hcurve"] += 1
        rows.append({"v": [int(t) for t in v], "npts": len(pts),
                     "ndistinct": len(dist), "undefined": undef,
                     "coincident_sources": coincide, "all_on_X": bool(allX),
                     "span_rank": int(rk), "incidence": inc,
                     "collapse": len(dist) < len(O)})
    return rows


VS = [rand_pt(rng, p) for _ in range(4)]
table = []
for oi, O in enumerate(orbits):
    o_ = ordij[O[0]]
    rows = measure(O, VS, "orb%d" % oi)
    ent = {"orbit": oi, "prod_order": o_, "size": len(O),
           "size_mod3": len(O) % 3, "rows": rows}
    # G-orbit structure of the cycle points at the first v
    v = VS[0]
    prj = [S.proj[t] @ v % p for t in range(n)]
    pts = []
    for (i, j) in O:
        c = chord(prj[i], prj[j], p)
        if c is not None:
            pts.append(c)
    reps = orbit_keys(pts, p)
    cnt = {}
    for r in reps:
        cnt[r] = cnt.get(r, 0) + 1
    ent["Gorbits_met"] = len(cnt)
    ent["max_per_Gorbit"] = max(cnt.values()) if cnt else 0
    table.append(ent)
    print("orbit %d: ord=%d |O|=%d mod3=%d  distinct=%s  rank=%s  onX=%s "
          "undef=%s  Gorbits=%d/max=%d  inc=%s"
          % (oi, o_, len(O), len(O) % 3,
             [r["ndistinct"] for r in rows], [r["span_rank"] for r in rows],
             all(r["all_on_X"] for r in rows), [r["undefined"] for r in rows],
             ent["Gorbits_met"], ent["max_per_Gorbit"], rows[0]["incidence"]),
          flush=True)

allX = all(r["all_on_X"] for e in table for r in e["rows"])
check("cycle_points_on_X", allX,
      "every chord-cycle point lies on X, all %d pair-orbits x %d source points"
      % (len(orbits), len(VS)))
collapses = [(e["orbit"], e["prod_order"], e["size"],
              [r["ndistinct"] for r in e["rows"]])
             for e in table if any(r["collapse"] for r in e["rows"])]
check("first_layer_collapse_search", True,
      "orbits with |C_O(v)| < |O| at some v: %s" % (collapses or "NONE"))

out = {"p": p, "pair_orders": {str(o): len(v) for o, v in sorted(byord.items())},
       "orbit_summary": [[a, b] for a, b in summary], "table": table,
       "sources": [[int(t) for t in v] for v in VS],
       "seconds": round(time.time() - t0, 1)}
json.dump(out, open(os.path.join(ROOT, "payload", "orbit_table.json"), "w"), indent=1)
json.dump({"orbits": [[list(x) for x in o] for o in orbits]},
          open(os.path.join(ROOT, "payload", "pair_orbits.json"), "w"))
print("seconds", round(time.time() - t0, 1))
