import numpy as np
from itertools import combinations
p = 397
z11 = next(t for t in range(2, p) if pow(t, 11, p) == 1 and t != 1)
# rebuild T6, S6 with BOTH sign choices of c^2 = ±1/11; use linear closure
F11 = np.array([[pow(z11, (i*j) % 11, p) for j in range(11)] for i in range(11)], dtype=np.int64)
E = np.zeros((11,6), dtype=np.int64); E[0,0] = 1
for j in range(1,6): E[j,j] = 1; E[11-j,j] = 1
P6 = np.zeros((6,11), dtype=np.int64); P6[0,0] = 1
for j in range(1,6): P6[j,j] = 1
S6u = P6 @ F11 @ E % p
T6 = np.diag([1] + [pow(z11, j*j, p) for j in range(1,6)]).astype(np.int64)
inv11 = pow(11, p-2, p)
for sgn in (1, p-1):
    tgt = sgn * inv11 % p
    c = next((t for t in range(1, p) if t*t % p == tgt), None)
    if c is None: continue
    S6 = c * S6u % p
    # linear BFS closure, cap 3000
    seen = {tuple((np.eye(6, dtype=np.int64)).reshape(36)): np.eye(6, dtype=np.int64)}
    frontier = [np.eye(6, dtype=np.int64)]
    while frontier and len(seen) <= 2800:
        nf = []
        for M in frontier:
            for g in (T6, S6):
                N = M @ g % p
                k = tuple(N.reshape(36))
                if k not in seen: seen[k] = N; nf.append(N)
        frontier = nf
    print("sign", "+1" if sgn == 1 else "-1", "linear closure:", len(seen))
    if len(seen) == 1320:
        L = list(seen.values())
        np.save('SL1320.npy', np.array(L, dtype=np.int64))
        break
# Lambda^2 action and decomposition
L = [np.array(M, dtype=np.int64) for M in np.load('SL1320.npy')]
pairs = list(combinations(range(6), 2))  # 15
def lam2(M):
    A = np.zeros((15,15), dtype=np.int64)
    for a,(i,j) in enumerate(pairs):
        for b,(k,l) in enumerate(pairs):
            A[a,b] = (M[i,k]*M[j,l] - M[i,l]*M[j,k]) % p
    return A % p
# order and trace per element (on U and Lambda2)
I6 = np.eye(6, dtype=np.int64)
def order6(M):
    k, A = 1, M % p
    while not np.array_equal(A, I6):
        A = A @ M % p; k += 1
        if k > 25: return 99
    return k
# character values mod p for PSL irreps (from the banked table, reduced mod p)
s11 = next(t for t in range(1, p) if t*t % p == (-11) % p)
lam_, lamb_ = (p-1+s11)*pow(2,p-2,p) % p, (p-1-s11)*pow(2,p-2,p) % p
s5 = None
mup = mum = 0
CL = ['1','2','3','5A','5B','6','11A','11B']
CT = {'W':[5,1,p-1,0,0,1,lam_,lamb_], 'Wb':[5,1,p-1,0,0,1,lamb_,lam_],
      'X10':[10,p-2,1,0,0,1,p-1,p-1], 'X10p':[10,2,1,0,0,p-1,p-1,p-1],
      'X11':[11,p-1,p-1,1,1,p-1,0,0], 'X12':[12,0,0,mup,mum,0,1,1], 'X12p':[12,0,0,mum,mup,0,1,1], 'triv':[1]*8}
# classify each SL element's PSL class: by order of its PSL image (order of M mod scalars)
scal = set()
for t in range(1, p):
    if pow(t, 6, p) == 1: scal.add(t)  # possible det-compatible scalars in closure: just use projective order
def proj_order(M):
    k, A = 1, M % p
    while k <= 12:
        if np.count_nonzero(A - np.diag(np.diagonal(A))) == 0 and len(set(int(x) for x in np.diagonal(A))) == 1:
            return k
        A = A @ M % p; k += 1
    return 99
# for ambiguity 11A/11B and 5A/5B: use chi_U trace fields... simpler: aggregate traces of Lambda2 per projective order, and match SUMS against candidate decompositions summed over the same classes
from collections import defaultdict
agg = defaultdict(lambda: [0, 0])  # proj order -> [count, sum of lam2 traces]
for M in L:
    po = proj_order(M)
    t2 = int(np.trace(lam2(M))) % p
    agg[po][0] += 1; agg[po][1] = (agg[po][1] + t2) % p
print("per projective order (count, sum of Lambda2 traces):", dict(agg))
# expected per candidate M10: sum over class of chi(class)*[class sizes within each order, x2 for SL double cover]
# orders: 1:{1}, 2:{2}, 3:{3}, 6:{6}, 5:{5A,5B}, 11:{11A,11B}; SL preimages double each
sizes = {'1':1,'2':55,'3':110,'5A':132,'5B':132,'6':110,'11A':60,'11B':60}
for five in ('W','Wb'):
    for ten in ('X10','X10p'):
        ok = True
        for po, classes in {1:['1'],2:['2'],3:['3'],6:['6'],5:['5A','5B'],11:['11A','11B']}.items():
            exp = sum(2*sizes[c]*( CT[five][CL.index(c)] + CT[ten][CL.index(c)] ) for c in classes) % p
            if agg[po][1] != exp: ok = False; break
        if ok: print("Lambda2 U =", five, "+", ten)
