#!/usr/bin/env python3
# Exhaustive corner-closing sweep for Lemma S on the G9-aligned fan.
# Patterns: (A) all sigma-coherent rank-patterns P (zero-region iff rank of
# H_0 in P), |P| >= 2 -- 26 patterns; (B) 150 random per-orbit patterns.
# For each: assemble the exact system ((1) zeros, (2)+values integrality,
# (3) congruence) on sampled lattice points; solve mod 5, mod 11; if forced
# v=0 mod 11, substitute v = 11w and test the level-121 system.
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

def rank_pattern(n):
    vals = sorted([(H(k, n), k) for k in range(5)], reverse=True)
    return [k for _, k in vals], [v for v, _ in vals]

def run_case(zero_region):
    # zero_region: function pi(tuple ordering) -> bool
    # free rays: S such that NO region with prefix-chain containing S is zero
    freeS = []
    for S in ALLS:
        bordered = False
        for pi in permutations(range(5)):
            if frozenset(pi[:len(S)]) == S and zero_region(pi):
                bordered = True; break
        if not bordered: freeS.append(S)
    idx = {S: i for i, S in enumerate(freeS)}
    nf = len(freeS)
    if nf == 0:
        return "no free rays (d = 0 forced): anchors violated -> infeasible", None
    def d_row(n):
        order, vals = rank_pattern(n)
        # zero if the (generic) region is zero; ties: take any compatible pi
        pi = tuple(order)
        if zero_region(pi): return {}
        row = {}
        for k in range(1, 5):
            S = frozenset(order[:k])
            gap = vals[k - 1] - vals[k]
            if gap == 0 or S not in idx: continue
            row[S] = row.get(S, Fr(0)) + Fr(gap, RAYGAP[S])
        return row
    random.seed(9)
    rowsZ = []
    for _ in range(2500):
        n = [random.randint(-6, 6) for _ in range(5)]
        n[4] -= sum(n)
        n = tuple(n)
        for k in range(5):
            m = n
            for _ in range(k): m = sigN(m)
            rr = d_row(m)
            if not rr: continue
            L = 1
            for cf in rr.values(): L = L * cf.denominator // gcd(L, cf.denominator)
            if L > 1:
                row = [0] * nf
                for S, cf in rr.items(): row[idx[S]] = int(cf * L)
                rowsZ.append((row, 0, L))
        row = {}
        for k in range(5):
            m = n
            for _ in range(k): m = sigN(m)
            for S, cf in d_row(m).items():
                row[S] = row.get(S, Fr(0)) + (9 ** k) * cf
        L = 1
        for cf in row.values(): L = L * cf.denominator // gcd(L, cf.denominator)
        r2 = [0] * nf
        for S, cf in row.items(): r2[idx[S]] = int(cf * L)
        rowsZ.append((r2, c9pair(n) * L, 11 * L))
    def gauss(A, p):
        r0 = 0; piv = []
        for col in range(nf):
            pr = next((i for i in range(r0, len(A)) if A[i][col] % p), None)
            if pr is None: continue
            A[r0], A[pr] = A[pr], A[r0]
            inv = pow(A[r0][col] % p, p - 2, p)
            A[r0] = [(x * inv) % p for x in A[r0]]
            for i in range(len(A)):
                if i != r0 and A[i][col] % p:
                    f = A[i][col]
                    A[i] = [(x - f * y) % p for x, y in zip(A[i], A[r0])]
            piv.append(col); r0 += 1
        cons = all(A[i][nf] % p == 0 for i in range(r0, len(A)))
        sol = None
        if cons:
            sol = [0] * nf
            for i, col in enumerate(piv): sol[col] = A[i][nf]
        return cons, r0, sol, piv
    A11 = [[x % 11 for x in row] + [(-rhs) % 11] for row, rhs, L in rowsZ if L % 11 == 0 or True]
    # careful: mod-11 shadow: condition row.v + rhs = 0 mod L: reduce only info mod 11:
    A11 = []
    for row, rhs, L in rowsZ:
        if L % 11 == 0:
            A11.append([x % 11 for x in row] + [(-rhs) % 11])
        else:
            Li = pow(L % 11, 9, 11)
            A11.append([(x * Li) % 11 for x in row] + [((-rhs) * Li) % 11])
    cons, rk, sol, piv = gauss([r[:] for r in A11], 11)
    if not cons:
        return "level-11 INFEASIBLE", None
    if sol is None or any(sol) or rk < nf:
        # nonzero solution or freedom: report (needs deeper look)
        return f"level-11 feasible: rank {rk}/{nf}, sol {sol}", None
    # forced v = 0 mod 11: substitute v = 11w in full conditions
    A121 = []
    bad = False
    for row, rhs, L in rowsZ:
        # row.(11w) + rhs = 0 mod L
        v11 = 0; LL = L
        while LL % 11 == 0: LL //= 11; v11 += 1
        if v11 >= 2:
            if rhs % 11: bad = True; break
            A121.append([x % 11 for x in row] + [((-rhs // 11)) % 11])
        elif v11 == 1:
            if rhs % 11: bad = True; break
    if bad:
        return "level-121 IMMEDIATE INCONSISTENCY (rhs not 11-divisible)", None
    cons2, rk2, sol2, _ = gauss(A121, 11)
    return f"forced v=0 mod 11; level-121: rows {len(A121)}, rank {rk2}, consistent {cons2}", sol2

# (A) rank patterns
print("== rank patterns ==")
for psz in range(2, 6):
    for P in combinations(range(5), psz):
        Pf = frozenset(P)
        res, _ = run_case(lambda pi, Pf=Pf: pi.index(0) in Pf)
        print(f"P = {sorted(P)}: {res}")
