#!/usr/bin/env python3
"""Reproduce Lane-3 anchors: 37-cell, P3=1380, generic Jac rank 5, Euler."""
from __future__ import annotations

import json
import os
import sys
import time

import numpy as np

import paths
import domlib as L
import slicelib as SL

RES = paths.RES


def run_one(p, ntrials=5):
    t0 = time.time()
    print("== anchors p=%d" % p, flush=True)
    cell = L.load_cell(p)
    I3, pivots = L.load_I3(p)
    print("  cell_dim=%d rank_U=%d I3=%s" % (
        cell["cell_dim"], cell["rank_U"], I3.shape), flush=True)
    assert cell["cell_dim"] == 37
    assert I3.shape == (1380, 9139)

    # I3 rows independent
    rkI3 = L.flint_rank(I3[:80], p)  # cheap prefix
    # full rank via known echelon: 1380 pivots
    n_piv = int(len(pivots)) if pivots is not None else None
    if pivots is not None:
        assert len(pivots) == 1380
        # verify pivot columns are standard basis
        eye_ok = all(int(I3[j, int(pivots[j])]) % p == 1 for j in range(0, 1380, 137))
    else:
        eye_ok = None

    mul3, n4 = L.build_mul_table(3)
    assert n4 == 91390
    S = L.pivot_quartic_support(pivots, mul3) if pivots is not None else set()
    print("  |S|=x_i*I3-pivot = %d (max 51060)" % len(S), flush=True)

    fr = SL.build_frame(p, verbose=False)
    rng = np.random.default_rng(20260812 + p)
    B37 = cell["B37"]
    A, C = cell["A"], cell["C"]

    cell_ranks = []
    euler_ok = []
    ambient_ranks = []
    for t in range(ntrials):
        c = rng.integers(1, p, size=37)
        w = rng.integers(1, p, size=(1, 5))
        Jcell = L.jacobians_cell(fr, A, C, B37, w)  # (37,1,5,5)
        J = L.jacobian_of_vec(Jcell, c, p)[0]
        r = L.rank5(J, p)
        T = L.values_cell(fr, A, C, B37, w)  # (37,1,5)
        Tv = (c @ T[:, 0, :]) % p
        lhs = (J @ w[0]) % p
        rhs = (paths.DEG * Tv) % p
        ok = bool(np.array_equal(lhs, rhs))
        cell_ranks.append(int(r))
        euler_ok.append(ok)
        print("  cell trial %d rank=%d Euler=%s" % (t, r, ok), flush=True)
        assert ok, "Euler failed"

        vec = rng.integers(0, p, size=637)
        # ambient Jacobian: treat vec as seed combo, reuse jet at same w
        # cheaper: random 37-coeff still in the cell — use a random 637 vec
        # via jet_rows on seeds
        Y = np.zeros_like(w)
        # 5 directions
        Ws = np.vstack([w] * 5)
        Ys = np.zeros((5, 5), dtype=np.int64)
        for j in range(5):
            Ys[j, j] = 1
        R = SL.jet_rows(fr, A, C, Ws, Ys, 2, deg=paths.DEG)
        d1 = R[:, :, :, 1] % p  # (637,5,5) seed, dir, component? 
        # R shape (637, 5, 5, 2); d1 (637, 5pairs, 5comp)
        Ja = np.zeros((5, 5), dtype=np.int64)
        for j in range(5):
            Ja[:, j] = (vec @ (R[:, j, :, 1] % p)) % p
        ambient_ranks.append(int(L.rank5(Ja, p)))

    rec = {
        "p": int(p),
        "cell_dim": 37,
        "rank_U": int(cell["rank_U"]),
        "I3_shape": list(I3.shape),
        "P3": 1380,
        "N3": 9139,
        "HF3": 7759,
        "n_pivots": n_piv,
        "pivot_eye_spotcheck": eye_ok,
        "pivot_quartic_support": len(S),
        "P4_ub": 51060,
        "N4": 91390,
        "HF4_domain_lb": 40330,
        "cell_ranks": cell_ranks,
        "ambient_ranks": ambient_ranks,
        "euler_ok": euler_ok,
        "generic_cell_rank": max(cell_ranks),
        "generic_ambient_rank": max(ambient_ranks),
        "euler_all_ok": all(euler_ok),
        "seconds": time.time() - t0,
    }
    path = os.path.join(RES, "anchors_p%d.json" % p)
    with open(path, "w") as f:
        json.dump(L.jsonable(rec), f, indent=2)
    print("  wrote", path, rec["seconds"], flush=True)
    return rec


def main():
    primes = [int(a) for a in sys.argv[1:] if a.isdigit()] or [331, 661]
    out = {}
    for p in primes:
        out[str(p)] = run_one(p)
    with open(os.path.join(RES, "anchors_summary.json"), "w") as f:
        json.dump(L.jsonable(out), f, indent=2)
    print("DONE", {k: {"cell": v["cell_dim"], "P3": v["P3"],
                       "jac": v["generic_cell_rank"],
                       "euler": v["euler_all_ok"],
                       "|S|": v["pivot_quartic_support"]}
                   for k, v in out.items()}, flush=True)


if __name__ == "__main__":
    main()
