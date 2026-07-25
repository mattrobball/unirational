/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import BConicBundleMultisections.PlaneCubicPartials
public import BConicBundleMultisections.PlaneCubicResidualEquivariance
public import BConicBundleMultisections.ResidualEquationLine
public import Mathlib.Algebra.MvPolynomial.Funext
public import Mathlib.Algebra.Polynomial.Degree.SmallDegree
public import Mathlib.FieldTheory.IsAlgClosed.Basic

/-!
# Base-point-freeness of the residual line of a smooth plane cubic

`certificates/all_smooth_tangent_residual_theorem.md` §2 builds the residual-line map
`δ_C : (ℙ²)^∨ → (ℙ²)^∨` of a smooth plane cubic `C` and calls it a *morphism* — the degree-four
Lattès map of `C`.  §5 writes its value at the coordinate line `L = {W = 0}` as

```
q_L(x, y) = q_U(x)·U + q_V(x)·V + q_W(x)·W .
```

That `δ_C` is a morphism, and not merely a rational map, is used silently: §5 divides out
`h = gcd(q_U, q_V, q_W)` and speaks of "the primitive residual equation", which presupposes that the
coefficient vector is not identically zero.  This file supplies the missing input in its sharpest
form: for a *single* smooth cubic the residual line is a genuine line, i.e. the linear form
`PlaneCubicResidual.residualLinearForm G` is nonzero
(`PlaneCubicResidual.residualLinearForm_ne_zero_of_nonsingular`), together with the two consequences
the development needs — the same along an arbitrary line
(`residualLinearFormOn_ne_zero_of_nonsingular`) and at the level of a bidegree-`(2,3)` family
(`exists_residualLineCoeff_ne_zero_of_nonsingular_fibre`,
`exists_residualLineCoeffOn_ne_zero_of_nonsingular_fibre`).

## Why this is the statement the development needs

`ResidualLineConstant` (`ResidualLineNonconstant.lean`) and `ResidualLineConstantOn`
(`ResidualEquationLine.lean`) both read

```
∃ g c, ∀ a, residualLineCoeff F a = C (c a) * g
```

and are therefore satisfied **vacuously** by `g = 0`, i.e. exactly when all three coefficient forms
vanish identically and the "residual line" is not a line at all.  Any argument that concludes
something geometric from constancy of `δ_C(L)` is unsound until that degenerate solution is
excluded.  The exclusion is a *fibrewise* fact: the three coefficient forms of the family cannot all
vanish as soon as **one** cubic fibre is smooth, because then the residual linear form of that one
cubic is nonzero.  So the object to be proved nonzero is `residualLinearForm G` for a smooth plane
cubic `G`, and that is `residualLinearForm_ne_zero_of_nonsingular` below.

## The proof

Everything rests on the universal identity of `UniversalResidualIdentity.lean`,

```
Res(g, P_p) + Δ(g) · G(p) = W_p² · q_G(p),        g = G|_L ,
```

where `P_p` is the polar quadric of `G` at `p` restricted to `L`.  Two observations turn a vanishing
`q_G` into a singular point of `G`.

* `Res(g, P_p)`, as a cubic form in `p`, is the product of the three **tangent lines** of `G` at the
  three points of `L ∩ C`.  Concretely: if `g = ∏ᵢ (sᵢ y₀ + tᵢ y₁)`, then the polar resultant equals
  `∏ᵢ Tᵢ(p)` with `Tᵢ` the linear form whose coefficient vector is `∇G(tᵢ, -sᵢ, 0)`.  This is the
  polynomial identity `polarRes32_of_split`, proved by `ring`.
* Hence `q_G = 0` forces `Δ(g) · G = -T₁T₂T₃`.  If some `Tᵢ` vanishes identically, the point
  `(tᵢ, -sᵢ, 0)` is a singular point of `G`; otherwise `Δ(g) ≠ 0` and `G` is a product of three
  linear forms, so any common zero of `T₁` and `T₂` is a singular point.

The remaining degenerate case `g = 0` is `L ⊂ C`: then `G = X₂ · Q` and any point of `L` on the
conic `Q` is singular.

No characteristic hypothesis is needed; only algebraic closure, which is used to split binary forms
into linear factors and to intersect a line with a conic.
-/

@[expose] public section

open MvPolynomial
open Finsupp

namespace BConicBundleMultisections
namespace PlaneCubicResidual

noncomputable section

variable {R : Type*} [CommRing R]

/-! ### Linear forms in three variables -/

/-- The linear form `c₀ X₀ + c₁ X₁ + c₂ X₂`. -/
def linearForm3 (c₀ c₁ c₂ : R) : MvPolynomial (Fin 3) R :=
  C c₀ * X 0 + C c₁ * X 1 + C c₂ * X 2

@[simp] theorem eval_linearForm3 (c₀ c₁ c₂ : R) (p : Fin 3 → R) :
    eval p (linearForm3 c₀ c₁ c₂) = c₀ * p 0 + c₁ * p 1 + c₂ * p 2 := by
  simp [linearForm3]

/-- A linear form vanishes exactly when its coefficient vector does. -/
theorem linearForm3_eq_zero_iff (c₀ c₁ c₂ : R) :
    linearForm3 c₀ c₁ c₂ = 0 ↔ c₀ = 0 ∧ c₁ = 0 ∧ c₂ = 0 := by
  constructor
  · intro h
    refine ⟨?_, ?_, ?_⟩
    · have := congrArg (coeff (single (0 : Fin 3) 1)) h
      simpa [linearForm3, coeff_C_mul, coeff_X, Finsupp.single_eq_single_iff] using this
    · have := congrArg (coeff (single (1 : Fin 3) 1)) h
      simpa [linearForm3, coeff_C_mul, coeff_X, Finsupp.single_eq_single_iff] using this
    · have := congrArg (coeff (single (2 : Fin 3) 1)) h
      simpa [linearForm3, coeff_C_mul, coeff_X, Finsupp.single_eq_single_iff] using this
  · rintro ⟨rfl, rfl, rfl⟩
    simp [linearForm3]

theorem coeff_linearForm3_zero (c₀ c₁ c₂ : R) :
    coeff (single (0 : Fin 3) 1) (linearForm3 c₀ c₁ c₂) = c₀ := by
  simp [linearForm3, coeff_C_mul, coeff_X, Finsupp.single_eq_single_iff]

theorem coeff_linearForm3_one (c₀ c₁ c₂ : R) :
    coeff (single (1 : Fin 3) 1) (linearForm3 c₀ c₁ c₂) = c₁ := by
  simp [linearForm3, coeff_C_mul, coeff_X, Finsupp.single_eq_single_iff]

theorem coeff_linearForm3_two (c₀ c₁ c₂ : R) :
    coeff (single (2 : Fin 3) 1) (linearForm3 c₀ c₁ c₂) = c₂ := by
  simp [linearForm3, coeff_C_mul, coeff_X, Finsupp.single_eq_single_iff]

/-- The residual linear form of §5 is the linear form on the three universal residual
coefficients. -/
theorem residualLinearForm_eq_linearForm3 (G : MvPolynomial (Fin 3) R) :
    residualLinearForm G =
      linearForm3
        (UniversalResidual.residualCoeffU (coeffU3 G) (coeffU2V G) (coeffUV2 G) (coeffV3 G)
          (coeffU2W G) (coeffUVW G) (coeffV2W G) (coeffUW2 G))
        (UniversalResidual.residualCoeffV (coeffU3 G) (coeffU2V G) (coeffUV2 G) (coeffV3 G)
          (coeffU2W G) (coeffUVW G) (coeffV2W G) (coeffVW2 G))
        (UniversalResidual.residualCoeffW (coeffU3 G) (coeffU2V G) (coeffUV2 G) (coeffV3 G)
          (coeffU2W G) (coeffUVW G) (coeffV2W G) (coeffW3 G)) :=
  rfl

/-- Vanishing of the residual line is vanishing of its three coefficients. -/
theorem residualLinearForm_eq_zero_iff (G : MvPolynomial (Fin 3) R) :
    residualLinearForm G = 0 ↔
      UniversalResidual.residualCoeffU (coeffU3 G) (coeffU2V G) (coeffUV2 G) (coeffV3 G)
          (coeffU2W G) (coeffUVW G) (coeffV2W G) (coeffUW2 G) = 0 ∧
        UniversalResidual.residualCoeffV (coeffU3 G) (coeffU2V G) (coeffUV2 G) (coeffV3 G)
            (coeffU2W G) (coeffUVW G) (coeffV2W G) (coeffVW2 G) = 0 ∧
          UniversalResidual.residualCoeffW (coeffU3 G) (coeffU2V G) (coeffUV2 G) (coeffV3 G)
            (coeffU2W G) (coeffUVW G) (coeffV2W G) (coeffW3 G) = 0 := by
  rw [residualLinearForm_eq_linearForm3, linearForm3_eq_zero_iff]

/-- **The residual line of the Fermat cubic `X₀³ + X₁³ + X₂³` is `-27·X₂`.**

Stated on the ten monomial coefficients, which for the Fermat cubic are `a = d = k = 1` and the rest
zero.  This is a witness that the residual coefficient forms are not identically zero, independently
of `residualLinearForm_ne_zero_of_nonsingular`; geometrically `L = {X₂ = 0}` meets the Fermat cubic
in three flexes, so the residual line is `L` itself. -/
theorem residualLinearForm_of_fermat_coeffs (G : MvPolynomial (Fin 3) R)
    (ha : coeffU3 G = 1) (hb : coeffU2V G = 0) (hc : coeffUV2 G = 0) (hd : coeffV3 G = 1)
    (he : coeffU2W G = 0) (hf : coeffUVW G = 0) (hg : coeffV2W G = 0)
    (hi : coeffUW2 G = 0) (hj : coeffVW2 G = 0) (hk : coeffW3 G = 1) :
    residualLinearForm G = linearForm3 0 0 (-27) := by
  rw [residualLinearForm_eq_linearForm3, ha, hb, hc, hd, he, hf, hg, hi, hj, hk]
  norm_num [UniversalResidual.residualCoeffU, UniversalResidual.residualCoeffV,
    UniversalResidual.residualCoeffW]

/-- The Fermat residual line is nonzero outside characteristic three, so the conclusion of
`residualLinearForm_ne_zero_of_nonsingular` is not vacuous. -/
theorem residualLinearForm_ne_zero_of_fermat_coeffs (G : MvPolynomial (Fin 3) R)
    (h27 : (27 : R) ≠ 0)
    (ha : coeffU3 G = 1) (hb : coeffU2V G = 0) (hc : coeffUV2 G = 0) (hd : coeffV3 G = 1)
    (he : coeffU2W G = 0) (hf : coeffUVW G = 0) (hg : coeffV2W G = 0)
    (hi : coeffUW2 G = 0) (hj : coeffVW2 G = 0) (hk : coeffW3 G = 1) :
    residualLinearForm G ≠ 0 := by
  rw [residualLinearForm_of_fermat_coeffs G ha hb hc hd he hf hg hi hj hk, Ne,
    linearForm3_eq_zero_iff]
  rintro ⟨-, -, h⟩
  exact h27 (neg_eq_zero.mp h)

/-! ### The polar resultant with free polar coefficients

`UniversalResidual.polarResultant` is the `(3,2)` resultant of the binary cubic `g = G|_L` against
the restriction `P_p|_L` of the polar quadric.  Keeping the three coefficients of `P_p|_L` as free
variables isolates the part of the formula that only sees `g`, which is what factors. -/

/-- The `(3,2)` resultant of the binary cubic `(a, b, c, d)` against the binary quadratic
`(pa, pb, pc)`, in Mathlib's Sylvester normalisation. -/
def polarRes32 (a b c d pa pb pc : R) : R :=
  pa ^ 3 * d ^ 2
    - pa ^ 2 * pb * c * d
    - 2 * pa ^ 2 * pc * b * d
    + pa ^ 2 * pc * c ^ 2
    + pa * pb ^ 2 * b * d
    + 3 * pa * pb * pc * a * d
    - pa * pb * pc * b * c
    - 2 * pa * pc ^ 2 * a * c
    + pa * pc ^ 2 * b ^ 2
    - pb ^ 3 * a * d
    + pb ^ 2 * pc * a * c
    - pb * pc ^ 2 * a * b
    + pc ^ 3 * a ^ 2

/-- `UniversalResidual.polarResultant` is `polarRes32` at the polar quadratic of the point. -/
theorem polarResultant_eq_polarRes32 (a b c d e f hh U V W : R) :
    UniversalResidual.polarResultant a b c d e f hh U V W =
      polarRes32 a b c d
        (UniversalResidual.polarQuadA a b e U V W)
        (UniversalResidual.polarQuadB b c f U V W)
        (UniversalResidual.polarQuadC c d hh U V W) :=
  rfl

/-- **The polar resultant splits into the three tangent lines.**

If the binary cubic `g = G|_L` factors as `∏ᵢ (sᵢ y₀ + tᵢ y₁)`, the `(3,2)` resultant against any
binary quadratic `(pa, pb, pc)` is the product of the three values of that quadratic at the roots
`(tᵢ, -sᵢ)`.  This is multiplicativity of the resultant in its first argument, here as a bare
polynomial identity so that no resultant API is needed. -/
theorem polarRes32_of_split (s₁ t₁ s₂ t₂ s₃ t₃ pa pb pc : R) :
    polarRes32 (s₁ * s₂ * s₃) (s₁ * s₂ * t₃ + s₁ * t₂ * s₃ + t₁ * s₂ * s₃)
        (s₁ * t₂ * t₃ + t₁ * s₂ * t₃ + t₁ * t₂ * s₃) (t₁ * t₂ * t₃) pa pb pc =
      (pa * t₁ ^ 2 - pb * (t₁ * s₁) + pc * s₁ ^ 2) *
        ((pa * t₂ ^ 2 - pb * (t₂ * s₂) + pc * s₂ ^ 2) *
          (pa * t₃ ^ 2 - pb * (t₃ * s₃) + pc * s₃ ^ 2)) := by
  simp only [polarRes32]
  ring

/-! ### The tangent line at a point of `L ∩ C` -/

/-- **The tangent line of `G` at the point `(t, -s, 0)`**, as a linear form.

Its coefficient vector is `∇G(t, -s, 0)`; see `lineTangentForm_eq`.  It is written here directly in
the ten monomial coefficients of `G` because that is the shape in which it comes out of the polar
resultant. -/
def lineTangentForm (G : MvPolynomial (Fin 3) R) (s t : R) : MvPolynomial (Fin 3) R :=
  linearForm3
    (3 * coeffU3 G * t ^ 2 - 2 * coeffU2V G * (t * s) + coeffUV2 G * s ^ 2)
    (coeffU2V G * t ^ 2 - 2 * coeffUV2 G * (t * s) + 3 * coeffV3 G * s ^ 2)
    (coeffU2W G * t ^ 2 - coeffUVW G * (t * s) + coeffV2W G * s ^ 2)

/-- Evaluating the tangent line is evaluating the polar quadratic at `(t, -s)`. -/
theorem eval_lineTangentForm (G : MvPolynomial (Fin 3) R) (s t : R) (p : Fin 3 → R) :
    eval p (lineTangentForm G s t) =
      UniversalResidual.polarQuadA (coeffU3 G) (coeffU2V G) (coeffU2W G) (p 0) (p 1) (p 2) * t ^ 2 -
        UniversalResidual.polarQuadB (coeffU2V G) (coeffUV2 G) (coeffUVW G)
            (p 0) (p 1) (p 2) * (t * s) +
        UniversalResidual.polarQuadC (coeffUV2 G) (coeffV3 G) (coeffV2W G)
            (p 0) (p 1) (p 2) * s ^ 2 := by
  simp only [lineTangentForm, eval_linearForm3, UniversalResidual.polarQuadA,
    UniversalResidual.polarQuadB, UniversalResidual.polarQuadC]
  ring

/-! ### The third partial of a plane cubic

`PlaneCubicPartials` has the first two; the third is needed to recognise the coefficient vector of
`lineTangentForm` as a gradient. -/

private theorem eval_monomial_single_pow' (a : R) (p : Fin 3 → R) (i : Fin 3) (n : ℕ) :
    eval p (monomial (single i n) a) = a * p i ^ n := by
  simp [eval_monomial]

private theorem eval_monomial_two' (a : R) (p : Fin 3 → R) (i j : Fin 3) (n m : ℕ) :
    eval p (monomial (single i n + single j m) a) = a * p i ^ n * p j ^ m := by
  classical
  rw [eval_monomial,
    prod_add_index' (fun x => pow_zero (p x)) (fun x n m => pow_add (p x) n m)]
  simp
  ring

/-- `∂G/∂W` of a homogeneous plane cubic at a general point. -/
theorem eval_pderiv2_planeCubic
    (G : MvPolynomial (Fin 3) R) (hG : G.IsHomogeneous 3) (q : Fin 3 → R) :
    eval q (pderiv 2 G) =
      coeffU2W G * q 0 ^ 2 + coeffUVW G * q 0 * q 1 + coeffV2W G * q 1 ^ 2 +
        q 2 * (2 * coeffUW2 G * q 0 + 2 * coeffVW2 G * q 1) + 3 * coeffW3 G * q 2 ^ 2 := by
  have hsum := planeCubic_eq_sum_monomials G hG
  conv_lhs => rw [hsum]
  simp only [map_add]
  have hU3 : eval q (pderiv 2 (monomial eU3 (coeffU3 G))) = 0 := by
    simp only [eU3, pderiv_monomial]
    have hcoe : (single (0 : Fin 3) 3 : Fin 3 →₀ ℕ) 2 = 0 := by simp
    rw [hcoe]; simp
  have hU2V : eval q (pderiv 2 (monomial eU2V (coeffU2V G))) = 0 := by
    simp only [eU2V, pderiv_monomial]
    have hcoe : (single (0 : Fin 3) 2 + single 1 1 : Fin 3 →₀ ℕ) 2 = 0 := by
      simp [Finsupp.add_apply]
    rw [hcoe]; simp
  have hUV2 : eval q (pderiv 2 (monomial eUV2 (coeffUV2 G))) = 0 := by
    simp only [eUV2, pderiv_monomial]
    have hcoe : (single (0 : Fin 3) 1 + single 1 2 : Fin 3 →₀ ℕ) 2 = 0 := by
      simp [Finsupp.add_apply]
    rw [hcoe]; simp
  have hV3 : eval q (pderiv 2 (monomial eV3 (coeffV3 G))) = 0 := by
    simp only [eV3, pderiv_monomial]
    have hcoe : (single (1 : Fin 3) 3 : Fin 3 →₀ ℕ) 2 = 0 := by simp
    rw [hcoe]; simp
  have hU2W : eval q (pderiv 2 (monomial eU2W (coeffU2W G))) = coeffU2W G * q 0 ^ 2 := by
    simp only [eU2W, pderiv_monomial]
    have hsub : single (0 : Fin 3) 2 + single 2 1 - single 2 1 = single 0 2 := by
      ext i; fin_cases i <;> simp
    have hcoe : (single (0 : Fin 3) 2 + single 2 1 : Fin 3 →₀ ℕ) 2 = 1 := by
      simp
    rw [hsub, hcoe, eval_monomial_single_pow']; ring
  have hUVW : eval q (pderiv 2 (monomial eUVW (coeffUVW G))) = coeffUVW G * q 0 * q 1 := by
    simp only [eUVW, pderiv_monomial]
    have hsub :
        single (0 : Fin 3) 1 + single 1 1 + single 2 1 - single 2 1 =
          single 0 1 + single 1 1 := by
      ext i; fin_cases i <;> simp [Finsupp.add_apply]
    have hcoe : (single (0 : Fin 3) 1 + single 1 1 + single 2 1 : Fin 3 →₀ ℕ) 2 = 1 := by
      simp [Finsupp.add_apply]
    rw [hsub, hcoe, eval_monomial_two']; ring
  have hV2W : eval q (pderiv 2 (monomial eV2W (coeffV2W G))) = coeffV2W G * q 1 ^ 2 := by
    simp only [eV2W, pderiv_monomial]
    have hsub : single (1 : Fin 3) 2 + single 2 1 - single 2 1 = single 1 2 := by
      ext i; fin_cases i <;> simp
    have hcoe : (single (1 : Fin 3) 2 + single 2 1 : Fin 3 →₀ ℕ) 2 = 1 := by
      simp
    rw [hsub, hcoe, eval_monomial_single_pow']; ring
  have hUW2 : eval q (pderiv 2 (monomial eUW2 (coeffUW2 G))) =
      2 * coeffUW2 G * q 0 * q 2 := by
    simp only [eUW2, pderiv_monomial]
    have hsub : single (0 : Fin 3) 1 + single 2 2 - single 2 1 =
        single 0 1 + single 2 1 := by
      ext i; fin_cases i <;> simp [Finsupp.add_apply]
    have hcoe : (single (0 : Fin 3) 1 + single 2 2 : Fin 3 →₀ ℕ) 2 = 2 := by
      simp [Finsupp.add_apply]
    rw [hsub, hcoe, eval_monomial_two']; ring
  have hVW2 : eval q (pderiv 2 (monomial eVW2 (coeffVW2 G))) =
      2 * coeffVW2 G * q 1 * q 2 := by
    simp only [eVW2, pderiv_monomial]
    have hsub : single (1 : Fin 3) 1 + single 2 2 - single 2 1 =
        single 1 1 + single 2 1 := by
      ext i; fin_cases i <;> simp [Finsupp.add_apply]
    have hcoe : (single (1 : Fin 3) 1 + single 2 2 : Fin 3 →₀ ℕ) 2 = 2 := by
      simp [Finsupp.add_apply]
    rw [hsub, hcoe, eval_monomial_two']; ring
  have hW3 : eval q (pderiv 2 (monomial eW3 (coeffW3 G))) = 3 * coeffW3 G * q 2 ^ 2 := by
    rw [show eW3 = single (2 : Fin 3) 3 from rfl, pderiv_monomial_single,
      eval_monomial_single_pow']
    ring
  simp only [hU3, hU2V, hUV2, hV3, hU2W, hUVW, hV2W, hUW2, hVW2, hW3]
  ring

/-- **The tangent line is the gradient at `(t, -s, 0)`.** -/
theorem lineTangentForm_eq (G : MvPolynomial (Fin 3) R) (hG : G.IsHomogeneous 3) (s t : R) :
    lineTangentForm G s t =
      linearForm3 (eval ![t, -s, 0] (pderiv 0 G)) (eval ![t, -s, 0] (pderiv 1 G))
        (eval ![t, -s, 0] (pderiv 2 G)) := by
  have h0 : eval (![t, -s, 0] : Fin 3 → R) (pderiv 0 G) =
      3 * coeffU3 G * t ^ 2 - 2 * coeffU2V G * (t * s) + coeffUV2 G * s ^ 2 := by
    rw [eval_pderiv0_planeCubic G hG]
    simp only [Matrix.cons_val_zero, Matrix.cons_val_one, Matrix.head_cons, Matrix.cons_val_two,
      Matrix.tail_cons]
    ring
  have h1 : eval (![t, -s, 0] : Fin 3 → R) (pderiv 1 G) =
      coeffU2V G * t ^ 2 - 2 * coeffUV2 G * (t * s) + 3 * coeffV3 G * s ^ 2 := by
    rw [eval_pderiv1_planeCubic G hG]
    simp only [Matrix.cons_val_zero, Matrix.cons_val_one, Matrix.head_cons, Matrix.cons_val_two,
      Matrix.tail_cons]
    ring
  have h2 : eval (![t, -s, 0] : Fin 3 → R) (pderiv 2 G) =
      coeffU2W G * t ^ 2 - coeffUVW G * (t * s) + coeffV2W G * s ^ 2 := by
    rw [eval_pderiv2_planeCubic G hG]
    simp only [Matrix.cons_val_zero, Matrix.cons_val_one, Matrix.head_cons, Matrix.cons_val_two,
      Matrix.tail_cons]
    ring
  rw [h0, h1, h2, lineTangentForm]

/-- The tangent line degenerates exactly at a singular point of `G` on `L`. -/
theorem lineTangentForm_eq_zero_iff (G : MvPolynomial (Fin 3) R) (hG : G.IsHomogeneous 3)
    (s t : R) :
    lineTangentForm G s t = 0 ↔ ∀ i : Fin 3, eval ![t, -s, 0] (pderiv i G) = 0 := by
  rw [lineTangentForm_eq G hG, linearForm3_eq_zero_iff]
  constructor
  · rintro ⟨h0, h1, h2⟩ i
    fin_cases i <;> assumption
  · intro h
    exact ⟨h 0, h 1, h 2⟩

/-- A product vanishing to first order: both factors vanishing at `p` kills every partial. -/
private theorem eval_pderiv_eq_zero_of_eq_mul {F₁ F₂ H : MvPolynomial (Fin 3) R}
    (h : H = F₁ * F₂) (p : Fin 3 → R) (h₁ : eval p F₁ = 0) (h₂ : eval p F₂ = 0) (i : Fin 3) :
    eval p (pderiv i H) = 0 := by
  subst h
  rw [pderiv_mul]
  simp [h₁, h₂]

/-! ### Splitting binary forms over an algebraically closed field -/

section AlgClosed

variable {K : Type*} [Field K] [IsAlgClosed K]

private theorem exists_root_quadratic (a b c : K) (ha : a ≠ 0) :
    ∃ r : K, a * r ^ 2 + b * r + c = 0 := by
  obtain ⟨r, hr⟩ := IsAlgClosed.exists_root
    (Polynomial.C a * Polynomial.X ^ 2 + Polynomial.C b * Polynomial.X + Polynomial.C c)
    (by rw [Polynomial.degree_quadratic ha]; decide)
  exact ⟨r, by simpa using hr⟩

private theorem exists_root_cubic (a b c d : K) (ha : a ≠ 0) :
    ∃ r : K, a * r ^ 3 + b * r ^ 2 + c * r + d = 0 := by
  obtain ⟨r, hr⟩ := IsAlgClosed.exists_root
    (Polynomial.C a * Polynomial.X ^ 3 + Polynomial.C b * Polynomial.X ^ 2 +
      Polynomial.C c * Polynomial.X + Polynomial.C d)
    (by rw [Polynomial.degree_cubic ha]; decide)
  exact ⟨r, by simpa using hr⟩

/-- **A nonzero binary quadratic form splits into two linear factors.**

Stated coefficientwise: `a y₀² + b y₀y₁ + c y₁² = (s₁y₀ + t₁y₁)(s₂y₀ + t₂y₁)`, with each factor
nonzero. -/
theorem exists_binaryQuadratic_split (a b c : K) (h : ¬(a = 0 ∧ b = 0 ∧ c = 0)) :
    ∃ s₁ t₁ s₂ t₂ : K, (s₁ ≠ 0 ∨ t₁ ≠ 0) ∧ (s₂ ≠ 0 ∨ t₂ ≠ 0) ∧
      a = s₁ * s₂ ∧ b = s₁ * t₂ + t₁ * s₂ ∧ c = t₁ * t₂ := by
  by_cases ha : a = 0
  · subst ha
    refine ⟨0, 1, b, c, Or.inr one_ne_zero, ?_, by ring, by ring, by ring⟩
    by_cases hb : b = 0
    · exact Or.inr fun hc => h ⟨rfl, hb, hc⟩
    · exact Or.inl hb
  · obtain ⟨r, hr⟩ := exists_root_quadratic a b c ha
    exact ⟨1, -r, a, b + a * r, Or.inl one_ne_zero, Or.inl ha, by ring, by ring,
      by linear_combination hr⟩

/-- **A nonzero binary cubic form splits into three linear factors.**

Stated coefficientwise: `a y₀³ + b y₀²y₁ + c y₀y₁² + d y₁³ = ∏ᵢ (sᵢ y₀ + tᵢ y₁)`, with each factor
nonzero.  This is the only place where algebraic closure enters the main theorem, apart from
intersecting a line with a conic. -/
theorem exists_binaryCubic_split (a b c d : K) (h : ¬(a = 0 ∧ b = 0 ∧ c = 0 ∧ d = 0)) :
    ∃ s₁ t₁ s₂ t₂ s₃ t₃ : K, (s₁ ≠ 0 ∨ t₁ ≠ 0) ∧ (s₂ ≠ 0 ∨ t₂ ≠ 0) ∧ (s₃ ≠ 0 ∨ t₃ ≠ 0) ∧
      a = s₁ * s₂ * s₃ ∧
      b = s₁ * s₂ * t₃ + s₁ * t₂ * s₃ + t₁ * s₂ * s₃ ∧
      c = s₁ * t₂ * t₃ + t₁ * s₂ * t₃ + t₁ * t₂ * s₃ ∧
      d = t₁ * t₂ * t₃ := by
  by_cases ha : a = 0
  · subst ha
    have hbcd : ¬(b = 0 ∧ c = 0 ∧ d = 0) := fun hh => h ⟨rfl, hh.1, hh.2.1, hh.2.2⟩
    obtain ⟨s₂, t₂, s₃, t₃, h₂, h₃, hb', hc', hd'⟩ := exists_binaryQuadratic_split b c d hbcd
    exact ⟨0, 1, s₂, t₂, s₃, t₃, Or.inr one_ne_zero, h₂, h₃, by ring,
      by linear_combination hb', by linear_combination hc', by linear_combination hd'⟩
  · obtain ⟨r, hr⟩ := exists_root_cubic a b c d ha
    have hne : ¬(a = 0 ∧ b + a * r = 0 ∧ c + b * r + a * r ^ 2 = 0) := fun hh => ha hh.1
    obtain ⟨s₂, t₂, s₃, t₃, h₂, h₃, ha', hb', hc'⟩ :=
      exists_binaryQuadratic_split a (b + a * r) (c + b * r + a * r ^ 2) hne
    exact ⟨1, -r, s₂, t₂, s₃, t₃, Or.inl one_ne_zero, h₂, h₃,
      by linear_combination ha', by linear_combination hb' - r * ha',
      by linear_combination hc' - r * hb', by linear_combination hr - r * hc'⟩

/-! ### Zeros of linear forms -/

omit [IsAlgClosed K] in
/-- A linear form in three variables has a nontrivial zero. -/
theorem exists_ne_zero_root_of_linear (c₀ c₁ c₂ : K) :
    ∃ p : Fin 3 → K, p ≠ 0 ∧ c₀ * p 0 + c₁ * p 1 + c₂ * p 2 = 0 := by
  by_cases h : c₀ = 0
  · refine ⟨![1, 0, 0], fun hh => ?_, ?_⟩
    · simpa using congrFun hh 0
    · simp [h]
  · refine ⟨![-c₁, c₀, 0], fun hh => h ?_, ?_⟩
    · simpa using congrFun hh 1
    · simp only [Matrix.cons_val_zero, Matrix.cons_val_one, Matrix.head_cons,
        Matrix.cons_val_two, Matrix.tail_cons]
      ring

omit [IsAlgClosed K] in
/-- **Two linear forms in three variables have a nontrivial common zero.**

Two planes through the origin of a three-dimensional space meet in a line.  The witness is the cross
product of the coefficient vectors when that is nonzero, and a zero of the first (equivalently the
second, since then the two forms are proportional) otherwise. -/
theorem exists_ne_zero_common_root_of_linear (c₀ c₁ c₂ d₀ d₁ d₂ : K) :
    ∃ p : Fin 3 → K, p ≠ 0 ∧ c₀ * p 0 + c₁ * p 1 + c₂ * p 2 = 0 ∧
      d₀ * p 0 + d₁ * p 1 + d₂ * p 2 = 0 := by
  by_cases hn : c₁ * d₂ - c₂ * d₁ = 0 ∧ c₂ * d₀ - c₀ * d₂ = 0 ∧ c₀ * d₁ - c₁ * d₀ = 0
  · obtain ⟨n₀, n₁, n₂⟩ := hn
    by_cases hc : c₀ = 0 ∧ c₁ = 0 ∧ c₂ = 0
    · obtain ⟨rfl, rfl, rfl⟩ := hc
      obtain ⟨p, hp0, hpd⟩ := exists_ne_zero_root_of_linear d₀ d₁ d₂
      exact ⟨p, hp0, by ring, hpd⟩
    · obtain ⟨p, hp0, hpc⟩ := exists_ne_zero_root_of_linear c₀ c₁ c₂
      refine ⟨p, hp0, hpc, ?_⟩
      by_cases h0 : c₀ = 0
      · by_cases h1 : c₁ = 0
        · have h2 : c₂ ≠ 0 := fun h2 => hc ⟨h0, h1, h2⟩
          have key : c₂ * (d₀ * p 0 + d₁ * p 1 + d₂ * p 2) = 0 := by
            linear_combination d₂ * hpc + p 0 * n₁ - p 1 * n₀
          exact (mul_eq_zero.mp key).resolve_left h2
        · have key : c₁ * (d₀ * p 0 + d₁ * p 1 + d₂ * p 2) = 0 := by
            linear_combination d₁ * hpc - p 0 * n₂ + p 2 * n₀
          exact (mul_eq_zero.mp key).resolve_left h1
      · have key : c₀ * (d₀ * p 0 + d₁ * p 1 + d₂ * p 2) = 0 := by
          linear_combination d₀ * hpc + p 1 * n₂ - p 2 * n₁
        exact (mul_eq_zero.mp key).resolve_left h0
  · refine ⟨![c₁ * d₂ - c₂ * d₁, c₂ * d₀ - c₀ * d₂, c₀ * d₁ - c₁ * d₀], fun hh => hn ?_, ?_, ?_⟩
    · exact ⟨by simpa using congrFun hh 0, by simpa using congrFun hh 1,
        by simpa using congrFun hh 2⟩
    · simp only [Matrix.cons_val_zero, Matrix.cons_val_one, Matrix.head_cons,
        Matrix.cons_val_two, Matrix.tail_cons]
      ring
    · simp only [Matrix.cons_val_zero, Matrix.cons_val_one, Matrix.head_cons,
        Matrix.cons_val_two, Matrix.tail_cons]
      ring

/-! ### The cubic containing the line -/

/-- If the restriction of a homogeneous plane cubic to `L = {X₂ = 0}` vanishes, the cubic is `X₂`
times a quadric — the line is a component. -/
theorem eq_X2_mul_of_lineRestriction_eq_zero (G : MvPolynomial (Fin 3) K)
    (hG : G.IsHomogeneous 3)
    (ha : coeffU3 G = 0) (hb : coeffU2V G = 0) (hc : coeffUV2 G = 0) (hd : coeffV3 G = 0) :
    G = X 2 * (C (coeffU2W G) * X 0 ^ 2 + C (coeffUVW G) * X 0 * X 1 + C (coeffV2W G) * X 1 ^ 2 +
      C (coeffUW2 G) * X 0 * X 2 + C (coeffVW2 G) * X 1 * X 2 + C (coeffW3 G) * X 2 ^ 2) := by
  refine MvPolynomial.funext fun p => ?_
  rw [eval_eq_planeCubicValue hG p]
  simp only [map_mul, map_add, map_pow, eval_X, eval_C, UniversalResidual.planeCubicValue,
    ha, hb, hc, hd]
  ring

/-! ### Base-point-freeness -/

/-- **Base-point-freeness of the residual line.**

For a smooth plane cubic over an algebraically closed field, the residual line
`δ_C({X₂ = 0})` of `certificates/all_smooth_tangent_residual_theorem.md` §2 is a genuine line: the
linear form `residualLinearForm G` of §5 is nonzero, equivalently its coefficient vector
`(q_U, q_V, q_W)` does not vanish.

Smoothness is the Jacobian criterion in the form the rest of the development uses: no nonzero point
of the cubic annihilates all three partials.  No hypothesis on the characteristic is needed. -/
theorem residualLinearForm_ne_zero_of_nonsingular
    (G : MvPolynomial (Fin 3) K) (hG : G.IsHomogeneous 3)
    (hns : ∀ r : Fin 3 → K, r ≠ 0 → eval r G = 0 → ∃ i : Fin 3, eval r (pderiv i G) ≠ 0) :
    residualLinearForm G ≠ 0 := by
  intro hq
  -- The universal identity of §2 with a vanishing residual line.
  have key : ∀ p : Fin 3 → K,
      UniversalResidual.polarResultant (coeffU3 G) (coeffU2V G) (coeffUV2 G) (coeffV3 G)
          (coeffU2W G) (coeffUVW G) (coeffV2W G) (p 0) (p 1) (p 2) +
        UniversalResidual.binaryCubicDiscr (coeffU3 G) (coeffU2V G) (coeffUV2 G) (coeffV3 G) *
          eval p G = 0 := by
    intro p
    have h := residual_identity_eval hG p
    simp only [hq, map_zero, mul_zero] at h
    exact h
  by_cases habcd : coeffU3 G = 0 ∧ coeffU2V G = 0 ∧ coeffUV2 G = 0 ∧ coeffV3 G = 0
  · -- `L ⊂ C`: the cubic contains the line, hence is singular where the line meets the residual
    -- conic.
    obtain ⟨ha, hb, hc, hd⟩ := habcd
    have hGQ := eq_X2_mul_of_lineRestriction_eq_zero G hG ha hb hc hd
    obtain ⟨u, v, huv, hconic⟩ :
        ∃ u v : K, (u ≠ 0 ∨ v ≠ 0) ∧
          coeffU2W G * u ^ 2 + coeffUVW G * (u * v) + coeffV2W G * v ^ 2 = 0 := by
      by_cases he : coeffU2W G = 0
      · exact ⟨1, 0, Or.inl one_ne_zero, by simp [he]⟩
      · obtain ⟨r, hr⟩ := exists_root_quadratic (coeffU2W G) (coeffUVW G) (coeffV2W G) he
        exact ⟨r, 1, Or.inr one_ne_zero, by linear_combination hr⟩
    have hp0 : (![u, v, 0] : Fin 3 → K) ≠ 0 := by
      intro hh
      rcases huv with hu | hv
      · exact hu (by simpa using congrFun hh 0)
      · exact hv (by simpa using congrFun hh 1)
    have hX0 : eval (![u, v, 0] : Fin 3 → K) (X 2) = 0 := by simp
    have hQ0 : eval (![u, v, 0] : Fin 3 → K)
        (C (coeffU2W G) * X 0 ^ 2 + C (coeffUVW G) * X 0 * X 1 + C (coeffV2W G) * X 1 ^ 2 +
            C (coeffUW2 G) * X 0 * X 2 + C (coeffVW2 G) * X 1 * X 2 +
            C (coeffW3 G) * X 2 ^ 2) = 0 := by
      simp only [map_mul, map_add, map_pow, eval_X, eval_C, Matrix.cons_val_zero,
        Matrix.cons_val_one, Matrix.head_cons, Matrix.cons_val_two, Matrix.tail_cons]
      linear_combination hconic
    have hGv : eval (![u, v, 0] : Fin 3 → K) G = 0 := by
      rw [hGQ, map_mul, hX0, zero_mul]
    obtain ⟨i, hi⟩ := hns _ hp0 hGv
    exact hi (eval_pderiv_eq_zero_of_eq_mul hGQ _ hX0 hQ0 i)
  · -- `L ⊄ C`: split `G|_L` into three linear factors and read off the three tangent lines.
    obtain ⟨s₁, t₁, s₂, t₂, s₃, t₃, hst₁, hst₂, hst₃, ha, hb, hc, hd⟩ :=
      exists_binaryCubic_split (coeffU3 G) (coeffU2V G) (coeffUV2 G) (coeffV3 G) habcd
    -- A degenerate tangent line is a singular point of `G` on `L`.
    have hTne : ∀ s t : K, (s ≠ 0 ∨ t ≠ 0) →
        coeffU3 G * t ^ 3 - coeffU2V G * (t ^ 2 * s) + coeffUV2 G * (t * s ^ 2) -
            coeffV3 G * s ^ 3 = 0 →
        lineTangentForm G s t ≠ 0 := by
      intro s t hst hroot hT
      have hr0 : (![t, -s, 0] : Fin 3 → K) ≠ 0 := by
        intro hh
        rcases hst with hs | ht
        · exact hs (by simpa using congrFun hh 1)
        · exact ht (by simpa using congrFun hh 0)
      have hgrad := (lineTangentForm_eq_zero_iff G hG s t).mp hT
      have hGv : eval (![t, -s, 0] : Fin 3 → K) G = 0 := by
        rw [eval_eq_planeCubicValue hG]
        simp only [UniversalResidual.planeCubicValue, Matrix.cons_val_zero, Matrix.cons_val_one,
          Matrix.head_cons, Matrix.cons_val_two, Matrix.tail_cons]
        linear_combination hroot
      obtain ⟨i, hi⟩ := hns _ hr0 hGv
      exact hi (hgrad i)
    have hT₁ : lineTangentForm G s₁ t₁ ≠ 0 :=
      hTne s₁ t₁ hst₁ (by rw [ha, hb, hc, hd]; ring)
    have hT₂ : lineTangentForm G s₂ t₂ ≠ 0 :=
      hTne s₂ t₂ hst₂ (by rw [ha, hb, hc, hd]; ring)
    have hT₃ : lineTangentForm G s₃ t₃ ≠ 0 :=
      hTne s₃ t₃ hst₃ (by rw [ha, hb, hc, hd]; ring)
    -- The polar resultant is the product of the three tangent lines.
    have hval : ∀ p : Fin 3 → K,
        eval p (lineTangentForm G s₁ t₁) *
            (eval p (lineTangentForm G s₂ t₂) * eval p (lineTangentForm G s₃ t₃)) =
          UniversalResidual.polarResultant (coeffU3 G) (coeffU2V G) (coeffUV2 G) (coeffV3 G)
            (coeffU2W G) (coeffUVW G) (coeffV2W G) (p 0) (p 1) (p 2) := by
      intro p
      simp only [eval_lineTangentForm]
      rw [polarResultant_eq_polarRes32, ha, hb, hc, hd, polarRes32_of_split]
    have hfact : lineTangentForm G s₁ t₁ * (lineTangentForm G s₂ t₂ * lineTangentForm G s₃ t₃) =
        -(C (UniversalResidual.binaryCubicDiscr (coeffU3 G) (coeffU2V G) (coeffUV2 G)
            (coeffV3 G)) * G) := by
      refine MvPolynomial.funext fun p => ?_
      rw [map_mul, map_mul, hval p, map_neg, map_mul, eval_C]
      linear_combination key p
    have hdisc : UniversalResidual.binaryCubicDiscr (coeffU3 G) (coeffU2V G) (coeffUV2 G)
        (coeffV3 G) ≠ 0 := by
      intro h0
      rw [h0, map_zero, zero_mul, neg_zero] at hfact
      rcases mul_eq_zero.mp hfact with h | h
      · exact hT₁ h
      · rcases mul_eq_zero.mp h with h' | h'
        · exact hT₂ h'
        · exact hT₃ h'
    -- A common zero of the first two tangent lines is a singular point of `G`.
    obtain ⟨p, hp0, hpT₁, hpT₂⟩ :=
      exists_ne_zero_common_root_of_linear
        (3 * coeffU3 G * t₁ ^ 2 - 2 * coeffU2V G * (t₁ * s₁) + coeffUV2 G * s₁ ^ 2)
        (coeffU2V G * t₁ ^ 2 - 2 * coeffUV2 G * (t₁ * s₁) + 3 * coeffV3 G * s₁ ^ 2)
        (coeffU2W G * t₁ ^ 2 - coeffUVW G * (t₁ * s₁) + coeffV2W G * s₁ ^ 2)
        (3 * coeffU3 G * t₂ ^ 2 - 2 * coeffU2V G * (t₂ * s₂) + coeffUV2 G * s₂ ^ 2)
        (coeffU2V G * t₂ ^ 2 - 2 * coeffUV2 G * (t₂ * s₂) + 3 * coeffV3 G * s₂ ^ 2)
        (coeffU2W G * t₂ ^ 2 - coeffUVW G * (t₂ * s₂) + coeffV2W G * s₂ ^ 2)
    have hev₁ : eval p (lineTangentForm G s₁ t₁) = 0 := by
      simp only [lineTangentForm, eval_linearForm3]; exact hpT₁
    have hev₂ : eval p (lineTangentForm G s₂ t₂) = 0 := by
      simp only [lineTangentForm, eval_linearForm3]; exact hpT₂
    have hEQ : C (UniversalResidual.binaryCubicDiscr (coeffU3 G) (coeffU2V G) (coeffUV2 G)
        (coeffV3 G)) * G =
          -lineTangentForm G s₁ t₁ * (lineTangentForm G s₂ t₂ * lineTangentForm G s₃ t₃) := by
      rw [neg_mul, hfact, neg_neg]
    have hGv : eval p G = 0 := by
      have h := congrArg (eval p) hEQ
      rw [map_mul, eval_C, map_mul, map_neg, hev₁, neg_zero, zero_mul] at h
      exact (mul_eq_zero.mp h).resolve_left hdisc
    have hgrad : ∀ i : Fin 3, eval p (pderiv i G) = 0 := by
      intro i
      have h := eval_pderiv_eq_zero_of_eq_mul hEQ p (by rw [map_neg, hev₁, neg_zero])
        (by rw [map_mul, hev₂, zero_mul]) i
      rw [pderiv_C_mul, map_mul, eval_C] at h
      exact (mul_eq_zero.mp h).resolve_left hdisc
    obtain ⟨i, hi⟩ := hns p hp0 hGv
    exact hi (hgrad i)

end AlgClosed

end

end PlaneCubicResidual

/-! ## Consequences

The two consequences the development needs: base-point-freeness along an arbitrary line, and
non-vacuity of `ResidualLineConstant`. -/

noncomputable section

open MvPolynomial Finsupp PlaneCubicResidual ResidualDivisor
open scoped Matrix

variable {K : Type*} [Field K] [IsAlgClosed K]

/-! ### Along an arbitrary line -/

/-- **Base-point-freeness of the residual line along an arbitrary line.**

`residualLinearFormOn M N G` is `δ_C(L)` for the line `L` with frame `M`, defined in
`PlaneCubicResidualEquivariance`.  It is a genuine line as soon as the cubic carried into the frame
of `L` is smooth — which, `M` being invertible, is smoothness of `G` itself.  The hypothesis is
stated on the transported cubic because that is the form in which the normalised theorem applies;
§3 of the source chooses `L`, never `C`. -/
theorem residualLinearFormOn_ne_zero_of_nonsingular
    (M N : Matrix (Fin 3) (Fin 3) K) (hMN : M * N = 1) (G : MvPolynomial (Fin 3) K)
    (hG : ((aeval (linearSubst 2 M) : MvPolynomial (Fin 3) K →ₐ[K] _) G).IsHomogeneous 3)
    (hns : ∀ r : Fin 3 → K, r ≠ 0 →
        eval r ((aeval (linearSubst 2 M) : MvPolynomial (Fin 3) K →ₐ[K] _) G) = 0 →
        ∃ i : Fin 3,
          eval r (pderiv i ((aeval (linearSubst 2 M) : MvPolynomial (Fin 3) K →ₐ[K] _) G)) ≠ 0) :
    residualLinearFormOn M N G ≠ 0 := by
  have hNM : N * M = 1 := mul_eq_one_comm.mp hMN
  have hcomp : ∀ p : MvPolynomial (Fin 3) K,
      (aeval (linearSubst 2 M) : MvPolynomial (Fin 3) K →ₐ[K] _)
        ((aeval (linearSubst 2 N) : MvPolynomial (Fin 3) K →ₐ[K] _) p) = p := by
    intro p
    have hid : ((aeval (linearSubst 2 M) : MvPolynomial (Fin 3) K →ₐ[K] _).comp
        (aeval (linearSubst 2 N) : MvPolynomial (Fin 3) K →ₐ[K] _)) = AlgHom.id K _ := by
      refine MvPolynomial.algHom_ext fun i => ?_
      simp only [AlgHom.comp_apply, aeval_X, AlgHom.id_apply]
      rw [aeval_linearSubst_linearSubst, hNM, linearSubst_one]
    exact DFunLike.congr_fun hid p
  intro h
  refine residualLinearForm_ne_zero_of_nonsingular _ hG hns ?_
  have h' := congrArg (aeval (linearSubst 2 M) : MvPolynomial (Fin 3) K →ₐ[K] _) h
  rw [residualLinearFormOn, hcomp, map_zero] at h'
  exact h'

/-- On the coordinate line the general statement is the normalised one. -/
theorem residualLinearFormOn_one_ne_zero_of_nonsingular
    (G : MvPolynomial (Fin 3) K) (hG : G.IsHomogeneous 3)
    (hns : ∀ r : Fin 3 → K, r ≠ 0 → eval r G = 0 → ∃ i : Fin 3, eval r (pderiv i G) ≠ 0) :
    residualLinearFormOn 1 1 G ≠ 0 := by
  rw [residualLinearFormOn_one]
  exact residualLinearForm_ne_zero_of_nonsingular G hG hns

/-! ### The residual line of a family

`residualLineCoeff F a` is the `a`-th of the three degree-ten forms `q_U, q_V, q_W` of §5.  Below
they are identified with the coefficients `ResidualDivisor.residualCoeff*_of` from which the
residual equation is built, and are shown not all to vanish once one cubic fibre is smooth. -/

/-- The cubic fibre of the residual equation is the residual line of the cubic fibre. -/
theorem specializeFirstCoordinates_residualEquation
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) K) (x : Fin 3 → K) :
    specializeFirstCoordinates (n := 2) x (residualEquation F) =
      linearForm3 (eval x (residualCoeffU_of F)) (eval x (residualCoeffV_of F))
        (eval x (residualCoeffW_of F)) := by
  refine MvPolynomial.funext fun y => ?_
  rw [eval_specializeFirstCoordinates, eval_residualEquation, eval_linearForm3]

theorem residualLineCoeff_zero (F : MvPolynomial (BiprojectiveCoordinate 2 2) K) :
    residualLineCoeff F 0 = residualCoeffU_of F := by
  refine MvPolynomial.funext fun x => ?_
  rw [residualLineCoeff, eval_secondBlockCoeff, specializeFirstCoordinates_residualEquation,
    coeff_linearForm3_zero]

theorem residualLineCoeff_one (F : MvPolynomial (BiprojectiveCoordinate 2 2) K) :
    residualLineCoeff F 1 = residualCoeffV_of F := by
  refine MvPolynomial.funext fun x => ?_
  rw [residualLineCoeff, eval_secondBlockCoeff, specializeFirstCoordinates_residualEquation,
    coeff_linearForm3_one]

theorem residualLineCoeff_two (F : MvPolynomial (BiprojectiveCoordinate 2 2) K) :
    residualLineCoeff F 2 = residualCoeffW_of F := by
  refine MvPolynomial.funext fun x => ?_
  rw [residualLineCoeff, eval_secondBlockCoeff, specializeFirstCoordinates_residualEquation,
    coeff_linearForm3_two]

/-- **The three residual coefficient forms of a family do not all vanish, as soon as one cubic
fibre is smooth.**

This is the family-level form of base-point-freeness, and the exact statement that rules out the
vacuous solution `g = 0` of `ResidualLineConstant`. -/
theorem exists_residualLineCoeff_ne_zero_of_nonsingular_fibre
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) K) (x : Fin 3 → K)
    (hG : (specializeFirstCoordinates (n := 2) x F).IsHomogeneous 3)
    (hns : ∀ r : Fin 3 → K, r ≠ 0 → eval r (specializeFirstCoordinates (n := 2) x F) = 0 →
      ∃ i : Fin 3, eval r (pderiv i (specializeFirstCoordinates (n := 2) x F)) ≠ 0) :
    ∃ a : Fin 3, residualLineCoeff F a ≠ 0 := by
  by_contra hall
  have hall' : ∀ a : Fin 3, residualLineCoeff F a = 0 := fun a => by
    by_contra hh
    exact hall ⟨a, hh⟩
  refine residualLinearForm_ne_zero_of_nonsingular _ hG hns ?_
  rw [residualLinearForm_eq_zero_iff]
  refine ⟨?_, ?_, ?_⟩
  · have h0 := congrArg (eval x) ((residualLineCoeff_zero F).symm.trans (hall' 0))
    rwa [eval_residualCoeffU_of, map_zero] at h0
  · have h1 := congrArg (eval x) ((residualLineCoeff_one F).symm.trans (hall' 1))
    rwa [eval_residualCoeffV_of, map_zero] at h1
  · have h2 := congrArg (eval x) ((residualLineCoeff_two F).symm.trans (hall' 2))
    rwa [eval_residualCoeffW_of, map_zero] at h2

/-- **`ResidualLineConstant` is not vacuous when a cubic fibre is smooth.**

`ResidualLineConstant F` is satisfied by `g = 0`, or by `c = 0`, precisely when all three
coefficient forms vanish; then the "residual line" is not a line and no geometric conclusion may be
drawn from constancy.  Under one smooth fibre both degenerate witnesses are excluded, so any
witness of `ResidualLineConstant F` really is a point of `(ℙ²_y)^∨`. -/
theorem ne_zero_of_residualLineConstant_of_nonsingular_fibre
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) K) (x : Fin 3 → K)
    (hG : (specializeFirstCoordinates (n := 2) x F).IsHomogeneous 3)
    (hns : ∀ r : Fin 3 → K, r ≠ 0 → eval r (specializeFirstCoordinates (n := 2) x F) = 0 →
      ∃ i : Fin 3, eval r (pderiv i (specializeFirstCoordinates (n := 2) x F)) ≠ 0)
    {g : MvPolynomial (Fin 3) K} {c : Fin 3 → K}
    (h : ∀ a : Fin 3, residualLineCoeff F a = C (c a) * g) :
    g ≠ 0 ∧ c ≠ 0 := by
  obtain ⟨a, ha⟩ := exists_residualLineCoeff_ne_zero_of_nonsingular_fibre F x hG hns
  refine ⟨fun hg => ha ?_, fun hc => ha ?_⟩
  · rw [h a, hg, mul_zero]
  · rw [h a, hc]
    simp

/-! ### The residual line of a family along an arbitrary line -/

/-- A linear substitution carries a linear form to a linear form. -/
theorem aeval_linearSubst_linearForm3 (N : Matrix (Fin 3) (Fin 3) K) (a b c : K) :
    (aeval (linearSubst 2 N) : MvPolynomial (Fin 3) K →ₐ[K] _) (linearForm3 a b c) =
      linearForm3 (a * N 0 0 + b * N 1 0 + c * N 2 0) (a * N 0 1 + b * N 1 1 + c * N 2 1)
        (a * N 0 2 + b * N 1 2 + c * N 2 2) := by
  refine MvPolynomial.funext fun y => ?_
  rw [eval_aeval_linearSubst, eval_linearForm3, eval_linearForm3]
  have hmv : ∀ j, (N *ᵥ y) j = N j 0 * y 0 + N j 1 * y 1 + N j 2 * y 2 := by
    intro j
    simp [Matrix.mulVec, dotProduct, Fin.sum_univ_three]
  rw [hmv, hmv, hmv]
  ring

/-- **The three residual coefficient forms along an arbitrary line `L` do not all vanish, as soon
as one cubic fibre in the frame of `L` is smooth.**

This is the statement that rules out the vacuous solution `g = 0` of `ResidualLineConstantOn`, which
is what `ResidualEquationLine.ResidualLineNonconstantOn` — condition **G3** of §3 — negates. -/
theorem exists_residualLineCoeffOn_ne_zero_of_nonsingular_fibre
    (M N : Matrix (Fin 3) (Fin 3) K) (hMN : M * N = 1)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) K) (x : Fin 3 → K)
    (hG : (specializeFirstCoordinates (n := 2) x (secondBlockSubst M F)).IsHomogeneous 3)
    (hns : ∀ r : Fin 3 → K, r ≠ 0 →
        eval r (specializeFirstCoordinates (n := 2) x (secondBlockSubst M F)) = 0 →
        ∃ i : Fin 3,
          eval r (pderiv i (specializeFirstCoordinates (n := 2) x (secondBlockSubst M F))) ≠ 0) :
    ∃ a : Fin 3, residualLineCoeffOn M N F a ≠ 0 := by
  have hNM : N * M = 1 := mul_eq_one_comm.mp hMN
  -- `aeval (linearSubst 2 N)` is injective: `M` undoes it.
  have hcomp : ∀ p : MvPolynomial (Fin 3) K,
      (aeval (linearSubst 2 M) : MvPolynomial (Fin 3) K →ₐ[K] _)
        ((aeval (linearSubst 2 N) : MvPolynomial (Fin 3) K →ₐ[K] _) p) = p := by
    intro p
    have hid : ((aeval (linearSubst 2 M) : MvPolynomial (Fin 3) K →ₐ[K] _).comp
        (aeval (linearSubst 2 N) : MvPolynomial (Fin 3) K →ₐ[K] _)) = AlgHom.id K _ := by
      refine MvPolynomial.algHom_ext fun i => ?_
      simp only [AlgHom.comp_apply, aeval_X, AlgHom.id_apply]
      rw [aeval_linearSubst_linearSubst, hNM, linearSubst_one]
    exact DFunLike.congr_fun hid p
  by_contra hall
  have hall' : ∀ a : Fin 3, residualLineCoeffOn M N F a = 0 := fun a => by
    by_contra hh
    exact hall ⟨a, hh⟩
  -- The specialised residual equation along `L` is the substituted residual line of the fibre.
  have hspec : specializeFirstCoordinates (n := 2) x (residualEquationOn M N F) =
      (aeval (linearSubst 2 N) : MvPolynomial (Fin 3) K →ₐ[K] _)
        (linearForm3 (eval x (residualCoeffU_of (secondBlockSubst M F)))
          (eval x (residualCoeffV_of (secondBlockSubst M F)))
          (eval x (residualCoeffW_of (secondBlockSubst M F)))) := by
    rw [residualEquationOn, specializeFirstCoordinates_secondBlockSubst,
      specializeFirstCoordinates_residualEquation]
  -- All three coefficients of that linear form vanish, so it is zero.
  have hlin : (aeval (linearSubst 2 N) : MvPolynomial (Fin 3) K →ₐ[K] _)
      (linearForm3 (eval x (residualCoeffU_of (secondBlockSubst M F)))
        (eval x (residualCoeffV_of (secondBlockSubst M F)))
        (eval x (residualCoeffW_of (secondBlockSubst M F)))) = 0 := by
    rw [aeval_linearSubst_linearForm3, linearForm3_eq_zero_iff]
    refine ⟨?_, ?_, ?_⟩
    · have h := congrArg (eval x) (hall' 0)
      rw [residualLineCoeffOn, eval_secondBlockCoeff, hspec, aeval_linearSubst_linearForm3,
        coeff_linearForm3_zero, map_zero] at h
      exact h
    · have h := congrArg (eval x) (hall' 1)
      rw [residualLineCoeffOn, eval_secondBlockCoeff, hspec, aeval_linearSubst_linearForm3,
        coeff_linearForm3_one, map_zero] at h
      exact h
    · have h := congrArg (eval x) (hall' 2)
      rw [residualLineCoeffOn, eval_secondBlockCoeff, hspec, aeval_linearSubst_linearForm3,
        coeff_linearForm3_two, map_zero] at h
      exact h
  have hABD : linearForm3 (eval x (residualCoeffU_of (secondBlockSubst M F)))
      (eval x (residualCoeffV_of (secondBlockSubst M F)))
      (eval x (residualCoeffW_of (secondBlockSubst M F))) = 0 := by
    have h := congrArg (aeval (linearSubst 2 M) : MvPolynomial (Fin 3) K →ₐ[K] _) hlin
    rwa [hcomp, map_zero] at h
  obtain ⟨hA0, hB0, hD0⟩ := (linearForm3_eq_zero_iff _ _ _).mp hABD
  -- Hence the residual line of the smooth fibre vanishes, contradicting base-point-freeness.
  refine residualLinearForm_ne_zero_of_nonsingular _ hG hns ?_
  rw [residualLinearForm_eq_zero_iff]
  rw [eval_residualCoeffU_of] at hA0
  rw [eval_residualCoeffV_of] at hB0
  rw [eval_residualCoeffW_of] at hD0
  exact ⟨hA0, hB0, hD0⟩

/-- **`ResidualLineConstantOn` is not vacuous when a cubic fibre in the frame of `L` is smooth.** -/
theorem ne_zero_of_residualLineConstantOn_of_nonsingular_fibre
    (M N : Matrix (Fin 3) (Fin 3) K) (hMN : M * N = 1)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) K) (x : Fin 3 → K)
    (hG : (specializeFirstCoordinates (n := 2) x (secondBlockSubst M F)).IsHomogeneous 3)
    (hns : ∀ r : Fin 3 → K, r ≠ 0 →
        eval r (specializeFirstCoordinates (n := 2) x (secondBlockSubst M F)) = 0 →
        ∃ i : Fin 3,
          eval r (pderiv i (specializeFirstCoordinates (n := 2) x (secondBlockSubst M F))) ≠ 0)
    {g : MvPolynomial (Fin 3) K} {c : Fin 3 → K}
    (h : ∀ a : Fin 3, residualLineCoeffOn M N F a = C (c a) * g) :
    g ≠ 0 ∧ c ≠ 0 := by
  obtain ⟨a, ha⟩ :=
    exists_residualLineCoeffOn_ne_zero_of_nonsingular_fibre M N hMN F x hG hns
  refine ⟨fun hg => ha ?_, fun hc => ha ?_⟩
  · rw [h a, hg, mul_zero]
  · rw [h a, hc]
    simp

end

end BConicBundleMultisections
