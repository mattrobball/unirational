/-
Auto-generated plus Segre aggregate identities.
-/
module

public import V14Formalization.D12SigmaPlusSegreLH_0_0
public import V14Formalization.D12SigmaPlusSegreLH_0_1
public import V14Formalization.D12SigmaPlusSegreLH_0_2
public import V14Formalization.D12SigmaPlusSegreLH_0_3
public import V14Formalization.D12SigmaPlusSegreLH_0_4
public import V14Formalization.D12SigmaPlusSegreLH_0_5
public import V14Formalization.D12SigmaPlusSegreLH_1_0
public import V14Formalization.D12SigmaPlusSegreLH_1_1
public import V14Formalization.D12SigmaPlusSegreLH_1_2
public import V14Formalization.D12SigmaPlusSegreLH_1_3
public import V14Formalization.D12SigmaPlusSegreLH_1_4
public import V14Formalization.D12SigmaPlusSegreLH_1_5
public import V14Formalization.D12SigmaPlusSegreLH_2_0
public import V14Formalization.D12SigmaPlusSegreLH_2_1
public import V14Formalization.D12SigmaPlusSegreLH_2_2
public import V14Formalization.D12SigmaPlusSegreLH_2_3
public import V14Formalization.D12SigmaPlusSegreLH_2_4
public import V14Formalization.D12SigmaPlusSegreLH_2_5
public import V14Formalization.D12SigmaPlusSegreLH_3_0
public import V14Formalization.D12SigmaPlusSegreLH_3_1
public import V14Formalization.D12SigmaPlusSegreLH_3_2
public import V14Formalization.D12SigmaPlusSegreLH_3_3
public import V14Formalization.D12SigmaPlusSegreLH_3_4
public import V14Formalization.D12SigmaPlusSegreLH_3_5
public import V14Formalization.D12SigmaPlusSegreLH_4_0
public import V14Formalization.D12SigmaPlusSegreLH_4_1
public import V14Formalization.D12SigmaPlusSegreLH_4_2
public import V14Formalization.D12SigmaPlusSegreLH_4_3
public import V14Formalization.D12SigmaPlusSegreLH_4_4
public import V14Formalization.D12SigmaPlusSegreLH_4_5
public import V14Formalization.D12SigmaPlusSegreLH_5_0
public import V14Formalization.D12SigmaPlusSegreLH_5_1
public import V14Formalization.D12SigmaPlusSegreLH_5_2
public import V14Formalization.D12SigmaPlusSegreLH_5_3
public import V14Formalization.D12SigmaPlusSegreLH_5_4
public import V14Formalization.D12SigmaPlusSegreLH_5_5
public import V14Formalization.D12SigmaPlusSegreNH_0_0
public import V14Formalization.D12SigmaPlusSegreNH_0_1
public import V14Formalization.D12SigmaPlusSegreNH_0_2
public import V14Formalization.D12SigmaPlusSegreNH_0_3
public import V14Formalization.D12SigmaPlusSegreNH_0_4
public import V14Formalization.D12SigmaPlusSegreNH_0_5
public import V14Formalization.D12SigmaPlusSegreNH_1_0
public import V14Formalization.D12SigmaPlusSegreNH_1_1
public import V14Formalization.D12SigmaPlusSegreNH_1_2
public import V14Formalization.D12SigmaPlusSegreNH_1_3
public import V14Formalization.D12SigmaPlusSegreNH_1_4
public import V14Formalization.D12SigmaPlusSegreNH_1_5
public import V14Formalization.D12SigmaPlusSegreNH_2_0
public import V14Formalization.D12SigmaPlusSegreNH_2_1
public import V14Formalization.D12SigmaPlusSegreNH_2_2
public import V14Formalization.D12SigmaPlusSegreNH_2_3
public import V14Formalization.D12SigmaPlusSegreNH_2_4
public import V14Formalization.D12SigmaPlusSegreNH_2_5

noncomputable section
open Matrix
namespace V14Formalization.D12SigmaPlusSegreData
open D12SigmaPlusSegreCore

public theorem L_mul_H : L * H = 1 := by
  ext i j
  fin_cases i <;> fin_cases j
  · exact LH_entry_0_0
  · exact LH_entry_0_1
  · exact LH_entry_0_2
  · exact LH_entry_0_3
  · exact LH_entry_0_4
  · exact LH_entry_0_5
  · exact LH_entry_1_0
  · exact LH_entry_1_1
  · exact LH_entry_1_2
  · exact LH_entry_1_3
  · exact LH_entry_1_4
  · exact LH_entry_1_5
  · exact LH_entry_2_0
  · exact LH_entry_2_1
  · exact LH_entry_2_2
  · exact LH_entry_2_3
  · exact LH_entry_2_4
  · exact LH_entry_2_5
  · exact LH_entry_3_0
  · exact LH_entry_3_1
  · exact LH_entry_3_2
  · exact LH_entry_3_3
  · exact LH_entry_3_4
  · exact LH_entry_3_5
  · exact LH_entry_4_0
  · exact LH_entry_4_1
  · exact LH_entry_4_2
  · exact LH_entry_4_3
  · exact LH_entry_4_4
  · exact LH_entry_4_5
  · exact LH_entry_5_0
  · exact LH_entry_5_1
  · exact LH_entry_5_2
  · exact LH_entry_5_3
  · exact LH_entry_5_4
  · exact LH_entry_5_5

public theorem N_mul_H : N * H = 0 := by
  ext i j
  fin_cases i <;> fin_cases j
  · exact NH_entry_0_0
  · exact NH_entry_0_1
  · exact NH_entry_0_2
  · exact NH_entry_0_3
  · exact NH_entry_0_4
  · exact NH_entry_0_5
  · exact NH_entry_1_0
  · exact NH_entry_1_1
  · exact NH_entry_1_2
  · exact NH_entry_1_3
  · exact NH_entry_1_4
  · exact NH_entry_1_5
  · exact NH_entry_2_0
  · exact NH_entry_2_1
  · exact NH_entry_2_2
  · exact NH_entry_2_3
  · exact NH_entry_2_4
  · exact NH_entry_2_5

end V14Formalization.D12SigmaPlusSegreData
