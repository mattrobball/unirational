#!/usr/bin/env python3
"""Vanishing orders of the landing system along the sealed special loci.

For each degree d in {35,36,37,38}, prime p, and each locus L of the Layer-0
configuration, measure the t-valuation at t=0 of

    g_c(t) = F(T_c(z0 + t v)),   z0 random on L, v random in W,

for individual random c and for random combinations of many landing cubics.
The minimum over samples is the generic vanishing order of the landing SPAN
along the locus (mod p; Tier 2).  Control: generic z0 gives order 0.

Usage: python3 locus_orders.py [d ...] [p ...]
"""
from __future__ import annotations

import json
import os
import sys
import time

import numpy as np

import common as CM
import slicelib as SL
import p2lib as P2
import d34lib as D34
import produce_ladder as PL
import instruments as INS


def valuation_series(vals, p, maxdeg):
    """t-valuation at 0 of the poly of degree <= maxdeg with given values.

    vals[t] for t = 0..p-1; interpolate on 0..maxdeg then verify; return
    (valuation, ok).  Valuation p means identically zero."""
    ts = list(range(maxdeg + 1))
    poly = _interp(ts, [int(v) for v in vals[: maxdeg + 1]], p)
    for t in range(maxdeg + 1, p):
        if _peval(poly, t, p) != int(vals[t]):
            return None, False
    if not poly:
        return p, True
    val = 0
    while val < len(poly) and poly[val] == 0:
        val += 1
    return val, True


def _interp(ts, vs, p):
    n = len(ts)
    coef = list(vs)
    for j in range(1, n):
        for i in range(n - 1, j - 1, -1):
            num = (coef[i] - coef[i - 1]) % p
            den = (ts[i] - ts[i - j]) % p
            coef[i] = num * pow(den, p - 2, p) % p
    poly = [0] * n
    poly[0] = coef[n - 1]
    deg = 0
    for k in range(n - 2, -1, -1):
        new = [0] * (deg + 2)
        for i in range(deg + 1):
            new[i + 1] = (new[i + 1] + poly[i]) % p
            new[i] = (new[i] - poly[i] * ts[k]) % p
        new[0] = (new[0] + coef[k]) % p
        poly = new
        deg += 1
    while poly and poly[-1] == 0:
        poly.pop()
    return poly


def _peval(a, t, p):
    r = 0
    for c in reversed(a):
        r = (r * t + c) % p
    return r


def orders_at(fr, A, C, B, d, p, z0, rng, n_c=10, n_combo=6, combo_size=40):
    """Generic landing order at z0: min valuation over samples."""
    K = B.shape[0]
    ts = np.arange(p, dtype=np.int64)
    v = rng.integers(0, p, size=5, dtype=np.int64)
    pts = (np.asarray(z0, dtype=np.int64)[None, :] + ts[:, None] * v[None, :]) % p
    Mall = CM.eval_cell(fr, A, C, B, pts, d)  # (p, 5, K)
    orders = []
    ok_all = True
    cs = rng.integers(0, p, size=(n_c, K), dtype=np.int64)
    vals = CM.landing_rows(np.ascontiguousarray(Mall), cs, p)  # (n_c, p)
    for q in range(n_c):
        val, ok = valuation_series(vals[q], p, 3 * d)
        ok_all &= ok
        orders.append(val)
    # random elements of the linear span: combinations of many landing cubics
    combo_orders = []
    cs2 = rng.integers(0, p, size=(combo_size, K), dtype=np.int64)
    vals2 = CM.landing_rows(np.ascontiguousarray(Mall), cs2, p)
    for _ in range(n_combo):
        gam = rng.integers(0, p, size=combo_size, dtype=np.int64)
        w = (gam @ vals2) % p
        val, ok = valuation_series(w, p, 3 * d)
        ok_all &= ok
        combo_orders.append(val)
    return {
        "orders_single_c": orders,
        "orders_span_combo": combo_orders,
        "min_order": int(min(orders + combo_orders)),
        "interp_ok": bool(ok_all),
    }


def rand_on(rows, p, rng):
    co = rng.integers(1, p, size=rows.shape[0])
    return (co @ rows) % p


def run_one(d, p):
    fr = D34.stage2_frame(P2.adapted_frame(SL.build_frame(p, verbose=False), verbose=False), verbose=False)
    A, C, B = CM.load_cell(d, p)
    rng = np.random.default_rng(20260812 + 271 * d + p)
    P11, P5on, P5off = PL.eig_points(fr, p)
    z, Z, Wplus, Wminus, kids6 = INS.build_v4_children(fr, p)

    loci = []
    loci.append(("generic (control)", rng.integers(0, p, size=5, dtype=np.int64)))
    loci.append(("ellV (V4-line, ord>=6 cut)", rand_on(fr["ellV"] if "ellV" in fr else fr["LINE"], p, rng)))
    loci.append(("plus-plane P_sigma", rand_on(fr["Wplus"], p, rng)))
    loci.append(("minus-line L_sigma", rand_on(fr["Wminus"], p, rng)))
    loci.append(("C3-eigenline ELL1", rand_on(fr["ELL1"], p, rng)))
    loci.append(("C3-eigenline ELL2", rand_on(fr["ELL2"], p, rng)))
    loci.append(("D10-point", np.asarray(fr["D10pt"])))
    w0 = fr.get("w0")
    if w0 is None:
        w0 = fr.get("c_sigma")
    if w0 is not None:
        loci.append(("D12-point c_sigma", np.asarray(w0)))
    loci.append(("X^{C6} point w=1", np.asarray(fr["C6_eig"][1][0])))
    loci.append(("X^{C6} point w=5", np.asarray(fr["C6_eig"][5][0])))
    loci.append(("C11 eigenpoint", np.asarray(P11[0])))
    if P5on:
        loci.append(("exact-C5 point (on X)", np.asarray(P5on[0])))
    if P5off:
        loci.append(("C5 fixed point off X (= D10 pt?)", np.asarray(P5off[0])))
    loci.append(("V4-child w (flip point)", np.asarray(kids6[0]["w"])))
    loci.append(("second random pt on ellV", rand_on(fr["ellV"] if "ellV" in fr else fr["LINE"], p, rng)))

    out = {"d": d, "p": p, "K": int(B.shape[0]), "loci": {}}
    for name, z0 in loci:
        t0 = time.time()
        rec = orders_at(fr, A, C, B, d, p, z0, rng)
        rec["seconds"] = time.time() - t0
        out["loci"][name] = rec
        print("d=%d p=%d %-36s min_ord=%3s  singles=%s combos=%s %s"
              % (d, p, name, rec["min_order"],
                 sorted(set(rec["orders_single_c"])),
                 sorted(set(rec["orders_span_combo"])),
                 "" if rec["interp_ok"] else "INTERP-FAIL"), flush=True)
    path = os.path.join(CM.RES, "locus_orders_d%d_p%d.json" % (d, p))
    json.dump(out, open(path, "w"), indent=1)
    print("[write]", path, flush=True)


def main():
    args = [int(a) for a in sys.argv[1:]]
    ds = [a for a in args if a < 100] or [35]
    ps = [a for a in args if a >= 100] or [331]
    for d in ds:
        for p in ps:
            run_one(d, p)


if __name__ == "__main__":
    main()
