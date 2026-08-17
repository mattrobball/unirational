/-
L*K = 0 and N*K = 1, so T = (L;N) is invertible.
-/
module

public import V14Formalization.D12SigmaPlusSegreLK_0_0
public import V14Formalization.D12SigmaPlusSegreLK_0_1
public import V14Formalization.D12SigmaPlusSegreLK_0_2
public import V14Formalization.D12SigmaPlusSegreLK_1_0
public import V14Formalization.D12SigmaPlusSegreLK_1_1
public import V14Formalization.D12SigmaPlusSegreLK_1_2
public import V14Formalization.D12SigmaPlusSegreLK_2_0
public import V14Formalization.D12SigmaPlusSegreLK_2_1
public import V14Formalization.D12SigmaPlusSegreLK_2_2
public import V14Formalization.D12SigmaPlusSegreLK_3_0
public import V14Formalization.D12SigmaPlusSegreLK_3_1
public import V14Formalization.D12SigmaPlusSegreLK_3_2
public import V14Formalization.D12SigmaPlusSegreLK_4_0
public import V14Formalization.D12SigmaPlusSegreLK_4_1
public import V14Formalization.D12SigmaPlusSegreLK_4_2
public import V14Formalization.D12SigmaPlusSegreLK_5_0
public import V14Formalization.D12SigmaPlusSegreLK_5_1
public import V14Formalization.D12SigmaPlusSegreLK_5_2
public import V14Formalization.D12SigmaPlusSegreNK_0_0
public import V14Formalization.D12SigmaPlusSegreNK_0_1
public import V14Formalization.D12SigmaPlusSegreNK_0_2
public import V14Formalization.D12SigmaPlusSegreNK_1_0
public import V14Formalization.D12SigmaPlusSegreNK_1_1
public import V14Formalization.D12SigmaPlusSegreNK_1_2
public import V14Formalization.D12SigmaPlusSegreNK_2_0
public import V14Formalization.D12SigmaPlusSegreNK_2_1
public import V14Formalization.D12SigmaPlusSegreNK_2_2

noncomputable section
open Matrix
namespace V14Formalization.D12SigmaPlusSegreData
open D12SigmaPlusSegreCore

public theorem L_mul_K : L * K = 0 := by
  ext i j
  fin_cases i <;> fin_cases j
  · exact LK_entry_0_0
  · exact LK_entry_0_1
  · exact LK_entry_0_2
  · exact LK_entry_1_0
  · exact LK_entry_1_1
  · exact LK_entry_1_2
  · exact LK_entry_2_0
  · exact LK_entry_2_1
  · exact LK_entry_2_2
  · exact LK_entry_3_0
  · exact LK_entry_3_1
  · exact LK_entry_3_2
  · exact LK_entry_4_0
  · exact LK_entry_4_1
  · exact LK_entry_4_2
  · exact LK_entry_5_0
  · exact LK_entry_5_1
  · exact LK_entry_5_2

public theorem N_mul_K : N * K = 1 := by
  ext i j
  fin_cases i <;> fin_cases j
  · exact NK_entry_0_0
  · exact NK_entry_0_1
  · exact NK_entry_0_2
  · exact NK_entry_1_0
  · exact NK_entry_1_1
  · exact NK_entry_1_2
  · exact NK_entry_2_0
  · exact NK_entry_2_1
  · exact NK_entry_2_2

end V14Formalization.D12SigmaPlusSegreData
