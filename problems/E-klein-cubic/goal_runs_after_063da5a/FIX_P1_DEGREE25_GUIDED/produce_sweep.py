#!/usr/bin/env python3
"""FIX-P1 Stage 2 -- the SIEVE x SLICE sweep.

For every degree d in a range, and every profile (m, r) the Stage-1 sieve leaves
admissible at that d, compute

    dim { T in M_d :  ord_{P_sigma}(T) >= m  and  ord_{ell_V}(T) >= r } .

Every G-equivariant dominant rational map of degree d with profile (m, r) gives
a NONZERO such T (H0-1 gives ord_{P_sigma}T = m; the multi-order gives
ord_{ell_V}T = r; the gcd-1 tuple is G-equivariant because PSL(2,11) is simple
and so has no nontrivial linear characters).  Hence

        slice dimension 0  for every admissible profile  ==>  NO MAP IN DEGREE d.

A zero slice computed mod p is a characteristic-zero verdict (slicelib.__doc__),
and sampling only a subset of the defining functionals can only ENLARGE the
computed slice, so zero is decisive either way.

Usage:  python3 produce_sweep.py [p] [dmin] [dmax]
"""
import json
import os
import sys

import numpy as np

import slicelib as SL
import produce_sieve as SV

HERE = os.path.dirname(os.path.abspath(__file__))
PAY = os.path.join(HERE, "payloads")


def load_dims():
    with open(os.path.join(PAY, "MOLIEN.json")) as fh:
        j = json.load(fh)
    return {int(k): v for k, v in j["dim_covariant_module_M_d"].items()}


class Basis:
    """Incremental row basis over F_p, remembering which rows were kept."""

    def __init__(self, ncols, p):
        self.p = p
        self.ncols = ncols
        self.rows = np.zeros((0, ncols), dtype=np.int64)
        self.piv = []
        self.keep = []

    def add_block(self, M, tags):
        p, ncols = self.p, self.ncols
        B = np.array(M, dtype=np.int64) % p
        if self.rows.shape[0]:
            B = (B - B[:, self.piv] @ self.rows) % p
        for i in range(B.shape[0]):
            v = B[i]
            nz = np.nonzero(v)[0]
            if nz.size == 0:
                continue
            c = int(nz[0])
            v = (v * SL.inv_mod(v[c], p)) % p
            if self.rows.shape[0]:
                col = self.rows[:, c].copy()
                k = np.nonzero(col)[0]
                if k.size:
                    self.rows[k] = (self.rows[k] - np.outer(col[k], v)) % p
            self.rows = np.concatenate([self.rows, v[None, :]], axis=0)
            self.piv.append(c)
            self.keep.append(tags[i])
            if i + 1 < B.shape[0]:
                col = B[i + 1:, c].copy()
                k = np.nonzero(col)[0]
                if k.size:
                    B[i + 1 + k] = (B[i + 1 + k] - np.outer(col[k], v)) % p
        return len(self.keep)


def basis_seeds(fr, deg, dim, p, rng, block=1500, maxseeds=60000):
    """Find `dim` monomial seeds whose Reynolds averages are a basis of M_deg."""
    npt = dim // 5 + 40
    W = SL.rand_in_span if False else None
    co = rng.integers(0, p, size=(npt, 5))
    Wev = co % p
    Yev = np.zeros_like(Wev)
    bas = Basis(npt * 5, p)
    kept_A, kept_C = [], []
    used = 0
    while len(bas.keep) < dim and used < maxseeds:
        A, C = SL.seed_exponents(used + block, deg=deg)
        A, C = A[used:], C[used:]
        used += block
        ev = SL.jet_rows(fr, A, C, Wev, Yev, 1, deg=deg)
        bas.add_block(ev.reshape(A.shape[0], -1),
                      list(zip(A.tolist(), C.tolist())))
    if len(bas.keep) < dim:
        return None, None, len(bas.keep)
    kept_A = np.array([k[0] for k in bas.keep[:dim]], dtype=np.int64)
    kept_C = np.array([k[1] for k in bas.keep[:dim]], dtype=np.int64)
    return kept_A, kept_C, dim


def slice_dim(fr, A, C, deg, m, r, npair, p, rng):
    Wp, Wm, LINE = fr["Wplus"], fr["Wminus"], fr["LINE"]
    FULL = np.eye(5, dtype=np.int64)
    ns = A.shape[0]
    Wa = SL.rand_in_span if False else None
    co = rng.integers(0, p, size=(npair, 3))
    Wa = (co @ Wp) % p
    co = rng.integers(0, p, size=(npair, 2))
    Ya = (co @ Wm) % p
    co = rng.integers(0, p, size=(npair, 2))
    Wb = (co @ LINE) % p
    co = rng.integers(0, p, size=(npair, 5))
    Yb = (co @ FULL) % p
    JA = SL.jet_rows(fr, A, C, Wa, Ya, m, deg=deg)
    JB = SL.jet_rows(fr, A, C, Wb, Yb, r, deg=deg)
    M = np.concatenate([JA.reshape(ns, -1), JB.reshape(ns, -1)], axis=1)
    return ns - SL.rref_rank(M, p)


def main():
    p = int(sys.argv[1]) if len(sys.argv) > 1 else 67
    dmin = int(sys.argv[2]) if len(sys.argv) > 2 else 24
    dmax = int(sys.argv[3]) if len(sys.argv) > 3 else 32
    os.makedirs(PAY, exist_ok=True)
    dims = load_dims()
    fr = SL.build_frame(p)
    rng = np.random.default_rng(20260806)

    rows = []
    for d in range(dmin, dmax + 1):
        profs = [x for x in SV.profiles_for(d) if x["admissible"]]
        if not profs:
            print("d=%2d  no admissible profile" % d)
            rows.append({"d": d, "profiles": [], "verdict": "NO-PROFILE"})
            continue
        dim = dims[d]
        A, C, got = basis_seeds(fr, d, dim, p, rng)
        if A is None:
            print("d=%2d  SEED SHORTFALL (%d of %d) -- NOT DECIDED" %
                  (d, got, dim))
            rows.append({"d": d, "dim_M": dim, "verdict": "NOT-DECIDED",
                         "reason": "seed shortfall %d/%d" % (got, dim)})
            continue
        npair = max(40, dim // 8 + 20)
        rec = {"d": d, "dim_M": dim, "profiles": []}
        alive = []
        for x in profs:
            m, r = x["m"], x["r"]
            sd = slice_dim(fr, A, C, d, m, r, npair, p, rng)
            rec["profiles"].append({"m": m, "r": r, "n": x["n"],
                                    "slice_dim": int(sd)})
            if sd > 0:
                alive.append((m, r, sd))
            print("d=%2d  dim M_d=%4d  profile (m,r)=(%d,%d) n=%2d  "
                  "slice dim = %d" % (d, dim, m, r, x["n"], sd), flush=True)
        rec["verdict"] = ("ALL-PROFILE-SLICES-EMPTY" if not alive
                          else "ALIVE:" + ";".join("(%d,%d):%d" % a
                                                   for a in alive))
        rows.append(rec)

    out = {"prime": p, "range": [dmin, dmax], "rows": rows,
           "semantics": ("slice_dim 0 for every admissible profile of a degree "
                         "d proves, in characteristic zero, that no "
                         "G-equivariant dominant rational map of degree d "
                         "exists; slice_dim > 0 is only an upper bound on the "
                         "true slice and decides nothing.")}
    fn = os.path.join(PAY, "SWEEP_p%d_%d_%d.json" % (p, dmin, dmax))
    with open(fn, "w") as fh:
        json.dump(out, fh, indent=1, sort_keys=True)
    print("wrote", fn)


if __name__ == "__main__":
    sys.exit(main())
