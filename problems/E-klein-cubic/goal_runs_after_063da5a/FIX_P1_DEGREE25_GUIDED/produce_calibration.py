#!/usr/bin/env python3
"""FIX-P1 -- calibration ladder (a CONTROL, not a verdict).

Weakening each profile condition one order at a time must produce a MONOTONE,
strictly meaningful ladder of dimensions -- evidence that the pipeline measures
real kernels rather than collapsing everything to zero.  Run at d = 25.
"""
import json, os, sys
import numpy as np
import slicelib as SL

HERE = os.path.dirname(os.path.abspath(__file__)); PAY = os.path.join(HERE, "payloads")
DEG, DIM = 25, 189

def main():
    p = int(sys.argv[1]) if len(sys.argv) > 1 else 199
    fr = SL.build_frame(p); rng = np.random.default_rng(1234)
    A, C = SL.seed_exponents(3000, deg=DEG)
    Wev = rng.integers(0, p, size=(250, 5))
    ev = SL.jet_rows(fr, A, C, Wev, np.zeros_like(Wev), 1, deg=DEG)
    E = ev.reshape(A.shape[0], -1)
    assert SL.rref_rank(E, p) == DIM
    # greedy basis
    B = None; piv = []; keep = []
    for i in range(E.shape[0]):
        v = E[i] % p
        if B is not None: v = (v - v[piv] @ B) % p
        nz = np.nonzero(v)[0]
        if nz.size == 0: continue
        c = int(nz[0]); v = (v * SL.inv_mod(v[c], p)) % p
        if B is not None:
            col = B[:, c].copy(); k = np.nonzero(col)[0]
            if k.size: B[k] = (B[k] - np.outer(col[k], v)) % p
            B = np.concatenate([B, v[None, :]], axis=0)
        else: B = v[None, :]
        piv.append(c); keep.append(i)
        if len(keep) == DIM: break
    A, C = A[keep], C[keep]
    npair = 150
    Wp, Wm, LINE = fr["Wplus"], fr["Wminus"], fr["LINE"]
    Wa = (rng.integers(0, p, size=(npair, 3)) @ Wp) % p
    Ya = (rng.integers(0, p, size=(npair, 2)) @ Wm) % p
    Wb = (rng.integers(0, p, size=(npair, 2)) @ LINE) % p
    Yb = rng.integers(0, p, size=(npair, 5))
    JA = SL.jet_rows(fr, A, C, Wa, Ya, 5, deg=DEG)
    JB = SL.jet_rows(fr, A, C, Wb, Yb, 9, deg=DEG)
    out = {"prime": p, "degree": DEG, "dim_M": DIM, "plane_ladder": {}, "line_ladder": {}}
    print("plane order ladder (ord_{P_sigma} >= k):")
    for k in range(0, 6):
        d = DIM if k == 0 else DIM - SL.rref_rank(JA[:, :, :, :k].reshape(DIM, -1), p)
        out["plane_ladder"][k] = int(d); print("   k=%d  dim = %4d" % (k, d))
    print("line order ladder (ord_{ell_V} >= k):")
    for k in range(0, 10):
        d = DIM if k == 0 else DIM - SL.rref_rank(JB[:, :, :, :k].reshape(DIM, -1), p)
        out["line_ladder"][k] = int(d); print("   k=%d  dim = %4d" % (k, d))
    mono = all(out["plane_ladder"][k] >= out["plane_ladder"][k+1] for k in range(5)) and \
           all(out["line_ladder"][k] >= out["line_ladder"][k+1] for k in range(9))
    out["monotone"] = bool(mono)
    out["nonzero_intermediate_levels"] = bool(out["plane_ladder"][2] > 0 and out["line_ladder"][4] > 0)
    print("monotone:", mono, " nonzero intermediates:", out["nonzero_intermediate_levels"])
    with open(os.path.join(PAY, "CALIBRATION_p%d.json" % p), "w") as fh:
        json.dump(out, fh, indent=1, sort_keys=True)
    print("wrote payloads/CALIBRATION_p%d.json" % p)

if __name__ == "__main__":
    sys.exit(main())
