/-
Dispatch restricted Plücker coefficients of BplusKi to Qplus.
-/
import V14Formalization.D12SigmaPlusSegreQrel_0
import V14Formalization.D12SigmaPlusSegreQrel_1
import V14Formalization.D12SigmaPlusSegreQrel_2
import V14Formalization.D12SigmaPlusSegreQrel_3
import V14Formalization.D12SigmaPlusSegreQrel_4
import V14Formalization.D12SigmaPlusSegreQrel_5
import V14Formalization.D12SigmaPlusSegreQrel_6
import V14Formalization.D12SigmaPlusSegreQrel_7
import V14Formalization.D12SigmaPlusSegreQrel_8
import V14Formalization.D12SigmaPlusSegreQrel_9
import V14Formalization.D12SigmaPlusSegreQrel_10
import V14Formalization.D12SigmaPlusSegreQrel_11
import V14Formalization.D12SigmaPlusSegreQrel_12
import V14Formalization.D12SigmaPlusSegreQrel_13
import V14Formalization.D12SigmaPlusSegreQrel_14

noncomputable section
open Matrix
namespace V14Formalization.D12SigmaPlusSegreCore
open D12SigmaPlusQuadric6

theorem Qplus_eq_restricted (q : Fin 15) (m : Fin 21) :
    restrictedPluckerCoeffs BplusKi q m = Qplus q m := by
  fin_cases q
  · exact Qplus_eq_restricted_row_0 m
  · exact Qplus_eq_restricted_row_1 m
  · exact Qplus_eq_restricted_row_2 m
  · exact Qplus_eq_restricted_row_3 m
  · exact Qplus_eq_restricted_row_4 m
  · exact Qplus_eq_restricted_row_5 m
  · exact Qplus_eq_restricted_row_6 m
  · exact Qplus_eq_restricted_row_7 m
  · exact Qplus_eq_restricted_row_8 m
  · exact Qplus_eq_restricted_row_9 m
  · exact Qplus_eq_restricted_row_10 m
  · exact Qplus_eq_restricted_row_11 m
  · exact Qplus_eq_restricted_row_12 m
  · exact Qplus_eq_restricted_row_13 m
  · exact Qplus_eq_restricted_row_14 m

end V14Formalization.D12SigmaPlusSegreCore
