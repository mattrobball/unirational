/-
Copyright (c) 2026 V14Formalization contributors.
Released under Apache 2.0 license.
-/
module

public import V14Formalization.V14D12CertificateExclusionOverField
public import V14Formalization.BaseFieldCriteria
public import V14Formalization.BlockNormalSigma
public import V14Formalization.CentralizerObstruction
public import V14Formalization.ProjectiveSpaceIntrinsicCompare
public import V14Formalization.ProjectiveSpaceIntrinsicIrreducible
public import V14Formalization.SchemeEquivariantTransport

/-!
# The no-map theorem over an arbitrary base field, modulo hypothesis (a)

The published theorems fix `k = ℚ(ζ₁₁)`.  That is strictly weaker than
intended: a rational map over a larger field does not descend to `ℚ(ζ₁₁)`, and
`FaithfulLinearRep k G V` does not even reach the two 12-dimensional
irreducibles of `PSL(2,11)`, whose character field `ℚ(√5)` is not inside
`ℚ(ζ₁₁)`.

This file states and proves the theorem over any field `F` with
`[Algebra k F]` — by `BaseFieldCriteria`, exactly the fields of characteristic
zero containing a primitive 11th root of unity — **conditionally on hypothesis
(a) over `F`**, which is the constancy statement

    every rational map over `Spec F` from a biprojective space to the
    `σ`-fixed locus of `V14_F` is constant.

Over `k` that is `V14FixedRationalConstancy.rationalMapIsConstantOver_v14FixedBy`;
over a general `F` it is what remains to be proved (see
`FIELD_CRITERIA_2026-08-18.md`).  Everything else in the argument is here and
is unconditional:

* the scheme spine — blow-up chart, exceptional divisor, properness, the
  valuative criterion, the normal-specialization datum and its `σ`-triviality —
  was already field-polymorphic (`UniversalNormalDivisor`, `BlockNormalSigma`,
  `BlockSourceFieldMap`, `SchemeNormalSpecialization`);
* hypothesis (b), `V₁₄^{D₁₂} = ∅`, holds over every field over `k`
  (`V14D12FixedPointExclusionOverField`) and reaches the base-changed target
  through `SchemeBaseChangeFixed`;
* the coordinate-free presentation `ℙ(V) = Proj (Sym V*)` and its comparison
  with a numbered `Proj` (`ProjectiveSpaceIntrinsic*`) never mentioned the
  field either.

`[CharZero F]` appears in the intermediate statements because
`plusMinusAmbientBasis` and the corrected-chart normal datum carry it (it is a
blanket for `1/2`, needed to split the `σ`-eigenspaces).  It is implied by
`[Algebra k F]` and is discharged that way in the coordinate-free theorem,
whose statement therefore carries no characteristic hypothesis at all.
-/

noncomputable section

open CategoryTheory
open scoped AlgebraicGeometry

namespace V14Formalization.SchemeGeometry

open AlgebraicGeometry GeometricV14Carrier Module
open BConicBundleMultisections

section Coordinates

variable (F : Type) [Field F] [CharZero F]

/-- The numbered ambient projective action of `R` in plus/minus coordinates,
over an arbitrary base field.  `ambientFor` is the `k`-instance. -/
public abbrev ambientForOver
    {V : Type} [AddCommGroup V] [Module F V]
    (R : FaithfulLinearRep F V14SchemeModel.G V) (p q : ℕ)
    (bp : Basis (Fin (p + 1)) F (R.plusEigenspace sigma))
    (bm : Basis (Fin (q + 1)) F (R.minusEigenspace sigma)) :=
  ambientProjectiveActionOver R (p + q + 1)
    (plusMinusAmbientBasis R sigma sigma_isInvolution p q bp bm)

/-- The exceptional divisor of the blow-up along `ℙ(V₊)`, over an arbitrary
base field.  `exceptionalFor` is the `k`-instance. -/
public abbrev exceptionalForOver
    {V : Type} [AddCommGroup V] [Module F V]
    (R : FaithfulLinearRep F V14SchemeModel.G V) (p q : ℕ)
    (bp : Basis (Fin (p + 1)) F (R.plusEigenspace sigma))
    (bm : Basis (Fin (q + 1)) F (R.minusEigenspace sigma)) :=
  normalDivisorActionOver R sigma p q bp bm

end Coordinates

/-- **Hypothesis (a) over `F`.**  Every rational map over `Spec F` from a
biprojective space to the `σ`-fixed locus of `V14_F` is constant.

Over `k` this is `rationalMapIsConstantOver_v14FixedBy`.  Naming it makes the
one remaining gap in the general-field headline explicit and citable. -/
@[expose] public def HypothesisAOver (F : Type) [Field F]
    [Algebra V14SchemeModel.k F] : Prop :=
  ∀ (p q : ℕ) (z : Scheme.RationalMap (BiprojectiveSpace p q F)
      (FixedBy (V14SchemeModel.actionOverBaseChange F) sigma).left),
    z.IsOver (Spec (.of F)) →
      RationalMapIsConstantOver
        (E := Over.mk (BiprojectiveSpace.toSpec p q F))
        (Z := FixedBy (V14SchemeModel.actionOverBaseChange F) sigma) z

/-- The coordinatized no-map theorem over `F`, granted hypothesis (a) over `F`.
This is `noEquivariantRationalMap_from_ambient_of_constancy` with `Spec k`
replaced by `Spec F` and the coordinate V14 by its base change. -/
public theorem noEquivariantRationalMap_from_ambient_of_constancy_over
    (F : Type) [Field F] [CharZero F] [Algebra V14SchemeModel.k F]
    {V : Type} [AddCommGroup V] [Module F V]
    (R : FaithfulLinearRep F V14SchemeModel.G V) (p q : ℕ)
    (bp : Basis (Fin (p + 1)) F (R.plusEigenspace sigma))
    (bm : Basis (Fin (q + 1)) F (R.minusEigenspace sigma))
    (ha : HypothesisAOver F) :
    ¬ HasEquivariantRationalMap (ambientForOver F R p q bp bm)
      (V14SchemeModel.actionOverBaseChange F) := by
  let X := ambientForOver F R p q bp bm
  let D := orderedPlusMinusEquivariantNormalDataOfCorrectedChartActual
    R sigma sigma_isInvolution p q bp bm
  apply noEquivariantRationalMap_of_normal_specialization_over F X D
  · change D.exceptionalFunctionFieldAction (sigmaInCentralizer sigma) = 𝟙 _
    have hs := orderedPlusMinusEquivariantNormalDataOfCorrectedChartActual_sigma
      R sigma sigma_isInvolution p q bp bm
    have helem : sigmaInCentralizer sigma = sigmaCentralizer sigma :=
      Subtype.ext rfl
    rw [helem]
    exact hs
  · intro z hz
    exact ha p q z hz

/-- **The coordinate-free no-map theorem over an arbitrary base field, granted
hypothesis (a).**

There is no `G`-equivariant rational map from `ℙ(V) = Proj (Sym (V*))`, the
projectivization of a faithful `F`-linear representation of `PSL(2,11)`, to
`V14_F`, for any field `F` of characteristic zero containing a primitive 11th
root of unity.

No basis of `V` and no system of homogeneous coordinates appears: the
`σ`-eigenspace decomposition is chosen inside the proof.  `[CharZero F]` does
not appear either — it follows from `[Algebra k F]`.

This is the general-field replacement for
`noEquivariantRationalMap_projectiveSpaceOfRep`, which quantifies only over
`ℚ(ζ₁₁)`-representations and therefore misses, for instance, the two
12-dimensional irreducibles of `PSL(2,11)` with character field `ℚ(√5)`. -/
public theorem noEquivariantRationalMap_projectiveSpaceOfRep_over_of_constancy
    (F : Type) [Field F] [Algebra V14SchemeModel.k F]
    {V : Type} [AddCommGroup V] [Module F V]
    [FiniteDimensional F V] [Nontrivial V]
    (R : FaithfulLinearRep F V14SchemeModel.G V)
    (ha : HypothesisAOver F) :
    ¬ HasEquivariantRationalMap (projectiveSpaceOfRep R)
      (V14SchemeModel.actionOverBaseChange F) := by
  haveI : CharZero F := BaseField.charZero_of_algebra F
  intro h
  obtain ⟨p, q, hbp, hbm⟩ :=
    exists_plus_minus_projective_bases R sigma sigma_isInvolution
      (not_degenerates_of_centerless
        GeometricFanoCarrier.PSL2F11_isCenterless sigma_isInvolution R)
  let bp := Classical.choice hbp
  let bm := Classical.choice hbm
  exact noEquivariantRationalMap_from_ambient_of_constancy_over F R p q bp bm ha
    (hasEquivariantRationalMap_of_iso
      (projectiveSpaceOfRepIso R
        (plusMinusAmbientBasis R sigma sigma_isInvolution p q bp bm)).symm h)

end V14Formalization.SchemeGeometry
