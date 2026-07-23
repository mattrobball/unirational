/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import BConicBundleMultisections.BinaryCubicResidual

/-!
# Projective residual points of binary cubics

This file turns the residual linear factor of a nonzero binary cubic with double contact at
`[1 : 0]` into the explicit nonzero representative `[-d,c]`. It then maps that representative
into an ambient vector space along the line `(s,t) ↦ s • p + t • q`.

The uniform map from the binary projective line into the ambient projective space requires the
endpoint vectors `p,q` to be linearly independent. The direct tangent-contact specialization
also retains the hypothesis that the binary line restriction is nonzero. This is necessary:
a nonzero ambient polynomial can vanish identically after restriction to a particular line.
-/

@[expose] public section

open MvPolynomial
open scoped LinearAlgebra.Projectivization

namespace BConicBundleMultisections

noncomputable section

universe u v

variable {K : Type u} [Field K]

/-- The coefficient of `X₀ X₁²` in the residual factor of a binary cubic. -/
def binaryCubicResidualFirstCoefficient (f : MvPolynomial (Fin 2) K) : K :=
  coeff (binaryExponent 1 2) f

/-- The coefficient of `X₁³` in the residual factor of a binary cubic. -/
def binaryCubicResidualSecondCoefficient (f : MvPolynomial (Fin 2) K) : K :=
  coeff (binaryExponent 0 3) f

/-- The binary representative `[-d,c]` cut out by the residual linear form `c X₀ + d X₁`. -/
def binaryCubicResidualPointRepresentative (f : MvPolynomial (Fin 2) K) : Fin 2 → K :=
  ![-binaryCubicResidualSecondCoefficient f, binaryCubicResidualFirstCoefficient f]

@[simp]
theorem binaryCubicResidualPointRepresentative_zero (f : MvPolynomial (Fin 2) K) :
    binaryCubicResidualPointRepresentative f 0 = -binaryCubicResidualSecondCoefficient f := by
  simp [binaryCubicResidualPointRepresentative]

@[simp]
theorem binaryCubicResidualPointRepresentative_one (f : MvPolynomial (Fin 2) K) :
    binaryCubicResidualPointRepresentative f 1 = binaryCubicResidualFirstCoefficient f := by
  simp [binaryCubicResidualPointRepresentative]

/-- The residual linear form vanishes at its canonical representative `[-d,c]`. -/
theorem eval_binaryCubicResidualLinearForm_residualPointRepresentative
    (f : MvPolynomial (Fin 2) K) :
    eval (binaryCubicResidualPointRepresentative f) (binaryCubicResidualLinearForm f) = 0 := by
  simp [binaryCubicResidualPointRepresentative, binaryCubicResidualLinearForm,
    binaryCubicResidualFirstCoefficient, binaryCubicResidualSecondCoefficient]
  ring

/-- A nonzero homogeneous binary cubic with double contact at `[1 : 0]` has a nonzero
residual-point representative. -/
theorem binaryCubicResidualPointRepresentative_ne_zero
    (f : MvPolynomial (Fin 2) K) (hf : f.IsHomogeneous 3) (hf0 : f ≠ 0)
    (hvalue : eval (binaryFirstEndpoint (R := K)) f = 0)
    (hderiv : eval (binaryFirstEndpoint (R := K)) (pderiv (1 : Fin 2) f) = 0) :
    binaryCubicResidualPointRepresentative f ≠ 0 := by
  intro hpoint
  have hc : binaryCubicResidualFirstCoefficient f = 0 := by
    have := congrFun hpoint (1 : Fin 2)
    simpa [binaryCubicResidualPointRepresentative] using this
  have hd : binaryCubicResidualSecondCoefficient f = 0 := by
    have := congrFun hpoint (0 : Fin 2)
    simpa [binaryCubicResidualPointRepresentative] using neg_eq_zero.mp this
  have hresidual : binaryCubicResidualLinearForm f = 0 := by
    rw [binaryCubicResidualLinearForm]
    change C (binaryCubicResidualFirstCoefficient f) * X 0 +
      C (binaryCubicResidualSecondCoefficient f) * X 1 = 0
    rw [hc, hd]
    simp
  apply hf0
  rw [binaryCubic_eq_X_one_sq_mul_of_endpoint_vanishing f hf hvalue hderiv,
    hresidual, mul_zero]

/-- The residual representative itself lies on the binary cubic. -/
theorem eval_binaryCubic_residualPointRepresentative
    (f : MvPolynomial (Fin 2) K) (hf : f.IsHomogeneous 3)
    (hvalue : eval (binaryFirstEndpoint (R := K)) f = 0)
    (hderiv : eval (binaryFirstEndpoint (R := K)) (pderiv (1 : Fin 2) f) = 0) :
    eval (binaryCubicResidualPointRepresentative f) f = 0 := by
  let x := binaryCubicResidualPointRepresentative f
  calc
    eval x f = eval x (X 1 ^ 2 * binaryCubicResidualLinearForm f) := by
      exact congrArg (eval x)
        (binaryCubic_eq_X_one_sq_mul_of_endpoint_vanishing f hf hvalue hderiv)
    _ = eval x (X 1 ^ 2) * eval x (binaryCubicResidualLinearForm f) := by
      exact map_mul (eval x) _ _
    _ = 0 := by
      rw [show eval x (binaryCubicResidualLinearForm f) = 0 by
        exact eval_binaryCubicResidualLinearForm_residualPointRepresentative f, mul_zero]

/-- The projective residual point of a nonzero binary cubic with double contact at `[1 : 0]`. -/
def binaryCubicResidualProjectivePoint
    (f : MvPolynomial (Fin 2) K) (hf : f.IsHomogeneous 3) (hf0 : f ≠ 0)
    (hvalue : eval (binaryFirstEndpoint (R := K)) f = 0)
    (hderiv : eval (binaryFirstEndpoint (R := K)) (pderiv (1 : Fin 2) f) = 0) :
    ℙ K (Fin 2 → K) :=
  Projectivization.mk K (binaryCubicResidualPointRepresentative f)
    (binaryCubicResidualPointRepresentative_ne_zero f hf hf0 hvalue hderiv)

variable {V : Type v} [AddCommGroup V] [Module K V]

/-- The linear map `(s,t) ↦ s • p + t • q`. -/
def binarySpanLinearMap (p q : V) : (Fin 2 → K) →ₗ[K] V :=
  Fintype.linearCombination K ![p, q]

@[simp]
theorem binarySpanLinearMap_apply (p q : V) (x : Fin 2 → K) :
    binarySpanLinearMap p q x = x 0 • p + x 1 • q := by
  simp [binarySpanLinearMap, Fintype.linearCombination_apply, Fin.sum_univ_two]

/-- The binary span map is injective when its two endpoint vectors are linearly independent. -/
theorem binarySpanLinearMap_injective {p q : V} (hpq : LinearIndependent K ![p, q]) :
    Function.Injective (binarySpanLinearMap (K := K) p q) := by
  exact hpq.fintypeLinearCombination_injective

/-- The projective-line embedding determined by two linearly independent ambient vectors. -/
def binarySpanProjectiveMap (p q : V) (hpq : LinearIndependent K ![p, q]) :
    ℙ K (Fin 2 → K) → ℙ K V :=
  Projectivization.map (binarySpanLinearMap (K := K) p q)
    (binarySpanLinearMap_injective hpq)

/-- Linear independence of the endpoints is exactly the natural hypothesis ensuring that the
binary span map does not collapse a nonzero representative. -/
theorem binarySpanLinearMap_ne_zero_of_linearIndependent
    {p q : V} (hpq : LinearIndependent K ![p, q]) {x : Fin 2 → K} (hx : x ≠ 0) :
    binarySpanLinearMap (K := K) p q x ≠ 0 := by
  exact map_zero (binarySpanLinearMap (K := K) p q) ▸
    (binarySpanLinearMap_injective hpq).ne hx

/-- Projectivizing the binary span map sends a representative to the same ambient linear
combination. -/
theorem binarySpanProjectiveMap_mk (p q : V) (hpq : LinearIndependent K ![p, q])
    (x : Fin 2 → K) (hx : x ≠ 0) :
    binarySpanProjectiveMap p q hpq (Projectivization.mk K x hx) =
      Projectivization.mk K (binarySpanLinearMap (K := K) p q x)
        (binarySpanLinearMap_ne_zero_of_linearIndependent hpq hx) := by
  apply Projectivization.map_mk

/-- Mapping the binary residual representative into a line with linearly independent endpoints
produces a nonzero ambient representative. -/
theorem binarySpanLinearMap_residualPointRepresentative_ne_zero
    {p q : V} (hpq : LinearIndependent K ![p, q])
    (f : MvPolynomial (Fin 2) K) (hf : f.IsHomogeneous 3) (hf0 : f ≠ 0)
    (hvalue : eval (binaryFirstEndpoint (R := K)) f = 0)
    (hderiv : eval (binaryFirstEndpoint (R := K)) (pderiv (1 : Fin 2) f) = 0) :
    binarySpanLinearMap (K := K) p q (binaryCubicResidualPointRepresentative f) ≠ 0 :=
  binarySpanLinearMap_ne_zero_of_linearIndependent hpq
    (binaryCubicResidualPointRepresentative_ne_zero f hf hf0 hvalue hderiv)

variable {σ : Type*}

/-- Evaluating at the ambient image of a binary representative agrees with evaluating the
binary line restriction at that representative. -/
theorem eval_binarySpanLinearMap_eq_eval_binaryLineRestriction
    (F : MvPolynomial σ K) (p q : σ → K) (x : Fin 2 → K) :
    eval (binarySpanLinearMap (K := K) p q x) F =
      eval x (binaryLineRestriction p q F) := by
  rw [eval_binaryLineRestriction]
  apply congrArg (fun y : σ → K ↦ eval y F)
  funext i
  simp [binarySpanLinearMap_apply, mul_comm]

/-- The mapped residual representative of a double-contact line restriction lies on the
original ambient hypersurface. -/
theorem eval_binarySpanLinearMap_residualPointRepresentative
    (F : MvPolynomial σ K) (hF : F.IsHomogeneous 3) (p q : σ → K)
    (hvalue : eval (binaryFirstEndpoint (R := K)) (binaryLineRestriction p q F) = 0)
    (hderiv : eval (binaryFirstEndpoint (R := K))
      (pderiv (1 : Fin 2) (binaryLineRestriction p q F)) = 0) :
    eval (binarySpanLinearMap (K := K) p q
      (binaryCubicResidualPointRepresentative (binaryLineRestriction p q F))) F = 0 := by
  rw [eval_binarySpanLinearMap_eq_eval_binaryLineRestriction]
  exact eval_binaryCubic_residualPointRepresentative (binaryLineRestriction p q F)
    (binaryLineRestriction_isHomogeneous hF p q) hvalue hderiv

variable [Fintype σ]

/-- The ambient representative obtained by mapping the residual binary representative along
the line `(s,t) ↦ s • p + t • q`. -/
def tangentResidualPointRepresentative
    (F : MvPolynomial σ K) (p q : σ → K) : σ → K :=
  binarySpanLinearMap (K := K) p q
    (binaryCubicResidualPointRepresentative (binaryLineRestriction p q F))

/-- The tangent-residual representative is nonzero when the line endpoints are linearly
independent and the binary restriction is nonzero. The latter hypothesis is essential:
a nonzero ambient cubic may restrict identically to zero on a line. -/
theorem tangentResidualPointRepresentative_ne_zero
    (F : MvPolynomial σ K) (hF : F.IsHomogeneous 3) (p q : σ → K)
    (hpq : LinearIndependent K ![p, q]) (hp : eval p F = 0)
    (hq : q ∈ tangentHyperplaneCone F p) (hrestriction : binaryLineRestriction p q F ≠ 0) :
    tangentResidualPointRepresentative F p q ≠ 0 := by
  have hcontact := binaryLineRestriction_double_contact_first F p q hp hq
  exact binarySpanLinearMap_residualPointRepresentative_ne_zero hpq
    (binaryLineRestriction p q F) (binaryLineRestriction_isHomogeneous hF p q)
    hrestriction hcontact.1 hcontact.2

/-- The ambient projective tangent-residual point. It is the image of the binary residual point
under the projective embedding induced by `(s,t) ↦ s • p + t • q`.

The nonzero-restriction hypothesis is retained explicitly because ambient nonvanishing alone
does not prevent a polynomial from vanishing identically on the chosen line. -/
def tangentResidualProjectivePoint
    (F : MvPolynomial σ K) (hF : F.IsHomogeneous 3) (p q : σ → K)
    (hpq : LinearIndependent K ![p, q]) (hp : eval p F = 0)
    (hq : q ∈ tangentHyperplaneCone F p) (hrestriction : binaryLineRestriction p q F ≠ 0) :
    ℙ K (σ → K) :=
  binarySpanProjectiveMap p q hpq
    (binaryCubicResidualProjectivePoint (binaryLineRestriction p q F)
      (binaryLineRestriction_isHomogeneous hF p q) hrestriction
      (binaryLineRestriction_double_contact_first F p q hp hq).1
      (binaryLineRestriction_double_contact_first F p q hp hq).2)

/-- The projective tangent-residual point is represented by
`tangentResidualPointRepresentative`. -/
theorem tangentResidualProjectivePoint_eq_mk
    (F : MvPolynomial σ K) (hF : F.IsHomogeneous 3) (p q : σ → K)
    (hpq : LinearIndependent K ![p, q]) (hp : eval p F = 0)
    (hq : q ∈ tangentHyperplaneCone F p) (hrestriction : binaryLineRestriction p q F ≠ 0) :
    tangentResidualProjectivePoint F hF p q hpq hp hq hrestriction =
      Projectivization.mk K (tangentResidualPointRepresentative F p q)
        (tangentResidualPointRepresentative_ne_zero F hF p q hpq hp hq hrestriction) := by
  apply binarySpanProjectiveMap_mk

/-- The mapped tangent-residual representative lies on the original cubic. -/
theorem eval_tangentResidualPointRepresentative
    (F : MvPolynomial σ K) (hF : F.IsHomogeneous 3) (p q : σ → K)
    (hp : eval p F = 0) (hq : q ∈ tangentHyperplaneCone F p) :
    eval (tangentResidualPointRepresentative F p q) F = 0 := by
  have hcontact := binaryLineRestriction_double_contact_first F p q hp hq
  exact eval_binarySpanLinearMap_residualPointRepresentative F hF p q
    hcontact.1 hcontact.2

end

end BConicBundleMultisections
