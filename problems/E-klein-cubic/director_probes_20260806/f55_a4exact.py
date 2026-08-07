#!/usr/bin/env python3
# The A4-fan (orderings of the COORDINATES n_0..n_4; the generic Weyl fan)
# in the exact (1)(2)(3) value frame, ALL patterns at once.
#
# Derivation (to be verified here): rays ray(S) = 5*chi_S - |S|*(1,..,1)
# have coordinate gap 5, so d(n) = sum_j g_j v_{pi[:j]}/5 with g the
# coordinate gaps, which are FREE mod 11 as n ranges over the chamber's
# lattice points.  The congruence (ii) therefore forces, per ray S:
#     eta(S) := sum_k 9^k v_{S+k}  ==  -<ray(S), c9>  ==  -5*c9(S)  (mod 11)
# (zero-translate terms drop: their rays are bordered, v = 0 there).
# Rows collapse to SIX subset-classes (eta and the RHS both twist by 5
# under S -> S+1).  All six targets are nonzero, so a pattern is feasible
# iff every class keeps a free ray -- impossible by the covering theorem
# (0 of 15,625 transversals; same count as the G9-fan).  Hence the A4-fan
# dies for EVERY pattern at level 1.
#
# This script: (1) verifies the eta-row against the (ii)-congruence at
# sampled lattice points for random patterns; (2) prints the six targets;
# (3) tests feasibility of the exact class system for random per-orbit
# patterns + all uniform ones (expected: all infeasible); (4) re-runs the
# transversal covering count (shared combinatorics with f55_xistar.py).
from itertools import combinations, permutations, product
import random

c9 = (4, 9, 1, 5, 3)
ALLS = [frozenset(S) for k in (1, 2, 3, 4) for S in combinations(range(5), k)]
def ray(S): return tuple(5 * (i in S) - len(S) for i in range(5))
def c9pair(n): return sum(n[j] * c9[j] for j in range(5))
def sigN(n): return tuple(n[(j - 1) % 5] for j in range(5))

def orbit_reps():
    reps = []
    seen = set()
    for pi in permutations(range(5)):
        if pi in seen: continue
        orb = []
        q = pi
        for _ in range(5): orb.append(q); q = tuple((p + 1) % 5 for p in q)
        seen.update(orb); reps.append(pi)
    return reps
REPS = orbit_reps()

# pattern: per orbit-rep a set Z of translates t such that chamber (pi + t)
# is a zero cell; chamber of n = ordering pi with n_{pi[0]} >= ...;
# chamber of sig^k n has ordering pi + k (coordinates shift up).
def zero_chambers(pattern):
    zc = set()
    for pi in REPS:
        for t in pattern[pi]:
            zc.add(tuple((p + t) % 5 for p in pi))
    return zc
def bordered(zc):
    B = set()
    for q in zc:
        for j in range(1, 5): B.add(frozenset(q[:j]))
    return B

# ---- (1) verify the eta-row derivation at sampled lattice points ----
def d_of(n, v, zc):
    # value of the PL function with ray values v (0 outside dict) at n
    pi = tuple(sorted(range(5), key=lambda j: -n[j]))
    if pi in zc: return None  # zero cell: d = 0
    vals = sorted(n, reverse=True)
    tot = 0
    from fractions import Fraction as Fr
    for j in range(1, 5):
        S = frozenset(pi[:j])
        g = vals[j - 1] - vals[j]
        tot += Fr(g, 5) * v.get(S, 0)
    return tot

random.seed(99)
subsets2 = [frozenset(c) for c in combinations(range(5), 2)]
ok = True
for trial in range(200):
    pat = {pi: random.choice(subsets2) for pi in REPS}
    zc = zero_chambers(pat)
    B = bordered(zc)
    FREE = [S for S in ALLS if S not in B]
    # random integer ray values, 0 on bordered
    v = {S: random.randrange(-20, 20) for S in FREE}
    # sample lattice points; compute (ii)-sum vs eta-prediction
    for _ in range(20):
        n = [random.randint(-9, 9) for _ in range(5)]
        n[4] -= sum(n)
        n = tuple(n)
        if len(set(n)) < 5: continue
        from fractions import Fraction as Fr
        tot = Fr(0)
        okpoint = True
        for k in range(5):
            m = n
            for _ in range(k): m = sigN(m)
            dv = d_of(m, v, zc)
            if dv is None: dv = Fr(0)
            tot += (9 ** k) * dv
        # predicted: sum_j (g_j/5) * [eta(pi[:j]) + <ray(pi[:j]), c9>] - <n,c9>
        pi = tuple(sorted(range(5), key=lambda j: -n[j]))
        vals = sorted(n, reverse=True)
        pred = Fr(0)
        for j in range(1, 5):
            S = frozenset(pi[:j])
            g = vals[j - 1] - vals[j]
            eta = sum((9 ** k) * v.get(frozenset((s + k) % 5 for s in S), 0)
                      for k in range(5))
            pred += Fr(g, 5) * eta
        # identity to verify: tot == pred  and  <n,c9> == sum_j g_j <ray,c9>/5
        anch = sum(Fr(vals[j - 1] - vals[j], 5) *
                   sum(ray(frozenset(pi[:j]))[i] * c9[i] for i in range(5))
                   for j in range(1, 5))
        if tot != pred or anch != c9pair(n):
            ok = False
            print("MISMATCH", n, tot, pred, anch, c9pair(n))
            break
    if not ok: break
print("eta-row identity verified on 200 random patterns x 20 points:", ok)

# ---- (2) the six class targets ----
CLASSREP = [frozenset({0}), frozenset({0, 1}), frozenset({0, 2}),
            frozenset({0, 1, 2}), frozenset({0, 1, 3}), frozenset({0, 1, 2, 3})]
targ = {}
for T in CLASSREP:
    targ[T] = (-sum(ray(T)[i] * c9[i] for i in range(5))) % 11
print("class targets -<ray(T),c9> mod 11:",
      {tuple(sorted(T)): targ[T] for T in CLASSREP})
assert all(targ[T] for T in CLASSREP), "all six targets must be nonzero"

# ---- (3) exact class-system feasibility per pattern ----
def class_of(S):
    for i, T in enumerate(CLASSREP):
        if len(T) != len(S): continue
        for t in range(5):
            if frozenset((x + t) % 5 for x in T) == S: return i
    raise RuntimeError
def feasible(pattern):
    zc = zero_chambers(pattern)
    B = bordered(zc)
    # class c is killable iff some ray of class c is free
    for i, T in enumerate(CLASSREP):
        if all(frozenset((x + t) % 5 for x in T) in B for t in range(5)):
            return False  # fully bordered class with nonzero target
    return True
subsetsBig = [frozenset(c) for sz in (2, 3) for c in combinations(range(5), sz)]
random.seed(7)
feas = 0
for trial in range(20000):
    pat = {pi: random.choice(subsets2 if trial % 2 else subsetsBig) for pi in REPS}
    if feasible(pat): feas += 1
print(f"random per-orbit patterns feasible: {feas} of 20000 (expect 0)")
for Z in [frozenset(c) for sz in (2, 3, 4, 5) for c in combinations(range(5), sz)]:
    assert not feasible({pi: Z for pi in REPS}), Z
print("all 26 uniform patterns infeasible: True")

# ---- (4) covering count (same combinatorics as f55_xistar.py) ----
PREF = {q: [frozenset(q[:j]) for j in range(1, 5)] for q in permutations(range(5))}
ORB = []
for pi in REPS:
    orb = []
    q = pi
    for _ in range(5): orb.append(q); q = tuple((p + 1) % 5 for p in q)
    ORB.append(orb)
cnt = 0
for choice in product(range(5), repeat=6):
    targets = {frozenset((x + t) % 5 for x in CLASSREP[c]) for c, t in zip(range(6), choice)}
    if all(sum(1 for q in orb if not any(S in targets for S in PREF[q])) >= 2
           for orb in ORB):
        cnt += 1
print(f"transversals dodging all six classes: {cnt} of 15625 (0 => A4-fan dead for every pattern)")
