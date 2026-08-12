#!/usr/bin/env python3
"""Produce TANGENT_C6 artefacts.  Writes ONLY under this packet's results/.

Usage:
  python3 scripts/produce.py            # polar + both primes
  python3 scripts/produce.py --p 331    # one prime
  python3 scripts/produce.py --polar    # identities only
"""
from __future__ import annotations

import argparse
import json
import os
import sys
import time

# one thread: director msolve/lean jobs own the box
os.environ.setdefault("OMP_NUM_THREADS", "1")
os.environ.setdefault("OPENBLAS_NUM_THREADS", "1")
os.environ.setdefault("MKL_NUM_THREADS", "1")
os.environ.setdefault("VECLIB_MAXIMUM_THREADS", "1")
os.environ.setdefault("NUMEXPR_NUM_THREADS", "1")

import numpy as np

import paths
import polar as P
import celllib as CL
import slicelib as SL

RES = paths.RES
DIM37 = paths.DIM37
NPTS = 96
N_RANDOM = 12


def dump(name, obj):
    path = os.path.join(RES, name)
    with open(path, "w") as f:
        json.dump(obj, f, indent=1)
    return path


def polar_stage():
    rec = P.run_checks()
    dump("polar_identities.json", rec)
    print("polar: %d checks, %d fails" % (rec["n_checks"], rec["n_fail"]),
          flush=True)
    if rec["n_fail"]:
        raise SystemExit("polar identities failed: %s" % rec["fails"])
    return rec


def run_prime(p, npts=NPTS, n_random=N_RANDOM):
    print("== cell / polar Jacobian p=%d" % p, flush=True)
    t0 = time.time()
    cell = CL.cell37(p)
    Aseed, Cseed = CL.load_AC()
    print("   cell %s  rank_U=%d  (%.1fs)" % (
        list(cell["B37"].shape), cell["rank_U"], time.time() - t0), flush=True)
    fr = SL.build_frame(p, verbose=False)
    rng = np.random.default_rng(20260812 + p)
    W = rng.integers(1, p, size=(npts, 5)) % p
    t1 = time.time()
    V = CL.seed_values(fr, Aseed, Cseed, W)
    print("   seed values %s in %.1fs" % (list(V.shape), time.time() - t1),
          flush=True)
    Tbasis = CL.tbasis_from_seeds(cell["B37"], V, p)

    origin = np.zeros(DIM37, dtype=np.int64)
    rho0 = CL.rho(origin, Tbasis, p)
    A0 = CL.A_matrix(origin, Tbasis, p)
    origin_rec = {
        "p": int(p),
        "rho": int(rho0),
        "A_is_zero": bool(np.all(A0 == 0)),
        "tan_dim": int(DIM37 - rho0),
        "npts": int(npts),
        "note": "cone vertex: grad F(0)=0 and Hess F(0)=0, so A(0)=0",
    }
    dump("origin_p%d.json" % p, origin_rec)
    print("   origin rho=%d  A==0 %s" % (rho0, origin_rec["A_is_zero"]),
          flush=True)

    # Euler + homogeneity on a few random points
    euler_ok = []
    homog_ok = []
    second_ok = []
    ranks_random = []
    kernels_one = []  # store one kernel basis row-set if rank < 37
    for t in range(n_random):
        c = rng.integers(1, p, size=DIM37) % p
        rnk = CL.rho(c, Tbasis, p)
        ranks_random.append(int(rnk))
        lhs, rhs, ok = CL.euler_residual(c, Tbasis, p)
        euler_ok.append(bool(ok))
        # A(λc) = λ² A(c)
        lam = int(rng.integers(2, min(p - 1, 20)))
        A_c = CL.A_matrix(c, Tbasis, p)
        A_lc = CL.A_matrix((lam * c) % p, Tbasis, p)
        homog_ok.append(bool(np.array_equal(A_lc, (lam * lam * A_c) % p)))
        # second-order identity vs polarisation, sampled
        s = rng.integers(0, p, size=DIM37) % p
        rr = rng.integers(0, p, size=DIM37) % p
        lhs2 = CL.second_order_sample(c, s, rr, Tbasis, p)
        Tc = CL.T_at(c, Tbasis, p)
        Ts = CL.T_at(s, Tbasis, p)
        Tr = CL.T_at(rr, Tbasis, p)
        rhs2 = np.zeros(npts, dtype=np.int64)
        for q in range(npts):
            rhs2[q] = (
                2 * P.Phi3(Tc[q].tolist(), Ts[q].tolist(), Ts[q].tolist())
                + 2 * P.Phi3(Tc[q].tolist(), Tc[q].tolist(), Tr[q].tolist())
            ) % p
        second_ok.append(bool(np.array_equal(lhs2, rhs2)))
        if rnk < DIM37:
            ns = SL.nullspace(A_c, p)
            kernels_one.append([int(x) for x in ns.reshape(-1)[:DIM37]])

    # rank on the 37 basis rays
    ranks_basis = []
    for i in range(DIM37):
        e = np.zeros(DIM37, dtype=np.int64)
        e[i] = 1
        ranks_basis.append(int(CL.rho(e, Tbasis, p)))

    # a few sparse (weight-2) points
    ranks_sparse2 = []
    for t in range(8):
        e = np.zeros(DIM37, dtype=np.int64)
        i, j = int(rng.integers(0, DIM37)), int(rng.integers(0, DIM37))
        e[i] = 1
        e[j] = int(rng.integers(1, p))
        ranks_sparse2.append(int(CL.rho(e, Tbasis, p)))

    all_pos = ranks_random + ranks_basis + ranks_sparse2
    rho_gen = max(all_pos) if all_pos else None
    rho_min_pos = min(all_pos) if all_pos else None
    jump_seen = rho_min_pos is not None and rho_min_pos < rho_gen

    # common kernel of A at the random points (stack)
    stack = []
    for t in range(min(4, n_random)):
        c = rng.integers(1, p, size=DIM37) % p
        stack.append(CL.A_matrix(c, Tbasis, p))
    stacked = np.vstack(stack) if stack else np.zeros((0, DIM37), dtype=np.int64)
    common_kdim = int(DIM37 - SL.rref_rank(stacked, p)) if stacked.size else DIM37

    gen_rec = {
        "p": int(p),
        "npts": int(npts),
        "n_random": int(n_random),
        "ranks_random": ranks_random,
        "ranks_basis_rays": ranks_basis,
        "ranks_sparse2": ranks_sparse2,
        "rho_generic": int(rho_gen) if rho_gen is not None else None,
        "rho_min_positive_samples": int(rho_min_pos) if rho_min_pos is not None else None,
        "jump_seen_in_samples": bool(jump_seen),
        "all_positive_samples_constant": bool(rho_gen == rho_min_pos),
        "euler_ok": euler_ok,
        "euler_all_ok": all(euler_ok),
        "homog_ok": homog_ok,
        "homog_all_ok": all(homog_ok),
        "second_order_ok": second_ok,
        "second_order_all_ok": all(second_ok),
        "common_kernel_dim_of_4_random": common_kdim,
        "seconds": time.time() - t0,
    }
    dump("generic_rank_p%d.json" % p, gen_rec)
    print("   rho_generic=%s  min_pos=%s  jump_in_samples=%s  euler=%s  homog=%s  25.2=%s  common_ker=%d  (%.1fs)"
          % (rho_gen, rho_min_pos, jump_seen, all(euler_ok), all(homog_ok),
             all(second_ok), common_kdim, gen_rec["seconds"]), flush=True)
    return origin_rec, gen_rec, cell


def jump_analysis(gen_by_p):
    """What the samples + Euler say about the degeneracy loci."""
    rhos = {str(p): g["rho_generic"] for p, g in gen_by_p.items()}
    constant = {str(p): g["all_positive_samples_constant"] for p, g in gen_by_p.items()}
    jump_seen = {str(p): g["jump_seen_in_samples"] for p, g in gen_by_p.items()}
    common = {str(p): g["common_kernel_dim_of_4_random"] for p, g in gen_by_p.items()}
    rgen = list(rhos.values())[0]
    rec = {
        "rho_generic_by_prime": rhos,
        "samples_constant_by_prime": constant,
        "jump_seen_in_samples": jump_seen,
        "common_kernel_dim": common,
        "rho_generic_agrees": len(set(rhos.values())) == 1,
        "interpretation": {
            "A_entries": (
                "quadratic in c (Jac of the landing cubics); not themselves "
                "vanishing conditions on V"
            ),
            "locus_rho_le_k": (
                "closed, cut by (k+1)-minors of A, degree 2(k+1)"
            ),
            "euler": "A(c) c = 3 F(T_c), so c in V implies rho(c) <= 36",
            "first_drop": (
                "{rho <= 36} contains V\\{0} by Euler; intersecting V with "
                "that locus does nothing"
            ),
            "further_drops": (
                "{rho <= 35} is the Jacobian-criterion / singular-locus cut "
                "on P(V); it is a proper closed condition on the cell iff "
                "rho_generic > 35, and it is NOT implied by the landing "
                "cubics (does not vanish on all of V unless P(V) is "
                "everywhere singular).  No nonzero point of V is known, so "
                "membership of V in {rho <= 35} is not evaluated."
            ),
            "new_vs_restatement": (
                "The minors of A are new polynomials on the 37-cell "
                "(Jacobian ideal, not the landing ideal).  They are a "
                "restatement of Jac(landing cubics), not a new spanning set "
                "of equations that every landing point must satisfy.  "
                "Deformation theory does not cut V except by the optional "
                "singular-locus intersection."
            ),
            "rho_generic_measured": rgen,
        },
    }
    dump("jump_locus.json", rec)
    return rec


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--p", type=int, default=None)
    ap.add_argument("--polar", action="store_true")
    ap.add_argument("--npts", type=int, default=NPTS)
    args = ap.parse_args()

    polar = polar_stage()
    if args.polar:
        dump("summary.json", {"polar": polar, "cell": None})
        return

    primes = (args.p,) if args.p else paths.PRIMES
    origins = {}
    gens = {}
    cells = {}
    for p in primes:
        o, g, cell = run_prime(p, npts=args.npts)
        origins[p] = o
        gens[p] = g
        cells[p] = {
            "shape": list(cell["B37"].shape),
            "rank_U": cell["rank_U"],
            "null_shape": cell["null_shape"],
        }
    jump = jump_analysis(gens)
    summary = {
        "headline": "Problem E remains OPEN; this packet excludes no degree.",
        "polar_ok": polar["all_ok"],
        "polar_n_checks": polar["n_checks"],
        "cells": cells,
        "origin_rho": {str(p): origins[p]["rho"] for p in origins},
        "origin_A_zero": {str(p): origins[p]["A_is_zero"] for p in origins},
        "rho_generic": {str(p): gens[p]["rho_generic"] for p in gens},
        "euler_all_ok": {str(p): gens[p]["euler_all_ok"] for p in gens},
        "homog_all_ok": {str(p): gens[p]["homog_all_ok"] for p in gens},
        "second_order_all_ok": {str(p): gens[p]["second_order_all_ok"] for p in gens},
        "jump": {
            "rho_generic_by_prime": jump["rho_generic_by_prime"],
            "samples_constant": jump["samples_constant_by_prime"],
            "jump_seen_in_samples": jump["jump_seen_in_samples"],
        },
        "excludes_no_degree": True,
        "nonzero_landing_point": False,
    }
    dump("summary.json", summary)
    print("SUMMARY rho0=%s  rho_gen=%s" % (
        summary["origin_rho"], summary["rho_generic"]), flush=True)


if __name__ == "__main__":
    main()
