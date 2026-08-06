#!/usr/bin/env python3
"""FIX-U1-FIN7 -- the (X,Y,Z) reformulation of the r = 7 landing identity,
verified exactly, and the completing-the-square normal form on {r0 != 0}.

  a' = xyz A(X,Y,Z),  b' = xyz B,  u0' = x U0,  u1' = y U1,  u2' = z U2
  X = x^2, Y = y^2, Z = z^2 ;  A,B quadratic ; U0,U1,U2 cubic with
  no X^3 / Y^3 / Z^3 respectively (that is exactly plane order >= 1).

Then   F(T) = xyz * G   with

  G = U0U1U2 + r0 X U0^2 + r1 Y U1^2 + r2 Z U2^2 + c XYZ ,
  r0 = A+B, r1 = om A + om^2 B, r2 = om^2 A + om B, c = kp A^3 + km B^3.

and, on {r0 != 0}, the completing-the-square identity

  4 r0 X G = (2 r0 X U0 + U1U2)^2 - [ U1^2 U2^2
             - 4 r0 X (r1 Y U1^2 + r2 Z U2^2 + c XYZ) ] .

So a cone point with r0 != 0 is exactly: a choice of (A,B,U1,U2) making the
degree-14 form  U1^2U2^2 - 4 r0 X(r1 Y U1^2 + r2 Z U2^2 + c XYZ)  a PERFECT
SQUARE W^2, together with U0 = (W - U1U2)/(2 r0 X) (two choices of sign,
subject to divisibility and to [X^3]U0 = 0).  This cuts the global dimension
question from 39 unknowns to 30.
"""
import sympy as sp

import fin7_lib as L
from fin7_lib import kp, kred, om, OM2, x, y, z

X, Y, Z = sp.symbols('X Y Z')
KM = sp.Rational(13, 8) - kp


def gen(prefix, deg, drop=None):
    ms = [(i, j, deg - i - j) for i in range(deg + 1)
          for j in range(deg + 1 - i)]
    if drop is not None:
        ms = [m for m in ms if m != drop]
    ms = sorted(ms, reverse=True)
    syms = [sp.Symbol('%s%d' % (prefix, k)) for k in range(len(ms))]
    return ms, syms, sum(s*X**m[0]*Y**m[1]*Z**m[2] for s, m in zip(syms, ms))


mA, sA, A = gen('A', 2)
mB, sB, B = gen('C', 2)
m0, s0, U0 = gen('U', 3, drop=(3, 0, 0))
m1, s1, U1 = gen('V', 3, drop=(0, 3, 0))
m2, s2, U2 = gen('W', 3, drop=(0, 0, 3))
print('parameter counts: A %d, B %d, U0 %d, U1 %d, U2 %d  (total %d)'
      % (len(sA), len(sB), len(s0), len(s1), len(s2),
         len(sA)+len(sB)+len(s0)+len(s1)+len(s2)))
assert len(sA)+len(sB)+len(s0)+len(s1)+len(s2) == 39

r0 = A + B
r1 = om*A + OM2*B
r2 = OM2*A + om*B
c = kp*A**3 + KM*B**3
G = sp.expand(U0*U1*U2 + r0*X*U0**2 + r1*Y*U1**2 + r2*Z*U2**2 + c*X*Y*Z)

sub = {X: x**2, Y: y**2, Z: z**2}
ap = sp.expand(x*y*z*A.subs(sub))
bp = sp.expand(x*y*z*B.subs(sub))
u0 = sp.expand(x*U0.subs(sub))
u1 = sp.expand(y*U1.subs(sub))
u2 = sp.expand(z*U2.subs(sub))
F = sp.expand(kp*ap**3 + KM*bp**3
              + ap*(u0**2 + om*u1**2 + OM2*u2**2)
              + bp*(u0**2 + OM2*u1**2 + om*u2**2)
              + u0*u1*u2)
diff = sp.expand(F - x*y*z*G.subs(sub))
P = sp.Poly(diff, x, y, z) if diff != 0 else None
resid = 0 if P is None else sum(1 for cf in P.coeffs() if kred(cf) != 0)
print('F(T) == xyz * G  (exact identity in 39 parameters):', resid == 0)

# the slot supports match fin7_lib exactly
sup = L.supports()
ok = True
for k, (ms, want) in enumerate([(mA, sup[0]), (mB, sup[1]), (m0, sup[2]),
                                (m1, sup[3]), (m2, sup[4])]):
    got = sorted([(2*i + (1 if k in (0, 1, 2) else 0),
                   2*j + (1 if k in (0, 1, 3) else 0),
                   2*l + (1 if k in (0, 1, 4) else 0))
                  for (i, j, l) in ms], reverse=True)
    ok = ok and got == sorted(want, reverse=True)
print('slot supports agree with fin7_lib.supports():', ok)

Wq = sp.expand(2*r0*X*U0 + U1*U2)
RHS = sp.expand(U1**2*U2**2 - 4*r0*X*(r1*Y*U1**2 + r2*Z*U2**2 + c*X*Y*Z))
idn = sp.expand(4*r0*X*G - (Wq**2 - RHS))
if idn != 0:
    PP = sp.Poly(idn, X, Y, Z)
    idn = sum(1 for cf in PP.coeffs() if kred(cf) != 0)
else:
    idn = 0
print('completing-the-square identity 4 r0 X G = W^2 - RHS :', idn == 0)
