# Residual target negative twist: focused algebraic audit

## Checked endpoint

For an irreducible positive-degree homogeneous target relation `H`, the retained target-chart
ring

`A_b = k[y_aff] / (dehom_b H)`

is a domain.  If every coefficient of a local quotient

`R_(a,b) * F_(a,b) = Q_(a,b)`

has its target-quadratic multiples extending to global regular functions on the integral
projective curve `V(H)`, then `R_(a,b) = 0`.  This is formalized coefficientwise in
`ProjectiveSpace.mvPolynomial_eq_zero_of_coeff_quadraticMultiples_extendToGlobal`.

Consequently all nonempty target-chart restrictions of `Q` vanish.  Projective chart-vanishing
descent then puts `Q` in the prime vertical ideal `(H(y))`, hence in `(F,H(y))`.  This uses no
radicality or primality assertion for the unsaturated affine complete-intersection cone
`(F,H(y))`.

The consumer
`residualTargetRelationMembershipAwayDiscriminantOn_of_negativeTwistGeometry` also installs the
automatic generic-fibre Artinian theorem, so its remaining target-geometry inputs are only:

1. projective integrality of `V(F,H(y))`; and
2. coefficientwise projective negative-twist gluing.

## Exact transition lemma still to instantiate

Fix a first chart `a` and two retained target charts `b,b'`.  Write

`z = Y_b' / Y_b`

in the common intrinsic function field of `V(H)`.  Bihomogeneity gives

`F_(a,b) = z^3 F_(a,b')`,

`Q_(a,b) = z Q_(a,b')`.

For local factors `R_(a,b)` and `R_(a,b')`, cancellation in the polynomial ring over the
function field should therefore give

`R_(a,b') = z^2 R_(a,b)`.

The cancellation is legitimate because:

- `z` is nonzero for retained charts; and
- discriminant avoidance makes the generic conic nonzero (indeed nonsingular), as provided by
  `sndConicAt_targetRelationChart_fraction_nonsingular`.

For every homogeneous target quadratic `P`, its chart representatives satisfy

`P_b = z^2 P_b'`.

Thus

`P_b R_(a,b) = P_b' R_(a,b')`

coefficientwise in the intrinsic function field.  Each coefficient has a regular representative
on every retained chart.  `ProjectiveSpace.HasRegularRetainedChartRepresentatives` is the exact
intrinsic compatibility predicate, and
`exists_globalSection_of_hasRegularRetainedChartRepresentatives` is the gluing endpoint.

The remaining plumbing is therefore not an affine-cone radical statement.  It is the explicit
chart-transition calculation above, followed by the canonical comparison between global
sections and the retained-chart fraction field.

## Mechanical checks

The focused Lean modules and their axiom audits use only the standard Mathlib axioms
`propext`, `Classical.choice`, and `Quot.sound`.  A fresh aggregate rebuild must be rerun after
the concurrently edited projective function-field/comparison modules stabilize.
