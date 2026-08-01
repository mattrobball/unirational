# Adversarial valuation and class-group audit

## Verdict

**No fatal gap remains in the infinity-place proof.**  The divisor `D`, its
degree-one place of `K_proj`, the residual net, and the class-group argument
do prove

```text
C(K_proj) = empty.
```

The conclusion is scoped to the fixed-frame plane cubic.  It gives the Goal F
exit `F-CONIC-CRITERION-EMPTY` through the accepted bidirectional
point/conic criterion, but it does not by itself decide the Klein-cubic
headline.

The only portion of the shared proof that needed sharper wording was the lift
from the characteristic-89 base-ideal computation to characteristic zero.
Section 3 below supplies a scheme-theoretic finite-flat/Nakayama/properness
argument.  It does not promote modular evidence by itself.

## 1. The infinity place really has `(e,f)=(1,1)`

Use `T=Z-11*A^2/18` and write the installed primitive sextic as

```text
P(u)=c6*u^6+c5*u^5+...+c0.
```

The exact payload identity is

```text
c6 = 38263752*B^2*(A-15)*D(A,B,Y,T).
```

The displayed linear coordinates `p,q,Y,T` in the shared packet are an
invertible linear change of `A,B,Y,T`, and in those coordinates

```text
6625000*D =
  150*(107219*p^2+954*p*q-9*q^2)
  -600*Y*(53*p-q)^2+(53*p-q)^3.
```

This is primitive and linear in `Y`.  Its `Y` coefficient and constant term
are coprime: on `53*p-q=0` the constant term is a nonzero multiple of `p^2`.
Gauss's lemma therefore proves that `D` is absolutely irreducible.  It occurs
to exponent one in `c6`.  The exact point

```text
(r,rho,T)=(0,1,0),
(A,B,Y,Z)=(33/2,-1/200,-1349/600,1331/8)
```

lies on `D` and has

```text
c5=4782969/625000000 != 0.
```

Thus at the DVR `R_D` of `F` one has

```text
ord_D(c6)=1,  ord_D(c5)=0.
```

For `s=1/u`, the reciprocal equation is

```text
Q(s)=s^6*P(1/s)=c6+c5*s+...+c0*s^6.
```

Its reduction has the simple root `s=0`, because `Q(0)` is in the maximal
ideal and `Q'(0)=c5` is a unit.  Hensel's lemma gives a nonzero root
`alpha` in the henselization with positive valuation.  Then `u=alpha^-1`
satisfies `P`, so

```text
K_proj tensor_F Frac(R_D^h)
```

has a linear field factor.  Its valuation and residue field are unchanged:
`e=1`, `f=1`, and the residue field is `C(D)`.  This is a genuine place of
the installed degree-six field, not merely a root of the leading form.

On `rho=53*p-q != 0`, the inverse formulas in the payload give

```text
C(D)=C(r,rho,T).
```

## 2. Exact residual net and its integral degree-three base point

Substitution on `D` gives

```text
C_res = C0(r)+rho*Crho(r)+T*CT
```

over `k=C(r)`, with the three sections printed in
`../../INFINITY_OBSTRUCTION.md`.  Let

```text
B=V(y-c*w,G) in P2_k,
G=X^3+(a0+a2*r^2)*X*w^2+(b0+b2*r^2)*w^3.
```

The independent verifier checks exactly in `Q(zeta_11)` that

```text
qY(c)=rB(c)=rY(c)=rZ(c)=0
```

and rebuilds all four coefficients of `G`.  Consequently

```text
C0|_(y=cw)=G,  Crho|_(y=cw)=0,  CT|_(y=cw)=0,
```

so `B` is a closed subscheme of the net base locus.

The equation is monic cubic in `X` on `w=1`, and it has no point at `w=0`.
It therefore defines a finite degree-three scheme.  It is integral even after
extending the constant field to an algebraic closure.  Indeed, put

```text
N=X^3+a0*X+b0,  L=a2*X+b2.
```

The exact values have `a2!=0` and `N(-b2/a2)!=0` (the latter reduces to `17`
at the good prime).  Hence `-N/L` has a simple pole at the zero of `L`, so it
cannot be a square in the algebraic closure of the constant rational-function
field.  The polynomial

```text
r^2+N(X)/L(X)
```

is irreducible.  Gauss's lemma then makes `G` irreducible in
`C(r)[X]`.  Thus `B=Spec(L_B)` for a separable cubic field `L_B/k`.

## 3. Rigorous lift of the base-ideal equality

Let `R` be the good DVR with fraction field `Q(zeta_11)(r)` and residue field
`F_89(r)` determined by `zeta_11 -> 2`.  Localize so that every displayed
denominator and the discriminant of `G` is a unit.  Let

```text
B_R subset Z_R subset P2_R
```

be respectively the displayed degree-three scheme and the base scheme of
`(C0,Crho,CT)`.

The exact identities above give `B_R subset Z_R`.  Moreover `B_R` is finite
flat of rank three: after `y=c*w`, the coordinate algebra is defined by a
monic cubic in `X`, and the projective infinity chart is empty.

The independent good-fibre Groebner computation proves equality on `w=1` and
proves both charts at `w=0` empty.  Hence

```text
(Z_R)_s = (B_R)_s
```

as projective schemes, not only set-theoretically.

Here is the missing lift argument.  With ideal sheaves ordered as

```text
I_Z subset I_B,
```

put `Q=I_B/I_Z`.  Flatness of `B_R` makes

```text
I_B tensor k(s) -> O_(P2_s)
```

injective.  Equality of the special-fibre ideals therefore gives
`Q tensor k(s)=0`.  Nakayama's lemma shows that `Q` vanishes at every point
over `s`, so the closed support of `Q` is disjoint from the special fibre.
But `Supp(Q)` is closed in the proper scheme `P2_R`.  If its generic fibre
were nonempty, its proper image in `Spec(R)` would be a closed set containing
the generic point, hence all of `Spec(R)`, contradicting disjointness from
the special point.  Therefore `Q_eta=0`, and

```text
Z_eta=B_eta
```

scheme-theoretically in characteristic zero.

This argument is stronger and more explicit than an unsupported appeal to a
modular screen or to numerical semicontinuity.

## 4. Normality of the universal net incidence

Let

```text
X = {lambda0*C0+lambda1*Crho+lambda2*CT=0}
    subset P2_z x P2_lambda.
```

Away from `B`, at least one section `Ci(z)` is nonzero, so the corresponding
partial derivative with respect to `lambda_i` is nonzero.  Hence `X` is
smooth there.

The scheme `B` is reduced and a codimension-two local complete intersection:
it is cut out by the line and the separable cubic `G`.  Since the three net
sections generate its ideal scheme-theoretically, their differentials span
the two-dimensional conormal space at every geometric point of `B`.  At such
a point the singularity condition on `[lambda0:lambda1:lambda2]` is the
projectivization of the one-dimensional kernel of a surjective map
`kbar^3 -> kbar^2`.  There is therefore exactly one singular lambda-point over
each geometric base point.  The singular locus of the threefold `X` is
finite.

On the complement of `B`, `X` is a `P1`-bundle over the integral surface
`P2-B`; this open is integral and dense, so `X` is integral.  A hypersurface
is Cohen--Macaulay, hence satisfies `S2`.  Its finite singular locus has
codimension three, so it is regular in codimension one (`R1`).  Serre's
criterion proves that `X` is normal.

No local-factoriality or Grothendieck--Lefschetz assertion is being smuggled
into this step.

## 5. The class group and the generic-fibre index

Put

```text
U=P2_z-B,  V=X-(B x P2_lambda),  E=B x P2_lambda.
```

The evaluation map of the three sections is surjective on `U`, and its kernel
is a rank-two vector bundle.  Thus `V -> U` is its projectivization, a
`P1`-bundle.  Since removing a codimension-two closed point does not alter the
class group of the regular plane,

```text
Cl(U)=Cl(P2_k)=Z*H_z.
```

The projective-bundle formula gives

```text
Cl(V)=Z*H_z + Z*H_lambda.
```

Because `B` is one integral cubic point, `E=P2_(L_B)` is one prime divisor of
the normal threefold `X`.  The localization sequence

```text
Z*[E] -> Cl(X) -> Cl(V) -> 0
```

shows that `Cl(X)` is generated by `H_z`, `H_lambda`, and `E`; injectivity of
the first arrow is neither asserted nor needed.

Restrict to the generic fibre over `P2_lambda`, whose field is
`k(P2_lambda)=C(r,rho,T)`.  The three generator degrees are

```text
deg(H_z)=3,  deg(H_lambda)=0,  deg(E)=3.
```

For `E`, this is simply the length of the cubic field base point after the
purely transcendental extension.  Every closed point of the smooth generic
cubic closes to an integral horizontal codimension-one subvariety of `X`,
hence to a Weil-divisor class.  Restricting its class to the generic fibre
shows that its degree belongs to `3Z`.  A plane line supplies a divisor of
degree three, so

```text
ind(C_res/C(D))=3.
```

In particular `C_res(C(D))` is empty.

## 6. Proper specialization

If the original cubic had a `K_proj`-point, the degree-one henselian factor
from Section 1 would give a point over the henselian valued field.  The
projective plane-cubic model is proper over the valuation ring, so the
valuative criterion extends the point and reduces it to a `C(D)`-point of the
residual cubic.  Section 5 excludes that point.  Therefore

```text
C(K_proj)=empty.
```

This is an all-point obstruction, not a bounded conic or coordinate search.

## Replay

From this directory run

```text
/opt/homebrew/bin/python3 verify_lift_hypotheses.py
```

Expected markers:

```text
EXACT_BASE_SUBSCHEME_INCLUSION_ACCEPT
FINITE_FLAT_DEGREE3_MODEL_ACCEPT
GOOD_FIBER_PROJECTIVE_IDEAL_EQUALITY_ACCEPT
EXACT_CONORMAL_RANK2_INPUT_ACCEPT
```
