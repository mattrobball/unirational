/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
import Mathlib

/-!
This is the trusted comparator statement interface.  It intentionally imports only `Mathlib`.
The vocabulary below is duplicated in `Solution/Definitions.lean`; keeping those declarations
structurally identical lets the comparator check the theorem without unchecked definition holes.
-/

@[expose] public section

namespace Bidegree23Unirationality

open Finsupp

/-- The two blocks of Cox coordinates for `ℙᵐ × ℙⁿ`. -/
abbrev BiprojectiveCoordinate (m n : ℕ) := Sum (Fin (m + 1)) (Fin (n + 1))

/-- The standard `ℕ × ℕ` weight of a Cox coordinate on `ℙᵐ × ℙⁿ`. -/
def bidegreeWeight {m n : ℕ} : BiprojectiveCoordinate m n → ℕ × ℕ
  | .inl _ => (1, 0)
  | .inr _ => (0, 1)

/-- A polynomial in the two blocks of Cox coordinates is bihomogeneous of bidegree `(a, b)`. -/
def IsBihomogeneousOfBidegree {m n : ℕ} {R : Type*} [CommSemiring R]
    (a b : ℕ) (F : MvPolynomial (BiprojectiveCoordinate m n) R) : Prop :=
  F.IsWeightedHomogeneous bidegreeWeight (a, b)

/-- The exact polynomial-level predicate for bidegree `(2, 3)`. -/
abbrev IsBidegree23 {m n : ℕ} {R : Type*} [CommSemiring R]
    (F : MvPolynomial (BiprojectiveCoordinate m n) R) : Prop :=
  IsBihomogeneousOfBidegree 2 3 F
end Bidegree23Unirationality

@[expose] public section

open CategoryTheory Limits
open scoped AlgebraicGeometry

namespace Bidegree23Unirationality

noncomputable section

universe u

open AlgebraicGeometry

attribute [local instance] MvPolynomial.gradedAlgebra

/-- Scheme-level projective `n`-space over a commutative ring `R`. -/
abbrev ProjectiveSpace (n : ℕ) (R : Type u) [CommRing R] : Scheme.{u} :=
  Proj (MvPolynomial.homogeneousSubmodule (Fin (n + 1)) R)

namespace ProjectiveSpace

/-- The structure morphism from projective `n`-space over `R` to `Spec R`. -/
def toSpec (n : ℕ) (R : Type u) [CommRing R] : ProjectiveSpace n R ⟶ Spec (.of R) :=
  Proj.toSpecZero (MvPolynomial.homogeneousSubmodule (Fin (n + 1)) R) ≫
    Spec.map (CommRingCat.ofHom
      (algebraMap R (MvPolynomial.homogeneousSubmodule (Fin (n + 1)) R 0)))

instance (n : ℕ) (R : Type u) [CommRing R] :
    (ProjectiveSpace n R).CanonicallyOver (Spec (.of R)) where
  hom := toSpec n R

/-- The degree-zero homogeneous localization defining the `i`-th standard affine chart. -/
abbrev StandardChartRing (n : ℕ) (R : Type u) [CommRing R] (i : Fin (n + 1)) : Type u :=
  HomogeneousLocalization.Away (MvPolynomial.homogeneousSubmodule (Fin (n + 1)) R)
    (MvPolynomial.X i)

/-- The canonical ring homomorphism from `R` to the ring of the `i`-th standard chart. -/
def standardChartRingHom (n : ℕ) (R : Type u) [CommRing R] (i : Fin (n + 1)) :
    R →+* StandardChartRing n R i :=
  (algebraMap (MvPolynomial.homogeneousSubmodule (Fin (n + 1)) R 0)
    (StandardChartRing n R i)).comp
      (algebraMap R (MvPolynomial.homogeneousSubmodule (Fin (n + 1)) R 0))

/-- The canonical `R`-algebra structure on a standard projective-space chart. -/
instance standardChartRingAlgebra (n : ℕ) (R : Type u) [CommRing R]
    (i : Fin (n + 1)) : Algebra R (StandardChartRing n R i) where
  smul := (inferInstance : SMul R (StandardChartRing n R i)).smul
  algebraMap := standardChartRingHom n R i
  commutes' _ _ := mul_comm _ _
  smul_def' r x := by
    apply HomogeneousLocalization.val_injective
    rw [HomogeneousLocalization.val_smul, HomogeneousLocalization.val_mul, Algebra.smul_def]
    rfl

/-- The `i`-th standard open subset `D₊(Xᵢ)` of projective `n`-space. -/
def standardChart (n : ℕ) (R : Type u) [CommRing R] (i : Fin (n + 1)) :
    (ProjectiveSpace n R).Opens :=
  Proj.basicOpen (MvPolynomial.homogeneousSubmodule (Fin (n + 1)) R) (MvPolynomial.X i)

/-- The standard open immersion `Spec (R[X₀, …, Xₙ]_(Xᵢ))₀ ⟶ ℙⁿ_R`. -/
def standardChartι (n : ℕ) (R : Type u) [CommRing R] (i : Fin (n + 1)) :
    Spec (.of (StandardChartRing n R i)) ⟶ ProjectiveSpace n R :=
  Proj.awayι (MvPolynomial.homogeneousSubmodule (Fin (n + 1)) R) (MvPolynomial.X i)
    (MvPolynomial.isHomogeneous_X R i) zero_lt_one

instance (n : ℕ) (R : Type u) [CommRing R] (i : Fin (n + 1)) :
    IsOpenImmersion (standardChartι n R i) :=
  show IsOpenImmersion
    (Proj.awayι (MvPolynomial.homogeneousSubmodule (Fin (n + 1)) R) (MvPolynomial.X i)
      (MvPolynomial.isHomogeneous_X R i) zero_lt_one) from
    inferInstance

@[simp]
theorem opensRange_standardChartι (n : ℕ) (R : Type u) [CommRing R]
    (i : Fin (n + 1)) :
    (standardChartι n R i).opensRange = standardChart n R i :=
  Proj.opensRange_awayι (MvPolynomial.homogeneousSubmodule (Fin (n + 1)) R)
    (MvPolynomial.X i) (MvPolynomial.isHomogeneous_X R i) zero_lt_one

@[reassoc]
theorem standardChartι_toSpec (n : ℕ) (R : Type u) [CommRing R]
    (i : Fin (n + 1)) :
    standardChartι n R i ≫ toSpec n R =
      Spec.map (CommRingCat.ofHom (algebraMap R (StandardChartRing n R i))) := by
  unfold standardChartι toSpec
  rw [Proj.awayι_toSpecZero_assoc, ← Spec.map_comp]
  change Spec.map (CommRingCat.ofHom (standardChartRingHom n R i)) = _
  rfl

/-- Every standard chart of projective space is affine. -/
theorem isAffineOpen_standardChart (n : ℕ) (R : Type u) [CommRing R]
    (i : Fin (n + 1)) : IsAffineOpen (standardChart n R i) :=
  Proj.isAffineOpen_basicOpen (MvPolynomial.homogeneousSubmodule (Fin (n + 1)) R)
    (MvPolynomial.X i) (MvPolynomial.isHomogeneous_X R i) zero_lt_one

/-- The irrelevant ideal of the homogeneous coordinate ring is generated by the variables. -/
theorem irrelevant_le_span_X (n : ℕ) (R : Type u) [CommRing R] :
    (HomogeneousIdeal.irrelevant
      (MvPolynomial.homogeneousSubmodule (Fin (n + 1)) R)).toIdeal ≤
      Ideal.span (Set.range
        (MvPolynomial.X : Fin (n + 1) → MvPolynomial (Fin (n + 1)) R)) := by
  rw [HomogeneousIdeal.toIdeal_irrelevant_le]
  intro d hd p hp
  change p ∈ MvPolynomial.idealOfVars (Fin (n + 1)) R
  rw [← pow_one (MvPolynomial.idealOfVars (Fin (n + 1)) R),
    MvPolynomial.mem_pow_idealOfVars_iff]
  intro monomial hmonomial
  rw [Finsupp.degree_apply, ← hp.degree_eq_sum_deg_support hmonomial]
  exact Nat.succ_le_iff.mpr hd

/-- The affine open cover of projective `n`-space by its standard charts. -/
@[simps! f]
def standardAffineOpenCover (n : ℕ) (R : Type u) [CommRing R] :
    (ProjectiveSpace n R).AffineOpenCover :=
  Proj.affineOpenCoverOfIrrelevantLESpan
    (MvPolynomial.homogeneousSubmodule (Fin (n + 1)) R)
    (MvPolynomial.X : Fin (n + 1) → MvPolynomial (Fin (n + 1)) R)
    (fun i ↦ MvPolynomial.isHomogeneous_X R i) (fun _ ↦ zero_lt_one)
    (irrelevant_le_span_X n R)

end ProjectiveSpace

/-- The scheme `ℙᵐ_R ×_{Spec R} ℙⁿ_R`. -/
abbrev BiprojectiveSpace (m n : ℕ) (R : Type u) [CommRing R] : Scheme.{u} :=
  pullback (ProjectiveSpace.toSpec m R) (ProjectiveSpace.toSpec n R)

namespace BiprojectiveSpace

/-- The first projection from `ℙᵐ_R ×_{Spec R} ℙⁿ_R`. -/
abbrev fst (m n : ℕ) (R : Type u) [CommRing R] :
    BiprojectiveSpace m n R ⟶ ProjectiveSpace m R :=
  pullback.fst (ProjectiveSpace.toSpec m R) (ProjectiveSpace.toSpec n R)

/-- The second projection from `ℙᵐ_R ×_{Spec R} ℙⁿ_R`. -/
abbrev snd (m n : ℕ) (R : Type u) [CommRing R] :
    BiprojectiveSpace m n R ⟶ ProjectiveSpace n R :=
  pullback.snd (ProjectiveSpace.toSpec m R) (ProjectiveSpace.toSpec n R)

/-- The structure morphism from `ℙᵐ_R ×_{Spec R} ℙⁿ_R` to `Spec R`. -/
def toSpec (m n : ℕ) (R : Type u) [CommRing R] :
    BiprojectiveSpace m n R ⟶ Spec (.of R) :=
  fst m n R ≫ ProjectiveSpace.toSpec m R

instance (m n : ℕ) (R : Type u) [CommRing R] :
    (BiprojectiveSpace m n R).CanonicallyOver (Spec (.of R)) where
  hom := toSpec m n R

@[reassoc]
theorem fst_toSpec (m n : ℕ) (R : Type u) [CommRing R] :
    fst m n R ≫ ProjectiveSpace.toSpec m R = toSpec m n R :=
  rfl

@[reassoc]
theorem snd_toSpec (m n : ℕ) (R : Type u) [CommRing R] :
    snd m n R ≫ ProjectiveSpace.toSpec n R = toSpec m n R :=
  (pullback.condition : fst m n R ≫ ProjectiveSpace.toSpec m R =
    snd m n R ≫ ProjectiveSpace.toSpec n R).symm

/-- The tensor-product coordinate ring of a standard chart of `ℙᵐ_R ×_R ℙⁿ_R`. -/
abbrev StandardChartRing (m n : ℕ) (R : Type u) [CommRing R]
    (i : Fin (m + 1)) (j : Fin (n + 1)) : Type u :=
  TensorProduct R (ProjectiveSpace.StandardChartRing m R i)
    (ProjectiveSpace.StandardChartRing n R j)

/-- The pullback of standard charts of `ℙᵐ_R` and `ℙⁿ_R` over `Spec R`. -/
abbrev standardChart (m n : ℕ) (R : Type u) [CommRing R]
    (i : Fin (m + 1)) (j : Fin (n + 1)) : Scheme.{u} :=
  pullback
    (ProjectiveSpace.standardChartι m R i ≫ ProjectiveSpace.toSpec m R)
    (ProjectiveSpace.standardChartι n R j ≫ ProjectiveSpace.toSpec n R)

/-- The tensor-product spectrum is a pullback of the two standard affine charts over `Spec R`. -/
theorem standardChartSpec_isPullback (m n : ℕ) (R : Type u) [CommRing R]
    (i : Fin (m + 1)) (j : Fin (n + 1)) :
    IsPullback
      (Spec.map (CommRingCat.ofHom Algebra.TensorProduct.includeLeftRingHom))
      (Spec.map (CommRingCat.ofHom
        (Algebra.TensorProduct.includeRight
          (R := R)
          (A := ProjectiveSpace.StandardChartRing m R i)
          (B := ProjectiveSpace.StandardChartRing n R j)).toRingHom))
      (ProjectiveSpace.standardChartι m R i ≫ ProjectiveSpace.toSpec m R)
      (ProjectiveSpace.standardChartι n R j ≫ ProjectiveSpace.toSpec n R) := by
  rw [ProjectiveSpace.standardChartι_toSpec, ProjectiveSpace.standardChartι_toSpec]
  apply IsPullback.of_iso_pullback (by
      refine ⟨?_⟩
      rw [← Spec.map_comp, ← Spec.map_comp]
      congr 1
      ext r
      simp [Algebra.TensorProduct.algebraMap_def])
    (pullbackSpecIso R (ProjectiveSpace.StandardChartRing m R i)
      (ProjectiveSpace.StandardChartRing n R j)).symm
  · exact pullbackSpecIso_inv_fst R _ _
  · exact pullbackSpecIso_inv_snd R _ _

/-- A standard product chart is the spectrum of the tensor product of its two chart rings. -/
def standardChartIsoSpec (m n : ℕ) (R : Type u) [CommRing R]
    (i : Fin (m + 1)) (j : Fin (n + 1)) :
    standardChart m n R i j ≅ Spec (.of (StandardChartRing m n R i j)) :=
  (standardChartSpec_isPullback m n R i j).isoPullback.symm

@[reassoc]
theorem standardChartIsoSpec_inv_fst (m n : ℕ) (R : Type u) [CommRing R]
    (i : Fin (m + 1)) (j : Fin (n + 1)) :
    (standardChartIsoSpec m n R i j).inv ≫ pullback.fst _ _ =
      Spec.map (CommRingCat.ofHom Algebra.TensorProduct.includeLeftRingHom) :=
  (standardChartSpec_isPullback m n R i j).isoPullback_hom_fst

@[reassoc]
theorem standardChartIsoSpec_inv_snd (m n : ℕ) (R : Type u) [CommRing R]
    (i : Fin (m + 1)) (j : Fin (n + 1)) :
    (standardChartIsoSpec m n R i j).inv ≫ pullback.snd _ _ =
      Spec.map (CommRingCat.ofHom
        (Algebra.TensorProduct.includeRight
          (R := R)
          (A := ProjectiveSpace.StandardChartRing m R i)
          (B := ProjectiveSpace.StandardChartRing n R j)).toRingHom) :=
  (standardChartSpec_isPullback m n R i j).isoPullback_hom_snd

/-- The standard affine open cover of `ℙᵐ_R ×_R ℙⁿ_R`. -/
def standardOpenCover (m n : ℕ) (R : Type u) [CommRing R] :
    (BiprojectiveSpace m n R).OpenCover :=
  Scheme.Pullback.openCoverOfLeftRight
    (ProjectiveSpace.standardAffineOpenCover m R).openCover
    (ProjectiveSpace.standardAffineOpenCover n R).openCover
    (ProjectiveSpace.toSpec m R) (ProjectiveSpace.toSpec n R)

/-- The standard open immersion from the product chart indexed by `(i, j)`. -/
abbrev standardChartι (m n : ℕ) (R : Type u) [CommRing R]
    (i : Fin (m + 1)) (j : Fin (n + 1)) :
    standardChart m n R i j ⟶ BiprojectiveSpace m n R :=
  (standardOpenCover m n R).f (i, j)

instance (m n : ℕ) (R : Type u) [CommRing R]
    (i : Fin (m + 1)) (j : Fin (n + 1)) :
    IsOpenImmersion (standardChartι m n R i j) :=
  (standardOpenCover m n R).map_prop (i, j)

end BiprojectiveSpace

end

end Bidegree23Unirationality

@[expose] public section

open scoped TensorProduct

namespace Bidegree23Unirationality

noncomputable section

universe u

attribute [local instance] MvPolynomial.gradedAlgebra

namespace ProjectiveSpace

/-- The homogeneous coordinate `Xₗ`, divided by the distinguished chart coordinate `Xᵢ`. -/
def normalizedCoordinate (n : ℕ) (R : Type u) [CommRing R] (i l : Fin (n + 1)) :
    StandardChartRing n R i :=
  HomogeneousLocalization.Away.mk
    (MvPolynomial.homogeneousSubmodule (Fin (n + 1)) R)
    (MvPolynomial.isHomogeneous_X R i) 1
    (MvPolynomial.X l)
    (by simpa using MvPolynomial.isHomogeneous_X R l)

@[simp]
theorem normalizedCoordinate_self (n : ℕ) (R : Type u) [CommRing R]
    (i : Fin (n + 1)) : normalizedCoordinate n R i i = 1 := by
  rw [HomogeneousLocalization.ext_iff_val]
  simp [normalizedCoordinate, HomogeneousLocalization.Away.val_mk,
    HomogeneousLocalization.val_one]

end ProjectiveSpace

namespace BiprojectiveSpace

/--
The value of a Cox coordinate on the standard product chart indexed by `(i, j)`.

Coordinates from the first projective-space factor enter the left tensor factor, and coordinates
from the second projective-space factor enter the right tensor factor.
-/
def chartVariable (m n : ℕ) (R : Type u) [CommRing R]
    (i : Fin (m + 1)) (j : Fin (n + 1)) :
    BiprojectiveCoordinate m n → StandardChartRing m n R i j
  | .inl l => ProjectiveSpace.normalizedCoordinate m R i l ⊗ₜ[R] 1
  | .inr l => 1 ⊗ₜ[R] ProjectiveSpace.normalizedCoordinate n R j l

@[simp]
theorem chartVariable_inl (m n : ℕ) (R : Type u) [CommRing R]
    (i l : Fin (m + 1)) (j : Fin (n + 1)) :
    chartVariable m n R i j (.inl l) =
      ProjectiveSpace.normalizedCoordinate m R i l ⊗ₜ[R] 1 :=
  rfl

@[simp]
theorem chartVariable_inr (m n : ℕ) (R : Type u) [CommRing R]
    (i : Fin (m + 1)) (j l : Fin (n + 1)) :
    chartVariable m n R i j (.inr l) =
      1 ⊗ₜ[R] ProjectiveSpace.normalizedCoordinate n R j l :=
  rfl

/-- Evaluation of Cox polynomials on the standard product chart indexed by `(i, j)`. -/
def chartEvaluation (m n : ℕ) (R : Type u) [CommRing R]
    (i : Fin (m + 1)) (j : Fin (n + 1)) :
    MvPolynomial (BiprojectiveCoordinate m n) R →ₐ[R] StandardChartRing m n R i j :=
  MvPolynomial.aeval (chartVariable m n R i j)

@[simp]
theorem chartEvaluation_X_inl (m n : ℕ) (R : Type u) [CommRing R]
    (i l : Fin (m + 1)) (j : Fin (n + 1)) :
    chartEvaluation m n R i j (MvPolynomial.X (.inl l)) =
      ProjectiveSpace.normalizedCoordinate m R i l ⊗ₜ[R] 1 := by
  simp [chartEvaluation]

@[simp]
theorem chartEvaluation_X_inr (m n : ℕ) (R : Type u) [CommRing R]
    (i : Fin (m + 1)) (j l : Fin (n + 1)) :
    chartEvaluation m n R i j (MvPolynomial.X (.inr l)) =
      1 ⊗ₜ[R] ProjectiveSpace.normalizedCoordinate n R j l := by
  simp [chartEvaluation]

/-- The regular function cut out by a Cox polynomial on a standard product chart. -/
def chartEquation (m n : ℕ) (R : Type u) [CommRing R]
    (i : Fin (m + 1)) (j : Fin (n + 1))
    (F : MvPolynomial (BiprojectiveCoordinate m n) R) : StandardChartRing m n R i j :=
  chartEvaluation m n R i j F
end BiprojectiveSpace

end

end Bidegree23Unirationality

@[expose] public section
open CategoryTheory Limits
open scoped AlgebraicGeometry
namespace Bidegree23Unirationality
noncomputable section
universe u
open AlgebraicGeometry
namespace BiprojectiveSpace

/-- Global functions on a standard product chart identify with its tensor-product chart ring. -/
def standardChartΓIso (m n : ℕ) (R : Type u) [CommRing R]
    (i : Fin (m + 1)) (j : Fin (n + 1)) :
    Γ(standardChart m n R i j, ⊤) ≅ .of (StandardChartRing m n R i j) :=
  (asIso (Scheme.Γ.map (standardChartIsoSpec m n R i j).hom.op)).symm ≪≫
    Scheme.ΓSpecIso (.of (StandardChartRing m n R i j))

/-- The chart equation, regarded as a global function on the corresponding chart scheme. -/
def chartEquationSection (m n : ℕ) (R : Type u) [CommRing R]
    (i : Fin (m + 1)) (j : Fin (n + 1))
    (F : MvPolynomial (BiprojectiveCoordinate m n) R) :
    Γ(standardChart m n R i j, ⊤) :=
  (standardChartΓIso m n R i j).inv (chartEquation m n R i j F)

/-- The principal ideal generated by the chart equation in the chart's global functions. -/
def chartIdealTop (m n : ℕ) (R : Type u) [CommRing R]
    (i : Fin (m + 1)) (j : Fin (n + 1))
    (F : MvPolynomial (BiprojectiveCoordinate m n) R) :
    Ideal Γ(standardChart m n R i j, ⊤) :=
  Ideal.span {chartEquationSection m n R i j F}

@[simp]
theorem chartEquationSection_mem_chartIdealTop (m n : ℕ)
    (R : Type u) [CommRing R] (i : Fin (m + 1)) (j : Fin (n + 1))
    (F : MvPolynomial (BiprojectiveCoordinate m n) R) :
    chartEquationSection m n R i j F ∈ chartIdealTop m n R i j F :=
  Ideal.subset_span (Set.mem_singleton _)

/-- The principal ideal sheaf cut out by `F` on one standard product chart. -/
def chartIdealSheaf (m n : ℕ) (R : Type u) [CommRing R]
    (i : Fin (m + 1)) (j : Fin (n + 1))
    (F : MvPolynomial (BiprojectiveCoordinate m n) R) :
    (standardChart m n R i j).IdealSheafData :=
  Scheme.IdealSheafData.ofIdealTop (chartIdealTop m n R i j F)

/-- The ideal sheaf obtained by extending the local chart equations to the ambient
biprojective space and taking their finite infimum.

This constructor is proof-independent: it does not require bihomogeneity of `F`.  Descent of
the local ideals to the expected chart ideals, and hence the local-to-global comparison with
the geometric zero locus of a bihomogeneous equation, is proved separately under that
hypothesis. -/
def biprojectiveZeroLocusIdeal (m n : ℕ) (R : Type u) [CommRing R]
    (F : MvPolynomial (BiprojectiveCoordinate m n) R) :
    (BiprojectiveSpace m n R).IdealSheafData :=
  ⨅ ij : Fin (m + 1) × Fin (n + 1),
    (chartIdealSheaf m n R ij.1 ij.2 F).map
      (standardChartι m n R ij.1 ij.2)

/-- The closed subscheme of biprojective space cut out by the chart equations of `F`. -/
abbrev biprojectiveZeroLocus (m n : ℕ) (R : Type u) [CommRing R]
    (F : MvPolynomial (BiprojectiveCoordinate m n) R) : Scheme :=
  (biprojectiveZeroLocusIdeal m n R F).subscheme

/-- The canonical closed immersion of a biprojective zero locus into its ambient space. -/
abbrev biprojectiveZeroLocusι (m n : ℕ) (R : Type u) [CommRing R]
    (F : MvPolynomial (BiprojectiveCoordinate m n) R) :
    biprojectiveZeroLocus m n R F ⟶ BiprojectiveSpace m n R :=
  (biprojectiveZeroLocusIdeal m n R F).subschemeι

/-- The structure morphism from a biprojective zero locus to the base affine scheme. -/
def biprojectiveZeroLocusToSpec (m n : ℕ) (R : Type u) [CommRing R]
    (F : MvPolynomial (BiprojectiveCoordinate m n) R) :
    biprojectiveZeroLocus m n R F ⟶ Spec (.of R) :=
  biprojectiveZeroLocusι m n R F ≫ toSpec m n R

end BiprojectiveSpace

end

end Bidegree23Unirationality

@[expose] public section
open CategoryTheory
open scoped AlgebraicGeometry
namespace Bidegree23Unirationality
noncomputable section
universe u
open AlgebraicGeometry BiprojectiveSpace
/-- The biprojective zero locus of a bidegree-`(2,3)` equation. -/
abbrev Bidegree23ZeroLocus (k : Type u) [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) : Scheme :=
  biprojectiveZeroLocus 2 2 k F

/-- Structure morphism of a bidegree-`(2,3)` zero locus to the base. -/
abbrev Bidegree23ZeroLocus.toSpec (k : Type u) [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) :
    Bidegree23ZeroLocus k F ⟶ Spec (.of k) :=
  biprojectiveZeroLocusToSpec 2 2 k F

/-- A dominant rational parametrization by relative affine space of fixed dimension. -/
def HasUnirationalParametrization {S X : Scheme.{u}} (n : ℕ) (sX : X ⟶ S) : Prop :=
  ∃ f : 𝔸(ULift.{u} (Fin n); S) ⤏ X,
    f.IsDominant ∧ f.compHom sX = (𝔸(ULift.{u} (Fin n); S) ↘ S).toRationalMap

/-- Every smooth bidegree-(2,3) hypersurface in P2 x P2 is unirational. -/
theorem smooth_bidegree23_hasUnirationalParametrization
    (k : Type u) [Field k] [IsAlgClosed k] [NeZero (2 : k)] [NeZero (3 : k)]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (Bidegree23ZeroLocus.toSpec k F)] :
    HasUnirationalParametrization 3 (Bidegree23ZeroLocus.toSpec k F) := by
  sorry

end
end Bidegree23Unirationality
