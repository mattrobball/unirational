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
because `incl` is injective, and the whole composite kills all thirty
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

variable (hsurj : Function.Surjective (incl.dualMap))

include hsurj in
/-- `Sym` of a surjection is surjective in every degree.  This replaces the
retraction: `incl` is injective, so `incl*` is surjective, so `Sym (incl*)`
carries the degree-`i` piece onto the degree-`i` piece. -/
public theorem map_grade_symMapIncl (i : ℕ) :
    Submodule.map (SymmetricAlgebra.map (incl.dualMap)).toLinearMap
        (grade k (Dual k ↥(⋀[k]^2 U)) i) = grade k (Dual k M) i := by
  have hrange : Submodule.map (SymmetricAlgebra.map (incl.dualMap)).toLinearMap
      (LinearMap.range (SymmetricAlgebra.ι k (Dual k ↥(⋀[k]^2 U)))) =
      LinearMap.range (SymmetricAlgebra.ι k (Dual k M)) := by
    rw [← LinearMap.range_comp,
      show (SymmetricAlgebra.map (incl.dualMap)).toLinearMap ∘ₗ
          SymmetricAlgebra.ι k (Dual k ↥(⋀[k]^2 U)) =
          (SymmetricAlgebra.ι k (Dual k M)) ∘ₗ incl.dualMap from
        LinearMap.ext fun φ => SymmetricAlgebra.map_ι _ _,
      LinearMap.range_comp, LinearMap.range_eq_top.2 hsurj, Submodule.map_top]
  have hpow := Submodule.map_pow
    (M := LinearMap.range (SymmetricAlgebra.ι k (Dual k ↥(⋀[k]^2 U))))
    (SymmetricAlgebra.map (incl.dualMap)) i
  show Submodule.map (SymmetricAlgebra.map (incl.dualMap)).toLinearMap
      (LinearMap.range (SymmetricAlgebra.ι k (Dual k ↥(⋀[k]^2 U))) ^ i) =
    LinearMap.range (SymmetricAlgebra.ι k (Dual k M)) ^ i
  rw [hpow, hrange]

include hsurj in
public theorem irrelevant_le_symMapIncl :
    (grade k (Dual k M))₊ ≤
      ((grade k (Dual k ↥(⋀[k]^2 U)))₊).map
        (SymmetricAlgebra.gradedMap (incl.dualMap)).toGradedRingHom := by
  rw [HomogeneousIdeal.irrelevant_le]
  intro i hi y hy
  have hmem : y ∈ Submodule.map (SymmetricAlgebra.map (incl.dualMap)).toLinearMap
      (grade k (Dual k ↥(⋀[k]^2 U)) i) := by
    rw [map_grade_symMapIncl incl hsurj i]
    exact hy
  obtain ⟨x, hx, rfl⟩ := hmem
  exact Ideal.mem_map_of_mem _ (HomogeneousIdeal.mem_irrelevant_of_mem _ hi hx)

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

include hsurj in
public theorem irrelevant_le_gradedCompare :
    (IntrinsicV14.coordinateRing k U incl)₊ ≤
      ((MvPolynomial.homogeneousSubmodule (Fin 15) k)₊).map (gradedCompare incl c) :=
  HomogeneousIdeal.irrelevant_le_map_comp
    (HomogeneousIdeal.irrelevant_le_map_comp
      (irrelevant_le_bridgeOfBasisSymm (d := 14) (Lambda4Coordinates.lex2 c))
      (irrelevant_le_symMapIncl incl hsurj))
    (GradedQuotient.irrelevant_le_map_mkGraded _ _)

/-- The morphism from the intrinsic `V₁₄` to the coordinate `ℙ¹⁴`. -/
@[expose] public def toAmbient14 :
    IntrinsicV14.scheme k U incl ⟶ ProjectiveSpace 14 k :=
  Proj.map (gradedCompare incl c) (irrelevant_le_gradedCompare incl c hsurj)

/-! ## Over `Spec k` -/

include hsurj in
private theorem gradedCompare_zero_comp_algebraMap :
    (gradedCompare incl c).gradedZeroRingHom.comp
        (algebraMap k (MvPolynomial.homogeneousSubmodule (Fin 15) k 0)) =
      algebraMap k (IntrinsicV14.coordinateRing k U incl 0) := by
  apply RingHom.ext
  intro r
  apply Subtype.ext
  show Ideal.Quotient.mk _
      (symCompare incl c (algebraMap k (MvPolynomial (Fin 15) k) r)) = _
  rw [AlgHom.commutes]
  rfl

include hsurj in
/-- The morphism to `ℙ¹⁴` is a morphism over `Spec k`. -/
public theorem toAmbient14_toSpec :
    toAmbient14 incl c hsurj ≫ ProjectiveSpace.toSpec 14 k =
      IntrinsicV14.toSpec k U incl := by
  unfold toAmbient14 ProjectiveSpace.toSpec IntrinsicV14.toSpec IntrinsicV14.scheme
  rw [← Category.assoc, AlgebraicGeometry.Proj.map_toSpecZero]
  rw [Category.assoc, ← Spec.map_comp]
  have hz :
      CommRingCat.ofHom (algebraMap k (MvPolynomial.homogeneousSubmodule (Fin 15) k 0)) ≫
        CommRingCat.ofHom (gradedCompare incl c).gradedZeroRingHom =
      CommRingCat.ofHom (algebraMap k (IntrinsicV14.coordinateRing k U incl 0)) := by
    simpa using congrArg CommRingCat.ofHom
      (gradedCompare_zero_comp_algebraMap incl c hsurj)
  rw [hz]

/-! ## It lands in the coordinate `V₁₄` -/

include hsurj in
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

include hsurj in
/-- **The comparison morphism.**  From the intrinsic `V₁₄` to the coordinate
`V₁₄`, over `Spec k` after `compare_toSpec`. -/
@[expose] public def compare [Infinite k] (h2 : (2 : k) ≠ 0)
    (hP : ∀ x : M, P.mulVec ((Lambda4Coordinates.lex2 c).equivFun (incl x)) =
      (Lambda4Coordinates.lex2 c).equivFun (incl x)) :
    IntrinsicV14.scheme k U incl ⟶ grassmannianLinearSection k P :=
  liftToZeroLocusFamily (gradedCompare incl c)
    (irrelevant_le_gradedCompare incl c hsurj)
    (grassmannianLinearSectionEquations k P)
    (Sum.elim (fun _ => 2) (fun _ => 1))
    (fun s => by
      rcases s with q | i
      · exact pluckerQuadric_isHomogeneous k q
      · exact projectorLinearCut_isHomogeneous k P i)
    (gradedCompare_equations_eq_zero incl c P hsurj h2 hP)

include hsurj in
@[reassoc (attr := simp)]
public theorem compare_ι [Infinite k] (h2 : (2 : k) ≠ 0)
    (hP : ∀ x : M, P.mulVec ((Lambda4Coordinates.lex2 c).equivFun (incl x)) =
      (Lambda4Coordinates.lex2 c).equivFun (incl x)) :
    compare incl c P hsurj h2 hP ≫ grassmannianLinearSectionι k P
      = toAmbient14 incl c hsurj :=
  liftToZeroLocusFamily_ι _ _ _ _ _ _

include hsurj in
/-- The comparison is a morphism over `Spec k`. -/
public theorem compare_toSpec [Infinite k] (h2 : (2 : k) ≠ 0)
    (hP : ∀ x : M, P.mulVec ((Lambda4Coordinates.lex2 c).equivFun (incl x)) =
      (Lambda4Coordinates.lex2 c).equivFun (incl x)) :
    compare incl c P hsurj h2 hP ≫
        projectiveZeroLocusFamilyToSpec 14 k (grassmannianLinearSectionEquations k P) =
      IntrinsicV14.toSpec k U incl := by
  rw [projectiveZeroLocusFamilyToSpec, ← Category.assoc, compare_ι, toAmbient14_toSpec]

/-! ## Equivariance

The comparison intertwines the intrinsic action with the coordinate one.  Both
sides are `Proj.map`s, so the whole content is one identity of graded ring maps,
checked on the fifteen variables, where it says exactly that `A` is the matrix
of `⋀²f` in the lex basis.
-/

variable (α : M →ₗ[k] M) (hα : IntrinsicV14.Covers k U incl α)
  (A : Matrix (Fin 15) (Fin 15) k)

/-- The intertwining identity at the level of graded rings. -/
public theorem gradedCompare_intertwines
    (hA : ∀ (x : M) (j : Fin 15),
      (Lambda4Coordinates.lex2 c).equivFun (incl (α x)) j =
        ∑ l : Fin 15, A j l * (Lambda4Coordinates.lex2 c).equivFun (incl x) l) :
    (IntrinsicV14.quotMap k U incl α hα).comp (gradedCompare incl c) =
      (gradedCompare incl c).comp (linearSubstGradedRingHom 14 A) := by
  have hdual : ∀ j : Fin 15,
      α.dualMap (incl.dualMap ((Lambda4Coordinates.lex2 c).dualBasis j)) =
        ∑ l : Fin 15, A j l • incl.dualMap ((Lambda4Coordinates.lex2 c).dualBasis l) := by
    intro j
    refine LinearMap.ext fun x => ?_
    show (Lambda4Coordinates.lex2 c).dualBasis j (incl (α x)) = _
    rw [Basis.dualBasis_apply]
    simp only [LinearMap.coe_sum, Finset.sum_apply, LinearMap.smul_apply,
      LinearMap.dualMap_apply, Basis.dualBasis_apply, smul_eq_mul]
    simpa [Basis.equivFun_apply] using hA x j
  have halg : ((Ideal.Quotient.mkₐ k (pluckerIdeal k U incl).toIdeal).comp
        ((SymmetricAlgebra.map α.dualMap).comp (symCompare incl c))) =
      ((Ideal.Quotient.mkₐ k (pluckerIdeal k U incl).toIdeal).comp
        ((symCompare incl c).comp
          (MvPolynomial.aeval (linearSubst 14 A) :
            MvPolynomial (Fin 15) k →ₐ[k] MvPolynomial (Fin 15) k))) := by
    apply MvPolynomial.algHom_ext
    intro j
    show Ideal.Quotient.mk _ (SymmetricAlgebra.map α.dualMap
        (symCompare incl c (MvPolynomial.X j))) =
      Ideal.Quotient.mk _ (symCompare incl c
        (MvPolynomial.aeval (linearSubst 14 A) (MvPolynomial.X j)))
    congr 1
    rw [symCompare_X, SymmetricAlgebra.map_ι, hdual j, MvPolynomial.aeval_X, linearSubst,
      map_sum (SymmetricAlgebra.ι k (Dual k M)), map_sum (symCompare incl c)]
    refine Finset.sum_congr rfl fun l _ => ?_
    rw [map_smul, map_mul, symCompare_X,
      show symCompare incl c (MvPolynomial.C (A j l)) =
          algebraMap k (SymmetricAlgebra k (Dual k M)) (A j l) by
        rw [← MvPolynomial.algebraMap_eq]; exact AlgHom.commutes _ _,
      Algebra.smul_def]
  refine GradedRingHom.ext fun p => ?_
  exact congr($halg p)

variable (β : M →ₗ[k] M) (N : Matrix (Fin 15) (Fin 15) k)

include hsurj in
/-- The intertwining identity at the level of schemes. -/
public theorem schemeMap_comp_toAmbient14
    (hinvα : β ∘ₗ α = LinearMap.id) (hAN : N * A = 1)
    (hA : ∀ (x : M) (j : Fin 15),
      (Lambda4Coordinates.lex2 c).equivFun (incl (α x)) j =
        ∑ l : Fin 15, A j l * (Lambda4Coordinates.lex2 c).equivFun (incl x) l) :
    IntrinsicV14.schemeMap k U incl α β hα hinvα ≫ toAmbient14 incl c hsurj =
      toAmbient14 incl c hsurj ≫ mapLinearSubst 14 A N hAN := by
  have hL : IntrinsicV14.schemeMap k U incl α β hα hinvα ≫ toAmbient14 incl c hsurj =
      Proj.map ((IntrinsicV14.quotMap k U incl α hα).comp (gradedCompare incl c))
        (HomogeneousIdeal.irrelevant_le_map_comp
          (irrelevant_le_gradedCompare incl c hsurj)
          (IntrinsicV14.irrelevant_le_quotMap k U incl α β hα hinvα)) :=
    (Proj.map_comp _ _ _ _).symm
  have hR : toAmbient14 incl c hsurj ≫ mapLinearSubst 14 A N hAN =
      Proj.map ((gradedCompare incl c).comp (linearSubstGradedRingHom 14 A))
        (HomogeneousIdeal.irrelevant_le_map_comp
          (irrelevant_le_map_linearSubst 14 A N hAN)
          (irrelevant_le_gradedCompare incl c hsurj)) :=
    (Proj.map_comp _ _ _ _).symm
  rw [hL, hR]
  exact AlgebraicGeometry.Proj.map_congr
    (gradedCompare_intertwines incl c α hα A hA) _ _

end IntrinsicV14Compare
end V14Formalization
