# Coupling all twelve Sylow-eleven presentations reconstructs the Klein cubic

**Date:** 2026-08-08  
**Scope:** all twelve conjugates of `C11:C5` in `PSL(2,11)`, with no degree
or support bound  
**Verdict:** exact method boundary; the full equivariant-unirationality
question remains open

Let

\[
 G=\operatorname {PSL}_2(\mathbf F_{11}),\qquad
 X=\left\{\sum_{i\in\mathbf Z/5}x_i^2x_{i+1}=0\right\}\subset\mathbf P^4,
 \qquad L=\mathbf C(X).
\]

For a Sylow subgroup `P=C11`, put `H=N_G(P)=C11:C5`.  In a `P`-eigenframe
the weights are

\[
 w=(1,9,4,3,5),\qquad w_{i+1}=9w_i=-2w_i\pmod {11}.
 \tag{0.1}
\]

The rank-three theorem in `RANK4_GLOBAL/RANK3_KLEIN_COVER_BOUNDARY.md`
identifies the surviving local Kummer cover with

\[
 \pi_P:X\dashrightarrow \mathcal H_P\simeq\mathbf P^3,
 \qquad y_i=x_i^2x_{i+1},\qquad \sum_i y_i=0.
 \tag{0.2}
\]

The point of this note is that the twelve conjugates of (0.2) are not
twelve independent Kummer covers.  They are the twelve order-eleven
quotient presentations of the same `G`-field `L`.

## Theorem 1: the final rank-three cover is the `P`-quotient

For every Sylow-eleven subgroup `P`,

\[
 \mathbf C(\mathcal H_P)=L^P,
 \qquad [L:L^P]=11.
 \tag{1.1}
\]

In particular, `X/P` is rational and (0.2) is its rational quotient map.

### Proof

Equation (0.1) gives

\[
 2w_i+w_{i+1}=0\pmod {11},
\]

so every `y_i` is `P`-invariant.  On the projective character lattice
`Lambda={n in Z^5:sum n_i=0}`, pullback is the circulant operator

\[
 (Cn)_k=2n_k+n_{k-1}.
\]

Its Smith invariants on `Lambda` are `(1,1,1,11)`.  Thus (0.2) has generic
degree eleven.  The faithful group `P` of order eleven acts in its generic
fibre, so the degree-eleven invariant subfield is exactly `L^P`.  QED.

## Theorem 2: two distinct Sylows already recover `L`

If `P` and `Q` are distinct Sylow-eleven subgroups, then

\[
 \boxed{\quad L^P L^Q=L.\quad}
 \tag{2.1}
\]

Moreover,

\[
 L^P\cap L^Q=L^G.
 \tag{2.2}
\]

Equivalently, the combined rational map

\[
 (\pi_P,\pi_Q):X\dashrightarrow (X/P)\times(X/Q)
 \tag{2.3}
\]

is birational onto its image.

### Proof of the compositum statement

Put `A=L^P` and `B=L^Q`.  Since `L/A` is a cyclic Galois extension of prime
degree eleven, the intermediate field `AB` is either `A` or `L`.  If
`AB=A`, then `B subset A`.  Both `A` and `B` have index eleven in `L`, so
`A=B`.  But then `Q` fixes `A`, hence

\[
 Q\subset\operatorname {Aut}(L/A)=P,
\]

which forces `Q=P`.  This contradicts the hypothesis, proving (2.1).

For (2.2), two distinct Sylow-eleven subgroups generate `G`.  Indeed, if
`K=<P,Q>`, then the number of Sylow-eleven subgroups of `K` is twelve.
Consequently `132` divides `|K|`; since `|K|` divides `660`, either
`|K|=132` or `K=G`.  The first case would give an index-five subgroup of
the simple group `G`.  Its coset action would inject `G` into `S5`, which is
impossible because `660>120`.  Thus `K=G`, and

\[
 L^P\cap L^Q=L^{\langle P,Q\rangle}=L^G.
\]

QED.

## Corollary 3: the compatible fibre product contains `X`, not a new cover

Consider the quotients over the common base `X/G`.  The normalization of

\[
 (X/P)\mathbin{\times_{X/G}}(X/Q)
 \tag{3.1}
\]

has components indexed by the double cosets `P\G/Q`; the component indexed
by `g` is birational to

\[
 X/(P\cap gQg^{-1}).
 \tag{3.2}
\]

There are exactly ten double cosets.  Five have intersection of order
eleven and normalize to `X/P`, while five have trivial intersection and
normalize to `X`.  To see the count, let `P` act on the sixty cosets `G/Q`.
Exactly

\[
 |N_G(P)|/|Q|=55/11=5
\]

cosets are fixed; the remaining fifty-five form five free orbits of length
eleven.

For `P != Q`, the diagonal compatible component has stabilizer
`P intersection Q=1`, hence its normalization is `X`.  The analogous
compatible component of the twelve-fold fibre product also normalizes to
`X`.  It cannot have positive Kodaira dimension: `X` is the Fano cubic with
`K_X=O_X(-2)`.

Thus coupling the final Kummer covers across conjugate Sylows cannot repeat
the successful intermediate-cover argument from `RANK4_GLOBAL`.  Two local
presentations already reconstruct the original target.

## Proposition 4: the sixty boundary divisors form consistent blocks

The five `P`-eigen-hyperplanes, as `P` varies, form one `G`-orbit

\[
 \Omega\simeq G/P,
 \qquad |\Omega|=60.
 \tag{4.1}
\]

The projection

\[
 G/P\longrightarrow G/H
 \tag{4.2}
\]

partitions them into twelve blocks of five, one block for each Sylow
subgroup.  A hyperplane belongs to only one block: if its eigenline were
stabilized by two distinct Sylows, those Sylows would generate `G`, forcing
a `G`-invariant line in the irreducible Klein representation.

Write `D_(P,i)` for the corresponding hyperplane section of `X`.  These are
distinct prime divisors.  In the displayed Klein frame, irreducibility of
`D_(P,0)` follows by viewing

\[
 x_1^2x_2+x_2^2x_3+x_3^2x_4
\]

as a primitive polynomial of degree one in `x_4`; the other cases follow by
the `G`-action.  The five trace summands have divisors

\[
 \operatorname {div}(y_i)=2D_{(P,i)}+D_{(P,i+1)}.
 \tag{4.3}
\]

Hence every one of the twelve rank-three incidence patterns is realized
simultaneously on `X`; there is no permutation-divisor inconsistency.

The local mod-eleven cokernel line is generated by

\[
 \mu=(1,5,3,4,9).
\]

Cyclic block rotation sends `mu` to `5mu` (or to `9mu` under the inverse
shift convention).  Therefore the twelve residue lines assemble as

\[
 \operatorname {Ind}_H^G(\chi),
 \tag{4.4}
\]

where `chi` is a nontrivial character of `H/P=C5`.  In particular this
module has no `G`-invariant vector: an invariant vector would have a base
component fixed by `H`, but `H/P` acts on that component by the nontrivial
scalar `5`.  Thus the twelve local residue characters do not combine into
a canonical `G`-invariant order-eleven Kummer character.

## Proposition 5: infinitely-near Sylow weights have an exact escape cycle

There is also no finite-state contradiction obtained by iterating
Sylow-fixed point blowups over the full sixty-point orbit.  If the four
nonzero, distinct tangent weights at a fixed point form `W` and one blows up
the eigen-direction of weight `a in W`, the tangent weights at that
infinitely-near fixed point are

\[
 U(W,a)=\{a\}\cup\{b-a:b\in W,\ b\ne a\}.
 \tag{5.1}
\]

Starting at the Klein vertex with

\[
 W_0=(4,7,9,10),
\]

the choices `7,3,3` reach `(1,2,3,7)`.  From there the following nine-step
cycle occurs:

```text
(1,2,3,7)  -2-> (1,2,5,10) -2-> (2,3,8,10)
           -2-> (1,2,6,8)  -2-> (2,4,6,10)
           -4-> (2,4,6,9)  -4-> (2,4,5,9)
           -4-> (1,4,5,9)  -1-> (1,3,4,8)
           -1-> (1,2,3,7).
```

Every state has four distinct nonzero weights.  Thus no zero tangent weight
and no repeated exceptional eigenspace is forced, at any depth, by the
weight update alone.  The construction is compatible with all conjugates
because

\[
 U(cW,ca)=cU(W,a),
\]

and the stabilizer of every chosen infinitely-near point remains exactly
`P`; its full `G`-orbit consequently has sixty points.  This is a formal
counterpath for the weight dynamics, not the base ideal of an actual
covariant.

## Exact stopping boundary

The all-conjugate compatibility problem has a universal solution: a generic
point of `X` and its twelve quotient images.  Conversely, any compatible
pair of quotient images generically reconstructs that point.  Therefore a
contradiction using only

* the twelve local rank-three Kummer covers,
* their boundary permutation modules,
* their fibre product over `X/G`, or
* iterated Sylow tangent weights

cannot prove non-unirationality.  A successful argument must still use the
fact that the source is a linear `G`-variety and must obstruct a dominant
`G`-equivariant embedding

\[
 \mathbf C(X)\hookrightarrow \mathbf C(W),
\]

not merely the internal compatibility of the twelve quotient presentations.

```text
FULL-G-SYL11-PAIR-QUOTIENTS-GENERATE-KLEIN-FIELD
FULL-G-ALL-SYL11-COMPATIBLE-COVER-IS-KLEIN
FULL-G-LOCAL-RESIDUE-MODULE-HAS-NO-INVARIANTS
FULL-G-INFINITELY-NEAR-WEIGHT-CYCLE-EXACT
FULL-G-COUPLING-ROUTE-TAUTOLOGICAL-BOUNDARY
PSL-KLEIN-QUESTION-OPEN
```
