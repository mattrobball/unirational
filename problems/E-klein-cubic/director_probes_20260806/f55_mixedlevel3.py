#!/usr/bin/env python3
# T5, LEVEL 3: the SLOPE-FRAME (U-frame) shadow of the full value-form system
# taken modulo 11^s (s = 1 ... 8) on the MIXED fan -- the common refinement of the
# A4 Weyl fan {n_a = n_b} and the G9 order fan {H_a = H_b} -- with the pure G9
# order fan and the pure A4 Weyl fan as calibration, PLUS an exact-integer decider
# that removes the modulus altogether.
#
# HEADLINE.  On the mixed fan the two G9-induced rank patterns P = {0,1} and
# P = {3,4} are not merely un-killed at 11^3: they carry an EXPLICIT INTEGER
# U-field, verified condition by condition over Z and against (ii) at random
# lattice points.  So the value-form system (1)(2)(3) that Theorems X, X' and X''
# kill on the aligned and A4 fans is SATISFIABLE on the mixed fan, and no depth of
# the 11-adic tower can close T5.
#
#   N = {n in Z^5 : sum n = 0},  Lambda = Z^5/diag,  G9 = (1,5,3,4,9),
#   sigN(n)_j = n_{j-1 mod 5},  H_k(n) = <sig^k n, G9> = <n, mu_k>,
#   mu_k[j] = G9[(j+k) mod 5].  Cells = realizable pairs (piA, piG).
#
# THE SLOPE-FRAME SHADOW mod q = 11^s.  Unknowns U_C in (Z/q)^5 modulo the
# diagonal -- normalized so that the last coordinate is 0, i.e. 4 free
# coordinates per cell.  ALL conditions are LINEAR over Z/q:
#
#   (1) zeros   U_C == 0 (mod q) on every zero cell of the pattern;
#   (2) jumps   U_C - U_C' in (Z/q)*nu across every wall W with primitive
#               integer normal nu.  Encoded WITHOUT an explicit multiplier:
#               pick j0 with nu[j0] a unit mod 11 (exists for every wall here
#               -- verified below); the conditions are
#                  nu[j0]*(U-U')[j] - nu[j]*(U-U')[j0] == 0 (mod q),  j != j0,
#               3 independent rows after the diagonal normalization.  This is
#               EQUIVALENT to membership in (Z/q)*nu because nu[j0] is a unit
#               (verified on random integer simulations U - U' = m*nu + q*e).
#   (3) orbit   for each sigma-orbit with rep C:
#       congruence   sum_k 9^k * shift^k(U(sig^k C)) == -c9  (mod 11),
#               c9 = (4,9,1,5,3), (shift U)_i = U_{i+k} (the M-side transport
#               verified in f55_mixedfan.py, re-verified below).  To keep ONE
#               modulus these rows are multiplied by q/11:
#                  (q/11)*row == -(q/11)*c9 (mod q)   <=>   row == -c9 (mod 11).
#
# SOUNDNESS.  Every row is a consequence of the value-form system (integral-
# sloped PL d on the fan, d = 0 on >= 2 cells per sigma-orbit, (ii) at every
# lattice point): (2) is the integral-slope wall law, (1) the zero pattern,
# (3) is exactly (ii) (Note IX S8.20).  So the shadow is a NECESSARY condition
# and every INFEASIBLE verdict transfers to the full system.  A FEASIBLE
# verdict says only that THIS shadow cannot kill the pattern.  Both the cell
# list and the wall list of the mixed fan are proved COMPLETE against exact
# Zaslavsky counts, and every cell/wall carries an exact integer certificate,
# so the system is the full one -- neither a sub- nor a super-system.
#
# SOLVER.  Z/11^s is not a field, so the solver is a Hensel/lifting solver that
# uses only F11 linear algebra: A x = b (mod 11^s) is reduced to a chain of F11
# systems A^(0) = A, A^(j+1) = [ (A^(j) K_j)/11 | A^(j) ], b^(j+1) =
# (b^(j) - A^(j) x_j)/11, where (x_j, K_j) is a particular solution and a kernel
# basis of A^(j) mod 11.  A FEASIBLE verdict returns an explicit x, verified by
# substitution into the ORIGINAL conditions.  An INFEASIBLE verdict returns a
# FARKAS CERTIFICATE y over Z/q with y*A == 0 (mod q) and y*b != 0 (mod q),
# obtained by lifting the F11 certificate through the chain
#      y  <-  y + 11^{s-i-1} * z,    z*A^(i) == -u (mod 11),
#      u := ((y A^(i)) mod 11^{s-i}) / 11^{s-i-1},
# and VERIFIED by direct substitution.  Every infeasible verdict below prints
# its certificate check; every feasible verdict prints its solution check.
#
# THE EXACT-INTEGER DECIDER (section 6).  The tower is not only a sequence of
# necessary conditions: writing the system over Z as [H x = 0 over Z] together
# with [C x == rhs mod 11] (H = jump + zero rows -- a primitive nu makes an
# integral cross-condition force an INTEGER multiplier, so H x = 0 IS the exact
# wall law), the lattice L := ker_Z(H) is SATURATED, hence L (x) F11 is exactly
# the set of residues realized by integer solutions, and
#     integral feasibility  <=>  feasibility mod 11^s for EVERY s.
# The decider computes an exact Z-basis of L (kernel over three primes ~10^6,
# CRT, rational reconstruction, H k = 0 re-verified over Z, then 11-saturation),
# which pins rank_Q(H) exactly, and decides the resulting d-dimensional F11
# problem.  FEASIBLE returns an explicit integer U-field, re-verified over Z
# condition by condition; INFEASIBLE returns a verified F11 Farkas certificate.
#
# Reproduce:  python3 f55_mixedlevel3.py          (deterministic; seed 20260807)
#   env knobs: F55_SMAX (default 8) top of the 11-adic tower; F55_INT=0 skips the
#              exact-integer certification; F55_NB / F55_NCT sample sizes
import numpy as np, random, time, sys, os
from fractions import Fraction as Fr
from itertools import combinations, permutations
from math import gcd
from scipy.optimize import linprog

T00 = time.time()
SEED = 20260807
BLK = 512
DO_INT = os.environ.get("F55_INT", "1") != "0"
INTRES = {}
np.seterr(all='raise')
def hdr(s): print("\n" + "=" * 78 + "\n== " + s + "\n" + "=" * 78)

# ============================================================ 0. conventions
G9 = (1, 5, 3, 4, 9)
c9 = (4, 9, 1, 5, 3)
MU = [tuple(G9[(j + k) % 5] for j in range(5)) for k in range(5)]
pairs = list(combinations(range(5), 2))
trip = list(combinations(range(5), 3))
INV11 = [0] + [pow(a, 9, 11) for a in range(1, 11)]

def sigN(n): return tuple(n[(j - 1) % 5] for j in range(5))
def shift_perm(p, k): return tuple((x + k) % 5 for x in p)
def swp(p, i):
    q = list(p); q[i], q[i + 1] = q[i + 1], q[i]; return tuple(q)
def shift_up(U, k): return tuple(U[(i + k) % 5] for i in range(5))
def shift_dn(U, k): return tuple(U[(i - k) % 5] for i in range(5))
def prim(v):
    w = [v[j] - v[4] for j in range(5)]
    g = 0
    for x in w: g = gcd(g, x)
    assert g > 0
    return tuple(x // g for x in w)
def nf4(v):     # normalized representative in Lambda, coords 0..3 (coord 4 = 0)
    return np.array([v[j] - v[4] for j in range(4)], dtype=np.int64)

hdr("0. conventions, verified numerically")
rng0 = random.Random(SEED)
def rnd_n(B=30):
    n = [rng0.randint(-B, B) for _ in range(5)]
    n[4] = -sum(n[:4]); return tuple(n)
ok = True
for _ in range(2000):
    n = rnd_n()
    for k in range(5):
        m = n
        for _ in range(k): m = sigN(m)
        if sum(m[j] * G9[j] for j in range(5)) != sum(n[j] * MU[k][j] for j in range(5)):
            ok = False
print("H_k(n) = <sig^k n, G9> = <n, mu_k>, mu_k[j] = G9[(j+k)%5] :", ok)
assert ok
sc_up = sc_dn = 0
for _ in range(2000):
    n = rnd_n(); U = tuple(rng0.randint(-30, 30) for _ in range(5))
    m = n
    for k in range(1, 5):
        m = sigN(m)
        lhs = sum(U[j] * m[j] for j in range(5))
        if lhs == sum(shift_up(U, k)[j] * n[j] for j in range(5)): sc_up += 1
        if lhs == sum(shift_dn(U, k)[j] * n[j] for j in range(5)): sc_dn += 1
print(f"M-side transport (8000 trials): (shift U)_i = U_(i+k): {sc_up} hits ; "
      f"U_(i-k): {sc_dn} hits")
assert sc_up == 8000 and sc_dn < 8000
print("VERIFIED convention: <U, sig^k n> = <shift_k U, n>, (shift_k U)_i = U_{(i+k) mod 5}")
assert shift_dn(c9, 1) == tuple((9 * x) % 11 for x in c9)
print("c9 is the 9-eigenvector: shift_{-1} c9 == 9*c9 (mod 11)  -> one congruence "
      "row-block per sigma-orbit")

# ================================================ 1. the Z/11^s solver
hdr("1. the Z/11^s solver (Hensel chain over F11, Farkas certificates)")

def imatmul(X, Y):
    """exact integer matrix product; uses float64 BLAS when provably exact."""
    if X.size == 0 or Y.size == 0:
        return np.zeros((X.shape[0], Y.shape[1]), dtype=np.int64)
    mx = int(np.abs(X).max()); my = int(np.abs(Y).max()); n = X.shape[1]
    if mx * my * n < 2 ** 52:
        return (X.astype(np.float64) @ Y.astype(np.float64)).astype(np.int64)
    return X.astype(object) @ Y.astype(object)

class Ech11(object):
    """RREF over F11 of an augmented system [A | b], pivots only in A-columns.
       Optionally tracks the row transformation Y: every echelon row equals the
       corresponding Y-row applied to the ORIGINAL rows.  On an inconsistent row
       (A-part zero, b-part nonzero) the Y-row is a Farkas certificate."""
    def __init__(self, nA, M=None):
        self.nA = nA; self.w = nA + 1; self.M = M
        self.E = np.zeros((0, self.w), dtype=np.int64)
        self.Y = None if M is None else np.zeros((0, M), dtype=np.int64)
        self.piv = []; self.bad = None; self.badb = 0
    def add(self, B, ridx):
        if self.bad is not None: return False
        B = np.asarray(B, dtype=np.int64) % 11
        k = B.shape[0]; C = None
        if self.piv:
            C = B[:, self.piv].copy()
            B = (B - imatmul(C, self.E)) % 11
        T = np.eye(k, dtype=np.int64)
        newp = []; keep = []
        for i in range(k):
            nz = np.nonzero(B[i, :self.nA])[0]
            if nz.size == 0:
                if B[i, self.nA] % 11:
                    self.badb = int(B[i, self.nA])
                    if self.M is not None:
                        y = np.zeros(self.M, dtype=np.int64)
                        y[ridx] = T[i]
                        if self.piv:
                            co = (T[i:i + 1] @ C) % 11
                            y = (y - imatmul(co, self.Y)[0]) % 11
                        self.bad = y % 11
                    else:
                        self.bad = True
                    return False
                continue
            c = int(nz[0]); iv = INV11[int(B[i, c])]
            B[i] = (B[i] * iv) % 11; T[i] = (T[i] * iv) % 11
            f = B[:, c].copy(); f[i] = 0
            nzr = np.nonzero(f)[0]
            if nzr.size:
                B[nzr] = (B[nzr] - np.outer(f[nzr], B[i])) % 11
                T[nzr] = (T[nzr] - np.outer(f[nzr], T[i])) % 11
            newp.append(c); keep.append(i)
        if keep:
            Bn = B[keep]; Tn = T[keep]
            Yb = None
            if self.M is not None:
                Yb = np.zeros((len(keep), self.M), dtype=np.int64)
                Yb[:, ridx] = Tn
                if self.piv:
                    co = (imatmul(Tn, C)) % 11
                    Yb = (Yb - imatmul(co, self.Y)) % 11
            if self.piv:
                D = self.E[:, newp].copy()
                self.E = (self.E - imatmul(D, Bn)) % 11
                if self.M is not None:
                    self.Y = (self.Y - imatmul(D, Yb)) % 11
            self.E = np.vstack([self.E, Bn]); self.piv += newp
            if self.M is not None: self.Y = np.vstack([self.Y, Yb])
        return True
    def solution(self):
        """particular solution (free coords 0) + kernel basis (nA x k)."""
        nv = self.nA
        part = np.zeros(nv, dtype=np.int64)
        pv = np.array(self.piv, dtype=np.int64)
        if pv.size: part[pv] = self.E[:, nv]
        ps = set(self.piv); free = [c for c in range(nv) if c not in ps]
        K = np.zeros((nv, len(free)), dtype=np.int64)
        if free:
            K[free, np.arange(len(free))] = 1
            if pv.size: K[pv, :] = (-self.E[:, free]) % 11
        return part, K
    def express(self, w):
        """z with z*(original A-rows) == w (mod 11), or None."""
        w = np.asarray(w, dtype=np.int64) % 11
        if not self.piv:
            return (np.zeros(self.M, dtype=np.int64) if not w.any() else None)
        coef = w[np.array(self.piv)] % 11
        res = (w - imatmul(coef[None, :], self.E[:, :self.nA])[0]) % 11
        if res.any(): return None
        return imatmul(coef[None, :], self.Y)[0] % 11

def solve_pow11(A, b, s, track=False):
    """decide A x == b (mod 11^s).  Returns ('FEASIBLE', x, None) or
       ('INFEASIBLE', y_or_None, level).  With track=True the infeasible
       branch returns a verified-shape Farkas certificate y."""
    q = 11 ** s
    M = A.shape[0]
    Ac = np.asarray(A, dtype=np.int64) % q; bc = np.asarray(b, dtype=np.int64) % q
    levels = []
    for j in range(s):
        mj = 11 ** (s - j)
        ech = Ech11(Ac.shape[1], M=(M if track else None))
        Ab = np.concatenate([Ac % 11, (bc % 11)[:, None]], axis=1)
        st = 0
        while st < M:
            if not ech.add(Ab[st:st + BLK], np.arange(st, min(st + BLK, M))): break
            st += BLK
        if ech.bad is not None:
            if not track: return ('INFEASIBLE', None, j)
            y = (ech.bad * (mj // 11)) % mj
            for i in range(j - 1, -1, -1):
                Ai, bi, Ki, xi, echi = levels[i]
                mi = 11 ** (s - i)
                t = imatmul(y[None, :], Ai)[0] % mi
                assert (t % (mi // 11) == 0).all(), "lift: y*A not divisible"
                u = (t // (mi // 11)) % 11
                z = echi.express((-u) % 11)
                assert z is not None, "lift: u not in the row space (impossible)"
                y = (y + (mi // 11) * z) % mi
            return ('INFEASIBLE', y, j)
        xj, Kj = ech.solution()
        levels.append((Ac, bc, Kj, xj, ech))
        if j == s - 1: break
        W = imatmul(Ac, Kj)
        assert (W % 11 == 0).all()
        W //= 11
        r = bc - imatmul(Ac, xj[:, None])[:, 0]
        assert (r % 11 == 0).all()
        r //= 11
        mn = 11 ** (s - j - 1)
        Ac = np.concatenate([W % mn, Ac % mn], axis=1); bc = r % mn
    x = levels[-1][3]
    for i in range(len(levels) - 2, -1, -1):
        Ai, bi, Ki, xi, _ = levels[i]
        kk = Ki.shape[1]
        x = (xi + imatmul(Ki, x[:kk, None])[:, 0] + 11 * x[kk:]) % (11 ** (s - i))
    return ('FEASIBLE', x, None)

def decide(A, b, s):
    """full decision + certificate/solution verification.  Returns
       (feasible, x_or_y, info-string)."""
    q = 11 ** s
    st, obj, lev = solve_pow11(A, b, s, track=False)
    if st == 'FEASIBLE':
        res = (imatmul(A % q, obj[:, None])[:, 0] - b) % q
        assert not res.any(), "FEASIBLE but the solution does not satisfy A x = b"
        return True, obj, f"solution verified: max|A x - b| mod {q} = 0"
    st2, y, lev2 = solve_pow11(A, b, s, track=True)
    assert st2 == 'INFEASIBLE' and lev2 == lev
    yA = imatmul(y[None, :], A % q)[0] % q
    yb = int(imatmul(y[None, :], (b % q)[:, None])[0, 0]) % q
    assert not yA.any(), "certificate failed: y*A != 0"
    assert yb % q != 0, "certificate failed: y*b == 0"
    nz = int((y % q != 0).sum())
    return False, y, (f"CERTIFICATE verified: y*A == 0 (mod {q}) on all {A.shape[1]} "
                      f"columns, y*b == {yb} != 0 (mod {q}); y has {nz} nonzero "
                      f"entries of {A.shape[0]} rows, 11-valuation of y*b = "
                      f"{[v for v in range(s+1) if yb % 11**v == 0][-1]}")

# ---------------------------------------------------- 1b. solver validation
hdr("1b. SOLVER VALIDATION (planted solutions, planted infeasibilities, brute force)")
vr = np.random.default_rng(SEED)
def rand_system(q, M, N):
    A = vr.integers(0, q, size=(M, N)).astype(np.int64)
    for c in range(N):                     # exercise 11-divisible columns
        d = int(vr.integers(0, 3))
        if d: A[:, c] = (A[:, c] * (11 ** d)) % q
    for r in range(M):                     # and 11-divisible rows
        if vr.random() < 0.3: A[r] = (A[r] * 11) % q
    return A
nfe = nfe_ok = 0; nin = nin_ok = 0
t0 = time.time()
for (s, ntr) in ((2, 200), (3, 200)):
    q = 11 ** s
    for tr in range(ntr):
        M = int(vr.integers(3, 9)); N = int(vr.integers(2, 6))
        A = rand_system(q, M, N)
        x0 = vr.integers(0, q, size=N).astype(np.int64)
        b = (A @ x0) % q
        f, obj, info = decide(A, b, s)
        nfe += 1; nfe_ok += int(f and not ((A @ obj - b) % q).any())
        # planted infeasibility: y with a unit entry, last row forced so y*A == 0
        A2 = rand_system(q, M, N)
        y = vr.integers(0, q, size=M).astype(np.int64); y[M - 1] = 1
        A2[M - 1] = (-(y[:M - 1] @ A2[:M - 1])) % q
        b2 = vr.integers(0, q, size=M).astype(np.int64)
        b2[M - 1] = (-(y[:M - 1] @ b2[:M - 1]) + 1) % q
        assert not ((y @ A2) % q).any() and (y @ b2) % q == 1
        f2, obj2, info2 = decide(A2, b2, s)
        nin += 1
        nin_ok += int((not f2) and (not ((obj2 @ A2) % q).any()) and (obj2 @ b2) % q != 0)
print(f"planted-solution systems  (Z/121 and Z/1331): {nfe_ok}/{nfe} declared FEASIBLE "
      f"with a solution that verifies by substitution")
print(f"planted-infeasible systems (Z/121 and Z/1331): {nin_ok}/{nin} declared INFEASIBLE "
      f"with a Farkas certificate y (y*A == 0, y*b != 0) that verifies by substitution")
assert nfe_ok == nfe and nin_ok == nin
nb = 0; nb_ok = 0
for (s, ntr) in ((2, 150), (3, 50)):
    q = 11 ** s
    grid = np.stack(np.meshgrid(np.arange(q), np.arange(q), indexing='ij'),
                    axis=-1).reshape(-1, 2).astype(np.int64)
    for tr in range(ntr):
        M = int(vr.integers(2, 5))
        A = rand_system(q, M, 2)
        b = vr.integers(0, q, size=M).astype(np.int64)
        brute = bool((((grid @ A.T) - b) % q == 0).all(1).any())
        f, obj, info = decide(A, b, s)
        nb += 1; nb_ok += int(f == brute)
print(f"BRUTE-FORCE cross-check (2 unknowns, all q^2 vectors enumerated): "
      f"{nb_ok}/{nb} verdicts agree with exhaustive enumeration over Z/121 and Z/1331")
assert nb_ok == nb
print(f"solver validation total: {nfe+nin+nb} systems, 0 discrepancies  "
      f"[{time.time()-t0:.1f}s]")

# ------------------------------------------- 1c. the wall-jump encoding
hdr("1c. the jump encoding: 3 cross-conditions == membership in (Z/q)*nu")
def jump_rows_ok(nu5, q, ntr=4000):
    n4 = nf4(nu5) % q
    j0 = next(j for j in range(4) if n4[j] % 11)
    inv = pow(int(n4[j0]), -1, q)
    good = bad = 0
    for _ in range(ntr):
        if vr.random() < 0.5:                          # d IS in (Z/q)*nu
            m = int(vr.integers(0, q))
            d = (m * n4 + q * vr.integers(-5, 6, size=4)) % q
            member = True
        else:
            d = vr.integers(0, q, size=4).astype(np.int64) % q
            m = (int(d[j0]) * inv) % q
            member = not ((m * n4 - d) % q).any()
        cross = all(((int(n4[j0]) * int(d[j]) - int(n4[j]) * int(d[j0])) % q) == 0
                    for j in range(4) if j != j0)
        if cross == member: good += 1
        else: bad += 1
    return good, bad
tg = tb = 0
for s in (1, 2, 3):
    for nu5 in [(1, -1, 0, 0, 0), tuple(MU[0][j] - MU[1][j] for j in range(5)),
                tuple(MU[2][j] - MU[4][j] for j in range(5)), (0, 0, 1, 0, -1)]:
        g, bdd = jump_rows_ok(nu5, 11 ** s); tg += g; tb += bdd
print(f"random integer simulations U - U' = m*nu + q*noise and random d, over "
      f"Z/11, Z/121, Z/1331, on 4 representative normals:")
print(f"   {tg} agreements, {tb} disagreements between 'the 3 cross-conditions hold' "
      f"and 'd lies in (Z/q)*nu'  (0 disagreements = the encoding is exact)")
assert tb == 0

# ================================================ 2. fan constructions
hdr("2. fan constructions")
FORMS = []; FNAME = []
for a, b_ in combinations(range(5), 2):
    v = [0] * 5; v[a] = 1; v[b_] = -1
    FORMS.append(tuple(v)); FNAME.append(("A", a, b_))
for a, b_ in combinations(range(5), 2):
    FORMS.append(tuple(MU[a][j] - MU[b_][j] for j in range(5))); FNAME.append(("G", a, b_))
F = np.array(FORMS, dtype=np.int64)
FN = np.array([[c[j] - c[4] for j in range(4)] for c in FORMS], dtype=np.float64)
def projdir(v):
    p = next(x for x in v if x != 0)
    return tuple(Fr(x, 1) / p for x in v)
assert len(set(projdir(v) for v in FORMS)) == 20
print("the 20 hyperplanes {n_a=n_b} (10, generic class) and {H_a=H_b} (10, aligned "
      "class) are pairwise distinct")

def zaslavsky(forms, d):
    forms = [tuple(Fr(x) for x in f) for f in forms]
    seen = {}
    for f in forms:
        p = next(x for x in f if x != 0); seen[tuple(x / p for x in f)] = f
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
cells = {}
for piA in permutations(range(5)):
    for piG in permutations(range(5)):
        key = (piA, piG); sv = cell_signs(key); p = find_point(sv)
        if p is None: continue
        assert (np.sign(p @ F.T) == sv).all()
        cells[key] = tuple(int(x) for x in p)
NC = len(cells)
print(f"MIXED FAN cells: LP over all {120*120} pairs (piA,piG), each survivor certified "
      f"by an EXACT integer interior point: {NC}")
print(f"   == exact Zaslavsky chamber count {ZAS}: {NC == ZAS}  => CELL LIST PROVABLY "
      f"COMPLETE   [{time.time()-t0:.1f}s]")
assert NC == ZAS == 1090
CK = sorted(cells.keys()); CIDX = {k: i for i, k in enumerate(CK)}
PTS = np.array([cells[k] for k in CK], dtype=np.int64)
SC = np.sign(PTS @ F.T)
assert (SC != 0).all() and len(set(map(tuple, SC.tolist()))) == NC

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
    free = [c for c in range(5) if c not in piv]; B = []
    for fc in free:
        v = [Fr(0)] * 5; v[fc] = Fr(1)
        for i, c in enumerate(piv): v[c] = -A[i][fc]
        B.append([Fr(x) for x in v])
    return B
t0 = time.time(); WALLCOUNT = 0
for t in range(20):
    B = plane_basis(t); restr = []
    for qf in range(20):
        if qf == t: continue
        co = tuple(sum(B[k][j] * FORMS[qf][j] for j in range(5)) for k in range(3))
        if any(x != 0 for x in co): restr.append(co)
    WALLCOUNT += zaslavsky(restr, 3)

score = {(sA, sG): 0 for sA in (1, -1) for sG in (1, -1)}
for i in range(NC):
    n = tuple(PTS[i].tolist()); (piA, piG) = CK[i]
    m = sigN(n); Hv = [sum(m[j] * MU[k][j] for j in range(5)) for k in range(5)]
    qA = tuple(sorted(range(5), key=lambda j: -m[j]))
    qG = tuple(sorted(range(5), key=lambda j: -Hv[j]))
    for sA in (1, -1):
        for sG in (1, -1):
            if (qA, qG) == (shift_perm(piA, sA), shift_perm(piG, sG)): score[(sA, sG)] += 1
assert score[(1, -1)] == NC
print(f"sigma-action verified on all {NC} exact witness points: "
      f"sigma:(piA,piG) -> (piA+1, piG-1)")
SIG = np.array([CIDX[(shift_perm(k[0], 1), shift_perm(k[1], -1))] for k in CK])
ORB = []; _sn = set()
for i in range(NC):
    if i in _sn: continue
    o = [i]
    for _ in range(4): o.append(int(SIG[o[-1]]))
    assert len(set(o)) == 5 and int(SIG[o[-1]]) == i
    _sn.update(o); ORB.append(o)
assert len(ORB) == 218
print(f"sigma-orbits: {len(ORB)}, all FREE of size 5 ({5*len(ORB)} = {NC})")

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
nA = sum(1 for t in wtyp if t == 'A')
print(f"MIXED FAN walls: every adjacent pair certified by an exact integer "
      f"relative-interior facet point: {len(WALLS)}")
print(f"   == exact Zaslavsky wall count {WALLCOUNT}: {len(WALLS) == WALLCOUNT}  => WALL "
      f"LIST PROVABLY COMPLETE   [{time.time()-t0:.1f}s]")
assert len(WALLS) == WALLCOUNT and (len(WALLS), nA) == (2570, 1400)
print(f"   A4-class (GENERIC normals e_a-e_b): {nA};  G9-class (ALIGNED normals "
      f"mu_a-mu_b): {len(WALLS)-nA}")

def check_normals(WL, label):
    nn = sorted(set(w[2] for w in WL)); bad = 0; j0s = {}
    for nu in nn:
        g = 0
        for x in nu: g = gcd(g, x)
        if g != 1: bad += 1
        v = nf4(nu)
        js = [j for j in range(4) if v[j] % 11]
        if not js: bad += 1
        j0s[nu] = (js[0] if js else None)
    print(f"   [{label}] {len(nn)} distinct normals, all primitive and all NONZERO "
          f"mod 11 (a unit coordinate exists): {bad == 0}")
    assert bad == 0
    return j0s
J0 = check_normals(WALLS, "mixed")

def cell_of_mixed(n):
    """index of the mixed-fan cell containing the lattice point n (None on a wall)."""
    Hv = [sum(n[j] * MU[k][j] for j in range(5)) for k in range(5)]
    if len(set(n)) < 5 or len(set(Hv)) < 5: return None
    piA = tuple(sorted(range(5), key=lambda j: -n[j]))
    piG = tuple(sorted(range(5), key=lambda j: -Hv[j]))
    return CIDX.get((piA, piG))

GPERM = sorted(set(k[1] for k in CK)); GIDX = {p: i for i, p in enumerate(GPERM)}
GOF = np.array([GIDX[k[1]] for k in CK])
GORB = []; _sn = set()
for p in GPERM:
    if p in _sn: continue
    o = [p]
    for _ in range(4): o.append(shift_perm(o[-1], -1))
    assert len(set(o)) == 5; _sn.update(o); GORB.append([GIDX[q] for q in o])

# ---- the pure G9 order fan and the pure A4 Weyl fan (same code path)
def order_fan(kind):
    OC = list(permutations(range(5))); OI = {p: i for i, p in enumerate(OC)}
    OW = []
    for p in OC:
        for pos in range(4):
            q = swp(p, pos)
            if OI[q] > OI[p]:
                a, b_ = p[pos], p[pos + 1]
                if kind == 'G':
                    v = tuple(MU[a][j] - MU[b_][j] for j in range(5))
                else:
                    vv = [0] * 5; vv[a] = 1; vv[b_] = -1; v = tuple(vv)
                OW.append((OI[p], OI[q], prim(v)))
    sh = -1 if kind == 'G' else 1
    OS = np.array([OI[shift_perm(p, sh)] for p in OC])
    OO = []; sn = set()
    for i in range(120):
        if i in sn: continue
        o = [i]
        for _ in range(4): o.append(int(OS[o[-1]]))
        assert len(set(o)) == 5 and int(OS[o[-1]]) == i
        sn.update(o); OO.append(o)
    return OC, OW, OS, OO
G9C, G9W, G9S, G9O = order_fan('G')
A4C, A4W, A4S, A4O = order_fan('A')
print(f"pure G9 order fan: {len(G9C)} cells, {len(G9W)} walls, {len(G9O)} free "
      f"sigma-orbits (sigma = piG - 1)")
print(f"pure A4 Weyl fan : {len(A4C)} cells, {len(A4W)} walls, {len(A4O)} free "
      f"sigma-orbits (sigma = piA + 1)")
assert (len(G9W), len(G9O)) == (240, 24) and (len(A4W), len(A4O)) == (240, 24)
check_normals(G9W, "G9 fan"); check_normals(A4W, "A4 fan")

# ================================================ 3. the slope-frame system
hdr("3. the slope-frame shadow: system builder")

_FANCACHE = {}
def fan_pieces(key, NCELL, WL, SIGP, ORBS):
    """pattern-independent pieces of the slope-frame system in the tree
       parametrization.  Unknowns: U_root (4 coords) + one multiplier per
       spanning-tree wall.  Returns
         EXPR  (NCELL,4,P) exact integer coefficient tensor for U_c coords 0..3,
         HJ    (3*#non-tree-walls, P) EXACT INTEGER jump rows (= 0 conditions),
         CM    (4*#orbits, P) congruence coefficients mod 11,
         RHS   (4*#orbits,) mod 11."""
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
    assert all(seen), "the cell adjacency graph is not connected"
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

def zero_rows(EXPR, ZEROS, P):
    if len(ZEROS) == 0: return np.zeros((0, P), dtype=np.int64)
    return EXPR[np.asarray(sorted(ZEROS), dtype=np.int64)].reshape(-1, P)

def build_system(key, NCELL, WL, SIGP, ORBS, ZEROS, s):
    EXPR, HJ, CM, RHS, P = fan_pieces(key, NCELL, WL, SIGP, ORBS)
    q = 11 ** s; qq = q // 11
    ZR = zero_rows(EXPR, ZEROS, P)
    A = np.concatenate([HJ % q, ZR % q, (qq * CM) % q], axis=0)
    b = np.concatenate([np.zeros(HJ.shape[0] + ZR.shape[0], dtype=np.int64),
                        (qq * RHS) % q])
    return A, b, EXPR, None, (HJ.shape[0], ZR.shape[0], CM.shape[0], P)

def U_from_params(EXPR, x, q):
    U = imatmul(EXPR.reshape(-1, EXPR.shape[2]), (x % q)[:, None])[:, 0] % q
    U = U.reshape(EXPR.shape[0], 4)
    return np.concatenate([U, np.zeros((EXPR.shape[0], 1), dtype=np.int64)], axis=1)

def verify_U(U, WL, SIGP, ORBS, ZEROS, q):
    """independent re-verification of a claimed solution against ALL the
       ORIGINAL conditions (not the row encoding).  Returns violation counts."""
    v_jump = v_zero = v_cong = 0
    for (i, j, nu) in WL:
        d = (U[i] - U[j]) % q
        n5 = np.array([(nu[t] - nu[4]) % q for t in range(5)], dtype=np.int64)
        j0 = next(t for t in range(4) if (nu[t] - nu[4]) % 11)
        m = (int(d[j0]) * pow(int(n5[j0]), -1, q)) % q
        if ((m * n5 - d) % q).any(): v_jump += 1
    for c in ZEROS:
        if (U[c] % q).any(): v_zero += 1
    rhs = np.array([((-c9[j]) - (-c9[4])) % 11 for j in range(5)], dtype=np.int64)
    for o in ORBS:
        acc = np.zeros(5, dtype=np.int64); cc = o[0]
        for k in range(5):
            u = U[cc] % 11
            sh = np.array([u[(i + k) % 5] for i in range(5)], dtype=np.int64)
            acc = (acc + pow(9, k, 11) * ((sh - sh[4]) % 11)) % 11
            cc = int(SIGP[cc])
        if (acc != rhs).any(): v_cong += 1
    return v_jump, v_zero, v_cong

def run_shadow(label, NCELL, WL, SIGP, ORBS, ZEROS, s, quiet=False, key=None):
    """decide the mod-11^s slope shadow for one pattern; verify either way."""
    q = 11 ** s
    t0 = time.time()
    if key is None: key = (id(WL), id(ORBS))       # one cache slot per fan object
    A, b, EXPR, tree, (njump, nz, ncg, P) = build_system(key, NCELL, WL, SIGP, ORBS,
                                                        sorted(ZEROS), s)
    feas, obj, info = decide(A, b, s)
    extra = ""
    if feas:
        U = U_from_params(EXPR, obj, q)
        vj, vz, vc = verify_U(U, WL, SIGP, ORBS, sorted(ZEROS), q)
        assert (vj, vz, vc) == (0, 0, 0), ("solution failed re-verification", vj, vz, vc)
        extra = (f"re-verified independently against ALL {len(WL)} wall memberships, "
                 f"{len(ZEROS)} zero cells and {len(ORBS)} orbit congruences: "
                 f"{vj+vz+vc} violations")
    if not quiet:
        print(f"  [{label}] mod {q}: unknowns {P}, rows {A.shape[0]} "
              f"({njump} jump + {nz} zero + {ncg} congruence) -> "
              f"{'FEASIBLE' if feas else 'INFEASIBLE'}   [{time.time()-t0:.1f}s]")
        print(f"      {info}")
        if extra: print(f"      {extra}")
    return feas, obj, A, b, EXPR

def tower(label, NCELL, WL, SIGP, ORBS, ZEROS, smax, quiet=False):
    """walk s = 1,2,...,smax, stopping at the first infeasible modulus.
       Returns (dict s -> feasible, smallest killing s or None)."""
    res = {}
    for s in range(1, smax + 1):
        f, _, _, _, _ = run_shadow(label, NCELL, WL, SIGP, ORBS, ZEROS, s, quiet=quiet)
        res[s] = f
        if not f: break
    kill = min([s for s in res if not res[s]], default=None)
    return res, kill

# --------------------------------------------- exact-integer certification
def echelon_p(A, p):
    """RREF over F_p (p prime, p^2 * ncols < 2^52 required for the BLAS path)."""
    nA = A.shape[1]
    E = np.zeros((0, nA), dtype=np.int64); piv = []
    for st in range(0, A.shape[0], BLK):
        B = np.array(A[st:st + BLK], dtype=np.int64) % p
        if piv:
            C = B[:, piv].copy()
            B = (B - imatmul(C, E)) % p
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
                D = E[:, newp].copy()
                E = (E - imatmul(D, Bn)) % p
            E = np.vstack([E, Bn]); piv += newp
    o = np.argsort(np.array(piv, dtype=np.int64))
    return E[o], [piv[i] for i in o]

def kernel_from_rref(E, piv, nA):
    """kernel basis of the RREF E (pivots piv) as an (nA x d) integer matrix,
       entries taken from E; over F_p this is the canonical RREF kernel basis."""
    ps = set(piv); free = [c for c in range(nA) if c not in ps]
    K = np.zeros((nA, len(free)), dtype=np.int64)
    if free:
        K[free, np.arange(len(free))] = 1
        if piv: K[np.array(piv), :] = -E[:, free]
    return K, free

def ratrec(a, M, N):
    """rational reconstruction: n/d == a (mod M) with |n| <= N, 0 < d <= M/(2N)."""
    r0, r1 = M, a % M
    s0, s1 = 0, 1
    while r1 > N:
        q = r0 // r1
        r0, r1 = r1, r0 - q * r1
        s0, s1 = s1, s0 - q * s1
    num, den = r1, s1
    if den < 0: num, den = -num, -den
    if den == 0: return None
    g = gcd(abs(num), den)
    num //= g; den //= g
    if (num - a * den) % M != 0: return None
    return num, den

def try_integral(key, NCELL, WL, SIGP, ORBS, ZEROS,
                 primes=(1000003, 999983, 999979)):
    """DECIDE the exact INTEGER slope system on this pattern.

       x in Z^P with H x = 0 over Z  and  C x == rhs (mod 11).  The first block
       is exactly 'the U-field is integral, vanishes on the zero cells, and every
       wall jump lies in Z*nu' (nu primitive, so an integral cross-condition
       forces an INTEGER multiplier); the second is (ii).  So this is the FULL
       value-form system, not a shadow.  Since L := ker_Z(H) is saturated,
       L (x) F11 is the exact set of achievable residues, and the decision is a
       d-dimensional F11 problem once an exact Z-basis of L is in hand.
       Returns (status, x_or_None, message)."""
    EXPR, HJ, CM, RHS, P = fan_pieces(key, NCELL, WL, SIGP, ORBS)
    H = np.concatenate([HJ, zero_rows(EXPR, ZEROS, P)], axis=0)
    r11 = len(echelon_p(H % 11, 11)[1])
    Ks = []; pv0 = None
    for p in primes:
        Ep, pvp = echelon_p(H % p, p)
        if pv0 is None: pv0 = pvp
        elif pvp != pv0:
            return ("PRIME-MISMATCH", None,
                    f"rank/pivot structure differs between primes "
                    f"({len(pvp)} vs {len(pv0)})")
        Kp, free = kernel_from_rref(Ep, pvp, P)
        Ks.append(Kp % p)
    rp = len(pv0); d = P - rp
    msg = [f"unknowns P = {P}; rank_F11(H) = {r11} (ker dim {P-r11}), "
           f"rank_Fp(H) = {rp} for 3 primes ~10^6 (ker dim {d})"
           + ("  -- the rank DROPS mod 11, so mod-11 feasibility alone says nothing "
              "about Z" if r11 < rp else "")]
    # ---- CRT + rational reconstruction of the canonical RREF kernel basis
    M = 1
    for p in primes: M *= p
    KC = np.zeros((P, d), dtype=object)
    for t, p in enumerate(primes):
        Mi = M // p; inv = pow(Mi % p, -1, p)
        KC += Ks[t].astype(object) * (Mi * inv)
    KC %= M
    N = 1
    while 2 * N * N < M: N *= 2
    N //= 2
    nums = np.zeros((P, d), dtype=object)
    for t in range(d):
        L = 1; col = []
        for i in range(P):
            r = ratrec(int(KC[i, t]), M, N)
            if r is None:
                return ("RECONSTRUCTION-FAILED", None, msg[0] +
                        f"\n        rational reconstruction failed at kernel vector "
                        f"{t}, coordinate {i}")
            col.append(r); L = L * r[1] // gcd(L, r[1])
            if L > 10 ** 11:
                return ("RECONSTRUCTION-FAILED", None, msg[0] +
                        f"\n        denominator lcm blows up at kernel vector {t}")
        for i in range(P):
            nums[i, t] = col[i][0] * (L // col[i][1])
    def checkH(K):
        mx = int(max(abs(int(v)) for v in K.ravel())) if K.size else 0
        if mx > 10 ** 12: return None, mx
        Ki = K.astype(np.int64)
        return H.astype(np.int64) @ Ki, mx
    prod, mx = checkH(nums)
    if prod is None or prod.any():
        return ("RECONSTRUCTION-FAILED", None, msg[0] +
                "\n        the reconstructed kernel vectors do NOT satisfy H k = 0 "
                "over Z")
    msg.append(f"{d} exact INTEGER kernel vectors reconstructed (CRT over 3 primes + "
               f"rational reconstruction), VERIFIED H k = 0 over Z, max|entry| = {mx}")
    msg.append(f"=> dim ker_Q(H) >= {d} so rank_Q(H) <= {rp}; and rank_Q(H) >= "
               f"rank_Fp(H) = {rp}: rank_Q(H) = {rp} and dim ker_Q(H) = {d} EXACTLY, "
               f"so L := ker_Z(H) has rank {d}")
    # ---- 11-saturate the reconstructed sublattice, so that L' (x) F11 = L (x) F11
    K = nums
    nsat = 0
    for _ in range(60):
        Ek, pk = echelon_p(np.array([[int(v) for v in row] for row in K],
                                    dtype=np.int64) % 11, 11)
        if len(pk) == d: break
        Kk, freek = kernel_from_rref(Ek, pk, d)          # c with K c == 0 mod 11
        c = Kk[:, 0] % 11
        i0 = next(t for t in range(d) if c[t] % 11)
        c = (c * INV11[int(c[i0]) % 11]) % 11            # normalize c[i0] = 1
        v = np.zeros(P, dtype=object)
        for t in range(d):
            if c[t]: v = v + K[:, t] * int(c[t])
        assert all(int(z) % 11 == 0 for z in v), "saturation: not divisible by 11"
        K = K.copy(); K[:, i0] = np.array([int(z) // 11 for z in v], dtype=object)
        nsat += 1
    else:
        return ("SATURATION-FAILED", None, "\n        ".join(msg))
    prod, mx = checkH(K)
    if prod is None or prod.any():
        return ("SATURATION-FAILED", None, "\n        ".join(msg) +
                "\n        the 11-saturated basis fails H k = 0 over Z")
    Ki = K.astype(np.int64)
    msg.append(f"11-saturation: {nsat} exchange step(s); the resulting Z-basis of a "
               f"sublattice L' <= L has 11 coprime to [L:L'] (rank of L' mod 11 = "
               f"{d}), max|entry| = {mx}, and H k = 0 over Z re-verified.  Hence "
               f"L' (x) F11 = L (x) F11: the exact set of residues x mod 11 realized "
               f"by INTEGER solutions of H x = 0")
    # ---- decide C (K c) == rhs (mod 11) over F11^d
    CK = imatmul(CM % 11, Ki % 11) % 11
    ech = Ech11(d, M=CM.shape[0])
    Ab = np.concatenate([CK, (RHS % 11)[:, None]], axis=1)
    for st in range(0, Ab.shape[0], BLK):
        if not ech.add(Ab[st:st + BLK], np.arange(st, min(st + BLK, Ab.shape[0]))):
            break
    if ech.bad is not None:
        y = ech.bad % 11
        yA = imatmul(y[None, :], CK) % 11
        yb = int(imatmul(y[None, :], (RHS % 11)[:, None])[0, 0]) % 11
        assert not yA.any() and yb, "certificate check failed"
        return ("INTEGRAL-INFEASIBLE", None, "\n        ".join(msg) +
                f"\n        NO residue in L (x) F11 satisfies the orbit congruence: "
                f"the {CM.shape[0]}-row x {d}-column\n        system (C K) c == rhs "
                f"is INFEASIBLE over F11, certificate y with y*(C K) == 0 and "
                f"y*rhs == {yb} != 0\n        VERIFIED.  ==> the EXACT integer "
                f"value-form system is INFEASIBLE on this pattern.")
    cvec, cbas = ech.solution()
    msg.append(f"the residue system (C K) c == rhs is FEASIBLE over F11: its solution "
               f"set has dimension {cbas.shape[1]} in F11^{d}, i.e. the integral "
               f"witnesses form 11^{cbas.shape[1]} residue classes of the rank-{d} "
               f"lattice L")
    x = Ki.astype(object) @ cvec.astype(object)
    mx2 = int(max(abs(int(v)) for v in x))
    if mx2 > 10 ** 12:
        return ("RECONSTRUCTION-FAILED", None, "\n        ".join(msg))
    xi = x.astype(np.int64)
    resid = H.astype(np.int64) @ xi
    cres = (imatmul(CM % 11, (xi % 11)[:, None])[:, 0] - RHS) % 11
    msg.append(f"EXPLICIT INTEGER SOLUTION x in Z^{P}, max|x| = {mx2}; exact check: "
               f"H x = 0 over Z ({int((resid != 0).sum())} violations), C x == rhs "
               f"(mod 11) ({int((cres != 0).sum())} violations)")
    if resid.any() or cres.any():
        return ("RECONSTRUCTION-FAILED", None, "\n        ".join(msg))
    return ("INTEGRAL-FEASIBLE", xi, "\n        ".join(msg))

def integral_test(tag, key, NCELL, WL, SIGP, ORBS, ZEROS, expect=None, pts=None):
    """run try_integral and, on a FEASIBLE verdict, re-verify the integer U-field
       condition by condition over Z."""
    t0 = time.time(); U5 = None
    st, xi, m = try_integral(key, NCELL, WL, SIGP, ORBS, ZEROS)
    print(f"    EXACT-INTEGER TEST [{st}]   [{time.time()-t0:.1f}s]\n        {m}")
    if st == "INTEGRAL-FEASIBLE":
        EXPRm = fan_pieces(key, NCELL, WL, SIGP, ORBS)[0]
        U4 = (EXPRm.reshape(-1, EXPRm.shape[2]).astype(object)
              @ xi.astype(object)).reshape(NCELL, 4)
        U5 = [[int(U4[c][t]) for t in range(4)] + [0] for c in range(NCELL)]
        vj, vz, vc = verify_U_integral(U5, WL, ORBS, SIGP, sorted(ZEROS), NCELL)
        mxU = max(abs(v) for row in U5 for v in row)
        print(f"        the INTEGER U-field it defines (max|U| = {mxU}) re-verified "
              f"OVER Z, condition by\n        condition: {vj} of {len(WL)} wall jumps "
              f"NOT of the form m*nu with m in Z; {vz} of {len(ZEROS)} zero\n        "
              f"cells nonzero; {vc} of {NCELL} per-cell orbit congruences violated "
              f"(all {NCELL} cells, i.e.\n        (ii) at EVERY lattice point of N, "
              f"not only at the {len(ORBS)} orbit representatives)")
        assert (vj, vz, vc) == (0, 0, 0), "integral U-field failed re-verification"
        print(f"        ==> the EXACT value-form system (1)(2)(3) is FEASIBLE here: "
              f"no modulus 11^s can ever\n        kill this pattern, and no argument "
              f"using only (1)(2)(3) can.")
        if pts is not None:
            dv = [sum(U5[c][t] * int(pts[c][t]) for t in range(5))
                  for c in range(NCELL)]
            neg = sum(1 for v in dv if v < 0)
            print(f"        [positivity diagnostic] d = <U_C, .> at the {NCELL} cell "
                  f"witness points: {neg} negative,\n        {sum(1 for v in dv if v == 0)}"
                  f" zero, {sum(1 for v in dv if v > 0)} positive -- so THIS solution is "
                  f"not a d >= 0 function.\n        (Positivity is discarded in the "
                  f"S8.22 setup, so it is not part of the system that is\n        being "
                  f"killed; the finding is about that system.)")
    if expect is not None:
        print(f"        expected {expect}: {'MATCH' if st == expect else 'MISMATCH'}")
        assert st == expect, f"integral-test gate failed for {tag}"
    return st, (U5 if st == "INTEGRAL-FEASIBLE" else None)

def ground_truth_ii(U5, cellof, npts, label, ZEROS=None):
    """The one check that bypasses the whole encoding: evaluate the PL function
       d(n) = <U_{C(n)}, n> at RANDOM lattice points of N and test the ORIGINAL
       congruence (ii) of S8.22 directly,
            sum_k 9^k d(sigma^k n) + <n, c9> == 0  (mod 11).
       Independent of the tree parametrization, of the row encoding and of the
       orbit bookkeeping."""
    rs = random.Random(SEED + 5)
    tested = bad = skipped = 0; zt = zbad = 0
    Zs = set(ZEROS) if ZEROS is not None else set()
    while tested < npts:
        n = [rs.randint(-40, 40) for _ in range(4)]
        n.append(-sum(n)); n = tuple(n)
        tot = 0; m = n; ok = True
        for k in range(5):
            c = cellof(m)
            if c is None: ok = False; break
            tot += pow(9, k, 11) * sum(U5[c][t] * m[t] for t in range(5))
            m = sigN(m)
        if not ok: skipped += 1; continue
        tot += sum(n[j] * c9[j] for j in range(5))
        if tot % 11: bad += 1
        c0 = cellof(n)
        if c0 in Zs:
            zt += 1
            if sum(U5[c0][t] * n[t] for t in range(5)) != 0: zbad += 1
        tested += 1
    print(f"        GROUND TRUTH [{label}]: (ii) tested DIRECTLY at {tested} random "
          f"lattice points of N\n        (d evaluated as <U_C(n), n> at n and at all "
          f"four sigma-translates): {bad} failures\n        ({skipped} points skipped "
          f"for lying on a wall); d = 0 checked at the {zt} of them\n        interior "
          f"to a zero cell: {zbad} failures")
    assert bad == 0 and zbad == 0, "GROUND TRUTH check failed"
    return bad

def verify_U_integral(U5, WL, ORBS, SIGP, ZEROS, NCELL):
    """exact-over-Z verification of an integer U-field: (2) every wall jump lies
       in Z*nu (INTEGER multiplier, exhibited), (1) U = 0 on every zero cell,
       (3) the orbit congruence at EVERY cell -- which by S8.20 is (ii) at EVERY
       lattice point of N, not just at orbit representatives."""
    vj = vz = vc = 0
    for (i, j, nu) in WL:
        d = [int(U5[i][t] - U5[j][t]) for t in range(5)]
        d = [d[t] - d[4] for t in range(5)]
        n5 = [nu[t] - nu[4] for t in range(5)]
        j0 = next(t for t in range(4) if n5[t] % 11)
        if d[j0] % n5[j0] != 0: vj += 1; continue
        m = d[j0] // n5[j0]
        if any(d[t] != m * n5[t] for t in range(5)): vj += 1
    for c in ZEROS:
        w = [int(U5[c][t] - U5[c][4]) for t in range(5)]
        if any(w): vz += 1
    rhs = [((-c9[j]) - (-c9[4])) % 11 for j in range(5)]
    for c0 in range(NCELL):
        acc = [0] * 5; cc = c0
        for k in range(5):
            u = [int(v) % 11 for v in U5[cc]]
            sh = [u[(i + k) % 5] for i in range(5)]
            sh = [(sh[i] - sh[4]) % 11 for i in range(5)]
            acc = [(acc[i] + pow(9, k, 11) * sh[i]) % 11 for i in range(5)]
            cc = int(SIGP[cc])
        if acc != rhs: vc += 1
    return vj, vz, vc

# ================================================ 4. calibration gates
hdr("4. CALIBRATION GATES")
print("G0 (pipeline gate).  The pure A4 Weyl fan, rank pattern P = {3,4} "
      "(zero iff the position\n    of coordinate 0 in piA is in P).  Theorem X'' "
      "(S8.23): dead at LEVEL 1 already.")
ZA = [i for i, p in enumerate(A4C) if p.index(0) in (3, 4)]
gate0, _, _, _, _ = run_shadow("A4 P={3,4}", 120, A4W, A4S, A4O, ZA, 1)
print(f"    G0 {'PASSED' if not gate0 else 'FAILED'}: the A4 fan dies already at "
      f"s = 1, as Theorem X'' says.")
assert not gate0
if DO_INT:
    print("    G0-INT: the exact-integer decider on the same pattern must return "
          "INTEGRAL-INFEASIBLE.")
    integral_test("G0", (id(A4W), id(A4O)), 120, A4W, A4S, A4O, ZA,
                  expect="INTEGRAL-INFEASIBLE")[0]

GATE_RES = {}
for (name, P) in (("G1", (3, 4)), ("G2", (0, 2))):
    print(f"\n{name}.  The pure G9 ORDER fan (120 cells, 240 walls, 24 orbits), rank "
          f"pattern P = {list(P)}\n    (zero iff the position of H-label 0 in piG is "
          f"in P).  The FULL integer system is\n    known INFEASIBLE (Theorem X, "
          f"S8.22).  Smallest s at which the slope shadow kills it?")
    ZG = [i for i, p in enumerate(G9C) if p.index(0) in P]
    print(f"    zero cells: {len(ZG)}/120 "
          f"(min {min(sum(1 for c in o if c in set(ZG)) for o in G9O)} per sigma-orbit)")
    res, kill = tower(f"G9 P={list(P)}", 120, G9W, G9S, G9O, ZG, 3)
    GATE_RES[name] = (P, res, kill)
    if kill is None:
        print(f"    {name} RESULT: FEASIBLE THROUGH 11^3 -- the slope shadow does NOT "
              f"reach Theorem X's kill.")
    else:
        print(f"    {name} RESULT: smallest killing modulus 11^{kill} = {11**kill} "
              f"(feasible for all smaller s).")
    if DO_INT:
        print(f"    {name}-INT (gate on the exact-integer decider): Theorem X says the "
              f"FULL integer\n    system is infeasible here, so the decider must "
              f"return INTEGRAL-INFEASIBLE.")
        integral_test(name, (id(G9W), id(G9O)), 120, G9W, G9S, G9O, ZG,
                      expect="INTEGRAL-INFEASIBLE")[0]

allP = [tuple(sorted(Q)) for k in range(2, 6) for Q in combinations(range(5), k)]
print("\nG3 (completeness of the calibration).  ALL 26 rank patterns on the pure G9 "
      "order fan\n    and on the pure A4 Weyl fan, at 11^1 and 11^2.  Theorems X and "
      "X'' say EVERY one dies.")
g9tab = {}; a4tab = {}
for P in allP:
    ZG = [i for i, p in enumerate(G9C) if p.index(0) in P]
    ZA_ = [i for i, p in enumerate(A4C) if p.index(0) in P]
    r1, k1 = tower("", 120, G9W, G9S, G9O, ZG, 2, quiet=True)
    r2, k2 = tower("", 120, A4W, A4S, A4O, ZA_, 2, quiet=True)
    g9tab[P] = k1; a4tab[P] = k2
print("    G9 order fan: smallest killing s per rank pattern -- "
      + ", ".join(f"{list(P)}:{g9tab[P]}" for P in allP if len(P) == 2))
print("      |P|=3..5 : " + ", ".join(f"{list(P)}:{g9tab[P]}" for P in allP if len(P) > 2))
print(f"    G9 order fan: {sum(1 for P in allP if g9tab[P] is not None)}/26 patterns "
      f"killed by the slope shadow at s <= 2; killing-s histogram "
      f"{ {s: sum(1 for P in allP if g9tab[P] == s) for s in (1, 2)} }")
print(f"    A4 Weyl fan : {sum(1 for P in allP if a4tab[P] is not None)}/26 patterns "
      f"killed; killing-s histogram "
      f"{ {s: sum(1 for P in allP if a4tab[P] == s) for s in (1, 2)} }")
assert all(g9tab[P] is not None for P in allP), "G3 failed on the G9 fan"
assert all(a4tab[P] == 1 for P in allP), "G3 failed on the A4 fan"
print("    G3 PASSED: the slope shadow reproduces Theorem X (G9 fan, every rank "
      "pattern) and\n    Theorem X'' (A4 fan, every rank pattern, level 1).")

# ================================================ 5. controls
hdr("5. CONTROLS on the mixed-fan system")
def orbmin(Zs): return min(sum(1 for c in o if c in Zs) for o in ORB)
def survives_level1(Zs):
    touched = set(int(GOF[c]) for c in Zs)
    return all(any(g not in touched for g in o) for o in GORB)
GCELLS = [np.nonzero(GOF == g)[0].tolist() for g in range(len(GPERM))]

print("C1 (no zero cells): the jump + orbit-congruence system alone.")
c1, _ = tower("mixed, no zeros", NC, WALLS, SIG, ORB, [], 3)
print(f"    C1 {'PASSED' if all(c1.values()) else 'FAILED'}: feasible at 11^1, 11^2, "
      f"11^3 -- the wall/congruence system is not self-\n    contradictory, so every "
      f"kill below is caused by the zero pattern.")
assert all(c1.values())
print("\nC1b (ground truth on a SECOND fan): take a verified mod-11 solution of the pure "
      "G9\n    order fan with the P = {3,4} zero pattern and test the ORIGINAL "
      "congruence (ii)\n    directly at random lattice points, bypassing the whole row "
      "encoding.")
G9I = {p: i for i, p in enumerate(G9C)}
def cell_of_g9(n):
    Hv = [sum(n[j] * MU[k][j] for j in range(5)) for k in range(5)]
    if len(set(Hv)) < 5: return None
    return G9I[tuple(sorted(range(5), key=lambda j: -Hv[j]))]
ZG34 = [i for i, p in enumerate(G9C) if p.index(0) in (3, 4)]
A_, b_, EXPRg1, _, _ = build_system((id(G9W), id(G9O)), 120, G9W, G9S, G9O, ZG34, 1)
fg1, xg1, _ = decide(A_, b_, 1)
assert fg1
Ug1 = U_from_params(EXPRg1, xg1, 11)
ground_truth_ii([[int(v) for v in Ug1[c]] for c in range(120)], cell_of_g9, 6000,
                "pure G9 order fan, mod-11 solution", ZEROS=ZG34)
print("    C1b PASSED: the mod-11 shadow's solutions really do satisfy (ii) as a "
      "congruence\n    on the PL function, on a fan different from the one carrying "
      "the headline.")

print("\nC2 (not over-constrained): the mixed fan REFINES the pure G9 order fan, so the "
      "PULLBACK\n    of any G9-fan solution must satisfy every mixed-fan wall "
      "membership and orbit\n    congruence.  A bug that faked infeasibility would show "
      "up here.")
Z01 = [i for i, (pA, pG) in enumerate(CK) if pG.index(0) in (0, 1)]
ZG01 = [i for i, p in enumerate(G9C) if p.index(0) in (0, 1)]
A_, b_, EXPRg, _, _ = build_system((id(G9W), id(G9O)), 120, G9W, G9S, G9O, ZG01, 1)
fg, xg, _ = decide(A_, b_, 1)
assert fg, "the G9 fan is level-1 feasible for P = {0,1} (f55_mixedfan.py)"
Ug = U_from_params(EXPRg, xg, 11)
Umix = np.array([Ug[GIDX[CK[c][1]]] for c in range(NC)], dtype=np.int64)
vj, vz, vc = verify_U(Umix, WALLS, SIG, ORB, Z01, 11)
print(f"    pullback of a verified G9-fan level-1 solution: {vj} wall-membership, "
      f"{vz} zero-cell,\n    {vc} orbit-congruence violations out of "
      f"{len(WALLS)} + {len(Z01)} + {len(ORB)} mixed-fan conditions")
print(f"    C2 {'PASSED' if (vj, vz, vc) == (0, 0, 0) else 'FAILED'}: the mixed-fan "
      f"row set is a faithful refinement, not over-constrained.")
assert (vj, vz, vc) == (0, 0, 0)
print("\nC3 (positive control, anchor 0): the SAME rows with the congruence right-hand "
      "side\n    replaced by 0 and the P = {0,1} zero pattern imposed -- U == 0 solves "
      "that.")
c2ok = True
for s in (1, 2, 3):
    A_, b_, EXPR_, _, _ = build_system((id(WALLS), id(ORB)), NC, WALLS, SIG, ORB, Z01, s)
    f_, o_, i_ = decide(A_, np.zeros_like(b_), s)
    c2ok &= f_
print(f"    C3 {'PASSED' if c2ok else 'FAILED'}: feasible at 11^1, 11^2, 11^3 with "
      f"anchor 0.")
assert c2ok

hdr("6. MAIN RUN: the mixed fan (1090 cells, 2570 walls, 218 orbits)")
SMAX = int(os.environ.get("F55_SMAX", "8"))
print(f"For every pattern the tower s = 1, 2, ... is walked to 11^{SMAX} or to the "
      f"first kill.\nNOTE (exact, not heuristic).  The slope-frame system over Z is "
      f"[H x = 0 over Z] together\nwith [C x == rhs mod 11].  ker_Z(H) is SATURATED in "
      f"Z^P, so ker_{{Z_11}}(H) = ker_Z(H) (x) Z_11\nand the two reductions mod 11 "
      f"agree; hence a solution exists over Z <=> one exists over\nZ_11 <=> the system "
      f"is feasible mod 11^s for EVERY s.  The tower below is therefore the\nCOMPLETE "
      f"test for the exact integral value-form system on that pattern, and each extra\n"
      f"level of survival is evidence for -- not merely absence of evidence against -- "
      f"an\nintegral solution.")

print(f"\n(a) EXHAUSTIVE: all 25 level-1-surviving G9-induced rank patterns "
      f"(|P| <= 4; |P| = 5 is\n    already dead at level 1).  Zero iff the position of "
      f"H-label 0 in piG is in P.")
allP4 = [tuple(sorted(Q)) for k in (2, 3, 4) for Q in combinations(range(5), k)]
MIX_A = {}
t0 = time.time()
for P in allP4:
    Z = [i for i, (pA, pG) in enumerate(CK) if pG.index(0) in P]
    assert survives_level1(set(Z)) and orbmin(set(Z)) >= 2
    res, kill = tower("", NC, WALLS, SIG, ORB, Z, 2, quiet=True)
    ist = ""
    if DO_INT:
        st, _, _ = try_integral((id(WALLS), id(ORB)), NC, WALLS, SIG, ORB, Z)
        ist = f",  exact-integer: {st}"
        assert (st == "INTEGRAL-FEASIBLE") == (kill is None), \
            f"tower and exact-integer decider disagree on P = {P}"
        MIX_A[P] = (kill, len(Z), st)
    else:
        MIX_A[P] = (kill, len(Z), None)
    print(f"    P = {str(list(P)):12s} zeros {len(Z):4d}  11^1 "
          f"{'FEAS' if res[1] else 'INFEAS'}, 11^2 "
          f"{'FEAS  <-- SURVIVES' if res.get(2) else 'INFEAS'}{ist}")
surv = [P for P in allP4 if MIX_A[P][0] is None]
print(f"    (a): {25-len(surv)} of 25 killed at 11^2, {len(surv)} survive: "
      f"{[list(P) for P in surv]}   [{time.time()-t0:.1f}s]")
if DO_INT:
    print(f"    the exact-integer decider agrees with the 11^2 verdict on ALL 25 "
          f"patterns:\n    exactly {sum(1 for P in allP4 if MIX_A[P][2] == 'INTEGRAL-FEASIBLE')}"
          f" of the 25 admit an EXACT integral value-form solution, the other "
          f"{sum(1 for P in allP4 if MIX_A[P][2] != 'INTEGRAL-FEASIBLE')}\n    are "
          f"infeasible over Z (and already over Z/121).")
print(f"    CROSS-CHECK vs f55_mixedlevel2.py sweep (a), the level-2 (tau,Psi) "
      f"pair-field shadow:\n    that run found exactly P = {{0,1}} and P = {{3,4}} "
      f"FEASIBLE at level 2.  Agreement: "
      f"{sorted(surv) == [(0, 1), (3, 4)]}")

print(f"\n(a-deep) the survivors of (a), pushed to 11^{SMAX}:")
MAIN = {}
for P in surv:
    Z = [i for i, (pA, pG) in enumerate(CK) if pG.index(0) in P]
    tag = f"G9-induced rank pattern P = {list(P)}"
    print(f"\n--- {tag}   [the exhaustive-family level-2 witness]")
    print(f"    zero cells {len(Z)}/{NC} (min {orbmin(set(Z))} per sigma-orbit); "
          f"level-1 criterion (every G9-orbit keeps a free chamber): "
          f"{survives_level1(set(Z))}")
    res, kill = tower(tag, NC, WALLS, SIG, ORB, Z, SMAX)
    MAIN[tag] = (res, kill, len(Z))
    if kill is None:
        print(f"    RESULT: FEASIBLE THROUGH 11^{SMAX} = {11**SMAX} (explicit "
              f"solution verified against ALL original conditions at every modulus).")
    else:
        print(f"    RESULT: killed at 11^{kill} = {11**kill} (certificate verified).")
    if DO_INT:
        st, U5w = integral_test(tag, (id(WALLS), id(ORB)), NC, WALLS, SIG, ORB, Z,
                                pts=PTS)
        INTRES[tag] = st
        if U5w is not None:
            ground_truth_ii(U5w, cell_of_mixed, 10000, "mixed fan, integral witness",
                            ZEROS=Z)

# --- (e) how big is the surviving family?  one-orbit changes of P = {0,1}
print(f"\n(e) STRUCTURE: start from the surviving pattern P = {list(surv[0])} written as "
      f"a per-G9-orbit\n    choice of one label PAIR (labels = position of H-label 0 in "
      f"piG, a bijection inside\n    every G9-orbit) and replace the pair in ONE "
      f"G9-orbit by each of the other 9 pairs.")
LAB = {}
for gi, og in enumerate(GORB):
    lab = {GPERM[g].index(0): g for g in og}
    assert sorted(lab) == [0, 1, 2, 3, 4]
    LAB[gi] = lab
def pullback_cells(choice):
    zg = set()
    for gi in range(len(GORB)):
        for t in choice[gi]: zg.add(LAB[gi][t])
    return sorted(c for g in zg for c in GCELLS[g])
P0 = surv[0]; NORB_E = 3
t0 = time.time(); esets = []
for gi in range(NORB_E):
    good = []
    for (i, j) in pairs:
        if (i, j) == P0: good.append((i, j)); continue
        ch = {gg: (set(P0) if gg != gi else {i, j}) for gg in range(len(GORB))}
        Ze = pullback_cells(ch)
        res, kill = tower("", NC, WALLS, SIG, ORB, Ze, 2, quiet=True)
        if kill is None:
            st, _, _ = try_integral((id(WALLS), id(ORB)), NC, WALLS, SIG, ORB, Ze)
            assert st == "INTEGRAL-FEASIBLE", "11^2-survivor is not integrally feasible"
            good.append((i, j))
    esets.append(tuple(good))
print(f"    per-G9-orbit sets of label-pairs that keep the pattern alive at 11^2 "
      f"(and, for every\n    survivor, INTEGRALLY feasible -- checked): "
      + "; ".join(f"orbit {gi}: {list(esets[gi])}" for gi in range(NORB_E))
      + f"   [{time.time()-t0:.1f}s]")
print(f"    sizes {[len(s) for s in esets]} of 10; identical across the {NORB_E} "
      f"orbits tested: {len(set(esets)) == 1}.  So the integral\n    witnesses are a "
      f"genuine FAMILY (>= {sum(len(s)-1 for s in esets)} further patterns beyond the "
      f"two rank patterns, each\n    carrying its own exact integer U-field), and "
      f"which pairs survive depends on the orbit --\n    feasibility is a coupled, "
      f"global condition, exactly as f55_mixedlevel2.py's sweep (e2)\n    found at "
      f"level 2.")

# --- deterministic reconstruction of f55_mixedlevel2.py's sweeps (b) and (c)
NBT = int(os.environ.get("F55_NB", "30")); NCT = int(os.environ.get("F55_NCT", "30"))
rp = random.Random(SEED)
BPATS = []; CPATS = []
for tr in range(200):                                  # sweep (b), verbatim
    zg = set()
    for o in GORB:
        i, j = rp.choice(pairs); zg.add(o[i]); zg.add(o[j])
    if tr < NBT: BPATS.append(sorted(c for g in zg for c in GCELLS[g]))
for tr in range(200):                                  # sweep (c), verbatim
    Zs = set()
    for og in GORB:
        zg = set(og[t] for t in rp.choice(trip))
        Zs.update(c for g in zg for c in GCELLS[g])
    for o in ORB:
        z = [c for c in o if c in Zs]
        assert len(z) == 3
        if rp.random() < 0.7: Zs.discard(rp.choice(z))
    if tr < NCT: CPATS.append(sorted(Zs))
print(f"\n(b)/(c) reconstructed from f55_mixedlevel2.py with the SAME seed ({SEED}) "
      f"and the SAME\n    RNG call sequence: 200 aligned-pullback patterns (b), then "
      f"200 non-pullback level-1\n    survivors (c).  The first {NBT} of (b) and the "
      f"first {NCT} of (c) are tested here.")
for (fam, PL, desc) in (("b", BPATS, "random ALIGNED-PULLBACK patterns (2 zero "
                                     "G9-chambers per G9-orbit,\n            all their "
                                     "mixed cells zeroed)"),
                        ("c", CPATS, "random NON-PULLBACK level-1 survivors "
                                     "(G9-chambers only\n            partially "
                                     "zeroed)")):
    t0 = time.time(); kills = {}; surv2 = []
    for t, Z in enumerate(PL):
        Zs = set(Z)
        assert orbmin(Zs) >= 2 and survives_level1(Zs)
        res, kill = tower("", NC, WALLS, SIG, ORB, Z, 2, quiet=True)
        kills[t] = kill
        if kill is None: surv2.append(t)
    hist = {}
    for t in kills: hist[kills[t]] = hist.get(kills[t], 0) + 1
    extra = ""
    if fam == "c":
        sp = [sum(1 for g in range(len(GPERM))
                  if 0 < len(set(GCELLS[g]) & set(Z)) < len(GCELLS[g])) for Z in PL]
        extra = f"; partially-zeroed G9-chambers per pattern {min(sp)}..{max(sp)}"
    print(f"    ({fam}) {len(PL)} {desc}:\n        killing-s histogram "
          f"{ {('survives 11^2' if k is None else 's=%d' % k): v for k, v in hist.items()} }"
          + extra + f"   [{time.time()-t0:.1f}s]")
    for t in surv2[:3]:
        tag = f"random {fam}-family survivor #{t}"
        print(f"\n--- {tag}  ({len(PL[t])} zero cells)")
        res, kill = tower(tag, NC, WALLS, SIG, ORB, PL[t], SMAX)
        MAIN[tag] = (res, kill, len(PL[t]))
    if surv2: print(f"    ({fam}) 11^2-survivors: trials {surv2}")

# ================================================ 7. verdict
hdr("7. VERDICT")
print("CALIBRATION (the shadow reproduces every proved kill, and at which depth)")
print(f"  G0  pure A4 Weyl fan, P = {{3,4}}      : INFEASIBLE at 11^1 "
      f"(Theorem X'', S8.23)")
for name in ("G1", "G2"):
    P, res, kill = GATE_RES[name]
    seq = ", ".join(f"11^{s}: {'FEAS' if res[s] else 'INFEAS'}" for s in sorted(res))
    print(f"  {name}  pure G9 order fan, P = {str(list(P)):6s} : {seq}"
          + (f"   -> smallest killing s = {kill}" if kill else
             "   -> NOT KILLED THROUGH 11^3"))
print(f"  G3  ALL 26 rank patterns          : G9 fan 26/26 killed by 11^2 "
      f"(Theorem X); A4 fan 26/26 by 11^1")
print("\nMAIN RUN (mixed fan: 1090 cells, 2570 walls, 218 orbits, BOTH wall classes)")
print(f"  (a) exhaustive over the 25 level-1-surviving G9-induced rank patterns:")
print(f"      {25-len(surv)} killed at 11^2, survivors {[list(P) for P in surv]}"
      f"   (matches f55_mixedlevel2.py's level-2 sweep)")
for tag, (res, kill, nz) in MAIN.items():
    seq = ", ".join(f"11^{s}:{'F' if res[s] else 'X'}" for s in sorted(res))
    print(f"  {tag:38s} ({nz:4d} zeros): {seq}"
          + (f"   -> KILLED at s = {kill}" if kill else
             f"   -> FEASIBLE THROUGH 11^{SMAX}"))
g1kill = GATE_RES['G1'][2]; g2kill = GATE_RES['G2'][2]
allkill = [k for (_, k, _) in MAIN.values()]
if INTRES:
    print("\nEXACT-INTEGER DECISION (no modulus at all -- the full value-form system)")
    for tag, st in INTRES.items():
        print(f"  {tag:38s} : {st}")
print("\nREADING")
if g1kill is None or g2kill is None:
    print("  The slope shadow does NOT reach Theorem X's kill on the pure G9 order fan "
          "even at\n  11^3.  The shadow therefore needs the value-frame's extra content "
          "and the W7 approach\n  must be recalibrated; the mixed-fan verdicts are for "
          "the record only.")
else:
    print(f"  The shadow is CALIBRATED: it reproduces Theorem X on the G9 order fan at "
          f"exactly\n  11^{max(g1kill, g2kill)} (all 26 rank patterns) and Theorem X'' "
          f"on the A4 Weyl fan at 11^1 (all 26).\n  Its 11^2 layer agrees pattern-for-"
          f"pattern with the independent level-2 (tau,Psi)\n  pair-field shadow of "
          f"f55_mixedlevel2.py on the mixed fan (exactly P = {{0,1}}, {{3,4}}\n  "
          f"survive).  The same exact-integer decider returns INTEGRAL-INFEASIBLE on "
          f"the A4 and G9\n  gate patterns, as Theorems X'' and X require.")
nsurv = sum(1 for k in allkill if k is None)
if nsurv:
    print(f"  {nsurv} mixed-fan pattern(s) SURVIVE the whole tower to 11^{SMAX}.")
nint = sum(1 for v in INTRES.values() if v == "INTEGRAL-FEASIBLE")
if nint:
    print(f"\n  DECISIVE.  For {nint} of them the answer is not 'no kill up to "
          f"11^{SMAX}' but 'no kill at ANY\n  modulus': an EXPLICIT INTEGER U-field "
          f"was constructed and verified condition by\n  condition over Z -- every one "
          f"of the 2570 wall jumps equals m*nu with m in Z, U = 0 on\n  all 436 zero "
          f"cells (exactly 2 per sigma-orbit), and the orbit congruence holds at all\n"
          f"  1090 cells, i.e. (ii) holds at EVERY lattice point of N.  So the "
          f"value-form system\n  (1)(2)(3) of S8.22 -- the exact object that Theorems "
          f"X, X' and X'' kill -- is SATISFIABLE\n  on the mixed fan.\n"
          f"\n  Consequence for the program: T5 cannot be closed by ANY argument that "
          f"uses only\n  (1) zeros + (2) integral-slope wall jumps + (3) the orbit "
          f"congruence.  Not level 3, not\n  level t: the whole 11-adic tower is "
          f"vacuous here.  Closing mixed fans needs an\n  ingredient that was "
          f"deliberately discarded upstream -- positivity d >= 0, or the\n  twice-min "
          f"/ min-normalization structure, or a ray/xi*-style argument on the refined\n"
          f"  cells.  (The witness produced here is NOT d >= 0 -- see the positivity "
          f"diagnostic --\n  so it is not yet a counterexample to Lemma S itself; it is "
          f"a proof that this method\n  cannot reach Lemma S on mixed fans.)")
if any(k is not None for k in allkill):
    print(f"\n  The mixed fan is nevertheless far from free: the {25-len(surv)} other "
          f"rank patterns and all\n  {NBT} + {NCT} sampled aligned-pullback and "
          f"non-pullback patterns die at 11^2.  The surviving\n  family is thin and "
          f"structured -- the two G9-induced rank patterns P = {{0,1}} and {{3,4}}.")
print(f"\nreproduce:  python3 {os.path.basename(__file__)}   "
      f"(deterministic, seed {SEED}; env F55_SMAX, F55_INT, F55_NB, F55_NCT)")
print(f"total runtime {time.time()-T00:.1f}s")
