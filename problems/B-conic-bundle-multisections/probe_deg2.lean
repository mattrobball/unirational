import Mathlib.Algebra.BigOperators.Fin
import Mathlib.Data.Finsupp.Defs
import Mathlib.Data.Finsupp.Single
import Mathlib.Tactic.IntervalCases
import Mathlib.Tactic.FinCases

open Finsupp

theorem degree_two_cases (s : Fin 3 →₀ ℕ)
    (h : ∑ i : Fin 3, s i = 2) :
    s = single (0 : Fin 3) 2 ∨ s = single (1 : Fin 3) 2 ∨ s = single (2 : Fin 3) 2 ∨
      s = single (0 : Fin 3) 1 + single (1 : Fin 3) 1 ∨
        s = single (0 : Fin 3) 1 + single (2 : Fin 3) 1 ∨
          s = single (1 : Fin 3) 1 + single (2 : Fin 3) 1 := by
  have hsum : s 0 + s 1 + s 2 = 2 := by
    rwa [Fin.sum_univ_three (fun i => s i)] at h
  have hs0 : s 0 ≤ 2 := by omega
  have hs1 : s 1 ≤ 2 := by omega
  have hs2 : s 2 ≤ 2 := by omega
  interval_cases h0 : s 0 <;> interval_cases h1 : s 1 <;> interval_cases h2 : s 2
  · omega
  · omega
  · -- 002
    refine Or.inr (Or.inr (Or.inl ?_))
    ext i; fin_cases i
    · exact h0.trans (by simp)
    · exact h1.trans (by simp)
    · exact h2.trans (by simp)
  · omega
  · -- 011
    refine Or.inr (Or.inr (Or.inr (Or.inr (Or.inr ?_))))
    ext i; fin_cases i
    · exact h0.trans (by simp [Finsupp.add_apply, single_apply])
    · exact h1.trans (by simp [Finsupp.add_apply, single_apply])
    · exact h2.trans (by simp [Finsupp.add_apply, single_apply])
  · omega
  · -- 020
    refine Or.inr (Or.inl ?_)
    ext i; fin_cases i
    · exact h0.trans (by simp)
    · exact h1.trans (by simp)
    · exact h2.trans (by simp)
  · omega
  · omega
  · omega
  · -- 101
    refine Or.inr (Or.inr (Or.inr (Or.inr (Or.inl ?_))))
    ext i; fin_cases i
    · exact h0.trans (by simp [Finsupp.add_apply, single_apply])
    · exact h1.trans (by simp [Finsupp.add_apply, single_apply])
    · exact h2.trans (by simp [Finsupp.add_apply, single_apply])
  · omega
  · -- 110
    refine Or.inr (Or.inr (Or.inr (Or.inl ?_)))
    ext i; fin_cases i
    · exact h0.trans (by simp [Finsupp.add_apply, single_apply])
    · exact h1.trans (by simp [Finsupp.add_apply, single_apply])
    · exact h2.trans (by simp [Finsupp.add_apply, single_apply])
  · omega
  · omega
  · omega
  · omega
  · omega
  · -- 200
    refine Or.inl ?_
    ext i; fin_cases i
    · exact h0.trans (by simp)
    · exact h1.trans (by simp)
    · exact h2.trans (by simp)
  · omega
  · omega
  · omega
  · omega
  · omega
  · omega
  · omega
  · omega
  · omega

#print axioms degree_two_cases
