/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import BConicBundleMultisections.BiprojectiveAffineJacobian
public import BConicBundleMultisections.BiprojectiveFiberPolynomial
public import BConicBundleMultisections.BiprojectiveNoWholeFiber
public import BConicBundleMultisections.MvPolynomialHomogeneousEvaluation
public import BConicBundleMultisections.ProjectiveCommonZero
public import BConicBundleMultisections.ResidualImageRationalParam
public import Mathlib.Algebra.MvPolynomial.Funext
public import Mathlib.Data.Finsupp.Weight
public import Mathlib.Algebra.MvPolynomial.Division
public import Mathlib.LinearAlgebra.CrossProduct
public import Mathlib.LinearAlgebra.FiniteDimensional.Lemmas
public import Mathlib.LinearAlgebra.LinearIndependent.Lemmas
public import Mathlib.RingTheory.MvPolynomial.Homogeneous
public import Mathlib.RingTheory.MvPolynomial.Ideal

/-!
# Free-direction nonvanishing for smooth `(2,3)` hypersurfaces

If the free-direction form `Q(1,s,0)` vanished along the coordinate line, the specialized conic
would vanish on `X₂ = 0`.  Homogenizing in the second block forces `F` to vanish on the surface
`X₂ = Y₂ = 0`, so `F ∈ (X₂, Y₂)`.  The resulting hypersurface is singular, contradicting global
smoothness.
-/

@[expose] public section

open CategoryTheory
open scoped AlgebraicGeometry

namespace BConicBundleMultisections

noncomputable section

universe u

open AlgebraicGeometry MvPolynomial BiprojectiveSpace
open _root_.MvPolynomial

/-! ### Numerical free-block vanishing -/

theorem eval_freeDir_coeffs_eq_zero_of_freeDirForm_eq_zero
    {k : Type u} [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (hα : specializedConicFreeDirForm F = 0) (t : k) :
    ternaryQuadraticCoeff (coordinateLineSpecializedConic F t) 0 0 = 0 ∧
      ternaryQuadraticCoeff (coordinateLineSpecializedConic F t) 0 1 = 0 ∧
        ternaryQuadraticCoeff (coordinateLineSpecializedConic F t) 1 1 = 0 := by
  obtain ⟨h00, h01, h11⟩ := freeDir_coeffs_eq_zero_of_freeDirForm_eq_zero F hF hα
  have hmap := map_eval_coordinateLineSpecializedConicPoly F t
  have hcoeff (i j : Fin 3) :
      ternaryQuadraticCoeff (coordinateLineSpecializedConic F t) i j =
        Polynomial.eval t
          (ternaryQuadraticCoeff (coordinateLineSpecializedConicPoly F) i j) := by
    have := congr_arg (fun f => ternaryQuadraticCoeff f i j) hmap
    simpa [ternaryQuadraticCoeff_map] using this.symm
  refine ⟨?_, ?_, ?_⟩
  · simp [hcoeff, h00]
  · simp [hcoeff, h01]
  · simp [hcoeff, h11]

theorem eval_coordinateLineSpecializedConic_of_freeDirForm_eq_zero
    {k : Type u} [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (hα : specializedConicFreeDirForm F = 0)
    (t x0 x1 : k) :
    eval (![x0, x1, (0 : k)]) (coordinateLineSpecializedConic F t) = 0 := by
  have hf := coordinateLineSpecializedConic_isHomogeneous hF t
  have hsum := eval_eq_ternaryQuadraticCoeff_sum hf (![x0, x1, (0 : k)])
  obtain ⟨z00, z01, z11⟩ := eval_freeDir_coeffs_eq_zero_of_freeDirForm_eq_zero F hF hα t
  have h10 : ternaryQuadraticCoeff (coordinateLineSpecializedConic F t) 1 0 = 0 := by
    simp [ternaryQuadraticCoeff, show ¬ (1 : Fin 3) < 0 by decide]
  have h20 : ternaryQuadraticCoeff (coordinateLineSpecializedConic F t) 2 0 = 0 := by
    simp [ternaryQuadraticCoeff, show ¬ (2 : Fin 3) < 0 by decide]
  have h21 : ternaryQuadraticCoeff (coordinateLineSpecializedConic F t) 2 1 = 0 := by
    simp [ternaryQuadraticCoeff, show ¬ (2 : Fin 3) < 1 by decide]
  rw [hsum]
  simp only [Fin.sum_univ_three, Matrix.cons_val_zero, Matrix.cons_val_one, Matrix.head_cons,
    Matrix.cons_val_two, Matrix.tail_cons, z00, z01, z11, h10, h20, h21, mul_zero, zero_mul,
    add_zero, zero_add]

theorem eval_F_coordinateLine_of_freeDirForm_eq_zero
    {k : Type u} [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (hα : specializedConicFreeDirForm F = 0)
    (t x0 x1 : k) :
    eval (Sum.elim (![x0, x1, (0 : k)]) (coordinateLinePoint k t)) F = 0 := by
  have h := eval_coordinateLineSpecializedConic_of_freeDirForm_eq_zero F hF hα t x0 x1
  simpa [coordinateLineSpecializedConic, eval_specializeSecondCoordinates] using h

/-! ### Binary restriction at `X₂ = 0` -/

/-- Binary form `(Y₀,Y₁) ↦ F(x₀,x₁,0,Y₀,Y₁,0)`. -/
def binaryY_of_X2_zero
    {k : Type u} [CommRing k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (x0 x1 : k) : MvPolynomial (Fin 2) k :=
  aeval (![X (0 : Fin 2), X 1, (0 : MvPolynomial (Fin 2) k)])
    (specializeFirstCoordinates (n := 2) (![x0, x1, (0 : k)]) F)

theorem eval_binaryY_of_X2_zero
    {k : Type u} [CommRing k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (x0 x1 y0 y1 : k) :
    eval (![y0, y1]) (binaryY_of_X2_zero F x0 x1) =
      eval (Sum.elim (![x0, x1, (0 : k)]) (![y0, y1, (0 : k)])) F := by
  simp only [binaryY_of_X2_zero, aeval_def]
  rw [eval_eval₂]
  have hg : (fun i : Fin 3 =>
      eval (![y0, y1]) (![X (0 : Fin 2), X 1, (0 : MvPolynomial (Fin 2) k)] i)) =
      ![y0, y1, 0] := by
    funext i; fin_cases i <;> simp [eval_X]
  have hf : (eval (![y0, y1])).comp (algebraMap k (MvPolynomial (Fin 2) k)) =
      RingHom.id k := by
    ext a; simp [eval_C, algebraMap_eq]
  simp only [hg, hf, eval₂_id]
  exact eval_specializeFirstCoordinates (n := 2)
    (![x0, x1, (0 : k)]) (![y0, y1, (0 : k)]) F

theorem binaryY_of_X2_zero_isHomogeneous
    {k : Type u} [CommRing k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (x0 x1 : k) :
    (binaryY_of_X2_zero F x0 x1).IsHomogeneous 3 := by
  have hspec :
      (specializeFirstCoordinates (n := 2) (![x0, x1, (0 : k)]) F).IsHomogeneous 3 :=
    hF.specializeFirstCoordinates_isHomogeneous _
  have h := IsHomogeneous.aeval (S := k) (τ := Fin 2) (m := 3) (n := 1) hspec
    (![X (0 : Fin 2), X 1, (0 : MvPolynomial (Fin 2) k)])
    (by
      intro i
      fin_cases i
      · exact isHomogeneous_X (R := k) (σ := Fin 2) 0
      · exact isHomogeneous_X (R := k) (σ := Fin 2) 1
      · exact isHomogeneous_zero (R := k) (σ := Fin 2) 1)
  simpa [binaryY_of_X2_zero, one_mul] using h

/-! ### Binary homogeneous forms via dehomogenization -/

/-- Dehomogenization `G(Y₀,Y₁) ↦ G(1,T)`. -/
def dehomogBinary {R : Type u} [CommRing R]
    (G : MvPolynomial (Fin 2) R) : Polynomial R :=
  eval₂ Polynomial.C ![1, Polynomial.X] G

theorem eval_dehomogBinary {R : Type u} [CommRing R]
    (G : MvPolynomial (Fin 2) R) (t : R) :
    Polynomial.eval t (dehomogBinary G) = eval (![1, t]) G := by
  simp only [dehomogBinary]
  induction G using MvPolynomial.induction_on with
  | C a => simp [eval₂_C, Polynomial.eval_C, eval_C]
  | add p q hp hq => simp [eval₂_add, hp, hq, eval_add]
  | mul_X p i hp =>
      fin_cases i
      · simp [eval₂_mul, eval₂_X, hp, eval_mul, eval_X]
      · simp [eval₂_mul, eval₂_X, hp, eval_mul, eval_X, Polynomial.eval_X]

private theorem dehomogBinary_monomial {R : Type u} [CommRing R]
    (a b : ℕ) (c : R) :
    dehomogBinary (monomial (Finsupp.single (0 : Fin 2) a + Finsupp.single 1 b) c) =
      Polynomial.monomial b c := by
  simp only [dehomogBinary, eval₂_monomial]
  rw [Finsupp.prod_add_index' (fun _ => pow_zero _) (fun _ _ _ => pow_add _ _ _)]
  have h0 : (Finsupp.single (0 : Fin 2) a).prod
      (fun j e => (![1, Polynomial.X] : Fin 2 → Polynomial R) j ^ e) = (1 : Polynomial R) := by
    rw [Finsupp.prod_single_index (by simp)]
    simp [Matrix.cons_val_zero, one_pow]
  have h1 : (Finsupp.single (1 : Fin 2) b).prod
      (fun j e => (![1, Polynomial.X] : Fin 2 → Polynomial R) j ^ e) = Polynomial.X ^ b := by
    rw [Finsupp.prod_single_index (by simp)]
    simp [Matrix.cons_val_one]
  rw [h0, h1, one_mul, Polynomial.C_mul_X_pow_eq_monomial]

/-- Standard monom `Y₀^{d-i} Y₁^i` of degree `d`. -/
def binaryMonom (d i : ℕ) : Fin 2 →₀ ℕ :=
  Finsupp.single (0 : Fin 2) (d - i) + Finsupp.single 1 i

/-- For `m : Fin 2 →₀ ℕ`, the weight-1 sum equals `m 0 + m 1`. -/
private theorem weight_one_eq_add (m : Fin 2 →₀ ℕ) :
    (Finsupp.weight (1 : Fin 2 → ℕ)) m = m 0 + m 1 := by
  simp only [Finsupp.weight_apply, Finsupp.sum, Pi.one_apply, smul_eq_mul, mul_one]
  classical
  have hs : m.support ⊆ ({0, 1} : Finset (Fin 2)) := by
    intro j _
    fin_cases j <;> simp
  -- sum_subset : s₁ ⊆ s₂ → (vanish on s₂ \ s₁) → ∑ s₁ = ∑ s₂
  have h1 : ∑ i ∈ m.support, m i = ∑ i ∈ ({0, 1} : Finset (Fin 2)), m i :=
    Finset.sum_subset hs fun j _ hj => by
      have : m j = 0 := Finsupp.notMem_support_iff.mp hj
      simp [this]
  have h2 : ∑ i ∈ ({0, 1} : Finset (Fin 2)), m i = m 0 + m 1 :=
    Finset.sum_pair (by decide : (0 : Fin 2) ≠ 1)
  exact h1.trans h2

/-- A homogeneous binary form of degree `d` is the sum of its standard monoms. -/
theorem isHomogeneous_binary_eq_sum {R : Type u} [CommRing R]
    (G : MvPolynomial (Fin 2) R) {d : ℕ} (hG : G.IsHomogeneous d) :
    G = ∑ i ∈ Finset.range (d + 1),
      monomial (binaryMonom d i) (G.coeff (binaryMonom d i)) := by
  classical
  have hsub : G.support ⊆ Finset.image (binaryMonom d) (Finset.range (d + 1)) := by
    intro m hm
    have hmd : (Finsupp.weight (1 : Fin 2 → ℕ)) m = d :=
      hG (mem_support_iff.mp hm)
    have hsum : m 0 + m 1 = d := (weight_one_eq_add m).symm.trans hmd
    refine Finset.mem_image.mpr ⟨m 1, Finset.mem_range.mpr (by omega), ?_⟩
    ext j
    fin_cases j <;> simp [binaryMonom, Finsupp.single_apply, Finsupp.add_apply]; omega
  have hinj : Set.InjOn (binaryMonom d) (Finset.range (d + 1)) := by
    intro i _ j _ hij
    have : (binaryMonom d i) 1 = (binaryMonom d j) 1 :=
      congr_arg (fun m : Fin 2 →₀ ℕ => m 1) hij
    simpa [binaryMonom, Finsupp.single_apply, Finsupp.add_apply] using this
  calc
    G = ∑ m ∈ G.support, monomial m (G.coeff m) := MvPolynomial.as_sum G
    _ = ∑ m ∈ Finset.image (binaryMonom d) (Finset.range (d + 1)),
          monomial m (G.coeff m) := by
      refine Finset.sum_subset hsub fun m _ hm => ?_
      have : G.coeff m = 0 := by simpa [mem_support_iff] using hm
      simp [this]
    _ = ∑ i ∈ Finset.range (d + 1),
          monomial (binaryMonom d i) (G.coeff (binaryMonom d i)) :=
      Finset.sum_image hinj

theorem dehomogBinary_of_isHomogeneous {R : Type u} [CommRing R]
    (G : MvPolynomial (Fin 2) R) {d : ℕ} (hG : G.IsHomogeneous d) :
    dehomogBinary G =
      ∑ i ∈ Finset.range (d + 1),
        Polynomial.monomial i (G.coeff (binaryMonom d i)) := by
  have h1 := congrArg dehomogBinary (isHomogeneous_binary_eq_sum G hG)
  rw [h1]
  have h2 :
      dehomogBinary (∑ i ∈ Finset.range (d + 1),
          monomial (binaryMonom d i) (G.coeff (binaryMonom d i))) =
        ∑ i ∈ Finset.range (d + 1),
          dehomogBinary (monomial (binaryMonom d i) (G.coeff (binaryMonom d i))) := by
    change (eval₂Hom (Polynomial.C : R →+* Polynomial R) ![1, Polynomial.X]) _ = _
    exact map_sum _ _ _
  rw [h2]
  refine Finset.sum_congr rfl fun i _ => ?_
  simpa [binaryMonom] using dehomogBinary_monomial (d - i) i (G.coeff _)

theorem dehomogBinary_eq_zero_iff_of_isHomogeneous
    {R : Type u} [CommRing R]
    (G : MvPolynomial (Fin 2) R) {d : ℕ} (hG : G.IsHomogeneous d) :
    dehomogBinary G = 0 ↔ G = 0 := by
  constructor
  · intro h
    rw [isHomogeneous_binary_eq_sum G hG]
    refine Finset.sum_eq_zero fun i hi => ?_
    have hcoeff : G.coeff (binaryMonom d i) = 0 := by
      have h0 : (dehomogBinary G).coeff i = 0 := by simp [h]
      rw [dehomogBinary_of_isHomogeneous G hG, Polynomial.finsetSum_coeff] at h0
      have hsum :
          (∑ j ∈ Finset.range (d + 1),
              (Polynomial.monomial j (G.coeff (binaryMonom d j))).coeff i) =
            G.coeff (binaryMonom d i) := by
        rw [Finset.sum_eq_single i]
        · simp [Polynomial.coeff_monomial]
        · intro j _ hji; simp [Polynomial.coeff_monomial, hji]
        · intro hni; exact (hni hi).elim
      exact hsum.symm.trans h0
    simp [hcoeff]
  · rintro rfl; simp [dehomogBinary]

/-- A homogeneous binary form vanishing on the affine line `Y₀ = 1` is zero. -/
theorem isHomogeneous_binary_eq_zero_of_eval_one
    {k : Type u} [Field k] [Infinite k]
    (G : MvPolynomial (Fin 2) k) {d : ℕ} (hG : G.IsHomogeneous d)
    (h : ∀ t : k, eval (![1, t]) G = 0) : G = 0 := by
  have hde : dehomogBinary G = 0 :=
    Polynomial.funext fun t => by simpa [eval_dehomogBinary] using h t
  exact (dehomogBinary_eq_zero_iff_of_isHomogeneous G hG).mp hde

/-! ### Surface vanishing `X₂ = Y₂ = 0` -/

/-- Free-direction form vanishing implies `F` vanishes on the full surface `X₂ = Y₂ = 0`. -/
theorem eval_F_on_X2Y2_zero_of_freeDirForm_eq_zero
    {k : Type u} [Field k] [Infinite k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (hα : specializedConicFreeDirForm F = 0)
    (x0 x1 y0 y1 : k) :
    eval (Sum.elim (![x0, x1, (0 : k)]) (![y0, y1, (0 : k)])) F = 0 := by
  let G := binaryY_of_X2_zero F x0 x1
  have hGhom : G.IsHomogeneous 3 := binaryY_of_X2_zero_isHomogeneous F hF x0 x1
  have hline (t : k) : eval (![1, t]) G = 0 := by
    have := eval_F_coordinateLine_of_freeDirForm_eq_zero F hF hα t x0 x1
    simpa [G, eval_binaryY_of_X2_zero, coordinateLinePoint] using this
  have hG0 : G = 0 := isHomogeneous_binary_eq_zero_of_eval_one G hGhom hline
  have : eval (![y0, y1]) G = 0 := by simp [hG0]
  rwa [eval_binaryY_of_X2_zero] at this

/-- Restriction of `F` to `X₂ = Y₂ = 0` as a 4-variable polynomial. -/
def restrictX2Y2
    {R : Type u} [CommRing R]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) R) :
    MvPolynomial (Fin 2 ⊕ Fin 2) R :=
  aeval
    (fun z : BiprojectiveCoordinate 2 2 =>
      match z with
      | Sum.inl i =>
          if h : (i : ℕ) < 2 then X (Sum.inl ⟨i, h⟩) else 0
      | Sum.inr j =>
          if h : (j : ℕ) < 2 then X (Sum.inr ⟨j, h⟩) else 0)
    F

theorem eval_restrictX2Y2
    {R : Type u} [CommRing R]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) R)
    (x y : Fin 2 → R) :
    eval (Sum.elim x y) (restrictX2Y2 F) =
      eval (Sum.elim (![x 0, x 1, 0]) (![y 0, y 1, 0])) F := by
  simp only [restrictX2Y2, aeval_def]
  rw [eval_eval₂]
  have hg : (fun z : BiprojectiveCoordinate 2 2 =>
      eval (Sum.elim x y)
        (match z with
        | Sum.inl i => if h : (i : ℕ) < 2 then X (Sum.inl ⟨i, h⟩) else 0
        | Sum.inr j => if h : (j : ℕ) < 2 then X (Sum.inr ⟨j, h⟩) else 0)) =
      Sum.elim (![x 0, x 1, 0]) (![y 0, y 1, 0]) := by
    funext z
    match z with
    | Sum.inl i => fin_cases i <;> simp [eval_X]
    | Sum.inr j => fin_cases j <;> simp [eval_X]
  have hf : (eval (Sum.elim x y)).comp (algebraMap R (MvPolynomial (Fin 2 ⊕ Fin 2) R)) =
      RingHom.id R := by
    ext a; simp [eval_C, algebraMap_eq]
  simp only [hg, hf, eval₂_id]

theorem restrictX2Y2_eq_zero_of_freeDirForm_eq_zero
    {k : Type u} [Field k] [Infinite k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (hα : specializedConicFreeDirForm F = 0) :
    restrictX2Y2 F = 0 := by
  refine MvPolynomial.funext fun z => ?_
  have h := eval_F_on_X2Y2_zero_of_freeDirForm_eq_zero F hF hα
    (z (Sum.inl 0)) (z (Sum.inl 1)) (z (Sum.inr 0)) (z (Sum.inr 1))
  have hz : z = Sum.elim ![z (Sum.inl 0), z (Sum.inl 1)]
      ![z (Sum.inr 0), z (Sum.inr 1)] := by
    funext i
    match i with
    | Sum.inl a => fin_cases a <;> simp
    | Sum.inr b => fin_cases b <;> simp
  rw [hz, eval_restrictX2Y2]
  simpa using h


/-! ### Ideal membership `F ∈ (X₂, Y₂)` via monomial division -/

/-- Remainder of `F` after discarding monoms divisible by `X₂` or `Y₂`. -/
def freePartX2Y2 {R : Type u} [CommRing R]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) R) :
    MvPolynomial (BiprojectiveCoordinate 2 2) R :=
  (F.modMonomial (Finsupp.single (Sum.inl (2 : Fin 3)) 1)).modMonomial
    (Finsupp.single (Sum.inr 2) 1)

/-- `F = X₂ · A + Y₂ · B + freePartX2Y2 F`. -/
theorem eq_X2_mul_add_Y2_mul_add_freePart {R : Type u} [CommRing R]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) R) :
    ∃ A B : MvPolynomial (BiprojectiveCoordinate 2 2) R,
      F = X (Sum.inl 2) * A + X (Sum.inr 2) * B + freePartX2Y2 F := by
  set R1 := F.modMonomial (Finsupp.single (Sum.inl (2 : Fin 3)) 1)
  set A1 := F.divMonomial (Finsupp.single (Sum.inl (2 : Fin 3)) 1)
  have h1 : X (Sum.inl 2) * A1 + R1 = F := by
    simpa [R1, A1] using divMonomial_add_modMonomial_single F (Sum.inl 2)
  set B := R1.divMonomial (Finsupp.single (Sum.inr (2 : Fin 3)) 1)
  set R0 := R1.modMonomial (Finsupp.single (Sum.inr (2 : Fin 3)) 1)
  have h2 : X (Sum.inr 2) * B + R0 = R1 := by
    simpa [B, R0] using divMonomial_add_modMonomial_single R1 (Sum.inr 2)
  refine ⟨A1, B, ?_⟩
  have hfree : freePartX2Y2 F = R0 := by simp only [freePartX2Y2, R1, R0]
  calc
    F = X (Sum.inl 2) * A1 + R1 := h1.symm
    _ = X (Sum.inl 2) * A1 + (X (Sum.inr 2) * B + R0) := by rw [← h2]
    _ = X (Sum.inl 2) * A1 + X (Sum.inr 2) * B + freePartX2Y2 F := by
      rw [hfree]; abel

/-- Free multiindices are unchanged by double `modMonomial`. -/
theorem coeff_freePartX2Y2_of_free {R : Type u} [CommRing R]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) R)
    (m : BiprojectiveCoordinate 2 2 →₀ ℕ)
    (h0 : m (Sum.inl 2) = 0) (h1 : m (Sum.inr 2) = 0) :
    (freePartX2Y2 F).coeff m = F.coeff m := by
  simp only [freePartX2Y2]
  have hsX : ¬ Finsupp.single (Sum.inl (2 : Fin 3)) 1 ≤ m := by
    intro hle
    have := hle (Sum.inl 2)
    simp [Finsupp.single_apply, h0] at this
  have hsY : ¬ Finsupp.single (Sum.inr (2 : Fin 3)) 1 ≤ m := by
    intro hle
    have := hle (Sum.inr 2)
    simp [Finsupp.single_apply, h1] at this
  rw [coeff_modMonomial_of_not_le _ hsY, coeff_modMonomial_of_not_le _ hsX]

private theorem single_one_le_of_pos {σ : Type*} (i : σ) (m : σ →₀ ℕ) (h : m i ≠ 0) :
    Finsupp.single i 1 ≤ m := by
  intro j
  by_cases hj : j = i
  · subst hj
    simpa [Finsupp.single_apply] using Nat.one_le_iff_ne_zero.mpr h
  · simp [Finsupp.single_apply, hj]

/-- Support monoms of `F % Xᵢ` are free of coordinate `i`. -/
theorem support_modMonomial_X_free
    {R : Type u} [CommRing R] {σ : Type*}
    (F : MvPolynomial σ R) (i : σ)
    {m : σ →₀ ℕ}
    (hm : m ∈ (F.modMonomial (Finsupp.single i 1)).support) :
    m i = 0 := by
  by_contra h
  have := coeff_modMonomial_of_le F (single_one_le_of_pos i m h)
  exact absurd this (mem_support_iff.mp hm)

/-- Support monoms of `freePartX2Y2 F` are free of both `X₂` and `Y₂`. -/
theorem support_freePartX2Y2_free {R : Type u} [CommRing R]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) R)
    {m : BiprojectiveCoordinate 2 2 →₀ ℕ}
    (hm : m ∈ (freePartX2Y2 F).support) :
    m (Sum.inl 2) = 0 ∧ m (Sum.inr 2) = 0 := by
  simp only [freePartX2Y2] at hm
  constructor
  · by_contra hX
    by_cases hleY : Finsupp.single (Sum.inr (2 : Fin 3)) 1 ≤ m
    · have := coeff_modMonomial_of_le
        (F.modMonomial (Finsupp.single (Sum.inl (2 : Fin 3)) 1)) hleY
      exact absurd this (mem_support_iff.mp hm)
    · have hfp : (freePartX2Y2 F).coeff m ≠ 0 := by
        simpa [freePartX2Y2] using mem_support_iff.mp hm
      have hne : (F.modMonomial (Finsupp.single (Sum.inl (2 : Fin 3)) 1)).coeff m ≠ 0 := by
        rwa [freePartX2Y2, coeff_modMonomial_of_not_le _ hleY] at hfp
      have hmR1 :
          m ∈ (F.modMonomial (Finsupp.single (Sum.inl (2 : Fin 3)) 1)).support :=
        mem_support_iff.mpr hne
      exact absurd (support_modMonomial_X_free F (Sum.inl 2) hmR1) hX
  · by_contra hY
    have := coeff_modMonomial_of_le
      (F.modMonomial (Finsupp.single (Sum.inl (2 : Fin 3)) 1))
      (single_one_le_of_pos (Sum.inr 2) m hY)
    exact absurd this (mem_support_iff.mp hm)

/-- Free monoms evaluate equally at points that agree on free coordinates. -/
private theorem eval_monomial_of_free_coords
    {R : Type u} [CommRing R]
    (m : BiprojectiveCoordinate 2 2 →₀ ℕ) (c : R)
    (z z0 : BiprojectiveCoordinate 2 2 → R)
    (hm0 : m (Sum.inl 2) = 0) (hm1 : m (Sum.inr 2) = 0)
    (hagree :
      z (Sum.inl 0) = z0 (Sum.inl 0) ∧ z (Sum.inl 1) = z0 (Sum.inl 1) ∧
        z (Sum.inr 0) = z0 (Sum.inr 0) ∧ z (Sum.inr 1) = z0 (Sum.inr 1)) :
    eval z (monomial m c) = eval z0 (monomial m c) := by
  simp only [eval_monomial]
  congr 1
  apply Finset.prod_congr rfl
  intro i hi
  have hmi : m i ≠ 0 := Finsupp.mem_support_iff.mp hi
  match i with
  | Sum.inl j =>
      fin_cases j
      · simp [hagree.1]
      · simp [hagree.2.1]
      · exact (hmi hm0).elim
  | Sum.inr j =>
      fin_cases j
      · simp [hagree.2.2.1]
      · simp [hagree.2.2.2]
      · exact (hmi hm1).elim

/-- Free-direction form vanishing forces the free part to vanish. -/
theorem freePartX2Y2_eq_zero_of_freeDirForm_eq_zero
    {k : Type u} [Field k] [Infinite k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (hα : specializedConicFreeDirForm F = 0) :
    freePartX2Y2 F = 0 := by
  refine MvPolynomial.funext fun z => ?_
  obtain ⟨A, B, hAB⟩ := eq_X2_mul_add_Y2_mul_add_freePart F
  let z0 : BiprojectiveCoordinate 2 2 → k :=
    Sum.elim ![z (Sum.inl 0), z (Sum.inl 1), (0 : k)]
      ![z (Sum.inr 0), z (Sum.inr 1), 0]
  have hF0 : eval z0 F = 0 := by
    simpa [z0] using
      eval_F_on_X2Y2_zero_of_freeDirForm_eq_zero F hF hα
        (z (Sum.inl 0)) (z (Sum.inl 1)) (z (Sum.inr 0)) (z (Sum.inr 1))
  -- eval z0 freePart = 0
  have hFP0 : eval z0 (freePartX2Y2 F) = 0 := by
    have hz0X : z0 (Sum.inl 2) = 0 := by simp [z0]
    have hz0Y : z0 (Sum.inr 2) = 0 := by simp [z0]
    have heq : eval z0 F =
        z0 (Sum.inl 2) * eval z0 A + z0 (Sum.inr 2) * eval z0 B +
          eval z0 (freePartX2Y2 F) := by
      -- Rewrite only the outer F, not inside freePartX2Y2
      have h := congrArg (eval z0) hAB
      simpa only [eval_add, eval_mul, eval_X] using h
    have h' : eval z0 F = eval z0 (freePartX2Y2 F) := by
      simpa [hz0X, hz0Y, zero_mul, zero_add] using heq
    exact h'.symm.trans hF0
  -- eval z freePart = eval z0 freePart
  have hagree : eval z (freePartX2Y2 F) = eval z0 (freePartX2Y2 F) := by
    rw [MvPolynomial.as_sum (freePartX2Y2 F), map_sum, map_sum]
    refine Finset.sum_congr rfl fun m hm => ?_
    obtain ⟨hm0, hm1⟩ := support_freePartX2Y2_free F hm
    exact eval_monomial_of_free_coords m _ z z0 hm0 hm1
      ⟨by simp [z0], by simp [z0], by simp [z0], by simp [z0]⟩
  rw [hagree, hFP0]
  rfl

/-- Free-direction form vanishing forces `F ∈ (X₂, Y₂)`. -/
theorem mem_span_X2_Y2_of_freeDirForm_eq_zero
    {k : Type u} [Field k] [Infinite k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (hα : specializedConicFreeDirForm F = 0) :
    F ∈ Ideal.span
      ({X (Sum.inl (2 : Fin 3)), X (Sum.inr 2)} :
        Set (MvPolynomial (BiprojectiveCoordinate 2 2) k)) := by
  obtain ⟨A, B, hAB⟩ := eq_X2_mul_add_Y2_mul_add_freePart F
  have hfree := freePartX2Y2_eq_zero_of_freeDirForm_eq_zero F hF hα
  have hAB' : F = X (Sum.inl 2) * A + X (Sum.inr 2) * B := by
    rw [hAB, hfree, add_zero]
  rw [hAB']
  set S : Set (MvPolynomial (BiprojectiveCoordinate 2 2) k) :=
    {X (Sum.inl (2 : Fin 3)), X (Sum.inr 2)}
  have hXspan : X (Sum.inl (2 : Fin 3)) ∈ Ideal.span S :=
    Ideal.subset_span (Set.mem_insert _ _)
  have hYspan : X (Sum.inr (2 : Fin 3)) ∈ Ideal.span S :=
    Ideal.subset_span (Set.mem_insert_of_mem _ rfl)
  exact Ideal.add_mem (Ideal.span S)
    (Ideal.mul_mem_right A (Ideal.span S) hXspan)
    (Ideal.mul_mem_right B (Ideal.span S) hYspan)

/-- Residual X-coords are nonzero once freeDir form is nonzero. -/
theorem residualImageXCoords_ne_zero_of_freeDir
    {k : Type u} [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (v : Fin 3 → Polynomial k) (hv0 : v ≠ 0)
    (hv : TernaryQuadraticPoly.eval (coordinateLineTernaryQuadraticPoly F) v = 0)
    (hα : specializedConicFreeDirForm F ≠ 0) :
    residualImageXCoords F v ≠ 0 :=
  residualImageXCoords_ne_zero_of_freeDir_ne_zero F hF v hv0 hv hα

/-! ### Singularity of the surface `X₂ = Y₂ = 0` when freeDir vanishes -/

/-- Canonical cofactor decomposition under free-direction vanishing. -/
theorem eq_X2_mul_add_Y2_mul_of_freeDirForm_eq_zero
    {k : Type u} [Field k] [Infinite k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (hα : specializedConicFreeDirForm F = 0) :
    ∃ A B : MvPolynomial (BiprojectiveCoordinate 2 2) k,
      F = X (Sum.inl 2) * A + X (Sum.inr 2) * B := by
  obtain ⟨A, B, hAB⟩ := eq_X2_mul_add_Y2_mul_add_freePart F
  have hfree := freePartX2Y2_eq_zero_of_freeDirForm_eq_zero F hF hα
  exact ⟨A, B, by rw [hAB, hfree, add_zero]⟩

/-- Free-surface specialisation in the free `X`-block. -/
def freeX_on_X2Y2_zero
    {R : Type u} [CommRing R]
    (G : MvPolynomial (BiprojectiveCoordinate 2 2) R)
    (y0 y1 : R) : MvPolynomial (Fin 2) R :=
  aeval (Sum.elim ![X (0 : Fin 2), X 1, (0 : MvPolynomial (Fin 2) R)]
      ![C y0, C y1, 0]) G

/-- Free-surface specialisation in the free `Y`-block. -/
def freeY_on_X2Y2_zero
    {R : Type u} [CommRing R]
    (G : MvPolynomial (BiprojectiveCoordinate 2 2) R)
    (x0 x1 : R) : MvPolynomial (Fin 2) R :=
  aeval (Sum.elim ![C x0, C x1, (0 : MvPolynomial (Fin 2) R)]
      ![X (0 : Fin 2), X 1, 0]) G

theorem eval_freeX_on_X2Y2_zero
    {R : Type u} [CommRing R]
    (G : MvPolynomial (BiprojectiveCoordinate 2 2) R)
    (x0 x1 y0 y1 : R) :
    eval (![x0, x1]) (freeX_on_X2Y2_zero G y0 y1) =
      eval (Sum.elim (![x0, x1, (0 : R)]) (![y0, y1, 0])) G := by
  simp only [freeX_on_X2Y2_zero, aeval_def]
  rw [eval_eval₂]
  have hg : (fun z : BiprojectiveCoordinate 2 2 =>
      eval (![x0, x1])
        (Sum.elim ![X (0 : Fin 2), X 1, (0 : MvPolynomial (Fin 2) R)]
          ![C y0, C y1, 0] z)) =
      Sum.elim (![x0, x1, (0 : R)]) (![y0, y1, 0]) := by
    funext z
    match z with
    | Sum.inl i => fin_cases i <;> simp [eval_X, eval_C]
    | Sum.inr j => fin_cases j <;> simp [eval_X, eval_C]
  have hf : (eval (![x0, x1])).comp (algebraMap R (MvPolynomial (Fin 2) R)) =
      RingHom.id R := by
    ext a; simp [eval_C, algebraMap_eq]
  simp only [hg, hf, eval₂_id]

theorem eval_freeY_on_X2Y2_zero
    {R : Type u} [CommRing R]
    (G : MvPolynomial (BiprojectiveCoordinate 2 2) R)
    (x0 x1 y0 y1 : R) :
    eval (![y0, y1]) (freeY_on_X2Y2_zero G x0 x1) =
      eval (Sum.elim (![x0, x1, (0 : R)]) (![y0, y1, 0])) G := by
  simp only [freeY_on_X2Y2_zero, aeval_def]
  rw [eval_eval₂]
  have hg : (fun z : BiprojectiveCoordinate 2 2 =>
      eval (![y0, y1])
        (Sum.elim ![C x0, C x1, (0 : MvPolynomial (Fin 2) R)]
          ![X (0 : Fin 2), X 1, 0] z)) =
      Sum.elim (![x0, x1, (0 : R)]) (![y0, y1, 0]) := by
    funext z
    match z with
    | Sum.inl i => fin_cases i <;> simp [eval_X, eval_C]
    | Sum.inr j => fin_cases j <;> simp [eval_X, eval_C]
  have hf : (eval (![y0, y1])).comp (algebraMap R (MvPolynomial (Fin 2) R)) =
      RingHom.id R := by
    ext a; simp [eval_C, algebraMap_eq]
  simp only [hg, hf, eval₂_id]

theorem isHomogeneous_freeX_on_X2Y2_zero
    {R : Type u} [CommRing R] {d e : ℕ}
    (G : MvPolynomial (BiprojectiveCoordinate 2 2) R)
    (hG : IsBihomogeneousOfBidegree d e G)
    (y0 y1 : R) :
    (freeX_on_X2Y2_zero G y0 y1).IsHomogeneous d := by
  refine hG.isWeightedHomogeneous_left.aeval_isHomogeneous
    (Sum.elim ![X (0 : Fin 2), X 1, (0 : MvPolynomial (Fin 2) R)]
      ![C y0, C y1, 0]) ?_
  intro z
  match z with
  | Sum.inl i =>
      fin_cases i
      · change (X (0 : Fin 2)).IsHomogeneous (leftDegreeWeight (Sum.inl 0))
        simp [leftDegreeWeight, isHomogeneous_X]
      · change (X (1 : Fin 2)).IsHomogeneous (leftDegreeWeight (Sum.inl 1))
        simp [leftDegreeWeight, isHomogeneous_X]
      · change (0 : MvPolynomial (Fin 2) R).IsHomogeneous (leftDegreeWeight (Sum.inl 2))
        simp [leftDegreeWeight, isHomogeneous_zero]
  | Sum.inr j =>
      fin_cases j
      · change (C y0).IsHomogeneous (leftDegreeWeight (Sum.inr 0))
        simp [leftDegreeWeight, isHomogeneous_C]
      · change (C y1).IsHomogeneous (leftDegreeWeight (Sum.inr 1))
        simp [leftDegreeWeight, isHomogeneous_C]
      · change (0 : MvPolynomial (Fin 2) R).IsHomogeneous (leftDegreeWeight (Sum.inr 2))
        simp [leftDegreeWeight, isHomogeneous_zero]

theorem isHomogeneous_freeY_on_X2Y2_zero
    {R : Type u} [CommRing R] {d e : ℕ}
    (G : MvPolynomial (BiprojectiveCoordinate 2 2) R)
    (hG : IsBihomogeneousOfBidegree d e G)
    (x0 x1 : R) :
    (freeY_on_X2Y2_zero G x0 x1).IsHomogeneous e := by
  refine hG.isWeightedHomogeneous_right.aeval_isHomogeneous
    (Sum.elim ![C x0, C x1, (0 : MvPolynomial (Fin 2) R)]
      ![X (0 : Fin 2), X 1, 0]) ?_
  intro z
  match z with
  | Sum.inl i =>
      fin_cases i
      · change (C x0).IsHomogeneous (rightDegreeWeight (Sum.inl 0))
        simp [rightDegreeWeight, isHomogeneous_C]
      · change (C x1).IsHomogeneous (rightDegreeWeight (Sum.inl 1))
        simp [rightDegreeWeight, isHomogeneous_C]
      · change (0 : MvPolynomial (Fin 2) R).IsHomogeneous (rightDegreeWeight (Sum.inl 2))
        simp [rightDegreeWeight, isHomogeneous_zero]
  | Sum.inr j =>
      fin_cases j
      · change (X (0 : Fin 2)).IsHomogeneous (rightDegreeWeight (Sum.inr 0))
        simp [rightDegreeWeight, isHomogeneous_X]
      · change (X (1 : Fin 2)).IsHomogeneous (rightDegreeWeight (Sum.inr 1))
        simp [rightDegreeWeight, isHomogeneous_X]
      · change (0 : MvPolynomial (Fin 2) R).IsHomogeneous (rightDegreeWeight (Sum.inr 2))
        simp [rightDegreeWeight, isHomogeneous_zero]

/-- On `X₂ = Y₂ = 0`, free partials of `X₂ A + Y₂ B` vanish and normal partials recover the
cofactors. -/
theorem eval_pderiv_of_X2_mul_add_Y2_mul_on_X2Y2_zero
    {R : Type u} [CommRing R]
    (A B : MvPolynomial (BiprojectiveCoordinate 2 2) R)
    (x0 x1 y0 y1 : R) :
    let z : BiprojectiveCoordinate 2 2 → R :=
      Sum.elim (![x0, x1, (0 : R)]) (![y0, y1, 0])
    let Fpoly := X (Sum.inl (2 : Fin 3)) * A + X (Sum.inr 2) * B
    eval z Fpoly = 0 ∧
      (∀ i : Fin 3, i ≠ 2 → eval z (pderiv (Sum.inl i) Fpoly) = 0) ∧
      (∀ j : Fin 3, j ≠ 2 → eval z (pderiv (Sum.inr j) Fpoly) = 0) ∧
      eval z (pderiv (Sum.inl 2) Fpoly) = eval z A ∧
      eval z (pderiv (Sum.inr 2) Fpoly) = eval z B := by
  intro z Fpoly
  have hzX : z (Sum.inl 2) = 0 := by simp [z]
  have hzY : z (Sum.inr 2) = 0 := by simp [z]
  have hFval : eval z Fpoly = 0 := by
    simp only [Fpoly, eval_add, eval_mul, eval_X, hzX, hzY, zero_mul, add_zero]
  have hderiv (w : BiprojectiveCoordinate 2 2) :
      pderiv w Fpoly =
        pderiv w (X (Sum.inl 2)) * A + X (Sum.inl 2) * pderiv w A +
          pderiv w (X (Sum.inr 2)) * B + X (Sum.inr 2) * pderiv w B := by
    simp only [Fpoly, map_add, Derivation.leibniz, smul_eq_mul]
    ring
  have heval_deriv (w : BiprojectiveCoordinate 2 2) :
      eval z (pderiv w Fpoly) =
        eval z (pderiv w (X (Sum.inl 2))) * eval z A +
          eval z (pderiv w (X (Sum.inr 2))) * eval z B := by
    rw [hderiv]
    simp only [eval_add, eval_mul, eval_X, hzX, hzY, zero_mul, add_zero]
  refine ⟨hFval, ?_, ?_, ?_, ?_⟩
  · intro i hi
    rw [heval_deriv, pderiv_X, pderiv_X]
    simp [hi]
  · intro j hj
    rw [heval_deriv, pderiv_X, pderiv_X]
    simp [hj]
  · rw [heval_deriv, pderiv_X, pderiv_X]
    simp
  · rw [heval_deriv, pderiv_X, pderiv_X]
    simp

/-- Left-weight zero polynomials ignore first-block coordinates. -/
theorem eval_eq_of_isWeightedHomogeneous_left_zero
    {R : Type u} [CommRing R]
    (G : MvPolynomial (BiprojectiveCoordinate 2 2) R)
    (hG : G.IsWeightedHomogeneous leftDegreeWeight 0)
    (x x' y : Fin 3 → R) :
    eval (Sum.elim x y) G = eval (Sum.elim x' y) G := by
  classical
  rw [MvPolynomial.as_sum G, map_sum, map_sum]
  refine Finset.sum_congr rfl fun m hm => ?_
  have hmw : Finsupp.weight leftDegreeWeight m = 0 := hG (mem_support_iff.mp hm)
  have hinl : ∀ i : Fin 3, m (Sum.inl i) = 0 := by
    intro i
    by_contra hne
    have hle :
        leftDegreeWeight (Sum.inl i) ≤ Finsupp.weight leftDegreeWeight m :=
      Finsupp.le_weight_of_ne_zero' leftDegreeWeight hne
    simp [leftDegreeWeight, hmw] at hle
  simp only [eval_monomial]
  congr 1
  refine Finset.prod_congr rfl fun z hz => ?_
  match z with
  | Sum.inl i => simp [hinl i]
  | Sum.inr j => rfl

/-- A left-degree-one bihomogeneous polynomial is linear in free `X` on `X₂ = 0`. -/
theorem eval_left_degree_one_on_X2_zero
    {R : Type u} [CommRing R] {e : ℕ}
    (G : MvPolynomial (BiprojectiveCoordinate 2 2) R)
    (hG : IsBihomogeneousOfBidegree 1 e G)
    (x0 x1 y0 y1 : R) :
    eval (Sum.elim (![x0, x1, (0 : R)]) (![y0, y1, 0])) G =
      x0 * eval (Sum.elim (![1, 0, (0 : R)]) (![y0, y1, 0])) G +
        x1 * eval (Sum.elim (![0, 1, (0 : R)]) (![y0, y1, 0])) G := by
  have hE :
      X (Sum.inl 0) * pderiv (Sum.inl 0) G +
          X (Sum.inl 1) * pderiv (Sum.inl 1) G +
            X (Sum.inl 2) * pderiv (Sum.inl 2) G = G := by
    simpa [Fin.sum_univ_three, one_smul] using hG.sum_inl_X_mul_pderiv
  have h0deg (i : Fin 3) :
      (pderiv (Sum.inl i) G).IsWeightedHomogeneous leftDegreeWeight 0 :=
    (hG.pderiv_inl (by norm_num) i).isWeightedHomogeneous_left
  have hz :
      eval (Sum.elim (![x0, x1, (0 : R)]) (![y0, y1, 0])) G =
        x0 * eval (Sum.elim (![x0, x1, (0 : R)]) (![y0, y1, 0]))
            (pderiv (Sum.inl 0) G) +
          x1 * eval (Sum.elim (![x0, x1, (0 : R)]) (![y0, y1, 0]))
            (pderiv (Sum.inl 1) G) := by
    have h := congrArg (eval (Sum.elim (![x0, x1, (0 : R)]) (![y0, y1, 0]))) hE
    have h' :
        x0 * eval (Sum.elim (![x0, x1, (0 : R)]) (![y0, y1, 0]))
              (pderiv (Sum.inl 0) G) +
            x1 * eval (Sum.elim (![x0, x1, (0 : R)]) (![y0, y1, 0]))
              (pderiv (Sum.inl 1) G) =
          eval (Sum.elim (![x0, x1, (0 : R)]) (![y0, y1, 0])) G := by
      simpa [eval_add, eval_mul, eval_X] using h
    exact h'.symm
  have hpartial0 :
      eval (Sum.elim (![x0, x1, (0 : R)]) (![y0, y1, 0])) (pderiv (Sum.inl 0) G) =
        eval (Sum.elim (![1, 0, (0 : R)]) (![y0, y1, 0])) (pderiv (Sum.inl 0) G) :=
    eval_eq_of_isWeightedHomogeneous_left_zero _ (h0deg 0)
      (![x0, x1, (0 : R)]) (![1, 0, (0 : R)]) (![y0, y1, 0])
  have hpartial1 :
      eval (Sum.elim (![x0, x1, (0 : R)]) (![y0, y1, 0])) (pderiv (Sum.inl 1) G) =
        eval (Sum.elim (![0, 1, (0 : R)]) (![y0, y1, 0])) (pderiv (Sum.inl 1) G) :=
    eval_eq_of_isWeightedHomogeneous_left_zero _ (h0deg 1)
      (![x0, x1, (0 : R)]) (![0, 1, (0 : R)]) (![y0, y1, 0])
  have hG10 :
      eval (Sum.elim (![1, 0, (0 : R)]) (![y0, y1, 0])) G =
        eval (Sum.elim (![1, 0, (0 : R)]) (![y0, y1, 0])) (pderiv (Sum.inl 0) G) := by
    have h := congrArg (eval (Sum.elim (![1, 0, (0 : R)]) (![y0, y1, 0]))) hE
    have h' :
        eval (Sum.elim (![1, 0, (0 : R)]) (![y0, y1, 0])) (pderiv (Sum.inl 0) G) =
          eval (Sum.elim (![1, 0, (0 : R)]) (![y0, y1, 0])) G := by
      simpa [eval_add, eval_mul, eval_X] using h
    exact h'.symm
  have hG01 :
      eval (Sum.elim (![0, 1, (0 : R)]) (![y0, y1, 0])) G =
        eval (Sum.elim (![0, 1, (0 : R)]) (![y0, y1, 0])) (pderiv (Sum.inl 1) G) := by
    have h := congrArg (eval (Sum.elim (![0, 1, (0 : R)]) (![y0, y1, 0]))) hE
    have h' :
        eval (Sum.elim (![0, 1, (0 : R)]) (![y0, y1, 0])) (pderiv (Sum.inl 1) G) =
          eval (Sum.elim (![0, 1, (0 : R)]) (![y0, y1, 0])) G := by
      simpa [eval_add, eval_mul, eval_X] using h
    exact h'.symm
  rw [hz, hpartial0, hpartial1, hG10, hG01]

/-- Scaled biprojective weight for substitution of left degree `p` and right degree `q`. -/
def scaledBidegreeWeight (m n p q : ℕ) : BiprojectiveCoordinate m n → ℕ
  | Sum.inl _ => p
  | Sum.inr _ => q

theorem IsBihomogeneousOfBidegree.isWeightedHomogeneous_scaled
    {m n d e p q : ℕ} {R : Type u} [CommSemiring R]
    {F : MvPolynomial (BiprojectiveCoordinate m n) R}
    (hF : IsBihomogeneousOfBidegree d e F) :
    F.IsWeightedHomogeneous (scaledBidegreeWeight m n p q) (d * p + e * q) := by
  intro mdeg hm
  have h := hF hm
  have hL : Finsupp.weight leftDegreeWeight mdeg = d := by
    simpa [fst_weight_bidegreeWeight] using congrArg Prod.fst h
  have hR : Finsupp.weight rightDegreeWeight mdeg = e := by
    simpa [snd_weight_bidegreeWeight] using congrArg Prod.snd h
  classical
  have hsplit :
      Finsupp.weight (scaledBidegreeWeight m n p q) mdeg =
        p * Finsupp.weight leftDegreeWeight mdeg +
          q * Finsupp.weight rightDegreeWeight mdeg := by
    simp only [Finsupp.weight_apply, scaledBidegreeWeight, leftDegreeWeight,
      rightDegreeWeight, Finsupp.sum]
    rw [Finset.mul_sum, Finset.mul_sum, ← Finset.sum_add_distrib]
    refine Finset.sum_congr rfl fun i _ => ?_
    match i with
    | Sum.inl _ => ring
    | Sum.inr _ => ring
  rw [hsplit, hL, hR]; ring

/-- Bihomogeneous evaluation is compatible with independent block normalizations. -/
theorem eval_normalize_blocks_eq_zero_of_isBidegree
    {k : Type u} [Field k] {d e : ℕ}
    (G : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (hG : IsBihomogeneousOfBidegree d e G)
    (x0 y0 : Fin 3 → k) (i j : Fin 3)
    (hval : eval (Sum.elim x0 y0) G = 0) :
    eval (Sum.elim (normalizeCoordinateRepresentative x0 i)
        (normalizeCoordinateRepresentative y0 j)) G = 0 := by
  set x := normalizeCoordinateRepresentative x0 i
  set y := normalizeCoordinateRepresentative y0 j
  have hxF : eval (Sum.elim x y0) G = 0 := by
    have hsmul :
        eval (fun z : BiprojectiveCoordinate 2 2 =>
            (x0 i)⁻¹ ^ leftDegreeWeight z * Sum.elim x0 y0 z) G =
          (x0 i)⁻¹ ^ d * eval (Sum.elim x0 y0) G :=
      hG.isWeightedHomogeneous_left.eval₂_weight_smul (RingHom.id k)
        (Sum.elim x0 y0) (x0 i)⁻¹
    have hxdef :
        (fun z : BiprojectiveCoordinate 2 2 =>
          (x0 i)⁻¹ ^ leftDegreeWeight z * Sum.elim x0 y0 z) =
          Sum.elim x y0 := by
      funext z
      match z with
      | Sum.inl a =>
          simp [x, normalizeCoordinateRepresentative, leftDegreeWeight, Pi.smul_apply,
            smul_eq_mul, pow_one]
      | Sum.inr b => simp [leftDegreeWeight]
    have : eval (Sum.elim x y0) G =
        (x0 i)⁻¹ ^ d * eval (Sum.elim x0 y0) G := by
      rwa [hxdef] at hsmul
    simpa [hval] using this
  have hsmulY :
      eval (fun z : BiprojectiveCoordinate 2 2 =>
          (y0 j)⁻¹ ^ rightDegreeWeight z * Sum.elim x y0 z) G =
        (y0 j)⁻¹ ^ e * eval (Sum.elim x y0) G :=
    hG.isWeightedHomogeneous_right.eval₂_weight_smul (RingHom.id k)
      (Sum.elim x y0) (y0 j)⁻¹
  have hydef :
      (fun z : BiprojectiveCoordinate 2 2 =>
        (y0 j)⁻¹ ^ rightDegreeWeight z * Sum.elim x y0 z) =
        Sum.elim x y := by
    funext z
    match z with
    | Sum.inl a => simp [rightDegreeWeight]
    | Sum.inr b =>
        simp [y, normalizeCoordinateRepresentative, rightDegreeWeight, Pi.smul_apply,
          smul_eq_mul, pow_one]
  have : eval (Sum.elim x y) G =
      (y0 j)⁻¹ ^ e * eval (Sum.elim x y0) G := by
    rwa [hydef] at hsmulY
  simpa [hxF] using this

/-- Free-direction vanishing produces a singular biprojective point on `X₂ = Y₂ = 0`. -/
theorem exists_singular_point_on_X2Y2_zero_of_freeDirForm_eq_zero
    {k : Type u} [Field k] [IsAlgClosed k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (hα : specializedConicFreeDirForm F = 0) :
    ∃ (x y : Fin 3 → k),
      x ≠ 0 ∧ y ≠ 0 ∧ x 2 = 0 ∧ y 2 = 0 ∧
        eval (Sum.elim x y) F = 0 ∧
          ∀ z : BiprojectiveCoordinate 2 2,
            eval (Sum.elim x y) (pderiv z F) = 0 := by
  classical
  haveI : Infinite k := inferInstance
  obtain ⟨A, B, hAB⟩ := eq_X2_mul_add_Y2_mul_of_freeDirForm_eq_zero F hF hα
  -- Work with the cofactor form of F
  have hFform : F = X (Sum.inl 2) * A + X (Sum.inr 2) * B := hAB
  set FX := pderiv (Sum.inl (2 : Fin 3)) F with hFXd
  set FY := pderiv (Sum.inr (2 : Fin 3)) F with hFYd
  have hFXdeg : IsBihomogeneousOfBidegree 1 3 FX := by
    simpa [FX] using hF.pderiv_inl (by norm_num) (2 : Fin 3)
  have hFYdeg : IsBihomogeneousOfBidegree 2 2 FY := by
    simpa [FY] using hF.pderiv_inr (by norm_num) (2 : Fin 3)
  -- Surface vanishing + gradient control from product rule
  have hpoint (x0 x1 y0 y1 : k)
      (hA0 : eval (Sum.elim (![x0, x1, (0 : k)]) (![y0, y1, 0])) A = 0)
      (hB0 : eval (Sum.elim (![x0, x1, (0 : k)]) (![y0, y1, 0])) B = 0) :
      eval (Sum.elim (![x0, x1, (0 : k)]) (![y0, y1, 0])) F = 0 ∧
        ∀ z : BiprojectiveCoordinate 2 2,
          eval (Sum.elim (![x0, x1, (0 : k)]) (![y0, y1, 0])) (pderiv z F) = 0 := by
    set z : BiprojectiveCoordinate 2 2 → k :=
      Sum.elim (![x0, x1, (0 : k)]) (![y0, y1, 0])
    have hraw := eval_pderiv_of_X2_mul_add_Y2_mul_on_X2Y2_zero A B x0 x1 y0 y1
    have hFval : eval z F = 0 := by
      have := hraw.1
      simpa [z, hFform] using this
    have hAeval : eval z (pderiv (Sum.inl 2) F) = eval z A := by
      have := hraw.2.2.2.1
      simpa [z, hFform] using this
    have hBeval : eval z (pderiv (Sum.inr 2) F) = eval z B := by
      have := hraw.2.2.2.2
      simpa [z, hFform] using this
    have hinl (i : Fin 3) (hi : i ≠ 2) : eval z (pderiv (Sum.inl i) F) = 0 := by
      have := hraw.2.1 i hi
      simpa [z, hFform] using this
    have hinr (j : Fin 3) (hj : j ≠ 2) : eval z (pderiv (Sum.inr j) F) = 0 := by
      have := hraw.2.2.1 j hj
      simpa [z, hFform] using this
    refine ⟨hFval, ?_⟩
    intro w
    match w with
    | Sum.inl i =>
        by_cases hi : i = 2
        · subst hi; exact hAeval.trans hA0
        · exact hinl i hi
    | Sum.inr j =>
        by_cases hj : j = 2
        · subst hj; exact hBeval.trans hB0
        · exact hinr j hj
  have hA_as_FX (x0 x1 y0 y1 : k) :
      eval (Sum.elim (![x0, x1, (0 : k)]) (![y0, y1, 0])) A =
        eval (Sum.elim (![x0, x1, (0 : k)]) (![y0, y1, 0])) FX := by
    have hraw := eval_pderiv_of_X2_mul_add_Y2_mul_on_X2Y2_zero A B x0 x1 y0 y1
    have := hraw.2.2.2.1
    simpa [hFform, FX, hFXd] using this.symm
  have hB_as_FY (x0 x1 y0 y1 : k) :
      eval (Sum.elim (![x0, x1, (0 : k)]) (![y0, y1, 0])) B =
        eval (Sum.elim (![x0, x1, (0 : k)]) (![y0, y1, 0])) FY := by
    have hraw := eval_pderiv_of_X2_mul_add_Y2_mul_on_X2Y2_zero A B x0 x1 y0 y1
    have := hraw.2.2.2.2
    simpa [hFform, FY, hFYd] using this.symm
  -- Case split on whether the free-X linear form of FX vanishes for some free Y
  have hvec2_ne (a b : k) (h : (![a, b] : Fin 2 → k) ≠ 0) :
      (![a, b, (0 : k)] : Fin 3 → k) ≠ 0 := by
    intro h3
    apply h
    funext i
    fin_cases i
    · exact congrFun h3 0
    · exact congrFun h3 1
  have hvec2_of_vec3 (x : Fin 2 → k) (h : (![x 0, x 1, (0 : k)] : Fin 3 → k) = 0) :
      x = 0 := by
    funext i
    fin_cases i
    · exact congrFun h 0
    · exact congrFun h 1
  by_cases hvan : ∃ y0 y1 : k, (![y0, y1] : Fin 2 → k) ≠ 0 ∧
      freeX_on_X2Y2_zero FX y0 y1 = 0
  · obtain ⟨y0, y1, hy, hlin0⟩ := hvan
    have hyvec := hvec2_ne y0 y1 hy
    by_cases hq0 : freeX_on_X2Y2_zero FY y0 y1 = 0
    · have hxne : (![1, 0, (0 : k)] : Fin 3 → k) ≠ 0 := by
        intro h; exact one_ne_zero (congrFun h 0)
      refine ⟨![1, 0, 0], ![y0, y1, 0], hxne, hyvec, rfl, rfl, ?_⟩
      apply hpoint 1 0 y0 y1
      · rw [hA_as_FX, ← eval_freeX_on_X2Y2_zero, hlin0, map_zero]
      · rw [hB_as_FY, ← eval_freeX_on_X2Y2_zero, hq0, map_zero]
    · have hquad_hom : (freeX_on_X2Y2_zero FY y0 y1).IsHomogeneous 2 :=
        isHomogeneous_freeX_on_X2Y2_zero FY hFYdeg y0 y1
      obtain ⟨xfree, hxfree, hquad⟩ :=
        exists_nonzero_zero_binary_homogeneous
          (freeX_on_X2Y2_zero FY y0 y1) (by norm_num) hquad_hom
      have hxfree_eq : xfree = ![xfree 0, xfree 1] := by
        funext i; fin_cases i <;> simp
      refine ⟨![xfree 0, xfree 1, 0], ![y0, y1, 0], ?_, hyvec, rfl, rfl, ?_⟩
      · intro hx; exact hxfree (hvec2_of_vec3 xfree hx)
      · apply hpoint (xfree 0) (xfree 1) y0 y1
        · rw [hA_as_FX, ← eval_freeX_on_X2Y2_zero, hlin0, map_zero]
        · rw [hB_as_FY, ← eval_freeX_on_X2Y2_zero, ← hxfree_eq]; exact hquad
  · -- Kernel section along nonzero linear forms of FX
    push Not at hvan
    set Aform := freeY_on_X2Y2_zero FX (1 : k) 0
    set Bform := freeY_on_X2Y2_zero FX (0 : k) 1
    have hAform_hom : Aform.IsHomogeneous 3 :=
      isHomogeneous_freeY_on_X2Y2_zero FX hFXdeg 1 0
    have hBform_hom : Bform.IsHomogeneous 3 :=
      isHomogeneous_freeY_on_X2Y2_zero FX hFXdeg 0 1
    set Gpoly : MvPolynomial (Fin 2) k :=
      aeval (Sum.elim ![Bform, -Aform, (0 : MvPolynomial (Fin 2) k)]
        ![X (0 : Fin 2), X 1, 0]) FY
    have hGhom : Gpoly.IsHomogeneous 8 := by
      have hW : FY.IsWeightedHomogeneous (scaledBidegreeWeight 2 2 3 1) 8 := by
        simpa using (hFYdeg.isWeightedHomogeneous_scaled (p := 3) (q := 1))
      refine hW.aeval_isHomogeneous
        (Sum.elim ![Bform, -Aform, (0 : MvPolynomial (Fin 2) k)]
          ![X (0 : Fin 2), X 1, 0]) ?_
      intro z
      match z with
      | Sum.inl i =>
          fin_cases i
          · change Bform.IsHomogeneous (scaledBidegreeWeight 2 2 3 1 (Sum.inl 0))
            simpa [scaledBidegreeWeight] using hBform_hom
          · change (-Aform).IsHomogeneous (scaledBidegreeWeight 2 2 3 1 (Sum.inl 1))
            simpa [scaledBidegreeWeight] using hAform_hom.neg
          · change (0 : MvPolynomial (Fin 2) k).IsHomogeneous
              (scaledBidegreeWeight 2 2 3 1 (Sum.inl 2))
            simpa [scaledBidegreeWeight] using
              (isHomogeneous_zero (R := k) (σ := Fin 2) 3)
      | Sum.inr j =>
          fin_cases j
          · change (X (0 : Fin 2)).IsHomogeneous (scaledBidegreeWeight 2 2 3 1 (Sum.inr 0))
            simpa [scaledBidegreeWeight] using isHomogeneous_X (R := k) (σ := Fin 2) 0
          · change (X (1 : Fin 2)).IsHomogeneous (scaledBidegreeWeight 2 2 3 1 (Sum.inr 1))
            simpa [scaledBidegreeWeight] using isHomogeneous_X (R := k) (σ := Fin 2) 1
          · change (0 : MvPolynomial (Fin 2) k).IsHomogeneous
              (scaledBidegreeWeight 2 2 3 1 (Sum.inr 2))
            simpa [scaledBidegreeWeight] using
              (isHomogeneous_zero (R := k) (σ := Fin 2) 1)
    have hG_eval (y0 y1 : k) :
        eval (![y0, y1]) Gpoly =
          eval (Sum.elim (![eval (![y0, y1]) Bform, -eval (![y0, y1]) Aform, (0 : k)])
            (![y0, y1, 0])) FY := by
      simp only [Gpoly, aeval_def]
      rw [eval_eval₂]
      have hg : (fun z : BiprojectiveCoordinate 2 2 =>
          eval (![y0, y1])
            (Sum.elim ![Bform, -Aform, (0 : MvPolynomial (Fin 2) k)]
              ![X (0 : Fin 2), X 1, 0] z)) =
          Sum.elim (![eval (![y0, y1]) Bform, -eval (![y0, y1]) Aform, (0 : k)])
            (![y0, y1, 0]) := by
        funext z
        match z with
        | Sum.inl i => fin_cases i <;> simp [eval_neg]
        | Sum.inr j => fin_cases j <;> simp [eval_X]
      have hf : (eval (![y0, y1])).comp (algebraMap k (MvPolynomial (Fin 2) k)) =
          RingHom.id k := by
        ext a; simp [eval_C, algebraMap_eq]
      simp only [hg, hf, eval₂_id]
    have hlin_coeff (y0 y1 x0 x1 : k) :
        eval (![x0, x1]) (freeX_on_X2Y2_zero FX y0 y1) =
          x0 * eval (![y0, y1]) Aform + x1 * eval (![y0, y1]) Bform := by
      have hlin := eval_left_degree_one_on_X2_zero FX hFXdeg x0 x1 y0 y1
      simpa [eval_freeX_on_X2Y2_zero, Aform, Bform, eval_freeY_on_X2Y2_zero] using hlin
    have hkernel_FX (y0 y1 : k) :
        eval (Sum.elim
            (![eval (![y0, y1]) Bform, -eval (![y0, y1]) Aform, (0 : k)])
            (![y0, y1, 0])) FX = 0 := by
      have hcoeff :=
        hlin_coeff y0 y1 (eval (![y0, y1]) Bform) (-eval (![y0, y1]) Aform)
      have hlin0 :
          eval (![eval (![y0, y1]) Bform, -eval (![y0, y1]) Aform])
            (freeX_on_X2Y2_zero FX y0 y1) = 0 := by
        rw [hcoeff]; ring
      simpa [eval_freeX_on_X2Y2_zero] using hlin0
    have hx_ne_of_y (y0 y1 : k) (hy : (![y0, y1] : Fin 2 → k) ≠ 0) :
        (![eval (![y0, y1]) Bform, -eval (![y0, y1]) Aform] : Fin 2 → k) ≠ 0 := by
      intro hx
      have hb : eval (![y0, y1]) Bform = 0 := congrFun hx 0
      have ha : eval (![y0, y1]) Aform = 0 := by
        have hx1 := congrFun hx 1
        exact neg_eq_zero.mp (by simpa using hx1)
      have hlin0 : freeX_on_X2Y2_zero FX y0 y1 = 0 := by
        refine MvPolynomial.funext fun t => ?_
        have ht : t = ![t 0, t 1] := by funext i; fin_cases i <;> simp
        have hval := hlin_coeff y0 y1 (t 0) (t 1)
        -- `![t 0, t 1]` is not defeq to arbitrary `t`; rewrite both sides carefully
        have hval' : eval t (freeX_on_X2Y2_zero FX y0 y1) =
            t 0 * eval ![y0, y1] Aform + t 1 * eval ![y0, y1] Bform := by
          rw [ht]; exact hval
        simp only [map_zero]
        rw [hval', ha, hb]
        ring
      exact hvan y0 y1 hy hlin0
    have hy10 : (![1, 0] : Fin 2 → k) ≠ 0 := by
      intro h; exact one_ne_zero (congrFun h 0)
    by_cases hG0 : Gpoly = 0
    · refine ⟨![eval (![1, 0]) Bform, -eval (![1, 0]) Aform, 0], ![1, 0, 0], ?_, ?_,
        rfl, rfl, ?_⟩
      · exact hvec2_ne _ _ (hx_ne_of_y 1 0 hy10)
      · exact hvec2_ne 1 0 hy10
      · apply hpoint (eval (![1, 0]) Bform) (-eval (![1, 0]) Aform) 1 0
        · rw [hA_as_FX]; exact hkernel_FX 1 0
        · rw [hB_as_FY]
          have := congrArg (eval (![1, 0])) hG0
          simpa [hG_eval] using this
    · obtain ⟨yfree, hyfree, hGval⟩ :=
        exists_nonzero_zero_binary_homogeneous Gpoly (by norm_num) hGhom
      set y0f := yfree 0
      set y1f := yfree 1
      have hyfree_eq : yfree = ![y0f, y1f] := by
        funext i; fin_cases i <;> simp [y0f, y1f]
      have hyfree2 : (![y0f, y1f] : Fin 2 → k) ≠ 0 := by
        intro hy
        apply hyfree
        rw [hyfree_eq, hy]
      refine ⟨![eval (![y0f, y1f]) Bform, -eval (![y0f, y1f]) Aform, 0], ![y0f, y1f, 0],
        ?_, ?_, rfl, rfl, ?_⟩
      · exact hvec2_ne _ _ (hx_ne_of_y y0f y1f hyfree2)
      · exact hvec2_ne y0f y1f hyfree2
      · apply hpoint (eval (![y0f, y1f]) Bform) (-eval (![y0f, y1f]) Aform) y0f y1f
        · rw [hA_as_FX]; exact hkernel_FX y0f y1f
        · rw [hB_as_FY]
          have hGv : eval (![y0f, y1f]) Gpoly = 0 := by
            simpa [← hyfree_eq] using hGval
          simpa [hG_eval] using hGv

/-- Free-direction form is nonzero on a smooth nonzero bidegree-`(2,3)` hypersurface. -/
theorem specializedConicFreeDirForm_ne_zero_of_smooth
    {k : Type u} [Field k] [IsAlgClosed k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (biprojectiveZeroLocusToSpec 2 2 k F)] :
    specializedConicFreeDirForm F ≠ 0 := by
  intro hα
  obtain ⟨x0, y0, hx0, hy0, _hx2, _hy2, hFval, hgrad⟩ :=
    exists_singular_point_on_X2Y2_zero_of_freeDirForm_eq_zero F hF hα
  obtain ⟨i, hxi⟩ := exists_normalizing_coordinate x0 hx0
  obtain ⟨j, hyj⟩ := exists_normalizing_coordinate y0 hy0
  set x := normalizeCoordinateRepresentative x0 i
  set y := normalizeCoordinateRepresentative y0 j
  have hxi1 : x i = 1 := normalizeCoordinateRepresentative_apply x0 i hxi
  have hyj1 : y j = 1 := normalizeCoordinateRepresentative_apply y0 j hyj
  have hFval' : eval (Sum.elim x y) F = 0 :=
    eval_normalize_blocks_eq_zero_of_isBidegree F hF x0 y0 i j hFval
  have hgrad' : ∀ z : BiprojectiveCoordinate 2 2,
      eval (Sum.elim x y) (pderiv z F) = 0 := by
    intro z
    match z with
    | Sum.inl a =>
        exact eval_normalize_blocks_eq_zero_of_isBidegree
          (pderiv (Sum.inl a) F) (hF.pderiv_inl (by norm_num) a) x0 y0 i j
          (hgrad (Sum.inl a))
    | Sum.inr a =>
        exact eval_normalize_blocks_eq_zero_of_isBidegree
          (pderiv (Sum.inr a) F) (hF.pderiv_inr (by norm_num) a) x0 y0 i j
          (hgrad (Sum.inr a))
  have hne : affineChartEquation 2 2 k i j F ≠ 0 :=
    affineChartEquation_ne_zero 2 2 k i j F hF hF0
  have hsing :=
    affineChartEquation_vanishing_and_gradient_eq_zero
      2 2 k i j x y hxi1 hyj1 F hFval' hgrad'
  exact (no_common_zero_affineChartEquation_and_pderiv_of_global_smooth
      2 2 k F hF i j hne (affineChartPoint i j x y)) ⟨hsing.1, hsing.2⟩

theorem residualImageXCoords_ne_zero_of_smooth
    {k : Type u} [Field k] [IsAlgClosed k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (biprojectiveZeroLocusToSpec 2 2 k F)]
    (v : Fin 3 → Polynomial k) (hv0 : v ≠ 0)
    (hv : TernaryQuadraticPoly.eval (coordinateLineTernaryQuadraticPoly F) v = 0) :
    residualImageXCoords F v ≠ 0 :=
  residualImageXCoords_ne_zero_of_freeDir F hF v hv0 hv
    (specializedConicFreeDirForm_ne_zero_of_smooth F hF hF0)

/-! ### Residual Y nonvanishing infrastructure for smooth equations -/

/-- Complementary direction vanishes when the cubic gradient does. -/
theorem complementaryTangentDir_eq_zero_of_tangentGradient_eq_zero
    {R : Type u} [CommRing R]
    (G : MvPolynomial (Fin 3) R) (p : Fin 3 → R)
    (hg : tangentGradient G p = 0) :
    complementaryTangentDir G p = 0 := by
  unfold complementaryTangentDir
  rw [hg]
  funext i
  fin_cases i <;> simp [cross3]

/-- On the normalized line point `p = (1,t,0)` with `G(p) = 0` and `1+t² ≠ 0`, vanishing of the
complementary direction forces the cubic gradient at `p` to vanish. -/
theorem tangentGradient_eq_zero_of_complementaryTangentDir_eq_zero
    {R : Type u} [CommRing R] [IsDomain R]
    (G : MvPolynomial (Fin 3) R) (hG : G.IsHomogeneous 3)
    (p : Fin 3 → R) (hp0 : p 0 = 1) (hp2 : p 2 = 0)
    (ht : 1 + p 1 ^ 2 ≠ 0) (hp : eval p G = 0)
    (hq : complementaryTangentDir G p = 0) :
    tangentGradient G p = 0 := by
  set g := tangentGradient G p
  set q := complementaryTangentDir G p
  have hq1 : q 1 = 0 := congrFun hq 1
  have hq2 : q 2 = 0 := congrFun hq 2
  have hg2 : g 2 = 0 := by
    have : -g 2 = 0 := by
      simpa [q, complementaryTangentDir, cross3, g, tangentGradient, hp0, hp2] using hq1
    exact neg_eq_zero.mp this
  have hrel : g 1 = p 1 * g 0 := by
    have : g 1 - p 1 * g 0 = 0 := by
      simpa [q, complementaryTangentDir, cross3, g, tangentGradient, hp0] using hq2
    exact eq_of_sub_eq_zero this
  have heuler : eval p (tangentForm G p) = 0 :=
    eval_tangentForm_self_eq_zero hG hp
  have hdot : g 0 * p 0 + g 1 * p 1 + g 2 * p 2 = 0 := by
    have h := heuler
    simpa [eval_tangentForm, g, tangentGradient, Fin.sum_univ_three, mul_comm] using h
  simp only [hp0, hp2, mul_one, mul_zero, add_zero, hg2] at hdot
  have hcomb : g 0 + (p 1 * g 0) * p 1 = 0 := by
    simpa [hrel] using hdot
  have hfac : g 0 * (1 + p 1 ^ 2) = 0 := by
    convert hcomb using 1
    ring
  have hg0 : g 0 = 0 := (mul_eq_zero.mp hfac).resolve_right ht
  have hg1 : g 1 = 0 := by simp [hrel, hg0]
  funext i
  fin_cases i
  · exact hg0
  · exact hg1
  · exact hg2

/-- Iff form combining the previous two lemmas (under the line-point normalization). -/
theorem complementaryTangentDir_eq_zero_iff_tangentGradient_eq_zero
    {R : Type u} [CommRing R] [IsDomain R]
    (G : MvPolynomial (Fin 3) R) (hG : G.IsHomogeneous 3)
    (p : Fin 3 → R) (hp0 : p 0 = 1) (hp2 : p 2 = 0)
    (ht : 1 + p 1 ^ 2 ≠ 0) (hp : eval p G = 0) :
    complementaryTangentDir G p = 0 ↔ tangentGradient G p = 0 :=
  ⟨tangentGradient_eq_zero_of_complementaryTangentDir_eq_zero G hG p hp0 hp2 ht hp,
    complementaryTangentDir_eq_zero_of_tangentGradient_eq_zero G p⟩

/-- Nonzero polynomial in the affine plane ring is nonvanishing at some `k`-point. -/
theorem exists_eval_ne_zero_affineTwoRing
    {k : Type u} [Field k] [Infinite k]
    (f : affineTwoRing k) (hf : f ≠ 0) :
    ∃ t s : k, eval (fun i : ULift (Fin 2) => if i.down = 0 then t else s) f ≠ 0 := by
  by_contra h
  push Not at h
  have hforall' : ∀ x : ULift (Fin 2) → k, eval x f = 0 := by
    intro x
    have hx :
        (fun i : ULift (Fin 2) => if i.down = 0 then x (ULift.up 0) else x (ULift.up 1)) = x := by
      funext i
      cases i with
      | up j =>
        fin_cases j <;> simp
    simpa [hx] using h (x (ULift.up 0)) (x (ULift.up 1))
  exact hf (MvPolynomial.funext fun x => by simpa using hforall' x)

/-- Evaluation homomorphism `k[t,s] → k` at a point `(t,s)`. -/
def evalAffineTwoPoint {k : Type u} [CommRing k] (t s : k) :
    affineTwoRing k →+* k :=
  eval (fun i : ULift (Fin 2) => if i.down = 0 then t else s)

theorem evalAffineTwoPoint_apply {k : Type u} [CommRing k] (t s : k)
    (f : affineTwoRing k) :
    evalAffineTwoPoint t s f =
      eval (fun i : ULift (Fin 2) => if i.down = 0 then t else s) f :=
  rfl


/-- Smooth packaging: residual X ≠ 0 is free; residual Y ≠ 0 and localized-point dominance remain.

Once those two inputs are supplied, residual-image unirationality follows from the rational-param
assembly. -/
theorem hasResidualImageUnirationalParametrization2_of_smooth_of_y_and_dominant
    {k : Type u} [Field k] [IsAlgClosed k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (biprojectiveZeroLocusToSpec 2 2 k F)]
    (v : Fin 3 → Polynomial k) (hv0 : v ≠ 0)
    (hv : TernaryQuadraticPoly.eval (coordinateLineTernaryQuadraticPoly F) v = 0)
    (hY : residualYCoords F v ≠ 0)
    (hdom :
      ∀ (i j : Fin 3) (hdenom : residualChartDenom F v i j ≠ 0),
        IsDominant (residualImagePointOfNormalizedLoc F hF v hv i j)) :
    HasResidualImageUnirationalParametrization2 F :=
  hasResidualImageUnirationalParametrization2_of_ne_zero_coords_and_dominant_point
    F hF v hv
    (residualImageXCoords_ne_zero_of_smooth F hF hF0 v hv0 hv)
    hY hdom

/-! ### Plane cubic containing a coordinate plane is divisible by the missing variable -/

/-- If a homogeneous ternary cubic vanishes on the plane `X₂ = 0`, it is divisible by `X₂`. -/
theorem eq_X2_mul_of_eval_on_X2_zero
    {R : Type u} [CommRing R] [IsDomain R] [Infinite R]
    (G : MvPolynomial (Fin 3) R) (hG : G.IsHomogeneous 3)
    (hvan : ∀ a b : R, eval ![a, b, (0 : R)] G = 0) :
    ∃ Q : MvPolynomial (Fin 3) R, G = X (2 : Fin 3) * Q := by
  -- G = X2 * (G.divMonomial single 2 1) + G.modMonomial
  -- free part (mod) has no X2 and evaluates to G on X2=0 plane, hence free part = 0
  classical
  set Q := G.divMonomial (Finsupp.single (2 : Fin 3) 1)
  set R0 := G.modMonomial (Finsupp.single (2 : Fin 3) 1)
  have hdecomp : X (2 : Fin 3) * Q + R0 = G := by
    simpa [Q, R0] using divMonomial_add_modMonomial_single G (2 : Fin 3)
  have hR0 : R0 = 0 := by
    refine MvPolynomial.funext fun z => ?_
    -- eval R0 at z = eval R0 at (z0,z1,0) = eval G at (z0,z1,0) = 0
    have hsup : ∀ m ∈ R0.support, m (2 : Fin 3) = 0 := by
      intro m hm
      by_contra hpos
      have hle : Finsupp.single (2 : Fin 3) 1 ≤ m := by
        intro i
        by_cases hi : i = 2
        · subst hi
          simpa [Finsupp.single_apply] using Nat.one_le_iff_ne_zero.mpr hpos
        · simp [Finsupp.single_apply, hi]
      have := coeff_modMonomial_of_le G hle
      exact absurd this (mem_support_iff.mp hm)
    have hagree : eval z R0 = eval ![z 0, z 1, (0 : R)] R0 := by
      rw [MvPolynomial.as_sum R0, map_sum, map_sum]
      refine Finset.sum_congr rfl fun m hm => ?_
      have hm2 : m 2 = 0 := hsup m hm
      simp only [eval_monomial]
      congr 1
      refine Finset.prod_congr rfl fun i hi => ?_
      fin_cases i <;> simp [hm2]
    have hG0 : eval ![z 0, z 1, (0 : R)] G = 0 := hvan (z 0) (z 1)
    have hmod : eval ![z 0, z 1, (0 : R)] R0 = eval ![z 0, z 1, (0 : R)] G := by
      have h := congrArg (eval ![z 0, z 1, (0 : R)]) hdecomp.symm
      simp only [eval_add, eval_mul, eval_X, Matrix.cons_val_two, Matrix.tail_cons,
        Matrix.head_cons, zero_mul, zero_add] at h
      exact h.symm
    rw [hagree, hmod, hG0]
    rfl
  refine ⟨Q, ?_⟩
  rw [← hdecomp, hR0, add_zero]


/-! ### Cross product and singular plane cubics containing a line -/

open Matrix

theorem cross3_eq_crossProduct {R : Type u} [CommRing R] (a b : Fin 3 → R) :
    cross3 a b = a ⨯₃ b := by
  funext i; fin_cases i <;> simp [cross3, cross_apply]

theorem cross3_ne_zero_of_linearIndependent {K : Type u} [Field K]
    (p q : Fin 3 → K) (hpq : LinearIndependent K ![p, q]) :
    cross3 p q ≠ 0 := by
  rw [cross3_eq_crossProduct, crossProduct_ne_zero_iff_linearIndependent]
  exact hpq

/-- Homogeneous cofactor version of `eq_X2_mul_of_eval_on_X2_zero`. -/
theorem eq_X2_mul_isHomogeneous_of_eval_on_X2_zero
    {R : Type u} [CommRing R] [IsDomain R] [Infinite R]
    (G : MvPolynomial (Fin 3) R) (hG : G.IsHomogeneous 3)
    (hvan : ∀ a b : R, eval ![a, b, (0 : R)] G = 0) :
    ∃ Q : MvPolynomial (Fin 3) R, Q.IsHomogeneous 2 ∧ G = X (2 : Fin 3) * Q := by
  obtain ⟨Q0, hGQ⟩ := eq_X2_mul_of_eval_on_X2_zero G hG hvan
  refine ⟨Q0, ?_, hGQ⟩
  intro d hd
  have hcoeff : coeff (Finsupp.single (2 : Fin 3) 1 + d) G = coeff d Q0 := by
    rw [hGQ, coeff_X_mul]
  have hne : coeff (Finsupp.single (2 : Fin 3) 1 + d) G ≠ 0 := by rwa [hcoeff]
  have hw := hG hne
  have hwt :
      (Finsupp.weight (1 : Fin 3 → ℕ)) (Finsupp.single (2 : Fin 3) 1 + d) =
        (Finsupp.weight (1 : Fin 3 → ℕ)) (Finsupp.single (2 : Fin 3) 1) +
          (Finsupp.weight (1 : Fin 3 → ℕ)) d := by
    exact (Finsupp.weight (1 : Fin 3 → ℕ)).map_add _ _
  have hs : (Finsupp.weight (1 : Fin 3 → ℕ)) (Finsupp.single (2 : Fin 3) 1) = 1 := by
    simp [Finsupp.weight_single]
  have : 1 + (Finsupp.weight (1 : Fin 3 → ℕ)) d = 3 := by
    rw [← hs, ← hwt, hw]
  omega

def frameApply {R : Type u} [CommRing R] (p q m c : Fin 3 → R) : Fin 3 → R :=
  fun i => c 0 * p i + c 1 * q i + c 2 * m i

def ternaryFramePullback {R : Type u} [CommRing R]
    (G : MvPolynomial (Fin 3) R) (p q m : Fin 3 → R) : MvPolynomial (Fin 3) R :=
  aeval (fun i => C (p i) * X 0 + C (q i) * X 1 + C (m i) * X 2) G

theorem eval_ternaryFramePullback {R : Type u} [CommRing R]
    (G : MvPolynomial (Fin 3) R) (p q m c : Fin 3 → R) :
    eval c (ternaryFramePullback G p q m) = eval (frameApply p q m c) G := by
  unfold ternaryFramePullback frameApply
  rw [aeval_def, eval_eval₂]
  have hf : (eval c).comp C = RingHom.id R := by ext; simp
  simp only [hf, eval₂_id, eval_add, eval_mul, eval_C, eval_X]
  congr 1
  funext i
  ring

theorem ternaryFramePullback_isHomogeneous {R : Type u} [CommRing R]
    {d : ℕ} (G : MvPolynomial (Fin 3) R) (hG : G.IsHomogeneous d)
    (p q m : Fin 3 → R) :
    (ternaryFramePullback G p q m).IsHomogeneous d := by
  unfold ternaryFramePullback
  simpa using hG.aeval
    (fun i => C (p i) * X (0 : Fin 3) + C (q i) * X 1 + C (m i) * X 2)
    (fun i =>
      ((isHomogeneous_C_mul_X (p i) (0 : Fin 3)).add
        (isHomogeneous_C_mul_X (q i) (1 : Fin 3))).add
        (isHomogeneous_C_mul_X (m i) (2 : Fin 3)))

theorem exists_third_basis_vector {K : Type u} [Field K]
    (p q : Fin 3 → K) (hpq : LinearIndependent K ![p, q]) :
    ∃ m : Fin 3 → K, LinearIndependent K ![p, q, m] := by
  have hlt :
      Module.finrank K (Submodule.span K (Set.range ![p, q])) <
        Module.finrank K (Fin 3 → K) := by
    rw [finrank_span_eq_card hpq, Module.finrank_fintype_fun_eq_card]
    decide
  obtain ⟨m, hm⟩ :=
    Submodule.exists_of_finrank_lt (Submodule.span K (Set.range ![p, q])) hlt
  have hm0 : m ∉ Submodule.span K (Set.range ![p, q]) := by
    simpa using hm (1 : K) one_ne_zero
  refine ⟨m, ?_⟩
  have h := hpq.finSnoc hm0
  have heq : Fin.snoc ![p, q] m = ![p, q, m] := by
    ext i; fin_cases i <;> rfl
  rwa [heq] at h

theorem frameApply_surjective {K : Type u} [Field K]
    (p q m : Fin 3 → K) (hli : LinearIndependent K ![p, q, m]) :
    Function.Surjective (frameApply p q m) := by
  have hcard : Fintype.card (Fin 3) = Module.finrank K (Fin 3 → K) := by
    rw [Module.finrank_fintype_fun_eq_card]
  let b := basisOfLinearIndependentOfCardEqFinrank hli hcard
  have hb : ⇑b = ![p, q, m] := coe_basisOfLinearIndependentOfCardEqFinrank hli hcard
  intro v
  refine ⟨b.repr v, ?_⟩
  funext i
  have hv : v = ∑ j, b.repr v j • b j := by
    simpa using (Basis.sum_repr b v).symm
  simp only [frameApply]
  have hcomp : b.repr v 0 * p i + b.repr v 1 * q i + b.repr v 2 * m i =
      b.repr v 0 * b 0 i + b.repr v 1 * b 1 i + b.repr v 2 * b 2 i := by
    simp [hb]
  rw [hcomp]
  have hsum :
      b.repr v 0 * b 0 i + b.repr v 1 * b 1 i + b.repr v 2 * b 2 i =
        (∑ j : Fin 3, b.repr v j • b j) i := by
    simp [Fin.sum_univ_three, Pi.smul_apply, smul_eq_mul, add_assoc]
  rw [hsum, ← hv]

private theorem eval_mul_X2_partials {R : Type u} [CommRing R]
    (Q : MvPolynomial (Fin 3) R) (a b : R) :
    eval ![a, b, (0 : R)] (X (2 : Fin 3) * Q) = 0 ∧
      eval ![a, b, (0 : R)] (pderiv 0 (X (2 : Fin 3) * Q)) = 0 ∧
        eval ![a, b, (0 : R)] (pderiv 1 (X (2 : Fin 3) * Q)) = 0 ∧
          eval ![a, b, (0 : R)] (pderiv 2 (X (2 : Fin 3) * Q)) =
            eval ![a, b, (0 : R)] Q := by
  refine ⟨?_, ?_, ?_, ?_⟩
  · simp [eval_mul, eval_X]
  · rw [Derivation.leibniz, pderiv_X]
    simp [Pi.single_apply, eval_add, eval_mul, eval_X, smul_eq_mul]
  · rw [Derivation.leibniz, pderiv_X]
    simp [Pi.single_apply, eval_add, eval_mul, eval_X, smul_eq_mul]
  · rw [Derivation.leibniz, pderiv_X]
    simp [Pi.single_apply, eval_add, eval_mul, eval_X, smul_eq_mul]

theorem directional_deriv_eq_sum_pderiv {R : Type u} [CommRing R]
    (G : MvPolynomial (Fin 3) R) (r w : Fin 3 → R) :
    Polynomial.coeff
        (aeval (fun i : Fin 3 => Polynomial.C (r i) + Polynomial.C (w i) * Polynomial.X) G) 1 =
      ∑ i : Fin 3, w i * eval r (pderiv i G) :=
  coeff_one_line_eval G w r

/-- A homogeneous plane cubic that vanishes on a projective line is singular. -/
theorem exists_singular_point_of_binaryLineRestriction_eq_zero
    {K : Type u} [Field K] [IsAlgClosed K]
    (G : MvPolynomial (Fin 3) K) (hG : G.IsHomogeneous 3)
    (p q : Fin 3 → K) (hpq : LinearIndependent K ![p, q])
    (hf : binaryLineRestriction p q G = 0) :
    ∃ r : Fin 3 → K, r ≠ 0 ∧ eval r G = 0 ∧ ∀ i : Fin 3, eval r (pderiv i G) = 0 := by
  classical
  haveI : Infinite K := inferInstance
  by_cases hG0 : G = 0
  · exact ⟨![1, 0, 0], fun h => one_ne_zero (congrFun h 0), by simp [hG0],
      fun _ => by simp [hG0]⟩
  obtain ⟨m, hli3⟩ := exists_third_basis_vector p q hpq
  set G' := ternaryFramePullback G p q m
  have hG' : G'.IsHomogeneous 3 := ternaryFramePullback_isHomogeneous G hG p q m
  have hvan : ∀ a b : K, eval ![a, b, (0 : K)] G' = 0 := by
    intro a b
    have hfr : frameApply p q m ![a, b, 0] = fun i => a * p i + b * q i := by
      funext i; simp [frameApply]
    rw [eval_ternaryFramePullback, hfr]
    have h := congrArg (eval ![a, b]) hf
    -- eval_binaryLineRestriction uses p*a + q*b
    have hcomm : (fun i => a * p i + b * q i) = fun i => p i * a + q i * b := by
      funext i; ring
    rw [hcomm]
    simpa [eval_binaryLineRestriction] using h
  obtain ⟨Q, hQhom, hGQ⟩ := eq_X2_mul_isHomogeneous_of_eval_on_X2_zero G' hG' hvan
  set Qbin : MvPolynomial (Fin 2) K :=
    aeval ![X (0 : Fin 2), X 1, (0 : MvPolynomial (Fin 2) K)] Q
  have hQbin_eval (a b : K) : eval ![a, b] Qbin = eval ![a, b, (0 : K)] Q := by
    have h1 : eval ![a, b] Qbin =
        eval ![a, b]
          (eval₂ C ![X (0 : Fin 2), X 1, (0 : MvPolynomial (Fin 2) K)] Q) := rfl
    rw [h1, eval_eval₂]
    have hf' : (eval ![a, b]).comp C = RingHom.id K := by ext; simp
    have hg :
        (fun i : Fin 3 =>
          eval ![a, b] (![X (0 : Fin 2), X 1, (0 : MvPolynomial (Fin 2) K)] i)) =
          (![a, b, (0 : K)] : Fin 3 → K) := by
      funext i; fin_cases i <;> simp
    rw [hg, hf', eval₂_id]
  have hQbin_hom : Qbin.IsHomogeneous 2 := by
    have h0 : (X (0 : Fin 2) : MvPolynomial (Fin 2) K).IsHomogeneous 1 :=
      isHomogeneous_X (R := K) (σ := Fin 2) 0
    have h1X : (X (1 : Fin 2) : MvPolynomial (Fin 2) K).IsHomogeneous 1 :=
      isHomogeneous_X (R := K) (σ := Fin 2) 1
    have h2 : (0 : MvPolynomial (Fin 2) K).IsHomogeneous 1 :=
      isHomogeneous_zero (R := K) (σ := Fin 2) 1
    have h := hQhom.aeval ![X (0 : Fin 2), X 1, (0 : MvPolynomial (Fin 2) K)]
      (fun i => by fin_cases i <;> [exact h0; exact h1X; exact h2])
    simpa [Qbin] using h
  obtain ⟨ab, hab0, hQab⟩ : ∃ ab : Fin 2 → K, ab ≠ 0 ∧ eval ab Qbin = 0 := by
    by_cases hQb0 : Qbin = 0
    · exact ⟨![1, 0], fun h => one_ne_zero (congrFun h 0), by simp [hQb0]⟩
    · exact exists_nonzero_zero_binary_homogeneous Qbin (by norm_num) hQbin_hom
  set a := ab 0
  set b := ab 1
  have hab_ne : (![a, b] : Fin 2 → K) ≠ 0 := by
    intro h
    apply hab0
    funext i
    fin_cases i
    · exact congrFun h 0
    · exact congrFun h 1
  have hQ0 : eval ![a, b, (0 : K)] Q = 0 := by
    have hab_eq : ab = ![a, b] := by funext i; fin_cases i <;> simp [a, b]
    have h1 : eval ![a, b] Qbin = 0 := by simpa [hab_eq] using hQab
    rwa [← hQbin_eval a b]
  set r' : Fin 3 → K := ![a, b, 0]
  have hmulparts := eval_mul_X2_partials (R := K) Q a b
  have hX2Q0 : eval ![a, b, (0 : K)] (X (2 : Fin 3) * Q) = 0 := hmulparts.1
  have hX2Qp0 : eval ![a, b, (0 : K)] (pderiv 0 (X (2 : Fin 3) * Q)) = 0 :=
    hmulparts.2.1
  have hX2Qp1 : eval ![a, b, (0 : K)] (pderiv 1 (X (2 : Fin 3) * Q)) = 0 :=
    hmulparts.2.2.1
  have hX2Qp2 : eval ![a, b, (0 : K)] (pderiv 2 (X (2 : Fin 3) * Q)) =
      eval ![a, b, (0 : K)] Q := hmulparts.2.2.2
  have hG'r : eval r' G' = 0 := by
    change eval ![a, b, (0 : K)] G' = 0
    rw [hGQ, hX2Q0]
  have hp0G : eval r' (pderiv 0 G') = 0 := by
    change eval ![a, b, (0 : K)] (pderiv 0 G') = 0
    rw [hGQ, hX2Qp0]
  have hp1G : eval r' (pderiv 1 G') = 0 := by
    change eval ![a, b, (0 : K)] (pderiv 1 G') = 0
    rw [hGQ, hX2Qp1]
  have hp2G : eval r' (pderiv 2 G') = 0 := by
    change eval ![a, b, (0 : K)] (pderiv 2 G') = 0
    rw [hGQ, hX2Qp2, hQ0]
  have hpG' : ∀ i : Fin 3, eval r' (pderiv i G') = 0 := by
    intro i; fin_cases i
    · exact hp0G
    · exact hp1G
    · exact hp2G
  set r := frameApply p q m r'
  have hr_ne : r ≠ 0 := by
    intro hr0
    have hlin : a • p + b • q = 0 := by
      funext i
      have := congrFun hr0 i
      simp only [r, r', frameApply, Pi.zero_apply] at this
      simpa [smul_eq_mul] using this
    obtain ⟨ha, hb⟩ := LinearIndependent.pair_iff.mp hpq a b hlin
    exact hab_ne (by funext i; fin_cases i <;> simp [ha, hb])
  have hrG : eval r G = 0 := by
    have := eval_ternaryFramePullback G p q m r'
    simpa [r, G', hG'r] using this.symm
  -- Gradient transport: for each basis direction eⱼ = frame(δ),
  -- ∂ⱼG(r) = directional derivative of G' along δ at r' = 0.
  refine ⟨r, hr_ne, hrG, ?_⟩
  intro j
  set ej : Fin 3 → K := Pi.single j (1 : K)
  obtain ⟨δ, hδ⟩ := frameApply_surjective p q m hli3 ej
  -- Chain rule along the line r + T•ej = frame(r' + T•δ):
  -- both directional derivatives equal the T-coefficient of the same univariate poly.
  have hline :
      aeval (fun i => Polynomial.C (r i) + Polynomial.C (ej i) * Polynomial.X) G =
        aeval (fun i => Polynomial.C (r' i) + Polynomial.C (δ i) * Polynomial.X)
          (ternaryFramePullback G p q m) := by
    have hsub (i : Fin 3) :
        Polynomial.C (r i) + Polynomial.C (ej i) * Polynomial.X =
          aeval (fun k => Polynomial.C (r' k) + Polynomial.C (δ k) * Polynomial.X)
            (C (p i) * X 0 + C (q i) * X 1 + C (m i) * X 2) := by
      have hri : r i = r' 0 * p i + r' 1 * q i + r' 2 * m i := by
        simp [r, r', frameApply]
      have hei : ej i = δ 0 * p i + δ 1 * q i + δ 2 * m i := by
        have := congrFun hδ i
        simpa [frameApply] using this.symm
      have hrhs :
          aeval (fun k => Polynomial.C (r' k) + Polynomial.C (δ k) * Polynomial.X)
              (C (p i) * X 0 + C (q i) * X 1 + C (m i) * X 2) =
            Polynomial.C (p i) * (Polynomial.C (r' 0) + Polynomial.C (δ 0) * Polynomial.X) +
              Polynomial.C (q i) * (Polynomial.C (r' 1) + Polynomial.C (δ 1) * Polynomial.X) +
                Polynomial.C (m i) * (Polynomial.C (r' 2) + Polynomial.C (δ 2) * Polynomial.X) := by
        simp [aeval_def, eval₂_add, eval₂_mul, eval₂_C, eval₂_X]
      rw [hrhs, hri, hei]
      simp only [map_add, map_mul]
      ring
    -- Isolate the identity so induction does not generalize outer hypotheses on G
    suffices hgen :
        ∀ G0 : MvPolynomial (Fin 3) K,
          aeval (fun i => Polynomial.C (r i) + Polynomial.C (ej i) * Polynomial.X) G0 =
            aeval (fun i => Polynomial.C (r' i) + Polynomial.C (δ i) * Polynomial.X)
              (ternaryFramePullback G0 p q m) by
      exact hgen G
    intro G0
    induction G0 using MvPolynomial.induction_on with
    | C c => simp [ternaryFramePullback, aeval_C]
    | add f g ihf ihg =>
        simp only [ternaryFramePullback, map_add, ihf, ihg]
    | mul_X f i ih =>
        simp only [ternaryFramePullback, map_mul, aeval_X, ih, hsub i]
  have hdir_G :
      Polynomial.coeff
          (aeval (fun i => Polynomial.C (r i) + Polynomial.C (ej i) * Polynomial.X) G) 1 =
        eval r (pderiv j G) := by
    have hsum :
        ∑ i : Fin 3, ej i * eval r (pderiv i G) = eval r (pderiv j G) := by
      classical
      simp [ej, Pi.single_apply, Finset.sum_ite_eq']
    rw [directional_deriv_eq_sum_pderiv, hsum]
  have hdir_G' :
      Polynomial.coeff
          (aeval (fun i => Polynomial.C (r' i) + Polynomial.C (δ i) * Polynomial.X) G') 1 =
        0 := by
    have hsum :
        ∑ i : Fin 3, δ i * eval r' (pderiv i G') = 0 :=
      Finset.sum_eq_zero fun i _ => by rw [hpG' i, mul_zero]
    rw [directional_deriv_eq_sum_pderiv, hsum]
  have : eval r (pderiv j G) = 0 := by
    rw [← hdir_G, hline, show ternaryFramePullback G p q m = G' from rfl, hdir_G']
  exact this

end

end BConicBundleMultisections
