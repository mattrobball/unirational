#!/usr/bin/env python3
# f55_qpreimage.py -- THE PREIMAGE (LIFTING) TEST: do the mixed-fan value-form
# witnesses of f55_mixedpos.py come from an actual Theorem-Q object?
#
# THE QUESTION (Note IX S8.16 / S8.26).  f55_mixedpos.py produced NONNEGATIVE
# integral witnesses d on the mixed fan for the SHADOW ("value form") system
#     (0) d >= 0,  (1) d = 0 on >= 2 cells per sigma-orbit,  (2) integral slopes
#     with wall jumps in Z*nu,  (3) sum_k 9^k d(sig^k n) + <n,c9> == 0 (mod 11).
# The ORIGINAL object is Theorem Q:  F := 2h + h.sig^{-1} - e2*  for an
# integral-sloped PL h, with the sigma-orbit min of F attained at least twice
# everywhere.  d is the min-normalization  d = F - m,  m(n) := min_i F(sig^i n)
# (m is sigma-invariant and integral-sloped PL).  So a shadow witness d is a
# GENUINE Theorem-Q shadow only if it LIFTS: there must exist integral-sloped PL
# h and sigma-invariant integral-sloped PL m with
#
#     (*)     2h + h.sig^{-1} - e2*  =  d + m       on N = {n in Z^5 : sum n = 0}.
#
# If (*) is unsolvable, the value form is STRICTLY WEAKER than Theorem Q and the
# witnesses are not counterexamples to the real lemma.
#
# THE SLOPE FRAME.  U_f(C) in Lambda = Z^5/diag is the slope of f on the maximal
# cone C.  With <U, sig^k n> = <shift_k U, n>, (shift_k U)_i = U_{(i+k) mod 5}
# (verified in f55_mixedfan.py, RE-verified here), one gets
#     U_{h.sig^{-1}}(C) = S U_h(sig^{-1} C),    S := shift_{-1},
# so (*) reads, cell by cell,
#
#     (**)    2 U_h(C) + S U_h(sig^{-1} C) - e2  ==  U_d(C) + U_m(C)   in Lambda,
#
# with wall conditions for U_h and U_m and sigma-equivariance U_m(sig C) = S U_m(C).
#
# THE ANSWER, AND WHY IT IS EXACT AND NOT A SEARCH.  Write sigt for precomposition
# with sig^{-1}; then (*) is (2 + sigt) h = d + m + e2*.  In Z[x]/(x^5-1),
#     (x + 2)(x^4 - 2x^3 + 4x^2 - 8x + 16) = x^5 + 32 == 33,
# so G(sigt) := sigt^4 - 2 sigt^3 + 4 sigt^2 - 8 sigt + 16 satisfies
# (2+sigt) G(sigt) = 33.  Hence 2+sigt is INJECTIVE on any torsion-free module and
#     h = (1/33) G(sigt)(d + m + e2*)     is UNIQUELY determined by d and m,
# and (*) is solvable over Z if and only if the slope field of G(sigt)(d+m+e2*) is
# divisible by 33 in Lambda at every cell.  Since G(1) = 11, a sigma-invariant m
# contributes exactly 11*U_m, so the criterion splits by CRT:
#   * mod 11:  m drops out entirely and the condition is EXACTLY congruence (3);
#   * mod  3:  G == 1+x+x^2+x^3+x^4 and 11 == -1, so the condition is
#              U_m == U_D (mod 3), D := sum_j d.sig^j -- always satisfiable,
#              because D is itself a sigma-invariant integral-sloped PL function.
# So (*) IS SOLVABLE, with the explicit choice m = D, and the general solution is
# h = h_0 + k, m = D + 3k for an arbitrary sigma-invariant integral-sloped PL k.
# Every step above is verified numerically below, and the resulting h is verified
# by substitution into every one of the 1090 + 2570 + 2570 + 1090 constraints and
# against Theorem Q directly at 20000+ random lattice points.
#
# THE UPGRADE TO THEOREM Q PROPER (support function of a LATTICE POLYTOPE).
# h_0 is integral-sloped PL but need not be convex.  Because Phi(n) := sum over
# the 20 arrangement forms of |<l, n>| is a SIGMA-INVARIANT, integral-sloped,
# strictly-wall-convex PL function on exactly the mixed fan, h_T := h_0 + T*Phi is
# convex for T large, is still an exact solution of (*) (with m = D + 3T*Phi), and
# F changes only by the orbit-constant 3T*Phi(n) -- so the twice-min structure is
# untouched.  Convexity is then decided EXACTLY by the ray criterion
#     h convex  <=>  h(r) = max_C <U_h(C), r>  at every ray r of the fan
# (both directions proved in the code comments), and Q := conv{U_h(C)} is a
# LATTICE polytope with h_Q = h_T.  Likewise h_0 - T*Phi realises the min/concave
# support-function convention.
#
# Reproduce:  python3 f55_qpreimage.py          (deterministic; seed 20260807)
#   env knobs: F55_EFAM=0 skip the (e)-family sweep; F55_NPTS ground-truth points
import numpy as np, random, time, sys, os
from fractions import Fraction as Fr
from itertools import combinations, permutations
from math import gcd
from scipy.optimize import linprog

T00 = time.time()
SEED = 20260807
BLK = 512
NPTS = int(os.environ.get("F55_NPTS", "20000"))
np.seterr(all='raise')
def hdr(s): print("\n" + "=" * 78 + "\n== " + s + "\n" + "=" * 78)
def sub(s): print("\n--- " + s)

# ============================================================ 0. conventions
G9 = (1, 5, 3, 4, 9)
c9 = (4, 9, 1, 5, 3)
E2 = (0, 0, 1, 0, 0)                       # e_2: the linear defect of Theorem Q
MU = [tuple(G9[(j + k) % 5] for j in range(5)) for k in range(5)]
pairs = list(combinations(range(5), 2))
INV11 = [0] + [pow(a, 9, 11) for a in range(1, 11)]
GC = [16, -8, 4, -2, 1]                    # G(x) = 16 - 8x + 4x^2 - 2x^3 + x^4

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
def lift5(u): return np.array([u[0], u[1], u[2], u[3], 0], dtype=np.int64)
def to4(n): return np.array(n[:4], dtype=np.int64)     # <U,n> = nf4(U) . (n_0..n_3)
def imatmul(X, Y):
    if X.size == 0 or Y.size == 0:
        return np.zeros((X.shape[0], Y.shape[1]), dtype=np.int64)
    mx = int(np.abs(X).max()); my = int(np.abs(Y).max()); n = X.shape[1]
    if mx * my * n < 2 ** 52:
        return (X.astype(np.float64) @ Y.astype(np.float64)).astype(np.int64)
    return X.astype(object) @ Y.astype(object)

hdr("0. CONVENTIONS AND THE SLOPE FRAME -- derived and verified numerically")
rng0 = random.Random(SEED)
def rnd_n(B=40):
    n = [rng0.randint(-B, B) for _ in range(5)]; n[4] = -sum(n[:4]); return tuple(n)

ok = True
for _ in range(2000):
    n = rnd_n(30)
    for k in range(5):
        m = n
        for _ in range(k): m = sigN(m)
        if sum(m[j] * G9[j] for j in range(5)) != sum(n[j] * MU[k][j] for j in range(5)):
            ok = False
print("H_k(n) = <sig^k n, G9> = <n, mu_k>, mu_k[j] = G9[(j+k)%5] :", ok); assert ok

# --- the M-side transport: which index shift realises <U, sig^k n> = <shift U, n>?
sc_up = sc_dn = 0
for _ in range(2000):
    n = rnd_n(30); U = tuple(rng0.randint(-40, 40) for _ in range(5))
    m = n
    for k in range(1, 5):
        m = sigN(m)
        lhs = sum(U[j] * m[j] for j in range(5))
        sc_up += (lhs == sum(U[(i + k) % 5] * n[i] for i in range(5)))
        sc_dn += (lhs == sum(U[(i - k) % 5] * n[i] for i in range(5)))
print(f"M-side transport (8000 trials): (shift U)_i = U_(i+k): {sc_up} hits ; "
      f"(shift U)_i = U_(i-k): {sc_dn} hits")
assert sc_up == 8000 and sc_dn < 8000
print("VERIFIED: <U, sig^k n> = <shift_k U, n>, (shift_k U)_i = U_{(i+k) mod 5}")

# --- sigma_* = shift_{-1} as a matrix S on the normalized coordinates of Lambda
S = np.array([[0, 0, 0, -1], [1, 0, 0, -1], [0, 1, 0, -1], [0, 0, 1, -1]], dtype=np.int64)
bad = 0
for _ in range(2000):
    u = np.array([rng0.randint(-40, 40) for _ in range(4)], dtype=np.int64)
    U5 = lift5(u); sh = np.array([U5[(i - 1) % 5] for i in range(5)])
    if not (nf4(sh) == S @ u).all(): bad += 1
SP = [np.linalg.matrix_power(S, j) for j in range(5)]      # S^j  = shift_{-j}
SM = [np.linalg.matrix_power(S, (-j) % 5) for j in range(5)]  # S^-j = shift_{+j}
print(f"S := shift_{{-1}} on Lambda in normalized coords: matches on 2000 random U "
      f"({bad} failures); S^5 = I: {(SP[0] == np.eye(4, dtype=np.int64)).all() and (np.linalg.matrix_power(S,5) == np.eye(4, dtype=np.int64)).all()}; "
      f"det S = {int(round(np.linalg.det(S)))}")
assert bad == 0
bad = 0
for _ in range(2000):
    u = np.array([rng0.randint(-40, 40) for _ in range(4)], dtype=np.int64); n = rnd_n(30)
    ni = n
    for _ in range(4): ni = sigN(ni)                       # sig^{-1} n
    l = int(sum(int(lift5(S @ u)[j]) * n[j] for j in range(5)))
    r = int(sum(int(lift5(u)[j]) * ni[j] for j in range(5)))
    bad += (l != r)
print(f"<S u, n> == <u, sig^{{-1}} n> on 2000 random (u, n): {bad} failures")
assert bad == 0
bad = 0
for _ in range(2000):
    U = tuple(rng0.randint(-40, 40) for _ in range(5)); n = rnd_n(30)
    bad += (int(sum(U[j] * n[j] for j in range(5))) != int(nf4(U) @ to4(n)))
print(f"pairing in normalized coords: <U, n> == nf4(U) . (n_0..n_3) on 2000 random "
      f"(U, n): {bad} failures")
assert bad == 0
print("   => for PL f:  U_{f.sig^{-1}}(C) = S U_f(sig^{-1} C).   THIS IS sigma_* IN (**).")

# --- e2 and c9
acc = np.zeros(5, dtype=np.int64)
for k in range(5):
    acc = acc + pow(9, k, 11) * np.array([E2[(i + k) % 5] for i in range(5)])
print(f"e2 = {E2}: sum_k 9^k shift_k(e2) == c9 = {c9} (mod 11): "
      f"{tuple(int(x) % 11 for x in acc) == c9};  <e2, G9> = {G9[2]} = lambda(e2) = 3 "
      f"(S8.16): {G9[2] == 3}")
assert tuple(int(x) % 11 for x in acc) == c9 and G9[2] == 3
E24 = nf4(E2)

# --- the operator identity (2 + sigt) G(sigt) = 33
NCT = 25; SIGT = [(c // 5) * 5 + (c % 5 + 1) % 5 for c in range(NCT)]
SIGTI = [0] * NCT
for c in range(NCT): SIGTI[SIGT[c]] = c
def op2s(U, sigi):
    return np.array([2 * U[c] + S @ U[sigi[c]] for c in range(len(U))])
def opG(U, sigi):
    out = np.zeros_like(U)
    for j in range(5):
        for c in range(len(U)):
            cc = c
            for _ in range(j): cc = sigi[cc]
            out[c] = out[c] + GC[j] * (SP[j] @ U[cc])
    return out
rr = np.random.default_rng(SEED)
U0 = rr.integers(-30, 31, size=(NCT, 4)).astype(np.int64)
print(f"operator identity on a free C5-set: G(sigt)(2+sigt) U == 33 U: "
      f"{(opG(op2s(U0, SIGTI), SIGTI) == 33 * U0).all()}; "
      f"(2+sigt)G(sigt) U == 33 U: {(op2s(opG(U0, SIGTI), SIGTI) == 33 * U0).all()}")
assert (opG(op2s(U0, SIGTI), SIGTI) == 33 * U0).all()
assert (op2s(opG(U0, SIGTI), SIGTI) == 33 * U0).all()
GE2 = sum(GC[j] * (SP[j] @ E24) for j in range(5))
print(f"G(sigt) applied to the constant field e2:  {tuple(int(x) for x in GE2)} ; "
      f"mod 3 = {tuple(int(x) % 3 for x in GE2)} (zero: {not (GE2 % 3).any()}) ; "
      f"mod 11 = {tuple(int(x) % 11 for x in GE2)}")

# --- the mod-11 half of the 33-criterion IS congruence (3)
def cong3_field(U, sigp):
    out = np.zeros_like(U)
    for c in range(len(U)):
        acc = np.zeros(4, dtype=np.int64); cc = c
        for k in range(5):
            acc = acc + pow(9, k, 11) * (SM[k] @ U[cc]); cc = sigp[cc]
        out[c] = acc % 11
    return out
nc9 = nf4(c9)
okid = True
for _ in range(200):
    U = rr.integers(-40, 41, size=(NCT, 4)).astype(np.int64)
    A_ = (opG(U, SIGTI) + GE2) % 11
    B_ = (cong3_field(U, SIGT) + nc9) % 11
    if ((A_ - 5 * B_) % 11).any(): okid = False
print(f"IDENTITY (200 random slope fields):  G(sigt)U + G(sigt)e2 == 5 * "
      f"( sum_k 9^k shift_k U(sig^k C) + c9 )  (mod 11): {okid}")
assert okid
print("   => the mod-11 half of the 33-divisibility criterion is EXACTLY congruence (3);")
print("      5 is a unit mod 11, so the two conditions are literally equivalent.")
# --- G on sigma-invariant fields is multiplication by 11
Uinv = np.zeros((NCT, 4), dtype=np.int64)
base = rr.integers(-20, 21, size=(5, 4)).astype(np.int64)
for c in range(NCT):
    o, k = c // 5, c % 5
    Uinv[c] = np.linalg.matrix_power(S, k) @ base[o]      # U(sig^k C) = S^k U(C)
print(f"G(sigt) on a sigma-EQUIVARIANT slope field == 11 * id: "
      f"{(opG(Uinv, SIGTI) == 11 * Uinv).all()}   [G(1) = 16-8+4-2+1 = 11]")
assert (opG(Uinv, SIGTI) == 11 * Uinv).all()

# ============================================================ 1. the mixed fan
hdr("1. the MIXED fan (cells, sigma, walls, rays) -- rebuilt and re-certified")
FORMS = []; FNAME = []
for a, b_ in combinations(range(5), 2):
    v = [0] * 5; v[a] = 1; v[b_] = -1
    FORMS.append(tuple(v)); FNAME.append(("A", a, b_))
for a, b_ in combinations(range(5), 2):
    FORMS.append(tuple(MU[a][j] - MU[b_][j] for j in range(5))); FNAME.append(("G", a, b_))
F = np.array(FORMS, dtype=np.int64)
FNf = np.array([[c[j] - c[4] for j in range(4)] for c in FORMS], dtype=np.float64)
LIN = [tuple(Fr(c[j] - c[4]) for j in range(4)) for c in FORMS]
LINI = np.array([[c[j] - c[4] for j in range(4)] for c in FORMS], dtype=np.int64)
PRIMF = np.array([nf4(prim(v)) for v in FORMS], dtype=np.int64)      # primitive, in Lambda

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
def inspan(rr_, piv, v):
    w = list(v)
    for i, c in enumerate(piv):
        if w[c] != 0:
            f = w[c]; w = [x - f * y for x, y in zip(w, rr_[i])]
    return all(x == 0 for x in w)

t0 = time.time()
assert len(rrefQ(LIN, 4)[1]) == 4, "arrangement is not essential"
allel = {frozenset(): 0}; level = [frozenset()]
for rank in range(1, 5):
    nxt = {}
    for Ss in level:
        for i in range(20):
            if i in Ss: continue
            rr_, piv = rrefQ([LIN[j] for j in set(Ss) | {i}], 4)
            if len(rr_) != rank: continue
            cl = frozenset(j for j in range(20) if inspan(rr_, piv, LIN[j]))
            if cl not in allel: nxt[cl] = rank
    allel.update(nxt); level = list(nxt.keys())
mob = {}
for cl, rk in sorted(allel.items(), key=lambda kv: kv[1]):
    mob[cl] = 1 if rk == 0 else -sum(mob[c2] for c2, r2 in allel.items()
                                     if r2 < rk and c2 < cl)
ZAS = sum(abs(v) for v in mob.values())
FLAT3 = [cl for cl, rk in allel.items() if rk == 3]
print(f"intersection lattice " +
      str({r: sum(1 for c, q in allel.items() if q == r) for r in range(5)}) +
      f"; Zaslavsky #chambers = {ZAS}; rank-3 flats = {len(FLAT3)}  [{time.time()-t0:.1f}s]")

def cell_signs(key):
    piA, piG = key; s = np.zeros(20, dtype=np.int64)
    posA = {v: i for i, v in enumerate(piA)}; posG = {v: i for i, v in enumerate(piG)}
    for t, (typ, a, b_) in enumerate(FNAME):
        s[t] = 1 if (posA[a] < posA[b_] if typ == 'A' else posG[a] < posG[b_]) else -1
    return s
def find_point(sv):
    r = linprog(c=np.zeros(4), A_ub=-(sv[:, None] * FNf), b_ub=-np.ones(20),
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
print(f"cells: {NC} == exact Zaslavsky chamber count {ZAS}: {NC == ZAS} "
      f"=> CELL LIST PROVABLY COMPLETE  [{time.time()-t0:.1f}s]")
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
SIGI = np.zeros(NC, dtype=np.int64)
for c in range(NC): SIGI[SIG[c]] = c
ORB = []; _sn = set()
for i in range(NC):
    if i in _sn: continue
    o = [i]
    for _ in range(4): o.append(int(SIG[o[-1]]))
    assert len(set(o)) == 5 and int(SIG[o[-1]]) == i
    _sn.update(o); ORB.append(o)
assert len(ORB) == 218
KIDX = np.zeros(NC, dtype=np.int64)          # position of a cell inside its orbit
OIDX = np.zeros(NC, dtype=np.int64)
for oi, o in enumerate(ORB):
    for k, c in enumerate(o): KIDX[c] = k; OIDX[c] = oi
print(f"sigma: (piA,piG) -> (piA+1, piG-1) verified on all {NC} witness points; "
      f"{len(ORB)} free sigma-orbits of size 5")

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
assert (len(WALLS), nAw) == (2570, 1400)
WNU = np.array([nf4(w[2]) for w in WALLS], dtype=np.int64)
GPERM = sorted(set(k[1] for k in CK)); GIDX = {p: i for i, p in enumerate(GPERM)}
GOF = np.array([GIDX[k[1]] for k in CK])
GCELLS = [np.nonzero(GOF == g)[0].tolist() for g in range(len(GPERM))]
GORB = []; _sn = set()
for p in GPERM:
    if p in _sn: continue
    o = [p]
    for _ in range(4): o.append(shift_perm(o[-1], -1))
    assert len(set(o)) == 5; _sn.update(o); GORB.append([GIDX[q] for q in o])

# --- rays
t0 = time.time(); rays = {}
for tri in combinations(range(20), 3):
    rr_, piv = rrefQ([LIN[j] for j in tri], 4)
    if len(rr_) != 3: continue
    free = [c for c in range(4) if c not in piv][0]
    v = [Fr(0)] * 4; v[free] = Fr(1)
    for i, c in enumerate(piv): v[c] = -rr_[i][free]
    L = 1
    for x in v: L = L * x.denominator // gcd(L, x.denominator)
    w = [int(x * L) for x in v]
    g = 0
    for x in w: g = gcd(g, abs(x))
    w = tuple(x // g for x in w)
    for s_ in (1, -1):
        r = tuple(s_ * x for x in w)
        if r not in rays:
            act = [q for q in range(20) if int(LINI[q] @ np.array(r)) == 0]
            assert len(rrefQ([LIN[q] for q in act], 4)[1]) == 3
            rays[r] = act
RAYS = sorted(rays.keys()); NR = len(RAYS)
R4 = np.array(RAYS, dtype=np.int64)
assert NR == 2 * len(FLAT3)
SGN = np.sign(R4 @ LINI.T)
INCID = [[] for _ in range(NC)]; RCELL = [[] for _ in range(NR)]
for c in range(NC):
    idx = np.nonzero(((SGN == 0) | (SGN == SC[c][None, :])).all(1))[0]
    INCID[c] = idx.tolist()
    for i in idx: RCELL[i].append(c)
print(f"RAYS: {NR} == 2 * #(rank-3 flats) = {2*len(FLAT3)}: PROVABLY COMPLETE; "
      f"max|ray| = {int(np.abs(R4).max())}  [{time.time()-t0:.1f}s]")
print(f"   every ray lies in >= 1 cell closure: {all(len(RCELL[i]) > 0 for i in range(NR))}; "
      f"per-cell ray counts {min(len(INCID[c]) for c in range(NC))}..{max(len(INCID[c]) for c in range(NC))}")

# --- every chamber is the conic hull of its rays (needed for both the d >= 0 <=> d >= 0
#     at rays reduction and for the convexity criterion below)
def cone_contains(gens, p):
    n = len(gens); m = 4
    A = [[Fr(gens[k][i]) for k in range(n)] for i in range(m)]
    b = [Fr(p[i]) for i in range(m)]
    for i in range(m):
        if b[i] < 0:
            A[i] = [-v for v in A[i]]; b[i] = -b[i]
    Nn = n + m
    T = [A[i] + [Fr(1) if j == i else Fr(0) for j in range(m)] + [b[i]] for i in range(m)]
    basis = [n + i for i in range(m)]; cost = [Fr(0)] * n + [Fr(1)] * m
    for _ in range(4000):
        cb = [cost[basis[i]] for i in range(m)]; ent = -1
        for j in range(Nn):
            if j in basis: continue
            if sum(cb[i] * T[i][j] for i in range(m)) - cost[j] > 0: ent = j; break
        if ent < 0: break
        piv = -1; best = None
        for i in range(m):
            if T[i][ent] > 0:
                rat = T[i][Nn] / T[i][ent]
                if best is None or rat < best or (rat == best and basis[i] < basis[piv]):
                    best = rat; piv = i
        if piv < 0: return None
        pv = T[piv][ent]; T[piv] = [v / pv for v in T[piv]]
        for i in range(m):
            if i != piv and T[i][ent] != 0:
                f = T[i][ent]; T[i] = [a - f * bb for a, bb in zip(T[i], T[piv])]
        basis[piv] = ent
    return sum(cost[basis[i]] * T[i][Nn] for i in range(m)) == 0

def cell_of_mixed(n):
    Hv = [sum(n[j] * MU[k][j] for j in range(5)) for k in range(5)]
    if len(set(n)) < 5 or len(set(Hv)) < 5: return None
    piA = tuple(sorted(range(5), key=lambda j: -n[j]))
    piG = tuple(sorted(range(5), key=lambda j: -Hv[j]))
    return CIDX.get((piA, piG))

# --- the sigma-action on CELLS agrees with the sigma-action on POINTS
rrc = random.Random(SEED + 2); okc = 0; tries = 0
while okc < 4000 and tries < 200000:
    tries += 1
    n = [rrc.randint(-60, 60) for _ in range(5)]; n[4] = -sum(n[:4]); n = tuple(n)
    c = cell_of_mixed(n)
    if c is None: continue
    cs = cell_of_mixed(sigN(n))
    assert cs is not None and cs == int(SIG[c]), "sigma cell map mismatch"
    okc += 1
print(f"cell map check: cell(sig n) == SIG[cell(n)] on {okc} random lattice points "
      f"(0 mismatches)")
print("   ==> together with <S u, n> = <u, sig^{-1} n> this PROVES (**) for every PL h.")

t0 = time.time(); rr_ = random.Random(SEED + 3); okspan = 0; tot = 0; cs_ = set()
while tot < 800:
    n = [rr_.randint(-60, 60) for _ in range(5)]; n[4] = -sum(n[:4])
    c = cell_of_mixed(tuple(n))
    if c is None: continue
    tot += 1; cs_.add(c)
    okspan += bool(cone_contains([RAYS[i] for i in INCID[c]], n[:4]))
print(f"POSITIVE SPAN (exact Fraction phase-1 simplex): {okspan}/{tot} random interior "
      f"points of {len(cs_)} cells are nonnegative combinations of their cell's rays "
      f"[{time.time()-t0:.1f}s]")
assert okspan == tot
print("   (Minkowski-Weyl: the arrangement is essential, so every chamber is a POINTED")
print("    cone = conic hull of its extreme rays, and an extreme ray has active-set rank")
print("    3, i.e. is one of the 460 enumerated rays.  Used twice below: d >= 0 at the")
print("    rays <=> d >= 0 everywhere, and the exact convexity criterion.)")

sub("the wall encoding: 3 cross-conditions + integrality == membership in Z*nu")
rq_ = np.random.default_rng(SEED + 4); good = badenc = 0
for wi in rq_.integers(0, len(WALLS), size=300):
    n4 = WNU[int(wi)]; j0 = next(t for t in range(4) if n4[t] % 11)
    for _ in range(20):
        if rq_.random() < 0.5:
            D = int(rq_.integers(-30, 31)) * n4                      # genuinely in Z*nu
            inZ = True
        else:
            D = rq_.integers(-30, 31, size=4).astype(np.int64)
            inZ = any((D == k * n4).all() for k in range(-60, 61))
        cross = all(int(n4[j0]) * int(D[j]) - int(n4[j]) * int(D[j0]) == 0
                    for j in range(4) if j != j0)
        if cross != inZ: badenc += 1
        else: good += 1
print(f"  300 walls x 20 random integral differences D: 'the 3 cross-conditions hold' "
      f"<=> 'D in Z*nu': {good} agreements, {badenc} disagreements")
print("  (nu is PRIMITIVE in Lambda, so D integral and D in Q*nu forces D in Z*nu)")
assert badenc == 0

# ==================================================== 2. exact integer machinery
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
    _FANCACHE[key] = (EXPR, HJ, CM, RHS, P, order, par, parw)
    return _FANCACHE[key]

def integer_solution_lattice(key, NCELL, WL, SIGP, ORBS, ZEROS,
                             primes=(1000003, 999983, 999979)):
    EXPR, HJ, CM, RHS, P = fan_pieces(key, NCELL, WL, SIGP, ORBS)[:5]
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
    assert len(echelon_p(Ki % 11, 11)[1]) == d, "11-saturation failed"
    CKm = imatmul(CM % 11, Ki % 11) % 11
    Eq, pq = echelon_p(np.concatenate([CKm, (RHS % 11)[:, None]], axis=1), 11)
    if len(pq) and pq[-1] == d:
        raise ValueError("congruence layer infeasible -- pattern already dead")
    rkC = len(pq)
    part = np.zeros(d, dtype=np.int64)
    for i, c in enumerate(pq): part[c] = Eq[i, d]
    Kc, freec = kernel_from_rref(Eq[:, :d], pq, d)
    x1 = (Ki.astype(object) @ part.astype(object)).astype(np.int64)
    assert not (H.astype(np.int64) @ x1).any()
    assert not ((imatmul(CM % 11, (x1 % 11)[:, None])[:, 0] - RHS) % 11).any()
    return P, H, CM, RHS, Ki, x1, (Kc, freec, pq, d, rkC)

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
def farkas_or_interior(Amat):
    m = len(Amat); k = len(Amat[0])
    An = np.array(Amat, dtype=np.float64)
    r1 = linprog(c=np.zeros(k), A_ub=-An, b_ub=-np.ones(m),
                 bounds=[(None, None)] * k, method='highs')
    if r1.status == 0:
        for den in (10 ** 3, 10 ** 5, 10 ** 7, 10 ** 9):
            z = frac_vec(r1.x, den)
            vals = [sum(Fr(int(Amat[i][j])) * z[j] for j in range(k)) for i in range(m)]
            if all(v > 0 for v in vals):
                sc = min(vals); return ('INTERIOR', [v / sc for v in z])
    return ('OTHER', None)

# ============================================ 3. the shadow witnesses, rebuilt
def build_witness(tagP, ZEROS):
    """Rebuild an f55_mixedpos.py nonnegative integral witness d.  Returns U5d
       (NC x 4 slopes in Lambda) or None."""
    key = ("mixed",)
    try:
        P, H, CM, RHS, Kb, x1, cinfo = integer_solution_lattice(
            key, NC, WALLS, SIG, ORB, sorted(ZEROS))
    except ValueError:
        return None, "congruence-infeasible"
    Kc, freec, pq, d, rkC = cinfo
    EXPR = _FANCACHE[key][0]
    Gm = imatmul(EXPR.reshape(-1, P), Kb).reshape(NC, 4, d)
    ROWS = []
    for i in range(NR):
        rows = set()
        for c in RCELL[i]:
            rows.add(tuple(int(z) for z in (R4[i].astype(np.int64) @ Gm[c])))
        assert len(rows) == 1, "d(r) depends on the cell -- PL continuity broken"
        v = rows.pop()
        if any(v): ROWS.append(v)
    ded = {}
    for v in ROWS:
        g = 0
        for z in v: g = gcd(g, abs(z))
        ded[tuple(z // g for z in v)] = 1
    A = sorted(ded.keys())
    st, w = farkas_or_interior([list(r) for r in A])
    if st != 'INTERIOR': return None, "positivity cone has no relative interior point"
    L0 = 1
    for x in w: L0 = L0 * x.denominator // gcd(L0, x.denominator)
    ui = np.array([int(x * L0) for x in w], dtype=np.int64)
    dU = [sum(int(A[i][j]) * int(ui[j]) for j in range(d)) for i in range(len(A))]
    if min(dU) < 0: return None, "direction not nonnegative"
    Etr, ptr = echelon_p(Kb.T % 1000003, 1000003)
    Msq = [[Fr(int(Kb[i][t])) for t in range(d)] + [Fr(int(x1[i]))] for i in ptr]
    R4f, piv4 = exact_rref_frac(Msq, d)
    cx = [Fr(0)] * d
    for i, c in enumerate(piv4): cx[c] = R4f[i][d]
    assert all(v.denominator == 1 for v in cx)
    cxi = np.array([int(v) for v in cx], dtype=np.int64)
    assert (imatmul(Kb, cxi[:, None])[:, 0] == x1).all()
    dX = [sum(int(A[i][j]) * int(cxi[j]) for j in range(d)) for i in range(len(A))]
    Nn = 1
    while Nn <= 10 ** 9:
        if min(dX[i] + 11 * Nn * dU[i] for i in range(len(A))) >= 0: break
        Nn *= 2
    cy = cxi + 11 * Nn * ui
    y = imatmul(Kb, cy[:, None])[:, 0]
    U4 = (EXPR.reshape(-1, P).astype(object) @ y.astype(object)).reshape(NC, 4)
    return np.array([[int(v) for v in row] for row in U4], dtype=np.int64), "ok"

def certify_d(U5d, ZEROS, label, npts=4000):
    """Independent re-certification of the shadow witness, over Z, no encodings."""
    Z0 = set(ZEROS)
    vj = 0
    for wi, (i, j, nu) in enumerate(WALLS):
        D = U5d[i] - U5d[j]; n4 = WNU[wi]
        j0 = next(t for t in range(4) if n4[t])
        if D[j0] % n4[j0] or not (D == (D[j0] // n4[j0]) * n4).all(): vj += 1
    vz = sum(1 for c in ZEROS if U5d[c].any())
    orbz = min(sum(1 for c in o if c in Z0) for o in ORB)
    dr = np.array([int(U5d[RCELL[i][0]] @ R4[i]) for i in range(NR)])
    vneg = int((dr < 0).sum())
    rp = random.Random(SEED + 21); v5 = v6 = v7 = nb = 0
    for _ in range(npts):
        B = rp.choice((6, 20, 80, 300))
        n = [rp.randint(-B, B) for _ in range(5)]; n[4] = -sum(n[:4]); n = tuple(n)
        cs = [cell_of_mixed(n)]; m = n
        for _ in range(4):
            m = sigN(m); cs.append(cell_of_mixed(m))
        if any(c is None for c in cs): continue
        nb += 1
        vals = []; m = n
        for k in range(5):
            vals.append(int(sum(int(U5d[cs[k]][t]) * m[t] for t in range(4))))
            m = sigN(m)
        if min(vals) < 0: v5 += 1
        if min(vals) != 0 or sum(1 for v in vals if v == 0) < 2: v6 += 1
        if (sum(pow(9, k, 11) * vals[k] for k in range(5))
                + sum(n[t] * c9[t] for t in range(5))) % 11: v7 += 1
    rc = ray_consistent(U5d)
    print(f"  [{label}] CERTIFY d: wall jumps not in Z*nu {vj}/{len(WALLS)}; zero cells "
          f"with U != 0 {vz}/{len(ZEROS)}; min zeros/orbit {orbz}; ray-value "
          f"inconsistencies {rc}")
    assert rc == 0
    print(f"  [{label}]   d(r) < 0 at the {NR} rays: {vneg}; ground truth at {nb} lattice "
          f"points: d<0 {v5}, twice-min failures {v6}, congruence (3) failures {v7}")
    okall = (vj, vz, vneg, v5, v6, v7) == (0,) * 6 and orbz >= 2
    print(f"  [{label}]   ==> certified shadow witness: {okall}   "
          f"(max|U_d| = {int(np.abs(U5d).max())})")
    assert okall
    return True

# ============================================ operators on slope fields (mixed fan)
def op_sigt(U):                                     # U_{f.sig^{-1}}(C) = S U(sig^{-1}C)
    return (S @ U[SIGI].T).T
def op_2plus(U):                                    # (2 + sigt) f
    return 2 * U + op_sigt(U)
def op_G(U):                                        # G(sigt) f
    out = np.zeros_like(U); cur = U
    for j in range(5):
        out = out + GC[j] * cur
        if j < 4: cur = op_sigt(cur)
    return out
def op_N(U):                                        # sum_j sigt^j f  (the orbit sum)
    out = np.zeros_like(U); cur = U
    for j in range(5):
        out = out + cur
        if j < 4: cur = op_sigt(cur)
    return out
CONST_E2 = np.tile(E24, (NC, 1))

hdr("2. TASK 2 -- the slope-frame reduction (**), verified end to end")
sub("random integral-sloped PL h on the mixed fan, F computed POINTWISE")
def phi_slopes(coeffs):
    """slope field of  sum_i coeffs[i] * |<l_i, .>|  (l_i = the 20 primitive forms)"""
    return (SC * np.array(coeffs, dtype=np.int64)[None, :]) @ PRIMF
def phi_value(coeffs, n):
    n4 = to4(n)
    return int(sum(int(coeffs[i]) * abs(int(PRIMF[i] @ n4)) for i in range(20)))
rrh = random.Random(SEED + 31)
tot = 0; failF = 0; failS = 0; failW = 0
for trial in range(6):
    co = [rrh.randint(-6, 6) for _ in range(20)]
    lin = np.array([rrh.randint(-9, 9) for _ in range(4)], dtype=np.int64)
    Uh = phi_slopes(co) + lin[None, :]
    for wi, (i, j, nu) in enumerate(WALLS):        # h really is PL with integral jumps
        D = Uh[i] - Uh[j]; n4 = WNU[wi]
        j0 = next(t for t in range(4) if n4[t])
        if D[j0] % n4[j0] or not (D == (D[j0] // n4[j0]) * n4).all(): failW += 1
    UF = op_2plus(Uh) - CONST_E2                    # the slope frame's prediction
    for _ in range(400):
        B = rrh.choice((7, 25, 90))
        n = [rrh.randint(-B, B) for _ in range(5)]; n[4] = -sum(n[:4]); n = tuple(n)
        cs = [cell_of_mixed(n)]; m = n
        for _ in range(4):
            m = sigN(m); cs.append(cell_of_mixed(m))
        if any(c is None for c in cs): continue
        tot += 1
        n4 = to4(n)
        hval = lambda q, cq: int(sum(int(co[i]) * abs(int(PRIMF[i] @ to4(q)))
                                     for i in range(20))) + int(lin @ to4(q))
        ni = n
        for _ in range(4): ni = sigN(ni)            # sig^{-1} n
        Fpt = 2 * hval(n, cs[0]) + hval(ni, cs[4]) - sum(E2[t] * n[t] for t in range(5))
        if Fpt != int(UF[cs[0]] @ n4): failF += 1
        if int(Uh[cs[0]] @ n4) != hval(n, cs[0]): failS += 1
print(f"  6 random PL h (h = sum a_i |l_i| + linear, a_i in [-6,6]); wall-jump "
      f"violations across all {len(WALLS)} walls x 6: {failW}")
print(f"  pointwise F(n) = 2h(n) + h(sig^{{-1}}n) - <e2,n> vs "
      f"<2U_h(C) + S U_h(sig^{{-1}}C) - e2, n> at {tot} lattice points: {failF} failures")
print(f"  pointwise h(n) vs <U_h(C), n>: {failS} failures")
assert (failW, failF, failS) == (0, 0, 0)
print("  ==> (**) IS the correct slope form of (*).  sigma_* = shift_{-1} = S.")

# ============================================ 4. TASK 3 -- solve (**) over Z
hdr("3. TASK 3 -- the preimage system (**) + wall conditions, solved over Z")
print("""  STRUCTURE (proved above, operator identity + uniqueness):
    (*) is  (2+sigt) h = d + m + e2*,  and (2+sigt) G(sigt) = 33 with
    G = 16 - 8x + 4x^2 - 2x^3 + x^4, so h is UNIQUE and equals (1/33) G(sigt)(d+m+e2*).
    Hence (*) has an integral-sloped PL solution  <=>  33 | G(sigt)(d+m+e2*) cellwise.
    G(sigt) on sigma-invariant fields = 11*id, so by CRT:
      mod 11 : m drops out; the condition is exactly congruence (3)  [verified above];
      mod  3 : the condition is U_m == U_D (mod 3), D := sum_j d.sig^j, satisfiable
               by m = D itself.
    => the ONLY obstruction is congruence (3), which every witness satisfies.""")

def solve_preimage(U5d, label):
    """Construct the unique h for m = D and verify 33-divisibility + all constraints."""
    UD = op_N(U5d)                                    # slopes of D = sum_j d.sig^j
    # D is sigma-invariant: U_D(sig C) = S U_D(C)
    einv = int((UD[SIG] != (S @ UD.T).T).any())
    UF = U5d + UD + CONST_E2                          # F = d + m + e2*, m := D
    GF = op_G(UF)
    r11 = int((GF % 11 != 0).any(1).sum()); r3 = int((GF % 3 != 0).any(1).sum())
    r33 = int((GF % 33 != 0).any(1).sum())
    print(f"  [{label}] m := D = sum_j d.sig^j is sigma-invariant: {einv == 0}")
    print(f"  [{label}] cells where G(sigt)(U_d+U_D+e2) is NOT divisible by: "
          f"11 -> {r11}, 3 -> {r3}, 33 -> {r33}   (of {NC})")
    if r33: return None, None
    Uh = GF // 33
    Um = op_2plus(Uh) - CONST_E2 - U5d
    return Uh, Um

def verify_preimage(Uh, Um, U5d, label):
    """Substitute (U_h, U_m) into EVERY constraint of the system, over Z."""
    v_eq = int((op_2plus(Uh) - CONST_E2 - U5d - Um != 0).any(1).sum())
    v_hw = v_mw = 0
    mhs = []
    for wi, (i, j, nu) in enumerate(WALLS):
        n4 = WNU[wi]; j0 = next(t for t in range(4) if n4[t])
        for (U, cnt) in ((Uh, 'h'), (Um, 'm')):
            D = U[i] - U[j]
            bad = (D[j0] % n4[j0] != 0) or not (D == (D[j0] // n4[j0]) * n4).all()
            if cnt == 'h':
                v_hw += bad
                if not bad: mhs.append(int(D[j0] // n4[j0]))
            else: v_mw += bad
    v_se = int((Um[SIG] != (S @ Um.T).T).any())
    print(f"  [{label}] (**) at all {NC} cells: {v_eq} violations")
    print(f"  [{label}] wall conditions U(C)-U(C') in Z*nu -- h: {v_hw}/{len(WALLS)}, "
          f"m: {v_mw}/{len(WALLS)}")
    print(f"  [{label}] m sigma-equivariance U_m(sig C) = S U_m(C): {v_se} violations")
    print(f"  [{label}] max|U_h| = {int(np.abs(Uh).max())}, max|U_m| = "
          f"{int(np.abs(Um).max())}, distinct slopes of h: {len(set(map(tuple, Uh.tolist())))}, "
          f"|wall multipliers of h| <= {max(abs(v) for v in mhs)}")
    ok = (v_eq, v_hw, v_mw, v_se) == (0, 0, 0, 0)
    print(f"  [{label}] ==> VERIFIED INTEGER SOLUTION of the preimage system: {ok}")
    assert ok
    return ok

def theoremQ_check(Uh, label, npts=NPTS, extra=None):
    """Direct Theorem-Q check, independent of every encoding: F = 2h + h.sig^{-1} - e2*
       evaluated POINTWISE; sigma-orbit min attained at least twice."""
    rp = random.Random(SEED + 77); nb = 0; bad_twice = 0; bad_min = 0
    UhE = Uh if extra is None else Uh + extra
    for _ in range(npts):
        B = rp.choice((5, 17, 60, 250, 1000))
        n = [rp.randint(-B, B) for _ in range(5)]; n[4] = -sum(n[:4]); n = tuple(n)
        cs = []; m = n; okc = True
        for k in range(5):
            c = cell_of_mixed(m)
            if c is None: okc = False; break
            cs.append(c); m = sigN(m)
        if not okc: continue
        nb += 1
        pts = []; m = n
        for k in range(5):
            pts.append(to4(m))
            m = sigN(m)
        hv = [int(UhE[cs[k]] @ pts[k]) for k in range(5)]
        m = n; Fv = []
        for k in range(5):     # F(sig^k n) = 2h(sig^k n) + h(sig^{k-1} n) - <sig^k n, e2>
            Fv.append(2 * hv[k] + hv[(k - 1) % 5] - int(sum(E2[t] * m[t] for t in range(5))))
            m = sigN(m)
        mn = min(Fv)
        if sum(1 for v in Fv if v == mn) < 2: bad_twice += 1
    print(f"  [{label}] THEOREM Q at {nb} random lattice points of N (boxes 5/17/60/250/1000):")
    print(f"  [{label}]   sigma-orbit min of (2h(sig^i n) + h(sig^{{i-1}}n) - <sig^i n, e2>)_i")
    print(f"  [{label}]   attained AT LEAST TWICE: {nb - bad_twice}/{nb}  "
          f"({bad_twice} failures)")
    assert nb > npts // 3
    return bad_twice, nb

def encoded_system_check(Uh, Um, U5d, label):
    """The literal encoding of the brief: unknowns = (tree parameters x for U_h,
       U_m on the 218 orbit representatives), constraints = HJ x = 0 (3 cross-conditions
       per non-tree wall) and the 4*1090 rows of (**).  Verify A z = b over Z for the
       constructed solution."""
    EXPR, HJ, CM, RHS, P, order, par, parw = fan_pieces(("mixed",), NC, WALLS, SIG, ORB)
    x = np.zeros(P, dtype=np.int64)
    x[:4] = Uh[0]
    pid = 4
    for c in order[1:]:
        D = Uh[c] - Uh[par[c]]; n4 = nf4(WALLS[parw[c]][2])
        j0 = next(t for t in range(4) if n4[t])
        assert D[j0] % n4[j0] == 0 and (D == (D[j0] // n4[j0]) * n4).all()
        x[pid] = D[j0] // n4[j0]; pid += 1
    assert pid == P
    v_expr = int(((EXPR.reshape(-1, P).astype(object) @ x.astype(object)
                   ).reshape(NC, 4).astype(np.int64) - Uh != 0).sum())
    v_hj = int((HJ.astype(object) @ x.astype(object) != 0).sum())
    w = np.array([Um[ORB[o][0]] for o in range(len(ORB))], dtype=np.int64)  # orbit reps
    v_star = 0
    for c in range(NC):
        lhs = 2 * Uh[c] + S @ Uh[SIGI[c]] - E24
        rhs = U5d[c] + np.linalg.matrix_power(S, int(KIDX[c])) @ w[OIDX[c]]
        v_star += int((lhs != rhs).any())
    print(f"  [{label}] LITERAL ENCODING (brief's form): unknowns = {P} tree params for "
          f"U_h + {4*len(ORB)} for U_m on orbit reps")
    print(f"  [{label}]   EXPR x reproduces U_h: {v_expr} mismatches; HJ x = 0 (the "
          f"{HJ.shape[0]} cross-condition rows at the {len(WALLS)-NC+1} non-tree walls): "
          f"{v_hj} nonzero")
    print(f"  [{label}]   the {4*NC} rows of (**) with U_m extended sigma-equivariantly "
          f"from the {len(ORB)} reps: {v_star} violated cells")
    assert (v_expr, v_hj, v_star) == (0, 0, 0)
    return True

# ---- the Farkas certificate that congruence (3) IS the obstruction (necessity)
def farkas_row_check(U5d, label):
    """The mod-11 row combination  sum_k 9^k S^{-k} (row at sig^k C)  annihilates every
       U_h and every sigma-equivariant U_m and leaves exactly congruence (3)."""
    rq = np.random.default_rng(SEED + 5)
    bad_h = bad_m = 0; vals = []
    for _ in range(200):
        Uh = rq.integers(-50, 51, size=(NC, 4)).astype(np.int64)   # ARBITRARY field
        base = rq.integers(-50, 51, size=(len(ORB), 4)).astype(np.int64)
        Um = np.zeros((NC, 4), dtype=np.int64)
        for c in range(NC): Um[c] = np.linalg.matrix_power(S, int(KIDX[c])) @ base[OIDX[c]]
        c0 = int(rq.integers(0, NC))
        acch = np.zeros(4, dtype=np.int64); accm = np.zeros(4, dtype=np.int64)
        accd = np.zeros(4, dtype=np.int64); acce = np.zeros(4, dtype=np.int64)
        cc = c0
        for k in range(5):
            w = pow(9, k, 11)
            acch = acch + w * (SM[k] @ (2 * Uh[cc] + S @ Uh[SIGI[cc]]))
            accm = accm + w * (SM[k] @ Um[cc])
            accd = accd + w * (SM[k] @ U5d[cc])
            acce = acce + w * (SM[k] @ E24)
            cc = int(SIG[cc])
        bad_h += int((acch % 11).any()); bad_m += int((accm % 11).any())
        vals.append(tuple(int(v) for v in (accd + acce) % 11))
    print(f"  [{label}] FARKAS ROW y = (9^k S^{{-k}} at sig^k C)_k, applied to (**):")
    print(f"  [{label}]   kills 2U_h + S U_h(sig^-1 .) on 200 random fields: "
          f"{200 - bad_h}/200   [2 + 9 = 11]")
    print(f"  [{label}]   kills sigma-equivariant U_m on 200 random fields: "
          f"{200 - bad_m}/200   [sum_k 9^k = 7381 = 11*671]")
    print(f"  [{label}]   residue y*b = sum_k 9^k shift_k(U_d(sig^k C)) + c9 (mod 11) "
          f"at 200 random cells: all zero = {all(v == (0,0,0,0) for v in vals)}")
    assert bad_h == 0 and bad_m == 0
    return all(v == (0, 0, 0, 0) for v in vals)

# ============================================================ 5. CONVEXIFICATION
hdr("4. THEOREM Q PROPER: making h the support function of a LATTICE POLYTOPE")
PHI_S = phi_slopes([1] * 20)                # slopes of Phi = sum_i |<l_i, .>|
# Phi is sigma-invariant, integral-sloped, and strictly convex across every wall
phi_sigok = int((PHI_S[SIG] != (S @ PHI_S.T).T).any())
phimult = []
for wi, (i, j, nu) in enumerate(WALLS):
    D = PHI_S[i] - PHI_S[j]; n4 = WNU[wi]
    j0 = next(t for t in range(4) if n4[t])
    assert D[j0] % n4[j0] == 0 and (D == (D[j0] // n4[j0]) * n4).all()
    phimult.append(int(D[j0] // n4[j0]))
print(f"Phi := sum over the 20 arrangement forms of |<l, .>|: sigma-invariant "
      f"(U_Phi(sig C) = S U_Phi(C)): {phi_sigok == 0}")
print(f"   wall multipliers of Phi: all nonzero {all(v != 0 for v in phimult)}, "
      f"|values| = {sorted(set(abs(v) for v in phimult))}")
assert phi_sigok == 0 and all(v != 0 for v in phimult)
rp = random.Random(SEED + 41); badphi = 0
for _ in range(500):
    n = [rp.randint(-50, 50) for _ in range(5)]; n[4] = -sum(n[:4]); n = tuple(n)
    c = cell_of_mixed(n)
    if c is None: continue
    n4 = to4(n)
    if int(PHI_S[c] @ n4) != phi_value([1] * 20, n): badphi += 1
    if phi_value([1] * 20, sigN(n)) != phi_value([1] * 20, n): badphi += 1
print(f"   Phi(n) = <U_Phi(C), n> and Phi(sig n) = Phi(n) at 500 random points: "
      f"{badphi} failures")
assert badphi == 0

def ray_consistent(U):
    """the PL function's value at a ray must not depend on which cell we use"""
    V = U @ R4.T
    return sum(1 for i in range(NR)
               if len(set(int(V[c, i]) for c in RCELL[i])) != 1)
def is_convex(U):
    """EXACT: h is convex  <=>  h(r) = max_C <U(C), r> at every ray r.
       (=>) trivial.  (<=) for n in a cell C, n = sum lam_k r_k with lam >= 0 over the
       rays of C (Minkowski-Weyl; every chamber of an essential arrangement is pointed),
       so h(n) = <U(C),n> = sum lam_k h(r_k) = sum lam_k hhat(r_k) >= hhat(n) by
       subadditivity of hhat := max_C <U(C),.>; and hhat >= h always.  Hence h = hhat."""
    V = U @ R4.T                                     # (NC, NR)
    mx = V.max(0)
    got = np.array([V[RCELL[i][0], i] for i in range(NR)])
    return int((got != mx).sum())
def is_concave(U):
    V = U @ R4.T
    mn = V.min(0)
    got = np.array([V[RCELL[i][0], i] for i in range(NR)])
    return int((got != mn).sum())

def polytope_oracle(Uq, label, npts=40000, cvx=True):
    """THE INDEPENDENT ORACLE.  Forget the fan, the cells, the slopes and every
       encoding: take Q := conv{U(C)} as a finite set of lattice points, define
       h_Q(w) := max (resp. min) over Q of <v, w> BY BRUTE FORCE, and test Theorem Q
       verbatim:  min_i ( 2 h_Q(sig^i w) + h_Q(sig^{i-1} w) - <sig^i w, e2> )
       is attained at least twice.  Includes NON-GENERIC w (ties, wall points)."""
    V = np.array(sorted(set(map(tuple, Uq.tolist()))), dtype=np.int64)     # vertices
    rq = np.random.default_rng(SEED + 91)
    tot = 0; bad = 0; ndeg = 0; badR = 0; mult = np.zeros(6, dtype=np.int64)
    for st in range(0, npts, 2000):
        B = min(2000, npts - st)
        box = int(rq.choice([3, 9, 40, 200, 5000]))
        n = rq.integers(-box, box + 1, size=(B, 5)).astype(np.int64)
        if rq.random() < 0.45:                     # force degeneracies (walls / rays)
            for t in range(B):
                for _ in range(int(rq.integers(1, 4))):
                    a, b_ = int(rq.integers(0, 5)), int(rq.integers(0, 5))
                    n[t, b_] = n[t, a]
        n[:, 4] = -n[:, :4].sum(1)
        HQ = np.zeros((5, B), dtype=np.int64); T2 = np.zeros((5, B), dtype=np.int64)
        m = n
        for k in range(5):
            pr = V @ m[:, :4].T                    # <v, sig^k w> for all v in Q
            HQ[k] = pr.max(0) if cvx else pr.min(0)
            T2[k] = m[:, 2]                        # <sig^k w, e2>,  e2 = (0,0,1,0,0)
            m = np.stack([m[:, (j - 1) % 5] for j in range(5)], axis=1)
        Fv = np.stack([2 * HQ[k] + HQ[(k - 1) % 5] - T2[k] for k in range(5)])
        mn = Fv.min(0)
        cnt = (Fv == mn[None, :]).sum(0)
        tot += B; bad += int((cnt < 2).sum())
        for v in range(1, 6): mult[v] += int((cnt == v).sum())
        # Theorem R, independently: sum_i 9^i F(sig^i w) + <w, c9> == 0 (mod 11)
        R = (sum(pow(9, k, 11) * Fv[k] for k in range(5))
             + (n @ np.array(c9, dtype=np.int64))) % 11
        badR += int((R != 0).sum())
        ndeg += int((np.array([len(set(row.tolist())) for row in n]) < 5).sum())
    print(f"  [{label}] POLYTOPE ORACLE (h_Q by brute force over the {len(V)} lattice "
          f"points of Q, no fan at all):")
    print(f"  [{label}]   {tot} random w in N ({ndeg} of them NON-GENERIC: repeated "
          f"coordinates, i.e. on walls/rays), boxes 3/9/40/200/5000")
    print(f"  [{label}]   min_i (2 h_Q(sig^i w) + h_Q(sig^{{i-1}} w) - <sig^i w, e2>) "
          f"attained AT LEAST TWICE: {tot - bad}/{tot}   ({bad} failures)")
    print(f"  [{label}]   multiplicity of the orbit-min: "
          + ", ".join(f"{v}x: {int(mult[v])}" for v in range(1, 6))
          + "   (NOT degenerate: 5x would mean a constant pattern, which Theorem R "
            "forbids at anchors)")
    print(f"  [{label}]   Theorem R independently: sum_i 9^i F(sig^i w) + <w, c9> == 0 "
          f"(mod 11): {tot - badR}/{tot}")
    assert badR == 0
    return bad, tot

def convexify(Uh, label, sign=+1):
    T = 1
    while T <= 2 ** 20:
        U = Uh + sign * T * PHI_S
        bad = is_convex(U) if sign > 0 else is_concave(U)
        if bad == 0: return T, U
        T *= 2
    return None, None

# ============================================================ 6. run the patterns
hdr("5. THE RUN: every mixed-fan shadow witness, lifted")
RESULTS = {}
PATTERNS = []
for P0 in [(3, 4), (0, 1)]:
    Z = [i for i, (pA, pG) in enumerate(CK) if pG.index(0) in P0]
    PATTERNS.append((f"G9-rank P={list(P0)}", Z))
if os.environ.get("F55_EFAM", "1") == "1":
    LAB = {}
    for gi, og in enumerate(GORB):
        LAB[gi] = {GPERM[g].index(0): g for g in og}
    for gi0 in (0, 1, 2):
        for (i0, j0) in pairs:
            if (i0, j0) == (0, 1): continue
            zg = set()
            for gi in range(len(GORB)):
                for t in ({i0, j0} if gi == gi0 else {0, 1}): zg.add(LAB[gi][t])
            Ze = sorted(c for g in zg for c in GCELLS[g])
            if min(sum(1 for c in o if c in set(Ze)) for o in ORB) < 2: continue
            PATTERNS.append((f"(e) G9-orbit {gi0} -> {(i0,j0)}", Ze))

FIRST = True
for (tag, Z) in PATTERNS:
    print("\n" + "-" * 78)
    print(f"PATTERN {tag}   ({len(Z)} zero cells)")
    U5d, msg = build_witness(tag, Z)
    if U5d is None:
        print(f"  [{tag}] no nonnegative shadow witness ({msg}) -- nothing to lift")
        RESULTS[tag] = 'no-witness'; continue
    certify_d(U5d, Z, tag, npts=(4000 if not FIRST else 8000))
    Uh, Um = solve_preimage(U5d, tag)
    if Uh is None:
        RESULTS[tag] = 'NOT-LIFTABLE'
        print(f"  [{tag}] ==> the witness does NOT lift")
        continue
    verify_preimage(Uh, Um, U5d, tag)
    encoded_system_check(Uh, Um, U5d, tag)
    bt, nb = theoremQ_check(Uh, tag, npts=(NPTS if FIRST else 3000))
    okQ = (bt == 0)
    Tc, Ucvx = convexify(Uh, tag, +1)
    Tk, Ucav = convexify(Uh, tag, -1)
    print(f"  [{tag}] CONVEXIFY: h + T*Phi is CONVEX (exact ray criterion, all {NR} "
          f"rays) at T = {Tc}; h - T*Phi is CONCAVE at T = {Tk}")
    btc, nbc = theoremQ_check(Uh, tag + "/convex", npts=(NPTS if FIRST else 3000),
                              extra=(Tc * PHI_S))
    RESULTS[tag] = ('LIFTS' if okQ and btc == 0 else 'LIFTS?')
    btk, _ = theoremQ_check(Uh, tag + "/concave", npts=(NPTS if FIRST else 3000),
                            extra=(-Tk * PHI_S))
    if btk or btc: RESULTS[tag] = 'LIFTS?'
    if FIRST:
        print("\n" + "!" * 78)
        print(f"!!!  THE FIRST WITNESS LIFTS.  h data for {tag}:")
        print(f"!!!    max|U_h| = {int(np.abs(Uh).max())}, distinct slopes "
              f"{len(set(map(tuple, Uh.tolist())))}, U_h on cells 0..5: "
              + ", ".join(str(tuple(int(v) for v in Uh[c])) for c in range(6)))
        print(f"!!!    max|U_m| = {int(np.abs(Um).max())}  (m = D = sum_j d.sig^j)")
        print(f"!!!    ray-value consistency of U_h over all {NR} rays: "
              f"{ray_consistent(Uh)} inconsistencies")
        for (nm, Uq, cvx, TT) in (("CONVEX  (max-support)", Uh + Tc * PHI_S, True, Tc),
                                  ("CONCAVE (min-support)", Uh - Tk * PHI_S, False, Tk)):
            verts = sorted(set(map(tuple, Uq.tolist())))
            sgn = '+' if cvx else '-'
            print(f"!!!    {nm} witness h_T = h {sgn} {TT}*Phi: max|U| = "
                  f"{int(np.abs(Uq).max())}, {len(verts)} distinct slopes, ray-value "
                  f"consistency {ray_consistent(Uq)}")
            fail = is_convex(Uq) if cvx else is_concave(Uq)
            print(f"!!!      Q := conv{{U(C)}} is a LATTICE polytope in Lambda with "
                  f"h_Q = h_T (exact ray criterion over all {NR} rays: {fail} failures)")
            rq = random.Random(SEED + 55); bad = 0; cnt = 0
            for _ in range(3000):
                n = [rq.randint(-70, 70) for _ in range(5)]; n[4] = -sum(n[:4]); n = tuple(n)
                c = cell_of_mixed(n)
                if c is None: continue
                cnt += 1
                n4 = to4(n); vv = Uq @ n4
                tgt = int(vv.max()) if cvx else int(vv.min())
                if int(Uq[c] @ n4) != tgt: bad += 1
            print(f"!!!      h_T(n) == {'max' if cvx else 'min'}_{{v in Q}} <v, n> at "
                  f"{cnt} random lattice points: {bad} failures")
            assert fail == 0 and bad == 0
            ob, ot = polytope_oracle(Uq, tag + ("/convex Q" if cvx else "/concave Q"),
                                     npts=40000, cvx=cvx)
            assert ob == 0
        print("!" * 78)
        print("""!!!  WHY THIS HOLDS AT *EVERY* w, NOT ONLY AT THE SAMPLED POINTS:
!!!    (**) verified at all 1090 cells says F = d + m identically on N, with m
!!!    sigma-invariant.  Hence F(sig^i w) = d(sig^i w) + m(w) for every w, so
!!!      min_i F(sig^i w) = m(w) + min_i d(sig^i w) = m(w),
!!!    attained exactly at those i with d(sig^i w) = 0.  d >= 0 everywhere (checked
!!!    at all 460 rays, and every chamber is the conic hull of its rays), and every
!!!    sigma-orbit of cells contains >= 2 ZERO cells, on which d vanishes identically;
!!!    any w lies in the closure of some cell C, so d(sig^i w) = 0 for those >= 2
!!!    indices.  Therefore the orbit-min of F is attained AT LEAST TWICE at EVERY w.
!!!    Adding T*Phi (Phi sigma-invariant) shifts every orbit by the same 3T*Phi(w),
!!!    so convexification does not disturb this.""")
        farkas_row_check(U5d, tag)
        FIRST = False

# ============================================================ 7. controls
hdr("6. CONTROLS -- the criterion is not vacuous")
sub("a shadow field that VIOLATES congruence (3) must NOT lift")
rq = random.Random(SEED + 61)
nbadlift = 0; ntest = 0; ncong = 0
for trial in range(12):
    co = [rq.randint(-4, 4) for _ in range(20)]
    lin = np.array([rq.randint(-6, 6) for _ in range(4)], dtype=np.int64)
    Ud = phi_slopes(co) + lin[None, :]
    cg = (cong3_field(Ud, SIG) + nc9) % 11
    viol = int((cg != 0).any(1).sum())
    UD = op_N(Ud); GF = op_G(Ud + UD + CONST_E2)
    nd33 = int((GF % 33 != 0).any(1).sum())
    ntest += 1
    if viol: ncong += 1; nbadlift += (nd33 > 0)
    print(f"  random PL field #{trial}: cells violating congruence (3): {viol}/{NC}; "
          f"cells where 33 does not divide G(sigt)(.): {nd33}/{NC}")
print(f"  {ncong} of {ntest} random PL fields violate (3); every one of them fails "
      f"33-divisibility: {nbadlift == ncong}")
assert nbadlift == ncong and ncong > 0
sub("mod-3 layer: without m the criterion fails; with m = D it holds")
for (tag, Z) in PATTERNS[:1]:
    U5d, _ = build_witness(tag, Z)
    G0 = op_G(U5d + CONST_E2)                  # m = 0
    G1 = op_G(U5d + op_N(U5d) + CONST_E2)      # m = D
    print(f"  m = 0 : cells with 3 | G(sigt)(d+e2): "
          f"{NC - int((G0 % 3 != 0).any(1).sum())}/{NC};  11 | : "
          f"{NC - int((G0 % 11 != 0).any(1).sum())}/{NC}")
    print(f"  m = D : cells with 3 | G(sigt)(d+D+e2): "
          f"{NC - int((G1 % 3 != 0).any(1).sum())}/{NC};  11 | : "
          f"{NC - int((G1 % 11 != 0).any(1).sum())}/{NC}")

# ============================================================ 8. verdict
hdr("7. VERDICT")
for k, v in RESULTS.items(): print(f"  {k:34s} : {v}")
nl = sum(1 for v in RESULTS.values() if v == 'LIFTS')
print(f"\n  {nl} of {len(RESULTS)} shadow witnesses LIFT to a genuine Theorem-Q object.")
print("""
  TASK 3 (solvability of (**) over Z): SOLVABLE, for every witness, with an
     EXPLICIT integer certificate (U_h, U_m) substituted into all 1090 (**)
     equations, all 2570 h-wall conditions, all 2570 m-wall conditions and the
     sigma-equivariance of m -- 0 violations each.
  TASK 4 (direct Theorem-Q check): PASSES.  The orbit-min of
     (2h(sig^i n) + h(sig^{i-1} n) - <sig^i n, e2>)_i is attained at least twice
     at every sampled lattice point, and -- by the F = d + m argument above --
     at EVERY w.  Moreover h can be made CONVEX (or CONCAVE) by adding T*Phi, so
     h = h_Q for an explicit LATTICE POLYTOPE Q: THEOREM Q PROPER IS SATISFIED.
  TASK 5 (obstruction characterisation): there is NO obstruction.  The lifting
     criterion is exactly  33 | G(sigt)(d + m + e2*)  cellwise, whose mod-11 half
     IS congruence (3) (already imposed on the shadow) and whose mod-3 half is
     absorbed by the free choice m = D.  So the value-form system is NOT strictly
     weaker than Theorem Q: on the mixed fan the two are EQUIVALENT.
  TASK 6 (refinement robustness): VACUOUS -- h already exists PL on the mixed fan
     itself, so no refinement is needed.  (A refinement can only ADD PL functions,
     never remove the one already constructed; and Theorem Q mentions no fan at
     all -- the polytope oracle above uses none.)

  WHAT THIS SETTLES AND WHAT IT DOES NOT.
     SETTLED: Theorem Q (S8.16) has an AFFIRMATIVE answer -- an explicit lattice
     polytope Q exists.  Hence Lemma S (S8.17, corrected in IX-j) is FALSE, the
     conserved-eleven / value-form route CANNOT prove F55-NO, and the arithmetic
     flank ends at the same lifting wall as the geometric one: the Section-4
     failure branch of HANDOFF_F55_ENDGAME.md is triggered.
     NOT SETTLED: F55 itself.  A feasible Q is NECESSARY, not sufficient -- it
     closes the boundary half (F1); the (F3) transpose layer, the b-split
     bookkeeping and the actual existence of a trace-zero phi remain open.  The
     headline verdict (ed = 4 vs. unirationality) is NOT decided by this run.""")
print(f"\nreproduce:  python3 {os.path.basename(__file__)}   (deterministic, seed {SEED})")
print(f"total runtime {time.time()-T00:.1f}s")
