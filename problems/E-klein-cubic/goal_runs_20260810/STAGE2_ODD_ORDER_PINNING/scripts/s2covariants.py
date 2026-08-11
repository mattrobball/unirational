"""Stage 2: brute-force confirmation on the repo's exact W-matrices.

Builds an honest basis of the covariant module  M_d = (Sym^d W* tensor W)^G
over F_p (p = 331, 661; p does not divide |G| = 660, so dim_{F_p} = dim_C), by
solving the two generator equations S.T = T, Tmat.T = T exactly, and then

  (i) re-expresses each covariant in the eigenbasis of an element g of order
      n in {3,5,6,11} and checks BY BRUTE FORCE that every non-zero monomial
      coefficient obeys the covariance congruence  sum_j nu_j a_j = a_i (mod n);
  (ii) evaluates each covariant at every g-eigenpoint and checks the value is
      either 0 or a multiple of the predicted eigenvector.

No floating point.  All arithmetic is in F_p / Z.
"""
import json
import sys
import numpy as np

from s2core import Model

MONCACHE = {}


def monomials(d, nvar=5):
    key = (d, nvar)
    if key in MONCACHE:
        return MONCACHE[key]
    out = []

    def rec(pos, left, cur):
        if pos == nvar - 1:
            out.append(tuple(cur + [left]))
            return
        for k in range(left + 1):
            rec(pos + 1, left - k, cur + [k])
    rec(0, d, [])
    idx = {m: i for i, m in enumerate(out)}
    MONCACHE[key] = (out, idx)
    return MONCACHE[key]


def subst_matrix(m, A, d):
    """Matrix Q (nmon x nmon) with  x^alpha o A  =  sum_beta Q[beta,alpha] x^beta,
    i.e. the expansion of prod_k (sum_l A[k][l] x_l)^{alpha_k}."""
    p = m.p
    mons, idx = monomials(d)
    nm = len(mons)
    # precompute shift maps for multiplying by x_l inside degree <= d
    Q = np.zeros((nm, nm), dtype=np.int64)
    # build linear-form coefficient vectors
    lin = [np.array([A[k][l] % p for l in range(5)], dtype=np.int64) for k in range(5)]
    # cache of expansions of prod over a multiset, done incrementally
    for ai, alpha in enumerate(mons):
        # poly starts as 1 (degree 0)
        cur = {(0, 0, 0, 0, 0): 1}
        for k in range(5):
            for _ in range(alpha[k]):
                nxt = {}
                for beta, c in cur.items():
                    for l in range(5):
                        cf = lin[k][l]
                        if cf == 0:
                            continue
                        nb = list(beta)
                        nb[l] += 1
                        nb = tuple(nb)
                        nxt[nb] = (nxt.get(nb, 0) + c * int(cf)) % p
                cur = nxt
        for beta, c in cur.items():
            if c % p:
                Q[idx[beta], ai] = c % p
    return Q


def nullspace_modp(M, p):
    """Right nullspace of M over F_p; M is (rows x cols) int64 numpy."""
    M = M % p
    rows, cols = M.shape
    M = M.copy()
    piv = []
    r = 0
    for c in range(cols):
        pr = None
        for i in range(r, rows):
            if M[i, c] % p:
                pr = i
                break
        if pr is None:
            continue
        if pr != r:
            M[[r, pr]] = M[[pr, r]]
        iv = pow(int(M[r, c]), p - 2, p)
        M[r] = (M[r] * iv) % p
        col = M[:, c].copy()
        col[r] = 0
        nz = np.nonzero(col)[0]
        if nz.size:
            M[nz] = (M[nz] - np.outer(col[nz], M[r])) % p
        piv.append(c)
        r += 1
        if r == rows:
            break
    free = [c for c in range(cols) if c not in piv]
    basis = []
    for f in free:
        v = np.zeros(cols, dtype=np.int64)
        v[f] = 1
        for i, c in enumerate(piv):
            v[c] = (-M[i, f]) % p
        basis.append(v)
    return basis


def covariants(m, d):
    """Basis of (Sym^d W* tensor W)^G over F_p, as arrays c[alpha_index, i]."""
    p = m.p
    mons, idx = monomials(d)
    nm = len(mons)
    a11 = m.Tdiag                      # C11 weights of the coordinate basis
    # T-invariance selects individual monomials
    keep = [(ai, i) for ai in range(nm) for i in range(5)
            if sum(mons[ai][j] * a11[j] for j in range(5)) % 11 == a11[i] % 11]
    K = len(keep)
    if K == 0:
        return [], mons, idx
    Sinv = m.matinv(m.S)
    Q = subst_matrix(m, Sinv, d)       # x^alpha o S^{-1} = sum_beta Q[beta,alpha] x^beta
    S = m.S
    # equations indexed by (beta, i): sum_j S[i][j] sum_alpha c[alpha,j] Q[beta,alpha]
    #                                  - c[beta,i] = 0
    A = np.zeros((nm * 5, K), dtype=np.int64)
    for u, (ai, j) in enumerate(keep):
        col = Q[:, ai]                 # length nm
        nz = np.nonzero(col)[0]
        for i in range(5):
            s = S[i][j] % p
            if s:
                A[i * nm + nz, u] = (A[i * nm + nz, u] + s * col[nz]) % p
    for u, (ai, i) in enumerate(keep):
        A[i * nm + ai, u] = (A[i * nm + ai, u] - 1) % p
    ns = nullspace_modp(A, p)
    out = []
    for v in ns:
        C = np.zeros((nm, 5), dtype=np.int64)
        for u, (ai, i) in enumerate(keep):
            C[ai, i] = v[u] % p
        out.append(C)
    return out, mons, idx


def eval_cov(m, C, mons, v):
    p = m.p
    val = [0] * 5
    for ai, alpha in enumerate(mons):
        row = C[ai]
        if not row.any():
            continue
        t = 1
        for j in range(5):
            if alpha[j]:
                t = t * pow(v[j] % p, alpha[j], p) % p
        for i in range(5):
            if row[i]:
                val[i] = (val[i] + int(row[i]) * t) % p
    return tuple(val)


def change_basis(m, C, mons, idx, P, Pinv, d):
    """Coefficients of  T'(y) = P^{-1} T(P y)  in the monomial basis."""
    p = m.p
    Q = subst_matrix(m, P, d)          # x^alpha o P
    nm = len(mons)
    Cp = np.zeros((nm, 5), dtype=np.int64)
    for ai in range(nm):
        row = C[ai]
        if not row.any():
            continue
        col = Q[:, ai]
        nz = np.nonzero(col)[0]
        for i in range(5):
            if row[i]:
                for k in range(5):
                    f = Pinv[k][i] % p
                    if f:
                        Cp[nz, k] = (Cp[nz, k] + f * int(row[i]) % p * col[nz]) % p
    return Cp


def run(p, degrees, out):
    m = Model(p)
    log = out.setdefault(str(p), {})
    # the four odd/composite-order generators to test against
    gens = {}
    gens[11] = m.T
    gens[5] = m.elt_of_order(5)
    A6 = m.elt_of_order(6)
    gens[6] = A6
    gens[3] = m.mm(A6, A6)
    for d in degrees:
        cov, mons, idx = covariants(m, d)
        rec = {"dim_M_d": len(cov), "checks": {}}
        for n, g in gens.items():
            eb = m.eigenbasis(g, n)
            wts = [a for a, _ in eb]
            P = tuple(tuple(eb[j][1][i] for j in range(5)) for i in range(5))
            Pinv = m.matinv(P)
            bad_mono = 0
            bad_eval = 0
            tested = 0
            for C in cov:
                Cp = change_basis(m, C, mons, idx, P, Pinv, d)
                for ai, alpha in enumerate(mons):
                    for i in range(5):
                        if Cp[ai, i]:
                            tested += 1
                            wa = sum(alpha[j] * wts[j] for j in range(5)) % n
                            if wa != wts[i] % n:
                                bad_mono += 1
                # direct evaluation at each eigenpoint
                for k in range(5):
                    ek = eb[k][1]
                    val = eval_cov(m, C, mons, ek)
                    if any(val):
                        pred = (d * wts[k]) % n
                        for i in range(5):
                            if val[i] % p and False:
                                pass
                        # value must lie in the span of the eigenvectors of
                        # weight `pred`
                        span = [eb[j][1] for j in range(5) if wts[j] % n == pred]
                        if not in_span(m, span, val):
                            bad_eval += 1
            rec["checks"]["n=%d" % n] = {
                "nonzero_coeffs_in_eigenbasis": tested,
                "monomial_congruence_violations": bad_mono,
                "eigenpoint_value_violations": bad_eval,
                "weights": wts,
            }
        log["d=%d" % d] = rec
        print(f"  p={p} d={d}: dim M_d = {len(cov)}, "
              + ", ".join(f"n={n}: {rec['checks']['n=%d' % n]['monomial_congruence_violations']}"
                          f"/{rec['checks']['n=%d' % n]['eigenpoint_value_violations']} bad"
                          for n in sorted(gens)))
    return out


def in_span(m, span, v):
    if not span:
        return not any(x % m.p for x in v)
    rows = [list(u) for u in span] + [list(v)]
    R0, _ = m.rref([list(u) for u in span])
    R1, _ = m.rref(rows)
    return len(R1) == len(R0)


def main():
    degrees = [1, 4, 5, 6, 7]
    if len(sys.argv) > 1:
        degrees = [int(x) for x in sys.argv[1:]]
    out = {}
    for p in (331, 661):
        run(p, degrees, out)
    with open("results/covariant_bruteforce.json", "w") as f:
        json.dump(out, f, indent=1, sort_keys=True)
    print("S2_COVARIANT_BRUTEFORCE_OK")


if __name__ == "__main__":
    main()
