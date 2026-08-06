"""Independent verification of the Stage-3 payload, from the coefficients only.

Nothing here reuses the product representation inv[34-e]*map[e] that produced
the tuples: every test starts from the explicit degree-34 coefficient arrays in
`payload/profile_basis_p*/coeffs.npz` and re-evaluates them.

  [A] equivariance  T(g v) = g T(v)  for ALL 660 group elements (so the tuples
      really lie in M_34, not merely in the span we built);
  [B] the plane condition, at fresh random points of Pi_sigma;
  [C] the line condition, at fresh random (base, direction) pairs of ell_V,
      with the jet taken by a fresh Vandermonde inversion -- and, as a
      sharpness control, that the order-6 coefficient is NOT identically zero
      (the profile is (1,6), not (1,7));
  [D] linear independence of the tuples as polynomials.
"""
import os
import sys
import time

import numpy as np

import gatelib as GL
from gatelib import check, matmul_mod, nmon
import stage1_group as S1
import stage2_span as S2

sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)),
                                "p2copy"))
import p2lib as P2             # noqa: E402

HERE = os.path.dirname(os.path.abspath(__file__))
DTOP = 34
R_PROF = 6
CHUNK = 400


def eval_tuples(T, PTS, p):
    """T (n,5,N_34) evaluated at PTS (npts,5) -> (n,5,npts)."""
    n = T.shape[0]
    flat = T.reshape(n * 5, -1) % p
    out = np.zeros((n * 5, PTS.shape[0]), dtype=np.int64)
    for lo in range(0, PTS.shape[0], CHUNK):
        hi = min(PTS.shape[0], lo + CHUNK)
        PTSt = np.ascontiguousarray(PTS[lo:hi].T)
        vals = np.ones((1, hi - lo), dtype=np.int64)
        for d in range(1, DTOP + 1):
            vals = S2.mon_step(vals, d, PTSt, p)
        out[:, lo:hi] = matmul_mod(flat, vals, p)
    return out.reshape(n, 5, PTS.shape[0])


def run(p, tag=""):
    t0 = time.time()
    log = lambda *a: print(*a, flush=True)
    log("=== verifier, p=%d ===" % p)
    T = np.load(os.path.join(HERE, "payload", "profile_basis_p%d" % p,
                             "coeffs.npz"))["T"].astype(np.int64)
    n1 = T.shape[0]
    fr = P2.adapted_frame(S1.make_frame(p, do_checks=False), verbose=False)
    RHO = fr["RHO"]
    rng = np.random.default_rng(555000 + p)

    # [A] equivariance against all 660 group elements
    V = rng.integers(1, p, size=(4, 5)).astype(np.int64)
    GV = np.einsum('gij,qj->gqi', RHO, V).reshape(-1, 5) % p
    valsV = eval_tuples(T, V, p)                       # (n,5,4)
    valsG = eval_tuples(T, GV, p).reshape(n1, 5, 660, V.shape[0])
    want = np.einsum('gij,njq->nigq', RHO, valsV) % p
    bad = int(np.count_nonzero((valsG - want) % p))
    check("payload_equivariant_660" + tag, bad == 0,
          "T(g.v) = g.T(v) at %d points for all 660 elements (%d mismatches)"
          % (V.shape[0], bad))

    # [B] the plane condition
    Wp = (rng.integers(0, p, size=(120, 3)) @ fr["Wplus"]) % p
    vp = eval_tuples(T, Wp, p)
    check("payload_vanishes_on_plane" + tag, not np.any(vp % p),
          "all 5 components vanish at %d fresh points of Pi_sigma" % len(Wp))

    # [C] the line condition, fresh jets
    NL = 120
    Wl = (rng.integers(0, p, size=(NL, 2)) @ fr["ellV"]) % p
    Yl = rng.integers(0, p, size=(NL, 5)) % p
    taus = (np.arange(DTOP + 1) + 1) % p
    LP = (Wl[:, None, :] + taus[None, :, None] * Yl[:, None, :]) % p
    vl = eval_tuples(T, LP.reshape(-1, 5), p).reshape(n1, 5, NL, DTOP + 1)
    Vinv = P2.vandermonde_inv(list(taus), p)
    co = np.einsum('ks,ncqs->ncqk', Vinv, vl) % p
    check("payload_line_order_6" + tag, not np.any(co[:, :, :, :R_PROF] % p),
          "jet coefficients t^0..t^%d vanish along ell_V at %d fresh pairs"
          % (R_PROF - 1, NL))
    sharp = [bool(np.any(co[j, :, :, R_PROF] % p)) for j in range(n1)]
    check("payload_line_order_sharp" + tag, all(sharp),
          "the t^%d coefficient is nonzero for every basis tuple (profile is "
          "(1,6), not (1,7)): %s" % (R_PROF, sharp))

    # [D] independence as polynomials
    rk = GL.rank_mod(T.reshape(n1, -1), p)
    check("payload_independent" + tag, rk == n1,
          "rank of the %d coefficient vectors = %d" % (n1, rk))
    log("  verifier %.0fs" % (time.time() - t0))


if __name__ == "__main__":
    for pp in [int(a) for a in (sys.argv[1:] or ["67", "199"])]:
        run(pp, tag="_p%d" % pp)
