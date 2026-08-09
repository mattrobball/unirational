# The Pfaffian kernel fibre forces degree four

Date: 2026-08-08

## 1. Setup and outcome

Let

\[
G=\operatorname{PSL}_2(\mathbf F_{11})
\]

and let \(T\) be the genuine generic \(G\)-torsor obtained from a
generically free honest linear representation.  Write \(K\) for its field
and

\[
\beta=\partial(T)\in\operatorname{Br}(K)[2]
\]

for the nonzero Schur class.  Let \(Y_T\) be the twisted Klein cubic and
\(X_T\) the twisted orthogonal \(V_{14}\).  Let \(C_\beta\) be the nonsplit
conic of class \(\beta\).

The Pfaffian--Grassmannian flop gives the following strengthening of the
Schur-conic criterion.

### Theorem 1.1 (degree-four replacement)

In the genuine generic situation above,

\[
\boxed{
Y_T(K)\ne\varnothing
\quad\Longleftrightarrow\quad
\operatorname{Mor}_K(C_\beta,X_T)_{H\text{-degree }4}\ne\varnothing .}
\]

Here \(H=-K_{X_T}\) is the descended Plücker polarization and the degree
is geometric degree after base change to an algebraic closure.

Consequently every Schur-conic curve of arbitrary even degree whose
existence is equivalent to a point of \(Y_T\) can be replaced by a
\(\beta\)-normalized rational quartic.  Thus the all-degree Schur-conic
gate is exactly its first surviving degree-four case.

This is a reduction, not an exclusion: the existence or nonexistence of
that quartic remains equivalent to the open Klein-cubic point problem.

## 2. The canonical kernel-fibre map

Use the equivariant Pfaffian data

\[
f:A\hookrightarrow\bigwedge^2 U^*,\qquad \dim A=5,\quad \dim U=6,
\]

with

\[
Y=\mathbf P(f(A))\cap\operatorname{Gr}(2,U)^\vee,
\qquad
X=\mathbf P(f(A)^\perp)\cap\operatorname{Gr}(2,U).
\]

Let \(E^\vee\) be the rank-two kernel bundle on \(Y\) and \(\mathcal U\)
the tautological rank-two bundle on \(X\).  Tschinkel--Zhang and
Kuznetsov give the canonical equivariant diagram

\[
\mathbf P_Y(E^\vee)\dashrightarrow\mathbf P_X(\mathcal U),
\]

whose two sides contract to the same quartic hypersurface
\(Q\subset\mathbf P(U)\).  Away from the ruled surfaces over
\(\operatorname{Sing}(Q)\), the map sends

\[
(y,[v]),\qquad 0\ne v\in\ker f(y),
\]

to the unique two-plane \(\ell_v\in X\) containing \(v\).

The construction is \(\widetilde G=\operatorname{SL}_2(\mathbf F_{11})\)-
equivariant before projectivization and \(G\)-equivariant after
projectivization.  It therefore twists by \(T\).  If
\(y\in Y_T(K)\), its projective kernel fibre is

\[
\mathbf P(E_y^\vee)\simeq C_\beta.
\]

Indeed the central involution acts on the fibres through the scalar
character of the six-dimensional spin representation, so the fibre has
Brauer class \(\partial(T)=\beta\) (the inverse class is the same because
\(\beta\) is two-torsion).

## 3. Choosing a fibre disjoint from the exceptional locus

Let \(\Gamma=\operatorname{Sing}(Q)\).  The exceptional locus on
\(\mathbf P_Y(E^\vee)\) is a ruled surface over \(\Gamma\).  Its image
\(B\subset Y\) is therefore a proper closed subset of dimension at most
two.  Equivalently, for \(y\in Y\setminus B\), the projective kernel line

\[
L_y=\mathbf P(\ker f(y))
\]

is disjoint from \(\Gamma\).

Suppose \(Y_T(K)\ne\varnothing\).  A smooth cubic hypersurface of
dimension at least two over an infinite field is unirational as soon as it
has a rational point (the classical tangent--secant construction).
Consequently \(Y_T(K)\) is Zariski dense.  We may therefore choose

\[
y\in (Y_T\setminus B_T)(K).
\]

For this choice the Pfaffian flop is defined at every point of the conic
fibre \(C_\beta=\mathbf P(E_y^\vee)\), and gives a morphism

\[
C_\beta\longrightarrow X_T.
\]

## 4. Exact Plücker-degree bound

The degree calculation is elementary and does not use the no-name lemma.
Work over a splitting field and represent \(y\) by \(a_0\in A\).  Choose
a basis \(a_0,a_1,\ldots,a_4\) of \(A\), and a basis \(v_0,v_1\) of

\[
K_y=\ker f(a_0).
\]

For \(v=sv_0+tv_1\), form the \(4\times6\) contraction matrix

\[
M_y(s,t)=\bigl(f(a_i)(v,-)\bigr)_{i=1}^4.
\]

Every entry is linear in \(s,t\).  Our choice of \(y\) makes this matrix
rank four for every \((s:t)\in L_y\), and

\[
\ell_v=\ker M_y(s,t)\subset U.
\]

There is also an exact bundle calculation which proves that no common
factor occurs.  On \(L_y\simeq\mathbf P^1\), contraction gives a
surjection

\[
U\otimes\mathcal O_{L_y}
\longrightarrow
(A/Ka_0)^*\otimes\mathcal O_{L_y}(1).
\]

Let \(F\) be its rank-two kernel.  It has degree \(-4\), and the
tautological vector \(v\) gives a subbundle
\(\mathcal O_{L_y}(-1)\subset F\).  The quotient is therefore
\(\mathcal O_{L_y}(-3)\).  Since

\[
\operatorname{Ext}^1(\mathcal O(-3),\mathcal O(-1))
=H^1(\mathbf P^1,\mathcal O(2))=0,
\]

we obtain

\[
F\simeq\mathcal O_{\mathbf P^1}(-1)
\oplus\mathcal O_{\mathbf P^1}(-3).
\]

This is precisely the pullback of the tautological bundle on
\(\operatorname{Gr}(2,U)\).  Hence

\[
(C_\beta\to X_T)^*H
=\det(F^*)=\mathcal O_{\mathbf P^1}(4)
\]

after geometric base change.  Equivalently, the Plücker coordinates are
the complementary \(4\times4\) minors of \(M_y(s,t)\), homogeneous
quartics with no common zero.

This calculation is intrinsic: changing the complement to \(Ka_0\), or
changing either basis, only performs invertible row and column operations
and a projective change of \((s:t)\).

## 5. Exact degree and the reverse implication

The bundle computation gives directly

\[
\boxed{\deg_H=4.}
\]

with geometric splitting type \((1,3)\).  Notice that the apparently odd
splitting type creates no descent contradiction: the tautological bundle
is \(\beta\)-twisted, while its projectivization and determinant descend.
This is the precise way in which the Schur class is compatible with the
quartic.

The same splitting also proves that this is not a multiple cover of a
curve of smaller degree.  Over an algebraic closure, factor the morphism
through the normalization of its image,

\[
\mathbf P^1\xrightarrow{h}\widetilde D\longrightarrow X,
\]

and let \(e=\deg(h)\).  If \(e>1\), then \(e\) divides the total
Plücker degree four.  Since \(\widetilde D\simeq\mathbf P^1\), write the
pullback of the tautological bundle to \(\widetilde D\) as

\[
\mathcal O(-a)\oplus\mathcal O(-b),\qquad a,b\geq0.
\]

Pullback by \(h\) would give
\(F\simeq\mathcal O(-ea)\oplus\mathcal O(-eb)\).  This cannot equal
\(\mathcal O(-1)\oplus\mathcal O(-3)\) for any \(e>1\).  Hence \(e=1\):
the image is a geometrically integral Plücker quartic and its
normalization is exactly \(C_\beta\).

This proves the forward implication of Theorem 1.1.  The reverse
implication is the already audited Schur-conic criterion: any
\(K\)-morphism \(C_\beta\to X_T\) gives an \(X_T(K(C_\beta))\)-point, and
the twisted stable Pfaffian--Grassmannian equivalence then gives
\(Y_T(K)\ne\varnothing\).

## 6. Relation to quartic Abel--Jacobi fibres

The degree-four replacement is compatible with, but stronger for this
purpose than, the classical Abel--Jacobi description.

For a general cubic threefold, Iliev--Markushevich identify a general
fibre of the Abel--Jacobi map from rational normal quartics as a smooth
threefold birational to an associated \(V_{14}\).  Li--Lin--Pertusi--Zhao
give a modern moduli-theoretic interpretation: for every smooth cubic,
the relevant Bridgeland moduli space is birational to the rational-quartic
Hilbert component, and its general Abel--Jacobi fibres are genus-eight
Fano threefolds.

Neither theorem controls the distinguished arithmetic fibre selected by
the generic \(G\)-twist.  Moreover, the Tregub--Takeuchi correspondence
sends a general point of an associated \(V_{14}\) to a rational quartic
on the cubic and carries its sixteen chords to sixteen conics through the
point.  The degree sixteen is even and supplies no odd-degree descent.
Thus Abel--Jacobi and chord arguments do not exclude the quartic obtained
above; they explain why degree four is the exact circular boundary.

## 7. Scope

No bounded search, finite-field specialization, or unbounded computer
algebra is used.  The only calculation is the forced \(4\times4\)-minor
degree count in Section 4.

The theorem does **not** prove the Klein cubic negative.  It replaces the
previous all-even-degree Schur-conic problem by the single exact question:

> Does the genuine generic twist \(X_T\) contain a geometrically integral
> anticanonical quartic whose normalization is the Schur conic
> \(C_\beta\)?
