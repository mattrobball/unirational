"""Probe: geometry of the A5 fixed loci inside X (drives the linear reduction).

For an involution a in A5:  W = V+ (dim 3) + V- (dim 2).
  - P(V-) should be one of the 55 lines on X  (F|_{V-} == 0)
  - C+ := X cap P(V+) is a plane cubic; smooth?  irreducible?
For an order-3 element b: eigenvalues 1 (mult 1), w, w (mult 2), w^2 (mult 2).
  - isolated fixed point v0: is F(v0) = 0 ?
  - eigen-lines P(E_w), P(E_w2): do they lie on X ?
"""
import sys, os
import numpy as np
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from a5lib import *

p = int(sys.argv[1]) if len(sys.argv) > 1 else 67
rng = np.random.default_rng(11)
G = group_closure(load_gens(p), p)
a, b, H = find_A5(G, p)


def eigspace(M, lam, p):
    """basis (rows) of ker(M - lam I) mod p"""
    A = (np.array(M) - lam * np.eye(5)) % p
    R, piv = rref(A, p)
    free = [c for c in range(5) if c not in piv]
    B = []
    for f in free:
        v = np.zeros(5)
        v[f] = 1
        for i, c in enumerate(piv):
            v[c] = (-R[i, f]) % p
        B.append(v % p)
    return np.array(B, dtype=np.float64)


w = None
for k in range(2, p):
    if pow(k, 3, p) == 1 and k != 1:
        w = k
        break
print('p=%d  cube root of unity w=%s' % (p, w))

Vp = eigspace(a, 1, p)
Vm = eigspace(a, p - 1, p)
print('involution a: dim V+ =', Vp.shape[0], ' dim V- =', Vm.shape[0])

# F restricted to V-  (should vanish identically: P(V-) is one of the 55 lines)
zs = 0
for _ in range(30):
    t = rng.integers(0, p, size=2).astype(np.float64)
    zs += klein_F((t @ Vm) % p, p) == 0
print('F|_{V-} vanishes at 30 random pts:', zs, '/30')

# F restricted to V+ : the plane cubic C+
# coefficients in coords (s,t,u) w.r.t. rows of Vp
mons3 = [(i, j, k) for i in range(3, -1, -1) for j in range(3 - i, -1, -1)
         for k in [3 - i - j]]
pts = rng.integers(0, p, size=(len(mons3) + 6, 3)).astype(np.float64)
A = np.array([[pow(int(q[0]), m[0], p) * pow(int(q[1]), m[1], p)
               * pow(int(q[2]), m[2], p) % p for m in mons3] for q in pts])
rhs = np.array([klein_F((q @ Vp) % p, p) for q in pts], dtype=np.float64)
R, piv = rref(np.concatenate([A, rhs[:, None]], axis=1), p)
assert piv[-1] != len(mons3), 'inconsistent interpolation'
coef = np.zeros(len(mons3))
for i, c in enumerate(piv):
    coef[c] = R[i, -1]
# back-substitute properly: solve A c = rhs
sq = A[:len(mons3)]
ci = inv_p(sq, p)
coef = mm(ci, rhs[:len(mons3)][:, None], p).ravel()
print('C+ cubic coefficients (mons %s):' % (mons3,), coef.astype(int).tolist())
print('C+ identically zero?', bool(np.all(coef % p == 0)))

# singular points of C+ : common zeros of the 3 partials -> resultant-free brute force
if not np.all(coef % p == 0):
    def fval(q):
        return int(sum(int(coef[i]) * pow(int(q[0]), m[0], p) * pow(int(q[1]), m[1], p)
                       * pow(int(q[2]), m[2], p) for i, m in enumerate(mons3))) % p

    def grad(q):
        g = [0, 0, 0]
        for i, m in enumerate(mons3):
            for v in range(3):
                if m[v]:
                    t = int(coef[i]) * m[v]
                    ee = list(m)
                    ee[v] -= 1
                    for u in range(3):
                        t = t * pow(int(q[u]), ee[u], p) % p
                    g[v] = (g[v] + t) % p
        return g

    sing, npts, onC = [], 0, 0
    for x in range(p):
        for y in range(p):
            for z in ([1] if True else []):
                pass
    proj = [(1, y, z) for y in range(p) for z in range(p)] + \
           [(0, 1, z) for z in range(p)] + [(0, 0, 1)]
    for q in proj:
        npts += 1
        if fval(q) == 0:
            onC += 1
            if all(t == 0 for t in grad(q)):
                sing.append(q)
    print('|C+(F_p)| =', onC, ' (p+1 =', p + 1, ')   singular points:', sing)

# common eigenvectors of the V4 = C_{A5}(a) inside V+
V4 = [M for M in H if np.array_equal(mm(M, a, p), mm(a, M, p))]
print('|C_{A5}(a)| =', len(V4))

# order-3 element b
E1 = eigspace(b, 1, p)
Ew = eigspace(b, w, p)
Ew2 = eigspace(b, w * w % p, p)
print('b eigen-dims: 1:%d w:%d w2:%d' % (E1.shape[0], Ew.shape[0], Ew2.shape[0]))
v0 = E1[0]
print('F(v0) =', klein_F(v0, p), '   (v0 = isolated order-3 fixed point)')
for nm, E in (('E_w', Ew), ('E_w2', Ew2)):
    z = sum(klein_F((rng.integers(0, p, size=2).astype(np.float64) @ E) % p, p) == 0
            for _ in range(20))
    print('F|_%s vanishes at 20 random pts: %d/20' % (nm, z))
