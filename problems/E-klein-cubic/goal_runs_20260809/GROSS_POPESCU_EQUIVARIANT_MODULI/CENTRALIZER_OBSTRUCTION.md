# Centralizer obstruction for the natural modular action

## Sealed target theorem

The repository theorem `theory/FIX_IX_v14.md`, sealed by
`goal_runs_after_c53d89a/FIX_IX_SEAL/REPORT.md`, applies to a smooth projective
`G`-variety `Y` when an involution `sigma` satisfies:

1. no positive-dimensional component of `Y^sigma` contains a rational curve;
2. `Y^{C_G(sigma)}` is empty.

An `N=C_G(sigma)`-stable projectivized eigenspace in any faithful linear
source persists through an equivariant resolution as an `N`-stable,
pointwise-`sigma`-fixed RCC stratum.  Its image must be a point in
`Y^N`, a contradiction.  This rules out every equivariant rational map from
a faithful linear source, independently of degree or dominance.

## Application to `V14`

The exact characteristic-zero seal proves:

```text
V14^sigma = smooth genus-one sextic + two reduced points,
V14^{D12} = empty.
```

Hence the `V14` action is not `G`-unirational, not weakly versal, and its
generic twist has no rational point.

## Transfer to the moduli action

The property relevant here is an equivariant-birational property formulated
through resolved maps, not literal invariance of fixed schemes.  Since this
packet proves

```text
A_11^lev ~_G V14,
```

any hypothetical dominant map from a linear `G`-source to the natural modular
function field would compose, after resolving indeterminacy, with the
`V14` model and contradict the sealed theorem.  Therefore

```text
A_11^lev with its natural effective G-action is not G-unirational.
```

This establishes **GP-MODULI-NON-G-UNIRATIONAL**.

## Compactification and boundary

No projective fixed-locus theorem is applied directly to the open moduli
space.  The smooth projective `V14` is the equivariant compactification used
in the proof.  Boundary fixed curves on another toroidal compactification may
look different, but the resolved-map theorem already accounts for blowups,
exceptional strata, and contractions.  A new boundary b-complex computation
would be useful for intrinsic modular interpretation, not for validity of the
negative theorem.
