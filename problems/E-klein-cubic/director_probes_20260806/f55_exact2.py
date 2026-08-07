#!/usr/bin/env python3
# T0/T1 support: the EXACT level-2 system on the G9-fan, no sampling.
#
# Derivation being verified here (then used for the hand unwinding):
#   On the G9-fan, H_a(n) = <sig^a n, G9> == 5^a * V0 (mod 11), V0 = <n,G9>,
#   because sig^{-1}G9 == 5*G9 (mod 11).  Hence at a lattice point n with
#   rank-chamber pi (ordering of H-values, descending) and sorted gaps
#   g_j = W_j - W_{j+1}:  g_j == (G9[pi[j-1]] - G9[pi[j]]) * V0 (mod 11).
#   The level-2 congruence row (the "level-121" rows of f55_sweep2.py) at n:
#       sum_S (11 r_S) w_S == -<n, c9>  (mod 11),
#   with r_S = sum_k 9^k [d_row(sig^k n)]_S, is therefore V0-linear and
#   depends mod 11 on pi alone; dividing by V0 (nonzero anchors) leaves
#   ONE row per chamber, RHS == -4.  Row structure: ray S gets a single
#   term iff S ~ pi[:|S|] cyclically (shift k_S admissible), coefficient
#   9^{k_S} * (G9[pi[|S|-1]] - G9[pi[|S|]]) * inv5.  Rows are sig-invariant
#   (9*5 == 45 == 1 mod 11): only 24 distinct rows (chamber sig-orbits).
#
# This script:
#   (1) computes RAYGAPs (checks v11(R_S) = 1 exactly),
#   (2) verifies the chamber-formula against the sampled d_row pipeline
#       (fresh seed, independent of the committed run's seed 9),
#   (3) builds the exact 24-row system for EVERY surviving rank-pattern P
#       (complete enumeration, no sampling), reports infeasibility,
#   (4) extracts ALL minimal Farkas certificates (subset search) for the
#       canonical pattern P = {3,4} and one per other pattern,
#   (5) prints full provenance for the unwinding.
from fractions import Fraction as Fr
from itertools import combinations, permutations
from math import gcd
import random

G9 = (1, 5, 3, 4, 9)
def sigN(n): return tuple(n[(j - 1) % 5] for j in range(5))
def H(k, n):
    m = n
    for _ in range(k): m = sigN(m)
    return sum(m[j] * G9[j] for j in range(5))
c9 = (4, 9, 1, 5, 3)
def c9pair(n): return sum(n[j] * c9[j] for j in range(5))
inv5 = 9  # 5*9 = 45 == 1 (mod 11)

# ---- rays of the G9-fan (from f55_sweep2.py, same construction) ----
def solve_ray(S):
    Sl = sorted(S); Cl = sorted(set(range(5)) - S)
    def Hrow(k):
        row = []
        for i in range(5):
            e = [0]*5; e[i] = 1
            row.append(H(k, tuple(e)))
        return row
    A = [[Fr(1)]*5]; b = [Fr(0)]
    for a in Sl[1:]:
        A.append([Fr(x - y) for x, y in zip(Hrow(a), Hrow(Sl[0]))]); b.append(Fr(0))
    for a in Cl[1:]:
        A.append([Fr(x - y) for x, y in zip(Hrow(a), Hrow(Cl[0]))]); b.append(Fr(0))
    A.append([Fr(x - y) for x, y in zip(Hrow(Sl[0]), Hrow(Cl[0]))]); b.append(Fr(55))
    M = [row[:] + [b[i]] for i, row in enumerate(A)]
    for col in range(5):
        pr = next(r for r in range(col, len(M)) if M[r][col] != 0)
        M[col], M[pr] = M[pr], M[col]
        pv = M[col][col]
        M[col] = [v / pv for v in M[col]]
        for r in range(len(M)):
            if r != col and M[r][col] != 0:
                f = M[r][col]
                M[r] = [v - f * w for v, w in zip(M[r], M[col])]
    n = [M[r][5] for r in range(5)]
    L = 1
    for v in n: L = L * v.denominator // gcd(L, v.denominator)
    ni = [int(v * L) for v in n]
    g = 0
    for v in ni: g = gcd(g, v)
    ni = [v // g for v in ni]
    if H(next(iter(S)), tuple(ni)) < H(next(iter(set(range(5)) - S)), tuple(ni)):
        ni = [-v for v in ni]
    return tuple(ni)

ALLS = [frozenset(S) for k in (1, 2, 3, 4) for S in combinations(range(5), k)]
RAY = {S: solve_ray(set(S)) for S in ALLS}
RAYGAP = {}
for S in ALLS:
    r = RAY[S]
    RAYGAP[S] = H(next(iter(S)), r) - H(next(iter(set(range(5)) - set(S))), r)
gapvals = sorted(set(RAYGAP.values()))
print("RAYGAP values over all 30 rays:", gapvals)
assert all(g % 11 == 0 and (g // 11) % 11 != 0 for g in gapvals), \
    "v11(RAYGAP) must be exactly 1 for the level-2 normalization"

def rank_pattern(n):
    vals = sorted([(H(k, n), k) for k in range(5)], reverse=True)
    return [k for _, k in vals], [v for v, _ in vals]

# ---- free rays for a rank-pattern P (zero-region: pos of H_0 in P) ----
def free_rays(P):
    out = []
    for S in ALLS:
        if 0 in S:
            bordered = any(p < len(S) for p in P)
        else:
            bordered = any(p >= len(S) for p in P)
        if not bordered:
            out.append(S)
    return out

# check free-ray rule against the sweep2 brute-force definition
def free_rays_brute(P):
    freeS = []
    for S in ALLS:
        bordered = False
        for pi in permutations(range(5)):
            if frozenset(pi[:len(S)]) == S and pi.index(0) in P:
                bordered = True; break
        if not bordered: freeS.append(S)
    return freeS
for P in [frozenset(x) for x in [(3,4),(0,1),(1,2,3),(0,1,2,3)]]:
    assert set(free_rays(P)) == set(free_rays_brute(P)), P
print("free-ray rule verified against brute force")

# ---- the exact chamber row ----
def cyc_shift_match(T, S):
    # k with T - k = S (at most one for |T| in 1..4); None if no match
    for k in range(5):
        if frozenset((t - k) % 5 for t in T) == S:
            return k
    return None

def chamber_row(pi, P, FREE):
    # row over FREE rays for the normalized (V0 = 1) level-2 congruence; rhs -4
    Z = {k for k in range(5) if pi.index(k) in P}
    row = {}
    for j in range(1, 5):
        T = frozenset(pi[:j])
        dG = (G9[pi[j - 1]] - G9[pi[j]]) if j < 5 else None
        for S in FREE:
            if len(S) != j: continue
            k = cyc_shift_match(T, S)
            if k is None or k in Z: continue
            row[S] = (row.get(S, 0) + pow(9, k, 11) * dG * inv5) % 11
    return row

# ---- verification of the chamber formula against the d_row pipeline ----
def d_row(n, P, FREE, idx):
    order, vals = rank_pattern(n)
    pi = tuple(order)
    if pi.index(0) in P: return {}
    row = {}
    for k in range(1, 5):
        S = frozenset(order[:k])
        gap = vals[k - 1] - vals[k]
        if gap == 0 or S not in idx: continue
        row[S] = row.get(S, Fr(0)) + Fr(gap, RAYGAP[S])
    return row

def sampled_level2_row(n, P, FREE, idx):
    # returns (dict S -> coeff mod 11, rhs mod 11) or None if v11(L) != 1
    row = {}
    for k in range(5):
        m = n
        for _ in range(k): m = sigN(m)
        for S, cf in d_row(m, P, FREE, idx).items():
            row[S] = row.get(S, Fr(0)) + (9 ** k) * cf
    L = 1
    for cf in row.values(): L = L * cf.denominator // gcd(L, cf.denominator)
    v11 = 0; LL = L
    while LL % 11 == 0: LL //= 11; v11 += 1
    if v11 != 1: return None
    u = LL  # L = 11*u, gcd(u,11)=1
    uinv = pow(u % 11, 9, 11)
    out = {}
    for S, cf in row.items():
        # (L*cf mod 11) * u^{-1} = (11*cf) reduced mod 11
        out[S] = (int(cf * L) * uinv) % 11
    rhs = (-c9pair(n)) % 11
    return out, rhs

def verify_formula(P, trials=4000, seed=20260807):
    FREE = free_rays(P); idx = {S: i for i, S in enumerate(FREE)}
    rng = random.Random(seed)
    checked = 0
    for _ in range(trials):
        n = [rng.randint(-9, 9) for _ in range(5)]
        n[4] -= sum(n)
        n = tuple(n)
        order, vals = rank_pattern(n)
        if len(set(vals)) < 5: continue  # avoid ties (boundary): chamber interior only
        got = sampled_level2_row(n, P, FREE, idx)
        V0 = H(0, n) % 11
        pi = tuple(order)
        pred_row = chamber_row(pi, P, FREE)
        if got is None:
            # v11(L) != 1: happens iff all coefficients' 11s cancel;
            # formula predicts row == 0 mod 11 then (V0 == 0 kills too)
            continue
        grow, grhs = got
        ok = all(grow.get(S, 0) % 11 == (V0 * pred_row.get(S, 0)) % 11 for S in FREE)
        ok = ok and grhs % 11 == (-4 * V0) % 11
        if not ok:
            print("MISMATCH at n =", n, "pi =", pi, "V0 =", V0)
            print("  sampled:", {tuple(sorted(S)): grow.get(S, 0) for S in FREE}, grhs)
            print("  formula:", {tuple(sorted(S)): (V0*pred_row.get(S,0))%11 for S in FREE},
                  (-4*V0) % 11)
            return False
        checked += 1
    print(f"P={sorted(P)}: chamber formula verified at {checked} interior lattice points")
    return True

# ---- sig-invariance of rows (exact check) ----
def check_sig_invariance(P):
    FREE = free_rays(P)
    for pi in permutations(range(5)):
        r1 = chamber_row(pi, P, FREE)
        pi2 = tuple((p + 1) % 5 for p in pi)
        r2 = chamber_row(pi2, P, FREE)
        if r1 != r2: return False
    return True

# ---- exact 24-row system, infeasibility, minimal certificates ----
def orbit_reps():
    reps = []
    seen = set()
    for pi in permutations(range(5)):
        if pi in seen: continue
        orb = []
        q = pi
        for _ in range(5):
            orb.append(q); q = tuple((p + 1) % 5 for p in q)
        seen.update(orb)
        reps.append(pi)
    return reps

REPS = orbit_reps()
assert len(REPS) == 24

def exact_system(P):
    FREE = free_rays(P)
    idx = {S: i for i, S in enumerate(FREE)}
    rows = []
    for pi in REPS:
        r = chamber_row(pi, P, FREE)
        vec = [0] * len(FREE)
        for S, c in r.items(): vec[idx[S]] = c % 11
        rows.append((pi, vec, (-4) % 11))
    return FREE, rows

def rankF11(mat):
    A = [r[:] for r in mat]
    m = len(A); n = len(A[0]) if A else 0
    r0 = 0
    for col in range(n):
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
    return r0

def feasible(rows, nf):
    A = [vec + [rhs] for _, vec, rhs in rows]
    ra = rankF11([vec for _, vec, rhs in rows]) if rows else 0
    rb = rankF11(A) if rows else 0
    return rb == ra, ra, rb

def min_certificates(rows, nf, maxsize=5, maxprint=6):
    # all minimal-size subsets T with coefficient-rank < augmented-rank
    found = []
    for size in range(1, maxsize + 1):
        for T in combinations(range(len(rows)), size):
            sub = [rows[i] for i in T]
            ok, ra, rb = feasible(sub, nf)
            if not ok:
                # solve for the certificate coefficients: y with y^T A = 0, y^T b != 0
                # kernel of A^T restricted to T
                A = [list(rows[i][1]) for i in T]
                m = len(T)
                # find y in F11^m with sum y_i A[i] = 0, sum y_i b_i != 0
                # basis of left kernel: kernel of A^T (nf x m)
                AT = [[A[i][j] for i in range(m)] for j in range(nf)]
                # gaussian on AT
                M = [r[:] for r in AT]
                piv = []; r0 = 0
                for col in range(m):
                    pr = next((i for i in range(r0, nf) if M[i][col] % 11), None)
                    if pr is None: continue
                    M[r0], M[pr] = M[pr], M[r0]
                    inv = pow(M[r0][col], 9, 11)
                    M[r0] = [(x * inv) % 11 for x in M[r0]]
                    for i in range(nf):
                        if i != r0 and M[i][col] % 11:
                            f = M[i][col]
                            M[i] = [(x - f * y) % 11 for x, y in zip(M[i], M[r0])]
                    piv.append(col); r0 += 1
                freec = [c for c in range(m) if c not in piv]
                for fcol in freec:
                    y = [0] * m; y[fcol] = 1
                    for rr, pc in enumerate(piv):
                        y[pc] = (-M[rr][fcol]) % 11
                    by = sum(y[i] * rows[T[i]][2] for i in range(m)) % 11
                    if by:
                        found.append((T, y, by))
                        break
        if found:
            return size, found[:maxprint]
    return None, []

# ================== run ==================
print("\n== formula verification (fresh seeds) ==")
allP = [frozenset(P) for sz in range(2, 6) for P in combinations(range(5), sz)]
for P in [frozenset({3, 4}), frozenset({0, 1}), frozenset({1, 2, 3})]:
    assert verify_formula(P)
print("sig-invariance of chamber rows:", all(check_sig_invariance(frozenset(p))
      for p in [(3, 4), (0, 1), (1, 3)]))

print("\n== exact 24-row systems, all rank-patterns ==")
summary = []
for P in allP:
    FREE, rows = exact_system(P)
    nf = len(FREE)
    if nf == 0:
        summary.append((sorted(P), 0, "no free rays"))
        print(f"P = {sorted(P)}: no free rays (anchors violated at level 1)")
        continue
    ok, ra, rb = feasible(rows, nf)
    verdict = "FEASIBLE (!!)" if ok else "infeasible"
    summary.append((sorted(P), nf, verdict))
    print(f"P = {sorted(P)}: {nf} free rays, 24 exact rows, coeff-rank {ra}, "
          f"aug-rank {rb} -> {verdict}")

print("\n== minimal certificates, canonical P = {3,4} ==")
P0 = frozenset({3, 4})
FREE, rows = exact_system(P0)
nf = len(FREE)
size, certs = min_certificates(rows, nf, maxsize=5)
print(f"minimal certificate size: {size}; showing up to {len(certs)}:")
for T, y, by in certs:
    print(f"  rows {[rows[i][0] for i in T]} coeffs {y}  =>  0 = {by} (mod 11)")
    for i, yi in zip(T, y):
        pi, vec, rhs = rows[i]
        pos0 = pi.index(0)
        zr = {k for k in range(5) if pi.index(k) in P0}
        nz = {tuple(sorted(S)): chamber_row(pi, P0, FREE)[S]
              for S in chamber_row(pi, P0, FREE)}
        print(f"    y={yi} chamber pi={pi} (H_0 rank {pos0}, zero-translates k in {sorted(zr)}) row: {nz}")

print("\n== minimal certificates for the other surviving patterns ==")
for P in allP:
    if P == P0: continue
    FREE, rows = exact_system(P)
    nf = len(FREE)
    if nf == 0: continue
    size, certs = min_certificates(rows, nf, maxsize=5, maxprint=1)
    if size is None:
        print(f"P = {sorted(P)}: no certificate up to size 5")
    else:
        T, y, by = certs[0]
        print(f"P = {sorted(P)}: min cert size {size}: chambers "
              f"{[rows[i][0] for i in T]} coeffs {y} rhs-sum {by}")
