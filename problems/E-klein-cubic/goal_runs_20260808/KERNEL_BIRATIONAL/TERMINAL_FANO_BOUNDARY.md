# Terminal Fano boundary

**Date:** 2026-08-08
**Status:** exact literature reduction, not an exclusion
**Scope:** the point-base output of the equivariant threefold MMP

Let `Z` be a terminal Fano threefold after geometric base change, with the
split `C11` acting faithfully and

```text
rank Cl(Z)^C11 = 1.
```

This is the geometric `G`-Fano condition used below.  It is stronger than
having only an arithmetic Picard-rank-one statement over `K`; the two must
not be conflated.

## 1. Gorenstein, geometric Picard rank greater than one

Assume `Z` is Gorenstein and `rho(Z)>1`.  Prokhorov, *G-Fano threefolds,
II*, Theorem 6.5 (using Theorem 1.2 and Namikawa smoothing), says that `Z`
is a degeneration, with the same explicit description, of one of the
following eight smooth types:

| geometric Picard rank | anticanonical degree | smooth type |
|---:|---:|---|
| 2 | 12 | `(2,2)` divisor in `P2 x P2`, or the indicated double cover of `V6` |
| 2 | 20 | three `(1,1)` divisors in `P3 x P3` |
| 2 | 28 | blowup of a quadric along a rational normal quartic |
| 2 | 48 | `(1,1)` divisor in `P2 x P2` |
| 3 | 12 | anticanonical double cover of `(P1)^3` |
| 3 | 30 | the indicated three divisors in `(P2)^3` |
| 3 | 48 | `(P1)^3` |
| 4 | 24 | `(1,1,1,1)` divisor in `(P1)^4` |

This is a finite deformation-type reduction, not a classification of the
order-eleven automorphisms of all degenerations.

It has two immediate consequences for the present group.

First, `Z` cannot be smooth.  In the smooth fibre `Cl=Pic` has rank at most
four, while a nontrivial rational representation of `C11` has dimension at
least `deg Phi_11=10`.  Hence `C11` acts trivially on `Pic`, contradicting
`rank Pic^C11=1`.

Second, every singular survivor in this branch is necessarily not
geometrically `Q`-factorial (in particular, nonfactorial) and satisfies

```text
rank Cl(Z) >= 11.
```

Indeed, `-K_Z` supplies a nonzero invariant line.  Any nontrivial part of
the rational `C11`-module `Cl(Z)_Q` is a sum of copies of the ten-dimensional
cyclotomic representation `Q(zeta_11)`.  If the action were trivial, the
invariant class group would have rank greater than one.  Thus at least one
cyclotomic summand occurs.  Geometric `Q`-factoriality would give
`Cl(Z)_Q=Pic(Z)_Q`, whose rank in the eight types is at most four, so it is
impossible.

For a multiplier-`9` descent, the order-five semilinear normalizer must in
addition furnish an order-five intertwiner on the cyclotomic isotypic part
which implements `zeta_11 |-> zeta_11^9`.  This rank-at-least-eleven,
geometrically non-`Q`-factorial,
eight-degeneration list is the precise surviving Gorenstein `rho>1`
configuration.

## 2. Rank-one addendum and where the classification stops

`RANK_ONE_TERMINAL_ADDENDUM.md` now gives a further all-degree necessary
condition under the geometric hypothesis `rank Cl(Z)^C11=1`.  In the
Gorenstein geometric-rank-one branch it leaves only

```text
smooth Klein cubic;
smooth genus-8 Pfaffian-Klein;
singular Q-factorial genus 6;
singular Q-factorial genus 7 with exactly 5 singular points;
singular Q-factorial genus 8 with exactly 5 singular points.
```

It also reduces the non-Gorenstein local-index basket to eleven explicit
multisets.  These are necessary lists, not exclusions.

The cited classification still does not cover all remaining cases:

* the singular genus `6,7,8` entries above;
* the surviving non-Gorenstein baskets;
* an arithmetic output known only to have invariant Picard rank one over
  `K`, without the geometric condition on `Cl(Z_bar)^C11`.

Prokhorov's survey *Equivariant minimal model program*, Section 11.6, states
that no complete classification of singular Gorenstein `G`-Fano
threefolds with `rho=iota=1` is known.  Section 12 emphasizes that the
non-Gorenstein class is much broader.  Thus the smooth rank-one
classification cannot legitimately be extended to these cases by citing a
smoothing: Namikawa supplies a smoothing of a terminal Gorenstein Fano, but
the sources used here do not supply a smoothing carrying the given `C11`
action together with its multiplier-`9` descent.

There is also no fixed-point shortcut at the prime `11`.  In
Prokhorov--Shramov, Proposition 8.1, the basket estimate proves that a
`p`-group acting on a non-Gorenstein terminal Fano has a fixed singular
point only for `p>=17`: there are at most fifteen non-Gorenstein points.
For `p=11`, an orbit of length eleven is still possible, so the stated
theorem does not apply.

Consequently, current low-dimensional Fano classification leaves the
following honest alternatives (see the addendum for the exact hypotheses):

```text
smooth geometric rank one        Klein cubic / Pfaffian-Klein branch
Gorenstein rho>1                  8 degeneration types, singular,
                                  geometrically non-Q-factorial,
                                  rank Cl >= 11
Gorenstein rho=1                  Klein/Pfaffian-Klein, or singular
                                  genera 6,7,8 in the addendum
non-Gorenstein terminal           11 necessary basket types in the addendum
```

None of these terminal results proves `ed_K(A)>=4`.
