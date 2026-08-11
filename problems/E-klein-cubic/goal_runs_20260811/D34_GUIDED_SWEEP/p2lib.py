#!/usr/bin/env python3
"""FIX-P2 -- the ADAPTED V4/D12 frame and the bivariate jet engine.

Built on top of `slicelib.py` (copied verbatim from FIX-P1: the modular Weil
frame and the univariate jet engine, with its own self-tests).  Everything new
here is the frame refinement that Theorem H1-1 needs:

    W  =  W^{K}  (+)  E_1 (+) E_2 (+) E_3            (V4 = K = {1,sig,tau,sig.tau})
          <-- ell_V -->   x     y     z
    W^+_sig = W^K (+) E_1 ,   W^-_sig = E_2 (+) E_3 ,
    c_sigma = P(W^{D12})  in  ell_V ,   D12 = C_G(sigma) ,
    W^+ = <w0> (+) std   (S3 = D12/<sigma>) ,  v0 = ell_V cap std ,

and the two equalizer lines of Theorem H1-1(b),(c), computed INTRINSICALLY
from the modular frame (no normalisation to any published matrix, hence no
choice of sqrt(-11) to make):

    L0 = V[sgn^e] = { L in End(W^-) : rho L rho^-1 = L ,
                                      tau L tau^-1 = (-1)^e L } ,
    L1 = ev_{v0} ( { psi in Hom(std, V) : psi(g u) = sgn(g)^e g psi(u) g^-1 } ).

THE LEADING LINE DATUM.  For m = 1,
    Lambda(P)_{ij} = [ s^5 t^1 ]  ( T(P + s e_x + t e_j) )_i ,   P in ell_V,
with i, j indexing the basis (e_y, e_z) of W^-.  (The x-exponent is
e = r - m; the lower x-coefficients vanish automatically once
ord_{ell_V} T >= r, which is checked as a control.)  Its Taylor coefficients
at c_sigma are taken in the S3-LINEAR chart  P(tau) = w0 + tau v0  -- the only
parametrisation for which H1-1(c) is a clean membership statement (a Moebius
reparametrisation would mix lambda_{2e+1} with lambda_{2e}).

WHY MODULAR IS STILL A CHARACTERISTIC-ZERO VERDICT: see slicelib.__doc__.
Only the safe direction is used: a computed slice of dimension 0 is a genuine
char-0 emptiness statement; a nonzero computed dimension is an UPPER BOUND on
the char-0 dimension and decides nothing.
"""
import numpy as np

import slicelib as SL


# --------------------------------------------------------------- linear algebra
def solve_nullspace(rows, ncols, p):
    if not rows:
        return np.eye(ncols, dtype=np.int64)
    return SL.nullspace(np.array(rows, dtype=np.int64) % p, p)


def eigenspace(M, lam, p):
    """rows spanning ker(M - lam I)."""
    n = M.shape[0]
    return SL.nullspace((M - lam * np.eye(n, dtype=np.int64)) % p, p)


def intersect(A, B, p):
    """rows spanning rowspan(A) cap rowspan(B)."""
    # {x : x = aA = bB} -> nullspace of [A; -B]^T stacked appropriately
    ra, rb = A.shape[0], B.shape[0]
    if ra == 0 or rb == 0:
        return np.zeros((0, A.shape[1]), dtype=np.int64)
    M = np.concatenate([A, -B % p], axis=0) % p          # (ra+rb, n)
    ns = SL.nullspace(M.T % p, p)                        # coefficient vectors
    out = []
    for v in ns:
        out.append((v[:ra] @ A) % p)
    out = [r for r in out if np.any(r % p)]
    if not out:
        return np.zeros((0, A.shape[1]), dtype=np.int64)
    O = np.array(out, dtype=np.int64) % p
    # reduce to a basis
    keep = []
    cur = np.zeros((0, O.shape[1]), dtype=np.int64)
    for r in O:
        test = np.concatenate([cur, r[None, :]], axis=0)
        if SL.rref_rank(test, p) > cur.shape[0]:
            cur = test
            keep.append(r)
    return np.array(keep, dtype=np.int64) if keep else \
        np.zeros((0, A.shape[1]), dtype=np.int64)


# ------------------------------------------------------------- adapted frame
def adapted_frame(fr, verbose=True):
    """Refine slicelib's frame to the full V4/D12 coordinate system."""
    p = fr["p"]
    RHO, RHOI = fr["RHO"], fr["RHOI"]
    si = fr["sigma_index"]
    v4 = fr["v4"]                       # [sigma, tau, sigma*tau] as indices
    sig = RHO[si]
    I5 = np.eye(5, dtype=np.int64)
    tests = {}

    # pick tau = the second involution of the V4
    ti = [j for j in v4 if j != si][0]
    tau = RHO[ti]
    tests["V4 commutes"] = bool(np.array_equal((sig @ tau) % p,
                                               (tau @ sig) % p))

    # the four V4-isotypic pieces
    def joint(es, et):
        A = np.concatenate([(sig - es * I5) % p, (tau - et * I5) % p], axis=0)
        return SL.nullspace(A % p, p)

    LINE = joint(1, 1)                  # W^K  = ell_V           (dim 2)
    E1 = joint(1, -1)                   # x  (sigma-even)        (dim 1)
    E2 = joint(-1, 1)                   # y                      (dim 1)
    E3 = joint(-1, -1)                  # z                      (dim 1)
    tests["dim W^K = 2"] = LINE.shape[0] == 2
    tests["dim E1 = dim E2 = dim E3 = 1"] = (E1.shape[0] == 1 and
                                             E2.shape[0] == 1 and
                                             E3.shape[0] == 1)

    # D12 = C_G(sigma)
    D12 = [g for g in range(660)
           if np.array_equal((RHO[g] @ sig) % p, (sig @ RHO[g]) % p)]
    tests["|C_G(sigma)| = 12"] = len(D12) == 12

    # w0 = the D12-fixed vector ; std = the S3-complement of <w0> in W^+
    S = np.zeros((5, 5), dtype=np.int64)
    for g in D12:
        S = (S + RHO[g]) % p
    W0 = SL.nullspace((S - 12 * I5) % p, p)          # fixed space of the average
    # (v is D12-fixed  <=>  S v = 12 v ; 12 is a unit)
    tests["dim W^{D12} = 1"] = W0.shape[0] == 1
    w0 = W0[0] % p
    tests["c_sigma lies on ell_V"] = SL.rref_rank(
        np.concatenate([LINE, w0[None, :]], axis=0), p) == 2

    # v0 : the S3-complement direction inside ell_V  (ker of the D12-average)
    KERS = SL.nullspace(S % p, p)                    # image of (1 - proj_triv)
    V0 = intersect(LINE, KERS, p)
    tests["dim (ell_V cap std) = 1"] = V0.shape[0] == 1
    v0 = V0[0] % p

    ex, ey, ez = E1[0] % p, E2[0] % p, E3[0] % p

    # change of basis (w0, v0, ex, ey, ez)
    B = np.stack([w0, v0, ex, ey, ez], axis=1) % p    # columns
    Binv = SL.mat_inv(B, p)
    tests["adapted basis invertible"] = True
    PMINUS = Binv[3:5, :] % p            # rows: the (e_y, e_z) components
    PPLUS = Binv[0:3, :] % p             # rows: the (w0, v0, e_x) components

    # rho : an order-3 element of D12 ; tau's residual image is the reflection
    rho_idx = None
    for g in D12:
        if fr["orders"][g] == 3:
            rho_idx = g
            break
    tests["D12 has an element of order 3"] = rho_idx is not None
    rho = RHO[rho_idx]

    # restrictions to W^- in the (e_y, e_z) basis
    def restrict_minus(M):
        img = (M @ np.stack([ey, ez], axis=1)) % p        # (5,2)
        return (PMINUS @ img) % p                          # (2,2)

    def restrict_plus_std(M):
        """action on std = <v0, ex>-span?  computed as the induced action on
        W^+ / <w0> is not needed: std is the S3-invariant complement, i.e.
        ker(S) cap W^+."""
        raise NotImplementedError

    RHOm = restrict_minus(rho)
    TAUm = restrict_minus(tau)
    tests["tau|W^- = diag(1,-1)"] = bool(
        np.array_equal(TAUm % p, np.array([[1, 0], [0, p - 1]],
                                          dtype=np.int64) % p))
    tests["rho|W^-  order 3"] = bool(np.array_equal(
        (RHOm @ RHOm @ RHOm) % p, np.eye(2, dtype=np.int64)))
    tests["rho|W^- off-diagonal nonzero"] = bool(RHOm[0, 1] % p and
                                                 RHOm[1, 0] % p)
    tests["tr rho|W^- = -1"] = int((RHOm[0, 0] + RHOm[1, 1]) % p) == (p - 1)

    # std : the 2-dimensional S3-complement of <w0> inside W^+
    WPLUS = SL.nullspace((sig - I5) % p, p)
    STD = intersect(WPLUS, KERS, p)
    tests["dim std = 2"] = STD.shape[0] == 2
    tests["v0 in std"] = SL.rref_rank(
        np.concatenate([STD, v0[None, :]], axis=0), p) == 2

    out = dict(fr)
    out.update({
        "tau_index": ti, "rho_index": rho_idx, "D12": D12,
        "ellV": LINE, "E1": E1, "E2": E2, "E3": E3,
        "w0": w0, "v0": v0, "ex": ex, "ey": ey, "ez": ez,
        "B": B, "Binv": Binv, "PMINUS": PMINUS, "PPLUS": PPLUS,
        "STD": STD, "RHOm": RHOm, "TAUm": TAUm,
        "sig": sig, "tau": tau, "rho": rho,
        "adapted_self_tests": tests,
    })
    if verbose:
        bad = [k for k, v in tests.items() if not v]
        print("[adapted] p=%d  |C_G(sigma)|=%d  self-tests %s"
              % (p, len(D12), "ALL OK" if not bad else "FAILED: %s" % bad))
    assert all(tests.values()), [k for k, v in tests.items() if not v]
    return out


# ------------------------------------------------- the two equalizer lines
def conj_action(M, p):
    """matrix of  L -> M L M^{-1}  on End(W^-) in the basis E_00,E_01,E_10,E_11."""
    Mi = SL.mat_inv(M % p, p)
    A = np.zeros((4, 4), dtype=np.int64)
    for a in range(2):
        for b in range(2):
            E = np.zeros((2, 2), dtype=np.int64)
            E[a, b] = 1
            X = (M @ E @ Mi) % p
            A[:, 2 * a + b] = X.reshape(4) % p
    return A % p


def std_action(fr, g, p):
    """matrix of g acting on std, in the basis (v0, w1) of STD."""
    STD = fr["STD"]
    img = (STD @ g.T) % p                  # rows: g applied to each basis vector
    # express in the STD basis
    M = np.concatenate([STD, img], axis=0)
    # solve  img = X . STD
    A = STD.T % p                          # (5,2)
    # least squares over F_p: pick 2 independent rows of A
    idx = []
    cur = np.zeros((0, 2), dtype=np.int64)
    for i in range(5):
        t = np.concatenate([cur, A[i][None, :]], axis=0)
        if SL.rref_rank(t, p) > cur.shape[0]:
            cur = t
            idx.append(i)
        if len(idx) == 2:
            break
    Asub = A[idx] % p
    Ainv = SL.mat_inv(Asub, p)
    X = (img[:, idx] @ Ainv.T) % p         # (2,2): rows = coordinates
    return X % p


def equalizer_lines(fr, e, p):
    """L0 = V[sgn^e] and L1 = ev_{v0}((std* ox V ox sgn^e)^{S3}), as row spans
    of F_p^4 (End(W^-) flattened row-major)."""
    RHOm, TAUm = fr["RHOm"], fr["TAUm"]
    Arho = conj_action(RHOm, p)
    Atau = conj_action(TAUm, p)
    sgn = 1 if e % 2 == 0 else p - 1
    I4 = np.eye(4, dtype=np.int64)
    rows = np.concatenate([(Arho - I4) % p, (Atau - sgn * I4) % p], axis=0)
    L0 = SL.nullspace(rows % p, p)

    # order 1:  psi in Hom(std, V) with psi(g u) = sgn(g)^e . g psi(u) g^{-1}
    # coordinates: psi = (psi_1, psi_2) in V^2 w.r.t. the STD basis (b1, b2)
    Srho = std_action(fr, fr["rho"], p)          # rows = images of b1, b2
    Stau = std_action(fr, fr["tau"], p)
    cond = []
    for (Sg, Ag, sg) in ((Srho, Arho, 1), (Stau, Atau, sgn)):
        # psi(g b_i) = sum_j Sg[i,j] psi(b_j)  must equal  sg . Ag psi(b_i)
        for i in range(2):
            for a in range(4):
                row = np.zeros(8, dtype=np.int64)
                for j in range(2):
                    row[4 * j + a] = (row[4 * j + a] + Sg[i, j]) % p
                for b in range(4):
                    row[4 * i + b] = (row[4 * i + b] - sg * Ag[a, b]) % p
                cond.append(row % p)
    ns = SL.nullspace(np.array(cond, dtype=np.int64) % p, p)
    # ev_{v0}: v0 is the FIRST basis vector of STD? -- express v0 in the STD basis
    STD = fr["STD"]
    A = STD.T % p
    idx = []
    cur = np.zeros((0, 2), dtype=np.int64)
    for i in range(5):
        t = np.concatenate([cur, A[i][None, :]], axis=0)
        if SL.rref_rank(t, p) > cur.shape[0]:
            cur = t
            idx.append(i)
        if len(idx) == 2:
            break
    coeff = (fr["v0"][idx] @ SL.mat_inv(A[idx] % p, p).T) % p     # (2,)
    img = []
    for b in ns:
        val = (coeff[0] * b[0:4] + coeff[1] * b[4:8]) % p
        if np.any(val):
            img.append(val)
    if img:
        L1 = np.array(img, dtype=np.int64) % p
        keep = []
        cur = np.zeros((0, 4), dtype=np.int64)
        for r in L1:
            t = np.concatenate([cur, r[None, :]], axis=0)
            if SL.rref_rank(t, p) > cur.shape[0]:
                cur = t
                keep.append(r)
        L1 = np.array(keep, dtype=np.int64)
    else:
        L1 = np.zeros((0, 4), dtype=np.int64)
    return L0 % p, L1 % p, ns.shape[0]


# -------------------------------------------------------- bivariate jet engine
def jet_rows2(frame, A, C, Wb, U1, U2, J1, J2, deg):
    """Coefficients of s^i t^j (i<J1, j<J2) of

           R(s)( w + s u1 + t u2 ) ,   R(s)(v) = sum_g rho(g)^{-1} s(rho(g) v),

    for each seed and each base point.  Shape (nseeds, npt, 5, J1, J2).
    (The 1/|G| is dropped -- a unit rescaling of rows.)
    """
    p = frame["p"]
    RHO, RHOI = frame["RHO"], frame["RHOI"]
    ns = A.shape[0]
    npt = Wb.shape[0]
    res = np.zeros((ns, npt, 5, J1, J2), dtype=np.int64)

    def tmul(a, b):
        out = np.zeros_like(a)
        for i in range(J1):
            for j in range(J2):
                blk = a[..., i, j]
                if i or j:
                    out[..., i:, j:] = (out[..., i:, j:] +
                                        blk[..., None, None] *
                                        b[..., :J1 - i, :J2 - j]) % p
                else:
                    out = (out + blk[..., None, None] * b) % p
        return out % p

    for q in range(npt):
        u = (RHO @ Wb[q]) % p
        u1 = (RHO @ U1[q]) % p
        u2 = (RHO @ U2[q]) % p
        POW = []
        for j in range(5):
            base = np.zeros((660, J1, J2), dtype=np.int64)
            base[:, 0, 0] = u[:, j]
            if J1 > 1:
                base[:, 1, 0] = u1[:, j]
            if J2 > 1:
                base[:, 0, 1] = u2[:, j]
            cur = np.zeros((660, J1, J2), dtype=np.int64)
            cur[:, 0, 0] = 1
            lst = [cur]
            for _ in range(deg):
                cur = tmul(cur, base)
                lst.append(cur)
            POW.append(np.stack(lst))
        P = POW[0][A[:, 0]]
        for j in range(1, 5):
            P = tmul(P, POW[j][A[:, j]])
        for c0 in range(5):
            idx = np.nonzero(C == c0)[0]
            if idx.size == 0:
                continue
            Mg = RHOI[:, :, c0] % p
            res[idx, q] = np.einsum('gsij,gc->scij',
                                    np.transpose(P[idx], (1, 0, 2, 3)),
                                    Mg) % p
    return res % p


# -------------------------------------------------------- Vandermonde inverse
def vandermonde_inv(taus, p):
    """inverse of the (N+1)x(N+1) matrix V[i,k] = taus[i]^k  over F_p."""
    N = len(taus)
    V = np.zeros((N, N), dtype=np.int64)
    for i, t in enumerate(taus):
        v = 1
        for k in range(N):
            V[i, k] = v
            v = (v * int(t)) % p
    return SL.mat_inv(V % p, p)


# ---------------------------------------------- a faster exact rank over F_p
def rref_rank_fast(M, p):
    """Rank of an integer matrix mod p.

    Identical semantics to slicelib.rref_rank (which is the reference
    implementation and is used by the verifier); the only change is that the
    pivot search is vectorised instead of a Python loop over rows, which is
    what makes the 357-profile sweep affordable.  `verify_p2.py` check [H]
    compares the two on random matrices of many shapes.
    """
    A = np.array(M, dtype=np.int64) % p
    rows, cols = A.shape
    r = 0
    for c in range(cols):
        col = A[r:, c]
        nz = np.nonzero(col)[0]
        if nz.size == 0:
            continue
        piv = r + int(nz[0])
        if piv != r:
            A[[r, piv]] = A[[piv, r]]
        A[r] = (A[r] * SL.inv_mod(A[r, c], p)) % p
        below = A[r + 1:, c]
        k = np.nonzero(below)[0]
        if k.size:
            A[r + 1 + k] = (A[r + 1 + k] - np.outer(below[k], A[r])) % p
        r += 1
        if r == rows:
            break
    return r
