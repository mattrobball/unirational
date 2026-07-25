/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import BConicBundleMultisections.BinaryCubicResidual
public import BConicBundleMultisections.LinearSubstitution
public import BConicBundleMultisections.MultisectionLine
public import BConicBundleMultisections.PlaneCubicResidualIdentity

/-!
# Reparameterizing the residual construction

The tangent-residual construction takes a plane cubic `G`, a point `p` on it, and a direction `q`,
restricts `G` to the line `span(p, q)`, and reads off the residual point.  This file records how the
output changes when the *direction representative* changes.

## Why this is needed

`certificates/all_smooth_tangent_residual_theorem.md` chooses the multisection line `L` in §3 and
only normalises it to `{W = 0}` in §5.  The development took the normalisation as given, so
`PlaneCubicResidual.residualLinearForm` — the residual line `δ_C(L)` — is defined through the
`U, V, W` monomial basis and is therefore tied to that one line.

Generalising it by re-deriving the §5 coefficient identities frame-independently would mean redoing
`PlaneCubicResidualVanishing` and `PlaneCubicResidualIdentity` (about a thousand lines of explicit
computation ending in `UniversalResidual.residualLinear_complementary_eq_zero`).  The cheaper route
is to *transport*: carry the cubic into the frame where `L = {W = 0}`, use the existing identities
there, and carry the conclusion back.  That transport happens on a three-variable cubic, not on the
biprojective scheme, so it needs only polynomial-level linear algebra — none of the `Proj.map` and
ideal-sheaf machinery that made the scheme-level `PGL₃` transport worth parking.

Transporting turns the canonical direction `p × ∇G(p)` into *some* direction spanning the same
tangent line modulo `p`, not into that exact vector.  The main result here says that this does not
matter: rescaling the direction rescales the residual point by a unit, and the residual point is
what the construction is about.

## Main results

* `binaryLineRestriction_reparam`: replacing `q` by `α·q + β·p` reparameterizes the restricted
  binary cubic by `X₀ ↦ X₀ + β·X₁`, `X₁ ↦ α·X₁`.
* `residualAmbientRep_reparam`: under that replacement the residual point is scaled by `α³`.
-/

@[expose] public section

namespace BConicBundleMultisections

noncomputable section

universe u

open MvPolynomial

variable {R : Type u} [CommRing R]

/-! ### Reparameterizing a binary form

Changing the direction from `q` to `α·q + β·p` keeps the point `p` and the line through it, but
moves the parameterisation of that line.  On the restricted binary form this is the substitution
below. -/

/-- The change of binary parameter induced by replacing the direction `q` with `α·q + β·p`. -/
def binaryReparam (α β : R) : MvPolynomial (Fin 2) R →ₐ[R] MvPolynomial (Fin 2) R :=
  aeval ![X 0 + C β * X 1, C α * X 1]

@[simp] theorem binaryReparam_X_zero (α β : R) :
    binaryReparam α β (X 0) = X 0 + C β * X 1 := by
  simp [binaryReparam]

@[simp] theorem binaryReparam_X_one (α β : R) :
    binaryReparam α β (X 1) = C α * X 1 := by
  simp [binaryReparam]

@[simp] theorem binaryReparam_C (α β r : R) :
    binaryReparam α β (C r) = C r := by
  simp [binaryReparam]

/-- `X₁² · X₀` as a monomial. -/
theorem X_one_sq_mul_X_zero :
    (X 1 : MvPolynomial (Fin 2) R) ^ 2 * X 0 = monomial (binaryExponent 1 2) 1 := by
  have hX0 : (X 0 : MvPolynomial (Fin 2) R) = monomial (Finsupp.single 0 1) 1 := by
    rw [← X_pow_eq_monomial, pow_one]
  have he : Finsupp.single (1 : Fin 2) 2 + Finsupp.single 0 1 = binaryExponent 1 2 := by
    ext i; fin_cases i <;> simp [binaryExponent]
  rw [X_pow_eq_monomial, hX0, monomial_mul, one_mul, he]

/-- `X₁³` as a monomial. -/
theorem X_one_cube :
    (X 1 : MvPolynomial (Fin 2) R) ^ 3 = monomial (binaryExponent 0 3) 1 := by
  have he : Finsupp.single (1 : Fin 2) 3 = binaryExponent 0 3 := by
    ext i; fin_cases i <;> simp [binaryExponent]
  rw [X_pow_eq_monomial, he]

/-- **Restricting to the line with a rescaled direction reparameterizes the binary form.**

Both sides send the binary point `(s, t)` to the value of the cubic at
`s·p + t·(α·q + β·p) = (s + β·t)·p + (α·t)·q`. -/
theorem binaryLineRestriction_reparam {σ : Type*} (p q : σ → R) (α β : R)
    (G : MvPolynomial σ R) :
    binaryLineRestriction p (fun i => α * q i + β * p i) G
      = binaryReparam α β (binaryLineRestriction p q G) := by
  have hfun : (fun i => C (p i) * X 0 + C (α * q i + β * p i) * X (1 : Fin 2))
      = fun i => binaryReparam α β (C (p i) * X 0 + C (q i) * X 1) := by
    funext i
    simp only [binaryReparam, map_add, map_mul, aeval_C, aeval_X, Matrix.cons_val_zero,
      Matrix.cons_val_one, MvPolynomial.algebraMap_eq]
    ring
  rw [binaryLineRestriction, binaryLineRestriction, ← AlgHom.comp_apply,
    MvPolynomial.comp_aeval, hfun]

/-! ### The residual point under reparameterization -/

/-- **Rescaling the direction rescales the residual point by `α³`.**

The residual point is `-d·p + c·q` where `c`, `d` are the `X₀X₁²` and `X₁³` coefficients of the
restricted cubic.  Writing the restricted cubic as `X₁²·(c·X₀ + d·X₁)` — legitimate because the
first two coefficients vanish, which is what makes `p` a point of double contact — the
reparameterized cubic is `X₁²·(α²c·X₀ + (α²cβ + α³d)·X₁)`, and the `β` contributions cancel against
the `β·p` in the new direction. -/
theorem residualAmbientRep_reparam {σ : Type*} (p q : σ → R) (α β : R)
    (f : MvPolynomial (Fin 2) R) (hf : f.IsHomogeneous 3)
    (h30 : coeff (binaryExponent 3 0) f = 0)
    (h21 : coeff (binaryExponent 2 1) f = 0) :
    residualAmbientRep p (fun i => α * q i + β * p i) (binaryReparam α β f)
      = fun i => α ^ 3 * residualAmbientRep p q f i := by
  classical
  set c := coeff (binaryExponent 1 2) f with hc
  set d := coeff (binaryExponent 0 3) f with hd
  -- The reparameterized cubic, computed from the factorization `f = X₁² * (c·X₀ + d·X₁)`.
  have hrep : binaryReparam α β f
      = monomial (binaryExponent 1 2) (α ^ 2 * c)
        + monomial (binaryExponent 0 3) (α ^ 2 * c * β + α ^ 3 * d) := by
    have hm : ∀ (e : Fin 2 →₀ ℕ) (r : R),
        (monomial e r : MvPolynomial (Fin 2) R) = C r * monomial e 1 := by
      intro e r; rw [C_mul_monomial, mul_one]
    rw [binaryCubic_eq_X_one_sq_mul f hf h30 h21, binaryCubicResidualLinearForm,
      hm _ (α ^ 2 * c), hm _ (α ^ 2 * c * β + α ^ 3 * d), ← X_one_sq_mul_X_zero, ← X_one_cube]
    simp only [map_mul, map_add, map_pow, binaryReparam_X_zero, binaryReparam_X_one,
      binaryReparam_C, C_mul, C_pow, C_add]
    ring
  have hne : binaryExponent 0 3 ≠ binaryExponent 1 2 := by
    intro h; exact absurd (congrArg (fun e => e 0) h) (by simp [binaryExponent])
  have hc' : coeff (binaryExponent 1 2) (binaryReparam α β f) = α ^ 2 * c := by
    rw [hrep]
    simp [coeff_monomial, hne]
  have hd' : coeff (binaryExponent 0 3) (binaryReparam α β f)
      = α ^ 2 * c * β + α ^ 3 * d := by
    rw [hrep]
    simp [coeff_monomial, hne, Ne.symm hne]
  funext i
  simp only [residualAmbientRep, residualBinaryRep, Matrix.cons_val_zero, Matrix.cons_val_one,
    Matrix.head_cons, hc', hd', ← hc, ← hd]
  ring

/-! ### The frame carrying the coordinate line to `L`

To run the residual construction for a general line `L = span(p, q)` we substitute variables so that
`L` becomes `{W = 0}`.  The matrix doing this has `p` and `q` as its first two columns: then the
coordinate line's point `[1 : t : 0]` is carried to `p + t·q`, the point of `L` at parameter `t`. -/

open scoped Matrix

/-- The frame of a line: the matrix whose columns are `p`, `q` and a completion `r`.

Invertibility is not part of the definition — the results below that need it take an explicit
inverse, so that the frame can be built before a completion is chosen. -/
def lineFrame (p q r : Fin 3 → R) : Matrix (Fin 3) (Fin 3) R :=
  Matrix.of fun j l => ![p, q, r] l j

@[simp] theorem lineFrame_apply (p q r : Fin 3 → R) (j l : Fin 3) :
    lineFrame p q r j l = ![p, q, r] l j := rfl

/-- **The frame carries the coordinate line to `L`.**  This is the defining property: the point of
the coordinate line at parameter `t` goes to the point of `L` at parameter `t`. -/
@[simp] theorem lineFrame_mulVec_coordinateLinePoint (p q r : Fin 3 → R) (t : R) :
    lineFrame p q r *ᵥ ![1, t, 0] = linePointOf p q t := by
  funext j
  simp only [Matrix.mulVec, dotProduct, Fin.sum_univ_three, lineFrame_apply,
    Matrix.cons_val_zero, Matrix.cons_val_one, Matrix.head_cons, Matrix.cons_val_two,
    Matrix.tail_cons, linePointOf]
  ring

/-- The frame sends the first basis vector to `p`, the base point of `L`. -/
@[simp] theorem lineFrame_mulVec_base (p q r : Fin 3 → R) :
    lineFrame p q r *ᵥ ![1, 0, 0] = p := by
  have := lineFrame_mulVec_coordinateLinePoint p q r 0
  simpa using this

/-- The frame sends the second basis vector to `q`, the direction of `L`. -/
@[simp] theorem lineFrame_mulVec_dir (p q r : Fin 3 → R) :
    lineFrame p q r *ᵥ ![0, 1, 0] = q := by
  funext j
  simp only [Matrix.mulVec, dotProduct, Fin.sum_univ_three, lineFrame_apply,
    Matrix.cons_val_zero, Matrix.cons_val_one, Matrix.head_cons, Matrix.cons_val_two,
    Matrix.tail_cons]
  ring

/-! ### The residual line of a cubic along an arbitrary line

`PlaneCubicResidual.residualLinearForm` is `δ_C(L)` for the single line `{W = 0}`: it is read off
the `U, V, W` monomial coefficients.  For a general `L` we carry the cubic into the frame of `L`,
take the residual line there, and carry it back.

Carrying back uses the *inverse* frame, because a point `y` has frame coordinates `N *ᵥ y`. -/

/-- **The residual line `δ_C(L)` of a plane cubic along the line spanned by `p` and `q`.**

`M` is the frame of `L` and `N` its inverse.  Taking both as arguments rather than inverting keeps
the definition free of `Invertible` instances; the results below state exactly which inverse
property they use. -/
def residualLinearFormOn (M N : Matrix (Fin 3) (Fin 3) R) (G : MvPolynomial (Fin 3) R) :
    MvPolynomial (Fin 3) R :=
  (aeval (linearSubst 2 N) : MvPolynomial (Fin 3) R →ₐ[R] _)
    (PlaneCubicResidual.residualLinearForm
      ((aeval (linearSubst 2 M) : MvPolynomial (Fin 3) R →ₐ[R] _) G))

/-- Evaluating the general residual line at `y` is evaluating the normalized one at the frame
coordinates of `y`. -/
theorem eval_residualLinearFormOn (M N : Matrix (Fin 3) (Fin 3) R)
    (G : MvPolynomial (Fin 3) R) (y : Fin 3 → R) :
    eval y (residualLinearFormOn M N G)
      = eval (N *ᵥ y) (PlaneCubicResidual.residualLinearForm
          ((aeval (linearSubst 2 M) : MvPolynomial (Fin 3) R →ₐ[R] _) G)) :=
  eval_aeval_linearSubst 2 N _ y

/-- For the identity frame the general residual line is the normalized one, so nothing is lost by
working with `residualLinearFormOn` throughout. -/
@[simp] theorem residualLinearFormOn_one (G : MvPolynomial (Fin 3) R) :
    residualLinearFormOn 1 1 G = PlaneCubicResidual.residualLinearForm G := by
  simp [residualLinearFormOn, aeval_X_left_apply]

end

end BConicBundleMultisections
