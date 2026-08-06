#!/usr/bin/env python3
"""FIX-D2  TASK B  --  (C2') the rung-independence check.

The divided-I0 identity of Note IV sec.5.8, expanded in the S3-adapted
affine chart at c_sigma:

    J(s ; y) := Q( Theta(s ; y) ; Psi(s ; y) (x) Psi(s ; y) )  ==  0 ,

    Theta(s;y) = sum_k Theta_k(s;y)   (Theta_k of s-degree k,
                                       y-degree m+1, W+-valued)
    Psi(s;y)   = sum_k Psi_k(s;y)     (Psi_k of s-degree k,
                                       y-degree m, W--valued, sgn^e-twisted)

RUNG k  :=  the s-degree-k graded piece of J,  an element of
            ( Sym^k(std*) (x) Sym^{3m+1}(W-)* )^{S3} ,
            R_k = sum_{i+j+l=k} Q(Theta_i ; Psi_j , Psi_l) = 0 .

(C2') asks whether the successive rungs are linearly independent as
functionals on the S3-equivariant Theta-jet space.  Exact, char 0.
"""
import json
import os
import sys
from fractions import Fraction as Fr

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
from d2field import (K, ZERO, ONE, OM, NU, DELTA, S33, add, sub, neg, mul,
                     scal, is_zero, eq, inv, tostr, rref, rank, nullspace)
import produce_d2 as P

OUT = []


def log(s=""):
    print(s)
    OUT.append(s)


# ------------------------------------------------------------------ std frame
# W+ = <c_sigma> (+) std,  std = <u+, u->  (FIX-L1 sec.1)
U_PLUS = [add(ONE, S33), sub(S33, ONE), ZERO]      # tau = +1
U_MINUS = [ZERO, ZERO, ONE]                        # tau = -1
CS = [ONE, P.BCS, ZERO]


def std_matrix(MP):
    """matrix of MP restricted to std = <u+,u-> in that basis."""
    cols = []
    for u in (U_PLUS, U_MINUS):
        v = P.matvec(MP, u)
        # solve v = A*c_sigma + B*u+ + C*u-  (c_sigma-part must be 0)
        A = [[CS[i], U_PLUS[i], U_MINUS[i]] for i in range(3)]
        sol = solve3(A, v)
        assert is_zero(sol[0]), "std is not MP-stable"
        cols.append([sol[1], sol[2]])
    return [[cols[j][i] for j in range(2)] for i in range(2)]


def solve3(A, b):
    rows = [A[i][:] + [b[i]] for i in range(3)]
    R, piv = rref(rows)
    out = [ZERO, ZERO, ZERO]
    for r, c in enumerate(piv):
        if c < 3:
            out[c] = R[r][3]
    return out


# ------------------------------------------------------------------ jets
def jet_basis(k, n, valdim):
    """basis of Sym^k(std*) (x) (deg-n (y,z)-forms with valdim-dim values)."""
    B = []
    for a in range(k + 1):
        for i in range(n + 1):
            for c in range(valdim):
                T = [[[ZERO] * valdim for _ in range(n + 1)]
                     for _ in range(k + 1)]
                T[a][i][c] = ONE
                B.append(T)
    return B


def act_jet(T, Mstd_inv, Mminus_inv, Mplus, sign):
    """(g.T)(s;y) = sign * Mplus . T(Mstd^{-1} s ; Mminus^{-1} y)."""
    k = len(T) - 1
    n = len(T[0]) - 1
    valdim = len(T[0][0])
    # substitute in y
    T1 = [[[ZERO] * valdim for _ in range(n + 1)] for _ in range(k + 1)]
    for a in range(k + 1):
        for c in range(valdim):
            f = [T[a][i][c] for i in range(n + 1)]
            g = P.bf_subst(f, Mminus_inv)
            for i in range(n + 1):
                T1[a][i][c] = g[i]
    # substitute in s
    T2 = [[[ZERO] * valdim for _ in range(n + 1)] for _ in range(k + 1)]
    for i in range(n + 1):
        for c in range(valdim):
            f = [T1[a][i][c] for a in range(k + 1)]
            g = P.bf_subst(f, Mstd_inv)
            for a in range(k + 1):
                T2[a][i][c] = g[a]
    # apply Mplus to values and the sign
    out = [[[ZERO] * valdim for _ in range(n + 1)] for _ in range(k + 1)]
    for a in range(k + 1):
        for i in range(n + 1):
            v = T2[a][i]
            v = P.matvec(Mplus, v) if Mplus is not None else v
            for c in range(valdim):
                out[a][i][c] = mul(sign, v[c])
    return out


def jet_invariants(k, n, valdim, gens):
    """gens = list of (Mstd, Mminus, Mplus, sign)."""
    B = jet_basis(k, n, valdim)
    dim = len(B)
    rows = []
    for Mstd, Mm, Mp, sg in gens:
        Msi = P.mat2inv(Mstd)
        Mmi = P.mat2inv(Mm)
        cols = []
        for T in B:
            gT = act_jet(T, Msi, Mmi, Mp, sg)
            d = []
            for a in range(k + 1):
                for i in range(n + 1):
                    for c in range(valdim):
                        d.append(sub(gT[a][i][c], T[a][i][c]))
            cols.append(d)
        for r in range(dim):
            rows.append([cols[c][r] for c in range(dim)])
    ns = nullspace(rows, dim)
    out = []
    for v in ns:
        T = [[[ZERO] * valdim for _ in range(n + 1)] for _ in range(k + 1)]
        t = 0
        for a in range(k + 1):
            for i in range(n + 1):
                for c in range(valdim):
                    T[a][i][c] = v[t]
                    t += 1
        out.append(T)
    return out


# ------------------------------------------------------------------ the rung
def contract(Theta, Psi1, Psi2):
    """Q(Theta(s;y) ; Psi1(s;y) (x) Psi2(s;y)) -- symmetric in Psi1,Psi2 via
    the polarised S = (u (x) v + v (x) u)/2 convention; here we use the plain
    product since Q(w;S) is linear in S and we always symmetrise by hand."""
    kT, nT = len(Theta) - 1, len(Theta[0]) - 1
    k1, m1 = len(Psi1) - 1, len(Psi1[0]) - 1
    k2, m2 = len(Psi2) - 1, len(Psi2[0]) - 1
    K_ = kT + k1 + k2
    N_ = nT + m1 + m2
    out = [[ZERO] * (N_ + 1) for _ in range(K_ + 1)]
    for aT in range(kT + 1):
        for iT in range(nT + 1):
            w = Theta[aT][iT]
            if all(is_zero(t) for t in w):
                continue
            for a1 in range(k1 + 1):
                for i1 in range(m1 + 1):
                    u = Psi1[a1][i1]
                    if all(is_zero(t) for t in u):
                        continue
                    for a2 in range(k2 + 1):
                        for i2 in range(m2 + 1):
                            v = Psi2[a2][i2]
                            if all(is_zero(t) for t in v):
                                continue
                            S = [mul(u[0], v[0]),
                                 scal(Fr(1, 2), add(mul(u[0], v[1]),
                                                    mul(u[1], v[0]))),
                                 mul(u[1], v[1])]
                            val = P.Qform(w, S)
                            out[aT + a1 + a2][iT + i1 + i2] = add(
                                out[aT + a1 + a2][iT + i1 + i2], val)
    return out, K_, N_


def flatten_jet(T):
    return [c for pl in T for row in pl for c in row]


def rung_system(m, e_odd, KMAX, theta_sgn=False, psi_generic=True):
    """Returns the per-rung data for one (m, e-parity) case."""
    n, mm, ntar = m + 1, m, 3 * m + 1
    RS, TS = std_matrix(P.RHO_P), std_matrix(P.TAU_P)
    sg_tau_psi = neg(ONE) if e_odd else ONE          # sgn^e(tau)
    sg_tau_th = neg(ONE) if theta_sgn else ONE
    gth = [(RS, P.RHO_M, P.RHO_P, ONE), (TS, P.TAU_M, P.TAU_P, sg_tau_th)]
    gps = [(RS, P.RHO_M, P.RHO_M, ONE), (TS, P.TAU_M, P.TAU_M, sg_tau_psi)]
    # the identity Q(Theta;Psi,Psi) carries Theta's twist (Psi's squares away)
    gtg = [(RS, P.RHO_M, None, ONE), (TS, P.TAU_M, None, sg_tau_th)]
    J = [jet_invariants(k, n, 3, gth) for k in range(KMAX + 1)]
    PS = [jet_invariants(k, mm, 2, gps) for k in range(KMAX + 1)]
    C = [jet_invariants(k, ntar, 1, gtg) for k in range(KMAX + 1)]
    # fixed Psi-jets: Psi_0 = the V_m[sgn^e] generator, higher = generic combos
    Psi = []
    for k in range(KMAX + 1):
        acc = [[[ZERO, ZERO] for _ in range(mm + 1)] for _ in range(k + 1)]
        if PS[k]:
            for t, B in enumerate(PS[k]):
                co = ONE if k == 0 else (P.randK(5 * k + 3 * t + 2)
                                         if psi_generic else ZERO)
                for a in range(k + 1):
                    for i in range(mm + 1):
                        for c in range(2):
                            acc[a][i][c] = add(acc[a][i][c], mul(co, B[a][i][c]))
        Psi.append(acc)
    rows_by_rung = []
    for k in range(KMAX + 1):
        # coordinates on the Theta-jet space: concat of J_0..J_k
        tgt_dim = len(C[k])
        # express R_k in the basis C[k]:  build the C[k] coordinate reader
        Cb = [flatten_jet(B) for B in C[k]]
        cols = []
        for i in range(k + 1):
            for B in J[i]:
                acc = [[ZERO] * (ntar + 1) for _ in range(k + 1)]
                for j in range(k - i + 1):
                    l = k - i - j
                    if l < 0:
                        continue
                    R, KK, NN = contract(B, Psi[j], Psi[l])
                    assert KK == k and NN == ntar, (KK, k, NN, ntar)
                    for a in range(k + 1):
                        for t in range(ntar + 1):
                            acc[a][t] = add(acc[a][t], R[a][t])
                vec = [acc[a][t] for a in range(k + 1) for t in range(ntar + 1)]
                cols.append(vec)
        # solve each column in terms of Cb (must lie in the invariant target)
        coord_cols = []
        for v in cols:
            A = [[Cb[q][r] for q in range(len(Cb))] + [v[r]]
                 for r in range(len(v))]
            R, piv = rref(A)
            assert all(pc < len(Cb) for pc in piv), "R_k left the invariant target"
            sol = [ZERO] * len(Cb)
            for r, pc in enumerate(piv):
                sol[pc] = R[r][len(Cb)]
            coord_cols.append(sol)
        mat = [[coord_cols[c][r] for c in range(len(coord_cols))]
               for r in range(len(Cb))] if Cb else []
        rows_by_rung.append((mat, [len(J[i]) for i in range(k + 1)], tgt_dim))
    return J, PS, C, rows_by_rung


def run_case(m, e_odd, KMAX, theta_sgn, psi_generic, tag):
    J, PS, C, R = rung_system(m, e_odd, KMAX, theta_sgn, psi_generic)
    log("  case %s   (m=%d, e %s, Theta-twist=%s, Psi-jets %s)"
        % (tag, m, "odd" if e_odd else "even",
           "sgn" if theta_sgn else "triv",
           "generic" if psi_generic else "ZERO above order 0"))
    log("    dim Theta-jet J_k      : %s" % [len(x) for x in J])
    log("    dim Psi-jet   P_k      : %s" % [len(x) for x in PS])
    log("    dim target    C_k      : %s" % [len(x) for x in C])
    inc, cum, mats = [], 0, []
    for k, (mat, jd, td) in enumerate(R):
        rk = rank(mat) if mat and mat[0] else 0
        mats.append((k, td, rk))
    # stacked rank through rung k, on the joint Theta-jet space
    KJ = [len(x) for x in J]
    stacked = []
    for k in range(KMAX + 1):
        tot_src = sum(KJ[:k + 1])
        rows = []
        for kk in range(k + 1):
            mat = R[kk][0]
            src_kk = sum(KJ[:kk + 1])
            for r in mat:
                rows.append(list(r) + [ZERO] * (tot_src - src_kk))
        stacked.append(rank(rows) if rows else 0)
    log("    rung target dim C_k    : %s" % [t for _, t, _ in mats])
    log("    rung rank (own target) : %s" % [r for _, _, r in mats])
    log("    rung SURJECTIVE        : %s"
        % [("YES" if r == t else "NO(%d/%d)" % (r, t)) for _, t, r in mats])
    own = [r for _, _, r in mats]
    tgt = [t for _, t, _ in mats]
    incr = [stacked[0]] + [stacked[k] - stacked[k - 1]
                           for k in range(1, KMAX + 1)]
    log("    stacked rank thru rung k: %s" % stacked)
    log("    NEW conditions per rung : %s" % incr)
    log("    surjectivity deficit    : %s   (dim C_k - own rank)"
        % [tgt[k] - own[k] for k in range(KMAX + 1)])
    log("    overlap deficit         : %s   (own rank - new conditions)"
        % [own[k] - incr[k] for k in range(KMAX + 1)])
    log("    sum of C_k dims        : %s"
        % [sum(len(C[i]) for i in range(k + 1)) for k in range(KMAX + 1)])
    log("    Theta-jet dim thru k   : %s"
        % [sum(KJ[:k + 1]) for k in range(KMAX + 1)])
    log("    residual Theta freedom : %s"
        % [sum(KJ[:k + 1]) - stacked[k] for k in range(KMAX + 1)])
    indep = all(stacked[k] == sum(len(C[i]) for i in range(k + 1))
                for k in range(KMAX + 1))
    log("    => RUNGS INDEPENDENT (no dependency among the rung conditions): %s"
        % ("YES" if indep else "NO"))
    log()
    return dict(tag=tag, m=m, e_odd=e_odd, theta_sgn=theta_sgn,
                psi_generic=psi_generic,
                dim_J=[len(x) for x in J], dim_P=[len(x) for x in PS],
                dim_C=[len(x) for x in C],
                rung_rank=[r for _, _, r in mats],
                rung_target=[t for _, t, _ in mats],
                stacked=stacked, independent=indep,
                residual=[sum(KJ[:k + 1]) - stacked[k]
                          for k in range(KMAX + 1)],
                new_per_rung=incr,
                surjectivity_deficit=[tgt[k] - own[k] for k in range(KMAX + 1)],
                overlap_deficit=[own[k] - incr[k] for k in range(KMAX + 1)])


if __name__ == "__main__":
    log("FIX-D2  TASK B  --  (C2') RUNG INDEPENDENCE")
    log("=" * 68)
    log()
    res = []
    KM = int(os.environ.get("KMAX", "3"))
    res.append(run_case(1, False, KM, False, True, "B-ii  m=1 e=6"))
    res.append(run_case(1, False, KM, True, True, "B-ii' m=1 e=6 sgn-Theta"))
    res.append(run_case(1, True, KM, False, True, "m=1 e odd (control)"))
    res.append(run_case(3, True, min(KM, 2), False, True, "B-i   m=3 e=3"))
    res.append(run_case(3, False, min(KM, 2), False, True, "m=3 e even (control)"))
    res.append(run_case(1, False, KM, False, False, "m=1 DEGENERATE Psi-jets"))
    json.dump(res, open(os.path.join(HERE, "payloads", "d2_c2prime.json"), "w"),
              indent=1)
    open(os.path.join(HERE, "payloads", "PAYLOAD_C2PRIME.txt"), "w").write(
        "\n".join(OUT) + "\n")
