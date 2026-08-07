#!/usr/bin/env python3
# Theorem Q crux: does an INTEGRAL-slope PL function h on the A4 Weyl fan
# exist such that F := 2h + h.sigma^{-1} - e2* has its sigma-orbit minimum
# attained >= 2x everywhere?  Rational solutions exist (the invariant point
# u = (2+sigma)^{-1} e2, denominator 11); the battle is integrality.
# Strategy: per equivariant tie-pattern, assemble exact equalities +
# inequalities at chamber rays; solve the equality system over Q; check the
# invariant point solves everything (pipeline self-test); then search the
# solution space for integral points.
from fractions import Fraction as Fr
from itertools import permutations, combinations
import sys

# ---- lattice: N = {n in Z^5 : sum n = 0}; represent as 5-tuples ----
def ray(S):  # 5*chi_S - |S|*(1,..,1)
    return tuple(5*(i in S) - len(S) for i in range(5))
SETS = []
for k in range(1, 5):
    for S in combinations(range(5), k):
        SETS.append(frozenset(S))
RAYS = {S: ray(S) for S in SETS}          # 30 rays
RIDX = {S: i for i, S in enumerate(SETS)}
def sigN(n):  # sigma on N: chosen so that <sig_L u, n> = <u, sigN^{-1} n>;
    return tuple(n[(j-1) % 5] for j in range(5))
def sigN_inv(n):
    return tuple(n[(j+1) % 5] for j in range(5))
def sigS(S):  # induced action on ray index sets: ray(sigS S) = sigN(ray(S))
    return frozenset((i+1) % 5 for i in S)

# chambers <-> orderings pi (n_pi0 >= ... >= n_pi4); rays = prefixes
CHAMBERS = list(permutations(range(5)))
def chamber_rays(pi):
    return [frozenset(pi[:k]) for k in range(1, 5)]
def sig_ch(pi):  # sigma maps chamber pi to chamber pi' with sets shifted
    return tuple((p+1) % 5 for p in pi)

# ---- h as vector x over rays; evaluate h at any n by locating chamber ----
def locate(n):
    pi = tuple(sorted(range(5), key=lambda j: -n[j]))
    return pi
def coords_in_chamber(n, pi):
    # n = sum c_k * ray(prefix_k)/1 ; for A4: c_k = (n[pi[k-1]] - n[pi[k]])/5
    cs = []
    for k in range(1, 5):
        cs.append(Fr(n[pi[k-1]] - n[pi[k]], 5))
    return cs
def h_eval_vec(n):
    # returns row vector (over rays) with h(n) = row . x   (exact, PL)
    pi = locate(n)
    cs = coords_in_chamber(n, pi)
    row = [Fr(0)]*30
    for k, S in enumerate(chamber_rays(pi)):
        row[RIDX[S]] += cs[k]
    return row
def e2star(n):  # <e2, n> = n_2
    return Fr(n[2])

# F_i(n) = 2 h(s^i n) + h(s^{i-1} n) - (s^i n)_2
def F_row(i, n):
    m = n
    for _ in range(i): m = sigN(m)
    m1 = sigN_inv(m)
    row = [Fr(0)]*30
    for r, c in zip(h_eval_vec(m), [Fr(2)]*1):
        pass
    rv = h_eval_vec(m); rv1 = h_eval_vec(m1)
    row = [2*a + b for a, b in zip(rv, rv1)]
    const = -e2star(m)
    return row, const

# ---- pipeline self-test: invariant rational point ----
# solve (2 + sig_L) u = e2 on characters Lambda = Z^5/diag, rationally.
# characters as 5-tuples mod diag; sig_L e_j = e_{j+1}
def sigL(u): return tuple(u[(j-1) % 5] for j in range(5))
# solve 2u + sigL u = e2: componentwise 2u_j + u_{j-1} = delta_{j,2} (mod diag freedom)
# solve exactly over Q: u_j unknowns, 5 eqs up to adding c*(1,1,1,1,1)
import itertools
A = [[Fr(0)]*5 for _ in range(5)]
bb = [Fr(0)]*5
for j in range(5):
    A[j][j] += 2; A[j][(j-1) % 5] += 1
    bb[j] = Fr(1) if j == 2 else Fr(0)
# gaussian solve
M = [row[:] + [bb[i]] for i, row in enumerate(A)]
for col in range(5):
    piv = next(r for r in range(col, 5) if M[r][col] != 0)
    M[col], M[piv] = M[piv], M[col]
    pv = M[col][col]
    M[col] = [v/pv for v in M[col]]
    for r in range(5):
        if r != col and M[r][col] != 0:
            f = M[r][col]
            M[r] = [v - f*w for v, w in zip(M[r], M[col])]
u_rat = [M[r][5] for r in range(5)]
den = 1
for v in u_rat: den = den*v.denominator // __import__('math').gcd(den, v.denominator)
print("invariant point u = (2+sig)^-1 e2 =", u_rat, " lcm denominator =", den)
assert den % 11 == 0, "convention self-test failed: denominator should be 11"
# h_lin(n) = <u, n>; as ray-vector x_inv:
x_inv = [sum(u_rat[j]*RAYS[S][j] for j in range(5)) for S in SETS]

def F_val(x, i, n):
    row, const = F_row(i, n)
    return sum(a*b for a, b in zip(row, x)) + const
# check invariance of F for x_inv at random points
import random
random.seed(5)
ok = True
for _ in range(40):
    n = [random.randint(-9, 9) for _ in range(5)]
    n[4] = -sum(n[:4])
    n = tuple(n)
    vals = [F_val(x_inv, i, n) for i in range(5)]
    if len(set(vals)) != 1: ok = False
print("self-test: F invariant at rational point:", ok)
assert ok

# ---- pattern LP: tie (i(C), i(C)+1) with i determined by C5-translate ----
# fundamental domain: chambers pi with pi.index(0) == 0 (24 chambers);
# sigma^i FD gets tie (i, i+1).
def fd_index(pi):
    # which translate: k such that sigma^{-k}(chamber) has 0 first
    for k in range(5):
        q = pi
        for _ in range(k):
            q = tuple((p-1) % 5 for p in q)
        if q[0] == 0: return k
    raise RuntimeError

def build_system(tieof):
    eqs = []   # rows (len 30) == const
    ineqs = [] # row . x + const >= 0
    for pi in CHAMBERS:
        i = tieof(pi)
        j = (i+1) % 5
        for S in chamber_rays(pi):
            n = RAYS[S]
            ri, ci = F_row(i, n)
            rj, cj = F_row(j, n)
            eqs.append(([a-b for a, b in zip(ri, rj)], cj - ci))
            for k in range(5):
                if k in (i, j): continue
                rk, ck = F_row(k, n)
                ineqs.append(([a-b for a, b in zip(rk, ri)], ck - ci))
    return eqs, ineqs

def solve_affine(eqs):
    # solve eqs over Q: returns (particular, basis of homogeneous solutions) or None
    rows = [r[:] + [c] for r, c in [(list(e[0]), -e[1]) for e in eqs]]
    # note: row.x == const means row.x - const = 0; store augmented [row | const]
    rows = [list(e[0]) + [Fr(e[1])*(-1)*(-1)] for e in eqs]
    # we want row.x = -(const)?? F_i - F_j = (ri-rj).x + (ci-cj) = 0 -> (ri-rj).x = cj-ci
    aug = [list(r) + [c] for (r, c) in eqs]
    ncols = 30
    piv_cols = []
    r0 = 0
    for col in range(ncols):
        piv = next((r for r in range(r0, len(aug)) if aug[r][col] != 0), None)
        if piv is None: continue
        aug[r0], aug[piv] = aug[piv], aug[r0]
        pv = aug[r0][col]
        aug[r0] = [v/pv for v in aug[r0]]
        for r in range(len(aug)):
            if r != r0 and aug[r][col] != 0:
                f = aug[r][col]
                aug[r] = [v - f*w for v, w in zip(aug[r], aug[r0])]
        piv_cols.append(col); r0 += 1
    for r in range(r0, len(aug)):
        if aug[r][30] != 0: return None
    part = [Fr(0)]*30
    for r, col in enumerate(piv_cols):
        part[col] = aug[r][30]
    free = [c for c in range(30) if c not in piv_cols]
    basis = []
    for f in free:
        v = [Fr(0)]*30; v[f] = Fr(1)
        for r, col in enumerate(piv_cols):
            v[col] = -aug[r][f]
        basis.append(v)
    return part, basis, free

tie1 = lambda pi: fd_index(pi)
eqs, ineqs = build_system(tie1)
res = solve_affine(eqs)
if res is None:
    print("pattern T1: equality system INFEASIBLE over Q")
else:
    part, basis, free = res
    print(f"pattern T1: equality system feasible over Q; solution space dim = {len(basis)}")
    # check invariant point satisfies equalities (it must)
    chk = all(sum(a*b for a, b in zip(e[0], x_inv)) == e[1] for e in eqs)
    print("  invariant point satisfies T1 equalities:", chk)
    viol = sum(1 for r, c in ineqs if sum(a*b for a, b in zip(r, x_inv)) + c < 0)
    print("  invariant point inequality violations:", viol, "of", len(ineqs))
    # Integrality probe: is there an integral point in the affine solution space
    # (before inequalities)?  Solve part + span(basis) cap Z^30: check the
    # fractional part of part modulo the basis lattice via HNF-lite:
    # quick necessary test: clear denominators of part along basis directions
    # by brute small search over free variables mod small denominators.
    D = 1
    for v in part: D = D*v.denominator // __import__('math').gcd(D, v.denominator)
    print("  particular-solution lcm denominator:", D)

# ---- integer solvability of the equality system (Smith-style) ----
def zsolve(eqs):
    # clear denominators per equation to integers
    import math
    E = []; c = []
    for row, const in eqs:
        L = 1
        for v in row + [const]:
            L = L*v.denominator // math.gcd(L, v.denominator)
        E.append([int(v*L) for v in row]); c.append(int(const*L))
    m, n = len(E), 30
    # HNF-based solve of E x = c over Z: work on augmented via column ops on x
    # use standard algorithm: reduce E to row-echelon over Z with unimodular row ops? 
    # simpler: solve via SNF of E: U E V = D. x = V y, D y = U c.
    # implement small dense SNF (m x n with m large: first reduce rows by gcd elimination)
    import copy
    A = [row[:] for row in E]; b = c[:]
    # row-reduce over Z: for each column, gcd-eliminate
    Vt = None
    # We'll do column-style: maintain x-transform V (n x n)
    V = [[1 if i == j else 0 for j in range(n)] for i in range(n)]
    r = 0
    for col in range(n):
        # find pivot row >= r with nonzero in col; gcd-reduce among rows
        rows_nz = [i for i in range(r, m) if A[i][col] != 0]
        if not rows_nz: continue
        # bring smallest abs to position r, eliminate others by integer ops (rows only)
        while True:
            rows_nz = [i for i in range(r, m) if A[i][col] != 0]
            if not rows_nz: break
            piv = min(rows_nz, key=lambda i: abs(A[i][col]))
            A[r], A[piv] = A[piv], A[r]; b[r], b[piv] = b[piv], b[r]
            done = True
            for i in range(r+1, m):
                if A[i][col] != 0:
                    q = A[i][col] // A[r][col]
                    A[i] = [a - q*p for a, p in zip(A[i], A[r])]
                    b[i] = b[i] - q*b[r]
                    if A[i][col] != 0: done = False
            if done: break
        if A[r][col] != 0:
            if A[r][col] < 0:
                A[r] = [-a for a in A[r]]; b[r] = -b[r]
            r += 1
        if r == m: break
    rank = r
    # back-substitution feasibility over Z with denominators tracked:
    # solve triangular-ish system by fractions, then check integrality via mod:
    # simpler: rational solve + lattice test along kernel basis using HNF of
    # combined matrix [basis | I]... use direct approach: find one rational
    # solution x0 and integral kernel lattice Kz of E; integral solution exists
    # iff x0 mod (Kz + Z^30-compat): test via solving E x = c mod M for growing M
    # PRACTICAL: try CRT-style: solve mod 11 and mod 3 and lift by search along kernel.
    return A[:rank], b[:rank], rank

Ar, br, rank = zsolve(eqs)
print("integer-reduced equality system rank:", rank)
# mod-p solvability tests
def modsolve(Ar, br, p):
    A = [[a % p for a in row] for row in Ar]; b = [x % p for x in br]
    m, n = len(A), 30
    r = 0; piv = []
    for col in range(n):
        pr = next((i for i in range(r, m) if A[i][col] % p), None)
        if pr is None: continue
        A[r], A[pr] = A[pr], A[r]; b[r], b[pr] = b[pr], b[r]
        inv = pow(A[r][col], p-2, p)
        A[r] = [(v*inv) % p for v in A[r]]; b[r] = (b[r]*inv) % p
        for i in range(m):
            if i != r and A[i][col] % p:
                f = A[i][col]
                A[i] = [(v - f*w) % p for v, w in zip(A[i], A[r])]
                b[i] = (b[i] - f*b[r]) % p
        piv.append(col); r += 1
    for i in range(r, m):
        if b[i] % p: return False
    return True
for p in (2, 3, 5, 11, 121):
    if p == 121:
        continue
    print(f"  equality system solvable mod {p}:", modsolve(Ar, br, p))

# ---- pattern sweep with mod-11 filter ----
import random as rnd
rnd.seed(11)
ORBITS = {}
for pi in CHAMBERS:
    k = fd_index(pi)
    q = pi
    for _ in range(k): q = tuple((p-1) % 5 for p in q)
    ORBITS.setdefault(q, []).append((pi, k))
REPS = list(ORBITS.keys())
def build_from_choice(choice):  # choice: rep -> (i0, j0) tie pair at translate 0
    def tieof(pi):
        k = fd_index(pi)
        q = pi
        for _ in range(k): q = tuple((p-1) % 5 for p in q)
        i0, j0 = choice[q]
        return ((i0 + k) % 5, (j0 + k) % 5)
    eqs = []
    for pi in CHAMBERS:
        i, j = tieof(pi)
        for S in chamber_rays(pi):
            n = RAYS[S]
            ri, ci = F_row(i, n); rj, cj = F_row(j, n)
            eqs.append(([a-b for a, b in zip(ri, rj)], cj - ci))
    return eqs
def mod11_feasible(eqs):
    p = 11
    import math
    rowsI = []
    for row, const in eqs:
        L = 1
        for v in row + [const]:
            L = L*v.denominator // math.gcd(L, v.denominator)
        if L % 11 == 0:
            L *= 1
        rowsI.append(([int(v*L) % p for v in row], int(const*L) % p))
    A = [r for r, c in rowsI]; b = [c for r, c in rowsI]
    m, n = len(A), 30
    r = 0
    for col in range(n):
        pr = next((i for i in range(r, m) if A[i][col] % p), None)
        if pr is None: continue
        A[r], A[pr] = A[pr], A[r]; b[r], b[pr] = b[pr], b[r]
        inv = pow(A[r][col], p-2, p)
        A[r] = [(v*inv) % p for v in A[r]]; b[r] = (b[r]*inv) % p
        for i2 in range(m):
            if i2 != r and A[i2][col] % p:
                f = A[i2][col]
                A[i2] = [(v - f*w) % p for v, w in zip(A[i2], A[r])]
                b[i2] = (b[i2] - f*b[r]) % p
        r += 1
    return all(b[i] % p == 0 for i in range(r, m))

# structured families: uniform consecutive (i0, i0+1) and skips (i0, i0+2)
results = {}
for d in (1, 2, 3, 4):
    for i0 in range(5):
        choice = {q: (i0, (i0+d) % 5) for q in REPS}
        eqs2 = build_from_choice(choice)
        results[(d, i0)] = mod11_feasible(eqs2)
print("uniform patterns (d, i0) -> mod-11 feasible:", results)
# randomized mixed patterns
feas = 0; tried = 400
pairs = [(i, j) for i in range(5) for j in range(5) if i != j]
for t in range(tried):
    choice = {q: rnd.choice(pairs) for q in REPS}
    if mod11_feasible(build_from_choice(choice)):
        feas += 1
        print("  mod-11 FEASIBLE mixed pattern found at trial", t)
        break
print(f"random mixed patterns: {feas} feasible in {t+1 if feas else tried} tried")

# ---- extract mod-11 Farkas certificate for T1 and examine structure ----
def farkas11(eqs):
    p = 11
    import math
    rowsI = []
    for row, const in eqs:
        L = 1
        for v in row + [const]:
            L = L*v.denominator // math.gcd(L, v.denominator)
        rowsI.append(([int(v*L) % p for v in row], int(const*L) % p))
    m = len(rowsI); n = 30
    # find y with y.A = 0, y.b != 0: row-reduce transpose with identity tracking
    A = [list(r) + [c] for r, c in rowsI]  # m x 31
    # We reduce the system's rows; track combination via Y (m x m sparse-lite: too big)
    # instead solve: find y in left kernel with y.b != 0 by solving A^T y = 0 (31 x m)
    # y lives in F_11^m, m = 480: solve A^T y = 0 with the b-column giving y.b
    AT = [[A[i][j] for i in range(m)] for j in range(31)]
    # gaussian on AT (31 x m): kernel of the 30 coefficient rows, then need b-row nonzero
    coef = AT[:30]; brow = AT[30]
    # reduce coef
    r = 0; piv = {}
    cols = list(range(m))
    for row_i in range(30):
        pr = next((cc for cc in range(m) if coef[row_i][cc] % p and cc not in piv.values()), None)
    # simpler: use generic method: find y = brow - projection onto row space of coef? 
    # We want y orthogonal to all coef rows (as vectors in F^m) with y.b != 0 --
    # equivalently b-row not in row space of coef. Compute rank(coef) vs rank(coef+b).
    def rank_rows(rows):
        R = [r2[:] for r2 in rows]; m2 = len(R); n2 = len(R[0]); rr = 0
        for col in range(n2):
            pr = next((i for i in range(rr, m2) if R[i][col] % p), None)
            if pr is None: continue
            R[rr], R[pr] = R[pr], R[rr]
            inv = pow(R[rr][col], p-2, p)
            R[rr] = [(v*inv) % p for v in R[rr]]
            for i in range(m2):
                if i != rr and R[i][col] % p:
                    f = R[i][col]
                    R[i] = [(v - f*w) % p for v, w in zip(R[i], R[rr])]
            rr += 1
        return rr, R
    r1, _ = rank_rows(coef)
    r2, _ = rank_rows(coef + [brow])
    print("mod-11 T1: rank(coef^T) =", r1, " rank with b-row =", r2, "(b independent => infeasible)", r2 > r1)

# ---- call the certificate extraction and print structure ----
def farkas_vec(eqs):
    p = 11
    import math
    rowsI = []
    for row, const in eqs:
        L = 1
        for v in row + [const]:
            L = L*v.denominator // math.gcd(L, v.denominator)
        rowsI.append(([int(v*L) % p for v in row], int(const*L) % p))
    m = len(rowsI); n = 30
    # reduce the transposed homogeneous part, tracking combos on the identity
    # y.A = 0, y.b != 0. Solve: rows of [A^T] (n x m), find y in kernel with b.y != 0
    # via reducing [A^T; b^T] and finding dependency of b-row: track combination.
    AT = [[rowsI[i][0][j] for i in range(m)] for j in range(n)]
    bT = [rowsI[i][1] for i in range(m)]
    # reduce AT rows to echelon (in F_p^m), keep them; then express: find y
    # orthogonal to all AT rows: kernel of AT (as matrix n x m acting on y).
    # kernel via row-reduction of AT and free-variable extraction:
    A2 = [r[:] for r in AT]
    piv = []
    r = 0
    for col in range(m):
        pr = next((i for i in range(r, n) if A2[i][col] % p), None)
        if pr is None: continue
        A2[r], A2[pr] = A2[pr], A2[r]
        inv = pow(A2[r][col], p-2, p)
        A2[r] = [(v*inv) % p for v in A2[r]]
        for i in range(n):
            if i != r and A2[i][col] % p:
                f = A2[i][col]
                A2[i] = [(v - f*w) % p for v, w in zip(A2[i], A2[r])]
        piv.append(col); r += 1
        if r == n: break
    # y kernel: free coords = non-pivot columns; y[pc] = -sum A2[r][f]*y[f]
    # search for kernel vector with b.y != 0: try unit vectors on free coords
    freecols = [c for c in range(m) if c not in piv]
    for f in freecols:
        y = [0]*m; y[f] = 1
        for rr, pc in enumerate(piv):
            y[pc] = (-A2[rr][f]) % p
        by = sum(bT[i]*y[i] for i in range(m)) % p
        if by % p:
            supp = [(i, y[i]) for i in range(m) if y[i] % p]
            print(f"certificate found: b.y = {by}, support size {len(supp)} of {m}")
            # structure: rows are indexed by (chamber, ray) in build order (4 rows per chamber)
            from collections import Counter
            cnt = Counter()
            for i, cy in supp:
                ch = i // 4
                cnt[ch] += 1
            print("  chambers touched:", len(cnt), "coefficient values used:", sorted(set(cy for _, cy in supp)))
            return
    print("no single-free-var certificate; obstruction uses combined directions")
farkas_vec(eqs)

# ---- full detail of the 4-term certificate ----
def farkas_detail(eqs, tieof):
    p = 11
    import math
    rowsI = []
    meta = []
    for ci, pi in enumerate(CHAMBERS):
        i, j = (tieof(pi), (tieof(pi)+1) % 5) if not isinstance(tieof(pi), tuple) else tieof(pi)
        for S in chamber_rays(pi):
            meta.append((pi, (i, j), S))
    for row, const in eqs:
        L = 1
        for v in row + [const]:
            L = L*v.denominator // math.gcd(L, v.denominator)
        rowsI.append(([int(v*L) % p for v in row], int(const*L) % p))
    m = len(rowsI); n = 30
    AT = [[rowsI[i][0][j] for i in range(m)] for j in range(n)]
    bT = [rowsI[i][1] for i in range(m)]
    A2 = [r[:] for r in AT]; piv = []; r = 0
    for col in range(m):
        pr = next((i for i in range(r, n) if A2[i][col] % p), None)
        if pr is None: continue
        A2[r], A2[pr] = A2[pr], A2[r]
        inv = pow(A2[r][col], p-2, p)
        A2[r] = [(v*inv) % p for v in A2[r]]
        for i in range(n):
            if i != r and A2[i][col] % p:
                f = A2[i][col]
                A2[i] = [(v - f*w) % p for v, w in zip(A2[i], A2[r])]
        piv.append(col); r += 1
        if r == n: break
    freecols = [c for c in range(m) if c not in piv]
    for f in freecols:
        y = [0]*m; y[f] = 1
        for rr, pc in enumerate(piv):
            y[pc] = (-A2[rr][f]) % p
        by = sum(bT[i]*y[i] for i in range(m)) % p
        if by % p:
            supp = [(i, y[i]) for i in range(m) if y[i] % p]
            if len(supp) <= 6:
                for i, cy in supp:
                    pi, tie, S = meta[i]
                    print(f"  coeff {cy}: chamber {pi} tie {tie} ray {sorted(S)} rayvec {RAYS[S]}")
                print("  b.y =", by)
                return
    print("(no short certificate this pass)")
farkas_detail(eqs, tie1)
