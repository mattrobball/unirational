/-
Auto-generated Fplus chart Nullstellensatz identities.
-/
module

public import V14Formalization.D12SigmaPlusSegreEval
public import V14Formalization.D12SigmaPlusSegreMul
public import V14Formalization.D12PolyZReflection

noncomputable section
open Matrix Polynomial
namespace V14Formalization.D12SigmaPlusSegreCore
open D12PolynomialData
open V14Formalization.D12PolyZReflection

public def Fplus_dU_re_002 : Polynomial ℚ := interpQ 2 [36, 0, 14, 33, -5, 24, 24, -5, 33, 14]
public def Fplus_dU_im_002 : Polynomial ℚ := interpQ 2 [14, 28, -6, 23, 21, -6, 34, 7, 5, 34]
public def Fplus_dU_c_002 : Ki := ofLadj Fplus_dU_re_002 Fplus_dU_im_002

public def Fplus_dU_re_011 : Polynomial ℚ := interpQ 1 [24, 0, 8, 20, -4, 15, 15, -4, 20, 8]
public def Fplus_dU_im_011 : Polynomial ℚ := interpQ 1 [10, 20, -2, 18, 14, -3, 23, 6, 2, 22]
public def Fplus_dU_c_011 : Ki := ofLadj Fplus_dU_re_011 Fplus_dU_im_011

public def Fplus_dU_re_020 : Polynomial ℚ := interpQ 2 [17, 0, 10, 16, -1, 12, 12, -1, 16, 10]
public def Fplus_dU_im_020 : Polynomial ℚ := interpQ 2 [5, 10, -6, 10, 7, -2, 12, 3, 0, 16]
public def Fplus_dU_c_020 : Ki := ofLadj Fplus_dU_re_020 Fplus_dU_im_020

public def Fplus_dU_re_101 : Polynomial ℚ := interpQ 1 [-12, 0, -2, -12, 4, -8, -8, 4, -12, -2]
public def Fplus_dU_im_101 : Polynomial ℚ := interpQ 1 [-8, -16, 2, -15, -10, 1, -17, -6, -1, -18]
public def Fplus_dU_c_101 : Ki := ofLadj Fplus_dU_re_101 Fplus_dU_im_101

public def Fplus_dU_re_110 : Polynomial ℚ := interpQ 1 [7, 0, 3, 7, -2, 3, 3, -2, 7, 3]
public def Fplus_dU_im_110 : Polynomial ℚ := interpQ 1 [2, 4, -2, 3, 5, -2, 6, -1, 1, 6]
public def Fplus_dU_c_110 : Ki := ofLadj Fplus_dU_re_110 Fplus_dU_im_110

public def Fplus_dU_re_200 : Polynomial ℚ := interpQ 4 [18, 0, 12, 15, -3, 9, 9, -3, 15, 12]
public def Fplus_dU_im_200 : Polynomial ℚ := interpQ 4 [0, 0, -6, -3, 3, -3, 3, -3, 3, 6]
public def Fplus_dU_c_200 : Ki := ofLadj Fplus_dU_re_200 Fplus_dU_im_200

public def Fplus_dU : MvPolynomial (Fin 3) Ki :=
  MvPolynomial.C Fplus_dU_c_002 * MvPolynomial.X 2 ^ 2 +
  MvPolynomial.C Fplus_dU_c_011 * MvPolynomial.X 1 * MvPolynomial.X 2 +
  MvPolynomial.C Fplus_dU_c_020 * MvPolynomial.X 1 ^ 2 +
  MvPolynomial.C Fplus_dU_c_101 * MvPolynomial.X 0 * MvPolynomial.X 2 +
  MvPolynomial.C Fplus_dU_c_110 * MvPolynomial.X 0 * MvPolynomial.X 1 +
  MvPolynomial.C Fplus_dU_c_200 * MvPolynomial.X 0 ^ 2

public def Fplus_dV_re_002 : Polynomial ℚ := interpQ 1 [4, 0, 1, 3, 0, 1, 1, 0, 3, 1]
public def Fplus_dV_im_002 : Polynomial ℚ := interpQ 1 [1, 2, -1, 2, 2, 0, 2, 0, 0, 3]
public def Fplus_dV_c_002 : Ki := ofLadj Fplus_dV_re_002 Fplus_dV_im_002

public def Fplus_dV_re_011 : Polynomial ℚ := interpQ 1 [-68, 0, -22, -58, 14, -40, -40, 14, -58, -22]
public def Fplus_dV_im_011 : Polynomial ℚ := interpQ 1 [-28, -56, 12, -52, -36, 8, -64, -20, -4, -68]
public def Fplus_dV_c_011 : Ki := ofLadj Fplus_dV_re_011 Fplus_dV_im_011

public def Fplus_dV_re_020 : Polynomial ℚ := interpQ 1 [-6, 0, -3, -6, 3, -6, -6, 3, -6, -3]
public def Fplus_dV_im_020 : Polynomial ℚ := interpQ 1 [-3, -6, 3, -6, -3, 3, -9, -3, 0, -9]
public def Fplus_dV_c_020 : Ki := ofLadj Fplus_dV_re_020 Fplus_dV_im_020

public def Fplus_dV_re_101 : Polynomial ℚ := interpQ 1 [24, 0, 8, 20, -4, 15, 15, -4, 20, 8]
public def Fplus_dV_im_101 : Polynomial ℚ := interpQ 1 [10, 20, -2, 18, 14, -3, 23, 6, 2, 22]
public def Fplus_dV_c_101 : Ki := ofLadj Fplus_dV_re_101 Fplus_dV_im_101

public def Fplus_dV_re_110 : Polynomial ℚ := interpQ 1 [17, 0, 10, 16, -1, 12, 12, -1, 16, 10]
public def Fplus_dV_im_110 : Polynomial ℚ := interpQ 1 [5, 10, -6, 10, 7, -2, 12, 3, 0, 16]
public def Fplus_dV_c_110 : Ki := ofLadj Fplus_dV_re_110 Fplus_dV_im_110

public def Fplus_dV_re_200 : Polynomial ℚ := interpQ 2 [7, 0, 3, 7, -2, 3, 3, -2, 7, 3]
public def Fplus_dV_im_200 : Polynomial ℚ := interpQ 2 [2, 4, -2, 3, 5, -2, 6, -1, 1, 6]
public def Fplus_dV_c_200 : Ki := ofLadj Fplus_dV_re_200 Fplus_dV_im_200

public def Fplus_dV : MvPolynomial (Fin 3) Ki :=
  MvPolynomial.C Fplus_dV_c_002 * MvPolynomial.X 2 ^ 2 +
  MvPolynomial.C Fplus_dV_c_011 * MvPolynomial.X 1 * MvPolynomial.X 2 +
  MvPolynomial.C Fplus_dV_c_020 * MvPolynomial.X 1 ^ 2 +
  MvPolynomial.C Fplus_dV_c_101 * MvPolynomial.X 0 * MvPolynomial.X 2 +
  MvPolynomial.C Fplus_dV_c_110 * MvPolynomial.X 0 * MvPolynomial.X 1 +
  MvPolynomial.C Fplus_dV_c_200 * MvPolynomial.X 0 ^ 2

public def Fplus_dW_re_002 : Polynomial ℚ := interpQ 1 [3]
public def Fplus_dW_im_002 : Polynomial ℚ := interpQ 1 []
public def Fplus_dW_c_002 : Ki := ofLadj Fplus_dW_re_002 Fplus_dW_im_002

public def Fplus_dW_re_011 : Polynomial ℚ := interpQ 1 [8, 0, 2, 6, 0, 2, 2, 0, 6, 2]
public def Fplus_dW_im_011 : Polynomial ℚ := interpQ 1 [2, 4, -2, 4, 4, 0, 4, 0, 0, 6]
public def Fplus_dW_c_011 : Ki := ofLadj Fplus_dW_re_011 Fplus_dW_im_011

public def Fplus_dW_re_020 : Polynomial ℚ := interpQ 1 [-34, 0, -11, -29, 7, -20, -20, 7, -29, -11]
public def Fplus_dW_im_020 : Polynomial ℚ := interpQ 1 [-14, -28, 6, -26, -18, 4, -32, -10, -2, -34]
public def Fplus_dW_c_020 : Ki := ofLadj Fplus_dW_re_020 Fplus_dW_im_020

public def Fplus_dW_re_101 : Polynomial ℚ := interpQ 1 [36, 0, 14, 33, -5, 24, 24, -5, 33, 14]
public def Fplus_dW_im_101 : Polynomial ℚ := interpQ 1 [14, 28, -6, 23, 21, -6, 34, 7, 5, 34]
public def Fplus_dW_c_101 : Ki := ofLadj Fplus_dW_re_101 Fplus_dW_im_101

public def Fplus_dW_re_110 : Polynomial ℚ := interpQ 1 [24, 0, 8, 20, -4, 15, 15, -4, 20, 8]
public def Fplus_dW_im_110 : Polynomial ℚ := interpQ 1 [10, 20, -2, 18, 14, -3, 23, 6, 2, 22]
public def Fplus_dW_c_110 : Ki := ofLadj Fplus_dW_re_110 Fplus_dW_im_110

public def Fplus_dW_re_200 : Polynomial ℚ := interpQ 1 [-6, 0, -1, -6, 2, -4, -4, 2, -6, -1]
public def Fplus_dW_im_200 : Polynomial ℚ := interpQ 2 [-8, -16, 2, -15, -10, 1, -17, -6, -1, -18]
public def Fplus_dW_c_200 : Ki := ofLadj Fplus_dW_re_200 Fplus_dW_im_200

public def Fplus_dW : MvPolynomial (Fin 3) Ki :=
  MvPolynomial.C Fplus_dW_c_002 * MvPolynomial.X 2 ^ 2 +
  MvPolynomial.C Fplus_dW_c_011 * MvPolynomial.X 1 * MvPolynomial.X 2 +
  MvPolynomial.C Fplus_dW_c_020 * MvPolynomial.X 1 ^ 2 +
  MvPolynomial.C Fplus_dW_c_101 * MvPolynomial.X 0 * MvPolynomial.X 2 +
  MvPolynomial.C Fplus_dW_c_110 * MvPolynomial.X 0 * MvPolynomial.X 1 +
  MvPolynomial.C Fplus_dW_c_200 * MvPolynomial.X 0 ^ 2


-- Defining equations, published so that consumers rewrite with the
-- theorem instead of unfolding the definition (see
-- scripts/table_interface_rewrite.py).  Tactic-mode proofs in the
-- defining module need no `@[expose]`.
public theorem Fplus_dU_re_002_def : Fplus_dU_re_002 = interpQ 2 [36, 0, 14, 33, -5, 24, 24, -5, 33, 14] := by
  rfl

public theorem Fplus_dU_im_002_def : Fplus_dU_im_002 = interpQ 2 [14, 28, -6, 23, 21, -6, 34, 7, 5, 34] := by
  rfl

public theorem Fplus_dU_c_002_def : Fplus_dU_c_002 = ofLadj Fplus_dU_re_002 Fplus_dU_im_002 := by
  rfl

public theorem Fplus_dU_re_011_def : Fplus_dU_re_011 = interpQ 1 [24, 0, 8, 20, -4, 15, 15, -4, 20, 8] := by
  rfl

public theorem Fplus_dU_im_011_def : Fplus_dU_im_011 = interpQ 1 [10, 20, -2, 18, 14, -3, 23, 6, 2, 22] := by
  rfl

public theorem Fplus_dU_c_011_def : Fplus_dU_c_011 = ofLadj Fplus_dU_re_011 Fplus_dU_im_011 := by
  rfl

public theorem Fplus_dU_re_020_def : Fplus_dU_re_020 = interpQ 2 [17, 0, 10, 16, -1, 12, 12, -1, 16, 10] := by
  rfl

public theorem Fplus_dU_im_020_def : Fplus_dU_im_020 = interpQ 2 [5, 10, -6, 10, 7, -2, 12, 3, 0, 16] := by
  rfl

public theorem Fplus_dU_c_020_def : Fplus_dU_c_020 = ofLadj Fplus_dU_re_020 Fplus_dU_im_020 := by
  rfl

public theorem Fplus_dU_re_101_def : Fplus_dU_re_101 = interpQ 1 [-12, 0, -2, -12, 4, -8, -8, 4, -12, -2] := by
  rfl

public theorem Fplus_dU_im_101_def : Fplus_dU_im_101 = interpQ 1 [-8, -16, 2, -15, -10, 1, -17, -6, -1, -18] := by
  rfl

public theorem Fplus_dU_c_101_def : Fplus_dU_c_101 = ofLadj Fplus_dU_re_101 Fplus_dU_im_101 := by
  rfl

public theorem Fplus_dU_re_110_def : Fplus_dU_re_110 = interpQ 1 [7, 0, 3, 7, -2, 3, 3, -2, 7, 3] := by
  rfl

public theorem Fplus_dU_im_110_def : Fplus_dU_im_110 = interpQ 1 [2, 4, -2, 3, 5, -2, 6, -1, 1, 6] := by
  rfl

public theorem Fplus_dU_c_110_def : Fplus_dU_c_110 = ofLadj Fplus_dU_re_110 Fplus_dU_im_110 := by
  rfl

public theorem Fplus_dU_re_200_def : Fplus_dU_re_200 = interpQ 4 [18, 0, 12, 15, -3, 9, 9, -3, 15, 12] := by
  rfl

public theorem Fplus_dU_im_200_def : Fplus_dU_im_200 = interpQ 4 [0, 0, -6, -3, 3, -3, 3, -3, 3, 6] := by
  rfl

public theorem Fplus_dU_c_200_def : Fplus_dU_c_200 = ofLadj Fplus_dU_re_200 Fplus_dU_im_200 := by
  rfl

public theorem Fplus_dU_def : Fplus_dU = MvPolynomial.C Fplus_dU_c_002 * MvPolynomial.X 2 ^ 2 +
  MvPolynomial.C Fplus_dU_c_011 * MvPolynomial.X 1 * MvPolynomial.X 2 +
  MvPolynomial.C Fplus_dU_c_020 * MvPolynomial.X 1 ^ 2 +
  MvPolynomial.C Fplus_dU_c_101 * MvPolynomial.X 0 * MvPolynomial.X 2 +
  MvPolynomial.C Fplus_dU_c_110 * MvPolynomial.X 0 * MvPolynomial.X 1 +
  MvPolynomial.C Fplus_dU_c_200 * MvPolynomial.X 0 ^ 2 := by
  rfl

public theorem Fplus_dV_re_002_def : Fplus_dV_re_002 = interpQ 1 [4, 0, 1, 3, 0, 1, 1, 0, 3, 1] := by
  rfl

public theorem Fplus_dV_im_002_def : Fplus_dV_im_002 = interpQ 1 [1, 2, -1, 2, 2, 0, 2, 0, 0, 3] := by
  rfl

public theorem Fplus_dV_c_002_def : Fplus_dV_c_002 = ofLadj Fplus_dV_re_002 Fplus_dV_im_002 := by
  rfl

public theorem Fplus_dV_re_011_def : Fplus_dV_re_011 = interpQ 1 [-68, 0, -22, -58, 14, -40, -40, 14, -58, -22] := by
  rfl

public theorem Fplus_dV_im_011_def : Fplus_dV_im_011 = interpQ 1 [-28, -56, 12, -52, -36, 8, -64, -20, -4, -68] := by
  rfl

public theorem Fplus_dV_c_011_def : Fplus_dV_c_011 = ofLadj Fplus_dV_re_011 Fplus_dV_im_011 := by
  rfl

public theorem Fplus_dV_re_020_def : Fplus_dV_re_020 = interpQ 1 [-6, 0, -3, -6, 3, -6, -6, 3, -6, -3] := by
  rfl

public theorem Fplus_dV_im_020_def : Fplus_dV_im_020 = interpQ 1 [-3, -6, 3, -6, -3, 3, -9, -3, 0, -9] := by
  rfl

public theorem Fplus_dV_c_020_def : Fplus_dV_c_020 = ofLadj Fplus_dV_re_020 Fplus_dV_im_020 := by
  rfl

public theorem Fplus_dV_re_101_def : Fplus_dV_re_101 = interpQ 1 [24, 0, 8, 20, -4, 15, 15, -4, 20, 8] := by
  rfl

public theorem Fplus_dV_im_101_def : Fplus_dV_im_101 = interpQ 1 [10, 20, -2, 18, 14, -3, 23, 6, 2, 22] := by
  rfl

public theorem Fplus_dV_c_101_def : Fplus_dV_c_101 = ofLadj Fplus_dV_re_101 Fplus_dV_im_101 := by
  rfl

public theorem Fplus_dV_re_110_def : Fplus_dV_re_110 = interpQ 1 [17, 0, 10, 16, -1, 12, 12, -1, 16, 10] := by
  rfl

public theorem Fplus_dV_im_110_def : Fplus_dV_im_110 = interpQ 1 [5, 10, -6, 10, 7, -2, 12, 3, 0, 16] := by
  rfl

public theorem Fplus_dV_c_110_def : Fplus_dV_c_110 = ofLadj Fplus_dV_re_110 Fplus_dV_im_110 := by
  rfl

public theorem Fplus_dV_re_200_def : Fplus_dV_re_200 = interpQ 2 [7, 0, 3, 7, -2, 3, 3, -2, 7, 3] := by
  rfl

public theorem Fplus_dV_im_200_def : Fplus_dV_im_200 = interpQ 2 [2, 4, -2, 3, 5, -2, 6, -1, 1, 6] := by
  rfl

public theorem Fplus_dV_c_200_def : Fplus_dV_c_200 = ofLadj Fplus_dV_re_200 Fplus_dV_im_200 := by
  rfl

public theorem Fplus_dV_def : Fplus_dV = MvPolynomial.C Fplus_dV_c_002 * MvPolynomial.X 2 ^ 2 +
  MvPolynomial.C Fplus_dV_c_011 * MvPolynomial.X 1 * MvPolynomial.X 2 +
  MvPolynomial.C Fplus_dV_c_020 * MvPolynomial.X 1 ^ 2 +
  MvPolynomial.C Fplus_dV_c_101 * MvPolynomial.X 0 * MvPolynomial.X 2 +
  MvPolynomial.C Fplus_dV_c_110 * MvPolynomial.X 0 * MvPolynomial.X 1 +
  MvPolynomial.C Fplus_dV_c_200 * MvPolynomial.X 0 ^ 2 := by
  rfl

public theorem Fplus_dW_re_002_def : Fplus_dW_re_002 = interpQ 1 [3] := by
  rfl

public theorem Fplus_dW_im_002_def : Fplus_dW_im_002 = interpQ 1 [] := by
  rfl

public theorem Fplus_dW_c_002_def : Fplus_dW_c_002 = ofLadj Fplus_dW_re_002 Fplus_dW_im_002 := by
  rfl

public theorem Fplus_dW_re_011_def : Fplus_dW_re_011 = interpQ 1 [8, 0, 2, 6, 0, 2, 2, 0, 6, 2] := by
  rfl

public theorem Fplus_dW_im_011_def : Fplus_dW_im_011 = interpQ 1 [2, 4, -2, 4, 4, 0, 4, 0, 0, 6] := by
  rfl

public theorem Fplus_dW_c_011_def : Fplus_dW_c_011 = ofLadj Fplus_dW_re_011 Fplus_dW_im_011 := by
  rfl

public theorem Fplus_dW_re_020_def : Fplus_dW_re_020 = interpQ 1 [-34, 0, -11, -29, 7, -20, -20, 7, -29, -11] := by
  rfl

public theorem Fplus_dW_im_020_def : Fplus_dW_im_020 = interpQ 1 [-14, -28, 6, -26, -18, 4, -32, -10, -2, -34] := by
  rfl

public theorem Fplus_dW_c_020_def : Fplus_dW_c_020 = ofLadj Fplus_dW_re_020 Fplus_dW_im_020 := by
  rfl

public theorem Fplus_dW_re_101_def : Fplus_dW_re_101 = interpQ 1 [36, 0, 14, 33, -5, 24, 24, -5, 33, 14] := by
  rfl

public theorem Fplus_dW_im_101_def : Fplus_dW_im_101 = interpQ 1 [14, 28, -6, 23, 21, -6, 34, 7, 5, 34] := by
  rfl

public theorem Fplus_dW_c_101_def : Fplus_dW_c_101 = ofLadj Fplus_dW_re_101 Fplus_dW_im_101 := by
  rfl

public theorem Fplus_dW_re_110_def : Fplus_dW_re_110 = interpQ 1 [24, 0, 8, 20, -4, 15, 15, -4, 20, 8] := by
  rfl

public theorem Fplus_dW_im_110_def : Fplus_dW_im_110 = interpQ 1 [10, 20, -2, 18, 14, -3, 23, 6, 2, 22] := by
  rfl

public theorem Fplus_dW_c_110_def : Fplus_dW_c_110 = ofLadj Fplus_dW_re_110 Fplus_dW_im_110 := by
  rfl

public theorem Fplus_dW_re_200_def : Fplus_dW_re_200 = interpQ 1 [-6, 0, -1, -6, 2, -4, -4, 2, -6, -1] := by
  rfl

public theorem Fplus_dW_im_200_def : Fplus_dW_im_200 = interpQ 2 [-8, -16, 2, -15, -10, 1, -17, -6, -1, -18] := by
  rfl

public theorem Fplus_dW_c_200_def : Fplus_dW_c_200 = ofLadj Fplus_dW_re_200 Fplus_dW_im_200 := by
  rfl

public theorem Fplus_dW_def : Fplus_dW = MvPolynomial.C Fplus_dW_c_002 * MvPolynomial.X 2 ^ 2 +
  MvPolynomial.C Fplus_dW_c_011 * MvPolynomial.X 1 * MvPolynomial.X 2 +
  MvPolynomial.C Fplus_dW_c_020 * MvPolynomial.X 1 ^ 2 +
  MvPolynomial.C Fplus_dW_c_101 * MvPolynomial.X 0 * MvPolynomial.X 2 +
  MvPolynomial.C Fplus_dW_c_110 * MvPolynomial.X 0 * MvPolynomial.X 1 +
  MvPolynomial.C Fplus_dW_c_200 * MvPolynomial.X 0 ^ 2 := by
  rfl

end V14Formalization.D12SigmaPlusSegreCore
