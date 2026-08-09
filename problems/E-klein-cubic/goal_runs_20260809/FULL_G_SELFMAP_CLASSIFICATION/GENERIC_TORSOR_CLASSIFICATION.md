# Generic-torsor classification of equivariant selfmaps

Let \(U\subset X\) be the free locus, \(B=U/G\),

\[
K=\mathbf C(B)=\mathbf C(X)^G,
\qquad L=\mathbf C(X),
\]

and let \(\alpha\in H^1(K,G)\) be the generic torsor.

## Proposition

Dominant \(G\)-equivariant rational selfmaps of \(X\) are equivalent to pairs

\[
(\psi,\iota)
\]

where

1. \(\psi:B\dashrightarrow B\) is dominant; and
2. \(\iota:\psi^*\alpha\xrightarrow\sim\alpha\) is an isomorphism of
   generic \(G\)-torsors.

Under this equivalence,

\[
\deg\varphi=\deg\psi.
\]

## Proof

An equivariant selfmap descends on the free quotient to \(\psi\). At the
generic point it gives a \(G\)-equivariant map from the pullback of the target
generic torsor to the source generic torsor. A \(G\)-equivariant map between
two finite étale \(G\)-torsors of the same order is an isomorphism, giving
\(\iota\).

Conversely, \(\iota\) gives a semilinear \(K\)-embedding

\[
L\hookrightarrow L
\]

whose restriction to \(K\) is \(\psi^*\). This is the function-field map of a
dominant \(G\)-equivariant rational selfmap. Since \([L:K]=|G|\) on both
sides, the finite torsor factors cancel in the degree calculation, giving
\(\deg\varphi=\deg\psi\).

## Interpretation

This is an exact classification at the generic-field level. It is not a
finite geometric classification: the set of torsor-preserving quotient
selfmaps can be infinite, and the tangent-residual construction produces a
nonidentity member.

For Problem E the relevant refinement is to characterize those pairs for
which the coordinate sections admit ambient lifts satisfying the Klein
landing equation identically.
