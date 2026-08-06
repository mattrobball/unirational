"""All A5 fixed-locus landing conditions on the covariant space M_d^{A5}.

For g in A5 and U = the lam-eigenspace of g, equivariance forces
T(U) subset E_{lam^d}(g).  Landing then forces the induced rational map
P(U) --> X cap P(E_{lam^d}) to have image in a variety with no rational
curves, so the map is CONSTANT (or T|_U == 0):

  target dim 1, F(target) != 0                     ->  T|_U == 0        [ZERO]
  target dim 2, F|_target != 0 (<= 3 points)       ->  T|_U = h.r       [RANK1]
  target dim 3, X cap P(target) a smooth cubic     ->  T|_U = h.q       [RANK1]
  F|_target == 0 (target inside X)                 ->  no condition

The loci used (a = involution, b = order 3):
  V+(a) dim 3 -> V+(a)                     always
  V-(a) dim 2 -> V+(a) if d even           (d odd: V- is in X, no condition)
  E_1(b) dim 1 -> E_1(b)                   always
  E_w(b)  dim 2 -> E_{w^d}(b)
  E_w2(b) dim 2 -> E_{w^{2d}}(b)
"""
import itertools
import numpy as np, sympy
from a5lib import mm, rref, inv_p, klein_F, monmat, monlist
from plane import eigspace, joint_eig, coord_solver
from fq import Fq, companion


def mons_m(d, m):
    """exponent tuples of degree d in m variables, deterministic order"""
    if m == 1:
        return [(d,)]
    out = []
    for i in range(d, -1, -1):
        for rest in mons_m(d - i, m - 1):
            out.append((i,) + rest)
    return out


def binary_cubic(B, p):
    """coefficients [c_{s^3}, c_{s^2 t}, c_{s t^2}, c_{t^3}] of F on span(B), dim B = 2"""
    pts = [(1, 0), (0, 1), (1, 1), (1, 2)]
    A = np.array([[pow(s, 3 - k, p) * pow(t, k, p) % p for k in range(4)] for s, t in pts],
                 dtype=np.float64)
    r = np.array([klein_F((np.array([s, t], dtype=np.float64) @ B) % p, p) for s, t in pts],
                 dtype=np.float64)
    return [int(v) % p for v in mm(inv_p(A, p), r[:, None], p).ravel()]


def factor_degrees(cb, p):
    x = sympy.symbols('x')
    poly = sympy.Poly(sum(sympy.Integer(cb[k]) * x ** (3 - k) for k in range(4)), x, modulus=p)
    return [(sympy.Poly(f, x, modulus=p)) for f, _ in sympy.factor_list(poly)[1]]


class Loci:
    def __init__(self, p, a, b, H):
        self.p, self.a, self.b = p, a % p, b % p
        V4 = [M for M in H if np.array_equal(mm(M, a, p), mm(a, M, p))]
        assert len(V4) == 4
        s1 = [M for M in V4 if not np.array_equal(M, np.eye(5))
              and not np.array_equal(M, a % p)][0]
        self.W0 = joint_eig([a, s1], [1, 1], p)
        self.W1 = joint_eig([a, s1], [1, -1], p)
        self.Vp = np.concatenate([self.W0, self.W1], axis=0) % p
        self.Vm = eigspace(a, p - 1, p)
        w = next(k for k in range(2, p) if pow(k, 3, p) == 1)
        self.w = w
        self.E1 = eigspace(b, 1, p)
        self.Ew = eigspace(b, w, p)
        self.Ew2 = eigspace(b, w * w % p, p)
        assert (self.W0.shape[0], self.W1.shape[0], self.Vm.shape[0]) == (2, 1, 2)
        assert (self.E1.shape[0], self.Ew.shape[0], self.Ew2.shape[0]) == (1, 2, 2)
        self.F_v0 = klein_F(self.E1[0], p)
        self.cb_W0 = binary_cubic(self.W0, p)
        self.cb_Ew = binary_cubic(self.Ew, p)
        self.cb_Ew2 = binary_cubic(self.Ew2, p)
        self.cb_Vm = binary_cubic(self.Vm, p)
        self.F_W1 = klein_F(self.W1[0], p)
        assert all(v % p == 0 for v in self.cb_Vm), 'P(V-) must lie on X'
        assert self.F_v0 % p != 0, 'F(v0) = 0 : the order-3 point condition fails'
        assert any(v % p for v in self.cb_W0)
        assert any(v % p for v in self.cb_Ew) and any(v % p for v in self.cb_Ew2)
        # --- the field: one block per irreducible factor of degree > 1 that we need
        degs = set()
        for cb in (self.cb_W0, self.cb_Ew, self.cb_Ew2):
            for f in factor_degrees(cb, p):
                if f.degree() > 1:
                    degs.add(f.degree())
        blocks, self.blockdeg = [], {}
        for dg in sorted(degs):
            f = None
            for cb in (self.cb_W0, self.cb_Ew, self.cb_Ew2):
                for ff in factor_degrees(cb, p):
                    if ff.degree() == dg:
                        f = ff
                        break
                if f is not None:
                    break
            co = [int(c) % p for c in f.all_coeffs()]
            co = [c * pow(co[0], p - 2, p) % p for c in co]
            self.blockdeg[dg] = len(blocks)
            blocks.append(companion(co, p))
        self.fq = Fq(p, blocks)

    # -------------------------------------------------- candidate branch points
    def _roots_of(self, cb):
        """roots [s:t] of a binary cubic, as pairs (s,t) over F_q"""
        p, fq = self.p, self.fq
        out = []
        if cb[0] % p == 0:
            out.append((fq.fp(1.0), fq.fp(0.0)))
        for f in factor_degrees(cb, p):
            dg = f.degree()
            co = [int(c) % p for c in f.all_coeffs()]
            co = [c * pow(co[0], p - 2, p) % p for c in co]
            if dg == 1:
                out.append((fq.fp(float((-co[1]) % p)), fq.one()))
            else:
                th = fq.gen(self.blockdeg[dg])
                for j in range(dg):
                    out.append((fq.frob(th, j), fq.one()))
        return out

    def Q_plane(self):
        """candidate q in V+ (coords w.r.t. self.Vp = (W0[0], W0[1], W1[0])):
        the V4-common-eigenvectors lying on C+."""
        fq, p = self.fq, self.p
        out = []
        if self.F_W1 % p == 0:
            q = fq.zero((3,)); q[2] = fq.one()
            out.append(('Wchi1', q))
        for i, (s, t) in enumerate(self._roots_of(self.cb_W0)):
            q = fq.zero((3,))
            q[0], q[1] = s, t
            out.append(('W0r%d' % i, q))
        return out

    def Q_line(self, cb):
        """candidate r in a 2-dim target: roots of its binary cubic"""
        fq = self.fq
        out = []
        for i, (s, t) in enumerate(self._roots_of(cb)):
            r = fq.zero((2,))
            r[0], r[1] = s, t
            out.append(('r%d' % i, r))
        return out

    # -------------------------------------------- pairwise plane intersections
    def pair_loci(self, H):
        """T vanishes identically on V+(a) cap V+(a') for every pair of distinct
        involutions a != a' of A5.

        Reason: T|_{V+(a)} = h_a . q_a with q_a in C+(a), and for a' = g a g^-1
        equivariance gives q_{a'} = g q_a; the map a -> q_a is A5-equivariant
        from the 15 involutions onto the A5-orbit of q.  That orbit has size 15
        in every branch (the stabiliser of q contains V4 and cannot be A4,
        because A4 acts without nonzero fixed vectors on W and with order 3 on
        P(W_chi0), so it moves every candidate q).  Hence a -> q_a is injective,
        q_a and q_{a'} are independent, and h_a = h_{a'} = 0 on the intersection.
        """
        p = self.p
        invs = [M for M in H if not np.array_equal(M % p, np.eye(5))
                and np.array_equal(mm(M, M, p), np.eye(5))]
        assert len(invs) == 15, len(invs)
        planes = [eigspace(M, 1, p) for M in invs]
        out, seen = [], set()
        for i in range(15):
            for j in range(i + 1, 15):
                A = np.concatenate([planes[i], planes[j]], axis=0) % p
                # intersection = { x : x in row(P_i) and x in row(P_j) }
                Ni = _perp(planes[i], p)
                Nj = _perp(planes[j], p)
                U = _nullrows(np.concatenate([Ni, Nj], axis=0), p)
                if U.shape[0] == 0:
                    continue
                key = tuple(sorted(tuple(int(t) for t in r)
                                   for r in rref(U, p)[0]))
                if key in seen:
                    continue
                seen.add(key)
                out.append(U)
        return out

    # ------------------------------------------------------ the condition list
    def conditions(self, d, H=None):
        """[(name, U, target, mode, candidates)] for degree d"""
        C = []
        C.append(('V+', self.Vp, self.Vp, 'RANK1', self.Q_plane()))
        if H is not None:
            for i, U in enumerate(self.pair_loci(H)):
                C.append(('P%d' % i, U, np.eye(5), 'ZERO', None))
        if d % 2 == 0:
            C.append(('V-', self.Vm, self.Vp, 'RANK1', self.Q_plane()))
        C.append(('E1', self.E1, self.E1, 'ZERO', None))
        for nm, U, e in (('Ew', self.Ew, 1), ('Ew2', self.Ew2, 2)):
            t = (e * d) % 3
            if t == 0:
                C.append((nm, U, self.E1, 'ZERO', None))
            else:
                Tg = self.Ew if t == 1 else self.Ew2
                cb = self.cb_Ew if t == 1 else self.cb_Ew2
                C.append((nm, U, Tg, 'RANK1', self.Q_line(cb)))
        return C


def deriv_matrices(d, p):
    """D[s] : (N x N') with  d/dx_s : S^d -> S^{d-1}  in the monomial bases."""
    mons, monsm = monlist(d), monlist(d - 1)
    idx = {m: j for j, m in enumerate(monsm)}
    D = [np.zeros((len(mons), len(monsm))) for _ in range(5)]
    for j, m in enumerate(mons):
        for s in range(5):
            if m[s]:
                e = list(m); e[s] -= 1
                D[s][j, idx[tuple(e)]] = m[s] % p
    return D


def jac_values(basis, mons, U, p, rng):
    """J[i, r, s, t] = dT_i^{(r)}/dx_s at the t-th interpolation point of U,
    together with the guarantee that vanishing at all t is equivalent to
    vanishing identically (the points interpolate degree d-1 forms on U)."""
    d = sum(mons[0])
    m = U.shape[0]
    mon_u = mons_m(d - 1, m)
    M = len(mon_u)
    Yi = None
    for _ in range(40):
        ys = rng.integers(0, p, size=(M, m)).astype(np.float64)
        Y = np.array([[int(np.prod([pow(int(y[t]), mu[t], p) for t in range(m)])) % p
                       for mu in mon_u] for y in ys])
        Yi = inv_p(Y, p)
        if Yi is not None:
            break
    assert Yi is not None, 'no interpolating point set on U'
    xs = mm(ys, U, p)
    Mx = monmat(xs, monlist(d - 1), p)                     # M x N'
    D = deriv_matrices(d, p)
    K = basis.shape[0]
    J = np.zeros((K, 5, 5, M))
    for s in range(5):
        Cder = np.tensordot(basis, D[s], axes=([2], [0])) % p       # (K,5,N')
        J[:, :, s, :] = np.tensordot(Cder, Mx, axes=([2], [1])) % p
    return J


def gradF(y, fq):
    """gradient of F(x) = sum x_i^2 x_{i+1} at y (entries over F_q)"""
    g = []
    for i in range(5):
        t = (fq.mul(y[i], y[(i + 1) % 5]) * 2 + fq.mul(y[(i - 1) % 5], y[(i - 1) % 5])) % fq.p
        g.append(t)
    return np.array(g)


def first_order_rows(J, qW, fq):
    """rows A[e, i] over F_q of  grad F(q)^T . DT(v) = 0  for all v in U."""
    n = gradF(qW, fq)                                     # (5,k)
    K, _, _, M = J.shape
    # A[i, s, t] = sum_r n[r] * J[i,r,s,t]
    A = np.einsum('rk,irst->istk', n, J) % fq.p
    return A.reshape(K, 5 * M, fq.k).transpose(1, 0, 2) % fq.p     # (rows, K, k)


def hessF(y, fq):
    """Hessian of F(x) = sum x_i^2 x_{i+1} at y, entries over F_q"""
    p = fq.p
    Hs = np.zeros((5, 5, fq.k))
    for i in range(5):
        Hs[i, i] = 2 * y[(i + 1) % 5] % p
        Hs[i, (i + 1) % 5] = (Hs[i, (i + 1) % 5] + 2 * y[i]) % p
        Hs[i, (i - 1) % 5] = (Hs[i, (i - 1) % 5] + 2 * y[(i - 1) % 5]) % p
    return Hs % p


def second_order_quadrics(basis, mons, U, qW, S, fq, nsamp, rng):
    """Second-order landing conditions on a contracted locus.

    On U we have T|_U = h.q with h != 0.  Expanding F(T(v + eps u)) = 0 in eps
    and using grad F(hq) = h^2 grad F(q), Hess F(hq) = h Hess F(q):

      eps^2 :  h(v) * gradF(q).T_2(v,u)  +  1/2 T_1(v,u)^t HessF(q) T_1(v,u) = 0

    with T_1 = DT_v(u), T_2 = 1/2 D^2T_v(u,u).  This is QUADRATIC in the
    coefficient vector.  Returns the quadric coefficient rows (nsamp, nmon)
    in the coordinates of the branch basis S (r x K x k), sampling random
    (v in U, u in W)."""
    p = fq.p
    d = sum(mons[0])
    r = S.shape[0]
    assert d + 1 <= p, 'need d+1 distinct eps values'
    n = gradF(qW, fq)
    Hq = hessF(qW, fq)
    # branch maps over F_q: Bm[l] = sum_i S[l,i] basis[i]   (r x 5 x N x k)
    Bm = np.transpose(np.tensordot(S, basis, axes=([1], [0])) % p, (0, 2, 3, 1))
    j0 = next(j for j in range(5) if np.any(qW[j] % p))
    qinv = fq.inv(qW[j0])
    monsl = list(itertools.combinations_with_replacement(range(r), 2))
    # T(v + eps u) is a polynomial of degree d in eps: recover T_0, T_1, T_2 by
    # interpolation at eps = 0..d (cheap: d+1 evaluations of the branch maps).
    eps = np.arange(d + 1, dtype=np.float64)
    VD = np.array([[pow(int(e), j, p) for j in range(d + 1)] for e in eps])
    VDi = inv_p(VD, p)
    assert VDi is not None
    rows = []
    for _ in range(nsamp):
        y = rng.integers(0, p, size=U.shape[0]).astype(np.float64)
        v = mm(y[None, :], U, p).ravel()
        u = rng.integers(0, p, size=5).astype(np.float64)
        pts = (v[None, :] + eps[:, None] * u[None, :]) % p
        MX = monmat(pts, mons, p)                                # (d+1) x N
        vals = np.einsum('linj,en->elij', Bm, MX) % p            # (d+1) x r x 5 x k
        coef = np.tensordot(VDi, vals, axes=([1], [0])) % p      # j x r x 5 x k
        T0, T1, T2 = coef[0], coef[1], coef[2]
        h = fq.mul(T0[:, j0, :], qinv[None, :])                  # r x k
        nT2 = np.einsum('rk,lrm,kmt->lt', n, T2, fq.tab) % p      # r x k  (n . T_2)
        A = fq.mul(h[:, None, :], nT2[None, :, :])                # r x r x k
        HT = np.einsum('ijk,ljm,kmt->lit', Hq, T1, fq.tab) % p    # r x 5 x k
        B = np.einsum('lik,jim,kmt->ljt', T1, HT, fq.tab) % p     # r x r x k
        Cq = (A + B * pow(2, p - 2, p)) % p
        Cq = (Cq + np.transpose(Cq, (1, 0, 2))) % p               # symmetrise
        vals = np.array([Cq[i, j] if i != j else Cq[i, i] * pow(2, p - 2, p) % p
                         for i, j in monsl]) % p
        rows.append(vals)
    return np.array(rows) % p, monsl


def apply_fq_rows(S, A, fq):
    """A: (rows, K, k) over F_q; impose sum_i c_i A[e,i] = 0 on the space S."""
    if S.shape[0] == 0 or A.shape[0] == 0:
        return S
    p = fq.p
    B = np.einsum('lia,eib,abt->elt', S, A, fq.tab, optimize=True) % p   # (rows, r, k)
    ns = fq.nullspace(B)
    if ns.shape[0] == 0:
        return np.zeros((0, S.shape[1], fq.k))
    return _compose(ns, S, fq)


def _perp(B, p):
    """rows spanning the annihilator of the row space of B (as linear forms)."""
    from plane import _nullbasis
    return _nullbasis(np.array(B) % p, B.shape[1], p)


def _nullrows(A, p):
    """basis of { x : A x = 0 } (A acts on column vectors), returned as rows."""
    from plane import _nullbasis
    return _nullbasis(np.array(A) % p, A.shape[1], p)


def restrict(basis, mons, U, Tg, p, rng):
    """R[i] = coefficients (n, M) of T_i|_U in the target basis Tg.

    U: m x 5 source basis, Tg: n x 5 target basis.  Asserts T_i(U) subset Tg."""
    d = sum(mons[0])
    m, n = U.shape[0], Tg.shape[0]
    mon_u = mons_m(d, m)
    M = len(mon_u)
    Yi = None
    for _ in range(40):
        ys = rng.integers(0, p, size=(M, m)).astype(np.float64)
        Y = np.array([[int(np.prod([pow(int(y[t]), mu[t], p) for t in range(m)])) % p
                       for mu in mon_u] for y in ys])
        Yi = inv_p(Y, p)
        if Yi is not None:
            break
    assert Yi is not None
    xs = mm(ys, U, p)
    Mx = monmat(xs, mons, p)
    tocoord = coord_solver(np.array(Tg) % p, p)
    out = np.zeros((basis.shape[0], n, M))
    for i, Cc in enumerate(basis):
        vals = mm(Mx, np.array(Cc, dtype=np.float64).T % p, p)
        coords = tocoord(vals)                       # asserts values lie in Tg
        out[i] = mm(Yi, coords, p).T % p
    return out


def apply_condition(S, R, cand, fq):
    """S: (r, K) basis over F_q of the current candidate space;
    R: (K, n, M) restriction coefficients over F_p;
    cand: None (ZERO mode) or (n,) vector over F_q (RANK1 mode).
    Returns the new basis (r', K) over F_q."""
    p = fq.p
    r, K = S.shape[0], S.shape[1]
    if r == 0:
        return S
    n, M = R.shape[1], R.shape[2]
    # RS[l,n,m] = sum_i S[l,i] * R[i,n,m]   -- R has F_p entries, so no mul table
    RS = np.transpose(np.tensordot(S, R, axes=([1], [0])), (0, 2, 3, 1)) % p   # (r,n,M,k)
    rows = []
    if cand is None:
        for nn in range(n):
            for mi in range(M):
                rows.append(RS[:, nn, mi, :])
    else:
        for s in range(n):
            for t in range(s + 1, n):
                for mi in range(M):
                    rows.append((fq.mul(RS[:, s, mi, :], cand[t][None, :])
                                 - fq.mul(RS[:, t, mi, :], cand[s][None, :])) % p)
    if not rows:
        return S
    A = np.stack(rows, axis=0) % p                                 # (rows, r, k)
    ns = fq.nullspace(A)                                           # (r', r, k)
    if ns.shape[0] == 0:
        return np.zeros((0, K, fq.k))
    return _compose(ns, S, fq)


def _compose(ns, S, fq):
    """ns: (r', r, k) coords in the S-basis -> (r', K, k)"""
    p = fq.p
    return np.einsum('ula,lib,abt->uit', ns, S, fq.tab, optimize=True) % p
