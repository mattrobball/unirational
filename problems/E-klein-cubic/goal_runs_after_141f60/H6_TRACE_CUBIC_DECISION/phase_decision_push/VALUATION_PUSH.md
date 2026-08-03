# H6.3 push — valuation ledger

## Status

```text
structural_inventory_with_residue_series_and_tropical_masks
```

**Not** `H6-VALUATION-REDUCTION-PASS`. No anisotropic residue completed.

## Corrections / method

For `f ∈ K ⊂ E`, Gal-conjugates of a toric place induce the **same** valuation
on `f`. Use `v|_K`, not the numerical sum of orbit valuations on characters
(that sum vanishes on the character lattice for these rays).

C5-equivariant toric places: integer vectors `v` with `∑ v_i = 0`. Orbit under
cycling; restrict to invariants; extend to `E`; leading term of the 11-torsor
invariant including `c`-translation; cancelation masks of `Φ` summands.

## Orbits

Six primitive-ray orbits inventoried (`single_coord`, `adjacent_pair`,
`skip_pair`, `triple`, `balanced`, `two_one_minus`). Tropical min-masks
counted for monoms of exponent box `[-2,2]⁵`.

## Series samples (single_coord chart)

`r₀=t`, `r₁=x`, `r₂=y`, `r₃=z`, `r₄=1/(t x y z)`. Constant-`z` power-basis
samples produce nonzero Laurent heads in `t` (e.g. `z=(1,0,0,0,0)` has a
`t^{-1}` term). Pure monoms excluded by H4 orbit-sum.

## Forbidden implications (not used)

```text
special fibre empty            => generic pointless
valuation on split E only      => K-obstruction
order-11 class of c alone      => Φ pointless
tropical noncancellation alone => headline negative
```

## Next finite gate

Complete one orbit through residue smoothness/singularity classification and
either anisotropic obstruction or forced trivialization (retire the family).
