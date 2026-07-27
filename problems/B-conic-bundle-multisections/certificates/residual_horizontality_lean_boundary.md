# Residual horizontality: exact Lean boundary

This note audits
`ResidualHorizontalityLine.det_residualYCoordsOn_ne_zero` against Section 4 of
`all_smooth_tangent_residual_theorem.md`.  It records the mathematical proof that the current
strengthened statement is meant to formalize and separates it from two section-degeneracy bugs
that are now ruled out in Lean.

## 1. The current hypotheses are mathematically sufficient

Let `S_L` be the vertical surface and let `T` be the closure of the tangent-residual image of the
chosen stereographic chart.  The assumptions `v 2 != 0` and
`lineStereoPolarForm ... != 0` make the chart dominant onto `S_L`; in particular the composite to
`P^2_x` is dominant.  This is now a theorem, not an informal assertion:

```
det_stereoFirstCoordsOn_ne_zero_of_smooth
```

in `ResidualHorizontalityLineAudit.lean`.  Its proof carries the equation into the frame of `L`
and applies the already proved coordinate-line stereo-Jacobian theorem.

Thus `T` is an integral surface dominating `P^2_x`, hence a prime divisor of the smooth
threefold `X`.  Grothendieck--Lefschetz gives

```
Pic(X) = Z H_x + Z H_y.
```

Write `[T] = a H_x + b H_y`.  The degree of `T -> P^2_x` is `3b`, because `H_y` has degree three
on a plane-cubic fibre.  On the other hand, `S_L -> P^2_x` has degree three, so the degree of its
image `T -> P^2_x` is a positive divisor of three.  It follows at once that it is three and that
`b = 1`.  Notice that this also forces `S_L -> T` to be birational.  Therefore the source's extra
conditions

1. `C cap L` reduced, and
2. `[-2]` injective on `C cap L`

are convenient sufficient conditions for birationality, but are not needed for horizontality once
the Picard calculation is available.

Now suppose the image of `T` in `P^2_y` were a curve.  A general conic fibre over a point outside
that curve is disjoint from `T`, so `2a = 0`, hence `a = 0`.  Thus `[T] = H_y`.  The restriction
sequence

```
0 -> O(-2,-2) -> O(0,1) -> O_X(0,1) -> 0
```

and `H^1(P^2 x P^2, O(-2,-2)) = 0` show that the section cutting out `T` is the restriction of a
constant linear form on `P^2_y`.  Consequently `T` is `X` intersected with one constant line
`M`.  Since `T -> P^2_x` has degree three, its generic fibre consists of the full three-point
tangent-residual image, so `delta_C(L) = M`.  This contradicts
`ResidualLineNonconstantOn`.  Hence the residual image dominates `P^2_y`.

In characteristic zero, dominance of the rational map from the two-parameter chart to `P^2_y` is
equivalent to nonvanishing of its projective Jacobian determinant.  This is the desired theorem.

## 2. Why an algebraic contrapositive does not close with the current API

The existing `AlgebraicIndependenceJacobian` module proves only the direction

```
nonzero projective Jacobian -> no nonzero homogeneous relation.
```

The proposed contrapositive `det = 0 -> constant residual line` needs two additional ingredients:

1. the converse Jacobian criterion in characteristic zero, turning determinant zero into a
   homogeneous relation (or, equivalently, an image curve); and
2. the divisor argument above, turning an image curve into a *constant line*.

The second step is the substantive one.  A varying line can contain three varying points of a
fixed plane curve, so the polynomial identity saying that every residual point lies on
`delta_C(L)` does not by itself imply that `delta_C(L)` is constant.  Excluding this possibility is
exactly what `Pic(X) = Z H_x + Z H_y` does.  There is currently no Grothendieck--Lefschetz theorem,
scheme Picard group of this hypersurface, divisor-class intersection API, or the required
restriction-sequence cohomology in this project or in the imported Mathlib surface.

For a future formalization, the cleaner target is likely scheme dominance (or directly the absence
of a homogeneous relation) rather than the determinant.  That avoids proving the reverse Jacobian
criterion merely to translate a geometric Picard proof back into coordinates.  The downstream
chart-injectivity argument already consumes absence of homogeneous relations.

## 3. Necessary section hypotheses already audited in Lean

The statement is false if either section hypothesis is dropped.

* If `lineStereoPolarForm = 0`, the stereo point is projectively the original Tsen section and is
  independent of the free parameter.
* If `v 2 = 0`, both the section and every stereo direction lie in `{x_2 = 0}`.  The theorem
  `det_stereoFirstCoordsOn_eq_zero_of_v_two_eq_zero` proves that the source projective Jacobian is
  then zero.

With both hypotheses present, `det_stereoFirstCoordsOn_ne_zero_of_smooth` proves the complementary
positive statement.  Both audit theorems are axiom-clean.

## 4. Honest remaining boundary

No counterexample exists to the strengthened determinant statement under its current hypotheses.
The remaining `sorry` cannot be removed by threading another open condition on `L`: it represents
the Grothendieck--Lefschetz/Picard vertical-divisor exclusion above (plus, if the determinant remains
the public target, the converse characteristic-zero Jacobian criterion).  Adding conditions (2)
and (3) from the source does not remove that Picard step; the source itself uses those conditions
before and independently of its horizontality argument.
