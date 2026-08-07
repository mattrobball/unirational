#!/usr/bin/env python3
# T4: arbitrary per-orbit zero-patterns on the G9-fan -- the unswept case.
# A pattern assigns to each of the 24 chamber sig-orbits a subset
# Z(pi) of Z/5 (which translates are zero cells), |Z(pi)| >= 2.
# Level 1 forces v == 0 (mod 11) for EVERY pattern (Lemma T + the 11-divisible
# ray values of the G9-fan; see f55_exact1.py / the write-up).  The remaining
# level-2 system on w = v/11 over F11:
#   w_S = 0 for every ray S in the closure of a zero chamber ("bordered");
#   for each orbit-rep pi:  sum_{k not in Z(pi)} C_k(pi) . w == -4  (mod 11),
# with C_k(pi)_S = 9^k * (G9[pi[j-1]] - G9[pi[j]]) * inv5 at S = pi[:j] - k
# (j = |S|), the exact chamber rows verified in f55_exact2.py.
# This script: random + adversarial sweep over patterns; report ANY feasible
# pattern (that would be the Section-4 failure branch of the endgame handoff).
from itertools import combinations, permutations
import random

G9 = (1, 5, 3, 4, 9)
inv5 = 9
ALLS = [frozenset(S) for k in (1, 2, 3, 4) for S in combinations(range(5), k)]

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
RIDX = {}
for pi in REPS:
    q = pi
    for t in range(5):
        RIDX[q] = (pi, t)  # chamber q = rep shifted by +t: q = pi + t
        q = tuple((p + 1) % 5 for p in q)

def cyc_shift_match(T, S):
    for k in range(5):
        if frozenset((t - k) % 5 for t in T) == S:
            return k
    return None

# Precompute, per rep pi: for each k in 0..4 the list of (S, coeff) of C_k(pi)
CK = {}
for pi in REPS:
    per_k = {k: [] for k in range(5)}
    for j in range(1, 5):
        T = frozenset(pi[:j])
        dG = (G9[pi[j - 1]] - G9[pi[j]]) % 11
        for k in range(5):
            S = frozenset((t - k) % 5 for t in T)
            c = (pow(9, k, 11) * dG * inv5) % 11
            if c: per_k[k].append((S, c))
    CK[pi] = per_k

# zero chambers of a pattern: pattern[pi] = frozenset Z(pi) subset Z/5;
# chamber (pi - k) is zero iff k in Z(pi).  Reps enumerated as pi; the
# chamber pi+t for t in 0..4; (pi+t) = pi - k with k = -t mod 5.
def zero_chambers(pattern):
    zc = set()
    for pi in REPS:
        for k in pattern[pi]:
            q = tuple((p - k) % 5 for p in pi)
            zc.add(q)
    return zc

def bordered_rays(zc):
    B = set()
    for q in zc:
        for j in range(1, 5):
            B.add(frozenset(q[:j]))
    return B

def rankF11(mat, ncols):
    A = [r[:] for r in mat]
    m = len(A); r0 = 0
    for col in range(ncols):
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

def test_pattern(pattern):
    zc = zero_chambers(pattern)
    B = bordered_rays(zc)
    FREE = [S for S in ALLS if S not in B]
    idx = {S: i for i, S in enumerate(FREE)}
    nf = len(FREE)
    rows = []
    for pi in REPS:
        row = [0] * (nf + 1)
        for k in range(5):
            if k in pattern[pi]: continue
            for S, c in CK[pi][k]:
                if S in idx:
                    row[idx[S]] = (row[idx[S]] + c) % 11
        row[nf] = (-4) % 11
        rows.append(row)
    ra = rankF11([r[:-1] for r in rows], nf) if nf else 0
    rb = rankF11(rows, nf + 1)
    return rb == ra, nf, ra, rb

# ---- sanity: rank patterns through this pipeline must match f55_exact2 ----
def rank_pattern_Z(P):
    pat = {}
    for pi in REPS:
        pat[pi] = frozenset(k for k in range(5) if pi.index(k) in P)
    return pat
for P in [(3, 4), (0, 1), (0, 2), (1, 2, 3)]:
    ok, nf, ra, rb = test_pattern(rank_pattern_Z(frozenset(P)))
    print(f"sanity rank P={P}: nf={nf} feasible={ok} (expect False)")

# ---- random sweep, biased to the hardest case |Z| = 2 ----
random.seed(20260807)
subsets2 = [frozenset(c) for c in combinations(range(5), 2)]
subsetsBig = [frozenset(c) for sz in (2, 3) for c in combinations(range(5), sz)]
feasible_found = []
Ntr = 4000
for trial in range(Ntr):
    if trial % 2:
        pat = {pi: random.choice(subsets2) for pi in REPS}
    else:
        pat = {pi: random.choice(subsetsBig) for pi in REPS}
    ok, nf, ra, rb = test_pattern(pat)
    if ok:
        feasible_found.append(pat)
        print(f"trial {trial}: FEASIBLE pattern found!! nf={nf} rank={ra}")
        break
print(f"random sweep: {Ntr if not feasible_found else trial+1} patterns tried, "
      f"{len(feasible_found)} feasible")

# ---- adversarial hill-climb: minimize (aug_rank - coeff_rank) ... it is 0/1;
# instead maximize nf (free rays) and retest; try single-orbit mutations from
# near-feasible states: score = 1 if feasible else fraction rank deficit ----
def score(pattern):
    ok, nf, ra, rb = test_pattern(pattern)
    if ok: return (1, nf)
    # infeasible: secondary score = nf - ra (slack): more slack ~ closer?
    return (0, nf - ra)
best = {pi: random.choice(subsets2) for pi in REPS}
bs = score(best)
improves = 0
for step in range(3000):
    pi = random.choice(REPS)
    cand = dict(best)
    cand[pi] = random.choice(subsetsBig)
    cs = score(cand)
    if cs > bs:
        best, bs = cand, cs
        improves += 1
    if bs[0] == 1:
        print("HILL-CLIMB FOUND FEASIBLE PATTERN:", best)
        break
print(f"hill-climb: {improves} improvements, best score {bs}, "
      f"feasible={bs[0] == 1}")

# ---- exhaustive over UNIFORM per-orbit patterns Z(pi) = Z fixed ----
print("\nuniform patterns Z(pi) = Z for all orbits:")
allZ = [frozenset(c) for sz in (2, 3, 4, 5) for c in combinations(range(5), sz)]
for Z in allZ:
    ok, nf, ra, rb = test_pattern({pi: Z for pi in REPS})
    print(f"  Z={sorted(Z)}: nf={nf} rank={ra}/{rb} feasible={ok}")
