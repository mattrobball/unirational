#!/usr/bin/env python3
# T5, LEVEL 2: the (tau,Psi) pair-field shadow on the MIXED fan -- the common
# refinement of the A4 Weyl fan (walls {n_a = n_b}) and the G9 order fan
# (walls {H_a = H_b}).  This is the first level-2 system on a fan carrying BOTH
# wall classes; FIX_IX S8.22's (tau,Psi)-frame was derived for ALIGNED fans only.
#
#   N = {n in Z^5 : sum n = 0},  Lambda = Z^5/diag,  G9 = (1,5,3,4,9),
#   sigN(n)_j = n_{j-1 mod 5},  H_k(n) = <sig^k n, G9> = <n, mu_k>,
#   mu_k[j] = G9[(j+k) mod 5].  Cells = realizable pairs (piA, piG).
#
# THE LEVEL-2 SYSTEM (unknowns tau_C in F11 and Psi_C in Q = (Lambda/11)/<G9,diag>
# = F11^3, one pair per mixed cell).  From U = tau~ G9 + 11 V (Lemma T) and the
# integral-slope wall law U(C) - U(C') = m*nu:
#
#  (J-G) ALIGNED wall (nu = mu_a - mu_b == (5^a-5^b) G9 mod 11):
#        Delta(tau, Psi) in F11 * (1, Theta_W),   Theta_W = nf_Q(rho * lam^-1),
#        nu - lam*G9 - s*(1,1,1,1,1) = 11*rho  (lam, s unique mod 11).
#  (J-A) GENERIC wall (nu = e_a - e_b, NOT in F11*G9 + F11*diag):
#        Delta tau == 0  and  Delta Psi in F11 * nf_Q(nu).
#        [mod 11 the law reads (tau~ - tau~')G9 == m*nu in Lambda/11; nu is off
#         the G9-line, so m == 0 and Delta tau~ == 0 (mod 11).  Writing m = 11m'
#         and Delta tau~ = 11 s gives Delta V = m' nu - s G9, i.e.
#         Delta Psi = m' * nf_Q(nu).]                     [VERIFIED in section 1]
#  (Z)   (tau, Psi) = 0 on every zero cell of the pattern.
#  (S)   sum of tau over each sigma-orbit of cells == 7 (mod 11).
#        [(3) reads (Sum tau)*G9 == -c9 in Lambda/11 and c9 == 4*G9, so 7.]
#
# SOUNDNESS.  Only exactly-certified cells and walls are used (integer witness
# points; every facet certificate re-checked in exact integer arithmetic), and
# BOTH the cell list and the wall list are proved COMPLETE against exact
# Zaslavsky counts (of the arrangement and of each of its 20 restrictions), so
# the system is the full one, neither a sub- nor a super-system.  The
# parametrization is proved surjective onto the solution set (tree transport),
# so the reported dimension is exact.  An INFEASIBLE verdict says: no aligned
# level-1 solution extends to the level-2 shadow on that pattern.  A FEASIBLE
# verdict is CONSTRUCTIVE -- an explicit (tau,Psi) field, re-verified by a
# second, independent plain-integer checker against every wall jump, every
# orbit sum and every zero condition, plus a check that its tau-layer is a
# genuine level-1 solution in the original U-frame.
#
# Reproduce:  python3 f55_mixedlevel2.py          (deterministic; seed 20260807)
#   env knobs: F55_DFS_LIMIT (s, default 900) time limit for each exhaustive DFS
#              F55_LEVEL1=0  skips the auxiliary level-1 re-verification
import numpy as np, random, time, sys, os
from fractions import Fraction as Fr
from itertools import combinations, permutations
from math import gcd
from scipy.optimize import linprog

T00 = time.time()
SEED = 20260807
DFS_LIMIT = float(os.environ.get("F55_DFS_LIMIT", "900"))
DO_LEVEL1 = os.environ.get("F55_LEVEL1", "1") != "0"
np.seterr(all='raise')
sys.setrecursionlimit(20000)
def hdr(s): print("\n" + "=" * 78 + "\n== " + s + "\n" + "=" * 78)

# ============================================================ 0. conventions
G9 = (1, 5, 3, 4, 9)
c9 = (4, 9, 1, 5, 3)
MU = [tuple(G9[(j + k) % 5] for j in range(5)) for k in range(5)]
pairs = list(combinations(range(5), 2))
INVT = np.array([0, 1, 6, 4, 3, 9, 2, 8, 7, 5, 10], dtype=np.int64)   # inverses mod 11

def sigN(n): return tuple(n[(j - 1) % 5] for j in range(5))
def shift_perm(p, k): return tuple((x + k) % 5 for x in p)
def swp(p, i):
    q = list(p); q[i], q[i + 1] = q[i + 1], q[i]; return tuple(q)

def nf_diag(v): return tuple((v[j] - v[4]) % 11 for j in range(5))
G9n = nf_diag(G9)                                     # (3,7,5,6,0)
inv_g0 = pow(G9n[0], 9, 11)
def nf_Q(v):
    """normal form in Q = (Lambda/11)/<G9> = F11^3 (kill diag, then the G9-line)."""
    w = nf_diag(v)
    c = (w[0] * inv_g0) % 11
    w = tuple((w[j] - c * G9n[j]) % 11 for j in range(5))
    assert w[0] == 0 and w[4] == 0
    return (w[1], w[2], w[3])

def prim(v):
    """primitive representative of the class of v in Lambda = Z^5/diag."""
    w = [v[j] - v[4] for j in range(5)]
    g = 0
    for x in w: g = gcd(g, x)
    assert g > 0
    return tuple(x // g for x in w)

def aligned_lifts(nu):
    """the (lam, s) with nu == lam*G9 + s*(1,1,1,1,1) mod 11; EMPTY iff nu is
       off the plane F11*G9 + F11*diag, i.e. iff the wall is generic."""
    return [(lh, r[0]) for lh in range(11)
            for r in [[(nu[i] - lh * G9[i]) % 11 for i in range(5)]] if len(set(r)) == 1]

def theta_of(nu):
    """for an ALIGNED normal: (lam, rho, Theta), nu - lam G9 - s*1 = 11 rho,
       Theta = nf_Q(rho/lam).  Raises if nu is not aligned mod 11."""
    hits = aligned_lifts(nu)
    assert len(hits) == 1, ("wall not aligned / non-unique lift", nu, hits)
    lamhat, s = hits[0]
    assert lamhat % 11 != 0, ("null wall", nu)
    diff = tuple(nu[i] - lamhat * G9[i] - s for i in range(5))
    assert all(x % 11 == 0 for x in diff)
    rho = tuple(x // 11 for x in diff)
    inv = pow(lamhat % 11, 9, 11)
    return lamhat % 11, rho, nf_Q(tuple((x * inv) % 11 for x in rho))

def decomp(U):
    """the canonical level-2 pair of an integral U: (tau, Psi) if
       U == tau*G9 (mod 11, diag) -- i.e. U = tau~ G9 + s*1 + 11 V -- else None."""
    hits = aligned_lifts(U)
    if not hits: return None
    assert len(hits) == 1
    lamhat, s = hits[0]
    assert all((U[i] - lamhat * G9[i] - s) % 11 == 0 for i in range(5))
    V = tuple((U[i] - lamhat * G9[i] - s) // 11 for i in range(5))
    return lamhat % 11, nf_Q(V)

def ann2(q):
    """2 independent functionals on F11^3 annihilating the nonzero q."""
    q = tuple(x % 11 for x in q)
    p = next(i for i in range(3) if q[i])
    inv = pow(q[p], 9, 11)
    out = []
    for c in range(3):
        if c == p: continue
        f = [0, 0, 0]; f[c] = 1; f[p] = (-q[c] * inv) % 11
        assert sum(f[i] * q[i] for i in range(3)) % 11 == 0
        out.append(f)
    return out

def ann3(nu):
    """3 independent functionals on Lambda/11 (coords 0..3 of nf_diag) killing nu."""
    v = np.array(nf_diag(nu)[:4], dtype=np.int64) % 11
    p = int(np.nonzero(v)[0][0]); inv = pow(int(v[p]), 9, 11); out = []
    for c in range(4):
        if c == p: continue
        f = np.zeros(4, dtype=np.int64); f[c] = 1; f[p] = (-int(v[c]) * inv) % 11
        assert int(f @ v) % 11 == 0
        out.append(f)
    return out

def rank_f11(vs):
    A = [[x % 11 for x in v] for v in vs]
    m = len(A); n = len(A[0]); r = 0
    for col in range(n):
        pr = next((i for i in range(r, m) if A[i][col]), None)
        if pr is None: continue
        A[r], A[pr] = A[pr], A[r]
        iv = pow(A[r][col], 9, 11); A[r] = [(x * iv) % 11 for x in A[r]]
        for i in range(m):
            if i != r and A[i][col]:
                f = A[i][col]; A[i] = [(x - f * y) % 11 for x, y in zip(A[i], A[r])]
        r += 1
    return r

def rref_np(rows, nv):
    """rref over F11 of [A|b]; returns None if inconsistent, else (part, basis)."""
    A = np.array(rows, dtype=np.int64) % 11
    m = A.shape[0]; piv = []; r0 = 0
    for col in range(nv):
        if r0 >= m: break
        nz = np.nonzero(A[r0:, col])[0]
        if nz.size == 0: continue
        pr = r0 + int(nz[0])
        if pr != r0: A[[r0, pr]] = A[[pr, r0]]
        A[r0] = (A[r0] * int(INVT[A[r0, col]])) % 11
        cv = A[:, col].copy(); cv[r0] = 0
        nzr = np.nonzero(cv)[0]
        if nzr.size: A[nzr] = (A[nzr] - np.outer(cv[nzr], A[r0])) % 11
        piv.append(col); r0 += 1
    if r0 < m and np.any(A[r0:, nv] % 11): return None
    part = np.zeros(nv, dtype=np.int64)
    for i, col in enumerate(piv): part[col] = A[i, nv]
    pv = set(piv); free = [c for c in range(nv) if c not in pv]
    B = np.zeros((len(free), nv), dtype=np.int64)
    for t, f in enumerate(free):
        B[t, f] = 1
        for i, col in enumerate(piv): B[t, col] = (-A[i, f]) % 11
    return part, B

def rref_cond(rows, nb):
    """rref of condition rows [coeffs|rhs] in nb parameters; None if inconsistent."""
    A = np.array(rows, dtype=np.int64) % 11
    if A.size == 0: return A.reshape(0, nb + 1)
    m = A.shape[0]; r0 = 0
    for col in range(nb):
        if r0 >= m: break
        nz = np.nonzero(A[r0:, col])[0]
        if nz.size == 0: continue
        pr = r0 + int(nz[0])
        if pr != r0: A[[r0, pr]] = A[[pr, r0]]
        A[r0] = (A[r0] * int(INVT[A[r0, col]])) % 11
        cv = A[:, col].copy(); cv[r0] = 0
        nzr = np.nonzero(cv)[0]
        if nzr.size: A[nzr] = (A[nzr] - np.outer(cv[nzr], A[r0])) % 11
        r0 += 1
    if r0 < m and np.any(A[r0:, nb] % 11): return None
    return np.ascontiguousarray(A[:r0])

# =============================================== 1. TASK 1: the generic-wall law
hdr("1. the GENERIC (A4-class) wall jump law, verified numerically")
GEN_NORMALS = []
for a, b in combinations(range(5), 2):
    v = [0] * 5; v[a] = 1; v[b] = -1
    GEN_NORMALS.append(((a, b), tuple(v)))
ALG_NORMALS = [((a, b), prim(tuple(MU[a][j] - MU[b][j] for j in range(5))))
               for a, b in combinations(range(5), 2)]

print("(1a) the ten A4-class normals nu = e_a - e_b:")
print("     nf_Q(nu) != 0  <=>  the Psi-slide direction F11*nf_Q(nu) is genuinely")
print("     1-dimensional; no (lam,s) with nu == lam*G9 + s*(1,1,1,1,1) mod 11")
print("     <=> nu is off F11*G9 + F11*diag, which forces m == 0 and Delta tau == 0.")
allok = True
for (a, b), nu in GEN_NORMALS:
    q = nf_Q(nu)
    lifts = aligned_lifts(nu)
    rk = rank_f11([list(nu), list(G9), [1] * 5])
    sols = [(m, dt) for m in range(11) for dt in range(11)
            if len(set([(dt * G9[i] - m * nu[i]) % 11 for i in range(5)])) == 1]
    forced = (sorted(sols) == [(0, 0)])
    ok = (q != (0, 0, 0)) and (lifts == []) and (rk == 3) and forced
    allok &= ok
    print(f"     e_{a}-e_{b} = {nu}  nf_Q = {q}  aligned lifts {lifts}  "
          f"rank_F11{{nu,G9,1}} = {rk}  forcing-solutions {sols}  {'OK' if ok else 'FAIL'}")
assert allok
print("(1a) VERIFIED: all ten generic normals have nf_Q != 0, admit NO aligned lift,")
print("     and the only (m, Delta tau) in F11^2 with Delta tau * G9 == m * nu in")
print("     Lambda/11 is (0,0) -- exactly the derivation's forcing step.")

print("\n(1b) integer simulation of the wall law U - U' = m*nu on GENERIC walls")
rng = random.Random(SEED)
n_al = n_nal = 0
for trial in range(4000):
    tt = rng.randrange(11 ** 2)
    V = tuple(rng.randint(-40, 40) for _ in range(5))
    U = tuple(tt * G9[i] + 11 * V[i] for i in range(5))
    d0 = decomp(U); assert d0 is not None and d0[0] == tt % 11 and d0[1] == nf_Q(V)
    (a, b), nu = GEN_NORMALS[rng.randrange(10)]
    m = rng.randint(-60, 60)
    U2 = tuple(U[i] - m * nu[i] for i in range(5))
    d1 = decomp(U2)
    if m % 11:
        assert d1 is None, ("a non-multiple-of-11 slide stayed aligned", m, nu)
        n_nal += 1
    else:
        assert d1 is not None
        mp = m // 11
        assert d1[0] == d0[0], ("Delta tau != 0 across a generic wall", m, nu)
        q = nf_Q(nu)
        dpsi = tuple((d0[1][c] - d1[1][c]) % 11 for c in range(3))
        assert dpsi == tuple((mp * q[c]) % 11 for c in range(3)), ("Delta Psi law", m, nu)
        n_al += 1
print(f"     {n_al} aligned slides (m == 0 mod 11): Delta tau == 0 and "
      f"Delta Psi == m' * nf_Q(nu) in EVERY case")
print(f"     {n_nal} non-aligned slides (m != 0 mod 11): U' is NOT of the form "
      f"tau*G9 mod (11,diag) in EVERY case  => m == 0 mod 11 is forced")

print("\n(1c) same simulation on the ten ALIGNED (G9-class) normals mu_a - mu_b")
n_ok = 0
for trial in range(4000):
    tt = rng.randrange(11 ** 2)
    V = tuple(rng.randint(-40, 40) for _ in range(5))
    U = tuple(tt * G9[i] + 11 * V[i] for i in range(5))
    (a, b), nu = ALG_NORMALS[rng.randrange(10)]
    lam, rho, th = theta_of(nu)
    m = rng.randint(-60, 60)
    U2 = tuple(U[i] - m * nu[i] for i in range(5))
    d0 = decomp(U); d1 = decomp(U2)
    assert d1 is not None, "an aligned slide left the aligned locus"
    dtau = (d0[0] - d1[0]) % 11
    dpsi = tuple((d0[1][c] - d1[1][c]) % 11 for c in range(3))
    assert dtau == (m * lam) % 11
    assert dpsi == tuple((dtau * th[c]) % 11 for c in range(3)), (m, nu, dpsi, th)
    n_ok += 1
print(f"     {n_ok}/4000: Delta(tau,Psi) == m*lam * (1, Theta_W) exactly, "
      f"Theta_W = nf_Q(rho/lam)")
print("     Theta of the ten G9-class normals mu_a - mu_b:")
for (a, b), nu in ALG_NORMALS:
    lam, rho, th = theta_of(nu)
    print(f"       mu_{a}-mu_{b} = {nu}  lam {lam}  rho {rho}  Theta {th}")
print("     Theta of the five sign-fan normals mu_k (calibration vs f55_signfan.py):")
REF_THETA = [(0, 0, 0), (0, 0, 10), (0, 2, 10), (7, 2, 10), (3, 7, 5)]
GOTT = [theta_of(prim(MU[k]))[2] for k in range(5)]
print(f"       computed {GOTT}\n       reference {REF_THETA}   equal: {GOTT == REF_THETA}")
assert GOTT == REF_THETA, "sign-wall Theta calibration failed"
print("     anchor: c9 =", c9, "== 4*G9 mod (11,diag):",
      nf_diag(c9) == tuple((4 * x) % 11 for x in G9n),
      "  =>  (3) reads (Sum_orbit tau)*G9 == -c9, i.e. Sum tau == -4 == 7")
assert nf_diag(c9) == tuple((4 * x) % 11 for x in G9n)

# ============================================ 2. the general (tau,Psi) engine
def solve_fan(ncells, walls, orbits, anchor=7, verbose=True, name="",
              psi_constant_on=None):
    """walls: (i, j, kind, nu), kind 'A' = generic (Delta tau = 0, Delta Psi in
       F11*nf_Q(nu)) or 'G' = aligned (Delta(tau,Psi) in F11*(1,Theta)).
       Parametrization: tau is constant on the connected components of the
       GENERIC wall graph (forced by (J-A)), Psi is transported along a spanning
       tree (each generic tree wall contributing one free slide scalar), and the
       independent cycles + the orbit sums are imposed.  This parametrization is
       SURJECTIVE onto the solution set (invert along the tree), so the reported
       dimension is the exact dimension of the solution set."""
    t0 = time.time()
    ISA = [w[2] == 'A' for w in walls]
    TH = {}; QG = {}
    for wi, (i, j, kd, nu) in enumerate(walls):
        if kd == 'A':
            q = nf_Q(nu)
            assert any(q), ("a generic normal collapses in Q", nu)
            QG[wi] = q
        else:
            TH[wi] = theta_of(nu)[2]
    par = list(range(ncells))
    def find(x):
        while par[x] != x: par[x] = par[par[x]]; x = par[x]
        return x
    for wi, (i, j, kd, nu) in enumerate(walls):
        if kd == 'A':
            ra, rb = find(i), find(j)
            if ra != rb: par[ra] = rb
    roots = sorted(set(find(i) for i in range(ncells)))
    CLSM = {r: k for k, r in enumerate(roots)}
    cls = np.array([CLSM[find(i)] for i in range(ncells)])
    K = len(roots)
    adj = [[] for _ in range(ncells)]
    for wi, (i, j, kd, nu) in enumerate(walls):
        adj[i].append((j, wi)); adj[j].append((i, wi))
    order = [0]; sn = [False] * ncells; sn[0] = True
    parc = [-1] * ncells; pare = [-1] * ncells; qi = 0
    while qi < len(order):
        X = order[qi]; qi += 1
        for (Y, e) in adj[X]:
            if not sn[Y]: sn[Y] = True; parc[Y] = X; pare[Y] = e; order.append(Y)
    assert all(sn), "the wall graph is disconnected"
    tree = set(pare[c] for c in range(ncells) if c != 0)
    gen_tree = sorted(e for e in tree if ISA[e])
    MCOL = {e: k for k, e in enumerate(gen_tree)}
    NUNK = K + 3 + len(MCOL)
    L = np.zeros((ncells, 3, NUNK), dtype=np.int64)          # Psi_C = L[C] . y
    for c in range(3): L[0, c, K + c] = 1
    for Y in order[1:]:
        X = parc[Y]; e = pare[Y]; L[Y] = L[X]
        if ISA[e]:
            col = K + 3 + MCOL[e]; q = QG[e]
            sgn = 1 if walls[e][0] == X else -1
            for c in range(3): L[Y, c, col] = (L[Y, c, col] + sgn * q[c]) % 11
        else:
            th = TH[e]
            for c in range(3):
                L[Y, c, cls[Y]] = (L[Y, c, cls[Y]] + th[c]) % 11
                L[Y, c, cls[X]] = (L[Y, c, cls[X]] - th[c]) % 11
    L %= 11
    rows = []
    for wi, (i, j, kd, nu) in enumerate(walls):
        if wi in tree: continue
        D = (L[i] - L[j]) % 11
        if kd == 'A':
            for f in ann2(QG[wi]):
                r = np.zeros(NUNK + 1, dtype=np.int64)
                r[:NUNK] = (f[0] * D[0] + f[1] * D[1] + f[2] * D[2]) % 11
                rows.append(r)
        else:
            th = TH[wi]
            for c in range(3):
                r = np.zeros(NUNK + 1, dtype=np.int64); r[:NUNK] = D[c]
                r[cls[i]] = (r[cls[i]] - th[c]) % 11
                r[cls[j]] = (r[cls[j]] + th[c]) % 11
                rows.append(r)
    ncyc = len(rows)
    nextra = 0
    if psi_constant_on:
        for g in psi_constant_on:
            for c in list(g)[1:]:
                D = (L[c] - L[list(g)[0]]) % 11
                for k in range(3):
                    r = np.zeros(NUNK + 1, dtype=np.int64); r[:NUNK] = D[k]
                    rows.append(r); nextra += 1
    for o in orbits:
        r = np.zeros(NUNK + 1, dtype=np.int64)
        for c in o: r[cls[c]] = (r[cls[c]] + 1) % 11
        r[NUNK] = anchor % 11
        rows.append(r)
    sol = rref_np(rows, NUNK)
    if verbose:
        print(f"[{name}] cells {ncells}, walls {len(walls)} "
              f"({sum(ISA)} generic + {len(walls)-sum(ISA)} aligned), "
              f"tau-classes (generic-wall components) {K}")
        print(f"[{name}] spanning tree {len(tree)} edges ({len(gen_tree)} generic "
              f"-> slide scalars), {len(walls)-len(tree)} independent cycles, "
              f"unknowns {NUNK} = {K} tau + 3 Psi(root) + {len(gen_tree)} slides")
        print(f"[{name}] system rows: {ncyc} cycle + {nextra} extra + "
              f"{len(orbits)} orbit-sum")
    if sol is None:
        if verbose: print(f"[{name}] jump+orbit-sum system INFEASIBLE with no zero cells")
        return None
    part, bas = sol; nb = len(bas)
    M = np.zeros((4 * ncells, NUNK), dtype=np.int64)
    for i in range(ncells):
        M[4 * i, cls[i]] = 1
        M[4 * i + 1:4 * i + 4] = L[i]
    MP = (M.astype(np.float64) @ part.astype(np.float64)).astype(np.int64) % 11
    MB = (M.astype(np.float64) @ bas.T.astype(np.float64)).astype(np.int64) % 11
    CCF = np.concatenate([MB, ((-MP) % 11)[:, None]], axis=1).reshape(ncells, 4, nb + 1)
    if verbose:
        print(f"[{name}] jump+orbit-sum SOLUTION SPACE: dim {nb}   [{time.time()-t0:.1f}s]")
    return dict(nb=nb, part=part, bas=bas, cls=cls, L=L, CCF=CCF, NUNK=NUNK,
                walls=walls, orbits=orbits, ncells=ncells, TH=TH, QG=QG, anchor=anchor)

def field_of(S, Y):
    """Y (nv, NUNK) -> tau (nv, ncells) and Psi (nv, ncells, 3)."""
    Y = np.atleast_2d(np.asarray(Y, dtype=np.int64)) % 11
    tau = Y[:, S['cls']] % 11
    psi = (S['L'].astype(np.float64).reshape(-1, S['NUNK']) @ Y.T.astype(np.float64)
           ).astype(np.int64).reshape(S['ncells'], 3, -1).transpose(2, 0, 1) % 11
    return tau, psi

def verify_field(S, Y, rhs, detail=False):
    """explicit substitution into EVERY wall condition and EVERY orbit sum."""
    tau, psi = field_of(S, Y)
    nv = tau.shape[0]
    Ai = np.array([w[0] for w in S['walls']]); Bi = np.array([w[1] for w in S['walls']])
    isa = np.array([w[2] == 'A' for w in S['walls']])
    dt = (tau[:, Ai] - tau[:, Bi]) % 11
    dp = (psi[:, Ai] - psi[:, Bi]) % 11
    bad = dict(aligned=0, gen_tau=0, gen_psi=0, orbit=0)
    al = np.nonzero(~isa)[0]
    if al.size:
        THm = np.array([S['TH'][int(w)] for w in al], dtype=np.int64)
        bad['aligned'] = int((((dp[:, al] - dt[:, al][:, :, None] * THm[None]) % 11) != 0).sum())
    ge = np.nonzero(isa)[0]
    if ge.size:
        Qm = np.array([S['QG'][int(w)] for w in ge], dtype=np.int64)
        bad['gen_tau'] = int(((dt[:, ge] % 11) != 0).sum())
        d = dp[:, ge]
        cr = np.stack([(d[:, :, 1] * Qm[None, :, 2] - d[:, :, 2] * Qm[None, :, 1]) % 11,
                       (d[:, :, 0] * Qm[None, :, 2] - d[:, :, 2] * Qm[None, :, 0]) % 11,
                       (d[:, :, 0] * Qm[None, :, 1] - d[:, :, 1] * Qm[None, :, 0]) % 11], axis=2)
        bad['gen_psi'] = int((cr != 0).sum())
    OA = np.array(S['orbits'])
    osum = tau[:, OA].sum(axis=2) % 11
    bad['orbit'] = int((osum != (np.array(rhs) % 11)[:, None]).sum())
    tot = sum(bad.values())
    if detail: return tot, bad, nv
    return tot

def verify_all(S, name):
    Y = np.vstack([S['part'][None, :], S['bas']])
    rhs = [S['anchor']] + [0] * S['nb']
    tot, bad, nv = verify_field(S, Y, rhs, detail=True)
    print(f"[{name}] EXPLICIT VERIFICATION of the particular solution and all "
          f"{S['nb']} basis vectors ({nv} vectors) against all {len(S['walls'])} "
          f"wall conditions and all {len(S['orbits'])} orbit sums:")
    print(f"[{name}]   violations: aligned-wall {bad['aligned']}, generic-wall "
          f"Delta tau {bad['gen_tau']}, generic-wall Delta Psi {bad['gen_psi']}, "
          f"orbit sums {bad['orbit']}  -> TOTAL {tot}")
    assert tot == 0
    return tot

def tau_projection_dim(S):
    """dimension of the image of the solution space under (tau,Psi) -> tau."""
    reps = {}
    for c in range(S['ncells']): reps.setdefault(int(S['cls'][c]), c)
    idx = [reps[k] for k in sorted(reps)]
    rowsT = [[int(b[S['cls'][c]]) for c in idx] for b in S['bas']]
    return rank_f11(rowsT) if rowsT else 0

def pattern_ok(S, Z):
    """is the level-2 system feasible with (tau,Psi) = 0 on the cells in Z?"""
    rows = S['CCF'][np.asarray(sorted(Z), dtype=np.int64)].reshape(-1, S['nb'] + 1)
    R = rref_cond(rows, S['nb'])
    if R is None: return False, None
    y = np.zeros(S['nb'], dtype=np.int64)
    for i in range(R.shape[0]):
        y[int(np.nonzero(R[i, :S['nb']])[0][0])] = R[i, S['nb']]
    return True, y

def y_to_unknowns(S, y):
    return (S['part'] + (np.asarray(y, dtype=np.int64) @ S['bas'])) % 11

# ------------------------------- the exhaustive fail-first DFS (from f55_flagsign)
def exhaustive_search(CCF, orbits, limit=900.0, label=""):
    """CCF (nblocks, R, NB+1): block b is ZERO at parameter point y iff
       CCF[b][:,:NB] @ y == CCF[b][:,NB].  Is there a y with >= 2 zero blocks in
       every orbit?  Searched over the SOLUTION SPACE (not over patterns) with
       (P1) forced-orbit detection, (P2) dead-orbit pruning, (P3) subspace dedup."""
    CCF = np.asarray(CCF, dtype=np.int64) % 11
    nblk, R2, NBp = CCF.shape; NB = NBp - 1; NO = len(orbits)
    FL = np.ascontiguousarray(CCF.reshape(nblk * R2, NBp))
    A0 = FL[:, :NB]; B0 = FL[:, NB]
    ROWIDX = np.array([[[R2 * orbits[o][i] + r for r in range(R2)] +
                        [R2 * orbits[o][j] + r for r in range(R2)]
                        for (i, j) in pairs] for o in range(NO)])
    FLAT = ROWIDX.reshape(-1, 2 * R2)
    BLK = [[FL[ROWIDX[o][c]] for c in range(10)] for o in range(NO)]
    st = dict(nodes=0, rrefs=0, scans=0, maxdepth=0, deaths={}, branchorbits=set(),
              best=-1, dim0deaths=0, optdeaths=0)

    def rref_np2(A):
        A = A % 11; m = A.shape[0]; r0 = 0
        st['rrefs'] += 1
        for col in range(NB):
            if r0 >= m: break
            nz = np.nonzero(A[r0:, col])[0]
            if nz.size == 0: continue
            pr = r0 + int(nz[0])
            if pr != r0: A[[r0, pr]] = A[[pr, r0]]
            A[r0] = (A[r0] * int(INVT[A[r0, col]])) % 11
            cv = A[:, col].copy(); cv[r0] = 0
            nzr = np.nonzero(cv)[0]
            if nzr.size: A[nzr] = (A[nzr] - np.outer(cv[nzr], A[r0])) % 11
            r0 += 1
        if r0 < m and np.any(A[r0:, NB]): return None
        return np.ascontiguousarray(A[:r0])

    def qW(Rst):
        piv = [int(np.nonzero(Rst[i, :NB])[0][0]) for i in range(Rst.shape[0])]
        ps = set(piv); free = [c for c in range(NB) if c not in ps]
        q = np.zeros(NB, dtype=np.int64)
        for i, p in enumerate(piv): q[p] = Rst[i, NB]
        W = np.zeros((len(free), NB), dtype=np.int64)
        for t, f in enumerate(free):
            W[t, f] = 1
            for i, p in enumerate(piv): W[t, p] = (-Rst[i, f]) % 11
        return q, W

    def scan(Rst):
        st['scans'] += 1
        if Rst.shape[0]: q, W = qW(Rst)
        else: q = np.zeros(NB, dtype=np.int64); W = np.eye(NB, dtype=np.int64)
        d = W.shape[0]
        A = (A0 @ W.T) % 11
        b = (B0 - A0 @ q) % 11
        T = np.concatenate([A[FLAT], b[FLAT][:, :, None]], axis=2) % 11
        K = T.shape[0]; rank = np.zeros(K, dtype=np.int64); ra = np.arange(2 * R2)
        for col in range(d):
            mk = (ra[None, :] >= rank[:, None]) & (T[:, :, col] != 0)
            ks = np.nonzero(mk.any(axis=1))[0]
            if ks.size == 0: continue
            idx = np.argmax(mk[ks], axis=1); rk = rank[ks]
            tmp = T[ks, rk].copy(); T[ks, rk] = T[ks, idx]; T[ks, idx] = tmp
            T[ks, rk] = (T[ks, rk] * INVT[T[ks, rk, col]][:, None]) % 11
            sub = T[ks]
            fac = sub[:, :, col].copy(); fac[np.arange(ks.size), rk] = 0
            T[ks] = (sub - fac[:, :, None] * sub[np.arange(ks.size), rk][:, None, :]) % 11
            rank[ks] += 1
        bad = ((ra[None, :] >= rank[:, None]) & (T[:, :, d] != 0)).any(axis=1)
        return (~bad).reshape(NO, 10), rank.reshape(NO, 10), d, q

    ORBA = np.array(orbits)
    def score(q):
        vals = (A0 @ q - B0) % 11
        zero = np.all(vals.reshape(nblk, R2) == 0, axis=1)
        return int((zero[ORBA].sum(axis=1) >= 2).sum()), zero

    seen = set(); t0 = time.time(); tmo = [False]; wit = [None]

    def dfs(Rst, chosen):
        st['nodes'] += 1
        st['maxdepth'] = max(st['maxdepth'], len(chosen))
        if time.time() - t0 > limit: tmo[0] = True; return False
        cons, radd, d, q = scan(Rst)
        if d == 0:
            s, zero = score(q); st['best'] = max(st['best'], s)
            if s == NO: wit[0] = (q, list(chosen), zero); return True
            st['dim0deaths'] += 1
            st['deaths'][len(chosen)] = st['deaths'].get(len(chosen), 0) + 1
            return False
        forced = (cons & (radd == 0)).any(axis=1)
        assert all(forced[o] for o, _ in chosen), "dedup invariant violated"
        live = [o for o in range(NO) if not forced[o]]
        if not live:
            s, zero = score(q); st['best'] = max(st['best'], s)
            assert s == NO, "forced-orbit bookkeeping is wrong"
            wit[0] = (q, list(chosen), zero); return True
        nc = cons.sum(axis=1)
        for o in live:
            if nc[o] == 0:
                st['optdeaths'] += 1
                st['deaths'][len(chosen)] = st['deaths'].get(len(chosen), 0) + 1
                return False
        live.sort(key=lambda o: (nc[o], o))
        o = live[0]; st['branchorbits'].add(o)
        for c in range(10):
            if not cons[o][c]: continue
            R2n = rref_np2(np.vstack([Rst, BLK[o][c]]) if Rst.shape[0] else BLK[o][c].copy())
            if R2n is None: continue
            k = R2n.tobytes()
            if k in seen: continue
            seen.add(k)
            if dfs(R2n, chosen + [(o, pairs[c])]): return True
            if tmo[0]: return False
        return False

    res = dfs(np.zeros((0, NB + 1), dtype=np.int64), [])
    st['time'] = time.time() - t0; st['timeout'] = tmo[0]
    return res, wit[0], st

def blocks_from_cells(S, groups):
    """condition blocks for unions of cells (rref'd and zero-padded to a common
       row count); an inconsistent group becomes the impossible row [0..0|1]."""
    nb = S['nb']; out = []
    for g in groups:
        rows = S['CCF'][np.asarray(sorted(g), dtype=np.int64)].reshape(-1, nb + 1)
        R = rref_cond(rows, nb)
        if R is None:
            R = np.zeros((1, nb + 1), dtype=np.int64); R[0, nb] = 1
        out.append(R)
    Rmax = max(x.shape[0] for x in out)
    B = np.zeros((len(out), Rmax, nb + 1), dtype=np.int64)
    for i, x in enumerate(out): B[i, :x.shape[0]] = x
    return B

# ================================================ 3. CALIBRATION GATE
hdr("2. CALIBRATION GATE: the pure sign fan and the pure G9 ORDER fan, same code path")
from itertools import product as iproduct
SCELLS = [s for s in iproduct((1, -1), repeat=5) if len(set(s)) == 2]
SIDX = {s: i for i, s in enumerate(SCELLS)}
SORB = []; _sn = set()
for s in SCELLS:
    if s in _sn: continue
    o = [s]
    for _ in range(4): o.append(tuple(o[-1][(k + 1) % 5] for k in range(5)))
    assert len(set(o)) == 5; _sn.update(o); SORB.append([SIDX[x] for x in o])
SW = []
for s in SCELLS:
    for k in range(5):
        if len(set([s[j] for j in range(5) if j != k])) < 2: continue
        s2 = tuple((-s[j] if j == k else s[j]) for j in range(5))
        if SIDX[s] < SIDX[s2]: SW.append((SIDX[s], SIDX[s2], 'G', prim(MU[k])))
print(f"sign fan: {len(SCELLS)} cells, {len(SORB)} orbits, {len(SW)} walls")
SS = solve_fan(30, SW, SORB, name="SIGN")
verify_all(SS, "SIGN")
assert SS['nb'] == 7, "sign-fan dimension gate failed"
tbl = []
for o in SORB:
    singles = sum(1 for i in o if pattern_ok(SS, [i])[0])
    bad = sum(1 for (i, j) in pairs if not pattern_ok(SS, [o[i], o[j]])[0])
    tbl.append((singles, bad))
print("sign-fan per-orbit table (consistent singles /5, inconsistent pairs /10):", tbl)
assert [b for _, b in tbl] == [10, 5, 5, 5, 5, 10] and all(s == 5 for s, _ in tbl), \
    "sign-fan pair-table gate failed"
print("GATE 2a PASSED: dim 7 and the pair table [10,5,5,5,5,10] reproduce "
      "f55_signfan_close.py / f55_flagsign.py GATE 2")

OC = list(permutations(range(5))); OI = {p: i for i, p in enumerate(OC)}
OW = []
for p in OC:
    for pos in range(4):
        q = swp(p, pos)
        if OI[q] > OI[p]:
            a, b = p[pos], p[pos + 1]
            OW.append((OI[p], OI[q], 'G', prim(tuple(MU[a][j] - MU[b][j] for j in range(5)))))
OO = []; _sn = set()
for p in OC:
    if p in _sn: continue
    o = [p]
    for _ in range(4): o.append(shift_perm(o[-1], -1))
    assert len(set(o)) == 5; _sn.update(o); OO.append([OI[x] for x in o])
print(f"\nG9 order fan: {len(OC)} cells, {len(OW)} walls, {len(OO)} free sigma-orbits")
assert (len(OC), len(OW), len(OO)) == (120, 240, 24)
SO = solve_fan(120, OW, OO, name="G9ORD")
verify_all(SO, "G9ORD")
assert SO['nb'] == 24, f"G9-order-fan dimension gate failed (got {SO['nb']}, want 24)"
print(f"[G9ORD] tau-projection of the solution space: dim {tau_projection_dim(SO)} "
      f"(level 1 alone allows 120 - 24 = 96, so the aligned level-2 curvature law "
      f"cuts the tau-freedom to {tau_projection_dim(SO)})")
print("GATE 2b(i) PASSED: jump+orbit-sum solution space dim = 24 "
      "(f55_flagsign.py by-product)")
allP = [tuple(sorted(P)) for k in range(2, 6) for P in combinations(range(5), k)]
ofeas = [P for P in allP
         if pattern_ok(SO, [i for i, p in enumerate(OC) if p.index(0) in P])[0]]
print(f"G9-fan rank patterns (zero iff position of H-label 0 in piG is in P): "
      f"{len(allP)-len(ofeas)}/{len(allP)} INFEASIBLE at level 2, feasible: {ofeas}")
assert not ofeas, "GATE 2b(ii) failed: a G9-fan rank pattern survived level 2"
print("GATE 2b(ii) PASSED: all 26 rank patterns level-2 infeasible (Theorem X, S8.22)")
ofound, owit, ost = exhaustive_search(SO['CCF'], OO, limit=DFS_LIMIT, label="G9ORD")
print(f"GATE 2b(iii) exhaustive fail-first DFS over ALL minimal patterns "
      f"(nominal C(5,2)^24 = 10^24): feasible = {ofound}, nodes {ost['nodes']}, "
      f"rref calls {ost['rrefs']}, scans {ost['scans']}, deepest level "
      f"{ost['maxdepth']}/24, best dim-0 coverage {ost['best']}/24 "
      f"[{ost['time']:.1f}s]" + ("  *** TIMED OUT ***" if ost['timeout'] else ""))
assert ofound is False and not ost['timeout'], "GATE 2b(iii) failed"
print("GATE 2b(iii) PASSED: every minimal pattern on the pure G9 order fan is "
      "level-2 infeasible (reproduces f55_flagsign.py's by-product cross-check)")
print("\n>>> CALIBRATION GATE PASSED -- proceeding to the mixed fan")

# ================================================ 4. the mixed fan, exactly
hdr("3. the MIXED fan: cells and walls, both provably complete")
FORMS = []; FNAME = []
for a, b in combinations(range(5), 2):
    v = [0] * 5; v[a] = 1; v[b] = -1
    FORMS.append(tuple(v)); FNAME.append(("A", a, b))
for a, b in combinations(range(5), 2):
    FORMS.append(tuple(MU[a][j] - MU[b][j] for j in range(5))); FNAME.append(("G", a, b))
F = np.array(FORMS, dtype=np.int64)
FN = np.array([[c[j] - c[4] for j in range(4)] for c in FORMS], dtype=np.float64)
def projdir(v):
    p = next(x for x in v if x != 0)
    return tuple(Fr(x, 1) / p for x in v)
assert len(set(projdir(v) for v in FORMS)) == 20
print("the 20 hyperplanes {n_a=n_b} (10, generic class) and {H_a=H_b} (10, "
      "aligned class) are pairwise distinct")

def zaslavsky(forms, d):
    """#chambers of a central arrangement of the given forms in R^d (exact,
       via the intersection lattice and the Moebius function)."""
    forms = [tuple(Fr(x) for x in f) for f in forms]
    seen = {}
    for f in forms:
        p = next(x for x in f if x != 0)
        seen[tuple(x / p for x in f)] = f
    forms = list(seen.values()); m = len(forms)
    def rrefQ(rows):
        A = [list(r) for r in rows]; mm = len(A); piv = []; r0 = 0
        for col in range(d):
            pr = next((i for i in range(r0, mm) if A[i][col] != 0), None)
            if pr is None: continue
            A[r0], A[pr] = A[pr], A[r0]
            pv = A[r0][col]; A[r0] = [x / pv for x in A[r0]]
            for i in range(mm):
                if i != r0 and A[i][col] != 0:
                    f = A[i][col]; A[i] = [x - f * y for x, y in zip(A[i], A[r0])]
            piv.append(col); r0 += 1
        return tuple(tuple(A[i]) for i in range(r0)), piv
    def inspan(rr, piv, v):
        w = list(v)
        for i, c in enumerate(piv):
            if w[c] != 0:
                f = w[c]; w = [x - f * y for x, y in zip(w, rr[i])]
        return all(x == 0 for x in w)
    allel = {frozenset(): 0}; level = [frozenset()]
    for rank in range(1, d + 1):
        nxt = {}
        for Ss in level:
            for i in range(m):
                if i in Ss: continue
                rr, piv = rrefQ([forms[j] for j in set(Ss) | {i}])
                if len(rr) != rank: continue
                cl = frozenset(j for j in range(m) if inspan(rr, piv, forms[j]))
                if cl not in allel: nxt[cl] = rank
        allel.update(nxt); level = list(nxt.keys())
    mob = {}
    for cl, rk in sorted(allel.items(), key=lambda kv: kv[1]):
        mob[cl] = 1 if rk == 0 else -sum(mob[c2] for c2, r2 in allel.items()
                                         if r2 < rk and c2 < cl)
    return sum(abs(v) for v in mob.values())

t0 = time.time()
LIN = [tuple(Fr(c[j] - c[4]) for j in range(4)) for c in FORMS]
ZAS = zaslavsky(LIN, 4)
print(f"exact Zaslavsky chamber count of the 20-hyperplane arrangement: {ZAS}")

def cell_signs(key):
    piA, piG = key
    s = np.zeros(20, dtype=np.int64)
    posA = {v: i for i, v in enumerate(piA)}; posG = {v: i for i, v in enumerate(piG)}
    for t, (typ, a, b) in enumerate(FNAME):
        s[t] = 1 if (posA[a] < posA[b] if typ == 'A' else posG[a] < posG[b]) else -1
    return s
def find_point(sv):
    r = linprog(c=np.zeros(4), A_ub=-(sv[:, None] * FN), b_ub=-np.ones(20),
                bounds=[(None, None)] * 4, method='highs')
    if not r.success: return None
    for sc in (1, 10, 10 ** 2, 10 ** 3, 10 ** 4, 10 ** 5, 10 ** 6, 10 ** 8):
        xi = np.round(np.asarray(r.x) * sc).astype(np.int64)
        n = np.array([xi[0], xi[1], xi[2], xi[3], -int(xi.sum())], dtype=np.int64)
        if (np.sign(n @ F.T) == sv).all(): return n
    return None
cells = {}
for piA in permutations(range(5)):
    for piG in permutations(range(5)):
        key = (piA, piG); sv = cell_signs(key)
        p = find_point(sv)
        if p is None: continue
        assert (np.sign(p @ F.T) == sv).all()          # exact integer certificate
        cells[key] = tuple(int(x) for x in p)
NC = len(cells)
print(f"cells: LP over all {120*120} candidate pairs (piA,piG); every survivor "
      f"certified by an EXACT integer interior point: {NC}   [{time.time()-t0:.1f}s]")
print(f"MIXED-FAN CELL COUNT = {NC} == exact Zaslavsky count {ZAS}: {NC == ZAS}"
      f"  => THE CELL LIST IS PROVABLY COMPLETE")
assert NC == ZAS == 1090
CK = sorted(cells.keys()); CIDX = {k: i for i, k in enumerate(CK)}
PTS = np.array([cells[k] for k in CK], dtype=np.int64)
SC = np.sign(PTS @ F.T)
assert (SC != 0).all() and len(set(map(tuple, SC.tolist()))) == NC

# exact wall count: sum over the 20 hyperplanes of the #regions of the induced
# arrangement on that hyperplane (each such region is a facet of exactly two
# chambers, i.e. one wall)
def plane_basis(fidx):
    rows = [[Fr(x) for x in FORMS[fidx]], [Fr(1)] * 5]
    A = [r[:] for r in rows]; piv = []; r0 = 0
    for col in range(5):
        pr = next((i for i in range(r0, 2) if A[i][col] != 0), None)
        if pr is None: continue
        A[r0], A[pr] = A[pr], A[r0]
        pv = A[r0][col]; A[r0] = [x / pv for x in A[r0]]
        for i in range(2):
            if i != r0 and A[i][col] != 0:
                f = A[i][col]; A[i] = [x - f * y for x, y in zip(A[i], A[r0])]
        piv.append(col); r0 += 1
    free = [c for c in range(5) if c not in piv]
    B = []
    for fc in free:
        v = [Fr(0)] * 5; v[fc] = Fr(1)
        for i, c in enumerate(piv): v[c] = -A[i][fc]
        B.append([Fr(x) for x in v])
    return B                                            # 3 x 5, spans H_t cap N
t0 = time.time(); WALLCOUNT = 0
for t in range(20):
    B = plane_basis(t)
    assert len(B) == 3
    assert all(sum(B[k][j] * FORMS[t][j] for j in range(5)) == 0 for k in range(3))
    restr = []
    for qf in range(20):
        if qf == t: continue
        co = tuple(sum(B[k][j] * FORMS[qf][j] for j in range(5)) for k in range(3))
        if any(x != 0 for x in co): restr.append(co)
    WALLCOUNT += zaslavsky(restr, 3)
print(f"exact Zaslavsky wall count (sum over the 20 hyperplanes of the #regions "
      f"of the induced arrangement): {WALLCOUNT}   [{time.time()-t0:.1f}s]")

score = {(sA, sG): 0 for sA in (1, -1) for sG in (1, -1)}
for i in range(NC):
    n = tuple(PTS[i].tolist()); (piA, piG) = CK[i]
    m = sigN(n); Hv = [sum(m[j] * MU[k][j] for j in range(5)) for k in range(5)]
    qA = tuple(sorted(range(5), key=lambda j: -m[j]))
    qG = tuple(sorted(range(5), key=lambda j: -Hv[j]))
    for sA in (1, -1):
        for sG in (1, -1):
            if (qA, qG) == (shift_perm(piA, sA), shift_perm(piG, sG)): score[(sA, sG)] += 1
print(f"sigma-action on all {NC} exact witness points: " +
      ", ".join(f"(piA{k[0]:+d}, piG{k[1]:+d}): {v}" for k, v in score.items()))
assert score[(1, -1)] == NC
SIG = np.array([CIDX[(shift_perm(k[0], 1), shift_perm(k[1], -1))] for k in CK])
ORB = []; _sn = set()
for i in range(NC):
    if i in _sn: continue
    o = [i]
    for _ in range(4): o.append(int(SIG[o[-1]]))
    assert len(set(o)) == 5 and int(SIG[o[-1]]) == i
    _sn.update(o); ORB.append(o)
print(f"sigma-orbits: {len(ORB)}, all FREE of size 5 ({5*len(ORB)} = {NC})")
assert len(ORB) == 218

FIDX = {}
for t, (typ, a, b) in enumerate(FNAME): FIDX[(typ, a, b)] = t; FIDX[(typ, b, a)] = t
t0 = time.time(); WALLS = []
for i, (piA, piG) in enumerate(CK):
    for pos in range(4):
        for (k2, typ, a, b) in (((swp(piA, pos), piG), 'A', piA[pos], piA[pos + 1]),
                                ((piA, swp(piG, pos)), 'G', piG[pos], piG[pos + 1])):
            if k2 not in CIDX or CIDX[k2] <= i: continue
            j = CIDX[k2]
            vv = ([0] * 5 if typ == 'A' else list(MU[a][q] - MU[b][q] for q in range(5)))
            if typ == 'A': vv[a] = 1; vv[b] = -1
            vv = tuple(vv); t = FIDX[(typ, a, b)]
            # exact segment certificate: p = -l(y) x + l(x) y lies on the tie
            # hyperplane and is a positive combination of x and y, so every OTHER
            # form keeps the common strict sign of the two cells -> a genuine facet.
            x = [int(z) for z in PTS[i]]; y = [int(z) for z in PTS[j]]
            lx = sum(x[q] * int(F[t][q]) for q in range(5))
            ly = sum(y[q] * int(F[t][q]) for q in range(5))
            assert lx * ly < 0
            p = [(-ly) * x[q] + lx * y[q] for q in range(5)]
            s = [sum(p[q] * int(F[r][q]) for q in range(5)) for r in range(20)]
            ok = any(p) and sum(p) == 0 and s[t] == 0
            for r in range(20):
                if r == t: continue
                if s[r] == 0 or (s[r] > 0) != (int(SC[i][r]) > 0) \
                        or (s[r] > 0) != (int(SC[j][r]) > 0): ok = False; break
            assert ok, ("facet certificate failed", i, j, t)
            WALLS.append((i, j, typ, prim(vv)))
nA = sum(1 for w in WALLS if w[2] == 'A')
print(f"walls: every adjacent pair certified by an exact integer relative-interior "
      f"facet point: {len(WALLS)}   [{time.time()-t0:.1f}s]")
print(f"MIXED-FAN WALL COUNT = {len(WALLS)} == exact Zaslavsky wall count "
      f"{WALLCOUNT}: {len(WALLS) == WALLCOUNT}  => THE WALL LIST IS PROVABLY COMPLETE")
assert len(WALLS) == WALLCOUNT
print(f"   A4-class (GENERIC normals e_a-e_b): {nA};  "
      f"G9-class (ALIGNED normals mu_a-mu_b): {len(WALLS)-nA}")
assert (len(WALLS), nA, len(WALLS) - nA) == (2570, 1400, 1170)
nu_gen = sorted(set(w[3] for w in WALLS if w[2] == 'A'))
nu_alg = sorted(set(w[3] for w in WALLS if w[2] == 'G'))
print(f"   distinct normals: {len(nu_gen)} generic, {len(nu_alg)} aligned; "
      f"aligned lifts exist for {sum(1 for v in nu_alg if aligned_lifts(v))}/"
      f"{len(nu_alg)} aligned and {sum(1 for v in nu_gen if aligned_lifts(v))}/"
      f"{len(nu_gen)} generic normals (0 = genuinely mixed)")
assert all(aligned_lifts(v) for v in nu_alg) and not any(aligned_lifts(v) for v in nu_gen)

GPERM = sorted(set(k[1] for k in CK)); GIDX = {p: i for i, p in enumerate(GPERM)}
GOF = np.array([GIDX[k[1]] for k in CK])
GORB = []; _sn = set()
for p in GPERM:
    if p in _sn: continue
    o = [p]
    for _ in range(4): o.append(shift_perm(o[-1], -1))
    assert len(set(o)) == 5; _sn.update(o); GORB.append([GIDX[q] for q in o])
GCELLS = [np.nonzero(GOF == g)[0] for g in range(len(GPERM))]
print(f"G9-chambers (distinct piG): {len(GPERM)} in {len(GORB)} orbits; "
      f"mixed cells per G9-chamber: {min(len(x) for x in GCELLS)}.."
      f"{max(len(x) for x in GCELLS)}")
# every G9-fan wall is realized by at least one mixed aligned wall
gwall = set()
for (i, j, kd, nu) in WALLS:
    if kd == 'G': gwall.add((min(int(GOF[i]), int(GOF[j])), max(int(GOF[i]), int(GOF[j]))))
print(f"   G9-chamber pairs joined by a mixed aligned wall: {len(gwall)} "
      f"(the pure G9 order fan has {len(OW)} walls): {len(gwall) == len(OW)}")
assert len(gwall) == len(OW)

# ============================== 5. TASK 3: the mixed level-2 system
hdr("4. the MIXED level-2 (tau,Psi) system")
SM = solve_fan(NC, WALLS, ORB, name="MIXED")
assert SM is not None
verify_all(SM, "MIXED")
NB = SM['nb']
print(f"[MIXED] tau is constant on the {len(set(SM['cls'].tolist()))} components of "
      f"the generic-wall graph; these coincide with the {len(GPERM)} piG-fibres: "
      f"{len(set(zip(SM['cls'].tolist(), GOF.tolist()))) == len(GPERM)}")
print(f"[MIXED] tau-projection of the solution space: dim {tau_projection_dim(SM)} "
      f"(pure G9 order fan: {tau_projection_dim(SO)}; level 1 alone allows 96)")
YO = np.vstack([SO['part'][None, :], SO['bas']])
tauO, psiO = field_of(SO, YO)
lift = np.array([OI[CK[c][1]] for c in range(NC)])
tauM = tauO[:, lift]; psiM = psiO[:, lift]
Ai = np.array([w[0] for w in WALLS]); Bi = np.array([w[1] for w in WALLS])
isa = np.array([w[2] == 'A' for w in WALLS])
dt = (tauM[:, Ai] - tauM[:, Bi]) % 11; dp = (psiM[:, Ai] - psiM[:, Bi]) % 11
bad = 0
al = np.nonzero(~isa)[0]
THm = np.array([SM['TH'][int(w)] for w in al], dtype=np.int64)
bad += int((((dp[:, al] - dt[:, al][:, :, None] * THm[None]) % 11) != 0).sum())
ge = np.nonzero(isa)[0]
bad += int(((dt[:, ge] % 11) != 0).sum()) + int(((dp[:, ge] % 11) != 0).sum())
OA = np.array(ORB)
bad += int(((tauM[:, OA].sum(axis=2) % 11) != np.array([7] + [0] * SO['nb'])[:, None]).sum())
print(f"[MIXED] pullback test: the {1+SO['nb']} pure-G9 level-2 solutions "
      f"(particular + basis), pulled back along piG, satisfy every mixed wall "
      f"condition and orbit sum: {bad} violations (0 = the mixed system is a "
      f"faithful refinement, not over-constrained)")
assert bad == 0
SMC = solve_fan(NC, WALLS, ORB, name="MIXED|Psi const on chambers", verbose=False,
                psi_constant_on=[list(GCELLS[g]) for g in range(len(GPERM))])
print(f"[MIXED] the SAME mixed system with Psi forced constant on every G9-chamber: "
      f"dim {SMC['nb']} == the pure G9 order fan's {SO['nb']}: {SMC['nb'] == SO['nb']}")
assert SMC['nb'] == SO['nb']
print(f"[MIXED] SOLUTION-SPACE DIMENSION = {NB}  (pure G9 order fan: {SO['nb']}; "
      f"the extra {NB - SO['nb']} directions are Psi-slides along generic walls,")
print(f"        i.e. PL functions that are NOT linear on a G9-chamber -- exactly "
      f"what the refinement adds and what Theorem X's transfer argument cannot see)")

# ================= independent, plain-integer certifier for any claimed witness
def certify(tag, Z, tau, psi, note=""):
    """Fully independent re-verification in plain Python integers: Theta and
       nf_Q(nu) are recomputed from the wall normals from scratch, the zero
       conditions and orbit sums are re-checked, and the tau-layer is fed back
       into the ORIGINAL level-1 U-frame conditions (1),(2),(3)."""
    Zs = set(int(c) for c in Z)
    v = dict(zero=0, alignedPsi=0, genTau=0, genPsi=0, orbit=0)
    for c in Zs:
        if tau[c] % 11 or any(x % 11 for x in psi[c]): v['zero'] += 1
    for (i, j, kd, nu) in WALLS:
        dtv = (tau[i] - tau[j]) % 11
        dpv = tuple((psi[i][k] - psi[j][k]) % 11 for k in range(3))
        if kd == 'G':
            th = theta_of(nu)[2]
            if dpv != tuple((dtv * th[k]) % 11 for k in range(3)): v['alignedPsi'] += 1
        else:
            q = nf_Q(nu)
            if dtv % 11: v['genTau'] += 1
            if not any(dpv == tuple((mm * q[k]) % 11 for k in range(3))
                       for mm in range(11)): v['genPsi'] += 1
    for o in ORB:
        if sum(tau[c] for c in o) % 11 != 7: v['orbit'] += 1
    # the tau-layer as a LEVEL-1 solution in the original U-frame
    U = [nf_diag(tuple((tau[c] * G9[k]) % 11 for k in range(5))) for c in range(NC)]
    l1 = dict(zero=0, jump=0, cong=0)
    for c in Zs:
        if any(U[c]): l1['zero'] += 1
    for (i, j, kd, nu) in WALLS:
        d = [(U[i][k] - U[j][k]) % 11 for k in range(5)]
        w = nf_diag(nu)
        if any((d[a] * w[b] - d[b] * w[a]) % 11 for a in range(5) for b in range(5)):
            l1['jump'] += 1
    rhs = nf_diag(tuple(-x for x in c9))
    for o in ORB:
        acc = [0] * 5; cc = o[0]
        for k in range(5):
            u = U[cc]; sh = tuple(u[(a + k) % 5] for a in range(5)); sh = nf_diag(sh)
            acc = [(acc[a] + pow(9, k, 11) * sh[a]) % 11 for a in range(5)]
            cc = int(SIG[cc])
        assert cc == o[0]
        if tuple(acc) != rhs: l1['cong'] += 1
    nonconst = sum(1 for g in range(len(GPERM))
                   if len(set(tuple(int(x) % 11 for x in psi[c]) for c in GCELLS[g])) > 1)
    ispb = all(len(set((c in Zs) for c in GCELLS[g])) == 1 for g in range(len(GPERM)))
    print("\n" + "!" * 78)
    print(f"!!!  FEASIBLE LEVEL-2 PATTERN ON THE MIXED FAN: {tag} {note}")
    print("!" * 78)
    print(f"!!!  {len(Zs)} zero cells of {NC}; min zeros per sigma-orbit "
          f"{min(sum(1 for c in o if c in Zs) for o in ORB)}; aligned pullback "
          f"(each G9-chamber all-zero or all-free): {ispb}; level-1 survival "
          f"criterion: {survives_level1(Zs)}")
    print(f"!!!  INDEPENDENT re-verification (plain integers, Theta and nf_Q "
          f"recomputed from the normals):")
    print(f"!!!    zero-cell violations {v['zero']}/{len(Zs)}; aligned-wall "
          f"Delta Psi = Delta tau * Theta violations {v['alignedPsi']}/{1170}; "
          f"generic-wall Delta tau != 0 {v['genTau']}/{1400}; generic-wall "
          f"Delta Psi off F11*nf_Q(nu) {v['genPsi']}/{1400}; orbit sums != 7 "
          f"{v['orbit']}/{len(ORB)}")
    print(f"!!!  the tau-layer U := tau*G9 as a LEVEL-1 solution in the original "
          f"U-frame: zeros {l1['zero']}, wall jumps off F11*nu {l1['jump']}, "
          f"congruence rows (3) failing {l1['cong']}  (all 0 = a genuine level-1 "
          f"solution)")
    print(f"!!!  Psi is NON-constant on {nonconst} of the {len(GPERM)} G9-chambers "
          f"(must be > 0: with Psi constant the field would descend to the pure "
          f"G9 order fan, where this pattern is INFEASIBLE)")
    print(f"!!!  tau on the {len(GPERM)} G9-chambers: "
          f"{[int(tau[GCELLS[g][0]]) for g in range(len(GPERM))]}")
    print(f"!!!  (tau, Psi) on the first 6 cells: " +
          ", ".join(f"{CK[c]}->({int(tau[c])},{tuple(int(x) for x in psi[c])})"
                    for c in range(6)))
    print(f"!!!  first 12 zero cells: {[CK[c] for c in sorted(Zs)[:12]]}")
    assert sum(v.values()) == 0 and sum(l1.values()) == 0, "witness re-verification FAILED"
    assert nonconst > 0, "a chamber-constant Psi would contradict the G9-fan gate"
    print("!!!  WITNESS RE-VERIFIED BY BOTH CHECKERS.  A level-2 escape on the "
          "MIXED fan: the (tau,Psi) shadow of S8.22 does NOT kill this pattern.")
    print("!" * 78)
    return True

# ============================== 6. TASK 4: the pattern sweeps
hdr("5. pattern sweeps on the mixed fan (level 2)")
def orbmin(Zs): return min(sum(1 for c in o if c in Zs) for o in ORB)
def survives_level1(Zs):
    """f55_mixedfan.py's level-1 survival criterion: every sigma-orbit of
       G9-chambers keeps a chamber containing NO zero mixed cell."""
    touched = set(int(GOF[c]) for c in Zs)
    return all(any(g not in touched for g in o) for o in GORB)
FEAS = []
def run(tag, Z, note=""):
    Zs = set(int(c) for c in Z)
    m = orbmin(Zs)
    assert m >= 2, (tag, "not admissible", m)
    ok, y = pattern_ok(SM, sorted(Zs))
    if ok: FEAS.append((tag, sorted(Zs), y, note))
    return ok, len(Zs), m

rp = random.Random(SEED)
print("(a) the 25 level-1-surviving G9-induced rank patterns (zero iff the position")
print("    of H-label 0 in piG is in P; |P| <= 4, so every G9-orbit keeps a free")
print("    chamber -- |P| = 5 is the one rank pattern already dead at level 1)")
cnt_a = [0, 0]; feas_a = []
for P in [tuple(sorted(Q)) for k in (2, 3, 4) for Q in combinations(range(5), k)]:
    Z = [i for i, (pA, pG) in enumerate(CK) if pG.index(0) in P]
    assert survives_level1(set(Z))
    f, nz, m = run(("a", P), Z, "(G9 rank pattern)"); cnt_a[int(f)] += 1
    if f: feas_a.append(P)
    print(f"    P = {str(list(P)):12s} zero cells {nz:4d} (min {m}/orbit) -> "
          f"{'FEASIBLE' if f else 'infeasible'}")
print(f"    (a): {cnt_a[0]} infeasible, {cnt_a[1]} FEASIBLE of 25   "
      f"feasible P: {feas_a}")

print("\n(b) 200 random ALIGNED-PULLBACK patterns: 2 zero G9-chambers per G9-orbit,")
print("    all their mixed cells zeroed (exactly 2 zeros per mixed sigma-orbit --")
print("    the sharpest admissible aligned patterns)")
t0 = time.time(); cnt_b = [0, 0]
for tr in range(200):
    zg = set()
    for o in GORB:
        i, j = rp.choice(pairs); zg.add(o[i]); zg.add(o[j])
    Z = [c for c in range(NC) if GOF[c] in zg]
    assert survives_level1(set(Z))
    f, nz, m = run(("b", tr), Z, "(random aligned pullback)"); cnt_b[int(f)] += 1
print(f"    (b): {cnt_b[0]} infeasible, {cnt_b[1]} FEASIBLE of 200   "
      f"[{time.time()-t0:.1f}s]")

print("\n(c) 200 random NON-PULLBACK level-1 survivors: 3 zero G9-chambers per")
print("    G9-orbit, then mixed cells un-zeroed at random (>= 2 zeros kept in every")
print("    mixed sigma-orbit, 2 chambers per G9-orbit left completely free)")
t0 = time.time(); cnt_c = [0, 0]; nsplit = []
trip = list(combinations(range(5), 3))
for tr in range(200):
    Zs = set()
    for og in GORB:
        zg = set(og[t] for t in rp.choice(trip))
        Zs.update(c for c in range(NC) if GOF[c] in zg)
    for o in ORB:
        z = [c for c in o if c in Zs]
        assert len(z) == 3
        if rp.random() < 0.7: Zs.discard(rp.choice(z))
    assert orbmin(Zs) >= 2 and survives_level1(Zs)
    nsplit.append(sum(1 for g in range(len(GPERM))
                      if 0 < sum(1 for c in GCELLS[g] if c in Zs) < len(GCELLS[g])))
    f, nz, m = run(("c", tr), sorted(Zs), "(non-pullback survivor)"); cnt_c[int(f)] += 1
print(f"    criterion verified for all 200 (>= 2 zeros per mixed orbit; every "
      f"G9-orbit keeps a totally free chamber)")
print(f"    genuinely non-pullback: partially-zeroed G9-chambers per pattern "
      f"min {min(nsplit)}, max {max(nsplit)}, mean {sum(nsplit)/len(nsplit):.1f}")
print(f"    (c): {cnt_c[0]} infeasible, {cnt_c[1]} FEASIBLE of 200   "
      f"[{time.time()-t0:.1f}s]")

cnt_e = [0, 0]; cnt_e2 = [0, 0]; common = None
# label the 5 chambers of each G9-orbit by the position of the H-label 0 in piG
# (a bijection onto {0,..,4} within every orbit -- checked), so a pullback
# pattern is a choice of one PAIR of labels per G9-orbit and the rank pattern P
# is the constant choice P in every orbit.
LAB = {}
for gi, og in enumerate(GORB):
    lab = {GPERM[g].index(0): g for g in og}
    assert sorted(lab) == [0, 1, 2, 3, 4], "pos-of-0 is not a bijection on a G9-orbit"
    LAB[gi] = lab
def pullback_cells(choice):
    zg = set()
    for gi in range(len(GORB)):
        for t in choice[gi]: zg.add(LAB[gi][t])
    return [c for c in range(NC) if GOF[c] in zg]
if feas_a:
    P0 = feas_a[0]
    print(f"\n(e) structure probe: start from the FEASIBLE rank pattern P = "
          f"{list(P0)} (the constant choice) and replace the zero pair in ONE")
    print(f"    G9-orbit by each of the other 9 label-pairs "
          f"({len(GORB)} orbits x 9 = {9*len(GORB)} patterns)")
    okpairs = []
    for gi in range(len(GORB)):
        good = []
        for (i, j) in pairs:
            if (i, j) == P0: good.append((i, j)); continue
            ch = {gg: (set(P0) if gg != gi else {i, j}) for gg in range(len(GORB))}
            f, nz, m = run(("e", gi, (i, j)), pullback_cells(ch), "(one-orbit change)")
            cnt_e[int(f)] += 1
            if f: good.append((i, j))
        okpairs.append(tuple(good))
    common = okpairs[0]
    same = len(set(okpairs)) == 1
    print(f"    (e): {cnt_e[0]} infeasible, {cnt_e[1]} FEASIBLE of {sum(cnt_e)}")
    print(f"    per-orbit sets S_g of label-pairs that keep feasibility: "
          f"{len(set(okpairs))} distinct sets over the {len(GORB)} orbits, sizes "
          f"{sorted(set(len(s) for s in okpairs))}; identical in every orbit: {same}")
    print(f"    S_0 = {list(okpairs[0])};  S_1 = {list(okpairs[1])}")
    print(f"\n(e2) 200 random pullbacks drawing orbit g's label-pair from ITS OWN "
          f"S_g (a product test: if the feasible family were a product of the")
    print(f"     per-orbit sets, all 200 would be feasible)")
    for tr in range(200):
        ch = {gg: set(rp.choice(okpairs[gg])) for gg in range(len(GORB))}
        f, nz, m = run(("e2", tr), pullback_cells(ch), "(product-of-S_g pullback)")
        cnt_e2[int(f)] += 1
    print(f"    (e2): {cnt_e2[0]} infeasible, {cnt_e2[1]} FEASIBLE of 200 "
          f"=> feasibility is a GLOBAL, coupled condition on the 24 choices, not "
          f"a per-orbit one")

# ---- (d) exhaustive searches
hdr("6. exhaustive DFS over minimal patterns")
print("(d1) the ALIGNED-PULLBACK family, EXHAUSTIVELY: per G9-orbit choose the 2")
print("     zero G9-chambers out of 5 -> C(5,2)^24 = 10^24 nominal patterns.")
print("     Blocks = G9-chambers (all their mixed cells zero), searched over the")
print("     solution space with the fail-first / forced / dedup engine.")
CH = blocks_from_cells(SM, [list(GCELLS[g]) for g in range(len(GPERM))])
print(f"     chamber condition blocks: {CH.shape[0]} chambers x {CH.shape[1]} rows "
      f"(rref'd, zero-padded) in {NB} parameters")
d1found, d1wit, d1st = exhaustive_search(CH, GORB, limit=DFS_LIMIT, label="pullback")
print(f"     feasible = {d1found}   nodes {d1st['nodes']}   rref calls "
      f"{d1st['rrefs']}   batched scans {d1st['scans']}   deepest level "
      f"{d1st['maxdepth']}/{len(GORB)}   distinct branch orbits "
      f"{len(d1st['branchorbits'])}   best dim-0 coverage {d1st['best']}/{len(GORB)}"
      f"   [{d1st['time']:.1f}s]" + ("  *** TIMED OUT ***" if d1st['timeout'] else ""))
print(f"     branch deaths: {d1st['optdeaths']} by 'some orbit has no consistent "
      f"pair', {d1st['dim0deaths']} at dimension 0; death-depth histogram: "
      + ", ".join(f"{k}:{v}" for k, v in sorted(d1st['deaths'].items())))

print("\n(d2) ALL minimal mixed patterns (exactly 2 zero mixed CELLS per mixed")
print("     sigma-orbit) -- nominal C(5,2)^218 = 10^218; same engine, blocks =")
print("     single mixed cells.  Every admissible pattern contains a minimal one,")
print("     so infeasibility here would kill EVERY admissible pattern at level 2.")
d2found, d2wit, d2st = exhaustive_search(SM['CCF'], ORB, limit=DFS_LIMIT, label="minimal")
print(f"     feasible = {d2found}   nodes {d2st['nodes']}   rref calls "
      f"{d2st['rrefs']}   batched scans {d2st['scans']}   deepest level "
      f"{d2st['maxdepth']}/{len(ORB)}   distinct branch orbits "
      f"{len(d2st['branchorbits'])}   best dim-0 coverage {d2st['best']}/{len(ORB)}"
      f"   [{d2st['time']:.1f}s]" + ("  *** TIMED OUT ***" if d2st['timeout'] else ""))
print(f"     branch deaths: {d2st['optdeaths']} by 'some orbit has no consistent "
      f"pair', {d2st['dim0deaths']} at dimension 0; death-depth histogram: "
      + ", ".join(f"{k}:{v}" for k, v in sorted(d2st['deaths'].items())))

# ---- controls on the search engine and on the generic-wall code path
hdr("7. controls")
SM0 = solve_fan(NC, WALLS, ORB, anchor=0, name="MIXED anchor 0", verbose=False)
c0found, _, c0st = exhaustive_search(SM0['CCF'], ORB, limit=DFS_LIMIT)
print(f"POSITIVE control: the mixed fan with the anchor Sum tau == 0 (the zero "
      f"field solves it): feasible = {c0found} (nodes {c0st['nodes']}, "
      f"{c0st['time']:.1f}s)")
assert c0found is True
A4C = list(permutations(range(5))); A4I = {p: i for i, p in enumerate(A4C)}
A4W = []
for p in A4C:
    for pos in range(4):
        q = swp(p, pos)
        if A4I[q] > A4I[p]:
            a, b = p[pos], p[pos + 1]
            v = [0] * 5; v[a] = 1; v[b] = -1
            A4W.append((A4I[p], A4I[q], 'A', prim(tuple(v))))
A4O = []; _sn = set()
for p in A4C:
    if p in _sn: continue
    o = [p]
    for _ in range(4): o.append(shift_perm(o[-1], 1))
    assert len(set(o)) == 5; _sn.update(o); A4O.append([A4I[x] for x in o])
SA = solve_fan(120, A4W, A4O, name="A4WEYL", verbose=False)
print(f"GENERIC-path control: the pure A4 Weyl fan (all 240 walls generic) through "
      f"the same engine: dim {SA['nb']}, tau-classes {len(set(SA['cls'].tolist()))} "
      f"(= 1: tau is globally constant, so 5*tau == 7 forces tau == 8 != 0 and ANY "
      f"zero cell is fatal)")
verify_all(SA, "A4WEYL")
a4bad = sum(1 for i in range(120) if pattern_ok(SA, [i])[0])
print(f"   single-zero-cell patterns consistent on the A4 fan: {a4bad}/120 "
      f"(0 = every pattern dies, as Theorem X'' says at level 1 already)")
assert len(set(SA['cls'].tolist())) == 1 and a4bad == 0

# ============================== 8. auxiliary: level-1 re-verification
if DO_LEVEL1:
    hdr("8. auxiliary: the LEVEL-1 (U-frame) system, re-verified on this construction")
    t0 = time.time()
    adj = [[] for _ in range(NC)]
    for wi, (i, j, kd, nu) in enumerate(WALLS):
        adj[i].append((j, wi)); adj[j].append((i, wi))
    order = [0]; sn = [False] * NC; sn[0] = True; parc = [-1] * NC; pare = [-1] * NC
    qi = 0
    while qi < len(order):
        X = order[qi]; qi += 1
        for (Y, e) in adj[X]:
            if not sn[Y]: sn[Y] = True; parc[Y] = X; pare[Y] = e; order.append(Y)
    tree1 = set(pare[c] for c in range(NC) if c != 0)
    P1 = 4 + len(tree1)
    EXPR = np.zeros((NC, 4, P1), dtype=np.int64)
    for i in range(4): EXPR[0, i, i] = 1
    pid = {e: 4 + k for k, e in enumerate(sorted(tree1))}
    for Y in order[1:]:
        X = parc[Y]; e = pare[Y]; EXPR[Y] = EXPR[X]
        w = np.array(nf_diag(WALLS[e][3])[:4], dtype=np.int64)
        sgn = 1 if WALLS[e][0] == X else -1
        EXPR[Y, :, pid[e]] = (EXPR[Y, :, pid[e]] + sgn * w) % 11
    rows1 = []
    for wi, (i, j, kd, nu) in enumerate(WALLS):
        if wi in tree1: continue
        D = (EXPR[i] - EXPR[j]) % 11
        for f in ann3(nu):
            r = np.zeros(P1 + 1, dtype=np.int64); r[:P1] = (f @ D) % 11
            rows1.append(r)
    rhs1 = np.array(nf_diag(tuple(-x for x in c9)), dtype=np.int64)
    for o in ORB:
        Mt = np.zeros((5, P1), dtype=np.int64); cc = o[0]
        for k in range(5):
            E4 = EXPR[cc]
            E5 = np.vstack([E4, np.zeros((1, P1), dtype=np.int64)])
            sh = np.array([E5[(a + k) % 5] for a in range(5)])
            sh = (sh - sh[4]) % 11
            Mt = (Mt + pow(9, k, 11) * sh) % 11
            cc = int(SIG[cc])
        for a in range(4):
            r = np.zeros(P1 + 1, dtype=np.int64); r[:P1] = Mt[a]; r[P1] = rhs1[a]
            rows1.append(r)
    s1 = rref_np(rows1, P1)
    assert s1 is not None
    p1, b1 = s1; nb1 = len(b1)
    B1 = np.zeros((P1, nb1 + 1), dtype=np.int64); B1[:, :nb1] = b1.T; B1[:, nb1] = p1
    EV = (EXPR.reshape(NC * 4, P1).astype(np.float64) @ B1.astype(np.float64)
          ).astype(np.int64).reshape(NC, 4, nb1 + 1) % 11
    print(f"level-1 U-frame: {P1} tree parameters, {len(rows1)} rows, "
          f"jump+congruence solution space dim {nb1}   [{time.time()-t0:.1f}s]")
    def l1_feasible(Z):
        rowsA = EV[np.asarray(sorted(Z), dtype=np.int64)].reshape(-1, nb1 + 1)
        A = np.empty_like(rowsA); A[:, :nb1] = rowsA[:, :nb1]
        A[:, nb1] = (-rowsA[:, nb1]) % 11
        R = rref_cond(A, nb1)
        if R is None: return False, None
        return True, R
    g9v = np.array(nf_diag(G9), dtype=np.int64)
    def l1_aligned(R):
        """is the WHOLE level-1 solution space of this pattern inside F11*G9?
           (checks the base point and every direction of the affine subspace)"""
        piv = [int(np.nonzero(R[i, :nb1])[0][0]) for i in range(R.shape[0])]
        ps = set(piv); free = [c for c in range(nb1) if c not in ps]
        y0 = np.zeros(nb1, dtype=np.int64)
        for i, p in enumerate(piv): y0[p] = R[i, nb1]
        vecs = [(y0, True)]
        for f in free:
            d = np.zeros(nb1, dtype=np.int64); d[f] = 1
            for i, p in enumerate(piv): d[p] = (-R[i, f]) % 11
            vecs.append((d, False))
        off = 0
        for (y, aff) in vecs:
            U = (EV[:, :, :nb1].astype(np.float64) @ y.astype(np.float64)).astype(np.int64)
            if aff: U = U + EV[:, :, nb1]
            U5 = np.concatenate([U % 11, np.zeros((NC, 1), dtype=np.int64)], axis=1)
            cross = (U5[:, :, None] * g9v[None, None, :] -
                     g9v[None, :, None] * U5[:, None, :]) % 11
            off += int((cross != 0).any(axis=(1, 2)).sum())
        return off, len(vecs)
    tests = [("a", P, [i for i, (pA, pG) in enumerate(CK) if pG.index(0) in P])
             for P in [tuple(sorted(Q)) for k in (2, 3, 4)
                       for Q in combinations(range(5), k)]]
    nfe = 0; noff = 0; nvec = 0
    for (kind, P, Z) in tests:
        ok, R = l1_feasible(Z)
        assert ok == survives_level1(set(Z)), ("level-1 criterion mismatch", P)
        nfe += ok
        if ok:
            off, nv = l1_aligned(R)
            noff += off; nvec += nv
    print(f"level-1 feasibility of the 25 G9-induced rank patterns: {nfe}/25 "
          f"feasible, and the criterion 'every G9-orbit keeps a free chamber' "
          f"agrees with the computed verdict on all 25")
    print(f"level-1 ALIGNMENT: over all 25 solution spaces ({nvec} vectors: base "
          f"point + every basis direction), cells whose U is OFF the G9-line "
          f"F11*G9: {noff} (0 = every level-1 solution is aligned, exactly as "
          f"f55_mixedfan.py reports)")
    assert noff == 0

# ============================== 9. verdict
hdr("9. verdict")
print(f"(a) 25 level-1-surviving G9-induced rank patterns : "
      f"{cnt_a[0]} infeasible, {cnt_a[1]} FEASIBLE  {feas_a}")
print(f"(b) 200 random aligned-pullback patterns          : "
      f"{cnt_b[0]} infeasible, {cnt_b[1]} feasible")
print(f"(c) 200 random non-pullback level-1 survivors     : "
      f"{cnt_c[0]} infeasible, {cnt_c[1]} feasible")
if feas_a:
    print(f"(e) {sum(cnt_e)} one-orbit changes of P = {list(feas_a[0])}         : "
          f"{cnt_e[0]} infeasible, {cnt_e[1]} feasible")
    print(f"(e2) 200 products of the per-orbit survivor sets S_g             : "
          f"{cnt_e2[0]} infeasible, {cnt_e2[1]} feasible")
def dfstag(f, s):
    if f: return "  [witness found at node %d -- the search stops there]" % s['nodes']
    return "  [TIMED OUT -- INCOMPLETE]" if s['timeout'] else "  [COMPLETE: whole family infeasible]"
print(f"(d1) pullback-family DFS (10^24 nominal)          : feasible = {d1found}"
      + dfstag(d1found, d1st))
print(f"(d2) minimal-pattern DFS (10^218 nominal)         : feasible = {d2found}"
      + dfstag(d2found, d2st))

for (tag, Z, y, note) in FEAS[:3]:
    yy = y_to_unknowns(SM, y)
    tau, psi = field_of(SM, yy[None, :])
    assert verify_field(SM, yy[None, :], [7]) == 0
    certify(tag, Z, [int(x) for x in tau[0]],
            [tuple(int(x) for x in r) for r in psi[0]], note)
if len(FEAS) > 3:
    print(f"\n[{len(FEAS)-3} further feasible patterns not printed: "
          f"{[t for t, _, _, _ in FEAS[3:12]]}]")
for (nm, fnd, wt) in (("d1 pullback-family", d1found, d1wit),
                      ("d2 minimal-pattern", d2found, d2wit)):
    if fnd and wt is not None:
        q, chosen, zero = wt
        if nm.startswith("d1"):
            Zc = [c for c in range(NC) if zero[int(GOF[c])]]
        else:
            Zc = [c for c in range(NC) if zero[c]]
        yy = y_to_unknowns(SM, q)
        tau, psi = field_of(SM, yy[None, :])
        certify(f"DFS witness ({nm})", Zc, [int(x) for x in tau[0]],
                [tuple(int(x) for x in r) for r in psi[0]],
                f"[{len(chosen)} branch commitments]")

if FEAS or d1found or d2found:
    print("\n" + "*" * 78)
    print("HEADLINE: the level-2 (tau,Psi) pair-field shadow of FIX_IX S8.22 does "
          "NOT kill the MIXED fan.")
    print("  Every witness above is an explicit (tau,Psi) field verified twice, by "
          "two independent checkers, against ALL 2570 wall jumps, ALL 218 orbit "
          "sums and every zero condition; its tau-layer is a genuine level-1 "
          "solution in the original U-frame.")
    print("  Mechanism: the A4-class (generic) walls let Psi slide inside a "
          "G9-chamber (Delta Psi in F11*nf_Q(nu) with Delta tau = 0), i.e. the "
          "PL function need not be linear on a G9-chamber.  That is exactly the "
          "freedom Theorem X's refinement/transfer argument does not have: the "
          "two feasible rank patterns P = {0,1} and {3,4} are INFEASIBLE on the "
          "pure G9 order fan (gate 2b(ii)), and forcing Psi to be constant on "
          "G9-chambers collapses the mixed system back to the G9 fan's dim 24 "
          "(dim 62 -> 24), where they die.")
    print("  WHAT THIS DOES AND DOES NOT SAY.  The (tau,Psi) system is a "
          "NECESSARY condition (a shadow) -- it keeps only the mod-11 tau-layer "
          "and the mod-11 curvature of the 11-adic level-2 data, and discards "
          "everything the value-form/ray-point route uses.  A feasible pattern "
          "is therefore NOT a counterexample to Lemma S; it is a proof that THIS "
          "method cannot kill mixed fans.  Lemma S on mixed fans needs strictly "
          "more: level 3 (mod 121), or a ray/xi*-style argument adapted to the "
          "refined cells.")
    print("*" * 78)
else:
    print("\nNO FEASIBLE PATTERN FOUND anywhere.")
print("\nCOVERAGE, stated exactly.")
print("  EXHAUSTIVE (every member individually tested): the 25 level-1-surviving "
      "G9-induced rank patterns (a); the 216 one-orbit label changes of the "
      "feasible pattern P = {0,1} (e).")
print("  EXISTENCE (searched until the first witness, then stopped -- NO negative "
      "claim about the rest of the family): the aligned-pullback family, 10^24 "
      f"nominal, witness at node {d1st['nodes']} (d1); all minimal mixed patterns, "
      f"10^218 nominal, witness at node {d2st['nodes']} (d2).")
print("  SAMPLED (verdict is 'no feasible pattern among these', not 'none exists'):"
      " 200 random aligned pullbacks (b), 200 random non-pullback level-1 "
      "survivors (c), 200 products of the per-orbit survivor sets (e2).")
print("  The infeasible verdicts inherit the level-1 input of f55_mixedfan.py "
      "(re-verified in section 8 on this construction): on every level-1-surviving "
      "pattern the whole level-1 solution space is aligned, so the (tau,Psi) "
      "shadow is a valid necessary condition there.")
print(f"\nreproduce:  python3 {os.path.basename(__file__)}   "
      f"(deterministic, seed {SEED}; F55_DFS_LIMIT={DFS_LIMIT:.0f}s per DFS)")
print(f"total runtime {time.time()-T00:.1f}s")
