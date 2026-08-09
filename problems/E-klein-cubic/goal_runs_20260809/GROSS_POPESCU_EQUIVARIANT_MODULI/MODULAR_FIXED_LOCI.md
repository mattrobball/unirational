# Fixed loci in modular language

## Fixed-point functor

Let `sigma in G` be an involution and choose a lift `sigma_tilde in
SL2(F11)`.  A coarse fixed point of the natural level action is represented by

```text
(A,lambda,alpha,u)
```

where `u` is a polarized automorphism and, up to the chosen right/left
convention, its action on the polarization kernel satisfies

```text
alpha^{-1} o u_* o alpha = sigma_tilde.
```

Because `sigma_tilde^2=-I`, the generic cocycle relation is
`u^2=[-1]_A`.  Thus the positive-dimensional fixed functor is of PEL type:
it parametrizes surfaces carrying an order-four endomorphism compatible with
the polarization and level marking.  Its expected one-dimensional part is a
unitary/Shimura-type modular curve.  This interpretation is intrinsic and
explains why a positive-genus curve, rather than a rational family, appears.

For `N=C_G(sigma)=D12`, an `N`-fixed point would require a coherent projective
`N`-action by polarized automorphisms inducing the prescribed action on the
polarization kernel.  Equivalently, one must lift the centralizer action
through the relevant binary extension, not merely find an abstract extra
endomorphism.

## What is proved exactly

The equivariant birational model identifies the modular function field with
the sealed `V14` action.  On the smooth projective `V14` model,

```text
V14^sigma = C_6 disjoint union {p_1,p_2},
```

where `C_6` is a smooth irreducible genus-one sextic, and

```text
V14^N = empty.
```

On every common open where `Theta_11` is an isomorphism, the modular
fixed-point functor maps to these strata.  The curve is therefore the
projective fixed curve naturally associated with the modular action.

## Deliberate limitation

Fixed loci are not naively invariant under birational maps.  The present
sources do not prove an intrinsic modular equation for `C_6`, identify its
compactification/cusps, or classify every special level-polarized surface at
which the rational construction of `Theta_11` degenerates.  In particular,
this packet does not claim a standalone moduli-theoretic proof that the open
coarse locus has literally no `N`-fixed point at every exceptional point of
`Theta_11`.

That limitation does not affect the non-unirationality theorem: it is applied
to the smooth projective equivariant `V14` compactification through the
resolved-map/b-complex formalism, not to the nonproper open moduli space by
inspection of its raw fixed scheme.
