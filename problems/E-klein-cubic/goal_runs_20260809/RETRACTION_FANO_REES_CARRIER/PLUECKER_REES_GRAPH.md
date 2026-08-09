# The canonical Pluecker Rees graph of a retraction

Assume

\[
T=Hx+FQ,\qquad F(T)=0,\qquad [T]|_X=\operatorname{id}_X,
\]

and put `B=V_X(H)`.

## 1. Gauge-independent line ideal

The retraction presentation has gauge freedom

\[
(H,Q)\mapsto(H+FU,Q-Ux).
\]

The ten Pluecker forms

\[
\Pi_{ij}=x_iQ_j-x_jQ_i
\]

are unchanged.  They can be recovered directly from the landing tuple:

\[
F\Pi_{ij}=x_iT_j-x_jT_i.
\]

Thus the ideal

\[
J_{\rm line}=(\Pi_{ij})\mathcal O_B
\]

is intrinsic to `T`.  On the open set where the tuple does not vanish, it
defines

\[
\lambda:B\dashrightarrow\operatorname{Gr}(2,W_5),
\qquad x\mapsto\langle x,Q(x)\rangle.
\]

The complete polar identities imply that this line is contained in `X`.
Hence `lambda` lands in the Fano surface `S=F(X)`.

The canonical carrier model is

\[
\Gamma_{\rm line}
=\operatorname{Proj}_B\overline{\mathcal R(J_{\rm line})},
\]

the normalization of the graph closure.  No arbitrary principalization is
used in its definition.

## 2. The line map cannot collapse on an irreducible base

Suppose that `B` is irreducible and that all `Pi_ij` vanish on `B`.  The ideal
of `B` in the ambient polynomial ring is `(F,H)`.  Since

\[
\deg\Pi_{ij}=d-2<d-1=\deg H,
\]

homogeneous degree forces

\[
\Pi_{ij}\in(F)
\]

for every pair.  Consequently `Q|_X` is everywhere proportional to `x`.
The proportionality scalar is a section of `O_X(d-4)` and lifts by projective
normality to a polynomial `U`.  Thus

\[
Q=Ux+FV
\]

for a covariant `V`.  Apply the gauge transformation to obtain

\[
T=H'x+FQ',\qquad Q'=FV,\qquad \gcd(H',F)=1.
\]

In the exact cubic identity

\[
H'^3+3H'^2\Phi(x,x,Q')
 +3H'F\Phi(x,Q',Q')+F^2F(Q')=0,
\]

every term except `H'^3` is divisible by `F`.  Reduction modulo `F` gives

\[
F\mid H'^3,
\]

contradicting `gcd(H',F)=1`.

Therefore:

> **Noncollapse theorem.** If the retraction base `B` is irreducible, the
> canonical line map `lambda:B -->> S` is nonconstant on a dense open set.

For a reducible base, an individual component can still be a fixed component
of the Pluecker system.  This is retained as a separate branch; the theorem
above is not silently applied componentwise.

## 3. Forced singularity along the involution elliptics

Every ambient landing tuple vanishes on every involution plus-plane.  On `X`,
`T=Hx`, so

\[
E_t\subset B
\]

for all 55 involutions.

At a point `x in E_t`, `d(H|_X)` vanishes on `T_xE_t` because `H|_{E_t}=0`.
It also vanishes on the two normal directions: `t` acts by `-1` there and `H`
is invariant.  Hence

\[
E_t\subset\operatorname{Sing}(B)
\]

scheme-theoretically at the level of the first derivative.  Any hypothetical
retraction base is therefore singular in codimension one along the complete
55-elliptic arrangement.

## 4. Carrier alternatives over `E_t`

Let `C` be an irreducible component of the inverse image of `E_t` in
`Gamma_line` which dominates `E_t`.

- If `C` is fixed by `t`, its line image is contained in the fixed locus of `t`
  on `S`.  The image cannot be the isolated point `L_t`, since one fixed line
  cannot contain a general point of `E_t`.  Therefore `C` maps finitely onto
  the genus-four curve `R_t`.
- If `C` is not fixed by `t`, it occurs together with the distinct component
  `tC`.  Their line images are exchanged by `t`.

In the fixed case there is a commutative diagram

\[
\begin{CD}
C^\nu @>>> R_t\\
@VVV @VVV\\
E_t @= E_t,
\end{CD}
\]

and therefore

\[
\deg(C^\nu/E_t)=2\deg(C^\nu/R_t).
\]

Thus every fixed carrier has even source degree and, if that degree is `2k`,
Riemann--Hurwitz gives

\[
g(C^\nu)\ge3k+1.
\]

A degree-one carrier of either type is impossible.  Indeed, a degree-one
component is birational to the elliptic curve `E_t` and yields a nonconstant
map from an elliptic curve to `S`.  The Albanese embedding excludes rational
curves on `S`, and Roulleau's involution/elliptic-curve correspondence excludes
elliptic curves on the Klein Fano surface: all involutions of `G` have trace
`1`, whereas an elliptic curve would produce a type-I involution of trace
`-3`.

Hence every normalized Pluecker carrier above an involution elliptic has
source degree at least two; fixed carriers have the sharper even-degree and
genus-four-cover description.
