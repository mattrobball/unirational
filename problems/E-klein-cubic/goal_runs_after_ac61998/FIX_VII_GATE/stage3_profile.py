"""Stage 3: the (1,6) profile conditions on M_34, and the explicit basis.

The two condition blocks are TRANSLATIONS of the FIX-P2 sieve rows that
produced the sealed (1,6) table -- read off `produce_cascade.plane_blocks`
(with m = 1) and `produce_cascade.line_block` (with r = 6), which are the only
two blocks `produce_sweep2.main` concatenates:

    (a) plane_blocks(..., m=1) -> c1 = J[:, :, :, :1]
        = the value of ALL FIVE components at points w of the plus-plane
          Pi_sigma = P(W^+).                    [ord_{Pi_sigma} T >= 1]

    (b) line_block(..., r=6)  -> J[:, :, :, :6]
        = the t-coefficients 0..5 of ALL FIVE components of T(w + t y),
          w in ell_V = P(W^{V4}), y an arbitrary direction of W.
                                                [ord_{ell_V} T >= 6]

So the multi-order (r; m, m, m) = (6; 1, 1, 1) is NOT encoded as a
component-by-component order split: it is `order 6 along the line, all five
value components, all transverse directions' plus `order 1 along each of the
three plus-planes of the V4' -- and equivariance reduces the latter three to
the single representative Pi_sigma.  No alternative translation had to be
tried; the encoding is read directly off the sealed implementation.

(c) No condition is imposed at c_sigma: sealed exit FIX-P2-H11-LOCAL-CONFIRMED
    proves every H1-1 clause there is forced by (a) + (b).

Jets are taken by evaluating along the line at 35 distinct parameter values
and inverting the 35x35 Vandermonde -- exact, since T restricted to a line is
a polynomial of degree exactly 34 in the affine parameter and p > 34.
"""
import json
import os
import sys
import time

import numpy as np

import gatelib as GL
from gatelib import check, matmul_mod, monomials, nmon, nullspace, shift_row
import stage1_group as S1
import stage2_span as S2

sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)),
                                "p2copy"))
import p2lib as P2             # noqa: E402

HERE = os.path.dirname(os.path.abspath(__file__))
DTOP = 34
M_PROF, R_PROF = 1, 6
DIM_M34 = 576
S34 = 16                       # sealed FIX-P2 (1,6)/d=34 slice dimension
N_PLANE = 200
N_LINE = 200
CHUNK = 400


def rand_in_span(rows, k, p, rng):
    co = rng.integers(0, p, size=(k, rows.shape[0]))
    return (co @ rows) % p


def eval_bases(PTS, INVC, MAPC, need_inv, need_map, p, log=print):
    """Values of the chosen invariant / map bases at PTS, chunked over points."""
    npts = PTS.shape[0]
    INVV = {d: np.zeros((len(INVC[d]), npts), dtype=np.int64) for d in need_inv}
    MAPV = {e: np.zeros((len(MAPC[e]), 5, npts), dtype=np.int64)
            for e in need_map}
    dmax = max(max(need_inv), max(need_map))
    t0 = time.time()
    for lo in range(0, npts, CHUNK):
        hi = min(npts, lo + CHUNK)
        PTSt = np.ascontiguousarray(PTS[lo:hi].T)
        vals = np.ones((1, hi - lo), dtype=np.int64)
        for d in range(1, dmax + 1):
            vals = S2.mon_step(vals, d, PTSt, p)
            if d in need_inv:
                INVV[d][:, lo:hi] = matmul_mod(INVC[d], vals, p)
            if d in need_map:
                MAPV[d][:, :, lo:hi] = matmul_mod(
                    MAPC[d].reshape(-1, nmon(d)), vals,
                    p).reshape(len(MAPC[d]), 5, hi - lo)
        log("    eval %d/%d points  (%.0fs)" % (hi, npts, time.time() - t0))
    return INVV, MAPV


def run(p, tag=""):
    t0 = time.time()
    log = lambda *a: print(*a, flush=True)
    log("=== Stage 3, p=%d ===" % p)
    fr = P2.adapted_frame(S1.make_frame(p, do_checks=False), verbose=True)

    invz = np.load(os.path.join(HERE, "payload", "invC_p%d.npz" % p))
    covz = np.load(os.path.join(HERE, "payload", "covC_p%d.npz" % p))
    INVC = {int(k[1:]): invz[k].astype(np.int64) for k in invz.files}
    MAPC = {int(k.split("_")[1]): covz[k].astype(np.int64)
            for k in covz.files if k.startswith("map_")}
    meta = json.load(open(os.path.join(HERE, "payload",
                                       "m34_basis_p%d.json" % p)))
    basis = [tuple(t) for t in meta["basis"]]
    assert len(basis) == DIM_M34, len(basis)
    need_map = sorted({e for e, _, _ in basis})
    need_inv = sorted({DTOP - e for e in need_map})
    log("  basis uses map degrees %s" % need_map)

    rng = np.random.default_rng(97531 + p)
    # (a) plane points
    Wplane = rand_in_span(fr["Wplus"], N_PLANE, p, rng)
    # (b) line base points + directions, sampled at 35 parameter values
    Wline = rand_in_span(fr["ellV"], N_LINE, p, rng)
    Yline = rng.integers(0, p, size=(N_LINE, 5)) % p
    taus = np.arange(DTOP + 1, dtype=np.int64) % p            # 35 values
    LP = (Wline[:, None, :] + taus[None, :, None] * Yline[:, None, :]) % p
    LP = LP.reshape(N_LINE * (DTOP + 1), 5)
    PTS = np.concatenate([Wplane, LP], axis=0)
    log("  %d plane points + %d line points (%d pairs x %d taus)"
        % (N_PLANE, LP.shape[0], N_LINE, DTOP + 1))

    INVV, MAPV = eval_bases(PTS, INVC, MAPC, set(need_inv), set(need_map), p,
                            log=log)
    Vinv = P2.vandermonde_inv(list(taus), p)                  # (35,35)

    # --- rows of the condition matrix, one per basis element of M_34
    nplane = N_PLANE
    rows = np.zeros((DIM_M34, 5 * nplane + 5 * N_LINE * R_PROF),
                    dtype=np.int64)
    for j, (e, u, a) in enumerate(basis):
        v = (INVV[DTOP - e][a][None, :] * MAPV[e][u]) % p     # (5, npts)
        rows[j, :5 * nplane] = v[:, :nplane].reshape(-1)
        lv = v[:, nplane:].reshape(5, N_LINE, DTOP + 1)
        co = np.einsum('ks,cqs->cqk', Vinv, lv) % p           # (5,N_LINE,35)
        rows[j, 5 * nplane:] = co[:, :, :R_PROF].reshape(-1)
    log("  condition matrix %s  (%.0fs)" % (rows.shape, time.time() - t0))

    rk = P2.rref_rank_fast(rows, p)
    n1 = DIM_M34 - rk
    log("  rank = %d   n1 = %d" % (rk, n1))

    # saturation control: half the functionals must give the same answer
    half = np.concatenate([rows[:, :5 * (nplane // 2)],
                           rows[:, 5 * nplane:5 * nplane +
                                5 * (N_LINE // 2) * R_PROF]], axis=1)
    n1_half = DIM_M34 - P2.rref_rank_fast(half, p)
    check("profile_sampling_saturated" + tag, n1_half == n1,
          "n1 with half the sampled functionals = %d, with all = %d"
          % (n1_half, n1))
    check("profile_dim_matches_P2" + tag, n1 == S34,
          "n1 = %d, sealed FIX-P2 (1,6)/d=34 slice s34 = %d" % (n1, S34))

    # --- kernel: the profile space, in coordinates of the 576 basis elements
    ker = nullspace(rows.T % p, p).T % p                      # (n1, 576)
    assert ker.shape[0] == n1
    # sanity: the kernel really satisfies both blocks
    resid = matmul_mod(ker, rows, p)
    check("profile_kernel_exact" + tag, not np.any(resid),
          "residual of the %d kernel vectors on all %d functionals is zero"
          % (n1, rows.shape[1]))

    np.savez_compressed(os.path.join(HERE, "payload",
                                     "profile_kernel_p%d.npz" % p),
                        ker=ker.astype(np.int64),
                        basis=np.array(basis, dtype=np.int64))
    log("  materialising %d degree-34 tuples ..." % n1)
    T = materialise(ker, basis, INVC, MAPC, p, log=log)
    nz = [int(np.count_nonzero(T[j])) for j in range(n1)]
    check("profile_basis_nonzero" + tag, all(x > 0 for x in nz),
          "nonzero coefficient counts per tuple: %s" % nz)
    dump_basis(T, p, tag)
    log("  Stage 3 total %.0fs" % (time.time() - t0))
    return dict(n1=n1, T=T, ker=ker, basis=basis)


def materialise(ker, basis, INVC, MAPC, p, log=print):
    """ker (n1,576) over the products inv[34-e][a]*map[e][u]  ->  (n1,5,N_34)."""
    t0 = time.time()
    n1 = ker.shape[0]
    N34 = nmon(DTOP)
    OUT = np.zeros((n1, 5, N34), dtype=np.int64)
    groups = {}
    for j, (e, u, a) in enumerate(basis):
        groups.setdefault((e, u), []).append((j, a))
    for (e, u), lst in sorted(groups.items()):
        aa = DTOP - e
        idx = np.array([j for j, _ in lst])
        arow = np.array([a for _, a in lst])
        Bmat = matmul_mod(ker[:, idx], INVC[aa][arow], p)     # (n1, N_{34-e})
        mons_e, _ = monomials(e)
        for i in range(5):
            comp = MAPC[e][u, i] % p
            for t in np.nonzero(comp)[0]:
                c = int(comp[t])
                row = shift_row(mons_e[t], aa)
                OUT[:, i, row] = (OUT[:, i, row] + c * Bmat) % p
        log("    (e=%2d,u=%2d) done  (%.0fs)" % (e, u, time.time() - t0))
    return OUT % p


def dump_basis(T, p, tag):
    d = os.path.join(HERE, "payload", "profile_basis_p%d" % p)
    os.makedirs(d, exist_ok=True)
    mons, _ = monomials(DTOP)
    np.savez_compressed(os.path.join(d, "coeffs.npz"), T=T.astype(np.uint8))
    for j in range(T.shape[0]):
        with open(os.path.join(d, "T%02d.txt" % j), "w") as f:
            f.write("# FIX-VII-GATE profile basis element %d, p=%d\n" % (j, p))
            f.write("# G-equivariant degree-34 covariant tuple T: P(W) -> P(W)\n")
            f.write("# format: <component 0..4> <e0 e1 e2 e3 e4> <coefficient>\n")
            for i in range(5):
                nz = np.nonzero(T[j, i])[0]
                for k in nz:
                    f.write("%d %d %d %d %d %d %d\n"
                            % (i, mons[k][0], mons[k][1], mons[k][2],
                               mons[k][3], mons[k][4], int(T[j, i, k])))
    with open(os.path.join(d, "README.txt"), "w") as f:
        f.write("FIX-VII-GATE Stage 3 payload, p=%d\n" % p)
        f.write("%d files T00..T%02d: a basis of\n" % (T.shape[0],
                                                       T.shape[0] - 1))
        f.write("  { T in M_34 : ord_{Pi_sigma} T >= 1, ord_{ell_V} T >= 6 }\n")
        f.write("coeffs.npz holds the same data as an array T[j, i, monomial]\n")
        f.write("over gatelib.monomials(34) (degree-34 monomials of F_p[x0..x4],\n")
        f.write("reverse-lexicographic recursive order).\n")


if __name__ == "__main__":
    for pp in [int(a) for a in (sys.argv[1:] or ["67", "199"])]:
        run(pp, tag="_p%d" % pp)
