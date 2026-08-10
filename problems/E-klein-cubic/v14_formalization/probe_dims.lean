import V14Formalization.GeometricV14Carrier
import Mathlib.RingTheory.AdjoinRoot
import Mathlib.LinearAlgebra.Dimension.Constructions
import Mathlib.LinearAlgebra.FreeModule.Finite.Basic
import Mathlib.LinearAlgebra.FiniteDimensional.Lemmas
import Mathlib.RingTheory.PrincipalIdealDomain
import Mathlib.Algebra.Polynomial.Eval.Defs
import Mathlib.Data.Finsupp.Basic

open Polynomial Module LinearMap AdjoinRoot
open V14Formalization.GeometricV14Carrier

set_option maxHeartbeats 32000000
noncomputable section

theorem finrank_residualKer_ge_two : 2 ≤ Module.finrank k residualKer := by
  classical
  haveI : Module.Finite k U := inferInstance
  haveI : Module.Finite k residualKer := inferInstance
  obtain ⟨u, hu, hune⟩ := Submodule.exists_mem_ne_zero_of_ne_bot residualKer_ne_bot
  have hR2add : Rlin (Rlin u) + u = 0 := (mem_residualKer_iff).mp hu
  have hli := residual_pair_independent hune hR2add
  have hRu : Rlin u ∈ residualKer := residualKer_R_stable hu
  let S : Submodule k U := Submodule.span k (Set.range ![u, Rlin u])
  have hSle : S ≤ residualKer := by
    apply Submodule.span_le.mpr
    intro x hx
    obtain ⟨i, rfl⟩ := hx
    fin_cases i <;> [exact hu; exact hRu]
  have hSdim : Module.finrank k S = 2 := by
    simpa using (finrank_span_eq_card hli)
  have hle := Submodule.finrank_mono hSle
  omega

theorem finrank_residual_add_Wker :
    Module.finrank k residualKer + Module.finrank k Wker = 6 := by
  classical
  haveI : Module.Finite k U := inferInstance
  have h := Submodule.finrank_add_eq_of_isCompl (V := U) isCompl_residualKer_Wker
  have hU : Module.finrank k U = 6 :=
    V14Formalization.GeometricFanoCarrier.finrank_U
  rwa [hU] at h

theorem aeval_Rlin_pW_apply {w : U} (hw : w ∈ Wker) :
    aeval (Rlin : Module.End k U) pW w = 0 := by
  dsimp [Wker, pW] at hw
  exact LinearMap.mem_ker.mp hw

theorem Rpow_mem_Wker (w : U) (hw : w ∈ Wker) (n : ℕ) :
    ((Rlin : Module.End k U) ^ n) w ∈ Wker := by
  induction n with
  | zero => simpa [pow_zero, Module.End.one_eq_id] using hw
  | succ n ih =>
    -- R^{n+1} w = R (R^n w)
    have : (Rlin ^ (n + 1) : Module.End k U) =
        Rlin * (Rlin ^ n) := (pow_succ' Rlin n)
    rw [this, Module.End.mul_eq_comp, LinearMap.comp_apply]
    exact Rlin_mem_Wker ih

theorem linearIndependent_Rpow_Wker {w : U} (hw : w ∈ Wker) (hwne : w ≠ 0) :
    LinearIndependent k fun i : Fin 4 => ((Rlin : Module.End k U) ^ (i : ℕ)) w := by
  rw [Fintype.linearIndependent_iff]
  intro s hs
  let q : k[X] := ∑ i : Fin 4, monomial (i : ℕ) (s i)
  have haq : aeval (Rlin : Module.End k U) q w = 0 := by
    calc aeval (Rlin : Module.End k U) q w
        = (∑ i : Fin 4,
            aeval (Rlin : Module.End k U) (monomial (i : ℕ) (s i))) w := by
          simp only [q, map_sum]
      _ = ∑ i : Fin 4,
            aeval (Rlin : Module.End k U) (monomial (i : ℕ) (s i)) w := by
          simp only [LinearMap.coeFn_sum, Finset.sum_apply]
      _ = ∑ i : Fin 4, s i • ((Rlin : Module.End k U) ^ (i : ℕ)) w := by
          refine Finset.sum_congr rfl fun i _ => ?_
          rw [aeval_monomial]
          simp only [Algebra.algebraMap_eq_smul_one, Module.End.one_eq_id,
            Module.End.mul_eq_comp, LinearMap.comp_apply, LinearMap.smul_apply,
            LinearMap.id_apply]
      _ = 0 := hs
  have hpW : aeval (Rlin : Module.End k U) pW w = 0 := aeval_Rlin_pW_apply hw
  by_cases hq0 : q = 0
  · intro i
    have hci : q.coeff i.val = s i := by
      simp only [q, finsetSum_coeff]
      rw [Finset.sum_eq_single i]
      · simp [coeff_monomial]
      · intro j _ hj
        rw [coeff_monomial]
        split_ifs with h
        · exact absurd (Fin.eq_of_val_eq h) hj
        · rfl
      · intro; exact absurd (Finset.mem_univ _) (by assumption)
    have : s i = 0 := by rw [← hci, hq0, coeff_zero]
    exact this
  · have hndvd : ¬ pW ∣ q := by
      intro hdiv
      have hle := natDegree_le_of_dvd hdiv hq0
      have hpw : pW.natDegree = 4 := natDegree_X4_sub_X2_add_one
      have hqle : q.natDegree ≤ 3 := by
        refine (natDegree_sum_le _ _).trans ?_
        apply Finset.sup_le
        intro i _
        calc (monomial (i.val) (s i)).natDegree
            ≤ i.val := natDegree_monomial_le _
          _ ≤ 3 := Nat.lt_succ_iff.mp i.isLt
      omega
    have hcop : IsCoprime pW q := by
      rcases dvd_or_isCoprime pW q irreducible_X4_sub_X2_add_one with h | h
      · exact absurd h hndvd
      · exact h
    obtain ⟨a, b, hab⟩ := hcop
    have hw0 : w = 0 := by
      have h1 : aeval (Rlin : Module.End k U) (1 : k[X]) w = 0 := by
        have hab' : aeval (Rlin : Module.End k U) (a * pW + b * q) w =
            aeval (Rlin : Module.End k U) (1 : k[X]) w := by rw [hab]
        rw [← hab']
        have hA : aeval (Rlin : Module.End k U) (a * pW) w = 0 := by
          rw [map_mul, Module.End.mul_eq_comp, LinearMap.comp_apply, hpW, map_zero]
        have hB : aeval (Rlin : Module.End k U) (b * q) w = 0 := by
          rw [map_mul, Module.End.mul_eq_comp, LinearMap.comp_apply, haq, map_zero]
        simp only [map_add, LinearMap.add_apply, hA, hB, add_zero]
      simpa [map_one, Module.End.one_eq_id, LinearMap.id_apply] using h1
    exact absurd hw0 hwne

theorem finrank_Wker_ge_four : 4 ≤ Module.finrank k Wker := by
  classical
  haveI : Module.Finite k U := inferInstance
  haveI : Module.Finite k Wker := inferInstance
  obtain ⟨w0, hw0, hw0ne⟩ := Submodule.exists_mem_ne_zero_of_ne_bot Wker_ne_bot
  have hind := linearIndependent_Rpow_Wker hw0 hw0ne
  have hspan_dim :
      Module.finrank k
        (Submodule.span k (Set.range fun i : Fin 4 =>
          ((Rlin : Module.End k U) ^ (i : ℕ)) w0)) = 4 := by
    simpa using (finrank_span_eq_card hind)
  have hspan_le :
      Submodule.span k (Set.range fun i : Fin 4 =>
          ((Rlin : Module.End k U) ^ (i : ℕ)) w0) ≤ Wker := by
    apply Submodule.span_le.mpr
    intro x hx
    obtain ⟨i, rfl⟩ := hx
    exact Rpow_mem_Wker w0 hw0 i
  have hle := Submodule.finrank_mono hspan_le
  omega

theorem finrank_residualKer_eq_two : Module.finrank k residualKer = 2 := by
  have hsum := finrank_residual_add_Wker
  have hr := finrank_residualKer_ge_two
  have hw := finrank_Wker_ge_four
  omega

theorem finrank_Wker_eq_four : Module.finrank k Wker = 4 := by
  have hsum := finrank_residual_add_Wker
  have hr := finrank_residualKer_eq_two
  omega

#print axioms finrank_residualKer_ge_two
#print axioms finrank_Wker_ge_four
#print axioms finrank_residualKer_eq_two
#print axioms finrank_Wker_eq_four
#print axioms linearIndependent_Rpow_Wker
