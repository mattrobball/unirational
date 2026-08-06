#!/usr/bin/env python3
"""FIX-P2, Engine 2 -- the DIMENSION CASCADE on the covariant module.

For each degree d and each profile (m,r) the FIX-P1 sieve leaves admissible,
impose the sealed constraints as LINEAR conditions on M_d = (Sym^d W* ox W)^G
and report the dimension after each one:

  step 0   dim M_d                                       (exact, Molien)
  step 1   + ord_{P_sigma}(T)   >= m                     [H0-1, P1's cond. A]
  step 2   + ord_{P_sigma}(T^+) >= m+1                   [H0-1 refinement, NEW]
  step 3   + ord_{ell_V}(T)     >= r                     [multi-order, cond. B]
  step 4   + H1-1(a) : Lambda vanishes to order >= 2e at c_sigma
  step 5   + H1-1(b) : lambda_{2e}   in L0 = V[sgn^e]
  step 6   + H1-1(c) : lambda_{2e+1} in L1 = Im(ev_{v0})

Every step is a linear condition satisfied by the tuple of ANY G-equivariant
dominant rational map of degree d with that profile, and such a tuple is
NONZERO.  So

        dimension 0 at any step  ==>  no such map in degree d,

and (slicelib.__doc__) a modular zero is a characteristic-zero verdict, while
a nonzero modular dimension is only an UPPER BOUND on the char-0 dimension.
Sampling a subset of the functionals can only ENLARGE the computed space, so
zero is decisive either way.

Steps 4-6 are implemented for m = 1 (V = End(W^-)); for m >= 3 the cascade is
reported through step 3, which is where those profiles die.

Usage:  python3 produce_cascade.py [p] [dmin] [dmax] [--full]
"""
import json
import os
import sys
import time

import numpy as np

import slicelib as SL
import p2lib as P2
import produce_sieve as SV

HERE = os.path.dirname(os.path.abspath(__file__))
PAY = os.path.join(HERE, "payloads")
T0 = time.time()


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
        p = self.p
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


def basis_seeds(fr, deg, dim, p, rng, block=2000, maxseeds=90000):
    """`dim` monomial seeds whose Reynolds averages form a basis of M_deg."""
    npt = dim // 5 + 40
    Wev = rng.integers(0, p, size=(npt, 5)) % p
    Yev = np.zeros_like(Wev)
    bas = Basis(npt * 5, p)
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
    kA = np.array([k[0] for k in bas.keep[:dim]], dtype=np.int64)
    kC = np.array([k[1] for k in bas.keep[:dim]], dtype=np.int64)
    return kA, kC, dim


def rand_in_span(rows, k, p, rng):
    co = rng.integers(0, p, size=(k, rows.shape[0]))
    return (co @ rows) % p


# ------------------------------------------------------------- the conditions
def plane_blocks(fr, A, C, deg, m, npair, p, rng):
    """(cond1, cond2): ord_{P_sigma} >= m ; and the plus half to order m."""
    Wp, Wm = fr["Wplus"], fr["Wminus"]
    ns = A.shape[0]
    Wa = rand_in_span(Wp, npair, p, rng)
    Ya = rand_in_span(Wm, npair, p, rng)
    J = SL.jet_rows(fr, A, C, Wa, Ya, m + 1, deg=deg)      # (ns,npair,5,m+1)
    c1 = J[:, :, :, :m].reshape(ns, -1)                    # orders 0..m-1, all
    # the PLUS half at order m:  project the order-m vector onto W^+
    PPL = fr["PPLUS"]                                      # (3,5)
    top = J[:, :, :, m]                                    # (ns,npair,5)
    c2 = np.einsum('sqc,kc->sqk', top, PPL).reshape(ns, -1) % p
    return c1 % p, c2 % p


def line_block(fr, A, C, deg, r, npair, p, rng):
    LINE = fr["ellV"]
    FULL = np.eye(5, dtype=np.int64)
    ns = A.shape[0]
    Wb = rand_in_span(LINE, npair, p, rng)
    Yb = rand_in_span(FULL, npair, p, rng)
    J = SL.jet_rows(fr, A, C, Wb, Yb, r, deg=deg)
    return J.reshape(ns, -1) % p


def lambda_coeffs(fr, A, C, deg, m, r, p, base=None, verbose=True):
    """Taylor coefficients lambda_0..lambda_n of the leading line datum

           Lambda(w0 + tau v0)  in  V = Hom(Sym^m W^-, W^-)

    Returns an array of shape (nseeds, n+1, dimV) with dimV = 2(m+1) -- for
    m = 1, dimV = 4 and the V-index is (out, in) row-major in the (e_y,e_z)
    basis of W^-.  Also returns the LOWER x-coefficients (a control: they must
    vanish once ord_{ell_V} >= r).
    """
    assert m == 1, "steps 4-6 are implemented for m = 1"
    e = r - m
    n = deg - r
    p_ = p
    ns = A.shape[0]
    w0 = fr["w0"] if base is None else base
    v0, ex, ey, ez = fr["v0"], fr["ex"], fr["ey"], fr["ez"]
    PM = fr["PMINUS"]                                  # (2,5)
    taus = list(range(n + 1))
    pts = []
    dirs = []
    for t in taus:
        for u2 in (ey, ez):
            pts.append((w0 + t * v0) % p_)
            dirs.append(u2)
    Wb = np.array(pts, dtype=np.int64) % p_
    U1 = np.tile(ex % p_, (len(pts), 1))
    U2 = np.array(dirs, dtype=np.int64) % p_
    J1, J2 = e + 1, 2
    if verbose:
        print("    [Lambda] %d base points x 2 directions, jet shape (%d,%d)"
              % (len(taus), J1, J2), flush=True)
    res = P2.jet_rows2(fr, A, C, Wb, U1, U2, J1, J2, deg)   # (ns,2N,5,J1,J2)
    # Lambda(P)_{i,jdir} = PM_i . res[:, pt, :, e, 1]
    top = res[:, :, :, e, 1]                                # (ns, 2N, 5)
    lam_pts = np.einsum('sqc,ic->sqi', top, PM) % p_        # (ns, 2N, 2)
    # reassemble into (ns, N, 4) with V-index 2*i + jdir
    Lp = np.zeros((ns, n + 1, 4), dtype=np.int64)
    for k in range(n + 1):
        for jd in range(2):
            Lp[:, k, 2 * 0 + jd] = lam_pts[:, 2 * k + jd, 0]
            Lp[:, k, 2 * 1 + jd] = lam_pts[:, 2 * k + jd, 1]
    Vi = P2.vandermonde_inv(taus, p_)                       # (N,N)
    lam = np.einsum('kq,sqv->skv', Vi, Lp) % p_             # (ns, n+1, 4)
    # control: the lower x-coefficients of the (y,z)-degree-1 part
    low = res[:, :, :, :e, 1].reshape(ns, -1) % p_
    return lam, low


def cascade(fr, d, m, r, dimM, p, rng, do_h1=True, verbose=True):
    e, n = r - m, d - r
    rec = {"d": d, "m": m, "r": r, "e": e, "n": n, "dim_M": dimM}
    A, C, got = basis_seeds(fr, d, dimM, p, rng)
    if A is None:
        rec["verdict"] = "NOT-DECIDED"
        rec["reason"] = "seed shortfall %d/%d" % (got, dimM)
        return rec
    ns = A.shape[0]
    npair = max(60, dimM // 6 + 30)
    blocks = []
    steps = []

    c1, c2 = plane_blocks(fr, A, C, d, m, npair, p, rng)
    blocks.append(c1)
    steps.append("1: ord_{P_sigma} >= %d" % m)
    blocks.append(c2)
    steps.append("2: + ord_{P_sigma}(T^+) >= %d" % (m + 1))
    lb = line_block(fr, A, C, d, r, npair, p, rng)
    blocks.append(lb)
    steps.append("3: + ord_{ell_V} >= %d" % r)

    dims = []
    M = None
    for b, nm in zip(blocks, steps):
        M = b if M is None else np.concatenate([M, b], axis=1)
        rk = P2.rref_rank_fast(M, p)
        dims.append(int(dimM - rk))
        if verbose:
            print("  d=%2d (m,r)=(%d,%d)  %-34s dim = %d"
                  % (d, m, r, nm, dims[-1]), flush=True)
    rec["steps"] = list(zip(steps, dims))
    rec["dim_after_step3"] = dims[-1]

    if dims[-1] == 0:
        rec["verdict"] = "EMPTY-AT-STEP-3"
        return rec
    if not (do_h1 and m == 1):
        rec["verdict"] = "ALIVE-AFTER-STEP-3:%d" % dims[-1]
        return rec

    lam, low = lambda_coeffs(fr, A, C, d, m, r, p, verbose=verbose)
    # control: the x-coefficients below e must already vanish on the step-3
    # slice (they are forced by ord_{ell_V} >= r).
    Mc = np.concatenate([M, low], axis=1)
    rec["control_low_x_free"] = int(dimM - P2.rref_rank_fast(Mc, p)) == dims[-1]

    L0, L1, _ = P2.equalizer_lines(fr, e, p)
    rec["dim_L0"] = int(L0.shape[0])
    rec["dim_L1"] = int(L1.shape[0])
    rec["L0_neq_L1"] = bool(SL.rref_rank(np.concatenate([L0, L1], axis=0), p)
                            == 2) if (L0.shape[0] == 1 and
                                      L1.shape[0] == 1) else None

    # step 4 : lambda_k = 0 for k < 2e
    b4 = lam[:, :2 * e, :].reshape(ns, -1) % p
    M = np.concatenate([M, b4], axis=1)
    d4 = int(dimM - P2.rref_rank_fast(M, p))
    rec["steps"].append(("4: + H1-1(a) ord_{c_sigma}(Lambda) >= %d" % (2 * e),
                         d4))
    if verbose:
        print("  d=%2d (m,r)=(%d,%d)  %-34s dim = %d"
              % (d, m, r, "4: + H1-1(a) (order >= %d)" % (2 * e), d4),
              flush=True)

    # step 5 : lambda_{2e} in L0  <=>  ann(L0) . lambda_{2e} = 0
    ann0 = SL.nullspace(L0 % p, p)                 # (3,4) annihilator of L0
    b5 = np.einsum('sv,kv->sk', lam[:, 2 * e, :], ann0) % p
    M = np.concatenate([M, b5], axis=1)
    d5 = int(dimM - P2.rref_rank_fast(M, p))
    rec["steps"].append(("5: + H1-1(b) lambda_{2e} in L0", d5))
    if verbose:
        print("  d=%2d (m,r)=(%d,%d)  %-34s dim = %d"
              % (d, m, r, "5: + H1-1(b) lambda_%d in L0" % (2 * e), d5),
              flush=True)

    # step 6 : lambda_{2e+1} in L1
    d6 = d5
    if 2 * e + 1 <= n:
        ann1 = SL.nullspace(L1 % p, p)
        b6 = np.einsum('sv,kv->sk', lam[:, 2 * e + 1, :], ann1) % p
        M = np.concatenate([M, b6], axis=1)
        d6 = int(dimM - P2.rref_rank_fast(M, p))
    rec["steps"].append(("6: + H1-1(c) lambda_{2e+1} in L1", d6))
    if verbose:
        print("  d=%2d (m,r)=(%d,%d)  %-34s dim = %d"
              % (d, m, r, "6: + H1-1(c) lambda_%d in L1" % (2 * e + 1), d6),
              flush=True)

    rec["dim_final"] = d6
    rec["verdict"] = "EMPTY" if d6 == 0 else "ALIVE:%d" % d6
    return rec


def main():
    p = int(sys.argv[1]) if len(sys.argv) > 1 else 67
    dmin = int(sys.argv[2]) if len(sys.argv) > 2 else 36
    dmax = int(sys.argv[3]) if len(sys.argv) > 3 else 36
    os.makedirs(PAY, exist_ok=True)
    dims = load_dims()
    fr = P2.adapted_frame(SL.build_frame(p))
    rng = np.random.default_rng(20260806)
    rows = []
    for d in range(dmin, dmax + 1):
        profs = [x for x in SV.profiles_for(d) if x["admissible"]]
        if not profs:
            print("d=%2d  no admissible profile" % d, flush=True)
            rows.append({"d": d, "profiles": [], "verdict": "NO-PROFILE"})
            continue
        for x in profs:
            rec = cascade(fr, d, x["m"], x["r"], dims[d], p, rng)
            rows.append(rec)
            out = {"prime": p, "rows": rows,
                   "adapted_self_tests": {k: bool(v) for k, v in
                                          fr["adapted_self_tests"].items()},
                   "semantics": (
                       "dimension 0 at any step is a characteristic-zero "
                       "emptiness verdict for that (d, m, r); a nonzero value "
                       "is an upper bound only.")}
            fn = os.path.join(PAY, "CASCADE_p%d_%d_%d.json" % (p, dmin, dmax))
            with open(fn, "w") as fh:
                json.dump(out, fh, indent=1, sort_keys=True)
    print("wrote", fn if rows else "(nothing)", " elapsed %.1f s"
          % (time.time() - T0))


if __name__ == "__main__":
    sys.exit(main())
