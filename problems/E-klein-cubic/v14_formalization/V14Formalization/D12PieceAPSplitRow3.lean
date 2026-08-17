/- AP split identity row 3: entry certificates inlined. Auto-generated. -/
module

public import V14Formalization.D12PieceAPData
public import V14Formalization.D12CyclotomicVecZ
public import V14Formalization.D12VecScaleIntro

noncomputable section
open Matrix

namespace V14Formalization.D12PieceAPSplitEntry3_0
open D12CyclotomicVec D12CyclotomicVecZ D12PieceAPData
def payloadSha256 : String := "76c6196f29afe1a8398af99502447f48ebeed4bcb3805fc5dbec693940bc04b0"

def scale : ℤ := 66

def XZ (k : Fin 20) : VecZ :=
  match k.val with
  | 0 => #v[41, 40, 112, 50, 35, 92, 63, 53, 29, 123]
  | 1 => #v[-7, -28, 10, 29, -3, -18, -3, 10, -2, 45]
  | 2 => #v[-130, 14, -151, -73, -55, -110, -37, -135, 19, -222]
  | 3 => #v[171, 16, 5, 18, 25, 84, -13, 116, -33, 73]
  | 4 => #v[7, 32, 17, -25, -25, 6, 39, 1, 2, -10]
  | 5 => #v[-178, -66, -88, -100, -132, -118, -22, -184, -60, -108]
  | 6 => #v[24, -28, 16, -36, -2, 48, 2, -18, -62, 78]
  | 7 => #v[-226, -6, -154, -134, -112, -126, -4, -250, -4, -194]
  | 8 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  | 9 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  | 10 => #v[22, 55, 66, 44, 0, 0, 44, 55, 66, 11]
  | 11 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
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
  | 0 => #v[60, -6, 0, 0, -6, 6, 12, 6, -6, 0]
  | 1 => #v[-6, 0, 6, -6, 12, -6, 6, 0, -6, 0]
  | 2 => #v[6, -6, -6, -6, -6, 6, 0, 0, 12, 0]
  | 3 => #v[12, 6, 6, 12, 0, 0, 6, 18, 6, 0]
  | 4 => #v[-6, 12, -6, 0, -6, 0, 6, 6, 0, -6]
  | 5 => #v[0, 0, 9, 0, 0, -9, -9, 0, 0, 9]
  | 6 => #v[0, 9, -9, 0, 0, 0, 0, -9, 9, 0]
  | 7 => #v[0, 0, 9, -9, -9, 9, 0, 0, 0, 0]
  | 8 => #v[0, -9, 0, -9, 0, 0, 9, 0, 0, 9]
  | 9 => #v[0, 0, 9, 0, -9, 0, -9, 0, 9, 0]
  | 10 => #v[-48, 0, 12, 6, 0, 6, 6, 0, 6, 12]
  | 11 => #v[-6, -6, 0, -12, -12, -6, 6, -6, -12, -12]
  | 12 => #v[0, -6, -12, -6, -12, 6, -12, -6, -12, -6]
  | 13 => #v[6, -6, -6, -6, -6, 6, 0, 0, 12, 0]
  | 14 => #v[6, 6, 0, 12, 18, 12, 0, 6, 6, 0]
  | 15 => #v[9, 0, 0, 9, 0, 0, -9, 0, -9, 0]
  | 16 => #v[0, 0, 0, 9, -9, -9, 9, 0, 0, 0]
  | 17 => #v[-9, -18, -9, -18, -9, 0, -9, -9, -9, -9]
  | 18 => #v[9, 9, 9, 0, 18, 9, 9, 9, 9, 18]
  | 19 => #v[0, -9, 0, 0, 0, -9, 0, 0, 9, 9]
  | _ => zeroZ

def KZ (k : Fin 1) : VecZ :=
  match k.val with
  | 0 => #v[0, 66, 66, 0, 0, 0, 66, 66, 66, 0]
  | _ => zeroZ

def YZ (k : Fin 1) : VecZ :=
  match k.val with
  | 0 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  | _ => zeroZ

def xaEntryZ : VecZ := sumFin (fun k => mulZ (XZ k) (AZ k))
def kyEntryZ : VecZ := sumFin (fun k => mulZ (KZ k) (YZ k))
def entryZ : VecZ := addZ xaEntryZ kyEntryZ

theorem entryZ_eq : entryZ = zeroZ :=
  eq_of_eqZ (by decide +kernel)

theorem scale_ne_zero : scale ≠ 0 := by
  decide

theorem XZ_scale_0 : toVec (XZ 0) = (scale : ℚ) • XCell3_0 :=
  toVec_eq_smul10 (XZ 0) scale XCell3_0
    (eq_smul_div (41) scale (41) (66) (by decide) (by decide))
    (eq_smul_div (40) scale (20) (33) (by decide) (by decide))
    (eq_smul_div (112) scale (56) (33) (by decide) (by decide))
    (eq_smul_div (50) scale (25) (33) (by decide) (by decide))
    (eq_smul_div (35) scale (35) (66) (by decide) (by decide))
    (eq_smul_div (92) scale (46) (33) (by decide) (by decide))
    (eq_smul_div (63) scale (21) (22) (by decide) (by decide))
    (eq_smul_div (53) scale (53) (66) (by decide) (by decide))
    (eq_smul_div (29) scale (29) (66) (by decide) (by decide))
    (eq_smul_div (123) scale (41) (22) (by decide) (by decide))

theorem XZ_scale_1 : toVec (XZ 1) = (scale : ℚ) • XCell3_1 :=
  toVec_eq_smul10 (XZ 1) scale XCell3_1
    (eq_smul_div (-7) scale (-7) (66) (by decide) (by decide))
    (eq_smul_div (-28) scale (-14) (33) (by decide) (by decide))
    (eq_smul_div (10) scale (5) (33) (by decide) (by decide))
    (eq_smul_div (29) scale (29) (66) (by decide) (by decide))
    (eq_smul_div (-3) scale (-1) (22) (by decide) (by decide))
    (eq_smul_div (-18) scale (-3) (11) (by decide) (by decide))
    (eq_smul_div (-3) scale (-1) (22) (by decide) (by decide))
    (eq_smul_div (10) scale (5) (33) (by decide) (by decide))
    (eq_smul_div (-2) scale (-1) (33) (by decide) (by decide))
    (eq_smul_div (45) scale (15) (22) (by decide) (by decide))

theorem XZ_scale_2 : toVec (XZ 2) = (scale : ℚ) • XCell3_2 :=
  toVec_eq_smul10 (XZ 2) scale XCell3_2
    (eq_smul_div (-130) scale (-65) (33) (by decide) (by decide))
    (eq_smul_div (14) scale (7) (33) (by decide) (by decide))
    (eq_smul_div (-151) scale (-151) (66) (by decide) (by decide))
    (eq_smul_div (-73) scale (-73) (66) (by decide) (by decide))
    (eq_smul_div (-55) scale (-5) (6) (by decide) (by decide))
    (eq_smul_div (-110) scale (-5) (3) (by decide) (by decide))
    (eq_smul_div (-37) scale (-37) (66) (by decide) (by decide))
    (eq_smul_div (-135) scale (-45) (22) (by decide) (by decide))
    (eq_smul_div (19) scale (19) (66) (by decide) (by decide))
    (eq_smul_div (-222) scale (-37) (11) (by decide) (by decide))

theorem XZ_scale_3 : toVec (XZ 3) = (scale : ℚ) • XCell3_3 :=
  toVec_eq_smul10 (XZ 3) scale XCell3_3
    (eq_smul_div (171) scale (57) (22) (by decide) (by decide))
    (eq_smul_div (16) scale (8) (33) (by decide) (by decide))
    (eq_smul_div (5) scale (5) (66) (by decide) (by decide))
    (eq_smul_div (18) scale (3) (11) (by decide) (by decide))
    (eq_smul_div (25) scale (25) (66) (by decide) (by decide))
    (eq_smul_div (84) scale (14) (11) (by decide) (by decide))
    (eq_smul_div (-13) scale (-13) (66) (by decide) (by decide))
    (eq_smul_div (116) scale (58) (33) (by decide) (by decide))
    (eq_smul_div (-33) scale (-1) (2) (by decide) (by decide))
    (eq_smul_div (73) scale (73) (66) (by decide) (by decide))

theorem XZ_scale_4 : toVec (XZ 4) = (scale : ℚ) • XCell3_4 :=
  toVec_eq_smul10 (XZ 4) scale XCell3_4
    (eq_smul_div (7) scale (7) (66) (by decide) (by decide))
    (eq_smul_div (32) scale (16) (33) (by decide) (by decide))
    (eq_smul_div (17) scale (17) (66) (by decide) (by decide))
    (eq_smul_div (-25) scale (-25) (66) (by decide) (by decide))
    (eq_smul_div (-25) scale (-25) (66) (by decide) (by decide))
    (eq_smul_div (6) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (39) scale (13) (22) (by decide) (by decide))
    (eq_smul_div (1) scale (1) (66) (by decide) (by decide))
    (eq_smul_div (2) scale (1) (33) (by decide) (by decide))
    (eq_smul_div (-10) scale (-5) (33) (by decide) (by decide))

theorem XZ_scale_5 : toVec (XZ 5) = (scale : ℚ) • XCell3_5 :=
  toVec_eq_smul10 (XZ 5) scale XCell3_5
    (eq_smul_div (-178) scale (-89) (33) (by decide) (by decide))
    (eq_smul_int (-66) scale (-1) (by decide))
    (eq_smul_div (-88) scale (-4) (3) (by decide) (by decide))
    (eq_smul_div (-100) scale (-50) (33) (by decide) (by decide))
    (eq_smul_int (-132) scale (-2) (by decide))
    (eq_smul_div (-118) scale (-59) (33) (by decide) (by decide))
    (eq_smul_div (-22) scale (-1) (3) (by decide) (by decide))
    (eq_smul_div (-184) scale (-92) (33) (by decide) (by decide))
    (eq_smul_div (-60) scale (-10) (11) (by decide) (by decide))
    (eq_smul_div (-108) scale (-18) (11) (by decide) (by decide))

theorem XZ_scale_6 : toVec (XZ 6) = (scale : ℚ) • XCell3_6 :=
  toVec_eq_smul10 (XZ 6) scale XCell3_6
    (eq_smul_div (24) scale (4) (11) (by decide) (by decide))
    (eq_smul_div (-28) scale (-14) (33) (by decide) (by decide))
    (eq_smul_div (16) scale (8) (33) (by decide) (by decide))
    (eq_smul_div (-36) scale (-6) (11) (by decide) (by decide))
    (eq_smul_div (-2) scale (-1) (33) (by decide) (by decide))
    (eq_smul_div (48) scale (8) (11) (by decide) (by decide))
    (eq_smul_div (2) scale (1) (33) (by decide) (by decide))
    (eq_smul_div (-18) scale (-3) (11) (by decide) (by decide))
    (eq_smul_div (-62) scale (-31) (33) (by decide) (by decide))
    (eq_smul_div (78) scale (13) (11) (by decide) (by decide))

theorem XZ_scale_7 : toVec (XZ 7) = (scale : ℚ) • XCell3_7 :=
  toVec_eq_smul10 (XZ 7) scale XCell3_7
    (eq_smul_div (-226) scale (-113) (33) (by decide) (by decide))
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-154) scale (-7) (3) (by decide) (by decide))
    (eq_smul_div (-134) scale (-67) (33) (by decide) (by decide))
    (eq_smul_div (-112) scale (-56) (33) (by decide) (by decide))
    (eq_smul_div (-126) scale (-21) (11) (by decide) (by decide))
    (eq_smul_div (-4) scale (-2) (33) (by decide) (by decide))
    (eq_smul_div (-250) scale (-125) (33) (by decide) (by decide))
    (eq_smul_div (-4) scale (-2) (33) (by decide) (by decide))
    (eq_smul_div (-194) scale (-97) (33) (by decide) (by decide))

theorem XZ_scale_8 : toVec (XZ 8) = (scale : ℚ) • XCell3_8 :=
  toVec_eq_smul10 (XZ 8) scale XCell3_8
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

theorem XZ_scale_9 : toVec (XZ 9) = (scale : ℚ) • XCell3_9 :=
  toVec_eq_smul10 (XZ 9) scale XCell3_9
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

theorem XZ_scale_10 : toVec (XZ 10) = (scale : ℚ) • XCell3_10 :=
  toVec_eq_smul10 (XZ 10) scale XCell3_10
    (eq_smul_div (22) scale (1) (3) (by decide) (by decide))
    (eq_smul_div (55) scale (5) (6) (by decide) (by decide))
    (eq_smul_int (66) scale (1) (by decide))
    (eq_smul_div (44) scale (2) (3) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (44) scale (2) (3) (by decide) (by decide))
    (eq_smul_div (55) scale (5) (6) (by decide) (by decide))
    (eq_smul_int (66) scale (1) (by decide))
    (eq_smul_div (11) scale (1) (6) (by decide) (by decide))

theorem XZ_scale_11 : toVec (XZ 11) = (scale : ℚ) • XCell3_11 :=
  toVec_eq_smul10 (XZ 11) scale XCell3_11
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

theorem XZ_scale_12 : toVec (XZ 12) = (scale : ℚ) • XCell3_12 :=
  toVec_eq_smul10 (XZ 12) scale XCell3_12
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

theorem XZ_scale_13 : toVec (XZ 13) = (scale : ℚ) • XCell3_13 :=
  toVec_eq_smul10 (XZ 13) scale XCell3_13
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

theorem XZ_scale_14 : toVec (XZ 14) = (scale : ℚ) • XCell3_14 :=
  toVec_eq_smul10 (XZ 14) scale XCell3_14
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

theorem XZ_scale_15 : toVec (XZ 15) = (scale : ℚ) • XCell3_15 :=
  toVec_eq_smul10 (XZ 15) scale XCell3_15
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

theorem XZ_scale_16 : toVec (XZ 16) = (scale : ℚ) • XCell3_16 :=
  toVec_eq_smul10 (XZ 16) scale XCell3_16
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

theorem XZ_scale_17 : toVec (XZ 17) = (scale : ℚ) • XCell3_17 :=
  toVec_eq_smul10 (XZ 17) scale XCell3_17
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

theorem XZ_scale_18 : toVec (XZ 18) = (scale : ℚ) • XCell3_18 :=
  toVec_eq_smul10 (XZ 18) scale XCell3_18
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

theorem XZ_scale_19 : toVec (XZ 19) = (scale : ℚ) • XCell3_19 :=
  toVec_eq_smul10 (XZ 19) scale XCell3_19
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
    toVec (XZ k) = (scale : ℚ) • XVec (3 : Fin 10) k :=
  forall_fin20 (P := fun k => toVec (XZ k) = (scale : ℚ) • XVec (3 : Fin 10) k)
    XZ_scale_0 XZ_scale_1 XZ_scale_2 XZ_scale_3 XZ_scale_4 XZ_scale_5 XZ_scale_6 XZ_scale_7 XZ_scale_8 XZ_scale_9 XZ_scale_10 XZ_scale_11 XZ_scale_12 XZ_scale_13 XZ_scale_14 XZ_scale_15 XZ_scale_16 XZ_scale_17 XZ_scale_18 XZ_scale_19 k

theorem AZ_scale_0 : toVec (AZ 0) = (scale : ℚ) • ACell0_0 :=
  toVec_eq_smul10 (AZ 0) scale ACell0_0
    (eq_smul_div (60) scale (10) (11) (by decide) (by decide))
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (6) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (6) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_zero scale)

theorem AZ_scale_1 : toVec (AZ 1) = (scale : ℚ) • ACell1_0 :=
  toVec_eq_smul10 (AZ 1) scale ACell1_0
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (6) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (6) scale (1) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_zero scale)

theorem AZ_scale_2 : toVec (AZ 2) = (scale : ℚ) • ACell2_0 :=
  toVec_eq_smul10 (AZ 2) scale ACell2_0
    (eq_smul_div (6) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (6) scale (1) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_zero scale)

theorem AZ_scale_3 : toVec (AZ 3) = (scale : ℚ) • ACell3_0 :=
  toVec_eq_smul10 (AZ 3) scale ACell3_0
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (6) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (6) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (6) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (18) scale (3) (11) (by decide) (by decide))
    (eq_smul_div (6) scale (1) (11) (by decide) (by decide))
    (eq_smul_zero scale)

theorem AZ_scale_4 : toVec (AZ 4) = (scale : ℚ) • ACell4_0 :=
  toVec_eq_smul10 (AZ 4) scale ACell4_0
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (6) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (6) scale (1) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))

theorem AZ_scale_5 : toVec (AZ 5) = (scale : ℚ) • ACell5_0 :=
  toVec_eq_smul10 (AZ 5) scale ACell5_0
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (9) scale (3) (22) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (-9) scale (-3) (22) (by decide) (by decide))
    (eq_smul_div (-9) scale (-3) (22) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (9) scale (3) (22) (by decide) (by decide))

theorem AZ_scale_6 : toVec (AZ 6) = (scale : ℚ) • ACell6_0 :=
  toVec_eq_smul10 (AZ 6) scale ACell6_0
    (eq_smul_zero scale)
    (eq_smul_div (9) scale (3) (22) (by decide) (by decide))
    (eq_smul_div (-9) scale (-3) (22) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (-9) scale (-3) (22) (by decide) (by decide))
    (eq_smul_div (9) scale (3) (22) (by decide) (by decide))
    (eq_smul_zero scale)

theorem AZ_scale_7 : toVec (AZ 7) = (scale : ℚ) • ACell7_0 :=
  toVec_eq_smul10 (AZ 7) scale ACell7_0
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (9) scale (3) (22) (by decide) (by decide))
    (eq_smul_div (-9) scale (-3) (22) (by decide) (by decide))
    (eq_smul_div (-9) scale (-3) (22) (by decide) (by decide))
    (eq_smul_div (9) scale (3) (22) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)

theorem AZ_scale_8 : toVec (AZ 8) = (scale : ℚ) • ACell8_0 :=
  toVec_eq_smul10 (AZ 8) scale ACell8_0
    (eq_smul_zero scale)
    (eq_smul_div (-9) scale (-3) (22) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-9) scale (-3) (22) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (9) scale (3) (22) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (9) scale (3) (22) (by decide) (by decide))

theorem AZ_scale_9 : toVec (AZ 9) = (scale : ℚ) • ACell9_0 :=
  toVec_eq_smul10 (AZ 9) scale ACell9_0
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (9) scale (3) (22) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-9) scale (-3) (22) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-9) scale (-3) (22) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (9) scale (3) (22) (by decide) (by decide))
    (eq_smul_zero scale)

theorem AZ_scale_10 : toVec (AZ 10) = (scale : ℚ) • ACell10_0 :=
  toVec_eq_smul10 (AZ 10) scale ACell10_0
    (eq_smul_div (-48) scale (-8) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (6) scale (1) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (6) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (6) scale (1) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (6) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))

theorem AZ_scale_11 : toVec (AZ 11) = (scale : ℚ) • ACell11_0 :=
  toVec_eq_smul10 (AZ 11) scale ACell11_0
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-12) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-12) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (6) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-12) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-12) scale (-2) (11) (by decide) (by decide))

theorem AZ_scale_12 : toVec (AZ 12) = (scale : ℚ) • ACell12_0 :=
  toVec_eq_smul10 (AZ 12) scale ACell12_0
    (eq_smul_zero scale)
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-12) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-12) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (6) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (-12) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-12) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))

theorem AZ_scale_13 : toVec (AZ 13) = (scale : ℚ) • ACell13_0 :=
  toVec_eq_smul10 (AZ 13) scale ACell13_0
    (eq_smul_div (6) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (6) scale (1) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_zero scale)

theorem AZ_scale_14 : toVec (AZ 14) = (scale : ℚ) • ACell14_0 :=
  toVec_eq_smul10 (AZ 14) scale ACell14_0
    (eq_smul_div (6) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (6) scale (1) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (18) scale (3) (11) (by decide) (by decide))
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (6) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (6) scale (1) (11) (by decide) (by decide))
    (eq_smul_zero scale)

theorem AZ_scale_15 : toVec (AZ 15) = (scale : ℚ) • ACell15_0 :=
  toVec_eq_smul10 (AZ 15) scale ACell15_0
    (eq_smul_div (9) scale (3) (22) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (9) scale (3) (22) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (-9) scale (-3) (22) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-9) scale (-3) (22) (by decide) (by decide))
    (eq_smul_zero scale)

theorem AZ_scale_16 : toVec (AZ 16) = (scale : ℚ) • ACell16_0 :=
  toVec_eq_smul10 (AZ 16) scale ACell16_0
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (9) scale (3) (22) (by decide) (by decide))
    (eq_smul_div (-9) scale (-3) (22) (by decide) (by decide))
    (eq_smul_div (-9) scale (-3) (22) (by decide) (by decide))
    (eq_smul_div (9) scale (3) (22) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)

theorem AZ_scale_17 : toVec (AZ 17) = (scale : ℚ) • ACell17_0 :=
  toVec_eq_smul10 (AZ 17) scale ACell17_0
    (eq_smul_div (-9) scale (-3) (22) (by decide) (by decide))
    (eq_smul_div (-18) scale (-3) (11) (by decide) (by decide))
    (eq_smul_div (-9) scale (-3) (22) (by decide) (by decide))
    (eq_smul_div (-18) scale (-3) (11) (by decide) (by decide))
    (eq_smul_div (-9) scale (-3) (22) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-9) scale (-3) (22) (by decide) (by decide))
    (eq_smul_div (-9) scale (-3) (22) (by decide) (by decide))
    (eq_smul_div (-9) scale (-3) (22) (by decide) (by decide))
    (eq_smul_div (-9) scale (-3) (22) (by decide) (by decide))

theorem AZ_scale_18 : toVec (AZ 18) = (scale : ℚ) • ACell18_0 :=
  toVec_eq_smul10 (AZ 18) scale ACell18_0
    (eq_smul_div (9) scale (3) (22) (by decide) (by decide))
    (eq_smul_div (9) scale (3) (22) (by decide) (by decide))
    (eq_smul_div (9) scale (3) (22) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (18) scale (3) (11) (by decide) (by decide))
    (eq_smul_div (9) scale (3) (22) (by decide) (by decide))
    (eq_smul_div (9) scale (3) (22) (by decide) (by decide))
    (eq_smul_div (9) scale (3) (22) (by decide) (by decide))
    (eq_smul_div (9) scale (3) (22) (by decide) (by decide))
    (eq_smul_div (18) scale (3) (11) (by decide) (by decide))

theorem AZ_scale_19 : toVec (AZ 19) = (scale : ℚ) • ACell19_0 :=
  toVec_eq_smul10 (AZ 19) scale ACell19_0
    (eq_smul_zero scale)
    (eq_smul_div (-9) scale (-3) (22) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (-9) scale (-3) (22) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (9) scale (3) (22) (by decide) (by decide))
    (eq_smul_div (9) scale (3) (22) (by decide) (by decide))

theorem AZ_scale (k : Fin 20) :
    toVec (AZ k) = (scale : ℚ) • AVec k (0 : Fin 10) :=
  forall_fin20 (P := fun k => toVec (AZ k) = (scale : ℚ) • AVec k (0 : Fin 10))
    AZ_scale_0 AZ_scale_1 AZ_scale_2 AZ_scale_3 AZ_scale_4 AZ_scale_5 AZ_scale_6 AZ_scale_7 AZ_scale_8 AZ_scale_9 AZ_scale_10 AZ_scale_11 AZ_scale_12 AZ_scale_13 AZ_scale_14 AZ_scale_15 AZ_scale_16 AZ_scale_17 AZ_scale_18 AZ_scale_19 k

theorem KZ_scale_0 : toVec (KZ 0) = (scale : ℚ) • KCell3_0 :=
  toVec_eq_smul10 (KZ 0) scale KCell3_0
    (eq_smul_zero scale)
    (eq_smul_int (66) scale (1) (by decide))
    (eq_smul_int (66) scale (1) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_int (66) scale (1) (by decide))
    (eq_smul_int (66) scale (1) (by decide))
    (eq_smul_int (66) scale (1) (by decide))
    (eq_smul_zero scale)

theorem KZ_scale (k : Fin 1) :
    toVec (KZ k) = (scale : ℚ) • KVec (3 : Fin 10) k :=
  forall_fin1 (P := fun k => toVec (KZ k) = (scale : ℚ) • KVec (3 : Fin 10) k)
    KZ_scale_0 k

theorem YZ_scale_0 : toVec (YZ 0) = (scale : ℚ) • YCell0_0 :=
  toVec_eq_smul10 (YZ 0) scale YCell0_0
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

theorem YZ_scale (k : Fin 1) :
    toVec (YZ k) = (scale : ℚ) • YVec k (0 : Fin 10) :=
  forall_fin1 (P := fun k => toVec (YZ k) = (scale : ℚ) • YVec k (0 : Fin 10))
    YZ_scale_0 k

theorem entry_eq :
    (matrixMul XVec AVec + matrixMul KVec YVec)
        (3 : Fin 10) (0 : Fin 10) = ![0, 0, 0, 0, 0, 0, 0, 0, 0, 0] := by
  change (∑ k : Fin 20, mul (XVec (3 : Fin 10) k)
      (AVec k (0 : Fin 10))) +
    (∑ k : Fin 1, mul (KVec (3 : Fin 10) k)
      (YVec k (0 : Fin 10))) = _
  refine add_sum_mul_eq_of_scaled scale scale_ne_zero
    (fun k => XVec (3 : Fin 10) k)
    (fun k => AVec k (0 : Fin 10))
    (fun k => KVec (3 : Fin 10) k)
    (fun k => YVec k (0 : Fin 10))
    XZ AZ KZ YZ XZ_scale AZ_scale KZ_scale YZ_scale entryZ rfl _ ?_
  rw [entryZ_eq, toVec_zeroZ_smul, vec_zero_eq]

theorem entry_eq_matrixOne :
    (matrixMul XVec AVec + matrixMul KVec YVec)
        (3 : Fin 10) (0 : Fin 10) =
      matrixOne (Fin 10) (3 : Fin 10) (0 : Fin 10) :=
  entry_eq.trans (matrixOne_off10 (3 : Fin 10) (0 : Fin 10) (by decide)).symm

end V14Formalization.D12PieceAPSplitEntry3_0


namespace V14Formalization.D12PieceAPSplitEntry3_1
open D12CyclotomicVec D12CyclotomicVecZ D12PieceAPData
def payloadSha256 : String := "76c6196f29afe1a8398af99502447f48ebeed4bcb3805fc5dbec693940bc04b0"

def scale : ℤ := 66

def XZ (k : Fin 20) : VecZ :=
  match k.val with
  | 0 => #v[41, 40, 112, 50, 35, 92, 63, 53, 29, 123]
  | 1 => #v[-7, -28, 10, 29, -3, -18, -3, 10, -2, 45]
  | 2 => #v[-130, 14, -151, -73, -55, -110, -37, -135, 19, -222]
  | 3 => #v[171, 16, 5, 18, 25, 84, -13, 116, -33, 73]
  | 4 => #v[7, 32, 17, -25, -25, 6, 39, 1, 2, -10]
  | 5 => #v[-178, -66, -88, -100, -132, -118, -22, -184, -60, -108]
  | 6 => #v[24, -28, 16, -36, -2, 48, 2, -18, -62, 78]
  | 7 => #v[-226, -6, -154, -134, -112, -126, -4, -250, -4, -194]
  | 8 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  | 9 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  | 10 => #v[22, 55, 66, 44, 0, 0, 44, 55, 66, 11]
  | 11 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
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
  | 0 => #v[-6, 0, 6, -6, 12, -6, 6, 0, -6, 0]
  | 1 => #v[66, 6, 18, 6, 0, 0, 12, 6, 6, 12]
  | 2 => #v[6, 6, 0, -6, 0, -6, 12, -6, 0, -6]
  | 3 => #v[0, 0, 12, 6, 6, 18, 6, 6, 12, 0]
  | 4 => #v[-6, -18, -12, -12, -18, -18, -12, -12, -18, -6]
  | 5 => #v[9, 9, 18, 9, 9, 18, 9, 9, 0, 9]
  | 6 => #v[0, 9, -9, -9, 9, 0, 0, 0, 0, 0]
  | 7 => #v[-9, -9, -9, -9, 0, -9, -18, -9, -18, -9]
  | 8 => #v[0, 0, -9, 9, 0, 0, 0, 0, 9, -9]
  | 9 => #v[0, -9, 0, 0, 0, -9, 0, 0, 9, 9]
  | 10 => #v[0, 6, -6, -6, 0, 12, 0, -6, -6, 6]
  | 11 => #v[-54, 0, 0, 6, -6, -6, -6, -6, 6, 0]
  | 12 => #v[-6, -18, -12, -12, -18, -18, -12, -12, -18, -6]
  | 13 => #v[6, 0, 18, 0, 6, 0, 6, 12, 12, 6]
  | 14 => #v[12, 6, 0, 6, 6, 0, 6, 12, 0, 18]
  | 15 => #v[9, 9, 9, 0, 18, 9, 9, 9, 9, 18]
  | 16 => #v[0, 9, 0, -9, 0, -9, 0, 9, 0, 0]
  | 17 => #v[0, 9, 9, 0, 0, -9, 0, 0, 0, -9]
  | 18 => #v[18, 18, 0, 9, 9, 9, 9, 9, 9, 9]
  | 19 => #v[0, -9, 0, 0, -9, 0, 0, 9, 0, 9]
  | _ => zeroZ

def KZ (k : Fin 1) : VecZ :=
  match k.val with
  | 0 => #v[0, 66, 66, 0, 0, 0, 66, 66, 66, 0]
  | _ => zeroZ

def YZ (k : Fin 1) : VecZ :=
  match k.val with
  | 0 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  | _ => zeroZ

def xaEntryZ : VecZ := sumFin (fun k => mulZ (XZ k) (AZ k))
def kyEntryZ : VecZ := sumFin (fun k => mulZ (KZ k) (YZ k))
def entryZ : VecZ := addZ xaEntryZ kyEntryZ

theorem entryZ_eq : entryZ = zeroZ :=
  eq_of_eqZ (by decide +kernel)

theorem scale_ne_zero : scale ≠ 0 := by
  decide

theorem XZ_scale_0 : toVec (XZ 0) = (scale : ℚ) • XCell3_0 :=
  toVec_eq_smul10 (XZ 0) scale XCell3_0
    (eq_smul_div (41) scale (41) (66) (by decide) (by decide))
    (eq_smul_div (40) scale (20) (33) (by decide) (by decide))
    (eq_smul_div (112) scale (56) (33) (by decide) (by decide))
    (eq_smul_div (50) scale (25) (33) (by decide) (by decide))
    (eq_smul_div (35) scale (35) (66) (by decide) (by decide))
    (eq_smul_div (92) scale (46) (33) (by decide) (by decide))
    (eq_smul_div (63) scale (21) (22) (by decide) (by decide))
    (eq_smul_div (53) scale (53) (66) (by decide) (by decide))
    (eq_smul_div (29) scale (29) (66) (by decide) (by decide))
    (eq_smul_div (123) scale (41) (22) (by decide) (by decide))

theorem XZ_scale_1 : toVec (XZ 1) = (scale : ℚ) • XCell3_1 :=
  toVec_eq_smul10 (XZ 1) scale XCell3_1
    (eq_smul_div (-7) scale (-7) (66) (by decide) (by decide))
    (eq_smul_div (-28) scale (-14) (33) (by decide) (by decide))
    (eq_smul_div (10) scale (5) (33) (by decide) (by decide))
    (eq_smul_div (29) scale (29) (66) (by decide) (by decide))
    (eq_smul_div (-3) scale (-1) (22) (by decide) (by decide))
    (eq_smul_div (-18) scale (-3) (11) (by decide) (by decide))
    (eq_smul_div (-3) scale (-1) (22) (by decide) (by decide))
    (eq_smul_div (10) scale (5) (33) (by decide) (by decide))
    (eq_smul_div (-2) scale (-1) (33) (by decide) (by decide))
    (eq_smul_div (45) scale (15) (22) (by decide) (by decide))

theorem XZ_scale_2 : toVec (XZ 2) = (scale : ℚ) • XCell3_2 :=
  toVec_eq_smul10 (XZ 2) scale XCell3_2
    (eq_smul_div (-130) scale (-65) (33) (by decide) (by decide))
    (eq_smul_div (14) scale (7) (33) (by decide) (by decide))
    (eq_smul_div (-151) scale (-151) (66) (by decide) (by decide))
    (eq_smul_div (-73) scale (-73) (66) (by decide) (by decide))
    (eq_smul_div (-55) scale (-5) (6) (by decide) (by decide))
    (eq_smul_div (-110) scale (-5) (3) (by decide) (by decide))
    (eq_smul_div (-37) scale (-37) (66) (by decide) (by decide))
    (eq_smul_div (-135) scale (-45) (22) (by decide) (by decide))
    (eq_smul_div (19) scale (19) (66) (by decide) (by decide))
    (eq_smul_div (-222) scale (-37) (11) (by decide) (by decide))

theorem XZ_scale_3 : toVec (XZ 3) = (scale : ℚ) • XCell3_3 :=
  toVec_eq_smul10 (XZ 3) scale XCell3_3
    (eq_smul_div (171) scale (57) (22) (by decide) (by decide))
    (eq_smul_div (16) scale (8) (33) (by decide) (by decide))
    (eq_smul_div (5) scale (5) (66) (by decide) (by decide))
    (eq_smul_div (18) scale (3) (11) (by decide) (by decide))
    (eq_smul_div (25) scale (25) (66) (by decide) (by decide))
    (eq_smul_div (84) scale (14) (11) (by decide) (by decide))
    (eq_smul_div (-13) scale (-13) (66) (by decide) (by decide))
    (eq_smul_div (116) scale (58) (33) (by decide) (by decide))
    (eq_smul_div (-33) scale (-1) (2) (by decide) (by decide))
    (eq_smul_div (73) scale (73) (66) (by decide) (by decide))

theorem XZ_scale_4 : toVec (XZ 4) = (scale : ℚ) • XCell3_4 :=
  toVec_eq_smul10 (XZ 4) scale XCell3_4
    (eq_smul_div (7) scale (7) (66) (by decide) (by decide))
    (eq_smul_div (32) scale (16) (33) (by decide) (by decide))
    (eq_smul_div (17) scale (17) (66) (by decide) (by decide))
    (eq_smul_div (-25) scale (-25) (66) (by decide) (by decide))
    (eq_smul_div (-25) scale (-25) (66) (by decide) (by decide))
    (eq_smul_div (6) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (39) scale (13) (22) (by decide) (by decide))
    (eq_smul_div (1) scale (1) (66) (by decide) (by decide))
    (eq_smul_div (2) scale (1) (33) (by decide) (by decide))
    (eq_smul_div (-10) scale (-5) (33) (by decide) (by decide))

theorem XZ_scale_5 : toVec (XZ 5) = (scale : ℚ) • XCell3_5 :=
  toVec_eq_smul10 (XZ 5) scale XCell3_5
    (eq_smul_div (-178) scale (-89) (33) (by decide) (by decide))
    (eq_smul_int (-66) scale (-1) (by decide))
    (eq_smul_div (-88) scale (-4) (3) (by decide) (by decide))
    (eq_smul_div (-100) scale (-50) (33) (by decide) (by decide))
    (eq_smul_int (-132) scale (-2) (by decide))
    (eq_smul_div (-118) scale (-59) (33) (by decide) (by decide))
    (eq_smul_div (-22) scale (-1) (3) (by decide) (by decide))
    (eq_smul_div (-184) scale (-92) (33) (by decide) (by decide))
    (eq_smul_div (-60) scale (-10) (11) (by decide) (by decide))
    (eq_smul_div (-108) scale (-18) (11) (by decide) (by decide))

theorem XZ_scale_6 : toVec (XZ 6) = (scale : ℚ) • XCell3_6 :=
  toVec_eq_smul10 (XZ 6) scale XCell3_6
    (eq_smul_div (24) scale (4) (11) (by decide) (by decide))
    (eq_smul_div (-28) scale (-14) (33) (by decide) (by decide))
    (eq_smul_div (16) scale (8) (33) (by decide) (by decide))
    (eq_smul_div (-36) scale (-6) (11) (by decide) (by decide))
    (eq_smul_div (-2) scale (-1) (33) (by decide) (by decide))
    (eq_smul_div (48) scale (8) (11) (by decide) (by decide))
    (eq_smul_div (2) scale (1) (33) (by decide) (by decide))
    (eq_smul_div (-18) scale (-3) (11) (by decide) (by decide))
    (eq_smul_div (-62) scale (-31) (33) (by decide) (by decide))
    (eq_smul_div (78) scale (13) (11) (by decide) (by decide))

theorem XZ_scale_7 : toVec (XZ 7) = (scale : ℚ) • XCell3_7 :=
  toVec_eq_smul10 (XZ 7) scale XCell3_7
    (eq_smul_div (-226) scale (-113) (33) (by decide) (by decide))
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-154) scale (-7) (3) (by decide) (by decide))
    (eq_smul_div (-134) scale (-67) (33) (by decide) (by decide))
    (eq_smul_div (-112) scale (-56) (33) (by decide) (by decide))
    (eq_smul_div (-126) scale (-21) (11) (by decide) (by decide))
    (eq_smul_div (-4) scale (-2) (33) (by decide) (by decide))
    (eq_smul_div (-250) scale (-125) (33) (by decide) (by decide))
    (eq_smul_div (-4) scale (-2) (33) (by decide) (by decide))
    (eq_smul_div (-194) scale (-97) (33) (by decide) (by decide))

theorem XZ_scale_8 : toVec (XZ 8) = (scale : ℚ) • XCell3_8 :=
  toVec_eq_smul10 (XZ 8) scale XCell3_8
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

theorem XZ_scale_9 : toVec (XZ 9) = (scale : ℚ) • XCell3_9 :=
  toVec_eq_smul10 (XZ 9) scale XCell3_9
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

theorem XZ_scale_10 : toVec (XZ 10) = (scale : ℚ) • XCell3_10 :=
  toVec_eq_smul10 (XZ 10) scale XCell3_10
    (eq_smul_div (22) scale (1) (3) (by decide) (by decide))
    (eq_smul_div (55) scale (5) (6) (by decide) (by decide))
    (eq_smul_int (66) scale (1) (by decide))
    (eq_smul_div (44) scale (2) (3) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (44) scale (2) (3) (by decide) (by decide))
    (eq_smul_div (55) scale (5) (6) (by decide) (by decide))
    (eq_smul_int (66) scale (1) (by decide))
    (eq_smul_div (11) scale (1) (6) (by decide) (by decide))

theorem XZ_scale_11 : toVec (XZ 11) = (scale : ℚ) • XCell3_11 :=
  toVec_eq_smul10 (XZ 11) scale XCell3_11
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

theorem XZ_scale_12 : toVec (XZ 12) = (scale : ℚ) • XCell3_12 :=
  toVec_eq_smul10 (XZ 12) scale XCell3_12
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

theorem XZ_scale_13 : toVec (XZ 13) = (scale : ℚ) • XCell3_13 :=
  toVec_eq_smul10 (XZ 13) scale XCell3_13
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

theorem XZ_scale_14 : toVec (XZ 14) = (scale : ℚ) • XCell3_14 :=
  toVec_eq_smul10 (XZ 14) scale XCell3_14
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

theorem XZ_scale_15 : toVec (XZ 15) = (scale : ℚ) • XCell3_15 :=
  toVec_eq_smul10 (XZ 15) scale XCell3_15
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

theorem XZ_scale_16 : toVec (XZ 16) = (scale : ℚ) • XCell3_16 :=
  toVec_eq_smul10 (XZ 16) scale XCell3_16
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

theorem XZ_scale_17 : toVec (XZ 17) = (scale : ℚ) • XCell3_17 :=
  toVec_eq_smul10 (XZ 17) scale XCell3_17
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

theorem XZ_scale_18 : toVec (XZ 18) = (scale : ℚ) • XCell3_18 :=
  toVec_eq_smul10 (XZ 18) scale XCell3_18
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

theorem XZ_scale_19 : toVec (XZ 19) = (scale : ℚ) • XCell3_19 :=
  toVec_eq_smul10 (XZ 19) scale XCell3_19
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
    toVec (XZ k) = (scale : ℚ) • XVec (3 : Fin 10) k :=
  forall_fin20 (P := fun k => toVec (XZ k) = (scale : ℚ) • XVec (3 : Fin 10) k)
    XZ_scale_0 XZ_scale_1 XZ_scale_2 XZ_scale_3 XZ_scale_4 XZ_scale_5 XZ_scale_6 XZ_scale_7 XZ_scale_8 XZ_scale_9 XZ_scale_10 XZ_scale_11 XZ_scale_12 XZ_scale_13 XZ_scale_14 XZ_scale_15 XZ_scale_16 XZ_scale_17 XZ_scale_18 XZ_scale_19 k

theorem AZ_scale_0 : toVec (AZ 0) = (scale : ℚ) • ACell0_1 :=
  toVec_eq_smul10 (AZ 0) scale ACell0_1
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (6) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (6) scale (1) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_zero scale)

theorem AZ_scale_1 : toVec (AZ 1) = (scale : ℚ) • ACell1_1 :=
  toVec_eq_smul10 (AZ 1) scale ACell1_1
    (eq_smul_int (66) scale (1) (by decide))
    (eq_smul_div (6) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (18) scale (3) (11) (by decide) (by decide))
    (eq_smul_div (6) scale (1) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (6) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (6) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))

theorem AZ_scale_2 : toVec (AZ 2) = (scale : ℚ) • ACell2_1 :=
  toVec_eq_smul10 (AZ 2) scale ACell2_1
    (eq_smul_div (6) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (6) scale (1) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))

theorem AZ_scale_3 : toVec (AZ 3) = (scale : ℚ) • ACell3_1 :=
  toVec_eq_smul10 (AZ 3) scale ACell3_1
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (6) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (6) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (18) scale (3) (11) (by decide) (by decide))
    (eq_smul_div (6) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (6) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_zero scale)

theorem AZ_scale_4 : toVec (AZ 4) = (scale : ℚ) • ACell4_1 :=
  toVec_eq_smul10 (AZ 4) scale ACell4_1
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-18) scale (-3) (11) (by decide) (by decide))
    (eq_smul_div (-12) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-12) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-18) scale (-3) (11) (by decide) (by decide))
    (eq_smul_div (-18) scale (-3) (11) (by decide) (by decide))
    (eq_smul_div (-12) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-12) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-18) scale (-3) (11) (by decide) (by decide))
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))

theorem AZ_scale_5 : toVec (AZ 5) = (scale : ℚ) • ACell5_1 :=
  toVec_eq_smul10 (AZ 5) scale ACell5_1
    (eq_smul_div (9) scale (3) (22) (by decide) (by decide))
    (eq_smul_div (9) scale (3) (22) (by decide) (by decide))
    (eq_smul_div (18) scale (3) (11) (by decide) (by decide))
    (eq_smul_div (9) scale (3) (22) (by decide) (by decide))
    (eq_smul_div (9) scale (3) (22) (by decide) (by decide))
    (eq_smul_div (18) scale (3) (11) (by decide) (by decide))
    (eq_smul_div (9) scale (3) (22) (by decide) (by decide))
    (eq_smul_div (9) scale (3) (22) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (9) scale (3) (22) (by decide) (by decide))

theorem AZ_scale_6 : toVec (AZ 6) = (scale : ℚ) • ACell6_1 :=
  toVec_eq_smul10 (AZ 6) scale ACell6_1
    (eq_smul_zero scale)
    (eq_smul_div (9) scale (3) (22) (by decide) (by decide))
    (eq_smul_div (-9) scale (-3) (22) (by decide) (by decide))
    (eq_smul_div (-9) scale (-3) (22) (by decide) (by decide))
    (eq_smul_div (9) scale (3) (22) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)

theorem AZ_scale_7 : toVec (AZ 7) = (scale : ℚ) • ACell7_1 :=
  toVec_eq_smul10 (AZ 7) scale ACell7_1
    (eq_smul_div (-9) scale (-3) (22) (by decide) (by decide))
    (eq_smul_div (-9) scale (-3) (22) (by decide) (by decide))
    (eq_smul_div (-9) scale (-3) (22) (by decide) (by decide))
    (eq_smul_div (-9) scale (-3) (22) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-9) scale (-3) (22) (by decide) (by decide))
    (eq_smul_div (-18) scale (-3) (11) (by decide) (by decide))
    (eq_smul_div (-9) scale (-3) (22) (by decide) (by decide))
    (eq_smul_div (-18) scale (-3) (11) (by decide) (by decide))
    (eq_smul_div (-9) scale (-3) (22) (by decide) (by decide))

theorem AZ_scale_8 : toVec (AZ 8) = (scale : ℚ) • ACell8_1 :=
  toVec_eq_smul10 (AZ 8) scale ACell8_1
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (-9) scale (-3) (22) (by decide) (by decide))
    (eq_smul_div (9) scale (3) (22) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (9) scale (3) (22) (by decide) (by decide))
    (eq_smul_div (-9) scale (-3) (22) (by decide) (by decide))

theorem AZ_scale_9 : toVec (AZ 9) = (scale : ℚ) • ACell9_1 :=
  toVec_eq_smul10 (AZ 9) scale ACell9_1
    (eq_smul_zero scale)
    (eq_smul_div (-9) scale (-3) (22) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (-9) scale (-3) (22) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (9) scale (3) (22) (by decide) (by decide))
    (eq_smul_div (9) scale (3) (22) (by decide) (by decide))

theorem AZ_scale_10 : toVec (AZ 10) = (scale : ℚ) • ACell10_1 :=
  toVec_eq_smul10 (AZ 10) scale ACell10_1
    (eq_smul_zero scale)
    (eq_smul_div (6) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (6) scale (1) (11) (by decide) (by decide))

theorem AZ_scale_11 : toVec (AZ 11) = (scale : ℚ) • ACell11_1 :=
  toVec_eq_smul10 (AZ 11) scale ACell11_1
    (eq_smul_div (-54) scale (-9) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (6) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (6) scale (1) (11) (by decide) (by decide))
    (eq_smul_zero scale)

theorem AZ_scale_12 : toVec (AZ 12) = (scale : ℚ) • ACell12_1 :=
  toVec_eq_smul10 (AZ 12) scale ACell12_1
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-18) scale (-3) (11) (by decide) (by decide))
    (eq_smul_div (-12) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-12) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-18) scale (-3) (11) (by decide) (by decide))
    (eq_smul_div (-18) scale (-3) (11) (by decide) (by decide))
    (eq_smul_div (-12) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-12) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-18) scale (-3) (11) (by decide) (by decide))
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))

theorem AZ_scale_13 : toVec (AZ 13) = (scale : ℚ) • ACell13_1 :=
  toVec_eq_smul10 (AZ 13) scale ACell13_1
    (eq_smul_div (6) scale (1) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (18) scale (3) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (6) scale (1) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (6) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (6) scale (1) (11) (by decide) (by decide))

theorem AZ_scale_14 : toVec (AZ 14) = (scale : ℚ) • ACell14_1 :=
  toVec_eq_smul10 (AZ 14) scale ACell14_1
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (6) scale (1) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (6) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (6) scale (1) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (6) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (18) scale (3) (11) (by decide) (by decide))

theorem AZ_scale_15 : toVec (AZ 15) = (scale : ℚ) • ACell15_1 :=
  toVec_eq_smul10 (AZ 15) scale ACell15_1
    (eq_smul_div (9) scale (3) (22) (by decide) (by decide))
    (eq_smul_div (9) scale (3) (22) (by decide) (by decide))
    (eq_smul_div (9) scale (3) (22) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (18) scale (3) (11) (by decide) (by decide))
    (eq_smul_div (9) scale (3) (22) (by decide) (by decide))
    (eq_smul_div (9) scale (3) (22) (by decide) (by decide))
    (eq_smul_div (9) scale (3) (22) (by decide) (by decide))
    (eq_smul_div (9) scale (3) (22) (by decide) (by decide))
    (eq_smul_div (18) scale (3) (11) (by decide) (by decide))

theorem AZ_scale_16 : toVec (AZ 16) = (scale : ℚ) • ACell16_1 :=
  toVec_eq_smul10 (AZ 16) scale ACell16_1
    (eq_smul_zero scale)
    (eq_smul_div (9) scale (3) (22) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-9) scale (-3) (22) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-9) scale (-3) (22) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (9) scale (3) (22) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)

theorem AZ_scale_17 : toVec (AZ 17) = (scale : ℚ) • ACell17_1 :=
  toVec_eq_smul10 (AZ 17) scale ACell17_1
    (eq_smul_zero scale)
    (eq_smul_div (9) scale (3) (22) (by decide) (by decide))
    (eq_smul_div (9) scale (3) (22) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (-9) scale (-3) (22) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (-9) scale (-3) (22) (by decide) (by decide))

theorem AZ_scale_18 : toVec (AZ 18) = (scale : ℚ) • ACell18_1 :=
  toVec_eq_smul10 (AZ 18) scale ACell18_1
    (eq_smul_div (18) scale (3) (11) (by decide) (by decide))
    (eq_smul_div (18) scale (3) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (9) scale (3) (22) (by decide) (by decide))
    (eq_smul_div (9) scale (3) (22) (by decide) (by decide))
    (eq_smul_div (9) scale (3) (22) (by decide) (by decide))
    (eq_smul_div (9) scale (3) (22) (by decide) (by decide))
    (eq_smul_div (9) scale (3) (22) (by decide) (by decide))
    (eq_smul_div (9) scale (3) (22) (by decide) (by decide))
    (eq_smul_div (9) scale (3) (22) (by decide) (by decide))

theorem AZ_scale_19 : toVec (AZ 19) = (scale : ℚ) • ACell19_1 :=
  toVec_eq_smul10 (AZ 19) scale ACell19_1
    (eq_smul_zero scale)
    (eq_smul_div (-9) scale (-3) (22) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (-9) scale (-3) (22) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (9) scale (3) (22) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (9) scale (3) (22) (by decide) (by decide))

theorem AZ_scale (k : Fin 20) :
    toVec (AZ k) = (scale : ℚ) • AVec k (1 : Fin 10) :=
  forall_fin20 (P := fun k => toVec (AZ k) = (scale : ℚ) • AVec k (1 : Fin 10))
    AZ_scale_0 AZ_scale_1 AZ_scale_2 AZ_scale_3 AZ_scale_4 AZ_scale_5 AZ_scale_6 AZ_scale_7 AZ_scale_8 AZ_scale_9 AZ_scale_10 AZ_scale_11 AZ_scale_12 AZ_scale_13 AZ_scale_14 AZ_scale_15 AZ_scale_16 AZ_scale_17 AZ_scale_18 AZ_scale_19 k

theorem KZ_scale_0 : toVec (KZ 0) = (scale : ℚ) • KCell3_0 :=
  toVec_eq_smul10 (KZ 0) scale KCell3_0
    (eq_smul_zero scale)
    (eq_smul_int (66) scale (1) (by decide))
    (eq_smul_int (66) scale (1) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_int (66) scale (1) (by decide))
    (eq_smul_int (66) scale (1) (by decide))
    (eq_smul_int (66) scale (1) (by decide))
    (eq_smul_zero scale)

theorem KZ_scale (k : Fin 1) :
    toVec (KZ k) = (scale : ℚ) • KVec (3 : Fin 10) k :=
  forall_fin1 (P := fun k => toVec (KZ k) = (scale : ℚ) • KVec (3 : Fin 10) k)
    KZ_scale_0 k

theorem YZ_scale_0 : toVec (YZ 0) = (scale : ℚ) • YCell0_1 :=
  toVec_eq_smul10 (YZ 0) scale YCell0_1
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

theorem YZ_scale (k : Fin 1) :
    toVec (YZ k) = (scale : ℚ) • YVec k (1 : Fin 10) :=
  forall_fin1 (P := fun k => toVec (YZ k) = (scale : ℚ) • YVec k (1 : Fin 10))
    YZ_scale_0 k

theorem entry_eq :
    (matrixMul XVec AVec + matrixMul KVec YVec)
        (3 : Fin 10) (1 : Fin 10) = ![0, 0, 0, 0, 0, 0, 0, 0, 0, 0] := by
  change (∑ k : Fin 20, mul (XVec (3 : Fin 10) k)
      (AVec k (1 : Fin 10))) +
    (∑ k : Fin 1, mul (KVec (3 : Fin 10) k)
      (YVec k (1 : Fin 10))) = _
  refine add_sum_mul_eq_of_scaled scale scale_ne_zero
    (fun k => XVec (3 : Fin 10) k)
    (fun k => AVec k (1 : Fin 10))
    (fun k => KVec (3 : Fin 10) k)
    (fun k => YVec k (1 : Fin 10))
    XZ AZ KZ YZ XZ_scale AZ_scale KZ_scale YZ_scale entryZ rfl _ ?_
  rw [entryZ_eq, toVec_zeroZ_smul, vec_zero_eq]

theorem entry_eq_matrixOne :
    (matrixMul XVec AVec + matrixMul KVec YVec)
        (3 : Fin 10) (1 : Fin 10) =
      matrixOne (Fin 10) (3 : Fin 10) (1 : Fin 10) :=
  entry_eq.trans (matrixOne_off10 (3 : Fin 10) (1 : Fin 10) (by decide)).symm

end V14Formalization.D12PieceAPSplitEntry3_1


namespace V14Formalization.D12PieceAPSplitEntry3_2
open D12CyclotomicVec D12CyclotomicVecZ D12PieceAPData
def payloadSha256 : String := "76c6196f29afe1a8398af99502447f48ebeed4bcb3805fc5dbec693940bc04b0"

def scale : ℤ := 66

def XZ (k : Fin 20) : VecZ :=
  match k.val with
  | 0 => #v[41, 40, 112, 50, 35, 92, 63, 53, 29, 123]
  | 1 => #v[-7, -28, 10, 29, -3, -18, -3, 10, -2, 45]
  | 2 => #v[-130, 14, -151, -73, -55, -110, -37, -135, 19, -222]
  | 3 => #v[171, 16, 5, 18, 25, 84, -13, 116, -33, 73]
  | 4 => #v[7, 32, 17, -25, -25, 6, 39, 1, 2, -10]
  | 5 => #v[-178, -66, -88, -100, -132, -118, -22, -184, -60, -108]
  | 6 => #v[24, -28, 16, -36, -2, 48, 2, -18, -62, 78]
  | 7 => #v[-226, -6, -154, -134, -112, -126, -4, -250, -4, -194]
  | 8 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  | 9 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  | 10 => #v[22, 55, 66, 44, 0, 0, 44, 55, 66, 11]
  | 11 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
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
  | 0 => #v[6, -6, -6, -6, -6, 6, 0, 0, 12, 0]
  | 1 => #v[6, 6, 0, -6, 0, -6, 12, -6, 0, -6]
  | 2 => #v[48, -6, -12, -18, -12, -12, -18, -12, -6, -18]
  | 3 => #v[-12, -6, -6, -12, -12, -6, -6, -12, 0, 6]
  | 4 => #v[-12, -12, -6, 6, -6, -12, -12, 0, -6, -6]
  | 5 => #v[0, 0, 0, 0, 0, 0, -9, 9, 9, -9]
  | 6 => #v[9, 9, 9, 0, 9, 9, 18, 18, 9, 9]
  | 7 => #v[-9, 0, -9, -9, -18, -9, -9, -18, -9, -9]
  | 8 => #v[0, -9, 0, 9, 0, 9, 0, -9, 0, 0]
  | 9 => #v[9, 9, 9, 9, 0, 18, 9, 9, 9, 18]
  | 10 => #v[6, 6, 0, -6, 0, -6, 12, -6, 0, -6]
  | 11 => #v[12, 18, 12, 0, 6, 6, 0, 0, 6, 6]
  | 12 => #v[-54, 0, -6, -6, 6, 0, 0, 6, -6, -6]
  | 13 => #v[6, 12, 0, 18, 0, 12, 6, 0, 6, 6]
  | 14 => #v[-12, -12, -6, -18, -18, -18, -18, -6, -12, -12]
  | 15 => #v[9, 18, 9, 18, 9, 0, 9, 9, 9, 9]
  | 16 => #v[0, -9, 0, 0, 9, 0, 9, 0, 0, -9]
  | 17 => #v[-18, -9, -9, -9, -9, -18, 0, -9, -9, -9]
  | 18 => #v[0, -9, -9, 0, 0, 9, 0, 0, 0, 9]
  | 19 => #v[0, 0, 9, -9, -9, 9, 0, 0, 0, 0]
  | _ => zeroZ

def KZ (k : Fin 1) : VecZ :=
  match k.val with
  | 0 => #v[0, 66, 66, 0, 0, 0, 66, 66, 66, 0]
  | _ => zeroZ

def YZ (k : Fin 1) : VecZ :=
  match k.val with
  | 0 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  | _ => zeroZ

def xaEntryZ : VecZ := sumFin (fun k => mulZ (XZ k) (AZ k))
def kyEntryZ : VecZ := sumFin (fun k => mulZ (KZ k) (YZ k))
def entryZ : VecZ := addZ xaEntryZ kyEntryZ

theorem entryZ_eq : entryZ = zeroZ :=
  eq_of_eqZ (by decide +kernel)

theorem scale_ne_zero : scale ≠ 0 := by
  decide

theorem XZ_scale_0 : toVec (XZ 0) = (scale : ℚ) • XCell3_0 :=
  toVec_eq_smul10 (XZ 0) scale XCell3_0
    (eq_smul_div (41) scale (41) (66) (by decide) (by decide))
    (eq_smul_div (40) scale (20) (33) (by decide) (by decide))
    (eq_smul_div (112) scale (56) (33) (by decide) (by decide))
    (eq_smul_div (50) scale (25) (33) (by decide) (by decide))
    (eq_smul_div (35) scale (35) (66) (by decide) (by decide))
    (eq_smul_div (92) scale (46) (33) (by decide) (by decide))
    (eq_smul_div (63) scale (21) (22) (by decide) (by decide))
    (eq_smul_div (53) scale (53) (66) (by decide) (by decide))
    (eq_smul_div (29) scale (29) (66) (by decide) (by decide))
    (eq_smul_div (123) scale (41) (22) (by decide) (by decide))

theorem XZ_scale_1 : toVec (XZ 1) = (scale : ℚ) • XCell3_1 :=
  toVec_eq_smul10 (XZ 1) scale XCell3_1
    (eq_smul_div (-7) scale (-7) (66) (by decide) (by decide))
    (eq_smul_div (-28) scale (-14) (33) (by decide) (by decide))
    (eq_smul_div (10) scale (5) (33) (by decide) (by decide))
    (eq_smul_div (29) scale (29) (66) (by decide) (by decide))
    (eq_smul_div (-3) scale (-1) (22) (by decide) (by decide))
    (eq_smul_div (-18) scale (-3) (11) (by decide) (by decide))
    (eq_smul_div (-3) scale (-1) (22) (by decide) (by decide))
    (eq_smul_div (10) scale (5) (33) (by decide) (by decide))
    (eq_smul_div (-2) scale (-1) (33) (by decide) (by decide))
    (eq_smul_div (45) scale (15) (22) (by decide) (by decide))

theorem XZ_scale_2 : toVec (XZ 2) = (scale : ℚ) • XCell3_2 :=
  toVec_eq_smul10 (XZ 2) scale XCell3_2
    (eq_smul_div (-130) scale (-65) (33) (by decide) (by decide))
    (eq_smul_div (14) scale (7) (33) (by decide) (by decide))
    (eq_smul_div (-151) scale (-151) (66) (by decide) (by decide))
    (eq_smul_div (-73) scale (-73) (66) (by decide) (by decide))
    (eq_smul_div (-55) scale (-5) (6) (by decide) (by decide))
    (eq_smul_div (-110) scale (-5) (3) (by decide) (by decide))
    (eq_smul_div (-37) scale (-37) (66) (by decide) (by decide))
    (eq_smul_div (-135) scale (-45) (22) (by decide) (by decide))
    (eq_smul_div (19) scale (19) (66) (by decide) (by decide))
    (eq_smul_div (-222) scale (-37) (11) (by decide) (by decide))

theorem XZ_scale_3 : toVec (XZ 3) = (scale : ℚ) • XCell3_3 :=
  toVec_eq_smul10 (XZ 3) scale XCell3_3
    (eq_smul_div (171) scale (57) (22) (by decide) (by decide))
    (eq_smul_div (16) scale (8) (33) (by decide) (by decide))
    (eq_smul_div (5) scale (5) (66) (by decide) (by decide))
    (eq_smul_div (18) scale (3) (11) (by decide) (by decide))
    (eq_smul_div (25) scale (25) (66) (by decide) (by decide))
    (eq_smul_div (84) scale (14) (11) (by decide) (by decide))
    (eq_smul_div (-13) scale (-13) (66) (by decide) (by decide))
    (eq_smul_div (116) scale (58) (33) (by decide) (by decide))
    (eq_smul_div (-33) scale (-1) (2) (by decide) (by decide))
    (eq_smul_div (73) scale (73) (66) (by decide) (by decide))

theorem XZ_scale_4 : toVec (XZ 4) = (scale : ℚ) • XCell3_4 :=
  toVec_eq_smul10 (XZ 4) scale XCell3_4
    (eq_smul_div (7) scale (7) (66) (by decide) (by decide))
    (eq_smul_div (32) scale (16) (33) (by decide) (by decide))
    (eq_smul_div (17) scale (17) (66) (by decide) (by decide))
    (eq_smul_div (-25) scale (-25) (66) (by decide) (by decide))
    (eq_smul_div (-25) scale (-25) (66) (by decide) (by decide))
    (eq_smul_div (6) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (39) scale (13) (22) (by decide) (by decide))
    (eq_smul_div (1) scale (1) (66) (by decide) (by decide))
    (eq_smul_div (2) scale (1) (33) (by decide) (by decide))
    (eq_smul_div (-10) scale (-5) (33) (by decide) (by decide))

theorem XZ_scale_5 : toVec (XZ 5) = (scale : ℚ) • XCell3_5 :=
  toVec_eq_smul10 (XZ 5) scale XCell3_5
    (eq_smul_div (-178) scale (-89) (33) (by decide) (by decide))
    (eq_smul_int (-66) scale (-1) (by decide))
    (eq_smul_div (-88) scale (-4) (3) (by decide) (by decide))
    (eq_smul_div (-100) scale (-50) (33) (by decide) (by decide))
    (eq_smul_int (-132) scale (-2) (by decide))
    (eq_smul_div (-118) scale (-59) (33) (by decide) (by decide))
    (eq_smul_div (-22) scale (-1) (3) (by decide) (by decide))
    (eq_smul_div (-184) scale (-92) (33) (by decide) (by decide))
    (eq_smul_div (-60) scale (-10) (11) (by decide) (by decide))
    (eq_smul_div (-108) scale (-18) (11) (by decide) (by decide))

theorem XZ_scale_6 : toVec (XZ 6) = (scale : ℚ) • XCell3_6 :=
  toVec_eq_smul10 (XZ 6) scale XCell3_6
    (eq_smul_div (24) scale (4) (11) (by decide) (by decide))
    (eq_smul_div (-28) scale (-14) (33) (by decide) (by decide))
    (eq_smul_div (16) scale (8) (33) (by decide) (by decide))
    (eq_smul_div (-36) scale (-6) (11) (by decide) (by decide))
    (eq_smul_div (-2) scale (-1) (33) (by decide) (by decide))
    (eq_smul_div (48) scale (8) (11) (by decide) (by decide))
    (eq_smul_div (2) scale (1) (33) (by decide) (by decide))
    (eq_smul_div (-18) scale (-3) (11) (by decide) (by decide))
    (eq_smul_div (-62) scale (-31) (33) (by decide) (by decide))
    (eq_smul_div (78) scale (13) (11) (by decide) (by decide))

theorem XZ_scale_7 : toVec (XZ 7) = (scale : ℚ) • XCell3_7 :=
  toVec_eq_smul10 (XZ 7) scale XCell3_7
    (eq_smul_div (-226) scale (-113) (33) (by decide) (by decide))
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-154) scale (-7) (3) (by decide) (by decide))
    (eq_smul_div (-134) scale (-67) (33) (by decide) (by decide))
    (eq_smul_div (-112) scale (-56) (33) (by decide) (by decide))
    (eq_smul_div (-126) scale (-21) (11) (by decide) (by decide))
    (eq_smul_div (-4) scale (-2) (33) (by decide) (by decide))
    (eq_smul_div (-250) scale (-125) (33) (by decide) (by decide))
    (eq_smul_div (-4) scale (-2) (33) (by decide) (by decide))
    (eq_smul_div (-194) scale (-97) (33) (by decide) (by decide))

theorem XZ_scale_8 : toVec (XZ 8) = (scale : ℚ) • XCell3_8 :=
  toVec_eq_smul10 (XZ 8) scale XCell3_8
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

theorem XZ_scale_9 : toVec (XZ 9) = (scale : ℚ) • XCell3_9 :=
  toVec_eq_smul10 (XZ 9) scale XCell3_9
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

theorem XZ_scale_10 : toVec (XZ 10) = (scale : ℚ) • XCell3_10 :=
  toVec_eq_smul10 (XZ 10) scale XCell3_10
    (eq_smul_div (22) scale (1) (3) (by decide) (by decide))
    (eq_smul_div (55) scale (5) (6) (by decide) (by decide))
    (eq_smul_int (66) scale (1) (by decide))
    (eq_smul_div (44) scale (2) (3) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (44) scale (2) (3) (by decide) (by decide))
    (eq_smul_div (55) scale (5) (6) (by decide) (by decide))
    (eq_smul_int (66) scale (1) (by decide))
    (eq_smul_div (11) scale (1) (6) (by decide) (by decide))

theorem XZ_scale_11 : toVec (XZ 11) = (scale : ℚ) • XCell3_11 :=
  toVec_eq_smul10 (XZ 11) scale XCell3_11
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

theorem XZ_scale_12 : toVec (XZ 12) = (scale : ℚ) • XCell3_12 :=
  toVec_eq_smul10 (XZ 12) scale XCell3_12
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

theorem XZ_scale_13 : toVec (XZ 13) = (scale : ℚ) • XCell3_13 :=
  toVec_eq_smul10 (XZ 13) scale XCell3_13
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

theorem XZ_scale_14 : toVec (XZ 14) = (scale : ℚ) • XCell3_14 :=
  toVec_eq_smul10 (XZ 14) scale XCell3_14
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

theorem XZ_scale_15 : toVec (XZ 15) = (scale : ℚ) • XCell3_15 :=
  toVec_eq_smul10 (XZ 15) scale XCell3_15
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

theorem XZ_scale_16 : toVec (XZ 16) = (scale : ℚ) • XCell3_16 :=
  toVec_eq_smul10 (XZ 16) scale XCell3_16
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

theorem XZ_scale_17 : toVec (XZ 17) = (scale : ℚ) • XCell3_17 :=
  toVec_eq_smul10 (XZ 17) scale XCell3_17
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

theorem XZ_scale_18 : toVec (XZ 18) = (scale : ℚ) • XCell3_18 :=
  toVec_eq_smul10 (XZ 18) scale XCell3_18
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

theorem XZ_scale_19 : toVec (XZ 19) = (scale : ℚ) • XCell3_19 :=
  toVec_eq_smul10 (XZ 19) scale XCell3_19
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
    toVec (XZ k) = (scale : ℚ) • XVec (3 : Fin 10) k :=
  forall_fin20 (P := fun k => toVec (XZ k) = (scale : ℚ) • XVec (3 : Fin 10) k)
    XZ_scale_0 XZ_scale_1 XZ_scale_2 XZ_scale_3 XZ_scale_4 XZ_scale_5 XZ_scale_6 XZ_scale_7 XZ_scale_8 XZ_scale_9 XZ_scale_10 XZ_scale_11 XZ_scale_12 XZ_scale_13 XZ_scale_14 XZ_scale_15 XZ_scale_16 XZ_scale_17 XZ_scale_18 XZ_scale_19 k

theorem AZ_scale_0 : toVec (AZ 0) = (scale : ℚ) • ACell0_2 :=
  toVec_eq_smul10 (AZ 0) scale ACell0_2
    (eq_smul_div (6) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (6) scale (1) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_zero scale)

theorem AZ_scale_1 : toVec (AZ 1) = (scale : ℚ) • ACell1_2 :=
  toVec_eq_smul10 (AZ 1) scale ACell1_2
    (eq_smul_div (6) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (6) scale (1) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))

theorem AZ_scale_2 : toVec (AZ 2) = (scale : ℚ) • ACell2_2 :=
  toVec_eq_smul10 (AZ 2) scale ACell2_2
    (eq_smul_div (48) scale (8) (11) (by decide) (by decide))
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-12) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-18) scale (-3) (11) (by decide) (by decide))
    (eq_smul_div (-12) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-12) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-18) scale (-3) (11) (by decide) (by decide))
    (eq_smul_div (-12) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-18) scale (-3) (11) (by decide) (by decide))

theorem AZ_scale_3 : toVec (AZ 3) = (scale : ℚ) • ACell3_2 :=
  toVec_eq_smul10 (AZ 3) scale ACell3_2
    (eq_smul_div (-12) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-12) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-12) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-12) scale (-2) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (6) scale (1) (11) (by decide) (by decide))

theorem AZ_scale_4 : toVec (AZ 4) = (scale : ℚ) • ACell4_2 :=
  toVec_eq_smul10 (AZ 4) scale ACell4_2
    (eq_smul_div (-12) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-12) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (6) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-12) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-12) scale (-2) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))

theorem AZ_scale_5 : toVec (AZ 5) = (scale : ℚ) • ACell5_2 :=
  toVec_eq_smul10 (AZ 5) scale ACell5_2
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (-9) scale (-3) (22) (by decide) (by decide))
    (eq_smul_div (9) scale (3) (22) (by decide) (by decide))
    (eq_smul_div (9) scale (3) (22) (by decide) (by decide))
    (eq_smul_div (-9) scale (-3) (22) (by decide) (by decide))

theorem AZ_scale_6 : toVec (AZ 6) = (scale : ℚ) • ACell6_2 :=
  toVec_eq_smul10 (AZ 6) scale ACell6_2
    (eq_smul_div (9) scale (3) (22) (by decide) (by decide))
    (eq_smul_div (9) scale (3) (22) (by decide) (by decide))
    (eq_smul_div (9) scale (3) (22) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (9) scale (3) (22) (by decide) (by decide))
    (eq_smul_div (9) scale (3) (22) (by decide) (by decide))
    (eq_smul_div (18) scale (3) (11) (by decide) (by decide))
    (eq_smul_div (18) scale (3) (11) (by decide) (by decide))
    (eq_smul_div (9) scale (3) (22) (by decide) (by decide))
    (eq_smul_div (9) scale (3) (22) (by decide) (by decide))

theorem AZ_scale_7 : toVec (AZ 7) = (scale : ℚ) • ACell7_2 :=
  toVec_eq_smul10 (AZ 7) scale ACell7_2
    (eq_smul_div (-9) scale (-3) (22) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-9) scale (-3) (22) (by decide) (by decide))
    (eq_smul_div (-9) scale (-3) (22) (by decide) (by decide))
    (eq_smul_div (-18) scale (-3) (11) (by decide) (by decide))
    (eq_smul_div (-9) scale (-3) (22) (by decide) (by decide))
    (eq_smul_div (-9) scale (-3) (22) (by decide) (by decide))
    (eq_smul_div (-18) scale (-3) (11) (by decide) (by decide))
    (eq_smul_div (-9) scale (-3) (22) (by decide) (by decide))
    (eq_smul_div (-9) scale (-3) (22) (by decide) (by decide))

theorem AZ_scale_8 : toVec (AZ 8) = (scale : ℚ) • ACell8_2 :=
  toVec_eq_smul10 (AZ 8) scale ACell8_2
    (eq_smul_zero scale)
    (eq_smul_div (-9) scale (-3) (22) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (9) scale (3) (22) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (9) scale (3) (22) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-9) scale (-3) (22) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)

theorem AZ_scale_9 : toVec (AZ 9) = (scale : ℚ) • ACell9_2 :=
  toVec_eq_smul10 (AZ 9) scale ACell9_2
    (eq_smul_div (9) scale (3) (22) (by decide) (by decide))
    (eq_smul_div (9) scale (3) (22) (by decide) (by decide))
    (eq_smul_div (9) scale (3) (22) (by decide) (by decide))
    (eq_smul_div (9) scale (3) (22) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (18) scale (3) (11) (by decide) (by decide))
    (eq_smul_div (9) scale (3) (22) (by decide) (by decide))
    (eq_smul_div (9) scale (3) (22) (by decide) (by decide))
    (eq_smul_div (9) scale (3) (22) (by decide) (by decide))
    (eq_smul_div (18) scale (3) (11) (by decide) (by decide))

theorem AZ_scale_10 : toVec (AZ 10) = (scale : ℚ) • ACell10_2 :=
  toVec_eq_smul10 (AZ 10) scale ACell10_2
    (eq_smul_div (6) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (6) scale (1) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))

theorem AZ_scale_11 : toVec (AZ 11) = (scale : ℚ) • ACell11_2 :=
  toVec_eq_smul10 (AZ 11) scale ACell11_2
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (18) scale (3) (11) (by decide) (by decide))
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (6) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (6) scale (1) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (6) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (6) scale (1) (11) (by decide) (by decide))

theorem AZ_scale_12 : toVec (AZ 12) = (scale : ℚ) • ACell12_2 :=
  toVec_eq_smul10 (AZ 12) scale ACell12_2
    (eq_smul_div (-54) scale (-9) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (6) scale (1) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (6) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))

theorem AZ_scale_13 : toVec (AZ 13) = (scale : ℚ) • ACell13_2 :=
  toVec_eq_smul10 (AZ 13) scale ACell13_2
    (eq_smul_div (6) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (18) scale (3) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (6) scale (1) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (6) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (6) scale (1) (11) (by decide) (by decide))

theorem AZ_scale_14 : toVec (AZ 14) = (scale : ℚ) • ACell14_2 :=
  toVec_eq_smul10 (AZ 14) scale ACell14_2
    (eq_smul_div (-12) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-12) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-18) scale (-3) (11) (by decide) (by decide))
    (eq_smul_div (-18) scale (-3) (11) (by decide) (by decide))
    (eq_smul_div (-18) scale (-3) (11) (by decide) (by decide))
    (eq_smul_div (-18) scale (-3) (11) (by decide) (by decide))
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-12) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-12) scale (-2) (11) (by decide) (by decide))

theorem AZ_scale_15 : toVec (AZ 15) = (scale : ℚ) • ACell15_2 :=
  toVec_eq_smul10 (AZ 15) scale ACell15_2
    (eq_smul_div (9) scale (3) (22) (by decide) (by decide))
    (eq_smul_div (18) scale (3) (11) (by decide) (by decide))
    (eq_smul_div (9) scale (3) (22) (by decide) (by decide))
    (eq_smul_div (18) scale (3) (11) (by decide) (by decide))
    (eq_smul_div (9) scale (3) (22) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (9) scale (3) (22) (by decide) (by decide))
    (eq_smul_div (9) scale (3) (22) (by decide) (by decide))
    (eq_smul_div (9) scale (3) (22) (by decide) (by decide))
    (eq_smul_div (9) scale (3) (22) (by decide) (by decide))

theorem AZ_scale_16 : toVec (AZ 16) = (scale : ℚ) • ACell16_2 :=
  toVec_eq_smul10 (AZ 16) scale ACell16_2
    (eq_smul_zero scale)
    (eq_smul_div (-9) scale (-3) (22) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (9) scale (3) (22) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (9) scale (3) (22) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (-9) scale (-3) (22) (by decide) (by decide))

theorem AZ_scale_17 : toVec (AZ 17) = (scale : ℚ) • ACell17_2 :=
  toVec_eq_smul10 (AZ 17) scale ACell17_2
    (eq_smul_div (-18) scale (-3) (11) (by decide) (by decide))
    (eq_smul_div (-9) scale (-3) (22) (by decide) (by decide))
    (eq_smul_div (-9) scale (-3) (22) (by decide) (by decide))
    (eq_smul_div (-9) scale (-3) (22) (by decide) (by decide))
    (eq_smul_div (-9) scale (-3) (22) (by decide) (by decide))
    (eq_smul_div (-18) scale (-3) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-9) scale (-3) (22) (by decide) (by decide))
    (eq_smul_div (-9) scale (-3) (22) (by decide) (by decide))
    (eq_smul_div (-9) scale (-3) (22) (by decide) (by decide))

theorem AZ_scale_18 : toVec (AZ 18) = (scale : ℚ) • ACell18_2 :=
  toVec_eq_smul10 (AZ 18) scale ACell18_2
    (eq_smul_zero scale)
    (eq_smul_div (-9) scale (-3) (22) (by decide) (by decide))
    (eq_smul_div (-9) scale (-3) (22) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (9) scale (3) (22) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (9) scale (3) (22) (by decide) (by decide))

theorem AZ_scale_19 : toVec (AZ 19) = (scale : ℚ) • ACell19_2 :=
  toVec_eq_smul10 (AZ 19) scale ACell19_2
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (9) scale (3) (22) (by decide) (by decide))
    (eq_smul_div (-9) scale (-3) (22) (by decide) (by decide))
    (eq_smul_div (-9) scale (-3) (22) (by decide) (by decide))
    (eq_smul_div (9) scale (3) (22) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)

theorem AZ_scale (k : Fin 20) :
    toVec (AZ k) = (scale : ℚ) • AVec k (2 : Fin 10) :=
  forall_fin20 (P := fun k => toVec (AZ k) = (scale : ℚ) • AVec k (2 : Fin 10))
    AZ_scale_0 AZ_scale_1 AZ_scale_2 AZ_scale_3 AZ_scale_4 AZ_scale_5 AZ_scale_6 AZ_scale_7 AZ_scale_8 AZ_scale_9 AZ_scale_10 AZ_scale_11 AZ_scale_12 AZ_scale_13 AZ_scale_14 AZ_scale_15 AZ_scale_16 AZ_scale_17 AZ_scale_18 AZ_scale_19 k

theorem KZ_scale_0 : toVec (KZ 0) = (scale : ℚ) • KCell3_0 :=
  toVec_eq_smul10 (KZ 0) scale KCell3_0
    (eq_smul_zero scale)
    (eq_smul_int (66) scale (1) (by decide))
    (eq_smul_int (66) scale (1) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_int (66) scale (1) (by decide))
    (eq_smul_int (66) scale (1) (by decide))
    (eq_smul_int (66) scale (1) (by decide))
    (eq_smul_zero scale)

theorem KZ_scale (k : Fin 1) :
    toVec (KZ k) = (scale : ℚ) • KVec (3 : Fin 10) k :=
  forall_fin1 (P := fun k => toVec (KZ k) = (scale : ℚ) • KVec (3 : Fin 10) k)
    KZ_scale_0 k

theorem YZ_scale_0 : toVec (YZ 0) = (scale : ℚ) • YCell0_2 :=
  toVec_eq_smul10 (YZ 0) scale YCell0_2
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

theorem YZ_scale (k : Fin 1) :
    toVec (YZ k) = (scale : ℚ) • YVec k (2 : Fin 10) :=
  forall_fin1 (P := fun k => toVec (YZ k) = (scale : ℚ) • YVec k (2 : Fin 10))
    YZ_scale_0 k

theorem entry_eq :
    (matrixMul XVec AVec + matrixMul KVec YVec)
        (3 : Fin 10) (2 : Fin 10) = ![0, 0, 0, 0, 0, 0, 0, 0, 0, 0] := by
  change (∑ k : Fin 20, mul (XVec (3 : Fin 10) k)
      (AVec k (2 : Fin 10))) +
    (∑ k : Fin 1, mul (KVec (3 : Fin 10) k)
      (YVec k (2 : Fin 10))) = _
  refine add_sum_mul_eq_of_scaled scale scale_ne_zero
    (fun k => XVec (3 : Fin 10) k)
    (fun k => AVec k (2 : Fin 10))
    (fun k => KVec (3 : Fin 10) k)
    (fun k => YVec k (2 : Fin 10))
    XZ AZ KZ YZ XZ_scale AZ_scale KZ_scale YZ_scale entryZ rfl _ ?_
  rw [entryZ_eq, toVec_zeroZ_smul, vec_zero_eq]

theorem entry_eq_matrixOne :
    (matrixMul XVec AVec + matrixMul KVec YVec)
        (3 : Fin 10) (2 : Fin 10) =
      matrixOne (Fin 10) (3 : Fin 10) (2 : Fin 10) :=
  entry_eq.trans (matrixOne_off10 (3 : Fin 10) (2 : Fin 10) (by decide)).symm

end V14Formalization.D12PieceAPSplitEntry3_2


namespace V14Formalization.D12PieceAPSplitEntry3_3
open D12CyclotomicVec D12CyclotomicVecZ D12PieceAPData
def payloadSha256 : String := "76c6196f29afe1a8398af99502447f48ebeed4bcb3805fc5dbec693940bc04b0"

def scale : ℤ := 66

def XZ (k : Fin 20) : VecZ :=
  match k.val with
  | 0 => #v[41, 40, 112, 50, 35, 92, 63, 53, 29, 123]
  | 1 => #v[-7, -28, 10, 29, -3, -18, -3, 10, -2, 45]
  | 2 => #v[-130, 14, -151, -73, -55, -110, -37, -135, 19, -222]
  | 3 => #v[171, 16, 5, 18, 25, 84, -13, 116, -33, 73]
  | 4 => #v[7, 32, 17, -25, -25, 6, 39, 1, 2, -10]
  | 5 => #v[-178, -66, -88, -100, -132, -118, -22, -184, -60, -108]
  | 6 => #v[24, -28, 16, -36, -2, 48, 2, -18, -62, 78]
  | 7 => #v[-226, -6, -154, -134, -112, -126, -4, -250, -4, -194]
  | 8 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  | 9 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  | 10 => #v[22, 55, 66, 44, 0, 0, 44, 55, 66, 11]
  | 11 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
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
  | 0 => #v[12, 6, 6, 12, 0, 0, 6, 18, 6, 0]
  | 1 => #v[0, 0, 12, 6, 6, 18, 6, 6, 12, 0]
  | 2 => #v[-12, -6, -6, -12, -12, -6, -6, -12, 0, 6]
  | 3 => #v[60, 0, 6, 6, 0, -6, 0, -6, 12, -6]
  | 4 => #v[6, -6, 12, -6, 6, 0, -6, 0, 0, -6]
  | 5 => #v[9, 9, 9, 0, 18, 9, 9, 9, 9, 18]
  | 6 => #v[9, 0, 9, 18, 9, 9, 9, 9, 18, 9]
  | 7 => #v[0, -9, 0, 0, 9, 9, 0, 0, -9, 0]
  | 8 => #v[9, 9, 9, 9, 9, 9, 9, 0, 18, 18]
  | 9 => #v[9, 9, 0, 9, 9, 18, 9, 18, 9, 9]
  | 10 => #v[12, 6, 6, 18, 6, 6, 12, 0, 0, 0]
  | 11 => #v[6, 0, 6, 12, 12, 6, 0, 6, 0, 18]
  | 12 => #v[-6, -12, -6, -6, -12, -6, 0, -12, 6, -12]
  | 13 => #v[-60, 0, -12, -6, -6, -12, -12, -6, -6, -12]
  | 14 => #v[12, 6, 6, 12, 0, 0, 6, 18, 6, 0]
  | 15 => #v[0, 0, 0, -9, 9, 9, -9, 0, 0, 0]
  | 16 => #v[-9, 0, 0, 0, -9, 0, 0, 9, 9, 0]
  | 17 => #v[0, -9, 0, 0, 9, 0, 9, 0, 0, -9]
  | 18 => #v[0, -9, 0, 9, 0, 9, 0, -9, 0, 0]
  | 19 => #v[0, 0, 0, -9, 9, 0, 0, 0, 9, -9]
  | _ => zeroZ

def KZ (k : Fin 1) : VecZ :=
  match k.val with
  | 0 => #v[0, 66, 66, 0, 0, 0, 66, 66, 66, 0]
  | _ => zeroZ

def YZ (k : Fin 1) : VecZ :=
  match k.val with
  | 0 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  | _ => zeroZ

def xaEntryZ : VecZ := sumFin (fun k => mulZ (XZ k) (AZ k))
def kyEntryZ : VecZ := sumFin (fun k => mulZ (KZ k) (YZ k))
def entryZ : VecZ := addZ xaEntryZ kyEntryZ

theorem entryZ_eq : entryZ = scaleSqE0 scale :=
  eq_of_eqZ (by decide +kernel)

theorem scale_ne_zero : scale ≠ 0 := by
  decide

theorem XZ_scale_0 : toVec (XZ 0) = (scale : ℚ) • XCell3_0 :=
  toVec_eq_smul10 (XZ 0) scale XCell3_0
    (eq_smul_div (41) scale (41) (66) (by decide) (by decide))
    (eq_smul_div (40) scale (20) (33) (by decide) (by decide))
    (eq_smul_div (112) scale (56) (33) (by decide) (by decide))
    (eq_smul_div (50) scale (25) (33) (by decide) (by decide))
    (eq_smul_div (35) scale (35) (66) (by decide) (by decide))
    (eq_smul_div (92) scale (46) (33) (by decide) (by decide))
    (eq_smul_div (63) scale (21) (22) (by decide) (by decide))
    (eq_smul_div (53) scale (53) (66) (by decide) (by decide))
    (eq_smul_div (29) scale (29) (66) (by decide) (by decide))
    (eq_smul_div (123) scale (41) (22) (by decide) (by decide))

theorem XZ_scale_1 : toVec (XZ 1) = (scale : ℚ) • XCell3_1 :=
  toVec_eq_smul10 (XZ 1) scale XCell3_1
    (eq_smul_div (-7) scale (-7) (66) (by decide) (by decide))
    (eq_smul_div (-28) scale (-14) (33) (by decide) (by decide))
    (eq_smul_div (10) scale (5) (33) (by decide) (by decide))
    (eq_smul_div (29) scale (29) (66) (by decide) (by decide))
    (eq_smul_div (-3) scale (-1) (22) (by decide) (by decide))
    (eq_smul_div (-18) scale (-3) (11) (by decide) (by decide))
    (eq_smul_div (-3) scale (-1) (22) (by decide) (by decide))
    (eq_smul_div (10) scale (5) (33) (by decide) (by decide))
    (eq_smul_div (-2) scale (-1) (33) (by decide) (by decide))
    (eq_smul_div (45) scale (15) (22) (by decide) (by decide))

theorem XZ_scale_2 : toVec (XZ 2) = (scale : ℚ) • XCell3_2 :=
  toVec_eq_smul10 (XZ 2) scale XCell3_2
    (eq_smul_div (-130) scale (-65) (33) (by decide) (by decide))
    (eq_smul_div (14) scale (7) (33) (by decide) (by decide))
    (eq_smul_div (-151) scale (-151) (66) (by decide) (by decide))
    (eq_smul_div (-73) scale (-73) (66) (by decide) (by decide))
    (eq_smul_div (-55) scale (-5) (6) (by decide) (by decide))
    (eq_smul_div (-110) scale (-5) (3) (by decide) (by decide))
    (eq_smul_div (-37) scale (-37) (66) (by decide) (by decide))
    (eq_smul_div (-135) scale (-45) (22) (by decide) (by decide))
    (eq_smul_div (19) scale (19) (66) (by decide) (by decide))
    (eq_smul_div (-222) scale (-37) (11) (by decide) (by decide))

theorem XZ_scale_3 : toVec (XZ 3) = (scale : ℚ) • XCell3_3 :=
  toVec_eq_smul10 (XZ 3) scale XCell3_3
    (eq_smul_div (171) scale (57) (22) (by decide) (by decide))
    (eq_smul_div (16) scale (8) (33) (by decide) (by decide))
    (eq_smul_div (5) scale (5) (66) (by decide) (by decide))
    (eq_smul_div (18) scale (3) (11) (by decide) (by decide))
    (eq_smul_div (25) scale (25) (66) (by decide) (by decide))
    (eq_smul_div (84) scale (14) (11) (by decide) (by decide))
    (eq_smul_div (-13) scale (-13) (66) (by decide) (by decide))
    (eq_smul_div (116) scale (58) (33) (by decide) (by decide))
    (eq_smul_div (-33) scale (-1) (2) (by decide) (by decide))
    (eq_smul_div (73) scale (73) (66) (by decide) (by decide))

theorem XZ_scale_4 : toVec (XZ 4) = (scale : ℚ) • XCell3_4 :=
  toVec_eq_smul10 (XZ 4) scale XCell3_4
    (eq_smul_div (7) scale (7) (66) (by decide) (by decide))
    (eq_smul_div (32) scale (16) (33) (by decide) (by decide))
    (eq_smul_div (17) scale (17) (66) (by decide) (by decide))
    (eq_smul_div (-25) scale (-25) (66) (by decide) (by decide))
    (eq_smul_div (-25) scale (-25) (66) (by decide) (by decide))
    (eq_smul_div (6) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (39) scale (13) (22) (by decide) (by decide))
    (eq_smul_div (1) scale (1) (66) (by decide) (by decide))
    (eq_smul_div (2) scale (1) (33) (by decide) (by decide))
    (eq_smul_div (-10) scale (-5) (33) (by decide) (by decide))

theorem XZ_scale_5 : toVec (XZ 5) = (scale : ℚ) • XCell3_5 :=
  toVec_eq_smul10 (XZ 5) scale XCell3_5
    (eq_smul_div (-178) scale (-89) (33) (by decide) (by decide))
    (eq_smul_int (-66) scale (-1) (by decide))
    (eq_smul_div (-88) scale (-4) (3) (by decide) (by decide))
    (eq_smul_div (-100) scale (-50) (33) (by decide) (by decide))
    (eq_smul_int (-132) scale (-2) (by decide))
    (eq_smul_div (-118) scale (-59) (33) (by decide) (by decide))
    (eq_smul_div (-22) scale (-1) (3) (by decide) (by decide))
    (eq_smul_div (-184) scale (-92) (33) (by decide) (by decide))
    (eq_smul_div (-60) scale (-10) (11) (by decide) (by decide))
    (eq_smul_div (-108) scale (-18) (11) (by decide) (by decide))

theorem XZ_scale_6 : toVec (XZ 6) = (scale : ℚ) • XCell3_6 :=
  toVec_eq_smul10 (XZ 6) scale XCell3_6
    (eq_smul_div (24) scale (4) (11) (by decide) (by decide))
    (eq_smul_div (-28) scale (-14) (33) (by decide) (by decide))
    (eq_smul_div (16) scale (8) (33) (by decide) (by decide))
    (eq_smul_div (-36) scale (-6) (11) (by decide) (by decide))
    (eq_smul_div (-2) scale (-1) (33) (by decide) (by decide))
    (eq_smul_div (48) scale (8) (11) (by decide) (by decide))
    (eq_smul_div (2) scale (1) (33) (by decide) (by decide))
    (eq_smul_div (-18) scale (-3) (11) (by decide) (by decide))
    (eq_smul_div (-62) scale (-31) (33) (by decide) (by decide))
    (eq_smul_div (78) scale (13) (11) (by decide) (by decide))

theorem XZ_scale_7 : toVec (XZ 7) = (scale : ℚ) • XCell3_7 :=
  toVec_eq_smul10 (XZ 7) scale XCell3_7
    (eq_smul_div (-226) scale (-113) (33) (by decide) (by decide))
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-154) scale (-7) (3) (by decide) (by decide))
    (eq_smul_div (-134) scale (-67) (33) (by decide) (by decide))
    (eq_smul_div (-112) scale (-56) (33) (by decide) (by decide))
    (eq_smul_div (-126) scale (-21) (11) (by decide) (by decide))
    (eq_smul_div (-4) scale (-2) (33) (by decide) (by decide))
    (eq_smul_div (-250) scale (-125) (33) (by decide) (by decide))
    (eq_smul_div (-4) scale (-2) (33) (by decide) (by decide))
    (eq_smul_div (-194) scale (-97) (33) (by decide) (by decide))

theorem XZ_scale_8 : toVec (XZ 8) = (scale : ℚ) • XCell3_8 :=
  toVec_eq_smul10 (XZ 8) scale XCell3_8
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

theorem XZ_scale_9 : toVec (XZ 9) = (scale : ℚ) • XCell3_9 :=
  toVec_eq_smul10 (XZ 9) scale XCell3_9
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

theorem XZ_scale_10 : toVec (XZ 10) = (scale : ℚ) • XCell3_10 :=
  toVec_eq_smul10 (XZ 10) scale XCell3_10
    (eq_smul_div (22) scale (1) (3) (by decide) (by decide))
    (eq_smul_div (55) scale (5) (6) (by decide) (by decide))
    (eq_smul_int (66) scale (1) (by decide))
    (eq_smul_div (44) scale (2) (3) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (44) scale (2) (3) (by decide) (by decide))
    (eq_smul_div (55) scale (5) (6) (by decide) (by decide))
    (eq_smul_int (66) scale (1) (by decide))
    (eq_smul_div (11) scale (1) (6) (by decide) (by decide))

theorem XZ_scale_11 : toVec (XZ 11) = (scale : ℚ) • XCell3_11 :=
  toVec_eq_smul10 (XZ 11) scale XCell3_11
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

theorem XZ_scale_12 : toVec (XZ 12) = (scale : ℚ) • XCell3_12 :=
  toVec_eq_smul10 (XZ 12) scale XCell3_12
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

theorem XZ_scale_13 : toVec (XZ 13) = (scale : ℚ) • XCell3_13 :=
  toVec_eq_smul10 (XZ 13) scale XCell3_13
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

theorem XZ_scale_14 : toVec (XZ 14) = (scale : ℚ) • XCell3_14 :=
  toVec_eq_smul10 (XZ 14) scale XCell3_14
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

theorem XZ_scale_15 : toVec (XZ 15) = (scale : ℚ) • XCell3_15 :=
  toVec_eq_smul10 (XZ 15) scale XCell3_15
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

theorem XZ_scale_16 : toVec (XZ 16) = (scale : ℚ) • XCell3_16 :=
  toVec_eq_smul10 (XZ 16) scale XCell3_16
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

theorem XZ_scale_17 : toVec (XZ 17) = (scale : ℚ) • XCell3_17 :=
  toVec_eq_smul10 (XZ 17) scale XCell3_17
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

theorem XZ_scale_18 : toVec (XZ 18) = (scale : ℚ) • XCell3_18 :=
  toVec_eq_smul10 (XZ 18) scale XCell3_18
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

theorem XZ_scale_19 : toVec (XZ 19) = (scale : ℚ) • XCell3_19 :=
  toVec_eq_smul10 (XZ 19) scale XCell3_19
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
    toVec (XZ k) = (scale : ℚ) • XVec (3 : Fin 10) k :=
  forall_fin20 (P := fun k => toVec (XZ k) = (scale : ℚ) • XVec (3 : Fin 10) k)
    XZ_scale_0 XZ_scale_1 XZ_scale_2 XZ_scale_3 XZ_scale_4 XZ_scale_5 XZ_scale_6 XZ_scale_7 XZ_scale_8 XZ_scale_9 XZ_scale_10 XZ_scale_11 XZ_scale_12 XZ_scale_13 XZ_scale_14 XZ_scale_15 XZ_scale_16 XZ_scale_17 XZ_scale_18 XZ_scale_19 k

theorem AZ_scale_0 : toVec (AZ 0) = (scale : ℚ) • ACell0_3 :=
  toVec_eq_smul10 (AZ 0) scale ACell0_3
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (6) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (6) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (6) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (18) scale (3) (11) (by decide) (by decide))
    (eq_smul_div (6) scale (1) (11) (by decide) (by decide))
    (eq_smul_zero scale)

theorem AZ_scale_1 : toVec (AZ 1) = (scale : ℚ) • ACell1_3 :=
  toVec_eq_smul10 (AZ 1) scale ACell1_3
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (6) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (6) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (18) scale (3) (11) (by decide) (by decide))
    (eq_smul_div (6) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (6) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_zero scale)

theorem AZ_scale_2 : toVec (AZ 2) = (scale : ℚ) • ACell2_3 :=
  toVec_eq_smul10 (AZ 2) scale ACell2_3
    (eq_smul_div (-12) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-12) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-12) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-12) scale (-2) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (6) scale (1) (11) (by decide) (by decide))

theorem AZ_scale_3 : toVec (AZ 3) = (scale : ℚ) • ACell3_3 :=
  toVec_eq_smul10 (AZ 3) scale ACell3_3
    (eq_smul_div (60) scale (10) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (6) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (6) scale (1) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))

theorem AZ_scale_4 : toVec (AZ 4) = (scale : ℚ) • ACell4_3 :=
  toVec_eq_smul10 (AZ 4) scale ACell4_3
    (eq_smul_div (6) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (6) scale (1) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))

theorem AZ_scale_5 : toVec (AZ 5) = (scale : ℚ) • ACell5_3 :=
  toVec_eq_smul10 (AZ 5) scale ACell5_3
    (eq_smul_div (9) scale (3) (22) (by decide) (by decide))
    (eq_smul_div (9) scale (3) (22) (by decide) (by decide))
    (eq_smul_div (9) scale (3) (22) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (18) scale (3) (11) (by decide) (by decide))
    (eq_smul_div (9) scale (3) (22) (by decide) (by decide))
    (eq_smul_div (9) scale (3) (22) (by decide) (by decide))
    (eq_smul_div (9) scale (3) (22) (by decide) (by decide))
    (eq_smul_div (9) scale (3) (22) (by decide) (by decide))
    (eq_smul_div (18) scale (3) (11) (by decide) (by decide))

theorem AZ_scale_6 : toVec (AZ 6) = (scale : ℚ) • ACell6_3 :=
  toVec_eq_smul10 (AZ 6) scale ACell6_3
    (eq_smul_div (9) scale (3) (22) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (9) scale (3) (22) (by decide) (by decide))
    (eq_smul_div (18) scale (3) (11) (by decide) (by decide))
    (eq_smul_div (9) scale (3) (22) (by decide) (by decide))
    (eq_smul_div (9) scale (3) (22) (by decide) (by decide))
    (eq_smul_div (9) scale (3) (22) (by decide) (by decide))
    (eq_smul_div (9) scale (3) (22) (by decide) (by decide))
    (eq_smul_div (18) scale (3) (11) (by decide) (by decide))
    (eq_smul_div (9) scale (3) (22) (by decide) (by decide))

theorem AZ_scale_7 : toVec (AZ 7) = (scale : ℚ) • ACell7_3 :=
  toVec_eq_smul10 (AZ 7) scale ACell7_3
    (eq_smul_zero scale)
    (eq_smul_div (-9) scale (-3) (22) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (9) scale (3) (22) (by decide) (by decide))
    (eq_smul_div (9) scale (3) (22) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (-9) scale (-3) (22) (by decide) (by decide))
    (eq_smul_zero scale)

theorem AZ_scale_8 : toVec (AZ 8) = (scale : ℚ) • ACell8_3 :=
  toVec_eq_smul10 (AZ 8) scale ACell8_3
    (eq_smul_div (9) scale (3) (22) (by decide) (by decide))
    (eq_smul_div (9) scale (3) (22) (by decide) (by decide))
    (eq_smul_div (9) scale (3) (22) (by decide) (by decide))
    (eq_smul_div (9) scale (3) (22) (by decide) (by decide))
    (eq_smul_div (9) scale (3) (22) (by decide) (by decide))
    (eq_smul_div (9) scale (3) (22) (by decide) (by decide))
    (eq_smul_div (9) scale (3) (22) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (18) scale (3) (11) (by decide) (by decide))
    (eq_smul_div (18) scale (3) (11) (by decide) (by decide))

theorem AZ_scale_9 : toVec (AZ 9) = (scale : ℚ) • ACell9_3 :=
  toVec_eq_smul10 (AZ 9) scale ACell9_3
    (eq_smul_div (9) scale (3) (22) (by decide) (by decide))
    (eq_smul_div (9) scale (3) (22) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (9) scale (3) (22) (by decide) (by decide))
    (eq_smul_div (9) scale (3) (22) (by decide) (by decide))
    (eq_smul_div (18) scale (3) (11) (by decide) (by decide))
    (eq_smul_div (9) scale (3) (22) (by decide) (by decide))
    (eq_smul_div (18) scale (3) (11) (by decide) (by decide))
    (eq_smul_div (9) scale (3) (22) (by decide) (by decide))
    (eq_smul_div (9) scale (3) (22) (by decide) (by decide))

theorem AZ_scale_10 : toVec (AZ 10) = (scale : ℚ) • ACell10_3 :=
  toVec_eq_smul10 (AZ 10) scale ACell10_3
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (6) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (6) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (18) scale (3) (11) (by decide) (by decide))
    (eq_smul_div (6) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (6) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)

theorem AZ_scale_11 : toVec (AZ 11) = (scale : ℚ) • ACell11_3 :=
  toVec_eq_smul10 (AZ 11) scale ACell11_3
    (eq_smul_div (6) scale (1) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (6) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (6) scale (1) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (6) scale (1) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (18) scale (3) (11) (by decide) (by decide))

theorem AZ_scale_12 : toVec (AZ 12) = (scale : ℚ) • ACell12_3 :=
  toVec_eq_smul10 (AZ 12) scale ACell12_3
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-12) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-12) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-12) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (6) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (-12) scale (-2) (11) (by decide) (by decide))

theorem AZ_scale_13 : toVec (AZ 13) = (scale : ℚ) • ACell13_3 :=
  toVec_eq_smul10 (AZ 13) scale ACell13_3
    (eq_smul_div (-60) scale (-10) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-12) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-12) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-12) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-12) scale (-2) (11) (by decide) (by decide))

theorem AZ_scale_14 : toVec (AZ 14) = (scale : ℚ) • ACell14_3 :=
  toVec_eq_smul10 (AZ 14) scale ACell14_3
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (6) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (6) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (6) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (18) scale (3) (11) (by decide) (by decide))
    (eq_smul_div (6) scale (1) (11) (by decide) (by decide))
    (eq_smul_zero scale)

theorem AZ_scale_15 : toVec (AZ 15) = (scale : ℚ) • ACell15_3 :=
  toVec_eq_smul10 (AZ 15) scale ACell15_3
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (-9) scale (-3) (22) (by decide) (by decide))
    (eq_smul_div (9) scale (3) (22) (by decide) (by decide))
    (eq_smul_div (9) scale (3) (22) (by decide) (by decide))
    (eq_smul_div (-9) scale (-3) (22) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)

theorem AZ_scale_16 : toVec (AZ 16) = (scale : ℚ) • ACell16_3 :=
  toVec_eq_smul10 (AZ 16) scale ACell16_3
    (eq_smul_div (-9) scale (-3) (22) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (-9) scale (-3) (22) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (9) scale (3) (22) (by decide) (by decide))
    (eq_smul_div (9) scale (3) (22) (by decide) (by decide))
    (eq_smul_zero scale)

theorem AZ_scale_17 : toVec (AZ 17) = (scale : ℚ) • ACell17_3 :=
  toVec_eq_smul10 (AZ 17) scale ACell17_3
    (eq_smul_zero scale)
    (eq_smul_div (-9) scale (-3) (22) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (9) scale (3) (22) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (9) scale (3) (22) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (-9) scale (-3) (22) (by decide) (by decide))

theorem AZ_scale_18 : toVec (AZ 18) = (scale : ℚ) • ACell18_3 :=
  toVec_eq_smul10 (AZ 18) scale ACell18_3
    (eq_smul_zero scale)
    (eq_smul_div (-9) scale (-3) (22) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (9) scale (3) (22) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (9) scale (3) (22) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-9) scale (-3) (22) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)

theorem AZ_scale_19 : toVec (AZ 19) = (scale : ℚ) • ACell19_3 :=
  toVec_eq_smul10 (AZ 19) scale ACell19_3
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (-9) scale (-3) (22) (by decide) (by decide))
    (eq_smul_div (9) scale (3) (22) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (9) scale (3) (22) (by decide) (by decide))
    (eq_smul_div (-9) scale (-3) (22) (by decide) (by decide))

theorem AZ_scale (k : Fin 20) :
    toVec (AZ k) = (scale : ℚ) • AVec k (3 : Fin 10) :=
  forall_fin20 (P := fun k => toVec (AZ k) = (scale : ℚ) • AVec k (3 : Fin 10))
    AZ_scale_0 AZ_scale_1 AZ_scale_2 AZ_scale_3 AZ_scale_4 AZ_scale_5 AZ_scale_6 AZ_scale_7 AZ_scale_8 AZ_scale_9 AZ_scale_10 AZ_scale_11 AZ_scale_12 AZ_scale_13 AZ_scale_14 AZ_scale_15 AZ_scale_16 AZ_scale_17 AZ_scale_18 AZ_scale_19 k

theorem KZ_scale_0 : toVec (KZ 0) = (scale : ℚ) • KCell3_0 :=
  toVec_eq_smul10 (KZ 0) scale KCell3_0
    (eq_smul_zero scale)
    (eq_smul_int (66) scale (1) (by decide))
    (eq_smul_int (66) scale (1) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_int (66) scale (1) (by decide))
    (eq_smul_int (66) scale (1) (by decide))
    (eq_smul_int (66) scale (1) (by decide))
    (eq_smul_zero scale)

theorem KZ_scale (k : Fin 1) :
    toVec (KZ k) = (scale : ℚ) • KVec (3 : Fin 10) k :=
  forall_fin1 (P := fun k => toVec (KZ k) = (scale : ℚ) • KVec (3 : Fin 10) k)
    KZ_scale_0 k

theorem YZ_scale_0 : toVec (YZ 0) = (scale : ℚ) • YCell0_3 :=
  toVec_eq_smul10 (YZ 0) scale YCell0_3
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

theorem YZ_scale (k : Fin 1) :
    toVec (YZ k) = (scale : ℚ) • YVec k (3 : Fin 10) :=
  forall_fin1 (P := fun k => toVec (YZ k) = (scale : ℚ) • YVec k (3 : Fin 10))
    YZ_scale_0 k

theorem entry_eq :
    (matrixMul XVec AVec + matrixMul KVec YVec)
        (3 : Fin 10) (3 : Fin 10) = ![1, 0, 0, 0, 0, 0, 0, 0, 0, 0] := by
  change (∑ k : Fin 20, mul (XVec (3 : Fin 10) k)
      (AVec k (3 : Fin 10))) +
    (∑ k : Fin 1, mul (KVec (3 : Fin 10) k)
      (YVec k (3 : Fin 10))) = _
  refine add_sum_mul_eq_of_scaled scale scale_ne_zero
    (fun k => XVec (3 : Fin 10) k)
    (fun k => AVec k (3 : Fin 10))
    (fun k => KVec (3 : Fin 10) k)
    (fun k => YVec k (3 : Fin 10))
    XZ AZ KZ YZ XZ_scale AZ_scale KZ_scale YZ_scale entryZ rfl _ ?_
  rw [entryZ_eq, toVec_scaleSqE0, constVec_one_eq]

theorem entry_eq_matrixOne :
    (matrixMul XVec AVec + matrixMul KVec YVec)
        (3 : Fin 10) (3 : Fin 10) =
      matrixOne (Fin 10) (3 : Fin 10) (3 : Fin 10) :=
  entry_eq.trans (matrixOne_diag10 (3 : Fin 10)).symm

end V14Formalization.D12PieceAPSplitEntry3_3


namespace V14Formalization.D12PieceAPSplitEntry3_4
open D12CyclotomicVec D12CyclotomicVecZ D12PieceAPData
def payloadSha256 : String := "76c6196f29afe1a8398af99502447f48ebeed4bcb3805fc5dbec693940bc04b0"

def scale : ℤ := 66

def XZ (k : Fin 20) : VecZ :=
  match k.val with
  | 0 => #v[41, 40, 112, 50, 35, 92, 63, 53, 29, 123]
  | 1 => #v[-7, -28, 10, 29, -3, -18, -3, 10, -2, 45]
  | 2 => #v[-130, 14, -151, -73, -55, -110, -37, -135, 19, -222]
  | 3 => #v[171, 16, 5, 18, 25, 84, -13, 116, -33, 73]
  | 4 => #v[7, 32, 17, -25, -25, 6, 39, 1, 2, -10]
  | 5 => #v[-178, -66, -88, -100, -132, -118, -22, -184, -60, -108]
  | 6 => #v[24, -28, 16, -36, -2, 48, 2, -18, -62, 78]
  | 7 => #v[-226, -6, -154, -134, -112, -126, -4, -250, -4, -194]
  | 8 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  | 9 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  | 10 => #v[22, 55, 66, 44, 0, 0, 44, 55, 66, 11]
  | 11 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
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
  | 0 => #v[-6, 12, -6, 0, -6, 0, 6, 6, 0, -6]
  | 1 => #v[-6, -18, -12, -12, -18, -18, -12, -12, -18, -6]
  | 2 => #v[-12, -12, -6, 6, -6, -12, -12, 0, -6, -6]
  | 3 => #v[6, -6, 12, -6, 6, 0, -6, 0, 0, -6]
  | 4 => #v[54, -12, -12, -12, 0, -6, -6, 6, -6, -6]
  | 5 => #v[0, 0, 0, -9, 0, 9, 0, 9, 0, -9]
  | 6 => #v[0, -9, 0, 0, 9, 0, 9, 0, 0, -9]
  | 7 => #v[0, -9, 9, 0, 0, 0, 9, -9, 0, 0]
  | 8 => #v[-9, -9, -18, -18, -9, -9, 0, -9, -9, -9]
  | 9 => #v[0, 0, 0, 0, 9, -9, -9, 9, 0, 0]
  | 10 => #v[0, -6, -6, 0, 0, -6, 6, 12, 6, -6]
  | 11 => #v[6, -6, 12, -6, 6, 0, -6, 0, 0, -6]
  | 12 => #v[0, 12, 0, 0, 6, -6, -6, -6, -6, 6]
  | 13 => #v[6, -6, -6, 0, 12, 0, -6, -6, 6, 0]
  | 14 => #v[-48, 0, 6, 0, 6, 12, 12, 6, 0, 6]
  | 15 => #v[0, 9, 0, 0, 0, 9, 0, 0, -9, -9]
  | 16 => #v[0, 0, 0, -9, 9, 0, 0, 0, 9, -9]
  | 17 => #v[0, 0, 9, -9, -9, 9, 0, 0, 0, 0]
  | 18 => #v[0, 9, 0, 0, 9, 0, 0, -9, 0, -9]
  | 19 => #v[-9, 0, 9, 0, 0, 0, 0, 9, 0, -9]
  | _ => zeroZ

def KZ (k : Fin 1) : VecZ :=
  match k.val with
  | 0 => #v[0, 66, 66, 0, 0, 0, 66, 66, 66, 0]
  | _ => zeroZ

def YZ (k : Fin 1) : VecZ :=
  match k.val with
  | 0 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  | _ => zeroZ

def xaEntryZ : VecZ := sumFin (fun k => mulZ (XZ k) (AZ k))
def kyEntryZ : VecZ := sumFin (fun k => mulZ (KZ k) (YZ k))
def entryZ : VecZ := addZ xaEntryZ kyEntryZ

theorem entryZ_eq : entryZ = zeroZ :=
  eq_of_eqZ (by decide +kernel)

theorem scale_ne_zero : scale ≠ 0 := by
  decide

theorem XZ_scale_0 : toVec (XZ 0) = (scale : ℚ) • XCell3_0 :=
  toVec_eq_smul10 (XZ 0) scale XCell3_0
    (eq_smul_div (41) scale (41) (66) (by decide) (by decide))
    (eq_smul_div (40) scale (20) (33) (by decide) (by decide))
    (eq_smul_div (112) scale (56) (33) (by decide) (by decide))
    (eq_smul_div (50) scale (25) (33) (by decide) (by decide))
    (eq_smul_div (35) scale (35) (66) (by decide) (by decide))
    (eq_smul_div (92) scale (46) (33) (by decide) (by decide))
    (eq_smul_div (63) scale (21) (22) (by decide) (by decide))
    (eq_smul_div (53) scale (53) (66) (by decide) (by decide))
    (eq_smul_div (29) scale (29) (66) (by decide) (by decide))
    (eq_smul_div (123) scale (41) (22) (by decide) (by decide))

theorem XZ_scale_1 : toVec (XZ 1) = (scale : ℚ) • XCell3_1 :=
  toVec_eq_smul10 (XZ 1) scale XCell3_1
    (eq_smul_div (-7) scale (-7) (66) (by decide) (by decide))
    (eq_smul_div (-28) scale (-14) (33) (by decide) (by decide))
    (eq_smul_div (10) scale (5) (33) (by decide) (by decide))
    (eq_smul_div (29) scale (29) (66) (by decide) (by decide))
    (eq_smul_div (-3) scale (-1) (22) (by decide) (by decide))
    (eq_smul_div (-18) scale (-3) (11) (by decide) (by decide))
    (eq_smul_div (-3) scale (-1) (22) (by decide) (by decide))
    (eq_smul_div (10) scale (5) (33) (by decide) (by decide))
    (eq_smul_div (-2) scale (-1) (33) (by decide) (by decide))
    (eq_smul_div (45) scale (15) (22) (by decide) (by decide))

theorem XZ_scale_2 : toVec (XZ 2) = (scale : ℚ) • XCell3_2 :=
  toVec_eq_smul10 (XZ 2) scale XCell3_2
    (eq_smul_div (-130) scale (-65) (33) (by decide) (by decide))
    (eq_smul_div (14) scale (7) (33) (by decide) (by decide))
    (eq_smul_div (-151) scale (-151) (66) (by decide) (by decide))
    (eq_smul_div (-73) scale (-73) (66) (by decide) (by decide))
    (eq_smul_div (-55) scale (-5) (6) (by decide) (by decide))
    (eq_smul_div (-110) scale (-5) (3) (by decide) (by decide))
    (eq_smul_div (-37) scale (-37) (66) (by decide) (by decide))
    (eq_smul_div (-135) scale (-45) (22) (by decide) (by decide))
    (eq_smul_div (19) scale (19) (66) (by decide) (by decide))
    (eq_smul_div (-222) scale (-37) (11) (by decide) (by decide))

theorem XZ_scale_3 : toVec (XZ 3) = (scale : ℚ) • XCell3_3 :=
  toVec_eq_smul10 (XZ 3) scale XCell3_3
    (eq_smul_div (171) scale (57) (22) (by decide) (by decide))
    (eq_smul_div (16) scale (8) (33) (by decide) (by decide))
    (eq_smul_div (5) scale (5) (66) (by decide) (by decide))
    (eq_smul_div (18) scale (3) (11) (by decide) (by decide))
    (eq_smul_div (25) scale (25) (66) (by decide) (by decide))
    (eq_smul_div (84) scale (14) (11) (by decide) (by decide))
    (eq_smul_div (-13) scale (-13) (66) (by decide) (by decide))
    (eq_smul_div (116) scale (58) (33) (by decide) (by decide))
    (eq_smul_div (-33) scale (-1) (2) (by decide) (by decide))
    (eq_smul_div (73) scale (73) (66) (by decide) (by decide))

theorem XZ_scale_4 : toVec (XZ 4) = (scale : ℚ) • XCell3_4 :=
  toVec_eq_smul10 (XZ 4) scale XCell3_4
    (eq_smul_div (7) scale (7) (66) (by decide) (by decide))
    (eq_smul_div (32) scale (16) (33) (by decide) (by decide))
    (eq_smul_div (17) scale (17) (66) (by decide) (by decide))
    (eq_smul_div (-25) scale (-25) (66) (by decide) (by decide))
    (eq_smul_div (-25) scale (-25) (66) (by decide) (by decide))
    (eq_smul_div (6) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (39) scale (13) (22) (by decide) (by decide))
    (eq_smul_div (1) scale (1) (66) (by decide) (by decide))
    (eq_smul_div (2) scale (1) (33) (by decide) (by decide))
    (eq_smul_div (-10) scale (-5) (33) (by decide) (by decide))

theorem XZ_scale_5 : toVec (XZ 5) = (scale : ℚ) • XCell3_5 :=
  toVec_eq_smul10 (XZ 5) scale XCell3_5
    (eq_smul_div (-178) scale (-89) (33) (by decide) (by decide))
    (eq_smul_int (-66) scale (-1) (by decide))
    (eq_smul_div (-88) scale (-4) (3) (by decide) (by decide))
    (eq_smul_div (-100) scale (-50) (33) (by decide) (by decide))
    (eq_smul_int (-132) scale (-2) (by decide))
    (eq_smul_div (-118) scale (-59) (33) (by decide) (by decide))
    (eq_smul_div (-22) scale (-1) (3) (by decide) (by decide))
    (eq_smul_div (-184) scale (-92) (33) (by decide) (by decide))
    (eq_smul_div (-60) scale (-10) (11) (by decide) (by decide))
    (eq_smul_div (-108) scale (-18) (11) (by decide) (by decide))

theorem XZ_scale_6 : toVec (XZ 6) = (scale : ℚ) • XCell3_6 :=
  toVec_eq_smul10 (XZ 6) scale XCell3_6
    (eq_smul_div (24) scale (4) (11) (by decide) (by decide))
    (eq_smul_div (-28) scale (-14) (33) (by decide) (by decide))
    (eq_smul_div (16) scale (8) (33) (by decide) (by decide))
    (eq_smul_div (-36) scale (-6) (11) (by decide) (by decide))
    (eq_smul_div (-2) scale (-1) (33) (by decide) (by decide))
    (eq_smul_div (48) scale (8) (11) (by decide) (by decide))
    (eq_smul_div (2) scale (1) (33) (by decide) (by decide))
    (eq_smul_div (-18) scale (-3) (11) (by decide) (by decide))
    (eq_smul_div (-62) scale (-31) (33) (by decide) (by decide))
    (eq_smul_div (78) scale (13) (11) (by decide) (by decide))

theorem XZ_scale_7 : toVec (XZ 7) = (scale : ℚ) • XCell3_7 :=
  toVec_eq_smul10 (XZ 7) scale XCell3_7
    (eq_smul_div (-226) scale (-113) (33) (by decide) (by decide))
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-154) scale (-7) (3) (by decide) (by decide))
    (eq_smul_div (-134) scale (-67) (33) (by decide) (by decide))
    (eq_smul_div (-112) scale (-56) (33) (by decide) (by decide))
    (eq_smul_div (-126) scale (-21) (11) (by decide) (by decide))
    (eq_smul_div (-4) scale (-2) (33) (by decide) (by decide))
    (eq_smul_div (-250) scale (-125) (33) (by decide) (by decide))
    (eq_smul_div (-4) scale (-2) (33) (by decide) (by decide))
    (eq_smul_div (-194) scale (-97) (33) (by decide) (by decide))

theorem XZ_scale_8 : toVec (XZ 8) = (scale : ℚ) • XCell3_8 :=
  toVec_eq_smul10 (XZ 8) scale XCell3_8
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

theorem XZ_scale_9 : toVec (XZ 9) = (scale : ℚ) • XCell3_9 :=
  toVec_eq_smul10 (XZ 9) scale XCell3_9
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

theorem XZ_scale_10 : toVec (XZ 10) = (scale : ℚ) • XCell3_10 :=
  toVec_eq_smul10 (XZ 10) scale XCell3_10
    (eq_smul_div (22) scale (1) (3) (by decide) (by decide))
    (eq_smul_div (55) scale (5) (6) (by decide) (by decide))
    (eq_smul_int (66) scale (1) (by decide))
    (eq_smul_div (44) scale (2) (3) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (44) scale (2) (3) (by decide) (by decide))
    (eq_smul_div (55) scale (5) (6) (by decide) (by decide))
    (eq_smul_int (66) scale (1) (by decide))
    (eq_smul_div (11) scale (1) (6) (by decide) (by decide))

theorem XZ_scale_11 : toVec (XZ 11) = (scale : ℚ) • XCell3_11 :=
  toVec_eq_smul10 (XZ 11) scale XCell3_11
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

theorem XZ_scale_12 : toVec (XZ 12) = (scale : ℚ) • XCell3_12 :=
  toVec_eq_smul10 (XZ 12) scale XCell3_12
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

theorem XZ_scale_13 : toVec (XZ 13) = (scale : ℚ) • XCell3_13 :=
  toVec_eq_smul10 (XZ 13) scale XCell3_13
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

theorem XZ_scale_14 : toVec (XZ 14) = (scale : ℚ) • XCell3_14 :=
  toVec_eq_smul10 (XZ 14) scale XCell3_14
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

theorem XZ_scale_15 : toVec (XZ 15) = (scale : ℚ) • XCell3_15 :=
  toVec_eq_smul10 (XZ 15) scale XCell3_15
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

theorem XZ_scale_16 : toVec (XZ 16) = (scale : ℚ) • XCell3_16 :=
  toVec_eq_smul10 (XZ 16) scale XCell3_16
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

theorem XZ_scale_17 : toVec (XZ 17) = (scale : ℚ) • XCell3_17 :=
  toVec_eq_smul10 (XZ 17) scale XCell3_17
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

theorem XZ_scale_18 : toVec (XZ 18) = (scale : ℚ) • XCell3_18 :=
  toVec_eq_smul10 (XZ 18) scale XCell3_18
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

theorem XZ_scale_19 : toVec (XZ 19) = (scale : ℚ) • XCell3_19 :=
  toVec_eq_smul10 (XZ 19) scale XCell3_19
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
    toVec (XZ k) = (scale : ℚ) • XVec (3 : Fin 10) k :=
  forall_fin20 (P := fun k => toVec (XZ k) = (scale : ℚ) • XVec (3 : Fin 10) k)
    XZ_scale_0 XZ_scale_1 XZ_scale_2 XZ_scale_3 XZ_scale_4 XZ_scale_5 XZ_scale_6 XZ_scale_7 XZ_scale_8 XZ_scale_9 XZ_scale_10 XZ_scale_11 XZ_scale_12 XZ_scale_13 XZ_scale_14 XZ_scale_15 XZ_scale_16 XZ_scale_17 XZ_scale_18 XZ_scale_19 k

theorem AZ_scale_0 : toVec (AZ 0) = (scale : ℚ) • ACell0_4 :=
  toVec_eq_smul10 (AZ 0) scale ACell0_4
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (6) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (6) scale (1) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))

theorem AZ_scale_1 : toVec (AZ 1) = (scale : ℚ) • ACell1_4 :=
  toVec_eq_smul10 (AZ 1) scale ACell1_4
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-18) scale (-3) (11) (by decide) (by decide))
    (eq_smul_div (-12) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-12) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-18) scale (-3) (11) (by decide) (by decide))
    (eq_smul_div (-18) scale (-3) (11) (by decide) (by decide))
    (eq_smul_div (-12) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-12) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-18) scale (-3) (11) (by decide) (by decide))
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))

theorem AZ_scale_2 : toVec (AZ 2) = (scale : ℚ) • ACell2_4 :=
  toVec_eq_smul10 (AZ 2) scale ACell2_4
    (eq_smul_div (-12) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-12) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (6) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-12) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-12) scale (-2) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))

theorem AZ_scale_3 : toVec (AZ 3) = (scale : ℚ) • ACell3_4 :=
  toVec_eq_smul10 (AZ 3) scale ACell3_4
    (eq_smul_div (6) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (6) scale (1) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))

theorem AZ_scale_4 : toVec (AZ 4) = (scale : ℚ) • ACell4_4 :=
  toVec_eq_smul10 (AZ 4) scale ACell4_4
    (eq_smul_div (54) scale (9) (11) (by decide) (by decide))
    (eq_smul_div (-12) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-12) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-12) scale (-2) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (6) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))

theorem AZ_scale_5 : toVec (AZ 5) = (scale : ℚ) • ACell5_4 :=
  toVec_eq_smul10 (AZ 5) scale ACell5_4
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (-9) scale (-3) (22) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (9) scale (3) (22) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (9) scale (3) (22) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-9) scale (-3) (22) (by decide) (by decide))

theorem AZ_scale_6 : toVec (AZ 6) = (scale : ℚ) • ACell6_4 :=
  toVec_eq_smul10 (AZ 6) scale ACell6_4
    (eq_smul_zero scale)
    (eq_smul_div (-9) scale (-3) (22) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (9) scale (3) (22) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (9) scale (3) (22) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (-9) scale (-3) (22) (by decide) (by decide))

theorem AZ_scale_7 : toVec (AZ 7) = (scale : ℚ) • ACell7_4 :=
  toVec_eq_smul10 (AZ 7) scale ACell7_4
    (eq_smul_zero scale)
    (eq_smul_div (-9) scale (-3) (22) (by decide) (by decide))
    (eq_smul_div (9) scale (3) (22) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (9) scale (3) (22) (by decide) (by decide))
    (eq_smul_div (-9) scale (-3) (22) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)

theorem AZ_scale_8 : toVec (AZ 8) = (scale : ℚ) • ACell8_4 :=
  toVec_eq_smul10 (AZ 8) scale ACell8_4
    (eq_smul_div (-9) scale (-3) (22) (by decide) (by decide))
    (eq_smul_div (-9) scale (-3) (22) (by decide) (by decide))
    (eq_smul_div (-18) scale (-3) (11) (by decide) (by decide))
    (eq_smul_div (-18) scale (-3) (11) (by decide) (by decide))
    (eq_smul_div (-9) scale (-3) (22) (by decide) (by decide))
    (eq_smul_div (-9) scale (-3) (22) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-9) scale (-3) (22) (by decide) (by decide))
    (eq_smul_div (-9) scale (-3) (22) (by decide) (by decide))
    (eq_smul_div (-9) scale (-3) (22) (by decide) (by decide))

theorem AZ_scale_9 : toVec (AZ 9) = (scale : ℚ) • ACell9_4 :=
  toVec_eq_smul10 (AZ 9) scale ACell9_4
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (9) scale (3) (22) (by decide) (by decide))
    (eq_smul_div (-9) scale (-3) (22) (by decide) (by decide))
    (eq_smul_div (-9) scale (-3) (22) (by decide) (by decide))
    (eq_smul_div (9) scale (3) (22) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)

theorem AZ_scale_10 : toVec (AZ 10) = (scale : ℚ) • ACell10_4 :=
  toVec_eq_smul10 (AZ 10) scale ACell10_4
    (eq_smul_zero scale)
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (6) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (6) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))

theorem AZ_scale_11 : toVec (AZ 11) = (scale : ℚ) • ACell11_4 :=
  toVec_eq_smul10 (AZ 11) scale ACell11_4
    (eq_smul_div (6) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (6) scale (1) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))

theorem AZ_scale_12 : toVec (AZ 12) = (scale : ℚ) • ACell12_4 :=
  toVec_eq_smul10 (AZ 12) scale ACell12_4
    (eq_smul_zero scale)
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (6) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (6) scale (1) (11) (by decide) (by decide))

theorem AZ_scale_13 : toVec (AZ 13) = (scale : ℚ) • ACell13_4 :=
  toVec_eq_smul10 (AZ 13) scale ACell13_4
    (eq_smul_div (6) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (6) scale (1) (11) (by decide) (by decide))
    (eq_smul_zero scale)

theorem AZ_scale_14 : toVec (AZ 14) = (scale : ℚ) • ACell14_4 :=
  toVec_eq_smul10 (AZ 14) scale ACell14_4
    (eq_smul_div (-48) scale (-8) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (6) scale (1) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (6) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (6) scale (1) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (6) scale (1) (11) (by decide) (by decide))

theorem AZ_scale_15 : toVec (AZ 15) = (scale : ℚ) • ACell15_4 :=
  toVec_eq_smul10 (AZ 15) scale ACell15_4
    (eq_smul_zero scale)
    (eq_smul_div (9) scale (3) (22) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (9) scale (3) (22) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (-9) scale (-3) (22) (by decide) (by decide))
    (eq_smul_div (-9) scale (-3) (22) (by decide) (by decide))

theorem AZ_scale_16 : toVec (AZ 16) = (scale : ℚ) • ACell16_4 :=
  toVec_eq_smul10 (AZ 16) scale ACell16_4
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (-9) scale (-3) (22) (by decide) (by decide))
    (eq_smul_div (9) scale (3) (22) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (9) scale (3) (22) (by decide) (by decide))
    (eq_smul_div (-9) scale (-3) (22) (by decide) (by decide))

theorem AZ_scale_17 : toVec (AZ 17) = (scale : ℚ) • ACell17_4 :=
  toVec_eq_smul10 (AZ 17) scale ACell17_4
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (9) scale (3) (22) (by decide) (by decide))
    (eq_smul_div (-9) scale (-3) (22) (by decide) (by decide))
    (eq_smul_div (-9) scale (-3) (22) (by decide) (by decide))
    (eq_smul_div (9) scale (3) (22) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)

theorem AZ_scale_18 : toVec (AZ 18) = (scale : ℚ) • ACell18_4 :=
  toVec_eq_smul10 (AZ 18) scale ACell18_4
    (eq_smul_zero scale)
    (eq_smul_div (9) scale (3) (22) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (9) scale (3) (22) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (-9) scale (-3) (22) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-9) scale (-3) (22) (by decide) (by decide))

theorem AZ_scale_19 : toVec (AZ 19) = (scale : ℚ) • ACell19_4 :=
  toVec_eq_smul10 (AZ 19) scale ACell19_4
    (eq_smul_div (-9) scale (-3) (22) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (9) scale (3) (22) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (9) scale (3) (22) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-9) scale (-3) (22) (by decide) (by decide))

theorem AZ_scale (k : Fin 20) :
    toVec (AZ k) = (scale : ℚ) • AVec k (4 : Fin 10) :=
  forall_fin20 (P := fun k => toVec (AZ k) = (scale : ℚ) • AVec k (4 : Fin 10))
    AZ_scale_0 AZ_scale_1 AZ_scale_2 AZ_scale_3 AZ_scale_4 AZ_scale_5 AZ_scale_6 AZ_scale_7 AZ_scale_8 AZ_scale_9 AZ_scale_10 AZ_scale_11 AZ_scale_12 AZ_scale_13 AZ_scale_14 AZ_scale_15 AZ_scale_16 AZ_scale_17 AZ_scale_18 AZ_scale_19 k

theorem KZ_scale_0 : toVec (KZ 0) = (scale : ℚ) • KCell3_0 :=
  toVec_eq_smul10 (KZ 0) scale KCell3_0
    (eq_smul_zero scale)
    (eq_smul_int (66) scale (1) (by decide))
    (eq_smul_int (66) scale (1) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_int (66) scale (1) (by decide))
    (eq_smul_int (66) scale (1) (by decide))
    (eq_smul_int (66) scale (1) (by decide))
    (eq_smul_zero scale)

theorem KZ_scale (k : Fin 1) :
    toVec (KZ k) = (scale : ℚ) • KVec (3 : Fin 10) k :=
  forall_fin1 (P := fun k => toVec (KZ k) = (scale : ℚ) • KVec (3 : Fin 10) k)
    KZ_scale_0 k

theorem YZ_scale_0 : toVec (YZ 0) = (scale : ℚ) • YCell0_4 :=
  toVec_eq_smul10 (YZ 0) scale YCell0_4
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

theorem YZ_scale (k : Fin 1) :
    toVec (YZ k) = (scale : ℚ) • YVec k (4 : Fin 10) :=
  forall_fin1 (P := fun k => toVec (YZ k) = (scale : ℚ) • YVec k (4 : Fin 10))
    YZ_scale_0 k

theorem entry_eq :
    (matrixMul XVec AVec + matrixMul KVec YVec)
        (3 : Fin 10) (4 : Fin 10) = ![0, 0, 0, 0, 0, 0, 0, 0, 0, 0] := by
  change (∑ k : Fin 20, mul (XVec (3 : Fin 10) k)
      (AVec k (4 : Fin 10))) +
    (∑ k : Fin 1, mul (KVec (3 : Fin 10) k)
      (YVec k (4 : Fin 10))) = _
  refine add_sum_mul_eq_of_scaled scale scale_ne_zero
    (fun k => XVec (3 : Fin 10) k)
    (fun k => AVec k (4 : Fin 10))
    (fun k => KVec (3 : Fin 10) k)
    (fun k => YVec k (4 : Fin 10))
    XZ AZ KZ YZ XZ_scale AZ_scale KZ_scale YZ_scale entryZ rfl _ ?_
  rw [entryZ_eq, toVec_zeroZ_smul, vec_zero_eq]

theorem entry_eq_matrixOne :
    (matrixMul XVec AVec + matrixMul KVec YVec)
        (3 : Fin 10) (4 : Fin 10) =
      matrixOne (Fin 10) (3 : Fin 10) (4 : Fin 10) :=
  entry_eq.trans (matrixOne_off10 (3 : Fin 10) (4 : Fin 10) (by decide)).symm

end V14Formalization.D12PieceAPSplitEntry3_4


namespace V14Formalization.D12PieceAPSplitEntry3_5
open D12CyclotomicVec D12CyclotomicVecZ D12PieceAPData
def payloadSha256 : String := "76c6196f29afe1a8398af99502447f48ebeed4bcb3805fc5dbec693940bc04b0"

def scale : ℤ := 66

def XZ (k : Fin 20) : VecZ :=
  match k.val with
  | 0 => #v[41, 40, 112, 50, 35, 92, 63, 53, 29, 123]
  | 1 => #v[-7, -28, 10, 29, -3, -18, -3, 10, -2, 45]
  | 2 => #v[-130, 14, -151, -73, -55, -110, -37, -135, 19, -222]
  | 3 => #v[171, 16, 5, 18, 25, 84, -13, 116, -33, 73]
  | 4 => #v[7, 32, 17, -25, -25, 6, 39, 1, 2, -10]
  | 5 => #v[-178, -66, -88, -100, -132, -118, -22, -184, -60, -108]
  | 6 => #v[24, -28, 16, -36, -2, 48, 2, -18, -62, 78]
  | 7 => #v[-226, -6, -154, -134, -112, -126, -4, -250, -4, -194]
  | 8 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  | 9 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  | 10 => #v[22, 55, 66, 44, 0, 0, 44, 55, 66, 11]
  | 11 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
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
  | 0 => #v[0, 0, 12, 0, 0, -12, -12, 0, 0, 12]
  | 1 => #v[12, 12, 24, 12, 12, 24, 12, 12, 0, 12]
  | 2 => #v[0, 0, 0, 0, 0, 0, -12, 12, 12, -12]
  | 3 => #v[12, 12, 12, 0, 24, 12, 12, 12, 12, 24]
  | 4 => #v[0, 0, 0, -12, 0, 12, 0, 12, 0, -12]
  | 5 => #v[66, 6, 6, 0, 12, 18, 12, 0, 6, 6]
  | 6 => #v[-6, 6, 6, 0, -12, 0, 6, 6, -6, 0]
  | 7 => #v[-12, -6, -6, -18, -6, -6, -12, 0, 0, 0]
  | 8 => #v[-6, 0, 0, -6, 0, 6, -6, 12, -6, 6]
  | 9 => #v[18, 12, 18, 12, 6, 6, 12, 18, 12, 18]
  | 10 => #v[12, 0, 0, -12, 0, -12, 0, 0, 12, 0]
  | 11 => #v[0, -12, 12, 0, 0, 0, 0, 12, -12, 0]
  | 12 => #v[-12, -24, -12, -12, -12, -12, -24, -12, 0, -12]
  | 13 => #v[0, 0, 0, 0, 0, -12, 12, 12, -12, 0]
  | 14 => #v[-12, -12, -24, -24, -12, -12, 0, -12, -12, -12]
  | 15 => #v[-48, 0, 12, 6, 0, 6, 6, 0, 6, 12]
  | 16 => #v[-12, -6, -6, -18, -6, -6, -12, 0, 0, 0]
  | 17 => #v[-6, -6, 0, 6, 0, 6, -12, 6, 0, 6]
  | 18 => #v[0, 6, -6, -6, 0, 12, 0, -6, -6, 6]
  | 19 => #v[0, 6, 6, 0, 0, 6, -6, -12, -6, 6]
  | _ => zeroZ

def KZ (k : Fin 1) : VecZ :=
  match k.val with
  | 0 => #v[0, 66, 66, 0, 0, 0, 66, 66, 66, 0]
  | _ => zeroZ

def YZ (k : Fin 1) : VecZ :=
  match k.val with
  | 0 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  | _ => zeroZ

def xaEntryZ : VecZ := sumFin (fun k => mulZ (XZ k) (AZ k))
def kyEntryZ : VecZ := sumFin (fun k => mulZ (KZ k) (YZ k))
def entryZ : VecZ := addZ xaEntryZ kyEntryZ

theorem entryZ_eq : entryZ = zeroZ :=
  eq_of_eqZ (by decide +kernel)

theorem scale_ne_zero : scale ≠ 0 := by
  decide

theorem XZ_scale_0 : toVec (XZ 0) = (scale : ℚ) • XCell3_0 :=
  toVec_eq_smul10 (XZ 0) scale XCell3_0
    (eq_smul_div (41) scale (41) (66) (by decide) (by decide))
    (eq_smul_div (40) scale (20) (33) (by decide) (by decide))
    (eq_smul_div (112) scale (56) (33) (by decide) (by decide))
    (eq_smul_div (50) scale (25) (33) (by decide) (by decide))
    (eq_smul_div (35) scale (35) (66) (by decide) (by decide))
    (eq_smul_div (92) scale (46) (33) (by decide) (by decide))
    (eq_smul_div (63) scale (21) (22) (by decide) (by decide))
    (eq_smul_div (53) scale (53) (66) (by decide) (by decide))
    (eq_smul_div (29) scale (29) (66) (by decide) (by decide))
    (eq_smul_div (123) scale (41) (22) (by decide) (by decide))

theorem XZ_scale_1 : toVec (XZ 1) = (scale : ℚ) • XCell3_1 :=
  toVec_eq_smul10 (XZ 1) scale XCell3_1
    (eq_smul_div (-7) scale (-7) (66) (by decide) (by decide))
    (eq_smul_div (-28) scale (-14) (33) (by decide) (by decide))
    (eq_smul_div (10) scale (5) (33) (by decide) (by decide))
    (eq_smul_div (29) scale (29) (66) (by decide) (by decide))
    (eq_smul_div (-3) scale (-1) (22) (by decide) (by decide))
    (eq_smul_div (-18) scale (-3) (11) (by decide) (by decide))
    (eq_smul_div (-3) scale (-1) (22) (by decide) (by decide))
    (eq_smul_div (10) scale (5) (33) (by decide) (by decide))
    (eq_smul_div (-2) scale (-1) (33) (by decide) (by decide))
    (eq_smul_div (45) scale (15) (22) (by decide) (by decide))

theorem XZ_scale_2 : toVec (XZ 2) = (scale : ℚ) • XCell3_2 :=
  toVec_eq_smul10 (XZ 2) scale XCell3_2
    (eq_smul_div (-130) scale (-65) (33) (by decide) (by decide))
    (eq_smul_div (14) scale (7) (33) (by decide) (by decide))
    (eq_smul_div (-151) scale (-151) (66) (by decide) (by decide))
    (eq_smul_div (-73) scale (-73) (66) (by decide) (by decide))
    (eq_smul_div (-55) scale (-5) (6) (by decide) (by decide))
    (eq_smul_div (-110) scale (-5) (3) (by decide) (by decide))
    (eq_smul_div (-37) scale (-37) (66) (by decide) (by decide))
    (eq_smul_div (-135) scale (-45) (22) (by decide) (by decide))
    (eq_smul_div (19) scale (19) (66) (by decide) (by decide))
    (eq_smul_div (-222) scale (-37) (11) (by decide) (by decide))

theorem XZ_scale_3 : toVec (XZ 3) = (scale : ℚ) • XCell3_3 :=
  toVec_eq_smul10 (XZ 3) scale XCell3_3
    (eq_smul_div (171) scale (57) (22) (by decide) (by decide))
    (eq_smul_div (16) scale (8) (33) (by decide) (by decide))
    (eq_smul_div (5) scale (5) (66) (by decide) (by decide))
    (eq_smul_div (18) scale (3) (11) (by decide) (by decide))
    (eq_smul_div (25) scale (25) (66) (by decide) (by decide))
    (eq_smul_div (84) scale (14) (11) (by decide) (by decide))
    (eq_smul_div (-13) scale (-13) (66) (by decide) (by decide))
    (eq_smul_div (116) scale (58) (33) (by decide) (by decide))
    (eq_smul_div (-33) scale (-1) (2) (by decide) (by decide))
    (eq_smul_div (73) scale (73) (66) (by decide) (by decide))

theorem XZ_scale_4 : toVec (XZ 4) = (scale : ℚ) • XCell3_4 :=
  toVec_eq_smul10 (XZ 4) scale XCell3_4
    (eq_smul_div (7) scale (7) (66) (by decide) (by decide))
    (eq_smul_div (32) scale (16) (33) (by decide) (by decide))
    (eq_smul_div (17) scale (17) (66) (by decide) (by decide))
    (eq_smul_div (-25) scale (-25) (66) (by decide) (by decide))
    (eq_smul_div (-25) scale (-25) (66) (by decide) (by decide))
    (eq_smul_div (6) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (39) scale (13) (22) (by decide) (by decide))
    (eq_smul_div (1) scale (1) (66) (by decide) (by decide))
    (eq_smul_div (2) scale (1) (33) (by decide) (by decide))
    (eq_smul_div (-10) scale (-5) (33) (by decide) (by decide))

theorem XZ_scale_5 : toVec (XZ 5) = (scale : ℚ) • XCell3_5 :=
  toVec_eq_smul10 (XZ 5) scale XCell3_5
    (eq_smul_div (-178) scale (-89) (33) (by decide) (by decide))
    (eq_smul_int (-66) scale (-1) (by decide))
    (eq_smul_div (-88) scale (-4) (3) (by decide) (by decide))
    (eq_smul_div (-100) scale (-50) (33) (by decide) (by decide))
    (eq_smul_int (-132) scale (-2) (by decide))
    (eq_smul_div (-118) scale (-59) (33) (by decide) (by decide))
    (eq_smul_div (-22) scale (-1) (3) (by decide) (by decide))
    (eq_smul_div (-184) scale (-92) (33) (by decide) (by decide))
    (eq_smul_div (-60) scale (-10) (11) (by decide) (by decide))
    (eq_smul_div (-108) scale (-18) (11) (by decide) (by decide))

theorem XZ_scale_6 : toVec (XZ 6) = (scale : ℚ) • XCell3_6 :=
  toVec_eq_smul10 (XZ 6) scale XCell3_6
    (eq_smul_div (24) scale (4) (11) (by decide) (by decide))
    (eq_smul_div (-28) scale (-14) (33) (by decide) (by decide))
    (eq_smul_div (16) scale (8) (33) (by decide) (by decide))
    (eq_smul_div (-36) scale (-6) (11) (by decide) (by decide))
    (eq_smul_div (-2) scale (-1) (33) (by decide) (by decide))
    (eq_smul_div (48) scale (8) (11) (by decide) (by decide))
    (eq_smul_div (2) scale (1) (33) (by decide) (by decide))
    (eq_smul_div (-18) scale (-3) (11) (by decide) (by decide))
    (eq_smul_div (-62) scale (-31) (33) (by decide) (by decide))
    (eq_smul_div (78) scale (13) (11) (by decide) (by decide))

theorem XZ_scale_7 : toVec (XZ 7) = (scale : ℚ) • XCell3_7 :=
  toVec_eq_smul10 (XZ 7) scale XCell3_7
    (eq_smul_div (-226) scale (-113) (33) (by decide) (by decide))
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-154) scale (-7) (3) (by decide) (by decide))
    (eq_smul_div (-134) scale (-67) (33) (by decide) (by decide))
    (eq_smul_div (-112) scale (-56) (33) (by decide) (by decide))
    (eq_smul_div (-126) scale (-21) (11) (by decide) (by decide))
    (eq_smul_div (-4) scale (-2) (33) (by decide) (by decide))
    (eq_smul_div (-250) scale (-125) (33) (by decide) (by decide))
    (eq_smul_div (-4) scale (-2) (33) (by decide) (by decide))
    (eq_smul_div (-194) scale (-97) (33) (by decide) (by decide))

theorem XZ_scale_8 : toVec (XZ 8) = (scale : ℚ) • XCell3_8 :=
  toVec_eq_smul10 (XZ 8) scale XCell3_8
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

theorem XZ_scale_9 : toVec (XZ 9) = (scale : ℚ) • XCell3_9 :=
  toVec_eq_smul10 (XZ 9) scale XCell3_9
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

theorem XZ_scale_10 : toVec (XZ 10) = (scale : ℚ) • XCell3_10 :=
  toVec_eq_smul10 (XZ 10) scale XCell3_10
    (eq_smul_div (22) scale (1) (3) (by decide) (by decide))
    (eq_smul_div (55) scale (5) (6) (by decide) (by decide))
    (eq_smul_int (66) scale (1) (by decide))
    (eq_smul_div (44) scale (2) (3) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (44) scale (2) (3) (by decide) (by decide))
    (eq_smul_div (55) scale (5) (6) (by decide) (by decide))
    (eq_smul_int (66) scale (1) (by decide))
    (eq_smul_div (11) scale (1) (6) (by decide) (by decide))

theorem XZ_scale_11 : toVec (XZ 11) = (scale : ℚ) • XCell3_11 :=
  toVec_eq_smul10 (XZ 11) scale XCell3_11
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

theorem XZ_scale_12 : toVec (XZ 12) = (scale : ℚ) • XCell3_12 :=
  toVec_eq_smul10 (XZ 12) scale XCell3_12
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

theorem XZ_scale_13 : toVec (XZ 13) = (scale : ℚ) • XCell3_13 :=
  toVec_eq_smul10 (XZ 13) scale XCell3_13
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

theorem XZ_scale_14 : toVec (XZ 14) = (scale : ℚ) • XCell3_14 :=
  toVec_eq_smul10 (XZ 14) scale XCell3_14
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

theorem XZ_scale_15 : toVec (XZ 15) = (scale : ℚ) • XCell3_15 :=
  toVec_eq_smul10 (XZ 15) scale XCell3_15
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

theorem XZ_scale_16 : toVec (XZ 16) = (scale : ℚ) • XCell3_16 :=
  toVec_eq_smul10 (XZ 16) scale XCell3_16
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

theorem XZ_scale_17 : toVec (XZ 17) = (scale : ℚ) • XCell3_17 :=
  toVec_eq_smul10 (XZ 17) scale XCell3_17
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

theorem XZ_scale_18 : toVec (XZ 18) = (scale : ℚ) • XCell3_18 :=
  toVec_eq_smul10 (XZ 18) scale XCell3_18
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

theorem XZ_scale_19 : toVec (XZ 19) = (scale : ℚ) • XCell3_19 :=
  toVec_eq_smul10 (XZ 19) scale XCell3_19
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
    toVec (XZ k) = (scale : ℚ) • XVec (3 : Fin 10) k :=
  forall_fin20 (P := fun k => toVec (XZ k) = (scale : ℚ) • XVec (3 : Fin 10) k)
    XZ_scale_0 XZ_scale_1 XZ_scale_2 XZ_scale_3 XZ_scale_4 XZ_scale_5 XZ_scale_6 XZ_scale_7 XZ_scale_8 XZ_scale_9 XZ_scale_10 XZ_scale_11 XZ_scale_12 XZ_scale_13 XZ_scale_14 XZ_scale_15 XZ_scale_16 XZ_scale_17 XZ_scale_18 XZ_scale_19 k

theorem AZ_scale_0 : toVec (AZ 0) = (scale : ℚ) • ACell0_5 :=
  toVec_eq_smul10 (AZ 0) scale ACell0_5
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (-12) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-12) scale (-2) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))

theorem AZ_scale_1 : toVec (AZ 1) = (scale : ℚ) • ACell1_5 :=
  toVec_eq_smul10 (AZ 1) scale ACell1_5
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (24) scale (4) (11) (by decide) (by decide))
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (24) scale (4) (11) (by decide) (by decide))
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))

theorem AZ_scale_2 : toVec (AZ 2) = (scale : ℚ) • ACell2_5 :=
  toVec_eq_smul10 (AZ 2) scale ACell2_5
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (-12) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (-12) scale (-2) (11) (by decide) (by decide))

theorem AZ_scale_3 : toVec (AZ 3) = (scale : ℚ) • ACell3_5 :=
  toVec_eq_smul10 (AZ 3) scale ACell3_5
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (24) scale (4) (11) (by decide) (by decide))
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (24) scale (4) (11) (by decide) (by decide))

theorem AZ_scale_4 : toVec (AZ 4) = (scale : ℚ) • ACell4_5 :=
  toVec_eq_smul10 (AZ 4) scale ACell4_5
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (-12) scale (-2) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-12) scale (-2) (11) (by decide) (by decide))

theorem AZ_scale_5 : toVec (AZ 5) = (scale : ℚ) • ACell5_5 :=
  toVec_eq_smul10 (AZ 5) scale ACell5_5
    (eq_smul_int (66) scale (1) (by decide))
    (eq_smul_div (6) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (6) scale (1) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (18) scale (3) (11) (by decide) (by decide))
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (6) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (6) scale (1) (11) (by decide) (by decide))

theorem AZ_scale_6 : toVec (AZ 6) = (scale : ℚ) • ACell6_5 :=
  toVec_eq_smul10 (AZ 6) scale ACell6_5
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (6) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (6) scale (1) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-12) scale (-2) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (6) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (6) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_zero scale)

theorem AZ_scale_7 : toVec (AZ 7) = (scale : ℚ) • ACell7_5 :=
  toVec_eq_smul10 (AZ 7) scale ACell7_5
    (eq_smul_div (-12) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-18) scale (-3) (11) (by decide) (by decide))
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-12) scale (-2) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)

theorem AZ_scale_8 : toVec (AZ 8) = (scale : ℚ) • ACell8_5 :=
  toVec_eq_smul10 (AZ 8) scale ACell8_5
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (6) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (6) scale (1) (11) (by decide) (by decide))

theorem AZ_scale_9 : toVec (AZ 9) = (scale : ℚ) • ACell9_5 :=
  toVec_eq_smul10 (AZ 9) scale ACell9_5
    (eq_smul_div (18) scale (3) (11) (by decide) (by decide))
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (18) scale (3) (11) (by decide) (by decide))
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (6) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (6) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (18) scale (3) (11) (by decide) (by decide))
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (18) scale (3) (11) (by decide) (by decide))

theorem AZ_scale_10 : toVec (AZ 10) = (scale : ℚ) • ACell10_5 :=
  toVec_eq_smul10 (AZ 10) scale ACell10_5
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (-12) scale (-2) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-12) scale (-2) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_zero scale)

theorem AZ_scale_11 : toVec (AZ 11) = (scale : ℚ) • ACell11_5 :=
  toVec_eq_smul10 (AZ 11) scale ACell11_5
    (eq_smul_zero scale)
    (eq_smul_div (-12) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (-12) scale (-2) (11) (by decide) (by decide))
    (eq_smul_zero scale)

theorem AZ_scale_12 : toVec (AZ 12) = (scale : ℚ) • ACell12_5 :=
  toVec_eq_smul10 (AZ 12) scale ACell12_5
    (eq_smul_div (-12) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-24) scale (-4) (11) (by decide) (by decide))
    (eq_smul_div (-12) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-12) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-12) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-12) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-24) scale (-4) (11) (by decide) (by decide))
    (eq_smul_div (-12) scale (-2) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-12) scale (-2) (11) (by decide) (by decide))

theorem AZ_scale_13 : toVec (AZ 13) = (scale : ℚ) • ACell13_5 :=
  toVec_eq_smul10 (AZ 13) scale ACell13_5
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (-12) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (-12) scale (-2) (11) (by decide) (by decide))
    (eq_smul_zero scale)

theorem AZ_scale_14 : toVec (AZ 14) = (scale : ℚ) • ACell14_5 :=
  toVec_eq_smul10 (AZ 14) scale ACell14_5
    (eq_smul_div (-12) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-12) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-24) scale (-4) (11) (by decide) (by decide))
    (eq_smul_div (-24) scale (-4) (11) (by decide) (by decide))
    (eq_smul_div (-12) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-12) scale (-2) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-12) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-12) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-12) scale (-2) (11) (by decide) (by decide))

theorem AZ_scale_15 : toVec (AZ 15) = (scale : ℚ) • ACell15_5 :=
  toVec_eq_smul10 (AZ 15) scale ACell15_5
    (eq_smul_div (-48) scale (-8) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (6) scale (1) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (6) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (6) scale (1) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (6) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))

theorem AZ_scale_16 : toVec (AZ 16) = (scale : ℚ) • ACell16_5 :=
  toVec_eq_smul10 (AZ 16) scale ACell16_5
    (eq_smul_div (-12) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-18) scale (-3) (11) (by decide) (by decide))
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-12) scale (-2) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)

theorem AZ_scale_17 : toVec (AZ 17) = (scale : ℚ) • ACell17_5 :=
  toVec_eq_smul10 (AZ 17) scale ACell17_5
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (6) scale (1) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (6) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (-12) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (6) scale (1) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (6) scale (1) (11) (by decide) (by decide))

theorem AZ_scale_18 : toVec (AZ 18) = (scale : ℚ) • ACell18_5 :=
  toVec_eq_smul10 (AZ 18) scale ACell18_5
    (eq_smul_zero scale)
    (eq_smul_div (6) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (6) scale (1) (11) (by decide) (by decide))

theorem AZ_scale_19 : toVec (AZ 19) = (scale : ℚ) • ACell19_5 :=
  toVec_eq_smul10 (AZ 19) scale ACell19_5
    (eq_smul_zero scale)
    (eq_smul_div (6) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (6) scale (1) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (6) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-12) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (6) scale (1) (11) (by decide) (by decide))

theorem AZ_scale (k : Fin 20) :
    toVec (AZ k) = (scale : ℚ) • AVec k (5 : Fin 10) :=
  forall_fin20 (P := fun k => toVec (AZ k) = (scale : ℚ) • AVec k (5 : Fin 10))
    AZ_scale_0 AZ_scale_1 AZ_scale_2 AZ_scale_3 AZ_scale_4 AZ_scale_5 AZ_scale_6 AZ_scale_7 AZ_scale_8 AZ_scale_9 AZ_scale_10 AZ_scale_11 AZ_scale_12 AZ_scale_13 AZ_scale_14 AZ_scale_15 AZ_scale_16 AZ_scale_17 AZ_scale_18 AZ_scale_19 k

theorem KZ_scale_0 : toVec (KZ 0) = (scale : ℚ) • KCell3_0 :=
  toVec_eq_smul10 (KZ 0) scale KCell3_0
    (eq_smul_zero scale)
    (eq_smul_int (66) scale (1) (by decide))
    (eq_smul_int (66) scale (1) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_int (66) scale (1) (by decide))
    (eq_smul_int (66) scale (1) (by decide))
    (eq_smul_int (66) scale (1) (by decide))
    (eq_smul_zero scale)

theorem KZ_scale (k : Fin 1) :
    toVec (KZ k) = (scale : ℚ) • KVec (3 : Fin 10) k :=
  forall_fin1 (P := fun k => toVec (KZ k) = (scale : ℚ) • KVec (3 : Fin 10) k)
    KZ_scale_0 k

theorem YZ_scale_0 : toVec (YZ 0) = (scale : ℚ) • YCell0_5 :=
  toVec_eq_smul10 (YZ 0) scale YCell0_5
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

theorem YZ_scale (k : Fin 1) :
    toVec (YZ k) = (scale : ℚ) • YVec k (5 : Fin 10) :=
  forall_fin1 (P := fun k => toVec (YZ k) = (scale : ℚ) • YVec k (5 : Fin 10))
    YZ_scale_0 k

theorem entry_eq :
    (matrixMul XVec AVec + matrixMul KVec YVec)
        (3 : Fin 10) (5 : Fin 10) = ![0, 0, 0, 0, 0, 0, 0, 0, 0, 0] := by
  change (∑ k : Fin 20, mul (XVec (3 : Fin 10) k)
      (AVec k (5 : Fin 10))) +
    (∑ k : Fin 1, mul (KVec (3 : Fin 10) k)
      (YVec k (5 : Fin 10))) = _
  refine add_sum_mul_eq_of_scaled scale scale_ne_zero
    (fun k => XVec (3 : Fin 10) k)
    (fun k => AVec k (5 : Fin 10))
    (fun k => KVec (3 : Fin 10) k)
    (fun k => YVec k (5 : Fin 10))
    XZ AZ KZ YZ XZ_scale AZ_scale KZ_scale YZ_scale entryZ rfl _ ?_
  rw [entryZ_eq, toVec_zeroZ_smul, vec_zero_eq]

theorem entry_eq_matrixOne :
    (matrixMul XVec AVec + matrixMul KVec YVec)
        (3 : Fin 10) (5 : Fin 10) =
      matrixOne (Fin 10) (3 : Fin 10) (5 : Fin 10) :=
  entry_eq.trans (matrixOne_off10 (3 : Fin 10) (5 : Fin 10) (by decide)).symm

end V14Formalization.D12PieceAPSplitEntry3_5


namespace V14Formalization.D12PieceAPSplitEntry3_6
open D12CyclotomicVec D12CyclotomicVecZ D12PieceAPData
def payloadSha256 : String := "76c6196f29afe1a8398af99502447f48ebeed4bcb3805fc5dbec693940bc04b0"

def scale : ℤ := 66

def XZ (k : Fin 20) : VecZ :=
  match k.val with
  | 0 => #v[41, 40, 112, 50, 35, 92, 63, 53, 29, 123]
  | 1 => #v[-7, -28, 10, 29, -3, -18, -3, 10, -2, 45]
  | 2 => #v[-130, 14, -151, -73, -55, -110, -37, -135, 19, -222]
  | 3 => #v[171, 16, 5, 18, 25, 84, -13, 116, -33, 73]
  | 4 => #v[7, 32, 17, -25, -25, 6, 39, 1, 2, -10]
  | 5 => #v[-178, -66, -88, -100, -132, -118, -22, -184, -60, -108]
  | 6 => #v[24, -28, 16, -36, -2, 48, 2, -18, -62, 78]
  | 7 => #v[-226, -6, -154, -134, -112, -126, -4, -250, -4, -194]
  | 8 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  | 9 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  | 10 => #v[22, 55, 66, 44, 0, 0, 44, 55, 66, 11]
  | 11 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
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
  | 0 => #v[0, 12, -12, 0, 0, 0, 0, -12, 12, 0]
  | 1 => #v[0, 12, -12, -12, 12, 0, 0, 0, 0, 0]
  | 2 => #v[12, 12, 12, 0, 12, 12, 24, 24, 12, 12]
  | 3 => #v[12, 0, 12, 24, 12, 12, 12, 12, 24, 12]
  | 4 => #v[0, -12, 0, 0, 12, 0, 12, 0, 0, -12]
  | 5 => #v[-6, 6, 6, 0, -12, 0, 6, 6, -6, 0]
  | 6 => #v[60, 0, -6, 12, -6, 0, -6, 0, 6, 6]
  | 7 => #v[-6, 6, 12, 6, -6, 0, 0, -6, -6, 0]
  | 8 => #v[0, 0, 0, -12, -6, -6, -18, -6, -6, -12]
  | 9 => #v[12, 6, 0, 6, 6, 0, 6, 12, 0, 18]
  | 10 => #v[0, 0, 0, 0, 0, 12, -12, -12, 12, 0]
  | 11 => #v[-12, -12, -12, -12, 0, -12, -24, -12, -24, -12]
  | 12 => #v[12, 12, 0, 12, 12, 24, 12, 24, 12, 12]
  | 13 => #v[-12, 0, 0, 12, 12, 0, 0, -12, 0, 0]
  | 14 => #v[0, 0, -12, 12, 0, 0, 0, 12, -12, 0]
  | 15 => #v[-6, 6, 6, 6, 6, -6, 0, 0, -12, 0]
  | 16 => #v[-60, 0, -12, -6, -6, -12, -12, -6, -6, -12]
  | 17 => #v[6, 12, 0, 18, 0, 12, 6, 0, 6, 6]
  | 18 => #v[-6, 0, -18, 0, -6, 0, -6, -12, -12, -6]
  | 19 => #v[6, -6, -6, 0, 12, 0, -6, -6, 6, 0]
  | _ => zeroZ

def KZ (k : Fin 1) : VecZ :=
  match k.val with
  | 0 => #v[0, 66, 66, 0, 0, 0, 66, 66, 66, 0]
  | _ => zeroZ

def YZ (k : Fin 1) : VecZ :=
  match k.val with
  | 0 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  | _ => zeroZ

def xaEntryZ : VecZ := sumFin (fun k => mulZ (XZ k) (AZ k))
def kyEntryZ : VecZ := sumFin (fun k => mulZ (KZ k) (YZ k))
def entryZ : VecZ := addZ xaEntryZ kyEntryZ

theorem entryZ_eq : entryZ = zeroZ :=
  eq_of_eqZ (by decide +kernel)

theorem scale_ne_zero : scale ≠ 0 := by
  decide

theorem XZ_scale_0 : toVec (XZ 0) = (scale : ℚ) • XCell3_0 :=
  toVec_eq_smul10 (XZ 0) scale XCell3_0
    (eq_smul_div (41) scale (41) (66) (by decide) (by decide))
    (eq_smul_div (40) scale (20) (33) (by decide) (by decide))
    (eq_smul_div (112) scale (56) (33) (by decide) (by decide))
    (eq_smul_div (50) scale (25) (33) (by decide) (by decide))
    (eq_smul_div (35) scale (35) (66) (by decide) (by decide))
    (eq_smul_div (92) scale (46) (33) (by decide) (by decide))
    (eq_smul_div (63) scale (21) (22) (by decide) (by decide))
    (eq_smul_div (53) scale (53) (66) (by decide) (by decide))
    (eq_smul_div (29) scale (29) (66) (by decide) (by decide))
    (eq_smul_div (123) scale (41) (22) (by decide) (by decide))

theorem XZ_scale_1 : toVec (XZ 1) = (scale : ℚ) • XCell3_1 :=
  toVec_eq_smul10 (XZ 1) scale XCell3_1
    (eq_smul_div (-7) scale (-7) (66) (by decide) (by decide))
    (eq_smul_div (-28) scale (-14) (33) (by decide) (by decide))
    (eq_smul_div (10) scale (5) (33) (by decide) (by decide))
    (eq_smul_div (29) scale (29) (66) (by decide) (by decide))
    (eq_smul_div (-3) scale (-1) (22) (by decide) (by decide))
    (eq_smul_div (-18) scale (-3) (11) (by decide) (by decide))
    (eq_smul_div (-3) scale (-1) (22) (by decide) (by decide))
    (eq_smul_div (10) scale (5) (33) (by decide) (by decide))
    (eq_smul_div (-2) scale (-1) (33) (by decide) (by decide))
    (eq_smul_div (45) scale (15) (22) (by decide) (by decide))

theorem XZ_scale_2 : toVec (XZ 2) = (scale : ℚ) • XCell3_2 :=
  toVec_eq_smul10 (XZ 2) scale XCell3_2
    (eq_smul_div (-130) scale (-65) (33) (by decide) (by decide))
    (eq_smul_div (14) scale (7) (33) (by decide) (by decide))
    (eq_smul_div (-151) scale (-151) (66) (by decide) (by decide))
    (eq_smul_div (-73) scale (-73) (66) (by decide) (by decide))
    (eq_smul_div (-55) scale (-5) (6) (by decide) (by decide))
    (eq_smul_div (-110) scale (-5) (3) (by decide) (by decide))
    (eq_smul_div (-37) scale (-37) (66) (by decide) (by decide))
    (eq_smul_div (-135) scale (-45) (22) (by decide) (by decide))
    (eq_smul_div (19) scale (19) (66) (by decide) (by decide))
    (eq_smul_div (-222) scale (-37) (11) (by decide) (by decide))

theorem XZ_scale_3 : toVec (XZ 3) = (scale : ℚ) • XCell3_3 :=
  toVec_eq_smul10 (XZ 3) scale XCell3_3
    (eq_smul_div (171) scale (57) (22) (by decide) (by decide))
    (eq_smul_div (16) scale (8) (33) (by decide) (by decide))
    (eq_smul_div (5) scale (5) (66) (by decide) (by decide))
    (eq_smul_div (18) scale (3) (11) (by decide) (by decide))
    (eq_smul_div (25) scale (25) (66) (by decide) (by decide))
    (eq_smul_div (84) scale (14) (11) (by decide) (by decide))
    (eq_smul_div (-13) scale (-13) (66) (by decide) (by decide))
    (eq_smul_div (116) scale (58) (33) (by decide) (by decide))
    (eq_smul_div (-33) scale (-1) (2) (by decide) (by decide))
    (eq_smul_div (73) scale (73) (66) (by decide) (by decide))

theorem XZ_scale_4 : toVec (XZ 4) = (scale : ℚ) • XCell3_4 :=
  toVec_eq_smul10 (XZ 4) scale XCell3_4
    (eq_smul_div (7) scale (7) (66) (by decide) (by decide))
    (eq_smul_div (32) scale (16) (33) (by decide) (by decide))
    (eq_smul_div (17) scale (17) (66) (by decide) (by decide))
    (eq_smul_div (-25) scale (-25) (66) (by decide) (by decide))
    (eq_smul_div (-25) scale (-25) (66) (by decide) (by decide))
    (eq_smul_div (6) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (39) scale (13) (22) (by decide) (by decide))
    (eq_smul_div (1) scale (1) (66) (by decide) (by decide))
    (eq_smul_div (2) scale (1) (33) (by decide) (by decide))
    (eq_smul_div (-10) scale (-5) (33) (by decide) (by decide))

theorem XZ_scale_5 : toVec (XZ 5) = (scale : ℚ) • XCell3_5 :=
  toVec_eq_smul10 (XZ 5) scale XCell3_5
    (eq_smul_div (-178) scale (-89) (33) (by decide) (by decide))
    (eq_smul_int (-66) scale (-1) (by decide))
    (eq_smul_div (-88) scale (-4) (3) (by decide) (by decide))
    (eq_smul_div (-100) scale (-50) (33) (by decide) (by decide))
    (eq_smul_int (-132) scale (-2) (by decide))
    (eq_smul_div (-118) scale (-59) (33) (by decide) (by decide))
    (eq_smul_div (-22) scale (-1) (3) (by decide) (by decide))
    (eq_smul_div (-184) scale (-92) (33) (by decide) (by decide))
    (eq_smul_div (-60) scale (-10) (11) (by decide) (by decide))
    (eq_smul_div (-108) scale (-18) (11) (by decide) (by decide))

theorem XZ_scale_6 : toVec (XZ 6) = (scale : ℚ) • XCell3_6 :=
  toVec_eq_smul10 (XZ 6) scale XCell3_6
    (eq_smul_div (24) scale (4) (11) (by decide) (by decide))
    (eq_smul_div (-28) scale (-14) (33) (by decide) (by decide))
    (eq_smul_div (16) scale (8) (33) (by decide) (by decide))
    (eq_smul_div (-36) scale (-6) (11) (by decide) (by decide))
    (eq_smul_div (-2) scale (-1) (33) (by decide) (by decide))
    (eq_smul_div (48) scale (8) (11) (by decide) (by decide))
    (eq_smul_div (2) scale (1) (33) (by decide) (by decide))
    (eq_smul_div (-18) scale (-3) (11) (by decide) (by decide))
    (eq_smul_div (-62) scale (-31) (33) (by decide) (by decide))
    (eq_smul_div (78) scale (13) (11) (by decide) (by decide))

theorem XZ_scale_7 : toVec (XZ 7) = (scale : ℚ) • XCell3_7 :=
  toVec_eq_smul10 (XZ 7) scale XCell3_7
    (eq_smul_div (-226) scale (-113) (33) (by decide) (by decide))
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-154) scale (-7) (3) (by decide) (by decide))
    (eq_smul_div (-134) scale (-67) (33) (by decide) (by decide))
    (eq_smul_div (-112) scale (-56) (33) (by decide) (by decide))
    (eq_smul_div (-126) scale (-21) (11) (by decide) (by decide))
    (eq_smul_div (-4) scale (-2) (33) (by decide) (by decide))
    (eq_smul_div (-250) scale (-125) (33) (by decide) (by decide))
    (eq_smul_div (-4) scale (-2) (33) (by decide) (by decide))
    (eq_smul_div (-194) scale (-97) (33) (by decide) (by decide))

theorem XZ_scale_8 : toVec (XZ 8) = (scale : ℚ) • XCell3_8 :=
  toVec_eq_smul10 (XZ 8) scale XCell3_8
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

theorem XZ_scale_9 : toVec (XZ 9) = (scale : ℚ) • XCell3_9 :=
  toVec_eq_smul10 (XZ 9) scale XCell3_9
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

theorem XZ_scale_10 : toVec (XZ 10) = (scale : ℚ) • XCell3_10 :=
  toVec_eq_smul10 (XZ 10) scale XCell3_10
    (eq_smul_div (22) scale (1) (3) (by decide) (by decide))
    (eq_smul_div (55) scale (5) (6) (by decide) (by decide))
    (eq_smul_int (66) scale (1) (by decide))
    (eq_smul_div (44) scale (2) (3) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (44) scale (2) (3) (by decide) (by decide))
    (eq_smul_div (55) scale (5) (6) (by decide) (by decide))
    (eq_smul_int (66) scale (1) (by decide))
    (eq_smul_div (11) scale (1) (6) (by decide) (by decide))

theorem XZ_scale_11 : toVec (XZ 11) = (scale : ℚ) • XCell3_11 :=
  toVec_eq_smul10 (XZ 11) scale XCell3_11
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

theorem XZ_scale_12 : toVec (XZ 12) = (scale : ℚ) • XCell3_12 :=
  toVec_eq_smul10 (XZ 12) scale XCell3_12
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

theorem XZ_scale_13 : toVec (XZ 13) = (scale : ℚ) • XCell3_13 :=
  toVec_eq_smul10 (XZ 13) scale XCell3_13
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

theorem XZ_scale_14 : toVec (XZ 14) = (scale : ℚ) • XCell3_14 :=
  toVec_eq_smul10 (XZ 14) scale XCell3_14
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

theorem XZ_scale_15 : toVec (XZ 15) = (scale : ℚ) • XCell3_15 :=
  toVec_eq_smul10 (XZ 15) scale XCell3_15
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

theorem XZ_scale_16 : toVec (XZ 16) = (scale : ℚ) • XCell3_16 :=
  toVec_eq_smul10 (XZ 16) scale XCell3_16
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

theorem XZ_scale_17 : toVec (XZ 17) = (scale : ℚ) • XCell3_17 :=
  toVec_eq_smul10 (XZ 17) scale XCell3_17
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

theorem XZ_scale_18 : toVec (XZ 18) = (scale : ℚ) • XCell3_18 :=
  toVec_eq_smul10 (XZ 18) scale XCell3_18
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

theorem XZ_scale_19 : toVec (XZ 19) = (scale : ℚ) • XCell3_19 :=
  toVec_eq_smul10 (XZ 19) scale XCell3_19
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
    toVec (XZ k) = (scale : ℚ) • XVec (3 : Fin 10) k :=
  forall_fin20 (P := fun k => toVec (XZ k) = (scale : ℚ) • XVec (3 : Fin 10) k)
    XZ_scale_0 XZ_scale_1 XZ_scale_2 XZ_scale_3 XZ_scale_4 XZ_scale_5 XZ_scale_6 XZ_scale_7 XZ_scale_8 XZ_scale_9 XZ_scale_10 XZ_scale_11 XZ_scale_12 XZ_scale_13 XZ_scale_14 XZ_scale_15 XZ_scale_16 XZ_scale_17 XZ_scale_18 XZ_scale_19 k

theorem AZ_scale_0 : toVec (AZ 0) = (scale : ℚ) • ACell0_6 :=
  toVec_eq_smul10 (AZ 0) scale ACell0_6
    (eq_smul_zero scale)
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (-12) scale (-2) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (-12) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_zero scale)

theorem AZ_scale_1 : toVec (AZ 1) = (scale : ℚ) • ACell1_6 :=
  toVec_eq_smul10 (AZ 1) scale ACell1_6
    (eq_smul_zero scale)
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (-12) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-12) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)

theorem AZ_scale_2 : toVec (AZ 2) = (scale : ℚ) • ACell2_6 :=
  toVec_eq_smul10 (AZ 2) scale ACell2_6
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (24) scale (4) (11) (by decide) (by decide))
    (eq_smul_div (24) scale (4) (11) (by decide) (by decide))
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))

theorem AZ_scale_3 : toVec (AZ 3) = (scale : ℚ) • ACell3_6 :=
  toVec_eq_smul10 (AZ 3) scale ACell3_6
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (24) scale (4) (11) (by decide) (by decide))
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (24) scale (4) (11) (by decide) (by decide))
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))

theorem AZ_scale_4 : toVec (AZ 4) = (scale : ℚ) • ACell4_6 :=
  toVec_eq_smul10 (AZ 4) scale ACell4_6
    (eq_smul_zero scale)
    (eq_smul_div (-12) scale (-2) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (-12) scale (-2) (11) (by decide) (by decide))

theorem AZ_scale_5 : toVec (AZ 5) = (scale : ℚ) • ACell5_6 :=
  toVec_eq_smul10 (AZ 5) scale ACell5_6
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (6) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (6) scale (1) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-12) scale (-2) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (6) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (6) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_zero scale)

theorem AZ_scale_6 : toVec (AZ 6) = (scale : ℚ) • ACell6_6 :=
  toVec_eq_smul10 (AZ 6) scale ACell6_6
    (eq_smul_div (60) scale (10) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (6) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (6) scale (1) (11) (by decide) (by decide))

theorem AZ_scale_7 : toVec (AZ 7) = (scale : ℚ) • ACell7_6 :=
  toVec_eq_smul10 (AZ 7) scale ACell7_6
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (6) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (6) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_zero scale)

theorem AZ_scale_8 : toVec (AZ 8) = (scale : ℚ) • ACell8_6 :=
  toVec_eq_smul10 (AZ 8) scale ACell8_6
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (-12) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-18) scale (-3) (11) (by decide) (by decide))
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-12) scale (-2) (11) (by decide) (by decide))

theorem AZ_scale_9 : toVec (AZ 9) = (scale : ℚ) • ACell9_6 :=
  toVec_eq_smul10 (AZ 9) scale ACell9_6
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (6) scale (1) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (6) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (6) scale (1) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (6) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (18) scale (3) (11) (by decide) (by decide))

theorem AZ_scale_10 : toVec (AZ 10) = (scale : ℚ) • ACell10_6 :=
  toVec_eq_smul10 (AZ 10) scale ACell10_6
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (-12) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-12) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_zero scale)

theorem AZ_scale_11 : toVec (AZ 11) = (scale : ℚ) • ACell11_6 :=
  toVec_eq_smul10 (AZ 11) scale ACell11_6
    (eq_smul_div (-12) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-12) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-12) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-12) scale (-2) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-12) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-24) scale (-4) (11) (by decide) (by decide))
    (eq_smul_div (-12) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-24) scale (-4) (11) (by decide) (by decide))
    (eq_smul_div (-12) scale (-2) (11) (by decide) (by decide))

theorem AZ_scale_12 : toVec (AZ 12) = (scale : ℚ) • ACell12_6 :=
  toVec_eq_smul10 (AZ 12) scale ACell12_6
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (24) scale (4) (11) (by decide) (by decide))
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (24) scale (4) (11) (by decide) (by decide))
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))

theorem AZ_scale_13 : toVec (AZ 13) = (scale : ℚ) • ACell13_6 :=
  toVec_eq_smul10 (AZ 13) scale ACell13_6
    (eq_smul_div (-12) scale (-2) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (-12) scale (-2) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)

theorem AZ_scale_14 : toVec (AZ 14) = (scale : ℚ) • ACell14_6 :=
  toVec_eq_smul10 (AZ 14) scale ACell14_6
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (-12) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (-12) scale (-2) (11) (by decide) (by decide))
    (eq_smul_zero scale)

theorem AZ_scale_15 : toVec (AZ 15) = (scale : ℚ) • ACell15_6 :=
  toVec_eq_smul10 (AZ 15) scale ACell15_6
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (6) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (6) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (6) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (6) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (-12) scale (-2) (11) (by decide) (by decide))
    (eq_smul_zero scale)

theorem AZ_scale_16 : toVec (AZ 16) = (scale : ℚ) • ACell16_6 :=
  toVec_eq_smul10 (AZ 16) scale ACell16_6
    (eq_smul_div (-60) scale (-10) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-12) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-12) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-12) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-12) scale (-2) (11) (by decide) (by decide))

theorem AZ_scale_17 : toVec (AZ 17) = (scale : ℚ) • ACell17_6 :=
  toVec_eq_smul10 (AZ 17) scale ACell17_6
    (eq_smul_div (6) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (18) scale (3) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (6) scale (1) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (6) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (6) scale (1) (11) (by decide) (by decide))

theorem AZ_scale_18 : toVec (AZ 18) = (scale : ℚ) • ACell18_6 :=
  toVec_eq_smul10 (AZ 18) scale ACell18_6
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-18) scale (-3) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-12) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-12) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))

theorem AZ_scale_19 : toVec (AZ 19) = (scale : ℚ) • ACell19_6 :=
  toVec_eq_smul10 (AZ 19) scale ACell19_6
    (eq_smul_div (6) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (6) scale (1) (11) (by decide) (by decide))
    (eq_smul_zero scale)

theorem AZ_scale (k : Fin 20) :
    toVec (AZ k) = (scale : ℚ) • AVec k (6 : Fin 10) :=
  forall_fin20 (P := fun k => toVec (AZ k) = (scale : ℚ) • AVec k (6 : Fin 10))
    AZ_scale_0 AZ_scale_1 AZ_scale_2 AZ_scale_3 AZ_scale_4 AZ_scale_5 AZ_scale_6 AZ_scale_7 AZ_scale_8 AZ_scale_9 AZ_scale_10 AZ_scale_11 AZ_scale_12 AZ_scale_13 AZ_scale_14 AZ_scale_15 AZ_scale_16 AZ_scale_17 AZ_scale_18 AZ_scale_19 k

theorem KZ_scale_0 : toVec (KZ 0) = (scale : ℚ) • KCell3_0 :=
  toVec_eq_smul10 (KZ 0) scale KCell3_0
    (eq_smul_zero scale)
    (eq_smul_int (66) scale (1) (by decide))
    (eq_smul_int (66) scale (1) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_int (66) scale (1) (by decide))
    (eq_smul_int (66) scale (1) (by decide))
    (eq_smul_int (66) scale (1) (by decide))
    (eq_smul_zero scale)

theorem KZ_scale (k : Fin 1) :
    toVec (KZ k) = (scale : ℚ) • KVec (3 : Fin 10) k :=
  forall_fin1 (P := fun k => toVec (KZ k) = (scale : ℚ) • KVec (3 : Fin 10) k)
    KZ_scale_0 k

theorem YZ_scale_0 : toVec (YZ 0) = (scale : ℚ) • YCell0_6 :=
  toVec_eq_smul10 (YZ 0) scale YCell0_6
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

theorem YZ_scale (k : Fin 1) :
    toVec (YZ k) = (scale : ℚ) • YVec k (6 : Fin 10) :=
  forall_fin1 (P := fun k => toVec (YZ k) = (scale : ℚ) • YVec k (6 : Fin 10))
    YZ_scale_0 k

theorem entry_eq :
    (matrixMul XVec AVec + matrixMul KVec YVec)
        (3 : Fin 10) (6 : Fin 10) = ![0, 0, 0, 0, 0, 0, 0, 0, 0, 0] := by
  change (∑ k : Fin 20, mul (XVec (3 : Fin 10) k)
      (AVec k (6 : Fin 10))) +
    (∑ k : Fin 1, mul (KVec (3 : Fin 10) k)
      (YVec k (6 : Fin 10))) = _
  refine add_sum_mul_eq_of_scaled scale scale_ne_zero
    (fun k => XVec (3 : Fin 10) k)
    (fun k => AVec k (6 : Fin 10))
    (fun k => KVec (3 : Fin 10) k)
    (fun k => YVec k (6 : Fin 10))
    XZ AZ KZ YZ XZ_scale AZ_scale KZ_scale YZ_scale entryZ rfl _ ?_
  rw [entryZ_eq, toVec_zeroZ_smul, vec_zero_eq]

theorem entry_eq_matrixOne :
    (matrixMul XVec AVec + matrixMul KVec YVec)
        (3 : Fin 10) (6 : Fin 10) =
      matrixOne (Fin 10) (3 : Fin 10) (6 : Fin 10) :=
  entry_eq.trans (matrixOne_off10 (3 : Fin 10) (6 : Fin 10) (by decide)).symm

end V14Formalization.D12PieceAPSplitEntry3_6


namespace V14Formalization.D12PieceAPSplitEntry3_7
open D12CyclotomicVec D12CyclotomicVecZ D12PieceAPData
def payloadSha256 : String := "76c6196f29afe1a8398af99502447f48ebeed4bcb3805fc5dbec693940bc04b0"

def scale : ℤ := 66

def XZ (k : Fin 20) : VecZ :=
  match k.val with
  | 0 => #v[41, 40, 112, 50, 35, 92, 63, 53, 29, 123]
  | 1 => #v[-7, -28, 10, 29, -3, -18, -3, 10, -2, 45]
  | 2 => #v[-130, 14, -151, -73, -55, -110, -37, -135, 19, -222]
  | 3 => #v[171, 16, 5, 18, 25, 84, -13, 116, -33, 73]
  | 4 => #v[7, 32, 17, -25, -25, 6, 39, 1, 2, -10]
  | 5 => #v[-178, -66, -88, -100, -132, -118, -22, -184, -60, -108]
  | 6 => #v[24, -28, 16, -36, -2, 48, 2, -18, -62, 78]
  | 7 => #v[-226, -6, -154, -134, -112, -126, -4, -250, -4, -194]
  | 8 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  | 9 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  | 10 => #v[22, 55, 66, 44, 0, 0, 44, 55, 66, 11]
  | 11 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
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
  | 0 => #v[0, 0, 12, -12, -12, 12, 0, 0, 0, 0]
  | 1 => #v[-12, -12, -12, -12, 0, -12, -24, -12, -24, -12]
  | 2 => #v[-12, 0, -12, -12, -24, -12, -12, -24, -12, -12]
  | 3 => #v[0, -12, 0, 0, 12, 12, 0, 0, -12, 0]
  | 4 => #v[0, -12, 12, 0, 0, 0, 12, -12, 0, 0]
  | 5 => #v[-12, -6, -6, -18, -6, -6, -12, 0, 0, 0]
  | 6 => #v[-6, 6, 12, 6, -6, 0, 0, -6, -6, 0]
  | 7 => #v[54, 6, -12, 0, -6, -12, -6, -6, -12, -6]
  | 8 => #v[0, 6, 12, 6, 12, -6, 12, 6, 12, 6]
  | 9 => #v[0, 12, 6, 6, 12, 0, 0, 6, 18, 6]
  | 10 => #v[12, 24, 12, 12, 12, 12, 24, 12, 0, 12]
  | 11 => #v[-12, -12, -24, -12, -12, -12, -24, -12, -12, 0]
  | 12 => #v[-12, 12, 0, 0, 0, 12, -12, 0, 0, 0]
  | 13 => #v[12, 12, 0, 12, 12, 24, 12, 24, 12, 12]
  | 14 => #v[0, 0, 0, 0, 0, 0, 12, -12, -12, 12]
  | 15 => #v[0, 6, 12, 6, 12, -6, 12, 6, 12, 6]
  | 16 => #v[-6, -12, -6, -6, -12, -6, 0, -12, 6, -12]
  | 17 => #v[-54, 0, -6, -6, 6, 0, 0, 6, -6, -6]
  | 18 => #v[6, 18, 12, 12, 18, 18, 12, 12, 18, 6]
  | 19 => #v[0, 12, 0, 0, 6, -6, -6, -6, -6, 6]
  | _ => zeroZ

def KZ (k : Fin 1) : VecZ :=
  match k.val with
  | 0 => #v[0, 66, 66, 0, 0, 0, 66, 66, 66, 0]
  | _ => zeroZ

def YZ (k : Fin 1) : VecZ :=
  match k.val with
  | 0 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  | _ => zeroZ

def xaEntryZ : VecZ := sumFin (fun k => mulZ (XZ k) (AZ k))
def kyEntryZ : VecZ := sumFin (fun k => mulZ (KZ k) (YZ k))
def entryZ : VecZ := addZ xaEntryZ kyEntryZ

theorem entryZ_eq : entryZ = zeroZ :=
  eq_of_eqZ (by decide +kernel)

theorem scale_ne_zero : scale ≠ 0 := by
  decide

theorem XZ_scale_0 : toVec (XZ 0) = (scale : ℚ) • XCell3_0 :=
  toVec_eq_smul10 (XZ 0) scale XCell3_0
    (eq_smul_div (41) scale (41) (66) (by decide) (by decide))
    (eq_smul_div (40) scale (20) (33) (by decide) (by decide))
    (eq_smul_div (112) scale (56) (33) (by decide) (by decide))
    (eq_smul_div (50) scale (25) (33) (by decide) (by decide))
    (eq_smul_div (35) scale (35) (66) (by decide) (by decide))
    (eq_smul_div (92) scale (46) (33) (by decide) (by decide))
    (eq_smul_div (63) scale (21) (22) (by decide) (by decide))
    (eq_smul_div (53) scale (53) (66) (by decide) (by decide))
    (eq_smul_div (29) scale (29) (66) (by decide) (by decide))
    (eq_smul_div (123) scale (41) (22) (by decide) (by decide))

theorem XZ_scale_1 : toVec (XZ 1) = (scale : ℚ) • XCell3_1 :=
  toVec_eq_smul10 (XZ 1) scale XCell3_1
    (eq_smul_div (-7) scale (-7) (66) (by decide) (by decide))
    (eq_smul_div (-28) scale (-14) (33) (by decide) (by decide))
    (eq_smul_div (10) scale (5) (33) (by decide) (by decide))
    (eq_smul_div (29) scale (29) (66) (by decide) (by decide))
    (eq_smul_div (-3) scale (-1) (22) (by decide) (by decide))
    (eq_smul_div (-18) scale (-3) (11) (by decide) (by decide))
    (eq_smul_div (-3) scale (-1) (22) (by decide) (by decide))
    (eq_smul_div (10) scale (5) (33) (by decide) (by decide))
    (eq_smul_div (-2) scale (-1) (33) (by decide) (by decide))
    (eq_smul_div (45) scale (15) (22) (by decide) (by decide))

theorem XZ_scale_2 : toVec (XZ 2) = (scale : ℚ) • XCell3_2 :=
  toVec_eq_smul10 (XZ 2) scale XCell3_2
    (eq_smul_div (-130) scale (-65) (33) (by decide) (by decide))
    (eq_smul_div (14) scale (7) (33) (by decide) (by decide))
    (eq_smul_div (-151) scale (-151) (66) (by decide) (by decide))
    (eq_smul_div (-73) scale (-73) (66) (by decide) (by decide))
    (eq_smul_div (-55) scale (-5) (6) (by decide) (by decide))
    (eq_smul_div (-110) scale (-5) (3) (by decide) (by decide))
    (eq_smul_div (-37) scale (-37) (66) (by decide) (by decide))
    (eq_smul_div (-135) scale (-45) (22) (by decide) (by decide))
    (eq_smul_div (19) scale (19) (66) (by decide) (by decide))
    (eq_smul_div (-222) scale (-37) (11) (by decide) (by decide))

theorem XZ_scale_3 : toVec (XZ 3) = (scale : ℚ) • XCell3_3 :=
  toVec_eq_smul10 (XZ 3) scale XCell3_3
    (eq_smul_div (171) scale (57) (22) (by decide) (by decide))
    (eq_smul_div (16) scale (8) (33) (by decide) (by decide))
    (eq_smul_div (5) scale (5) (66) (by decide) (by decide))
    (eq_smul_div (18) scale (3) (11) (by decide) (by decide))
    (eq_smul_div (25) scale (25) (66) (by decide) (by decide))
    (eq_smul_div (84) scale (14) (11) (by decide) (by decide))
    (eq_smul_div (-13) scale (-13) (66) (by decide) (by decide))
    (eq_smul_div (116) scale (58) (33) (by decide) (by decide))
    (eq_smul_div (-33) scale (-1) (2) (by decide) (by decide))
    (eq_smul_div (73) scale (73) (66) (by decide) (by decide))

theorem XZ_scale_4 : toVec (XZ 4) = (scale : ℚ) • XCell3_4 :=
  toVec_eq_smul10 (XZ 4) scale XCell3_4
    (eq_smul_div (7) scale (7) (66) (by decide) (by decide))
    (eq_smul_div (32) scale (16) (33) (by decide) (by decide))
    (eq_smul_div (17) scale (17) (66) (by decide) (by decide))
    (eq_smul_div (-25) scale (-25) (66) (by decide) (by decide))
    (eq_smul_div (-25) scale (-25) (66) (by decide) (by decide))
    (eq_smul_div (6) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (39) scale (13) (22) (by decide) (by decide))
    (eq_smul_div (1) scale (1) (66) (by decide) (by decide))
    (eq_smul_div (2) scale (1) (33) (by decide) (by decide))
    (eq_smul_div (-10) scale (-5) (33) (by decide) (by decide))

theorem XZ_scale_5 : toVec (XZ 5) = (scale : ℚ) • XCell3_5 :=
  toVec_eq_smul10 (XZ 5) scale XCell3_5
    (eq_smul_div (-178) scale (-89) (33) (by decide) (by decide))
    (eq_smul_int (-66) scale (-1) (by decide))
    (eq_smul_div (-88) scale (-4) (3) (by decide) (by decide))
    (eq_smul_div (-100) scale (-50) (33) (by decide) (by decide))
    (eq_smul_int (-132) scale (-2) (by decide))
    (eq_smul_div (-118) scale (-59) (33) (by decide) (by decide))
    (eq_smul_div (-22) scale (-1) (3) (by decide) (by decide))
    (eq_smul_div (-184) scale (-92) (33) (by decide) (by decide))
    (eq_smul_div (-60) scale (-10) (11) (by decide) (by decide))
    (eq_smul_div (-108) scale (-18) (11) (by decide) (by decide))

theorem XZ_scale_6 : toVec (XZ 6) = (scale : ℚ) • XCell3_6 :=
  toVec_eq_smul10 (XZ 6) scale XCell3_6
    (eq_smul_div (24) scale (4) (11) (by decide) (by decide))
    (eq_smul_div (-28) scale (-14) (33) (by decide) (by decide))
    (eq_smul_div (16) scale (8) (33) (by decide) (by decide))
    (eq_smul_div (-36) scale (-6) (11) (by decide) (by decide))
    (eq_smul_div (-2) scale (-1) (33) (by decide) (by decide))
    (eq_smul_div (48) scale (8) (11) (by decide) (by decide))
    (eq_smul_div (2) scale (1) (33) (by decide) (by decide))
    (eq_smul_div (-18) scale (-3) (11) (by decide) (by decide))
    (eq_smul_div (-62) scale (-31) (33) (by decide) (by decide))
    (eq_smul_div (78) scale (13) (11) (by decide) (by decide))

theorem XZ_scale_7 : toVec (XZ 7) = (scale : ℚ) • XCell3_7 :=
  toVec_eq_smul10 (XZ 7) scale XCell3_7
    (eq_smul_div (-226) scale (-113) (33) (by decide) (by decide))
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-154) scale (-7) (3) (by decide) (by decide))
    (eq_smul_div (-134) scale (-67) (33) (by decide) (by decide))
    (eq_smul_div (-112) scale (-56) (33) (by decide) (by decide))
    (eq_smul_div (-126) scale (-21) (11) (by decide) (by decide))
    (eq_smul_div (-4) scale (-2) (33) (by decide) (by decide))
    (eq_smul_div (-250) scale (-125) (33) (by decide) (by decide))
    (eq_smul_div (-4) scale (-2) (33) (by decide) (by decide))
    (eq_smul_div (-194) scale (-97) (33) (by decide) (by decide))

theorem XZ_scale_8 : toVec (XZ 8) = (scale : ℚ) • XCell3_8 :=
  toVec_eq_smul10 (XZ 8) scale XCell3_8
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

theorem XZ_scale_9 : toVec (XZ 9) = (scale : ℚ) • XCell3_9 :=
  toVec_eq_smul10 (XZ 9) scale XCell3_9
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

theorem XZ_scale_10 : toVec (XZ 10) = (scale : ℚ) • XCell3_10 :=
  toVec_eq_smul10 (XZ 10) scale XCell3_10
    (eq_smul_div (22) scale (1) (3) (by decide) (by decide))
    (eq_smul_div (55) scale (5) (6) (by decide) (by decide))
    (eq_smul_int (66) scale (1) (by decide))
    (eq_smul_div (44) scale (2) (3) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (44) scale (2) (3) (by decide) (by decide))
    (eq_smul_div (55) scale (5) (6) (by decide) (by decide))
    (eq_smul_int (66) scale (1) (by decide))
    (eq_smul_div (11) scale (1) (6) (by decide) (by decide))

theorem XZ_scale_11 : toVec (XZ 11) = (scale : ℚ) • XCell3_11 :=
  toVec_eq_smul10 (XZ 11) scale XCell3_11
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

theorem XZ_scale_12 : toVec (XZ 12) = (scale : ℚ) • XCell3_12 :=
  toVec_eq_smul10 (XZ 12) scale XCell3_12
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

theorem XZ_scale_13 : toVec (XZ 13) = (scale : ℚ) • XCell3_13 :=
  toVec_eq_smul10 (XZ 13) scale XCell3_13
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

theorem XZ_scale_14 : toVec (XZ 14) = (scale : ℚ) • XCell3_14 :=
  toVec_eq_smul10 (XZ 14) scale XCell3_14
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

theorem XZ_scale_15 : toVec (XZ 15) = (scale : ℚ) • XCell3_15 :=
  toVec_eq_smul10 (XZ 15) scale XCell3_15
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

theorem XZ_scale_16 : toVec (XZ 16) = (scale : ℚ) • XCell3_16 :=
  toVec_eq_smul10 (XZ 16) scale XCell3_16
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

theorem XZ_scale_17 : toVec (XZ 17) = (scale : ℚ) • XCell3_17 :=
  toVec_eq_smul10 (XZ 17) scale XCell3_17
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

theorem XZ_scale_18 : toVec (XZ 18) = (scale : ℚ) • XCell3_18 :=
  toVec_eq_smul10 (XZ 18) scale XCell3_18
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

theorem XZ_scale_19 : toVec (XZ 19) = (scale : ℚ) • XCell3_19 :=
  toVec_eq_smul10 (XZ 19) scale XCell3_19
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
    toVec (XZ k) = (scale : ℚ) • XVec (3 : Fin 10) k :=
  forall_fin20 (P := fun k => toVec (XZ k) = (scale : ℚ) • XVec (3 : Fin 10) k)
    XZ_scale_0 XZ_scale_1 XZ_scale_2 XZ_scale_3 XZ_scale_4 XZ_scale_5 XZ_scale_6 XZ_scale_7 XZ_scale_8 XZ_scale_9 XZ_scale_10 XZ_scale_11 XZ_scale_12 XZ_scale_13 XZ_scale_14 XZ_scale_15 XZ_scale_16 XZ_scale_17 XZ_scale_18 XZ_scale_19 k

theorem AZ_scale_0 : toVec (AZ 0) = (scale : ℚ) • ACell0_7 :=
  toVec_eq_smul10 (AZ 0) scale ACell0_7
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (-12) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-12) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)

theorem AZ_scale_1 : toVec (AZ 1) = (scale : ℚ) • ACell1_7 :=
  toVec_eq_smul10 (AZ 1) scale ACell1_7
    (eq_smul_div (-12) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-12) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-12) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-12) scale (-2) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-12) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-24) scale (-4) (11) (by decide) (by decide))
    (eq_smul_div (-12) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-24) scale (-4) (11) (by decide) (by decide))
    (eq_smul_div (-12) scale (-2) (11) (by decide) (by decide))

theorem AZ_scale_2 : toVec (AZ 2) = (scale : ℚ) • ACell2_7 :=
  toVec_eq_smul10 (AZ 2) scale ACell2_7
    (eq_smul_div (-12) scale (-2) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-12) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-12) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-24) scale (-4) (11) (by decide) (by decide))
    (eq_smul_div (-12) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-12) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-24) scale (-4) (11) (by decide) (by decide))
    (eq_smul_div (-12) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-12) scale (-2) (11) (by decide) (by decide))

theorem AZ_scale_3 : toVec (AZ 3) = (scale : ℚ) • ACell3_7 :=
  toVec_eq_smul10 (AZ 3) scale ACell3_7
    (eq_smul_zero scale)
    (eq_smul_div (-12) scale (-2) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (-12) scale (-2) (11) (by decide) (by decide))
    (eq_smul_zero scale)

theorem AZ_scale_4 : toVec (AZ 4) = (scale : ℚ) • ACell4_7 :=
  toVec_eq_smul10 (AZ 4) scale ACell4_7
    (eq_smul_zero scale)
    (eq_smul_div (-12) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (-12) scale (-2) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)

theorem AZ_scale_5 : toVec (AZ 5) = (scale : ℚ) • ACell5_7 :=
  toVec_eq_smul10 (AZ 5) scale ACell5_7
    (eq_smul_div (-12) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-18) scale (-3) (11) (by decide) (by decide))
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-12) scale (-2) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)

theorem AZ_scale_6 : toVec (AZ 6) = (scale : ℚ) • ACell6_7 :=
  toVec_eq_smul10 (AZ 6) scale ACell6_7
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (6) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (6) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_zero scale)

theorem AZ_scale_7 : toVec (AZ 7) = (scale : ℚ) • ACell7_7 :=
  toVec_eq_smul10 (AZ 7) scale ACell7_7
    (eq_smul_div (54) scale (9) (11) (by decide) (by decide))
    (eq_smul_div (6) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (-12) scale (-2) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-12) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-12) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))

theorem AZ_scale_8 : toVec (AZ 8) = (scale : ℚ) • ACell8_7 :=
  toVec_eq_smul10 (AZ 8) scale ACell8_7
    (eq_smul_zero scale)
    (eq_smul_div (6) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (6) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (6) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (6) scale (1) (11) (by decide) (by decide))

theorem AZ_scale_9 : toVec (AZ 9) = (scale : ℚ) • ACell9_7 :=
  toVec_eq_smul10 (AZ 9) scale ACell9_7
    (eq_smul_zero scale)
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (6) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (6) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (6) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (18) scale (3) (11) (by decide) (by decide))
    (eq_smul_div (6) scale (1) (11) (by decide) (by decide))

theorem AZ_scale_10 : toVec (AZ 10) = (scale : ℚ) • ACell10_7 :=
  toVec_eq_smul10 (AZ 10) scale ACell10_7
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (24) scale (4) (11) (by decide) (by decide))
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (24) scale (4) (11) (by decide) (by decide))
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))

theorem AZ_scale_11 : toVec (AZ 11) = (scale : ℚ) • ACell11_7 :=
  toVec_eq_smul10 (AZ 11) scale ACell11_7
    (eq_smul_div (-12) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-12) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-24) scale (-4) (11) (by decide) (by decide))
    (eq_smul_div (-12) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-12) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-12) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-24) scale (-4) (11) (by decide) (by decide))
    (eq_smul_div (-12) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-12) scale (-2) (11) (by decide) (by decide))
    (eq_smul_zero scale)

theorem AZ_scale_12 : toVec (AZ 12) = (scale : ℚ) • ACell12_7 :=
  toVec_eq_smul10 (AZ 12) scale ACell12_7
    (eq_smul_div (-12) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (-12) scale (-2) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)

theorem AZ_scale_13 : toVec (AZ 13) = (scale : ℚ) • ACell13_7 :=
  toVec_eq_smul10 (AZ 13) scale ACell13_7
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (24) scale (4) (11) (by decide) (by decide))
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (24) scale (4) (11) (by decide) (by decide))
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))

theorem AZ_scale_14 : toVec (AZ 14) = (scale : ℚ) • ACell14_7 :=
  toVec_eq_smul10 (AZ 14) scale ACell14_7
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (-12) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-12) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))

theorem AZ_scale_15 : toVec (AZ 15) = (scale : ℚ) • ACell15_7 :=
  toVec_eq_smul10 (AZ 15) scale ACell15_7
    (eq_smul_zero scale)
    (eq_smul_div (6) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (6) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (6) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (6) scale (1) (11) (by decide) (by decide))

theorem AZ_scale_16 : toVec (AZ 16) = (scale : ℚ) • ACell16_7 :=
  toVec_eq_smul10 (AZ 16) scale ACell16_7
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-12) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-12) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-12) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (6) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (-12) scale (-2) (11) (by decide) (by decide))

theorem AZ_scale_17 : toVec (AZ 17) = (scale : ℚ) • ACell17_7 :=
  toVec_eq_smul10 (AZ 17) scale ACell17_7
    (eq_smul_div (-54) scale (-9) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (6) scale (1) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (6) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))

theorem AZ_scale_18 : toVec (AZ 18) = (scale : ℚ) • ACell18_7 :=
  toVec_eq_smul10 (AZ 18) scale ACell18_7
    (eq_smul_div (6) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (18) scale (3) (11) (by decide) (by decide))
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (18) scale (3) (11) (by decide) (by decide))
    (eq_smul_div (18) scale (3) (11) (by decide) (by decide))
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (18) scale (3) (11) (by decide) (by decide))
    (eq_smul_div (6) scale (1) (11) (by decide) (by decide))

theorem AZ_scale_19 : toVec (AZ 19) = (scale : ℚ) • ACell19_7 :=
  toVec_eq_smul10 (AZ 19) scale ACell19_7
    (eq_smul_zero scale)
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (6) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (6) scale (1) (11) (by decide) (by decide))

theorem AZ_scale (k : Fin 20) :
    toVec (AZ k) = (scale : ℚ) • AVec k (7 : Fin 10) :=
  forall_fin20 (P := fun k => toVec (AZ k) = (scale : ℚ) • AVec k (7 : Fin 10))
    AZ_scale_0 AZ_scale_1 AZ_scale_2 AZ_scale_3 AZ_scale_4 AZ_scale_5 AZ_scale_6 AZ_scale_7 AZ_scale_8 AZ_scale_9 AZ_scale_10 AZ_scale_11 AZ_scale_12 AZ_scale_13 AZ_scale_14 AZ_scale_15 AZ_scale_16 AZ_scale_17 AZ_scale_18 AZ_scale_19 k

theorem KZ_scale_0 : toVec (KZ 0) = (scale : ℚ) • KCell3_0 :=
  toVec_eq_smul10 (KZ 0) scale KCell3_0
    (eq_smul_zero scale)
    (eq_smul_int (66) scale (1) (by decide))
    (eq_smul_int (66) scale (1) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_int (66) scale (1) (by decide))
    (eq_smul_int (66) scale (1) (by decide))
    (eq_smul_int (66) scale (1) (by decide))
    (eq_smul_zero scale)

theorem KZ_scale (k : Fin 1) :
    toVec (KZ k) = (scale : ℚ) • KVec (3 : Fin 10) k :=
  forall_fin1 (P := fun k => toVec (KZ k) = (scale : ℚ) • KVec (3 : Fin 10) k)
    KZ_scale_0 k

theorem YZ_scale_0 : toVec (YZ 0) = (scale : ℚ) • YCell0_7 :=
  toVec_eq_smul10 (YZ 0) scale YCell0_7
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

theorem YZ_scale (k : Fin 1) :
    toVec (YZ k) = (scale : ℚ) • YVec k (7 : Fin 10) :=
  forall_fin1 (P := fun k => toVec (YZ k) = (scale : ℚ) • YVec k (7 : Fin 10))
    YZ_scale_0 k

theorem entry_eq :
    (matrixMul XVec AVec + matrixMul KVec YVec)
        (3 : Fin 10) (7 : Fin 10) = ![0, 0, 0, 0, 0, 0, 0, 0, 0, 0] := by
  change (∑ k : Fin 20, mul (XVec (3 : Fin 10) k)
      (AVec k (7 : Fin 10))) +
    (∑ k : Fin 1, mul (KVec (3 : Fin 10) k)
      (YVec k (7 : Fin 10))) = _
  refine add_sum_mul_eq_of_scaled scale scale_ne_zero
    (fun k => XVec (3 : Fin 10) k)
    (fun k => AVec k (7 : Fin 10))
    (fun k => KVec (3 : Fin 10) k)
    (fun k => YVec k (7 : Fin 10))
    XZ AZ KZ YZ XZ_scale AZ_scale KZ_scale YZ_scale entryZ rfl _ ?_
  rw [entryZ_eq, toVec_zeroZ_smul, vec_zero_eq]

theorem entry_eq_matrixOne :
    (matrixMul XVec AVec + matrixMul KVec YVec)
        (3 : Fin 10) (7 : Fin 10) =
      matrixOne (Fin 10) (3 : Fin 10) (7 : Fin 10) :=
  entry_eq.trans (matrixOne_off10 (3 : Fin 10) (7 : Fin 10) (by decide)).symm

end V14Formalization.D12PieceAPSplitEntry3_7


namespace V14Formalization.D12PieceAPSplitEntry3_8
open D12CyclotomicVec D12CyclotomicVecZ D12PieceAPData
def payloadSha256 : String := "76c6196f29afe1a8398af99502447f48ebeed4bcb3805fc5dbec693940bc04b0"

def scale : ℤ := 66

def XZ (k : Fin 20) : VecZ :=
  match k.val with
  | 0 => #v[41, 40, 112, 50, 35, 92, 63, 53, 29, 123]
  | 1 => #v[-7, -28, 10, 29, -3, -18, -3, 10, -2, 45]
  | 2 => #v[-130, 14, -151, -73, -55, -110, -37, -135, 19, -222]
  | 3 => #v[171, 16, 5, 18, 25, 84, -13, 116, -33, 73]
  | 4 => #v[7, 32, 17, -25, -25, 6, 39, 1, 2, -10]
  | 5 => #v[-178, -66, -88, -100, -132, -118, -22, -184, -60, -108]
  | 6 => #v[24, -28, 16, -36, -2, 48, 2, -18, -62, 78]
  | 7 => #v[-226, -6, -154, -134, -112, -126, -4, -250, -4, -194]
  | 8 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  | 9 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  | 10 => #v[22, 55, 66, 44, 0, 0, 44, 55, 66, 11]
  | 11 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
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
  | 0 => #v[0, -12, 0, -12, 0, 0, 12, 0, 0, 12]
  | 1 => #v[0, 0, -12, 12, 0, 0, 0, 0, 12, -12]
  | 2 => #v[0, -12, 0, 12, 0, 12, 0, -12, 0, 0]
  | 3 => #v[12, 12, 12, 12, 12, 12, 12, 0, 24, 24]
  | 4 => #v[-12, -12, -24, -24, -12, -12, 0, -12, -12, -12]
  | 5 => #v[-6, 0, 0, -6, 0, 6, -6, 12, -6, 6]
  | 6 => #v[0, 0, 0, -12, -6, -6, -18, -6, -6, -12]
  | 7 => #v[0, 6, 12, 6, 12, -6, 12, 6, 12, 6]
  | 8 => #v[60, -6, 6, 0, 0, 6, -6, -6, 0, 12]
  | 9 => #v[-12, -18, -12, 0, -6, -6, 0, 0, -6, -6]
  | 10 => #v[0, -12, 12, 0, 0, 0, 0, 12, -12, 0]
  | 11 => #v[0, -24, -12, -12, -12, -12, -12, -12, -12, -24]
  | 12 => #v[12, 12, 24, 12, 12, 12, 24, 12, 12, 0]
  | 13 => #v[12, 12, 12, 12, 0, 12, 24, 12, 24, 12]
  | 14 => #v[-12, -12, -24, -12, -24, -12, -12, 0, -12, -12]
  | 15 => #v[-6, -6, 0, -12, -12, -6, 6, -6, -12, -12]
  | 16 => #v[-6, 0, -6, -12, -12, -6, 0, -6, 0, -18]
  | 17 => #v[-12, -18, -12, 0, -6, -6, 0, 0, -6, -6]
  | 18 => #v[-54, 0, 0, 6, -6, -6, -6, -6, 6, 0]
  | 19 => #v[-6, 6, -12, 6, -6, 0, 6, 0, 0, 6]
  | _ => zeroZ

def KZ (k : Fin 1) : VecZ :=
  match k.val with
  | 0 => #v[0, 66, 66, 0, 0, 0, 66, 66, 66, 0]
  | _ => zeroZ

def YZ (k : Fin 1) : VecZ :=
  match k.val with
  | 0 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  | _ => zeroZ

def xaEntryZ : VecZ := sumFin (fun k => mulZ (XZ k) (AZ k))
def kyEntryZ : VecZ := sumFin (fun k => mulZ (KZ k) (YZ k))
def entryZ : VecZ := addZ xaEntryZ kyEntryZ

theorem entryZ_eq : entryZ = zeroZ :=
  eq_of_eqZ (by decide +kernel)

theorem scale_ne_zero : scale ≠ 0 := by
  decide

theorem XZ_scale_0 : toVec (XZ 0) = (scale : ℚ) • XCell3_0 :=
  toVec_eq_smul10 (XZ 0) scale XCell3_0
    (eq_smul_div (41) scale (41) (66) (by decide) (by decide))
    (eq_smul_div (40) scale (20) (33) (by decide) (by decide))
    (eq_smul_div (112) scale (56) (33) (by decide) (by decide))
    (eq_smul_div (50) scale (25) (33) (by decide) (by decide))
    (eq_smul_div (35) scale (35) (66) (by decide) (by decide))
    (eq_smul_div (92) scale (46) (33) (by decide) (by decide))
    (eq_smul_div (63) scale (21) (22) (by decide) (by decide))
    (eq_smul_div (53) scale (53) (66) (by decide) (by decide))
    (eq_smul_div (29) scale (29) (66) (by decide) (by decide))
    (eq_smul_div (123) scale (41) (22) (by decide) (by decide))

theorem XZ_scale_1 : toVec (XZ 1) = (scale : ℚ) • XCell3_1 :=
  toVec_eq_smul10 (XZ 1) scale XCell3_1
    (eq_smul_div (-7) scale (-7) (66) (by decide) (by decide))
    (eq_smul_div (-28) scale (-14) (33) (by decide) (by decide))
    (eq_smul_div (10) scale (5) (33) (by decide) (by decide))
    (eq_smul_div (29) scale (29) (66) (by decide) (by decide))
    (eq_smul_div (-3) scale (-1) (22) (by decide) (by decide))
    (eq_smul_div (-18) scale (-3) (11) (by decide) (by decide))
    (eq_smul_div (-3) scale (-1) (22) (by decide) (by decide))
    (eq_smul_div (10) scale (5) (33) (by decide) (by decide))
    (eq_smul_div (-2) scale (-1) (33) (by decide) (by decide))
    (eq_smul_div (45) scale (15) (22) (by decide) (by decide))

theorem XZ_scale_2 : toVec (XZ 2) = (scale : ℚ) • XCell3_2 :=
  toVec_eq_smul10 (XZ 2) scale XCell3_2
    (eq_smul_div (-130) scale (-65) (33) (by decide) (by decide))
    (eq_smul_div (14) scale (7) (33) (by decide) (by decide))
    (eq_smul_div (-151) scale (-151) (66) (by decide) (by decide))
    (eq_smul_div (-73) scale (-73) (66) (by decide) (by decide))
    (eq_smul_div (-55) scale (-5) (6) (by decide) (by decide))
    (eq_smul_div (-110) scale (-5) (3) (by decide) (by decide))
    (eq_smul_div (-37) scale (-37) (66) (by decide) (by decide))
    (eq_smul_div (-135) scale (-45) (22) (by decide) (by decide))
    (eq_smul_div (19) scale (19) (66) (by decide) (by decide))
    (eq_smul_div (-222) scale (-37) (11) (by decide) (by decide))

theorem XZ_scale_3 : toVec (XZ 3) = (scale : ℚ) • XCell3_3 :=
  toVec_eq_smul10 (XZ 3) scale XCell3_3
    (eq_smul_div (171) scale (57) (22) (by decide) (by decide))
    (eq_smul_div (16) scale (8) (33) (by decide) (by decide))
    (eq_smul_div (5) scale (5) (66) (by decide) (by decide))
    (eq_smul_div (18) scale (3) (11) (by decide) (by decide))
    (eq_smul_div (25) scale (25) (66) (by decide) (by decide))
    (eq_smul_div (84) scale (14) (11) (by decide) (by decide))
    (eq_smul_div (-13) scale (-13) (66) (by decide) (by decide))
    (eq_smul_div (116) scale (58) (33) (by decide) (by decide))
    (eq_smul_div (-33) scale (-1) (2) (by decide) (by decide))
    (eq_smul_div (73) scale (73) (66) (by decide) (by decide))

theorem XZ_scale_4 : toVec (XZ 4) = (scale : ℚ) • XCell3_4 :=
  toVec_eq_smul10 (XZ 4) scale XCell3_4
    (eq_smul_div (7) scale (7) (66) (by decide) (by decide))
    (eq_smul_div (32) scale (16) (33) (by decide) (by decide))
    (eq_smul_div (17) scale (17) (66) (by decide) (by decide))
    (eq_smul_div (-25) scale (-25) (66) (by decide) (by decide))
    (eq_smul_div (-25) scale (-25) (66) (by decide) (by decide))
    (eq_smul_div (6) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (39) scale (13) (22) (by decide) (by decide))
    (eq_smul_div (1) scale (1) (66) (by decide) (by decide))
    (eq_smul_div (2) scale (1) (33) (by decide) (by decide))
    (eq_smul_div (-10) scale (-5) (33) (by decide) (by decide))

theorem XZ_scale_5 : toVec (XZ 5) = (scale : ℚ) • XCell3_5 :=
  toVec_eq_smul10 (XZ 5) scale XCell3_5
    (eq_smul_div (-178) scale (-89) (33) (by decide) (by decide))
    (eq_smul_int (-66) scale (-1) (by decide))
    (eq_smul_div (-88) scale (-4) (3) (by decide) (by decide))
    (eq_smul_div (-100) scale (-50) (33) (by decide) (by decide))
    (eq_smul_int (-132) scale (-2) (by decide))
    (eq_smul_div (-118) scale (-59) (33) (by decide) (by decide))
    (eq_smul_div (-22) scale (-1) (3) (by decide) (by decide))
    (eq_smul_div (-184) scale (-92) (33) (by decide) (by decide))
    (eq_smul_div (-60) scale (-10) (11) (by decide) (by decide))
    (eq_smul_div (-108) scale (-18) (11) (by decide) (by decide))

theorem XZ_scale_6 : toVec (XZ 6) = (scale : ℚ) • XCell3_6 :=
  toVec_eq_smul10 (XZ 6) scale XCell3_6
    (eq_smul_div (24) scale (4) (11) (by decide) (by decide))
    (eq_smul_div (-28) scale (-14) (33) (by decide) (by decide))
    (eq_smul_div (16) scale (8) (33) (by decide) (by decide))
    (eq_smul_div (-36) scale (-6) (11) (by decide) (by decide))
    (eq_smul_div (-2) scale (-1) (33) (by decide) (by decide))
    (eq_smul_div (48) scale (8) (11) (by decide) (by decide))
    (eq_smul_div (2) scale (1) (33) (by decide) (by decide))
    (eq_smul_div (-18) scale (-3) (11) (by decide) (by decide))
    (eq_smul_div (-62) scale (-31) (33) (by decide) (by decide))
    (eq_smul_div (78) scale (13) (11) (by decide) (by decide))

theorem XZ_scale_7 : toVec (XZ 7) = (scale : ℚ) • XCell3_7 :=
  toVec_eq_smul10 (XZ 7) scale XCell3_7
    (eq_smul_div (-226) scale (-113) (33) (by decide) (by decide))
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-154) scale (-7) (3) (by decide) (by decide))
    (eq_smul_div (-134) scale (-67) (33) (by decide) (by decide))
    (eq_smul_div (-112) scale (-56) (33) (by decide) (by decide))
    (eq_smul_div (-126) scale (-21) (11) (by decide) (by decide))
    (eq_smul_div (-4) scale (-2) (33) (by decide) (by decide))
    (eq_smul_div (-250) scale (-125) (33) (by decide) (by decide))
    (eq_smul_div (-4) scale (-2) (33) (by decide) (by decide))
    (eq_smul_div (-194) scale (-97) (33) (by decide) (by decide))

theorem XZ_scale_8 : toVec (XZ 8) = (scale : ℚ) • XCell3_8 :=
  toVec_eq_smul10 (XZ 8) scale XCell3_8
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

theorem XZ_scale_9 : toVec (XZ 9) = (scale : ℚ) • XCell3_9 :=
  toVec_eq_smul10 (XZ 9) scale XCell3_9
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

theorem XZ_scale_10 : toVec (XZ 10) = (scale : ℚ) • XCell3_10 :=
  toVec_eq_smul10 (XZ 10) scale XCell3_10
    (eq_smul_div (22) scale (1) (3) (by decide) (by decide))
    (eq_smul_div (55) scale (5) (6) (by decide) (by decide))
    (eq_smul_int (66) scale (1) (by decide))
    (eq_smul_div (44) scale (2) (3) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (44) scale (2) (3) (by decide) (by decide))
    (eq_smul_div (55) scale (5) (6) (by decide) (by decide))
    (eq_smul_int (66) scale (1) (by decide))
    (eq_smul_div (11) scale (1) (6) (by decide) (by decide))

theorem XZ_scale_11 : toVec (XZ 11) = (scale : ℚ) • XCell3_11 :=
  toVec_eq_smul10 (XZ 11) scale XCell3_11
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

theorem XZ_scale_12 : toVec (XZ 12) = (scale : ℚ) • XCell3_12 :=
  toVec_eq_smul10 (XZ 12) scale XCell3_12
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

theorem XZ_scale_13 : toVec (XZ 13) = (scale : ℚ) • XCell3_13 :=
  toVec_eq_smul10 (XZ 13) scale XCell3_13
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

theorem XZ_scale_14 : toVec (XZ 14) = (scale : ℚ) • XCell3_14 :=
  toVec_eq_smul10 (XZ 14) scale XCell3_14
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

theorem XZ_scale_15 : toVec (XZ 15) = (scale : ℚ) • XCell3_15 :=
  toVec_eq_smul10 (XZ 15) scale XCell3_15
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

theorem XZ_scale_16 : toVec (XZ 16) = (scale : ℚ) • XCell3_16 :=
  toVec_eq_smul10 (XZ 16) scale XCell3_16
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

theorem XZ_scale_17 : toVec (XZ 17) = (scale : ℚ) • XCell3_17 :=
  toVec_eq_smul10 (XZ 17) scale XCell3_17
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

theorem XZ_scale_18 : toVec (XZ 18) = (scale : ℚ) • XCell3_18 :=
  toVec_eq_smul10 (XZ 18) scale XCell3_18
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

theorem XZ_scale_19 : toVec (XZ 19) = (scale : ℚ) • XCell3_19 :=
  toVec_eq_smul10 (XZ 19) scale XCell3_19
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
    toVec (XZ k) = (scale : ℚ) • XVec (3 : Fin 10) k :=
  forall_fin20 (P := fun k => toVec (XZ k) = (scale : ℚ) • XVec (3 : Fin 10) k)
    XZ_scale_0 XZ_scale_1 XZ_scale_2 XZ_scale_3 XZ_scale_4 XZ_scale_5 XZ_scale_6 XZ_scale_7 XZ_scale_8 XZ_scale_9 XZ_scale_10 XZ_scale_11 XZ_scale_12 XZ_scale_13 XZ_scale_14 XZ_scale_15 XZ_scale_16 XZ_scale_17 XZ_scale_18 XZ_scale_19 k

theorem AZ_scale_0 : toVec (AZ 0) = (scale : ℚ) • ACell0_8 :=
  toVec_eq_smul10 (AZ 0) scale ACell0_8
    (eq_smul_zero scale)
    (eq_smul_div (-12) scale (-2) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-12) scale (-2) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))

theorem AZ_scale_1 : toVec (AZ 1) = (scale : ℚ) • ACell1_8 :=
  toVec_eq_smul10 (AZ 1) scale ACell1_8
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (-12) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (-12) scale (-2) (11) (by decide) (by decide))

theorem AZ_scale_2 : toVec (AZ 2) = (scale : ℚ) • ACell2_8 :=
  toVec_eq_smul10 (AZ 2) scale ACell2_8
    (eq_smul_zero scale)
    (eq_smul_div (-12) scale (-2) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-12) scale (-2) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)

theorem AZ_scale_3 : toVec (AZ 3) = (scale : ℚ) • ACell3_8 :=
  toVec_eq_smul10 (AZ 3) scale ACell3_8
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (24) scale (4) (11) (by decide) (by decide))
    (eq_smul_div (24) scale (4) (11) (by decide) (by decide))

theorem AZ_scale_4 : toVec (AZ 4) = (scale : ℚ) • ACell4_8 :=
  toVec_eq_smul10 (AZ 4) scale ACell4_8
    (eq_smul_div (-12) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-12) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-24) scale (-4) (11) (by decide) (by decide))
    (eq_smul_div (-24) scale (-4) (11) (by decide) (by decide))
    (eq_smul_div (-12) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-12) scale (-2) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-12) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-12) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-12) scale (-2) (11) (by decide) (by decide))

theorem AZ_scale_5 : toVec (AZ 5) = (scale : ℚ) • ACell5_8 :=
  toVec_eq_smul10 (AZ 5) scale ACell5_8
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (6) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (6) scale (1) (11) (by decide) (by decide))

theorem AZ_scale_6 : toVec (AZ 6) = (scale : ℚ) • ACell6_8 :=
  toVec_eq_smul10 (AZ 6) scale ACell6_8
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (-12) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-18) scale (-3) (11) (by decide) (by decide))
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-12) scale (-2) (11) (by decide) (by decide))

theorem AZ_scale_7 : toVec (AZ 7) = (scale : ℚ) • ACell7_8 :=
  toVec_eq_smul10 (AZ 7) scale ACell7_8
    (eq_smul_zero scale)
    (eq_smul_div (6) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (6) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (6) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (6) scale (1) (11) (by decide) (by decide))

theorem AZ_scale_8 : toVec (AZ 8) = (scale : ℚ) • ACell8_8 :=
  toVec_eq_smul10 (AZ 8) scale ACell8_8
    (eq_smul_div (60) scale (10) (11) (by decide) (by decide))
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (6) scale (1) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (6) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))

theorem AZ_scale_9 : toVec (AZ 9) = (scale : ℚ) • ACell9_8 :=
  toVec_eq_smul10 (AZ 9) scale ACell9_8
    (eq_smul_div (-12) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-18) scale (-3) (11) (by decide) (by decide))
    (eq_smul_div (-12) scale (-2) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))

theorem AZ_scale_10 : toVec (AZ 10) = (scale : ℚ) • ACell10_8 :=
  toVec_eq_smul10 (AZ 10) scale ACell10_8
    (eq_smul_zero scale)
    (eq_smul_div (-12) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (-12) scale (-2) (11) (by decide) (by decide))
    (eq_smul_zero scale)

theorem AZ_scale_11 : toVec (AZ 11) = (scale : ℚ) • ACell11_8 :=
  toVec_eq_smul10 (AZ 11) scale ACell11_8
    (eq_smul_zero scale)
    (eq_smul_div (-24) scale (-4) (11) (by decide) (by decide))
    (eq_smul_div (-12) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-12) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-12) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-12) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-12) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-12) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-12) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-24) scale (-4) (11) (by decide) (by decide))

theorem AZ_scale_12 : toVec (AZ 12) = (scale : ℚ) • ACell12_8 :=
  toVec_eq_smul10 (AZ 12) scale ACell12_8
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (24) scale (4) (11) (by decide) (by decide))
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (24) scale (4) (11) (by decide) (by decide))
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_zero scale)

theorem AZ_scale_13 : toVec (AZ 13) = (scale : ℚ) • ACell13_8 :=
  toVec_eq_smul10 (AZ 13) scale ACell13_8
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (24) scale (4) (11) (by decide) (by decide))
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (24) scale (4) (11) (by decide) (by decide))
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))

theorem AZ_scale_14 : toVec (AZ 14) = (scale : ℚ) • ACell14_8 :=
  toVec_eq_smul10 (AZ 14) scale ACell14_8
    (eq_smul_div (-12) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-12) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-24) scale (-4) (11) (by decide) (by decide))
    (eq_smul_div (-12) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-24) scale (-4) (11) (by decide) (by decide))
    (eq_smul_div (-12) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-12) scale (-2) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-12) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-12) scale (-2) (11) (by decide) (by decide))

theorem AZ_scale_15 : toVec (AZ 15) = (scale : ℚ) • ACell15_8 :=
  toVec_eq_smul10 (AZ 15) scale ACell15_8
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-12) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-12) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (6) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-12) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-12) scale (-2) (11) (by decide) (by decide))

theorem AZ_scale_16 : toVec (AZ 16) = (scale : ℚ) • ACell16_8 :=
  toVec_eq_smul10 (AZ 16) scale ACell16_8
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-12) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-12) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-18) scale (-3) (11) (by decide) (by decide))

theorem AZ_scale_17 : toVec (AZ 17) = (scale : ℚ) • ACell17_8 :=
  toVec_eq_smul10 (AZ 17) scale ACell17_8
    (eq_smul_div (-12) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-18) scale (-3) (11) (by decide) (by decide))
    (eq_smul_div (-12) scale (-2) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))

theorem AZ_scale_18 : toVec (AZ 18) = (scale : ℚ) • ACell18_8 :=
  toVec_eq_smul10 (AZ 18) scale ACell18_8
    (eq_smul_div (-54) scale (-9) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (6) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (6) scale (1) (11) (by decide) (by decide))
    (eq_smul_zero scale)

theorem AZ_scale_19 : toVec (AZ 19) = (scale : ℚ) • ACell19_8 :=
  toVec_eq_smul10 (AZ 19) scale ACell19_8
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (6) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (-12) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (6) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (6) scale (1) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (6) scale (1) (11) (by decide) (by decide))

theorem AZ_scale (k : Fin 20) :
    toVec (AZ k) = (scale : ℚ) • AVec k (8 : Fin 10) :=
  forall_fin20 (P := fun k => toVec (AZ k) = (scale : ℚ) • AVec k (8 : Fin 10))
    AZ_scale_0 AZ_scale_1 AZ_scale_2 AZ_scale_3 AZ_scale_4 AZ_scale_5 AZ_scale_6 AZ_scale_7 AZ_scale_8 AZ_scale_9 AZ_scale_10 AZ_scale_11 AZ_scale_12 AZ_scale_13 AZ_scale_14 AZ_scale_15 AZ_scale_16 AZ_scale_17 AZ_scale_18 AZ_scale_19 k

theorem KZ_scale_0 : toVec (KZ 0) = (scale : ℚ) • KCell3_0 :=
  toVec_eq_smul10 (KZ 0) scale KCell3_0
    (eq_smul_zero scale)
    (eq_smul_int (66) scale (1) (by decide))
    (eq_smul_int (66) scale (1) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_int (66) scale (1) (by decide))
    (eq_smul_int (66) scale (1) (by decide))
    (eq_smul_int (66) scale (1) (by decide))
    (eq_smul_zero scale)

theorem KZ_scale (k : Fin 1) :
    toVec (KZ k) = (scale : ℚ) • KVec (3 : Fin 10) k :=
  forall_fin1 (P := fun k => toVec (KZ k) = (scale : ℚ) • KVec (3 : Fin 10) k)
    KZ_scale_0 k

theorem YZ_scale_0 : toVec (YZ 0) = (scale : ℚ) • YCell0_8 :=
  toVec_eq_smul10 (YZ 0) scale YCell0_8
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

theorem YZ_scale (k : Fin 1) :
    toVec (YZ k) = (scale : ℚ) • YVec k (8 : Fin 10) :=
  forall_fin1 (P := fun k => toVec (YZ k) = (scale : ℚ) • YVec k (8 : Fin 10))
    YZ_scale_0 k

theorem entry_eq :
    (matrixMul XVec AVec + matrixMul KVec YVec)
        (3 : Fin 10) (8 : Fin 10) = ![0, 0, 0, 0, 0, 0, 0, 0, 0, 0] := by
  change (∑ k : Fin 20, mul (XVec (3 : Fin 10) k)
      (AVec k (8 : Fin 10))) +
    (∑ k : Fin 1, mul (KVec (3 : Fin 10) k)
      (YVec k (8 : Fin 10))) = _
  refine add_sum_mul_eq_of_scaled scale scale_ne_zero
    (fun k => XVec (3 : Fin 10) k)
    (fun k => AVec k (8 : Fin 10))
    (fun k => KVec (3 : Fin 10) k)
    (fun k => YVec k (8 : Fin 10))
    XZ AZ KZ YZ XZ_scale AZ_scale KZ_scale YZ_scale entryZ rfl _ ?_
  rw [entryZ_eq, toVec_zeroZ_smul, vec_zero_eq]

theorem entry_eq_matrixOne :
    (matrixMul XVec AVec + matrixMul KVec YVec)
        (3 : Fin 10) (8 : Fin 10) =
      matrixOne (Fin 10) (3 : Fin 10) (8 : Fin 10) :=
  entry_eq.trans (matrixOne_off10 (3 : Fin 10) (8 : Fin 10) (by decide)).symm

end V14Formalization.D12PieceAPSplitEntry3_8


namespace V14Formalization.D12PieceAPSplitEntry3_9
open D12CyclotomicVec D12CyclotomicVecZ D12PieceAPData
def payloadSha256 : String := "76c6196f29afe1a8398af99502447f48ebeed4bcb3805fc5dbec693940bc04b0"

def scale : ℤ := 66

def XZ (k : Fin 20) : VecZ :=
  match k.val with
  | 0 => #v[41, 40, 112, 50, 35, 92, 63, 53, 29, 123]
  | 1 => #v[-7, -28, 10, 29, -3, -18, -3, 10, -2, 45]
  | 2 => #v[-130, 14, -151, -73, -55, -110, -37, -135, 19, -222]
  | 3 => #v[171, 16, 5, 18, 25, 84, -13, 116, -33, 73]
  | 4 => #v[7, 32, 17, -25, -25, 6, 39, 1, 2, -10]
  | 5 => #v[-178, -66, -88, -100, -132, -118, -22, -184, -60, -108]
  | 6 => #v[24, -28, 16, -36, -2, 48, 2, -18, -62, 78]
  | 7 => #v[-226, -6, -154, -134, -112, -126, -4, -250, -4, -194]
  | 8 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  | 9 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  | 10 => #v[22, 55, 66, 44, 0, 0, 44, 55, 66, 11]
  | 11 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
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
  | 0 => #v[0, 0, 12, 0, -12, 0, -12, 0, 12, 0]
  | 1 => #v[0, -12, 0, 0, 0, -12, 0, 0, 12, 12]
  | 2 => #v[12, 12, 12, 12, 0, 24, 12, 12, 12, 24]
  | 3 => #v[12, 12, 0, 12, 12, 24, 12, 24, 12, 12]
  | 4 => #v[0, 0, 0, 0, 12, -12, -12, 12, 0, 0]
  | 5 => #v[18, 12, 18, 12, 6, 6, 12, 18, 12, 18]
  | 6 => #v[12, 6, 0, 6, 6, 0, 6, 12, 0, 18]
  | 7 => #v[0, 12, 6, 6, 12, 0, 0, 6, 18, 6]
  | 8 => #v[-12, -18, -12, 0, -6, -6, 0, 0, -6, -6]
  | 9 => #v[66, 12, 6, 6, 18, 6, 6, 12, 0, 0]
  | 10 => #v[12, 12, 24, 24, 12, 12, 0, 12, 12, 12]
  | 11 => #v[12, 12, 24, 12, 24, 12, 12, 0, 12, 12]
  | 12 => #v[0, 0, 0, 0, 0, 0, 12, -12, -12, 12]
  | 13 => #v[0, 0, -12, 12, 0, 0, 0, 12, -12, 0]
  | 14 => #v[-12, 0, -12, 0, 12, 0, 0, 0, 0, 12]
  | 15 => #v[-6, -6, 0, -12, -18, -12, 0, -6, -6, 0]
  | 16 => #v[12, 6, 6, 12, 0, 0, 6, 18, 6, 0]
  | 17 => #v[-12, -12, -6, -18, -18, -18, -18, -6, -12, -12]
  | 18 => #v[-12, -6, 0, -6, -6, 0, -6, -12, 0, -18]
  | 19 => #v[-48, 0, 6, 0, 6, 12, 12, 6, 0, 6]
  | _ => zeroZ

def KZ (k : Fin 1) : VecZ :=
  match k.val with
  | 0 => #v[0, 66, 66, 0, 0, 0, 66, 66, 66, 0]
  | _ => zeroZ

def YZ (k : Fin 1) : VecZ :=
  match k.val with
  | 0 => #v[-88, -44, 0, 0, -88, 0, 0, -44, -88, -44]
  | _ => zeroZ

def xaEntryZ : VecZ := sumFin (fun k => mulZ (XZ k) (AZ k))
def kyEntryZ : VecZ := sumFin (fun k => mulZ (KZ k) (YZ k))
def entryZ : VecZ := addZ xaEntryZ kyEntryZ

theorem entryZ_eq : entryZ = zeroZ :=
  eq_of_eqZ (by decide +kernel)

theorem scale_ne_zero : scale ≠ 0 := by
  decide

theorem XZ_scale_0 : toVec (XZ 0) = (scale : ℚ) • XCell3_0 :=
  toVec_eq_smul10 (XZ 0) scale XCell3_0
    (eq_smul_div (41) scale (41) (66) (by decide) (by decide))
    (eq_smul_div (40) scale (20) (33) (by decide) (by decide))
    (eq_smul_div (112) scale (56) (33) (by decide) (by decide))
    (eq_smul_div (50) scale (25) (33) (by decide) (by decide))
    (eq_smul_div (35) scale (35) (66) (by decide) (by decide))
    (eq_smul_div (92) scale (46) (33) (by decide) (by decide))
    (eq_smul_div (63) scale (21) (22) (by decide) (by decide))
    (eq_smul_div (53) scale (53) (66) (by decide) (by decide))
    (eq_smul_div (29) scale (29) (66) (by decide) (by decide))
    (eq_smul_div (123) scale (41) (22) (by decide) (by decide))

theorem XZ_scale_1 : toVec (XZ 1) = (scale : ℚ) • XCell3_1 :=
  toVec_eq_smul10 (XZ 1) scale XCell3_1
    (eq_smul_div (-7) scale (-7) (66) (by decide) (by decide))
    (eq_smul_div (-28) scale (-14) (33) (by decide) (by decide))
    (eq_smul_div (10) scale (5) (33) (by decide) (by decide))
    (eq_smul_div (29) scale (29) (66) (by decide) (by decide))
    (eq_smul_div (-3) scale (-1) (22) (by decide) (by decide))
    (eq_smul_div (-18) scale (-3) (11) (by decide) (by decide))
    (eq_smul_div (-3) scale (-1) (22) (by decide) (by decide))
    (eq_smul_div (10) scale (5) (33) (by decide) (by decide))
    (eq_smul_div (-2) scale (-1) (33) (by decide) (by decide))
    (eq_smul_div (45) scale (15) (22) (by decide) (by decide))

theorem XZ_scale_2 : toVec (XZ 2) = (scale : ℚ) • XCell3_2 :=
  toVec_eq_smul10 (XZ 2) scale XCell3_2
    (eq_smul_div (-130) scale (-65) (33) (by decide) (by decide))
    (eq_smul_div (14) scale (7) (33) (by decide) (by decide))
    (eq_smul_div (-151) scale (-151) (66) (by decide) (by decide))
    (eq_smul_div (-73) scale (-73) (66) (by decide) (by decide))
    (eq_smul_div (-55) scale (-5) (6) (by decide) (by decide))
    (eq_smul_div (-110) scale (-5) (3) (by decide) (by decide))
    (eq_smul_div (-37) scale (-37) (66) (by decide) (by decide))
    (eq_smul_div (-135) scale (-45) (22) (by decide) (by decide))
    (eq_smul_div (19) scale (19) (66) (by decide) (by decide))
    (eq_smul_div (-222) scale (-37) (11) (by decide) (by decide))

theorem XZ_scale_3 : toVec (XZ 3) = (scale : ℚ) • XCell3_3 :=
  toVec_eq_smul10 (XZ 3) scale XCell3_3
    (eq_smul_div (171) scale (57) (22) (by decide) (by decide))
    (eq_smul_div (16) scale (8) (33) (by decide) (by decide))
    (eq_smul_div (5) scale (5) (66) (by decide) (by decide))
    (eq_smul_div (18) scale (3) (11) (by decide) (by decide))
    (eq_smul_div (25) scale (25) (66) (by decide) (by decide))
    (eq_smul_div (84) scale (14) (11) (by decide) (by decide))
    (eq_smul_div (-13) scale (-13) (66) (by decide) (by decide))
    (eq_smul_div (116) scale (58) (33) (by decide) (by decide))
    (eq_smul_div (-33) scale (-1) (2) (by decide) (by decide))
    (eq_smul_div (73) scale (73) (66) (by decide) (by decide))

theorem XZ_scale_4 : toVec (XZ 4) = (scale : ℚ) • XCell3_4 :=
  toVec_eq_smul10 (XZ 4) scale XCell3_4
    (eq_smul_div (7) scale (7) (66) (by decide) (by decide))
    (eq_smul_div (32) scale (16) (33) (by decide) (by decide))
    (eq_smul_div (17) scale (17) (66) (by decide) (by decide))
    (eq_smul_div (-25) scale (-25) (66) (by decide) (by decide))
    (eq_smul_div (-25) scale (-25) (66) (by decide) (by decide))
    (eq_smul_div (6) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (39) scale (13) (22) (by decide) (by decide))
    (eq_smul_div (1) scale (1) (66) (by decide) (by decide))
    (eq_smul_div (2) scale (1) (33) (by decide) (by decide))
    (eq_smul_div (-10) scale (-5) (33) (by decide) (by decide))

theorem XZ_scale_5 : toVec (XZ 5) = (scale : ℚ) • XCell3_5 :=
  toVec_eq_smul10 (XZ 5) scale XCell3_5
    (eq_smul_div (-178) scale (-89) (33) (by decide) (by decide))
    (eq_smul_int (-66) scale (-1) (by decide))
    (eq_smul_div (-88) scale (-4) (3) (by decide) (by decide))
    (eq_smul_div (-100) scale (-50) (33) (by decide) (by decide))
    (eq_smul_int (-132) scale (-2) (by decide))
    (eq_smul_div (-118) scale (-59) (33) (by decide) (by decide))
    (eq_smul_div (-22) scale (-1) (3) (by decide) (by decide))
    (eq_smul_div (-184) scale (-92) (33) (by decide) (by decide))
    (eq_smul_div (-60) scale (-10) (11) (by decide) (by decide))
    (eq_smul_div (-108) scale (-18) (11) (by decide) (by decide))

theorem XZ_scale_6 : toVec (XZ 6) = (scale : ℚ) • XCell3_6 :=
  toVec_eq_smul10 (XZ 6) scale XCell3_6
    (eq_smul_div (24) scale (4) (11) (by decide) (by decide))
    (eq_smul_div (-28) scale (-14) (33) (by decide) (by decide))
    (eq_smul_div (16) scale (8) (33) (by decide) (by decide))
    (eq_smul_div (-36) scale (-6) (11) (by decide) (by decide))
    (eq_smul_div (-2) scale (-1) (33) (by decide) (by decide))
    (eq_smul_div (48) scale (8) (11) (by decide) (by decide))
    (eq_smul_div (2) scale (1) (33) (by decide) (by decide))
    (eq_smul_div (-18) scale (-3) (11) (by decide) (by decide))
    (eq_smul_div (-62) scale (-31) (33) (by decide) (by decide))
    (eq_smul_div (78) scale (13) (11) (by decide) (by decide))

theorem XZ_scale_7 : toVec (XZ 7) = (scale : ℚ) • XCell3_7 :=
  toVec_eq_smul10 (XZ 7) scale XCell3_7
    (eq_smul_div (-226) scale (-113) (33) (by decide) (by decide))
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-154) scale (-7) (3) (by decide) (by decide))
    (eq_smul_div (-134) scale (-67) (33) (by decide) (by decide))
    (eq_smul_div (-112) scale (-56) (33) (by decide) (by decide))
    (eq_smul_div (-126) scale (-21) (11) (by decide) (by decide))
    (eq_smul_div (-4) scale (-2) (33) (by decide) (by decide))
    (eq_smul_div (-250) scale (-125) (33) (by decide) (by decide))
    (eq_smul_div (-4) scale (-2) (33) (by decide) (by decide))
    (eq_smul_div (-194) scale (-97) (33) (by decide) (by decide))

theorem XZ_scale_8 : toVec (XZ 8) = (scale : ℚ) • XCell3_8 :=
  toVec_eq_smul10 (XZ 8) scale XCell3_8
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

theorem XZ_scale_9 : toVec (XZ 9) = (scale : ℚ) • XCell3_9 :=
  toVec_eq_smul10 (XZ 9) scale XCell3_9
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

theorem XZ_scale_10 : toVec (XZ 10) = (scale : ℚ) • XCell3_10 :=
  toVec_eq_smul10 (XZ 10) scale XCell3_10
    (eq_smul_div (22) scale (1) (3) (by decide) (by decide))
    (eq_smul_div (55) scale (5) (6) (by decide) (by decide))
    (eq_smul_int (66) scale (1) (by decide))
    (eq_smul_div (44) scale (2) (3) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (44) scale (2) (3) (by decide) (by decide))
    (eq_smul_div (55) scale (5) (6) (by decide) (by decide))
    (eq_smul_int (66) scale (1) (by decide))
    (eq_smul_div (11) scale (1) (6) (by decide) (by decide))

theorem XZ_scale_11 : toVec (XZ 11) = (scale : ℚ) • XCell3_11 :=
  toVec_eq_smul10 (XZ 11) scale XCell3_11
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

theorem XZ_scale_12 : toVec (XZ 12) = (scale : ℚ) • XCell3_12 :=
  toVec_eq_smul10 (XZ 12) scale XCell3_12
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

theorem XZ_scale_13 : toVec (XZ 13) = (scale : ℚ) • XCell3_13 :=
  toVec_eq_smul10 (XZ 13) scale XCell3_13
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

theorem XZ_scale_14 : toVec (XZ 14) = (scale : ℚ) • XCell3_14 :=
  toVec_eq_smul10 (XZ 14) scale XCell3_14
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

theorem XZ_scale_15 : toVec (XZ 15) = (scale : ℚ) • XCell3_15 :=
  toVec_eq_smul10 (XZ 15) scale XCell3_15
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

theorem XZ_scale_16 : toVec (XZ 16) = (scale : ℚ) • XCell3_16 :=
  toVec_eq_smul10 (XZ 16) scale XCell3_16
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

theorem XZ_scale_17 : toVec (XZ 17) = (scale : ℚ) • XCell3_17 :=
  toVec_eq_smul10 (XZ 17) scale XCell3_17
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

theorem XZ_scale_18 : toVec (XZ 18) = (scale : ℚ) • XCell3_18 :=
  toVec_eq_smul10 (XZ 18) scale XCell3_18
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

theorem XZ_scale_19 : toVec (XZ 19) = (scale : ℚ) • XCell3_19 :=
  toVec_eq_smul10 (XZ 19) scale XCell3_19
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
    toVec (XZ k) = (scale : ℚ) • XVec (3 : Fin 10) k :=
  forall_fin20 (P := fun k => toVec (XZ k) = (scale : ℚ) • XVec (3 : Fin 10) k)
    XZ_scale_0 XZ_scale_1 XZ_scale_2 XZ_scale_3 XZ_scale_4 XZ_scale_5 XZ_scale_6 XZ_scale_7 XZ_scale_8 XZ_scale_9 XZ_scale_10 XZ_scale_11 XZ_scale_12 XZ_scale_13 XZ_scale_14 XZ_scale_15 XZ_scale_16 XZ_scale_17 XZ_scale_18 XZ_scale_19 k

theorem AZ_scale_0 : toVec (AZ 0) = (scale : ℚ) • ACell0_9 :=
  toVec_eq_smul10 (AZ 0) scale ACell0_9
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-12) scale (-2) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-12) scale (-2) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_zero scale)

theorem AZ_scale_1 : toVec (AZ 1) = (scale : ℚ) • ACell1_9 :=
  toVec_eq_smul10 (AZ 1) scale ACell1_9
    (eq_smul_zero scale)
    (eq_smul_div (-12) scale (-2) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (-12) scale (-2) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))

theorem AZ_scale_2 : toVec (AZ 2) = (scale : ℚ) • ACell2_9 :=
  toVec_eq_smul10 (AZ 2) scale ACell2_9
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (24) scale (4) (11) (by decide) (by decide))
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (24) scale (4) (11) (by decide) (by decide))

theorem AZ_scale_3 : toVec (AZ 3) = (scale : ℚ) • ACell3_9 :=
  toVec_eq_smul10 (AZ 3) scale ACell3_9
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (24) scale (4) (11) (by decide) (by decide))
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (24) scale (4) (11) (by decide) (by decide))
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))

theorem AZ_scale_4 : toVec (AZ 4) = (scale : ℚ) • ACell4_9 :=
  toVec_eq_smul10 (AZ 4) scale ACell4_9
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (-12) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-12) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)

theorem AZ_scale_5 : toVec (AZ 5) = (scale : ℚ) • ACell5_9 :=
  toVec_eq_smul10 (AZ 5) scale ACell5_9
    (eq_smul_div (18) scale (3) (11) (by decide) (by decide))
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (18) scale (3) (11) (by decide) (by decide))
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (6) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (6) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (18) scale (3) (11) (by decide) (by decide))
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (18) scale (3) (11) (by decide) (by decide))

theorem AZ_scale_6 : toVec (AZ 6) = (scale : ℚ) • ACell6_9 :=
  toVec_eq_smul10 (AZ 6) scale ACell6_9
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (6) scale (1) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (6) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (6) scale (1) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (6) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (18) scale (3) (11) (by decide) (by decide))

theorem AZ_scale_7 : toVec (AZ 7) = (scale : ℚ) • ACell7_9 :=
  toVec_eq_smul10 (AZ 7) scale ACell7_9
    (eq_smul_zero scale)
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (6) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (6) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (6) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (18) scale (3) (11) (by decide) (by decide))
    (eq_smul_div (6) scale (1) (11) (by decide) (by decide))

theorem AZ_scale_8 : toVec (AZ 8) = (scale : ℚ) • ACell8_9 :=
  toVec_eq_smul10 (AZ 8) scale ACell8_9
    (eq_smul_div (-12) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-18) scale (-3) (11) (by decide) (by decide))
    (eq_smul_div (-12) scale (-2) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))

theorem AZ_scale_9 : toVec (AZ 9) = (scale : ℚ) • ACell9_9 :=
  toVec_eq_smul10 (AZ 9) scale ACell9_9
    (eq_smul_int (66) scale (1) (by decide))
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (6) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (6) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (18) scale (3) (11) (by decide) (by decide))
    (eq_smul_div (6) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (6) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)

theorem AZ_scale_10 : toVec (AZ 10) = (scale : ℚ) • ACell10_9 :=
  toVec_eq_smul10 (AZ 10) scale ACell10_9
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (24) scale (4) (11) (by decide) (by decide))
    (eq_smul_div (24) scale (4) (11) (by decide) (by decide))
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))

theorem AZ_scale_11 : toVec (AZ 11) = (scale : ℚ) • ACell11_9 :=
  toVec_eq_smul10 (AZ 11) scale ACell11_9
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (24) scale (4) (11) (by decide) (by decide))
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (24) scale (4) (11) (by decide) (by decide))
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))

theorem AZ_scale_12 : toVec (AZ 12) = (scale : ℚ) • ACell12_9 :=
  toVec_eq_smul10 (AZ 12) scale ACell12_9
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (-12) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-12) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))

theorem AZ_scale_13 : toVec (AZ 13) = (scale : ℚ) • ACell13_9 :=
  toVec_eq_smul10 (AZ 13) scale ACell13_9
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (-12) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (-12) scale (-2) (11) (by decide) (by decide))
    (eq_smul_zero scale)

theorem AZ_scale_14 : toVec (AZ 14) = (scale : ℚ) • ACell14_9 :=
  toVec_eq_smul10 (AZ 14) scale ACell14_9
    (eq_smul_div (-12) scale (-2) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-12) scale (-2) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))

theorem AZ_scale_15 : toVec (AZ 15) = (scale : ℚ) • ACell15_9 :=
  toVec_eq_smul10 (AZ 15) scale ACell15_9
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-12) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-18) scale (-3) (11) (by decide) (by decide))
    (eq_smul_div (-12) scale (-2) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_zero scale)

theorem AZ_scale_16 : toVec (AZ 16) = (scale : ℚ) • ACell16_9 :=
  toVec_eq_smul10 (AZ 16) scale ACell16_9
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (6) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (6) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (6) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (18) scale (3) (11) (by decide) (by decide))
    (eq_smul_div (6) scale (1) (11) (by decide) (by decide))
    (eq_smul_zero scale)

theorem AZ_scale_17 : toVec (AZ 17) = (scale : ℚ) • ACell17_9 :=
  toVec_eq_smul10 (AZ 17) scale ACell17_9
    (eq_smul_div (-12) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-12) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-18) scale (-3) (11) (by decide) (by decide))
    (eq_smul_div (-18) scale (-3) (11) (by decide) (by decide))
    (eq_smul_div (-18) scale (-3) (11) (by decide) (by decide))
    (eq_smul_div (-18) scale (-3) (11) (by decide) (by decide))
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-12) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-12) scale (-2) (11) (by decide) (by decide))

theorem AZ_scale_18 : toVec (AZ 18) = (scale : ℚ) • ACell18_9 :=
  toVec_eq_smul10 (AZ 18) scale ACell18_9
    (eq_smul_div (-12) scale (-2) (11) (by decide) (by decide))
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-6) scale (-1) (11) (by decide) (by decide))
    (eq_smul_div (-12) scale (-2) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (-18) scale (-3) (11) (by decide) (by decide))

theorem AZ_scale_19 : toVec (AZ 19) = (scale : ℚ) • ACell19_9 :=
  toVec_eq_smul10 (AZ 19) scale ACell19_9
    (eq_smul_div (-48) scale (-8) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (6) scale (1) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (6) scale (1) (11) (by decide) (by decide))
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (12) scale (2) (11) (by decide) (by decide))
    (eq_smul_div (6) scale (1) (11) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_div (6) scale (1) (11) (by decide) (by decide))

theorem AZ_scale (k : Fin 20) :
    toVec (AZ k) = (scale : ℚ) • AVec k (9 : Fin 10) :=
  forall_fin20 (P := fun k => toVec (AZ k) = (scale : ℚ) • AVec k (9 : Fin 10))
    AZ_scale_0 AZ_scale_1 AZ_scale_2 AZ_scale_3 AZ_scale_4 AZ_scale_5 AZ_scale_6 AZ_scale_7 AZ_scale_8 AZ_scale_9 AZ_scale_10 AZ_scale_11 AZ_scale_12 AZ_scale_13 AZ_scale_14 AZ_scale_15 AZ_scale_16 AZ_scale_17 AZ_scale_18 AZ_scale_19 k

theorem KZ_scale_0 : toVec (KZ 0) = (scale : ℚ) • KCell3_0 :=
  toVec_eq_smul10 (KZ 0) scale KCell3_0
    (eq_smul_zero scale)
    (eq_smul_int (66) scale (1) (by decide))
    (eq_smul_int (66) scale (1) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_int (66) scale (1) (by decide))
    (eq_smul_int (66) scale (1) (by decide))
    (eq_smul_int (66) scale (1) (by decide))
    (eq_smul_zero scale)

theorem KZ_scale (k : Fin 1) :
    toVec (KZ k) = (scale : ℚ) • KVec (3 : Fin 10) k :=
  forall_fin1 (P := fun k => toVec (KZ k) = (scale : ℚ) • KVec (3 : Fin 10) k)
    KZ_scale_0 k

theorem YZ_scale_0 : toVec (YZ 0) = (scale : ℚ) • YCell0_9 :=
  toVec_eq_smul10 (YZ 0) scale YCell0_9
    (eq_smul_div (-88) scale (-4) (3) (by decide) (by decide))
    (eq_smul_div (-44) scale (-2) (3) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (-88) scale (-4) (3) (by decide) (by decide))
    (eq_smul_zero scale)
    (eq_smul_zero scale)
    (eq_smul_div (-44) scale (-2) (3) (by decide) (by decide))
    (eq_smul_div (-88) scale (-4) (3) (by decide) (by decide))
    (eq_smul_div (-44) scale (-2) (3) (by decide) (by decide))

theorem YZ_scale (k : Fin 1) :
    toVec (YZ k) = (scale : ℚ) • YVec k (9 : Fin 10) :=
  forall_fin1 (P := fun k => toVec (YZ k) = (scale : ℚ) • YVec k (9 : Fin 10))
    YZ_scale_0 k

theorem entry_eq :
    (matrixMul XVec AVec + matrixMul KVec YVec)
        (3 : Fin 10) (9 : Fin 10) = ![0, 0, 0, 0, 0, 0, 0, 0, 0, 0] := by
  change (∑ k : Fin 20, mul (XVec (3 : Fin 10) k)
      (AVec k (9 : Fin 10))) +
    (∑ k : Fin 1, mul (KVec (3 : Fin 10) k)
      (YVec k (9 : Fin 10))) = _
  refine add_sum_mul_eq_of_scaled scale scale_ne_zero
    (fun k => XVec (3 : Fin 10) k)
    (fun k => AVec k (9 : Fin 10))
    (fun k => KVec (3 : Fin 10) k)
    (fun k => YVec k (9 : Fin 10))
    XZ AZ KZ YZ XZ_scale AZ_scale KZ_scale YZ_scale entryZ rfl _ ?_
  rw [entryZ_eq, toVec_zeroZ_smul, vec_zero_eq]

theorem entry_eq_matrixOne :
    (matrixMul XVec AVec + matrixMul KVec YVec)
        (3 : Fin 10) (9 : Fin 10) =
      matrixOne (Fin 10) (3 : Fin 10) (9 : Fin 10) :=
  entry_eq.trans (matrixOne_off10 (3 : Fin 10) (9 : Fin 10) (by decide)).symm

end V14Formalization.D12PieceAPSplitEntry3_9


namespace V14Formalization.D12PieceAPSplitRow3
open D12CyclotomicVec D12PieceAPData

public theorem row_eq (j : Fin 10) :
    (matrixMul XVec AVec + matrixMul KVec YVec)
      (3 : Fin 10) j = matrixOne (Fin 10) (3 : Fin 10) j :=
  D12CyclotomicVecZ.forall_fin10
    (P := fun j => (matrixMul XVec AVec + matrixMul KVec YVec) (3 : Fin 10) j = matrixOne (Fin 10) (3 : Fin 10) j)
    D12PieceAPSplitEntry3_0.entry_eq_matrixOne
    D12PieceAPSplitEntry3_1.entry_eq_matrixOne
    D12PieceAPSplitEntry3_2.entry_eq_matrixOne
    D12PieceAPSplitEntry3_3.entry_eq_matrixOne
    D12PieceAPSplitEntry3_4.entry_eq_matrixOne
    D12PieceAPSplitEntry3_5.entry_eq_matrixOne
    D12PieceAPSplitEntry3_6.entry_eq_matrixOne
    D12PieceAPSplitEntry3_7.entry_eq_matrixOne
    D12PieceAPSplitEntry3_8.entry_eq_matrixOne
    D12PieceAPSplitEntry3_9.entry_eq_matrixOne
    j

end V14Formalization.D12PieceAPSplitRow3
