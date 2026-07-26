/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import BConicBundleMultisections.MvPolynomialHomogeneousEvaluation
public import BConicBundleMultisections.ProjectiveSpaceClosedPoints
public import Mathlib.Algebra.MvPolynomial.Degrees
public import Mathlib.Data.Fin.Tuple.Basic
public import Mathlib.RingTheory.MvPolynomial.Homogeneous

/-!
# Homogenizing along a projective chart

`ProjectiveSpace.affineCoordinates j x` reads the `n` affine coordinates of a homogeneous
representative `x : Fin (n+1) → S` normalized by `x j = 1`.  Evaluating an `n`-variable polynomial
at those affine coordinates is the same as evaluating its **homogenization** — the degree-`d` form
in `n + 1` variables obtained by padding each homogeneous component with a power of `X j` — at the
representative itself.

`chartHomogenization` is that homogenization, built from `homogeneousComponent` and `rename`, so
that `aeval_chartHomogenization` is the only computation needed.  Mathlib has homogenization only
for univariate polynomials (`Polynomial.homogenize`, into `MvPolynomial (Fin 2) R`); this is the
multivariate chart version.

The payoff is `injective_aeval_affineCoordinates`: to know that no nonzero polynomial vanishes on
the affine coordinate ratios of a projective point it suffices to know that no nonzero
**homogeneous form** vanishes on its homogeneous coordinates.  That converts a question about a
localization into a question about forms, which is where the geometry lives.
-/

@[expose] public section

namespace BConicBundleMultisections

noncomputable section

universe u v

open MvPolynomial

/-! ### Rescaling an algebra-valued point -/

/-- A homogeneous polynomial of degree `d` evaluated at a uniformly rescaled algebra-valued point
picks up `r ^ d`.  Algebra-valued analogue of `eval_smul_point_of_isHomogeneous`; it is what makes
"pass to a chart-normalized representative" harmless for homogeneous forms. -/
theorem aeval_smul_point_of_isHomogeneous
    {σ : Type*} {R : Type u} {S : Type v} [CommSemiring R] [CommSemiring S] [Algebra R S]
    {f : MvPolynomial σ R} {d : ℕ} (h : f.IsHomogeneous d) (r : S) (p : σ → S) :
    aeval (fun i => r * p i) f = r ^ d * aeval p f := by
  have hmap : (map (algebraMap R S) f).IsHomogeneous d := by
    intro c hc
    exact h (fun h0 => hc (by rw [coeff_map, h0, map_zero]))
  rw [aeval_def, eval₂_eq_eval_map, aeval_def, eval₂_eq_eval_map]
  exact eval_smul_point_of_isHomogeneous hmap r p

namespace ProjectiveSpace

variable {n : ℕ} {R : Type u} [CommRing R]

/-- The degree-`d` homogenization of `p` along the chart variable `X j`.

Its `e`-th homogeneous component is the `e`-th homogeneous component of `p`, with its variables
renamed by `j.succAbove` and padded to degree `d` by `X j ^ (d - e)`. -/
def chartHomogenization (j : Fin (n + 1)) (d : ℕ) (p : MvPolynomial (Fin n) R) :
    MvPolynomial (Fin (n + 1)) R :=
  ∑ e ∈ Finset.range (d + 1),
    X j ^ (d - e) * rename j.succAbove (homogeneousComponent e p)

theorem chartHomogenization_isHomogeneous (j : Fin (n + 1)) (d : ℕ)
    (p : MvPolynomial (Fin n) R) :
    (chartHomogenization j d p).IsHomogeneous d := by
  refine IsHomogeneous.sum _ _ _ fun e he => ?_
  have hed : e ≤ d := Nat.lt_succ_iff.mp (Finset.mem_range.mp he)
  have hX : ((X j : MvPolynomial (Fin (n + 1)) R) ^ (d - e)).IsHomogeneous (d - e) := by
    simpa using (isHomogeneous_X R j).pow (d - e)
  have hcomp : (rename j.succAbove (homogeneousComponent e p)).IsHomogeneous e :=
    (homogeneousComponent_isHomogeneous e p).rename_isHomogeneous
  simpa [Nat.sub_add_cancel hed] using hX.mul hcomp

/-- The homogeneous components below the total degree bound already sum to the polynomial. -/
theorem sum_homogeneousComponent_of_totalDegree_le
    (d : ℕ) (p : MvPolynomial (Fin n) R) (hd : p.totalDegree ≤ d) :
    ∑ e ∈ Finset.range (d + 1), homogeneousComponent e p = p := by
  have hsub : Finset.range (p.totalDegree + 1) ⊆ Finset.range (d + 1) := by
    intro x hx
    simp only [Finset.mem_range] at hx ⊢
    omega
  have hz : ∀ e ∈ Finset.range (d + 1), e ∉ Finset.range (p.totalDegree + 1) →
      homogeneousComponent e p = 0 := by
    intro e _ he
    refine homogeneousComponent_eq_zero e p ?_
    by_contra hcon
    exact he (Finset.mem_range.mpr (Nat.lt_succ_of_le (not_lt.mp hcon)))
  rw [← Finset.sum_subset hsub hz]
  exact sum_homogeneousComponent p

/-- Evaluating the homogenization at a representative normalized by `y j = 1` is evaluating the
original polynomial at the affine coordinates. -/
theorem aeval_chartHomogenization {S : Type u} [CommRing S] [Algebra R S]
    (j : Fin (n + 1)) (d : ℕ) (p : MvPolynomial (Fin n) R) (hd : p.totalDegree ≤ d)
    (y : Fin (n + 1) → S) (hyj : y j = 1) :
    aeval y (chartHomogenization (R := R) j d p) = aeval (affineCoordinates j y) p := by
  have haff : affineCoordinates j y = y ∘ j.succAbove := rfl
  calc
    aeval y (chartHomogenization (R := R) j d p)
        = ∑ e ∈ Finset.range (d + 1),
            aeval y ((X j : MvPolynomial (Fin (n + 1)) R) ^ (d - e)) *
              aeval y (rename j.succAbove (homogeneousComponent e p)) := by
          simp only [chartHomogenization, map_sum, map_mul]
    _ = ∑ e ∈ Finset.range (d + 1),
          aeval (affineCoordinates j y) (homogeneousComponent e p) := by
          refine Finset.sum_congr rfl fun e _ => ?_
          rw [map_pow, aeval_X, hyj, one_pow, one_mul, aeval_rename, haff]
    _ = aeval (affineCoordinates j y) p := by
          rw [← map_sum, sum_homogeneousComponent_of_totalDegree_le d p hd]

/-- Homogenization is injective on polynomials of total degree at most `d`: it is undone by
evaluating at the tautological chart point `X j ↦ 1`, `X (j.succAbove r) ↦ X r`. -/
theorem eq_zero_of_chartHomogenization_eq_zero (j : Fin (n + 1)) (d : ℕ)
    (p : MvPolynomial (Fin n) R) (hd : p.totalDegree ≤ d)
    (h : chartHomogenization (R := R) j d p = 0) : p = 0 := by
  set y₀ : Fin (n + 1) → MvPolynomial (Fin n) R :=
    Fin.insertNth (α := fun _ => MvPolynomial (Fin n) R) j 1 X with hy₀
  have hy : y₀ j = 1 :=
    Fin.insertNth_apply_same (α := fun _ => MvPolynomial (Fin n) R) j 1 X
  have key := aeval_chartHomogenization (R := R) (S := MvPolynomial (Fin n) R) j d p hd y₀ hy
  have haff : affineCoordinates j y₀ = (X : Fin n → MvPolynomial (Fin n) R) := by
    funext r
    exact Fin.insertNth_apply_succAbove (α := fun _ => MvPolynomial (Fin n) R) j 1 X r
  rw [h, map_zero, haff] at key
  have hid : aeval (X : Fin n → MvPolynomial (Fin n) R) p = p := by
    simp [aeval_X_left]
  rw [hid] at key
  exact key.symm

/--
**No relation among the affine coordinates from no relation among the forms.**

If no nonzero homogeneous form in `n + 1` variables vanishes at a chart-normalized representative
`y` (`y j = 1`), then no nonzero polynomial in `n` variables vanishes at its affine coordinates.

This is the step that turns "the image of a rational map to `ℙⁿ` is not contained in a
hypersurface" into an injectivity statement about the chart evaluation.
-/
theorem injective_aeval_affineCoordinates {S : Type u} [CommRing S] [Algebra R S]
    (j : Fin (n + 1)) (y : Fin (n + 1) → S) (hyj : y j = 1)
    (h : ∀ (d : ℕ) (Ψ : MvPolynomial (Fin (n + 1)) R), Ψ.IsHomogeneous d →
      aeval y Ψ = 0 → Ψ = 0) :
    Function.Injective (aeval (affineCoordinates j y) : MvPolynomial (Fin n) R →ₐ[R] S) := by
  rw [injective_iff_map_eq_zero
    (aeval (affineCoordinates j y) : MvPolynomial (Fin n) R →ₐ[R] S)]
  intro p hp
  refine eq_zero_of_chartHomogenization_eq_zero j p.totalDegree p (le_refl _) ?_
  refine h p.totalDegree _ (chartHomogenization_isHomogeneous j p.totalDegree p) ?_
  rw [aeval_chartHomogenization j p.totalDegree p (le_refl _) y hyj]
  exact hp

/-! ### Recovery of homogeneous forms from dehomogenization

The I1-GI chart-domain route needs: dehomogenizing a nonsingular ternary quadratic and reading the
affine chart ring as a domain.  That uses the identity
`chartHomogenization i d (chartDehomogenization n K i p) = p` for homogeneous `p` of degree `d`.
-/

variable {K : Type u} [Field K]

/-- `chartDehomogenization` is `aeval` at the chart-normalized tautological point
`insertNth i 1 X`. -/
theorem chartDehomogenization_eq_aeval_insertNth (i : Fin (n + 1)) :
    (chartDehomogenization n K i : MvPolynomial (Fin (n + 1)) K →ₐ[K] MvPolynomial (Fin n) K) =
      aeval (Fin.insertNth (α := fun _ => MvPolynomial (Fin n) K) i 1 X) := by
  simp only [chartDehomogenization, Fin.succAbove_cases_eq_insertNth]

/-- For a homogeneous form of degree `d`, chart dehomogenization has total degree at most `d`.

Each monomial of degree `d` dehomogenizes to a product whose total degree is the sum of the
non-chart exponents, hence ≤ `d`. -/
theorem totalDegree_chartDehomogenization_of_isHomogeneous
    (i : Fin (n + 1)) (d : ℕ) (p : MvPolynomial (Fin (n + 1)) K)
    (hp : p.IsHomogeneous d) :
    (chartDehomogenization n K i p).totalDegree ≤ d := by
  classical
  have hdecomp :
      chartDehomogenization n K i p =
        ∑ α ∈ p.support, chartDehomogenization n K i (monomial α (coeff α p)) := by
    conv_lhs => rw [as_sum p]
    exact map_sum (chartDehomogenization n K i) _ _
  rw [hdecomp]
  refine totalDegree_finsetSum_le fun α hα => ?_
  have hαd : (α.sum fun _ e => e) = d := by
    have hc : coeff α p ≠ 0 := mem_support_iff.mp hα
    by_contra hne
    exact hc (hp.coeff_eq_zero hne)
  have hmon :
      (chartDehomogenization n K i (monomial α (coeff α p))).totalDegree ≤
        α.sum fun _ e => e := by
    rw [chartDehomogenization_eq_aeval_insertNth, aeval_monomial]
    have hCeq : algebraMap K (MvPolynomial (Fin n) K) (coeff α p) = C (coeff α p) := by
      simp [algebraMap_eq]
    rw [hCeq]
    let φ : Fin (n + 1) → MvPolynomial (Fin n) K := fun j =>
      (Fin.insertNth (α := fun _ => MvPolynomial (Fin n) K) i 1 X j) ^ α j
    have hprod_eq :
        (α.prod fun j k =>
            Fin.insertNth (α := fun _ => MvPolynomial (Fin n) K) i 1 X j ^ k) =
          ∏ j ∈ α.support, φ j := by
      simp only [Finsupp.prod, φ]
    rw [hprod_eq]
    have hφ : ∀ j ∈ α.support, (φ j).totalDegree ≤ α j := by
      intro j hj
      unfold φ
      rcases Fin.eq_self_or_eq_succAbove i j with rfl | ⟨r, rfl⟩
      · rw [Fin.insertNth_apply_same, one_pow, totalDegree_one]
        exact Nat.zero_le _
      · rw [Fin.insertNth_apply_succAbove]
        have hpow := totalDegree_pow (X r : MvPolynomial (Fin n) K) (α (i.succAbove r))
        have hX1 : (X r : MvPolynomial (Fin n) K).totalDegree = 1 := totalDegree_X r
        calc
          _ ≤ α (i.succAbove r) * (X r : MvPolynomial (Fin n) K).totalDegree := hpow
          _ = α (i.succAbove r) := by rw [hX1, mul_one]
    have hprod_td := totalDegree_finsetProd α.support φ
    have hsum_α := Finset.sum_le_sum hφ
    have hmul := totalDegree_mul (C (coeff α p) : MvPolynomial (Fin n) K)
      (∏ j ∈ α.support, φ j)
    calc
      (C (coeff α p) * ∏ j ∈ α.support, φ j).totalDegree
          ≤ (C (coeff α p) : MvPolynomial (Fin n) K).totalDegree +
              (∏ j ∈ α.support, φ j).totalDegree := hmul
      _ = 0 + _ := by rw [totalDegree_C]
      _ ≤ ∑ j ∈ α.support, (φ j).totalDegree := by rw [zero_add]; exact hprod_td
      _ ≤ ∑ j ∈ α.support, α j := hsum_α
      _ = α.sum fun _ e => e := by simp only [Finsupp.sum]
  exact hmon.trans hαd.le

/-- **Recovery identity.**  Homogenizing the dehomogenization of a homogeneous form recovers it.

`chartHomogenization i d (chartDehomogenization n K i p) = p` when `p` is homogeneous of degree
`d`.  Proof: both sides are homogeneous of degree `d` and have the same dehomogenization (by
`aeval_chartHomogenization` and the total-degree bound), so their difference is killed by
dehomogenization and vanishes by `chartDehomogenization_eq_zero_of_isHomogeneous`.

Used by I1-GI route (B): irreducibility of the dehomogenized chart equation from irreducibility of
the homogeneous ternary quadratic. -/
theorem chartHomogenization_chartDehomogenization
    (i : Fin (n + 1)) (d : ℕ) (p : MvPolynomial (Fin (n + 1)) K)
    (hp : p.IsHomogeneous d) :
    chartHomogenization (R := K) i d (chartDehomogenization n K i p) = p := by
  set g := chartDehomogenization n K i p with hg_def
  set H := chartHomogenization (R := K) i d g with hH_def
  have hg_td : g.totalDegree ≤ d :=
    totalDegree_chartDehomogenization_of_isHomogeneous i d p hp
  have hHhom : H.IsHomogeneous d := chartHomogenization_isHomogeneous i d g
  have haeval :
      aeval (Fin.insertNth (α := fun _ => MvPolynomial (Fin n) K) i 1 X) H = g := by
    have hyj : Fin.insertNth (α := fun _ => MvPolynomial (Fin n) K) i 1 X i = 1 :=
      Fin.insertNth_apply_same _ _ _
    have key := aeval_chartHomogenization (R := K) (S := MvPolynomial (Fin n) K)
      i d g hg_td (Fin.insertNth (α := fun _ => MvPolynomial (Fin n) K) i 1 X) hyj
    have haff :
        affineCoordinates i (Fin.insertNth (α := fun _ => MvPolynomial (Fin n) K) i 1 X) =
          (X : Fin n → MvPolynomial (Fin n) K) := by
      funext r
      exact Fin.insertNth_apply_succAbove
        (α := fun _ => MvPolynomial (Fin n) K) i 1 X r
    rw [haff, aeval_X_left_apply] at key
    simpa [hH_def] using key
  have hdehH : chartDehomogenization n K i H = g := by
    rw [chartDehomogenization_eq_aeval_insertNth, haeval]
  have hdiff : chartDehomogenization n K i (H - p) = 0 := by
    rw [map_sub, hdehH, hg_def, sub_self]
  have hdiff_hom : (H - p).IsHomogeneous d := hHhom.sub hp
  have hzero := chartDehomogenization_eq_zero_of_isHomogeneous n i d (H - p) hdiff_hom hdiff
  exact sub_eq_zero.mp hzero

/-- Dehomogenization undoes homogenization when `totalDegree ≤ d`. -/
theorem chartDehomogenization_chartHomogenization
    (i : Fin (n + 1)) (d : ℕ) (p : MvPolynomial (Fin n) K)
    (hd : p.totalDegree ≤ d) :
    chartDehomogenization n K i (chartHomogenization (R := K) i d p) = p := by
  rw [chartDehomogenization_eq_aeval_insertNth]
  have hyj : Fin.insertNth (α := fun _ => MvPolynomial (Fin n) K) i 1 X i = 1 :=
    Fin.insertNth_apply_same _ _ _
  have key := aeval_chartHomogenization (R := K) (S := MvPolynomial (Fin n) K)
    i d p hd (Fin.insertNth (α := fun _ => MvPolynomial (Fin n) K) i 1 X) hyj
  have haff :
      affineCoordinates i (Fin.insertNth (α := fun _ => MvPolynomial (Fin n) K) i 1 X) =
        (X : Fin n → MvPolynomial (Fin n) K) := by
    funext r
    exact Fin.insertNth_apply_succAbove
      (α := fun _ => MvPolynomial (Fin n) K) i 1 X r
  rw [haff, aeval_X_left_apply] at key
  exact key

/-- Homogenization is multiplicative on total-degree-bounded polynomials. -/
theorem chartHomogenization_mul
    (i : Fin (n + 1)) (d1 d2 : ℕ) (a b : MvPolynomial (Fin n) K)
    (ha : a.totalDegree ≤ d1) (hb : b.totalDegree ≤ d2) :
    chartHomogenization (R := K) i (d1 + d2) (a * b) =
      chartHomogenization (R := K) i d1 a *
        chartHomogenization (R := K) i d2 b := by
  set LHS := chartHomogenization (R := K) i (d1 + d2) (a * b)
  set RHS := chartHomogenization (R := K) i d1 a *
      chartHomogenization (R := K) i d2 b
  have hL : LHS.IsHomogeneous (d1 + d2) :=
    chartHomogenization_isHomogeneous i (d1 + d2) (a * b)
  have hR : RHS.IsHomogeneous (d1 + d2) :=
    (chartHomogenization_isHomogeneous i d1 a).mul
      (chartHomogenization_isHomogeneous i d2 b)
  have hab : (a * b).totalDegree ≤ d1 + d2 :=
    (totalDegree_mul a b).trans (add_le_add ha hb)
  have hdehL : chartDehomogenization n K i LHS = a * b :=
    chartDehomogenization_chartHomogenization i (d1 + d2) (a * b) hab
  have hdehR : chartDehomogenization n K i RHS = a * b := by
    change chartDehomogenization n K i
        (chartHomogenization (R := K) i d1 a *
          chartHomogenization (R := K) i d2 b) = a * b
    rw [map_mul,
      chartDehomogenization_chartHomogenization i d1 a ha,
      chartDehomogenization_chartHomogenization i d2 b hb]
  have hdiff : chartDehomogenization n K i (LHS - RHS) = 0 := by
    rw [map_sub, hdehL, hdehR, sub_self]
  have hdiff_hom : (LHS - RHS).IsHomogeneous (d1 + d2) := hL.sub hR
  exact sub_eq_zero.mp
    (chartDehomogenization_eq_zero_of_isHomogeneous n i (d1 + d2)
      (LHS - RHS) hdiff_hom hdiff)

/-- Homogenization of a constant of degree `d` is `Xᵢ^d · C r`. -/
theorem chartHomogenization_C (i : Fin (n + 1)) (d : ℕ) (r : K) :
    chartHomogenization (R := K) i d (C r) = X i ^ d * C r := by
  classical
  simp only [chartHomogenization]
  set Cr : MvPolynomial (Fin n) K := C r
  have hhom : Cr.IsHomogeneous 0 := isHomogeneous_C (Fin n) r
  have h0 : homogeneousComponent 0 Cr = Cr := homogeneousComponent_eq_self hhom
  have hpos (e : ℕ) (he : 0 < e) : homogeneousComponent e Cr = 0 :=
    homogeneousComponent_eq_zero (φ := Cr) (n := e)
      (by rwa [show Cr.totalDegree = 0 from totalDegree_C r])
  have hmem0 : (0 : ℕ) ∈ Finset.range (d + 1) :=
    Finset.mem_range.mpr (Nat.zero_lt_succ d)
  rw [← Finset.add_sum_erase _ _ hmem0]
  have hleft :
      X i ^ (d - 0) * rename i.succAbove (homogeneousComponent 0 Cr) =
        X i ^ d * C r := by
    rw [h0, tsub_zero, show Cr = C r from rfl, rename_C]
  have hright :
      ∑ e ∈ (Finset.range (d + 1)).erase 0,
          X i ^ (d - e) * rename i.succAbove (homogeneousComponent e Cr) = 0 := by
    refine Finset.sum_eq_zero fun e he => ?_
    have he0 : e ≠ 0 := (Finset.mem_erase.mp he).1
    have : 0 < e := Nat.pos_of_ne_zero he0
    rw [hpos e this, map_zero, mul_zero]
  rw [hleft, hright, add_zero]

end ProjectiveSpace

end

end BConicBundleMultisections
