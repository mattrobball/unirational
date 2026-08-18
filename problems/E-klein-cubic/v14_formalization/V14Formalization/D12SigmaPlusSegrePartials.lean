/-
Auto-generated Fplus chart Nullstellensatz identities.
-/
module

public import V14Formalization.D12SigmaPlusSegreEval
public import V14Formalization.D12SigmaPlusSegreMul

noncomputable section
open Matrix Polynomial
namespace V14Formalization.D12SigmaPlusSegreCore
open D12PolynomialData

public def Fplus_dU_re_002 : Polynomial ℚ := C (18) + C (7) * X ^ 2 + C ((33 / 2 : ℚ)) * X ^ 3 + C ((-5 / 2 : ℚ)) * X ^ 4 + C (12) * X ^ 5 + C (12) * X ^ 6 + C ((-5 / 2 : ℚ)) * X ^ 7 + C ((33 / 2 : ℚ)) * X ^ 8 + C (7) * X ^ 9
public def Fplus_dU_im_002 : Polynomial ℚ := C (7) + C (14) * X + C (-3) * X ^ 2 + C ((23 / 2 : ℚ)) * X ^ 3 + C ((21 / 2 : ℚ)) * X ^ 4 + C (-3) * X ^ 5 + C (17) * X ^ 6 + C ((7 / 2 : ℚ)) * X ^ 7 + C ((5 / 2 : ℚ)) * X ^ 8 + C (17) * X ^ 9
public def Fplus_dU_c_002 : Ki := ofLadj Fplus_dU_re_002 Fplus_dU_im_002

public def Fplus_dU_re_011 : Polynomial ℚ := C (24) + C (8) * X ^ 2 + C (20) * X ^ 3 + C (-4) * X ^ 4 + C (15) * X ^ 5 + C (15) * X ^ 6 + C (-4) * X ^ 7 + C (20) * X ^ 8 + C (8) * X ^ 9
public def Fplus_dU_im_011 : Polynomial ℚ := C (10) + C (20) * X + C (-2) * X ^ 2 + C (18) * X ^ 3 + C (14) * X ^ 4 + C (-3) * X ^ 5 + C (23) * X ^ 6 + C (6) * X ^ 7 + C (2) * X ^ 8 + C (22) * X ^ 9
public def Fplus_dU_c_011 : Ki := ofLadj Fplus_dU_re_011 Fplus_dU_im_011

public def Fplus_dU_re_020 : Polynomial ℚ := C ((17 / 2 : ℚ)) + C (5) * X ^ 2 + C (8) * X ^ 3 + C ((-1 / 2 : ℚ)) * X ^ 4 + C (6) * X ^ 5 + C (6) * X ^ 6 + C ((-1 / 2 : ℚ)) * X ^ 7 + C (8) * X ^ 8 + C (5) * X ^ 9
public def Fplus_dU_im_020 : Polynomial ℚ := C ((5 / 2 : ℚ)) + C (5) * X + C (-3) * X ^ 2 + C (5) * X ^ 3 + C ((7 / 2 : ℚ)) * X ^ 4 + C (-1) * X ^ 5 + C (6) * X ^ 6 + C ((3 / 2 : ℚ)) * X ^ 7 + C (8) * X ^ 9
public def Fplus_dU_c_020 : Ki := ofLadj Fplus_dU_re_020 Fplus_dU_im_020

public def Fplus_dU_re_101 : Polynomial ℚ := C (-12) + C (-2) * X ^ 2 + C (-12) * X ^ 3 + C (4) * X ^ 4 + C (-8) * X ^ 5 + C (-8) * X ^ 6 + C (4) * X ^ 7 + C (-12) * X ^ 8 + C (-2) * X ^ 9
public def Fplus_dU_im_101 : Polynomial ℚ := C (-8) + C (-16) * X + C (2) * X ^ 2 + C (-15) * X ^ 3 + C (-10) * X ^ 4 + C (1) * X ^ 5 + C (-17) * X ^ 6 + C (-6) * X ^ 7 + C (-1) * X ^ 8 + C (-18) * X ^ 9
public def Fplus_dU_c_101 : Ki := ofLadj Fplus_dU_re_101 Fplus_dU_im_101

public def Fplus_dU_re_110 : Polynomial ℚ := C (7) + C (3) * X ^ 2 + C (7) * X ^ 3 + C (-2) * X ^ 4 + C (3) * X ^ 5 + C (3) * X ^ 6 + C (-2) * X ^ 7 + C (7) * X ^ 8 + C (3) * X ^ 9
public def Fplus_dU_im_110 : Polynomial ℚ := C (2) + C (4) * X + C (-2) * X ^ 2 + C (3) * X ^ 3 + C (5) * X ^ 4 + C (-2) * X ^ 5 + C (6) * X ^ 6 + C (-1) * X ^ 7 + C (1) * X ^ 8 + C (6) * X ^ 9
public def Fplus_dU_c_110 : Ki := ofLadj Fplus_dU_re_110 Fplus_dU_im_110

public def Fplus_dU_re_200 : Polynomial ℚ := C ((9 / 2 : ℚ)) + C (3) * X ^ 2 + C ((15 / 4 : ℚ)) * X ^ 3 + C ((-3 / 4 : ℚ)) * X ^ 4 + C ((9 / 4 : ℚ)) * X ^ 5 + C ((9 / 4 : ℚ)) * X ^ 6 + C ((-3 / 4 : ℚ)) * X ^ 7 + C ((15 / 4 : ℚ)) * X ^ 8 + C (3) * X ^ 9
public def Fplus_dU_im_200 : Polynomial ℚ := C ((-3 / 2 : ℚ)) * X ^ 2 + C ((-3 / 4 : ℚ)) * X ^ 3 + C ((3 / 4 : ℚ)) * X ^ 4 + C ((-3 / 4 : ℚ)) * X ^ 5 + C ((3 / 4 : ℚ)) * X ^ 6 + C ((-3 / 4 : ℚ)) * X ^ 7 + C ((3 / 4 : ℚ)) * X ^ 8 + C ((3 / 2 : ℚ)) * X ^ 9
public def Fplus_dU_c_200 : Ki := ofLadj Fplus_dU_re_200 Fplus_dU_im_200

public def Fplus_dU : MvPolynomial (Fin 3) Ki :=
  MvPolynomial.C Fplus_dU_c_002 * MvPolynomial.X 2 ^ 2 +
  MvPolynomial.C Fplus_dU_c_011 * MvPolynomial.X 1 * MvPolynomial.X 2 +
  MvPolynomial.C Fplus_dU_c_020 * MvPolynomial.X 1 ^ 2 +
  MvPolynomial.C Fplus_dU_c_101 * MvPolynomial.X 0 * MvPolynomial.X 2 +
  MvPolynomial.C Fplus_dU_c_110 * MvPolynomial.X 0 * MvPolynomial.X 1 +
  MvPolynomial.C Fplus_dU_c_200 * MvPolynomial.X 0 ^ 2

public def Fplus_dV_re_002 : Polynomial ℚ := C (4) + C (1) * X ^ 2 + C (3) * X ^ 3 + C (1) * X ^ 5 + C (1) * X ^ 6 + C (3) * X ^ 8 + C (1) * X ^ 9
public def Fplus_dV_im_002 : Polynomial ℚ := C (1) + C (2) * X + C (-1) * X ^ 2 + C (2) * X ^ 3 + C (2) * X ^ 4 + C (2) * X ^ 6 + C (3) * X ^ 9
public def Fplus_dV_c_002 : Ki := ofLadj Fplus_dV_re_002 Fplus_dV_im_002

public def Fplus_dV_re_011 : Polynomial ℚ := C (-68) + C (-22) * X ^ 2 + C (-58) * X ^ 3 + C (14) * X ^ 4 + C (-40) * X ^ 5 + C (-40) * X ^ 6 + C (14) * X ^ 7 + C (-58) * X ^ 8 + C (-22) * X ^ 9
public def Fplus_dV_im_011 : Polynomial ℚ := C (-28) + C (-56) * X + C (12) * X ^ 2 + C (-52) * X ^ 3 + C (-36) * X ^ 4 + C (8) * X ^ 5 + C (-64) * X ^ 6 + C (-20) * X ^ 7 + C (-4) * X ^ 8 + C (-68) * X ^ 9
public def Fplus_dV_c_011 : Ki := ofLadj Fplus_dV_re_011 Fplus_dV_im_011

public def Fplus_dV_re_020 : Polynomial ℚ := C (-6) + C (-3) * X ^ 2 + C (-6) * X ^ 3 + C (3) * X ^ 4 + C (-6) * X ^ 5 + C (-6) * X ^ 6 + C (3) * X ^ 7 + C (-6) * X ^ 8 + C (-3) * X ^ 9
public def Fplus_dV_im_020 : Polynomial ℚ := C (-3) + C (-6) * X + C (3) * X ^ 2 + C (-6) * X ^ 3 + C (-3) * X ^ 4 + C (3) * X ^ 5 + C (-9) * X ^ 6 + C (-3) * X ^ 7 + C (-9) * X ^ 9
public def Fplus_dV_c_020 : Ki := ofLadj Fplus_dV_re_020 Fplus_dV_im_020

public def Fplus_dV_re_101 : Polynomial ℚ := C (24) + C (8) * X ^ 2 + C (20) * X ^ 3 + C (-4) * X ^ 4 + C (15) * X ^ 5 + C (15) * X ^ 6 + C (-4) * X ^ 7 + C (20) * X ^ 8 + C (8) * X ^ 9
public def Fplus_dV_im_101 : Polynomial ℚ := C (10) + C (20) * X + C (-2) * X ^ 2 + C (18) * X ^ 3 + C (14) * X ^ 4 + C (-3) * X ^ 5 + C (23) * X ^ 6 + C (6) * X ^ 7 + C (2) * X ^ 8 + C (22) * X ^ 9
public def Fplus_dV_c_101 : Ki := ofLadj Fplus_dV_re_101 Fplus_dV_im_101

public def Fplus_dV_re_110 : Polynomial ℚ := C (17) + C (10) * X ^ 2 + C (16) * X ^ 3 + C (-1) * X ^ 4 + C (12) * X ^ 5 + C (12) * X ^ 6 + C (-1) * X ^ 7 + C (16) * X ^ 8 + C (10) * X ^ 9
public def Fplus_dV_im_110 : Polynomial ℚ := C (5) + C (10) * X + C (-6) * X ^ 2 + C (10) * X ^ 3 + C (7) * X ^ 4 + C (-2) * X ^ 5 + C (12) * X ^ 6 + C (3) * X ^ 7 + C (16) * X ^ 9
public def Fplus_dV_c_110 : Ki := ofLadj Fplus_dV_re_110 Fplus_dV_im_110

public def Fplus_dV_re_200 : Polynomial ℚ := C ((7 / 2 : ℚ)) + C ((3 / 2 : ℚ)) * X ^ 2 + C ((7 / 2 : ℚ)) * X ^ 3 + C (-1) * X ^ 4 + C ((3 / 2 : ℚ)) * X ^ 5 + C ((3 / 2 : ℚ)) * X ^ 6 + C (-1) * X ^ 7 + C ((7 / 2 : ℚ)) * X ^ 8 + C ((3 / 2 : ℚ)) * X ^ 9
public def Fplus_dV_im_200 : Polynomial ℚ := C (1) + C (2) * X + C (-1) * X ^ 2 + C ((3 / 2 : ℚ)) * X ^ 3 + C ((5 / 2 : ℚ)) * X ^ 4 + C (-1) * X ^ 5 + C (3) * X ^ 6 + C ((-1 / 2 : ℚ)) * X ^ 7 + C ((1 / 2 : ℚ)) * X ^ 8 + C (3) * X ^ 9
public def Fplus_dV_c_200 : Ki := ofLadj Fplus_dV_re_200 Fplus_dV_im_200

public def Fplus_dV : MvPolynomial (Fin 3) Ki :=
  MvPolynomial.C Fplus_dV_c_002 * MvPolynomial.X 2 ^ 2 +
  MvPolynomial.C Fplus_dV_c_011 * MvPolynomial.X 1 * MvPolynomial.X 2 +
  MvPolynomial.C Fplus_dV_c_020 * MvPolynomial.X 1 ^ 2 +
  MvPolynomial.C Fplus_dV_c_101 * MvPolynomial.X 0 * MvPolynomial.X 2 +
  MvPolynomial.C Fplus_dV_c_110 * MvPolynomial.X 0 * MvPolynomial.X 1 +
  MvPolynomial.C Fplus_dV_c_200 * MvPolynomial.X 0 ^ 2

public def Fplus_dW_re_002 : Polynomial ℚ := C (3)
public def Fplus_dW_im_002 : Polynomial ℚ := (0 : Polynomial ℚ)
public def Fplus_dW_c_002 : Ki := ofLadj Fplus_dW_re_002 Fplus_dW_im_002

public def Fplus_dW_re_011 : Polynomial ℚ := C (8) + C (2) * X ^ 2 + C (6) * X ^ 3 + C (2) * X ^ 5 + C (2) * X ^ 6 + C (6) * X ^ 8 + C (2) * X ^ 9
public def Fplus_dW_im_011 : Polynomial ℚ := C (2) + C (4) * X + C (-2) * X ^ 2 + C (4) * X ^ 3 + C (4) * X ^ 4 + C (4) * X ^ 6 + C (6) * X ^ 9
public def Fplus_dW_c_011 : Ki := ofLadj Fplus_dW_re_011 Fplus_dW_im_011

public def Fplus_dW_re_020 : Polynomial ℚ := C (-34) + C (-11) * X ^ 2 + C (-29) * X ^ 3 + C (7) * X ^ 4 + C (-20) * X ^ 5 + C (-20) * X ^ 6 + C (7) * X ^ 7 + C (-29) * X ^ 8 + C (-11) * X ^ 9
public def Fplus_dW_im_020 : Polynomial ℚ := C (-14) + C (-28) * X + C (6) * X ^ 2 + C (-26) * X ^ 3 + C (-18) * X ^ 4 + C (4) * X ^ 5 + C (-32) * X ^ 6 + C (-10) * X ^ 7 + C (-2) * X ^ 8 + C (-34) * X ^ 9
public def Fplus_dW_c_020 : Ki := ofLadj Fplus_dW_re_020 Fplus_dW_im_020

public def Fplus_dW_re_101 : Polynomial ℚ := C (36) + C (14) * X ^ 2 + C (33) * X ^ 3 + C (-5) * X ^ 4 + C (24) * X ^ 5 + C (24) * X ^ 6 + C (-5) * X ^ 7 + C (33) * X ^ 8 + C (14) * X ^ 9
public def Fplus_dW_im_101 : Polynomial ℚ := C (14) + C (28) * X + C (-6) * X ^ 2 + C (23) * X ^ 3 + C (21) * X ^ 4 + C (-6) * X ^ 5 + C (34) * X ^ 6 + C (7) * X ^ 7 + C (5) * X ^ 8 + C (34) * X ^ 9
public def Fplus_dW_c_101 : Ki := ofLadj Fplus_dW_re_101 Fplus_dW_im_101

public def Fplus_dW_re_110 : Polynomial ℚ := C (24) + C (8) * X ^ 2 + C (20) * X ^ 3 + C (-4) * X ^ 4 + C (15) * X ^ 5 + C (15) * X ^ 6 + C (-4) * X ^ 7 + C (20) * X ^ 8 + C (8) * X ^ 9
public def Fplus_dW_im_110 : Polynomial ℚ := C (10) + C (20) * X + C (-2) * X ^ 2 + C (18) * X ^ 3 + C (14) * X ^ 4 + C (-3) * X ^ 5 + C (23) * X ^ 6 + C (6) * X ^ 7 + C (2) * X ^ 8 + C (22) * X ^ 9
public def Fplus_dW_c_110 : Ki := ofLadj Fplus_dW_re_110 Fplus_dW_im_110

public def Fplus_dW_re_200 : Polynomial ℚ := C (-6) + C (-1) * X ^ 2 + C (-6) * X ^ 3 + C (2) * X ^ 4 + C (-4) * X ^ 5 + C (-4) * X ^ 6 + C (2) * X ^ 7 + C (-6) * X ^ 8 + C (-1) * X ^ 9
public def Fplus_dW_im_200 : Polynomial ℚ := C (-4) + C (-8) * X + C (1) * X ^ 2 + C ((-15 / 2 : ℚ)) * X ^ 3 + C (-5) * X ^ 4 + C ((1 / 2 : ℚ)) * X ^ 5 + C ((-17 / 2 : ℚ)) * X ^ 6 + C (-3) * X ^ 7 + C ((-1 / 2 : ℚ)) * X ^ 8 + C (-9) * X ^ 9
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
public theorem Fplus_dU_re_002_def : Fplus_dU_re_002 = C (18) + C (7) * X ^ 2 + C ((33 / 2 : ℚ)) * X ^ 3 + C ((-5 / 2 : ℚ)) * X ^ 4 + C (12) * X ^ 5 + C (12) * X ^ 6 + C ((-5 / 2 : ℚ)) * X ^ 7 + C ((33 / 2 : ℚ)) * X ^ 8 + C (7) * X ^ 9 := by
  rfl

public theorem Fplus_dU_im_002_def : Fplus_dU_im_002 = C (7) + C (14) * X + C (-3) * X ^ 2 + C ((23 / 2 : ℚ)) * X ^ 3 + C ((21 / 2 : ℚ)) * X ^ 4 + C (-3) * X ^ 5 + C (17) * X ^ 6 + C ((7 / 2 : ℚ)) * X ^ 7 + C ((5 / 2 : ℚ)) * X ^ 8 + C (17) * X ^ 9 := by
  rfl

public theorem Fplus_dU_c_002_def : Fplus_dU_c_002 = ofLadj Fplus_dU_re_002 Fplus_dU_im_002 := by
  rfl

public theorem Fplus_dU_re_011_def : Fplus_dU_re_011 = C (24) + C (8) * X ^ 2 + C (20) * X ^ 3 + C (-4) * X ^ 4 + C (15) * X ^ 5 + C (15) * X ^ 6 + C (-4) * X ^ 7 + C (20) * X ^ 8 + C (8) * X ^ 9 := by
  rfl

public theorem Fplus_dU_im_011_def : Fplus_dU_im_011 = C (10) + C (20) * X + C (-2) * X ^ 2 + C (18) * X ^ 3 + C (14) * X ^ 4 + C (-3) * X ^ 5 + C (23) * X ^ 6 + C (6) * X ^ 7 + C (2) * X ^ 8 + C (22) * X ^ 9 := by
  rfl

public theorem Fplus_dU_c_011_def : Fplus_dU_c_011 = ofLadj Fplus_dU_re_011 Fplus_dU_im_011 := by
  rfl

public theorem Fplus_dU_re_020_def : Fplus_dU_re_020 = C ((17 / 2 : ℚ)) + C (5) * X ^ 2 + C (8) * X ^ 3 + C ((-1 / 2 : ℚ)) * X ^ 4 + C (6) * X ^ 5 + C (6) * X ^ 6 + C ((-1 / 2 : ℚ)) * X ^ 7 + C (8) * X ^ 8 + C (5) * X ^ 9 := by
  rfl

public theorem Fplus_dU_im_020_def : Fplus_dU_im_020 = C ((5 / 2 : ℚ)) + C (5) * X + C (-3) * X ^ 2 + C (5) * X ^ 3 + C ((7 / 2 : ℚ)) * X ^ 4 + C (-1) * X ^ 5 + C (6) * X ^ 6 + C ((3 / 2 : ℚ)) * X ^ 7 + C (8) * X ^ 9 := by
  rfl

public theorem Fplus_dU_c_020_def : Fplus_dU_c_020 = ofLadj Fplus_dU_re_020 Fplus_dU_im_020 := by
  rfl

public theorem Fplus_dU_re_101_def : Fplus_dU_re_101 = C (-12) + C (-2) * X ^ 2 + C (-12) * X ^ 3 + C (4) * X ^ 4 + C (-8) * X ^ 5 + C (-8) * X ^ 6 + C (4) * X ^ 7 + C (-12) * X ^ 8 + C (-2) * X ^ 9 := by
  rfl

public theorem Fplus_dU_im_101_def : Fplus_dU_im_101 = C (-8) + C (-16) * X + C (2) * X ^ 2 + C (-15) * X ^ 3 + C (-10) * X ^ 4 + C (1) * X ^ 5 + C (-17) * X ^ 6 + C (-6) * X ^ 7 + C (-1) * X ^ 8 + C (-18) * X ^ 9 := by
  rfl

public theorem Fplus_dU_c_101_def : Fplus_dU_c_101 = ofLadj Fplus_dU_re_101 Fplus_dU_im_101 := by
  rfl

public theorem Fplus_dU_re_110_def : Fplus_dU_re_110 = C (7) + C (3) * X ^ 2 + C (7) * X ^ 3 + C (-2) * X ^ 4 + C (3) * X ^ 5 + C (3) * X ^ 6 + C (-2) * X ^ 7 + C (7) * X ^ 8 + C (3) * X ^ 9 := by
  rfl

public theorem Fplus_dU_im_110_def : Fplus_dU_im_110 = C (2) + C (4) * X + C (-2) * X ^ 2 + C (3) * X ^ 3 + C (5) * X ^ 4 + C (-2) * X ^ 5 + C (6) * X ^ 6 + C (-1) * X ^ 7 + C (1) * X ^ 8 + C (6) * X ^ 9 := by
  rfl

public theorem Fplus_dU_c_110_def : Fplus_dU_c_110 = ofLadj Fplus_dU_re_110 Fplus_dU_im_110 := by
  rfl

public theorem Fplus_dU_re_200_def : Fplus_dU_re_200 = C ((9 / 2 : ℚ)) + C (3) * X ^ 2 + C ((15 / 4 : ℚ)) * X ^ 3 + C ((-3 / 4 : ℚ)) * X ^ 4 + C ((9 / 4 : ℚ)) * X ^ 5 + C ((9 / 4 : ℚ)) * X ^ 6 + C ((-3 / 4 : ℚ)) * X ^ 7 + C ((15 / 4 : ℚ)) * X ^ 8 + C (3) * X ^ 9 := by
  rfl

public theorem Fplus_dU_im_200_def : Fplus_dU_im_200 = C ((-3 / 2 : ℚ)) * X ^ 2 + C ((-3 / 4 : ℚ)) * X ^ 3 + C ((3 / 4 : ℚ)) * X ^ 4 + C ((-3 / 4 : ℚ)) * X ^ 5 + C ((3 / 4 : ℚ)) * X ^ 6 + C ((-3 / 4 : ℚ)) * X ^ 7 + C ((3 / 4 : ℚ)) * X ^ 8 + C ((3 / 2 : ℚ)) * X ^ 9 := by
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

public theorem Fplus_dV_re_002_def : Fplus_dV_re_002 = C (4) + C (1) * X ^ 2 + C (3) * X ^ 3 + C (1) * X ^ 5 + C (1) * X ^ 6 + C (3) * X ^ 8 + C (1) * X ^ 9 := by
  rfl

public theorem Fplus_dV_im_002_def : Fplus_dV_im_002 = C (1) + C (2) * X + C (-1) * X ^ 2 + C (2) * X ^ 3 + C (2) * X ^ 4 + C (2) * X ^ 6 + C (3) * X ^ 9 := by
  rfl

public theorem Fplus_dV_c_002_def : Fplus_dV_c_002 = ofLadj Fplus_dV_re_002 Fplus_dV_im_002 := by
  rfl

public theorem Fplus_dV_re_011_def : Fplus_dV_re_011 = C (-68) + C (-22) * X ^ 2 + C (-58) * X ^ 3 + C (14) * X ^ 4 + C (-40) * X ^ 5 + C (-40) * X ^ 6 + C (14) * X ^ 7 + C (-58) * X ^ 8 + C (-22) * X ^ 9 := by
  rfl

public theorem Fplus_dV_im_011_def : Fplus_dV_im_011 = C (-28) + C (-56) * X + C (12) * X ^ 2 + C (-52) * X ^ 3 + C (-36) * X ^ 4 + C (8) * X ^ 5 + C (-64) * X ^ 6 + C (-20) * X ^ 7 + C (-4) * X ^ 8 + C (-68) * X ^ 9 := by
  rfl

public theorem Fplus_dV_c_011_def : Fplus_dV_c_011 = ofLadj Fplus_dV_re_011 Fplus_dV_im_011 := by
  rfl

public theorem Fplus_dV_re_020_def : Fplus_dV_re_020 = C (-6) + C (-3) * X ^ 2 + C (-6) * X ^ 3 + C (3) * X ^ 4 + C (-6) * X ^ 5 + C (-6) * X ^ 6 + C (3) * X ^ 7 + C (-6) * X ^ 8 + C (-3) * X ^ 9 := by
  rfl

public theorem Fplus_dV_im_020_def : Fplus_dV_im_020 = C (-3) + C (-6) * X + C (3) * X ^ 2 + C (-6) * X ^ 3 + C (-3) * X ^ 4 + C (3) * X ^ 5 + C (-9) * X ^ 6 + C (-3) * X ^ 7 + C (-9) * X ^ 9 := by
  rfl

public theorem Fplus_dV_c_020_def : Fplus_dV_c_020 = ofLadj Fplus_dV_re_020 Fplus_dV_im_020 := by
  rfl

public theorem Fplus_dV_re_101_def : Fplus_dV_re_101 = C (24) + C (8) * X ^ 2 + C (20) * X ^ 3 + C (-4) * X ^ 4 + C (15) * X ^ 5 + C (15) * X ^ 6 + C (-4) * X ^ 7 + C (20) * X ^ 8 + C (8) * X ^ 9 := by
  rfl

public theorem Fplus_dV_im_101_def : Fplus_dV_im_101 = C (10) + C (20) * X + C (-2) * X ^ 2 + C (18) * X ^ 3 + C (14) * X ^ 4 + C (-3) * X ^ 5 + C (23) * X ^ 6 + C (6) * X ^ 7 + C (2) * X ^ 8 + C (22) * X ^ 9 := by
  rfl

public theorem Fplus_dV_c_101_def : Fplus_dV_c_101 = ofLadj Fplus_dV_re_101 Fplus_dV_im_101 := by
  rfl

public theorem Fplus_dV_re_110_def : Fplus_dV_re_110 = C (17) + C (10) * X ^ 2 + C (16) * X ^ 3 + C (-1) * X ^ 4 + C (12) * X ^ 5 + C (12) * X ^ 6 + C (-1) * X ^ 7 + C (16) * X ^ 8 + C (10) * X ^ 9 := by
  rfl

public theorem Fplus_dV_im_110_def : Fplus_dV_im_110 = C (5) + C (10) * X + C (-6) * X ^ 2 + C (10) * X ^ 3 + C (7) * X ^ 4 + C (-2) * X ^ 5 + C (12) * X ^ 6 + C (3) * X ^ 7 + C (16) * X ^ 9 := by
  rfl

public theorem Fplus_dV_c_110_def : Fplus_dV_c_110 = ofLadj Fplus_dV_re_110 Fplus_dV_im_110 := by
  rfl

public theorem Fplus_dV_re_200_def : Fplus_dV_re_200 = C ((7 / 2 : ℚ)) + C ((3 / 2 : ℚ)) * X ^ 2 + C ((7 / 2 : ℚ)) * X ^ 3 + C (-1) * X ^ 4 + C ((3 / 2 : ℚ)) * X ^ 5 + C ((3 / 2 : ℚ)) * X ^ 6 + C (-1) * X ^ 7 + C ((7 / 2 : ℚ)) * X ^ 8 + C ((3 / 2 : ℚ)) * X ^ 9 := by
  rfl

public theorem Fplus_dV_im_200_def : Fplus_dV_im_200 = C (1) + C (2) * X + C (-1) * X ^ 2 + C ((3 / 2 : ℚ)) * X ^ 3 + C ((5 / 2 : ℚ)) * X ^ 4 + C (-1) * X ^ 5 + C (3) * X ^ 6 + C ((-1 / 2 : ℚ)) * X ^ 7 + C ((1 / 2 : ℚ)) * X ^ 8 + C (3) * X ^ 9 := by
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

public theorem Fplus_dW_re_002_def : Fplus_dW_re_002 = C (3) := by
  rfl

public theorem Fplus_dW_im_002_def : Fplus_dW_im_002 = (0 : Polynomial ℚ) := by
  rfl

public theorem Fplus_dW_c_002_def : Fplus_dW_c_002 = ofLadj Fplus_dW_re_002 Fplus_dW_im_002 := by
  rfl

public theorem Fplus_dW_re_011_def : Fplus_dW_re_011 = C (8) + C (2) * X ^ 2 + C (6) * X ^ 3 + C (2) * X ^ 5 + C (2) * X ^ 6 + C (6) * X ^ 8 + C (2) * X ^ 9 := by
  rfl

public theorem Fplus_dW_im_011_def : Fplus_dW_im_011 = C (2) + C (4) * X + C (-2) * X ^ 2 + C (4) * X ^ 3 + C (4) * X ^ 4 + C (4) * X ^ 6 + C (6) * X ^ 9 := by
  rfl

public theorem Fplus_dW_c_011_def : Fplus_dW_c_011 = ofLadj Fplus_dW_re_011 Fplus_dW_im_011 := by
  rfl

public theorem Fplus_dW_re_020_def : Fplus_dW_re_020 = C (-34) + C (-11) * X ^ 2 + C (-29) * X ^ 3 + C (7) * X ^ 4 + C (-20) * X ^ 5 + C (-20) * X ^ 6 + C (7) * X ^ 7 + C (-29) * X ^ 8 + C (-11) * X ^ 9 := by
  rfl

public theorem Fplus_dW_im_020_def : Fplus_dW_im_020 = C (-14) + C (-28) * X + C (6) * X ^ 2 + C (-26) * X ^ 3 + C (-18) * X ^ 4 + C (4) * X ^ 5 + C (-32) * X ^ 6 + C (-10) * X ^ 7 + C (-2) * X ^ 8 + C (-34) * X ^ 9 := by
  rfl

public theorem Fplus_dW_c_020_def : Fplus_dW_c_020 = ofLadj Fplus_dW_re_020 Fplus_dW_im_020 := by
  rfl

public theorem Fplus_dW_re_101_def : Fplus_dW_re_101 = C (36) + C (14) * X ^ 2 + C (33) * X ^ 3 + C (-5) * X ^ 4 + C (24) * X ^ 5 + C (24) * X ^ 6 + C (-5) * X ^ 7 + C (33) * X ^ 8 + C (14) * X ^ 9 := by
  rfl

public theorem Fplus_dW_im_101_def : Fplus_dW_im_101 = C (14) + C (28) * X + C (-6) * X ^ 2 + C (23) * X ^ 3 + C (21) * X ^ 4 + C (-6) * X ^ 5 + C (34) * X ^ 6 + C (7) * X ^ 7 + C (5) * X ^ 8 + C (34) * X ^ 9 := by
  rfl

public theorem Fplus_dW_c_101_def : Fplus_dW_c_101 = ofLadj Fplus_dW_re_101 Fplus_dW_im_101 := by
  rfl

public theorem Fplus_dW_re_110_def : Fplus_dW_re_110 = C (24) + C (8) * X ^ 2 + C (20) * X ^ 3 + C (-4) * X ^ 4 + C (15) * X ^ 5 + C (15) * X ^ 6 + C (-4) * X ^ 7 + C (20) * X ^ 8 + C (8) * X ^ 9 := by
  rfl

public theorem Fplus_dW_im_110_def : Fplus_dW_im_110 = C (10) + C (20) * X + C (-2) * X ^ 2 + C (18) * X ^ 3 + C (14) * X ^ 4 + C (-3) * X ^ 5 + C (23) * X ^ 6 + C (6) * X ^ 7 + C (2) * X ^ 8 + C (22) * X ^ 9 := by
  rfl

public theorem Fplus_dW_c_110_def : Fplus_dW_c_110 = ofLadj Fplus_dW_re_110 Fplus_dW_im_110 := by
  rfl

public theorem Fplus_dW_re_200_def : Fplus_dW_re_200 = C (-6) + C (-1) * X ^ 2 + C (-6) * X ^ 3 + C (2) * X ^ 4 + C (-4) * X ^ 5 + C (-4) * X ^ 6 + C (2) * X ^ 7 + C (-6) * X ^ 8 + C (-1) * X ^ 9 := by
  rfl

public theorem Fplus_dW_im_200_def : Fplus_dW_im_200 = C (-4) + C (-8) * X + C (1) * X ^ 2 + C ((-15 / 2 : ℚ)) * X ^ 3 + C (-5) * X ^ 4 + C ((1 / 2 : ℚ)) * X ^ 5 + C ((-17 / 2 : ℚ)) * X ^ 6 + C (-3) * X ^ 7 + C ((-1 / 2 : ℚ)) * X ^ 8 + C (-9) * X ^ 9 := by
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
