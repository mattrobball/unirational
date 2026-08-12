/-
Copyright (c) 2026 V14Formalization contributors.
Released under Apache 2.0 license.
-/
import V14Formalization.D12SigmaPlusSegreCore

noncomputable section

open Polynomial

namespace V14Formalization.D12SigmaPlusSegreCore
open GeometricV14Carrier

theorem iRoot_sq : (iRoot : Ki) ^ 2 = -1 := by
  have h := GeometricV14Carrier.aeval_iRoot
  have : (iRoot : Ki) ^ 2 + 1 = 0 := by
    simpa [Polynomial.aeval_add, Polynomial.aeval_C, Polynomial.aeval_X,
      map_pow] using h
  linear_combination this

theorem ofLadj_mul (a b c d : Polynomial ℚ) :
    ofLadj a b * ofLadj c d = ofLadj (a * c - b * d) (a * d + b * c) := by
  have hi := iRoot_sq
  have hre : ofPoly (a * c - b * d) =
      ofPoly a * ofPoly c - ofPoly b * ofPoly d := by
    simp [ofPoly, map_mul, map_add, map_sub]
  have him : ofPoly (a * d + b * c) =
      ofPoly a * ofPoly d + ofPoly b * ofPoly c := by
    simp [ofPoly, map_mul, map_add]
  simp only [ofLadj, hre, him, map_add, map_mul, map_sub]
  ring_nf
  simp [hi]
  ring

end V14Formalization.D12SigmaPlusSegreCore
