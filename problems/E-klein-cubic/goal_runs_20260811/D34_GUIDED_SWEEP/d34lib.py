#!/usr/bin/env python3
"""D34_GUIDED_SWEEP -- the STAGE-2 structural condition blocks at d = 34.

`slicelib.py` and `p2lib.py` are copied verbatim from FIX-P2 (the modular Weil
frame, the univariate/bivariate jet engines, the adapted V4/D12 frame).  This
module adds the frame data and the linear-functional blocks for the conditions
that STAGE2_ODD_ORDER_PINNING forces at d = 34 and that the FIX-P2 sweep did
NOT impose:

    (M)  d = 34 is EVEN  =>  T|_{L_sigma} = 0 on all 55 minus-lines
         (STAGE2 Prop. 1.4(i); ord_{L_sigma}(T) = d+1 = 1 mod 2, so odd)
    (E)  34 = 1 (mod 3)  =>  T contracts each C3-eigenline ell_w to the SINGLE
         X^{C6}-point lying ON ell_w  (STAGE2 Prop. 1.6).  As a linear
         condition:  ann(p_w) . T(v) = 0  for every v in ell_w.
    (C6) 34 = 4 (mod 6)  =>  both X^{C6} points lie in Bs(T)
         (STAGE2 Cor. 1.5) -- implied by (M) since X^{C6} is contained in L_t.
    (D10) the 66 D10-points lie in Bs(T) for every d   (STAGE2 B(D10))
    (D12) the 55 D12-points lie in Bs(T) for every d   (STAGE2 B(D12))
          -- implied by the plus-plane condition since c_sigma is in P_sigma.

By G-equivariance of the Reynolds averages it suffices to impose each
condition at ONE representative of its G-orbit; that is the same reduction
FIX-P1/FIX-P2 use for the plus-plane and the V4-line.

Sampling only a SUBSET of the functionals of a vanishing condition can only
ENLARGE the computed kernel, and rank mod p <= rank over Q, so a computed
dimension of 0 is a characteristic-zero emptiness verdict, while a nonzero
computed dimension is an UPPER BOUND on the char-0 dimension.  (slicelib.__doc__)
"""
import numpy as np

import slicelib as SL


def klein_F(v, p):
    return sum(int(v[i]) ** 2 * int(v[(i + 1) % 5]) for i in range(5)) % p


def stage2_frame(fr, verbose=True):
    """Add: the order-6 element, its weight decomposition, the two X^{C6}
    points, a C3-eigenline with its C6-point, and a D10-point."""
    p = fr["p"]
    RHO = fr["RHO"]
    I5 = np.eye(5, dtype=np.int64)
    tests = {}

    z6 = None
    for a in range(2, p):
        c = pow(a, (p - 1) // 6, p)
        if c != 1 and pow(c, 2, p) != 1 and pow(c, 3, p) != 1:
            z6 = c
            break
    assert z6 is not None and pow(z6, 6, p) == 1

    t6 = [g for g in range(660) if fr["orders"][g] == 6][0]
    T6 = RHO[t6] % p
    eig = {}
    for a in range(6):
        ns = SL.nullspace((T6 - pow(z6, a, p) * I5) % p, p)
        if ns.shape[0]:
            eig[a] = ns % p
    tests["C6 weights on W are {0,1,2,4,5}"] = sorted(eig) == [0, 1, 2, 4, 5]
    tests["C6 weight spaces are lines"] = all(eig[a].shape[0] == 1
                                              for a in eig)
    onX = sorted(a for a in eig if klein_F(eig[a][0], p) == 0)
    tests["X^{C6} = weights {1,5}"] = onX == [1, 5]

    # rho = t6^2 (order 3); its eigenline of rho-weight w = 1 is <v_1, v_4>
    # (t6-weights a and a+3 have the same rho-weight a mod 3).
    ELL1 = np.concatenate([eig[1], eig[4]], axis=0) % p
    PW1 = eig[1][0] % p                        # the X^{C6}-point on ELL1
    ELL2 = np.concatenate([eig[2], eig[5]], axis=0) % p
    PW2 = eig[5][0] % p
    rho3 = (T6 @ T6) % p
    tests["ELL1 is a rho-eigenline"] = SL.rref_rank(
        np.concatenate([ELL1, (ELL1 @ rho3.T) % p], axis=0), p) == 2
    tests["p_w1 lies on ELL1"] = SL.rref_rank(
        np.concatenate([ELL1, PW1[None, :]], axis=0), p) == 2
    # Stab_G(ELL1) must be C6 (order 6)
    stab = [g for g in range(660)
            if SL.rref_rank(np.concatenate([ELL1, (ELL1 @ RHO[g].T) % p],
                                           axis=0), p) == 2]
    tests["|Stab_G(ell_w)| = 6"] = len(stab) == 6

    # annihilator of p_w1 inside W* (4 rows)
    ANN1 = SL.nullspace(PW1[None, :] % p, p)
    tests["dim ann(p_w) = 4"] = ANN1.shape[0] == 4
    # annihilator of the WHOLE rho-eigenline's ambient weight space:
    # Lemma 1.1 already forces T(ell_1) in W_1(rho) = ELL1, so applying
    # functionals that annihilate ELL1 must give ZERO on all of M_34.
    ANN_ELL1 = SL.nullspace(ELL1 % p, p)
    tests["dim ann(W_w) = 3"] = ANN_ELL1.shape[0] == 3

    # a D10-point: the C5-fixed vector (weight 0), off X
    g5 = [g for g in range(660) if fr["orders"][g] == 5][0]
    q = SL.nullspace((RHO[g5] - I5) % p, p)
    tests["dim W^{C5} = 1"] = q.shape[0] == 1
    tests["D10-point is off X"] = klein_F(q[0], p) % p != 0
    stab10 = [g for g in range(660)
              if SL.rref_rank(np.concatenate([q, (q @ RHO[g].T) % p],
                                             axis=0), p) == 1]
    tests["|Stab_G(D10-point)| = 10"] = len(stab10) == 10

    out = dict(fr)
    out.update({"t6_index": t6, "C6_eig": eig, "C6_onX": onX,
                "ELL1": ELL1, "PW1": PW1, "ELL2": ELL2, "PW2": PW2,
                "ANN_PW1": ANN1, "ANN_ELL1": ANN_ELL1,
                "D10pt": q[0] % p, "stab_ellw": stab, "stab_D10": stab10,
                "stage2_self_tests": tests})
    if verbose:
        bad = [k for k, v in tests.items() if not v]
        print("[stage2] p=%d  X^{C6} weights=%s  self-tests %s"
              % (p, onX, "ALL OK" if not bad else "FAILED: %s" % bad))
    assert all(tests.values()), [k for k, v in tests.items() if not v]
    return out


def rand_in_span(rows, k, p, rng):
    co = rng.integers(0, p, size=(k, rows.shape[0]))
    return (co @ rows) % p


# --------------------------------------------------------------- the blocks
def minus_line_block(fr, A, C, deg, npt, p, rng):
    """(M)  T(v) = 0 for v in W^-_sigma  --  the 55 minus-lines."""
    ns = A.shape[0]
    Wb = rand_in_span(fr["Wminus"], npt, p, rng)
    Yb = np.zeros_like(Wb)
    J = SL.jet_rows(fr, A, C, Wb, Yb, 1, deg=deg)          # (ns,npt,5,1)
    return J.reshape(ns, -1) % p


def eigenline_block(fr, A, C, deg, npt, p, rng, which=1):
    """(E)  ann(p_w) . T(v) = 0 for v in ell_w  --  the 110 C3-eigenlines.

    Returns (block, control) where `control` holds the functionals that
    annihilate the whole weight space W_w: those must ALREADY vanish on M_deg
    by Lemma 1.1, and the caller checks that they add no rank."""
    ns = A.shape[0]
    ELL = fr["ELL1"] if which == 1 else fr["ELL2"]
    ANN = fr["ANN_PW1"] if which == 1 else SL.nullspace(
        fr["PW2"][None, :] % p, p)
    ANNE = fr["ANN_ELL1"] if which == 1 else SL.nullspace(fr["ELL2"] % p, p)
    Wb = rand_in_span(ELL, npt, p, rng)
    Yb = np.zeros_like(Wb)
    J = SL.jet_rows(fr, A, C, Wb, Yb, 1, deg=deg)[:, :, :, 0]   # (ns,npt,5)
    blk = np.einsum('sqc,kc->sqk', J, ANN).reshape(ns, -1) % p
    ctl = np.einsum('sqc,kc->sqk', J, ANNE).reshape(ns, -1) % p
    return blk, ctl


def point_block(fr, A, C, deg, pts, p):
    """T(v) = 0 at each listed point."""
    ns = A.shape[0]
    Wb = np.array(pts, dtype=np.int64) % p
    Yb = np.zeros_like(Wb)
    J = SL.jet_rows(fr, A, C, Wb, Yb, 1, deg=deg)
    return J.reshape(ns, -1) % p
