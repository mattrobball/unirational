/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import BConicBundleMultisections.BinaryCubicResidual
public import BConicBundleMultisections.MultisectionLine

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

end

end BConicBundleMultisections
