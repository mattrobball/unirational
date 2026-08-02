# Four-Kummer Laurent-monomial exclusion for the `11:5` trace cubic

## Theorem

Use the installed exact model

\[
K=\mathbf C(U_1,U_2,U_3,U_4),\qquad
E=K(\alpha),\qquad \alpha^5=U_1,
\]

and

\[
\Phi(R_2b)=\operatorname {Tr}_{E/K}(R_2R_3^2b^2\sigma(b)).
\]

For every four-element subset

\[
0\le p<q<r<s\le4,
\]

every nonzero `c_p,c_q,c_r,c_s in C`, and every exponent vectors
`m_p,m_q,m_r,m_s in Z^4`, one has

\[
\Phi\!\left(R_2\left(
c_pU^{m_p}\alpha^p+c_qU^{m_q}\alpha^q+
c_rU^{m_r}\alpha^r+c_sU^{m_s}\alpha^s
\right)\right)\ne0.
\]

Thus no point on the genuine `11:5` trace cubic has exactly four nonzero
Kummer-basis coordinates when each coordinate is a single Laurent monomial
times a nonzero complex scalar.

## Exact support model

Homogeneity permits division by the first coefficient, leaving three
relative exponent vectors `a,b,c in Z^4`.  A cubic in four coordinates has
20 coefficient monomials.  The exact Fourier trace formula gives seven
distinct nonzero invariant monomials in every coefficient, hence 140 labelled
contributions.  A contribution with parameter counts
`n=(n0,n1,n2,n3)` and invariant exponent `e` lands at

\[
e+n_1a+n_2b+n_3c.
\]

If the trace identity vanished, every resulting exponent would occur at
least twice.  The scalar coefficients never enter unless this necessary
support condition holds.

## Unique modulo-three gate

The verifier first enumerates all `3^12` residue triples `(a,b,c)` for each
of the five four-element subsets.  Exactly one residue triple survives for
each subset, and each has 31 residue support groups:

| subset | `(a,b,c) mod 3` |
|---|---|
| `(0,1,2,3)` | `((1,0,0,0),(2,0,0,0),(0,0,0,0))` |
| `(0,1,2,4)` | `((1,0,0,0),(2,0,0,0),(1,0,0,0))` |
| `(0,1,3,4)` | `((1,0,0,0),(0,0,0,0),(1,0,0,0))` |
| `(0,2,3,4)` | `((2,0,0,0),(0,0,0,0),(1,0,0,0))` |
| `(1,2,3,4)` | `((1,0,0,0),(2,0,0,0),(0,0,0,0))` |

Any exact support identity must reduce to the corresponding row.  This cuts
the exact collision table from 4,095 equations to 145 equations and 73
directions for each subset.

## Exhaustion by collision rank

A collision gives a vector equation

\[
A a+B b+C c=\delta.
\]

The realized collision directions span rank one, two, or three.

### Rank three

Three independent equations determine all twelve integer entries of
`(a,b,c)`.  For every subset the verifier enumerates 56,382 independent
direction triples and 402,802 exact right-hand-side systems.  It retains
35,473 integral exponent triples and tests all 140 shifted contributions.
There is no support survivor.  Across all five subsets:

```text
integral rank-three candidates  177365
support survivors                    0
```

### Rank two

Every rank-two direction plane has a primitive normal.  The verifier
enumerates all 505 possible planes.  Within a plane, two independent realized
collisions determine the rational restriction of the exponent map to that
plane.  It deduplicates 7,554 such restrictions per subset and marks every
labelled term that could collide consistently with each restriction.  No
restriction matches all 140 terms.  This is an over-approximation: maps that
do not extend to integral `(a,b,c)` are retained, so emptiness is sufficient.

```text
rank-two candidate restrictions  37770
viable restrictions                  0
```

### Rank one

For every primitive collision direction `w`, an integral exponent map has
an integral value on `w`.  The verifier reconstructs every possible value
from the filtered equations and checks all incident labelled terms.  It finds
61 directions and 121 candidates per subset, with no candidate matching all
140 terms.

```text
rank-one candidates  605
viable candidates      0
```

The three ranks are exhaustive, so no necessary support exists.  The theorem
follows for arbitrary nonzero complex scalars before coefficient cancellation
needs to be considered.

## Boundary

This theorem does not allow any Kummer coordinate to be a sum of Laurent
monomials or an arbitrary rational function in `K`.  It also does not treat
all five nonzero Kummer coordinates.  It produces neither a rational point
nor a pointlessness obstruction for the full trace cubic.  The `11:5` gate
and Goal Q remain undecided.

