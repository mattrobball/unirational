/-
Copyright (c) 2026 V14Formalization contributors.
Released under Apache 2.0 license.
-/
module

public import V14Formalization.Lambda4Coordinates
public import V14Formalization.ProjMapZeroLocus
public import V14Formalization.ProjectiveSpaceIntrinsicBasis
public import V14Formalization.IntrinsicV14Action

/-!
# The comparison morphism `V₁₄ intrinsic ⟶ V₁₄ coordinate`

The intrinsic `V₁₄` sits in `ℙ(M) = ℙ⁹`, the coordinate one in
`ProjectiveSpace 14 k = ℙ(⋀²U)`.  The comparison is `Proj.map` along

    MvPolynomial (Fin 15) k  ≃  Sym ((⋀²U)*)  →  Sym (M*)  ↠  Sym (M*) ⧸ I

— the basis isomorphism of a lex `Λ²` basis, then restriction of linear forms
along `incl`, then the quotient by the Plücker ideal.  Its side condition holds
because `incl` has a retraction, and the whole composite kills all thirty
defining equations of the coordinate model:

* the fifteen linear cuts `(P − I)x` because `P` is the identity on `M`;
* the fifteen Plücker quadrics because, up to the factor of two supplied by
  `Lambda4Coordinates.lex4_repr_wedge_self`, they *are* the intrinsic quadrics
  of the wedge pairing.

Both are checked by evaluating at points of `M`, which determines an element of
`Sym (M*)` over an infinite field (`IntrinsicQuadrics.eq_of_evalAt_eq`).  With
`SchemeGeometry.liftToZeroLocusFamily` this factors the morphism through the
closed subscheme.
-/

set_option linter.unusedSectionVars false

noncomputable section

open CategoryTheory
open scoped AlgebraicGeometry HomogeneousIdeal

universe u

namespace V14Formalization
namespace IntrinsicV14Compare

open AlgebraicGeometry Module SymmetricAlgebra BConicBundleMultisections
open V14Formalization.SchemeGeometry V14Formalization.IntrinsicV14

attribute [local instance] MvPolynomial.gradedAlgebra

variable {k : Type u} [Field k] {U : Type u} [AddCommGroup U] [Module k U]
  [FiniteDimensional k U] [Module.Free k U]
  {M : Type u} [AddCommGroup M] [Module k M] [FiniteDimensional k M]
  (incl : M →ₗ[k] ↥(⋀[k]^2 U)) (c : Basis (Fin 6) k U)

/-! ## The symmetric-algebra half -/

/-- The comparison at the level of symmetric algebras: read a polynomial in the
fifteen Plücker coordinates as a form on `⋀²U`, then restrict it to `M`. -/
@[expose] public def symCompare :
    MvPolynomial (Fin 15) k →ₐ[k] SymmetricAlgebra k (Dual k M) :=
  (SymmetricAlgebra.map (incl.dualMap)).comp
    (SymmetricAlgebra.equivMvPolynomial
      (Lambda4Coordinates.lex2 c).dualBasis).symm.toAlgHom

public theorem symCompare_X (j : Fin 15) :
    symCompare incl c (MvPolynomial.X j) =
      SymmetricAlgebra.ι k (Dual k M)
        (incl.dualMap ((Lambda4Coordinates.lex2 c).dualBasis j)) := by
  show SymmetricAlgebra.map (incl.dualMap)
      ((SymmetricAlgebra.equivMvPolynomial
        (Lambda4Coordinates.lex2 c).dualBasis).symm (MvPolynomial.X j)) = _
  rw [show (SymmetricAlgebra.equivMvPolynomial
      (Lambda4Coordinates.lex2 c).dualBasis).symm (MvPolynomial.X j) =
      SymmetricAlgebra.ι k _ ((Lambda4Coordinates.lex2 c).dualBasis j) from by
    apply (SymmetricAlgebra.equivMvPolynomial (Lambda4Coordinates.lex2 c).dualBasis).injective
    rw [AlgEquiv.apply_symm_apply, SymmetricAlgebra.equivMvPolynomial_ι_apply]]
  rw [SymmetricAlgebra.map_ι]

/-- Evaluating the comparison at a point of `M` is evaluating the polynomial at
the Plücker coordinates of that point. -/
public theorem evalAt_symCompare (x : M) (p : MvPolynomial (Fin 15) k) :
    IntrinsicQuadrics.evalAt x (symCompare incl c p) =
      MvPolynomial.aeval ((Lambda4Coordinates.lex2 c).equivFun (incl x)) p := by
  have hext : ((IntrinsicQuadrics.evalAt x).comp (symCompare incl c) :
        MvPolynomial (Fin 15) k →ₐ[k] k) =
      MvPolynomial.aeval ((Lambda4Coordinates.lex2 c).equivFun (incl x)) := by
    apply MvPolynomial.algHom_ext
    intro j
    show IntrinsicQuadrics.evalAt x (symCompare incl c (MvPolynomial.X j)) = _
    rw [symCompare_X, IntrinsicQuadrics.evalAt_ι, MvPolynomial.aeval_X]
    simp [Basis.equivFun_apply]
  exact congr($hext p)

/-! ## The thirty equations die -/

variable (P : Matrix (Fin 15) (Fin 15) k)

/-- The fifteen linear cuts die because `P` fixes the Plücker coordinates of
every point of `M`. -/
public theorem symCompare_projectorLinearCut [Infinite k]
    (hP : ∀ x : M, P.mulVec ((Lambda4Coordinates.lex2 c).equivFun (incl x)) =
      (Lambda4Coordinates.lex2 c).equivFun (incl x)) (i : Fin 15) :
    symCompare incl c (projectorLinearCut k P i) = 0 := by
  refine IntrinsicQuadrics.eq_of_evalAt_eq fun x => ?_
  rw [evalAt_symCompare, map_zero]
  exact (projectorLinearCuts_vanish_iff k P _).2 (hP x) i

/-- The fifteen Plücker quadrics become the intrinsic quadrics, up to the
factor of two. -/
public theorem two_smul_symCompare_pluckerQuadric [Infinite k] (q : Fin 15) :
    (2 : k) • symCompare incl c (pluckerQuadric k q) =
      IntrinsicQuadrics.quadrics (wedgeOn k U incl)
        ((Lambda4Coordinates.lex4 c).coord q) := by
  refine IntrinsicQuadrics.eq_of_evalAt_eq fun x => ?_
  rw [map_smul, evalAt_symCompare, IntrinsicQuadrics.evalAt_quadrics]
  show (2 : k) • MvPolynomial.eval ((Lambda4Coordinates.lex2 c).equivFun (incl x))
      (pluckerQuadric k q) = _
  rw [smul_eq_mul, ← Lambda4Coordinates.lex4_repr_wedge_self c (incl x) q]
  rfl

public theorem symCompare_pluckerQuadric_mem [Infinite k] (h2 : (2 : k) ≠ 0) (q : Fin 15) :
    symCompare incl c (pluckerQuadric k q) ∈ (pluckerIdeal k U incl).toIdeal := by
  have hmem : IntrinsicQuadrics.quadrics (wedgeOn k U incl)
      ((Lambda4Coordinates.lex4 c).coord q) ∈ (pluckerIdeal k U incl).toIdeal :=
    IntrinsicQuadrics.quadrics_mem_quadricIdeal _ _
  rw [← two_smul_symCompare_pluckerQuadric incl c q] at hmem
  have hinv : symCompare incl c (pluckerQuadric k q) =
      (2 : k)⁻¹ • ((2 : k) • symCompare incl c (pluckerQuadric k q)) := by
    rw [smul_smul, inv_mul_cancel₀ h2, one_smul]
  rw [hinv, Algebra.smul_def]
  exact Ideal.mul_mem_left _ _ hmem

/-! ## The graded map, and the morphism to `ℙ¹⁴` -/

variable (retr : ↥(⋀[k]^2 U) →ₗ[k] M) (hretr : retr ∘ₗ incl = LinearMap.id)

include hretr in
public theorem irrelevant_le_symMapIncl :
    (grade k (Dual k M))₊ ≤
      ((grade k (Dual k ↥(⋀[k]^2 U)))₊).map
        (SymmetricAlgebra.gradedMap (incl.dualMap)).toGradedRingHom := by
  refine irrelevant_le_map_of_rightInverse (SymmetricAlgebra.gradedMap (incl.dualMap))
    (SymmetricAlgebra.gradedMap (retr.dualMap)) fun y => ?_
  show SymmetricAlgebra.map (incl.dualMap) (SymmetricAlgebra.map (retr.dualMap) y) = y
  rw [show SymmetricAlgebra.map (incl.dualMap) (SymmetricAlgebra.map (retr.dualMap) y) =
      ((SymmetricAlgebra.map (incl.dualMap)).comp
        (SymmetricAlgebra.map (retr.dualMap))) y from rfl]
  rw [SymmetricAlgebra.map_comp, LinearMap.dualMap_comp_dualMap incl retr, hretr,
    LinearMap.dualMap_id, SymmetricAlgebra.map_id]
  rfl

/-- The comparison as a graded ring map into the homogeneous coordinate ring of
the intrinsic `V₁₄`. -/
@[expose] public def gradedCompare :
    MvPolynomial.homogeneousSubmodule (Fin 15) k →+*ᵍ IntrinsicV14.coordinateRing k U incl :=
  (GradedQuotient.mkGraded (grade k (Dual k M)) (pluckerIdeal k U incl)).comp
    ((SymmetricAlgebra.gradedMap (incl.dualMap)).toGradedRingHom.comp
      (bridgeOfBasisSymm (d := 14) (Lambda4Coordinates.lex2 c)).toGradedRingHom)

public theorem gradedCompare_apply (p : MvPolynomial (Fin 15) k) :
    gradedCompare incl c p =
      Ideal.Quotient.mk (pluckerIdeal k U incl).toIdeal (symCompare incl c p) :=
  rfl

include hretr in
public theorem irrelevant_le_gradedCompare :
    (IntrinsicV14.coordinateRing k U incl)₊ ≤
      ((MvPolynomial.homogeneousSubmodule (Fin 15) k)₊).map (gradedCompare incl c) :=
  HomogeneousIdeal.irrelevant_le_map_comp
    (HomogeneousIdeal.irrelevant_le_map_comp
      (irrelevant_le_bridgeOfBasisSymm (d := 14) (Lambda4Coordinates.lex2 c))
      (irrelevant_le_symMapIncl incl retr hretr))
    (GradedQuotient.irrelevant_le_map_mkGraded _ _)

/-- The morphism from the intrinsic `V₁₄` to the coordinate `ℙ¹⁴`. -/
@[expose] public def toAmbient14 :
    IntrinsicV14.scheme k U incl ⟶ ProjectiveSpace 14 k :=
  Proj.map (gradedCompare incl c) (irrelevant_le_gradedCompare incl c retr hretr)

/-! ## It lands in the coordinate `V₁₄` -/

include hretr in
/-- Every one of the thirty defining equations of the coordinate model dies. -/
public theorem gradedCompare_equations_eq_zero [Infinite k] (h2 : (2 : k) ≠ 0)
    (hP : ∀ x : M, P.mulVec ((Lambda4Coordinates.lex2 c).equivFun (incl x)) =
      (Lambda4Coordinates.lex2 c).equivFun (incl x))
    (s : Fin 15 ⊕ Fin 15) :
    gradedCompare incl c (grassmannianLinearSectionEquations k P s) = 0 := by
  rw [gradedCompare_apply]
  rcases s with q | i
  · exact (Ideal.Quotient.eq_zero_iff_mem).2 (symCompare_pluckerQuadric_mem incl c h2 q)
  · show Ideal.Quotient.mk _ (symCompare incl c (projectorLinearCut k P i)) = 0
    rw [symCompare_projectorLinearCut incl c P hP i, map_zero]

include hretr in
/-- **The comparison morphism.**  From the intrinsic `V₁₄` to the coordinate
`V₁₄`, over `Spec k` after `compare_toSpec`. -/
@[expose] public def compare [Infinite k] (h2 : (2 : k) ≠ 0)
    (hP : ∀ x : M, P.mulVec ((Lambda4Coordinates.lex2 c).equivFun (incl x)) =
      (Lambda4Coordinates.lex2 c).equivFun (incl x)) :
    IntrinsicV14.scheme k U incl ⟶ grassmannianLinearSection k P :=
  liftToZeroLocusFamily (gradedCompare incl c)
    (irrelevant_le_gradedCompare incl c retr hretr)
    (grassmannianLinearSectionEquations k P)
    (Sum.elim (fun _ => 2) (fun _ => 1))
    (fun s => by
      rcases s with q | i
      · exact pluckerQuadric_isHomogeneous k q
      · exact projectorLinearCut_isHomogeneous k P i)
    (gradedCompare_equations_eq_zero incl c P retr hretr h2 hP)

include hretr in
@[reassoc (attr := simp)]
public theorem compare_ι [Infinite k] (h2 : (2 : k) ≠ 0)
    (hP : ∀ x : M, P.mulVec ((Lambda4Coordinates.lex2 c).equivFun (incl x)) =
      (Lambda4Coordinates.lex2 c).equivFun (incl x)) :
    compare incl c P retr hretr h2 hP ≫ grassmannianLinearSectionι k P
      = toAmbient14 incl c retr hretr :=
  liftToZeroLocusFamily_ι _ _ _ _ _ _

end IntrinsicV14Compare
end V14Formalization
