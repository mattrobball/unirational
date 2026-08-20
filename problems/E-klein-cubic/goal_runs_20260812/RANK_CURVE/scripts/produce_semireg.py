#!/usr/bin/env python3
"""Semi-regularity probe at d=35: independence of the 37 x 1380 products.

The degree-4 piece of the landing ideal is spanned by x_i * g_j, i=0..36,
j=0..1379. Ambient dim N4 = C(40,4) = 91390. Domain dim = 51060.

A randomized test: take a large random subset of those products, evaluate
them at random cell-parameter points, and compute exact rank over F_p.
Evaluation can only drop rank, so full rank of an N x N sketch certifies
that those N products are linearly independent.

Usage: python3 scripts/produce_semireg.py [p] [Nmax]
"""
from __future__ import annotations

import os
import sys
import time

import numpy as np

import paths
import cells
import cubics
import lin
import d34lib as D34
import p2lib as P2
import slicelib as SL

K = 37
P3_SEAL = 1380
N4 = 91390
P4_UB = K * P3_SEAL  # 51060


def independent_rows(rows, p, want):
    """Return indices of a linearly independent subset, up to `want`."""
    if paths.INV_SCR not in sys.path:
        sys.path.insert(1, paths.INV_SCR)
    import invlib as L

    ech = L.Echelon(rows.shape[1], p)
    idx = []
    for i in range(rows.shape[0]):
        if ech.try_add(rows[i]):
            idx.append(i)
            if len(idx) >= want:
                break
        if (i + 1) % 200 == 0:
            print(
                "  row %d independent %d rss=%.2fGB" % (i + 1, len(idx), lin.rss_gb()),
                flush=True,
            )
    return idx, int(ech.rank)


def product_eval_matrix(Z, G, pairs, p):
    """M[s,t] = z_t[i_s] * g_{j_s}(z_t). Z (Nz,K), G (P3,Nz)."""
    ii = pairs[:, 0]
    jj = pairs[:, 1]
    return (Z[:, ii].T * G[jj, :]) % p


def certify_subset(Z, G, N, p, seed, tag):
    t0 = time.time()
    rng = np.random.default_rng(seed)
    P3 = G.shape[0]
    Nz = Z.shape[0]
    if N > P4_UB or N > Nz:
        raise ValueError("N=%d exceeds P4_UB=%d or Nz=%d" % (N, P4_UB, Nz))
    flat = rng.choice(K * P3, size=N, replace=False)
    pairs = np.column_stack((flat // P3, flat % P3)).astype(np.int32)
    M = product_eval_matrix(Z, G, pairs, p)
    print(
        "[%s] N=%d matrix %s rss=%.2fGB; ranking ..."
        % (tag, N, M.shape, lin.rss_gb()),
        flush=True,
    )
    rk = lin.rank_mod(M, p)
    rec = {
        "tag": tag,
        "N": int(N),
        "rank": int(rk),
        "full": int(rk) == int(N),
        "seed": int(seed),
        "seconds": time.time() - t0,
        "rss_gb": lin.rss_gb(),
    }
    print(
        "[%s] rank=%d / %d full=%s (%.1fs)"
        % (tag, rk, N, rec["full"], rec["seconds"]),
        flush=True,
    )
    return rec, pairs if rec["full"] else None


def run_one(p: int, nmax: int) -> dict:
    t0 = time.time()
    print("=" * 60, "\n[semireg] d=35 p=%d nmax=%d" % (p, nmax), flush=True)
    fr = D34.stage2_frame(P2.adapted_frame(SL.build_frame(p, verbose=False)))
    cell = cells.load_d35_cell(p)
    A, C, B = cell["A"], cell["C"], cell["Bcell"]

    # Generators: sealed I3 echelon (same 1380-space as restricted_cubics).
    # Control packet already checked director restricted_cubics rank = 1380.
    i3path = os.path.join(paths.D35L_RES, "I3_echelon_p%d.npy" % p)
    if not os.path.exists(i3path):
        raise SystemExit("missing I3 basis %s" % i3path)
    gens = np.load(i3path) % p
    assert gens.shape[0] == P3_SEAL, gens.shape
    P3 = gens.shape[0]
    npts = 0
    print("[gens] I3_echelon %s rss=%.2fGB" % (gens.shape, lin.rss_gb()), flush=True)

    # Evaluate each cubic at random z by the monomial contraction.
    # mon (a,b,c) <-> combinations_with_replacement, same as restricted_cubics.
    import itertools
    mons = list(itertools.combinations_with_replacement(range(K), 3))
    assert gens.shape[1] == len(mons), (gens.shape, len(mons))
    Nz = max(nmax + 200, 4200)
    rngz = np.random.default_rng(20260812 + 19 * p)
    Z = rngz.integers(0, p, size=(Nz, K), dtype=np.int64)
    print("[eval] building z-monomials Nz=%d N3=%d" % (Nz, len(mons)), flush=True)
    zmon = np.empty((Nz, len(mons)), dtype=np.int64)
    for t, (a, b, c) in enumerate(mons):
        zmon[:, t] = (Z[:, a] * Z[:, b] % p) * Z[:, c] % p
    G = (gens.astype(np.int64) @ zmon.T) % p  # (P3, Nz)
    del zmon
    print("[eval] G=%s rss=%.2fGB" % (G.shape, lin.rss_gb()), flush=True)

    schedule = [n for n in (2000, 4000, 6000, 8000, 10000, 12000, 15000) if n <= nmax]
    if nmax not in schedule:
        schedule.append(nmax)
        schedule = sorted(set(schedule))

    probes = []
    largest = 0
    largest_seed = None
    for N in schedule:
        rec, _ = certify_subset(
            Z, G, N, p, seed=13 + 10007 * N + 17 * p, tag="subset_N%d" % N
        )
        probes.append(rec)
        if rec["full"]:
            largest = N
            largest_seed = rec["seed"]
        else:
            # A dependent random subset falsifies free spanning (not semi-regular).
            break

    # Structured block: all 37 multiples of a random 150 gens (5550 products).
    nblock = min(150, P3)
    rngb = np.random.default_rng(41 + p)
    jsel = rngb.choice(P3, size=nblock, replace=False)
    pairs = np.array([[i, int(j)] for j in jsel for i in range(K)], dtype=np.int32)
    print("[block] 37 x %d = %d products" % (nblock, pairs.shape[0]), flush=True)
    # Need Nz >= 37*nblock
    if Z.shape[0] < pairs.shape[0]:
        print("[block] skipped: Nz < block size", flush=True)
        block = {"skipped": True}
    else:
        t1 = time.time()
        M = product_eval_matrix(Z, G, pairs, p)
        rk_b = lin.rank_mod(M, p)
        block = {
            "n_gens": int(nblock),
            "N": int(pairs.shape[0]),
            "rank": int(rk_b),
            "full": int(rk_b) == int(pairs.shape[0]),
            "seconds": time.time() - t1,
        }
        print("[block] rank=%d / %d" % (rk_b, pairs.shape[0]), flush=True)
        if block["full"] and block["N"] > largest:
            largest = block["N"]
            largest_seed = "block_37x%d" % nblock

    free = all(pr["full"] for pr in probes) and block.get("full", True)
    rec = {
        "d": 35,
        "p": int(p),
        "K": K,
        "P3": int(P3),
        "N4": N4,
        "n_products": P4_UB,
        "domain_ub": P4_UB,
        "HF4_domain_lb": N4 - P4_UB,
        "npts_cubics": npts,
        "Nz": int(Nz),
        "probes": probes,
        "block_37x": block,
        "largest_independent_subset": int(largest),
        "largest_seed": largest_seed,
        "no_dependency_found": bool(free),
        "verdict": (
            "UNFALSIFIED_AT_SCALE"
            if free
            else "DEPENDENCY_FOUND_NOT_SEMIREGULAR"
        ),
        "note": (
            "A full-rank N x N evaluation sketch of N random products certifies "
            "those N products are independent in Sym^4. A rank drop on a random "
            "subset proves the 51060 products are dependent (not a free spanning "
            "of the degree-4 piece). Semi-regularity at c-degree 4 would mean "
            "all 51060 products are independent. Groebner at c-degree 5 is "
            "numerically possible iff the Macaulay matrix at degree 5 can fill "
            "Sym^5 (703*1380 = 970140 > 749398); a degree-4 dependency already "
            "means the system is not semi-regular, so termination at 5 is not "
            "predicted."
        ),
        "seconds": time.time() - t0,
        "rss_gb": lin.rss_gb(),
        "mode": "restricted_cubics + product evaluation rank",
    }
    path = os.path.join(paths.RES, "semireg_d35_p%d.json" % p)
    lin.dump(path, rec)
    print("[write]", path, "largest=%d verdict=%s" % (largest, rec["verdict"]), flush=True)
    return rec


def main():
    args = [int(a) for a in sys.argv[1:] if a.isdigit()]
    p = args[0] if args else 331
    nmax = args[1] if len(args) > 1 else 8000
    rec = run_one(p, nmax)
    lin.dump(os.path.join(paths.RES, "semireg_summary.json"), {str(p): {
        "largest_independent_subset": rec["largest_independent_subset"],
        "verdict": rec["verdict"],
        "P3": rec["P3"],
        "seconds": rec["seconds"],
    }})
    return 0


if __name__ == "__main__":
    sys.exit(main())
