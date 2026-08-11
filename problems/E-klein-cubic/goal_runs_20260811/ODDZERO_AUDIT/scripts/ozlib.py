"""ODDZERO_AUDIT -- independent rebuild library.

Everything here is built from the raw 660-element matrix group (psl211.Model)
only.  No STAGE1 / STAGE1_TIGHTEN code is imported.

Two layers:
  (I)  the sigma-local stabilized-strata poset under the two dimension-3
       divisor rows D_{P_sigma} (exc. divisor over the plus-plane P(W+_s)) and
       D_{L-_sigma} (exc. divisor over the minus-line P(W-_s)), rebuilt as
       *interleaved flags*  0 <= A_0 <= U_1 <= A_1 <= ... <= U_k <= A_k <= W ;
  (II) the order-0 value / module structure of those two rows, computed in
       explicit sigma-adapted coordinates (u0,u1,u2) on W+ and (v0,v1) on W-,
       by brute-force polynomial linear algebra over F_p.
"""
import itertools, os, sys
from collections import defaultdict

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from psl211 import Model  # noqa: E402


# ===========================================================================
#  Layer 0: group + arrangement
# ===========================================================================
class Ambient:
    def __init__(self, p):
        self.m = Model(p)
        self.p = p
        self.W = tuple(tuple(int(i == j) for j in range(5)) for i in range(5))
        self._arrangement()

    def _arrangement(self):
        m, p = self.m, self.p
        roots = {n: [x for x in range(1, p) if pow(x, n, p) == 1]
                 for n in (2, 3, 5, 6, 11)}
        sp = set()
        for A in m.G:
            n = m.order[A]
            if n == 1:
                continue
            for lam in roots[n]:
                E = m.eigsp(A, lam)
                if E and len(E) < 5:
                    sp.add(E)
        changed = True
        while changed:
            changed = False
            for U, V in itertools.combinations(sorted(sp), 2):
                I = m.inter(U, V)
                if I and I not in sp:
                    sp.add(I)
                    changed = True
        self.A = sorted(sp)
        self.Aset = set(self.A)
        self.byd = defaultdict(list)
        for U in self.A:
            self.byd[len(U)].append(U)

    # --- subspace helpers (canonical rref bases throughout) ---
    def sub(self, U, V):
        """U subseteq V"""
        if not U:
            return True
        if not V:
            return False
        return self.m.rank([list(x) for x in U] + [list(y) for y in V]) == len(V)

    def span(self, *Us):
        rows = [list(x) for U in Us for x in U]
        return self.m.canon(rows) if rows else ()

    def gact(self, g, U):
        return self.m.canon([list(self.m.act(g, v)) for v in U]) if U else ()

    def scalar_on(self, g, lo, hi):
        """does g act by a scalar on hi/lo ?  (g must preserve lo and hi)"""
        m = self.m
        if len(hi) - len(lo) <= 0:
            return True
        for lam in self.eigvals(g):
            E = m.eigsp(g, lam)
            EL = self.span(E, lo) if lo else E
            if self.sub(hi, EL):
                return True
        return False

    def eigvals(self, g):
        m = self.m
        if not hasattr(self, "_evc"):
            self._evc = {}
        if g not in self._evc:
            n = m.order[g]
            self._evc[g] = [x for x in range(1, self.p)
                            if pow(x, n, self.p) == 1 and m.eigsp(g, x)]
        return self._evc[g]

    def scalar_value(self, g, lo, hi):
        """the scalar by which g acts on hi/lo (assumes it is scalar)."""
        m = self.m
        for lam in self.eigvals(g):
            E = m.eigsp(g, lam)
            EL = self.span(E, lo) if lo else E
            if self.sub(hi, EL):
                return lam
        return None


# ===========================================================================
#  Layer I: components as interleaved flags
# ===========================================================================
class Comp:
    """interleaved flag  0=U_0 <= A_0 <= U_1 <= ... <= U_k <= A_k <= U_{k+1}=W."""
    __slots__ = ("U", "A", "H", "key")

    def __init__(self, U, A, H):
        self.U = U          # (U_1,...,U_k)   members of the arrangement
        self.A = A          # (A_0,...,A_k)   lifted slot spaces
        self.H = H          # pointwise stabilizer (frozenset of matrices)
        self.key = (U, A)

    def dim(self):
        Us = [()] + list(self.U)
        return sum(len(self.A[i]) - len(Us[i]) - 1 for i in range(len(self.A)))

    def slots(self):
        """[(lo_i, A_i)]"""
        Us = [()] + list(self.U)
        return [(Us[i], self.A[i]) for i in range(len(self.A))]


class Band:
    """the components lying in the closure of a given top component."""

    def __init__(self, amb):
        self.amb = amb
        self.m = amb.m

    # ---------- pointwise stabilizer of an interleaved flag ----------
    def pointwise(self, U, A):
        amb, m = self.amb, self.m
        Us = [()] + list(U)
        out = []
        for g in m.G:
            ok = True
            for X in list(U) + list(A):
                if amb.gact(g, X) != X:
                    ok = False
                    break
            if not ok:
                continue
            for i in range(len(A)):
                if not amb.scalar_on(g, Us[i], A[i]):
                    ok = False
                    break
            if ok:
                out.append(g)
        return frozenset(out)

    # ---------- validity of an interleaved flag ----------
    def valid(self, U, A, H):
        """(a) each slot's generic point avoids every arrangement member
               strictly between U_i and U_{i+1};
           (b) exactness: A_i is the FULL H-eigenspace of U_{i+1}/U_i, so the
               generic point's stabilizer is exactly H;
           (c) the chain is exactly the set of arrangement members the point
               degenerates into."""
        amb = self.amb
        Us = [()] + list(U)
        His = list(U) + [amb.W]
        # (c) openness: if H acts by the SAME character on two consecutive slots
        #     the point is not a separate orbit-type stratum -- it can be
        #     deformed inside the constant-stabilizer locus that drops U_{i+1}
        #     from the chain, so it lies in the closure of a bigger stratum
        #     with the same H.  (Derived, not assumed: sigma acts trivially on
        #     the whole of E_{W-_sigma}, so E_pt & E_{W-_sigma} is NOT its own
        #     H=<sigma> stratum.)
        chis = []
        for i in range(len(A)):
            ch = tuple(amb.scalar_value(h, Us[i], A[i]) for h in sorted(H))
            if any(c is None for c in ch):
                return False
            chis.append(ch)
        for i in range(1, len(A)):
            if chis[i - 1] == chis[i]:
                return False
        for i in range(len(A)):
            lo, hi = Us[i], His[i]
            for V in amb.A:
                if V == hi or V == lo:
                    continue
                if hi != amb.W and not amb.sub(V, hi):
                    continue
                if lo and not amb.sub(lo, V):
                    continue
                if amb.sub(A[i], V):
                    return False           # slot buried in a deeper member
            # exactness: A_i must be a maximal subspace of hi containing lo on
            # which H acts by a scalar
            if not self.maximal_eigen(H, lo, hi, A[i]):
                return False
        return True

    def maximal_eigen(self, H, lo, hi, Ai):
        """Ai == lo + (the H-character eigenspace of hi/lo containing Ai/lo)"""
        amb, m = self.amb, self.m
        # build the H-isotypic piece of hi/lo containing Ai/lo:
        # intersect, over h in H, the eigenspace of h on hi/lo for the scalar h
        # acts by on Ai/lo.
        cur = hi
        for h in H:
            if h == m.Id:
                continue
            lam = amb.scalar_value(h, lo, Ai)
            if lam is None:
                return False
            E = m.eigsp(h, lam)
            EL = amb.span(E, lo) if lo else E
            cur = m.inter(cur, EL)
            if not cur:
                return False
        cur = amb.span(cur, lo) if lo else cur
        return m.canon(list(cur)) == m.canon(list(Ai))

    # ---------- enumeration of the closure of a top flag ----------
    def under(self, topU, topA):
        """all components whose chain contains every member of topU and whose
        slots refine topA.  Enumerated by extending the chain downwards."""
        amb = self.amb
        out = {}
        # chains: insert arrangement members below/between the topU members
        top = list(topU)
        # for our two rows topU has a single member Ut, and nothing in A lies
        # strictly above it (checked); so chains are (V_1<...<V_r<Ut) with
        # V_j in A, V_j subset Ut.
        assert len(top) == 1
        Ut = top[0]
        belows = [V for V in amb.A if V != Ut and amb.sub(V, Ut)]
        chains = [()]
        frontier = [(V,) for V in belows]
        while frontier:
            chains.extend(frontier)
            nf = []
            for C in frontier:
                for V in belows:
                    if len(V) > len(C[-1]) and amb.sub(C[-1], V):
                        nf.append(C + (V,))
            frontier = nf
        for C in chains:
            U = tuple(C) + (Ut,)
            Us = [()] + list(U)
            His = list(U) + [amb.W]
            # candidate slot spaces: all subspaces lo <= X <= hi that are
            # eigen-lifts for SOME subgroup; we generate them as intersections
            # of eigenspaces, but it is cheaper to enumerate H first.
            for H in self.abelian_stabilizing(U):
                A = []
                good = True
                for i in range(len(U) + 1):
                    lo, hi = Us[i], His[i]
                    pieces = self.eigen_pieces(H, lo, hi)
                    if not pieces:
                        good = False
                        break
                    A.append(pieces)
                if not good:
                    continue
                for choice in itertools.product(*A):
                    Ai = tuple(choice)
                    # must refine the top row's slots
                    if not self.refines(U, Ai, topU, topA):
                        continue
                    Hx = self.pointwise(U, Ai)
                    if Hx != H:
                        continue
                    if not self.valid(U, Ai, Hx):
                        continue
                    out[(U, Ai)] = Comp(U, Ai, Hx)
        return list(out.values())

    def abelian_stabilizing(self, U):
        m = self.m
        if not hasattr(self, "_abel"):
            abel = set()
            for A in m.G:
                H, B = [m.Id], A
                while B != m.Id:
                    H.append(B)
                    B = m.mm(B, A)
                abel.add(frozenset(H))
            inv = [A for A in m.G if m.order[A] == 2]
            for a, b in itertools.combinations(inv, 2):
                if m.mm(a, b) == m.mm(b, a):
                    abel.add(frozenset([m.Id, a, b, m.mm(a, b)]))
            self._abel = sorted(abel, key=lambda H: (len(H), sorted(H)))
        amb = self.amb
        return [H for H in self._abel
                if all(amb.gact(g, X) == X for g in H for X in U)]

    def eigen_pieces(self, H, lo, hi):
        """the lifted H-character eigenspaces of hi/lo"""
        amb, m = self.amb, self.m
        cache = getattr(self, "_epc", None)
        if cache is None:
            cache = self._epc = {}
        key = (H, lo, hi)
        if key in cache:
            return cache[key]
        pieces = [hi]
        for h in sorted(H):
            if h == m.Id:
                continue
            new = []
            for X in pieces:
                for lam in amb.eigvals(h):
                    E = m.eigsp(h, lam)
                    EL = amb.span(E, lo) if lo else E
                    I = m.inter(X, EL)
                    if I and len(I) > len(lo):
                        new.append(m.canon(list(I)))
            pieces = new
        seen, out = set(), []
        for X in pieces:
            if X not in seen and len(X) > len(lo):
                seen.add(X)
                out.append(X)
        cache[key] = out
        return out

    def refines(self, U, A, topU, topA):
        """the component (U,A) lies in the closure of (topU, topA)."""
        amb = self.amb
        assert len(topU) == 1
        Ut, = topU
        Us = [()] + list(U)
        # position of Ut in U
        k = U.index(Ut)
        # slot r of the top row:  r=0 -> inside Ut ; r=1 -> W/Ut
        # the deep component's slot A_0 must sit inside topA[0]
        if not amb.sub(A[0], topA[0]):
            return False
        if not amb.sub(A[k + 1], topA[1]):
            return False
        return True


# ===========================================================================
#  Layer II: sigma-adapted coordinates and the two divisor modules
# ===========================================================================
def matmul(p, X, Y):
    n, k, mm = len(X), len(Y), len(Y[0])
    return [[sum(X[i][t] * Y[t][j] for t in range(k)) % p for j in range(mm)]
            for i in range(n)]


class SigmaFrame:
    """explicit sigma-adapted coordinates: W = W+ (+) W-, basis u0,u1,u2 | v0,v1."""

    def __init__(self, amb, sigma):
        m, p = amb.m, amb.p
        self.amb, self.m, self.p, self.sigma = amb, m, p, sigma
        self.Wp = m.plus_plane(sigma)          # 3 basis vectors
        self.Wm = m.minus_line(sigma)          # 2 basis vectors
        assert len(self.Wp) == 3 and len(self.Wm) == 2
        self.Gam = [g for g in m.G if m.mm(g, sigma) == m.mm(sigma, g)]
        assert len(self.Gam) == 12
        # basis matrix: columns = u0,u1,u2,v0,v1
        B = [[0] * 5 for _ in range(5)]
        cols = list(self.Wp) + list(self.Wm)
        for j, c in enumerate(cols):
            for i in range(5):
                B[i][j] = c[i] % p
        self.B = B
        self.Binv = self._inv(B)
        # block matrices
        self.blk = {}
        for g in self.Gam:
            M = matmul(p, self.Binv, matmul(p, [list(r) for r in g], B))
            # check block diagonal
            for i in range(3):
                for j in range(3, 5):
                    assert M[i][j] % p == 0, "not block diagonal"
                    assert M[j][i] % p == 0, "not block diagonal"
            Ag = [[M[i][j] for j in range(3)] for i in range(3)]
            Bg = [[M[3 + i][3 + j] for j in range(2)] for i in range(2)]
            self.blk[g] = (Ag, Bg)
        # two generators of Gamma
        self.gens = self._gens()

    def _inv(self, X):
        p = self.p
        n = len(X)
        M = [list(X[i]) + [int(i == j) for j in range(n)] for i in range(n)]
        r = 0
        for c in range(n):
            pr = next(i for i in range(r, n) if M[i][c] % p)
            M[r], M[pr] = M[pr], M[r]
            iv = pow(M[r][c], p - 2, p)
            M[r] = [x * iv % p for x in M[r]]
            for i in range(n):
                if i != r and M[i][c] % p:
                    f = M[i][c]
                    M[i] = [(x - f * y) % p for x, y in zip(M[i], M[r])]
            r += 1
        return [row[n:] for row in M]

    def _gens(self):
        m = self.m
        for a, b in itertools.combinations(self.Gam, 2):
            gen = {m.Id}
            fr = [m.Id]
            while fr:
                nf = []
                for x in fr:
                    for y in (a, b):
                        z = m.mm(x, y)
                        if z not in gen:
                            gen.add(z)
                            nf.append(z)
                fr = nf
            if len(gen) == 12:
                return (a, b)
        raise RuntimeError

    # ---------- linear characters of Gamma ----------
    def characters(self):
        """all linear characters of Gamma = D12, as dicts g -> scalar in F_p."""
        m, p = self.m, self.p
        # abelianization D12 -> C2 x C2 ; build by brute force over F_p values
        # a linear character is determined on the two generators
        a, b = self.gens
        oa, ob = m.order[a], m.order[b]
        out = []
        for va in [x for x in range(1, p) if pow(x, oa, p) == 1]:
            for vb in [x for x in range(1, p) if pow(x, ob, p) == 1]:
                chi = {m.Id: 1}
                ok = True
                fr = [m.Id]
                while fr and ok:
                    nf = []
                    for x in fr:
                        for y, vy in ((a, va), (b, vb)):
                            z = m.mm(x, y)
                            val = chi[x] * vy % p
                            if z in chi:
                                if chi[z] != val:
                                    ok = False
                                    break
                            else:
                                chi[z] = val
                                nf.append(z)
                        if not ok:
                            break
                    fr = nf
                if ok and len(chi) == 12:
                    out.append(chi)
        # dedupe
        uniq = []
        for chi in out:
            if not any(all(chi[g] == c[g] for g in chi) for c in uniq):
                uniq.append(chi)
        return uniq

    # ---------- the module V(a,b,psi) ----------
    def module(self, a, b, psi):
        """basis of  { f in Sym^a(W+*) (x) Sym^b(W-*) (x) W- :
                       f(A_g u, B_g v) = psi(g) B_g f(u,v) }  as a nullspace."""
        p = self.p
        mons_u = [(i, j, a - i - j) for i in range(a + 1) for j in range(a + 1 - i)]
        mons_v = [(i, b - i) for i in range(b + 1)]
        idx = {}
        n = 0
        for mu in mons_u:
            for mv in mons_v:
                for c in range(2):
                    idx[(mu, mv, c)] = n
                    n += 1
        rows = []
        for g in self.gens:
            Ag, Bg = self.blk[g]
            pg = psi[g]
            SU = subst_matrix(p, Ag, a, mons_u, 3)
            SV = subst_matrix(p, Bg, b, mons_v, 2)
            # equations indexed by the monomial (mu2,mv2) and component c of
            #     f(Ag u, Bg v)  -  psi(g) * Bg f(u,v)  ==  0 .
            # f(Ag u, Bg v) = sum_{mu,mv,c} f_{mu,mv,c} (Ag u)^mu (Bg v)^mv e_c
            M = [[0] * n for _ in range(n)]
            for mu in mons_u:
                for mu2, cu in SU[mu]:
                    for mv in mons_v:
                        for mv2, cv in SV[mv]:
                            t = cu * cv % p
                            for c in range(2):
                                M[idx[(mu2, mv2, c)]][idx[(mu, mv, c)]] = (
                                    M[idx[(mu2, mv2, c)]][idx[(mu, mv, c)]] + t) % p
            for mu in mons_u:
                for mv in mons_v:
                    for c in range(2):
                        for c2 in range(2):
                            M[idx[(mu, mv, c)]][idx[(mu, mv, c2)]] = (
                                M[idx[(mu, mv, c)]][idx[(mu, mv, c2)]]
                                - pg * Bg[c][c2]) % p
            rows.extend(M)
        return nullspace(p, rows, n), idx, mons_u, mons_v

    def check_equivariance(self, vec, idx, mons_u, mons_v, a, b, psi, trials=4):
        """direct test:  f(A_g u, B_g v) == psi(g) * B_g f(u,v)  for all g."""
        import random
        p = self.p
        rnd = random.Random(20260811)
        for _ in range(trials):
            u = [rnd.randrange(p) for _ in range(3)]
            v = [rnd.randrange(p) for _ in range(2)]
            f0 = self.evaluate(vec, idx, mons_u, mons_v, u, v)
            for g in self.Gam:
                Ag, Bg = self.blk[g]
                gu = [sum(Ag[i][j] * u[j] for j in range(3)) % p for i in range(3)]
                gv = [sum(Bg[i][j] * v[j] for j in range(2)) % p for i in range(2)]
                lhs = self.evaluate(vec, idx, mons_u, mons_v, gu, gv)
                rhs = tuple(psi[g] * sum(Bg[i][j] * f0[j] for j in range(2)) % p
                            for i in range(2))
                if lhs != rhs:
                    return False
        return True

    def evaluate(self, vec, idx, mons_u, mons_v, u, v):
        """f(u,v) in W- coordinates."""
        p = self.p
        out = [0, 0]
        for mu in mons_u:
            pu = 1
            for t in range(3):
                pu = pu * pow(u[t], mu[t], p) % p
            if pu == 0:
                continue
            for mv in mons_v:
                pv = pow(v[0], mv[0], p) * pow(v[1], mv[1], p) % p
                if pv == 0:
                    continue
                for c in range(2):
                    out[c] = (out[c] + vec[idx[(mu, mv, c)]] * pu * pv) % p
        return tuple(out)


def subst_matrix(p, M, deg, mons, nv):
    """for each monomial x^alpha, expand (Mx)^alpha in the monomial basis."""
    out = {}
    lin = []
    for j in range(nv):
        lin.append({tuple(int(t == k) for t in range(nv)): M[j][k] % p
                    for k in range(nv) if M[j][k] % p})
    for al in mons:
        cur = {tuple([0] * nv): 1}
        for j in range(nv):
            for _ in range(al[j]):
                nxt = defaultdict(int)
                for e, c in cur.items():
                    for e2, c2 in lin[j].items():
                        key = tuple(e[t] + e2[t] for t in range(nv))
                        nxt[key] = (nxt[key] + c * c2) % p
                cur = {k: v for k, v in nxt.items() if v}
        out[al] = [(k, v) for k, v in cur.items() if v]
    return out


def nullspace(p, rows, n):
    M = [list(r) for r in rows]
    piv = []
    r = 0
    for c in range(n):
        pr = None
        for i in range(r, len(M)):
            if M[i][c] % p:
                pr = i
                break
        if pr is None:
            continue
        M[r], M[pr] = M[pr], M[r]
        iv = pow(M[r][c], p - 2, p)
        M[r] = [x * iv % p for x in M[r]]
        for i in range(len(M)):
            if i != r and M[i][c] % p:
                f = M[i][c]
                M[i] = [(x - f * y) % p for x, y in zip(M[i], M[r])]
        piv.append(c)
        r += 1
        if r == len(M):
            break
    free = [c for c in range(n) if c not in piv]
    basis = []
    for f in free:
        v = [0] * n
        v[f] = 1
        for i, c in enumerate(piv):
            v[c] = (-M[i][f]) % p
        basis.append(v)
    return basis
