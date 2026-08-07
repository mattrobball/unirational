#!/usr/bin/env python3
# The H-fan candidate for refuting Lemma S.
# d: PL on the fan of orderings of (H_0..H_4), H_k(n) = <sig^k n, G9>,
# G9 = (1,5,3,4,9).  Zero-regions: rank of H_0 in {4th, 5th}.  Then every
# ray whose block-set S misses 0, or has |S| = 4, borders a zero-region:
# d = 0 there.  Free unknowns: v_S for S containing 0, |S| <= 3 (11 rays).
# Conditions: (ii) Sum_k 9^k d(sig^k n) + <n, c9> = 0 mod 11 at all lattice n;
# d integer-valued on N.  Search v mod 11 from sampled congruences; verify.
from fractions import Fraction as Fr
from itertools import combinations
import random

G9 = (1, 5, 3, 4, 9)
def sigN(n): return tuple(n[(j - 1) % 5] for j in range(5))
def H(k, n):
    m = n
    for _ in range(k): m = sigN(m)
    return sum(m[j] * G9[j] for j in range(5))
c9 = (4, 9, 1, 5, 3)   # c9 = 4*G9-class; <n, c9> with representative
def c9pair(n): return sum(n[j] * c9[j] for j in range(5))

# free rays: S containing 0, |S| <= 3; ray_S in N: H_a equal on S, on S^c,
# block values (5-|S|)*t, -|S|*t scaled primitive.  Solve for the actual
# vector: need n with H_a(n) = A for a in S, H_a(n) = B else, sum cond.
# H_a(n) = <n, sig_L^{-a}-transported G9>: linear system in n (4 dof).
import itertools
def solve_ray(S):
    # unknown n in Q^5, sum n = 0; equations: H_a(n) - H_b(n) = 0 within
    # S and within complement; normalize H_in - H_out = 5 (say). Solve.
    A = []
    b = []
    Sl = sorted(S); Cl = sorted(set(range(5)) - S)
    rowsum = [1]*5
    A.append(rowsum); b.append(Fr(0))
    def Hrow(k):
        m = [0]*5
        # H_k(n) = sum_j n[(j-k)%5]*G9[j]?? implement via basis vectors
        row = []
        for i in range(5):
            e = [0]*5; e[i] = 1
            row.append(H(k, tuple(e)))
        return row
    for a in Sl[1:]:
        A.append([x - y for x, y in zip(Hrow(a), Hrow(Sl[0]))]); b.append(Fr(0))
    for a in Cl[1:]:
        A.append([x - y for x, y in zip(Hrow(a), Hrow(Cl[0]))]); b.append(Fr(0))
    A.append([x - y for x, y in zip(Hrow(Sl[0]), Hrow(Cl[0]))]); b.append(Fr(55))
    # solve 5x5
    M = [[Fr(v) for v in row] + [b[i]] for i, row in enumerate(A)]
    nvar = 5
    for col in range(nvar):
        pr = next(r for r in range(col, len(M)) if M[r][col] != 0)
        M[col], M[pr] = M[pr], M[col]
        pv = M[col][col]
        M[col] = [v / pv for v in M[col]]
        for r in range(len(M)):
            if r != col and M[r][col] != 0:
                f = M[r][col]
                M[r] = [v - f * w for v, w in zip(M[r], M[col])]
    n = [M[r][5] for r in range(5)]
    # scale to primitive integer
    from math import gcd
    L = 1
    for v in n: L = L * v.denominator // gcd(L, v.denominator)
    ni = [int(v * L) for v in n]
    g = 0
    for v in ni: g = gcd(g, v)
    ni = [v // g for v in ni]
    # orient: H_in > H_out
    if H(next(iter(S)), tuple(ni)) < H(next(iter(set(range(5)) - S)), tuple(ni)):
        ni = [-v for v in ni]
    return tuple(ni)

FREE = []
for size in (1, 2, 3):
    for S in combinations(range(5), size):
        if 0 in S:
            FREE.append(frozenset(S))
RAY = {S: solve_ray(set(S)) for S in FREE}
print("free rays:", {tuple(sorted(S)): RAY[S] for S in FREE})

def rank_pattern(n):
    vals = [(H(k, n), k) for k in range(5)]
    vals.sort(reverse=True)
    return [k for _, k in vals], [v for v, _ in vals]

def d_row(n):
    # returns dict S -> rational coeff, so that d(n) = sum coeff * v_S,
    # for n in the closure of positive regions; d = 0 if H_0 ranks 4th/5th.
    order, vals = rank_pattern(n)
    # position of 0:
    pos0 = order.index(0)
    if pos0 >= 3 and vals[pos0] < vals[2]:
        return {}
    if pos0 >= 3:  # tied boundary: d = 0 anyway by continuity
        return {}
    # region: prefix sets of the ordering (handle ties by grouping: use any
    # compatible full ordering; for generic n no ties)
    row = {}
    rem = n
    # express n = sum alpha_k ray_{prefix_k}; alpha from H-value gaps:
    # H-profile of ray_{S}: in = (5-|S|)*w, out = -|S|*w for its scale w_S.
    # Solve greedily: alpha_k = (V_k - V_{k+1}) / (gap of ray_prefix_k)
    for k in range(1, 5):
        S = frozenset(order[:k])
        gap = vals[k - 1] - vals[k]
        if gap == 0: continue
        r = RAY.get(S)
        if r is None:
            # ray not free: value 0; skip coefficient
            # still need the H-gap bookkeeping: compute ray gap for scaling
            r2 = solve_ray(set(S))
            hin = H(next(iter(S)), r2); hout = H(next(iter(set(range(5)) - S)), r2)
            continue
        hin = H(next(iter(S)), r); hout = H(next(iter(set(range(5)) - set(S))), r)
        alpha = Fr(gap, hin - hout)
        row[S] = row.get(S, Fr(0)) + alpha
    return row

# sanity: reconstruct H-profile? Instead directly test linearity: d defined as
# above is the unique PL function with values v_S at free rays, 0 at others.
# Collect congruences: for random lattice n: sum_k 9^k d(sig^k n) + <n,c9> = 0 mod 11.
# d(sig^k n) row via d_row.  Values v_S are unknown INTEGERS.
random.seed(1)
CONG = []
for _ in range(300):
    n = [random.randint(-8, 8) for _ in range(5)]
    n[4] -= sum(n)  # make sum zero? N = sum-zero lattice
    n = tuple(n)
    if sum(n) != 0: continue
    row = {}
    constt = c9pair(n)
    ok = True
    denom_lcm = 1
    from math import gcd as _g
    for k in range(5):
        m = n
        for _ in range(k): m = sigN(m)
        rr = d_row(m)
        for S, cf in rr.items():
            row[S] = row.get(S, Fr(0)) + (9 ** k) * cf
    # need all coefficients integral mod ... they are rational; congruence must
    # be tested after clearing denominators COPRIME to 11 (else skip)
    L = 1
    for cf in row.values():
        L = L * cf.denominator // _g(L, cf.denominator)
    if L % 11 == 0: continue
    Li = pow(L % 11, 9, 11)  # inverse of L mod 11
    cong = {S: (int(cf * L) * Li) % 11 for S, cf in row.items()}
    rhs = (-constt * L * Li) % 11
    CONG.append((cong, rhs))
print("congruences collected:", len(CONG))
# solve for v_S mod 11
idx = {S: i for i, S in enumerate(FREE)}
A = []
for cong, rhs in CONG:
    row = [0] * 11
    for S, cf in cong.items(): row[idx[S]] = cf % 11
    A.append(row + [rhs % 11])
r0 = 0; piv = []
for col in range(11):
    pr = next((i for i in range(r0, len(A)) if A[i][col] % 11), None)
    if pr is None: continue
    A[r0], A[pr] = A[pr], A[r0]
    inv = pow(A[r0][col], 9, 11)
    A[r0] = [(v * inv) % 11 for v in A[r0]]
    for i in range(len(A)):
        if i != r0 and A[i][col] % 11:
            f = A[i][col]
            A[i] = [(v - f * w) % 11 for v, w in zip(A[i], A[r0])]
    piv.append(col); r0 += 1
cons = all(A[i][11] % 11 == 0 for i in range(r0, len(A)))
print(f"congruence system: rank {r0} of 11 unknowns, consistent: {cons}")
if cons:
    v = [0] * 11
    for i, col in enumerate(piv): v[col] = A[i][11]
    print("solution v_S mod 11:", {tuple(sorted(S)): v[idx[S]] for S in FREE})

# ---- FULL integral system: conditions (a) d(n) in Z and (b) mod-11 (ii) ----
# Solve over Z for v in Z^11 via congruence accumulation mod 121 (safety) and 5.
random.seed(4)
MOD = 121 * 5
rowsZ = []   # (coeffs mod MOD, rhs mod MOD) representing L*(condition) = 0 mod L-scaled
from math import gcd as _g
count_a = count_b = 0
for _ in range(4000):
    n = [random.randint(-6, 6) for _ in range(5)]
    n[4] -= sum(n)
    n = tuple(n)
    # (a): d(sig^k n) integral for each k
    for k in range(5):
        m = n
        for _ in range(k): m = sigN(m)
        rr = d_row(m)
        if not rr: continue
        L = 1
        for cf in rr.values(): L = L * cf.denominator // _g(L, cf.denominator)
        if L == 1: continue
        row = [0] * 11
        for S, cf in rr.items(): row[idx[S]] = int(cf * L) % (L if L else 1)
        # condition: sum row*v = 0 mod L
        # embed mod MOD via scaling: keep as (row mod L, 0, modulus L)
        rowsZ.append((row, 0, L)); count_a += 1
    # (b): sum 9^k d + <n,c9> = 0 mod 11
    row = {}
    for k in range(5):
        m = n
        for _ in range(k): m = sigN(m)
        for S, cf in d_row(m).items():
            row[S] = row.get(S, Fr(0)) + (9 ** k) * cf
    L = 1
    for cf in row.values(): L = L * cf.denominator // _g(L, cf.denominator)
    # condition: sum (L*cf) v + L*<n,c9> = 0 mod 11*L
    r2 = [0] * 11
    for S, cf in row.items(): r2[idx[S]] = int(cf * L) % (11 * L)
    rowsZ.append((r2, (c9pair(n) * L) % (11 * L), 11 * L)); count_b += 1
print("conditions: a =", count_a, " b =", count_b)
# Solve the simultaneous congruences by CRT-free approach: search v in a box?
# 11 unknowns; try mod-55 exhaustive on a reduced basis: first solve mod 5 and
# mod 11 and mod 121 separately via linear algebra.
def solve_mod(p):
    A = []
    for row, rhs, L in rowsZ:
        if L % p: continue
        # condition holds mod p component: (row.v + rhs) = 0 mod p requires
        # extracting: original condition: row.v + rhs = 0 mod L; reduce mod p
        A.append([x % p for x in row] + [(-rhs) % p])
    r0 = 0; piv = []
    for col in range(11):
        pr = next((i for i in range(r0, len(A)) if A[i][col] % p), None)
        if pr is None: continue
        A[r0], A[pr] = A[pr], A[r0]
        inv = pow(A[r0][col], p - 2, p)
        A[r0] = [(x * inv) % p for x in A[r0]]
        for i in range(len(A)):
            if i != r0 and A[i][col] % p:
                f = A[i][col]
                A[i] = [(x - f * y) % p for x, y in zip(A[i], A[r0])]
        piv.append(col); r0 += 1
    cons = all(A[i][11] % p == 0 for i in range(r0, len(A)))
    sol = None
    if cons:
        sol = [0] * 11
        for i, col in enumerate(piv): sol[col] = A[i][11]
    return cons, r0, sol, [c for c in range(11) if c not in piv]
for p in (5, 11):
    cons, rk, sol, free = solve_mod(p)
    print(f"mod {p}: rank {rk}, consistent {cons}, particular {sol}, free {len(free)}")

# ---- 11-adic tower: v = 11 w; do the (b)-conditions survive at level 121? ----
def solve_mod121():
    p = 11
    A = []
    for row, rhs, L in rowsZ:
        v11 = 0; LL = L
        while LL % 11 == 0: LL //= 11; v11 += 1
        # condition: row.v + rhs = 0 (mod modulus), modulus = L or 11L per type
        # For b-type rows modulus = 11*L_orig... we stored modulus in L field.
        # substitute v = 11 w: row.(11w) + rhs = 0 mod L  ->  11*(row.w) = -rhs mod L
        # solvable only if gcd(11, L) | rhs appropriately; reduce to w mod 11:
        # keep rows where 11^2 | L (these constrain w mod 11):
        if L % 121 == 0:
            # 11 row.w = -rhs mod 121-part: need rhs = 0 mod 11 first (checked),
            # then row.w = -rhs/11 mod 11
            if rhs % 11 != 0:
                return "IMMEDIATE INCONSISTENCY: rhs not divisible by 11", None
            A.append([x % 11 for x in row] + [(-(rhs // 11)) % 11])
        elif L % 11 == 0:
            # 11 row.w = -rhs mod 11*M-part: mod 11: 0 = -rhs mod 11 => rhs = 0 mod 11
            if rhs % 11 != 0:
                return "INCONSISTENT at level 11 after substitution", None
    r0 = 0
    piv = []
    for col in range(11):
        pr = next((i for i in range(r0, len(A)) if A[i][col] % p), None)
        if pr is None: continue
        A[r0], A[pr] = A[pr], A[r0]
        inv = pow(A[r0][col], p - 2, p)
        A[r0] = [(x * inv) % p for x in A[r0]]
        for i in range(len(A)):
            if i != r0 and A[i][col] % p:
                f = A[i][col]
                A[i] = [(x - f * y) % p for x, y in zip(A[i], A[r0])]
        piv.append(col); r0 += 1
    cons = all(A[i][11] % p == 0 for i in range(r0, len(A)))
    sol = None
    if cons:
        sol = [0] * 11
        for i, col in enumerate(piv): sol[col] = A[i][11]
    return f"level-121 system: {len(A)} rows, rank {r0}, consistent {cons}", sol
msg, sol = solve_mod121()
print(msg)
if sol is not None:
    print("w mod 11:", sol)
