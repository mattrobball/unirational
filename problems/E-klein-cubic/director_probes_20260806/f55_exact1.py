#!/usr/bin/env python3
# T0/T2 support: EXACT level-1 mod-11 forcing on the G9-fan, no sampling.
#
# Level-1 mod-11 system on the free-ray values v_S (pattern P):
#   a-rows (integrality shadow): at any lattice n interior to chamber pi
#     with V0 = <n,G9> nonzero mod 11:  sum_j DG9_j(pi) * v_{pi[:j]}  == 0,
#     where DG9_j(pi) = G9[pi[j-1]] - G9[pi[j]]  (g_j == DG9_j * V0 mod 11).
#     One row per chamber (120 chambers = 24 sig-classes x 5 translates).
#   b-rows (congruence shadow): R(pi) . v == 0  (homogeneous at level 1;
#     the same 24 sig-invariant rows whose level-2 inhomogeneous version
#     is the certificate system; see f55_exact2.py).
# Claim to verify: for every surviving rank-pattern P this exact system
# forces v == 0 (mod 11)  [rank = #free rays].
# Also: cross-check each row family against sampled lattice instances.
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
inv5 = 9

ALLS = [frozenset(S) for k in (1, 2, 3, 4) for S in combinations(range(5), k)]

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

def cyc_shift_match(T, S):
    for k in range(5):
        if frozenset((t - k) % 5 for t in T) == S:
            return k
    return None

def chamber_row_b(pi, P, FREE):
    Z = {k for k in range(5) if pi.index(k) in P}
    row = {}
    for j in range(1, 5):
        T = frozenset(pi[:j])
        dG = G9[pi[j - 1]] - G9[pi[j]]
        for S in FREE:
            if len(S) != j: continue
            k = cyc_shift_match(T, S)
            if k is None or k in Z: continue
            row[S] = (row.get(S, 0) + pow(9, k, 11) * dG * inv5) % 11
    return row

def chamber_row_a(pi, P, FREE):
    # integrality row at chamber pi: sum_j DG9_j * v_{pi[:j]} (only free rays,
    # and only if pi itself is NOT a zero chamber -- zero chambers have d = 0)
    if pi.index(0) in P: return {}
    row = {}
    for j in range(1, 5):
        S = frozenset(pi[:j])
        if S not in FREE: continue
        dG = (G9[pi[j - 1]] - G9[pi[j]]) % 11
        if dG: row[S] = (row.get(S, 0) + dG) % 11
    return row

def rank_aug(rows, nf):
    A = [r[:] for r in rows]
    m = len(A); r0 = 0
    for col in range(nf):
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

# ---- sampled cross-check of the a-row formula ----
def rank_pattern(n):
    vals = sorted([(H(k, n), k) for k in range(5)], reverse=True)
    return [k for _, k in vals], [v for v, _ in vals]

def sampled_a_row(n, P, FREE):
    # exact integrality condition mod 11 at n: sum_j g_j v_{pi[:j]} == 0 (mod 11)
    order, vals = rank_pattern(n)
    pi = tuple(order)
    if pi.index(0) in P: return None
    row = {}
    for j in range(1, 5):
        S = frozenset(order[:j])
        if S not in FREE: continue
        g = (vals[j - 1] - vals[j]) % 11
        if g: row[S] = (row.get(S, 0) + g) % 11
    return pi, row

def verify_a(P, trials=3000, seed=777):
    FREE = free_rays(P)
    rng = random.Random(seed)
    checked = 0
    for _ in range(trials):
        n = [rng.randint(-9, 9) for _ in range(5)]
        n[4] -= sum(n)
        n = tuple(n)
        order, vals = rank_pattern(n)
        if len(set(vals)) < 5: continue
        V0 = H(0, n) % 11
        got = sampled_a_row(n, P, FREE)
        if got is None: continue
        pi, row = got
        pred = chamber_row_a(pi, P, FREE)
        ok = all(row.get(S, 0) % 11 == (V0 * pred.get(S, 0)) % 11 for S in FREE)
        if not ok:
            print("A-ROW MISMATCH", n, pi, V0, row, pred)
            return False
        checked += 1
    print(f"P={sorted(P)}: a-row formula verified at {checked} points")
    return True

allP = [frozenset(P) for sz in range(2, 6) for P in combinations(range(5), sz)]
for P in [frozenset({3, 4}), frozenset({1, 2})]:
    assert verify_a(P)

print("\n== exact level-1 forcing, all surviving patterns ==")
for P in allP:
    FREE = free_rays(P)
    nf = len(FREE)
    if nf == 0:
        print(f"P = {sorted(P)}: no free rays (level-1 anchor death)")
        continue
    idx = {S: i for i, S in enumerate(FREE)}
    rows = []
    for pi in permutations(range(5)):
        ra = chamber_row_a(pi, P, FREE)
        if ra:
            vec = [0] * nf
            for S, cf in ra.items(): vec[idx[S]] = cf
            rows.append(vec)
        rb = chamber_row_b(pi, P, FREE)
        if rb:
            vec = [0] * nf
            for S, cf in rb.items(): vec[idx[S]] = cf
            rows.append(vec)
    rk = rank_aug(rows, nf)
    print(f"P = {sorted(P)}: free rays {nf}, level-1 rows {len(rows)}, "
          f"rank {rk} -> {'v == 0 mod 11 FORCED' if rk == nf else 'NOT FORCED (!!)'}")
