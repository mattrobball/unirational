/-
Copyright (c) 2026 V14Formalization contributors.
Released under Apache 2.0 license.
-/
module

public import V14Formalization.D12MatrixCertificate
public import V14Formalization.D12PieceAction

/-!
# Base change of a D12 four-piece certificate

`D12Certificate.Certificate` is already stated over an arbitrary field, but a
certificate over one field does not obviously give one over another: two of the
four fields of `PieceCertificate` (`action_kernel` and `plucker_empty`) are
quantified over vectors of the *ambient* field, so they do not transport along
a ring map on their own.

This file removes that obstruction.

* `action_kernel` transports because the emitted `A` is the character stack
  `[RM - r·1 ; SM - s·1]`, and `characterStack` commutes with `Matrix.map`
  (`characterStack_map`).  The kernel description is then re-derived over the
  target field by the field-generic
  `D12PieceAction.characterStack_mulVec_eq_zero_iff`.

* `plucker_empty` transports because the `∀ t` coefficient hypothesis of
  `plucker_empty_fin2_of_coeff` / `plucker_empty_fin1_of_coeff` has a *canonical*
  solution: `pluckerValue ((B*K).mulVec t) q` is a quadratic form in `t`, and its
  coefficients are values of that same expression at `t = (1,0), (0,1), (1,1)`.
  Those canonical coefficients commute with any ring map by construction, so the
  only field-dependent input that survives is the nonvanishing of three explicit
  scalars: one `3 × 3` determinant for the `(+,+)` piece and one coefficient each
  for `(-,+)` and `(-,-)`.  The `(+,-)` piece is a zero-dimensional character
  space and needs nothing.

So the emptiness of the D12-fixed locus is *ideal-theoretic*: it survives base
change along any ring map keeping those three explicit elements nonzero, and in
particular along every field extension of the cyclotomic base field, where they
stay nonzero because a ring map out of a field is injective.
-/

noncomputable section

open Matrix

namespace V14Formalization
namespace D12Certificate

universe u v

section Coefficients

variable {Ω : Type u} [Field Ω] {Ω' : Type v} [Field Ω']

public theorem pluckerValue_ringHom (φ : Ω →+* Ω') (x : Fin 15 → Ω) (q : Fin 15) :
    pluckerValue (fun i => φ (x i)) q = φ (pluckerValue x q) := by
  simp [pluckerValue]

public theorem mulVec_map_ringHom {m n : ℕ} (φ : Ω →+* Ω')
    (M : Matrix (Fin m) (Fin n) Ω) (t : Fin n → Ω) :
    (M.map φ).mulVec (fun j => φ (t j)) = fun i => φ (M.mulVec t i) := by
  funext i
  simp [Matrix.mulVec, dotProduct, Matrix.map_apply, map_sum, map_mul]

/-! ### Two-parameter pieces -/

/-- The `(t₀², t₀t₁, t₁²)` coefficients of the `q`-th Plücker quadric on the
image of a two-column matrix, defined by *evaluation* at `(1,0)`, `(1,1)`,
`(0,1)`.  Being an evaluation, it commutes with every ring map. -/
@[expose] public def pluckerCoeff2 (M : Matrix (Fin 15) (Fin 2) Ω) (q : Fin 15) :
    Fin 3 → Ω :=
  ![pluckerValue (M.mulVec ![1, 0]) q,
    pluckerValue (M.mulVec ![1, 1]) q -
      pluckerValue (M.mulVec ![1, 0]) q -
      pluckerValue (M.mulVec ![0, 1]) q,
    pluckerValue (M.mulVec ![0, 1]) q]

/-- Canonical coefficient matrix of the three Plücker quadrics `q = 1, 2, 9`. -/
@[expose] public def pluckerCoeffMatrix2 (M : Matrix (Fin 15) (Fin 2) Ω) :
    Matrix (Fin 3) (Fin 3) Ω :=
  Matrix.of fun i j => pluckerCoeff2 M (![1, 2, 9] i) j

public theorem pluckerValue_mulVec_fin2 (M : Matrix (Fin 15) (Fin 2) Ω)
    (q : Fin 15) (t : Fin 2 → Ω) :
    pluckerValue (M.mulVec t) q =
      pluckerCoeff2 M q 0 * (t 0 * t 0) +
        pluckerCoeff2 M q 1 * (t 0 * t 1) +
        pluckerCoeff2 M q 2 * (t 1 * t 1) := by
  simp only [pluckerCoeff2, pluckerValue, Matrix.mulVec, dotProduct,
    Fin.sum_univ_two, Matrix.cons_val_zero, Matrix.cons_val_one,
    Matrix.head_cons, Matrix.cons_val_fin_one, Matrix.cons_val,
    mul_one, mul_zero, add_zero, zero_add]
  ring

public theorem pluckerCoeffMatrix2_mulVec (M : Matrix (Fin 15) (Fin 2) Ω)
    (t : Fin 2 → Ω) :
    (pluckerCoeffMatrix2 M).mulVec (squareMonomials t) =
      ![pluckerValue (M.mulVec t) 1, pluckerValue (M.mulVec t) 2,
        pluckerValue (M.mulVec t) 9] := by
  have h1 := pluckerValue_mulVec_fin2 M 1 t
  have h2 := pluckerValue_mulVec_fin2 M 2 t
  have h9 := pluckerValue_mulVec_fin2 M 9 t
  funext i
  fin_cases i <;>
    simp [pluckerCoeffMatrix2, Matrix.mulVec, dotProduct,
      Fin.sum_univ_three, squareMonomials, h1, h2, h9] <;>
    ring

/-- Two `3 × 3` matrices agreeing on every square-monomial vector are equal:
the three vectors `(1,0,0)`, `(0,0,1)`, `(1,1,1)` already span. -/
public theorem eq_of_mulVec_squareMonomials {C C' : Matrix (Fin 3) (Fin 3) Ω}
    (h : ∀ t : Fin 2 → Ω,
      C.mulVec (squareMonomials t) = C'.mulVec (squareMonomials t)) :
    C = C' := by
  have h10 := h ![1, 0]
  have h01 := h ![0, 1]
  have h11 := h ![1, 1]
  simp only [squareMonomials, Matrix.mulVec, dotProduct, Fin.sum_univ_three,
    Matrix.cons_val_zero, Matrix.cons_val_one, Matrix.head_cons,
    Matrix.cons_val, mul_one, mul_zero, zero_mul, add_zero,
    zero_add] at h10 h01 h11
  ext i j
  have e0 := congrFun h10 i
  have e2 := congrFun h01 i
  have e1 := congrFun h11 i
  simp [Matrix.mulVec, dotProduct, Fin.sum_univ_three] at e0 e1 e2
  fin_cases j
  · show C i 0 = C' i 0
    linear_combination e0
  · show C i 1 = C' i 1
    linear_combination e1 - e0 - e2
  · show C i 2 = C' i 2
    linear_combination e2

public theorem eq_pluckerCoeffMatrix2 {M : Matrix (Fin 15) (Fin 2) Ω}
    {C : Matrix (Fin 3) (Fin 3) Ω}
    (h : ∀ t : Fin 2 → Ω,
      C.mulVec (squareMonomials t) =
        ![pluckerValue (M.mulVec t) 1, pluckerValue (M.mulVec t) 2,
          pluckerValue (M.mulVec t) 9]) :
    C = pluckerCoeffMatrix2 M :=
  eq_of_mulVec_squareMonomials fun t => by
    rw [h t, pluckerCoeffMatrix2_mulVec]

public theorem pluckerCoeff2_map (φ : Ω →+* Ω') (M : Matrix (Fin 15) (Fin 2) Ω)
    (q : Fin 15) (j : Fin 3) :
    pluckerCoeff2 (M.map φ) q j = φ (pluckerCoeff2 M q j) := by
  have c10 : (![1, 0] : Fin 2 → Ω') = fun j => φ ((![1, 0] : Fin 2 → Ω) j) := by
    funext j; fin_cases j <;> simp
  have c01 : (![0, 1] : Fin 2 → Ω') = fun j => φ ((![0, 1] : Fin 2 → Ω) j) := by
    funext j; fin_cases j <;> simp
  have c11 : (![1, 1] : Fin 2 → Ω') = fun j => φ ((![1, 1] : Fin 2 → Ω) j) := by
    funext j; fin_cases j <;> simp
  have key : ∀ t : Fin 2 → Ω,
      pluckerValue ((M.map φ).mulVec (fun j => φ (t j))) q =
        φ (pluckerValue (M.mulVec t) q) := by
    intro t
    rw [mulVec_map_ringHom]
    exact pluckerValue_ringHom φ _ q
  fin_cases j <;>
    simp [pluckerCoeff2, c10, c01, c11, key, map_sub]

public theorem pluckerCoeffMatrix2_map (φ : Ω →+* Ω')
    (M : Matrix (Fin 15) (Fin 2) Ω) :
    pluckerCoeffMatrix2 (M.map φ) = (pluckerCoeffMatrix2 M).map φ := by
  ext i j
  simp only [pluckerCoeffMatrix2, Matrix.of_apply, Matrix.map_apply,
    pluckerCoeff2_map]

/-! ### One-parameter pieces -/

/-- The `t₀²` coefficient of the `q`-th Plücker quadric on the image of a
one-column matrix, defined by evaluation at `t = 1`. -/
@[expose] public def pluckerCoeff1 (M : Matrix (Fin 15) (Fin 1) Ω) (q : Fin 15) : Ω :=
  pluckerValue (M.mulVec ![1]) q

public theorem pluckerValue_mulVec_fin1 (M : Matrix (Fin 15) (Fin 1) Ω)
    (q : Fin 15) (t : Fin 1 → Ω) :
    pluckerValue (M.mulVec t) q = pluckerCoeff1 M q * (t 0 * t 0) := by
  simp only [pluckerCoeff1, pluckerValue, Matrix.mulVec, dotProduct,
    Fin.sum_univ_one, Matrix.cons_val_zero, Matrix.cons_val_fin_one, mul_one]
  ring

public theorem eq_pluckerCoeff1 {M : Matrix (Fin 15) (Fin 1) Ω} {delta : Ω}
    {q : Fin 15}
    (h : ∀ t : Fin 1 → Ω, pluckerValue (M.mulVec t) q = delta * (t 0 * t 0)) :
    delta = pluckerCoeff1 M q := by
  have h1 := h ![1]
  simp only [pluckerCoeff1, Matrix.cons_val_zero, mul_one] at h1 ⊢
  exact h1.symm

public theorem pluckerCoeff1_map (φ : Ω →+* Ω') (M : Matrix (Fin 15) (Fin 1) Ω)
    (q : Fin 15) :
    pluckerCoeff1 (M.map φ) q = φ (pluckerCoeff1 M q) := by
  have c1 : (![1] : Fin 1 → Ω') = fun j => φ ((![1] : Fin 1 → Ω) j) := by
    funext j; fin_cases j <;> simp
  simp only [pluckerCoeff1, c1, mulVec_map_ringHom, pluckerValue_ringHom]

end Coefficients

/-! ## Base change of the character stack -/

section Stack

variable {Ω : Type u} [Field Ω] {Ω' : Type v} [Field Ω']

public theorem characterStack_map (φ : Ω →+* Ω')
    (RM SM : Matrix (Fin 10) (Fin 10) Ω) (r s : Ω) :
    (D12PieceAction.characterStack RM SM r s).map φ =
      D12PieceAction.characterStack (RM.map φ) (SM.map φ) (φ r) (φ s) := by
  ext i j
  simp only [Matrix.map_apply, D12PieceAction.characterStack, Matrix.of_apply,
    Fin.addCases]
  split_ifs <;> simp [Matrix.map_apply, apply_ite φ]

end Stack

/-! ## Base change of the pieces -/

section PieceMap

variable {Ω : Type u} [Field Ω] {Ω' : Type v} [Field Ω']
variable {B : Matrix (Fin 15) (Fin 10) Ω} {RM SM : Matrix (Fin 10) (Fin 10) Ω}
variable {r s : Ω}

/-- Base change of a two-parameter character piece.  The only field-dependent
input is nonvanishing of the canonical `3 × 3` coefficient determinant in the
target. -/
@[expose] public def PieceCertificate.mapFin2
    (D : PieceCertificate B RM SM r s (Fin 2))
    (hA : D.A = D12PieceAction.characterStack RM SM r s)
    (φ : Ω →+* Ω')
    (hdet : φ (pluckerCoeffMatrix2 (B * D.K)).det ≠ 0) :
    PieceCertificate (B.map φ) (RM.map φ) (SM.map φ) (φ r) (φ s) (Fin 2) where
  A := D12PieceAction.characterStack (RM.map φ) (SM.map φ) (φ r) (φ s)
  K := D.K.map φ
  Y := D.Y.map φ
  X := D.X.map φ
  action_kernel := fun m =>
    D12PieceAction.characterStack_mulVec_eq_zero_iff _ _ _ _ m
  split_identity := by
    rw [← characterStack_map, ← hA, ← Matrix.map_mul, ← Matrix.map_mul,
      ← Matrix.map_add _ φ.map_add, D.split_identity]
    exact Matrix.map_one φ φ.map_zero φ.map_one
  plucker_empty := by
    refine plucker_empty_fin2_of_coeff (B.map φ * D.K.map φ)
      (pluckerCoeffMatrix2 (B.map φ * D.K.map φ)) ?_
      (fun t => pluckerCoeffMatrix2_mulVec _ t)
    have hd : ((pluckerCoeffMatrix2 (B * D.K)).map φ).det =
        φ (pluckerCoeffMatrix2 (B * D.K)).det := by
      rw [← RingHom.mapMatrix_apply]
      exact (RingHom.map_det φ _).symm
    rw [← Matrix.map_mul, pluckerCoeffMatrix2_map, hd]
    exact hdet

/-- Base change of a one-parameter character piece. -/
@[expose] public def PieceCertificate.mapFin1
    (D : PieceCertificate B RM SM r s (Fin 1))
    (hA : D.A = D12PieceAction.characterStack RM SM r s)
    (φ : Ω →+* Ω') (q : Fin 15)
    (hdelta : φ (pluckerCoeff1 (B * D.K) q) ≠ 0) :
    PieceCertificate (B.map φ) (RM.map φ) (SM.map φ) (φ r) (φ s) (Fin 1) where
  A := D12PieceAction.characterStack (RM.map φ) (SM.map φ) (φ r) (φ s)
  K := D.K.map φ
  Y := D.Y.map φ
  X := D.X.map φ
  action_kernel := fun m =>
    D12PieceAction.characterStack_mulVec_eq_zero_iff _ _ _ _ m
  split_identity := by
    rw [← characterStack_map, ← hA, ← Matrix.map_mul, ← Matrix.map_mul,
      ← Matrix.map_add _ φ.map_add, D.split_identity]
    exact Matrix.map_one φ φ.map_zero φ.map_one
  plucker_empty := by
    refine plucker_empty_fin1_of_coeff (B.map φ * D.K.map φ) q
      (pluckerCoeff1 (B.map φ * D.K.map φ) q) ?_
      (fun t => pluckerValue_mulVec_fin1 _ q t)
    rw [← Matrix.map_mul, pluckerCoeff1_map]
    exact hdelta

/-- Base change of a zero-dimensional character piece. -/
@[expose] public def PieceCertificate.mapFin0
    (D : PieceCertificate B RM SM r s (Fin 0))
    (hA : D.A = D12PieceAction.characterStack RM SM r s)
    (φ : Ω →+* Ω') :
    PieceCertificate (B.map φ) (RM.map φ) (SM.map φ) (φ r) (φ s) (Fin 0) where
  A := D12PieceAction.characterStack (RM.map φ) (SM.map φ) (φ r) (φ s)
  K := D.K.map φ
  Y := D.Y.map φ
  X := D.X.map φ
  action_kernel := fun m =>
    D12PieceAction.characterStack_mulVec_eq_zero_iff _ _ _ _ m
  split_identity := by
    rw [← characterStack_map, ← hA, ← Matrix.map_mul, ← Matrix.map_mul,
      ← Matrix.map_add _ φ.map_add, D.split_identity]
    exact Matrix.map_one φ φ.map_zero φ.map_one
  plucker_empty := fun t _ => Subsingleton.elim _ _

end PieceMap

/-! ## Base change of the full certificate -/

section CertificateMap

variable {Ω : Type u} [Field Ω] {Ω' : Type v} [Field Ω']

/-- The three explicit scalars a base change of a certificate has to keep
nonzero: the `(+,+)` coefficient determinant and the `(-,+)` and `(-,-)`
Plücker coefficients.  The `(+,-)` piece is zero-dimensional. -/
@[expose] public def Certificate.ppDet (C : Certificate (Ω := Ω)) : Ω :=
  (pluckerCoeffMatrix2 (C.B * C.pp.K)).det

@[expose] public def Certificate.apDelta (C : Certificate (Ω := Ω)) : Ω :=
  pluckerCoeff1 (C.B * C.ap.K) 0

@[expose] public def Certificate.aaDelta (C : Certificate (Ω := Ω)) : Ω :=
  pluckerCoeff1 (C.B * C.aa.K) 0

/-- Base change of the full four-piece certificate along a ring map.

`hApp`–`hAaa` say the four emitted action matrices are the character stacks,
which is how they are built; `hpp`, `hap`, `haa` are the three explicit
nonvanishing conditions.  Nothing else about the target field is used. -/
@[expose] public def Certificate.mapRingHom (C : Certificate (Ω := Ω)) (φ : Ω →+* Ω')
    (hApp : C.pp.A = D12PieceAction.characterStack C.RM C.SM 1 1)
    (hApa : C.pa.A = D12PieceAction.characterStack C.RM C.SM 1 (-1))
    (hAap : C.ap.A = D12PieceAction.characterStack C.RM C.SM (-1) 1)
    (hAaa : C.aa.A = D12PieceAction.characterStack C.RM C.SM (-1) (-1))
    (hpp : φ C.ppDet ≠ 0) (hap : φ C.apDelta ≠ 0) (haa : φ C.aaDelta ≠ 0) :
    Certificate (Ω := Ω') where
  P := C.P.map φ
  R := C.R.map φ
  F := C.F.map φ
  B := C.B.map φ
  L := C.L.map φ
  RM := C.RM.map φ
  SM := C.SM.map φ
  left_inverse := by
    rw [← Matrix.map_mul, C.left_inverse]
    exact Matrix.map_one φ φ.map_zero φ.map_one
  projector_factor := by
    rw [← Matrix.map_mul, ← Matrix.map_mul, C.projector_factor]
  rot_restrict := by
    rw [← Matrix.map_mul, ← Matrix.map_mul, C.rot_restrict]
  refl_restrict := by
    rw [← Matrix.map_mul, ← Matrix.map_mul, C.refl_restrict]
  pp := by
    have h := C.pp.mapFin2 hApp φ hpp
    simpa only [map_one] using h
  pa := by
    have h := C.pa.mapFin0 hApa φ
    simpa only [map_one, map_neg] using h
  ap := by
    have h := C.ap.mapFin1 hAap φ 0 hap
    simpa only [map_one, map_neg] using h
  aa := by
    have h := C.aa.mapFin1 hAaa φ 0 haa
    simpa only [map_one, map_neg] using h

/-- Along an injective ring map — in particular along any map of fields — the
three nonvanishing conditions are automatic. -/
@[expose] public def Certificate.mapOfInjective (C : Certificate (Ω := Ω)) (φ : Ω →+* Ω')
    (hφ : Function.Injective φ)
    (hApp : C.pp.A = D12PieceAction.characterStack C.RM C.SM 1 1)
    (hApa : C.pa.A = D12PieceAction.characterStack C.RM C.SM 1 (-1))
    (hAap : C.ap.A = D12PieceAction.characterStack C.RM C.SM (-1) 1)
    (hAaa : C.aa.A = D12PieceAction.characterStack C.RM C.SM (-1) (-1))
    (hpp : C.ppDet ≠ 0) (hap : C.apDelta ≠ 0) (haa : C.aaDelta ≠ 0) :
    Certificate (Ω := Ω') :=
  C.mapRingHom φ hApp hApa hAap hAaa
    ((map_ne_zero_iff φ hφ).2 hpp)
    ((map_ne_zero_iff φ hφ).2 hap)
    ((map_ne_zero_iff φ hφ).2 haa)

end CertificateMap

end D12Certificate
end V14Formalization
