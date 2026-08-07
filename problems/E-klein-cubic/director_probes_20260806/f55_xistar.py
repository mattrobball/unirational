#!/usr/bin/env python3
# The final reduction for the G9-fan class:
#   E(O).w = sum_j DG9_j(pi) * 5^{t_j} * xi_{c_j},  xi_c = sum_t 5^t w_{T_c + t},
#   over the 6 cyclic classes of proper nonempty subsets of Z/5.
#   System: A xi = 2*(1,..,1) over the 24 orbits; A injective => unique xi*.
#   Pattern feasible <=> xi*_c = 0 for all fully-bordered classes c.
# This script: (1) build A, verify rank 6 and E-factorization; (2) solve xi*;
# (3) exhaustive transversal search: can an admissible pattern (>= 2 zero
#     chambers per sigma-orbit) keep every class in supp(xi*) partially free?
from itertools import combinations, permutations

G9 = (1, 5, 3, 4, 9)

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

# classes: representative subsets up to translation
CLASSREP = [frozenset({0}), frozenset({0, 1}), frozenset({0, 2}),
            frozenset({0, 1, 2}), frozenset({0, 1, 3}), frozenset({0, 1, 2, 3})]
CNAME = ["c1", "c2a", "c2b", "c3a", "c3b", "c4"]
def class_of(S):
    for i, T in enumerate(CLASSREP):
        if len(T) != len(S): continue
        for t in range(5):
            if frozenset((x + t) % 5 for x in T) == S:
                return i, t   # S = T + t
    raise RuntimeError(S)

# check translate-representation uniqueness: subsets of Z/5 sizes 1..4 have
# trivial cyclic stabilizer, so (class, t) is unique
for sz in (1, 2, 3, 4):
    for S in combinations(range(5), sz):
        i, t = class_of(frozenset(S))

# build A (24 x 6): row(O)_c = sum over j with class(pi[:j]) = c of DG9_j * 5^t
A = []
for pi in REPS:
    row = [0] * 6
    for j in range(1, 5):
        S = frozenset(pi[:j])
        c, t = class_of(S)   # S = T_c + t; sigma(S) = 9^t * xi_c
        dG = (G9[pi[j - 1]] - G9[pi[j]]) % 11
        row[c] = (row[c] + dG * pow(9, t, 11)) % 11
    A.append(row)

# verify factorization against E rows built directly
ALLS = [frozenset(S) for k in (1, 2, 3, 4) for S in combinations(range(5), k)]
AIDX = {S: i for i, S in enumerate(ALLS)}
import random
random.seed(1)
for _ in range(200):
    w = [random.randrange(11) for _ in range(30)]
    xi = [0] * 6
    for S in ALLS:
        c, t = class_of(S)
        xi[c] = (xi[c] + pow(5, t, 11) * w[AIDX[S]]) % 11
    for pi, row in zip(REPS, A):
        # E(O).w directly
        val = 0
        q = pi
        for _ in range(5):
            for j in range(1, 5):
                S = frozenset(q[:j])
                val = (val + (G9[q[j - 1]] - G9[q[j]]) * w[AIDX[S]]) % 11
            q = tuple((p + 1) % 5 for p in q)
        pred = sum(row[c] * xi[c] for c in range(6)) % 11
        assert val == pred, (pi, val, pred)
print("factorization E(O).w = A.xi verified on 200 random w")

# solve A xi = 2*1
M = [row[:] + [2] for row in A]
r0 = 0; piv = []
for col in range(6):
    pr = next((i for i in range(r0, 24) if M[i][col] % 11), None)
    if pr is None: continue
    M[r0], M[pr] = M[pr], M[r0]
    inv = pow(M[r0][col], 9, 11)
    M[r0] = [(x * inv) % 11 for x in M[r0]]
    for i in range(24):
        if i != r0 and M[i][col] % 11:
            f = M[i][col]
            M[i] = [(x - f * y) % 11 for x, y in zip(M[i], M[r0])]
    piv.append(col); r0 += 1
cons = all(M[i][6] % 11 == 0 for i in range(r0, 24))
print(f"rank(A) = {r0}, consistent = {cons}")
xistar = [0] * 6
for i, c in enumerate(piv): xistar[c] = M[i][6]
print("unique xi* =", {CNAME[c]: xistar[c] for c in range(6)})
# sanity: A xi* = 2 everywhere
assert all(sum(A[i][c] * xistar[c] for c in range(6)) % 11 == 2 for i in range(24))
print("supp(xi*) =", [CNAME[c] for c in range(6) if xistar[c]])

# ---- transversal search over supp(xi*) ----
# Pattern feasible <=> xi*_c = 0 on all fully-bordered classes
#   <=> every class c with xi*_c != 0 has a free ray.
# Free ray rho: NO zero chamber has rho among its prefixes.
# So: feasible pattern exists <=> exists a transversal (rho_c in class c,
# for c in supp(xi*)) and a pattern with >= 2 zeros per orbit, all zeros
# "safe" = having no prefix in {rho_c}.
supp = [c for c in range(6) if xistar[c]]
print(f"\ntransversal search over {len(supp)} classes: 5^{len(supp)} =",
      5 ** len(supp), "choices")
def prefixes(q): return [frozenset(q[:j]) for j in range(1, 5)]
PREF = {q: prefixes(q) for q in permutations(range(5))}
ORBITS = []
for pi in REPS:
    orb = []
    q = pi
    for _ in range(5):
        orb.append(q); q = tuple((p + 1) % 5 for p in q)
    ORBITS.append(orb)
best = None
count_ok = 0
import itertools
for choice in itertools.product(range(5), repeat=len(supp)):
    targets = set()
    for c, t in zip(supp, choice):
        targets.add(frozenset((x + t) % 5 for x in CLASSREP[c]))
    ok = True
    minsafe = 5
    for orb in ORBITS:
        safe = sum(1 for q in orb if not any(S in targets for S in PREF[q]))
        minsafe = min(minsafe, safe)
        if safe < 2:
            ok = False
            break
    if ok:
        count_ok += 1
        if best is None:
            best = (choice, targets)
            print("TRANSVERSAL WITH >=2 SAFE PER ORBIT FOUND:", choice)
            print("  targets:", [tuple(sorted(T)) for T in targets])
print("transversals admitting a pattern that dodges supp(xi*):", count_ok)
if count_ok == 0:
    print("=> NO admissible pattern dodges supp(xi*): "
          "every pattern on the G9-fan class is infeasible (Lemma S, G9 case)")
else:
    print("=> FAILURE BRANCH: construct the feasible pattern & shadow explicitly")
    # build one explicit pattern: per orbit choose 2 safe chambers as zeros
    choice, targets = best
    pat = {}
    for pi, orb in zip(REPS, ORBITS):
        safeq = [q for q in orb if not any(S in targets for S in PREF[q])]
        pat[pi] = safeq[:2]
    print("example pattern (zeros per orbit):")
    for pi in REPS: print("  ", pi, "->", pat[pi])
