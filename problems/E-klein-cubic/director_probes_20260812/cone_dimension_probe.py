#!/usr/bin/env python3
"""Director probe (2026-08-12): dimension of the landing cone at d = 35.

The landing locus V = {c in the 37-cell : F(T_c(x)) = 0 for all x} is a
CONE.  Two facts make this cheap where the sealed attempt was expensive:

  * a SUBSET of the landing cubics suffices: V(subset) contains V, so
    V(subset) = {0} proves V = {0}.  The sealed msolve attempt used 520
    generators (70 MB input) and walled; a few dozen is a different
    computation.
  * restricting to a generic m-dimensional section L bounds the cone:
    for a cone of dimension k, V ∩ L = {0} iff k <= 37 - m.  So each
    section that comes back trivial is a theorem "dim V <= 37 - m".

Each sample point x gives ONE cubic in the section parameters, via
F = sum_k y_k^2 y_{k+1} applied to T_{c(t)}(x) = sum_i t_i v_i(x).

Emits Macaulay2 input and runs it for the Krull dimension of the
quotient (0 means the only solution is the origin, the cone being
homogeneous).

Usage: python3 cone_dimension_probe.py [p] [m] [ncubics]
"""
import itertools
import json
import os
import subprocess
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
    return (K37 @ NUL) % p


def restricted_cubics(fr, A, C, basis, npts, p, seed=20260812):
    """npts cubic forms in the section parameters, one per sample point."""
    rng = np.random.default_rng(seed)
    W = rng.integers(1, p, size=(npts, 5)) % p
    V = SL.jet_rows(fr, A, C, W, np.zeros_like(W), 1, deg=DEG)[:, :, :, 0] % p
    v = np.tensordot(basis % p, V % p, axes=(1, 0)) % p        # (m, npts, 5)
    m = basis.shape[0]
    mons = list(itertools.combinations_with_replacement(range(m), 3))
    idx = {t: n for n, t in enumerate(mons)}
    out = np.zeros((npts, len(mons)), dtype=np.int64)
    for k in range(5):
        Ak = v[:, :, k] % p
        Bk = v[:, :, (k + 1) % 5] % p
        for i in range(m):
            for j in range(i, m):
                base = (Ak[i] * Ak[j]) % p
                mult = 1 if i == j else 2
                for l in range(m):
                    t = tuple(sorted((i, j, l)))
                    out[:, idx[t]] = (out[:, idx[t]] + mult * base * Bk[l]) % p
    return out % p, mons


def write_m2(path, rows, mons, m, p):
    terms_all = []
    for r in rows:
        terms = []
        for n, cf in enumerate(r):
            if cf % p:
                a, b, c = mons[n]
                cnt = {}
                for i in (a, b, c):
                    cnt[i] = cnt.get(i, 0) + 1
                mon = "*".join("t_%d^%d" % (i + 1, e) if e > 1 else "t_%d" % (i + 1)
                               for i, e in sorted(cnt.items()))
                terms.append("%d*%s" % (int(cf) % p, mon))
        if terms:
            terms_all.append(" + ".join(terms))
    with open(path, "w") as f:
        f.write("R = ZZ/%d[t_1..t_%d];\n" % (p, m))
        f.write("I = ideal(\n  " + ",\n  ".join(terms_all) + "\n);\n")
        f.write('print("NGENS " | toString(numgens I));\n')
        f.write('print("DIM " | toString(dim I));\n')
        f.write('print("DEGREE " | toString(degree I));\n')
        f.write("exit 0\n")
    return len(terms_all)


def main(p=331, m=20, ncub=None):
    ncub = ncub or (m + 15)
    print("== cone dimension probe, p = %d, section dim m = %d, %d cubics"
          % (p, m, ncub))
    fr = SL.build_frame(p, verbose=False)
    A = np.load(os.path.join(RES, "layer0_A_p331.npy"))
    C = np.load(os.path.join(RES, "layer0_C_p331.npy"))
    CELL = cell37(p)
    rng = np.random.default_rng(777 + m)
    if m == 37:
        basis = CELL
    else:
        S = rng.integers(0, p, size=(m, 37)) % p
        basis = (S @ CELL) % p
    rows, mons = restricted_cubics(fr, A, C, basis, ncub, p)
    r = SL.rref_rank(rows % p, p)
    print("   independent cubics among the %d sampled: %d" % (ncub, r))
    m2file = os.path.join(HERE, "cone_m%d_p%d.m2" % (m, p))
    n = write_m2(m2file, rows, mons, m, p)
    print("   wrote %s (%d generators)" % (os.path.basename(m2file), n))
    try:
        out = subprocess.run(["M2", "--script", m2file], capture_output=True,
                             text=True, timeout=1800)
        txt = (out.stdout or "") + (out.stderr or "")
        print("   M2:", " | ".join(l for l in txt.splitlines()
                                   if l.startswith(("NGENS", "DIM", "DEGREE"))))
        dim = None
        for l in txt.splitlines():
            if l.startswith("DIM "):
                dim = int(l.split()[1])
        if dim == 0:
            print("   => V ∩ L = {0}:  landing cone has dim <= %d" % (37 - m))
        elif dim is not None:
            print("   => V ∩ L has dim %d: landing cone has dim >= %d"
                  % (dim, dim + 37 - m))
        return dim
    except subprocess.TimeoutExpired:
        print("   M2 TIMEOUT (30 min) — no verdict at this m")
        return None


if __name__ == "__main__":
    main(int(sys.argv[1]) if len(sys.argv) > 1 else 331,
         int(sys.argv[2]) if len(sys.argv) > 2 else 20,
         int(sys.argv[3]) if len(sys.argv) > 3 else None)
