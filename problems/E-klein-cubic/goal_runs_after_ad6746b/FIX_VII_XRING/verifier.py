"""FIX-VII-XRING independent verifier.

Deliberately re-derives everything from the PAYLOAD files by methods different
from the ones used to produce them:

  * group order      -- full multiplication-table closure of the stored 660
                        matrices (production used BFS on generators);
  * covariant dims   -- Molien / character projector, with h_d read off the
                        power series 1/det(1 - t g) (production solved a linear
                        system built from explicit symmetric-power matrices);
  * d=6 pair         -- equivariance tested pointwise at random v for all 660
                        group elements (production used coefficient algebra);
  * vanishing on C   -- membership in the *unsaturated* Jacobian ideal
                        (H, dH/dx_i) by linear algebra in F_p (production used
                        Macaulay2 normal forms modulo the saturated I_C).

Run:  python3 verifier.py [p]
"""
import json, os, re, sys
import numpy as np

HERE = os.path.dirname(os.path.abspath(__file__))
LOG = os.path.join(HERE, "results", "checks.log")


def vcheck(name, ok, note=""):
    line = "CHECK %s %s%s" % (name, "PASS" if ok else "FAIL",
                              ("  # " + note) if note else "")
    with open(LOG, "a") as f:
        f.write(line + "\n")
    print(line, flush=True)
    return ok


# ------------------------------------------------------- minimal modular LA

def _rref(A, p):
    A = (np.asarray(A, dtype=np.int64) % p).copy()
    m, n = A.shape
    piv, r = [], 0
    for c in range(n):
        if r >= m:
            break
        nz = np.nonzero(A[r:, c])[0]
        if nz.size == 0:
            continue
        i = r + int(nz[0])
        A[[r, i]] = A[[i, r]]
        A[r] = A[r] * pow(int(A[r, c]), p - 2, p) % p
        col = A[:, c].copy(); col[r] = 0
        w = np.nonzero(col)[0]
        if w.size:
            A[w] = (A[w] - np.outer(col[w], A[r])) % p
        piv.append(c); r += 1
    return A, piv


def _rank(A, p):
    return 0 if np.asarray(A).size == 0 else len(_rref(A, p)[1])


# --------------------------------------------------------------- polynomials

def monlist(d, nv=5):
    out = []
    def rec(pos, rem, cur):
        if pos == nv - 1:
            out.append(tuple(cur + [rem])); return
        for e in range(rem, -1, -1):
            rec(pos + 1, rem - e, cur + [e])
    rec(0, d, [])
    return out, {m: i for i, m in enumerate(out)}


TERM = re.compile(r"([0-9]+)((?:\*x[0-4](?:\^[0-9]+)?)*)$")


def parse_poly(s, p):
    """Parse the 'c*x0^2*x1+...' strings written into the payload."""
    out = {}
    if s.strip() in ("0", ""):
        return out
    for term in s.split("+"):
        m = TERM.match(term.strip())
        assert m, "unparsable term %r" % term
        c = int(m.group(1)) % p
        e = [0] * 5
        for v in re.finditer(r"x([0-4])(?:\^([0-9]+))?", m.group(2)):
            e[int(v.group(1))] += int(v.group(2) or 1)
        key = tuple(e)
        out[key] = (out.get(key, 0) + c) % p
    return {k: v for k, v in out.items() if v}


def peval(poly, V, p):
    """Evaluate a poly at rows of V (n x 5)."""
    n = V.shape[0]
    acc = np.zeros(n, dtype=np.int64)
    for m, c in poly.items():
        t = np.full(n, c % p, dtype=np.int64)
        for i, e in enumerate(m):
            for _ in range(e):
                t = t * V[:, i] % p
        acc = (acc + t) % p
    return acc


def pmul(a, b, p):
    out = {}
    for ma, ca in a.items():
        for mb, cb in b.items():
            k = tuple(x + y for x, y in zip(ma, mb))
            out[k] = (out.get(k, 0) + ca * cb) % p
    return {k: v for k, v in out.items() if v}


def pdiff(a, i, p):
    out = {}
    for m, c in a.items():
        if m[i]:
            mm = list(m); e = mm[i]; mm[i] -= 1
            v = c * e % p
            if v:
                out[tuple(mm)] = (out.get(tuple(mm), 0) + v) % p
    return {k: v for k, v in out.items() if v}


def to_vec(poly, d, p):
    mons, idx = monlist(d)
    v = np.zeros(len(mons), dtype=np.int64)
    for m, c in poly.items():
        v[idx[m]] = c % p
    return v


# ------------------------------------------------------------------- checks

def verify(p=397):
    tag = "" if p == 397 else "_p%d" % p
    G = json.load(open(os.path.join(HERE, "payload", "G660_p%d.json" % p)))
    mats = np.array(G["matrices"], dtype=np.int64) % p
    n = len(mats)

    # (1) group: full closure of the multiplication table, dets, F-invariance
    keys = {m.tobytes(): i for i, m in enumerate(mats)}
    prod = np.einsum('aij,bjk->abik', mats, mats) % p
    closed = all(prod[a, b].tobytes() in keys for a in range(n) for b in range(n))
    ident = any(np.array_equal(m, np.eye(5, dtype=np.int64)) for m in mats)
    inv_ok = all(any(prod[a, b].tobytes() ==
                     np.eye(5, dtype=np.int64).tobytes() for b in range(n))
                 for a in range(n))
    vcheck("V_group_closure_660" + tag, n == 660 and closed and ident and inv_ok,
           "n=%d closed=%s id=%s inverses=%s" % (n, closed, ident, inv_ok))

    rng = np.random.default_rng(11)
    V = rng.integers(1, p, size=(6, 5)).astype(np.int64)
    Fv = sum((V[:, i] ** 2 % p) * V[:, (i + 1) % 5] for i in range(5)) % p
    bad = 0
    for M in mats:
        W = V @ M.T % p
        FW = sum((W[:, i] ** 2 % p) * W[:, (i + 1) % 5] for i in range(5)) % p
        if not np.array_equal(FW, Fv):
            bad += 1
    vcheck("V_all_660_fix_F" + tag, bad == 0, "%d/%d violate F(gv)=F(v)" % (bad, n))

    # (2) covariant dimensions by the Molien / character projector
    DMAX = 12
    hs = np.zeros((n, DMAX + 1), dtype=np.int64)
    trs = np.zeros(n, dtype=np.int64)
    trinv = np.zeros(n, dtype=np.int64)
    for a, M in enumerate(mats):
        # det(1 - t M) as a degree-5 poly in t, by the Leverrier/Newton route:
        # use exact expansion over F_p via the characteristic polynomial.
        co = charpoly_det_1_minus_tM(M, p)
        hs[a] = series_inverse(co, DMAX, p)
        trs[a] = int(np.trace(M)) % p
        Minv = matinv5(M, p)
        trinv[a] = int(np.trace(Minv)) % p
    inv660 = pow(n % p, p - 2, p)
    dims = {"map": [], "polar": [], "triv": []}
    for d in range(1, DMAX + 1):
        h = hs[:, d] % p
        dims["map"].append(int(h @ trinv % p * inv660 % p))
        dims["polar"].append(int(h @ trs % p * inv660 % p))
        dims["triv"].append(int(h.sum() % p * inv660 % p))
    prod_dims = json.load(open(os.path.join(HERE, "payload", "cov_dims_p%d.json" % p)))
    ok = (dims["map"] == prod_dims["map"] and dims["polar"] == prod_dims["polar"])
    vcheck("V_dims_by_character_projector" + tag, ok,
           "map=%s polar=%s triv=%s" % (dims["map"], dims["polar"], dims["triv"]))
    ok456 = all(dims[k][d - 1] == prod_dims[k][d - 1]
                for k in ("map", "polar") for d in (4, 5, 6))
    vcheck("V_dims_d456" + tag, ok456,
           "d=4,5,6 map=%s polar=%s" % (dims["map"][3:6], dims["polar"][3:6]))
    ok_triv = all(dims["triv"][d - 1] == prod_dims["triv"][str(d)]
                  for d in (3, 4, 5, 6, 7))
    vcheck("V_invariant_dims" + tag, ok_triv, "triv d=1..12: %s" % dims["triv"])

    # (3) the d=6 map-type pair: equivariance pointwise, over all 660 elements
    doc = json.load(open(os.path.join(HERE, "payload", "pair_d6_p%d.json" % p)))
    pair = [[parse_poly(s, p) for s in row] for row in doc["pair"]]
    vcheck("V_pair_is_degree6" + tag,
           all(all(sum(m) == 6 for m in q) for row in pair for q in row),
           "%d covariants x 5 components" % len(pair))
    U = rng.integers(1, p, size=(8, 5)).astype(np.int64)
    worst = 0
    for T in pair:
        TU = np.stack([peval(q, U, p) for q in T], axis=1)         # (8,5)
        for M in mats:
            lhs = np.stack([peval(q, U @ M.T % p, p) for q in T], axis=1)
            rhs = TU @ M.T % p
            if not np.array_equal(lhs, rhs):
                worst += 1
    vcheck("V_pair_equivariant_all_660" + tag, worst == 0,
           "%d (covariant, g) pairs fail T(gv)=g T(v)" % worst)

    # (4) vanishing on C via the unsaturated Jacobian ideal of H
    F = {}
    for i in range(5):
        m = [0] * 5; m[i] += 2; m[(i + 1) % 5] += 1
        F[tuple(m)] = 1
    Hs = det5([[pdiff(pdiff(F, i, p), j, p) for j in range(5)] for i in range(5)], p)
    dH = [pdiff(Hs, i, p) for i in range(5)]
    rows = []
    for m in monlist(1)[0]:
        rows.append(to_vec(pmul(Hs, {m: 1}, p), 6, p))
    for i in range(5):
        for m in monlist(2)[0]:
            rows.append(to_vec(pmul(dH[i], {m: 1}, p), 6, p))
    Jac = np.array(rows, dtype=np.int64)
    rk = _rank(Jac, p)
    bad = []
    for t, T in enumerate(pair):
        for j, q in enumerate(T):
            if _rank(np.vstack([Jac, to_vec(q, 6, p)[None, :]]), p) != rk:
                bad.append((t, j))
    vcheck("V_pair_in_jacobian_ideal_of_H" + tag, not bad,
           "dim (H,dH)_6 = %d; failures=%s" % (rk, bad))

    return dims


def matinv5(M, p):
    A = np.concatenate([M % p, np.eye(5, dtype=np.int64)], axis=1)
    R, piv = _rref(A, p)
    assert piv == list(range(5))
    return R[:, 5:] % p


def charpoly_det_1_minus_tM(M, p):
    """Coefficients c_0..c_5 of det(I - t M) in F_p, by exact 5x5 expansion."""
    import itertools
    co = [0] * 6
    for perm in itertools.permutations(range(5)):
        sgn = 1
        seen = [False] * 5
        for i in range(5):
            if seen[i]:
                continue
            j, ln = i, 0
            while not seen[j]:
                seen[j] = True; j = perm[j]; ln += 1
            if ln % 2 == 0:
                sgn = -sgn
        # entry (i,perm[i]) of (I - tM) is delta - t*M[i,perm[i]]
        poly = [1]
        for i in range(5):
            a = 1 if i == perm[i] else 0
            b = (-int(M[i, perm[i]])) % p
            new = [0] * (len(poly) + 1)
            for k, c in enumerate(poly):
                new[k] = (new[k] + c * a) % p
                new[k + 1] = (new[k + 1] + c * b) % p
            poly = new
        for k, c in enumerate(poly):
            co[k] = (co[k] + sgn * c) % p
    return co


def series_inverse(co, dmax, p):
    """Power-series inverse of sum co[k] t^k (co[0]=1) up to t^dmax."""
    assert co[0] % p == 1
    h = [0] * (dmax + 1)
    h[0] = 1
    for d in range(1, dmax + 1):
        s = 0
        for k in range(1, min(d, len(co) - 1) + 1):
            s = (s + co[k] * h[d - k]) % p
        h[d] = (-s) % p
    return h


def det5(M, p):
    import itertools
    tot = {}
    for perm in itertools.permutations(range(5)):
        sgn = 1
        seen = [False] * 5
        for i in range(5):
            if seen[i]:
                continue
            j, ln = i, 0
            while not seen[j]:
                seen[j] = True; j = perm[j]; ln += 1
            if ln % 2 == 0:
                sgn = -sgn
        term = {(0, 0, 0, 0, 0): 1}
        for i in range(5):
            term = pmul(term, M[i][perm[i]], p)
            if not term:
                break
        for k, c in term.items():
            tot[k] = (tot.get(k, 0) + sgn * c) % p
    return {k: v for k, v in tot.items() if v}


if __name__ == "__main__":
    verify(int(sys.argv[1]) if len(sys.argv) > 1 else 397)
