/-
Copyright (c) 2026 V14Formalization contributors.
Released under Apache 2.0 license.
-/
module

public import V14Formalization.V14FieldPointReconstruction
public import V14Formalization.ProjectiveDiagonalAction

/-!
# Fixed field-valued projective points for a diagonal sign action

This is deliberately point-level.  It translates equality of a `Spec L` point
under a diagonal projective scheme automorphism into support in one of the two
sign blocks.  No scheme-theoretic fixed-locus decomposition is asserted.
-/

noncomputable section

open CategoryTheory
open scoped AlgebraicGeometry

namespace V14Formalization.SchemeGeometry

universe u

open AlgebraicGeometry BConicBundleMultisections

attribute [local instance] MvPolynomial.gradedAlgebra

variable {k L : Type u} [Field k] [Field L] [Algebra k L]

private theorem mapLinearSubst_congr_matrices
    (n : ℕ)
    {M M' N N' : Matrix (Fin (n + 1)) (Fin (n + 1)) k}
    (hNM : N * M = 1) (hN'M' : N' * M' = 1)
    (hM : M = M') (hN : N = N') :
    mapLinearSubst n M N hNM = mapLinearSubst n M' N' hN'M' := by
  subst M'
  subst N'
  rfl

/-- The projective automorphism induced by an invertible diagonal matrix. -/
@[expose] public def diagonalProjectiveHom (n : ℕ) (d : Fin (n + 1) → k)
    (hd : ∀ i, d i ≠ 0) :
    ProjectiveSpace n k ⟶ ProjectiveSpace n k :=
  mapLinearSubst n (Matrix.diagonal d)
    (Matrix.diagonal fun j ↦ (d j)⁻¹) (by
      rw [Matrix.diagonal_mul_diagonal]
      simp [hd])

/-- On a normalized chart, a fixed point for a diagonal sign action has no
coordinate in the sign block opposite to the distinguished coordinate.

The conclusion is stated directly as normalized-coordinate support.  This is
the exact point-level replacement for a global equalizer decomposition.
-/
public theorem exists_normalizedCoordinates_support_of_diagonal_sign_fixed
    [NeZero (2 : k)]
    (n : ℕ) (d : Fin (n + 1) → k)
    (hsign : ∀ l, d l = 1 ∨ d l = -1)
    (p : Spec (.of L) ⟶ ProjectiveSpace n k)
    (hpbase : p ≫ ProjectiveSpace.toSpec n k =
      Spec.map (CommRingCat.ofHom (algebraMap k L)))
    (hfixed : p ≫ diagonalProjectiveHom n d (fun i ↦ by
      rcases hsign i with hi | hi <;> simp [hi]) = p) :
    ∃ (j : Fin (n + 1)) (x : Fin (n + 1) → L),
      x j = 1 ∧
      p = ProjectiveSpace.pointOfNormalizedCoordinatesAlgebra (R := k) n j x ∧
      ((d j = 1 ∧ ∀ l, d l = -1 → x l = 0) ∨
        (d j = -1 ∧ ∀ l, d l = 1 → x l = 0)) := by
  classical
  let hd : ∀ i, d i ≠ 0 := fun i ↦ by
    rcases hsign i with hi | hi <;> simp [hi]
  obtain ⟨j, x, hxj, hp⟩ :=
    exists_normalizedResidueCoordinates_for_fieldPoint n p hpbase
  refine ⟨j, x, hxj, hp, ?_⟩
  have hfixed' :
      ProjectiveSpace.pointOfNormalizedCoordinatesAlgebra (R := k) n j x ≫
          diagonalProjectiveHom n d hd =
        ProjectiveSpace.pointOfNormalizedCoordinatesAlgebra (R := k) n j x := by
    simpa only [hp] using hfixed
  let e := ProjectiveSpace.standardChartEvalAlgebra (R := k) n j x
  let c := diagonalChartHom n d j (hd j)
  have hchart :
      Spec.map (CommRingCat.ofHom e) ≫ Spec.map (CommRingCat.ofHom c) =
        Spec.map (CommRingCat.ofHom e) := by
    apply (cancel_mono (ProjectiveSpace.standardChartι n k j)).mp
    unfold ProjectiveSpace.pointOfNormalizedCoordinatesAlgebra at hfixed'
    unfold diagonalProjectiveHom at hfixed'
    rw [Category.assoc,
      standardChartι_comp_mapLinearSubst_diagonal n d hd j] at hfixed'
    simpa only [Category.assoc, e, c] using hfixed'
  have hring : e.comp c = e := by
    have hpre := congrArg Spec.preimage hchart
    have hcat :
        CommRingCat.ofHom c ≫ CommRingCat.ofHom e = CommRingCat.ofHom e := by
      simpa only [Spec.preimage_comp, Spec.preimage_map] using hpre
    change e.comp c = e
    exact congrArg CommRingCat.Hom.hom hcat
  have hopposite (l : Fin (n + 1)) (hli : d l = -d j) : x l = 0 := by
    have hcoord := congrArg
      (fun q : ProjectiveSpace.StandardChartRing n k j →+* L ↦
        q (ProjectiveSpace.normalizedCoordinate n k j l)) hring
    rw [RingHom.comp_apply,
      diagonalChartHom_normalizedCoordinate_eq_neg_of_eq_neg n d j (hd j) l hli,
      map_neg,
      standardChartEvalAlgebra_normalizedCoordinate n j x hxj l] at hcoord
    have hadd : x l + x l = 0 := neg_eq_iff_add_eq_zero.mp hcoord
    have hmul : (2 : L) * x l = 0 := by simpa [two_mul] using hadd
    have htwoK : (2 : k) ≠ 0 := NeZero.ne _
    have htwoL : (2 : L) ≠ 0 := by
      intro hzero
      apply htwoK
      exact (FaithfulSMul.algebraMap_injective k L) (by
        change algebraMap k L (2 : k) = algebraMap k L (0 : k)
        simpa only [map_ofNat, map_zero] using hzero)
    exact (mul_eq_zero.mp hmul).resolve_left htwoL
  rcases hsign j with hj | hj
  · left
    refine ⟨hj, fun l hl ↦ hopposite l ?_⟩
    rw [hj]
    exact hl
  · right
    refine ⟨hj, fun l hl ↦ hopposite l ?_⟩
    rw [hj, hl]
    ring

/-- Wrapper phrased with the actual `projectiveActionHom` API.  The only
representation-specific input is the equality saying that the chosen group
element acts by the indicated diagonal sign matrix. -/
public theorem exists_normalizedCoordinates_support_of_projectiveActionHom_fixed
    {G : Type u} [Group G] [NeZero (2 : k)]
    (n : ℕ) (R : MatrixRepresentation (k := k) (G := G) n) (sigma : G)
    (d : Fin (n + 1) → k)
    (hsign : ∀ l, d l = 1 ∨ d l = -1)
    (hdiag : (↑(R sigma) : Matrix _ _ k) = Matrix.diagonal d)
    (p : Spec (.of L) ⟶ ProjectiveSpace n k)
    (hpbase : p ≫ ProjectiveSpace.toSpec n k =
      Spec.map (CommRingCat.ofHom (algebraMap k L)))
    (hfixed : p ≫ projectiveActionHom R sigma = p) :
    ∃ (j : Fin (n + 1)) (x : Fin (n + 1) → L),
      x j = 1 ∧
      p = ProjectiveSpace.pointOfNormalizedCoordinatesAlgebra (R := k) n j x ∧
      ((d j = 1 ∧ ∀ l, d l = -1 → x l = 0) ∨
        (d j = -1 ∧ ∀ l, d l = 1 → x l = 0)) := by
  classical
  let hd : ∀ i, d i ≠ 0 := fun i ↦ by
    rcases hsign i with hi | hi <;> simp [hi]
  have hdiagInv :
      (↑((R sigma)⁻¹) : Matrix _ _ k) =
        Matrix.diagonal (fun j ↦ (d j)⁻¹) := by
    have hright :
        Matrix.diagonal d * Matrix.diagonal (fun j ↦ (d j)⁻¹) = 1 := by
      rw [Matrix.diagonal_mul_diagonal]
      simp [hd]
    calc
      (↑((R sigma)⁻¹) : Matrix _ _ k) =
          (↑((R sigma)⁻¹) : Matrix _ _ k) * 1 := (mul_one _).symm
      _ = (↑((R sigma)⁻¹) : Matrix _ _ k) *
          (Matrix.diagonal d * Matrix.diagonal (fun j ↦ (d j)⁻¹)) := by
            rw [hright]
      _ = ((↑((R sigma)⁻¹) : Matrix _ _ k) * Matrix.diagonal d) *
          Matrix.diagonal (fun j ↦ (d j)⁻¹) := by rw [Matrix.mul_assoc]
      _ = 1 * Matrix.diagonal (fun j ↦ (d j)⁻¹) := by rw [← hdiag]; simp
      _ = Matrix.diagonal (fun j ↦ (d j)⁻¹) := one_mul _
  have hhom : projectiveActionHom R sigma = diagonalProjectiveHom n d hd := by
    unfold projectiveActionHom diagonalProjectiveHom
    exact mapLinearSubst_congr_matrices n _ _ hdiag hdiagInv
  apply exists_normalizedCoordinates_support_of_diagonal_sign_fixed n d hsign p hpbase
  simpa only [hhom] using hfixed

end V14Formalization.SchemeGeometry

