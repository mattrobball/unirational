import numpy as np
from itertools import combinations
exec(open('v14_d12fix.py').read().split('# 2.D12')[0])
# 10'-isotypic projector on Lambda2 U: chi_{10'} by projective order: 1->10, 2->2, 3->1, 5->0, 6->-1, 11->-1
chi = {1: 10, 2: 2, 3: 1, 5: 0, 6: p-1, 11: p-1}
pairs = list(combinations(range(6), 2))
def lam2(M):
    A = np.zeros((15,15), dtype=np.int64)
    for x,(i,j) in enumerate(pairs):
        for y,(k,l) in enumerate(pairs):
            A[x,y] = (M[i,k]*M[j,l] - M[i,l]*M[j,k]) % p
    return A % p
PM = np.zeros((15,15), dtype=np.int64)
for M in L:
    PM = (PM + chi[proj_order(M)] * lam2(M)) % p
PM = PM * 10 % p * pow(1320 % p, p-2, p) % p
def rank_p(M):
    M = M.copy() % p; rr = 0
    rows, cols = M.shape
    for c in range(cols):
        piv = next((r2 for r2 in range(rr, rows) if M[r2, c] % p), None)
        if piv is None: continue
        M[[rr, piv]] = M[[piv, rr]]
        M[rr] = M[rr] * pow(int(M[rr, c]), p-2, p) % p
        for r2 in range(rows):
            if r2 != rr and M[r2, c] % p: M[r2] = (M[r2] - M[r2, c]*M[rr]) % p
        rr += 1
    return rr
print("rank of 10'-projector:", rank_p(PM), "(must be 10)")
# D12 Reynolds, then project to M
import importlib
# rebuild 2.D12 as before
o6 = [M for M in L if proj_order(M) == 6]; o2 = [M for M in L if proj_order(M) == 2]
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
        if proj_eq(s @ r @ inv_m(s) % p, ri): found = (r, s); break
    if found: break
r, s = found
seen = {tuple(I6.reshape(36)): I6}; frontier = [I6]
while frontier:
    nf = []
    for M in frontier:
        for g in (r, s):
            N = M @ g % p; k = tuple(N.reshape(36))
            if k not in seen: seen[k] = N; nf.append(N)
    frontier = nf
R = np.zeros((15,15), dtype=np.int64)
for M in seen.values(): R = (R + lam2(M)) % p
R = R * pow(len(seen) % p, p-2, p) % p
RM = PM @ R % p
print("dim of D12-invariants inside M:", rank_p(RM), "(expect 2)")
cols = []
for c in range(15):
    t = np.array(cols + [RM[:, c] % p])
    if rank_p(t) > len(cols): cols.append(RM[:, c] % p)
    if len(cols) == 2: break
def Om(w):
    O = np.zeros((6,6), dtype=np.int64)
    for x,(i,j) in enumerate(pairs):
        O[i,j] = w[x] % p; O[j,i] = (-w[x]) % p
    return O
O1, O2 = Om(cols[0]), Om(cols[1])
ranks = {}
for t in list(range(p)) + ['inf']:
    O = O1 if t == 'inf' else (t*O1 + O2) % p
    rk = rank_p(O); ranks[rk] = ranks.get(rk, 0) + 1
print("rank distribution over the TRUE D12-pencil in M:", ranks, "-> rank-2 (= V14 D12-fixed pts):", ranks.get(2, 0))
