# Global coupling of the 55 involution and 55 `V4` fibers

## 1. Equivariant normalized graph

The primitive restricted ideal `J` is `G`-stable.  Therefore the normalized
Rees algebra and normalized graph carry canonical `G`-actions.  Both
\[
\pi,q:\Gamma\to X
\]
are equivariant.  In particular, `G` transports:

- ordinary valuations over fixed curves;
- Rees valuations;
- curve and surface components of normalized point fibers;
- fixed-locus components;
- base multiplicities and target degrees.

The carrier selected over one involution is therefore not an independent
choice.

## 2. Ordinary carrier orbits

The 55 curves `E_t` form one `G`-orbit, as do the 55 lines `L_t`.  Hence all
ordinary elliptic carriers have the same:

- dimension (curve or surface);
- source degree in the curve case;
- target type and target degree;
- generic base order;
- Stein degree in the surface case.

The accepted parity theorem fixes their target type: every ordinary carrier
above an `E_t` is line-valued.

The same orbit principle applies to strict or ordinary carriers above `L_t`,
although their target degrees are not determined.

## 3. `V4` point-fiber orbits

The 55 marked `V4` configurations are transported by `G`.  Within one fiber,
the residual `C3` cycles `z,s,r`.  Thus a component not invariant under this
`C3` occurs in an orbit of three, with equal residue dimension, target degree,
and base multiplicity.

For a point-centered Rees divisor, the target is a surface and the generic
`V4` action is faithful.  Its three involution-fixed curve slices are cyclically
coupled.  For a point-fiber curve, the target curve and its subgroup action are
likewise transported.

This is the correct locus for residual phase data: phases decorate actual
curve maps or fixed slices, not abstract normal-cone states.

## 4. Incidence coupling

At a type-I point, the closures of the ordinary carriers above
`E_z,L_s,L_r` meet the normalized point fiber.  At a type-II point, the three
ordinary elliptic carriers meet it.  These attachments are `G`-equivariant and
satisfy every marked specialization constraint already accepted in the fixed
network packet.

However, the normalized fiber can contain several curve orbits and faithful
surface components.  Equivariance alone does not determine which component
contains each attachment.  Therefore the 55-incidence network couples the
local choices but does not yet propagate a unique value.

## 5. Mapwise finite profile theorem

For one fixed hypothetical map, define its carrier profile to consist of:

1. the dimensions and maps of the 110 ordinary fixed-curve carriers;
2. the `G`-orbits of point-centered Rees divisors;
3. the `G`-orbits of normalized point-fiber curves;
4. the involution-fixed curve slices in stable surfaces;
5. all attachment and marked specialization data;
6. all base orders and polarization corrections.

This profile is finite because `Gamma` and its finite-group fixed loci are
Noetherian.  The profile is determined by its data over one involution and one
representative of each marked `V4` orbit, together with stabilizer actions.

This is a genuine finite theorem **after the map is fixed**.

## 6. Why no uniform finite profile theorem follows

The theorem does not bound, uniformly over all homogeneous `G`-stable landing
ideals:

- the number of Rees valuations;
- the number or degree of normalized fiber curves;
- the degree of finite maps carried by a fixed curve;
- the number of stable surface components;
- the base multiplicities.

The exact local families `(v^m,w^m)` already show unbounded carrier-map degree
on one fixed normalized source carrier.  Monomial ideals with the same first
normal state can have multiple Rees valuations.  Thus Noetherianity for each
ideal is not a uniform classification theorem.

## 7. Conditional propagation theorem

The accepted marked-incidence propagation becomes valid on the actual graph
under the following intrinsic hypotheses:

1. every ordinary branch attachment lies in a unique landing-horizontal fixed
   carrier component;
2. the union of those components is connected through intersections fixed by
   the relevant involutions;
3. no attachment is rerouted through a faithful surface without meeting the
   required fixed slice;
4. the fixed carrier maps have the marked target specializations prescribed by
   the transition packet.

These conditions refer only to `Gamma` and are refinement-invariant.  They are
not consequences of connectedness of the total fiber.

## 8. Exact global stop

The global `G`-network reduces the missing information to one type-I and one
type-II completed normalized-Rees calculation, followed by orbit propagation.
But because the actual completed ideals are not currently available, neither a
unique profile nor a uniform finite profile list is proved.

The global exit remains

```text
EXCEPTIONAL-CARRIER-INTEGRATION-UNDECIDED
```
