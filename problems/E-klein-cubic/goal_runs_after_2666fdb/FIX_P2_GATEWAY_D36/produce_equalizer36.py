#!/usr/bin/env python3
"""FIX-P2, Engine 1 -- the TIGHT-WINDOW equalizer at d = 36, profile (1,6).

EXACT, characteristic zero, over K0 = QQ(om, nu) (om^2+om+1 = 0, nu^2 = -11).
No modular arithmetic anywhere in this file.

-------------------------------------------------------------------------
THE DERIVATION (everything cited is sealed; nothing is re-proved here)

Inputs.
  (P1) a G-equivariant dominant rational map of degree d gives a nonzero
       T in M_d = (Sym^d W* ox W)^G  with T(gv) = rho(g) T(v).
  (P2)/H0-1  multi-order (r; m,m,m) at the V4-lines, m odd, minus half
       leading.
  (P3)/H0-2  the leading line datum Lambda is NONZERO.
  (P4)/Theorem H1-1 (FIX-H1, PAYLOAD_theorem.txt):
       Lambda in H^0(ell_V, O(n)) ox V ,  V := Hom(Sym^m W^-, W^-),
       n = d - r,  e := r - m , and
         (a) Lambda vanishes to order >= 2e at EACH of the three D12-points
             of ell_V  (hence n >= 6e, i.e. d >= 7r - 6m);
         (b) lambda_{2e} in V[sgn^e]  (one-dimensional);
         (c) lambda_{2e+k} in Im( ev_{v0} : (Sym^k(std*) ox V ox sgn^e)^{S3}
             -> V )  for k >= 1;  vacuous for k >= 2.
  (P5) FIX-P1 sieve: at d = 36 the ONLY admissible profile is (m,r) = (1,6)
       apart from m >= 3 profiles, all of which have a ZERO degree-36 slice
       (FIX-P1 sweep, replicated in this packet by produce_slice36.py).

The tight window.  For (m,r) = (1,6): e = 5 and n = d - r = 30 = 6e.
H1-1(a)'s degree bound is TIGHT: Lambda is a V-valued binary form of degree
exactly 6e vanishing to order >= 2e at three distinct points, so EACH of its
dim V component forms is divisible by  n3^{2e} = (N1 N2 N3)^{10}, a form of
degree 3*2e = 30 = deg Lambda.  Therefore

        Lambda  =  c . n3^{2e} (x) v0 ,      v0 in V CONSTANT,

and (P3) forces v0 != 0.

Taylor coefficients at the D12-point c_sigma.  In the S3-linear affine chart
of P_sigma centred at c_sigma (W^+ = <w0> (+) std is an S3-splitting, so the
chart and the trivialisation of O(k) are S3-equivariant, and the affine
parameter tau along ell_V is a linear coordinate), write
n3 = tau . h(tau) with h(0) != 0 (the three points are distinct).  Then

        lambda_{2e}   =  c h(0)^{2e}          . v0 ,
        lambda_{2e+1} =  c 2e h(0)^{2e-1}h'(0). v0 ,

so BOTH are nonzero scalar multiples of v0 as soon as h(0) != 0 and
h'(0) != 0 -- both verified exactly below from the D12-point cubic
beta^3 + 3 beta^2 + kp = 0 of FIX-H1 sec.4.

Hence (b) and (c)(k=1) read

        v0 in L0 := V[sgn^e]        and        v0 in L1 := Im(ev_{v0})|_{k=1},

two lines in V.  If L0 != L1 then v0 = 0, contradicting (P3).

(Consistency of (c): Lambda = const.(N2 N3)^e|_{ell_V} . Psi|_{ell_V} and
(N2 N3)|_{ell_V} is a product of two linear forms both vanishing at c_sigma,
hence EXACTLY const.tau^2; so (N2N3)^e|_{ell_V} = const.tau^{2e} is a
monomial and lambda_{2e+k} = const . ev_{v0}(psi_k) with no mixing of lower
orders.  This is why (c) is a clean membership statement.)
-------------------------------------------------------------------------
"""
import json
import os
import sys
import time

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)

from k0 import K, ZERO, ONE, OM, OM2, NU, KP, KM, rref, rank, nullspace  # noqa

T0 = time.time()
LOG = []


def log(s=""):
    print(s, flush=True)
    LOG.append(s)


# ---------------------------------------------------------------- the S3 frame
# The residual S3 = C_G(sigma)/<sigma> acting on W^- = std.  These two matrices
# are FIX-H1's certificate A4 (produce_h1_frame.py); they are re-verified from
# scratch here (order relations + irreducibility), not taken on trust.
R = [[K.rat(-1, 2), (ONE - NU) / K.rat(4)],
     [(-ONE - NU) / K.rat(4), K.rat(-1, 2)]]
TAU = [[ONE, ZERO], [ZERO, -ONE]]


def mm(A, B):
    n = len(A)
    return [[sum((A[i][k] * B[k][j] for k in range(n)), ZERO)
             for j in range(n)] for i in range(n)]


def eye(n):
    return [[ONE if i == j else ZERO for j in range(n)] for i in range(n)]


def eqm(A, B):
    return all((A[i][j] - B[i][j]).is_zero()
               for i in range(len(A)) for j in range(len(A)))


def m2inv(M):
    d = M[0][0] * M[1][1] - M[0][1] * M[1][0]
    di = d.inv()
    return [[M[1][1] * di, -M[0][1] * di], [-M[1][0] * di, M[0][0] * di]]


def frame_selftests():
    ok = {}
    I2 = eye(2)
    ok["R^3 = 1"] = eqm(mm(R, mm(R, R)), I2)
    ok["R^2 != 1"] = not eqm(mm(R, R), I2)
    ok["TAU^2 = 1"] = eqm(mm(TAU, TAU), I2)
    ok["(R TAU)^2 = 1"] = eqm(mm(mm(R, TAU), mm(R, TAU)), I2)
    ok["TAU R TAU = R^{-1}"] = eqm(mm(TAU, mm(R, TAU)), mm(R, R))
    ok["det R = 1"] = (R[0][0] * R[1][1] - R[0][1] * R[1][0] - ONE).is_zero()
    ok["tr R = -1"] = (R[0][0] + R[1][1] + ONE).is_zero()
    # W^- irreducible over S3: R has nonzero off-diagonal entries and TAU is
    # diag(1,-1), so no common eigenvector.
    ok["R off-diagonal nonzero"] = (not R[0][1].is_zero()) and \
        (not R[1][0].is_zero())
    return ok


# ---------------------------------- V = Hom(Sym^m W^-, W^-) and the S3-action
def vbasis(m):
    """(component, i) <-> the basis element  y^i z^{m-i}  in component comp."""
    return [(comp, i) for comp in (0, 1) for i in range(m + 1)]


def binom_expand(a, b, k):
    """coefficients c[j] of y^j z^{k-j} in (a y + b z)^k."""
    cur = [ONE]
    for _ in range(k):
        nxt = [ZERO] * (len(cur) + 1)
        for j, c in enumerate(cur):
            nxt[j + 1] = nxt[j + 1] + c * a
            nxt[j] = nxt[j] + c * b
        cur = nxt
    return cur


def act_matrix(M, m):
    """matrix of  L -> M o L o (M^{-1})^{sym m}  on V, in vbasis(m)."""
    Mi = m2inv(M)
    vb = vbasis(m)
    n = len(vb)
    cols = []
    for comp, i in vb:
        A = binom_expand(Mi[0][0], Mi[0][1], i)
        Bp = binom_expand(Mi[1][0], Mi[1][1], m - i)
        coefs = [ZERO] * (m + 1)
        for j1, c1 in enumerate(A):
            for j2, c2 in enumerate(Bp):
                coefs[j1 + j2] = coefs[j1 + j2] + c1 * c2
        col = [ZERO] * n
        for j in range(m + 1):
            col[vb.index((0, j))] = col[vb.index((0, j))] + M[0][comp] * coefs[j]
            col[vb.index((1, j))] = col[vb.index((1, j))] + M[1][comp] * coefs[j]
        cols.append(col)
    return [[cols[j][i] for j in range(n)] for i in range(n)]


def act_matrix_sym(M, k):
    """action on Sym^k(std*), basis xi0^i xi1^{k-i}  (q -> q o g^{-1})."""
    Mi = m2inv(M)
    cols = []
    for i in range(k + 1):
        A = binom_expand(Mi[0][0], Mi[0][1], i)
        Bp = binom_expand(Mi[1][0], Mi[1][1], k - i)
        coefs = [ZERO] * (k + 1)
        for j1, c1 in enumerate(A):
            for j2, c2 in enumerate(Bp):
                coefs[j1 + j2] = coefs[j1 + j2] + c1 * c2
        cols.append(coefs)
    return [[cols[j][i] for j in range(k + 1)] for i in range(k + 1)]


def isotypic_line(m, e):
    """V[sgn^e] = {L : rho.L = L , tau.L = sgn(tau)^e L}."""
    n = 2 * (m + 1)
    A, B = act_matrix(R, m), act_matrix(TAU, m)
    sgn = ONE if e % 2 == 0 else -ONE
    rows = [[A[i][j] - (ONE if i == j else ZERO) for j in range(n)]
            for i in range(n)]
    rows += [[B[i][j] - (sgn if i == j else ZERO) for j in range(n)]
             for i in range(n)]
    return nullspace(rows, n)


def order_image(m, e, k):
    """Im( ev_{v0} : (Sym^k(std*) ox V ox sgn^e)^{S3} -> V ) and dim V^{tau}."""
    n = 2 * (m + 1)
    AV, BV = act_matrix(R, m), act_matrix(TAU, m)
    sgn = ONE if e % 2 == 0 else -ONE
    SR, ST = act_matrix_sym(R, k), act_matrix_sym(TAU, k)
    N = (k + 1) * n
    rr = []
    for (MS, MV, sg) in ((SR, AV, ONE), (ST, BV, sgn)):
        for i in range(k + 1):
            for a in range(n):
                row = [ZERO] * N
                for j in range(k + 1):
                    for b in range(n):
                        row[j * n + b] = MS[i][j] * MV[a][b]
                row[i * n + a] = row[i * n + a] - sg
                rr.append(row)
    ns = nullspace(rr, N)
    # v0 = the tau-fixed direction of std (tau = diag(1,-1) => v0 = e_0), so the
    # monomial xi0^i xi1^{k-i} evaluates to 1 at v0 iff i = k.
    img = [[b[k * n + a] for a in range(n)] for b in ns]
    img = [row for row in img if any(not v.is_zero() for v in row)]
    rows2 = [[BV[i][j] - (sgn if i == j else ZERO) for j in range(n)]
             for i in range(n)]
    R2, _ = rref(img) if img else ([], [])
    return [list(x) for x in R2], len(nullspace(rows2, n)), len(ns)


def mono_str(m, comp, i):
    yz = ('y^%d' % i if i > 1 else ('y' if i == 1 else '')) + \
         ('z^%d' % (m - i) if m - i > 1 else ('z' if m - i == 1 else ''))
    return '%s E_%s' % (yz if yz else '1', 'y' if comp == 0 else 'z')


def show(vec, m):
    parts = []
    for c, (comp, i) in zip(vec, vbasis(m)):
        if not c.is_zero():
            parts.append('(%r) %s' % (c, mono_str(m, comp, i)))
    return ' + '.join(parts) if parts else '0'


def as_matrix(vec, m=1):
    """for m = 1: the 2x2 matrix of L in the (y,z) basis."""
    assert m == 1
    vb = vbasis(1)
    Mx = [[ZERO, ZERO], [ZERO, ZERO]]
    for c, (comp, i) in zip(vec, vb):
        # basis element:  y^i z^{1-i}  in component comp
        col = 0 if i == 1 else 1        # which input coordinate
        Mx[comp][col] = c
    return Mx


def lines_equal(u, v):
    """do the nonzero vectors u, v span the same line?"""
    n = len(u)
    piv = next(i for i in range(n) if not u[i].is_zero())
    if v[piv].is_zero():
        return False
    lam = v[piv] / u[piv]
    return all((v[i] - lam * u[i]).is_zero() for i in range(n))


# ------------------------------------------------------- the D12-point cubic
def d12_nondegeneracy():
    """Exactly: the three D12-points of ell_V are DISTINCT and none of the two
    scalars h(0), h'(0) of the derivation vanishes.

    FIX-H1 sec.4: c_sigma = [1 : beta] with P(beta) = beta^3 + 3 beta^2 + kp = 0
    (kp = KP, 8 kp^2 - 13 kp - 4 = 0), and the three D12-points of ell_V are the
    three roots of P (one free C3-orbit).  With  n3 = P  and  c_sigma = beta_1:

        h(t) := P(t)/(t - beta_1) ,   h(beta_1) = P'(beta_1) = 3 beta^2 + 6 beta,
                                      h'(beta_1) = P''(beta_1)/2 = 3 beta + 3 .

    So h(0) != 0  <=>  beta != 0 and beta != -2 ;  h'(0) != 0 <=> beta != -1.
    All three are decided by evaluating P at 0, -2, -1 and using the minimal
    polynomial of kp.  Distinctness of the roots is disc(P) != 0.
    """
    out = {}
    # P(0) = kp ; P(-2) = 4 + kp ; P(-1) = 2 + kp
    for nm, val in (("P(0)  = kp", KP),
                    ("P(-2) = 4+kp", KP + K.rat(4)),
                    ("P(-1) = 2+kp", KP + K.rat(2))):
        out[nm] = repr(val)
        assert not val.is_zero(), nm
    # discriminant of t^3 + 3t^2 + kp :  disc = -4 p^3 - 27 q^2 in depressed form
    # t = u - 1 : u^3 - 3u + (2 + kp)  => p = -3, q = 2 + kp
    q = KP + K.rat(2)
    disc = K.rat(-4) * K.rat(-27) - K.rat(27) * q * q          # -4p^3-27q^2
    out["disc(n3)"] = repr(disc)
    out["disc_nonzero"] = not disc.is_zero()
    assert not disc.is_zero(), "D12-points not distinct?!"
    # the same in the Chebyshev variable: beta = -(1+c), c^3-3c = kp+2, and
    # h'(beta_1) = 3(beta+1) = -3c ; c = 0 would force kp = -2.
    out["h'(c_sigma) = -3c, c != 0 since kp != -2"] = True
    return out


# ------------------------------------------------------------------- the run
def window(m, r, d, tag):
    e = r - m
    n = d - r
    log("")
    log("===== %s :  (m,r) = (%d,%d) , e = %d , d = %d , n = d-r = %d ====="
        % (tag, m, r, e, d, n))
    res = {"m": m, "r": r, "d": d, "e": e, "n": n}
    res["tight"] = (n == 6 * e)
    log("  H1-1(a) degree bound n >= 6e = %d :  n = %d  ->  %s"
        % (6 * e, n, "TIGHT (equality)" if n == 6 * e else
           ("slack %d" % (n - 6 * e))))
    L0 = isotypic_line(m, e)
    assert len(L0) == 1, ("dim V[sgn^e] = %d" % len(L0))
    g0 = L0[0]
    piv = next(i for i in range(len(g0)) if not g0[i].is_zero())
    g0 = [v * g0[piv].inv() for v in g0]
    log("  L0 = V[sgn^e] (order-0 equalizer, dim %d) = < %s >"
        % (len(L0), show(g0, m)))
    img1, dtau, dinv = order_image(m, e, 1)
    log("  dim V^{tau,sgn^e} = %d ;  dim (Sym^1(std*) ox V ox sgn^e)^{S3} = %d"
        % (dtau, dinv))
    log("  L1 = Im(ev_v0) at order 1 (dim %d) = %s"
        % (len(img1), " , ".join("< %s >" % show(b, m) for b in img1)))
    res["dim_V"] = 2 * (m + 1)
    res["dim_L0"] = len(L0)
    res["dim_L1"] = len(img1)
    res["dim_Vtau"] = dtau
    res["L0"] = [repr(v) for v in g0]
    res["L1"] = [[repr(v) for v in b] for b in img1]
    if len(img1) == 1:
        same = lines_equal(g0, img1[0])
        res["L0_equals_L1"] = bool(same)
        log("  L0 == L1 ?  %s" % ("YES" if same else "NO"))
        if m == 1:
            log("     L0 as a matrix on W^-: %s" %
                _mstr(as_matrix(g0)))
            log("     L1 as a matrix on W^-: %s" %
                _mstr(as_matrix(img1[0])))
        if not same and res["tight"]:
            log("  ==> at the TIGHT window Lambda = c.n3^{2e} (x) v0 with v0"
                " constant, so")
            log("      lambda_{2e} and lambda_{2e+1} are BOTH nonzero scalar"
                " multiples of v0 ;")
            log("      (b) puts v0 on L0, (c) puts v0 on L1, and"
                " L0 cap L1 = {0}:")
            log("      v0 = 0, i.e. Lambda = 0 -- contradicting H0-2"
                " (Lambda != 0).")
            res["verdict"] = "WINDOW-EMPTY-BY-EQUALIZER"
        elif res["tight"]:
            res["verdict"] = "EQUALIZER-DOES-NOT-CLOSE (L0 = L1)"
        else:
            res["verdict"] = "NOT-TIGHT: no rigidity, equalizer inconclusive"
    else:
        res["L0_equals_L1"] = None
        res["verdict"] = "L1 not a line (dim %d)" % len(img1)
    log("  VERDICT: %s" % res["verdict"])
    return res


def _mstr(Mx):
    return "[[%r, %r], [%r, %r]]" % (Mx[0][0], Mx[0][1], Mx[1][0], Mx[1][1])


def dim_span(vecs):
    return rank([list(v) for v in vecs]) if vecs else 0


def tight_window_scan(mmax=11, rmax=20):
    """For EVERY profile (m, r) with m odd and r >= (3m+1)/2, decide whether the
    TIGHT window  d = 7r - 6m  (the minimal degree H1-1(a) allows) is EMPTY.

    At d = 7r-6m the line degree is n = d - r = 6e exactly, so H1-1(a) forces
    Lambda = c . n3^{2e} (x) v0 with v0 in V CONSTANT and (H0-2) v0 != 0; then
    lambda_{2e} and lambda_{2e+1} are both nonzero multiples of v0, so

        v0  in  L0 cap L1 .

    dim(L0 cap L1) = 0  ==>  the profile (m,r) carries NO map in its minimal
    degree 7r-6m.  (Independent of the line-degree/cell classification.)
    """
    log("")
    log("===== TIGHT-WINDOW SCAN: is d = 7r-6m empty for each profile? =====")
    log("  m   r    e   d=7r-6m   dim V  dim L0  dim L1  dim(L0 cap L1)"
        "   tight window")
    rows = []
    for m in range(1, mmax + 1, 2):
        rmin = (3 * m + 1) // 2
        for r in range(rmin, rmax + 1):
            e = r - m
            if e < 1:
                continue
            d = 7 * r - 6 * m
            L0 = isotypic_line(m, e)
            L1, dtau, dinv = order_image(m, e, 1)
            both = [list(v) for v in L0] + [list(v) for v in L1]
            dsum = dim_span(both)
            dint = len(L0) + len(L1) - dsum
            rows.append({"m": m, "r": r, "e": e, "d": d,
                         "dim_V": 2 * (m + 1), "dim_L0": len(L0),
                         "dim_L1": len(L1), "dim_cap": dint,
                         "tight_empty": bool(dint == 0)})
            log("  %-3d %-4d %-3d %-8d  %-6d %-7d %-7d %-14d  %s"
                % (m, r, e, d, 2 * (m + 1), len(L0), len(L1), dint,
                   "EMPTY" if dint == 0 else "not decided"))
    nemp = sum(1 for x in rows if x["tight_empty"])
    log("  --> %d of %d profiles have EMPTY tight window" % (nemp, len(rows)))
    return rows


def main():
    log("# FIX-P2 Engine 1 -- the tight-window S3-equalizer, exact over"
        " K0 = QQ(om,nu)")
    log("# kp = %r  (numerically %s)" % (KP, KP.cplx()))
    st = frame_selftests()
    log("# frame self-tests: %s"
        % ", ".join("%s:%s" % (k, "OK" if v else "FAIL") for k, v in st.items()))
    assert all(st.values()), st
    nd = d12_nondegeneracy()
    log("# D12-point cubic n3 = beta^3+3beta^2+kp :")
    for k2, v2 in nd.items():
        log("#    %-28s %s" % (k2, v2))

    out = {"frame_self_tests": {k: bool(v) for k, v in st.items()},
           "d12_nondegeneracy": {k: (v if isinstance(v, (bool, str)) else
                                     repr(v)) for k, v in nd.items()},
           "windows": {}}

    # ---- the mission's window --------------------------------------------
    out["windows"]["d36_(1,6)"] = window(1, 6, 36, "THE GATEWAY WINDOW d = 36")

    # ---- controls ---------------------------------------------------------
    log("")
    log("===== CONTROLS =====")
    # (i) reproduce FIX-H1 sec.9 branch (ii) : m = 1, e = 6 -> L0 = <id>,
    #     L1 = <diag(1,-1)>
    c1 = window(1, 7, 43, "CONTROL: FIX-H1 branch (ii), (1,7), e = 6")
    M0 = as_matrix([K(eval(x)) if False else None for x in []]) if False else None
    out["windows"]["control_d43_(1,7)"] = c1
    # (ii) branch (i) of FIX-H1: m = 3, e = 3 -- dim L1 must be 3 in the
    #     4-dimensional V^{tau,sgn}
    c2 = window(3, 6, 39, "CONTROL: FIX-H1 branch (i), (3,6), e = 3")
    out["windows"]["control_d39_(3,6)"] = c2
    # (iii) the NON-tight (1,6) windows d = 37, 38 : the same two lines, but the
    #     rigidity is gone (Lambda = n3^{2e} . Xi with deg Xi = n - 6e > 0)
    for dd in (37, 38, 39, 40):
        out["windows"]["d%d_(1,6)" % dd] = window(1, 6, dd,
                                                  "(1,6) at d = %d" % dd)
    out["tight_window_scan"] = tight_window_scan()
    return out


if __name__ == "__main__":
    OUT = main()
    log("")
    log("elapsed %.2f s" % (time.time() - T0))
    os.makedirs(os.path.join(HERE, "payloads"), exist_ok=True)
    with open(os.path.join(HERE, "payloads", "EQUALIZER36.json"), "w") as fh:
        json.dump(OUT, fh, indent=1, sort_keys=True)
    with open(os.path.join(HERE, "payloads", "PAYLOAD_equalizer36.txt"),
              "w") as fh:
        fh.write("\n".join(LOG) + "\n")
    print("FIX_P2_EQUALIZER_OK")
