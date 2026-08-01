# Point ledger

## Current verdict

No `K_proj`-rational point of the genuine twisted Fano threefold has been
constructed in this packet.  This file intentionally contains no placeholder
coordinates and no promotion of a modular or auxiliary point.

## Accepted exact target

With the exact Hilbert--90 frame `V_j=(x,C,D,E,K)` and aligned alternating
map `Q`, the installed distinguished section is

```text
B_j(x)=Q(V_j(x)),
S_j(x)=Q(x)^-1 B_j(x).
```

After an explicit Morita identification, these become five Hermitian forms.
A valid point must be a single right quaternionic line isotropic for all five;
equivalently its primal Pluecker vector must be decomposable and annihilated
by the entire distinguished five-space.

## Rejected substitutes

- The abstract self-adjoint reduced-rank-two idempotent exists, but is only a
  structure projector.
- The degree-12 ambient residue projectors are modular auxiliary points.  At
  prime 23 the three extracted projectors have nonzero distinguished
  five-plane residuals at every checked source point.
- Separate isotropic lines for individual forms do not define a common line.
- A residue point or a point over an uncontrolled extension is not a
  `K_proj`-point.

## Required future payload

A replacement positive point entry must include exact coordinates over the
named `K_proj` model, all five zero residuals, every Pluecker relation, the
relevant nonvanishing conditions, descent under the aligned generators, and
an independent substitution in the original Fano equations.
