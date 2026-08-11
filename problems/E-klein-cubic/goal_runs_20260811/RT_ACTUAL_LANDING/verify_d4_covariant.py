#!/usr/bin/env python3
"""verify_d4_covariant.py

Independent audit of the explicit degree-four divergence-free G-covariant D_4
produced by `verify_low_degree_covariants.py`.

D_4 is a new named object entering the repository, so it is re-checked here by a
separate arithmetic path.  `verify_low_degree_covariants.py` builds the whole
representation with sympy DomainMatrix over Q(zeta_11) and takes nullspaces;
this file hardcodes only the CLAIMED D_4 and verifies, from scratch:

  * D_4 is homogeneous of degree 4, primitive, and not a multiple of the Euler
    field;
  * div D_4 = 0;
  * sigma-covariance (the cyclic shift), by direct substitution;
  * tau-covariance (the diagonal z^{(-2)^i} action), as a weight condition;
  * iota-covariance under the THIRD generator -- the one that actually cuts the
    space from 7 to 2 -- with iota rebuilt here from the repository's own
    formula (exact_schur_frame/exact_representation_core.py, weil_generators()[0])
    rather than imported, and with Q(zeta_11) implemented as Q[z]/(z^11-1) plus
    the relation 1+z+...+z^10 = 0, so the field arithmetic shares no code with
    the script under audit.

Since <sigma, tau, iota> is the full group of order 660 (enumerated in
`verify_low_degree_covariants.py`), these three conditions are exactly
G-covariance.  Everything is exact; no floating point.
"""

import sys

OK = True


def chk(name, cond):
    global OK
    print(("  ok   " if cond else "  FAIL ") + name)
    OK = OK and bool(cond)


print('=' * 72)
print('A. D_4: shape, divergence, sigma- and tau-covariance')
print('=' * 72)
import sympy as sp

x = sp.symbols('x0 x1 x2 x3 x4')
x0, x1, x2, x3, x4 = x

D = [
 2*x3**4 + 8*x1*x2*x4**2 - x0*x3**2*x4 - 9*x0*x2**2*x3 + 7*x0*x1**2*x2 + 3*x0**2*x4**2 - x0**3*x1,
 2*x4**4 - 9*x1*x3**2*x4 + 7*x1*x2**2*x3 - x1**3*x2 - x0*x1*x4**2 + 8*x0**2*x2*x3 + 3*x0**2*x1**2,
 7*x2*x3**2*x4 - x2**3*x3 + 8*x1**2*x3*x4 + 3*x1**2*x2**2 - 9*x0*x2*x4**2 - x0**2*x1*x2 + 2*x0**4,
 -x3**3*x4 + 3*x2**2*x3**2 - x1**2*x2*x3 + 2*x1**4 + 7*x0*x3*x4**2 + 8*x0*x2**2*x4 - 9*x0**2*x1*x3,
 3*x3**2*x4**2 - x2**2*x3*x4 + 2*x2**4 - 9*x1**2*x2*x4 - x0*x4**3 + 8*x0*x1*x3**2 + 7*x0**2*x1*x4,
]
D = [sp.expand(f) for f in D]


chk("all five components homogeneous of degree 4",
    all(sp.Poly(f, *x).is_homogeneous and sp.Poly(f, *x).total_degree() == 4 for f in D))

# (a) divergence-free
div = sp.expand(sum(sp.diff(D[i], x[i]) for i in range(5)))
chk("div D_4 = 0   (got %s)" % div, div == 0)

# (b) sigma-covariance: sigma sends x_i -> x_{i+1}; covariance T(sigma x) = sigma T(x)
#     means component i of T evaluated at shifted vars equals component i+1.
sub = {x[i]: x[(i + 1) % 5] for i in range(5)}
chk("sigma-covariance: D_i(x_{j+1}) = D_{i+1}(x) for all i",
    all(sp.expand(D[i].subs(sub, simultaneous=True) - D[(i + 1) % 5]) == 0 for i in range(5)))

# (c) tau-covariance: x_i -> z^{a_i} x_i with a = (1,9,4,3,5); every monomial of
#     component i must carry total weight = a_i mod 11.
a = [1, 9, 4, 3, 5]
bad = []
for i in range(5):
    P = sp.Poly(D[i], *x)
    for mon in P.monoms():
        w = sum(a[j] * mon[j] for j in range(5)) % 11
        if w != a[i] % 11:
            bad.append((i, mon, w))
chk("tau-covariance: every monomial of component i has weight a_i mod 11 "
    "(a = 1,9,4,3,5); %d violations" % len(bad), not bad)

# (d) sanity: the Klein cubic really is tau-invariant with these weights
F = sum(x[i]**2 * x[(i + 1) % 5] for i in range(5))
badF = [m for m in sp.Poly(sp.expand(F), *x).monoms()
        if sum(a[j] * m[j] for j in range(5)) % 11 != 0]
chk("the Klein cubic F has all monomials of tau-weight 0", not badF)
chk("F is sigma-invariant", sp.expand(F.subs(sub, simultaneous=True) - F) == 0)

# (e) D_4 is primitive and not a multiple of the Euler field
g = D[0]
for f in D[1:]:
    g = sp.gcd(g, f)
chk("D_4 is primitive (gcd of components = %s)" % g, g == 1)
chk("D_4 is not f * (x_0..x_4) for any cubic f",
    any(sp.rem(sp.Poly(D[i], *x), sp.Poly(x[i], *x)) != 0 for i in range(5)))

# (f) the companion fact used in Lemma 2.1 of FOLIATION_REFORMULATION.md
Fx = [sp.expand(F * x[i]) for i in range(5)]
divFx = sp.expand(sum(sp.diff(Fx[i], x[i]) for i in range(5)))
chk("div(F x) = 8F exactly", sp.expand(divFx - 8 * F) == 0)


print()
print('=' * 72)
print('B. iota-covariance, with iota rebuilt from the repository formula')
print('=' * 72)
from fractions import Fraction as Fr
from itertools import product

N = 11
ZERO = (Fr(0),) * N


def z(e):
    v = [Fr(0)] * N
    v[e % N] = Fr(1)
    return tuple(v)


ONE = z(0)


def add(a, b):
    return tuple(a[i] + b[i] for i in range(N))


def sub(a, b):
    return tuple(a[i] - b[i] for i in range(N))


def smul(c, a):
    c = Fr(c)
    return tuple(c * a[i] for i in range(N))


def mul(a, b):
    out = [Fr(0)] * N
    for i in range(N):
        if a[i]:
            for j in range(N):
                if b[j]:
                    out[(i + j) % N] += a[i] * b[j]
    return tuple(out)


def eq(a, b):
    d = sub(a, b)
    return all(d[i] == d[0] for i in range(N))


def is_zero(a):
    return eq(a, ZERO)


# ---- iota, from the repository formula -------------------------------------
QR = {1, 3, 4, 5, 9}
gauss = ZERO
for e in range(1, 11):
    gauss = add(gauss, smul(1 if e in QR else -1, z(e)))
# gauss^2 must be -11
assert eq(mul(gauss, gauss), smul(-11, ONE)), "Gauss sum check failed"

indices = [1, 3, 2, 5, 4]
signs = [1, 1, -1, 1, 1]
iota = []
for row, left in enumerate(indices):
    r = []
    for col, right in enumerate(indices):
        t = sub(z((9 * left * right) % 11), z((-9 * left * right) % 11))
        t = mul(t, smul(-1, gauss))
        t = smul(Fr(signs[col], signs[row]), t)
        t = smul(Fr(1, 11), t)
        r.append(t)
    iota.append(r)

# tau, for the record
tau = [[z((indices[i] * indices[i]) % 11) if i == j else ZERO for j in range(5)]
       for i in range(5)]
assert [tau[i][i] for i in range(5)] == [z(1), z(9), z(4), z(3), z(5)], "tau mismatch"

# iota^2 = I
prod2 = [[ZERO] * 5 for _ in range(5)]
for i in range(5):
    for j in range(5):
        s = ZERO
        for k in range(5):
            s = add(s, mul(iota[i][k], iota[k][j]))
        prod2[i][j] = s
chk("iota^2 = identity",
    all(eq(prod2[i][j], ONE if i == j else ZERO) for i in range(5) for j in range(5)))
chk("trace(iota) = 1 (a legal 5-dim character value)",
    eq(add(add(add(add(iota[0][0], iota[1][1]), iota[2][2]), iota[3][3]), iota[4][4]), ONE))

# ---- polynomials in x_0..x_4 over Q(zeta_11) --------------------------------
# represented as dict: exponent-tuple -> field element


def pmul(p, q):
    out = {}
    for m1, c1 in p.items():
        for m2, c2 in q.items():
            m = tuple(m1[i] + m2[i] for i in range(5))
            out[m] = add(out.get(m, ZERO), mul(c1, c2))
    return out


def padd(p, q):
    out = dict(p)
    for m, c in q.items():
        out[m] = add(out.get(m, ZERO), c)
    return out


def pscal(c, p):
    return {m: mul(c, v) for m, v in p.items()}


def pzero(p):
    return all(is_zero(v) for v in p.values())


def var(i):
    e = [0] * 5
    e[i] = 1
    return {tuple(e): ONE}


def const(c):
    return {(0, 0, 0, 0, 0): smul(c, ONE)}


def ppow(p, n):
    r = const(1)
    for _ in range(n):
        r = pmul(r, p)
    return r


# D_4, as reported
TERMS = [
    [(2, (0, 0, 0, 4, 0)), (8, (0, 1, 1, 0, 2)), (-1, (1, 0, 0, 2, 1)),
     (-9, (1, 0, 2, 1, 0)), (7, (1, 2, 1, 0, 0)), (3, (2, 0, 0, 0, 2)),
     (-1, (3, 1, 0, 0, 0))],
    [(2, (0, 0, 0, 0, 4)), (-9, (0, 1, 0, 2, 1)), (7, (0, 1, 2, 1, 0)),
     (-1, (0, 3, 1, 0, 0)), (-1, (1, 1, 0, 0, 2)), (8, (2, 0, 1, 1, 0)),
     (3, (2, 2, 0, 0, 0))],
    [(7, (0, 0, 1, 2, 1)), (-1, (0, 0, 3, 1, 0)), (8, (0, 2, 0, 1, 1)),
     (3, (0, 2, 2, 0, 0)), (-9, (1, 0, 1, 0, 2)), (-1, (2, 1, 1, 0, 0)),
     (2, (4, 0, 0, 0, 0))],
    [(-1, (0, 0, 0, 3, 1)), (3, (0, 0, 2, 2, 0)), (-1, (0, 2, 1, 1, 0)),
     (2, (0, 4, 0, 0, 0)), (7, (1, 0, 0, 1, 2)), (8, (1, 0, 2, 0, 1)),
     (-9, (2, 1, 0, 1, 0))],
    [(3, (0, 0, 0, 2, 2)), (-1, (0, 0, 2, 1, 1)), (2, (0, 0, 4, 0, 0)),
     (-9, (0, 2, 1, 0, 1)), (-1, (1, 0, 0, 0, 3)), (8, (1, 1, 0, 2, 0)),
     (7, (2, 1, 0, 0, 1))],
]
D = []
for comp in TERMS:
    p = {}
    for c, m in comp:
        p[m] = add(p.get(m, ZERO), smul(c, ONE))
    D.append(p)

chk("D_4 has 7 terms in each of the five components",
    all(len(c) == 7 for c in TERMS))

# substitution x_j -> sum_k iota[j][k] x_k
subst = [{} for _ in range(5)]
for j in range(5):
    p = {}
    for k in range(5):
        e = [0] * 5
        e[k] = 1
        p[tuple(e)] = iota[j][k]
    subst[j] = p


def apply_subst(p):
    out = {}
    for m, c in p.items():
        term = {(0, 0, 0, 0, 0): c}
        for j in range(5):
            if m[j]:
                term = pmul(term, ppow(subst[j], m[j]))
        out = padd(out, term)
    return out


# left side: D_i(iota x); right side: sum_k iota[i][k] D_k(x)
lhs = [apply_subst(D[i]) for i in range(5)]
rhs = []
for i in range(5):
    s = {}
    for k in range(5):
        s = padd(s, pscal(iota[i][k], D[k]))
    rhs.append(s)
chk("IOTA-COVARIANCE: D_4(iota x) = iota D_4(x), all five components",
    all(pzero(padd(lhs[i], pscal(smul(-1, ONE), rhs[i]))) for i in range(5)))

# and the Klein cubic is iota-invariant, as a control
F = {}
for i in range(5):
    e = [0] * 5
    e[i] += 2
    e[(i + 1) % 5] += 1
    F[tuple(e)] = ONE
chk("control: F(iota x) = F(x)",
    pzero(padd(apply_subst(F), pscal(smul(-1, ONE), F))))


print()
print("RESULT: " + ("PASS" if OK else "FAIL"))
sys.exit(0 if OK else 1)
