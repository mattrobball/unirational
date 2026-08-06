"""Experiment A, part 4 -- the geometry of <sigma,tau> for each pair orbit.

The V4 story (3 coplanar lines = a plane section of X) is the n=2 case.  Here we
ask the same question for the dihedral subgroups D_n = <sigma,tau>, n = 3,5,6:
how do their n involution-lines sit, and is there a second "triangle calculus"?
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
rng = np.random.default_rng(9001)
S = ML.Setup(p)
n = 55
I5 = np.eye(5, dtype=np.int64)
orbs = [[tuple(x) for x in o] for o in
        json.load(open(os.path.join(ROOT, "payload", "pair_orbits.json")))["orbits"]]


def gen_sub(idxs):
    seen = {ML.norm_mat(I5, p): I5}
    frontier = [I5]
    gens = [S.inv[t] for t in idxs]
    while frontier:
        nx = []
        for M in frontier:
            for g in gens:
                N = g @ M % p
                k = ML.norm_mat(N, p)
                if k not in seen:
                    seen[k] = N
                    nx.append(N)
        frontier = nx
    return list(seen.values())


def sub_key(mats):
    return tuple(sorted(ML.norm_mat(M, p) for M in mats))


table = []
subclass = {}
for oi, O in enumerate(orbs):
    subs = {}
    for pr in O:
        mats = gen_sub(pr)
        subs.setdefault(sub_key(mats), []).append(pr)
    # geometry of one representative
    k0 = sorted(subs)[0]
    mats = gen_sub(subs[k0][0])
    ivs = sorted({S.imat[ML.norm_mat(M, p)] for M in mats
                  if ML.norm_mat(M, p) in S.imat})
    B = np.concatenate([S.Lbas[t] for t in ivs])
    span = ML.rank_p(B, p)
    cut = np.concatenate([S.Lcut[t] for t in ivs])
    common = ML.nullspace(cut, p)          # points on ALL the lines
    conc = int(common.shape[0])
    # pairwise meets among the lines of the subgroup
    meets = 0
    for a in range(len(ivs)):
        for b in range(a + 1, len(ivs)):
            if ML.rank_p(np.concatenate([S.Lbas[ivs[a]], S.Lbas[ivs[b]]]), p) == 3:
                meets += 1
    ent = {"orbit": oi, "prod_order": ML.elt_order((S.inv[O[0][0]] @ S.inv[O[0][1]]) % p, p),
           "orbit_size": len(O), "nsubgroups": len(subs),
           "sub_order": len(mats), "ninvolutions": len(ivs),
           "line_span_rank": span, "concurrency_dim": conc,
           "pairwise_meeting_line_pairs": meets,
           "npairs_per_subgroup": len(subs[k0])}
    table.append(ent)
    subclass[oi] = subs
    print(ent, flush=True)

check("dihedral_subgroup_geometry", True,
      "per pair-orbit (prod_order, #subgroups, |D|, #inv-lines, span rank, "
      "concurrency dim, #meeting line pairs) = %s"
      % [(e["prod_order"], e["nsubgroups"], e["sub_order"], e["ninvolutions"],
          e["line_span_rank"], e["concurrency_dim"],
          e["pairwise_meeting_line_pairs"]) for e in table])

# the two order-3 classes: 55 S3-subgroups each -> two canonical 55-element
# G-sets besides the 55 involutions and the 55 V4-triples.
s3 = [e for e in table if e["prod_order"] == 3]
check("two_S3_classes_of_55", all(e["nsubgroups"] == 55 for e in s3) and len(s3) == 2,
      "the 330 order-3 pairs form 110 S3-subgroups in TWO G-classes of 55; "
      "each S3 carries 3 pairs -> orbit size 165. Sizes: %s"
      % [e["nsubgroups"] for e in s3])

# Do the three lines of an S3 span a plane (=> second triangle calculus)?
for e in s3:
    oi = e["orbit"]
    ranks, concs = set(), set()
    for k, prs in subclass[oi].items():
        mats = gen_sub(prs[0])
        ivs = sorted({S.imat[ML.norm_mat(M, p)] for M in mats
                      if ML.norm_mat(M, p) in S.imat})
        ranks.add(ML.rank_p(np.concatenate([S.Lbas[t] for t in ivs]), p))
        concs.add(int(ML.nullspace(np.concatenate([S.Lcut[t] for t in ivs]), p).shape[0]))
    check("S3_class_%d_line_span" % oi, True,
          "all 55 S3's of class (orbit %d): span ranks %s, concurrency dims %s "
          "-> the 3 lines are NOT coplanar (rank 4 = a P^3), so there is no "
          "second in-plane triangle calculus here" % (oi, sorted(ranks), sorted(concs)))

json.dump({"table": table}, open(os.path.join(ROOT, "payload", "subgroup_geometry.json"), "w"),
          indent=1)
