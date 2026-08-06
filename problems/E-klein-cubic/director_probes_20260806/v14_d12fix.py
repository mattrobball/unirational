import numpy as np
from itertools import combinations
p = 397
L = [np.array(M, dtype=np.int64) for M in np.load('SL1320.npy')]
I6 = np.eye(6, dtype=np.int64)
def proj_order(M):
    k, A = 1, M % p
    while k <= 12:
        if np.count_nonzero(A - np.diag(np.diagonal(A))) == 0 and len(set(int(x) for x in np.diagonal(A))) == 1:
            return k
        A = A @ M % p; k += 1
    return 99
def closure(gens):
    seen = {tuple(I6.reshape(36)): I6}; frontier = [I6]
    while frontier:
        nf = []
        for M in frontier:
            for g in gens:
                N = M @ g % p; k = tuple(N.reshape(36))
                if k not in seen: seen[k] = N; nf.append(N)
        frontier = nf
    return list(seen.values())
# 2.D12: find r (proj order 6), s (proj order 2) with srs^{-1} = r^{-1} projectively
import random
o6 = [M for M in L if proj_order(M) == 6]
o2 = [M for M in L if proj_order(M) == 2]
def inv_m(g):
    A = np.concatenate([g % p, I6], axis=1) % p
    for c in range(6):
        pr = next(r for r in range(c, 6) if A[r, c] % p)
        A[[c, pr]] = A[[pr, c]]
        A[c] = A[c] * pow(int(A[c, c]), p-2, p) % p
        for r in range(6):
            if r != c and A[r, c] % p: A[r] = (A[r] - A[r, c]*A[c]) % p
    return A[:, 6:] % p
def proj_eq(A, B):
    for i in range(36):
        a, b = A.reshape(36)[i], B.reshape(36)[i]
        if a or b:
            if not a or not b: return False
            lam = a * pow(int(b), p-2, p) % p
            return np.array_equal(A % p, lam * B % p)
    return True
found = None
for r in o6:
    ri = inv_m(r)
    for s in o2:
        if proj_eq(s @ r @ inv_m(s) % p, ri):
            found = (r, s); break
    if found: break
r, s = found
D = closure([r, s])
print("2.D12 closure:", len(D))
pairs = list(combinations(range(6), 2))
def lam2(M):
    A = np.zeros((15,15), dtype=np.int64)
    for x,(i,j) in enumerate(pairs):
        for y,(k,l) in enumerate(pairs):
            A[x,y] = (M[i,k]*M[j,l] - M[i,l]*M[j,k]) % p
    return A % p
R = np.zeros((15,15), dtype=np.int64)
for M in D: R = (R + lam2(M)) % p
R = R * pow(len(D) % p, p-2, p) % p
def rank_p(M):
    M = M.copy() % p; rr = 0
    rows, cols = M.shape
    for c in range(cols):
        piv = next((rr2 for rr2 in range(rr, rows) if M[rr2, c] % p), None)
        if piv is None: continue
        M[[rr, piv]] = M[[piv, rr]]
        M[rr] = M[rr] * pow(int(M[rr, c]), p-2, p) % p
        for r2 in range(rows):
            if r2 != rr and M[r2, c] % p: M[r2] = (M[r2] - M[r2, c]*M[rr]) % p
        rr += 1
    return rr
print("dim invariants of Lambda2 under 2.D12:", rank_p(R))
# basis of the invariant pencil
cols = []
Rc = R.copy()
for c in range(15):
    if rank_p(np.array(cols + [R[:, c]])) > len(cols):
        cols.append(R[:, c] % p)
    if len(cols) == 2: break
# rank of s*w1 + t*w2 over all (s:t) in P^1(F_p)
def Om(w):
    O = np.zeros((6,6), dtype=np.int64)
    for x,(i,j) in enumerate(pairs):
        O[i,j] = w[x] % p; O[j,i] = (-w[x]) % p
    return O
O1, O2 = Om(cols[0]), Om(cols[1])
ranks = {}
for t in list(range(p)) + ['inf']:
    O = O1 if t == 'inf' else (t*O1 + O2) % p
    ranks.setdefault(rank_p(O), 0)
    ranks[rank_p(O)] += 1
print("rank distribution over the D12-pencil P^1:", ranks, "-> rank-2 members =", ranks.get(2, 0))
