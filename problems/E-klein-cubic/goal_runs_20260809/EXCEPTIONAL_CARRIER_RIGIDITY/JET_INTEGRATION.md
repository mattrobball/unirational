# Integration of formal normal jets

## 1. The five distinct layers

The following objects must not be identified.

| layer | object | what it records | what it does not prove |
|---|---|---|---|
| associated graded | first nonzero classes `in(p_i)` in a normal filtration | character and order | survival of any prime |
| normal-cone map | rational map on `P(N_{S/X})` or on a component of a normal cone | initial target ratios | regularity after normalization |
| ordinary carrier center | center `K_S` of the ordinary valuation on `Gamma` | the intrinsic quotient of the ordinary normal parameter | that a later weak divisor survives |
| normalized-Rees component | prime divisor or fiber component of `Gamma` | actual component selected by the ideal | smoothness or a chosen section |
| actual landing map | restriction of `q:Gamma→X` | genuine morphism satisfying the Klein equation | existence of a global covariant |

## 2. Ordinary-jet integration theorem

Let `S=E_t` or `L_t` be generically contained in the restricted base scheme.
Let
\[
D_S=\mathbf P(N_{S/X}),
\qquad
k(D_S)=\mathbf C(S)(z).
\]
The first nonzero normal terms of the tuple define a rational joint map
\[
\alpha_S:D_S\dashrightarrow S\times X.
\tag{2.1}
\]
Let `L_S` be the function field of the closure of its image.

Let `K_S` be the center of the ordinary valuation on the normalized graph.
Then
\[
L_S\subset\mathbf C(K_S)\subset\mathbf C(S)(z),
\qquad
[\mathbf C(K_S):L_S]<\infty.
\tag{2.2}
\]
Consequently there is a canonical rational factorization
\[
D_S\dashrightarrow K_S\xrightarrow{q}X,
\tag{2.3}
\]
and `q` is an actual morphism.

This is the precise integration theorem.  The formal ordinary jet cannot
disappear completely: it determines the target residue field and hence the
center `K_S`.  What may disappear is a proposed **additional** carrier obtained
by blowing up a prime in the weak base locus of (2.1).

## 3. Curve versus surface outcome

There are exactly two ordinary outcomes.

### Curve outcome

If `trdeg_C L_S=1`, then
\[
\mathbf C(K_S)=\mathbf C(S).
\]
Thus `K_S` is birational to `S`, and the normal direction has been forgotten by
the joint graph.  The integrated morphism is literally a morphism from a curve
birational to the original fixed curve.

### Surface outcome

If `trdeg_C L_S=2`, then
\[
\mathbf C(K_S)=\mathbf C(S)(z).
\]
The ordinary valuation is a Rees valuation, `K_S` is birational to `D_S`, and
its map to `X^t` is a surface-to-curve morphism.  Its one-dimensional quotient
is canonically obtained by Stein factorization.  No section of the ruled
surface is intrinsic.

## 4. Finite normal branch over the joint jet image

The center need not be the ordinary normalization of the joint image.  It is a
finite normal factor over that image inside the residue field.

For example, for the ideal
\[
I=(v^3,w^3)
\]
one has
\[
\overline{I^n}=(v,w)^{3n}.
\]
The normalized blowup is therefore the ordinary blowup of `(v,w)` (the relevant
graded algebra is a Veronese of the Rees algebra of `(v,w)`).  Its exceptional
fiber has function field `C(V/W)`, while the target map
\[
[V:W]\longmapsto[V^3:W^3]
\]
generates only `C((V/W)^3)`.  The carrier retains a degree-three normal branch
which the joint target image forgets.

This example answers two adversarial questions simultaneously:

- two different normal jets can use the same normalized carrier;
- the map on that carrier is not determined by the carrier alone.

## 5. Integration along the involution plus-plane

The accepted transition theorem gives, along the plus-plane containing `E_t`,
a first nonzero **odd** normal jet with target in `L_t`.  Applying (2.3):

1. an actual canonical ordinary carrier over `E_t` exists;
2. it has dimension one or two;
3. its actual target is `L_t`;
4. if it is a curve, it is birational to `E_t` and carries a genuine
   residual-`S3`-equivariant morphism `E_t→L_t`;
5. if it is a surface, its Stein quotient is a curve mapping to `L_t`.

Nothing in this integration produces an elliptic-target multiplier.  In
particular it does not realize `[-5]`.

## 6. Criterion for an arbitrary formal prime

Let `H` be a homogeneous prime in a normal-cone or weak-transform base locus,
and let `v_H` be the divisorial valuation created by blowing up `H`.  Then:

```text
H lifts to a divisor of the normalized graph
    iff
trdeg_C of the joint initial target ratios at v_H is 2.
```

If the transcendence degree is one, the refinement divisor maps to a curve on
`Gamma`.  If it is zero, it maps to a point.  Thus compatible character data
and a nonzero normal determinant are only preliminary tests.

## 7. Explicit failures of naive integration

The local pairs
\[
(uw+v^3,uv+w^3)
\]
and
\[
((u^2+v^2+w^2)v+u^3w,
 (u^2+v^2+w^2)w+u^3v)
\]
create, respectively, a weak bypass-line divisor and a weak conic divisor after
the first point blowup.  Both divisors map only to `L_z`; both therefore
contract to curves on the normalized graph.

Accordingly:

- a formal state can lose a proposed carrier under normalization;
- two different weak primes can contribute to the same type of actual curve
  carrier;
- the normal-cone incidence complex need not equal the actual carrier complex.

## 8. Scope

The theorem integrates the ordinary jet and gives an exact test for every
specified valuation.  It does not enumerate the valuations or curve components
of the unknown genuine completed ideal.  That enumeration is the remaining
local algebraic theorem.
