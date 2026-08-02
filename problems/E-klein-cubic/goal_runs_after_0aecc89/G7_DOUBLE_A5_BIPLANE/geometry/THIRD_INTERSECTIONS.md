# G7.5 — third intersections and residual cycles

## Formula

With polarization normalized by `F(x)=B(x,x,x)` on the split Klein model,

```text
r_ij = B(p_i, q_j, q_j) p_i − B(p_i, p_i, q_j) q_j
```

multihomogeneous of bidegree `(2,2)`. Verified against the expansion of
`F(sp+tq)` on a sample pair.

## Census (all 121 ordered pairs)

| class | count |
|---|---|
| incident (`N_ij=1`) | 55 |
| nonincident | 66 |
| status `ok` (nonzero residual on cubic) | 109 |
| `line_on_cubic` | 4 |
| `coincide_pq` | 6 |
| `coincide_r_p` | 2 |
| unique residual projective points | 97 |
| Q-rational residual points | 0 |

## Lines on the split cubic

4 incident pairs have `B(p,p,q)=B(p,q,q)=0`, hence the whole line
`span(p,q) ⊂ V(F)`. Among them, the coordinate line `e_0–e_2` has both
endpoints Q-rational (classical Klein geometry). **These are not promoted to
`K_proj`-lines on `X_gen`** without equivariant descent and bridge.

## Design-forced neighbor secants (`2-(11,5,2)`)

For each point, the five incident partners determine `C(5,2)=10` secants.
Within-class and neighbor-secant third intersections produced **no** Q-rational
residual points. A few neighbor secants lie on the cubic (recorded in JSON).

## Span ranks (Q-embedding of lifts)

See `residual_cycles.json` → `span_ranks`. Residual incident/nonincident cycles
span the full ambient Q-embedding (rank 50); no low-dimensional rational linear
span yielding a `K_proj` component was found.

## Scheme-theoretic gate

Degree reduction claims require **effective** subschemes. Signed `CH_0` arithmetic
is not used. No effective length-two subscheme over `K_proj` was obtained from
the residual data.

Machine data: `residual_cycles.json`.
