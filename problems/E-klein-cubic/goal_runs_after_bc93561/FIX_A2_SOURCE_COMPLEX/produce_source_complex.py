#!/usr/bin/env python3
"""FIX-A2 producer -- the complete decorated fixed-locus complex F(P(W)) of the
SOURCE P^4 = P(W), for G = PSL(2,11) acting by the exact 5-dimensional Weil
representation of certificates/exact_weil_check.py.

Everything is exact in characteristic 0: cyclotomic arithmetic in Q(zeta_n),
n | 330, and integer arithmetic in PSL(2,F_11).

PRODUCER METHOD.  Fixed strata are produced as IMAGES OF CHARACTER PROJECTORS
      P_chi = (1/|H|) sum_{h in H} chi(h)^{-1} rho(h),
one projector per one-dimensional character chi of H; the incidence poset is
produced by EXACT SUBSPACE CONTAINMENT of the resulting row-reduced bases.
Both are done on conjugacy-class representatives and then transported by the
elementary equivariance identity

      rho(g) . W_chi(H)  =  W_{chi o c_g^{-1}}(g H g^{-1}),        (*)

which the producer itself re-checks by projectors on a sample.  The sibling
verifier recomputes everything by deliberately different methods (an
independent subgroup enumeration by a different algorithm, direct
eigen-equation solving instead of projectors, character inner products instead
of projector ranks, and character restriction instead of subspace containment).

Output: source_complex.json (byte-reproducible; no timestamps inside).

Nothing outside this packet directory is read, written or imported.
"""
import json, os, sys
from fractions import Fraction
from math import gcd
from functools import lru_cache
from collections import deque, Counter

HERE = os.path.dirname(os.path.abspath(__file__))
def log(*a): print(*a, flush=True)

# ==========================================================================
# 0. exact arithmetic in Q(zeta_n) = Q[x]/Phi_n(x)
# ==========================================================================
def _polydiv_exact(a, b):
    a = list(a); db = len(b) - 1
    q = [0] * (len(a) - db)
    for i in range(len(a) - 1, db - 1, -1):
        c = a[i] // b[db]
        assert c * b[db] == a[i]
        q[i - db] = c
        for j in range(db + 1):
            a[i - db + j] -= c * b[j]
    assert all(x == 0 for x in a[:db])
    return q

@lru_cache(maxsize=None)
def cyclotomic_poly(n):
    poly = [-1] + [0] * (n - 1) + [1]
    for d in range(1, n):
        if n % d == 0:
            poly = _polydiv_exact(poly, list(cyclotomic_poly(d)))
    return tuple(poly)

class CycField:
    _cache = {}
    def __new__(cls, n):
        if n in cls._cache: return cls._cache[n]
        self = object.__new__(cls)
        self.n = n
        self.phi = list(cyclotomic_poly(n))
        self.deg = d = len(self.phi) - 1
        red = []
        cur = [-c for c in self.phi[:d]]
        for k in range(d, max(2 * d - 1, d + 1)):
            red.append(list(cur))
            nxt = [0] * d
            top = cur[d - 1]
            for i in range(d - 1, 0, -1): nxt[i] = cur[i - 1]
            if top:
                for i in range(d): nxt[i] += top * red[0][i]
            cur = nxt
        self.red = red
        cls._cache[n] = self
        return self
    def __repr__(self): return "Q(zeta_%d)" % self.n

class E:
    """element of Q(zeta_n): integer numerator tuple / positive integer denominator."""
    __slots__ = ('f', 'num', 'den')
    def __init__(self, f, num, den=1):
        if den < 0:
            den = -den; num = [-x for x in num]
        g = den
        for x in num:
            if x: g = gcd(g, x if x > 0 else -x)
        if g > 1:
            num = [x // g for x in num]; den //= g
        self.f = f; self.num = tuple(num); self.den = den
    @staticmethod
    def zero(f): return E(f, (0,) * f.deg, 1)
    @staticmethod
    def one(f):
        v = [0] * f.deg; v[0] = 1; return E(f, v, 1)
    @staticmethod
    def rat(f, p, q=1):
        v = [0] * f.deg; v[0] = p; return E(f, v, q)
    @staticmethod
    def zeta(f, k):
        k %= f.n
        if f.deg == 1: base = E._reduce_raw(f, [0, 1])
        else:
            v = [0] * f.deg; v[1] = 1; base = E(f, v, 1)
        return base ** k
    @staticmethod
    def _reduce_raw(f, v):
        d = f.deg
        v = list(v) + [0] * (d - len(v))
        for i in range(len(v) - 1, d - 1, -1):
            c = v[i]
            if c:
                v[i] = 0; row = f.red[i - d]
                for j in range(d): v[j] += c * row[j]
        return E(f, v[:d], 1)
    def __add__(a, b):
        assert a.f is b.f
        return E(a.f, [x * b.den + y * a.den for x, y in zip(a.num, b.num)], a.den * b.den)
    def __neg__(a): return E(a.f, [-x for x in a.num], a.den)
    def __sub__(a, b): return a + (-b)
    def __mul__(a, b):
        if isinstance(b, int): return E(a.f, [x * b for x in a.num], a.den)
        assert a.f is b.f
        d = a.f.deg; conv = [0] * (2 * d - 1)
        an, bn = a.num, b.num
        for i in range(d):
            x = an[i]
            if x:
                for j in range(d):
                    y = bn[j]
                    if y: conv[i + j] += x * y
        red = a.f.red
        for i in range(2 * d - 2, d - 1, -1):
            c = conv[i]
            if c:
                conv[i] = 0; row = red[i - d]
                for j in range(d): conv[j] += c * row[j]
        return E(a.f, conv[:d], a.den * b.den)
    __rmul__ = __mul__
    def __truediv__(a, b):
        if isinstance(b, int): return E(a.f, list(a.num), a.den * b)
        return a * b.inv()
    def __pow__(a, k):
        r = E.one(a.f); b = a
        while k:
            if k & 1: r = r * b
            b = b * b; k >>= 1
        return r
    def inv(a):
        assert any(a.num), "inversion of 0"
        f = a.f
        r0 = [Fraction(c) for c in f.phi]
        r1 = [Fraction(x, a.den) for x in a.num]
        s0 = [Fraction(0)]; s1 = [Fraction(1)]
        def deg(p):
            k = len(p) - 1
            while k >= 0 and p[k] == 0: k -= 1
            return k
        def submul(p, q, c, sh):
            out = list(p) + [Fraction(0)] * (len(q) + sh - len(p))
            for i, y in enumerate(q): out[i + sh] -= c * y
            return out
        while deg(r1) > 0:
            d0, d1 = deg(r0), deg(r1)
            if d0 < d1:
                r0, r1 = r1, r0; s0, s1 = s1, s0; continue
            c = r0[d0] / r1[d1]
            r0 = submul(r0, r1, c, d0 - d1)
            s0 = submul(s0, s1, c, d0 - d1)
            r0, r1 = r1, r0; s0, s1 = s1, s0
        assert deg(r1) == 0
        c = r1[0]
        co = [x / c for x in s1]
        den = 1
        for x in co: den = den * x.denominator // gcd(den, x.denominator)
        res = E._reduce_raw(f, [int(x * den) for x in co])
        return E(f, res.num, res.den * den)
    def __bool__(a): return any(a.num)
    def __eq__(a, b):
        if isinstance(b, int): b = E.rat(a.f, b)
        return a.f is b.f and a.num == b.num and a.den == b.den
    def __hash__(a): return hash((a.f.n, a.num, a.den))
    def __repr__(a): return "E%d%s/%d" % (a.f.n, a.num, a.den)
    def up(a, f2):
        if a.f is f2: return a
        assert f2.n % a.f.n == 0, (a.f.n, f2.n)
        img = _embed_images(a.f.n, f2.n)
        acc = E.zero(f2)
        for i, c in enumerate(a.num):
            if c: acc = acc + img[i] * c
        return acc / a.den
    def conj(a):
        """complex conjugation zeta_n -> zeta_n^{-1}."""
        f = a.f
        img = _conj_images(f.n)
        acc = E.zero(f)
        for i, c in enumerate(a.num):
            if c: acc = acc + img[i] * c
        return acc / a.den
    def js(a): return {"f": a.f.n, "num": list(a.num), "den": a.den}

def LCM(a, b): return a * b // gcd(a, b)

@lru_cache(maxsize=None)
def _embed_images(n1, n2):
    f1, f2 = CycField(n1), CycField(n2)
    k = n2 // n1
    return [E.zeta(f2, (k * i) % n2) for i in range(f1.deg)]

@lru_cache(maxsize=None)
def _conj_images(n):
    f = CycField(n)
    return [E.zeta(f, (-i) % n) for i in range(f.deg)]

def is_int(x):
    return x.den == 1 and all(c == 0 for c in x.num[1:])
def to_int(x):
    assert is_int(x), ("not a rational integer", x)
    return int(x.num[0])

# ==========================================================================
# 1. the exact Weil representation and the group PSL(2,11)
# ==========================================================================
F11 = CycField(11)

def build_rep():
    """S, T exactly as in certificates/exact_weil_check.py (rebuilt, not imported)."""
    f = F11
    zp = [E.zeta(f, i) for i in range(11)]
    qr = {1, 3, 4, 5, 9}
    g = E.zero(f)
    for a in range(1, 11): g = g + zp[a] * (1 if a in qr else -1)
    assert g * g == E.rat(f, -11), "Gauss sum g^2 = -11"
    js = [1, 3, 2, 5, 4]; signs = [1, 1, -1, 1, 1]
    S = [[(zp[(9 * js[i] * js[k]) % 11] - zp[(-9 * js[i] * js[k]) % 11])
          * (signs[k] * signs[i]) * (-g) / 11 for k in range(5)] for i in range(5)]
    T = [[zp[(js[i] * js[i]) % 11] if i == j else E.zero(f) for j in range(5)] for i in range(5)]
    return S, T

def matmul(A, B):
    n = len(A); z = E.zero(A[0][0].f)
    return [[sum((A[i][k] * B[k][j] for k in range(n)), z) for j in range(n)] for i in range(n)]
def ident(f, n=5):
    return [[E.one(f) if i == j else E.zero(f) for j in range(n)] for i in range(n)]
def fmul(A, B):
    return ((A[0]*B[0]+A[1]*B[2]) % 11, (A[0]*B[1]+A[1]*B[3]) % 11,
            (A[2]*B[0]+A[3]*B[2]) % 11, (A[2]*B[1]+A[3]*B[3]) % 11)
def fcanon(A):
    A = tuple(a % 11 for a in A)
    return min(A, tuple((-a) % 11 for a in A))

def build_group():
    S, T = build_rep()
    I = ident(F11)
    assert matmul(S, S) == I, "S^2 = 1"
    P = I
    for _ in range(11): P = matmul(P, T)
    assert P == I, "T^11 = 1"
    ST = matmul(S, T)
    assert matmul(matmul(ST, ST), ST) == I, "(ST)^3 = 1"
    fone = fcanon((1, 0, 0, 1)); fs = fcanon((0, 2, 5, 0)); ft = fcanon((1, 2, 0, 1))
    rho = {fone: I}; q = deque([fone])
    while q:
        a = q.popleft()
        for b, R in ((fs, S), (ft, T)):
            c = fcanon(fmul(a, b)); M = matmul(rho[a], R)
            if c in rho: assert rho[c] == M, "representation inconsistency on the Cayley graph"
            else: rho[c] = M; q.append(c)
    assert len(rho) == 660, len(rho)
    els = sorted(rho)                       # deterministic lexicographic indexing
    return els, [rho[e] for e in els], S, T

log("[1] group + representation")
ELS, RHO, Smat, Tmat = build_group()
IDX = {e: i for i, e in enumerate(ELS)}
NG = 660
ONE = IDX[fcanon((1, 0, 0, 1))]
MUL = [[IDX[fcanon(fmul(a, b))] for b in ELS] for a in ELS]
INV = [next(j for j in range(NG) if MUL[i][j] == ONE) for i in range(NG)]

def eorder(i):
    k = 1; c = i
    while c != ONE: c = MUL[c][i]; k += 1
    return k
ORD = [eorder(i) for i in range(NG)]
CHI_W = []
for i in range(NG):
    M = RHO[i]; t = E.zero(F11)
    for k in range(5): t = t + M[k][k]
    CHI_W.append(t)
assert sorted(Counter(ORD).items()) == [(1, 1), (2, 55), (3, 110), (5, 264), (6, 110), (11, 120)]
log("    |G| = 660, element orders {1,2,3,5,6,11} with profile 1/55/110/264/110/120")

_RHO_EMB = {}
def rho_in(g, f):
    key = (g, f.n); M = _RHO_EMB.get(key)
    if M is None:
        M = [[x.up(f) for x in row] for row in RHO[g]]; _RHO_EMB[key] = M
    return M
def apply_rho(g, v, f):
    M = rho_in(g, f); z = E.zero(f)
    return tuple(sum((M[i][j] * v[j] for j in range(5) if v[j]), z) for i in range(5))

def element_classes():
    seen = set(); out = []
    for x in range(NG):
        if x in seen: continue
        orb = set(MUL[MUL[g][x]][INV[g]] for g in range(NG))
        seen |= orb; out.append(sorted(orb))
    return sorted(out, key=lambda c: (ORD[c[0]], -len(c), c[0]))
ECLASSES = element_classes()
assert len(ECLASSES) == 8

# ==========================================================================
# 2. subgroups, conjugacy classes of subgroups, normalizers
# ==========================================================================
def closure(gens):
    elems = {ONE}; frontier = [ONE]
    while frontier:
        new = []
        for a in frontier:
            ra = MUL[a]
            for s in gens:
                c = ra[s]
                if c not in elems: elems.add(c); new.append(c)
        frontier = new
    return frozenset(elems)

log("[2] subgroup lattice")
# All element orders in G are squarefree, hence every subgroup is generated by
# elements of prime order; extending one generator at a time from the trivial
# subgroup therefore reaches every subgroup of G.
PRIME_ORD = [i for i in range(NG) if ORD[i] in (2, 3, 5, 11)]
SUBS = {frozenset([ONE]): []}
q = deque([frozenset([ONE])])
while q:
    H = q.popleft(); Hg = SUBS[H]
    covered = set(H); reps = []
    for g in PRIME_ORD:
        if g in covered: continue
        reps.append(g)
        for h in H: covered.add(MUL[h][g])
    for g in reps:
        K = closure(Hg + [g])
        if K not in SUBS:
            SUBS[K] = Hg + [g]; q.append(K)
SUBLIST = sorted(SUBS, key=lambda H: (len(H), sorted(H)))
SUBID = {H: i for i, H in enumerate(SUBLIST)}
NSUB = len(SUBLIST)
log("    %d subgroups" % NSUB)

CONJ = [[MUL[MUL[g][x]][INV[g]] for x in range(NG)] for g in range(NG)]
def conj_sub(g, H): return frozenset(CONJ[g][x] for x in H)

CLASS_OF = [None] * NSUB
CONJUGATOR = [None] * NSUB          # g with  g . rep . g^{-1} = SUBLIST[i]
CLASSES = []
for H in SUBLIST:
    if CLASS_OF[SUBID[H]] is not None: continue
    orb = {}; norm = []
    for g in range(NG):
        K = conj_sub(g, H)
        if K not in orb: orb[K] = g
        if K == H: norm.append(g)
    cid = len(CLASSES)
    for K, g in orb.items():
        CLASS_OF[SUBID[K]] = cid; CONJUGATOR[SUBID[K]] = g
    CLASSES.append({"rep": SUBID[H], "size": len(orb),
                    "members": sorted(SUBID[K] for K in orb),
                    "normalizer": frozenset(norm)})
for i in range(NSUB):
    assert conj_sub(CONJUGATOR[i], SUBLIST[CLASSES[CLASS_OF[i]]["rep"]]) == SUBLIST[i]
log("    %d conjugacy classes of subgroups" % len(CLASSES))

@lru_cache(maxsize=None)
def derived(H):
    gens = set()
    Hl = sorted(H)
    for a in Hl:
        ia = INV[a]
        for b in Hl:
            c = MUL[MUL[MUL[a][b]][ia]][INV[b]]
            if c != ONE: gens.add(c)
    return closure(sorted(gens)) if gens else frozenset([ONE])

def name_group(order, prof, abelian):
    if order == 1: return "1"
    if abelian:
        if prof.get(order, 0) > 0: return "C%d" % order
        if order == 4: return "V4"
        return "Ab%d" % order
    if order == 6: return "S3"
    if order == 10: return "D10"
    if order == 12: return "A4" if prof.get(3, 0) == 8 else "D12"
    if order == 55: return "C11:C5"
    if order == 60: return "A5"
    if order == 660: return "PSL(2,11)"
    return "G%d" % order

def group_info(H):
    prof = dict(Counter(ORD[x] for x in H))
    D = derived(H); ab = (len(D) == 1)
    return {"order": len(H), "order_profile": {str(k): v for k, v in sorted(prof.items())},
            "abelian": ab, "derived_order": len(D), "name": name_group(len(H), prof, ab)}

for c in CLASSES:
    H = SUBLIST[c["rep"]]
    c["info"] = group_info(H)
    c["normalizer_info"] = group_info(c["normalizer"])

@lru_cache(maxsize=None)
def class_list(H):
    """conjugacy classes of the abstract group H."""
    seen = set(); out = []
    Hl = sorted(H)
    for x in Hl:
        if x in seen: continue
        orb = frozenset(MUL[MUL[g][x]][INV[g]] for g in Hl)
        seen |= orb; out.append(tuple(sorted(orb)))
    return tuple(sorted(out, key=lambda c: (ORD[c[0]], -len(c), c[0])))

# ==========================================================================
# 3. linear characters of every subgroup (via H/[H,H])
# ==========================================================================
log("[3] linear characters of all %d subgroups" % NSUB)
def linear_characters(H):
    D = derived(H)
    Hl = sorted(H)
    rep_of = {}; cosets = []
    for x in Hl:
        if x in rep_of: continue
        cs = frozenset(MUL[x][d] for d in D); r = min(cs)
        for y in cs: rep_of[y] = r
        cosets.append(r)
    cosets = sorted(cosets)
    EID = rep_of[ONE]                     # the identity coset (NOT necessarily ONE)
    def qmul(a, b): return rep_of[MUL[a][b]]
    def qclosure(gs):
        S = {EID}; fr = [EID]
        while fr:
            nw = []
            for a in fr:
                for s in gs:
                    c = qmul(a, s)
                    if c not in S: S.add(c); nw.append(c)
            fr = nw
        return S
    def qorder(x):
        k = 1; c = x
        while c != EID: c = qmul(c, x); k += 1
        return k
    gens = []; ordsq = []; span = {EID}
    while len(span) < len(cosets):
        cand = sorted([x for x in cosets if x not in span], key=lambda x: (-qorder(x), x))
        chosen = None
        for x in cand:
            ns = qclosure(gens + [x])
            if len(ns) == len(span) * qorder(x): chosen = x; break
        assert chosen is not None, "abelian quotient decomposition failed"
        gens.append(chosen); ordsq.append(qorder(chosen)); span = qclosure(gens)
    expvec = {EID: tuple([0] * len(gens))}
    fr = [EID]
    while fr:
        nw = []
        for a in fr:
            for i, s in enumerate(gens):
                c = qmul(a, s)
                if c not in expvec:
                    v = list(expvec[a]); v[i] = (v[i] + 1) % ordsq[i]
                    expvec[c] = tuple(v); nw.append(c)
        fr = nw
    assert len(expvec) == len(cosets), "exponent vectors incomplete"
    e = 1
    for o in ordsq: e = LCM(e, o)
    f = CycField(LCM(11, e))
    keys = [()]
    for i in range(len(gens)):
        keys = [k + (t,) for k in keys for t in range(ordsq[i])]
    keys.sort()
    out = []
    for kv in keys:
        vals = {}
        for h in Hl:
            ev = expvec[rep_of[h]]
            t = sum(kv[i] * ev[i] * (f.n // ordsq[i]) for i in range(len(gens)))
            vals[h] = E.zeta(f, t % f.n)
        out.append({"key": kv, "vals": vals})
    return {"field": f, "chars": out, "gens": gens, "gen_orders": ordsq,
            "derived": sorted(D)}

SUBCH = [linear_characters(H) for H in SUBLIST]
for i in range(NSUB):
    r = CLASSES[CLASS_OF[i]]["rep"]
    assert SUBCH[i]["field"] is SUBCH[r]["field"]
    assert len(SUBCH[i]["chars"]) == len(SUBCH[r]["chars"])

_ACT_CHAR = {}
def act_char(g, si, ci):
    """g . (H, chi) = (gHg^{-1}, chi o c_g^{-1}); returns (subgroup id, char index)."""
    key = (g, si, ci)
    r = _ACT_CHAR.get(key)
    if r is not None: return r
    H = SUBLIST[si]; K = conj_sub(g, H); sj = SUBID[K]
    src = SUBCH[si]["chars"][ci]["vals"]
    tgt = {h: src[MUL[MUL[INV[g]][h]][g]] for h in K}
    cj = None
    for j, ch in enumerate(SUBCH[sj]["chars"]):
        if all(ch["vals"][h] == tgt[h] for h in K): cj = j; break
    assert cj is not None, "conjugated character not found"
    _ACT_CHAR[key] = (sj, cj)
    return sj, cj

# ==========================================================================
# 4. linear algebra over Q(zeta_n)
# ==========================================================================
def rref(rows):
    M = [list(r) for r in rows]; piv = []; r = 0
    ncol = len(M[0]) if M else 0
    for c in range(ncol):
        p = None
        for i in range(r, len(M)):
            if M[i][c]: p = i; break
        if p is None: continue
        M[r], M[p] = M[p], M[r]
        iv = M[r][c].inv(); M[r] = [x * iv for x in M[r]]
        for i in range(len(M)):
            if i != r and M[i][c]:
                fac = M[i][c]
                M[i] = [x - fac * y for x, y in zip(M[i], M[r])]
        piv.append(c); r += 1
        if r == len(M): break
    return [tuple(M[i]) for i in range(r)], piv

def subspace(rows, f):
    B, piv = rref(rows)
    return {"basis": B, "pivots": piv, "dim": len(B), "field": f}

def in_subspace(v, sub):
    v = list(v)
    for row, c in zip(sub["basis"], sub["pivots"]):
        if v[c]:
            fac = v[c]; v = [x - fac * y for x, y in zip(v, row)]
    return not any(v)

_EMB_SUB = {}
def embed_sub(sub, f2):
    if sub["field"] is f2: return sub
    key = (id(sub), f2.n)
    r = _EMB_SUB.get(key)
    if r is None:
        r = {"basis": [tuple(x.up(f2) for x in b) for b in sub["basis"]],
             "pivots": sub["pivots"], "dim": sub["dim"], "field": f2}
        _EMB_SUB[key] = r
    return r

def contains(big, small):
    """is the subspace `small` contained in the subspace `big`?  (exact)"""
    if small["dim"] > big["dim"]: return False
    nf = CycField(LCM(big["field"].n, small["field"].n))
    B = embed_sub(big, nf)
    return all(in_subspace(tuple(x.up(nf) for x in v), B) for v in small["basis"])

# ==========================================================================
# 5. strata of the class representatives, via character projectors
# ==========================================================================
log("[4] strata of the 16 class representatives by character projectors")
REP_STRATA = {}          # class id -> list of (char index, subspace)
for cid, c in enumerate(CLASSES):
    si = c["rep"]; H = SUBLIST[si]; sc = SUBCH[si]; f = sc["field"]
    out = []
    for ci, ch in enumerate(sc["chars"]):
        P = [[E.zero(f) for _ in range(5)] for _ in range(5)]
        for h in sorted(H):
            co = ch["vals"][h].inv(); Rh = rho_in(h, f)
            for i in range(5):
                for j in range(5):
                    if Rh[i][j]: P[i][j] = P[i][j] + co * Rh[i][j]
        P = [[x / len(H) for x in row] for row in P]
        cols = [tuple(P[i][j] for i in range(5)) for j in range(5)]   # image = column span
        sp = subspace(cols, f)
        # projector identity  P^2 = P  (internal consistency of the producer)
        P2 = [[sum((P[i][k] * P[k][j] for k in range(5)), E.zero(f)) for j in range(5)]
              for i in range(5)]
        assert P2 == P, "projector is not idempotent"
        if sp["dim"]: out.append((ci, sp))
    REP_STRATA[cid] = out
    log("    %-10s |H|=%3d : %s" % (c["info"]["name"], len(H),
        " ".join("chi%d:P^%d" % (ci, sp["dim"] - 1) for ci, sp in out) or "EMPTY"))

# strata of an arbitrary subgroup, by equivariant transport (*)
_STRAT_SPACE = {}
def stratum_space(si, ci):
    key = (si, ci)
    r = _STRAT_SPACE.get(key)
    if r is not None: return r
    cid = CLASS_OF[si]; rep = CLASSES[cid]["rep"]
    if si == rep:
        r = dict(REP_STRATA[cid])[ci]
    else:
        g = CONJUGATOR[si]
        ci0 = None
        for c0, sp in REP_STRATA[cid]:
            if act_char(g, rep, c0) == (si, ci): ci0 = c0; sp0 = sp; break
        assert ci0 is not None, "no source character for transport"
        f = sp0["field"]
        r = subspace([apply_rho(g, b, f) for b in sp0["basis"]], f)
    _STRAT_SPACE[key] = r
    return r

# global stratum inventory
STRATA = []; SID = {}
for si in range(NSUB):
    cid = CLASS_OF[si]; rep = CLASSES[cid]["rep"]; g = CONJUGATOR[si]
    for ci0, sp in REP_STRATA[cid]:
        sj, cj = act_char(g, rep, ci0)
        assert sj == si
        SID[(si, cj)] = len(STRATA)
        STRATA.append({"sub": si, "char": cj, "vdim": sp["dim"], "dim": sp["dim"] - 1,
                       "class": cid, "rep_char": ci0, "conjugator": g})
log("    %d strata (H,F) in total" % len(STRATA))

# producer-internal spot check of the transport identity (*) against projectors
import random
rnd = random.Random(20260804)
spot = 0
for si in rnd.sample(range(NSUB), 40):
    H = SUBLIST[si]; sc = SUBCH[si]; f = sc["field"]
    for ci, ch in enumerate(sc["chars"]):
        P = [[E.zero(f) for _ in range(5)] for _ in range(5)]
        for h in sorted(H):
            co = ch["vals"][h].inv(); Rh = rho_in(h, f)
            for i in range(5):
                for j in range(5):
                    if Rh[i][j]: P[i][j] = P[i][j] + co * Rh[i][j]
        P = [[x / len(H) for x in row] for row in P]
        sp = subspace([tuple(P[i][j] for i in range(5)) for j in range(5)], f)
        if (si, ci) in SID:
            t = stratum_space(si, ci)
            assert sp["dim"] == t["dim"] and contains(t, sp) and contains(sp, t), \
                "transport disagrees with the projector"
        else:
            assert sp["dim"] == 0, "projector found a stratum the transport missed"
        spot += 1
log("    transport identity (*) re-checked against projectors on %d (subgroup,character) pairs" % spot)

# ==========================================================================
# 6. decorations
# ==========================================================================
log("[5] decorations")
def char_inner(H, v1, v2, f):
    acc = E.zero(f)
    for h in H: acc = acc + v1[h] * v2[h].conj()
    return acc / len(H)

def induced_char(H, C, lam, f):
    out = {}
    for h in H:
        acc = E.zero(f)
        for x in H:
            y = MUL[MUL[INV[x]][h]][x]
            if y in C: acc = acc + lam[y].up(f)
        out[h] = acc / len(C)
    return out

@lru_cache(maxsize=None)
def irreducible_characters(H):
    """irreducible characters of H by inducing linear characters of cyclic subgroups
    and sieving.  Complete exactly when the returned flag is True (certified by
    #irreducibles = #classes and sum of squares of degrees = |H|)."""
    e = 1
    for x in H: e = LCM(e, ORD[x])
    f = CycField(LCM(11, e))
    cl = class_list(H)
    if len(H) > 60:            # the full table of G itself is not needed anywhere
        return f, (), False
    pool = []
    for C in sorted({closure([x]) for x in H}, key=lambda c: (len(c), sorted(c))):
        lc = linear_characters(C)
        for ch in lc["chars"]:
            pool.append(induced_char(H, C, ch["vals"], f))
    # the linear characters of H are irreducible; seed the sieve with them
    irr = [{h: ch["vals"][h].up(f) for h in H} for ch in linear_characters(H)["chars"]]
    one = E.one(f)
    changed = True
    while changed and len(irr) < len(cl):
        changed = False
        newpool = []
        for v in pool:
            w = dict(v)
            for u in irr:
                m = char_inner(H, w, u, f)
                if m:
                    k = to_int(m)
                    w = {h: w[h] - u[h] * k for h in H}
            if not any(w.values()): continue
            nn = char_inner(H, w, w, f)
            if nn == one and to_int(w[ONE]) > 0:
                if not any(all(w[h] == u[h] for h in H) for u in irr):
                    irr.append(w); changed = True
            else:
                newpool.append(w)
        pool = newpool
    complete = (len(irr) == len(cl) and sum(to_int(u[ONE]) ** 2 for u in irr) == len(H))
    irr.sort(key=lambda u: (to_int(u[ONE]), [tuple(u[c[0]].num) for c in cl]))
    return f, tuple(tuple(u[c[0]] for c in cl) for u in irr), complete

def decompose(H, vals, f):
    """multiplicities of the irreducible characters in the class function `vals`."""
    f2, irr, complete = irreducible_characters(H)
    cl = class_list(H)
    if not complete: return None, False
    out = []
    for u in irr:
        acc = E.zero(f2)
        for c, uv in zip(cl, u):
            acc = acc + vals[c[0]].up(f2) * uv.conj() * len(c)
        m = acc / len(H)
        out.append({"degree": to_int(u[0]),
                    "values": [x.js() for x in u], "mult": to_int(m)})
    return out, True

def char_on_classes(H, vals):
    return [{"element_order": ORD[c[0]], "class_size": len(c), "value": vals[c[0]].js()}
            for c in class_list(H)]

DEC = {}          # (class id, rep char index) -> decoration dict
for cid, c in enumerate(CLASSES):
    si = c["rep"]; H = SUBLIST[si]; sc = SUBCH[si]; f = sc["field"]
    NH = c["normalizer"]
    for ci, sp in REP_STRATA[cid]:
        d = sp["dim"]; ch = sc["chars"][ci]
        # normal representation N = chi^{-1} tensor (W/W_chi):  nu(h) = conj(chi(h)) chi_W(h) - d
        nu = {h: ch["vals"][h].conj() * CHI_W[h].up(f) - E.rat(f, d) for h in H}
        linmult = [to_int(char_inner(H, nu, c2["vals"], f)) for c2 in sc["chars"]]
        triv = next(i for i, c2 in enumerate(sc["chars"]) if all(k == 0 for k in c2["key"]))
        assert linmult[triv] == 0, "trivial character occurs in the normal type"
        assert sum(linmult) <= 5 - d
        irrdec, ok = decompose(H, nu, f)
        # residual action: stabiliser of F inside N_G(H), by exact linear algebra
        stab = []
        for g in sorted(NH):
            if all(in_subspace(apply_rho(g, b, sp["field"]), sp) for b in sp["basis"]):
                stab.append(g)
        stab = frozenset(stab)
        assert H <= stab
        # group-theoretic cross-check: stabiliser of the character
        stab2 = frozenset(g for g in NH if act_char(g, si, ci) == (si, ci))
        assert stab == stab2, "stabiliser mismatch (subspace vs character)"
        # pointwise stabiliser of F: the largest subgroup acting on W_chi by a scalar
        # (H is contained in it; equality can fail, e.g. the C3-fixed point is D12-fixed)
        pw = []
        for g in range(NG):
            im = [apply_rho(g, b, sp["field"]) for b in sp["basis"]]
            if not all(in_subspace(w, sp) for w in im): continue
            lam = None; scalar = True
            for b, w in zip(sp["basis"], im):
                k = next(i for i in range(5) if b[i])
                mu = w[k] / b[k]
                if lam is None: lam = mu
                elif mu != lam: scalar = False; break
                if any(w[i] != b[i] * mu for i in range(5)): scalar = False; break
            if scalar: pw.append(g)
        pw = frozenset(pw)
        assert H <= pw and pw in SUBID, "pointwise stabiliser is not a subgroup containing H"
        DEC[(cid, ci)] = {"normal_char": nu, "normal_dim": 5 - d, "normal_linear_mult": linmult,
                          "normal_irr": irrdec, "normal_irr_complete": ok,
                          "stab": stab, "orbit_size": NG // len(stab), "space": sp,
                          "pointwise": pw}
log("    normal types, residual stabilisers and irreducible decompositions computed")

# ==========================================================================
# 7. orbits of strata (purely group-theoretic action on the labels)
# ==========================================================================
log("[6] G-orbits of strata")
ORBIT_OF = [None] * len(STRATA)
ORBITS = []
for k, s in enumerate(STRATA):
    if ORBIT_OF[k] is not None: continue
    orb = set()
    for g in range(NG):
        sj, cj = act_char(g, s["sub"], s["char"])
        orb.add(SID[(sj, cj)])
    oid = len(ORBITS)
    for t in orb: ORBIT_OF[t] = oid
    ORBITS.append({"rep": k, "size": len(orb), "members": sorted(orb)})
for o in ORBITS:
    s = STRATA[o["rep"]]
    dec = DEC[(s["class"], s["rep_char"])]
    assert o["size"] == dec["orbit_size"], (o["size"], dec["orbit_size"])
log("    %d stratum orbits; |orbit| = |G|/|Stab| verified for each" % len(ORBITS))

# ==========================================================================
# 8. the incidence poset  (H,F) <= (H',F')  iff  H >= H'  and  F <= F'
# ==========================================================================
log("[7] incidence poset")
SUBS_OF = [[] for _ in range(NSUB)]
for i, K in enumerate(SUBLIST):
    for j, H in enumerate(SUBLIST):
        if j != i and H <= K: SUBS_OF[i].append(j)

REP_EDGES = []      # edges whose lower stratum sits on a class representative
for cid, c in enumerate(CLASSES):
    si = c["rep"]
    for ci, sp in REP_STRATA[cid]:
        lo = SID[(si, ci)]
        for sj in SUBS_OF[si]:
            found = []
            for cj in range(len(SUBCH[sj]["chars"])):
                if (sj, cj) not in SID: continue
                t = stratum_space(sj, cj)
                if contains(t, sp): found.append(SID[(sj, cj)])
            assert len(found) == 1, ("the containing stratum is not unique", lo, sj, found)
            REP_EDGES.append((lo, found[0]))
log("    %d poset edges at the level of class representatives" % len(REP_EDGES))

def act_stratum(g, k):
    s = STRATA[k]; sj, cj = act_char(g, s["sub"], s["char"])
    return SID[(sj, cj)]

EDGESET = set()
for (lo, hi) in REP_EDGES:
    for g in range(NG):
        EDGESET.add((act_stratum(g, lo), act_stratum(g, hi)))
EDGES = sorted(EDGESET)
log("    %d poset edges in total (G-transported)" % len(EDGES))

# cross-check: the character-restriction description of the same poset
chk = 0
for (lo, hi) in EDGES:
    a, b = STRATA[lo], STRATA[hi]
    assert SUBLIST[b["sub"]] <= SUBLIST[a["sub"]]
    va = SUBCH[a["sub"]]["chars"][a["char"]]["vals"]
    vb = SUBCH[b["sub"]]["chars"][b["char"]]["vals"]
    f = CycField(LCM(va[ONE].f.n, vb[ONE].f.n))
    assert all(va[h].up(f) == vb[h].up(f) for h in SUBLIST[b["sub"]]), \
        "edge is not a character restriction"
    chk += 1
log("    all %d edges satisfy chi_upper = chi_lower restricted (independent description)" % chk)

# every (stratum, smaller subgroup) pair must give exactly one edge
cnt = Counter(lo for lo, hi in EDGES)
for k, s in enumerate(STRATA):
    assert cnt.get(k, 0) == len(SUBS_OF[s["sub"]]), ("missing/extra up-edges", k)

# orbit level table
UP = {}
for (lo, hi) in EDGES:
    UP.setdefault((ORBIT_OF[lo], ORBIT_OF[hi]), Counter())[lo] += 1
ORB_TABLE = []
for (a, b), cnt2 in sorted(UP.items()):
    vals = set(cnt2.get(x, 0) for x in ORBITS[a]["members"])
    assert len(vals) == 1, ("non-constant up-multiplicity", a, b, vals)
    up = vals.pop()
    rb = ORBITS[b]["rep"]
    down = sum(1 for (lo, hi) in EDGES if hi == rb and ORBIT_OF[lo] == a)
    assert ORBITS[a]["size"] * up == ORBITS[b]["size"] * down, "double counting fails"
    ORB_TABLE.append({"lower_orbit": a, "upper_orbit": b, "up_multiplicity": up,
                      "down_multiplicity": down})
log("    orbit-level poset: %d relations, double counting verified" % len(ORB_TABLE))

# ==========================================================================
# 9. sanity identities
# ==========================================================================
log("[8] sanity identities")
SANITY = {}
fails = []

# (a) Euler / Lefschetz
euler = []
for si in range(NSUB):
    tot = sum(STRATA[SID[(si, ci)]]["vdim"] for ci in range(len(SUBCH[si]["chars"]))
              if (si, ci) in SID)
    ab = len(SUBCH[si]["derived"]) == 1
    if (tot == 5) != ab: fails.append(("euler", si))
    euler.append(tot)
SANITY["euler_lefschetz"] = {
    "statement": "for every H <= G, sum over the components F of P(W)^H of (dim F + 1) equals "
                 "the dimension of the sum of the one-dimensional isotypic pieces of W|_H; it "
                 "equals 5 exactly for abelian H.  For cyclic H this is the Lefschetz count "
                 "chi_top(P(W)^H) = chi_top(P^4) = 5 (G acts trivially on H^*(P^4,Q)).",
    "subgroups_checked": NSUB, "failures": 0}

# (b) chi_top(P(W)^g) = 5 for every single element g
for g in range(NG):
    si = SUBID[closure([g])]
    tot = sum(STRATA[SID[(si, ci)]]["vdim"] for ci in range(len(SUBCH[si]["chars"]))
              if (si, ci) in SID)
    if tot != 5: fails.append(("lefschetz-element", g))
SANITY["lefschetz_per_element"] = {
    "statement": "chi_top(Fix(g,P^4)) = 5 for all 660 elements g of G",
    "elements_checked": NG, "failures": 0}

# (c) totals
SANITY["totals"] = {"subgroups": NSUB, "subgroup_classes": len(CLASSES),
                    "strata": len(STRATA), "stratum_orbits": len(ORBITS),
                    "poset_edges": len(EDGES),
                    "strata_by_class": {"%d:%s" % (c, CLASSES[c]["info"]["name"]):
                                        sum(1 for s in STRATA if s["class"] == c)
                                        for c in range(len(CLASSES))}}

# (d) what lies inside the two C2 strata and inside the V4 line
def orbit_label(oid):
    o = ORBITS[oid]; s = STRATA[o["rep"]]
    return "%s/chi%s" % (CLASSES[s["class"]]["info"]["name"],
                         "".join(str(t) for t in SUBCH[s["sub"]]["chars"][s["char"]]["key"]))
DEEPER = []
for oid, o in enumerate(ORBITS):
    rep = o["rep"]
    below = Counter(ORBIT_OF[lo] for (lo, hi) in EDGES if hi == rep)
    DEEPER.append({"orbit": oid, "label": orbit_label(oid), "dim": STRATA[rep]["dim"],
                   "deeper_strata": [{"orbit": k, "label": orbit_label(k), "count": v,
                                      "dim": STRATA[ORBITS[k]["rep"]]["dim"]}
                                     for k, v in sorted(below.items())]})
SANITY["deeper_strata_per_orbit"] = DEEPER
assert not fails, fails
SANITY["failures"] = 0

# ==========================================================================
# 10. payload
# ==========================================================================
log("[9] payload")
def js_vec(v): return [x.js() for x in v]

def quotient_info(Stab, H):
    Sl = sorted(Stab); rep = {}; cos = []
    for x in Sl:
        if x in rep: continue
        cs = frozenset(MUL[x][h] for h in H); r = min(cs)
        for y in cs: rep[y] = r
        cos.append(r)
    EID = rep[ONE]
    def qm(a, b): return rep[MUL[a][b]]
    def qo(x):
        k = 1; c = x
        while c != EID: c = qm(c, x); k += 1
        return k
    prof = dict(Counter(qo(x) for x in cos))
    ab = all(qm(a, b) == qm(b, a) for a in cos for b in cos)
    return {"order": len(cos), "order_profile": {str(k): v for k, v in sorted(prof.items())},
            "abelian": ab, "name": name_group(len(cos), prof, ab), "cosets": sorted(cos)}

CLASS_JS = []
for cid, c in enumerate(CLASSES):
    si = c["rep"]; H = SUBLIST[si]; sc = SUBCH[si]; f = sc["field"]
    chiW = {h: CHI_W[h].up(f) for h in H}
    linmult = [to_int(char_inner(H, chiW, ch["vals"], f)) for ch in sc["chars"]]
    normW = char_inner(H, chiW, chiW, f)
    irrdec, ok = decompose(H, chiW, f)
    shapes = []
    for ci, sp in REP_STRATA[cid]:
        shapes.append("P^%d" % (sp["dim"] - 1))
    CLASS_JS.append({
        "class_id": cid, "name": c["info"]["name"], "order": c["info"]["order"],
        "number_of_conjugates": c["size"], "order_profile": c["info"]["order_profile"],
        "abelian": c["info"]["abelian"], "derived_subgroup_order": c["info"]["derived_order"],
        "normalizer": {"order": c["normalizer_info"]["order"],
                       "name": c["normalizer_info"]["name"],
                       "order_profile": c["normalizer_info"]["order_profile"],
                       "index_of_H": c["normalizer_info"]["order"] // c["info"]["order"]},
        "representative_subgroup_id": si,
        "representative_elements_psl": [list(ELS[x]) for x in sorted(H)],
        "abelianization": {"invariant_factors": SUBCH[si]["gen_orders"],
                           "generators_psl": [list(ELS[g]) for g in SUBCH[si]["gens"]],
                           "number_of_linear_characters": len(sc["chars"])},
        "W_restricted_to_H": {
            "field": f.n,
            "linear_character_multiplicities": [
                {"char_key": list(ch["key"]), "mult": m} for ch, m in zip(sc["chars"], linmult)],
            "sum_of_linear_isotypic_dims": sum(linmult),
            "character_norm": normW.js(), "irreducible": (normW == E.one(f)),
            "irreducible_decomposition": irrdec, "decomposition_certified": ok,
            "character_values": char_on_classes(H, chiW)},
        "fixed_locus_shape": (" u ".join(shapes) if shapes else "empty"),
        "fixed_locus_components": len(REP_STRATA[cid]),
    })

ORBIT_JS = []
for oid, o in enumerate(ORBITS):
    k = o["rep"]; s = STRATA[k]; cid = s["class"]; ci = s["rep_char"]
    si = s["sub"]; H = SUBLIST[si]; sc = SUBCH[si]; f = sc["field"]
    dec = DEC[(cid, ci)]; sp = dec["space"]
    qi = quotient_info(dec["stab"], H)
    act = []
    for r in qi["cosets"]:
        M = []
        for b in sp["basis"]:
            w = list(apply_rho(r, b, f)); co = []
            for row, cpos in zip(sp["basis"], sp["pivots"]):
                co.append(w[cpos]); fac = w[cpos]
                w = [x - fac * y for x, y in zip(w, row)]
            assert not any(w), "residual element does not preserve the stratum"
            M.append(co)
        act.append({"coset_rep_psl": list(ELS[r]), "element_order_in_G": ORD[r],
                    "matrix_rows_on_basis": [[x.js() for x in row] for row in M]})
    ORBIT_JS.append({
        "orbit_id": oid, "label": orbit_label(oid), "orbit_size": o["size"],
        "representative_stratum_id": k,
        "subgroup_class": cid, "subgroup_class_name": CLASSES[cid]["info"]["name"],
        "subgroup_id": si, "subgroup_elements_psl": [list(ELS[x]) for x in sorted(H)],
        "character_key": list(sc["chars"][ci]["key"]),
        "character_values": char_on_classes(H, sc["chars"][ci]["vals"]),
        "delta_dim": s["dim"],
        "delta_nr": {
            "dim": dec["normal_dim"],
            "linear_character_multiplicities": [
                {"char_key": list(c2["key"]), "mult": m}
                for c2, m in zip(sc["chars"], dec["normal_linear_mult"])],
            "linear_part_dim": sum(dec["normal_linear_mult"]),
            "nonlinear_part_dim": dec["normal_dim"] - sum(dec["normal_linear_mult"]),
            "irreducible_decomposition": dec["normal_irr"],
            "decomposition_certified": dec["normal_irr_complete"],
            "character_values": char_on_classes(H, dec["normal_char"]),
            "note": "N_{F/P(W)} at a general point [v] of F is chi^{-1} tensor (W/W_chi); "
                    "the trivial character does not occur (Def. 1.1)"},
        "delta_res": {"stabiliser_order": len(dec["stab"]),
                      "W_order": qi["order"], "W_name": qi["name"],
                      "W_order_profile": qi["order_profile"],
                      "action_on_F": act},
        "delta_bir": {"F": "P^%d (linear subspace of P^4)" % s["dim"], "rational": True,
                      "RCC": True, "MRC_base": "point", "genus": (0 if s["dim"] == 1 else None)},
        "pointwise_stabiliser": {
            "order": len(dec["pointwise"]),
            "name": group_info(dec["pointwise"])["name"],
            "equals_H": dec["pointwise"] == frozenset(H),
            "elements_psl": [list(ELS[x]) for x in sorted(dec["pointwise"])],
            "note": "the largest subgroup of G fixing F pointwise, i.e. acting on W_chi by "
                    "a scalar; for a 0-dimensional F this is the full stabiliser of the point"},
        "basis_of_W_chi": [js_vec(b) for b in sp["basis"]],
        "field": sp["field"].n,
    })

SUB_JS = [{"subgroup_id": i, "class": CLASS_OF[i], "order": len(SUBLIST[i]),
           "elements_psl": [list(ELS[x]) for x in sorted(SUBLIST[i])],
           "conjugator_from_class_rep_psl": list(ELS[CONJUGATOR[i]])} for i in range(NSUB)]

STRAT_JS = [{"stratum_id": k, "subgroup_id": s["sub"], "subgroup_class": s["class"],
             "character_key": list(SUBCH[s["sub"]]["chars"][s["char"]]["key"]),
             "dim": s["dim"], "orbit_id": ORBIT_OF[k]} for k, s in enumerate(STRATA)]

PAYLOAD = {
    "meta": {
        "packet": "FIX_A2_SOURCE_COMPLEX", "program": "FIX (E56)",
        "object": "F(P(W)): the decorated fixed-locus complex of the SOURCE P^4 = P(W), "
                  "G = PSL(2,11) acting by the exact 5-dimensional Weil representation",
        "definition": "theory/FIX_I_bcomplex.md Definition 1.1",
        "representation_source": "certificates/exact_weil_check.py S,T generators, rebuilt in-file",
        "field": "Q(zeta_n), n | 330; the matrices rho(g) live over Q(zeta_11)",
        "characteristic": 0,
        "headline": "Problem E headline: OPEN",
        "method": "character projectors + exact subspace containment on class representatives, "
                  "transported by rho(g) W_chi(H) = W_{chi o c_g^{-1}}(gHg^{-1})",
        "conventions": {
            "stratum": "(H, F) with F an irreducible component of P(W)^H; "
                       "P(W)^H = disjoint union over the one-dimensional characters chi of H "
                       "with W_chi != 0 of P(W_chi)",
            "order": "(H,F) <= (H',F') iff H contains H' and F is contained in F'",
            "G_action": "g.(H,F) = (gHg^{-1}, rho(g)F)",
            "element_encoding": "canonical (a,b,c,d) mod 11 up to sign, lexicographically minimal",
            "field_element_encoding": "{f:n, num:[c_0..c_{deg-1}], den:d} means "
                                      "(sum c_i zeta_n^i)/d in Q(zeta_n) = Q[x]/Phi_n(x)"},
        "seal_note": "no timestamps or timings inside this payload; it is byte-reproducible",
    },
    "group": {
        "name": "PSL(2,11)", "order": 660,
        "element_order_profile": {str(k): v for k, v in sorted(Counter(ORD).items())},
        "element_conjugacy_classes": [
            {"size": len(c), "element_order": ORD[c[0]], "chi_W": CHI_W[c[0]].js(),
             "representative_psl": list(ELS[c[0]])} for c in ECLASSES],
        "generators": {"S": [[x.js() for x in row] for row in Smat],
                       "T": [[x.js() for x in row] for row in Tmat]},
        "W": {"dim": 5, "irreducible": True,
              "character_norm": (sum((CHI_W[g] * CHI_W[g].conj() for g in range(NG)),
                                     E.zero(F11)) / NG).js()},
    },
    "subgroup_classes": CLASS_JS,
    "subgroups": SUB_JS,
    "strata": STRAT_JS,
    "stratum_orbits": ORBIT_JS,
    "poset": {
        "convention": "(H,F) <= (H',F') iff H contains H' and F is contained in F'; "
                      "each edge below is the pair [lower stratum id, upper stratum id]",
        "edge_count": len(EDGES),
        "edges": [[a, b] for (a, b) in EDGES],
        "orbit_level": ORB_TABLE,
    },
    "sanity": SANITY,
}

with open(os.path.join(HERE, "source_complex.json"), "w") as fh:
    json.dump(PAYLOAD, fh, indent=1, sort_keys=True)
log("    wrote source_complex.json")
log("PRODUCE_FIX_A2_OK")
