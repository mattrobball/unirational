/-
Copyright (c) 2026 V14Formalization contributors.
Released under Apache 2.0 license.
-/
module

public import V14Formalization.D12PolynomialEvaluation
public import V14Formalization.D12U6Fourier

/-!
# Semantic formula for the six-dimensional D12 rotation

This file derives a closed formula for every entry of the actual Weil
rotation matrix.  It then represents that formula by a small polynomial in
the distinguished eleventh root of unity.  Generated finite certificates can
therefore be checked modulo the cyclotomic polynomial, entry by entry.
-/

noncomputable section

open Matrix BigOperators Polynomial

namespace V14Formalization.D12U6Semantic

open Lambda2Coordinates D12U6Fourier D12U6Support
open D12PolynomialData D12PolynomialEvaluation

/-- The actual six-dimensional rotation matrix in the even Weil basis. -/
public abbrev actualU6 : Matrix (Fin 6) (Fin 6) WeilRep.K :=
  LinearMap.toMatrix uBasisCore uBasisCore GeometricV14Carrier.Rlin

/-- Entry formula obtained by evaluating the two supported Fourier terms. -/
@[expose] public def directValue (i j : Fin 6) : WeilRep.K :=
  WeilRep.cFourier * WeilRep.ψ (3 * (i.val : ZMod 11) ^ 2) *
    (if j = 0 then 1 else
      WeilRep.ψ (3 * (j.val : ZMod 11) ^ 2) *
        (WeilRep.ψ (2 * (i.val : ZMod 11) * (j.val : ZMod 11)) +
          WeilRep.ψ (-(2 * (i.val : ZMod 11) * (j.val : ZMod 11)))))

private theorem chi2_six : (WeilRep.χ₂ (E := k)) (6 : ZMod 11) = -1 := by
  have h := WeilRep.card_sq_eq (E := k) (6 : ZMod 11)
  have hcard : ((Finset.univ.filter
      (fun x : ZMod 11 => x ^ 2 = 6)).card : WeilRep.K) = 0 := by
    norm_num
  rw [hcard] at h
  exact eq_neg_of_add_eq_zero_left h.symm

public theorem actualU6_apply_eq_directValue (i j : Fin 6) :
    actualU6 i j = directValue i j := by
  classical
  simp only [actualU6, LinearMap.toMatrix_apply, uBasisCore]
  change GeometricFanoCarrier.evalEven
      (GeometricV14Carrier.Rlin (uBasisCore j)) i = directValue i j
  rw [uBasisCore_apply]
  change WeilRepSL2.weilFun
      (CentralizerN.mkRot CentralizerN.rotPt)
      (GeometricFanoCarrier.extendEven (Pi.single j 1)).1
      (i.val : ZMod 11) = directValue i j
  have hc : WeilRepSL2.ec (CentralizerN.mkRot CentralizerN.rotPt) ≠ 0 := by
    decide
  rw [WeilHom.weilFun_of_big hc]
  simp only [WeilRepSL2.bigCellPos, LinearMap.neg_apply,
    LinearMap.comp_apply, WeilRepSL2.Nfull, WeilRepSL2.Wfull,
    WeilRep.Tfull_b, WeilRep.Sfull, WeilRepSL2.Dfull,
    LinearMap.coe_mk, AddHom.coe_mk]
  have ha : WeilRepSL2.ea (CentralizerN.mkRot CentralizerN.rotPt) *
      (WeilRepSL2.ec (CentralizerN.mkRot CentralizerN.rotPt))⁻¹ = 6 := by
    have hinv : (5 : ZMod 11)⁻¹ = 9 :=
      inv_eq_of_mul_eq_one_right (by decide)
    simp [WeilRepSL2.ea, WeilRepSL2.ec, CentralizerN.mkRot,
      CentralizerN.rotPt, hinv]
    exact (by decide : (-(27 : ZMod 11)) = 6)
  have hcval : WeilRepSL2.ec (CentralizerN.mkRot CentralizerN.rotPt) = 6 := by
    decide
  have hd : (WeilRepSL2.ec (CentralizerN.mkRot CentralizerN.rotPt))⁻¹ *
      WeilRepSL2.ed (CentralizerN.mkRot CentralizerN.rotPt) = 6 := by
    have hinv : (5 : ZMod 11)⁻¹ = 9 :=
      inv_eq_of_mul_eq_one_right (by decide)
    simp [WeilRepSL2.ec, WeilRepSL2.ed, CentralizerN.mkRot,
      CentralizerN.rotPt, hinv]
    exact (by decide : (-(27 : ZMod 11)) = 6)
  rw [ha, hd, hcval, chi2_six]
  simp only [Pi.neg_apply, neg_mul, mul_neg, one_mul, neg_neg,
    GeometricFanoCarrier.extendEven, WeilLambda2.extendEven,
    LinearMap.coe_mk, AddHom.coe_mk]
  simp_rw [extendEven_single_apply]
  have hpos (x : ZMod 11) :
      6 * x = (j.val : ZMod 11) ↔ x = 2 * (j.val : ZMod 11) := by
    constructor <;> intro h
    · calc x = 1 * x := by simp
        _ = (2 * 6 : ZMod 11) * x := by
          rw [show (2 : ZMod 11) * 6 = 1 by decide]
        _ = 2 * (6 * x) := by ring
        _ = 2 * (j.val : ZMod 11) := by rw [h]
    · rw [h]
      calc 6 * (2 * (j.val : ZMod 11)) =
          (6 * 2 : ZMod 11) * (j.val : ZMod 11) := by ring
        _ = 1 * (j.val : ZMod 11) := by
          rw [show (6 : ZMod 11) * 2 = 1 by decide]
        _ = (j.val : ZMod 11) := one_mul _
  have hneg (x : ZMod 11) :
      6 * x = -(j.val : ZMod 11) ↔
        x = -(2 * (j.val : ZMod 11)) := by
    constructor <;> intro h
    · calc x = 1 * x := by simp
        _ = (2 * 6 : ZMod 11) * x := by
          rw [show (2 : ZMod 11) * 6 = 1 by decide]
        _ = 2 * (6 * x) := by ring
        _ = 2 * (-(j.val : ZMod 11)) := by rw [h]
        _ = -(2 * (j.val : ZMod 11)) := by ring
    · rw [h]
      calc 6 * (-(2 * (j.val : ZMod 11))) =
          -((6 * 2 : ZMod 11) * (j.val : ZMod 11)) := by ring
        _ = -(1 * (j.val : ZMod 11)) := by
          rw [show (6 : ZMod 11) * 2 = 1 by decide]
        _ = -(j.val : ZMod 11) := by rw [one_mul]
  simp_rw [hpos, hneg]
  simp_rw [mul_ite, mul_one, mul_zero]
  rw [Finset.sum_neg_distrib]
  simp only [mul_neg, neg_mul, neg_neg]
  have hinv2 : (2 : ZMod 11)⁻¹ = 6 :=
    inv_eq_of_mul_eq_one_right (by decide)
  have hphase (z : ZMod 11) :
      6 * z ^ 2 * WeilRep.twoInv = 3 * z ^ 2 := by
    rw [WeilRep.twoInv, hinv2]
    calc
      6 * z ^ 2 * 6 = (36 : ZMod 11) * z ^ 2 := by ring
      _ = 3 * z ^ 2 := by rw [show (36 : ZMod 11) = 3 by decide]
  by_cases hj : j = 0
  · subst j
    simp only [Fin.val_zero, Nat.cast_zero, mul_zero, neg_zero, if_pos]
    have hsum : (∑ x : ZMod 11,
        if x = 0 then (WeilRep.ψ (E := k)) ((i.val : ZMod 11) * x) *
          WeilRep.ψ (6 * (6 * x) ^ 2 * WeilRep.twoInv)
        else if x = 0 then WeilRep.ψ ((i.val : ZMod 11) * x) *
          WeilRep.ψ (6 * (6 * x) ^ 2 * WeilRep.twoInv) else 0) = 1 := by
      calc
        _ = (∑ x : ZMod 11,
            if x = 0 then (WeilRep.ψ (E := k)) ((i.val : ZMod 11) * x) *
              WeilRep.ψ (6 * (6 * x) ^ 2 * WeilRep.twoInv) else 0) := by
          apply Finset.sum_congr rfl
          intro x _
          by_cases hx : x = 0 <;> simp [hx]
        _ = (WeilRep.ψ (E := k)) ((i.val : ZMod 11) * 0) *
              WeilRep.ψ (6 * (6 * 0) ^ 2 * WeilRep.twoInv) := by
          rw [sum_indicator_one]
        _ = 1 := by simp
    rw [hsum]
    rw [hphase]
    simp [directValue]
    ring
  · have hjval : (j.val : ZMod 11) ≠ 0 := by
      intro h
      apply hj
      apply Fin.ext
      have hval := congrArg ZMod.val h
      simpa [ZMod.val_cast_of_lt
        (Nat.lt_trans j.isLt (by decide : 6 < 11))] using hval
    have htwoj : -(2 * (j.val : ZMod 11)) ≠
        2 * (j.val : ZMod 11) := by
      intro h
      have : (4 : ZMod 11) * (j.val : ZMod 11) = 0 := by
        calc
          4 * (j.val : ZMod 11) =
              2 * (j.val : ZMod 11) - (-(2 * (j.val : ZMod 11))) := by ring
          _ = 0 := by rw [h]; simp
      exact hjval ((mul_eq_zero.mp this).resolve_left (by decide))
    rw [sum_indicator_two
      (2 * (j.val : ZMod 11)) (-(2 * (j.val : ZMod 11))) htwoj]
    unfold directValue
    rw [if_neg hj]
    have h6pos : 6 * (2 * (j.val : ZMod 11)) = (j.val : ZMod 11) := by
      calc
        6 * (2 * (j.val : ZMod 11)) =
            (6 * 2 : ZMod 11) * (j.val : ZMod 11) := by ring
        _ = 1 * (j.val : ZMod 11) := by
          rw [show (6 : ZMod 11) * 2 = 1 by decide]
        _ = (j.val : ZMod 11) := one_mul _
    have h6neg : 6 * (-(2 * (j.val : ZMod 11))) =
        -(j.val : ZMod 11) := by
      rw [mul_neg, h6pos]
    have hfourierPos : (i.val : ZMod 11) * (2 * (j.val : ZMod 11)) =
        2 * (i.val : ZMod 11) * (j.val : ZMod 11) := by ring
    have hfourierNeg :
        (i.val : ZMod 11) * (-(2 * (j.val : ZMod 11))) =
          -(2 * (i.val : ZMod 11) * (j.val : ZMod 11)) := by ring
    have hsqneg : (-(j.val : ZMod 11)) ^ 2 =
        (j.val : ZMod 11) ^ 2 := by ring
    rw [h6pos, h6neg, hsqneg, hphase, hphase,
      hfourierPos, hfourierNeg]
    ring

public abbrev PolyQ := Polynomial ℚ

/-- Polynomial encoding of the Fourier normalization. -/
@[expose] public def cFourierPoly : PolyQ :=
  C (-1 / 11) + C (-2 / 11) * X + C (-2 / 11) * X ^ 3 +
    C (-2 / 11) * X ^ 4 + C (-2 / 11) * X ^ 5 +
      C (-2 / 11) * X ^ 9

@[expose] public def phasePoly (a : ZMod 11) : PolyQ := X ^ a.val

/-- Polynomial encoding of `directValue`; equality is required only modulo
the eleventh cyclotomic polynomial. -/
@[expose] public def directEntryPoly (i j : Fin 6) : PolyQ :=
  cFourierPoly * phasePoly (3 * (i.val : ZMod 11) ^ 2) *
    (if j = 0 then 1 else
      phasePoly (3 * (j.val : ZMod 11) ^ 2) *
        (phasePoly (2 * (i.val : ZMod 11) * (j.val : ZMod 11)) +
          phasePoly (-(2 * (i.val : ZMod 11) * (j.val : ZMod 11)))))

theorem cFourier_eq_neg_gauss_div_eleven :
    (WeilRep.cFourier : k) = -WeilRep.gauss / 11 := by
  rw [WeilRep.cFourier, eq_div_iff (by norm_num : (11 : WeilRep.K) ≠ 0)]
  apply (mul_left_cancel₀ (a := WeilRep.gauss) WeilRep.gauss_ne_zero)
  rw [← mul_assoc, mul_inv_cancel₀ WeilRep.gauss_ne_zero, one_mul]
  calc
    (11 : WeilRep.K) = -(WeilRep.gauss ^ 2) := by
      rw [WeilRep.gauss_sq]
      norm_num
    _ = WeilRep.gauss * -WeilRep.gauss := by ring

theorem gauss_explicit :
    (WeilRep.gauss : k) = 1 + 2 * (WeilRep.ζ + WeilRep.ζ ^ 3 + WeilRep.ζ ^ 4 +
      WeilRep.ζ ^ 5 + WeilRep.ζ ^ 9) := by
  classical
  unfold WeilRep.gauss
  rw [show (Finset.univ : Finset (ZMod 11)) =
    {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10} by decide]
  rw [Finset.sum_insert (by decide), Finset.sum_insert (by decide),
    Finset.sum_insert (by decide), Finset.sum_insert (by decide),
    Finset.sum_insert (by decide), Finset.sum_insert (by decide),
    Finset.sum_insert (by decide), Finset.sum_insert (by decide),
    Finset.sum_insert (by decide), Finset.sum_insert (by decide),
    Finset.sum_singleton]
  have h1 : ZMod.val (1 : ZMod 11) = 1 := by decide
  have h4 : ZMod.val (4 : ZMod 11) = 4 := by decide
  have h9 : ZMod.val (9 : ZMod 11) = 9 := by decide
  have h16 : ZMod.val (16 : ZMod 11) = 5 := by decide
  have h25 : ZMod.val (25 : ZMod 11) = 3 := by decide
  have h36 : ZMod.val (36 : ZMod 11) = 3 := by decide
  have h49 : ZMod.val (49 : ZMod 11) = 5 := by decide
  have h64 : ZMod.val (64 : ZMod 11) = 9 := by decide
  have h81 : ZMod.val (81 : ZMod 11) = 4 := by decide
  have h100 : ZMod.val (100 : ZMod 11) = 1 := by decide
  norm_num [WeilRep.ψ_apply, h1, h4, h9, h16, h25, h36, h49, h64, h81, h100]
  ring

public theorem eval_cFourierPoly :
    evalPolyAt (WeilRep.ζ : k) cFourierPoly = WeilRep.cFourier := by
  rw [cFourier_eq_neg_gauss_div_eleven, gauss_explicit]
  simp [cFourierPoly, evalPolyAt]
  ring

public theorem eval_phasePoly (a : ZMod 11) :
    evalPolyAt (WeilRep.ζ : k) (phasePoly a) = WeilRep.ψ a := by
  simp [phasePoly, evalPolyAt, WeilRep.ψ_apply]

public theorem eval_directEntryPoly (i j : Fin 6) :
    evalPolyAt WeilRep.ζ (directEntryPoly i j) = directValue i j := by
  by_cases hj : j = 0 <;>
    simp [directEntryPoly, directValue, hj, eval_cFourierPoly, eval_phasePoly]

end V14Formalization.D12U6Semantic
