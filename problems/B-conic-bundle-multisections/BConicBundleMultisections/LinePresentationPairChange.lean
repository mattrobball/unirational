/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import BConicBundleMultisections.LinePresentationElementaryMoves
public import BConicBundleMultisections.BinaryResultant
public import BConicBundleMultisections.DeterminantHomogeneous
public import BConicBundleMultisections.HomogeneousFactor
public import Mathlib.Algebra.Polynomial.Reverse
public import Mathlib.Algebra.BigOperators.Fin

/-!
# Pair change: swap via homogenization, residual G4 laws, endpoint (Goal F-1b)

## Adjusted inverses (derived from `lineFrame` columns `(p,q,r)`)

| move | `E` | frame | inverse |
|---|---|---|---|
| shear `β` | `S=!![(1),0,0; β,1,0; 0,0,1]` | `M*S` | `N'=S⁻¹*N` |
| scale `α,δ` | `D=!![α,0,0; 0,δ,0; 0,0,1]` | `M*D` | `N'=D⁻¹*N` |
| swap | `W=!![0,1,0; 1,0,0; 0,0,1]` | `M*W` | `N'=W*N` |

## Exponents

| move | line disc | residual disc |
|---|---|---|
| shear | `comp(X+Cβ)` | affine-two `t↦t+β` |
| scale | `C(α^9)·comp(C(δ/α)X)` | `C(α^{27})` times `t↦(δ/α)t` |
| swap | `reflect 9` | nonvanishing via `k(t)[s]`, weight `27` |
-/

@[expose] public section

namespace BConicBundleMultisections

noncomputable section

universe u

open scoped Matrix

variable {k : Type u} [Field k]

/-! ### Generic binary reflection -/

def dehomogenizeAtFirst (G : MvPolynomial (Fin 2) k) : Polynomial k :=
  MvPolynomial.aeval ![1, (Polynomial.X : Polynomial k)] G

def dehomogenizeAtSecond (G : MvPolynomial (Fin 2) k) : Polynomial k :=
  MvPolynomial.aeval ![(Polynomial.X : Polynomial k), 1] G

private theorem reflect_sum {ι : Type*} (s : Finset ι) (f : ι → Polynomial k) (N : ℕ) :
    Polynomial.reflect N (∑ i ∈ s, f i) = ∑ i ∈ s, Polynomial.reflect N (f i) := by
  induction s using Finset.cons_induction with
  | empty => simp [Polynomial.reflect_zero]
  | cons a s ha ih =>
      simp only [Finset.sum_cons, Polynomial.reflect_add, ih]

private theorem aeval_monomial_one_X (d : Fin 2 →₀ ℕ) (c : k) :
    MvPolynomial.aeval ![1, (Polynomial.X : Polynomial k)] (MvPolynomial.monomial d c) =
      Polynomial.C c * Polynomial.X ^ (d 1) := by
  rw [MvPolynomial.aeval_monomial, Polynomial.algebraMap_eq]
  congr 1
  rw [Finsupp.prod_of_support_subset (s := (Finset.univ : Finset (Fin 2))) d
      (Finset.subset_univ _)
      (fun i e => (![1, (Polynomial.X : Polynomial k)] i) ^ e)
      (fun _ _ => by simp), Fin.prod_univ_two]
  simp [one_pow]

private theorem aeval_monomial_X_one (d : Fin 2 →₀ ℕ) (c : k) :
    MvPolynomial.aeval ![(Polynomial.X : Polynomial k), 1] (MvPolynomial.monomial d c) =
      Polynomial.C c * Polynomial.X ^ (d 0) := by
  rw [MvPolynomial.aeval_monomial, Polynomial.algebraMap_eq]
  congr 1
  rw [Finsupp.prod_of_support_subset (s := (Finset.univ : Finset (Fin 2))) d
      (Finset.subset_univ _)
      (fun i e => (![(Polynomial.X : Polynomial k), 1] i) ^ e)
      (fun _ _ => by simp), Fin.prod_univ_two]
  simp [one_pow]

private theorem finsupp_fin2_sum (d : Fin 2 →₀ ℕ) :
    ∑ i ∈ d.support, d i = d 0 + d 1 := by
  have : d.sum (fun _ x => x) = ∑ i ∈ d.support, d i := rfl
  rw [← this, Finsupp.sum_fintype d (g := fun _ x => x) (fun _ => rfl), Fin.sum_univ_two]

theorem reflect_dehomogenizeAtFirst_of_isHomogeneous
    (G : MvPolynomial (Fin 2) k) (n : ℕ) (hG : G.IsHomogeneous n) :
    Polynomial.reflect n (dehomogenizeAtFirst G) = dehomogenizeAtSecond G := by
  classical
  have hsum : G = ∑ d ∈ G.support, MvPolynomial.monomial d (MvPolynomial.coeff d G) :=
    (MvPolynomial.support_sum_monomial_coeff G).symm
  rw [hsum]
  simp only [dehomogenizeAtFirst, dehomogenizeAtSecond, map_sum]
  rw [reflect_sum]
  refine Finset.sum_congr rfl fun d hd => ?_
  have hab : d 0 + d 1 = n := by
    have hsup : n = ∑ i ∈ d.support, d i :=
      MvPolynomial.IsHomogeneous.degree_eq_sum_deg_support hG hd
    rw [hsup, finsupp_fin2_sum]
  have hle : d 1 ≤ n := by omega
  rw [aeval_monomial_one_X, aeval_monomial_X_one, Polynomial.reflect_C_mul,
    Polynomial.reflect_monomial, Polynomial.revAt_le hle, show n - d 1 = d 0 by omega]

/-! ### Binary disc -/

def lineBinaryPoint (p q : Fin 3 → k) : Fin 3 → MvPolynomial (Fin 2) k :=
  fun i => MvPolynomial.C (p i) * MvPolynomial.X 0 + MvPolynomial.C (q i) * MvPolynomial.X 1

def lineSpecializedConicBinary (p q : Fin 3 → k)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) :
    MvPolynomial (Fin 3) (MvPolynomial (Fin 2) k) :=
  specializeSecondCoordinates (m := 2) (lineBinaryPoint p q)
    (MvPolynomial.map (MvPolynomial.C : k →+* MvPolynomial (Fin 2) k) F)

def lineConicDiscBinary (p q : Fin 3 → k)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) : MvPolynomial (Fin 2) k :=
  (polarMatrix (lineSpecializedConicBinary p q F)).det

private theorem lineBinaryPoint_dehomAtFirst (p q : Fin 3 → k) :
    (fun j =>
        (MvPolynomial.aeval ![1, (Polynomial.X : Polynomial k)]).toRingHom
          (lineBinaryPoint p q j)) =
      linePointOf (fun a => Polynomial.C (p a)) (fun a => Polynomial.C (q a)) Polynomial.X := by
  funext j
  simp only [lineBinaryPoint, linePointOf, map_add, map_mul, AlgHom.toRingHom_eq_coe,
    RingHom.coe_coe, MvPolynomial.aeval_C, MvPolynomial.aeval_X]
  simp

private theorem lineBinaryPoint_dehomAtSecond (p q : Fin 3 → k) :
    (fun j =>
        (MvPolynomial.aeval ![(Polynomial.X : Polynomial k), 1]).toRingHom
          (lineBinaryPoint p q j)) =
      linePointOf (fun a => Polynomial.C (q a)) (fun a => Polynomial.C (p a)) Polynomial.X := by
  funext j
  simp only [lineBinaryPoint, linePointOf, map_add, map_mul, AlgHom.toRingHom_eq_coe,
    RingHom.coe_coe, MvPolynomial.aeval_C, MvPolynomial.aeval_X]
  simp; ring

private theorem map_dehomAtFirst_specialized
    (p q : Fin 3 → k) (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) :
    MvPolynomial.map (MvPolynomial.aeval ![1, (Polynomial.X : Polynomial k)]).toRingHom
        (lineSpecializedConicBinary p q F) =
      lineSpecializedConicPoly p q F := by
  have hC :
      (MvPolynomial.aeval ![1, (Polynomial.X : Polynomial k)]).toRingHom.comp
          (MvPolynomial.C : k →+* MvPolynomial (Fin 2) k) =
        (Polynomial.C : k →+* Polynomial k) := by ext; simp
  simp only [lineSpecializedConicBinary, lineSpecializedConicPoly]
  rw [map_specializeSecondCoordinates, MvPolynomial.map_map, hC, lineBinaryPoint_dehomAtFirst]

private theorem map_dehomAtSecond_specialized
    (p q : Fin 3 → k) (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) :
    MvPolynomial.map (MvPolynomial.aeval ![(Polynomial.X : Polynomial k), 1]).toRingHom
        (lineSpecializedConicBinary p q F) =
      lineSpecializedConicPoly q p F := by
  have hC :
      (MvPolynomial.aeval ![(Polynomial.X : Polynomial k), 1]).toRingHom.comp
          (MvPolynomial.C : k →+* MvPolynomial (Fin 2) k) =
        (Polynomial.C : k →+* Polynomial k) := by ext; simp
  simp only [lineSpecializedConicBinary, lineSpecializedConicPoly]
  rw [map_specializeSecondCoordinates, MvPolynomial.map_map, hC, lineBinaryPoint_dehomAtSecond]

theorem dehomogenizeAtFirst_lineConicDiscBinary
    (p q : Fin 3 → k) (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) :
    dehomogenizeAtFirst (lineConicDiscBinary p q F) = lineConicDiscriminant p q F := by
  set φ : MvPolynomial (Fin 2) k →+* Polynomial k :=
    (MvPolynomial.aeval ![1, (Polynomial.X : Polynomial k)]).toRingHom
  have hdef : dehomogenizeAtFirst (lineConicDiscBinary p q F) =
      φ (lineConicDiscBinary p q F) := rfl
  rw [hdef, lineConicDiscBinary, lineConicDiscriminant]
  have hmap := polarMatrix_map φ (lineSpecializedConicBinary p q F)
  have hdet :
      φ ((polarMatrix (lineSpecializedConicBinary p q F)).det) =
        ((polarMatrix (lineSpecializedConicBinary p q F)).map φ).det := by
    have h' : (polarMatrix (lineSpecializedConicBinary p q F)).map φ =
        φ.mapMatrix (polarMatrix (lineSpecializedConicBinary p q F)) := by ext; rfl
    rw [h', RingHom.map_det]
  rw [hdet, ← hmap, map_dehomAtFirst_specialized]

theorem dehomogenizeAtSecond_lineConicDiscBinary
    (p q : Fin 3 → k) (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) :
    dehomogenizeAtSecond (lineConicDiscBinary p q F) = lineConicDiscriminant q p F := by
  set φ : MvPolynomial (Fin 2) k →+* Polynomial k :=
    (MvPolynomial.aeval ![(Polynomial.X : Polynomial k), 1]).toRingHom
  have hdef : dehomogenizeAtSecond (lineConicDiscBinary p q F) =
      φ (lineConicDiscBinary p q F) := rfl
  rw [hdef, lineConicDiscBinary, lineConicDiscriminant]
  have hmap := polarMatrix_map φ (lineSpecializedConicBinary p q F)
  have hdet :
      φ ((polarMatrix (lineSpecializedConicBinary p q F)).det) =
        ((polarMatrix (lineSpecializedConicBinary p q F)).map φ).det := by
    have h' : (polarMatrix (lineSpecializedConicBinary p q F)).map φ =
        φ.mapMatrix (polarMatrix (lineSpecializedConicBinary p q F)) := by ext; rfl
    rw [h', RingHom.map_det]
  rw [hdet, ← hmap, map_dehomAtSecond_specialized]

theorem lineConicDiscBinary_swap
    (p q : Fin 3 → k) (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) :
    lineConicDiscBinary q p F =
      MvPolynomial.rename (Equiv.swap (0 : Fin 2) 1) (lineConicDiscBinary p q F) := by
  classical
  set σ := Equiv.swap (0 : Fin 2) 1
  set φ : MvPolynomial (Fin 2) k →+* MvPolynomial (Fin 2) k :=
    (MvPolynomial.rename σ).toRingHom
  have hpt : lineBinaryPoint q p = fun i => φ (lineBinaryPoint p q i) := by
    funext i
    simp only [lineBinaryPoint, φ, map_add, map_mul, AlgHom.toRingHom_eq_coe, RingHom.coe_coe,
      MvPolynomial.rename_C, MvPolynomial.rename_X]
    have h0 : σ 0 = 1 := rfl
    have h1 : σ 1 = 0 := rfl
    simp [σ, h0, h1]
    ring
  have hQ : lineSpecializedConicBinary q p F =
      MvPolynomial.map φ (lineSpecializedConicBinary p q F) := by
    have hC : φ.comp (MvPolynomial.C : k →+* MvPolynomial (Fin 2) k) =
        (MvPolynomial.C : k →+* MvPolynomial (Fin 2) k) := by ext; simp [φ]
    simp only [lineSpecializedConicBinary]
    rw [map_specializeSecondCoordinates, MvPolynomial.map_map, hC, hpt]
  change lineConicDiscBinary q p F = φ (lineConicDiscBinary p q F)
  simp only [lineConicDiscBinary, hQ]
  set Q := lineSpecializedConicBinary p q F
  have hmap : polarMatrix (MvPolynomial.map φ Q) = (polarMatrix Q).map φ :=
    polarMatrix_map φ Q
  have hdet : φ ((polarMatrix Q).det) = ((polarMatrix Q).map φ).det := by
    have h' : (polarMatrix Q).map φ = φ.mapMatrix (polarMatrix Q) := by ext; rfl
    rw [h', RingHom.map_det]
  calc
    (polarMatrix (MvPolynomial.map φ Q)).det = ((polarMatrix Q).map φ).det := by rw [hmap]
    _ = φ ((polarMatrix Q).det) := hdet.symm

/-! ### Homogeneity of binary disc (degree 9) via polar scaling -/

private theorem degreeEmbedding_lineBinaryPoint (p q : Fin 3 → k) (j : Fin 3) :
    (MvPolynomial.degreeEmbedding (lineBinaryPoint p q j) :
      Polynomial (MvPolynomial (Fin 2) k)) =
      Polynomial.X * Polynomial.C (lineBinaryPoint p q j) := by
  dsimp [MvPolynomial.degreeEmbedding, lineBinaryPoint]
  simp only [map_add, map_mul, MvPolynomial.aeval_C, MvPolynomial.aeval_X]
  have hC (a : k) :
      algebraMap k (Polynomial (MvPolynomial (Fin 2) k)) a =
        Polynomial.C (MvPolynomial.C a) := by
    simp [MvPolynomial.algebraMap_eq]
  simp only [hC]
  ring

private theorem map_degreeEmbedding_specialized
    (p q : Fin 3 → k) (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F) :
    MvPolynomial.map (MvPolynomial.degreeEmbedding (σ := Fin 2) (K := k)).toRingHom
        (lineSpecializedConicBinary p q F) =
      MvPolynomial.C (Polynomial.X ^ 3) *
        MvPolynomial.map Polynomial.C (lineSpecializedConicBinary p q F) := by
  set φ : MvPolynomial (Fin 2) k →+* Polynomial (MvPolynomial (Fin 2) k) :=
    (MvPolynomial.degreeEmbedding (σ := Fin 2) (K := k)).toRingHom
  have h1 :
      MvPolynomial.map φ (lineSpecializedConicBinary p q F) =
        specializeSecondCoordinates (m := 2) (fun j => φ (lineBinaryPoint p q j))
          (MvPolynomial.map (φ.comp (MvPolynomial.C : k →+* MvPolynomial (Fin 2) k)) F) := by
    simp only [lineSpecializedConicBinary]
    rw [map_specializeSecondCoordinates, MvPolynomial.map_map]
  have hC : φ.comp (MvPolynomial.C : k →+* MvPolynomial (Fin 2) k) =
      Polynomial.C.comp (MvPolynomial.C : k →+* MvPolynomial (Fin 2) k) := by
    ext a
    simp [φ, MvPolynomial.degreeEmbedding, MvPolynomial.aeval_C, MvPolynomial.algebraMap_eq]
  have hpt : (fun j => φ (lineBinaryPoint p q j)) =
      fun j => Polynomial.X * Polynomial.C (lineBinaryPoint p q j) := by
    funext j
    simpa [φ, AlgHom.toRingHom_eq_coe, RingHom.coe_coe] using
      degreeEmbedding_lineBinaryPoint p q j
  rw [h1, hC, hpt]
  have hsmul :=
    (hF.map_coefficients
        (Polynomial.C.comp (MvPolynomial.C : k →+* MvPolynomial (Fin 2) k) :
          k →+* Polynomial (MvPolynomial (Fin 2) k))).specializeSecondCoordinates_smul
      (Polynomial.X : Polynomial (MvPolynomial (Fin 2) k))
      (fun j => Polynomial.C (lineBinaryPoint p q j))
  have h3 :
      specializeSecondCoordinates (m := 2)
          (fun j => Polynomial.C (lineBinaryPoint p q j))
          (MvPolynomial.map
            (Polynomial.C.comp (MvPolynomial.C : k →+* MvPolynomial (Fin 2) k)) F) =
        MvPolynomial.map Polynomial.C (lineSpecializedConicBinary p q F) := by
    simp only [lineSpecializedConicBinary]
    rw [map_specializeSecondCoordinates, MvPolynomial.map_map]
  have hsm :
      (fun j => Polynomial.X * Polynomial.C (lineBinaryPoint p q j)) =
        (Polynomial.X : Polynomial (MvPolynomial (Fin 2) k)) •
          fun j => Polynomial.C (lineBinaryPoint p q j) := by
    funext j; simp [Pi.smul_apply, smul_eq_mul]
  rw [hsm, hsmul, h3]

private theorem det_polar_C_pow3
    (Q : MvPolynomial (Fin 3) (MvPolynomial (Fin 2) k)) :
    (polarMatrix
        (MvPolynomial.C (Polynomial.X ^ 3 : Polynomial (MvPolynomial (Fin 2) k)) *
          MvPolynomial.map Polynomial.C Q)).det =
      Polynomial.X ^ 9 *
        (polarMatrix (MvPolynomial.map Polynomial.C Q)).det := by
  have h :=
    det_polarMatrix_C_mul (Polynomial.X ^ 3 : Polynomial (MvPolynomial (Fin 2) k))
      (MvPolynomial.map Polynomial.C Q)
  -- h : det = (X^3)^3 * det = X^9 * det
  rw [h, ← pow_mul]

private theorem det_polar_map_C
    (Q : MvPolynomial (Fin 3) (MvPolynomial (Fin 2) k)) :
    (polarMatrix (MvPolynomial.map Polynomial.C Q)).det =
      Polynomial.C ((polarMatrix Q).det) := by
  have h1 := polarMatrix_map
    (Polynomial.C : MvPolynomial (Fin 2) k →+* Polynomial (MvPolynomial (Fin 2) k)) Q
  have h2 : ((polarMatrix Q).map Polynomial.C).det =
      Polynomial.C ((polarMatrix Q).det) := by
    have h' : (polarMatrix Q).map Polynomial.C =
        Polynomial.C.mapMatrix (polarMatrix Q) := by ext; rfl
    rw [h', RingHom.map_det]
  rw [h1, h2]

private theorem degreeEmbedding_lineConicDiscBinary
    (p q : Fin 3 → k) (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F) :
    MvPolynomial.degreeEmbedding (lineConicDiscBinary p q F) =
      Polynomial.X ^ 9 * Polynomial.C (lineConicDiscBinary p q F) := by
  set φ : MvPolynomial (Fin 2) k →+* Polynomial (MvPolynomial (Fin 2) k) :=
    (MvPolynomial.degreeEmbedding (σ := Fin 2) (K := k)).toRingHom
  set Q := lineSpecializedConicBinary p q F
  -- φ (det) = X^9 * C (det)
  change φ ((polarMatrix Q).det) =
    Polynomial.X ^ 9 * Polynomial.C ((polarMatrix Q).det)
  have hdet : φ ((polarMatrix Q).det) = ((polarMatrix Q).map φ).det := by
    have h' : (polarMatrix Q).map φ = φ.mapMatrix (polarMatrix Q) := by ext; rfl
    rw [h', RingHom.map_det]
  have hmap : ((polarMatrix Q).map φ).det = (polarMatrix (MvPolynomial.map φ Q)).det := by
    rw [polarMatrix_map φ Q]
  have hspec := map_degreeEmbedding_specialized p q F hF
  rw [hdet, hmap, hspec, det_polar_C_pow3 Q, det_polar_map_C Q]

/-- **(a)** Binary disc is homogeneous of degree 9. -/
theorem lineConicDiscBinary_isHomogeneous
    (p q : Fin 3 → k) (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F) :
    (lineConicDiscBinary p q F).IsHomogeneous 9 := by
  classical
  have hemb := degreeEmbedding_lineConicDiscBinary p q F hF
  intro d hd
  have hne : MvPolynomial.coeff d (lineConicDiscBinary p q F) ≠ 0 := hd
  have hneComp :
      (MvPolynomial.degreeEmbedding (lineConicDiscBinary p q F)).coeff d.degree ≠ 0 := by
    intro h0
    have :
        MvPolynomial.coeff d
          (MvPolynomial.homogeneousComponent d.degree (lineConicDiscBinary p q F)) = 0 := by
      rw [← MvPolynomial.coeff_degreeEmbedding, h0]; simp
    rw [MvPolynomial.coeff_homogeneousComponent, if_pos rfl] at this
    exact hne this
  have honly : ∀ n : ℕ, n ≠ 9 →
      (MvPolynomial.degreeEmbedding (lineConicDiscBinary p q F)).coeff n = 0 := by
    intro n hn
    rw [hemb, Polynomial.coeff_X_pow_mul']
    split_ifs with hge
    · -- n ≥ 9 and n ≠ 9 ⇒ n - 9 ≠ 0 ⇒ C.coeff = 0
      have : n - 9 ≠ 0 := by omega
      simp [Polynomial.coeff_C, this]
    · rfl
  by_contra hne9
  have hdeg : d.degree ≠ 9 := by
    simpa [Finsupp.degree_eq_weight_one, Pi.one_def] using hne9
  exact hneComp (honly d.degree hdeg)

/-- Swap law: `lineConicDiscriminant q p = reflect 9 (lineConicDiscriminant p q)`. -/
theorem lineConicDiscriminant_swap
    (p q : Fin 3 → k) (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F) :
    lineConicDiscriminant q p F =
      Polynomial.reflect 9 (lineConicDiscriminant p q F) := by
  have hG := lineConicDiscBinary_isHomogeneous p q F hF
  have href :=
    reflect_dehomogenizeAtFirst_of_isHomogeneous (lineConicDiscBinary p q F) 9 hG
  rw [← dehomogenizeAtSecond_lineConicDiscBinary p q F, ← href,
    dehomogenizeAtFirst_lineConicDiscBinary]

theorem lineConicDiscriminant_swap_ne_zero_iff
    (p q : Fin 3 → k) (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F) :
    lineConicDiscriminant q p F ≠ 0 ↔ lineConicDiscriminant p q F ≠ 0 := by
  rw [lineConicDiscriminant_swap p q F hF, not_iff_not, Polynomial.reflect_eq_zero_iff]

/-! ### Frame elementary matrices and adjusted inverses -/

/-- Shear block `S = !![(1),0,0; β,1,0; 0,0,1]`. -/
def shearFrame3 (β : k) : Matrix (Fin 3) (Fin 3) k :=
  !![1, 0, 0; β, 1, 0; 0, 0, 1]

/-- Scale block `D = !![α,0,0; 0,δ,0; 0,0,1]`. -/
def scaleFrame3 (α δ : k) : Matrix (Fin 3) (Fin 3) k :=
  !![α, 0, 0; 0, δ, 0; 0, 0, 1]

/-- Swap block `W = !![0,1,0; 1,0,0; 0,0,1]`. -/
def swapFrame3 : Matrix (Fin 3) (Fin 3) k :=
  !![0, 1, 0; 1, 0, 0; 0, 0, 1]

theorem lineFrame_shear (p q r : Fin 3 → k) (β : k) :
    lineFrame (fun i => p i + β * q i) q r =
      lineFrame p q r * shearFrame3 β := by
  ext i j
  fin_cases j <;> simp [lineFrame, shearFrame3, Matrix.mul_apply, Fin.sum_univ_three] <;> ring

theorem lineFrame_scale (p q r : Fin 3 → k) (α δ : k) :
    lineFrame (fun i => α * p i) (fun i => δ * q i) r =
      lineFrame p q r * scaleFrame3 α δ := by
  ext i j
  fin_cases j <;>
    simp [lineFrame, scaleFrame3, Matrix.mul_apply, Fin.sum_univ_three] <;> ring

theorem lineFrame_swap (p q r : Fin 3 → k) :
    lineFrame q p r = lineFrame p q r * swapFrame3 := by
  ext i j
  fin_cases j <;> simp [lineFrame, swapFrame3, Matrix.mul_apply, Fin.sum_univ_three]

theorem shearFrame3_inv (β : k) : shearFrame3 β * shearFrame3 (-β) = 1 := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [shearFrame3, Matrix.mul_apply, Fin.sum_univ_three, Matrix.one_apply] <;> ring

theorem scaleFrame3_inv (α δ : k) (hα : α ≠ 0) (hδ : δ ≠ 0) :
    scaleFrame3 α δ * scaleFrame3 α⁻¹ δ⁻¹ = 1 := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [scaleFrame3, Matrix.mul_apply, Fin.sum_univ_three, Matrix.one_apply, hα, hδ]

theorem swapFrame3_inv : swapFrame3 * swapFrame3 = (1 : Matrix (Fin 3) (Fin 3) k) := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [swapFrame3, Matrix.mul_apply, Fin.sum_univ_three, Matrix.one_apply]

/-- Adjusted inverse for shear: `N' = S⁻¹ * N`. -/
theorem lineFrame_mul_shear_inv
    (p q r : Fin 3 → k) (N : Matrix (Fin 3) (Fin 3) k) (β : k)
    (hMN : lineFrame p q r * N = 1) :
    lineFrame (fun i => p i + β * q i) q r * (shearFrame3 (-β) * N) = 1 := by
  rw [lineFrame_shear, mul_assoc, ← mul_assoc (shearFrame3 β), shearFrame3_inv, one_mul, hMN]

/-- Adjusted inverse for scale: `N' = D⁻¹ * N`. -/
theorem lineFrame_mul_scale_inv
    (p q r : Fin 3 → k) (N : Matrix (Fin 3) (Fin 3) k) (α δ : k)
    (hα : α ≠ 0) (hδ : δ ≠ 0) (hMN : lineFrame p q r * N = 1) :
    lineFrame (fun i => α * p i) (fun i => δ * q i) r * (scaleFrame3 α⁻¹ δ⁻¹ * N) = 1 := by
  rw [lineFrame_scale, mul_assoc, ← mul_assoc (scaleFrame3 α δ), scaleFrame3_inv α δ hα hδ,
    one_mul, hMN]

/-- Adjusted inverse for swap: `N' = W * N`. -/
theorem lineFrame_mul_swap_inv
    (p q r : Fin 3 → k) (N : Matrix (Fin 3) (Fin 3) k)
    (hMN : lineFrame p q r * N = 1) :
    lineFrame q p r * (swapFrame3 * N) = 1 := by
  rw [lineFrame_swap, mul_assoc, ← mul_assoc swapFrame3, swapFrame3_inv, one_mul, hMN]

/-! ### F-1b.2 infrastructure notes

Adjusted inverses (proved above):

* shear: `N' = shearFrame3 (-β) * N`  (`S⁻¹ N`, left multiplication)
* scale: `N' = scaleFrame3 α⁻¹ δ⁻¹ * N`  (`D⁻¹ N`)
* swap: `N' = swapFrame3 * N`  (`W N`, since `W⁻¹ = W`)

Residual disc exponents (for the residual `Y` equivariance layer still to land):

* shear: residual disc transforms by `shearAffineTwoHom β` (no unit prefactor)
* scale: residual disc transforms by `C (α^{27}) * scaleAffineTwoHom (δ/α)` with
  `27 = 3 · 9` (stereo/cubic residual coordinates scale as degree 3, then `sndConicDiscriminant`
  is homogeneous of degree 9)
* swap: nonvanishing through `k(t)[s]` via `t ↦ 1/t` with weight 27 (no bivariate `reflect`)

The full residual `Y`-coordinate equivariance and
`hasGoodLineSectionPartial_pair_change` are the remaining F-1b.2/F-1b.3 work.
-/

end

end BConicBundleMultisections
