#!/usr/bin/env python3
# F55 on the V14: C11-eigenpoints of P(M), which lie on V14, and the
# C11-weight decomposition of the tangent/normal spaces there; the
# C5-linkage. Mod p, p = 1 mod 55 not needed: p = 1 mod 11 suffices,
# and C5-conjugation acts on exponents by *3 mod 11.
import sys
from itertools import combinations
p = int(sys.argv[1]) if len(sys.argv) > 1 else 397
g11 = next(t for t in range(2, p) if pow(t, 11, p) == 1 and t != 1)
gauss = sum(pow(g11, (k*k) % 11, p) for k in range(11)) % p
assert (gauss*gauss + 11) % p == 0
c = pow(gauss, p-2, p)
T6 = [[(pow(g11, (j*j) % 11, p) if i == j else 0) for j in range(6)] for i in range(6)]
S6 = [[(c if j == 0 else c*(pow(g11, (i*j) % 11, p) + pow(g11, (-i*j) % 11, p))) % p
       for j in range(6)] for i in range(6)]
def mm(A, B, n=6):
    return tuple(tuple(sum(A[i][k]*B[k][j] for k in range(n)) % p for j in range(n)) for i in range(n))
I6 = tuple(tuple((1 if i == j else 0) for j in range(6)) for i in range(6))
seen = {I6}; fr = [I6]
T6t, S6t = tuple(map(tuple, T6)), tuple(map(tuple, S6))
while fr:
    nx = []
    for M in fr:
        for g in (T6t, S6t):
            N = mm(M, g)
            if N not in seen: seen.add(N); nx.append(N)
    fr = nx
GRP = list(seen); assert len(GRP) == 1320
def is_scal(A):
    d = A[0][0]
    return d != 0 and all(A[i][j] == (d if i == j else 0) for i in range(6) for j in range(6))
def po(M):
    A = M
    for k in range(1, 14):
        if is_scal(A): return k
        A = mm(A, M)
    return 99
pairs = list(combinations(range(6), 2))
quads = list(combinations(range(6), 4))
def lam2(M):
    return tuple(tuple((M[i][k]*M[j][l] - M[i][l]*M[j][k]) % p for (k, l) in pairs)
                 for (i, j) in pairs)
def perm_sign(P):
    s = 1; P = list(P)
    for i in range(len(P)):
        for j in range(i+1, len(P)):
            if P[i] > P[j]: s = -s
    return s
# 10' projector -> M basis (columns)
CHI = {1:10, 2:2, 3:1, 5:0, 6:p-1, 11:p-1}
PM = [[0]*15 for _ in range(15)]
for M in GRP:
    w = CHI[po(M)]
    if w == 0: continue
    L2 = lam2(M)
    for i in range(15):
        for j in range(15): PM[i][j] = (PM[i][j] + w*L2[i][j]) % p
sc = 10 * pow(1320 % p, p-2, p) % p
PM = [[x*sc % p for x in r] for r in PM]
def echelon(rows):
    R = [list(r) for r in rows]; piv = []; rr = 0
    for cx in range(len(R[0]) if R else 0):
        pr = next((r for r in range(rr, len(R)) if R[r][cx] % p), None)
        if pr is None: continue
        R[rr], R[pr] = R[pr], R[rr]
        iv = pow(R[rr][cx], p-2, p)
        R[rr] = [x*iv % p for x in R[rr]]
        for r in range(len(R)):
            if r != rr and R[r][cx] % p:
                f = R[r][cx]
                R[r] = [(x - f*y) % p for x, y in zip(R[r], R[rr])]
        piv.append(cx); rr += 1
    return [tuple(r) for r in R[:rr]], piv
MB, _ = echelon([tuple(PM[i][j] for i in range(15)) for j in range(15)])
assert len(MB) == 10
# order-11 element h (linear order 11 in SL) and its Lambda^2
h = next(M for M in GRP if po(M) == 11)
L2h = lam2(h)
# powers of L2h
L2hp = [tuple(tuple((1 if i == j else 0) for j in range(15)) for i in range(15))]
for _ in range(10):
    A = L2hp[-1]
    L2hp.append(tuple(tuple(sum(A[i][k]*L2h[k][j] for k in range(15)) % p for j in range(15)) for i in range(15)))
z = pow(g11, 1, p)  # fixed primitive 11th root: weight e <-> eigenvalue z^e
inv11 = pow(11, p-2, p)
def proj_e(e):
    # projector onto weight-e space of h on Lambda^2, then restrict to M
    P = [[0]*15 for _ in range(15)]
    for j in range(11):
        cf = pow(z, (-e*j) % 11, p)
        A = L2hp[j]
        for i in range(15):
            for k in range(15): P[i][k] = (P[i][k] + cf*A[i][k]) % p
    P = [[x*inv11 % p for x in r] for r in P]
    vecs = [tuple(sum(P[i][k]*m[k] for k in range(15)) % p for i in range(15)) for m in MB]
    V, _ = echelon(vecs)
    return V
wt = {e: proj_e(e) for e in range(11)}
print("weights of C11 on M (mult):", {e: len(v) for e, v in wt.items() if v})
def wedge22(a, b):
    if set(a) & set(b): return None
    s = tuple(sorted(set(a) | set(b)))
    return (quads.index(s), perm_sign(list(a) + list(b)))
def wprod(u, v):
    out = [0]*15
    for a in range(15):
        if not u[a] % p: continue
        for b in range(15):
            if not v[b] % p: continue
            w = wedge22(pairs[a], pairs[b])
            if w is None: continue
            K, sg = w
            out[K] = (out[K] + sg*u[a]*v[b]) % p
    return out
onV = []
for e, V in wt.items():
    if len(V) != 1: continue
    y = V[0]
    yy = wprod(y, y)
    if all(x % p == 0 for x in yy): onV.append((e, y))
print("C11-eigenpoints ON V14: weights", sorted(e for e, _ in onV))
# tangent cone: ker(v -> y ^ v) on M; weights of the kernel
for e, y in sorted(onV):
    rows = []
    for m in MB:
        rows.append(tuple(wprod(y, m)))
    # kernel: coeff vectors c in k^10 with sum c_i (y ^ MB_i) = 0
    RT = [tuple(rows[i][j] for i in range(10)) for j in range(15)]
    E, piv = echelon(RT)
    free = [i for i in range(10) if i not in piv]
    ker = []
    for f in free:
        v = [0]*10; v[f] = 1
        for r, pc in zip(E, piv): v[pc] = (-r[f]) % p
        w15 = [0]*15
        for ci, m in zip(v, MB):
            for j in range(15): w15[j] = (w15[j] + ci*m[j]) % p
        ker.append(tuple(w15))
    KB, _ = echelon(ker)
    # weights inside the kernel: dim of weight-f component
    twts = []
    for f in range(11):
        # project each kernel vector onto weight f, count rank
        vecs = []
        for v in KB:
            pv = [0]*15
            for j in range(11):
                cf = pow(z, (-f*j) % 11, p)
                A = L2hp[j]
                for i in range(15):
                    s = 0
                    for k2 in range(15): s += A[i][k2]*v[k2]
                    pv[i] = (pv[i] + cf*s) % p
            pv = [x*inv11 % p for x in pv]
            vecs.append(tuple(pv))
        V2, _ = echelon(vecs)
        if V2: twts += [f]*len(V2)
    tang = sorted(((f - e) % 11) for f in twts if f != e or twts.count(f) > 1)
    print(f"point wt {e}: cone dim {len(KB)}, cone weights {sorted(twts)}, "
          f"projective tangent weights {[t for t in tang]}")
# C5 linkage: n in GRP with n h n^-1 = h^k (proj), k order 5 mod 11
def minv(A):
    # inverse via adjugate-free: A^(order-1)
    o = po(A)
    # linear order may be 2*proj or proj; just find B with A B = I by powers
    B = A; C = mm(A, A)
    while not is_scal(C) or C[0][0] != 1:
        B = C if False else mm(B, A)
        C = mm(B, A)
        # guard
    return B
found = None
for N in GRP:
    if po(N) != 5: continue
    # check N h = h^k N for some k
    NH = mm(N, h)
    Hk = h
    for k in range(2, 11):
        Hk = mm(Hk, h)
        if mm(Hk, N) == NH: found = (N, k+0); break
    if found: break
if found:
    N, k = found
    print("C5-normalizer element found: conj sends h -> h^", k % 11, "(exponent scaling factor)")
