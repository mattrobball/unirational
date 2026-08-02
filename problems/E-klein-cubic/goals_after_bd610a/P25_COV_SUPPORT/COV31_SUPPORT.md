# Degree-31 literal COV support

Status: `PC-UNDECIDED`; neither a survivor nor degree-wide emptiness is proved.

## Exact installed system

```text
full self-covariant dimension       410
literal K1 dimension                198
positive-multiple span              197
complete landing cubics            5349
C3/C6 decision-space dimension      187
initial based dimension             177
initial nonbased charts              10
```

The full 5,349-cubic landing ideal is retained on all 198 literal
coefficients.  It is not pushed to the one-dimensional linear quotient.

## Exact branch reductions

The inherited characteristic-zero linear gates give:

| branch | remaining dimension / charts |
|---|---:|
| first-normal based | 147 |
| first-normal nonbased after tangent gate | 137 / 15 |
| second-based | 130 |
| pure-second nonbased | 99 / 7 |
| mixed-second based | 78 |
| mixed-second nonbased after tangent gate | 45 / 9 |
| third-based | 65 |
| pure-third nonbased | 36 / 6 |
| deepest scalar-zero tail | 5 |

On the deepest five-space the complete equations span all `35/35` cubic
monomials over `F_463`, closing that projective tail.  Two of the six
pure-third affine charts return `[1]` over `F_463`, but the charts are
prime-specific affine systems.  This does not transfer by projective
properness, so all six remain open for the characteristic-zero scheme.

The remaining characteristic-zero affine cover is therefore

```text
10 + 15 + 7 + 9 + 6 = 47 charts.
```

## Degree-25 multiplier and factor boundary

An exact fixed circuit now gives the full strict-space multiplication map

```text
f6 : K1_25^strict (dimension 43) -> K1_31^literal (dimension 198).
```

Its modular reductions at 419 and 463 have rank 43 and satisfy all 400
evaluation identities; the Cramer denominator is certified nonzero in
characteristic zero.  The stored arrays are modular reductions, not an
entrywise cyclotomic reconstruction.  More importantly, this is an ambient
linear map: the actual image of the unresolved nonlinear PC.2 scheme is still
unknown.

The fixed characteristic-zero chart itself drops to rank 15 at `p=89`.
A deterministic replacement chart has determinant 74, spans the accepted DVR
strict space in authoritative `Q(37)|K(6)` coordinates, and reconstructs the
`198 x 43` map with rank 43 and zero residual on all 400 evaluation rows.
Thus the ambient special-fibre binding is repaired, but no PC.2 scheme point
or equation has been pushed through it.

The old fixed 59-dimensional P25 multiplier localization gives successive
allowed/scalar-zero dimensions `51/46`, `27/18`, and `3/0`; its pure-second
three-space is closed by scalar rank 3 and cubic span `10/10`.  A residual
51-dimensional branch A is still open, and the calculation is not the image
of the authoritative current PC.2 scheme.

The exact Bezout sum `(0,9)` shows that the 197-dimensional
positive-multiple span contains a component-gcd-one covariant.  No complete
total factor/composition/ansatz incidence union exists.  The actual common
scalar-factor locus itself is now exhaustive: 11 kernel-aware projective
graphs cover factor degrees `3,5,6,7,8,9,10,11,12,13,14`, with all
multiplication circuits and tangent witnesses independently replayed at 419
and 463.  Target-only eliminated ideals are not materialized, and the
composition, named-family, intersection, and away-from-union saturations are
open.  Thus neither the one-dimensional quotient nor the partial branch tree authorizes
`PC31-DEGREE-EMPTY-SCOPED` or `PC31-COVARIANT-HEADLINE-POSITIVE`.
