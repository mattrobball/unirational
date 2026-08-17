/-
Copyright (c) 2026 V14Formalization contributors.
Released under Apache 2.0 license.
-/
module

public import V14Formalization.GeometricV14Carrier
public import V14Formalization.Lambda2Coordinates

/-!
# Sparse support of the even Weil basis

This module isolates the only support calculation needed to identify the
generated six-dimensional D12 rotation matrix with the actual Weil action.
The proof is symbolic and uses no large matrix expansion.
-/

noncomputable section

namespace V14Formalization.D12U6Support

public theorem extendEven_single_apply (j : Fin 6) (x : ZMod 11) :
    GeometricFanoCarrier.extendEvenFun (Pi.single j (1 : WeilRep.K)) x =
      if x = (j.val : ZMod 11) then 1
      else if x = -(j.val : ZMod 11) then 1 else 0 := by
  classical
  unfold GeometricFanoCarrier.extendEvenFun
  by_cases hle : x.val ≤ 5
  · rw [dif_pos hle]
    have hxj : x = (j.val : ZMod 11) ↔
        (⟨x.val, Nat.lt_succ_of_le hle⟩ : Fin 6) = j := by
      constructor
      · intro h
        apply Fin.ext
        have := congrArg ZMod.val h
        simpa [ZMod.val_cast_of_lt
          (Nat.lt_trans j.isLt (by decide : 6 < 11))] using this
      · intro h
        apply ZMod.val_injective
        simpa [ZMod.val_cast_of_lt
          (Nat.lt_trans j.isLt (by decide : 6 < 11))] using congrArg Fin.val h
    by_cases h : x = (j.val : ZMod 11)
    · rw [if_pos h]
      have hfin := hxj.mp h
      simpa [hfin] using (Pi.single_eq_same j (1 : WeilRep.K))
    · rw [if_neg h, Pi.single_eq_of_ne ((not_congr hxj).mp h)]
      have hneg : x ≠ -(j.val : ZMod 11) := by
        intro hn
        have hj0 : (j.val : ZMod 11) ≠ 0 := by
          intro hj
          apply h
          calc
            x = -(j.val : ZMod 11) := hn
            _ = (j.val : ZMod 11) := by rw [hj]; simp
        letI : NeZero (j.val : ZMod 11) := ⟨hj0⟩
        have hval := congrArg ZMod.val hn
        rw [ZMod.val_neg_of_ne_zero (j.val : ZMod 11)] at hval
        rw [ZMod.val_cast_of_lt
          (Nat.lt_trans j.isLt (by decide : 6 < 11))] at hval
        omega
      rw [if_neg hneg]
  · rw [dif_neg hle]
    have hx0 : x ≠ 0 := by
      intro hx
      subst x
      simp at hle
    haveI : NeZero x := ⟨hx0⟩
    have hxj : x = -(j.val : ZMod 11) ↔
        (⟨11 - x.val, by
          have : 6 ≤ x.val := by omega
          have : x.val ≤ 10 := Nat.lt_succ_iff.mp (ZMod.val_lt x)
          omega⟩ : Fin 6) = j := by
      constructor
      · intro h
        have hj0 : (j.val : ZMod 11) ≠ 0 := by
          intro hj
          apply hx0
          rw [h, hj, neg_zero]
        letI : NeZero (j.val : ZMod 11) := ⟨hj0⟩
        apply Fin.ext
        have hval := congrArg ZMod.val h
        rw [ZMod.val_neg_of_ne_zero (j.val : ZMod 11)] at hval
        rw [ZMod.val_cast_of_lt
          (Nat.lt_trans j.isLt (by decide : 6 < 11))] at hval
        change 11 - x.val = j.val
        rw [hval, Nat.sub_sub_self
          (Nat.le_of_lt (Nat.lt_trans j.isLt (by decide : 6 < 11)))]
      · intro h
        have hj0 : (j.val : ZMod 11) ≠ 0 := by
          intro hj
          have hjval : j.val = 0 := by
            have := congrArg ZMod.val hj
            simpa [ZMod.val_cast_of_lt
              (Nat.lt_trans j.isLt (by decide : 6 < 11))] using this
          have hfin := congrArg Fin.val h
          simp [hjval] at hfin
          have hxlt := ZMod.val_lt x
          omega
        letI : NeZero (j.val : ZMod 11) := ⟨hj0⟩
        apply ZMod.val_injective
        rw [ZMod.val_neg_of_ne_zero (j.val : ZMod 11)]
        rw [ZMod.val_cast_of_lt
          (Nat.lt_trans j.isLt (by decide : 6 < 11))]
        have hfin := congrArg Fin.val h
        calc
          x.val = 11 - (11 - x.val) :=
            (Nat.sub_sub_self (Nat.le_of_lt (ZMod.val_lt x))).symm
          _ = 11 - j.val := congrArg (fun m => 11 - m) hfin
    have hpos : x ≠ (j.val : ZMod 11) := by
      intro h
      have hval := congrArg ZMod.val h
      rw [ZMod.val_cast_of_lt
        (Nat.lt_trans j.isLt (by decide : 6 < 11))] at hval
      omega
    rw [if_neg hpos]
    by_cases h : x = -(j.val : ZMod 11)
    · rw [if_pos h]
      have hfin := hxj.mp h
      simpa [hfin] using (Pi.single_eq_same j (1 : WeilRep.K))
    · rw [if_neg h, Pi.single_eq_of_ne ((not_congr hxj).mp h)]

end V14Formalization.D12U6Support
