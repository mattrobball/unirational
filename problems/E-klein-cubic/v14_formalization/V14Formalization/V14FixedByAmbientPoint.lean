/-
Copyright (c) 2026 V14Formalization contributors.
Released under Apache 2.0 license.
-/
module

public import V14Formalization.V14SchemeModel
public import V14Formalization.SchemeFixedLocus

/-!
# Ambient projective point of a field-valued V14 fixed-locus point

This is only the categorical projection from the V14 equalizer to ambient
projective space.  It makes no claim about a decomposition of the fixed locus.
-/

noncomputable section

open CategoryTheory
open scoped AlgebraicGeometry

namespace V14Formalization.SchemeGeometry

open AlgebraicGeometry BConicBundleMultisections
open Lambda2Coordinates

public abbrev v14FieldPointOver (L : Type) [Field L]
    [Algebra V14SchemeModel.k L] :
    Over (Spec (.of V14SchemeModel.k)) :=
  Over.mk (Spec.map
    (CommRingCat.ofHom (algebraMap V14SchemeModel.k L)))

/-- The ambient `P¹⁴` point obtained from a field-valued point of the
scheme-theoretic sigma fixed locus of V14. -/
@[expose] public noncomputable def ambientPointOfV14FixedBy
    (L : Type) [Field L] [Algebra V14SchemeModel.k L]
    (p : v14FieldPointOver L ⟶
      FixedBy V14SchemeModel.actionOver GeometricV14Carrier.sigma) :
    Spec (.of L) ⟶ ProjectiveSpace 14 V14SchemeModel.k :=
  p.left ≫
    (fixedByι V14SchemeModel.actionOver GeometricV14Carrier.sigma).left ≫
      V14SchemeModel.v14Schemeι

/-- The ambient point associated to an over-base point of the V14 equalizer
is over `Spec k` and is fixed by the actual projective sigma action. -/
public theorem ambientPointOfV14FixedBy_isOver_and_fixed
    (L : Type) [Field L] [Algebra V14SchemeModel.k L]
    (p : v14FieldPointOver L ⟶
      FixedBy V14SchemeModel.actionOver GeometricV14Carrier.sigma) :
    ambientPointOfV14FixedBy L p ≫
        ProjectiveSpace.toSpec 14 V14SchemeModel.k =
        Spec.map (CommRingCat.ofHom (algebraMap V14SchemeModel.k L)) ∧
      ambientPointOfV14FixedBy L p ≫
          projectiveActionHom lambda2MatrixRepresentation.ρ
            GeometricV14Carrier.sigma =
        ambientPointOfV14FixedBy L p := by
  constructor
  · change
      (p.left ≫
        (fixedByι V14SchemeModel.actionOver GeometricV14Carrier.sigma).left ≫
          V14SchemeModel.v14Schemeι) ≫
            ProjectiveSpace.toSpec 14 V14SchemeModel.k = _
    rw [Category.assoc, Category.assoc]
    change p.left ≫
      ((fixedByι V14SchemeModel.actionOver GeometricV14Carrier.sigma).left ≫
        V14SchemeModel.actionOver.V.hom) = _
    have hi :=
      (fixedByι V14SchemeModel.actionOver GeometricV14Carrier.sigma).w
    rw [hi]
    exact p.w
  · let pv : Spec (.of L) ⟶ V14SchemeModel.actionOver.V.left :=
      p.left ≫
        (fixedByι V14SchemeModel.actionOver GeometricV14Carrier.sigma).left
    have hpv : pv ≫
        (V14SchemeModel.actionOver.ρ GeometricV14Carrier.sigma).left = pv := by
      have hi := congrArg Over.Hom.left
        (fixedByι_comp_action V14SchemeModel.actionOver
          GeometricV14Carrier.sigma)
      change
        (fixedByι V14SchemeModel.actionOver GeometricV14Carrier.sigma).left ≫
            (V14SchemeModel.actionOver.ρ GeometricV14Carrier.sigma).left =
          (fixedByι V14SchemeModel.actionOver GeometricV14Carrier.sigma).left at hi
      dsimp only [pv]
      rw [Category.assoc, hi]
    exact V14SchemeModel.fixed_comp_v14Schemeι
      GeometricV14Carrier.sigma pv hpv

/-- Plain-scheme-morphism form.  The displayed base equation is necessary:
an arbitrary morphism `Spec L ⟶ X` need not use the specified `k`-algebra
structure on `L`. -/
public theorem v14FixedBy_schemePoint_ambient_isOver_and_fixed
    (L : Type) [Field L] [Algebra V14SchemeModel.k L]
    (p : Spec (.of L) ⟶
      (FixedBy V14SchemeModel.actionOver GeometricV14Carrier.sigma).left)
    (hpbase : p ≫
        (FixedBy V14SchemeModel.actionOver GeometricV14Carrier.sigma).hom =
      Spec.map (CommRingCat.ofHom (algebraMap V14SchemeModel.k L))) :
    (p ≫
        (fixedByι V14SchemeModel.actionOver GeometricV14Carrier.sigma).left ≫
          V14SchemeModel.v14Schemeι) ≫
            ProjectiveSpace.toSpec 14 V14SchemeModel.k =
        Spec.map (CommRingCat.ofHom (algebraMap V14SchemeModel.k L)) ∧
      (p ≫
          (fixedByι V14SchemeModel.actionOver GeometricV14Carrier.sigma).left ≫
            V14SchemeModel.v14Schemeι) ≫
          projectiveActionHom lambda2MatrixRepresentation.ρ
            GeometricV14Carrier.sigma =
        p ≫
          (fixedByι V14SchemeModel.actionOver GeometricV14Carrier.sigma).left ≫
            V14SchemeModel.v14Schemeι := by
  let pOver : v14FieldPointOver L ⟶
      FixedBy V14SchemeModel.actionOver GeometricV14Carrier.sigma :=
    Over.homMk p hpbase
  have hpOverLeft : pOver.left = p := rfl
  simpa only [ambientPointOfV14FixedBy, hpOverLeft] using
    ambientPointOfV14FixedBy_isOver_and_fixed L pOver

end V14Formalization.SchemeGeometry
