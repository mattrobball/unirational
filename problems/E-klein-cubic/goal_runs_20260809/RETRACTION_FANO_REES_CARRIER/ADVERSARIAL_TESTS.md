# Adversarial audit

## 1. Confusing the two Fano curves

**Attack.** Identify the retraction boundary with Roulleau's genus-two curve.

**Resolution.** The genus-two component parametrizes lines exchanged by the
involution and generically disjoint from the plus-plane.  A fixed boundary
line containing `x in E_t` lies on the residual genus-four curve `R_t`.

## 2. Arbitrary resolution dependence

**Attack.** The claimed carrier may be an artifact of blowing up a chosen
curve.

**Resolution.** The line carrier is defined by the normalized Rees algebra of
the intrinsic Pluecker ideal

\[
J_{line}=((x_iT_j-x_jT_i)/F)|_B.
\]

It is gauge-independent and is the normalized graph of the actual line map.

## 3. A birational elliptic carrier

**Attack.** A component above `E_t` might be birational to `E_t`.

**Resolution.** Such a component gives a nonconstant morphism from an elliptic
curve to the Klein Fano surface.  The Fano surface contains neither rational
nor elliptic curves.  If the component is involution-fixed, the sharper degree
formula through `R_t -> E_t` also forces even source degree.

## 4. Paired nonfixed carriers

**Attack.** The involution may exchange two components above `E_t`, so neither
maps to `R_t`.

**Resolution.** This is a genuine surviving alternative.  The packet does not
claim that every component is fixed.  Fixed components are finite covers of
`R_t`; nonfixed components occur in pairs.  In the ruled curve-image branch,
all involution carriers must be of the paired type.

## 5. Line map collapsed on the entire base

**Attack.** `Q` could be proportional to `x` on an irreducible `B`.

**Resolution.** Degree forces every Pluecker minor to be divisible by `F`.
After projective-normality lifting and a gauge change, `Q=FV`; reduction of the
landing identity modulo `F` then contradicts `gcd(H,F)=1`.

## 6. Collapsed component of a reducible base

**Attack.** One component of a reducible `B` may be a fixed component of the
Pluecker system.

**Resolution.** Not excluded.  The noncollapse theorem is asserted for an
irreducible full base.  Componentwise collapse is retained for the next
conductor analysis.

## 7. One-dimensional line-map image

**Attack.** The map need not dominate the Fano surface.

**Resolution.** This is classified, not discarded.  The graph is birational
to the universal ruled surface over a faithful `G`-curve `Sigma`, with

\[
[\Sigma]=nC,\qquad d=5n+1,\qquad n\ge2,\qquad g(\Sigma^\nu)\ge26.
\]

## 8. Nonfaithful action on the image curve

**Attack.** Hurwitz need not apply if `G` acts through a quotient.

**Resolution.** The kernel is normal in the simple group `G`.  If the whole
group acted trivially, every parametrized line would be a `G`-stable
2-dimensional subspace of the irreducible module `W_5`.  Hence the action is
faithful.

## 9. Fractional invariant Neron--Severi generator

**Attack.** A `G`-invariant curve could have class `qC` with nonintegral `q`.

**Resolution.** Intersections with `C` and with a genus-two curve are `5q` and
`2q`; both are integral, so `q` is integral.

## 10. Universal-family degree has extra multiplicity

**Attack.** The ruled universal family may map with degree greater than one to
`B`, invalidating `d-1=5n`.

**Resolution.** The normalized graph records one selected line through a
general source point.  Over a general line in the curve image its fibre is a
dense open subset of that line, and projection to `B` is birational by the
graph property.  Thus no extra generic evaluation degree occurs.

## 11. Singular image curve

**Attack.** The image curve need not be smooth, so its arithmetic genus does
not bound the group action correctly.

**Resolution.** The action is taken on the normalization, whose genus is at
most the arithmetic genus.  The faithful lower bound 26 therefore still
excludes `n=1`.  At `n=2` equality forces smoothness.

## 12. The original elliptics as Hodge carriers

**Attack.** The 55 elliptics already have positive genus, so no new carrier is
needed.

**Resolution.** Their residual differential character is `sign`, while the
`t=+` restriction of `W_5` is `triv+std`; the Hom space is zero.  The
fixed genus-four curve has character `triv+sign+std` and supplies two copies by
Frobenius reciprocity.

## 13. Claimed headline implication

**Attack.** Treat the dichotomy as an exclusion of retractions or all ambient
maps.

**Resolution.** Neither branch has yet been contradicted.  The exact remaining
target is the conductor/Hurwitz compatibility of the singular base and its
normalized Pluecker graph.
