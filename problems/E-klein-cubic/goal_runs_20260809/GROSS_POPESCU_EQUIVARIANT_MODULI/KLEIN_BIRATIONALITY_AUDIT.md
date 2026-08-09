# Audit of the birational map to the Klein cubic

## Where equivariance is lost

Let `X=V14`, let `K` be its Pfaffian cubic partner, and let `Gamma` be the
common Palatini quartic in `P(V_+^*)`.  A point `p in X` represents a ruling
line `L_p`; a point `q in K` represents a center line `N_q`.  Both line
families sweep `Gamma`.

For a generic hyperplane `Pi subset P(V_+^*)`, Gross--Popescu define

```text
eta_Pi(p)   = L_p intersect Pi,
gamma_Pi(q) = N_q intersect Pi,
chi_Pi      = gamma_Pi^{-1} o eta_Pi : X -->> K.
```

The line families and `Gamma` are equivariant, but the selected slice is not.
For every `g in G`,

```text
g eta_Pi       = eta_{gPi} g,
g gamma_Pi     = gamma_{gPi} g,
g chi_Pi       = chi_{gPi} g.
```

Thus a fixed `chi_Pi` is equivariant only when the hyperplane is `G`-stable.

## No fixed hyperplane

A `G`-stable hyperplane in `P(V_+^*)` is an invariant line in `V_+`.  The
even Weil module is irreducible of dimension six, so no such hyperplane
exists.  This is the precise structural content behind Gross--Popescu Remark
2.8; it is not a random-hyperplane failure.

There could in principle be nonconstant equivariant maps into the hyperplane
parameter space.  What cannot exist is a rational choice that turns the above
construction into a `G`-birational map from `V14` to the standard Klein
action: the two actions are known not to be `G`-birational, and the standard
Klein action is `G`-birationally superrigid.

## Retaining the parameter

Before choosing `Pi`, the incidence built from the two tautological rank-two
bundles is equivariant for the central extension `SL2(F11)`.  Projectivizing
produces the common Palatini geometry and an equivariant birationality between
projective bundles.  Adding the hyperplane/projective representation factor
therefore yields a twisted stable birationality, not a birational map between
the bases.

This is the same geometric phenomenon isolated by Tschinkel--Zhang.  The
order-two Schur factor is conceptual: `V_+` is a linear module for
`SL2(F11)`, while only `P(V_+)` is a `PSL2(F11)`-variety.  On a generic twist
the projective factor becomes a Severi--Brauer form carrying that order-two
class.

## Averaging hyperplanes: the exact parity obstruction

The universal incidence does produce controlled correspondences after one
cuts the common Palatini quartic by a `G`-stable divisor `D` of degree `d`.
Both projections then have generic degree `d`, because the ruling and center
fibers are lines.

However, `d` is necessarily even.  The equation of a stable divisor spans a
one-dimensional representation of `SL2(F11)`.  This group is perfect, so the
character is trivial, while its central element acts on a degree-`d` equation
as `(-1)^d`.  Hence `d` is even.  An orbit product of hyperplanes therefore
replaces the noninvariant degree-one slice by an even-degree multisection.
The Palatini quartic itself contains every relevant line and gives no finite
cut.  See `UNIVERSAL_INCIDENCE_PARITY.md` for the full argument and the
generic Severi--Brauer interpretation.

## What is and is not produced

The uncut universal incidence has positive-dimensional fibers.  It is not a
dominant equivariant rational map `V14 -->> K`.  Stable divisor cuts can give
finite correspondences, but this construction forces both degrees to be even,
so it gives neither an odd-degree zero-cycle on the generic Klein twist nor a
secant/residual route that cancels the order-two Schur obstruction.

This parity theorem concerns the Gross--Popescu/Palatini universal incidence;
it does not exclude every conceivable correspondence between the two
threefolds.
