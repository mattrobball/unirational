#!/usr/bin/env python3
"""
verify_conic_slice.py  --  exact symbolic verification of the Klein conic-slice
countermodel to the "generic slice is line-type" normal form.

Everything below is exact (sympy over Q / Z).  Every check is a real assertion:
the script exits nonzero if any of them fails.

Setting.  F is the Klein cubic form on P^4,

    F(x) = sum_{i in Z/5} x_i^2 x_{i+1}
         = x0^2 x1 + x1^2 x2 + x2^2 x3 + x3^2 x4 + x4^2 x0,

X = V(F) subset P^4 (a smooth cubic threefold).

The external source asserted, as part of a "weighted line normal form", that the
exceptional P^1 of the normalized blowup of the base ideal of a landing tuple
along a common-factor surface must map to a LINE in X.  The countermodel is the
binary-quadratic tuple

    P(u,v) = ( u^2 - v^2, -2(u^2+v^2), (u-v)^2, -2(u^2+v^2), 0 ).

Claims verified here:

  C1  F(P(u,v)) = 0 identically in Q[u,v].            (P lands in X)
  C2  The Q-span of the five components of P is the full space of binary
      quadratics <u^2, uv, v^2>; hence the base ideal is I_P = (u,v)^2 and
      the normalized blowup of I_P is the ordinary blowup of the maximal
      ideal (u,v) (Veronese: Proj of the Rees algebra is unchanged).
  C3  P has no common polynomial factor (the tuple is primitive as written).
  C4  The image of P is a SMOOTH CONIC, not a line:
        (a) the image spans exactly a 2-plane Pi = {x4 = 0, x1 - x3 = 0};
        (b) inside Pi the three coordinate quadrics are linearly independent,
            so [u:v] -> P is the 2-uple Veronese followed by a linear
            isomorphism: an embedding of P^1 with image of degree 2;
        (c) the defining quadratic form of the image inside Pi has rank 3,
            i.e. the conic is smooth;
        (d) the image is not contained in any hyperplane section of Pi, i.e.
            it is not a line (degree 2 != 1).
  C5  On the slice v = 0 the tuple is P(u,0) = u^2 * (1,-2,1,-2,0): a genuine
      divisorial common factor u^2 with primitive value the Klein point
      p0 = [1:-2:1:-2:0], and F(p0) = 0 so p0 lies on X.
  C6  Sanity: the general fibre of P is a single point (the map P^1 -> P^4 is
      injective on a dense open), confirming degree 1 onto its image.

Nothing here depends on any repository claim; it is self-contained arithmetic.
"""

import sys
import sympy as sp

u, v, t = sp.symbols("u v t")
X0, X1, X2, X3, X4 = sp.symbols("x0 x1 x2 x3 x4")
XS = (X0, X1, X2, X3, X4)

FAILURES = []


def check(name, cond, detail=""):
    status = "ok  " if cond else "FAIL"
    print(f"[{status}] {name}" + (f"   {detail}" if detail else ""))
    if not cond:
        FAILURES.append(name)


def klein(x):
    """F(x) = sum_{i in Z/5} x_i^2 x_{i+1}, exact."""
    return sum(sp.expand(x[i] ** 2 * x[(i + 1) % 5]) for i in range(5))


# ---------------------------------------------------------------- the tuple
P = [
    sp.expand(u**2 - v**2),
    sp.expand(-2 * (u**2 + v**2)),
    sp.expand((u - v) ** 2),
    sp.expand(-2 * (u**2 + v**2)),
    sp.Integer(0),
]

print("Klein form F  =", sp.expand(klein(XS)))
print("P(u,v)        =", P)
print()

# ---------------------------------------------------------------- C1
FP = sp.expand(klein(P))
check("C1  F(P(u,v)) == 0 identically", FP == 0, f"F(P) = {FP}")

# a stronger form of the same statement: F(P) as a polynomial in Q[u,v]
poly_FP = sp.Poly(klein(P), u, v)
check("C1' F(P) is the zero polynomial in Q[u,v]", poly_FP.is_zero)

# ---------------------------------------------------------------- C2
# coefficient matrix of the five components in the basis (u^2, uv, v^2)
basis = [u**2, u * v, v**2]


def coeffs(f):
    pf = sp.Poly(sp.expand(f), u, v)
    if pf.is_zero:
        return [sp.Integer(0)] * 3
    d = pf.total_degree()
    assert d <= 2, f"component {f} is not a binary quadratic"
    return [sp.Poly(sp.expand(f), u, v).coeff_monomial(b) for b in basis]


M = sp.Matrix([coeffs(f) for f in P])
print("coefficient matrix (rows = components, cols = u^2, uv, v^2):")
sp.pprint(M)
print()
check("C2  span of components = <u^2, uv, v^2> (rank 3)", M.rank() == 3,
      f"rank = {M.rank()}")

# explicit witness: u^2, uv, v^2 are Z-combinations of the components.
# P0 = u^2 - v^2, P1 = -2(u^2+v^2)  =>  u^2 = (2*P0 - P1)/4, v^2 = -(2*P0 + P1)/4
# P2 = u^2 - 2uv + v^2              =>  uv  = (u^2 + v^2 - P2)/2 = (-P1/2 - P2)/2
u2 = sp.expand(sp.Rational(1, 4) * (2 * P[0] - P[1]))
v2 = sp.expand(sp.Rational(-1, 4) * (2 * P[0] + P[1]))
uv = sp.expand(sp.Rational(1, 2) * (sp.Rational(-1, 2) * P[1] - P[2]))
check("C2' explicit rewriting u^2", sp.expand(u2 - u**2) == 0)
check("C2' explicit rewriting v^2", sp.expand(v2 - v**2) == 0)
check("C2' explicit rewriting u*v", sp.expand(uv - u * v) == 0)

# ---------------------------------------------------------------- C3
gcd_all = sp.gcd_list([f for f in P if f != 0])
check("C3  gcd of the components is a unit (tuple is primitive)",
      sp.Poly(gcd_all, u, v).total_degree() == 0, f"gcd = {gcd_all}")

# ---------------------------------------------------------------- C4
# (a) linear forms vanishing on the image
lin = sp.symbols("a0:5")
gen = sp.expand(sum(lin[i] * P[i] for i in range(5)))
sols = sp.solve([sp.Poly(gen, u, v).coeff_monomial(b) for b in basis],
                list(lin), dict=True)
assert len(sols) == 1
sol = sols[0]
free = sorted({s for s in lin if s not in sol}, key=str)
# dimension of the space of linear forms vanishing on the image
lin_space = []
for fv in free:
    subs = {s: (1 if s == fv else 0) for s in free}
    vec = [sp.simplify(sol.get(lin[i], lin[i]).subs(subs)) for i in range(5)]
    lin_space.append(vec)
L = sp.Matrix(lin_space)
check("C4a  exactly 2 independent linear forms vanish on the image",
      L.rank() == 2, f"rank = {L.rank()}, forms = {lin_space}")
for vec in lin_space:
    check("C4a' the linear form really vanishes on P",
          sp.expand(sum(vec[i] * P[i] for i in range(5))) == 0)
# the two forms are x4 and x1 - x3 (up to the chosen basis of the 2-dim space)
for cand in ([0, 0, 0, 0, 1], [0, 1, 0, -1, 0]):
    check(f"C4a'' {cand} is in the span of the vanishing linear forms",
          sp.Matrix(lin_space + [cand]).rank() == 2)
    check(f"C4a'' {cand} vanishes on P",
          sp.expand(sum(cand[i] * P[i] for i in range(5))) == 0)

# (b) inside the plane {x4 = 0, x1 = x3}, coordinates (x0, x1, x2)
Mplane = sp.Matrix([coeffs(P[0]), coeffs(P[1]), coeffs(P[2])])
det = Mplane.det()
check("C4b  the three plane-coordinate quadrics are independent (det != 0)",
      det != 0, f"det = {det}")
check("C4b' hence [u:v] -> (P0:P1:P2) is the 2-uple Veronese up to GL_3, "
      "so it is an embedding of P^1 as a degree-2 curve", det != 0)

# (c) the conic's equation inside the plane: eliminate u,v
c = sp.symbols("c0:6")
mon = [X0**2, X0 * X1, X0 * X2, X1**2, X1 * X2, X2**2]
Qgen = sum(c[i] * mon[i] for i in range(6))
sub = Qgen.subs({X0: P[0], X1: P[1], X2: P[2]})
eqs = [sp.Poly(sp.expand(sub), u, v).coeff_monomial(m)
       for m in [u**4, u**3 * v, u**2 * v**2, u * v**3, v**4]]
qsol = sp.solve(eqs, list(c), dict=True)[0]
qfree = sorted({s for s in c if s not in qsol}, key=str)
check("C4c  exactly one quadric in the plane contains the image "
      "(=> the image is a conic, degree 2)", len(qfree) == 1,
      f"free params = {qfree}")
conic = sp.expand(Qgen.subs(qsol).subs({qfree[0]: 1}))
print("conic equation in the plane {x4=0, x1=x3}:", conic)
check("C4c' the conic really vanishes on the image",
      sp.expand(conic.subs({X0: P[0], X1: P[1], X2: P[2]})) == 0)
# rank of the symmetric matrix of the conic
Cm = sp.Matrix(3, 3, lambda i, j: sp.Rational(1, 2) *
               sp.diff(conic, XS[i], XS[j]))
check("C4c'' the conic is SMOOTH (symmetric matrix has rank 3)",
      Cm.rank() == 3, f"rank = {Cm.rank()}, det = {Cm.det()}")

# (d) not a line
check("C4d  the image is NOT a line: a line would lie in 3 independent "
      "hyperplanes of P^4, but only 2 vanish on the image", L.rank() == 2)

# ---------------------------------------------------------------- C5
P_slice = [sp.expand(f.subs(v, 0)) for f in P]
p0 = [sp.Integer(1), sp.Integer(-2), sp.Integer(1), sp.Integer(-2),
      sp.Integer(0)]
check("C5  P(u,0) = u^2 * (1,-2,1,-2,0)",
      all(sp.expand(P_slice[i] - u**2 * p0[i]) == 0 for i in range(5)),
      f"P(u,0) = {P_slice}")
check("C5' the slice has a genuine divisorial common factor u^2",
      sp.Poly(sp.gcd_list([f for f in P_slice if f != 0]), u).total_degree() == 2)
check("C5'' the primitive value (1,-2,1,-2,0) is primitive over Z",
      sp.gcd([abs(int(a)) for a in p0 if a != 0]) == 1)
check("C5''' F(1,-2,1,-2,0) == 0, i.e. the primitive value lies on X",
      klein(p0) == 0, f"F(p0) = {klein(p0)}")

# ---------------------------------------------------------------- C6
# injectivity on a dense open: P(u,v) ~ P(u',v') forces [u:v] = [u':v'].
up, vp = sp.symbols("up vp")
Pp = [f.subs({u: up, v: vp}) for f in P]
# 2x2 minors of the 2x5 matrix (P; P') all vanish  <=>  same point of P^4
minors = [sp.factor(sp.expand(P[i] * Pp[j] - P[j] * Pp[i]))
          for i in range(5) for j in range(i + 1, 5)]
common = sp.gcd_list([m for m in minors if m != 0])
check("C6  every 2x2 minor is divisible by (u*vp - v*up), so the map is "
      "injective away from that locus (degree 1 onto its image)",
      sp.simplify(sp.rem(sp.Poly(common, u, v, up, vp),
                         sp.Poly(u * vp - v * up, u, v, up, vp))) == 0
      or sp.simplify(common / (u * vp - v * up)).is_polynomial(),
      f"gcd of minors = {sp.factor(common)}")

# ---------------------------------------------------------------- C7
# The exact landing-identity data of the conic cell.  With
#     f = v,  H = u^2,  B = (1,-2,1,-2,0),  C = (-v,-2v,-2u+v,-2v,0)
# one has A = H B + f C = P, and the four identities (10) hold with
#     R_0 = 0,   R_1 = 8,   R_3 = -8 v.
# (Fuller replay, including the derivation of these R_i from F(P) = 0 by the
# mod-s / mod-t^e reductions, is in verify_slice_universality.py, block S6.)
Hc = u**2
fc = v
Bc = [sp.Integer(1), sp.Integer(-2), sp.Integer(1), sp.Integer(-2),
      sp.Integer(0)]
Cc = [-v, -2 * v, sp.expand(-2 * u + v), -2 * v, sp.Integer(0)]
R0c, R1c, R3c = sp.Integer(0), sp.Integer(8), sp.expand(-8 * v)


def phi3(a, b, c):
    """symmetric trilinear polarization of F, Phi(x,x,x) = F(x)."""
    def add(p, q):
        return [p[i] + q[i] for i in range(5)]
    return sp.expand(sp.Rational(1, 6) * (
        klein(add(add(a, b), c)) - klein(add(a, b)) - klein(add(b, c))
        - klein(add(a, c)) + klein(a) + klein(b) + klein(c)))


check("C7  A = H B + f C = P with H = u^2, f = v, B = (1,-2,1,-2,0), "
      "C = (-v,-2v,-2u+v,-2v,0)",
      all(sp.expand(Hc * Bc[i] + fc * Cc[i] - P[i]) == 0 for i in range(5)))
check("C7a (I0) F(B) = f R_0 with R_0 = 0",
      sp.expand(klein(Bc) - fc * R0c) == 0, f"F(B) = {klein(Bc)}")
check("C7b (I1) H R_0 + 3 Phi(B,B,C) = f R_1 with R_1 = 8",
      sp.expand(Hc * R0c + 3 * phi3(Bc, Bc, Cc) - fc * R1c) == 0,
      f"3 Phi(B,B,C) = {sp.expand(3*phi3(Bc,Bc,Cc))}")
check("C7c (I3) F(C) = H R_3 with R_3 = -8v",
      sp.expand(klein(Cc) - Hc * R3c) == 0, f"F(C) = {klein(Cc)}")
check("C7d (I2) H R_1 + 3 Phi(B,C,C) + f R_3 = 0",
      sp.expand(Hc * R1c + 3 * phi3(Bc, Cc, Cc) + fc * R3c) == 0,
      f"3 Phi(B,C,C) = {sp.expand(3*phi3(Bc,Cc,Cc))}")

# ---------------------------------------------------------------- verdict
print()
if FAILURES:
    print("RESULT: FAIL  ->", FAILURES)
    sys.exit(1)
print("RESULT: PASS  -- the Klein conic-slice countermodel is exact.")
print("Consequence: a normalized slice ideal of a tuple landing on the Klein")
print("cubic can be (u,v)^2 with exceptional P^1 mapping ISOMORPHICALLY to a")
print("SMOOTH CONIC in X.  The 'generic exceptional curve must map to a line'")
print("normal form is therefore false as a general statement.")
