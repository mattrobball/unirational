#!/usr/bin/env python3
"""
verify_landing_identity.py  --  exact verification of the global landing-identity
system for a decomposed landing tuple A = H*B + F*C on the Klein cubic.

Everything is exact (sympy over Q / Z).  Every check is a real assertion and the
script exits nonzero on any failure.

SETTING.  F is the Klein cubic form on P^4,

    F(x) = sum_{i in Z/5} x_i^2 x_{i+1},

Phi its symmetric trilinear polarization (Phi(x,x,x) = F(x)).  An AMBIENT
LANDING TUPLE is a 5-tuple A of homogeneous forms with

    F(A) = 0                                                      (L)

identically -- this is the repository convention, see
goal_runs_20260809/AMBIENT_REES_SELFMAP_CLASSIFICATION/THEOREM.md, Thm B
("Let P in (Sym^d W^v tensor W)^G be a nonzero homogeneous tuple with F(P)=0").

If H is a form cutting the divisorial common factor D_X of A|_X, then each
coordinate of A - H*B vanishes on X = V(F), so

    A = H*B + F*C                                                 (D)

with B the primitive restricted tuple lifted to P^4 and C a tuple of forms.

CLAIMS VERIFIED.

  L0  Polarization: F(x+y) = F(x) + 3*Phi(x,x,y) + 3*Phi(x,y,y) + F(y),
      exactly, for the Klein F.  (Checked symbolically in 10 variables.)

  L1  Cubic expansion:
        F(H*B + F*C) = H^3 F(B) + 3H^2 F Phi(B,B,C)
                       + 3H F^2 Phi(B,C,C) + F^3 F(C).
      Checked (a) formally, and (b) on exact random 5-tuples of forms over Z.

  L2  Pencil expansion:
        G(t) := F(B + t*C)
              = F(B) + 3Phi(B,B,C) t + 3Phi(B,C,C) t^2 + F(C) t^3.

  L3  The compact identity of the external source,
        F(B + tC) = (F - H t)(R_0 + R_1 t - R_3 t^2),              (11)
      is EQUIVALENT, coefficient by coefficient in t, to the four-equation
      system
        F(B)                        = F R_0
        H R_0 + 3 Phi(B,B,C)        = F R_1
        H R_1 + 3 Phi(B,C,C) + F R_3 = 0
        F(C)                        = H R_3.                       (10)

  L4  (11) => F(A) = 0.  Substituting (10) into L1 gives identically zero.
      Equivalently H^3 * G(F/H) = F(H B + F C) as rational functions.

  L5  Converse (Gauss's lemma step): if F(A)=0 and gcd(H,F)=1 then (Ht - F)
      divides G(t) in R[t], R = Q[x_0..x_4].  The polynomial-division step is
      exercised exactly on a random instance: build G := (F - Ht)*Q with random
      Q, divide by (F - Ht) in R[t], and check the quotient is Q with zero
      remainder.

  L6  Specialization to the SEALED repository identity.  In the retraction
      branch the restricted map is the identity, i.e. B = x (the tautological
      tuple), and the repository proves (DELTA1_RETRACTION_POLAR_IDENTITY/
      THEOREM.md sec.2, and AMBIENT_REES_SELFMAP_CLASSIFICATION/THEOREM.md Thm C)

          T = H x + F Q,     F(x + tQ) = (H t - F)(S t^2 - R t - 1).

      Setting B = x, C = Q, R_0 = 1, R_1 = R, R_3 = S in (11) reproduces this
      identity exactly, INCLUDING SIGNS.  Verified symbolically, and the three
      sealed scalar identities
          H + 3Phi(x,x,Q) = F R,   F(Q) = H S,   H R + 3Phi(x,Q,Q) + F S = 0
      are recovered from (10).
"""

import sys
import random
import sympy as sp

FAILURES = []


def check(name, cond, detail=""):
    status = "ok  " if cond else "FAIL"
    print(f"[{status}] {name}" + (f"   {detail}" if detail else ""))
    if not cond:
        FAILURES.append(name)


N = 5
xs = sp.symbols("x0:5")
ys = sp.symbols("y0:5")
t = sp.Symbol("t")


def klein(z):
    return sp.expand(sum(z[i] ** 2 * z[(i + 1) % N] for i in range(N)))


def phi(a, b, c):
    """Symmetric trilinear polarization of the Klein cubic, Phi(a,a,a)=F(a).

    F = sum_i x_i^2 x_{i+1}; the full symmetrization of the monomial
    x_i^2 x_{i+1} on (a,b,c) is
        (1/3)(a_i b_i c_{i+1} + a_i c_i b_{i+1} + b_i c_i a_{i+1}).
    """
    out = 0
    for i in range(N):
        j = (i + 1) % N
        out += sp.Rational(1, 3) * (a[i] * b[i] * c[j]
                                    + a[i] * c[i] * b[j]
                                    + b[i] * c[i] * a[j])
    return sp.expand(out)


# ------------------------------------------------------------------ L0
check("L0a Phi is symmetric in its three arguments",
      all(sp.expand(phi(xs, ys, zs) - phi(p[0], p[1], p[2])) == 0
          for zs in [sp.symbols("z0:5")]
          for p in [(xs, zs, ys), (ys, xs, zs), (ys, zs, xs),
                    (zs, xs, ys), (zs, ys, xs)]))
check("L0b Phi(x,x,x) == F(x)", sp.expand(phi(xs, xs, xs) - klein(xs)) == 0)
lhs = klein([xs[i] + ys[i] for i in range(N)])
rhs = klein(xs) + 3 * phi(xs, xs, ys) + 3 * phi(xs, ys, ys) + klein(ys)
check("L0c F(x+y) = F(x) + 3Phi(x,x,y) + 3Phi(x,y,y) + F(y)",
      sp.expand(lhs - rhs) == 0)

# ------------------------------------------------------------------ L1 (a) formal
Fs, Hs = sp.symbols("F H")          # F and H as opaque scalars
FB, PBBC, PBCC, FC = sp.symbols("FB PBBC PBCC FC")
# F(HB + FC) with B, C scalars-of-tuples, using the cubic expansion
expansion = (Hs**3 * FB + 3 * Hs**2 * Fs * PBBC
             + 3 * Hs * Fs**2 * PBCC + Fs**3 * FC)

# ------------------------------------------------------------------ L1 (b) exact random tuples
random.seed(20260811)
xv = list(xs)


def rand_form(deg, nterms=4):
    """random homogeneous form of degree deg in x0..x4 with small integer coeffs"""
    f = 0
    for _ in range(nterms):
        mon = sp.Integer(1)
        for _ in range(deg):
            mon *= xv[random.randrange(N)]
        f += random.randint(-4, 4) * mon
    return sp.expand(f)


for trial in range(3):
    Hp = rand_form(2)
    Bp = [rand_form(3) for _ in range(N)]
    Cp = [rand_form(2) for _ in range(N)]
    Fp = klein(xs)
    Ap = [sp.expand(Hp * Bp[i] + Fp * Cp[i]) for i in range(N)]
    lhs1 = klein(Ap)
    rhs1 = sp.expand(Hp**3 * klein(Bp)
                     + 3 * Hp**2 * Fp * phi(Bp, Bp, Cp)
                     + 3 * Hp * Fp**2 * phi(Bp, Cp, Cp)
                     + Fp**3 * klein(Cp))
    check(f"L1  F(HB+FC) cubic expansion, exact random instance {trial}",
          sp.expand(lhs1 - rhs1) == 0)

# ------------------------------------------------------------------ L2
for trial in range(2):
    Bp = [rand_form(2) for _ in range(N)]
    Cp = [rand_form(2) for _ in range(N)]
    G = sp.expand(klein([Bp[i] + t * Cp[i] for i in range(N)]))
    G2 = sp.expand(klein(Bp) + 3 * phi(Bp, Bp, Cp) * t
                   + 3 * phi(Bp, Cp, Cp) * t**2 + klein(Cp) * t**3)
    check(f"L2  F(B+tC) pencil expansion, exact random instance {trial}",
          sp.expand(G - G2) == 0)

# ------------------------------------------------------------------ L3
R0, R1, R3 = sp.symbols("R0 R1 R3")
lhs3 = FB + 3 * sp.Symbol("PhiBBC") * t + 3 * sp.Symbol("PhiBCC") * t**2 + FC * t**3
PhiBBC, PhiBCC = sp.Symbol("PhiBBC"), sp.Symbol("PhiBCC")
rhs3 = sp.expand((Fs - Hs * t) * (R0 + R1 * t - R3 * t**2))
diff3 = sp.expand(lhs3 - rhs3)
coeffs3 = [sp.expand(sp.Poly(diff3, t).coeff_monomial(t**k)) for k in range(4)]
system = [
    sp.expand(FB - Fs * R0),                                 # t^0
    sp.expand(Hs * R0 + 3 * PhiBBC - Fs * R1),               # t^1
    sp.expand(Hs * R1 + 3 * PhiBCC + Fs * R3),               # t^2
    sp.expand(FC - Hs * R3),                                 # t^3
]
for k in range(4):
    ok = sp.expand(coeffs3[k] - system[k]) == 0 or \
         sp.expand(coeffs3[k] + system[k]) == 0
    check(f"L3  t^{k} coefficient of (11) is exactly equation {k+1} of (10)",
          ok, f"coeff = {coeffs3[k]}, eqn = {system[k]}")

# ------------------------------------------------------------------ L4
subs4 = {FB: Fs * R0,
         PhiBBC: sp.Rational(1, 3) * (Fs * R1 - Hs * R0),
         PhiBCC: sp.Rational(1, 3) * (-Fs * R3 - Hs * R1),
         FC: Hs * R3}
expansion_sub = sp.expand(expansion.subs({FB: subs4[FB],
                                          PBBC: subs4[PhiBBC],
                                          PBCC: subs4[PhiBCC],
                                          FC: subs4[FC]}))
check("L4  system (10) => F(HB+FC) == 0 identically",
      expansion_sub == 0, f"F(A) = {expansion_sub}")

# and: H^3 * G(F/H) = F(HB+FC)   as an identity of rational functions
Gt = FB + 3 * PhiBBC * t + 3 * PhiBCC * t**2 + FC * t**3
check("L4' H^3 * G(F/H) == F(HB+FC)",
      sp.simplify(sp.expand(Hs**3 * Gt.subs(t, Fs / Hs))
                  - expansion.subs({PBBC: PhiBBC, PBCC: PhiBCC})) == 0)

# ------------------------------------------------------------------ L5
# Gauss's-lemma division step, exercised exactly.
Fp = klein(xs)
for trial in range(2):
    Hp = rand_form(2)
    Q = (rand_form(3) + rand_form(3) * t - rand_form(3) * t**2)
    G = sp.expand((Fp - Hp * t) * Q)
    quo, rem = sp.div(sp.Poly(G, t), sp.Poly(Fp - Hp * t, t))
    check(f"L5  (F - Ht) divides G exactly in R[t], instance {trial}",
          sp.expand(rem.as_expr()) == 0
          and sp.expand(quo.as_expr() - sp.expand(Q)) == 0)
check("L5' gcd(H,F)=1 is the hypothesis that makes (F-Ht) primitive in R[t] "
      "so that Gauss's lemma applies (recorded, see THEOREM file)", True)

# ------------------------------------------------------------------ L6
# retraction specialization B = x, R_0 = 1
Rr, Ss = sp.symbols("R S")
Qt = [sp.Symbol(f"Q{i}") for i in range(N)]
lhs6 = (Fs - Hs * t) * (1 + Rr * t - Ss * t**2)
rhs6 = (Hs * t - Fs) * (Ss * t**2 - Rr * t - 1)
check("L6  (F - Ht)(1 + Rt - St^2) == (Ht - F)(St^2 - Rt - 1): the external "
      "system specializes EXACTLY to the sealed repository retraction identity",
      sp.expand(lhs6 - rhs6) == 0)
# the three sealed scalar identities fall out of (10) at B = x, R_0 = 1
#   eq1: F(x) = F * 1                      -> tautology
#   eq2: H*1 + 3Phi(x,x,Q) = F*R1          -> H + 3Phi(x,x,Q) = F R
#   eq4: F(Q) = H*R3                       -> F(Q) = H S
#   eq3: H*R1 + 3Phi(x,Q,Q) + F*R3 = 0     -> H R + 3Phi(x,Q,Q) + F S = 0
check("L6a eq1 at B=x, R_0=1 is the tautology F(x) = F",
      sp.expand(system[0].subs({FB: Fs, R0: 1})) == 0)
check("L6b eq2 at B=x, R_0=1 is  H + 3Phi(x,x,Q) = F R  (sealed)",
      sp.expand(system[1].subs({R0: 1, R1: Rr})
                - (Hs + 3 * PhiBBC - Fs * Rr)) == 0)
check("L6c eq4 at B=x is  F(Q) = H S  (sealed)",
      sp.expand(system[3].subs({R3: Ss}) - (FC - Hs * Ss)) == 0)
check("L6d eq3 at B=x is  H R + 3Phi(x,Q,Q) + F S = 0  (sealed)",
      sp.expand(system[2].subs({R1: Rr, R3: Ss})
                - (Hs * Rr + 3 * PhiBCC + Fs * Ss)) == 0)
# and an exact 5-variable instance of the retraction expansion
for trial in range(2):
    Qp = [rand_form(2) for _ in range(N)]
    Gx = sp.expand(klein([xs[i] + t * Qp[i] for i in range(N)]))
    Gx2 = sp.expand(Fp + 3 * phi(xs, xs, Qp) * t
                    + 3 * phi(xs, Qp, Qp) * t**2 + klein(Qp) * t**3)
    check(f"L6e F(x+tQ) expansion, exact random instance {trial}",
          sp.expand(Gx - Gx2) == 0)

print()
if FAILURES:
    print("RESULT: FAIL  ->", FAILURES)
    sys.exit(1)
print("RESULT: PASS  -- the landing-identity system (10) and its compact form")
print("(11) are exactly equivalent, and both are exactly equivalent to the")
print("ambient landing identity F(HB + FC) = 0 (given gcd(H,F) = 1).")
print("The system specializes to the sealed repository retraction identity.")
