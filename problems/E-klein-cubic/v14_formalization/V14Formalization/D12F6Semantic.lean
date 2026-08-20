/-
Copyright (c) 2026 V14Formalization contributors.
Released under Apache 2.0 license.
-/
module

public import V14Formalization.D12U6Semantic

/-!
# Semantic formula for the six-dimensional D12 reflection

The exporter records the reflection by the four-block word `T⁴ST⁷S`, where
`T` is the even Weil operator attached to `Tmat²` and `S` is the Fourier
operator attached to `-Smat`.  This file proves structurally that the word is
`mkRefl reflPt`, provides a polynomial version of the word, and proves that
evaluation at the distinguished eleventh root gives the actual Weil
reflection matrix.
-/

noncomputable section

open Matrix Polynomial

namespace V14Formalization.D12F6Semantic

open Lambda2Coordinates D12U6Support D12U6Fourier D12U6Semantic
open D12PolynomialData D12PolynomialEvaluation

public abbrev SLG := Matrix.SpecialLinearGroup (Fin 2) (ZMod 11)

/-- The actual six-dimensional reflection matrix in the even Weil basis. -/
public abbrev actualF6 : Matrix (Fin 6) (Fin 6) WeilRep.K :=
  LinearMap.toMatrix uBasisCore uBasisCore GeometricV14Carrier.Slin

@[expose] public def T2 : SLG := WeilRep.Tmat ^ 2
def S2p : SLG := -WeilRep.Smat
def reflWord : SLG := T2 ^ 4 * S2p * T2 ^ 7 * S2p

theorem reflWord_eq_mkRefl :
    reflWord = CentralizerN.mkRefl CentralizerN.reflPt := by
  apply Subtype.ext
  ext i j
  fin_cases i <;> fin_cases j <;> decide

theorem S2p_eq_negI_mul_Smat :
    S2p = WeilRepSL2.negI * WeilRep.Smat := by
  apply Subtype.ext
  ext i j
  fin_cases i <;> fin_cases j <;> decide

public theorem weilUHom_T2 :
    WeilHom.weilUHom (E := k) T2 = WeilRep.T_even_b 2 := by
  rw [T2, map_pow]
  change WeilRepSL2.weilU WeilRep.Tmat ^ 2 = WeilRep.T_even_b 2
  rw [WeilRepSL2.weilU_Tmat, pow_two, Module.End.mul_eq_comp,
    ← WeilRep.T_even_b_add]
  norm_num

theorem weilUHom_S2p :
    WeilHom.weilUHom (E := k) S2p = WeilRep.S_even := by
  rw [S2p_eq_negI_mul_Smat, map_mul]
  change WeilRepSL2.weilU WeilRepSL2.negI ∘ₗ
      WeilRepSL2.weilU WeilRep.Smat = WeilRep.S_even
  rw [WeilRepSL2.weilU_negI, WeilRepSL2.weilU_Smat]
  ext f
  simp

public theorem toMatrix_Teven2_eq_T6 :
    LinearMap.toMatrix uBasisCore uBasisCore (WeilRep.T_even_b 2) =
      WeilRep.T6 := by
  have hinv : (2 : ZMod 11)⁻¹ = 6 :=
    inv_eq_of_mul_eq_one_right (by decide)
  ext i j
  simp only [LinearMap.toMatrix_apply, uBasisCore]
  change GeometricFanoCarrier.evalEven
      (WeilRep.T_even_b 2 (uBasisCore j)) i = WeilRep.T6 i j
  rw [D12U6Fourier.uBasisCore_apply]
  simp [GeometricFanoCarrier.evalEven, WeilLambda2.evalEven,
    WeilRep.T_even_b, WeilRep.Tfull_b,
    GeometricFanoCarrier.extendEven, WeilLambda2.extendEven,
    GeometricFanoCarrier.extendEvenFun, WeilLambda2.extendEvenFun,
    WeilRep.T6, WeilRep.twoInv, WeilRep.ψ_apply, hinv]
  fin_cases i <;> fin_cases j <;>
    norm_num [Matrix.diagonal_apply, Pi.single_apply]
  all_goals norm_num [ZMod.val_ofNat, ZMod.val_natCast, ZMod.val_one]

/-- The actual Weil reflection matrix is the word recorded by the exporter. -/
public theorem actualF6_eq_wordMatrix :
    actualF6 =
      WeilRep.T6 ^ 4 * WeilRep.S6 * WeilRep.T6 ^ 7 * WeilRep.S6 := by
  rw [show actualF6 =
      LinearMap.toMatrix uBasisCore uBasisCore
        (WeilHom.weilUHom (CentralizerN.mkRefl CentralizerN.reflPt)) from rfl]
  rw [← reflWord_eq_mkRefl]
  unfold reflWord
  have hlin :
      WeilHom.weilUHom (E := k) (T2 ^ 4 * S2p * T2 ^ 7 * S2p) =
        (WeilHom.weilUHom T2) ^ 4 * WeilHom.weilUHom S2p *
          (WeilHom.weilUHom T2) ^ 7 * WeilHom.weilUHom S2p := by
    simp only [map_mul, map_pow]
  rw [hlin]
  rw [LinearMap.toMatrix_mul, LinearMap.toMatrix_mul,
    LinearMap.toMatrix_mul, ← LinearMap.toMatrix_pow,
    ← LinearMap.toMatrix_pow]
  rw [weilUHom_S2p, weilUHom_T2,
    D12U6Fourier.toMatrix_Seven_eq_S6, toMatrix_Teven2_eq_T6]

/-- Closed entry formula for the actual reflection. -/
@[expose] public def directValue (i j : Fin 6) : WeilRep.K :=
  -WeilRep.cFourier * WeilRep.ψ (2 * (i.val : ZMod 11) ^ 2) *
    (if j = 0 then 1 else
      WeilRep.ψ (9 * (j.val : ZMod 11) ^ 2) *
        (WeilRep.ψ (4 * (i.val : ZMod 11) * (j.val : ZMod 11)) +
          WeilRep.ψ (-(4 * (i.val : ZMod 11) * (j.val : ZMod 11)))))

private theorem chi2_three : (WeilRep.χ₂ (E := k)) (3 : ZMod 11) = 1 := by
  have h := WeilRep.card_sq_eq (E := k) (3 : ZMod 11)
  have hcard : ((Finset.univ.filter
      (fun x : ZMod 11 => x ^ 2 = 3)).card : WeilRep.K) = 2 := by
    rw [show Finset.univ.filter (fun x : ZMod 11 => x ^ 2 = 3) =
      {5, 6} by decide]
    rw [show ({5, 6} : Finset (ZMod 11)).card = 2 by decide]
    norm_num
  rw [hcard] at h
  calc
    (WeilRep.χ₂ (E := k)) (3 : ZMod 11) = WeilRep.χ₂ (3 : ZMod 11) + 1 - 1 := by ring
    _ = 2 - 1 := by rw [← h]
    _ = 1 := by ring

public theorem actualF6_apply_eq_directValue (i j : Fin 6) :
    actualF6 i j = directValue i j := by
  classical
  simp only [actualF6, LinearMap.toMatrix_apply, uBasisCore]
  change GeometricFanoCarrier.evalEven
      (GeometricV14Carrier.Slin (uBasisCore j)) i = directValue i j
  rw [uBasisCore_apply]
  change WeilRepSL2.weilFun
      (CentralizerN.mkRefl CentralizerN.reflPt)
      (GeometricFanoCarrier.extendEven (Pi.single j 1)).1
      (i.val : ZMod 11) = directValue i j
  have hc : WeilRepSL2.ec
      (CentralizerN.mkRefl CentralizerN.reflPt) ≠ 0 := by
    decide
  rw [WeilHom.weilFun_of_big hc]
  simp only [WeilRepSL2.bigCellPos, LinearMap.neg_apply,
    LinearMap.comp_apply, WeilRepSL2.Nfull, WeilRepSL2.Wfull,
    WeilRep.Tfull_b, WeilRep.Sfull, WeilRepSL2.Dfull,
    LinearMap.coe_mk, AddHom.coe_mk]
  have ha : WeilRepSL2.ea (CentralizerN.mkRefl CentralizerN.reflPt) *
      (WeilRepSL2.ec (CentralizerN.mkRefl CentralizerN.reflPt))⁻¹ = 4 := by
    have hinv : (3 : ZMod 11)⁻¹ = 4 :=
      inv_eq_of_mul_eq_one_right (by decide)
    simp [WeilRepSL2.ea, WeilRepSL2.ec, CentralizerN.mkRefl,
      CentralizerN.reflPt, hinv]
  have hcval : WeilRepSL2.ec
      (CentralizerN.mkRefl CentralizerN.reflPt) = 3 := by
    decide
  have hd :
      (WeilRepSL2.ec (CentralizerN.mkRefl CentralizerN.reflPt))⁻¹ *
        WeilRepSL2.ed (CentralizerN.mkRefl CentralizerN.reflPt) = 7 := by
    have hinv : (3 : ZMod 11)⁻¹ = 4 :=
      inv_eq_of_mul_eq_one_right (by decide)
    change (3 : ZMod 11)⁻¹ * (-1) = 7
    rw [hinv]
    decide
  rw [ha, hd, hcval, chi2_three]
  simp only [Pi.neg_apply, one_mul,
    GeometricFanoCarrier.extendEven, WeilLambda2.extendEven,
    LinearMap.coe_mk, AddHom.coe_mk]
  simp_rw [extendEven_single_apply]
  have hpos (x : ZMod 11) :
      3 * x = (j.val : ZMod 11) ↔ x = 4 * (j.val : ZMod 11) := by
    constructor <;> intro h
    · calc x = 1 * x := by simp
        _ = (4 * 3 : ZMod 11) * x := by
          rw [show (4 : ZMod 11) * 3 = 1 by decide]
        _ = 4 * (3 * x) := by ring
        _ = 4 * (j.val : ZMod 11) := by rw [h]
    · rw [h]
      calc 3 * (4 * (j.val : ZMod 11)) =
          (3 * 4 : ZMod 11) * (j.val : ZMod 11) := by ring
        _ = 1 * (j.val : ZMod 11) := by
          rw [show (3 : ZMod 11) * 4 = 1 by decide]
        _ = (j.val : ZMod 11) := one_mul _
  have hneg (x : ZMod 11) :
      3 * x = -(j.val : ZMod 11) ↔
        x = -(4 * (j.val : ZMod 11)) := by
    constructor <;> intro h
    · calc x = 1 * x := by simp
        _ = (4 * 3 : ZMod 11) * x := by
          rw [show (4 : ZMod 11) * 3 = 1 by decide]
        _ = 4 * (3 * x) := by ring
        _ = 4 * (-(j.val : ZMod 11)) := by rw [h]
        _ = -(4 * (j.val : ZMod 11)) := by ring
    · rw [h]
      calc 3 * (-(4 * (j.val : ZMod 11))) =
          -((3 * 4 : ZMod 11) * (j.val : ZMod 11)) := by ring
        _ = -(1 * (j.val : ZMod 11)) := by
          rw [show (3 : ZMod 11) * 4 = 1 by decide]
        _ = -(j.val : ZMod 11) := by rw [one_mul]
  simp_rw [hpos, hneg]
  simp_rw [mul_ite, mul_one, mul_zero]
  have hinv2 : (2 : ZMod 11)⁻¹ = 6 :=
    inv_eq_of_mul_eq_one_right (by decide)
  have houter (z : ZMod 11) :
      4 * z ^ 2 * WeilRep.twoInv = 2 * z ^ 2 := by
    rw [WeilRep.twoInv, hinv2]
    calc
      4 * z ^ 2 * 6 = (24 : ZMod 11) * z ^ 2 := by ring
      _ = 2 * z ^ 2 := by rw [show (24 : ZMod 11) = 2 by decide]
  have hinner (z : ZMod 11) :
      7 * z ^ 2 * WeilRep.twoInv = 9 * z ^ 2 := by
    rw [WeilRep.twoInv, hinv2]
    calc
      7 * z ^ 2 * 6 = (42 : ZMod 11) * z ^ 2 := by ring
      _ = 9 * z ^ 2 := by rw [show (42 : ZMod 11) = 9 by decide]
  by_cases hj : j = 0
  · subst j
    simp only [Fin.val_zero, Nat.cast_zero, mul_zero, neg_zero]
    have hsum : (∑ x : ZMod 11,
        if x = 0 then (WeilRep.ψ (E := k)) ((i.val : ZMod 11) * x) *
          WeilRep.ψ (7 * (3 * x) ^ 2 * WeilRep.twoInv)
        else if x = 0 then WeilRep.ψ ((i.val : ZMod 11) * x) *
          WeilRep.ψ (7 * (3 * x) ^ 2 * WeilRep.twoInv) else 0) = 1 := by
      calc
        _ = (∑ x : ZMod 11,
            if x = 0 then (WeilRep.ψ (E := k)) ((i.val : ZMod 11) * x) *
              WeilRep.ψ (7 * (3 * x) ^ 2 * WeilRep.twoInv) else 0) := by
          apply Finset.sum_congr rfl
          intro x _
          by_cases hx : x = 0 <;> simp [hx]
        _ = (WeilRep.ψ (E := k)) ((i.val : ZMod 11) * 0) *
              WeilRep.ψ (7 * (3 * 0) ^ 2 * WeilRep.twoInv) := by
          rw [sum_indicator_one]
        _ = 1 := by simp
    rw [hsum, houter]
    simp [directValue]
    ring
  · have hjval : (j.val : ZMod 11) ≠ 0 := by
      intro h
      apply hj
      apply Fin.ext
      have hval := congrArg ZMod.val h
      simpa [ZMod.val_cast_of_lt
        (Nat.lt_trans j.isLt (by decide : 6 < 11))] using hval
    have hfourj : -(4 * (j.val : ZMod 11)) ≠
        4 * (j.val : ZMod 11) := by
      intro h
      have : (8 : ZMod 11) * (j.val : ZMod 11) = 0 := by
        calc
          8 * (j.val : ZMod 11) =
              4 * (j.val : ZMod 11) - (-(4 * (j.val : ZMod 11))) := by ring
          _ = 0 := by rw [h]; simp
      exact hjval ((mul_eq_zero.mp this).resolve_left (by decide))
    rw [sum_indicator_two
      (4 * (j.val : ZMod 11)) (-(4 * (j.val : ZMod 11))) hfourj]
    unfold directValue
    rw [if_neg hj]
    have h3pos : 3 * (4 * (j.val : ZMod 11)) = (j.val : ZMod 11) := by
      calc
        3 * (4 * (j.val : ZMod 11)) =
            (3 * 4 : ZMod 11) * (j.val : ZMod 11) := by ring
        _ = 1 * (j.val : ZMod 11) := by
          rw [show (3 : ZMod 11) * 4 = 1 by decide]
        _ = (j.val : ZMod 11) := one_mul _
    have h3neg : 3 * (-(4 * (j.val : ZMod 11))) =
        -(j.val : ZMod 11) := by
      rw [mul_neg, h3pos]
    have hfourierPos :
        (i.val : ZMod 11) * (4 * (j.val : ZMod 11)) =
          4 * (i.val : ZMod 11) * (j.val : ZMod 11) := by ring
    have hfourierNeg :
        (i.val : ZMod 11) * (-(4 * (j.val : ZMod 11))) =
          -(4 * (i.val : ZMod 11) * (j.val : ZMod 11)) := by ring
    have hsqneg : (-(j.val : ZMod 11)) ^ 2 =
        (j.val : ZMod 11) ^ 2 := by ring
    rw [h3pos, h3neg, hsqneg, hinner,
      hfourierPos, hfourierNeg, houter]
    ring

/-- Polynomial encoding of the closed reflection entry formula. -/
@[expose] public def directEntryPoly (i j : Fin 6) : Polynomial ℚ :=
  -cFourierPoly * phasePoly (2 * (i.val : ZMod 11) ^ 2) *
    (if j = 0 then 1 else
      phasePoly (9 * (j.val : ZMod 11) ^ 2) *
        (phasePoly (4 * (i.val : ZMod 11) * (j.val : ZMod 11)) +
          phasePoly (-(4 * (i.val : ZMod 11) * (j.val : ZMod 11)))))

public theorem eval_directEntryPoly (i j : Fin 6) :
    evalPolyAt WeilRep.ζ (directEntryPoly i j) = directValue i j := by
  by_cases hj : j = 0 <;>
    simp [directEntryPoly, directValue, hj, eval_cFourierPoly, eval_phasePoly]

end V14Formalization.D12F6Semantic
