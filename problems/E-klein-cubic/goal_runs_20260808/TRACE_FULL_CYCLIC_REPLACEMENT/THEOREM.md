# Full-cyclic-span replacement for the `F55` trace cubic

**Date:** 2026-08-08  
**Result:** `F55-TRACE-FULL-CYCLIC-SPAN-REPLACEMENT`  
**Global status:** OPEN

Let

\[
 G=F_{55}=C_{11}\rtimes C_5
\]

act on its original faithful five-dimensional Klein representation `W`, and
let `X subset P(W)` be the Klein cubic.  On a free open
`U subset P(W)`, put

\[
 B=U/G,\qquad K=\mathbf C(B),
\]

and let `T/K` be the generic `G`-torsor.  In the authoritative trace
trivialization,

\[
 E=\mathbf C(r_0,\ldots,r_4)/(r_0\cdots r_4-1),
 \qquad K=E^{\langle\sigma\rangle},
\]

and a `K`-point of `{}^T X` is represented by a nonzero `a in E` satisfying

\[
 \Phi(a)=\operatorname {Tr}_{E/K}
 \big(ca^2\sigma(a)\big)=0,
 \qquad c=r_2^{-1}.                                    \tag{0.1}
\]

## Theorem

If (0.1) has any nonzero solution, then it has a solution `a'` for which,
after setting

\[
 b=ca'^2\sigma(a'),\qquad b_i=\sigma^i(b),
\]

one has

\[
 \dim_{\mathbf C}\operatorname {span}_{\mathbf C}
 \{b_0,b_1,b_2,b_3,b_4\}=4.                             \tag{0.2}
\]

Equivalently, for a primitive fifth root `zeta`, all four nontrivial
additive Fourier components

\[
 \widehat b_q={1\over5}\sum_{i=0}^4\zeta^{-iq}b_i,
 \qquad q=1,2,3,4,                                      \tag{0.3}
\]

are nonzero.  Since they have four distinct `sigma`-eigenvalues, they are
automatically `C`-linearly independent.

Thus the unrestricted trace question is equivalent to its full cyclic-span
four branch.  This is a replacement theorem: `a'` need not equal the
original solution.

## 1. What the versality theorems do and do not say

Duncan--Reichstein define:

* weakly versal: every twist has a rational point;
* versal: every invariant dense open is weakly versal;
* very versal: there is a dominant equivariant rational map from **some**
  linear representation.

Their Theorem 1.1 identifies these with, respectively, points, dense points,
and unirationality on every twist.  For a smooth invariant cubic
hypersurface of dimension at least two, their Lemma 10.1 and Theorem 10.5,
using Kollár's cubic unirationality theorem, give

\[
 \text{weakly versal}\iff\text{versal}\iff\text{very versal}. \tag{1.1}
\]

A point on the one generic twist above does imply weak versality here.  It
gives a rational `G`-map from `P(W)` to `X`.  Its invariant domain is a dense
open of `P(W)`; after twisting by any torsor over an extension of `C`, that
domain is a dense open in a split projective four-space and hence has a
rational point.

There is nevertheless a genuine source gap in quoting (1.1) alone:
"very versal" only supplies an unspecified representation.  It does not say
that the dominant map comes from this original `P(W)`.  The next lemma fills
that gap in characteristic zero.

## 2. Prescribed-source graph lemma

### Lemma 2.1

Let `k` be algebraically closed of characteristic zero, let a finite group
`G` act freely on a dense open `U subset P(V)`, and put `B=U/G` and
`K=k(B)`.  Let `Y` be a smooth `G`-invariant cubic hypersurface of dimension
`d>=2`, embedded in a projective representation.  If

\[
 \dim B\ge d                                             \tag{2.1}
\]

and the generic twist `{}^T Y` has a `K`-point, then there is a dominant
`G`-equivariant rational map

\[
 \mathbf P(V)\dashrightarrow Y.                         \tag{2.2}
\]

### Proof

Duncan--Reichstein Lemma 10.1 says `{}^T Y` is again a smooth cubic in a
split projective space.  By Kollár's Theorem 1, its `K`-point makes it
`K`-unirational.  Choose a dominant rational parametrization

\[
 \psi:\mathbf A_K^N\dashrightarrow{}^T Y.               \tag{2.3}
\]

Spread (2.3) over a nonempty open of `B` and pull it back along the finite
étale torsor `pi:U->B`.  Torsor untwisting gives a `G`-equivariant rational
map

\[
 F:U\times\mathbf A^N\dashrightarrow Y,                 \tag{2.4}
\]

where `G` acts trivially on `A^N`.  After shrinking, choose a complex point
`(u_0,t_0)` in the regular locus at which the vertical differential

\[
 C=d_tF:T_{t_0}\mathbf A^N\longrightarrow T_{F(u_0,t_0)}Y
\]

is surjective.  Such a point exists because (2.3) is dominant and
characteristic zero makes it generically separable.  Write `b_0=pi(u_0)`.
The quotient `B` is smooth and `d pi:T_{u_0}U->T_{b_0}B` is an isomorphism.

Choose a rational map `h:B-->A^N`, regular at `b_0`, with
`h(b_0)=t_0`.  Its first derivative at `b_0` may be prescribed arbitrarily:
smooth local parameters realize every class modulo the square of the maximal
ideal.  Put

\[
 f(u)=F\big(u,h(\pi(u))\big).                            \tag{2.5}
\]

If `A=d_uF`, then

\[
 df_{u_0}=A+C\,(dh)_{b_0}\,d\pi.                        \tag{2.6}
\]

By (2.1), choose a surjection
`S:T_{u_0}U->T_{F(u_0,t_0)}Y`.  Since `C` is surjective, choose
`(dh)_{b_0}` so that the right side of (2.6) equals `S`.  Hence `f` has rank
`d` at `u_0` and is dominant.  It is `G`-equivariant because `h o pi` is
`G`-invariant and (2.4) is equivariant.  This proves (2.2).  QED.

For the present source, the projective action is generically free.  Indeed,
`F55` has trivial center; since `W` is faithful and irreducible, no
nonidentity element acts by a scalar, and the finite union of the remaining
projective fixed loci is proper.  Moreover,

\[
 \dim B=\dim\mathbf P(W)=4>3=\dim X.                    \tag{2.7}
\]

Lemma 2.1 therefore produces a dominant map from the same original
projective four-space.  Composing with `W\setminus\{0\}->P(W)` gives the
corresponding dominant map from the original affine five-space as well.

## 3. Dominance forces full additive Fourier span

On the dense coordinate torus of the Klein cubic, consider

\[
 \mu:X\dashrightarrow H,
 \qquad
 [x_0:\cdots:x_4]\longmapsto
 [x_0^2x_1:x_1^2x_2:\cdots:x_4^2x_0],                  \tag{3.1}
\]

where

\[
 H=\{y_0+\cdots+y_4=0\}\simeq\mathbf P^3.
\]

The exponent map of (3.1) on the projective torus is `2+sigma`.  Its Smith
form on the augmentation lattice is

\[
 \operatorname {diag}(1,1,1,11),                       \tag{3.2}
\]

so it is a finite degree-eleven isogeny.  Because the Klein equation is
exactly `sum x_i^2x_(i+1)=0`, its restriction (3.1) is dominant onto the
trace hyperplane `H`.

Let `f:P(W)-->X` be the dominant map obtained from Lemma 2.1.  The composite
`mu o f` is dominant onto `H`.  Under the authoritative trace
trivialization, its five coordinate functions, up to one common nonzero
invariant scalar, are

\[
 b_i=\sigma^i\big(ca'^2\sigma(a')\big).                 \tag{3.3}
\]

The trace equation supplies the relation `sum b_i=0`.  If their complex
linear span had dimension at most three, there would be a second independent
constant linear relation, and the image of `mu o f` would lie in a proper
linear subspace of `H`.  This contradicts dominance.  Hence their span is
four, proving (0.2) and (0.3).

## 4. Exact scope

The valid conclusion is

```text
any F55 trace zero => another F55 trace zero of cyclic span four
```

Consequently a uniform exclusion of the rank-four branch would prove
`F55-NO`; the rank-three branch need not be excluded separately for that
negative implication.  The theorem constructs no trace zero and excludes no
rank-four trace zero.  Therefore the unrestricted `F55` and
`PSL(2,11)` questions remain open.

```text
F55-TRACE-FULL-CYCLIC-SPAN-REPLACEMENT
F55-TRACE-QUESTION-EQUIVALENT-TO-CYCLIC-RANK-FOUR
F55-GLOBAL-QUESTION-OPEN
```
