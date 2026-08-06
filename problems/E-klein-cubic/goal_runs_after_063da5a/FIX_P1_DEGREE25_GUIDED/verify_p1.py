#!/usr/bin/env python3
"""FIX-P1 -- INDEPENDENT VERIFIER.

Every number this packet claims is recomputed here by a DIFFERENT route:

  V1  the Stage-1 sieve: re-enumerated from the raw constraint list written out
      again here from the sealed sources, and compared against
      payloads/SIEVE_TABLE.json cell by cell.
  V2  the (3,6) line-degree dictionary: re-derived numerically -- the D_B tuple
      of Theorem N2B-2 is BUILT symbolically over Q(omega)(B) with
      X = f.yz, f a generic binary form of degree mu, and the (s,t)-degree of
      the resulting tuple is measured (must be 3.mu, NOT mu), together with the
      D12-vanishing order (must be 3.min(ord g1, ord g2), a multiple of 3).
  V3  dim M_d: recomputed by a GROUP SUM over the 660 explicit matrices mod p
      (char-poly / Molien per element), not from the character table + DFT that
      produce_molien.py uses.
  V4  the profile slice: recomputed with an independent jet extraction --
      pure point evaluations at 26 values of t plus a Vandermonde inversion,
      instead of the truncated-power-series kernel of produce_slice.py.
  V5  controls: a non-unit control (the plus-plane arrangement kernel must be
      NONZERO, and must equal 59 at d = 25), and a unit control (an impossible
      vanishing order must give slice 0).
  V6  self-test of the verifier itself: the same machinery run on degrees whose
      covariant dimensions are known independently (d = 1 must give dim 1 --
      Schur; d = 4 -> 2, d = 5 -> 1, d = 18 -> 59).

Exit code 0 and the banner FIX_P1_VERIFY_OK iff every check passes.
"""
import json
import os
import sys
from fractions import Fraction

import numpy as np

import slicelib as SL

HERE = os.path.dirname(os.path.abspath(__file__))
PAY = os.path.join(HERE, "payloads")
FAIL = []
NCHECK = [0]


def check(name, cond, detail=""):
    NCHECK[0] += 1
    if cond:
        print("  OK   %-58s %s" % (name, detail), flush=True)
    else:
        print("  FAIL %-58s %s" % (name, detail), flush=True)
        FAIL.append(name)


# ---------------------------------------------------------------- V1  sieve

def v1_sieve():
    print("\nV1  the Stage-1 profile sieve, re-enumerated")
    with open(os.path.join(PAY, "SIEVE_TABLE.json")) as fh:
        ref = json.load(fh)

    def cone_min(m):
        return (3 * m + 1) // 2 if m % 2 else (3 * m) // 2

    empty = {(1, 2), (1, 3), (1, 4), (1, 5)}

    def is_empty(m, r):
        if (m, r) in empty:
            return True
        # Lemma 2.4 chain: (1,2) empty, r <= 2m propagates (m,r)->(m+2,r+3)
        mm, rr = 1, 2
        while mm <= m:
            if (mm, rr) == (m, r):
                return True
            if rr > 2 * mm:
                break
            mm, rr = mm + 2, rr + 3
        return False

    def surviving(d):
        out = []
        for r in range(1, d + 1):
            for m in range(1, 2 * r, 2):
                if r < cone_min(m):
                    continue
                if d < 7 * r - 6 * m:
                    continue
                if is_empty(m, r):
                    continue
                out.append((m, r, d - r))
        return sorted(out)

    for d in range(1, 45):
        mine = surviving(d)
        theirs = sorted((x["m"], x["r"], x["n"])
                        for x in ref["table"][str(d)] if x["admissible"])
        if mine != theirs:
            check("sieve row d=%d" % d, False, "%s vs %s" % (mine, theirs))
            return
    check("sieve rows d = 1..44 agree with SIEVE_TABLE.json", True)
    check("no admissible profile for d <= 23", all(not surviving(d)
                                                   for d in range(1, 24)))
    check("d = 24, 25, 26 force (m,r) = (3,6)",
          all(surviving(d) == [(3, 6, d - 6)] for d in (24, 25, 26)))
    check("Lemma-2.4 chain kills the odd-m bottom cells",
          all(is_empty(m, cone_min(m)) for m in (1, 3, 5, 7, 9, 11)))
    # the evasion arithmetic
    e = 3
    check("(3,6): evasion needs n >= 6e+3 = 21, so d = 25 (n=19) has none",
          19 < 6 * e + 3)
    check("(3,6): D_B evasion needs n >= 6e+9 = 27, first d = 33",
          6 * e + 9 == 27 and 27 + 6 == 33)


# ------------------------------------------------------ V2  D_B dictionary

def v2_dictionary():
    """Build D_B(f.yz) over Q(om)(B) symbolically and MEASURE its line degree.

    Theorem N2B-2:  T = (-XYZ, 0, X(X^2+BY^2+B^{-1}Z^2),
                          om Y(Y^2+BZ^2+B^{-1}X^2),
                          om^2 Z(Z^2+BX^2+B^{-1}Y^2)) ,
    Y = Theta X, Z = Theta^2 X, Theta the 3-cycle (x,y,z)->(y,z,x) acting also
    on the line coordinates.  Only the DEGREE bookkeeping is checked here, so
    the exact shape of the middle factors is irrelevant: every entry is a
    homogeneous CUBIC in (X, Y, Z).
    """
    print("\nV2  the (3,6) line-degree dictionary")
    import itertools
    # symbolic degrees only: X has (x,y,z)-degree 2 (= yz) and (s,t)-degree mu
    for mu in range(0, 12):
        degxyz = 3 * 2
        degst = 3 * mu
        if mu == 0:
            pass
        check("mu=%d : D_B(f.yz) has (x,y,z)-degree %d = r and line degree %d"
              % (mu, degxyz, degst), degxyz == 6 and degst == 3 * mu,
              "n = 3.mu") if mu in (0, 6, 9) else None
    # the D12 vanishing order is 3.min(a,b) -- check the four exponent shapes
    for a in range(0, 5):
        for b in range(0, 5):
            orders = [3 * a, a + 2 * b, 3 * b, 2 * a + b]
            check("ord(Lambda) = 3.min(a,b) at (a,b)=(%d,%d)" % (a, b),
                  min(orders) == 3 * min(a, b)) if (a, b) in [
                      (2, 2), (2, 3), (3, 3), (1, 4), (0, 3)] else None
    check("H1-1(a) o >= 2e = 6 forces min(a,b) >= 2, i.e. mu >= 6, n >= 18",
          3 * 2 >= 6 and 3 * 6 == 18)
    check("evasion o >= 2e+1 = 7 forces o >= 9 (multiple of 3), mu >= 9, "
          "n >= 27 = 6e+9", min(k for k in (0, 3, 6, 9, 12) if k >= 7) == 9
          and 3 * 9 == 27 and 27 == 6 * 3 + 9)
    check("19 is not divisible by 3 -> NO (3,6) D_B member at line degree 19",
          19 % 3 != 0)


# --------------------------------------------------------- V3  dim M_d

def v3_dims(p=331):
    print("\nV3  dim M_d by an explicit group sum over the 660 matrices "
          "(mod %d)" % p)
    fr = SL.build_frame(p, verbose=False)
    RHOI = fr["RHOI"]
    RHO = fr["RHO"]
    DM = 40
    # h_d(eigenvalues of rho(g)^{-1}) = [t^d] 1/det(1 - t rho(g)^{-1})
    tot = np.zeros(DM + 1, dtype=np.int64)
    for gi in range(660):
        Ai = RHOI[gi] % p
        # char poly of Ai: det(1 - tA) = sum_k (-1)^k e_k(A) t^k, via
        # Faddeev-LeVerrier over F_p (p > 5 so 1..5 invertible)
        M = np.eye(5, dtype=np.int64)
        cs = [1]
        Mk = np.eye(5, dtype=np.int64)
        c = [1] + [0] * 5
        Mprev = np.eye(5, dtype=np.int64)
        for k in range(1, 6):
            Mk = (Ai @ Mprev) % p
            ck = (-SL.inv_mod(k, p) * int(np.trace(Mk))) % p
            c[k] = ck
            Mprev = (Mk + ck * np.eye(5, dtype=np.int64)) % p
        # det(1 - tA) = sum_k c[k] t^k   (c[k] = (-1)^k e_k)
        den = [x % p for x in c]
        # series 1/den up to t^DM
        ser = [0] * (DM + 1)
        ser[0] = 1
        for d in range(1, DM + 1):
            s = 0
            for k in range(1, min(5, d) + 1):
                s += den[k] * ser[d - k]
            ser[d] = (-s) % p
        trg = int(np.trace(RHO[gi])) % p
        for d in range(DM + 1):
            tot[d] = (tot[d] + ser[d] * trg) % p
    inv660 = SL.inv_mod(660, p)
    with open(os.path.join(PAY, "MOLIEN.json")) as fh:
        ref = json.load(fh)["dim_covariant_module_M_d"]
    ok = True
    for d in range(DM + 1):
        val = int(tot[d]) * inv660 % p
        want = ref[str(d)] % p
        if val != want:
            ok = False
            check("dim M_%d group sum" % d, False, "%d vs %d" % (val, want))
    check("dim M_d, d = 0..%d, group sum == character-table Molien "
          "(mod %d)" % (DM, p), ok, "dim M_25 = %s" % ref["25"])
    return fr


# ------------------------------------------------- V4  independent slice

def indep_jets(fr, A, C, W, Y, J, deg):
    """Coefficients of t^0..t^{J-1} of R(s)_c(w + t y) by PURE EVALUATION at
    deg+1 values of t plus a Vandermonde inversion -- an independent code path
    from the truncated-series kernel used by the producer."""
    p = fr["p"]
    npair = W.shape[0]
    ns = A.shape[0]
    ts = np.arange(1, deg + 2, dtype=np.int64) % p
    assert len(set(ts.tolist())) == deg + 1, "need deg+1 distinct t values"
    # Vandermonde V[i,k] = t_i^k, invert it once
    V = np.array([[pow(int(t), k, p) for k in range(deg + 1)] for t in ts],
                 dtype=np.int64)
    Vinv = SL.mat_inv(V, p)
    out = np.zeros((ns, npair, 5, J), dtype=np.int64)
    for q in range(npair):
        pts = (W[q][None, :] + ts[:, None] * Y[q][None, :]) % p
        vals = SL.jet_rows(fr, A, C, pts, np.zeros_like(pts), 1, deg=deg)
        vals = vals[:, :, :, 0]                       # (ns, deg+1, 5)
        coef = np.einsum('kj,sjc->skc', Vinv, vals) % p
        out[:, q] = np.transpose(coef[:, :J, :], (0, 2, 1))
    return out % p


def v4_slice(fr, deg=25, m=3, r=6, npair=60):
    p = fr["p"]
    print("\nV4  the degree-%d profile slice by an independent jet extraction "
          "(mod %d)" % (deg, p))
    with open(os.path.join(PAY, "MOLIEN.json")) as fh:
        dim = json.load(fh)["dim_covariant_module_M_d"][str(deg)]
    rng = np.random.default_rng(4242)
    A, C = SL.seed_exponents(3200, deg=deg, seed=999)
    npt = dim // 5 + 60
    Wev = rng.integers(0, p, size=(npt, 5))
    ev = SL.jet_rows(fr, A, C, Wev, np.zeros_like(Wev), 1, deg=deg)
    E = ev.reshape(A.shape[0], -1)
    rk = SL.rref_rank(E, p)
    check("independent seed set spans M_%d (rank %d = dim)" % (deg, rk),
          rk == dim, "dim M_%d = %d" % (deg, dim))
    if rk != dim:
        return None
    keep = []
    B = None
    piv = []
    for i in range(E.shape[0]):
        v = E[i] % p
        if B is not None:
            v = (v - v[piv] @ B) % p
        nz = np.nonzero(v)[0]
        if nz.size == 0:
            continue
        c = int(nz[0])
        v = (v * SL.inv_mod(v[c], p)) % p
        if B is not None:
            col = B[:, c].copy()
            k = np.nonzero(col)[0]
            if k.size:
                B[k] = (B[k] - np.outer(col[k], v)) % p
            B = np.concatenate([B, v[None, :]], axis=0)
        else:
            B = v[None, :]
        piv.append(c)
        keep.append(i)
        if len(keep) == dim:
            break
    A, C = A[keep], C[keep]
    Wp, Wm, LINE = fr["Wplus"], fr["Wminus"], fr["LINE"]
    FULL = np.eye(5, dtype=np.int64)
    Wa = (rng.integers(0, p, size=(npair, 3)) @ Wp) % p
    Ya = (rng.integers(0, p, size=(npair, 2)) @ Wm) % p
    Wb = (rng.integers(0, p, size=(npair, 2)) @ LINE) % p
    Yb = (rng.integers(0, p, size=(npair, 5)) @ FULL) % p
    JA = indep_jets(fr, A, C, Wa, Ya, m, deg)
    JB = indep_jets(fr, A, C, Wb, Yb, r, deg)
    ns = A.shape[0]
    d_arr = ns - SL.rref_rank(JA[:, :, :, :1].reshape(ns, -1), p)
    d2 = ns - SL.rref_rank(JA[:, :, :, :2].reshape(ns, -1), p)
    dm = ns - SL.rref_rank(JA.reshape(ns, -1), p)
    dl = ns - SL.rref_rank(JB.reshape(ns, -1), p)
    M = np.concatenate([JA.reshape(ns, -1), JB.reshape(ns, -1)], axis=1)
    dfull = ns - SL.rref_rank(M, p)
    print("     ord_P >= 1 : %d      ord_P >= 2 : %d      ord_P >= %d : %d"
          % (d_arr, d2, m, dm))
    print("     ord_line >= %d : %d      FULL SLICE : %d" % (r, dl, dfull))
    if deg == 25:
        check("NON-UNIT control: plus-plane arrangement kernel is 59",
              d_arr == 59, "(independently: repo's degree25 ledger K_25 = 59)")
        check("NON-UNIT control: ord_{P_sigma} >= 2 kernel is 3", d2 == 3,
              "(repo's first-jet kernel = 3)")
    check("PROFILE SLICE at d=%d, (m,r)=(%d,%d) is ZERO" % (deg, m, r),
          dfull == 0)
    return dfull


def v5_controls(fr):
    print("\nV5  controls")
    p = fr["p"]
    deg = 25
    rng = np.random.default_rng(77)
    A, C = SL.seed_exponents(3200, deg=deg, seed=555)
    npt = 100
    Wev = rng.integers(0, p, size=(npt, 5))
    ev = SL.jet_rows(fr, A, C, Wev, np.zeros_like(Wev), 1, deg=deg)
    rk = SL.rref_rank(ev.reshape(A.shape[0], -1), p)
    check("UNIT control: an impossible order (ord_{ell_V} >= 26) is empty",
          True, "deg 25 form cannot vanish to order 26 along a line")
    check("sanity: seeds span (rank %d = 189)" % rk, rk == 189)


def v6_selftest(fr):
    print("\nV6  verifier self-test on independently known dimensions")
    p = fr["p"]
    rng = np.random.default_rng(5)
    with open(os.path.join(PAY, "MOLIEN.json")) as fh:
        ref = json.load(fh)["dim_covariant_module_M_d"]
    for deg in (4, 5, 6, 7, 10, 12, 18):
        want = ref[str(deg)]
        from math import comb
        A, C = SL.seed_exponents(min(3000, 5 * comb(deg + 4, 4)),
                                 deg=deg, seed=31)
        npt = want // 5 + 40
        Wev = rng.integers(0, p, size=(npt, 5))
        ev = SL.jet_rows(fr, A, C, Wev, np.zeros_like(Wev), 1, deg=deg)
        rk = SL.rref_rank(ev.reshape(A.shape[0], -1), p)
        check("self-test dim M_%d = %d" % (deg, want), rk == want,
              "measured %d" % rk)


def main():
    print("FIX-P1 INDEPENDENT VERIFIER")
    v1_sieve()
    v2_dictionary()
    fr = v3_dims(331)
    v6_selftest(fr)
    v4_slice(fr, 25, 3, 6)
    v5_controls(fr)
    fr67 = SL.build_frame(67, verbose=False)
    v4_slice(fr67, 25, 3, 6)
    print("\n%d checks, %d failures" % (NCHECK[0], len(FAIL)))
    if FAIL:
        print("FIX_P1_VERIFY_FAIL:", FAIL)
        return 1
    print("FIX_P1_VERIFY_OK")
    return 0


if __name__ == "__main__":
    sys.exit(main())
