/-
Copyright (c) 2026 V14Formalization contributors.
Released under Apache 2.0 license.
-/
module

public import V14Formalization.V14D12FixedPointExclusionOverField
public import Mathlib.Analysis.Complex.Polynomial.Basic
public import Mathlib.FieldTheory.IsAlgClosed.Basic

/-!
# Hypothesis (b) over `ℂ`

`ℚ(ζ₁₁)` is algebraic over `ℚ` and `ℂ` is algebraically closed of
characteristic zero, so there is an embedding `ℚ(ζ₁₁) ↪ ℂ`.  Any one of them
turns `ℂ` into an algebra over the cyclotomic base, and
`no_centralizer_fixed_point_over` then applies.  There is nothing special about
`ℂ`; this file only exhibits the instantiation.
-/

noncomputable section

open CategoryTheory
open scoped AlgebraicGeometry

namespace V14Formalization
namespace SchemeGeometry

open AlgebraicGeometry GeometricV14Carrier

/-- An embedding of the cyclotomic base field into `ℂ`. -/
@[expose] public def complexEmbedding : V14SchemeModel.k →ₐ[ℚ] ℂ :=
  IsAlgClosed.lift (R := ℚ) (S := V14SchemeModel.k) (M := ℂ)

/-- `ℂ`, as an algebra over the cyclotomic base field, along the chosen
embedding. -/
@[reducible, expose] public def complexAlgebra : Algebra V14SchemeModel.k ℂ :=
  (complexEmbedding : V14SchemeModel.k →+* ℂ).toAlgebra

/-- Hypothesis (b) over `ℂ`: no complex point of the scheme-theoretic sigma
fixed locus of V14 is fixed by the whole centralizer `D₁₂`. -/
public theorem no_centralizer_fixed_point_complex :
    letI : Algebra V14SchemeModel.k ℂ := complexAlgebra
    ¬ ∃ y : Spec (.of ℂ) ⟶ (FixedBy V14SchemeModel.actionOver sigma).left,
      y ≫ (FixedBy V14SchemeModel.actionOver sigma).hom =
          Spec.map (CommRingCat.ofHom (algebraMap V14SchemeModel.k ℂ)) ∧
        ∀ n : Subgroup.centralizer ({sigma} : Set G),
          y ≫ (fixedByCentralizerHom V14SchemeModel.actionOver sigma n).left =
            y := by
  letI : Algebra V14SchemeModel.k ℂ := complexAlgebra
  exact no_centralizer_fixed_point_over ℂ

end SchemeGeometry
end V14Formalization
