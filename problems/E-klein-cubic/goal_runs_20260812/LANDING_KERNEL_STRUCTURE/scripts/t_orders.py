#!/usr/bin/env python3
"""Component-wise vanishing order of cell covariants T_c at the special
points, versus the landing order of F(T_c).  Decomposes each landing boost:
landing_ord = 3*ord(T) + (F-degeneracy on the leading jet values).

Usage: python3 t_orders.py [d] [p]
"""
from __future__ import annotations

import json
import os
import sys

import numpy as np

import common as CM
import slicelib as SL
import p2lib as P2
import d34lib as D34
import produce_ladder as PL
import instruments as INS


def poly_val_orders(vals_matrix, p, maxdeg):
    """vals_matrix: (ncomp, p) values of polys of degree <= maxdeg on t=0..p-1.
    Returns list of valuations (maxdeg+1 means identically zero)."""
    from locus_orders import valuation_series
    outs = []
    for row in vals_matrix:
        v, ok = valuation_series(row, p, maxdeg)
        assert ok
        outs.append(v if v is not None else -1)
    return outs


def main():
    d = int(sys.argv[1]) if len(sys.argv) > 1 else 35
    p = int(sys.argv[2]) if len(sys.argv) > 2 else 331
    fr = D34.stage2_frame(P2.adapted_frame(SL.build_frame(p, verbose=False), verbose=False), verbose=False)
    A, C, B = CM.load_cell(d, p)
    K = B.shape[0]
    rng = np.random.default_rng(20260812 + 999 * d + p)
    P11, P5on, P5off = PL.eig_points(fr, p)
    z, Z, Wplus, Wminus, kids6 = INS.build_v4_children(fr, p)

    def rand_on(rows):
        co = rng.integers(1, p, size=rows.shape[0])
        return (co @ rows) % p

    loci = [
        ("D12pt c_sigma", np.asarray(fr["w0"])),
        ("D10pt", np.asarray(fr["D10pt"])),
        ("V4-child w", np.asarray(kids6[0]["w"])),
        ("X^C6 w=1", np.asarray(fr["C6_eig"][1][0])),
        ("C11 pt", np.asarray(P11[0])),
        ("C5 pt", np.asarray(P5on[0]) if P5on else None),
        ("ellV pt", rand_on(fr["ellV"])),
        ("plus-plane pt", rand_on(fr["Wplus"])),
        ("minus-line pt", rand_on(fr["Wminus"])),
        ("eigenline pt", rand_on(fr["ELL1"])),
    ]
    ts = np.arange(p, dtype=np.int64)
    out = {"d": d, "p": p, "loci": {}}
    for name, z0 in loci:
        if z0 is None:
            continue
        v = rng.integers(0, p, size=5, dtype=np.int64)
        pts = (np.asarray(z0)[None, :] + ts[:, None] * v[None, :]) % p
        Mall = CM.eval_cell(fr, A, C, B, pts, d)  # (p, 5, K)
        tords, fords = [], []
        for _ in range(8):
            c = rng.integers(0, p, size=K, dtype=np.int64)
            Tv = np.einsum("tck,k->tc", Mall, c) % p  # (p, 5)
            comp_orders = poly_val_orders(Tv.T, p, d)
            tords.append(min(comp_orders))
            fvals = CM.klein_F_vec(Tv, p)
            from locus_orders import valuation_series
            fo, ok = valuation_series(fvals, p, 3 * d)
            assert ok
            fords.append(fo)
        rec = {"ord_T": int(min(tords)), "ord_T_all": sorted(set(tords)),
               "ord_F": int(min(fords)), "ord_F_all": sorted(set(fords)),
               "excess": int(min(fords)) - 3 * int(min(tords))}
        out["loci"][name] = rec
        print("d=%d %-15s ord(T)=%2d  ord(F(T))=%2d  excess=%d"
              % (d, name, rec["ord_T"], rec["ord_F"], rec["excess"]), flush=True)
    json.dump(out, open(os.path.join(CM.RES, "t_orders_d%d_p%d.json" % (d, p)), "w"), indent=1)


if __name__ == "__main__":
    main()
