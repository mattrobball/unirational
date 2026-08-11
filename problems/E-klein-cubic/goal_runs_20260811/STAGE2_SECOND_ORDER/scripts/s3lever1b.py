"""Lever 1, part b: impose the LANDING condition F(Phi) = 0 on the A4-jet and
decide which of the three points of X on the target C3-eigenline is realised.

Reduction used (proved in THEOREM.md sec.2.2): a value c is realised by an
A4-equivariant landing jet of order mu at the A4-point  <=>  there is
Phi in Sym^mu(Theta)* (x) W, A4-equivariant with the omega^{-d} twist,
satisfying the eigenline constraint, with F(Phi) = 0 identically on Theta and
ev(Phi) in <c> \\ {0}.  ("<=" by extension by zero across the omega-summand of
N, which is A4-stable; "=>" by restricting to Theta subset N.)

The achievable set on the target eigenline is computed as a BINARY FORM, so no
rationality assumption on the two exact-C3 points is used.
"""
import json

from s3core import Model
from s3a4 import (A4Point, equivariant_space, eval_phi, F_of_phi, coords_in,
                  nullspace_rows, prop)


# --------------------------------------------------------- binary forms
def bf_trim(a, p):
    a = [x % p for x in a]
    while a and a[-1] == 0:
        a.pop()
    return a


def bf_gcd(a, b, p):
    a, b = bf_trim(list(a), p), bf_trim(list(b), p)
    while b:
        inv = pow(b[-1], p - 2, p)
        r = list(a)
        while len(r) >= len(b) and bf_trim(r, p):
            r = bf_trim(r, p)
            if len(r) < len(b):
                break
            c = r[-1] * inv % p
            sh = len(r) - len(b)
            for i, bi in enumerate(b):
                r[i + sh] = (r[i + sh] - c * bi) % p
            r = bf_trim(r, p)
        a, b = b, r
    return bf_trim(a, p)


def bf_eval_deg(a):
    return len(a) - 1 if a else -1


def homog_gcd(polys, p, deg):
    """polys: list of coefficient lists in the affine variable lam (nu = 1),
    together with the multiplicity of the root at infinity tracked by `deg`.
    Returns (affine gcd, order of the common root at infinity)."""
    g = []
    inf = min(deg - bf_eval_deg(bf_trim(list(q), p)) for q in polys) \
        if all(bf_trim(list(q), p) for q in polys) else None
    for q in polys:
        g = bf_gcd(g, q, p) if g else bf_trim(list(q), p)
    return g, inf


# ---------------------------------------------------------------- driver
def run_case(m, which, dmod3, mu):
    p = m.p
    ap = A4Point(m, which)
    aq = ap.a_q
    basis, mons, idx = equivariant_space(m, ap, mu, dmod3)
    rec = {"p": p, "orbit": "omega" if aq == 1 else "omega^2",
           "d_mod_3": dmod3, "mu": mu, "dim_A": len(basis)}
    if not basis:
        rec["verdict"] = "no equivariant jet"
        return rec

    def ev(C, b):
        return eval_phi(m, C, mons, coords_in(m, ap.Theta, ap.theta[b]))

    b_line, b_r1, b_r2 = aq % 3, (aq + 1) % 3, (aq + 2) % 3
    wline = (dmod3 * aq) % 3
    rows = []
    if wline == 0:
        for k in range(5):
            rows.append([ev(C, b_line)[k] for C in basis])
    else:
        f = ap.C6pt[wline]
        for k in range(5):
            for l in range(k + 1, 5):
                rows.append([(ev(C, b_line)[k] * f[l] - ev(C, b_line)[l] * f[k]) % p
                             for C in basis])
    ns = nullspace_rows(m, [r for r in rows if any(x % p for x in r)], len(basis))
    rec["dim_Aprime"] = len(ns)
    if not ns:
        rec["verdict"] = "eigenline constraint kills the jet space"
        return rec

    def cmb(co):
        C = [[0] * 5 for _ in range(len(mons))]
        for k, lam in enumerate(co):
            if lam % p:
                for a in range(len(mons)):
                    for i in range(5):
                        if basis[k][a][i]:
                            C[a][i] = (C[a][i] + lam * basis[k][a][i]) % p
        return C

    Ap = [cmb(s) for s in ns]
    out = {}
    for tag, b in (("row_dim1", b_r1), ("row_dim0", b_r2)):
        w = (dmod3 * aq + mu * ((b - aq) % 3)) % 3
        sub = {"weight": w}
        if w == 0:
            sub["verdict"] = ("target weight 0 = the D12-point, OFF X: the row "
                              "is a deeper base point (no value at this order)")
            out[tag] = sub
            continue
        B = ap.eigline[w]
        # the binary cubic cutting X on the eigenline
        cub = []
        for k in range(4):
            pass
        # F(s B0 + t B1) as a binary cubic in (s,t): sample 4 points
        cub = binary_form_from_samples(
            m, lambda s, t: m.F(tuple((s * B[0][i] + t * B[1][i]) % p
                                      for i in range(5))), 3)
        sub["X_cubic_on_eigenline"] = cub
        # the C6-point's (s:t)
        c6 = coords_in(m, B, ap.C6pt[w])
        sub["C6_point_st"] = c6
        # ev as a linear map from the A'-coordinates to (s,t)
        A = []
        for C in Ap:
            v = ev(C, b)
            A.append(coords_in(m, B, v) if any(x % p for x in v) else [0, 0])
        sub["ev_matrix"] = A
        rk = len(m.rref([list(r) for r in A if any(r)], 2)[0]) if any(
            any(r) for r in A) else 0
        sub["rank_ev"] = rk
        if rk == 0:
            sub["verdict"] = "ev = 0 on the whole jet space: deeper base point"
            out[tag] = sub
            continue
        # landing: G(lambda) = gcd over the coefficients of F(Phi)
        nA = len(Ap)
        if nA == 1:
            C = Ap[0]
            Fc = F_of_phi(m, C, mons, mu)
            sub["landing_holds"] = (len(Fc) == 0)
            sub["achievable_st"] = [coords_in(m, B, ev(C, b))] if not Fc else []
        elif nA == 2:
            # Phi = lam*Ap0 + Ap1  (plus the point at infinity lam = inf)
            polys = []
            for lam in range(p):
                pass
            # build F(Phi) coefficient-wise as a cubic in lam by 4-point interp
            keys = set()
            samples = {}
            for lam in range(4):
                C = addc(m, Ap[0], Ap[1], lam, 1)
                Fc = F_of_phi(m, C, mons, mu)
                samples[lam] = Fc
                keys |= set(Fc)
            polys = []
            for k in sorted(keys):
                vals = [samples[lam].get(k, 0) for lam in range(4)]
                polys.append(interp(m, list(range(4)), vals, 3))
            g, _ = homog_gcd(polys, p, 3) if polys else ([], None)
            # also test the point at infinity (Phi = Ap[0])
            inf_ok = (len(F_of_phi(m, Ap[0], mons, mu)) == 0)
            sub["landing_gcd_degree"] = bf_eval_deg(g) if polys else "all"
            achievable = []
            if not polys:
                achievable = "the whole pencil"
            else:
                for lam in range(p):
                    if bf_at(g, lam, p) == 0:
                        C = addc(m, Ap[0], Ap[1], lam, 1)
                        v = ev(C, b)
                        if any(x % p for x in v):
                            achievable.append(coords_in(m, B, v))
                if inf_ok:
                    v = ev(Ap[0], b)
                    if any(x % p for x in v):
                        achievable.append(coords_in(m, B, v))
            sub["achievable_st"] = achievable
        else:
            sub["achievable_st"] = "NOT-SCANNED (dim A' = %d)" % nA
        out[tag] = sub
    rec["rows"] = out
    return rec


def addc(m, C0, C1, a, b):
    p = m.p
    return [[(a * C0[k][i] + b * C1[k][i]) % p for i in range(5)]
            for k in range(len(C0))]


def bf_at(a, x, p):
    r = 0
    for c in reversed(a):
        r = (r * x + c) % p
    return r


def interp(m, xs, ys, deg):
    """coefficients of the unique polynomial of degree <= deg through (xs,ys)."""
    p = m.p
    n = deg + 1
    M = [[pow(xs[r], c, p) for c in range(n)] + [ys[r] % p] for r in range(n)]
    R, piv = m.rref(M, n + 1)
    sol = [0] * n
    for r, c in enumerate(piv):
        if c < n:
            sol[c] = R[r][n]
    return sol


def binary_form_from_samples(m, fun, deg):
    p = m.p
    xs = list(range(deg + 1))
    ys = [fun(x, 1) for x in xs]
    aff = interp(m, xs, ys, deg)
    lead = fun(1, 0)
    return {"affine_coeffs_t=1": aff, "value_at_(1:0)": lead % p}


def main():
    out = {}
    for p in (331, 661):
        m = Model(p)
        recs = []
        for which in (0, 1):
            for dmod3 in (0, 1, 2):
                for mu in (2, 3):
                    recs.append(run_case(m, which, dmod3, mu))
        out[str(p)] = recs
        print("[p=%d] %d cases" % (p, len(recs)))
    with open("results/lever1_landing.json", "w") as f:
        json.dump(out, f, indent=1, sort_keys=True, default=str)
    print("S3_LEVER1B_OK")


if __name__ == "__main__":
    main()
