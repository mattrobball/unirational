/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import BConicBundleMultisections.Standard.ResidualLineMapDefinitions
public import BConicBundleMultisections.HesseNormalFormBridge
public import BConicBundleMultisections.HesseResidualMapBridge
public import Mathlib.FieldTheory.IsAlgClosed.Basic

/-!
# The residual-line map of a smooth plane cubic, and what it determines

This module proves the pencil form of residual-line-map rigidity.  The definitions and elementary
coordinate-change lemmas live in `Standard/ResidualLineMapDefinitions.lean`; the proof here is
axiom-clean and contains no borrowed theorem.

## The object

For a smooth plane cubic `C = {f = 0}` over a field of characteristic zero, a line `L` cuts
`L · C = p + q + r`, and the three tangent-residual points `g(p), g(q), g(r)` (where
`T_pC · C = 2p + g(p)`) are again collinear.  The resulting

```
δ_C : (ℙ²)^∨ → (ℙ²)^∨,    L ↦ ⟨g(p) g(q) g(r)⟩
```

is `certificates/all_smooth_tangent_residual_theorem.md` (2.1): the degree-four Lattès map of `C`.
In this development `δ_C(L)` is the linear form `residualLinearFormOn M N f`, where `M` is a frame
of `L` (`lineFrame`, columns the spanning vectors) and `N` its inverse; the point of `(ℙ²)^∨` is the
coefficient vector of that form.

## Checked proof strategy

The source recovers the cubic from the critical-value sextic of `δ_C`.  The formal proof uses a
finite algebraic route instead:

1. `HesseNormalForm.exists_hesseNormalForm_coordinates` carries one smooth member to a nonzero
   scalar multiple of `U³ + V³ + W³ - 3λUVW`, with `λ³ ≠ 1`.
2. Coordinate and scalar equivariance carry the whole family and its common residual-line map into
   those coordinates, normalizing the chosen member to the exact Hesse cubic.
3. `HesseResidualMapBridge` evaluates the residual line on the affine dual frames
   `W = sU + tV` and turns projective equality into two quartic cross-product identities plus a
   nonzero value at `(s,t) = (0,0)`.
4. `HesseProjectiveResidualRigidity` replays an exact finite interpolation and Groebner certificate,
   forcing all ten coefficients to be a scalar multiple of the Hesse coefficients.

The internal conclusion is stronger than the public pencil statement: after the common coordinate
change every family member is a scalar multiple of the same Hesse cubic.  The theorem retains the
pencil-shaped interface because that is exactly what `GoodLineExistence.lean` consumes.

## The base-point-freeness hypothesis is not decoration

`HasCommonResidualLineMap` is a condition on *values*, and the zero vector is a legal value of a
coefficient vector even though it is not a point of `(ℙ²)^∨`.  Without
`ResidualLineMapBasepointFree` the hypothesis is satisfied by any family one of whose members has
`δ ≡ 0`, and the conclusion is then false.

Note that the *weak* form — "some line has nonzero residual coefficient vector" — would **not** be
enough: what the proof consumes is that `δ_{f i}` and `δ_{f j}` agree as morphisms, and a single
nondegenerate line does not give that.  The hypothesis below is therefore the all-lines form.

It is not an assumption of the development:
`ResidualLineBasePointFree.residualLinearFormOn_ne_zero_of_nonsingular` proves it (over an
algebraically closed field, with no hypothesis on the characteristic), and
`GoodLineExistence.residualLineMapBasepointFree_of_isSmoothPlaneCubic` discharges it in the exact
shape used here.
-/

@[expose] public section

namespace BConicBundleMultisections.Standard

noncomputable section

universe u v

open MvPolynomial
open _root_.MvPolynomial

variable {k : Type u} [Field k]

/-! ### Lemma 2.1, in its pencil form -/

/--
**Lemma 2.1 (pencil form): smooth plane cubics with a common residual-line map lie in a pencil.**

*What it says.*  If every member of a family of smooth plane cubics over an algebraically closed
field of characteristic zero has the same residual-line map `δ`, then the whole family lies in a
single pencil `⟨f₀, f₁⟩` of cubic forms.

*Why it is true.*  Normalize one member to smooth Hesse form, transport and normalize the whole
family, and compare the three affine residual coordinates projectively.  The exact finite
certificate in `HesseProjectiveResidualRigidity` forces each normalized cubic to be a scalar
multiple of the chosen Hesse cubic.  Applying the inverse coordinate change gives the displayed
pencil (with the second generator equal to zero).

Source: `certificates/all_smooth_tangent_residual_theorem.md` §2, Lemma 2.1, consumed in §3.

*Hypotheses.*  Characteristic zero and algebraic closure are used by the checked Hesse normal-form
theorem and by finite polynomial interpolation.  `hbpf` is essential and not decoration — see the
module docstring.  The index type is arbitrary; the empty family is handled separately.
-/
theorem exists_pencil_of_hasCommonResidualLineMap
    [IsAlgClosed k] [NeZero (2 : k)] [NeZero (3 : k)] {ι : Type v} (f : ι → MvPolynomial (Fin 3) k)
    (hsmooth : ∀ i, IsSmoothPlaneCubic (f i))
    (hbpf : ∀ i, ResidualLineMapBasepointFree (f i))
    (hcommon : HasCommonResidualLineMap f) :
    ∃ f₀ f₁ : MvPolynomial (Fin 3) k,
      f₀.IsHomogeneous 3 ∧ f₁.IsHomogeneous 3 ∧
        ∀ i : ι, ∃ a b : k, f i = C a * f₀ + C b * f₁ :=
by
  classical
  by_cases hι : Nonempty ι
  · let i₀ : ι := Classical.choice hι
    obtain ⟨lam, c, M, N, hlam, hc, hMN, _hNM, hnormal⟩ :=
      HesseNormalForm.exists_hesseNormalForm_coordinates (f i₀) (hsmooth i₀)
    let T : ι → MvPolynomial (Fin 3) k := fun i =>
      (aeval (linearSubst 2 M) : MvPolynomial (Fin 3) k →ₐ[k] _) (f i)
    let g : ι → MvPolynomial (Fin 3) k := fun i => C c⁻¹ * T i
    have hcInv : c⁻¹ ≠ 0 := inv_ne_zero hc
    have hTHom : ∀ i, (T i).IsHomogeneous 3 := by
      intro i
      exact isHomogeneous_aeval_linearSubst M (hsmooth i).1
    have hgHom : ∀ i, (g i).IsHomogeneous 3 := by
      intro i
      dsimp only [g]
      simpa using (isHomogeneous_C (Fin 3) c⁻¹).mul (hTHom i)
    have hTcommon : HasCommonResidualLineMap T := by
      exact hasCommonResidualLineMap_aeval_linearSubst f M N hMN hcommon
    have hgcommon : HasCommonResidualLineMap g := by
      exact HesseResidualMapBridge.hasCommonResidualLineMap_C_mul T c⁻¹ hTcommon
    have hTbpf : ∀ i, ResidualLineMapBasepointFree (T i) := by
      intro i
      exact residualLineMapBasepointFree_aeval_linearSubst (f i) M N hMN (hbpf i)
    have hgbpf : ∀ i, ResidualLineMapBasepointFree (g i) := by
      intro i
      exact HesseResidualMapBridge.residualLineMapBasepointFree_C_mul
        (T i) c⁻¹ hcInv (hTbpf i)
    have hgi₀ : g i₀ = HesseNormalForm.hesseCubic lam := by
      dsimp only [g, T]
      rw [hnormal]
      rw [← mul_assoc, ← C_mul, inv_mul_cancel₀ hc, C_1, one_mul]
    let f₀ : MvPolynomial (Fin 3) k :=
      (aeval (linearSubst 2 N) : MvPolynomial (Fin 3) k →ₐ[k] _)
        (HesseNormalForm.hesseCubic lam)
    refine ⟨f₀, 0, ?_, isHomogeneous_zero (Fin 3) k 3, ?_⟩
    · exact isHomogeneous_aeval_linearSubst N
        (HesseNormalForm.hesseCubic_isHomogeneous lam)
    · intro i
      let a : k := PlaneCubicResidual.coeffU3 (g i)
      have hgi : g i = C a * HesseNormalForm.hesseCubic lam :=
        HesseResidualMapBridge.eq_C_mul_hesse_of_hasCommonResidualLineMap
          g hgHom hgbpf hgcommon i₀ i lam hgi₀ hlam
      have hTi : T i = C (c * a) * HesseNormalForm.hesseCubic lam := by
        calc
          T i = C 1 * T i := by simp
          _ = C (c * c⁻¹) * T i := by rw [mul_inv_cancel₀ hc]
          _ = C c * (C c⁻¹ * T i) := by rw [← mul_assoc, ← C_mul]
          _ = C c * (C a * HesseNormalForm.hesseCubic lam) := by
            rw [← hgi]
          _ = C (c * a) * HesseNormalForm.hesseCubic lam := by
            rw [← mul_assoc, ← C_mul]
      have hback := congrArg
        (aeval (linearSubst 2 N) : MvPolynomial (Fin 3) k →ₐ[k] _) hTi
      have hfi : f i = C (c * a) * f₀ := by
        have hbackT :
            (aeval (linearSubst 2 N) : MvPolynomial (Fin 3) k →ₐ[k] _) (T i) = f i := by
          dsimp only [T]
          rw [aeval_linearSubst_comp, hMN]
          simp
        rw [hbackT, map_mul, aeval_C] at hback
        simp only [MvPolynomial.algebraMap_eq] at hback
        exact hback
      refine ⟨c * a, 0, ?_⟩
      simpa using hfi
  · refine ⟨0, 0, isHomogeneous_zero (Fin 3) k 3,
      isHomogeneous_zero (Fin 3) k 3, ?_⟩
    intro i
    exact (hι ⟨i⟩).elim

end

end BConicBundleMultisections.Standard
