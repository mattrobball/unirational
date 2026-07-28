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
# Pair change: swap via homogenization, residual G4 laws, endpoint (Goal F-1b/F-1c)

## Adjusted inverses (derived from `lineFrame` columns `(p,q,r)`)

| move | `E` | frame | inverse |
|---|---|---|---|
| shear `β` | `S=!![(1),0,0; β,1,0; 0,0,1]` | `M*S` | `N'=S⁻¹*N` |
| scale `α,δ` | `D=!![α,0,0; 0,δ,0; 0,0,1]` | `M*D` | `N'=D⁻¹*N` |
| swap | `W=!![0,1,0; 1,0,0; 0,0,1]` | `M*W` | `N'=W*N` |

## Exponents

| move | line disc | residual disc |
|---|---|---|
| shear | `comp(X+Cβ)` | affine-two `t↦t+β` (Y-layer: cross3 clearing twist, see F-1c status) |
| scale | `C(α^9)·comp(C(δ/α)X)` | intended `C(α^{27})` times `t↦(δ/α)t` with `27=3·9` |
| swap | `reflect 9` | nonvanishing via `k(t)[s]`, weight `27` |

## F-1c residual-Y layer (status)

| piece | status |
|---|---|
| `shearAffineTwoHom` / `scaleAffineTwoHom` | **proved** (injective) |
| `liftPolyT` / `liftTsenSection` equivariance | **proved** |
| partial transports with adjusted `N'` | **proved** (G4 still hyp) |
| residual Y pointwise shear | **resisted**: cross3 frame transport yields a reparam factor, not bare shear; intended clearing form involves ratios of the shape `(1+t²)/(1+(t+β)²)` |
| residual Y scale unit `α³` ⇒ disc `α²⁷` | **recorded** (`residualY_scale_disc_exponent`); pointwise law open |
| swap residual nonvanishing weight 27 | **open** (k(t)[s] route) |
| swap isotropy (`reverse` normalization) | **open** (binary/`reflect 3` on coeffs; package takes isotropy as hyp) |
| automatic G4 transport | **open** (blocked on residual-Y / reparam) |
| `hasGoodLineSectionPartial_pair_change` | **open** (blocked on automatic G4) |

G3 remains out of scope (phase F-3).
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

/-! ### F-1c status (residual Y equivariance / pair-change)

Adjusted inverses (proved above): shear `N'=S⁻¹N`, scale `N'=D⁻¹N`, swap `N'=WN`.

| piece | status |
|---|---|
| shearAffineTwoHom / scaleAffineTwoHom | **proved** (injective) |
| liftPolyT / liftTsenSection equivariance | **proved** |
| affineTwo pullback / stereo dir fixed by shear/scale | **proved** |
| partial transports with adjusted `N'` | **proved** (G4 still hyp; new lemmas) |
| residual Y pointwise shear | **resisted** — cross3 reparam factor, not bare shear |
| residual Y scale unit α³ ⇒ disc α²⁷ | **recorded** (`residualY_scale_disc_exponent`) |
| swap residual nonvanishing weight 27 | **open** |
| swap isotropy (`reverse` / binary) | **open** (partial takes isotropy as hyp) |
| automatic G4 transport | **open** (blocked on residual-Y) |
| hasGoodLineSectionPartial_pair_change | **open** (blocked on automatic G4) |

Partial transports with adjusted inverses take G4 as hypothesis. No new `sorry`.
-/

/-! ### Affine-plane parameter endomorphisms (F-1c) -/

open _root_.MvPolynomial

/-- Ring endomorphism of `k[t,s]` sending `t ↦ t+β` and fixing `s`. -/
def shearAffineTwoHom (β : k) : affineTwoRing k →+* affineTwoRing k :=
  (aeval (fun i : ULift (Fin 2) =>
      if i.down = 0 then affineTwoCoord0 k + C β else affineTwoCoord1 k)).toRingHom

@[simp] theorem shearAffineTwoHom_C (β : k) (a : k) :
    shearAffineTwoHom β (C a) = C a := by
  simp [shearAffineTwoHom]

@[simp] theorem shearAffineTwoHom_affineTwoCoord0 (β : k) :
    shearAffineTwoHom β (affineTwoCoord0 k) = affineTwoCoord0 k + C β := by
  simp [shearAffineTwoHom, affineTwoCoord0]

@[simp] theorem shearAffineTwoHom_affineTwoCoord1 (β : k) :
    shearAffineTwoHom β (affineTwoCoord1 k) = affineTwoCoord1 k := by
  simp [shearAffineTwoHom, affineTwoCoord1]

theorem shearAffineTwoHom_comp_neg (β : k) (f : affineTwoRing k) :
    shearAffineTwoHom (-β) (shearAffineTwoHom β f) = f := by
  induction f using induction_on with
  | C a => simp [shearAffineTwoHom]
  | add p q hp hq => simp [map_add, hp, hq]
  | mul_X p i hp =>
      simp only [map_mul, hp]
      congr 1
      change
        (aeval (fun j : ULift (Fin 2) =>
            if j.down = 0 then affineTwoCoord0 k + C (-β) else affineTwoCoord1 k) :
              affineTwoRing k →ₐ[k] affineTwoRing k)
          ((aeval (fun j : ULift (Fin 2) =>
              if j.down = 0 then affineTwoCoord0 k + C β else affineTwoCoord1 k) :
                affineTwoRing k →ₐ[k] affineTwoRing k) (X i)) = X i
      rw [aeval_X]
      fin_cases i <;> simp [affineTwoCoord0, affineTwoCoord1] <;> ring_nf

theorem shearAffineTwoHom_injective (β : k) :
    Function.Injective (shearAffineTwoHom (k := k) β) := by
  intro f g hfg
  simpa [shearAffineTwoHom_comp_neg] using congrArg (shearAffineTwoHom (-β)) hfg

theorem shearAffineTwoHom_ne_zero_iff (β : k) {f : affineTwoRing k} :
    shearAffineTwoHom β f ≠ 0 ↔ f ≠ 0 := by
  constructor
  · intro h hf; exact h (by simp [hf])
  · intro hf h0
    exact hf (shearAffineTwoHom_injective β (by simpa using h0))

/-- Ring endomorphism of `k[t,s]` sending `t ↦ μ·t` and fixing `s`. -/
def scaleAffineTwoHom (μ : k) : affineTwoRing k →+* affineTwoRing k :=
  (aeval (fun i : ULift (Fin 2) =>
      if i.down = 0 then C μ * affineTwoCoord0 k else affineTwoCoord1 k)).toRingHom

@[simp] theorem scaleAffineTwoHom_C (μ : k) (a : k) :
    scaleAffineTwoHom μ (C a) = C a := by
  simp [scaleAffineTwoHom]

@[simp] theorem scaleAffineTwoHom_affineTwoCoord0 (μ : k) :
    scaleAffineTwoHom μ (affineTwoCoord0 k) = C μ * affineTwoCoord0 k := by
  simp [scaleAffineTwoHom, affineTwoCoord0]

@[simp] theorem scaleAffineTwoHom_affineTwoCoord1 (μ : k) :
    scaleAffineTwoHom μ (affineTwoCoord1 k) = affineTwoCoord1 k := by
  simp [scaleAffineTwoHom, affineTwoCoord1]

private theorem scaleAffineTwoHom_t_inv (μ : k) (hμ : μ ≠ 0) :
    scaleAffineTwoHom μ⁻¹ (C μ * affineTwoCoord0 k) = affineTwoCoord0 k := by
  simp only [scaleAffineTwoHom, AlgHom.toRingHom_eq_coe, RingHom.coe_coe, map_mul, aeval_C]
  have ha :
      (aeval (fun j : ULift (Fin 2) =>
          if j.down = 0 then C μ⁻¹ * affineTwoCoord0 k else affineTwoCoord1 k) :
            affineTwoRing k →ₐ[k] affineTwoRing k)
        (affineTwoCoord0 k) = C μ⁻¹ * affineTwoCoord0 k := by
    rw [show affineTwoCoord0 k = X (ULift.up (0 : Fin 2)) from rfl, aeval_X]
    simp
  rw [ha]
  have hAM : (algebraMap k (affineTwoRing k) μ) = (C μ : affineTwoRing k) := rfl
  rw [hAM, ← mul_assoc, ← map_mul, mul_inv_cancel₀ hμ, map_one, one_mul]

theorem scaleAffineTwoHom_comp_inv (μ : k) (hμ : μ ≠ 0) (f : affineTwoRing k) :
    scaleAffineTwoHom μ⁻¹ (scaleAffineTwoHom μ f) = f := by
  induction f using induction_on with
  | C a => simp [scaleAffineTwoHom]
  | add p q hp hq => simp [map_add, hp, hq]
  | mul_X p i hp =>
      simp only [map_mul, hp]
      congr 1
      -- scale μ then μ⁻¹ on generators
      have h0 :
          scaleAffineTwoHom μ⁻¹ (scaleAffineTwoHom μ (affineTwoCoord0 k)) =
            affineTwoCoord0 k := by
        rw [scaleAffineTwoHom_affineTwoCoord0, scaleAffineTwoHom_t_inv μ hμ]
      have h1 :
          scaleAffineTwoHom μ⁻¹ (scaleAffineTwoHom μ (affineTwoCoord1 k)) =
            affineTwoCoord1 k := by
        simp
      fin_cases i
      · simpa [affineTwoCoord0] using h0
      · simpa [affineTwoCoord1] using h1

theorem scaleAffineTwoHom_injective {μ : k} (hμ : μ ≠ 0) :
    Function.Injective (scaleAffineTwoHom (k := k) μ) := by
  intro f g hfg
  simpa [scaleAffineTwoHom_comp_inv μ hμ] using congrArg (scaleAffineTwoHom μ⁻¹) hfg

theorem scaleAffineTwoHom_ne_zero_iff {μ : k} (hμ : μ ≠ 0) {f : affineTwoRing k} :
    scaleAffineTwoHom μ f ≠ 0 ↔ f ≠ 0 := by
  constructor
  · intro h hf; exact h (by simp [hf])
  · intro hf h0
    exact hf (scaleAffineTwoHom_injective hμ (by simpa using h0))

theorem liftPolyT_shearPolyHom (β : k) (f : Polynomial k) :
    liftPolyT (shearPolyHom β f) = shearAffineTwoHom β (liftPolyT f) := by
  simp only [liftPolyT, shearPolyHom_apply, shearAffineTwoHom, AlgHom.toRingHom_eq_coe,
    RingHom.coe_coe]
  rw [Polynomial.eval₂_comp]
  simp only [Polynomial.eval₂_add, Polynomial.eval₂_X, Polynomial.eval₂_C]
  set φ :
      affineTwoRing k →+* affineTwoRing k :=
    (aeval (fun i : ULift (Fin 2) =>
        if i.down = 0 then affineTwoCoord0 k + C β else affineTwoCoord1 k)).toRingHom
  change f.eval₂ (C : k →+* affineTwoRing k) (affineTwoCoord0 k + C β) =
    φ (f.eval₂ (C : k →+* affineTwoRing k) (affineTwoCoord0 k))
  have hC : φ.comp (C : k →+* affineTwoRing k) = (C : k →+* affineTwoRing k) := by
    ext a; simp [φ]
  have ht : φ (affineTwoCoord0 k) = affineTwoCoord0 k + C β := by
    simp [φ, affineTwoCoord0]
  have h :=
    Polynomial.hom_eval₂ (f := (C : k →+* affineTwoRing k)) (g := φ) (p := f)
      (x := affineTwoCoord0 k)
  calc
    f.eval₂ (C : k →+* affineTwoRing k) (affineTwoCoord0 k + C β) =
        f.eval₂ (φ.comp (C : k →+* affineTwoRing k)) (φ (affineTwoCoord0 k)) := by
      rw [hC, ht]
    _ = φ (f.eval₂ (C : k →+* affineTwoRing k) (affineTwoCoord0 k)) := h.symm

theorem liftPolyT_scalePolyHom (μ : k) (f : Polynomial k) :
    liftPolyT (scalePolyHom μ f) = scaleAffineTwoHom μ (liftPolyT f) := by
  simp only [liftPolyT, scalePolyHom_apply, scaleAffineTwoHom, AlgHom.toRingHom_eq_coe,
    RingHom.coe_coe]
  rw [Polynomial.eval₂_comp]
  simp only [Polynomial.eval₂_mul, Polynomial.eval₂_X, Polynomial.eval₂_C]
  set φ :
      affineTwoRing k →+* affineTwoRing k :=
    (aeval (fun i : ULift (Fin 2) =>
        if i.down = 0 then C μ * affineTwoCoord0 k else affineTwoCoord1 k)).toRingHom
  change f.eval₂ (C : k →+* affineTwoRing k) (C μ * affineTwoCoord0 k) =
    φ (f.eval₂ (C : k →+* affineTwoRing k) (affineTwoCoord0 k))
  have hC : φ.comp (C : k →+* affineTwoRing k) = (C : k →+* affineTwoRing k) := by
    ext a; simp [φ]
  have ht : φ (affineTwoCoord0 k) = C μ * affineTwoCoord0 k := by
    simp [φ, affineTwoCoord0]
  have h :=
    Polynomial.hom_eval₂ (f := (C : k →+* affineTwoRing k)) (g := φ) (p := f)
      (x := affineTwoCoord0 k)
  calc
    f.eval₂ (C : k →+* affineTwoRing k) (C μ * affineTwoCoord0 k) =
        f.eval₂ (φ.comp (C : k →+* affineTwoRing k)) (φ (affineTwoCoord0 k)) := by
      rw [hC, ht]
    _ = φ (f.eval₂ (C : k →+* affineTwoRing k) (affineTwoCoord0 k)) := h.symm

theorem liftTsenSection_shearPolyHom (β : k) (v : Fin 3 → Polynomial k) :
    liftTsenSection (fun i => shearPolyHom β (v i)) =
      fun i => shearAffineTwoHom β (liftTsenSection v i) := by
  funext i; exact liftPolyT_shearPolyHom β (v i)

theorem liftTsenSection_scalePolyHom (μ : k) (v : Fin 3 → Polynomial k) :
    liftTsenSection (fun i => scalePolyHom μ (v i)) =
      fun i => scaleAffineTwoHom μ (liftTsenSection v i) := by
  funext i; exact liftPolyT_scalePolyHom μ (v i)

theorem shearAffineTwoHom_affineTwoStereoDir (β : k) :
    (fun i => shearAffineTwoHom β (affineTwoStereoDir (k := k) i)) =
      affineTwoStereoDir (k := k) := by
  funext i; fin_cases i <;> simp [affineTwoStereoDir]

theorem scaleAffineTwoHom_affineTwoStereoDir (μ : k) :
    (fun i => scaleAffineTwoHom μ (affineTwoStereoDir (k := k) i)) =
      affineTwoStereoDir (k := k) := by
  funext i; fin_cases i <;> simp [affineTwoStereoDir]

theorem shearAffineTwoHom_affineTwoPullback
    (β : k) (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) :
    map (shearAffineTwoHom β) (affineTwoPullback F) = affineTwoPullback F := by
  simp only [affineTwoPullback]
  rw [map_map]
  have h : (shearAffineTwoHom β).comp (C : k →+* affineTwoRing k) =
      (C : k →+* affineTwoRing k) := by
    ext; simp
  rw [h]

theorem scaleAffineTwoHom_affineTwoPullback
    (μ : k) (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) :
    map (scaleAffineTwoHom μ) (affineTwoPullback F) = affineTwoPullback F := by
  simp only [affineTwoPullback]
  rw [map_map]
  have h : (scaleAffineTwoHom μ).comp (C : k →+* affineTwoRing k) =
      (C : k →+* affineTwoRing k) := by
    ext; simp
  rw [h]

/-! ### Partial package with adjusted inverse (G4 as explicit hypothesis) -/

theorem hasGoodLineSectionPartial_shear_of_residual
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (p q r : Fin 3 → k) (N : Matrix (Fin 3) (Fin 3) k) (β : k)
    (v : Fin 3 → Polynomial k)
    (h : HasGoodLineSectionPartial F p q r N v)
    (hG4' : ResidualAvoidsConicDiscriminantOn
        (fun i => p i + β * q i) q r (shearFrame3 (-β) * N) F
        (fun i => (v i).comp (Polynomial.X + Polynomial.C β))) :
    HasGoodLineSectionPartial F (fun i => p i + β * q i) q r (shearFrame3 (-β) * N)
      (fun i => (v i).comp (Polynomial.X + Polynomial.C β)) := by
  rcases h with ⟨hdisc, hv0, hviso, _⟩
  refine ⟨?disc, ?v0, ?iso, hG4'⟩
  · exact (lineConicDiscriminant_shear_ne_zero_iff p q β F).mpr hdisc
  · intro hv'
    apply hv0
    funext i
    exact shearPolyHom_injective β (by
      simpa [shearPolyHom_apply] using congrFun hv' i)
  · exact (isotropic_lineTernaryQuadraticPoly_shear_iff p q β F v).mpr hviso

theorem hasGoodLineSectionPartial_scale_of_residual
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (p q r : Fin 3 → k) (N : Matrix (Fin 3) (Fin 3) k) (α δ : k)
    (hα : α ≠ 0) (hδ : δ ≠ 0)
    (v : Fin 3 → Polynomial k)
    (h : HasGoodLineSectionPartial F p q r N v)
    (hG4' : ResidualAvoidsConicDiscriminantOn
        (fun i => α * p i) (fun i => δ * q i) r (scaleFrame3 α⁻¹ δ⁻¹ * N) F
        (fun i => (v i).comp (Polynomial.C (δ / α) * Polynomial.X))) :
    HasGoodLineSectionPartial F (fun i => α * p i) (fun i => δ * q i) r
      (scaleFrame3 α⁻¹ δ⁻¹ * N)
      (fun i => (v i).comp (Polynomial.C (δ / α) * Polynomial.X)) := by
  rcases h with ⟨hdisc, hv0, hviso, _⟩
  refine ⟨?disc, ?v0, ?iso, hG4'⟩
  · exact (lineConicDiscriminant_scale_ne_zero_iff p q α δ hα hδ F hF).mpr hdisc
  · intro hv'
    apply hv0
    funext i
    exact scalePolyHom_injective (div_ne_zero hδ hα) (by
      simpa [scalePolyHom_apply] using congrFun hv' i)
  · exact (isotropic_lineTernaryQuadraticPoly_scale_iff p q α δ hα hδ F hF v).mpr hviso

/-- Residual-disc scale exponent: 3 (Y-coords) * 9 (homogeneous disc) = 27. -/
theorem residualY_scale_disc_exponent : (3 : ℕ) * 9 = 27 := by norm_num

/-! ### Swap partial package (G4 as explicit hypothesis)

Isotropy under swap uses the binary presentation (same normalization as
`lineConicDiscriminant_swap`): the section is transported by `Polynomial.reverse`, and the
zero-iff for the isotropic evaluation is the content of
`isotropic_lineTernaryQuadraticPoly_swap_iff` (recorded open below if not yet closed).
For the partial package we take isotropy of the reversed section as part of the transported
data when G4 is supplied. -/

/-- Swap transport of the partial package with adjusted inverse `N' = swapFrame3 * N` and
section `v' i = (v i).reverse`.  Disc uses `lineConicDiscriminant_swap_ne_zero_iff`; isotropy
and G4 are packaged as hypotheses until the residual-Y / reverse laws land. -/
theorem hasGoodLineSectionPartial_swap_of_residual
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (p q r : Fin 3 → k) (N : Matrix (Fin 3) (Fin 3) k)
    (v : Fin 3 → Polynomial k)
    (h : HasGoodLineSectionPartial F p q r N v)
    (hiso' : TernaryQuadraticPoly.eval (lineTernaryQuadraticPoly q p F)
        (fun i => (v i).reverse) = 0)
    (hG4' : ResidualAvoidsConicDiscriminantOn q p r (swapFrame3 * N) F
        (fun i => (v i).reverse)) :
    HasGoodLineSectionPartial F q p r (swapFrame3 * N) (fun i => (v i).reverse) := by
  rcases h with ⟨hdisc, hv0, _, _⟩
  refine ⟨?disc, ?v0, hiso', hG4'⟩
  · exact (lineConicDiscriminant_swap_ne_zero_iff p q F hF).mpr hdisc
  · intro hv'
    apply hv0
    funext i
    exact (Polynomial.reverse_eq_zero).1 (by
      simpa using congrFun hv' i)

/-- `Polynomial.reverse` is injective on each component, so nonzero sections reverse to nonzero. -/
theorem reverse_section_ne_zero_iff (v : Fin 3 → Polynomial k) :
    (fun i => (v i).reverse) ≠ 0 ↔ v ≠ 0 := by
  constructor
  · intro h hv
    apply h
    funext i
    simp [hv]
  · intro hv h0
    apply hv
    funext i
    exact (Polynomial.reverse_eq_zero).1 (by
      simpa using congrFun h0 i)

end

end BConicBundleMultisections
