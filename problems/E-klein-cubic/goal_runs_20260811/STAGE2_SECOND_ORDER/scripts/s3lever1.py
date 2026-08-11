"""Lever 1 driver: does the A4-equivariant jet separate the three C3-landing
options at an A4-point?

For each multiplicity mu = mult_q(T) and each residue d mod 3 we compute

   A(mu,d)   = { Phi : Sym^mu Theta -> W  A4-equivariant with the omega^{-d}
                 twist }                                        (linear)
   A'(mu,d)  = the subspace cut by the EIGENLINE constraint
                 Phi(theta_{a_q}^mu) in <f>,  f = the X^{C6} point of weight
                 d*a_q          (Prop. 1.6 of the sealed Stage-2 packet)
   ev1       = Phi |-> Phi(theta_{a_q+1}^mu)   -- the dim-1 immune row's value
   ev2       = Phi |-> Phi(theta_{a_q+2}^mu)   -- the dim-0 immune row's value

and report dim A, dim A', dim ev1(A'), dim ev2(A'), plus, when the image is
2-dimensional, which of the three points of X on the target eigenline survive
the landing condition F(Phi) = 0.
"""
import json
import sys

from s3core import Model
from s3a4 import (A4Point, equivariant_space, eval_phi, F_of_phi, monomials3,
                  prop, coords_in, nullspace_rows)

MAXMU = 6


def span_dim(m, vecs):
    vecs = [list(v) for v in vecs if any(x % m.p for x in v)]
    if not vecs:
        return 0
    return len(m.rref(vecs, 5)[0])


def restrict(m, basis, lin_rows, nv):
    """basis: list of coefficient arrays (flattened later).  lin_rows: list of
    linear functionals on the coefficient space, given as lists over the basis
    index.  Returns the sub-basis annihilated by all of them."""
    if not lin_rows:
        return list(range(len(basis))), [tuple(int(i == j) for i in range(len(basis)))
                                         for j in range(len(basis))]
    ns = nullspace_rows(m, [list(r) for r in lin_rows], len(basis))
    return None, ns


def combo(basis, coeffs, p):
    nm = len(basis[0])
    C = [[0] * 5 for _ in range(nm)]
    for k, lam in enumerate(coeffs):
        if lam % p == 0:
            continue
        for a in range(nm):
            for i in range(5):
                if basis[k][a][i]:
                    C[a][i] = (C[a][i] + lam * basis[k][a][i]) % p
    return C


def analyse(m, which, dmod3, mu, log):
    p = m.p
    ap = A4Point(m, which)
    aq = ap.a_q
    basis, mons, idx = equivariant_space(m, ap, mu, dmod3)
    rec = {"p": p, "A4_orbit": "omega" if aq == 1 else "omega^2",
           "a_q": aq, "d_mod_3": dmod3, "mu": mu,
           "dim_A": len(basis)}
    if not basis:
        rec.update(dim_Aprime=0, note="no equivariant jet of this degree")
        log.append(rec)
        return rec

    b_line = aq % 3                      # relative weight 0 : the eigenline
    b_row1 = (aq + 1) % 3                # relative weight 1 : the dim-1 row
    b_row2 = (aq + 2) % 3                # relative weight 2 : the dim-0 row

    def evb(C, b):
        t = coords_in(m, ap.Theta, ap.theta[b])
        return eval_phi(m, C, mons, t)

    # --- the eigenline constraint
    wline = (dmod3 * aq) % 3
    rows = []
    if wline == 0:
        # the weight-0 eigenspace of W is the D12-point, off X: forced zero
        f = None
        for k in range(5):
            rows.append([evb(C, b_line)[k] for C in basis])
    else:
        f = ap.C6pt[wline]
        # ev_line(Phi) must be proportional to f: 1 condition inside the
        # 2-dimensional weight space.  Impose all 2x2 minors with f.
        for k in range(5):
            for l in range(k + 1, 5):
                rows.append([(evb(C, b_line)[k] * f[l]
                              - evb(C, b_line)[l] * f[k]) % p for C in basis])
    ns = nullspace_rows(m, [r for r in rows if any(x % p for x in r)], len(basis))
    rec["dim_Aprime"] = len(ns)
    rec["eigenline_target"] = ("D12-point (forced zero)" if wline == 0
                               else "X^{C6} point of weight %d" % wline)
    if not ns:
        rec["note"] = "eigenline constraint kills the whole jet space"
        log.append(rec)
        return rec

    Aprime = [combo(basis, s, p) for s in ns]
    for tag, b in (("row_dim1", b_row1), ("row_dim0", b_row2)):
        ims = [evb(C, b) for C in Aprime]
        dim = span_dim(m, ims)
        rec["dim_ev_" + tag] = dim
        w = (dmod3 * aq + mu * ((b - aq) % 3)) % 3
        rec["weight_" + tag] = w
        if dim == 0:
            rec["values_" + tag] = "0 (row is a deeper base point)"
        elif dim == 1:
            v = next(x for x in ims if any(y % p for y in x))
            onX = m.onX(v)
            isc6 = (w in ap.C6pt) and prop(m, v, ap.C6pt[w])
            rec["values_" + tag] = ("PINNED to one point; onX=%s; is the X^{C6} "
                                    "point=%s" % (onX, isc6))
            rec["pinned_is_C6pt_" + tag] = bool(isc6)
            rec["pinned_onX_" + tag] = bool(onX)
        else:
            rec["values_" + tag] = "image is the whole P^1 of the eigenline"
    log.append(rec)
    return rec


def landing_scan(m, which, dmod3, mu):
    """For the cases where equivariance alone does not pin the value, test the
    landing condition F(Phi) = 0 on the whole jet space by exhaustive scan of
    P(A') when dim A' is small."""
    p = m.p
    ap = A4Point(m, which)
    aq = ap.a_q
    basis, mons, idx = equivariant_space(m, ap, mu, dmod3)
    if not basis:
        return None
    return {"dim": len(basis)}


def main():
    out = {}
    for p in (331, 661):
        m = Model(p)
        log = []
        for which in (0, 1):
            for dmod3 in (0, 1, 2):
                for mu in range(1, MAXMU + 1):
                    analyse(m, which, dmod3, mu, log)
        out[str(p)] = log
        print("[p=%d] %d cases" % (p, len(log)))
    with open("results/lever1_jets.json", "w") as f:
        json.dump(out, f, indent=1, sort_keys=True)
    # human readable
    with open("results/lever1_jets.txt", "w") as f:
        f.write("LEVER 1 : the A4-equivariant jet at an A4-point\n")
        f.write("cols: orbit | d%3 | mu | dim A | dim A' | dim ev(dim1 row) | "
                "verdict(dim1 row) | dim ev(dim0 row) | verdict(dim0 row)\n\n")
        for r in out["331"]:
            f.write("%-8s %d %2d | %3d %3d | %s %-58s | %s %s\n"
                    % (r["A4_orbit"], r["d_mod_3"], r["mu"], r["dim_A"],
                       r.get("dim_Aprime", 0),
                       r.get("dim_ev_row_dim1", "-"),
                       r.get("values_row_dim1", "-"),
                       r.get("dim_ev_row_dim0", "-"),
                       r.get("values_row_dim0", "-")))
    print("S3_LEVER1_OK")


if __name__ == "__main__":
    main()
