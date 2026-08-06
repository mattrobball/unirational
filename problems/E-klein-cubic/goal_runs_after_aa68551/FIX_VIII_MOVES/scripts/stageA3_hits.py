"""Experiment A, part 3 -- why do cross-V4 chords land back on Z(v)?

For each pair-orbit, record which pairs {sigma,tau} satisfy
chord(pi_sigma v, pi_tau v) in Z(v), and whether the hit is stable in v.
"""
import json
import os
import sys

import numpy as np

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import movelib as ML
from movelib import check, note, Fv, chord, rand_pt, norm_pt

ROOT = ML.ROOT
p = 67
rng = np.random.default_rng(555)
S = ML.Setup(p)
n = 55
orbs = [[tuple(x) for x in o] for o in
        json.load(open(os.path.join(ROOT, "payload", "pair_orbits.json")))["orbits"]]

NV = 8
VS = [rand_pt(rng, p) for _ in range(NV)]
res = []
for oi, O in enumerate(orbs):
    hit_count = {pr: 0 for pr in O}
    hit_rho = {pr: set() for pr in O}
    per_v = []
    for v in VS:
        prj = [S.proj[t] @ v % p for t in range(n)]
        keys = {norm_pt(x, p): t for t, x in enumerate(prj)}
        h = 0
        for pr in O:
            c = chord(prj[pr[0]], prj[pr[1]], p)
            if c is None:
                continue
            k = norm_pt(c, p)
            if k in keys:
                h += 1
                hit_count[pr] += 1
                hit_rho[pr].add(keys[k])
        per_v.append(h)
    always = [pr for pr in O if hit_count[pr] == NV]
    never = [pr for pr in O if hit_count[pr] == 0]
    res.append({"orbit": oi, "size": len(O), "hits_per_v": per_v,
                "pairs_always_hitting": len(always),
                "pairs_never_hitting": len(never),
                "pairs_sometimes": len(O) - len(always) - len(never)})
    print("orbit %d |O|=%d: hits/v=%s  always=%d never=%d sometimes=%d"
          % (oi, len(O), per_v, len(always), len(never), len(O) - len(always) - len(never)),
          flush=True)

check("base_cycle_hits_are_accidental",
      all(r["pairs_always_hitting"] == 0 for r in res),
      "no pair {sigma,tau} has chord(pi_sigma v, pi_tau v) in Z(v) for all %d "
      "random v; per-orbit (always, sometimes, never) = %s -- the elevated hit "
      "rate (~2-3%% vs 0.02%% chance) is a union of codim-1 coincidence loci, "
      "not an identity"
      % (NV, [(r["pairs_always_hitting"], r["pairs_sometimes"],
               r["pairs_never_hitting"]) for r in res]))

# is the hit rate explained by  chord in Z  <=>  the three points are collinear
# with a line of the arrangement?  measure how often the hit point is the
# projection pi_rho with rho in <sigma,tau>.
insub = tot = 0
for oi, O in enumerate(orbs):
    if oi == 0:
        continue
    for v in VS[:3]:
        prj = [S.proj[t] @ v % p for t in range(n)]
        keys = {norm_pt(x, p): t for t, x in enumerate(prj)}
        for pr in O:
            c = chord(prj[pr[0]], prj[pr[1]], p)
            if c is None:
                continue
            k = norm_pt(c, p)
            if k not in keys:
                continue
            tot += 1
            # generate <sigma,tau> and list its involutions
            sub = {ML.norm_mat(np.eye(5, dtype=np.int64), p)}
            frontier = [np.eye(5, dtype=np.int64)]
            mats = [np.eye(5, dtype=np.int64)]
            gens = [S.inv[pr[0]], S.inv[pr[1]]]
            while frontier:
                nx = []
                for M in frontier:
                    for g in gens:
                        N = g @ M % p
                        kk = ML.norm_mat(N, p)
                        if kk not in sub:
                            sub.add(kk)
                            mats.append(N)
                            nx.append(N)
                frontier = nx
            ivs = {S.imat[ML.norm_mat(M, p)] for M in mats
                   if ML.norm_mat(M, p) in S.imat}
            insub += (keys[k] in ivs)
check("base_cycle_hit_inside_subgroup", True,
      "of %d observed hits, %d have the hit index rho inside <sigma,tau>" % (tot, insub))

json.dump({"per_orbit": res, "hits_in_subgroup": [insub, tot]},
          open(os.path.join(ROOT, "payload", "basehits.json"), "w"), indent=1)
