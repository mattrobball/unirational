#!/usr/bin/env python3
"""V14_MAP_DICHOTOMY verifier -- pure python3, no dependencies.

Replays, at two primes, the machine-checkable content of this packet.

  1  model        SL(2,11) even Weil 6-space U (T6, S6, gauss^2 = -11, S6^2 = -I),
                  1320-closure, M = 10' summand of Lambda^2 U (rank-10 projector),
                  A = Ann(M) in Lambda^4 U (dim 5).  Same conventions as
                  goal_runs_after_c53d89a/FIX_IX_SEAL/scripts/seal.py.
  2  v14points    generator for F_p-points of V14 = Gr(2,U) cap P(M); each point
                  is checked to lie in M and to satisfy the Plucker (wedge-square)
                  equations.
  3  hom1         Hom_G(M, A) = 0            (no degree-1 covariant)
  4  sym2char     multiplicities in Sym^2(M): 1, 5, 5bar each once, 10' twice,
                  <chi,chi> = 9, dim 55      (corrects the session's "dim 26")
  5  quadcov      the (unique up to scale) quadratic covariant q: Sym^2 M -> A
                  exists, is equivariant, and vanishes identically on V14;
                  same for the conjugate 5-space A^dual
  6  secant       the cubic-secant residual identity over F_{p^2} on the standard
                  cyclic Klein cubic (Theorem B step 5)
  7  noinvariant  A^G = 0, hence P(A)^G = X^G = empty  (Phi is nonconstant)
  8  pins         repository pins: sealed exit strings and external documents

Usage:  python3 verifier.py [p ...]      (default: 397 199)
Writes results/checks.log; exits 0 on ALLGREEN.
"""

import os
import random
import subprocess
import sys
from itertools import combinations, permutations

HERE = os.path.dirname(os.path.abspath(__file__))
PROBLEM_ROOT = os.path.abspath(os.path.join(HERE, '..', '..'))
RESULTS = os.path.join(HERE, 'results')

PAIRS = list(combinations(range(6), 2))     # Lambda^2 basis, lex
QUADS = list(combinations(range(6), 4))     # Lambda^4 basis, lex
PIDX = {a: i for i, a in enumerate(PAIRS)}
QIDX = {K: i for i, K in enumerate(QUADS)}

LOG = []


def note(name, ok, detail):
    line = "CHECK %s %s %s" % (name, "PASS" if ok else "FAIL", detail)
    print(line)
    LOG.append((name, bool(ok), detail))


# ---------------------------------------------------------------- combinatorics
def perm_sign(seq):
    s, seq = 1, list(seq)
    for i in range(len(seq)):
        for j in range(i + 1, len(seq)):
            if seq[i] > seq[j]:
                s = -s
    return s


PERMS4 = list(permutations(range(4)))
SGN4 = [perm_sign(x) for x in PERMS4]

WEDGE = {}          # (index of pair a, index of pair b) -> (index of a|b, sign)
for _ia, _a in enumerate(PAIRS):
    for _ib, _b in enumerate(PAIRS):
        if set(_a) & set(_b):
            continue
        WEDGE[(_ia, _ib)] = (QIDX[tuple(sorted(_a + _b))], perm_sign(list(_a) + list(_b)))


def pair24(K, a):
    """<e_K ^ e_a> in Lambda^6 = k, for K a 4-set and a a 2-set."""
    if set(K) & set(a):
        return 0
    return perm_sign(list(K) + list(a))


# ---------------------------------------------------------------- linear algebra
def mmul(A, B, p):
    Bt = list(zip(*B))
    return tuple(tuple(sum(x * y for x, y in zip(row, col)) % p for col in Bt) for row in A)


def matvec(A, v, p):
    return tuple(sum(x * y for x, y in zip(row, v)) % p for row in A)


def eye(n, p=None):
    return tuple(tuple(1 if i == j else 0 for j in range(n)) for i in range(n))


def rref(rows, p):
    """Reduced row echelon form; returns (nonzero rows, pivot columns)."""
    A = [[x % p for x in r] for r in rows]
    if not A:
        return [], []
    r, piv, ncol = 0, [], len(A[0])
    for c in range(ncol):
        q = next((i for i in range(r, len(A)) if A[i][c]), None)
        if q is None:
            continue
        A[r], A[q] = A[q], A[r]
        iv = pow(A[r][c], p - 2, p)
        A[r] = [(x * iv) % p for x in A[r]]
        for i in range(len(A)):
            if i != r and A[i][c]:
                t = A[i][c]
                A[i] = [(x - t * y) % p for x, y in zip(A[i], A[r])]
        piv.append(c)
        r += 1
        if r == len(A):
            break
    return [tuple(x) for x in A[:r]], piv


def kernel(rows, nvar, p):
    R, piv = rref(rows, p)
    free = [j for j in range(nvar) if j not in piv]
    out = []
    for f in free:
        v = [0] * nvar
        v[f] = 1
        for row, pc in zip(R, piv):
            v[pc] = (-row[f]) % p
        out.append(tuple(v))
    return out


def rank(rows, p):
    return len(rref(rows, p)[0])


def inv_matrix(A, p):
    n = len(A)
    M = [list(r) + [1 if i == j else 0 for j in range(n)] for i, r in enumerate(A)]
    R, piv = rref(M, p)
    assert piv == list(range(n)), "matrix not invertible"
    return tuple(tuple(row[n:]) for row in R)


# ---------------------------------------------------------------- compounds
def lam2(M, p):
    return tuple(tuple((M[i][k] * M[j][l] - M[i][l] * M[j][k]) % p for (k, l) in PAIRS)
                 for (i, j) in PAIRS)


def det4(sub, p):
    s = 0
    for pi, sg in zip(PERMS4, SGN4):
        t = 1
        for i in range(4):
            t = t * sub[i][pi[i]]
        s += sg * t
    return s % p


def lam4(M, p):
    return tuple(tuple(det4([[M[K[i]][L[j]] for j in range(4)] for i in range(4)], p)
                       for L in QUADS) for K in QUADS)


# ---------------------------------------------------------------- the model
CHI10P = {1: 10, 2: 2, 3: 1, 5: 0, 6: -1, 11: -1}     # character of 10' by proj order


def build_model(p):
    assert p % 11 == 1, "need p = 1 mod 11"
    g11 = next(t for t in range(2, p) if pow(t, 11, p) == 1 and t != 1)
    gauss = sum(pow(g11, (k * k) % 11, p) for k in range(11)) % p
    ok_gauss = (gauss * gauss + 11) % p == 0
    c = pow(gauss, p - 2, p)
    T6 = tuple(tuple((pow(g11, (j * j) % 11, p) if i == j else 0) for j in range(6))
               for i in range(6))
    S6 = tuple(tuple((c if j == 0 else c * (pow(g11, (i * j) % 11, p)
                                            + pow(g11, (-i * j) % 11, p))) % p
                     for j in range(6)) for i in range(6))
    minusI = tuple(tuple((-1 if i == j else 0) % p for j in range(6)) for i in range(6))
    ok_S = mmul(S6, S6, p) == minusI

    # --- 1320-closure, with parent pointers so representations propagate cheaply
    I6 = eye(6)
    idx = {I6: 0}
    elems = [I6]
    par = [(-1, -1)]
    frontier = [0]
    while frontier:
        nxt = []
        for i in frontier:
            Mi = elems[i]
            for gi, gg in enumerate((T6, S6)):
                N = mmul(Mi, gg, p)
                if N not in idx:
                    idx[N] = len(elems)
                    elems.append(N)
                    par.append((i, gi))
                    nxt.append(len(elems) - 1)
        frontier = nxt
        assert len(elems) <= 1400

    def is_scalar(A):
        d = A[0][0]
        return d != 0 and all(A[i][j] == (d if i == j else 0)
                              for i in range(6) for j in range(6))

    def proj_order(M):
        A = M
        for k in range(1, 14):
            if is_scalar(A):
                return k
            A = mmul(A, M, p)
        return 99

    porder = [proj_order(M) for M in elems]
    profile = {}
    for k in porder:
        profile[k] = profile.get(k, 0) + 1

    # --- 10'-isotypic projector; M = its column space
    PM = [[0] * 15 for _ in range(15)]
    for i, M in enumerate(elems):
        w = CHI10P[porder[i]] % p
        if not w:
            continue
        L = lam2(M, p)
        for a in range(15):
            La = L[a]
            row = PM[a]
            for b in range(15):
                if La[b]:
                    row[b] = (row[b] + w * La[b]) % p
    sc = 10 * pow(1320 % p, p - 2, p) % p
    PM = [[sc * x % p for x in row] for row in PM]
    MB, piv = rref([tuple(PM[i][j] for i in range(15)) for j in range(15)], p)

    # --- A = Ann(M) in Lambda^4 U
    annrows = []
    for m in MB:
        annrows.append(tuple(sum(pair24(K, a) * m[ai] for ai, a in enumerate(PAIRS)) % p
                             for K in QUADS))
    ANN, apiv = rref(kernel(annrows, 15, p), p)

    # --- linear conditions cutting M inside Lambda^2 U:  D . omega = 0
    D = [tuple(sum(pair24(K, a) * ANN[i][Ki] for Ki, K in enumerate(QUADS)) % p
               for a in PAIRS) for i in range(len(ANN))]

    mod = dict(p=p, T6=T6, S6=S6, elems=elems, idx=idx, par=par, porder=porder,
               profile=profile, MB=MB, piv=piv, ANN=ANN, apiv=apiv, D=D,
               ok_gauss=ok_gauss, ok_S=ok_S, gauss=gauss)

    if len(MB) != 10 or len(ANN) != 5:
        return mod

    # --- representation matrices on M (10-dim) and A (5-dim)
    def coordsM(v):
        return tuple(v[j] for j in piv)

    def coordsA(v):
        return tuple(v[j] for j in apiv)

    def rebuildM(cv):
        w = [0] * 15
        for ci, m in zip(cv, MB):
            if ci:
                for j in range(15):
                    w[j] = (w[j] + ci * m[j]) % p
        return tuple(w)

    def rebuildA(cv):
        w = [0] * 15
        for ci, m in zip(cv, ANN):
            if ci:
                for j in range(15):
                    w[j] = (w[j] + ci * m[j]) % p
        return tuple(w)

    stable = True
    genM, genA = [], []
    for g in (T6, S6):
        L2, L4 = lam2(g, p), lam4(g, p)
        colsM, colsA = [], []
        for m in MB:
            im = matvec(L2, m, p)
            cv = coordsM(im)
            stable = stable and rebuildM(cv) == im
            colsM.append(cv)
        for a in ANN:
            im = matvec(L4, a, p)
            cv = coordsA(im)
            stable = stable and rebuildA(cv) == im
            colsA.append(cv)
        genM.append(tuple(tuple(colsM[j][i] for j in range(10)) for i in range(10)))
        genA.append(tuple(tuple(colsA[j][i] for j in range(5)) for i in range(5)))
    mod['stable'] = stable
    mod['genM'], mod['genA'] = genM, genA

    I10, I5 = eye(10), eye(5)
    Mrep = [None] * len(elems)
    Arep = [None] * len(elems)
    Mrep[0], Arep[0] = I10, I5
    for i in range(1, len(elems)):
        pi, gi = par[i]
        Mrep[i] = mmul(Mrep[pi], genM[gi], p)
        Arep[i] = mmul(Arep[pi], genA[gi], p)
    mod['Mrep'], mod['Arep'] = Mrep, Arep

    # inverse index (used for dual characters / dual representation)
    inv_idx = [idx[inv_matrix(g, p)] for g in elems]
    mod['inv_idx'] = inv_idx

    # one representative per {+-g} pair: the action on M and on A factors through
    # PSL(2,11) (order 660) because Lambda^2(-I) = Lambda^4(-I) = identity.
    mI = minusI
    reps, seen = [], set()
    for i, g in enumerate(elems):
        if i in seen:
            continue
        j = idx[mmul(mI, g, p)]
        seen.add(i)
        seen.add(j)
        reps.append(i)
    mod['reps'] = reps
    return mod


# ---------------------------------------------------------------- check 1
def check_model(mod, tag):
    p = mod['p']
    ok = (mod['ok_gauss'] and mod['ok_S'] and len(mod['elems']) == 1320
          and mod['profile'] == {1: 2, 2: 110, 3: 220, 5: 528, 6: 220, 11: 240})
    note("model_" + tag, ok,
         "gauss^2=-11 %s, S6^2=-I %s, |<T,S>|=%d, proj-order profile %s"
         % (mod['ok_gauss'], mod['ok_S'], len(mod['elems']), sorted(mod['profile'].items())))
    ok2 = len(mod['MB']) == 10 and len(mod['ANN']) == 5 and mod.get('stable', False)
    note("summands_" + tag, ok2,
         "rank(10'-projector)=%d, dim Ann(M) in Lambda^4=%d, M and A are G-stable: %s"
         % (len(mod['MB']), len(mod['ANN']), mod.get('stable')))
    return ok and ok2


# ---------------------------------------------------------------- check 2
def wedge_of(u, v, p):
    return tuple((u[i] * v[j] - u[j] * v[i]) % p for (i, j) in PAIRS)


def wedge_square(om, p):
    q = [0] * 15
    for i in range(15):
        if not om[i]:
            continue
        for j in range(15):
            if om[j] and (i, j) in WEDGE:
                K, sg = WEDGE[(i, j)]
                q[K] = (q[K] + sg * om[i] * om[j]) % p
    return tuple(q)


def v14_points(mod, want, seed=20260810):
    """F_p-points of V14 = Gr(2,U) cap P(M).

    For u in U the map v -> u ^ v has kernel <u>; imposing the five linear
    conditions D that cut M out of Lambda^2 U gives a 5 x 6 matrix N(u) whose
    kernel always contains u.  When the kernel jumps to dimension 2 -- a
    codimension-1 condition on u, found by sweeping a random line in U -- any
    v in it independent of u gives a decomposable bivector u ^ v lying in M,
    i.e. a point of V14.
    """
    p, D, MB, piv = mod['p'], mod['D'], mod['MB'], mod['piv']
    rng = random.Random(seed)

    def Nmat(u):
        cols = []
        for j in range(6):
            w = [0] * 15
            for k in range(6):
                if k == j or not u[k] % p:
                    continue
                if k < j:
                    w[PIDX[(k, j)]] = u[k] % p
                else:
                    w[PIDX[(j, k)]] = (-u[k]) % p
            cols.append(w)
        return [[sum(D[i][a] * cols[j][a] for a in range(15)) % p for j in range(6)]
                for i in range(len(D))]

    out, seen = [], set()
    tries = 0
    while len(out) < want and tries < 4000:
        tries += 1
        u0 = [rng.randrange(p) for _ in range(6)]
        u1 = [rng.randrange(p) for _ in range(6)]
        N0, N1 = Nmat(u0), Nmat(u1)
        for t in range(p):
            N = [[(N0[i][j] + t * N1[i][j]) % p for j in range(6)] for i in range(len(D))]
            ker = kernel(N, 6, p)
            if len(ker) < 2:
                continue
            u = [(u0[j] + t * u1[j]) % p for j in range(6)]
            for v in ker:
                om = wedge_of(u, v, p)
                if any(om):
                    k0 = next(i for i in range(15) if om[i])
                    iv = pow(om[k0], p - 2, p)
                    key = tuple(x * iv % p for x in om)
                    if key in seen:
                        continue
                    seen.add(key)
                    out.append(om)
                    break
            if len(out) >= want:
                break
    return out


def check_v14_points(mod, tag, pts):
    p, D, MB, piv = mod['p'], mod['D'], mod['MB'], mod['piv']
    good = 0
    bad = []
    coords = []
    for om in pts:
        inM = all(sum(D[i][a] * om[a] for a in range(15)) % p == 0 for i in range(len(D)))
        pl = all(x == 0 for x in wedge_square(om, p))
        cv = tuple(om[j] for j in piv)
        w = [0] * 15
        for ci, m in zip(cv, MB):
            if ci:
                for j in range(15):
                    w[j] = (w[j] + ci * m[j]) % p
        rec = tuple(w) == tuple(om)
        if inM and pl and rec and any(om):
            good += 1
            coords.append(cv)
        else:
            bad.append((inM, pl, rec))
    note("v14points_" + tag, good >= 50 and not bad,
         "%d distinct V14 points: all in M, all decomposable, all satisfy the 15 "
         "wedge-square (Plucker) equations (%d failures)" % (good, len(bad)))
    return coords


# ---------------------------------------------------------------- check 3
def check_hom1(mod, tag):
    """Averaging projector on Hom(M, A):  P = (1/|G|) sum_g rho_A(g) (x) rho_M(g^-1)^T."""
    p, Mrep, Arep, inv_idx, reps = mod['p'], mod['Mrep'], mod['Arep'], mod['inv_idx'], mod['reps']
    acc = [[0] * 50 for _ in range(50)]
    for gi in reps:
        Ag, Ng = Arep[gi], Mrep[inv_idx[gi]]
        for k in range(5):
            Ak = Ag[k]
            for kp in range(5):
                cc = Ak[kp]
                if not cc:
                    continue
                base = kp * 10
                for i in range(10):
                    row = acc[k * 10 + i]
                    for j in range(10):
                        if Ng[j][i]:
                            row[base + j] = (row[base + j] + cc * Ng[j][i]) % p
    r = rank(acc, p)
    # cross-check by characters: <chi_M, chi_A> = (1/|G|) sum chi_M(g) chi_A(g^-1)
    s = 0
    for gi in reps:
        cm = sum(Mrep[gi][i][i] for i in range(10)) % p
        ca = sum(Arep[inv_idx[gi]][i][i] for i in range(5)) % p
        s += cm * ca
    mult = s * pow(660 % p, p - 2, p) % p
    note("hom1_" + tag, r == 0 and mult == 0,
         "rank of the G-averaging projector on Hom(M,A) = %d; <chi_M, chi_A> = %d "
         "(no degree-1 covariant)" % (r, mult))
    return r == 0 and mult == 0


# ---------------------------------------------------------------- check 4
def check_sym2(mod, tag):
    p, Mrep, Arep, inv_idx, reps = mod['p'], mod['Mrep'], mod['Arep'], mod['inv_idx'], mod['reps']
    inv660 = pow(660 % p, p - 2, p)
    inv2 = pow(2, p - 2, p)
    chiS, chiM, chiA, chiAd = {}, {}, {}, {}
    for gi in reps:
        R = Mrep[gi]
        c1 = sum(R[i][i] for i in range(10)) % p
        c2 = sum(R[i][j] * R[j][i] for i in range(10) for j in range(10)) % p   # chi_M(g^2)
        chiS[gi] = (c1 * c1 + c2) % p * inv2 % p
        chiM[gi] = c1
        chiA[gi] = sum(Arep[gi][i][i] for i in range(5)) % p
        chiAd[gi] = sum(Arep[inv_idx[gi]][i][i] for i in range(5)) % p

    def ip(f, g):
        return sum(f[gi] * g[gi] for gi in reps) % p * inv660 % p

    one = {gi: 1 for gi in reps}
    chiMd = {gi: sum(Mrep[inv_idx[gi]][i][i] for i in range(10)) % p for gi in reps}
    m_triv = ip(chiS, one)
    m_A = ip(chiS, chiAd)          # multiplicity of A          (chi_A(g^-1))
    m_Ad = ip(chiS, chiA)          # multiplicity of A^dual
    m_M = ip(chiS, chiMd)          # multiplicity of M = 10'
    self_ip = ip(chiS, chiS)
    dim = chiS[0]
    ok = (m_triv == 1 and m_A == 1 and m_Ad == 1 and m_M == 2
          and self_ip == 9 % p and dim == 55 % p)
    note("sym2char_" + tag, ok,
         "Sym^2(10'): dim %d, mult(1)=%d, mult(5)=%d, mult(5bar)=%d, mult(10')=%d, "
         "<chi,chi>=%d  =>  1 + 5 + 5bar + 10' + 10' + 12 + 12' (55), NOT the "
         "session's 1+5+10+10' (26)" % (dim, m_triv, m_A, m_Ad, m_M, self_ip))
    return ok


# ---------------------------------------------------------------- check 5
def average_quadratic(mod, k0, i0, j0, dual=False):
    """Average the seed covariant y -> (y_i0 y_j0) e_k0 over G, into A or A^dual."""
    p, Mrep, Arep, inv_idx, reps = mod['p'], mod['Mrep'], mod['Arep'], mod['inv_idx'], mod['reps']
    acc = [[[0] * 10 for _ in range(10)] for _ in range(5)]
    for gi in reps:
        N = Mrep[inv_idx[gi]]
        if dual:
            B = Arep[inv_idx[gi]]
            col = [B[k0][k] for k in range(5)]      # (rho_A(g^-1)^T)[k][k0]
        else:
            col = [Arep[gi][k][k0] for k in range(5)]
        if not any(col):
            continue
        Ni, Nj = N[i0], N[j0]
        if i0 == j0:
            out = [[Ni[a] * Ni[b] % p for b in range(10)] for a in range(10)]
        else:
            out = [[(Ni[a] * Nj[b] + Nj[a] * Ni[b]) % p for b in range(10)] for a in range(10)]
        for k in range(5):
            cc = col[k]
            if not cc:
                continue
            A = acc[k]
            for a in range(10):
                ra, oa = A[a], out[a]
                for b in range(10):
                    if oa[b]:
                        ra[b] = (ra[b] + cc * oa[b]) % p
    return acc


def average_cubic(mod, seed, dual):
    """Average a monomial cubic form on A (dual=False) or on A^dual (dual=True)."""
    p, Arep, inv_idx, reps = mod['p'], mod['Arep'], mod['inv_idx'], mod['reps']
    acc = [[[0] * 5 for _ in range(5)] for _ in range(5)]
    monos = set(permutations(seed))
    for gi in reps:
        if dual:
            A = Arep[gi]
            N = [[A[j][i] for j in range(5)] for i in range(5)]     # rho_A(g)^T
        else:
            N = Arep[inv_idx[gi]]                                   # rho_A(g)^-1
        for (x, y, z) in monos:
            Nx, Ny, Nz = N[x], N[y], N[z]
            for i in range(5):
                if not Nx[i]:
                    continue
                ai = acc[i]
                for j in range(5):
                    if not Ny[j]:
                        continue
                    t = Nx[i] * Ny[j] % p
                    aij = ai[j]
                    for k in range(5):
                        if Nz[k]:
                            aij[k] = (aij[k] + t * Nz[k]) % p
    return acc


def eval_cubic(C, z, p):
    return sum(C[i][j][k] * z[i] * z[j] * z[k]
               for i in range(5) for j in range(5) for k in range(5)) % p


def invariant_cubic(mod, dual):
    for seed in ((0, 0, 0), (0, 0, 1), (0, 1, 2), (1, 2, 3), (2, 3, 4), (0, 0, 2),
                 (1, 1, 1), (3, 4, 4), (0, 2, 4)):
        C = average_cubic(mod, seed, dual)
        if any(any(any(r) for r in C[i]) for i in range(5)):
            return C
    return None


def sym3_trivial_mult(mod, dual):
    """<chi_{Sym^3 V}, 1> for V = A^dual (dual=False: cubics on A) or V = A."""
    p, Arep, inv_idx, reps = mod['p'], mod['Arep'], mod['inv_idx'], mod['reps']
    inv6, inv660 = pow(6, p - 2, p), pow(660 % p, p - 2, p)
    s = 0
    for gi in reps:
        R = Arep[inv_idx[gi]] if not dual else tuple(zip(*Arep[gi]))
        R2 = mmul(R, R, p)
        R3 = mmul(R2, R, p)
        c1 = sum(R[i][i] for i in range(5)) % p
        c2 = sum(R2[i][i] for i in range(5)) % p
        c3 = sum(R3[i][i] for i in range(5)) % p
        s += (c1 ** 3 + 3 * c1 * c2 + 2 * c3) * inv6
    return s % p * inv660 % p


def klein_pfaffian(mod):
    """Pf of the 6x6 skew matrix attached to a in A (seal.py conventions)."""
    p, ANN = mod['p'], mod['ANN']
    CM = [[[0] * 5 for _ in range(6)] for _ in range(6)]
    for u in range(6):
        for v in range(6):
            if u == v:
                continue
            K = tuple(sorted(set(range(6)) - {u, v}))
            sg = perm_sign(list(K) + ([u, v] if u < v else [v, u])) * (1 if u < v else -1)
            Ki = QIDX[K]
            for j in range(5):
                CM[u][v][j] = (sg * ANN[j][Ki]) % p

    def pf(a):
        A = [[sum(CM[u][v][j] * a[j] for j in range(5)) % p for v in range(6)]
             for u in range(6)]

        def rec(idx):
            if not idx:
                return 1
            i0, s, sgn = idx[0], 0, 1
            for j in idx[1:]:
                rest = [x for x in idx[1:] if x != j]
                s = (s + sgn * A[i0][j] * rec(rest)) % p
                sgn = -sgn
            return s % p
        return rec(list(range(6)))
    return pf


def check_invcubic(mod, tag):
    p = mod['p']
    mA, mAd = sym3_trivial_mult(mod, False), sym3_trivial_mult(mod, True)
    CA, CAd = invariant_cubic(mod, False), invariant_cubic(mod, True)
    pf = klein_pfaffian(mod)
    rng = random.Random(31)
    lam, prop, nonz = None, True, 0
    for _ in range(25):
        a = [rng.randrange(p) for _ in range(5)]
        v1, v2 = pf(a), eval_cubic(CA, a, p)
        if v2:
            nonz += 1
            r = v1 * pow(v2, p - 2, p) % p
            if lam is None:
                lam = r
            elif r != lam:
                prop = False
        elif v1:
            prop = False
    ok = (mA == 1 and mAd == 1 and CA is not None and CAd is not None
          and prop and lam not in (None, 0) and nonz >= 15)
    note("invcubic_" + tag, ok,
         "trivial multiplicity in Sym^3(A) = %d and in Sym^3(A^dual) = %d (a unique "
         "G-invariant cubic on each 5-space); the invariant cubic on A equals %d * Pf6 "
         "on %d/25 random points (sealed Klein identification X = {Pf=0})"
         % (mA, mAd, lam if lam is not None else -1, nonz))
    return ok, CA, CAd


def eval_quad(Q, y, p):
    out = []
    for k in range(5):
        s = 0
        for a in range(10):
            if y[a]:
                ra = Q[k][a]
                s += y[a] * sum(ra[b] * y[b] for b in range(10) if y[b])
        out.append(s % p)
    return tuple(out)


def check_quadcov(mod, tag, coords, dual, label, cubic):
    p, genM, genA = mod['p'], mod['genM'], mod['genA']
    rng = random.Random(7 + (1 if dual else 0))
    # The averaging projector onto Hom_G(Sym^2 M, A) has rank 1, so a coordinate
    # seed survives only when the covariant has a nonzero matching coefficient;
    # the covariant is sparse, so sweep seeds until three survivors are found.
    seeds = [(k, i, j) for k in range(5) for i in range(10) for j in range(i, 10)]
    rng.shuffle(seeds)
    Q = None
    used = None
    found = []
    for s in seeds[:40]:
        cand = average_quadratic(mod, s[0], s[1], s[2], dual=dual)
        if any(any(any(r) for r in cand[k]) for k in range(5)):
            found.append((s, cand))
            if Q is None:
                Q, used = cand, s
        if len(found) >= 3:
            break
    if Q is None:
        note("quadcov_%s_%s" % (label, tag), False,
             "the averaging projector killed every seed -- no quadratic covariant found")
        return False
    # proportionality of the independent averages  (=> dim Hom_G = 1 on the nose)
    prop = True
    k0 = next((k, a, b) for k in range(5) for a in range(10) for b in range(10) if Q[k][a][b])
    base = Q[k0[0]][k0[1]][k0[2]]
    for s, cand in found[1:]:
        lam = cand[k0[0]][k0[1]][k0[2]] * pow(base, p - 2, p) % p
        if any(cand[k][a][b] != lam * Q[k][a][b] % p
               for k in range(5) for a in range(10) for b in range(10)):
            prop = False
    # equivariance on the two generators
    equiv = True
    for gi, (gM, gA) in enumerate(zip(genM, genA)):
        if dual:
            gA = tuple(zip(*inv_matrix(gA, p)))          # rho_{A^dual}(g)
        for _ in range(4):
            y = tuple(rng.randrange(p) for _ in range(10))
            gy = matvec(gM, y, p)
            lhs = eval_quad(Q, gy, p)
            rhs = matvec(gA, eval_quad(Q, y, p), p)
            if lhs != rhs:
                equiv = False
    vanish = sum(1 for y in coords if all(x == 0 for x in eval_quad(Q, y, p)))
    nonzero_off = sum(1 for _ in range(20)
                      if any(eval_quad(Q, tuple(rng.randrange(p) for _ in range(10)), p)))
    base_ok = prop and equiv and nonzero_off == 20
    if not dual:
        ok = base_ok and vanish == len(coords)
        note("quadcov_%s_%s" % (label, tag), ok,
             "q: Sym^2(M) -> %s nonzero (seed %s), %d independent averages proportional "
             "(%s), generator-equivariant (%s), nonzero at %d/20 random points of P(M); "
             "q VANISHES at %d/%d sampled V14 points => no degree-2 covariant map "
             "V14 --> P(A)" % (label, used, len(found), prop, equiv, nonzero_off,
                               vanish, len(coords)))
    else:
        offcubic = sum(1 for y in coords
                       if any(eval_quad(Q, y, p))
                       and eval_cubic(cubic, eval_quad(Q, y, p), p) != 0)
        ok = base_ok and vanish == 0 and offcubic == len(coords)
        note("quadcov_%s_%s" % (label, tag), ok,
             "q: Sym^2(M) -> %s nonzero (seed %s), %d independent averages proportional "
             "(%s), generator-equivariant (%s), nonzero at %d/20 random points of P(M); "
             "q does NOT vanish on V14 (%d/%d points nonzero) but the unique invariant "
             "cubic of P(A^dual) is nonzero at %d/%d image points => the degree-2 map "
             "V14 --> P(A^dual) misses the conjugate Klein cubic"
             % (label, used, len(found), prop, equiv, nonzero_off,
                len(coords) - vanish, len(coords), offcubic, len(coords)))
    return ok


# ---------------------------------------------------------------- check 6
def check_secant(p, tag):
    """Theorem B step 5: the residual point of a conjugate secant pair on a cubic."""
    sq = {}
    for t in range(p):
        sq.setdefault(t * t % p, t)
    n = next(t for t in range(2, p) if t not in sq)          # a non-residue
    inv2, inv3 = pow(2, p - 2, p), pow(3, p - 2, p)

    def add(x, y):
        return ((x[0] + y[0]) % p, (x[1] + y[1]) % p)

    def sub(x, y):
        return ((x[0] - y[0]) % p, (x[1] - y[1]) % p)

    def mul(x, y):
        return ((x[0] * y[0] + n * x[1] * y[1]) % p, (x[0] * y[1] + x[1] * y[0]) % p)

    def smul(c, x):
        return ((c * x[0]) % p, (c * x[1]) % p)

    def conj(x):
        return (x[0], (-x[1]) % p)

    def inv(x):
        nn = (x[0] * x[0] - n * x[1] * x[1]) % p
        i = pow(nn, p - 2, p)
        return ((x[0] * i) % p, (-x[1] * i) % p)

    def isz(x):
        return x[0] % p == 0 and x[1] % p == 0

    def sqrt2(z):
        c, d = z[0] % p, z[1] % p
        if d == 0:
            if c == 0:
                return (0, 0)
            if c in sq:
                return (sq[c], 0)
            e = c * pow(n, p - 2, p) % p
            return (0, sq[e]) if e in sq else None
        N = (c * c - n * d * d) % p
        if N not in sq:
            return None
        s = sq[N]
        for sg in (s, (-s) % p):
            u2 = (c + sg) * inv2 % p
            if u2 and u2 in sq:
                u = sq[u2]
                v = d * pow(2 * u % p, p - 2, p) % p
                if mul((u, v), (u, v)) == (c, d):
                    return (u, v)
        return None

    def F(z):
        s = (0, 0)
        for i in range(5):
            s = add(s, mul(mul(z[i], z[i]), z[(i + 1) % 5]))
        return s

    def B(x, y, w):
        s = (0, 0)
        for i in range(5):
            j = (i + 1) % 5
            s = add(s, mul(mul(x[i], y[i]), w[j]))
            s = add(s, mul(mul(x[i], y[j]), w[i]))
            s = add(s, mul(mul(x[j], y[i]), w[i]))
        return smul(inv3, s)

    rng = random.Random(11)
    tested, degenerate, fails = 0, 0, []
    for _ in range(4000):
        if tested >= 12:
            break
        xs = [(rng.randrange(p), rng.randrange(p)) for _ in range(4)]
        x1, x2, x3, x4 = xs
        A2 = x1
        A1 = mul(x4, x4)
        A0 = add(add(mul(mul(x1, x1), x2), mul(mul(x2, x2), x3)), mul(mul(x3, x3), x4))
        if isz(A2):
            continue
        disc = sub(mul(A1, A1), smul(4, mul(A2, A0)))
        r = sqrt2(disc)
        if r is None:
            continue
        x0 = mul(sub(r, A1), inv(smul(2, A2)))
        x = [x0, x1, x2, x3, x4]
        if not isz(F(x)):
            fails.append("point not on cubic")
            continue
        y = [conj(z) for z in x]
        if not isz(F(y)):
            fails.append("conjugate not on cubic")
            continue
        # x must not be an F_p-point projectively
        if all(isz(sub(mul(x[i], y[j]), mul(x[j], y[i]))) for i in range(5) for j in range(5)):
            continue
        a, b = B(x, x, y), B(x, y, y)
        if not (b == conj(a)):
            fails.append("b != a^iota")
            continue
        if isz(a) and isz(b):
            degenerate += 1
            continue
        # F(s x + u y) = 3 s u (a s + b u) at six distinct ratios (s:u): a binary
        # cubic vanishing at 6 > 3 points of P^1 is identically zero.
        idok = True
        for (s_, u_) in ((1, 0), (0, 1), (1, 1), (1, 2), (1, 3), (2, 1)):
            z = [add(smul(s_, x[i]), smul(u_, y[i])) for i in range(5)]
            lhs = F(z)
            rhs = smul(3 * s_ * u_ % p, add(smul(s_, a), smul(u_, b)))
            if lhs != rhs:
                idok = False
        if not idok:
            fails.append("secant identity F(sx+uy) = 3su(as+bu) failed")
            continue
        rr = [sub(mul(b, x[i]), mul(a, y[i])) for i in range(5)]
        if all(isz(z) for z in rr):
            fails.append("residual point is zero")
            continue
        if not isz(F(rr)):
            fails.append("residual point not on the cubic")
            continue
        if [conj(z) for z in rr] != [smul(p - 1, z) for z in rr]:
            fails.append("residual point not iota-anti-invariant")
            continue
        if any(z[0] % p for z in rr):
            fails.append("residual point has a nonzero real part")
            continue
        rp = [z[1] % p for z in rr]                     # rr = sqrt(n) * rp, rp over F_p
        if sum(rp[i] * rp[i] % p * rp[(i + 1) % 5] for i in range(5)) % p:
            fails.append("descended F_p point not on the cubic")
            continue
        tested += 1
    note("secant_" + tag, tested >= 10 and not fails,
         "%d conjugate pairs x, x^iota on the cyclic Klein cubic over F_{p^2}: "
         "F(sx+ux^iota) = 3su(as+bu) exactly, r = b.x - a.x^iota is nonzero, "
         "iota-anti-invariant (hence F_p-rational) and lies on the cubic; "
         "%d degenerate samples skipped; failures %s" % (tested, degenerate, fails[:3]))
    return tested >= 10 and not fails


# ---------------------------------------------------------------- check 7
def check_no_invariant(mod, tag):
    p, Arep, Mrep, reps = mod['p'], mod['Arep'], mod['Mrep'], mod['reps']
    accA = [[0] * 5 for _ in range(5)]
    accM = [[0] * 10 for _ in range(10)]
    for gi in reps:
        A, M = Arep[gi], Mrep[gi]
        for i in range(5):
            for j in range(5):
                accA[i][j] = (accA[i][j] + A[i][j]) % p
        for i in range(10):
            for j in range(10):
                accM[i][j] = (accM[i][j] + M[i][j]) % p
    rA, rM = rank(accA, p), rank(accM, p)
    note("noinvariant_" + tag, rA == 0 and rM == 0,
         "rank of the averaging projector onto A^G = %d and onto M^G = %d; G is simple "
         "so a fixed point of P(A) needs an invariant vector: X^G = P(A)^G = empty" % (rA, rM))
    return rA == 0 and rM == 0


# ---------------------------------------------------------------- check 8
def check_pins():
    ok = True
    for s in ("FIX-IX-SEAL-PASS", "FIX-A0-ARRANGEMENT-PASS"):
        r = subprocess.run(["grep", "-rl", "--include=*.md", "--include=*.json",
                            "--include=*.log", "--include=*.py", s, PROBLEM_ROOT],
                           capture_output=True, text=True)
        hits = [h for h in r.stdout.split() if h and not h.startswith(HERE)]
        note("pin_exit_" + s, bool(hits),
             "%d file(s) outside this packet carry the exit string, e.g. %s"
             % (len(hits), os.path.relpath(hits[0], PROBLEM_ROOT) if hits else "-"))
        ok = ok and bool(hits)
    for doc in ("tschinkel_zhang_stable_equivariant_arxiv2409.08392.pdf",
                "duncan_reichstein_versality_arxiv1109.6093.pdf"):
        path = os.path.join(PROBLEM_ROOT, "external_docs", doc)
        exists = os.path.isfile(path)
        note("pin_doc_" + doc.split('_')[0], exists,
             "external_docs/%s %s" % (doc, "present (%d bytes)" % os.path.getsize(path)
                                      if exists else "MISSING"))
        ok = ok and exists
    return ok


# ---------------------------------------------------------------- driver
def run_prime(p):
    tag = str(p)
    print("--- prime %d ---" % p)
    mod = build_model(p)
    if not check_model(mod, tag):
        return False
    pts = v14_points(mod, 60)
    coords = check_v14_points(mod, tag, pts)
    ok = True
    ok &= check_hom1(mod, tag)
    ok &= check_sym2(mod, tag)
    okc, CA, CAd = check_invcubic(mod, tag)
    ok &= okc
    ok &= check_quadcov(mod, tag, coords, False, "A", CA)
    ok &= check_quadcov(mod, tag, coords, True, "Adual", CAd)
    ok &= check_secant(p, tag)
    ok &= check_no_invariant(mod, tag)
    return ok


def main():
    primes = [int(a) for a in sys.argv[1:]] or [397, 199]
    ok = True
    for p in primes:
        ok &= run_prime(p)
    print("--- repository pins ---")
    ok &= check_pins()
    verdict = ("V14MAP-DICHOTOMY-VERIFIER: ALLGREEN" if ok and all(o for _, o, _ in LOG)
               else "V14MAP-DICHOTOMY-VERIFIER: %d FAILURES"
                    % sum(1 for _, o, _ in LOG if not o))
    print(verdict)
    os.makedirs(RESULTS, exist_ok=True)
    with open(os.path.join(RESULTS, "checks.log"), "w") as f:
        f.write("# verifier.py %s   (primes %s)\n"
                % (os.path.basename(__file__), " ".join(map(str, primes))))
        for name, o, detail in LOG:
            f.write("CHECK %s %s %s\n" % (name, "PASS" if o else "FAIL", detail))
        f.write(verdict + "\n")
    return 0 if ok and all(o for _, o, _ in LOG) else 1


if __name__ == "__main__":
    sys.exit(main())
