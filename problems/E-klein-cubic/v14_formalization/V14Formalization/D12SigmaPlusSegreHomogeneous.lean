/-
Copyright (c) 2026 V14Formalization contributors.
Released under Apache 2.0 license.
-/
module

public import V14Formalization.D12SigmaPlusSegreCore

noncomputable section

open MvPolynomial

namespace V14Formalization.D12SigmaPlusSegreCore

public theorem Fplus_isHomogeneous : Fplus.IsHomogeneous 3 := by
  unfold Fplus
  repeat' apply IsHomogeneous.add
  · exact ((isHomogeneous_X Ki 0).pow 3).C_mul _
  · exact ((((isHomogeneous_X Ki 0).pow 2).mul
      (isHomogeneous_X Ki 1))).C_mul _
  · exact ((((isHomogeneous_X Ki 0).pow 2).mul
      (isHomogeneous_X Ki 2))).C_mul _
  · exact (((isHomogeneous_X Ki 0).mul
      ((isHomogeneous_X Ki 1).pow 2))).C_mul _
  · exact (((((isHomogeneous_X Ki 0).mul
      (isHomogeneous_X Ki 1)).mul (isHomogeneous_X Ki 2)))).C_mul _
  · exact (((isHomogeneous_X Ki 0).mul
      ((isHomogeneous_X Ki 2).pow 2))).C_mul _
  · exact ((isHomogeneous_X Ki 1).pow 3).C_mul _
  · exact ((((isHomogeneous_X Ki 1).pow 2).mul
      (isHomogeneous_X Ki 2))).C_mul _
  · exact (((isHomogeneous_X Ki 1).mul
      ((isHomogeneous_X Ki 2).pow 2))).C_mul _
  · exact ((isHomogeneous_X Ki 2).pow 3).C_mul _

end V14Formalization.D12SigmaPlusSegreCore
