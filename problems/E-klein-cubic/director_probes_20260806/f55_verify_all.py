#!/usr/bin/env python3
"""f55_verify_all.py -- master verifier for the wave-31 F55 campaign.

Re-runs, from scratch and at FRESH seeds wherever randomness is involved, the
decisive finite verdicts recorded in theory/FIX_IX_v14.md sections 8.22-8.24
(Corrections IX-g/IX-h, Theorems W, X, X', X'', X''', Theorem R) and asserts
the recorded conclusions.  Nothing is shelled out: every routine below is a
self-contained re-implementation of the corresponding probe
(f55_exact1/exact2/eweb/xistar/free_sweep/signfan/signfan_close/a4exact/ellfan).

Items
  1  G9-fan geometry: all 30 ray gaps equal 55; the exact chamber row of the
     level-2 congruence agrees with the sampled d_row pipeline at >= 1000
     fresh interior lattice points for the patterns P = {3,4} and P = {1,2}
     (and the level-1 a-row formula agrees at the same points).
  2  Level-1 exact forcing (Theorem W): rank = #free rays for all 18 surviving
     rank patterns; the other 8 patterns have no free rays.
  3  Exact 24-row level-2 systems: all 18 surviving patterns infeasible;
     minimal Farkas certificate size 3 for {3,4} and {0,1}, 2 for the other 16;
     the recorded hand certificate 4*R(0,1,4,2,3)+5*R(0,1,4,3,2)+1*R(0,4,3,1,2)
     is valid for P = {3,4}.
  4  E-web: rank(E) = 6 on the 24x30 matrix; every relation (left-kernel
     element) has coefficient-sum 0; A.xi = 2*(1..1) has the unique solution
     xi* = (7,4,2,10,3,9); E(O).w = A.xi at fresh random w.
  5  Covering theorem: 0 of 15625 transversals survive at >= 2 zeros per orbit,
     15625 of 15625 at >= 1 (sharpness of the twice-min), and the six
     drop-one-class counts are (3125, 350, 350, 350, 350, 3125).
  6  A4-fan (Theorem X''): the six class targets -<ray(T_c), c9> are
     (2,1,8,7,9,4); 5000 fresh random per-orbit patterns and all 26 uniform
     patterns are infeasible by the class criterion.
  7  Sign-fan (Theorem X'): Theta list, 30 cells / 6 orbits / 70 walls,
     jump+orbit-sum solution space of dimension 7, the per-orbit pair table
     (10/10 inconsistent on the two corank-1 orbits, 5/10 on the middle four,
     every single cell consistent), and a DFS over all 10^6 minimal patterns
     finding none feasible.
  8  ell-fans (Theorem X'''): analyze(G9) -> xi* = (8,3,7,2,5,4) at a fresh
     witness seed, equal to 9*(7,4,2,10,3,9) mod 11; analyze((2,1,-4,4,0)) ->
     (1,10,5,3,2,6); the block-Fourier lemma (24 coefficients, all nonzero);
     200 fresh fully-active generic ell all have six nonzero class targets.
  9  Theorem R (the h-free congruence) by direct computation on 500 fresh
     random (h-values, n): sum_k 9^k F(sig^k n) == -<n, c9> (mod 11) for
     F = 2h + h.sig^{-1} - e_2^*.

All randomness is derived from one fixed base seed (override with the
environment variable F55_BASE_SEED), so reruns are bit-for-bit reproducible.
Exit 0 with "ALL PASS (n items)"; exit 1 with the list of failures.
"""
import os
import sys
import time
from fractions import Fraction as Fr
from itertools import combinations, permutations, product
from math import gcd
import random

# ----------------------------------------------------------------- harness --
BASE_SEED = int(os.environ.get("F55_BASE_SEED", "31415926535"))
def seed_for(k):
    """fresh, fixed-base, per-item seed"""
    return (BASE_SEED + 1000003 * k) % (2 ** 61 - 1)

FAILURES = []
_sub = []

def sub(ok, msg):
    _sub.append((bool(ok), msg))
    print(("    ok   " if ok else "    FAIL ") + msg)
    return bool(ok)

def item(n, title, fn):
    global _sub
    _sub = []
    print(f"\n[{n}] {title}")
    t0 = time.time()
    try:
        fn()
        ok = all(o for o, _ in _sub) and len(_sub) > 0
    except Exception as e:  # noqa: BLE001
        import traceback
        traceback.print_exc()
        sub(False, f"exception: {e!r}")
        ok = False
    if not ok:
        for o, m in _sub:
            if not o:
                FAILURES.append(f"item {n} ({title}): {m}")
        if not _sub:
            FAILURES.append(f"item {n} ({title}): no checks ran")
    print(f"  ITEM {n}: {'PASS' if ok else 'FAIL'}   [{time.time() - t0:.1f}s]")

# ------------------------------------------------------- shared arithmetic --
G9 = (1, 5, 3, 4, 9)
c9 = (4, 9, 1, 5, 3)
inv5 = 9                     # 5*9 = 45 == 1 (mod 11)

def sigN(n):
    """(sigma n)_j = n_{j-1}"""
    return tuple(n[(j - 1) % 5] for j in range(5))

def H(k, n):
    m = n
    for _ in range(k):
        m = sigN(m)
    return sum(m[j] * G9[j] for j in range(5))

def c9pair(n):
    return sum(n[j] * c9[j] for j in range(5))

ALLS = [frozenset(S) for k in (1, 2, 3, 4) for S in combinations(range(5), k)]
AIDX = {S: i for i, S in enumerate(ALLS)}
ALLP = [frozenset(P) for sz in range(2, 6) for P in combinations(range(5), sz)]
NOFREE = [frozenset(x) for x in
          [(0, 4), (0, 1, 4), (0, 2, 4), (0, 3, 4), (0, 1, 2, 4),
           (0, 1, 3, 4), (0, 2, 3, 4), (0, 1, 2, 3, 4)]]

def orbit_reps():
    reps, seen = [], set()
    for pi in permutations(range(5)):
        if pi in seen:
            continue
        orb, q = [], pi
        for _ in range(5):
            orb.append(q)
            q = tuple((p + 1) % 5 for p in q)
        seen.update(orb)
        reps.append(pi)
    return reps

REPS = orbit_reps()
assert len(REPS) == 24

def orbit(pi):
    out, q = [], pi
    for _ in range(5):
        out.append(q)
        q = tuple((p + 1) % 5 for p in q)
    return out

def rankF11(mat, ncols=None):
    A = [r[:] for r in mat]
    if not A:
        return 0
    m = len(A)
    n = ncols if ncols is not None else len(A[0])
    r0 = 0
    for col in range(n):
        pr = next((i for i in range(r0, m) if A[i][col] % 11), None)
        if pr is None:
            continue
        A[r0], A[pr] = A[pr], A[r0]
        iv = pow(A[r0][col], 9, 11)
        A[r0] = [(x * iv) % 11 for x in A[r0]]
        for i in range(m):
            if i != r0 and A[i][col] % 11:
                f = A[i][col]
                A[i] = [(x - f * y) % 11 for x, y in zip(A[i], A[r0])]
        r0 += 1
    return r0

def free_rays(P):
    out = []
    for S in ALLS:
        if 0 in S:
            bordered = any(p < len(S) for p in P)
        else:
            bordered = any(p >= len(S) for p in P)
        if not bordered:
            out.append(S)
    return out

def cyc_shift_match(T, S):
    for k in range(5):
        if frozenset((t - k) % 5 for t in T) == S:
            return k
    return None

def rank_pattern_H(n):
    vals = sorted([(H(k, n), k) for k in range(5)], reverse=True)
    return [k for _, k in vals], [v for v, _ in vals]

# ================================================================= item 1 ===
def solve_ray_G9(S):
    """primitive ray generator of the G9-fan with top-block S"""
    Sl, Cl = sorted(S), sorted(set(range(5)) - S)
    def Hrow(k):
        row = []
        for i in range(5):
            e = [0] * 5
            e[i] = 1
            row.append(H(k, tuple(e)))
        return row
    A = [[Fr(1)] * 5]
    b = [Fr(0)]
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
    v = [M[r][5] for r in range(5)]
    L = 1
    for x in v:
        L = L * x.denominator // gcd(L, x.denominator)
    ni = [int(x * L) for x in v]
    g = 0
    for x in ni:
        g = gcd(g, x)
    ni = [x // g for x in ni]
    if H(next(iter(S)), tuple(ni)) < H(next(iter(set(range(5)) - S)), tuple(ni)):
        ni = [-x for x in ni]
    return tuple(ni)

RAY = {S: solve_ray_G9(set(S)) for S in ALLS}
RAYGAP = {S: H(next(iter(S)), RAY[S]) - H(next(iter(set(range(5)) - set(S))), RAY[S])
          for S in ALLS}

def chamber_row(pi, P, FREE):
    """exact level-2 congruence row (V0-normalized) over the free rays; rhs -4"""
    Z = {k for k in range(5) if pi.index(k) in P}
    row = {}
    for j in range(1, 5):
        T = frozenset(pi[:j])
        dG = G9[pi[j - 1]] - G9[pi[j]]
        for S in FREE:
            if len(S) != j:
                continue
            k = cyc_shift_match(T, S)
            if k is None or k in Z:
                continue
            row[S] = (row.get(S, 0) + pow(9, k, 11) * dG * inv5) % 11
    return row

def chamber_row_a(pi, P, FREE):
    """exact level-1 integrality row at chamber pi"""
    if pi.index(0) in P:
        return {}
    row = {}
    for j in range(1, 5):
        S = frozenset(pi[:j])
        if S not in FREE:
            continue
        dG = (G9[pi[j - 1]] - G9[pi[j]]) % 11
        if dG:
            row[S] = (row.get(S, 0) + dG) % 11
    return row

def chamber_row_b(pi, P, FREE):
    return chamber_row(pi, P, FREE)      # same rows, homogeneous at level 1

def d_row(n, idx):
    order, vals = rank_pattern_H(n)
    row = {}
    for k in range(1, 5):
        S = frozenset(order[:k])
        gap = vals[k - 1] - vals[k]
        if gap == 0 or S not in idx:
            continue
        row[S] = row.get(S, Fr(0)) + Fr(gap, RAYGAP[S])
    return row

def sampled_level2_row(n, P, idx):
    """sampled (unnormalized) level-2 congruence row at n, or None"""
    row = {}
    for k in range(5):
        m = n
        for _ in range(k):
            m = sigN(m)
        pi = tuple(rank_pattern_H(m)[0])
        if pi.index(0) in P:      # zero chamber: d = 0 there
            continue
        for S, cf in d_row(m, idx).items():
            row[S] = row.get(S, Fr(0)) + (9 ** k) * cf
    L = 1
    for cf in row.values():
        L = L * cf.denominator // gcd(L, cf.denominator)
    v11, LL = 0, L
    while LL % 11 == 0:
        LL //= 11
        v11 += 1
    if v11 != 1:
        return None
    uinv = pow(LL % 11, 9, 11)
    return ({S: (int(cf * L) * uinv) % 11 for S, cf in row.items()},
            (-c9pair(n)) % 11)

def item1():
    gaps = sorted(set(RAYGAP.values()))
    sub(len(RAY) == 30 and gaps == [55], f"all 30 G9-fan ray gaps equal 55 (values {gaps})")
    sub(all(g % 11 == 0 and (g // 11) % 11 != 0 for g in gaps),
        "v11(ray gap) = 1 exactly (the level-2 normalization is clean)")
    for k, Pt in enumerate([(3, 4), (1, 2)]):
        P = frozenset(Pt)
        FREE = free_rays(P)
        idx = {S: i for i, S in enumerate(FREE)}
        rng = random.Random(seed_for(10 + k))
        checked = checked_a = 0
        bad = bad_a = 0
        while checked < 1200 or checked_a < 1200:
            n = [rng.randint(-9, 9) for _ in range(5)]
            n[4] -= sum(n)
            n = tuple(n)
            order, vals = rank_pattern_H(n)
            if len(set(vals)) < 5:
                continue                       # chamber interior only
            pi = tuple(order)
            V0 = H(0, n) % 11
            got = sampled_level2_row(n, P, idx)
            if got is not None:
                grow, grhs = got
                pred = chamber_row(pi, P, FREE)
                ok = all(grow.get(S, 0) % 11 == (V0 * pred.get(S, 0)) % 11 for S in FREE)
                ok = ok and grhs % 11 == (-4 * V0) % 11
                checked += 1
                if not ok:
                    bad += 1
                    if bad == 1:
                        print("      MISMATCH(level2)", n, pi, V0, grow, grhs)
            # level-1 a-row (integrality shadow) at the same point
            if pi.index(0) not in P:
                srow = {}
                for j in range(1, 5):
                    S = frozenset(order[:j])
                    if S not in FREE:
                        continue
                    g = (vals[j - 1] - vals[j]) % 11
                    if g:
                        srow[S] = (srow.get(S, 0) + g) % 11
                preda = chamber_row_a(pi, P, FREE)
                checked_a += 1
                if not all(srow.get(S, 0) % 11 == (V0 * preda.get(S, 0)) % 11 for S in FREE):
                    bad_a += 1
                    if bad_a == 1:
                        print("      MISMATCH(level1 a-row)", n, pi, V0, srow, preda)
        sub(bad == 0 and checked >= 1000,
            f"P={sorted(P)}: level-2 chamber formula == sampled pipeline at "
            f"{checked} fresh interior lattice points ({bad} mismatches)")
        sub(bad_a == 0 and checked_a >= 1000,
            f"P={sorted(P)}: level-1 a-row formula == sampled rows at "
            f"{checked_a} points ({bad_a} mismatches)")
    inv_ok = True
    for Pt in [(3, 4), (0, 1), (1, 3)]:
        P = frozenset(Pt)
        FREE = free_rays(P)
        for pi in permutations(range(5)):
            if chamber_row(pi, P, FREE) != chamber_row(
                    tuple((p + 1) % 5 for p in pi), P, FREE):
                inv_ok = False
    sub(inv_ok, "chamber rows are sigma-invariant (120 chambers -> 24 orbit rows)")

# ================================================================= item 2 ===
def item2():
    nofree, forced, table = [], [], []
    for P in ALLP:
        FREE = free_rays(P)
        nf = len(FREE)
        if nf == 0:
            nofree.append(P)
            continue
        idx = {S: i for i, S in enumerate(FREE)}
        rows = []
        for pi in permutations(range(5)):
            for r in (chamber_row_a(pi, P, FREE), chamber_row_b(pi, P, FREE)):
                if r:
                    vec = [0] * nf
                    for S, cf in r.items():
                        vec[idx[S]] = cf % 11
                    rows.append(vec)
        rk = rankF11(rows, nf)
        table.append((sorted(P), nf, len(rows), rk))
        forced.append(rk == nf)
    sub(len(nofree) == 8 and set(nofree) == set(NOFREE),
        f"exactly 8 rank patterns have no free rays "
        f"(match the IX-g list: {set(nofree) == set(NOFREE)})")
    sub(len(forced) == 18, f"18 surviving rank patterns (got {len(forced)})")
    sub(all(forced), "level-1 exact system has rank = #free rays for all 18 "
                     "(=> v == 0 mod 11 forced; Theorem W)")
    print("      " + "; ".join(f"{P}:nf{nf}/rows{nr}/rk{rk}" for P, nf, nr, rk in table))

# ================================================================= item 3 ===
def exact_system(P):
    FREE = free_rays(P)
    idx = {S: i for i, S in enumerate(FREE)}
    rows = []
    for pi in REPS:
        r = chamber_row(pi, P, FREE)
        vec = [0] * len(FREE)
        for S, c in r.items():
            vec[idx[S]] = c % 11
        rows.append((pi, vec, (-4) % 11))
    return FREE, rows

def infeasible(rows, nf):
    ra = rankF11([v for _, v, _ in rows], nf)
    rb = rankF11([v + [r] for _, v, r in rows], nf + 1)
    return rb != ra, ra, rb

def min_cert_size(rows, nf, maxsize=4):
    for size in range(1, maxsize + 1):
        for T in combinations(range(len(rows)), size):
            sub_rows = [rows[i] for i in T]
            if infeasible(sub_rows, nf)[0]:
                return size, T
    return None, None

def item3():
    verdicts, sizes = [], {}
    for P in ALLP:
        FREE, rows = exact_system(P)
        nf = len(FREE)
        if nf == 0:
            continue
        inf, ra, rb = infeasible(rows, nf)
        verdicts.append((sorted(P), nf, ra, rb, inf))
        want = 3 if P in (frozenset({3, 4}), frozenset({0, 1})) else 2
        sz, _ = min_cert_size(rows, nf, maxsize=want + 1)
        sizes[tuple(sorted(P))] = (sz, want)
    sub(len(verdicts) == 18 and all(v[4] for v in verdicts),
        f"all 18 surviving rank patterns infeasible on the exact 24-row level-2 "
        f"system ({sum(1 for v in verdicts if v[4])}/18)")
    bad = {k: v for k, v in sizes.items() if v[0] != v[1]}
    sub(not bad, f"minimal certificate sizes as recorded: 3 for (3,4) and (0,1), "
                 f"2 for the other 16 (deviations: {bad})")
    # the recorded hand certificate for P = {3,4}
    P0 = frozenset({3, 4})
    FREE, rows = exact_system(P0)
    want = {(0, 1, 4, 2, 3): 4, (0, 1, 4, 3, 2): 5, (0, 4, 3, 1, 2): 1}
    byrep = {pi: (vec, rhs) for pi, vec, rhs in rows}
    have = all(pi in byrep for pi in want)
    if have:
        acc = [0] * len(FREE)
        rhs = 0
        for pi, y in want.items():
            v, r = byrep[pi]
            acc = [(a + y * b) % 11 for a, b in zip(acc, v)]
            rhs = (rhs + y * r) % 11
        sub(all(a % 11 == 0 for a in acc) and rhs % 11 != 0,
            f"hand certificate 4*R(0,1,4,2,3)+5*R(0,1,4,3,2)+1*R(0,4,3,1,2): "
            f"coefficients {acc} vanish, rhs-sum {rhs} != 0")
    else:
        sub(False, "hand-certificate chambers not among the 24 orbit reps")
    print("      " + "; ".join(f"{P}:nf{nf} rk{ra}/{rb}" for P, nf, ra, rb, _ in verdicts))

# ================================================================= item 4 ===
def D(q):
    vec = [0] * 30
    for j in range(1, 5):
        S = frozenset(q[:j])
        vec[AIDX[S]] = (vec[AIDX[S]] + G9[q[j - 1]] - G9[q[j]]) % 11
    return vec

EMAT = {}
for _pi in REPS:
    _v = [0] * 30
    for _q in orbit(_pi):
        _v = [(a + b) % 11 for a, b in zip(_v, D(_q))]
    EMAT[_pi] = _v

CLASSREP = [frozenset({0}), frozenset({0, 1}), frozenset({0, 2}),
            frozenset({0, 1, 2}), frozenset({0, 1, 3}), frozenset({0, 1, 2, 3})]
CNAME = ["c1", "c2a", "c2b", "c3a", "c3b", "c4"]

def class_of(S):
    for i, T in enumerate(CLASSREP):
        if len(T) != len(S):
            continue
        for t in range(5):
            if frozenset((x + t) % 5 for x in T) == S:
                return i, t
    raise RuntimeError(S)

def item4():
    mat = [EMAT[pi][:] for pi in REPS]
    m, n = 24, 30
    A = [mat[i][:] + [1 if j == i else 0 for j in range(m)] for i in range(m)]
    r0 = 0
    for col in range(n):
        pr = next((i for i in range(r0, m) if A[i][col] % 11), None)
        if pr is None:
            continue
        A[r0], A[pr] = A[pr], A[r0]
        iv = pow(A[r0][col], 9, 11)
        A[r0] = [(x * iv) % 11 for x in A[r0]]
        for i in range(m):
            if i != r0 and A[i][col] % 11:
                f = A[i][col]
                A[i] = [(x - f * y) % 11 for x, y in zip(A[i], A[r0])]
        r0 += 1
    sub(r0 == 6, f"rank(E) = {r0} on the 24x30 matrix (expect 6); "
                 f"relation space dim {24 - r0} (expect 18)")
    rels = [A[i][n:] for i in range(r0, m)]
    good = all(all(sum(y[j] * mat[j][c] for j in range(m)) % 11 == 0 for c in range(n))
               for y in rels)
    sums = [sum(y) % 11 for y in rels]
    sub(good and len(rels) == 18 and not any(sums),
        f"all {len(rels)} basis relations are genuine and every unrestricted "
        f"relation has coefficient-sum 0 (sums {set(sums)})")
    # E-form vs the verified chamber rows
    eform = True
    for Pt in [(3, 4), (0, 2), (1, 2)]:
        P = frozenset(Pt)
        FREE = free_rays(P)
        for pi in REPS:
            r1 = chamber_row(pi, P, FREE)
            for S in FREE:
                if (9 * EMAT[pi][AIDX[S]]) % 11 != r1.get(S, 0) % 11:
                    eform = False
    sub(eform, "9*E(O) restricted to the free rays == the exact chamber rows")
    # A (24 x 6) and the factorization at fresh random w
    Amat = []
    for pi in REPS:
        row = [0] * 6
        for j in range(1, 5):
            c, t = class_of(frozenset(pi[:j]))
            dG = (G9[pi[j - 1]] - G9[pi[j]]) % 11
            row[c] = (row[c] + dG * pow(9, t, 11)) % 11
        Amat.append(row)
    rng = random.Random(seed_for(40))
    fac_ok = True
    for _ in range(200):
        w = [rng.randrange(11) for _ in range(30)]
        xi = [0] * 6
        for S in ALLS:
            c, t = class_of(S)
            xi[c] = (xi[c] + pow(5, t, 11) * w[AIDX[S]]) % 11
        for pi, row in zip(REPS, Amat):
            val = sum(EMAT[pi][i] * w[i] for i in range(30)) % 11
            if val != sum(row[c] * xi[c] for c in range(6)) % 11:
                fac_ok = False
    sub(fac_ok, "E(O).w = A.xi verified on 200 fresh random w")
    M = [row[:] + [2] for row in Amat]
    r0 = 0
    piv = []
    for col in range(6):
        pr = next((i for i in range(r0, 24) if M[i][col] % 11), None)
        if pr is None:
            continue
        M[r0], M[pr] = M[pr], M[r0]
        iv = pow(M[r0][col], 9, 11)
        M[r0] = [(x * iv) % 11 for x in M[r0]]
        for i in range(24):
            if i != r0 and M[i][col] % 11:
                f = M[i][col]
                M[i] = [(x - f * y) % 11 for x, y in zip(M[i], M[r0])]
        piv.append(col)
        r0 += 1
    cons = all(M[i][6] % 11 == 0 for i in range(r0, 24))
    xistar = [0] * 6
    for i, c in enumerate(piv):
        xistar[c] = M[i][6]
    ok = (r0 == 6 and cons and xistar == [7, 4, 2, 10, 3, 9]
          and all(sum(Amat[i][c] * xistar[c] for c in range(6)) % 11 == 2
                  for i in range(24)))
    sub(ok, f"rank(A) = {r0}, consistent {cons}, unique xi* = {xistar} "
            f"(expect (7,4,2,10,3,9)) on {CNAME}; nowhere zero {all(xistar)}")

# ================================================================= item 5 ===
PREFMASK = {}
for _q in permutations(range(5)):
    _m = 0
    for _j in range(1, 5):
        _m |= 1 << AIDX[frozenset(_q[:_j])]
    PREFMASK[_q] = _m
ORBMASKS = [[PREFMASK[q] for q in orbit(pi)] for pi in REPS]
CLASSBITS = [[1 << AIDX[frozenset((x + t) % 5 for x in T)] for t in range(5)]
             for T in CLASSREP]

def covering_count(classes, thr):
    cnt = 0
    tabs = [CLASSBITS[c] for c in classes]
    for choice in product(range(5), repeat=len(classes)):
        tmask = 0
        for tab, t in zip(tabs, choice):
            tmask |= tab[t]
        for masks in ORBMASKS:
            if sum(1 for m in masks if not (tmask & m)) < thr:
                break
        else:
            cnt += 1
    return cnt

def item5():
    c2 = covering_count(list(range(6)), 2)
    sub(c2 == 0, f"transversals surviving with >= 2 zeros per orbit: {c2} of 15625 (expect 0)")
    c1 = covering_count(list(range(6)), 1)
    sub(c1 == 15625, f"transversals surviving with >= 1 zero per orbit: {c1} of 15625 "
                     f"(expect 15625 -- the twice-min is exactly load-bearing)")
    drop = [covering_count([c for c in range(6) if c != d], 2) for d in range(6)]
    sub(drop == [3125, 350, 350, 350, 350, 3125],
        f"drop-one-class counts (of 5^5 = 3125 each): {drop} "
        f"(expect (3125,350,350,350,350,3125) -- all six classes load-bearing)")

# ================================================================= item 6 ===
def ray_A4(S):
    return tuple(5 * (i in S) - len(S) for i in range(5))

def item6():
    targ = [(-sum(ray_A4(T)[i] * c9[i] for i in range(5))) % 11 for T in CLASSREP]
    sub(targ == [2, 1, 8, 7, 9, 4],
        f"A4 class targets -<ray(T_c), c9> = {targ} (expect (2,1,8,7,9,4)); "
        f"all nonzero {all(targ)}")
    def zero_chambers(pattern):
        zc = set()
        for pi in REPS:
            for t in pattern[pi]:
                zc.add(tuple((p + t) % 5 for p in pi))
        return zc
    def bordered(zc):
        B = set()
        for q in zc:
            for j in range(1, 5):
                B.add(frozenset(q[:j]))
        return B
    def feasible(pattern):
        B = bordered(zero_chambers(pattern))
        for T in CLASSREP:
            if all(frozenset((x + t) % 5 for x in T) in B for t in range(5)):
                return False
        return True
    rng = random.Random(seed_for(60))
    s2 = [frozenset(c) for c in combinations(range(5), 2)]
    sbig = [frozenset(c) for sz in (2, 3) for c in combinations(range(5), sz)]
    feas = 0
    for trial in range(5000):
        pat = {pi: rng.choice(s2 if trial % 2 else sbig) for pi in REPS}
        if feasible(pat):
            feas += 1
    sub(feas == 0, f"5000 fresh random per-orbit patterns: {feas} feasible (expect 0)")
    uni = [Z for Z in [frozenset(c) for sz in (2, 3, 4, 5)
                       for c in combinations(range(5), sz)]
           if feasible({pi: Z for pi in REPS})]
    sub(not uni, f"all 26 uniform patterns infeasible (feasible: {uni})")

# ================================================================= item 7 ===
def item7():
    def nf_diag(v):
        return tuple((v[j] - v[4]) % 11 for j in range(5))
    G9n = nf_diag(G9)
    inv_g0 = pow(G9n[0], 9, 11)
    def nf_Q(v):
        w = nf_diag(v)
        c = (w[0] * inv_g0) % 11
        w = tuple((w[j] - c * G9n[j]) % 11 for j in range(5))
        assert w[0] == 0 and w[4] == 0
        return (w[1], w[2], w[3])
    def sigT(m):
        return tuple(m[(j + 1) % 5] for j in range(5))
    MU, m = [], G9
    for _ in range(5):
        MU.append(m)
        m = sigT(m)
    THETA = []
    for k in range(5):
        diff = tuple(MU[k][j] - pow(5, k) * G9[j] for j in range(5))
        assert all(d % 11 == 0 for d in diff)
        rho = tuple(d // 11 for d in diff)
        i5 = pow(pow(5, k, 11), 9, 11)
        THETA.append(nf_Q(tuple((x * i5) % 11 for x in rho)))
    sub(THETA == [(0, 0, 0), (0, 0, 10), (0, 2, 10), (7, 2, 10), (3, 7, 5)],
        f"Theta_k in Q = {THETA} (expect [(0,0,0),(0,0,10),(0,2,10),(7,2,10),(3,7,5)])")
    CELLS = [s for s in product((1, -1), repeat=5) if len(set(s)) == 2]
    CIDX = {s: i for i, s in enumerate(CELLS)}
    def sig_cell(s):
        return tuple(s[(k + 1) % 5] for k in range(5))
    ORBITS, seen = [], set()
    for s in CELLS:
        if s in seen:
            continue
        orb, q = [], s
        for _ in range(5):
            orb.append(q)
            q = sig_cell(q)
        seen.update(orb)
        ORBITS.append(orb)
    EDGES = []
    for s in CELLS:
        for k in range(5):
            if len(set(s[j] for j in range(5) if j != k)) < 2:
                continue
            s2 = tuple((-s[j] if j == k else s[j]) for j in range(5))
            if CIDX[s] < CIDX[s2]:
                EDGES.append((CIDX[s], CIDX[s2], k))
    sub(len(CELLS) == 30 and len(ORBITS) == 6 and len(EDGES) == 70,
        f"sign-fan: {len(CELLS)} cells, {len(ORBITS)} orbits, {len(EDGES)} walls "
        f"(expect 30 / 6 / 70)")
    NV = 120
    def var_tau(i): return 4 * i
    def var_psi(i, a): return 4 * i + 1 + a
    rows = []
    for a, b, k in EDGES:
        for c in range(3):
            r = [0] * NV
            r[var_psi(a, c)] = 1
            r[var_psi(b, c)] = (r[var_psi(b, c)] - 1) % 11
            r[var_tau(a)] = (r[var_tau(a)] - THETA[k][c]) % 11
            r[var_tau(b)] = (r[var_tau(b)] + THETA[k][c]) % 11
            rows.append((r, 0))
    for orb in ORBITS:
        r = [0] * NV
        for s in orb:
            r[var_tau(CIDX[s])] = (r[var_tau(CIDX[s])] + 1) % 11
        rows.append((r, 7))
    Amat = [list(r) + [rhs % 11] for r, rhs in rows]
    mm, piv, r0 = len(Amat), [], 0
    for col in range(NV):
        pr = next((i for i in range(r0, mm) if Amat[i][col] % 11), None)
        if pr is None:
            continue
        Amat[r0], Amat[pr] = Amat[pr], Amat[r0]
        iv = pow(Amat[r0][col], 9, 11)
        Amat[r0] = [(x * iv) % 11 for x in Amat[r0]]
        for i in range(mm):
            if i != r0 and Amat[i][col] % 11:
                f = Amat[i][col]
                Amat[i] = [(x - f * y) % 11 for x, y in zip(Amat[i], Amat[r0])]
        piv.append(col)
        r0 += 1
    solvable = all(Amat[i][NV] % 11 == 0 for i in range(r0, mm))
    part = [0] * NV
    for i, col in enumerate(piv):
        part[col] = Amat[i][NV]
    basis = []
    for fc in [c for c in range(NV) if c not in piv]:
        v = [0] * NV
        v[fc] = 1
        for i, col in enumerate(piv):
            v[col] = (-Amat[i][fc]) % 11
        basis.append(v)
    nb = len(basis)
    sub(solvable and nb == 7,
        f"jump+orbit-sum system solvable {solvable}; solution space dim {nb} (expect 7)")
    CELLCOND = [[[b[4 * i + c] for b in basis] + [(-part[4 * i + c]) % 11]
                 for c in range(4)] for i in range(30)]
    def rref(rws):
        A = [r[:] for r in rws]
        mm2, r0 = len(A), 0
        for col in range(nb):
            pr = next((i for i in range(r0, mm2) if A[i][col] % 11), None)
            if pr is None:
                continue
            A[r0], A[pr] = A[pr], A[r0]
            iv = pow(A[r0][col], 9, 11)
            A[r0] = [(x * iv) % 11 for x in A[r0]]
            for i in range(mm2):
                if i != r0 and A[i][col] % 11:
                    f = A[i][col]
                    A[i] = [(x - f * y) % 11 for x, y in zip(A[i], A[r0])]
            r0 += 1
        for i in range(r0, mm2):
            if A[i][nb] % 11:
                return None
        return tuple(tuple(A[i]) for i in range(r0))
    table = []
    for orb in ORBITS:
        singles = all(rref(CELLCOND[CIDX[s]]) is not None for s in orb)
        bad = sum(1 for (i, j) in combinations(range(5), 2)
                  if rref(CELLCOND[CIDX[orb[i]]] + CELLCOND[CIDX[orb[j]]]) is None)
        table.append((orb[0], singles, bad))
    for rep, singles, bad in table:
        print(f"      orbit rep {rep}: singles consistent {singles}, "
              f"inconsistent pairs {bad}/10")
    corank1 = [t for t in table if abs(sum(t[0])) == 3]
    mid = [t for t in table if abs(sum(t[0])) != 3]
    sub(all(s for _, s, _ in table), "every single zero cell is consistent "
                                     "(the kill is exactly at the twice-min threshold)")
    sub(len(corank1) == 2 and all(b == 10 for _, _, b in corank1),
        f"the two corank-1 orbits (reps {[t[0] for t in corank1]}) have 10/10 "
        f"inconsistent pairs")
    sub(len(mid) == 4 and all(b == 5 for _, _, b in mid),
        f"the four middle orbits have 5/10 inconsistent pairs "
        f"({[b for _, _, b in mid]})")
    pairs = list(combinations(range(5), 2))
    ORBPAIRCOND = [[CELLCOND[CIDX[orb[i]]] + CELLCOND[CIDX[orb[j]]] for (i, j) in pairs]
                   for orb in ORBITS]
    calls = [0]
    def dfs(level, flat):
        if level == 6:
            return True
        seen2 = set()
        for block in ORBPAIRCOND[level]:
            R = rref(list(flat) + block)
            calls[0] += 1
            if R is None or R in seen2:
                continue
            seen2.add(R)
            if dfs(level + 1, R):
                return True
        return False
    found = dfs(0, [])
    sub(not found, f"DFS over all 10^6 minimal patterns: feasible found = {found} "
                   f"(rref calls {calls[0]}; prunes at the first orbit)")

# ================================================================= item 8 ===
def make_fan(ell):
    def L(k, n):
        m = n
        for _ in range(k):
            m = sigN(m)
        return sum(m[j] * ell[j] for j in range(5))
    def solve_ray(S):
        Sl, Cl = sorted(S), sorted(set(range(5)) - S)
        def Lrow(k):
            row = []
            for i in range(5):
                e = [0] * 5
                e[i] = 1
                row.append(L(k, tuple(e)))
            return row
        A = [[Fr(1)] * 5]
        b = [Fr(0)]
        for a in Sl[1:]:
            A.append([Fr(x - y) for x, y in zip(Lrow(a), Lrow(Sl[0]))]); b.append(Fr(0))
        for a in Cl[1:]:
            A.append([Fr(x - y) for x, y in zip(Lrow(a), Lrow(Cl[0]))]); b.append(Fr(0))
        A.append([Fr(x - y) for x, y in zip(Lrow(Sl[0]), Lrow(Cl[0]))]); b.append(Fr(55))
        M = [row[:] + [b[i]] for i, row in enumerate(A)]
        for col in range(5):
            pr = next((r for r in range(col, len(M)) if M[r][col] != 0), None)
            if pr is None:
                return None
            M[col], M[pr] = M[pr], M[col]
            pv = M[col][col]
            M[col] = [v / pv for v in M[col]]
            for r in range(len(M)):
                if r != col and M[r][col] != 0:
                    f = M[r][col]
                    M[r] = [v - f * w for v, w in zip(M[r], M[col])]
        v = [M[r][5] for r in range(5)]
        Lc = 1
        for x in v:
            Lc = Lc * x.denominator // gcd(Lc, x.denominator)
        ni = [int(x * Lc) for x in v]
        g = 0
        for x in ni:
            g = gcd(g, x)
        if g == 0:
            return None
        ni = [x // g for x in ni]
        if L(next(iter(S)), tuple(ni)) < L(next(iter(set(range(5)) - S)), tuple(ni)):
            ni = [-x for x in ni]
        return tuple(ni)
    return L, solve_ray

def aligned_lambda(ell):
    for lam in range(11):
        t = (ell[0] - lam * G9[0]) % 11
        if all((ell[j] - lam * G9[j] - t) % 11 == 0 for j in range(5)):
            return lam
    return None

def analyze_aligned(ell, seed):
    """xi*(ell) for an aligned ell, from 24 randomly witnessed chamber orbits"""
    L, solve_ray = make_fan(ell)
    RAYl = {}
    for S in ALLS:
        r = solve_ray(set(S))
        if r is None:
            return None, "degenerate ray"
        RAYl[S] = r
    RG = {S: L(next(iter(S)), RAYl[S]) - L(next(iter(set(range(5)) - set(S))), RAYl[S])
          for S in ALLS}
    raydeg = all(all(L(k, RAYl[S]) % 11 == 0 for k in range(5)) for S in ALLS)
    if not raydeg:
        return None, "ray degeneracy fails"
    def rp(n):
        vals = sorted([(L(k, n), k) for k in range(5)], reverse=True)
        return [k for _, k in vals], [v for v, _ in vals]
    rng = random.Random(seed)
    rows, tries = {}, 0
    while len(rows) < 24 and tries < 600000:
        tries += 1
        n = [rng.randint(-15, 15) for _ in range(5)]
        n[4] -= sum(n)
        n = tuple(n)
        order, vals = rp(n)
        if len(set(vals)) < 5:
            continue
        V0 = sum(n[j] * G9[j] for j in range(5)) % 11
        if V0 == 0:
            continue
        rep = min(orbit(tuple(order)))
        if rep in rows:
            continue
        r = {}
        for k in range(5):
            m = n
            for _ in range(k):
                m = sigN(m)
            o2, v2 = rp(m)
            for j in range(1, 5):
                S = frozenset(o2[:j])
                r[S] = r.get(S, Fr(0)) + (9 ** k) * Fr(v2[j - 1] - v2[j], RG[S])
        Lc = 1
        for cf in r.values():
            Lc = Lc * cf.denominator // gcd(Lc, cf.denominator)
        LL, e11 = Lc, 0
        while LL % 11 == 0:
            LL //= 11
            e11 += 1
        if e11 != 1:
            continue
        uin = pow(LL % 11, 9, 11)
        V0in = pow(V0, 9, 11)
        rows[rep] = {S: (int(cf * Lc) * uin * V0in) % 11 for S, cf in r.items()}
    if len(rows) < 24:
        return None, f"only {len(rows)} chamber orbits witnessed in {tries} tries"
    A = []
    for rep, row in sorted(rows.items()):
        cls = [0] * 6
        for S, cf in row.items():
            c, t = class_of(S)
            cls[c] = (cls[c] + cf * pow(9, t, 11)) % 11
        A.append(cls)
    M = [row[:] + [(-4) % 11] for row in A]
    r0, piv = 0, []
    for col in range(6):
        pr = next((i for i in range(r0, len(M)) if M[i][col] % 11), None)
        if pr is None:
            continue
        M[r0], M[pr] = M[pr], M[r0]
        iv = pow(M[r0][col], 9, 11)
        M[r0] = [(x * iv) % 11 for x in M[r0]]
        for i in range(len(M)):
            if i != r0 and M[i][col] % 11:
                f = M[i][col]
                M[i] = [(x - f * y) % 11 for x, y in zip(M[i], M[r0])]
        piv.append(col)
        r0 += 1
    cons = all(M[i][6] % 11 == 0 for i in range(r0, len(M)))
    xis = [0] * 6
    for i, c in enumerate(piv):
        xis[c] = M[i][6]
    return (xis if (r0 == 6 and cons) else None), f"rank {r0}/6, consistent {cons}"

def active_set(ell):
    """A(ell) = {eps in {3,9,5,4} : a_eps != 0}, a_eps = <ell, v_eps>/5"""
    out = set()
    for eps in (3, 9, 5, 4):
        ie = pow(eps, 9, 11)          # eps^{-1} mod 11 (eps^5 = 1 => eps^4 = eps^{-1})
        val = sum(ell[j] * pow(ie, j, 11) for j in range(5)) % 11
        if val:
            out.add(eps)
    return out

def item8():
    xg, note = analyze_aligned(G9, seed_for(80))
    ref = [7, 4, 2, 10, 3, 9]
    exp = [(9 * x) % 11 for x in ref]
    sub(xg == [8, 3, 7, 2, 5, 4],
        f"analyze(G9) at fresh seed -> xi* = {xg} (expect (8,3,7,2,5,4)); {note}")
    sub(exp == [8, 3, 7, 2, 5, 4] and xg == exp,
        f"identity 9*(7,4,2,10,3,9) mod 11 = {exp} == the -4-normalized xi*(G9)")
    xb, noteb = analyze_aligned((2, 1, -4, 4, 0), seed_for(81))
    sub(xb == [1, 10, 5, 3, 2, 6],
        f"analyze((2,1,-4,4,0)) at fresh seed -> xi* = {xb} "
        f"(expect (1,10,5,3,2,6)); {noteb}; nowhere zero {bool(xb) and all(xb)}")
    sub(aligned_lambda((2, 1, -4, 4, 0)) == 8,
        f"e_b = (2,1,-4,4,0) is aligned with lambda = {aligned_lambda((2,1,-4,4,0))} "
        f"(expect 8)")
    fh = {}
    zeros = []
    for T in CLASSREP:
        for eps in (3, 9, 5, 4):
            v = sum(pow(eps, k, 11) for k in T) % 11
            fh[(tuple(sorted(T)), eps)] = v
            if v == 0:
                zeros.append((tuple(sorted(T)), eps))
    sub(len(fh) == 24 and not zeros,
        f"block-Fourier lemma: all {len(fh)} coefficients 1^_S(eps) nonzero "
        f"(zeros: {zeros})")
    rng = random.Random(seed_for(82))
    tested = viol = degen = 0
    firstbad = None
    while tested < 200:
        ell = tuple(rng.randint(-6, 6) for _ in range(5))
        if active_set(ell) != {3, 9, 5, 4}:
            continue
        L, solve_ray = make_fan(ell)
        rays = [solve_ray(set(T)) for T in CLASSREP]
        if any(r is None for r in rays):
            degen += 1
            continue
        targ = [(-sum(r[i] * c9[i] for i in range(5))) % 11 for r in rays]
        tested += 1
        if not all(targ):
            viol += 1
            if firstbad is None:
                firstbad = (ell, targ)
    sub(viol == 0, f"{tested} fresh fully-active generic ell: {viol} with a vanishing "
                   f"class target (expect 0; {degen} degenerate skipped; "
                   f"first violation {firstbad})")

# ================================================================= item 9 ===
def item9():
    rng = random.Random(seed_for(90))
    bad = 0
    firstbad = None
    for _ in range(500):
        n = [rng.randint(-40, 40) for _ in range(5)]
        n[4] -= sum(n)
        n = tuple(n)
        pts, m = [], n
        for _ in range(5):
            pts.append(m)
            m = sigN(m)
        h = {}
        for p in pts:
            if p not in h:
                h[p] = rng.randint(-10 ** 6, 10 ** 6)
        def sigInv(v):
            return tuple(v[(j + 1) % 5] for j in range(5))
        def F(v):
            return 2 * h[v] + h[sigInv(v)] - v[2]
        tot = sum(pow(9, k) * F(pts[k]) for k in range(5))
        if (tot + c9pair(n)) % 11 != 0:
            bad += 1
            if firstbad is None:
                firstbad = (n, tot % 11, (-c9pair(n)) % 11)
    sub(bad == 0, f"Theorem R: sum_k 9^k F(sig^k n) == -<n,c9> (mod 11) on 500 fresh "
                  f"random (h, n): {bad} failures (first {firstbad})")
    # the c9 identity that makes the statement well posed
    ce = [pow(9, (2 - j) % 5, 11) for j in range(5)]
    sub(ce == list(c9), f"c9 = sum_i 9^i sig^{{-i}} e_2 = {ce} (expect (4,9,1,5,3))")
    sub(all((c9[(j - 1) % 5] - 9 * c9[j]) % 11 == 0 for j in range(5)),
        "sigma(c9) == 9*c9 (mod 11)")

# ==================================================================== main ==
def main():
    print("f55_verify_all.py -- master verifier, wave-31 F55 campaign")
    print(f"base seed {BASE_SEED} (override with F55_BASE_SEED); "
          f"derived item seeds are fresh w.r.t. every committed probe")
    t0 = time.time()
    items = [
        (1, "G9-fan: ray gaps 55; chamber formula == sampled pipeline (fresh seeds)", item1),
        (2, "level-1 exact forcing: rank = #free rays, all 18 surviving patterns", item2),
        (3, "exact 24-row level-2 systems: all infeasible; minimal certificate sizes", item3),
        (4, "E-web: rank(E) = 6, relation sums 0, unique xi* = (7,4,2,10,3,9)", item4),
        (5, "covering counts: 0/15625, 15625/15625, drop-one (3125,350,350,350,350,3125)", item5),
        (6, "A4-fan: six class targets (2,1,8,7,9,4); 5000 fresh patterns infeasible", item6),
        (7, "sign-fan: Theta, dim 7, pair table, DFS over all minimal patterns", item7),
        (8, "ell-fans: xi*(G9), xi*(e_b), block-Fourier, 200 fresh fully-active ell", item8),
        (9, "Theorem R: h-free congruence on 500 fresh random (h, n)", item9),
    ]
    for n, title, fn in items:
        item(n, title, fn)
    print(f"\ntotal {time.time() - t0:.1f}s")
    if FAILURES:
        print(f"\n{len(FAILURES)} FAILURES:")
        for f in FAILURES:
            print("  - " + f)
        sys.exit(1)
    print(f"\nALL PASS ({len(items)} items)")
    sys.exit(0)

if __name__ == "__main__":
    main()
