#!/usr/bin/env python3
# Exhaustive closure of the SIGN-FAN (arrangement of {H_k = 0}): every
# admissible zero-pattern (>= 2 zero cells per sigma-orbit) is infeasible
# for the level-2 pair-field shadow (tau, Psi).  Method: solve the
# jump + orbit-sum system once (7-dim solution space), then show ANY two
# zero cells in the corank-1 orbit (rep (+,+,+,+,-)) are already
# inconsistent; every admissible pattern contains such a pair.  Also
# verifies the full per-orbit pair table and the single-cell consistency
# (so the kill is exactly at the twice-min threshold), and runs the DFS
# over all 10^6 minimal patterns for completeness (prunes at level 0).
from itertools import combinations
import os
HERE = os.path.dirname(os.path.abspath(__file__))
exec(open(os.path.join(HERE, 'f55_signfan.py')).read().split("# minimal patterns:")[0])

nb = len(basis)
CELLCOND = []
for i in range(30):
    M = []
    for c in range(4):
        row = [b[4 * i + c] for b in basis]
        rhs = (-part[4 * i + c]) % 11
        M.append(row + [rhs])
    CELLCOND.append(M)

def rref(rows):
    A = [r[:] for r in rows]
    m = len(A); r0 = 0
    for col in range(nb):
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
    for i in range(r0, m):
        if A[i][nb] % 11: return None
    return tuple(tuple(A[i]) for i in range(r0))

print("\nper-orbit structure:")
for onum, orb in enumerate(ORBITS):
    singles = [rref(CELLCOND[CIDX[s]]) is not None for s in orb]
    bad = sum(1 for (i, j) in combinations(range(5), 2)
              if rref(CELLCOND[CIDX[orb[i]]] + CELLCOND[CIDX[orb[j]]]) is None)
    print(f"  orbit {onum} rep {orb[0]}: singles consistent {all(singles)}, "
          f"inconsistent pairs {bad}/10")

pairs = list(combinations(range(5), 2))
ORBPAIRCOND = []
for orb in ORBITS:
    ORBPAIRCOND.append([CELLCOND[CIDX[orb[i]]] + CELLCOND[CIDX[orb[j]]]
                        for (i, j) in pairs])
examined = [0]
def dfs(level, flatrows):
    if level == 6: return True
    seen = set()
    for block in ORBPAIRCOND[level]:
        R = rref(list(flatrows) + block)
        examined[0] += 1
        if R is None or R in seen: continue
        seen.add(R)
        if dfs(level + 1, R): return True
    return False
found = dfs(0, [])
print(f"\nDFS over all minimal patterns: feasible found = {found} "
      f"(rref calls = {examined[0]})")
assert not found
print("=> every admissible pattern on the sign-fan is infeasible "
      "(level-2 pair-field shadow); kill happens at the corank-1 orbit pair")
