/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import BConicBundleMultisections.PlaneCubicResidualEquivariance
public import Mathlib.Algebra.MvPolynomial.PDeriv

/-!
# Smooth plane cubics and their residual-line maps

This module contains the definitions and coordinate-change lemmas used both by Hesse normal form
and by residual-map rigidity.  Keeping them separate from the final injectivity theorem avoids an
import cycle between those two arguments.
-/

@[expose] public section

namespace BConicBundleMultisections.Standard

noncomputable section

universe u v

open MvPolynomial
open _root_.MvPolynomial

variable {k : Type u} [Field k]

/-- A homogeneous cubic with no projective common zero of its three partial derivatives. -/
def IsSmoothPlaneCubic (f : MvPolynomial (Fin 3) k) : Prop :=
  f.IsHomogeneous 3 ∧
    ∀ r : Fin 3 → k, r ≠ 0 → eval r f = 0 → ∃ i : Fin 3, eval r (pderiv i f) ≠ 0

/-- The residual-line coefficient vector is nonzero along every projective line. -/
def ResidualLineMapBasepointFree (f : MvPolynomial (Fin 3) k) : Prop :=
  ∀ M N : Matrix (Fin 3) (Fin 3) k, M * N = 1 → residualLinearFormOn M N f ≠ 0

/-- Every family member has, projectively, the same residual line along every input line. -/
def HasCommonResidualLineMap {ι : Type v} (f : ι → MvPolynomial (Fin 3) k) : Prop :=
  ∀ M N : Matrix (Fin 3) (Fin 3) k, M * N = 1 →
    ∃ ell : MvPolynomial (Fin 3) k, ∀ i : ι, ∃ a : k,
      residualLinearFormOn M N (f i) = C a * ell

/-- Composing two linear substitutions multiplies their matrices in the order dictated by
precomposition: first `B`, then `A`, is substitution by `B * A`. -/
theorem aeval_linearSubst_comp (A B : Matrix (Fin 3) (Fin 3) k)
    (G : MvPolynomial (Fin 3) k) :
    (aeval (linearSubst 2 A) : MvPolynomial (Fin 3) k →ₐ[k] _)
        ((aeval (linearSubst 2 B) : MvPolynomial (Fin 3) k →ₐ[k] _) G)
      = (aeval (linearSubst 2 (B * A)) : MvPolynomial (Fin 3) k →ₐ[k] _) G := by
  induction G using MvPolynomial.induction_on with
  | C r => simp
  | add p q hp hq => simp [hp, hq]
  | mul_X p i hp =>
      simp [hp, aeval_linearSubst_linearSubst]

/-- Coordinate-change formula for the residual line. -/
theorem residualLinearFormOn_aeval_linearSubst (P Q M N : Matrix (Fin 3) (Fin 3) k)
    (hPQ : P * Q = 1) (G : MvPolynomial (Fin 3) k) :
    residualLinearFormOn M N
        ((aeval (linearSubst 2 P) : MvPolynomial (Fin 3) k →ₐ[k] _) G)
      = (aeval (linearSubst 2 P) : MvPolynomial (Fin 3) k →ₐ[k] _)
          (residualLinearFormOn (P * M) (N * Q) G) := by
  have hQP : Q * P = 1 := mul_eq_one_comm.mp hPQ
  simp only [residualLinearFormOn, aeval_linearSubst_comp]
  rw [Matrix.mul_assoc N Q P, hQP, mul_one]

/-- A common invertible change of projective coordinates preserves a common residual-line map. -/
theorem hasCommonResidualLineMap_aeval_linearSubst {ι : Type v}
    (f : ι → MvPolynomial (Fin 3) k) (P Q : Matrix (Fin 3) (Fin 3) k)
    (hPQ : P * Q = 1) (hcommon : HasCommonResidualLineMap f) :
    HasCommonResidualLineMap
      (fun i => (aeval (linearSubst 2 P) : MvPolynomial (Fin 3) k →ₐ[k] _) (f i)) := by
  intro M N hMN
  have htransport : (P * M) * (N * Q) = 1 := by
    calc
      (P * M) * (N * Q) = P * ((M * N) * Q) := by simp only [Matrix.mul_assoc]
      _ = 1 := by rw [hMN, one_mul, hPQ]
  obtain ⟨ell, hell⟩ := hcommon (P * M) (N * Q) htransport
  refine ⟨(aeval (linearSubst 2 P) : MvPolynomial (Fin 3) k →ₐ[k] _) ell, fun i => ?_⟩
  obtain ⟨a, ha⟩ := hell i
  refine ⟨a, ?_⟩
  rw [residualLinearFormOn_aeval_linearSubst P Q M N hPQ, ha, map_mul]
  simp [MvPolynomial.algebraMap_eq]

/-- Base-point-freeness is invariant under an invertible coordinate change. -/
theorem residualLineMapBasepointFree_aeval_linearSubst
    (G : MvPolynomial (Fin 3) k) (P Q : Matrix (Fin 3) (Fin 3) k)
    (hPQ : P * Q = 1) (hbpf : ResidualLineMapBasepointFree G) :
    ResidualLineMapBasepointFree
      ((aeval (linearSubst 2 P) : MvPolynomial (Fin 3) k →ₐ[k] _) G) := by
  intro M N hMN
  have htransport : (P * M) * (N * Q) = 1 := by
    calc
      (P * M) * (N * Q) = P * ((M * N) * Q) := by simp only [Matrix.mul_assoc]
      _ = 1 := by rw [hMN, one_mul, hPQ]
  rw [residualLinearFormOn_aeval_linearSubst P Q M N hPQ]
  intro hzero
  have hzero' := congrArg
    (aeval (linearSubst 2 Q) : MvPolynomial (Fin 3) k →ₐ[k] _) hzero
  rw [map_zero, aeval_linearSubst_comp, hPQ] at hzero'
  apply hbpf (P * M) (N * Q) htransport
  simpa [aeval_X_left_apply] using hzero'

end

end BConicBundleMultisections.Standard
