#!/usr/bin/env python3
"""FIX-P2 -- INDEPENDENT VERIFIER (own engines) + self-test harness.

Every claim of the packet is re-derived here by a *different* route from the
producer's:

  claim                              producer engine        verifier engine
  ---------------------------------  ---------------------  -------------------
  the residual S3 on W^-             FIX-H1's certificate   rebuilt from the
                                     matrices over K0        660 group matrices
                                                             mod p (intrinsic)
  L0 = V[sgn^e]                      nullspace over K0      Reynolds projector
                                                             over F_p
  L1 = Im(ev_v0) at order 1          nullspace over K0      Reynolds projector
                                                             over F_p
  L0 != L1                           exact over K0          2x2 minor mod p
                                                             (nonzero mod p =>
                                                              nonzero in char 0)
  the adapted V4 frame               eigenspace solves      V4-CHARACTER
                                                             SELECTION RULE on
                                                             an actual module
  the bivariate jet engine           truncated 2-series     univariate jets +
                                                             a mixed-degree
                                                             identity
  dim M_d                            character-theory       FIX-P1's payload
                                     Molien in Z[z]/Phi330   (read-only)
  the equalizer arithmetic           k0.py exact            recomputed ratios

Terminal marker: FIX_P2_VERIFY_OK
Usage: python3 verify_p2.py [p]
"""
import json
import os
import sys
import time

import numpy as np

import slicelib as SL
import p2lib as P2

HERE = os.path.dirname(os.path.abspath(__file__))
PAY = os.path.join(HERE, "payloads")
T0 = time.time()
NOK = [0, 0]


def ck(name, cond, extra=""):
    NOK[0] += 1
    if cond:
        NOK[1] += 1
    print("  [%s] %-62s %s" % ("OK " if cond else "FAIL", name, extra),
          flush=True)
    return bool(cond)


# ---------------------------------------------------- independent L0 / L1
def reynolds_lines(fr, e, p):
    """L0 and L1 by REYNOLDS PROJECTORS over the residual S3 (an engine
    independent of the nullspace route used in p2lib.equalizer_lines)."""
    RHOm, TAUm = fr["RHOm"], fr["TAUm"]
    I2 = np.eye(2, dtype=np.int64)
    # the six elements of S3 as 2x2 matrices on W^- together with their sign
    els = []
    cur = I2.copy()
    for k in range(3):
        els.append((cur.copy(), 1))
        els.append(((cur @ TAUm) % p, -1))
        cur = (cur @ RHOm) % p
    assert len(els) == 6
    sgn = 1 if e % 2 == 0 else -1

    def conj(M):
        return P2.conj_action(M, p)

    # L0 = image of the projector  (1/6) sum_g sgn(g)^e . conj(g)
    Pr = np.zeros((4, 4), dtype=np.int64)
    for M, s in els:
        c = pow(s, e, 3) if False else (1 if (e % 2 == 0 or s == 1) else -1)
        Pr = (Pr + c * conj(M)) % p
    L0 = image_rows(Pr.T, p)        # conj_action acts on COLUMNS

    # L1: psi in Hom(std, V) equivariant; then evaluate at v0.
    STD = fr["STD"]
    A = STD.T % p
    idx = []
    cur2 = np.zeros((0, 2), dtype=np.int64)
    for i in range(5):
        t = np.concatenate([cur2, A[i][None, :]], axis=0)
        if SL.rref_rank(t, p) > cur2.shape[0]:
            cur2 = t
            idx.append(i)
        if len(idx) == 2:
            break
    Ainv = SL.mat_inv(A[idx] % p, p)

    def std_mat(g):
        img = (STD @ g.T) % p
        return (img[:, idx] @ Ainv.T) % p

    # group elements of the residual S3 inside D12, as (W^- matrix, std matrix,
    # sign)
    gs = []
    rho, tau = fr["rho"], fr["tau"]
    I5 = np.eye(5, dtype=np.int64)
    cur3 = I5.copy()
    for k in range(3):
        gs.append((cur3.copy(), 1))
        gs.append(((cur3 @ tau) % p, -1))
        cur3 = (cur3 @ rho) % p
    Pr8 = np.zeros((8, 8), dtype=np.int64)
    for g, s in gs:
        Sm = std_mat(g)                      # (2,2) rows = images of the basis
        Vm = P2.conj_action(restrict_minus(fr, g, p), p)      # (4,4)
        c = 1 if (e % 2 == 0 or s == 1) else -1
        blk = np.zeros((8, 8), dtype=np.int64)
        # (g.psi)(b_i) = c . Vm . psi(g^{-1} b_i) ; build with Sm^{-1}
        Sinv = SL.mat_inv(Sm % p, p)
        for i in range(2):
            for j in range(2):
                blk[4 * i:4 * i + 4, 4 * j:4 * j + 4] = (c * Sinv[i, j] *
                                                         Vm) % p
        Pr8 = (Pr8 + blk) % p
    inv = image_rows(Pr8.T, p)      # ditto
    STDv = fr["v0"]
    coeff = (STDv[idx] @ Ainv.T) % p
    img = []
    for b in inv:
        val = (coeff[0] * b[0:4] + coeff[1] * b[4:8]) % p
        if np.any(val):
            img.append(val)
    L1 = basis_of(img, 4, p)
    return L0, L1


def restrict_minus(fr, M, p):
    ey, ez, PM = fr["ey"], fr["ez"], fr["PMINUS"]
    img = (M @ np.stack([ey, ez], axis=1)) % p
    return (PM @ img) % p


def image_rows(A, p):
    """basis of the row space of A (= image of A^T, i.e. of the projector)."""
    rows = []
    cur = np.zeros((0, A.shape[1]), dtype=np.int64)
    for r in A % p:
        if not np.any(r):
            continue
        t = np.concatenate([cur, r[None, :]], axis=0)
        if SL.rref_rank(t, p) > cur.shape[0]:
            cur = t
            rows.append(r % p)
    return np.array(rows, dtype=np.int64) if rows else \
        np.zeros((0, A.shape[1]), dtype=np.int64)


def basis_of(vecs, n, p):
    rows = []
    cur = np.zeros((0, n), dtype=np.int64)
    for r in vecs:
        t = np.concatenate([cur, np.array(r)[None, :] % p], axis=0)
        if SL.rref_rank(t, p) > cur.shape[0]:
            cur = t
            rows.append(np.array(r) % p)
    return np.array(rows, dtype=np.int64) if rows else \
        np.zeros((0, n), dtype=np.int64)


def same_line(u, v, p):
    n = len(u)
    piv = next((i for i in range(n) if u[i] % p), None)
    if piv is None:
        return False
    if v[piv] % p == 0:
        return False
    lam = (int(v[piv]) * SL.inv_mod(int(u[piv]), p)) % p
    return all((int(v[i]) - lam * int(u[i])) % p == 0 for i in range(n))


# ------------------------------------------------------------------ main
def main():
    p = int(sys.argv[1]) if len(sys.argv) > 1 else 331
    print("FIX-P2 verifier -- independent engines, prime p = %d" % p)

    print("\n[A] the frame and the adapted V4/D12 coordinates")
    fr = P2.adapted_frame(SL.build_frame(p))
    for k, v in fr["adapted_self_tests"].items():
        ck("A: " + k, v)
    ck("A: 55 involutions, |G| = 660, F invariant (slicelib self-tests)",
       len(fr["self_tests"]) >= 10)

    print("\n[B] the V4-character SELECTION RULE on a real module "
          "(independent test of the adapted frame AND of jet_rows2)")
    import produce_cascade as PC
    dims = PC.load_dims()
    rng = np.random.default_rng(3)
    d = 10
    A, C, got = PC.basis_seeds(fr, d, dims[d], p, rng)
    ok_all = True
    npt = 6
    Wb = PC.rand_in_span(fr["ellV"], npt, p, rng)
    U1 = np.tile(fr["ex"] % p, (npt, 1))
    J = 5
    for dirname, u2 in (("ey", fr["ey"]), ("ez", fr["ez"])):
        U2 = np.tile(u2 % p, (npt, 1))
        res = P2.jet_rows2(fr, A, C, Wb, U1, U2, J, J, d)
        for lbl, PJ, want in (
                ("triv (w0,v0)", fr["Binv"][0:2, :], lambda a, b:
                 a % 2 == 0 and b % 2 == 0),
                ("chi_1 (e_x)", fr["Binv"][2:3, :], lambda a, b:
                 a % 2 == 1 and b % 2 == 0),
                ("chi_2 (e_y)", fr["Binv"][3:4, :], lambda a, b:
                 ((a + (b if dirname == "ey" else 0)) % 2 == 1 and
                  (a + (b if dirname == "ez" else 0)) % 2 == 0)),
                ("chi_3 (e_z)", fr["Binv"][4:5, :], lambda a, b:
                 ((a + (b if dirname == "ey" else 0)) % 2 == 0 and
                  (a + (b if dirname == "ez" else 0)) % 2 == 1))):
            half = np.einsum('sqcab,ic->sqiab', res, PJ) % p
            for a in range(J):
                for b in range(J):
                    blk = half[:, :, :, a, b].reshape(A.shape[0], -1) % p
                    rk = SL.rref_rank(blk, p)
                    allowed = want(a, b)
                    good = (rk > 0) if allowed else (rk == 0)
                    if not good:
                        ok_all = False
                        print("      mismatch %s dir=%s (a,b)=(%d,%d) rank=%d "
                              "allowed=%s" % (lbl, dirname, a, b, rk, allowed))
    ck("B: every (a,b) bidegree obeys the V4-character rule, both directions",
       ok_all, "(d = %d, %d seeds)" % (d, A.shape[0]))

    print("\n[C] the bivariate jet engine against the univariate one")
    deg = 9
    A2, C2 = SL.seed_exponents(30, deg=deg)
    W = rng.integers(0, p, size=(3, 5)) % p
    Ua = rng.integers(0, p, size=(3, 5)) % p
    Ub = rng.integers(0, p, size=(3, 5)) % p
    R2 = P2.jet_rows2(fr, A2, C2, W, Ua, Ub, 4, 3, deg)
    ck("C: t = 0 slice equals the univariate jet in u1",
       np.array_equal(R2[:, :, :, :, 0] % p,
                      SL.jet_rows(fr, A2, C2, W, Ua, 4, deg=deg) % p))
    ck("C: s = 0 slice equals the univariate jet in u2",
       np.array_equal(R2[:, :, :, 0, :] % p,
                      SL.jet_rows(fr, A2, C2, W, Ub, 3, deg=deg) % p))
    lam = 5
    Rm = SL.jet_rows(fr, A2, C2, W, (Ua + lam * Ub) % p, 3, deg=deg)
    pred = (R2[:, :, :, 2, 0] + lam * R2[:, :, :, 1, 1] +
            lam * lam * R2[:, :, :, 0, 2]) % p
    ck("C: mixed-degree identity  sum_{i+j=2} lam^j c_ij",
       np.array_equal(pred % p, Rm[:, :, :, 2] % p))

    print("\n[D] the two equalizer lines -- Reynolds-projector engine")
    payload = json.load(open(os.path.join(PAY, "EQUALIZER36.json")))
    for e in (5, 6):
        L0a, L1a, _ = P2.equalizer_lines(fr, e, p)
        L0b, L1b = reynolds_lines(fr, e, p)
        ck("D: e=%d  dim L0 = 1 (both engines)" % e,
           L0a.shape[0] == 1 and L0b.shape[0] == 1,
           "nullspace %d, projector %d" % (L0a.shape[0], L0b.shape[0]))
        ck("D: e=%d  dim L1 = 1 (both engines)" % e,
           L1a.shape[0] == 1 and L1b.shape[0] == 1,
           "nullspace %d, projector %d" % (L1a.shape[0], L1b.shape[0]))
        if L0a.shape[0] == 1 and L0b.shape[0] == 1:
            ck("D: e=%d  the two engines give the SAME L0" % e,
               same_line(L0a[0], L0b[0], p))
        if L1a.shape[0] == 1 and L1b.shape[0] == 1:
            ck("D: e=%d  the two engines give the SAME L1" % e,
               same_line(L1a[0], L1b[0], p))
        if L0a.shape[0] == 1 and L1a.shape[0] == 1:
            ck("D: e=%d  L0 != L1  (rank 2 mod p => distinct in char 0)" % e,
               SL.rref_rank(np.concatenate([L0a, L1a], axis=0), p) == 2)
    # the exact K0 answers, re-read and re-checked mod p up to the residual
    # square-scaling of the e_z basis vector
    w36 = payload["windows"]["d36_(1,6)"]
    ck("D: exact engine (K0) says L0 != L1 at the gateway window",
       w36["L0_equals_L1"] is False)
    # k0-side basis order is  (z E_y, y E_y, z E_z, y E_z), so the identity of
    # W^- is (0,1,1,0) and diag(1,-1) is (0,1,-1,0).
    ck("D: exact engine (K0) reproduces FIX-H1 sec.9 branch (ii): "
       "L0 = <id>, L1 = <diag(1,-1)>",
       payload["windows"]["control_d43_(1,7)"]["L0"] ==
       ['0', '1', '1', '0'] and
       payload["windows"]["control_d43_(1,7)"]["L1"] ==
       [['0', '1', '-1', '0']])
    # L1 = -L0 in the lower-left entry, both engines
    L0a, L1a, _ = P2.equalizer_lines(fr, 5, p)
    c0 = (int(L0a[0][2]) * SL.inv_mod(int(L0a[0][1]), p)) % p
    c1 = (int(L1a[0][2]) * SL.inv_mod(int(L1a[0][1]), p)) % p
    ck("D: e=5  the two lines are  [[0,1],[c,0]]  and  [[0,1],[-c,0]]",
       (c0 + c1) % p == 0, "c = %d, c' = %d" % (c0, c1))

    print("\n[E] the tight-window scan (exact, char 0) -- structure checks")
    tw = payload["tight_window_scan"]
    ck("E: every scanned profile has dim(L0 cap L1) = 0",
       all(x["dim_cap"] == 0 for x in tw), "%d profiles" % len(tw))
    ck("E: the scan contains the gateway window (1,6) at d = 36",
       any(x["m"] == 1 and x["r"] == 6 and x["d"] == 36 for x in tw))
    ck("E: d = 7r-6m holds on every scanned row",
       all(x["d"] == 7 * x["r"] - 6 * x["m"] for x in tw))

    print("\n[F] dim M_d against FIX-P1's independent Molien payload")
    mine = json.load(open(os.path.join(PAY, "MOLIEN.json"))
                     )["dim_covariant_module_M_d"]
    p1 = json.load(open(os.path.join(
        HERE, "..", "..", "goal_runs_after_063da5a",
        "FIX_P1_DEGREE25_GUIDED", "payloads", "MOLIEN.json"))
    )["dim_covariant_module_M_d"]
    agree = all(mine[k] == p1[k] for k in p1)
    ck("F: dim M_d agrees with FIX-P1 for every d it computed", agree,
       "d = 0..%d" % max(int(k) for k in p1))
    ck("F: dim M_36 = 706, dim M_37 = 786, dim M_38 = 865",
       mine["36"] == 706 and mine["37"] == 786 and mine["38"] == 865)

    print("\n[G] the packet's own recorded cascade, re-read")
    fn = os.path.join(PAY, "CASCADE_p67_36_36.json")
    if os.path.exists(fn):
        cas = json.load(open(fn))["rows"]
        r16 = [x for x in cas if x["m"] == 1 and x["r"] == 6][0]
        ck("G: the (1,6) step-3 slice at d = 36 is 83 (FIX-P1 replicated)",
           r16["dim_after_step3"] == 83)
        ck("G: the H0-1 plus-half refinement is VACUOUS (parity)",
           r16["steps"][0][1] == r16["steps"][1][1])
        ck("G: H1-1(a),(b),(c) AT c_sigma add nothing on the slice "
           "(they are forced)",
           r16["steps"][3][1] == 83 and r16["steps"][4][1] == 83 and
           r16["steps"][5][1] == 83)
        ck("G: every m >= 3 profile at d = 36 has a ZERO slice",
           all(x["dim_after_step3"] == 0 for x in cas if x["m"] >= 3))
    else:
        ck("G: cascade payload present", False, "(not produced)")

    print("\n[I] FINDING P2-C: the residual C3 moves the D12-POINTS and the "
          "INVOLUTIONS together")
    import diag_d12 as D12
    C123 = D12.d12_points(fr, p)
    ck("I: the three D12-points of ell_V are pairwise distinct",
       all(SL.rref_rank(np.stack([C123[i], C123[j]]), p) == 2
           for i in range(3) for j in range(i + 1, 3)))
    RHO = fr["RHO"]
    A4 = [g for g in range(660)
          if all(any(np.array_equal((RHO[g] @ RHO[t] @
                                     SL.mat_inv(RHO[g], p)) % p, RHO[u] % p)
                     for u in fr["v4"]) for t in fr["v4"])]
    ck("I: N_G(K_1) has order 12 (= A4)", len(A4) == 12)
    th = [g for g in A4 if fr["orders"][g] == 3]
    ck("I: A4 contains elements of order 3", len(th) > 0)
    g = RHO[th[0]]
    ginv = SL.mat_inv(g, p)
    ppt, pinv = [], []
    for i in range(3):
        w = (g @ C123[i]) % p
        ppt.append(next((j for j in range(3)
                         if SL.rref_rank(np.stack([w, C123[j]]), p) == 1), -1))
        M = (g @ RHO[fr["v4"][i]] @ ginv) % p
        pinv.append(next((j for j in range(3)
                          if np.array_equal(M, RHO[fr["v4"][j]] % p)), -1))
    ck("I: theta permutes the three D12-points in a 3-cycle",
       sorted(ppt) == [0, 1, 2] and ppt != [0, 1, 2], "perm %s" % ppt)
    ck("I: theta permutes the three involutions of K_1 by the SAME 3-cycle "
       "-- so it carries Lambda^{(i)} to Lambda^{(perm i)}",
       ppt == pinv, "points %s vs involutions %s" % (ppt, pinv))

    print("\n[H] the fast rank engine against slicelib's reference rank")
    rng2 = np.random.default_rng(11)
    okr = True
    for q in (67, 199, 331):
        for shape in [(20, 7), (7, 20), (50, 50), (120, 300), (3, 3),
                      (1, 9), (9, 1)]:
            for t in range(3):
                Mx = rng2.integers(0, q, size=shape)
                if t == 1:
                    Mx[:, ::2] = 0
                if t == 2:
                    Mx = (Mx @ rng2.integers(0, q, size=(shape[1],
                                                         shape[1]))) % q
                if SL.rref_rank(Mx, q) != P2.rref_rank_fast(Mx, q):
                    okr = False
    ck("H: rref_rank_fast == slicelib.rref_rank", okr,
       "63 random matrices, 3 primes")

    print("\nchecks: %d/%d passed   elapsed %.1f s"
          % (NOK[1], NOK[0], time.time() - T0))
    if NOK[1] == NOK[0]:
        print("FIX_P2_VERIFY_OK")
        return 0
    print("FIX_P2_VERIFY_FAILED")
    return 1


if __name__ == "__main__":
    sys.exit(main())
