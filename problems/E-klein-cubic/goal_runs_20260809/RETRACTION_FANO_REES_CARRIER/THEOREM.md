# The retraction Fano--Rees carrier theorem

**Field:** `C`  
**Group:** `G=PSL2(F11)`  
**Target:** the Klein cubic `X=V(F) subset P(W_5)`

## 1. Retraction setup and the intrinsic line ideal

Assume that a primitive homogeneous `G`-covariant tuple `T` defines a rational
retraction

\[
T:\mathbf P(W_5)\dashrightarrow X,
\qquad F(T)=0,
\qquad [T]|_X=\operatorname{id}_X.
\]

Use the accepted normal form

\[
T=Hx+FQ,
\qquad \deg H=d-1,
\qquad \deg Q=d-3,
\qquad \gcd(H,F)=1,
\tag{1.1}
\]

and put

\[
B=V_X(H).
\tag{1.2}
\]

The gauge change

\[
(H,Q)\longmapsto(H+FU,Q-Ux)
\tag{1.3}
\]

does not change the ten Pluecker forms

\[
\Pi_{ij}=x_iQ_j-x_jQ_i.
\tag{1.4}
\]

They are intrinsic to the actual landing tuple because

\[
x_iT_j-x_jT_i=F\Pi_{ij}.
\tag{1.5}
\]

Let

\[
J_{\rm line}=(\Pi_{ij})\mathcal O_B
\]

and define

\[
\Gamma_{\rm line}
=\operatorname{Proj}_B\overline{\mathcal R(J_{\rm line})}.
\tag{1.6}
\]

This is the normalization of the graph of the rational line map

\[
\lambda:B\dashrightarrow\operatorname{Gr}(2,W_5),
\qquad
x\longmapsto\langle x,Q(x)\rangle.
\tag{1.7}
\]

The complete polar identities give, on the noncollapsed locus of `B`,

\[
F(ux+vQ(x))=0
\qquad\text{for all }[u:v]\in\mathbf P^1.
\tag{1.8}
\]

Hence `lambda` lands in the Fano surface `S=F(X)` of lines on `X`.  The
carrier model (1.6) is selected by the actual tuple and is independent of a
chosen resolution.

## 2. The involution-fixed genus-four Fano curve

Fix an involution `t` and write

\[
W_5=W_+(t)\oplus W_-(t),
\qquad \dim W_+=3,\quad \dim W_-=2.
\]

Put

\[
E_t=X\cap\mathbf P(W_+),
\qquad
L_t=\mathbf P(W_-).
\]

Cubic parity gives

\[
F(x+y)=F(x)+3\Phi(x,y,y)
\qquad(x\in W_+,\ y\in W_-).
\tag{2.1}
\]

Define

\[
R_t=
\{([x],[y])\in E_t\times L_t:\Phi(x,y,y)=0\}.
\tag{2.2}
\]

### Theorem 2.1

The map

\[
([x],[y])\longmapsto[\mathbf P(\langle x,y\rangle)]
\tag{2.3}
\]

identifies `R_t` with the curve component of the fixed locus `S^t`.  The only
other fixed component is the isolated point represented by `L_t`.  The curve
`R_t` is smooth, connected, and irreducible, and

\[
\deg(R_t/E_t)=2,
\qquad
\deg(R_t/L_t)=3,
\qquad
g(R_t)=4.
\tag{2.4}
\]

### Proof

A `t`-stable two-dimensional vector subspace is either contained in an
eigenspace or is a sum of one plus and one minus eigenline.  The smooth plane
cubic `E_t` contains no line, while `P(W_-)=L_t`.  Thus every non-isolated
`t`-fixed line is uniquely mixed and is governed by (2.1).

The fixed locus of a finite-order automorphism on the smooth surface `S` is
smooth.  Equation (2.2) is a section of

\[
\mathcal O_{E_t}(1)\boxtimes\mathcal O_{\mathbf P^1}(2),
\]

an ample line bundle, so the zero divisor is connected.  Its class on
`E_t x P1` is `3A+2B`; adjunction with `K=-2B` gives genus four.  The
projection degrees are the two bidegrees.  `square`

Roulleau's harmonic-inversion calculation decomposes the incidence divisor of
lines meeting `L_t` as

\[
C_{L_t}=D_t+R_t.
\tag{2.5}
\]

Here `D_t` is the smooth genus-two component.  It parametrizes lines exchanged
in pairs by `t`; it is not the retraction fixed-line carrier.  The residual
component is the genus-four curve (2.2), whose lines contain a point of `E_t`
and are fixed setwise by `t`.

Numerically, if `C` is an incidence class on `S`, then

\[
C^2=5,\qquad C\cdot D_t=2,\qquad D_t^2=-4,\qquad K_S=3C,
\]

so

\[
R_t=C-D_t,\qquad R_t^2=-3,\qquad K_S\cdot R_t=9.
\tag{2.6}
\]

## 3. The base surface is forced to be singular along all fixed elliptics

Every ambient landing tuple vanishes on every involution plus-plane.  On `X`,
`T=Hx`; therefore

\[
E_t\subset B
\tag{3.1}
\]

for all 55 involutions.

### Proposition 3.1

\[
E_t\subset\operatorname{Sing}(B)
\qquad\text{for every }t.
\tag{3.2}
\]

### Proof

The differential of `H|_X` vanishes on `T_xE_t` because `H` vanishes
identically on `E_t`.  The involution acts as `-1` on the two normal
directions in `T_xX`.  Since `H` is invariant,

\[
dH_x(v)=dH_x(tv)=dH_x(-v)=-dH_x(v),
\]

so it vanishes normally as well.  `square`

Thus every hypothetical retraction base is singular in codimension one along
the complete 55-elliptic arrangement.

## 4. Exact carrier alternatives above `E_t`

Let `C_0` be an irreducible component of the inverse image of `E_t` in
`Gamma_line` which dominates `E_t`, and let `C_0^nu` be its normalization.
The graph morphism gives a nonconstant map

\[
\beta:C_0^\nu\longrightarrow S.
\tag{4.1}
\]

It is nonconstant because a single line cannot contain a general point of
`E_t`.

### Theorem 4.1 — fixed versus paired carriers

Exactly one of the following occurs.

1. `C_0` is fixed by `t`.  Then `beta` factors through `R_t`, and for some
   `k>=1`,
   \[
   \deg(C_0^\nu/E_t)=2k,
   \qquad
   \deg(C_0^\nu/R_t)=k,
   \qquad
   g(C_0^\nu)\ge3k+1.
   \tag{4.2}
   \]
2. `C_0` is not fixed by `t`.  Then `C_0` and `tC_0` are distinct components
   with the same source degree and exchanged line images.

No component above `E_t` has source degree one.

### Proof

In the fixed case, the image lies in `S^t`.  It cannot be the isolated point
`[L_t]`, since `L_t` does not contain a general point of `E_t`.  Hence it lies
on `R_t`.  The source point of the selected mixed line is its plus-plane
intersection, so the diagram

\[
\begin{CD}
C_0^\nu @>>> R_t\\
@VVV @VVV\\
E_t @= E_t
\end{CD}
\]

commutes.  Degree multiplication gives the first two equations in (4.2), and
Riemann--Hurwitz over the genus-four curve gives the genus bound.

If a component had source degree one, it would be birational to `E_t` and
would give a nonconstant map from an elliptic curve to `S`.  The Albanese
embedding excludes rational curves on a Fano surface.  Roulleau's
elliptic-curve/involution correspondence excludes elliptic curves on the Klein
Fano surface: an elliptic curve would give a type-I involution of trace `-3`,
whereas every involution of `G` has trace `1`.  Thus degree one is impossible.
`square`

The theorem retains the genuine paired-component escape.  It does **not**
relabel every component as a cover of `R_t`.

## 5. Noncollapse for an irreducible base

### Proposition 5.1

If `B` is irreducible, the line map (1.7) is nonconstant on a dense open set.

### Proof

Assume all `Pi_ij` vanish on `B`.  The homogeneous ideal of the integral
complete intersection `B` is `(F,H)`.  Since

\[
\deg\Pi_{ij}=d-2<d-1=\deg H,
\]

every `Pi_ij` is divisible by `F`.  Hence `Q|_X` is pointwise proportional to
`x`.  The scalar is a section of `O_X(d-4)` and lifts by projective normality
to a polynomial `U`; thus

\[
Q=Ux+FV.
\]

After the gauge transformation (1.3), `Q'=FV` and

\[
T=H'x+FQ',\qquad \gcd(H',F)=1.
\]

In the cubic landing identity

\[
H'^3+3H'^2\Phi(x,x,Q')
+3H'F\Phi(x,Q',Q')+F^2F(Q')=0,
\]

every term except `H'^3` is divisible by `F`.  Reduction modulo `F` forces
`F|H'`, a contradiction.  `square`

For a reducible base, an individual component can remain a fixed component of
the Pluecker system; no componentwise noncollapse is asserted.

## 6. Global dichotomy for an irreducible base

Assume from now on that `B` is irreducible and let `Y` be a smooth model of
`Gamma_line`.  By Proposition 5.1, the image of

\[
\lambda_Y:Y\longrightarrow S
\]

has dimension one or two.

### Branch A — dominant Fano image

If the image is `S`, then `lambda_Y` is generically finite.  Pullback gives

\[
H^0(S,\Omega_S^p)\hookrightarrow H^0(Y,\Omega_Y^p)
\qquad(p=1,2),
\]

and an injection on `NS(-)_Q`.  Since the Klein Fano surface has

\[
q(S)=5,\qquad p_g(S)=10,\qquad \rho(S)=25,
\]

one obtains

\[
q(Y)\ge5,\qquad p_g(Y)\ge10,\qquad \rho(Y)\ge25.
\tag{6.1}
\]

The existence of a single fixed carrier in Theorem 4.1 forces this branch.
Indeed, equivariance then puts all 55 distinct curves `R_t` in the image, and
an irreducible curve cannot contain them.

### Branch B — ruled curve image

Suppose the image is an irreducible curve `Sigma subset S`.  For a general
`ell in Sigma`, the fibre of `Y -> Sigma` is one-dimensional and its source
points lie on `ell`.  Hence the fibre maps birationally onto `ell`, and

\[
Y\sim_{\rm bir}\mathbf P(T_S)|_{\Sigma^\nu}.
\tag{6.2}
\]

The induced `G`-action on `Sigma^nu` is faithful.  Its kernel is normal in the
simple group `G`; a trivial action would make every line in `Sigma` a
`G`-stable two-dimensional subspace of the irreducible module `W_5`.

The smallest faithful genus is 26.  Indeed, the element orders are
`2,3,5,6,11`; the smallest positive hyperbolic signature is `(2,3,11)`, with
orbifold Euler characteristic `5/66`.  Four or more branch points, or positive
quotient genus, gives no smaller positive value; the Euclidean zero cases do
not admit the nonabelian simple group.  Hence

\[
g(\Sigma^\nu)\ge26.
\tag{6.3}
\]

Roulleau's 55 genus-two curves span `NS(S)_Q`, and their permutation module
has a one-dimensional invariant subspace.  Thus

\[
NS(S)^G=\mathbf Z[C],
\tag{6.4}
\]

where `C` is an incidence class.  Integrality follows because a class `qC`
has intersections `5q` with `C` and `2q` with every genus-two curve.
Consequently

\[
[\Sigma]=nC
\qquad(n\ge1).
\tag{6.5}
\]

Adjunction gives

\[
p_a(\Sigma)=1+\frac{5n^2+15n}{2}.
\tag{6.6}
\]

For `n=1` this is 11, contradicting (6.3); hence `n>=2`.  If `n=2`, equality
forces `Sigma` to be smooth of genus 26 with signature `(2,3,11)`.

Let

\[
\pi:\mathcal I=\mathbf P(T_S)\to S,
\qquad e:\mathcal I\to X,
\qquad \xi=e^*H_X.
\]

The tangent-bundle theorem gives

\[
\pi_*(\xi^2)=c_1(\Omega_S)=K_S.
\]

Since (6.2) is birational both to the universal family over `Sigma` and to
`B`,

\[
\deg B=K_S\cdot\Sigma=3C\cdot nC=15n.
\]

But `B sim (d-1)H_X` on the cubic, so `deg B=3(d-1)`.  Therefore

\[
\boxed{d=5n+1,\qquad n\ge2.}
\tag{6.7}
\]

In this branch

\[
q(Y)=g(\Sigma^\nu)\ge26,\qquad p_g(Y)=0,
\tag{6.8}
\]

and every carrier above every `E_t` must be nonfixed and paired; a fixed
carrier would force Branch A.

## 7. Residual Hodge representation of `R_t`

The residual group is

\[
N_G(\langle t\rangle)/\langle t\rangle\simeq S_3.
\]

The order-three element acts freely on `R_t` because it translates `E_t` by a
nonzero 3-torsion point.  Its quotient has genus two.  A residual reflection
has two fixed points on `R_t`: its isolated fixed line and the unique point of
`R_t cap R_s` for the commuting involution `s`.  The latter uniqueness follows
from

\[
R_t\cdot R_s=(C-D_t)(C-D_s)=5-2-2+0=1.
\]

Thus the reflection quotient also has genus two, and

\[
\chi_{H^0(R_t,\Omega^1)}=(4,0,1)
\]

on `(1, reflection, 3-cycle)`.  Therefore

\[
H^0(R_t,\Omega^1)
\simeq
\mathbf1\oplus\operatorname{sgn}\oplus\operatorname{std}.
\tag{7.1}
\]

The exact centralizer restriction of the Klein module is

\[
W_5|_{D_{12}}
=(\mathbf1\oplus\operatorname{std})_{t=+1}
\oplus(\operatorname{std})_{t=-1}.
\tag{7.2}
\]

Hence

\[
\dim\operatorname{Hom}_{D_{12}}
\bigl(W_5,H^0(R_t,\Omega^1)\bigr)=2.
\tag{7.3}
\]

By Frobenius reciprocity, the orbit of the 55 curves `R_t` carries two copies
of `W_5`.  Every fixed source carrier covering `R_t` inherits these
differentials.

By contrast,

\[
H^0(E_t,\Omega^1)\simeq\operatorname{sgn},
\]

so

\[
\operatorname{Hom}_{D_{12}}
\bigl(W_5,H^0(E_t,\Omega^1)\bigr)=0.
\tag{7.4}
\]

The original 55 elliptics cannot themselves supply the Weil Hodge summand;
the genus-four Fano carriers can.

## 8. Exact theorem boundary

The packet proves

```text
DELTA1-CANONICAL-PLUECKER-REES-GRAPH
DELTA1-BASE-SINGULAR-ALONG-ALL-55-ELLIPTICS
DELTA1-FIXED-FANO-GENUS4-CURVES
DELTA1-NO-DEGREE-ONE-ELLIPTIC-CARRIER
DELTA1-FIXED-CARRIERS-EVEN-DEGREE
DELTA1-IRREDUCIBLE-BASE-NONCOLLAPSE
DELTA1-GLOBAL-FANO-OR-RULED-DICHOTOMY
DELTA1-RULED-BRANCH-d-EQUIV-1-MOD-5
DELTA1-GENUS4-CARRIERS-SUPPLY-WEIL-HODGE-MODULE
```

It does not prove that either global branch is empty.  The smallest remaining
retraction theorem is a conductor/Hurwitz incompatibility for the singular
Cartier divisor `B` and its normalized Pluecker graph.
