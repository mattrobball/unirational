#!/usr/bin/env python3
# FIX-IX-SEAL: director-run seal of Cor IX.1 hypotheses on the V14.
# Modes: 397 | 199 | 353 (F_p, p = 1 mod 11) | K (exact char 0, Q(z)/Phi11).
# Layer 1 (this file): the 6-dim even Weil rep of SL(2,11) (S^2 = -I,
# c = 1/gauss), 1320-closure, 10'-summand M of Lambda^2 U (column space of
# the isotypic projector), sigma eigenpieces (6/4), C_G(sigma) = D12,
# D12 character pieces, Ann(M) in Lambda^4 U, the dual-side smoothness
# system J (Pfaffian + adjoint-bivector conditions), quadric restrictions.
# Writes Macaulay2 inputs for layer 2 and a checks log.
import sys, os
from fractions import Fraction
from itertools import combinations

MODE = sys.argv[1]
OUT = os.path.join(os.path.dirname(os.path.abspath(__file__)), '..')

# ---------- field layer ----------
if MODE == 'K':
    def nf(c): return tuple(c)
    ZERO = nf([Fraction(0)]*10); ONE = nf([Fraction(1)]+[Fraction(0)]*9)
    def fadd(a,b): return nf([x+y for x,y in zip(a,b)])
    def fsub(a,b): return nf([x-y for x,y in zip(a,b)])
    def fneg(a): return nf([-x for x in a])
    def fmul(a,b):
        c = [Fraction(0)]*19
        for i,x in enumerate(a):
            if x:
                for j,y in enumerate(b):
                    if y: c[i+j] += x*y
        for k in range(18,9,-1):
            if c[k]:
                v = c[k]; c[k] = Fraction(0)
                for t in range(k-10,k): c[t] -= v
        return nf(c[:10])
    def fisz(a): return all(x == 0 for x in a)
    def finv(a):
        phi = [Fraction(1)]*11
        def deg(P):
            d = len(P)-1
            while d >= 0 and P[d] == 0: d -= 1
            return d
        def pmul(P,Q):
            R = [Fraction(0)]*(len(P)+len(Q)-1)
            for i,x in enumerate(P):
                if x:
                    for j,y in enumerate(Q):
                        if y: R[i+j] += x*y
            return R
        def psub(P,Q):
            n = max(len(P),len(Q)); R = [Fraction(0)]*n
            for i,x in enumerate(P): R[i] += x
            for i,y in enumerate(Q): R[i] -= y
            return R
        r0, r1 = phi[:], list(a)
        s0, s1 = [Fraction(0)], [Fraction(1)]
        while deg(r1) >= 0:
            d0, d1 = deg(r0), deg(r1)
            if d0 < d1:
                r0, r1, s0, s1 = r1, r0, s1, s0; continue
            q = [Fraction(0)]*(d0-d1) + [r0[d0]/r1[d1]]
            r0 = psub(r0, pmul(q, r1)); s0 = psub(s0, pmul(q, s1))
            if deg(r0) < deg(r1):
                r0, r1, s0, s1 = r1, r0, s1, s0
        c0 = r0[deg(r0)]
        inv = [x/c0 for x in s0] + [Fraction(0)]*11
        # reduce mod phi (deg of s0 is <= 9 in the Bezout identity, safe)
        red = [Fraction(0)]*19
        for i,x in enumerate(inv[:19]): red[i] = x
        for k in range(18,9,-1):
            if red[k]:
                v = red[k]; red[k] = Fraction(0)
                for t in range(k-10,k): red[t] -= v
        return nf(red[:10])
    Z = nf([Fraction(0),Fraction(1)]+[Fraction(0)]*8)
    def zpow(k):
        k = k % 11; r = ONE
        for _ in range(k): r = fmul(r, Z)
        return r
    def fint(n): return nf([Fraction(n)]+[Fraction(0)]*9)
    def fstr(a):
        terms = []
        for i,x in enumerate(a):
            if x: terms.append(f"({x.numerator}/{x.denominator})" + ("" if i==0 else f"*z^{i}"))
        return "+".join(terms) if terms else "0"
    # shadow: z -> g11 mod 397 for fast projective orders
    ps = 397
    g11s = next(t for t in range(2,ps) if pow(t,11,ps) == 1 and t != 1)
    def shadow(a):
        s = 0
        for i,x in enumerate(a):
            if x: s = (s + x.numerator % ps * pow(x.denominator % ps, ps-2, ps) * pow(g11s, i, ps)) % ps
        return s
else:
    p = int(MODE)
    assert p % 11 == 1
    ZERO, ONE = 0, 1
    def fadd(a,b): return (a+b) % p
    def fsub(a,b): return (a-b) % p
    def fneg(a): return (-a) % p
    def fmul(a,b): return (a*b) % p
    def fisz(a): return a % p == 0
    def finv(a): return pow(a, p-2, p)
    g11 = next(t for t in range(2,p) if pow(t,11,p) == 1 and t != 1)
    def zpow(k): return pow(g11, k % 11, p)
    def fint(n): return n % p
    def fstr(a): return str(a % p)

def frac(n, d=1):
    return fmul(fint(n), finv(fint(d)))

# ---------- matrices ----------
def mmul(A,B):
    n = len(A)
    Bt = list(zip(*B))
    return tuple(tuple(_dot(A[i], Bt[j]) for j in range(n)) for i in range(n))
def _dot(r, c):
    s = ZERO
    for x,y in zip(r,c):
        if not fisz(x) and not fisz(y): s = fadd(s, fmul(x,y))
    return s
def meye(n=6):
    return tuple(tuple(ONE if i==j else ZERO for j in range(n)) for i in range(n))
def mneg(A): return tuple(tuple(fneg(x) for x in r) for r in A)

ck = []
def CHECK(name, ok, detail):
    ck.append((name, bool(ok), detail))

# ---------- Weil generators, closure ----------
gauss = ZERO
for k in range(11): gauss = fadd(gauss, zpow(k*k))
CHECK("gauss_sq_m11", fisz(fadd(fmul(gauss,gauss), fint(11))), "gauss^2 = -11")
c = finv(gauss)
T6 = tuple(tuple((zpow(j*j) if i==j else ZERO) for j in range(6)) for i in range(6))
def cosentry(i,j):
    if j == 0: return c
    return fmul(c, fadd(zpow(i*j), zpow(-i*j)))
S6 = tuple(tuple(cosentry(i,j) for j in range(6)) for i in range(6))
CHECK("S_sq_minusI", mmul(S6,S6) == mneg(meye()), "S^2 = -I")

if MODE == 'K':
    T6s = tuple(tuple(shadow(x) for x in r) for r in T6)
    S6s = tuple(tuple(shadow(x) for x in r) for r in S6)
    def smul(A,B):
        return tuple(tuple(sum(A[i][k]*B[k][j] for k in range(6)) % ps for j in range(6)) for i in range(6))
    seen = {meye(): meye()}   # K-matrix -> shadow
    sh = {meye(): tuple(tuple((1 if i==j else 0) for j in range(6)) for i in range(6))}
    frontier = [meye()]
    while frontier:
        nxt = []
        for M in frontier:
            for gK, gS in ((T6, T6s), (S6, S6s)):
                N = mmul(M, gK)
                if N not in sh:
                    sh[N] = smul(sh[M], gS); nxt.append(N)
        frontier = nxt
        assert len(sh) <= 1400
    GRP = list(sh.keys())
    def is_scalar_s(A):
        d = A[0][0]
        if d == 0: return False
        return all(A[i][j] == (d if i==j else 0) for i in range(6) for j in range(6))
    def proj_order(M):
        A = sh[M]; B = A; k = 1
        while k <= 13:
            if is_scalar_s(B): return k
            B = smul(B, A); k += 1
        return 99
else:
    seen = {meye(): True}; frontier = [meye()]
    while frontier:
        nxt = []
        for M in frontier:
            for ggen in (T6, S6):
                N = mmul(M, ggen)
                if N not in seen:
                    seen[N] = True; nxt.append(N)
        frontier = nxt
        assert len(seen) <= 1400
    GRP = list(seen.keys())
    def is_scalar(A):
        d = A[0][0]
        if fisz(d): return False
        for i in range(6):
            for j in range(6):
                if i == j:
                    if not fisz(fsub(A[i][j], d)): return False
                elif not fisz(A[i][j]): return False
        return True
    PORD = {}
    def proj_order(M):
        if M in PORD: return PORD[M]
        A = M; k = 1
        while k <= 13:
            if is_scalar(A): PORD[M] = k; return k
            A = mmul(A, M); k += 1
        PORD[M] = 99; return 99

CHECK("group_order_SL", len(GRP) == 1320, f"|<T,S>| = {len(GRP)}")

pairs = list(combinations(range(6), 2))       # Lambda^2 basis, lex
quads_idx = list(combinations(range(6), 4))   # Lambda^4 basis, lex
def lam2(M):
    return tuple(tuple(
        fsub(fmul(M[i][k], M[j][l]), fmul(M[i][l], M[j][k]))
        for (k,l) in pairs) for (i,j) in pairs)
def perm_sign(P):
    s = 1; P = list(P)
    for i in range(len(P)):
        for j in range(i+1, len(P)):
            if P[i] > P[j]: s = -s
    return s
def lam4(M):
    # 4-th compound: minors on 4-subsets
    R = []
    for K in quads_idx:
        row = []
        for L in quads_idx:
            # det of submatrix M[K][L]
            sub = [[M[K[i]][L[j]] for j in range(4)] for i in range(4)]
            # 4x4 det by expansion
            d = ZERO
            import itertools as _it
            for pi in _it.permutations(range(4)):
                t = ONE
                for i in range(4): t = fmul(t, sub[i][pi[i]])
                d = fadd(d, t) if perm_sign(pi) > 0 else fsub(d, t)
            row.append(d)
        R.append(tuple(row))
    return tuple(R)

# ---------- 10'-projector, M = column space ----------
CHIV = {1:frac(10), 2:frac(2), 3:frac(1), 5:ZERO, 6:frac(-1), 11:frac(-1)}
PM = [[ZERO]*15 for _ in range(15)]
ords = {}
for M in GRP:
    po = proj_order(M); ords[po] = ords.get(po, 0) + 1
    w = CHIV[po]
    if fisz(w): continue
    L2 = lam2(M)
    for i in range(15):
        Li = L2[i]
        for j in range(15):
            if not fisz(Li[j]): PM[i][j] = fadd(PM[i][j], fmul(w, Li[j]))
scale = fmul(frac(10), finv(frac(1320)))
PM = [[fmul(scale, x) for x in row] for row in PM]
CHECK("SL_order_profile", ords == {1:2, 2:110, 3:220, 5:528, 6:220, 11:240},
      f"proj-order counts {sorted(ords.items())}")

def echelon(rows):
    R = [list(r) for r in rows]; piv = []
    rr = 0
    ncol = len(R[0]) if R else 0
    for cidx in range(ncol):
        pr = next((r for r in range(rr, len(R)) if not fisz(R[r][cidx])), None)
        if pr is None: continue
        R[rr], R[pr] = R[pr], R[rr]
        iv = finv(R[rr][cidx])
        R[rr] = [fmul(iv, x) for x in R[rr]]
        for r in range(len(R)):
            if r != rr and not fisz(R[r][cidx]):
                fct = R[r][cidx]
                R[r] = [fsub(x, fmul(fct, y)) for x, y in zip(R[r], R[rr])]
        piv.append(cidx); rr += 1
        if rr == len(R): break
    return [tuple(r) for r in R[:rr]], piv
def kernel_of(rows, nvar):
    # kernel of the linear map v -> (rows . v), v in k^nvar; rows are length-nvar
    E, piv = echelon(rows)
    free = [i for i in range(nvar) if i not in piv]
    ker = []
    for f in free:
        v = [ZERO]*nvar; v[f] = ONE
        for r, pc in zip(E, piv):
            v[pc] = fneg(r[f])
        ker.append(tuple(v))
    return ker

# columns of PM span M
MB, _ = echelon([tuple(PM[i][j] for i in range(15)) for j in range(15)])
CHECK("M_rank10", len(MB) == 10, f"rank 10' projector = {len(MB)}")
# projector property on columns: PM * m = m for m in MB
okp = all(tuple(_dot(PM[i], list(m)) for i in range(15)) == m for m in MB[:3])
CHECK("PM_idempotent_on_M", okp, "PM fixes its column space")

# ---------- Ann(M) in Lambda^4 ----------
def pair24(K, a):
    # <e_K, e_a> = sign(e_K ^ e_a = eps e_{0..5}), K 4-set, a 2-set
    if set(K) & set(a): return 0
    return perm_sign(list(K) + list(a))
annrows = []
for m in MB:
    row = []
    for Ki, K in enumerate(quads_idx):
        s = ZERO
        for ai, a in enumerate(pairs):
            sg = pair24(K, a)
            if sg and not fisz(m[ai]):
                s = fadd(s, m[ai]) if sg > 0 else fsub(s, m[ai])
        row.append(s)
    annrows.append(tuple(row))
ANN = kernel_of(annrows, 15)
CHECK("annM_dim5", len(ANN) == 5, f"dim Ann(M) in Lambda^4 = {len(ANN)}")

# ---------- sigma, eigenpieces, centralizer ----------
sig = next(M for M in GRP if mmul(M, M) == mneg(meye()))
L2s = lam2(sig)
def eigpiece(sign):
    rows = []
    for m in MB:
        im = tuple(_dot(L2s[i], list(m)) for i in range(15))
        rows.append(tuple(fsub(im[j], m[j]) if sign > 0 else fadd(im[j], m[j]) for j in range(15)))
    RT = [tuple(rows[i][j] for i in range(10)) for j in range(15)]  # 15 x 10, unknowns = coeffs in MB
    ker = kernel_of(RT, 10)
    vecs = []
    for cvec in ker:
        w = [ZERO]*15
        for ci, m in zip(cvec, MB):
            if not fisz(ci):
                for j in range(15): w[j] = fadd(w[j], fmul(ci, m[j]))
        vecs.append(tuple(w))
    V, _ = echelon(vecs) if vecs else ([], [])
    return V
Mplus = eigpiece(+1); Mminus = eigpiece(-1)
CHECK("sigma_split_6_4", (len(Mplus), len(Mminus)) == (6, 4),
      f"dims (M+, M-) = {(len(Mplus), len(Mminus))}")

cent = []          # projective centralizer reps
centkeys = set()
for M in GRP:
    Ms, sM = mmul(M, sig), mmul(sig, M)
    if Ms == sM or Ms == mneg(sM):
        key = min(M, mneg(M))
        if key not in centkeys:
            centkeys.add(key); cent.append(M)
CHECK("centralizer_order12", len(cent) == 12, f"|C_G(sigma)| = {len(cent)}")
ninv = sum(1 for M in cent if proj_order(M) == 2)
CHECK("centralizer_is_D12", ninv == 7, f"projective involutions in C = {ninv} (D12 has 7)")

# ---------- D12 character pieces ----------
D24 = [M for M in GRP if min(M, mneg(M)) in centkeys]
assert len(D24) == 24
r6 = next(M for M in D24 if proj_order(M) == 6)
rotkeys = set()
A = meye()
for k in range(6):
    A = mmul(A, r6); rotkeys.add(min(A, mneg(A)))
s0 = next(N for N in D24 if proj_order(N) == 2 and min(N, mneg(N)) not in rotkeys)
# s0 projective inverse: s0^2 = +-I so s0 works as its own projective inverse
def char_val(M, cr, cs):
    key = min(M, mneg(M))
    if key in rotkeys:
        return 1 if proj_order(M) in (1, 3) else cr
    Ra = mmul(M, s0)
    a_even = proj_order(Ra) in (1, 3)
    return cs if a_even else cr * cs
pieces = {}
for (cr, cs) in [(1,1), (1,-1), (-1,1), (-1,-1)]:
    R = [[ZERO]*15 for _ in range(15)]
    for M in D24:
        cv = char_val(M, cr, cs)
        L2m = lam2(M)
        for i in range(15):
            for j in range(15):
                if not fisz(L2m[i][j]):
                    v = L2m[i][j] if cv > 0 else fneg(L2m[i][j])
                    R[i][j] = fadd(R[i][j], v)
    sc = finv(frac(24))
    R = [[fmul(sc, x) for x in row] for row in R]
    vecs = [tuple(_dot(R[i], list(m)) for i in range(15)) for m in MB]
    V, _ = echelon(vecs)
    pieces[(cr, cs)] = V
pdims = tuple(sorted((len(v) for v in pieces.values()), reverse=True))
CHECK("D12_piece_dims_sum", sum(pdims) >= 3, f"character piece dims {pdims}")

# ---------- quadric restriction m^m = 0 ----------
def wedge22(a, b):
    if set(a) & set(b): return None
    s = tuple(sorted(set(a) | set(b)))
    return (quads_idx.index(s), perm_sign(list(a) + list(b)))
def restrict_quads(B):
    n = len(B)
    Q = [dict() for _ in range(15)]
    for i in range(n):
        for j in range(i, n):
            acc = {}
            for a in range(15):
                if fisz(B[i][a]): continue
                for b in range(15):
                    if fisz(B[j][b]): continue
                    w = wedge22(pairs[a], pairs[b])
                    if w is None: continue
                    K, sgn = w
                    v = fmul(B[i][a], B[j][b])
                    if sgn < 0: v = fneg(v)
                    acc[K] = fadd(acc.get(K, ZERO), v)
            mult = frac(2) if i != j else ONE
            for K, v in acc.items():
                vv = fmul(mult, v)
                if not fisz(vv): Q[K][(i, j)] = vv
    return Q
def m2quads(Q, var):
    out = []
    for K in range(15):
        terms = [f"({fstr(cf)})*{var}{i}*{var}{j}" for (i, j), cf in sorted(Q[K].items())]
        out.append("+".join(terms) if terms else "0")
    return out

# ---------- dual-side smoothness system ----------
# phi = sum a_j ANN_j in Lambda^4;  A_phi[u][v] = phi_{comp{u,v}} * sign(comp,{u,v})
def compsign(u, v):
    K = tuple(sorted(set(range(6)) - {u, v}))
    return K, perm_sign(list(K) + [u, v] if u < v else list(K) + [v, u]) * (1 if u < v else -1)
CM = [[[ZERO]*5 for _ in range(6)] for _ in range(6)]
for u in range(6):
    for v in range(6):
        if u == v: continue
        K, sg = compsign(u, v)
        Ki = quads_idx.index(K)
        for j in range(5):
            val = ANN[j][Ki]
            CM[u][v][j] = val if sg > 0 else fneg(val)
def m2lin(u, v):
    terms = [f"({fstr(CM[u][v][j])})*a{j}" for j in range(5) if not fisz(CM[u][v][j])]
    return "+".join(terms) if terms else "0"

# Pfaffian invariance of the dual cubic (Klein identification leg), F_p only
if MODE != 'K':
    import random
    random.seed(23)
    def Aof(wc):
        A = [[0]*6 for _ in range(6)]
        for u in range(6):
            for v in range(6):
                if u == v: continue
                s = 0
                for j in range(5): s = (s + CM[u][v][j]*wc[j]) % p
                A[u][v] = s
        return A
    def pf6_of(A):
        def pf(idx):
            if not idx: return 1
            i0 = idx[0]; s = 0; sgn = 1
            for j in idx[1:]:
                rest = [x for x in idx[1:] if x != j]
                s = (s + sgn * A[i0][j] * pf(rest)) % p
                sgn = -sgn
            return s % p
        return pf(list(range(6)))
    # coords of Lambda^4(g) phi in ANN basis: ANN[j] has a 1 at its free column
    Eann, pivann = echelon(annrows)
    freecols = [i for i in range(15) if i not in pivann]
    okinv, nonz = True, False
    for gm in (T6, S6, mmul(T6, S6)):
        L4 = lam4(gm)
        for _ in range(8):
            wc = [random.randrange(p) for _ in range(5)]
            phi = [ZERO]*15
            for j in range(5):
                for K in range(15): phi[K] = fadd(phi[K], fmul(fint(wc[j]), ANN[j][K]))
            gphi = tuple(_dot(L4[i], phi) for i in range(15))
            gw = [gphi[fc] for fc in freecols]
            v1, v2 = pf6_of(Aof(wc)), pf6_of(Aof(gw))
            if v1 % p: nonz = True
            if v1 != v2: okinv = False
    CHECK("pf_G_invariant", okinv and nonz, "Pf6(dual) invariant, 3 gens x 8 samples, nonzero")

# ---------- isolated sigma-minus points: fast chart solve ----------
if MODE != 'K':
    sqtab = {}
    for t in range(p): sqtab.setdefault(t*t % p, t)
    Qm = restrict_quads(Mminus)
    def qeval(Q, xs):
        vals = []
        for K in range(15):
            s = 0
            for (i, j), cf in Q[K].items(): s = (s + cf*xs[i]*xs[j]) % p
            vals.append(s)
        return vals
    # pick a quadric with a3^2 term or linear a3 to solve per (chart, a1, a2)
    found = set()
    for chart in range(4):
        for a in range(p):
            for b in range(p):
                xs = [None]*4
                free = [i for i in range(4) if i != chart]
                base = {chart: 1, free[0]: a, free[1]: b}
                t = free[2]
                # collect quadratic in x_t from first nontrivial quadric
                sols = None
                for K in range(15):
                    c2 = Qm[K].get((t, t), 0)
                    c1 = 0; c0 = 0
                    for (i, j), cf in Qm[K].items():
                        if (i, j) == (t, t): continue
                        if i == t or j == t:
                            o = j if i == t else i
                            c1 = (c1 + cf*base.get(o, 0)) % p
                        else:
                            c0 = (c0 + cf*base.get(i, 0)*base.get(j, 0)) % p
                    if c2 == 0 and c1 == 0:
                        if c0 % p: sols = []; break
                        continue
                    if c2 == 0:
                        sols = [(-c0) * pow(c1, p-2, p) % p]; break
                    disc = (c1*c1 - 4*c2*c0) % p
                    if disc not in sqtab: sols = []; break
                    r = sqtab[disc]; i2 = pow(2*c2, p-2, p)
                    sols = list({(-c1 + r) * i2 % p, (-c1 - r) * i2 % p}); break
                if sols is None: sols = list(range(p))
                for s_ in sols:
                    base[t] = s_
                    xs = [base[i] for i in range(4)]
                    if any(xs[i] for i in range(chart)): continue  # normalized: first nonzero = chart
                    if all(v == 0 for v in qeval(Qm, xs)):
                        # normalize projectively
                        k0 = next(i for i in range(4) if xs[i])
                        iv = pow(xs[k0], p-2, p)
                        found.add(tuple(x*iv % p for x in xs))
    CHECK("sigma_minus_pts_count", len(found) in (0, 1, 2), f"F_p-rational pts in V14 cap P(M-): {len(found)}")
    if len(found) == 2:
        def liftpt(xs):
            w = [0]*15
            for ci, m in zip(xs, Mminus):
                for j in range(15): w[j] = (w[j] + ci*m[j]) % p
            return tuple(w)
        F = sorted(found)
        P1, P2 = liftpt(F[0]), liftpt(F[1])
        def proj_eqv(u, v):
            lam_ = None
            for x, y in zip(u, v):
                if (x == 0) != (y == 0): return False
                if x:
                    l2 = x * pow(y, p-2, p) % p
                    if lam_ is None: lam_ = l2
                    elif l2 != lam_: return False
            return True
        def actpt(M, w):
            L2m = lam2(M)
            return tuple(_dot(L2m[i], list(w)) for i in range(15))
        st1 = sum(1 for M in cent if proj_eqv(actpt(M, P1), P1))
        sw = sum(1 for M in cent if proj_eqv(actpt(M, P1), P2))
        CHECK("pts_stab6_swap6", st1 == 6 and sw == 6, f"stab order {st1}, swapping elements {sw}")

# ---------- write M2 ----------
tag = MODE
header = ('kk = toField(QQ[z]/(z^10+z^9+z^8+z^7+z^6+z^5+z^4+z^3+z^2+z+1));\n'
          if MODE == 'K' else f'kk = ZZ/{p};\n')
qp = m2quads(restrict_quads(Mplus), 'x')
qm = m2quads(restrict_quads(Mminus), 'y')
with open(f"{OUT}/scripts/m2_sigma_{tag}.m2", "w") as f:
    f.write(header)
    f.write('Rp = kk[x0,x1,x2,x3,x4,x5];\n')
    f.write('Ip = ideal(' + ",".join(qp) + ');\n')
    f.write('Isat = saturate(Ip, ideal vars Rp);\n')
    f.write('<< "SIGPLUS dim " << dim Isat << " deg " << degree Isat << endl;\n')
    f.write('<< "SIGPLUS hp " << toString hilbertPolynomial(Isat, Projective=>false) << endl;\n')
    if MODE != 'K':
        f.write('<< "SIGPLUS radical " << (Isat == radical Isat) << endl;\n')
        f.write('cmps = primaryDecomposition Isat;\n')
        f.write('<< "SIGPLUS ncomp " << #cmps << endl;\n')
    f.write('Jc = Isat + minors(4, jacobian Isat);\n')
    f.write('<< "SIGPLUS smooth " << (saturate(Jc, ideal vars Rp) == ideal(1_Rp)) << endl;\n')
    f.write('Rm = kk[y0,y1,y2,y3];\n')
    f.write('Im = ideal(' + ",".join(qm) + ');\n')
    f.write('Ims = saturate(Im, ideal vars Rm);\n')
    f.write('<< "SIGMINUS dim " << dim Ims << " deg " << degree Ims << endl;\n')
    if MODE != 'K':
        f.write('<< "SIGMINUS reduced " << (Ims == radical Ims) << endl;\n')
    f.write('Jm = Ims + minors(3, jacobian Ims);\n')
    f.write('<< "SIGMINUS smooth " << (saturate(Jm, ideal vars Rm) == ideal(1_Rm)) << endl;\n')
with open(f"{OUT}/scripts/m2_d12_{tag}.m2", "w") as f:
    f.write(header)
    for nm, key in (("PP", (1,1)), ("PA", (1,-1)), ("AP", (-1,1)), ("AA", (-1,-1))):
        B = pieces[key]
        if not B:
            f.write(f'<< "D12 {nm} dim 0 empty True" << endl;\n')
            continue
        qq = m2quads(restrict_quads(B), 't')
        vs = ",".join(f"t{i}" for i in range(len(B)))
        f.write(f'R{nm} = kk[{vs}];\n')
        f.write(f'I{nm} = ideal(' + ",".join(qq) + ');\n')
        f.write(f'<< "D12 {nm} dim {len(B)} empty " << (saturate(I{nm}, ideal vars R{nm}) == ideal(1_R{nm})) << endl;\n')
with open(f"{OUT}/scripts/m2_smooth_{tag}.m2", "w") as f:
    f.write(header)
    f.write('S = kk[a0,a1,a2,a3,a4];\n')
    rows = ",".join("{" + ",".join(m2lin(u, v) for v in range(6)) + "}" for u in range(6))
    f.write('A = matrix{' + rows + '};\n')
    f.write('pf6 = pfaffians(6, A);\n')
    f.write('<< "PF6 nonzero " << (pf6 != 0) << endl;\n')
    f.write('lv = new MutableHashTable;\n')
    f.write('for u from 0 to 5 do for v from u+1 to 5 do lv#(u,v) = (gens pfaffians(4, submatrix\'(A, {u,v}, {u,v})))_(0,0);\n')
    # bivector lambda in Lambda^2 coords: lambda_{(u,v)} = +- pf4(complement rows/cols)
    # J condition: <lambda, ANN_j> = 0 via pair24; lambda_(a) corresponds to pairs
    for j in range(5):
        terms = []
        for ai, a in enumerate(pairs):
            # coefficient of lambda_a in <lambda, ANN_j>: sum_K ANN_j[K] pair24(K, a)
            s = ZERO
            for Ki, K in enumerate(quads_idx):
                sg = pair24(K, a)
                if sg and not fisz(ANN[j][Ki]):
                    s = fadd(s, ANN[j][Ki]) if sg > 0 else fsub(s, ANN[j][Ki])
            if not fisz(s):
                terms.append(f'({fstr(s)})*lv#({a[0]},{a[1]})')
        f.write(f'q{j} = ' + ("+".join(terms) if terms else "0_S") + ';\n')
    f.write('J = pf6 + ideal(q0,q1,q2,q3,q4);\n')
    f.write('<< "JSYS empty " << (saturate(J, ideal vars S) == ideal(1_S)) << endl;\n')
if MODE != 'K':
    with open(f"{OUT}/scripts/m2_ambient_{tag}.m2", "w") as f:
        f.write(header)
        f.write('R = kk[x0,x1,x2,x3,x4,x5,x6,x7,x8,x9];\n')
        qa = m2quads(restrict_quads(MB), 'x')
        f.write('I = ideal(' + ",".join(qa) + ');\n')
        f.write('<< "AMBIENT dim " << dim I << " deg " << degree I << endl;\n')

with open(f"{OUT}/results/checks_{tag}.log", "w") as f:
    for name, ok, detail in ck:
        f.write(f"CHECK {name}_{tag} {'PASS' if ok else 'FAIL'} {detail}\n")
print(open(f"{OUT}/results/checks_{tag}.log").read())
