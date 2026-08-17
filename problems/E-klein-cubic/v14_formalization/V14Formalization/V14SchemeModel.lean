/-
Copyright (c) 2026 V14Formalization contributors.
Released under Apache 2.0 license.
-/
module

public import V14Formalization.Lambda2Coordinates
public import V14Formalization.GeometricV14Carrier
public import V14Formalization.GrassmannianLinearSection
public import V14Formalization.ProjectiveAwayNaturality
public import V14Formalization.PluckerNaturality
public import Mathlib.Algebra.CharZero.Infinite

/-!
# The coordinate scheme model of V14

This file connects the representation-theoretic projector onto the `10′`
summand of `Λ²U` to the lexicographic Plücker coordinates used by the scheme
model and by the finite D12 certificates.

The resulting matrix is proved idempotent and equivariant for the actual
`PSL₂(F₁₁)` representation.  Its fifteen linear equations vanish exactly on
vectors in the representation-theoretic summand `M`.
-/

noncomputable section

open Set Matrix exteriorPower Module
open CategoryTheory
open scoped AlgebraicGeometry

namespace V14Formalization
namespace V14SchemeModel

open GeometricFanoCarrier GeometricV14Carrier Lambda2Coordinates SchemeGeometry
  BConicBundleMultisections

public abbrev k := GeometricV14Carrier.k
public abbrev G := GeometricV14Carrier.PSL2F11
public abbrev Lambda2U := GeometricV14Carrier.Lambda2U

/-- The character projector in the exact Plücker coordinate basis
`01,02,03,04,05,12,...,45`. -/
@[expose] public noncomputable def projectorMatrix : Matrix (Fin 15) (Fin 15) k :=
  LinearMap.toMatrix lambda2Basis lambda2Basis projectorM

/-- Matrix multiplication by the coordinate projector is the coordinate form
of the representation-theoretic projector. -/
theorem projectorMatrix_mulVec_equivFun (v : Lambda2U) :
    projectorMatrix.mulVec (lambda2Basis.equivFun v) =
      lambda2Basis.equivFun (projectorM v) := by
  simpa only [projectorMatrix, Basis.equivFun_apply] using
    LinearMap.toMatrix_mulVec_repr lambda2Basis lambda2Basis projectorM v

/-- Matrix multiplication by the genuine group representation is its
coordinate action. -/
theorem representationMatrix_mulVec_equivFun (g : G) (v : Lambda2U) :
    (lambda2MatrixRepresentation.ρ g : Matrix (Fin 15) (Fin 15) k).mulVec
        (lambda2Basis.equivFun v) =
      lambda2Basis.equivFun (ambientAct g v) := by
  simpa only [lambda2MatrixRepresentation_coe, ambientAct,
    Basis.equivFun_apply] using
    LinearMap.toMatrix_mulVec_repr lambda2Basis lambda2Basis
      (GeometricFanoCarrier.pslLambda2Hom g) v

/-- The coordinate projector is idempotent. -/
public theorem projectorMatrix_idempotent :
    projectorMatrix * projectorMatrix = projectorMatrix := by
  rw [Matrix.ext_iff_mulVec]
  intro x
  obtain ⟨v, rfl⟩ := lambda2Basis.equivFun.surjective x
  rw [← Matrix.mulVec_mulVec, projectorMatrix_mulVec_equivFun,
    projectorMatrix_mulVec_equivFun, projectorM_sq_apply]

/-- The coordinate projector commutes with the genuine exterior-square
representation. -/
public theorem projectorMatrix_commutes (g : G) :
    projectorMatrix *
        (lambda2MatrixRepresentation.ρ g : Matrix (Fin 15) (Fin 15) k) =
      (lambda2MatrixRepresentation.ρ g : Matrix (Fin 15) (Fin 15) k) *
        projectorMatrix := by
  rw [Matrix.ext_iff_mulVec]
  intro x
  obtain ⟨v, rfl⟩ := lambda2Basis.equivFun.surjective x
  rw [← Matrix.mulVec_mulVec, ← Matrix.mulVec_mulVec,
    representationMatrix_mulVec_equivFun, projectorMatrix_mulVec_equivFun,
    projectorMatrix_mulVec_equivFun, representationMatrix_mulVec_equivFun,
    projectorM_equivariant]

/-- Matrix multiplication by the coordinate projector is the coordinate form
of the representation-theoretic projector. -/
theorem projectorMatrix_mulVec_repr (v : Lambda2U) :
    projectorMatrix.mulVec (lambda2Basis.repr v) =
      lambda2Basis.repr (projectorM v) := by
  exact LinearMap.toMatrix_mulVec_repr lambda2Basis lambda2Basis projectorM v

/-- A vector is fixed by the coordinate matrix precisely when it is fixed by
the representation-theoretic projector. -/
theorem projectorMatrix_fixed_iff (v : Lambda2U) :
    projectorMatrix.mulVec (lambda2Basis.repr v) = lambda2Basis.repr v ↔
      projectorM v = v := by
  rw [projectorMatrix_mulVec_repr]
  rw [DFunLike.coe_fn_eq]
  exact lambda2Basis.repr.injective.eq_iff

/-- Because the character projector is idempotent, its fixed subspace is its
range `M`. -/
theorem projectorM_fixed_iff_mem_Msub (v : Lambda2U) :
    projectorM v = v ↔ v ∈ Msub := by
  constructor
  · intro hv
    exact ⟨v, hv⟩
  · rintro ⟨w, hw⟩
    calc
      projectorM v = projectorM (projectorM w) := congrArg projectorM hw.symm
      _ = projectorM w := projectorM_sq_apply w
      _ = v := hw

/-- The linear equations in the coordinate scheme are exactly the condition
that a Plücker representative lies in `M`. -/
public theorem projectorLinearCuts_vanish_iff_mem_Msub (v : Lambda2U) :
    (∀ i : Fin 15, MvPolynomial.eval (lambda2Basis.repr v)
        (projectorLinearCut k projectorMatrix i) = 0) ↔ v ∈ Msub := by
  rw [projectorLinearCuts_vanish_iff, projectorMatrix_fixed_iff,
    projectorM_fixed_iff_mem_Msub]

/-- Degree of each equation in the combined Plücker/projector family. -/
@[expose] public def equationDegree : Fin 15 ⊕ Fin 15 → ℕ :=
  Sum.elim (fun _ ↦ 2) (fun _ ↦ 1)

/-- The combined equations have their advertised degrees. -/
public theorem equations_isHomogeneous (s : Fin 15 ⊕ Fin 15) :
    (grassmannianLinearSectionEquations k projectorMatrix s).IsHomogeneous
      (equationDegree s) := by
  rcases s with q | i
  · exact pluckerQuadric_isHomogeneous k q
  · exact projectorLinearCut_isHomogeneous k projectorMatrix i

/-- The projector-image half of the V14 equations is stable under the actual
exterior-square representation. -/
theorem projector_span_aeval_lambda2_le (g : G) :
    Ideal.span (Set.range (fun i : Fin 15 ↦
      (MvPolynomial.aeval (linearSubst 14
        (lambda2MatrixRepresentation.ρ g : Matrix (Fin 15) (Fin 15) k)) :
          _ →ₐ[k] _)
        (projectorLinearCut k projectorMatrix i))) ≤
      Ideal.span (Set.range (projectorLinearCut k projectorMatrix)) :=
  span_aeval_projectorLinearCut_le k projectorMatrix
    (lambda2MatrixRepresentation.ρ g : Matrix (Fin 15) (Fin 15) k)
    (projectorMatrix_commutes g)

/-- The Plücker quadrics are stable under the actual exterior-square
representation.  This is the coordinate form of functoriality of the
Grassmannian under linear changes of the underlying six-space. -/
public theorem plucker_span_aeval_lambda2_le (g : G) :
    Ideal.span (Set.range (fun q : Fin 15 ↦
      (MvPolynomial.aeval (linearSubst 14
        (lambda2MatrixRepresentation.ρ g : Matrix (Fin 15) (Fin 15) k)) :
          _ →ₐ[k] _)
        (pluckerQuadric k q))) ≤
      Ideal.span (Set.range (pluckerQuadric k)) := by
  obtain ⟨A, hA⟩ :=
    PluckerNaturality.lambda2MatrixRepresentation_eq_compound2Lex g
  rw [hA]
  exact PluckerNaturality.span_aeval_pluckerQuadric_compound_le
    (R := k) (by norm_num) A

/-- Combining a Plücker-span proof with the now-unconditional projector-span
proof gives stability of the complete coordinate equation family. -/
theorem equations_span_aeval_lambda2_le_of_plucker
    (g : G)
    (hplucker :
      Ideal.span (Set.range (fun q : Fin 15 ↦
        (MvPolynomial.aeval (linearSubst 14
          (lambda2MatrixRepresentation.ρ g : Matrix (Fin 15) (Fin 15) k)) :
            _ →ₐ[k] _)
          (pluckerQuadric k q))) ≤
        Ideal.span (Set.range (pluckerQuadric k))) :
    Ideal.span (Set.range (fun s : Fin 15 ⊕ Fin 15 ↦
      (MvPolynomial.aeval (linearSubst 14
        (lambda2MatrixRepresentation.ρ g : Matrix (Fin 15) (Fin 15) k)) :
          _ →ₐ[k] _)
        (grassmannianLinearSectionEquations k projectorMatrix s))) ≤
      Ideal.span (Set.range
        (grassmannianLinearSectionEquations k projectorMatrix)) :=
  grassmannianLinearSection_span_le_of_parts k projectorMatrix
    (lambda2MatrixRepresentation.ρ g : Matrix (Fin 15) (Fin 15) k)
    hplucker (projector_span_aeval_lambda2_le g)

/-- The scheme-theoretic intersection `Gr(2,6) ∩ P(M)` in the actual
representation coordinates. -/
public abbrev v14Scheme : AlgebraicGeometry.Scheme :=
  grassmannianLinearSection k projectorMatrix

/-- The canonical closed immersion of the coordinate V14 into `P¹⁴`. -/
public abbrev v14Schemeι : v14Scheme ⟶ ProjectiveSpace 14 k :=
  grassmannianLinearSectionι k projectorMatrix

/-- The genuine projective action before restriction to the V14 subscheme. -/
public abbrev ambientSchemeAction : Action AlgebraicGeometry.Scheme G :=
  projectiveAction 14 lambda2MatrixRepresentation.ρ

/-- The ideal sheaf defining the coordinate V14 inside `P¹⁴`. -/
public abbrev v14Ideal : (ProjectiveSpace 14 k).IdealSheafData :=
  projectiveZeroLocusFamilyIdeal 14 k
    (grassmannianLinearSectionEquations k projectorMatrix)

/-- Projective-family naturality for the actual V14 equation family. -/
public theorem v14Ideal_naturality (g : G) :
    v14Ideal.comap
        (mapLinearSubst 14
          (lambda2MatrixRepresentation.ρ g : Matrix (Fin 15) (Fin 15) k)
          ((lambda2MatrixRepresentation.ρ g)⁻¹ : Matrix (Fin 15) (Fin 15) k)
          (by simp)) =
      projectiveZeroLocusFamilyIdeal 14 k (fun s ↦
        (MvPolynomial.aeval (linearSubst 14
          (lambda2MatrixRepresentation.ρ g : Matrix (Fin 15) (Fin 15) k)) :
            _ →ₐ[k] _)
          (grassmannianLinearSectionEquations k projectorMatrix s)) :=
  projectiveZeroLocusFamilyIdeal_comap_mapLinearSubst_aeval 14
    (lambda2MatrixRepresentation.ρ g : Matrix (Fin 15) (Fin 15) k)
    ((lambda2MatrixRepresentation.ρ g)⁻¹ : Matrix (Fin 15) (Fin 15) k)
    (by simp) (grassmannianLinearSectionEquations k projectorMatrix)
    equationDegree equations_isHomogeneous

/-- Honest assembly boundary for the scheme action.  Projective-family
naturality, the projector part, and all homogeneity obligations are discharged
internally.  The remaining input is exactly Plücker-span naturality. -/
public theorem invariantIdeal_of_plucker
    (hplucker : ∀ g : G,
      Ideal.span (Set.range (fun q : Fin 15 ↦
        (MvPolynomial.aeval (linearSubst 14
          (lambda2MatrixRepresentation.ρ g : Matrix (Fin 15) (Fin 15) k)) :
            _ →ₐ[k] _)
          (pluckerQuadric k q))) ≤
        Ideal.span (Set.range (pluckerQuadric k))) :
    IsInvariantIdeal ambientSchemeAction v14Ideal := by
  apply isInvariantIdeal_of_comap_le
  intro g
  change v14Ideal.comap
      (mapLinearSubst 14
        (lambda2MatrixRepresentation.ρ g : Matrix (Fin 15) (Fin 15) k)
        ((lambda2MatrixRepresentation.ρ g)⁻¹ : Matrix (Fin 15) (Fin 15) k)
        (by simp)) ≤ v14Ideal
  exact comap_le_projectiveZeroLocusFamilyIdeal_of_span_le 14
    (lambda2MatrixRepresentation.ρ g : Matrix (Fin 15) (Fin 15) k)
    ((lambda2MatrixRepresentation.ρ g)⁻¹ : Matrix (Fin 15) (Fin 15) k)
    (by simp)
    (grassmannianLinearSectionEquations k projectorMatrix)
    equationDegree equations_isHomogeneous (v14Ideal_naturality g)
    (equations_span_aeval_lambda2_le_of_plucker g (hplucker g))

/-- The genuine V14 scheme action once Plücker-span naturality is supplied. -/
@[expose] public noncomputable def action_of_plucker
    (hplucker : ∀ g : G,
      Ideal.span (Set.range (fun q : Fin 15 ↦
        (MvPolynomial.aeval (linearSubst 14
          (lambda2MatrixRepresentation.ρ g : Matrix (Fin 15) (Fin 15) k)) :
            _ →ₐ[k] _)
          (pluckerQuadric k q))) ≤
        Ideal.span (Set.range (pluckerQuadric k))) :
    Action AlgebraicGeometry.Scheme G :=
  (invariantIdeal_of_plucker hplucker).action

/-- The defining ideal sheaf of the coordinate V14 is invariant under the
genuine projective `PSL₂(F₁₁)` action. -/
public theorem invariantIdeal : IsInvariantIdeal ambientSchemeAction v14Ideal :=
  invariantIdeal_of_plucker plucker_span_aeval_lambda2_le

/-- The unconditional genuine `PSL₂(F₁₁)` action on the coordinate V14
scheme. -/
@[expose] public noncomputable def action : Action AlgebraicGeometry.Scheme G :=
  invariantIdeal.action

/-- The canonical closed immersion is equivariant for the restricted V14
action and the ambient projective action. -/
@[reassoc]
public theorem action_hom_v14Schemeι (g : G) :
    action.ρ g ≫ v14Schemeι =
      v14Schemeι ≫ projectiveActionHom lambda2MatrixRepresentation.ρ g :=
  invariantIdeal.hom_subschemeι g

/-- The unconditional V14 action with its canonical structure morphism to
`Spec k`.  This is the base-preserving target used by equivariant rational
maps and proper specialization. -/
@[expose] public noncomputable def actionOver :
    Action (Over (AlgebraicGeometry.Spec (.of k))) G := by
  letI : ambientSchemeAction.V.Over (AlgebraicGeometry.Spec (.of k)) := by
    change (ProjectiveSpace 14 k).Over (AlgebraicGeometry.Spec (.of k))
    infer_instance
  exact invariantIdeal.actionOver fun g ↦ by
    change (projectiveActionHom lambda2MatrixRepresentation.ρ g).IsOver
      (AlgebraicGeometry.Spec (.of k))
    infer_instance

@[simp]
public theorem actionOver_carrier : actionOver.V.left = v14Scheme := rfl

/-- The equivariance square, phrased for the over-base action used by rational
maps and proper specialization. -/
@[reassoc]
public theorem actionOver_hom_v14Schemeι (g : G) :
    (actionOver.ρ g).left ≫ v14Schemeι =
      v14Schemeι ≫ projectiveActionHom lambda2MatrixRepresentation.ρ g :=
  invariantIdeal.hom_subschemeι g

/-- A fixed field-valued point of V14 remains fixed after composing with the
canonical closed immersion into the ambient projective space. -/
public theorem fixed_comp_v14Schemeι
    {L : Type} [Field L]
    (g : G) (p : AlgebraicGeometry.Spec (.of L) ⟶ actionOver.V.left)
    (hfixed : p ≫ (actionOver.ρ g).left = p) :
    (p ≫ v14Schemeι) ≫ projectiveActionHom lambda2MatrixRepresentation.ρ g =
      p ≫ v14Schemeι := by
  calc
    (p ≫ v14Schemeι) ≫ projectiveActionHom lambda2MatrixRepresentation.ρ g =
        p ≫ (v14Schemeι ≫
          projectiveActionHom lambda2MatrixRepresentation.ρ g) :=
      Category.assoc _ _ _
    _ = p ≫ ((actionOver.ρ g).left ≫ v14Schemeι) := by
      rw [actionOver_hom_v14Schemeι]
      rfl
    _ = (p ≫ (actionOver.ρ g).left) ≫ v14Schemeι :=
      (Category.assoc _ _ _).symm
    _ = p ≫ v14Schemeι := congrArg (fun f ↦ f ≫ v14Schemeι) hfixed

end V14SchemeModel
end V14Formalization
