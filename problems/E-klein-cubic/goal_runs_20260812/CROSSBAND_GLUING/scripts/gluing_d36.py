#!/usr/bin/env python3
"""Cross-band gluing at d=36 on the sealed 63-cell.

Same L1 locus (ell_V / commuting plane triples).  At even d the six-flip
universal cut is off (LANDING_SWEEP); the working cell is the Layer-0
structure+(1,6) cell of dim 63 (Bcell_d36 from LANDING_INVARIANT_SIDE).

Leading multidegree: m=1 still (odd m forced); leading datum is (35,1).
Minus-line band is active at even d but contributes no new positive-dim
cross-band locus (L3/L4 are 0-dim).

Usage: python3 gluing_d36.py [p]
"""
from __future__ import annotations

import json
import os
import sys
import time

import numpy as np

import paths
import slicelib as SL
from inventory import build_v4s
from gluing_d35 import (
    common_normal_gluing,
    depth6_diagnostic,
    inv_mod,
    leading_vanish_table,
    rigidity_on_cell,
    sample_in_span,
    v4_data,
)

DEG = 36
RES = paths.RES
LAND_INV_RES = paths.LAND_INV_RES


def load_d36_cell(p):
    A = np.load(os.path.join(LAND_INV_RES, "A_d36_p%d.npy" % p))
    C = np.load(os.path.join(LAND_INV_RES, "C_d36_p%d.npy" % p))
    B = np.load(os.path.join(LAND_INV_RES, "Bcell_d36_p%d.npy" % p)) % p
    assert A.shape[0] == 706 and B.shape == (63, 706), (A.shape, B.shape)
    return A, C, B


def run(p, n_base=16, n_base_sat=28):
    t0 = time.time()
    print("== cross-band gluing d=36, p=%d" % p, flush=True)
    fr = SL.build_frame(p, verbose=False)
    A6, C6, AMB = load_d36_cell(p)  # AMB = Bcell (63, 706)
    print("63-cell shape", AMB.shape, "seeds", A6.shape[0])

    v4s = build_v4s(fr, p)
    rep = v4s[0]
    inv_triple = rep["involutions"]
    Aspan, chi, frames = v4_data(fr, p, inv_triple)

    rng = np.random.default_rng(20260812 + 36 + p)
    vtable = leading_vanish_table(
        fr, A6, C6, AMB, Aspan, chi, frames, inv_triple, p, rng, deg=DEG
    )
    print("vanish table:", vtable)

    Phi, meta = common_normal_gluing(
        fr, A6, C6, Aspan, chi, inv_triple, p, rng, n_base=n_base, deg=DEG
    )
    Phi_cell = (AMB @ Phi) % p
    r1 = SL.rref_rank(Phi_cell.T % p, p)
    print("rep rank pass1:", r1, "dim", 63 - r1)

    rng2 = np.random.default_rng(20260812 + 36 + p + 77)
    Phi2, meta2 = common_normal_gluing(
        fr, A6, C6, Aspan, chi, inv_triple, p, rng2, n_base=n_base_sat, deg=DEG
    )
    Phi_sat = np.concatenate([Phi_cell, (AMB @ Phi2) % p], axis=1) % p
    r2 = SL.rref_rank(Phi_sat.T % p, p)
    sat_ok = r2 == r1
    print("rep rank sat:", r2, "dim", 63 - r2, "sat_ok", sat_ok)

    print("full orbit 55...", flush=True)
    chunks = [Phi_sat]
    for vi, v in enumerate(v4s):
        As, ch, _ = v4_data(fr, p, v["involutions"])
        rngv = np.random.default_rng(20260812 + 36 + p + 1000 + vi)
        Pv, _ = common_normal_gluing(
            fr, A6, C6, As, ch, v["involutions"], p, rngv, n_base=10, deg=DEG
        )
        chunks.append((AMB @ Pv) % p)
        if (vi + 1) % 11 == 0:
            print("  %d/55" % (vi + 1), flush=True)
    Phi_orb = np.concatenate(chunks, axis=1) % p
    r_orb = SL.rref_rank(Phi_orb.T % p, p)
    dim_orb = 63 - r_orb
    print("orbit rank:", r_orb, "dim_after", dim_orb)

    print("depth-6 diagnostic...", flush=True)
    d6 = depth6_diagnostic(
        fr, A6, C6, AMB, Aspan, chi, frames, inv_triple, p, rng, deg=DEG
    )
    print("depth6 first nonzero full/Wm/cn:",
          d6["first_nonzero_full_normal"], d6["first_nonzero_Wm"],
          d6["first_nonzero_common_normal"])

    rig_bad, rig_checks = rigidity_on_cell(
        fr, A6, C6, AMB, Aspan, chi, inv_triple, p, rng, n_base=10, deg=DEG
    )
    print("rigidity: %d bad / %d" % (rig_bad, rig_checks))
    if rig_bad != 0:
        print("WARNING: rigidity nonzero at d=36 — recorded")

    auto_note = None
    if r_orb == 0:
        auto_note = (
            "Primary (d-1,1) gluing has rank 0 on the 63-cell: leading form "
            "vanishes on ell_V; both bands agree automatically. dim stays 63."
        )

    out = {
        "p": int(p),
        "d": DEG,
        "cell_in_dim": 63,
        "rep_v4_involutions": [int(x) for x in inv_triple],
        "leading_vanish_table": vtable,
        "rank_rep_pass1": int(r1),
        "dim_rep_pass1": int(63 - r1),
        "rank_rep_saturated": int(r2),
        "dim_rep_saturated": int(63 - r2),
        "saturation_ok": bool(sat_ok),
        "rank_full_orbit_55": int(r_orb),
        "dim_after_gluing": int(dim_orb),
        "depth6_diagnostic": d6,
        "n_func_rep_sat": int(Phi_sat.shape[1]),
        "n_func_orbit": int(Phi_orb.shape[1]),
        "meta_pass1": meta,
        "rigidity_slice_bad": int(rig_bad),
        "rigidity_slice_checks": int(rig_checks),
        "automatic_gluing_note": auto_note,
        "seconds": time.time() - t0,
        "headline": "Problem E remains OPEN; this packet excludes no degree.",
        "note": (
            "Even d: no six-flip cut; minus-line band on but no new pos-dim "
            "cross-band locus. Same L1 ell_V gluing as d=35."
        ),
    }
    np.save(os.path.join(RES, "gluing_d36_phi_orbit_p%d.npy" % p), Phi_orb % p)
    path = os.path.join(RES, "gluing_d36_p%d.json" % p)
    with open(path, "w") as f:
        json.dump(out, f, indent=1, sort_keys=True)
    print("wrote", path)
    print("RESULT d36: rank=%d dim_after=%d" % (r_orb, dim_orb))
    return out


def main():
    p = int(sys.argv[1]) if len(sys.argv) > 1 else 331
    run(p)


if __name__ == "__main__":
    main()
