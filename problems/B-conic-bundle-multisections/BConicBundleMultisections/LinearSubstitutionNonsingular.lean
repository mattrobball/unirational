/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import BConicBundleMultisections.AlgebraicIndependenceJacobian
public import BConicBundleMultisections.ResidualLineBasePointFree

/-!
# An invertible linear substitution preserves nonsingularity

`certificates/all_smooth_tangent_residual_theorem.md` §3–§4 *chooses* the multisection line `L` and
only in §5 puts coordinates so that `L = {W = 0}`.  Carrying a plane cubic into that frame is the
linear substitution `aeval (linearSubst n M)` of `LinearSubstitution.lean`.  Every statement that
lives in the normalised frame therefore reaches a consumer as a statement about the *transported*
cubic, while what the consumer has in hand is smoothness of the original.  This module closes that
gap: for invertible `M`,

```
∀ r ≠ 0, eval r G = 0 → ∃ i, eval r (pderiv i G) ≠ 0
```

holds for `G` if and only if it holds for `aeval (linearSubst n M) G`.

## The argument

Substitution is precomposition with `x ↦ M *ᵥ x` (`eval_aeval_linearSubst`), and each substituted
variable is linear with `∂(linearSubst n M j)/∂X i = M j i` (`pderiv_linearSubst`).  So the
multivariate chain rule `pderiv_aeval` of `AlgebraicIndependenceJacobian.lean` specialises to

```
∇(G ∘ M)(r) = Mᵀ *ᵥ ∇G(M *ᵥ r) ,
```

`gradient_aeval_linearSubst` below — note the **transpose**: the chain rule contracts the second
index of `M` with the differentiation variable, so the matrix acting on gradients is `Mᵀ`, not `M`.
Both `M` and `Mᵀ` are invertible, and an invertible matrix kills no nonzero vector, so `r ↦ M *ᵥ r`
matches nonzero points with nonzero points and `∇G(M *ᵥ r) ≠ 0` iff `∇(G ∘ M)(r) ≠ 0`.  Nothing
beyond a commutative ring is used, and no hypothesis on the degree.

## What consumes it

`ResidualLineBasePointFree.lean` states its general-line results —
`residualLinearFormOn_ne_zero_of_nonsingular` and
`exists_residualLineCoeffOn_ne_zero_of_nonsingular_fibre` — with smoothness hypotheses on the cubic
*already carried into the frame of `L`*, because that is the form in which the normalised theorem
applies.  The last section here restates both with the hypothesis on the untransported cubic, which
is what a caller holding a smooth fibre of `F` actually has.
-/

@[expose] public section

namespace BConicBundleMultisections

noncomputable section

universe u

open MvPolynomial
open scoped Matrix

variable {R : Type u} [CommRing R]

/-! ### The chain rule for a linear substitution -/

/-- **The partial derivatives of a substituted variable are the matrix entries.**

`linearSubst n M j = ∑ l, M j l · X l` is linear, so `∂/∂X i` of it is the constant `M j i`. -/
@[simp]
theorem pderiv_linearSubst (n : ℕ) (M : Matrix (Fin (n + 1)) (Fin (n + 1)) R)
    (j i : Fin (n + 1)) : pderiv i (linearSubst n M j) = C (M j i) := by
  classical
  simp only [linearSubst, map_sum, pderiv_C_mul, pderiv_X, Pi.single_apply, mul_ite, mul_one,
    mul_zero]
  rw [Finset.sum_ite_eq' Finset.univ i fun l => C (M j l)]
  simp

/-- **The chain rule for a linear substitution.**

The general chain rule `pderiv_aeval` with `Y = linearSubst n M`: differentiating in `X i` picks out
the `i`-th column of `M`. -/
theorem pderiv_aeval_linearSubst (n : ℕ) (M : Matrix (Fin (n + 1)) (Fin (n + 1)) R)
    (G : MvPolynomial (Fin (n + 1)) R) (i : Fin (n + 1)) :
    pderiv i ((aeval (linearSubst n M) : MvPolynomial (Fin (n + 1)) R →ₐ[R] _) G)
      = ∑ a : Fin (n + 1),
          (aeval (linearSubst n M) : MvPolynomial (Fin (n + 1)) R →ₐ[R] _) (pderiv a G) *
            C (M a i) := by
  classical
  rw [pderiv_aeval (linearSubst n M) i G]
  exact Finset.sum_congr rfl fun a _ => by rw [pderiv_linearSubst]

/-- The value at `r` of the `i`-th partial of the substituted polynomial. -/
theorem eval_pderiv_aeval_linearSubst (n : ℕ) (M : Matrix (Fin (n + 1)) (Fin (n + 1)) R)
    (G : MvPolynomial (Fin (n + 1)) R) (r : Fin (n + 1) → R) (i : Fin (n + 1)) :
    eval r (pderiv i ((aeval (linearSubst n M) : MvPolynomial (Fin (n + 1)) R →ₐ[R] _) G))
      = ∑ a : Fin (n + 1), M a i * eval (M *ᵥ r) (pderiv a G) := by
  rw [pderiv_aeval_linearSubst, map_sum]
  refine Finset.sum_congr rfl fun a _ => ?_
  rw [map_mul, eval_C, eval_aeval_linearSubst, mul_comm]

/-- **The gradient transforms by the transpose.**

`∇(G ∘ M)(r) = Mᵀ *ᵥ ∇G(M *ᵥ r)`.  The transpose is forced: the chain rule contracts the
differentiation index of `M j i` — its *second* index — with the index of the gradient of the
substituted polynomial. -/
theorem gradient_aeval_linearSubst (n : ℕ) (M : Matrix (Fin (n + 1)) (Fin (n + 1)) R)
    (G : MvPolynomial (Fin (n + 1)) R) (r : Fin (n + 1) → R) :
    (fun i => eval r
        (pderiv i ((aeval (linearSubst n M) : MvPolynomial (Fin (n + 1)) R →ₐ[R] _) G)))
      = Mᵀ *ᵥ fun a => eval (M *ᵥ r) (pderiv a G) := by
  funext i
  rw [eval_pderiv_aeval_linearSubst]
  simp [Matrix.mulVec, dotProduct]

/-! ### Invertibility -/

/-- A matrix with a left inverse kills no nonzero vector. -/
theorem mulVec_ne_zero_of_left_inv {m : ℕ} {A B : Matrix (Fin m) (Fin m) R} (h : B * A = 1)
    {x : Fin m → R} (hx : x ≠ 0) : A *ᵥ x ≠ 0 := by
  intro h0
  refine hx ?_
  have hBA : B *ᵥ (A *ᵥ x) = 0 := by rw [h0, Matrix.mulVec_zero]
  rwa [Matrix.mulVec_mulVec, h, Matrix.one_mulVec] at hBA

/-- The transpose of an invertible matrix is invertible, with the transposed inverse. -/
theorem transpose_mul_transpose_eq_one {m : ℕ} {A B : Matrix (Fin m) (Fin m) R} (h : A * B = 1) :
    Bᵀ * Aᵀ = 1 := by
  rw [← Matrix.transpose_mul, h, Matrix.transpose_one]

/-! ### Transfer of nonsingularity

Nonsingularity in the form used throughout this development: no nonzero point of the hypersurface
annihilates every partial derivative. -/

/-- **An invertible linear substitution carries a nonsingular polynomial to a nonsingular one.** -/
theorem nonsingular_aeval_linearSubst_of_nonsingular
    (n : ℕ) (M N : Matrix (Fin (n + 1)) (Fin (n + 1)) R) (hMN : M * N = 1)
    (G : MvPolynomial (Fin (n + 1)) R)
    (hns : ∀ r : Fin (n + 1) → R, r ≠ 0 → eval r G = 0 →
      ∃ i : Fin (n + 1), eval r (pderiv i G) ≠ 0) :
    ∀ r : Fin (n + 1) → R, r ≠ 0 →
      eval r ((aeval (linearSubst n M) : MvPolynomial (Fin (n + 1)) R →ₐ[R] _) G) = 0 →
        ∃ i : Fin (n + 1),
          eval r (pderiv i
            ((aeval (linearSubst n M) : MvPolynomial (Fin (n + 1)) R →ₐ[R] _) G)) ≠ 0 := by
  classical
  intro r hr hG0
  have hNM : N * M = 1 := mul_eq_one_comm.mp hMN
  have hMr : M *ᵥ r ≠ 0 := mulVec_ne_zero_of_left_inv hNM hr
  rw [eval_aeval_linearSubst] at hG0
  obtain ⟨a, ha⟩ := hns _ hMr hG0
  set w : Fin (n + 1) → R := fun a => eval (M *ᵥ r) (pderiv a G) with hw
  have hw0 : w ≠ 0 := fun h => ha (by simpa [hw] using congrFun h a)
  have hMtw : Mᵀ *ᵥ w ≠ 0 :=
    mulVec_ne_zero_of_left_inv (transpose_mul_transpose_eq_one hMN) hw0
  have hgrad := gradient_aeval_linearSubst n M G r
  by_contra hcon
  refine hMtw (funext fun i => ?_)
  have hi := congrFun hgrad i
  have : eval r (pderiv i ((aeval (linearSubst n M) : MvPolynomial (Fin (n + 1)) R →ₐ[R] _) G))
      = 0 := by
    by_contra hne
    exact hcon ⟨i, hne⟩
  rw [← hi, this]
  rfl

/-- **Conversely**: if the substituted polynomial is nonsingular so is the original. -/
theorem nonsingular_of_nonsingular_aeval_linearSubst
    (n : ℕ) (M N : Matrix (Fin (n + 1)) (Fin (n + 1)) R) (hMN : M * N = 1)
    (G : MvPolynomial (Fin (n + 1)) R)
    (hns : ∀ r : Fin (n + 1) → R, r ≠ 0 →
      eval r ((aeval (linearSubst n M) : MvPolynomial (Fin (n + 1)) R →ₐ[R] _) G) = 0 →
        ∃ i : Fin (n + 1),
          eval r
            (pderiv i ((aeval (linearSubst n M) : MvPolynomial (Fin (n + 1)) R →ₐ[R] _) G)) ≠ 0) :
    ∀ r : Fin (n + 1) → R, r ≠ 0 → eval r G = 0 →
      ∃ i : Fin (n + 1), eval r (pderiv i G) ≠ 0 := by
  have hNM : N * M = 1 := mul_eq_one_comm.mp hMN
  have hcomp : (aeval (linearSubst n N) : MvPolynomial (Fin (n + 1)) R →ₐ[R] _)
      ((aeval (linearSubst n M) : MvPolynomial (Fin (n + 1)) R →ₐ[R] _) G) = G := by
    have hid : ((aeval (linearSubst n N) : MvPolynomial (Fin (n + 1)) R →ₐ[R] _).comp
        (aeval (linearSubst n M) : MvPolynomial (Fin (n + 1)) R →ₐ[R] _)) = AlgHom.id R _ := by
      refine MvPolynomial.algHom_ext fun i => ?_
      simp only [AlgHom.comp_apply, aeval_X, AlgHom.id_apply]
      rw [aeval_linearSubst_linearSubst, hMN, linearSubst_one]
    exact DFunLike.congr_fun hid G
  have h := nonsingular_aeval_linearSubst_of_nonsingular n N M hNM
    ((aeval (linearSubst n M) : MvPolynomial (Fin (n + 1)) R →ₐ[R] _) G) hns
  rwa [hcomp] at h

/-- **Nonsingularity is invariant under an invertible linear substitution.**

The statement is the one used throughout this development: a nonzero point of the hypersurface at
which every partial derivative vanishes.  `M` invertible is exactly what makes the two sides
equivalent — the gradient is multiplied by `Mᵀ` and the point by `M`. -/
theorem nonsingular_aeval_linearSubst_iff
    (n : ℕ) (M N : Matrix (Fin (n + 1)) (Fin (n + 1)) R) (hMN : M * N = 1)
    (G : MvPolynomial (Fin (n + 1)) R) :
    (∀ r : Fin (n + 1) → R, r ≠ 0 →
        eval r ((aeval (linearSubst n M) : MvPolynomial (Fin (n + 1)) R →ₐ[R] _) G) = 0 →
          ∃ i : Fin (n + 1),
            eval r
              (pderiv i ((aeval (linearSubst n M) : MvPolynomial (Fin (n + 1)) R →ₐ[R] _) G)) ≠ 0)
      ↔ (∀ r : Fin (n + 1) → R, r ≠ 0 → eval r G = 0 →
          ∃ i : Fin (n + 1), eval r (pderiv i G) ≠ 0) :=
  ⟨nonsingular_of_nonsingular_aeval_linearSubst n M N hMN G,
    nonsingular_aeval_linearSubst_of_nonsingular n M N hMN G⟩

/-! ### Consequences for the residual line

`ResidualLineBasePointFree.lean` states its general-line results with the smoothness hypothesis on
the cubic already carried into the frame of `L`.  These are the same statements with the hypothesis
on the cubic the caller actually holds. -/

section Residual

variable {K : Type u} [Field K] [IsAlgClosed K]

open PlaneCubicResidual ResidualDivisor

/-- **Base-point-freeness along an arbitrary line, from smoothness of the cubic itself.**

`residualLinearFormOn_ne_zero_of_nonsingular` with its hypotheses discharged from smoothness of
`G`, rather than of the cubic carried into the frame of `L`. -/
theorem residualLinearFormOn_ne_zero_of_nonsingular_source
    (M N : Matrix (Fin 3) (Fin 3) K) (hMN : M * N = 1) (G : MvPolynomial (Fin 3) K)
    (hG : G.IsHomogeneous 3)
    (hns : ∀ r : Fin 3 → K, r ≠ 0 → eval r G = 0 → ∃ i : Fin 3, eval r (pderiv i G) ≠ 0) :
    residualLinearFormOn M N G ≠ 0 :=
  residualLinearFormOn_ne_zero_of_nonsingular M N hMN G
    (isHomogeneous_aeval_linearSubst M hG)
    (nonsingular_aeval_linearSubst_of_nonsingular 2 M N hMN G hns)

/-- **The residual coefficient forms along an arbitrary line do not all vanish, as soon as one
cubic fibre is smooth** — the fibre of `F` itself, not of the substituted `F`.

This is the form condition **G3** of §3 needs: the caller has a smooth fibre of the family, and the
frame of `L` is a choice made afterwards. -/
theorem exists_residualLineCoeffOn_ne_zero_of_nonsingular_source_fibre
    (M N : Matrix (Fin 3) (Fin 3) K) (hMN : M * N = 1)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) K) (x : Fin 3 → K)
    (hG : (specializeFirstCoordinates (n := 2) x F).IsHomogeneous 3)
    (hns : ∀ r : Fin 3 → K, r ≠ 0 → eval r (specializeFirstCoordinates (n := 2) x F) = 0 →
      ∃ i : Fin 3, eval r (pderiv i (specializeFirstCoordinates (n := 2) x F)) ≠ 0) :
    ∃ a : Fin 3, residualLineCoeffOn M N F a ≠ 0 := by
  refine exists_residualLineCoeffOn_ne_zero_of_nonsingular_fibre M N hMN F x ?_ ?_ <;>
    rw [specializeFirstCoordinates_secondBlockSubst]
  · exact isHomogeneous_aeval_linearSubst M hG
  · exact nonsingular_aeval_linearSubst_of_nonsingular 2 M N hMN _ hns

end Residual

end

end BConicBundleMultisections
