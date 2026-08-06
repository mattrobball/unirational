"""The fixed-plane reduction.

Let a be an involution of A5, W = V+ (dim 3) + V- (dim 2), V4 = C_{A5}(a).
For any A5-equivariant T of degree d,  T(V+) subset V+  (from T(av) = aT(v)),
so a landing T restricts to a map V+ -> cone over C+ := X cap P(V+).

FACTS (checked at both primes by probe_plane.py / stage2):
  * F|_{V-} == 0        (P(V-) is one of the 55 lines of X)
  * F|_{V+} != 0 and C+ is a SMOOTH plane cubic => genus 1 => there is no
    nonconstant rational map P(V+) --> C+.
Hence T|_{V+} == 0, or T|_{V+} = h . q with h a ternary d-form and q in C+.
V4-equivariance forces q to be a common V4-eigenvector of V+; as a V4-module
V+ = W_chi0 (dim 2, trivial) + W_chi1 (dim 1, sign), so the common
eigenvectors are P(W_chi0) together with the single point [W_chi1], and

   q  in  ( C+ cap P(W_chi0) )  union  ( {[W_chi1]} cap C+ )   -- at most 4 pts.

Branches are enumerated over F_p and over F_{p^k} for each irreducible factor
of the binary cubic F|_{W_chi0}.  On each branch the constraint on c is LINEAR.
"""
import numpy as np, sympy
from a5lib import mm, rref, inv_p, klein_F, monmat


def _nullbasis(A, ncols, p):
    R, piv = rref(A, p)
    free = [c for c in range(ncols) if c not in piv]
    ns = []
    for f in free:
        v = np.zeros(ncols)
        v[f] = 1
        for i, c in enumerate(piv):
            v[c] = (-R[i, f]) % p
        ns.append(v % p)
    return np.array(ns) if ns else np.zeros((0, ncols))


def eigspace(M, lam, p):
    return _nullbasis((np.array(M) - (lam % p) * np.eye(5)) % p, 5, p)


def joint_eig(mats, signs, p):
    A = np.concatenate([(np.array(M) - (s % p) * np.eye(5)) % p
                        for M, s in zip(mats, signs)], axis=0) % p
    return _nullbasis(A, 5, p)


def coord_solver(B, p):
    """B is r x n of rank r; return f(v) = coords z with z @ B = v."""
    r, n = B.shape
    cols = None
    for c in __import__('itertools').combinations(range(n), r):
        S = B[:, list(c)]
        Si = inv_p(S, p)
        if Si is not None:
            cols, Si_ = list(c), Si
            break
    assert cols is not None

    def f(V):
        V = np.atleast_2d(np.array(V, dtype=np.float64) % p)
        z = mm(V[:, cols], Si_, p)
        assert np.array_equal(mm(z, B % p, p), V % p), 'vector not in the span'
        return z
    return f


class PlaneData:
    """fixed-plane geometry of the involution a at one prime"""

    def __init__(self, p, a, H):
        self.p = p
        self.a = a % p
        V4 = [M for M in H if np.array_equal(mm(M, a, p), mm(a, M, p))]
        assert len(V4) == 4, len(V4)
        self.s1 = [M for M in V4 if not np.array_equal(M, np.eye(5))
                   and not np.array_equal(M, a % p)][0]
        self.Vm = eigspace(a, p - 1, p)
        W0 = joint_eig([a, self.s1], [1, 1], p)
        W1 = joint_eig([a, self.s1], [1, -1], p)
        assert W0.shape[0] == 2 and W1.shape[0] == 1, (W0.shape, W1.shape)
        self.W0, self.W1 = W0, W1
        self.Vp = np.concatenate([W0, W1], axis=0) % p     # plane basis (w0,w1,w2)
        pts2 = [(1, 0), (0, 1), (1, 1), (1, 2)]
        A2 = np.array([[pow(s, 3 - k, p) * pow(t, k, p) % p for k in range(4)]
                       for s, t in pts2], dtype=np.float64)
        r2 = np.array([klein_F((np.array([s, t], dtype=np.float64) @ W0) % p, p)
                       for s, t in pts2], dtype=np.float64)
        self.bincubic = [int(v) % p for v in
                         mm(inv_p(A2, p), r2[:, None], p).ravel()]
        self.F_W1 = klein_F(W1[0], p)
        self.Vm_on_X = all(klein_F((np.array([s, t], dtype=np.float64) @ self.Vm) % p, p) == 0
                           for s in range(p) for t in (0, 1))

    def branches(self):
        """[(label, k, q, Th)] : q is (3,k) coords over F_{p^k} in basis (1,th,...),
        Th = k x k matrix of multiplication by theta (identity block for k=1)."""
        p, out = self.p, []
        if self.F_W1 % p == 0:
            q = np.zeros((3, 1)); q[2, 0] = 1
            out.append(('Wchi1', 1, q, np.zeros((1, 1))))
        cb = self.bincubic
        assert any(v % p for v in cb), 'F|_{W_chi0} == 0 : plane argument invalid'
        if cb[0] % p == 0:                                  # root [s:t] = [1:0]
            q = np.zeros((3, 1)); q[0, 0] = 1
            out.append(('W0inf', 1, q, np.zeros((1, 1))))
        x = sympy.symbols('x')
        poly = sympy.Poly(sum(sympy.Integer(cb[k]) * x ** (3 - k) for k in range(4)),
                          x, modulus=p)
        for fac, _mult in sympy.factor_list(poly)[1]:
            f = sympy.Poly(fac, x, modulus=p)
            k = f.degree()
            if k == 0:
                continue
            co = [int(c) % p for c in f.all_coeffs()]
            co = [c * pow(co[0], p - 2, p) % p for c in co]       # monic
            Th = np.zeros((k, k))
            for j in range(k - 1):
                Th[j + 1, j] = 1
            for j in range(k):
                Th[j, k - 1] = (-co[k - j]) % p
            q = np.zeros((3, k))
            if k == 1:
                q[0, 0] = (-co[1]) % p                            # theta in F_p
                q[1, 0] = 1
                Th = np.array([[(-co[1]) % p]], dtype=np.float64)
            else:
                q[0, 1] = 1                                       # s = theta
                q[1, 0] = 1                                       # t = 1
            out.append(('W0deg%d' % k, k, q, Th))
        return out


def restriction_map(basis, mons, Vp, p, rng):
    """R[i] = coefficient array (3, M) of T_i|_{V+} in the plane basis Vp."""
    d = sum(mons[0])
    mon3 = [(i, j, d - i - j) for i in range(d, -1, -1) for j in range(d - i, -1, -1)]
    M = len(mon3)
    Yi = None
    for _ in range(30):
        ys = rng.integers(0, p, size=(M, 3)).astype(np.float64)
        Y = np.array([[pow(int(y[0]), m[0], p) * pow(int(y[1]), m[1], p)
                       * pow(int(y[2]), m[2], p) % p for m in mon3] for y in ys])
        Yi = inv_p(Y, p)
        if Yi is not None:
            break
    assert Yi is not None
    xs = mm(ys, Vp, p)
    Mx = monmat(xs, mons, p)
    tocoord = coord_solver(np.array(Vp) % p, p)
    out = np.zeros((basis.shape[0], 3, M))
    for i, C in enumerate(basis):
        vals = mm(Mx, np.array(C, dtype=np.float64).T % p, p)      # M x 5
        coords = tocoord(vals)                                     # M x 3 (asserts in-plane)
        out[i] = mm(Yi, coords, p).T % p
    return out, mon3


def branch_solution(R, q, Th, k, p):
    """F_p-nullspace of {R(c)_m parallel to q for all plane monomials m}.

    c in F_{p^k}^K written as sum_j c_{ij} theta^j; conditions are the three
    2x2 minors of [R_m | q].  Returns (dim over F_{p^k}, F_p nullspace basis)."""
    K, three, M = R.shape
    assert three == 3
    P = [np.eye(k)]
    for j in range(1, k):
        P.append(mm(P[-1], Th, p))
    rows = []
    for m in range(M):
        for (r, s) in ((0, 1), (0, 2), (1, 2)):
            blocks = []
            for i in range(K):
                alpha = (R[i, r, m] * q[s] - R[i, s, m] * q[r]) % p     # (k,)
                Mul = np.zeros((k, k))
                for j in range(k):
                    if alpha[j] % p:
                        Mul = (Mul + alpha[j] * P[j]) % p
                blocks.append(Mul)
            rows.append(np.concatenate(blocks, axis=1))
    A = np.concatenate(rows, axis=0) % p
    ns = _nullbasis(A, K * k, p)
    assert ns.shape[0] % k == 0, (ns.shape, k)
    return ns.shape[0] // k, ns
