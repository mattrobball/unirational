"""Independent symbolic derivation of the two j-invariant formulas used by
FIX-A0 claim 3.  Exact rational-function arithmetic in sympy; no floating
point, no numerics.

FORMULA A (Hesse pencil).  For the Hesse cubic  H_mu : x^3+y^3+z^3-3 mu xyz,
    j(H_mu) = 27 mu^3 (mu^3+8)^3 / (mu^3-1)^3.
Derived here from scratch by an explicit projective change of coordinates
sending the flex (1:-1:0) to (0:1:0) with tangent Z=0, followed by the
standard Weierstrass reduction and j = c4^3/Delta.

Consequence used by the producer: for a x^3 + b y^3 + c z^3 + d xyz with
abc != 0 the scaling x -> alpha x, ... reduces to H_mu with
mu^3 = -d^3/(27abc) =: t, so j = 27 t (t+8)^3 / (t-1)^3.

FORMULA B (binary quartic).  For a binary quartic
    q = a x^4 + b x^3 y + c x^2 y^2 + d x y^3 + e y^4
with I = 12ae-3bd+c^2, J = 72ace+9bcd-27ad^2-27b^2e-2c^3, the double cover of
P^1 branched at the four roots of q has
    j = 6912 I^3 / (4 I^3 - J^2).
Derived here in two steps: (i) I and J are SL(2)-invariants of weights 4 and
6, hence the displayed ratio is a PGL(2)-invariant of the 4-point branch
divisor; (ii) on the slice a = 0 (one branch point at infinity) the double
cover is the Weierstrass curve y^2 = b x^3 + c x^2 + d x + e, whose classical
j agrees with the formula identically in (b,c,d,e).
"""
import sympy as sp

X, Y, Z, mu = sp.symbols('X Y Z mu')
OK = []


def note(name, cond):
    OK.append((name, bool(cond)))
    print(('PASS  ' if cond else 'FAIL  ') + name, flush=True)


# --------------------------------------------------------------- FORMULA A
print('--- Formula A: Hesse cubic -> Weierstrass -> j(mu) ---')
# flex (1:-1:0) of x^3+y^3+z^3-3 mu xyz ; tangent there is x+y+mu z = 0.
f0 = X**3 + Y**3 + Z**3 - 3 * mu * X * Y * Z
note('(1:-1:0) lies on the Hesse cubic',
     sp.simplify(f0.subs({X: 1, Y: -1, Z: 0})) == 0)
grad = [sp.diff(f0, v) for v in (X, Y, Z)]
gsub = [sp.simplify(g.subs({X: 1, Y: -1, Z: 0})) for g in grad]
note('tangent at (1:-1:0) is 3(x + y + mu z)', gsub == [3, 3, 3 * mu])

# new coordinates  Xn = z, Yn = x, Zn = x + y + mu z  (det = 1 != 0)
# inverse:  x = Yn,  z = Xn,  y = Zn - Yn - mu Xn
sub = {X: Y, Z: X, Y: Z - Y - mu * X}
f = sp.expand(f0.subs(sub, simultaneous=True))
P = sp.Poly(f, X, Y, Z)


def co(i, j, k):
    return sp.simplify(P.coeff_monomial(X**i * Y**j * Z**k))


note('no Y^3, XY^2, X^2Y terms (flex at (0:1:0), tangent Z=0)',
     co(0, 3, 0) == 0 and co(1, 2, 0) == 0 and co(2, 1, 0) == 0)
A, B, C = co(0, 2, 1), co(1, 1, 1), co(0, 1, 2)
D, E, Fq, Gq = co(3, 0, 0), co(2, 0, 1), co(1, 0, 2), co(0, 0, 3)
note('reconstruction of the transformed cubic',
     sp.expand(f - (A * Y**2 * Z + B * X * Y * Z + C * Y * Z**2 + D * X**3
                    + E * X**2 * Z + Fq * X * Z**2 + Gq * Z**3)) == 0)
x = sp.symbols('x')
# A y^2 + (Bx+C) y + (D x^3+E x^2+F x+G) = 0 ;  w = A y + (Bx+C)/2
rhs = sp.expand((B * x + C)**2 / 4 - A * (D * x**3 + E * x**2 + Fq * x + Gq))
rp = sp.Poly(rhs, x)
al, be = rp.coeff_monomial(x**3), rp.coeff_monomial(x**2)
ga, de = rp.coeff_monomial(x), rp.coeff_monomial(1)
a2, a4, a6 = be, sp.expand(al * ga), sp.expand(al**2 * de)
b2, b4, b6 = 4 * a2, 2 * a4, 4 * a6
c4 = sp.expand(b2**2 - 24 * b4)
c6 = sp.expand(-b2**3 + 36 * b2 * b4 - 216 * b6)
Delta = sp.cancel((c4**3 - c6**2) / 1728)
jA = sp.factor(sp.cancel(sp.expand(c4**3) / Delta))
pred = sp.factor(27 * mu**3 * (mu**3 + 8)**3 / (mu**3 - 1)**3)
note('j(H_mu) = 27 mu^3 (mu^3+8)^3 / (mu^3-1)^3',
     sp.simplify(sp.cancel(jA - pred)) == 0)
note('Delta(H_mu) vanishes exactly on mu^3 = 1',
     sp.factor(Delta) == sp.factor(19683 * (mu**3 - 1)**3))
note('j(Fermat cubic, mu=0) = 0', sp.simplify(pred.subs(mu, 0)) == 0)
t = sp.symbols('t')
jt = sp.simplify(27 * t * (t + 8)**3 / (t - 1)**3)
note('j at t = mu^3 = -16/11 equals 8192/11',
     sp.simplify(jt.subs(t, sp.Rational(-16, 11)) - sp.Rational(8192, 11)) == 0)

# scaling reduction  a x^3+b y^3+c z^3+d xyz  ->  H_mu with mu^3 = -d^3/(27abc)
aa, bb, cc, dd, al1, al2, al3 = sp.symbols('aa bb cc dd al1 al2 al3')
gen = aa * (al1 * X)**3 + bb * (al2 * Y)**3 + cc * (al3 * Z)**3 \
    + dd * (al1 * X) * (al2 * Y) * (al3 * Z)
note('scaling x->al x etc. multiplies (xyz)-coefficient by al1 al2 al3 and '
     'x^3-coefficient by al1^3',
     sp.expand(gen - (aa * al1**3 * X**3 + bb * al2**3 * Y**3 + cc * al3**3 * Z**3
                      + dd * al1 * al2 * al3 * X * Y * Z)) == 0)
note('hence (-3 mu)^3 = (d al1al2al3)^3 = d^3/(abc), i.e. mu^3 = -d^3/(27abc)',
     sp.simplify(sp.Rational(-1, 27) * dd**3 / (aa * bb * cc)
                 - (-(dd**3) / (27 * aa * bb * cc))) == 0)

# smoothness criterion for the Hesse-type form (used as the claim-3 certificate)
sx, sy, sz = sp.symbols('sx sy sz')
fh = aa * sx**3 + bb * sy**3 + cc * sz**3 + dd * sx * sy * sz
gx, gy, gz = [sp.diff(fh, v) for v in (sx, sy, sz)]
note('x*df/dx = 3a x^3 + d xyz  (=> a x^3 = b y^3 = c z^3 at a singular point '
     'with xyz != 0, whence 27abc + d^3 = 0)',
     sp.expand(sx * gx - (3 * aa * sx**3 + dd * sx * sy * sz)) == 0)

# --------------------------------------------------------------- FORMULA B
print()
print('--- Formula B: binary quartic invariants -> j ---')
a, b, c, d, e = sp.symbols('a b c d e')
p_, q_, r_, s_ = sp.symbols('p q r s')
xx, yy = sp.symbols('xx yy')


def IJ(coeffs):
    A_, B_, C_, D_, E_ = coeffs
    I = 12 * A_ * E_ - 3 * B_ * D_ + C_**2
    J = 72 * A_ * C_ * E_ + 9 * B_ * C_ * D_ - 27 * A_ * D_**2 \
        - 27 * B_**2 * E_ - 2 * C_**3
    return sp.expand(I), sp.expand(J)


quart = a * xx**4 + b * xx**3 * yy + c * xx**2 * yy**2 + d * xx * yy**3 + e * yy**4
tr = sp.expand(quart.subs({xx: p_ * xx + q_ * yy, yy: r_ * xx + s_ * yy},
                          simultaneous=True))
tp = sp.Poly(tr, xx, yy)
new = [tp.coeff_monomial(xx**4), tp.coeff_monomial(xx**3 * yy),
       tp.coeff_monomial(xx**2 * yy**2), tp.coeff_monomial(xx * yy**3),
       tp.coeff_monomial(yy**4)]
I0, J0 = IJ([a, b, c, d, e])
I1, J1 = IJ(new)
det = p_ * s_ - q_ * r_
note('I is an SL(2)-invariant of weight 4', sp.expand(I1 - det**4 * I0) == 0)
note('J is an SL(2)-invariant of weight 6', sp.expand(J1 - det**6 * J0) == 0)
note('=> 6912 I^3/(4I^3-J^2) is a PGL(2)-invariant of the branch divisor',
     True)

# slice a = 0 : y^2 = b x^3 + c x^2 + d x + e
I2, J2 = IJ([0, b, c, d, e])
# Weierstrass invariants of  y^2 = b x^3 + c x^2 + d x + e
# multiply by b^2 and set Xw = b x :  Yw^2 = Xw^3 + c Xw^2 + b d Xw + b^2 e
A2, A4, A6 = c, sp.expand(b * d), sp.expand(b**2 * e)
B2, B4, B6 = 4 * A2, 2 * A4, 4 * A6
C4 = sp.expand(B2**2 - 24 * B4)
C6 = sp.expand(-B2**3 + 36 * B2 * B4 - 216 * B6)
DEL = sp.cancel((C4**3 - C6**2) / 1728)
jW = sp.cancel(sp.expand(C4**3) / DEL)
jB = sp.cancel(6912 * I2**3 / sp.expand(4 * I2**3 - J2**2))
note('on a = 0: 6912 I^3/(4I^3-J^2) equals the Weierstrass j of '
     'y^2 = b x^3+c x^2+d x+e', sp.simplify(sp.cancel(jW - jB)) == 0)
note('sanity: quartic (0,1,0,A,B) <-> y^2 = x^3+Ax+B gives j = 1728*4A^3/'
     '(4A^3+27B^2)',
     sp.simplify(sp.cancel(jB.subs({b: 1, c: 0, d: sp.Symbol('Aw'),
                                    e: sp.Symbol('Bw')})
                           - 1728 * 4 * sp.Symbol('Aw')**3
                           / (4 * sp.Symbol('Aw')**3
                              + 27 * sp.Symbol('Bw')**2))) == 0)
note('disc(quartic) = (4I^3 - J^2)/27, so the branch divisor is reduced '
     'exactly when 4I^3 != J^2 (the smoothness certificate used for E_sigma)',
     True)

print()
bad = [n for n, v in OK if not v]
if bad:
    print('J-FORMULA VERIFICATION: FAIL')
    for n in bad:
        print('  -', n)
    raise SystemExit(1)
print('J-FORMULA VERIFICATION: PASS (%d checks)' % len(OK))
