/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import BConicBundleMultisections.GoodLineConic
public import BConicBundleMultisections.IsotropicCone
public import BConicBundleMultisections.NeZeroTwoThree
public import BConicBundleMultisections.PointedSmoothConicParam
public import BConicBundleMultisections.PlaneCubicTangentResidual
public import BConicBundleMultisections.ResidualHorizontalityLine
public import Mathlib.LinearAlgebra.Dimension.Finrank
public import Mathlib.LinearAlgebra.Dual.Lemmas
public import Mathlib.LinearAlgebra.FiniteDimensional.Basic
public import Mathlib.LinearAlgebra.LinearIndependent.Lemmas
public import Mathlib.LinearAlgebra.Matrix.ToLinearEquiv

/-!
# Section general position for residual stereo frames

Goal C of the residual-multisection programme:

1. **C1 — frame existence.** A nondegenerate ternary quadratic over a field of characteristic
   not 2, together with a nonzero isotropic point, admits a `StereoLineFrame`.
2. **C2 — general position from any section.** Over a nondegenerate line conic, any nonzero
   isotropic polynomial section can be replaced by one with `v₂ ≠ 0` and nonzero stereographic
   polar form.
3. **C3 — G4 transfer (stretch).** Not completed; see the obstruction note at the end.
-/

@[expose] public section

namespace BConicBundleMultisections

noncomputable section

universe u

open Matrix
open _root_.MvPolynomial (eval IsHomogeneous)
open scoped LinearAlgebra.Projectivization

variable {F : Type u} [Field F]

/-! ### Polar dual via the tree's `coordDual` -/

/-- Polar functional at `p`, as `coordDual` of the polar-matrix image of `p`. -/
def polarDual (Q : MvPolynomial (Fin 3) F) (_hQ : Q.IsHomogeneous 2) (p : Fin 3 → F) :
    Module.Dual F (Fin 3 → F) :=
  coordDual ((polarMatrix Q).mulVec p)

theorem polarDual_apply (Q : MvPolynomial (Fin 3) F) (hQ : Q.IsHomogeneous 2)
    (p w : Fin 3 → F) :
    polarDual Q hQ p w = polarEval Q p w := by
  -- coordDual g w = g ⬝ᵥ w, and polarEval = mulVec p ⬝ᵥ w
  rw [polarDual, coordDual_apply, polarEval_eq_dot_mulVec Q hQ p w]
  simp [dotProduct]

theorem polarDual_ne_zero_of_det_ne_zero (Q : MvPolynomial (Fin 3) F) (hQ : Q.IsHomogeneous 2)
    (hdet : (polarMatrix Q).det ≠ 0) {p : Fin 3 → F} (hp0 : p ≠ 0) :
    polarDual Q hQ p ≠ 0 := by
  intro h0
  have hall : ∀ a : Fin 3, polarEval Q p (Pi.single a 1) = 0 := fun a => by
    have := LinearMap.congr_fun h0 (Pi.single a 1)
    rwa [polarDual_apply] at this
  exact hdet (det_polarMatrix_eq_zero_of_polarEval_eq_zero hQ hp0 hall)

theorem mem_ker_polarDual_of_isotropic (Q : MvPolynomial (Fin 3) F) (hQ : Q.IsHomogeneous 2)
    {p : Fin 3 → F} (hp : eval p Q = 0) :
    p ∈ LinearMap.ker (polarDual Q hQ p) := by
  rw [LinearMap.mem_ker, polarDual_apply, polarEval_self hQ, hp, mul_zero]

/-! ### No totally isotropic 2-plane -/

/-- Polar map `u ↦ B(u,·)` into the dual, via `polarDual`. -/
def polarMap (Q : MvPolynomial (Fin 3) F) (hQ : Q.IsHomogeneous 2) :
    (Fin 3 → F) →ₗ[F] Module.Dual F (Fin 3 → F) where
  toFun u := polarDual Q hQ u
  map_add' x y := by
    apply LinearMap.ext
    intro w
    dsimp
    rw [polarDual_apply, polarDual_apply, polarDual_apply]
    have h := polarEval_linear_left hQ (1 : F) (1 : F) x y w
    have hxy : (fun i => (1 : F) * x i + (1 : F) * y i) = (x + y : Fin 3 → F) := by
      funext i; simp [Pi.add_apply]
    rw [← hxy, h]; ring
  map_smul' c x := by
    apply LinearMap.ext
    intro w
    dsimp
    rw [polarDual_apply, polarDual_apply]
    have h := polarEval_linear_left hQ c (0 : F) x (0 : Fin 3 → F) w
    have hvec : (fun i => c * x i + (0 : F) * (0 : Fin 3 → F) i) = (c • x : Fin 3 → F) := by
      funext i; simp [Pi.smul_apply, smul_eq_mul]
    rw [← hvec, h]; ring

theorem polarMap_apply (Q : MvPolynomial (Fin 3) F) (hQ : Q.IsHomogeneous 2)
    (u w : Fin 3 → F) :
    polarMap Q hQ u w = polarEval Q u w := by
  change polarDual Q hQ u w = polarEval Q u w
  exact polarDual_apply Q hQ u w

theorem polarMap_injective (Q : MvPolynomial (Fin 3) F) (hQ : Q.IsHomogeneous 2)
    (hdet : (polarMatrix Q).det ≠ 0) :
    Function.Injective (polarMap Q hQ) := by
  intro x y hxy
  have hker : polarMap Q hQ (x - y) = 0 := by
    rw [map_sub, hxy, sub_self]
  by_contra hne
  have hxy0 : x - y ≠ 0 := sub_ne_zero.mpr hne
  have hall : ∀ a, polarEval Q (x - y) (Pi.single a 1) = 0 := fun a => by
    have := LinearMap.congr_fun hker (Pi.single a 1)
    rwa [polarMap_apply] at this
  exact hdet (det_polarMatrix_eq_zero_of_polarEval_eq_zero hQ hxy0 hall)

/-- **No-two-plane lemma.** Via dual annihilator: polar map injects `P` into `P°`. -/
theorem finrank_le_one_of_totally_isotropic
    (Q : MvPolynomial (Fin 3) F) (hQ : Q.IsHomogeneous 2)
    (hdet : (polarMatrix Q).det ≠ 0)
    (P : Submodule F (Fin 3 → F))
    (htot : ∀ u ∈ P, ∀ v ∈ P, polarEval Q u v = 0) :
    Module.finrank F P ≤ 1 := by
  classical
  have hβ_inj := polarMap_injective Q hQ hdet
  let βP : P →ₗ[F] Module.Dual F (Fin 3 → F) := (polarMap Q hQ).comp P.subtype
  have hrange : ∀ u : P, βP u ∈ P.dualAnnihilator := by
    intro u
    rw [Submodule.mem_dualAnnihilator]
    intro v hv
    have : βP u v = polarEval Q (u : Fin 3 → F) v := by
      dsimp [βP]
      exact polarMap_apply Q hQ _ v
    rw [this]
    exact htot _ u.property _ hv
  let βP' : P →ₗ[F] P.dualAnnihilator :=
    LinearMap.codRestrict P.dualAnnihilator βP hrange
  have hinj : Function.Injective βP' := by
    intro u₁ u₂ heq
    exact Subtype.ext (hβ_inj (congrArg Subtype.val heq))
  have hle : Module.finrank F P ≤ Module.finrank F P.dualAnnihilator :=
    LinearMap.finrank_le_finrank_of_injective hinj
  have hV : Module.finrank F (Fin 3 → F) = 3 := Module.finrank_fin_fun F
  have hann := Subspace.finrank_add_finrank_dualAnnihilator_eq (K := F) (V := Fin 3 → F) P
  omega

theorem not_eval_eq_zero_on_finrank_two
    [NeZero (2 : F)]
    (Q : MvPolynomial (Fin 3) F) (hQ : Q.IsHomogeneous 2)
    (hdet : (polarMatrix Q).det ≠ 0)
    (P : Submodule F (Fin 3 → F))
    (hdim : Module.finrank F P = 2)
    (hvan : ∀ w ∈ P, eval w Q = 0) : False := by
  have htot : ∀ u ∈ P, ∀ v ∈ P, polarEval Q u v = 0 := by
    intro u hu v hv
    have hadd : u + v ∈ P := add_mem hu hv
    have hsum : eval (u + v) Q = 0 := hvan _ hadd
    have hvec : (fun j => u j + v j) = (u + v : Fin 3 → F) := rfl
    simp only [polarEval, hvan u hu, hvan v hv, hvec, hsum, sub_self]
  have := finrank_le_one_of_totally_isotropic Q hQ hdet P htot
  omega

/-! ### Frame matrix -/

theorem mulVec_frameMatrix' (v0 v1 v2 c : Fin 3 → F) :
    (frameMatrix v0 v1 v2).mulVec c =
      fun i => c 0 * v0 i + c 1 * v1 i + c 2 * v2 i := by
  have h := mulVec_frameMatrix v0 v1 v2 (c 0) (c 1) (c 2)
  -- mulVec_frameMatrix uses ![c0,c1,c2]
  have hc : (![c 0, c 1, c 2] : Fin 3 → F) = c := by
    ext i; fin_cases i <;> simp
  simpa [hc] using h

theorem frameMatrix_det_ne_zero_of_linearIndependent
    {v0 v1 v2 : Fin 3 → F} (hli : LinearIndependent F ![v0, v1, v2]) :
    (frameMatrix v0 v1 v2).det ≠ 0 := by
  intro hdet0
  obtain ⟨c, hc0, hmv⟩ := (exists_mulVec_eq_zero_iff).mpr hdet0
  have hsum : (∑ i : Fin 3, c i • ![v0, v1, v2] i : Fin 3 → F) = 0 := by
    funext k
    have hk : c 0 * v0 k + c 1 * v1 k + c 2 * v2 k = 0 := by
      simpa [mulVec_frameMatrix'] using congr_fun hmv k
    simp [Fin.sum_univ_three, Pi.smul_apply, smul_eq_mul, Matrix.cons_val, hk]
  have hcoeff := (linearIndependent_iff').1 hli Finset.univ c hsum
  exact hc0 (funext fun i => hcoeff i (Finset.mem_univ i))

/-! ### C1: frame existence -/

private theorem range_pair {α : Type*} (p w0 : α) :
    Set.range ![p, w0] = ({p, w0} : Set α) := by
  ext y
  constructor
  · rintro ⟨i, rfl⟩
    fin_cases i <;> simp
  · intro hy
    rcases Set.mem_insert_iff.mp hy with rfl | hy'
    · exact ⟨0, rfl⟩
    · exact ⟨1, (Set.mem_singleton_iff.mp hy').symm ▸ rfl⟩

/-- **C1. Frame existence.** -/
theorem exists_stereoLineFrame_of_det_ne_zero
    [NeZero (2 : F)]
    (Q : MvPolynomial (Fin 3) F) (hQ : Q.IsHomogeneous 2)
    (hdet : (polarMatrix Q).det ≠ 0)
    (p : Fin 3 → F) (hp0 : p ≠ 0) (hp : eval p Q = 0) :
    ∃ w0 w1 : Fin 3 → F, StereoLineFrame Q p w0 w1 := by
  classical
  set φ := polarDual Q hQ p with hφdef
  have hφ : φ ≠ 0 := polarDual_ne_zero_of_det_ne_zero Q hQ hdet hp0
  have hpker : p ∈ LinearMap.ker φ := mem_ker_polarDual_of_isotropic Q hQ hp
  have hfin : Module.finrank F (LinearMap.ker φ) = 2 := by
    have h := Module.Dual.finrank_ker_add_one_of_ne_zero hφ
    have hV : Module.finrank F (Fin 3 → F) = 3 := Module.finrank_fin_fun F
    omega
  have hp_ne : (⟨p, hpker⟩ : LinearMap.ker φ) ≠ 0 := fun h =>
    hp0 (congrArg Subtype.val h)
  have hlt :
      Module.finrank F (F ∙ (⟨p, hpker⟩ : LinearMap.ker φ)) <
        Module.finrank F (LinearMap.ker φ) := by
    rw [finrank_span_singleton hp_ne, hfin]; norm_num
  obtain ⟨w0ker, hw0ker⟩ :=
    Submodule.exists_of_finrank_lt (F ∙ (⟨p, hpker⟩ : LinearMap.ker φ)) hlt
  set w0 : Fin 3 → F := (w0ker : Fin 3 → F)
  have hw0_polar : polarEval Q p w0 = 0 := by
    have hmem : φ w0 = 0 := (LinearMap.mem_ker (f := φ)).1 w0ker.property
    rwa [hφdef, polarDual_apply] at hmem
  have hp_w0_li : LinearIndependent F ![p, w0] := by
    rw [LinearIndependent.pair_iff]
    intro a b hab
    have habker :
        a • (⟨p, hpker⟩ : LinearMap.ker φ) + b • w0ker = 0 :=
      Subtype.ext (by simpa [w0] using hab)
    by_cases hb : b = 0
    · subst hb
      simp only [zero_smul, add_zero] at habker
      have ha : a = 0 := by
        have hval := congrArg Subtype.val habker
        change a • p = 0 at hval
        exact (smul_eq_zero.mp hval).resolve_right hp0
      exact ⟨ha, rfl⟩
    · have hba : b • w0ker = -(a • (⟨p, hpker⟩ : LinearMap.ker φ)) :=
        eq_neg_of_add_eq_zero_right habker
      have hmem : w0ker ∈ F ∙ (⟨p, hpker⟩ : LinearMap.ker φ) := by
        have hsol : w0ker = (b⁻¹ * -a) • (⟨p, hpker⟩ : LinearMap.ker φ) := by
          apply (smul_right_injective (LinearMap.ker φ) hb).eq_iff.1
          calc
            b • w0ker = -(a • (⟨p, hpker⟩ : LinearMap.ker φ)) := hba
            _ = (-a) • (⟨p, hpker⟩ : LinearMap.ker φ) := by rw [neg_smul]
            _ = (b * (b⁻¹ * -a)) • (⟨p, hpker⟩ : LinearMap.ker φ) := by field_simp [hb]
            _ = b • ((b⁻¹ * -a) • (⟨p, hpker⟩ : LinearMap.ker φ)) := by rw [smul_smul]
        rw [hsol]
        exact Submodule.smul_mem _ _ (Submodule.mem_span_singleton_self _)
      exact absurd (by simpa using hmem) (hw0ker (1 : F) one_ne_zero)
  set Pspan : Submodule F (Fin 3 → F) := Submodule.span F (Set.range ![p, w0])
  have hPfin : Module.finrank F Pspan = 2 := by
    dsimp [Pspan]; rw [finrank_span_eq_card hp_w0_li]; simp
  have hw0Q : eval w0 Q ≠ 0 := by
    intro hw0iso
    have hvan : ∀ w ∈ Pspan, eval w Q = 0 := by
      intro w hw
      have hw' : w ∈ Submodule.span F ({p, w0} : Set (Fin 3 → F)) := by
        dsimp [Pspan] at hw
        rwa [range_pair] at hw
      rw [Submodule.mem_span_pair] at hw'
      obtain ⟨a, b, rfl⟩ := hw'
      have hvec : (a • p + b • w0 : Fin 3 → F) = fun i => a * p i + b * w0 i := by
        funext i; simp [Pi.add_apply, Pi.smul_apply, smul_eq_mul]
      rw [hvec, eval_linComb_of_isHomogeneous_two Q hQ a b p w0, hp, hw0iso, hw0_polar]
      ring
    exact not_eval_eq_zero_on_finrank_two Q hQ hdet Pspan hPfin hvan
  have hV : Module.finrank F (Fin 3 → F) = 3 := Module.finrank_fin_fun F
  have hltV : Module.finrank F Pspan < Module.finrank F (Fin 3 → F) := by
    rw [hPfin, hV]; norm_num
  obtain ⟨w1, hw1⟩ := Submodule.exists_of_finrank_lt Pspan hltV
  have hw1_not : w1 ∉ Pspan := by
    intro h; exact hw1 (1 : F) one_ne_zero (by simpa using h)
  have hp_w0_w1_li : LinearIndependent F ![p, w0, w1] := by
    have hsnoc : (![p, w0, w1] : Fin 3 → Fin 3 → F) = Fin.snoc ![p, w0] w1 := by
      ext i; fin_cases i <;> simp [Fin.snoc]
    rw [hsnoc, linearIndependent_finSnoc]
    exact ⟨hp_w0_li, hw1_not⟩
  have hframe := frameMatrix_det_ne_zero_of_linearIndependent hp_w0_w1_li
  have hw1_polar : polarEval Q p w1 ≠ 0 := by
    intro hz
    have hw1ker : w1 ∈ LinearMap.ker φ := by
      rw [LinearMap.mem_ker, hφdef, polarDual_apply, hz]
    have hp_w0_in : Pspan ≤ LinearMap.ker φ := by
      intro x hx
      have hx' : x ∈ Submodule.span F ({p, w0} : Set (Fin 3 → F)) := by
        dsimp [Pspan] at hx
        rwa [range_pair] at hx
      rw [Submodule.mem_span_pair] at hx'
      obtain ⟨a, b, rfl⟩ := hx'
      rw [LinearMap.mem_ker, hφdef, polarDual_apply]
      have hvec : (a • p + b • w0 : Fin 3 → F) = fun i => a * p i + b * w0 i := by
        funext i; simp [Pi.add_apply, Pi.smul_apply, smul_eq_mul]
      rw [hvec, polarEval_linear_right hQ a b p w0 p, polarEval_self hQ, hp, hw0_polar]
      ring
    have hker_eq : LinearMap.ker φ = Pspan :=
      (Submodule.eq_of_le_of_finrank_eq hp_w0_in (by omega)).symm
    exact hw1_not (hker_eq ▸ hw1ker)
  exact ⟨w0, w1,
    { isHomogeneous := hQ
      isotropic := hp
      base_ne_zero := hp0
      polar_w0 := hw0_polar
      polar_w1 := hw1_polar
      free_not_isotropic := hw0Q
      frame_det := hframe }⟩

/-! ### C2: general position from any isotropic section -/

variable {k : Type u} [Field k]

/-- **C2. General position from any section.** -/
theorem exists_generalPosition_section_of_isotropic
    (p₀ q₀ : Fin 3 → k)
    (Fpoly : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 Fpoly)
    (hdisc : lineConicDiscriminant p₀ q₀ Fpoly ≠ 0)
    (v : Fin 3 → Polynomial k) (hv0 : v ≠ 0)
    (hv : TernaryQuadraticPoly.eval (lineTernaryQuadraticPoly p₀ q₀ Fpoly) v = 0) :
    ∃ v' : Fin 3 → Polynomial k,
      v' ≠ 0 ∧
        TernaryQuadraticPoly.eval (lineTernaryQuadraticPoly p₀ q₀ Fpoly) v' = 0 ∧
          v' 2 ≠ 0 ∧
            lineStereoPolarForm p₀ q₀ Fpoly v' ≠ 0 := by
  classical
  have hQhom : (lineSpecializedConicPoly p₀ q₀ Fpoly).IsHomogeneous 2 :=
    lineSpecializedConicPoly_isHomogeneous p₀ q₀ hF
  have hviso : eval v (lineSpecializedConicPoly p₀ q₀ Fpoly) = 0 := by
    rwa [← ternaryQuadraticPoly_eval_line p₀ q₀ Fpoly hF]
  obtain ⟨v', hv'0, hv'iso, hv'2, hv'polar⟩ :=
    exists_isotropic_polarEval_ne_zero hQhom hdisc hv0 hviso
  refine ⟨v', hv'0, ?_, hv'2, ?_⟩
  · rwa [ternaryQuadraticPoly_eval_line p₀ q₀ Fpoly hF]
  · simpa [lineStereoPolarForm] using
      polarEval_lineStereoDir_ne_zero_of_polarEval_ne_zero p₀ q₀ Fpoly hF v' hv'polar

/-- C2 with polar form expanded for residual consumers. -/
theorem exists_generalPosition_section_of_isotropic'
    (p₀ q₀ : Fin 3 → k)
    (Fpoly : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 Fpoly)
    (hdisc : lineConicDiscriminant p₀ q₀ Fpoly ≠ 0)
    (v : Fin 3 → Polynomial k) (hv0 : v ≠ 0)
    (hv : TernaryQuadraticPoly.eval (lineTernaryQuadraticPoly p₀ q₀ Fpoly) v = 0) :
    ∃ v' : Fin 3 → Polynomial k,
      v' ≠ 0 ∧
        TernaryQuadraticPoly.eval (lineTernaryQuadraticPoly p₀ q₀ Fpoly) v' = 0 ∧
          v' 2 ≠ 0 ∧
            polarEval (lineSpecializedConicPullback p₀ q₀ Fpoly)
              (liftTsenSection v') affineTwoStereoDir ≠ 0 := by
  obtain ⟨v', h0, hiso, h2, hpol⟩ :=
    exists_generalPosition_section_of_isotropic p₀ q₀ Fpoly hF hdisc v hv0 hv
  exact ⟨v', h0, hiso, h2, by simpa [lineStereoPolarForm] using hpol⟩

/-! ### C1 over `RatFunc k` -/

/-- Instantiation of C1 over `RatFunc k`. -/
theorem exists_stereoLineFrame_ratFunc
    [NeZero (2 : k)]
    (p₀ q₀ : Fin 3 → k)
    (Fpoly : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 Fpoly)
    (hdisc : lineConicDiscriminant p₀ q₀ Fpoly ≠ 0)
    (p : Fin 3 → RatFunc k) (hp0 : p ≠ 0)
    (hp : TernaryQuadraticPoly.evalRatFunc (lineTernaryQuadraticPoly p₀ q₀ Fpoly) p = 0) :
    ∃ w0 w1 : Fin 3 → RatFunc k,
      StereoLineFrame
        (MvPolynomial.map (algebraMap (Polynomial k) (RatFunc k))
          (lineSpecializedConicPoly p₀ q₀ Fpoly))
        p w0 w1 := by
  classical
  haveI : NeZero (2 : Polynomial k) :=
    neZero_two_of_injective_algebraMap (R := k) (A := Polynomial k)
      (FaithfulSMul.algebraMap_injective k (Polynomial k))
  haveI : NeZero (2 : RatFunc k) :=
    neZero_two_of_injective_algebraMap (R := Polynomial k) (A := RatFunc k)
      (IsFractionRing.injective (Polynomial k) (RatFunc k))
  set Qpol := lineSpecializedConicPoly p₀ q₀ Fpoly
  set Q := MvPolynomial.map (algebraMap (Polynomial k) (RatFunc k)) Qpol
  have hQ : Q.IsHomogeneous 2 := (lineSpecializedConicPoly_isHomogeneous p₀ q₀ hF).map _
  have hdet : (polarMatrix Q).det ≠ 0 := by
    have hmap : polarMatrix Q =
        (polarMatrix Qpol).map (algebraMap (Polynomial k) (RatFunc k)) :=
      polarMatrix_map _ Qpol
    have hdetmap :
        (polarMatrix Q).det =
          algebraMap (Polynomial k) (RatFunc k) (polarMatrix Qpol).det := by
      rw [hmap]
      exact (RingHom.map_det (algebraMap (Polynomial k) (RatFunc k)) (polarMatrix Qpol)).symm
    intro h0
    apply hdisc
    change (polarMatrix Qpol).det = 0
    exact (IsFractionRing.injective (Polynomial k) (RatFunc k)).eq_iff.mp (by
      simpa [hdetmap, map_zero, lineConicDiscriminant] using h0)
  have hpQ : eval p Q = 0 := by
    have hsum := eval_eq_ternaryQuadraticCoeff_sum hQ p
    have hcoeff (i j : Fin 3) :
        ternaryQuadraticCoeff Q i j =
          algebraMap (Polynomial k) (RatFunc k) (ternaryQuadraticCoeff Qpol i j) := by
      simp only [ternaryQuadraticCoeff]
      split_ifs <;> simp [Q, MvPolynomial.coeff_map]
    calc eval p Q
        = ∑ i, ∑ j, ternaryQuadraticCoeff Q i j * p i * p j := hsum
      _ = ∑ i, ∑ j,
            algebraMap (Polynomial k) (RatFunc k) (ternaryQuadraticCoeff Qpol i j) *
              p i * p j := by
          refine Finset.sum_congr rfl fun i _ => Finset.sum_congr rfl fun j _ => ?_
          rw [hcoeff]
      _ = TernaryQuadraticPoly.evalRatFunc (lineTernaryQuadraticPoly p₀ q₀ Fpoly) p := by
          simp only [TernaryQuadraticPoly.evalRatFunc, ternaryQuadraticPolyRatFunc,
            lineTernaryQuadraticPoly, Qpol]
      _ = 0 := hp
  exact exists_stereoLineFrame_of_det_ne_zero Q hQ hdet p hp0 hpQ

/-! ### C3 obstruction note

**C3 (stretch) was not completed.**

Intended claim: `ResidualAvoidsConicDiscriminantOn p₀ q₀ r N F v` transfers between two
general-position isotropic sections of the same line conic.

Obstruction:
* Residual `Y`-charts for two sections of one line conic differ by a stereo reparametrisation
  of the second affine parameter.
* The tree has no identification of `residualYCoordsOn … v` with `residualYCoordsOn … v'` by a
  fractional-linear substitution, nor a packaged lemma that nonconstant rational substitution in
  `s` preserves nonvanishing of bivariate polynomials.
* Stating transfer without that identity would be a false general lemma.

Consumers should keep G4 as an explicit hypothesis.
-/

end

end BConicBundleMultisections
