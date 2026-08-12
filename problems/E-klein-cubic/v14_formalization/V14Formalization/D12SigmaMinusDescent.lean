/-
Copyright (c) 2026 V14Formalization contributors.
Released under Apache 2.0 license.
-/
import V14Formalization.BinaryQuadraticDescent
import V14Formalization.D12SigmaMinusConcrete
import V14Formalization.V14SchemeModel

/-!
# Descent of a minus-carrier Plücker zero to the base field
-/

noncomputable section

open Matrix Polynomial

namespace V14Formalization.D12SigmaMinusDescent

open D12PolynomialData D12PolynomialEvaluation
open D12SigmaMinusNormalForm D12SigmaMinusNormalFormData
open D12SigmaMinusConcrete
open EllipticPolynomialConstancy MvFracConstantField BinaryQuadraticDescent

private abbrev k := V14SchemeModel.k

private lemma evalA_map {S : Type*} [CommRing S] [Algebra ℚ S]
    [Algebra k S] [IsScalarTower ℚ k S] :
    evalA ((algebraMap k S) WeilRep.ζ) =
      algebraMap k S (evalA WeilRep.ζ) :=
  evalPolyAt_extension_eq_map_evalPolyAt S a_poly

private lemma evalB_map {S : Type*} [CommRing S] [Algebra ℚ S]
    [Algebra k S] [IsScalarTower ℚ k S] :
    evalB ((algebraMap k S) WeilRep.ζ) =
      algebraMap k S (evalB WeilRep.ζ) :=
  evalPolyAt_extension_eq_map_evalPolyAt S b_poly

private lemma evalC_map {S : Type*} [CommRing S] [Algebra ℚ S]
    [Algebra k S] [IsScalarTower ℚ k S] :
    evalC ((algebraMap k S) WeilRep.ζ) =
      algebraMap k S (evalC WeilRep.ζ) :=
  evalPolyAt_extension_eq_map_evalPolyAt S c_poly

private lemma evalD_map {S : Type*} [CommRing S] [Algebra ℚ S]
    [Algebra k S] [IsScalarTower ℚ k S] :
    evalD ((algebraMap k S) WeilRep.ζ) =
      algebraMap k S (evalD WeilRep.ζ) :=
  evalPolyAt_extension_eq_map_evalPolyAt S d_poly

private lemma evalBinaryA_map {S : Type*} [CommRing S] [Algebra ℚ S]
    [Algebra k S] [IsScalarTower ℚ k S] :
    evalBinaryA ((algebraMap k S) WeilRep.ζ) =
      algebraMap k S (evalBinaryA WeilRep.ζ) :=
  evalPolyAt_extension_eq_map_evalPolyAt S A_poly

private lemma evalBinaryB_map {S : Type*} [CommRing S] [Algebra ℚ S]
    [Algebra k S] [IsScalarTower ℚ k S] :
    evalBinaryB ((algebraMap k S) WeilRep.ζ) =
      algebraMap k S (evalBinaryB WeilRep.ζ) :=
  evalPolyAt_extension_eq_map_evalPolyAt S BB_poly

private lemma evalBinaryC_map {S : Type*} [CommRing S] [Algebra ℚ S]
    [Algebra k S] [IsScalarTower ℚ k S] :
    evalBinaryC ((algebraMap k S) WeilRep.ζ) =
      algebraMap k S (evalBinaryC WeilRep.ζ) :=
  evalPolyAt_extension_eq_map_evalPolyAt S C_poly

private lemma lineParam_map {S : Type*} [CommRing S] [Algebra k S]
    (a b c d s t : k) :
    lineParam (algebraMap k S a) (algebraMap k S b)
        (algebraMap k S c) (algebraMap k S d)
        (algebraMap k S s) (algebraMap k S t) =
      fun i => algebraMap k S (lineParam a b c d s t i) := by
  funext i
  fin_cases i <;> simp [lineParam, map_add, map_mul, map_neg, map_sub]

private lemma lineParam_smul {R : Type*} [CommRing R]
    (a b c d s t r : R) :
    lineParam a b c d (r * s) (r * t) =
      r • lineParam a b c d s t := by
  funext i
  fin_cases i <;> simp [lineParam, Pi.smul_apply, smul_eq_mul] <;> ring

theorem minusCarrier_commonPluckerZero_descends_mvfrac
    (n : ℕ) (v : Fin 4 → MvFrac k n)
    (hv : v ≠ 0)
    (hQ : ∀ q : Fin 15,
      D12Certificate.pluckerValue
        (((D12SigmaCarrierConcrete.core.Bminus).map
          (algebraMap k (MvFrac k n))).mulVec v) q = 0) :
    ∃ (v0 : Fin 4 → k) (_hv0 : v0 ≠ 0) (c : MvFrac k n),
      c ≠ 0 ∧ v = c • fun i => algebraMap k (MvFrac k n) (v0 i) := by
  haveI : CharZero k := inferInstance
  have hparam :=
    common_plucker_zero_parametric (S := MvFrac k n) hv hQ
  have hdisc : evalBinaryB WeilRep.ζ ^ 2 -
      4 * evalBinaryA WeilRep.ζ * evalBinaryC WeilRep.ζ ≠ 0 := by
    have := hparam.2.2
    rw [evalBinaryA_map, evalBinaryB_map, evalBinaryC_map] at this
    exact (map_ne_zero_iff (algebraMap k (MvFrac k n))
      (algebraMap k (MvFrac k n)).injective).1 (by
        convert this using 1
        simp [map_sub, map_mul, map_pow, map_ofNat])
  have hst : v 2 ≠ 0 ∨ v 3 ≠ 0 := by
    by_contra h
    push_neg at h
    have hvlin := hparam.1
    apply hv
    rw [hvlin]
    simp [lineParam, h.1, h.2]
  have hq : (algebraMap k (MvFrac k n) (evalBinaryA WeilRep.ζ)) * (v 2) ^ 2 +
      (algebraMap k (MvFrac k n) (evalBinaryB WeilRep.ζ)) * (v 2) * (v 3) +
      (algebraMap k (MvFrac k n) (evalBinaryC WeilRep.ζ)) * (v 3) ^ 2 = 0 := by
    have := hparam.2.1
    rw [evalBinaryA_map, evalBinaryB_map, evalBinaryC_map] at this
    simpa [binaryQuadratic] using this
  obtain ⟨s0, t0, c, hst0, hc, hs, ht⟩ :=
    binaryQuadratic_projective_descends_mvfrac n
      (evalBinaryA WeilRep.ζ) (evalBinaryB WeilRep.ζ) (evalBinaryC WeilRep.ζ)
      hdisc (v 2) (v 3) hst hq
  let v0 : Fin 4 → k :=
    lineParam (evalA WeilRep.ζ) (evalB WeilRep.ζ)
      (evalC WeilRep.ζ) (evalD WeilRep.ζ) s0 t0
  have hv0 : v0 ≠ 0 := by
    intro h0
    have hs0 : s0 = 0 := by simpa [v0, lineParam] using congrFun h0 (2 : Fin 4)
    have ht0 : t0 = 0 := by simpa [v0, lineParam] using congrFun h0 (3 : Fin 4)
    cases hst0 with
    | inl h => exact h hs0
    | inr h => exact h ht0
  refine ⟨v0, hv0, c, hc, ?_⟩
  have hvlin := hparam.1
  rw [hvlin, evalA_map, evalB_map, evalC_map, evalD_map, hs, ht]
  have hscale := lineParam_smul
    (algebraMap k (MvFrac k n) (evalA WeilRep.ζ))
    (algebraMap k (MvFrac k n) (evalB WeilRep.ζ))
    (algebraMap k (MvFrac k n) (evalC WeilRep.ζ))
    (algebraMap k (MvFrac k n) (evalD WeilRep.ζ))
    (algebraMap k (MvFrac k n) s0)
    (algebraMap k (MvFrac k n) t0) c
  rw [hscale]
  funext i
  simp [Pi.smul_apply, smul_eq_mul, v0, lineParam_map]

theorem minusCarrier_ambient_descends_mvfrac
    (n : ℕ) (x : Fin 15 → MvFrac k n)
    (v : Fin 4 → MvFrac k n) (hv : v ≠ 0)
    (hx : x = ((D12SigmaCarrierConcrete.core.Bminus).map
      (algebraMap k (MvFrac k n))).mulVec v)
    (hQ : ∀ q : Fin 15, D12Certificate.pluckerValue x q = 0) :
    ∃ (x0 : Fin 15 → k) (_hx0 : x0 ≠ 0) (c : MvFrac k n),
      c ≠ 0 ∧ x = c • fun i => algebraMap k (MvFrac k n) (x0 i) := by
  obtain ⟨v0, hv0, c, hc, hvdesc⟩ :=
    minusCarrier_commonPluckerZero_descends_mvfrac n v hv (by
      intro q; simpa [hx] using hQ q)
  let x0 : Fin 15 → k := D12SigmaCarrierConcrete.core.Bminus.mulVec v0
  have hx0 : x0 ≠ 0 := by
    intro h0
    have hL := congrArg (D12SigmaCarrierConcrete.core.Lminus.mulVec) h0
    have : v0 = 0 := by
      simpa [x0, Matrix.mulVec_mulVec,
        D12SigmaCarrierConcrete.core.left_inverse_minus] using hL
    exact hv0 this
  refine ⟨x0, hx0, c, hc, ?_⟩
  have hmap :
      ((D12SigmaCarrierConcrete.core.Bminus).map
          (algebraMap k (MvFrac k n))).mulVec
        (fun i => algebraMap k (MvFrac k n) (v0 i)) =
      fun i => algebraMap k (MvFrac k n) (x0 i) := by
    funext i
    simp [x0, Matrix.mulVec, dotProduct, map_sum, map_mul]
  rw [hx, hvdesc, Matrix.mulVec_smul, hmap]

end V14Formalization.D12SigmaMinusDescent
