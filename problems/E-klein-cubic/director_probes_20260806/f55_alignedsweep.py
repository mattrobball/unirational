#!/usr/bin/env python3
# f55_alignedsweep.py  --  ALIGNED order fans: mass sweep of xi*(ell), plus the
# level-3 analysis of the first depth-2 inhabitant of the IX-h tower.
#
# Context: FIX_IX_v14.md Sect. 8.22-8.24 (Theorem X, Theorem X''', case (iii)).
# For an ALIGNED primitive covector ell (ell == lam*G9 + t*diag mod 11) level 1
# forces the ray values v == 0 (mod 11), and the level-2 chamber rows collapse
# through the six twisted class sums to a 24x6 system with unique solution
# xi*(ell) in F_11^6.  The order fan of the sigma-orbit of ell then dies for
# EVERY zero-pattern iff xi*(ell) is nowhere zero (rank 6 + consistency, both
# reported by analyze()).  A ZERO COORDINATE of xi*(ell) would be a genuinely
# new escape needing a deeper analysis, so we hunt for one.
#
# PART A  calibration gate  : analyze(G9) == (8,3,7,2,5,4) and
#                             analyze((2,1,-4,4,0)) == (1,10,5,3,2,6).
# PART B  sweep             : ell = lam*G9 + 11*mu over a 3^5 grid, 300 random
#                             mu, and 50 random mu for each of lam = 2,3.
#                             Reports xi*, zero-hits, depth-2/3 aborts, and the
#                             "xi* depends only on mu mod 11" conjecture test.
# PART C  the depth tower   : run_case of f55_sweep2.py generalised to an
#                             arbitrary aligned ell and to an arbitrary number
#                             of 11-adic levels.  Calibrated on the G9-fan
#                             (must reproduce Correction IX-g's 8 + 18 split,
#                             all 18 dead at level 11^2), then applied to
#                             ell0 = (1,16,3,4,9) (all ray gaps 605 = 5*11^2)
#                             and to the depth-3 member (1,16,25,15,20)
#                             (all ray gaps 6655 = 5*11^3).
#
# HEADLINE (see the PART B output): over 455 depth-1 aligned fans NOT ONE xi*
# has a zero coordinate, and the reason is rigid -- every xi*(ell) is a nonzero
# F_11-multiple of the single vector XI_REF = (7,4,2,10,3,9), i.e. the class
# [xi*(ell)] in P(F_11^5) does not move.  Since rank 6 + RHS -4*(1..1) != 0
# force xi* != 0, projective rigidity ALONE implies nowhere-vanishing.
# And the depth tower is exactly one level per unit of v11(ray gap): the
# depth-t aligned fan dies at 11-adic level t+1, all 26 rank patterns.
#
# Reproduce:  python3 f55_alignedsweep.py          (all seeds fixed below)
#             python3 f55_alignedsweep.py --checkcopy   (verbatim-copy proof)
#             python3 f55_alignedsweep.py --fullcheck   (uncapped depth>=2 runs)
#
# NOTE ON THE COPIED MACHINERY.  Lines between the two "=== f55_ellfan.py
# machinery" banners are a verbatim copy of f55_ellfan.py lines 21-216, with
# EXACTLY three lines changed, each marked "# [MOD]":
#   (1) analyze()'s signature gains  tries_cap=400000
#   (2) the witness loop bound 400000 -> tries_cap
#   (3) the 'aligned-incomplete' return carries len(rows) instead of None
# Nothing mathematical is touched; the cap only lets the sweep abandon a
# depth>=2 fan after a few thousand tries instead of 400000 (~46 s each).
# The verbatim-copy claim is machine-checked by --checkcopy (see bottom).
from fractions import Fraction as Fr
from itertools import combinations, permutations
from math import gcd
import random, sys, time

# ===================== f55_ellfan.py machinery (copy) =====================
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

def analyze(ell, verbose=True, seed=20260808, tries_cap=400000):   # [MOD] tries_cap
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
    while len(rows) < 24 and tries < tries_cap:                     # [MOD] tries_cap
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
        return ('aligned-incomplete', len(rows), None)              # [MOD] len(rows)
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
# =================== end f55_ellfan.py machinery (copy) ===================

# ------------------------------ seeds -------------------------------------
SEED_RANDMU  = 20260807   # 300 random mu, lambda = 1
SEED_LAMVAR  = 20260811   # 50 random mu for each of lambda = 2, 3
SEED_PAIRS   = 20260813   # (mu, mu + 11 nu) conjecture pairs
SEED_ROWS    = 9          # lattice sampling in PART C (same as f55_sweep2.py)
SEED_ROWS_B  = 4242       # robustness re-run
TRIES_SHALLOW = 400000    # f55_ellfan.py default, used for depth-1 fans
TRIES_DEEP    = 4000      # abandon a fan whose ray gaps are 121-divisible

DIAG = (1, 1, 1, 1, 1)
XI_REF = (7, 4, 2, 10, 3, 9)   # Theorem X(c): the G9-fan xi* in the "2" norm.

def xi_scalar(x):
    """c in F_11^* with x == c * XI_REF, or None if x is not a multiple."""
    c = (x[0] * pow(XI_REF[0], 9, 11)) % 11
    return c if all((x[i] - c * XI_REF[i]) % 11 == 0 for i in range(6)) else None

def v11(x):
    """11-adic valuation of a nonzero integer."""
    if x == 0: return None
    e = 0
    x = abs(x)
    while x % 11 == 0: x //= 11; e += 1
    return e

def canon(ell):
    """Canonical representative of ell modulo diag and modulo positive scaling.
    The order fan and the whole (1)(2)(3)-system depend only on this: the ray
    generators are normalised primitive, so every d-row coefficient
    gap_j/RAYGAP_S is invariant under ell -> c*(ell + t*diag), c > 0."""
    e = [ell[j] - ell[0] for j in range(5)]
    g = 0
    for x in e: g = gcd(g, x)
    if g == 0: return (0, 0, 0, 0, 0)
    return tuple(x // g for x in e)

def fan_data(ell):
    """(L, RAY, RAYGAP) for the order fan of the sigma-orbit of ell, or None."""
    L, solve_ray = make_fan(ell)
    RAY = {}
    for S in ALLS:
        r = solve_ray(set(S))
        if r is None: return None
        RAY[S] = r
    RAYGAP = {S: L(next(iter(S)), RAY[S]) -
                 L(next(iter(set(range(5)) - set(S))), RAY[S]) for S in ALLS}
    return L, RAY, RAYGAP

def gap_depth(RAYGAP):
    """min over rays of v11(ray gap).  1 = ordinary aligned fan (analyze()
    applies); >= 2 = the fan is deeper 11-adically and analyze() aborts."""
    return min(v11(g) for g in RAYGAP.values())


# =========================== PART A: calibration ==========================
def part_A():
    print("=" * 74)
    print("PART A  CALIBRATION GATE (uncapped analyze, exactly as f55_ellfan.py)")
    print("=" * 74)
    ok = True
    for ell, want in [(G9, [8, 3, 7, 2, 5, 4]), ((2, 1, -4, 4, 0), [1, 10, 5, 3, 2, 6])]:
        res = analyze(ell, verbose=True)
        got = res[1] if res and res[0] == 'aligned' else None
        good = (got == want)
        ok = ok and good
        print(f"  gate ell={ell}: want {want}, got {got}  ->  {'PASS' if good else 'FAIL'}")
    print(f"CALIBRATION: {'PASS' if ok else 'FAIL'}")
    if not ok:
        print("ABORT: calibration gate failed; not proceeding.")
        sys.exit(1)
    return ok


# ============================== PART B: sweep =============================
def classify(ell):
    """Return dict with keys status, xistar, depth, gaps."""
    fd = fan_data(ell)
    if fd is None:
        return dict(status='degenerate-ray', xistar=None, depth=None, gaps=None)
    L, RAY, RAYGAP = fd
    dep = gap_depth(RAYGAP)
    gaps = sorted(set(RAYGAP.values()))
    cap = TRIES_SHALLOW if dep == 1 else TRIES_DEEP
    res = analyze(ell, verbose=False, tries_cap=cap)
    if res is None:
        return dict(status='degenerate-ray', xistar=None, depth=dep, gaps=gaps)
    kind = res[0]
    if kind == 'aligned':
        return dict(status='aligned', xistar=tuple(res[1]), depth=dep, gaps=gaps)
    if kind == 'aligned-incomplete':
        return dict(status=f'depth-{dep}', xistar=None, depth=dep, gaps=gaps,
                    orbits=res[1])
    return dict(status=kind, xistar=tuple(res[1]) if res[1] else None,
                depth=dep, gaps=gaps)

def part_B():
    print()
    print("=" * 74)
    print("PART B  SWEEP over aligned ell = lam*G9 + 11*mu")
    print("=" * 74)
    cases = []          # (tag, lam, mu, ell)
    seen = {}

    # (1) full 3^5 grid, lam = 1.  Constant mu are the diag shifts of G9 and
    # collapse onto G9 under canon(), so "minus constants" is automatic.
    ngrid = 0
    for mu in __import__('itertools').product((0, 1, 2), repeat=5):
        ngrid += 1
        ell = tuple(G9[j] + 11 * mu[j] for j in range(5))
        c = canon(ell)
        if c in seen: continue
        seen[c] = ell
        cases.append(('grid', 1, mu, ell))
    ngrid_kept = len(cases)

    # (2) 300 random mu in [-6,6]^5, lam = 1
    rng = random.Random(SEED_RANDMU)
    nrand = 0
    for _ in range(300):
        mu = tuple(rng.randint(-6, 6) for _ in range(5))
        nrand += 1
        ell = tuple(G9[j] + 11 * mu[j] for j in range(5))
        c = canon(ell)
        if c in seen: continue
        seen[c] = ell
        cases.append(('rand', 1, mu, ell))
    nrand_kept = len(cases) - ngrid_kept

    # (3) lam = 2, 3 with 50 random mu each
    rng2 = random.Random(SEED_LAMVAR)
    nlam = 0
    for lam in (2, 3):
        for _ in range(50):
            mu = tuple(rng2.randint(-6, 6) for _ in range(5))
            nlam += 1
            ell = tuple(lam * G9[j] + 11 * mu[j] for j in range(5))
            c = canon(ell)
            if c in seen: continue
            seen[c] = ell
            cases.append((f'lam{lam}', lam, mu, ell))
    nlam_kept = len(cases) - ngrid_kept - nrand_kept

    print(f"cases generated: grid {ngrid} (kept {ngrid_kept}), "
          f"random {nrand} (kept {nrand_kept}), lam-variants {nlam} "
          f"(kept {nlam_kept}); total distinct fans {len(cases)}")

    t0 = time.time()
    out = []
    for tag, lam, mu, ell in cases:
        r = classify(ell)
        r.update(tag=tag, lam=lam, mu=mu, ell=ell)
        out.append(r)
    print(f"swept {len(out)} fans in {time.time() - t0:.1f}s")

    # ---- (a) how many produced xi* -------------------------------------
    withxi = [r for r in out if r['status'] == 'aligned']
    print()
    print(f"(a) xi* computed for {len(withxi)} / {len(out)} fans")
    bystat = {}
    for r in out: bystat[r['status']] = bystat.get(r['status'], 0) + 1
    for k in sorted(bystat): print(f"      status {k:16s} : {bystat[k]}")

    # ---- (b) zero coordinates ------------------------------------------
    zeros = [r for r in withxi if not all(r['xistar'])]
    print()
    if zeros:
        print("!" * 74)
        print("!!!!  ZERO COORDINATE FOUND IN xi*(ell) -- NEW ESCAPE CANDIDATE  !!!!")
        for r in zeros:
            print(f"!!!!  ell={r['ell']} (lam={r['lam']}, mu={r['mu']}) "
                  f"xi*={list(r['xistar'])}")
        print("!" * 74)
    else:
        print(f"(b) ZERO-HITS: none.  All {len(withxi)} computed xi* are "
              f"nowhere zero  ->  every one of these fans dies for EVERY pattern.")
    dist = {}
    for r in withxi: dist[r['xistar']] = dist.get(r['xistar'], 0) + 1
    print(f"    distinct xi* values observed: {len(dist)}")
    for x, c in sorted(dist.items(), key=lambda kv: -kv[1])[:12]:
        print(f"      {list(x)}  x{c}")
    if len(dist) > 12: print(f"      ... ({len(dist) - 12} more)")

    # ---- (b') projective rigidity: xi*(ell) is always F_11^* . XI_REF ---
    # Note xi* = 0 is impossible a priori (rank 6 and RHS -4*(1..1) != 0), so
    # proportionality to a nowhere-zero reference IMPLIES nowhere-zero.
    print()
    print("(b') projective rigidity test: is xi*(ell) always a scalar multiple")
    print(f"     of the G9-fan value XI_REF = {list(XI_REF)}? "
          f"(Theorem X(c) normalisation A.xi = 2.(1..1))")
    scals = {}
    bad = []
    for r in withxi:
        c = xi_scalar(r['xistar'])
        if c is None: bad.append(r)
        else: scals[c] = scals.get(c, 0) + 1
    if bad:
        print(f"     NOT rigid: {len(bad)} of {len(withxi)} xi* are not multiples "
              f"of XI_REF, e.g. {list(bad[0]['xistar'])} at ell={bad[0]['ell']}")
    else:
        print(f"     RIGID: all {len(withxi)} computed xi* equal c*XI_REF with "
              f"c in F_11^*; the class [xi*] in P(F_11^5) is CONSTANT over")
        print( "     aligned ell.  Since xi* != 0 always, this forces xi*(ell)")
        print( "     nowhere zero for every aligned ell in the sweep.")
        print(f"     scalar c histogram: "
              f"{{{', '.join(f'{k}: {scals[k]}' for k in sorted(scals))}}}")

    # ---- (c) does xi* depend only on mu mod 11? ------------------------
    print()
    print("(c) conjecture: xi*(lam*G9 + 11*mu) depends only on (lam, mu mod 11)")
    rngp = random.Random(SEED_PAIRS)
    match = mism = 0
    skipped = 0
    examples = []
    pairs = 0
    attempts = 0
    while pairs < 30 and attempts < 400:
        attempts += 1
        lam = rngp.choice((1, 2, 3))
        mu = tuple(rngp.randint(-5, 5) for _ in range(5))
        nu = tuple(rngp.randint(-3, 3) for _ in range(5))
        if all(x == 0 for x in nu): continue
        mu2 = tuple(mu[j] + 11 * nu[j] for j in range(5))
        e1 = tuple(lam * G9[j] + 11 * mu[j] for j in range(5))
        e2 = tuple(lam * G9[j] + 11 * mu2[j] for j in range(5))
        r1, r2 = classify(e1), classify(e2)
        if r1['status'] != 'aligned' or r2['status'] != 'aligned':
            skipped += 1; continue
        pairs += 1
        if r1['xistar'] == r2['xistar']: match += 1
        else:
            mism += 1
            if len(examples) < 5:
                examples.append((lam, mu, nu, list(r1['xistar']), list(r2['xistar'])))
    print(f"    usable pairs {pairs} (skipped {skipped} where a member was "
          f"depth>=2/degenerate); MATCH {match}, MISMATCH {mism}")
    verdict = ("CONFIRMED on this sample" if mism == 0 else "REFUTED")
    print(f"    verdict: xi* depends only on (lam, mu mod 11): {verdict}")
    for ex in examples:
        print(f"      counterexample lam={ex[0]} mu={ex[1]} nu={ex[2]}: "
              f"{ex[3]} (c={xi_scalar(tuple(ex[3]))}) vs "
              f"{ex[4]} (c={xi_scalar(tuple(ex[4]))})")
    if mism:
        print("    NOTE: by (b') every mismatch is a pure change of the scalar c;")
        print("          the projective class [xi*] is the same on both sides, so")
        print("          the nowhere-zero conclusion is untouched.")

    # ---- (d) depth-2 (and deeper) list ---------------------------------
    print()
    deep = [r for r in out if r['status'].startswith('depth-')]
    bydepth = {}
    for r in deep: bydepth.setdefault(r['depth'], []).append(r)
    print(f"(d) depth>=2 fans found: {len(deep)}  "
          f"(by depth: {{{', '.join(f'{d}: {len(v)}' for d, v in sorted(bydepth.items()))}}})")
    for d in sorted(bydepth):
        print(f"    --- depth {d} (all ray gaps = 5*11^{d}); "
              f"analyze() aborts with 0 chamber-orbits ---")
        for r in sorted(bydepth[d], key=lambda r: r['ell'])[:60]:
            print(f"      ell={str(r['ell']):26s} lam={r['lam']} mu={r['mu']} "
                  f"gaps={r['gaps']} orbits={r.get('orbits')}")
        if len(bydepth[d]) > 60: print(f"      ... ({len(bydepth[d]) - 60} more)")
    return out


# ================== PART C: the 11-adic level tower =======================
# Generalisation of f55_sweep2.py's run_case to an arbitrary aligned ell and to
# an arbitrary number of levels.  Row bookkeeping is identical to run_case:
#   a-rows  (row, 0, Lc)          : integrality of d at a lattice point,
#                                   row . v == 0 (mod Lc)
#   b-rows  (row, c9pair(n)*Lc, 11*Lc)
#                                 : integrality of sum_k 9^k d(sigma^k n)
#                                   together with congruence (ii),
#                                   row . v + rhs == 0 (mod 11*Lc)
# LEVEL REDUCTION (derived cleanly, replaces run_case's ad-hoc level-121 block).
# Substituting v = 11^s * y into  row . v + rhs == 0 (mod M)  gives
#   11^s (row . y) + rhs == 0 (mod M),   e := v11(M).
# Solvability needs 11^min(s,e) | rhs.  If e > s (so 11^s | rhs) divide by 11^s:
#   row . y + rhs/11^s == 0  (mod 11^(e-s) * M'),  M' = M/11^e,
# whose mod-11 shadow is  row . y == -(rhs/11^s)  (mod 11).
# If e <= s the surviving congruence is modulo M' only: NO mod-11 content, and
# such rows are correctly dropped (run_case's `else` branch at level 11 divided
# by L mod 11 instead, which manufactures information; here we do not).
def build_rows(ell, zero_region, seed=SEED_ROWS, npts=2500, rng_range=6):
    fd = fan_data(ell)
    if fd is None: return None, 0, None
    L, RAY, RAYGAP = fd
    def rank_pattern(n):
        vals = sorted([(L(k, n), k) for k in range(5)], reverse=True)
        return [k for _, k in vals], [v for v, _ in vals]
    freeS = []
    for S in ALLS:
        bordered = False
        for pi in permutations(range(5)):
            if frozenset(pi[:len(S)]) == S and zero_region(pi):
                bordered = True; break
        if not bordered: freeS.append(S)
    idx = {S: i for i, S in enumerate(freeS)}
    nf = len(freeS)
    if nf == 0: return None, 0, RAYGAP
    def d_row(n):
        order, vals = rank_pattern(n)
        pi = tuple(order)
        if zero_region(pi): return {}
        row = {}
        for k in range(1, 5):
            S = frozenset(order[:k])
            gap = vals[k - 1] - vals[k]
            if gap == 0 or S not in idx: continue
            row[S] = row.get(S, Fr(0)) + Fr(gap, RAYGAP[S])
        return row
    rng = random.Random(seed)
    rowsZ = []
    for _ in range(npts):
        n = [rng.randint(-rng_range, rng_range) for _ in range(5)]
        n[4] -= sum(n)
        n = tuple(n)
        for k in range(5):
            m = n
            for _ in range(k): m = sigN(m)
            rr = d_row(m)
            if not rr: continue
            Lc = 1
            for cf in rr.values(): Lc = Lc * cf.denominator // gcd(Lc, cf.denominator)
            if Lc > 1:
                row = [0] * nf
                for S, cf in rr.items(): row[idx[S]] = int(cf * Lc)
                rowsZ.append((row, 0, Lc))
        row = {}
        for k in range(5):
            m = n
            for _ in range(k): m = sigN(m)
            for S, cf in d_row(m).items():
                row[S] = row.get(S, Fr(0)) + (9 ** k) * cf
        Lc = 1
        for cf in row.values(): Lc = Lc * cf.denominator // gcd(Lc, cf.denominator)
        r2 = [0] * nf
        for S, cf in row.items(): r2[idx[S]] = int(cf * Lc)
        rowsZ.append((r2, c9pair(n) * Lc, 11 * Lc))
    return rowsZ, nf, RAYGAP

def gauss(A, p, nf):
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

def level_rows(rowsZ, s):
    """mod-11 shadow of the system after the substitution v = 11^s * y."""
    out = []
    for row, rhs, M in rowsZ:
        e = v11(M)
        if rhs % (11 ** min(s, e)) != 0:
            return 'VALUATION-CLASH', None
        if e > s:
            out.append([x % 11 for x in row] + [(-(rhs // 11 ** s)) % 11])
    return 'ok', out

def descend(rowsZ, nf, maxlevel=5):
    """Iterate the level reduction.  Returns (verdict, trace)."""
    trace = []
    for s in range(maxlevel):
        st, rows = level_rows(rowsZ, s)
        if st != 'ok':
            return f"DEAD at level 11^{s+1} (rhs 11-valuation clash)", trace
        if not rows:
            trace.append((s + 1, 0, None, None, None))
            return f"level 11^{s+1}: NO mod-11 content in the sample", trace
        cons, rk, sol, piv = gauss([r[:] for r in rows], 11, nf)
        trace.append((s + 1, len(rows), rk, cons, sol))
        if not cons:
            return f"DEAD at level 11^{s+1}", trace
        if rk < nf:
            return (f"level 11^{s+1}: consistent, rank {rk}/{nf} -> NOT forced "
                    f"(!! needs a closer look)"), trace
        if any(sol):
            return (f"level 11^{s+1}: unique but NONZERO solution -> NOT forced "
                    f"(!! needs a closer look)"), trace
    return f"forced 0 through level 11^{maxlevel} (no kill seen)", trace

def zero_check(rowsZ):
    """If the descent forces v == 0 mod 11^s for every s then v = 0; check that
    v = 0 itself contradicts the anchor rows."""
    for row, rhs, M in rowsZ:
        if rhs % M != 0: return True
    return False

def tower_table(ell, label, maxlevel=5, seed=SEED_ROWS, npts=2500, rng_range=6):
    fd = fan_data(ell)
    L, RAY, RAYGAP = fd
    gaps = sorted(set(RAYGAP.values()))
    print()
    print("-" * 74)
    print(f"{label}: ell = {ell}   ray gaps {gaps}  "
          f"(v11 = {sorted(set(v11(g) for g in RAYGAP.values()))})  "
          f"lambda = {aligned_lambda(ell)}")
    raydeg = all(all(L(k, RAY[S]) % 11 == 0 for k in range(5)) for S in ALLS)
    print(f"   ray degeneracy (all ray L-values == 0 mod 11): {raydeg}   "
          f"[seed {seed}, {npts} lattice points, entries in [-{rng_range},{rng_range}]]")
    print("-" * 74)
    summary = {}
    for psz in range(2, 6):
        for P in combinations(range(5), psz):
            Pf = frozenset(P)
            rowsZ, nf, _ = build_rows(ell, lambda pi, Pf=Pf: pi.index(0) in Pf,
                                      seed=seed, npts=npts, rng_range=rng_range)
            if rowsZ is None:
                print(f"  P = {str(sorted(P)):15s} no free rays (d = 0 forced) "
                      f"-> anchors violated -> INFEASIBLE")
                summary['no-free-rays'] = summary.get('no-free-rays', 0) + 1
                continue
            verdict, trace = descend(rowsZ, nf, maxlevel=maxlevel)
            steps = "  ".join(
                f"L{t[0]}[rows {t[1]}, rk {t[2]}/{nf}, cons {t[3]}, "
                f"{'sol=0' if t[4] is not None and not any(t[4]) else 'sol!=0' if t[4] else '-'}]"
                for t in trace)
            print(f"  P = {str(sorted(P)):15s} nf={nf:2d}  {steps}")
            print(f"      -> {verdict}")
            if verdict.startswith("DEAD"):
                key = verdict.split('(')[0].strip()
            elif verdict.startswith("forced 0"):
                key = f"forced 0 through 11^{maxlevel}; v=0 contradicts anchors: " \
                      f"{zero_check(rowsZ)}"
            else:
                key = "NOT FORCED -- ESCAPE CANDIDATE"
            summary[key] = summary.get(key, 0) + 1
    print(f"  SUMMARY {label}: " +
          "; ".join(f"{k}: {v}" for k, v in sorted(summary.items())))
    bad = [k for k in summary if 'ESCAPE' in k]
    if bad:
        print("!" * 74)
        print(f"!!!!  FEASIBLE / UNFORCED PATTERN(S) on {label}  !!!!")
        print("!" * 74)
    return summary

def part_C():
    print()
    print("=" * 74)
    print("PART C  THE 11-ADIC LEVEL TOWER, all 26 rank patterns")
    print("        (zero region iff position of index 0 in the descending")
    print("         H-ordering lies in P; |P| >= 2; conventions of f55_sweep2.py)")
    print("=" * 74)
    print()
    print(">>> C0  CALIBRATION on the G9-fan: must reproduce Correction IX-g")
    print(">>>     (8 patterns with no free rays, 18 dead at level 11^2)")
    s0 = tower_table(G9, "G9-fan (depth 1)", maxlevel=4)

    print()
    print(">>> C1  the depth-2 inhabitant ell0 = (1,16,3,4,9) = G9 + 11*e1")
    s1 = tower_table((1, 16, 3, 4, 9), "ell0 = G9 + 11 e1 (depth 2)", maxlevel=5)

    print()
    print(">>> C2  robustness: ell0 again, fresh seed / more points / wider box")
    s1b = tower_table((1, 16, 3, 4, 9), "ell0 (depth 2) [robustness]",
                      maxlevel=5, seed=SEED_ROWS_B, npts=1500, rng_range=9)

    print()
    print(">>> C3  bonus: a depth-3 member, ell1 = (1,16,25,15,20)")
    s2 = tower_table((1, 16, 25, 15, 20), "ell1 (depth 3)", maxlevel=6)

    print()
    print("=" * 74)
    print("PART C VERDICTS")
    print(f"  G9-fan   (depth 1): {dict(sorted(s0.items()))}")
    print(f"  ell0     (depth 2): {dict(sorted(s1.items()))}")
    print(f"  ell0 alt (depth 2): {dict(sorted(s1b.items()))}")
    print(f"  ell1     (depth 3): {dict(sorted(s2.items()))}")
    return s0, s1, s1b, s2


def full_check():
    """The sweep abandons a depth>=2 fan after TRIES_DEEP witnesses instead of
    the f55_ellfan.py default 400000 (~46 s per fan).  This confirms on three
    representatives that the uncapped run reaches the identical verdict
    ('only 0 chamber-orbits witnessed; abort')."""
    print("uncapped analyze() on three depth>=2 representatives "
          f"(default tries_cap = {TRIES_SHALLOW}):")
    for ell in [(1, 16, 3, 4, 9), (1, 5, 14, 4, 9), (1, 16, 25, 15, 20)]:
        t = time.time()
        res = analyze(ell, verbose=True)
        print(f"   ell={ell} -> {res}   [{time.time() - t:.1f}s]")


if __name__ == '__main__':
    if '--fullcheck' in sys.argv:
        full_check(); sys.exit(0)
    if '--checkcopy' in sys.argv:
        # machine-check the verbatim-copy claim for the machinery block
        import difflib, os
        here = os.path.dirname(os.path.abspath(__file__))
        src = open(os.path.join(here, 'f55_ellfan.py')).readlines()[20:216]
        me = open(os.path.abspath(__file__)).readlines()
        i = next(k for k, l in enumerate(me) if l.startswith('# ====') and 'machinery (copy)' in l)
        j = next(k for k, l in enumerate(me) if l.startswith('# ====') and 'end f55_ellfan' in l)
        mine = me[i + 1:j]
        diff = [d for d in difflib.unified_diff(src, mine, n=0)
                if d.startswith(('+', '-')) and not d.startswith(('+++', '---'))]
        print(f"machinery block: {len(src)} source lines vs {len(mine)} copied lines; "
              f"{len(diff)} differing lines")
        for d in diff: print("   ", d.rstrip())
        sys.exit(0)
    t0 = time.time()
    part_A()
    part_B()
    part_C()
    print()
    print(f"total wall time {time.time() - t0:.1f}s")
