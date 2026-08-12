#!/usr/bin/env python3
"""Are the collision products (I4 generators whose lead already sits in S)
new, or already in the 17905-dimensional pivot-lead span?

If a sample of extras rewrite to 0, P4 may equal |S|. If they have nonzero
remainders, P4 > |S| and the I4 rewrite of minors is only a partial test.
"""
from __future__ import annotations

import json
import os
import sys
import time

import numpy as np

import paths
import domlib as L

RES = paths.RES


def main():
    p = int(sys.argv[1]) if len(sys.argv) > 1 else 331
    nsamp = int(sys.argv[2]) if len(sys.argv) > 2 else 40
    t0 = time.time()
    print("== extra I4 generators p=%d n=%d" % (p, nsamp), flush=True)
    I3, pivots = L.load_I3(p)
    mul3, _ = L.build_mul_table(3)
    used = {}
    pairs = []
    for i in range(paths.K):
        for j in range(paths.P3):
            lead = int(mul3[i, int(pivots[j])])
            pairs.append((i, j, lead))
            if lead not in used:
                used[lead] = (i, j)
    extras = [(i, j, lead) for (i, j, lead) in pairs if used[lead] != (i, j)]
    print("  |S|=%d extras=%d" % (len(used), len(extras)), flush=True)
    rng = np.random.default_rng(20260812 + p)
    idx = rng.choice(len(extras), size=min(nsamp, len(extras)), replace=False)
    n_zero = 0
    weights = []
    for t, a in enumerate(idx):
        i, j, lead = extras[int(a)]
        Q = np.zeros(paths.N4, dtype=np.int64)
        row = I3[j] % p
        nz = np.nonzero(row)[0]
        Q[mul3[i, nz]] = row[nz]
        R, _ = L.rewrite_I4(Q, I3, pivots, mul3, p)
        wt = int(np.count_nonzero(R))
        zero = wt == 0
        if zero:
            n_zero += 1
        weights.append({"i": int(i), "j": int(j), "lead": int(lead),
                        "wt_rem": wt, "zero": zero})
        print("  extra %d/%d i=%d j=%d wtR=%d zero=%s" % (
            t + 1, len(idx), i, j, wt, zero), flush=True)
    rec = {
        "p": int(p),
        "n_S": len(used),
        "n_extras": len(extras),
        "n_sampled": len(idx),
        "n_rewrite_zero": n_zero,
        "all_sampled_in_lead_span": n_zero == len(idx),
        "weights": weights,
        "seconds": time.time() - t0,
    }
    path = os.path.join(RES, "i4_extras_p%d.json" % p)
    with open(path, "w") as f:
        json.dump(L.jsonable(rec), f, indent=2)
    print("  extras rewrite zero %d/%d" % (n_zero, len(idx)), flush=True)


if __name__ == "__main__":
    main()
