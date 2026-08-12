/-
Copyright (c) 2026 V14Formalization contributors.
Released under Apache 2.0 license.
-/
import V14Formalization.ProjectiveFamilyNaturality
import V14Formalization.V14FieldPointReconstruction

/-!
# Equations satisfied by field-valued projective zero-locus points

This file connects Problem B's imported projective chart API to the normalized
coordinates used by the V14 fixed-point argument.  A field-valued point of a
projective family zero locus satisfies every base-changed homogeneous equation
in any normalized coordinates that reconstruct its ambient projective point.
-/

noncomputable section

open CategoryTheory
open scoped AlgebraicGeometry

namespace V14Formalization
namespace SchemeGeometry

open AlgebraicGeometry BConicBundleMultisections
open MvPolynomial

attribute [local instance] MvPolynomial.gradedAlgebra

universe u v

@[reassoc]
theorem standardChartAlgebraPoint_appTop_hypersurfaceChartΓIso
    {R S : Type u} [CommRing R] [CommRing S] [Algebra R S]
    (n : ℕ) (i : Fin (n + 1)) (x : Fin (n + 1) → S) :
    (Spec.map (CommRingCat.ofHom
        (ProjectiveSpace.standardChartEvalAlgebra (R := R) n i x))).appTop ≫
        (Scheme.ΓSpecIso (.of S)).hom =
      (ProjectiveSpace.hypersurfaceChartΓIso n R i).hom ≫
        CommRingCat.ofHom
          (ProjectiveSpace.standardChartEvalAlgebra (R := R) n i x) := by
  exact Scheme.ΓSpecIso_naturality
    (CommRingCat.ofHom
      (ProjectiveSpace.standardChartEvalAlgebra (R := R) n i x))

theorem standardChartEvalAlgebra_hypersurfaceChartEquation
    {R S : Type u} [CommRing R] [CommRing S] [Algebra R S]
    (n : ℕ) (i : Fin (n + 1)) (x : Fin (n + 1) → S)
    (hxi : x i = 1) (Q : MvPolynomial (Fin (n + 1)) R) :
    ProjectiveSpace.standardChartEvalAlgebra (R := R) n i x
        (ProjectiveSpace.hypersurfaceChartEquation n R i Q) =
      MvPolynomial.aeval x Q := by
  rw [ProjectiveSpace.hypersurfaceChartEquation,
    MvPolynomial.aeval_def, MvPolynomial.hom_eval₂]
  change MvPolynomial.eval₂
      ((ProjectiveSpace.standardChartEvalAlgebra (R := R) n i x).comp
        (algebraMap R (ProjectiveSpace.StandardChartRing n R i)))
      (fun l ↦ ProjectiveSpace.standardChartEvalAlgebra (R := R) n i x
        (ProjectiveSpace.normalizedCoordinate n R i l)) Q =
    MvPolynomial.eval₂ (algebraMap R S) x Q
  rw [show
    (ProjectiveSpace.standardChartEvalAlgebra (R := R) n i x).comp
        (algebraMap R (ProjectiveSpace.StandardChartRing n R i)) =
      algebraMap R S by
        ext r
        simp [ProjectiveSpace.standardChartEvalAlgebra]]
  apply MvPolynomial.eval₂_congr
  intro l c hl hc
  exact standardChartEvalAlgebra_normalizedCoordinate
    n i x hxi l

/-- If the projective hypersurface ideal is contained in the kernel of an
algebra-valued normalized projective point, its equation vanishes there. -/
theorem aeval_eq_zero_of_projectiveZeroLocusIdeal_le_normalizedPoint_ker
    {R S : Type u} [CommRing R] [CommRing S] [Algebra R S]
    (n : ℕ) (i : Fin (n + 1)) (x : Fin (n + 1) → S)
    (hxi : x i = 1) {d : ℕ}
    (Q : MvPolynomial (Fin (n + 1)) R) (hQ : Q.IsHomogeneous d)
    (hle : ProjectiveSpace.projectiveZeroLocusIdeal n R Q ≤
      (ProjectiveSpace.pointOfNormalizedCoordinatesAlgebra
        (R := R) n i x).ker) :
    MvPolynomial.aeval x Q = 0 := by
  let p : Spec (.of S) ⟶
      Spec (.of (ProjectiveSpace.StandardChartRing n R i)) :=
    Spec.map (CommRingCat.ofHom
      (ProjectiveSpace.standardChartEvalAlgebra (R := R) n i x))
  have hle' : ProjectiveSpace.projectiveZeroLocusIdeal n R Q ≤
      p.ker.map (ProjectiveSpace.standardChartι n R i) := by
    simpa only [ProjectiveSpace.pointOfNormalizedCoordinatesAlgebra,
      Scheme.Hom.ker_comp] using hle
  have hlocal : ProjectiveSpace.hypersurfaceChartIdealSheaf n R i Q ≤
      p.ker := by
    have h := Scheme.IdealSheafData.le_map_iff_comap_le.mp hle'
    rwa [ProjectiveSpace.projectiveZeroLocusIdeal_comap_standardChartι
      n R Q hQ] at h
  let U : (Spec (.of (ProjectiveSpace.StandardChartRing n R i))).affineOpens :=
    ⟨⊤, isAffineOpen_top _⟩
  have hsection :
      ProjectiveSpace.hypersurfaceChartEquationSection n R i Q ∈
        p.ker.ideal U := by
    apply hlocal
    rw [ProjectiveSpace.hypersurfaceChartIdealSheaf_ideal_top]
    exact Ideal.subset_span (Set.mem_singleton _)
  have hsection0 : p.appTop.hom
      (ProjectiveSpace.hypersurfaceChartEquationSection n R i Q) = 0 := by
    apply RingHom.mem_ker.mp
    exact p.ideal_ker_le U hsection
  have hsectionS :
      ((p.appTop ≫ (Scheme.ΓSpecIso (.of S)).hom).hom)
        (ProjectiveSpace.hypersurfaceChartEquationSection n R i Q) = 0 := by
    simp only [CommRingCat.hom_comp, RingHom.coe_comp, Function.comp_apply,
      hsection0, map_zero]
  rw [standardChartAlgebraPoint_appTop_hypersurfaceChartΓIso] at hsectionS
  change ProjectiveSpace.standardChartEvalAlgebra (R := R) n i x
      ((ProjectiveSpace.hypersurfaceChartΓIso n R i).hom
        (ProjectiveSpace.hypersurfaceChartEquationSection n R i Q)) = 0 at hsectionS
  rw [ProjectiveSpace.hypersurfaceChartΓIso_hom_equationSection] at hsectionS
  rwa [standardChartEvalAlgebra_hypersurfaceChartEquation
    n i x hxi Q] at hsectionS

/-- A field-valued point of a projective family zero locus satisfies every
base-changed family equation in any normalized coordinates reconstructing its
ambient projective point. -/
theorem eval_map_eq_zero_of_projectiveZeroLocusFamily_point
    {k L : Type u} [Field k] [Field L] [Algebra k L]
    (n : ℕ) {ι : Type v}
    (F : ι → MvPolynomial (Fin (n + 1)) k)
    (d : ι → ℕ) (hF : ∀ s, (F s).IsHomogeneous (d s))
    (z : Spec (.of L) ⟶ projectiveZeroLocusFamily n k F)
    (_hzbase : z ≫ projectiveZeroLocusFamilyToSpec n k F =
      Spec.map (CommRingCat.ofHom (algebraMap k L)))
    (j : Fin (n + 1)) (x : Fin (n + 1) → L) (hxj : x j = 1)
    (hzcoord : z ≫ projectiveZeroLocusFamilyι n k F =
      ProjectiveSpace.pointOfNormalizedCoordinatesAlgebra
        (R := k) n j x) :
    ∀ s : ι,
      MvPolynomial.eval x
        (MvPolynomial.map (algebraMap k L) (F s)) = 0 := by
  intro s
  have hfamilyker : projectiveZeroLocusFamilyIdeal n k F ≤
      (z ≫ projectiveZeroLocusFamilyι n k F).ker := by
    rw [← ker_projectiveZeroLocusFamilyι]
    exact Scheme.Hom.le_ker_comp z (projectiveZeroLocusFamilyι n k F)
  have hsingle : ProjectiveSpace.projectiveZeroLocusIdeal n k (F s) ≤
      (ProjectiveSpace.pointOfNormalizedCoordinatesAlgebra
        (R := k) n j x).ker := by
    rw [← hzcoord]
    exact (le_iSup (fun t ↦
      ProjectiveSpace.projectiveZeroLocusIdeal n k (F t)) s).trans hfamilyker
  have hae : MvPolynomial.aeval x (F s) = 0 :=
    aeval_eq_zero_of_projectiveZeroLocusIdeal_le_normalizedPoint_ker
      n j x hxj (F s) (hF s) hsingle
  rw [MvPolynomial.aeval_def, MvPolynomial.eval₂_eq_eval_map] at hae
  exact hae

end SchemeGeometry
end V14Formalization
