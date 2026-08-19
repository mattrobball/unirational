/-
Copyright (c) 2026 V14Formalization contributors.
Released under Apache 2.0 license.
-/
module

public import V14Formalization.V14D12FixedPointExclusionOverField
public import V14Formalization.V14SchemeBaseChange
public import V14Formalization.SchemeBaseChangeFixed
public import V14Formalization.SchemeRationalConstancy
public import V14Formalization.SchemeModelAliases

/-!
# The terminal reduction over an arbitrary base field

`V14D12CertificateExclusion.noEquivariantRationalMap_of_normal_specialization`
reduces "no equivariant rational map into the coordinate V14" to a normal
specialization datum plus constancy on the exceptional divisor, over the
cyclotomic base `k = ℚ(ζ₁₁)`.  This file does the same over any field `F` with
`[Algebra k F]` — equivalently (`BaseFieldCriteria`) any field of
characteristic zero containing a primitive 11th root of unity — with the target
the base-changed action `V14SchemeModel.actionOverBaseChange F`.

Nothing new is proved about V14 here.  Everything that was specific to `k` in
the `k`-version was hypothesis (b), `V₁₄^{D₁₂} = ∅`, and that has been
base-change-stable since `V14D12FixedPointExclusionOverField`: it is a
statement about `L`-points for every field `L` over `k`, because the emptiness
certificate is ideal-theoretic rather than point-counting.  The only work is
`SchemeBaseChangeFixed.exists_centralizer_fixed_point_of_baseChange`, which
turns a centralizer-fixed section of the base change into a centralizer-fixed
`F`-point upstairs.

What is *not* supplied here is the constancy hypothesis `hconst`, i.e.
hypothesis (a) over `F`.  That is the one remaining gap in the general-field
headline; see `FIELD_CRITERIA_2026-08-18.md`.
-/

noncomputable section

open CategoryTheory
open scoped AlgebraicGeometry

namespace V14Formalization.SchemeGeometry

open AlgebraicGeometry GeometricV14Carrier

/-- Hypothesis (b) against the base-changed action: the `sigma`-fixed locus of
`V14_F` has no `F`-section fixed by the whole centralizer of `sigma`. -/
public theorem no_centralizer_fixed_section_baseChange
    (F : Type) [Field F] [Algebra V14SchemeModel.k F] :
    ¬ ∃ y : Spec (.of F) ⟶
        (fixedByCentralizerAction
          (V14SchemeModel.actionOverBaseChange F) sigma).V.left,
      y ≫ (fixedByCentralizerAction
          (V14SchemeModel.actionOverBaseChange F) sigma).V.hom = 𝟙 _ ∧
        ∀ n : Subgroup.centralizer ({sigma} : Set V14SchemeModel.G),
          y ≫ ((fixedByCentralizerAction
            (V14SchemeModel.actionOverBaseChange F) sigma).ρ n).left = y := by
  rintro ⟨y, hybase, hyfixed⟩
  obtain ⟨z, hzbase, hzfixed⟩ :=
    exists_centralizer_fixed_point_of_baseChange
      (Spec.map (CommRingCat.ofHom (algebraMap V14SchemeModel.k F)))
      V14SchemeModel.actionOver sigma y hybase hyfixed
  exact no_centralizer_fixed_point_over F ⟨z, hzbase, hzfixed⟩

/-- The terminal reduction over `F`.  Same shape as
`noEquivariantRationalMap_of_normal_specialization`, with `Spec k` replaced by
`Spec F` and the coordinate V14 by its base change.

Read together with `FaithfulHeadlineReduction`, this says that the general-field
headline is now exactly one input away: a proof of `hconst`, which is
hypothesis (a) — no rational curve in the positive-dimensional part of
`V14^σ` — over `F`. -/
public theorem noEquivariantRationalMap_of_normal_specialization_over
    (F : Type) [Field F] [Algebra V14SchemeModel.k F]
    (X : Action (Over (Spec (.of F))) V14SchemeModel.G)
    [IsIntegral X.V.left]
    {E : Action (Over (Spec (.of F)))
      (Subgroup.centralizer ({sigma} : Set V14SchemeModel.G))}
    [IsIntegral E.V.left]
    (D : EquivariantNormalValuationData
      ((Action.res (Over (Spec (.of F)))
        (Subgroup.subtype _)).obj X) E)
    (hsigma : D.exceptionalFunctionFieldAction (sigmaInCentralizer sigma) =
      𝟙 (Spec (.of E.V.left.functionField)))
    (hconst : ∀ q : Scheme.RationalMap E.V.left
        (fixedByCentralizerAction
          (V14SchemeModel.actionOverBaseChange F) sigma).V.left,
      q.IsOver (Spec (.of F)) →
        RationalMapIsConstantOver (E := E.V)
          (Z := (fixedByCentralizerAction
            (V14SchemeModel.actionOverBaseChange F) sigma).V) q) :
    ¬ HasEquivariantRationalMap X (V14SchemeModel.actionOverBaseChange F) :=
  D.noEquivariantRationalMap_of_constant_fixedSpecialization_section
    X (V14SchemeModel.actionOverBaseChange F) sigma hsigma hconst
    (no_centralizer_fixed_section_baseChange F)

end V14Formalization.SchemeGeometry
