/-
Copyright (c) 2026 V14Formalization contributors.
Released under Apache 2.0 license.
-/
import V14Formalization.D12SigmaCarrierConcrete
import V14Formalization.D12SigmaMinusAmbient
import V14Formalization.D12SigmaMinusQuadric0
import V14Formalization.D12SigmaMinusQuadric1
import V14Formalization.D12SigmaMinusQuadric2
import V14Formalization.D12SigmaMinusQuadric3
import V14Formalization.D12SigmaMinusQuadric4
import V14Formalization.D12SigmaMinusQuadric5
import V14Formalization.D12SigmaMinusQuadric6
import V14Formalization.D12SigmaMinusQuadric7
import V14Formalization.D12SigmaMinusReverse0
import V14Formalization.D12SigmaMinusReverse1
import V14Formalization.D12SigmaMinusReverse2
import V14Formalization.D12SigmaMinusReverse3
import V14Formalization.D12SigmaMinusReverse4
import V14Formalization.D12SigmaMinusReverse5
import V14Formalization.D12SigmaMinusReverse6
import V14Formalization.D12SigmaMinusReverse7
import V14Formalization.D12SigmaMinusReference
import V14Formalization.D12U6PolynomialSeal

noncomputable section
open Matrix Polynomial
namespace V14Formalization.D12SigmaMinusConcrete
open D12PolynomialData D12PolynomialEvaluation
open D12SigmaCarrier D12SigmaCarrierPolynomial D12SigmaCarrierConcrete
open D12SigmaMinusNormalForm D12SigmaMinusNormalFormData

theorem evalMatrixK_Bminus_poly :
    evalMatrixK Bminus_poly = D12SigmaCarrierConcrete.core.Bminus := by
  rw [← D12SigmaMinusAmbient.B_mul_Kminus_poly]
  change evalMatrixAt WeilRep.ζ (B_poly * Kminus_poly) = _
  rw [evalMatrixAt_mul]
  rfl

theorem plucker_eq_evalQuadratic
    {S : Type*} [Field S] [Algebra ℚ S] (z : S)
    (hPhi : evalPolyAt z Phi11 = 0) (q : Fin 8) (y : Fin 4 → S) :
    D12Certificate.pluckerValue ((evalMatrixAt z Bminus_poly).mulVec y)
        ⟨q.val, by omega⟩ = evalQuadratic z q y := by
  fin_cases q
  · exact D12SigmaMinusQuadric0.plucker_eq_evalQuadratic z hPhi y
  · exact D12SigmaMinusQuadric1.plucker_eq_evalQuadratic z hPhi y
  · exact D12SigmaMinusQuadric2.plucker_eq_evalQuadratic z hPhi y
  · exact D12SigmaMinusQuadric3.plucker_eq_evalQuadratic z hPhi y
  · exact D12SigmaMinusQuadric4.plucker_eq_evalQuadratic z hPhi y
  · exact D12SigmaMinusQuadric5.plucker_eq_evalQuadratic z hPhi y
  · exact D12SigmaMinusQuadric6.plucker_eq_evalQuadratic z hPhi y
  · exact D12SigmaMinusQuadric7.plucker_eq_evalQuadratic z hPhi y

theorem linears_zero_of_quadrics
    {S : Type*} [Field S] [Algebra ℚ S] (z : S)
    (hPhi : evalPolyAt z Phi11 = 0) {y : Fin 4 → S} (hy : y ≠ 0)
    (hQ : ∀ q : Fin 8, evalQuadratic z q y = 0) :
    linearOne (evalA z) (evalB z) y = 0 ∧
      linearTwo (evalC z) (evalD z) y = 0 := by
  have hj : ∃ j : Fin 4, y j ≠ 0 := by
    by_contra h
    push_neg at h
    exact hy (funext h)
  obtain ⟨j, hj⟩ := hj
  have h1j : y j * linearOne (evalA z) (evalB z) y = 0 := by
    have hjv := j.isLt
    interval_cases hv : j.val
    · have : j = 0 := Fin.ext hv
      subst this
      rw [D12SigmaMinusReverse0.identity z hPhi y]
      simp [hQ]
    · have : j = 1 := Fin.ext hv
      subst this
      rw [D12SigmaMinusReverse1.identity z hPhi y]
      simp [hQ]
    · have : j = 2 := Fin.ext hv
      subst this
      rw [D12SigmaMinusReverse2.identity z hPhi y]
      simp [hQ]
    · have : j = 3 := Fin.ext hv
      subst this
      rw [D12SigmaMinusReverse3.identity z hPhi y]
      simp [hQ]
  have h2j : y j * linearTwo (evalC z) (evalD z) y = 0 := by
    have hjv := j.isLt
    interval_cases hv : j.val
    · have : j = 0 := Fin.ext hv
      subst this
      rw [D12SigmaMinusReverse4.identity z hPhi y]
      simp [hQ]
    · have : j = 1 := Fin.ext hv
      subst this
      rw [D12SigmaMinusReverse5.identity z hPhi y]
      simp [hQ]
    · have : j = 2 := Fin.ext hv
      subst this
      rw [D12SigmaMinusReverse6.identity z hPhi y]
      simp [hQ]
    · have : j = 3 := Fin.ext hv
      subst this
      rw [D12SigmaMinusReverse7.identity z hPhi y]
      simp [hQ]
  exact ⟨(mul_eq_zero.mp h1j).resolve_left hj,
    (mul_eq_zero.mp h2j).resolve_left hj⟩

/-- Every nonzero common Plücker zero in the concrete minus carrier
lies on the emitted projective line and satisfies its binary quadratic. -/
theorem common_plucker_zero_parametric
    (S : Type*) [Field S] [Algebra ℚ S] [Algebra WeilRep.K S]
    [IsScalarTower ℚ WeilRep.K S] {y : Fin 4 → S} (hy : y ≠ 0)
    (hQ : ∀ q : Fin 15, D12Certificate.pluckerValue
      (((D12SigmaCarrierConcrete.core.Bminus).map
        (algebraMap WeilRep.K S)).mulVec y) q = 0) :
    y = lineParam
        (evalA ((algebraMap WeilRep.K S) WeilRep.ζ))
        (evalB ((algebraMap WeilRep.K S) WeilRep.ζ))
        (evalC ((algebraMap WeilRep.K S) WeilRep.ζ))
        (evalD ((algebraMap WeilRep.K S) WeilRep.ζ)) (y 2) (y 3) ∧
      binaryQuadratic
        (evalBinaryA ((algebraMap WeilRep.K S) WeilRep.ζ))
        (evalBinaryB ((algebraMap WeilRep.K S) WeilRep.ζ))
        (evalBinaryC ((algebraMap WeilRep.K S) WeilRep.ζ)) (y 2) (y 3) = 0 ∧
      evalBinaryB ((algebraMap WeilRep.K S) WeilRep.ζ) ^ 2 -
          4 * evalBinaryA ((algebraMap WeilRep.K S) WeilRep.ζ) *
            evalBinaryC ((algebraMap WeilRep.K S) WeilRep.ζ) ≠ 0 := by
  let z : S := (algebraMap WeilRep.K S) WeilRep.ζ
  have hPhi : evalPolyAt z Phi11 = 0 := by
    rw [evalPolyAt_extension_eq_map_evalPolyAt,
      D12U6PolynomialSeal.evalPhi11_ζ, map_zero]
  have hB : evalMatrixAt z Bminus_poly =
      (D12SigmaCarrierConcrete.core.Bminus).map
        (algebraMap WeilRep.K S) := by
    rw [evalMatrixAt_extension_eq_map_evalMatrixK, evalMatrixK_Bminus_poly]
  have hQ8 : ∀ q : Fin 8, evalQuadratic z q y = 0 := by
    intro q
    rw [← plucker_eq_evalQuadratic z hPhi q y, hB]
    exact hQ ⟨q.val, by omega⟩
  have hlin := linears_zero_of_quadrics z hPhi hy hQ8
  have hparam := commonZero_parametric
    (fun q => fun m => evalPolyAt z (Qcoeff_poly q m))
    (evalA z) (evalB z) (evalC z) (evalD z)
    (evalBinaryA z) (evalBinaryB z) (evalBinaryC z)
    (fun _ => hlin) (D12SigmaMinusReference.pullback z hPhi) hQ8
  refine ⟨hparam.1, hparam.2, ?_⟩
  rw [D12SigmaMinusReference.eval_disc z hPhi,
    evalPolyAt_extension_eq_map_evalPolyAt]
  exact (map_ne_zero_iff (algebraMap WeilRep.K S)
    (algebraMap WeilRep.K S).injective).2
    D12SigmaMinusReference.eval_disc_K_ne_zero

end V14Formalization.D12SigmaMinusConcrete
