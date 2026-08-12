/-
Aggregate V-span: every minor is a linear combination of Qplus rows.
-/
import V14Formalization.D12SigmaPlusSegreVQ_0_0
import V14Formalization.D12SigmaPlusSegreVQ_0_1
import V14Formalization.D12SigmaPlusSegreVQ_0_2
import V14Formalization.D12SigmaPlusSegreVQ_0_3
import V14Formalization.D12SigmaPlusSegreVQ_0_4
import V14Formalization.D12SigmaPlusSegreVQ_0_5
import V14Formalization.D12SigmaPlusSegreVQ_0_6
import V14Formalization.D12SigmaPlusSegreVQ_0_7
import V14Formalization.D12SigmaPlusSegreVQ_0_8
import V14Formalization.D12SigmaPlusSegreVQ_0_9
import V14Formalization.D12SigmaPlusSegreVQ_0_10
import V14Formalization.D12SigmaPlusSegreVQ_0_11
import V14Formalization.D12SigmaPlusSegreVQ_0_12
import V14Formalization.D12SigmaPlusSegreVQ_0_13
import V14Formalization.D12SigmaPlusSegreVQ_0_14
import V14Formalization.D12SigmaPlusSegreVQ_0_15
import V14Formalization.D12SigmaPlusSegreVQ_0_16
import V14Formalization.D12SigmaPlusSegreVQ_0_17
import V14Formalization.D12SigmaPlusSegreVQ_0_18
import V14Formalization.D12SigmaPlusSegreVQ_0_19
import V14Formalization.D12SigmaPlusSegreVQ_0_20
import V14Formalization.D12SigmaPlusSegreVQ_1_0
import V14Formalization.D12SigmaPlusSegreVQ_1_1
import V14Formalization.D12SigmaPlusSegreVQ_1_2
import V14Formalization.D12SigmaPlusSegreVQ_1_3
import V14Formalization.D12SigmaPlusSegreVQ_1_4
import V14Formalization.D12SigmaPlusSegreVQ_1_5
import V14Formalization.D12SigmaPlusSegreVQ_1_6
import V14Formalization.D12SigmaPlusSegreVQ_1_7
import V14Formalization.D12SigmaPlusSegreVQ_1_8
import V14Formalization.D12SigmaPlusSegreVQ_1_9
import V14Formalization.D12SigmaPlusSegreVQ_1_10
import V14Formalization.D12SigmaPlusSegreVQ_1_11
import V14Formalization.D12SigmaPlusSegreVQ_1_12
import V14Formalization.D12SigmaPlusSegreVQ_1_13
import V14Formalization.D12SigmaPlusSegreVQ_1_14
import V14Formalization.D12SigmaPlusSegreVQ_1_15
import V14Formalization.D12SigmaPlusSegreVQ_1_16
import V14Formalization.D12SigmaPlusSegreVQ_1_17
import V14Formalization.D12SigmaPlusSegreVQ_1_18
import V14Formalization.D12SigmaPlusSegreVQ_1_19
import V14Formalization.D12SigmaPlusSegreVQ_1_20
import V14Formalization.D12SigmaPlusSegreVQ_2_0
import V14Formalization.D12SigmaPlusSegreVQ_2_1
import V14Formalization.D12SigmaPlusSegreVQ_2_2
import V14Formalization.D12SigmaPlusSegreVQ_2_3
import V14Formalization.D12SigmaPlusSegreVQ_2_4
import V14Formalization.D12SigmaPlusSegreVQ_2_5
import V14Formalization.D12SigmaPlusSegreVQ_2_6
import V14Formalization.D12SigmaPlusSegreVQ_2_7
import V14Formalization.D12SigmaPlusSegreVQ_2_8
import V14Formalization.D12SigmaPlusSegreVQ_2_9
import V14Formalization.D12SigmaPlusSegreVQ_2_10
import V14Formalization.D12SigmaPlusSegreVQ_2_11
import V14Formalization.D12SigmaPlusSegreVQ_2_12
import V14Formalization.D12SigmaPlusSegreVQ_2_13
import V14Formalization.D12SigmaPlusSegreVQ_2_14
import V14Formalization.D12SigmaPlusSegreVQ_2_15
import V14Formalization.D12SigmaPlusSegreVQ_2_16
import V14Formalization.D12SigmaPlusSegreVQ_2_17
import V14Formalization.D12SigmaPlusSegreVQ_2_18
import V14Formalization.D12SigmaPlusSegreVQ_2_19
import V14Formalization.D12SigmaPlusSegreVQ_2_20
import V14Formalization.D12SigmaPlusSegreVQ_3_0
import V14Formalization.D12SigmaPlusSegreVQ_3_1
import V14Formalization.D12SigmaPlusSegreVQ_3_2
import V14Formalization.D12SigmaPlusSegreVQ_3_3
import V14Formalization.D12SigmaPlusSegreVQ_3_4
import V14Formalization.D12SigmaPlusSegreVQ_3_5
import V14Formalization.D12SigmaPlusSegreVQ_3_6
import V14Formalization.D12SigmaPlusSegreVQ_3_7
import V14Formalization.D12SigmaPlusSegreVQ_3_8
import V14Formalization.D12SigmaPlusSegreVQ_3_9
import V14Formalization.D12SigmaPlusSegreVQ_3_10
import V14Formalization.D12SigmaPlusSegreVQ_3_11
import V14Formalization.D12SigmaPlusSegreVQ_3_12
import V14Formalization.D12SigmaPlusSegreVQ_3_13
import V14Formalization.D12SigmaPlusSegreVQ_3_14
import V14Formalization.D12SigmaPlusSegreVQ_3_15
import V14Formalization.D12SigmaPlusSegreVQ_3_16
import V14Formalization.D12SigmaPlusSegreVQ_3_17
import V14Formalization.D12SigmaPlusSegreVQ_3_18
import V14Formalization.D12SigmaPlusSegreVQ_3_19
import V14Formalization.D12SigmaPlusSegreVQ_3_20
import V14Formalization.D12SigmaPlusSegreVQ_4_0
import V14Formalization.D12SigmaPlusSegreVQ_4_1
import V14Formalization.D12SigmaPlusSegreVQ_4_2
import V14Formalization.D12SigmaPlusSegreVQ_4_3
import V14Formalization.D12SigmaPlusSegreVQ_4_4
import V14Formalization.D12SigmaPlusSegreVQ_4_5
import V14Formalization.D12SigmaPlusSegreVQ_4_6
import V14Formalization.D12SigmaPlusSegreVQ_4_7
import V14Formalization.D12SigmaPlusSegreVQ_4_8
import V14Formalization.D12SigmaPlusSegreVQ_4_9
import V14Formalization.D12SigmaPlusSegreVQ_4_10
import V14Formalization.D12SigmaPlusSegreVQ_4_11
import V14Formalization.D12SigmaPlusSegreVQ_4_12
import V14Formalization.D12SigmaPlusSegreVQ_4_13
import V14Formalization.D12SigmaPlusSegreVQ_4_14
import V14Formalization.D12SigmaPlusSegreVQ_4_15
import V14Formalization.D12SigmaPlusSegreVQ_4_16
import V14Formalization.D12SigmaPlusSegreVQ_4_17
import V14Formalization.D12SigmaPlusSegreVQ_4_18
import V14Formalization.D12SigmaPlusSegreVQ_4_19
import V14Formalization.D12SigmaPlusSegreVQ_4_20
import V14Formalization.D12SigmaPlusSegreVQ_5_0
import V14Formalization.D12SigmaPlusSegreVQ_5_1
import V14Formalization.D12SigmaPlusSegreVQ_5_2
import V14Formalization.D12SigmaPlusSegreVQ_5_3
import V14Formalization.D12SigmaPlusSegreVQ_5_4
import V14Formalization.D12SigmaPlusSegreVQ_5_5
import V14Formalization.D12SigmaPlusSegreVQ_5_6
import V14Formalization.D12SigmaPlusSegreVQ_5_7
import V14Formalization.D12SigmaPlusSegreVQ_5_8
import V14Formalization.D12SigmaPlusSegreVQ_5_9
import V14Formalization.D12SigmaPlusSegreVQ_5_10
import V14Formalization.D12SigmaPlusSegreVQ_5_11
import V14Formalization.D12SigmaPlusSegreVQ_5_12
import V14Formalization.D12SigmaPlusSegreVQ_5_13
import V14Formalization.D12SigmaPlusSegreVQ_5_14
import V14Formalization.D12SigmaPlusSegreVQ_5_15
import V14Formalization.D12SigmaPlusSegreVQ_5_16
import V14Formalization.D12SigmaPlusSegreVQ_5_17
import V14Formalization.D12SigmaPlusSegreVQ_5_18
import V14Formalization.D12SigmaPlusSegreVQ_5_19
import V14Formalization.D12SigmaPlusSegreVQ_5_20
import V14Formalization.D12SigmaPlusSegreVQ_6_0
import V14Formalization.D12SigmaPlusSegreVQ_6_1
import V14Formalization.D12SigmaPlusSegreVQ_6_2
import V14Formalization.D12SigmaPlusSegreVQ_6_3
import V14Formalization.D12SigmaPlusSegreVQ_6_4
import V14Formalization.D12SigmaPlusSegreVQ_6_5
import V14Formalization.D12SigmaPlusSegreVQ_6_6
import V14Formalization.D12SigmaPlusSegreVQ_6_7
import V14Formalization.D12SigmaPlusSegreVQ_6_8
import V14Formalization.D12SigmaPlusSegreVQ_6_9
import V14Formalization.D12SigmaPlusSegreVQ_6_10
import V14Formalization.D12SigmaPlusSegreVQ_6_11
import V14Formalization.D12SigmaPlusSegreVQ_6_12
import V14Formalization.D12SigmaPlusSegreVQ_6_13
import V14Formalization.D12SigmaPlusSegreVQ_6_14
import V14Formalization.D12SigmaPlusSegreVQ_6_15
import V14Formalization.D12SigmaPlusSegreVQ_6_16
import V14Formalization.D12SigmaPlusSegreVQ_6_17
import V14Formalization.D12SigmaPlusSegreVQ_6_18
import V14Formalization.D12SigmaPlusSegreVQ_6_19
import V14Formalization.D12SigmaPlusSegreVQ_6_20
import V14Formalization.D12SigmaPlusSegreVQ_7_0
import V14Formalization.D12SigmaPlusSegreVQ_7_1
import V14Formalization.D12SigmaPlusSegreVQ_7_2
import V14Formalization.D12SigmaPlusSegreVQ_7_3
import V14Formalization.D12SigmaPlusSegreVQ_7_4
import V14Formalization.D12SigmaPlusSegreVQ_7_5
import V14Formalization.D12SigmaPlusSegreVQ_7_6
import V14Formalization.D12SigmaPlusSegreVQ_7_7
import V14Formalization.D12SigmaPlusSegreVQ_7_8
import V14Formalization.D12SigmaPlusSegreVQ_7_9
import V14Formalization.D12SigmaPlusSegreVQ_7_10
import V14Formalization.D12SigmaPlusSegreVQ_7_11
import V14Formalization.D12SigmaPlusSegreVQ_7_12
import V14Formalization.D12SigmaPlusSegreVQ_7_13
import V14Formalization.D12SigmaPlusSegreVQ_7_14
import V14Formalization.D12SigmaPlusSegreVQ_7_15
import V14Formalization.D12SigmaPlusSegreVQ_7_16
import V14Formalization.D12SigmaPlusSegreVQ_7_17
import V14Formalization.D12SigmaPlusSegreVQ_7_18
import V14Formalization.D12SigmaPlusSegreVQ_7_19
import V14Formalization.D12SigmaPlusSegreVQ_7_20
import V14Formalization.D12SigmaPlusSegreVQ_8_0
import V14Formalization.D12SigmaPlusSegreVQ_8_1
import V14Formalization.D12SigmaPlusSegreVQ_8_2
import V14Formalization.D12SigmaPlusSegreVQ_8_3
import V14Formalization.D12SigmaPlusSegreVQ_8_4
import V14Formalization.D12SigmaPlusSegreVQ_8_5
import V14Formalization.D12SigmaPlusSegreVQ_8_6
import V14Formalization.D12SigmaPlusSegreVQ_8_7
import V14Formalization.D12SigmaPlusSegreVQ_8_8
import V14Formalization.D12SigmaPlusSegreVQ_8_9
import V14Formalization.D12SigmaPlusSegreVQ_8_10
import V14Formalization.D12SigmaPlusSegreVQ_8_11
import V14Formalization.D12SigmaPlusSegreVQ_8_12
import V14Formalization.D12SigmaPlusSegreVQ_8_13
import V14Formalization.D12SigmaPlusSegreVQ_8_14
import V14Formalization.D12SigmaPlusSegreVQ_8_15
import V14Formalization.D12SigmaPlusSegreVQ_8_16
import V14Formalization.D12SigmaPlusSegreVQ_8_17
import V14Formalization.D12SigmaPlusSegreVQ_8_18
import V14Formalization.D12SigmaPlusSegreVQ_8_19
import V14Formalization.D12SigmaPlusSegreVQ_8_20

noncomputable section
open Matrix
namespace V14Formalization.D12SigmaPlusSegreCore

theorem spanV_mul_Qplus : spanV * Qplus = minorQ := by
  ext i j
  fin_cases i <;> fin_cases j
  · exact VQ_entry_0_0
  · exact VQ_entry_0_1
  · exact VQ_entry_0_2
  · exact VQ_entry_0_3
  · exact VQ_entry_0_4
  · exact VQ_entry_0_5
  · exact VQ_entry_0_6
  · exact VQ_entry_0_7
  · exact VQ_entry_0_8
  · exact VQ_entry_0_9
  · exact VQ_entry_0_10
  · exact VQ_entry_0_11
  · exact VQ_entry_0_12
  · exact VQ_entry_0_13
  · exact VQ_entry_0_14
  · exact VQ_entry_0_15
  · exact VQ_entry_0_16
  · exact VQ_entry_0_17
  · exact VQ_entry_0_18
  · exact VQ_entry_0_19
  · exact VQ_entry_0_20
  · exact VQ_entry_1_0
  · exact VQ_entry_1_1
  · exact VQ_entry_1_2
  · exact VQ_entry_1_3
  · exact VQ_entry_1_4
  · exact VQ_entry_1_5
  · exact VQ_entry_1_6
  · exact VQ_entry_1_7
  · exact VQ_entry_1_8
  · exact VQ_entry_1_9
  · exact VQ_entry_1_10
  · exact VQ_entry_1_11
  · exact VQ_entry_1_12
  · exact VQ_entry_1_13
  · exact VQ_entry_1_14
  · exact VQ_entry_1_15
  · exact VQ_entry_1_16
  · exact VQ_entry_1_17
  · exact VQ_entry_1_18
  · exact VQ_entry_1_19
  · exact VQ_entry_1_20
  · exact VQ_entry_2_0
  · exact VQ_entry_2_1
  · exact VQ_entry_2_2
  · exact VQ_entry_2_3
  · exact VQ_entry_2_4
  · exact VQ_entry_2_5
  · exact VQ_entry_2_6
  · exact VQ_entry_2_7
  · exact VQ_entry_2_8
  · exact VQ_entry_2_9
  · exact VQ_entry_2_10
  · exact VQ_entry_2_11
  · exact VQ_entry_2_12
  · exact VQ_entry_2_13
  · exact VQ_entry_2_14
  · exact VQ_entry_2_15
  · exact VQ_entry_2_16
  · exact VQ_entry_2_17
  · exact VQ_entry_2_18
  · exact VQ_entry_2_19
  · exact VQ_entry_2_20
  · exact VQ_entry_3_0
  · exact VQ_entry_3_1
  · exact VQ_entry_3_2
  · exact VQ_entry_3_3
  · exact VQ_entry_3_4
  · exact VQ_entry_3_5
  · exact VQ_entry_3_6
  · exact VQ_entry_3_7
  · exact VQ_entry_3_8
  · exact VQ_entry_3_9
  · exact VQ_entry_3_10
  · exact VQ_entry_3_11
  · exact VQ_entry_3_12
  · exact VQ_entry_3_13
  · exact VQ_entry_3_14
  · exact VQ_entry_3_15
  · exact VQ_entry_3_16
  · exact VQ_entry_3_17
  · exact VQ_entry_3_18
  · exact VQ_entry_3_19
  · exact VQ_entry_3_20
  · exact VQ_entry_4_0
  · exact VQ_entry_4_1
  · exact VQ_entry_4_2
  · exact VQ_entry_4_3
  · exact VQ_entry_4_4
  · exact VQ_entry_4_5
  · exact VQ_entry_4_6
  · exact VQ_entry_4_7
  · exact VQ_entry_4_8
  · exact VQ_entry_4_9
  · exact VQ_entry_4_10
  · exact VQ_entry_4_11
  · exact VQ_entry_4_12
  · exact VQ_entry_4_13
  · exact VQ_entry_4_14
  · exact VQ_entry_4_15
  · exact VQ_entry_4_16
  · exact VQ_entry_4_17
  · exact VQ_entry_4_18
  · exact VQ_entry_4_19
  · exact VQ_entry_4_20
  · exact VQ_entry_5_0
  · exact VQ_entry_5_1
  · exact VQ_entry_5_2
  · exact VQ_entry_5_3
  · exact VQ_entry_5_4
  · exact VQ_entry_5_5
  · exact VQ_entry_5_6
  · exact VQ_entry_5_7
  · exact VQ_entry_5_8
  · exact VQ_entry_5_9
  · exact VQ_entry_5_10
  · exact VQ_entry_5_11
  · exact VQ_entry_5_12
  · exact VQ_entry_5_13
  · exact VQ_entry_5_14
  · exact VQ_entry_5_15
  · exact VQ_entry_5_16
  · exact VQ_entry_5_17
  · exact VQ_entry_5_18
  · exact VQ_entry_5_19
  · exact VQ_entry_5_20
  · exact VQ_entry_6_0
  · exact VQ_entry_6_1
  · exact VQ_entry_6_2
  · exact VQ_entry_6_3
  · exact VQ_entry_6_4
  · exact VQ_entry_6_5
  · exact VQ_entry_6_6
  · exact VQ_entry_6_7
  · exact VQ_entry_6_8
  · exact VQ_entry_6_9
  · exact VQ_entry_6_10
  · exact VQ_entry_6_11
  · exact VQ_entry_6_12
  · exact VQ_entry_6_13
  · exact VQ_entry_6_14
  · exact VQ_entry_6_15
  · exact VQ_entry_6_16
  · exact VQ_entry_6_17
  · exact VQ_entry_6_18
  · exact VQ_entry_6_19
  · exact VQ_entry_6_20
  · exact VQ_entry_7_0
  · exact VQ_entry_7_1
  · exact VQ_entry_7_2
  · exact VQ_entry_7_3
  · exact VQ_entry_7_4
  · exact VQ_entry_7_5
  · exact VQ_entry_7_6
  · exact VQ_entry_7_7
  · exact VQ_entry_7_8
  · exact VQ_entry_7_9
  · exact VQ_entry_7_10
  · exact VQ_entry_7_11
  · exact VQ_entry_7_12
  · exact VQ_entry_7_13
  · exact VQ_entry_7_14
  · exact VQ_entry_7_15
  · exact VQ_entry_7_16
  · exact VQ_entry_7_17
  · exact VQ_entry_7_18
  · exact VQ_entry_7_19
  · exact VQ_entry_7_20
  · exact VQ_entry_8_0
  · exact VQ_entry_8_1
  · exact VQ_entry_8_2
  · exact VQ_entry_8_3
  · exact VQ_entry_8_4
  · exact VQ_entry_8_5
  · exact VQ_entry_8_6
  · exact VQ_entry_8_7
  · exact VQ_entry_8_8
  · exact VQ_entry_8_9
  · exact VQ_entry_8_10
  · exact VQ_entry_8_11
  · exact VQ_entry_8_12
  · exact VQ_entry_8_13
  · exact VQ_entry_8_14
  · exact VQ_entry_8_15
  · exact VQ_entry_8_16
  · exact VQ_entry_8_17
  · exact VQ_entry_8_18
  · exact VQ_entry_8_19
  · exact VQ_entry_8_20

end V14Formalization.D12SigmaPlusSegreCore
