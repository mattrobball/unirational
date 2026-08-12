"""The genus-0 closed test at order 11, and the tower menus that support it.

Genus-0 branch of C14: fibres of q over the five C11-points of X are rational
and connected, so Rq_*O = O_X near them and tr_j = 1.  The identity family
then reads, for every twist k,

    sum_{sites z of Z^g}  w_k(value(z)) * AB(z)  =  sum_j  z^{-k a_j} / D^X_j
                                                 =  chi_g(X, O_X(k)) ,

whose right side is the sealed anchor (A4).  Grouping the left side by value,
with  M(W) = total localization mass landing on the eigenpoint of weight W,

    E_k := sum_{W in QR} z^{-k W} M(W) - chi_g(X, O_X(k)) ,

and the test is E_1 = E_2 = E_3 = 0 (E_0 = 0 holds for every tower).
The SHARPER local form (all twists k = 0..10) is M(W) = 1/D^X_{j(W)}.

N_G(C11) = C11:C5 acts transitively on the five points, so the tower over
e_k is the A_k-multiple of the tower over e_0 and the AB terms transform by
the Galois automorphism sigma_{A_k}.  Everything is therefore enumerated over
e_0 alone and then transported.
"""
import cyclo as C
import l12core as L
import towers as T

N = 11
QRL = sorted(L.QR)


# ------------------------------------------------------- subtree enumeration
def _key(site, depth):
    if site.kind == "pt":
        return ("pt", tuple(sorted(site.data)), site.vw, depth)
    return ("comp", tuple(sorted(site.data[0])), site.data[1], site.vw, depth)


_MEMO = {}


def subtree_vectors(site, depth, cap=4000):
    """Set of achievable value-mass vectors (dict weight -> element) for the
    sub-tower rooted at `site`, using closed towers of blowup depth <= depth.

    Returns (list_of_vectors, status) where status is
      'closed'   at least one closed sub-tower exists,
      'open'     none within the depth budget,
      'blocked'  a positive-dimensional fixed component is undefined
                 (cannot be resolved by further POINT blowups; FLAG-T).
    """
    k = _key(site, depth)
    if k in _MEMO:
        return _MEMO[k]

    if site.defined():
        v = {w: (C.zero(), 0) for w in QRL}
        v[site.vw] = (site.term(), 1)
        res = ([v], "closed")
        _MEMO[k] = res
        return res

    if site.kind == "comp":
        res = ([], "blocked")
        _MEMO[k] = res
        return res

    if depth <= 0:
        res = ([], "open")
        _MEMO[k] = res
        return res

    vecs = []
    status = "open"
    for mu in range(1, N):
        kids = T.blowup(site, mu)
        parts = []
        ok = True
        for kd in kids:
            vs, st = subtree_vectors(kd, depth - 1, cap)
            if st == "blocked" and status != "closed":
                status = "blocked"
            if not vs:
                ok = False
                break
            parts.append(vs)
        if not ok:
            continue
        # Minkowski sum over the children
        acc = [{w: (C.zero(), 0) for w in QRL}]
        for ps in parts:
            new = []
            for a in acc:
                for b in ps:
                    new.append({w: (C.add(a[w][0], b[w][0]), a[w][1] + b[w][1])
                                for w in QRL})
                    if len(new) > cap:
                        break
                if len(new) > cap:
                    break
            acc = new
        for a in acc:
            vecs.append(a)
        status = "closed"
    # dedup
    seen = set()
    ded = []
    for v in vecs:
        kk = tuple(v[w] for w in QRL)
        if kk in seen:
            continue
        seen.add(kk)
        ded.append(v)
    res = (ded, status if ded else status)
    _MEMO[k] = res
    return res


# ------------------------------------------------------------------ assembly
def tower_over_e0(d, mu1, depth):
    """All achievable value-mass vectors over e_0 for level-0 multiplicity mu1."""
    root = T.Site("pt", L.tangent_P4(0), (d * L.A[0]) % N, ())
    assert not root.defined(), "e_0 not a base point: mu1 is not forced"
    kids = T.blowup(root, mu1)
    parts = []
    blocked = False
    for kd in kids:
        vs, st = subtree_vectors(kd, depth)
        if st == "blocked":
            blocked = True
        if not vs:
            return [], ("blocked" if blocked else "open")
        parts.append(vs)
    acc = [{w: (C.zero(), 0) for w in QRL}]
    for ps in parts:
        new = []
        for a in acc:
            for b in ps:
                new.append({w: (C.add(a[w][0], b[w][0]), a[w][1] + b[w][1])
                            for w in QRL})
        acc = new
    seen = set()
    ded = []
    for v in acc:
        kk = tuple(v[w] for w in QRL)
        if kk in seen:
            continue
        seen.add(kk)
        ded.append(v)
    return ded, ("closed" if not blocked else "closed+blockedbranches")


def globalize(v0):
    """M(W) over all five points, from the e_0 vector by N-equivariance.

    Returns (M, counts) with counts[W] = #terminal sites with value W (= n_W).
    """
    M = {w: C.zero() for w in QRL}
    cnt = {w: 0 for w in QRL}
    for s in QRL:                       # s = A_k runs over QR
        for w in QRL:
            t = (s * w) % N
            M[t] = C.add(M[t], C.sigma(v0[w][0], s))
            cnt[t] += v0[w][1]
    return M, cnt


def residuals(M):
    """E_k for k = 0,1,2,3 and the sharper local residuals."""
    E = []
    for k in range(4):
        s = C.total([C.mul(C.zpow(-k * w), M[w]) for w in QRL])
        E.append(C.sub(s, L.chi_OX(k)))
    loc = {w: C.sub(M[w], C.inv(L.D_X(L.WEIGHT_INDEX[w]))) for w in QRL}
    return E, loc


def implied_traces(M):
    """tr_j forced by the FULL twist family:  tr_j = D^X_j * M(a_j)."""
    return {w: C.mul(L.D_X(L.WEIGHT_INDEX[w]), M[w]) for w in QRL}
