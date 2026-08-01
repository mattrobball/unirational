# Elimination of both maximal-A5 valuation survivors

## Theorem

Let `X` be the Klein cubic with its restricted action by either of the two
maximal subgroups

\[
A_5^{(1)},A_5^{(2)}\subset \operatorname{PSL}_2(\mathbf F_{11}).
\]

For every extension field `L/C` and every torsor `T/L` under either embedded
`A5`, the twist `X_T` has an `L`-rational point.

Consequently, in the genuine Schur valuation frontier, an unramified
henselian nonpoint cannot have either maximal `A5` as its decomposition
group.  The previously certified survivor list

```text
{G, A5_class_1, A5_class_2, 11:5}
```

therefore sharpens to

```text
{G, 11:5}.
```

The remaining conditions are unchanged: a nonpoint must have trivial
inertia, residue transcendence degree at least two, and rational rank at most
three.

## Proof

The sealed A5 packet constructs, separately for both embedded classes, an
exact degree-eleven covariant

\[
\phi_i:\mathbf P(V_3)\dashrightarrow X
\]

and verifies the complete landing identity in characteristic zero.  Here
`V3` is the honest irreducible three-dimensional linear representation of
`A5`; the source action is generically free because no nonidentity element
acts projectively as a scalar and the group is finite.

Now let `T/L` be an arbitrary `A5` torsor.  Twisting the honest vector space
`V3` gives a three-dimensional `L`-vector space by linear Galois descent, so

\[
{}^T\mathbf P(V_3)\simeq\mathbf P^2_L.
\]

Twisting `phi_i` gives a rational map from this split plane to `X_T`.  Its
domain is a nonempty open.  Every extension of `C` is infinite, so that open
contains an `L`-point.  Its image is an `L`-point of `X_T`.  Notice that no
dominance assertion is needed: this is weak versality, not equivariant
unirationality.

For the valuation consequence, use the exact low-rank valuation theorem.  At
an unramified site with decomposition group `D`, the smooth special fibre is
the twist by the induced residue `D`-torsor.  If `D` is either maximal `A5`,
the preceding paragraph supplies a residue point.  Smooth Hensel lifting
then supplies a point over the henselian valued field, contradicting the
assumption that it is a nonpoint.

## Boundary

This is a functorial positive local-solubility theorem, not a global point on
the genuine `G` twist.  The cases `D=G` and `D=11:5` remain.  The generic
`11:5` trace model has no known rational point, and the full `G` case is the
original binary problem.  The governing Q status remains `Q-UNDECIDED`.
