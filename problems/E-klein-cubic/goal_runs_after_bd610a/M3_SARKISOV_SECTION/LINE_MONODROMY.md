# Line-cover monodromy and residual operations

## The 55-point action

The installed line multisection is the transitive \(G\)-set of involutions.
For an involution \(z\),

\[
C_G(z)\simeq D_{12},\qquad [G:C_G(z)]=55.
\]

The independent verifier enumerates \(G\) directly as determinant-one
\(2\times2\) matrices over \(\mathbf F_{11}\), modulo \(\{\pm I\}\).  It
recovers the element-order histogram

```text
1:1, 2:55, 3:110, 5:264, 6:110, 11:120
```

and the stabilizer histogram

```text
1:1, 2:7, 3:2, 6:2.
```

The stabilizer subdegrees are

```text
1, 3, 3, 6, 6, 6, 6, 12, 12.
```

The six unordered-pair orbits have sizes

```text
165, 165, 165, 330, 330, 330.
```

The complete triple-orbit histogram and canonical digests are stored in
`residual_galois.json`.

## No degree-four resolvent inside the line field

The verifier checks simplicity independently by testing every union of
conjugacy classes containing the identity for subgroup closure.  There is no
proper nontrivial normal subgroup.  Hence there is no transitive four-point
action and no index-four subgroup.

Let \(q=s/t\).  Since \(E(q)/K(q)\) has Galois group \(G\), a quartic field
inside it would correspond to an index-four subgroup.  Therefore no quartic
point can be obtained merely by choosing a quartic component in the original
line splitting field.

This statement concerns the 55 horizontal lines on the threefold and their
splitting field.  It is not a computation of the full Galois action on the 27
lines of the generic cubic surface, and it does not assert that the latter
Galois group is a specified subgroup of \(W(E_6)\).

## Binary secants

The exact two-prime audit applies the fibrewise third-intersection operation
to every pair.  Every pair orbit has a non-singleton image, with minimum
observed cardinality 55.  Therefore this natural residual operation does not
produce a descended section.

No claim is made about tangent constructions requiring an additional
Galois-compatible tangent direction, or about iterated chord trees involving
new choices beyond the installed 55-point set.
