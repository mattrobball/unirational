/- Auto-generated integer-reflection bridge umbrella. DO NOT HAND-EDIT. -/
import V14Formalization.D12SigmaPlusSegreSpanVZ
import V14Formalization.D12SigmaPlusSegreQplusZ
import V14Formalization.D12SigmaPlusSegreMinorQZ
import V14Formalization.D12SigmaPlusSegreApplyHZ

noncomputable section
open Polynomial
namespace V14Formalization.D12SigmaPlusSegreCore
open D12PolynomialData
open V14Formalization.D12PolyZReflection

theorem z_Phi11 : (Phi11 : Polynomial ℚ) = interpQ 1 [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1] := by
  rw [Phi11_expand]
  refine Polynomial.funext fun r => ?_
  simp [interpQ, toPolyZ, Polynomial.eval_add, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow]
  try ring

end V14Formalization.D12SigmaPlusSegreCore
