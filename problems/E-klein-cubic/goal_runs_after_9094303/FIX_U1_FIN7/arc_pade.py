#!/usr/bin/env python3
"""FIX-U1-FIN7 -- lift the Kuranishi arc along an essential direction to high
order and try to recognise it as a RATIONAL curve (Pade / rational function
reconstruction of the projective coordinates).

If the arc's projective coordinates are rational functions of low degree, the
essential deformation is a genuine algebraic curve in PO_1(7), the germ at the
classified point is strictly bigger than the torus orbit, and PO_1(7) is NOT a
finite union of torus orbits even on the non-degenerate stratum.
"""
import sys
import sympy as sp
import fin7_lib as L, fin7_modular as M, fin7_jac as JJ, fin7_equiv as E
import fin7_theta as TH

NMAX = int(sys.argv[1]) if len(sys.argv) > 1 else 26
p, omp, kpp = M.good_primes(100000, 1)[0]
names, eqs = L.landing_terms(); R = JJ.Fp(p)
eq_p = M.eqs_mod(eqs, p, omp, kpp); n = len(names); NE = len(eq_p)
tofp = lambda e: M.to_fp(e, {L.om: omp, L.kp: kpp}, p)

j = 0
coords = E.classified_point(j)
r1, r2 = M.block_points_mod(j, p, omp, kpp)
B20 = tofp(sp.expand((2*L.om+1)*L.om**(2*j)*(sp.Rational(4,3)*L.kp-sp.Rational(1,3))))
P10 = tofp(sp.expand(sp.Rational(4,3)*L.om**(j+1)*(sp.Rational(4,3)*L.kp-sp.Rational(1,3))))
B2v = [b for b in r1 if b != B20][0]; P1v = [b for b in r2 if b != P10][0]  # part D
P = M.point_mod(j, B2v, P1v, p, omp, kpp, names, coords)
J = JJ.jacobian(R, P, eq_p, names)
rk, pc, A2 = JJ.rank(R, J)
ker = JJ.nullspace(R, J, (rk, pc, A2))
print('part D: rank %d, dim ker %d' % (rk, len(ker)))

# an ESSENTIAL direction: a kernel vector in the Theta-eigenblock V_{om} that is
# not the torus one there.
_nm, EB = TH.eigen_basis()
EBp = {jm: [[tofp(c) for c in v] for v in EB[jm]] for jm in range(3)}
E3 = JJ.torus_rows()
Tv = [[E3[a][t] % p * P[t] % p for t in range(n)] for a in range(3)]
B = EBp[1]
cols = [[sum(J[i][t]*b[t] for t in range(n)) % p for i in range(NE)] for b in B]
Mb = [[cols[k][i] for k in range(13)] for i in range(NE)]
r0_, pc0, A0 = JJ.rank(R, Mb)
kb = JJ.nullspace(R, Mb, (r0_, pc0, A0))
kv = [[sum(c[k]*B[k][t] for k in range(13)) % p for t in range(n)] for c in kb]
# the torus direction inside V_om : project E_x.p
proj = []
for tv in Tv:
    pv = [0]*n
    for k in range(3):
        w = tv
        for _ in range(k):
            w2 = [0]*n
            for a in range(n):
                for b2 in range(n):
                    pass
            break
    proj.append(pv)
# simpler: pick the kernel combination independent from the torus span
def in_span(vec, basis):
    r1_, _, _ = JJ.rank(R, [[b[t] for b in basis] for t in range(n)])
    r2_, _, _ = JJ.rank(R, [[b[t] for b in basis] + [vec[t]] for t in range(n)])
    return r2_ == r1_
v = None
for a in range(len(kv)):
    for b2 in range(p):
        cand = [(kv[0][t] + b2*kv[1][t]) % p for t in range(n)] if a == 0 else kv[1]
        if not in_span(cand, Tv):
            v = cand
            break
    if v: break
print('essential direction found (not in the torus span):', v is not None)

def solve_complement(rhs):
    aug = [J[i][:] + [rhs[i]] for i in range(NE)]
    r_, pcs, A = JJ.rank(R, aug)
    if n in pcs:
        return None
    w = [0]*n
    for i, c1 in enumerate(pcs):
        w[c1] = A[i][n] % p
    return w

terms = [P[:], v[:]]
for N in range(2, NMAX+1):
    rhs = [0]*NE
    for ei, (_m, tl) in enumerate(eq_p):
        s = 0
        for c0, (i1, i2, i3) in tl:
            for a in range(len(terms)):
                for b2 in range(len(terms)):
                    c2 = N - a - b2
                    if c2 < 0 or c2 >= len(terms):
                        continue
                    s = (s + c0*terms[a][i1]*terms[b2][i2] % p * terms[c2][i3]) % p
        rhs[ei] = (-s) % p
    w = solve_complement(rhs)
    if w is None:
        print('OBSTRUCTED at order', N); break
    terms.append(w)
else:
    print('arc lifted to order %d with NO obstruction' % NMAX)

# rational reconstruction of coordinate ratios
def pade(series, d):
    """find num,den of degree <= d with num = den*series mod eps^(2d+1)."""
    Nn = 2*d + 1
    rows = []
    for k in range(Nn):
        row = [0]*(2*d+2)
        if k <= d:
            row[k] = 1                      # -num_k
        for i in range(d+1):
            if 0 <= k-i < len(series):
                row[d+1+i] = (-series[k-i]) % p
        rows.append(row)
    # nullspace of rows (Nn x (2d+2))
    r_, pcs, A = JJ.rank(R, rows)
    ns = JJ.nullspace(R, rows, (r_, pcs, A))
    return ns

t0 = max(range(n), key=lambda t: 1 if P[t] else 0)
ser0 = [terms[k][t0] % p for k in range(len(terms))]
inv0 = None
# series inverse of ser0
if ser0[0] == 0:
    print('bad normalising coordinate'); sys.exit()
inv = [pow(ser0[0], p-2, p)]
for k in range(1, len(ser0)):
    s = 0
    for i in range(1, k+1):
        s = (s + ser0[i]*inv[k-i]) % p
    inv.append((-s*inv[0]) % p)
found = {}
for t in range(n):
    ser = [sum(terms[i][t]*inv[k-i] for i in range(k+1)) % p
           for k in range(len(terms))]
    for d in range(1, (len(ser)-1)//2):
        ns = pade(ser, d)
        if ns:
            found[t] = d
            break
    else:
        found[t] = None
degs = sorted(set(found.values()), key=lambda z: (z is None, z))
print('Pade degrees of the 39 projective coordinates:', degs)
print('coordinates with no rational fit at degree < %d :' % ((len(terms)-1)//2),
      sum(1 for v2 in found.values() if v2 is None))

# --- is the projective arc a LINE?  (span of the series coefficients) -------
Mrank = [[terms[k][t] for k in range(len(terms))] for t in range(n)]
rr, _, _ = JJ.rank(R, Mrank)
print('rank of the span{P, v, w_2, ..., w_%d} :' % (len(terms)-1), rr)

# --- direct test: is the straight line P + s v inside the cone? -------------
def Fval(u):
    out = []
    for _m, tl in eq_p:
        s = 0
        for c0, (i1, i2, i3) in tl:
            s = (s + c0*u[i1]*u[i2] % p * u[i3]) % p
        out.append(s)
    return out
def Qval(u, w):
    out = []
    for _m, tl in eq_p:
        s = 0
        for c0, (i1, i2, i3) in tl:
            s = (s + c0*(u[i1]*w[i2] % p*P[i3] + u[i1]*P[i2] % p*w[i3]
                         + P[i1]*u[i2] % p*w[i3])) % p
        out.append(s)
    return out
print('Q(v,v) == 0 exactly :', all(c == 0 for c in Qval(v, v)))
print('F(v)   == 0 exactly :', all(c == 0 for c in Fval(v)))
for s in (1, 2, 7, 12345):
    u = [(P[t] + s*v[t]) % p for t in range(n)]
    print('  F(P + %6d v) == 0 :' % s, all(c == 0 for c in Fval(u)))
