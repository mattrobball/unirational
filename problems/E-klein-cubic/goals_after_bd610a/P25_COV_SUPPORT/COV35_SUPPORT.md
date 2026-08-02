# Degree-35 literal COV support

Status: `PC-UNDECIDED`; neither a survivor nor degree-wide emptiness is proved.

## Exact installed system

```text
full self-covariant dimension       637
literal K1 dimension                361
positive-multiple span              361
complete landing cubics            8555
C3/C6 decision-space dimension      348
initial based dimension             336
initial nonbased charts              12
```

The full 8,555-cubic landing ideal remains on all 361 literal coefficients.
The zero-dimensional linear module quotient is not used.

## Exact branch reductions

| branch | remaining dimension / charts |
|---|---:|
| first-normal based | 300 |
| first-normal nonbased after tangent gate | 266 / 9 |
| second-based | 289 |
| pure-second nonbased | 247 / 24 |
| mixed-second based | 204 |
| mixed-second nonbased after tangent gate | 156 / 16 |
| third-based | 184 |
| pure-third nonbased | 140 / 31 |
| mixed-third nonbased after tangent gate | 39 / 9 |
| deepest scalar-zero tail | 5 |

The deepest five-space has complete cubic span `35/35` over `F_463`, so that
tail is empty.  The remaining characteristic-zero affine cover is

```text
12 + 9 + 24 + 16 + 31 + 9 = 101 charts.
```

## Degree-25 multiplier and factor boundary

An exact fixed circuit now gives the full strict-space multiplication map

```text
f10 : K1_25^strict (dimension 43) -> K1_35^literal (dimension 361).
```

Its reductions at 419 and 463 have rank 43 and zero residual on all 400
evaluation rows; the fixed Cramer denominator is nonzero in characteristic
zero.  No entrywise cyclotomic matrix or image of the unresolved nonlinear
PC.2 scheme is claimed.

At `p=89` the fixed chart drops to rank 15.  A separately replayed
determinant-74 chart identifies the authoritative DVR/`Q(37)|K(6)` strict
space and gives a rank-43 `361 x 43` ambient map with zero 400-row residual.
This repairs the special-fibre coordinate map only; the PC.2 scheme image is
still uncomputed.

The inherited fixed P25 multiplier tree has allowed/scalar-zero pairs

```text
59/59, 51/46, 38/38, 27/18, 13/10, 1/1, then zero.
```

It closes named deeper branches but retains the same unresolved
51-dimensional branch A and is not the authoritative current PC.2 scheme
image.

The exact Bezout sum `(0,18)` lies in the entire 361-dimensional
positive-multiple span while having component gcd one.  This directly refutes
the inference from a zero linear quotient to primitive or landing emptiness.
The actual common scalar-factor locus is now exhaustive: 15 kernel-aware
projective graphs cover factor degrees
`3,5,6,7,8,9,10,11,12,13,14,15,16,17,18`, with both-prime independent replay.
The total union with composition and named-family incidences, its
intersections, target-only eliminations, and the saturation of the 101
remaining charts do not exist.  Neither `PC35-DEGREE-EMPTY-SCOPED` nor
`PC35-COVARIANT-HEADLINE-POSITIVE` is authorized.
