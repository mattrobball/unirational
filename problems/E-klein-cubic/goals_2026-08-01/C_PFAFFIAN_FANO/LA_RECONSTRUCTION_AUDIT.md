# `L_a` reconstruction audit

## Verdict

The named-basis reconstruction of `L_a in Mat_6(E)` is not complete.  The
exact determinant oracle is valid, but low-degree interpolation is ruled out
far beyond the historical preflight.

## Exact modular rank ledger

For `L_a[0,1,0]` at the deterministic `p=353` sample design:

| rational total degree `D` | samples | numerator columns | denominator columns | augmented rank | nullity |
|---:|---:|---:|---:|---:|---:|
| 2 | 918 | 180 | 15 | 195 | 0 |
| 3 | 1,600 | 420 | 35 | 455 | 0 |
| 4 | 1,600 | 840 | 70 | 910 | 0 |
| 5 | 2,200 | 1,512 | 126 | 1,638 | 0 |
| 6 | 3,300 | 2,520 | 210 | 2,730 | 0 |
| 7 | 5,000 | 3,960 | 330 | 4,290 | 0 |

All ranks are over `F_353`.  The design columns are
`beta_s*t^alpha`; denominator columns are
`-x*t^alpha`.  Full numerator rank and zero augmented nullity rule out the
stated ansatz at that prime.

The 918-point degree-four system had nullity 35 for each tested coordinate,
but two such denominator spaces had zero intersection.  The 1,600-point
extension raises the representative augmented rank from 875 to 910 and
removes the false fits.

## Boundary

This proves a modular degree floor for one varying coordinate.  It does not
prove a characteristic-zero degree floor, does not reconstruct a rational
function, and does not bear on existence of the genuine common Fano line.

