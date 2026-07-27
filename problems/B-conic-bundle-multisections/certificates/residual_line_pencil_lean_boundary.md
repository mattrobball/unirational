# Residual-line pencil lemma: checked resolution

This note records the status of
`Standard.exists_pencil_of_hasCommonResidualLineMap`.  The theorem is now proved axiom-clean by
the Hesse normal-form and projective residual-rigidity route summarized below.

## What is now checked in Lean

`Standard/ResidualLineMapDefinitions.lean` contains exact equivariance lemmas for a simultaneous
invertible linear change of coordinates:

* `residualLinearFormOn_aeval_linearSubst`;
* `hasCommonResidualLineMap_aeval_linearSubst`;
* `residualLineMapBasepointFree_aeval_linearSubst`.

These lemmas transport both hypotheses to Hesse coordinates without an additional geometric axiom.

`HesseResidualCertificate.lean` checks, over an arbitrary commutative ring, the three polynomial
identities for the Hesse cubic

```text
U^3 + V^3 + W^3 - 3 lambda U V W
```

on the affine dual chart `W = s U + t V`.  After removing the common scalar
`27 (lambda^3 - 1)`, the residual-line map is represented by

```text
s^4 - 2 s t^3 + 2 s + 3 lambda t^2,
t^4 - 2 s^3 t + 2 t + 3 lambda s^2,
1 + 2 s^3 + 2 t^3 + 3 lambda s^2 t^2.
```

The module is closed by `ring`; it has no local axioms or `sorry` declarations.
It also proves `coordinateLine_fixed` and `cubeRootLines_fixed`: the coordinate line and every
line `W = sU+tV` with `s^3=t^3=-1` are fixed.  These two statements are the compact
Lean-checkable form of the ten Hesse-configuration fixed-line equations.  They verify that the
Hesse pencil has the expected fixed lines; they do not prove that every cubic with those fixed
lines belongs to that pencil.

`HesseFullResidualRigidity.lean` then internalizes the triangular part of the full-map
certificate.  It reconstructs all 45 coefficients of the three universal residual quartics,
extracts them from functional equality by exact quartic interpolation, and replays explicit
Groebner combinations with `linear_combination`.  Its endpoint

```text
eq_hesse_of_fullResidual_eq
```

says that equality with one nonzero scalar multiple of the normalized Hesse residual triple
forces

```text
b=c=e=h=i=j=0,  d=a,  k=a,  f=-3*lambda*a.
```

`HesseProjectiveResidualRigidity.lean` removes the assumption that the scalar has already been
chosen.  It checks the 88 cross-product coefficients by two exact degree-eight reconstruction
identities, extracts them by interpolation on 45 integral points, and replays a sparse left
inverse over `QQ[lambda]`.  The reusable theorem

```text
coefficients_eq_zero_of_projective_hesse
```

proves global scalar rigidity for three arbitrary quartics.  The endpoint

```text
eq_hesse_of_projective_fullResidual_eq_at_origin
```

specializes this to the universal residual triple: the two functional cross-product identities
with the Hesse triple and nonvanishing of the `W` coefficient at `(s,t)=(0,0)` recover the Hesse
cubic shape.  No smoothness condition on `lambda`, localization, saturation, generic-rank
argument, or external axiom occurs in these Lean theorems.

## What the external probe establishes

Run:

```sh
python3 certificates/residual_line_pencil_probe.py
```

The script checks the universal affine quartic calculation, the three Hesse formulas, and the ten
fixed Hesse-configuration lines.  It also finds rank eight for the twenty fixed-line equations at
one smooth Hesse point over `F_7`.  Rank eight is only a tangent-space/local calculation.  It is
not a global ideal-membership, radical, saturation, or component-classification certificate.

Attempts to saturate both the full twenty-equation ideal and an eight-equation rank-independent
subsystem did not terminate in a practical time.  Consequently no output from those attempts is
retained or cited as evidence.

## Exact full-map rigidity certificate

The fixed-line saturation above was superseded by a stronger calculation.  Run:

```sh
python3 certificates/hesse_full_residual_map_certificate.py
```

This performs two exact ideal comparisons.

1. For arbitrary bivariate quartics `P0,P1,P2`, the 88 coefficients of
   `P0*Q2-P2*Q0` and `P1*Q2-P2*Q1` generate exactly the 44-codimensional linear ideal
   `P = rho*Q`, with `rho` the constant coefficient of `P2`.  This holds over
   `QQ[lambda]`, with no localization and no saturation.  Thus polynomial cross-product equality
   with the Hesse triple has one global scalar.

2. For the universal residual quartics `R_G` of a general cubic `G`, impose
   `R_G=rho*Q`, adjoin `u*(lambda^3-1)-1`, and saturate at `rho`.  Macaulay2 checks equality of the
   resulting ideal with the triangular ideal

   ```text
   b=c=e=h=i=j=0,  d=a,  k=a,  f=-3*lambda*a,
   rho=27*(lambda^3-1)*a^5,  u*(lambda^3-1)=1.
   ```

Both containments are asserted exactly.  Consequently, on `lambda^3 != 1` and `rho != 0`, a cubic
with the same full residual-map quartic triple is a scalar multiple of the fixed Hesse cubic.  This
is a global, uniform saturation certificate; it uses no numerical specialization, tangent-space
rank, radical inference, or unrecorded component assumption.

The shape-recovery and scalar-rigidity implications certified here are now also kernel-checked in
`HesseFullResidualRigidity.lean` and `HesseProjectiveResidualRigidity.lean`.  The Lean form is
slightly stronger: once the normalized coordinate is nonzero, those purely algebraic implications
do not require `lambda^3 != 1`.  Smoothness of the Hesse cubic still supplies that inequality in
the eventual geometric application.

## Closed geometric bridge

1. **Hesse normal form.**
   `HesseNormalForm.exists_hesseNormalForm_coordinates` proves that every smooth ternary cubic over
   an algebraically closed characteristic-zero field becomes a nonzero scalar multiple of a smooth
   Hesse cubic after an explicitly invertible linear substitution.

2. **Geometric predicate to affine identities.**  `HesseResidualMapBridge` instantiates transported
   `HasCommonResidualLineMap` on the lines `W=sU+tV`, identifies the resulting residual-linear-form
   coordinates with `ambientCoeffU/V/W`, and derives the two pointwise cross-product identities
   expected by `eq_hesse_of_projective_fullResidual_eq_at_origin`.  At `(s,t)=(0,0)`, the Hesse
   vector is `(0,0,1)`; transported base-point-freeness then supplies nonvanishing of the other
   cubic's `W` coordinate.

3. **Family conclusion.**  `Standard.exists_pencil_of_hasCommonResidualLineMap` normalizes one
   smooth family member, applies the preceding projective rigidity to every member, and transports
   back.  Its internal conclusion is rank one; it returns a degenerate pencil to preserve the
   consumer interface.

## Reproduction

```sh
lake build BConicBundleMultisections.Standard.ResidualLineMapInjective
lake build BConicBundleMultisections.HesseResidualMapBridge
lake build BConicBundleMultisections.HesseResidualCertificate
lake build BConicBundleMultisections.HesseFullResidualRigidity
lake build BConicBundleMultisections.HesseProjectiveResidualRigidity
lake env lean BConicBundleMultisections/HesseProjectiveResidualRigidityAxiomAudit.lean
lake env lean BConicBundleMultisections/Standard/ResidualLineMapInjectiveAxiomAudit.lean
lake env lean BConicBundleMultisections/GoodLineExistenceAxiomAudit.lean
python3 certificates/residual_line_pencil_probe.py
python3 certificates/hesse_full_residual_map_certificate.py
```

The focused audit reports only `propext`, `Classical.choice`, and `Quot.sound` for both the pencil
theorem and `exists_good_line`; it does not report `sorryAx`.  The source's separate line
conditions (2) and (3) are not part of either theorem.
