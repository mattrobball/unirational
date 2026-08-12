#!/usr/bin/env python3
"""Direction-resolved vanishing orders of the landing span along
stabilizer-adapted transverse directions at each special locus.

For each (locus z0/line, eigen-direction v): valuation in t of
F(T_c(z0 + t v)) minimized over random c and random span combinations.
Anisotropy (order > isotropic minimum in special directions) = refinement
conditions beyond plain order vanishing.

Usage: python3 directional_orders.py [d] [p]
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
from locus_orders import valuation_series


def span_val(fr, A, C, B, d, p, z0, v, rng, n_c=8, n_combo=4):
    K = B.shape[0]
    ts = np.arange(p, dtype=np.int64)
    pts = (np.asarray(z0, dtype=np.int64)[None, :] + ts[:, None] * np.asarray(v, dtype=np.int64)[None, :]) % p
    Mall = CM.eval_cell(fr, A, C, B, pts, d)
    cs = rng.integers(0, p, size=(n_c + 40, K), dtype=np.int64)
    vals = CM.landing_rows(np.ascontiguousarray(Mall), cs, p)
    orders = []
    for q in range(n_c):
        val, ok = valuation_series(vals[q], p, 3 * d)
        assert ok
        orders.append(val)
    for _ in range(n_combo):
        gam = rng.integers(0, p, size=40, dtype=np.int64)
        w = (gam @ vals[n_c:n_c + 40]) % p
        val, ok = valuation_series(w, p, 3 * d)
        assert ok
        orders.append(val)
    return int(min(orders))


def eig_dirs_of(fr, elts, p):
    """Common eigen-directions of a list of group elements (indices)."""
    # not used generically; specific loci handled in main
    raise NotImplementedError


def main():
    d = int(sys.argv[1]) if len(sys.argv) > 1 else 35
    p = int(sys.argv[2]) if len(sys.argv) > 2 else 331
    fr = D34.stage2_frame(P2.adapted_frame(SL.build_frame(p, verbose=False), verbose=False), verbose=False)
    A, C, B = CM.load_cell(d, p)
    rng = np.random.default_rng(20260812 + 4441 * d + p)
    P11, P5on, P5off = PL.eig_points(fr, p)
    zi, Zm, Wplus, Wminus, kids6 = INS.build_v4_children(fr, p)
    I5 = np.eye(5, dtype=np.int64)

    def rand_on(rows):
        co = rng.integers(1, p, size=rows.shape[0])
        return (co @ rows) % p

    # V4 of the frame: sigma_index and v4 list; ellV = its fixed line
    v4 = fr["v4"]
    RHO = fr["RHO"]
    sign_lines = []
    Zs, Ss = RHO[v4[0]] % p, RHO[v4[1]] % p
    for s1, s2, tag in ((1, -1, "B(+-)"), (-1, 1, "C(-+)"), (-1, -1, "D(--)")):
        L = INS.eig_split([Zs, Ss], p, [s1, s2])
        assert L.shape[0] == 1
        sign_lines.append((tag, L[0]))

    cases = []
    # ellV with V4-sign directions
    z0 = rand_on(fr["ellV"])
    for tag, v in sign_lines:
        cases.append(("ellV", "dir %s" % tag, z0, v))
    cases.append(("ellV", "dir random", z0, rng.integers(0, p, size=5, dtype=np.int64)))

    # plus-plane with W^- eigendirections of a 3-cycle in D12
    # find an order-3 element commuting with sigma
    sig = fr["sigma_index"]
    r3 = next(g for g in range(660) if fr["orders"][g] == 3 and
              np.array_equal((RHO[g] @ RHO[sig]) % p, (RHO[sig] @ RHO[g]) % p))
    R3 = RHO[r3] % p
    # eigenvectors of R3 inside Wminus
    z0p = rand_on(fr["Wplus"])
    w3 = None
    for a in range(2, p):
        c = pow(a, (p - 1) // 3, p)
        if c != 1:
            w3 = c
            break
    for lam, tag in ((1, "omega^0"), (w3, "omega"), (w3 * w3 % p, "omega^2")):
        M = np.concatenate([fr["Wminus"], ], axis=0)
        # solve R3 x = lam x within span(Wminus)
        X = fr["Wminus"]
        Mm = (X @ R3.T) % p  # rows: images
        # find combo c with c@X mapping to lam * c@X: (X R3^T - lam X)^T c = 0
        Kc = SL.nullspace(((Mm - (lam % p) * X) % p).T, p)
        if Kc.shape[0]:
            vdir = (Kc[0] @ X) % p
            cases.append(("plus-plane", "W^- eig %s" % tag, z0p, vdir))
    cases.append(("plus-plane", "dir random", z0p, rng.integers(0, p, size=5, dtype=np.int64)))

    # minus-line with W^+ directions: c_sigma direction vs std directions
    z0m = rand_on(fr["Wminus"])
    cases.append(("minus-line", "dir c_sigma", z0m, np.asarray(fr["w0"])))
    # std part of W^+: eigendirs of R3 in Wplus other than w0
    Xp = fr["Wplus"]
    Mp = (Xp @ R3.T) % p
    for lam, tag in ((1, "omega^0"), (w3, "omega"), (w3 * w3 % p, "omega^2")):
        Kc = SL.nullspace(((Mp - (lam % p) * Xp) % p).T, p)
        for k in range(Kc.shape[0]):
            vdir = (Kc[k] @ Xp) % p
            if np.array_equal(vdir % p, np.zeros(5, dtype=np.int64)):
                continue
            cases.append(("minus-line", "W^+ eig %s#%d" % (tag, k), z0m, vdir))
    cases.append(("minus-line", "dir random", z0m, rng.integers(0, p, size=5, dtype=np.int64)))

    # eigenline ELL1 (weights {1,4}): directions = other C6 weight lines 0,2,5
    z0e = rand_on(fr["ELL1"])
    for a in (0, 2, 5):
        if a in fr["C6_eig"]:
            cases.append(("eigenline1", "C6 wt %d" % a, z0e, np.asarray(fr["C6_eig"][a][0])))
    cases.append(("eigenline1", "dir random", z0e, rng.integers(0, p, size=5, dtype=np.int64)))

    # D10pt: directions = C5 eigenvectors (P5on 4 pts + nothing else transverse)
    for k in range(min(4, len(P5on))):
        cases.append(("D10pt", "C5 wt#%d" % k, np.asarray(fr["D10pt"]), np.asarray(P5on[k])))
    cases.append(("D10pt", "dir random", np.asarray(fr["D10pt"]), rng.integers(0, p, size=5, dtype=np.int64)))

    # D12pt c_sigma: directions: W^- eigendirs of R3, std(W^+) eigendirs
    for lam, tag in ((1, "m.omega^0"), (w3, "m.omega"), (w3 * w3 % p, "m.omega^2")):
        Kc = SL.nullspace((((fr["Wminus"] @ R3.T) % p - (lam % p) * fr["Wminus"]) % p).T, p)
        if Kc.shape[0]:
            cases.append(("D12pt", "W^- eig %s" % tag, np.asarray(fr["w0"]), (Kc[0] @ fr["Wminus"]) % p))
    for lam, tag in ((w3, "p.omega"), (w3 * w3 % p, "p.omega^2")):
        Kc = SL.nullspace((((Xp @ R3.T) % p - (lam % p) * Xp) % p).T, p)
        if Kc.shape[0]:
            cases.append(("D12pt", "W^+ eig %s" % tag, np.asarray(fr["w0"]), (Kc[0] @ Xp) % p))
    cases.append(("D12pt", "dir random", np.asarray(fr["w0"]), rng.integers(0, p, size=5, dtype=np.int64)))

    # C11 pt: other weight directions
    for k in range(1, 5):
        cases.append(("C11pt", "wt#%d" % k, np.asarray(P11[0]), np.asarray(P11[k])))

    # V4-child w: directions: LINE (2-dim, sample one), other sign lines
    kid = kids6[0]
    cases.append(("V4w", "dir y", np.asarray(kid["w"]), np.asarray(kid["y"])))
    cases.append(("V4w", "dir yperp", np.asarray(kid["w"]), np.asarray(kid["yperp"])))
    cases.append(("V4w", "dir random", np.asarray(kid["w"]), rng.integers(0, p, size=5, dtype=np.int64)))

    out = {"d": d, "p": p, "cases": []}
    for (loc, tag, z0c, vdir) in cases:
        val = span_val(fr, A, C, B, d, p, z0c, vdir, rng)
        out["cases"].append({"locus": loc, "dir": tag, "min_order": val})
        print("d=%d %-12s %-16s min_ord=%3d" % (d, loc, tag, val), flush=True)
    json.dump(out, open(os.path.join(CM.RES, "directional_orders_d%d_p%d.json" % (d, p)), "w"), indent=1)


if __name__ == "__main__":
    main()
