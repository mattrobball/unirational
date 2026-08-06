#!/usr/bin/env python3
"""FIX-P1 Stage 2(c)/(d) -- the profile slice of the degree-25 covariant module.

STAGE-1 INPUT (proved in PAYLOAD_dictionary.txt): at d = 25 the ONLY admissible
profile is (m, r) = (3, 6), n = 19.  So EVERY G-equivariant dominant rational
map of degree 25 gives a nonzero T in M_25 = (Sym^25 W* (x) W)^G with

    (A)  ord_{P_sigma}(T) >= 3   at every one of the 55 plus-planes
         [m = 3 for the minus half, >= 4 for the plus half -- H0-1];
    (B)  ord_{ell_V}(T)   >= 6   at every one of the 55 V4-triple-lines
         [the cone order r = 6].

Both are implied by the forced profile, so the linear space they cut out
CONTAINS every degree-25 map tuple.  If that space is ZERO, degree 25 is closed.

By G-equivariance it suffices to impose (A) at ONE sigma and (B) at ONE V4.

Method: rank of the matrix of jet functionals evaluated on Reynolds averages of
monomial seeds, over F_p with p = 1 mod 33.  See slicelib.__doc__ for why a
full-rank modular computation is a characteristic-zero verdict, and why using
only a random SUBSET of the functionals is safe on the emptiness side.

Usage:  python3 produce_slice.py [p] [nseeds] [npair]
"""
import json
import os
import sys

import numpy as np

import slicelib as SL

HERE = os.path.dirname(os.path.abspath(__file__))
PAY = os.path.join(HERE, "payloads")
DEG = 25
DIM_M25 = 189                       # exact, from produce_molien.py


def rand_in_span(rows, k, p, rng):
    """k random points in the row span of `rows` (over F_p)."""
    co = rng.integers(0, p, size=(k, rows.shape[0]))
    return (co @ rows) % p


def indep_rows(M, p, want):
    """Greedy: indices of a maximal independent set of rows of M (mod p)."""
    A = np.array(M, dtype=np.int64) % p
    basis = []
    idx = []
    piv = []
    for i in range(A.shape[0]):
        v = A[i].copy()
        for b, c in zip(basis, piv):
            if v[c]:
                v = (v - v[c] * b) % p
        nz = np.nonzero(v)[0]
        if nz.size == 0:
            continue
        c = int(nz[0])
        v = (v * SL.inv_mod(v[c], p)) % p
        basis.append(v)
        piv.append(c)
        idx.append(i)
        if len(idx) == want:
            break
    return idx


def main():
    p = int(sys.argv[1]) if len(sys.argv) > 1 else 67
    nseeds = int(sys.argv[2]) if len(sys.argv) > 2 else 3000
    npair = int(sys.argv[3]) if len(sys.argv) > 3 else 30
    os.makedirs(PAY, exist_ok=True)
    rng = np.random.default_rng(20260806)

    fr = SL.build_frame(p)
    Wp, Wm, LINE = fr["Wplus"], fr["Wminus"], fr["LINE"]
    FULL = np.eye(5, dtype=np.int64)

    # ---------------------------------------------------------------- phase 1
    # A seed set whose Reynolds averages SPAN M_25: certified by the rank of a
    # pure-evaluation matrix reaching dim M_25 = 189.
    A, C = SL.seed_exponents(nseeds, deg=DEG)
    npt = 250
    Wev = rand_in_span(FULL, npt, p, rng)
    Yev = np.zeros_like(Wev)
    ev = SL.jet_rows(fr, A, C, Wev, Yev, 1, deg=DEG)      # (ns,npt,5,1)
    E = ev.reshape(nseeds, -1)
    rk = SL.rref_rank(E, p)
    print("[phase1] evaluation rank of the seed set = %d (dim M_25 = %d)"
          % (rk, DIM_M25))
    assert rk <= DIM_M25, "rank exceeds Molien dimension -- bug"
    assert rk == DIM_M25, ("seeds do not span M_25; increase nseeds", rk)
    keep = indep_rows(E, p, DIM_M25)
    A, C = A[keep], C[keep]
    ns = A.shape[0]
    print("[phase1] kept %d seeds; their Reynolds averages are a basis of M_25"
          % ns)

    # ---------------------------------------------------------------- phase 2
    # (A) plus-plane jets: w in W^+_sigma, y in W^-_sigma, orders t^0..t^{J-1}
    Jp = 4
    Wa = rand_in_span(Wp, npair, p, rng)
    Ya = rand_in_span(Wm, npair, p, rng)
    JA = SL.jet_rows(fr, A, C, Wa, Ya, Jp, deg=DEG)       # (ns,npair,5,Jp)

    # (B) triple-line jets: w in W^{V4}, y in W, orders t^0..t^{J-1}
    Jl = 6
    Wb = rand_in_span(LINE, npair, p, rng)
    Yb = rand_in_span(FULL, npair, p, rng)
    JB = SL.jet_rows(fr, A, C, Wb, Yb, Jl, deg=DEG)       # (ns,npair,5,Jl)

    def cols(Jarr, upto):
        return Jarr[:, :, :, :upto].reshape(ns, -1)

    results = {}

    def report(tag, blocks):
        M = np.concatenate(blocks, axis=1) if len(blocks) > 1 else blocks[0]
        r = SL.rref_rank(M, p)
        dim = DIM_M25 - r
        results[tag] = {"rank": int(r), "dim_slice": int(dim),
                        "n_functionals": int(M.shape[1])}
        print("  %-46s rank %4d   dim of slice = %4d" % (tag, r, dim))
        return dim, M

    print("[phase2] nested profile conditions (dim M_25 = %d):" % DIM_M25)
    d1, _ = report("ord_{P_sigma} >= 1  (55 plus-planes in base locus)",
                   [cols(JA, 1)])
    d2, _ = report("ord_{P_sigma} >= 2", [cols(JA, 2)])
    d3, _ = report("ord_{P_sigma} >= 3  (m = 3, minus half)", [cols(JA, 3)])
    d4, _ = report("ord_{P_sigma} >= 4", [cols(JA, 4)])
    dl, _ = report("ord_{ell_V} >= 6    (cone order r = 6) ALONE",
                   [cols(JB, 6)])
    dfull, Mfull = report("FULL PROFILE SLICE  (A) and (B) together",
                          [cols(JA, 3), cols(JB, 6)])

    # saturation control: does adding more sampled pairs change anything?
    Wa2 = rand_in_span(Wp, npair, p, rng)
    Ya2 = rand_in_span(Wm, npair, p, rng)
    Wb2 = rand_in_span(LINE, npair, p, rng)
    Yb2 = rand_in_span(FULL, npair, p, rng)
    JA2 = SL.jet_rows(fr, A, C, Wa2, Ya2, 3, deg=DEG)
    JB2 = SL.jet_rows(fr, A, C, Wb2, Yb2, 6, deg=DEG)
    Msat = np.concatenate([cols(JA, 3), cols(JB, 6),
                           JA2.reshape(ns, -1), JB2.reshape(ns, -1)], axis=1)
    rsat = SL.rref_rank(Msat, p)
    print("  %-46s rank %4d   dim of slice = %4d"
          % ("SATURATION control (2x the sampled pairs)", rsat,
             DIM_M25 - rsat))

    # ------------------------------------------------------------- controls
    ctrl = {}
    # NON-UNIT control: a condition that must NOT kill everything --
    # 'ord_{P_sigma} >= 1' alone must leave a positive-dimensional space
    # (the 55-plane arrangement kernel), else the pipeline is over-imposing.
    ctrl["arrangement_kernel_positive"] = bool(d1 > 0)
    # UNIT control: a deliberately impossible condition (order 26 vanishing
    # along the line) must give slice 0.
    Jbig = 12
    Wb3 = rand_in_span(LINE, npair, p, rng)
    Yb3 = rand_in_span(FULL, npair, p, rng)
    JB3 = SL.jet_rows(fr, A, C, Wb3, Yb3, Jbig, deg=DEG)
    rbig = SL.rref_rank(JB3.reshape(ns, -1), p)
    ctrl["deep_line_vanishing_kills"] = bool(DIM_M25 - rbig == 0)
    ctrl["deep_line_slice_dim"] = int(DIM_M25 - rbig)
    print("[controls] arrangement kernel > 0 : %s   (dim %d)"
          % (ctrl["arrangement_kernel_positive"], d1))
    print("[controls] ord_{ell_V} >= %d kills : %s   (dim %d)"
          % (Jbig, ctrl["deep_line_vanishing_kills"], ctrl["deep_line_slice_dim"]))

    out = {
        "prime": p, "dim_M25": DIM_M25, "n_seeds_used": int(ns),
        "n_pairs": npair,
        "nested_slice_dimensions": results,
        "saturation_rank": int(rsat),
        "saturation_slice_dim": int(DIM_M25 - rsat),
        "controls": ctrl,
        "verdict": ("PROFILE-SLICE-EMPTY" if dfull == 0
                    else "PROFILE-SLICE-DIM-%d" % dfull),
        "char0_bridge": ("rank mod p <= rank over K, so a full-rank modular "
                         "computation proves the char-0 slice is zero"),
        "frame_self_tests": fr["self_tests"],
    }
    fn = os.path.join(PAY, "SLICE_p%d.json" % p)
    with open(fn, "w") as fh:
        json.dump(out, fh, indent=1, sort_keys=True)
    print("[verdict]", out["verdict"], "-> wrote", fn)


if __name__ == "__main__":
    sys.exit(main())
