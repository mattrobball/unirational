/-
Copyright (c) 2026 V14Formalization contributors.
Released under Apache 2.0 license.
-/
import V14Formalization.ProjectiveFamilyFieldPoint
import V14Formalization.ProjectiveEigenvectorReduction

/-!
# Reverse field-point construction

Normalized coordinates that satisfy every homogeneous family equation lift
to a morphism into the projective family zero locus.  The eigenvector
converse reconstructs a sigma-fixed projective point from `M x = a • x`.
-/

noncomputable section

open CategoryTheory
open scoped AlgebraicGeometry

namespace V14Formalization
namespace SchemeGeometry

open AlgebraicGeometry BConicBundleMultisections
open MvPolynomial

universe u v

attribute [local instance] MvPolynomial.gradedAlgebra

theorem standardChartEvalAlgebra_comp_algebraMap
    {R S : Type u} [CommRing R] [CommRing S] [Algebra R S]
    (n : ℕ) (i : Fin (n + 1)) (x : Fin (n + 1) → S) :
    (ProjectiveSpace.standardChartEvalAlgebra (R := R) n i x).comp
        (algebraMap R (ProjectiveSpace.StandardChartRing n R i)) =
      algebraMap R S := by
  ext r
  simp [ProjectiveSpace.standardChartEvalAlgebra, MvPolynomial.algebraMap_eq,
    MvPolynomial.aeval_C]

theorem pointOfNormalizedCoordinatesAlgebra_toSpec
    {R S : Type u} [CommRing R] [CommRing S] [Algebra R S]
    (n : ℕ) (i : Fin (n + 1)) (x : Fin (n + 1) → S) :
    ProjectiveSpace.pointOfNormalizedCoordinatesAlgebra (R := R) n i x ≫
        ProjectiveSpace.toSpec n R =
      Spec.map (CommRingCat.ofHom (algebraMap R S)) := by
  unfold ProjectiveSpace.pointOfNormalizedCoordinatesAlgebra
  rw [Category.assoc, ProjectiveSpace.standardChartι_toSpec, ← Spec.map_comp]
  refine congrArg Spec.map ?_
  apply CommRingCat.hom_ext
  ext r
  exact DFunLike.congr_fun
    (standardChartEvalAlgebra_comp_algebraMap n i x) r

theorem hypersurfaceChartIdealSheaf_le_evalAlgebra_ker
    {R S : Type u} [CommRing R] [CommRing S] [Algebra R S]
    (n : ℕ) (i : Fin (n + 1)) (x : Fin (n + 1) → S) (hxi : x i = 1)
    {d : ℕ} (Q : MvPolynomial (Fin (n + 1)) R) (_hQ : Q.IsHomogeneous d)
    (hzero : aeval x Q = 0) :
    ProjectiveSpace.hypersurfaceChartIdealSheaf n R i Q ≤
      (Spec.map (CommRingCat.ofHom
        (ProjectiveSpace.standardChartEvalAlgebra (R := R) n i x))).ker := by
  let p : Spec (.of S) ⟶
      Spec (.of (ProjectiveSpace.StandardChartRing n R i)) :=
    Spec.map (CommRingCat.ofHom
      (ProjectiveSpace.standardChartEvalAlgebra (R := R) n i x))
  have hgen :
      ProjectiveSpace.standardChartEvalAlgebra (R := R) n i x
          (ProjectiveSpace.hypersurfaceChartEquation n R i Q) = 0 := by
    rw [standardChartEvalAlgebra_hypersurfaceChartEquation n i x hxi Q]
    exact hzero
  have hsection :
      p.appTop.hom (ProjectiveSpace.hypersurfaceChartEquationSection n R i Q) = 0 := by
    have hnat :=
      standardChartAlgebraPoint_appTop_hypersurfaceChartΓIso
        (R := R) (S := S) n i x
    have hcomp :
        ((p.appTop ≫ (Scheme.ΓSpecIso (.of S)).hom).hom)
          (ProjectiveSpace.hypersurfaceChartEquationSection n R i Q) = 0 := by
      rw [hnat]
      change ProjectiveSpace.standardChartEvalAlgebra (R := R) n i x
          ((ProjectiveSpace.hypersurfaceChartΓIso n R i).hom
            (ProjectiveSpace.hypersurfaceChartEquationSection n R i Q)) = 0
      rw [ProjectiveSpace.hypersurfaceChartΓIso_hom_equationSection]
      exact hgen
    have hcomp0 :
        (Scheme.ΓSpecIso (.of S)).hom.hom
          (p.appTop.hom
            (ProjectiveSpace.hypersurfaceChartEquationSection n R i Q)) = 0 :=
      hcomp
    have hinj : Function.Injective (Scheme.ΓSpecIso (.of S)).hom.hom :=
      (ConcreteCategory.bijective_of_isIso
        (C := CommRingCat) (Scheme.ΓSpecIso (.of S)).hom).1
    exact hinj (by simpa [map_zero] using hcomp0)
  have hspan :
      ProjectiveSpace.hypersurfaceChartIdealTop n R i Q ≤
        RingHom.ker p.appTop.hom :=
    Ideal.span_le.mpr (by
      intro z hz
      simp only [Set.mem_singleton_iff] at hz
      subst z
      exact RingHom.mem_ker.mpr hsection)
  haveI : IsAffine (Spec (.of (ProjectiveSpace.StandardChartRing n R i))) :=
    inferInstance
  haveI : QuasiCompact p := inferInstance
  refine Scheme.IdealSheafData.le_of_isAffine ?_
  have htop :
      p.ker.ideal ⟨⊤, isAffineOpen_top _⟩ = RingHom.ker p.appTop.hom :=
    Scheme.Hom.ker_apply p ⟨⊤, isAffineOpen_top _⟩
  rw [ProjectiveSpace.hypersurfaceChartIdealSheaf_ideal_top, htop]
  exact hspan

theorem projectiveZeroLocusIdeal_le_pointOfNormalizedCoordinatesAlgebra_ker
    {R S : Type u} [CommRing R] [CommRing S] [Algebra R S]
    (n : ℕ) (i : Fin (n + 1)) (x : Fin (n + 1) → S) (hxi : x i = 1)
    {d : ℕ} (Q : MvPolynomial (Fin (n + 1)) R) (hQ : Q.IsHomogeneous d)
    (hzero : aeval x Q = 0) :
    ProjectiveSpace.projectiveZeroLocusIdeal n R Q ≤
      (ProjectiveSpace.pointOfNormalizedCoordinatesAlgebra (R := R) n i x).ker := by
  have hchart :
      ProjectiveSpace.hypersurfaceChartIdealSheaf n R i Q ≤
        (Spec.map (CommRingCat.ofHom
          (ProjectiveSpace.standardChartEvalAlgebra (R := R) n i x))).ker :=
    hypersurfaceChartIdealSheaf_le_evalAlgebra_ker n i x hxi Q hQ hzero
  have hinf :
      ProjectiveSpace.projectiveZeroLocusIdeal n R Q ≤
        (ProjectiveSpace.hypersurfaceChartIdealSheaf n R i Q).map
          (ProjectiveSpace.standardChartι n R i) :=
    iInf_le _ i
  refine hinf.trans ?_
  unfold ProjectiveSpace.pointOfNormalizedCoordinatesAlgebra
  rw [Scheme.Hom.ker_comp]
  exact Scheme.IdealSheafData.map_mono _ hchart

theorem projectiveZeroLocusFamilyIdeal_le_pointOfNormalizedCoordinatesAlgebra_ker
    {k L : Type u} [Field k] [Field L] [Algebra k L]
    (n : ℕ) {ι : Type v}
    (F : ι → MvPolynomial (Fin (n + 1)) k)
    (d : ι → ℕ) (hF : ∀ s, (F s).IsHomogeneous (d s))
    (j : Fin (n + 1)) (x : Fin (n + 1) → L) (hxj : x j = 1)
    (hzero : ∀ s : ι,
      eval x (map (algebraMap k L) (F s)) = 0) :
    projectiveZeroLocusFamilyIdeal n k F ≤
      (ProjectiveSpace.pointOfNormalizedCoordinatesAlgebra (R := k) n j x).ker := by
  refine iSup_le ?_
  intro s
  have hae : aeval x (F s) = 0 := by
    rw [aeval_def, eval₂_eq_eval_map]
    exact hzero s
  exact projectiveZeroLocusIdeal_le_pointOfNormalizedCoordinatesAlgebra_ker
    n j x hxj (F s) (hF s) hae

/-- Normalized coordinates satisfying every family equation lift to the
scheme-theoretic family zero locus. -/
noncomputable def pointOfNormalizedCoordinates_lifts_projectiveZeroLocusFamily
    {k L : Type u} [Field k] [Field L] [Algebra k L]
    (n : ℕ) {ι : Type v}
    (F : ι → MvPolynomial (Fin (n + 1)) k)
    (d : ι → ℕ) (hF : ∀ s, (F s).IsHomogeneous (d s))
    (j : Fin (n + 1)) (x : Fin (n + 1) → L) (hxj : x j = 1)
    (hzero : ∀ s : ι,
      eval x (map (algebraMap k L) (F s)) = 0) :
    Spec (.of L) ⟶ projectiveZeroLocusFamily n k F :=
  IsClosedImmersion.lift
    (projectiveZeroLocusFamilyι n k F)
    (ProjectiveSpace.pointOfNormalizedCoordinatesAlgebra (R := k) n j x)
    (by
      rw [ker_projectiveZeroLocusFamilyι]
      exact projectiveZeroLocusFamilyIdeal_le_pointOfNormalizedCoordinatesAlgebra_ker
        n F d hF j x hxj hzero)

@[reassoc]
theorem pointOfNormalizedCoordinates_lifts_projectiveZeroLocusFamily_ι
    {k L : Type u} [Field k] [Field L] [Algebra k L]
    (n : ℕ) {ι : Type v}
    (F : ι → MvPolynomial (Fin (n + 1)) k)
    (d : ι → ℕ) (hF : ∀ s, (F s).IsHomogeneous (d s))
    (j : Fin (n + 1)) (x : Fin (n + 1) → L) (hxj : x j = 1)
    (hzero : ∀ s : ι,
      eval x (map (algebraMap k L) (F s)) = 0) :
    pointOfNormalizedCoordinates_lifts_projectiveZeroLocusFamily
        n F d hF j x hxj hzero ≫
      projectiveZeroLocusFamilyι n k F =
      ProjectiveSpace.pointOfNormalizedCoordinatesAlgebra (R := k) n j x :=
  IsClosedImmersion.lift_fac _ _ _

theorem pointOfNormalizedCoordinates_lifts_projectiveZeroLocusFamily_toSpec
    {k L : Type u} [Field k] [Field L] [Algebra k L]
    (n : ℕ) {ι : Type v}
    (F : ι → MvPolynomial (Fin (n + 1)) k)
    (d : ι → ℕ) (hF : ∀ s, (F s).IsHomogeneous (d s))
    (j : Fin (n + 1)) (x : Fin (n + 1) → L) (hxj : x j = 1)
    (hzero : ∀ s : ι,
      eval x (map (algebraMap k L) (F s)) = 0) :
    pointOfNormalizedCoordinates_lifts_projectiveZeroLocusFamily
        n F d hF j x hxj hzero ≫
      projectiveZeroLocusFamilyToSpec n k F =
      Spec.map (CommRingCat.ofHom (algebraMap k L)) := by
  rw [projectiveZeroLocusFamilyToSpec, ← Category.assoc,
    pointOfNormalizedCoordinates_lifts_projectiveZeroLocusFamily_ι]
  exact pointOfNormalizedCoordinatesAlgebra_toSpec n j x

/-- If `M x = a • x` with `a ≠ 0`, the normalized projective point is fixed by
the associated linear substitution. -/
theorem pointOfNormalizedCoordinates_fixed_of_mulVec_eq_smul
    {k L : Type u} [Field k] [Field L] [Algebra k L]
    (n : ℕ)
    (M N : Matrix (Fin (n + 1)) (Fin (n + 1)) k) (hNM : N * M = 1)
    (j : Fin (n + 1)) (x : Fin (n + 1) → L) (hxj : x j = 1)
    (a : L) (ha : a ≠ 0)
    (heig : (M.map (algebraMap k L)).mulVec x = a • x) :
    ProjectiveSpace.pointOfNormalizedCoordinatesAlgebra (R := k) n j x ≫
        mapLinearSubst n M N hNM =
      ProjectiveSpace.pointOfNormalizedCoordinatesAlgebra (R := k) n j x := by
  have hyj : ((M.map (algebraMap k L)).mulVec x) j ≠ 0 := by
    simp [heig, Pi.smul_apply, ha, hxj]
  have hcomp := pointOfNormalizedCoordinatesAlgebra_comp_mapLinearSubst
    n M N hNM j x hxj hyj
  refine hcomp.trans ?_
  apply congrArg
  funext l
  simp [heig, Pi.smul_apply, hxj, ha, mul_div_cancel_left₀]

end SchemeGeometry
end V14Formalization
