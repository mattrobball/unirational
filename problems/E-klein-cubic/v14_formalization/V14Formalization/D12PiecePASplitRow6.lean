/- PA split identity row 6: entry certificates inlined. Auto-generated. -/
module

public import V14Formalization.D12PiecePAData
public import V14Formalization.D12CyclotomicVecZ
public import V14Formalization.D12VecScaleIntro

noncomputable section
open Matrix

namespace V14Formalization.D12PiecePASplitEntry6_0
open D12CyclotomicVec D12CyclotomicVecZ D12PiecePAData
def payloadSha256 : String := "76c6196f29afe1a8398af99502447f48ebeed4bcb3805fc5dbec693940bc04b0"

def scale : ℤ := 44

def XZ (k : Fin 20) : VecZ :=
  match k.val with
  | 0 => #v[-5, -47, -14, -20, -48, -22, -43, -18, -23, -46]
  | 1 => #v[13, 31, -8, 20, 26, 9, 28, 26, 6, 36]
  | 2 => #v[-9, -29, -20, -16, -17, -16, -8, -4, -7, -17]
  | 3 => #v[6, -12, 14, 12, -2, 8, -16, -4, -6, -22]
  | 4 => #v[-1, -26, -12, 15, -4, -19, -5, 14, -14, -25]
  | 5 => #v[8, 12, -14, 14, 2, -18, 6, 14, -6, 26]
  | 6 => #v[-32, -54, -12, -32, -36, -16, -38, -16, 0, -50]
  | 7 => #v[-10, -4, 0, -34, -10, 38, -8, -2, 32, 20]
  | 8 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  | 9 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  | 10 => #v[11, 0, -11, 0, -11, -22, -22, -11, 0, -11]
  | 11 => #v[11, 0, -11, 0, 11, 0, 0, 11, 0, -11]
  | 12 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  | 13 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  | 14 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  | 15 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  | 16 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  | 17 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  | 18 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  | 19 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  | _ => zeroZ

def AZ (k : Fin 20) : VecZ :=
  match k.val with
  | 0 => #v[-48, -4, 0, 0, -4, 4, 8, 4, -4, 0]
  | 1 => #v[-4, 0, 4, -4, 8, -4, 4, 0, -4, 0]
  | 2 => #v[4, -4, -4, -4, -4, 4, 0, 0, 8, 0]
  | 3 => #v[8, 4, 4, 8, 0, 0, 4, 12, 4, 0]
  | 4 => #v[-4, 8, -4, 0, -4, 0, 4, 4, 0, -4]
  | 5 => #v[0, 0, 6, 0, 0, -6, -6, 0, 0, 6]
  | 6 => #v[0, 6, -6, 0, 0, 0, 0, -6, 6, 0]
  | 7 => #v[0, 0, 6, -6, -6, 6, 0, 0, 0, 0]
  | 8 => #v[0, -6, 0, -6, 0, 0, 6, 0, 0, 6]
  | 9 => #v[0, 0, 6, 0, -6, 0, -6, 0, 6, 0]
  | 10 => #v[56, 0, 8, 4, 0, 4, 4, 0, 4, 8]
  | 11 => #v[-4, -4, 0, -8, -8, -4, 4, -4, -8, -8]
  | 12 => #v[0, -4, -8, -4, -8, 4, -8, -4, -8, -4]
  | 13 => #v[4, -4, -4, -4, -4, 4, 0, 0, 8, 0]
  | 14 => #v[4, 4, 0, 8, 12, 8, 0, 4, 4, 0]
  | 15 => #v[6, 0, 0, 6, 0, 0, -6, 0, -6, 0]
  | 16 => #v[0, 0, 0, 6, -6, -6, 6, 0, 0, 0]
  | 17 => #v[-6, -12, -6, -12, -6, 0, -6, -6, -6, -6]
  | 18 => #v[6, 6, 6, 0, 12, 6, 6, 6, 6, 12]
  | 19 => #v[0, -6, 0, 0, 0, -6, 0, 0, 6, 6]
  | _ => zeroZ

def entryZ : VecZ := sumFin (fun k => mulZ (XZ k) (AZ k))

theorem entryZ_eq : entryZ = zeroZ :=
  eq_of_eqZ (by decide +kernel)

theorem scale_ne_zero : scale ≠ 0 := by
  decide

theorem XZ_scale_0 : toVec (XZ 0) = (scale : ℚ) • XCell6_0 :=
  toVec_eq_smul10 (XZ 0) scale XCell6_0
    (eq_smul_div (-5) scale (-5) (44) (by decide) (by decide))
    (eq_smul_div (-47) scale (-47) (44) (by decide) (by decide))
    (eq_smul_div (-14) scale (-7) (22) (by decide) (by decide))
    (eq_smul_div (-20) scale (-5) (11) (by decide) (by decide))
    (eq_smul_div (-48) scale (-12) (11) (by decide) (by decide))
    (eq_smul_div (-22) scale (-1) (2) (by decide) (by decide))
    (eq_smul_div (-43) scale (-43) (44) (by decide) (by decide))
    (eq_smul_div (-18) scale (-9) (22) (by decide) (by decide))
    (eq_smul_div (-23) scale (-23) (44) (by decide) (by decide))
    (eq_smul_div (-46) scale (-23) (22) (by decide) (by decide))

theorem XZ_scale_1 : toVec (XZ 1) = (scale : ℚ) • XCell6_1 :=
  toVec_eq_smul10 (XZ 1) scale XCell6_1
    (eq_smul_div (13) scale (13) (44) (by decide) (by decide))
    (eq_smul_div (31) scale (31) (44) (by decide) (by decide))
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (20) scale (5) (11) (by decide) (by decide))
    (eq_smul_div (26) scale (13) (22) (by decide) (by decide))
    (eq_smul_div (9) scale (9) (44) (by decide) (by decide))
    (eq_smul_div (28) scale (7) (11) (by decide) (by decide))
    (eq_smul_div (26) scale (13) (22) (by decide) (by decide))
    (eq_smul_div (6) scale (3) (22) (by decide) (by decide))
    (eq_smul_div (36) scale (9) (11) (by decide) (by decide))

theorem XZ_scale_2 : toVec (XZ 2) = (scale : ℚ) • XCell6_2 :=
  toVec_eq_smul10 (XZ 2) scale XCell6_2
    (eq_smul_div (-9) scale (-9) (44) (by decide) (by decide))
    (eq_smul_div (-29) scale (-29) (44) (by decide) (by decide))
    (eq_smul_div (-20) scale (-5) (11) (by decide) (by decide))
    (eq_smul_div (-16) scale (-4) (11) (by decide) (by decide))
    (eq_smul_div (-17) scale (-17) (44) (by decide) (by decide))
    (eq_smul_div (-16) scale (-4) (11) (by decide) (by decide))
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-7) scale (-7) (44) (by decide) (by decide))
    (eq_smul_div (-17) scale (-17) (44) (by decide) (by decide))

theorem XZ_scale_3 : toVec (XZ 3) = (scale : ℚ) • XCell6_3 :=
  toVec_eq_smul10 (XZ 3) scale XCell6_3
    (eq_smul_div (6) scale (3) (22) (by decide) (by decide))
    (eq_smul_div (-12) scale (-3) (11) (by decide) (by decide))
    (eq_smul_div (14) scale (7) (22) (by decide) (by decide))
    (eq_smul_div (12) scale (3) (11) (by decide) (by decide))
    (eq_smul_div (-2) scale (-1) (22) (by decide) (by decide))
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (-16) scale (-4) (11) (by decide) (by decide))
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-6) scale (-3) (22) (by decide) (by decide))
    (eq_smul_div (-22) scale (-1) (2) (by decide) (by decide))

theorem XZ_scale_4 : toVec (XZ 4) = (scale : ℚ) • XCell6_4 :=
  toVec_eq_smul10 (XZ 4) scale XCell6_4
    (eq_smul_div (-1) scale (-1) (44) (by decide) (by decide))
    (eq_smul_div (-26) scale (-13) (22) (by decide) (by decide))
    (eq_smul_div (-12) scale (-3) (11) (by decide) (by decide))
    (eq_smul_div (15) scale (15) (44) (by decide) (by decide))
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-19) scale (-19) (44) (by decide) (by decide))
    (eq_smul_div (-5) scale (-5) (44) (by decide) (by decide))
    (eq_smul_div (14) scale (7) (22) (by decide) (by decide))
    (eq_smul_div (-14) scale (-7) (22) (by decide) (by decide))
    (eq_smul_div (-25) scale (-25) (44) (by decide) (by decide))

theorem XZ_scale_5 : toVec (XZ 5) = (scale : ℚ) • XCell6_5 :=
  toVec_eq_smul10 (XZ 5) scale XCell6_5
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (12) scale (3) (11) (by decide) (by decide))
    (eq_smul_div (-14) scale (-7) (22) (by decide) (by decide))
    (eq_smul_div (14) scale (7) (22) (by decide) (by decide))
    (eq_smul_div (2) scale (1) (22) (by decide) (by decide))
    (eq_smul_div (-18) scale (-9) (22) (by decide) (by decide))
    (eq_smul_div (6) scale (3) (22) (by decide) (by decide))
    (eq_smul_div (14) scale (7) (22) (by decide) (by decide))
    (eq_smul_div (-6) scale (-3) (22) (by decide) (by decide))
    (eq_smul_div (26) scale (13) (22) (by decide) (by decide))

theorem XZ_scale_6 : toVec (XZ 6) = (scale : ℚ) • XCell6_6 :=
  toVec_eq_smul10 (XZ 6) scale XCell6_6
    (eq_smul_div (-32) scale (-8) (11) (by decide) (by decide))
    (eq_smul_div (-54) scale (-27) (22) (by decide) (by decide))
    (eq_smul_div (-12) scale (-3) (11) (by decide) (by decide))
    (eq_smul_div (-32) scale (-8) (11) (by decide) (by decide))
    (eq_smul_div (-36) scale (-9) (11) (by decide) (by decide))
    (eq_smul_div (-16) scale (-4) (11) (by decide) (by decide))
    (eq_smul_div (-38) scale (-19) (22) (by decide) (by decide))
    (eq_smul_div (-16) scale (-4) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-50) scale (-25) (22) (by decide) (by decide))

theorem XZ_scale_7 : toVec (XZ 7) = (scale : ℚ) • XCell6_7 :=
  toVec_eq_smul10 (XZ 7) scale XCell6_7
    (eq_smul_div (-10) scale (-5) (22) (by decide) (by decide))
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-34) scale (-17) (22) (by decide) (by decide))
    (eq_smul_div (-10) scale (-5) (22) (by decide) (by decide))
    (eq_smul_div (38) scale (19) (22) (by decide) (by decide))
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-2) scale (-1) (22) (by decide) (by decide))
    (eq_smul_div (32) scale (8) (11) (by decide) (by decide))
    (eq_smul_div (20) scale (5) (11) (by decide) (by decide))

theorem XZ_scale_8 : toVec (XZ 8) = (scale : ℚ) • XCell6_8 :=
  toVec_eq_smul10 (XZ 8) scale XCell6_8
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)

theorem XZ_scale_9 : toVec (XZ 9) = (scale : ℚ) • XCell6_9 :=
  toVec_eq_smul10 (XZ 9) scale XCell6_9
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)

theorem XZ_scale_10 : toVec (XZ 10) = (scale : ℚ) • XCell6_10 :=
  toVec_eq_smul10 (XZ 10) scale XCell6_10
    (eq_smul_div (11) scale (1) (4) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-11) scale (-1) (4) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-11) scale (-1) (4) (by decide) (by decide))
    (eq_smul_div (-22) scale (-1) (2) (by decide) (by decide))
    (eq_smul_div (-22) scale (-1) (2) (by decide) (by decide))
    (eq_smul_div (-11) scale (-1) (4) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-11) scale (-1) (4) (by decide) (by decide))

theorem XZ_scale_11 : toVec (XZ 11) = (scale : ℚ) • XCell6_11 :=
  toVec_eq_smul10 (XZ 11) scale XCell6_11
    (eq_smul_div (11) scale (1) (4) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-11) scale (-1) (4) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (11) scale (1) (4) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (11) scale (1) (4) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-11) scale (-1) (4) (by decide) (by decide))

theorem XZ_scale_12 : toVec (XZ 12) = (scale : ℚ) • XCell6_12 :=
  toVec_eq_smul10 (XZ 12) scale XCell6_12
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)

theorem XZ_scale_13 : toVec (XZ 13) = (scale : ℚ) • XCell6_13 :=
  toVec_eq_smul10 (XZ 13) scale XCell6_13
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)

theorem XZ_scale_14 : toVec (XZ 14) = (scale : ℚ) • XCell6_14 :=
  toVec_eq_smul10 (XZ 14) scale XCell6_14
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)

theorem XZ_scale_15 : toVec (XZ 15) = (scale : ℚ) • XCell6_15 :=
  toVec_eq_smul10 (XZ 15) scale XCell6_15
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)

theorem XZ_scale_16 : toVec (XZ 16) = (scale : ℚ) • XCell6_16 :=
  toVec_eq_smul10 (XZ 16) scale XCell6_16
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)

theorem XZ_scale_17 : toVec (XZ 17) = (scale : ℚ) • XCell6_17 :=
  toVec_eq_smul10 (XZ 17) scale XCell6_17
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)

theorem XZ_scale_18 : toVec (XZ 18) = (scale : ℚ) • XCell6_18 :=
  toVec_eq_smul10 (XZ 18) scale XCell6_18
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)

theorem XZ_scale_19 : toVec (XZ 19) = (scale : ℚ) • XCell6_19 :=
  toVec_eq_smul10 (XZ 19) scale XCell6_19
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)

theorem XZ_scale (k : Fin 20) :
    toVec (XZ k) = (scale : ℚ) • XVec (6 : Fin 10) k :=
  forall_fin20 (P := fun k => toVec (XZ k) = (scale : ℚ) • XVec (6 : Fin 10) k)
    XZ_scale_0 XZ_scale_1 XZ_scale_2 XZ_scale_3 XZ_scale_4 XZ_scale_5 XZ_scale_6 XZ_scale_7 XZ_scale_8 XZ_scale_9 XZ_scale_10 XZ_scale_11 XZ_scale_12 XZ_scale_13 XZ_scale_14 XZ_scale_15 XZ_scale_16 XZ_scale_17 XZ_scale_18 XZ_scale_19 k

theorem AZ_scale_0 : toVec (AZ 0) = (scale : ℚ) • ACell0_0 :=
  toVec_eq_smul10 (AZ 0) scale ACell0_0
    (eq_smul_div (-48) scale (-12) (11) (by decide) (by decide))
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (4) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (4) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_zero scale)

theorem AZ_scale_1 : toVec (AZ 1) = (scale : ℚ) • ACell1_0 :=
  toVec_eq_smul10 (AZ 1) scale ACell1_0
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (4) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (4) scale (1) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_zero scale)

theorem AZ_scale_2 : toVec (AZ 2) = (scale : ℚ) • ACell2_0 :=
  toVec_eq_smul10 (AZ 2) scale ACell2_0
    (eq_smul_div (4) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (4) scale (1) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_zero scale)

theorem AZ_scale_3 : toVec (AZ 3) = (scale : ℚ) • ACell3_0 :=
  toVec_eq_smul10 (AZ 3) scale ACell3_0
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (4) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (4) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (4) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (12) scale (3) (11) (by decide) (by decide))
    (eq_smul_div (4) scale (1) (11) (by decide) (by decide))
    (eq_smul_zero scale)

theorem AZ_scale_4 : toVec (AZ 4) = (scale : ℚ) • ACell4_0 :=
  toVec_eq_smul10 (AZ 4) scale ACell4_0
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (4) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (4) scale (1) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))

theorem AZ_scale_5 : toVec (AZ 5) = (scale : ℚ) • ACell5_0 :=
  toVec_eq_smul10 (AZ 5) scale ACell5_0
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (6) scale (3) (22) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (-6) scale (-3) (22) (by decide) (by decide))
    (eq_smul_div (-6) scale (-3) (22) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (6) scale (3) (22) (by decide) (by decide))

theorem AZ_scale_6 : toVec (AZ 6) = (scale : ℚ) • ACell6_0 :=
  toVec_eq_smul10 (AZ 6) scale ACell6_0
    (eq_smul_zero scale)
    (eq_smul_div (6) scale (3) (22) (by decide) (by decide))
    (eq_smul_div (-6) scale (-3) (22) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (-6) scale (-3) (22) (by decide) (by decide))
    (eq_smul_div (6) scale (3) (22) (by decide) (by decide))
    (eq_smul_zero scale)

theorem AZ_scale_7 : toVec (AZ 7) = (scale : ℚ) • ACell7_0 :=
  toVec_eq_smul10 (AZ 7) scale ACell7_0
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (6) scale (3) (22) (by decide) (by decide))
    (eq_smul_div (-6) scale (-3) (22) (by decide) (by decide))
    (eq_smul_div (-6) scale (-3) (22) (by decide) (by decide))
    (eq_smul_div (6) scale (3) (22) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)

theorem AZ_scale_8 : toVec (AZ 8) = (scale : ℚ) • ACell8_0 :=
  toVec_eq_smul10 (AZ 8) scale ACell8_0
    (eq_smul_zero scale)
    (eq_smul_div (-6) scale (-3) (22) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-6) scale (-3) (22) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (6) scale (3) (22) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (6) scale (3) (22) (by decide) (by decide))

theorem AZ_scale_9 : toVec (AZ 9) = (scale : ℚ) • ACell9_0 :=
  toVec_eq_smul10 (AZ 9) scale ACell9_0
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (6) scale (3) (22) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-6) scale (-3) (22) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-6) scale (-3) (22) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (6) scale (3) (22) (by decide) (by decide))
    (eq_smul_zero scale)

theorem AZ_scale_10 : toVec (AZ 10) = (scale : ℚ) • ACell10_0 :=
  toVec_eq_smul10 (AZ 10) scale ACell10_0
    (eq_smul_div (56) scale (14) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (4) scale (1) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (4) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (4) scale (1) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (4) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))

theorem AZ_scale_11 : toVec (AZ 11) = (scale : ℚ) • ACell11_0 :=
  toVec_eq_smul10 (AZ 11) scale ACell11_0
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (4) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))

theorem AZ_scale_12 : toVec (AZ 12) = (scale : ℚ) • ACell12_0 :=
  toVec_eq_smul10 (AZ 12) scale ACell12_0
    (eq_smul_zero scale)
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (4) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))

theorem AZ_scale_13 : toVec (AZ 13) = (scale : ℚ) • ACell13_0 :=
  toVec_eq_smul10 (AZ 13) scale ACell13_0
    (eq_smul_div (4) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (4) scale (1) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_zero scale)

theorem AZ_scale_14 : toVec (AZ 14) = (scale : ℚ) • ACell14_0 :=
  toVec_eq_smul10 (AZ 14) scale ACell14_0
    (eq_smul_div (4) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (4) scale (1) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (12) scale (3) (11) (by decide) (by decide))
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (4) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (4) scale (1) (11) (by decide) (by decide))
    (eq_smul_zero scale)

theorem AZ_scale_15 : toVec (AZ 15) = (scale : ℚ) • ACell15_0 :=
  toVec_eq_smul10 (AZ 15) scale ACell15_0
    (eq_smul_div (6) scale (3) (22) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (6) scale (3) (22) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (-6) scale (-3) (22) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-6) scale (-3) (22) (by decide) (by decide))
    (eq_smul_zero scale)

theorem AZ_scale_16 : toVec (AZ 16) = (scale : ℚ) • ACell16_0 :=
  toVec_eq_smul10 (AZ 16) scale ACell16_0
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (6) scale (3) (22) (by decide) (by decide))
    (eq_smul_div (-6) scale (-3) (22) (by decide) (by decide))
    (eq_smul_div (-6) scale (-3) (22) (by decide) (by decide))
    (eq_smul_div (6) scale (3) (22) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)

theorem AZ_scale_17 : toVec (AZ 17) = (scale : ℚ) • ACell17_0 :=
  toVec_eq_smul10 (AZ 17) scale ACell17_0
    (eq_smul_div (-6) scale (-3) (22) (by decide) (by decide))
    (eq_smul_div (-12) scale (-3) (11) (by decide) (by decide))
    (eq_smul_div (-6) scale (-3) (22) (by decide) (by decide))
    (eq_smul_div (-12) scale (-3) (11) (by decide) (by decide))
    (eq_smul_div (-6) scale (-3) (22) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-6) scale (-3) (22) (by decide) (by decide))
    (eq_smul_div (-6) scale (-3) (22) (by decide) (by decide))
    (eq_smul_div (-6) scale (-3) (22) (by decide) (by decide))
    (eq_smul_div (-6) scale (-3) (22) (by decide) (by decide))

theorem AZ_scale_18 : toVec (AZ 18) = (scale : ℚ) • ACell18_0 :=
  toVec_eq_smul10 (AZ 18) scale ACell18_0
    (eq_smul_div (6) scale (3) (22) (by decide) (by decide))
    (eq_smul_div (6) scale (3) (22) (by decide) (by decide))
    (eq_smul_div (6) scale (3) (22) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (12) scale (3) (11) (by decide) (by decide))
    (eq_smul_div (6) scale (3) (22) (by decide) (by decide))
    (eq_smul_div (6) scale (3) (22) (by decide) (by decide))
    (eq_smul_div (6) scale (3) (22) (by decide) (by decide))
    (eq_smul_div (6) scale (3) (22) (by decide) (by decide))
    (eq_smul_div (12) scale (3) (11) (by decide) (by decide))

theorem AZ_scale_19 : toVec (AZ 19) = (scale : ℚ) • ACell19_0 :=
  toVec_eq_smul10 (AZ 19) scale ACell19_0
    (eq_smul_zero scale)
    (eq_smul_div (-6) scale (-3) (22) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (-6) scale (-3) (22) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (6) scale (3) (22) (by decide) (by decide))
    (eq_smul_div (6) scale (3) (22) (by decide) (by decide))

theorem AZ_scale (k : Fin 20) :
    toVec (AZ k) = (scale : ℚ) • AVec k (0 : Fin 10) :=
  forall_fin20 (P := fun k => toVec (AZ k) = (scale : ℚ) • AVec k (0 : Fin 10))
    AZ_scale_0 AZ_scale_1 AZ_scale_2 AZ_scale_3 AZ_scale_4 AZ_scale_5 AZ_scale_6 AZ_scale_7 AZ_scale_8 AZ_scale_9 AZ_scale_10 AZ_scale_11 AZ_scale_12 AZ_scale_13 AZ_scale_14 AZ_scale_15 AZ_scale_16 AZ_scale_17 AZ_scale_18 AZ_scale_19 k

theorem entry_eq :
    (matrixMul XVec AVec) (6 : Fin 10) (0 : Fin 10) =
      ![0, 0, 0, 0, 0, 0, 0, 0, 0, 0] := by
  unfold matrixMul
  refine sum_mul_eq_of_scaled scale scale_ne_zero
    (fun k => XVec (6 : Fin 10) k)
    (fun k => AVec k (0 : Fin 10))
    XZ AZ XZ_scale AZ_scale entryZ rfl _ ?_
  rw [entryZ_eq, toVec_zeroZ_smul, vec_zero_eq]

theorem entry_eq_matrixOne :
    (matrixMul XVec AVec) (6 : Fin 10) (0 : Fin 10) =
      matrixOne (Fin 10) (6 : Fin 10) (0 : Fin 10) :=
  entry_eq.trans (matrixOne_off10 (6 : Fin 10) (0 : Fin 10) (by decide)).symm

end V14Formalization.D12PiecePASplitEntry6_0


namespace V14Formalization.D12PiecePASplitEntry6_1
open D12CyclotomicVec D12CyclotomicVecZ D12PiecePAData
def payloadSha256 : String := "76c6196f29afe1a8398af99502447f48ebeed4bcb3805fc5dbec693940bc04b0"

def scale : ℤ := 44

def XZ (k : Fin 20) : VecZ :=
  match k.val with
  | 0 => #v[-5, -47, -14, -20, -48, -22, -43, -18, -23, -46]
  | 1 => #v[13, 31, -8, 20, 26, 9, 28, 26, 6, 36]
  | 2 => #v[-9, -29, -20, -16, -17, -16, -8, -4, -7, -17]
  | 3 => #v[6, -12, 14, 12, -2, 8, -16, -4, -6, -22]
  | 4 => #v[-1, -26, -12, 15, -4, -19, -5, 14, -14, -25]
  | 5 => #v[8, 12, -14, 14, 2, -18, 6, 14, -6, 26]
  | 6 => #v[-32, -54, -12, -32, -36, -16, -38, -16, 0, -50]
  | 7 => #v[-10, -4, 0, -34, -10, 38, -8, -2, 32, 20]
  | 8 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  | 9 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  | 10 => #v[11, 0, -11, 0, -11, -22, -22, -11, 0, -11]
  | 11 => #v[11, 0, -11, 0, 11, 0, 0, 11, 0, -11]
  | 12 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  | 13 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  | 14 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  | 15 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  | 16 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  | 17 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  | 18 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  | 19 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  | _ => zeroZ

def AZ (k : Fin 20) : VecZ :=
  match k.val with
  | 0 => #v[-4, 0, 4, -4, 8, -4, 4, 0, -4, 0]
  | 1 => #v[-44, 4, 12, 4, 0, 0, 8, 4, 4, 8]
  | 2 => #v[4, 4, 0, -4, 0, -4, 8, -4, 0, -4]
  | 3 => #v[0, 0, 8, 4, 4, 12, 4, 4, 8, 0]
  | 4 => #v[-4, -12, -8, -8, -12, -12, -8, -8, -12, -4]
  | 5 => #v[6, 6, 12, 6, 6, 12, 6, 6, 0, 6]
  | 6 => #v[0, 6, -6, -6, 6, 0, 0, 0, 0, 0]
  | 7 => #v[-6, -6, -6, -6, 0, -6, -12, -6, -12, -6]
  | 8 => #v[0, 0, -6, 6, 0, 0, 0, 0, 6, -6]
  | 9 => #v[0, -6, 0, 0, 0, -6, 0, 0, 6, 6]
  | 10 => #v[0, 4, -4, -4, 0, 8, 0, -4, -4, 4]
  | 11 => #v[52, 0, 0, 4, -4, -4, -4, -4, 4, 0]
  | 12 => #v[-4, -12, -8, -8, -12, -12, -8, -8, -12, -4]
  | 13 => #v[4, 0, 12, 0, 4, 0, 4, 8, 8, 4]
  | 14 => #v[8, 4, 0, 4, 4, 0, 4, 8, 0, 12]
  | 15 => #v[6, 6, 6, 0, 12, 6, 6, 6, 6, 12]
  | 16 => #v[0, 6, 0, -6, 0, -6, 0, 6, 0, 0]
  | 17 => #v[0, 6, 6, 0, 0, -6, 0, 0, 0, -6]
  | 18 => #v[12, 12, 0, 6, 6, 6, 6, 6, 6, 6]
  | 19 => #v[0, -6, 0, 0, -6, 0, 0, 6, 0, 6]
  | _ => zeroZ

def entryZ : VecZ := sumFin (fun k => mulZ (XZ k) (AZ k))

theorem entryZ_eq : entryZ = zeroZ :=
  eq_of_eqZ (by decide +kernel)

theorem scale_ne_zero : scale ≠ 0 := by
  decide

theorem XZ_scale_0 : toVec (XZ 0) = (scale : ℚ) • XCell6_0 :=
  toVec_eq_smul10 (XZ 0) scale XCell6_0
    (eq_smul_div (-5) scale (-5) (44) (by decide) (by decide))
    (eq_smul_div (-47) scale (-47) (44) (by decide) (by decide))
    (eq_smul_div (-14) scale (-7) (22) (by decide) (by decide))
    (eq_smul_div (-20) scale (-5) (11) (by decide) (by decide))
    (eq_smul_div (-48) scale (-12) (11) (by decide) (by decide))
    (eq_smul_div (-22) scale (-1) (2) (by decide) (by decide))
    (eq_smul_div (-43) scale (-43) (44) (by decide) (by decide))
    (eq_smul_div (-18) scale (-9) (22) (by decide) (by decide))
    (eq_smul_div (-23) scale (-23) (44) (by decide) (by decide))
    (eq_smul_div (-46) scale (-23) (22) (by decide) (by decide))

theorem XZ_scale_1 : toVec (XZ 1) = (scale : ℚ) • XCell6_1 :=
  toVec_eq_smul10 (XZ 1) scale XCell6_1
    (eq_smul_div (13) scale (13) (44) (by decide) (by decide))
    (eq_smul_div (31) scale (31) (44) (by decide) (by decide))
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (20) scale (5) (11) (by decide) (by decide))
    (eq_smul_div (26) scale (13) (22) (by decide) (by decide))
    (eq_smul_div (9) scale (9) (44) (by decide) (by decide))
    (eq_smul_div (28) scale (7) (11) (by decide) (by decide))
    (eq_smul_div (26) scale (13) (22) (by decide) (by decide))
    (eq_smul_div (6) scale (3) (22) (by decide) (by decide))
    (eq_smul_div (36) scale (9) (11) (by decide) (by decide))

theorem XZ_scale_2 : toVec (XZ 2) = (scale : ℚ) • XCell6_2 :=
  toVec_eq_smul10 (XZ 2) scale XCell6_2
    (eq_smul_div (-9) scale (-9) (44) (by decide) (by decide))
    (eq_smul_div (-29) scale (-29) (44) (by decide) (by decide))
    (eq_smul_div (-20) scale (-5) (11) (by decide) (by decide))
    (eq_smul_div (-16) scale (-4) (11) (by decide) (by decide))
    (eq_smul_div (-17) scale (-17) (44) (by decide) (by decide))
    (eq_smul_div (-16) scale (-4) (11) (by decide) (by decide))
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-7) scale (-7) (44) (by decide) (by decide))
    (eq_smul_div (-17) scale (-17) (44) (by decide) (by decide))

theorem XZ_scale_3 : toVec (XZ 3) = (scale : ℚ) • XCell6_3 :=
  toVec_eq_smul10 (XZ 3) scale XCell6_3
    (eq_smul_div (6) scale (3) (22) (by decide) (by decide))
    (eq_smul_div (-12) scale (-3) (11) (by decide) (by decide))
    (eq_smul_div (14) scale (7) (22) (by decide) (by decide))
    (eq_smul_div (12) scale (3) (11) (by decide) (by decide))
    (eq_smul_div (-2) scale (-1) (22) (by decide) (by decide))
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (-16) scale (-4) (11) (by decide) (by decide))
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-6) scale (-3) (22) (by decide) (by decide))
    (eq_smul_div (-22) scale (-1) (2) (by decide) (by decide))

theorem XZ_scale_4 : toVec (XZ 4) = (scale : ℚ) • XCell6_4 :=
  toVec_eq_smul10 (XZ 4) scale XCell6_4
    (eq_smul_div (-1) scale (-1) (44) (by decide) (by decide))
    (eq_smul_div (-26) scale (-13) (22) (by decide) (by decide))
    (eq_smul_div (-12) scale (-3) (11) (by decide) (by decide))
    (eq_smul_div (15) scale (15) (44) (by decide) (by decide))
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-19) scale (-19) (44) (by decide) (by decide))
    (eq_smul_div (-5) scale (-5) (44) (by decide) (by decide))
    (eq_smul_div (14) scale (7) (22) (by decide) (by decide))
    (eq_smul_div (-14) scale (-7) (22) (by decide) (by decide))
    (eq_smul_div (-25) scale (-25) (44) (by decide) (by decide))

theorem XZ_scale_5 : toVec (XZ 5) = (scale : ℚ) • XCell6_5 :=
  toVec_eq_smul10 (XZ 5) scale XCell6_5
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (12) scale (3) (11) (by decide) (by decide))
    (eq_smul_div (-14) scale (-7) (22) (by decide) (by decide))
    (eq_smul_div (14) scale (7) (22) (by decide) (by decide))
    (eq_smul_div (2) scale (1) (22) (by decide) (by decide))
    (eq_smul_div (-18) scale (-9) (22) (by decide) (by decide))
    (eq_smul_div (6) scale (3) (22) (by decide) (by decide))
    (eq_smul_div (14) scale (7) (22) (by decide) (by decide))
    (eq_smul_div (-6) scale (-3) (22) (by decide) (by decide))
    (eq_smul_div (26) scale (13) (22) (by decide) (by decide))

theorem XZ_scale_6 : toVec (XZ 6) = (scale : ℚ) • XCell6_6 :=
  toVec_eq_smul10 (XZ 6) scale XCell6_6
    (eq_smul_div (-32) scale (-8) (11) (by decide) (by decide))
    (eq_smul_div (-54) scale (-27) (22) (by decide) (by decide))
    (eq_smul_div (-12) scale (-3) (11) (by decide) (by decide))
    (eq_smul_div (-32) scale (-8) (11) (by decide) (by decide))
    (eq_smul_div (-36) scale (-9) (11) (by decide) (by decide))
    (eq_smul_div (-16) scale (-4) (11) (by decide) (by decide))
    (eq_smul_div (-38) scale (-19) (22) (by decide) (by decide))
    (eq_smul_div (-16) scale (-4) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-50) scale (-25) (22) (by decide) (by decide))

theorem XZ_scale_7 : toVec (XZ 7) = (scale : ℚ) • XCell6_7 :=
  toVec_eq_smul10 (XZ 7) scale XCell6_7
    (eq_smul_div (-10) scale (-5) (22) (by decide) (by decide))
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-34) scale (-17) (22) (by decide) (by decide))
    (eq_smul_div (-10) scale (-5) (22) (by decide) (by decide))
    (eq_smul_div (38) scale (19) (22) (by decide) (by decide))
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-2) scale (-1) (22) (by decide) (by decide))
    (eq_smul_div (32) scale (8) (11) (by decide) (by decide))
    (eq_smul_div (20) scale (5) (11) (by decide) (by decide))

theorem XZ_scale_8 : toVec (XZ 8) = (scale : ℚ) • XCell6_8 :=
  toVec_eq_smul10 (XZ 8) scale XCell6_8
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)

theorem XZ_scale_9 : toVec (XZ 9) = (scale : ℚ) • XCell6_9 :=
  toVec_eq_smul10 (XZ 9) scale XCell6_9
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)

theorem XZ_scale_10 : toVec (XZ 10) = (scale : ℚ) • XCell6_10 :=
  toVec_eq_smul10 (XZ 10) scale XCell6_10
    (eq_smul_div (11) scale (1) (4) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-11) scale (-1) (4) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-11) scale (-1) (4) (by decide) (by decide))
    (eq_smul_div (-22) scale (-1) (2) (by decide) (by decide))
    (eq_smul_div (-22) scale (-1) (2) (by decide) (by decide))
    (eq_smul_div (-11) scale (-1) (4) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-11) scale (-1) (4) (by decide) (by decide))

theorem XZ_scale_11 : toVec (XZ 11) = (scale : ℚ) • XCell6_11 :=
  toVec_eq_smul10 (XZ 11) scale XCell6_11
    (eq_smul_div (11) scale (1) (4) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-11) scale (-1) (4) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (11) scale (1) (4) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (11) scale (1) (4) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-11) scale (-1) (4) (by decide) (by decide))

theorem XZ_scale_12 : toVec (XZ 12) = (scale : ℚ) • XCell6_12 :=
  toVec_eq_smul10 (XZ 12) scale XCell6_12
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)

theorem XZ_scale_13 : toVec (XZ 13) = (scale : ℚ) • XCell6_13 :=
  toVec_eq_smul10 (XZ 13) scale XCell6_13
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)

theorem XZ_scale_14 : toVec (XZ 14) = (scale : ℚ) • XCell6_14 :=
  toVec_eq_smul10 (XZ 14) scale XCell6_14
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)

theorem XZ_scale_15 : toVec (XZ 15) = (scale : ℚ) • XCell6_15 :=
  toVec_eq_smul10 (XZ 15) scale XCell6_15
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)

theorem XZ_scale_16 : toVec (XZ 16) = (scale : ℚ) • XCell6_16 :=
  toVec_eq_smul10 (XZ 16) scale XCell6_16
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)

theorem XZ_scale_17 : toVec (XZ 17) = (scale : ℚ) • XCell6_17 :=
  toVec_eq_smul10 (XZ 17) scale XCell6_17
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)

theorem XZ_scale_18 : toVec (XZ 18) = (scale : ℚ) • XCell6_18 :=
  toVec_eq_smul10 (XZ 18) scale XCell6_18
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)

theorem XZ_scale_19 : toVec (XZ 19) = (scale : ℚ) • XCell6_19 :=
  toVec_eq_smul10 (XZ 19) scale XCell6_19
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)

theorem XZ_scale (k : Fin 20) :
    toVec (XZ k) = (scale : ℚ) • XVec (6 : Fin 10) k :=
  forall_fin20 (P := fun k => toVec (XZ k) = (scale : ℚ) • XVec (6 : Fin 10) k)
    XZ_scale_0 XZ_scale_1 XZ_scale_2 XZ_scale_3 XZ_scale_4 XZ_scale_5 XZ_scale_6 XZ_scale_7 XZ_scale_8 XZ_scale_9 XZ_scale_10 XZ_scale_11 XZ_scale_12 XZ_scale_13 XZ_scale_14 XZ_scale_15 XZ_scale_16 XZ_scale_17 XZ_scale_18 XZ_scale_19 k

theorem AZ_scale_0 : toVec (AZ 0) = (scale : ℚ) • ACell0_1 :=
  toVec_eq_smul10 (AZ 0) scale ACell0_1
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (4) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (4) scale (1) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_zero scale)

theorem AZ_scale_1 : toVec (AZ 1) = (scale : ℚ) • ACell1_1 :=
  toVec_eq_smul10 (AZ 1) scale ACell1_1
    (eq_smul_int (-44) scale (-1) (by decide))
    (eq_smul_div (4) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (12) scale (3) (11) (by decide) (by decide))
    (eq_smul_div (4) scale (1) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (4) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (4) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))

theorem AZ_scale_2 : toVec (AZ 2) = (scale : ℚ) • ACell2_1 :=
  toVec_eq_smul10 (AZ 2) scale ACell2_1
    (eq_smul_div (4) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (4) scale (1) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))

theorem AZ_scale_3 : toVec (AZ 3) = (scale : ℚ) • ACell3_1 :=
  toVec_eq_smul10 (AZ 3) scale ACell3_1
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (4) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (4) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (12) scale (3) (11) (by decide) (by decide))
    (eq_smul_div (4) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (4) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_zero scale)

theorem AZ_scale_4 : toVec (AZ 4) = (scale : ℚ) • ACell4_1 :=
  toVec_eq_smul10 (AZ 4) scale ACell4_1
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-12) scale (-3) (11) (by decide) (by decide))
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-12) scale (-3) (11) (by decide) (by decide))
    (eq_smul_div (-12) scale (-3) (11) (by decide) (by decide))
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-12) scale (-3) (11) (by decide) (by decide))
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))

theorem AZ_scale_5 : toVec (AZ 5) = (scale : ℚ) • ACell5_1 :=
  toVec_eq_smul10 (AZ 5) scale ACell5_1
    (eq_smul_div (6) scale (3) (22) (by decide) (by decide))
    (eq_smul_div (6) scale (3) (22) (by decide) (by decide))
    (eq_smul_div (12) scale (3) (11) (by decide) (by decide))
    (eq_smul_div (6) scale (3) (22) (by decide) (by decide))
    (eq_smul_div (6) scale (3) (22) (by decide) (by decide))
    (eq_smul_div (12) scale (3) (11) (by decide) (by decide))
    (eq_smul_div (6) scale (3) (22) (by decide) (by decide))
    (eq_smul_div (6) scale (3) (22) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (6) scale (3) (22) (by decide) (by decide))

theorem AZ_scale_6 : toVec (AZ 6) = (scale : ℚ) • ACell6_1 :=
  toVec_eq_smul10 (AZ 6) scale ACell6_1
    (eq_smul_zero scale)
    (eq_smul_div (6) scale (3) (22) (by decide) (by decide))
    (eq_smul_div (-6) scale (-3) (22) (by decide) (by decide))
    (eq_smul_div (-6) scale (-3) (22) (by decide) (by decide))
    (eq_smul_div (6) scale (3) (22) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)

theorem AZ_scale_7 : toVec (AZ 7) = (scale : ℚ) • ACell7_1 :=
  toVec_eq_smul10 (AZ 7) scale ACell7_1
    (eq_smul_div (-6) scale (-3) (22) (by decide) (by decide))
    (eq_smul_div (-6) scale (-3) (22) (by decide) (by decide))
    (eq_smul_div (-6) scale (-3) (22) (by decide) (by decide))
    (eq_smul_div (-6) scale (-3) (22) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-6) scale (-3) (22) (by decide) (by decide))
    (eq_smul_div (-12) scale (-3) (11) (by decide) (by decide))
    (eq_smul_div (-6) scale (-3) (22) (by decide) (by decide))
    (eq_smul_div (-12) scale (-3) (11) (by decide) (by decide))
    (eq_smul_div (-6) scale (-3) (22) (by decide) (by decide))

theorem AZ_scale_8 : toVec (AZ 8) = (scale : ℚ) • ACell8_1 :=
  toVec_eq_smul10 (AZ 8) scale ACell8_1
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (-6) scale (-3) (22) (by decide) (by decide))
    (eq_smul_div (6) scale (3) (22) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (6) scale (3) (22) (by decide) (by decide))
    (eq_smul_div (-6) scale (-3) (22) (by decide) (by decide))

theorem AZ_scale_9 : toVec (AZ 9) = (scale : ℚ) • ACell9_1 :=
  toVec_eq_smul10 (AZ 9) scale ACell9_1
    (eq_smul_zero scale)
    (eq_smul_div (-6) scale (-3) (22) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (-6) scale (-3) (22) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (6) scale (3) (22) (by decide) (by decide))
    (eq_smul_div (6) scale (3) (22) (by decide) (by decide))

theorem AZ_scale_10 : toVec (AZ 10) = (scale : ℚ) • ACell10_1 :=
  toVec_eq_smul10 (AZ 10) scale ACell10_1
    (eq_smul_zero scale)
    (eq_smul_div (4) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (4) scale (1) (11) (by decide) (by decide))

theorem AZ_scale_11 : toVec (AZ 11) = (scale : ℚ) • ACell11_1 :=
  toVec_eq_smul10 (AZ 11) scale ACell11_1
    (eq_smul_div (52) scale (13) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (4) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (4) scale (1) (11) (by decide) (by decide))
    (eq_smul_zero scale)

theorem AZ_scale_12 : toVec (AZ 12) = (scale : ℚ) • ACell12_1 :=
  toVec_eq_smul10 (AZ 12) scale ACell12_1
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-12) scale (-3) (11) (by decide) (by decide))
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-12) scale (-3) (11) (by decide) (by decide))
    (eq_smul_div (-12) scale (-3) (11) (by decide) (by decide))
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-12) scale (-3) (11) (by decide) (by decide))
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))

theorem AZ_scale_13 : toVec (AZ 13) = (scale : ℚ) • ACell13_1 :=
  toVec_eq_smul10 (AZ 13) scale ACell13_1
    (eq_smul_div (4) scale (1) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (12) scale (3) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (4) scale (1) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (4) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (4) scale (1) (11) (by decide) (by decide))

theorem AZ_scale_14 : toVec (AZ 14) = (scale : ℚ) • ACell14_1 :=
  toVec_eq_smul10 (AZ 14) scale ACell14_1
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (4) scale (1) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (4) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (4) scale (1) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (4) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (12) scale (3) (11) (by decide) (by decide))

theorem AZ_scale_15 : toVec (AZ 15) = (scale : ℚ) • ACell15_1 :=
  toVec_eq_smul10 (AZ 15) scale ACell15_1
    (eq_smul_div (6) scale (3) (22) (by decide) (by decide))
    (eq_smul_div (6) scale (3) (22) (by decide) (by decide))
    (eq_smul_div (6) scale (3) (22) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (12) scale (3) (11) (by decide) (by decide))
    (eq_smul_div (6) scale (3) (22) (by decide) (by decide))
    (eq_smul_div (6) scale (3) (22) (by decide) (by decide))
    (eq_smul_div (6) scale (3) (22) (by decide) (by decide))
    (eq_smul_div (6) scale (3) (22) (by decide) (by decide))
    (eq_smul_div (12) scale (3) (11) (by decide) (by decide))

theorem AZ_scale_16 : toVec (AZ 16) = (scale : ℚ) • ACell16_1 :=
  toVec_eq_smul10 (AZ 16) scale ACell16_1
    (eq_smul_zero scale)
    (eq_smul_div (6) scale (3) (22) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-6) scale (-3) (22) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-6) scale (-3) (22) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (6) scale (3) (22) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)

theorem AZ_scale_17 : toVec (AZ 17) = (scale : ℚ) • ACell17_1 :=
  toVec_eq_smul10 (AZ 17) scale ACell17_1
    (eq_smul_zero scale)
    (eq_smul_div (6) scale (3) (22) (by decide) (by decide))
    (eq_smul_div (6) scale (3) (22) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (-6) scale (-3) (22) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (-6) scale (-3) (22) (by decide) (by decide))

theorem AZ_scale_18 : toVec (AZ 18) = (scale : ℚ) • ACell18_1 :=
  toVec_eq_smul10 (AZ 18) scale ACell18_1
    (eq_smul_div (12) scale (3) (11) (by decide) (by decide))
    (eq_smul_div (12) scale (3) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (6) scale (3) (22) (by decide) (by decide))
    (eq_smul_div (6) scale (3) (22) (by decide) (by decide))
    (eq_smul_div (6) scale (3) (22) (by decide) (by decide))
    (eq_smul_div (6) scale (3) (22) (by decide) (by decide))
    (eq_smul_div (6) scale (3) (22) (by decide) (by decide))
    (eq_smul_div (6) scale (3) (22) (by decide) (by decide))
    (eq_smul_div (6) scale (3) (22) (by decide) (by decide))

theorem AZ_scale_19 : toVec (AZ 19) = (scale : ℚ) • ACell19_1 :=
  toVec_eq_smul10 (AZ 19) scale ACell19_1
    (eq_smul_zero scale)
    (eq_smul_div (-6) scale (-3) (22) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (-6) scale (-3) (22) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (6) scale (3) (22) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (6) scale (3) (22) (by decide) (by decide))

theorem AZ_scale (k : Fin 20) :
    toVec (AZ k) = (scale : ℚ) • AVec k (1 : Fin 10) :=
  forall_fin20 (P := fun k => toVec (AZ k) = (scale : ℚ) • AVec k (1 : Fin 10))
    AZ_scale_0 AZ_scale_1 AZ_scale_2 AZ_scale_3 AZ_scale_4 AZ_scale_5 AZ_scale_6 AZ_scale_7 AZ_scale_8 AZ_scale_9 AZ_scale_10 AZ_scale_11 AZ_scale_12 AZ_scale_13 AZ_scale_14 AZ_scale_15 AZ_scale_16 AZ_scale_17 AZ_scale_18 AZ_scale_19 k

theorem entry_eq :
    (matrixMul XVec AVec) (6 : Fin 10) (1 : Fin 10) =
      ![0, 0, 0, 0, 0, 0, 0, 0, 0, 0] := by
  unfold matrixMul
  refine sum_mul_eq_of_scaled scale scale_ne_zero
    (fun k => XVec (6 : Fin 10) k)
    (fun k => AVec k (1 : Fin 10))
    XZ AZ XZ_scale AZ_scale entryZ rfl _ ?_
  rw [entryZ_eq, toVec_zeroZ_smul, vec_zero_eq]

theorem entry_eq_matrixOne :
    (matrixMul XVec AVec) (6 : Fin 10) (1 : Fin 10) =
      matrixOne (Fin 10) (6 : Fin 10) (1 : Fin 10) :=
  entry_eq.trans (matrixOne_off10 (6 : Fin 10) (1 : Fin 10) (by decide)).symm

end V14Formalization.D12PiecePASplitEntry6_1


namespace V14Formalization.D12PiecePASplitEntry6_2
open D12CyclotomicVec D12CyclotomicVecZ D12PiecePAData
def payloadSha256 : String := "76c6196f29afe1a8398af99502447f48ebeed4bcb3805fc5dbec693940bc04b0"

def scale : ℤ := 44

def XZ (k : Fin 20) : VecZ :=
  match k.val with
  | 0 => #v[-5, -47, -14, -20, -48, -22, -43, -18, -23, -46]
  | 1 => #v[13, 31, -8, 20, 26, 9, 28, 26, 6, 36]
  | 2 => #v[-9, -29, -20, -16, -17, -16, -8, -4, -7, -17]
  | 3 => #v[6, -12, 14, 12, -2, 8, -16, -4, -6, -22]
  | 4 => #v[-1, -26, -12, 15, -4, -19, -5, 14, -14, -25]
  | 5 => #v[8, 12, -14, 14, 2, -18, 6, 14, -6, 26]
  | 6 => #v[-32, -54, -12, -32, -36, -16, -38, -16, 0, -50]
  | 7 => #v[-10, -4, 0, -34, -10, 38, -8, -2, 32, 20]
  | 8 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  | 9 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  | 10 => #v[11, 0, -11, 0, -11, -22, -22, -11, 0, -11]
  | 11 => #v[11, 0, -11, 0, 11, 0, 0, 11, 0, -11]
  | 12 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  | 13 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  | 14 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  | 15 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  | 16 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  | 17 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  | 18 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  | 19 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  | _ => zeroZ

def AZ (k : Fin 20) : VecZ :=
  match k.val with
  | 0 => #v[4, -4, -4, -4, -4, 4, 0, 0, 8, 0]
  | 1 => #v[4, 4, 0, -4, 0, -4, 8, -4, 0, -4]
  | 2 => #v[-56, -4, -8, -12, -8, -8, -12, -8, -4, -12]
  | 3 => #v[-8, -4, -4, -8, -8, -4, -4, -8, 0, 4]
  | 4 => #v[-8, -8, -4, 4, -4, -8, -8, 0, -4, -4]
  | 5 => #v[0, 0, 0, 0, 0, 0, -6, 6, 6, -6]
  | 6 => #v[6, 6, 6, 0, 6, 6, 12, 12, 6, 6]
  | 7 => #v[-6, 0, -6, -6, -12, -6, -6, -12, -6, -6]
  | 8 => #v[0, -6, 0, 6, 0, 6, 0, -6, 0, 0]
  | 9 => #v[6, 6, 6, 6, 0, 12, 6, 6, 6, 12]
  | 10 => #v[4, 4, 0, -4, 0, -4, 8, -4, 0, -4]
  | 11 => #v[8, 12, 8, 0, 4, 4, 0, 0, 4, 4]
  | 12 => #v[52, 0, -4, -4, 4, 0, 0, 4, -4, -4]
  | 13 => #v[4, 8, 0, 12, 0, 8, 4, 0, 4, 4]
  | 14 => #v[-8, -8, -4, -12, -12, -12, -12, -4, -8, -8]
  | 15 => #v[6, 12, 6, 12, 6, 0, 6, 6, 6, 6]
  | 16 => #v[0, -6, 0, 0, 6, 0, 6, 0, 0, -6]
  | 17 => #v[-12, -6, -6, -6, -6, -12, 0, -6, -6, -6]
  | 18 => #v[0, -6, -6, 0, 0, 6, 0, 0, 0, 6]
  | 19 => #v[0, 0, 6, -6, -6, 6, 0, 0, 0, 0]
  | _ => zeroZ

def entryZ : VecZ := sumFin (fun k => mulZ (XZ k) (AZ k))

theorem entryZ_eq : entryZ = zeroZ :=
  eq_of_eqZ (by decide +kernel)

theorem scale_ne_zero : scale ≠ 0 := by
  decide

theorem XZ_scale_0 : toVec (XZ 0) = (scale : ℚ) • XCell6_0 :=
  toVec_eq_smul10 (XZ 0) scale XCell6_0
    (eq_smul_div (-5) scale (-5) (44) (by decide) (by decide))
    (eq_smul_div (-47) scale (-47) (44) (by decide) (by decide))
    (eq_smul_div (-14) scale (-7) (22) (by decide) (by decide))
    (eq_smul_div (-20) scale (-5) (11) (by decide) (by decide))
    (eq_smul_div (-48) scale (-12) (11) (by decide) (by decide))
    (eq_smul_div (-22) scale (-1) (2) (by decide) (by decide))
    (eq_smul_div (-43) scale (-43) (44) (by decide) (by decide))
    (eq_smul_div (-18) scale (-9) (22) (by decide) (by decide))
    (eq_smul_div (-23) scale (-23) (44) (by decide) (by decide))
    (eq_smul_div (-46) scale (-23) (22) (by decide) (by decide))

theorem XZ_scale_1 : toVec (XZ 1) = (scale : ℚ) • XCell6_1 :=
  toVec_eq_smul10 (XZ 1) scale XCell6_1
    (eq_smul_div (13) scale (13) (44) (by decide) (by decide))
    (eq_smul_div (31) scale (31) (44) (by decide) (by decide))
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (20) scale (5) (11) (by decide) (by decide))
    (eq_smul_div (26) scale (13) (22) (by decide) (by decide))
    (eq_smul_div (9) scale (9) (44) (by decide) (by decide))
    (eq_smul_div (28) scale (7) (11) (by decide) (by decide))
    (eq_smul_div (26) scale (13) (22) (by decide) (by decide))
    (eq_smul_div (6) scale (3) (22) (by decide) (by decide))
    (eq_smul_div (36) scale (9) (11) (by decide) (by decide))

theorem XZ_scale_2 : toVec (XZ 2) = (scale : ℚ) • XCell6_2 :=
  toVec_eq_smul10 (XZ 2) scale XCell6_2
    (eq_smul_div (-9) scale (-9) (44) (by decide) (by decide))
    (eq_smul_div (-29) scale (-29) (44) (by decide) (by decide))
    (eq_smul_div (-20) scale (-5) (11) (by decide) (by decide))
    (eq_smul_div (-16) scale (-4) (11) (by decide) (by decide))
    (eq_smul_div (-17) scale (-17) (44) (by decide) (by decide))
    (eq_smul_div (-16) scale (-4) (11) (by decide) (by decide))
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-7) scale (-7) (44) (by decide) (by decide))
    (eq_smul_div (-17) scale (-17) (44) (by decide) (by decide))

theorem XZ_scale_3 : toVec (XZ 3) = (scale : ℚ) • XCell6_3 :=
  toVec_eq_smul10 (XZ 3) scale XCell6_3
    (eq_smul_div (6) scale (3) (22) (by decide) (by decide))
    (eq_smul_div (-12) scale (-3) (11) (by decide) (by decide))
    (eq_smul_div (14) scale (7) (22) (by decide) (by decide))
    (eq_smul_div (12) scale (3) (11) (by decide) (by decide))
    (eq_smul_div (-2) scale (-1) (22) (by decide) (by decide))
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (-16) scale (-4) (11) (by decide) (by decide))
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-6) scale (-3) (22) (by decide) (by decide))
    (eq_smul_div (-22) scale (-1) (2) (by decide) (by decide))

theorem XZ_scale_4 : toVec (XZ 4) = (scale : ℚ) • XCell6_4 :=
  toVec_eq_smul10 (XZ 4) scale XCell6_4
    (eq_smul_div (-1) scale (-1) (44) (by decide) (by decide))
    (eq_smul_div (-26) scale (-13) (22) (by decide) (by decide))
    (eq_smul_div (-12) scale (-3) (11) (by decide) (by decide))
    (eq_smul_div (15) scale (15) (44) (by decide) (by decide))
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-19) scale (-19) (44) (by decide) (by decide))
    (eq_smul_div (-5) scale (-5) (44) (by decide) (by decide))
    (eq_smul_div (14) scale (7) (22) (by decide) (by decide))
    (eq_smul_div (-14) scale (-7) (22) (by decide) (by decide))
    (eq_smul_div (-25) scale (-25) (44) (by decide) (by decide))

theorem XZ_scale_5 : toVec (XZ 5) = (scale : ℚ) • XCell6_5 :=
  toVec_eq_smul10 (XZ 5) scale XCell6_5
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (12) scale (3) (11) (by decide) (by decide))
    (eq_smul_div (-14) scale (-7) (22) (by decide) (by decide))
    (eq_smul_div (14) scale (7) (22) (by decide) (by decide))
    (eq_smul_div (2) scale (1) (22) (by decide) (by decide))
    (eq_smul_div (-18) scale (-9) (22) (by decide) (by decide))
    (eq_smul_div (6) scale (3) (22) (by decide) (by decide))
    (eq_smul_div (14) scale (7) (22) (by decide) (by decide))
    (eq_smul_div (-6) scale (-3) (22) (by decide) (by decide))
    (eq_smul_div (26) scale (13) (22) (by decide) (by decide))

theorem XZ_scale_6 : toVec (XZ 6) = (scale : ℚ) • XCell6_6 :=
  toVec_eq_smul10 (XZ 6) scale XCell6_6
    (eq_smul_div (-32) scale (-8) (11) (by decide) (by decide))
    (eq_smul_div (-54) scale (-27) (22) (by decide) (by decide))
    (eq_smul_div (-12) scale (-3) (11) (by decide) (by decide))
    (eq_smul_div (-32) scale (-8) (11) (by decide) (by decide))
    (eq_smul_div (-36) scale (-9) (11) (by decide) (by decide))
    (eq_smul_div (-16) scale (-4) (11) (by decide) (by decide))
    (eq_smul_div (-38) scale (-19) (22) (by decide) (by decide))
    (eq_smul_div (-16) scale (-4) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-50) scale (-25) (22) (by decide) (by decide))

theorem XZ_scale_7 : toVec (XZ 7) = (scale : ℚ) • XCell6_7 :=
  toVec_eq_smul10 (XZ 7) scale XCell6_7
    (eq_smul_div (-10) scale (-5) (22) (by decide) (by decide))
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-34) scale (-17) (22) (by decide) (by decide))
    (eq_smul_div (-10) scale (-5) (22) (by decide) (by decide))
    (eq_smul_div (38) scale (19) (22) (by decide) (by decide))
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-2) scale (-1) (22) (by decide) (by decide))
    (eq_smul_div (32) scale (8) (11) (by decide) (by decide))
    (eq_smul_div (20) scale (5) (11) (by decide) (by decide))

theorem XZ_scale_8 : toVec (XZ 8) = (scale : ℚ) • XCell6_8 :=
  toVec_eq_smul10 (XZ 8) scale XCell6_8
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)

theorem XZ_scale_9 : toVec (XZ 9) = (scale : ℚ) • XCell6_9 :=
  toVec_eq_smul10 (XZ 9) scale XCell6_9
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)

theorem XZ_scale_10 : toVec (XZ 10) = (scale : ℚ) • XCell6_10 :=
  toVec_eq_smul10 (XZ 10) scale XCell6_10
    (eq_smul_div (11) scale (1) (4) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-11) scale (-1) (4) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-11) scale (-1) (4) (by decide) (by decide))
    (eq_smul_div (-22) scale (-1) (2) (by decide) (by decide))
    (eq_smul_div (-22) scale (-1) (2) (by decide) (by decide))
    (eq_smul_div (-11) scale (-1) (4) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-11) scale (-1) (4) (by decide) (by decide))

theorem XZ_scale_11 : toVec (XZ 11) = (scale : ℚ) • XCell6_11 :=
  toVec_eq_smul10 (XZ 11) scale XCell6_11
    (eq_smul_div (11) scale (1) (4) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-11) scale (-1) (4) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (11) scale (1) (4) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (11) scale (1) (4) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-11) scale (-1) (4) (by decide) (by decide))

theorem XZ_scale_12 : toVec (XZ 12) = (scale : ℚ) • XCell6_12 :=
  toVec_eq_smul10 (XZ 12) scale XCell6_12
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)

theorem XZ_scale_13 : toVec (XZ 13) = (scale : ℚ) • XCell6_13 :=
  toVec_eq_smul10 (XZ 13) scale XCell6_13
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)

theorem XZ_scale_14 : toVec (XZ 14) = (scale : ℚ) • XCell6_14 :=
  toVec_eq_smul10 (XZ 14) scale XCell6_14
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)

theorem XZ_scale_15 : toVec (XZ 15) = (scale : ℚ) • XCell6_15 :=
  toVec_eq_smul10 (XZ 15) scale XCell6_15
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)

theorem XZ_scale_16 : toVec (XZ 16) = (scale : ℚ) • XCell6_16 :=
  toVec_eq_smul10 (XZ 16) scale XCell6_16
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)

theorem XZ_scale_17 : toVec (XZ 17) = (scale : ℚ) • XCell6_17 :=
  toVec_eq_smul10 (XZ 17) scale XCell6_17
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)

theorem XZ_scale_18 : toVec (XZ 18) = (scale : ℚ) • XCell6_18 :=
  toVec_eq_smul10 (XZ 18) scale XCell6_18
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)

theorem XZ_scale_19 : toVec (XZ 19) = (scale : ℚ) • XCell6_19 :=
  toVec_eq_smul10 (XZ 19) scale XCell6_19
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)

theorem XZ_scale (k : Fin 20) :
    toVec (XZ k) = (scale : ℚ) • XVec (6 : Fin 10) k :=
  forall_fin20 (P := fun k => toVec (XZ k) = (scale : ℚ) • XVec (6 : Fin 10) k)
    XZ_scale_0 XZ_scale_1 XZ_scale_2 XZ_scale_3 XZ_scale_4 XZ_scale_5 XZ_scale_6 XZ_scale_7 XZ_scale_8 XZ_scale_9 XZ_scale_10 XZ_scale_11 XZ_scale_12 XZ_scale_13 XZ_scale_14 XZ_scale_15 XZ_scale_16 XZ_scale_17 XZ_scale_18 XZ_scale_19 k

theorem AZ_scale_0 : toVec (AZ 0) = (scale : ℚ) • ACell0_2 :=
  toVec_eq_smul10 (AZ 0) scale ACell0_2
    (eq_smul_div (4) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (4) scale (1) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_zero scale)

theorem AZ_scale_1 : toVec (AZ 1) = (scale : ℚ) • ACell1_2 :=
  toVec_eq_smul10 (AZ 1) scale ACell1_2
    (eq_smul_div (4) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (4) scale (1) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))

theorem AZ_scale_2 : toVec (AZ 2) = (scale : ℚ) • ACell2_2 :=
  toVec_eq_smul10 (AZ 2) scale ACell2_2
    (eq_smul_div (-56) scale (-14) (11) (by decide) (by decide))
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-12) scale (-3) (11) (by decide) (by decide))
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-12) scale (-3) (11) (by decide) (by decide))
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-12) scale (-3) (11) (by decide) (by decide))

theorem AZ_scale_3 : toVec (AZ 3) = (scale : ℚ) • ACell3_2 :=
  toVec_eq_smul10 (AZ 3) scale ACell3_2
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (4) scale (1) (11) (by decide) (by decide))

theorem AZ_scale_4 : toVec (AZ 4) = (scale : ℚ) • ACell4_2 :=
  toVec_eq_smul10 (AZ 4) scale ACell4_2
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (4) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))

theorem AZ_scale_5 : toVec (AZ 5) = (scale : ℚ) • ACell5_2 :=
  toVec_eq_smul10 (AZ 5) scale ACell5_2
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (-6) scale (-3) (22) (by decide) (by decide))
    (eq_smul_div (6) scale (3) (22) (by decide) (by decide))
    (eq_smul_div (6) scale (3) (22) (by decide) (by decide))
    (eq_smul_div (-6) scale (-3) (22) (by decide) (by decide))

theorem AZ_scale_6 : toVec (AZ 6) = (scale : ℚ) • ACell6_2 :=
  toVec_eq_smul10 (AZ 6) scale ACell6_2
    (eq_smul_div (6) scale (3) (22) (by decide) (by decide))
    (eq_smul_div (6) scale (3) (22) (by decide) (by decide))
    (eq_smul_div (6) scale (3) (22) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (6) scale (3) (22) (by decide) (by decide))
    (eq_smul_div (6) scale (3) (22) (by decide) (by decide))
    (eq_smul_div (12) scale (3) (11) (by decide) (by decide))
    (eq_smul_div (12) scale (3) (11) (by decide) (by decide))
    (eq_smul_div (6) scale (3) (22) (by decide) (by decide))
    (eq_smul_div (6) scale (3) (22) (by decide) (by decide))

theorem AZ_scale_7 : toVec (AZ 7) = (scale : ℚ) • ACell7_2 :=
  toVec_eq_smul10 (AZ 7) scale ACell7_2
    (eq_smul_div (-6) scale (-3) (22) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-6) scale (-3) (22) (by decide) (by decide))
    (eq_smul_div (-6) scale (-3) (22) (by decide) (by decide))
    (eq_smul_div (-12) scale (-3) (11) (by decide) (by decide))
    (eq_smul_div (-6) scale (-3) (22) (by decide) (by decide))
    (eq_smul_div (-6) scale (-3) (22) (by decide) (by decide))
    (eq_smul_div (-12) scale (-3) (11) (by decide) (by decide))
    (eq_smul_div (-6) scale (-3) (22) (by decide) (by decide))
    (eq_smul_div (-6) scale (-3) (22) (by decide) (by decide))

theorem AZ_scale_8 : toVec (AZ 8) = (scale : ℚ) • ACell8_2 :=
  toVec_eq_smul10 (AZ 8) scale ACell8_2
    (eq_smul_zero scale)
    (eq_smul_div (-6) scale (-3) (22) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (6) scale (3) (22) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (6) scale (3) (22) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-6) scale (-3) (22) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)

theorem AZ_scale_9 : toVec (AZ 9) = (scale : ℚ) • ACell9_2 :=
  toVec_eq_smul10 (AZ 9) scale ACell9_2
    (eq_smul_div (6) scale (3) (22) (by decide) (by decide))
    (eq_smul_div (6) scale (3) (22) (by decide) (by decide))
    (eq_smul_div (6) scale (3) (22) (by decide) (by decide))
    (eq_smul_div (6) scale (3) (22) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (12) scale (3) (11) (by decide) (by decide))
    (eq_smul_div (6) scale (3) (22) (by decide) (by decide))
    (eq_smul_div (6) scale (3) (22) (by decide) (by decide))
    (eq_smul_div (6) scale (3) (22) (by decide) (by decide))
    (eq_smul_div (12) scale (3) (11) (by decide) (by decide))

theorem AZ_scale_10 : toVec (AZ 10) = (scale : ℚ) • ACell10_2 :=
  toVec_eq_smul10 (AZ 10) scale ACell10_2
    (eq_smul_div (4) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (4) scale (1) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))

theorem AZ_scale_11 : toVec (AZ 11) = (scale : ℚ) • ACell11_2 :=
  toVec_eq_smul10 (AZ 11) scale ACell11_2
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (12) scale (3) (11) (by decide) (by decide))
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (4) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (4) scale (1) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (4) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (4) scale (1) (11) (by decide) (by decide))

theorem AZ_scale_12 : toVec (AZ 12) = (scale : ℚ) • ACell12_2 :=
  toVec_eq_smul10 (AZ 12) scale ACell12_2
    (eq_smul_div (52) scale (13) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (4) scale (1) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (4) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))

theorem AZ_scale_13 : toVec (AZ 13) = (scale : ℚ) • ACell13_2 :=
  toVec_eq_smul10 (AZ 13) scale ACell13_2
    (eq_smul_div (4) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (12) scale (3) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (4) scale (1) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (4) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (4) scale (1) (11) (by decide) (by decide))

theorem AZ_scale_14 : toVec (AZ 14) = (scale : ℚ) • ACell14_2 :=
  toVec_eq_smul10 (AZ 14) scale ACell14_2
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-12) scale (-3) (11) (by decide) (by decide))
    (eq_smul_div (-12) scale (-3) (11) (by decide) (by decide))
    (eq_smul_div (-12) scale (-3) (11) (by decide) (by decide))
    (eq_smul_div (-12) scale (-3) (11) (by decide) (by decide))
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))

theorem AZ_scale_15 : toVec (AZ 15) = (scale : ℚ) • ACell15_2 :=
  toVec_eq_smul10 (AZ 15) scale ACell15_2
    (eq_smul_div (6) scale (3) (22) (by decide) (by decide))
    (eq_smul_div (12) scale (3) (11) (by decide) (by decide))
    (eq_smul_div (6) scale (3) (22) (by decide) (by decide))
    (eq_smul_div (12) scale (3) (11) (by decide) (by decide))
    (eq_smul_div (6) scale (3) (22) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (6) scale (3) (22) (by decide) (by decide))
    (eq_smul_div (6) scale (3) (22) (by decide) (by decide))
    (eq_smul_div (6) scale (3) (22) (by decide) (by decide))
    (eq_smul_div (6) scale (3) (22) (by decide) (by decide))

theorem AZ_scale_16 : toVec (AZ 16) = (scale : ℚ) • ACell16_2 :=
  toVec_eq_smul10 (AZ 16) scale ACell16_2
    (eq_smul_zero scale)
    (eq_smul_div (-6) scale (-3) (22) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (6) scale (3) (22) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (6) scale (3) (22) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (-6) scale (-3) (22) (by decide) (by decide))

theorem AZ_scale_17 : toVec (AZ 17) = (scale : ℚ) • ACell17_2 :=
  toVec_eq_smul10 (AZ 17) scale ACell17_2
    (eq_smul_div (-12) scale (-3) (11) (by decide) (by decide))
    (eq_smul_div (-6) scale (-3) (22) (by decide) (by decide))
    (eq_smul_div (-6) scale (-3) (22) (by decide) (by decide))
    (eq_smul_div (-6) scale (-3) (22) (by decide) (by decide))
    (eq_smul_div (-6) scale (-3) (22) (by decide) (by decide))
    (eq_smul_div (-12) scale (-3) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-6) scale (-3) (22) (by decide) (by decide))
    (eq_smul_div (-6) scale (-3) (22) (by decide) (by decide))
    (eq_smul_div (-6) scale (-3) (22) (by decide) (by decide))

theorem AZ_scale_18 : toVec (AZ 18) = (scale : ℚ) • ACell18_2 :=
  toVec_eq_smul10 (AZ 18) scale ACell18_2
    (eq_smul_zero scale)
    (eq_smul_div (-6) scale (-3) (22) (by decide) (by decide))
    (eq_smul_div (-6) scale (-3) (22) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (6) scale (3) (22) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (6) scale (3) (22) (by decide) (by decide))

theorem AZ_scale_19 : toVec (AZ 19) = (scale : ℚ) • ACell19_2 :=
  toVec_eq_smul10 (AZ 19) scale ACell19_2
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (6) scale (3) (22) (by decide) (by decide))
    (eq_smul_div (-6) scale (-3) (22) (by decide) (by decide))
    (eq_smul_div (-6) scale (-3) (22) (by decide) (by decide))
    (eq_smul_div (6) scale (3) (22) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)

theorem AZ_scale (k : Fin 20) :
    toVec (AZ k) = (scale : ℚ) • AVec k (2 : Fin 10) :=
  forall_fin20 (P := fun k => toVec (AZ k) = (scale : ℚ) • AVec k (2 : Fin 10))
    AZ_scale_0 AZ_scale_1 AZ_scale_2 AZ_scale_3 AZ_scale_4 AZ_scale_5 AZ_scale_6 AZ_scale_7 AZ_scale_8 AZ_scale_9 AZ_scale_10 AZ_scale_11 AZ_scale_12 AZ_scale_13 AZ_scale_14 AZ_scale_15 AZ_scale_16 AZ_scale_17 AZ_scale_18 AZ_scale_19 k

theorem entry_eq :
    (matrixMul XVec AVec) (6 : Fin 10) (2 : Fin 10) =
      ![0, 0, 0, 0, 0, 0, 0, 0, 0, 0] := by
  unfold matrixMul
  refine sum_mul_eq_of_scaled scale scale_ne_zero
    (fun k => XVec (6 : Fin 10) k)
    (fun k => AVec k (2 : Fin 10))
    XZ AZ XZ_scale AZ_scale entryZ rfl _ ?_
  rw [entryZ_eq, toVec_zeroZ_smul, vec_zero_eq]

theorem entry_eq_matrixOne :
    (matrixMul XVec AVec) (6 : Fin 10) (2 : Fin 10) =
      matrixOne (Fin 10) (6 : Fin 10) (2 : Fin 10) :=
  entry_eq.trans (matrixOne_off10 (6 : Fin 10) (2 : Fin 10) (by decide)).symm

end V14Formalization.D12PiecePASplitEntry6_2


namespace V14Formalization.D12PiecePASplitEntry6_3
open D12CyclotomicVec D12CyclotomicVecZ D12PiecePAData
def payloadSha256 : String := "76c6196f29afe1a8398af99502447f48ebeed4bcb3805fc5dbec693940bc04b0"

def scale : ℤ := 44

def XZ (k : Fin 20) : VecZ :=
  match k.val with
  | 0 => #v[-5, -47, -14, -20, -48, -22, -43, -18, -23, -46]
  | 1 => #v[13, 31, -8, 20, 26, 9, 28, 26, 6, 36]
  | 2 => #v[-9, -29, -20, -16, -17, -16, -8, -4, -7, -17]
  | 3 => #v[6, -12, 14, 12, -2, 8, -16, -4, -6, -22]
  | 4 => #v[-1, -26, -12, 15, -4, -19, -5, 14, -14, -25]
  | 5 => #v[8, 12, -14, 14, 2, -18, 6, 14, -6, 26]
  | 6 => #v[-32, -54, -12, -32, -36, -16, -38, -16, 0, -50]
  | 7 => #v[-10, -4, 0, -34, -10, 38, -8, -2, 32, 20]
  | 8 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  | 9 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  | 10 => #v[11, 0, -11, 0, -11, -22, -22, -11, 0, -11]
  | 11 => #v[11, 0, -11, 0, 11, 0, 0, 11, 0, -11]
  | 12 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  | 13 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  | 14 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  | 15 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  | 16 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  | 17 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  | 18 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  | 19 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  | _ => zeroZ

def AZ (k : Fin 20) : VecZ :=
  match k.val with
  | 0 => #v[8, 4, 4, 8, 0, 0, 4, 12, 4, 0]
  | 1 => #v[0, 0, 8, 4, 4, 12, 4, 4, 8, 0]
  | 2 => #v[-8, -4, -4, -8, -8, -4, -4, -8, 0, 4]
  | 3 => #v[-48, 0, 4, 4, 0, -4, 0, -4, 8, -4]
  | 4 => #v[4, -4, 8, -4, 4, 0, -4, 0, 0, -4]
  | 5 => #v[6, 6, 6, 0, 12, 6, 6, 6, 6, 12]
  | 6 => #v[6, 0, 6, 12, 6, 6, 6, 6, 12, 6]
  | 7 => #v[0, -6, 0, 0, 6, 6, 0, 0, -6, 0]
  | 8 => #v[6, 6, 6, 6, 6, 6, 6, 0, 12, 12]
  | 9 => #v[6, 6, 0, 6, 6, 12, 6, 12, 6, 6]
  | 10 => #v[8, 4, 4, 12, 4, 4, 8, 0, 0, 0]
  | 11 => #v[4, 0, 4, 8, 8, 4, 0, 4, 0, 12]
  | 12 => #v[-4, -8, -4, -4, -8, -4, 0, -8, 4, -8]
  | 13 => #v[48, 0, -8, -4, -4, -8, -8, -4, -4, -8]
  | 14 => #v[8, 4, 4, 8, 0, 0, 4, 12, 4, 0]
  | 15 => #v[0, 0, 0, -6, 6, 6, -6, 0, 0, 0]
  | 16 => #v[-6, 0, 0, 0, -6, 0, 0, 6, 6, 0]
  | 17 => #v[0, -6, 0, 0, 6, 0, 6, 0, 0, -6]
  | 18 => #v[0, -6, 0, 6, 0, 6, 0, -6, 0, 0]
  | 19 => #v[0, 0, 0, -6, 6, 0, 0, 0, 6, -6]
  | _ => zeroZ

def entryZ : VecZ := sumFin (fun k => mulZ (XZ k) (AZ k))

theorem entryZ_eq : entryZ = zeroZ :=
  eq_of_eqZ (by decide +kernel)

theorem scale_ne_zero : scale ≠ 0 := by
  decide

theorem XZ_scale_0 : toVec (XZ 0) = (scale : ℚ) • XCell6_0 :=
  toVec_eq_smul10 (XZ 0) scale XCell6_0
    (eq_smul_div (-5) scale (-5) (44) (by decide) (by decide))
    (eq_smul_div (-47) scale (-47) (44) (by decide) (by decide))
    (eq_smul_div (-14) scale (-7) (22) (by decide) (by decide))
    (eq_smul_div (-20) scale (-5) (11) (by decide) (by decide))
    (eq_smul_div (-48) scale (-12) (11) (by decide) (by decide))
    (eq_smul_div (-22) scale (-1) (2) (by decide) (by decide))
    (eq_smul_div (-43) scale (-43) (44) (by decide) (by decide))
    (eq_smul_div (-18) scale (-9) (22) (by decide) (by decide))
    (eq_smul_div (-23) scale (-23) (44) (by decide) (by decide))
    (eq_smul_div (-46) scale (-23) (22) (by decide) (by decide))

theorem XZ_scale_1 : toVec (XZ 1) = (scale : ℚ) • XCell6_1 :=
  toVec_eq_smul10 (XZ 1) scale XCell6_1
    (eq_smul_div (13) scale (13) (44) (by decide) (by decide))
    (eq_smul_div (31) scale (31) (44) (by decide) (by decide))
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (20) scale (5) (11) (by decide) (by decide))
    (eq_smul_div (26) scale (13) (22) (by decide) (by decide))
    (eq_smul_div (9) scale (9) (44) (by decide) (by decide))
    (eq_smul_div (28) scale (7) (11) (by decide) (by decide))
    (eq_smul_div (26) scale (13) (22) (by decide) (by decide))
    (eq_smul_div (6) scale (3) (22) (by decide) (by decide))
    (eq_smul_div (36) scale (9) (11) (by decide) (by decide))

theorem XZ_scale_2 : toVec (XZ 2) = (scale : ℚ) • XCell6_2 :=
  toVec_eq_smul10 (XZ 2) scale XCell6_2
    (eq_smul_div (-9) scale (-9) (44) (by decide) (by decide))
    (eq_smul_div (-29) scale (-29) (44) (by decide) (by decide))
    (eq_smul_div (-20) scale (-5) (11) (by decide) (by decide))
    (eq_smul_div (-16) scale (-4) (11) (by decide) (by decide))
    (eq_smul_div (-17) scale (-17) (44) (by decide) (by decide))
    (eq_smul_div (-16) scale (-4) (11) (by decide) (by decide))
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-7) scale (-7) (44) (by decide) (by decide))
    (eq_smul_div (-17) scale (-17) (44) (by decide) (by decide))

theorem XZ_scale_3 : toVec (XZ 3) = (scale : ℚ) • XCell6_3 :=
  toVec_eq_smul10 (XZ 3) scale XCell6_3
    (eq_smul_div (6) scale (3) (22) (by decide) (by decide))
    (eq_smul_div (-12) scale (-3) (11) (by decide) (by decide))
    (eq_smul_div (14) scale (7) (22) (by decide) (by decide))
    (eq_smul_div (12) scale (3) (11) (by decide) (by decide))
    (eq_smul_div (-2) scale (-1) (22) (by decide) (by decide))
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (-16) scale (-4) (11) (by decide) (by decide))
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-6) scale (-3) (22) (by decide) (by decide))
    (eq_smul_div (-22) scale (-1) (2) (by decide) (by decide))

theorem XZ_scale_4 : toVec (XZ 4) = (scale : ℚ) • XCell6_4 :=
  toVec_eq_smul10 (XZ 4) scale XCell6_4
    (eq_smul_div (-1) scale (-1) (44) (by decide) (by decide))
    (eq_smul_div (-26) scale (-13) (22) (by decide) (by decide))
    (eq_smul_div (-12) scale (-3) (11) (by decide) (by decide))
    (eq_smul_div (15) scale (15) (44) (by decide) (by decide))
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-19) scale (-19) (44) (by decide) (by decide))
    (eq_smul_div (-5) scale (-5) (44) (by decide) (by decide))
    (eq_smul_div (14) scale (7) (22) (by decide) (by decide))
    (eq_smul_div (-14) scale (-7) (22) (by decide) (by decide))
    (eq_smul_div (-25) scale (-25) (44) (by decide) (by decide))

theorem XZ_scale_5 : toVec (XZ 5) = (scale : ℚ) • XCell6_5 :=
  toVec_eq_smul10 (XZ 5) scale XCell6_5
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (12) scale (3) (11) (by decide) (by decide))
    (eq_smul_div (-14) scale (-7) (22) (by decide) (by decide))
    (eq_smul_div (14) scale (7) (22) (by decide) (by decide))
    (eq_smul_div (2) scale (1) (22) (by decide) (by decide))
    (eq_smul_div (-18) scale (-9) (22) (by decide) (by decide))
    (eq_smul_div (6) scale (3) (22) (by decide) (by decide))
    (eq_smul_div (14) scale (7) (22) (by decide) (by decide))
    (eq_smul_div (-6) scale (-3) (22) (by decide) (by decide))
    (eq_smul_div (26) scale (13) (22) (by decide) (by decide))

theorem XZ_scale_6 : toVec (XZ 6) = (scale : ℚ) • XCell6_6 :=
  toVec_eq_smul10 (XZ 6) scale XCell6_6
    (eq_smul_div (-32) scale (-8) (11) (by decide) (by decide))
    (eq_smul_div (-54) scale (-27) (22) (by decide) (by decide))
    (eq_smul_div (-12) scale (-3) (11) (by decide) (by decide))
    (eq_smul_div (-32) scale (-8) (11) (by decide) (by decide))
    (eq_smul_div (-36) scale (-9) (11) (by decide) (by decide))
    (eq_smul_div (-16) scale (-4) (11) (by decide) (by decide))
    (eq_smul_div (-38) scale (-19) (22) (by decide) (by decide))
    (eq_smul_div (-16) scale (-4) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-50) scale (-25) (22) (by decide) (by decide))

theorem XZ_scale_7 : toVec (XZ 7) = (scale : ℚ) • XCell6_7 :=
  toVec_eq_smul10 (XZ 7) scale XCell6_7
    (eq_smul_div (-10) scale (-5) (22) (by decide) (by decide))
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-34) scale (-17) (22) (by decide) (by decide))
    (eq_smul_div (-10) scale (-5) (22) (by decide) (by decide))
    (eq_smul_div (38) scale (19) (22) (by decide) (by decide))
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-2) scale (-1) (22) (by decide) (by decide))
    (eq_smul_div (32) scale (8) (11) (by decide) (by decide))
    (eq_smul_div (20) scale (5) (11) (by decide) (by decide))

theorem XZ_scale_8 : toVec (XZ 8) = (scale : ℚ) • XCell6_8 :=
  toVec_eq_smul10 (XZ 8) scale XCell6_8
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)

theorem XZ_scale_9 : toVec (XZ 9) = (scale : ℚ) • XCell6_9 :=
  toVec_eq_smul10 (XZ 9) scale XCell6_9
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)

theorem XZ_scale_10 : toVec (XZ 10) = (scale : ℚ) • XCell6_10 :=
  toVec_eq_smul10 (XZ 10) scale XCell6_10
    (eq_smul_div (11) scale (1) (4) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-11) scale (-1) (4) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-11) scale (-1) (4) (by decide) (by decide))
    (eq_smul_div (-22) scale (-1) (2) (by decide) (by decide))
    (eq_smul_div (-22) scale (-1) (2) (by decide) (by decide))
    (eq_smul_div (-11) scale (-1) (4) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-11) scale (-1) (4) (by decide) (by decide))

theorem XZ_scale_11 : toVec (XZ 11) = (scale : ℚ) • XCell6_11 :=
  toVec_eq_smul10 (XZ 11) scale XCell6_11
    (eq_smul_div (11) scale (1) (4) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-11) scale (-1) (4) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (11) scale (1) (4) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (11) scale (1) (4) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-11) scale (-1) (4) (by decide) (by decide))

theorem XZ_scale_12 : toVec (XZ 12) = (scale : ℚ) • XCell6_12 :=
  toVec_eq_smul10 (XZ 12) scale XCell6_12
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)

theorem XZ_scale_13 : toVec (XZ 13) = (scale : ℚ) • XCell6_13 :=
  toVec_eq_smul10 (XZ 13) scale XCell6_13
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)

theorem XZ_scale_14 : toVec (XZ 14) = (scale : ℚ) • XCell6_14 :=
  toVec_eq_smul10 (XZ 14) scale XCell6_14
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)

theorem XZ_scale_15 : toVec (XZ 15) = (scale : ℚ) • XCell6_15 :=
  toVec_eq_smul10 (XZ 15) scale XCell6_15
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)

theorem XZ_scale_16 : toVec (XZ 16) = (scale : ℚ) • XCell6_16 :=
  toVec_eq_smul10 (XZ 16) scale XCell6_16
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)

theorem XZ_scale_17 : toVec (XZ 17) = (scale : ℚ) • XCell6_17 :=
  toVec_eq_smul10 (XZ 17) scale XCell6_17
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)

theorem XZ_scale_18 : toVec (XZ 18) = (scale : ℚ) • XCell6_18 :=
  toVec_eq_smul10 (XZ 18) scale XCell6_18
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)

theorem XZ_scale_19 : toVec (XZ 19) = (scale : ℚ) • XCell6_19 :=
  toVec_eq_smul10 (XZ 19) scale XCell6_19
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)

theorem XZ_scale (k : Fin 20) :
    toVec (XZ k) = (scale : ℚ) • XVec (6 : Fin 10) k :=
  forall_fin20 (P := fun k => toVec (XZ k) = (scale : ℚ) • XVec (6 : Fin 10) k)
    XZ_scale_0 XZ_scale_1 XZ_scale_2 XZ_scale_3 XZ_scale_4 XZ_scale_5 XZ_scale_6 XZ_scale_7 XZ_scale_8 XZ_scale_9 XZ_scale_10 XZ_scale_11 XZ_scale_12 XZ_scale_13 XZ_scale_14 XZ_scale_15 XZ_scale_16 XZ_scale_17 XZ_scale_18 XZ_scale_19 k

theorem AZ_scale_0 : toVec (AZ 0) = (scale : ℚ) • ACell0_3 :=
  toVec_eq_smul10 (AZ 0) scale ACell0_3
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (4) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (4) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (4) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (12) scale (3) (11) (by decide) (by decide))
    (eq_smul_div (4) scale (1) (11) (by decide) (by decide))
    (eq_smul_zero scale)

theorem AZ_scale_1 : toVec (AZ 1) = (scale : ℚ) • ACell1_3 :=
  toVec_eq_smul10 (AZ 1) scale ACell1_3
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (4) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (4) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (12) scale (3) (11) (by decide) (by decide))
    (eq_smul_div (4) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (4) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_zero scale)

theorem AZ_scale_2 : toVec (AZ 2) = (scale : ℚ) • ACell2_3 :=
  toVec_eq_smul10 (AZ 2) scale ACell2_3
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (4) scale (1) (11) (by decide) (by decide))

theorem AZ_scale_3 : toVec (AZ 3) = (scale : ℚ) • ACell3_3 :=
  toVec_eq_smul10 (AZ 3) scale ACell3_3
    (eq_smul_div (-48) scale (-12) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (4) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (4) scale (1) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))

theorem AZ_scale_4 : toVec (AZ 4) = (scale : ℚ) • ACell4_3 :=
  toVec_eq_smul10 (AZ 4) scale ACell4_3
    (eq_smul_div (4) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (4) scale (1) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))

theorem AZ_scale_5 : toVec (AZ 5) = (scale : ℚ) • ACell5_3 :=
  toVec_eq_smul10 (AZ 5) scale ACell5_3
    (eq_smul_div (6) scale (3) (22) (by decide) (by decide))
    (eq_smul_div (6) scale (3) (22) (by decide) (by decide))
    (eq_smul_div (6) scale (3) (22) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (12) scale (3) (11) (by decide) (by decide))
    (eq_smul_div (6) scale (3) (22) (by decide) (by decide))
    (eq_smul_div (6) scale (3) (22) (by decide) (by decide))
    (eq_smul_div (6) scale (3) (22) (by decide) (by decide))
    (eq_smul_div (6) scale (3) (22) (by decide) (by decide))
    (eq_smul_div (12) scale (3) (11) (by decide) (by decide))

theorem AZ_scale_6 : toVec (AZ 6) = (scale : ℚ) • ACell6_3 :=
  toVec_eq_smul10 (AZ 6) scale ACell6_3
    (eq_smul_div (6) scale (3) (22) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (6) scale (3) (22) (by decide) (by decide))
    (eq_smul_div (12) scale (3) (11) (by decide) (by decide))
    (eq_smul_div (6) scale (3) (22) (by decide) (by decide))
    (eq_smul_div (6) scale (3) (22) (by decide) (by decide))
    (eq_smul_div (6) scale (3) (22) (by decide) (by decide))
    (eq_smul_div (6) scale (3) (22) (by decide) (by decide))
    (eq_smul_div (12) scale (3) (11) (by decide) (by decide))
    (eq_smul_div (6) scale (3) (22) (by decide) (by decide))

theorem AZ_scale_7 : toVec (AZ 7) = (scale : ℚ) • ACell7_3 :=
  toVec_eq_smul10 (AZ 7) scale ACell7_3
    (eq_smul_zero scale)
    (eq_smul_div (-6) scale (-3) (22) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (6) scale (3) (22) (by decide) (by decide))
    (eq_smul_div (6) scale (3) (22) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (-6) scale (-3) (22) (by decide) (by decide))
    (eq_smul_zero scale)

theorem AZ_scale_8 : toVec (AZ 8) = (scale : ℚ) • ACell8_3 :=
  toVec_eq_smul10 (AZ 8) scale ACell8_3
    (eq_smul_div (6) scale (3) (22) (by decide) (by decide))
    (eq_smul_div (6) scale (3) (22) (by decide) (by decide))
    (eq_smul_div (6) scale (3) (22) (by decide) (by decide))
    (eq_smul_div (6) scale (3) (22) (by decide) (by decide))
    (eq_smul_div (6) scale (3) (22) (by decide) (by decide))
    (eq_smul_div (6) scale (3) (22) (by decide) (by decide))
    (eq_smul_div (6) scale (3) (22) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (12) scale (3) (11) (by decide) (by decide))
    (eq_smul_div (12) scale (3) (11) (by decide) (by decide))

theorem AZ_scale_9 : toVec (AZ 9) = (scale : ℚ) • ACell9_3 :=
  toVec_eq_smul10 (AZ 9) scale ACell9_3
    (eq_smul_div (6) scale (3) (22) (by decide) (by decide))
    (eq_smul_div (6) scale (3) (22) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (6) scale (3) (22) (by decide) (by decide))
    (eq_smul_div (6) scale (3) (22) (by decide) (by decide))
    (eq_smul_div (12) scale (3) (11) (by decide) (by decide))
    (eq_smul_div (6) scale (3) (22) (by decide) (by decide))
    (eq_smul_div (12) scale (3) (11) (by decide) (by decide))
    (eq_smul_div (6) scale (3) (22) (by decide) (by decide))
    (eq_smul_div (6) scale (3) (22) (by decide) (by decide))

theorem AZ_scale_10 : toVec (AZ 10) = (scale : ℚ) • ACell10_3 :=
  toVec_eq_smul10 (AZ 10) scale ACell10_3
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (4) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (4) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (12) scale (3) (11) (by decide) (by decide))
    (eq_smul_div (4) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (4) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)

theorem AZ_scale_11 : toVec (AZ 11) = (scale : ℚ) • ACell11_3 :=
  toVec_eq_smul10 (AZ 11) scale ACell11_3
    (eq_smul_div (4) scale (1) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (4) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (4) scale (1) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (4) scale (1) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (12) scale (3) (11) (by decide) (by decide))

theorem AZ_scale_12 : toVec (AZ 12) = (scale : ℚ) • ACell12_3 :=
  toVec_eq_smul10 (AZ 12) scale ACell12_3
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (4) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))

theorem AZ_scale_13 : toVec (AZ 13) = (scale : ℚ) • ACell13_3 :=
  toVec_eq_smul10 (AZ 13) scale ACell13_3
    (eq_smul_div (48) scale (12) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))

theorem AZ_scale_14 : toVec (AZ 14) = (scale : ℚ) • ACell14_3 :=
  toVec_eq_smul10 (AZ 14) scale ACell14_3
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (4) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (4) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (4) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (12) scale (3) (11) (by decide) (by decide))
    (eq_smul_div (4) scale (1) (11) (by decide) (by decide))
    (eq_smul_zero scale)

theorem AZ_scale_15 : toVec (AZ 15) = (scale : ℚ) • ACell15_3 :=
  toVec_eq_smul10 (AZ 15) scale ACell15_3
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (-6) scale (-3) (22) (by decide) (by decide))
    (eq_smul_div (6) scale (3) (22) (by decide) (by decide))
    (eq_smul_div (6) scale (3) (22) (by decide) (by decide))
    (eq_smul_div (-6) scale (-3) (22) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)

theorem AZ_scale_16 : toVec (AZ 16) = (scale : ℚ) • ACell16_3 :=
  toVec_eq_smul10 (AZ 16) scale ACell16_3
    (eq_smul_div (-6) scale (-3) (22) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (-6) scale (-3) (22) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (6) scale (3) (22) (by decide) (by decide))
    (eq_smul_div (6) scale (3) (22) (by decide) (by decide))
    (eq_smul_zero scale)

theorem AZ_scale_17 : toVec (AZ 17) = (scale : ℚ) • ACell17_3 :=
  toVec_eq_smul10 (AZ 17) scale ACell17_3
    (eq_smul_zero scale)
    (eq_smul_div (-6) scale (-3) (22) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (6) scale (3) (22) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (6) scale (3) (22) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (-6) scale (-3) (22) (by decide) (by decide))

theorem AZ_scale_18 : toVec (AZ 18) = (scale : ℚ) • ACell18_3 :=
  toVec_eq_smul10 (AZ 18) scale ACell18_3
    (eq_smul_zero scale)
    (eq_smul_div (-6) scale (-3) (22) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (6) scale (3) (22) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (6) scale (3) (22) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-6) scale (-3) (22) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)

theorem AZ_scale_19 : toVec (AZ 19) = (scale : ℚ) • ACell19_3 :=
  toVec_eq_smul10 (AZ 19) scale ACell19_3
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (-6) scale (-3) (22) (by decide) (by decide))
    (eq_smul_div (6) scale (3) (22) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (6) scale (3) (22) (by decide) (by decide))
    (eq_smul_div (-6) scale (-3) (22) (by decide) (by decide))

theorem AZ_scale (k : Fin 20) :
    toVec (AZ k) = (scale : ℚ) • AVec k (3 : Fin 10) :=
  forall_fin20 (P := fun k => toVec (AZ k) = (scale : ℚ) • AVec k (3 : Fin 10))
    AZ_scale_0 AZ_scale_1 AZ_scale_2 AZ_scale_3 AZ_scale_4 AZ_scale_5 AZ_scale_6 AZ_scale_7 AZ_scale_8 AZ_scale_9 AZ_scale_10 AZ_scale_11 AZ_scale_12 AZ_scale_13 AZ_scale_14 AZ_scale_15 AZ_scale_16 AZ_scale_17 AZ_scale_18 AZ_scale_19 k

theorem entry_eq :
    (matrixMul XVec AVec) (6 : Fin 10) (3 : Fin 10) =
      ![0, 0, 0, 0, 0, 0, 0, 0, 0, 0] := by
  unfold matrixMul
  refine sum_mul_eq_of_scaled scale scale_ne_zero
    (fun k => XVec (6 : Fin 10) k)
    (fun k => AVec k (3 : Fin 10))
    XZ AZ XZ_scale AZ_scale entryZ rfl _ ?_
  rw [entryZ_eq, toVec_zeroZ_smul, vec_zero_eq]

theorem entry_eq_matrixOne :
    (matrixMul XVec AVec) (6 : Fin 10) (3 : Fin 10) =
      matrixOne (Fin 10) (6 : Fin 10) (3 : Fin 10) :=
  entry_eq.trans (matrixOne_off10 (6 : Fin 10) (3 : Fin 10) (by decide)).symm

end V14Formalization.D12PiecePASplitEntry6_3


namespace V14Formalization.D12PiecePASplitEntry6_4
open D12CyclotomicVec D12CyclotomicVecZ D12PiecePAData
def payloadSha256 : String := "76c6196f29afe1a8398af99502447f48ebeed4bcb3805fc5dbec693940bc04b0"

def scale : ℤ := 44

def XZ (k : Fin 20) : VecZ :=
  match k.val with
  | 0 => #v[-5, -47, -14, -20, -48, -22, -43, -18, -23, -46]
  | 1 => #v[13, 31, -8, 20, 26, 9, 28, 26, 6, 36]
  | 2 => #v[-9, -29, -20, -16, -17, -16, -8, -4, -7, -17]
  | 3 => #v[6, -12, 14, 12, -2, 8, -16, -4, -6, -22]
  | 4 => #v[-1, -26, -12, 15, -4, -19, -5, 14, -14, -25]
  | 5 => #v[8, 12, -14, 14, 2, -18, 6, 14, -6, 26]
  | 6 => #v[-32, -54, -12, -32, -36, -16, -38, -16, 0, -50]
  | 7 => #v[-10, -4, 0, -34, -10, 38, -8, -2, 32, 20]
  | 8 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  | 9 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  | 10 => #v[11, 0, -11, 0, -11, -22, -22, -11, 0, -11]
  | 11 => #v[11, 0, -11, 0, 11, 0, 0, 11, 0, -11]
  | 12 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  | 13 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  | 14 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  | 15 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  | 16 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  | 17 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  | 18 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  | 19 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  | _ => zeroZ

def AZ (k : Fin 20) : VecZ :=
  match k.val with
  | 0 => #v[-4, 8, -4, 0, -4, 0, 4, 4, 0, -4]
  | 1 => #v[-4, -12, -8, -8, -12, -12, -8, -8, -12, -4]
  | 2 => #v[-8, -8, -4, 4, -4, -8, -8, 0, -4, -4]
  | 3 => #v[4, -4, 8, -4, 4, 0, -4, 0, 0, -4]
  | 4 => #v[-52, -8, -8, -8, 0, -4, -4, 4, -4, -4]
  | 5 => #v[0, 0, 0, -6, 0, 6, 0, 6, 0, -6]
  | 6 => #v[0, -6, 0, 0, 6, 0, 6, 0, 0, -6]
  | 7 => #v[0, -6, 6, 0, 0, 0, 6, -6, 0, 0]
  | 8 => #v[-6, -6, -12, -12, -6, -6, 0, -6, -6, -6]
  | 9 => #v[0, 0, 0, 0, 6, -6, -6, 6, 0, 0]
  | 10 => #v[0, -4, -4, 0, 0, -4, 4, 8, 4, -4]
  | 11 => #v[4, -4, 8, -4, 4, 0, -4, 0, 0, -4]
  | 12 => #v[0, 8, 0, 0, 4, -4, -4, -4, -4, 4]
  | 13 => #v[4, -4, -4, 0, 8, 0, -4, -4, 4, 0]
  | 14 => #v[56, 0, 4, 0, 4, 8, 8, 4, 0, 4]
  | 15 => #v[0, 6, 0, 0, 0, 6, 0, 0, -6, -6]
  | 16 => #v[0, 0, 0, -6, 6, 0, 0, 0, 6, -6]
  | 17 => #v[0, 0, 6, -6, -6, 6, 0, 0, 0, 0]
  | 18 => #v[0, 6, 0, 0, 6, 0, 0, -6, 0, -6]
  | 19 => #v[-6, 0, 6, 0, 0, 0, 0, 6, 0, -6]
  | _ => zeroZ

def entryZ : VecZ := sumFin (fun k => mulZ (XZ k) (AZ k))

theorem entryZ_eq : entryZ = zeroZ :=
  eq_of_eqZ (by decide +kernel)

theorem scale_ne_zero : scale ≠ 0 := by
  decide

theorem XZ_scale_0 : toVec (XZ 0) = (scale : ℚ) • XCell6_0 :=
  toVec_eq_smul10 (XZ 0) scale XCell6_0
    (eq_smul_div (-5) scale (-5) (44) (by decide) (by decide))
    (eq_smul_div (-47) scale (-47) (44) (by decide) (by decide))
    (eq_smul_div (-14) scale (-7) (22) (by decide) (by decide))
    (eq_smul_div (-20) scale (-5) (11) (by decide) (by decide))
    (eq_smul_div (-48) scale (-12) (11) (by decide) (by decide))
    (eq_smul_div (-22) scale (-1) (2) (by decide) (by decide))
    (eq_smul_div (-43) scale (-43) (44) (by decide) (by decide))
    (eq_smul_div (-18) scale (-9) (22) (by decide) (by decide))
    (eq_smul_div (-23) scale (-23) (44) (by decide) (by decide))
    (eq_smul_div (-46) scale (-23) (22) (by decide) (by decide))

theorem XZ_scale_1 : toVec (XZ 1) = (scale : ℚ) • XCell6_1 :=
  toVec_eq_smul10 (XZ 1) scale XCell6_1
    (eq_smul_div (13) scale (13) (44) (by decide) (by decide))
    (eq_smul_div (31) scale (31) (44) (by decide) (by decide))
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (20) scale (5) (11) (by decide) (by decide))
    (eq_smul_div (26) scale (13) (22) (by decide) (by decide))
    (eq_smul_div (9) scale (9) (44) (by decide) (by decide))
    (eq_smul_div (28) scale (7) (11) (by decide) (by decide))
    (eq_smul_div (26) scale (13) (22) (by decide) (by decide))
    (eq_smul_div (6) scale (3) (22) (by decide) (by decide))
    (eq_smul_div (36) scale (9) (11) (by decide) (by decide))

theorem XZ_scale_2 : toVec (XZ 2) = (scale : ℚ) • XCell6_2 :=
  toVec_eq_smul10 (XZ 2) scale XCell6_2
    (eq_smul_div (-9) scale (-9) (44) (by decide) (by decide))
    (eq_smul_div (-29) scale (-29) (44) (by decide) (by decide))
    (eq_smul_div (-20) scale (-5) (11) (by decide) (by decide))
    (eq_smul_div (-16) scale (-4) (11) (by decide) (by decide))
    (eq_smul_div (-17) scale (-17) (44) (by decide) (by decide))
    (eq_smul_div (-16) scale (-4) (11) (by decide) (by decide))
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-7) scale (-7) (44) (by decide) (by decide))
    (eq_smul_div (-17) scale (-17) (44) (by decide) (by decide))

theorem XZ_scale_3 : toVec (XZ 3) = (scale : ℚ) • XCell6_3 :=
  toVec_eq_smul10 (XZ 3) scale XCell6_3
    (eq_smul_div (6) scale (3) (22) (by decide) (by decide))
    (eq_smul_div (-12) scale (-3) (11) (by decide) (by decide))
    (eq_smul_div (14) scale (7) (22) (by decide) (by decide))
    (eq_smul_div (12) scale (3) (11) (by decide) (by decide))
    (eq_smul_div (-2) scale (-1) (22) (by decide) (by decide))
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (-16) scale (-4) (11) (by decide) (by decide))
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-6) scale (-3) (22) (by decide) (by decide))
    (eq_smul_div (-22) scale (-1) (2) (by decide) (by decide))

theorem XZ_scale_4 : toVec (XZ 4) = (scale : ℚ) • XCell6_4 :=
  toVec_eq_smul10 (XZ 4) scale XCell6_4
    (eq_smul_div (-1) scale (-1) (44) (by decide) (by decide))
    (eq_smul_div (-26) scale (-13) (22) (by decide) (by decide))
    (eq_smul_div (-12) scale (-3) (11) (by decide) (by decide))
    (eq_smul_div (15) scale (15) (44) (by decide) (by decide))
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-19) scale (-19) (44) (by decide) (by decide))
    (eq_smul_div (-5) scale (-5) (44) (by decide) (by decide))
    (eq_smul_div (14) scale (7) (22) (by decide) (by decide))
    (eq_smul_div (-14) scale (-7) (22) (by decide) (by decide))
    (eq_smul_div (-25) scale (-25) (44) (by decide) (by decide))

theorem XZ_scale_5 : toVec (XZ 5) = (scale : ℚ) • XCell6_5 :=
  toVec_eq_smul10 (XZ 5) scale XCell6_5
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (12) scale (3) (11) (by decide) (by decide))
    (eq_smul_div (-14) scale (-7) (22) (by decide) (by decide))
    (eq_smul_div (14) scale (7) (22) (by decide) (by decide))
    (eq_smul_div (2) scale (1) (22) (by decide) (by decide))
    (eq_smul_div (-18) scale (-9) (22) (by decide) (by decide))
    (eq_smul_div (6) scale (3) (22) (by decide) (by decide))
    (eq_smul_div (14) scale (7) (22) (by decide) (by decide))
    (eq_smul_div (-6) scale (-3) (22) (by decide) (by decide))
    (eq_smul_div (26) scale (13) (22) (by decide) (by decide))

theorem XZ_scale_6 : toVec (XZ 6) = (scale : ℚ) • XCell6_6 :=
  toVec_eq_smul10 (XZ 6) scale XCell6_6
    (eq_smul_div (-32) scale (-8) (11) (by decide) (by decide))
    (eq_smul_div (-54) scale (-27) (22) (by decide) (by decide))
    (eq_smul_div (-12) scale (-3) (11) (by decide) (by decide))
    (eq_smul_div (-32) scale (-8) (11) (by decide) (by decide))
    (eq_smul_div (-36) scale (-9) (11) (by decide) (by decide))
    (eq_smul_div (-16) scale (-4) (11) (by decide) (by decide))
    (eq_smul_div (-38) scale (-19) (22) (by decide) (by decide))
    (eq_smul_div (-16) scale (-4) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-50) scale (-25) (22) (by decide) (by decide))

theorem XZ_scale_7 : toVec (XZ 7) = (scale : ℚ) • XCell6_7 :=
  toVec_eq_smul10 (XZ 7) scale XCell6_7
    (eq_smul_div (-10) scale (-5) (22) (by decide) (by decide))
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-34) scale (-17) (22) (by decide) (by decide))
    (eq_smul_div (-10) scale (-5) (22) (by decide) (by decide))
    (eq_smul_div (38) scale (19) (22) (by decide) (by decide))
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-2) scale (-1) (22) (by decide) (by decide))
    (eq_smul_div (32) scale (8) (11) (by decide) (by decide))
    (eq_smul_div (20) scale (5) (11) (by decide) (by decide))

theorem XZ_scale_8 : toVec (XZ 8) = (scale : ℚ) • XCell6_8 :=
  toVec_eq_smul10 (XZ 8) scale XCell6_8
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)

theorem XZ_scale_9 : toVec (XZ 9) = (scale : ℚ) • XCell6_9 :=
  toVec_eq_smul10 (XZ 9) scale XCell6_9
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)

theorem XZ_scale_10 : toVec (XZ 10) = (scale : ℚ) • XCell6_10 :=
  toVec_eq_smul10 (XZ 10) scale XCell6_10
    (eq_smul_div (11) scale (1) (4) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-11) scale (-1) (4) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-11) scale (-1) (4) (by decide) (by decide))
    (eq_smul_div (-22) scale (-1) (2) (by decide) (by decide))
    (eq_smul_div (-22) scale (-1) (2) (by decide) (by decide))
    (eq_smul_div (-11) scale (-1) (4) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-11) scale (-1) (4) (by decide) (by decide))

theorem XZ_scale_11 : toVec (XZ 11) = (scale : ℚ) • XCell6_11 :=
  toVec_eq_smul10 (XZ 11) scale XCell6_11
    (eq_smul_div (11) scale (1) (4) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-11) scale (-1) (4) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (11) scale (1) (4) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (11) scale (1) (4) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-11) scale (-1) (4) (by decide) (by decide))

theorem XZ_scale_12 : toVec (XZ 12) = (scale : ℚ) • XCell6_12 :=
  toVec_eq_smul10 (XZ 12) scale XCell6_12
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)

theorem XZ_scale_13 : toVec (XZ 13) = (scale : ℚ) • XCell6_13 :=
  toVec_eq_smul10 (XZ 13) scale XCell6_13
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)

theorem XZ_scale_14 : toVec (XZ 14) = (scale : ℚ) • XCell6_14 :=
  toVec_eq_smul10 (XZ 14) scale XCell6_14
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)

theorem XZ_scale_15 : toVec (XZ 15) = (scale : ℚ) • XCell6_15 :=
  toVec_eq_smul10 (XZ 15) scale XCell6_15
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)

theorem XZ_scale_16 : toVec (XZ 16) = (scale : ℚ) • XCell6_16 :=
  toVec_eq_smul10 (XZ 16) scale XCell6_16
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)

theorem XZ_scale_17 : toVec (XZ 17) = (scale : ℚ) • XCell6_17 :=
  toVec_eq_smul10 (XZ 17) scale XCell6_17
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)

theorem XZ_scale_18 : toVec (XZ 18) = (scale : ℚ) • XCell6_18 :=
  toVec_eq_smul10 (XZ 18) scale XCell6_18
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)

theorem XZ_scale_19 : toVec (XZ 19) = (scale : ℚ) • XCell6_19 :=
  toVec_eq_smul10 (XZ 19) scale XCell6_19
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)

theorem XZ_scale (k : Fin 20) :
    toVec (XZ k) = (scale : ℚ) • XVec (6 : Fin 10) k :=
  forall_fin20 (P := fun k => toVec (XZ k) = (scale : ℚ) • XVec (6 : Fin 10) k)
    XZ_scale_0 XZ_scale_1 XZ_scale_2 XZ_scale_3 XZ_scale_4 XZ_scale_5 XZ_scale_6 XZ_scale_7 XZ_scale_8 XZ_scale_9 XZ_scale_10 XZ_scale_11 XZ_scale_12 XZ_scale_13 XZ_scale_14 XZ_scale_15 XZ_scale_16 XZ_scale_17 XZ_scale_18 XZ_scale_19 k

theorem AZ_scale_0 : toVec (AZ 0) = (scale : ℚ) • ACell0_4 :=
  toVec_eq_smul10 (AZ 0) scale ACell0_4
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (4) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (4) scale (1) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))

theorem AZ_scale_1 : toVec (AZ 1) = (scale : ℚ) • ACell1_4 :=
  toVec_eq_smul10 (AZ 1) scale ACell1_4
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-12) scale (-3) (11) (by decide) (by decide))
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-12) scale (-3) (11) (by decide) (by decide))
    (eq_smul_div (-12) scale (-3) (11) (by decide) (by decide))
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-12) scale (-3) (11) (by decide) (by decide))
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))

theorem AZ_scale_2 : toVec (AZ 2) = (scale : ℚ) • ACell2_4 :=
  toVec_eq_smul10 (AZ 2) scale ACell2_4
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (4) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))

theorem AZ_scale_3 : toVec (AZ 3) = (scale : ℚ) • ACell3_4 :=
  toVec_eq_smul10 (AZ 3) scale ACell3_4
    (eq_smul_div (4) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (4) scale (1) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))

theorem AZ_scale_4 : toVec (AZ 4) = (scale : ℚ) • ACell4_4 :=
  toVec_eq_smul10 (AZ 4) scale ACell4_4
    (eq_smul_div (-52) scale (-13) (11) (by decide) (by decide))
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (4) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))

theorem AZ_scale_5 : toVec (AZ 5) = (scale : ℚ) • ACell5_4 :=
  toVec_eq_smul10 (AZ 5) scale ACell5_4
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (-6) scale (-3) (22) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (6) scale (3) (22) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (6) scale (3) (22) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-6) scale (-3) (22) (by decide) (by decide))

theorem AZ_scale_6 : toVec (AZ 6) = (scale : ℚ) • ACell6_4 :=
  toVec_eq_smul10 (AZ 6) scale ACell6_4
    (eq_smul_zero scale)
    (eq_smul_div (-6) scale (-3) (22) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (6) scale (3) (22) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (6) scale (3) (22) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (-6) scale (-3) (22) (by decide) (by decide))

theorem AZ_scale_7 : toVec (AZ 7) = (scale : ℚ) • ACell7_4 :=
  toVec_eq_smul10 (AZ 7) scale ACell7_4
    (eq_smul_zero scale)
    (eq_smul_div (-6) scale (-3) (22) (by decide) (by decide))
    (eq_smul_div (6) scale (3) (22) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (6) scale (3) (22) (by decide) (by decide))
    (eq_smul_div (-6) scale (-3) (22) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)

theorem AZ_scale_8 : toVec (AZ 8) = (scale : ℚ) • ACell8_4 :=
  toVec_eq_smul10 (AZ 8) scale ACell8_4
    (eq_smul_div (-6) scale (-3) (22) (by decide) (by decide))
    (eq_smul_div (-6) scale (-3) (22) (by decide) (by decide))
    (eq_smul_div (-12) scale (-3) (11) (by decide) (by decide))
    (eq_smul_div (-12) scale (-3) (11) (by decide) (by decide))
    (eq_smul_div (-6) scale (-3) (22) (by decide) (by decide))
    (eq_smul_div (-6) scale (-3) (22) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-6) scale (-3) (22) (by decide) (by decide))
    (eq_smul_div (-6) scale (-3) (22) (by decide) (by decide))
    (eq_smul_div (-6) scale (-3) (22) (by decide) (by decide))

theorem AZ_scale_9 : toVec (AZ 9) = (scale : ℚ) • ACell9_4 :=
  toVec_eq_smul10 (AZ 9) scale ACell9_4
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (6) scale (3) (22) (by decide) (by decide))
    (eq_smul_div (-6) scale (-3) (22) (by decide) (by decide))
    (eq_smul_div (-6) scale (-3) (22) (by decide) (by decide))
    (eq_smul_div (6) scale (3) (22) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)

theorem AZ_scale_10 : toVec (AZ 10) = (scale : ℚ) • ACell10_4 :=
  toVec_eq_smul10 (AZ 10) scale ACell10_4
    (eq_smul_zero scale)
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (4) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (4) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))

theorem AZ_scale_11 : toVec (AZ 11) = (scale : ℚ) • ACell11_4 :=
  toVec_eq_smul10 (AZ 11) scale ACell11_4
    (eq_smul_div (4) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (4) scale (1) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))

theorem AZ_scale_12 : toVec (AZ 12) = (scale : ℚ) • ACell12_4 :=
  toVec_eq_smul10 (AZ 12) scale ACell12_4
    (eq_smul_zero scale)
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (4) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (4) scale (1) (11) (by decide) (by decide))

theorem AZ_scale_13 : toVec (AZ 13) = (scale : ℚ) • ACell13_4 :=
  toVec_eq_smul10 (AZ 13) scale ACell13_4
    (eq_smul_div (4) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (4) scale (1) (11) (by decide) (by decide))
    (eq_smul_zero scale)

theorem AZ_scale_14 : toVec (AZ 14) = (scale : ℚ) • ACell14_4 :=
  toVec_eq_smul10 (AZ 14) scale ACell14_4
    (eq_smul_div (56) scale (14) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (4) scale (1) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (4) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (4) scale (1) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (4) scale (1) (11) (by decide) (by decide))

theorem AZ_scale_15 : toVec (AZ 15) = (scale : ℚ) • ACell15_4 :=
  toVec_eq_smul10 (AZ 15) scale ACell15_4
    (eq_smul_zero scale)
    (eq_smul_div (6) scale (3) (22) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (6) scale (3) (22) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (-6) scale (-3) (22) (by decide) (by decide))
    (eq_smul_div (-6) scale (-3) (22) (by decide) (by decide))

theorem AZ_scale_16 : toVec (AZ 16) = (scale : ℚ) • ACell16_4 :=
  toVec_eq_smul10 (AZ 16) scale ACell16_4
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (-6) scale (-3) (22) (by decide) (by decide))
    (eq_smul_div (6) scale (3) (22) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (6) scale (3) (22) (by decide) (by decide))
    (eq_smul_div (-6) scale (-3) (22) (by decide) (by decide))

theorem AZ_scale_17 : toVec (AZ 17) = (scale : ℚ) • ACell17_4 :=
  toVec_eq_smul10 (AZ 17) scale ACell17_4
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (6) scale (3) (22) (by decide) (by decide))
    (eq_smul_div (-6) scale (-3) (22) (by decide) (by decide))
    (eq_smul_div (-6) scale (-3) (22) (by decide) (by decide))
    (eq_smul_div (6) scale (3) (22) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)

theorem AZ_scale_18 : toVec (AZ 18) = (scale : ℚ) • ACell18_4 :=
  toVec_eq_smul10 (AZ 18) scale ACell18_4
    (eq_smul_zero scale)
    (eq_smul_div (6) scale (3) (22) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (6) scale (3) (22) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (-6) scale (-3) (22) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-6) scale (-3) (22) (by decide) (by decide))

theorem AZ_scale_19 : toVec (AZ 19) = (scale : ℚ) • ACell19_4 :=
  toVec_eq_smul10 (AZ 19) scale ACell19_4
    (eq_smul_div (-6) scale (-3) (22) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (6) scale (3) (22) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (6) scale (3) (22) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-6) scale (-3) (22) (by decide) (by decide))

theorem AZ_scale (k : Fin 20) :
    toVec (AZ k) = (scale : ℚ) • AVec k (4 : Fin 10) :=
  forall_fin20 (P := fun k => toVec (AZ k) = (scale : ℚ) • AVec k (4 : Fin 10))
    AZ_scale_0 AZ_scale_1 AZ_scale_2 AZ_scale_3 AZ_scale_4 AZ_scale_5 AZ_scale_6 AZ_scale_7 AZ_scale_8 AZ_scale_9 AZ_scale_10 AZ_scale_11 AZ_scale_12 AZ_scale_13 AZ_scale_14 AZ_scale_15 AZ_scale_16 AZ_scale_17 AZ_scale_18 AZ_scale_19 k

theorem entry_eq :
    (matrixMul XVec AVec) (6 : Fin 10) (4 : Fin 10) =
      ![0, 0, 0, 0, 0, 0, 0, 0, 0, 0] := by
  unfold matrixMul
  refine sum_mul_eq_of_scaled scale scale_ne_zero
    (fun k => XVec (6 : Fin 10) k)
    (fun k => AVec k (4 : Fin 10))
    XZ AZ XZ_scale AZ_scale entryZ rfl _ ?_
  rw [entryZ_eq, toVec_zeroZ_smul, vec_zero_eq]

theorem entry_eq_matrixOne :
    (matrixMul XVec AVec) (6 : Fin 10) (4 : Fin 10) =
      matrixOne (Fin 10) (6 : Fin 10) (4 : Fin 10) :=
  entry_eq.trans (matrixOne_off10 (6 : Fin 10) (4 : Fin 10) (by decide)).symm

end V14Formalization.D12PiecePASplitEntry6_4


namespace V14Formalization.D12PiecePASplitEntry6_5
open D12CyclotomicVec D12CyclotomicVecZ D12PiecePAData
def payloadSha256 : String := "76c6196f29afe1a8398af99502447f48ebeed4bcb3805fc5dbec693940bc04b0"

def scale : ℤ := 44

def XZ (k : Fin 20) : VecZ :=
  match k.val with
  | 0 => #v[-5, -47, -14, -20, -48, -22, -43, -18, -23, -46]
  | 1 => #v[13, 31, -8, 20, 26, 9, 28, 26, 6, 36]
  | 2 => #v[-9, -29, -20, -16, -17, -16, -8, -4, -7, -17]
  | 3 => #v[6, -12, 14, 12, -2, 8, -16, -4, -6, -22]
  | 4 => #v[-1, -26, -12, 15, -4, -19, -5, 14, -14, -25]
  | 5 => #v[8, 12, -14, 14, 2, -18, 6, 14, -6, 26]
  | 6 => #v[-32, -54, -12, -32, -36, -16, -38, -16, 0, -50]
  | 7 => #v[-10, -4, 0, -34, -10, 38, -8, -2, 32, 20]
  | 8 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  | 9 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  | 10 => #v[11, 0, -11, 0, -11, -22, -22, -11, 0, -11]
  | 11 => #v[11, 0, -11, 0, 11, 0, 0, 11, 0, -11]
  | 12 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  | 13 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  | 14 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  | 15 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  | 16 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  | 17 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  | 18 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  | 19 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  | _ => zeroZ

def AZ (k : Fin 20) : VecZ :=
  match k.val with
  | 0 => #v[0, 0, 8, 0, 0, -8, -8, 0, 0, 8]
  | 1 => #v[8, 8, 16, 8, 8, 16, 8, 8, 0, 8]
  | 2 => #v[0, 0, 0, 0, 0, 0, -8, 8, 8, -8]
  | 3 => #v[8, 8, 8, 0, 16, 8, 8, 8, 8, 16]
  | 4 => #v[0, 0, 0, -8, 0, 8, 0, 8, 0, -8]
  | 5 => #v[-44, 4, 4, 0, 8, 12, 8, 0, 4, 4]
  | 6 => #v[-4, 4, 4, 0, -8, 0, 4, 4, -4, 0]
  | 7 => #v[-8, -4, -4, -12, -4, -4, -8, 0, 0, 0]
  | 8 => #v[-4, 0, 0, -4, 0, 4, -4, 8, -4, 4]
  | 9 => #v[12, 8, 12, 8, 4, 4, 8, 12, 8, 12]
  | 10 => #v[8, 0, 0, -8, 0, -8, 0, 0, 8, 0]
  | 11 => #v[0, -8, 8, 0, 0, 0, 0, 8, -8, 0]
  | 12 => #v[-8, -16, -8, -8, -8, -8, -16, -8, 0, -8]
  | 13 => #v[0, 0, 0, 0, 0, -8, 8, 8, -8, 0]
  | 14 => #v[-8, -8, -16, -16, -8, -8, 0, -8, -8, -8]
  | 15 => #v[56, 0, 8, 4, 0, 4, 4, 0, 4, 8]
  | 16 => #v[-8, -4, -4, -12, -4, -4, -8, 0, 0, 0]
  | 17 => #v[-4, -4, 0, 4, 0, 4, -8, 4, 0, 4]
  | 18 => #v[0, 4, -4, -4, 0, 8, 0, -4, -4, 4]
  | 19 => #v[0, 4, 4, 0, 0, 4, -4, -8, -4, 4]
  | _ => zeroZ

def entryZ : VecZ := sumFin (fun k => mulZ (XZ k) (AZ k))

theorem entryZ_eq : entryZ = zeroZ :=
  eq_of_eqZ (by decide +kernel)

theorem scale_ne_zero : scale ≠ 0 := by
  decide

theorem XZ_scale_0 : toVec (XZ 0) = (scale : ℚ) • XCell6_0 :=
  toVec_eq_smul10 (XZ 0) scale XCell6_0
    (eq_smul_div (-5) scale (-5) (44) (by decide) (by decide))
    (eq_smul_div (-47) scale (-47) (44) (by decide) (by decide))
    (eq_smul_div (-14) scale (-7) (22) (by decide) (by decide))
    (eq_smul_div (-20) scale (-5) (11) (by decide) (by decide))
    (eq_smul_div (-48) scale (-12) (11) (by decide) (by decide))
    (eq_smul_div (-22) scale (-1) (2) (by decide) (by decide))
    (eq_smul_div (-43) scale (-43) (44) (by decide) (by decide))
    (eq_smul_div (-18) scale (-9) (22) (by decide) (by decide))
    (eq_smul_div (-23) scale (-23) (44) (by decide) (by decide))
    (eq_smul_div (-46) scale (-23) (22) (by decide) (by decide))

theorem XZ_scale_1 : toVec (XZ 1) = (scale : ℚ) • XCell6_1 :=
  toVec_eq_smul10 (XZ 1) scale XCell6_1
    (eq_smul_div (13) scale (13) (44) (by decide) (by decide))
    (eq_smul_div (31) scale (31) (44) (by decide) (by decide))
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (20) scale (5) (11) (by decide) (by decide))
    (eq_smul_div (26) scale (13) (22) (by decide) (by decide))
    (eq_smul_div (9) scale (9) (44) (by decide) (by decide))
    (eq_smul_div (28) scale (7) (11) (by decide) (by decide))
    (eq_smul_div (26) scale (13) (22) (by decide) (by decide))
    (eq_smul_div (6) scale (3) (22) (by decide) (by decide))
    (eq_smul_div (36) scale (9) (11) (by decide) (by decide))

theorem XZ_scale_2 : toVec (XZ 2) = (scale : ℚ) • XCell6_2 :=
  toVec_eq_smul10 (XZ 2) scale XCell6_2
    (eq_smul_div (-9) scale (-9) (44) (by decide) (by decide))
    (eq_smul_div (-29) scale (-29) (44) (by decide) (by decide))
    (eq_smul_div (-20) scale (-5) (11) (by decide) (by decide))
    (eq_smul_div (-16) scale (-4) (11) (by decide) (by decide))
    (eq_smul_div (-17) scale (-17) (44) (by decide) (by decide))
    (eq_smul_div (-16) scale (-4) (11) (by decide) (by decide))
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-7) scale (-7) (44) (by decide) (by decide))
    (eq_smul_div (-17) scale (-17) (44) (by decide) (by decide))

theorem XZ_scale_3 : toVec (XZ 3) = (scale : ℚ) • XCell6_3 :=
  toVec_eq_smul10 (XZ 3) scale XCell6_3
    (eq_smul_div (6) scale (3) (22) (by decide) (by decide))
    (eq_smul_div (-12) scale (-3) (11) (by decide) (by decide))
    (eq_smul_div (14) scale (7) (22) (by decide) (by decide))
    (eq_smul_div (12) scale (3) (11) (by decide) (by decide))
    (eq_smul_div (-2) scale (-1) (22) (by decide) (by decide))
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (-16) scale (-4) (11) (by decide) (by decide))
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-6) scale (-3) (22) (by decide) (by decide))
    (eq_smul_div (-22) scale (-1) (2) (by decide) (by decide))

theorem XZ_scale_4 : toVec (XZ 4) = (scale : ℚ) • XCell6_4 :=
  toVec_eq_smul10 (XZ 4) scale XCell6_4
    (eq_smul_div (-1) scale (-1) (44) (by decide) (by decide))
    (eq_smul_div (-26) scale (-13) (22) (by decide) (by decide))
    (eq_smul_div (-12) scale (-3) (11) (by decide) (by decide))
    (eq_smul_div (15) scale (15) (44) (by decide) (by decide))
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-19) scale (-19) (44) (by decide) (by decide))
    (eq_smul_div (-5) scale (-5) (44) (by decide) (by decide))
    (eq_smul_div (14) scale (7) (22) (by decide) (by decide))
    (eq_smul_div (-14) scale (-7) (22) (by decide) (by decide))
    (eq_smul_div (-25) scale (-25) (44) (by decide) (by decide))

theorem XZ_scale_5 : toVec (XZ 5) = (scale : ℚ) • XCell6_5 :=
  toVec_eq_smul10 (XZ 5) scale XCell6_5
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (12) scale (3) (11) (by decide) (by decide))
    (eq_smul_div (-14) scale (-7) (22) (by decide) (by decide))
    (eq_smul_div (14) scale (7) (22) (by decide) (by decide))
    (eq_smul_div (2) scale (1) (22) (by decide) (by decide))
    (eq_smul_div (-18) scale (-9) (22) (by decide) (by decide))
    (eq_smul_div (6) scale (3) (22) (by decide) (by decide))
    (eq_smul_div (14) scale (7) (22) (by decide) (by decide))
    (eq_smul_div (-6) scale (-3) (22) (by decide) (by decide))
    (eq_smul_div (26) scale (13) (22) (by decide) (by decide))

theorem XZ_scale_6 : toVec (XZ 6) = (scale : ℚ) • XCell6_6 :=
  toVec_eq_smul10 (XZ 6) scale XCell6_6
    (eq_smul_div (-32) scale (-8) (11) (by decide) (by decide))
    (eq_smul_div (-54) scale (-27) (22) (by decide) (by decide))
    (eq_smul_div (-12) scale (-3) (11) (by decide) (by decide))
    (eq_smul_div (-32) scale (-8) (11) (by decide) (by decide))
    (eq_smul_div (-36) scale (-9) (11) (by decide) (by decide))
    (eq_smul_div (-16) scale (-4) (11) (by decide) (by decide))
    (eq_smul_div (-38) scale (-19) (22) (by decide) (by decide))
    (eq_smul_div (-16) scale (-4) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-50) scale (-25) (22) (by decide) (by decide))

theorem XZ_scale_7 : toVec (XZ 7) = (scale : ℚ) • XCell6_7 :=
  toVec_eq_smul10 (XZ 7) scale XCell6_7
    (eq_smul_div (-10) scale (-5) (22) (by decide) (by decide))
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-34) scale (-17) (22) (by decide) (by decide))
    (eq_smul_div (-10) scale (-5) (22) (by decide) (by decide))
    (eq_smul_div (38) scale (19) (22) (by decide) (by decide))
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-2) scale (-1) (22) (by decide) (by decide))
    (eq_smul_div (32) scale (8) (11) (by decide) (by decide))
    (eq_smul_div (20) scale (5) (11) (by decide) (by decide))

theorem XZ_scale_8 : toVec (XZ 8) = (scale : ℚ) • XCell6_8 :=
  toVec_eq_smul10 (XZ 8) scale XCell6_8
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)

theorem XZ_scale_9 : toVec (XZ 9) = (scale : ℚ) • XCell6_9 :=
  toVec_eq_smul10 (XZ 9) scale XCell6_9
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)

theorem XZ_scale_10 : toVec (XZ 10) = (scale : ℚ) • XCell6_10 :=
  toVec_eq_smul10 (XZ 10) scale XCell6_10
    (eq_smul_div (11) scale (1) (4) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-11) scale (-1) (4) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-11) scale (-1) (4) (by decide) (by decide))
    (eq_smul_div (-22) scale (-1) (2) (by decide) (by decide))
    (eq_smul_div (-22) scale (-1) (2) (by decide) (by decide))
    (eq_smul_div (-11) scale (-1) (4) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-11) scale (-1) (4) (by decide) (by decide))

theorem XZ_scale_11 : toVec (XZ 11) = (scale : ℚ) • XCell6_11 :=
  toVec_eq_smul10 (XZ 11) scale XCell6_11
    (eq_smul_div (11) scale (1) (4) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-11) scale (-1) (4) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (11) scale (1) (4) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (11) scale (1) (4) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-11) scale (-1) (4) (by decide) (by decide))

theorem XZ_scale_12 : toVec (XZ 12) = (scale : ℚ) • XCell6_12 :=
  toVec_eq_smul10 (XZ 12) scale XCell6_12
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)

theorem XZ_scale_13 : toVec (XZ 13) = (scale : ℚ) • XCell6_13 :=
  toVec_eq_smul10 (XZ 13) scale XCell6_13
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)

theorem XZ_scale_14 : toVec (XZ 14) = (scale : ℚ) • XCell6_14 :=
  toVec_eq_smul10 (XZ 14) scale XCell6_14
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)

theorem XZ_scale_15 : toVec (XZ 15) = (scale : ℚ) • XCell6_15 :=
  toVec_eq_smul10 (XZ 15) scale XCell6_15
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)

theorem XZ_scale_16 : toVec (XZ 16) = (scale : ℚ) • XCell6_16 :=
  toVec_eq_smul10 (XZ 16) scale XCell6_16
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)

theorem XZ_scale_17 : toVec (XZ 17) = (scale : ℚ) • XCell6_17 :=
  toVec_eq_smul10 (XZ 17) scale XCell6_17
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)

theorem XZ_scale_18 : toVec (XZ 18) = (scale : ℚ) • XCell6_18 :=
  toVec_eq_smul10 (XZ 18) scale XCell6_18
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)

theorem XZ_scale_19 : toVec (XZ 19) = (scale : ℚ) • XCell6_19 :=
  toVec_eq_smul10 (XZ 19) scale XCell6_19
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)

theorem XZ_scale (k : Fin 20) :
    toVec (XZ k) = (scale : ℚ) • XVec (6 : Fin 10) k :=
  forall_fin20 (P := fun k => toVec (XZ k) = (scale : ℚ) • XVec (6 : Fin 10) k)
    XZ_scale_0 XZ_scale_1 XZ_scale_2 XZ_scale_3 XZ_scale_4 XZ_scale_5 XZ_scale_6 XZ_scale_7 XZ_scale_8 XZ_scale_9 XZ_scale_10 XZ_scale_11 XZ_scale_12 XZ_scale_13 XZ_scale_14 XZ_scale_15 XZ_scale_16 XZ_scale_17 XZ_scale_18 XZ_scale_19 k

theorem AZ_scale_0 : toVec (AZ 0) = (scale : ℚ) • ACell0_5 :=
  toVec_eq_smul10 (AZ 0) scale ACell0_5
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))

theorem AZ_scale_1 : toVec (AZ 1) = (scale : ℚ) • ACell1_5 :=
  toVec_eq_smul10 (AZ 1) scale ACell1_5
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (16) scale (4) (11) (by decide) (by decide))
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (16) scale (4) (11) (by decide) (by decide))
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))

theorem AZ_scale_2 : toVec (AZ 2) = (scale : ℚ) • ACell2_5 :=
  toVec_eq_smul10 (AZ 2) scale ACell2_5
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))

theorem AZ_scale_3 : toVec (AZ 3) = (scale : ℚ) • ACell3_5 :=
  toVec_eq_smul10 (AZ 3) scale ACell3_5
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (16) scale (4) (11) (by decide) (by decide))
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (16) scale (4) (11) (by decide) (by decide))

theorem AZ_scale_4 : toVec (AZ 4) = (scale : ℚ) • ACell4_5 :=
  toVec_eq_smul10 (AZ 4) scale ACell4_5
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))

theorem AZ_scale_5 : toVec (AZ 5) = (scale : ℚ) • ACell5_5 :=
  toVec_eq_smul10 (AZ 5) scale ACell5_5
    (eq_smul_int (-44) scale (-1) (by decide))
    (eq_smul_div (4) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (4) scale (1) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (12) scale (3) (11) (by decide) (by decide))
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (4) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (4) scale (1) (11) (by decide) (by decide))

theorem AZ_scale_6 : toVec (AZ 6) = (scale : ℚ) • ACell6_5 :=
  toVec_eq_smul10 (AZ 6) scale ACell6_5
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (4) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (4) scale (1) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (4) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (4) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_zero scale)

theorem AZ_scale_7 : toVec (AZ 7) = (scale : ℚ) • ACell7_5 :=
  toVec_eq_smul10 (AZ 7) scale ACell7_5
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-12) scale (-3) (11) (by decide) (by decide))
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)

theorem AZ_scale_8 : toVec (AZ 8) = (scale : ℚ) • ACell8_5 :=
  toVec_eq_smul10 (AZ 8) scale ACell8_5
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (4) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (4) scale (1) (11) (by decide) (by decide))

theorem AZ_scale_9 : toVec (AZ 9) = (scale : ℚ) • ACell9_5 :=
  toVec_eq_smul10 (AZ 9) scale ACell9_5
    (eq_smul_div (12) scale (3) (11) (by decide) (by decide))
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (12) scale (3) (11) (by decide) (by decide))
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (4) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (4) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (12) scale (3) (11) (by decide) (by decide))
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (12) scale (3) (11) (by decide) (by decide))

theorem AZ_scale_10 : toVec (AZ 10) = (scale : ℚ) • ACell10_5 :=
  toVec_eq_smul10 (AZ 10) scale ACell10_5
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_zero scale)

theorem AZ_scale_11 : toVec (AZ 11) = (scale : ℚ) • ACell11_5 :=
  toVec_eq_smul10 (AZ 11) scale ACell11_5
    (eq_smul_zero scale)
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_zero scale)

theorem AZ_scale_12 : toVec (AZ 12) = (scale : ℚ) • ACell12_5 :=
  toVec_eq_smul10 (AZ 12) scale ACell12_5
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-16) scale (-4) (11) (by decide) (by decide))
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-16) scale (-4) (11) (by decide) (by decide))
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))

theorem AZ_scale_13 : toVec (AZ 13) = (scale : ℚ) • ACell13_5 :=
  toVec_eq_smul10 (AZ 13) scale ACell13_5
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_zero scale)

theorem AZ_scale_14 : toVec (AZ 14) = (scale : ℚ) • ACell14_5 :=
  toVec_eq_smul10 (AZ 14) scale ACell14_5
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-16) scale (-4) (11) (by decide) (by decide))
    (eq_smul_div (-16) scale (-4) (11) (by decide) (by decide))
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))

theorem AZ_scale_15 : toVec (AZ 15) = (scale : ℚ) • ACell15_5 :=
  toVec_eq_smul10 (AZ 15) scale ACell15_5
    (eq_smul_div (56) scale (14) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (4) scale (1) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (4) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (4) scale (1) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (4) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))

theorem AZ_scale_16 : toVec (AZ 16) = (scale : ℚ) • ACell16_5 :=
  toVec_eq_smul10 (AZ 16) scale ACell16_5
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-12) scale (-3) (11) (by decide) (by decide))
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)

theorem AZ_scale_17 : toVec (AZ 17) = (scale : ℚ) • ACell17_5 :=
  toVec_eq_smul10 (AZ 17) scale ACell17_5
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (4) scale (1) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (4) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (4) scale (1) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (4) scale (1) (11) (by decide) (by decide))

theorem AZ_scale_18 : toVec (AZ 18) = (scale : ℚ) • ACell18_5 :=
  toVec_eq_smul10 (AZ 18) scale ACell18_5
    (eq_smul_zero scale)
    (eq_smul_div (4) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (4) scale (1) (11) (by decide) (by decide))

theorem AZ_scale_19 : toVec (AZ 19) = (scale : ℚ) • ACell19_5 :=
  toVec_eq_smul10 (AZ 19) scale ACell19_5
    (eq_smul_zero scale)
    (eq_smul_div (4) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (4) scale (1) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (4) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (4) scale (1) (11) (by decide) (by decide))

theorem AZ_scale (k : Fin 20) :
    toVec (AZ k) = (scale : ℚ) • AVec k (5 : Fin 10) :=
  forall_fin20 (P := fun k => toVec (AZ k) = (scale : ℚ) • AVec k (5 : Fin 10))
    AZ_scale_0 AZ_scale_1 AZ_scale_2 AZ_scale_3 AZ_scale_4 AZ_scale_5 AZ_scale_6 AZ_scale_7 AZ_scale_8 AZ_scale_9 AZ_scale_10 AZ_scale_11 AZ_scale_12 AZ_scale_13 AZ_scale_14 AZ_scale_15 AZ_scale_16 AZ_scale_17 AZ_scale_18 AZ_scale_19 k

theorem entry_eq :
    (matrixMul XVec AVec) (6 : Fin 10) (5 : Fin 10) =
      ![0, 0, 0, 0, 0, 0, 0, 0, 0, 0] := by
  unfold matrixMul
  refine sum_mul_eq_of_scaled scale scale_ne_zero
    (fun k => XVec (6 : Fin 10) k)
    (fun k => AVec k (5 : Fin 10))
    XZ AZ XZ_scale AZ_scale entryZ rfl _ ?_
  rw [entryZ_eq, toVec_zeroZ_smul, vec_zero_eq]

theorem entry_eq_matrixOne :
    (matrixMul XVec AVec) (6 : Fin 10) (5 : Fin 10) =
      matrixOne (Fin 10) (6 : Fin 10) (5 : Fin 10) :=
  entry_eq.trans (matrixOne_off10 (6 : Fin 10) (5 : Fin 10) (by decide)).symm

end V14Formalization.D12PiecePASplitEntry6_5


namespace V14Formalization.D12PiecePASplitEntry6_6
open D12CyclotomicVec D12CyclotomicVecZ D12PiecePAData
def payloadSha256 : String := "76c6196f29afe1a8398af99502447f48ebeed4bcb3805fc5dbec693940bc04b0"

def scale : ℤ := 44

def XZ (k : Fin 20) : VecZ :=
  match k.val with
  | 0 => #v[-5, -47, -14, -20, -48, -22, -43, -18, -23, -46]
  | 1 => #v[13, 31, -8, 20, 26, 9, 28, 26, 6, 36]
  | 2 => #v[-9, -29, -20, -16, -17, -16, -8, -4, -7, -17]
  | 3 => #v[6, -12, 14, 12, -2, 8, -16, -4, -6, -22]
  | 4 => #v[-1, -26, -12, 15, -4, -19, -5, 14, -14, -25]
  | 5 => #v[8, 12, -14, 14, 2, -18, 6, 14, -6, 26]
  | 6 => #v[-32, -54, -12, -32, -36, -16, -38, -16, 0, -50]
  | 7 => #v[-10, -4, 0, -34, -10, 38, -8, -2, 32, 20]
  | 8 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  | 9 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  | 10 => #v[11, 0, -11, 0, -11, -22, -22, -11, 0, -11]
  | 11 => #v[11, 0, -11, 0, 11, 0, 0, 11, 0, -11]
  | 12 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  | 13 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  | 14 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  | 15 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  | 16 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  | 17 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  | 18 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  | 19 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  | _ => zeroZ

def AZ (k : Fin 20) : VecZ :=
  match k.val with
  | 0 => #v[0, 8, -8, 0, 0, 0, 0, -8, 8, 0]
  | 1 => #v[0, 8, -8, -8, 8, 0, 0, 0, 0, 0]
  | 2 => #v[8, 8, 8, 0, 8, 8, 16, 16, 8, 8]
  | 3 => #v[8, 0, 8, 16, 8, 8, 8, 8, 16, 8]
  | 4 => #v[0, -8, 0, 0, 8, 0, 8, 0, 0, -8]
  | 5 => #v[-4, 4, 4, 0, -8, 0, 4, 4, -4, 0]
  | 6 => #v[-48, 0, -4, 8, -4, 0, -4, 0, 4, 4]
  | 7 => #v[-4, 4, 8, 4, -4, 0, 0, -4, -4, 0]
  | 8 => #v[0, 0, 0, -8, -4, -4, -12, -4, -4, -8]
  | 9 => #v[8, 4, 0, 4, 4, 0, 4, 8, 0, 12]
  | 10 => #v[0, 0, 0, 0, 0, 8, -8, -8, 8, 0]
  | 11 => #v[-8, -8, -8, -8, 0, -8, -16, -8, -16, -8]
  | 12 => #v[8, 8, 0, 8, 8, 16, 8, 16, 8, 8]
  | 13 => #v[-8, 0, 0, 8, 8, 0, 0, -8, 0, 0]
  | 14 => #v[0, 0, -8, 8, 0, 0, 0, 8, -8, 0]
  | 15 => #v[-4, 4, 4, 4, 4, -4, 0, 0, -8, 0]
  | 16 => #v[48, 0, -8, -4, -4, -8, -8, -4, -4, -8]
  | 17 => #v[4, 8, 0, 12, 0, 8, 4, 0, 4, 4]
  | 18 => #v[-4, 0, -12, 0, -4, 0, -4, -8, -8, -4]
  | 19 => #v[4, -4, -4, 0, 8, 0, -4, -4, 4, 0]
  | _ => zeroZ

def entryZ : VecZ := sumFin (fun k => mulZ (XZ k) (AZ k))

theorem entryZ_eq : entryZ = scaleSqE0 scale :=
  eq_of_eqZ (by decide +kernel)

theorem scale_ne_zero : scale ≠ 0 := by
  decide

theorem XZ_scale_0 : toVec (XZ 0) = (scale : ℚ) • XCell6_0 :=
  toVec_eq_smul10 (XZ 0) scale XCell6_0
    (eq_smul_div (-5) scale (-5) (44) (by decide) (by decide))
    (eq_smul_div (-47) scale (-47) (44) (by decide) (by decide))
    (eq_smul_div (-14) scale (-7) (22) (by decide) (by decide))
    (eq_smul_div (-20) scale (-5) (11) (by decide) (by decide))
    (eq_smul_div (-48) scale (-12) (11) (by decide) (by decide))
    (eq_smul_div (-22) scale (-1) (2) (by decide) (by decide))
    (eq_smul_div (-43) scale (-43) (44) (by decide) (by decide))
    (eq_smul_div (-18) scale (-9) (22) (by decide) (by decide))
    (eq_smul_div (-23) scale (-23) (44) (by decide) (by decide))
    (eq_smul_div (-46) scale (-23) (22) (by decide) (by decide))

theorem XZ_scale_1 : toVec (XZ 1) = (scale : ℚ) • XCell6_1 :=
  toVec_eq_smul10 (XZ 1) scale XCell6_1
    (eq_smul_div (13) scale (13) (44) (by decide) (by decide))
    (eq_smul_div (31) scale (31) (44) (by decide) (by decide))
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (20) scale (5) (11) (by decide) (by decide))
    (eq_smul_div (26) scale (13) (22) (by decide) (by decide))
    (eq_smul_div (9) scale (9) (44) (by decide) (by decide))
    (eq_smul_div (28) scale (7) (11) (by decide) (by decide))
    (eq_smul_div (26) scale (13) (22) (by decide) (by decide))
    (eq_smul_div (6) scale (3) (22) (by decide) (by decide))
    (eq_smul_div (36) scale (9) (11) (by decide) (by decide))

theorem XZ_scale_2 : toVec (XZ 2) = (scale : ℚ) • XCell6_2 :=
  toVec_eq_smul10 (XZ 2) scale XCell6_2
    (eq_smul_div (-9) scale (-9) (44) (by decide) (by decide))
    (eq_smul_div (-29) scale (-29) (44) (by decide) (by decide))
    (eq_smul_div (-20) scale (-5) (11) (by decide) (by decide))
    (eq_smul_div (-16) scale (-4) (11) (by decide) (by decide))
    (eq_smul_div (-17) scale (-17) (44) (by decide) (by decide))
    (eq_smul_div (-16) scale (-4) (11) (by decide) (by decide))
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-7) scale (-7) (44) (by decide) (by decide))
    (eq_smul_div (-17) scale (-17) (44) (by decide) (by decide))

theorem XZ_scale_3 : toVec (XZ 3) = (scale : ℚ) • XCell6_3 :=
  toVec_eq_smul10 (XZ 3) scale XCell6_3
    (eq_smul_div (6) scale (3) (22) (by decide) (by decide))
    (eq_smul_div (-12) scale (-3) (11) (by decide) (by decide))
    (eq_smul_div (14) scale (7) (22) (by decide) (by decide))
    (eq_smul_div (12) scale (3) (11) (by decide) (by decide))
    (eq_smul_div (-2) scale (-1) (22) (by decide) (by decide))
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (-16) scale (-4) (11) (by decide) (by decide))
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-6) scale (-3) (22) (by decide) (by decide))
    (eq_smul_div (-22) scale (-1) (2) (by decide) (by decide))

theorem XZ_scale_4 : toVec (XZ 4) = (scale : ℚ) • XCell6_4 :=
  toVec_eq_smul10 (XZ 4) scale XCell6_4
    (eq_smul_div (-1) scale (-1) (44) (by decide) (by decide))
    (eq_smul_div (-26) scale (-13) (22) (by decide) (by decide))
    (eq_smul_div (-12) scale (-3) (11) (by decide) (by decide))
    (eq_smul_div (15) scale (15) (44) (by decide) (by decide))
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-19) scale (-19) (44) (by decide) (by decide))
    (eq_smul_div (-5) scale (-5) (44) (by decide) (by decide))
    (eq_smul_div (14) scale (7) (22) (by decide) (by decide))
    (eq_smul_div (-14) scale (-7) (22) (by decide) (by decide))
    (eq_smul_div (-25) scale (-25) (44) (by decide) (by decide))

theorem XZ_scale_5 : toVec (XZ 5) = (scale : ℚ) • XCell6_5 :=
  toVec_eq_smul10 (XZ 5) scale XCell6_5
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (12) scale (3) (11) (by decide) (by decide))
    (eq_smul_div (-14) scale (-7) (22) (by decide) (by decide))
    (eq_smul_div (14) scale (7) (22) (by decide) (by decide))
    (eq_smul_div (2) scale (1) (22) (by decide) (by decide))
    (eq_smul_div (-18) scale (-9) (22) (by decide) (by decide))
    (eq_smul_div (6) scale (3) (22) (by decide) (by decide))
    (eq_smul_div (14) scale (7) (22) (by decide) (by decide))
    (eq_smul_div (-6) scale (-3) (22) (by decide) (by decide))
    (eq_smul_div (26) scale (13) (22) (by decide) (by decide))

theorem XZ_scale_6 : toVec (XZ 6) = (scale : ℚ) • XCell6_6 :=
  toVec_eq_smul10 (XZ 6) scale XCell6_6
    (eq_smul_div (-32) scale (-8) (11) (by decide) (by decide))
    (eq_smul_div (-54) scale (-27) (22) (by decide) (by decide))
    (eq_smul_div (-12) scale (-3) (11) (by decide) (by decide))
    (eq_smul_div (-32) scale (-8) (11) (by decide) (by decide))
    (eq_smul_div (-36) scale (-9) (11) (by decide) (by decide))
    (eq_smul_div (-16) scale (-4) (11) (by decide) (by decide))
    (eq_smul_div (-38) scale (-19) (22) (by decide) (by decide))
    (eq_smul_div (-16) scale (-4) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-50) scale (-25) (22) (by decide) (by decide))

theorem XZ_scale_7 : toVec (XZ 7) = (scale : ℚ) • XCell6_7 :=
  toVec_eq_smul10 (XZ 7) scale XCell6_7
    (eq_smul_div (-10) scale (-5) (22) (by decide) (by decide))
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-34) scale (-17) (22) (by decide) (by decide))
    (eq_smul_div (-10) scale (-5) (22) (by decide) (by decide))
    (eq_smul_div (38) scale (19) (22) (by decide) (by decide))
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-2) scale (-1) (22) (by decide) (by decide))
    (eq_smul_div (32) scale (8) (11) (by decide) (by decide))
    (eq_smul_div (20) scale (5) (11) (by decide) (by decide))

theorem XZ_scale_8 : toVec (XZ 8) = (scale : ℚ) • XCell6_8 :=
  toVec_eq_smul10 (XZ 8) scale XCell6_8
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)

theorem XZ_scale_9 : toVec (XZ 9) = (scale : ℚ) • XCell6_9 :=
  toVec_eq_smul10 (XZ 9) scale XCell6_9
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)

theorem XZ_scale_10 : toVec (XZ 10) = (scale : ℚ) • XCell6_10 :=
  toVec_eq_smul10 (XZ 10) scale XCell6_10
    (eq_smul_div (11) scale (1) (4) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-11) scale (-1) (4) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-11) scale (-1) (4) (by decide) (by decide))
    (eq_smul_div (-22) scale (-1) (2) (by decide) (by decide))
    (eq_smul_div (-22) scale (-1) (2) (by decide) (by decide))
    (eq_smul_div (-11) scale (-1) (4) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-11) scale (-1) (4) (by decide) (by decide))

theorem XZ_scale_11 : toVec (XZ 11) = (scale : ℚ) • XCell6_11 :=
  toVec_eq_smul10 (XZ 11) scale XCell6_11
    (eq_smul_div (11) scale (1) (4) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-11) scale (-1) (4) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (11) scale (1) (4) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (11) scale (1) (4) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-11) scale (-1) (4) (by decide) (by decide))

theorem XZ_scale_12 : toVec (XZ 12) = (scale : ℚ) • XCell6_12 :=
  toVec_eq_smul10 (XZ 12) scale XCell6_12
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)

theorem XZ_scale_13 : toVec (XZ 13) = (scale : ℚ) • XCell6_13 :=
  toVec_eq_smul10 (XZ 13) scale XCell6_13
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)

theorem XZ_scale_14 : toVec (XZ 14) = (scale : ℚ) • XCell6_14 :=
  toVec_eq_smul10 (XZ 14) scale XCell6_14
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)

theorem XZ_scale_15 : toVec (XZ 15) = (scale : ℚ) • XCell6_15 :=
  toVec_eq_smul10 (XZ 15) scale XCell6_15
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)

theorem XZ_scale_16 : toVec (XZ 16) = (scale : ℚ) • XCell6_16 :=
  toVec_eq_smul10 (XZ 16) scale XCell6_16
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)

theorem XZ_scale_17 : toVec (XZ 17) = (scale : ℚ) • XCell6_17 :=
  toVec_eq_smul10 (XZ 17) scale XCell6_17
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)

theorem XZ_scale_18 : toVec (XZ 18) = (scale : ℚ) • XCell6_18 :=
  toVec_eq_smul10 (XZ 18) scale XCell6_18
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)

theorem XZ_scale_19 : toVec (XZ 19) = (scale : ℚ) • XCell6_19 :=
  toVec_eq_smul10 (XZ 19) scale XCell6_19
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)

theorem XZ_scale (k : Fin 20) :
    toVec (XZ k) = (scale : ℚ) • XVec (6 : Fin 10) k :=
  forall_fin20 (P := fun k => toVec (XZ k) = (scale : ℚ) • XVec (6 : Fin 10) k)
    XZ_scale_0 XZ_scale_1 XZ_scale_2 XZ_scale_3 XZ_scale_4 XZ_scale_5 XZ_scale_6 XZ_scale_7 XZ_scale_8 XZ_scale_9 XZ_scale_10 XZ_scale_11 XZ_scale_12 XZ_scale_13 XZ_scale_14 XZ_scale_15 XZ_scale_16 XZ_scale_17 XZ_scale_18 XZ_scale_19 k

theorem AZ_scale_0 : toVec (AZ 0) = (scale : ℚ) • ACell0_6 :=
  toVec_eq_smul10 (AZ 0) scale ACell0_6
    (eq_smul_zero scale)
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_zero scale)

theorem AZ_scale_1 : toVec (AZ 1) = (scale : ℚ) • ACell1_6 :=
  toVec_eq_smul10 (AZ 1) scale ACell1_6
    (eq_smul_zero scale)
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)

theorem AZ_scale_2 : toVec (AZ 2) = (scale : ℚ) • ACell2_6 :=
  toVec_eq_smul10 (AZ 2) scale ACell2_6
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (16) scale (4) (11) (by decide) (by decide))
    (eq_smul_div (16) scale (4) (11) (by decide) (by decide))
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))

theorem AZ_scale_3 : toVec (AZ 3) = (scale : ℚ) • ACell3_6 :=
  toVec_eq_smul10 (AZ 3) scale ACell3_6
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (16) scale (4) (11) (by decide) (by decide))
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (16) scale (4) (11) (by decide) (by decide))
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))

theorem AZ_scale_4 : toVec (AZ 4) = (scale : ℚ) • ACell4_6 :=
  toVec_eq_smul10 (AZ 4) scale ACell4_6
    (eq_smul_zero scale)
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))

theorem AZ_scale_5 : toVec (AZ 5) = (scale : ℚ) • ACell5_6 :=
  toVec_eq_smul10 (AZ 5) scale ACell5_6
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (4) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (4) scale (1) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (4) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (4) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_zero scale)

theorem AZ_scale_6 : toVec (AZ 6) = (scale : ℚ) • ACell6_6 :=
  toVec_eq_smul10 (AZ 6) scale ACell6_6
    (eq_smul_div (-48) scale (-12) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (4) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (4) scale (1) (11) (by decide) (by decide))

theorem AZ_scale_7 : toVec (AZ 7) = (scale : ℚ) • ACell7_6 :=
  toVec_eq_smul10 (AZ 7) scale ACell7_6
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (4) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (4) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_zero scale)

theorem AZ_scale_8 : toVec (AZ 8) = (scale : ℚ) • ACell8_6 :=
  toVec_eq_smul10 (AZ 8) scale ACell8_6
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-12) scale (-3) (11) (by decide) (by decide))
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))

theorem AZ_scale_9 : toVec (AZ 9) = (scale : ℚ) • ACell9_6 :=
  toVec_eq_smul10 (AZ 9) scale ACell9_6
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (4) scale (1) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (4) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (4) scale (1) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (4) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (12) scale (3) (11) (by decide) (by decide))

theorem AZ_scale_10 : toVec (AZ 10) = (scale : ℚ) • ACell10_6 :=
  toVec_eq_smul10 (AZ 10) scale ACell10_6
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_zero scale)

theorem AZ_scale_11 : toVec (AZ 11) = (scale : ℚ) • ACell11_6 :=
  toVec_eq_smul10 (AZ 11) scale ACell11_6
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-16) scale (-4) (11) (by decide) (by decide))
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-16) scale (-4) (11) (by decide) (by decide))
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))

theorem AZ_scale_12 : toVec (AZ 12) = (scale : ℚ) • ACell12_6 :=
  toVec_eq_smul10 (AZ 12) scale ACell12_6
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (16) scale (4) (11) (by decide) (by decide))
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (16) scale (4) (11) (by decide) (by decide))
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))

theorem AZ_scale_13 : toVec (AZ 13) = (scale : ℚ) • ACell13_6 :=
  toVec_eq_smul10 (AZ 13) scale ACell13_6
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)

theorem AZ_scale_14 : toVec (AZ 14) = (scale : ℚ) • ACell14_6 :=
  toVec_eq_smul10 (AZ 14) scale ACell14_6
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_zero scale)

theorem AZ_scale_15 : toVec (AZ 15) = (scale : ℚ) • ACell15_6 :=
  toVec_eq_smul10 (AZ 15) scale ACell15_6
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (4) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (4) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (4) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (4) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_zero scale)

theorem AZ_scale_16 : toVec (AZ 16) = (scale : ℚ) • ACell16_6 :=
  toVec_eq_smul10 (AZ 16) scale ACell16_6
    (eq_smul_div (48) scale (12) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))

theorem AZ_scale_17 : toVec (AZ 17) = (scale : ℚ) • ACell17_6 :=
  toVec_eq_smul10 (AZ 17) scale ACell17_6
    (eq_smul_div (4) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (12) scale (3) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (4) scale (1) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (4) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (4) scale (1) (11) (by decide) (by decide))

theorem AZ_scale_18 : toVec (AZ 18) = (scale : ℚ) • ACell18_6 :=
  toVec_eq_smul10 (AZ 18) scale ACell18_6
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-12) scale (-3) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))

theorem AZ_scale_19 : toVec (AZ 19) = (scale : ℚ) • ACell19_6 :=
  toVec_eq_smul10 (AZ 19) scale ACell19_6
    (eq_smul_div (4) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (4) scale (1) (11) (by decide) (by decide))
    (eq_smul_zero scale)

theorem AZ_scale (k : Fin 20) :
    toVec (AZ k) = (scale : ℚ) • AVec k (6 : Fin 10) :=
  forall_fin20 (P := fun k => toVec (AZ k) = (scale : ℚ) • AVec k (6 : Fin 10))
    AZ_scale_0 AZ_scale_1 AZ_scale_2 AZ_scale_3 AZ_scale_4 AZ_scale_5 AZ_scale_6 AZ_scale_7 AZ_scale_8 AZ_scale_9 AZ_scale_10 AZ_scale_11 AZ_scale_12 AZ_scale_13 AZ_scale_14 AZ_scale_15 AZ_scale_16 AZ_scale_17 AZ_scale_18 AZ_scale_19 k

theorem entry_eq :
    (matrixMul XVec AVec) (6 : Fin 10) (6 : Fin 10) =
      ![1, 0, 0, 0, 0, 0, 0, 0, 0, 0] := by
  unfold matrixMul
  refine sum_mul_eq_of_scaled scale scale_ne_zero
    (fun k => XVec (6 : Fin 10) k)
    (fun k => AVec k (6 : Fin 10))
    XZ AZ XZ_scale AZ_scale entryZ rfl _ ?_
  rw [entryZ_eq, toVec_scaleSqE0, constVec_one_eq]

theorem entry_eq_matrixOne :
    (matrixMul XVec AVec) (6 : Fin 10) (6 : Fin 10) =
      matrixOne (Fin 10) (6 : Fin 10) (6 : Fin 10) :=
  entry_eq.trans (matrixOne_diag10 (6 : Fin 10)).symm

end V14Formalization.D12PiecePASplitEntry6_6


namespace V14Formalization.D12PiecePASplitEntry6_7
open D12CyclotomicVec D12CyclotomicVecZ D12PiecePAData
def payloadSha256 : String := "76c6196f29afe1a8398af99502447f48ebeed4bcb3805fc5dbec693940bc04b0"

def scale : ℤ := 44

def XZ (k : Fin 20) : VecZ :=
  match k.val with
  | 0 => #v[-5, -47, -14, -20, -48, -22, -43, -18, -23, -46]
  | 1 => #v[13, 31, -8, 20, 26, 9, 28, 26, 6, 36]
  | 2 => #v[-9, -29, -20, -16, -17, -16, -8, -4, -7, -17]
  | 3 => #v[6, -12, 14, 12, -2, 8, -16, -4, -6, -22]
  | 4 => #v[-1, -26, -12, 15, -4, -19, -5, 14, -14, -25]
  | 5 => #v[8, 12, -14, 14, 2, -18, 6, 14, -6, 26]
  | 6 => #v[-32, -54, -12, -32, -36, -16, -38, -16, 0, -50]
  | 7 => #v[-10, -4, 0, -34, -10, 38, -8, -2, 32, 20]
  | 8 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  | 9 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  | 10 => #v[11, 0, -11, 0, -11, -22, -22, -11, 0, -11]
  | 11 => #v[11, 0, -11, 0, 11, 0, 0, 11, 0, -11]
  | 12 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  | 13 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  | 14 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  | 15 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  | 16 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  | 17 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  | 18 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  | 19 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  | _ => zeroZ

def AZ (k : Fin 20) : VecZ :=
  match k.val with
  | 0 => #v[0, 0, 8, -8, -8, 8, 0, 0, 0, 0]
  | 1 => #v[-8, -8, -8, -8, 0, -8, -16, -8, -16, -8]
  | 2 => #v[-8, 0, -8, -8, -16, -8, -8, -16, -8, -8]
  | 3 => #v[0, -8, 0, 0, 8, 8, 0, 0, -8, 0]
  | 4 => #v[0, -8, 8, 0, 0, 0, 8, -8, 0, 0]
  | 5 => #v[-8, -4, -4, -12, -4, -4, -8, 0, 0, 0]
  | 6 => #v[-4, 4, 8, 4, -4, 0, 0, -4, -4, 0]
  | 7 => #v[-52, 4, -8, 0, -4, -8, -4, -4, -8, -4]
  | 8 => #v[0, 4, 8, 4, 8, -4, 8, 4, 8, 4]
  | 9 => #v[0, 8, 4, 4, 8, 0, 0, 4, 12, 4]
  | 10 => #v[8, 16, 8, 8, 8, 8, 16, 8, 0, 8]
  | 11 => #v[-8, -8, -16, -8, -8, -8, -16, -8, -8, 0]
  | 12 => #v[-8, 8, 0, 0, 0, 8, -8, 0, 0, 0]
  | 13 => #v[8, 8, 0, 8, 8, 16, 8, 16, 8, 8]
  | 14 => #v[0, 0, 0, 0, 0, 0, 8, -8, -8, 8]
  | 15 => #v[0, 4, 8, 4, 8, -4, 8, 4, 8, 4]
  | 16 => #v[-4, -8, -4, -4, -8, -4, 0, -8, 4, -8]
  | 17 => #v[52, 0, -4, -4, 4, 0, 0, 4, -4, -4]
  | 18 => #v[4, 12, 8, 8, 12, 12, 8, 8, 12, 4]
  | 19 => #v[0, 8, 0, 0, 4, -4, -4, -4, -4, 4]
  | _ => zeroZ

def entryZ : VecZ := sumFin (fun k => mulZ (XZ k) (AZ k))

theorem entryZ_eq : entryZ = zeroZ :=
  eq_of_eqZ (by decide +kernel)

theorem scale_ne_zero : scale ≠ 0 := by
  decide

theorem XZ_scale_0 : toVec (XZ 0) = (scale : ℚ) • XCell6_0 :=
  toVec_eq_smul10 (XZ 0) scale XCell6_0
    (eq_smul_div (-5) scale (-5) (44) (by decide) (by decide))
    (eq_smul_div (-47) scale (-47) (44) (by decide) (by decide))
    (eq_smul_div (-14) scale (-7) (22) (by decide) (by decide))
    (eq_smul_div (-20) scale (-5) (11) (by decide) (by decide))
    (eq_smul_div (-48) scale (-12) (11) (by decide) (by decide))
    (eq_smul_div (-22) scale (-1) (2) (by decide) (by decide))
    (eq_smul_div (-43) scale (-43) (44) (by decide) (by decide))
    (eq_smul_div (-18) scale (-9) (22) (by decide) (by decide))
    (eq_smul_div (-23) scale (-23) (44) (by decide) (by decide))
    (eq_smul_div (-46) scale (-23) (22) (by decide) (by decide))

theorem XZ_scale_1 : toVec (XZ 1) = (scale : ℚ) • XCell6_1 :=
  toVec_eq_smul10 (XZ 1) scale XCell6_1
    (eq_smul_div (13) scale (13) (44) (by decide) (by decide))
    (eq_smul_div (31) scale (31) (44) (by decide) (by decide))
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (20) scale (5) (11) (by decide) (by decide))
    (eq_smul_div (26) scale (13) (22) (by decide) (by decide))
    (eq_smul_div (9) scale (9) (44) (by decide) (by decide))
    (eq_smul_div (28) scale (7) (11) (by decide) (by decide))
    (eq_smul_div (26) scale (13) (22) (by decide) (by decide))
    (eq_smul_div (6) scale (3) (22) (by decide) (by decide))
    (eq_smul_div (36) scale (9) (11) (by decide) (by decide))

theorem XZ_scale_2 : toVec (XZ 2) = (scale : ℚ) • XCell6_2 :=
  toVec_eq_smul10 (XZ 2) scale XCell6_2
    (eq_smul_div (-9) scale (-9) (44) (by decide) (by decide))
    (eq_smul_div (-29) scale (-29) (44) (by decide) (by decide))
    (eq_smul_div (-20) scale (-5) (11) (by decide) (by decide))
    (eq_smul_div (-16) scale (-4) (11) (by decide) (by decide))
    (eq_smul_div (-17) scale (-17) (44) (by decide) (by decide))
    (eq_smul_div (-16) scale (-4) (11) (by decide) (by decide))
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-7) scale (-7) (44) (by decide) (by decide))
    (eq_smul_div (-17) scale (-17) (44) (by decide) (by decide))

theorem XZ_scale_3 : toVec (XZ 3) = (scale : ℚ) • XCell6_3 :=
  toVec_eq_smul10 (XZ 3) scale XCell6_3
    (eq_smul_div (6) scale (3) (22) (by decide) (by decide))
    (eq_smul_div (-12) scale (-3) (11) (by decide) (by decide))
    (eq_smul_div (14) scale (7) (22) (by decide) (by decide))
    (eq_smul_div (12) scale (3) (11) (by decide) (by decide))
    (eq_smul_div (-2) scale (-1) (22) (by decide) (by decide))
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (-16) scale (-4) (11) (by decide) (by decide))
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-6) scale (-3) (22) (by decide) (by decide))
    (eq_smul_div (-22) scale (-1) (2) (by decide) (by decide))

theorem XZ_scale_4 : toVec (XZ 4) = (scale : ℚ) • XCell6_4 :=
  toVec_eq_smul10 (XZ 4) scale XCell6_4
    (eq_smul_div (-1) scale (-1) (44) (by decide) (by decide))
    (eq_smul_div (-26) scale (-13) (22) (by decide) (by decide))
    (eq_smul_div (-12) scale (-3) (11) (by decide) (by decide))
    (eq_smul_div (15) scale (15) (44) (by decide) (by decide))
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-19) scale (-19) (44) (by decide) (by decide))
    (eq_smul_div (-5) scale (-5) (44) (by decide) (by decide))
    (eq_smul_div (14) scale (7) (22) (by decide) (by decide))
    (eq_smul_div (-14) scale (-7) (22) (by decide) (by decide))
    (eq_smul_div (-25) scale (-25) (44) (by decide) (by decide))

theorem XZ_scale_5 : toVec (XZ 5) = (scale : ℚ) • XCell6_5 :=
  toVec_eq_smul10 (XZ 5) scale XCell6_5
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (12) scale (3) (11) (by decide) (by decide))
    (eq_smul_div (-14) scale (-7) (22) (by decide) (by decide))
    (eq_smul_div (14) scale (7) (22) (by decide) (by decide))
    (eq_smul_div (2) scale (1) (22) (by decide) (by decide))
    (eq_smul_div (-18) scale (-9) (22) (by decide) (by decide))
    (eq_smul_div (6) scale (3) (22) (by decide) (by decide))
    (eq_smul_div (14) scale (7) (22) (by decide) (by decide))
    (eq_smul_div (-6) scale (-3) (22) (by decide) (by decide))
    (eq_smul_div (26) scale (13) (22) (by decide) (by decide))

theorem XZ_scale_6 : toVec (XZ 6) = (scale : ℚ) • XCell6_6 :=
  toVec_eq_smul10 (XZ 6) scale XCell6_6
    (eq_smul_div (-32) scale (-8) (11) (by decide) (by decide))
    (eq_smul_div (-54) scale (-27) (22) (by decide) (by decide))
    (eq_smul_div (-12) scale (-3) (11) (by decide) (by decide))
    (eq_smul_div (-32) scale (-8) (11) (by decide) (by decide))
    (eq_smul_div (-36) scale (-9) (11) (by decide) (by decide))
    (eq_smul_div (-16) scale (-4) (11) (by decide) (by decide))
    (eq_smul_div (-38) scale (-19) (22) (by decide) (by decide))
    (eq_smul_div (-16) scale (-4) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-50) scale (-25) (22) (by decide) (by decide))

theorem XZ_scale_7 : toVec (XZ 7) = (scale : ℚ) • XCell6_7 :=
  toVec_eq_smul10 (XZ 7) scale XCell6_7
    (eq_smul_div (-10) scale (-5) (22) (by decide) (by decide))
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-34) scale (-17) (22) (by decide) (by decide))
    (eq_smul_div (-10) scale (-5) (22) (by decide) (by decide))
    (eq_smul_div (38) scale (19) (22) (by decide) (by decide))
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-2) scale (-1) (22) (by decide) (by decide))
    (eq_smul_div (32) scale (8) (11) (by decide) (by decide))
    (eq_smul_div (20) scale (5) (11) (by decide) (by decide))

theorem XZ_scale_8 : toVec (XZ 8) = (scale : ℚ) • XCell6_8 :=
  toVec_eq_smul10 (XZ 8) scale XCell6_8
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)

theorem XZ_scale_9 : toVec (XZ 9) = (scale : ℚ) • XCell6_9 :=
  toVec_eq_smul10 (XZ 9) scale XCell6_9
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)

theorem XZ_scale_10 : toVec (XZ 10) = (scale : ℚ) • XCell6_10 :=
  toVec_eq_smul10 (XZ 10) scale XCell6_10
    (eq_smul_div (11) scale (1) (4) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-11) scale (-1) (4) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-11) scale (-1) (4) (by decide) (by decide))
    (eq_smul_div (-22) scale (-1) (2) (by decide) (by decide))
    (eq_smul_div (-22) scale (-1) (2) (by decide) (by decide))
    (eq_smul_div (-11) scale (-1) (4) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-11) scale (-1) (4) (by decide) (by decide))

theorem XZ_scale_11 : toVec (XZ 11) = (scale : ℚ) • XCell6_11 :=
  toVec_eq_smul10 (XZ 11) scale XCell6_11
    (eq_smul_div (11) scale (1) (4) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-11) scale (-1) (4) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (11) scale (1) (4) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (11) scale (1) (4) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-11) scale (-1) (4) (by decide) (by decide))

theorem XZ_scale_12 : toVec (XZ 12) = (scale : ℚ) • XCell6_12 :=
  toVec_eq_smul10 (XZ 12) scale XCell6_12
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)

theorem XZ_scale_13 : toVec (XZ 13) = (scale : ℚ) • XCell6_13 :=
  toVec_eq_smul10 (XZ 13) scale XCell6_13
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)

theorem XZ_scale_14 : toVec (XZ 14) = (scale : ℚ) • XCell6_14 :=
  toVec_eq_smul10 (XZ 14) scale XCell6_14
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)

theorem XZ_scale_15 : toVec (XZ 15) = (scale : ℚ) • XCell6_15 :=
  toVec_eq_smul10 (XZ 15) scale XCell6_15
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)

theorem XZ_scale_16 : toVec (XZ 16) = (scale : ℚ) • XCell6_16 :=
  toVec_eq_smul10 (XZ 16) scale XCell6_16
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)

theorem XZ_scale_17 : toVec (XZ 17) = (scale : ℚ) • XCell6_17 :=
  toVec_eq_smul10 (XZ 17) scale XCell6_17
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)

theorem XZ_scale_18 : toVec (XZ 18) = (scale : ℚ) • XCell6_18 :=
  toVec_eq_smul10 (XZ 18) scale XCell6_18
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)

theorem XZ_scale_19 : toVec (XZ 19) = (scale : ℚ) • XCell6_19 :=
  toVec_eq_smul10 (XZ 19) scale XCell6_19
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)

theorem XZ_scale (k : Fin 20) :
    toVec (XZ k) = (scale : ℚ) • XVec (6 : Fin 10) k :=
  forall_fin20 (P := fun k => toVec (XZ k) = (scale : ℚ) • XVec (6 : Fin 10) k)
    XZ_scale_0 XZ_scale_1 XZ_scale_2 XZ_scale_3 XZ_scale_4 XZ_scale_5 XZ_scale_6 XZ_scale_7 XZ_scale_8 XZ_scale_9 XZ_scale_10 XZ_scale_11 XZ_scale_12 XZ_scale_13 XZ_scale_14 XZ_scale_15 XZ_scale_16 XZ_scale_17 XZ_scale_18 XZ_scale_19 k

theorem AZ_scale_0 : toVec (AZ 0) = (scale : ℚ) • ACell0_7 :=
  toVec_eq_smul10 (AZ 0) scale ACell0_7
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)

theorem AZ_scale_1 : toVec (AZ 1) = (scale : ℚ) • ACell1_7 :=
  toVec_eq_smul10 (AZ 1) scale ACell1_7
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-16) scale (-4) (11) (by decide) (by decide))
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-16) scale (-4) (11) (by decide) (by decide))
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))

theorem AZ_scale_2 : toVec (AZ 2) = (scale : ℚ) • ACell2_7 :=
  toVec_eq_smul10 (AZ 2) scale ACell2_7
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-16) scale (-4) (11) (by decide) (by decide))
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-16) scale (-4) (11) (by decide) (by decide))
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))

theorem AZ_scale_3 : toVec (AZ 3) = (scale : ℚ) • ACell3_7 :=
  toVec_eq_smul10 (AZ 3) scale ACell3_7
    (eq_smul_zero scale)
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_zero scale)

theorem AZ_scale_4 : toVec (AZ 4) = (scale : ℚ) • ACell4_7 :=
  toVec_eq_smul10 (AZ 4) scale ACell4_7
    (eq_smul_zero scale)
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)

theorem AZ_scale_5 : toVec (AZ 5) = (scale : ℚ) • ACell5_7 :=
  toVec_eq_smul10 (AZ 5) scale ACell5_7
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-12) scale (-3) (11) (by decide) (by decide))
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)

theorem AZ_scale_6 : toVec (AZ 6) = (scale : ℚ) • ACell6_7 :=
  toVec_eq_smul10 (AZ 6) scale ACell6_7
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (4) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (4) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_zero scale)

theorem AZ_scale_7 : toVec (AZ 7) = (scale : ℚ) • ACell7_7 :=
  toVec_eq_smul10 (AZ 7) scale ACell7_7
    (eq_smul_div (-52) scale (-13) (11) (by decide) (by decide))
    (eq_smul_div (4) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))

theorem AZ_scale_8 : toVec (AZ 8) = (scale : ℚ) • ACell8_7 :=
  toVec_eq_smul10 (AZ 8) scale ACell8_7
    (eq_smul_zero scale)
    (eq_smul_div (4) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (4) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (4) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (4) scale (1) (11) (by decide) (by decide))

theorem AZ_scale_9 : toVec (AZ 9) = (scale : ℚ) • ACell9_7 :=
  toVec_eq_smul10 (AZ 9) scale ACell9_7
    (eq_smul_zero scale)
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (4) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (4) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (4) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (12) scale (3) (11) (by decide) (by decide))
    (eq_smul_div (4) scale (1) (11) (by decide) (by decide))

theorem AZ_scale_10 : toVec (AZ 10) = (scale : ℚ) • ACell10_7 :=
  toVec_eq_smul10 (AZ 10) scale ACell10_7
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (16) scale (4) (11) (by decide) (by decide))
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (16) scale (4) (11) (by decide) (by decide))
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))

theorem AZ_scale_11 : toVec (AZ 11) = (scale : ℚ) • ACell11_7 :=
  toVec_eq_smul10 (AZ 11) scale ACell11_7
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-16) scale (-4) (11) (by decide) (by decide))
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-16) scale (-4) (11) (by decide) (by decide))
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_zero scale)

theorem AZ_scale_12 : toVec (AZ 12) = (scale : ℚ) • ACell12_7 :=
  toVec_eq_smul10 (AZ 12) scale ACell12_7
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)

theorem AZ_scale_13 : toVec (AZ 13) = (scale : ℚ) • ACell13_7 :=
  toVec_eq_smul10 (AZ 13) scale ACell13_7
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (16) scale (4) (11) (by decide) (by decide))
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (16) scale (4) (11) (by decide) (by decide))
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))

theorem AZ_scale_14 : toVec (AZ 14) = (scale : ℚ) • ACell14_7 :=
  toVec_eq_smul10 (AZ 14) scale ACell14_7
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))

theorem AZ_scale_15 : toVec (AZ 15) = (scale : ℚ) • ACell15_7 :=
  toVec_eq_smul10 (AZ 15) scale ACell15_7
    (eq_smul_zero scale)
    (eq_smul_div (4) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (4) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (4) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (4) scale (1) (11) (by decide) (by decide))

theorem AZ_scale_16 : toVec (AZ 16) = (scale : ℚ) • ACell16_7 :=
  toVec_eq_smul10 (AZ 16) scale ACell16_7
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (4) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))

theorem AZ_scale_17 : toVec (AZ 17) = (scale : ℚ) • ACell17_7 :=
  toVec_eq_smul10 (AZ 17) scale ACell17_7
    (eq_smul_div (52) scale (13) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (4) scale (1) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (4) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))

theorem AZ_scale_18 : toVec (AZ 18) = (scale : ℚ) • ACell18_7 :=
  toVec_eq_smul10 (AZ 18) scale ACell18_7
    (eq_smul_div (4) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (12) scale (3) (11) (by decide) (by decide))
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (12) scale (3) (11) (by decide) (by decide))
    (eq_smul_div (12) scale (3) (11) (by decide) (by decide))
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (12) scale (3) (11) (by decide) (by decide))
    (eq_smul_div (4) scale (1) (11) (by decide) (by decide))

theorem AZ_scale_19 : toVec (AZ 19) = (scale : ℚ) • ACell19_7 :=
  toVec_eq_smul10 (AZ 19) scale ACell19_7
    (eq_smul_zero scale)
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (4) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (4) scale (1) (11) (by decide) (by decide))

theorem AZ_scale (k : Fin 20) :
    toVec (AZ k) = (scale : ℚ) • AVec k (7 : Fin 10) :=
  forall_fin20 (P := fun k => toVec (AZ k) = (scale : ℚ) • AVec k (7 : Fin 10))
    AZ_scale_0 AZ_scale_1 AZ_scale_2 AZ_scale_3 AZ_scale_4 AZ_scale_5 AZ_scale_6 AZ_scale_7 AZ_scale_8 AZ_scale_9 AZ_scale_10 AZ_scale_11 AZ_scale_12 AZ_scale_13 AZ_scale_14 AZ_scale_15 AZ_scale_16 AZ_scale_17 AZ_scale_18 AZ_scale_19 k

theorem entry_eq :
    (matrixMul XVec AVec) (6 : Fin 10) (7 : Fin 10) =
      ![0, 0, 0, 0, 0, 0, 0, 0, 0, 0] := by
  unfold matrixMul
  refine sum_mul_eq_of_scaled scale scale_ne_zero
    (fun k => XVec (6 : Fin 10) k)
    (fun k => AVec k (7 : Fin 10))
    XZ AZ XZ_scale AZ_scale entryZ rfl _ ?_
  rw [entryZ_eq, toVec_zeroZ_smul, vec_zero_eq]

theorem entry_eq_matrixOne :
    (matrixMul XVec AVec) (6 : Fin 10) (7 : Fin 10) =
      matrixOne (Fin 10) (6 : Fin 10) (7 : Fin 10) :=
  entry_eq.trans (matrixOne_off10 (6 : Fin 10) (7 : Fin 10) (by decide)).symm

end V14Formalization.D12PiecePASplitEntry6_7


namespace V14Formalization.D12PiecePASplitEntry6_8
open D12CyclotomicVec D12CyclotomicVecZ D12PiecePAData
def payloadSha256 : String := "76c6196f29afe1a8398af99502447f48ebeed4bcb3805fc5dbec693940bc04b0"

def scale : ℤ := 44

def XZ (k : Fin 20) : VecZ :=
  match k.val with
  | 0 => #v[-5, -47, -14, -20, -48, -22, -43, -18, -23, -46]
  | 1 => #v[13, 31, -8, 20, 26, 9, 28, 26, 6, 36]
  | 2 => #v[-9, -29, -20, -16, -17, -16, -8, -4, -7, -17]
  | 3 => #v[6, -12, 14, 12, -2, 8, -16, -4, -6, -22]
  | 4 => #v[-1, -26, -12, 15, -4, -19, -5, 14, -14, -25]
  | 5 => #v[8, 12, -14, 14, 2, -18, 6, 14, -6, 26]
  | 6 => #v[-32, -54, -12, -32, -36, -16, -38, -16, 0, -50]
  | 7 => #v[-10, -4, 0, -34, -10, 38, -8, -2, 32, 20]
  | 8 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  | 9 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  | 10 => #v[11, 0, -11, 0, -11, -22, -22, -11, 0, -11]
  | 11 => #v[11, 0, -11, 0, 11, 0, 0, 11, 0, -11]
  | 12 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  | 13 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  | 14 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  | 15 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  | 16 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  | 17 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  | 18 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  | 19 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  | _ => zeroZ

def AZ (k : Fin 20) : VecZ :=
  match k.val with
  | 0 => #v[0, -8, 0, -8, 0, 0, 8, 0, 0, 8]
  | 1 => #v[0, 0, -8, 8, 0, 0, 0, 0, 8, -8]
  | 2 => #v[0, -8, 0, 8, 0, 8, 0, -8, 0, 0]
  | 3 => #v[8, 8, 8, 8, 8, 8, 8, 0, 16, 16]
  | 4 => #v[-8, -8, -16, -16, -8, -8, 0, -8, -8, -8]
  | 5 => #v[-4, 0, 0, -4, 0, 4, -4, 8, -4, 4]
  | 6 => #v[0, 0, 0, -8, -4, -4, -12, -4, -4, -8]
  | 7 => #v[0, 4, 8, 4, 8, -4, 8, 4, 8, 4]
  | 8 => #v[-48, -4, 4, 0, 0, 4, -4, -4, 0, 8]
  | 9 => #v[-8, -12, -8, 0, -4, -4, 0, 0, -4, -4]
  | 10 => #v[0, -8, 8, 0, 0, 0, 0, 8, -8, 0]
  | 11 => #v[0, -16, -8, -8, -8, -8, -8, -8, -8, -16]
  | 12 => #v[8, 8, 16, 8, 8, 8, 16, 8, 8, 0]
  | 13 => #v[8, 8, 8, 8, 0, 8, 16, 8, 16, 8]
  | 14 => #v[-8, -8, -16, -8, -16, -8, -8, 0, -8, -8]
  | 15 => #v[-4, -4, 0, -8, -8, -4, 4, -4, -8, -8]
  | 16 => #v[-4, 0, -4, -8, -8, -4, 0, -4, 0, -12]
  | 17 => #v[-8, -12, -8, 0, -4, -4, 0, 0, -4, -4]
  | 18 => #v[52, 0, 0, 4, -4, -4, -4, -4, 4, 0]
  | 19 => #v[-4, 4, -8, 4, -4, 0, 4, 0, 0, 4]
  | _ => zeroZ

def entryZ : VecZ := sumFin (fun k => mulZ (XZ k) (AZ k))

theorem entryZ_eq : entryZ = zeroZ :=
  eq_of_eqZ (by decide +kernel)

theorem scale_ne_zero : scale ≠ 0 := by
  decide

theorem XZ_scale_0 : toVec (XZ 0) = (scale : ℚ) • XCell6_0 :=
  toVec_eq_smul10 (XZ 0) scale XCell6_0
    (eq_smul_div (-5) scale (-5) (44) (by decide) (by decide))
    (eq_smul_div (-47) scale (-47) (44) (by decide) (by decide))
    (eq_smul_div (-14) scale (-7) (22) (by decide) (by decide))
    (eq_smul_div (-20) scale (-5) (11) (by decide) (by decide))
    (eq_smul_div (-48) scale (-12) (11) (by decide) (by decide))
    (eq_smul_div (-22) scale (-1) (2) (by decide) (by decide))
    (eq_smul_div (-43) scale (-43) (44) (by decide) (by decide))
    (eq_smul_div (-18) scale (-9) (22) (by decide) (by decide))
    (eq_smul_div (-23) scale (-23) (44) (by decide) (by decide))
    (eq_smul_div (-46) scale (-23) (22) (by decide) (by decide))

theorem XZ_scale_1 : toVec (XZ 1) = (scale : ℚ) • XCell6_1 :=
  toVec_eq_smul10 (XZ 1) scale XCell6_1
    (eq_smul_div (13) scale (13) (44) (by decide) (by decide))
    (eq_smul_div (31) scale (31) (44) (by decide) (by decide))
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (20) scale (5) (11) (by decide) (by decide))
    (eq_smul_div (26) scale (13) (22) (by decide) (by decide))
    (eq_smul_div (9) scale (9) (44) (by decide) (by decide))
    (eq_smul_div (28) scale (7) (11) (by decide) (by decide))
    (eq_smul_div (26) scale (13) (22) (by decide) (by decide))
    (eq_smul_div (6) scale (3) (22) (by decide) (by decide))
    (eq_smul_div (36) scale (9) (11) (by decide) (by decide))

theorem XZ_scale_2 : toVec (XZ 2) = (scale : ℚ) • XCell6_2 :=
  toVec_eq_smul10 (XZ 2) scale XCell6_2
    (eq_smul_div (-9) scale (-9) (44) (by decide) (by decide))
    (eq_smul_div (-29) scale (-29) (44) (by decide) (by decide))
    (eq_smul_div (-20) scale (-5) (11) (by decide) (by decide))
    (eq_smul_div (-16) scale (-4) (11) (by decide) (by decide))
    (eq_smul_div (-17) scale (-17) (44) (by decide) (by decide))
    (eq_smul_div (-16) scale (-4) (11) (by decide) (by decide))
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-7) scale (-7) (44) (by decide) (by decide))
    (eq_smul_div (-17) scale (-17) (44) (by decide) (by decide))

theorem XZ_scale_3 : toVec (XZ 3) = (scale : ℚ) • XCell6_3 :=
  toVec_eq_smul10 (XZ 3) scale XCell6_3
    (eq_smul_div (6) scale (3) (22) (by decide) (by decide))
    (eq_smul_div (-12) scale (-3) (11) (by decide) (by decide))
    (eq_smul_div (14) scale (7) (22) (by decide) (by decide))
    (eq_smul_div (12) scale (3) (11) (by decide) (by decide))
    (eq_smul_div (-2) scale (-1) (22) (by decide) (by decide))
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (-16) scale (-4) (11) (by decide) (by decide))
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-6) scale (-3) (22) (by decide) (by decide))
    (eq_smul_div (-22) scale (-1) (2) (by decide) (by decide))

theorem XZ_scale_4 : toVec (XZ 4) = (scale : ℚ) • XCell6_4 :=
  toVec_eq_smul10 (XZ 4) scale XCell6_4
    (eq_smul_div (-1) scale (-1) (44) (by decide) (by decide))
    (eq_smul_div (-26) scale (-13) (22) (by decide) (by decide))
    (eq_smul_div (-12) scale (-3) (11) (by decide) (by decide))
    (eq_smul_div (15) scale (15) (44) (by decide) (by decide))
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-19) scale (-19) (44) (by decide) (by decide))
    (eq_smul_div (-5) scale (-5) (44) (by decide) (by decide))
    (eq_smul_div (14) scale (7) (22) (by decide) (by decide))
    (eq_smul_div (-14) scale (-7) (22) (by decide) (by decide))
    (eq_smul_div (-25) scale (-25) (44) (by decide) (by decide))

theorem XZ_scale_5 : toVec (XZ 5) = (scale : ℚ) • XCell6_5 :=
  toVec_eq_smul10 (XZ 5) scale XCell6_5
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (12) scale (3) (11) (by decide) (by decide))
    (eq_smul_div (-14) scale (-7) (22) (by decide) (by decide))
    (eq_smul_div (14) scale (7) (22) (by decide) (by decide))
    (eq_smul_div (2) scale (1) (22) (by decide) (by decide))
    (eq_smul_div (-18) scale (-9) (22) (by decide) (by decide))
    (eq_smul_div (6) scale (3) (22) (by decide) (by decide))
    (eq_smul_div (14) scale (7) (22) (by decide) (by decide))
    (eq_smul_div (-6) scale (-3) (22) (by decide) (by decide))
    (eq_smul_div (26) scale (13) (22) (by decide) (by decide))

theorem XZ_scale_6 : toVec (XZ 6) = (scale : ℚ) • XCell6_6 :=
  toVec_eq_smul10 (XZ 6) scale XCell6_6
    (eq_smul_div (-32) scale (-8) (11) (by decide) (by decide))
    (eq_smul_div (-54) scale (-27) (22) (by decide) (by decide))
    (eq_smul_div (-12) scale (-3) (11) (by decide) (by decide))
    (eq_smul_div (-32) scale (-8) (11) (by decide) (by decide))
    (eq_smul_div (-36) scale (-9) (11) (by decide) (by decide))
    (eq_smul_div (-16) scale (-4) (11) (by decide) (by decide))
    (eq_smul_div (-38) scale (-19) (22) (by decide) (by decide))
    (eq_smul_div (-16) scale (-4) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-50) scale (-25) (22) (by decide) (by decide))

theorem XZ_scale_7 : toVec (XZ 7) = (scale : ℚ) • XCell6_7 :=
  toVec_eq_smul10 (XZ 7) scale XCell6_7
    (eq_smul_div (-10) scale (-5) (22) (by decide) (by decide))
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-34) scale (-17) (22) (by decide) (by decide))
    (eq_smul_div (-10) scale (-5) (22) (by decide) (by decide))
    (eq_smul_div (38) scale (19) (22) (by decide) (by decide))
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-2) scale (-1) (22) (by decide) (by decide))
    (eq_smul_div (32) scale (8) (11) (by decide) (by decide))
    (eq_smul_div (20) scale (5) (11) (by decide) (by decide))

theorem XZ_scale_8 : toVec (XZ 8) = (scale : ℚ) • XCell6_8 :=
  toVec_eq_smul10 (XZ 8) scale XCell6_8
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)

theorem XZ_scale_9 : toVec (XZ 9) = (scale : ℚ) • XCell6_9 :=
  toVec_eq_smul10 (XZ 9) scale XCell6_9
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)

theorem XZ_scale_10 : toVec (XZ 10) = (scale : ℚ) • XCell6_10 :=
  toVec_eq_smul10 (XZ 10) scale XCell6_10
    (eq_smul_div (11) scale (1) (4) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-11) scale (-1) (4) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-11) scale (-1) (4) (by decide) (by decide))
    (eq_smul_div (-22) scale (-1) (2) (by decide) (by decide))
    (eq_smul_div (-22) scale (-1) (2) (by decide) (by decide))
    (eq_smul_div (-11) scale (-1) (4) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-11) scale (-1) (4) (by decide) (by decide))

theorem XZ_scale_11 : toVec (XZ 11) = (scale : ℚ) • XCell6_11 :=
  toVec_eq_smul10 (XZ 11) scale XCell6_11
    (eq_smul_div (11) scale (1) (4) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-11) scale (-1) (4) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (11) scale (1) (4) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (11) scale (1) (4) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-11) scale (-1) (4) (by decide) (by decide))

theorem XZ_scale_12 : toVec (XZ 12) = (scale : ℚ) • XCell6_12 :=
  toVec_eq_smul10 (XZ 12) scale XCell6_12
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)

theorem XZ_scale_13 : toVec (XZ 13) = (scale : ℚ) • XCell6_13 :=
  toVec_eq_smul10 (XZ 13) scale XCell6_13
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)

theorem XZ_scale_14 : toVec (XZ 14) = (scale : ℚ) • XCell6_14 :=
  toVec_eq_smul10 (XZ 14) scale XCell6_14
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)

theorem XZ_scale_15 : toVec (XZ 15) = (scale : ℚ) • XCell6_15 :=
  toVec_eq_smul10 (XZ 15) scale XCell6_15
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)

theorem XZ_scale_16 : toVec (XZ 16) = (scale : ℚ) • XCell6_16 :=
  toVec_eq_smul10 (XZ 16) scale XCell6_16
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)

theorem XZ_scale_17 : toVec (XZ 17) = (scale : ℚ) • XCell6_17 :=
  toVec_eq_smul10 (XZ 17) scale XCell6_17
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)

theorem XZ_scale_18 : toVec (XZ 18) = (scale : ℚ) • XCell6_18 :=
  toVec_eq_smul10 (XZ 18) scale XCell6_18
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)

theorem XZ_scale_19 : toVec (XZ 19) = (scale : ℚ) • XCell6_19 :=
  toVec_eq_smul10 (XZ 19) scale XCell6_19
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)

theorem XZ_scale (k : Fin 20) :
    toVec (XZ k) = (scale : ℚ) • XVec (6 : Fin 10) k :=
  forall_fin20 (P := fun k => toVec (XZ k) = (scale : ℚ) • XVec (6 : Fin 10) k)
    XZ_scale_0 XZ_scale_1 XZ_scale_2 XZ_scale_3 XZ_scale_4 XZ_scale_5 XZ_scale_6 XZ_scale_7 XZ_scale_8 XZ_scale_9 XZ_scale_10 XZ_scale_11 XZ_scale_12 XZ_scale_13 XZ_scale_14 XZ_scale_15 XZ_scale_16 XZ_scale_17 XZ_scale_18 XZ_scale_19 k

theorem AZ_scale_0 : toVec (AZ 0) = (scale : ℚ) • ACell0_8 :=
  toVec_eq_smul10 (AZ 0) scale ACell0_8
    (eq_smul_zero scale)
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))

theorem AZ_scale_1 : toVec (AZ 1) = (scale : ℚ) • ACell1_8 :=
  toVec_eq_smul10 (AZ 1) scale ACell1_8
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))

theorem AZ_scale_2 : toVec (AZ 2) = (scale : ℚ) • ACell2_8 :=
  toVec_eq_smul10 (AZ 2) scale ACell2_8
    (eq_smul_zero scale)
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)

theorem AZ_scale_3 : toVec (AZ 3) = (scale : ℚ) • ACell3_8 :=
  toVec_eq_smul10 (AZ 3) scale ACell3_8
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (16) scale (4) (11) (by decide) (by decide))
    (eq_smul_div (16) scale (4) (11) (by decide) (by decide))

theorem AZ_scale_4 : toVec (AZ 4) = (scale : ℚ) • ACell4_8 :=
  toVec_eq_smul10 (AZ 4) scale ACell4_8
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-16) scale (-4) (11) (by decide) (by decide))
    (eq_smul_div (-16) scale (-4) (11) (by decide) (by decide))
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))

theorem AZ_scale_5 : toVec (AZ 5) = (scale : ℚ) • ACell5_8 :=
  toVec_eq_smul10 (AZ 5) scale ACell5_8
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (4) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (4) scale (1) (11) (by decide) (by decide))

theorem AZ_scale_6 : toVec (AZ 6) = (scale : ℚ) • ACell6_8 :=
  toVec_eq_smul10 (AZ 6) scale ACell6_8
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-12) scale (-3) (11) (by decide) (by decide))
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))

theorem AZ_scale_7 : toVec (AZ 7) = (scale : ℚ) • ACell7_8 :=
  toVec_eq_smul10 (AZ 7) scale ACell7_8
    (eq_smul_zero scale)
    (eq_smul_div (4) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (4) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (4) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (4) scale (1) (11) (by decide) (by decide))

theorem AZ_scale_8 : toVec (AZ 8) = (scale : ℚ) • ACell8_8 :=
  toVec_eq_smul10 (AZ 8) scale ACell8_8
    (eq_smul_div (-48) scale (-12) (11) (by decide) (by decide))
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (4) scale (1) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (4) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))

theorem AZ_scale_9 : toVec (AZ 9) = (scale : ℚ) • ACell9_8 :=
  toVec_eq_smul10 (AZ 9) scale ACell9_8
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-12) scale (-3) (11) (by decide) (by decide))
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))

theorem AZ_scale_10 : toVec (AZ 10) = (scale : ℚ) • ACell10_8 :=
  toVec_eq_smul10 (AZ 10) scale ACell10_8
    (eq_smul_zero scale)
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_zero scale)

theorem AZ_scale_11 : toVec (AZ 11) = (scale : ℚ) • ACell11_8 :=
  toVec_eq_smul10 (AZ 11) scale ACell11_8
    (eq_smul_zero scale)
    (eq_smul_div (-16) scale (-4) (11) (by decide) (by decide))
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-16) scale (-4) (11) (by decide) (by decide))

theorem AZ_scale_12 : toVec (AZ 12) = (scale : ℚ) • ACell12_8 :=
  toVec_eq_smul10 (AZ 12) scale ACell12_8
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (16) scale (4) (11) (by decide) (by decide))
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (16) scale (4) (11) (by decide) (by decide))
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_zero scale)

theorem AZ_scale_13 : toVec (AZ 13) = (scale : ℚ) • ACell13_8 :=
  toVec_eq_smul10 (AZ 13) scale ACell13_8
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (16) scale (4) (11) (by decide) (by decide))
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (16) scale (4) (11) (by decide) (by decide))
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))

theorem AZ_scale_14 : toVec (AZ 14) = (scale : ℚ) • ACell14_8 :=
  toVec_eq_smul10 (AZ 14) scale ACell14_8
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-16) scale (-4) (11) (by decide) (by decide))
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-16) scale (-4) (11) (by decide) (by decide))
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))

theorem AZ_scale_15 : toVec (AZ 15) = (scale : ℚ) • ACell15_8 :=
  toVec_eq_smul10 (AZ 15) scale ACell15_8
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (4) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))

theorem AZ_scale_16 : toVec (AZ 16) = (scale : ℚ) • ACell16_8 :=
  toVec_eq_smul10 (AZ 16) scale ACell16_8
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-12) scale (-3) (11) (by decide) (by decide))

theorem AZ_scale_17 : toVec (AZ 17) = (scale : ℚ) • ACell17_8 :=
  toVec_eq_smul10 (AZ 17) scale ACell17_8
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-12) scale (-3) (11) (by decide) (by decide))
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))

theorem AZ_scale_18 : toVec (AZ 18) = (scale : ℚ) • ACell18_8 :=
  toVec_eq_smul10 (AZ 18) scale ACell18_8
    (eq_smul_div (52) scale (13) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (4) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (4) scale (1) (11) (by decide) (by decide))
    (eq_smul_zero scale)

theorem AZ_scale_19 : toVec (AZ 19) = (scale : ℚ) • ACell19_8 :=
  toVec_eq_smul10 (AZ 19) scale ACell19_8
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (4) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (4) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (4) scale (1) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (4) scale (1) (11) (by decide) (by decide))

theorem AZ_scale (k : Fin 20) :
    toVec (AZ k) = (scale : ℚ) • AVec k (8 : Fin 10) :=
  forall_fin20 (P := fun k => toVec (AZ k) = (scale : ℚ) • AVec k (8 : Fin 10))
    AZ_scale_0 AZ_scale_1 AZ_scale_2 AZ_scale_3 AZ_scale_4 AZ_scale_5 AZ_scale_6 AZ_scale_7 AZ_scale_8 AZ_scale_9 AZ_scale_10 AZ_scale_11 AZ_scale_12 AZ_scale_13 AZ_scale_14 AZ_scale_15 AZ_scale_16 AZ_scale_17 AZ_scale_18 AZ_scale_19 k

theorem entry_eq :
    (matrixMul XVec AVec) (6 : Fin 10) (8 : Fin 10) =
      ![0, 0, 0, 0, 0, 0, 0, 0, 0, 0] := by
  unfold matrixMul
  refine sum_mul_eq_of_scaled scale scale_ne_zero
    (fun k => XVec (6 : Fin 10) k)
    (fun k => AVec k (8 : Fin 10))
    XZ AZ XZ_scale AZ_scale entryZ rfl _ ?_
  rw [entryZ_eq, toVec_zeroZ_smul, vec_zero_eq]

theorem entry_eq_matrixOne :
    (matrixMul XVec AVec) (6 : Fin 10) (8 : Fin 10) =
      matrixOne (Fin 10) (6 : Fin 10) (8 : Fin 10) :=
  entry_eq.trans (matrixOne_off10 (6 : Fin 10) (8 : Fin 10) (by decide)).symm

end V14Formalization.D12PiecePASplitEntry6_8


namespace V14Formalization.D12PiecePASplitEntry6_9
open D12CyclotomicVec D12CyclotomicVecZ D12PiecePAData
def payloadSha256 : String := "76c6196f29afe1a8398af99502447f48ebeed4bcb3805fc5dbec693940bc04b0"

def scale : ℤ := 44

def XZ (k : Fin 20) : VecZ :=
  match k.val with
  | 0 => #v[-5, -47, -14, -20, -48, -22, -43, -18, -23, -46]
  | 1 => #v[13, 31, -8, 20, 26, 9, 28, 26, 6, 36]
  | 2 => #v[-9, -29, -20, -16, -17, -16, -8, -4, -7, -17]
  | 3 => #v[6, -12, 14, 12, -2, 8, -16, -4, -6, -22]
  | 4 => #v[-1, -26, -12, 15, -4, -19, -5, 14, -14, -25]
  | 5 => #v[8, 12, -14, 14, 2, -18, 6, 14, -6, 26]
  | 6 => #v[-32, -54, -12, -32, -36, -16, -38, -16, 0, -50]
  | 7 => #v[-10, -4, 0, -34, -10, 38, -8, -2, 32, 20]
  | 8 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  | 9 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  | 10 => #v[11, 0, -11, 0, -11, -22, -22, -11, 0, -11]
  | 11 => #v[11, 0, -11, 0, 11, 0, 0, 11, 0, -11]
  | 12 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  | 13 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  | 14 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  | 15 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  | 16 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  | 17 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  | 18 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  | 19 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  | _ => zeroZ

def AZ (k : Fin 20) : VecZ :=
  match k.val with
  | 0 => #v[0, 0, 8, 0, -8, 0, -8, 0, 8, 0]
  | 1 => #v[0, -8, 0, 0, 0, -8, 0, 0, 8, 8]
  | 2 => #v[8, 8, 8, 8, 0, 16, 8, 8, 8, 16]
  | 3 => #v[8, 8, 0, 8, 8, 16, 8, 16, 8, 8]
  | 4 => #v[0, 0, 0, 0, 8, -8, -8, 8, 0, 0]
  | 5 => #v[12, 8, 12, 8, 4, 4, 8, 12, 8, 12]
  | 6 => #v[8, 4, 0, 4, 4, 0, 4, 8, 0, 12]
  | 7 => #v[0, 8, 4, 4, 8, 0, 0, 4, 12, 4]
  | 8 => #v[-8, -12, -8, 0, -4, -4, 0, 0, -4, -4]
  | 9 => #v[-44, 8, 4, 4, 12, 4, 4, 8, 0, 0]
  | 10 => #v[8, 8, 16, 16, 8, 8, 0, 8, 8, 8]
  | 11 => #v[8, 8, 16, 8, 16, 8, 8, 0, 8, 8]
  | 12 => #v[0, 0, 0, 0, 0, 0, 8, -8, -8, 8]
  | 13 => #v[0, 0, -8, 8, 0, 0, 0, 8, -8, 0]
  | 14 => #v[-8, 0, -8, 0, 8, 0, 0, 0, 0, 8]
  | 15 => #v[-4, -4, 0, -8, -12, -8, 0, -4, -4, 0]
  | 16 => #v[8, 4, 4, 8, 0, 0, 4, 12, 4, 0]
  | 17 => #v[-8, -8, -4, -12, -12, -12, -12, -4, -8, -8]
  | 18 => #v[-8, -4, 0, -4, -4, 0, -4, -8, 0, -12]
  | 19 => #v[56, 0, 4, 0, 4, 8, 8, 4, 0, 4]
  | _ => zeroZ

def entryZ : VecZ := sumFin (fun k => mulZ (XZ k) (AZ k))

theorem entryZ_eq : entryZ = zeroZ :=
  eq_of_eqZ (by decide +kernel)

theorem scale_ne_zero : scale ≠ 0 := by
  decide

theorem XZ_scale_0 : toVec (XZ 0) = (scale : ℚ) • XCell6_0 :=
  toVec_eq_smul10 (XZ 0) scale XCell6_0
    (eq_smul_div (-5) scale (-5) (44) (by decide) (by decide))
    (eq_smul_div (-47) scale (-47) (44) (by decide) (by decide))
    (eq_smul_div (-14) scale (-7) (22) (by decide) (by decide))
    (eq_smul_div (-20) scale (-5) (11) (by decide) (by decide))
    (eq_smul_div (-48) scale (-12) (11) (by decide) (by decide))
    (eq_smul_div (-22) scale (-1) (2) (by decide) (by decide))
    (eq_smul_div (-43) scale (-43) (44) (by decide) (by decide))
    (eq_smul_div (-18) scale (-9) (22) (by decide) (by decide))
    (eq_smul_div (-23) scale (-23) (44) (by decide) (by decide))
    (eq_smul_div (-46) scale (-23) (22) (by decide) (by decide))

theorem XZ_scale_1 : toVec (XZ 1) = (scale : ℚ) • XCell6_1 :=
  toVec_eq_smul10 (XZ 1) scale XCell6_1
    (eq_smul_div (13) scale (13) (44) (by decide) (by decide))
    (eq_smul_div (31) scale (31) (44) (by decide) (by decide))
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (20) scale (5) (11) (by decide) (by decide))
    (eq_smul_div (26) scale (13) (22) (by decide) (by decide))
    (eq_smul_div (9) scale (9) (44) (by decide) (by decide))
    (eq_smul_div (28) scale (7) (11) (by decide) (by decide))
    (eq_smul_div (26) scale (13) (22) (by decide) (by decide))
    (eq_smul_div (6) scale (3) (22) (by decide) (by decide))
    (eq_smul_div (36) scale (9) (11) (by decide) (by decide))

theorem XZ_scale_2 : toVec (XZ 2) = (scale : ℚ) • XCell6_2 :=
  toVec_eq_smul10 (XZ 2) scale XCell6_2
    (eq_smul_div (-9) scale (-9) (44) (by decide) (by decide))
    (eq_smul_div (-29) scale (-29) (44) (by decide) (by decide))
    (eq_smul_div (-20) scale (-5) (11) (by decide) (by decide))
    (eq_smul_div (-16) scale (-4) (11) (by decide) (by decide))
    (eq_smul_div (-17) scale (-17) (44) (by decide) (by decide))
    (eq_smul_div (-16) scale (-4) (11) (by decide) (by decide))
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-7) scale (-7) (44) (by decide) (by decide))
    (eq_smul_div (-17) scale (-17) (44) (by decide) (by decide))

theorem XZ_scale_3 : toVec (XZ 3) = (scale : ℚ) • XCell6_3 :=
  toVec_eq_smul10 (XZ 3) scale XCell6_3
    (eq_smul_div (6) scale (3) (22) (by decide) (by decide))
    (eq_smul_div (-12) scale (-3) (11) (by decide) (by decide))
    (eq_smul_div (14) scale (7) (22) (by decide) (by decide))
    (eq_smul_div (12) scale (3) (11) (by decide) (by decide))
    (eq_smul_div (-2) scale (-1) (22) (by decide) (by decide))
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (-16) scale (-4) (11) (by decide) (by decide))
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-6) scale (-3) (22) (by decide) (by decide))
    (eq_smul_div (-22) scale (-1) (2) (by decide) (by decide))

theorem XZ_scale_4 : toVec (XZ 4) = (scale : ℚ) • XCell6_4 :=
  toVec_eq_smul10 (XZ 4) scale XCell6_4
    (eq_smul_div (-1) scale (-1) (44) (by decide) (by decide))
    (eq_smul_div (-26) scale (-13) (22) (by decide) (by decide))
    (eq_smul_div (-12) scale (-3) (11) (by decide) (by decide))
    (eq_smul_div (15) scale (15) (44) (by decide) (by decide))
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-19) scale (-19) (44) (by decide) (by decide))
    (eq_smul_div (-5) scale (-5) (44) (by decide) (by decide))
    (eq_smul_div (14) scale (7) (22) (by decide) (by decide))
    (eq_smul_div (-14) scale (-7) (22) (by decide) (by decide))
    (eq_smul_div (-25) scale (-25) (44) (by decide) (by decide))

theorem XZ_scale_5 : toVec (XZ 5) = (scale : ℚ) • XCell6_5 :=
  toVec_eq_smul10 (XZ 5) scale XCell6_5
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (12) scale (3) (11) (by decide) (by decide))
    (eq_smul_div (-14) scale (-7) (22) (by decide) (by decide))
    (eq_smul_div (14) scale (7) (22) (by decide) (by decide))
    (eq_smul_div (2) scale (1) (22) (by decide) (by decide))
    (eq_smul_div (-18) scale (-9) (22) (by decide) (by decide))
    (eq_smul_div (6) scale (3) (22) (by decide) (by decide))
    (eq_smul_div (14) scale (7) (22) (by decide) (by decide))
    (eq_smul_div (-6) scale (-3) (22) (by decide) (by decide))
    (eq_smul_div (26) scale (13) (22) (by decide) (by decide))

theorem XZ_scale_6 : toVec (XZ 6) = (scale : ℚ) • XCell6_6 :=
  toVec_eq_smul10 (XZ 6) scale XCell6_6
    (eq_smul_div (-32) scale (-8) (11) (by decide) (by decide))
    (eq_smul_div (-54) scale (-27) (22) (by decide) (by decide))
    (eq_smul_div (-12) scale (-3) (11) (by decide) (by decide))
    (eq_smul_div (-32) scale (-8) (11) (by decide) (by decide))
    (eq_smul_div (-36) scale (-9) (11) (by decide) (by decide))
    (eq_smul_div (-16) scale (-4) (11) (by decide) (by decide))
    (eq_smul_div (-38) scale (-19) (22) (by decide) (by decide))
    (eq_smul_div (-16) scale (-4) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-50) scale (-25) (22) (by decide) (by decide))

theorem XZ_scale_7 : toVec (XZ 7) = (scale : ℚ) • XCell6_7 :=
  toVec_eq_smul10 (XZ 7) scale XCell6_7
    (eq_smul_div (-10) scale (-5) (22) (by decide) (by decide))
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-34) scale (-17) (22) (by decide) (by decide))
    (eq_smul_div (-10) scale (-5) (22) (by decide) (by decide))
    (eq_smul_div (38) scale (19) (22) (by decide) (by decide))
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-2) scale (-1) (22) (by decide) (by decide))
    (eq_smul_div (32) scale (8) (11) (by decide) (by decide))
    (eq_smul_div (20) scale (5) (11) (by decide) (by decide))

theorem XZ_scale_8 : toVec (XZ 8) = (scale : ℚ) • XCell6_8 :=
  toVec_eq_smul10 (XZ 8) scale XCell6_8
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)

theorem XZ_scale_9 : toVec (XZ 9) = (scale : ℚ) • XCell6_9 :=
  toVec_eq_smul10 (XZ 9) scale XCell6_9
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)

theorem XZ_scale_10 : toVec (XZ 10) = (scale : ℚ) • XCell6_10 :=
  toVec_eq_smul10 (XZ 10) scale XCell6_10
    (eq_smul_div (11) scale (1) (4) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-11) scale (-1) (4) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-11) scale (-1) (4) (by decide) (by decide))
    (eq_smul_div (-22) scale (-1) (2) (by decide) (by decide))
    (eq_smul_div (-22) scale (-1) (2) (by decide) (by decide))
    (eq_smul_div (-11) scale (-1) (4) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-11) scale (-1) (4) (by decide) (by decide))

theorem XZ_scale_11 : toVec (XZ 11) = (scale : ℚ) • XCell6_11 :=
  toVec_eq_smul10 (XZ 11) scale XCell6_11
    (eq_smul_div (11) scale (1) (4) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-11) scale (-1) (4) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (11) scale (1) (4) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (11) scale (1) (4) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-11) scale (-1) (4) (by decide) (by decide))

theorem XZ_scale_12 : toVec (XZ 12) = (scale : ℚ) • XCell6_12 :=
  toVec_eq_smul10 (XZ 12) scale XCell6_12
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)

theorem XZ_scale_13 : toVec (XZ 13) = (scale : ℚ) • XCell6_13 :=
  toVec_eq_smul10 (XZ 13) scale XCell6_13
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)

theorem XZ_scale_14 : toVec (XZ 14) = (scale : ℚ) • XCell6_14 :=
  toVec_eq_smul10 (XZ 14) scale XCell6_14
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)

theorem XZ_scale_15 : toVec (XZ 15) = (scale : ℚ) • XCell6_15 :=
  toVec_eq_smul10 (XZ 15) scale XCell6_15
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)

theorem XZ_scale_16 : toVec (XZ 16) = (scale : ℚ) • XCell6_16 :=
  toVec_eq_smul10 (XZ 16) scale XCell6_16
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)

theorem XZ_scale_17 : toVec (XZ 17) = (scale : ℚ) • XCell6_17 :=
  toVec_eq_smul10 (XZ 17) scale XCell6_17
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)

theorem XZ_scale_18 : toVec (XZ 18) = (scale : ℚ) • XCell6_18 :=
  toVec_eq_smul10 (XZ 18) scale XCell6_18
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)

theorem XZ_scale_19 : toVec (XZ 19) = (scale : ℚ) • XCell6_19 :=
  toVec_eq_smul10 (XZ 19) scale XCell6_19
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)

theorem XZ_scale (k : Fin 20) :
    toVec (XZ k) = (scale : ℚ) • XVec (6 : Fin 10) k :=
  forall_fin20 (P := fun k => toVec (XZ k) = (scale : ℚ) • XVec (6 : Fin 10) k)
    XZ_scale_0 XZ_scale_1 XZ_scale_2 XZ_scale_3 XZ_scale_4 XZ_scale_5 XZ_scale_6 XZ_scale_7 XZ_scale_8 XZ_scale_9 XZ_scale_10 XZ_scale_11 XZ_scale_12 XZ_scale_13 XZ_scale_14 XZ_scale_15 XZ_scale_16 XZ_scale_17 XZ_scale_18 XZ_scale_19 k

theorem AZ_scale_0 : toVec (AZ 0) = (scale : ℚ) • ACell0_9 :=
  toVec_eq_smul10 (AZ 0) scale ACell0_9
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_zero scale)

theorem AZ_scale_1 : toVec (AZ 1) = (scale : ℚ) • ACell1_9 :=
  toVec_eq_smul10 (AZ 1) scale ACell1_9
    (eq_smul_zero scale)
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))

theorem AZ_scale_2 : toVec (AZ 2) = (scale : ℚ) • ACell2_9 :=
  toVec_eq_smul10 (AZ 2) scale ACell2_9
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (16) scale (4) (11) (by decide) (by decide))
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (16) scale (4) (11) (by decide) (by decide))

theorem AZ_scale_3 : toVec (AZ 3) = (scale : ℚ) • ACell3_9 :=
  toVec_eq_smul10 (AZ 3) scale ACell3_9
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (16) scale (4) (11) (by decide) (by decide))
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (16) scale (4) (11) (by decide) (by decide))
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))

theorem AZ_scale_4 : toVec (AZ 4) = (scale : ℚ) • ACell4_9 :=
  toVec_eq_smul10 (AZ 4) scale ACell4_9
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)

theorem AZ_scale_5 : toVec (AZ 5) = (scale : ℚ) • ACell5_9 :=
  toVec_eq_smul10 (AZ 5) scale ACell5_9
    (eq_smul_div (12) scale (3) (11) (by decide) (by decide))
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (12) scale (3) (11) (by decide) (by decide))
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (4) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (4) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (12) scale (3) (11) (by decide) (by decide))
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (12) scale (3) (11) (by decide) (by decide))

theorem AZ_scale_6 : toVec (AZ 6) = (scale : ℚ) • ACell6_9 :=
  toVec_eq_smul10 (AZ 6) scale ACell6_9
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (4) scale (1) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (4) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (4) scale (1) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (4) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (12) scale (3) (11) (by decide) (by decide))

theorem AZ_scale_7 : toVec (AZ 7) = (scale : ℚ) • ACell7_9 :=
  toVec_eq_smul10 (AZ 7) scale ACell7_9
    (eq_smul_zero scale)
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (4) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (4) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (4) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (12) scale (3) (11) (by decide) (by decide))
    (eq_smul_div (4) scale (1) (11) (by decide) (by decide))

theorem AZ_scale_8 : toVec (AZ 8) = (scale : ℚ) • ACell8_9 :=
  toVec_eq_smul10 (AZ 8) scale ACell8_9
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-12) scale (-3) (11) (by decide) (by decide))
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))

theorem AZ_scale_9 : toVec (AZ 9) = (scale : ℚ) • ACell9_9 :=
  toVec_eq_smul10 (AZ 9) scale ACell9_9
    (eq_smul_int (-44) scale (-1) (by decide))
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (4) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (4) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (12) scale (3) (11) (by decide) (by decide))
    (eq_smul_div (4) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (4) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)

theorem AZ_scale_10 : toVec (AZ 10) = (scale : ℚ) • ACell10_9 :=
  toVec_eq_smul10 (AZ 10) scale ACell10_9
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (16) scale (4) (11) (by decide) (by decide))
    (eq_smul_div (16) scale (4) (11) (by decide) (by decide))
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))

theorem AZ_scale_11 : toVec (AZ 11) = (scale : ℚ) • ACell11_9 :=
  toVec_eq_smul10 (AZ 11) scale ACell11_9
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (16) scale (4) (11) (by decide) (by decide))
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (16) scale (4) (11) (by decide) (by decide))
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))

theorem AZ_scale_12 : toVec (AZ 12) = (scale : ℚ) • ACell12_9 :=
  toVec_eq_smul10 (AZ 12) scale ACell12_9
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))

theorem AZ_scale_13 : toVec (AZ 13) = (scale : ℚ) • ACell13_9 :=
  toVec_eq_smul10 (AZ 13) scale ACell13_9
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_zero scale)

theorem AZ_scale_14 : toVec (AZ 14) = (scale : ℚ) • ACell14_9 :=
  toVec_eq_smul10 (AZ 14) scale ACell14_9
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))

theorem AZ_scale_15 : toVec (AZ 15) = (scale : ℚ) • ACell15_9 :=
  toVec_eq_smul10 (AZ 15) scale ACell15_9
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-12) scale (-3) (11) (by decide) (by decide))
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_zero scale)

theorem AZ_scale_16 : toVec (AZ 16) = (scale : ℚ) • ACell16_9 :=
  toVec_eq_smul10 (AZ 16) scale ACell16_9
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (4) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (4) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (4) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (12) scale (3) (11) (by decide) (by decide))
    (eq_smul_div (4) scale (1) (11) (by decide) (by decide))
    (eq_smul_zero scale)

theorem AZ_scale_17 : toVec (AZ 17) = (scale : ℚ) • ACell17_9 :=
  toVec_eq_smul10 (AZ 17) scale ACell17_9
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-12) scale (-3) (11) (by decide) (by decide))
    (eq_smul_div (-12) scale (-3) (11) (by decide) (by decide))
    (eq_smul_div (-12) scale (-3) (11) (by decide) (by decide))
    (eq_smul_div (-12) scale (-3) (11) (by decide) (by decide))
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))

theorem AZ_scale_18 : toVec (AZ 18) = (scale : ℚ) • ACell18_9 :=
  toVec_eq_smul10 (AZ 18) scale ACell18_9
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-4) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-8) scale (-2) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-12) scale (-3) (11) (by decide) (by decide))

theorem AZ_scale_19 : toVec (AZ 19) = (scale : ℚ) • ACell19_9 :=
  toVec_eq_smul10 (AZ 19) scale ACell19_9
    (eq_smul_div (56) scale (14) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (4) scale (1) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (4) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (8) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (4) scale (1) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (4) scale (1) (11) (by decide) (by decide))

theorem AZ_scale (k : Fin 20) :
    toVec (AZ k) = (scale : ℚ) • AVec k (9 : Fin 10) :=
  forall_fin20 (P := fun k => toVec (AZ k) = (scale : ℚ) • AVec k (9 : Fin 10))
    AZ_scale_0 AZ_scale_1 AZ_scale_2 AZ_scale_3 AZ_scale_4 AZ_scale_5 AZ_scale_6 AZ_scale_7 AZ_scale_8 AZ_scale_9 AZ_scale_10 AZ_scale_11 AZ_scale_12 AZ_scale_13 AZ_scale_14 AZ_scale_15 AZ_scale_16 AZ_scale_17 AZ_scale_18 AZ_scale_19 k

theorem entry_eq :
    (matrixMul XVec AVec) (6 : Fin 10) (9 : Fin 10) =
      ![0, 0, 0, 0, 0, 0, 0, 0, 0, 0] := by
  unfold matrixMul
  refine sum_mul_eq_of_scaled scale scale_ne_zero
    (fun k => XVec (6 : Fin 10) k)
    (fun k => AVec k (9 : Fin 10))
    XZ AZ XZ_scale AZ_scale entryZ rfl _ ?_
  rw [entryZ_eq, toVec_zeroZ_smul, vec_zero_eq]

theorem entry_eq_matrixOne :
    (matrixMul XVec AVec) (6 : Fin 10) (9 : Fin 10) =
      matrixOne (Fin 10) (6 : Fin 10) (9 : Fin 10) :=
  entry_eq.trans (matrixOne_off10 (6 : Fin 10) (9 : Fin 10) (by decide)).symm

end V14Formalization.D12PiecePASplitEntry6_9


namespace V14Formalization.D12PiecePASplitRow6
open D12CyclotomicVec D12PiecePAData

public theorem row_eq (j : Fin 10) :
    (matrixMul XVec AVec) (6 : Fin 10) j =
      matrixOne (Fin 10) (6 : Fin 10) j :=
  D12CyclotomicVecZ.forall_fin10
    (P := fun j => (matrixMul XVec AVec) (6 : Fin 10) j = matrixOne (Fin 10) (6 : Fin 10) j)
    D12PiecePASplitEntry6_0.entry_eq_matrixOne
    D12PiecePASplitEntry6_1.entry_eq_matrixOne
    D12PiecePASplitEntry6_2.entry_eq_matrixOne
    D12PiecePASplitEntry6_3.entry_eq_matrixOne
    D12PiecePASplitEntry6_4.entry_eq_matrixOne
    D12PiecePASplitEntry6_5.entry_eq_matrixOne
    D12PiecePASplitEntry6_6.entry_eq_matrixOne
    D12PiecePASplitEntry6_7.entry_eq_matrixOne
    D12PiecePASplitEntry6_8.entry_eq_matrixOne
    D12PiecePASplitEntry6_9.entry_eq_matrixOne
    j

end V14Formalization.D12PiecePASplitRow6
