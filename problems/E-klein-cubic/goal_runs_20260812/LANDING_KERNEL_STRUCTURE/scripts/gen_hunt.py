#!/usr/bin/env python3
"""Empirical generator hunt for R = (Sym W*)^G, G = PSL(2,11), mod p.

Degree by degree m = 3..MCAP: compare the point-evaluation rank of products
of already-found generators (degree m) with the exact Molien I(m); when the
products fall short, adjoin new Reynolds averages of random degree-m
monomials until the rank fills I(m).  All ranks over F_p at >= I(m)+margin
random points (rank mod p <= true dim; filling to I(m) certifies spanning
mod p).

Then: certify that products of the found generators span the full invariant
space in degree 105 (and 108, 111, 114) by point-evaluation rank = I(deg).

Output: results/generators_p{p}.json with generator (degree, exponent,
component) descriptors and the product-span certification.
"""
from __future__ import annotations

import json
import os
import sys
import time

import numpy as np

import common as CM
import slicelib as SL

P3_TARGETS = {105: 8555, 108: 9545, 111: 10614, 114: 11776}


def molien_I():
    path = os.path.join(CM.RES, "molien_ext.json")
    return json.load(open(path))["I"]


def reynolds_values(fr, expo, pts_g):
    """Values of R(x^expo) at points; pts_g: (npts, 660, 5) precomputed orbits."""
    p = fr["p"]
    # mono at each (pt, g): prod_j pts_g[..., j]^expo_j
    val = np.ones(pts_g.shape[:2], dtype=np.int64)
    for j in range(5):
        e = int(expo[j])
        if e == 0:
            continue
        base = pts_g[:, :, j] % p
        val = (val * pow_mod_arr(base, e, p)) % p
    return val.sum(axis=1) % p


def pow_mod_arr(base, e, p):
    r = np.ones_like(base)
    b = base % p
    while e:
        if e & 1:
            r = (r * b) % p
        b = (b * b) % p
        e >>= 1
    return r


def rand_expo(m, rng):
    cuts = sorted(int(rng.integers(0, m + 1)) for _ in range(4))
    return (cuts[0], cuts[1] - cuts[0], cuts[2] - cuts[1], cuts[3] - cuts[2], m - cuts[3])


def main():
    p = int(sys.argv[1]) if len(sys.argv) > 1 else 331
    MCAP = int(sys.argv[2]) if len(sys.argv) > 2 else 40
    NPTS = int(sys.argv[3]) if len(sys.argv) > 3 else 900
    I = molien_I()
    fr = CM.frame(p)
    RHO = fr["RHO"]
    rng = np.random.default_rng(20260812 + p)
    pts = rng.integers(0, p, size=(NPTS, 5), dtype=np.int64)
    # orbit points: (npts, 660, 5)
    pts_g = np.einsum("gij,qj->qgi", RHO, pts) % p

    gens = []  # list of dicts {deg, expo, values (npts,)}
    t0 = time.time()
    for m in range(2, MCAP + 1):
        target = I[m]
        if target == 0:
            continue
        # products of existing generators with total degree m
        prod_vals = []
        prod_tags = []

        def extend(idx, deg_left, cur_vals, tag):
            if deg_left == 0:
                prod_vals.append(cur_vals % p)
                prod_tags.append(tuple(tag))
                return
            if idx >= len(gens):
                return
            g = gens[idx]
            if g["deg"] > deg_left:
                extend(idx + 1, deg_left, cur_vals, tag)
                return
            # skip
            extend(idx + 1, deg_left, cur_vals, tag)
            # use k copies
            v = cur_vals
            k = 0
            dl = deg_left
            while dl >= g["deg"]:
                v = (v * g["values"]) % p
                k += 1
                dl -= g["deg"]
                extend(idx + 1, dl, v, tag + [(idx, k)])

        extend(0, m, np.ones(NPTS, dtype=np.int64), [])
        ech = CM.FastEchelon(NPTS, p)
        for v in prod_vals:
            ech.try_add(v)
        r_prod = ech.rank
        newg = 0
        tries = 0
        while ech.rank < target and tries < 200 + 40 * target:
            expo = rand_expo(m, rng)
            vals = reynolds_values(fr, expo, pts_g)
            tries += 1
            if ech.try_add(vals):
                gens.append({"deg": m, "expo": expo, "values": vals})
                newg += 1
        status = "OK" if ech.rank == target else "SHORT %d/%d" % (ech.rank, target)
        print("m=%2d I=%4d products=%4d rank_prod=%4d new_gens=%d  %s [%.0fs]"
              % (m, target, len(prod_vals), r_prod, newg, status, time.time() - t0),
              flush=True)
        if ech.rank < target:
            print("  !! could not fill degree %d (mod-p span shortfall)" % m)

    gd = sorted(g["deg"] for g in gens)
    print("generator degrees:", gd, flush=True)

    out = {"p": p, "NPTS": NPTS, "MCAP": MCAP,
           "generators": [{"deg": g["deg"], "expo": list(g["expo"])} for g in gens],
           "checks": {}}
    json.dump(out, open(os.path.join(CM.RES, "generators_p%d.json" % p), "w"), indent=1)
    print("[write] generators_p%d.json" % p)


if __name__ == "__main__":
    main()
