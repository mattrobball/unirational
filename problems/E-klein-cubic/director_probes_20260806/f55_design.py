#!/usr/bin/env python3
# Isotropic design search for the d-system (Lemma S decision).
# d := sum of nonneg-integer multiples of margin generators, each a
# sigma-invariant formula in the values (H_0,...,H_4), H_k(w) = <sig^k w, G9>,
# G9 = (1,5,3,4,9).  Generators:
#   P_D := max(0, H_0 - H_D)              D = 1..4
#   R_r := max(0, H_0 - V_r)              V_r = r-th largest value, r = 2..5
#   B_r := max(0, V_r - H_0)              r = 1..4
# On a region with ordering pi (H_{pi0} > ... > H_{pi4}), each generator's
# translate-k slope contributes to the (ii)-sum a G9-multiple computable
# from ranks; condition: total = -4 mod 11 for EVERY ordering.
# Then check the 2-cover: zero-translates per orbit >= 2.
from itertools import permutations

MOD = 11
P9 = [pow(9, k, MOD) for k in range(5)]      # 9^k mod 11
IP9 = [pow(9, (5-k) % 5 * 1, MOD) for k in range(5)]  # 9^{-k} = 9^{5-k} since 9^5=1
def inv9(k): return P9[(5 - k) % 5]

GENS = []
# P_Delta: active at translate k iff H_k > H_{k+D}; slope contribution
# (transported, G9-units): 1 - 9^{-D}
for D in range(1, 5):
    GENS.append(("P", D))
# R_r: active at translate k iff H_k > V_r  (H_k ranks <= r-1);
# slope at translate k: G_k - G_{j} with j = index ranked r;
# transported G9-units: 1 - 9^{j3...}: 9^{k - pos_r}?? computed per pi below.
for r in range(2, 6):
    GENS.append(("R", r))
for r in range(1, 5):
    GENS.append(("B", r))

def contrib(gen, pi):
    # returns total (ii)-contribution in G9-units mod 11 for one unit of gen,
    # plus the set of ZERO translates (k with generator's translate vanishing)
    kind, x = gen
    rankpos = {pi[i]: i for i in range(5)}   # index -> rank position (0 = top)
    tot = 0
    zeros = set()
    if kind == "P":
        D = x
        for k in range(5):
            if rankpos[k] < rankpos[(k + D) % 5]:   # H_k > H_{k+D}: active
                tot = (tot + 1 - inv9(D)) % MOD
            else:
                zeros.add(k)
    elif kind == "R":
        r = x
        j = pi[r - 1]                       # index ranked r
        for k in range(5):
            if rankpos[k] < r - 1:          # H_k strictly above V_r
                # slope G_k - G_j ; transported: 9^k(9^{-k} - 9^{-j}) = 1 - 9^{k-j}
                tot = (tot + 1 - P9[(k - j) % 5]) % MOD
            else:
                zeros.add(k)
    elif kind == "B":
        r = x
        j = pi[r - 1]
        for k in range(5):
            if rankpos[k] > r - 1:          # H_k strictly below V_r: active
                # slope G_j - G_k ; transported: 9^k(9^{-j} - 9^{-k}) = 9^{k-j} - 1
                tot = (tot + P9[(k - j) % 5] - 1) % MOD
            else:
                zeros.add(k)
    return tot, zeros

PIS = list(permutations(range(5)))
# build the F11 linear system: sum_g c_g * contrib_g(pi) = -4 (mod 11) for all pi
rows = []
zsets = []
for pi in PIS:
    row = []
    zs = []
    for g in GENS:
        t, z = contrib(g, pi)
        row.append(t); zs.append(z)
    rows.append(row); zsets.append(zs)
target = (-4) % MOD
# solve the linear system over F11
import itertools
n = len(GENS)
A = [r[:] + [target] for r in rows]
# gaussian
r0 = 0
piv = []
for col in range(n):
    pr = next((i for i in range(r0, len(A)) if A[i][col] % MOD), None)
    if pr is None: continue
    A[r0], A[pr] = A[pr], A[r0]
    inv = pow(A[r0][col], MOD - 2, MOD)
    A[r0] = [(v * inv) % MOD for v in A[r0]]
    for i in range(len(A)):
        if i != r0 and A[i][col] % MOD:
            f = A[i][col]
            A[i] = [(v - f * w) % MOD for v, w in zip(A[i], A[r0])]
    piv.append(col); r0 += 1
consistent = all(A[i][n] % MOD == 0 for i in range(r0, len(A)))
print(f"design system: {len(PIS)} conditions, {n} unknowns, rank {r0}, consistent: {consistent}")
if consistent:
    # particular solution + kernel
    c0 = [0] * n
    for i, col in enumerate(piv):
        c0[col] = A[i][n]
    print("particular solution c =", c0, "generators:", GENS)
    free = [c for c in range(n) if c not in piv]
    kerbasis = []
    for f in free:
        v = [0] * n; v[f] = 1
        for i, col in enumerate(piv):
            v[col] = (-A[i][f]) % MOD
        kerbasis.append(v)
    print("kernel dim:", len(kerbasis))
    # search solution space for one with the 2-cover property:
    # zero-translates(pi) := set of k that are zeros of EVERY generator with
    # c_g != 0 -- need |...| >= 2 for all pi
    def covers(c):
        for pi_i in range(len(PIS)):
            zz = set(range(5))
            for gi in range(n):
                if c[gi] % MOD:
                    zz &= zsets[pi_i][gi]
            if len(zz) < 2:
                return False
        return True
    found = None
    import random
    random.seed(3)
    trials = 200000
    for t in range(trials):
        c = c0[:]
        for kb in kerbasis:
            lam = random.randrange(MOD)
            c = [(a + lam * b) % MOD for a, b in zip(c, kb)]
        if covers(c):
            found = c; print("COVERING SOLUTION FOUND:", c); break
    if not found:
        print(f"no covering solution in {trials} random kernel samples")
