#!/usr/bin/env python3
"""FIX-P2 -- the sweep under the CORRECTED degree bound.

FINDING P2-C (this packet, see STATUS sec.4): Theorem H1-1(a)'s clause
"Lambda vanishes to order >= 2e at EACH of the three D12-points of ell_V"
is supported only at c_sigma.  The residual C3 = A4/K_1 permutes the three
D12-points of ell_V TOGETHER WITH the three involutions of K_1, hence it
carries the sigma_1-datum Lambda^{(1)} to the sigma_2-datum Lambda^{(2)} --
a DIFFERENT set of coefficients of the same leading graded piece.  The
transport therefore reproduces the vanishing of Lambda^{(1)} at c_1 and says
nothing about Lambda^{(1)} at c_2, c_3.  Measured on the degree-36 slice
(diag_d12.py): the vanishing of Lambda^{(1)} to order 2e = 10 at c_1 is
FORCED (rank 0 through order 9, rank 1 at order 10 -- H1-1(b) also forced),
while at c_2 and c_3 only order 1 is forced.

The safe consequence of the mirror-line factorisation Phi = D^e Psi is

        n = d - r  >=  2e ,      i.e.      d  >=  3r - 2m ,

(equivalently deg Psi = d - m - 3e >= 0), NOT d >= 7r - 6m.

This script re-runs the FIX-P1 sieve x slice sweep with the corrected bound,
so that every profile it admits at every degree gets its slice computed.
A slice of dimension 0 is a characteristic-zero emptiness verdict for that
(d, m, r); a nonzero dimension is an upper bound only.

Usage: python3 produce_sweep2.py [p] [dmin] [dmax]
"""
import json
import os
import sys
import time

import numpy as np

import slicelib as SL
import p2lib as P2
import produce_cascade as PC

HERE = os.path.dirname(os.path.abspath(__file__))
PAY = os.path.join(HERE, "payloads")
T0 = time.time()


def cone_min_r(m):
    return (3 * m + 1) // 2 if m % 2 else (3 * m) // 2


def cell_empty_all_line_degrees(m, r):
    """Cells PROVED empty at every line degree (Note II table, FIX-N2)."""
    if (m, r) in {(1, 2), (1, 3), (1, 4), (1, 5), (3, 5)}:
        return True
    if m % 2 == 1 and r == cone_min_r(m):
        return True                     # Lemma 2.4 chain from (1,2)
    return False


def profiles(d, bound="corrected"):
    out = []
    m = 1
    while m <= 2 * d:
        rmin = cone_min_r(m)
        for r in range(rmin, d + 1):
            e = r - m
            if e < 1:
                continue
            n = d - r
            if bound == "corrected":
                ok = n >= 2 * e
            else:
                ok = n >= 6 * e
            if not ok:
                continue
            if cell_empty_all_line_degrees(m, r):
                continue
            out.append({"m": m, "r": r, "e": e, "n": n})
        m += 2
    return out


def main():
    p = int(sys.argv[1]) if len(sys.argv) > 1 else 67
    dmin = int(sys.argv[2]) if len(sys.argv) > 2 else 25
    dmax = int(sys.argv[3]) if len(sys.argv) > 3 else 38
    os.makedirs(PAY, exist_ok=True)
    dims = PC.load_dims()
    fr = P2.adapted_frame(SL.build_frame(p))
    rng = np.random.default_rng(20260806)
    fn = os.path.join(PAY, "SWEEP2_p%d_%d_%d.json" % (p, dmin, dmax))
    rows = []
    for d in range(dmin, dmax + 1):
        profs = profiles(d)
        dimM = dims[d]
        A, C, got = PC.basis_seeds(fr, d, dimM, p, rng)
        if A is None:
            print("d=%2d SEED SHORTFALL %d/%d -- NOT DECIDED"
                  % (d, got, dimM), flush=True)
            rows.append({"d": d, "dim_M": dimM, "verdict": "NOT-DECIDED"})
            continue
        npair = max(40, dimM // 8 + 20)
        alive = []
        rec = {"d": d, "dim_M": dimM, "n_profiles": len(profs),
               "profiles": []}
        for x in profs:
            m, r = x["m"], x["r"]
            c1, _ = PC.plane_blocks(fr, A, C, d, m, npair, p, rng)
            lb = PC.line_block(fr, A, C, d, r, npair, p, rng)
            M = np.concatenate([c1, lb], axis=1)
            sd = int(dimM - P2.rref_rank_fast(M, p))
            rec["profiles"].append(dict(x, slice_dim=sd,
                                        under_H1_bound=bool(x["n"] >= 6 *
                                                            x["e"])))
            if sd:
                alive.append((m, r, sd))
            print("d=%2d dimM=%4d  (m,r)=(%2d,%2d) n=%2d  slice dim = %d%s"
                  % (d, dimM, m, r, x["n"], sd,
                     "   [also admissible under the H1 bound]"
                     if x["n"] >= 6 * x["e"] else ""), flush=True)
            rec["verdict"] = ("ALL-EMPTY" if not alive else
                              "ALIVE:" + ";".join("(%d,%d):%d" % a
                                                  for a in alive))
            rows.append(rec) if rec not in rows else None
            with open(fn, "w") as fh:
                json.dump({"prime": p, "range": [dmin, dmax], "rows": rows,
                           "bound": "corrected: n >= 2e (d >= 3r-2m)",
                           "semantics": ("slice_dim 0 is a characteristic-zero"
                                         " emptiness verdict for that "
                                         "(d,m,r); nonzero is an upper bound"
                                         " only.")}, fh, indent=1,
                          sort_keys=True)
        print("d=%2d : %s   [%.0f s]" % (d, rec["verdict"], time.time() - T0),
              flush=True)
    print("wrote", fn)


if __name__ == "__main__":
    sys.exit(main())
