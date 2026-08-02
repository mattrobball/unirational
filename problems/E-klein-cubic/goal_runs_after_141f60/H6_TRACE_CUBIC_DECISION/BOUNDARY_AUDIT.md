# Boundary audit (H6.1)

## Open covered by the torsor equivalence

On the product-one torus open inside the H4 common open

```text
product_i(y_i)*product_h ell(rho(h^{-1})y)*det(A)*product_{i<j}(r_j-r_i)*s0*q1 != 0
```

the identification

```text
Y(K)  ↔  nonzero solutions of Phi=0
```

is exact (see TRACE_HYPERPLANE_TORSOR.md).

## Degeneracy loci

| Locus | Effect |
|---|---|
| some `r_i=0` or chart exit from product-one | leave multiplicative torus model |
| `y_i=0`, `s0=0`, `q1=0`, `det A=0` | leave H4 common open / frame |
| `r_i=r_j` | discriminant; specialization of cyclic basis |
| `a=0` | invalid projective class |
| scalar vs projective | full `E^*` map degree 33; projective isogeny degree 11 |

## Boundary points of `Phi=0`

- Pure Laurent monoms: empty (H4; not re-run).
- Low-support constant / monom screens: empty in H5 scope (bound only).
- This residual constructed **no** boundary `K`-point and proves **no**
  boundary emptiness theorem.

## Honesty bound

Tropical or chart-boundary noncancellation without a residue anisotropy
theorem is only structural.  It is **not** used as
`H6-POINTLESS-HEADLINE-NEGATIVE`.
