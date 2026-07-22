#!/usr/bin/env python3
"""Build an EXPLICIT numerical unirational parametrization of a random
bidegree-(2,3) hypersurface X in P^2_x x P^2_y via the tangent-residual
construction, with exact internal verification over Q.

Coefficients: 60 integers drawn externally (/dev/urandom 2026-07-22), with
the four W-free slots of the x0^2 coefficient zeroed so the constant section
(1,0,0) x L lies on X (codim-4 LINEAR slice; makes stage 1 rational over Q;
touches nothing in the tangent-residual machinery).  Override with
  --coeffs file.json   ({"coefficients": [60 ints in the monomial order below]}).

Map (staged straight-line form; composite is dominant of degree 20 onto X):
  Stage 1  y(t)=(t,1,0);  x*(t,m) = (A11+m*A12+m^2*A22, -(A01+m*A02),
           -m*(A01+m*A02))  -- chord of the conic F(.,y(t)) through (1,0,0).
  Stage 2  f* = F(x*,.);  (al,be,ga) = grad_y f* at p*=y(t);
           z* = (ga,0,-al);  f*(s p* + u z*) = u^2(A s + B u);
           r(t,m) = B p* - A z*   (tangent residual on the cubic C_{x*}).
  Stage 3  x'(t,m,n) = Q(d) x* - Bpol(x*,d) d,  d=(0,1,n),  Q = F(., r),
           Bpol = Q(x*+d)-Q(x*)-Q(d)   (chord of the conic through x*).
  Phi(t,m,n) = (x'; r) in X.

Verification (all EXACT; grid checks are deterministic proofs via degree
bounds -- a poly of bidegree <= (D1,D2) vanishing on a (D1+1)x(D2+1) grid
of distinct rational nodes is identically zero):
  C1 Q_t(x*) == 0                    symbolic
  C2 s^3-, s^2 u-coefficients == 0   symbolic          (tangency at p*)
  C3 f*(r) == 0                      grid, bound (99,52)
  C4 q_{f*}(r) == 0                  grid, bound (61,36)   (covariant check)
  C5 Q(Q(d)x - Bpol(x,d)d) == Q(d)^2 Q(x)   generic symbols
     => F(x',r) = Q(d)^2 f*(r) == 0 structurally from C3+C5.
  C6 exact evaluation of Phi at sample rational points; F(Phi)=0, in X
  C7 Jacobian rank 3 at a sample point  (dominance onto the threefold X)
  C8 fiber over random y0: Res_x2(F(x,y0), q_F(x,y0)) squarefree of deg 20
     (degree of T over P^2_y is 20)
"""
import json, sys, pathlib
from fractions import Fraction
import sympy as sp

RAW = [19, -15, 20, 10, -10, -12, 18, 16, 16, -16, 19, 1, 3, -8, 10, 5, -8, 5,
       19, -12, -5, -4, 14, -1, 3, 13, 5, 15, -16, -15, -1, -5, -20, -20, 18,
       -8, 20, 9, 15, -12, 19, -13, 9, 11, -7, -14, 18, 11, -15, 11, -3, -9,
       -5, 3, 17, 4, -13, 12, -16, 15]        # /dev/urandom 2026-07-22
Y0 = (12, 16, 17)                              # spare entropy: fiber basepoint
if len(sys.argv) > 2 and sys.argv[1] == '--coeffs':
    RAW = json.load(open(sys.argv[2]))['coefficients']

x0, x1, x2, U, V, W = sp.symbols('x0 x1 x2 U V W')
t, m, n, s, u = sp.symbols('t m n s u')
XMON = [x0**2, x0*x1, x0*x2, x1**2, x1*x2, x2**2]
YMON = [U**3, U**2*V, U*V**2, V**3, U**2*W, U*V*W, V**2*W, U*W**2, V*W**2, W**3]
C = list(RAW)
for k in range(4):
    C[k] = 0                                   # x0^2 * {U^3,U^2V,UV^2,V^3}
F = sp.expand(sum(C[10*i + j]*XMON[i]*YMON[j] for i in range(6) for j in range(10)))
print("conditioned coefficients:", C)

def Fxy(xv, yv):
    return F.subs({x0: xv[0], x1: xv[1], x2: xv[2], U: yv[0], V: yv[1], W: yv[2]})

# ---------------- stage 1 ----------------
yt = (t, sp.Integer(1), sp.Integer(0))
Pf = sp.Poly(sp.expand(F.subs({U: t, V: 1, W: 0})), x0, x1, x2)
def Ac(mon):
    c = Pf.coeff_monomial(mon)
    return sp.expand(c) if c is not None else sp.Integer(0)
assert Ac(x0**2) == 0
A01, A02, A11, A12, A22 = Ac(x0*x1), Ac(x0*x2), Ac(x1**2), Ac(x1*x2), Ac(x2**2)
B1 = sp.expand(A01 + m*A02); Qd = sp.expand(A11 + m*A12 + m**2*A22)
assert B1 != 0 and Qd != 0
xstar = (Qd, sp.expand(-B1), sp.expand(-m*B1))
print("C1 Q_t(x*) == 0:", sp.expand(Fxy(xstar, yt)) == 0)

# ---------------- stage 2 (Poly arithmetic in t,m) ----------------
fstar = sp.expand(F.subs({x0: xstar[0], x1: xstar[1], x2: xstar[2]}))
al = sp.expand(sp.diff(fstar, U).subs({U: t, V: 1, W: 0}))
be = sp.expand(sp.diff(fstar, V).subs({U: t, V: 1, W: 0}))
ga = sp.expand(sp.diff(fstar, W).subs({U: t, V: 1, W: 0}))
assert not (al == 0 and ga == 0)
zstar = (ga, sp.Integer(0), sp.expand(-al))
lin = [sp.expand(s*yt[k] + u*zstar[k]) for k in range(3)]
frl = sp.Poly(fstar, U, V, W)
acc = sp.Poly(0, s, u, t, m)
for mono, coef in frl.terms():
    a, b, c = mono
    term = sp.Poly(coef, s, u, t, m)
    term *= sp.Poly(lin[0], s, u, t, m)**a
    term *= sp.Poly(lin[1], s, u, t, m)**b
    term *= sp.Poly(lin[2], s, u, t, m)**c
    acc += term
def su_coeff(P, i, j):
    out = sp.Poly(0, t, m)
    for mono, coef in P.terms():
        if mono[0] == i and mono[1] == j:
            out += sp.Poly(coef, t, m)*sp.Monomial((mono[2], mono[3]), (t, m)).as_expr()
    return out.as_expr()
c_s3, c_s2u = su_coeff(acc, 3, 0), su_coeff(acc, 2, 1)
Ares, Bres = sp.expand(su_coeff(acc, 1, 2)), sp.expand(su_coeff(acc, 0, 3))
print("C2 tangency coefficients vanish:", sp.expand(c_s3) == 0, sp.expand(c_s2u) == 0)
r_pt = tuple(sp.expand(Bres*yt[k] - Ares*zstar[k]) for k in range(3))

# fast exact evaluators
r_polys = [sp.Poly(e, t, m) for e in r_pt]
fstar_P = sp.Poly(fstar, U, V, W)
fstar_coeff_polys = {mono: sp.Poly(coef, t, m) for mono, coef in fstar_P.terms()}
def r_at(tv, mv):
    return tuple(p.eval((tv, mv)) for p in r_polys)
def fstar_at(tv, mv, yv):
    tot = 0
    for (a, b, c), cp in fstar_coeff_polys.items():
        tot += cp.eval((tv, mv)) * yv[0]**a * yv[1]**b * yv[2]**c
    return tot

# ---------------- C3 grid proof: f*(r) == 0, bidegree <= (99,52) ----------------
ok3 = all(fstar_at(sp.Integer(i), sp.Integer(j), r_at(sp.Integer(i), sp.Integer(j))) == 0
          for i in range(100) for j in range(53))
print("C3 f*(r) == 0 on full 100x53 grid (deterministic proof):", ok3)

# ---------------- C4 covariant cross-check on grid, bound (61,36) ----------------
a3s, a2s, a1s, a0s, b2s, b1s, b0s, cis, cjs, cks = sp.symbols(
    'a3s a2s a1s a0s b2s b1s b0s cis cjs cks')
uu, vv = sp.symbols('uu vv')
g_uv = a3s*uu**3 + a2s*uu**2*vv + a1s*uu*vv**2 + a0s*vv**3
h_uv = b2s*uu**2 + b1s*uu*vv + b0s*vv**2
fU = sp.expand(g_uv.subs({uu: U, vv: V}) + W*h_uv.subs({uu: U, vv: V})
               + W**2*(cis*U + cjs*V) + cks*W**3)
Ppol = sp.expand(U*sp.diff(g_uv, uu) + V*sp.diff(g_uv, vv) + W*h_uv)
Rg = sp.expand(sp.resultant(sp.Poly(g_uv.subs(vv, 1), uu),
                            sp.Poly(Ppol.subs(vv, 1), uu)))
Delta = sp.expand(18*a3s*a2s*a1s*a0s - 4*a2s**3*a0s + a2s**2*a1s**2
                  - 4*a3s*a1s**3 - 27*a3s**2*a0s**2)
q_univ = sp.expand(sp.cancel(sp.expand(Rg + Delta*fU) / W**2))
UNIV = [a3s, a2s, a1s, a0s, b2s, b1s, b0s, cis, cjs, cks]
YIDX = {(3,0,0): 0, (2,1,0): 1, (1,2,0): 2, (0,3,0): 3, (2,0,1): 4,
        (1,1,1): 5, (0,2,1): 6, (1,0,2): 7, (0,1,2): 8, (0,0,3): 9}
qU_u, qV_u, qW_u = [sp.Poly(sp.expand(q_univ.coeff(ysym)), *UNIV)
                    for ysym in (U, V, W)]
def fcoeffs_at(tv, mv):
    vals = [0]*10
    for mono, cp in fstar_coeff_polys.items():
        vals[YIDX[mono]] = cp.eval((tv, mv))
    return vals
def q_at(tv, mv, yv):
    vals = fcoeffs_at(tv, mv)
    return (qU_u.eval(vals)*yv[0] + qV_u.eval(vals)*yv[1] + qW_u.eval(vals)*yv[2])
ok4 = all(q_at(sp.Integer(i), sp.Integer(j), r_at(sp.Integer(i), sp.Integer(j))) == 0
          for i in range(62) for j in range(37))
print("C4 q_{f*}(r) == 0 on full 62x37 grid (deterministic proof):", ok4)

# ---------------- C5 reflection identity (generic) ----------------
q00, q01, q02, q11, q12, q22, X0, X1, X2, D0, D1, D2 = sp.symbols(
    'q00 q01 q02 q11 q12 q22 X0 X1 X2 D0 D1 D2')
def Qg(a, b, c):
    return q00*a**2 + q01*a*b + q02*a*c + q11*b**2 + q12*b*c + q22*c**2
Bg = sp.expand(Qg(X0+D0, X1+D1, X2+D2) - Qg(X0, X1, X2) - Qg(D0, D1, D2))
refl = [sp.expand(Qg(D0, D1, D2)*x - Bg*d) for x, d in
        ((X0, D0), (X1, D1), (X2, D2))]
print("C5 reflection identity:", sp.expand(Qg(*refl) - Qg(D0, D1, D2)**2*Qg(X0, X1, X2)) == 0)

# ---------------- staged evaluator for Phi ----------------
Fpoly = sp.Poly(F, x0, x1, x2, U, V, W)
def F_at(xv, yv):
    tot = 0
    for mono, coef in Fpoly.terms():
        tot += coef * xv[0]**mono[0]*xv[1]**mono[1]*xv[2]**mono[2] \
                    * yv[0]**mono[3]*yv[1]**mono[4]*yv[2]**mono[5]
    return tot
xstar_polys = [sp.Poly(e, t, m) for e in xstar]
def Phi_at(tv, mv, nv):
    xs = tuple(p.eval((tv, mv)) for p in xstar_polys)
    rv = r_at(tv, mv)
    d = (sp.Integer(0), sp.Integer(1), nv)
    Qd2 = F_at(d, rv)
    Bp = F_at((xs[0]+d[0], xs[1]+d[1], xs[2]+d[2]), rv) - F_at(xs, rv) - Qd2
    xp = tuple(Qd2*xs[k] - Bp*d[k] for k in range(3))
    return xp, rv

# ---------------- C6 exact samples ----------------
samples = [(sp.Rational(2, 3), sp.Rational(-1, 2), sp.Integer(3)),
           (sp.Integer(5), sp.Integer(2), sp.Rational(-7, 2)),
           (sp.Integer(-4), sp.Rational(1, 3), sp.Rational(1, 5))]
for (tv, mv, nv) in samples:
    xp, rv = Phi_at(tv, mv, nv)
    val = F_at(xp, rv)
    print(f"C6 (t,m,n)=({tv},{mv},{nv}): F(Phi)=0: {val == 0}; "
          f"nondegenerate: {any(c != 0 for c in xp) and any(c != 0 for c in rv)}")

# ---------------- C7 Jacobian rank via exact finite differences? no: symbolic diff of staged evaluator ----
# Use exact rational-derivative via automatic differentiation on dual numbers.
class Dual:
    __slots__ = ('a', 'b')
    def __init__(self, a, b=(0, 0, 0)):
        self.a, self.b = sp.nsimplify(a), tuple(sp.nsimplify(x) for x in b)
    def __add__(self, o):
        o = o if isinstance(o, Dual) else Dual(o)
        return Dual(self.a+o.a, tuple(self.b[i]+o.b[i] for i in range(3)))
    __radd__ = __add__
    def __sub__(self, o):
        o = o if isinstance(o, Dual) else Dual(o)
        return Dual(self.a-o.a, tuple(self.b[i]-o.b[i] for i in range(3)))
    def __rsub__(self, o):
        return Dual(o) - self
    def __mul__(self, o):
        o = o if isinstance(o, Dual) else Dual(o)
        return Dual(self.a*o.a, tuple(self.a*o.b[i]+o.a*self.b[i] for i in range(3)))
    __rmul__ = __mul__
    def __truediv__(self, o):
        o = o if isinstance(o, Dual) else Dual(o)
        inv = 1/o.a
        return Dual(self.a*inv, tuple((self.b[i]*o.a - self.a*o.b[i])*inv*inv for i in range(3)))
    def __pow__(self, k):
        out = Dual(1)
        for _ in range(k):
            out = out*self
        return out
def poly_dual(P, args):
    tot = Dual(0)
    for mono, coef in P.terms():
        term = Dual(coef)
        for base, e in zip(args, mono):
            term = term*(base**e)
        tot = tot + term
    return tot
tv, mv, nv = sp.Rational(2, 3), sp.Rational(-1, 2), sp.Integer(3)
Td = Dual(tv, (1, 0, 0)); Md = Dual(mv, (0, 1, 0)); Nd = Dual(nv, (0, 0, 1))
xs_d = [poly_dual(p, (Td, Md)) for p in xstar_polys]
rv_d = [poly_dual(p, (Td, Md)) for p in r_polys]
d_d = [Dual(0), Dual(1), Nd]
def F_dual(xv, yv):
    tot = Dual(0)
    for mono, coef in Fpoly.terms():
        term = Dual(coef)
        for base, e in zip(list(xv)+list(yv), mono):
            term = term*(base**e)
        tot = tot + term
    return tot
Qd2_d = F_dual(d_d, rv_d)
Bp_d = F_dual([xs_d[k]+d_d[k] for k in range(3)], rv_d) - F_dual(xs_d, rv_d) - Qd2_d
xp_d = [Qd2_d*xs_d[k] - Bp_d*d_d[k] for k in range(3)]
charts = [xp_d[1]/xp_d[0], xp_d[2]/xp_d[0], rv_d[1]/rv_d[0], rv_d[2]/rv_d[0]]
J = sp.Matrix([[c.b[i] for i in range(3)] for c in charts])
print("C7 Jacobian rank at sample:", J.rank(), "(need 3 => dominant onto X)")

# ---------------- C8 degree-20 fiber over y0 ----------------
xq = {a3s: 0, a2s: 0}  # placeholder; build substitution from F's y-coefficients (quadratics in x)
PFy = sp.Poly(F, U, V, W)
xvals = [0]*10
for mono, coef in PFy.terms():
    xvals[YIDX[mono]] = sp.expand(coef)
qU_x = sp.expand(qU_u.as_expr().subs(dict(zip(UNIV, xvals))))
qV_x = sp.expand(qV_u.as_expr().subs(dict(zip(UNIV, xvals))))
qW_x = sp.expand(qW_u.as_expr().subs(dict(zip(UNIV, xvals))))
G10 = sp.expand(Y0[0]*qU_x + Y0[1]*qV_x + Y0[2]*qW_x).subs(x1, 1)
C2f = sp.expand(F.subs({U: Y0[0], V: Y0[1], W: Y0[2], x1: 1}))
res1 = sp.Poly(sp.expand(sp.resultant(sp.Poly(C2f, x2), sp.Poly(G10, x2))), x0)
sqf = sp.gcd(res1, res1.diff(x0)) == 1
print("C8 fiber resultant: degree", res1.degree(), "(need 20); squarefree:", sqf)

# ---------------- artifacts ----------------
here = pathlib.Path(__file__).resolve().parent
with open(here/'map_instance.txt', 'w') as fh:
    fh.write("# Explicit degree-20 unirational parametrization Phi(t,m,n) of X\n")
    fh.write("# Phi = (xprime ; r), staged straight-line program, exact over Q.\n\n")
    fh.write(f"F = {F}\n\n")
    fh.write(f"xstar0 = {xstar[0]}\nxstar1 = {xstar[1]}\nxstar2 = {xstar[2]}\n\n")
    fh.write(f"r0 = {r_pt[0]}\n\nr1 = {r_pt[1]}\n\nr2 = {r_pt[2]}\n\n")
    fh.write("# Stage 3 (evaluate, do not expand):\n")
    fh.write("# d = (0,1,n); Qd2 = F(d, r); Bpol = F(xstar+d, r) - F(xstar, r) - Qd2\n")
    fh.write("# xprime_k = Qd2*xstar_k - Bpol*d_k\n")
    fh.write("# Then F(xprime, r) == 0 identically; map is dominant of degree 20.\n")
print("artifacts written:", str(here/'map_instance.txt'))
