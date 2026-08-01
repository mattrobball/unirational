# Descent audit

## The tempting rigidity shortcut is invalid

The split complex Klein cubic is
\(G=\operatorname{PSL}_2(\mathbf F_{11})\)-birationally superrigid, and the
split genus-8 Fano threefold is also \(G\)-birationally rigid.  These facts do
not automatically make their generic twists birationally rigid.

Write

\[
L=\mathbf C(\mathbf P(W)),\qquad K=L^G.
\]

A \(K\)-birational map from \(X_T\) to a Mori fibre space becomes after
extension to \(L\) a map from \(X_L\), but its descent equivariance is
semilinear: \(G\) acts both on the coefficients in \(L\) and on \(X\).  It is
therefore a parameter-dependent family of complex birational maps.  It need
not specialize to one fixed complex (G)-equivariant birational map.  The
ordinary split \(G\)-superrigidity theorem does not apply to this semilinear
object.

Equivalently, a centre on \(X_T\) corresponds after untwisting to a
\(G\)-equivariant rational map from the generic torsor to a Hilbert scheme of
centres, not necessarily to a constant (G)-fixed Hilbert point.  Constant
\(G\)-stable centres are only one special case.

This distinction is load-bearing.  Any negative result must prove semilinear
generic-twist rigidity or a dominance-functorial obstruction; citing split
equivariant rigidity is not enough.

## What does descend directly

The projective representation on the Klein cubic lifts to a genuine
five-dimensional linear representation.  Hence the twisted ambient
projective space is the projectivization of a five-dimensional \(K\)-vector
space and is isomorphic to \(\mathbf P^4_K\).  Linear subspaces, their
incidence blowups, and projection maps can therefore be chosen directly over
(K).  This is the descent mechanism used in
`links/plane_cubic_dp3/README.md`.

## Headline boundary

Birational rigidity controls birational maps between Mori fibre spaces.
Problem E asks about a dominant equivariant map from a linear representation,
which may have positive relative dimension or degree greater than one.  No
negative headline conclusion follows without a separate theorem connecting
the two notions.
