# Theorem: a rational conic-bundle threefold with a ruled central fixed divisor

## Statement

Let

\[
p:\mathbb F_1=\mathbf P_{\mathbf P^1}
(\mathcal O\oplus\mathcal O(1))\longrightarrow\mathbf P^1
\]

be the first Hirzebruch surface.  Let `S3=D6` act on the base by

\[
r[x:y]=[\omega x:y],\qquad s[x:y]=[y:x],
\]

using the standard two-dimensional linear lift to linearize `O(1)`.  Put

\[
L=p^*\mathcal O(3),\qquad f=p^*(x^6+y^6),
\]

and

\[
X=\{uv=f w^2\}\subset
\mathbf P_{\mathbb F_1}(L\oplus L\oplus\mathcal O).
\]

Let `z` exchange `u` and `v`, and set

\[
G=\langle z\rangle\times S_3\simeq C_2\times S_3.
\]

Then:

1. `X` is a smooth rational projective threefold with a faithful `G`-action;
2. `X^A` is nonempty for every abelian subgroup `A <= G`;
3. every Sylow subgroup has a fixed point;
4. `X` is not weakly `G`-versal and hence not `G`-unirational;
5. the proof uses a central fixed divisor containing infinitely many rational curves.

Moreover, the relative `G`-invariant Neron-Severi space is one-dimensional: the central involution exchanges the two component classes over every discriminant component.  Thus the associated relative equivariant MMP is a `G`-Mori conic-bundle model.

## Proof

### Smoothness and rationality

The zero divisor of `f` is the disjoint union of six ruling fibers of `F_1`, each with multiplicity one.  Locally transverse to one such fiber the equation is

\[
uv=t w^2.
\]

The total space is smooth by the same Jacobian calculation as in the surface theorem.  The sections `[1:0:0]` and `[0:1:0]` split the generic conic.  Since the base `F_1` is rational, `X` is rational.

### Central fixed divisor

The fixed locus of `z` is

\[
T=X^z:\quad q^2=f.
\]

Let

\[
C:\ q^2=x^6+y^6.
\]

Then

\[
T\simeq\mathbb F_1\times_{\mathbf P^1}C.
\]

Thus `T -> C` is a projective-line bundle and `g(C)=2`.  In particular `T` contains a full ruling of rational curves.

### Residual action

The residual `S3` action on `C` has no common fixed point: the rotation fixes `0,infinity` and the reflection exchanges them.  Therefore

\[
C^{S_3}=\varnothing.
\]

Every RCC subvariety of `T` maps to a point under `T -> C`.  If such a subvariety were `S3`-stable, its image would be an `S3`-fixed point of `C`, impossible.  Hence `T` contains no positive-dimensional `S3`-stable RCC subvariety.

Any full `G`-fixed point of `X` would lie in `T` and project to `C^{S3}`, so

\[
X^G=\varnothing.
\]

The residual-stable RCC obstruction of `GENERALIZATIONS.md` now excludes every equivariant rational map from a faithful linear source.  Thus `X` is not weakly `G`-versal.

### Condition (A)

Let `A <= G` be abelian and let `B` be its projection to `S3`.  Then `B` is cyclic.  The surface theorem gives a point `c in C^B`.  The ruling fiber `T_c=P1` is `A`-stable; the action on it factors through a cyclic finite group and hence has a fixed point.  The central involution is trivial on `T`.  Therefore `X^A` is nonempty.

The same witnesses apply to Sylow 2- and 3-subgroups, so the usual Amitsur and higher-Amitsur audits vanish.

### Relative `G`-Mori property

Over each of the six discriminant fibers, the conic splits into two components, one in `u=0` and one in `v=0`.  Their numerical difference is anti-invariant under `z`; their sum is the pullback of the discriminant fiber.  Hence these reducible fibers contribute no new `G`-invariant relative numerical class.  The relative hyperplane class spans

\[
N^1(X/\mathbb F_1)^G.
\]

Relative anticanonical degree is positive on the conic fibers.  Running the relative `G`-MMP therefore retains the displayed conic-bundle contraction as a `G`-Mori model.  QED.

## Significance

The fixed divisor contains many rational curves, so the original central theorem cannot be quoted.  The proof is the first application in this packet that genuinely uses the stronger residual-RCC/MRC formulation.
