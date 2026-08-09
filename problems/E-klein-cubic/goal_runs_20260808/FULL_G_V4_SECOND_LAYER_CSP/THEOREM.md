# The full-`G` `V4` second-layer character CSP is nonempty

**Date:** 2026-08-08

**Field:** \(\mathbf C\)

**Group:** \(G=\operatorname {PSL}_2(\mathbf F_{11})\)

**Verdict:** the theorem-forced tangent-character and incidence equalities on
the second `V4` exceptional layer have an exact `G`-compatible solution

This packet starts from the unique type-I state surviving the first exceptional
layer in `FULL_G_GRAPH_DEGREE_LOCALIZATION`.  It tests exactly one further
finite layer: tangent characters at the three exceptional sections, equality
of the two endpoint derivatives on every involution-fixed triangle edge, and
the identifications forced where the `V4` lines meet the deeper `D12` and `A4`
strata.

The resulting constraint system is **not empty**.  The solution below is a
finite character-and-equality counterconfiguration.  It is only formal
fixed-stratum/first-derivative data on the second exceptional layer.  It does
not construct a rational map, a landing covariant, a base ideal, a genuine
graph, or even a second-order landing jet.

## 1. Characters at a surviving type-I section

Fix \(V\cong V_4\), and denote its three nontrivial characters by

\[
 B=(1,0),\qquad C=(0,1),\qquad D=(1,1)
 \quad\text{in }\widehat V\cong\mathbf F_2^2.
 \tag{1.1}
\]

Thus multiplication of characters is addition in \(\mathbf F_2^2\); in
particular \(B+C=D\) and cyclically.  The ambient representation is

\[
 W|_V=A\oplus B\oplus C\oplus D,
 \qquad \dim A=2,
 \tag{1.2}
\]

and the pointwise fixed line is \(\ell_V=\mathbf P(A)\).  Blow up
\(\ell_V\).  At the generic point of the exceptional section \(S_i\)
corresponding to the normal direction \(i\in\{B,C,D\}\), the four tangent
characters are

\[
 1,\quad i,\quad j/i=k,\quad k/i=j,
 \qquad \{i,j,k\}=\{B,C,D\}.
 \tag{1.3}
\]

Hence

\[
 T_{S_i}\operatorname {Bl}_{\ell_V}\mathbf P(W)
 \cong 1\oplus B\oplus C\oplus D.
 \tag{1.4}
\]

In the unique surviving first-layer state, \(S_i\) maps to the type-I vertex
\(P_i\).  The exact target tangent representation is

\[
 T_{P_i}X\cong B\oplus C\oplus D.
 \tag{1.5}
\]

The \(i\)-line is tangent to the elliptic component \(E_{\sigma_i}\); the
other two character lines are tangent to the two rational triangle edges
through \(P_i\).  A `V`-equivariant first derivative must kill the trivial
source line and is diagonal on the other three character lines.

## 2. Exact nonempty solution

Order the nontrivial character lines as \((B,C,D)\).  Put

\[
 \boxed{\quad
  \lambda=1,\qquad \mu=0,\qquad
  D_i=I_3-E_{ii}\quad (i=B,C,D).
 \quad}
 \tag{2.1}
\]

Here the omitted trivial source column is zero.  Explicitly,

\[
 D_B=\operatorname {diag}(0,1,1),\qquad
 D_C=\operatorname {diag}(1,0,1),\qquad
 D_D=\operatorname {diag}(1,1,0).
 \tag{2.2}
\]

The scalar \(\mu=0\) is the derivative from the plus-plane direction to the
elliptic tangent at its matching vertex.  It is compatible with the fact that
a rationally connected plus-plane exceptional fiber, if regular, maps
constantly to the elliptic curve.  The two remaining entries are the common
edge scale \(\lambda=1\).

The residual quotient \(N_G(V)/V=C_3\) cyclically permutes \(B,C,D\), and
conjugation by this cycle sends

\[
 D_B\longmapsto D_C\longmapsto D_D\longmapsto D_B.
 \tag{2.3}
\]

Thus (2.1) is residual-`C3` equivariant.

## 3. Every involution-fixed edge equality is satisfied

For the involution \(\sigma_i\) whose plus character is \(i\), the rational
minus-line \(L_{\sigma_i}\) joins the other two vertices \(P_j,P_k\).  Its
tangent character at either endpoint is

\[
 k/j=j/k=i.
 \tag{3.1}
\]

Because \(i\ne j,k\), formula (2.1) gives

\[
 D_j|_i=D_k|_i=\lambda=1.
 \tag{3.2}
\]

Therefore the two endpoint jets glue to the identity first derivative on
\(L_{\sigma_i}\cong\mathbf P^1\).  This holds on all three edges and is
cyclically transported by the residual `C3`.  Transport by `G` gives the same
solution for every `V4` and every incident involution.

## 4. Compatibility at the `D12` meetings

Let \(c_{\sigma}\) be one of the deeper ambient points with stabilizer
\(D_{12}\), and write \(D_{12}/\langle\sigma\rangle\cong S_3\).  The exact
projective tangent representation has the form

\[
 T_{c_{\sigma}}\mathbf P(W)=U\oplus(\varepsilon U),
 \tag{4.1}
\]

where \(U\) is the irreducible standard two-dimensional representation of
\(S_3\), \(\varepsilon\) is the sign character, and

\[
 L_{\sigma}=\mathbf P(\varepsilon U).
 \tag{4.2}
\]

As `S3` representations, \(\varepsilon U\cong U\); the two summands in
(4.1) retain their geometric labels even though their abstract isomorphism
types agree.

The three `V4` lines through \(c_{\sigma}\) have mirror tangent directions
\(u_i\subset U\), permuted by `S3`.  After blowing up the point and then the
three line transforms, the relevant minus boundary over the direction \(u_i\)
is

\[
 \mathbf P\!\left(\operatorname {Hom}(u_i,\varepsilon U)\right)
 \cong \mathbf P(\varepsilon U)=L_{\sigma}.
 \tag{4.3}
\]

Tensoring by the one-dimensional space \(u_i^*\) gives the displayed
projective identification.  The three identifications are permuted by `S3`.
Moreover

\[
 \dim\operatorname {End}_{S_3}(U)=1,
 \tag{4.4}
\]

so their only common equality parameter is one scalar.  Choosing that scalar
to be \(\lambda=1\) is exactly (3.2).  Hence the three `V4` branches meeting at
each `D12` point impose no further inconsistency.  `G`-transport solves all 55
such configurations at once.

This is a statement about the projectivized boundary and its first derivative;
it does not claim that a regular local landing map exists across the whole
`D12` exceptional divisor.

## 5. Compatibility at the `A4` endpoints

At either `A4` endpoint of a `V4` line, the normal representation to that line
is the irreducible three-dimensional `A4` representation \(R\).  Its
restriction to `V4` is

\[
 R|_V=B\oplus C\oplus D.
 \tag{5.1}
\]

The tangent representation of the type-I triangle is the same \(R\).  Since

\[
 \dim\operatorname {End}_{A_4}(R)=1,
 \tag{5.2}
\]

the identity intertwiner supplies a compatible endpoint state.  Its three
coordinate-edge restrictions have the common derivative \(\lambda=1\), and
the order-three quotient cycles them exactly as in (2.3).  Thus the `A4`
endpoint equality also leaves (2.1) alive.

The identity on \(R\), or on \(\mathbf P(R)\), is **not** asserted to land
generically in the Klein cubic.  It records only the forced representation and
edge-jet equalities.

## 6. The precise conclusion

The full finite system tested here has the exact solution

\[
 (\lambda,\mu,D_B,D_C,D_D)
 =\left(1,0,
 \operatorname {diag}(0,1,1),
 \operatorname {diag}(1,0,1),
 \operatorname {diag}(1,1,0)\right).
 \tag{6.1}
\]

It simultaneously satisfies:

1. all `V4` tangent-character selection rules;
2. residual-`C3` conjugacy;
3. equality of the two endpoint derivatives on every involution-fixed edge;
4. the common `S3` scale at every `D12` meeting; and
5. the irreducible `A4` endpoint intertwiner constraint.

Therefore this theorem-forced second-layer CSP is **nonempty**.  Per the
finite-layer stopping rule, it supplies counterevidence to a purely
tangent-character obstruction and does not authorize a deeper arbitrary
degree or support sweep.  The non-`G`-unirationality headline remains open.
