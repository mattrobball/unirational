"""Shared geometry helpers: skew forms, Pfaffian adjoint, random points on V14."""
import random

import fp
import v14lib as V

PAIRS, PIDX, QUADS = V.PAIRS, V.PIDX, V.QUADS


def _matchings(n):
    out = []

    def rec(rem, prs):
        if not rem:
            perm = [x for pr in prs for x in pr]
            s = 1
            for i in range(len(perm)):
                for j in range(i + 1, len(perm)):
                    if perm[i] > perm[j]:
                        s = -s
            out.append((s, list(prs)))
            return
        a = rem[0]
        for k in range(1, len(rem)):
            rec(rem[1:k] + rem[k + 1:], prs + [(a, rem[k])])
    rec(list(range(n)), [])
    return out


MATCH6 = _matchings(6)

COMP = {}
for _Q in QUADS:
    _C = tuple(x for x in range(6) if x not in _Q)
    _perm = list(_Q) + list(_C)
    _s = 1
    for _i in range(6):
        for _j in range(_i + 1, 6):
            if _perm[_i] > _perm[_j]:
                _s = -_s
    COMP[_Q] = (_C, _s)


def skew(v15, p):
    """15-vector -> 6x6 skew matrix."""
    W = [[0] * 6 for _ in range(6)]
    for (i, j) in PAIRS:
        W[i][j] = v15[PIDX[(i, j)]] % p
        W[j][i] = (-v15[PIDX[(i, j)]]) % p
    return W


def pf(v15, p):
    """Pfaffian of the 6x6 skew form given by a 15-vector."""
    W = skew(v15, p)
    t = 0
    for s, prs in MATCH6:
        u = s
        for (i, j) in prs:
            u = u * W[i][j] % p
        t = (t + u) % p
    return t % p


def wedge_square(v15, p):
    """lambda /\\ lambda in Lambda^4, then contracted to a 15-vector in Lambda^2
    (the Pfaffian adjoint: spans rad(lambda) when rank = 4)."""
    out = [0] * 15
    for Q in QUADS:
        i, j, k, l = Q
        val = (v15[PIDX[(i, j)]] * v15[PIDX[(k, l)]]
               - v15[PIDX[(i, k)]] * v15[PIDX[(j, l)]]
               + v15[PIDX[(i, l)]] * v15[PIDX[(j, k)]]) % p
        C, s = COMP[Q]
        out[PIDX[C]] = (s * val) % p
    return out


def wedge(u, v, p):
    """u /\\ v in Lambda^2 U as a 15-vector."""
    return [(u[i] * v[j] - u[j] * v[i]) % p for (i, j) in PAIRS]


def is_decomposable(v15, p):
    i, j, k, l = 0, 1, 2, 3
    for Q in QUADS:
        i, j, k, l = Q
        val = (v15[PIDX[(i, j)]] * v15[PIDX[(k, l)]]
               - v15[PIDX[(i, k)]] * v15[PIDX[(j, l)]]
               + v15[PIDX[(i, l)]] * v15[PIDX[(j, k)]]) % p
        if val:
            return False
    return True


def plane_of(v15, p):
    """The 2-plane (basis) spanned by a nonzero decomposable 15-vector."""
    W = skew(v15, p)
    return fp.rowspace_basis(W, p)


def rand_points_V14(model, n, rng, tries=200000):
    """Random F_p-points of V14: pick u in P(U), require M \\cap (u /\\ U) != 0."""
    p = model.p
    pts = []
    Mrows = model.Mrows
    for _ in range(tries):
        if len(pts) >= n:
            break
        u = [rng.randrange(p) for _ in range(6)]
        if not any(u):
            continue
        # columns: u /\\ e_t (t=0..5, rank 5) together with M -> 15-space
        cols = [wedge(u, [1 if s == t else 0 for s in range(6)], p) for t in range(6)]
        cols += [Mrows[a] for a in range(10)]
        Mat = [[cols[c][r] for c in range(16)] for r in range(15)]
        ns = fp.nullspace(Mat, p)
        # a nullspace vector gives  sum a_t (u/\e_t) + sum b_a m_a = 0
        # the trivial one is a = u (since u/\u = 0); we want a second
        good = []
        for vec in ns:
            if any(vec[6:]):
                good.append(vec)
        for vec in good:
            om = [(-x) % p for x in _lincomb(Mrows, vec[6:], p)]
            if not any(om):
                continue
            if not is_decomposable(om, p):
                continue
            y = [om[c] for c in model.Mpiv]
            pts.append((u, om, y))
            break
    return pts


def _lincomb(rows, coefs, p):
    n = len(rows[0])
    out = [0] * n
    for c, r in zip(coefs, rows):
        if c:
            for i in range(n):
                out[i] = (out[i] + c * r[i]) % p
    return out


def in_M(om, ann, p):
    return all(sum(a[i] * om[i] for i in range(15)) % p == 0 for a in ann)
