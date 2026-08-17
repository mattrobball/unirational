/-
Copyright (c) 2026 V14Formalization contributors.
Released under Apache 2.0 license.
-/
module

public import V14Formalization.D12CyclotomicVecZ

/-!
# Shared introduction lemmas for generated scale certificates

The generated `*_scale_*` lemmas proved `toVec v = (s : ℚ) • w` by
`funext` + `fin_cases` on each of the ten coordinates.  `fin_cases`
inlines a `List.Mem.casesOn` over `List.finRange 10` with `HEq` motives
into every proof term, and each `SplitRow` module contains ~4,200 such
coordinate cases.  The lemmas below prove that case split once, so each
generated proof becomes a single application whose leaves are the small
per-coordinate arithmetic certificates.
-/

namespace V14Formalization.D12CyclotomicVecZ

open V14Formalization.D12CyclotomicVec

/-- Coordinatewise scaled equality gives the `Vec`-level equality.
Replaces a per-lemma `funext` + `fin_cases` with one shared case split. -/
public theorem toVec_eq_smul10 (v : VecZ) (s : ℤ) (w : Vec)
    (h0 : ((v[0] : ℤ) : ℚ) = (s : ℚ) * w 0)
    (h1 : ((v[1] : ℤ) : ℚ) = (s : ℚ) * w 1)
    (h2 : ((v[2] : ℤ) : ℚ) = (s : ℚ) * w 2)
    (h3 : ((v[3] : ℤ) : ℚ) = (s : ℚ) * w 3)
    (h4 : ((v[4] : ℤ) : ℚ) = (s : ℚ) * w 4)
    (h5 : ((v[5] : ℤ) : ℚ) = (s : ℚ) * w 5)
    (h6 : ((v[6] : ℤ) : ℚ) = (s : ℚ) * w 6)
    (h7 : ((v[7] : ℤ) : ℚ) = (s : ℚ) * w 7)
    (h8 : ((v[8] : ℤ) : ℚ) = (s : ℚ) * w 8)
    (h9 : ((v[9] : ℤ) : ℚ) = (s : ℚ) * w 9) :
    toVec v = (s : ℚ) • w := by
  funext i
  match i with
  | ⟨0, _⟩ => exact h0
  | ⟨1, _⟩ => exact h1
  | ⟨2, _⟩ => exact h2
  | ⟨3, _⟩ => exact h3
  | ⟨4, _⟩ => exact h4
  | ⟨5, _⟩ => exact h5
  | ⟨6, _⟩ => exact h6
  | ⟨7, _⟩ => exact h7
  | ⟨8, _⟩ => exact h8
  | ⟨9, _⟩ => exact h9
  | ⟨n + 10, h⟩ => exact absurd h (by omega)

/-- Case split over `Fin 20`, proved once; replaces per-selector `fin_cases`. -/
public theorem forall_fin20 {P : Fin 20 → Prop}
    (h0 : P 0) (h1 : P 1) (h2 : P 2) (h3 : P 3) (h4 : P 4)
    (h5 : P 5) (h6 : P 6) (h7 : P 7) (h8 : P 8) (h9 : P 9)
    (h10 : P 10) (h11 : P 11) (h12 : P 12) (h13 : P 13) (h14 : P 14)
    (h15 : P 15) (h16 : P 16) (h17 : P 17) (h18 : P 18) (h19 : P 19) :
    ∀ k, P k := by
  intro k
  match k with
  | ⟨0, _⟩ => exact h0
  | ⟨1, _⟩ => exact h1
  | ⟨2, _⟩ => exact h2
  | ⟨3, _⟩ => exact h3
  | ⟨4, _⟩ => exact h4
  | ⟨5, _⟩ => exact h5
  | ⟨6, _⟩ => exact h6
  | ⟨7, _⟩ => exact h7
  | ⟨8, _⟩ => exact h8
  | ⟨9, _⟩ => exact h9
  | ⟨10, _⟩ => exact h10
  | ⟨11, _⟩ => exact h11
  | ⟨12, _⟩ => exact h12
  | ⟨13, _⟩ => exact h13
  | ⟨14, _⟩ => exact h14
  | ⟨15, _⟩ => exact h15
  | ⟨16, _⟩ => exact h16
  | ⟨17, _⟩ => exact h17
  | ⟨18, _⟩ => exact h18
  | ⟨19, _⟩ => exact h19
  | ⟨n + 20, h⟩ => exact absurd h (by omega)

/-- Case split over `Fin 10`, proved once. -/
public theorem forall_fin10 {P : Fin 10 → Prop}
    (h0 : P 0) (h1 : P 1) (h2 : P 2) (h3 : P 3) (h4 : P 4)
    (h5 : P 5) (h6 : P 6) (h7 : P 7) (h8 : P 8) (h9 : P 9) :
    ∀ k, P k := by
  intro k
  match k with
  | ⟨0, _⟩ => exact h0
  | ⟨1, _⟩ => exact h1
  | ⟨2, _⟩ => exact h2
  | ⟨3, _⟩ => exact h3
  | ⟨4, _⟩ => exact h4
  | ⟨5, _⟩ => exact h5
  | ⟨6, _⟩ => exact h6
  | ⟨7, _⟩ => exact h7
  | ⟨8, _⟩ => exact h8
  | ⟨9, _⟩ => exact h9
  | ⟨n + 10, h⟩ => exact absurd h (by omega)

/-- Case split over `Fin 2`, proved once. -/
public theorem forall_fin2 {P : Fin 2 → Prop} (h0 : P 0) (h1 : P 1) : ∀ k, P k := by
  intro k
  match k with
  | ⟨0, _⟩ => exact h0
  | ⟨1, _⟩ => exact h1
  | ⟨n + 2, h⟩ => exact absurd h (by omega)

/-- Case split over `Fin 1`, proved once. -/
public theorem forall_fin1 {P : Fin 1 → Prop} (h0 : P 0) : ∀ k, P k := by
  intro k
  match k with
  | ⟨0, _⟩ => exact h0
  | ⟨n + 1, h⟩ => exact absurd h (by omega)

/-- Diagonal entry of `matrixOne`, in the literal-vector form the generated
`entry_eq` certificates produce; proved once. -/
public theorem matrixOne_diag10 (i : Fin 10) :
    matrixOne (Fin 10) i i = ![1, 0, 0, 0, 0, 0, 0, 0, 0, 0] := by
  rw [matrixOne, if_pos rfl]
  exact constVec_one_eq

/-- Off-diagonal entry of `matrixOne`, in literal-vector form; proved once. -/
public theorem matrixOne_off10 (i j : Fin 10) (h : i ≠ j) :
    matrixOne (Fin 10) i j = ![0, 0, 0, 0, 0, 0, 0, 0, 0, 0] := by
  rw [matrixOne, if_neg h]
  exact vec_zero_eq

end V14Formalization.D12CyclotomicVecZ
