# Consequences for the standard Klein action

## Two actions on the same abstract birational variety

Gross--Popescu provide an abstract birational map from the modular `V14` to
the Klein cubic.  Transporting the natural modular action through a chosen
`chi_Pi` gives a birational `G`-action on the underlying Klein function field.
It is not the standard regular action

```text
G subset Aut(K) subset PGL(V_-).
```

Thus one must distinguish:

1. the standard Klein action on the five-dimensional honest `G`-module
   `V_-`;
2. the transported modular action arising from the projective six-dimensional
   spin/Weil module and the `V14` model.

## No birational conjugacy

The standard Klein action is `G`-birationally superrigid.  A `G`-birational
map from the `V14` Mori fiber space to the standard Klein Mori fiber space
would therefore have to be square/biregular, which is impossible: the Fano
indices, degrees, and anticanonical models differ.  Hence the two actions are
not `G`-birationally conjugate.

This remains true after precomposing either action by an automorphism of `G`.
Such a relabeling does not change the image subgroup or the superrigidity
statement.  The unique involution class also retains the visible
`elliptic-sextic+points` versus `elliptic-cubic+line` diagnostic.

Changing left/right marking conventions, symmetric theta characteristic,
Heisenberg lift, dual six-dimensional Weil module, or Galois/outer convention
changes coordinates or relabels `G`; it keeps the natural action in the
`V14` equivariant-birational class and does not turn it into the standard
Klein class.

## Correspondence audit

Retaining the hyperplane or tautological vector-bundle parameter gives a
canonical equivariant stable correspondence.  It has positive-dimensional
fibers and supplies no rational section.  No projection in the construction
has been shown to have odd finite degree; no odd-degree zero-cycle on the
generic standard Klein twist follows; and no secant/residual operation removes
the Schur obstruction.

Averaging hyperplanes does not help: a formal sum or invariant linear system
is not a selected hyperplane, and the Fano--Iskovskikh map requires an actual
rational point of the parameter space.

## Headline conclusion

The modular interpretation gives a new negative theorem for the natural
level action and a clean structural separation from the standard Klein
action.  It gives neither a positive linear-source map nor a negative
fixed-locus bridge for the standard action.  Therefore the strongest valid
headline statement is

```text
GP-MODULAR-ACTION-IS-V14-NOT-KLEIN,
Problem-E standard Klein G-unirationality: OPEN.
```
