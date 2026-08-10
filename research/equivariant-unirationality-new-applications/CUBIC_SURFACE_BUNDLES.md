# Cubic-surface bundles

## Executive result

The packet now contains an infinite family of smooth unirational cubic-surface
bundle threefolds satisfying Condition (A) and carrying no higher-Amitsur
obstruction, but failing weak versality.

For every odd \(n\ge3\), put

\[
G_n=C_3\times D_{2n},
\qquad |D_{2n}|=2n,
\]

and let \(G_n\) act on the bidegree-\((2n,3)\) hypersurface
\(\mathcal X_{n,F_0,F_1}\subset\mathbf P^1\times\mathbf P^3\) defined in
`THEOREM_CUBIC_SURFACE_BUNDLE_FAMILY.md`. For parameters in a nonempty open
set,

\[
\boxed{
\mathcal X_{n,F_0,F_1}
\text{ is unirational but not weakly }G_n\text{-versal}.}
\]

## Why this family was selected

The construction aligns all of the obstruction criteria without a large
search:

| feature | value |
|---|---|
| ordinary geometry | smooth cubic-surface bundle with three sections; unirational |
| finite group | explicit \(C_3\times D_{2n}\) |
| central element | the fiberwise order-three element \(z\) |
| central fixed geometry | one smooth curve of genus \(4n-2\), plus \(4n\) points |
| deeper fixed locus | empty for the full group |
| Condition (A) | passes because \(n\) is odd and all abelian subgroups of \(D_{2n}\) are cyclic |
| universal torsor | exists equivariantly |
| higher Amitsur | zero in every degree |
| CAS | only finite character and count checks |

The use of an order-three central element is deliberate. For a diagonal
order-three action on a cubic surface, the projective fixed locus contains a
line; intersecting the bundle equation with this line produces a curve whose
genus grows linearly with the base degree. At the same time, the invariant
fiber monomials \(U^3,V^3\) provide rational sections.

## Relation to standard cubic-bundle literature

The main recent cubic-surface-bundle papers focus on stable rationality,
unramified cohomology, and Brauer groups. They provide a rich supply of
nonequivariant obstructions but do not decide the weak versality of the
explicit finite-group actions here. The present construction is instead
engineered so that ordinary unirationality is immediate from a generic
rational point while equivariant domination is impossible.

## Reusable template

The proof abstracts as follows. Let a finite group \(H\) act on a rational
curve \(B\) with no global fixed point but with fixed points for every
abelian subgroup. Let \(z\) be central of prime order \(p\), acting on the
fiber of a degree-\(p\) hypersurface bundle so that one projective eigenspace
is a line. If

1. the intersection of the bundle with that line is a smooth curve of
   positive genus;
2. all other \(z\)-fixed components are zero-dimensional;
3. the bundle has a rational section;
4. the full group has no fixed point;

then the central fixed-locus theorem excludes weak versality while the
section can supply ordinary unirationality. The family in the theorem is the
first exact implementation with \(p=3\).

## Boundary

No claim is made that every cubic-surface bundle of bidegree \((2n,3)\) is
unirational or has the obstruction. Both conclusions use the displayed
subfamily. No claim is made about stable rationality or the equivariant
intermediate-Jacobian torsor.
