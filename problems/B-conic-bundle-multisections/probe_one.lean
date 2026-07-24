import Mathlib.Data.Finsupp.Basic
import Mathlib.Tactic.IntervalCases

open Finsupp

example (s : Fin 3 →₀ ℕ) (h0 : s 0 = 0) (h1 : s 1 = 1) (h2 : s 2 = 1) :
    s = single (1 : Fin 3) 1 + single (2 : Fin 3) 1 := by
  ext ⟨i, hi⟩
  interval_cases i
  · simpa [Finsupp.add_apply, single_apply] using h0
  · simpa [Finsupp.add_apply, single_apply] using h1
  · simpa [Finsupp.add_apply, single_apply] using h2

example (s : Fin 3 →₀ ℕ) (h0 : s 0 = 2) (h1 : s 1 = 0) (h2 : s 2 = 0) :
    s = single (0 : Fin 3) 2 := by
  ext ⟨i, hi⟩
  interval_cases i
  · simpa [single_apply] using h0
  · simpa [single_apply] using h1
  · simpa [single_apply] using h2
