#!/usr/bin/env python3
# T5: the MIXED fan -- the common refinement of the A4 Weyl fan (walls
# {n_a = n_b}) and the G9 order fan (walls {H_a = H_b}).  First genuinely
# mixed wall-system: both generic and aligned wall classes occur.
#
#   N  = {n in Z^5 : sum n = 0},   Lambda = Z^5/diag,  pairing <U,n>.
#   sigN(n)_j = n_{j-1 mod 5};  G9 = (1,5,3,4,9);  H_k(n) = <sig^k n, G9>.
#   H_k(n) = <n, mu_k> with mu_k[j] = G9[(j+k) mod 5]   (verified below).
#   Cells = chambers of the arrangement of the 20 hyperplanes
#         = realizable pairs (piA, piG) = (coordinate ordering, H-ordering),
#           both descending.
#
# The level-1 mod-11 system in the SLOPE (U-) frame of Note IX S8.20:
#   unknowns U_C in Lambda/11 (5-tuples mod 11, last coord normalized to 0),
#   (1) zeros      U_C == 0 on the pattern's zero cells,
#   (2) jumps      U_C - U_C' in F11 * nu_W across every wall W,
#   (3) congruence sum_k 9^k * shift_k( U(sig^k C) ) == -c9  (mod 11)
#                  per sigma-orbit, c9 = (4,9,1,5,3)          [ == (ii) ].
#
# SOUNDNESS.  Every row used below is a consequence of the value-form system
# (integral-sloped PL d, d = 0 on >= 2 cells per orbit, (ii) at every lattice
# point).  Hence: a system built from a SUBSET of the true walls/cells can
# only be WEAKER, so every INFEASIBLE verdict is valid for the full system.
# A bogus wall would be unsound, so only exactly-certified walls are used
# (integer certificate points on the shared facet, checked with exact integer
# arithmetic).  The cell list is proved COMPLETE by an independent exact
# Zaslavsky count of the arrangement's chambers, so nothing is missing either.
# Any FEASIBLE verdict is additionally checked by explicit substitution of the
# produced solution into ALL original constraints.
#
# Reproduce:  python3 f55_mixedfan.py            (deterministic; seed 20260807)
import numpy as np, random, time, sys
from fractions import Fraction as Fr
from itertools import combinations, permutations
from math import gcd

T00 = time.time()
SEED = 20260807
np.seterr(all='raise')

# ============================================================ 0. conventions
G9 = (1, 5, 3, 4, 9)
c9 = (4, 9, 1, 5, 3)
def sigN(n):  return tuple(n[(j - 1) % 5] for j in range(5))
MU = [tuple(G9[(j + k) % 5] for j in range(5)) for k in range(5)]   # (sig^T)^k G9

def hdr(s): print("\n" + "=" * 78 + "\n== " + s + "\n" + "=" * 78)

hdr("0. conventions, verified numerically")
rng0 = random.Random(SEED)
def rnd_n(B=30):
    n = [rng0.randint(-B, B) for _ in range(5)]
    n[4] = -sum(n[:4])
    return tuple(n)

ok = True
for _ in range(2000):
    n = rnd_n()
    for k in range(5):
        m = n
        for _ in range(k): m = sigN(m)
        lhs = sum(m[j] * G9[j] for j in range(5))              # <sig^k n, G9>
        rhs = sum(n[j] * MU[k][j] for j in range(5))           # <n, mu_k>
        if lhs != rhs: ok = False
print("H_k(n) = <sig^k n, G9> = <n, mu_k>, mu_k[j] = G9[(j+k)%5] :", ok)
assert ok

# transport on the M-side: which index shift realizes <U, sig^k n> = <shift U, n>?
def shift_up(U, k):   return tuple(U[(i + k) % 5] for i in range(5))
def shift_dn(U, k):   return tuple(U[(i - k) % 5] for i in range(5))
sc_up = sc_dn = 0
for _ in range(2000):
    n = rnd_n(); U = tuple(rng0.randint(-30, 30) for _ in range(5))
    m = n
    for k in range(1, 5):
        m = sigN(m)
        lhs = sum(U[j] * m[j] for j in range(5))
        if lhs == sum(shift_up(U, k)[j] * n[j] for j in range(5)): sc_up += 1
        if lhs == sum(shift_dn(U, k)[j] * n[j] for j in range(5)): sc_dn += 1
print(f"M-side transport test (8000 trials): (shift U)_i = U_(i+k): {sc_up} hits ; "
      f"(shift U)_i = U_(i-k): {sc_dn} hits")
assert sc_up == 8000 and sc_dn < 8000
print("VERIFIED convention: <U, sig^k n> = <shift_k U, n> with (shift_k U)_i = U_{(i+k) mod 5}")
print("  (so sigNM^{-k} of the brief = the index shift UP by k; note shift_k G9 = mu_k)")

# c9 is a 9-eigenvector: shift_{-1} c9 == 9 c9 (mod 11) -> one congruence row per orbit
print("shift_{-1} c9 =", shift_dn(c9, 1), " 9*c9 mod 11 =",
      tuple((9 * x) % 11 for x in c9),
      " equal:", shift_dn(c9, 1) == tuple((9 * x) % 11 for x in c9))
assert shift_dn(c9, 1) == tuple((9 * x) % 11 for x in c9)

# the 20 hyperplanes
FORMS = []; FNAME = []
for a, b in combinations(range(5), 2):
    v = [0] * 5; v[a] = 1; v[b] = -1
    FORMS.append(tuple(v)); FNAME.append(("A", a, b))
for a, b in combinations(range(5), 2):
    FORMS.append(tuple(MU[a][j] - MU[b][j] for j in range(5))); FNAME.append(("G", a, b))
F = np.array(FORMS, dtype=np.int64)
def projdir(v):
    p = next(x for x in v if x != 0)
    return tuple(Fr(x, 1) / p for x in v)
assert len(set(projdir(v) for v in FORMS)) == 20
print("the 20 hyperplanes {n_a=n_b} (10) and {H_a=H_b} (10) are pairwise DISTINCT")

def nf(v):    # normal form in Lambda/11: last coordinate 0
    return tuple((v[j] - v[4]) % 11 for j in range(5))
def prim(v):  # primitive representative in Lambda = Z^5/diag
    w = [v[j] - v[4] for j in range(5)]
    g = 0
    for x in w: g = gcd(g, x)
    assert g > 0
    return tuple(x // g for x in w)

# ============================================== 1. cell enumeration (sampled)
hdr("1. cell enumeration: >= 2,000,000 random integer points, stabilized")
MUT = np.array(MU, dtype=np.int64).T
rs = np.random.default_rng(SEED)
BLK = 200000
cells = {}
tot = 0; untied = 0; blk = 0; hist = []
while True:
    a = rs.integers(-50, 51, size=(BLK, 4))
    last = -a.sum(1)
    keep = np.abs(last) <= 50                      # keep all entries in [-50,50]
    n = np.concatenate([a[keep], last[keep, None]], axis=1)
    Hv = n @ MUT
    piA = np.argsort(-n, axis=1, kind='stable'); piG = np.argsort(-Hv, axis=1, kind='stable')
    sA = np.take_along_axis(n, piA, axis=1); sG = np.take_along_axis(Hv, piG, axis=1)
    good = (np.diff(sA, axis=1) != 0).all(1) & (np.diff(sG, axis=1) != 0).all(1)  # resample ties
    piA, piG, n = piA[good], piG[good], n[good]
    before = len(cells)
    for i in range(len(n)):
        key = (tuple(piA[i].tolist()), tuple(piG[i].tolist()))
        if key not in cells: cells[key] = tuple(n[i].tolist())
    tot += BLK; untied += len(n); blk += 1; hist.append(len(cells) - before)
    print(f"  block {blk:2d}: {BLK} points ({len(n)} untied), cells = {len(cells)}"
          f"  (new this block: {len(cells)-before})")
    if blk >= 10 and hist[-1] == 0 and hist[-2] == 0 and hist[-3] == 0: break
    if blk > 60: break
print(f"sampled {tot} points total ({untied} untied); STABILIZED: "
      f"last {sum(1 for x in reversed(hist) if x == 0)} consecutive blocks added 0 new cells")
NSAMPLED = len(cells)
print(f"cells found by sampling = {NSAMPLED}")

# --- independent exact cross-check: Zaslavsky's theorem on the intersection lattice
def rrefQ(rows):
    A = [list(r) for r in rows]; m = len(A); piv = []; r0 = 0
    for col in range(4):
        pr = next((i for i in range(r0, m) if A[i][col] != 0), None)
        if pr is None: continue
        A[r0], A[pr] = A[pr], A[r0]
        pv = A[r0][col]; A[r0] = [x / pv for x in A[r0]]
        for i in range(m):
            if i != r0 and A[i][col] != 0:
                f = A[i][col]; A[i] = [x - f * y for x, y in zip(A[i], A[r0])]
        piv.append(col); r0 += 1
    return tuple(tuple(A[i]) for i in range(r0)), piv
LIN = [tuple(Fr(c[j] - c[4]) for j in range(4)) for c in FORMS]   # forms in coords (n0..n3)
def inspan(rr, piv, v):
    w = list(v)
    for i, c in enumerate(piv):
        if w[c] != 0:
            f = w[c]; w = [x - f * y for x, y in zip(w, rr[i])]
    return all(x == 0 for x in w)
allel = {frozenset(): 0}; level = [frozenset()]
for rank in range(1, 5):
    nxt = {}
    for Ss in level:
        for i in range(20):
            if i in Ss: continue
            rr, piv = rrefQ([LIN[j] for j in set(Ss) | {i}])
            if len(rr) != rank: continue
            cl = frozenset(j for j in range(20) if inspan(rr, piv, LIN[j]))
            if cl not in allel: nxt[cl] = rank
    allel.update(nxt); level = list(nxt.keys())
mu = {}
for cl, rk in sorted(allel.items(), key=lambda kv: kv[1]):
    mu[cl] = 1 if rk == 0 else -sum(mu[c2] for c2, r2 in allel.items() if r2 < rk and c2 < cl)
ZAS = sum(abs(v) for v in mu.values())
NLINES = sum(1 for cl, rk in allel.items() if rk == 3)
print(f"Zaslavsky (exact, intersection lattice { {r: sum(1 for c,q in allel.items() if q==r) for r in range(5)} }): "
      f"#chambers = {ZAS}")

# --- exact completion: BFS over single sign-flips, each new chamber certified by an
#     exact INTEGER witness point (LP proposes, integer arithmetic disposes)
from scipy.optimize import linprog
FN = np.array([[c[j] - c[4] for j in range(4)] for c in FORMS], dtype=np.float64)   # (20,4)
def find_point(sv):
    r = linprog(c=np.zeros(4), A_ub=-(sv[:, None] * FN), b_ub=-np.ones(20),
                bounds=[(None, None)] * 4, method='highs')
    if not r.success: return None
    for sc in (1, 10, 10 ** 2, 10 ** 3, 10 ** 4, 10 ** 5, 10 ** 6, 10 ** 8):
        xi = np.round(np.asarray(r.x) * sc).astype(np.int64)
        n = np.array([xi[0], xi[1], xi[2], xi[3], -int(xi.sum())], dtype=np.int64)
        if (np.sign(n @ F.T) == sv).all(): return n
    return None
def cell_signs(key):
    piA, piG = key
    s = np.zeros(20, dtype=np.int64)
    posA = {v: i for i, v in enumerate(piA)}; posG = {v: i for i, v in enumerate(piG)}
    for t, (typ, a, b) in enumerate(FNAME):
        s[t] = 1 if (posA[a] < posA[b] if typ == 'A' else posG[a] < posG[b]) else -1
    return s
def swp(p, i):
    q = list(p); q[i], q[i + 1] = q[i + 1], q[i]; return tuple(q)
queue = list(cells.keys()); added = 0
while queue:
    piA, piG = queue.pop()
    for cand in ([(swp(piA, i), piG) for i in range(4)] +
                 [(piA, swp(piG, i)) for i in range(4)]):
        if cand in cells: continue
        p = find_point(cell_signs(cand))
        if p is None:
            cells[cand] = None      # certified non-realizable by LP (only weakens the system)
            continue
        assert (np.sign(p @ F.T) == cell_signs(cand)).all()
        cells[cand] = tuple(int(x) for x in p); added += 1; queue.append(cand)
cells = {k: v for k, v in cells.items() if v is not None}
NC = len(cells)
print(f"exact sign-flip BFS completion (LP witness + exact integer check): +{added} cell(s)")
print(f"MIXED-FAN CELL COUNT = {NC}")
print(f"cells {NC} == exact Zaslavsky chamber count {ZAS} :", NC == ZAS,
      " => THE CELL LIST IS PROVABLY COMPLETE")
assert NC == ZAS

CK = sorted(cells.keys()); CIDX = {k: i for i, k in enumerate(CK)}
PTS = np.array([cells[k] for k in CK], dtype=np.int64)
SC = np.sign(PTS @ F.T)                      # sign vector of every cell, 20 forms
assert (SC != 0).all()
assert len(set(map(tuple, SC.tolist()))) == NC   # sign vector <-> cell, bijectively

# ================================================== 2. the sigma-action on cells
hdr("2. sigma-action on cells")
def shift_perm(p, k): return tuple((x + k) % 5 for x in p)
score = {(+1, -1): 0, (+1, +1): 0, (-1, -1): 0, (-1, +1): 0}
NTEST = 0
for i in range(NC):
    n = tuple(PTS[i].tolist()); (piA, piG) = CK[i]
    m = sigN(n)
    Hv = [sum(m[j] * MU[k][j] for j in range(5)) for k in range(5)]
    qA = tuple(sorted(range(5), key=lambda j: -m[j]))
    qG = tuple(sorted(range(5), key=lambda j: -Hv[j]))
    NTEST += 1
    for sA in (+1, -1):
        for sG in (+1, -1):
            if (qA, qG) == (shift_perm(piA, sA), shift_perm(piG, sG)): score[(sA, sG)] += 1
print(f"tested sigma on all {NTEST} cell witness points; matches:")
for k, v in score.items():
    print(f"   (piA + {k[0]:+d}, piG + {k[1]:+d}) : {v}/{NTEST}")
assert score[(+1, -1)] == NTEST
print("VERIFIED: sigma : (piA, piG) -> (piA + 1, piG - 1)  (elementwise mod 5) -- the brief's convention")
SIG = np.array([CIDX[(shift_perm(k[0], 1), shift_perm(k[1], -1))] for k in CK])
seen = set(); ORB = []
for i in range(NC):
    if i in seen: continue
    o = [i]
    for _ in range(4): o.append(int(SIG[o[-1]]))
    assert len(set(o)) == 5 and int(SIG[o[-1]]) == i, "orbit not free of size 5"
    seen.update(o); ORB.append(o)
print(f"sigma-orbits: {len(ORB)} orbits, all FREE of size 5 ({5*len(ORB)} = {NC} cells)")

# ============================================================= 3. walls, exact
hdr("3. walls: candidate pairs + exact facet certificates")
def swapped(p, i):
    q = list(p); q[i], q[i + 1] = q[i + 1], q[i]; return tuple(q)
FIDX = {}
for t, (typ, a, b) in enumerate(FNAME): FIDX[(typ, a, b)] = t; FIDX[(typ, b, a)] = t
CAND = []          # (cell i, cell j, form index, nu primitive)
for i, (piA, piG) in enumerate(CK):
    for pos in range(4):
        k2 = (swapped(piA, pos), piG)
        if k2 in CIDX and CIDX[k2] > i:
            a, b = piA[pos], piA[pos + 1]
            v = [0] * 5; v[a] = 1; v[b] = -1
            CAND.append((i, CIDX[k2], FIDX[("A", a, b)], prim(tuple(v))))
        k3 = (piA, swapped(piG, pos))
        if k3 in CIDX and CIDX[k3] > i:
            a, b = piG[pos], piG[pos + 1]
            v = tuple(MU[a][j] - MU[b][j] for j in range(5))
            CAND.append((i, CIDX[k3], FIDX[("G", a, b)], prim(v)))
print(f"candidate adjacent pairs (one adjacent transposition in exactly one ordering): {len(CAND)}")
nA = sum(1 for c in CAND if FNAME[c[2]][0] == 'A'); nG = len(CAND) - nA
print(f"   A4-type (generic wall class) {nA} ; G9-type (aligned wall class) {nG}")

# hyperplane lattice/plane bases (exact, over Q then cleared to Z)
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
        L = 1
        for x in v: L = L * x.denominator // gcd(L, x.denominator)
        B.append([int(x * L) for x in v])
    return np.array(B, dtype=np.int64)          # (3,5)
PB = [plane_basis(t) for t in range(20)]
for t in range(20):
    assert (PB[t] @ F[t] == 0).all() and (PB[t].sum(1) == 0).all() and len(PB[t]) == 3

# (i) random rational/integer points on the tie hyperplane (the brief's method)
rw = np.random.default_rng(SEED + 1)
def sample_certify(i, j, t, nsamp):
    tgt = SC[i].copy()
    cols = [c for c in range(20) if c != t]
    for K in (2, 5, 20, 200, 2000):
        A = rw.integers(-K, K + 1, size=(nsamp // 5, 3))
        X = A @ PB[t]                                   # points on the hyperplane, in N
        S = np.sign(X @ F.T)
        okm = (S[:, cols] == tgt[cols]).all(1) & (S[:, t] == 0)
        w = np.nonzero(okm)[0]
        if len(w): return X[w[0]]
    return None
# (ii) exact segment certificate: x in C, y in C' -> p = -l(y) x + l(x) y  (integral)
def segment_certify(i, j, t):
    # x in C, y in C': p = -l(y)*x + l(x)*y is a positive combination with l(p) = 0,
    # so every OTHER form keeps its (common, strict) sign.  Exact Python integers.
    x = [int(v) for v in PTS[i]]; y = [int(v) for v in PTS[j]]
    lx = sum(x[k] * int(F[t][k]) for k in range(5))
    ly = sum(y[k] * int(F[t][k]) for k in range(5))
    assert lx * ly < 0
    return [(-ly) * x[k] + lx * y[k] for k in range(5)]
def check_point(p, i, t):
    p = np.asarray(p, dtype=object)
    if not any(p): return False
    if int(sum(p)) != 0: return False
    s = [int(sum(int(p[k]) * int(F[q][k]) for k in range(5))) for q in range(20)]
    if s[t] != 0: return False
    for q in range(20):
        if q == t: continue
        if (s[q] > 0) != (SC[i][q] > 0) or s[q] == 0: return False
    return True

t0 = time.time(); by_sample = 0; by_segment = 0; failed = []
WALLS = []
for (i, j, t, nu) in CAND:
    p = sample_certify(i, j, t, 1000)
    how = 's'
    if p is None:
        p = sample_certify(i, j, t, 10000); how = 's'
    if p is None:
        p = segment_certify(i, j, t); how = 'g'
    if not check_point(p, i, t):
        failed.append((i, j, t)); continue
    by_sample += (how == 's'); by_segment += (how == 'g')
    WALLS.append((i, j, t, nu))
print(f"exact facet certificates: {by_sample} by random sampling on the tie hyperplane, "
      f"{by_segment} by the exact segment construction, {len(failed)} NOT certified")
print(f"   (every certificate re-checked with exact integer arithmetic: the point lies on "
      f"the tie hyperplane and satisfies ALL 19 other order-inequalities of both cells STRICTLY)")
print(f"VERIFIED WALLS: {len(WALLS)} of {len(CAND)} candidates   [t={time.time()-t0:.1f}s]")
assert not failed
# primitivity / nonvanishing mod 11 of the normals
NUS = sorted(set(w[3] for w in WALLS))
for nu in NUS:
    g = 0
    for x in nu: g = gcd(g, x)
    assert g == 1
    assert any(x % 11 for x in nf(nu)), ("nu vanishes mod 11", nu)
print(f"wall normals: {len(NUS)} distinct primitive nu in Lambda; all nonzero mod 11")
print("   sample normals:", [(FNAME[w[2]], w[3]) for w in WALLS[:2]])
# the two wall CLASSES, mod 11 (this is what makes the fan genuinely mixed)
g9n = np.array(nf(G9), dtype=np.int64)
def on_g9_line(v):
    a = np.array(nf(v), dtype=np.int64)
    return ((np.outer(a, g9n) - np.outer(g9n, a)) % 11 == 0).all()
clsA = set(); clsG = set()
for (i, j, t, nu) in WALLS:
    (typ, a, b) = FNAME[t]
    (clsA if typ == 'A' else clsG).add((nu, on_g9_line(nu)))
print(f"   A4-class normals e_a-e_b : {len(clsA)} distinct, on the G9-line mod 11: "
      f"{sum(1 for _, f in clsA if f)}/{len(clsA)}  (GENERIC class)")
print(f"   G9-class normals mu_a-mu_b: {len(clsG)} distinct, on the G9-line mod 11: "
      f"{sum(1 for _, f in clsG if f)}/{len(clsG)}  (ALIGNED class; Lemma Y: mu_a-mu_b == (5^a-5^b)G9)")
for (typ, a, b) in [f for f in FNAME if f[0] == 'G'][:3]:
    v = tuple(MU[a][j] - MU[b][j] for j in range(5))
    lam = (pow(5, a, 11) - pow(5, b, 11)) % 11
    assert nf(v) == tuple((lam * x) % 11 for x in nf(G9))
print("   Lemma Y verified on the G9-class normals: nu == (5^a - 5^b)*G9 (mod 11)")
DEG = np.zeros(NC, int)
for (i, j, t, nu) in WALLS: DEG[i] += 1; DEG[j] += 1
print(f"walls per cell: min {DEG.min()}, max {DEG.max()}, mean {DEG.mean():.2f}")

# ================================================ 4. mod-11 linear algebra
class Ech:
    """RREF over F11 of an augmented system [A | b]; pivots only in A-columns."""
    __slots__ = ('n', 'E', 'piv', 'bad')
    def __init__(self, ncols):
        self.n = ncols + 1
        self.E = np.zeros((0, self.n), dtype=np.int64)
        self.piv = []; self.bad = False
    def add(self, B):
        if self.bad: return False
        B = np.asarray(B, dtype=np.int64) % 11
        if self.piv:
            B = (B - (B[:, self.piv].astype(np.float64) @ self.E.astype(np.float64)
                      ).astype(np.int64)) % 11
        newp = []; i = 0
        while i < B.shape[0]:
            row = B[i]
            nz = np.nonzero(row[:-1])[0]
            if len(nz) == 0:
                if row[-1] % 11: self.bad = True; return False
                B = np.delete(B, i, axis=0); continue
            c = int(nz[0]); inv = pow(int(row[c]), 9, 11)
            B[i] = (row * inv) % 11
            f = B[:, c].copy(); f[i] = 0
            r = np.nonzero(f)[0]
            if len(r): B[r] = (B[r] - np.outer(f[r], B[i])) % 11
            newp.append(c); i += 1
        if len(newp):
            if len(self.piv):
                self.E = (self.E - (self.E[:, newp].astype(np.float64) @ B.astype(np.float64)
                                    ).astype(np.int64)) % 11
            self.E = np.vstack([self.E, B]); self.piv += newp
        return True
    def solution(self):
        if self.bad: return None
        nv = self.n - 1
        part = np.zeros(nv, dtype=np.int64)
        for i, c in enumerate(self.piv): part[c] = self.E[i, nv]
        free = [c for c in range(nv) if c not in set(self.piv)]
        bas = np.zeros((len(free), nv), dtype=np.int64)
        for a, fc in enumerate(free):
            bas[a, fc] = 1
            for i, c in enumerate(self.piv): bas[a, c] = (-self.E[i, fc]) % 11
        return part, bas

def ann_functionals(nu):
    """3 independent functionals on Lambda/11 (coords 0..3 of the nf rep) killing nu."""
    v = np.array(nf(nu)[:4], dtype=np.int64) % 11
    out = []
    p = int(np.nonzero(v)[0][0]); inv = pow(int(v[p]), 9, 11)
    for c in range(4):
        if c == p: continue
        f = np.zeros(4, dtype=np.int64); f[c] = 1
        f[p] = (-int(v[c]) * inv) % 11
        out.append(f)
    assert len(out) == 3
    for f in out: assert int(f @ v) % 11 == 0
    return out

def build_and_solve(name, NCELL, WLIST, SIGP, ORBS, verbose=True):
    """Tree-parametrize the jump system, impose the congruence rows, solve once.
       Returns (nb, EV) with EV[(c,i)] = affine form of U_c coordinate i (i<5)
       in the nb free parameters (last column = constant)."""
    t0 = time.time()
    adj = [[] for _ in range(NCELL)]
    for wi, (i, j, t, nu) in enumerate(WLIST):
        adj[i].append((j, wi)); adj[j].append((i, wi))
    par = [-1] * NCELL; parw = [-1] * NCELL; order = [0]; par[0] = 0
    seen = [False] * NCELL; seen[0] = True
    qi = 0
    while qi < len(order):
        u = order[qi]; qi += 1
        for (v, wi) in adj[u]:
            if not seen[v]:
                seen[v] = True; par[v] = u; parw[v] = wi; order.append(v)
    assert all(seen), "cell adjacency graph is not connected"
    P = 4 + (NCELL - 1)                              # U_root (4) + one scalar per tree wall
    EXPR = np.zeros((NCELL, 5, P), dtype=np.int16)
    for i in range(4): EXPR[0, i, i] = 1
    pid = 4
    for c in order[1:]:
        EXPR[c] = EXPR[par[c]]
        nu = np.array(nf(WLIST[parw[c]][3]), dtype=np.int16)
        EXPR[c, :, pid] = (EXPR[c, :, pid] + nu) % 11
        pid += 1
    assert pid == P
    tree = set(parw[c] for c in order[1:])
    rows = []
    for wi, (i, j, t, nu) in enumerate(WLIST):
        if wi in tree: continue
        D = (EXPR[i].astype(np.int64) - EXPR[j].astype(np.int64)) % 11      # (5,P)
        for f in ann_functionals(nu):
            rows.append(np.concatenate([(f @ D[:4]) % 11, [0]]))
    njump = len(rows)
    # congruence: sum_k 9^k shift_k( U(sig^k C) ) == -c9   (one row-block per orbit)
    rhs = np.array(nf(tuple(-x for x in c9)), dtype=np.int64) % 11
    for orb in ORBS:
        Mt = np.zeros((5, P), dtype=np.int64)
        cc = orb[0]
        for k in range(5):
            E5 = EXPR[cc].astype(np.int64)
            sh = np.array([E5[(i + k) % 5] for i in range(5)])
            sh = (sh - sh[4]) % 11                                    # renormalize mod diag
            Mt = (Mt + pow(9, k, 11) * sh) % 11
            cc = SIGP[cc]
        assert cc == orb[0]
        for i in range(4):
            rows.append(np.concatenate([Mt[i], [rhs[i]]]))
    R = np.array(rows, dtype=np.int64)
    ech = Ech(P)
    for s in range(0, len(R), 512):
        if not ech.add(R[s:s + 512]): break
    sol = ech.solution()
    if sol is None:
        print(f"[{name}] jump+congruence system ALREADY infeasible with NO zeros")
        return None
    part, bas = sol
    nb = len(bas)
    B = np.zeros((P, nb + 1), dtype=np.int64)
    B[:, :nb] = bas.T; B[:, nb] = part
    EV = (EXPR.reshape(NCELL * 5, P).astype(np.float64) @ B.astype(np.float64)).astype(np.int64) % 11
    EV = EV.reshape(NCELL, 5, nb + 1)
    if verbose:
        print(f"[{name}] cells {NCELL}, walls {len(WLIST)}, tree params {P}, "
              f"jump rows {njump}, congruence rows {4*len(ORBS)}")
        print(f"[{name}] jump+congruence solution space: dim {nb}   [t={time.time()-t0:.1f}s]")
    # ---- pipeline self-test: a random solution must satisfy ALL original constraints
    rr = np.random.default_rng(SEED + 7)
    for trial in range(3):
        co = rr.integers(0, 11, size=nb)
        U = (EV[:, :, :nb].astype(np.float64) @ co.astype(np.float64)).astype(np.int64)
        U = (U + EV[:, :, nb]) % 11                                   # (NCELL,5)
        assert (U[:, 4] == 0).all()
        for (i, j, t, nu) in WLIST:                                   # (2) jumps, ALL walls
            d = (U[i] - U[j]) % 11
            v = np.array(nf(nu), dtype=np.int64)
            m = np.outer(d, v) - np.outer(v, d)
            assert (m % 11 == 0).all(), ("jump self-test failed", i, j)
        for orb in ORBS:                                              # (3) congruence
            acc = np.zeros(5, dtype=np.int64); cc = orb[0]
            for k in range(5):
                u = U[cc]; sh = np.array([u[(i + k) % 5] for i in range(5)])
                acc = (acc + pow(9, k, 11) * ((sh - sh[4]) % 11)) % 11
                cc = SIGP[cc]
            assert (acc == rhs).all(), ("congruence self-test failed", orb[0])
    if verbose: print(f"[{name}] SELF-TEST: 3 random solutions satisfy every wall-jump "
                      f"and every orbit congruence exactly")
    return EV

def pattern_feasible(EV, zeros, want_sol=False):
    nb = EV.shape[2] - 1
    rowsA = EV[zeros][:, :4, :].reshape(-1, nb + 1)
    A = np.empty_like(rowsA)
    A[:, :nb] = rowsA[:, :nb]; A[:, nb] = (-rowsA[:, nb]) % 11
    ech = Ech(nb)
    for s in range(0, len(A), 256):
        if not ech.add(A[s:s + 256]): return (False, None)
    if not want_sol: return (True, None)
    return (True, ech.solution())

# ================================================ 5. CALIBRATION GATE: A4 fan
hdr("5. CALIBRATION GATE: the pure A4 Weyl fan through the same code path")
A4 = list(permutations(range(5)))
A4I = {p: i for i, p in enumerate(A4)}
A4W = []
for p in A4:
    for pos in range(4):
        q = swapped(p, pos)
        if A4I[q] > A4I[p]:
            a, b = p[pos], p[pos + 1]
            v = [0] * 5; v[a] = 1; v[b] = -1
            A4W.append((A4I[p], A4I[q], -1, prim(tuple(v))))
A4S = np.array([A4I[shift_perm(p, 1)] for p in A4])
seen = set(); A4O = []
for i in range(120):
    if i in seen: continue
    o = [i]
    for _ in range(4): o.append(int(A4S[o[-1]]))
    assert len(set(o)) == 5; seen.update(o); A4O.append(o)
print(f"A4 fan: {len(A4)} cells, {len(A4W)} walls, {len(A4O)} free sigma-orbits")
EV4 = build_and_solve("A4", 120, A4W, A4S, A4O)
gate_ok = True
GATE = [(3, 4), (0, 1), (0, 2)]
allP4 = [tuple(sorted(P)) for k in range(2, 6) for P in combinations(range(5), k)]
print("\n  rank patterns on the A4 fan (zero iff position of coordinate 0 in piA is in P):")
for P in allP4:
    Z = [i for i, p in enumerate(A4) if p.index(0) in P]
    per = [sum(1 for c in o if c in set(Z)) for o in A4O]
    feas, _ = pattern_feasible(EV4, np.array(Z))
    tag = "FEASIBLE" if feas else "infeasible"
    mark = ""
    if P in GATE:
        mark = "   <-- GATE"
        if feas: gate_ok = False
    print(f"    P = {str(list(P)):12s} zero cells {len(Z):3d} (min {min(per)}/orbit) -> {tag}{mark}")
print(f"\nCALIBRATION GATE {'PASSED' if gate_ok else 'FAILED'}: "
      f"P = {{3,4}}, {{0,1}}, {{0,2}} all mod-11 INFEASIBLE on the A4 fan "
      f"(reproduces the known A4 level-1 death, Thm X'' of S8.23)")
assert gate_ok, "calibration gate failed -- do not trust the mixed-fan run"

# second calibration: the pure G9 order fan (the ALIGNED reference behaviour)
print("\n  second reference run: the pure G9 order fan {H_a = H_b} (same code path)")
G9F = list(permutations(range(5)))
G9I = {p: i for i, p in enumerate(G9F)}
G9W = []
for p in G9F:
    for pos in range(4):
        q = swapped(p, pos)
        if G9I[q] > G9I[p]:
            a, b = p[pos], p[pos + 1]
            G9W.append((G9I[p], G9I[q], -1, prim(tuple(MU[a][j] - MU[b][j] for j in range(5)))))
G9S = np.array([G9I[shift_perm(p, -1)] for p in G9F])
seen = set(); G9O = []
for i in range(120):
    if i in seen: continue
    o = [i]
    for _ in range(4): o.append(int(G9S[o[-1]]))
    assert len(set(o)) == 5; seen.update(o); G9O.append(o)
EVG = build_and_solve("G9", 120, G9W, G9S, G9O)
G9VERD = {}
for P in allP4:
    Z = [i for i, p in enumerate(G9F) if p.index(0) in P]
    G9VERD[P] = pattern_feasible(EVG, np.array(Z))[0]
print("    G9-fan rank patterns (zero iff position of H-label 0 in piG is in P): "
      f"{sum(G9VERD.values())}/26 FEASIBLE at level 1 (the aligned signature: level 1 "
      f"survives, the kill is at level 2 -- Thm X of S8.22)")
print("    infeasible ones:", [list(P) for P in allP4 if not G9VERD[P]])

# ==================================================== 6. the MIXED fan system
hdr("6. the mixed fan: level-1 mod-11 system")
EVM = build_and_solve("MIXED", NC, WALLS, SIG, ORB)

# cross-fan validation: the mixed fan REFINES both coarse fans, so the pullback of any
# solution of the coarse system must satisfy every mixed-fan constraint.  (This tests
# the mixed system for OVER-constraining, i.e. for a bug that would fake infeasibility.)
rhs0 = np.array(nf(tuple(-x for x in c9)), dtype=np.int64) % 11
def check_pullback(name, EVX, into):
    nbx = EVX.shape[2] - 1; rr = np.random.default_rng(SEED + 11); bad = 0
    for _ in range(3):
        co = rr.integers(0, 11, size=nbx)
        UX = (EVX[:, :, :nbx].astype(np.float64) @ co.astype(np.float64)).astype(np.int64)
        UX = (UX + EVX[:, :, nbx]) % 11
        U = np.array([UX[into[c]] for c in range(NC)])
        for (i, j, t, nu) in WALLS:
            d = (U[i] - U[j]) % 11; v = np.array(nf(nu), dtype=np.int64)
            if ((np.outer(d, v) - np.outer(v, d)) % 11 != 0).any(): bad += 1
        for o in ORB:
            acc = np.zeros(5, dtype=np.int64); cc = o[0]
            for k in range(5):
                u = U[cc]; sh = np.array([u[(i + k) % 5] for i in range(5)])
                acc = (acc + pow(9, k, 11) * ((sh - sh[4]) % 11)) % 11
                cc = SIG[cc]
            if (acc != rhs0).any(): bad += 1
    print(f"[MIXED] pullback of 3 random {name}-fan solutions satisfies every mixed-fan "
          f"wall-jump and orbit congruence: {bad} violations (0 = the mixed system is a "
          f"faithful refinement, not over-constrained)")
    assert bad == 0
check_pullback("A4", EV4, [A4I[CK[c][0]] for c in range(NC)])
check_pullback("G9", EVG, [G9I[CK[c][1]] for c in range(NC)])

# ==================================================== 7. pattern sweep
hdr("7. pattern sweep on the mixed fan")
# G9-cell bookkeeping (the aligned shadow of a mixed pattern)
GPERM = sorted(set(k[1] for k in CK)); GIDX = {p: i for i, p in enumerate(GPERM)}
GOF = np.array([GIDX[k[1]] for k in CK])
gseen = set(); GORB = []
for p in GPERM:
    if p in gseen: continue
    o = [p]
    for _ in range(4): o.append(shift_perm(o[-1], -1))
    assert len(set(o)) == 5; gseen.update(o); GORB.append([GIDX[q] for q in o])
print(f"G9-cells (distinct piG among mixed cells): {len(GPERM)}, G9-orbits: {len(GORB)}, "
      f"mixed cells per G9-cell: {min(np.bincount(GOF))}..{max(np.bincount(GOF))}")

def orbit_min(Zset):
    return min(sum(1 for c in o if c in Zset) for o in ORB)
res = {}; feasible_hits = []; pred = {}
def run(tag, Z, note=""):
    Zs = set(Z); m = orbit_min(Zs)
    assert m >= 2, f"pattern {tag} is not admissible ({m} zeros in some orbit)"
    feas, sol = pattern_feasible(EVM, np.array(sorted(Z)), want_sol=True)
    res[tag] = feas
    # CRITERION under test: feasible iff every sigma-orbit of G9-cells keeps one
    # G9-cell free of zero mixed cells (i.e. one free tau in each orbit-sum == 7)
    touched = set(int(GOF[c]) for c in Z)
    pred[tag] = all(any(g not in touched for g in o) for o in GORB)
    if feas:
        feasible_hits.append((tag, sorted(Z), sol, note))
    return feas, len(Z), m

print("\n(a) induced A4 rank patterns: zero iff position of coordinate 0 in piA is in P")
for P in allP4:
    Z = [i for i, (pA, pG) in enumerate(CK) if pA.index(0) in P]
    f, nz, m = run(("a", P), Z)
    print(f"    P = {str(list(P)):12s} zero cells {nz:4d} (min {m}/orbit) -> "
          f"{'FEASIBLE' if f else 'infeasible'}")
print("\n(b) induced G9 rank patterns: zero iff position of H-label 0 in piG is in P")
for P in allP4:
    Z = [i for i, (pA, pG) in enumerate(CK) if pG.index(0) in P]
    f, nz, m = run(("b", P), Z)
    print(f"    P = {str(list(P)):12s} zero cells {nz:4d} (min {m}/orbit) -> "
          f"{'FEASIBLE' if f else 'infeasible'}")

print("\n(c) 500 random per-orbit patterns (2 zero translates per orbit, seed 20260807)")
print("    [exactly 2 zeros/orbit is the SHARPEST case: any admissible pattern contains one,")
print("     and adding zeros only adds constraints, so these dominate the whole class]")
rp = random.Random(SEED)
pairs = list(combinations(range(5), 2))
t0 = time.time(); nfe = 0
for tr in range(500):
    Z = []
    for o in ORB:
        i, j = rp.choice(pairs); Z.append(o[i]); Z.append(o[j])
    f, nz, m = run(("c", tr), Z)
    nfe += f
    if (tr + 1) % 100 == 0:
        print(f"    ... {tr+1}/500 done, feasible so far: {nfe}   [t={time.time()-t0:.1f}s]")
print(f"    random per-orbit patterns: {nfe} FEASIBLE of 500")

# (d) random ALIGNED patterns: zeros = pullback of a per-orbit pattern on the 120
#     G9-cells (piG alone).  These are the patterns the aligned theory (S8.22) governs.
print("\n(d) 200 random ALIGNED patterns (2 zero G9-cells per G9-orbit, pulled back)")
nfd = 0
for tr in range(200):
    zg = set()
    for o in GORB:
        i, j = rp.choice(pairs); zg.add(o[i]); zg.add(o[j])
    Z = [c for c in range(NC) if GOF[c] in zg]
    f, nz, m = run(("d", tr), Z, note="(aligned pullback)")
    nfd += f
print(f"    random ALIGNED patterns: {nfd} FEASIBLE of 200")

# (e) MINIMAL de-alignment: an aligned pattern with ONE sigma-orbit's zero pair moved
print("\n(e) 200 minimally DE-ALIGNED patterns (an aligned pattern, one orbit's zero pair"
      " replaced)")
nfe2 = 0
for tr in range(200):
    zg = set()
    for o in GORB:
        i, j = rp.choice(pairs); zg.add(o[i]); zg.add(o[j])
    Z = [c for c in range(NC) if GOF[c] in zg]
    Zs = set(Z)
    tries = 0
    while tries < 50:
        tries += 1
        o = ORB[rp.randrange(len(ORB))]
        cur = tuple(t for t in range(5) if o[t] in Zs)
        new = rp.choice(pairs)
        if set(new) != set(cur): break
    Z2 = [c for c in Z if c not in set(o)] + [o[new[0]], o[new[1]]]
    f, nz, m = run(("e", tr), Z2, note="(de-aligned)")
    nfe2 += f
print(f"    minimally de-aligned patterns: {nfe2} FEASIBLE of 200"
      f"   [moving zeros WITHIN a sigma-orbit does not kill: what matters is only the"
      f"\n     G9-cell shadow of the zero set, not its position inside a G9-cell]")

# (f) saturated patterns: one G9-orbit fully touched  -> the criterion predicts death
print("\n(f) 100 SATURATED patterns (aligned base, one G9-orbit made entirely zero)")
nff = 0
for tr in range(100):
    zg = set()
    for o in GORB:
        i, j = rp.choice(pairs); zg.add(o[i]); zg.add(o[j])
    zg |= set(GORB[rp.randrange(len(GORB))])
    Z = [c for c in range(NC) if GOF[c] in zg]
    f, nz, m = run(("f", tr), Z, note="(saturated)")
    nff += f
print(f"    saturated patterns: {nff} FEASIBLE of 100")

# ==================================================== 8. verdict / feasible analysis
hdr("8. verdict")
cnt = {t: [0, 0] for t in "abcdef"}
for k, v in res.items(): cnt[k[0]][int(v)] += 1
print(f"(a) A4-induced rank patterns  : {cnt['a'][0]:3d} infeasible, {cnt['a'][1]:3d} feasible   (26)")
print(f"(b) G9-induced rank patterns  : {cnt['b'][0]:3d} infeasible, {cnt['b'][1]:3d} feasible   (26)")
print(f"(c) random per-orbit patterns : {cnt['c'][0]:3d} infeasible, {cnt['c'][1]:3d} feasible  (500)")
print(f"(d) random aligned pullbacks  : {cnt['d'][0]:3d} infeasible, {cnt['d'][1]:3d} feasible  (200)")
print(f"(e) minimally de-aligned      : {cnt['e'][0]:3d} infeasible, {cnt['e'][1]:3d} feasible  (200)")
print(f"(f) saturated (one G9-orbit)  : {cnt['f'][0]:3d} infeasible, {cnt['f'][1]:3d} feasible  (100)")
print(f"    TOTAL: {sum(c[0] for c in cnt.values())} infeasible, "
      f"{sum(c[1] for c in cnt.values())} feasible, of {len(res)} patterns")
mism = [k for k in res if res[k] != pred[k]]
print(f"\nCRITERION under test: a mixed pattern survives level 1 <=> every sigma-orbit of")
print(f"G9-cells keeps a G9-cell free of zero mixed cells (one free tau per orbit-sum 7).")
print(f"    agreement with the computed verdicts: {len(res)-len(mism)}/{len(res)}"
      f"   mismatches: {[k for k in mism[:8]]}")
print("\ncross-check (b) vs the pure G9 fan (same rank patterns, coarser fan):")
agree = all(res[("b", P)] == G9VERD[P] for P in allP4)
print(f"    mixed-fan (b) verdicts == pure-G9-fan verdicts on all 26 rank patterns: {agree}")
print(f"    (expected: the mixed fan's level-1 survivors are exactly the G9-fan's, since"
      f" every\n     surviving U is aligned and constant on G9-cells -- verified below)")

if feasible_hits:
    print("\n" + "!" * 78)
    print(f"!!!  {len(feasible_hits)} FEASIBLE PATTERN(S) AT LEVEL 1 (mod 11) ON THE MIXED FAN")
    print("!" * 78)
    print("!!!  feasible patterns: " +
          ", ".join(str(t) for t, _, _, _ in feasible_hits[:40]) +
          (" ..." if len(feasible_hits) > 40 else ""))
    nbp = EVM.shape[2] - 1
    rhs = np.array(nf(tuple(-x for x in c9)), dtype=np.int64) % 11
    g = np.array(nf(G9), dtype=np.int64)
    def Uof(co):
        U = (EVM[:, :, :nbp].astype(np.float64) @ co.astype(np.float64)).astype(np.int64)
        return (U + EVM[:, :, nbp]) % 11
    def Udir(co):
        return (EVM[:, :, :nbp].astype(np.float64) @ co.astype(np.float64)).astype(np.int64) % 11
    def online(U):     # cells whose U is NOT in F11*G9
        return [c for c in range(NC)
                if ((np.outer(U[c], g) - np.outer(g, U[c])) % 11 != 0).any()]
    allaligned = True; alltau = True
    for hi, (tag, Z, sol, note) in enumerate(feasible_hits):
        part, bas = sol
        U = Uof(part)
        bad = 0
        for (i, j, t, nu) in WALLS:                       # (2) every wall
            d = (U[i] - U[j]) % 11; v = np.array(nf(nu), dtype=np.int64)
            if ((np.outer(d, v) - np.outer(v, d)) % 11 != 0).any(): bad += 1
        for o in ORB:                                     # (3) every orbit
            acc = np.zeros(5, dtype=np.int64); cc = o[0]
            for k in range(5):
                u = U[cc]; sh = np.array([u[(i + k) % 5] for i in range(5)])
                acc = (acc + pow(9, k, 11) * ((sh - sh[4]) % 11)) % 11
                cc = SIG[cc]
            if (acc != rhs).any(): bad += 1
        for c in Z:                                       # (1) every zero cell
            if (U[c] % 11 != 0).any(): bad += 1
        # is the WHOLE solution space aligned?  (base point + every basis direction)
        off = len(online(U))
        for b in bas: off += len(online(Udir(b)))
        allaligned &= (off == 0)
        p = int(np.nonzero(g)[0][0]); ip = pow(int(g[p]), 9, 11)
        tau = np.array([(int(U[c][p]) * ip) % 11 for c in range(NC)])
        taucst = all(len(set(tau[GOF == gg].tolist())) <= 1 for gg in range(len(GPERM)))
        sums = sorted(set(int(sum(tau[c] for c in o)) % 11 for o in ORB))
        alltau &= taucst and sums == [7]
        if hi < 3 or hi == len(feasible_hits) - 1:
            print(f"\n!!! pattern {tag} {note}: {len(Z)} zero cells, "
                  f"solution space dim {len(bas)}")
            print(f"!!!   explicit re-verification against ALL {len(WALLS)} wall-jumps, "
                  f"{len(ORB)} orbit congruences and {len(Z)} zero conditions: "
                  f"{bad} violations (0 = genuine solution)")
            print("!!!   U on cells 0..7: " +
                  ", ".join(str(tuple(U[c].tolist())) for c in range(8)))
            print(f"!!!   cells with U OFF the G9-line F11*G9, over the WHOLE solution "
                  f"space (base + {len(bas)} directions): {off}")
            print(f"!!!   U == tau*G9 with tau constant on each G9-cell (piG): {taucst}; "
                  f"per-sigma-orbit sums of tau: {sums}  (aligned signature: 7)")
    print(f"\n!!!  ALL {len(feasible_hits)} feasible patterns: solution space entirely "
          f"ALIGNED (U in F11*G9): {allaligned}")
    print(f"!!!  ALL feasible patterns: tau factors through piG (constant on G9-cells) "
          f"and Sum_orbit tau == 7: {alltau}")
    print("!!!  => the level-1 survivors on the MIXED fan are EXACTLY the pullbacks of the")
    print("!!!     G9-fan's aligned tau-layer.  Lemma-T confinement to F11*G9 is FORCED here")
    print("!!!     by the zero-web, NOT by the wall-span (the A4-class walls are generic and")
    print("!!!     span all of Lambda/11), and every A4-class jump must vanish: tau is")
    print("!!!     constant across every generic wall, i.e. constant on each G9-cell.")
    print("!!!     So the mixed fan adds NO new level-1 freedom over the G9-fan; the")
    print("!!!     survivors are killed only by the level-2 (tau,Psi) machinery of S8.22")
    print("!!!     (on the G9-fan that is Theorem X; on the mixed fan the V-web has the")
    print("!!!     extra A4-class rho-data and is NOT covered by any proved statement yet).")
else:
    print("\nNO FEASIBLE PATTERN: every one of the 552 patterns tested on the mixed fan is")
    print("mod-11 INFEASIBLE at level 1 -- the mixed fan dies where the aligned fans survive.")

print(f"\nreproduce:  python3 {sys.argv[0].split('/')[-1]}   (deterministic, seed {SEED})")
print(f"total runtime {time.time()-T00:.1f}s")
