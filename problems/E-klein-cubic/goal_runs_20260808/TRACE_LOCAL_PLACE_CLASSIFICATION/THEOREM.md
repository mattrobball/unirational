# Local-place classification for the exact `F55` trace cubic

**Date:** 2026-08-08  
**Scope:** divisorial completions of the exact field

\[
 E=\mathbf C(r_0,\ldots,r_4)/(\prod r_i-1),\qquad
 K=E^{\langle\sigma\rangle},\qquad \sigma(r_i)=r_{i+1},
\]

and the cubic

\[
 \Phi(a)=\operatorname {Tr}_{E/K}
 \left(r_2^{-1}a^2\sigma(a)\right)=0.                 \tag{0.1}
\]

**Verdict:** every split place, every toric-boundary place, every ramified
place of the full `F55` splitting torsor, and every unramified place with
proper decomposition group is locally soluble.  A bad divisorial completion,
if one exists, is exactly an unramified full-`F55` interior residue cubic.
No such pointless residue cubic is proved here.

## 1. The full splitting torsor

Let `H=F55=C11:C5`.  The sealed H4 model gives the full splitting field

\[
 L=E(\beta),\qquad
 \beta^{11}=b={r_0^2r_1r_3^4\over r_2^4},\qquad
 \sigma(\beta)={1\over r_2\beta^2}.                    \tag{1.1}
\]

Thus `L/K` is the generic `H`-torsor and (0.1) is its twist of the Klein
cubic

\[
 X=\left\{\sum_{i\in\mathbf Z/5}x_i^2x_{i+1}=0\right\}
 \subset\mathbf P^4.                                   \tag{1.2}
\]

Let `v` be a divisorial valuation of `K`, trivial on `C`, let `F=K_v^h`
(or the completion), and choose a prolongation to `L`.  Write `D_v` and
`I_v` for its decomposition and inertia subgroups in `H`.

## 2. Proper decomposition groups always give points

The only proper subgroups of `H` are, up to conjugacy,

\[
 1,\qquad C_{11},\qquad C_5.                             \tag{2.1}
\]

Each stabilizes a point of `X` over `C`.

* `C11` is diagonal in the Klein basis.  Every coordinate vertex `[e_i]`
  lies on `X` and is projectively fixed by `C11`.
* Let `epsilon` be a primitive fifth root of unity and
  `p_j=(epsilon^{ij})_{i=0}^4`, `j=1,2,3,4`.  The cyclic permutation fixes
  `[p_j]` projectively, and

  \[
  F_X(p_j)=\epsilon^j\sum_{i=0}^4\epsilon^{3ij}=0.       \tag{2.2}
  \]

  Hence `C5` fixes four points of `X`; these points have all five Klein
  coordinates nonzero.

A projective point fixed by the image of a twisting cocycle descends to a
point on the twist.  Therefore

\[
 D_v\ne H\quad\Longrightarrow\quad X_T(F)\ne\varnothing. \tag{2.3}
\]

This includes the split, unramified-`C11`, and unramified-`C5` cases.

If `I_v` is nontrivial, it is tame cyclic.  Since the residue field contains
all roots of unity, tame conjugation is trivial, so `I_v` is central in
`D_v`.  For a nontrivial element of `C11` its centralizer in `H` is `C11`,
and for a nontrivial element of a complement `C5` its centralizer is that
`C5`.  Thus nontrivial inertia forces `D_v` to be proper.  By (2.3),

\[
 I_v\ne1\quad\Longrightarrow\quad X_T(F)\ne\varnothing. \tag{2.4}
\]

In particular, a potentially bad full-decomposition place is automatically
unramified.

## 3. Split places have a dense trace point

Suppose the place splits in `E/K`.  Then

\[
 E\otimes_KF\simeq F^5
\]

and (0.1) is

\[
 \sum_i c_i a_i^2a_{i+1}=0,
 \qquad c_i\in F^*.                                    \tag{3.1}
\]

The exact Smith calculation for the projective map `a -> a^2 sigma(a)`
identifies its coefficient quotient with `F*/F*11`, through the resolvent
weights `(1,9,4,3,5)`.  Proposition 5.1 of `UNIT_RESIDUE_TOROIDAL` proves
that the trace-zero open `(b_i in F*, sum b_i=0)` maps onto this quotient:
for a target `z`, one may take

\[
 (b_i)=(z^{10},-z^{10},1,\omega,\omega^2),              \tag{3.2}
\]

where `omega^3=1`.  Choosing the target class of `(c_i)` gives nonzero
`a_i` solving (3.1).  Hence every split place has a point in the dense trace
torus, not merely a coordinate-vertex point.

## 4. Every toric-boundary place is split

Let

\[
 M=\mathbf Z^5/\mathbf Z(1,1,1,1,1),\qquad
 N=M^\vee=\{(n_i):\sum n_i=0\}.                         \tag{4.1}
\]

For a divisorial valuation `w` of `E`, its values on Laurent characters give
a cocharacter `n_w in N`.  If `w` is stabilized by `C5`, then

\[
 n_w=\sigma n_w.
\]

But `N^{C5}=0`: a cyclically fixed five-tuple is constant, and its coordinate
sum is zero.  Thus a stabilized valuation has `n_w=0`.

Equivalently, any valuation with nonzero toric cocharacter has a free orbit
of five prolongations.  In particular every boundary divisor on every
`C5`-equivariant toric model has trivial stabilizer: for a ray this also
follows because a fixed primitive ray generator would lie in `N^{C5}`.
The quotient divisorial place therefore splits completely in `E/K`.
Section 3 supplies a dense local trace point.

Conversely, `n_w=0` means that every Laurent character is a valuation unit,
so the center of `w` on the affine torus lies in the torus.  Consequently
every nonsplit, and hence every potentially bad, divisorial place is an
interior place.  This includes exceptional valuations centered over one of
the five isolated `C5`-fixed points of the torus.

## 5. Exact unramified interior reduction

Now let `v` be nonsplit in `E/K` and unramified.  Its unique prolongation
`w` to `E` is stabilized by `C5`, so Section 4 gives

\[
 w(r_i)=0\quad\text{for every }i.                       \tag{5.1}
\]

Put

\[
 k=\kappa(v),\qquad \ell=\kappa(w).
\]

Then `ell/k` is a cyclic degree-five extension, `trdeg_C(k)=3`, and both
`c=r_2^-1` and the Kummer radicand `b` in (1.1) are units.  Since the residue
characteristic is zero, the degree-eleven Kummer layer is either split or
unramified.  More precisely:

* if `[bar b]=0` in `ell*/ell*11`, then `D_v=C5`, so Section 2 gives a
  local point;
* if `[bar b]` is nonzero, then `ell(bar beta)/ell` has degree eleven and
  (1.1) gives the full residue `F55` action, so `D_v=H`.

Because the full torsor is unramified, it extends over the henselian DVR as
a finite etale torsor.  Twisting the smooth Klein cubic gives a smooth
proper model.  Its special fibre is exactly

\[
 \overline\Phi_\Delta(\bar a)=
 \operatorname {Tr}_{\ell/k}
 \left(\bar r_2^{-1}\bar a^2\bar\sigma(\bar a)\right)=0
 \subset\mathbf P(\ell),                                \tag{5.2}
\]

because trace, multiplication, `sigma`, and the unit coefficient all reduce
through the unramified integral model.

Properness gives specialization of every `F`-point, and smooth Hensel lifting
gives the converse.  Therefore there is an exact equivalence

\[
 X_T(F)\ne\varnothing
 \quad\Longleftrightarrow\quad
 \overline X_\Delta(k)\ne\varnothing.                   \tag{5.3}
\]

In the only unresolved case `[bar b] != 0`, (5.2) is a genuine `F55` twist
over a field of transcendence degree three.  It is not a split cubic, a
value-group initial form, or a bounded-support approximation.

## 6. Consequence of finite-place matching

Theorem 5.3 of `UNIT_RESIDUE_TOROIDAL` simultaneously matches the actual
coefficient class at any finite family of split places by one globally
soluble coefficient.  This covers every finite toric-boundary ledger.
Theorem 5.4 does the same for any finite family of nonsplit places at which
the actual cubic is already known to have dense local points.

Thus separate conditions at finitely many already-soluble completions cannot
prove pointlessness of the actual coefficient.  A local proof must produce
one interior divisor with nonzero residue Kummer class for which the complete
smooth cubic (5.2) is pointless.  No such divisor is presently known.

## Exact status

```text
ALL-SPLIT-DIVISORIAL-PLACES-DENSELY-SOLUBLE
ALL-TORIC-BOUNDARY-DIVISORIAL-PLACES-SPLIT-AND-SOLUBLE
ALL-RAMIFIED-F55-TORSOR-PLACES-SOLUBLE
ALL-PROPER-DECOMPOSITION-PLACES-SOLUBLE
FULL-DECOMPOSITION-IMPLIES-UNRAMIFIED-INTERIOR
UNRAMIFIED-FULL-F55-LOCAL-POINT-IFF-RESIDUE-POINT
FINITE-SOLUBLE-PLACE-LEDGERS-CANNOT-DISTINGUISH-THE-COEFFICIENT
NO-ANALYTICALLY-FORCED-BAD-COMPLETION-FOUND
F55-GLOBAL-QUESTION-OPEN
```
