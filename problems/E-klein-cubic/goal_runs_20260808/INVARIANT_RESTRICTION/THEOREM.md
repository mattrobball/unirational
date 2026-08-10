# Invariant-section and selfmap audit for a hypothetical `F55` compression

**Date:** 2026-08-08  
**Group:** `G=F55=C_11 semidirect C_5`  
**Verdict:** a high-degree invariant section can be forced to dominate, but
the source Klein cubic cannot; selfmap rigidity gives no contradiction

Assume hypothetically that

\[
 f_0:\mathbf P(W)\dashrightarrow X
 \tag{0.1}
\]

is a dominant `G`-equivariant rational map to the Klein cubic.  Choose an
equivariant resolution

\[
 \pi:Z\longrightarrow\mathbf P(W),\qquad f:Z\longrightarrow X.
 \tag{0.2}
\]

Let `Gamma` be the generic curve fibre of `f` and put

\[
 a=\deg_\Gamma\pi^*O_{\mathbf P(W)}(1)>0.
 \tag{0.3}
\]

The inequality is strict: otherwise `pi` would contract the generic fibre,
so the birational map `pi` would be generically constant along a
one-dimensional fibration and could not have four-dimensional image.

## 1. A controlled invariant hypersurface does dominate

The invariant linear system

\[
 H^0(\mathbf P(W),O(55))^G
 \tag{1.1}
\]

is basepoint-free.  Indeed, for any point `x`, choose a hyperplane `ell=0`
avoiding the finite orbit `Gx`; then

\[
 s_x=\prod_{g\in G}g\ell
 \tag{1.2}
\]

is an invariant degree-55 section nonzero at `x`.

There are only finitely many centers in (0.2).  A general invariant member
`D` of (1.1) contains none of them.  By Bertini it is smooth, and its strict
transform has class `55 pi^*H` with no exceptional subtraction.  Hence

\[
 \widetilde D\cdot\Gamma=55a>0.
 \tag{1.3}
\]

It follows that `f|_(D)` is dominant and generically finite after resolution.
Thus invariant slicing itself is available.  Its price is decisive:

\[
 K_D=O_D(50),
 \]

so `D` is a general-type threefold, not another rational source and not the
Klein cubic.  Equal-dimensional degree formulas applied to this slice do not
recover the desired compression obstruction.

## 2. The complete stable-cubic system

Let the `C_11` weights be

\[
 q_i=(-2)^i=(1,9,4,3,5)\pmod {11}.
\]

Among all degree-three monomials, the only weight-zero ones are

\[
 M_i=x_i^2x_{i+1},\qquad i\in\mathbf Z/5.
 \tag{2.1}
\]

Consequently the `C_11`-invariant cubic space is the regular representation
of `C_5`, and its five semi-invariant eigenlines are

\[
 F_c=\sum_{i=0}^4\zeta_5^{ci}x_i^2x_{i+1},
 \qquad c=0,1,2,3,4.
 \tag{2.2}
\]

Their zero loci are exactly the five `F55`-stable smooth cubics appearing in
Cheltsov--Krylov--Ma'u; diagonal changes of coordinates identify all five
with the Klein cubic.

The common reduced base locus of (2.2) is

\[
 C=\bigcup_{i\in\mathbf Z/5}
 \langle p_i,p_{i+2}\rangle.
 \tag{2.3}
\]

Indeed, all `M_i` vanish precisely when the nonzero coordinate support is an
independent set in the five-cycle, hence has size at most two and, in size
two, consists of non-neighbors.  The five lines in (2.3) form a pentagon;
therefore

\[
 \deg C=5,\qquad p_a(C)=1.
 \tag{2.4}
\]

This is not a harmless coordinate boundary.  It is exactly the pentagon
curve used as the base center of the explicit `F55`-Sarkisov link from the
Klein cubic to its genus-eight degree-14 Fano twin.

## 3. Exact dominance criterion for the source Klein cubic

For every exceptional divisor `E_nu` in (0.2), let

\[
 e_\nu=E_\nu\cdot\Gamma
\]

when `E_nu` dominates `X`, and put `e_nu=0` otherwise.  Let `c_nu` be the
successive multiplicity of the source Klein equation along its center.
Then

\[
 \widetilde X_{\rm source}\cdot\Gamma
   =3a-\sum_\nu c_\nu e_\nu\ge0.
 \tag{3.1}
\]

The restriction of (0.1) to the source Klein cubic is dominant exactly when
the right side is positive.  If it is zero, every intersection with the
generic fibre has been absorbed by horizontal exceptional multisections and
the strict transform is vertical.

Neither dominance of (0.1), primitivity of its five coordinates, nor the
landing identity gives a known inequality

\[
 \sum_\nu c_\nu e_\nu<3a.
 \tag{3.2}
\]

The fixed vertices from `EQUIVARIANT_LOCALIZATION` and the pentagon (2.3)
are genuine invariant centers on which `c_nu>0`.  Thus replacing a general
degree-55 member by the Klein cubic silently discards the exceptional term
that decides (3.1).

There is also no positivity-only repair.  On an abstract generic fibre
`Gamma=P^1`, choose five distinct marked points and five sections of
`O_P1(3a)`, each vanishing entirely at one marked point.  They have no common
zero and define a nonconstant map to `P4`, while every one of the five
coordinate hyperplane intersections is supported on the marked exceptional
multisections.  This is the exact intersection-theoretic configuration in
which all five eigencubics are vertical.  It is not asserted to lift to a
landing covariant; it shows that ampleness, positivity, and the five-section
decomposition alone cannot prove (3.2).

## 4. Why selfmap rigidity stops

Suppose, as an extra hypothesis, that the restriction

\[
 \varphi:X\dashrightarrow X
 \tag{4.1}
\]

is dominant.

1. **Basepoint-free case.** If (4.1) is a morphism, Beauville's theorem on
   endomorphisms of smooth hypersurfaces says that a smooth hypersurface of
   degree greater than two and dimension greater than one has no endomorphism
   of degree greater than one.  Thus `varphi` is an automorphism.

2. **Birational-superrigidity case.** The full
   `PSL_2(F_11)` action on the Klein cubic is equivariantly birationally
   superrigid.  This controls equivariant **birational** selfmaps, not a
   generically finite rational map of degree greater than one.

3. **The actual subgroup is the exceptional case.** For
   `G=F55`, Cheltsov--Krylov--Ma'u's main criterion explicitly excludes
   `C_11 semidirect C_5` from the rigid cases.  Their Theorem 12 constructs
   an `F55`-equivariant Sarkisov link

   \[
   X\dashrightarrow Y_{14}
   \tag{4.2}
   \]

   with base curve precisely (2.3), and proves that `X` is not
   `F55`-birationally rigid.  Hence the proposed `F55` superrigidity input is
   false, not merely insufficient.

4. **Rational selfmaps with base locus.** Beauville's theorem does not apply
   to rational selfmaps.  Resolving (4.1) introduces curve centers and their
   `H^1` contributions.  The induced `F55`-endomorphism on the original
   `H^3(X)` factor is scalar by Schur's lemma, but the projection formula is
   accompanied by the exceptional channels; it does not force degree one or
   an integral retraction.  Smooth cubic threefolds also have large groups of
   birational selfmaps, so ordinary cubic geometry supplies no substitute.

Thus even the additional dominance of (4.1) would leave precisely the hard
case: an ambient-extendable `F55`-equivariant rational selfmap with a
nonempty invariant base ideal.  Classifying that ideal is equivalent in
strength to the unresolved landing problem.

## 5. Exact stop

```text
F55-DEGREE55-INVARIANT-SLICE-DOMINATES
F55-STABLE-CUBICS-ARE-FIVE-EIGENLINES-WITH-PENTAGON-BASE
F55-KLEIN-RESTRICTION-DOMINANCE-REQUIRES-NEW-BASE-INEQUALITY
F55-BIRATIONAL-SUPERRIGIDITY-INPUT-IS-FALSE
F55-BASEPOINTFREE-SELF-ENDOMORPHISM-BRANCH-EMPTY
F55-AMBIENT-RATIONAL-SELFMAP-BRANCH-OPEN
F55-GLOBAL-QUESTION-OPEN
```

## Primary sources

* A. Beauville, *Endomorphisms of hypersurfaces and other manifolds*,
  <https://arxiv.org/abs/math/0008205>.
* I. Cheltsov, I. Krylov, S. Ma'u, *G-birationally rigid cubic
  threefolds*, especially Theorem 3 and Theorem 12,
  <https://arxiv.org/abs/2604.20426>.
* J. Blanc, S. Lamy, *On birational maps from cubic threefolds*,
  <https://www.algebra.dmi.unibas.ch/blanc/articles/cubicthreefolds.pdf>.
