"""Probe 2: the V4-isotypic decomposition of V+ and the candidate image points q.

If T is A5-equivariant and lands in X then T(V+) subset V+ and the induced
rational map P(V+) --> C+ = X cap P(V+) has image in a genus-1 curve, hence is
constant: T|_{V+} = h.q.  V4 = C_{A5}(a) equivariance then forces q to be a
common V4-eigenvector in V+, i.e. q in P(W_chi0) (dim 2) or q = [W_chi1].
So the candidate set is  C+ cap (P(W_chi0) union {W_chi1}).
"""
import sys, os, subprocess
import numpy as np
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from a5lib import *

p = int(sys.argv[1]) if len(sys.argv) > 1 else 67
HERE = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
rng = np.random.default_rng(5)
G = group_closure(load_gens(p), p)
a, b, H = find_A5(G, p)
V4 = [M for M in H if np.array_equal(mm(M, a, p), mm(a, M, p))]
assert len(V4) == 4


def eigspace(M, lam, p):
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


def joint_eig(mats, signs, p):
    """common eigenspace: M_i v = sign_i v"""
    rows = []
    for M, s in zip(mats, signs):
        rows.append((np.array(M) - (s % p) * np.eye(5)) % p)
    A = np.concatenate(rows, axis=0) % p
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


sig = [M for M in V4 if not np.array_equal(M, np.eye(5)) and not np.array_equal(M, a % p)]
s1, s2 = sig
Vp = eigspace(a, 1, p)
W0 = joint_eig([a, s1], [1, 1], p)          # chi0: trivial on V4  (dim 2)
W1 = joint_eig([a, s1], [1, -1], p)         # chi1: dim 1
print('dim V+ = %d, dim W_chi0 = %d, dim W_chi1 = %d' % (Vp.shape[0], W0.shape[0], W1.shape[0]))
print('F(W_chi1 generator) =', klein_F(W1[0], p))
zs = [klein_F((np.array([s, t], dtype=np.float64) @ W0) % p, p) for s in range(p) for t in range(1)]
# binary cubic F|_{W0}: interpolate coefficients in (s,t)
pts2 = [(1, 0), (0, 1), (1, 1), (1, 2)]
A2 = np.array([[pow(s, 3 - k, p) * pow(t, k, p) % p for k in range(4)] for s, t in pts2],
              dtype=np.float64)
r2 = np.array([klein_F((np.array([s, t], dtype=np.float64) @ W0) % p, p) for s, t in pts2],
              dtype=np.float64)
cb = mm(inv_p(A2, p), r2[:, None], p).ravel().astype(int).tolist()
print('binary cubic F|_{W_chi0} coeffs (s^3,s^2t,st^2,t^3):', cb)
print('F|_{W_chi0} identically zero?', all(v % p == 0 for v in cb))

# roots of the binary cubic over F_p and its factorisation type
import sympy
x = sympy.symbols('x')
poly = sum(sympy.Integer(cb[k]) * x ** (3 - k) for k in range(4))
fac = sympy.factor_list(sympy.Poly(poly, x, modulus=p, symmetric=False))
print('factorisation of F|_{W_chi0} over F_%d:' % p, fac)
roots_fp = [int(r) for r in range(p) if int(poly.subs(x, r)) % p == 0]
print('F_p-rational roots [s:t] with s=1:', roots_fp,
      '   (t=1,s=0 root?)', int(cb[3]) % p == 0)

# --- smoothness of C+ = X cap P(V+) over the algebraic closure, via msolve
mons3 = [(i, j, 3 - i - j) for i in range(3, -1, -1) for j in range(3 - i, -1, -1)]
pts3 = rng.integers(0, p, size=(10, 3)).astype(np.float64)
A3 = np.array([[pow(int(q[0]), m[0], p) * pow(int(q[1]), m[1], p) * pow(int(q[2]), m[2], p) % p
                for m in mons3] for q in pts3])
r3 = np.array([klein_F((q @ Vp) % p, p) for q in pts3], dtype=np.float64)
Ai = inv_p(A3, p)
assert Ai is not None
coef = mm(Ai, r3[:, None], p).ravel().astype(int).tolist()
names = ['s', 't', 'u']
terms = []
for c, m in zip(coef, mons3):
    if c % p:
        terms.append('%d*%s' % (c, '*'.join('%s^%d' % (names[i], m[i]) for i in range(3) if m[i])))
Fplane = '+'.join(terms)
print('C+ : ', Fplane)
# partial derivatives
part = []
for v in range(3):
    tt = []
    for c, m in zip(coef, mons3):
        if c % p and m[v]:
            e = list(m)
            e[v] -= 1
            mon = '*'.join('%s^%d' % (names[i], e[i]) for i in range(3) if e[i]) or '1'
            tt.append('%d*%s' % (c * m[v] % p, mon))
    part.append('+'.join(tt))
ms = os.path.join(HERE, 'results', 'cplus_jac_p%d.ms' % p)
open(ms, 'w').write('s,t,u\n%d\n' % p + ',\n'.join(part) + '\n')
assert '(' not in open(ms).read()
out = ms.replace('.ms', '.out')
subprocess.run(['msolve', '-g', '2', '-f', ms, '-o', out], check=True, timeout=300)
body = ''.join(l for l in open(out) if not l.startswith('#')).strip()
print('Jacobian ideal GB of C+ :', body[:200])
print('C+ SMOOTH (Jacobian ideal irrelevant)?',
      sorted(__import__('re').findall(r'1\*([stu])\^1', body)) == ['s', 't', 'u'])
