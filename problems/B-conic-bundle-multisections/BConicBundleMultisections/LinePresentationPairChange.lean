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
public import BConicBundleMultisections.LinearSubstitutionNonsingular
public import BConicBundleMultisections.PlaneCubicTangentForm
public import Mathlib.Algebra.Polynomial.Reverse
public import Mathlib.Algebra.BigOperators.Fin
public import Mathlib.RingTheory.Localization.FractionRing
public import Mathlib.Algebra.Polynomial.FieldDivision

/-!
# Pair change: swap via homogenization, residual G4 laws, endpoint (Goal F-1b/F-1c/F-1d)

## Adjusted inverses (derived from `lineFrame` columns `(p,q,r)`)

| move | `E` | frame | inverse |
|---|---|---|---|
| shear `β` | `S=!![(1),0,0; β,1,0; 0,0,1]` | `M*S` | `N'=S⁻¹*N` |
| scale `α,δ` | `D=!![α,0,0; 0,δ,0; 0,0,1]` | `M*D` | `N'=D⁻¹*N` |
| swap | `W=!![0,1,0; 1,0,0; 0,0,1]` | `M*W` | `N'=W*N` |

## Exponents

| move | line disc | residual Y clearing | residual disc |
|---|---|---|---|
| shear | `comp(X+Cβ)` | **`e = 3` proved** at complementaryTangentDir / residualAmbientRep | intended `(1+(t+β)²)^{27}`, `(1+t²)^{27}` |
| scale | `C(α^9)·comp(C(δ/α)X)` | intended unit power 3 on Y | intended `α^{27}` (`3·9`) |
| swap | `reflect 9` | via `k(t)[s]`, weight `27` | nonvanishing weight `27` |

## F-1e residual-Y / G4 layer (status)

| piece | status |
|---|---|
| `shearAffineTwoHom` / `scaleAffineTwoHom` | **proved** (injective) |
| partial transports with adjusted `N'` | **proved** (G4 as hyp) |
| `complementaryTangentDir_shear_cleared` | **proved** |
| `residualAmbientRep_shear_cleared` | **proved** (`e = 3`) |
| stereo / cubic fibre shear equivariance | **proved** |
| `residualYCoordsOn_shear_cleared` | **proved** (frame bookkeeping, `e = 3`) |
| automatic G4 **shear** | **proved** (`hasGoodLineSectionPartial_shear_auto`) |
| residual Y scale unit `α³` ⇒ disc `α²⁷` | open |
| swap residual nonvanishing weight 27 | open (k(t)[s] route) |
| swap isotropy (`reverse` normalization) | open |
| automatic G4 scale/swap | open |
| `hasGoodLineSectionPartial_pair_change` | open: blocked on scale/swap G4 + swap isotropy |

**Proved exponent: `e = 3`.** Residual-disc clearing exponent: `9e = 27`.
Shear Y-level law is **literal** after clearing (tangential `γ·p` absorbed at residualAmbientRep).
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

/-! ### F-1d status (residual Y equivariance / pair-change)

Adjusted inverses (proved above): shear `N'=S⁻¹N`, scale `N'=D⁻¹N`, swap `N'=WN`.
Cleared shear exponent `e = 3`; residual disc exponents `9e = 27`. See module docstring.
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

/-! ### F-1d.1 — cleared complementaryTangentDir shear identity

On a homogeneous cubic, Euler forces `grad H · (S p0) = 0` at a point of the cubic. Under that
constraint the cross-product construction does not commute with the shear matrix on the nose:
`S * complementaryTangentDir (H o S) p0 = alpha * complementaryTangentDir H (S p0) + gamma * (S p0)`
with rational twist `alpha = (1+t^2)/(1+(t+beta)^2)`. Clearing denominators gives a polynomial
identity; the residual ambient representative scales by `alpha^3`, so the residual-Y exponent is
`e = 3`. -/

open _root_.MvPolynomial
-- `DeterminantHomogeneous` shadows `Matrix`; use the root scoped notation for `*ᵥ`.
open scoped _root_.Matrix

/-- Gradient of a linearly substituted cubic: `grad(H o M)(r) = M.transpose * grad H (M r)`. -/
theorem tangentGradient_aeval_linearSubst
    {R : Type u} [CommRing R] (M : Matrix (Fin 3) (Fin 3) R)
    (H : MvPolynomial (Fin 3) R) (r : Fin 3 → R) :
    tangentGradient ((aeval (linearSubst 2 M) : MvPolynomial (Fin 3) R →ₐ[R] _) H) r =
      M.transpose *ᵥ tangentGradient H (M *ᵥ r) := by
  change
      (fun i => eval r (pderiv i
          ((aeval (linearSubst 2 M) : MvPolynomial (Fin 3) R →ₐ[R] _) H))) =
        M.transpose *ᵥ fun a => eval (M *ᵥ r) (pderiv a H)
  exact gradient_aeval_linearSubst (n := 2) M H r

/-- Shear matrix over an arbitrary commutative ring (same entries as `shearFrame3`). -/
def shearMatrix3 {R : Type u} [CommRing R] (β : R) : Matrix (Fin 3) (Fin 3) R :=
  !![1, 0, 0; β, 1, 0; 0, 0, 1]

theorem shearMatrix3_mulVec_line {R : Type u} [CommRing R] (β t : R) :
    shearMatrix3 β *ᵥ ![1, t, (0 : R)] = ![1, t + β, 0] := by
  funext i
  fin_cases i <;>
    simp [shearMatrix3, Matrix.mulVec, dotProduct, Fin.sum_univ_three] <;> ring

theorem shearMatrix3_transpose_mulVec {R : Type u} [CommRing R] (β : R) (g : Fin 3 → R) :
    (shearMatrix3 β).transpose *ᵥ g = ![g 0 + β * g 1, g 1, g 2] := by
  funext i
  fin_cases i <;>
    simp [shearMatrix3, Matrix.mulVec, Matrix.transpose, dotProduct, Fin.sum_univ_three] <;>
    ring

theorem shearMatrix3_mulVec_vec {R : Type u} [CommRing R] (β : R) (x y z : R) :
    shearMatrix3 β *ᵥ ![x, y, z] = ![x, β * x + y, z] := by
  funext i
  fin_cases i <;>
    simp [shearMatrix3, Matrix.mulVec, dotProduct, Fin.sum_univ_three] <;> ring

/-- Explicit cross product on the coordinate line point `(1,t,0)`. -/
theorem cross3_line_point {R : Type u} [CommRing R] (t : R) (g : Fin 3 → R) :
    cross3 ![1, t, (0 : R)] g = ![t * g 2, -g 2, g 1 - t * g 0] := by
  funext i
  fin_cases i <;> simp [cross3] <;> ring

/-- **Cleared shear identity for `complementaryTangentDir`.**

With `S = shearMatrix3 β`, `p0 = (1,t,0)`, `σ = t+β`, and Euler at `S p0` on a homogeneous cubic
vanishing there:
```
(1+σ²) • (S * complementaryTangentDir (H o S) p0)
  = (1+t²) • complementaryTangentDir H (S p0)
    + γ • (S p0)
```
for `γ = (t(1+σ²) - (1+t²)σ) * (grad H (S p0)) 2`. The rational ratio of clearing factors is the
twist `α = (1+t²)/(1+σ²)`. -/
theorem complementaryTangentDir_shear_cleared
    {R : Type u} [CommRing R]
    (H : MvPolynomial (Fin 3) R) (hH : H.IsHomogeneous 3)
    (β t : R)
    (hp : eval ![1, t + β, (0 : R)] H = 0) :
    (1 + (t + β) ^ 2) •
        (shearMatrix3 β *ᵥ
          complementaryTangentDir
            ((aeval (linearSubst 2 (shearMatrix3 β)) :
                MvPolynomial (Fin 3) R →ₐ[R] _) H)
            ![1, t, 0]) =
      (1 + t ^ 2) •
          complementaryTangentDir H (shearMatrix3 β *ᵥ ![1, t, 0]) +
        (((t * (1 + (t + β) ^ 2) - (1 + t ^ 2) * (t + β)) *
            tangentGradient H (shearMatrix3 β *ᵥ ![1, t, 0]) 2) •
          (shearMatrix3 β *ᵥ ![1, t, 0])) := by
  let S := shearMatrix3 (R := R) β
  let p0 : Fin 3 → R := ![1, t, 0]
  let σ := t + β
  let H' := (aeval (linearSubst 2 S) : MvPolynomial (Fin 3) R →ₐ[R] _) H
  let g := tangentGradient H ![1, σ, 0]
  have hSp : S *ᵥ p0 = ![1, σ, 0] := shearMatrix3_mulVec_line β t
  -- Euler at (1,σ,0): grad · point = 0
  have hE : g 0 + σ * g 1 = 0 := by
    have htf0 : eval ![1, t + β, (0 : R)] (tangentForm H ![1, t + β, 0]) = 0 :=
      eval_tangentForm_self_eq_zero hH hp
    have htf : eval ![1, σ, (0 : R)] (tangentForm H ![1, σ, 0]) = 0 := by
      convert htf0 using 1 <;> simp only [σ]
    have hdot : tangentGradient H ![1, σ, (0 : R)] ⬝ᵥ ![1, σ, (0 : R)] = 0 := by
      rwa [← eval_tangentForm_eq_dotProduct]
    have hsum : g 0 * 1 + g 1 * σ + g 2 * 0 = 0 := by
      simpa [g, dotProduct, Fin.sum_univ_three] using hdot
    have hsum' : g 0 + g 1 * σ = 0 := by
      convert hsum using 1 <;> ring
    convert hsum' using 1 <;> ring
  have hg0 : g 0 = -(σ * g 1) := eq_neg_of_add_eq_zero_left hE
  -- g at S p0 equals g (same point)
  have hgSp : tangentGradient H (S *ᵥ p0) = g := by
    rw [hSp]
  -- Chain rule: grad H' p0 = Sᵀ g
  have hgrad : tangentGradient H' p0 = S.transpose *ᵥ g := by
    have := tangentGradient_aeval_linearSubst S H p0
    rwa [hgSp] at this
  have hw : S.transpose *ᵥ g = ![g 0 + β * g 1, g 1, g 2] :=
    shearMatrix3_transpose_mulVec β g
  -- Expand left direction
  have hL : S *ᵥ complementaryTangentDir H' p0 =
      ![t * g 2, (β * t - 1) * g 2, g 1 - t * g 0 - t * β * g 1] := by
    have hc : complementaryTangentDir H' p0 =
        cross3 p0 (S.transpose *ᵥ g) := by
      simp only [complementaryTangentDir, hgrad]
    rw [hc, hw, cross3_line_point, shearMatrix3_mulVec_vec]
    funext j
    fin_cases j <;> simp <;> ring
  -- Expand right direction
  have hR : complementaryTangentDir H (S *ᵥ p0) =
      ![σ * g 2, -g 2, g 1 - σ * g 0] := by
    rw [hSp, complementaryTangentDir, cross3_line_point]
  -- Componentwise identity
  funext i
  simp only [Pi.smul_apply, smul_eq_mul, Pi.add_apply]
  have hz : g 1 - t * g 0 - t * β * g 1 = g 1 * (1 + t ^ 2) := by
    calc
      g 1 - t * g 0 - t * β * g 1
          = g 1 - t * (-(σ * g 1)) - t * β * g 1 := by rw [hg0]
      _ = g 1 + (t * σ - t * β) * g 1 := by ring
      _ = g 1 + t * t * g 1 := by simp only [σ]; ring
      _ = g 1 * (1 + t ^ 2) := by ring
  have hz' : g 1 - σ * g 0 = g 1 * (1 + σ ^ 2) := by
    calc
      g 1 - σ * g 0 = g 1 - σ * (-(σ * g 1)) := by rw [hg0]
      _ = g 1 * (1 + σ ^ 2) := by ring
  have hgoal :
      (1 + σ ^ 2) * (S *ᵥ complementaryTangentDir H' p0) i =
        (1 + t ^ 2) * complementaryTangentDir H (S *ᵥ p0) i +
          ((t * (1 + σ ^ 2) - (1 + t ^ 2) * σ) * g 2) * (S *ᵥ p0) i := by
    rw [hL, hR, hSp]
    fin_cases i
    · -- x
      change (1 + σ ^ 2) * (t * g 2) =
          (1 + t ^ 2) * (σ * g 2) + ((t * (1 + σ ^ 2) - (1 + t ^ 2) * σ) * g 2) * 1
      ring
    · -- y
      change (1 + σ ^ 2) * ((β * t - 1) * g 2) =
          (1 + t ^ 2) * (-g 2) + ((t * (1 + σ ^ 2) - (1 + t ^ 2) * σ) * g 2) * σ
      ring
    · -- z
      change (1 + σ ^ 2) * (g 1 - t * g 0 - t * β * g 1) =
          (1 + t ^ 2) * (g 1 - σ * g 0) + ((t * (1 + σ ^ 2) - (1 + t ^ 2) * σ) * g 2) * 0
      rw [hz, hz']; ring
  -- reduce the original goal to hgoal via the local aliases
  simpa [S, p0, σ, H', g, hSp, hgSp, smul_eq_mul, Pi.smul_apply, Pi.add_apply]
    using hgoal

/-- The two directions differ by reparametrisation after clearing. -/
theorem complementaryTangentDir_shear_reparam
    {R : Type u} [CommRing R]
    (H : MvPolynomial (Fin 3) R) (hH : H.IsHomogeneous 3)
    (β t : R)
    (hp : eval ![1, t + β, (0 : R)] H = 0) :
    ∃ γ : R,
      (1 + (t + β) ^ 2) •
          (shearMatrix3 β *ᵥ
            complementaryTangentDir
              ((aeval (linearSubst 2 (shearMatrix3 β)) :
                  MvPolynomial (Fin 3) R →ₐ[R] _) H)
              ![1, t, 0]) =
        (1 + t ^ 2) • complementaryTangentDir H (shearMatrix3 β *ᵥ ![1, t, 0]) +
          γ • (shearMatrix3 β *ᵥ ![1, t, 0]) := by
  refine ⟨((t * (1 + (t + β) ^ 2) - (1 + t ^ 2) * (t + β)) *
      tangentGradient H (shearMatrix3 β *ᵥ ![1, t, 0]) 2), ?_⟩
  simpa using complementaryTangentDir_shear_cleared H hH β t hp

/-- Residual-Y clearing exponent under shear: direction scale cubed. -/
theorem residualY_shear_clearing_exponent : (3 : ℕ) = 3 := rfl

/-- Combined residual-disc exponent under shear: `e * 9 = 27`. -/
theorem residualY_shear_disc_exponent : (3 : ℕ) * 9 = 27 := by norm_num

/-! ### Residual ambient representative under cleared direction reparam -/

/-- If `c · q' = d · q + γ · p` and `q` is a double-contact direction, residual points scale by
the cubes of the clearing factors. -/
theorem residualAmbientRep_cleared_reparam {R : Type u} [CommRing R]
    (p q q' : Fin 3 → R) (c d γ : R)
    (G : MvPolynomial (Fin 3) R) (hG : G.IsHomogeneous 3)
    (hp : eval p G = 0)
    (hq : q ∈ tangentHyperplaneCone G p)
    (hreparam : (fun i => c * q' i) = fun i => d * q i + γ * p i) :
    (fun i => c ^ 3 * residualAmbientRep p q' (binaryLineRestriction p q' G) i) =
      fun i => d ^ 3 * residualAmbientRep p q (binaryLineRestriction p q G) i := by
  classical
  obtain ⟨h30, h21⟩ := coeff_binaryLineRestriction_double_contact G hG p q hp hq
  have hf : (binaryLineRestriction p q G).IsHomogeneous 3 :=
    binaryLineRestriction_isHomogeneous hG p q
  have hdir : residualAmbientRep p (fun i => c * q' i)
        (binaryLineRestriction p (fun i => c * q' i) G) =
      residualAmbientRep p (fun i => d * q i + γ * p i)
        (binaryLineRestriction p (fun i => d * q i + γ * p i) G) := by
    simp only [hreparam]
  have hright :
      residualAmbientRep p (fun i => d * q i + γ * p i)
          (binaryLineRestriction p (fun i => d * q i + γ * p i) G) =
        fun i => d ^ 3 * residualAmbientRep p q (binaryLineRestriction p q G) i := by
    rw [binaryLineRestriction_reparam p q d γ G]
    exact residualAmbientRep_reparam p q d γ (binaryLineRestriction p q G) hf h30 h21
  have hleft_scale :
      residualAmbientRep p (fun i => c * q' i)
          (binaryLineRestriction p (fun i => c * q' i) G) =
        fun i => c ^ 3 * residualAmbientRep p q' (binaryLineRestriction p q' G) i := by
    have hdir' : (fun i => c * q' i) = fun i => c * q' i + (0 : R) * p i := by
      funext i; ring
    have hbr : binaryLineRestriction p (fun i => c * q' i) G =
        binaryReparam c 0 (binaryLineRestriction p q' G) := by
      rw [hdir']; exact binaryLineRestriction_reparam p q' c 0 G
    rw [hbr]
    exact residualAmbientRep_smul_dir_coeff p q' c (binaryLineRestriction p q' G)
  funext i
  calc
    c ^ 3 * residualAmbientRep p q' (binaryLineRestriction p q' G) i =
        residualAmbientRep p (fun j => c * q' j)
          (binaryLineRestriction p (fun j => c * q' j) G) i := by
      rw [← congrFun hleft_scale i]
    _ = residualAmbientRep p (fun j => d * q j + γ * p j)
          (binaryLineRestriction p (fun j => d * q j + γ * p j) G) i := by
      rw [← congrFun hdir i]
    _ = d ^ 3 * residualAmbientRep p q (binaryLineRestriction p q G) i := by
      rw [← congrFun hright i]

/-- Shear clearing at the residual-ambient level: factors `(1+(t+β)²)³` and `(1+t²)³`. -/
theorem residualAmbientRep_shear_cleared
    {R : Type u} [CommRing R]
    (H : MvPolynomial (Fin 3) R) (hH : H.IsHomogeneous 3)
    (β t : R)
    (hp : eval ![1, t + β, (0 : R)] H = 0) :
    (fun i => (1 + (t + β) ^ 2) ^ 3 *
        residualAmbientRep (shearMatrix3 β *ᵥ ![1, t, (0 : R)])
          (shearMatrix3 β *ᵥ
            complementaryTangentDir
              ((aeval (linearSubst 2 (shearMatrix3 β)) :
                  MvPolynomial (Fin 3) R →ₐ[R] _) H)
              ![1, t, 0])
          (binaryLineRestriction (shearMatrix3 β *ᵥ ![1, t, 0])
            (shearMatrix3 β *ᵥ
              complementaryTangentDir
                ((aeval (linearSubst 2 (shearMatrix3 β)) :
                    MvPolynomial (Fin 3) R →ₐ[R] _) H)
                ![1, t, 0])
            H) i) =
      fun i => (1 + t ^ 2) ^ 3 *
        residualAmbientRep (shearMatrix3 β *ᵥ ![1, t, (0 : R)])
          (complementaryTangentDir H (shearMatrix3 β *ᵥ ![1, t, 0]))
          (binaryLineRestriction (shearMatrix3 β *ᵥ ![1, t, 0])
            (complementaryTangentDir H (shearMatrix3 β *ᵥ ![1, t, 0])) H) i := by
  set S := shearMatrix3 (R := R) β
  set p0 : Fin 3 → R := ![1, t, 0]
  set σ := t + β
  set H' := (aeval (linearSubst 2 S) : MvPolynomial (Fin 3) R →ₐ[R] _) H
  set pS := S *ᵥ p0
  set qS := complementaryTangentDir H pS
  set q0 := complementaryTangentDir H' p0
  set q0S := S *ᵥ q0
  obtain ⟨γ, hγ⟩ := complementaryTangentDir_shear_reparam H hH β t hp
  have hreparam : (fun i => (1 + σ ^ 2) * q0S i) =
      fun i => (1 + t ^ 2) * qS i + γ * pS i := by
    funext i
    have hi := congrFun hγ i
    simpa [Pi.smul_apply, smul_eq_mul, Pi.add_apply, q0S, q0, qS, pS, S, p0, σ, H'] using hi
  have hpS : eval pS H = 0 := by
    simp only [pS, S, p0, shearMatrix3_mulVec_line]
    exact hp
  have hqS : qS ∈ tangentHyperplaneCone H pS :=
    complementaryTangentDir_mem_tangentHyperplaneCone H pS
  have h := residualAmbientRep_cleared_reparam pS qS q0S
      (1 + σ ^ 2) (1 + t ^ 2) γ H hH hpS hqS hreparam
  -- rewrite aliases back to the goal statement
  exact h


/-! ### F-1d.1 continued — stereo shear equivariance -/

/-- Affine line point shears as `t ↦ t+β`. -/
theorem shearAffineTwoHom_affineTwoLinePoint (p q : Fin 3 → k) (β : k) :
    (fun i => shearAffineTwoHom β (affineTwoLinePoint p q i)) =
      affineTwoLinePoint (fun i => p i + β * q i) q := by
  funext i
  simp only [affineTwoLinePoint, linePointOf, map_add, map_mul, shearAffineTwoHom_C,
    shearAffineTwoHom_affineTwoCoord0]
  ring

/-- Specialised conic along the sheared line is the shear of the original specialised conic. -/
theorem map_lineSpecializedConicPullback_shear
    (p q : Fin 3 → k) (β : k)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) :
    map (shearAffineTwoHom β) (lineSpecializedConicPullback p q F) =
      lineSpecializedConicPullback (fun i => p i + β * q i) q F := by
  simp only [lineSpecializedConicPullback]
  rw [map_specializeSecondCoordinates, shearAffineTwoHom_affineTwoPullback,
    shearAffineTwoHom_affineTwoLinePoint]

/-- Stereo first coords transform under shear of the line presentation and section. -/
theorem stereoFirstCoordsOn_shear
    (p q : Fin 3 → k) (β : k)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (v : Fin 3 → Polynomial k) :
    (fun i => shearAffineTwoHom β (stereoFirstCoordsOn p q F v i)) =
      stereoFirstCoordsOn (fun i => p i + β * q i) q F
        (fun i => (v i).comp (Polynomial.X + Polynomial.C β)) := by
  -- map_stereoAlg : φ ∘ stereoAlg Q p w = stereoAlg (map φ Q) (φ∘p) (φ∘w)
  have h := map_stereoAlg (shearAffineTwoHom β)
      (lineSpecializedConicPullback p q F) (liftTsenSection v) affineTwoStereoDir
  -- h : (fun i => φ (stereoAlg ... i)) = stereoAlg (map φ Q) (φ∘p) (φ∘w)
  have h1 : map (shearAffineTwoHom β) (lineSpecializedConicPullback p q F) =
      lineSpecializedConicPullback (fun i => p i + β * q i) q F :=
    map_lineSpecializedConicPullback_shear p q β F
  have h2 : (fun i => shearAffineTwoHom β (liftTsenSection v i)) =
      liftTsenSection (fun i => shearPolyHom β (v i)) :=
    (liftTsenSection_shearPolyHom β v).symm
  have h3 : (fun i => shearAffineTwoHom β (affineTwoStereoDir (k := k) i)) =
      affineTwoStereoDir (k := k) :=
    shearAffineTwoHom_affineTwoStereoDir β
  -- rewrite RHS of h
  have h' :
      (fun i => shearAffineTwoHom β
          (stereoAlg (lineSpecializedConicPullback p q F) (liftTsenSection v)
            affineTwoStereoDir i)) =
        stereoAlg (lineSpecializedConicPullback (fun i => p i + β * q i) q F)
          (liftTsenSection (fun i => shearPolyHom β (v i))) affineTwoStereoDir := by
    rw [h, h1, h2, h3]
  simpa [stereoFirstCoordsOn, shearPolyHom_apply] using h'

/-- Cubic fibre transforms under shear of the stereo point. -/
theorem map_cubicFiberPullback_shear
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (x : Fin 3 → affineTwoRing k) (β : k) :
    map (shearAffineTwoHom β) (cubicFiberPullback F x) =
      cubicFiberPullback F (fun i => shearAffineTwoHom β (x i)) := by
  simp only [cubicFiberPullback]
  rw [ResidualDataBaseChange.map_specializeFirstCoords, shearAffineTwoHom_affineTwoPullback]

/-- Clearing polynomials `1+t²` and `1+(t+β)²` are nonzero in `k[t,s]`. -/
theorem one_add_t_sq_ne_zero :
    (1 + affineTwoCoord0 k ^ 2 : affineTwoRing k) ≠ 0 := by
  intro h
  have hC : (C (1 : k) + X (ULift.up (0 : Fin 2)) ^ 2 : affineTwoRing k) = 0 := by
    simpa [affineTwoCoord0] using h
  have := congrArg (aeval (fun _ : ULift (Fin 2) => (0 : k))) hC
  simpa using this

theorem one_add_t_add_beta_sq_ne_zero (β : k) :
    (1 + (affineTwoCoord0 k + C β) ^ 2 : affineTwoRing k) ≠ 0 := by
  intro h
  have hC :
      (1 + (X (ULift.up (0 : Fin 2)) + C β) ^ 2 : affineTwoRing k) = 0 := by
    simpa [affineTwoCoord0] using h
  have := congrArg
      (aeval (fun i : ULift (Fin 2) => if i.down = 0 then (-β : k) else (0 : k))) hC
  simp only [map_add, map_pow, map_one, aeval_X, aeval_C, MvPolynomial.algebraMap_eq] at this
  simpa using this

/-- `aeval` of a base-field polynomial after applying shear to the point equals shear of the
original `aeval`. -/
theorem aeval_shearAffineTwoHom_sndConicDiscriminant
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (β : k)
    (y : Fin 3 → affineTwoRing k) :
    aeval (fun i => shearAffineTwoHom β (y i)) (sndConicDiscriminant F) =
      shearAffineTwoHom β (aeval y (sndConicDiscriminant F)) := by
  induction (sndConicDiscriminant F) using MvPolynomial.induction_on with
  | C a =>
      simp only [aeval_C]
      exact (shearAffineTwoHom_C β a).symm
  | add p q hp hq =>
      simp only [map_add, hp, hq]
  | mul_X p i hp =>
      simp only [map_mul, aeval_X, hp]

/-- Same for scale. -/
theorem aeval_scaleAffineTwoHom_sndConicDiscriminant
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (μ : k)
    (y : Fin 3 → affineTwoRing k) :
    aeval (fun i => scaleAffineTwoHom μ (y i)) (sndConicDiscriminant F) =
      scaleAffineTwoHom μ (aeval y (sndConicDiscriminant F)) := by
  induction (sndConicDiscriminant F) using MvPolynomial.induction_on with
  | C a =>
      simp only [aeval_C]
      exact (scaleAffineTwoHom_C μ a).symm
  | add p q hp hq =>
      simp only [map_add, hp, hq]
  | mul_X p i hp =>
      simp only [map_mul, aeval_X, hp]

/-! ### F-1e.1 — residual Y pointwise shear (frame bookkeeping)

Route: reduce general `residualYCoordsOn` to coordinate-line `residualYCoords` via
`residualYCoordsOn_eq_mulVec_residualYCoords_secondBlockSubst`, then apply the cleared
`residualAmbientRep_shear_cleared` identity to the second-block shear of that equation. -/

theorem shearFrame3_map_C (β : k) :
    (shearFrame3 β).map (C : k →+* affineTwoRing k) =
      shearMatrix3 (C β) := by
  ext i j
  fin_cases i <;> fin_cases j <;> simp [shearFrame3, shearMatrix3, Matrix.map_apply]

theorem affineTwoLineFrame_shear (p q r : Fin 3 → k) (β : k) :
    affineTwoLineFrame (fun i => p i + β * q i) q r =
      affineTwoLineFrame p q r * (shearFrame3 β).map C := by
  have h := congrArg (fun M : Matrix (Fin 3) (Fin 3) k =>
      M.map (C : k →+* affineTwoRing k)) (lineFrame_shear p q r β)
  simpa [affineTwoLineFrame, lineFrame_map, Matrix.map_mul] using h

private theorem eval_map_comp {R S : Type u} [CommRing R] [CommRing S]
    (φ : R →+* S) (p : Fin 3 → R) (G : MvPolynomial (Fin 3) R) :
    eval (fun i => φ (p i)) (map φ G) = φ (eval p G) := by
  rw [eval_map]
  induction G using MvPolynomial.induction_on with
  | C a => simp
  | add f g hf hg => simp [hf, hg]
  | mul_X f i hf => simp [hf]

private theorem map_residualAmbientRep_ringHom {R S : Type u} [CommRing R] [CommRing S]
    (φ : R →+* S) {σ : Type*} (p q : σ → R) (g : MvPolynomial (Fin 2) R) :
    (fun i => φ (residualAmbientRep p q g i)) =
      residualAmbientRep (fun j => φ (p j)) (fun j => φ (q j)) (map φ g) := by
  funext i
  simp [residualAmbientRep, residualBinaryRep, coeff_map]

theorem stereoFirstCoords_secondBlock_shear
    (β : k) (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (v : Fin 3 → Polynomial k) :
    stereoFirstCoords (secondBlockSubst (shearFrame3 β) F)
        (fun i => (v i).comp (Polynomial.X + Polynomial.C β)) =
      (fun i => shearAffineTwoHom β (stereoFirstCoords F v i)) := by
  have hline :
      lineFrame (fun i => (![1, 0, 0] : Fin 3 → k) i + β * (![0, 1, 0] : Fin 3 → k) i)
          ![0, 1, 0] ![0, 0, 1] =
        shearFrame3 β := by
    simpa [lineFrame_coordinate, one_mul] using
      lineFrame_shear (![1, 0, 0] : Fin 3 → k) ![0, 1, 0] ![0, 0, 1] β
  calc
    stereoFirstCoords (secondBlockSubst (shearFrame3 β) F)
        (fun i => (v i).comp (Polynomial.X + Polynomial.C β)) =
      stereoFirstCoordsOn
        (fun i => (![1, 0, 0] : Fin 3 → k) i + β * (![0, 1, 0] : Fin 3 → k) i)
        ![0, 1, 0] F
        (fun i => (v i).comp (Polynomial.X + Polynomial.C β)) := by
      rw [← hline]
      exact (stereoFirstCoordsOn_eq_stereoFirstCoords_secondBlockSubst
        (fun i => (![1, 0, 0] : Fin 3 → k) i + β * (![0, 1, 0] : Fin 3 → k) i)
        ![0, 1, 0] ![0, 0, 1] F _).symm
    _ = (fun i => shearAffineTwoHom β
          (stereoFirstCoordsOn ![1, 0, 0] ![0, 1, 0] F v i)) :=
      (stereoFirstCoordsOn_shear ![1, 0, 0] ![0, 1, 0] β F v).symm
    _ = (fun i => shearAffineTwoHom β (stereoFirstCoords F v i)) := by
      simp only [stereoFirstCoordsOn_coordinate]

/-- `φ` of the coordinate-line residual equals residualAmbientRep of the mapped data. -/
theorem residualYCoords_map_shear
    (β : k) (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (v : Fin 3 → Polynomial k) :
    (fun i => shearAffineTwoHom β (residualYCoords F v i)) =
      residualAmbientRep
        (fun j => shearAffineTwoHom β (affineTwoCoordinateLineY k j))
        (fun j => shearAffineTwoHom β
          (complementaryTangentDir
            (cubicFiberPullback F (stereoFirstCoords F v))
            (affineTwoCoordinateLineY k) j))
        (map (shearAffineTwoHom β)
          (binaryLineRestriction (affineTwoCoordinateLineY k)
            (complementaryTangentDir
              (cubicFiberPullback F (stereoFirstCoords F v))
              (affineTwoCoordinateLineY k))
            (cubicFiberPullback F (stereoFirstCoords F v)))) :=
  map_residualAmbientRep_ringHom (shearAffineTwoHom β)
    (affineTwoCoordinateLineY k)
    (complementaryTangentDir
      (cubicFiberPullback F (stereoFirstCoords F v))
      (affineTwoCoordinateLineY k))
    (binaryLineRestriction (affineTwoCoordinateLineY k)
      (complementaryTangentDir
        (cubicFiberPullback F (stereoFirstCoords F v))
        (affineTwoCoordinateLineY k))
      (cubicFiberPullback F (stereoFirstCoords F v)))

private theorem shear_affineTwoCoordinateLineY (β : k) :
    (fun j => shearAffineTwoHom β (affineTwoCoordinateLineY k j)) =
      shearMatrix3 (C β) *ᵥ affineTwoCoordinateLineY k := by
  funext j
  fin_cases j <;>
    simp [affineTwoCoordinateLineY, shearAffineTwoHom_C, shearAffineTwoHom_affineTwoCoord0,
      shearMatrix3_mulVec_line]

private theorem residualYCoords_eq_ambient
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (v : Fin 3 → Polynomial k) :
    residualYCoords F v =
      residualAmbientRep (affineTwoCoordinateLineY k)
        (complementaryTangentDir
          (cubicFiberPullback F (stereoFirstCoords F v))
          (affineTwoCoordinateLineY k))
        (binaryLineRestriction (affineTwoCoordinateLineY k)
          (complementaryTangentDir
            (cubicFiberPullback F (stereoFirstCoords F v))
            (affineTwoCoordinateLineY k))
          (cubicFiberPullback F (stereoFirstCoords F v))) :=
  rfl

/-- Cleared residual-`Y` law under second-block shear (coordinate-line residual). -/
theorem residualYCoords_secondBlock_shear_cleared
    (β : k) (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (v : Fin 3 → Polynomial k)
    (hv : TernaryQuadraticPoly.eval (coordinateLineTernaryQuadraticPoly F) v = 0) :
    (fun i => (1 + (affineTwoCoord0 k + C β) ^ 2) ^ 3 *
        (shearMatrix3 (C β) *ᵥ
          residualYCoords (secondBlockSubst (shearFrame3 β) F)
            (fun j => (v j).comp (Polynomial.X + Polynomial.C β))) i) =
      (fun i => (1 + affineTwoCoord0 k ^ 2) ^ 3 *
        shearAffineTwoHom β (residualYCoords F v i)) := by
  -- abbreviations used only in local `have`s (no `set`/`let` that block `rw`)
  have hx' :
      stereoFirstCoords (secondBlockSubst (shearFrame3 β) F)
          (fun j => (v j).comp (Polynomial.X + Polynomial.C β)) =
        fun i => shearAffineTwoHom β (stereoFirstCoords F v i) :=
    stereoFirstCoords_secondBlock_shear β F v
  have hGmap :
      map (shearAffineTwoHom β) (cubicFiberPullback F (stereoFirstCoords F v)) =
        cubicFiberPullback F
          (fun i => shearAffineTwoHom β (stereoFirstCoords F v i)) :=
    map_cubicFiberPullback_shear F (stereoFirstCoords F v) β
  have hG' :
      cubicFiberPullback (secondBlockSubst (shearFrame3 β) F)
          (stereoFirstCoords (secondBlockSubst (shearFrame3 β) F)
            (fun j => (v j).comp (Polynomial.X + Polynomial.C β))) =
        (aeval (linearSubst 2 (shearMatrix3 (C β))) :
          MvPolynomial (Fin 3) (affineTwoRing k) →ₐ[affineTwoRing k] _)
          (map (shearAffineTwoHom β)
            (cubicFiberPullback F (stereoFirstCoords F v))) := by
    rw [cubicFiberPullback_secondBlockSubst, shearFrame3_map_C, hx', ← hGmap]
  have hp0 :
      eval (affineTwoCoordinateLineY k)
        (cubicFiberPullback F (stereoFirstCoords F v)) = 0 :=
    eval_cubicFiber_coordinateLine_of_stereo F hF v hv
  have hpH :
      eval ![1, affineTwoCoord0 k + C β, (0 : affineTwoRing k)]
        (map (shearAffineTwoHom β)
          (cubicFiberPullback F (stereoFirstCoords F v))) = 0 := by
    have h1 :=
      eval_map_comp (shearAffineTwoHom β) (affineTwoCoordinateLineY k)
        (cubicFiberPullback F (stereoFirstCoords F v))
    have h2 : (fun i => shearAffineTwoHom β (affineTwoCoordinateLineY k i)) =
        ![1, affineTwoCoord0 k + C β, 0] := by
      simpa [shear_affineTwoCoordinateLineY, shearMatrix3_mulVec_line,
        affineTwoCoordinateLineY] using shear_affineTwoCoordinateLineY β
    rw [← h2, h1, hp0, map_zero]
  have hHhom :
      (map (shearAffineTwoHom β)
          (cubicFiberPullback F (stereoFirstCoords F v))).IsHomogeneous 3 :=
    (cubicFiberPullback_isHomogeneous F hF _).map _
  -- core cleared identity
  have hcleared :=
    residualAmbientRep_shear_cleared
      (map (shearAffineTwoHom β) (cubicFiberPullback F (stereoFirstCoords F v)))
      hHhom (C β) (affineTwoCoord0 k) hpH
  -- residualYCoords after second-block shear
  have hY' :
      residualYCoords (secondBlockSubst (shearFrame3 β) F)
          (fun j => (v j).comp (Polynomial.X + Polynomial.C β)) =
        residualAmbientRep (affineTwoCoordinateLineY k)
          (complementaryTangentDir
            (cubicFiberPullback (secondBlockSubst (shearFrame3 β) F)
              (stereoFirstCoords (secondBlockSubst (shearFrame3 β) F)
                (fun j => (v j).comp (Polynomial.X + Polynomial.C β))))
            (affineTwoCoordinateLineY k))
          (binaryLineRestriction (affineTwoCoordinateLineY k)
            (complementaryTangentDir
              (cubicFiberPullback (secondBlockSubst (shearFrame3 β) F)
                (stereoFirstCoords (secondBlockSubst (shearFrame3 β) F)
                  (fun j => (v j).comp (Polynomial.X + Polynomial.C β))))
              (affineTwoCoordinateLineY k))
            (cubicFiberPullback (secondBlockSubst (shearFrame3 β) F)
              (stereoFirstCoords (secondBlockSubst (shearFrame3 β) F)
                (fun j => (v j).comp (Polynomial.X + Polynomial.C β))))) :=
    residualYCoords_eq_ambient _ _
  have hbin :
      binaryLineRestriction (affineTwoCoordinateLineY k)
          (complementaryTangentDir
            (cubicFiberPullback (secondBlockSubst (shearFrame3 β) F)
              (stereoFirstCoords (secondBlockSubst (shearFrame3 β) F)
                (fun j => (v j).comp (Polynomial.X + Polynomial.C β))))
            (affineTwoCoordinateLineY k))
          (cubicFiberPullback (secondBlockSubst (shearFrame3 β) F)
            (stereoFirstCoords (secondBlockSubst (shearFrame3 β) F)
              (fun j => (v j).comp (Polynomial.X + Polynomial.C β)))) =
        binaryLineRestriction
          (shearMatrix3 (C β) *ᵥ affineTwoCoordinateLineY k)
          (shearMatrix3 (C β) *ᵥ complementaryTangentDir
            (cubicFiberPullback (secondBlockSubst (shearFrame3 β) F)
              (stereoFirstCoords (secondBlockSubst (shearFrame3 β) F)
                (fun j => (v j).comp (Polynomial.X + Polynomial.C β))))
            (affineTwoCoordinateLineY k))
          (map (shearAffineTwoHom β)
            (cubicFiberPullback F (stereoFirstCoords F v))) := by
    rw [hG', binaryLineRestriction_aeval_linearSubst]
  have hmul :
      shearMatrix3 (C β) *ᵥ residualYCoords (secondBlockSubst (shearFrame3 β) F)
          (fun j => (v j).comp (Polynomial.X + Polynomial.C β)) =
        residualAmbientRep
          (shearMatrix3 (C β) *ᵥ affineTwoCoordinateLineY k)
          (shearMatrix3 (C β) *ᵥ complementaryTangentDir
            (cubicFiberPullback (secondBlockSubst (shearFrame3 β) F)
              (stereoFirstCoords (secondBlockSubst (shearFrame3 β) F)
                (fun j => (v j).comp (Polynomial.X + Polynomial.C β))))
            (affineTwoCoordinateLineY k))
          (binaryLineRestriction
            (shearMatrix3 (C β) *ᵥ affineTwoCoordinateLineY k)
            (shearMatrix3 (C β) *ᵥ complementaryTangentDir
              (cubicFiberPullback (secondBlockSubst (shearFrame3 β) F)
                (stereoFirstCoords (secondBlockSubst (shearFrame3 β) F)
                  (fun j => (v j).comp (Polynomial.X + Polynomial.C β))))
              (affineTwoCoordinateLineY k))
            (map (shearAffineTwoHom β)
              (cubicFiberPullback F (stereoFirstCoords F v)))) := by
    rw [hY', mulVec_residualAmbientRep, hbin]
  -- rewrite φ(residualYCoords) via mapped complementaryTangentDir
  have hqφ :
      (fun j => shearAffineTwoHom β
          (complementaryTangentDir
            (cubicFiberPullback F (stereoFirstCoords F v))
            (affineTwoCoordinateLineY k) j)) =
        complementaryTangentDir
          (map (shearAffineTwoHom β)
            (cubicFiberPullback F (stereoFirstCoords F v)))
          (shearMatrix3 (C β) *ᵥ affineTwoCoordinateLineY k) := by
    have h := map_complementaryTangentDir (shearAffineTwoHom β)
      (cubicFiberPullback F (stereoFirstCoords F v)) (affineTwoCoordinateLineY k)
    have h' : (fun j => shearAffineTwoHom β
          (complementaryTangentDir
            (cubicFiberPullback F (stereoFirstCoords F v))
            (affineTwoCoordinateLineY k) j)) =
        complementaryTangentDir
          (map (shearAffineTwoHom β)
            (cubicFiberPullback F (stereoFirstCoords F v)))
          (fun j => shearAffineTwoHom β (affineTwoCoordinateLineY k j)) := by
      simpa [Function.comp_def] using h
    rwa [shear_affineTwoCoordinateLineY] at h'
  have hbinφ :
      map (shearAffineTwoHom β)
          (binaryLineRestriction (affineTwoCoordinateLineY k)
            (complementaryTangentDir
              (cubicFiberPullback F (stereoFirstCoords F v))
              (affineTwoCoordinateLineY k))
            (cubicFiberPullback F (stereoFirstCoords F v))) =
        binaryLineRestriction
          (shearMatrix3 (C β) *ᵥ affineTwoCoordinateLineY k)
          (complementaryTangentDir
            (map (shearAffineTwoHom β)
              (cubicFiberPullback F (stereoFirstCoords F v)))
            (shearMatrix3 (C β) *ᵥ affineTwoCoordinateLineY k))
          (map (shearAffineTwoHom β)
            (cubicFiberPullback F (stereoFirstCoords F v))) := by
    have h := map_binaryLineRestriction (shearAffineTwoHom β)
      (affineTwoCoordinateLineY k)
      (complementaryTangentDir
        (cubicFiberPullback F (stereoFirstCoords F v))
        (affineTwoCoordinateLineY k))
      (cubicFiberPullback F (stereoFirstCoords F v))
    -- rewrite Function.comp points via the two equivariance lemmas
    have hp :
        (shearAffineTwoHom β ∘ affineTwoCoordinateLineY k) =
          shearMatrix3 (C β) *ᵥ affineTwoCoordinateLineY k := by
      funext j; simpa [Function.comp_apply] using congrFun (shear_affineTwoCoordinateLineY β) j
    have hq :
        (shearAffineTwoHom β ∘ complementaryTangentDir
            (cubicFiberPullback F (stereoFirstCoords F v))
            (affineTwoCoordinateLineY k)) =
          complementaryTangentDir
            (map (shearAffineTwoHom β)
              (cubicFiberPullback F (stereoFirstCoords F v)))
            (shearMatrix3 (C β) *ᵥ affineTwoCoordinateLineY k) := by
      funext j; simpa [Function.comp_apply] using congrFun hqφ j
    rw [h, hp, hq]
  have hYφ :
      (fun i => shearAffineTwoHom β (residualYCoords F v i)) =
        residualAmbientRep
          (shearMatrix3 (C β) *ᵥ affineTwoCoordinateLineY k)
          (complementaryTangentDir
            (map (shearAffineTwoHom β)
              (cubicFiberPullback F (stereoFirstCoords F v)))
            (shearMatrix3 (C β) *ᵥ affineTwoCoordinateLineY k))
          (binaryLineRestriction
            (shearMatrix3 (C β) *ᵥ affineTwoCoordinateLineY k)
            (complementaryTangentDir
              (map (shearAffineTwoHom β)
                (cubicFiberPullback F (stereoFirstCoords F v)))
              (shearMatrix3 (C β) *ᵥ affineTwoCoordinateLineY k))
            (map (shearAffineTwoHom β)
              (cubicFiberPullback F (stereoFirstCoords F v)))) := by
    rw [residualYCoords_map_shear, shear_affineTwoCoordinateLineY, hqφ, hbinφ]
  -- connect G' ctd to H∘S ctd
  have hctd :
      complementaryTangentDir
          (cubicFiberPullback (secondBlockSubst (shearFrame3 β) F)
            (stereoFirstCoords (secondBlockSubst (shearFrame3 β) F)
              (fun j => (v j).comp (Polynomial.X + Polynomial.C β))))
          (affineTwoCoordinateLineY k) =
        complementaryTangentDir
          ((aeval (linearSubst 2 (shearMatrix3 (C β))) :
            MvPolynomial (Fin 3) (affineTwoRing k) →ₐ[affineTwoRing k] _)
            (map (shearAffineTwoHom β)
              (cubicFiberPullback F (stereoFirstCoords F v))))
          (affineTwoCoordinateLineY k) := by
    rw [hG']
  -- restate hcleared with G' direction and affineTwoCoordinateLineY
  have hcleared' :
      (fun i => (1 + (affineTwoCoord0 k + C β) ^ 2) ^ 3 *
          residualAmbientRep
            (shearMatrix3 (C β) *ᵥ affineTwoCoordinateLineY k)
            (shearMatrix3 (C β) *ᵥ complementaryTangentDir
              (cubicFiberPullback (secondBlockSubst (shearFrame3 β) F)
                (stereoFirstCoords (secondBlockSubst (shearFrame3 β) F)
                  (fun j => (v j).comp (Polynomial.X + Polynomial.C β))))
              (affineTwoCoordinateLineY k))
            (binaryLineRestriction
              (shearMatrix3 (C β) *ᵥ affineTwoCoordinateLineY k)
              (shearMatrix3 (C β) *ᵥ complementaryTangentDir
                (cubicFiberPullback (secondBlockSubst (shearFrame3 β) F)
                  (stereoFirstCoords (secondBlockSubst (shearFrame3 β) F)
                    (fun j => (v j).comp (Polynomial.X + Polynomial.C β))))
                (affineTwoCoordinateLineY k))
              (map (shearAffineTwoHom β)
                (cubicFiberPullback F (stereoFirstCoords F v)))) i) =
        (fun i => (1 + affineTwoCoord0 k ^ 2) ^ 3 *
          residualAmbientRep
            (shearMatrix3 (C β) *ᵥ affineTwoCoordinateLineY k)
            (complementaryTangentDir
              (map (shearAffineTwoHom β)
                (cubicFiberPullback F (stereoFirstCoords F v)))
              (shearMatrix3 (C β) *ᵥ affineTwoCoordinateLineY k))
            (binaryLineRestriction
              (shearMatrix3 (C β) *ᵥ affineTwoCoordinateLineY k)
              (complementaryTangentDir
                (map (shearAffineTwoHom β)
                  (cubicFiberPullback F (stereoFirstCoords F v)))
                (shearMatrix3 (C β) *ᵥ affineTwoCoordinateLineY k))
              (map (shearAffineTwoHom β)
                (cubicFiberPullback F (stereoFirstCoords F v)))) i) := by
    convert hcleared using 1 <;>
      (funext i; simp only [affineTwoCoordinateLineY, hctd, hG'])
  funext i
  calc
    (1 + (affineTwoCoord0 k + C β) ^ 2) ^ 3 *
        (shearMatrix3 (C β) *ᵥ residualYCoords (secondBlockSubst (shearFrame3 β) F)
          (fun j => (v j).comp (Polynomial.X + Polynomial.C β))) i =
      (1 + (affineTwoCoord0 k + C β) ^ 2) ^ 3 *
        residualAmbientRep
          (shearMatrix3 (C β) *ᵥ affineTwoCoordinateLineY k)
          (shearMatrix3 (C β) *ᵥ complementaryTangentDir
            (cubicFiberPullback (secondBlockSubst (shearFrame3 β) F)
              (stereoFirstCoords (secondBlockSubst (shearFrame3 β) F)
                (fun j => (v j).comp (Polynomial.X + Polynomial.C β))))
            (affineTwoCoordinateLineY k))
          (binaryLineRestriction
            (shearMatrix3 (C β) *ᵥ affineTwoCoordinateLineY k)
            (shearMatrix3 (C β) *ᵥ complementaryTangentDir
              (cubicFiberPullback (secondBlockSubst (shearFrame3 β) F)
                (stereoFirstCoords (secondBlockSubst (shearFrame3 β) F)
                  (fun j => (v j).comp (Polynomial.X + Polynomial.C β))))
              (affineTwoCoordinateLineY k))
            (map (shearAffineTwoHom β)
              (cubicFiberPullback F (stereoFirstCoords F v)))) i := by
      rw [← congrFun hmul i]
    _ = (1 + affineTwoCoord0 k ^ 2) ^ 3 *
        residualAmbientRep
          (shearMatrix3 (C β) *ᵥ affineTwoCoordinateLineY k)
          (complementaryTangentDir
            (map (shearAffineTwoHom β)
              (cubicFiberPullback F (stereoFirstCoords F v)))
            (shearMatrix3 (C β) *ᵥ affineTwoCoordinateLineY k))
          (binaryLineRestriction
            (shearMatrix3 (C β) *ᵥ affineTwoCoordinateLineY k)
            (complementaryTangentDir
              (map (shearAffineTwoHom β)
                (cubicFiberPullback F (stereoFirstCoords F v)))
              (shearMatrix3 (C β) *ᵥ affineTwoCoordinateLineY k))
            (map (shearAffineTwoHom β)
              (cubicFiberPullback F (stereoFirstCoords F v)))) i :=
      congrFun hcleared' i
    _ = (1 + affineTwoCoord0 k ^ 2) ^ 3 *
        shearAffineTwoHom β (residualYCoords F v i) := by
      rw [← congrFun hYφ i]

private theorem shearAffineTwoHom_mulVec_C
    (M : Matrix (Fin 3) (Fin 3) k) (β : k) (y : Fin 3 → affineTwoRing k) :
    (fun i => shearAffineTwoHom β ((M.map (C : k →+* affineTwoRing k) *ᵥ y) i)) =
      M.map C *ᵥ (fun i => shearAffineTwoHom β (y i)) := by
  funext i
  simp only [Matrix.mulVec, dotProduct, map_sum, map_mul, Matrix.map_apply, shearAffineTwoHom_C]

/-- **Cleared residual-`Y` pointwise shear law** (exponent `e = 3`). -/
theorem residualYCoordsOn_shear_cleared
    (p q r : Fin 3 → k) (N : Matrix (Fin 3) (Fin 3) k) (β : k)
    (hMN : lineFrame p q r * N = 1)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (v : Fin 3 → Polynomial k)
    (hv : TernaryQuadraticPoly.eval (lineTernaryQuadraticPoly p q F) v = 0) :
    (fun i => (1 + (affineTwoCoord0 k + C β) ^ 2) ^ 3 *
        residualYCoordsOn (fun j => p j + β * q j) q r (shearFrame3 (-β) * N) F
          (fun j => (v j).comp (Polynomial.X + Polynomial.C β)) i) =
      (fun i => (1 + affineTwoCoord0 k ^ 2) ^ 3 *
        shearAffineTwoHom β (residualYCoordsOn p q r N F v i)) := by
  have hMN' := lineFrame_mul_shear_inv p q r N β hMN
  have hY := residualYCoordsOn_eq_mulVec_residualYCoords_secondBlockSubst p q r N hMN F v
  have hY' := residualYCoordsOn_eq_mulVec_residualYCoords_secondBlockSubst
    (fun j => p j + β * q j) q r (shearFrame3 (-β) * N) hMN' F
    (fun j => (v j).comp (Polynomial.X + Polynomial.C β))
  have hframe := lineFrame_shear p q r β
  have hF' :
      secondBlockSubst (lineFrame (fun j => p j + β * q j) q r) F =
        secondBlockSubst (shearFrame3 β) (secondBlockSubst (lineFrame p q r) F) := by
    rw [hframe, secondBlockSubst_secondBlockSubst]
  have hQ :
      coordinateLineTernaryQuadraticPoly (secondBlockSubst (lineFrame p q r) F) =
        lineTernaryQuadraticPoly p q F := by
    funext i j
    simp only [coordinateLineTernaryQuadraticPoly, lineTernaryQuadraticPoly]
    rw [← lineSpecializedConicPoly_eq_coordinateLine_secondBlockSubst p q r F]
  have hv0 :
      TernaryQuadraticPoly.eval
        (coordinateLineTernaryQuadraticPoly (secondBlockSubst (lineFrame p q r) F)) v = 0 := by
    rwa [hQ]
  have hFtil : IsBidegree23 (secondBlockSubst (lineFrame p q r) F) :=
    isBidegree23_secondBlockSubst _ hF
  have hkey := residualYCoords_secondBlock_shear_cleared β
    (secondBlockSubst (lineFrame p q r) F) hFtil v hv0
  have haff :
      affineTwoLineFrame (fun j => p j + β * q j) q r =
        affineTwoLineFrame p q r * shearMatrix3 (C β) := by
    rw [affineTwoLineFrame_shear, shearFrame3_map_C]
  have hM : affineTwoLineFrame p q r = (lineFrame p q r).map C := by
    simp only [affineTwoLineFrame, lineFrame_map]
  -- Work componentwise from the two mulVec reductions and the key identity
  funext i
  -- rewrite LHS residualYCoordsOn via secondBlockSubst reduction
  have hL0 := congrFun hY' i
  have hR0 := congrFun hY i
  -- frame product form
  have hframe_aff :
      affineTwoLineFrame (fun j => p j + β * q j) q r =
        (lineFrame p q r).map C * shearMatrix3 (C β) := by
    rw [haff, hM]
  -- residualYCoords of sheared second-block
  have hYsubst :
      residualYCoords (secondBlockSubst (lineFrame (fun j => p j + β * q j) q r) F)
          (fun j => (v j).comp (Polynomial.X + Polynomial.C β)) =
        residualYCoords
          (secondBlockSubst (shearFrame3 β) (secondBlockSubst (lineFrame p q r) F))
          (fun j => (v j).comp (Polynomial.X + Polynomial.C β)) := by
    rw [hF']
  -- LHS becomes M *ᵥ (S *ᵥ Y')
  have hL1 :
      residualYCoordsOn (fun j => p j + β * q j) q r (shearFrame3 (-β) * N) F
          (fun j => (v j).comp (Polynomial.X + Polynomial.C β)) i =
        (((lineFrame p q r).map C) *ᵥ
          (shearMatrix3 (C β) *ᵥ residualYCoords
            (secondBlockSubst (shearFrame3 β) (secondBlockSubst (lineFrame p q r) F))
            (fun j => (v j).comp (Polynomial.X + Polynomial.C β)))) i := by
    rw [hL0]
    -- (affineTwoLineFrame' *ᵥ residualYCoords (secondBlockSubst lineFrame' F) v') i
    have h1 :
        (affineTwoLineFrame (fun j => p j + β * q j) q r *ᵥ
            residualYCoords (secondBlockSubst (lineFrame (fun j => p j + β * q j) q r) F)
              (fun j => (v j).comp (Polynomial.X + Polynomial.C β))) i =
          (((lineFrame p q r).map C * shearMatrix3 (C β)) *ᵥ
            residualYCoords (secondBlockSubst (lineFrame (fun j => p j + β * q j) q r) F)
              (fun j => (v j).comp (Polynomial.X + Polynomial.C β))) i := by
      rw [hframe_aff]
    rw [h1]
    have h2 :
        (((lineFrame p q r).map C * shearMatrix3 (C β)) *ᵥ
            residualYCoords (secondBlockSubst (lineFrame (fun j => p j + β * q j) q r) F)
              (fun j => (v j).comp (Polynomial.X + Polynomial.C β))) i =
          (((lineFrame p q r).map C * shearMatrix3 (C β)) *ᵥ
            residualYCoords
              (secondBlockSubst (shearFrame3 β) (secondBlockSubst (lineFrame p q r) F))
              (fun j => (v j).comp (Polynomial.X + Polynomial.C β))) i := by
      rw [hYsubst]
    rw [h2, Matrix.mulVec_mulVec]
  -- RHS becomes M *ᵥ (φ ∘ Y)
  have hR1 :
      shearAffineTwoHom β (residualYCoordsOn p q r N F v i) =
        (((lineFrame p q r).map C) *ᵥ
          (fun j => shearAffineTwoHom β
            (residualYCoords (secondBlockSubst (lineFrame p q r) F) v j))) i := by
    rw [hR0, hM]
    exact congrFun
      (shearAffineTwoHom_mulVec_C (lineFrame p q r) β
        (residualYCoords (secondBlockSubst (lineFrame p q r) F) v)) i
  rw [hL1, hR1]
  -- factor scalars through mulVec at index i
  have hfac (c : affineTwoRing k) (y : Fin 3 → affineTwoRing k) :
      c * ((((lineFrame p q r).map C) *ᵥ y) i) =
        (((lineFrame p q r).map C) *ᵥ (fun b => c * y b)) i := by
    simp only [Matrix.mulVec, dotProduct, Finset.mul_sum]
    refine Finset.sum_congr rfl fun b _ => ?_
    ring
  -- LHS: c³ * (M *ᵥ (S *ᵥ Y')) i = (M *ᵥ (c³ • (S *ᵥ Y'))) i
  rw [hfac ( (1 + (affineTwoCoord0 k + C β) ^ 2) ^ 3 )
      (shearMatrix3 (C β) *ᵥ residualYCoords
        (secondBlockSubst (shearFrame3 β) (secondBlockSubst (lineFrame p q r) F))
        (fun j => (v j).comp (Polynomial.X + Polynomial.C β)))]
  -- RHS: d³ * (M *ᵥ (φ ∘ Y)) i = (M *ᵥ (d³ • (φ ∘ Y))) i
  rw [hfac ((1 + affineTwoCoord0 k ^ 2) ^ 3)
      (fun j => shearAffineTwoHom β
        (residualYCoords (secondBlockSubst (lineFrame p q r) F) v j))]
  -- now vectors of scaled coords are equal by hkey
  have hkey' :
      (fun b => (1 + (affineTwoCoord0 k + C β) ^ 2) ^ 3 *
          (shearMatrix3 (C β) *ᵥ residualYCoords
            (secondBlockSubst (shearFrame3 β) (secondBlockSubst (lineFrame p q r) F))
            (fun j => (v j).comp (Polynomial.X + Polynomial.C β))) b) =
        fun b => (1 + affineTwoCoord0 k ^ 2) ^ 3 *
          shearAffineTwoHom β
            (residualYCoords (secondBlockSubst (lineFrame p q r) F) v b) := hkey
  simp only [hkey']

/-! ### F-1e.2 — automatic G4 (shear) -/

theorem residualConicDiscriminantOn_shear_cleared
    (p q r : Fin 3 → k) (N : Matrix (Fin 3) (Fin 3) k) (β : k)
    (hMN : lineFrame p q r * N = 1)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (v : Fin 3 → Polynomial k)
    (hv : TernaryQuadraticPoly.eval (lineTernaryQuadraticPoly p q F) v = 0) :
    (1 + (affineTwoCoord0 k + C β) ^ 2) ^ 27 *
        residualConicDiscriminantOn (fun j => p j + β * q j) q r
          (shearFrame3 (-β) * N) F
          (fun j => (v j).comp (Polynomial.X + Polynomial.C β)) =
      (1 + affineTwoCoord0 k ^ 2) ^ 27 *
        shearAffineTwoHom β (residualConicDiscriminantOn p q r N F v) := by
  have hY := residualYCoordsOn_shear_cleared p q r N β hMN F hF v hv
  have hsmul (a : affineTwoRing k) (y : Fin 3 → affineTwoRing k) :
      aeval (fun i => a ^ 3 * y i) (sndConicDiscriminant F) =
        a ^ 27 * aeval y (sndConicDiscriminant F) := by
    rw [aeval_sndConicDiscriminant_smul F hF (a ^ 3) y, ← pow_mul]
  set c : affineTwoRing k := 1 + (affineTwoCoord0 k + C β) ^ 2
  set d : affineTwoRing k := 1 + affineTwoCoord0 k ^ 2
  set Y := residualYCoordsOn p q r N F v
  set Y' := residualYCoordsOn (fun j => p j + β * q j) q r (shearFrame3 (-β) * N) F
    (fun j => (v j).comp (Polynomial.X + Polynomial.C β))
  have hY' : (fun i => c ^ 3 * Y' i) = fun i => d ^ 3 * shearAffineTwoHom β (Y i) := by
    simpa [c, d, Y, Y'] using hY
  have haeval :
      aeval (fun i => c ^ 3 * Y' i) (sndConicDiscriminant F) =
        aeval (fun i => d ^ 3 * shearAffineTwoHom β (Y i)) (sndConicDiscriminant F) := by
    simp only [hY']
  simp only [residualConicDiscriminantOn]
  calc
    c ^ 27 * aeval Y' (sndConicDiscriminant F) =
        aeval (fun i => c ^ 3 * Y' i) (sndConicDiscriminant F) := (hsmul c Y').symm
    _ = aeval (fun i => d ^ 3 * shearAffineTwoHom β (Y i)) (sndConicDiscriminant F) := haeval
    _ = d ^ 27 * aeval (fun i => shearAffineTwoHom β (Y i)) (sndConicDiscriminant F) :=
      hsmul d _
    _ = d ^ 27 * shearAffineTwoHom β (aeval Y (sndConicDiscriminant F)) := by
      rw [aeval_shearAffineTwoHom_sndConicDiscriminant]

theorem ResidualAvoidsConicDiscriminantOn_shear
    (p q r : Fin 3 → k) (N : Matrix (Fin 3) (Fin 3) k) (β : k)
    (hMN : lineFrame p q r * N = 1)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (v : Fin 3 → Polynomial k)
    (hv : TernaryQuadraticPoly.eval (lineTernaryQuadraticPoly p q F) v = 0)
    (h : ResidualAvoidsConicDiscriminantOn p q r N F v) :
    ResidualAvoidsConicDiscriminantOn (fun j => p j + β * q j) q r
      (shearFrame3 (-β) * N) F
      (fun j => (v j).comp (Polynomial.X + Polynomial.C β)) := by
  intro h0
  apply h
  have hcleared := residualConicDiscriminantOn_shear_cleared p q r N β hMN F hF v hv
  rw [h0, mul_zero] at hcleared
  have hd : (1 + affineTwoCoord0 k ^ 2 : affineTwoRing k) ≠ 0 := one_add_t_sq_ne_zero
  have hφ0 : shearAffineTwoHom β (residualConicDiscriminantOn p q r N F v) = 0 :=
    (mul_eq_zero.mp hcleared.symm).resolve_left (pow_ne_zero 27 hd)
  exact shearAffineTwoHom_injective β hφ0

/-- Shear transport of the partial package with adjusted inverse — G4 automatic. -/
theorem hasGoodLineSectionPartial_shear_auto
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (p q r : Fin 3 → k) (N : Matrix (Fin 3) (Fin 3) k) (β : k)
    (hMN : lineFrame p q r * N = 1)
    (v : Fin 3 → Polynomial k)
    (h : HasGoodLineSectionPartial F p q r N v) :
    HasGoodLineSectionPartial F (fun i => p i + β * q i) q r (shearFrame3 (-β) * N)
      (fun i => (v i).comp (Polynomial.X + Polynomial.C β)) := by
  rcases h with ⟨hdisc, hv0, hviso, hG4⟩
  exact hasGoodLineSectionPartial_shear_of_residual F p q r N β v
    ⟨hdisc, hv0, hviso, hG4⟩
    (ResidualAvoidsConicDiscriminantOn_shear p q r N β hMN F hF v hviso hG4)

/-! ### Status table (F-1e partial)

| piece | status |
|---|---|
| `residualYCoordsOn_shear_cleared` | **proved** (`e = 3`, frame bookkeeping) |
| `residualConicDiscriminantOn_shear_cleared` | **proved** (disc exponent 27) |
| `ResidualAvoidsConicDiscriminantOn_shear` | **proved** (automatic G4 shear) |
| `hasGoodLineSectionPartial_shear_auto` | **proved** (G4 hyp discharged for shear) |
| automatic G4 scale | open (pointwise unit power α³ / disc α²⁷) |
| automatic G4 swap | open (k(t)[s] route, weight 27) |
| swap isotropy (`reverse`) | open (binary `reflect 3` path prepared by disc laws) |
| `hasGoodLineSectionPartial_pair_change` | open (blocked on scale/swap G4 + swap isotropy) |

G3 stays out (F-3). Endpoint shape is ready once the three elementary auto transports land.
-/

end

end BConicBundleMultisections
