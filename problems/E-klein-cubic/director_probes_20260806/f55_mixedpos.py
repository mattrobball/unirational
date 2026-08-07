#!/usr/bin/env python3
# f55_mixedpos.py -- T5, THE POSITIVITY TEST on the MIXED fan (Correction IX-j).
#
# WHY.  Sections 8.20-8.22 of theory/FIX_IX_v14.md relaxed the honest necessary
# system by DROPPING positivity.  The min-normalized field of Theorem Q is
#      d(w) = F(w) - min_i F(sigma^i w) >= 0    EVERYWHERE,
# and f55_mixedlevel3.py proved that the relaxation {(1) zeros, (2) integral wall
# jumps, (3) orbit congruence mod 11} is INTEGRALLY SATISFIABLE on the mixed fan
# for the G9-induced rank patterns P = {0,1} and P = {3,4}.  The witness it
# produced takes 81 negative cell values, i.e. it is not a min-normalized field.
# THE QUESTION HERE: does the *positivity-restored* system have a solution?
#
# THE REDUCTION USED.  d is linear on every cell of a COMPLETE fan and every cell
# is the conic hull of its rays (Minkowski-Weyl; the arrangement is essential so
# every chamber is pointed), hence
#      d >= 0 everywhere   <=>   d(r) >= 0 at every ray r of the fan.
# So the exact program is:  x in Z^P with  H x = 0 (over Z),  C x == rhs (mod 11),
# and  <U_{C(r)}(x), r>  >= 0 for every ray r.
#
# WHAT IS ACTUALLY DECIDED (and a correction to the brief).  Over Q the affine
# space  x1 + M (x) Q  equals  ker_Q(H)  (M has full rank 19 inside L = ker_Z H),
# so it CONTAINS 0 and the literal "rational positivity LP" is trivially
# feasible at d = 0 -- and vacuous, because d = 0 fails the congruence.  The
# informative rational object is the CONE
#      K+ := { x in ker_Q(H) : d_x(r) >= 0 for every ray r },
# a pointed cone (the map x -> (U_C)_C is injective, so K+ has no lineality).
# The decisive dichotomy, proved below and used as the verdict:
#   * K+ = {0}                -> NO nonzero rational, a fortiori no integral,
#                                nonnegative witness: the pattern DIES BY
#                                POSITIVITY.  Certificate: y > 0 with y^T A = 0
#                                and rank_Q(A) = 19 (Stiemke), verified exactly.
#   * K+ has a relative interior point u (strict at every non-forced ray)
#                             -> an INTEGRAL nonnegative witness EXISTS: for any
#                                integral solution x1 of H x = 0, C x == rhs, and
#                                any N with 11*N*d_u > |d_{x1}| off the forced
#                                rays, x1 + 11*N*u is again a solution of the
#                                congruence (11*M-shift) and is >= 0 at every ray.
#                                It is then constructed and re-verified.
#   * intermediate            -> reported explicitly, with the accumulated
#                                implicit-equality set and its rank.
#
# Rays forced to 0: every ray in the closure of a zero cell has d(r) = 0 for ALL
# x in ker_Q(H) (U is 0 there), so those rows of A vanish identically; they are
# detected, not assumed.
#
# SOUNDNESS.  The cell list, the wall list and the ray list of the mixed fan are
# each proved COMPLETE against exact Zaslavsky/intersection-lattice counts, and
# every cell, wall and ray carries an exact integer certificate.  Every LP verdict
# is produced by a float LP and then CERTIFIED with exact Fraction arithmetic;
# no verdict rests on a floating-point computation.
#
# RESULT (2026-08-07).  POSITIVITY DOES NOT KILL.  On the mixed fan the rational
# positivity cone K+ is FULL-DIMENSIONAL (dim K+ = dim ker_Q(H) = 19) for both
# G9-induced rank patterns P = {0,1} and P = {3,4}, and for all 12 congruence-
# feasible (e)-family variants tested.  An explicit NONNEGATIVE INTEGRAL witness
# y = x1 + 11*u is produced for each of the 14 patterns and verified:
#   H y = 0 over Z; every one of the 2570 wall jumps of the form m*nu with m in Z;
#   all 436 zero cells exactly 0; d(r) >= 0 at ALL 460 rays; d >= 0 at the 1090 cell
#   witness points; and, by direct ground truth at ~16000 random lattice points of N
#   with all five sigma-translates, d >= 0, min_k d(sigma^k n) = 0 attained AT LEAST
#   TWICE, and sum_k 9^k d(sigma^k n) + <n,c9> == 0 (mod 11) -- 0 failures each.
# So the honest necessary system (0) d >= 0 + (1) twice-min zeros + (2) integral
# slopes + (3) the congruence (ii) is SATISFIABLE on the mixed fan: the corrected
# Lemma S of Correction IX-j is FALSE as stated, and T5 cannot be closed at the
# value-form level at all.  Any kill must use structure beyond the value form --
# i.e. F = 2h + h.sigma^{-1} - e2* for an actual support function h = h_Q of a
# lattice polytope (Theorem Q proper).
#
# Reproduce:  python3 f55_mixedpos.py            (deterministic; seed 20260807)
#   env knobs: F55_EFAM=0  skip the (e)-family sweep (30 one-orbit variants)
import numpy as np, random, time, sys, os
from fractions import Fraction as Fr
from itertools import combinations, permutations
from math import gcd
from scipy.optimize import linprog

T00 = time.time()
SEED = 20260807
BLK = 512
np.seterr(all='raise')
def hdr(s): print("\n" + "=" * 78 + "\n== " + s + "\n" + "=" * 78)

# ============================================================ 0. conventions
G9 = (1, 5, 3, 4, 9)
c9 = (4, 9, 1, 5, 3)
MU = [tuple(G9[(j + k) % 5] for j in range(5)) for k in range(5)]
pairs = list(combinations(range(5), 2))
INV11 = [0] + [pow(a, 9, 11) for a in range(1, 11)]

def sigN(n): return tuple(n[(j - 1) % 5] for j in range(5))
def shift_perm(p, k): return tuple((x + k) % 5 for x in p)
def swp(p, i):
    q = list(p); q[i], q[i + 1] = q[i + 1], q[i]; return tuple(q)
def prim(v):
    w = [v[j] - v[4] for j in range(5)]
    g = 0
    for x in w: g = gcd(g, x)
    assert g > 0
    return tuple(x // g for x in w)
def nf4(v): return np.array([v[j] - v[4] for j in range(4)], dtype=np.int64)
def imatmul(X, Y):
    if X.size == 0 or Y.size == 0:
        return np.zeros((X.shape[0], Y.shape[1]), dtype=np.int64)
    mx = int(np.abs(X).max()); my = int(np.abs(Y).max()); n = X.shape[1]
    if mx * my * n < 2 ** 52:
        return (X.astype(np.float64) @ Y.astype(np.float64)).astype(np.int64)
    return X.astype(object) @ Y.astype(object)

hdr("0. conventions")
rng0 = random.Random(SEED)
ok = True
for _ in range(2000):
    n = [rng0.randint(-30, 30) for _ in range(5)]; n[4] = -sum(n[:4]); n = tuple(n)
    for k in range(5):
        m = n
        for _ in range(k): m = sigN(m)
        if sum(m[j] * G9[j] for j in range(5)) != sum(n[j] * MU[k][j] for j in range(5)):
            ok = False
print("H_k(n) = <sig^k n, G9> = <n, mu_k>, mu_k[j] = G9[(j+k)%5] :", ok); assert ok

# ============================================================ 1. the mixed fan
hdr("1. the mixed fan (cells, sigma, walls) -- rebuilt and re-certified")
FORMS = []; FNAME = []
for a, b_ in combinations(range(5), 2):
    v = [0] * 5; v[a] = 1; v[b_] = -1
    FORMS.append(tuple(v)); FNAME.append(("A", a, b_))
for a, b_ in combinations(range(5), 2):
    FORMS.append(tuple(MU[a][j] - MU[b_][j] for j in range(5))); FNAME.append(("G", a, b_))
F = np.array(FORMS, dtype=np.int64)
FN = np.array([[c[j] - c[4] for j in range(4)] for c in FORMS], dtype=np.float64)
LIN = [tuple(Fr(c[j] - c[4]) for j in range(4)) for c in FORMS]        # forms on Z^4 = N
LINI = np.array([[c[j] - c[4] for j in range(4)] for c in FORMS], dtype=np.int64)

def rrefQ(rows, d):
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
    return [tuple(A[i]) for i in range(r0)], piv
def inspan(rr, piv, v):
    w = list(v)
    for i, c in enumerate(piv):
        if w[c] != 0:
            f = w[c]; w = [x - f * y for x, y in zip(w, rr[i])]
    return all(x == 0 for x in w)

# --- intersection lattice of the 20 hyperplanes in N (x) Q = Q^4 : chambers AND lines
t0 = time.time()
assert len(rrefQ(LIN, 4)[1]) == 4, "arrangement is not essential"
allel = {frozenset(): 0}; level = [frozenset()]
for rank in range(1, 5):
    nxt = {}
    for Ss in level:
        for i in range(20):
            if i in Ss: continue
            rr, piv = rrefQ([LIN[j] for j in set(Ss) | {i}], 4)
            if len(rr) != rank: continue
            cl = frozenset(j for j in range(20) if inspan(rr, piv, LIN[j]))
            if cl not in allel: nxt[cl] = rank
    allel.update(nxt); level = list(nxt.keys())
mob = {}
for cl, rk in sorted(allel.items(), key=lambda kv: kv[1]):
    mob[cl] = 1 if rk == 0 else -sum(mob[c2] for c2, r2 in allel.items()
                                     if r2 < rk and c2 < cl)
ZAS = sum(abs(v) for v in mob.values())
FLAT3 = [cl for cl, rk in allel.items() if rk == 3]
print(f"intersection lattice: " +
      str({r: sum(1 for c, q in allel.items() if q == r) for r in range(5)}) +
      f";  Zaslavsky #chambers = {ZAS};  rank-3 flats (= LINES) = {len(FLAT3)}"
      f"   [{time.time()-t0:.1f}s]")

# --- cells: LP over all 120*120 order pairs, each survivor certified by an exact
#     integer interior point (the f55_mixedlevel3.py construction, verbatim)
def cell_signs(key):
    piA, piG = key; s = np.zeros(20, dtype=np.int64)
    posA = {v: i for i, v in enumerate(piA)}; posG = {v: i for i, v in enumerate(piG)}
    for t, (typ, a, b_) in enumerate(FNAME):
        s[t] = 1 if (posA[a] < posA[b_] if typ == 'A' else posG[a] < posG[b_]) else -1
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
t0 = time.time(); cells = {}
for piA in permutations(range(5)):
    for piG in permutations(range(5)):
        key = (piA, piG); sv = cell_signs(key); p = find_point(sv)
        if p is None: continue
        assert (np.sign(p @ F.T) == sv).all()
        cells[key] = tuple(int(x) for x in p)
NC = len(cells)
print(f"cells: {NC}  == exact Zaslavsky chamber count {ZAS}: {NC == ZAS}"
      f"  => CELL LIST PROVABLY COMPLETE   [{time.time()-t0:.1f}s]")
assert NC == ZAS == 1090
CK = sorted(cells.keys()); CIDX = {k: i for i, k in enumerate(CK)}
PTS = np.array([cells[k] for k in CK], dtype=np.int64)
SC = np.sign(PTS @ F.T)
assert (SC != 0).all() and len(set(map(tuple, SC.tolist()))) == NC

score = 0
for i in range(NC):
    n = tuple(PTS[i].tolist()); (piA, piG) = CK[i]
    m = sigN(n); Hv = [sum(m[j] * MU[k][j] for j in range(5)) for k in range(5)]
    qA = tuple(sorted(range(5), key=lambda j: -m[j]))
    qG = tuple(sorted(range(5), key=lambda j: -Hv[j]))
    score += ((qA, qG) == (shift_perm(piA, 1), shift_perm(piG, -1)))
assert score == NC
SIG = np.array([CIDX[(shift_perm(k[0], 1), shift_perm(k[1], -1))] for k in CK])
ORB = []; _sn = set()
for i in range(NC):
    if i in _sn: continue
    o = [i]
    for _ in range(4): o.append(int(SIG[o[-1]]))
    assert len(set(o)) == 5 and int(SIG[o[-1]]) == i
    _sn.update(o); ORB.append(o)
assert len(ORB) == 218
print(f"sigma:(piA,piG)->(piA+1,piG-1) verified on all {NC} witness points; "
      f"{len(ORB)} free sigma-orbits")

FIDX = {}
for t, (typ, a, b_) in enumerate(FNAME): FIDX[(typ, a, b_)] = t; FIDX[(typ, b_, a)] = t
WALLS = []; wtyp = []
for i, (piA, piG) in enumerate(CK):
    for pos in range(4):
        for (k2, typ, a, b_) in (((swp(piA, pos), piG), 'A', piA[pos], piA[pos + 1]),
                                 ((piA, swp(piG, pos)), 'G', piG[pos], piG[pos + 1])):
            if k2 not in CIDX or CIDX[k2] <= i: continue
            j = CIDX[k2]
            vv = ([0] * 5 if typ == 'A' else list(MU[a][q] - MU[b_][q] for q in range(5)))
            if typ == 'A': vv[a] = 1; vv[b_] = -1
            vv = tuple(vv); t = FIDX[(typ, a, b_)]
            x = [int(z) for z in PTS[i]]; y = [int(z) for z in PTS[j]]
            lx = sum(x[q] * int(F[t][q]) for q in range(5))
            ly = sum(y[q] * int(F[t][q]) for q in range(5))
            assert lx * ly < 0
            p = [(-ly) * x[q] + lx * y[q] for q in range(5)]
            sgn = [sum(p[q] * int(F[r][q]) for q in range(5)) for r in range(20)]
            good = any(p) and sum(p) == 0 and sgn[t] == 0
            for r in range(20):
                if r == t: continue
                if sgn[r] == 0 or (sgn[r] > 0) != (int(SC[i][r]) > 0) \
                        or (sgn[r] > 0) != (int(SC[j][r]) > 0): good = False; break
            assert good, ("facet certificate failed", i, j, t)
            WALLS.append((i, j, prim(vv))); wtyp.append(typ)
nAw = sum(1 for t in wtyp if t == 'A')
print(f"walls: {len(WALLS)} (A4-class {nAw}, G9-class {len(WALLS)-nAw}), every one "
      f"certified by an exact integer relative-interior facet point")
assert (len(WALLS), nAw) == (2570, 1400)     # == exact Zaslavsky wall count, f55_mixedlevel3.py
GPERM = sorted(set(k[1] for k in CK)); GIDX = {p: i for i, p in enumerate(GPERM)}
GOF = np.array([GIDX[k[1]] for k in CK])
GCELLS = [np.nonzero(GOF == g)[0].tolist() for g in range(len(GPERM))]
GORB = []; _sn = set()
for p in GPERM:
    if p in _sn: continue
    o = [p]
    for _ in range(4): o.append(shift_perm(o[-1], -1))
    assert len(set(o)) == 5; _sn.update(o); GORB.append([GIDX[q] for q in o])

# ============================================================ 2. THE RAYS
hdr("2. RAY ENUMERATION of the mixed fan (task 1)")
# A ray of an arrangement fan is a 1-dimensional face, i.e. a 1-dim intersection of
# hyperplanes; every such line L has active set of rank exactly 3, so both halves of
# L \ {0} are relatively open faces.  Candidates: kernels of rank-3 triples.
t0 = time.time(); rays = {}
ntrip = 0
for tri in combinations(range(20), 3):
    rr, piv = rrefQ([LIN[j] for j in tri], 4)
    if len(rr) != 3: continue
    ntrip += 1
    free = [c for c in range(4) if c not in piv][0]
    v = [Fr(0)] * 4; v[free] = Fr(1)
    for i, c in enumerate(piv): v[c] = -rr[i][free]
    L = 1
    for x in v: L = L * x.denominator // gcd(L, x.denominator)
    w = [int(x * L) for x in v]
    g = 0
    for x in w: g = gcd(g, abs(x))
    w = tuple(x // g for x in w)
    for s in (1, -1):
        r = tuple(s * x for x in w)
        if r not in rays:
            act = [q for q in range(20) if int(LINI[q] @ np.array(r)) == 0]
            assert len(rrefQ([LIN[q] for q in act], 4)[1]) == 3
            rays[r] = act
RAYS = sorted(rays.keys())
NR = len(RAYS)
R4 = np.array(RAYS, dtype=np.int64)
R5 = np.concatenate([R4, -R4.sum(1)[:, None]], axis=1)
print(f"rank-3 triples of normals with a 1-dim kernel: {ntrip} of {len(list(combinations(range(20),3)))}")
print(f"RAYS of the mixed fan: {NR}  (each certified: its active set has rank exactly 3,")
print(f"   so R_{{>0}}*r is a relatively open 1-dim FACE of the arrangement)")
print(f"INDEPENDENT COMPLETENESS CHECK: #rays must equal 2 * #(rank-3 flats) = "
      f"2 * {len(FLAT3)} = {2*len(FLAT3)}:  {NR == 2*len(FLAT3)}   [{time.time()-t0:.1f}s]")
assert NR == 2 * len(FLAT3)
print(f"   max|ray coordinate| = {int(np.abs(R4).max())}; the ray set is stable under "
      f"r -> -r: {set(tuple(-np.array(r)) for r in RAYS) == set(RAYS)}")
# sigma acts on rays (sanity)
SIGR = {}
for idx, r in enumerate(RAYS):
    s5 = sigN(tuple(R5[idx].tolist())); s4 = tuple(int(s5[j]) for j in range(4))
    g = 0
    for x in s4: g = gcd(g, abs(x))
    assert g == 1
    SIGR[idx] = RAYS.index(s4)
print(f"   sigma permutes the ray set: {len(set(SIGR.values())) == NR}")

# --- which rays lie in the closure of which cell
SGN = np.sign(R4 @ LINI.T)                      # (NR,20) in {-1,0,1}
INCID = [[] for _ in range(NC)]                 # cell -> rays in its closure
RCELL = [[] for _ in range(NR)]
for c in range(NC):
    m = ((SGN == 0) | (SGN == SC[c][None, :])).all(1)
    idx = np.nonzero(m)[0]
    INCID[c] = idx.tolist()
    for i in idx: RCELL[i].append(c)
cnts = np.array([len(INCID[c]) for c in range(NC)])
histo = {}
for v in cnts.tolist(): histo[v] = histo.get(v, 0) + 1
print(f"per-cell ray counts: min {cnts.min()}, max {cnts.max()}, mean {cnts.mean():.3f}; "
      f"histogram {dict(sorted(histo.items()))}")
rc = np.array([len(RCELL[i]) for i in range(NR)])
print(f"per-ray cell counts: min {rc.min()}, max {rc.max()}, mean {rc.mean():.2f}; "
      f"every ray is in >= 1 cell closure: {bool((rc > 0).all())}")

# --- completeness check (task 1): every cell is POSITIVELY SPANNED by its rays.
#     Exact Fraction LP feasibility  p = sum lam_k r_k , lam >= 0.
def cone_contains(gens, p):
    """exact: is p in cone(gens)?  phase-1 simplex, Fractions, Bland's rule."""
    n = len(gens); m = 4
    A = [[Fr(gens[k][i]) for k in range(n)] for i in range(m)]
    b = [Fr(p[i]) for i in range(m)]
    for i in range(m):
        if b[i] < 0:
            A[i] = [-v for v in A[i]]; b[i] = -b[i]
    N = n + m
    T = [A[i] + [Fr(1) if j == i else Fr(0) for j in range(m)] + [b[i]] for i in range(m)]
    basis = [n + i for i in range(m)]
    cost = [Fr(0)] * n + [Fr(1)] * m
    for _ in range(4000):
        cb = [cost[basis[i]] for i in range(m)]
        ent = -1
        for j in range(N):
            if j in basis: continue
            z = sum(cb[i] * T[i][j] for i in range(m)) - cost[j]
            if z > 0: ent = j; break                 # Bland
        if ent < 0: break
        piv = -1; best = None
        for i in range(m):
            if T[i][ent] > 0:
                rat = T[i][N] / T[i][ent]
                if best is None or rat < best or (rat == best and basis[i] < basis[piv]):
                    best = rat; piv = i
        if piv < 0: return None                      # unbounded (cannot happen here)
        pv = T[piv][ent]; T[piv] = [v / pv for v in T[piv]]
        for i in range(m):
            if i != piv and T[i][ent] != 0:
                f = T[i][ent]; T[i] = [a - f * bb for a, bb in zip(T[i], T[piv])]
        basis[piv] = ent
    obj = sum(cost[basis[i]] * T[i][N] for i in range(m))
    return obj == 0

def cell_of_mixed(n):
    Hv = [sum(n[j] * MU[k][j] for j in range(5)) for k in range(5)]
    if len(set(n)) < 5 or len(set(Hv)) < 5: return None
    piA = tuple(sorted(range(5), key=lambda j: -n[j]))
    piG = tuple(sorted(range(5), key=lambda j: -Hv[j]))
    return CIDX.get((piA, piG))
t0 = time.time(); rr = random.Random(SEED + 3)
NSPAN = 1500; okspan = 0; tot = 0; cellseen = set()
while tot < NSPAN:
    n = [rr.randint(-60, 60) for _ in range(5)]; n[4] = -sum(n[:4])
    c = cell_of_mixed(tuple(n))
    if c is None: continue
    tot += 1; cellseen.add(c)
    gens = [RAYS[i] for i in INCID[c]]
    okspan += bool(cone_contains(gens, [n[0], n[1], n[2], n[3]]))
print(f"POSITIVE-SPAN CHECK (exact Fraction phase-1 simplex): {okspan}/{tot} random "
      f"interior lattice points of\n   {len(cellseen)} distinct cells are exact "
      f"NONNEGATIVE rational combinations of their cell's rays   [{time.time()-t0:.1f}s]")
assert okspan == tot
print("   (this is the empirical half; the proof is Minkowski-Weyl: the arrangement is")
print("    essential so every chamber is a POINTED polyhedral cone, hence the conic hull")
print("    of its extreme rays, and an extreme ray has active-set rank 3, i.e. is one of")
print("    the enumerated rays.  Therefore d >= 0 on a cell <=> d >= 0 at its rays.)")

# ==================================================== 3. the exact integer system
hdr("3. the exact integer system: H, the rank-19 lattice L, the congruence")
_FANCACHE = {}
def fan_pieces(key, NCELL, WL, SIGP, ORBS):
    if key in _FANCACHE: return _FANCACHE[key]
    adj = [[] for _ in range(NCELL)]
    for wi, (i, j, nu) in enumerate(WL):
        adj[i].append((j, wi)); adj[j].append((i, wi))
    par = [-1] * NCELL; parw = [-1] * NCELL; order = [0]
    seen = [False] * NCELL; seen[0] = True; qi = 0
    while qi < len(order):
        u = order[qi]; qi += 1
        for (v, wi) in adj[u]:
            if not seen[v]: seen[v] = True; par[v] = u; parw[v] = wi; order.append(v)
    assert all(seen)
    P = 4 + (NCELL - 1)
    EXPR = np.zeros((NCELL, 4, P), dtype=np.int64)
    for i in range(4): EXPR[0, i, i] = 1
    pid = 4
    for c in order[1:]:
        EXPR[c] = EXPR[par[c]]
        EXPR[c, :, pid] += nf4(WL[parw[c]][2]); pid += 1
    assert pid == P
    tree = set(parw[c] for c in order[1:])
    njump = 3 * (len(WL) - (NCELL - 1))
    HJ = np.zeros((njump, P), dtype=np.int64); ri = 0
    for wi, (i, j, nu) in enumerate(WL):
        if wi in tree: continue
        D = EXPR[i] - EXPR[j]; n4 = nf4(nu)
        j0 = next(t for t in range(4) if n4[t] % 11)
        for jj in range(4):
            if jj == j0: continue
            HJ[ri] = int(n4[j0]) * D[jj] - int(n4[jj]) * D[j0]; ri += 1
    assert ri == njump
    CM = np.zeros((4 * len(ORBS), P), dtype=np.int64)
    RHS = np.zeros(4 * len(ORBS), dtype=np.int64)
    rhs4 = np.array([((-c9[j]) - (-c9[4])) % 11 for j in range(4)], dtype=np.int64)
    ri = 0
    for orb in ORBS:
        Mt = np.zeros((4, P), dtype=np.int64); cc = orb[0]
        for k in range(5):
            E5 = np.zeros((5, P), dtype=np.int64); E5[:4] = EXPR[cc] % 11
            sh = E5[[(i + k) % 5 for i in range(5)]]
            sh = (sh - sh[4]) % 11
            Mt = (Mt + pow(9, k, 11) * sh[:4]) % 11
            cc = int(SIGP[cc])
        assert cc == orb[0]
        CM[ri:ri + 4] = Mt; RHS[ri:ri + 4] = rhs4; ri += 4
    _FANCACHE[key] = (EXPR, HJ, CM, RHS, P)
    return _FANCACHE[key]

def echelon_p(A, p):
    nA = A.shape[1]; E = np.zeros((0, nA), dtype=np.int64); piv = []
    for st in range(0, A.shape[0], BLK):
        B = np.array(A[st:st + BLK], dtype=np.int64) % p
        if piv:
            C = B[:, piv].copy(); B = (B - imatmul(C, E)) % p
        newp = []; keep = []
        for i in range(B.shape[0]):
            nz = np.nonzero(B[i])[0]
            if nz.size == 0: continue
            c = int(nz[0]); iv = pow(int(B[i, c]), p - 2, p)
            B[i] = (B[i] * iv) % p
            f = B[:, c].copy(); f[i] = 0
            nzr = np.nonzero(f)[0]
            if nzr.size: B[nzr] = (B[nzr] - np.outer(f[nzr], B[i])) % p
            newp.append(c); keep.append(i)
        if keep:
            Bn = B[keep]
            if piv:
                D = E[:, newp].copy(); E = (E - imatmul(D, Bn)) % p
            E = np.vstack([E, Bn]); piv += newp
    o = np.argsort(np.array(piv, dtype=np.int64))
    return E[o], [piv[i] for i in o]
def kernel_from_rref(E, piv, nA):
    ps = set(piv); free = [c for c in range(nA) if c not in ps]
    K = np.zeros((nA, len(free)), dtype=np.int64)
    if free:
        K[free, np.arange(len(free))] = 1
        if piv: K[np.array(piv), :] = -E[:, free]
    return K, free
def ratrec(a, M, N):
    r0, r1 = M, a % M; s0, s1 = 0, 1
    while r1 > N:
        q = r0 // r1; r0, r1 = r1, r0 - q * r1; s0, s1 = s1, s0 - q * s1
    num, den = r1, s1
    if den < 0: num, den = -num, -den
    if den == 0: return None
    g = gcd(abs(num), den); num //= g; den //= g
    if (num - a * den) % M != 0: return None
    return num, den
def bareiss_det(Mrows):
    A = [row[:] for row in Mrows]; n = len(A); sign = 1; prev = 1
    for k in range(n - 1):
        if A[k][k] == 0:
            sw = next((i for i in range(k + 1, n) if A[i][k] != 0), None)
            if sw is None: return 0
            A[k], A[sw] = A[sw], A[k]; sign = -sign
        for i in range(k + 1, n):
            for j in range(k + 1, n):
                A[i][j] = (A[i][j] * A[k][k] - A[i][k] * A[k][j]) // prev
            A[i][k] = 0
        prev = A[k][k]
    return sign * A[n - 1][n - 1]

def integer_solution_lattice(key, NCELL, WL, SIGP, ORBS, ZEROS,
                             primes=(1000003, 999983, 999979), verbose=True):
    """Returns (P, H, CM, RHS, K, x1, msg): K = exact Z-basis (P x d) of L = ker_Z(H)
       (11-saturated, saturation independently PROVED by a unit gcd of maximal minors),
       x1 = explicit integer solution of H x = 0, C x == rhs (mod 11)."""
    EXPR, HJ, CM, RHS, P = fan_pieces(key, NCELL, WL, SIGP, ORBS)
    ZR = EXPR[np.asarray(sorted(ZEROS), dtype=np.int64)].reshape(-1, P) if len(ZEROS) \
        else np.zeros((0, P), dtype=np.int64)
    H = np.concatenate([HJ, ZR], axis=0)
    Ks = []; pv0 = None
    for p in primes:
        Ep, pvp = echelon_p(H % p, p)
        if pv0 is None: pv0 = pvp
        else: assert pvp == pv0, "prime mismatch"
        Kp, free = kernel_from_rref(Ep, pvp, P); Ks.append(Kp % p)
    rp = len(pv0); d = P - rp
    M = 1
    for p in primes: M *= p
    KC = np.zeros((P, d), dtype=object)
    for t, p in enumerate(primes):
        Mi = M // p; KC += Ks[t].astype(object) * (Mi * pow(Mi % p, -1, p))
    KC %= M
    N = 1
    while 2 * N * N < M: N *= 2
    N //= 2
    nums = np.zeros((P, d), dtype=object)
    for t in range(d):
        L0 = 1; col = []
        for i in range(P):
            r = ratrec(int(KC[i, t]), M, N); assert r is not None
            col.append(r); L0 = L0 * r[1] // gcd(L0, r[1])
        for i in range(P): nums[i, t] = col[i][0] * (L0 // col[i][1])
    K = nums
    assert not (H.astype(np.int64) @ K.astype(np.int64)).any()
    nsat = 0
    for _ in range(60):
        Ek, pk = echelon_p(K.astype(np.int64) % 11, 11)
        if len(pk) == d: break
        Kk, _ = kernel_from_rref(Ek, pk, d); cvec = Kk[:, 0] % 11
        i0 = next(t for t in range(d) if cvec[t] % 11)
        cvec = (cvec * INV11[int(cvec[i0]) % 11]) % 11
        v = np.zeros(P, dtype=object)
        for t in range(d):
            if cvec[t]: v = v + K[:, t] * int(cvec[t])
        assert all(int(z) % 11 == 0 for z in v)
        K = K.copy(); K[:, i0] = np.array([int(z) // 11 for z in v], dtype=object)
        nsat += 1
    Ki = K.astype(np.int64)
    assert not (H.astype(np.int64) @ Ki).any()
    rk11 = len(echelon_p(Ki % 11, 11)[1])
    assert rk11 == d, ("11-saturation failed", rk11, d)
    # --- PROOF of saturation: gcd of maximal (d x d) minors of K is 1  =>  K spans
    #     a SATURATED sublattice, i.e. exactly L = ker_Z(H).
    rrsel = random.Random(SEED + 5)
    Etr, ptr = echelon_p(Ki.T % 1000003, 1000003)     # independent rows of K
    base = list(ptr)
    assert len(base) == d
    g = 0; ndet = 0
    for it in range(400):
        if it == 0: sel = list(base)
        elif it < 200:
            sel = list(base); sel[rrsel.randrange(d)] = rrsel.randrange(P)
            sel = sorted(set(sel))
            if len(sel) != d: continue
        else: sel = sorted(rrsel.sample(range(P), d))
        det = bareiss_det([[int(Ki[i, t]) for t in range(d)] for i in sel])
        if det:
            g = gcd(g, abs(det)); ndet += 1
        if g == 1: break
    msg = [f"unknowns P = {P}; rank_Fp(H) = {rp} over 3 primes ~10^6, so rank_Q(H) = "
           f"{rp} and L = ker_Z(H) has rank d = {d}",
           f"exact integer basis K of L: CRT + rational reconstruction over 3 primes, "
           f"H K = 0 over Z VERIFIED, {nsat} 11-saturation step(s), max|K| = "
           f"{int(np.abs(Ki).max())}",
           f"rank_F11(K) = {rk11} = d, so 11 is coprime to [L:L'] (11-SATURATED: "
           f"L' (x) F11 = L (x) F11); gcd of {ndet} sampled maximal {d}x{d} minors "
           f"of K = {g}" + ("  => L' = L = ker_Z(H) exactly" if g == 1 else "")]
    CKm = imatmul(CM % 11, Ki % 11) % 11
    Eq, pq = echelon_p(np.concatenate([CKm, (RHS % 11)[:, None]], axis=1), 11)
    if len(pq) and pq[-1] == d:
        raise ValueError("INTEGRAL-INFEASIBLE (congruence layer has no solution "
                         "in L (x) F11) -- this pattern is already dead without "
                         "positivity")
    rkC = len(pq)
    part = np.zeros(d, dtype=np.int64)
    for i, c in enumerate(pq): part[c] = Eq[i, d]
    Kc, freec = kernel_from_rref(Eq[:, :d], pq, d)
    x1 = (Ki.astype(object) @ part.astype(object)).astype(np.int64)
    assert not (H.astype(np.int64) @ x1).any()
    assert not ((imatmul(CM % 11, (x1 % 11)[:, None])[:, 0] - RHS) % 11).any()
    msg.append(f"congruence layer: rank_F11(C K) = {rkC}, solution space dim "
               f"{d - rkC} in F11^{d}; explicit integer witness x1 with "
               f"max|x1| = {int(np.abs(x1).max())}, H x1 = 0 over Z and "
               f"C x1 == rhs (mod 11) both VERIFIED")
    return P, H, CM, RHS, Ki, x1, (Kc, freec, pq, d, rkC), "\n     ".join(msg)

# ==================================================== exact-LP helpers (Fractions)
def frac_vec(fl, den=10 ** 7): return [Fr(float(v)).limit_denominator(den) for v in fl]
def exact_rref_frac(rows, ncols):
    A = [list(r) for r in rows]; m = len(A); piv = []; r0 = 0
    for col in range(ncols):
        pr = next((i for i in range(r0, m) if A[i][col] != 0), None)
        if pr is None: continue
        A[r0], A[pr] = A[pr], A[r0]
        pv = A[r0][col]; A[r0] = [x / pv for x in A[r0]]
        for i in range(m):
            if i != r0 and A[i][col] != 0:
                f = A[i][col]; A[i] = [x - f * y for x, y in zip(A[i], A[r0])]
        piv.append(col); r0 += 1
    return A[:r0], piv

def farkas_or_interior(Amat, tag):
    """Amat: list of integer rows (functionals) on Q^k.  Decide EXACTLY:
         (I)  exists z with Amat z >= 1 (componentwise)          -- relative interior
         (II) exists y >= 0, sum y = 1, y^T Amat = 0             -- Farkas blocker
       Exactly one holds.  Float LP proposes, Fraction arithmetic disposes.
       Returns ('INTERIOR', z_frac) or ('BLOCKED', y_frac)."""
    m = len(Amat); k = len(Amat[0])
    An = np.array(Amat, dtype=np.float64)
    r1 = linprog(c=np.zeros(k), A_ub=-An, b_ub=-np.ones(m),
                 bounds=[(None, None)] * k, method='highs')
    if r1.status == 0:
        for den in (10 ** 3, 10 ** 5, 10 ** 7, 10 ** 9):
            z = frac_vec(r1.x, den)
            vals = [sum(Fr(int(Amat[i][j])) * z[j] for j in range(k)) for i in range(m)]
            if all(v > 0 for v in vals):
                sc = min(vals)
                return ('INTERIOR', [v / sc for v in z])
    r2 = linprog(c=np.zeros(m), A_eq=np.vstack([An.T, np.ones((1, m))]),
                 b_eq=np.concatenate([np.zeros(k), [1.0]]),
                 bounds=[(0, None)] * m, method='highs')
    if r2.status == 0:
        supp = [i for i in range(m) if r2.x[i] > 1e-9]
        rows = [[Fr(int(Amat[i][j])) for i in supp] for j in range(k)]
        rows.append([Fr(1)] * len(supp))
        rhs = [Fr(0)] * k + [Fr(1)]
        aug = [rows[t] + [rhs[t]] for t in range(k + 1)]
        R, piv = exact_rref_frac(aug, len(supp))
        if not any(all(r[c] == 0 for c in range(len(supp))) and r[len(supp)] != 0
                   for r in R):
            ys = [Fr(0)] * len(supp)
            freec = [c for c in range(len(supp)) if c not in piv]
            for c in freec: ys[c] = Fr(float(r2.x[supp[c]])).limit_denominator(10 ** 7)
            for i, c in enumerate(piv):
                ys[c] = R[i][len(supp)] - sum(R[i][f] * ys[f] for f in freec)
            y = [Fr(0)] * m
            for a, i in enumerate(supp): y[i] = ys[a]
            if all(v >= 0 for v in y) and sum(y) == 1 and \
               all(sum(y[i] * Fr(int(Amat[i][j])) for i in range(m)) == 0
                   for j in range(k)):
                return ('BLOCKED', y)
    return ('UNRESOLVED', None)

# ==================================================== 4. the positivity program
def positivity(tagP, ZEROS, do_witness=True):
    hdr(f"4. POSITIVITY on the mixed fan: pattern {tagP}")
    key = ("mixed", tuple(sorted(ZEROS)))
    P, H, CM, RHS, Kb, x1, cinfo, msg = integer_solution_lattice(
        key, NC, WALLS, SIG, ORB, sorted(ZEROS))
    Kc, freec, pq, d, rkC = cinfo
    print(f"  zero cells {len(ZEROS)}/{NC}")
    print(f"     {msg}")
    EXPR = _FANCACHE[key][0]
    # --- the solution lattice Lambda_sol = x1 + M  (task 2)
    Mc = np.zeros((d, d), dtype=np.int64); col = 0
    for a in range(Kc.shape[1]):
        Mc[:, col] = Kc[:, a] % 11; col += 1
    for p in pq:
        e = np.zeros(d, dtype=np.int64); e[p] = 11; Mc[:, col] = e; col += 1
    assert col == d
    Mx = imatmul(Kb, Mc)                                # (P,d): Z-basis of M
    dt = bareiss_det([[int(Mc[i][j]) for j in range(d)] for i in range(d)])
    rrm = random.Random(SEED + 9); bad = 0
    for _ in range(30):
        co = np.array([rrm.randint(-4, 4) for _ in range(d)], dtype=np.int64)
        mvec = imatmul(Mx, co[:, None])[:, 0]
        if (H.astype(np.int64) @ mvec).any(): bad += 1
        if (imatmul(CM % 11, (mvec % 11)[:, None])[:, 0] % 11).any(): bad += 1
        xx = x1 + mvec
        if (H.astype(np.int64) @ xx).any(): bad += 1
        if ((imatmul(CM % 11, (xx % 11)[:, None])[:, 0] - RHS) % 11).any(): bad += 1
    print(f"  SOLUTION LATTICE Lambda_sol = x1 + M, M = {{x in L : C x == 0 mod 11}}: "
          f"rank {d}, [L:M] = |det| = {abs(dt)} = 11^{rkC}: {abs(dt) == 11**rkC}")
    print(f"     VERIFIED on 30 random m in M: H m = 0 over Z, C m == 0 (mod 11), and "
          f"x1 + m solves everything -- {bad} violations")
    assert bad == 0 and abs(dt) == 11 ** rkC

    # --- ray functionals (task 3 setup):  d_x(r) = <U_{C}(x), r>,  C any cell at r
    Gm = imatmul(EXPR.reshape(-1, P), Kb).reshape(NC, 4, d)      # U_C in c-coords
    ROWS = []; nzeroray = 0; incons = 0
    for i in range(NR):
        rows = set()
        for c in RCELL[i]:
            v = tuple(int(z) for z in (R4[i].astype(np.int64) @ Gm[c]))
            rows.add(v)
        if len(rows) > 1: incons += 1
        v = rows.pop()
        if all(z == 0 for z in v): nzeroray += 1; ROWS.append(None)
        else: ROWS.append(v)
    print(f"  d(r) = <U_C, r> is INDEPENDENT of the cell C containing r, checked over "
          f"ALL {sum(len(RCELL[i]) for i in range(NR))}\n     (ray, cell) incidences: "
          f"{incons} inconsistencies  (continuity of the PL field, on ker_Q(H))")
    assert incons == 0
    Z0 = set(ZEROS)
    forced = sum(1 for i in range(NR) if any(c in Z0 for c in RCELL[i]))
    print(f"  rays in the closure of a zero cell: {forced}; rays whose functional "
          f"vanishes identically\n     on ker_Q(H): {nzeroray}  (>= forced: "
          f"{nzeroray >= forced}) -- these rows carry NO information")
    A_all = [ROWS[i] for i in range(NR) if ROWS[i] is not None]
    # dedupe up to positive scaling
    ded = {}
    for v in A_all:
        g = 0
        for z in v: g = gcd(g, abs(z))
        pv = tuple(z // g for z in v)
        ded[pv] = ded.get(pv, 0) + 1
    A = sorted(ded.keys())
    print(f"  live ray inequalities: {len(A_all)} rows, {len(A)} distinct up to positive "
          f"scaling")
    rkA = len(exact_rref_frac([[Fr(z) for z in r] for r in A], d)[1])
    print(f"  rank_Q of the live inequality matrix = {rkA} (of {d})")

    # --- sanity control: the zero field fails the congruence
    z0 = np.zeros(P, dtype=np.int64)
    cres = (imatmul(CM % 11, (z0 % 11)[:, None])[:, 0] - RHS) % 11
    print(f"  CONTROL: x = 0 (i.e. d == 0, positive trivially) violates the congruence "
          f"in {int((cres != 0).sum())} of {len(RHS)} rows -- so d == 0 is NOT a witness")
    assert (cres != 0).any()
    # --- sanity control: the f55_mixedlevel3 witness x1 itself
    dv = []
    for i in range(NR):
        c = RCELL[i][0]
        u = (EXPR[c].astype(object) @ x1.astype(object))
        dv.append(int(sum(int(u[t]) * int(R4[i][t]) for t in range(4))))
    neg = sum(1 for v in dv if v < 0)
    print(f"  CONTROL: the f55_mixedlevel3-style integer witness x1 evaluated at the "
          f"{NR} rays:\n     {neg} negative, {sum(1 for v in dv if v==0)} zero, "
          f"{sum(1 for v in dv if v>0)} positive; min = {min(dv)}, max = {max(dv)}"
          f"  => x1 is NOT d >= 0")

    # --- the exact cone analysis: K+ = {c in Q^d : A c >= 0}
    print(f"\n  EXACT CONE ANALYSIS of K+ = {{c in Q^{d} : A c >= 0}} "
          f"(the rational positivity cone)")
    Bcur = [[Fr(1) if i == j else Fr(0) for j in range(d)] for i in range(d)]  # basis of V, d x k
    kdim = d
    Eqs = []           # accumulated implicit-equality rows (in the ORIGINAL c-coords)
    certs = []
    rounds = 0
    verdict = None
    while True:
        rounds += 1
        # rows of A restricted to V:  A_V = A * B
        AV = []; keep = []
        for idx, r in enumerate(A):
            row = [sum(Fr(int(r[i])) * Bcur[i][t] for i in range(d)) for t in range(kdim)]
            if any(x != 0 for x in row):
                L0 = 1
                for x in row: L0 = L0 * x.denominator // gcd(L0, x.denominator)
                AV.append([int(x * L0) for x in row]); keep.append(idx)
        print(f"    round {rounds}: dim V = {kdim}, live rows on V = {len(AV)}")
        if kdim == 0:
            verdict = ('TRIVIAL', None); break
        if not AV:
            verdict = ('FREE', None); break
        st, w = farkas_or_interior(AV, tagP)
        if st == 'INTERIOR':
            verdict = ('INTERIOR', (w, list(Bcur), kdim)); break
        if st != 'BLOCKED':
            verdict = ('UNRESOLVED', None); break
        supp = [keep[i] for i in range(len(AV)) if w[i] != 0]
        certs.append((list(w), list(keep)))
        print(f"       Farkas blocker verified EXACTLY: y >= 0, sum y = 1, y^T A_V = 0, "
              f"support {len(supp)}")
        for idx in supp: Eqs.append(A[idx])
        # V := V cap {c : A[idx] c = 0 for idx in supp}
        M2 = [[sum(Fr(int(A[idx][i])) * Bcur[i][t] for i in range(d))
               for t in range(kdim)] for idx in supp]
        R2, piv2 = exact_rref_frac(M2, kdim)
        freev = [c for c in range(kdim) if c not in piv2]
        NB = []
        for f in freev:
            z = [Fr(0)] * kdim; z[f] = Fr(1)
            for i, c in enumerate(piv2): z[c] = -R2[i][f]
            NB.append(z)
        Bnew = [[sum(Bcur[i][t] * NB[a][t] for t in range(kdim)) for a in range(len(NB))]
                for i in range(d)]
        Bcur = Bnew; kdim = len(NB)

    print(f"\n  >>> CONE VERDICT for pattern {tagP}: ", end="")
    if verdict[0] == 'TRIVIAL':
        print("K+ = {0}")
        rkE = len(exact_rref_frac([[Fr(z) for z in r] for r in Eqs], d)[1])
        print(f"      the accumulated implicit-equality rows have rank_Q = {rkE} = {d}: "
              f"{rkE == d}")
        assert rkE == d
        # single strictly-positive Stiemke certificate y > 0, y^T A = 0
        m = len(A)
        An = np.array(A, dtype=np.float64)
        rr = linprog(c=np.ones(m), A_eq=An.T, b_eq=np.zeros(d),
                     bounds=[(1, None)] * m, method='highs')
        okcert = False
        if rr.status == 0:
            rowsT = [[Fr(int(A[i][j])) for i in range(m)] for j in range(d)]
            R3, piv3 = exact_rref_frac([row + [Fr(0)] for row in rowsT], m)
            free3 = [c for c in range(m) if c not in piv3]
            y = [Fr(0)] * m
            for c in free3: y[c] = Fr(float(rr.x[c])).limit_denominator(10 ** 6)
            for i, c in enumerate(piv3):
                y[c] = -sum(R3[i][f] * y[f] for f in free3)
            okcert = all(v > 0 for v in y) and \
                all(sum(y[i] * Fr(int(A[i][j])) for i in range(m)) == 0 for j in range(d))
            if okcert:
                print(f"      STIEMKE CERTIFICATE (exact): y in Q^{m}, y > 0 "
                      f"componentwise (min y = {min(y)}), y^T A = 0 EXACTLY.")
                print(f"      Proof: c with A c >= 0 gives 0 = y^T(A c) = sum y_i (Ac)_i "
                      f"with y_i > 0, (Ac)_i >= 0,\n      so A c = 0; and rank_Q(A) = "
                      f"{rkA} = {d} forces c = 0.   QED")
        if not okcert:
            print(f"      (single Stiemke vector not reconstructed; the verified "
                  f"{len(certs)}-step Farkas CHAIN above\n      is the certificate: each "
                  f"step is an exactly verified y >= 0, sum y = 1, y^T A_V = 0, and the "
                  f"accumulated equality rows have rank {d}.)")
        print(f"\n  ==> PATTERN {tagP} DIES BY POSITIVITY: no nonzero rational -- a "
              f"fortiori no integral --\n      field with d >= 0 at every ray exists in "
              f"ker_Q(H).  Since d == 0 fails the congruence,\n      the positivity-"
              f"restored system on this pattern is INFEASIBLE.")
        return ('DIES-BY-POSITIVITY', None, rkA, d)
    if verdict[0] == 'UNRESOLVED':
        print("UNRESOLVED (LP not certified)"); return ('UNRESOLVED', None, rkA, d)
    if verdict[0] == 'FREE':
        print(f"every remaining row is identically zero on V (dim {kdim}) -- K+ contains "
              f"a subspace")
        w = [Fr(0)] * kdim; w[0] = Fr(1)
        Bl = list(Bcur)
    else:
        w, Bl, kdim = verdict[1]
        print(f"K+ has a RELATIVE INTERIOR point; dim K+ = {kdim}")
    # --- build an integral nonnegative witness (task 5)
    u = [sum(Bl[i][t] * w[t] for t in range(kdim)) for i in range(d)]
    L0 = 1
    for x in u: L0 = L0 * x.denominator // gcd(L0, x.denominator)
    ui = np.array([int(x * L0) for x in u], dtype=np.int64)
    dU = [sum(int(A[i][j]) * int(ui[j]) for j in range(d)) for i in range(len(A))]
    print(f"      integral direction u in L with A u >= 0: min {min(dU)}, "
          f"# strictly positive {sum(1 for v in dU if v>0)} of {len(dU)}")
    if min(dU) < 0:
        print("      (direction not nonneg -- UNRESOLVED)"); return ('UNRESOLVED', None, rkA, d)
    # c-coords of x1
    Etr, ptr = echelon_p(Kb.T % 1000003, 1000003)
    # solve Kb * cx = x1 exactly on the pivot rows
    sel = list(ptr)
    Msq = [[Fr(int(Kb[i][t])) for t in range(d)] + [Fr(int(x1[i]))] for i in sel]
    R4f, piv4 = exact_rref_frac(Msq, d)
    cx = [Fr(0)] * d
    for i, c in enumerate(piv4): cx[c] = R4f[i][d]
    assert all(v.denominator == 1 for v in cx)
    cxi = np.array([int(v) for v in cx], dtype=np.int64)
    assert (imatmul(Kb, cxi[:, None])[:, 0] == x1).all()
    dX = [sum(int(A[i][j]) * int(cxi[j]) for j in range(d)) for i in range(len(A))]
    Nn = 1
    while True:
        cand = [dX[i] + 11 * Nn * dU[i] for i in range(len(A))]
        if min(cand) >= 0: break
        Nn *= 2
        if Nn > 10 ** 9: break
    cy = cxi + 11 * Nn * ui
    y = imatmul(Kb, cy[:, None])[:, 0]
    print(f"      candidate witness y = x1 + 11*{Nn}*u  (11*M-shift keeps the congruence)")
    return ('LP-FEASIBLE', (y, cy, ui, Nn, A, Kb, H, CM, RHS, EXPR, P), rkA, d)

# ==================================================== main
def run_pattern(tagP, ZEROS):
    st, dat, rkA, d = positivity(tagP, ZEROS)
    if st != 'LP-FEASIBLE': return st
    (y, cy, ui, Nn, A, Kb, H, CM, RHS, EXPR, P) = dat
    print("\n" + "!" * 78)
    print(f"!!!  NONNEGATIVE INTEGRAL WITNESS CANDIDATE for pattern {tagP}")
    print("!" * 78)
    v1 = int((H.astype(object) @ y.astype(object) != 0).sum())
    v2 = int(((imatmul(CM % 11, (y % 11)[:, None])[:, 0] - RHS) % 11 != 0).sum())
    U4 = (EXPR.reshape(-1, P).astype(object) @ y.astype(object)).reshape(NC, 4)
    U5 = [[int(U4[c][t]) for t in range(4)] + [0] for c in range(NC)]
    # ---- (A) INDEPENDENT re-verification over Z, condition by condition, bypassing
    #          the row encoding entirely.
    vj = 0
    for (i, j, nu) in WALLS:
        D = [U5[i][t] - U5[j][t] for t in range(5)]
        n5 = [nu[t] - nu[4] for t in range(5)]
        j0 = next(t for t in range(5) if n5[t])
        if D[j0] % n5[j0]: vj += 1; continue
        m = D[j0] // n5[j0]
        if any(D[t] != m * n5[t] for t in range(5)): vj += 1
    v4 = sum(1 for c in ZEROS if any(U5[c][t] for t in range(5)))
    dr = [int(sum(U5[RCELL[i][0]][t] * int(R4[i][t]) for t in range(4)))
          for i in range(NR)]
    v3 = sum(1 for v in dr if v < 0)
    # ---- (B) GROUND TRUTH at random lattice points: d >= 0, the TWICE-MIN structure
    #          min_k d(sigma^k n) = 0 attained >= 2 times, and (ii) itself.
    rrp = random.Random(SEED + 21)
    v5 = v6 = v7 = nb = 0
    for _ in range(20000):
        B = rrp.choice((6, 20, 80, 300))
        n = [rrp.randint(-B, B) for _ in range(5)]; n[4] = -sum(n[:4])
        n = tuple(n)
        cs = [cell_of_mixed(n)]
        m = n
        for _ in range(4):
            m = sigN(m); cs.append(cell_of_mixed(m))
        if any(c is None for c in cs): continue
        nb += 1
        vals = []; m = n
        for k in range(5):
            vals.append(sum(U5[cs[k]][t] * m[t] for t in range(5)))
            m = sigN(m)
        if min(vals) < 0: v5 += 1
        if min(vals) != 0 or sum(1 for v in vals if v == 0) < 2: v6 += 1
        if (sum(pow(9, k, 11) * vals[k] for k in range(5))
                + sum(n[t] * c9[t] for t in range(5))) % 11: v7 += 1
    v8 = sum(1 for c in range(NC)
             if sum(U5[c][t] * int(PTS[c][t]) for t in range(5)) < 0)
    orbz = min(sum(1 for c in o if c in set(ZEROS)) for o in ORB)
    print(f"!!!  (encoding)  H y = 0 over Z: {v1} violations;  C y == rhs (mod 11): "
          f"{v2} violations")
    print(f"!!!  (over Z, independent of the encoding) wall jumps NOT of the form "
          f"m*nu, m in Z: {vj} of {len(WALLS)}")
    print(f"!!!  (over Z) zero cells with U != 0: {v4} of {len(ZEROS)}; min zero cells "
          f"per sigma-orbit = {orbz} (>= 2 needed)")
    print(f"!!!  d(r) < 0 at the {NR} enumerated rays: {v3}   [d >= 0 at every ray "
          f"<=> d >= 0 EVERYWHERE]")
    print(f"!!!  d < 0 at the {NC} cell witness points: {v8}")
    print(f"!!!  GROUND TRUTH at {nb} random lattice points of N (boxes 6/20/80/300), "
          f"all 5 sigma-translates:")
    print(f"!!!     d < 0                                        : {v5}")
    print(f"!!!     TWICE-MIN  min_k d(sig^k n) = 0 attained >= 2x: {v6} failures")
    print(f"!!!     (ii)  sum_k 9^k d(sig^k n) + <n,c9> == 0 (11) : {v7} failures")
    mxU = max(abs(v) for row in U5 for v in row)
    dpos = sum(1 for c in range(NC) if any(U5[c][t] for t in range(5)))
    print(f"!!!  max|U| = {mxU}; cells with U != 0: {dpos} of {NC}; "
          f"d at rays: min {min(dr)}, max {max(dr)}, zero at {sum(1 for v in dr if v==0)}")
    print(f"!!!  witness (c-coords in the L-basis): {list(int(v) for v in cy)}")
    if (v1, v2, vj, v3, v4, v5, v6, v7, v8) == (0,) * 9 and orbz >= 2 and nb > 5000:
        print("!!!  ===> GENUINE NONNEGATIVE INTEGRAL WITNESS of the POSITIVITY-RESTORED")
        print("!!!       value-form system (0) d >= 0, (1) zeros/twice-min, (2) integral")
        print("!!!       slopes, (3) the congruence (ii).  The corrected Lemma S is FALSE")
        print("!!!       on the mixed fan.")
        return 'NONNEG-WITNESS'
    print("!!!  candidate FAILED verification -- inconclusive")
    return 'UNRESOLVED'

def safe_run(tag, Z):
    try:
        return run_pattern(tag, Z)
    except ValueError as e:
        print(f"  {tag}: {e}")
        return 'ALREADY-DEAD (congruence)'

RES = {}
for P0 in [(0, 1), (3, 4)]:
    Z = [i for i, (pA, pG) in enumerate(CK) if pG.index(0) in P0]
    RES[str(list(P0))] = safe_run(f"G9-rank P = {list(P0)}", Z)

if os.environ.get("F55_EFAM", "1") == "1":
    # the (e)-family of f55_mixedlevel3.py: start from the aligned pullback of the
    # surviving rank pattern P = {0,1} and replace the label pair in ONE G9-orbit.
    LAB = {}
    for gi, og in enumerate(GORB):
        LAB[gi] = {GPERM[g].index(0): g for g in og}
        assert sorted(LAB[gi]) == [0, 1, 2, 3, 4]
    for gi0 in (0, 1, 2):
        for (i0, j0) in pairs:
            if (i0, j0) == (0, 1): continue
            zg = set()
            for gi in range(len(GORB)):
                for t in ({i0, j0} if gi == gi0 else {0, 1}): zg.add(LAB[gi][t])
            Ze = sorted(c for g in zg for c in GCELLS[g])
            if min(sum(1 for c in o if c in set(Ze)) for o in ORB) < 2:
                RES[f"(e) G9-orbit {gi0} -> {(i0,j0)}"] = 'inadmissible'
                continue
            RES[f"(e) G9-orbit {gi0} -> {(i0,j0)}"] = safe_run(
                f"(e)-family: G9-orbit {gi0} pair -> {(i0, j0)}", Ze)

hdr("5. VERDICT")
for k, v in RES.items(): print(f"  {k:34s} : {v}")
print(f"\nreproduce:  python3 {os.path.basename(__file__)}   (deterministic, seed {SEED})")
print(f"total runtime {time.time()-T00:.1f}s")
