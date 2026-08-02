# H5.1.C — projection geometry (wave 2)

## Ambient cubic

On the B-frame of H4,

```text
F = sum_{i in Z/5} x_i^2 x_{i+1},
F(B z) = Phi(z) = Tr(r2^{-1} a^2 sigma(a)).
```

The affine cone of `F` has only the origin as a singular point (partials
`2 x_j x_{j+1} + x_{j-1}^2`), so the projective cubic threefold is smooth over
`C`.

## Degree-five closed point

`Z0(T) = ∏_{k=1}^4 (T − r_k)` gives `Phi=0` over `E` (H4). In the B-frame the
image is proportional to `e_0`, and the Gal(`E/K`)-orbit is the five coordinate
points `e_i`. This is index evidence already recorded — **not** a K-point.

## Skip-one lines on `F`

For each `i`, the line

```text
L_i = span(e_i, e_{i+2})
```

lies on `F=0`: a general point has only coordinates `i` and `i+2` nonzero, so
every monomial `x_j^2 x_{j+1}` of `F` vanishes. Independently verified on
random points over several `F_p`.

Consecutive lines `span(e_i, e_{i+1})` do **not** lie on `F`.

## Residual after projecting from `L_0`

Write `x = (s, u, t, v, w)` with line coordinates `(s:t)` on
`L_0 = span(e_0,e_2)` and complementary `P^2` coordinates `(u:v:w)`.

```text
F = u s^2 + w^2 s + v t^2 + u^2 t + v^2 w.
```

This is the residual equation of the conic bundle fibres (quadratic in the
line coordinates once the complementary point is fixed).

### Linear sections

No linear formulas

```text
s = a_u u + a_v v + a_w w,   t = b_u u + b_v v + b_w w
```

with small integer coefficients satisfy the residual identity. Payload:
`projection.json` → `linear_sections = []`.

## Galois descent obstruction (structural, not a theorem of pointlessness)

The five lines `L_i` form a single Gal(`E/K`)-orbit of size 5. No individual
line is σ-fixed, so **no skip-one line is defined over `K`**. Projection from
a single `L_i` yields a conic bundle over `E`, not over `K`.

The unique obvious Gal-invariant hyperplane (without adjoining fifth roots)
is `∑ x_i = 0`. The cubic surface `X ∩ {∑ x_i=0}` is defined over `K`, but a
constant B-frame point on it need not come from `z ∈ P^4(K)` because `B`
depends on the `r`-parameters.

## Verdict

```text
geometry_recorded_no_K_point
```

Next gate: descend the residual conic bundle along the orbit (or compute the
associated Brauer/Severi–Brauer class) and decide the generic fibre over `K`.
