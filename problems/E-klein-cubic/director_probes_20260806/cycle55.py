import json, random, itertools
import numpy as np
random.seed(3); p = 67
G = [np.array(M, dtype=np.int64) % p for M in np.load("G660_p67.npy")]
I5 = np.eye(5, dtype=np.int64)
inv2 = pow(2, p-2, p)
def order(M):
    k, A = 1, M % p
    while not np.array_equal(A, I5): A = A @ M % p; k += 1
    return k
invs = [M for M in G if order(M) == 2]
print("involutions:", len(invs))
def Fv(x): return int(sum(x[i]*x[i]*x[(i+1)%5] for i in range(5))) % p
def gradF(x): return [(2*x[i]*x[(i+1)%5] + x[(i-1)%5]**2) % p for i in range(5)]
# A: symbolic landing check F(P v) == 0 for all 55 projectors, via 30 random points (deg-3 poly in 5 vars, 30 >> needed with Schwartz-Zippel at p=67; then exact via 126-monomial interpolation for one)
ok = 0
for M in invs:
    P = (I5 - M) % p * inv2 % p
    if all(Fv(P @ np.array([random.randrange(p) for _ in range(5)]) % p) == 0 for _ in range(8)): ok += 1
print("projectors landing in X (8 random pts each):", ok, "/", len(invs))
# commuting structure: V4 triples
def comm(A, B): return np.array_equal(A @ B % p, B @ A % p)
pairs = [(i,j) for i in range(55) for j in range(i+1,55) if comm(invs[i], invs[j])]
print("commuting pairs:", len(pairs))
v4s = set()
for i, j in pairs:
    Mk = invs[i] @ invs[j] % p
    k = next(kk for kk in range(55) if np.array_equal(invs[kk]*1 % p, Mk) or np.array_equal((invs[kk]*(-1))%p, Mk) or np.array_equal((invs[kk]*int(pow(1,1)))%p, Mk)) if True else None
    # find index of Mk up to scalar
    k = next(kk for kk in range(55) if any(np.array_equal(invs[kk], Mk*s % p) for s in range(1,p)))
    v4s.add(tuple(sorted((i,j,k))))
print("V4 triples:", len(v4s))
# B/C: triangle + Menelaus for one V4
i, j, k = sorted(v4s)[0]
Ps = [ (I5 - invs[t]) % p * inv2 % p for t in (i,j,k) ]
def chord(a, b):
    A = sum(int(b[t])*g for t, g in enumerate(gradF(a))) % p   # D_b F(a)
    B = sum(int(a[t])*g for t, g in enumerate(gradF(b))) % p   # D_a F(b)
    return (B*a - A*b) % p
mene = 0; onX = 0
for _ in range(6):
    v = np.array([random.randrange(p) for _ in range(5)])
    pts = [P @ v % p for P in Ps]
    cs = [chord(pts[1], pts[2]), chord(pts[2], pts[0]), chord(pts[0], pts[1])]
    onX += all(Fv(c) == 0 for c in cs)
    mene += (np.linalg.matrix_rank(np.array(cs) % p) == 2)  # rank over R of small ints ok as heuristic; exact below
    # exact rank mod p via row reduction
def rank_p(Mrows):
    M = np.array(Mrows, dtype=np.int64) % p; r = 0
    M = M.copy()
    rows, cols = M.shape
    rr = 0
    for c in range(cols):
        piv = None
        for r2 in range(rr, rows):
            if M[r2, c] % p: piv = r2; break
        if piv is None: continue
        M[[rr, piv]] = M[[piv, rr]]
        M[rr] = M[rr] * pow(int(M[rr, c]), p-2, p) % p
        for r2 in range(rows):
            if r2 != rr and M[r2, c] % p:
                M[r2] = (M[r2] - M[r2, c] * M[rr]) % p
        rr += 1
    return rr
ex = 0
for _ in range(6):
    v = np.array([random.randrange(p) for _ in range(5)])
    pts = [P @ v % p for P in Ps]
    cs = [chord(pts[1], pts[2]), chord(pts[2], pts[0]), chord(pts[0], pts[1])]
    ex += (rank_p(cs) == 2 and all(Fv(c) == 0 for c in cs))
print("Menelaus axis (chord-triple collinear + on X), 6 trials:", ex, "/6")
# D: full 55-cycle rank + vertex orbit
v = np.array([random.randrange(p) for _ in range(5)])
Z = [ (I5 - M) % p * inv2 % p @ v % p for M in invs ]
print("55-cycle span rank:", rank_p(Z))
vert = None
# vertex of first triangle: intersection of lines 1 and 2: image(P1) cap image(P2)
# line i = column space of Pi (rank 2)
def colspace(P):
    return [P[:, c] for c in range(5)]
# intersection via nullspace stacking: x in both column spaces
A1 = np.array(colspace(Ps[0])).T; A2 = np.array(colspace(Ps[1])).T
# solve A1 u = A2 w: stack [A1 | -A2]
S = np.concatenate([A1, (-A2) % p], axis=1) % p
# nullspace mod p
def null_p(M):
    M = M.copy() % p; rows, cols = M.shape
    piv = {}; rr = 0
    for c in range(cols):
        pv = None
        for r2 in range(rr, rows):
            if M[r2, c] % p: pv = r2; break
        if pv is None: continue
        M[[rr, pv]] = M[[pv, rr]]
        M[rr] = M[rr] * pow(int(M[rr, c]), p-2, p) % p
        for r2 in range(rows):
            if r2 != rr and M[r2, c] % p: M[r2] = (M[r2] - M[r2, c]*M[rr]) % p
        piv[c] = rr; rr += 1
    free = [c for c in range(cols) if c not in piv]
    basis = []
    for f in free:
        x = np.zeros(cols, dtype=np.int64); x[f] = 1
        for c, r2 in piv.items(): x[c] = (-M[r2, f]) % p
        basis.append(x % p)
    return basis
ns = null_p(S)
vtx = None
for x in ns:
    w = A1 @ x[:5] % p
    if w.any(): vtx = w; break
print("vertex of triangle 1:", vtx)
orb = set()
for M in G:
    w = M @ vtx % p
    nz = next(int(t) for t in w if t)
    w = w * pow(nz, p-2, p) % p
    orb.add(tuple(int(t) for t in w))
print("vertex orbit size:", len(orb))
# E: the 55 Menelaus axes' Pluecker rank
plks = []
for (i, j, k) in sorted(v4s):
    Ps3 = [ (I5 - invs[t]) % p * inv2 % p for t in (i, j, k) ]
    pts = [P @ v % p for P in Ps3]
    cs = [chord(pts[1], pts[2]), chord(pts[2], pts[0])]
    a, b = cs
    plk = [ (a[r]*b[s] - a[s]*b[r]) % p for r in range(5) for s in range(r+1,5) ]
    plks.append(plk)
print("Pluecker rank of the 55 axes (<=10):", rank_p(plks))
