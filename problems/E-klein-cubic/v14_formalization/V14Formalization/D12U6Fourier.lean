/-
Copyright (c) 2026 V14Formalization contributors.
Released under Apache 2.0 license.
-/
module

public import V14Formalization.D12U6Support

/-!
# Fourier matrix on the even Weil basis

The six-dimensional basis is obtained by extending functions evenly on
`ZMod 11`.  The lemmas below evaluate that extension and reduce Fourier sums
to one or two supported terms.
-/

noncomputable section

open Matrix

namespace V14Formalization.D12U6Fourier

open Lambda2Coordinates D12U6Support

theorem evalEvenEquivCore_symm_apply (v : Fin 6 → WeilRep.K) :
    evalEvenEquivCore.symm v = GeometricFanoCarrier.extendEven v := by
  apply GeometricFanoCarrier.evalEven_injective
  exact (evalEvenEquivCore.apply_symm_apply v).trans
    (LinearMap.congr_fun GeometricFanoCarrier.evalEven_extendEven v).symm

public theorem uBasisCore_apply (j : Fin 6) :
    uBasisCore j = GeometricFanoCarrier.extendEven (Pi.single j 1) := by
  rw [uBasisCore, Module.Basis.coe_ofEquivFun]
  exact evalEvenEquivCore_symm_apply _

public theorem sum_indicator_one (a : ZMod 11) (f : ZMod 11 → WeilRep.K) :
    (∑ x : ZMod 11, if x = a then f x else 0) = f a := by
  classical
  rw [Finset.sum_eq_single a]
  · simp
  · intro b _ hb
    simp [hb]
  · simp

public theorem sum_indicator_two (a b : ZMod 11) (hba : b ≠ a)
    (f : ZMod 11 → WeilRep.K) :
    (∑ x : ZMod 11,
      if x = a then f x else if x = b then f x else 0) = f a + f b := by
  classical
  calc
    (∑ x : ZMod 11,
      if x = a then f x else if x = b then f x else 0) =
        (∑ x : ZMod 11, if x = a then f x else 0) +
          (∑ x : ZMod 11, if x = b then f x else 0) := by
      rw [← Finset.sum_add_distrib]
      apply Finset.sum_congr rfl
      intro x _
      by_cases hxa : x = a
      · subst x
        simp [hba.symm]
      · by_cases hxb : x = b
        · subst x
          simp [hba]
        · simp [hxa, hxb]
    _ = f a + f b := by rw [sum_indicator_one, sum_indicator_one]

public theorem toMatrix_Seven_eq_S6 :
    LinearMap.toMatrix uBasisCore uBasisCore WeilRep.S_even = WeilRep.S6 := by
  classical
  ext i j
  simp only [LinearMap.toMatrix_apply, uBasisCore]
  change GeometricFanoCarrier.evalEven
      (WeilRep.S_even (uBasisCore j)) i = WeilRep.S6 i j
  rw [uBasisCore_apply]
  simp only [GeometricFanoCarrier.evalEven, WeilRep.S_even, WeilRep.Sfull,
    LinearMap.coe_mk, AddHom.coe_mk, GeometricFanoCarrier.extendEven,
    WeilRep.S6, Matrix.of_apply]
  simp_rw [extendEven_single_apply]
  simp_rw [mul_ite, mul_one, mul_zero]
  by_cases hj : j = 0
  · subst j
    simp only [Fin.val_zero, Nat.cast_zero, neg_zero, if_pos]
    have hsum : (∑ x : ZMod 11,
        if x = 0 then WeilRep.ψ ((i.val : ZMod 11) * x)
        else if x = 0 then WeilRep.ψ ((i.val : ZMod 11) * x) else 0) =
          WeilRep.ψ ((i.val : ZMod 11) * 0) := by
      calc
        (∑ x : ZMod 11,
          if x = 0 then WeilRep.ψ ((i.val : ZMod 11) * x)
          else if x = 0 then WeilRep.ψ ((i.val : ZMod 11) * x) else 0) =
            (∑ x : ZMod 11,
              if x = 0 then WeilRep.ψ ((i.val : ZMod 11) * x) else 0) := by
                apply Finset.sum_congr rfl
                intro x _
                by_cases hx : x = 0 <;> simp [hx]
        _ = WeilRep.ψ ((i.val : ZMod 11) * 0) := sum_indicator_one 0 _
    rw [hsum]
    simp
  · have hjval : (j.val : ZMod 11) ≠ 0 := by
      intro h
      apply hj
      apply Fin.ext
      have hval := congrArg ZMod.val h
      simpa [ZMod.val_cast_of_lt
        (Nat.lt_trans j.isLt (by decide : 6 < 11))] using hval
    have hjneg : -(j.val : ZMod 11) ≠ (j.val : ZMod 11) := by
      intro h
      have htwo : (2 : ZMod 11) * (j.val : ZMod 11) = 0 := by
        rw [show (2 : ZMod 11) * (j.val : ZMod 11) =
          (j.val : ZMod 11) - (-(j.val : ZMod 11)) by ring, h]
        simp
      exact hjval ((mul_eq_zero.mp htwo).resolve_left (by decide))
    have hjNat : j.val ≠ 0 := by
      intro h
      apply hj
      exact Fin.ext h
    rw [if_neg hjNat]
    rw [sum_indicator_two (j.val : ZMod 11) (-(j.val : ZMod 11)) hjneg
      (fun x => WeilRep.ψ ((i.val : ZMod 11) * x))]
    rw [show (i.val : ZMod 11) * -(j.val : ZMod 11) =
      -((i.val : ZMod 11) * (j.val : ZMod 11)) by ring]

end V14Formalization.D12U6Fourier
