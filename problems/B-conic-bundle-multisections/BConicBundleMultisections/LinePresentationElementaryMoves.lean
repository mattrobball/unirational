/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import BConicBundleMultisections.GoodLineConic
public import BConicBundleMultisections.ResidualDiscriminantAvoidance
public import BConicBundleMultisections.MinimalLineSection
public import BConicBundleMultisections.ResidualImageAffineParam
public import Mathlib.Algebra.Polynomial.AlgebraMap
public import Mathlib.LinearAlgebra.Matrix.Determinant.Basic
public import Mathlib.LinearAlgebra.Matrix.Notation

/-!
# Elementary moves on the line presentation (Goal F-1)

Two independent pairs `(p,q)`, `(p',q')` span the same line iff
`(p',q') = (a•p+b•q, c•p+d•q)` with `ad − bc ≠ 0`. Every such change is a product of three
elementary families (2×2 Gaussian elimination):

* **shear** `(p,q) ↦ (p+β•q, q)` — translation `t ↦ t+β`;
* **scale** `(p,q) ↦ (α•p, δ•q)` (`αδ ≠ 0`) — scaling `t ↦ (δ/α)•t` and unit scalar;
* **swap** `(p,q) ↦ (q, p)` — projective inversion / coefficient reflection.

## Laws proved in this module

| move | `lineConicDiscriminant` | section | isotropy |
|---|---|---|---|
| shear | `comp (X + C β)` | same `comp` | ↔ |
| scale | `C (α^9) * comp (C (δ/α) * X)` | same `comp` | ↔ (`δ ≠ 0`) |

Exponent `9 = 3·3`: second-block degree of `F` is 3; polar-`det` is cubic in the entries.

### Landed in `LinePresentationPairChange`

* **Swap disc**: `lineConicDiscriminant q p F = reflect 9 (lineConicDiscriminant p q F)` via the
  binary polar disc `lineConicDiscBinary` (homogenization route; not bare `reflect` through
  products). Homogeneous of degree 9; dehomogenizations recover the univariate disc;
  `p ↔ q` is the variable swap `T₀ ↔ T₁`.
* **Adjusted inverses** (derived from `lineFrame p' q' r = lineFrame p q r * E`):
  shear `N' = S⁻¹ N`, scale `N' = D⁻¹ N`, swap `N' = W N`.

### Still open (F-1b.2 residual Y-laws / F-1b.3 endpoint)

* Residual `Y`-coordinate equivariance under shear/scale/swap (with the adjusted inverses).
* `hasGoodLineSectionPartial_pair_change` once G4 transports without hypothesis.
-/

@[expose] public section

namespace BConicBundleMultisections

noncomputable section

universe u

open Matrix
open scoped Matrix

variable {k : Type u} [Field k]

/-! ### Lemma 0: elementary decomposition of `GL₂` data -/

/-- The three elementary 2×2 shapes. -/
inductive ElemGL2 (R : Type*) [CommRing R] where
  | shear (β : R)
  | scale (α δ : R) (hα : α ≠ 0) (hδ : δ ≠ 0)
  | swap

namespace ElemGL2

variable {R : Type*} [CommRing R]

/-- Matrix of an elementary move. Pair convention: `(p',q') = (a p + b q, c p + d q)` for
`!![a, b; c, d]`. Shear is upper-triangular `!![1, β; 0, 1]`. Lower shears are
`swap * shear * swap`. -/
def matrix : ElemGL2 R → Matrix (Fin 2) (Fin 2) R
  | shear β => !![1, β; 0, 1]
  | scale α δ _ _ => !![α, 0; 0, δ]
  | swap => !![0, 1; 1, 0]

end ElemGL2

/-- Determinant nonvanishing for elementary matrices over a field. -/
theorem ElemGL2.det_matrix_ne_zero (e : ElemGL2 k) : (ElemGL2.matrix e).det ≠ 0 := by
  cases e with
  | shear β => simp [ElemGL2.matrix, Matrix.det_fin_two]
  | scale α δ hα hδ => simp [ElemGL2.matrix, Matrix.det_fin_two, hα, hδ]
  | swap => simp [ElemGL2.matrix, Matrix.det_fin_two]

/-- Apply a 2×2 matrix to a pair: `(p', q') = (a p + b q, c p + d q)`. -/
def applyPair (M : Matrix (Fin 2) (Fin 2) k) (p q : Fin 3 → k) : (Fin 3 → k) × (Fin 3 → k) :=
  (fun i => M 0 0 * p i + M 0 1 * q i, fun i => M 1 0 * p i + M 1 1 * q i)

@[simp] theorem applyPair_shear (β : k) (p q : Fin 3 → k) :
    applyPair (ElemGL2.matrix (ElemGL2.shear (R := k) β)) p q =
      (fun i => p i + β * q i, q) := by
  ext <;> simp [applyPair, ElemGL2.matrix] <;> try ring

@[simp] theorem applyPair_scale (α δ : k) (hα : α ≠ 0) (hδ : δ ≠ 0) (p q : Fin 3 → k) :
    applyPair (ElemGL2.matrix (ElemGL2.scale (R := k) α δ hα hδ)) p q =
      (fun i => α * p i, fun i => δ * q i) := by
  ext <;> simp [applyPair, ElemGL2.matrix]

@[simp] theorem applyPair_swap (p q : Fin 3 → k) :
    applyPair (ElemGL2.matrix (ElemGL2.swap (R := k))) p q = (q, p) := by
  ext <;> simp [applyPair, ElemGL2.matrix]

theorem applyPair_mul (A B : Matrix (Fin 2) (Fin 2) k) (p q : Fin 3 → k) :
    applyPair (A * B) p q =
      applyPair A (applyPair B p q).1 (applyPair B p q).2 := by
  ext <;> simp [applyPair, Matrix.mul_apply, Fin.sum_univ_two] <;> try ring

theorem applyPair_one (p q : Fin 3 → k) :
    applyPair (1 : Matrix (Fin 2) (Fin 2) k) p q = (p, q) := by
  ext <;> simp [applyPair]

private theorem mul22 (a b c d a' b' c' d' : k) :
    (!![a, b; c, d] : Matrix (Fin 2) (Fin 2) k) * !![a', b'; c', d'] =
      !![a * a' + b * c', a * b' + b * d'; c * a' + d * c', c * b' + d * d'] := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [Matrix.mul_apply, Fin.sum_univ_two] <;> ring

/-- **Lemma 0.** Every 2×2 matrix with nonzero determinant is a finite product of elementary
shear, scale and swap matrices. Direct 2×2 Gaussian elimination. -/
theorem exists_elemGL2_prod (a b c d : k) (hdet : a * d - b * c ≠ 0) :
    ∃ es : List (ElemGL2 k),
      (es.map ElemGL2.matrix).prod = (!![a, b; c, d] : Matrix (Fin 2) (Fin 2) k) := by
  classical
  by_cases ha : a = 0
  · subst ha
    have hbc : b * c ≠ 0 := by
      intro h0; exact hdet (by simp [h0])
    have hb : b ≠ 0 := left_ne_zero_of_mul hbc
    have hc : c ≠ 0 := right_ne_zero_of_mul hbc
    let β := d / c
    -- `!![0,b;c,d] = swap * scale(c,b) * shear(d/c)` (List.prod is right-associated).
    refine ⟨[ElemGL2.swap, ElemGL2.scale c b hc hb, ElemGL2.shear β], ?_⟩
    simp only [List.map_cons, List.map_nil, List.prod_cons, List.prod_nil, mul_one,
      ElemGL2.matrix]
    have hsc :
        (!![c, 0; 0, b] : Matrix (Fin 2) (Fin 2) k) * !![1, β; 0, 1] =
          !![c, c * β; 0, b] := by
      rw [mul22]; ext i j; fin_cases i <;> fin_cases j <;> simp
    have hsw :
        (!![0, 1; 1, 0] : Matrix (Fin 2) (Fin 2) k) * !![c, c * β; 0, b] =
          !![0, b; c, c * β] := by
      rw [mul22]; ext i j; fin_cases i <;> fin_cases j <;> simp
    have hassoc :
        (!![0, 1; 1, 0] : Matrix (Fin 2) (Fin 2) k) *
            (!![c, 0; 0, b] * !![1, β; 0, 1]) =
          !![0, 1; 1, 0] * !![c, c * β; 0, b] := by rw [hsc]
    rw [hassoc, hsw]
    ext i j
    fin_cases i <;> fin_cases j <;> simp [β, mul_div_cancel₀ d hc]
  · have ha' : a ≠ 0 := ha
    let β := b / a
    let γ := c / a
    let δ := (a * d - b * c) / a
    have hδ0 : δ ≠ 0 := by
      intro h0
      exact hdet ((div_eq_zero_iff.mp h0).resolve_right ha')
    -- `!![a,b;c,d] = L(γ) * D * U(β)` with `L = swap * shear(γ) * swap`.
    refine ⟨[ElemGL2.swap, ElemGL2.shear γ, ElemGL2.swap,
        ElemGL2.scale a δ ha' hδ0, ElemGL2.shear β], ?_⟩
    simp only [List.map_cons, List.map_nil, List.prod_cons, List.prod_nil, mul_one,
      ElemGL2.matrix]
    have hDU :
        (!![a, 0; 0, δ] : Matrix (Fin 2) (Fin 2) k) * !![1, β; 0, 1] =
          !![a, a * β; 0, δ] := by
      rw [mul22]; ext i j; fin_cases i <;> fin_cases j <;> simp
    have hswDU :
        (!![0, 1; 1, 0] : Matrix (Fin 2) (Fin 2) k) * !![a, a * β; 0, δ] =
          !![0, δ; a, a * β] := by
      rw [mul22]; ext i j; fin_cases i <;> fin_cases j <;> simp
    have hsh :
        (!![1, γ; 0, 1] : Matrix (Fin 2) (Fin 2) k) * !![0, δ; a, a * β] =
          !![γ * a, γ * (a * β) + δ; a, a * β] := by
      rw [mul22]; ext i j; fin_cases i <;> fin_cases j <;> simp <;> ring
    have hfin :
        (!![0, 1; 1, 0] : Matrix (Fin 2) (Fin 2) k) *
            !![γ * a, γ * (a * β) + δ; a, a * β] =
          !![a, a * β; γ * a, γ * (a * β) + δ] := by
      rw [mul22]; ext i j; fin_cases i <;> fin_cases j <;> simp
    have hchain :
        (!![0, 1; 1, 0] : Matrix (Fin 2) (Fin 2) k) *
            (!![1, γ; 0, 1] *
              (!![0, 1; 1, 0] * (!![a, 0; 0, δ] * !![1, β; 0, 1]))) =
          !![a, a * β; γ * a, γ * (a * β) + δ] := by
      rw [hDU, hswDU, hsh, hfin]
    rw [hchain]
    ext i j
    fin_cases i <;> fin_cases j
    · simp
    · simp [β, mul_div_cancel₀ b ha']
    · change γ * a = c
      simp only [γ]; exact div_mul_cancel₀ c ha'
    · change γ * (a * β) + δ = d
      simp only [β, γ, δ]
      field_simp [ha']
      ring

/-- Invariance under elementary moves lifts to every `GL₂` pair change.
`List.prod` is right-associated, so the word `e :: rest` means "apply `rest` first, then `e`". -/
theorem pair_property_of_elemGL2_invariant
    (P : (Fin 3 → k) → (Fin 3 → k) → Prop)
    (hshear : ∀ (p q : Fin 3 → k) (β : k), P p q → P (fun i => p i + β * q i) q)
    (hscale : ∀ (p q : Fin 3 → k) (α δ : k) (hα : α ≠ 0) (hδ : δ ≠ 0),
      P p q → P (fun i => α * p i) (fun i => δ * q i))
    (hswap : ∀ (p q : Fin 3 → k), P p q → P q p)
    (a b c d : k) (hdet : a * d - b * c ≠ 0)
    (p q : Fin 3 → k) (hP : P p q) :
    P (fun i => a * p i + b * q i) (fun i => c * p i + d * q i) := by
  classical
  obtain ⟨es, hes⟩ := exists_elemGL2_prod a b c d hdet
  have hword :
      ∀ es' : List (ElemGL2 k), ∀ p q,
        P p q →
          P (applyPair (es'.map ElemGL2.matrix).prod p q).1
            (applyPair (es'.map ElemGL2.matrix).prod p q).2 := by
    intro es' p q h
    induction es' generalizing p q with
    | nil =>
      simpa [List.map_nil, List.prod_nil, applyPair_one] using h
    | cons e rest ih =>
      -- `prod (e::rest) = e.matrix * prod rest`, so apply `rest` first.
      have hrest := ih p q h
      have h1 :
          P (applyPair (ElemGL2.matrix e)
                (applyPair (rest.map ElemGL2.matrix).prod p q).1
                (applyPair (rest.map ElemGL2.matrix).prod p q).2).1
            (applyPair (ElemGL2.matrix e)
                (applyPair (rest.map ElemGL2.matrix).prod p q).1
                (applyPair (rest.map ElemGL2.matrix).prod p q).2).2 := by
        cases e with
        | shear β =>
          simpa using hshear _ _ β hrest
        | scale α δ hα hδ =>
          simpa using hscale _ _ α δ hα hδ hrest
        | swap =>
          simpa using hswap _ _ hrest
      simpa [List.map_cons, List.prod_cons, applyPair_mul] using h1
  have hfin := hword es p q hP
  have happ :
      applyPair (!![a, b; c, d] : Matrix (Fin 2) (Fin 2) k) p q =
        (fun i => a * p i + b * q i, fun i => c * p i + d * q i) := by
    ext <;> simp [applyPair]
  simpa [hes, happ] using hfin

/-! ### Parameter substitutions on `k[t]` -/

/-- The ring endomorphism `f ↦ f.comp (X + C β)`. -/
def shearPolyHom (β : k) : Polynomial k →+* Polynomial k :=
  Polynomial.eval₂RingHom Polynomial.C (Polynomial.X + Polynomial.C β)

@[simp] theorem shearPolyHom_apply (β : k) (f : Polynomial k) :
    shearPolyHom β f = f.comp (Polynomial.X + Polynomial.C β) :=
  rfl

theorem shearPolyHom_injective (β : k) : Function.Injective (shearPolyHom β) := by
  intro f g h
  have h' : f.comp (Polynomial.X + Polynomial.C β) = g.comp (Polynomial.X + Polynomial.C β) := h
  have := congrArg (fun p => p.comp (Polynomial.X + Polynomial.C (-β))) h'
  have hinv : (Polynomial.X + Polynomial.C β).comp (Polynomial.X + Polynomial.C (-β)) =
      (Polynomial.X : Polynomial k) := by
    simp [Polynomial.add_comp, Polynomial.X_comp, Polynomial.C_comp, add_assoc]
  simpa [Polynomial.comp_assoc, hinv, Polynomial.comp_X] using this

theorem shearPolyHom_ne_zero_iff (β : k) {f : Polynomial k} :
    shearPolyHom β f ≠ 0 ↔ f ≠ 0 := by
  constructor
  · intro h hf; exact h (by simp [hf])
  · intro hf h0
    exact hf (shearPolyHom_injective β (by simpa using h0))

/-- The ring endomorphism `f ↦ f.comp (C μ * X)`. -/
def scalePolyHom (μ : k) : Polynomial k →+* Polynomial k :=
  Polynomial.eval₂RingHom Polynomial.C (Polynomial.C μ * Polynomial.X)

@[simp] theorem scalePolyHom_apply (μ : k) (f : Polynomial k) :
    scalePolyHom μ f = f.comp (Polynomial.C μ * Polynomial.X) :=
  rfl

theorem scalePolyHom_injective {μ : k} (hμ : μ ≠ 0) :
    Function.Injective (scalePolyHom μ) := by
  intro f g h
  have h' : f.comp (Polynomial.C μ * Polynomial.X) =
      g.comp (Polynomial.C μ * Polynomial.X) := h
  have := congrArg (fun p => p.comp (Polynomial.C μ⁻¹ * Polynomial.X)) h'
  have hinv : (Polynomial.C μ * Polynomial.X).comp (Polynomial.C μ⁻¹ * Polynomial.X) =
      (Polynomial.X : Polynomial k) := by
    simp [Polynomial.mul_comp, Polynomial.C_comp, Polynomial.X_comp, ← mul_assoc, ← map_mul,
      mul_inv_cancel₀ hμ]
  simpa [Polynomial.comp_assoc, hinv, Polynomial.comp_X] using this

theorem scalePolyHom_ne_zero_iff {μ : k} (hμ : μ ≠ 0) {f : Polynomial k} :
    scalePolyHom μ f ≠ 0 ↔ f ≠ 0 := by
  constructor
  · intro h hf; exact h (by simp [hf])
  · intro hf h0
    exact hf (scalePolyHom_injective hμ (by simpa using h0))

/-! ### Line-point identities -/

theorem linePointOf_shear {R : Type u} [CommRing R] (p q : Fin 3 → R) (β t : R) :
    linePointOf (fun i => p i + β * q i) q t = linePointOf p q (t + β) := by
  funext a; simp [linePointOf]; ring

theorem linePointOf_scale_field (p q : Fin 3 → k) (α δ t : k) (hα : α ≠ 0) :
    linePointOf (fun i => α * p i) (fun i => δ * q i) t =
      α • linePointOf p q ((δ / α) * t) := by
  funext a
  simp only [linePointOf, Pi.smul_apply, smul_eq_mul]
  field_simp [hα]

/-! ### Specialised conic under shear and scale -/

theorem lineSpecializedConicPoly_shear
    (p q : Fin 3 → k) (β : k)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) :
    lineSpecializedConicPoly (fun i => p i + β * q i) q F =
      MvPolynomial.map (shearPolyHom β) (lineSpecializedConicPoly p q F) := by
  have hpt :
      (fun j => shearPolyHom β
          (linePointOf (fun a => Polynomial.C (p a)) (fun a => Polynomial.C (q a))
            Polynomial.X j)) =
        linePointOf (fun a => Polynomial.C (p a + β * q a))
          (fun a => Polynomial.C (q a)) Polynomial.X := by
    funext j
    simp only [shearPolyHom_apply, linePointOf]
    -- `(C p + X * C q).comp (X + C β) = C p + (X + C β) * C q`
    simp only [Polynomial.add_comp, Polynomial.mul_comp, Polynomial.C_comp, Polynomial.X_comp,
      Polynomial.C_add, Polynomial.C_mul, add_mul]
    abel
  have hC :
      (shearPolyHom β).comp (Polynomial.C : k →+* Polynomial k) =
        (Polynomial.C : k →+* Polynomial k) := by
    ext; simp
  simp only [lineSpecializedConicPoly]
  rw [map_specializeSecondCoordinates, MvPolynomial.map_map, hC, hpt]

theorem lineSpecializedConicPoly_scale
    (p q : Fin 3 → k) (α δ : k) (hα : α ≠ 0)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F) :
    lineSpecializedConicPoly (fun i => α * p i) (fun i => δ * q i) F =
      MvPolynomial.C (Polynomial.C α ^ 3) *
        MvPolynomial.map (scalePolyHom (δ / α)) (lineSpecializedConicPoly p q F) := by
  have hpt :
      linePointOf (fun a => Polynomial.C (α * p a)) (fun a => Polynomial.C (δ * q a))
          Polynomial.X =
        (Polynomial.C α : Polynomial k) •
          linePointOf (fun a => Polynomial.C (p a)) (fun a => Polynomial.C (q a))
            (Polynomial.C (δ / α) * Polynomial.X) := by
    funext j
    simp only [linePointOf, Pi.smul_apply, smul_eq_mul, Polynomial.C_mul]
    -- `C α * C p + X * C δ * C q = C α * (C p + C(δ/α) * X * C q)`
    have hδα : (Polynomial.C (δ / α) : Polynomial k) * Polynomial.C α = Polynomial.C δ := by
      simp [← map_mul, div_mul_cancel₀ δ hα]
    calc
      Polynomial.C α * Polynomial.C (p j) + Polynomial.X * (Polynomial.C δ * Polynomial.C (q j)) =
          Polynomial.C α * Polynomial.C (p j) +
            Polynomial.X * (Polynomial.C (δ / α) * Polynomial.C α * Polynomial.C (q j)) := by
          rw [← hδα]
      _ = Polynomial.C α *
            (Polynomial.C (p j) + Polynomial.C (δ / α) * Polynomial.X * Polynomial.C (q j)) := by
          ring
  have hmapF : IsBidegree23 (MvPolynomial.map (Polynomial.C : k →+* Polynomial k) F) :=
    hF.map_coefficients (Polynomial.C : k →+* Polynomial k)
  have hsmul :=
    hmapF.specializeSecondCoordinates_smul (Polynomial.C α)
      (linePointOf (fun a => Polynomial.C (p a)) (fun a => Polynomial.C (q a))
        (Polynomial.C (δ / α) * Polynomial.X))
  have hcomp :
      specializeSecondCoordinates
          (linePointOf (fun a => Polynomial.C (p a)) (fun a => Polynomial.C (q a))
            (Polynomial.C (δ / α) * Polynomial.X))
          (MvPolynomial.map (Polynomial.C : k →+* Polynomial k) F) =
        MvPolynomial.map (scalePolyHom (δ / α)) (lineSpecializedConicPoly p q F) := by
    have hpt' :
        (fun j => scalePolyHom (δ / α)
            (linePointOf (fun a => Polynomial.C (p a)) (fun a => Polynomial.C (q a))
              Polynomial.X j)) =
          linePointOf (fun a => Polynomial.C (p a)) (fun a => Polynomial.C (q a))
            (Polynomial.C (δ / α) * Polynomial.X) := by
      funext j
      simp only [scalePolyHom_apply, linePointOf, Polynomial.add_comp, Polynomial.mul_comp,
        Polynomial.C_comp, Polynomial.X_comp]
    have hC :
        (scalePolyHom (δ / α)).comp (Polynomial.C : k →+* Polynomial k) =
          (Polynomial.C : k →+* Polynomial k) := by
      ext; simp
    simp only [lineSpecializedConicPoly]
    rw [map_specializeSecondCoordinates, MvPolynomial.map_map, hC, hpt']
  -- Avoid unfolding the RHS `lineSpecializedConicPoly`.
  conv_lhs => rw [lineSpecializedConicPoly]
  rw [hpt, hsmul, hcomp]

/-! ### Polar matrix under coefficient maps and units -/

theorem polarMatrix_C_mul {R : Type u} [CommRing R]
    (c : R) (Q : MvPolynomial (Fin 3) R) :
    polarMatrix (MvPolynomial.C c * Q) = c • polarMatrix Q := by
  ext i j
  change polarEval (MvPolynomial.C c * Q) (Pi.single i 1) (Pi.single j 1) =
    c * polarEval Q (Pi.single i 1) (Pi.single j 1)
  simp only [polarEval, MvPolynomial.eval_mul, MvPolynomial.eval_C]
  ring

theorem det_polarMatrix_C_mul {R : Type u} [CommRing R]
    (c : R) (Q : MvPolynomial (Fin 3) R) :
    (polarMatrix (MvPolynomial.C c * Q)).det = c ^ 3 * (polarMatrix Q).det := by
  rw [polarMatrix_C_mul, Matrix.det_smul, Fintype.card_fin]

theorem det_polarMatrix_map_ringHom {R S : Type u} [CommRing R] [CommRing S]
    (φ : R →+* S) (Q : MvPolynomial (Fin 3) R) :
    (polarMatrix (MvPolynomial.map φ Q)).det = φ (polarMatrix Q).det := by
  have h := polarMatrix_map φ Q
  -- `polarMatrix_map` yields `(polarMatrix Q).map φ`; `RingHom.map_det` expects `mapMatrix`.
  have h' : (polarMatrix Q).map φ = φ.mapMatrix (polarMatrix Q) := by
    ext; rfl
  rw [h, h', RingHom.map_det]

/-! ### Discriminant: shear and scale -/

theorem lineConicDiscriminant_shear
    (p q : Fin 3 → k) (β : k)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) :
    lineConicDiscriminant (fun i => p i + β * q i) q F =
      (lineConicDiscriminant p q F).comp (Polynomial.X + Polynomial.C β) := by
  simp only [lineConicDiscriminant]
  rw [lineSpecializedConicPoly_shear, det_polarMatrix_map_ringHom, shearPolyHom_apply]

/-- Scale law. Twist: global unit `α^9` times `t ↦ (δ/α) t`. -/
theorem lineConicDiscriminant_scale
    (p q : Fin 3 → k) (α δ : k) (hα : α ≠ 0)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F) :
    lineConicDiscriminant (fun i => α * p i) (fun i => δ * q i) F =
      Polynomial.C (α ^ 9) *
        (lineConicDiscriminant p q F).comp (Polynomial.C (δ / α) * Polynomial.X) := by
  simp only [lineConicDiscriminant]
  rw [lineSpecializedConicPoly_scale p q α δ hα F hF, det_polarMatrix_C_mul,
    det_polarMatrix_map_ringHom, scalePolyHom_apply]
  -- `(C α ^ 3) ^ 3 = C α ^ 9 = C (α ^ 9)`
  have hpow : (Polynomial.C α ^ 3 : Polynomial k) ^ 3 = Polynomial.C (α ^ 9) := by
    rw [← pow_mul]
    norm_num1
    exact (map_pow (Polynomial.C : k →+* Polynomial k) α 9).symm
  rw [hpow]

theorem lineConicDiscriminant_shear_ne_zero_iff
    (p q : Fin 3 → k) (β : k)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) :
    lineConicDiscriminant (fun i => p i + β * q i) q F ≠ 0 ↔
      lineConicDiscriminant p q F ≠ 0 := by
  rw [lineConicDiscriminant_shear, ← shearPolyHom_apply, shearPolyHom_ne_zero_iff]

theorem lineConicDiscriminant_scale_ne_zero_iff
    (p q : Fin 3 → k) (α δ : k) (hα : α ≠ 0) (hδ : δ ≠ 0)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F) :
    lineConicDiscriminant (fun i => α * p i) (fun i => δ * q i) F ≠ 0 ↔
      lineConicDiscriminant p q F ≠ 0 := by
  rw [lineConicDiscriminant_scale p q α δ hα F hF]
  have hμ : δ / α ≠ 0 := div_ne_zero hδ hα
  have hunit : (Polynomial.C (α ^ 9) : Polynomial k) ≠ 0 := by
    simpa using pow_ne_zero 9 hα
  constructor
  · intro h h0; exact h (by simp [h0])
  · intro h h0
    rcases mul_eq_zero.mp h0 with hC | hcomp
    · exact hunit hC
    · have : scalePolyHom (δ / α) (lineConicDiscriminant p q F) = 0 := by
        simpa [scalePolyHom_apply] using hcomp
      exact h (scalePolyHom_injective hμ (by simpa using this))

/-! ### Isotropy under shear and scale -/

theorem eval_lineTernaryQuadraticPoly_shear
    (p q : Fin 3 → k) (β : k)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (v : Fin 3 → Polynomial k) :
    TernaryQuadraticPoly.eval
        (lineTernaryQuadraticPoly (fun i => p i + β * q i) q F)
        (fun i => shearPolyHom β (v i)) =
      shearPolyHom β
        (TernaryQuadraticPoly.eval (lineTernaryQuadraticPoly p q F) v) := by
  have hQ := lineSpecializedConicPoly_shear p q β F
  have hcoeff (i j : Fin 3) :
      ternaryQuadraticCoeff
          (lineSpecializedConicPoly (fun i => p i + β * q i) q F) i j =
        shearPolyHom β
          (ternaryQuadraticCoeff (lineSpecializedConicPoly p q F) i j) := by
    rw [hQ, ternaryQuadraticCoeff_map]
  simp only [lineTernaryQuadraticPoly, TernaryQuadraticPoly.eval, hcoeff, map_sum, map_mul]

theorem isotropic_lineTernaryQuadraticPoly_shear_iff
    (p q : Fin 3 → k) (β : k)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (v : Fin 3 → Polynomial k) :
    TernaryQuadraticPoly.eval
        (lineTernaryQuadraticPoly (fun i => p i + β * q i) q F)
        (fun i => (v i).comp (Polynomial.X + Polynomial.C β)) = 0 ↔
      TernaryQuadraticPoly.eval (lineTernaryQuadraticPoly p q F) v = 0 := by
  have h := eval_lineTernaryQuadraticPoly_shear p q β F v
  simp only [shearPolyHom_apply] at h
  rw [h]
  constructor
  · intro h0
    exact shearPolyHom_injective β (by simpa [shearPolyHom_apply] using h0)
  · intro h0; simp [h0]

theorem eval_lineTernaryQuadraticPoly_scale
    (p q : Fin 3 → k) (α δ : k) (hα : α ≠ 0)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (v : Fin 3 → Polynomial k) :
    TernaryQuadraticPoly.eval
        (lineTernaryQuadraticPoly (fun i => α * p i) (fun i => δ * q i) F)
        (fun i => scalePolyHom (δ / α) (v i)) =
      (Polynomial.C α ^ 3) *
        scalePolyHom (δ / α)
          (TernaryQuadraticPoly.eval (lineTernaryQuadraticPoly p q F) v) := by
  have hQ := lineSpecializedConicPoly_scale p q α δ hα F hF
  have hcoeff (i j : Fin 3) :
      ternaryQuadraticCoeff
          (lineSpecializedConicPoly (fun i => α * p i) (fun i => δ * q i) F) i j =
        (Polynomial.C α ^ 3) *
          scalePolyHom (δ / α)
            (ternaryQuadraticCoeff (lineSpecializedConicPoly p q F) i j) := by
    have h1 :
        ternaryQuadraticCoeff
            (MvPolynomial.C (Polynomial.C α ^ 3) *
              MvPolynomial.map (scalePolyHom (δ / α)) (lineSpecializedConicPoly p q F)) i j =
          (Polynomial.C α ^ 3) *
            ternaryQuadraticCoeff
              (MvPolynomial.map (scalePolyHom (δ / α)) (lineSpecializedConicPoly p q F)) i j := by
      simp only [ternaryQuadraticCoeff, MvPolynomial.coeff_C_mul]
      split_ifs <;> ring
    rw [hQ, h1, ternaryQuadraticCoeff_map]
  -- Work with the evaluation definition.
  simp only [lineTernaryQuadraticPoly, TernaryQuadraticPoly.eval]
  -- Replace coeffs via hcoeff, then factor.
  have hsum :
      (∑ i : Fin 3, ∑ j : Fin 3,
          ternaryQuadraticCoeff
              (lineSpecializedConicPoly (fun i => α * p i) (fun i => δ * q i) F) i j *
            scalePolyHom (δ / α) (v i) * scalePolyHom (δ / α) (v j)) =
        (Polynomial.C α ^ 3) *
          ∑ i : Fin 3, ∑ j : Fin 3,
            scalePolyHom (δ / α)
                (ternaryQuadraticCoeff (lineSpecializedConicPoly p q F) i j) *
              scalePolyHom (δ / α) (v i) * scalePolyHom (δ / α) (v j) := by
    simp only [hcoeff, Finset.mul_sum, mul_assoc]
  rw [hsum]
  congr 1
  simp only [map_sum, map_mul]

theorem isotropic_lineTernaryQuadraticPoly_scale_iff
    (p q : Fin 3 → k) (α δ : k) (hα : α ≠ 0) (hδ : δ ≠ 0)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (v : Fin 3 → Polynomial k) :
    TernaryQuadraticPoly.eval
        (lineTernaryQuadraticPoly (fun i => α * p i) (fun i => δ * q i) F)
        (fun i => (v i).comp (Polynomial.C (δ / α) * Polynomial.X)) = 0 ↔
      TernaryQuadraticPoly.eval (lineTernaryQuadraticPoly p q F) v = 0 := by
  have h := eval_lineTernaryQuadraticPoly_scale p q α δ hα F hF v
  simp only [scalePolyHom_apply] at h
  rw [h]
  have hα3 : (Polynomial.C α ^ 3 : Polynomial k) ≠ 0 := by
    simp [hα]
  have hμ : δ / α ≠ 0 := div_ne_zero hδ hα
  constructor
  · intro h0
    have hcomp :
        scalePolyHom (δ / α)
          (TernaryQuadraticPoly.eval (lineTernaryQuadraticPoly p q F) v) = 0 :=
      (mul_eq_zero.mp (by simpa [scalePolyHom_apply] using h0)).resolve_left hα3
    exact scalePolyHom_injective hμ (by simpa using hcomp)
  · intro h0; simp [h0]

/-! ### Partial pair-change package (no G3, no frame completion) -/

/-- The F-1 fragment of `HasGoodLineWithSection`: disc + nonzero isotropic section + G4.
Frame completion and G3 are deliberately omitted. -/
def HasGoodLineSectionPartial
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (p q r : Fin 3 → k) (N : Matrix (Fin 3) (Fin 3) k)
    (v : Fin 3 → Polynomial k) : Prop :=
  lineConicDiscriminant p q F ≠ 0 ∧
    v ≠ 0 ∧
    TernaryQuadraticPoly.eval (lineTernaryQuadraticPoly p q F) v = 0 ∧
    ResidualAvoidsConicDiscriminantOn p q r N F v

theorem HasGoodLineWithSection.to_partial
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (p q r : Fin 3 → k) (N : Matrix (Fin 3) (Fin 3) k)
    (v : Fin 3 → Polynomial k)
    (h : Standard.HasGoodLineWithSection F p q r N v) :
    HasGoodLineSectionPartial F p q r N v := by
  rcases h with ⟨_, _, hdisc, hv0, hviso, hG4⟩
  exact ⟨hdisc, hv0, hviso, hG4⟩

/-- Shear transport of the partial package. Disc and isotropy are transported; G4 is an
explicit hypothesis (residual frame adjustment not yet proved). -/
theorem hasGoodLineSectionPartial_shear
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (p q r : Fin 3 → k) (N : Matrix (Fin 3) (Fin 3) k) (β : k)
    (v : Fin 3 → Polynomial k)
    (h : HasGoodLineSectionPartial F p q r N v)
    (hG4' : ResidualAvoidsConicDiscriminantOn
        (fun i => p i + β * q i) q r N F
        (fun i => (v i).comp (Polynomial.X + Polynomial.C β))) :
    HasGoodLineSectionPartial F (fun i => p i + β * q i) q r N
      (fun i => (v i).comp (Polynomial.X + Polynomial.C β)) := by
  rcases h with ⟨hdisc, hv0, hviso, _⟩
  refine ⟨?disc, ?v0, ?iso, hG4'⟩
  · exact (lineConicDiscriminant_shear_ne_zero_iff p q β F).mpr hdisc
  · intro hv'
    apply hv0
    funext i
    exact shearPolyHom_injective β (by
      simpa [shearPolyHom_apply] using congrFun hv' i)
  · exact (isotropic_lineTernaryQuadraticPoly_shear_iff p q β F v).mpr hviso

/-- Scale transport of the partial package. -/
theorem hasGoodLineSectionPartial_scale
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (p q r : Fin 3 → k) (N : Matrix (Fin 3) (Fin 3) k) (α δ : k)
    (hα : α ≠ 0) (hδ : δ ≠ 0)
    (v : Fin 3 → Polynomial k)
    (h : HasGoodLineSectionPartial F p q r N v)
    (hG4' : ResidualAvoidsConicDiscriminantOn
        (fun i => α * p i) (fun i => δ * q i) r N F
        (fun i => (v i).comp (Polynomial.C (δ / α) * Polynomial.X))) :
    HasGoodLineSectionPartial F (fun i => α * p i) (fun i => δ * q i) r N
      (fun i => (v i).comp (Polynomial.C (δ / α) * Polynomial.X)) := by
  rcases h with ⟨hdisc, hv0, hviso, _⟩
  refine ⟨?disc, ?v0, ?iso, hG4'⟩
  · exact (lineConicDiscriminant_scale_ne_zero_iff p q α δ hα hδ F hF).mpr hdisc
  · intro hv'
    apply hv0
    funext i
    exact scalePolyHom_injective (div_ne_zero hδ hα) (by
      simpa [scalePolyHom_apply] using congrFun hv' i)
  · exact (isotropic_lineTernaryQuadraticPoly_scale_iff p q α δ hα hδ F hF v).mpr hviso

end

end BConicBundleMultisections
