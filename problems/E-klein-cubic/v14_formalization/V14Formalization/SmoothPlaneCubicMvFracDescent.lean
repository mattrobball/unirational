/-
Copyright (c) 2026 V14Formalization contributors.
Released under Apache 2.0 license.
-/
module

public import V14Formalization.MvFracConstantField
public import V14Formalization.WeierstrassSchemeDescent
public import V14Formalization.KernelLineDescent
public import BConicBundleMultisections.ShortWeierstrassNormalForm
public import Mathlib.FieldTheory.IsAlgClosed.AlgebraicClosure
public import Mathlib.Algebra.MvPolynomial.Eval

/-!
# Descent of a smooth plane cubic over an arbitrary characteristic-zero field

A nonzero solution of a smooth ternary cubic over a pure transcendental
extension is a scalar multiple of a base-field solution.  The argument
extends coefficients to an algebraic closure, applies the existing
algebraically closed Weierstrass descent, and returns via the relative
constant-field theorem.
-/

noncomputable section

open MvPolynomial Matrix

namespace V14Formalization.SmoothPlaneCubicMvFracDescent

open EllipticPolynomialConstancy MvFracConstantField
open BConicBundleMultisections
open ShortWeierstrassNormalForm

variable {K : Type*} [Field K] [CharZero K]

omit [CharZero K] in
theorem isSmoothPlaneCubic_map
    {L : Type*} [Field L] [Algebra K L]
    (F : MvPolynomial (Fin 3) K)
    (hF : Standard.IsSmoothPlaneCubic F)
    (hpts : ∀ r : Fin 3 → L, r ≠ 0 →
      eval r (map (algebraMap K L) F) = 0 →
      ∃ i : Fin 3, eval r (pderiv i (map (algebraMap K L) F)) ≠ 0) :
    Standard.IsSmoothPlaneCubic (map (algebraMap K L) F) :=
  ⟨hF.1.map _, hpts⟩

/-- Homogeneity is preserved by coefficient maps. -/
theorem isHomogeneous_map {L : Type*} [CommSemiring L] (f : K →+* L)
    {σ : Type*} (p : MvPolynomial σ K) {n : ℕ} (hp : p.IsHomogeneous n) :
    (map f p).IsHomogeneous n :=
  hp.map _

/-- If every coordinate of a nonzero vector is a scalar times a base constant,
the scalars can be aligned using one nonzero coordinate. -/
theorem align_projective_scalars
    (n : ℕ) (a : Fin 3 → MvFrac K n) (ha : a ≠ 0)
    (hconst : ∀ i, ∃ c : K, a i = algebraMap K (MvFrac K n) c) :
    ∃ (a0 : Fin 3 → K) (_ha0 : a0 ≠ 0) (c : MvFrac K n),
      c ≠ 0 ∧ a = c • fun i => algebraMap K (MvFrac K n) (a0 i) := by
  obtain ⟨j, hj⟩ : ∃ j, a j ≠ 0 := by
    by_contra h
    push Not at h
    exact ha (funext h)
  obtain ⟨cj, hcj⟩ := hconst j
  have hcjne : cj ≠ 0 := by
    intro h0
    apply hj
    simp [hcj, h0]
  refine ⟨fun i =>
      (Classical.choose (hconst i)) * cj⁻¹,
    ?_, algebraMap K (MvFrac K n) cj, ?_, ?_⟩
  · intro h0
    have h0j := congrFun h0 j
    have hch : Classical.choose (hconst j) = cj := by
      have hspec := Classical.choose_spec (hconst j)
      exact (algebraMap K (MvFrac K n)).injective (hspec.symm.trans hcj)
    have : (cj * cj⁻¹ : K) = 0 := by
      simpa [hch] using h0j
    rw [mul_inv_cancel₀ hcjne] at this
    exact one_ne_zero this
  · simpa [hcj] using hcjne
  · funext i
    have hi := Classical.choose_spec (hconst i)
    rw [Pi.smul_apply, smul_eq_mul, hi, map_mul, map_inv₀]
    have hcj0 : (algebraMap K (MvFrac K n) cj) ≠ 0 := by
      simpa [hcj] using hj
    field_simp [hcj0]

/-- Coefficient maps commute with linear substitution, on values. -/
theorem eval_map_aeval_linearSubst
    {L : Type*} [CommRing L] (φ : K →+* L)
    (M : Matrix (Fin 3) (Fin 3) K)
    (G : MvPolynomial (Fin 3) K) (x : Fin 3 → L) :
    eval x (map φ ((aeval (linearSubst 2 M) :
        MvPolynomial (Fin 3) K →ₐ[K] _) G)) =
      eval ((M.map φ).mulVec x) (map φ G) := by
  rw [eval_map, eval_map]
  induction G using MvPolynomial.induction_on with
  | C a => simp
  | add P Q hP hQ =>
      rw [map_add, eval₂_add, hP, hQ, eval₂_add]
  | mul_X P i hP =>
      have hlin : eval₂ φ x (linearSubst 2 M i) = ((M.map φ).mulVec x) i := by
        simp [linearSubst, Matrix.mulVec, dotProduct, Matrix.map_apply]
      have hmul :
          (aeval (linearSubst 2 M) : MvPolynomial (Fin 3) K →ₐ[K] _) (P * X i) =
            (aeval (linearSubst 2 M) P) * linearSubst 2 M i := by
        rw [map_mul, aeval_X]
      rw [hmul, eval₂_mul, hP, hlin, eval₂_mul, eval₂_X]

theorem eval_map_shortWeierstrassCubic
    {L : Type*} [CommRing L] (φ : K →+* L) (A B : K) (x : Fin 3 → L) :
    eval x (map φ (shortWeierstrassCubic A B)) =
      -(x 0) ^ 3 + (x 1) ^ 2 * x 2 - φ A * x 0 * (x 2) ^ 2 - φ B * (x 2) ^ 3 := by
  simp [shortWeierstrassCubic]

theorem mapped_mulVec_left_inv
    {L : Type*} [CommRing L] (φ : K →+* L)
    {M N : Matrix (Fin 3) (Fin 3) K} (hMN : M * N = 1)
    (x : Fin 3 → L) :
    (M.map φ).mulVec ((N.map φ).mulVec x) = x := by
  rw [Matrix.mulVec_mulVec, ← Matrix.map_mul, hMN,
    Matrix.map_one φ (map_zero φ) (map_one φ), Matrix.one_mulVec]

/-- Over an algebraically closed base, put the cubic in short Weierstrass form
and apply the existing Weierstrass triple descent.

The Weierstrass identity is `eval x (shortWeierstrassCubic A B) =
c * eval (M *ᵥ x) F`.  A zero of `F` at `a` is therefore a zero of the
short cubic at `p = N *ᵥ a`, and the descended Weierstrass point `q`
pulls back as `a0 = M *ᵥ q`. -/
theorem smoothPlaneCubic_projective_descends_mvfrac_of_isAlgClosed
    [IsAlgClosed K] [DecidableEq K]
    (n : ℕ) [DecidableEq (MvFrac K n)]
    (F : MvPolynomial (Fin 3) K)
    (hF : Standard.IsSmoothPlaneCubic F)
    (a : Fin 3 → MvFrac K n) (ha : a ≠ 0)
    (hzero : eval a (map (algebraMap K (MvFrac K n)) F) = 0) :
    ∃ (a0 : Fin 3 → K) (_ha0 : a0 ≠ 0) (c : MvFrac K n),
      c ≠ 0 ∧ a = c • fun i => algebraMap K (MvFrac K n) (a0 i) := by
  haveI : Infinite K := inferInstance
  haveI : NeZero (2 : K) := inferInstance
  haveI : NeZero (3 : K) := inferInstance
  obtain ⟨M, N, A, B, cF, hMN, hNM, hcF, hform, hdisc⟩ :=
    exists_shortWeierstrass_coordinates (k := K) F hF
  set φ : K →+* MvFrac K n := algebraMap K (MvFrac K n)
  let p : Fin 3 → MvFrac K n := (N.map φ).mulVec a
  have ha_of_p : a = (M.map φ).mulVec p :=
    (mapped_mulVec_left_inv φ hMN a).symm
  have hp0 : p ≠ 0 := by
    intro hp
    apply ha
    simpa [hp] using ha_of_p
  have hpF : eval p (map φ (shortWeierstrassCubic A B)) = 0 := by
    have hform' :=
      congrArg (fun f : MvPolynomial (Fin 3) K => eval p (map φ f)) hform
    have hleft :
        eval p (map φ (C cF *
            ((aeval (linearSubst 2 M) : MvPolynomial (Fin 3) K →ₐ[K] _) F))) =
          φ cF * eval a (map φ F) := by
      rw [map_mul, eval_mul, eval_map_aeval_linearSubst, ← ha_of_p]
      simp
    rw [← hform', hleft, hzero, mul_zero]
  let W : WeierstrassCurve K :=
    { a₁ := 0, a₂ := 0, a₃ := 0, a₄ := A, a₆ := B }
  haveI : W.IsShortNF := ⟨rfl, rfl, rfl⟩
  have hΔ : W.Δ = -16 * WeierstrassResidualInfinitesimalCertificate.discr A B := by
    simp only [W, WeierstrassCurve.Δ, WeierstrassCurve.b₂, WeierstrassCurve.b₄,
      WeierstrassCurve.b₆, WeierstrassCurve.b₈,
      WeierstrassResidualInfinitesimalCertificate.discr]
    ring
  haveI : W.IsElliptic :=
    ⟨isUnit_iff_ne_zero.mpr (by
      rw [hΔ]
      exact mul_ne_zero (neg_ne_zero.mpr (by norm_num)) hdisc)⟩
  have heq : (W.baseChange (MvFrac K n)).toProjective.Equation p := by
    unfold WeierstrassCurve.Projective.Equation
    have hpoly :
        eval p (W.baseChange (MvFrac K n)).toProjective.polynomial =
          eval p (map φ (shortWeierstrassCubic A B)) := by
      rw [WeierstrassCurve.Projective.eval_polynomial,
        eval_map_shortWeierstrassCubic]
      simp [W, WeierstrassCurve.baseChange, WeierstrassCurve.map, φ]
      ring
    rw [hpoly, hpF]
  obtain ⟨q, hq0, c, hc, hcoord⟩ :=
    WeierstrassSchemeDescent.projective_weierstrass_triple_descends_mvfrac
      K n W p hp0 heq
  let a0 : Fin 3 → K := M.mulVec q
  have ha0 : a0 ≠ 0 := by
    intro h0
    have hqeq : q = N.mulVec (M.mulVec q) := by
      rw [Matrix.mulVec_mulVec, hNM, Matrix.one_mulVec]
    have : M.mulVec q = 0 := h0
    exact hq0 (by simpa [this] using hqeq)
  refine ⟨a0, ha0, c, hc, ?_⟩
  have hp : p = c • fun j => φ (q j) := by
    funext j; exact hcoord j
  have hMq : (M.map φ).mulVec (fun j => φ (q j)) =
      fun j => φ (a0 j) := by
    funext j
    change ((M.map φ).mulVec (φ ∘ q)) j = φ ((M.mulVec q) j)
    exact (RingHom.map_mulVec φ M q j).symm
  rw [ha_of_p, hp, Matrix.mulVec_smul, hMq]

/-- Evaluation of a mapped cubic commutes with coefficient extension of `MvFrac`. -/
theorem mvFracBaseChange_eval
    {L : Type*} [Field L] [Algebra K L]
    (n : ℕ) (F : MvPolynomial (Fin 3) K) (a : Fin 3 → MvFrac K n) :
    mvFracBaseChange (algebraMap K L)
        (FaithfulSMul.algebraMap_injective K L) n
      (eval a (map (algebraMap K (MvFrac K n)) F)) =
    eval (fun i =>
        mvFracBaseChange (algebraMap K L)
          (FaithfulSMul.algebraMap_injective K L) n (a i))
      (map (algebraMap K (MvFrac L n)) F) := by
  set ι :=
    mvFracBaseChange (algebraMap K L)
      (FaithfulSMul.algebraMap_injective K L) n
  set p := map (algebraMap K (MvFrac K n)) F
  have hcomp : ι.comp (algebraMap K (MvFrac K n)) =
      algebraMap K (MvFrac L n) := by
    ext c
    exact mvFracBaseChange_algebraMap_base (algebraMap K L)
      (FaithfulSMul.algebraMap_injective K L) n c
  have hmap : map ι p = map (algebraMap K (MvFrac L n)) F := by
    change map ι (map (algebraMap K (MvFrac K n)) F) =
      map (algebraMap K (MvFrac L n)) F
    rw [MvPolynomial.map_map, hcomp]
  calc
    ι (eval a p) = eval₂ ι (ι ∘ a) p := eval₂_comp ι a p
    _ = eval (fun i => ι (a i)) (map ι p) := by
        rw [eval_map]
        rfl
    _ = eval (fun i => ι (a i)) (map (algebraMap K (MvFrac L n)) F) := by
      rw [hmap]

/-- Descent over an arbitrary characteristic-zero field, assuming the cubic
remains smooth after base change to an algebraic closure.

`IsSmoothPlaneCubic` over `K` is not enough: it only constrains `K`-points,
so it is not geometric smoothness and is not preserved by base change. -/
public theorem smoothPlaneCubic_projective_descends_mvfrac
    (n : ℕ) (F : MvPolynomial (Fin 3) K)
    (hFbar : Standard.IsSmoothPlaneCubic
      (map (algebraMap K (AlgebraicClosure K)) F))
    (a : Fin 3 → MvFrac K n) (ha : a ≠ 0)
    (hzero : eval a (map (algebraMap K (MvFrac K n)) F) = 0) :
    ∃ (a0 : Fin 3 → K) (_ha0 : a0 ≠ 0) (c : MvFrac K n),
      c ≠ 0 ∧ a = c • fun i => algebraMap K (MvFrac K n) (a0 i) := by
  classical
  let L := AlgebraicClosure K
  let ι :=
    mvFracBaseChange (algebraMap K L)
      (FaithfulSMul.algebraMap_injective K L) n
  let aL : Fin 3 → MvFrac L n := fun i => ι (a i)
  have haL : aL ≠ 0 := by
    intro h0
    apply ha
    funext i
    exact (map_eq_zero_iff ι (mvFracBaseChange_injective _ _ n)).1
      (congrFun h0 i)
  have hzeroL :
      eval aL (map (algebraMap L (MvFrac L n))
        (map (algebraMap K L) F)) = 0 := by
    have htower :
        (algebraMap L (MvFrac L n)).comp (algebraMap K L) =
          algebraMap K (MvFrac L n) := by
      ext c
      exact (IsScalarTower.algebraMap_apply K L (MvFrac L n) c).symm
    have htrans := mvFracBaseChange_eval (L := L) n F a
    rw [hzero, map_zero] at htrans
    have hmaps :
        map (algebraMap L (MvFrac L n)) (map (algebraMap K L) F) =
          map (algebraMap K (MvFrac L n)) F := by
      rw [MvPolynomial.map_map, htower]
    rw [hmaps]
    exact htrans.symm
  obtain ⟨b, hb0, cL, hcL, hscale⟩ :=
    smoothPlaneCubic_projective_descends_mvfrac_of_isAlgClosed
      (K := L) n (map (algebraMap K L) F) hFbar aL haL hzeroL
  have hscalei : ∀ i, ι (a i) = cL * algebraMap L (MvFrac L n) (b i) := by
    intro i
    simpa [aL, Pi.smul_apply, smul_eq_mul] using congrFun hscale i
  obtain ⟨j, hj⟩ : ∃ j, a j ≠ 0 := by
    by_contra h
    push Not at h
    exact ha (funext h)
  have hιj : ι (a j) ≠ 0 :=
    (map_ne_zero_iff ι (mvFracBaseChange_injective _ _ n)).2 hj
  have hbj : b j ≠ 0 := by
    intro hb
    have := hscalei j
    rw [hb, map_zero, mul_zero] at this
    exact hιj this
  have hratio : ∀ i,
      ∃ r : K, a i / a j = algebraMap K (MvFrac K n) r := by
    intro i
    have hιratio :
        ι (a i / a j) = algebraMap L (MvFrac L n) (b i / b j) := by
      calc
        ι (a i / a j) = ι (a i) / ι (a j) := map_div₀ _ _ _
        _ = (cL * algebraMap L (MvFrac L n) (b i)) /
              (cL * algebraMap L (MvFrac L n) (b j)) := by
              rw [hscalei i, hscalei j]
        _ = algebraMap L (MvFrac L n) (b i) /
              algebraMap L (MvFrac L n) (b j) :=
              mul_div_mul_left _ _ hcL
        _ = algebraMap L (MvFrac L n) (b i / b j) := (map_div₀ _ _ _).symm
    exact mvFrac_eq_constant_of_baseChange_eq_constant n
      (a i / a j) (b i / b j) hιratio
  let a0 : Fin 3 → K := fun i => Classical.choose (hratio i)
  have ha0i : ∀ i, a i = algebraMap K (MvFrac K n) (a0 i) * a j := by
    intro i
    have hi := Classical.choose_spec (hratio i)
    calc
      a i = (a i / a j) * a j := (div_mul_cancel₀ (a i) hj).symm
      _ = algebraMap K (MvFrac K n) (a0 i) * a j := by rw [hi]
  have ha0 : a0 ≠ 0 := by
    intro h0
    have hj0 : a0 j = 0 := by
      simpa using congrFun h0 j
    have := ha0i j
    rw [hj0, map_zero, zero_mul] at this
    exact hj this
  refine ⟨a0, ha0, a j, hj, ?_⟩
  funext i
  rw [Pi.smul_apply, smul_eq_mul, ha0i i, mul_comm]

end V14Formalization.SmoothPlaneCubicMvFracDescent
