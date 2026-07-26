/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import BConicBundleMultisections.Standard.ShortWeierstrassTangentResidual
public import BConicBundleMultisections.PlaneCubicResidualTransport

/-!
# Tangent-residual avoidance for a smooth plane cubic

This module transports the explicit short-Weierstrass calculation in
`Standard.ShortWeierstrassTangentResidual` back to an arbitrary smooth ternary cubic.

Suppose that `M` carries the original equation `g` to the short equation `E`, up to a nonzero
scalar `c`, and that `N` is its inverse:

```
C c * g(M X) = E(X),       M * N = N * M = 1.
```

A point `y` of `g` has short coordinates `N *ᵥ y`.  Short-Weierstrass surjectivity supplies a
tangent line whose residual representative is a nonzero multiple of `N *ᵥ y`.  Restriction to a
line commutes with linear substitution, while `residualAmbientRep` commutes with `M`; its remaining
dependence on the equation is linear.  These three identities transport the tangent line and its
residual point back to `g`.

The final avoidance theorem assumes exactly the pointwise properness needed in G4: there is a
projective point of the cubic where the prescribed homogeneous target polynomial does not vanish.
-/

@[expose] public section

open scoped Matrix

namespace BConicBundleMultisections.Standard

noncomputable section

universe u

open _root_.MvPolynomial

variable {k : Type u} [Field k] [CharZero k]

/-! ## Scaling the restricted equation -/

omit [CharZero k] in
/-- Restriction to a line commutes with multiplying the equation by a scalar. -/
theorem binaryLineRestriction_C_mul (c : k) (p q : Fin 3 → k)
    (f : MvPolynomial (Fin 3) k) :
    binaryLineRestriction p q (C c * f) =
      C c * binaryLineRestriction p q f := by
  rw [map_mul, binaryLineRestriction_C]

omit [CharZero k] in
/-- The binary residual representative is linear in the binary cubic. -/
theorem residualBinaryRep_C_mul (c : k) (f : MvPolynomial (Fin 2) k) :
    residualBinaryRep (C c * f) = fun i => c * residualBinaryRep f i := by
  funext i
  fin_cases i <;> simp [residualBinaryRep, coeff_C_mul]

omit [CharZero k] in
/-- The ambient residual representative is linear in the restricted cubic. -/
theorem residualAmbientRep_C_mul (c : k) (p q : Fin 3 → k)
    (f : MvPolynomial (Fin 2) k) :
    residualAmbientRep p q (C c * f) =
      fun i => c * residualAmbientRep p q f i := by
  funext i
  simp only [residualAmbientRep, residualBinaryRep_C_mul]
  ring

/-! ## Transport from short Weierstrass coordinates -/

/-- **The tangent-residual map of every smooth plane cubic is projectively surjective.**

The witnesses are ordinary cone representatives: `p` is nonzero, `p,q` are linearly independent,
and `q` belongs to the tangent hyperplane at `p`.  The displayed residual representative is a
nonzero scalar multiple of the prescribed nonzero point `y` of the cubic. -/
theorem exists_tangentResidualRep_eq_smul_target_of_isSmoothPlaneCubic [IsAlgClosed k]
    (g : MvPolynomial (Fin 3) k) (hsmooth : IsSmoothPlaneCubic g)
    (y : Fin 3 → k) (hy0 : y ≠ 0) (hy : eval y g = 0) :
    ∃ (p q : Fin 3 → k) (a : k),
      p ≠ 0 ∧
      eval p g = 0 ∧
      LinearIndependent k ![p, q] ∧
      q ∈ tangentHyperplaneCone g p ∧
      a ≠ 0 ∧
      residualAmbientRep p q (binaryLineRestriction p q g) = fun i => a * y i := by
  obtain ⟨M, N, A, B, c, hMN, hNM, hc, hnormal, hdisc⟩ :=
    ShortWeierstrassNormalForm.exists_shortWeierstrass_coordinates g hsmooth
  let gM : MvPolynomial (Fin 3) k :=
    (aeval (linearSubst 2 M) : MvPolynomial (Fin 3) k →ₐ[k] _) g
  have hnormal' : C c * gM = shortWeierstrassCubic A B := by
    simpa [gM, shortWeierstrassCubic] using hnormal
  let yS : Fin 3 → k := N *ᵥ y
  have hMyS : M *ᵥ yS = y := by
    simp [yS, Matrix.mulVec_mulVec, hMN]
  have hyS0 : yS ≠ 0 := by
    intro hyS
    apply hy0
    rw [← hMyS, hyS, Matrix.mulVec_zero]
  have hyS : eval yS (shortWeierstrassCubic A B) = 0 := by
    calc
      eval yS (shortWeierstrassCubic A B) = eval yS (C c * gM) := by
        rw [hnormal']
      _ = c * eval yS gM := by rw [map_mul, eval_C]
      _ = c * eval (M *ᵥ yS) g := by
        change c * eval yS
          ((aeval (linearSubst 2 M) : MvPolynomial (Fin 3) k →ₐ[k] _) g) = _
        rw [eval_aeval_linearSubst]
      _ = 0 := by rw [hMyS, hy, mul_zero]
  obtain ⟨pS, qS, b, hpS0, hpS, hpqS, hqS, hb, hresS⟩ :=
    exists_tangentResidualRep_eq_smul_target A B hdisc yS hyS0 hyS
  let p : Fin 3 → k := M *ᵥ pS
  let q : Fin 3 → k := M *ᵥ qS
  have hp0 : p ≠ 0 := by
    intro hp
    apply hpS0
    have h := congrArg (fun z => N *ᵥ z) hp
    simpa [p, Matrix.mulVec_mulVec, hNM] using h
  have hp : eval p g = 0 := by
    have hcp : c * eval p g = 0 := by
      calc
        c * eval p g = c * eval (M *ᵥ pS) g := by rfl
        _ = c * eval pS gM := by
          change c * eval (M *ᵥ pS) g =
            c * eval pS
              ((aeval (linearSubst 2 M) : MvPolynomial (Fin 3) k →ₐ[k] _) g)
          rw [eval_aeval_linearSubst]
        _ = eval pS (C c * gM) := by rw [map_mul, eval_C]
        _ = eval pS (shortWeierstrassCubic A B) := by rw [hnormal']
        _ = 0 := hpS
    exact (mul_eq_zero.mp hcp).resolve_left hc
  have hpq : LinearIndependent k ![p, q] := by
    rw [LinearIndependent.pair_iff] at hpqS ⊢
    intro s t hst
    apply hpqS s t
    have h := congrArg (fun z => N *ᵥ z) hst
    simpa [p, q, Matrix.mulVec_add, Matrix.mulVec_smul,
      Matrix.mulVec_mulVec, hNM] using h
  have hq : q ∈ tangentHyperplaneCone g p := by
    have hderS :
        eval (binaryFirstEndpoint (R := k))
            (pderiv (1 : Fin 2)
              (binaryLineRestriction pS qS (shortWeierstrassCubic A B))) = 0 := by
      rw [eval_pderiv_one_binaryLineRestriction_first]
      exact hqS
    have hderM :
        eval (binaryFirstEndpoint (R := k))
            (pderiv (1 : Fin 2) (binaryLineRestriction pS qS gM)) = 0 := by
      rw [← hnormal', binaryLineRestriction_C_mul, pderiv_C_mul,
        map_mul, eval_C] at hderS
      exact (mul_eq_zero.mp hderS).resolve_left hc
    rw [mem_tangentHyperplaneCone, ← eval_pderiv_one_binaryLineRestriction_first]
    rw [← binaryLineRestriction_aeval_linearSubst 2 M pS qS g]
    exact hderM
  let f : MvPolynomial (Fin 2) k := binaryLineRestriction p q g
  have hf : binaryLineRestriction pS qS gM = f := by
    exact binaryLineRestriction_aeval_linearSubst 2 M pS qS g
  have hresScale :
      residualAmbientRep pS qS
          (binaryLineRestriction pS qS (shortWeierstrassCubic A B)) =
        fun i => c * residualAmbientRep pS qS f i := by
    rw [← hnormal', binaryLineRestriction_C_mul, residualAmbientRep_C_mul, hf]
  let a : k := c⁻¹ * b
  have ha : a ≠ 0 := mul_ne_zero (inv_ne_zero hc) hb
  have hresFrame : residualAmbientRep pS qS f = fun i => a * yS i := by
    rw [hresScale] at hresS
    funext i
    have hi := congrFun hresS i
    calc
      residualAmbientRep pS qS f i = c⁻¹ * (c * residualAmbientRep pS qS f i) := by
        field_simp
      _ = c⁻¹ * (b * yS i) := by rw [hi]
      _ = a * yS i := by simp only [a]; ring
  have hres : residualAmbientRep p q f = fun i => a * y i := by
    calc
      residualAmbientRep p q f = M *ᵥ residualAmbientRep pS qS f := by
        exact (mulVec_residualAmbientRep M pS qS f).symm
      _ = M *ᵥ (a • yS) := by
        have hfun : (fun i => a * yS i) = a • yS := by
          funext i
          simp [Pi.smul_apply, smul_eq_mul]
        exact congrArg (fun z => M *ᵥ z) (hresFrame.trans hfun)
      _ = a • (M *ᵥ yS) := by rw [Matrix.mulVec_smul]
      _ = a • y := by rw [hMyS]
      _ = fun i => a * y i := by ext i; simp [Pi.smul_apply]
  exact ⟨p, q, a, hp0, hp, hpq, hq, ha, hres⟩

/-! ## Homogeneous-target avoidance -/

/-- **Some tangent residual avoids every pointwise proper homogeneous target on a smooth cubic.**

The hypothesis says precisely that the hypersurface `H = 0` does not contain the projective cubic.
No density or generic-point argument is hidden in the statement. -/
theorem exists_tangentResidualRep_avoids_homogeneous_target_of_isSmoothPlaneCubic
    [IsAlgClosed k]
    (g : MvPolynomial (Fin 3) k) (hsmooth : IsSmoothPlaneCubic g)
    (H : MvPolynomial (Fin 3) k) {d : ℕ} (hH : H.IsHomogeneous d)
    (hproper : ∃ y : Fin 3 → k, y ≠ 0 ∧ eval y g = 0 ∧ eval y H ≠ 0) :
    ∃ p q : Fin 3 → k,
      p ≠ 0 ∧
      eval p g = 0 ∧
      LinearIndependent k ![p, q] ∧
      q ∈ tangentHyperplaneCone g p ∧
      eval (residualAmbientRep p q (binaryLineRestriction p q g)) H ≠ 0 := by
  obtain ⟨y, hy0, hy, hyH⟩ := hproper
  obtain ⟨p, q, a, hp0, hp, hpq, hq, ha, hres⟩ :=
    exists_tangentResidualRep_eq_smul_target_of_isSmoothPlaneCubic
      g hsmooth y hy0 hy
  refine ⟨p, q, hp0, hp, hpq, hq, ?_⟩
  rw [hres, eval_smul_point_of_isHomogeneous hH]
  exact mul_ne_zero (pow_ne_zero d ha) hyH

end

end BConicBundleMultisections.Standard
