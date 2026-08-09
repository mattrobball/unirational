# Bypass classification on the normalized graph

## 1. Decision table

The first exceptional plane contains many invariant curves.  Their status is
controlled by how they occur in the normalized graph, not by invariance alone.

| proposed object | exact normalized-Rees conclusion | status for actual global ideal |
|---|---|---|
| involution-fixed bypass line `P(chi_s⊕chi_r)` | can occur as an actual curve fiber of a divisor centered on the incident source curve; cannot occur as a point-centered line-valued Rees divisor | not excluded |
| faithful `V4` invariant conic | a weak conic divisor mapping to a target line contracts; a faithful curve component or fixed slice in a surface remains possible | undecided |
| residual-`C3`-stable higher-degree curve | any point-centered curve component is finite over its target curve; a weak divisor with curve target contracts | undecided |
| component joining only two character directions | realized by the exact ordinary bypass model `(v,w)` | not uniformly excluded |
| component mapping to `L_z` | possible as a curve; impossible as a point-centered divisor | curve family retained |

## 2. Three geometrically different bypasses

A phrase such as “the bypass line occurs” can mean three different things.

### A. Ordinary fixed slice

A Rees divisor centered on an incident source curve has a special fiber over the
marked point.  That fiber can be the bypass line and can map nonconstantly to
`L_z`.  The local ideal `(v,w)` is the exact model.

### B. Intrinsic point-fiber curve

The normalized graph may contain a curve component over the marked point.  The
finite normalization map identifies it with a finite cover of its target curve.
It is not a Rees valuation because it has codimension two in `Gamma`.

### C. Fixed slice in a stable surface

A point-centered Rees divisor must be surface-valued and generically faithful
under `V4`.  Its `z`-fixed locus may contain a curve mapping to `L_z`.  The
surface is the Rees carrier; the curve is an essential fixed slice if it is a
maximal component of the fixed locus.

Only A and C can appear as curves inside divisorial carriers.  B is a genuine
fiber component without a corresponding Rees valuation.

## 3. Why the line is not excluded

For
\[
J=(v,w)
\]
the normalized blowup is the ordinary blowup of the `u`-axis.  The special
fiber over the origin is
\[
\mathbf P(\chi_s\oplus\chi_r)
\]
and maps isomorphically to `L_z`.  This pair is `V4`-equivariant after the
standard common projective character twist, and its image lies on the Klein
cubic.

Thus neither the `V4` character decomposition nor the equation `F(p)=0`
excludes the bypass.  Residual `C3` symmetry would couple it to two conjugate
bypasses; it does not turn the local mechanism into a contradiction.

## 4. Why the weak-line determinant is insufficient

The pair
\[
(uw+v^3,uv+w^3)
\]
has a weak base line on the first `P2`.  The determinant `W^4-V^4` proves that
the next blowup resolves the weak ideal generically.  The resulting divisor is
nevertheless contracted by the normalized graph because its only target
parameter is the coordinate on `L_z`.

This gives the exact rule:

```text
nonzero weak determinant
    proves generic resolution on that refinement;
it does not prove Rees-divisor survival.
```

## 5. Why the conic is not yet a carrier

For
\[
h=u^2+v^2+w^2,
\qquad
(hv+u^3w,hw+u^3v),
\]
the weak base conic has determinant `U^3(V^2-W^2)`.  The associated divisor
again contracts because the target is one-dimensional.

Therefore the abstract conic
\[
u^2+v^2+w^2=0
\]
and its faithful `V4` action do not by themselves produce an actual conic
carrier.  To retain a conic as an intrinsic curve, one must find it as a curve
component of the normalized point fiber or as a fixed/stable slice in a
surface-valued Rees divisor.

## 6. Higher-degree and two-direction components

The same residue-dimension dichotomy applies to every invariant curve `H` in
the first `P2`.

- If blowing up `H` gives a valuation whose target residues generate only a
  curve field, the divisor contracts.
- If the target residues generate a surface field, the divisor survives, but
  it is generically faithful and is not itself an involution-fixed bypass.
- A curve component may still survive in the normalized point fiber and map
  finitely to a target curve.

Hence no degree bound for invariant curves follows from Rees theory alone.
The unknown special landing ideal must provide the bound.

## 7. Final bypass statement

The strongest unconditional statement is:

> The genuine normalized graph has no point-centered line-valued Rees divisor.
> Every line-valued bypass is a curve: an ordinary special fiber, an intrinsic
> point-fiber component, or an involution-fixed slice in a surface-valued stable
> divisor.

This reduces the exceptional-carrier problem from arbitrary point-centered
ruled divisors to a finite curve-and-surface decomposition of the actual
normalized fiber, but does not eliminate the bypass family.
