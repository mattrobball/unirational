# H5 modular residual fibration probe — summary

Discovery only.  Exit: **H5-UNDECIDED**.  Headline: **OPEN**.

## Geometry

Specialized equation `G(x)=sum_i (1/r_{i+2}) x_i^2 x_{i+1}` on product-one
`r` with distinct coordinates.  Degree-five eigenpoints `e_m` lie on `G`.
Projection from `e_m` yields residual binary quadrics on lines through `e_m`.

## Summary by prime

| p | specs | soluble | sing* | cont.line | double | split | nonsplit | split/(non-cont) | #X est/exact |
|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| 31 | 24 | 24/24 | 0 | 1 | 457 | 7247 | 6695 | 0.5033 | 30784.0 exact-mean |
| 41 | 24 | 24/24 | 0 | 1 | 369 | 7222 | 6808 | 0.5016 | 70644.0 exact-mean |
| 61 | 24 | 24/24 | 0 | 1 | 204 | 7186 | 7009 | 0.4991 | 225519 MC-mean |
| 71 | 24 | 24/24 | 0 | 0 | 227 | 7137 | 7036 | 0.4956 | 369169 MC-mean |
| 89 | 24 | 24/24 | 0 | 0 | 196 | 7276 | 6928 | 0.5053 | 709905 MC-mean |
| 101 | 24 | 24/24 | 0 | 0 | 146 | 7074 | 7180 | 0.4913 | 1047726 MC-mean |
| 131 | 24 | 24/24 | 0 | 0 | 101 | 7143 | 7156 | 0.4960 | 2371031 MC-mean |
| 151 | 24 | 24/24 | 0 | 0 | 103 | 7196 | 7101 | 0.4997 | 3723428 MC-mean |
| 181 | 24 | 24/24 | 0 | 0 | 78 | 7221 | 7101 | 0.5015 | 6003305 MC-mean |
| 199 (holdout) | 24 | 24/24 | 0 | 0 | 67 | 7254 | 7079 | 0.5038 | 8077818 MC-mean |

\* `sing` = specializations where a random/eigenpoint search found
`grad G = 0` (heuristic; not a smoothness theorem).

## Reading

- Local solubility of specialized fibres is routine (eigenpoints alone).
- Residual fibrations show mixed split/nonsplit fibres; contained lines
  and double fibres appear at low rate.
- No transfer to a `K`-point or to pointlessness is claimed.

Elapsed: 34.46s.  Seed=20260802.
