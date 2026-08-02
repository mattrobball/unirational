# H5.2 — valuation ledger (inventory only)

## Status

```text
structural_inventory_only
```

No anisotropic completion and no implication `Phi(K)=empty` is proved.

## Ambient

Work on the affine norm-one torus

\[
 r_0 r_1 r_2 r_3 r_4=1
\]

with `C_5` cycling coordinates, then descend orbit-sums to valuations of `K`.

## First primitive-boundary orbits (not exhaustive)

| Name | Representative (additive vals) | Orbit | Descends to `K`? | Residue anisotropy |
|---|---|---:|---|---|
| single coordinate | `v(r0)=1`, others `0` except `v(r4)=-1` | 5 | yes (orbit sum) | **not proved** |
| adjacent pair | `v(r0)=v(r1)=1`, `v(r4)=-2` | 5 | yes | **not proved** |
| balanced placeholder | mixed weights sum to 0 | — | — | **not proved** |

On the single-coordinate representative, `v(c)=v(r_2^{-1})` is zero; the full
orbit of valuations sees mixed signs for `c`.  Tropical cancellation patterns
for the five summands of `Phi` were **not** enumerated to residue equations in
this run.

## Forbidden implications (explicitly not used)

```text
special fibre has no visible point  =>  generic twist pointless
valuation on split E only           =>  obstruction for K-points
index one                           =>  rational point
order-11 multiplicative class       =>  trace cubic pointless
```

## Next finite gate for H5.2

Complete a `C_5`-equivariant toric fan census, descend every orbit, compute
extensions to `E`, and for each tropical pattern either prove residue
anisotropy or record an exact residual equation.
