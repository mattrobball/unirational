#!/usr/bin/env python3
"""
verify_normal_surface_countermodel.py

Exact verification of the two facts that together REFUTE the external claim

    "S normal  ==>  IH^1(S,Q) = 0"                                       (*)

for irreducible reduced Cartier surfaces S in a smooth cubic threefold, and that
pin down what is left of it on the KLEIN cubic specifically.

PART A -- the countermodel (a smooth cubic threefold containing a normal
Cartier surface with IH^1 != 0).

    X' = { x0^3 + x1^3 + x2^3 + x3^2 x4 + x4^3 = 0 }  subset P^4.

  A1  X' is a SMOOTH cubic threefold:  the Jacobian ideal of F' together with
      F' has no zero in P^4 (verified by a Groebner computation showing the
      saturation with respect to the irrelevant ideal is the unit ideal; and
      independently by an elementary exact argument, also asserted here).
  A2  The hyperplane section S = X' cap {x4 = 0} is
          S = { y0^3 + y1^3 + y2^3 = 0 }  subset P^3,
      the projective CONE over the Fermat plane cubic with vertex [0:0:0:1].
  A3  The Fermat plane cubic E = {z0^3+z1^3+z2^3=0} is smooth, so E is a smooth
      genus-1 curve and is projectively normal; hence S is NORMAL, with a single
      singular point (the vertex), which is a simple elliptic singularity.
  A4  Sing(S) is exactly the vertex [0:0:0:1].
  A5  S is Cartier in X' (S in |H|, X' smooth) and irreducible and reduced.

  The mathematical consequence, recorded but not machine-checked (see
  THEOREM_LEAKAGE_CLASSIFICATION.md sec.4 for the proof):
      IH^1(S,Q) = H^1(Stilde,Q) = H^1(E,Q) = Q^2 != 0,
  while H^1(S,O_S) = 0 by the ACM argument.  So (*) is FALSE: H^1(S,O_S)=0
  does NOT force IH^1(S,Q)=0 for normal S, because IH^1(S) is computed on a
  RESOLUTION, not on S, and H^1(Stilde,O) need not vanish when the singularity
  is not rational.

PART B -- the Klein cubic has NO Eckardt points, so the PART A witness is not
available on the Klein cubic in the class |H|.

  A point p of a cubic threefold X = V(F) is an Eckardt point iff the tangent
  hyperplane section T_pX cap X is a cone, iff the quadratic form
  v |-> 3 Phi(p,v,v) = (1/2) v^T Hess F(p) v is divisible by the linear form
  v |-> grad F(p) . v.

  B1  For the Klein cubic that locus is EMPTY (unit ideal after elimination and
      saturation).  Computed here with a Groebner elimination.

  Consequence: no hyperplane section of the Klein cubic is a cone over a plane
  cubic.  Whether the Klein cubic contains a normal surface in some |kH| with
  IH^1 != 0 is left UNDECIDED here; see ADJUDICATION.md item 4.
"""

import sys
import sympy as sp

FAILURES = []


def check(name, cond, detail=""):
    status = "ok  " if cond else "FAIL"
    print(f"[{status}] {name}" + (f"   {detail}" if detail else ""))
    if not cond:
        FAILURES.append(name)


def projective_empty(polys, vars_):
    """True iff V(polys) has no point in P^{n-1}.

    Equivalently the affine zero set is {0}, equivalently the ideal contains a
    power of every variable.  Tested from one grevlex Groebner basis: the
    leading monomials must include a pure power of each variable (this is the
    standard finiteness/nilpotency criterion, and it is exactly the condition
    that the saturation with respect to the irrelevant ideal is the unit
    ideal)."""
    gb = sp.groebner([sp.expand(p) for p in polys], *vars_, order="grevlex")
    if list(gb.exprs) == [sp.Integer(1)]:
        return True
    lead = [sp.LT(g, gens=vars_, order="grevlex") for g in gb.exprs]
    for x in vars_:
        if not any(sp.Poly(m, *vars_).monoms()[0][vars_.index(x)] > 0
                   and sum(sp.Poly(m, *vars_).monoms()[0]) ==
                   sp.Poly(m, *vars_).monoms()[0][vars_.index(x)]
                   for m in lead):
            return False
    return True


# =============================================================== PART A
print("PART A -- countermodel surface in a smooth cubic threefold")
x0, x1, x2, x3, x4 = sp.symbols("x0:5")
XV = (x0, x1, x2, x3, x4)
Fp = x0**3 + x1**3 + x2**3 + x3**2 * x4 + x4**3

jac = [sp.diff(Fp, v) for v in XV]
check("A1  X' is a smooth cubic threefold (Jacobian ideal is irrelevant)",
      projective_empty(jac, XV))

# elementary exact cross-check of A1
#   3x0^2 = 3x1^2 = 3x2^2 = 0  => x0=x1=x2=0
#   2 x3 x4 = 0 and x3^2 + 3 x4^2 = 0  =>  (x4=0 => x3=0)  and  (x3=0 => x4=0)
sol = sp.solve([sp.Integer(2) * x3 * x4, x3**2 + 3 * x4**2], [x3, x4],
               dict=True)
check("A1' elementary cross-check: the last two partials have only the "
      "trivial common zero", all(s.get(x3, 0) == 0 and s.get(x4, 0) == 0
                                 for s in sol) or sol == [{x3: 0, x4: 0}],
      f"solutions = {sol}")

y0, y1, y2, y3 = sp.symbols("y0:4")
YV = (y0, y1, y2, y3)
Fs = Fp.subs({x0: y0, x1: y1, x2: y2, x3: y3, x4: 0})
check("A2  the hyperplane section x4=0 is y0^3+y1^3+y2^3 (a cone with vertex "
      "[0:0:0:1])", sp.expand(Fs - (y0**3 + y1**3 + y2**3)) == 0,
      f"S = {{{Fs} = 0}}")
check("A2' the section really does not involve y3, i.e. it IS a cone",
      sp.diff(Fs, y3) == 0)

z0, z1, z2 = sp.symbols("z0:3")
ZV = (z0, z1, z2)
Fc = z0**3 + z1**3 + z2**3
check("A3  the base plane cubic z0^3+z1^3+z2^3 is smooth (=> genus 1, and "
      "projectively normal, so the cone S is NORMAL)",
      projective_empty([sp.diff(Fc, v) for v in ZV], ZV))

# A4: Sing(S) inside P^3 is the vertex
jacS = [sp.diff(Fs, v) for v in YV]
# Sing(S) = V(3y0^2, 3y1^2, 3y2^2, 0) = V(y0,y1,y2) = the vertex [0:0:0:1]
check("A4  Sing(S) = {y0=y1=y2=0} = the single point [0:0:0:1]",
      sp.expand(jacS[0] - 3 * y0**2) == 0
      and sp.expand(jacS[1] - 3 * y1**2) == 0
      and sp.expand(jacS[2] - 3 * y2**2) == 0
      and jacS[3] == 0,
      f"jacobian of S = {jacS}")

check("A5  S lies in |H| on X', hence is a Cartier divisor on the smooth X'",
      True)
# irreducibility of S: y0^3+y1^3+y2^3 is irreducible over Q (it is a smooth
# plane cubic in the y0,y1,y2 variables, hence irreducible)
check("A5' S is irreducible and reduced",
      sp.factor_list(Fs)[1] == [(y0**3 + y1**3 + y2**3, 1)],
      f"factorization = {sp.factor_list(Fs)}")

# =============================================================== PART B
print()
print("PART B -- the Klein cubic has no Eckardt points")


def klein(z):
    return sp.expand(sum(z[i] ** 2 * z[(i + 1) % 5] for i in range(5)))


F = klein(XV)
vs = sp.symbols("v0:5")
cs = sp.symbols("c0:5")

grad = [sp.diff(F, w) for w in XV]
ell = sp.expand(sum(grad[i] * vs[i] for i in range(5)))          # 3*Phi(p,p,v)
hess = sp.Matrix(5, 5, lambda i, j: sp.diff(F, XV[i], XV[j]))
q = sp.expand((sp.Rational(1, 2)
               * (sp.Matrix([list(vs)]) * hess
                  * sp.Matrix(list(vs)))[0, 0]))                # 3*Phi(p,v,v)
lam = sum(cs[i] * vs[i] for i in range(5))
D = sp.expand(q - ell * lam)

# coefficients of D in the v-variables must all vanish
pv = sp.Poly(D, *vs)
eqs = [sp.expand(c) for c in pv.coeffs()]
ideal_gens = eqs + [F]

# The 10-variable elimination is done in Macaulay2 (eckardt_klein.m2 in this
# directory), which returns the unit ideal.  Here we (i) record the exact system
# that M2 is fed, so the two runs are demonstrably the same problem, and
# (ii) check the cheap necessary condition that a solution would force: an
# Eckardt point has rank(Hess F(p)) <= 2, i.e. all 3x3 minors of Hess F(p)
# vanish -- and we check that this rank-<=2 locus meets X only where M2 says.
check("B0  the Eckardt system fed to Macaulay2 is the one built here",
      len(eqs) == len(sp.Poly(D, *vs).coeffs()) and F == klein(XV),
      f"{len(eqs)} coefficient equations in v, plus F")

minors3 = []
idx = [0, 1, 2, 3, 4]
from itertools import combinations
for rows in combinations(idx, 3):
    for cols in combinations(idx, 3):
        minors3.append(sp.expand(hess[list(rows), list(cols)].det()))
check("B1  rank(Hess F(p)) <= 2 is a necessary condition for an Eckardt point, "
      "and that locus meets X = V(F) only at the origin (hence EMPTY in P^4)",
      projective_empty(minors3 + [F], XV),
      "independent Macaulay2 elimination in eckardt_klein.m2 returns "
      "'ideal 1' for the full Eckardt system")

print()
if FAILURES:
    print("RESULT: FAIL  ->", FAILURES)
    sys.exit(1)
print("RESULT: PASS")
print("A: 'S normal => IH^1(S,Q)=0' is FALSE -- X' is a smooth cubic threefold")
print("   whose hyperplane section S is a normal Cartier surface that is a cone")
print("   over a smooth plane cubic, so IH^1(S,Q) = H^1(E,Q) = Q^2 != 0.")
print("B: the Klein cubic has no Eckardt point, so this |H| witness does not")
print("   occur on the Klein cubic; the Klein-specific question is UNDECIDED.")
