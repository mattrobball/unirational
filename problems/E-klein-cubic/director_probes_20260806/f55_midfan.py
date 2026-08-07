#!/usr/bin/env python3
# f55_midfan.py -- the OPEN regime (iv) of Theorem X''' (FIX_IX_v14 §8.24),
# machine-checked at LEVEL 2.
#
# Regime (iv): ell a primitive covector with 5 in A(ell) and {5} strictly
# inside A(ell) strictly inside {3,9,5,4}; i.e. the aligned (eps=5) component
# survives and exactly one or two of the components at eps in {3,9,4} die.
# On such order fans §8.24 records: every ray value is ==0 mod 11, all six
# class targets -<ray,c9> vanish (so the level-1 ray-point kill of (ii) fails),
# and the chamber profile carries |A| parameters (so the single-V0 collapse of
# the aligned case (iii) fails).  What is left is the LEVEL-2 system on w=v/11.
# This probe builds that system exactly and sweeps patterns.
#
# ---------------------------------------------------------------------------
# DERIVATION OF THE ROWS USED HERE (all normalisations 11-adic).
#
# Fan: order fan of ell_k(n) = ell(sigma^k n), k in Z/5, on N = {sum n = 0}.
# Chambers <-> orderings pi (descending); the chamber of sigma^k n is pi - k
# (elementwise mod 5).  Rays r_S, S a proper nonempty subset of Z/5 (top block);
# R_S := RAYGAP_S = (ell-value on S) - (ell-value off S) > 0.  For n interior
# to the chamber of pi with sorted gaps g_j = W_j - W_{j+1} (j=1..4),
#     n = sum_j (g_j / R_{S_j}) r_{S_j},   S_j = pi[:j],
# hence for the PL function d with ray values v:  d(n) = sum_j (g_j/R_j) v_{S_j}.
# In regime (iv) v11(R_S) = 1 for every ray (checked; the deeper fans with
# v11 >= 2 are reported and skipped -- they need level 3).
#
# LEVEL-1 mod-11 shadows (v = ray values):
#   (a) integrality  d(m) in Z.  With rho_S := 11*g_S/R_S in Z_11,
#       d(m) = (1/11) sum rho_S v_S, so d(m) in Z_11  <=>  sum (rho_S mod 11) v_S == 0.
#       [f55_sweep2.py stores this as (L*coeffs, 0, L); the mod-11 content is
#        nonvacuous exactly when 11 | L, and equals the row above.]
#   (b) congruence (3): sum_S r_S v_S + <n,c9> == 0 (mod 11),
#       r_S := sum_k 9^k * (gap of translate k at level |S|)/R_S.
#       If v11(lcm den r) = 0 (all r_S 11-integral) this IS a mod-11 row
#       (r mod 11 | -<n,c9>).  If v11 = 1, write rho = 11r in Z_11: the
#       constraint is rho.v == -11<n,c9> (mod 121), whose mod-11 shadow is
#       (rho mod 11).v == 0.
#
# LEVEL-2 (v = 11w, legitimate once level 1 forces v == 0 mod 11):
#   (b) becomes   sum_S (11 r_S mod 11) w_S == -<n,c9>  (mod 11).
#   (a) becomes vacuous mod 11 (11 g/R is already 11-integral).
#   Per-ray closed form used here (identical to the lcm normalisation of
#   f55_ellfan.analyze()/f55_exact2.sampled_level2_row, asserted equal on every
#   collected sample):  11 r_S = 9^k * g / (R_S/11), so the coefficient is
#       (9^k * g * inv(R_S/11)) mod 11,
#   and since a given S is the |S|-prefix of at most one translate, the row
#   splits as a SUM OF FIVE PER-TRANSLATE PARTIAL ROWS.  Indexing translates by
#   t = k - s (s the shift with chamber(n) = rep + s) makes partial t the
#   contribution of the orbit chamber rep - t, so the row for a zero-pattern
#   with zero-translate set Z is  sum_{t not in Z} partial_t : this is the
#   "per-(orbit,k) separated form".  (Dropping t in Z agrees with keeping it and
#   imposing w=0 on bordered rays: the 4 prefixes of a zero chamber are all
#   bordered.  Asserted in the calibration.)
#
# Row space bound (why the sampling below is provably saturated): the gaps, and
# hence every partial row and the rhs -<n,c9>, are linear in n mod 11 through
# the |A| surviving eigen-coordinates only; and base points differing by sigma
# scale the whole augmented row by 5.  So each (orbit, Z) augmented row space
# has dimension <= |A|.  The runs below attain |A| for Z = empty, i.e. the
# collection is complete, not merely stalled.
#
# PATTERNS: an assignment orbit-rep pi |-> Z(pi) subset Z/5 with |Z| >= 2; the
# zero chambers of that orbit are pi - t, t in Z.  Rank pattern P (zero iff the
# position of 0 in the ordering lies in P) is Z(pi) = {t : pi.index(t) in P}.
# Bordered rays = all prefixes of all zero chambers; the pattern system is
# {collected level-2 rows for the pattern's Z} + {w_S = 0 for bordered S}.
#
# CALIBRATION GATE: on ell = G9 this pipeline must reproduce Theorem X's known
# verdict -- all 26 rank patterns infeasible, with exactly the 8 no-free-ray
# patterns of Correction IX-g.  Nothing is run until that passes.
#
# Nothing here is claimed beyond "level-2 shadow (in)feasible for this fan +
# pattern".  Deterministic: every RNG is a seeded random.Random.
#
# Run:  python3 f55_midfan.py
from fractions import Fraction as Fr
from itertools import combinations, permutations
from math import gcd
import random, sys, time

G9 = (1, 5, 3, 4, 9)
c9 = (4, 9, 1, 5, 3)
EPS = [3, 9, 5, 4]
def sigN(n): return tuple(n[(j - 1) % 5] for j in range(5))
def c9pair(n): return sum(n[j] * c9[j] for j in range(5))

def comps(ell):
    """mod-11 eigencomponents <ell, v_eps>, v_eps = ((eps^-1)^j)_j."""
    return {e: sum(ell[j] * pow(pow(e, 9, 11), j, 11) for j in range(5)) % 11
            for e in EPS}
def active(ell):
    cp = comps(ell)
    return tuple(sorted(e for e in EPS if cp[e]))

def v11(x):
    e = 0
    while x % 11 == 0: x //= 11; e += 1
    return e

# ---------------- order-fan machinery (copied from f55_ellfan.py) -----------
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
            if pr is None: return None
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
IDX = {S: i for i, S in enumerate(ALLS)}
NR = len(ALLS)                     # 30 rays
def rot(pi, t): return tuple((p + t) % 5 for p in pi)
def orbit_reps():
    reps = []; seen = set()
    for pi in permutations(range(5)):
        if pi in seen: continue
        for t in range(5): seen.add(rot(pi, t))
        reps.append(pi)
    return reps
REPS = orbit_reps()
assert len(REPS) == 24
ALLZ = [frozenset(Z) for k in range(6) for Z in combinations(range(5), k)]
ADMZ = [Z for Z in ALLZ if len(Z) >= 2]
assert len(ADMZ) == 26

# ---------------- F11 reduced row echelon ----------------------------------
class Ech:
    __slots__ = ('piv', 'nc')
    def __init__(self, nc): self.piv = {}; self.nc = nc
    def add(self, row):
        row = list(row)
        for c in sorted(self.piv):
            if row[c]:
                f = row[c]; p = self.piv[c]
                row = [(x - f * y) % 11 for x, y in zip(row, p)]
        for c in range(self.nc):
            if row[c]:
                inv = pow(row[c], 9, 11)
                new = [(x * inv) % 11 for x in row]
                for c2 in list(self.piv):            # keep it REDUCED
                    if self.piv[c2][c]:
                        f = self.piv[c2][c]
                        self.piv[c2] = [(x - f * y) % 11
                                        for x, y in zip(self.piv[c2], new)]
                self.piv[c] = new
                return True
        return False
    def rows(self): return [self.piv[c] for c in sorted(self.piv)]
    def dim(self): return len(self.piv)
    def contains(self, row):
        row = list(row)
        for c in sorted(self.piv):
            if row[c]:
                f = row[c]; p = self.piv[c]
                row = [(x - f * y) % 11 for x, y in zip(row, p)]
        return not any(row)
    def nullspace(self):
        """basis of {x : (rows).x = 0}, valid because self is reduced."""
        piv = sorted(self.piv)
        out = []
        for fc in [c for c in range(self.nc) if c not in self.piv]:
            x = [0] * self.nc; x[fc] = 1
            for c in piv: x[c] = (-self.piv[c][fc]) % 11
            out.append(x)
        return out

# ---------------- fan construction + regime-(iv) checks --------------------
def build_fan(ell):
    L, solve_ray = make_fan(ell)
    RAY = {}
    for S in ALLS:
        r = solve_ray(set(S))
        if r is None: return None, "degenerate ray %s" % sorted(S)
        RAY[S] = r
    RG = {S: L(next(iter(S)), RAY[S]) -
             L(next(iter(set(range(5)) - set(S))), RAY[S]) for S in ALLS}
    vs = sorted(set(v11(g) for g in RG.values()))
    info = dict(RAYGAP=sorted(set(RG.values())), v11set=vs,
                raydeg=all(all(L(k, RAY[S]) % 11 == 0 for k in range(5)) for S in ALLS),
                targets=sorted(set(c9pair(RAY[S]) % 11 for S in ALLS)))
    if vs != [1]:
        return None, "DEEPER: v11(RAYGAP) set = %s (needs level >= 3)" % vs
    return (L, RAY, RG, info), None

def chamber(L, n):
    v = sorted([(L(k, n), k) for k in range(5)], reverse=True)
    return tuple(k for _, k in v), [x for x, _ in v]

def sample_in_chamber(L, RAY, pi, rng, K):
    """interior lattice point of the chamber pi: deep cone point + full mod-11
    perturbation (the 4 free deltas in [-5,5] hit every class of N/11N)."""
    pref = [frozenset(pi[:j]) for j in range(1, 5)]
    for _ in range(400):
        n = [0] * 5
        for S in pref:
            a = rng.randint(K, 2 * K); r = RAY[S]
            for i in range(5): n[i] += a * r[i]
        d = [rng.randint(-5, 5) for _ in range(4)]; d.append(-sum(d))
        for i in range(5): n[i] += d[i]
        n = tuple(n); o, vals = chamber(L, n)
        if o == pi and len(set(vals)) == 5: return n
    raise RuntimeError("sampler failed for chamber %s" % (pi,))

def sample_data(L, RG, n, rep):
    """per-translate partial mod-11 rows q[t] (t = k - s indexes chamber rep-t),
    rhs, v11(lcm den), shift s, and the exact Fraction row."""
    o0, _ = chamber(L, n)
    s = next(t for t in range(5) if rot(rep, t) == o0)
    q = [None] * 5; exact = {}
    for k in range(5):
        m = n
        for _ in range(k): m = sigN(m)
        o, vals = chamber(L, m)
        d = {}
        for j in range(1, 5):
            S = frozenset(o[:j]); g = vals[j - 1] - vals[j]; u = RG[S] // 11
            d[S] = (pow(9, k, 11) * g * pow(u % 11, 9, 11)) % 11
            exact[S] = exact.get(S, Fr(0)) + (9 ** k) * Fr(g, RG[S])
        q[(k - s) % 5] = d
    Lc = 1
    for cf in exact.values(): Lc = Lc * cf.denominator // gcd(Lc, cf.denominator)
    return q, (-c9pair(n)) % 11, v11(Lc), s, exact, Lc

# ---------------- level 1 (no pattern) -------------------------------------
def level1(ell, L, RAY, RG, seed=20260807, per_orbit=25):
    rng = random.Random(seed); K = 10 * max(abs(x) for x in ell) + 12
    E = Ech(NR + 1); Ec = Ech(NR); nrows = 0
    for rep in REPS:
        for _ in range(per_orbit):
            n = sample_in_chamber(L, RAY, rot(rep, rng.randrange(5)), rng, K)
            for k in range(5):                      # (a) integrality rows
                m = n
                for _ in range(k): m = sigN(m)
                o, vals = chamber(L, m)
                row = [0] * (NR + 1)
                for j in range(1, 5):
                    S = frozenset(o[:j]); g = vals[j - 1] - vals[j]; u = RG[S] // 11
                    row[IDX[S]] = (row[IDX[S]] + g * pow(u % 11, 9, 11)) % 11
                E.add(row); Ec.add(row[:NR]); nrows += 1
            q, rhs, e, s, exact, Lc = sample_data(L, RG, n, rep)   # (b) congruence
            row = [0] * (NR + 1)
            if e == 1:
                u = Lc // 11; uin = pow(u % 11, 9, 11)
                for S, cf in exact.items(): row[IDX[S]] = (int(cf * Lc) * uin) % 11
            elif e == 0:
                for S, cf in exact.items():
                    row[IDX[S]] = (cf.numerator * pow(cf.denominator % 11, 9, 11)) % 11
                row[NR] = rhs
            else:
                raise RuntimeError("v11(lcm) = %d unexpected" % e)
            E.add(row); Ec.add(row[:NR]); nrows += 1
    return nrows, Ec.dim(), E.dim(), Ec.nullspace()

def U_family(RAY):
    """span of v_S = <U, r_S> mod 11 over U in (Z^5/diag)/11 -- the linear PL
    functions; these solve integrality and (3)'s mod-11 shadow exactly."""
    E = Ech(NR)
    for i in range(5):
        E.add([RAY[S][i] % 11 for S in ALLS])
    return E

# ---------------- level 2: collection --------------------------------------
def collect(ell, L, RAY, RG, seed=20260808, min_samp=250, stale_need=200, maxs=6000):
    K = 10 * max(abs(x) for x in ell) + 12
    rng = random.Random(seed)
    bases = {rep: {Z: Ech(NR + 1) for Z in ALLZ} for rep in REPS}
    store = {rep: [] for rep in REPS}
    ndeg = ndegbad = nchk = 0
    for rep in REPS:
        stale = 0; ns = 0
        while ns < maxs and (ns < min_samp or stale < stale_need):
            n = sample_in_chamber(L, RAY, rot(rep, rng.randrange(5)), rng, K)
            q, rhs, e, s, exact, Lc = sample_data(L, RG, n, rep)
            if e != 1:
                ndeg += 1
                if rhs: ndegbad += 1          # would be an immediate level-1.5 kill
                continue
            u = Lc // 11; uin = pow(u % 11, 9, 11)
            ref = {S: (int(cf * Lc) * uin) % 11 for S, cf in exact.items()}
            tot = {}
            for t in range(5):
                for S, cv in q[t].items(): tot[S] = (tot.get(S, 0) + cv) % 11
            assert all(ref.get(S, 0) == tot.get(S, 0) for S in set(ref) | set(tot)), \
                "lcm normalisation != per-ray normalisation"
            nchk += 1; ns += 1; grew = False
            store[rep].append((q, rhs))
            for Z in ALLZ:
                row = [0] * (NR + 1)
                for t in range(5):
                    if t in Z: continue
                    for S, cv in q[t].items(): row[IDX[S]] = (row[IDX[S]] + cv) % 11
                row[NR] = rhs
                if bases[rep][Z].add(row): grew = True
            stale = 0 if grew else stale + 1
    return bases, store, ndeg, ndegbad, nchk

# ---------------- patterns --------------------------------------------------
def border_of(pattern):
    B = set()
    for rep, Z in pattern.items():
        for t in Z:
            q = rot(rep, (-t) % 5)
            for j in range(1, 5): B.add(frozenset(q[:j]))
    return B

def rank_pattern(P):
    return {rep: frozenset(t for t in range(5) if rep.index(t) in P) for rep in REPS}

def free_rays_brute(P):
    out = set()
    for S in ALLS:
        if not any(frozenset(pi[:len(S)]) == S and pi.index(0) in P
                   for pi in permutations(range(5))): out.add(S)
    return out

def feasible(bases, pattern):
    """mod-11 feasibility of {level-2 rows for this pattern} + {w=0 on bordered}."""
    B = border_of(pattern)
    free = [IDX[S] for S in ALLS if S not in B]
    nf = len(free); piv = {}
    for rep, Z in pattern.items():
        for r in bases[rep][Z].rows():
            row = [r[i] for i in free] + [r[NR]]
            for c in sorted(piv):
                if row[c]:
                    f = row[c]; p = piv[c]
                    row = [(x - f * y) % 11 for x, y in zip(row, p)]
            nz = next((c for c in range(nf) if row[c]), None)
            if nz is None:
                if row[nf]: return False, nf, None
                continue
            inv = pow(row[nz], 9, 11)
            piv[nz] = [(x * inv) % 11 for x in row]
    w = [0] * NR
    for c, r in piv.items(): w[free[c]] = r[nf]
    return True, nf, w

def E_closed(rep):
    """Theorem X §8.22(b) closed form: E(O)_S = 5^t * dG9_j(pi) for S = pi[:j]+t."""
    E = [0] * NR
    for j in range(1, 5):
        dG = (G9[rep[j - 1]] - G9[rep[j]]) % 11
        T = frozenset(rep[:j])
        for t in range(5):
            S = frozenset((x + t) % 5 for x in T)
            E[IDX[S]] = (E[IDX[S]] + pow(5, t, 11) * dG) % 11
    return E

def level1_gate(nullbasis, B):
    """with the pattern's bordered rays set to 0, is v == 0 mod 11 forced?"""
    idx = [IDX[S] for S in B]
    if not idx: return not nullbasis
    E = Ech(len(idx)); d = 0
    for x in nullbasis:
        if E.add([x[i] for i in idx]): d += 1
    return d == len(nullbasis)

# ---------------- self-tests ------------------------------------------------
def self_tests():
    ok = True
    (L, RAY, RG, info), err = build_fan(G9)
    rng = random.Random(3)
    # chamber(sigma^k n) == chamber(n) - k
    for _ in range(300):
        n = [rng.randint(-20, 20) for _ in range(5)]; n[4] -= sum(n); n = tuple(n)
        o0, v0 = chamber(L, n)
        if len(set(v0)) < 5: continue
        for k in range(5):
            m = n
            for _ in range(k): m = sigN(m)
            if chamber(L, m)[0] != rot(o0, (-k) % 5): ok = False
    print("  chamber(sigma^k n) == chamber(n) - k :", ok)
    # border rule vs f55_sweep2 brute force
    bok = all(set(ALLS) - border_of(rank_pattern(frozenset(P))) == free_rays_brute(frozenset(P))
              for P in [(3, 4), (0, 1), (1, 2, 3), (0, 1, 2, 3), (0, 4), (0, 1, 2, 3, 4)])
    print("  border rule == f55_sweep2.free_rays_brute :", bok); ok &= bok
    # level-2 augmented row scales by 5 under n -> sigma n
    sok = True
    for _ in range(60):
        n = sample_in_chamber(L, RAY, rot(REPS[7], rng.randrange(5)), rng, 22)
        q, rhs, e, s, ex, Lc = sample_data(L, RG, n, REPS[7])
        m = sigN(n)
        q2, rhs2, e2, s2, ex2, Lc2 = sample_data(L, RG, m, REPS[7])
        if e != 1 or e2 != 1: continue
        for t in range(5):
            for S in set(q[t]) | set(q2[t]):
                if (5 * q[t].get(S, 0)) % 11 != q2[t].get(S, 0): sok = False
        if (5 * rhs) % 11 != rhs2: sok = False
    print("  per-translate rows and rhs scale by 5 under n -> sigma n :", sok); ok &= sok
    return ok

# ---------------- per-ell driver -------------------------------------------
def analyse(ell, tag, nrand=2000, nprot=3000, min_samp=250, stale_need=200,
            verbose_patterns=True, seed=20260808):
    t0 = time.time()
    A = active(ell)
    print("\n" + "=" * 78)
    print("ELL = %s   %s   A(ell) = %s  |A| = %d   comps = %s"
          % (ell, tag, list(A), len(A), comps(ell)))
    res, err = build_fan(ell)
    if res is None:
        print("  SKIPPED: %s" % err); return None
    L, RAY, RG, info = res
    print("  30 rays built; RAYGAP values %s; v11(RAYGAP) set %s; "
          "all ray ell-values ==0 mod 11: %s; c9pair(ray) mod 11 values %s"
          % (info['RAYGAP'], info['v11set'], info['raydeg'], info['targets']))
    nrows, rc, ra, nullb = level1(ell, L, RAY, RG, seed=seed)
    UF = U_family(RAY)
    same = (UF.dim() == len(nullb)) and all(UF.contains(b) for b in nullb)
    print("  LEVEL 1 (no pattern): %d sampled rows, coeff-rank %d/%d, aug-rank %d"
          % (nrows, rc, NR, ra))
    print("     -> v==0 mod 11 forced without a pattern: %s ; residual dim %d "
          "(= 4-|A| = %d) ; residual == U-family {v_S=<U,r_S>}: %s"
          % (rc == NR, len(nullb), 4 - len(A), same))
    bases, store, ndeg, ndegbad, nchk = collect(ell, L, RAY, RG, seed=seed + 1,
                                                min_samp=min_samp, stale_need=stale_need)
    ns = min(len(store[r]) for r in REPS), max(len(store[r]) for r in REPS)
    d0 = sorted(set(bases[r][frozenset()].dim() for r in REPS))
    dall = sorted(set(bases[r][Z].dim() for r in REPS for Z in ADMZ))
    print("  LEVEL 2 collection: samples/orbit %d..%d (%d accepted, %d degenerate "
          "[v11(lcm)=0], %d of those with rhs != 0)" % (ns[0], ns[1], nchk, ndeg, ndegbad))
    print("     per-orbit augmented row-space dim, Z=empty: %s  (bound |A| = %d) ; "
          "over the 26 admissible Z: %s" % (d0, len(A), dall))
    print("     collection PROVABLY exhaustive for every Z: %s  (dim(Z=empty) = |A| on "
          "every orbit => the sampled base points span the whole |A|-dim parameter\n"
          "     space that the rows and the rhs factor through, so no Z's row space "
          "can be under-sampled)" % (d0 == [len(A)]))
    feas = []

    def run(pattern, name):
        gate = level1_gate(nullb, border_of(pattern))
        ok, nf, w = feasible(bases, pattern)
        if ok: feas.append((name, pattern, nf, w, gate))
        return ok, nf, gate

    # (A) 26 rank patterns
    nfe = 0; prof = []
    for sz in range(2, 6):
        for P in combinations(range(5), sz):
            ok, nf, gate = run(rank_pattern(frozenset(P)), "rank P=%s" % list(P))
            prof.append(nf); nfe += ok
            if verbose_patterns:
                print("     rank P=%-12s free rays %2d  level-1 gate(v==0 forced) %s  -> %s"
                      % (list(P), nf, gate, "FEASIBLE(!!)" if ok else "infeasible"))
    print("  (A) 26 rank patterns: feasible %d ; free-ray profile %s ; "
          "%d with no free rays" % (nfe, sorted(set(prof)), prof.count(0)))
    # (B) 26 uniform patterns
    nfe = 0; prof = []
    for Z in ADMZ:
        ok, nf, gate = run({rep: Z for rep in REPS}, "uniform Z=%s" % sorted(Z))
        prof.append(nf); nfe += ok
        if verbose_patterns:
            print("     uniform Z=%-12s free rays %2d  level-1 gate %s  -> %s"
                  % (sorted(Z), nf, gate, "FEASIBLE(!!)" if ok else "infeasible"))
    print("  (B) 26 uniform patterns: feasible %d ; free-ray profile %s"
          % (nfe, sorted(set(prof))))
    # (C) random per-orbit patterns, |Z|=2 biased
    rng = random.Random(seed + 2); nfe = 0; prof = {}
    for _ in range(nrand):
        pat = {}
        for rep in REPS:
            k = 2 if rng.random() < 0.85 else rng.randint(3, 5)
            pat[rep] = frozenset(rng.sample(range(5), k))
        ok, nf, gate = run(pat, "random#%d" % _)
        prof[nf] = prof.get(nf, 0) + 1; nfe += ok
    print("  (C) %d random per-orbit patterns (|Z|=2 biased): feasible %d ; "
          "free-ray histogram %s" % (nrand, nfe, sorted(prof.items())))
    # (D) protected-ray patterns: force free rays to exist (the dangerous ones)
    rng = random.Random(seed + 3); nfe = 0; built = 0; prof = {}
    allowed_cache = {}
    for _ in range(nprot):
        m = rng.randint(1, 12)
        R = set(rng.sample(ALLS, m))
        pat = {}
        for rep in REPS:
            al = [t for t in range(5)
                  if not any(frozenset(rot(rep, (-t) % 5)[:j]) in R for j in range(1, 5))]
            if len(al) < 2: pat = None; break
            pat[rep] = frozenset(rng.sample(al, 2 if rng.random() < 0.8 else
                                            rng.randint(2, len(al))))
        if pat is None: continue
        built += 1
        ok, nf, gate = run(pat, "protected#%d" % _)
        prof[nf] = prof.get(nf, 0) + 1; nfe += ok
    print("  (D) %d protected-ray attempts -> %d admissible patterns: feasible %d ; "
          "free-ray histogram %s" % (nprot, built, nfe, sorted(prof.items())))
    # (E) controls: the pipeline must still be able to say FEASIBLE
    ok0, nf0, _ = feasible(bases, {rep: frozenset() for rep in REPS})
    c1 = []
    for z in range(5):
        o, n1, _ = feasible(bases, {rep: frozenset({z}) for rep in REPS})
        c1.append((z, n1, o))
    print("  (E) controls (NOT admissible patterns): Z=empty free rays %d -> %s ; "
          "uniform |Z|=1 -> %s" % (nf0, "FEASIBLE" if ok0 else "infeasible",
          ["Z={%d}: nf %d %s" % (z, n1, "FEASIBLE" if o else "infeasible")
           for z, n1, o in c1]))
    print("  total patterns tested: %d ; FEASIBLE: %d   [%.1fs]"
          % (26 + 26 + nrand + built, len(feas), time.time() - t0))
    if feas:
        print("\n" + "!" * 78)
        print("!!!! LEVEL-2 SHADOW FEASIBLE -- ell = %s, A = %s" % (ell, list(A)))
        for name, pat, nf, w, gate in feas[:5]:
            print("!!!! pattern %s : free rays %d, level-1 gate %s" % (name, nf, gate))
            print("!!!!   Z per orbit: %s" % {r: sorted(pat[r]) for r in REPS})
            print("!!!!   solution w  : %s" % {tuple(sorted(S)): w[IDX[S]]
                                               for S in ALLS if w[IDX[S]]})
        print("!" * 78)
        # confirmation rerun with 4x the sampling
        print("  CONFIRMATION: recollecting with 4x rows ...")
        b2, s2, dg2, dgb2, nc2 = collect(ell, L, RAY, RG, seed=seed + 99,
                                         min_samp=4 * min_samp, stale_need=4 * stale_need)
        d2 = sorted(set(b2[r][frozenset()].dim() for r in REPS))
        print("  4x collection: %d accepted, per-orbit dims %s" % (nc2, d2))
        for name, pat, nf, w, gate in feas:
            ok2, nf2, w2 = feasible(b2, pat)
            print("  4x recheck %s: %s" % (name, "STILL FEASIBLE" if ok2 else
                                           "infeasible (row space had not saturated)"))
            if ok2:
                print("  !!!! CONFIRMED FEASIBLE: ell=%s pattern=%s w=%s"
                      % (ell, {r: sorted(pat[r]) for r in REPS},
                         {tuple(sorted(S)): w2[IDX[S]] for S in ALLS if w2[IDX[S]]}))
    return len(feas)

# ================================= run ======================================
if __name__ == '__main__':
    T0 = time.time()
    print("== f55_midfan.py: regime (iv) of Theorem X''' (FIX_IX_v14 §8.24) at level 2 ==")
    print("\n[0] convention self-tests")
    assert self_tests(), "self-tests failed"

    print("\n[1] regime-(iv) census (deterministic search, |ell_j| <= 4, primitive)")
    from itertools import product
    cens = {}; examples = {}
    for ell in product(range(-4, 5), repeat=5):
        g = 0
        for x in ell: g = gcd(g, x)
        if g != 1: continue
        cp = comps(ell)
        if cp[5] == 0: continue
        nz = [e for e in (3, 9, 4) if cp[e] == 0]
        if len(nz) not in (1, 2): continue
        A = active(ell)
        cens[A] = cens.get(A, 0) + 1
        w = (sum(abs(x) for x in ell), ell)
        if A not in examples or w < examples[A]: examples[A] = w
    print("    regime-(iv) ell in the box, by active set: %s"
          % {str(list(k)): v for k, v in sorted(cens.items())})
    print("    smallest (L1) example per active set: %s"
          % {str(list(k)): v[1] for k, v in sorted(examples.items())})

    print("\n[1b] depth census: how many regime-(iv) fans are DEEPER (v11(RAYGAP) >= 2)?")
    rng = random.Random(20260807); deep = []; shallow = 0; tested = 0
    for _ in range(4000):
        ell = tuple(rng.randint(-9, 9) for _ in range(5))
        g = 0
        for x in ell: g = gcd(g, x)
        if g != 1: continue
        cp = comps(ell)
        if cp[5] == 0: continue
        if len([e for e in (3, 9, 4) if cp[e] == 0]) not in (1, 2): continue
        res, err = build_fan(ell)
        tested += 1
        if res is None: deep.append((ell, active(ell), err))
        else: shallow += 1
    print("    %d regime-(iv) ell tested: %d with v11(RAYGAP)==1 (analysed here), "
          "%d DEEPER -> skipped, need level >= 3" % (tested, shallow, len(deep)))
    for e in deep[:5]: print("      deeper: ell=%s A=%s %s" % (e[0], list(e[1]), e[2]))

    print("\n[2] CALIBRATION GATE: ell = G9 (regime (iii), Theorem X) -- the 26 rank")
    print("    patterns must all be infeasible, with exactly 8 no-free-ray patterns.")
    res, err = build_fan(G9)
    Lg, RAYg, RGg, infog = res
    nrows, rc, ra, nullg = level1(G9, Lg, RAYg, RGg)
    print("    level 1 (no pattern): coeff-rank %d/%d, residual dim %d" % (rc, NR, len(nullg)))
    basesg, storeg, dg, dgb, ncg = collect(G9, Lg, RAYg, RGg)
    # drop-vs-zero equivalence: dropping translate t in Z == keeping it and w=0 on bordered
    P0 = frozenset({3, 4}); pat0 = rank_pattern(P0); B0 = border_of(pat0)
    freeidx = [IDX[S] for S in ALLS if S not in B0]
    eqok = True
    for rep in REPS:
        for q, rhs in storeg[rep][:40]:
            drop = [0] * NR; keep = [0] * NR
            for t in range(5):
                for S, cv in q[t].items():
                    keep[IDX[S]] = (keep[IDX[S]] + cv) % 11
                    if t not in pat0[rep]: drop[IDX[S]] = (drop[IDX[S]] + cv) % 11
            if [drop[i] for i in freeidx] != [keep[i] for i in freeidx]: eqok = False
    print("    drop-translate assembly == keep-all + w=0 on bordered rays: %s" % eqok)
    assert eqok
    # collected rows vs the hand-derived closed form of Theorem X §8.22(b):
    # each orbit's Z=empty augmented space is 1-dimensional and, rescaled to
    # rhs = -4, equals R(pi) = 9*E(pi) exactly.
    mism = 0
    for rep in REPS:
        rows = basesg[rep][frozenset()].rows()
        if len(rows) != 1 or rows[0][NR] == 0: mism += 1; continue
        lam = ((-4) % 11) * pow(rows[0][NR], 9, 11) % 11
        if [(lam * x) % 11 for x in rows[0][:NR]] != [(9 * x) % 11 for x in E_closed(rep)]:
            mism += 1
    print("    sampled rows == 9*E(pi) (Theorem X §8.22(b) closed form, rhs -4) "
          "on all 24 orbits: %s (mismatches %d)" % (mism == 0, mism))
    assert mism == 0
    # NEGATIVE CONTROL (§8.22 sharpness: the "two zeros per orbit" is
    # load-bearing) -- with no pattern, and with only ONE zero per orbit, the
    # very same pipeline must report FEASIBLE.  Otherwise it is vacuous.
    ok0, nf0, _ = feasible(basesg, {r: frozenset() for r in REPS})
    ctrl = []
    for z in range(5):
        ok1, nf1, _ = feasible(basesg, {r: frozenset({z}) for r in REPS})
        ctrl.append(ok1)
        print("     control uniform |Z|=1 Z={%d}: free rays %2d -> %s"
              % (z, nf1, "FEASIBLE (expected)" if ok1 else "infeasible (!!)"))
    print("    control Z=empty (no pattern): free rays %d -> %s"
          % (nf0, "FEASIBLE (expected)" if ok0 else "infeasible (!!)"))
    ctrl_ok = ok0 and all(ctrl)
    nfeas = 0; nofree = []
    for sz in range(2, 6):
        for P in combinations(range(5), sz):
            pat = rank_pattern(frozenset(P))
            ok, nf, w = feasible(basesg, pat)
            gate = level1_gate(nullg, border_of(pat))
            if ok: nfeas += 1
            if nf == 0: nofree.append(list(P))
            print("     P=%-12s free rays %2d  level-1 gate %s -> %s"
                  % (list(P), nf, gate, "FEASIBLE(!!)" if ok else "infeasible"))
    print("    CALIBRATION: feasible %d/26 (must be 0); no-free-ray patterns (%d): %s"
          % (nfeas, len(nofree), nofree))
    gate_ok = (nfeas == 0 and len(nofree) == 8 and ctrl_ok and
               sorted(nofree) == sorted([[0, 4], [0, 1, 4], [0, 2, 4], [0, 3, 4],
                                         [0, 1, 2, 4], [0, 1, 3, 4], [0, 2, 3, 4],
                                         [0, 1, 2, 3, 4]]))
    print("    CALIBRATION GATE: %s" % ("PASS" if gate_ok else "FAIL"))
    if not gate_ok:
        print("    aborting: calibration failed"); sys.exit(1)

    print("\n[3] regime-(iv) runs")
    CASES = [((-2, 0, -1, 0, 0), "one dead comp (a_4 = 0)"),
             ((-2, 0, 0, -1, 0), "one dead comp (a_3 = 0)"),
             ((-2, 0, 0, 0, -1), "one dead comp (a_9 = 0)"),
             ((-3, 0, 1, 1, 0), "two dead comps (a_3 = a_4 = 0)"),
             ((-2, -1, 0, 0, 2), "two dead comps (a_3 = a_9 = 0)"),
             ((-2, 0, 2, -1, 0), "two dead comps (a_9 = a_4 = 0)"),
             ((3, -3, -5, 6, -3), "larger fan, ray gap 3355 (a_3 = a_4 = 0)"),
             ((5, -4, -1, 1, -5), "larger fan, ray gap 3905 (a_3 = 0)")]
    summary = []
    for ell, tag in CASES:
        A = active(ell)
        assert 5 in A and 1 <= len(A) - 1 <= 2 and len(A) < 4, (ell, A)
        r = analyse(ell, tag)
        summary.append((ell, A, r))
    print("\n[4] SUMMARY")
    for ell, A, r in summary:
        print("   ell=%-18s A=%-12s feasible patterns: %s"
              % (str(ell), str(list(A)), "SKIPPED" if r is None else r))
    tot = sum(r for _, _, r in summary if r is not None)
    print("   TOTAL feasible level-2 patterns over all regime-(iv) fans tested: %d" % tot)
    print("   (a 0 here means: for every pattern tested, the level-2 mod-11 shadow is")
    print("    infeasible -- nothing beyond that is claimed)")
    print("\ndone in %.1fs" % (time.time() - T0))
