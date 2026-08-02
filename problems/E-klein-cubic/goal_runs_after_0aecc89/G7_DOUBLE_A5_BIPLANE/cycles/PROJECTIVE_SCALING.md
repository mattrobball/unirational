# G7.2 — projective-lift and scaling gate

## Interface installed

**`cone_lifts_plus_multihomogeneous`** — audited affine cone lifts **and** multihomogeneous
tensor formulas for projective operations.

### Cone lifts

For each of the 22 geometric points the producer stores:

1. a raw homogeneous representative `rho(g_i)·base ∈ Q(ζ₁₁)⁵`;
2. the **chart-normalized** lift with first nonzero coordinate equal to `1`.

Nonvanishing opens appearing among the charts:

```text
x_0 != 0
x_2 != 0
```

Galois compatibility: the chart is the minimal index of a nonzero coordinate.
On the open where that coordinate remains nonzero, the lift is the unique
vector on the line with that coordinate `1`. Residual `C*`-scales never enter
projective constructions.

### Multihomogeneous operations

- Third intersection on a line through `p,q`:
  `r = B(p,q,q)p − B(p,p,q)q` (bidegree (2,2) — projectively meaningful).
- Incidence-weighted sums require the stored chart lifts (or a common
  Galois-compatible unit scale). **Silent sums of arbitrary homogeneous
  representatives are forbidden** and fail the scaling verifier.

### Verifier contract

`verify_scaling.py` deliberately rescales every input point independently and
checks projective outputs are unchanged. Marker:

```text
G7-PROJECTIVE-SCALING-PASS
```
