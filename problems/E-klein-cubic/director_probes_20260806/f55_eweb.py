#!/usr/bin/env python3
# The pattern-independent form of the G9-fan level-2 system:
#   E(O) . w == 2 (mod 11) per sig-orbit O of chambers  (24 fixed rows),
#   w_S = 0 on rays bordered by the pattern's zero chambers.
#   E(O) = sum_{q in O} D(q),  D(q) = sum_j (G9[q[j-1]] - G9[q[j]]) e*_{prefix_j(q)}.
# (Level-2 row of orbit O = 9 * sum_{q in O minus zeros} D(q).w == -4; zero
#  chambers contribute 0 since their prefixes are bordered; -4*5 = -20 == 2.)
# Questions:
#   (a) verify E-form against the verified chamber rows (f55_exact2 formula);
#   (b) rank of the 24x30 matrix E; relation space Y = leftker(E);
#   (c) coefficient sums {sum y : y in Y}: if some unrestricted relation has
#       sum y != 0, EVERY pattern dies at once.  Else find the B-dependent story.
from itertools import combinations, permutations
import random

G9 = (1, 5, 3, 4, 9)
inv5 = 9
ALLS = [frozenset(S) for k in (1, 2, 3, 4) for S in combinations(range(5), k)]
AIDX = {S: i for i, S in enumerate(ALLS)}

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

def D(q):
    vec = [0] * 30
    for j in range(1, 5):
        S = frozenset(q[:j])
        vec[AIDX[S]] = (vec[AIDX[S]] + G9[q[j - 1]] - G9[q[j]]) % 11
    return vec

def orbit(pi):
    out = []
    q = pi
    for _ in range(5):
        out.append(q); q = tuple((p + 1) % 5 for p in q)
    return out

E = {}
for pi in REPS:
    vec = [0] * 30
    for q in orbit(pi):
        d = D(q)
        vec = [(a + b) % 11 for a, b in zip(vec, d)]
    E[pi] = vec

# (a) check E-form against the direct chamber-row formula for rank patterns
def cyc_shift_match(T, S):
    for k in range(5):
        if frozenset((t - k) % 5 for t in T) == S:
            return k
    return None
def chamber_row(pi, P, FREE):
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
def free_rays(P):
    out = []
    for S in ALLS:
        if 0 in S:
            bordered = any(p < len(S) for p in P)
        else:
            bordered = any(p >= len(S) for p in P)
        if not bordered: out.append(S)
    return out
okall = True
for P in [frozenset({3, 4}), frozenset({0, 2}), frozenset({1, 2})]:
    FREE = free_rays(P)
    for pi in REPS:
        r1 = chamber_row(pi, P, FREE)
        # E-form: 9 * (E(pi) restricted to FREE) should equal r1... note
        # E includes zero-chamber terms; those must vanish on FREE. Check:
        for S in FREE:
            lhs = (9 * E[pi][AIDX[S]]) % 11
            if lhs != r1.get(S, 0) % 11:
                okall = False
                print("E-FORM MISMATCH", sorted(P), pi, tuple(sorted(S)),
                      lhs, r1.get(S, 0))
print("E-form matches verified chamber rows on free rays:", okall)

# (b) rank and left-kernel of E (24 x 30)
mat = [E[pi][:] for pi in REPS]
m, n = 24, 30
# augment with identity to track left-kernel
A = [mat[i][:] + [1 if j == i else 0 for j in range(m)] for i in range(m)]
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
rank = r0
print(f"rank(E) = {rank} of 24; relation space dim = {24 - rank}")
rels = []
for i in range(rank, m):
    y = A[i][n:]
    assert all(sum(y[j] * mat[j][c] for j in range(m)) % 11 == 0 for c in range(n))
    rels.append(y)
sums = [sum(y) % 11 for y in rels]
print("coefficient sums of a relation basis:", sums)
# span of sums over the relation space: nonzero iff some basis sum != 0
if any(sums):
    print("=> UNRESTRICTED relation with nonzero sum EXISTS: every pattern dies at once")
    # find and print a small such relation
    y = rels[[i for i, s in enumerate(sums) if s][0]]
    supp = [(REPS[i], y[i]) for i in range(m) if y[i]]
    print(f"   example: support {len(supp)} orbits, sum {sum(c for _, c in supp) % 11}")
    for piq, c in supp: print("   ", c, piq)
else:
    print("=> all unrestricted relations have sum 0: pattern-dependent story;")
    print("   the kill must use w=0 on bordered rays. Computing the B-quotient story.")
    # For each uniform pattern Z, compute relations of E restricted to FREE.
    def bordered_from_pattern(pattern):
        zc = set()
        for pi in REPS:
            for k in pattern[pi]:
                zc.add(tuple((p - k) % 5 for p in pi))
        B = set()
        for q in zc:
            for j in range(1, 5): B.add(frozenset(q[:j]))
        return B
    Z0 = frozenset({3, 4})
    pat = {pi: frozenset(k for k in range(5) if pi.index(k) in Z0) for pi in REPS}
    B = bordered_from_pattern(pat)
    FREE = [S for S in ALLS if S not in B]
    cols = [AIDX[S] for S in FREE]
    A2 = [[mat[i][c] for c in cols] + [1 if j == i else 0 for j in range(m)]
          for i in range(m)]
    r0 = 0
    for col in range(len(cols)):
        pr = next((i for i in range(r0, m) if A2[i][col] % 11), None)
        if pr is None: continue
        A2[r0], A2[pr] = A2[pr], A2[r0]
        inv = pow(A2[r0][col], 9, 11)
        A2[r0] = [(x * inv) % 11 for x in A2[r0]]
        for i in range(m):
            if i != r0 and A2[i][col] % 11:
                f = A2[i][col]
                A2[i] = [(x - f * y) % 11 for x, y in zip(A2[i], A2[r0])]
        r0 += 1
    print(f"   canonical pattern: rank on FREE = {r0}; relations with sums:",
          [sum(A2[i][len(cols):]) % 11 for i in range(r0, m)][:8], "...")

# (c) independent re-derivation of E entries as stated closed form:
# E(O)_S = sum over q in O with prefix_{|S|}(q) = S of (G9[q[|S|-1]]-G9[q[|S|]]).
# Also print E rows compactly for the record.
print("\nE rows (nonzero entries), orbit-rep -> {ray: coeff}:")
for pi in REPS:
    nz = {tuple(sorted(S)): E[pi][AIDX[S]] for S in ALLS if E[pi][AIDX[S]]}
    print(" ", pi, nz)
