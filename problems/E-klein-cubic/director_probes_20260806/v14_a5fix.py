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
# find 2.A5: a (proj ord 2), b (proj ord 3), ab proj ord 5
import random
random.seed(5)
found = None
o2 = [M for M in L if proj_order(M) == 2]
o3 = [M for M in L if proj_order(M) == 3]
for a in o2:
    for b in o3:
        if proj_order(a @ b % p) == 5:
            found = (a, b); break
    if found: break
a, b = found
seen = {tuple(I6.reshape(36)): I6}
frontier = [I6]
while frontier:
    nf = []
    for M in frontier:
        for g in (a, b):
            N = M @ g % p
            k = tuple(N.reshape(36))
            if k not in seen: seen[k] = N; nf.append(N)
    frontier = nf
print("2.A5 closure order:", len(seen))
pairs = list(combinations(range(6), 2))
def lam2(M):
    A = np.zeros((15,15), dtype=np.int64)
    for x,(i,j) in enumerate(pairs):
        for y,(k,l) in enumerate(pairs):
            A[x,y] = (M[i,k]*M[j,l] - M[i,l]*M[j,k]) % p
    return A % p
R = np.zeros((15,15), dtype=np.int64)
for M in seen.values():
    R = (R + lam2(M)) % p
R = R * pow(len(seen) % p, p-2, p) % p
# rank of R and the invariant vector
def rank_p(M):
    M = M.copy() % p; rr = 0
    rows, cols = M.shape
    for c in range(cols):
        piv = next((r for r in range(rr, rows) if M[r, c] % p), None)
        if piv is None: continue
        M[[rr, piv]] = M[[piv, rr]]
        M[rr] = M[rr] * pow(int(M[rr, c]), p-2, p) % p
        for r in range(rows):
            if r != rr and M[r, c] % p: M[r] = (M[r] - M[r, c]*M[rr]) % p
        rr += 1
    return rr
print("Reynolds rank (dim invariants of Lambda2 U under 2.A5):", rank_p(R))
# invariant vector = any nonzero column of R
w = None
for c in range(15):
    if R[:, c].any(): w = R[:, c] % p; break
# build antisymmetric 6x6 Omega and its rank
Om = np.zeros((6,6), dtype=np.int64)
for x,(i,j) in enumerate(pairs):
    Om[i,j] = w[x] % p; Om[j,i] = (-w[x]) % p
r = rank_p(Om)
print("rank of invariant bivector Omega:", r, " (2 = DECOMPOSABLE = the A5-fixed point LIES ON Gr(2,U) and hence on V14)")
np.save('omega_a5.npy', w % p)
