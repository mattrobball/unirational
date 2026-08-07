#!/usr/bin/env python3
# General ORDER-FAN machinery: for a primitive covector ell (integer 5-tuple
# taken mod diag), the order fan of (ell_k)_k, ell_k(n) = ell(sigma^k n).
# Regimes (mod 11): ALIGNED (ell == lambda*G9 + t*diag) vs GENERIC.
#   Aligned: level 1 forces v == 0 (mod 11) (ray degeneracy), and the exact
#     level-2 chamber rows collapse through the six twisted class sums to a
#     24x6 system with unique solution xi*(ell); the fan dies for EVERY
#     pattern iff xi*(ell) is nowhere zero (+ the covering theorem, which is
#     fan-independent for order fans).
#   Generic (11 coprime to the ray gap): level-1 class rows have targets
#     -<ray_ell(T_c), c9>; dies for every pattern iff all six are nonzero.
# This probe: classify ell, compute the six targets / xi*(ell), and report.
# Run on: the e_b-direction (2,1,-4,4,0) — closing the e_b-fan for all
# patterns; a few aligned perturbations G9 + 11*mu; a sweep of small generic
# ell counting how often a class target vanishes (the "bad generic" locus).
from fractions import Fraction as Fr
from itertools import combinations, permutations
from math import gcd
import random, sys

G9 = (1, 5, 3, 4, 9)
c9 = (4, 9, 1, 5, 3)
def sigN(n): return tuple(n[(j - 1) % 5] for j in range(5))
def c9pair(n): return sum(n[j] * c9[j] for j in range(5))

def make_fan(ell):
    def L(k, n):
        m = n
        for _ in range(k): m = sigN(m)
        return sum(m[j] * ell[j] for j in range(5))
    def solve_ray(S):
        Sl = sorted(S); Cl = sorted(set(range(5)) - S)
        def Lrow(k):
            row = []
            for i in range(5):
                e = [0] * 5; e[i] = 1
                row.append(L(k, tuple(e)))
            return row
        A = [[Fr(1)] * 5]; b = [Fr(0)]
        for a in Sl[1:]:
            A.append([Fr(x - y) for x, y in zip(Lrow(a), Lrow(Sl[0]))]); b.append(Fr(0))
        for a in Cl[1:]:
            A.append([Fr(x - y) for x, y in zip(Lrow(a), Lrow(Cl[0]))]); b.append(Fr(0))
        A.append([Fr(x - y) for x, y in zip(Lrow(Sl[0]), Lrow(Cl[0]))]); b.append(Fr(55))
        M = [row[:] + [b[i]] for i, row in enumerate(A)]
        for col in range(5):
            pr = next((r for r in range(col, len(M)) if M[r][col] != 0), None)
            if pr is None: return None  # degenerate ell (non-generic orbit)
            M[col], M[pr] = M[pr], M[col]
            pv = M[col][col]
            M[col] = [v / pv for v in M[col]]
            for r in range(len(M)):
                if r != col and M[r][col] != 0:
                    f = M[r][col]
                    M[r] = [v - f * w for v, w in zip(M[r], M[col])]
        n = [M[r][5] for r in range(5)]
        Lc = 1
        for v in n: Lc = Lc * v.denominator // gcd(Lc, v.denominator)
        ni = [int(v * Lc) for v in n]
        g = 0
        for v in ni: g = gcd(g, v)
        if g == 0: return None
        ni = [v // g for v in ni]
        if L(next(iter(S)), tuple(ni)) < L(next(iter(set(range(5)) - S)), tuple(ni)):
            ni = [-v for v in ni]
        return tuple(ni)
    return L, solve_ray

ALLS = [frozenset(S) for k in (1, 2, 3, 4) for S in combinations(range(5), k)]
CLASSREP = [frozenset({0}), frozenset({0, 1}), frozenset({0, 2}),
            frozenset({0, 1, 2}), frozenset({0, 1, 3}), frozenset({0, 1, 2, 3})]
def class_of(S):
    for i, T in enumerate(CLASSREP):
        if len(T) != len(S): continue
        for t in range(5):
            if frozenset((x + t) % 5 for x in T) == S: return i, t
    raise RuntimeError

def aligned_lambda(ell):
    # ell == lam*G9 + t*(1,..,1) mod 11?  return lam or None
    for lam in range(11):
        t = (ell[0] - lam * G9[0]) % 11
        if all((ell[j] - lam * G9[j] - t) % 11 == 0 for j in range(5)):
            return lam
    return None

def orbit_reps():
    reps = []; seen = set()
    for pi in permutations(range(5)):
        if pi in seen: continue
        orb = []; q = pi
        for _ in range(5): orb.append(q); q = tuple((p + 1) % 5 for p in q)
        seen.update(orb); reps.append(pi)
    return reps
REPS = orbit_reps()

def analyze(ell, verbose=True, seed=20260808):
    lam = aligned_lambda(ell)
    L, solve_ray = make_fan(ell)
    RAY = {}
    for S in ALLS:
        r = solve_ray(set(S))
        if r is None:
            if verbose: print(f"ell={ell}: degenerate ray {sorted(S)}; skipping")
            return None
        RAY[S] = r
    RAYGAP = {S: L(next(iter(S)), RAY[S]) -
                 L(next(iter(set(range(5)) - set(S))), RAY[S]) for S in ALLS}
    gaps11 = sorted(set(g % 11 for g in RAYGAP.values()))
    if lam is None:
        # generic: require gaps coprime to 11 for the clean criterion
        if 0 in gaps11:
            if verbose: print(f"ell={ell}: GENERIC but some ray gap == 0 mod 11 "
                              f"(regime iii); targets still necessary")
        targ = []
        for T in CLASSREP:
            targ.append((-sum(RAY[T][i] * c9[i] for i in range(5))) % 11)
        dead = all(targ)
        if verbose:
            print(f"ell={ell}: GENERIC; class targets {targ} -> "
                  f"{'DEAD for every pattern' if dead else 'ESCAPE CLASSES EXIST'}")
        return ('generic', targ, dead)
    # aligned: check ray degeneracy: all L-values of rays == 0 mod 11
    raydeg = all(all(L(k, RAY[S]) % 11 == 0 for k in range(5)) for S in ALLS)
    v11gap = sorted(set((g % 121 == 0) for g in RAYGAP.values()))
    if verbose:
        print(f"ell={ell}: ALIGNED (lambda = {lam}); ray degeneracy: {raydeg}; "
              f"any gap with 121|gap: {any(v11gap)}")
    if not raydeg:
        return ('aligned-anomaly', None, None)
    # exact level-2 chamber rows via a lattice witness per chamber-orbit
    def rank_pattern(n):
        vals = sorted([(L(k, n), k) for k in range(5)], reverse=True)
        return [k for _, k in vals], [v for v, _ in vals]
    rng = random.Random(seed)
    rows = {}
    tries = 0
    while len(rows) < 24 and tries < 400000:
        tries += 1
        n = [rng.randint(-15, 15) for _ in range(5)]
        n[4] -= sum(n)
        n = tuple(n)
        order, vals = rank_pattern(n)
        if len(set(vals)) < 5: continue
        V0 = sum(n[j] * G9[j] for j in range(5)) % 11
        if V0 == 0: continue
        pi = tuple(order)
        # orbit rep: smallest rotation
        rots = []
        q = pi
        for _ in range(5):
            rots.append(q); q = tuple((p + 1) % 5 for p in q)
        rep = min(rots)
        if rep in rows: continue
        # exact congruence row at n on ALL rays (no pattern):
        # r_S = sum_k 9^k * gap_j/RAYGAP; normalized: (11 r)*w = -c9pair(n)
        r = {}
        for k in range(5):
            m = n
            for _ in range(k): m = sigN(m)
            o2, v2 = rank_pattern(m)
            for j in range(1, 5):
                S = frozenset(o2[:j])
                g = v2[j - 1] - v2[j]
                r[S] = r.get(S, Fr(0)) + (9 ** k) * Fr(g, RAYGAP[S])
        Lc = 1
        for cf in r.values(): Lc = Lc * cf.denominator // gcd(Lc, cf.denominator)
        LL = Lc; e11 = 0
        while LL % 11 == 0: LL //= 11; e11 += 1
        if e11 != 1: continue  # need clean level-2 normalization
        u = LL
        uin = pow(u % 11, 9, 11)
        V0in = pow(V0, 9, 11)
        row = {}
        for S, cf in r.items():
            row[S] = (int(cf * Lc) * uin * V0in) % 11
        rows[rep] = row  # RHS normalized: -c9pair/V0 == -4
    if len(rows) < 24:
        if verbose: print(f"  only {len(rows)} chamber-orbits witnessed; abort")
        return ('aligned-incomplete', None, None)
    # verify sigma-invariance & class collapse; build 24x6 system
    A = []
    ok_collapse = True
    for rep, row in sorted(rows.items()):
        cls = [0] * 6
        for S, cf in row.items():
            c, t = class_of(S)
            # row must look like coeff_c * 5^t on class c... verify collapse:
            cls[c] = (cls[c] + cf * pow(9, t, 11)) % 11  # xi(T+t) = 9^t xi(T) => w-coeff transported
        # verification: reconstruct row from cls? do a direct check instead:
        for S, cf in row.items():
            c, t = class_of(S)
        A.append(cls)
    # solve A xi = -4 * 1
    M = [row[:] + [(-4) % 11] for row in A]
    r0 = 0; piv = []
    for col in range(6):
        pr = next((i for i in range(r0, len(M)) if M[i][col] % 11), None)
        if pr is None: continue
        M[r0], M[pr] = M[pr], M[r0]
        inv = pow(M[r0][col], 9, 11)
        M[r0] = [(x * inv) % 11 for x in M[r0]]
        for i in range(len(M)):
            if i != r0 and M[i][col] % 11:
                f = M[i][col]
                M[i] = [(x - f * y) % 11 for x, y in zip(M[i], M[r0])]
        piv.append(col); r0 += 1
    cons = all(M[i][6] % 11 == 0 for i in range(r0, len(M)))
    xistar = [0] * 6
    for i, c in enumerate(piv): xistar[c] = M[i][6]
    if verbose:
        print(f"  level-2 class system: rank {r0}/6, consistent {cons}, "
              f"xi*(ell) = {xistar}, nowhere-zero: {all(xistar) and r0 == 6}")
    if r0 == 6 and cons:
        return ('aligned', xistar, all(xistar))
    return ('aligned-odd', xistar, None)

if __name__ == '__main__':
    print("== the G9 direction (sanity: must reproduce (7,4,2,10,3,9)) ==")
    analyze(G9)
    print("\n== the e_b direction (2,1,-4,4,0) — closing the e_b-fan ==")
    analyze((2, 1, -4, 4, 0))
    print("\n== aligned perturbations G9 + 11*mu ==")
    for mu in [(1, 0, 0, 0, 0), (0, 1, 0, 0, 0), (1, -1, 0, 0, 0), (0, 0, 1, 1, 0)]:
        ell = tuple(G9[j] + 11 * mu[j] for j in range(5))
        analyze(ell)
    print("\n== generic sweep: small primitive ell, count escape classes ==")
    rng = random.Random(5)
    tot = bad = 0
    badex = []
    for _ in range(400):
        ell = tuple(rng.randint(-6, 6) for _ in range(5))
        if aligned_lambda(ell) is not None: continue
        res = analyze(ell, verbose=False)
        if res is None or res[0] != 'generic': continue
        tot += 1
        if not res[2]:
            bad += 1
            if len(badex) < 3: badex.append((ell, res[1]))
    print(f"generic ells tested: {tot}; with an escape class (some target 0): {bad}")
    for ell, targ in badex: print("  bad generic example:", ell, "targets", targ)
