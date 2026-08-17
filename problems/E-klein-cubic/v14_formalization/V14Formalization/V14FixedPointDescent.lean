/-
Copyright (c) 2026 V14Formalization contributors.
Released under Apache 2.0 license.
-/
module

public import V14Formalization.ProjectiveFamilyFieldPointLift
public import V14Formalization.V14SchemeModel
public import V14Formalization.V14FixedPointEquations

/-!
# Base morphisms from descended V14 coordinates
-/

noncomputable section

open CategoryTheory Matrix
open scoped AlgebraicGeometry

namespace V14Formalization.SchemeGeometry

open AlgebraicGeometry BConicBundleMultisections Lambda2Coordinates

public abbrev k := V14SchemeModel.k

public theorem v14Equations_of_projector_and_plucker
    {L : Type} [Field L] [Algebra k L]
    (x : Fin 15 → L)
    (hproj : (V14SchemeModel.projectorMatrix.map (algebraMap k L)).mulVec x = x)
    (hQ : ∀ q : Fin 15,
      MvPolynomial.eval x
        (MvPolynomial.map (algebraMap k L)
          (pluckerQuadric k q)) = 0) :
    ∀ s : Fin 15 ⊕ Fin 15,
      MvPolynomial.eval x
        (MvPolynomial.map (algebraMap k L)
          (grassmannianLinearSectionEquations k
            V14SchemeModel.projectorMatrix s)) = 0 := by
  intro s
  rcases s with q | i
  · exact hQ q
  · have : MvPolynomial.eval x
        (MvPolynomial.map (algebraMap k L)
          (projectorLinearCut k V14SchemeModel.projectorMatrix i)) = 0 := by
      rw [map_projectorLinearCut (algebraMap k L)]
      exact (projectorLinearCuts_vanish_iff (R := L)
          (V14SchemeModel.projectorMatrix.map (algebraMap k L)) x |>.mpr
          hproj) i
    exact this

/-- A normalized base-field V14 vector satisfying the projector and Plücker
equations determines a section `Spec k ⟶ v14Scheme` over the base. -/
@[expose] public noncomputable def v14SchemePointOfNormalizedCoordinates
    (j : Fin 15) (x : Fin 15 → k) (hxj : x j = 1)
    (hproj : V14SchemeModel.projectorMatrix.mulVec x = x)
    (hQ : ∀ q : Fin 15, MvPolynomial.eval x (pluckerQuadric k q) = 0) :
    Spec (.of k) ⟶ V14SchemeModel.v14Scheme :=
  pointOfNormalizedCoordinates_lifts_projectiveZeroLocusFamily
    14 (grassmannianLinearSectionEquations k V14SchemeModel.projectorMatrix)
    V14SchemeModel.equationDegree V14SchemeModel.equations_isHomogeneous
    j x hxj
    (by
      intro s
      have hzero := v14Equations_of_projector_and_plucker (L := k) x
        (by
          convert hproj
          ext i j
          simp [Matrix.map_apply])
        (fun q => by simpa using hQ q)
      simpa using hzero s)

public theorem v14SchemePointOfNormalizedCoordinates_toSpec
    (j : Fin 15) (x : Fin 15 → k) (hxj : x j = 1)
    (hproj : V14SchemeModel.projectorMatrix.mulVec x = x)
    (hQ : ∀ q : Fin 15, MvPolynomial.eval x (pluckerQuadric k q) = 0) :
    v14SchemePointOfNormalizedCoordinates j x hxj hproj hQ ≫
      V14SchemeModel.actionOver.V.hom = 𝟙 _ := by
  change _ ≫ projectiveZeroLocusFamilyToSpec 14 k
      (grassmannianLinearSectionEquations k V14SchemeModel.projectorMatrix) =
    𝟙 _
  have hzero : ∀ s : Fin 15 ⊕ Fin 15,
      MvPolynomial.eval x
        (MvPolynomial.map (algebraMap k k)
          (grassmannianLinearSectionEquations k
            V14SchemeModel.projectorMatrix s)) = 0 := by
    intro s
    have hz := v14Equations_of_projector_and_plucker (L := k) x
      (by
        convert hproj
        ext a b
        simp [Matrix.map_apply])
      (fun q => by simpa using hQ q)
    simpa using hz s
  simpa [v14SchemePointOfNormalizedCoordinates, algebraMap, Spec.map_id] using
    (pointOfNormalizedCoordinates_lifts_projectiveZeroLocusFamily_toSpec
      14 (grassmannianLinearSectionEquations k V14SchemeModel.projectorMatrix)
      V14SchemeModel.equationDegree V14SchemeModel.equations_isHomogeneous
      j x hxj hzero)

public theorem v14SchemePointOfNormalizedCoordinates_ι
    (j : Fin 15) (x : Fin 15 → k) (hxj : x j = 1)
    (hproj : V14SchemeModel.projectorMatrix.mulVec x = x)
    (hQ : ∀ q : Fin 15, MvPolynomial.eval x (pluckerQuadric k q) = 0) :
    v14SchemePointOfNormalizedCoordinates j x hxj hproj hQ ≫
      V14SchemeModel.v14Schemeι =
      ProjectiveSpace.pointOfNormalizedCoordinatesAlgebra (R := k) 14 j x := by
  have hzero : ∀ s : Fin 15 ⊕ Fin 15,
      MvPolynomial.eval x
        (MvPolynomial.map (algebraMap k k)
          (grassmannianLinearSectionEquations k
            V14SchemeModel.projectorMatrix s)) = 0 := by
    intro s
    have hz := v14Equations_of_projector_and_plucker (L := k) x
      (by
        convert hproj
        ext a b
        simp [Matrix.map_apply])
      (fun q => by simpa using hQ q)
    simpa using hz s
  simpa [v14SchemePointOfNormalizedCoordinates] using
    (pointOfNormalizedCoordinates_lifts_projectiveZeroLocusFamily_ι
      14 (grassmannianLinearSectionEquations k V14SchemeModel.projectorMatrix)
      V14SchemeModel.equationDegree V14SchemeModel.equations_isHomogeneous
      j x hxj hzero)

/-- A descended eigenvector for `lambda²(σ)` is a `σ`-fixed V14 point. -/
public theorem v14SchemePointOfNormalizedCoordinates_sigma_fixed
    (j : Fin 15) (x : Fin 15 → k) (hxj : x j = 1)
    (hproj : V14SchemeModel.projectorMatrix.mulVec x = x)
    (hQ : ∀ q : Fin 15, MvPolynomial.eval x (pluckerQuadric k q) = 0)
    (a : k) (ha : a ≠ 0)
    (heig :
      ((Lambda2Coordinates.lambda2MatrixRepresentation.ρ
          GeometricV14Carrier.sigma :
          Matrix (Fin 15) (Fin 15) k)).mulVec x = a • x) :
    v14SchemePointOfNormalizedCoordinates j x hxj hproj hQ ≫
      (V14SchemeModel.actionOver.ρ GeometricV14Carrier.sigma).left =
      v14SchemePointOfNormalizedCoordinates j x hxj hproj hQ := by
  haveI : Mono V14SchemeModel.v14Schemeι := inferInstance
  apply (cancel_mono V14SchemeModel.v14Schemeι).1
  have hsq :=
    V14SchemeModel.actionOver_hom_v14Schemeι GeometricV14Carrier.sigma
  have hι :=
    v14SchemePointOfNormalizedCoordinates_ι j x hxj hproj hQ
  calc
    (v14SchemePointOfNormalizedCoordinates j x hxj hproj hQ ≫
          (V14SchemeModel.actionOver.ρ GeometricV14Carrier.sigma).left) ≫
        V14SchemeModel.v14Schemeι =
        v14SchemePointOfNormalizedCoordinates j x hxj hproj hQ ≫
          ((V14SchemeModel.actionOver.ρ GeometricV14Carrier.sigma).left ≫
            V14SchemeModel.v14Schemeι) := by
      exact (Category.assoc _ _ _).symm.symm
    _ = v14SchemePointOfNormalizedCoordinates j x hxj hproj hQ ≫
          (V14SchemeModel.v14Schemeι ≫
            projectiveActionHom lambda2MatrixRepresentation.ρ
              GeometricV14Carrier.sigma) :=
      congrArg
        (fun t => v14SchemePointOfNormalizedCoordinates j x hxj hproj hQ ≫ t)
        hsq
    _ = (v14SchemePointOfNormalizedCoordinates j x hxj hproj hQ ≫
          V14SchemeModel.v14Schemeι) ≫
        projectiveActionHom lambda2MatrixRepresentation.ρ
          GeometricV14Carrier.sigma :=
      (Category.assoc _ _ _).symm
    _ = ProjectiveSpace.pointOfNormalizedCoordinatesAlgebra (R := k) 14 j x ≫
          mapLinearSubst 14
            (lambda2MatrixRepresentation.ρ GeometricV14Carrier.sigma :
              Matrix (Fin 15) (Fin 15) k)
            ((lambda2MatrixRepresentation.ρ GeometricV14Carrier.sigma)⁻¹ :
              Matrix (Fin 15) (Fin 15) k)
            (by simp) := by
      rw [hι]; rfl
    _ = ProjectiveSpace.pointOfNormalizedCoordinatesAlgebra (R := k) 14 j x := by
      refine pointOfNormalizedCoordinates_fixed_of_mulVec_eq_smul
        14
        (lambda2MatrixRepresentation.ρ GeometricV14Carrier.sigma :
          Matrix (Fin 15) (Fin 15) k)
        ((lambda2MatrixRepresentation.ρ GeometricV14Carrier.sigma)⁻¹ :
          Matrix (Fin 15) (Fin 15) k)
        (by simp) j x hxj a ha ?_
      convert heig
      ext i1 j1
      simp [Matrix.map_apply]
    _ = v14SchemePointOfNormalizedCoordinates j x hxj hproj hQ ≫
          V14SchemeModel.v14Schemeι := hι.symm

end V14Formalization.SchemeGeometry
