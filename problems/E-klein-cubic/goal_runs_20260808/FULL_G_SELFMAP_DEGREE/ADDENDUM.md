# Full-`G` ambient selfmaps: the `H^3` carrier boundary

**Date:** 2026-08-08  
**Group:** `G = PSL_2(F_11)`  
**Variety:** the Klein cubic threefold `X` in `P(W)=P^4`  
**Verdict:** a dominant restriction gives an injective pullback on a
resolution, but its whole image may lie in exceptional curve-centre
cohomology.  Full-`G` equivariance and the source-cubic inclusion do not
bound those carriers.  No theorem-level exclusion of degree greater than one
results.

## 1. The two pullbacks that must not be confused

Let

\[
 f:\mathbf P^4\dashrightarrow X
\]

be a hypothetical dominant `G`-map, let `g:Z -> X` resolve it, and suppose
that the strict transform `D` of the source Klein cubic maps generically
finitely to `X`.  Write

\[
 p:D\longrightarrow X,\qquad q=g|_D:D\longrightarrow X,
 \qquad \delta=\deg(q)>0.
\]

After making `D` smooth, the morphism pullback

\[
 q^*:H^3(X,\mathbf Q)\longrightarrow H^3(D,\mathbf Q)
 \tag{1.1}
\]

is injective, since `q_*q^*=delta id`.  This does **not** imply that the
rational-correspondence action

\[
 p_*q^*:H^3(X,\mathbf Q)\longrightarrow H^3(X,\mathbf Q)
 \tag{1.2}
\]

is nonzero.  The image of (1.1) may be contained entirely in the exceptional
summands for `p`.

The ambient map makes this possibility especially natural.  Since
`H^3(P^4,Q)=0`, the group `H^3(Z,Q)` is built from the `H^1` of curve and
surface centres in the resolution.  Restricting to `D` does not, in general,
remove those summands.

## 2. Clean-blowup restriction lemma

Let `Y` be a smooth fourfold, `D_0` a smooth divisor, and `C` a smooth centre
of codimension at least two meeting `D_0` cleanly.  Put

\[
 \widetilde Y=\operatorname{Bl}_C(Y),\qquad
 \widetilde D_0=\text{the strict transform of }D_0.
\]

The degree-three part of the blowup formula contains

\[
 H^1(C,\mathbf Q)(-1)\subset H^3(\widetilde Y,\mathbf Q).
 \tag{2.1}
\]

Functoriality of the exceptional-divisor construction gives the following.

1. If `C` is a curve not contained in `D_0`, then `C cap D_0` is finite and
   (2.1) restricts to zero on `\widetilde D_0`.
2. If `C` is a surface not contained in `D_0`, then (2.1) restricts through
   `H^1(C) -> H^1(C cap D_0)` and can be nonzero.
3. If `C` is a curve contained in `D_0`, then (2.1) maps to the corresponding
   exceptional `H^1(C)(-1)` summand of
   `H^3(Bl_C(D_0))`.

Thus the useful vanishing for transverse curve centres does not propagate
through an arbitrary resolution.  Surface centres and infinitely-near curve
centres remain legal carrier channels.

## 3. Exact full-`G` carrier tower over a free orbit

The failure is realized by a smooth equivariant blowup tower, not merely by a
formal representation count.

Choose a point `x in X` with trivial stabilizer and let

\[
 O=Gx,\qquad |O|=660.
\]

Such points form a dense open subset of `X`.  Blow up `O` in `P^4`:

\[
 Y_1=\operatorname{Bl}_O(\mathbf P^4),\qquad
 D_1=\operatorname{Bl}_O(X).
\]

Over each point of `O`, the ambient exceptional divisor is `P^3` and its
intersection with `D_1` is a plane `P^2`.

Let

\[
 E_{11}=\mathbf C/\mathbf Z\left[\frac{-1+\sqrt{-11}}2\right].
\]

Write `E_11` as `t^2=Delta(x,z)` for a squarefree binary quartic `Delta`.
Inside one exceptional plane choose the smooth plane quartic

\[
 B:\quad y^4=\Delta(x,z).
 \tag{3.1}
\]

The involution `y -> -y` has quotient `E_11`, so `H^1(E_11,Q)` is a Hodge
summand of `H^1(B,Q)`.  Let

\[
 C=\coprod_{g\in G}gB\subset D_1.
\]

The components are disjoint because they lie over the free orbit `O`.  Blow
up this smooth disconnected `G`-centre:

\[
 Y_2=\operatorname{Bl}_C(Y_1),\qquad
 D_2=\operatorname{Bl}_C(D_1).
\]

The blowup formula gives `G`-equivariant decompositions

\[
 H^3(Y_2,\mathbf Q)=H^1(C,\mathbf Q)(-1),
 \tag{3.2}
\]

\[
 H^3(D_2,\mathbf Q)=H^3(X,\mathbf Q)
       \mathbin\oplus H^1(C,\mathbf Q)(-1),
 \tag{3.3}
\]

and restriction from (3.2) identifies it with the second summand of (3.3).
Moreover,

\[
 H^1(C,\mathbf Q)\simeq \mathbf Q[G]\otimes H^1(B,\mathbf Q).
 \tag{3.4}
\]

Roulleau's period calculation gives `J(X) isomorphic to E_11^5` as an
unpolarized abelian variety.  Hence there is a nonzero Hodge map
`H^3(X,Q)(1) -> H^1(B,Q)`.  Inducing from the trivial stabilizer, or
explicitly averaging

\[
 v\longmapsto \sum_{g\in G} i(g^{-1}v)\otimes e_g,
 \tag{3.5}
\]

produces a nonzero `G`-equivariant Hodge map from `H^3(X,Q)(1)` into
`H^1(C,Q)`.  Since the rational `G`-module `H^3(X,Q)` is simple, (3.5) is
injective.  Averaging a polarization gives the required positive rational
multiple of the invariant polarization.

Consequently all `H^3`, intermediate-Jacobian, and rational-polarization data
forced by a generically finite restriction can be carried by infinitely-near
centres over a free orbit.  These centres project to points of the original
`X`; they do not yield a bounded `G`-stable carrier curve on `X`.

This tower is not claimed to resolve a landing covariant.  Its precise force
is negative: cohomology, equivariance, and compatibility with the source
cubic alone cannot prove that such a covariant does not exist.  The actual
base ideal and the identity `F(T)=0` would have to exclude the tower.

## 4. Why degree greater than one is still open

Three standard inputs stop at strictly weaker boundaries.

* Beauville excludes endomorphisms of a smooth cubic threefold of degree
  greater than one only when the selfmap is a morphism.
* Full-`G` birational superrigidity controls `G`-equivariant **birational**
  selfmaps.  It does not turn a generically finite rational selfmap into a
  birational one.
* The intermediate Jacobian supplies an injective map into the cohomology of
  a resolution, but Section 3 shows that the exceptional carrier can contain
  the complete full-`G` Hodge structure.

There is also an exact nonequivariant sanity check.  Every smooth complex
cubic threefold admits a degree-two unirational parametrization
`u:P^3 --> X`.  Projection from a point `x in X` gives a degree-two rational
map `pi_x:X --> P^3`, induced by the ambient linear projection
`Pi_x:P^4 --> P^3`.  Therefore

\[
 u\circ\Pi_x:\mathbf P^4\dashrightarrow X
\]

restricts to the degree-four rational selfmap `u o pi_x` of `X`.  Its
pullback on a resolution is carried through the exceptional cohomology of a
resolution of `u`; one must not replace that resolution by `P^3` and declare
the pullback zero.  Thus ambient extendability and nonzero morphism pullback
do not, even for a cubic threefold, force degree one.  This example is not
`G`-equivariant; that missing symmetry is exactly the unresolved input.

For any fixed homogeneous degree `d`, the conditions

\[
 T\in\operatorname{Hom}_G(\operatorname{Sym}^dW,W),\qquad F(T)=0
\]

form a finite CAS target.  But this is the original landing scheme in degree
`d`.  Neither the argument above nor birational superrigidity supplies an
upper bound for `d`.  Replacing the ambient identity by the weaker selfmap
condition `F(T) in (F)` also gives only a degree-by-degree target and cannot
close the headline.

## 5. Exact stop

```text
FULL-G-RESTRICTION-MORPHISM-PULLBACK-INJECTIVE
FULL-G-RATIONAL-H3-ACTION-MAY-VANISH
FULL-G-FREE-ORBIT-INFINITELY-NEAR-CARRIERS-UNBOUNDED
FULL-G-INTERMEDIATE-JACOBIAN-DOES-NOT-FORCE-DEGREE-ONE
FULL-G-BIRATIONAL-SUPERRIGIDITY-DOES-NOT-EXCLUDE-DEGREE-GT-ONE
FULL-G-FIXED-DEGREE-SELFMAP-CAS-HAS-NO-THEOREM-FORCED-CUTOFF
FULL-G-AMBIENT-RATIONAL-SELFMAP-DEGREE-GT-ONE-OPEN
```

## Sources

* X. Roulleau, *The Fano surface of the Klein cubic threefold*,
  <https://arxiv.org/abs/1001.4853>.
* A. Beauville, *Endomorphisms of hypersurfaces and other manifolds*,
  <https://arxiv.org/abs/math/0008205>.
* I. Cheltsov, I. Krylov, S. Ma'u, *G-birationally rigid cubic
  threefolds*, <https://arxiv.org/abs/2604.20426>.
