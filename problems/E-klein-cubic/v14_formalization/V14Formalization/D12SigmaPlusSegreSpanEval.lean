/-
Copyright (c) 2026 V14Formalization contributors.
Released under Apache 2.0 license.
-/
import V14Formalization.D12SigmaPlusSegreSpanVDir
import V14Formalization.D12SigmaPlusSegreGeom

noncomputable section

open Matrix
open V14Formalization.D12SigmaPlusQuadric6

namespace V14Formalization.D12SigmaPlusSegreCore

theorem minorQ_row_eq_spanV_smul (s : Fin 9) :
    (fun k => minorQ s k) = ∑ q : Fin 15, spanV s q • (fun k => Qplus q k) := by
  funext k
  have h := congrArg (fun M : Matrix (Fin 9) (Fin 21) Ki => M s k) spanV_mul_Qplus
  simpa [Matrix.mul_apply, Pi.smul_apply, smul_eq_mul, Finset.sum_apply] using h.symm

theorem quadValue_spanV_Qplus (u : Fin 6 → Ki) (s : Fin 9) :
    quadValue (fun k => minorQ s k) u =
      ∑ q : Fin 15, spanV s q * quadValue (fun k => Qplus q k) u := by
  rw [minorQ_row_eq_spanV_smul, quadValue_linear]

theorem minorQ_value_eq_zero_of_Qplus
    (u : Fin 6 → Ki) (s : Fin 9)
    (hQ : ∀ q : Fin 15, quadValue (fun k => Qplus q k) u = 0) :
    quadValue (fun k => minorQ s k) u = 0 := by
  rw [quadValue_spanV_Qplus]
  simp [hQ]

end V14Formalization.D12SigmaPlusSegreCore
