#!/usr/bin/env python3
"""Director probe (2026-08-12): deficiency profile of the landing system
restricted to random sections of the d = 35 37-cell.

Globally the landing cubics span P3 = 1380 of the 9139 dimensions of
Sym^3 of the 37-cell.  Restricted to a random m-dimensional section L,
the cubics span some subspace of Sym^3(L) (dim C(m+2,3)); the deficiency
HF_L(3) = C(m+2,3) - rank measures how far the system is from cutting L
down to the origin at degree 3.

Why it matters: a GENERIC 1380-dimensional space of cubics restricts onto
all of Sym^3(L) whenever C(m+2,3) <= 1380 (m <= 19), so any deficiency
there is a structural signature of the landing system, and it bounds
where the solution cone can meet L.

Method: for a section basis b_1..b_m (vectors in the 637 seed
coordinates) and a sample point x, T_{c(t)}(x) = sum_i t_i v_i with
v_i = T_{b_i}(x); F(sum t_i v_i) expands by F = sum_k y_k^2 y_{k+1} into
a cubic form in t.  Rank over many x.

Usage: python3 section_deficiency_probe.py [p] [m1,m2,...]
"""
import itertools
import json
import os
import sys

import numpy as np

HERE = os.path.dirname(os.path.abspath(__file__))
EROOT = os.path.dirname(HERE)
PAIR = os.path.join(EROOT, "goal_runs_20260811", "PAIR_ATTACK_D35")
sys.path.insert(0, os.path.join(PAIR, "scripts"))
import paths  # noqa: E402
import slicelib as SL  # noqa: E402

RES = os.path.join(PAIR, "results")
DEG = 35


def cell37(p):
    NUL = np.load(os.path.join(RES, "layer0_null_p%d.npy" % p)) % p
    U6 = np.array(json.load(open(os.path.join(
        RES, "worked_example_p%d.json" % p)))["universal_matrix_6x39"],
        dtype=np.int64) % p
    K37 = SL.nullspace(U6 % p, p) % p
    assert K37.shape[0] == 37
    return (K37 @ NUL) % p                      # 37 x 637


def values_at(fr, A, C, W, p):
    """T_seed(x) for every seed and every sampled point: (nseeds, npts, 5)."""
    R = SL.jet_rows(fr, A, C, W, np.zeros_like(W), 1, deg=DEG)
    return R[:, :, :, 0] % p


def cubic_rows(V, basis, p):
    """Coefficient rows of F(T_{c(t)}(x)) as cubic forms in t.

    V: (nseeds, npts, 5) seed values; basis: (m, nseeds).
    Returns (npts, C(m+2,3)) matrix of coefficients mod p.
    """
    m = basis.shape[0]
    # v[i, q, c] = value of basis covariant i at point q, component c
    v = np.tensordot(basis % p, V % p, axes=(1, 0)) % p       # (m, npts, 5)
    npts = v.shape[1]
    mons = [t for t in itertools.combinations_with_replacement(range(m), 3)]
    idx = {t: n for n, t in enumerate(mons)}
    out = np.zeros((npts, len(mons)), dtype=np.int64)
    for k in range(5):
        Ak = v[:, :, k] % p                    # (m, npts)   coefficient of y_k
        Bk = v[:, :, (k + 1) % 5] % p          # (m, npts)   coefficient of y_{k+1}
        # contribution sum_{i,j,l} t_i t_j t_l A[i]A[j]B[l]
        for i in range(m):
            Ai = Ak[i]
            for j in range(i, m):
                base = (Ai * Ak[j]) % p
                mult = 1 if i == j else 2      # symmetry of the two A-slots
                for l in range(m):
                    trip = tuple(sorted((i, j, l)))
                    out[:, idx[trip]] = (out[:, idx[trip]]
                                         + mult * base * Bk[l]) % p
    return out % p


def main(p=331, ms=(8, 12, 16, 20)):
    print("== section deficiency probe, p =", p)
    fr = SL.build_frame(p, verbose=False)
    A = np.load(os.path.join(RES, "layer0_A_p331.npy"))
    C = np.load(os.path.join(RES, "layer0_C_p331.npy"))
    CELL = cell37(p)
    rng = np.random.default_rng(20260812)
    out = {"p": p, "P3_global": 1380, "sections": []}

    for m in ms:
        nmon = len(list(itertools.combinations_with_replacement(range(m), 3)))
        npts = int(nmon * 1.4) + 40
        W = rng.integers(1, p, size=(npts, 5)) % p
        V = values_at(fr, A, C, W, p)                      # (637, npts, 5)
        S = rng.integers(0, p, size=(m, 37)) % p           # random section
        basis = (S @ CELL) % p                             # (m, 637)
        M = cubic_rows(V, basis, p)
        r = SL.rref_rank(M % p, p)
        defc = nmon - r
        gen = min(1380, nmon)
        print("  m=%2d  dim Sym^3 = %5d  rank = %5d  HF_L(3) = %5d"
              "   (generic 1380-dim space would give rank %d)"
              % (m, nmon, r, defc, gen))
        out["sections"].append({"m": m, "dim_sym3": nmon, "rank": int(r),
                                "HF_L3": int(defc), "generic_rank": gen,
                                "npts": npts})

    print("\nreading: rank < min(1380, dim Sym^3) is a structural deficiency")
    with open(os.path.join(HERE, "section_deficiency_p%d.json" % p), "w") as f:
        json.dump(out, f, indent=1)
    return out


if __name__ == "__main__":
    p = int(sys.argv[1]) if len(sys.argv) > 1 else 331
    ms = tuple(int(x) for x in sys.argv[2].split(",")) if len(sys.argv) > 2 \
        else (8, 12, 16, 20)
    main(p, ms)
