/-
Copyright (c) 2026 V14Formalization contributors.
Released under Apache 2.0 license.
-/
import V14Formalization.ProjectiveFamilyFieldPoint
import V14Formalization.V14FixedByAmbientPoint

/-!
# Coordinate equations of field-valued V14 fixed points

This file keeps the scheme-theoretic source visible: it starts with a point of
the equalizer `FixedBy` and proves that normalized coordinates of its ambient
projective point satisfy every base-changed V14 equation.  In particular the
base-changed character projector fixes the vector and all Plücker quadrics
vanish.
-/

noncomputable section

open CategoryTheory
open scoped AlgebraicGeometry

namespace V14Formalization.SchemeGeometry

open AlgebraicGeometry BConicBundleMultisections

theorem map_projectorLinearCut
    {R S : Type} [CommRing R] [CommRing S]
    (f : R →+* S) (P : Matrix (Fin 15) (Fin 15) R) (i : Fin 15) :
    MvPolynomial.map f (projectorLinearCut R P i) =
      projectorLinearCut S (P.map f) i := by
  simp [projectorLinearCut, Matrix.map_apply]

/-- Normalized coordinates of a field-valued point of the sigma fixed locus
satisfy all thirty base-changed equations defining the coordinate V14. -/
theorem exists_normalizedCoordinates_equations_of_v14FixedBy
    (L : Type) [Field L] [Algebra V14SchemeModel.k L]
    (p : v14FieldPointOver L ⟶
      FixedBy V14SchemeModel.actionOver GeometricV14Carrier.sigma) :
    ∃ (j : Fin 15) (x : Fin 15 → L),
      x j = 1 ∧
      ambientPointOfV14FixedBy L p =
        ProjectiveSpace.pointOfNormalizedCoordinatesAlgebra
          (R := V14SchemeModel.k) 14 j x ∧
      (∀ s : Fin 15 ⊕ Fin 15,
        MvPolynomial.eval x
          (MvPolynomial.map (algebraMap V14SchemeModel.k L)
            (grassmannianLinearSectionEquations V14SchemeModel.k
              V14SchemeModel.projectorMatrix s)) = 0) := by
  have hamb := ambientPointOfV14FixedBy_isOver_and_fixed L p
  obtain ⟨j, x, hxj, hx⟩ :=
    exists_normalizedResidueCoordinates_for_fieldPoint 14
      (ambientPointOfV14FixedBy L p) hamb.1
  refine ⟨j, x, hxj, hx, ?_⟩
  let z : Spec (.of L) ⟶ V14SchemeModel.v14Scheme :=
    p.left ≫
      (fixedByι V14SchemeModel.actionOver GeometricV14Carrier.sigma).left
  have hzbase : z ≫ projectiveZeroLocusFamilyToSpec 14 V14SchemeModel.k
        (grassmannianLinearSectionEquations V14SchemeModel.k
          V14SchemeModel.projectorMatrix) =
      Spec.map (CommRingCat.ofHom (algebraMap V14SchemeModel.k L)) := by
    change z ≫ projectiveZeroLocusFamilyToSpec 14 V14SchemeModel.k
        (grassmannianLinearSectionEquations V14SchemeModel.k
          V14SchemeModel.projectorMatrix) = (v14FieldPointOver L).hom
    calc
      z ≫ projectiveZeroLocusFamilyToSpec 14 V14SchemeModel.k
          (grassmannianLinearSectionEquations V14SchemeModel.k
            V14SchemeModel.projectorMatrix) =
          p.left ≫
            ((fixedByι V14SchemeModel.actionOver
              GeometricV14Carrier.sigma).left ≫
                V14SchemeModel.actionOver.V.hom) := by rfl
      _ = p.left ≫
          (FixedBy V14SchemeModel.actionOver
            GeometricV14Carrier.sigma).hom := by
        rw [(fixedByι V14SchemeModel.actionOver
          GeometricV14Carrier.sigma).w]
      _ = (v14FieldPointOver L).hom := p.w
  apply eval_map_eq_zero_of_projectiveZeroLocusFamily_point
    14
    (grassmannianLinearSectionEquations V14SchemeModel.k
      V14SchemeModel.projectorMatrix)
    V14SchemeModel.equationDegree V14SchemeModel.equations_isHomogeneous
    z hzbase j x hxj
  exact hx

/-- The preceding equations imply both `P x = x` for the base-changed
character projector and all fifteen base-changed Plücker relations. -/
theorem exists_normalizedCoordinates_v14FixedBy_projector_fixed
    (L : Type) [Field L] [Algebra V14SchemeModel.k L]
    (p : v14FieldPointOver L ⟶
      FixedBy V14SchemeModel.actionOver GeometricV14Carrier.sigma) :
    ∃ (j : Fin 15) (x : Fin 15 → L),
      x j = 1 ∧
      ambientPointOfV14FixedBy L p =
        ProjectiveSpace.pointOfNormalizedCoordinatesAlgebra
          (R := V14SchemeModel.k) 14 j x ∧
      (V14SchemeModel.projectorMatrix.map
        (algebraMap V14SchemeModel.k L)).mulVec x = x ∧
      (∀ q : Fin 15,
        MvPolynomial.eval x
          (MvPolynomial.map (algebraMap V14SchemeModel.k L)
            (pluckerQuadric V14SchemeModel.k q)) = 0) := by
  obtain ⟨j, x, hxj, hxpoint, heq⟩ :=
    exists_normalizedCoordinates_equations_of_v14FixedBy L p
  refine ⟨j, x, hxj, hxpoint, ?_, ?_⟩
  · apply (projectorLinearCuts_vanish_iff L
      (V14SchemeModel.projectorMatrix.map
        (algebraMap V14SchemeModel.k L)) x).mp
    intro i
    rw [← map_projectorLinearCut]
    exact heq (Sum.inr i)
  · intro q
    exact heq (Sum.inl q)

end V14Formalization.SchemeGeometry
