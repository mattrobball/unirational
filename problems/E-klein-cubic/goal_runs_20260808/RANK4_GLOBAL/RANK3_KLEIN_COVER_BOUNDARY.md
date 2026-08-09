# The residue-rank-three cover is the Klein cubic torus

**Date:** 2026-08-08  
**Scope:** the full cyclic-span-four branch with
`S=ker(mu)` and hence `A=<mu>`  
**Verdict:** exact identification, not an exclusion; the `F55` question is
still open

This note records the stopping boundary after the Kummer--Newton reduction.
When the incidence space has its maximal possible rank three, its sole
Kummer character does not produce a new cover of the trace hyperplane.  It
reconstructs the familiar degree-eleven monomial cover by the Klein cubic.

## 1. Exact lattice identification

Let

\[
 T_x=T_y=(\mathbf G_m^5)/\mathbf G_m,
 \qquad
 \Lambda=X^*(T_y)=\{n\in\mathbf Z^5:\sum n_i=0\}.
\]

On the dense coordinate torus define

\[
 \varphi:T_x\longrightarrow T_y,
 \qquad y_j=x_j^2x_{j+1}.                              \tag{1.1}
\]

Its pullback on characters is

\[
 (Cn)_k=2n_k+n_{k-1}.                                  \tag{1.2}
\]

The determinant of `C` on `Lambda` is eleven.  Put

\[
 \mu=(1,5,3,4,9)\pmod {11},
 \qquad \widetilde\mu=(1,5,3,4,-13)\in\Lambda.
\]

Then

\[
 C\widetilde\mu=11(-1,1,1,1,-2).                     \tag{1.3}
\]

Consequently

\[
 C^{-1}\Lambda
   =\Lambda+\mathbf Z{\widetilde\mu\over11}.          \tag{1.4}
\]

The right side is exactly the character lattice `Lambda_<mu>` used to
define the Kummer cover in `KUMMER_NEWTON_REDUCTION.md`.  Therefore the
degree-eleven cover attached to `A=<mu>` is, as a torus cover,

\[
 T_{\langle\mu\rangle}\longrightarrow T_y
 \simeq
 T_x\mathrel{\mathop{\longrightarrow}^{\varphi}}T_y.   \tag{1.5}
\]

This also fixes the possible orientation ambiguity: cyclic rotation sends
`mu` to a nonzero scalar multiple of itself, so either convention for the
shift gives the same character line.

## 2. Pulling back the trace hyperplane

Let

\[
 H^\circ=\{[y]\in T_y:\sum_jy_j=0\}.
\]

By literal substitution in (1.1),

\[
 Y_{\langle\mu\rangle}
   =\varphi^{-1}(H^\circ)
   =\{[x]\in T_x:\sum_jx_j^2x_{j+1}=0\}
   =X_{\rm Klein}^\circ.                              \tag{2.1}
\]

Thus the only cover left by residue rank three is the dense-torus open of
the Klein cubic itself.  Its natural coordinate-boundary incidence already
has this rank: along `x_i=0`, away from the other coordinate hyperplanes,
the two affected monomials have multiplicities `2` and `1`.  The five cyclic
translates of

\[
 (2,0,0,0,1)                                           \tag{2.2}
\]

span a four-dimensional subspace of `F_11^5` containing the diagonal;
their image in `V=F_11^5/F_11(1,1,1,1,1)` is precisely the
three-dimensional hyperplane `ker(mu)`.

## 3. The special multiplicative lift is tautological here

Suppose the trace coordinates have the special form

\[
 b_j=c_j a_j^2a_{j+1},
 \qquad c_j=\sigma^j(r_2^{-1}),
 \qquad \sum_jb_j=0.                                  \tag{3.1}
\]

In the fixed degree-eleven layer `L/E` of the authoritative trace model
there are conjugates `beta_j` satisfying

\[
 \beta_j^2\beta_{j+1}=c_j.                             \tag{3.2}
\]

Putting `x_j=beta_j a_j` gives

\[
 b_j=x_j^2x_{j+1},\qquad [x]\in X_{\rm Klein}^\circ(L). \tag{3.3}
\]

Equivalently, for the sum-zero lift `widetilde mu`,

\[
 \prod_j(a_j^2a_{j+1})^{\widetilde\mu_j}
   =\left(\prod_k a_k^{(C\widetilde\mu)_k/11}\right)^{11}. \tag{3.4}
\]

So the special factorization supplies exactly the one Kummer root defining
(2.1); it is not extra ramification or a second cover.  A common projective
factor in `b_j=QH_j` cancels from (3.4) because
`sum widetilde(mu)_j=0`.

The coefficient also disappears after the same fixed source isogeny used in
the Kummer lifting lemma.  Indeed, with

\[
 d=r_1r_2^6r_3^{-2}r_4^2,
 \qquad \psi(d)=d^2\sigma(d)=r_2^{11},                 \tag{3.5}
\]

pullback by `[11]` sends `c=r_2^{-1}` to
`r_2^{-11}=psi(d^{-1})`.  It can then be absorbed into `a`.  This explains
why divisor and cover calculations after `[11]` see only the ordinary Klein
cover.

## 4. Why canonical, ramification, and logarithmic arguments stop

The map (1.1) is finite etale of degree eleven on the tori, but its
projective extension has coordinate-boundary base strata and contracted
divisors.  A finite-morphism Hurwitz formula cannot be applied directly to
that rational compactification map.

More decisively, the smooth compactification in (2.1) is the cubic
threefold itself, with

\[
 K_X=\mathcal O_X(-2).                                 \tag{4.1}
\]

It has no nonzero regular pluricanonical forms and is ordinarily unirational
over `C`.  Hence no obstruction to domination by a rational variety can
come from the canonical class, a regular residue form, or the geometry of
the cover `Y_<mu>` alone.  Logarithmic forms on the torus acquire boundary
poles; resolving the rational compactification map supplies exactly the
boundary and discrepancy terms omitted by a naive toric Hurwitz count.

What remains is the semilinear descent condition.  An arbitrary dominant
rational map to the ordinary Klein cover does not ensure that its
coordinates can be written as `x_j=beta_j sigma^j(a)` for one `a in E`,
with the prescribed `C_5` action.  Requiring that descent is precisely the
original gate

\[
 r_2^{-1}\psi(E^*)\cap\ker(\operatorname {Tr}_{E/K})
 \ne\varnothing.                                      \tag{4.2}
\]

When `S=ker(mu)`, valuations have exhausted their information: the
annihilator contains no character beyond `mu`.  Any further obstruction
must therefore retain the global additive equation together with the
prescribed unit/Kummer descent class.  Rephrasing that datum as a lift to
`Y_<mu>` does not simplify it; it is the original `F55` trace problem.

```text
RANK4-RANK3-KUMMER-COVER-IS-KLEIN-TORUS
RANK4-RANK3-SPECIAL-LIFT-IS-TAUTOLOGICAL
RANK4-RANK3-SEMILINEAR-DESCENT-IS-ORIGINAL-GATE
RANK4-RANK3-BRANCH-OPEN
F55-GLOBAL-QUESTION-OPEN
```
