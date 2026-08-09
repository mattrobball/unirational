# Generalized fixed-stratum obstructions

## Theorem G1: residual-RCC centralizer obstruction

Let `G` be a finite group acting faithfully on a smooth projective
rationally connected variety `Y` over an algebraically closed field of
characteristic zero. Let

\[
1\ne \sigma\in G,\qquad N=C_G(\sigma).
\]

Assume:

1. every `N`-stable irreducible rationally chain connected closed
   subvariety of `Y^sigma` is a point;
2. `Y^N=emptyset`.

Then no faithful linear `G`-variety admits a `G`-equivariant rational map
to `Y`. Consequently `Y` is not weakly `G`-versal and, in particular, is
not `G`-unirational.

### Proof

Let `V` be a faithful representation. A rational map from the affine
linear source `V` to the proper variety `Y` determines a rational map

\[
\phi:\mathbf P(k\oplus V)\dashrightarrow Y.
\]

Choose a nonzero `sigma`-eigenspace `W_chi` in `k\oplus V` and set

\[
F_0=\mathbf P(W_\chi).
\]

Because `N` commutes with `sigma`, `F_0` is irreducible, `N`-stable,
pointwise fixed by `sigma`, and rationally chain connected.

Take an equivariant elimination of the indeterminacy of `phi` by a sequence
of blowups with smooth invariant centers. Carry `F_0` through the tower by
the controlled survivor rule used in `theory/FIX_IX_v14.md`:

- if the current survivor `F` is not contained in the next center, take its
  strict transform;
- if `F` is contained in the center, decompose the normal bundle along `F`
  into `sigma`-eigenbundles and take the projectivization of any nonzero
  eigenbundle.

A strict transform is birational to `F`; a projectivized eigenbundle is a
projective bundle over `F`. Thus the new survivor remains irreducible and
RCC. Since `N` preserves every `sigma`-eigenbundle, it remains `N`-stable;
`sigma` acts scalarly on the selected fibers, so it remains pointwise
`sigma`-fixed.

On the final model the resolved morphism sends the survivor to an
irreducible, `N`-stable, RCC closed subvariety of `Y^sigma`. Hypothesis (1)
forces the image to be a point `y`. Its `N`-stability says
`y in Y^N`, contradicting hypothesis (2).

For a complete `G`-variety, weak versality implies the existence of a
rational `G`-map from a generically free faithful representation, by the
generic-torsor criterion of Duncan--Reichstein. Hence the absence just
proved implies non-weak-versality. A dominant map from a representation
would in particular be such a map, so `G`-unirationality also fails. QED.

## Corollary G2: residual quotient/MRC criterion

It is enough to verify the following for every `N`-stable irreducible
component `F` of `Y^sigma` that could contain an `N`-stable image. There is
an `N`-equivariant proper morphism

\[
q_F:F\longrightarrow B_F
\]

such that:

1. `B_F` contains no positive-dimensional RCC closed subvariety;
2. `B_F^N=emptyset`.

Indeed, an `N`-stable irreducible RCC subvariety `Z subset F` has RCC image
in `B_F`, hence maps to a point `b`. Equivariance and `N`-stability of `Z`
make `b` an `N`-fixed point, a contradiction.

The most useful case is an equivariant fibration over a positive-genus
curve on which the residual group has no fixed point. This is the precise
MRC-style replacement for the unnecessarily strong condition that the
whole fixed component contain no rational curve.

## Corollary G3: product amplification

Suppose `z in Z(G)` and a smooth projective `G`-variety `S` satisfy

\[
S^z=C,
\]

where `C` is a smooth curve of genus at least one and `C^G=emptyset`. Let
`R` be any smooth projective rationally chain connected variety with
trivial `G`-action. Then

\[
(R\times S)^z=R\times C,
\]

and `R x S` is not weakly `G`-versal.

The old central theorem cannot be invoked when `dim(R)>0`, because
`R x C` contains rational curves. Theorem G1 does apply: every irreducible
RCC subvariety of `R x C` maps to a point of `C`, and `G`-stability would
force that point to lie in `C^G`.

This is the mechanism used for both threefold applications in the packet.

## What this theorem does not claim

- It does not propagate an arbitrary RCC fixed network through an arbitrary
  higher-dimensional resolution.
- It does not classify horizontal components of a normalized Rees algebra.
- It uses one deliberately selected eigenspace survivor whose behavior is
  controlled at every blowup.
- It does not say that the MRC base alone suffices without residual
  equivariance: absence of a residual fixed point is load-bearing.
