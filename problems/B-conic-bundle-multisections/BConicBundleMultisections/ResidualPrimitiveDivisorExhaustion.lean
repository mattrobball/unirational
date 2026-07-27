/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import BConicBundleMultisections.PlaneCubicResidualTransport
public import BConicBundleMultisections.ProjectiveCommonZero
public import BConicBundleMultisections.ResidualPrimitiveEquation

/-!
# Conditional horizontality from exhaustion of the primitive residual divisor

The source conditions that the generic line section be reduced and that tangent residual be
injective on its three points are not yet represented by Lean objects in this project.  Their
scheme-theoretic consequence, after excluding vertical components, is that the chosen residual
component exhausts the primitive complete intersection `V(F,q)`.

This file isolates the smallest closed-point relation interface needed from that geometry.
`ResidualPrimitiveDivisorExhaustedOn` says that every target-coordinate polynomial relation on the
explicit residual parametrization also vanishes at every genuine biprojective point of `V(F,q)`.
It is the pointwise relation-kernel consequence of equality between the component and the
primitive divisor; unlike literal surjectivity of the affine parametrization, it correctly allows
the parametrization to cover only a dense open subset of its scheme-theoretic image.

If `q` has bidegree `(a,1)` with `a>0`, two positive-degree forms `F_y` and `q_y` in three
first-block variables have a common nonzero zero for every projective `y`.  The exhaustion
interface then makes every homogeneous relation vanish at every `y`, hence vanish identically.
No Picard or divisor-class axiom is used here.

`SourceFaithfulGoodLineOn` packages this exhaustion with an invertible line frame, the moving-line
condition, and a genuinely bihomogeneous primitive factorization.  It is deliberately separate
from `exists_good_line`: the
current good-line theorem proves only movement of the residual line, not the source's reducedness
and point-injectivity conditions or the Picard argument excluding vertical components.
-/

@[expose] public section

namespace BConicBundleMultisections

noncomputable section

universe u

open MvPolynomial ResidualDivisor
open _root_.MvPolynomial

/-- Closed-point relation containment expressing that the explicit residual image exhausts the
primitive complete intersection.

This is weaker than asking the affine parametrization to hit every closed point: relations vanish
on the closure of its image.  It is exactly the interface supplied by equality of that
scheme-theoretic image with `V(F,q)`. -/
def ResidualPrimitiveDivisorExhaustedOn
    {K : Type u} [Field K]
    (p₀ q₀ r : Fin 3 → K) (N : Matrix (Fin 3) (Fin 3) K)
    (F q : MvPolynomial (BiprojectiveCoordinate 2 2) K)
    (v : Fin 3 → Polynomial K) : Prop :=
  ∀ Ψ : MvPolynomial (Fin 3) K,
    aeval (residualYCoordsOn p₀ q₀ r N F v) Ψ = 0 →
      ∀ (x y : Fin 3 → K), x ≠ 0 → y ≠ 0 →
        eval (Sum.elim x y) F = 0 → eval (Sum.elim x y) q = 0 → eval y Ψ = 0

/-- A strengthened, source-faithful good-line/parametrization package at the exact algebraic
interface used by the primitive-divisor proof.

The last conjunct is where reduced generic line section, injectivity of tangent residual on its
three points, and exclusion of vertical components must eventually enter. -/
def SourceFaithfulGoodLineOn
    {K : Type u} [Field K]
    (p₀ q₀ r : Fin 3 → K) (N : Matrix (Fin 3) (Fin 3) K)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) K)
    (v : Fin 3 → Polynomial K) : Prop :=
  lineFrame p₀ q₀ r * N = 1 ∧
    ResidualLineNonconstantOn (lineFrame p₀ q₀ r) N F ∧
      ∃ (e a : ℕ) (B q : MvPolynomial (BiprojectiveCoordinate 2 2) K),
      IsBihomogeneousOfBidegree e 0 B ∧
        IsBihomogeneousOfBidegree a 1 q ∧
        0 < a ∧ q ≠ 0 ∧ IsPrimitiveOverFirstBlock q ∧
        residualEquationOn (lineFrame p₀ q₀ r) N F = B * q ∧
        ResidualPrimitiveDivisorExhaustedOn p₀ q₀ r N F q v

/-- If every target relation on the explicit residual image also vanishes on the primitive
complete intersection, positive first degree forces that relation to be zero. -/
theorem eq_zero_of_aeval_residualYCoordsOn_of_primitiveDivisorExhausted
    {K : Type u} [Field K] [IsAlgClosed K]
    (p₀ q₀ r : Fin 3 → K) (N : Matrix (Fin 3) (Fin 3) K)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) K) (hF : IsBidegree23 F)
    (v : Fin 3 → Polynomial K)
    {a : ℕ} {q : MvPolynomial (BiprojectiveCoordinate 2 2) K}
    (hq : IsBihomogeneousOfBidegree a 1 q) (ha : 0 < a)
    (hexhaust : ResidualPrimitiveDivisorExhaustedOn p₀ q₀ r N F q v)
    (d : ℕ) (Ψ : MvPolynomial (Fin 3) K) (hΨ : Ψ.IsHomogeneous d)
    (hvan : aeval (residualYCoordsOn p₀ q₀ r N F v) Ψ = 0) :
    Ψ = 0 := by
  rcases Nat.eq_zero_or_pos d with rfl | hd
  · rw [← totalDegree_zero_iff_isHomogeneous, totalDegree_eq_zero_iff_eq_C] at hΨ
    rw [hΨ] at hvan ⊢
    simpa using hvan
  · apply hΨ.eq_zero_of_forall_eval_eq_zero
    intro y
    by_cases hy : y = 0
    · subst y
      rw [eval_zero, constantCoeff_eq]
      exact hΨ.coeff_eq_zero (by simpa using hd.ne)
    · have hFy : (specializeSecondCoordinates (m := 2) y F).IsHomogeneous 2 :=
        hF.specializeSecondCoordinates_isHomogeneous y
      have hqy : (specializeSecondCoordinates (m := 2) y q).IsHomogeneous a :=
        hq.specializeSecondCoordinates_isHomogeneous y
      obtain ⟨x, hx, hxF, hxq⟩ := exists_common_nonzero_zero_pair
        hFy hqy (by norm_num) ha (by simp)
      exact hexhaust Ψ hvan x y hx hy (by simpa using hxF) (by simpa using hxq)

/-- The strengthened good-line package supplies the conditional no-relation theorem. -/
theorem eq_zero_of_aeval_residualYCoordsOn_of_sourceFaithfulGoodLine
    {K : Type u} [Field K] [IsAlgClosed K]
    (p₀ q₀ r : Fin 3 → K) (N : Matrix (Fin 3) (Fin 3) K)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) K) (hF : IsBidegree23 F)
    (v : Fin 3 → Polynomial K)
    (hgood : SourceFaithfulGoodLineOn p₀ q₀ r N F v)
    (d : ℕ) (Ψ : MvPolynomial (Fin 3) K) (hΨ : Ψ.IsHomogeneous d)
    (hvan : aeval (residualYCoordsOn p₀ q₀ r N F v) Ψ = 0) :
    Ψ = 0 := by
  obtain ⟨_, a, _, q, _, hq, ha, _, _, _, hexhaust⟩ := hgood.2.2
  exact eq_zero_of_aeval_residualYCoordsOn_of_primitiveDivisorExhausted
    p₀ q₀ r N F hF v hq ha hexhaust d Ψ hΨ hvan

end

end BConicBundleMultisections
