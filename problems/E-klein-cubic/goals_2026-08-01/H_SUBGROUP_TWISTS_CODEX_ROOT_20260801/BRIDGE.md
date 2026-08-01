# BR-SUBGROUP-NEG and the generic subgroup twists

Let

\[
G=\operatorname{PSL}_2(\mathbf F_{11}),\qquad
X=\{\sum_{i\in\mathbf Z/5}x_i^2x_{i+1}=0\}\subset\mathbf P(W),
\]

and let `H` be any subgroup of `G`.

## Restriction implication

If `X` is `G`-unirational, there are a `G`-representation `V` and a
dominant `G`-equivariant rational map `V --> X`.  After restriction this is
the same dominant rational map with `H`-equivariance.  Thus `X` is
`H`-unirational (very versal).

Duncan--Reichstein, Theorem 1.1(a),(c), then gives, for every `H`-torsor
`T/Spec K`,

\[
{}^T X(K)\ne\varnothing
\quad\text{and}\quad
{}^T X\text{ is }K\text{-unirational}.
\]

Consequently one `H`-torsor whose twist is pointless disproves
`G`-unirationality.  This is the bridge `BR-SUBGROUP-NEG`; it does not need
the subgroup torsor to be generic.  Generic/versal torsors are used below
because they give one canonical test.

## The two maximal A5 torsors

For each of the two nonconjugate maximal subgroups `H_i=A5`, choose the
faithful irreducible three-dimensional icosahedral representation
`sigma_i`.  Its projective action on `P2` is faithful and generically free.
Put

\[
L_i=\mathbf C(\mathbf P^2),\qquad K_i=L_i^{H_i}.
\]

Then `Spec L_i -> Spec K_i` is the generic-point `H_i`-torsor.  Since
`P(sigma_i)` is dominated equivariantly by the underlying linear
representation, it is a versal `A5`-variety.

The file `a5_twist_payload.json` records two explicit `(2,3,5)` generating
pairs in the exact `PSL_2(F_11)` matrix group and proves by exhaustive
conjugation through all 660 elements that their maximal `A5` subgroups lie
in the two disjoint conjugacy classes (eleven subgroups per class).

Let `rho_i` be the restriction of the exact five-dimensional Klein
representation.  Put

\[
c(y)=\frac{3y_0+5y_1+7y_2}{y_0+2y_1+4y_2}
\in\mathbf C(\mathbf P^2),
\]

and define

\[
A_i(y)=\sum_{h\in H_i}c(\sigma_i(h^{-1})y)\rho_i(h).
\]

Reindexing the sum gives

\[
A_i(\sigma_i(g)y)=\rho_i(g)A_i(y).
\]

The payload gives a good-reduction point at which `det(A_i)=24 mod 89`
for each class.  Therefore both determinants are nonzero rational functions
in characteristic zero.  The five columns of `A_i` are a Hilbert--90
descent frame, and the exact twisted Klein equation is

\[
F_i^\tau(z)=\sum_{j\in\mathbf Z/5}
  (A_i(y)z)_j^2(A_i(y)z)_{j+1}=0
\quad\text{over }K_i.
\]

The transformation law and `G`-invariance of the original Klein form show
that every coefficient lies in `K_i`.  The formula, concrete subgroup
generators, finite-field frames, and the complete specialized coefficient
tables are
machine-readable in `a5_twist_payload.json`.

## The maximal 11:5 torsor

Let `H=N_G(C11)=11:5`.  The exact character norm is one, so `W|H` is
irreducible.  The projective action on `P(W)` is faithful and generically
free.  Put

\[
L=\mathbf C(\mathbf P(W)),\qquad K=L^H.
\]

With

\[
c(y)=\frac{2y_0+3y_1+5y_2+7y_3+11y_4}
{y_0+2y_1+3y_2+4y_3+5y_4},
\]

the same construction gives

\[
A_H(y)=\sum_{h\in H}c(\rho(h^{-1})y)\rho(h),\qquad
F_H^\tau(z)=F(A_H(y)z).
\]

The independent exact witness `det(A_H)=57 mod 89` proves this is a genuine
Hilbert--90 frame.  Full data are in `11_5_twist_payload.json`.

## Positive subgroup twists from contained linear spaces

If an `H`-subrepresentation `U` of `W` satisfies `P(U) subset X`, then for
every `H`-torsor `T/K`,

\[
\mathbf P({}^T U)\subset{}^T X.
\]

The twist `{}^T U` is an ordinary `K`-vector space, so its projective space
has a `K`-point.  This proves solubility of every `H`-twist.

The exact Klein representation contains such a two-space for `D12` (the
minus-eigenspace of an involution) and for `D10` (the span of inverse
nontrivial `C5` eigenvectors).  The verifier reconstructs both spaces and
checks the Klein cubic vanishes identically on each projective line.

## Logical boundary

A rational point on either displayed generic twist would only give an
equivariant rational map from its chosen versal variety to `X`; without a
dominance argument it is not by itself an `H`-unirationality proof.  A
pointless twist would be decisive by the first implication.  No such
pointlessness theorem is proved in this packet.
