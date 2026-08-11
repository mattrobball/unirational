"""Lever 1: the A4-adapted jet at an A4-point of P(W).

Set-up (everything below is verified from the exact matrices at p = 331, 661):

  q  = an A4-point of P(W),  Stab_G(q) = A4,  <q> = the character omega of A4;
  W|_{A4} = omega + omega^2 + Theta,  Theta = the 3-dimensional irreducible,
  Theta = the sum of the three NON-trivial V4-eigenspaces of W  (so that
  <q> + <q'> = W^{V4} = the span of ell_V);
  U  = the A4-stable complement of <q> in W  =  <q'> + Theta;
  N  = the projective normal space at q  =  omega^{-1} (x) U.

For v = q + w (w in U) and h in A4,  h.v = omega(h)(q + psi_h w) with
psi_h w = omega(h)^{-1} h w, so writing T(q + w) = sum_k Phi_k(w) and letting
Phi = Phi_{mu} be the first non-zero term (mu = mult_q(T)),

    (*)   Phi(psi_h w) = omega(h)^{-d} h Phi(w)      for all h in A4,
    (**)  F(Phi(w)) = 0 identically                  (lowest order of F o T = 0).

So [Phi] : P(N) --> X is an A4-equivariant rational map of degree mu.

Weight dictionary (h of order 3, omega(h)-weights; q has C3-weight a_q):
a vector of Theta of C3-weight b sits in N with RELATIVE weight b - a_q, and

    h . Phi(theta_b^mu)  =  omega(h)^{ d*a_q + mu*(b - a_q) } Phi(theta_b^mu).

For the omega-point (a_q = 1) the three C3-fixed loci of P(N) are
    b = 1  ->  relative weight 0 : the direction of the C3-EIGENLINE through q
    b = 2  ->  relative weight 1 : the P^1 = immune row `pt_A4 dim1`
    b = 0  ->  relative weight 2 : the point   = immune row `pt_A4 dim0`
and the value of the dim-1 row is [Phi(theta_2^mu)], because theta_2 lies on
that P^1.  Everything therefore lives inside Sym^mu Theta.
"""

from s3core import Model


class A4Point:
    """All data attached to one A4-point q of P(W)."""

    def __init__(self, m, which=0):
        self.m = m
        p = m.p
        A6 = m.elt_of_order(6)
        h = m.mm(A6, A6)
        assert m.order[h] == 3
        self.h, hi = h, m.matinv(h)
        invols = [A for A in m.G if m.order[A] == 2]
        v4 = None
        for a in invols:
            b = m.mm(m.mm(h, a), hi)
            c = m.mm(m.mm(h, b), hi)
            if b != a and m.mm(a, b) == m.mm(b, a) and m.mm(a, b) == c:
                v4 = (a, b, m.mm(a, b))
                break
        assert v4 is not None
        self.V4 = v4
        self.A4 = closure(m, [h, v4[0]])
        assert len(self.A4) == 12, len(self.A4)

        # ell_V = W^{V4} (2-dim), Theta = sum of the non-trivial V4-eigenspaces
        ell = inter(m, m.eigsp(v4[0], 1), m.eigsp(v4[1], 1))
        assert len(ell) == 2
        self.ell = ell
        th = []
        for s0 in (1, p - 1):
            for s1 in (1, p - 1):
                if s0 == 1 and s1 == 1:
                    continue
                E = inter(m, m.eigsp(v4[0], s0), m.eigsp(v4[1], s1))
                assert len(E) == 1
                th.append(E[0])
        assert len(th) == 3
        self.Theta = tuple(th)

        # the two A4-points inside ell_V
        z3 = m.root(3)
        self.z3 = z3
        pts = {}
        for a in (1, 2):
            E = m.eigsp(h, pow(z3, a, p))
            cand = inter(m, E, ell)
            assert len(cand) == 1
            pts[a] = cand[0]
        self.a_q = (1, 2)[which]
        self.q = pts[self.a_q]
        self.qp = pts[3 - self.a_q]
        self.U = (self.qp,) + self.Theta

        # h-eigenvectors of Theta, indexed by C3-weight
        self.theta = {}
        for b in (0, 1, 2):
            E = m.eigsp(h, pow(z3, b, p))
            cand = inter(m, E, self.Theta)
            assert len(cand) == 1, (b, len(cand))
            self.theta[b] = cand[0]

        # C3-eigenlines of W and the X^{C6} point on each
        self.eigline = {w: m.eigsp(h, pow(z3, w, p)) for w in (1, 2)}
        self.C6 = m.centralizer(h)
        g = next(A for A in self.C6 if m.order[A] == 6)
        self.g = g
        z6 = m.root(6)
        self.C6pt = {}
        for b in range(6):
            E = m.eigsp(g, pow(z6, b, p))
            if len(E) == 1 and m.onX(E[0]):
                self.C6pt[b % 3] = E[0]
        assert set(self.C6pt) == {1, 2}, sorted(self.C6pt)

    def omega(self, h):
        """the scalar by which h in A4 acts on <q>."""
        m = self.m
        v = m.act(h, self.q)
        k = next(i for i in range(5) if self.q[i] % m.p)
        return v[k] * m.inv(self.q[k]) % m.p

    def X_on_eigenline(self, w):
        """all geometric points of X on the weight-w C3-eigenline, F_p-rational
        ones listed; returns (list of vectors, index of the X^{C6} point)."""
        m = self.m
        B = self.eigline[w]
        pts = []
        for s in range(m.p):
            v = tuple((B[0][i] + s * B[1][i]) % m.p for i in range(5))
            if m.onX(v):
                pts.append(v)
        if m.onX(B[1]):
            pts.append(B[1])
        c6 = self.C6pt[w]
        ic6 = next((i for i, v in enumerate(pts) if prop(m, v, c6)), None)
        return pts, ic6


# ------------------------------------------------------------ small helpers
def closure(m, gens):
    S, fr = {m.Id}, [m.Id]
    while fr:
        nf = []
        for A in fr:
            for g in gens:
                B = m.mm(A, g)
                if B not in S:
                    S.add(B)
                    nf.append(B)
        fr = nf
    return sorted(S)


def inter(m, U, V):
    if not U or not V:
        return ()
    pu = m.nullspace([list(u) for u in U])
    pv = m.nullspace([list(v) for v in V])
    return m.nullspace([list(x) for x in pu] + [list(x) for x in pv])


def prop(m, v, w):
    k = next((i for i in range(5) if w[i] % m.p), None)
    if k is None or v[k] % m.p == 0:
        return False
    c = w[k] * m.inv(v[k]) % m.p
    return all((w[i] - c * v[i]) % m.p == 0 for i in range(5))


def coords_in(m, B, v):
    n = len(B)
    rows = [[B[j][i] for j in range(n)] + [v[i]] for i in range(5)]
    R, piv = m.rref(rows, n + 1)
    assert n not in piv, "vector not in the span"
    sol = [0] * n
    for r, c in enumerate(piv):
        sol[c] = R[r][n]
    return sol


def monomials3(mu):
    return [(a, b, mu - a - b) for a in range(mu + 1) for b in range(mu + 1 - a)]


def subst_matrix(m, M, mu, mons, idx):
    """Q[beta][alpha] = coeff of t^beta in prod_k ( sum_j M[k][j] t_j )^{alpha_k}."""
    p = m.p
    nm = len(mons)
    Q = [[0] * nm for _ in range(nm)]
    for ai, al in enumerate(mons):
        cur = {(0, 0, 0): 1}
        for k in range(3):
            for _ in range(al[k]):
                nxt = {}
                for b, c in cur.items():
                    for j in range(3):
                        cf = M[k][j] % p
                        if cf:
                            nb = list(b)
                            nb[j] += 1
                            nxt[tuple(nb)] = (nxt.get(tuple(nb), 0) + c * cf) % p
                cur = nxt
        for b, c in cur.items():
            if c % p:
                Q[idx[b]][ai] = c % p
    return Q


def nullspace_rows(m, rows, n):
    if not rows:
        return [tuple(int(i == j) for i in range(n)) for j in range(n)]
    R, piv = m.rref(rows, n)
    free = [c for c in range(n) if c not in piv]
    out = []
    for f in free:
        v = [0] * n
        v[f] = 1
        for i, c in enumerate(piv):
            v[c] = (-R[i][f]) % m.p
        out.append(tuple(v))
    return out


# --------------------------------------------------- the equivariant space
def equivariant_space(m, ap, mu, dmod3):
    """Basis of {Phi : Sym^mu Theta -> W  satisfying (*)}, as C[mon][i]."""
    p = m.p
    Tb = ap.Theta
    mons = monomials3(mu)
    idx = {mm: i for i, mm in enumerate(mons)}
    nm = len(mons)
    varlist = [(a, i) for a in range(nm) for i in range(5)]
    vidx = {v: k for k, v in enumerate(varlist)}
    nv = len(varlist)
    rows = []
    for h in (ap.h, ap.V4[0]):
        om = ap.omega(h)
        omi = m.inv(om)
        M = [[0] * 3 for _ in range(3)]
        for j in range(3):
            v = tuple(x * omi % p for x in m.act(h, Tb[j]))
            cj = coords_in(m, Tb, v)
            for k in range(3):
                M[k][j] = cj[k]
        Q = subst_matrix(m, M, mu, mons, idx)
        tw = pow(omi, dmod3, p)
        for beta in range(nm):
            for i in range(5):
                vec = [0] * nv
                for alpha in range(nm):
                    if Q[beta][alpha]:
                        vec[vidx[(alpha, i)]] = (vec[vidx[(alpha, i)]]
                                                 + Q[beta][alpha]) % p
                for j in range(5):
                    cf = tw * h[i][j] % p
                    if cf:
                        vec[vidx[(beta, j)]] = (vec[vidx[(beta, j)]] - cf) % p
                if any(vec):
                    rows.append(vec)
    ns = nullspace_rows(m, rows, nv)
    out = []
    for sol in ns:
        C = [[0] * 5 for _ in range(nm)]
        for (a, i), k in vidx.items():
            C[a][i] = sol[k]
        out.append(C)
    return out, mons, idx


def eval_phi(m, C, mons, t):
    p = m.p
    val = [0] * 5
    for ai, al in enumerate(mons):
        c = 1
        for j in range(3):
            if al[j]:
                c = c * pow(t[j] % p, al[j], p) % p
        if c:
            for i in range(5):
                if C[ai][i]:
                    val[i] = (val[i] + C[ai][i] * c) % p
    return tuple(val)


def F_of_phi(m, C, mons, mu):
    """The coefficient vector of  F(Phi(t))  (a form of degree 3*mu in t),
    as a dict monomial -> value.  Used for the landing condition (**)."""
    p = m.p
    # build the 5 component polynomials as dicts
    comp = []
    for i in range(5):
        d = {}
        for ai, al in enumerate(mons):
            if C[ai][i]:
                d[al] = C[ai][i] % p
        comp.append(d)

    def mul(a, b):
        out = {}
        for ka, va in a.items():
            for kb, vb in b.items():
                k = (ka[0] + kb[0], ka[1] + kb[1], ka[2] + kb[2])
                out[k] = (out.get(k, 0) + va * vb) % p
        return {k: v for k, v in out.items() if v % p}

    tot = {}
    for i in range(5):
        t = mul(mul(comp[i], comp[i]), comp[(i + 1) % 5])
        for k, v in t.items():
            tot[k] = (tot.get(k, 0) + v) % p
    return {k: v for k, v in tot.items() if v % p}
