import numpy as np
from itertools import combinations
p = 397
# roots mod p
def find_root(order):
    for t in range(2, p):
        if pow(t, order, p) == 1 and all(pow(t, order//q, p) != 1 for q in {2,3,5,11,397} if order % q == 0 and q <= order):
            return t
z11 = None
for t in range(2, p):
    if pow(t, 11, p) == 1 and t != 1: z11 = t; break
# 6-dim even Weil rep of SL(2,11) on even functions on F11
# basis: e0 = delta_0, e_j = delta_j + delta_{-j}, j = 1..5
# t-generator: (Tf)(x) = zeta^{x^2} f(x)  -> diagonal in delta basis, preserves even part
idx = [0,1,2,3,4,5]
T6 = np.zeros((6,6), dtype=np.int64)
T6[0,0] = 1
for j in range(1,6):
    T6[j,j] = pow(z11, j*j, p)
# s-generator: Fourier (Sf)(x) = c * sum_y zeta^{xy} f(y) on delta basis; restrict to even
# on even basis: (S e0)(x)-coeffs: build full 11x11 Fourier then compress
F11 = np.array([[pow(z11, (i*j) % 11, p) for j in range(11)] for i in range(11)], dtype=np.int64)
# compression matrices: even functions embed E: 6 -> 11; project P: 11 -> 6
E = np.zeros((11,6), dtype=np.int64); E[0,0] = 1
for j in range(1,6): E[j,j] = 1; E[11-j,j] = 1
P6 = np.zeros((6,11), dtype=np.int64); P6[0,0] = 1
for j in range(1,6): P6[j,j] = 1
S6u = P6 @ F11 @ E % p   # unnormalized
# normalize: need scalar c with (c*S6u)^2 = identity-ish; compute S6u^2 = scalar*Id?
S2 = S6u @ S6u % p
assert np.count_nonzero(S2 - np.diag(np.diagonal(S2))) == 0, S2
d = set(int(x) for x in np.diagonal(S2))
print("S^2 diagonal values:", d)
# S2 = lam * I: c^2 = lam^{-1}: c = sqrt(inv lam) if QR
lam = d.pop()
il = pow(lam, p-2, p)
c = None
for t in range(1, p):
    if t*t % p == il: c = t; break
print("normalizer c found:", c is not None)
S6 = c * S6u % p
# BFS projective closure of <T6, S6>
def canon(M):
    M = M % p
    for i in range(36):
        v = M.reshape(36)[i]
        if v: return tuple((M * pow(int(v), p-2, p) % p).reshape(36))
seen = {canon(np.eye(6, dtype=np.int64)): np.eye(6, dtype=np.int64)}
frontier = [np.eye(6, dtype=np.int64)]
while frontier:
    nf = []
    for M in frontier:
        for g in (T6, S6):
            N = M @ g % p
            cn = canon(N)
            if cn not in seen:
                seen[cn] = N; nf.append(N)
    frontier = nf
print("projective closure order:", len(seen))
np.save('U6_group.npy', np.array(list(seen.values()), dtype=np.int64))
