#!/usr/bin/env python3
"""Director probe (2026-08-12): generic Jacobian rank on the d=35 37-cell.

Dominance onto the 3-fold X requires the 5x5 Jacobian of T (on the affine
cone) to have rank 4 at a general point.  Question: what rank do generic
members of the sealed cell actually have?

  rank 5 generically -> det J is a NONTRIVIAL closed condition on the cell
                        (new degree-5 equations in the 37 parameters).
  rank 4 generically -> det J = 0 already forced; the open condition
                        (some 4x4 minor nonzero) is satisfied generically.
  rank <= 3 generically -> NO member of the cell is dominant onto a
                        3-fold: d = 35 would die without the cubic at all.

Controls: (a) Euler relation J(w).w = d*T(w) must hold exactly;
(b) a random covariant from the FULL 637-dim space (not in the cell)
    gives the ambient generic rank for comparison.

Usage: python3 jacobian_rank_probe.py [p] [ntrials]
"""
import json
import os
import sys

import numpy as np

HERE = os.path.dirname(os.path.abspath(__file__))
EROOT = os.path.dirname(HERE)
PAIR = os.path.join(EROOT, "goal_runs_20260811", "PAIR_ATTACK_D35")
sys.path.insert(0, os.path.join(PAIR, "scripts"))
import paths  # noqa: E402  (installs the D34 engine on sys.path)
import slicelib as SL  # noqa: E402

RES = os.path.join(PAIR, "results")
DEG = 35


def rank_mod(M, p):
    return SL.rref_rank(np.array(M, dtype=np.int64) % p, p)


def jacobian_at(fr, A, C, vec, w, p):
    """5x5 Jacobian J[c][j] = d(T_c)/dx_j (w) for the covariant `vec`."""
    ns = A.shape[0]
    J = np.zeros((5, 5), dtype=np.int64)
    W = np.array([w], dtype=np.int64) % p
    for j in range(5):
        Y = np.zeros((1, 5), dtype=np.int64)
        Y[0, j] = 1
        R = SL.jet_rows(fr, A, C, W, Y, 2, deg=DEG)      # (ns,1,5,2)
        d1 = R[:, 0, :, 1] % p                            # (ns,5)
        J[:, j] = (vec @ d1) % p
    return J % p


def value_at(fr, A, C, vec, w, p):
    W = np.array([w], dtype=np.int64) % p
    R = SL.jet_rows(fr, A, C, W, np.zeros_like(W), 1, deg=DEG)
    return (vec @ R[:, 0, :, 0]) % p


def main(p=331, ntrials=3):
    print("== Jacobian rank probe, p =", p)
    fr = SL.build_frame(p, verbose=False)
    A = np.load(os.path.join(RES, "layer0_A_p331.npy"))
    C = np.load(os.path.join(RES, "layer0_C_p331.npy"))
    NUL = np.load(os.path.join(RES, "layer0_null_p%d.npy" % p)) % p   # 39x637
    U6 = np.array(json.load(open(os.path.join(
        RES, "worked_example_p%d.json" % p)))["universal_matrix_6x39"],
        dtype=np.int64) % p                                          # 6x39
    assert NUL.shape == (39, 637) and U6.shape == (6, 39)

    # the 37-cell inside the 39-slice: kernel of the six flip functionals
    K37 = SL.nullspace(U6 % p, p) % p                                # 37x39
    print("cell37 dim:", K37.shape[0], "(expect 37)")
    assert K37.shape[0] == 37
    CELL = (K37 @ NUL) % p                                           # 37x637

    rng = np.random.default_rng(20260812)
    results = {"p": p, "cell_ranks": [], "ambient_ranks": [], "euler_ok": []}

    for t in range(ntrials):
        c = rng.integers(1, p, size=37) % p
        vec = (c @ CELL) % p
        w = rng.integers(1, p, size=5) % p
        J = jacobian_at(fr, A, C, vec, w, p)
        r = rank_mod(J, p)
        # Euler control: J(w).w == d*T(w)
        lhs = (J @ w) % p
        rhs = (DEG * value_at(fr, A, C, vec, w, p)) % p
        ok = bool(np.array_equal(lhs, rhs))
        results["cell_ranks"].append(int(r))
        results["euler_ok"].append(ok)
        print("  cell trial %d: rank(J) = %d   Euler %s" % (t, r, "OK" if ok else "FAIL"))
        assert ok, "Euler relation failed -- derivative extraction is wrong"

    for t in range(ntrials):
        vec = rng.integers(0, p, size=637) % p     # ambient covariant
        w = rng.integers(1, p, size=5) % p
        J = jacobian_at(fr, A, C, vec, w, p)
        r = rank_mod(J, p)
        results["ambient_ranks"].append(int(r))
        print("  ambient control trial %d: rank(J) = %d" % (t, r))

    cr = set(results["cell_ranks"])
    print("\nCELL generic rank(s):", sorted(cr))
    print("AMBIENT generic rank(s):", sorted(set(results["ambient_ranks"])))
    if max(cr) <= 3:
        print("VERDICT: rank <= 3 on the cell -> NO member is dominant onto a"
              " 3-fold (would exclude d = 35 outright) -- FLAG, audit needed")
    elif max(cr) == 4:
        print("VERDICT: rank 4 -- det J = 0 already forced on the cell;"
              " the dominance-open condition is generically satisfied")
    else:
        print("VERDICT: rank 5 -- det J = 0 is a NONTRIVIAL new closed"
              " condition on the 37 parameters (degree-5 equations)")
    with open(os.path.join(HERE, "jacobian_rank_probe_p%d.json" % p), "w") as f:
        json.dump(results, f, indent=1)
    return results


if __name__ == "__main__":
    main(int(sys.argv[1]) if len(sys.argv) > 1 else 331,
         int(sys.argv[2]) if len(sys.argv) > 2 else 3)
