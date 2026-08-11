"""Lever 1, part c: per-target-point landing test.

For a jet order mu with jet space A' of dimension n and evaluation map
ev : A' -> (the 2-dimensional weight space of the target eigenline) of rank 2,
choose a basis  A' = ker(ev) + <Q1, Q2>  with ev(Q1) = (1,0), ev(Q2) = (0,1).
Then for a target point c = (s:t) on the eigenline,

      c is realised  <=>  the cubic system  F( sum a_i P_i + s Q1 + t Q2 ) = 0
                          has a solution in the a_i  over the algebraic closure.

For dim ker(ev) = 1 this is a univariate gcd, decided exactly over F_p (a
common root in the algebraic closure exists iff the gcd over F_p has positive
degree).  Larger kernels are handed to Macaulay2 by `s3m2.py`.
"""
import json

from s3core import Model
from s3a4 import (A4Point, equivariant_space, eval_phi, F_of_phi, coords_in,
                  nullspace_rows, prop)


def poly_gcd(a, b, p):
    a = trim(list(a), p)
    b = trim(list(b), p)
    while b:
        inv = pow(b[-1], p - 2, p)
        r = list(a)
        while True:
            r = trim(r, p)
            if len(r) < len(b):
                break
            c = r[-1] * inv % p
            sh = len(r) - len(b)
            for i, bi in enumerate(b):
                r[i + sh] = (r[i + sh] - c * bi) % p
        a, b = b, r
    return trim(a, p)


def trim(a, p):
    a = [x % p for x in a]
    while a and a[-1] == 0:
        a.pop()
    return a


def build(m, which, dmod3, mu, eigline_constraint=True):
    p = m.p
    ap = A4Point(m, which)
    aq = ap.a_q
    basis, mons, idx = equivariant_space(m, ap, mu, dmod3)
    if not basis:
        return None
    tcoord = {b: coords_in(m, ap.Theta, ap.theta[b]) for b in (0, 1, 2)}

    def ev(C, b):
        return eval_phi(m, C, mons, tcoord[b])

    b_line = aq % 3
    wline = (dmod3 * aq) % 3
    rows = []
    if not eigline_constraint:
        rows = []
    elif wline == 0:
        for k in range(5):
            rows.append([ev(C, b_line)[k] for C in basis])
    else:
        f = ap.C6pt[wline]
        for k in range(5):
            for l in range(k + 1, 5):
                rows.append([(ev(C, b_line)[k] * f[l] - ev(C, b_line)[l] * f[k]) % p
                             for C in basis])
    ns = nullspace_rows(m, [r for r in rows if any(x % p for x in r)], len(basis))
    if not ns:
        return None

    def cmb(co):
        C = [[0] * 5 for _ in range(len(mons))]
        for k, lam in enumerate(co):
            if lam % p:
                for a in range(len(mons)):
                    for i in range(5):
                        if basis[k][a][i]:
                            C[a][i] = (C[a][i] + lam * basis[k][a][i]) % p
        return C
    return ap, mons, [cmb(s) for s in ns], ev, aq


def xpoints_on_line(m, ap, w):
    p = m.p
    B = ap.eigline[w]
    pts = []
    for s in range(p):
        v = tuple((B[0][i] + s * B[1][i]) % p for i in range(5))
        if m.onX(v):
            pts.append((1, s))
    if m.onX(B[1]):
        pts.append((0, 1))
    return pts, B


def run(m, which, dmod3, mu, tag_row, eig=True):
    p = m.p
    got = build(m, which, dmod3, mu, eig)
    if got is None:
        return {"verdict": "no jet space"}
    ap, mons, Ap, ev, aq = got
    b = (aq + (1 if tag_row == "row_dim1" else 2)) % 3
    w = (dmod3 * aq + mu * ((b - aq) % 3)) % 3
    rec = {"p": p, "orbit": "omega" if aq == 1 else "omega^2", "d_mod_3": dmod3,
           "mu": mu, "row": tag_row, "weight": w, "dim_Aprime": len(Ap),
           "eigenline_constraint": eig}
    if w == 0:
        rec["verdict"] = "weight 0: target off X, deeper base point"
        return rec
    pts, B = xpoints_on_line(m, ap, w)
    rec["n_Fp_points_of_X_on_line"] = len(pts)
    c6 = coords_in(m, B, ap.C6pt[w])
    # ev in eigenline coordinates
    E = []
    for C in Ap:
        v = ev(C, b)
        E.append(coords_in(m, B, v) if any(x % p for x in v) else [0, 0])
    R, piv = m.rref([list(r) for r in E if any(r)], 2)
    rk = len(R)
    rec["rank_ev"] = rk
    if rk < 2:
        rec["verdict"] = "ev has rank < 2: value already pinned by equivariance"
        return rec
    # kernel of ev and a section
    K = nullspace_rows(m, [[E[k][j] for k in range(len(Ap))] for j in range(2)],
                       len(Ap))
    rec["dim_ker_ev"] = len(K)
    if len(K) != 1:
        rec["verdict"] = "kernel dimension %d: handed to M2" % len(K)
        return rec
    Pk = lincomb(m, Ap, K[0])
    # find Q1,Q2 with ev = (1,0),(0,1)
    Q = []
    for target in ((1, 0), (0, 1)):
        sol = solve_lin(m, [[E[k][j] for k in range(len(Ap))] for j in range(2)],
                        list(target))
        Q.append(lincomb(m, Ap, sol))
    res = {}
    for (s, t) in pts:
        polys = {}
        for a in range(4):
            C = addv(m, [(a, Pk), (s, Q[0]), (t, Q[1])])
            Fc = F_of_phi(m, C, mons, mu)
            for k, v in Fc.items():
                polys.setdefault(k, [0, 0, 0, 0])[a] = v
        g = []
        for k, vals in polys.items():
            co = interp(m, [0, 1, 2, 3], vals, 3)
            g = poly_gcd(g, co, p) if g else trim(co, p)
        if not polys:
            verdict = "REALISED (landing holds identically on the whole line)"
        elif not g:
            verdict = "REALISED (all cubics vanish identically)"
        elif len(g) - 1 >= 1:
            verdict = "REALISED (gcd degree %d)" % (len(g) - 1)
        else:
            verdict = "NOT realised"
        isc6 = (s * c6[1] - t * c6[0]) % p == 0
        res["(%d:%d)%s" % (s, t, " = X^{C6} point" if isc6 else " = exact-C3 point")] \
            = verdict
    rec["targets"] = res
    return rec


def lincomb(m, Ap, co):
    p = m.p
    nm = len(Ap[0])
    C = [[0] * 5 for _ in range(nm)]
    for k, lam in enumerate(co):
        if lam % p:
            for a in range(nm):
                for i in range(5):
                    if Ap[k][a][i]:
                        C[a][i] = (C[a][i] + lam * Ap[k][a][i]) % p
    return C


def addv(m, pairs):
    p = m.p
    nm = len(pairs[0][1])
    C = [[0] * 5 for _ in range(nm)]
    for lam, D in pairs:
        if lam % p:
            for a in range(nm):
                for i in range(5):
                    if D[a][i]:
                        C[a][i] = (C[a][i] + lam * D[a][i]) % p
    return C


def solve_lin(m, rows, rhs):
    p = m.p
    n = len(rows[0])
    M = [list(rows[j]) + [rhs[j]] for j in range(len(rows))]
    R, piv = m.rref(M, n + 1)
    sol = [0] * n
    for r, c in enumerate(piv):
        if c < n:
            sol[c] = R[r][n]
    return sol


def interp(m, xs, ys, deg):
    p = m.p
    n = deg + 1
    M = [[pow(xs[r], c, p) for c in range(n)] + [ys[r] % p] for r in range(n)]
    R, piv = m.rref(M, n + 1)
    sol = [0] * n
    for r, c in enumerate(piv):
        if c < n:
            sol[c] = R[r][n]
    return sol


def main():
    out = {}
    for p in (331, 661):
        m = Model(p)
        recs = []
        for which in (0, 1):
            for dmod3 in (0, 1, 2):
                for mu in (3, 4, 5):
                    for tag in ("row_dim1", "row_dim0"):
                        for eig in (True, False):
                            recs.append(run(m, which, dmod3, mu, tag, eig))
        out[str(p)] = recs
    with open("results/lever1_targets.json", "w") as f:
        json.dump(out, f, indent=1, sort_keys=True, default=str)
    for pp in ("331", "661"):
        for r in out[pp]:
            if "targets" in r:
                print("p=%s %-8s d%d mu=%d %-9s eig=%-5s w=%d  %s"
                      % (pp, r["orbit"], r["d_mod_3"], r["mu"], r["row"],
                         r["eigenline_constraint"], r["weight"], r["targets"]))
    print("S3_LEVER1C_OK")


if __name__ == "__main__":
    main()
