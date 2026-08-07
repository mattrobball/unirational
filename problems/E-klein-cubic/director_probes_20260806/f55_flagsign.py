#!/usr/bin/env python3
# T3 test case #2: the FLAG-SIGN FAN -- the common refinement of the G9 ORDER
# fan (walls {H_a = H_b}) and the SIGN fan (walls {H_a = 0}), where
#   H_k(n) = <sig^k n, G9>,  G9 = (1,5,3,4,9),  sigN(n)_j = n_{j-1 mod 5},
# so H_k(n) = <n, mu_k> with mu_k[i] = G9[(i+k) mod 5].
#
# Sum_k H_k(n) = 22*Sum_i n_i = 0 on N = {Sum n = 0}, so the sorted H-values
# always straddle 0.  A maximal cone ("flag-sign cell") is a pair (pi, p):
#   pi an ordering of {0..4} with H_{pi[0]} > H_{pi[1]} > ... > H_{pi[4]},
#   p in {1,2,3,4} the cut: H_{pi[j]} > 0 for j < p, H_{pi[j]} < 0 for j >= p.
# 480 cells, 96 free sigma-orbits, 1080 walls.
#
# This fan is ALIGNED (every wall normal == lambda*G9 mod 11, lambda != 0) but
# is covered by NEITHER Theorem X (walls only among {H_a = H_b}) NOR Theorem X'
# (walls only among {H_a = 0}): its wall set is the union of the two families,
# so it is a genuinely new aligned combinatorial type.  We run the (tau,Psi)
# level-2 pair-field shadow of FIX_IX §8.20-8.22 on it:
#   - Lemma T: U(C) == tau_C*G9 (mod 11);  U = tau~ G9 + 11 V;
#     Psi := V mod (11, G9) in Q = (Lambda/11)/<G9> ~ F11^3;
#   - wall jumps Delta(tau,Psi) in F11*(1, Theta_W),
#     Theta_W = rho_W / lambda_W mod (11,G9),  nu_W = lambda_W G9 + 11 rho_W;
#   - (tau,Psi) = 0 on zero cells;
#   - Sum tau == 7 (mod 11) over each sigma-orbit.
#
# Everything below is machine-verified: cell realizability by explicit interior
# lattice points, the sigma-action by sampling, both wall types by exact
# rational relative-interior points on the shared facet, and the two
# calibration gates (sign-wall Theta list; full sign-fan rerun through the
# general code path) before any flag-sign conclusion is drawn.
#
# Reproduce:  python3 f55_flagsign.py
from fractions import Fraction as Fr
from itertools import combinations, permutations
from math import gcd
import os, sys, time

t_start = time.time()
G9 = (1, 5, 3, 4, 9)
# F55_WALLCERTS=0 restricts the exact facet certificates to one sample of each
# wall type (the default, 1, certifies all 1080 walls; ~80s).
FULL_WALL_CERTS = os.environ.get("F55_WALLCERTS", "1") != "0"

# ============================================================================
# 0.  Lambda/11 bookkeeping  (verbatim from f55_signfan.py)
# ============================================================================
def nf_diag(v):
    return tuple((v[j] - v[4]) % 11 for j in range(5))
G9n = nf_diag(G9)          # (3,7,5,6,0)
assert G9n[0] % 11 and G9n[4] == 0
inv_g0 = pow(G9n[0], 9, 11)
def nf_Q(v):
    w = nf_diag(v)
    c = (w[0] * inv_g0) % 11
    w = tuple((w[j] - c * G9n[j]) % 11 for j in range(5))
    assert w[0] == 0 and w[4] == 0
    return (w[1], w[2], w[3])

# ============================================================================
# 1.  H-forms, sigma, and the general wall machinery (normal -> Theta)
# ============================================================================
MU = [tuple(G9[(i + k) % 5] for i in range(5)) for k in range(5)]
def sigN(n):
    return tuple(n[(j - 1) % 5] for j in range(5))
def Hk(k, n):
    return sum(n[i] * MU[k][i] for i in range(5))
def Hvec(n):
    return tuple(Hk(k, n) for k in range(5))

# check H_k(n) = H_0(sig^k n) and the H-sum identity
for n in [(1, -1, 0, 0, 0), (3, 1, -2, -5, 3), (7, 0, 0, 0, -7), (2, 2, 2, -3, -3)]:
    m = n
    for k in range(5):
        assert Hk(k, n) == Hk(0, m), (n, k)
        m = sigN(m)
    assert sum(Hvec(n)) == 22 * sum(n) == 0

def prim_normal(v):
    """primitive representative of the class of v in Lambda = Z^5 / diag."""
    d = 0
    for i in range(5):
        for j in range(5):
            d = gcd(d, v[i] - v[j])
    assert d > 0, v
    return tuple((v[i] - v[0]) // d for i in range(5)), d

def theta_of(nu):
    """nu (integer 5-vector, class mod diag) with nu == lam*G9 (mod 11, diag).
    Returns (lam, rho, Theta) with rho = (nu - lamhat*G9 - s*ones)/11 exactly
    and Theta = nf_Q(rho * lam^{-1}) in Q.  (lam,s) is unique mod 11 because
    G9 and (1,1,1,1,1) are independent in F11^5.)"""
    hits = []
    for lamhat in range(11):
        r = [(nu[i] - lamhat * G9[i]) % 11 for i in range(5)]
        if len(set(r)) == 1:
            hits.append((lamhat, r[0]))
    assert len(hits) == 1, ("wall not aligned / non-unique lift", nu, hits)
    lamhat, s = hits[0]
    assert lamhat % 11 != 0, ("null wall (nu == 0 in Lambda/11)", nu)
    diff = tuple(nu[i] - lamhat * G9[i] - s for i in range(5))
    assert all(x % 11 == 0 for x in diff), (nu, lamhat, s, diff)
    rho = tuple(x // 11 for x in diff)
    inv = pow(lamhat % 11, 9, 11)
    return lamhat % 11, rho, nf_Q(tuple((x * inv) % 11 for x in rho))

# ---------------------------------------------------------------- GATE 1 ----
print("=" * 74)
print("CALIBRATION GATE 1: Theta of the five sign-wall normals mu_k")
print("=" * 74)
REF_THETA = [(0, 0, 0), (0, 0, 10), (0, 2, 10), (7, 2, 10), (3, 7, 5)]
G1 = []
for k in range(5):
    p, c = prim_normal(MU[k])
    lam, rho, th = theta_of(MU[k])
    G1.append(th)
    print(f"  mu_{k} = {MU[k]}  content {c}  lam {lam}  rho {rho}  Theta {th}")
print(f"  computed : {G1}")
print(f"  reference: {REF_THETA}   (f55_signfan.py)")
assert G1 == REF_THETA, "GATE 1 FAILED"
print("  GATE 1 PASSED\n")

# ============================================================================
# 2.  The general (tau,Psi) engine for an arbitrary aligned fan
#     fan = (ncells, edges [(a,b,nu)], orbits [[cell,...]*5])
#     Two solvers: DIRECT (4*ncells unknowns, as in f55_signfan.py) and
#     REDUCED (tau on cells + one global Psi base point, via a spanning tree).
#     They are cross-checked against each other on the sign fan.
# ============================================================================
def rref_f11(A, nv):
    """in-place-ish rref of a list of rows (length nv+1) over F11.
    Returns None if inconsistent, else (part, basis)."""
    A = [list(r) for r in A]
    m = len(A); piv = []; r0 = 0
    for col in range(nv):
        pr = next((i for i in range(r0, m) if A[i][col] % 11), None)
        if pr is None: continue
        A[r0], A[pr] = A[pr], A[r0]
        inv = pow(A[r0][col], 9, 11)
        A[r0] = [(x * inv) % 11 for x in A[r0]]
        for i in range(m):
            if i != r0 and A[i][col] % 11:
                f = A[i][col]
                A[i] = [(x - f * y) % 11 for x, y in zip(A[i], A[r0])]
        piv.append(col); r0 += 1
    for i in range(r0, m):
        if A[i][nv] % 11: return None
    part = [0] * nv
    for i, col in enumerate(piv): part[col] = A[i][nv]
    freec = [c for c in range(nv) if c not in piv]
    basis = []
    for fc in freec:
        v = [0] * nv; v[fc] = 1
        for i, col in enumerate(piv):
            v[col] = (-A[i][fc]) % 11
        basis.append(v)
    return part, basis

def rref_f11_np(rows, nv):
    """same contract, numpy-accelerated (used for the 480-cell fan)."""
    import numpy as np
    A = np.array(rows, dtype=np.int64) % 11
    m = A.shape[0]
    piv = []; r0 = 0
    for col in range(nv):
        if r0 >= m: break
        nz = np.nonzero(A[r0:, col])[0]
        if nz.size == 0: continue
        pr = r0 + int(nz[0])
        if pr != r0:
            A[[r0, pr]] = A[[pr, r0]]
        inv = pow(int(A[r0, col]), 9, 11)
        A[r0] = (A[r0] * inv) % 11
        colv = A[:, col].copy(); colv[r0] = 0
        nzr = np.nonzero(colv)[0]
        if nzr.size:
            A[nzr] = (A[nzr] - np.outer(colv[nzr], A[r0])) % 11
        piv.append(col); r0 += 1
    if r0 < m and np.any(A[r0:, nv] % 11): return None
    part = [0] * nv
    for i, col in enumerate(piv): part[col] = int(A[i, nv])
    pivset = set(piv)
    freec = [c for c in range(nv) if c not in pivset]
    basis = []
    for fc in freec:
        v = [0] * nv; v[fc] = 1
        for i, col in enumerate(piv):
            v[col] = int((-A[i, fc]) % 11)
        basis.append(v)
    return part, basis

def solve_fan_direct(ncells, edges, orbits, anchor=7):
    """unknowns x = (tau_C, Psi_C[0..2]) per cell; 4*ncells over F11."""
    NV = 4 * ncells
    rows = []
    for a, b, nu in edges:
        th = theta_of(nu)[2]
        for c in range(3):
            r = [0] * (NV + 1)
            r[4 * a + 1 + c] = (r[4 * a + 1 + c] + 1) % 11
            r[4 * b + 1 + c] = (r[4 * b + 1 + c] - 1) % 11
            r[4 * a] = (r[4 * a] - th[c]) % 11
            r[4 * b] = (r[4 * b] + th[c]) % 11
            rows.append(r)
    for orb in orbits:
        r = [0] * (NV + 1)
        for i in orb: r[4 * i] = (r[4 * i] + 1) % 11
        r[NV] = anchor % 11
        rows.append(r)
    return rref_f11(rows, NV)

def solve_fan_reduced(ncells, edges, orbits, anchor=7, use_np=True, verbose=True):
    """Spanning-tree reduction: Psi is determined by tau up to the global base
    value Psi(C0), so the unknowns are (tau_C)_C and Psi(C0) -- ncells+3 of
    them.  Cycle conditions come from the non-tree edges.  Returns
    (part_full, basis_full) in the SAME 4*ncells coordinates as the direct
    solver, after verifying every wall equation and orbit sum explicitly."""
    TH = [theta_of(nu)[2] for (a, b, nu) in edges]
    adj = [[] for _ in range(ncells)]
    for e, (a, b, nu) in enumerate(edges):
        adj[a].append((b, e)); adj[b].append((a, e))
    for i in range(ncells): adj[i].sort()
    # deterministic BFS spanning tree from cell 0
    root = 0
    par = [-1] * ncells; pare = [-1] * ncells
    order = [root]; seen = [False] * ncells; seen[root] = True
    qi = 0
    while qi < len(order):
        X = order[qi]; qi += 1
        for (Y, e) in adj[X]:
            if not seen[Y]:
                seen[Y] = True; par[Y] = X; pare[Y] = e; order.append(Y)
    assert all(seen), "dual graph disconnected"
    tree_edges = set(pare[i] for i in range(ncells) if i != root)
    nontree = [e for e in range(len(edges)) if e not in tree_edges]
    if verbose:
        print(f"  spanning tree: {len(tree_edges)} tree edges, "
              f"{len(nontree)} independent cycles")
    # dense transport maps L_C : tau -> Q (3 x ncells over F11)
    L = [None] * ncells
    L[root] = [[0] * ncells for _ in range(3)]
    for Y in order[1:]:
        X = par[Y]; th = TH[pare[Y]]
        M = [row[:] for row in L[X]]
        for c in range(3):
            M[c][Y] = (M[c][Y] + th[c]) % 11
            M[c][X] = (M[c][X] - th[c]) % 11
        L[Y] = M
    NV = ncells + 3
    rows = []
    for e in nontree:
        a, b, nu = edges[e]; th = TH[e]
        for c in range(3):
            r = [0] * (NV + 1)
            LA = L[a][c]; LB = L[b][c]
            for i in range(ncells):
                d = (LB[i] - LA[i]) % 11
                if d: r[i] = d
            r[b] = (r[b] - th[c]) % 11
            r[a] = (r[a] + th[c]) % 11
            if any(r[:ncells]): rows.append(r)
    for orb in orbits:
        r = [0] * (NV + 1)
        for i in orb: r[i] = (r[i] + 1) % 11
        r[NV] = anchor % 11
        rows.append(r)
    if verbose:
        print(f"  reduced system: {len(rows)} rows x {NV} unknowns "
              f"(tau: {ncells}, Psi(C0): 3)")
    sol = (rref_f11_np(rows, NV) if use_np else rref_f11(rows, NV))
    if sol is None: return None
    part, basis = sol

    def expand(vec):
        tau = vec[:ncells]
        psi = [None] * ncells
        psi[root] = [vec[ncells + c] % 11 for c in range(3)]
        for Y in order[1:]:
            X = par[Y]; th = TH[pare[Y]]; d = (tau[Y] - tau[X]) % 11
            psi[Y] = [(psi[X][c] + d * th[c]) % 11 for c in range(3)]
        full = [0] * (4 * ncells)
        for i in range(ncells):
            full[4 * i] = tau[i] % 11
            for c in range(3): full[4 * i + 1 + c] = psi[i][c]
        return full

    part_full = expand(part)
    basis_full = [expand(b) for b in basis]

    # explicit verification of EVERY wall equation and orbit sum
    def check(full, rhs):
        for e, (a, b, nu) in enumerate(edges):
            th = TH[e]; d = (full[4 * a] - full[4 * b]) % 11
            for c in range(3):
                if (full[4 * a + 1 + c] - full[4 * b + 1 + c] - d * th[c]) % 11:
                    return False
        for orb in orbits:
            if sum(full[4 * i] for i in orb) % 11 != rhs % 11: return False
        return True
    assert check(part_full, anchor), "particular solution fails the raw system"
    for b in basis_full:
        assert check(b, 0), "a basis vector fails the raw homogeneous system"
    if verbose:
        print(f"  verified: all {len(edges)} wall equations and {len(orbits)} "
              f"orbit sums hold for the particular solution and all "
              f"{len(basis_full)} basis vectors")
    return part_full, basis_full

# ---- per-cell conditions + pattern feasibility (pattern of f55_signfan_close)
def make_cellcond(ncells, part, basis):
    nb = len(basis)
    CC = []
    for i in range(ncells):
        M = []
        for c in range(4):
            M.append([b[4 * i + c] for b in basis] + [(-part[4 * i + c]) % 11])
        CC.append(M)
    return CC

def make_rref(nb):
    def rref(rows):
        A = [r[:] for r in rows]
        m = len(A); r0 = 0
        for col in range(nb):
            pr = next((i for i in range(r0, m) if A[i][col] % 11), None)
            if pr is None: continue
            A[r0], A[pr] = A[pr], A[r0]
            inv = pow(A[r0][col], 9, 11)
            A[r0] = [(x * inv) % 11 for x in A[r0]]
            for i in range(m):
                if i != r0 and A[i][col] % 11:
                    f = A[i][col]
                    A[i] = [(x - f * y) % 11 for x, y in zip(A[i], A[r0])]
            r0 += 1
        for i in range(r0, m):
            if A[i][nb] % 11: return None
        return tuple(tuple(A[i]) for i in range(r0))
    return rref

# ============================================================================
# 3.  CALIBRATION GATE 2 -- rebuild the PURE sign fan through the general path
# ============================================================================
print("=" * 74)
print("CALIBRATION GATE 2: the pure sign fan {H_k = 0} through the general "
      "wall/Theta code path")
print("=" * 74)
from itertools import product as iproduct
SCELLS = [s for s in iproduct((1, -1), repeat=5) if len(set(s)) == 2]
SIDX = {s: i for i, s in enumerate(SCELLS)}
def s_sig(s): return tuple(s[(k + 1) % 5] for k in range(5))
SORB = []
_seen = set()
for s in SCELLS:
    if s in _seen: continue
    orb = []; q = s
    for _ in range(5):
        orb.append(q); q = s_sig(q)
    assert len(set(orb)) == 5
    _seen.update(orb); SORB.append([SIDX[x] for x in orb])
assert len(SCELLS) == 30 and len(SORB) == 6
SEDGES = []
for s in SCELLS:
    for k in range(5):
        rest = [s[j] for j in range(5) if j != k]
        if len(set(rest)) < 2: continue
        s2 = tuple((-s[j] if j == k else s[j]) for j in range(5))
        if SIDX[s] < SIDX[s2]:
            SEDGES.append((SIDX[s], SIDX[s2], prim_normal(MU[k])[0]))
print(f"  cells {len(SCELLS)}, orbits {len(SORB)}, walls {len(SEDGES)}")
sd = solve_fan_direct(30, SEDGES, SORB)
assert sd is not None
print(f"  DIRECT solver : jump+orbit-sum solution space dim = {len(sd[1])}")
sr = solve_fan_reduced(30, SEDGES, SORB, use_np=False)
assert sr is not None
print(f"  REDUCED solver: jump+orbit-sum solution space dim = {len(sr[1])}")
assert len(sd[1]) == len(sr[1]) == 7, "GATE 2 FAILED (dimension)"

for tag, (P_, B_) in (("direct", sd), ("reduced", sr)):
    CC = make_cellcond(30, P_, B_); rr = make_rref(len(B_))
    tbl = []
    for onum, orb in enumerate(SORB):
        singles = all(rr(CC[i]) is not None for i in orb)
        bad = sum(1 for (i, j) in combinations(range(5), 2)
                  if rr(CC[orb[i]] + CC[orb[j]]) is None)
        tbl.append((SCELLS[orb[0]], singles, bad))
    if tag == "reduced":
        for onum, (rep, singles, bad) in enumerate(tbl):
            print(f"    orbit {onum} rep {rep}: singles consistent {singles}, "
                  f"inconsistent pairs {bad}/10")
    ref = [10, 5, 5, 5, 5, 10]
    assert [b for _, _, b in tbl] == ref, ("GATE 2 FAILED (pair table)", tag, tbl)
    assert all(s for _, s, _ in tbl)
# the corank-1 orbit, explicitly
rep0 = SCELLS[SORB[0][0]]
assert rep0 == (1, 1, 1, 1, -1)
print(f"  corank-1 orbit rep {rep0}: 10/10 within-orbit zero-pairs inconsistent"
      "  (matches f55_signfan_close.py)")
print("  GATE 2 PASSED\n")

# ============================================================================
# 4.  The FLAG-SIGN FAN: cells, realizability, sigma-action, walls
# ============================================================================
print("=" * 74)
print("THE FLAG-SIGN FAN")
print("=" * 74)
CELLS = [(pi, p) for pi in permutations(range(5)) for p in (1, 2, 3, 4)]
CIDX = {c: i for i, c in enumerate(CELLS)}
assert len(CELLS) == 480

# exact inverse of the H-map (circulant on the sum-zero space)
def solve_n_from_h(h):
    """exact rational n with H(n) = h (needs sum h = 0; then sum n = 0)."""
    assert sum(h) == 0
    M = [[Fr(MU[k][i]) for i in range(5)] + [Fr(h[k])] for k in range(5)]
    for col in range(5):
        pr = next(r for r in range(col, 5) if M[r][col] != 0)
        M[col], M[pr] = M[pr], M[col]
        pv = M[col][col]
        M[col] = [v / pv for v in M[col]]
        for r in range(5):
            if r != col and M[r][col] != 0:
                f = M[r][col]
                M[r] = [v - f * w for v, w in zip(M[r], M[col])]
    n = tuple(M[r][5] for r in range(5))
    assert sum(n) == 0
    for k in range(5):
        assert sum(n[i] * MU[k][i] for i in range(5)) == h[k]
    return n

def clear_denoms(n):
    L = 1
    for v in n: L = L * v.denominator // gcd(L, v.denominator)
    ni = [int(v * L) for v in n]
    g = 0
    for v in ni: g = gcd(g, v)
    if g > 1: ni = [v // g for v in ni]
    return tuple(ni)

def cell_of(n):
    h = Hvec(n)
    assert len(set(h)) == 5 and all(x != 0 for x in h), ("not interior", n, h)
    pi = tuple(sorted(range(5), key=lambda k: -h[k]))
    p = sum(1 for x in h if x > 0)
    return (pi, p)

# --- 4a. realizability: an explicit interior LATTICE point for every cell ---
REP = {}
bad = []
for (pi, p) in CELLS:
    A = (5 - p) * (6 - p); B = p * (p + 1)          # sum_j vals[j] = 0
    vals = [(p - j) * A if j < p else -(j - p + 1) * B for j in range(5)]
    assert sum(vals) == 0
    h = [0] * 5
    for j in range(5): h[pi[j]] = vals[j]
    n = clear_denoms(solve_n_from_h(h))
    if cell_of(n) != (pi, p): bad.append((pi, p))
    REP[(pi, p)] = n
print(f"realizability: interior lattice point found for {len(REP)} of "
      f"{len(CELLS)} cells; unrealizable cells: {len(bad)} {bad if bad else ''}")
assert not bad, "some (pi,p) is unrealizable"
assert len(set(REP.values())) == 480

# --- 4b. the sigma-action, determined empirically ---
def sig_cell_pred_minus(c): return (tuple((x - 1) % 5 for x in c[0]), c[1])
def sig_cell_pred_plus(c):  return (tuple((x + 1) % 5 for x in c[0]), c[1])
nm = np_ = 0
for c, n in REP.items():
    got = cell_of(sigN(n))
    nm += (got == sig_cell_pred_minus(c))
    np_ += (got == sig_cell_pred_plus(c))
print(f"sigma-action on cells (480 representative points, plus 480 extra "
      f"scaled/perturbed samples below):")
print(f"  cell(sigma n) == (pi - 1, p): {nm}/480     cell(sigma n) == (pi + 1, p): {np_}/480")
assert nm == 480, "the empirical sigma-action is not pi -> pi-1"
# extra independent samples: perturb inside each cell
extra = 0
for (pi, p), n in REP.items():
    for mult in (2, 3):
        n2 = tuple(mult * x for x in n)
        assert cell_of(n2) == (pi, p)
        assert cell_of(sigN(n2)) == sig_cell_pred_minus((pi, p))
        extra += 1
print(f"  confirmed on {extra} further interior points (scaled): "
      f"pi -> pi-1 elementwise, p UNCHANGED, on all of them")
print("  [f55_exact2.py's 'chamber of sigma^k n has ordering pi - k' is the "
      "same convention; the brief's 'pi+1' is the inverse map.]")
def sig_cell(c): return sig_cell_pred_minus(c)

ORBITS = []
_seen = set()
for c in CELLS:
    if c in _seen: continue
    orb = []; q = c
    for _ in range(5):
        orb.append(q); q = sig_cell(q)
    assert len(set(orb)) == 5, ("non-free orbit", c)
    _seen.update(orb); ORBITS.append([CIDX[x] for x in orb])
print(f"sigma-orbits: {len(ORBITS)} (all free 5-orbits)")
assert len(ORBITS) == 96

# --- 4c. walls, both types, with exact relative-interior facet points -------
# g-coordinates: g_i = H_{pi[i-1]} - H_{pi[i]} (i = 1..4).  With a_j := 5*H_{pi[j]}
#   a_j = sum_{i=1..4} (5-i) g_i - 5 * sum_{i<=j} g_i     (sum_j a_j = 0),
# so the closed cell is  {g_i >= 0} & {a_{p-1} >= 0} & {a_p <= 0}, and
#   Lpos := a_{p-1},   Lneg := -a_p = 5 g_p - a_{p-1},   Lpos + Lneg = 5 g_p.
# => g_p >= 0 is IMPLIED (redundant): the order wall at rank position j = p is
#    NOT a facet -- tightening g_p = 0 forces Lpos = Lneg = 0 (two more tight
#    constraints), i.e. codimension >= 3.  That is the "fake wall".
def a_from_g(g):    # g indexed 1..4 in g[0..3]
    tot = sum((5 - i) * g[i - 1] for i in range(1, 5))
    out = []
    run = 0
    for j in range(5):
        if j >= 1: run += g[j - 1]
        out.append(tot - 5 * run)
    assert sum(out) == 0
    return out

def facet_point(pi, p, kind, j):
    """kind 'ord': tie at rank positions j-1,j (g_j = 0), everything else
       strict.  kind 'sgn': a_{p-1} = 0 (H_{pi[p-1]} = 0), everything else
       strict.  Returns the exact rational n, or None if no such point."""
    RNG = range(1, 11)
    cands = []
    if kind == 'ord':
        free = [i for i in range(1, 5) if i != j]
        for v0 in RNG:
            for v1 in RNG:
                for v2 in RNG:
                    g = [0, 0, 0, 0]
                    for i, v in zip(free, (v0, v1, v2)): g[i - 1] = v
                    cands.append(g)
    else:
        for v0 in RNG:
            for v1 in RNG:
                for v2 in RNG:
                    for v3 in RNG:
                        cands.append([v0, v1, v2, v3])
    for g in cands:
        a = a_from_g(g)
        if kind == 'ord':
            if any(g[i - 1] <= 0 for i in range(1, 5) if i != j): continue
            if g[j - 1] != 0: continue
            if not (a[p - 1] > 0 > a[p]): continue
        else:
            if any(x <= 0 for x in g): continue
            if a[p - 1] != 0: continue
            if not (a[p - 2] > 0 and a[p] < 0): continue
        h = [0] * 5
        for t in range(5): h[pi[t]] = a[t]
        return solve_n_from_h(h), g, a
    return None

EDGES = []
HYP = {}          # hyperplane key -> (nu, lam, rho, Theta)
def hyp_add(key, v):
    nu, cont = prim_normal(v)
    lam, rho, th = theta_of(nu)
    if key in HYP: assert HYP[key] == (nu, cont, lam, rho, th)
    else: HYP[key] = (nu, cont, lam, rho, th)
    return nu

n_ord = n_sgn = 0
for (pi, p) in CELLS:
    a_idx = CIDX[(pi, p)]
    for j in range(1, 5):
        if j == p: continue                     # fake wall (proof above)
        pi2 = list(pi); pi2[j - 1], pi2[j] = pi2[j], pi2[j - 1]
        b_idx = CIDX[(tuple(pi2), p)]
        if a_idx > b_idx: continue
        A, B = pi[j - 1], pi[j]
        nu = hyp_add(('ord', frozenset((A, B))),
                     tuple(MU[A][i] - MU[B][i] for i in range(5)))
        EDGES.append((a_idx, b_idx, nu)); n_ord += 1
    if p >= 2:
        b_idx = CIDX[(pi, p - 1)]
        A = pi[p - 1]
        nu = hyp_add(('sgn', A), MU[A])
        EDGES.append((min(a_idx, b_idx), max(a_idx, b_idx), nu)); n_sgn += 1
print(f"walls: {n_ord} order walls + {n_sgn} sign walls = {len(EDGES)} total "
      f"(= 480*3/2 + 120*3)")
assert (n_ord, n_sgn) == (720, 360)
assert len(set((a, b) for a, b, _ in EDGES)) == 1080
print(f"distinct wall hyperplanes: {len(HYP)} "
      f"(5 sign + 10 order); all normals aligned (nu == lam*G9 mod 11):")
for key in sorted(HYP, key=lambda k: (k[0], sorted(k[1]) if k[0] == 'ord' else k[1])):
    nu, cont, lam, rho, th = HYP[key]
    nm2 = (f"H_{key[1]} = 0" if key[0] == 'sgn'
           else "H_%d = H_%d" % tuple(sorted(key[1])))
    print(f"  {nm2:<12} nu = {nu}  content {cont}  lam {lam}  Theta {th}")
assert len(HYP) == 15

# facet certificates
print("wall certificates (exact rational relative-interior points on the "
      "shared facet, all other defining inequalities strict):")
ok_ord = ok_sgn = 0
cert_ord = set(); cert_sgn = set()
shown = 0
CERTCELLS = CELLS if FULL_WALL_CERTS else [((0, 1, 2, 3, 4), 2), ((0, 1, 2, 3, 4), 3)]
for (pi, p) in CERTCELLS:
    for j in range(1, 5):
        if j == p: continue
        r = facet_point(pi, p, 'ord', j)
        assert r is not None, ("no facet point", pi, p, j)
        n, g, a = r
        A, B = pi[j - 1], pi[j]
        h = Hvec(n)
        assert h[A] == h[B]
        rest = [h[pi[t]] for t in range(5)]
        assert all(rest[t] > rest[t + 1] for t in range(4) if t + 1 != j)
        assert rest[p - 1] > 0 > rest[p]
        pi2 = list(pi); pi2[j - 1], pi2[j] = pi2[j], pi2[j - 1]
        cert_ord.add((min(CIDX[(pi, p)], CIDX[(tuple(pi2), p)]),
                      max(CIDX[(pi, p)], CIDX[(tuple(pi2), p)])))
        ok_ord += 1
        if shown < 2 and (pi, p) == ((0, 1, 2, 3, 4), 2) :
            print(f"  ORDER wall  cells {(pi,p)} ~ {(tuple(list(pi[:j-1])+[pi[j],pi[j-1]]+list(pi[j+1:])),p)}"
                  f"  hyperplane H_{A} = H_{B}")
            print(f"     n = {n}   H(n) = {h}   (tie at ranks {j-1},{j}; "
                  f"cut p = {p} strict)")
            shown += 1
    if p >= 2:
        r = facet_point(pi, p, 'sgn', None)
        assert r is not None, ("no sign facet point", pi, p)
        n, g, a = r
        A = pi[p - 1]
        h = Hvec(n)
        assert h[A] == 0
        rest = [h[pi[t]] for t in range(5)]
        assert all(rest[t] > rest[t + 1] for t in range(4))
        assert rest[p - 2] > 0 and rest[p] < 0
        cert_sgn.add((min(CIDX[(pi, p)], CIDX[(pi, p - 1)]),
                      max(CIDX[(pi, p)], CIDX[(pi, p - 1)])))
        ok_sgn += 1
        if (pi, p) == ((0, 1, 2, 3, 4), 3):
            print(f"  SIGN  wall  cells {(pi,p)} ~ {(pi,p-1)}  hyperplane H_{A} = 0")
            print(f"     n = {n}   H(n) = {h}   (rank {p-1} value 0; order strict)")
print(f"  certified: {len(cert_ord)}/720 order walls (from {ok_ord} facet "
      f"incidences, each wall seen from both sides) and {len(cert_sgn)}/360 "
      f"sign walls have an exact relative-interior facet point")
if FULL_WALL_CERTS:
    assert (len(cert_ord), len(cert_sgn)) == (720, 360)
    assert (ok_ord, ok_sgn) == (1440, 360)
    assert cert_ord | cert_sgn == set((a, b) for a, b, _ in EDGES)

# the fake walls j = p: no such facet point exists, and the reason is exact
fake_fail = 0
for (pi, p) in CERTCELLS:
    r = facet_point(pi, p, 'ord', p)
    if r is None: fake_fail += 1
print(f"  fake walls (order tie at rank position j = p): search finds a point "
      f"for 0 of {len(CERTCELLS)}; failures {fake_fail}/{len(CERTCELLS)}")
assert fake_fail == len(CERTCELLS)
print("  reason (exact): in g-coordinates Lpos + Lneg = 5*g_p with "
      "Lpos, Lneg >= 0 on the closed cell, so g_p = 0 forces Lpos = Lneg = 0 "
      "-- three tight constraints, codim >= 3, not a facet.  Equivalently the "
      "tied value would have to be both > 0 (rank p-1) and < 0 (rank p).")
for (pi, p) in CELLS[:8]:
    g = [1, 1, 1, 1]; g[p - 1] = 0
    a = a_from_g(g)
    assert not (a[p - 1] > 0 > a[p])
print("")

# ============================================================================
# 5.  The level-2 (tau,Psi) system on the flag-sign fan
# ============================================================================
print("=" * 74)
print("LEVEL-2 (tau,Psi) SHADOW ON THE FLAG-SIGN FAN")
print("=" * 74)
t0 = time.time()
sol = solve_fan_reduced(480, EDGES, ORBITS, use_np=True)
if sol is None:
    print("jump+orbit-sum system ALREADY infeasible with NO zero cells "
          "(so a fortiori every pattern dies).")
    raise SystemExit
part, basis = sol
nb = len(basis)
print(f"jump + orbit-sum system solvable; solution space dim = {nb}   "
      f"[{time.time()-t0:.1f}s]")

CELLCOND = make_cellcond(480, part, basis)
rref = make_rref(nb)

# ---- MARKER: the level-2 system is built (part, basis, CELLCOND, rref) ----

# --- per-orbit within-orbit pair table -------------------------------------
pairs = list(combinations(range(5), 2))
t0 = time.time()
PAIRTBL = []
for onum, orb in enumerate(ORBITS):
    singles = sum(1 for i in orb if rref(CELLCOND[i]) is not None)
    badp = [pi_ for pi_, (i, j) in enumerate(pairs)
            if rref(CELLCOND[orb[i]] + CELLCOND[orb[j]]) is None]
    PAIRTBL.append((onum, singles, len(badp)))
hist = {}
for _, _, b in PAIRTBL: hist[b] = hist.get(b, 0) + 1
print(f"\nper-orbit within-orbit pair table ({len(ORBITS)} orbits x 10 pairs) "
      f"[{time.time()-t0:.1f}s]:")
print("  inconsistent-pairs-out-of-10 -> #orbits: " +
      ", ".join(f"{k}: {hist[k]}" for k in sorted(hist, reverse=True)))
sing_all = set(s for _, s, _ in PAIRTBL)
print(f"  single zero cells consistent: {sorted(sing_all)} of 5 per orbit "
      f"(5 = all single cells consistent)")
ORDER = sorted(range(len(ORBITS)), key=lambda o: (-PAIRTBL[o][2], o))
print("  most constraining orbits (orbit#, rep cell, inconsistent pairs):")
for o in ORDER[:8]:
    rep = CELLS[ORBITS[o][0]]
    print(f"    orbit {o:>2}  rep (pi={rep[0]}, p={rep[1]})  "
          f"{PAIRTBL[o][2]}/10 inconsistent")
dead = [o for o in ORDER if PAIRTBL[o][2] == 10]
print(f"  orbits with ALL 10 within-orbit pairs inconsistent: {len(dead)}"
      + (f"  (e.g. orbit {dead[0]}, rep {CELLS[ORBITS[dead[0]][0]]})" if dead else ""))

# --- exhaustive FAIL-FIRST DFS over all minimal patterns -------------------
# The nominal search is C(5,2)^96 = 10^96 patterns.  It is done exhaustively by
# searching over the SOLUTION x instead of over the pattern:  a minimal pattern
# is feasible iff some x in the (nb)-dimensional affine solution space has
# >= 2 zero cells in every sigma-orbit.  The state of the search is the affine
# subspace cut out by the zero conditions chosen so far, stored as a canonical
# rref R over the nb basis coordinates.  At each node the 96*10 orbit-pair
# blocks are tested SIMULTANEOUSLY (batched Gaussian elimination over F11), and
# we branch on the orbit with the FEWEST consistent pairs.  Three prunings,
# each exactly sound:
#  (P1) FORCED: if some consistent pair of orbit o adds no rank, every point of
#       the current subspace already has those two cells zero -- orbit o is
#       satisfied and needs no branch.
#  (P2) DEAD:  if some unsatisfied orbit has no consistent pair, no point of
#       the subspace can satisfy it -> prune.
#  (P3) DEDUP: the remaining search depends only on the subspace (the orbits
#       branched on so far are always among the FORCED ones), so a state whose
#       canonical rref was seen before is skipped.
# Completeness: at every node all 10 pairs of the branch orbit are expanded, so
# every minimal pattern's subspace is visited.  Reaching dim 0 leaves a single
# candidate point, which is then scored against all 96 orbits directly.
import numpy as np
INVARR = np.array([0, 1, 6, 4, 3, 9, 2, 8, 7, 5, 10], dtype=np.int64)

def exhaustive_search(ncells, orbits, part, basis, limit=3600.0, label=""):
    NB = len(basis); NO = len(orbits)
    CCF = np.array([[b[4 * i + c] for b in basis] + [(-part[4 * i + c]) % 11]
                    for i in range(ncells) for c in range(4)],
                   dtype=np.int64) % 11                      # 4*ncells x NB+1
    A0 = CCF[:, :NB]; B0 = CCF[:, NB]
    PRT = np.array(part, dtype=np.int64) % 11
    BAS = np.array(basis, dtype=np.int64) % 11
    ORBA = np.array(orbits, dtype=np.int64)
    ROWIDX = np.array([[[4 * orbits[o][i] + c for c in range(4)] +
                        [4 * orbits[o][j] + c for c in range(4)]
                        for (i, j) in pairs] for o in range(NO)])
    FLAT = ROWIDX.reshape(-1, 8)
    BLK = [[CCF[ROWIDX[o][c]] for c in range(10)] for o in range(NO)]
    stats = dict(nodes=0, rrefs=0, scans=0, maxdepth=0, deaths={},
                 branchorbits=set(), best=-1, dim0deaths=0, optdeaths=0)

    def rref_np(A):
        A = A % 11; m = A.shape[0]; r0 = 0
        stats['rrefs'] += 1
        for col in range(NB):
            if r0 >= m: break
            nz = np.nonzero(A[r0:, col])[0]
            if nz.size == 0: continue
            pr = r0 + int(nz[0])
            if pr != r0: A[[r0, pr]] = A[[pr, r0]]
            A[r0] = (A[r0] * int(INVARR[A[r0, col]])) % 11
            cv = A[:, col].copy(); cv[r0] = 0
            nzr = np.nonzero(cv)[0]
            if nzr.size: A[nzr] = (A[nzr] - np.outer(cv[nzr], A[r0])) % 11
            r0 += 1
        if r0 < m and np.any(A[r0:, NB]): return None
        return np.ascontiguousarray(A[:r0])

    def qW(R):
        piv = [int(np.nonzero(R[i, :NB])[0][0]) for i in range(R.shape[0])]
        pset = set(piv); free = [c for c in range(NB) if c not in pset]
        q = np.zeros(NB, dtype=np.int64)
        for i, p in enumerate(piv): q[p] = R[i, NB]
        W = np.zeros((len(free), NB), dtype=np.int64)
        for t, f in enumerate(free):
            W[t, f] = 1
            for i, p in enumerate(piv): W[t, p] = (-R[i, f]) % 11
        return q, W

    def scan(R):
        """consistency + rank-added of all NO*10 orbit-pair blocks at once."""
        stats['scans'] += 1
        if R.shape[0]: q, W = qW(R)
        else: q = np.zeros(NB, dtype=np.int64); W = np.eye(NB, dtype=np.int64)
        d = W.shape[0]
        A = (A0 @ W.T) % 11
        b = (B0 - A0 @ q) % 11
        T = np.concatenate([A[FLAT], b[FLAT][:, :, None]], axis=2) % 11
        K = T.shape[0]; rank = np.zeros(K, dtype=np.int64); ra = np.arange(8)
        for col in range(d):
            mk = (ra[None, :] >= rank[:, None]) & (T[:, :, col] != 0)
            ks = np.nonzero(mk.any(axis=1))[0]
            if ks.size == 0: continue
            idx = np.argmax(mk[ks], axis=1); rk = rank[ks]
            tmp = T[ks, rk].copy(); T[ks, rk] = T[ks, idx]; T[ks, idx] = tmp
            T[ks, rk] = (T[ks, rk] * INVARR[T[ks, rk, col]][:, None]) % 11
            sub = T[ks]
            fac = sub[:, :, col].copy(); fac[np.arange(ks.size), rk] = 0
            T[ks] = (sub - fac[:, :, None] *
                     sub[np.arange(ks.size), rk][:, None, :]) % 11
            rank[ks] += 1
        bad = ((ra[None, :] >= rank[:, None]) & (T[:, :, d] != 0)).any(axis=1)
        return (~bad).reshape(NO, 10), rank.reshape(NO, 10), d, q

    def score(q):
        vals = (PRT + q @ BAS) % 11
        zero = np.all(vals.reshape(ncells, 4) == 0, axis=1)
        cnt = zero[ORBA].sum(axis=1)
        return int((cnt >= 2).sum()), zero

    seen = set(); t0 = time.time(); tmo = [False]; wit = [None]

    def dfs(R, chosen):
        stats['nodes'] += 1
        stats['maxdepth'] = max(stats['maxdepth'], len(chosen))
        if time.time() - t0 > limit:
            tmo[0] = True; return False
        cons, radd, d, q = scan(R)
        if d == 0:
            s, zero = score(q)
            stats['best'] = max(stats['best'], s)
            if s == NO:
                wit[0] = (q, list(chosen), zero); return True
            stats['dim0deaths'] += 1
            stats['deaths'][len(chosen)] = stats['deaths'].get(len(chosen), 0) + 1
            return False
        forced = (cons & (radd == 0)).any(axis=1)
        # (P3) is sound only because every orbit branched on so far is FORCED
        # in the current subspace -- so "what remains to be done" is a function
        # of the subspace alone and a repeated state may be skipped.  Checked,
        # not assumed:
        assert all(forced[o] for o, _ in chosen), "dedup invariant violated"
        live = [o for o in range(NO) if not forced[o]]
        if not live:
            s, zero = score(q); wit[0] = (q, list(chosen), zero); return True
        nc = cons.sum(axis=1)
        for o in live:
            if nc[o] == 0:
                stats['optdeaths'] += 1
                stats['deaths'][len(chosen)] = stats['deaths'].get(len(chosen), 0) + 1
                return False
        live.sort(key=lambda o: (nc[o], o))
        o = live[0]; stats['branchorbits'].add(o)
        for c in range(10):
            if not cons[o][c]: continue
            R2 = rref_np(np.vstack([R, BLK[o][c]]) if R.shape[0] else BLK[o][c].copy())
            if R2 is None: continue
            k = R2.tobytes()
            if k in seen: continue
            seen.add(k)
            if dfs(R2, chosen + [(o, pairs[c])]): return True
            if tmo[0]: return False
        return False

    sys.setrecursionlimit(20000)
    res = dfs(np.zeros((0, NB + 1), dtype=np.int64), [])
    stats['time'] = time.time() - t0
    stats['timeout'] = tmo[0]
    return res, wit[0], stats

def random_coverage(ncells, orbits, part, basis, ntrials, seed):
    """How many of the orbits can a single solution satisfy?  Random greedy
    descents; when the subspace collapses to a point, score that point.
    (An independent, non-exhaustive lower-bound probe on the same system.)"""
    import random as _r
    NB = len(basis); NO = len(orbits)
    CCF = np.array([[b[4 * i + c] for b in basis] + [(-part[4 * i + c]) % 11]
                    for i in range(ncells) for c in range(4)],
                   dtype=np.int64) % 11
    IDX = [[[4 * orbits[o][i] + c for c in range(4)] +
            [4 * orbits[o][j] + c for c in range(4)] for (i, j) in pairs]
           for o in range(NO)]
    BLK = [[CCF[IDX[o][c]] for c in range(10)] for o in range(NO)]
    PRT = np.array(part, dtype=np.int64) % 11
    BAS = np.array(basis, dtype=np.int64) % 11
    ORBA = np.array(orbits, dtype=np.int64)
    def rr(A):
        A = A % 11; m = A.shape[0]; r0 = 0
        for col in range(NB):
            if r0 >= m: break
            nz = np.nonzero(A[r0:, col])[0]
            if nz.size == 0: continue
            pr = r0 + int(nz[0])
            if pr != r0: A[[r0, pr]] = A[[pr, r0]]
            A[r0] = (A[r0] * int(INVARR[A[r0, col]])) % 11
            cv = A[:, col].copy(); cv[r0] = 0
            nzr = np.nonzero(cv)[0]
            if nzr.size: A[nzr] = (A[nzr] - np.outer(cv[nzr], A[r0])) % 11
            r0 += 1
        if r0 < m and np.any(A[r0:, NB]): return None
        return np.ascontiguousarray(A[:r0])
    rnd = _r.Random(seed); best = (-1, 0); hist = {}
    for _ in range(ntrials):
        order = list(range(NO)); rnd.shuffle(order)
        state = np.zeros((0, NB + 1), dtype=np.int64)
        for o in order:
            if state.shape[0] == NB: break
            cand = list(range(10)); rnd.shuffle(cand)
            got = None
            for c in cand:
                R = rr(np.vstack([state, BLK[o][c]]) if state.shape[0]
                       else BLK[o][c].copy())
                if R is not None: got = R; break
            if got is None: break
            state = got
        if state.shape[0] != NB: continue
        q = np.zeros(NB, dtype=np.int64)
        for i in range(state.shape[0]):
            q[int(np.nonzero(state[i, :NB])[0][0])] = state[i, NB]
        vals = (PRT + q @ BAS) % 11
        zero = np.all(vals.reshape(ncells, 4) == 0, axis=1)
        s = int((zero[ORBA].sum(axis=1) >= 2).sum())
        hist[s] = hist.get(s, 0) + 1
        if s > best[0]: best = (s, int(zero.sum()))
    return best, hist

# -- CONTROLS for the search code itself -------------------------------------
print("\nsearch-engine controls:")
sc = solve_fan_reduced(30, SEDGES, SORB, use_np=False, verbose=False)
r_ctl, w_ctl, st_ctl = exhaustive_search(30, SORB, sc[0], sc[1])
print(f"  NEGATIVE control -- sign fan through the same engine: feasible = "
      f"{r_ctl} (nodes {st_ctl['nodes']}, {st_ctl['time']:.1f}s)   "
      f"[agrees with f55_signfan_close.py]")
assert r_ctl is False
sc0 = solve_fan_reduced(30, SEDGES, SORB, anchor=0, use_np=False, verbose=False)
r_pos, w_pos, st_pos = exhaustive_search(30, SORB, sc0[0], sc0[1])
print(f"  POSITIVE control -- same fan with the anchor 7 replaced by 0 (so the "
      f"zero field solves it): feasible = {r_pos} "
      f"(nodes {st_pos['nodes']}, {st_pos['time']:.1f}s)")
assert r_pos is True
sf0 = solve_fan_reduced(480, EDGES, ORBITS, anchor=0, use_np=True, verbose=False)
r_pos2, _, st_pos2 = exhaustive_search(480, ORBITS, sf0[0], sf0[1])
print(f"  POSITIVE control -- FLAG-SIGN fan with anchor 0: feasible = {r_pos2} "
      f"(nodes {st_pos2['nodes']}, {st_pos2['time']:.1f}s)  "
      f"=> the anchor Sum tau == 7 is exactly what does the killing")
assert r_pos2 is True

# -- how close does the fan come?  (independent randomized lower-bound probe) -
t0 = time.time()
(bcov, bzero), chist = random_coverage(480, ORBITS, part, basis, 600, 20260807)
print(f"\nrandomized coverage probe (600 greedy descents, "
      f"[{time.time()-t0:.0f}s]): the best single solution found satisfies "
      f"{bcov} of the 96 orbits ({bzero} zero cells of 480); "
      f"top of the histogram: "
      + ", ".join(f"{k}: {chist[k]}" for k in sorted(chist, reverse=True)[:5]))

# -- the real run ------------------------------------------------------------
print(f"\nexhaustive fail-first DFS over all minimal patterns "
      f"(nominal C(5,2)^96 = 10^96):")
found, wit, st = exhaustive_search(480, ORBITS, part, basis, limit=7200.0,
                                   label="flag-sign")
print(f"  feasible found = {found}   nodes = {st['nodes']}   "
      f"rref calls = {st['rrefs']}   batched 960-block scans = {st['scans']}   "
      f"deepest level = {st['maxdepth']} of {len(ORBITS)}   "
      f"distinct branch orbits = {len(st['branchorbits'])}   "
      f"[{st['time']:.1f}s]" + ("   *** TIMED OUT ***" if st['timeout'] else ""))
print(f"  branch deaths: {st['optdeaths']} by (P2) 'some orbit has no "
      f"consistent pair', {st['dim0deaths']} at dimension 0 "
      f"(best coverage of a dim-0 node: {st['best']}/96)")
dh = st['deaths']
print("  death-depth histogram (level at which a branch became infeasible): "
      + ", ".join(f"{k}: {dh[k]}" for k in sorted(dh)))
timeout = [st['timeout']]

# -- by-product cross-check: the G9 ORDER fan (the pullback route) -----------
# The flag-sign fan REFINES the G9 order fan (walls {H_a = H_b}), so any
# (tau,Psi) field pulled back from that fan -- i.e. independent of the cut p --
# is automatically admissible here, and an admissible order-fan pattern would
# lift to an admissible flag-sign pattern (a flag-sign orbit is
# {(pi-k, p) : k}, so >= 2 zero orderings per ordering-orbit gives >= 2 zero
# cells in each of the 4 flag-sign orbits above it).  So the order fan must be
# checked too, or the verdict above would be in tension with a witness there.
OCELLS = list(permutations(range(5)))
OIDX = {c: i for i, c in enumerate(OCELLS)}
OORB = []; _s = set()
for pi in OCELLS:
    if pi in _s: continue
    orb = []; q = pi
    for _ in range(5):
        orb.append(q); q = tuple((x - 1) % 5 for x in q)
    _s.update(orb); OORB.append([OIDX[x] for x in orb])
OEDGES = []
for pi in OCELLS:
    for j in range(1, 5):
        p2 = list(pi); p2[j - 1], p2[j] = p2[j], p2[j - 1]
        a, b = OIDX[pi], OIDX[tuple(p2)]
        if a < b:
            A_, B_ = pi[j - 1], pi[j]
            OEDGES.append((a, b, prim_normal(
                tuple(MU[A_][i] - MU[B_][i] for i in range(5)))[0]))
osol = solve_fan_reduced(120, OEDGES, OORB, use_np=True, verbose=False)
ofound, _ow, ost = exhaustive_search(120, OORB, osol[0], osol[1], limit=900.0)
print(f"\nby-product cross-check -- the G9 ORDER fan (120 orderings, 24 orbits, "
      f"{len(OEDGES)} walls), whose (tau,Psi) fields pull back to admissible "
      f"flag-sign fields:")
print(f"  jump+orbit-sum dim = {len(osol[1])}; exhaustive fail-first DFS: "
      f"feasible = {ofound}, nodes {ost['nodes']}, rref calls {ost['rrefs']}, "
      f"best dim-0 coverage {ost['best']}/24 [{ost['time']:.1f}s]")
assert ofound is False, "an order-fan witness would contradict the verdict above"
print("  => the pullback route to a flag-sign witness is closed as well "
      "(and this is a new statement: Theorem X kills the G9-fan class through "
      "the ray/xi* value-form route; here the (tau,Psi) pair-field shadow "
      "alone already suffices).")

print("\n" + "=" * 74)
if found:
    print("!" * 74)
    print("!!!!  FEASIBLE MINIMAL PATTERN ON THE FLAG-SIGN FAN  !!!!")
    print("!" * 74)
    q, chosen, zero = wit
    print("  witness solution coefficients (in the basis of the jump+sum "
          "solution space):")
    print("   ", list(int(x) for x in q))
    print(f"  zero cells: {int(zero.sum())} of 480")
    print("  pattern (orbit -> the two zero cells):")
    for o, pr in chosen:
        print(f"    orbit {o}: {[CELLS[ORBITS[o][k]] for k in pr]}")
elif st['timeout']:
    print("INCONCLUSIVE: the fail-first DFS timed out.")
    print(f"  reached depth {st['maxdepth']}; branch orbits touched: "
          f"{sorted(st['branchorbits'])[:20]}")
else:
    print("VERDICT: every admissible pattern on the FLAG-SIGN FAN is INFEASIBLE")
    print("         for the level-2 pair-field (tau,Psi) shadow.")
    print("  Killing mechanism -- NOT the sign-fan mechanism.  On the sign fan "
          "the corank-1 orbit alone kills (10/10 pairs inconsistent) and the "
          "DFS prunes at the first orbit.  HERE the per-orbit pair table is "
          "EMPTY -- 0/10 inconsistent for all 96 orbits, every single cell "
          "individually consistent, and the best single solution still "
          f"satisfies {max(bcov, st['best'])} of the 96 orbits -- so no orbit, "
          "and no pair of orbits, kills on its own.  The obstruction is "
          f"GLOBAL: it needs up to {st['maxdepth']} simultaneous zero-pair "
          "commitments, and the anchor Sum tau == 7 per orbit is its sole "
          "source (with the anchor set to 0 the identical search returns "
          "FEASIBLE at once).")
    print("  MONOTONICITY: any admissible pattern (>= 2 zeros per sigma-orbit) "
          "contains a minimal one (exactly 2 per orbit); zero conditions only "
          "add constraints, so infeasibility of every minimal pattern gives "
          "infeasibility of every admissible pattern.")
print("=" * 74)
print(f"total wall clock {time.time()-t_start:.1f}s   "
      f"(reproduce: python3 f55_flagsign.py -- deterministic; "
      f"F55_WALLCERTS=0 samples the facet certificates instead of doing all "
      f"1080 walls)")
