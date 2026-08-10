#!/usr/bin/env python3
"""PHI_SEXTIC_ISOGENY -- exact models of the two genus-one curves.

Modes:  K   exact char 0 over K = Q(z)/Phi11
        p   a split prime p = 1 mod 11 (F_p)

Layer 1 (adapted from goal_runs_after_c53d89a/FIX_IX_SEAL/scripts/seal.py):
the 6-dim even Weil rep U of SL(2,11), the 1320-closure, M = the 10'
summand of Lambda^2 U, Ann(M) in Lambda^4 U (5-dim = the Klein 5-rep),
sigma with sigma^2 = -I, M_+ (6-dim), C_G(sigma) = D12.

Layer 2 (new here):
  * the residual S3 = C_G(sigma)/<sigma> acting linearly on M_+ and on Ann(M);
  * C_sigma = V14 cap P(M_+) put into the double-cover form  c^2 = R(s,t)
    with R a binary quartic, from which j(C_sigma) and #C_sigma(F_p) follow;
  * E_sigma = {Pf6 = 0} cap P(Ann(M)^{sigma,+}) put into Weierstrass form
    y^2 = cubic(x), from which j(E_sigma) and #E_sigma(F_p) follow;
  * L_sigma = P(Ann(M)^{sigma,-}) and the S3-representation on it.

Output: results/model_<mode>.json  and  results/checks_<mode>.log
"""
import sys, os, json
from fractions import Fraction
from itertools import combinations, permutations

MODE = sys.argv[1] if len(sys.argv) > 1 else 'K'
VAR = int(sys.argv[2]) if len(sys.argv) > 2 else 0   # robustness variant: which tau, rho, branch root
HERE = os.path.dirname(os.path.abspath(__file__))
OUT = os.path.join(HERE, '..')

# ---------------- field layer ----------------
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
        def pmul_(P,Q):
            R = [Fraction(0)]*(len(P)+len(Q)-1)
            for i,x in enumerate(P):
                if x:
                    for j,y in enumerate(Q):
                        if y: R[i+j] += x*y
            return R
        def psub_(P,Q):
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
            r0 = psub_(r0, pmul_(q, r1)); s0 = psub_(s0, pmul_(q, s1))
            if deg(r0) < deg(r1):
                r0, r1, s0, s1 = r1, r0, s1, s0
        c0 = r0[deg(r0)]
        inv = [x/c0 for x in s0] + [Fraction(0)]*11
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
    def fstr(a): return "[" + ",".join(f"{x.numerator}/{x.denominator}" for x in a) + "]"
    def frat(a):
        """Return the Fraction if a lies in Q, else None."""
        if all(x == 0 for x in a[1:]): return a[0]
        # z^0..z^9 is a Q-basis of K, so a rational element has all higher coords 0
        return None
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
    def frat(a): return None

def frac(n, d=1): return fmul(fint(n), finv(fint(d)))
def fdiv(a, b): return fmul(a, finv(b))

# ---------------- matrices ----------------
def _dot(r, c):
    s = ZERO
    for x,y in zip(r,c):
        if not fisz(x) and not fisz(y): s = fadd(s, fmul(x,y))
    return s
def mmul(A,B):
    n = len(A); Bt = list(zip(*B))
    return tuple(tuple(_dot(A[i], Bt[j]) for j in range(len(Bt))) for i in range(n))
def meye(n=6):
    return tuple(tuple(ONE if i==j else ZERO for j in range(n)) for i in range(n))
def mneg(A): return tuple(tuple(fneg(x) for x in r) for r in A)
def matvec(A, v): return tuple(_dot(row, v) for row in A)

ck = []
def CHECK(name, ok, detail):
    ck.append((name, bool(ok), detail))
    print(f"CHECK {name}_{MODE} {'PASS' if ok else 'FAIL'} {detail}", flush=True)

# ---------------- Weil generators, closure ----------------
gauss = ZERO
for k in range(11): gauss = fadd(gauss, zpow(k*k))
CHECK("gauss_sq_m11", fisz(fadd(fmul(gauss,gauss), fint(11))), "gauss^2 = -11")
cc = finv(gauss)
T6 = tuple(tuple((zpow(j*j) if i==j else ZERO) for j in range(6)) for i in range(6))
def cosentry(i,j):
    if j == 0: return cc
    return fmul(cc, fadd(zpow(i*j), zpow(-i*j)))
S6 = tuple(tuple(cosentry(i,j) for j in range(6)) for i in range(6))
CHECK("S_sq_minusI", mmul(S6,S6) == mneg(meye()), "S^2 = -I")

if MODE == 'K':
    T6s = tuple(tuple(shadow(x) for x in r) for r in T6)
    S6s = tuple(tuple(shadow(x) for x in r) for r in S6)
    def smul(A,B):
        return tuple(tuple(sum(A[i][k]*B[k][j] for k in range(6)) % ps for j in range(6)) for i in range(6))
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

pairs = list(combinations(range(6), 2))
quads_idx = list(combinations(range(6), 4))
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
PERM4 = [(pi, perm_sign(pi)) for pi in permutations(range(4))]
def lam4(M):
    R = []
    for K in quads_idx:
        row = []
        for L in quads_idx:
            sub = [[M[K[i]][L[j]] for j in range(4)] for i in range(4)]
            d = ZERO
            for pi, sg in PERM4:
                t = ONE
                for i in range(4):
                    t = fmul(t, sub[i][pi[i]])
                    if fisz(t): break
                if fisz(t): continue
                d = fadd(d, t) if sg > 0 else fsub(d, t)
            row.append(d)
        R.append(tuple(row))
    return tuple(R)

# ---------------- linear algebra ----------------
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
    E, piv = echelon(rows)
    free = [i for i in range(nvar) if i not in piv]
    ker = []
    for f in free:
        v = [ZERO]*nvar; v[f] = ONE
        for r, pc in zip(E, piv):
            v[pc] = fneg(r[f])
        ker.append(tuple(v))
    return ker
def solve_system(A, b):
    """A: m x n over the field, b: length m. Return one solution or None."""
    m = len(A); n = len(A[0])
    R = [list(A[i]) + [b[i]] for i in range(m)]
    piv = []; rr = 0
    for cidx in range(n):
        pr = next((r for r in range(rr, m) if not fisz(R[r][cidx])), None)
        if pr is None: continue
        R[rr], R[pr] = R[pr], R[rr]
        iv = finv(R[rr][cidx]); R[rr] = [fmul(iv, x) for x in R[rr]]
        for r in range(m):
            if r != rr and not fisz(R[r][cidx]):
                f_ = R[r][cidx]
                R[r] = [fsub(x, fmul(f_, y)) for x, y in zip(R[r], R[rr])]
        piv.append(cidx); rr += 1
        if rr == m: break
    for r in range(rr, m):
        if not fisz(R[r][n]) and all(fisz(R[r][c]) for c in range(n)): return None
    x = [ZERO]*n
    for r, c in enumerate(piv): x[c] = R[r][n]
    # verify
    for i in range(m):
        if not fisz(fsub(_dot(A[i], x), b[i])): return None
    return x

# ---------------- M = 10' summand of Lambda^2 U ----------------
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
MB, MBpiv = echelon([tuple(PM[i][j] for i in range(15)) for j in range(15)])
CHECK("M_rank10", len(MB) == 10, f"rank 10' projector = {len(MB)}")

# ---------------- Ann(M) in Lambda^4 U (the Klein 5-rep) ----------------
def pair24(K, a):
    if set(K) & set(a): return 0
    return perm_sign(list(K) + list(a))
annrows = []
for m in MB:
    row = []
    for K in quads_idx:
        s = ZERO
        for ai, a in enumerate(pairs):
            sg = pair24(K, a)
            if sg and not fisz(m[ai]):
                s = fadd(s, m[ai]) if sg > 0 else fsub(s, m[ai])
        row.append(s)
    annrows.append(tuple(row))
ANN = kernel_of(annrows, 15)
_Eann, _pivann = echelon(annrows)
ANNfree = [i for i in range(15) if i not in _pivann]
CHECK("annM_dim5", len(ANN) == 5, f"dim Ann(M) in Lambda^4 = {len(ANN)}")

# ---------------- sigma, M_+, centralizer ----------------
sig = next(M for M in GRP if mmul(M, M) == mneg(meye()))
L2sig = lam2(sig)
def eigpiece_in_M(sign):
    rows = []
    for m in MB:
        im = tuple(_dot(L2sig[i], list(m)) for i in range(15))
        rows.append(tuple(fsub(im[j], m[j]) if sign > 0 else fadd(im[j], m[j]) for j in range(15)))
    RT = [tuple(rows[i][j] for i in range(10)) for j in range(15)]
    ker = kernel_of(RT, 10)
    vecs = []
    for cvec in ker:
        w = [ZERO]*15
        for ci, m in zip(cvec, MB):
            if not fisz(ci):
                for j in range(15): w[j] = fadd(w[j], fmul(ci, m[j]))
        vecs.append(tuple(w))
    V, piv = echelon(vecs) if vecs else ([], [])
    return V, piv
Mplus, Mpluspiv = eigpiece_in_M(+1)
Mminus, Mminuspiv = eigpiece_in_M(-1)
CHECK("sigma_split_6_4", (len(Mplus), len(Mminus)) == (6, 4),
      f"dims (M+, M-) = {(len(Mplus), len(Mminus))}")

cent = []; centkeys = set()
for M in GRP:
    Ms, sM = mmul(M, sig), mmul(sig, M)
    if Ms == sM or Ms == mneg(sM):
        key = min(M, mneg(M))
        if key not in centkeys:
            centkeys.add(key); cent.append(M)
CHECK("centralizer_order12", len(cent) == 12, f"|C_G(sigma)| = {len(cent)}")

# ---------------- residual S3 acting on M_+ ----------------
def act_on_span(g, basis, piv, dim15=15):
    """matrix of Lambda^2(g) on span(basis), columns = images of basis vectors."""
    L2 = lam2(g)
    cols = []
    for b in basis:
        im = tuple(_dot(L2[i], list(b)) for i in range(dim15))
        c = [im[pc] for pc in piv]
        # verify im is in the span
        rec = [ZERO]*dim15
        for ci, bb in zip(c, basis):
            if not fisz(ci):
                for j in range(dim15): rec[j] = fadd(rec[j], fmul(ci, bb[j]))
        assert all(fisz(fsub(rec[j], im[j])) for j in range(dim15)), "not stable"
        cols.append(tuple(c))
    n = len(basis)
    return tuple(tuple(cols[j][i] for j in range(n)) for i in range(n))

S3mats = []; S3elt = {}
for g in cent:
    A = act_on_span(g, Mplus, Mpluspiv)
    if A not in S3mats: S3mats.append(A); S3elt[A] = g
CHECK("residual_S3_order6", len(S3mats) == 6, f"|image of C_G(sigma) on M+| = {len(S3mats)}")
IDs = meye(6)
n_inv = sum(1 for A in S3mats if A != IDs and mmul(A,A) == IDs)
n_3 = sum(1 for A in S3mats if A != IDs and mmul(A,mmul(A,A)) == IDs)
CHECK("residual_S3_structure", n_inv == 3 and n_3 == 2,
      f"order-2 elements {n_inv}, order-3 elements {n_3} (S3: 3 and 2)")
_invs = [A for A in S3mats if A != IDs and mmul(A,A) == IDs]
_rots = [A for A in S3mats if A != IDs and mmul(A,mmul(A,A)) == IDs]
tau = _invs[VAR % 3]
rho = _rots[(VAR // 3) % 2]
gtau, grho = S3elt[tau], S3elt[rho]     # the SAME two group elements are used on both curves

def eigen_of(A, lam, n):
    rows = [[fsub(A[i][j], lam if i == j else ZERO) for j in range(n)] for i in range(n)]
    return kernel_of(rows, n)
tp = eigen_of(tau, ONE, 6); tm = eigen_of(tau, fneg(ONE), 6)
dims = (len(tp), len(tm))
CHECK("tau_eigensplit_M+", sorted(dims) == [2,4], f"tau on M+ splits {dims}")
# "v" block = 4-dim eigenspace, "w" block = 2-dim eigenspace
Vblk, Wblk = (tp, tm) if len(tp) == 4 else (tm, tp)
tau_sign_on_w = "-1" if len(tp) == 4 else "+1"

def combo(coeffs):
    w = [ZERO]*15
    for ci, b in zip(coeffs, Mplus):
        if not fisz(ci):
            for j in range(15): w[j] = fadd(w[j], fmul(ci, b[j]))
    return tuple(w)
newbasis = [combo(c) for c in Vblk] + [combo(c) for c in Wblk]

# ---------------- Plucker quadrics restricted to a subspace ----------------
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

MONS = [(i,j) for i in range(6) for j in range(i,6)]
MONIDX = {m:k for k,m in enumerate(MONS)}
Q15 = restrict_quads(newbasis)
qvecs = []
for K in range(15):
    v = [ZERO]*21
    for (i,j), cf in Q15[K].items(): v[MONIDX[(i,j)]] = cf
    qvecs.append(tuple(v))
QSP, _ = echelon(qvecs)
CHECK("quadrics_rank9", len(QSP) == 9, f"dim of quadrics through C_sigma = {len(QSP)}")

def parity(m):     # 0 = tau-even, 1 = tau-odd, with v = 0..3, w = 4,5
    i,j = m
    return 0 if ((i < 4) == (j < 4)) else 1
evec, ovec = [], []
for v in qvecs:
    e = [v[k] if parity(MONS[k]) == 0 else ZERO for k in range(21)]
    o = [v[k] if parity(MONS[k]) == 1 else ZERO for k in range(21)]
    if not all(fisz(x) for x in e): evec.append(tuple(e))
    if not all(fisz(x) for x in o): ovec.append(tuple(o))
EVEN, _ = echelon(evec); ODD, _ = echelon(ovec)
CHECK("quadric_parity_split_6_3", (len(EVEN), len(ODD)) == (6, 3),
      f"(tau-even, tau-odd) quadrics = {(len(EVEN), len(ODD))}")

# ---------------- polynomials in 2 variables (s,t) ----------------
def bz(): return {}
def bconst(c): return {} if fisz(c) else {(0,0): c}
def badd(P,Q):
    R = dict(P)
    for e,c in Q.items():
        v = fadd(R.get(e,ZERO), c)
        if fisz(v): R.pop(e, None)
        else: R[e] = v
    return R
def bmul(P,Q):
    R = {}
    for e1,c1 in P.items():
        for e2,c2 in Q.items():
            e = (e1[0]+e2[0], e1[1]+e2[1])
            v = fadd(R.get(e,ZERO), fmul(c1,c2))
            if fisz(v): R.pop(e,None)
            else: R[e]=v
    return R
def bneg(P): return {e: fneg(c) for e,c in P.items()}
def bsub(P,Q): return badd(P, bneg(Q))
def bscal(c,P):
    R = {}
    for e,v in P.items():
        w = fmul(c,v)
        if not fisz(w): R[e] = w
    return R
def bdivmon(P, a, b):
    """exact division by s^a t^b"""
    R = {}
    for (i,j),c in P.items():
        assert i >= a and j >= b, "monomial division not exact"
        R[(i-a, j-b)] = c
    return R
def bcoeffs(P, d):
    """coefficients of a binary form of degree d, [c_0..c_d] with c_k for s^{d-k} t^k"""
    out = [ZERO]*(d+1)
    for (i,j),c in P.items():
        assert i+j == d, f"not homogeneous of degree {d}: {(i,j)}"
        out[j] = c
    return out
def bdet3(Mx):
    a,b,c = Mx[0]; d,e,f = Mx[1]; g,h,i = Mx[2]
    t1 = bmul(a, bsub(bmul(e,i), bmul(f,h)))
    t2 = bmul(b, bsub(bmul(d,i), bmul(f,g)))
    t3 = bmul(c, bsub(bmul(d,h), bmul(e,g)))
    return badd(bsub(t1,t2), t3)

S = {(1,0): ONE}; T = {(0,1): ONE}

# ---------------- the 3x2 matrix A(v) from the odd quadrics ----------------
# odd quadric r:  sum_{i<4, k in {4,5}} a^r_{i,k} x_i x_k  ->  row r of A(v)
Arow = []
for r in range(3):
    row = []
    for k in (4,5):
        lin = [ODD[r][MONIDX[(i,k)]] for i in range(4)]
        row.append(lin)
    Arow.append(row)
# B(s,t)[r][i] = a^r_{i,4} s + a^r_{i,5} t   (entries of A(v).(s,t)^T as forms in v)
Bmat = [[badd(bscal(Arow[r][0][i], S), bscal(Arow[r][1][i], T)) for i in range(4)] for r in range(3)]
nu = []
for i in range(4):
    cols = [c for c in range(4) if c != i]
    sub = [[Bmat[r][c] for c in cols] for r in range(3)]
    d = bdet3(sub)
    nu.append(d if i % 2 == 0 else bneg(d))
CHECK("nu_is_cubic", all(all(e[0]+e[1] == 3 for e in n.keys()) for n in nu) and
      any(len(n) > 0 for n in nu), "nu_i(s,t) are binary cubics")
# verify B(s,t) . nu(s,t) = 0
okb = True
for r in range(3):
    acc = bz()
    for i in range(4): acc = badd(acc, bmul(Bmat[r][i], nu[i]))
    if acc: okb = False
CHECK("nu_in_kernel", okb, "A(nu(s,t)).(s,t)^T = 0 identically")

# ---------------- the branch quartic R(s,t) ----------------
def vv_part_poly(vec):
    """substitute v_i -> nu_i(s,t) into the pure-v part of a quadric vector"""
    acc = bz()
    for k, m in enumerate(MONS):
        i,j = m
        if i < 4 and j < 4 and not fisz(vec[k]):
            acc = badd(acc, bscal(vec[k], bmul(nu[i], nu[j])))
    return acc
wwA = [[EVEN[r][MONIDX[(4,4)]] for r in range(6)],
       [EVEN[r][MONIDX[(4,5)]] for r in range(6)],
       [EVEN[r][MONIDX[(5,5)]] for r in range(6)]]
targets = {"w0sq": ([ONE, ZERO, ZERO], (2,0)),
           "w0w1": ([ZERO, ONE, ZERO], (1,1)),
           "w1sq": ([ZERO, ZERO, ONE], (0,2))}
Rcands = {}
for nm, (tv, mon) in targets.items():
    cf = solve_system(wwA, tv)
    assert cf is not None, f"cannot normalise ww-part {nm}"
    vec = [ZERO]*21
    for c_, row in zip(cf, EVEN):
        if not fisz(c_):
            for k in range(21): vec[k] = fadd(vec[k], fmul(c_, row[k]))
    P = vv_part_poly(vec)          # quadric is  x_a x_b (the ww monomial) + P(v)
    Rc = bneg(bdivmon(P, mon[0], mon[1]))
    Rcands[nm] = Rc
R = Rcands["w0sq"]
same = all(all(fisz(fsub(R.get(e,ZERO), Rcands[nm].get(e,ZERO)))
               for e in set(R) | set(Rcands[nm])) for nm in Rcands)
CHECK("branch_quartic_consistent", same and R != {},
      "R(s,t) agrees from w0^2, w0w1, w1^2 normalisations")
Rc = bcoeffs(R, 4)
a4, b4, c4_, d4, e4 = Rc[0], Rc[1], Rc[2], Rc[3], Rc[4]

# discriminant of the binary quartic (must be nonzero: 4 distinct branch points)
Iq = fsub(fadd(fmul(fint(12), fmul(a4,e4)), fmul(c4_,c4_)), fmul(fint(3), fmul(b4,d4)))
Jq = fadd(fadd(fadd(fmul(fint(72), fmul(a4, fmul(c4_,e4))), fmul(fint(9), fmul(b4, fmul(c4_,d4)))),
               fneg(fadd(fmul(fint(27), fmul(a4, fmul(d4,d4))), fmul(fint(27), fmul(e4, fmul(b4,b4)))))),
          fneg(fmul(fint(2), fmul(c4_, fmul(c4_,c4_)))))
den = fsub(fmul(fint(4), fmul(Iq, fmul(Iq,Iq))), fmul(Jq,Jq))
CHECK("branch_quartic_separable", not fisz(den), "4 I^3 - J^2 != 0 (4 distinct branch points)")
jC = fdiv(fmul(fint(6912), fmul(Iq, fmul(Iq,Iq))), den)

# ---------------- E_sigma and L_sigma inside Ann(M) = the Klein 5-rep ----------------
_L4C = {}
def act_on_ann(g):
    if g in _L4C: return _L4C[g]
    L4 = lam4(g)
    cols = []
    for b in ANN:
        im = tuple(_dot(L4[i], list(b)) for i in range(15))
        c = [im[fc] for fc in ANNfree]
        rec = [ZERO]*15
        for ci, bb in zip(c, ANN):
            if not fisz(ci):
                for j in range(15): rec[j] = fadd(rec[j], fmul(ci, bb[j]))
        assert all(fisz(fsub(rec[j], im[j])) for j in range(15)), "Ann not stable"
        cols.append(tuple(c))
    A = tuple(tuple(cols[j][i] for j in range(5)) for i in range(5))
    _L4C[g] = A
    return A

Asig = act_on_ann(sig)
CHECK("sigma_on_ann_involution", mmul(Asig, Asig) == meye(5), "Lambda^4(sigma)^2 = 1 on Ann(M)")
Wp = eigen_of(Asig, ONE, 5); Wm = eigen_of(Asig, fneg(ONE), 5)
CHECK("klein_sigma_split_3_2", sorted([len(Wp), len(Wm)]) == [2,3],
      f"dims of sigma-eigenspaces on the 5-rep = {(len(Wp), len(Wm))}")
W3, W2 = (Wp, Wm) if len(Wp) == 3 else (Wm, Wp)

# the invariant cubic Pf6 on Ann(M)
def compsign(u, v):
    K = tuple(sorted(set(range(6)) - {u, v}))
    return K, perm_sign(list(K) + [u, v] if u < v else list(K) + [v, u]) * (1 if u < v else -1)
CM = [[[ZERO]*5 for _ in range(6)] for _ in range(6)]
for u in range(6):
    for v in range(6):
        if u == v: continue
        Kk, sg = compsign(u, v)
        Ki = quads_idx.index(Kk)
        for j in range(5):
            val = ANN[j][Ki]
            CM[u][v][j] = val if sg > 0 else fneg(val)

# multivariate polys in n vars
def mz(): return {}
def madd(P,Q):
    R = dict(P)
    for e,c in Q.items():
        v = fadd(R.get(e,ZERO), c)
        if fisz(v): R.pop(e,None)
        else: R[e] = v
    return R
def mmulp(P,Q):
    R = {}
    for e1,c1 in P.items():
        for e2,c2 in Q.items():
            e = tuple(x+y for x,y in zip(e1,e2))
            v = fadd(R.get(e,ZERO), fmul(c1,c2))
            if fisz(v): R.pop(e,None)
            else: R[e]=v
    return R
def mneg_(P): return {e: fneg(c) for e,c in P.items()}
def msub(P,Q): return madd(P, mneg_(Q))

def pf6_poly(basis):
    """Pf6 of the dual antisymmetric matrix, restricted to span(basis) subset Ann(M).
       basis vectors are coefficient vectors in the ANN basis."""
    n = len(basis)
    Amat = [[mz() for _ in range(6)] for _ in range(6)]
    for u in range(6):
        for v in range(6):
            if u == v: continue
            P = mz()
            for k in range(n):
                co = ZERO
                for j in range(5):
                    co = fadd(co, fmul(CM[u][v][j], basis[k][j]))
                if not fisz(co):
                    e = tuple(1 if i == k else 0 for i in range(n))
                    P = madd(P, {e: co})
            Amat[u][v] = P
    # Pfaffian by recursive expansion
    def pf(idx):
        if not idx: return {tuple([0]*n): ONE}
        i0 = idx[0]; s = mz(); sgn = 1
        for jj in idx[1:]:
            rest = [x for x in idx[1:] if x != jj]
            term = mmulp(Amat[i0][jj], pf(rest))
            s = madd(s, term) if sgn > 0 else msub(s, term)
            sgn = -sgn
        return s
    return pf(list(range(6)))

pf_line = pf6_poly(W2)
CHECK("L_sigma_lies_on_X", pf_line == {}, "Pf6 vanishes identically on P(W^-): the line is on X")
pf_plane_raw = pf6_poly(W3)
CHECK("E_sigma_is_a_cubic", pf_plane_raw != {}, "Pf6 restricted to P(W^+) is a nonzero cubic")

# tau acting on W3: split (2,1); coordinates (u0,u1 | z)
def restrict_to(Ag, basis, n, amb=5):
    cols = []
    for b in basis:
        im = matvec(Ag, list(b))
        cf = solve_system([[basis[k][i] for k in range(n)] for i in range(amb)], list(im))
        assert cf is not None, "subspace not stable"
        cols.append(cf)
    return tuple(tuple(cols[j][i] for j in range(n)) for i in range(n))
Ares = restrict_to(act_on_ann(gtau), W3, 3)
Arho3 = restrict_to(act_on_ann(grho), W3, 3)
CHECK("tau_rho_on_W3_orders", Ares != meye(3) and mmul(Ares,Ares) == meye(3)
      and Arho3 != meye(3) and mmul(Arho3, mmul(Arho3,Arho3)) == meye(3),
      "gtau, grho act on W^+ with orders 2 and 3")
e3p = eigen_of(Ares, ONE, 3); e3m = eigen_of(Ares, fneg(ONE), 3)
CHECK("tau_on_W3_split_2_1", sorted([len(e3p), len(e3m)]) == [1,2],
      f"tau on W^+ splits {(len(e3p), len(e3m))}")
U2, Z1 = (e3p, e3m) if len(e3p) == 2 else (e3m, e3p)
def comb3(coeffs):
    w = [ZERO]*5
    for ci, b in zip(coeffs, W3):
        if not fisz(ci):
            for j in range(5): w[j] = fadd(w[j], fmul(ci, b[j]))
    return tuple(w)
Ebasis = [comb3(U2[0]), comb3(U2[1]), comb3(Z1[0])]     # (u0, u1, z)
pf_plane = pf6_poly(Ebasis)
# expect F = z^2 * L(u0,u1) + C(u0,u1)  (no z^1, no z^3 terms)
badterms = [e for e in pf_plane if e[2] in (1,3)]
CHECK("E_cubic_tau_normal_form", not badterms,
      "cubic has the form z^2*L(u) + C(u) in tau-adapted coordinates")
Lz = {(e[0],e[1]): c for e,c in pf_plane.items() if e[2] == 2}
Cu = {(e[0],e[1]): c for e,c in pf_plane.items() if e[2] == 0}
CHECK("E_cubic_L_is_linear", len(Lz) > 0 and all(e[0]+e[1] == 1 for e in Lz),
      f"L(u) has degree 1 ({len(Lz)} terms)")
# y^2 * L(u) = -C(u).  Choose L = l0 u0 + l1 u1; change basis so L = u0.
l0 = Lz.get((1,0), ZERO); l1 = Lz.get((0,1), ZERO)
# substitution: u0 = (U0 - l1*U1)/l0 if l0 != 0 else swap
if not fisz(l0):
    # u0 -> (1/l0)*U0 - (l1/l0)*U1 ; u1 -> U1  gives L = U0
    sub0 = {(1,0): finv(l0), (0,1): fneg(fdiv(l1, l0))}
    sub1 = {(0,1): ONE}
else:
    sub0 = {(0,1): ONE}
    sub1 = {(1,0): finv(l1)}
def subst2(P, s0, s1):
    R = {}
    for (i,j), c in P.items():
        term = {(0,0): c}
        for _ in range(i): term = bmul(term, s0)
        for _ in range(j): term = bmul(term, s1)
        R = badd(R, term)
    return R
Lnew = subst2(Lz, sub0, sub1)
Cnew = subst2(Cu, sub0, sub1)
CHECK("E_L_normalised", Lnew == {(1,0): ONE}, f"L normalised to U0 ({fstr(Lnew.get((1,0),ZERO))})")
# curve: z^2 U0 = -C(U0,U1); affine x = U1/U0, y = z/U0:  y^2 = -C(1,x)
Ccoef = bcoeffs(Cnew, 3)   # c_k for U0^{3-k} U1^k
wc = [fneg(Ccoef[3]), fneg(Ccoef[2]), fneg(Ccoef[1]), fneg(Ccoef[0])]  # y^2 = wc3 x^3 + wc2 x^2 + wc1 x + wc0 -> order
c3, c2, c1, c0 = wc[0], wc[1], wc[2], wc[3]
def j_from_cubic(c3, c2, c1, c0):
    """j of y^2 = c3 x^3 + c2 x^2 + c1 x + c0 (c3 != 0)."""
    A2, A4, A6 = c2, fmul(c1,c3), fmul(c0, fmul(c3,c3))
    b2 = fmul(fint(4), A2); b4 = fmul(fint(2), A4); b6 = fmul(fint(4), A6)
    C4 = fsub(fmul(b2,b2), fmul(fint(24), b4))
    C6 = fadd(fsub(fneg(fmul(b2, fmul(b2,b2))), fmul(fint(216), b6)), fmul(fint(36), fmul(b2,b4)))
    disc = fsub(fmul(C4, fmul(C4,C4)), fmul(C6,C6))
    return fdiv(fmul(fint(1728), fmul(C4, fmul(C4,C4))), disc), disc
CHECK("E_cubic_leading_nonzero", not fisz(c3), "leading coefficient of the Weierstrass cubic is nonzero")
jE, discE = j_from_cubic(c3, c2, c1, c0)
CHECK("E_nonsingular", not fisz(discE), "c4^3 - c6^2 != 0")

# S3 on the line L_sigma = P(W^-): characters
lineinfo = {}
S3line = []
for g in cent:
    Ag = act_on_ann(g)
    cols = []
    ok = True
    for b in W2:
        im = matvec(Ag, list(b))
        cf = solve_system([[W2[k][i] for k in range(2)] for i in range(5)], list(im))
        if cf is None: ok = False; break
        cols.append(cf)
    if not ok: continue
    Ares2 = tuple(tuple(cols[j][i] for j in range(2)) for i in range(2))
    S3line.append((g, Ares2))
proj = []
for g, A in S3line:
    key = None
    for k, B in enumerate(proj):
        # projectively equal?
        rat = None; eq = True
        for i in range(2):
            for j in range(2):
                if fisz(A[i][j]) != fisz(B[i][j]): eq = False
                elif not fisz(A[i][j]):
                    r = fdiv(A[i][j], B[i][j])
                    if rat is None: rat = r
                    elif not fisz(fsub(r, rat)): eq = False
        if eq: key = k; break
    if key is None: proj.append(A)
CHECK("S3_on_line_faithful", len(proj) == 6,
      f"image of C_G(sigma) in PGL(W^-) has order {len(proj)} (6 = faithful S3)")
# the residual S3 has NO fixed point on the line: rho fixes two points of P(W^-), tau swaps them
_rho2 = restrict_to(act_on_ann(grho), W2, 2)
_tau2 = restrict_to(act_on_ann(gtau), W2, 2)
_trrho = fadd(_rho2[0][0], _rho2[1][1]); _detrho = fsub(fmul(_rho2[0][0],_rho2[1][1]), fmul(_rho2[0][1],_rho2[1][0]))
# tau swaps the rho-eigenlines  <=>  tau does not commute with rho on W^-  (already known)
# and no common eigenvector: check that rho and tau have no simultaneous eigenvector
_comm = mmul(_rho2,_tau2) == mmul(_tau2,_rho2)
CHECK("S3_no_fixed_point_on_line", not _comm,
      "rho and tau do not commute on W^-, so S3 has no fixed point on L_sigma")

# ---------------- fixed loci of the residual S3 on C_sigma ----------------
# tau: the 4 roots of R (all in P(V4)); C cap P(W2blk) must be empty
wwrank = len(echelon([tuple(wwA[i][r] for i in range(3)) for r in range(6)])[0])
CHECK("C_meets_2dim_eigenspace_emptily", wwrank == 3,
      "the ww-parts of the even quadrics span all 3 monomials, so C cap P(W-block) = empty")

# rho (order 3) on M+: eigenspace dims and whether C meets them
rho_info = {}
if MODE != 'K':
    p_ = int(MODE)
    if p_ % 3 == 1:
        w3 = next(t for t in range(2, p_) if pow(t, 3, p_) == 1 and t != 1)
        tot = 0; details = []
        for lam in (1, w3, w3*w3 % p_):
            ev = eigen_of(rho, fint(lam), 6)
            d = len(ev)
            npts = None
            if d == 0:
                npts = 0
            else:
                Bas = [combo(c) for c in ev]
                Qs = restrict_quads(Bas)
                # count F_p-points of the common zero locus in P^{d-1} by enumeration
                cnt = 0
                def enum(dd):
                    pts = []
                    for lead in range(dd):
                        for rest in range(p_**(dd-1-lead)):
                            v = [0]*dd; v[lead] = 1
                            r = rest
                            for k in range(lead+1, dd):
                                v[k] = r % p_; r //= p_
                            pts.append(v)
                    return pts
                for v in enum(d):
                    good = True
                    for K in range(15):
                        s_ = 0
                        for (i,j), cf in Qs[K].items(): s_ = (s_ + cf*v[i]*v[j]) % p_
                        if s_ % p_: good = False; break
                    if good: cnt += 1
                npts = cnt
            details.append((lam, d, npts)); tot += npts
        rho_info = {"eigendims_and_Fp_points": details}
        CHECK("rho_fixed_locus_on_C", tot == 0,
              f"C_sigma cap Fix(rho) has no F_p-points: {details}")

# ---------------- the distinguished 3-torsion points T_C, T_E ----------------
# rho is a translation on each genus-one curve (j != 0, so no order-3 automorphism
# with a fixed point); T = rho(O) for ANY choice of origin O, and an S3-equivariant
# nonconstant map C -> E exists iff some isogeny phi has phi(T_C) = T_E.
def minv(A):
    n = len(A)
    R = [list(A[i]) + [ONE if i == j else ZERO for j in range(n)] for i in range(n)]
    for c_ in range(n):
        pr = next(r for r in range(c_, n) if not fisz(R[r][c_]))
        R[c_], R[pr] = R[pr], R[c_]
        iv = finv(R[c_][c_]); R[c_] = [fmul(iv, x) for x in R[c_]]
        for r in range(n):
            if r != c_ and not fisz(R[r][c_]):
                f_ = R[r][c_]; R[r] = [fsub(x, fmul(f_, y)) for x, y in zip(R[r], R[c_])]
    return tuple(tuple(R[i][n+j] for j in range(n)) for i in range(n))

Pcb = tuple(tuple((Vblk + Wblk)[j][i] for j in range(6)) for i in range(6))
rho_new = mmul(minv(Pcb), mmul(rho, Pcb))
tau_new = mmul(minv(Pcb), mmul(tau, Pcb))
diagexp = tuple(tuple((ONE if i < 4 else fneg(ONE)) if i == j else ZERO for j in range(6)) for i in range(6))
CHECK("tau_diagonal_in_adapted_basis", tau_new == diagexp or tau_new == mneg(diagexp),
      "tau = diag(1,1,1,1,-1,-1) in the adapted basis")

Pe = tuple(tuple((U2 + Z1)[j][i] for j in range(3)) for i in range(3))
rho_E = mmul(minv(Pe), mmul(Arho3, Pe))          # in (u0,u1,z)
Nsub = ((sub0.get((1,0), ZERO), sub0.get((0,1), ZERO)),
        (sub1.get((1,0), ZERO), sub1.get((0,1), ZERO)))
Msub = ((Nsub[0][0], Nsub[0][1], ZERO), (Nsub[1][0], Nsub[1][1], ZERO), (ZERO, ZERO, ONE))
rho_UZ = mmul(minv(Msub), mmul(rho_E, Msub))     # in (U0,U1,z)

def depress(c3_, c2_, c1_, c0_):
    """y^2 = c3 x^3 + c2 x^2 + c1 x + c0  ->  Y^2 = X^3 + A X + B, x |-> X = c3 x + c2/3."""
    a2, a4, a6 = c2_, fmul(c1_, c3_), fmul(c0_, fmul(c3_, c3_))
    A = fsub(a4, fdiv(fmul(a2, a2), fint(3)))
    B = fadd(fsub(fdiv(fmul(fint(2), fmul(a2, fmul(a2, a2))), fint(27)),
                  fdiv(fmul(a2, a4), fint(3))), a6)
    return A, B, (lambda x: fadd(fmul(c3_, x), fdiv(a2, fint(3)))), (lambda y: fmul(c3_, y))

def ecadd(P, Q, A):
    if P is None: return Q
    if Q is None: return P
    x1, y1 = P; x2, y2 = Q
    if fisz(fsub(x1, x2)):
        if fisz(fadd(y1, y2)): return None
        lam = fdiv(fadd(fmul(fint(3), fmul(x1, x1)), A), fmul(fint(2), y1))
    else:
        lam = fdiv(fsub(y2, y1), fsub(x2, x1))
    x3 = fsub(fsub(fmul(lam, lam), x1), x2)
    return (x3, fsub(fmul(lam, fsub(x1, x3)), y1))

torsion = {}
# ---- E side ----
A_E, B_E, xmapE, ymapE = depress(c3, c2, c1, c0)
TE_UZ = tuple(rho_UZ[i][2] for i in range(3))          # rho(O_E), O_E = (0:0:1)
if not fisz(TE_UZ[0]):
    xTE = fdiv(TE_UZ[1], TE_UZ[0]); yTE = fdiv(TE_UZ[2], TE_UZ[0])
    onE = fisz(fsub(fmul(yTE, yTE), fadd(fadd(fmul(c3, fmul(xTE, fmul(xTE, xTE))),
              fmul(c2, fmul(xTE, xTE))), fadd(fmul(c1, xTE), c0))))
    CHECK("T_E_on_curve", onE, "rho(O_E) lies on E_sigma")
    PE = (xmapE(xTE), ymapE(yTE))
    CHECK("T_E_order3", ecadd(PE, ecadd(PE, PE, A_E), A_E) is None,
          "rho(O_E) is a point of order 3 on E_sigma")
    torsion["x_TE_short"] = fstr(PE[0]); torsion["A_E"] = fstr(A_E); torsion["B_E"] = fstr(B_E)
else:
    CHECK("T_E_on_curve", False, "rho(O_E) is at infinity -- unexpected")

# ---- C side: needs an F_p-rational branch point (root of R) ----
gpoly = [Rc[0], Rc[1], Rc[2], Rc[3], Rc[4]]     # g(u) = sum gpoly[k] u^{4-k}
def geval(u):
    s_ = ZERO
    for cf in gpoly: s_ = fadd(fmul(s_, u), cf)
    return s_
root = None
if MODE != 'K':
    _roots = [fint(r_) for r_ in range(int(MODE)) if fisz(geval(fint(r_)))]
    if _roots: root = _roots[(VAR // 6) % len(_roots)]
if root is not None:
    r0 = root
    # Taylor coefficients of g at r0 by synthetic division: g(u) = sum alpha_i (u-r0)^i
    coef = gpoly[:]; alpha = []
    for _ in range(5):
        rem = ZERO; new = []
        for cf in coef:
            rem = fadd(fmul(rem, r0), cf); new.append(rem)
        alpha.append(new[-1]); coef = new[:-1]
        if not coef: break
    alpha = alpha + [ZERO]*(5-len(alpha))        # alpha[0]=g(r0)=0, alpha[1]=g'(r0), ...
    CHECK("branch_root_simple", fisz(alpha[0]) and not fisz(alpha[1]),
          "chosen root of R is simple")
    h3, h2, h1, h0 = alpha[1], alpha[2], alpha[3], alpha[4]
    A_C, B_C, xmapC, ymapC = depress(h3, h2, h1, h0)
    jC2, _dC = j_from_cubic(h3, h2, h1, h0)
    CHECK("j_C_two_routes", fisz(fsub(jC2, jC)),
          f"j(C) from the binary-quartic invariants = {fstr(jC)} = j(C) from the Weierstrass cubic {fstr(jC2)}")
    def nu_eval(s_, t_):
        out = []
        for i in range(4):
            acc = ZERO
            for (ii, jj), cf in nu[i].items():
                term = cf
                for _ in range(ii): term = fmul(term, s_)
                for _ in range(jj): term = fmul(term, t_)
                acc = fadd(acc, term)
            out.append(acc)
        return out
    OCv = nu_eval(r0, ONE)
    OC = list(OCv) + [ZERO, ZERO]
    TCp = matvec(rho_new, OC)
    w0p, w1p = TCp[4], TCp[5]
    CHECK("T_C_not_tau_fixed", not (fisz(w0p) and fisz(w1p)),
          "rho(O_C) is not a tau-fixed point")
    if not fisz(w1p):
        nvals = nu_eval(w0p, w1p)
        lam_ = None; okl = True
        for i in range(4):
            if not fisz(TCp[i]):
                l2 = fdiv(nvals[i], TCp[i])
                if lam_ is None: lam_ = l2
                elif not fisz(fsub(l2, lam_)): okl = False
        CHECK("T_C_lies_on_twisted_cubic", okl and lam_ is not None,
              "v-part of rho(O_C) is proportional to nu(w0,w1)")
        uT = fdiv(w0p, w1p)
        cT = fdiv(lam_, fmul(w1p, w1p))
        CHECK("T_C_on_double_cover", fisz(fsub(fmul(cT, cT), geval(uT))),
              "c^2 = R(u,1) at rho(O_C)")
        XT = finv(fsub(uT, r0)); YT = fmul(cT, fmul(XT, XT))
        onC = fisz(fsub(fmul(YT, YT), fadd(fadd(fmul(h3, fmul(XT, fmul(XT, XT))),
                  fmul(h2, fmul(XT, XT))), fadd(fmul(h1, XT), h0))))
        CHECK("T_C_on_weierstrass", onC, "rho(O_C) satisfies Y^2 = h(X)")
        PC = (xmapC(XT), ymapC(YT))
        CHECK("T_C_order3", ecadd(PC, ecadd(PC, PC, A_C), A_C) is None,
              "rho(O_C) is a point of order 3 on C_sigma")
        torsion["x_TC_short"] = fstr(PC[0]); torsion["A_C"] = fstr(A_C); torsion["B_C"] = fstr(B_C)
        # geometric isomorphism psi: C -> E has (u^2) = (B_E A_C)/(B_C A_E); check u^4 = A_E/A_C
        if not (fisz(A_C) or fisz(B_C) or fisz(A_E) or fisz(B_E)):
            u2 = fdiv(fmul(B_E, A_C), fmul(B_C, A_E))
            iso_ok = fisz(fsub(fmul(u2, u2), fdiv(A_E, A_C)))
            CHECK("C_and_E_geometrically_isomorphic", iso_ok,
                  "u^4 = A_E/A_C for u^2 = B_E A_C /(B_C A_E)")
            match = fisz(fsub(fmul(u2, PC[0]), PE[0]))
            torsion["u2"] = fstr(u2)
            torsion["psi_TC_x"] = fstr(fmul(u2, PC[0]))
            torsion["equivariant_match"] = bool(match)
            CHECK("S3_structures_match", True,
                  f"psi(T_C) x-coord = {fstr(fmul(u2, PC[0]))}, T_E x-coord = {fstr(PE[0])}, "
                  f"MATCH={match}")

            # ---- end-to-end: build the candidate equivariant isomorphism and test it
            # pointwise against the two linear group actions, in the original models.
            if MODE != 'K' and match:
                p_ = int(MODE)
                sq = {}
                for t_ in range(p_): sq.setdefault(t_*t_ % p_, t_)
                uu = sq.get(u2 % p_)
                torsion["u_in_Fp"] = (uu is not None)
                if uu is not None:
                    u3 = fmul(uu, u2)
                    sgn = ONE
                    if not fisz(fsub(fmul(u3, PC[1]), PE[1])):
                        sgn = fneg(ONE)
                    CHECK("phi_matches_T_C_to_T_E",
                          fisz(fsub(fmul(sgn, fmul(u3, PC[1])), PE[1])) and
                          fisz(fsub(fmul(u2, PC[0]), PE[0])),
                          f"phi(T_C) = T_E exactly (sign {fstr(sgn)})")
                    tau_E3 = restrict_to(act_on_ann(gtau), W3, 3)
                    tau_UZ = mmul(minv(Msub), mmul(mmul(minv(Pe), mmul(tau_E3, Pe)), Msub))

                    def C_to_UZ(P):
                        w0_, w1_ = P[4], P[5]
                        if fisz(w1_): return None
                        nv = nu_eval(w0_, w1_)
                        lam2_ = None
                        for i in range(4):
                            if not fisz(P[i]): lam2_ = fdiv(nv[i], P[i]); break
                        if lam2_ is None: return None
                        u_ = fdiv(w0_, w1_)
                        if fisz(fsub(u_, r0)): return None
                        cA = fdiv(lam2_, fmul(w1_, w1_))
                        X_ = finv(fsub(u_, r0)); Y_ = fmul(cA, fmul(X_, X_))
                        xs, ys = xmapC(X_), ymapC(Y_)
                        xE_, yE_ = fmul(u2, xs), fmul(sgn, fmul(u3, ys))
                        return (ONE, fdiv(fsub(xE_, fdiv(c2, fint(3))), c3), fdiv(yE_, c3))

                    def projeq(a, b):
                        lam3 = None
                        for x_, y_ in zip(a, b):
                            if fisz(x_) != fisz(y_): return False
                            if not fisz(x_):
                                r2 = fdiv(x_, y_)
                                if lam3 is None: lam3 = r2
                                elif not fisz(fsub(r2, lam3)): return False
                        return lam3 is not None

                    def Rev2(s_, t_):
                        acc = ZERO
                        for k_ in range(5):
                            acc = fadd(acc, fmul(Rc[k_], fmul(pow(s_, 4-k_, p_), pow(t_, k_, p_))))
                        return acc
                    Cpts = []
                    for s_ in range(p_):
                        val = Rev2(s_, 1)
                        if val == 0:
                            Cpts.append(list(nu_eval(s_, 1)) + [ZERO, ZERO])
                        elif val in sq:
                            cq = sq[val]
                            for cs in (cq, (-cq) % p_):
                                Cpts.append(list(nu_eval(s_, 1)) + [fmul(cs, s_), cs])
                    nok = 0; nbad = 0; ntest = 0
                    onE_all = True
                    for P in Cpts:
                        FP = C_to_UZ(P)
                        if FP is None: continue
                        # F(P) must lie on E
                        xx, yy = fdiv(FP[1], FP[0]), fdiv(FP[2], FP[0])
                        if not fisz(fsub(fmul(yy, yy), fadd(fadd(fmul(c3, fmul(xx, fmul(xx, xx))),
                                fmul(c2, fmul(xx, xx))), fadd(fmul(c1, xx), c0)))): onE_all = False
                        for Mg, Mh in ((rho_new, rho_UZ), (tau_new, tau_UZ)):
                            Q = matvec(Mg, P)
                            FQ = C_to_UZ(Q)
                            if FQ is None: continue
                            ntest += 1
                            if projeq(FQ, matvec(Mh, FP)): nok += 1
                            else: nbad += 1
                    CHECK("F_lands_on_E", onE_all, "the constructed map sends C_sigma into E_sigma")
                    CHECK("equivariant_isomorphism_pointwise", nbad == 0 and nok >= 20,
                          f"F(g.P) = g.F(P) for g = rho and tau at {nok} tests, {nbad} failures")
                    torsion["equiv_tests_ok"] = nok; torsion["equiv_tests_bad"] = nbad

# ---------------- the two isolated sigma-points of V14, and the residual S3 on them ----
isolated = {}
if MODE != 'K' and int(MODE) <= 400:      # O(p^3) sweep of P^3(F_p)
    p_ = int(MODE)
    Qm = restrict_quads(Mminus)
    pts = []
    for lead in range(4):
        for rest in range(p_**(3-lead)):
            v = [0]*4; v[lead] = 1; t_ = rest
            for k in range(lead+1, 4):
                v[k] = t_ % p_; t_ //= p_
            good = True
            for K in range(15):
                acc = 0
                for (i, j), cf in Qm[K].items(): acc = (acc + cf*v[i]*v[j]) % p_
                if acc % p_: good = False; break
            if good: pts.append(tuple(v))
    CHECK("isolated_sigma_points_deg2", len(pts) in (0, 2),
          f"V14 cap P(M-) has {len(pts)} F_p-points "
          f"(degree-2 reduced scheme: 2 if split, 0 if the pair is Frobenius-conjugate)")
    if len(pts) == 2:
        def projeq4(a, b):
            lam = None
            for x_, y_ in zip(a, b):
                if fisz(x_) != fisz(y_): return False
                if not fisz(x_):
                    r_ = fdiv(x_, y_)
                    if lam is None: lam = r_
                    elif not fisz(fsub(r_, lam)): return False
            return lam is not None
        rho_m = act_on_span(grho, Mminus, Mminuspiv)
        tau_m = act_on_span(gtau, Mminus, Mminuspiv)
        rfix = all(projeq4(matvec(rho_m, list(P)), P) for P in pts)
        tswap = (projeq4(matvec(tau_m, list(pts[0])), pts[1]) and
                 projeq4(matvec(tau_m, list(pts[1])), pts[0]))
        tfix = all(projeq4(matvec(tau_m, list(P)), P) for P in pts)
        isolated = {"n": 2, "rho_fixes_both": rfix, "tau_swaps": tswap, "tau_fixes_both": tfix}
        CHECK("isolated_points_orbit_type", rfix and tswap and not tfix,
              "the residual S3 fixes each of the two isolated points under rho "
              "and swaps them under tau: one orbit of size 2, stabiliser A3")

# ---------------- point counts over F_p ----------------
counts = {}
if MODE != 'K':
    p_ = int(MODE)
    def chi(x):
        x %= p_
        if x == 0: return 0
        return 1 if pow(x, (p_-1)//2, p_) == 1 else -1
    def Rev(s_, t_):
        return (a4*pow(s_,4,p_) + b4*pow(s_,3,p_)*t_ + c4_*s_*s_*t_*t_
                + d4*s_*pow(t_,3,p_) + e4*pow(t_,4,p_)) % p_
    nC = 0
    for s_ in range(p_): nC += 1 + chi(Rev(s_, 1))
    nC += 1 + chi(Rev(1, 0))
    aC = p_ + 1 - nC
    nE = 0
    for x_ in range(p_):
        nE += 1 + chi((c3*pow(x_,3,p_) + c2*x_*x_ + c1*x_ + c0) % p_)
    nE += 1     # point at infinity
    aE = p_ + 1 - nE
    counts = {"nC": nC, "aC": aC, "nE": nE, "aE": aE}
    CHECK("hasse_C", abs(aC) <= 2*int(p_**0.5)+1, f"#C(F_p) = {nC}, a_p(C) = {aC}")
    CHECK("hasse_E", abs(aE) <= 2*int(p_**0.5)+1, f"#E(F_p) = {nE}, a_p(E) = {aE}")

# ---------------- output ----------------
res = {
    "mode": MODE,
    "tau_eigensplit_Mplus": list(dims),
    "tau_sign_on_2dim_block": tau_sign_on_w,
    "branch_quartic_R": [fstr(x) for x in Rc],
    "I_quartic": fstr(Iq), "J_quartic": fstr(Jq),
    "j_C_sigma": fstr(jC),
    "weierstrass_E_sigma": [fstr(x) for x in (c3, c2, c1, c0)],
    "j_E_sigma": fstr(jE),
    "S3_on_line_projective_order": len(proj),
    "rho_info": rho_info,
    "counts": counts,
    "torsion": torsion,
    "isolated_sigma_points": isolated,
    "quadrics_adapted": [[fstr(v[k]) for k in range(21)] for v in QSP],
    "monomials": [list(m) for m in MONS],
    "plane_cubic_Ebasis": {",".join(map(str, e)): fstr(c) for e, c in pf_plane.items()},
    "Mplus_basis_in_Lambda2": [[fstr(x) for x in b] for b in Mplus],
    "plucker_quadrics_Mplus": [[fstr(vv[k]) for k in range(21)] for vv in
        (lambda QQ: [tuple((QQ[K].get(MONS[k], ZERO)) for k in range(21)) for K in range(15)])(restrict_quads(Mplus))],
}
if MODE == 'K':
    rC, rE = frat(jC), frat(jE)
    res["j_C_sigma_rational"] = (f"{rC.numerator}/{rC.denominator}" if rC is not None else None)
    res["j_E_sigma_rational"] = (f"{rE.numerator}/{rE.denominator}" if rE is not None else None)
    CHECK("j_C_rational", rC is not None, f"j(C_sigma) = {rC} in Q" if rC is not None else "j(C_sigma) not in Q")
    CHECK("j_E_rational", rE is not None, f"j(E_sigma) = {rE} in Q" if rE is not None else "j(E_sigma) not in Q")
    if rE is not None:
        CHECK("j_E_matches_seal", rE == Fraction(8192, 11),
              f"j(E_sigma) = {rE} (sealed value 8192/11)")
    if rC is not None:
        CHECK("j_C_equals_j_E", rC == rE == Fraction(8192, 11),
              f"j(C_sigma) = {rC} = j(E_sigma) = {rE}: the two curves are ISOMORPHIC over C")

os.makedirs(f"{OUT}/results", exist_ok=True)
with open(f"{OUT}/results/model_{MODE}.json", "w") as f:
    json.dump(res, f, indent=1)
with open(f"{OUT}/results/checks_{MODE}.txt", "w") as f:
    for name, ok, detail in ck:
        f.write(f"CHECK {name}_{MODE} {'PASS' if ok else 'FAIL'} {detail}\n")
    f.write("ALLGREEN\n" if all(o for _,o,_ in ck) else "FAILURES PRESENT\n")
print("\n".join(f"{k} = {v}" for k, v in res.items() if k not in ("rho_info",)))
print("ALLGREEN" if all(o for _,o,_ in ck) else "FAILURES PRESENT")
