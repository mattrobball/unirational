"""FIX-VIII-MOVES core library.

Klein cubic F = sum x_i^2 x_{i+1} in P^4 over F_p, its automorphism group
G = PSL(2,11) of order 660 (explicit generators from FIX-VII-GATE), the 55
involutions, their eigenspace geometry, the chord map, and the canonical loci.

Conventions match GATE's gatelib.py / the director probe cycle55.py.
"""
import itertools
import json
import os

import numpy as np

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.dirname(HERE)
GATE = ("/Users/worker/unirational/problems/E-klein-cubic/"
        "goal_runs_after_ac61998/FIX_VII_GATE")
CHECKLOG = os.path.join(ROOT, "results", "checks.log")


# ------------------------------------------------------------ modular linalg

def rref(A, p):
    A = (np.asarray(A, dtype=np.int64) % p).copy()
    m, n = A.shape
    pivots = []
    r = 0
    for c in range(n):
        if r >= m:
            break
        nz = np.nonzero(A[r:, c])[0]
        if nz.size == 0:
            continue
        i = r + int(nz[0])
        if i != r:
            A[[r, i]] = A[[i, r]]
        A[r] = (A[r] * pow(int(A[r, c]), p - 2, p)) % p
        col = A[:, c].copy()
        col[r] = 0
        nzr = np.nonzero(col)[0]
        if nzr.size:
            A[nzr] = (A[nzr] - np.outer(col[nzr], A[r])) % p
        pivots.append(c)
        r += 1
    return A, pivots


def rank_p(A, p):
    A = np.asarray(A, dtype=np.int64)
    if A.size == 0:
        return 0
    return len(rref(A, p)[1])


def nullspace(A, p):
    """Rows of the returned array span the (right) nullspace of A."""
    A = np.asarray(A, dtype=np.int64) % p
    m, n = A.shape
    if m == 0:
        return np.eye(n, dtype=np.int64)
    R, piv = rref(A, p)
    free = [c for c in range(n) if c not in set(piv)]
    B = np.zeros((len(free), n), dtype=np.int64)
    for j, f in enumerate(free):
        B[j, f] = 1
        for i, c in enumerate(piv):
            B[j, c] = (-R[i, f]) % p
    return B % p


def norm_pt(v, p):
    """Canonical projective representative (first nonzero coord scaled to 1)."""
    v = np.asarray(v, dtype=np.int64) % p
    nz = np.nonzero(v)[0]
    if nz.size == 0:
        return None
    return tuple(int(t) for t in (v * pow(int(v[nz[0]]), p - 2, p)) % p)


def norm_mat(M, p):
    M = np.asarray(M, dtype=np.int64) % p
    flat = M.reshape(-1)
    nz = np.nonzero(flat)[0]
    s = pow(int(flat[nz[0]]), p - 2, p)
    return tuple(int(t) for t in (flat * s) % p)


# ------------------------------------------------------------------- the group

def load_group(p=67):
    """BFS closure of the three GATE generators; returns list of 5x5 arrays."""
    js = json.load(open(os.path.join(GATE, "payload", "G660_p%d.json" % p)))
    gens = [np.array(js["generators"][k], dtype=np.int64) % p
            for k in ("g11", "s5", "S")]
    I5 = np.eye(5, dtype=np.int64)
    seen = {tuple(I5.reshape(-1).tolist()): I5}
    frontier = [I5]
    while frontier:
        nxt = []
        for M in frontier:
            for g in gens:
                N = (g @ M) % p
                k = tuple(N.reshape(-1).tolist())
                if k not in seen:
                    seen[k] = N
                    nxt.append(N)
        frontier = nxt
    return list(seen.values()), js


def elt_order(M, p):
    I5 = np.eye(5, dtype=np.int64)
    k, A = 1, M % p
    while not np.array_equal(A, I5):
        A = (A @ M) % p
        k += 1
        if k > 700:
            return -1
    return k


# ------------------------------------------------------------------ the cubic

def Fv(x, p):
    x = np.asarray(x, dtype=np.int64) % p
    return int(sum(int(x[i]) * int(x[i]) * int(x[(i + 1) % 5])
                   for i in range(5)) % p)


def gradF(x, p):
    x = [int(t) % p for t in x]
    return np.array([(2 * x[i] * x[(i + 1) % 5] + x[(i - 1) % 5] ** 2) % p
                     for i in range(5)], dtype=np.int64)


def chord(a, b, p):
    """Third intersection of line(a,b) with X, for a,b in X.  Symmetric up to
    sign, hence well defined projectively.  Returns None if the whole line
    lies on X (both coefficients vanish) or the result is 0."""
    a = np.asarray(a, dtype=np.int64) % p
    b = np.asarray(b, dtype=np.int64) % p
    A = int(np.dot(gradF(a, p), b) % p)          # grad F(a) . b
    B = int(np.dot(gradF(b, p), a) % p)          # grad F(b) . a
    c = (B * a - A * b) % p
    if not c.any():
        return None
    return c


# ----------------------------------------------------------- involution data

class Setup:
    def __init__(self, p=67):
        self.p = p
        G, js = load_group(p)
        self.G = G
        self.js = js
        assert len(G) == 660, len(G)
        self.inv = [M for M in G if elt_order(M, p) == 2]
        assert len(self.inv) == 55, len(self.inv)
        I5 = np.eye(5, dtype=np.int64)
        inv2 = pow(2, p - 2, p)
        self.I5 = I5
        # projector onto the (-1)-eigenspace V_-(sigma) = the V4-line
        self.proj = [((I5 - M) % p) * inv2 % p for M in self.inv]
        self.projp = [((I5 + M) % p) * inv2 % p for M in self.inv]
        # line L_sigma = P(V_-) : 2-dim; plus-plane P_sigma = P(V_+): 3-dim.
        # V_-(sigma) = IMAGE of pi_sigma = column space, so transpose before rref.
        self.Lbas = [rref(P.T, p)[0][:rank_p(P, p)] for P in self.proj]
        self.Pbas = [rref(P.T, p)[0][:rank_p(P, p)] for P in self.projp]
        assert all(b.shape[0] == 2 for b in self.Lbas)
        assert all(b.shape[0] == 3 for b in self.Pbas)
        # linear forms cutting each line (3 forms) / each plus-plane (2 forms)
        self.Lcut = [nullspace(b, p) for b in self.Lbas]     # 3 x 5
        self.Pcut = [nullspace(b, p) for b in self.Pbas]     # 2 x 5
        self.imat = {norm_mat(M, p): i for i, M in enumerate(self.inv)}
        self._v4()
        self._loci()

    # -- V4 triples, triangle planes, vertices ------------------------------
    def _v4(self):
        p = self.p
        n = 55
        self.commutes = np.zeros((n, n), dtype=bool)
        for i in range(n):
            for j in range(n):
                self.commutes[i, j] = np.array_equal(
                    (self.inv[i] @ self.inv[j]) % p,
                    (self.inv[j] @ self.inv[i]) % p)
        v4 = set()
        for i in range(n):
            for j in range(i + 1, n):
                if i != j and self.commutes[i, j]:
                    Mk = (self.inv[i] @ self.inv[j]) % p
                    k = self.imat[norm_mat(Mk, p)]
                    v4.add(tuple(sorted((i, j, k))))
        self.v4 = sorted(v4)
        assert len(self.v4) == 55, len(self.v4)
        # triangle plane = span of the three lines (rank 3)
        self.tri_plane = []
        self.tri_cut = []
        for (i, j, k) in self.v4:
            B = np.concatenate([self.Lbas[i], self.Lbas[j], self.Lbas[k]])
            R, piv = rref(B, p)
            assert len(piv) == 3
            self.tri_plane.append(R[:3])
            self.tri_cut.append(nullspace(R[:3], p))     # 2 x 5
        # vertices: pairwise intersections of the three lines of a V4
        vs = {}
        for t, (i, j, k) in enumerate(self.v4):
            for (a, b) in ((i, j), (j, k), (i, k)):
                M = np.concatenate([self.Lcut[a], self.Lcut[b]])
                N = nullspace(M, p)
                assert N.shape[0] == 1, (t, a, b, N.shape)
                key = norm_pt(N[0], p)
                vs.setdefault(key, []).append((t, a, b))
        self.vertices = sorted(vs)
        self.vertex_of = vs

    # -- Hessian quintic, Hessian curve -------------------------------------
    def _loci(self):
        p = self.p
        import sys
        sys.path.insert(0, GATE)
        import gatelib as GL
        self.H = GL.hessian_H(p)
        self.dH = [GL.poly_diff(self.H, i, p) for i in range(5)]
        self.Cpts = None
        cp = os.path.join(GATE, "payload", "cpoints_p%d.json" % p)
        if os.path.exists(cp):
            self.Cpts = [np.array(v, dtype=np.int64)
                         for v in json.load(open(cp))["points"]]

    def evalpoly(self, poly, x):
        p = self.p
        x = [int(t) % p for t in x]
        acc = 0
        for m, c in poly.items():
            t = c
            for k in range(5):
                if m[k]:
                    t = t * pow(x[k], m[k], p) % p
            acc = (acc + t) % p
        return acc % p

    def Hval(self, x):
        return self.evalpoly(self.H, x)

    def on_C(self, x):
        """Hessian curve C = Sing V(H) = V(partial H) set-theoretically."""
        return all(self.evalpoly(d, x) == 0 for d in self.dH)

    # -- incidence tests ----------------------------------------------------
    def on_line(self, x):
        p = self.p
        x = np.asarray(x, dtype=np.int64) % p
        return [i for i in range(55) if not (self.Lcut[i] @ x % p).any()]

    def on_plusplane(self, x):
        p = self.p
        x = np.asarray(x, dtype=np.int64) % p
        return [i for i in range(55) if not (self.Pcut[i] @ x % p).any()]

    def on_triplane(self, x):
        p = self.p
        x = np.asarray(x, dtype=np.int64) % p
        return [i for i in range(55) if not (self.tri_cut[i] @ x % p).any()]

    def is_vertex(self, x):
        return norm_pt(x, self.p) in self.vertex_of

    def orbit(self, x):
        p = self.p
        x = np.asarray(x, dtype=np.int64) % p
        return {norm_pt(M @ x % p, p) for M in self.G}


# ----------------------------------------------------------------- utilities

def rand_pt(rng, p, n=5):
    while True:
        v = rng.integers(0, p, size=n).astype(np.int64)
        if v.any():
            return v


def plucker(a, b, p):
    a = np.asarray(a, dtype=np.int64) % p
    b = np.asarray(b, dtype=np.int64) % p
    return np.array([(int(a[r]) * int(b[s]) - int(a[s]) * int(b[r])) % p
                     for r in range(5) for s in range(r + 1, 5)],
                    dtype=np.int64)


def lines_meet(pl1, pl2, p):
    """Two lines in P^4 meet iff the 4x5 stack of their spanning points has
    rank <= 3.  Here we pass spanning pairs, not Plucker vectors."""
    raise NotImplementedError


def check(name, ok, note=""):
    line = "CHECK %s %s%s" % (name, "PASS" if ok else "FAIL",
                              ("  # " + note) if note else "")
    os.makedirs(os.path.dirname(CHECKLOG), exist_ok=True)
    with open(CHECKLOG, "a") as f:
        f.write(line + "\n")
    print(line, flush=True)
    return ok


def note(name, text):
    line = "NOTE %s  # %s" % (name, text)
    os.makedirs(os.path.dirname(CHECKLOG), exist_ok=True)
    with open(CHECKLOG, "a") as f:
        f.write(line + "\n")
    print(line, flush=True)
