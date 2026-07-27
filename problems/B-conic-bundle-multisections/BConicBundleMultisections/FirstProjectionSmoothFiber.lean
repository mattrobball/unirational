/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import BConicBundleMultisections.CubicFiberSingularLocus
public import BConicBundleMultisections.SmoothExtensionJacobian
public import BConicBundleMultisections.SpecializedConicFreeDir
public import Mathlib.Algebra.TrivSqZeroExt.Ideal
public import Mathlib.FieldTheory.IsAlgClosed.AlgebraicClosure
public import Mathlib.RingTheory.Etale.Field
public import Mathlib.RingTheory.Localization.FractionRing
public import BConicBundleMultisections.NeZeroTwoThree

/-!
# A nonsingular fibre of the first projection

This file proves the coordinate form of generic smoothness needed by the cubic-fibre
construction.  It deliberately does not use scheme-theoretic generic smoothness.

The proof is algebraic Sard in the special hypersurface situation.  If every cubic fibre were
singular, projective elimination would give a singular point of the cubic over the fraction field
of the polynomial parameter ring, after passing to its algebraic closure.  Coordinate derivations
of the parameter ring extend first to the fraction field and then to its separable algebraic
closure.  Differentiating the equation at that point shows that its first-block derivatives vanish;
the fibre singularity already says that its second-block derivatives vanish.  This contradicts the
affine-chart Jacobian certificate supplied by smoothness of the total hypersurface.
-/

@[expose] public section

namespace BConicBundleMultisections

noncomputable section

open AlgebraicGeometry MvPolynomial BiprojectiveSpace
open _root_.MvPolynomial

universe u v

/-! ## Extending derivations through formally smooth algebras -/

/-- A derivation with values in a formally smooth algebra extends across the structure map.

The proof uses the infinitesimal lifting definition.  Give `B ⊕ εB` the `A`-algebra structure
`a ↦ (a, d a)`.  Formal smoothness lifts the identity of `B` through the first projection;
the second component of the lift is the required derivation. -/
theorem exists_derivation_extension_of_formallySmooth
    {R A B : Type u} [CommRing R] [CommRing A] [CommRing B]
    [Algebra R A] [Algebra R B] [Algebra A B] [IsScalarTower R A B]
    [Algebra.FormallySmooth A B] (d : Derivation R A B) :
    ∃ D : Derivation R B B, ∀ a : A, D (algebraMap A B a) = d a := by
  let θ : A →+* TrivSqZeroExt B B :=
    { toFun := fun a => ⟨algebraMap A B a, d a⟩
      map_one' := by ext <;> simp
      map_mul' := fun a b => by
        ext
        · simp
        · simp only [TrivSqZeroExt.snd_mk, map_mul, TrivSqZeroExt.snd_mul,
            TrivSqZeroExt.fst_mk, Derivation.leibniz, Algebra.smul_def]
          simp [mul_comm]
      map_zero' := by ext <;> simp
      map_add' := fun a b => by ext <;> simp }
  letI : Algebra A (TrivSqZeroExt B B) := θ.toAlgebra
  let π : TrivSqZeroExt B B →ₐ[A] B :=
    { toFun := TrivSqZeroExt.fst
      map_one' := TrivSqZeroExt.fst_one
      map_mul' := TrivSqZeroExt.fst_mul
      map_zero' := TrivSqZeroExt.fst_zero
      map_add' := TrivSqZeroExt.fst_add
      commutes' := fun a => rfl }
  have hπsurj : Function.Surjective π := by
    intro b
    exact ⟨TrivSqZeroExt.inl b, rfl⟩
  have hker : RingHom.ker π.toRingHom = TrivSqZeroExt.kerIdeal B B := by
    ext x
    simp [π, TrivSqZeroExt.kerIdeal, TrivSqZeroExt.fstHom]
  have hπnil : IsNilpotent (RingHom.ker π.toRingHom) := by
    refine ⟨2, ?_⟩
    rw [hker]
    exact TrivSqZeroExt.kerIdeal_sq B B
  let ℓ : B →ₐ[A] TrivSqZeroExt B B :=
    Algebra.FormallySmooth.liftOfSurjective (AlgHom.id A B) π hπsurj hπnil
  have hℓ (b : B) : TrivSqZeroExt.fst (ℓ b) = b := by
    have h := AlgHom.congr_fun
      (Algebra.FormallySmooth.comp_liftOfSurjective
        (AlgHom.id A B) π hπsurj hπnil) b
    exact h
  let L : B →ₗ[R] B :=
    { toFun := fun b => TrivSqZeroExt.snd (ℓ b)
      map_add' := fun a b => by simp [map_add]
      map_smul' := fun r b => by
        rw [Algebra.smul_def, map_mul, TrivSqZeroExt.snd_mul, hℓ]
        have hr : ℓ (algebraMap R B r) = θ (algebraMap R A r) := by
          rw [show algebraMap R B r = algebraMap A B (algebraMap R A r) from
            IsScalarTower.algebraMap_apply R A B r]
          exact ℓ.commutes _
        rw [hr]
        rw [hℓ]
        simp [θ, Algebra.smul_def, d.map_algebraMap] }
  let D : Derivation R B B := Derivation.mk' L fun a b => by
    change TrivSqZeroExt.snd (ℓ (a * b)) =
      a * TrivSqZeroExt.snd (ℓ b) + b * TrivSqZeroExt.snd (ℓ a)
    rw [map_mul, TrivSqZeroExt.snd_mul, hℓ, hℓ]
    simp [mul_comm]
  refine ⟨D, fun a => ?_⟩
  change TrivSqZeroExt.snd (ℓ (algebraMap A B a)) = d a
  rw [ℓ.commutes]
  rfl

/-! ## Coordinate derivations at the generic point -/

/-- Multivariate chain rule for an arbitrary derivation on the target algebra. -/
theorem derivation_aeval_eq_sum {R S : Type u} {σ : Type v} [CommRing R] [CommRing S] [Algebra R S]
    [Fintype σ] (D : Derivation R S S) (Y : σ → S)
    (Ψ : MvPolynomial σ R) :
    D (aeval Y Ψ) = ∑ a : σ, aeval Y (pderiv a Ψ) * D (Y a) := by
  classical
  induction Ψ using MvPolynomial.induction_on with
  | C c => simp
  | add p q hp hq =>
      simp only [map_add, hp, hq, ← Finset.sum_add_distrib]
      exact Finset.sum_congr rfl fun a _ => by ring
  | mul_X p b hp =>
      have hleib : D (aeval Y (p * X b)) =
          D (aeval Y p) * Y b + aeval Y p * D (Y b) := by
        simp [map_mul, D.leibniz, mul_comm]
      rw [hleib, hp]
      symm
      calc ∑ a : σ, aeval Y (pderiv a (p * X b)) * D (Y a)
          = ∑ a : σ, (aeval Y (pderiv a p) * D (Y a) * Y b +
              (if a = b then aeval Y p * D (Y b) else 0)) := by
            refine Finset.sum_congr rfl fun a _ => ?_
            by_cases hab : a = b
            · subst hab; simp; ring
            · simp [hab, Ne.symm hab]
              ring
        _ = (∑ a : σ, aeval Y (pderiv a p) * D (Y a)) * Y b +
              aeval Y p * D (Y b) := by
            rw [Finset.sum_add_distrib, Finset.sum_mul]
            simp

/-- Coordinate derivations of a polynomial ring extend to its fraction field. -/
theorem exists_fractionRing_coordinateDerivation
    {k : Type u} [Field k] (i : Fin 3) :
    let A := MvPolynomial (Fin 3) k
    let K := FractionRing A
    ∃ D : Derivation k K K, ∀ j : Fin 3,
      D (algebraMap A K (X j)) = if j = i then 1 else 0 := by
  dsimp only
  let A := MvPolynomial (Fin 3) k
  let K := FractionRing A
  letI : Algebra.FormallySmooth A K :=
    Algebra.FormallySmooth.of_isLocalization (nonZeroDivisors A)
  let d : Derivation k A K :=
    MvPolynomial.mkDerivation k (fun j : Fin 3 => if j = i then 1 else 0)
  obtain ⟨D, hD⟩ := exists_derivation_extension_of_formallySmooth d
  refine ⟨D, fun j => ?_⟩
  rw [hD]
  exact MvPolynomial.mkDerivation_X (R := k) (A := K)
    (fun j : Fin 3 => if j = i then 1 else 0) j

/-- The coordinate derivations extend further to the algebraic closure of the fraction field. -/
theorem exists_algebraicClosure_coordinateDerivation
    {k : Type u} [Field k] [CharZero k] (i : Fin 3) :
    let A := MvPolynomial (Fin 3) k
    let K := FractionRing A
    let Ω := AlgebraicClosure K
    ∃ D : Derivation k Ω Ω, ∀ j : Fin 3,
      D (algebraMap A Ω (X j)) = if j = i then 1 else 0 := by
  dsimp only
  let A := MvPolynomial (Fin 3) k
  let K := FractionRing A
  let Ω := AlgebraicClosure K
  obtain ⟨dK, hdK⟩ := exists_fractionRing_coordinateDerivation (k := k) i
  let dKΩ : Derivation k K Ω :=
    Derivation.llcomp (Algebra.linearMap K Ω) dK
  letI : Algebra.FormallyEtale K Ω := Algebra.FormallyEtale.of_isSeparable K Ω
  letI : Algebra.FormallySmooth K Ω := inferInstance
  obtain ⟨D, hD⟩ := exists_derivation_extension_of_formallySmooth dKΩ
  refine ⟨D, fun j => ?_⟩
  rw [show algebraMap A Ω (X j) = algebraMap K Ω (algebraMap A K (X j)) from
    (IsScalarTower.algebraMap_apply A K Ω (X j)).symm, hD]
  change algebraMap K Ω (dK (algebraMap A K (X j))) = _
  rw [hdK]
  split <;> simp_all

/-! ## Algebraic Sard for the bidegree-`(2,3)` first projection -/

private theorem eval_rescale_first_bidegree
    {E : Type u} [Field E] {d e : ℕ}
    {G : MvPolynomial (BiprojectiveCoordinate 2 2) E}
    (hG : IsBihomogeneousOfBidegree d e G) (a : E) (x y : Fin 3 → E) :
    eval (Sum.elim (fun i => a * x i) y) G =
      a ^ d * eval (Sum.elim x y) G := by
  have hx : (fun i => a * x i) = (a • x : Fin 3 → E) := by
    funext i
    simp [Pi.smul_apply, smul_eq_mul]
  have h := congrArg (eval y) (hG.specializeFirstCoordinates_smul a x)
  rw [eval_specializeFirstCoordinates, map_mul, eval_C,
    eval_specializeFirstCoordinates] at h
  rw [hx, h]

private theorem eval_rescale_second_bidegree
    {E : Type u} [Field E] {d e : ℕ}
    {G : MvPolynomial (BiprojectiveCoordinate 2 2) E}
    (hG : IsBihomogeneousOfBidegree d e G) (b : E) (x y : Fin 3 → E) :
    eval (Sum.elim x (fun j => b * y j)) G =
      b ^ e * eval (Sum.elim x y) G := by
  have hy : (fun j => b * y j) = (b • y : Fin 3 → E) := by
    funext j
    simp [Pi.smul_apply, smul_eq_mul]
  have h := congrArg (eval x) (hG.specializeSecondCoordinates_smul b y)
  rw [eval_specializeSecondCoordinates, map_mul, eval_C,
    eval_specializeSecondCoordinates] at h
  rw [hy, h]

private theorem eval_rescale_blocks_bidegree
    {E : Type u} [Field E] {d e : ℕ}
    {G : MvPolynomial (BiprojectiveCoordinate 2 2) E}
    (hG : IsBihomogeneousOfBidegree d e G) (a b : E) (x y : Fin 3 → E) :
    eval (Sum.elim (fun i => a * x i) (fun j => b * y j)) G =
      a ^ d * b ^ e * eval (Sum.elim x y) G := by
  rw [eval_rescale_second_bidegree hG b (fun i => a * x i) y,
    eval_rescale_first_bidegree hG a x y]
  ring

private theorem eval_normalize_blocks_eq_zero_explicit
    {E : Type u} [Field E] {d e : ℕ}
    (P : MvPolynomial (BiprojectiveCoordinate 2 2) E)
    (hP : IsBihomogeneousOfBidegree d e P)
    (x y : Fin 3 → E) (i j : Fin 3)
    (hP0 : eval (Sum.elim x y) P = 0) :
    eval (Sum.elim (normalizeCoordinateRepresentative x i)
      (normalizeCoordinateRepresentative y j)) P = 0 := by
  have h := eval_rescale_blocks_bidegree hP (x i)⁻¹ (y j)⁻¹ x y
  have hxnorm : normalizeCoordinateRepresentative x i = fun l ↦ (x i)⁻¹ * x l := by
    funext l
    simp [normalizeCoordinateRepresentative, Pi.smul_apply, smul_eq_mul]
  have hynorm : normalizeCoordinateRepresentative y j = fun l ↦ (y j)⁻¹ * y l := by
    funext l
    simp [normalizeCoordinateRepresentative, Pi.smul_apply, smul_eq_mul]
  rw [hxnorm, hynorm]
  simpa only [hP0, mul_zero] using h

/-- Independent normalization of both projective-coordinate blocks preserves a common zero of a
bidegree-`(2,3)` form and all of its coordinate partial derivatives.  Keeping this bookkeeping in
a small lemma avoids unfolding the generic-point construction in the main Sard argument. -/
theorem eval_normalize_blocks_jacobian_eq_zero_of_isBidegree23
    {E : Type u} [Field E]
    (G : MvPolynomial (BiprojectiveCoordinate 2 2) E)
    (hG : IsBidegree23 G)
    (x y : Fin 3 → E) (i j : Fin 3)
    (hval : eval (Sum.elim x y) G = 0)
    (hgrad : ∀ z : BiprojectiveCoordinate 2 2,
      eval (Sum.elim x y) (pderiv z G) = 0) :
    eval (Sum.elim (normalizeCoordinateRepresentative x i)
        (normalizeCoordinateRepresentative y j)) G = 0 ∧
      ∀ z : BiprojectiveCoordinate 2 2,
        eval (Sum.elim (normalizeCoordinateRepresentative x i)
          (normalizeCoordinateRepresentative y j)) (pderiv z G) = 0 := by
  have hleft (a : Fin 3) :
      eval (Sum.elim (normalizeCoordinateRepresentative x i)
        (normalizeCoordinateRepresentative y j))
          (pderiv (Sum.inl a : BiprojectiveCoordinate 2 2) G) = 0 := by
    have hp : IsBihomogeneousOfBidegree 1 3
        (pderiv (Sum.inl a : BiprojectiveCoordinate 2 2) G) :=
      IsBihomogeneousOfBidegree.pderiv_inl
        (m := 2) (n := 2) (d := 2) (e := 3) (R := E) (F := G)
        hG (by decide) a
    exact eval_normalize_blocks_eq_zero_explicit
      (d := 1) (e := 3) (pderiv (Sum.inl a : BiprojectiveCoordinate 2 2) G)
        hp x y i j (hgrad (Sum.inl a))
  have hright (a : Fin 3) :
      eval (Sum.elim (normalizeCoordinateRepresentative x i)
        (normalizeCoordinateRepresentative y j))
          (pderiv (Sum.inr a : BiprojectiveCoordinate 2 2) G) = 0 := by
    have hp : IsBihomogeneousOfBidegree 2 2
        (pderiv (Sum.inr a : BiprojectiveCoordinate 2 2) G) :=
      IsBihomogeneousOfBidegree.pderiv_inr
        (m := 2) (n := 2) (d := 2) (e := 3) (R := E) (F := G)
        hG (by decide) a
    exact eval_normalize_blocks_eq_zero_explicit
      (d := 2) (e := 2) (pderiv (Sum.inr a : BiprojectiveCoordinate 2 2) G)
        hp x y i j (hgrad (Sum.inr a))
  refine ⟨eval_normalize_blocks_eq_zero_explicit
    (d := 2) (e := 3) G hG x y i j hval, ?_⟩
  intro z
  rcases z with a | a
  · exact hleft a
  · exact hright a

/-- A normalized algebra-valued common zero of a Cox equation and its coordinate gradient gives
a common zero of the corresponding affine chart equation and all of its affine partials. -/
theorem aeval_affineChartEquation_jacobian_eq_zero
    {R E : Type u} [CommRing R] [CommRing E] [Algebra R E]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) R)
    (i j : Fin 3) (x y : Fin 3 → E)
    (hxi : x i = 1) (hyj : y j = 1)
    (hval : aeval (Sum.elim x y) F = 0)
    (hgrad : ∀ z : BiprojectiveCoordinate 2 2,
      aeval (Sum.elim x y) (pderiv z F) = 0) :
    aeval (BiprojectiveSpace.affineChartPoint i j x y)
        (BiprojectiveSpace.affineChartEquation 2 2 R i j F) = 0 ∧
      ∀ q : Fin 2 ⊕ Fin 2,
        aeval (BiprojectiveSpace.affineChartPoint i j x y)
          (pderiv q (BiprojectiveSpace.affineChartEquation 2 2 R i j F)) = 0 := by
  have hleft (r : Fin 2) :
      aeval (BiprojectiveSpace.affineChartPoint i j x y)
        (pderiv (.inl r) (BiprojectiveSpace.affineChartEquation 2 2 R i j F)) = 0 := by
    rw [BiprojectiveSpace.pderiv_affineChartEquation_inl]
    rw [aeval_affineChartEquation_affineChartPoint (R := R) (S := E)
      2 2 i j x y hxi hyj (pderiv (.inl (i.succAbove r)) F)]
    exact hgrad (.inl (i.succAbove r))
  have hright (s : Fin 2) :
      aeval (BiprojectiveSpace.affineChartPoint i j x y)
        (pderiv (.inr s) (BiprojectiveSpace.affineChartEquation 2 2 R i j F)) = 0 := by
    rw [BiprojectiveSpace.pderiv_affineChartEquation_inr]
    rw [aeval_affineChartEquation_affineChartPoint (R := R) (S := E)
      2 2 i j x y hxi hyj (pderiv (.inr (j.succAbove s)) F)]
    exact hgrad (.inr (j.succAbove s))
  refine ⟨?_, ?_⟩
  · rw [aeval_affineChartEquation_affineChartPoint (R := R) (S := E)
      2 2 i j x y hxi hyj F]
    exact hval
  · intro q
    rcases q with r | s
    · exact hleft r
    · exact hright s

/-- Smoothness of the original biprojective hypersurface rules out a common projective zero of
the base-changed equation and its full Cox-coordinate gradient over any field extension. -/
theorem false_of_baseChanged_common_zero_of_smooth
    {k E : Type u} [Field k] [Field E] [Algebra k E]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (biprojectiveZeroLocusToSpec 2 2 k F)]
    (x y : Fin 3 → E) (hx : x ≠ 0) (hy : y ≠ 0)
    (hval : eval (Sum.elim x y) (map (algebraMap k E) F) = 0)
    (hgrad : ∀ z : BiprojectiveCoordinate 2 2,
      eval (Sum.elim x y) (pderiv z (map (algebraMap k E) F)) = 0) : False := by
  classical
  obtain ⟨i, hxi⟩ := exists_normalizing_coordinate x hx
  obtain ⟨j, hyj⟩ := exists_normalizing_coordinate y hy
  let xn := normalizeCoordinateRepresentative x i
  let yn := normalizeCoordinateRepresentative y j
  have hxni : xn i = 1 := normalizeCoordinateRepresentative_apply x i hxi
  have hynj : yn j = 1 := normalizeCoordinateRepresentative_apply y j hyj
  have hG : IsBidegree23 (map (algebraMap k E) F) :=
    hF.map_coefficients (algebraMap k E)
  have hnorm := eval_normalize_blocks_jacobian_eq_zero_of_isBidegree23
    (map (algebraMap k E) F) hG x y i j hval hgrad
  have hvalA : aeval (Sum.elim xn yn) F = 0 := by
    simpa [aeval_def] using hnorm.1
  have hgradA : ∀ z : BiprojectiveCoordinate 2 2,
      aeval (Sum.elim xn yn) (pderiv z F) = 0 := by
    intro z
    simpa [aeval_def, pderiv_map] using hnorm.2 z
  have hsing := aeval_affineChartEquation_jacobian_eq_zero
    F i j xn yn hxni hynj hvalA hgradA
  have hne : BiprojectiveSpace.affineChartEquation 2 2 k i j F ≠ 0 :=
    BiprojectiveSpace.affineChartEquation_ne_zero 2 2 k i j F hF hF0
  exact (BiprojectiveSpace.no_common_zero_affineChartEquation_and_pderiv_of_global_smooth_extension
    2 2 k E F hF i j hne (BiprojectiveSpace.affineChartPoint i j xn yn)) hsing

/-- A smooth bidegree-`(2,3)` hypersurface has a Jacobian-nonsingular plane-cubic fibre.

This is the exact coordinate conclusion previously obtained from the unformalized
scheme-theoretic generic-smoothness theorem. -/
theorem exists_nonsingularCubicFiber_of_smooth_coordinate
    {k : Type u} [Field k] [IsAlgClosed k] [CharZero k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [AlgebraicGeometry.Smooth (biprojectiveZeroLocusToSpec 2 2 k F)] :
    ∃ x : Fin 3 → k, ∀ r : Fin 3 → k, r ≠ 0 →
      eval r (specializeFirstCoordinates (n := 2) x F) = 0 →
        ∃ i : Fin 3, eval r (pderiv i (specializeFirstCoordinates (n := 2) x F)) ≠ 0 := by
  classical
  let A := MvPolynomial (Fin 3) k
  let K := FractionRing A
  let Ω := AlgebraicClosure K
  let φ : A →+* Ω := algebraMap A Ω
  let xΩ : Fin 3 → Ω := fun i => φ (X i)
  let FΩ : MvPolynomial (BiprojectiveCoordinate 2 2) Ω := map (algebraMap k Ω) F
  let ℱ := cubicFiberJacobianFamily F
  let d : Fin 4 → ℕ := ![3, 2, 2, 2]
  let S : Set A := elimCertificates ℱ d
  by_contra hex
  have hno : ∀ x : Fin 3 → k, ¬ (∀ r : Fin 3 → k, r ≠ 0 →
      eval r (specializeFirstCoordinates (n := 2) x F) = 0 →
        ∃ i : Fin 3, eval r (pderiv i (specializeFirstCoordinates (n := 2) x F)) ≠ 0) := by
    intro x hx
    exact hex ⟨x, hx⟩
  have hcert0 : ∀ Δ ∈ S, Δ = 0 := by
    intro Δ hΔ
    by_contra hΔ0
    obtain ⟨x, hx⟩ : ∃ x : Fin 3 → k, eval x Δ ≠ 0 := by
      by_contra hall
      push Not at hall
      apply hΔ0
      apply MvPolynomial.funext
      intro x
      simpa using hall x
    have hns4 : ∀ r : Fin 3 → k, r ≠ 0 →
        ∃ j : Fin 4, eval r (map (eval x) (ℱ j)) ≠ 0 :=
      (elimCertificates_spec ℱ d (cubicFiberJacobianFamily_isHomogeneous hF) (eval x)).mp
        ⟨Δ, hΔ, hx⟩
    have hmaps := map_eval_cubicFiberJacobianFamily F x
    apply hno x
    intro r hr hzero
    obtain ⟨j, hj⟩ := hns4 r hr
    revert hj
    refine Fin.cases (fun hj0 => ?_) (fun i hji => ?_) j
    · rw [hmaps.1] at hj0
      exact absurd hzero hj0
    · exact ⟨i, by rwa [hmaps.2 i] at hji⟩
  have hbad : ¬ (∀ r : Fin 3 → Ω, r ≠ 0 →
      ∃ j : Fin 4, eval r (map φ (ℱ j)) ≠ 0) := by
    intro hgood
    obtain ⟨Δ, hΔ, hΔφ⟩ :=
      (elimCertificates_spec ℱ d (cubicFiberJacobianFamily_isHomogeneous hF) φ).mpr hgood
    rw [hcert0 Δ hΔ, map_zero] at hΔφ
    exact hΔφ rfl
  push Not at hbad
  obtain ⟨y, hy0, hy⟩ := hbad
  have hφC : φ.comp (C : k →+* A) = algebraMap k Ω := by
    ext c
    exact (IsScalarTower.algebraMap_apply k A Ω c).symm
  have hgeneric : map φ (universalCubicFiber F) =
      specializeFirstCoordinates (n := 2) xΩ FΩ := by
    rw [universalCubicFiber, map_specializeFirstCoordinates_general, MvPolynomial.map_map, hφC]
  have hfibre : eval y (specializeFirstCoordinates (n := 2) xΩ FΩ) = 0 := by
    rw [← hgeneric]
    have h := hy 0
    change eval y (map φ (universalCubicFiber F)) = 0 at h
    exact h
  have hyfibre (i : Fin 3) :
      eval y (pderiv i (specializeFirstCoordinates (n := 2) xΩ FΩ)) = 0 := by
    rw [← hgeneric, pderiv_map]
    have h := hy i.succ
    change eval y (map φ (pderiv i (universalCubicFiber F))) = 0 at h
    exact h
  have hFxy : eval (Sum.elim xΩ y) FΩ = 0 := by
    rw [← eval_specializeFirstCoordinates]
    exact hfibre
  have hygrad (i : Fin 3) : eval (Sum.elim xΩ y) (pderiv (.inr i) FΩ) = 0 := by
    rw [← eval_specializeFirstCoordinates, specializeFirstCoordinates_pderiv_inr]
    exact hyfibre i
  have hFxyA : aeval (Sum.elim xΩ y) F = 0 := by
    simpa [FΩ, aeval_def] using hFxy
  have hygradA (i : Fin 3) : aeval (Sum.elim xΩ y) (pderiv (.inr i) F) = 0 := by
    simpa [FΩ, aeval_def, pderiv_map] using hygrad i
  have hxgradA (i : Fin 3) : aeval (Sum.elim xΩ y) (pderiv (.inl i) F) = 0 := by
    obtain ⟨D, hD⟩ := exists_algebraicClosure_coordinateDerivation (k := k) i
    have hDx (j : Fin 3) : D (xΩ j) = if j = i then 1 else 0 := by
      simpa [xΩ, φ, A, K, Ω] using hD j
    have hchain := derivation_aeval_eq_sum D (Sum.elim xΩ y) F
    have hsum : (∑ z : BiprojectiveCoordinate 2 2,
        aeval (Sum.elim xΩ y) (pderiv z F) * D (Sum.elim xΩ y z)) = 0 := by
      rw [← hchain, hFxyA, map_zero]
    rw [Fintype.sum_sum_type] at hsum
    simpa [hDx, hygradA] using hsum
  have hgradΩ : ∀ z : BiprojectiveCoordinate 2 2, eval (Sum.elim xΩ y) (pderiv z FΩ) = 0 := by
    rintro (i | j)
    · simpa [FΩ, aeval_def, pderiv_map] using hxgradA i
    · exact hygrad j
  have hxΩ0 : xΩ ≠ 0 := by
    intro hx
    have hx0 := congrFun hx 0
    have hX0 : (X (0 : Fin 3) : A) ≠ 0 := X_ne_zero (R := k) 0
    have hx0' : algebraMap K Ω (algebraMap A K (X (0 : Fin 3))) = 0 := by
      rw [← IsScalarTower.algebraMap_apply A K Ω]
      simpa [xΩ, φ] using hx0
    have hx0K : algebraMap A K (X (0 : Fin 3)) = 0 := by
      apply (algebraMap K Ω).injective
      simpa only [map_zero] using hx0'
    exact hX0 (IsFractionRing.to_map_eq_zero_iff.mp hx0K)
  exact false_of_baseChanged_common_zero_of_smooth
    F hF hF0 xΩ y hxΩ0 hy0 hFxy hgradΩ

end

end BConicBundleMultisections
