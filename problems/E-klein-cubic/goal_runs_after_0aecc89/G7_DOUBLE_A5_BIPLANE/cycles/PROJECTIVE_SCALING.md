# G7.2 — projective-lift and scaling gate

## Interface installed

**`cone_lifts_plus_multihomogeneous`** — audited affine cone lifts **and** multihomogeneous
tensor formulas for projective operations.

### Cone lifts

Chart normalization: first nonzero coordinate scaled to `1`. Sample F=0 points
(not induced-cycle points) exercise the interface. Nonvanishing opens among
samples:

```text
x_0 != 0
```

On the open where the chosen chart coordinate remains nonzero, the lift is the
unique vector on the line with that coordinate `1`. Residual `C*`-scales never
enter projective constructions.

### Multihomogeneous operations

- Third intersection on a line through `p,q`:
  `r = B(p,q,q)p − B(p,p,q)q` (bidegree (2,2) — projectively meaningful).
- Incidence-weighted sums require audited chart lifts (or a common
  Galois-compatible unit scale). **Silent sums of arbitrary homogeneous
  representatives are forbidden** and fail the scaling verifier.

### Binding

This gate does **not** claim induced-cycle coordinates. It seals the
scale-safe operation interface for any later geometric points.

### Verifier contract

`verify_scaling.py` deliberately rescales every sample point independently and
checks projective outputs are unchanged. Marker:

```text
G7-PROJECTIVE-SCALING-PASS
```
