# Fixed-locus/b-complex comparison

## The involution diagnostic

For the natural modular/`V14` action, the sealed projective model has

```text
sigma-fixed locus:  smooth elliptic sextic + two points,
D12-fixed locus:    empty.
```

This is exactly the configuration that activates the centralizer obstruction:
there is no rational curve in the positive-dimensional fixed locus.

For the standard regular Klein action, the exact repository certificates give

```text
K^sigma = E_sigma disjoint union L_sigma,
```

where `E_sigma` is a smooth plane elliptic cubic and `L_sigma ~= P^1`.  The
normalizer quotient acts through the marked `S3` geometry recorded in
`MARKED_S3_GEOMETRY.md`.  The rational line is the decisive failure of the
simple centralizer hypothesis.

## Why this is not a naive birational invariant

A blowup may create or delete fixed components and change normal characters.
Consequently the displayed fixed schemes alone do not prove that the two
actions are not birational.  The correct conclusions are:

- the mismatch explains why the same obstruction closes `V14` but not the
  standard Klein action;
- nonbirationality is proved independently by equivariant Burnside/rigidity
  results;
- the repository b-complex formalism is the correct language for transport
  through a resolved birational map.

## Structural mismatch in the b-complex

The modular side contains an incompressible positive-genus involution stratum
with no rational escape and no centralizer-fixed endpoint.  The standard
Klein side contains a rational fixed component linked to the elliptic
component through the exact `V4`, `C3`, and marked-incidence network.  Thus a
pointwise-fixed RCC exceptional stratum can land on `L_sigma`; constancy is no
longer forced.

The failure of Gross--Popescu equivariance is therefore visible in the
b-complex as the impossibility of matching the involution vertices and their
residual data under an equivariant birational identification.  This is a
structural explanation, while rigidity remains the formal separation proof.
