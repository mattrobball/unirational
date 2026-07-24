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


/-! ### Residual Y nonvanishing for smooth equations -/

theorem map_binaryLineRestriction
    {R S : Type u} [CommRing R] [CommRing S] (phi : R →+* S) {sigma : Type*}
    (p q : sigma → R) (G : MvPolynomial sigma R) :
    map phi (binaryLineRestriction p q G) =
      binaryLineRestriction (phi ∘ p) (phi ∘ q) (map phi G) := by
  simp only [binaryLineRestriction]
  let eR : sigma → MvPolynomial (Fin 2) R := fun i => C (p i) * X 0 + C (q i) * X 1
  let eS : sigma → MvPolynomial (Fin 2) S :=
    fun i => C ((phi ∘ p) i) * X 0 + C ((phi ∘ q) i) * X 1
  change map phi (aeval eR G) = aeval eS (map phi G)
  have hmap :
      map phi (eval₂ C eR G) = eval₂ C (map phi ∘ eR) (map phi G) :=
    map_eval₂ phi eR G
  have he : map phi ∘ eR = eS := by
    funext i
    simp [eR, eS, map_add, map_mul, map_C, map_X, Function.comp_apply]
  have hR : aeval eR G = eval₂ C eR G := rfl
  have hS : aeval eS (map phi G) = eval₂ C eS (map phi G) := rfl
  rw [hR, hmap, he, hS]

theorem map_complementaryTangentDir
    {R S : Type u} [CommRing R] [CommRing S] (phi : R →+* S)
    (G : MvPolynomial (Fin 3) R) (p : Fin 3 → R) :
    phi ∘ complementaryTangentDir G p =
      complementaryTangentDir (map phi G) (phi ∘ p) := by
  funext i
  simp only [Function.comp_apply, complementaryTangentDir, cross3, tangentGradient]
  have hmap (j : Fin 3) :
      phi (eval p (pderiv j G)) = eval (phi ∘ p) (pderiv j (map phi G)) := by
    calc
      phi (eval p (pderiv j G)) = eval₂ phi (phi ∘ p) (pderiv j G) :=
        eval₂_comp phi p (pderiv j G)
      _ = eval (phi ∘ p) (map phi (pderiv j G)) := (eval_map phi (phi ∘ p) (pderiv j G)).symm
      _ = eval (phi ∘ p) (pderiv j (map phi G)) := by rw [← pderiv_map]
  fin_cases i <;> simp [map_sub, map_mul, hmap]

/-- A nonsingular plane cubic cannot contain a projective line. -/
theorem binaryLineRestriction_ne_zero_of_nonsingular
    {K : Type u} [Field K] [IsAlgClosed K]
    (G : MvPolynomial (Fin 3) K) (hG : G.IsHomogeneous 3)
    (hns : ∀ r : Fin 3 → K, r ≠ 0 → eval r G = 0 →
      ∃ i : Fin 3, eval r (pderiv i G) ≠ 0)
    (p q : Fin 3 → K) (hpq : LinearIndependent K ![p, q]) :
    binaryLineRestriction p q G ≠ 0 := by
  intro hf
  obtain ⟨r, hr0, hrG, hrgrad⟩ :=
    exists_singular_point_of_binaryLineRestriction_eq_zero G hG p q hpq hf
  obtain ⟨i, hi⟩ := hns r hr0 hrG
  exact hi (hrgrad i)

/-- If some stereo specialization has a nonsingular cubic fiber with independent residual
line endpoints, residual Y-coordinates are nonzero. -/
theorem residualYCoords_ne_zero_of_exists_nonsingular_stereo
    {k : Type u} [Field k] [IsAlgClosed k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (v : Fin 3 → Polynomial k)
    (hv : TernaryQuadraticPoly.eval (coordinateLineTernaryQuadraticPoly F) v = 0)
    (hns : ∃ t s : k,
      let x := residualImageXCoords F v
      let p := affineTwoCoordinateLineY k
      let G := cubicFiberPullback F x
      let q := complementaryTangentDir G p
      let phi := evalAffineTwoPoint t s
      let Gs := map phi G
      let ps := phi ∘ p
      let qs := complementaryTangentDir Gs ps
      Gs.IsHomogeneous 3 ∧
        (∀ r : Fin 3 → k, r ≠ 0 → eval r Gs = 0 →
          ∃ i : Fin 3, eval r (pderiv i Gs) ≠ 0) ∧
          LinearIndependent k ![ps, qs]) :
    residualYCoords F v ≠ 0 := by
  classical
  refine residualYCoords_ne_zero_of_binaryLineRestriction_ne_zero F hF v hv ?_
  change
    binaryLineRestriction (affineTwoCoordinateLineY k)
        (complementaryTangentDir (cubicFiberPullback F (residualImageXCoords F v))
          (affineTwoCoordinateLineY k))
        (cubicFiberPullback F (residualImageXCoords F v)) ≠ 0
  intro hf
  set x := residualImageXCoords F v
  set p := affineTwoCoordinateLineY k
  set G := cubicFiberPullback F x
  set q := complementaryTangentDir G p
  have hf0 : binaryLineRestriction p q G = 0 := by
    simpa [x, p, G, q] using hf
  obtain ⟨t, s, hGhom, hnsG, hpq⟩ := hns
  set phi := evalAffineTwoPoint t s
  set Gs := map phi G
  set ps := phi ∘ p
  set qs := complementaryTangentDir Gs ps
  have hqs : qs = phi ∘ q := by
    simpa [qs, ps, Gs, q] using (map_complementaryTangentDir phi G p).symm
  have hmapf :
      map phi (binaryLineRestriction p q G) =
        binaryLineRestriction ps (phi ∘ q) Gs := by
    simpa [ps, Gs] using map_binaryLineRestriction phi p q G
  have hfs : binaryLineRestriction ps qs Gs = 0 := by
    rw [hqs, ← hmapf, hf0, map_zero]
  exact (binaryLineRestriction_ne_zero_of_nonsingular Gs hGhom hnsG ps qs hpq) hfs

theorem map_specializeFirstCoordinates
    {k : Type u} [CommRing k]
    (x : Fin 3 → affineTwoRing k) (phi : affineTwoRing k →+* k)
    (H : MvPolynomial (BiprojectiveCoordinate 2 2) (affineTwoRing k)) :
    map phi (specializeFirstCoordinates (n := 2) x H) =
      specializeFirstCoordinates (n := 2) (fun i => phi (x i)) (map phi H) := by
  induction H using MvPolynomial.induction_on with
  | C c => simp [map_C]
  | add f g hf hg => simp [map_add, hf, hg]
  | mul_X f i hf =>
      cases i with
      | inl j => simp [map_mul, map_C, map_X, hf, specializeFirstCoordinates_X_inl]
      | inr j => simp [map_mul, map_X, hf, specializeFirstCoordinates_X_inr]

theorem map_cubicFiberPullback_eq_specializeFirst
    {k : Type u} [CommRing k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (x : Fin 3 → affineTwoRing k) (t s : k) :
    map (evalAffineTwoPoint t s) (cubicFiberPullback F x) =
      specializeFirstCoordinates (n := 2)
        (fun i => evalAffineTwoPoint t s (x i)) F := by
  set phi := evalAffineTwoPoint t s
  unfold cubicFiberPullback affineTwoPullback
  have hcomm : map phi (map (C : k →+* affineTwoRing k) F) = F := by
    rw [MvPolynomial.map_map]
    have : phi.comp (C : k →+* affineTwoRing k) = RingHom.id k := by
      ext; simp [phi, evalAffineTwoPoint, eval_C]
    rw [this]
    exact map_id F
  rw [map_specializeFirstCoordinates x phi, hcomm]

/-- Stereo cubic fiber is nonzero under smoothness. -/
theorem cubicFiberPullback_stereo_ne_zero_of_smooth
    {k : Type u} [Field k] [IsAlgClosed k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (biprojectiveZeroLocusToSpec 2 2 k F)]
    (v : Fin 3 → Polynomial k) (hv0 : v ≠ 0)
    (hv : TernaryQuadraticPoly.eval (coordinateLineTernaryQuadraticPoly F) v = 0) :
    cubicFiberPullback F (residualImageXCoords F v) ≠ 0 := by
  classical
  set x := residualImageXCoords F v
  set G := cubicFiberPullback F x
  intro hG0
  have hXne := residualImageXCoords_ne_zero_of_smooth F hF hF0 v hv0 hv
  obtain ⟨iX, hiX⟩ : ∃ i, x i ≠ 0 := by
    by_contra h; push Not at h; exact hXne (funext h)
  haveI : Infinite k := inferInstance
  obtain ⟨t, s, hts⟩ := exists_eval_ne_zero_affineTwoRing (x iX) hiX
  set phi := evalAffineTwoPoint t s
  set xs : Fin 3 → k := fun i => phi (x i)
  have hxs_ne : xs ≠ 0 := by
    intro h
    exact hts (by simpa [phi, evalAffineTwoPoint, xs] using congrFun h iX)
  have hxsF0 : specializeFirstCoordinates (n := 2) xs F = 0 := by
    have hspec := map_cubicFiberPullback_eq_specializeFirst F x t s
    simpa [G, hG0, xs, phi] using hspec.symm
  obtain ⟨ix, hix⟩ := exists_normalizing_coordinate xs hxs_ne
  set xn := normalizeCoordinateRepresentative xs ix
  have hxn1 : xn ix = 1 := normalizeCoordinateRepresentative_apply xs ix hix
  have hsmul :=
    IsBihomogeneousOfBidegree.specializeFirstCoordinates_smul hF (xs ix)⁻¹ xs
  have hxnG : specializeFirstCoordinates (n := 2) xn F = 0 := by
    have hxndef : xn = (xs ix)⁻¹ • xs := rfl
    rw [hxndef, hsmul, hxsF0, mul_zero]
  exact (not_specializeFirstCoordinates_eq_zero_of_smooth_bidegree23
    k F hF hF0 ix xn hxn1) hxnG

/-- On the normalized line point with nonsingular gradient, residual endpoints are lin-ind. -/
theorem linearIndependent_linePoint_complementary
    {K : Type u} [Field K]
    (G : MvPolynomial (Fin 3) K) (hG : G.IsHomogeneous 3)
    (p : Fin 3 → K) (hp0 : p 0 = 1) (hp2 : p 2 = 0)
    (ht : 1 + p 1 ^ 2 ≠ 0) (hp : eval p G = 0)
    (hgrad : tangentGradient G p ≠ 0) :
    LinearIndependent K ![p, complementaryTangentDir G p] := by
  rw [LinearIndependent.pair_iff]
  intro a b hab
  by_cases hb : b = 0
  · have : a • p = 0 := by simpa [hb] using hab
    have ha : a = 0 := (smul_eq_zero.mp this).resolve_right fun hpz =>
      (one_ne_zero : (1 : K) ≠ 0) (by simpa [hp0] using congrFun hpz 0)
    exact ⟨ha, hb⟩
  · have hbq : b • complementaryTangentDir G p = -(a • p) := by
      have := hab
      rw [add_comm] at this
      exact eq_neg_of_add_eq_zero_left this
    have hlam :
        complementaryTangentDir G p = (-(a * b⁻¹)) • p := by
      calc
        complementaryTangentDir G p
            = (1 : K) • complementaryTangentDir G p := (one_smul K _).symm
        _ = (b⁻¹ * b) • complementaryTangentDir G p := by rw [inv_mul_cancel₀ hb]
        _ = b⁻¹ • (b • complementaryTangentDir G p) := by rw [mul_smul]
        _ = b⁻¹ • (-(a • p)) := by rw [hbq]
        _ = -((b⁻¹ * a) • p) := by simp [smul_neg, smul_smul]
        _ = (-(a * b⁻¹)) • p := by
          have hcomm : (b⁻¹ * a : K) = a * b⁻¹ := mul_comm _ _
          simp only [neg_smul, hcomm]
    have hdot : ∑ i : Fin 3, p i * complementaryTangentDir G p i = 0 := by
      simp [complementaryTangentDir, cross3, Fin.sum_univ_three, tangentGradient]
      ring
    have hnorm : ∑ i : Fin 3, p i ^ 2 = 1 + p 1 ^ 2 := by
      simp [Fin.sum_univ_three, hp0, hp2, pow_two]
    have hlam0 : a * b⁻¹ = 0 := by
      have : (-(a * b⁻¹)) * (∑ i : Fin 3, p i ^ 2) = 0 := by
        have h := hdot
        simp only [hlam, Pi.smul_apply, smul_eq_mul] at h
        convert h using 1
        simp [Finset.mul_sum, pow_two, mul_comm, mul_left_comm, mul_assoc]
      rw [neg_mul, neg_eq_zero] at this
      exact (mul_eq_zero.mp this).resolve_right (by simpa [hnorm] using ht)
    have hq0 : complementaryTangentDir G p = 0 := by simp [hlam, hlam0]
    exact absurd
      ((complementaryTangentDir_eq_zero_iff_tangentGradient_eq_zero
        G hG p hp0 hp2 ht hp).mp hq0) hgrad

/-- Residual-ready stereo specialization: nonzero gradient and lin-ind residual endpoints. -/
theorem exists_residualStereo_ready_specialization
    {k : Type u} [Field k] [IsAlgClosed k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (biprojectiveZeroLocusToSpec 2 2 k F)]
    (v : Fin 3 → Polynomial k) (hv0 : v ≠ 0)
    (hv : TernaryQuadraticPoly.eval (coordinateLineTernaryQuadraticPoly F) v = 0)
    (hgrad : tangentGradient (cubicFiberPullback F (residualImageXCoords F v))
      (affineTwoCoordinateLineY k) ≠ 0) :
    ∃ t s : k,
      let x := residualImageXCoords F v
      let p := affineTwoCoordinateLineY k
      let G := cubicFiberPullback F x
      let phi := evalAffineTwoPoint t s
      let Gs := map phi G
      let ps := phi ∘ p
      Gs.IsHomogeneous 3 ∧
        eval ps Gs = 0 ∧
          ps 0 = 1 ∧ ps 2 = 0 ∧ 1 + ps 1 ^ 2 ≠ 0 ∧
            tangentGradient Gs ps ≠ 0 ∧
              LinearIndependent k ![ps, complementaryTangentDir Gs ps] := by
  classical
  set x := residualImageXCoords F v
  set p := affineTwoCoordinateLineY k
  set G := cubicFiberPullback F x
  have hGhom : G.IsHomogeneous 3 := cubicFiberPullback_isHomogeneous F hF x
  have hpG : eval p G = 0 := by
    simpa [x, G, residualImageXCoords] using
      eval_cubicFiber_coordinateLine_of_stereo F hF v hv
  have hXne := residualImageXCoords_ne_zero_of_smooth F hF hF0 v hv0 hv
  obtain ⟨jX, hjX⟩ : ∃ j, x j ≠ 0 := by
    by_contra h; push Not at h; exact hXne (funext h)
  obtain ⟨jG, hjG⟩ : ∃ j, eval p (pderiv j G) ≠ 0 := by
    by_contra h; push Not at h; exact hgrad (funext h)
  have h1t : (1 + affineTwoCoord0 k ^ 2 : affineTwoRing k) ≠ 0 :=
    one_add_affineTwoCoord0_sq_ne_zero k
  set w : affineTwoRing k := x jX * eval p (pderiv jG G) * (1 + affineTwoCoord0 k ^ 2)
  have hw : w ≠ 0 := mul_ne_zero (mul_ne_zero hjX hjG) h1t
  haveI : Infinite k := inferInstance
  obtain ⟨t, s, hts⟩ := exists_eval_ne_zero_affineTwoRing w hw
  set phi := evalAffineTwoPoint t s
  set Gs := map phi G
  set ps := phi ∘ p
  have hGshom : Gs.IsHomogeneous 3 := hGhom.map _
  have hps0 : ps 0 = 1 := by
    simp [ps, phi, evalAffineTwoPoint, p, affineTwoCoordinateLineY]
  have hps2 : ps 2 = 0 := by
    simp [ps, phi, evalAffineTwoPoint, p, affineTwoCoordinateLineY]
  have htps : 1 + ps 1 ^ 2 ≠ 0 := by
    intro h
    have hphi : phi (1 + affineTwoCoord0 k ^ 2) = 1 + t ^ 2 := by
      simp [phi, evalAffineTwoPoint, affineTwoCoord0]
    have hps1 : ps 1 = t := by
      simp [ps, phi, evalAffineTwoPoint, p, affineTwoCoordinateLineY, affineTwoCoord0]
    have : phi (1 + affineTwoCoord0 k ^ 2) = 0 := by simpa [hphi, hps1] using h
    have : phi w = 0 := by simp [w, map_mul, this]
    exact hts (by simpa [phi, evalAffineTwoPoint] using this)
  have hgrad_s : tangentGradient Gs ps ≠ 0 := by
    intro hg0
    have hmapj : phi (eval p (pderiv jG G)) = eval ps (pderiv jG Gs) := by
      have hpd : pderiv jG Gs = map phi (pderiv jG G) := by
        simpa [Gs] using pderiv_map (φ := phi) (f := G) (i := jG)
      calc
        phi (eval p (pderiv jG G)) = eval₂ phi (phi ∘ p) (pderiv jG G) :=
          eval₂_comp phi p (pderiv jG G)
        _ = eval ps (map phi (pderiv jG G)) := by simp [ps, eval_map]
        _ = eval ps (pderiv jG Gs) := by rw [← hpd]
    have hz : eval ps (pderiv jG Gs) = 0 := by
      simpa [tangentGradient] using congrFun hg0 jG
    have : phi (eval p (pderiv jG G)) = 0 := hmapj.trans hz
    have : phi w = 0 := by simp [w, map_mul, this, mul_zero, zero_mul]
    exact hts (by simpa [phi, evalAffineTwoPoint] using this)
  have hpsG : eval ps Gs = 0 := by
    have hcmp : eval ps Gs = phi (eval p G) := by
      calc
        eval ps Gs = eval₂ phi (phi ∘ p) G := by simp [ps, Gs, eval_map]
        _ = phi (eval p G) := (eval₂_comp phi p G).symm
    simpa [hcmp, hpG]
  have hpq : LinearIndependent k ![ps, complementaryTangentDir Gs ps] :=
    linearIndependent_linePoint_complementary Gs hGshom ps hps0 hps2 htps hpsG hgrad_s
  exact ⟨t, s, hGshom, hpsG, hps0, hps2, htps, hgrad_s, hpq⟩

/-! ### No whole `P² × {y}` slices for smooth equations -/

/-- If `F` vanishes for every first-block point at a fixed second-block point, the second
specialization is the zero polynomial. -/
theorem specializeSecondCoordinates_eq_zero_of_eval_elim_eq_zero
    {k : Type u} [Field k] [Infinite k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (y : Fin 3 → k)
    (hvan : ∀ x : Fin 3 → k, eval (Sum.elim x y) F = 0) :
    specializeSecondCoordinates (m := 2) y F = 0 := by
  refine MvPolynomial.funext fun x => ?_
  simpa [eval_specializeSecondCoordinates] using hvan x

/-- If `F` vanishes for every second-block point at a fixed first-block point, the first
specialization is the zero polynomial. -/
theorem specializeFirstCoordinates_eq_zero_of_eval_elim_eq_zero
    {k : Type u} [Field k] [Infinite k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (x : Fin 3 → k)
    (hvan : ∀ y : Fin 3 → k, eval (Sum.elim x y) F = 0) :
    specializeFirstCoordinates (n := 2) x F = 0 := by
  refine MvPolynomial.funext fun y => ?_
  simpa [eval_specializeFirstCoordinates] using hvan y

/-- Smooth nonzero bidegree-`(2,3)` equations cannot vanish on a whole slice
`{(x, y) | x arbitrary}` for fixed nonzero `y`. -/
theorem not_eval_elim_eq_zero_for_all_x_of_smooth_bidegree23
    {k : Type u} [Field k] [IsAlgClosed k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (biprojectiveZeroLocusToSpec 2 2 k F)]
    (y : Fin 3 → k) (hy0 : y ≠ 0) :
    ¬ (∀ x : Fin 3 → k, eval (Sum.elim x y) F = 0) := by
  intro hvan
  obtain ⟨j, hyj⟩ := exists_normalizing_coordinate y hy0
  set yn := normalizeCoordinateRepresentative y j
  have hyj1 : yn j = 1 := normalizeCoordinateRepresentative_apply y j hyj
  have hspec_y : specializeSecondCoordinates (m := 2) y F = 0 :=
    specializeSecondCoordinates_eq_zero_of_eval_elim_eq_zero F y hvan
  have hspec0 : specializeSecondCoordinates (m := 2) yn F = 0 := by
    have hyn : yn = (y j)⁻¹ • y := rfl
    rw [hyn, hF.specializeSecondCoordinates_smul, hspec_y, mul_zero]
  exact (not_specializeSecondCoordinates_eq_zero_of_smooth_bidegree23
      k F hF hF0 j yn hyj1) hspec0

/-- Smooth nonzero bidegree-`(2,3)` equations cannot vanish on a whole slice
`{(x, y) | y arbitrary}` for fixed nonzero `x`. -/
theorem not_eval_elim_eq_zero_for_all_y_of_smooth_bidegree23
    {k : Type u} [Field k] [IsAlgClosed k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (biprojectiveZeroLocusToSpec 2 2 k F)]
    (x : Fin 3 → k) (hx0 : x ≠ 0) :
    ¬ (∀ y : Fin 3 → k, eval (Sum.elim x y) F = 0) := by
  intro hvan
  obtain ⟨i, hxi⟩ := exists_normalizing_coordinate x hx0
  set xn := normalizeCoordinateRepresentative x i
  have hxi1 : xn i = 1 := normalizeCoordinateRepresentative_apply x i hxi
  have hspec_x : specializeFirstCoordinates (n := 2) x F = 0 :=
    specializeFirstCoordinates_eq_zero_of_eval_elim_eq_zero F x hvan
  have hspec0 : specializeFirstCoordinates (n := 2) xn F = 0 := by
    have hxn : xn = (x i)⁻¹ • x := rfl
    rw [hxn, hF.specializeFirstCoordinates_smul, hspec_x, mul_zero]
  exact (not_specializeFirstCoordinates_eq_zero_of_smooth_bidegree23
      k F hF hF0 i xn hxi1) hspec0

/-- In particular `Y₂` cannot divide a smooth nonzero bidegree-`(2,3)` equation: otherwise `F`
would vanish on the whole slice `Y₂ = 0`. -/
theorem not_dvd_X_inr_two_of_smooth_bidegree23
    {k : Type u} [Field k] [IsAlgClosed k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (biprojectiveZeroLocusToSpec 2 2 k F)] :
    ¬ X (Sum.inr (2 : Fin 3)) ∣ F := by
  intro hdiv
  obtain ⟨B, hFB⟩ := hdiv
  set y0 : Fin 3 → k := ![1, 0, 0]
  have hy0 : y0 ≠ 0 := fun h => one_ne_zero (congrFun h 0)
  have hvan : ∀ x : Fin 3 → k, eval (Sum.elim x y0) F = 0 := by
    intro x
    simp [hFB, eval_mul, eval_X, y0]
  exact (not_eval_elim_eq_zero_for_all_x_of_smooth_bidegree23 F hF hF0 y0 hy0) hvan

/-- Symmetric statement: `X₂` cannot divide a smooth nonzero bidegree-`(2,3)` equation. -/
theorem not_dvd_X_inl_two_of_smooth_bidegree23
    {k : Type u} [Field k] [IsAlgClosed k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (biprojectiveZeroLocusToSpec 2 2 k F)] :
    ¬ X (Sum.inl (2 : Fin 3)) ∣ F := by
  intro hdiv
  obtain ⟨B, hFB⟩ := hdiv
  set x0 : Fin 3 → k := ![1, 0, 0]
  have hx0 : x0 ≠ 0 := fun h => one_ne_zero (congrFun h 0)
  have hvan : ∀ y : Fin 3 → k, eval (Sum.elim x0 y) F = 0 := by
    intro y
    simp [hFB, eval_mul, eval_X, x0]
  exact (not_eval_elim_eq_zero_for_all_y_of_smooth_bidegree23 F hF hF0 x0 hx0) hvan


/-! ### Residual-line-equals-L branch infrastructure -/

/-- Complementary `q₂` on the normalized line point `p = (1,t,0)`. -/
theorem complementaryTangentDir_two
    {R : Type u} [CommRing R]
    (G : MvPolynomial (Fin 3) R) (p : Fin 3 → R)
    (hp0 : p 0 = 1) (_hp2 : p 2 = 0) :
    complementaryTangentDir G p 2 =
      eval p (pderiv 1 G) - p 1 * eval p (pderiv 0 G) := by
  simp [complementaryTangentDir, cross3, tangentGradient, hp0]

/-- If `q₂ = 0` on the normalized line point with `1+t² ≠ 0` and `G(p)=0`, then
`∂₀G(p) = ∂₁G(p) = 0`. -/
theorem tangentGradient_vertical_of_complementary_two_eq_zero
    {R : Type u} [CommRing R] [IsDomain R]
    (G : MvPolynomial (Fin 3) R) (hG : G.IsHomogeneous 3)
    (p : Fin 3 → R) (hp0 : p 0 = 1) (hp2 : p 2 = 0)
    (ht : 1 + p 1 ^ 2 ≠ 0) (hp : eval p G = 0)
    (hq2 : complementaryTangentDir G p 2 = 0) :
    eval p (pderiv 0 G) = 0 ∧ eval p (pderiv 1 G) = 0 := by
  have hq2' : eval p (pderiv 1 G) - p 1 * eval p (pderiv 0 G) = 0 := by
    rwa [complementaryTangentDir_two G p hp0 hp2] at hq2
  have hrel : eval p (pderiv 1 G) = p 1 * eval p (pderiv 0 G) :=
    eq_of_sub_eq_zero hq2'
  have heuler : eval p (tangentForm G p) = 0 :=
    eval_tangentForm_self_eq_zero hG hp
  have hdot :
      eval p (pderiv 0 G) * p 0 + eval p (pderiv 1 G) * p 1 +
        eval p (pderiv 2 G) * p 2 = 0 := by
    simpa [eval_tangentForm, Fin.sum_univ_three, mul_comm] using heuler
  simp only [hp0, hp2, mul_one, mul_zero, add_zero] at hdot
  have hcomb :
      eval p (pderiv 0 G) + (p 1 * eval p (pderiv 0 G)) * p 1 = 0 := by
    simpa [hrel] using hdot
  have hfac : eval p (pderiv 0 G) * (1 + p 1 ^ 2) = 0 := by
    convert hcomb using 1; ring
  have hg0 : eval p (pderiv 0 G) = 0 :=
    (mul_eq_zero.mp hfac).resolve_right ht
  have hg1 : eval p (pderiv 1 G) = 0 := by simp [hrel, hg0]
  exact ⟨hg0, hg1⟩

/-- Binary restriction to the standard frame of `L = {Y₂ = 0}` vanishes implies `G` vanishes
on `L`. -/
theorem eval_on_L_eq_zero_of_binaryLineRestriction_e0e1_eq_zero
    {R : Type u} [CommRing R]
    (G : MvPolynomial (Fin 3) R)
    (hf : binaryLineRestriction (![1, 0, (0 : R)]) (![0, 1, (0 : R)]) G = 0) :
    ∀ a b : R, eval ![a, b, (0 : R)] G = 0 := by
  intro a b
  have h := congrArg (eval ![a, b]) hf
  have hpt :
      (fun i : Fin 3 =>
        (![1, 0, (0 : R)] : Fin 3 → R) i * a +
          (![0, 1, (0 : R)] : Fin 3 → R) i * b) =
        ![a, b, (0 : R)] := by
    funext i
    fin_cases i <;> simp [mul_comm]
  simpa [eval_binaryLineRestriction, hpt] using h

/-- If residual `q₂ = 0` and `∂₂G(p) ≠ 0`, residual direction spans `L` with `p`, so residual
binary restriction zero forces `G` to vanish on `L`. -/
theorem eval_on_L_eq_zero_of_residual_binary_eq_zero_of_q_two_grad2_ne
    {K : Type u} [Field K]
    (G : MvPolynomial (Fin 3) K) (_hG : G.IsHomogeneous 3)
    (p : Fin 3 → K) (hp0 : p 0 = 1) (hp2 : p 2 = 0)
    (ht : 1 + p 1 ^ 2 ≠ 0) (_hp : eval p G = 0)
    (hq2 : complementaryTangentDir G p 2 = 0)
    (hg2 : eval p (pderiv 2 G) ≠ 0)
    (hf : binaryLineRestriction p (complementaryTangentDir G p) G = 0) :
    ∀ a b : K, eval ![a, b, (0 : K)] G = 0 := by
  classical
  set q := complementaryTangentDir G p
  set t := p 1
  set g2 := eval p (pderiv 2 G)
  have hq0 : q 0 = t * g2 := by
    simp [q, complementaryTangentDir, cross3, tangentGradient, hp2, t, g2]
  have hq1 : q 1 = -g2 := by
    simp [q, complementaryTangentDir, cross3, tangentGradient, hp0, hp2, g2]
  set vL : Fin 3 → K := ![t, -1, 0]
  have hq_smul : q = g2 • vL := by
    funext i
    fin_cases i
    · simp [hq0, vL, t, Pi.smul_apply, smul_eq_mul]; ring
    · simp [hq1, vL, Pi.smul_apply, smul_eq_mul]
    · simp [hq2, vL, Pi.smul_apply, smul_eq_mul]
  intro a b
  set α : K := (a + b * t) * (1 + t ^ 2)⁻¹
  set β : K := α * t - b
  have hspan : (fun i : Fin 3 => α * p i + β * vL i) = ![a, b, (0 : K)] := by
    funext i
    fin_cases i
    · have hinv : (1 + t ^ 2)⁻¹ * (1 + t ^ 2) = 1 := inv_mul_cancel₀ ht
      calc
        α * p 0 + β * vL 0 = α + β * t := by simp [hp0, vL, t]
        _ = α + (α * t - b) * t := by simp [β]
        _ = α * (1 + t ^ 2) - b * t := by ring
        _ = (a + b * t) * ((1 + t ^ 2)⁻¹ * (1 + t ^ 2)) - b * t := by
          simp only [α]; ring
        _ = a + b * t - b * t := by rw [hinv]; ring
        _ = a := by ring
    · -- α * p 1 + β * (-1) = α * t - (α * t - b) = b
      change α * p 1 + β * (-1) = b
      have hp1 : p 1 = t := rfl
      have hβ : β = α * t - b := rfl
      rw [hp1, hβ]
      ring
    · simp [hp2, vL]
  have hline : eval (fun i => α * p i + (β * g2⁻¹) * q i) G = 0 := by
    have h := congrArg (eval ![α, β * g2⁻¹]) hf
    have hcomm :
        (fun i => p i * α + q i * (β * g2⁻¹)) =
          fun i => α * p i + (β * g2⁻¹) * q i := by
      funext i; ring
    simpa [eval_binaryLineRestriction, hcomm] using h
  have hpt : (fun i => α * p i + β * vL i) =
      fun i => α * p i + (β * g2⁻¹) * q i := by
    funext i
    have hv : vL i = g2⁻¹ * q i := by
      have := congrFun hq_smul i
      simp only [Pi.smul_apply, smul_eq_mul] at this
      calc
        vL i = g2⁻¹ * (g2 * vL i) := by
          rw [← mul_assoc, inv_mul_cancel₀ hg2, one_mul]
        _ = g2⁻¹ * q i := by rw [← this]
    rw [hv]; ring
  rw [← hspan, hpt]
  exact hline

/-- Stereo cubic vanishing on `L` is divisible by `Y₂`. -/
theorem cubicFiberPullback_stereo_eq_X2_mul_of_eval_on_L
    {k : Type u} [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (v : Fin 3 → Polynomial k)
    (hvan : ∀ a b : affineTwoRing k,
      eval ![a, b, (0 : affineTwoRing k)]
        (cubicFiberPullback F (residualImageXCoords F v)) = 0) :
    ∃ Q : MvPolynomial (Fin 3) (affineTwoRing k),
      cubicFiberPullback F (residualImageXCoords F v) =
        X (2 : Fin 3) * Q := by
  haveI : Infinite (affineTwoRing k) := inferInstance
  haveI : IsDomain (affineTwoRing k) := inferInstance
  exact eq_X2_mul_of_eval_on_X2_zero
    (cubicFiberPullback F (residualImageXCoords F v))
    (cubicFiberPullback_isHomogeneous F hF _) hvan

/-- Specializing the second block at `(1,0,0)` of a smooth bidegree-`(2,3)` equation is a
nonzero plane conic (otherwise `F` vanishes on the slice `y = (1,0,0)`). -/
theorem specializeSecond_e0_ne_zero_of_smooth_bidegree23
    {k : Type u} [Field k] [IsAlgClosed k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (biprojectiveZeroLocusToSpec 2 2 k F)] :
    specializeSecondCoordinates (m := 2) (![1, 0, (0 : k)]) F ≠ 0 := by
  intro h0
  set y0 : Fin 3 → k := ![1, 0, 0]
  have hy0 : y0 ≠ 0 := fun h => one_ne_zero (congrFun h 0)
  have hvan : ∀ x : Fin 3 → k, eval (Sum.elim x y0) F = 0 := by
    intro x
    rw [← eval_specializeSecondCoordinates, h0, map_zero]
  exact (not_eval_elim_eq_zero_for_all_x_of_smooth_bidegree23 F hF hF0 y0 hy0) hvan

/-- Same for `y = (0,1,0)`. -/
theorem specializeSecond_e1_ne_zero_of_smooth_bidegree23
    {k : Type u} [Field k] [IsAlgClosed k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (biprojectiveZeroLocusToSpec 2 2 k F)] :
    specializeSecondCoordinates (m := 2) (![0, 1, (0 : k)]) F ≠ 0 := by
  intro h0
  set y0 : Fin 3 → k := ![0, 1, 0]
  have hy0 : y0 ≠ 0 := fun h => one_ne_zero (congrFun h 1)
  have hvan : ∀ x : Fin 3 → k, eval (Sum.elim x y0) F = 0 := by
    intro x
    rw [← eval_specializeSecondCoordinates, h0, map_zero]
  exact (not_eval_elim_eq_zero_for_all_x_of_smooth_bidegree23 F hF hF0 y0 hy0) hvan



/-! ### Specialized conic pencil non-constancy -/

/-- Univariate polynomial `T ↦ F(z, T, 1, 0)`. -/
noncomputable def evalF_Y0_poly
    {k : Type u} [CommRing k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (z : Fin 3 → k) : Polynomial k :=
  aeval (Sum.elim (fun i => Polynomial.C (z i)) ![Polynomial.X, 1, 0])
    (map (Polynomial.C : k →+* Polynomial k) F)

theorem eval_evalF_Y0_poly
    {k : Type u} [CommRing k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (z : Fin 3 → k) (s : k) :
    Polynomial.eval s (evalF_Y0_poly F z) =
      eval (Sum.elim z ![s, 1, (0 : k)]) F := by
  unfold evalF_Y0_poly
  -- General fact: eval s (aeval g (map C F)) = eval (eval s ∘ g) F
  have hgen :
      ∀ (G : MvPolynomial (BiprojectiveCoordinate 2 2) k)
        (g : BiprojectiveCoordinate 2 2 → Polynomial k),
        Polynomial.eval s (aeval g (map (Polynomial.C : k →+* Polynomial k) G)) =
          eval (fun i => Polynomial.eval s (g i)) G := by
    intro G g
    induction G using MvPolynomial.induction_on with
    | C a =>
        simp only [map_C, aeval_C, eval_C]
        -- algebraMap R R = id under Algebra.id
        simp [Algebra.algebraMap_self_apply, Polynomial.eval_C]
    | add f1 f2 ih1 ih2 =>
        simp only [map_add, ih1, ih2, Polynomial.eval_add, eval_add]
    | mul_X f i ih =>
        simp only [map_mul, map_X, ih, aeval_X, Polynomial.eval_mul, eval_mul, eval_X]
  have h := hgen F (Sum.elim (fun i => Polynomial.C (z i)) ![Polynomial.X, 1, 0])
  rw [h]
  apply congrArg (fun v => eval v F)
  funext i
  cases i with
  | inl j => simp
  | inr j => fin_cases j <;> simp

/-- If specialized conics do not depend on the line parameter, `F` vanishes on `y=(0,1,0)`. -/
theorem not_coordinateLineSpecializedConic_eq_const_of_smooth
    {k : Type u} [Field k] [IsAlgClosed k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (biprojectiveZeroLocusToSpec 2 2 k F)] :
    ¬ (∀ t₁ t₂ : k,
        coordinateLineSpecializedConic F t₁ = coordinateLineSpecializedConic F t₂) := by
  intro hconst
  have hEq : ∀ t : k,
      coordinateLineSpecializedConic F t = coordinateLineSpecializedConic F 0 :=
    fun t => hconst t 0
  have hF_t_indep : ∀ (t : k) (z : Fin 3 → k),
      eval (Sum.elim z (coordinateLinePoint k t)) F =
        eval (Sum.elim z (coordinateLinePoint k 0)) F := by
    intro t z
    have ht :
        eval z (coordinateLineSpecializedConic F t) =
          eval (Sum.elim z (coordinateLinePoint k t)) F := by
      simp [coordinateLineSpecializedConic, eval_specializeSecondCoordinates]
    have h0 :
        eval z (coordinateLineSpecializedConic F 0) =
          eval (Sum.elim z (coordinateLinePoint k 0)) F := by
      simp [coordinateLineSpecializedConic, eval_specializeSecondCoordinates]
    rw [← ht, ← h0, hEq t]
  have hy_smul :
      ∀ (z : Fin 3 → k) (r : k) (y : Fin 3 → k),
        eval (Sum.elim z (r • y)) F = r ^ 3 * eval (Sum.elim z y) F := by
    intro z r y
    have h := hF.isWeightedHomogeneous_right.eval₂_weight_smul
      (RingHom.id k) (Sum.elim z y) r
    have hdef :
        (fun c : BiprojectiveCoordinate 2 2 =>
          r ^ rightDegreeWeight c * Sum.elim z y c) =
          Sum.elim z (r • y) := by
      funext c
      match c with
      | Sum.inl i => simp [rightDegreeWeight, Pi.smul_apply]
      | Sum.inr j => simp [rightDegreeWeight, Pi.smul_apply, smul_eq_mul, pow_one]
    simpa [hdef] using h
  have hvan : ∀ z : Fin 3 → k, eval (Sum.elim z (![0, 1, (0 : k)])) F = 0 := by
    intro z
    set val0 := eval (Sum.elim z (coordinateLinePoint k 0)) F
    have hε : ∀ ε : k, ε ≠ 0 →
        eval (Sum.elim z ![ε, 1, (0 : k)]) F = ε ^ 3 * val0 := by
      intro ε hε
      have hsmul := hy_smul z ε ![1, ε⁻¹, 0]
      have hy : ε • (![1, ε⁻¹, (0 : k)] : Fin 3 → k) = ![ε, 1, 0] := by
        funext j
        fin_cases j <;> simp [Pi.smul_apply, smul_eq_mul, mul_inv_cancel₀ hε]
      rw [hy] at hsmul
      have hindep := hF_t_indep ε⁻¹ z
      have hpt : coordinateLinePoint k ε⁻¹ = ![1, ε⁻¹, 0] := by
        simp [coordinateLinePoint]
      calc
        eval (Sum.elim z ![ε, 1, (0 : k)]) F =
            ε ^ 3 * eval (Sum.elim z ![1, ε⁻¹, (0 : k)]) F := hsmul
        _ = ε ^ 3 * eval (Sum.elim z (coordinateLinePoint k 0)) F := by
          rw [← hpt, hindep]
        _ = ε ^ 3 * val0 := rfl
    classical
    set qT : Polynomial k :=
      evalF_Y0_poly F z - Polynomial.X ^ 3 * Polynomial.C val0
    have hqT_ne0 : ∀ ε : k, ε ≠ 0 → Polynomial.eval ε qT = 0 := by
      intro ε hε0
      simp only [qT, Polynomial.eval_sub, eval_evalF_Y0_poly, Polynomial.eval_mul,
        Polynomial.eval_pow, Polynomial.eval_X, Polynomial.eval_C]
      rw [hε ε hε0, sub_self]
    have hqT0 : qT = 0 := by
      by_contra hqne
      haveI : Infinite k := inferInstance
      have hroots_all : ∀ ε : k, ε ≠ 0 → ε ∈ qT.roots := by
        intro ε hε0
        exact (Polynomial.mem_roots hqne).mpr (hqT_ne0 ε hε0)
      have hfin : (qT.roots.toFinset : Set k).Finite := qT.roots.toFinset.finite_toSet
      have hInf : Set.Infinite {ε : k | ε ≠ 0} := by
        have hcompl : {ε : k | ε ≠ 0}ᶜ = ({0} : Set k) := by
          ext ε; simp
        have : ({ε : k | ε ≠ 0}ᶜ).Finite := by
          rw [hcompl]; exact Set.finite_singleton 0
        exact Set.infinite_of_finite_compl this
      have hsub : {ε : k | ε ≠ 0} ⊆ (qT.roots.toFinset : Set k) := by
        intro ε hε0
        exact Multiset.mem_toFinset.mpr (hroots_all ε hε0)
      exact hInf.not_finite (hfin.subset hsub)
    have := congrArg (Polynomial.eval 0) hqT0
    simpa [qT, eval_evalF_Y0_poly, zero_pow (by decide : (3 : ℕ) ≠ 0), zero_mul,
      sub_zero, Polynomial.eval_sub, Polynomial.eval_mul, Polynomial.eval_pow,
      Polynomial.eval_X, Polynomial.eval_C] using this
  exact (not_eval_elim_eq_zero_for_all_x_of_smooth_bidegree23 F hF hF0
      (![0, 1, (0 : k)]) (fun h => one_ne_zero (congrFun h 1))) hvan

/-! ### Stereo denseness support -/

/-- `stereoAlg` agrees with the quadratic-form stereo second-intersection. -/
theorem stereoSecondIntersection_eq_stereoAlg
    {K : Type u} [Field K]
    (f : MvPolynomial (Fin 3) K) (hf : f.IsHomogeneous 2)
    (p w : Fin 3 → K) :
    stereoSecondIntersection f hf p w = stereoAlg f p w := by
  funext i
  dsimp [stereoSecondIntersection, conicParametrization, stereoAlg, polarEval]
  simp only [ternaryQuadraticForm_apply, QuadraticMap.polar]
  rfl

/-- Evaluate a base-field form after affine-plane coordinates, then specialize the plane. -/
theorem eval_evalAffineTwoPoint_of_map_C
    {k : Type u} [CommRing k]
    (t s : k) (H : MvPolynomial (Fin 3) k) (z : Fin 3 → affineTwoRing k) :
    evalAffineTwoPoint t s (eval z (map (C : k →+* affineTwoRing k) H)) =
      eval (fun i => evalAffineTwoPoint t s (z i)) H := by
  induction H using MvPolynomial.induction_on with
  | C a => simp [map_C, eval_C, evalAffineTwoPoint]
  | add f1 f2 ih1 ih2 => rw [map_add, eval_add, map_add, eval_add, ih1, ih2]
  | mul_X f i ih => rw [map_mul, map_X, eval_mul, eval_X, map_mul, eval_mul, eval_X, ih]

theorem eval_evalAffineTwoPoint_residualImageXCoords
    {k : Type u} [CommRing k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (v : Fin 3 → Polynomial k) (t s : k)
    (H : MvPolynomial (Fin 3) k) :
    evalAffineTwoPoint t s
        (eval (residualImageXCoords F v) (map (C : k →+* affineTwoRing k) H)) =
      eval (fun i => evalAffineTwoPoint t s (residualImageXCoords F v i)) H :=
  eval_evalAffineTwoPoint_of_map_C t s H (residualImageXCoords F v)

/-- Map of `specializeSecondCoordinates` under a coefficient ring hom. -/
theorem map_specializeSecondCoordinates
    {k : Type u} [CommRing k]
    (y : Fin 3 → affineTwoRing k) (phi : affineTwoRing k →+* k)
    (H : MvPolynomial (BiprojectiveCoordinate 2 2) (affineTwoRing k)) :
    map phi (specializeSecondCoordinates (m := 2) y H) =
      specializeSecondCoordinates (m := 2) (fun i => phi (y i)) (map phi H) := by
  induction H using MvPolynomial.induction_on with
  | C c => simp [map_C]
  | add f g hf hg => simp [map_add, hf, hg]
  | mul_X f i hf =>
      cases i with
      | inl j => simp [map_mul, map_X, hf, specializeSecondCoordinates_X_inl]
      | inr j => simp [map_mul, map_C, map_X, hf, specializeSecondCoordinates_X_inr]

/-- Specialize the specialized-conic pullback along the affine plane at `(t, _)`. -/
theorem map_evalAffineTwoPoint_specializedConicPullback
    {k : Type u} [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (t s : k) :
    map (evalAffineTwoPoint t s) (specializedConicPullback F) =
      coordinateLineSpecializedConic F t := by
  have hline :
      (fun j : Fin 3 => evalAffineTwoPoint t s (affineTwoCoordinateLineY k j)) =
        coordinateLinePoint k t := by
    funext j
    fin_cases j <;>
      simp [affineTwoCoordinateLineY, affineTwoCoord0, evalAffineTwoPoint,
        coordinateLinePoint, eval_X]
  have hcomm : map (evalAffineTwoPoint t s) (affineTwoPullback F) = F := by
    unfold affineTwoPullback
    rw [MvPolynomial.map_map]
    have : (evalAffineTwoPoint t s).comp (C : k →+* affineTwoRing k) = RingHom.id k := by
      ext a; simp [evalAffineTwoPoint, eval_C]
    rw [this]
    exact map_id F
  simp only [specializedConicPullback, coordinateLineSpecializedConic]
  rw [map_specializeSecondCoordinates, hcomm, hline]

/-- `liftPolyT` specializes under `evalAffineTwoPoint` to univariate evaluation at `t`. -/
theorem evalAffineTwoPoint_liftPolyT
    {k : Type u} [CommRing k] (p : Polynomial k) (t s : k) :
    evalAffineTwoPoint t s (liftPolyT p) = Polynomial.eval t p := by
  simp only [liftPolyT, affineTwoCoord0]
  rw [Polynomial.hom_eval₂ (f := (C : k →+* affineTwoRing k))
    (g := evalAffineTwoPoint t s) (x := X (ULift.up (0 : Fin 2))) (p := p)]
  have hC : (evalAffineTwoPoint t s).comp (C : k →+* affineTwoRing k) = RingHom.id k := by
    ext a; simp [evalAffineTwoPoint, eval_C]
  have hx : evalAffineTwoPoint t s (X (ULift.up (0 : Fin 2))) = t := by
    simp [evalAffineTwoPoint, eval_X]
  rw [hC, hx, Polynomial.eval₂_id]

/-- Coefficient ring-hom acts componentwise on `stereoAlg`. -/
theorem map_stereoAlg
    {R S : Type u} [CommRing R] [CommRing S] (phi : R →+* S)
    (Q : MvPolynomial (Fin 3) R) (p w : Fin 3 → R) :
    (fun i => phi (stereoAlg Q p w i)) =
      stereoAlg (map phi Q) (fun j => phi (p j)) (fun j => phi (w j)) := by
  funext i
  have heval (z : Fin 3 → R) :
      phi (eval z Q) = eval (fun j => phi (z j)) (map phi Q) := by
    rw [eval_map]
    convert eval₂_comp phi z Q
    rfl
  dsimp [stereoAlg, polarEval]
  simp only [map_sub, map_mul, heval, map_add]

/-- Plane specialization of residual stereo coordinates is ring-level stereo of the specialized conic. -/
theorem evalAffineTwoPoint_residualImageXCoords_eq_stereoAlg
    {k : Type u} [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (v : Fin 3 → Polynomial k) (t s : k) :
    (fun i => evalAffineTwoPoint t s (residualImageXCoords F v i)) =
      stereoAlg (coordinateLineSpecializedConic F t)
        (evalPolySection v t) (stereographicDirection s) := by
  set phi := evalAffineTwoPoint t s
  set Q := specializedConicPullback F
  set p := liftTsenSection (k := k) v
  set w := affineTwoStereoDir (k := k)
  have hmap := map_stereoAlg phi Q p w
  have hp : (fun j => phi (p j)) = evalPolySection v t := by
    funext j
    simp only [p, liftTsenSection, evalPolySection, phi]
    exact evalAffineTwoPoint_liftPolyT (v j) t s
  have hw : (fun j => phi (w j)) = stereographicDirection s := by
    funext j
    fin_cases j <;>
      simp [w, affineTwoStereoDir, affineTwoCoord1, phi, evalAffineTwoPoint,
        stereographicDirection, eval_X]
  have hQ : map phi Q = coordinateLineSpecializedConic F t := by
    dsimp [phi, Q]
    exact map_evalAffineTwoPoint_specializedConicPullback F t s
  calc
    (fun i => phi (residualImageXCoords F v i))
        = (fun i => phi (stereoAlg Q p w i)) := by
          funext i; simp only [residualImageXCoords, stereoFirstCoords, Q, p, w]
    _ = stereoAlg (map phi Q) (fun j => phi (p j)) (fun j => phi (w j)) := hmap
    _ = stereoAlg (coordinateLineSpecializedConic F t)
          (evalPolySection v t) (stereographicDirection s) := by
          rw [hQ, hp, hw]

/-- Same specialization equals the classical `coordinateLineStereoParam`. -/
theorem evalAffineTwoPoint_residualImageXCoords_eq_coordinateLineStereoParam
    {k : Type u} [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (v : Fin 3 → Polynomial k) (t s : k) :
    (fun i => evalAffineTwoPoint t s (residualImageXCoords F v i)) =
      coordinateLineStereoParam F hF v t s := by
  rw [evalAffineTwoPoint_residualImageXCoords_eq_stereoAlg F v t s,
    coordinateLineStereoParam, stereoSecondIntersection_eq_stereoAlg]

/-- If residual stereo vanishes a base-field form as an affine-plane polynomial, every classical
stereo specialization vanishes that form. -/
theorem eval_coordinateLineStereoParam_eq_zero_of_eval_residualImageXCoords
    {k : Type u} [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (v : Fin 3 → Polynomial k)
    (H : MvPolynomial (Fin 3) k)
    (hvan : eval (residualImageXCoords F v) (map (C : k →+* affineTwoRing k) H) = 0)
    (t s : k) :
    eval (coordinateLineStereoParam F hF v t s) H = 0 := by
  have hpt : eval (fun i => evalAffineTwoPoint t s (residualImageXCoords F v i)) H = 0 := by
    rw [← eval_evalAffineTwoPoint_residualImageXCoords F v t s H]
    simpa using congrArg (evalAffineTwoPoint t s) hvan
  rwa [evalAffineTwoPoint_residualImageXCoords_eq_coordinateLineStereoParam F hF v t s] at hpt

/-! ### Covering the specialized conic by stereo -/

/-- Polar form is linear in the free vector. -/
theorem polarEval_smul_right
    {K : Type u} [CommRing K]
    (Q : MvPolynomial (Fin 3) K) (hQ : Q.IsHomogeneous 2)
    (p w : Fin 3 → K) (c : K) :
    polarEval Q p (c • w) = c * polarEval Q p w := by
  simp only [polarEval_eq_coeff_sum Q hQ, Pi.smul_apply, smul_eq_mul, Fin.sum_univ_three]
  ring

/-- Expansion of a homogeneous ternary quadratic on a linear combination. -/
theorem eval_linComb_of_isHomogeneous_two
    {K : Type u} [CommRing K]
    (Q : MvPolynomial (Fin 3) K) (hQ : Q.IsHomogeneous 2)
    (a b : K) (p w : Fin 3 → K) :
    eval (fun i => a * p i + b * w i) Q =
      a * a * eval p Q + a * b * polarEval Q p w + b * b * eval w Q := by
  have hp := eval_eq_ternaryQuadraticCoeff_sum hQ p
  have hw := eval_eq_ternaryQuadraticCoeff_sum hQ w
  have hpol := polarEval_eq_coeff_sum Q hQ p w
  have h := eval_eq_ternaryQuadraticCoeff_sum hQ (fun i => a * p i + b * w i)
  rw [h, hp, hw, hpol]
  simp only [Fin.sum_univ_three]
  ring

/-- Stereographic second intersection scales quadratically in the free direction. -/
theorem stereoAlg_smul_right
    {K : Type u} [CommRing K]
    (Q : MvPolynomial (Fin 3) K) (hQ : Q.IsHomogeneous 2)
    (p w : Fin 3 → K) (c : K) :
    stereoAlg Q p (c • w) = (c * c) • stereoAlg Q p w := by
  funext i
  simp only [stereoAlg, Pi.smul_apply, smul_eq_mul]
  have hw : eval (c • w) Q = (c * c) * eval w Q := by
    have hw' : (c • w : Fin 3 → K) = fun j => c * w j := by
      funext j; simp [Pi.smul_apply, smul_eq_mul]
    rw [hw']
    have hp := eval_eq_ternaryQuadraticCoeff_sum hQ w
    have hc := eval_eq_ternaryQuadraticCoeff_sum hQ (fun j => c * w j)
    rw [hc, hp]
    simp only [Fin.sum_univ_three]
    ring
  have hpol : polarEval Q p (c • w) = c * polarEval Q p w :=
    polarEval_smul_right Q hQ p w c
  simp only [hw, hpol]
  ring

/-- If `x = λ p + w` lies on the conic with isotropic `p`, then
`stereoAlg Q p w = (-polarEval Q p w) • x`. -/
theorem stereoAlg_eq_neg_polar_smul_of_isotropic
    {K : Type u} [Field K]
    (Q : MvPolynomial (Fin 3) K) (hQ : Q.IsHomogeneous 2)
    (p x : Fin 3 → K) (hp : eval p Q = 0) (hx : eval x Q = 0)
    (lam : K) (w : Fin 3 → K)
    (hxw : x = fun i => lam * p i + w i) :
    stereoAlg Q p w = (- polarEval Q p w) • x := by
  have hQB : eval w Q + lam * polarEval Q p w = 0 := by
    have hx' := hx
    rw [hxw] at hx'
    have hexp := eval_linComb_of_isHomogeneous_two Q hQ lam 1 p w
    simp only [one_mul, mul_one] at hexp
    have : eval (fun i => lam * p i + w i) Q =
        lam * lam * eval p Q + lam * polarEval Q p w + eval w Q := hexp
    rw [this, hp, mul_zero, zero_add] at hx'
    linear_combination hx'
  have hQw : eval w Q = -lam * polarEval Q p w := by
    linear_combination hQB
  funext i
  simp only [stereoAlg, Pi.smul_apply, smul_eq_mul, hQw, hxw]
  ring

/-- Free-direction vectors with third coordinate 0 are multiples of `(1,s,0)` or `(0,1,0)`. -/
theorem exists_smul_stereographicDirection_of_third_eq_zero
    {K : Type u} [Field K] (w : Fin 3 → K) (hw2 : w 2 = 0) :
    ∃ c s : K, w = c • stereographicDirection s ∨ w = c • (![0, 1, (0 : K)]) := by
  classical
  by_cases hw0 : w 0 = 0
  · refine ⟨w 1, 0, Or.inr ?_⟩
    funext i
    fin_cases i <;> simp [hw0, hw2, Pi.smul_apply, smul_eq_mul]
  · refine ⟨w 0, (w 0)⁻¹ * w 1, Or.inl ?_⟩
    funext i
    fin_cases i
    · simp [stereographicDirection, Pi.smul_apply, smul_eq_mul]
    · simp [stereographicDirection, Pi.smul_apply, smul_eq_mul, ← mul_assoc,
        mul_inv_cancel₀ hw0]
    · simp [stereographicDirection, Pi.smul_apply, smul_eq_mul, hw2]

/-- Homogeneous degree-2 evaluation of a scalar multiple. -/
theorem eval_smul_of_isHomogeneous_two'
    {K : Type u} [CommRing K]
    (H : MvPolynomial (Fin 3) K) (hH : H.IsHomogeneous 2)
    (c : K) (x : Fin 3 → K) :
    eval (c • x) H = (c * c) * eval x H := by
  have hpt : (c • x : Fin 3 → K) = fun i => c * x i + 0 * (0 : Fin 3 → K) i := by
    funext i; simp [Pi.smul_apply, smul_eq_mul]
  rw [hpt, eval_linComb_of_isHomogeneous_two H hH c 0 x (0 : Fin 3 → K)]
  simp [mul_zero, zero_mul, add_zero]

/-- Covering when polar is nonzero: isotropic `x` is a multiple of free stereo. -/
theorem eval_eq_zero_of_eval_stereo_of_polar_ne
    {K : Type u} [Field K]
    (Q H : MvPolynomial (Fin 3) K)
    (hQ : Q.IsHomogeneous 2) (hH : H.IsHomogeneous 2)
    (p : Fin 3 → K) (hp : eval p Q = 0) (hp2 : p 2 ≠ 0)
    (hHst : ∀ s : K, eval (stereoAlg Q p (stereographicDirection s)) H = 0)
    (hHinf : eval (stereoAlg Q p (![0, 1, (0 : K)])) H = 0)
    (x : Fin 3 → K) (hx : eval x Q = 0)
    (hB : polarEval Q p (fun i => x i - (x 2 * (p 2)⁻¹) * p i) ≠ 0) :
    eval x H = 0 := by
  classical
  set lam := x 2 * (p 2)⁻¹
  set w : Fin 3 → K := fun i => x i - lam * p i
  have hw2 : w 2 = 0 := by
    simp [w, lam]
    field_simp [hp2]
    ring
  have hxw : x = fun i => lam * p i + w i := by
    funext i; simp [w]
  have hst :=
    stereoAlg_eq_neg_polar_smul_of_isotropic Q hQ p x hp hx lam w hxw
  have hB' : polarEval Q p w ≠ 0 := hB
  have hx' : x = (- polarEval Q p w)⁻¹ • stereoAlg Q p w := by
    funext i
    have hi := congr_fun hst i
    simp only [Pi.smul_apply, smul_eq_mul] at hi
    have hBne : polarEval Q p w ≠ 0 := hB'
    have hst' : stereoAlg Q p w i = (- polarEval Q p w) * x i := by
      simpa [Pi.smul_apply, smul_eq_mul] using hi
    show x i = ((- polarEval Q p w)⁻¹ • stereoAlg Q p w) i
    simp only [Pi.smul_apply, smul_eq_mul]
    calc
      x i = (- polarEval Q p w)⁻¹ * ((- polarEval Q p w) * x i) := by
        field_simp [hBne]
      _ = (- polarEval Q p w)⁻¹ * stereoAlg Q p w i := by rw [← hst']
  rw [hx', eval_smul_of_isHomogeneous_two' H hH]
  suffices h0 : eval (stereoAlg Q p w) H = 0 by
    simp [h0]
  obtain ⟨c, s0, hws⟩ := exists_smul_stereographicDirection_of_third_eq_zero w hw2
  rcases hws with hws | hws
  · rw [hws, stereoAlg_smul_right Q hQ p (stereographicDirection s0) c,
      eval_smul_of_isHomogeneous_two' H hH]
    simp [hHst s0]
  · rw [hws, stereoAlg_smul_right Q hQ p (![0, 1, (0 : K)]) c,
      eval_smul_of_isHomogeneous_two' H hH]
    simp [hHinf]

/-! ### Free-direction univariate of ternary quadratics -/

/-- Free-direction univariate `s ↦ H(1,s,0)`. -/
noncomputable def freeDirUnivariate
    {K : Type u} [CommRing K] (H : MvPolynomial (Fin 3) K) : Polynomial K :=
  Polynomial.C (ternaryQuadraticCoeff H 0 0) +
    Polynomial.C (ternaryQuadraticCoeff H 0 1) * Polynomial.X +
      Polynomial.C (ternaryQuadraticCoeff H 1 1) * Polynomial.X ^ 2

theorem eval_freeDirUnivariate
    {K : Type u} [CommRing K]
    (H : MvPolynomial (Fin 3) K) (hH : H.IsHomogeneous 2) (s : K) :
    Polynomial.eval s (freeDirUnivariate H) = eval (stereographicDirection s) H := by
  have h10 : ternaryQuadraticCoeff H 1 0 = 0 := by
    simp [ternaryQuadraticCoeff, show ¬ (1 : Fin 3) < 0 by decide]
  have h20 : ternaryQuadraticCoeff H 2 0 = 0 := by
    simp [ternaryQuadraticCoeff, show ¬ (2 : Fin 3) < 0 by decide]
  have h21 : ternaryQuadraticCoeff H 2 1 = 0 := by
    simp [ternaryQuadraticCoeff, show ¬ (2 : Fin 3) < 1 by decide]
  have hs := eval_eq_ternaryQuadraticCoeff_sum hH (![1, s, (0 : K)])
  have hdir : stereographicDirection s = ![1, s, (0 : K)] := rfl
  rw [hdir, hs]
  unfold freeDirUnivariate
  simp only [Fin.sum_univ_three, h10, h20, h21, Polynomial.eval_add, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_pow, Polynomial.eval_X, Matrix.cons_val_zero,
    Matrix.cons_val_one, Matrix.head_cons, Matrix.cons_val_two, Matrix.tail_cons,
    mul_zero, zero_mul, add_zero, zero_add, mul_one, one_mul]
  ring

theorem coeff_freeDirUnivariate_eq_zero
    {K : Type u} [CommRing K] (H : MvPolynomial (Fin 3) K)
    (hfree : freeDirUnivariate H = 0) :
    ternaryQuadraticCoeff H 0 0 = 0 ∧
      ternaryQuadraticCoeff H 0 1 = 0 ∧
        ternaryQuadraticCoeff H 1 1 = 0 := by
  have h0 := congrArg (fun p : Polynomial K => p.coeff 0) hfree
  have h1 := congrArg (fun p : Polynomial K => p.coeff 1) hfree
  have h2 := congrArg (fun p : Polynomial K => p.coeff 2) hfree
  refine ⟨?_, ?_, ?_⟩
  · simpa [freeDirUnivariate] using h0
  · simpa [freeDirUnivariate] using h1
  · have hc :
        (freeDirUnivariate H).coeff 2 = ternaryQuadraticCoeff H 1 1 := by
      simp [freeDirUnivariate, Polynomial.coeff_add, Polynomial.coeff_C_mul,
        Polynomial.coeff_X_pow, Polynomial.coeff_C]
    rw [← hc, hfree, Polynomial.coeff_zero]

theorem eval_on_X2_zero_of_freeDirUnivariate_eq_zero
    {K : Type u} [CommRing K]
    (H : MvPolynomial (Fin 3) K) (hH : H.IsHomogeneous 2)
    (hfree : freeDirUnivariate H = 0) :
    ∀ a b : K, eval ![a, b, (0 : K)] H = 0 := by
  intro a b
  obtain ⟨hc00, hc01, hc11⟩ := coeff_freeDirUnivariate_eq_zero H hfree
  have hsum := eval_eq_ternaryQuadraticCoeff_sum hH (![a, b, (0 : K)])
  have h10 : ternaryQuadraticCoeff H 1 0 = 0 := by
    simp [ternaryQuadraticCoeff, show ¬ (1 : Fin 3) < 0 by decide]
  have h20 : ternaryQuadraticCoeff H 2 0 = 0 := by
    simp [ternaryQuadraticCoeff, show ¬ (2 : Fin 3) < 0 by decide]
  have h21 : ternaryQuadraticCoeff H 2 1 = 0 := by
    simp [ternaryQuadraticCoeff, show ¬ (2 : Fin 3) < 1 by decide]
  rw [hsum]
  simp only [Fin.sum_univ_three, h10, h20, h21, hc00, hc01, hc11,
    Matrix.cons_val_zero, Matrix.cons_val_one, Matrix.head_cons, Matrix.cons_val_two,
    Matrix.tail_cons, mul_zero, zero_mul, add_zero, zero_add]

theorem freeDirUnivariate_eq_zero_of_forall_eval
    {K : Type u} [CommRing K] [IsDomain K] [Infinite K]
    (H : MvPolynomial (Fin 3) K) (hH : H.IsHomogeneous 2)
    (h : ∀ s : K, eval (stereographicDirection s) H = 0) :
    freeDirUnivariate H = 0 := by
  refine Polynomial.funext fun s => ?_
  calc
    Polynomial.eval s (freeDirUnivariate H) = eval (stereographicDirection s) H :=
      eval_freeDirUnivariate H hH s
    _ = 0 := h s
    _ = Polynomial.eval s 0 := by simp

theorem eq_X2_mul_of_eval_on_X2_zero_deg_two
    {R : Type u} [CommRing R] [IsDomain R] [Infinite R]
    (H : MvPolynomial (Fin 3) R) (_hH : H.IsHomogeneous 2)
    (hvan : ∀ a b : R, eval ![a, b, (0 : R)] H = 0) :
    ∃ L : MvPolynomial (Fin 3) R, H = X (2 : Fin 3) * L := by
  classical
  set Qdiv := H.divMonomial (Finsupp.single (2 : Fin 3) 1)
  set R0 := H.modMonomial (Finsupp.single (2 : Fin 3) 1)
  have hdecomp : X (2 : Fin 3) * Qdiv + R0 = H := by
    simpa [Qdiv, R0] using divMonomial_add_modMonomial_single H (2 : Fin 3)
  have hR0 : R0 = 0 := by
    refine MvPolynomial.funext fun z => ?_
    have hsup : ∀ m ∈ R0.support, m (2 : Fin 3) = 0 := by
      intro m hm
      by_contra hpos
      have hle : Finsupp.single (2 : Fin 3) 1 ≤ m := by
        intro i
        by_cases hi : i = 2
        · subst hi
          simpa [Finsupp.single_apply] using Nat.one_le_iff_ne_zero.mpr hpos
        · simp [Finsupp.single_apply, hi]
      have := coeff_modMonomial_of_le H hle
      exact absurd this (mem_support_iff.mp hm)
    have hagree : eval z R0 = eval ![z 0, z 1, (0 : R)] R0 := by
      rw [MvPolynomial.as_sum R0, map_sum, map_sum]
      refine Finset.sum_congr rfl fun m hm => ?_
      have hm2 : m 2 = 0 := hsup m hm
      simp only [eval_monomial]
      congr 1
      refine Finset.prod_congr rfl fun i _ => ?_
      fin_cases i <;> simp [hm2]
    have hG0 : eval ![z 0, z 1, (0 : R)] H = 0 := hvan (z 0) (z 1)
    have hmod : eval ![z 0, z 1, (0 : R)] R0 = eval ![z 0, z 1, (0 : R)] H := by
      have h := congrArg (eval ![z 0, z 1, (0 : R)]) hdecomp.symm
      simp only [eval_add, eval_mul, eval_X, Matrix.cons_val_two, Matrix.tail_cons,
        Matrix.head_cons, zero_mul, zero_add] at h
      exact h.symm
    rw [hagree, hmod, hG0]
    rfl
  refine ⟨Qdiv, ?_⟩
  rw [← hdecomp, hR0, add_zero]

theorem evalAffineTwoPoint_specializedConicFreeDirForm
    {k : Type u} [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (t s : k) :
    evalAffineTwoPoint t s (specializedConicFreeDirForm F) =
      eval (stereographicDirection s) (coordinateLineSpecializedConic F t) := by
  have hmap := map_evalAffineTwoPoint_specializedConicPullback F t s
  have hst :
      (fun i => evalAffineTwoPoint t s (affineTwoStereoDir (k := k) i)) =
        stereographicDirection s := by
    funext i
    fin_cases i <;>
      simp [affineTwoStereoDir, affineTwoCoord1, evalAffineTwoPoint, stereographicDirection,
        eval_X]
  simp only [specializedConicFreeDirForm]
  calc
    evalAffineTwoPoint t s
        (eval (affineTwoStereoDir (k := k)) (specializedConicPullback F)) =
        eval (fun i => evalAffineTwoPoint t s (affineTwoStereoDir (k := k) i))
          (map (evalAffineTwoPoint t s) (specializedConicPullback F)) := by
      rw [eval_map]
      exact eval₂_comp (evalAffineTwoPoint t s) (affineTwoStereoDir (k := k))
        (specializedConicPullback F)
    _ = eval (stereographicDirection s) (coordinateLineSpecializedConic F t) := by
      rw [hmap, hst]

theorem eval_stereographicDirection_eq_zero_of_freeDir_zero_of_polar_ne
    {k : Type u} [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (v : Fin 3 → Polynomial k)
    (H : MvPolynomial (Fin 3) k) (hH : H.IsHomogeneous 2)
    (t s : k)
    (hα0 : eval (stereographicDirection s) (coordinateLineSpecializedConic F t) = 0)
    (hB : polarEval (coordinateLineSpecializedConic F t) (evalPolySection v t)
      (stereographicDirection s) ≠ 0)
    (hHst : eval (coordinateLineStereoParam F hF v t s) H = 0) :
    eval (stereographicDirection s) H = 0 := by
  have hst_eq :
      stereoAlg (coordinateLineSpecializedConic F t) (evalPolySection v t)
        (stereographicDirection s) =
        (- polarEval (coordinateLineSpecializedConic F t) (evalPolySection v t)
          (stereographicDirection s)) • stereographicDirection s := by
    funext i
    simp only [stereoAlg, hα0, zero_mul, zero_sub, Pi.smul_apply, smul_eq_mul, neg_mul]
  have hvec : coordinateLineStereoParam F hF v t s =
      stereoAlg (coordinateLineSpecializedConic F t) (evalPolySection v t)
        (stereographicDirection s) := by
    rw [coordinateLineStereoParam, stereoSecondIntersection_eq_stereoAlg]
  rw [hvec, hst_eq, eval_smul_of_isHomogeneous_two' H hH] at hHst
  have hsq :
      (- polarEval (coordinateLineSpecializedConic F t) (evalPolySection v t)
        (stereographicDirection s)) *
        (- polarEval (coordinateLineSpecializedConic F t) (evalPolySection v t)
          (stereographicDirection s)) ≠ 0 :=
    mul_ne_zero (neg_ne_zero.mpr hB) (neg_ne_zero.mpr hB)
  exact (mul_eq_zero.mp hHst).resolve_left hsq


/-! ### Denseness under residual X₂ ≠ 0 -/

/-- Residual X₂ equals free-direction form times the Tsen section's third coordinate. -/
theorem residualImageXCoords_two_eq
    {k : Type u} [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (v : Fin 3 → Polynomial k) :
    residualImageXCoords F v 2 =
      specializedConicFreeDirForm F * liftTsenSection v 2 := by
  simp only [residualImageXCoords, stereoFirstCoords, stereoAlg, specializedConicFreeDirForm,
    affineTwoStereoDir, liftTsenSection]
  simp [Matrix.cons_val_two, Matrix.tail_cons, Matrix.head_cons, mul_zero, sub_zero]

/-- Free-plane vanishing of a ternary quadratic means it is supported on monomials involving `X₂`.
-/
theorem eq_X2_linear_of_freeDirUnivariate_eq_zero
    {K : Type u} [Field K] [Infinite K]
    (H : MvPolynomial (Fin 3) K) (hH : H.IsHomogeneous 2)
    (hfree : freeDirUnivariate H = 0) :
    H = C (ternaryQuadraticCoeff H 0 2) * X 0 * X 2 +
        C (ternaryQuadraticCoeff H 1 2) * X 1 * X 2 +
        C (ternaryQuadraticCoeff H 2 2) * X 2 * X 2 := by
  obtain ⟨hc00, hc01, hc11⟩ := coeff_freeDirUnivariate_eq_zero H hfree
  have h10 : ternaryQuadraticCoeff H 1 0 = 0 := by
    simp [ternaryQuadraticCoeff, show ¬ (1 : Fin 3) < 0 by decide]
  have h20 : ternaryQuadraticCoeff H 2 0 = 0 := by
    simp [ternaryQuadraticCoeff, show ¬ (2 : Fin 3) < 0 by decide]
  have h21 : ternaryQuadraticCoeff H 2 1 = 0 := by
    simp [ternaryQuadraticCoeff, show ¬ (2 : Fin 3) < 1 by decide]
  refine MvPolynomial.funext fun x => ?_
  have hsum := eval_eq_ternaryQuadraticCoeff_sum hH x
  have hsum' :
      (∑ i : Fin 3, ∑ j : Fin 3, ternaryQuadraticCoeff H i j * x i * x j) =
        ternaryQuadraticCoeff H 0 2 * x 0 * x 2 +
          ternaryQuadraticCoeff H 1 2 * x 1 * x 2 +
            ternaryQuadraticCoeff H 2 2 * x 2 * x 2 := by
    simp only [Fin.sum_univ_three, hc00, hc01, hc11, h10, h20, h21, zero_mul,
      zero_add, add_zero]
  have hrhs :
      eval x (C (ternaryQuadraticCoeff H 0 2) * X 0 * X 2 +
          C (ternaryQuadraticCoeff H 1 2) * X 1 * X 2 +
            C (ternaryQuadraticCoeff H 2 2) * X 2 * X 2) =
        ternaryQuadraticCoeff H 0 2 * x 0 * x 2 +
          ternaryQuadraticCoeff H 1 2 * x 1 * x 2 +
            ternaryQuadraticCoeff H 2 2 * x 2 * x 2 := by
    simp [mul_comm, mul_left_comm]
  exact hsum.trans (hsum'.trans hrhs.symm)

theorem eval_map_C_X2_linear
    {k : Type u} [Field k]
    (z : Fin 3 → affineTwoRing k) (c02 c12 c22 : k) :
    eval z (map (C : k →+* affineTwoRing k)
      (C c02 * X 0 * X 2 + C c12 * X 1 * X 2 + C c22 * X 2 * X 2)) =
      z 2 * (C c02 * z 0 + C c12 * z 1 + C c22 * z 2) := by
  simp [map_add, map_mul, map_C, map_X, eval_C, eval_X]
  ring

private theorem single_s_ne_zero :
    (Finsupp.single (ULift.up (1 : Fin 2)) 1 : ULift.{u} (Fin 2) →₀ ℕ) ≠ 0 := by
  intro h
  have := congrArg (fun m : ULift.{u} (Fin 2) →₀ ℕ => m (ULift.up (1 : Fin 2))) h
  simp at this

/-- The free-plane linear form `c₀₂ + c₁₂ s` vanishes as an affine-plane polynomial
iff both coeffs vanish. -/
theorem eq_zero_of_C_add_C_mul_affineTwoCoord1
    {k : Type u} [Field k] (c02 c12 : k)
    (h : C c02 + C c12 * affineTwoCoord1 k = (0 : affineTwoRing k)) :
    c02 = 0 ∧ c12 = 0 := by
  have e0 : coeff (0 : ULift (Fin 2) →₀ ℕ) (C c02 + C c12 * affineTwoCoord1 k) = c02 := by
    rw [coeff_add, coeff_C, if_pos rfl, affineTwoCoord1, coeff_C_mul, coeff_X]
    simp
  have e1 :
      coeff (Finsupp.single (ULift.up (1 : Fin 2)) 1)
        (C c02 + C c12 * affineTwoCoord1 k) = c12 := by
    rw [coeff_add, affineTwoCoord1, coeff_C_mul, coeff_X, if_pos rfl, mul_one]
    have hc : coeff (Finsupp.single (ULift.up (1 : Fin 2)) 1) (C c02 : affineTwoRing k) = 0 := by
      rw [coeff_C, if_neg (Ne.symm single_s_ne_zero)]
    rw [hc, zero_add]
  constructor
  · have := congrArg (coeff (0 : ULift (Fin 2) →₀ ℕ)) h
    simpa [e0] using this
  · have := congrArg (coeff (Finsupp.single (ULift.up (1 : Fin 2)) 1)) h
    simpa [e1] using this

/-- Linear relation on residual stereo from free-plane vanishing of a deg-2 form. -/
theorem residual_linear_eq_zero_of_freeDirUnivariate
    {k : Type u} [Field k] [Infinite k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (v : Fin 3 → Polynomial k)
    (H : MvPolynomial (Fin 3) k) (hH : H.IsHomogeneous 2)
    (hfree : freeDirUnivariate H = 0)
    (hst2 : residualImageXCoords F v 2 ≠ 0)
    (hvan : eval (residualImageXCoords F v) (map (C : k →+* affineTwoRing k) H) = 0) :
    C (ternaryQuadraticCoeff H 0 2) * residualImageXCoords F v 0 +
      C (ternaryQuadraticCoeff H 1 2) * residualImageXCoords F v 1 +
        C (ternaryQuadraticCoeff H 2 2) * residualImageXCoords F v 2 = 0 := by
  classical
  set c02 := ternaryQuadraticCoeff H 0 2
  set c12 := ternaryQuadraticCoeff H 1 2
  set c22 := ternaryQuadraticCoeff H 2 2
  have hform := eq_X2_linear_of_freeDirUnivariate_eq_zero H hH hfree
  have hprod :
      residualImageXCoords F v 2 *
        (C c02 * residualImageXCoords F v 0 +
          C c12 * residualImageXCoords F v 1 +
            C c22 * residualImageXCoords F v 2) = 0 := by
    have : eval (residualImageXCoords F v) (map (C : k →+* affineTwoRing k) H) =
        residualImageXCoords F v 2 *
          (C c02 * residualImageXCoords F v 0 +
            C c12 * residualImageXCoords F v 1 +
              C c22 * residualImageXCoords F v 2) := by
      rw [hform]
      simpa [c02, c12, c22] using
        eval_map_C_X2_linear (residualImageXCoords F v) c02 c12 c22
    rw [← this, hvan]
  exact (mul_eq_zero.mp hprod).resolve_left hst2

/-- FreeDir–polar identity for a residual linear form. -/
theorem freeDir_mul_Lp_eq_polar_mul_Lfree
    {k : Type u} [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (v : Fin 3 → Polynomial k)
    (c02 c12 c22 : k)
    (hlin :
      C c02 * residualImageXCoords F v 0 +
        C c12 * residualImageXCoords F v 1 +
          C c22 * residualImageXCoords F v 2 = 0) :
    specializedConicFreeDirForm F *
        (C c02 * liftTsenSection v 0 + C c12 * liftTsenSection v 1 +
          C c22 * liftTsenSection v 2) =
      polarEval (specializedConicPullback F) (liftTsenSection v) (affineTwoStereoDir (k := k)) *
        (C c02 + C c12 * affineTwoCoord1 k) := by
  have hx : ∀ i,
      residualImageXCoords F v i =
        specializedConicFreeDirForm F * liftTsenSection v i -
          polarEval (specializedConicPullback F) (liftTsenSection v) (affineTwoStereoDir (k := k)) *
            affineTwoStereoDir (k := k) i := by
    intro i
    simp only [residualImageXCoords, stereoFirstCoords, stereoAlg, specializedConicFreeDirForm]
  have hw0 : affineTwoStereoDir (k := k) 0 = 1 := by simp [affineTwoStereoDir]
  have hw1 : affineTwoStereoDir (k := k) 1 = affineTwoCoord1 k := by simp [affineTwoStereoDir]
  have hw2 : affineTwoStereoDir (k := k) 2 = 0 := by simp [affineTwoStereoDir]
  have := hlin
  simp only [hx, hw0, hw1, hw2] at this
  set α := specializedConicFreeDirForm F
  set B := polarEval (specializedConicPullback F) (liftTsenSection v) (affineTwoStereoDir (k := k))
  set p0 := liftTsenSection v 0
  set p1 := liftTsenSection v 1
  set p2 := liftTsenSection v 2
  set s := affineTwoCoord1 k
  change C c02 * (α * p0 - B * 1) + C c12 * (α * p1 - B * s) +
      C c22 * (α * p2 - B * 0) = 0 at this
  have hre :
      α * (C c02 * p0 + C c12 * p1 + C c22 * p2) -
        B * (C c02 * 1 + C c12 * s + C c22 * 0) = 0 := by
    convert this using 1; ring
  have hre' :
      α * (C c02 * p0 + C c12 * p1 + C c22 * p2) = B * (C c02 + C c12 * s) := by
    linear_combination hre
  simpa [α, B, p0, p1, p2, s] using hre'

/-- Free-direction univariate of the specialized conic at a fixed free parameter `s`. -/
noncomputable def freeDirPolyT
    {k : Type u} [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (s : k) : Polynomial k :=
  ternaryQuadraticCoeff (coordinateLineSpecializedConicPoly F) 0 0 +
    ternaryQuadraticCoeff (coordinateLineSpecializedConicPoly F) 0 1 * Polynomial.C s +
      ternaryQuadraticCoeff (coordinateLineSpecializedConicPoly F) 1 1 * Polynomial.C s ^ 2

theorem evalAffineTwoPoint_specializedConicFreeDirForm_eq_eval_freeDirPolyT
    {k : Type u} [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (t s : k) :
    evalAffineTwoPoint t s (specializedConicFreeDirForm F) =
      Polynomial.eval t (freeDirPolyT F s) := by
  rw [specializedConicFreeDirForm_eq_lift F hF]
  unfold freeDirPolyT
  simp only [map_add, map_mul, evalAffineTwoPoint_liftPolyT]
  have hs : evalAffineTwoPoint t s (affineTwoCoord1 k) = s := by
    simp [affineTwoCoord1, evalAffineTwoPoint, eval_X]
  have hs2 : evalAffineTwoPoint t s (affineTwoCoord1 k ^ 2) = s ^ 2 := by
    rw [map_pow, hs]
  rw [hs, hs2]
  simp only [Polynomial.eval_add, Polynomial.eval_mul, Polynomial.eval_C, Polynomial.eval_pow]

theorem eval_freeDirPolyT
    {k : Type u} [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (t s : k) :
    Polynomial.eval t (freeDirPolyT F s) =
      eval (stereographicDirection s) (coordinateLineSpecializedConic F t) := by
  rw [← evalAffineTwoPoint_specializedConicFreeDirForm_eq_eval_freeDirPolyT F hF t s]
  exact evalAffineTwoPoint_specializedConicFreeDirForm F t s


/-- If residual stereo vanishes `H` and freeDir vanishes with nonzero polar at `(t,s)`,
then freeDirUnivariate `H` vanishes at `s`. -/
theorem freeDirUnivariate_eval_eq_zero_of_freeDir_root_polar_ne
    {k : Type u} [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (v : Fin 3 → Polynomial k)
    (H : MvPolynomial (Fin 3) k) (hH : H.IsHomogeneous 2)
    (hvan : eval (residualImageXCoords F v) (map (C : k →+* affineTwoRing k) H) = 0)
    (t s : k)
    (hα0 : Polynomial.eval t (freeDirPolyT F s) = 0)
    (hB : polarEval (coordinateLineSpecializedConic F t) (evalPolySection v t)
      (stereographicDirection s) ≠ 0) :
    Polynomial.eval s (freeDirUnivariate H) = 0 := by
  have hα0' : eval (stereographicDirection s) (coordinateLineSpecializedConic F t) = 0 := by
    rwa [← eval_freeDirPolyT F hF t s]
  have hHst :
      eval (coordinateLineStereoParam F hF v t s) H = 0 :=
    eval_coordinateLineStereoParam_eq_zero_of_eval_residualImageXCoords F hF v H hvan t s
  have hdir :
      eval (stereographicDirection s) H = 0 :=
    eval_stereographicDirection_eq_zero_of_freeDir_zero_of_polar_ne F hF v H hH t s hα0' hB hHst
  rw [eval_freeDirUnivariate H hH s]
  exact hdir

/-- Coefficients of a residual linear form vanish when residual X₂ ≠ 0 and free-plane linear
part is zero. -/
theorem coeffs_eq_zero_of_residual_linear_of_Lfree_zero
    {k : Type u} [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (v : Fin 3 → Polynomial k)
    (c02 c12 c22 : k)
    (hst2 : residualImageXCoords F v 2 ≠ 0)
    (hlin :
      C c02 * residualImageXCoords F v 0 +
        C c12 * residualImageXCoords F v 1 +
          C c22 * residualImageXCoords F v 2 = 0)
    (hLfree : c02 = 0 ∧ c12 = 0) :
    c02 = 0 ∧ c12 = 0 ∧ c22 = 0 := by
  obtain ⟨hc02, hc12⟩ := hLfree
  have hlin' : C c22 * residualImageXCoords F v 2 = 0 := by
    simpa [hc02, hc12] using hlin
  refine ⟨hc02, hc12, ?_⟩
  have hC : (C c22 : affineTwoRing k) = 0 ∨ residualImageXCoords F v 2 = 0 :=
    mul_eq_zero.mp hlin'
  rcases hC with hC | hC
  · exact C_eq_zero.mp hC
  · exact absurd hC hst2

/-- Under free-plane vanishing, residual X₂ ≠ 0, and free residual linear coeffs zero, denseness. -/
theorem eq_zero_of_freeDirUnivariate_residualX2_Lfree
    {k : Type u} [Field k] [Infinite k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (v : Fin 3 → Polynomial k)
    (H : MvPolynomial (Fin 3) k) (hH : H.IsHomogeneous 2)
    (hfree : freeDirUnivariate H = 0)
    (hst2 : residualImageXCoords F v 2 ≠ 0)
    (hvan : eval (residualImageXCoords F v) (map (C : k →+* affineTwoRing k) H) = 0)
    (hLfree :
      ternaryQuadraticCoeff H 0 2 = 0 ∧ ternaryQuadraticCoeff H 1 2 = 0) :
    H = 0 := by
  classical
  have hlin :=
    residual_linear_eq_zero_of_freeDirUnivariate F v H hH hfree hst2 hvan
  set c02 := ternaryQuadraticCoeff H 0 2
  set c12 := ternaryQuadraticCoeff H 1 2
  set c22 := ternaryQuadraticCoeff H 2 2
  have hcs :=
    coeffs_eq_zero_of_residual_linear_of_Lfree_zero F v c02 c12 c22 hst2 hlin hLfree
  obtain ⟨hc02, hc12, hc22⟩ := hcs
  have hform := eq_X2_linear_of_freeDirUnivariate_eq_zero H hH hfree
  simp only [c02, c12, c22] at hc02 hc12 hc22 hform
  simpa [hc02, hc12, hc22] using hform

/-- Polar of specialized conic along free direction, as an affine-plane polynomial. -/
noncomputable def freePolarForm
    {k : Type u} [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (v : Fin 3 → Polynomial k) : affineTwoRing k :=
  polarEval (specializedConicPullback F) (liftTsenSection v) (affineTwoStereoDir (k := k))

theorem evalAffineTwoPoint_freePolarForm
    {k : Type u} [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (_hF : IsBidegree23 F)
    (v : Fin 3 → Polynomial k) (t s : k) :
    evalAffineTwoPoint t s (freePolarForm F v) =
      polarEval (coordinateLineSpecializedConic F t) (evalPolySection v t)
        (stereographicDirection s) := by
  have hQ := map_evalAffineTwoPoint_specializedConicPullback F t s
  have hp : (fun j => evalAffineTwoPoint t s (liftTsenSection v j)) =
      evalPolySection v t := by
    funext j
    simp [liftTsenSection, evalPolySection, evalAffineTwoPoint_liftPolyT]
  have hw : (fun j => evalAffineTwoPoint t s (affineTwoStereoDir (k := k) j)) =
      stereographicDirection s := by
    funext j
    fin_cases j <;>
      simp [affineTwoStereoDir, affineTwoCoord1, evalAffineTwoPoint, stereographicDirection,
        eval_X]
  have hpw :
      (fun j => evalAffineTwoPoint t s
        (liftTsenSection v j + affineTwoStereoDir (k := k) j)) =
        fun j => evalPolySection v t j + stereographicDirection s j := by
    funext j
    simp only [map_add, hp, hw]
    -- hp and hw are funext equalities; apply componentwise
    have hpj := congrFun hp j
    have hwj := congrFun hw j
    simp only [hpj, hwj]
  simp only [freePolarForm, polarEval]
  have heval (z : Fin 3 → affineTwoRing k) :
      evalAffineTwoPoint t s (eval z (specializedConicPullback F)) =
        eval (fun j => evalAffineTwoPoint t s (z j))
          (map (evalAffineTwoPoint t s) (specializedConicPullback F)) := by
    rw [eval_map]
    exact eval₂_comp (evalAffineTwoPoint t s) z (specializedConicPullback F)
  rw [map_sub, map_sub, heval, heval, heval, hQ, hp, hw, hpw]


/-- Expansion of a deg-2 form on algebraic stereo: `H(α p − B w)`. -/
theorem eval_stereoAlg_of_isHomogeneous_two
    {K : Type u} [CommRing K]
    (Q H : MvPolynomial (Fin 3) K)
    (hH : H.IsHomogeneous 2)
    (p w : Fin 3 → K) :
    eval (stereoAlg Q p w) H =
      eval w Q * eval w Q * eval p H -
        eval w Q * polarEval Q p w * polarEval H p w +
          polarEval Q p w * polarEval Q p w * eval w H := by
  have hst : stereoAlg Q p w =
      fun i => eval w Q * p i + (- polarEval Q p w) * w i := by
    funext i; simp only [stereoAlg]; ring
  rw [hst, eval_linComb_of_isHomogeneous_two H hH (eval w Q) (-polarEval Q p w) p w]
  ring

/-- Residual vanishing of `H` implies freeDir divides `polar² · H(w)` on the free direction. -/
theorem freeDir_mul_eq_of_eval_residualImageXCoords
    {k : Type u} [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (_hF : IsBidegree23 F)
    (v : Fin 3 → Polynomial k)
    (H : MvPolynomial (Fin 3) k) (hH : H.IsHomogeneous 2)
    (hvan : eval (residualImageXCoords F v) (map (C : k →+* affineTwoRing k) H) = 0) :
    freePolarForm F v * freePolarForm F v *
        eval (affineTwoStereoDir (k := k)) (map (C : k →+* affineTwoRing k) H) =
      specializedConicFreeDirForm F *
        (freePolarForm F v *
            polarEval (map (C : k →+* affineTwoRing k) H) (liftTsenSection v)
              (affineTwoStereoDir (k := k)) -
          specializedConicFreeDirForm F *
            eval (liftTsenSection v) (map (C : k →+* affineTwoRing k) H)) := by
  set Q := specializedConicPullback F
  set p := liftTsenSection v
  set w := affineTwoStereoDir (k := k)
  set α := specializedConicFreeDirForm F
  set B := freePolarForm F v
  set HC := map (C : k →+* affineTwoRing k) H
  have hHC : HC.IsHomogeneous 2 := hH.map _
  have hx : residualImageXCoords F v = stereoAlg Q p w := by
    simp [residualImageXCoords, stereoFirstCoords, Q, p, w]
  have hvan' : eval (stereoAlg Q p w) HC = 0 := by
    simpa [hx, HC] using hvan
  have hα : α = eval w Q := by
    simp [α, specializedConicFreeDirForm, w, Q]
  have hB : B = polarEval Q p w := by
    simp [B, freePolarForm, Q, p, w]
  have hexp := eval_stereoAlg_of_isHomogeneous_two Q HC hHC p w
  have hexp' :
      α * α * eval p HC - α * B * polarEval HC p w + B * B * eval w HC = 0 := by
    have hexp0 :
        eval w Q * eval w Q * eval p HC -
          eval w Q * polarEval Q p w * polarEval HC p w +
            polarEval Q p w * polarEval Q p w * eval w HC = 0 := by
      rw [← hexp]; exact hvan'
    rw [← hα, ← hB] at hexp0
    exact hexp0
  -- Rearrange: B² H(w) = α (B polar_H - α H(p))
  linear_combination hexp'

/-- Evaluation of `map C H` on the free direction equals the freeDirUnivariate polynomial. -/
theorem eval_affineTwoStereoDir_map_C
    {k : Type u} [Field k]
    (H : MvPolynomial (Fin 3) k) (hH : H.IsHomogeneous 2) :
    eval (affineTwoStereoDir (k := k)) (map (C : k →+* affineTwoRing k) H) =
      Polynomial.eval₂ (C : k →+* affineTwoRing k) (affineTwoCoord1 k)
        (freeDirUnivariate H) := by
  have h10 : ternaryQuadraticCoeff H 1 0 = 0 := by
    simp [ternaryQuadraticCoeff, show ¬ (1 : Fin 3) < 0 by decide]
  have h20 : ternaryQuadraticCoeff H 2 0 = 0 := by
    simp [ternaryQuadraticCoeff, show ¬ (2 : Fin 3) < 0 by decide]
  have h21 : ternaryQuadraticCoeff H 2 1 = 0 := by
    simp [ternaryQuadraticCoeff, show ¬ (2 : Fin 3) < 1 by decide]
  have hsum := eval_eq_ternaryQuadraticCoeff_sum (hH.map (C : k →+* affineTwoRing k))
    (affineTwoStereoDir (k := k))
  have hcoeff (i j : Fin 3) :
      ternaryQuadraticCoeff (map (C : k →+* affineTwoRing k) H) i j =
        C (ternaryQuadraticCoeff H i j) := by
    simp only [ternaryQuadraticCoeff, coeff_map]
    split_ifs <;> simp
  rw [hsum]
  simp only [Fin.sum_univ_three, hcoeff, h10, h20, h21, affineTwoStereoDir,
    Matrix.cons_val_zero, Matrix.cons_val_one, Matrix.head_cons, Matrix.cons_val_two,
    Matrix.tail_cons, map_zero, mul_zero, zero_mul, zero_add, add_zero, mul_one, one_mul]
  simp only [freeDirUnivariate, Polynomial.eval₂_add, Polynomial.eval₂_mul, Polynomial.eval₂_C,
    Polynomial.eval₂_X, Polynomial.eval₂_pow]
  ring


/-- Specialize `eval₂ C s` along the affine plane at `(t,s)`. -/
theorem evalAffineTwoPoint_eval₂_C_affineTwoCoord1
    {k : Type u} [Field k] (t s : k) (p : Polynomial k) :
    evalAffineTwoPoint t s
        (Polynomial.eval₂ (C : k →+* affineTwoRing k) (affineTwoCoord1 k) p) =
      Polynomial.eval s p := by
  have h :
      evalAffineTwoPoint t s
          (Polynomial.eval₂ (C : k →+* affineTwoRing k) (affineTwoCoord1 k) p) =
        Polynomial.eval₂ ((evalAffineTwoPoint t s).comp (C : k →+* affineTwoRing k))
          (evalAffineTwoPoint t s (affineTwoCoord1 k)) p :=
    Polynomial.hom_eval₂ (f := (C : k →+* affineTwoRing k))
      (g := evalAffineTwoPoint t s) (x := affineTwoCoord1 k) (p := p)
  rw [h]
  have hC : (evalAffineTwoPoint t s).comp (C : k →+* affineTwoRing k) = RingHom.id k := by
    ext a; simp [evalAffineTwoPoint, eval_C]
  have hx : evalAffineTwoPoint t s (affineTwoCoord1 k) = s := by
    simp [affineTwoCoord1, evalAffineTwoPoint, eval_X]
  rw [hC, hx, Polynomial.eval₂_id]

/-- From the division identity: freeDir zero and polar nonzero force freeDirUnivariate H at s. -/
theorem freeDirUnivariate_eval_eq_zero_of_freeDir_polar_eval
    {k : Type u} [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (v : Fin 3 → Polynomial k)
    (H : MvPolynomial (Fin 3) k) (hH : H.IsHomogeneous 2)
    (hvan : eval (residualImageXCoords F v) (map (C : k →+* affineTwoRing k) H) = 0)
    (t s : k)
    (hα0 : evalAffineTwoPoint t s (specializedConicFreeDirForm F) = 0)
    (hB : evalAffineTwoPoint t s (freePolarForm F v) ≠ 0) :
    Polynomial.eval s (freeDirUnivariate H) = 0 := by
  have hid := freeDir_mul_eq_of_eval_residualImageXCoords F hF v H hH hvan
  have hpt := congrArg (evalAffineTwoPoint t s) hid
  have hwe :
      evalAffineTwoPoint t s
          (eval (affineTwoStereoDir (k := k)) (map (C : k →+* affineTwoRing k) H)) =
        Polynomial.eval s (freeDirUnivariate H) := by
    rw [eval_affineTwoStereoDir_map_C H hH]
    exact evalAffineTwoPoint_eval₂_C_affineTwoCoord1 t s _
  have hpt' :
      evalAffineTwoPoint t s (freePolarForm F v) *
          evalAffineTwoPoint t s (freePolarForm F v) *
            evalAffineTwoPoint t s
              (eval (affineTwoStereoDir (k := k)) (map (C : k →+* affineTwoRing k) H)) =
        evalAffineTwoPoint t s (specializedConicFreeDirForm F) *
          evalAffineTwoPoint t s
            (freePolarForm F v *
                polarEval (map (C : k →+* affineTwoRing k) H) (liftTsenSection v)
                  (affineTwoStereoDir (k := k)) -
              specializedConicFreeDirForm F *
                eval (liftTsenSection v) (map (C : k →+* affineTwoRing k) H)) := by
    simpa [map_mul, map_sub] using hpt
  have hB2φ :
      evalAffineTwoPoint t s (freePolarForm F v) *
          evalAffineTwoPoint t s (freePolarForm F v) *
            Polynomial.eval s (freeDirUnivariate H) = 0 := by
    calc
      _ = evalAffineTwoPoint t s (freePolarForm F v) *
            evalAffineTwoPoint t s (freePolarForm F v) *
              evalAffineTwoPoint t s
                (eval (affineTwoStereoDir (k := k)) (map (C : k →+* affineTwoRing k) H)) := by
          rw [hwe]
      _ = evalAffineTwoPoint t s (specializedConicFreeDirForm F) *
            evalAffineTwoPoint t s
              (freePolarForm F v *
                  polarEval (map (C : k →+* affineTwoRing k) H) (liftTsenSection v)
                    (affineTwoStereoDir (k := k)) -
                specializedConicFreeDirForm F *
                  eval (liftTsenSection v) (map (C : k →+* affineTwoRing k) H)) := hpt'
      _ = 0 := by rw [hα0, zero_mul]
  exact (mul_eq_zero.mp hB2φ).resolve_left (mul_ne_zero hB hB)

/-- Same conclusion from freeDirPolyT root + specialized polar. -/
theorem freeDirUnivariate_eval_eq_zero_of_freeDirPolyT_root_polar_ne
    {k : Type u} [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (v : Fin 3 → Polynomial k)
    (H : MvPolynomial (Fin 3) k) (hH : H.IsHomogeneous 2)
    (hvan : eval (residualImageXCoords F v) (map (C : k →+* affineTwoRing k) H) = 0)
    (t s : k)
    (hα0 : Polynomial.eval t (freeDirPolyT F s) = 0)
    (hB : polarEval (coordinateLineSpecializedConic F t) (evalPolySection v t)
      (stereographicDirection s) ≠ 0) :
    Polynomial.eval s (freeDirUnivariate H) = 0 := by
  refine freeDirUnivariate_eval_eq_zero_of_freeDir_polar_eval F hF v H hH hvan t s ?_ ?_
  · rwa [evalAffineTwoPoint_specializedConicFreeDirForm_eq_eval_freeDirPolyT F hF t s]
  · rwa [evalAffineTwoPoint_freePolarForm F hF v t s]

/-- freeDirUnivariate vanishes identically if every `s` admits a freeDir root with nonzero polar. -/
theorem freeDirUnivariate_eq_zero_of_forall_exists_freeDir_polar
    {k : Type u} [Field k] [IsDomain k] [Infinite k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (v : Fin 3 → Polynomial k)
    (H : MvPolynomial (Fin 3) k) (hH : H.IsHomogeneous 2)
    (hvan : eval (residualImageXCoords F v) (map (C : k →+* affineTwoRing k) H) = 0)
    (hroot : ∀ s : k, ∃ t : k,
      evalAffineTwoPoint t s (specializedConicFreeDirForm F) = 0 ∧
        evalAffineTwoPoint t s (freePolarForm F v) ≠ 0) :
    freeDirUnivariate H = 0 := by
  refine Polynomial.funext fun s => ?_
  obtain ⟨t, hα0, hB⟩ := hroot s
  have := freeDirUnivariate_eval_eq_zero_of_freeDir_polar_eval F hF v H hH hvan t s hα0 hB
  simpa using this


/-- Free residual linear form vanishes at `s` when freeDir vanishes with nonzero polar. -/
theorem Lfree_eval_eq_zero_of_freeDir_polar
    {k : Type u} [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (v : Fin 3 → Polynomial k)
    (c02 c12 c22 : k)
    (hlin :
      C c02 * residualImageXCoords F v 0 +
        C c12 * residualImageXCoords F v 1 +
          C c22 * residualImageXCoords F v 2 = 0)
    (t s : k)
    (hα0 : evalAffineTwoPoint t s (specializedConicFreeDirForm F) = 0)
    (hB : evalAffineTwoPoint t s (freePolarForm F v) ≠ 0) :
    c02 + c12 * s = 0 := by
  have hid := freeDir_mul_Lp_eq_polar_mul_Lfree F v c02 c12 c22 hlin
  have hpt := congrArg (evalAffineTwoPoint t s) hid
  have hLf :
      evalAffineTwoPoint t s (C c02 + C c12 * affineTwoCoord1 k) = c02 + c12 * s := by
    simp [evalAffineTwoPoint, affineTwoCoord1, eval_add, eval_mul, eval_C, eval_X]
  have hBLf :
      evalAffineTwoPoint t s (freePolarForm F v) * (c02 + c12 * s) = 0 := by
    simp only [freePolarForm] at hpt hB ⊢
    have h' :
        evalAffineTwoPoint t s (specializedConicFreeDirForm F) *
            evalAffineTwoPoint t s
              (C c02 * liftTsenSection v 0 + C c12 * liftTsenSection v 1 +
                C c22 * liftTsenSection v 2) =
          evalAffineTwoPoint t s
              (polarEval (specializedConicPullback F) (liftTsenSection v)
                (affineTwoStereoDir (k := k))) *
            evalAffineTwoPoint t s (C c02 + C c12 * affineTwoCoord1 k) := by
      simpa [map_mul, map_add] using hpt
    rw [hα0, zero_mul, hLf] at h'
    exact h'.symm
  exact (mul_eq_zero.mp hBLf).resolve_left hB

/-- Free residual linear coefficients vanish under a freeDir+polar root for every `s`. -/
theorem Lfree_eq_zero_of_forall_exists_freeDir_polar
    {k : Type u} [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (v : Fin 3 → Polynomial k)
    (c02 c12 c22 : k)
    (hlin :
      C c02 * residualImageXCoords F v 0 +
        C c12 * residualImageXCoords F v 1 +
          C c22 * residualImageXCoords F v 2 = 0)
    (hroot : ∀ s : k, ∃ t : k,
      evalAffineTwoPoint t s (specializedConicFreeDirForm F) = 0 ∧
        evalAffineTwoPoint t s (freePolarForm F v) ≠ 0) :
    c02 = 0 ∧ c12 = 0 := by
  have h0 : c02 + c12 * (0 : k) = 0 := by
    obtain ⟨t, hα0, hB⟩ := hroot 0
    exact Lfree_eval_eq_zero_of_freeDir_polar F v c02 c12 c22 hlin t 0 hα0 hB
  have h1 : c02 + c12 * (1 : k) = 0 := by
    obtain ⟨t, hα0, hB⟩ := hroot 1
    exact Lfree_eval_eq_zero_of_freeDir_polar F v c02 c12 c22 hlin t 1 hα0 hB
  have hc02 : c02 = 0 := by simpa using h0
  have hc12 : c12 = 0 := by simpa [hc02] using h1
  exact ⟨hc02, hc12⟩

/-- Denseness of residual stereo for homog deg-2 forms, under freeDir+polar roots for all `s`. -/
theorem eq_zero_of_aeval_residualImageXCoords_eq_zero_of_isHomogeneous_two_of_roots
    {k : Type u} [Field k] [IsAlgClosed k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (v : Fin 3 → Polynomial k)
    (H : MvPolynomial (Fin 3) k) (hH : H.IsHomogeneous 2)
    (hst2 : residualImageXCoords F v 2 ≠ 0)
    (hvan : eval (residualImageXCoords F v) (map (C : k →+* affineTwoRing k) H) = 0)
    (hroot : ∀ s : k, ∃ t : k,
      evalAffineTwoPoint t s (specializedConicFreeDirForm F) = 0 ∧
        evalAffineTwoPoint t s (freePolarForm F v) ≠ 0) :
    H = 0 := by
  classical
  haveI : Infinite k := inferInstance
  have hfree :=
    freeDirUnivariate_eq_zero_of_forall_exists_freeDir_polar F hF v H hH hvan hroot
  have hlin :=
    residual_linear_eq_zero_of_freeDirUnivariate F v H hH hfree hst2 hvan
  set c02 := ternaryQuadraticCoeff H 0 2
  set c12 := ternaryQuadraticCoeff H 1 2
  set c22 := ternaryQuadraticCoeff H 2 2
  have hLfree :=
    Lfree_eq_zero_of_forall_exists_freeDir_polar F v c02 c12 c22 hlin hroot
  exact eq_zero_of_freeDirUnivariate_residualX2_Lfree F v H hH hfree hst2 hvan hLfree

/-- freeDirPolyT of positive degree has a root over an alg closed field. -/
theorem exists_root_of_freeDirPolyT_degree_ne_zero
    {k : Type u} [Field k] [IsAlgClosed k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (s : k)
    (hdeg : (freeDirPolyT F s).degree ≠ 0) :
    ∃ t : k, Polynomial.eval t (freeDirPolyT F s) = 0 := by
  obtain ⟨t, ht⟩ := IsAlgClosed.exists_root (freeDirPolyT F s) hdeg
  exact ⟨t, by simpa [Polynomial.IsRoot] using ht⟩


/-- freeDirUnivariate vanishes if it has infinitely many roots. -/
theorem freeDirUnivariate_eq_zero_of_infinite_roots
    {k : Type u} [Field k] [IsDomain k]
    (H : MvPolynomial (Fin 3) k)
    (hinf : {s : k | Polynomial.eval s (freeDirUnivariate H) = 0}.Infinite) :
    freeDirUnivariate H = 0 := by
  refine Polynomial.eq_zero_of_infinite_isRoot (freeDirUnivariate H) ?_
  refine hinf.mono fun s hs => ?_
  simpa [Polynomial.IsRoot] using hs

/-- The three free-plane coefficient polynomials of the specialized conic pencil. -/
noncomputable def freeDirCoeffT
    {k : Type u} [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (i j : Fin 3) : Polynomial k :=
  ternaryQuadraticCoeff (coordinateLineSpecializedConicPoly F) i j

/-- freeDir depends on `t` when some free-plane pencil coefficient has positive degree. -/
def freeDirDependsOnT
    {k : Type u} [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) : Prop :=
  (freeDirCoeffT F 0 0).natDegree ≠ 0 ∨
    (freeDirCoeffT F 0 1).natDegree ≠ 0 ∨
      (freeDirCoeffT F 1 1).natDegree ≠ 0

theorem freeDirPolyT_eq_coeff_sum
    {k : Type u} [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (s : k) :
    freeDirPolyT F s =
      freeDirCoeffT F 0 0 +
        freeDirCoeffT F 0 1 * Polynomial.C s +
          freeDirCoeffT F 1 1 * Polynomial.C s ^ 2 :=
  rfl

/-- Auxiliary poly in `s` extracting the coefficient of `t^n` in freeDirPolyT. -/
noncomputable def freeDirPolyT_coeffN
    {k : Type u} [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (n : ℕ) : Polynomial k :=
  Polynomial.C ((freeDirCoeffT F 0 0).coeff n) +
    Polynomial.C ((freeDirCoeffT F 0 1).coeff n) * Polynomial.X +
      Polynomial.C ((freeDirCoeffT F 1 1).coeff n) * Polynomial.X ^ 2

theorem coeff_freeDirPolyT_eq_eval_coeffN
    {k : Type u} [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (s : k) (n : ℕ) :
    (freeDirPolyT F s).coeff n = Polynomial.eval s (freeDirPolyT_coeffN F n) := by
  set a0 := freeDirCoeffT F 0 0
  set a1 := freeDirCoeffT F 0 1
  set a2 := freeDirCoeffT F 1 1
  have hsum : freeDirPolyT F s = a0 + a1 * Polynomial.C s + a2 * Polynomial.C s ^ 2 := by
    simp only [freeDirPolyT_eq_coeff_sum, a0, a1, a2]
  have h1 : (a1 * Polynomial.C s).coeff n = a1.coeff n * s := Polynomial.coeff_mul_C a1 n s
  have h2 : (a2 * Polynomial.C s ^ 2).coeff n = a2.coeff n * s ^ 2 := by
    rw [pow_two, ← mul_assoc, Polynomial.coeff_mul_C, Polynomial.coeff_mul_C]
    ring
  have hLHS : (freeDirPolyT F s).coeff n =
      a0.coeff n + a1.coeff n * s + a2.coeff n * s ^ 2 := by
    rw [hsum, Polynomial.coeff_add, Polynomial.coeff_add, h1, h2]
  have hRHS : Polynomial.eval s (freeDirPolyT_coeffN F n) =
      a0.coeff n + a1.coeff n * s + a2.coeff n * s ^ 2 := by
    simp only [freeDirPolyT_coeffN, a0, a1, a2, freeDirCoeffT, Polynomial.eval_add,
      Polynomial.eval_mul, Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow]
  exact hLHS.trans hRHS.symm

private theorem leadingCoeff_ne_zero_of_natDegree_ne_zero
    {k : Type u} [Field k] {p : Polynomial k} (h : p.natDegree ≠ 0) :
    p.coeff p.natDegree ≠ 0 := by
  have hp0 : p ≠ 0 := fun hp0 => by
    rw [hp0, Polynomial.natDegree_zero] at h
    exact h rfl
  rw [Polynomial.coeff_natDegree]
  exact mt Polynomial.leadingCoeff_eq_zero.mp hp0

/-- If freeDir depends on `t`, some `freeDirPolyT_coeffN` is a nonzero poly in `s`. -/
theorem exists_coeffN_ne_zero_of_freeDirDependsOnT
    {k : Type u} [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (hdep : freeDirDependsOnT F) :
    ∃ n : ℕ, 0 < n ∧ freeDirPolyT_coeffN F n ≠ 0 := by
  classical
  rcases hdep with h | h | h
  · refine ⟨(freeDirCoeffT F 0 0).natDegree, Nat.pos_of_ne_zero h, ?_⟩
    intro hcn
    have hlead := leadingCoeff_ne_zero_of_natDegree_ne_zero h
    have e0 : (freeDirCoeffT F 0 0).coeff (freeDirCoeffT F 0 0).natDegree = 0 := by
      have := congrArg (fun p : Polynomial k => p.coeff 0) hcn
      simpa [freeDirPolyT_coeffN, Polynomial.coeff_add, Polynomial.coeff_C_mul,
        Polynomial.coeff_X_pow, Polynomial.coeff_X, Polynomial.coeff_C,
        Polynomial.coeff_zero] using this
    exact hlead e0
  · refine ⟨(freeDirCoeffT F 0 1).natDegree, Nat.pos_of_ne_zero h, ?_⟩
    intro hcn
    have hlead := leadingCoeff_ne_zero_of_natDegree_ne_zero h
    have e1 : (freeDirCoeffT F 0 1).coeff (freeDirCoeffT F 0 1).natDegree = 0 := by
      have := congrArg (fun p : Polynomial k => p.coeff 1) hcn
      simpa [freeDirPolyT_coeffN, Polynomial.coeff_add, Polynomial.coeff_C_mul,
        Polynomial.coeff_X_pow, Polynomial.coeff_X, Polynomial.coeff_C,
        Polynomial.coeff_zero] using this
    exact hlead e1
  · refine ⟨(freeDirCoeffT F 1 1).natDegree, Nat.pos_of_ne_zero h, ?_⟩
    intro hcn
    have hlead := leadingCoeff_ne_zero_of_natDegree_ne_zero h
    have e2 : (freeDirCoeffT F 1 1).coeff (freeDirCoeffT F 1 1).natDegree = 0 := by
      have := congrArg (fun p : Polynomial k => p.coeff 2) hcn
      simpa [freeDirPolyT_coeffN, Polynomial.coeff_add, Polynomial.coeff_C_mul,
        Polynomial.coeff_X_pow, Polynomial.coeff_X, Polynomial.coeff_C,
        Polynomial.coeff_zero] using this
    exact hlead e2

/-- Outside the roots of a nonzero `coeffN`, freeDirPolyT has nonzero degree. -/
theorem freeDirPolyT_degree_ne_zero_of_coeffN_eval_ne
    {k : Type u} [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (s : k) (n : ℕ)
    (hn : 0 < n) (hne : Polynomial.eval s (freeDirPolyT_coeffN F n) ≠ 0) :
    (freeDirPolyT F s).degree ≠ 0 := by
  have hcoeff : (freeDirPolyT F s).coeff n ≠ 0 := by
    rwa [coeff_freeDirPolyT_eq_eval_coeffN]
  have hle : n ≤ (freeDirPolyT F s).natDegree :=
    Polynomial.le_natDegree_of_ne_zero hcoeff
  have hnat : (freeDirPolyT F s).natDegree ≠ 0 := by omega
  have hp0 : freeDirPolyT F s ≠ 0 := fun hp0 => by
    rw [hp0, Polynomial.natDegree_zero] at hnat
    exact hnat rfl
  intro hdeg0
  have hnat0 : (freeDirPolyT F s).natDegree = 0 := by
    rw [Polynomial.degree_eq_natDegree hp0] at hdeg0
    exact WithBot.coe_eq_coe.mp hdeg0
  exact hnat hnat0


/-- Outside finitely many `s`, freeDirPolyT has nonzero degree when freeDir depends on `t`. -/
theorem exists_finite_bad_s_of_freeDirDependsOnT
    {k : Type u} [Field k] [IsAlgClosed k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (hdep : freeDirDependsOnT F) :
    ∃ B : Finset k, ∀ s ∉ B, (freeDirPolyT F s).degree ≠ 0 := by
  classical
  obtain ⟨n, hn, hcn⟩ := exists_coeffN_ne_zero_of_freeDirDependsOnT F hdep
  refine ⟨(freeDirPolyT_coeffN F n).roots.toFinset, fun s hs => ?_⟩
  have hne : Polynomial.eval s (freeDirPolyT_coeffN F n) ≠ 0 := by
    intro h0
    have : s ∈ (freeDirPolyT_coeffN F n).roots.toFinset := by
      simp only [Multiset.mem_toFinset, Polynomial.mem_roots hcn, Polynomial.IsRoot.def, h0]
    exact hs this
  exact freeDirPolyT_degree_ne_zero_of_coeffN_eval_ne F s n hn hne


/-! ### FreeDir+polar roots for cofinite `s` and denseness -/

/-- denseness under infinite freeDir+polar roots (weaker than forall s). -/
theorem freeDirUnivariate_eq_zero_of_infinite_freeDir_polar_roots
    {k : Type u} [Field k] [IsAlgClosed k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (v : Fin 3 → Polynomial k)
    (H : MvPolynomial (Fin 3) k) (hH : H.IsHomogeneous 2)
    (hvan : eval (residualImageXCoords F v) (map (C : k →+* affineTwoRing k) H) = 0)
    (hinf : {s : k | ∃ t : k,
        evalAffineTwoPoint t s (specializedConicFreeDirForm F) = 0 ∧
          evalAffineTwoPoint t s (freePolarForm F v) ≠ 0}.Infinite) :
    freeDirUnivariate H = 0 := by
  classical
  refine freeDirUnivariate_eq_zero_of_infinite_roots H ?_
  refine hinf.mono fun s hs => ?_
  obtain ⟨t, hα0, hB⟩ := hs
  exact freeDirUnivariate_eval_eq_zero_of_freeDir_polar_eval F hF v H hH hvan t s hα0 hB

/-- L_free vanishes for infinitely many s ⇒ coefficients zero. -/
theorem Lfree_eq_zero_of_infinite_roots
    {k : Type u} [Field k] [Infinite k]
    (c02 c12 : k)
    (hinf : {s : k | c02 + c12 * s = 0}.Infinite) :
    c02 = 0 ∧ c12 = 0 := by
  classical
  -- c02 + c12 * X as poly has infinitely many roots ⇒ zero
  set p : Polynomial k := Polynomial.C c02 + Polynomial.C c12 * Polynomial.X
  have hp : p = 0 := by
    refine Polynomial.eq_zero_of_infinite_isRoot p ?_
    refine hinf.mono fun s hs => ?_
    simpa [p, Polynomial.IsRoot, Polynomial.eval_add, Polynomial.eval_mul, Polynomial.eval_C,
      Polynomial.eval_X] using hs
  have h0 := congrArg (fun q : Polynomial k => q.coeff 0) hp
  have h1 := congrArg (fun q : Polynomial k => q.coeff 1) hp
  refine ⟨?_, ?_⟩
  · simpa [p] using h0
  · simpa [p] using h1

/-- Denseness under infinite freeDir+polar roots and residualX₂ ≠ 0. -/
theorem eq_zero_of_aeval_residualImageXCoords_eq_zero_of_isHomogeneous_two_of_infinite_roots
    {k : Type u} [Field k] [IsAlgClosed k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (v : Fin 3 → Polynomial k)
    (H : MvPolynomial (Fin 3) k) (hH : H.IsHomogeneous 2)
    (hst2 : residualImageXCoords F v 2 ≠ 0)
    (hvan : eval (residualImageXCoords F v) (map (C : k →+* affineTwoRing k) H) = 0)
    (hinf : {s : k | ∃ t : k,
        evalAffineTwoPoint t s (specializedConicFreeDirForm F) = 0 ∧
          evalAffineTwoPoint t s (freePolarForm F v) ≠ 0}.Infinite) :
    H = 0 := by
  classical
  haveI : Infinite k := inferInstance
  have hfree :=
    freeDirUnivariate_eq_zero_of_infinite_freeDir_polar_roots F hF v H hH hvan hinf
  have hlin :=
    residual_linear_eq_zero_of_freeDirUnivariate F v H hH hfree hst2 hvan
  set c02 := ternaryQuadraticCoeff H 0 2
  set c12 := ternaryQuadraticCoeff H 1 2
  set c22 := ternaryQuadraticCoeff H 2 2
  have hLfree_inf : {s : k | c02 + c12 * s = 0}.Infinite := by
    refine hinf.mono fun s hs => ?_
    obtain ⟨t, hα0, hB⟩ := hs
    exact Lfree_eval_eq_zero_of_freeDir_polar F v c02 c12 c22 hlin t s hα0 hB
  have hLfree := Lfree_eq_zero_of_infinite_roots c02 c12 hLfree_inf
  exact eq_zero_of_freeDirUnivariate_residualX2_Lfree F v H hH hfree hst2 hvan hLfree

/-- Cofinite freeDir roots when freeDir depends on `t`. -/
theorem exists_freeDir_root_of_freeDirDependsOnT
    {k : Type u} [Field k] [IsAlgClosed k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (hdep : freeDirDependsOnT F) :
    ∃ B : Finset k, ∀ s ∉ B, ∃ t : k,
      evalAffineTwoPoint t s (specializedConicFreeDirForm F) = 0 := by
  classical
  obtain ⟨B, hB⟩ := exists_finite_bad_s_of_freeDirDependsOnT F hdep
  refine ⟨B, fun s hs => ?_⟩
  obtain ⟨t, ht⟩ := exists_root_of_freeDirPolyT_degree_ne_zero F s (hB s hs)
  refine ⟨t, ?_⟩
  rwa [evalAffineTwoPoint_specializedConicFreeDirForm_eq_eval_freeDirPolyT F hF t s]

/-- Map `C` through `specializeSecondCoordinates`. -/
theorem map_C_specializeSecond
    {k : Type u} [Field k]
    (y : Fin 3 → k) (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) :
    map (C : k →+* affineTwoRing k) (specializeSecondCoordinates (m := 2) y F) =
      specializeSecondCoordinates (m := 2) (fun i => (C : k →+* affineTwoRing k) (y i))
        (map (C : k →+* affineTwoRing k) F) := by
  induction F using MvPolynomial.induction_on with
  | C c => simp [map_C]
  | add f g hf hg => simp [map_add, hf, hg]
  | mul_X f i hf =>
      cases i with
      | inl j => simp only [map_mul, map_X, hf, specializeSecondCoordinates_X_inl]
      | inr j => simp only [map_mul, map_C, map_X, hf, specializeSecondCoordinates_X_inr]

/-- `map C (specializeSecond e0 F)` at residual stereo equals cubic fiber at e0. -/
theorem eval_residual_map_C_specializeSecond_e0
    {k : Type u} [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (v : Fin 3 → Polynomial k) :
    eval (residualImageXCoords F v)
        (map (C : k →+* affineTwoRing k)
          (specializeSecondCoordinates (m := 2) (![1, 0, (0 : k)]) F)) =
      eval ![1, 0, (0 : affineTwoRing k)]
        (cubicFiberPullback F (residualImageXCoords F v)) := by
  set x := residualImageXCoords F v
  set yk : Fin 3 → k := ![1, 0, 0]
  set y0 : Fin 3 → affineTwoRing k := fun i => C (yk i)
  have hy : y0 = ![1, 0, (0 : affineTwoRing k)] := by
    funext i; fin_cases i <;> simp [y0, yk]
  have hmap := map_C_specializeSecond yk F
  rw [hmap]
  have h1 : eval x (specializeSecondCoordinates (m := 2) y0 (map (C : k →+* affineTwoRing k) F)) =
      eval (Sum.elim x y0) (map (C : k →+* affineTwoRing k) F) :=
    eval_specializeSecondCoordinates x y0 (map (C : k →+* affineTwoRing k) F)
  rw [h1]
  have h2 : eval y0 (cubicFiberPullback F x) =
      eval (Sum.elim x y0) (affineTwoPullback F) := by
    simp only [cubicFiberPullback, eval_specializeFirstCoordinates]
  have hpull : affineTwoPullback F = map (C : k →+* affineTwoRing k) F := rfl
  have hrhs : eval ![1, 0, (0 : affineTwoRing k)] (cubicFiberPullback F x) =
      eval y0 (cubicFiberPullback F x) := by rw [hy]
  rw [hrhs, h2, hpull]


/-! Residual-Y L-branch assembly (uses denseness of `specializeSecond e0`):
`residualYCoords_ne_zero_of_smooth_L_branch` is deferred to avoid elaborator timeouts in this
module; the supporting lemmas `eval_residual_map_C_specializeSecond_e0`,
`eq_zero_of_aeval_residualImageXCoords_eq_zero_of_isHomogeneous_two_of_infinite_roots`, and
L-branch geometry (`eval_on_L_*`, `cubicFiberPullback_stereo_eq_X2_mul_of_eval_on_L`) are green.
-/


/-- freeDirUnivariate has degree at most 2. -/
theorem freeDirUnivariate_natDegree_le_two
    {k : Type u} [Field k] (H : MvPolynomial (Fin 3) k) :
    (freeDirUnivariate H).natDegree ≤ 2 := by
  simp only [freeDirUnivariate]
  have h0 : (Polynomial.C (ternaryQuadraticCoeff H 0 0) : Polynomial k).natDegree ≤ 2 := by
    simp [Polynomial.natDegree_C]
  have h1 :
      ((Polynomial.C (ternaryQuadraticCoeff H 0 1) : Polynomial k) * Polynomial.X).natDegree ≤
        2 := by
    refine (Polynomial.natDegree_mul_le).trans ?_
    simp [Polynomial.natDegree_C, Polynomial.natDegree_X]
  have h2 :
      ((Polynomial.C (ternaryQuadraticCoeff H 1 1) : Polynomial k) * Polynomial.X ^ 2).natDegree ≤
        2 := by
    refine (Polynomial.natDegree_mul_le).trans ?_
    simp [Polynomial.natDegree_C, Polynomial.natDegree_X_pow]
  refine (Polynomial.natDegree_add_le _ _).trans ?_
  simp only [max_le_iff]
  exact ⟨(Polynomial.natDegree_add_le _ _).trans (by simp [h0, h1]), h2⟩

/-- A degree-≤2 univariate with three distinct roots is zero. -/
theorem eq_zero_of_three_roots_of_natDegree_le_two
    {k : Type u} [Field k]
    (p : Polynomial k) (hp : p.natDegree ≤ 2)
    (s0 s1 s2 : k) (h01 : s0 ≠ s1) (h02 : s0 ≠ s2) (h12 : s1 ≠ s2)
    (h0 : Polynomial.eval s0 p = 0) (h1 : Polynomial.eval s1 p = 0)
    (h2 : Polynomial.eval s2 p = 0) :
    p = 0 := by
  classical
  by_cases hp0 : p = 0
  · exact hp0
  · have hs0 : s0 ∈ p.roots.toFinset := by
      rw [Multiset.mem_toFinset, Polynomial.mem_roots hp0, Polynomial.IsRoot.def]; exact h0
    have hs1 : s1 ∈ p.roots.toFinset := by
      rw [Multiset.mem_toFinset, Polynomial.mem_roots hp0, Polynomial.IsRoot.def]; exact h1
    have hs2 : s2 ∈ p.roots.toFinset := by
      rw [Multiset.mem_toFinset, Polynomial.mem_roots hp0, Polynomial.IsRoot.def]; exact h2
    have hsub : ({s0, s1, s2} : Finset k) ⊆ p.roots.toFinset := by
      intro x hx
      simp only [Finset.mem_insert, Finset.mem_singleton] at hx
      rcases hx with rfl | rfl | rfl <;> assumption
    have hcard3 : ({s0, s1, s2} : Finset k).card = 3 := by
      rw [Finset.card_insert_of_notMem, Finset.card_insert_of_notMem, Finset.card_singleton]
      · simp [h12]
      · simp [h01, h02]
    have hle3 : 3 ≤ p.roots.toFinset.card := by
      simpa [hcard3] using Finset.card_le_card hsub
    have hcard : p.roots.toFinset.card ≤ p.natDegree :=
      (Multiset.toFinset_card_le p.roots).trans (Polynomial.card_roots' p)
    omega

/-- freeDirUnivariate vanishes given three distinct freeDir+polar roots. -/
theorem freeDirUnivariate_eq_zero_of_three_freeDir_polar_roots
    {k : Type u} [Field k] [IsAlgClosed k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (v : Fin 3 → Polynomial k)
    (H : MvPolynomial (Fin 3) k) (hH : H.IsHomogeneous 2)
    (hvan : eval (residualImageXCoords F v) (map (C : k →+* affineTwoRing k) H) = 0)
    (s0 s1 s2 : k) (h01 : s0 ≠ s1) (h02 : s0 ≠ s2) (h12 : s1 ≠ s2)
    (hs0 : ∃ t : k, evalAffineTwoPoint t s0 (specializedConicFreeDirForm F) = 0 ∧
      evalAffineTwoPoint t s0 (freePolarForm F v) ≠ 0)
    (hs1 : ∃ t : k, evalAffineTwoPoint t s1 (specializedConicFreeDirForm F) = 0 ∧
      evalAffineTwoPoint t s1 (freePolarForm F v) ≠ 0)
    (hs2 : ∃ t : k, evalAffineTwoPoint t s2 (specializedConicFreeDirForm F) = 0 ∧
      evalAffineTwoPoint t s2 (freePolarForm F v) ≠ 0) :
    freeDirUnivariate H = 0 := by
  obtain ⟨t0, hα0, hB0⟩ := hs0
  obtain ⟨t1, hα1, hB1⟩ := hs1
  obtain ⟨t2, hα2, hB2⟩ := hs2
  have e0 := freeDirUnivariate_eval_eq_zero_of_freeDir_polar_eval F hF v H hH hvan t0 s0 hα0 hB0
  have e1 := freeDirUnivariate_eval_eq_zero_of_freeDir_polar_eval F hF v H hH hvan t1 s1 hα1 hB1
  have e2 := freeDirUnivariate_eval_eq_zero_of_freeDir_polar_eval F hF v H hH hvan t2 s2 hα2 hB2
  exact eq_zero_of_three_roots_of_natDegree_le_two (freeDirUnivariate H)
    (freeDirUnivariate_natDegree_le_two H) s0 s1 s2 h01 h02 h12 e0 e1 e2

/-- L_free coeffs vanish given two distinct freeDir+polar roots. -/
theorem Lfree_eq_zero_of_two_freeDir_polar_roots
    {k : Type u} [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (v : Fin 3 → Polynomial k)
    (c02 c12 c22 : k)
    (hlin :
      C c02 * residualImageXCoords F v 0 +
        C c12 * residualImageXCoords F v 1 +
          C c22 * residualImageXCoords F v 2 = 0)
    (s0 s1 : k) (h01 : s0 ≠ s1)
    (hs0 : ∃ t : k, evalAffineTwoPoint t s0 (specializedConicFreeDirForm F) = 0 ∧
      evalAffineTwoPoint t s0 (freePolarForm F v) ≠ 0)
    (hs1 : ∃ t : k, evalAffineTwoPoint t s1 (specializedConicFreeDirForm F) = 0 ∧
      evalAffineTwoPoint t s1 (freePolarForm F v) ≠ 0) :
    c02 = 0 ∧ c12 = 0 := by
  obtain ⟨t0, hα0, hB0⟩ := hs0
  obtain ⟨t1, hα1, hB1⟩ := hs1
  have e0 := Lfree_eval_eq_zero_of_freeDir_polar F v c02 c12 c22 hlin t0 s0 hα0 hB0
  have e1 := Lfree_eval_eq_zero_of_freeDir_polar F v c02 c12 c22 hlin t1 s1 hα1 hB1
  -- c02 + c12*s0 = 0, c02 + c12*s1 = 0
  have hc12 : c12 * (s0 - s1) = 0 := by linear_combination e0 - e1
  have hc12' : c12 = 0 := by
    have hne : (s0 - s1 : k) ≠ 0 := sub_ne_zero.mpr h01
    exact (mul_eq_zero.mp hc12).resolve_right hne
  have hc02 : c02 = 0 := by simpa [hc12'] using e0
  exact ⟨hc02, hc12'⟩

/-- Denseness given three distinct freeDir+polar roots and residualX₂ ≠ 0. -/
theorem eq_zero_of_aeval_residualImageXCoords_eq_zero_of_isHomogeneous_two_of_three_roots
    {k : Type u} [Field k] [IsAlgClosed k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (v : Fin 3 → Polynomial k)
    (H : MvPolynomial (Fin 3) k) (hH : H.IsHomogeneous 2)
    (hst2 : residualImageXCoords F v 2 ≠ 0)
    (hvan : eval (residualImageXCoords F v) (map (C : k →+* affineTwoRing k) H) = 0)
    (s0 s1 s2 : k) (h01 : s0 ≠ s1) (h02 : s0 ≠ s2) (h12 : s1 ≠ s2)
    (hs0 : ∃ t : k, evalAffineTwoPoint t s0 (specializedConicFreeDirForm F) = 0 ∧
      evalAffineTwoPoint t s0 (freePolarForm F v) ≠ 0)
    (hs1 : ∃ t : k, evalAffineTwoPoint t s1 (specializedConicFreeDirForm F) = 0 ∧
      evalAffineTwoPoint t s1 (freePolarForm F v) ≠ 0)
    (hs2 : ∃ t : k, evalAffineTwoPoint t s2 (specializedConicFreeDirForm F) = 0 ∧
      evalAffineTwoPoint t s2 (freePolarForm F v) ≠ 0) :
    H = 0 := by
  classical
  haveI : Infinite k := inferInstance
  have hfree :=
    freeDirUnivariate_eq_zero_of_three_freeDir_polar_roots F hF v H hH hvan
      s0 s1 s2 h01 h02 h12 hs0 hs1 hs2
  have hlin :=
    residual_linear_eq_zero_of_freeDirUnivariate F v H hH hfree hst2 hvan
  set c02 := ternaryQuadraticCoeff H 0 2
  set c12 := ternaryQuadraticCoeff H 1 2
  set c22 := ternaryQuadraticCoeff H 2 2
  have hLfree :=
    Lfree_eq_zero_of_two_freeDir_polar_roots F v c02 c12 c22 hlin s0 s1 h01 hs0 hs1
  exact eq_zero_of_freeDirUnivariate_residualX2_Lfree F v H hH hfree hst2 hvan hLfree


/-- Three distinct elements outside a finite set, over an infinite field. -/
theorem exists_three_notMem_finset
    {k : Type u} [Field k] [Infinite k] (B : Finset k) :
    ∃ s0 s1 s2 : k, s0 ∉ B ∧ s1 ∉ B ∧ s2 ∉ B ∧ s0 ≠ s1 ∧ s0 ≠ s2 ∧ s1 ≠ s2 := by
  classical
  have hinf : (Bᶜ : Set k).Infinite := B.finite_toSet.infinite_compl
  obtain ⟨s0, hs0⟩ := hinf.nonempty
  have hs0B : s0 ∉ B := by simpa [Set.mem_compl_iff] using hs0
  have hinf1 : ((B ∪ {s0} : Finset k)ᶜ : Set k).Infinite :=
    (B ∪ {s0}).finite_toSet.infinite_compl
  obtain ⟨s1, hs1⟩ := hinf1.nonempty
  have hs1B' : s1 ∉ (B ∪ {s0} : Finset k) := by simpa [Set.mem_compl_iff] using hs1
  have hs1B : s1 ∉ B := fun h => hs1B' (Finset.mem_union.mpr (Or.inl h))
  have h01 : s0 ≠ s1 := fun h => hs1B' (by simp [h])
  have hinf2 : ((B ∪ {s0, s1} : Finset k)ᶜ : Set k).Infinite :=
    (B ∪ {s0, s1}).finite_toSet.infinite_compl
  obtain ⟨s2, hs2⟩ := hinf2.nonempty
  have hs2B' : s2 ∉ (B ∪ {s0, s1} : Finset k) := by simpa [Set.mem_compl_iff] using hs2
  have hs2B : s2 ∉ B := fun h => hs2B' (Finset.mem_union.mpr (Or.inl h))
  have h02 : s0 ≠ s2 := fun h => hs2B' (by simp [h])
  have h12 : s1 ≠ s2 := fun h => hs2B' (by simp [h])
  exact ⟨s0, s1, s2, hs0B, hs1B, hs2B, h01, h02, h12⟩

/-- freeDirDependsOnT supplies three freeDir roots at distinct free parameters. -/
theorem exists_three_freeDir_roots_of_freeDirDependsOnT
    {k : Type u} [Field k] [IsAlgClosed k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (hdep : freeDirDependsOnT F) :
    ∃ s0 s1 s2 : k, s0 ≠ s1 ∧ s0 ≠ s2 ∧ s1 ≠ s2 ∧
      (∃ t : k, evalAffineTwoPoint t s0 (specializedConicFreeDirForm F) = 0) ∧
        (∃ t : k, evalAffineTwoPoint t s1 (specializedConicFreeDirForm F) = 0) ∧
          (∃ t : k, evalAffineTwoPoint t s2 (specializedConicFreeDirForm F) = 0) := by
  classical
  haveI : Infinite k := inferInstance
  obtain ⟨B, hB⟩ := exists_freeDir_root_of_freeDirDependsOnT F hF hdep
  obtain ⟨s0, s1, s2, hs0B, hs1B, hs2B, h01, h02, h12⟩ := exists_three_notMem_finset B
  exact ⟨s0, s1, s2, h01, h02, h12, hB s0 hs0B, hB s1 hs1B, hB s2 hs2B⟩


/-! ### Pure-`t` freeDir: polar nonvanishing and three good roots -/

/-- Polar form is additive in the free vector. -/
theorem polarEval_add_right
    {K : Type u} [CommRing K]
    (Q : MvPolynomial (Fin 3) K) (hQ : Q.IsHomogeneous 2)
    (p w1 w2 : Fin 3 → K) :
    polarEval Q p (w1 + w2) = polarEval Q p w1 + polarEval Q p w2 := by
  simp only [polarEval_eq_coeff_sum Q hQ, Pi.add_apply, Fin.sum_univ_three]
  ring

/-- Polar along free direction is affine-linear in the free parameter `s`. -/
theorem polarEval_stereographicDirection_eq_linear
    {K : Type u} [CommRing K]
    (Q : MvPolynomial (Fin 3) K) (hQ : Q.IsHomogeneous 2)
    (p : Fin 3 → K) (s : K) :
    polarEval Q p (stereographicDirection s) =
      polarEval Q p (![1, 0, (0 : K)]) + s * polarEval Q p (![0, 1, (0 : K)]) := by
  have hw : (stereographicDirection s : Fin 3 → K) =
      (![1, 0, (0 : K)] + s • (![0, 1, (0 : K)])) := by
    funext i; fin_cases i <;>
      simp [stereographicDirection, Pi.add_apply, Pi.smul_apply, smul_eq_mul]
  rw [hw, polarEval_add_right Q hQ, polarEval_smul_right Q hQ]

/-- If a ternary quadratic vanishes on the free plane and is polar-orthogonal to an off-plane
isotropic point, it vanishes everywhere. -/
theorem eval_eq_zero_of_vanishes_free_plane_and_polar
    {K : Type u} [Field K]
    (Q : MvPolynomial (Fin 3) K) (hQ : Q.IsHomogeneous 2)
    (p : Fin 3 → K) (hp : eval p Q = 0) (hp2 : p 2 ≠ 0)
    (hfree : ∀ a b : K, eval ![a, b, (0 : K)] Q = 0)
    (hpol0 : polarEval Q p (![1, 0, (0 : K)]) = 0)
    (hpol1 : polarEval Q p (![0, 1, (0 : K)]) = 0) :
    ∀ x : Fin 3 → K, eval x Q = 0 := by
  intro x
  set lam := x 2 * (p 2)⁻¹
  set w : Fin 3 → K := fun i => x i - lam * p i
  have hw2 : w 2 = 0 := by simp [w, lam]; field_simp [hp2]; ring
  have hx : x = fun i => lam * p i + w i := by funext i; simp [w]
  have hwfree : eval w Q = 0 := by
    have : w = ![w 0, w 1, (0 : K)] := by
      funext i; fin_cases i <;> simp [hw2]
    rw [this]; exact hfree (w 0) (w 1)
  have hpolw : polarEval Q p w = 0 := by
    have hw : w = w 0 • (![1, 0, (0 : K)]) + w 1 • (![0, 1, (0 : K)]) := by
      funext i; fin_cases i <;> simp [hw2, Pi.add_apply, Pi.smul_apply, smul_eq_mul]
    rw [hw, polarEval_add_right Q hQ, polarEval_smul_right Q hQ, polarEval_smul_right Q hQ,
      hpol0, hpol1]
    ring
  have hexp := eval_linComb_of_isHomogeneous_two Q hQ lam 1 p w
  simp only [one_mul, mul_one] at hexp
  rw [hx, hexp, hp, hwfree, hpolw]
  ring

/-- FreeDir independent of the free parameter `s` (pure-`t` form). -/
def freeDirPureT
    {k : Type u} [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) : Prop :=
  freeDirCoeffT F 0 1 = 0 ∧ freeDirCoeffT F 1 1 = 0

theorem freeDirPolyT_eq_coeff00_of_pureT
    {k : Type u} [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (hpure : freeDirPureT F) (s : k) :
    freeDirPolyT F s = freeDirCoeffT F 0 0 := by
  obtain ⟨h1, h2⟩ := hpure
  simp [freeDirPolyT_eq_coeff_sum, h1, h2]

theorem freeDirDependsOnT_of_pureT_natDegree
    {k : Type u} [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (_hpure : freeDirPureT F)
    (hdeg : (freeDirCoeffT F 0 0).natDegree ≠ 0) :
    freeDirDependsOnT F :=
  Or.inl hdeg

/-- At a pure-`t` freeDir root, specialized conics vanish on the free plane. -/
theorem eval_on_free_plane_of_pureT_freeDir_root
    {k : Type u} [Field k] [IsAlgClosed k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (hpure : freeDirPureT F)
    (t : k) (ht : Polynomial.eval t (freeDirCoeffT F 0 0) = 0) :
    ∀ a b : k, eval ![a, b, (0 : k)] (coordinateLineSpecializedConic F t) = 0 := by
  haveI : Infinite k := inferInstance
  have hQs : ∀ s : k,
      eval (stereographicDirection s) (coordinateLineSpecializedConic F t) = 0 := by
    intro s
    have hpoly : freeDirPolyT F s = freeDirCoeffT F 0 0 :=
      freeDirPolyT_eq_coeff00_of_pureT F hpure s
    rw [← eval_freeDirPolyT F hF t s, hpoly, ht]
  have huni : freeDirUnivariate (coordinateLineSpecializedConic F t) = 0 :=
    freeDirUnivariate_eq_zero_of_forall_eval (coordinateLineSpecializedConic F t)
      (coordinateLineSpecializedConic_isHomogeneous hF t) hQs
  exact eval_on_X2_zero_of_freeDirUnivariate_eq_zero
    (coordinateLineSpecializedConic F t)
    (coordinateLineSpecializedConic_isHomogeneous hF t) huni

/-- At pure-`t` freeDir root with `p₂ ≠ 0`, polar is not identically zero in `s`. -/
theorem not_polar_eq_zero_for_all_s_of_pureT_freeDir_root_p2_ne
    {k : Type u} [Field k] [IsAlgClosed k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (biprojectiveZeroLocusToSpec 2 2 k F)]
    (v : Fin 3 → Polynomial k)
    (hv : TernaryQuadraticPoly.eval (coordinateLineTernaryQuadraticPoly F) v = 0)
    (hpure : freeDirPureT F)
    (t : k) (ht : Polynomial.eval t (freeDirCoeffT F 0 0) = 0)
    (hp2 : Polynomial.eval t (v 2) ≠ 0) :
    ¬ (∀ s : k,
        polarEval (coordinateLineSpecializedConic F t) (evalPolySection v t)
          (stereographicDirection s) = 0) := by
  classical
  intro hpol_all
  set Q := coordinateLineSpecializedConic F t
  set p := evalPolySection v t
  have hQ : Q.IsHomogeneous 2 := coordinateLineSpecializedConic_isHomogeneous hF t
  have hp : eval p Q = 0 :=
    evalPolySection_isotropic_coordinateLineSpecializedConic F hF v hv t
  have hp2' : p 2 ≠ 0 := by simpa [p, evalPolySection] using hp2
  have hfree := eval_on_free_plane_of_pureT_freeDir_root F hF hpure t ht
  have hpol0 : polarEval Q p (![1, 0, (0 : k)]) = 0 := by
    have := hpol_all 0
    simpa [stereographicDirection] using this
  have hpol1 : polarEval Q p (![0, 1, (0 : k)]) = 0 := by
    have hlin1 := polarEval_stereographicDirection_eq_linear Q hQ p 1
    -- polar(stereo 1) = polar(e0) + polar(e1) = 0, and polar(e0)=0
    have hsum : polarEval Q p (![1, 0, (0 : k)]) + polarEval Q p (![0, 1, (0 : k)]) = 0 := by
      have h1 := hpol_all 1
      rw [hlin1] at h1
      simpa using h1
    simpa [hpol0] using hsum
  have hvan_all :=
    eval_eq_zero_of_vanishes_free_plane_and_polar Q hQ p hp hp2' hfree hpol0 hpol1
  have hQ0 : Q ≠ 0 := coordinateLineSpecializedConic_ne_zero_of_smooth k F hF hF0 t
  exact hQ0 (hQ.eq_zero_of_forall_eval_eq_zero hvan_all)

/-- Pure-`t` freeDir root with `p₂ ≠ 0` yields polar ≠ 0 for all but at most one `s`. -/
theorem exists_at_most_one_bad_s_of_pureT_freeDir_root_p2_ne
    {k : Type u} [Field k] [IsAlgClosed k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (biprojectiveZeroLocusToSpec 2 2 k F)]
    (v : Fin 3 → Polynomial k)
    (hv : TernaryQuadraticPoly.eval (coordinateLineTernaryQuadraticPoly F) v = 0)
    (hpure : freeDirPureT F)
    (t : k) (ht : Polynomial.eval t (freeDirCoeffT F 0 0) = 0)
    (hp2 : Polynomial.eval t (v 2) ≠ 0) :
    ∃ sBad : Option k, ∀ s : k,
      (∀ sb ∈ sBad, s ≠ sb) →
        polarEval (coordinateLineSpecializedConic F t) (evalPolySection v t)
          (stereographicDirection s) ≠ 0 := by
  classical
  set Q := coordinateLineSpecializedConic F t
  set p := evalPolySection v t
  have hQ : Q.IsHomogeneous 2 := coordinateLineSpecializedConic_isHomogeneous hF t
  set b0 := polarEval Q p (![1, 0, (0 : k)])
  set b1 := polarEval Q p (![0, 1, (0 : k)])
  have hlin : ∀ s : k, polarEval Q p (stereographicDirection s) = b0 + s * b1 :=
    fun s => polarEval_stereographicDirection_eq_linear Q hQ p s
  have hnot_both : ¬ (b0 = 0 ∧ b1 = 0) := by
    intro ⟨hb0, hb1⟩
    have hpol_all : ∀ s : k, polarEval Q p (stereographicDirection s) = 0 := by
      intro s; rw [hlin, hb0, hb1]; ring
    exact not_polar_eq_zero_for_all_s_of_pureT_freeDir_root_p2_ne
      F hF hF0 v hv hpure t ht hp2 hpol_all
  by_cases hb1 : b1 = 0
  · -- b1 = 0 ⇒ b0 ≠ 0 ⇒ polar = b0 ≠ 0 for all s
    refine ⟨none, fun s _ => ?_⟩
    have hb0 : b0 ≠ 0 := fun hb0 => hnot_both ⟨hb0, hb1⟩
    rw [hlin, hb1, mul_zero, add_zero]
    exact hb0
  · -- b1 ≠ 0 ⇒ unique root s = -b0/b1
    refine ⟨some (-b0 * b1⁻¹), fun s hs => ?_⟩
    have hne : s ≠ -b0 * b1⁻¹ := by
      simpa using hs (-b0 * b1⁻¹) rfl
    rw [hlin]
    intro h0
    have : s * b1 = -b0 := by linear_combination h0
    have : s = -b0 * b1⁻¹ := by
      field_simp [hb1] at this ⊢
      linear_combination this
    exact hne this

/-- Three freeDir+polar roots under pure-`t` freeDir with a freeDir root where `p₂ ≠ 0`. -/
theorem exists_three_freeDir_polar_roots_of_pureT
    {k : Type u} [Field k] [IsAlgClosed k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (biprojectiveZeroLocusToSpec 2 2 k F)]
    (v : Fin 3 → Polynomial k)
    (hv : TernaryQuadraticPoly.eval (coordinateLineTernaryQuadraticPoly F) v = 0)
    (hpure : freeDirPureT F)
    (hdeg : (freeDirCoeffT F 0 0).natDegree ≠ 0)
    (ht0 : ∃ t : k, Polynomial.eval t (freeDirCoeffT F 0 0) = 0 ∧
      Polynomial.eval t (v 2) ≠ 0) :
    ∃ s0 s1 s2 : k, s0 ≠ s1 ∧ s0 ≠ s2 ∧ s1 ≠ s2 ∧
      (∃ t : k, evalAffineTwoPoint t s0 (specializedConicFreeDirForm F) = 0 ∧
        evalAffineTwoPoint t s0 (freePolarForm F v) ≠ 0) ∧
      (∃ t : k, evalAffineTwoPoint t s1 (specializedConicFreeDirForm F) = 0 ∧
        evalAffineTwoPoint t s1 (freePolarForm F v) ≠ 0) ∧
      (∃ t : k, evalAffineTwoPoint t s2 (specializedConicFreeDirForm F) = 0 ∧
        evalAffineTwoPoint t s2 (freePolarForm F v) ≠ 0) := by
  classical
  haveI : Infinite k := inferInstance
  obtain ⟨t0, ht0a, hp2⟩ := ht0
  obtain ⟨sBad, hgood⟩ :=
    exists_at_most_one_bad_s_of_pureT_freeDir_root_p2_ne F hF hF0 v hv hpure t0 ht0a hp2
  -- Bad finset: empty or singleton
  let B : Finset k := sBad.toFinset
  obtain ⟨s0, s1, s2, hs0B, hs1B, hs2B, h01, h02, h12⟩ := exists_three_notMem_finset B
  have hα : ∀ s : k,
      evalAffineTwoPoint t0 s (specializedConicFreeDirForm F) = 0 := by
    intro s
    have hpoly : freeDirPolyT F s = freeDirCoeffT F 0 0 :=
      freeDirPolyT_eq_coeff00_of_pureT F hpure s
    rw [evalAffineTwoPoint_specializedConicFreeDirForm_eq_eval_freeDirPolyT F hF t0 s, hpoly,
      ht0a]
  have hBne : ∀ s : k, s ∉ B →
      evalAffineTwoPoint t0 s (freePolarForm F v) ≠ 0 := by
    intro s hsB
    have hpol := hgood s (by
      intro sb hsb
      have : sb ∈ B := by
        simpa [B, Option.mem_toFinset] using hsb
      exact fun hseq => hsB (hseq ▸ this))
    rwa [evalAffineTwoPoint_freePolarForm F hF v t0 s]
  refine ⟨s0, s1, s2, h01, h02, h12, ?_, ?_, ?_⟩
  · exact ⟨t0, hα s0, hBne s0 hs0B⟩
  · exact ⟨t0, hα s1, hBne s1 hs1B⟩
  · exact ⟨t0, hα s2, hBne s2 hs2B⟩

/-- Denseness under pure-`t` freeDir with a freeDir root where `v₂ ≠ 0`. -/
theorem eq_zero_of_aeval_residualImageXCoords_eq_zero_of_isHomogeneous_two_of_pureT
    {k : Type u} [Field k] [IsAlgClosed k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (biprojectiveZeroLocusToSpec 2 2 k F)]
    (v : Fin 3 → Polynomial k)
    (hv : TernaryQuadraticPoly.eval (coordinateLineTernaryQuadraticPoly F) v = 0)
    (H : MvPolynomial (Fin 3) k) (hH : H.IsHomogeneous 2)
    (hst2 : residualImageXCoords F v 2 ≠ 0)
    (hvan : eval (residualImageXCoords F v) (map (C : k →+* affineTwoRing k) H) = 0)
    (hpure : freeDirPureT F)
    (hdeg : (freeDirCoeffT F 0 0).natDegree ≠ 0)
    (ht0 : ∃ t : k, Polynomial.eval t (freeDirCoeffT F 0 0) = 0 ∧
      Polynomial.eval t (v 2) ≠ 0) :
    H = 0 := by
  obtain ⟨s0, s1, s2, h01, h02, h12, hs0, hs1, hs2⟩ :=
    exists_three_freeDir_polar_roots_of_pureT F hF hF0 v hv hpure hdeg ht0
  exact eq_zero_of_aeval_residualImageXCoords_eq_zero_of_isHomogeneous_two_of_three_roots
    F hF v H hH hst2 hvan s0 s1 s2 h01 h02 h12 hs0 hs1 hs2


/-- Pure-`t` freeDir with nonconst `a₀` has a root (alg closed). -/
theorem exists_root_of_pureT_natDegree
    {k : Type u} [Field k] [IsAlgClosed k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (_hpure : freeDirPureT F)
    (hdeg : (freeDirCoeffT F 0 0).natDegree ≠ 0) :
    ∃ t : k, Polynomial.eval t (freeDirCoeffT F 0 0) = 0 := by
  have hdeg' : (freeDirCoeffT F 0 0).degree ≠ 0 := by
    intro h
    have : (freeDirCoeffT F 0 0).natDegree = 0 := by
      have hp0 : freeDirCoeffT F 0 0 ≠ 0 := fun hp0 => by
        rw [hp0, Polynomial.natDegree_zero] at hdeg
        exact hdeg rfl
      rw [Polynomial.degree_eq_natDegree hp0] at h
      exact WithBot.coe_eq_coe.mp h
    exact hdeg this
  obtain ⟨t, ht⟩ := IsAlgClosed.exists_root (freeDirCoeffT F 0 0) hdeg'
  exact ⟨t, by simpa [Polynomial.IsRoot] using ht⟩

/-- Residual X₂ under pure-`t` freeDir is freeDir·v₂ (lifted). -/
theorem residualImageXCoords_two_eq_pureT
    {k : Type u} [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (v : Fin 3 → Polynomial k) (hpure : freeDirPureT F) :
    residualImageXCoords F v 2 =
      liftPolyT (freeDirCoeffT F 0 0) * liftPolyT (v 2) := by
  have h := residualImageXCoords_two_eq F v
  -- freeDir = lift(a0) under pure-t
  have hα : specializedConicFreeDirForm F = liftPolyT (freeDirCoeffT F 0 0) := by
    rw [specializedConicFreeDirForm_eq_lift F hF]
    obtain ⟨h1, h2⟩ := hpure
    simp only [freeDirCoeffT] at h1 h2 ⊢
    have hz : liftPolyT (0 : Polynomial k) = 0 := by simp [liftPolyT]
    rw [h1, h2, hz, zero_mul, zero_mul, add_zero, add_zero]
  have hv2 : liftTsenSection v 2 = liftPolyT (v 2) := rfl
  rw [h, hα, hv2]

/-- If residualX₂ ≠ 0 and pure-`t` freeDir, then `a₀ ≠ 0` and `v₂ ≠ 0`. -/
theorem freeDirCoeff00_ne_zero_and_v2_ne_zero_of_pureT_residualX2
    {k : Type u} [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (v : Fin 3 → Polynomial k) (hpure : freeDirPureT F)
    (hst2 : residualImageXCoords F v 2 ≠ 0) :
    freeDirCoeffT F 0 0 ≠ 0 ∧ v 2 ≠ 0 := by
  have h := residualImageXCoords_two_eq_pureT F hF v hpure
  have hprod : liftPolyT (freeDirCoeffT F 0 0) * liftPolyT (v 2) ≠ 0 := by
    rwa [← h]
  constructor
  · intro h0
    apply left_ne_zero_of_mul hprod
    simp only [h0, liftPolyT, Polynomial.eval₂_zero]
  · intro h0
    apply right_ne_zero_of_mul hprod
    simp only [h0, liftPolyT, Polynomial.eval₂_zero]

/-! Residual-Y L-branch under pure-`t` denseness: compose
`eq_zero_of_aeval_..._of_pureT` with `eval_residual_map_C_specializeSecond_e0` and
L-branch geometry (`eval_on_L_*`, `cubicFiberPullback_stereo_eq_X2_mul_of_eval_on_L`,
`specializeSecond_e0_ne_zero_of_smooth_bidegree23`). Deferred as a thin wrapper to avoid
elaborator timeouts in this module; all supporting lemmas are green above. -/

end

end BConicBundleMultisections
