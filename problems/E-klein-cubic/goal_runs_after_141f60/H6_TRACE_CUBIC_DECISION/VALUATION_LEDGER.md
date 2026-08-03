# H6.3 — valuation ledger

## Status

```text
structural_inventory_with_residue_template
```

**Not** `H6-VALUATION-REDUCTION-PASS`.  No anisotropic residue completed.
Push extension: tropical min-masks + single_coord series samples in
`phase_decision_push/valuation_push.json`.

## V3 constraints (binding)

Consume `V3_VALUATION_RESIDUE_CLOSEOUT`: a negative henselian site must be
unramified, non-`C1` residue of transcendence degree ≥2, rank ≤2, decomposition
group in `{PSL(2,11), 11:5}`.  The only unresolved proper-decomposition site
is this maximal `11:5` trace cubic.

## Method

C5-equivariant valuations on the product-one torus: integer vectors
`v` with `sum v_i=0`.  Orbit under cycling; for `f∈K` use `v|_K` (all
conjugates agree on invariants — not the character-lattice orbit sum, which
vanishes).  Extend to `E`; form leading term of the 11-torsor invariant
including the `c`-translation; analyze cancellation patterns of `Phi` to a
residue torsor/cubic.

## Orbits inventoried (not a full fan)

| Name | Representative | Orbit size | Residue anisotropy |
|---|---|---:|---|
| single_coord | (1,0,0,0,-1) | 5 | not proved |
| adjacent_pair | (1,1,0,0,-2) | 5 | not proved |
| skip_pair | (1,0,1,0,-2) | 5 | not proved |
| triple | (1,1,1,0,-3) | 5 | not proved |
| balanced | (2,-1,2,-1,-2) | 5 | not proved |
| two_one_minus | (2,1,0,0,-3) | 5 | not proved |

## Series note (single_coord chart)

On `r0=t`, `r4=1/(t x y z)`, constant power-basis samples (e.g. `z=(1,0,0,0,0)`)
have nonzero Laurent heads in `t`.  Pure monoms excluded by H4 orbit-sum.

## Forbidden implications (not used)

```text
special fibre empty            =>  generic pointless
valuation on split E only      =>  K-obstruction
order-11 class of c alone      =>  Phi pointless
tropical noncancellation alone =>  headline negative
```

## Next finite gate

Complete one orbit through residue smoothness/singularity classification and
either anisotropic obstruction or forced trivialization (retire the family).
