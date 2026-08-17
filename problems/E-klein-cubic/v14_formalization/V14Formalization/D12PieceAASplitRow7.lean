/- AA split identity row 7: entry certificates inlined. Auto-generated. -/
module

import all Init.Data.Vector.Basic
import all Init.Data.Array.DecidableEq
public import V14Formalization.D12PieceAAData
public import V14Formalization.D12CyclotomicVecZ

noncomputable section
open Matrix

namespace V14Formalization.D12PieceAASplitEntry7_0
open D12CyclotomicVec D12CyclotomicVecZ D12PieceAAData
def payloadSha256 : String := "76c6196f29afe1a8398af99502447f48ebeed4bcb3805fc5dbec693940bc04b0"

def scale : ℤ := 44

def XZ (k : Fin 20) : VecZ :=
  match k.val with
  | 0 => #v[18, -70, -4, 34, -33, -15, -19, 54, -77, 13]
  | 1 => #v[16, -17, 1, 5, -9, 11, -19, 17, 1, -6]
  | 2 => #v[-119, -2, -41, -108, -1, -99, 29, -164, 46, -113]
  | 3 => #v[32, 70, 43, 35, 11, 82, 0, 61, 39, 78]
  | 4 => #v[16, 3, -5, 24, 1, -7, 16, 15, -13, 16]
  | 5 => #v[-62, -104, -58, -50, -40, -144, -10, -86, -50, -144]
  | 6 => #v[38, -28, 24, 52, -16, 10, -18, 90, -46, 48]
  | 7 => #v[-138, -162, -84, -142, -82, -200, -30, -200, -42, -240]
  | 8 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  | 9 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  | 10 => #v[22, 22, 0, 22, -11, 22, 11, 11, 22, 0]
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
  | 0 => #v[40, -4, 0, 0, -4, 4, 8, 4, -4, 0]
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

def KZ (k : Fin 1) : VecZ :=
  match k.val with
  | 0 => #v[22, 0, -22, 0, 0, 0, 22, -22, 0, -22]
  | _ => zeroZ

def YZ (k : Fin 1) : VecZ :=
  match k.val with
  | 0 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  | _ => zeroZ

def xaEntryZ : VecZ := sumFin (fun k => mulZ (XZ k) (AZ k))
def kyEntryZ : VecZ := sumFin (fun k => mulZ (KZ k) (YZ k))
def entryZ : VecZ := addZ xaEntryZ kyEntryZ

theorem entryZ_eq : entryZ = zeroZ := by
  decide +kernel

theorem scale_ne_zero : scale ≠ 0 := by
  decide

theorem XZ_scale_0 : toVec (XZ 0) = (scale : ℚ) • XCell7_0 := by
  funext i
  fin_cases i
  · change ((18 : ℤ) : ℚ) = (scale : ℚ) * (9 / 22 : ℚ)
    exact eq_smul_div (18) scale (9) (22) (by decide) (by decide)
  · change ((-70 : ℤ) : ℚ) = (scale : ℚ) * (-35 / 22 : ℚ)
    exact eq_smul_div (-70) scale (-35) (22) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)
  · change ((34 : ℤ) : ℚ) = (scale : ℚ) * (17 / 22 : ℚ)
    exact eq_smul_div (34) scale (17) (22) (by decide) (by decide)
  · change ((-33 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 4 : ℚ)
    exact eq_smul_div (-33) scale (-3) (4) (by decide) (by decide)
  · change ((-15 : ℤ) : ℚ) = (scale : ℚ) * (-15 / 44 : ℚ)
    exact eq_smul_div (-15) scale (-15) (44) (by decide) (by decide)
  · change ((-19 : ℤ) : ℚ) = (scale : ℚ) * (-19 / 44 : ℚ)
    exact eq_smul_div (-19) scale (-19) (44) (by decide) (by decide)
  · change ((54 : ℤ) : ℚ) = (scale : ℚ) * (27 / 22 : ℚ)
    exact eq_smul_div (54) scale (27) (22) (by decide) (by decide)
  · change ((-77 : ℤ) : ℚ) = (scale : ℚ) * (-7 / 4 : ℚ)
    exact eq_smul_div (-77) scale (-7) (4) (by decide) (by decide)
  · change ((13 : ℤ) : ℚ) = (scale : ℚ) * (13 / 44 : ℚ)
    exact eq_smul_div (13) scale (13) (44) (by decide) (by decide)

theorem XZ_scale_1 : toVec (XZ 1) = (scale : ℚ) • XCell7_1 := by
  funext i
  fin_cases i
  · change ((16 : ℤ) : ℚ) = (scale : ℚ) * (4 / 11 : ℚ)
    exact eq_smul_div (16) scale (4) (11) (by decide) (by decide)
  · change ((-17 : ℤ) : ℚ) = (scale : ℚ) * (-17 / 44 : ℚ)
    exact eq_smul_div (-17) scale (-17) (44) (by decide) (by decide)
  · change ((1 : ℤ) : ℚ) = (scale : ℚ) * (1 / 44 : ℚ)
    exact eq_smul_div (1) scale (1) (44) (by decide) (by decide)
  · change ((5 : ℤ) : ℚ) = (scale : ℚ) * (5 / 44 : ℚ)
    exact eq_smul_div (5) scale (5) (44) (by decide) (by decide)
  · change ((-9 : ℤ) : ℚ) = (scale : ℚ) * (-9 / 44 : ℚ)
    exact eq_smul_div (-9) scale (-9) (44) (by decide) (by decide)
  · change ((11 : ℤ) : ℚ) = (scale : ℚ) * (1 / 4 : ℚ)
    exact eq_smul_div (11) scale (1) (4) (by decide) (by decide)
  · change ((-19 : ℤ) : ℚ) = (scale : ℚ) * (-19 / 44 : ℚ)
    exact eq_smul_div (-19) scale (-19) (44) (by decide) (by decide)
  · change ((17 : ℤ) : ℚ) = (scale : ℚ) * (17 / 44 : ℚ)
    exact eq_smul_div (17) scale (17) (44) (by decide) (by decide)
  · change ((1 : ℤ) : ℚ) = (scale : ℚ) * (1 / 44 : ℚ)
    exact eq_smul_div (1) scale (1) (44) (by decide) (by decide)
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-6) scale (-3) (22) (by decide) (by decide)

theorem XZ_scale_2 : toVec (XZ 2) = (scale : ℚ) • XCell7_2 := by
  funext i
  fin_cases i
  · change ((-119 : ℤ) : ℚ) = (scale : ℚ) * (-119 / 44 : ℚ)
    exact eq_smul_div (-119) scale (-119) (44) (by decide) (by decide)
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 22 : ℚ)
    exact eq_smul_div (-2) scale (-1) (22) (by decide) (by decide)
  · change ((-41 : ℤ) : ℚ) = (scale : ℚ) * (-41 / 44 : ℚ)
    exact eq_smul_div (-41) scale (-41) (44) (by decide) (by decide)
  · change ((-108 : ℤ) : ℚ) = (scale : ℚ) * (-27 / 11 : ℚ)
    exact eq_smul_div (-108) scale (-27) (11) (by decide) (by decide)
  · change ((-1 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 44 : ℚ)
    exact eq_smul_div (-1) scale (-1) (44) (by decide) (by decide)
  · change ((-99 : ℤ) : ℚ) = (scale : ℚ) * (-9 / 4 : ℚ)
    exact eq_smul_div (-99) scale (-9) (4) (by decide) (by decide)
  · change ((29 : ℤ) : ℚ) = (scale : ℚ) * (29 / 44 : ℚ)
    exact eq_smul_div (29) scale (29) (44) (by decide) (by decide)
  · change ((-164 : ℤ) : ℚ) = (scale : ℚ) * (-41 / 11 : ℚ)
    exact eq_smul_div (-164) scale (-41) (11) (by decide) (by decide)
  · change ((46 : ℤ) : ℚ) = (scale : ℚ) * (23 / 22 : ℚ)
    exact eq_smul_div (46) scale (23) (22) (by decide) (by decide)
  · change ((-113 : ℤ) : ℚ) = (scale : ℚ) * (-113 / 44 : ℚ)
    exact eq_smul_div (-113) scale (-113) (44) (by decide) (by decide)

theorem XZ_scale_3 : toVec (XZ 3) = (scale : ℚ) • XCell7_3 := by
  funext i
  fin_cases i
  · change ((32 : ℤ) : ℚ) = (scale : ℚ) * (8 / 11 : ℚ)
    exact eq_smul_div (32) scale (8) (11) (by decide) (by decide)
  · change ((70 : ℤ) : ℚ) = (scale : ℚ) * (35 / 22 : ℚ)
    exact eq_smul_div (70) scale (35) (22) (by decide) (by decide)
  · change ((43 : ℤ) : ℚ) = (scale : ℚ) * (43 / 44 : ℚ)
    exact eq_smul_div (43) scale (43) (44) (by decide) (by decide)
  · change ((35 : ℤ) : ℚ) = (scale : ℚ) * (35 / 44 : ℚ)
    exact eq_smul_div (35) scale (35) (44) (by decide) (by decide)
  · change ((11 : ℤ) : ℚ) = (scale : ℚ) * (1 / 4 : ℚ)
    exact eq_smul_div (11) scale (1) (4) (by decide) (by decide)
  · change ((82 : ℤ) : ℚ) = (scale : ℚ) * (41 / 22 : ℚ)
    exact eq_smul_div (82) scale (41) (22) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((61 : ℤ) : ℚ) = (scale : ℚ) * (61 / 44 : ℚ)
    exact eq_smul_div (61) scale (61) (44) (by decide) (by decide)
  · change ((39 : ℤ) : ℚ) = (scale : ℚ) * (39 / 44 : ℚ)
    exact eq_smul_div (39) scale (39) (44) (by decide) (by decide)
  · change ((78 : ℤ) : ℚ) = (scale : ℚ) * (39 / 22 : ℚ)
    exact eq_smul_div (78) scale (39) (22) (by decide) (by decide)

theorem XZ_scale_4 : toVec (XZ 4) = (scale : ℚ) • XCell7_4 := by
  funext i
  fin_cases i
  · change ((16 : ℤ) : ℚ) = (scale : ℚ) * (4 / 11 : ℚ)
    exact eq_smul_div (16) scale (4) (11) (by decide) (by decide)
  · change ((3 : ℤ) : ℚ) = (scale : ℚ) * (3 / 44 : ℚ)
    exact eq_smul_div (3) scale (3) (44) (by decide) (by decide)
  · change ((-5 : ℤ) : ℚ) = (scale : ℚ) * (-5 / 44 : ℚ)
    exact eq_smul_div (-5) scale (-5) (44) (by decide) (by decide)
  · change ((24 : ℤ) : ℚ) = (scale : ℚ) * (6 / 11 : ℚ)
    exact eq_smul_div (24) scale (6) (11) (by decide) (by decide)
  · change ((1 : ℤ) : ℚ) = (scale : ℚ) * (1 / 44 : ℚ)
    exact eq_smul_div (1) scale (1) (44) (by decide) (by decide)
  · change ((-7 : ℤ) : ℚ) = (scale : ℚ) * (-7 / 44 : ℚ)
    exact eq_smul_div (-7) scale (-7) (44) (by decide) (by decide)
  · change ((16 : ℤ) : ℚ) = (scale : ℚ) * (4 / 11 : ℚ)
    exact eq_smul_div (16) scale (4) (11) (by decide) (by decide)
  · change ((15 : ℤ) : ℚ) = (scale : ℚ) * (15 / 44 : ℚ)
    exact eq_smul_div (15) scale (15) (44) (by decide) (by decide)
  · change ((-13 : ℤ) : ℚ) = (scale : ℚ) * (-13 / 44 : ℚ)
    exact eq_smul_div (-13) scale (-13) (44) (by decide) (by decide)
  · change ((16 : ℤ) : ℚ) = (scale : ℚ) * (4 / 11 : ℚ)
    exact eq_smul_div (16) scale (4) (11) (by decide) (by decide)

theorem XZ_scale_5 : toVec (XZ 5) = (scale : ℚ) • XCell7_5 := by
  funext i
  fin_cases i
  · change ((-62 : ℤ) : ℚ) = (scale : ℚ) * (-31 / 22 : ℚ)
    exact eq_smul_div (-62) scale (-31) (22) (by decide) (by decide)
  · change ((-104 : ℤ) : ℚ) = (scale : ℚ) * (-26 / 11 : ℚ)
    exact eq_smul_div (-104) scale (-26) (11) (by decide) (by decide)
  · change ((-58 : ℤ) : ℚ) = (scale : ℚ) * (-29 / 22 : ℚ)
    exact eq_smul_div (-58) scale (-29) (22) (by decide) (by decide)
  · change ((-50 : ℤ) : ℚ) = (scale : ℚ) * (-25 / 22 : ℚ)
    exact eq_smul_div (-50) scale (-25) (22) (by decide) (by decide)
  · change ((-40 : ℤ) : ℚ) = (scale : ℚ) * (-10 / 11 : ℚ)
    exact eq_smul_div (-40) scale (-10) (11) (by decide) (by decide)
  · change ((-144 : ℤ) : ℚ) = (scale : ℚ) * (-36 / 11 : ℚ)
    exact eq_smul_div (-144) scale (-36) (11) (by decide) (by decide)
  · change ((-10 : ℤ) : ℚ) = (scale : ℚ) * (-5 / 22 : ℚ)
    exact eq_smul_div (-10) scale (-5) (22) (by decide) (by decide)
  · change ((-86 : ℤ) : ℚ) = (scale : ℚ) * (-43 / 22 : ℚ)
    exact eq_smul_div (-86) scale (-43) (22) (by decide) (by decide)
  · change ((-50 : ℤ) : ℚ) = (scale : ℚ) * (-25 / 22 : ℚ)
    exact eq_smul_div (-50) scale (-25) (22) (by decide) (by decide)
  · change ((-144 : ℤ) : ℚ) = (scale : ℚ) * (-36 / 11 : ℚ)
    exact eq_smul_div (-144) scale (-36) (11) (by decide) (by decide)

theorem XZ_scale_6 : toVec (XZ 6) = (scale : ℚ) • XCell7_6 := by
  funext i
  fin_cases i
  · change ((38 : ℤ) : ℚ) = (scale : ℚ) * (19 / 22 : ℚ)
    exact eq_smul_div (38) scale (19) (22) (by decide) (by decide)
  · change ((-28 : ℤ) : ℚ) = (scale : ℚ) * (-7 / 11 : ℚ)
    exact eq_smul_div (-28) scale (-7) (11) (by decide) (by decide)
  · change ((24 : ℤ) : ℚ) = (scale : ℚ) * (6 / 11 : ℚ)
    exact eq_smul_div (24) scale (6) (11) (by decide) (by decide)
  · change ((52 : ℤ) : ℚ) = (scale : ℚ) * (13 / 11 : ℚ)
    exact eq_smul_div (52) scale (13) (11) (by decide) (by decide)
  · change ((-16 : ℤ) : ℚ) = (scale : ℚ) * (-4 / 11 : ℚ)
    exact eq_smul_div (-16) scale (-4) (11) (by decide) (by decide)
  · change ((10 : ℤ) : ℚ) = (scale : ℚ) * (5 / 22 : ℚ)
    exact eq_smul_div (10) scale (5) (22) (by decide) (by decide)
  · change ((-18 : ℤ) : ℚ) = (scale : ℚ) * (-9 / 22 : ℚ)
    exact eq_smul_div (-18) scale (-9) (22) (by decide) (by decide)
  · change ((90 : ℤ) : ℚ) = (scale : ℚ) * (45 / 22 : ℚ)
    exact eq_smul_div (90) scale (45) (22) (by decide) (by decide)
  · change ((-46 : ℤ) : ℚ) = (scale : ℚ) * (-23 / 22 : ℚ)
    exact eq_smul_div (-46) scale (-23) (22) (by decide) (by decide)
  · change ((48 : ℤ) : ℚ) = (scale : ℚ) * (12 / 11 : ℚ)
    exact eq_smul_div (48) scale (12) (11) (by decide) (by decide)

theorem XZ_scale_7 : toVec (XZ 7) = (scale : ℚ) • XCell7_7 := by
  funext i
  fin_cases i
  · change ((-138 : ℤ) : ℚ) = (scale : ℚ) * (-69 / 22 : ℚ)
    exact eq_smul_div (-138) scale (-69) (22) (by decide) (by decide)
  · change ((-162 : ℤ) : ℚ) = (scale : ℚ) * (-81 / 22 : ℚ)
    exact eq_smul_div (-162) scale (-81) (22) (by decide) (by decide)
  · change ((-84 : ℤ) : ℚ) = (scale : ℚ) * (-21 / 11 : ℚ)
    exact eq_smul_div (-84) scale (-21) (11) (by decide) (by decide)
  · change ((-142 : ℤ) : ℚ) = (scale : ℚ) * (-71 / 22 : ℚ)
    exact eq_smul_div (-142) scale (-71) (22) (by decide) (by decide)
  · change ((-82 : ℤ) : ℚ) = (scale : ℚ) * (-41 / 22 : ℚ)
    exact eq_smul_div (-82) scale (-41) (22) (by decide) (by decide)
  · change ((-200 : ℤ) : ℚ) = (scale : ℚ) * (-50 / 11 : ℚ)
    exact eq_smul_div (-200) scale (-50) (11) (by decide) (by decide)
  · change ((-30 : ℤ) : ℚ) = (scale : ℚ) * (-15 / 22 : ℚ)
    exact eq_smul_div (-30) scale (-15) (22) (by decide) (by decide)
  · change ((-200 : ℤ) : ℚ) = (scale : ℚ) * (-50 / 11 : ℚ)
    exact eq_smul_div (-200) scale (-50) (11) (by decide) (by decide)
  · change ((-42 : ℤ) : ℚ) = (scale : ℚ) * (-21 / 22 : ℚ)
    exact eq_smul_div (-42) scale (-21) (22) (by decide) (by decide)
  · change ((-240 : ℤ) : ℚ) = (scale : ℚ) * (-60 / 11 : ℚ)
    exact eq_smul_div (-240) scale (-60) (11) (by decide) (by decide)

theorem XZ_scale_8 : toVec (XZ 8) = (scale : ℚ) • XCell7_8 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem XZ_scale_9 : toVec (XZ 9) = (scale : ℚ) • XCell7_9 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem XZ_scale_10 : toVec (XZ 10) = (scale : ℚ) • XCell7_10 := by
  funext i
  fin_cases i
  · change ((22 : ℤ) : ℚ) = (scale : ℚ) * (1 / 2 : ℚ)
    exact eq_smul_div (22) scale (1) (2) (by decide) (by decide)
  · change ((22 : ℤ) : ℚ) = (scale : ℚ) * (1 / 2 : ℚ)
    exact eq_smul_div (22) scale (1) (2) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((22 : ℤ) : ℚ) = (scale : ℚ) * (1 / 2 : ℚ)
    exact eq_smul_div (22) scale (1) (2) (by decide) (by decide)
  · change ((-11 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 4 : ℚ)
    exact eq_smul_div (-11) scale (-1) (4) (by decide) (by decide)
  · change ((22 : ℤ) : ℚ) = (scale : ℚ) * (1 / 2 : ℚ)
    exact eq_smul_div (22) scale (1) (2) (by decide) (by decide)
  · change ((11 : ℤ) : ℚ) = (scale : ℚ) * (1 / 4 : ℚ)
    exact eq_smul_div (11) scale (1) (4) (by decide) (by decide)
  · change ((11 : ℤ) : ℚ) = (scale : ℚ) * (1 / 4 : ℚ)
    exact eq_smul_div (11) scale (1) (4) (by decide) (by decide)
  · change ((22 : ℤ) : ℚ) = (scale : ℚ) * (1 / 2 : ℚ)
    exact eq_smul_div (22) scale (1) (2) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem XZ_scale_11 : toVec (XZ 11) = (scale : ℚ) • XCell7_11 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem XZ_scale_12 : toVec (XZ 12) = (scale : ℚ) • XCell7_12 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem XZ_scale_13 : toVec (XZ 13) = (scale : ℚ) • XCell7_13 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem XZ_scale_14 : toVec (XZ 14) = (scale : ℚ) • XCell7_14 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem XZ_scale_15 : toVec (XZ 15) = (scale : ℚ) • XCell7_15 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem XZ_scale_16 : toVec (XZ 16) = (scale : ℚ) • XCell7_16 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem XZ_scale_17 : toVec (XZ 17) = (scale : ℚ) • XCell7_17 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem XZ_scale_18 : toVec (XZ 18) = (scale : ℚ) • XCell7_18 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem XZ_scale_19 : toVec (XZ 19) = (scale : ℚ) • XCell7_19 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem XZ_scale (k : Fin 20) :
    toVec (XZ k) = (scale : ℚ) • XVec (7 : Fin 10) k := by
  fin_cases k
  · simp [XVec, XRow7]; exact XZ_scale_0
  · simp [XVec, XRow7]; exact XZ_scale_1
  · simp [XVec, XRow7]; exact XZ_scale_2
  · simp [XVec, XRow7]; exact XZ_scale_3
  · simp [XVec, XRow7]; exact XZ_scale_4
  · simp [XVec, XRow7]; exact XZ_scale_5
  · simp [XVec, XRow7]; exact XZ_scale_6
  · simp [XVec, XRow7]; exact XZ_scale_7
  · simp [XVec, XRow7]; exact XZ_scale_8
  · simp [XVec, XRow7]; exact XZ_scale_9
  · simp [XVec, XRow7]; exact XZ_scale_10
  · simp [XVec, XRow7]; exact XZ_scale_11
  · simp [XVec, XRow7]; exact XZ_scale_12
  · simp [XVec, XRow7]; exact XZ_scale_13
  · simp [XVec, XRow7]; exact XZ_scale_14
  · simp [XVec, XRow7]; exact XZ_scale_15
  · simp [XVec, XRow7]; exact XZ_scale_16
  · simp [XVec, XRow7]; exact XZ_scale_17
  · simp [XVec, XRow7]; exact XZ_scale_18
  · simp [XVec, XRow7]; exact XZ_scale_19

theorem AZ_scale_0 : toVec (AZ 0) = (scale : ℚ) • ACell0_0 := by
  funext i
  fin_cases i
  · change ((40 : ℤ) : ℚ) = (scale : ℚ) * (10 / 11 : ℚ)
    exact eq_smul_div (40) scale (10) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (4) scale (1) (11) (by decide) (by decide)
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (8) scale (2) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (4) scale (1) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem AZ_scale_1 : toVec (AZ 1) = (scale : ℚ) • ACell1_0 := by
  funext i
  fin_cases i
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (4) scale (1) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (8) scale (2) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (4) scale (1) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem AZ_scale_2 : toVec (AZ 2) = (scale : ℚ) • ACell2_0 := by
  funext i
  fin_cases i
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (4) scale (1) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (4) scale (1) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (8) scale (2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem AZ_scale_3 : toVec (AZ 3) = (scale : ℚ) • ACell3_0 := by
  funext i
  fin_cases i
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (8) scale (2) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (4) scale (1) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (4) scale (1) (11) (by decide) (by decide)
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (8) scale (2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (4) scale (1) (11) (by decide) (by decide)
  · change ((12 : ℤ) : ℚ) = (scale : ℚ) * (3 / 11 : ℚ)
    exact eq_smul_div (12) scale (3) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (4) scale (1) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem AZ_scale_4 : toVec (AZ 4) = (scale : ℚ) • ACell4_0 := by
  funext i
  fin_cases i
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (8) scale (2) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (4) scale (1) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (4) scale (1) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)

theorem AZ_scale_5 : toVec (AZ 5) = (scale : ℚ) • ACell5_0 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (3 / 22 : ℚ)
    exact eq_smul_div (6) scale (3) (22) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-6) scale (-3) (22) (by decide) (by decide)
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-6) scale (-3) (22) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (3 / 22 : ℚ)
    exact eq_smul_div (6) scale (3) (22) (by decide) (by decide)

theorem AZ_scale_6 : toVec (AZ 6) = (scale : ℚ) • ACell6_0 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (3 / 22 : ℚ)
    exact eq_smul_div (6) scale (3) (22) (by decide) (by decide)
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-6) scale (-3) (22) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-6) scale (-3) (22) (by decide) (by decide)
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (3 / 22 : ℚ)
    exact eq_smul_div (6) scale (3) (22) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem AZ_scale_7 : toVec (AZ 7) = (scale : ℚ) • ACell7_0 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (3 / 22 : ℚ)
    exact eq_smul_div (6) scale (3) (22) (by decide) (by decide)
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-6) scale (-3) (22) (by decide) (by decide)
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-6) scale (-3) (22) (by decide) (by decide)
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (3 / 22 : ℚ)
    exact eq_smul_div (6) scale (3) (22) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem AZ_scale_8 : toVec (AZ 8) = (scale : ℚ) • ACell8_0 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-6) scale (-3) (22) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-6) scale (-3) (22) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (3 / 22 : ℚ)
    exact eq_smul_div (6) scale (3) (22) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (3 / 22 : ℚ)
    exact eq_smul_div (6) scale (3) (22) (by decide) (by decide)

theorem AZ_scale_9 : toVec (AZ 9) = (scale : ℚ) • ACell9_0 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (3 / 22 : ℚ)
    exact eq_smul_div (6) scale (3) (22) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-6) scale (-3) (22) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-6) scale (-3) (22) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (3 / 22 : ℚ)
    exact eq_smul_div (6) scale (3) (22) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem AZ_scale_10 : toVec (AZ 10) = (scale : ℚ) • ACell10_0 := by
  funext i
  fin_cases i
  · change ((56 : ℤ) : ℚ) = (scale : ℚ) * (14 / 11 : ℚ)
    exact eq_smul_div (56) scale (14) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (8) scale (2) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (4) scale (1) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (4) scale (1) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (4) scale (1) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (4) scale (1) (11) (by decide) (by decide)
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (8) scale (2) (11) (by decide) (by decide)

theorem AZ_scale_11 : toVec (AZ 11) = (scale : ℚ) • ACell11_0 := by
  funext i
  fin_cases i
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-2) (11) (by decide) (by decide)
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-2) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (4) scale (1) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-2) (11) (by decide) (by decide)
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-2) (11) (by decide) (by decide)

theorem AZ_scale_12 : toVec (AZ 12) = (scale : ℚ) • ACell12_0 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-2) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-2) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (4) scale (1) (11) (by decide) (by decide)
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-2) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-2) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)

theorem AZ_scale_13 : toVec (AZ 13) = (scale : ℚ) • ACell13_0 := by
  funext i
  fin_cases i
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (4) scale (1) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (4) scale (1) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (8) scale (2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem AZ_scale_14 : toVec (AZ 14) = (scale : ℚ) • ACell14_0 := by
  funext i
  fin_cases i
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (4) scale (1) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (4) scale (1) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (8) scale (2) (11) (by decide) (by decide)
  · change ((12 : ℤ) : ℚ) = (scale : ℚ) * (3 / 11 : ℚ)
    exact eq_smul_div (12) scale (3) (11) (by decide) (by decide)
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (8) scale (2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (4) scale (1) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (4) scale (1) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem AZ_scale_15 : toVec (AZ 15) = (scale : ℚ) • ACell15_0 := by
  funext i
  fin_cases i
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (3 / 22 : ℚ)
    exact eq_smul_div (6) scale (3) (22) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (3 / 22 : ℚ)
    exact eq_smul_div (6) scale (3) (22) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-6) scale (-3) (22) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-6) scale (-3) (22) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem AZ_scale_16 : toVec (AZ 16) = (scale : ℚ) • ACell16_0 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (3 / 22 : ℚ)
    exact eq_smul_div (6) scale (3) (22) (by decide) (by decide)
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-6) scale (-3) (22) (by decide) (by decide)
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-6) scale (-3) (22) (by decide) (by decide)
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (3 / 22 : ℚ)
    exact eq_smul_div (6) scale (3) (22) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem AZ_scale_17 : toVec (AZ 17) = (scale : ℚ) • ACell17_0 := by
  funext i
  fin_cases i
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-6) scale (-3) (22) (by decide) (by decide)
  · change ((-12 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 11 : ℚ)
    exact eq_smul_div (-12) scale (-3) (11) (by decide) (by decide)
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-6) scale (-3) (22) (by decide) (by decide)
  · change ((-12 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 11 : ℚ)
    exact eq_smul_div (-12) scale (-3) (11) (by decide) (by decide)
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-6) scale (-3) (22) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-6) scale (-3) (22) (by decide) (by decide)
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-6) scale (-3) (22) (by decide) (by decide)
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-6) scale (-3) (22) (by decide) (by decide)
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-6) scale (-3) (22) (by decide) (by decide)

theorem AZ_scale_18 : toVec (AZ 18) = (scale : ℚ) • ACell18_0 := by
  funext i
  fin_cases i
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (3 / 22 : ℚ)
    exact eq_smul_div (6) scale (3) (22) (by decide) (by decide)
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (3 / 22 : ℚ)
    exact eq_smul_div (6) scale (3) (22) (by decide) (by decide)
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (3 / 22 : ℚ)
    exact eq_smul_div (6) scale (3) (22) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((12 : ℤ) : ℚ) = (scale : ℚ) * (3 / 11 : ℚ)
    exact eq_smul_div (12) scale (3) (11) (by decide) (by decide)
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (3 / 22 : ℚ)
    exact eq_smul_div (6) scale (3) (22) (by decide) (by decide)
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (3 / 22 : ℚ)
    exact eq_smul_div (6) scale (3) (22) (by decide) (by decide)
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (3 / 22 : ℚ)
    exact eq_smul_div (6) scale (3) (22) (by decide) (by decide)
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (3 / 22 : ℚ)
    exact eq_smul_div (6) scale (3) (22) (by decide) (by decide)
  · change ((12 : ℤ) : ℚ) = (scale : ℚ) * (3 / 11 : ℚ)
    exact eq_smul_div (12) scale (3) (11) (by decide) (by decide)

theorem AZ_scale_19 : toVec (AZ 19) = (scale : ℚ) • ACell19_0 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-6) scale (-3) (22) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-6) scale (-3) (22) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (3 / 22 : ℚ)
    exact eq_smul_div (6) scale (3) (22) (by decide) (by decide)
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (3 / 22 : ℚ)
    exact eq_smul_div (6) scale (3) (22) (by decide) (by decide)

theorem AZ_scale (k : Fin 20) :
    toVec (AZ k) = (scale : ℚ) • AVec k (0 : Fin 10) := by
  fin_cases k
  · simp [AVec, ARow0]; exact AZ_scale_0
  · simp [AVec, ARow1]; exact AZ_scale_1
  · simp [AVec, ARow2]; exact AZ_scale_2
  · simp [AVec, ARow3]; exact AZ_scale_3
  · simp [AVec, ARow4]; exact AZ_scale_4
  · simp [AVec, ARow5]; exact AZ_scale_5
  · simp [AVec, ARow6]; exact AZ_scale_6
  · simp [AVec, ARow7]; exact AZ_scale_7
  · simp [AVec, ARow8]; exact AZ_scale_8
  · simp [AVec, ARow9]; exact AZ_scale_9
  · simp [AVec, ARow10]; exact AZ_scale_10
  · simp [AVec, ARow11]; exact AZ_scale_11
  · simp [AVec, ARow12]; exact AZ_scale_12
  · simp [AVec, ARow13]; exact AZ_scale_13
  · simp [AVec, ARow14]; exact AZ_scale_14
  · simp [AVec, ARow15]; exact AZ_scale_15
  · simp [AVec, ARow16]; exact AZ_scale_16
  · simp [AVec, ARow17]; exact AZ_scale_17
  · simp [AVec, ARow18]; exact AZ_scale_18
  · simp [AVec, ARow19]; exact AZ_scale_19

theorem KZ_scale_0 : toVec (KZ 0) = (scale : ℚ) • KCell7_0 := by
  funext i
  fin_cases i
  · change ((22 : ℤ) : ℚ) = (scale : ℚ) * (1 / 2 : ℚ)
    exact eq_smul_div (22) scale (1) (2) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-22 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 2 : ℚ)
    exact eq_smul_div (-22) scale (-1) (2) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((22 : ℤ) : ℚ) = (scale : ℚ) * (1 / 2 : ℚ)
    exact eq_smul_div (22) scale (1) (2) (by decide) (by decide)
  · change ((-22 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 2 : ℚ)
    exact eq_smul_div (-22) scale (-1) (2) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-22 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 2 : ℚ)
    exact eq_smul_div (-22) scale (-1) (2) (by decide) (by decide)

theorem KZ_scale (k : Fin 1) :
    toVec (KZ k) = (scale : ℚ) • KVec (7 : Fin 10) k := by
  fin_cases k
  · simp [KVec, KRow0]; exact KZ_scale_0

theorem YZ_scale_0 : toVec (YZ 0) = (scale : ℚ) • YCell0_0 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem YZ_scale (k : Fin 1) :
    toVec (YZ k) = (scale : ℚ) • YVec k (0 : Fin 10) := by
  fin_cases k
  · simp [YVec, YRow0]; exact YZ_scale_0

theorem entry_eq :
    (matrixMul XVec AVec + matrixMul KVec YVec)
        (7 : Fin 10) (0 : Fin 10) = ![0, 0, 0, 0, 0, 0, 0, 0, 0, 0] := by
  change (∑ k : Fin 20, mul (XVec (7 : Fin 10) k)
      (AVec k (0 : Fin 10))) +
    (∑ k : Fin 1, mul (KVec (7 : Fin 10) k)
      (YVec k (0 : Fin 10))) = _
  refine add_sum_mul_eq_of_scaled scale scale_ne_zero
    (fun k => XVec (7 : Fin 10) k)
    (fun k => AVec k (0 : Fin 10))
    (fun k => KVec (7 : Fin 10) k)
    (fun k => YVec k (0 : Fin 10))
    XZ AZ KZ YZ XZ_scale AZ_scale KZ_scale YZ_scale entryZ rfl _ ?_
  rw [entryZ_eq, toVec_zeroZ_smul, vec_zero_eq]

theorem entry_eq_matrixOne :
    (matrixMul XVec AVec + matrixMul KVec YVec)
        (7 : Fin 10) (0 : Fin 10) =
      matrixOne (Fin 10) (7 : Fin 10) (0 : Fin 10) := by
  rw [entry_eq]
  have hne : (7 : Fin 10) ≠ (0 : Fin 10) := by decide
  funext n
  fin_cases n <;> simp [matrixOne, constVec, basis, *]

end V14Formalization.D12PieceAASplitEntry7_0


namespace V14Formalization.D12PieceAASplitEntry7_1
open D12CyclotomicVec D12CyclotomicVecZ D12PieceAAData
def payloadSha256 : String := "76c6196f29afe1a8398af99502447f48ebeed4bcb3805fc5dbec693940bc04b0"

def scale : ℤ := 44

def XZ (k : Fin 20) : VecZ :=
  match k.val with
  | 0 => #v[18, -70, -4, 34, -33, -15, -19, 54, -77, 13]
  | 1 => #v[16, -17, 1, 5, -9, 11, -19, 17, 1, -6]
  | 2 => #v[-119, -2, -41, -108, -1, -99, 29, -164, 46, -113]
  | 3 => #v[32, 70, 43, 35, 11, 82, 0, 61, 39, 78]
  | 4 => #v[16, 3, -5, 24, 1, -7, 16, 15, -13, 16]
  | 5 => #v[-62, -104, -58, -50, -40, -144, -10, -86, -50, -144]
  | 6 => #v[38, -28, 24, 52, -16, 10, -18, 90, -46, 48]
  | 7 => #v[-138, -162, -84, -142, -82, -200, -30, -200, -42, -240]
  | 8 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  | 9 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  | 10 => #v[22, 22, 0, 22, -11, 22, 11, 11, 22, 0]
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
  | 0 => #v[-4, 0, 4, -4, 8, -4, 4, 0, -4, 0]
  | 1 => #v[44, 4, 12, 4, 0, 0, 8, 4, 4, 8]
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

def KZ (k : Fin 1) : VecZ :=
  match k.val with
  | 0 => #v[22, 0, -22, 0, 0, 0, 22, -22, 0, -22]
  | _ => zeroZ

def YZ (k : Fin 1) : VecZ :=
  match k.val with
  | 0 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  | _ => zeroZ

def xaEntryZ : VecZ := sumFin (fun k => mulZ (XZ k) (AZ k))
def kyEntryZ : VecZ := sumFin (fun k => mulZ (KZ k) (YZ k))
def entryZ : VecZ := addZ xaEntryZ kyEntryZ

theorem entryZ_eq : entryZ = zeroZ := by
  decide +kernel

theorem scale_ne_zero : scale ≠ 0 := by
  decide

theorem XZ_scale_0 : toVec (XZ 0) = (scale : ℚ) • XCell7_0 := by
  funext i
  fin_cases i
  · change ((18 : ℤ) : ℚ) = (scale : ℚ) * (9 / 22 : ℚ)
    exact eq_smul_div (18) scale (9) (22) (by decide) (by decide)
  · change ((-70 : ℤ) : ℚ) = (scale : ℚ) * (-35 / 22 : ℚ)
    exact eq_smul_div (-70) scale (-35) (22) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)
  · change ((34 : ℤ) : ℚ) = (scale : ℚ) * (17 / 22 : ℚ)
    exact eq_smul_div (34) scale (17) (22) (by decide) (by decide)
  · change ((-33 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 4 : ℚ)
    exact eq_smul_div (-33) scale (-3) (4) (by decide) (by decide)
  · change ((-15 : ℤ) : ℚ) = (scale : ℚ) * (-15 / 44 : ℚ)
    exact eq_smul_div (-15) scale (-15) (44) (by decide) (by decide)
  · change ((-19 : ℤ) : ℚ) = (scale : ℚ) * (-19 / 44 : ℚ)
    exact eq_smul_div (-19) scale (-19) (44) (by decide) (by decide)
  · change ((54 : ℤ) : ℚ) = (scale : ℚ) * (27 / 22 : ℚ)
    exact eq_smul_div (54) scale (27) (22) (by decide) (by decide)
  · change ((-77 : ℤ) : ℚ) = (scale : ℚ) * (-7 / 4 : ℚ)
    exact eq_smul_div (-77) scale (-7) (4) (by decide) (by decide)
  · change ((13 : ℤ) : ℚ) = (scale : ℚ) * (13 / 44 : ℚ)
    exact eq_smul_div (13) scale (13) (44) (by decide) (by decide)

theorem XZ_scale_1 : toVec (XZ 1) = (scale : ℚ) • XCell7_1 := by
  funext i
  fin_cases i
  · change ((16 : ℤ) : ℚ) = (scale : ℚ) * (4 / 11 : ℚ)
    exact eq_smul_div (16) scale (4) (11) (by decide) (by decide)
  · change ((-17 : ℤ) : ℚ) = (scale : ℚ) * (-17 / 44 : ℚ)
    exact eq_smul_div (-17) scale (-17) (44) (by decide) (by decide)
  · change ((1 : ℤ) : ℚ) = (scale : ℚ) * (1 / 44 : ℚ)
    exact eq_smul_div (1) scale (1) (44) (by decide) (by decide)
  · change ((5 : ℤ) : ℚ) = (scale : ℚ) * (5 / 44 : ℚ)
    exact eq_smul_div (5) scale (5) (44) (by decide) (by decide)
  · change ((-9 : ℤ) : ℚ) = (scale : ℚ) * (-9 / 44 : ℚ)
    exact eq_smul_div (-9) scale (-9) (44) (by decide) (by decide)
  · change ((11 : ℤ) : ℚ) = (scale : ℚ) * (1 / 4 : ℚ)
    exact eq_smul_div (11) scale (1) (4) (by decide) (by decide)
  · change ((-19 : ℤ) : ℚ) = (scale : ℚ) * (-19 / 44 : ℚ)
    exact eq_smul_div (-19) scale (-19) (44) (by decide) (by decide)
  · change ((17 : ℤ) : ℚ) = (scale : ℚ) * (17 / 44 : ℚ)
    exact eq_smul_div (17) scale (17) (44) (by decide) (by decide)
  · change ((1 : ℤ) : ℚ) = (scale : ℚ) * (1 / 44 : ℚ)
    exact eq_smul_div (1) scale (1) (44) (by decide) (by decide)
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-6) scale (-3) (22) (by decide) (by decide)

theorem XZ_scale_2 : toVec (XZ 2) = (scale : ℚ) • XCell7_2 := by
  funext i
  fin_cases i
  · change ((-119 : ℤ) : ℚ) = (scale : ℚ) * (-119 / 44 : ℚ)
    exact eq_smul_div (-119) scale (-119) (44) (by decide) (by decide)
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 22 : ℚ)
    exact eq_smul_div (-2) scale (-1) (22) (by decide) (by decide)
  · change ((-41 : ℤ) : ℚ) = (scale : ℚ) * (-41 / 44 : ℚ)
    exact eq_smul_div (-41) scale (-41) (44) (by decide) (by decide)
  · change ((-108 : ℤ) : ℚ) = (scale : ℚ) * (-27 / 11 : ℚ)
    exact eq_smul_div (-108) scale (-27) (11) (by decide) (by decide)
  · change ((-1 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 44 : ℚ)
    exact eq_smul_div (-1) scale (-1) (44) (by decide) (by decide)
  · change ((-99 : ℤ) : ℚ) = (scale : ℚ) * (-9 / 4 : ℚ)
    exact eq_smul_div (-99) scale (-9) (4) (by decide) (by decide)
  · change ((29 : ℤ) : ℚ) = (scale : ℚ) * (29 / 44 : ℚ)
    exact eq_smul_div (29) scale (29) (44) (by decide) (by decide)
  · change ((-164 : ℤ) : ℚ) = (scale : ℚ) * (-41 / 11 : ℚ)
    exact eq_smul_div (-164) scale (-41) (11) (by decide) (by decide)
  · change ((46 : ℤ) : ℚ) = (scale : ℚ) * (23 / 22 : ℚ)
    exact eq_smul_div (46) scale (23) (22) (by decide) (by decide)
  · change ((-113 : ℤ) : ℚ) = (scale : ℚ) * (-113 / 44 : ℚ)
    exact eq_smul_div (-113) scale (-113) (44) (by decide) (by decide)

theorem XZ_scale_3 : toVec (XZ 3) = (scale : ℚ) • XCell7_3 := by
  funext i
  fin_cases i
  · change ((32 : ℤ) : ℚ) = (scale : ℚ) * (8 / 11 : ℚ)
    exact eq_smul_div (32) scale (8) (11) (by decide) (by decide)
  · change ((70 : ℤ) : ℚ) = (scale : ℚ) * (35 / 22 : ℚ)
    exact eq_smul_div (70) scale (35) (22) (by decide) (by decide)
  · change ((43 : ℤ) : ℚ) = (scale : ℚ) * (43 / 44 : ℚ)
    exact eq_smul_div (43) scale (43) (44) (by decide) (by decide)
  · change ((35 : ℤ) : ℚ) = (scale : ℚ) * (35 / 44 : ℚ)
    exact eq_smul_div (35) scale (35) (44) (by decide) (by decide)
  · change ((11 : ℤ) : ℚ) = (scale : ℚ) * (1 / 4 : ℚ)
    exact eq_smul_div (11) scale (1) (4) (by decide) (by decide)
  · change ((82 : ℤ) : ℚ) = (scale : ℚ) * (41 / 22 : ℚ)
    exact eq_smul_div (82) scale (41) (22) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((61 : ℤ) : ℚ) = (scale : ℚ) * (61 / 44 : ℚ)
    exact eq_smul_div (61) scale (61) (44) (by decide) (by decide)
  · change ((39 : ℤ) : ℚ) = (scale : ℚ) * (39 / 44 : ℚ)
    exact eq_smul_div (39) scale (39) (44) (by decide) (by decide)
  · change ((78 : ℤ) : ℚ) = (scale : ℚ) * (39 / 22 : ℚ)
    exact eq_smul_div (78) scale (39) (22) (by decide) (by decide)

theorem XZ_scale_4 : toVec (XZ 4) = (scale : ℚ) • XCell7_4 := by
  funext i
  fin_cases i
  · change ((16 : ℤ) : ℚ) = (scale : ℚ) * (4 / 11 : ℚ)
    exact eq_smul_div (16) scale (4) (11) (by decide) (by decide)
  · change ((3 : ℤ) : ℚ) = (scale : ℚ) * (3 / 44 : ℚ)
    exact eq_smul_div (3) scale (3) (44) (by decide) (by decide)
  · change ((-5 : ℤ) : ℚ) = (scale : ℚ) * (-5 / 44 : ℚ)
    exact eq_smul_div (-5) scale (-5) (44) (by decide) (by decide)
  · change ((24 : ℤ) : ℚ) = (scale : ℚ) * (6 / 11 : ℚ)
    exact eq_smul_div (24) scale (6) (11) (by decide) (by decide)
  · change ((1 : ℤ) : ℚ) = (scale : ℚ) * (1 / 44 : ℚ)
    exact eq_smul_div (1) scale (1) (44) (by decide) (by decide)
  · change ((-7 : ℤ) : ℚ) = (scale : ℚ) * (-7 / 44 : ℚ)
    exact eq_smul_div (-7) scale (-7) (44) (by decide) (by decide)
  · change ((16 : ℤ) : ℚ) = (scale : ℚ) * (4 / 11 : ℚ)
    exact eq_smul_div (16) scale (4) (11) (by decide) (by decide)
  · change ((15 : ℤ) : ℚ) = (scale : ℚ) * (15 / 44 : ℚ)
    exact eq_smul_div (15) scale (15) (44) (by decide) (by decide)
  · change ((-13 : ℤ) : ℚ) = (scale : ℚ) * (-13 / 44 : ℚ)
    exact eq_smul_div (-13) scale (-13) (44) (by decide) (by decide)
  · change ((16 : ℤ) : ℚ) = (scale : ℚ) * (4 / 11 : ℚ)
    exact eq_smul_div (16) scale (4) (11) (by decide) (by decide)

theorem XZ_scale_5 : toVec (XZ 5) = (scale : ℚ) • XCell7_5 := by
  funext i
  fin_cases i
  · change ((-62 : ℤ) : ℚ) = (scale : ℚ) * (-31 / 22 : ℚ)
    exact eq_smul_div (-62) scale (-31) (22) (by decide) (by decide)
  · change ((-104 : ℤ) : ℚ) = (scale : ℚ) * (-26 / 11 : ℚ)
    exact eq_smul_div (-104) scale (-26) (11) (by decide) (by decide)
  · change ((-58 : ℤ) : ℚ) = (scale : ℚ) * (-29 / 22 : ℚ)
    exact eq_smul_div (-58) scale (-29) (22) (by decide) (by decide)
  · change ((-50 : ℤ) : ℚ) = (scale : ℚ) * (-25 / 22 : ℚ)
    exact eq_smul_div (-50) scale (-25) (22) (by decide) (by decide)
  · change ((-40 : ℤ) : ℚ) = (scale : ℚ) * (-10 / 11 : ℚ)
    exact eq_smul_div (-40) scale (-10) (11) (by decide) (by decide)
  · change ((-144 : ℤ) : ℚ) = (scale : ℚ) * (-36 / 11 : ℚ)
    exact eq_smul_div (-144) scale (-36) (11) (by decide) (by decide)
  · change ((-10 : ℤ) : ℚ) = (scale : ℚ) * (-5 / 22 : ℚ)
    exact eq_smul_div (-10) scale (-5) (22) (by decide) (by decide)
  · change ((-86 : ℤ) : ℚ) = (scale : ℚ) * (-43 / 22 : ℚ)
    exact eq_smul_div (-86) scale (-43) (22) (by decide) (by decide)
  · change ((-50 : ℤ) : ℚ) = (scale : ℚ) * (-25 / 22 : ℚ)
    exact eq_smul_div (-50) scale (-25) (22) (by decide) (by decide)
  · change ((-144 : ℤ) : ℚ) = (scale : ℚ) * (-36 / 11 : ℚ)
    exact eq_smul_div (-144) scale (-36) (11) (by decide) (by decide)

theorem XZ_scale_6 : toVec (XZ 6) = (scale : ℚ) • XCell7_6 := by
  funext i
  fin_cases i
  · change ((38 : ℤ) : ℚ) = (scale : ℚ) * (19 / 22 : ℚ)
    exact eq_smul_div (38) scale (19) (22) (by decide) (by decide)
  · change ((-28 : ℤ) : ℚ) = (scale : ℚ) * (-7 / 11 : ℚ)
    exact eq_smul_div (-28) scale (-7) (11) (by decide) (by decide)
  · change ((24 : ℤ) : ℚ) = (scale : ℚ) * (6 / 11 : ℚ)
    exact eq_smul_div (24) scale (6) (11) (by decide) (by decide)
  · change ((52 : ℤ) : ℚ) = (scale : ℚ) * (13 / 11 : ℚ)
    exact eq_smul_div (52) scale (13) (11) (by decide) (by decide)
  · change ((-16 : ℤ) : ℚ) = (scale : ℚ) * (-4 / 11 : ℚ)
    exact eq_smul_div (-16) scale (-4) (11) (by decide) (by decide)
  · change ((10 : ℤ) : ℚ) = (scale : ℚ) * (5 / 22 : ℚ)
    exact eq_smul_div (10) scale (5) (22) (by decide) (by decide)
  · change ((-18 : ℤ) : ℚ) = (scale : ℚ) * (-9 / 22 : ℚ)
    exact eq_smul_div (-18) scale (-9) (22) (by decide) (by decide)
  · change ((90 : ℤ) : ℚ) = (scale : ℚ) * (45 / 22 : ℚ)
    exact eq_smul_div (90) scale (45) (22) (by decide) (by decide)
  · change ((-46 : ℤ) : ℚ) = (scale : ℚ) * (-23 / 22 : ℚ)
    exact eq_smul_div (-46) scale (-23) (22) (by decide) (by decide)
  · change ((48 : ℤ) : ℚ) = (scale : ℚ) * (12 / 11 : ℚ)
    exact eq_smul_div (48) scale (12) (11) (by decide) (by decide)

theorem XZ_scale_7 : toVec (XZ 7) = (scale : ℚ) • XCell7_7 := by
  funext i
  fin_cases i
  · change ((-138 : ℤ) : ℚ) = (scale : ℚ) * (-69 / 22 : ℚ)
    exact eq_smul_div (-138) scale (-69) (22) (by decide) (by decide)
  · change ((-162 : ℤ) : ℚ) = (scale : ℚ) * (-81 / 22 : ℚ)
    exact eq_smul_div (-162) scale (-81) (22) (by decide) (by decide)
  · change ((-84 : ℤ) : ℚ) = (scale : ℚ) * (-21 / 11 : ℚ)
    exact eq_smul_div (-84) scale (-21) (11) (by decide) (by decide)
  · change ((-142 : ℤ) : ℚ) = (scale : ℚ) * (-71 / 22 : ℚ)
    exact eq_smul_div (-142) scale (-71) (22) (by decide) (by decide)
  · change ((-82 : ℤ) : ℚ) = (scale : ℚ) * (-41 / 22 : ℚ)
    exact eq_smul_div (-82) scale (-41) (22) (by decide) (by decide)
  · change ((-200 : ℤ) : ℚ) = (scale : ℚ) * (-50 / 11 : ℚ)
    exact eq_smul_div (-200) scale (-50) (11) (by decide) (by decide)
  · change ((-30 : ℤ) : ℚ) = (scale : ℚ) * (-15 / 22 : ℚ)
    exact eq_smul_div (-30) scale (-15) (22) (by decide) (by decide)
  · change ((-200 : ℤ) : ℚ) = (scale : ℚ) * (-50 / 11 : ℚ)
    exact eq_smul_div (-200) scale (-50) (11) (by decide) (by decide)
  · change ((-42 : ℤ) : ℚ) = (scale : ℚ) * (-21 / 22 : ℚ)
    exact eq_smul_div (-42) scale (-21) (22) (by decide) (by decide)
  · change ((-240 : ℤ) : ℚ) = (scale : ℚ) * (-60 / 11 : ℚ)
    exact eq_smul_div (-240) scale (-60) (11) (by decide) (by decide)

theorem XZ_scale_8 : toVec (XZ 8) = (scale : ℚ) • XCell7_8 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem XZ_scale_9 : toVec (XZ 9) = (scale : ℚ) • XCell7_9 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem XZ_scale_10 : toVec (XZ 10) = (scale : ℚ) • XCell7_10 := by
  funext i
  fin_cases i
  · change ((22 : ℤ) : ℚ) = (scale : ℚ) * (1 / 2 : ℚ)
    exact eq_smul_div (22) scale (1) (2) (by decide) (by decide)
  · change ((22 : ℤ) : ℚ) = (scale : ℚ) * (1 / 2 : ℚ)
    exact eq_smul_div (22) scale (1) (2) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((22 : ℤ) : ℚ) = (scale : ℚ) * (1 / 2 : ℚ)
    exact eq_smul_div (22) scale (1) (2) (by decide) (by decide)
  · change ((-11 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 4 : ℚ)
    exact eq_smul_div (-11) scale (-1) (4) (by decide) (by decide)
  · change ((22 : ℤ) : ℚ) = (scale : ℚ) * (1 / 2 : ℚ)
    exact eq_smul_div (22) scale (1) (2) (by decide) (by decide)
  · change ((11 : ℤ) : ℚ) = (scale : ℚ) * (1 / 4 : ℚ)
    exact eq_smul_div (11) scale (1) (4) (by decide) (by decide)
  · change ((11 : ℤ) : ℚ) = (scale : ℚ) * (1 / 4 : ℚ)
    exact eq_smul_div (11) scale (1) (4) (by decide) (by decide)
  · change ((22 : ℤ) : ℚ) = (scale : ℚ) * (1 / 2 : ℚ)
    exact eq_smul_div (22) scale (1) (2) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem XZ_scale_11 : toVec (XZ 11) = (scale : ℚ) • XCell7_11 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem XZ_scale_12 : toVec (XZ 12) = (scale : ℚ) • XCell7_12 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem XZ_scale_13 : toVec (XZ 13) = (scale : ℚ) • XCell7_13 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem XZ_scale_14 : toVec (XZ 14) = (scale : ℚ) • XCell7_14 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem XZ_scale_15 : toVec (XZ 15) = (scale : ℚ) • XCell7_15 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem XZ_scale_16 : toVec (XZ 16) = (scale : ℚ) • XCell7_16 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem XZ_scale_17 : toVec (XZ 17) = (scale : ℚ) • XCell7_17 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem XZ_scale_18 : toVec (XZ 18) = (scale : ℚ) • XCell7_18 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem XZ_scale_19 : toVec (XZ 19) = (scale : ℚ) • XCell7_19 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem XZ_scale (k : Fin 20) :
    toVec (XZ k) = (scale : ℚ) • XVec (7 : Fin 10) k := by
  fin_cases k
  · simp [XVec, XRow7]; exact XZ_scale_0
  · simp [XVec, XRow7]; exact XZ_scale_1
  · simp [XVec, XRow7]; exact XZ_scale_2
  · simp [XVec, XRow7]; exact XZ_scale_3
  · simp [XVec, XRow7]; exact XZ_scale_4
  · simp [XVec, XRow7]; exact XZ_scale_5
  · simp [XVec, XRow7]; exact XZ_scale_6
  · simp [XVec, XRow7]; exact XZ_scale_7
  · simp [XVec, XRow7]; exact XZ_scale_8
  · simp [XVec, XRow7]; exact XZ_scale_9
  · simp [XVec, XRow7]; exact XZ_scale_10
  · simp [XVec, XRow7]; exact XZ_scale_11
  · simp [XVec, XRow7]; exact XZ_scale_12
  · simp [XVec, XRow7]; exact XZ_scale_13
  · simp [XVec, XRow7]; exact XZ_scale_14
  · simp [XVec, XRow7]; exact XZ_scale_15
  · simp [XVec, XRow7]; exact XZ_scale_16
  · simp [XVec, XRow7]; exact XZ_scale_17
  · simp [XVec, XRow7]; exact XZ_scale_18
  · simp [XVec, XRow7]; exact XZ_scale_19

theorem AZ_scale_0 : toVec (AZ 0) = (scale : ℚ) • ACell0_1 := by
  funext i
  fin_cases i
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (4) scale (1) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (8) scale (2) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (4) scale (1) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem AZ_scale_1 : toVec (AZ 1) = (scale : ℚ) • ACell1_1 := by
  funext i
  fin_cases i
  · change ((44 : ℤ) : ℚ) = (scale : ℚ) * (1 : ℚ)
    exact eq_smul_int (44) scale (1) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (4) scale (1) (11) (by decide) (by decide)
  · change ((12 : ℤ) : ℚ) = (scale : ℚ) * (3 / 11 : ℚ)
    exact eq_smul_div (12) scale (3) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (4) scale (1) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (8) scale (2) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (4) scale (1) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (4) scale (1) (11) (by decide) (by decide)
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (8) scale (2) (11) (by decide) (by decide)

theorem AZ_scale_2 : toVec (AZ 2) = (scale : ℚ) • ACell2_1 := by
  funext i
  fin_cases i
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (4) scale (1) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (4) scale (1) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (8) scale (2) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)

theorem AZ_scale_3 : toVec (AZ 3) = (scale : ℚ) • ACell3_1 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (8) scale (2) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (4) scale (1) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (4) scale (1) (11) (by decide) (by decide)
  · change ((12 : ℤ) : ℚ) = (scale : ℚ) * (3 / 11 : ℚ)
    exact eq_smul_div (12) scale (3) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (4) scale (1) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (4) scale (1) (11) (by decide) (by decide)
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (8) scale (2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem AZ_scale_4 : toVec (AZ 4) = (scale : ℚ) • ACell4_1 := by
  funext i
  fin_cases i
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)
  · change ((-12 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 11 : ℚ)
    exact eq_smul_div (-12) scale (-3) (11) (by decide) (by decide)
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-2) (11) (by decide) (by decide)
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-2) (11) (by decide) (by decide)
  · change ((-12 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 11 : ℚ)
    exact eq_smul_div (-12) scale (-3) (11) (by decide) (by decide)
  · change ((-12 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 11 : ℚ)
    exact eq_smul_div (-12) scale (-3) (11) (by decide) (by decide)
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-2) (11) (by decide) (by decide)
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-2) (11) (by decide) (by decide)
  · change ((-12 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 11 : ℚ)
    exact eq_smul_div (-12) scale (-3) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)

theorem AZ_scale_5 : toVec (AZ 5) = (scale : ℚ) • ACell5_1 := by
  funext i
  fin_cases i
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (3 / 22 : ℚ)
    exact eq_smul_div (6) scale (3) (22) (by decide) (by decide)
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (3 / 22 : ℚ)
    exact eq_smul_div (6) scale (3) (22) (by decide) (by decide)
  · change ((12 : ℤ) : ℚ) = (scale : ℚ) * (3 / 11 : ℚ)
    exact eq_smul_div (12) scale (3) (11) (by decide) (by decide)
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (3 / 22 : ℚ)
    exact eq_smul_div (6) scale (3) (22) (by decide) (by decide)
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (3 / 22 : ℚ)
    exact eq_smul_div (6) scale (3) (22) (by decide) (by decide)
  · change ((12 : ℤ) : ℚ) = (scale : ℚ) * (3 / 11 : ℚ)
    exact eq_smul_div (12) scale (3) (11) (by decide) (by decide)
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (3 / 22 : ℚ)
    exact eq_smul_div (6) scale (3) (22) (by decide) (by decide)
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (3 / 22 : ℚ)
    exact eq_smul_div (6) scale (3) (22) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (3 / 22 : ℚ)
    exact eq_smul_div (6) scale (3) (22) (by decide) (by decide)

theorem AZ_scale_6 : toVec (AZ 6) = (scale : ℚ) • ACell6_1 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (3 / 22 : ℚ)
    exact eq_smul_div (6) scale (3) (22) (by decide) (by decide)
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-6) scale (-3) (22) (by decide) (by decide)
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-6) scale (-3) (22) (by decide) (by decide)
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (3 / 22 : ℚ)
    exact eq_smul_div (6) scale (3) (22) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem AZ_scale_7 : toVec (AZ 7) = (scale : ℚ) • ACell7_1 := by
  funext i
  fin_cases i
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-6) scale (-3) (22) (by decide) (by decide)
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-6) scale (-3) (22) (by decide) (by decide)
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-6) scale (-3) (22) (by decide) (by decide)
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-6) scale (-3) (22) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-6) scale (-3) (22) (by decide) (by decide)
  · change ((-12 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 11 : ℚ)
    exact eq_smul_div (-12) scale (-3) (11) (by decide) (by decide)
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-6) scale (-3) (22) (by decide) (by decide)
  · change ((-12 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 11 : ℚ)
    exact eq_smul_div (-12) scale (-3) (11) (by decide) (by decide)
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-6) scale (-3) (22) (by decide) (by decide)

theorem AZ_scale_8 : toVec (AZ 8) = (scale : ℚ) • ACell8_1 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-6) scale (-3) (22) (by decide) (by decide)
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (3 / 22 : ℚ)
    exact eq_smul_div (6) scale (3) (22) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (3 / 22 : ℚ)
    exact eq_smul_div (6) scale (3) (22) (by decide) (by decide)
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-6) scale (-3) (22) (by decide) (by decide)

theorem AZ_scale_9 : toVec (AZ 9) = (scale : ℚ) • ACell9_1 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-6) scale (-3) (22) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-6) scale (-3) (22) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (3 / 22 : ℚ)
    exact eq_smul_div (6) scale (3) (22) (by decide) (by decide)
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (3 / 22 : ℚ)
    exact eq_smul_div (6) scale (3) (22) (by decide) (by decide)

theorem AZ_scale_10 : toVec (AZ 10) = (scale : ℚ) • ACell10_1 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (4) scale (1) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (8) scale (2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (4) scale (1) (11) (by decide) (by decide)

theorem AZ_scale_11 : toVec (AZ 11) = (scale : ℚ) • ACell11_1 := by
  funext i
  fin_cases i
  · change ((52 : ℤ) : ℚ) = (scale : ℚ) * (13 / 11 : ℚ)
    exact eq_smul_div (52) scale (13) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (4) scale (1) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (4) scale (1) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem AZ_scale_12 : toVec (AZ 12) = (scale : ℚ) • ACell12_1 := by
  funext i
  fin_cases i
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)
  · change ((-12 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 11 : ℚ)
    exact eq_smul_div (-12) scale (-3) (11) (by decide) (by decide)
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-2) (11) (by decide) (by decide)
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-2) (11) (by decide) (by decide)
  · change ((-12 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 11 : ℚ)
    exact eq_smul_div (-12) scale (-3) (11) (by decide) (by decide)
  · change ((-12 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 11 : ℚ)
    exact eq_smul_div (-12) scale (-3) (11) (by decide) (by decide)
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-2) (11) (by decide) (by decide)
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-2) (11) (by decide) (by decide)
  · change ((-12 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 11 : ℚ)
    exact eq_smul_div (-12) scale (-3) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)

theorem AZ_scale_13 : toVec (AZ 13) = (scale : ℚ) • ACell13_1 := by
  funext i
  fin_cases i
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (4) scale (1) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((12 : ℤ) : ℚ) = (scale : ℚ) * (3 / 11 : ℚ)
    exact eq_smul_div (12) scale (3) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (4) scale (1) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (4) scale (1) (11) (by decide) (by decide)
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (8) scale (2) (11) (by decide) (by decide)
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (8) scale (2) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (4) scale (1) (11) (by decide) (by decide)

theorem AZ_scale_14 : toVec (AZ 14) = (scale : ℚ) • ACell14_1 := by
  funext i
  fin_cases i
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (8) scale (2) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (4) scale (1) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (4) scale (1) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (4) scale (1) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (4) scale (1) (11) (by decide) (by decide)
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (8) scale (2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((12 : ℤ) : ℚ) = (scale : ℚ) * (3 / 11 : ℚ)
    exact eq_smul_div (12) scale (3) (11) (by decide) (by decide)

theorem AZ_scale_15 : toVec (AZ 15) = (scale : ℚ) • ACell15_1 := by
  funext i
  fin_cases i
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (3 / 22 : ℚ)
    exact eq_smul_div (6) scale (3) (22) (by decide) (by decide)
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (3 / 22 : ℚ)
    exact eq_smul_div (6) scale (3) (22) (by decide) (by decide)
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (3 / 22 : ℚ)
    exact eq_smul_div (6) scale (3) (22) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((12 : ℤ) : ℚ) = (scale : ℚ) * (3 / 11 : ℚ)
    exact eq_smul_div (12) scale (3) (11) (by decide) (by decide)
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (3 / 22 : ℚ)
    exact eq_smul_div (6) scale (3) (22) (by decide) (by decide)
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (3 / 22 : ℚ)
    exact eq_smul_div (6) scale (3) (22) (by decide) (by decide)
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (3 / 22 : ℚ)
    exact eq_smul_div (6) scale (3) (22) (by decide) (by decide)
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (3 / 22 : ℚ)
    exact eq_smul_div (6) scale (3) (22) (by decide) (by decide)
  · change ((12 : ℤ) : ℚ) = (scale : ℚ) * (3 / 11 : ℚ)
    exact eq_smul_div (12) scale (3) (11) (by decide) (by decide)

theorem AZ_scale_16 : toVec (AZ 16) = (scale : ℚ) • ACell16_1 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (3 / 22 : ℚ)
    exact eq_smul_div (6) scale (3) (22) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-6) scale (-3) (22) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-6) scale (-3) (22) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (3 / 22 : ℚ)
    exact eq_smul_div (6) scale (3) (22) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem AZ_scale_17 : toVec (AZ 17) = (scale : ℚ) • ACell17_1 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (3 / 22 : ℚ)
    exact eq_smul_div (6) scale (3) (22) (by decide) (by decide)
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (3 / 22 : ℚ)
    exact eq_smul_div (6) scale (3) (22) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-6) scale (-3) (22) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-6) scale (-3) (22) (by decide) (by decide)

theorem AZ_scale_18 : toVec (AZ 18) = (scale : ℚ) • ACell18_1 := by
  funext i
  fin_cases i
  · change ((12 : ℤ) : ℚ) = (scale : ℚ) * (3 / 11 : ℚ)
    exact eq_smul_div (12) scale (3) (11) (by decide) (by decide)
  · change ((12 : ℤ) : ℚ) = (scale : ℚ) * (3 / 11 : ℚ)
    exact eq_smul_div (12) scale (3) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (3 / 22 : ℚ)
    exact eq_smul_div (6) scale (3) (22) (by decide) (by decide)
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (3 / 22 : ℚ)
    exact eq_smul_div (6) scale (3) (22) (by decide) (by decide)
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (3 / 22 : ℚ)
    exact eq_smul_div (6) scale (3) (22) (by decide) (by decide)
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (3 / 22 : ℚ)
    exact eq_smul_div (6) scale (3) (22) (by decide) (by decide)
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (3 / 22 : ℚ)
    exact eq_smul_div (6) scale (3) (22) (by decide) (by decide)
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (3 / 22 : ℚ)
    exact eq_smul_div (6) scale (3) (22) (by decide) (by decide)
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (3 / 22 : ℚ)
    exact eq_smul_div (6) scale (3) (22) (by decide) (by decide)

theorem AZ_scale_19 : toVec (AZ 19) = (scale : ℚ) • ACell19_1 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-6) scale (-3) (22) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-6) scale (-3) (22) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (3 / 22 : ℚ)
    exact eq_smul_div (6) scale (3) (22) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (3 / 22 : ℚ)
    exact eq_smul_div (6) scale (3) (22) (by decide) (by decide)

theorem AZ_scale (k : Fin 20) :
    toVec (AZ k) = (scale : ℚ) • AVec k (1 : Fin 10) := by
  fin_cases k
  · simp [AVec, ARow0]; exact AZ_scale_0
  · simp [AVec, ARow1]; exact AZ_scale_1
  · simp [AVec, ARow2]; exact AZ_scale_2
  · simp [AVec, ARow3]; exact AZ_scale_3
  · simp [AVec, ARow4]; exact AZ_scale_4
  · simp [AVec, ARow5]; exact AZ_scale_5
  · simp [AVec, ARow6]; exact AZ_scale_6
  · simp [AVec, ARow7]; exact AZ_scale_7
  · simp [AVec, ARow8]; exact AZ_scale_8
  · simp [AVec, ARow9]; exact AZ_scale_9
  · simp [AVec, ARow10]; exact AZ_scale_10
  · simp [AVec, ARow11]; exact AZ_scale_11
  · simp [AVec, ARow12]; exact AZ_scale_12
  · simp [AVec, ARow13]; exact AZ_scale_13
  · simp [AVec, ARow14]; exact AZ_scale_14
  · simp [AVec, ARow15]; exact AZ_scale_15
  · simp [AVec, ARow16]; exact AZ_scale_16
  · simp [AVec, ARow17]; exact AZ_scale_17
  · simp [AVec, ARow18]; exact AZ_scale_18
  · simp [AVec, ARow19]; exact AZ_scale_19

theorem KZ_scale_0 : toVec (KZ 0) = (scale : ℚ) • KCell7_0 := by
  funext i
  fin_cases i
  · change ((22 : ℤ) : ℚ) = (scale : ℚ) * (1 / 2 : ℚ)
    exact eq_smul_div (22) scale (1) (2) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-22 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 2 : ℚ)
    exact eq_smul_div (-22) scale (-1) (2) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((22 : ℤ) : ℚ) = (scale : ℚ) * (1 / 2 : ℚ)
    exact eq_smul_div (22) scale (1) (2) (by decide) (by decide)
  · change ((-22 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 2 : ℚ)
    exact eq_smul_div (-22) scale (-1) (2) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-22 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 2 : ℚ)
    exact eq_smul_div (-22) scale (-1) (2) (by decide) (by decide)

theorem KZ_scale (k : Fin 1) :
    toVec (KZ k) = (scale : ℚ) • KVec (7 : Fin 10) k := by
  fin_cases k
  · simp [KVec, KRow0]; exact KZ_scale_0

theorem YZ_scale_0 : toVec (YZ 0) = (scale : ℚ) • YCell0_1 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem YZ_scale (k : Fin 1) :
    toVec (YZ k) = (scale : ℚ) • YVec k (1 : Fin 10) := by
  fin_cases k
  · simp [YVec, YRow0]; exact YZ_scale_0

theorem entry_eq :
    (matrixMul XVec AVec + matrixMul KVec YVec)
        (7 : Fin 10) (1 : Fin 10) = ![0, 0, 0, 0, 0, 0, 0, 0, 0, 0] := by
  change (∑ k : Fin 20, mul (XVec (7 : Fin 10) k)
      (AVec k (1 : Fin 10))) +
    (∑ k : Fin 1, mul (KVec (7 : Fin 10) k)
      (YVec k (1 : Fin 10))) = _
  refine add_sum_mul_eq_of_scaled scale scale_ne_zero
    (fun k => XVec (7 : Fin 10) k)
    (fun k => AVec k (1 : Fin 10))
    (fun k => KVec (7 : Fin 10) k)
    (fun k => YVec k (1 : Fin 10))
    XZ AZ KZ YZ XZ_scale AZ_scale KZ_scale YZ_scale entryZ rfl _ ?_
  rw [entryZ_eq, toVec_zeroZ_smul, vec_zero_eq]

theorem entry_eq_matrixOne :
    (matrixMul XVec AVec + matrixMul KVec YVec)
        (7 : Fin 10) (1 : Fin 10) =
      matrixOne (Fin 10) (7 : Fin 10) (1 : Fin 10) := by
  rw [entry_eq]
  have hne : (7 : Fin 10) ≠ (1 : Fin 10) := by decide
  funext n
  fin_cases n <;> simp [matrixOne, constVec, basis, *]

end V14Formalization.D12PieceAASplitEntry7_1


namespace V14Formalization.D12PieceAASplitEntry7_2
open D12CyclotomicVec D12CyclotomicVecZ D12PieceAAData
def payloadSha256 : String := "76c6196f29afe1a8398af99502447f48ebeed4bcb3805fc5dbec693940bc04b0"

def scale : ℤ := 44

def XZ (k : Fin 20) : VecZ :=
  match k.val with
  | 0 => #v[18, -70, -4, 34, -33, -15, -19, 54, -77, 13]
  | 1 => #v[16, -17, 1, 5, -9, 11, -19, 17, 1, -6]
  | 2 => #v[-119, -2, -41, -108, -1, -99, 29, -164, 46, -113]
  | 3 => #v[32, 70, 43, 35, 11, 82, 0, 61, 39, 78]
  | 4 => #v[16, 3, -5, 24, 1, -7, 16, 15, -13, 16]
  | 5 => #v[-62, -104, -58, -50, -40, -144, -10, -86, -50, -144]
  | 6 => #v[38, -28, 24, 52, -16, 10, -18, 90, -46, 48]
  | 7 => #v[-138, -162, -84, -142, -82, -200, -30, -200, -42, -240]
  | 8 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  | 9 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  | 10 => #v[22, 22, 0, 22, -11, 22, 11, 11, 22, 0]
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
  | 0 => #v[4, -4, -4, -4, -4, 4, 0, 0, 8, 0]
  | 1 => #v[4, 4, 0, -4, 0, -4, 8, -4, 0, -4]
  | 2 => #v[32, -4, -8, -12, -8, -8, -12, -8, -4, -12]
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

def KZ (k : Fin 1) : VecZ :=
  match k.val with
  | 0 => #v[22, 0, -22, 0, 0, 0, 22, -22, 0, -22]
  | _ => zeroZ

def YZ (k : Fin 1) : VecZ :=
  match k.val with
  | 0 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  | _ => zeroZ

def xaEntryZ : VecZ := sumFin (fun k => mulZ (XZ k) (AZ k))
def kyEntryZ : VecZ := sumFin (fun k => mulZ (KZ k) (YZ k))
def entryZ : VecZ := addZ xaEntryZ kyEntryZ

theorem entryZ_eq : entryZ = zeroZ := by
  decide +kernel

theorem scale_ne_zero : scale ≠ 0 := by
  decide

theorem XZ_scale_0 : toVec (XZ 0) = (scale : ℚ) • XCell7_0 := by
  funext i
  fin_cases i
  · change ((18 : ℤ) : ℚ) = (scale : ℚ) * (9 / 22 : ℚ)
    exact eq_smul_div (18) scale (9) (22) (by decide) (by decide)
  · change ((-70 : ℤ) : ℚ) = (scale : ℚ) * (-35 / 22 : ℚ)
    exact eq_smul_div (-70) scale (-35) (22) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)
  · change ((34 : ℤ) : ℚ) = (scale : ℚ) * (17 / 22 : ℚ)
    exact eq_smul_div (34) scale (17) (22) (by decide) (by decide)
  · change ((-33 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 4 : ℚ)
    exact eq_smul_div (-33) scale (-3) (4) (by decide) (by decide)
  · change ((-15 : ℤ) : ℚ) = (scale : ℚ) * (-15 / 44 : ℚ)
    exact eq_smul_div (-15) scale (-15) (44) (by decide) (by decide)
  · change ((-19 : ℤ) : ℚ) = (scale : ℚ) * (-19 / 44 : ℚ)
    exact eq_smul_div (-19) scale (-19) (44) (by decide) (by decide)
  · change ((54 : ℤ) : ℚ) = (scale : ℚ) * (27 / 22 : ℚ)
    exact eq_smul_div (54) scale (27) (22) (by decide) (by decide)
  · change ((-77 : ℤ) : ℚ) = (scale : ℚ) * (-7 / 4 : ℚ)
    exact eq_smul_div (-77) scale (-7) (4) (by decide) (by decide)
  · change ((13 : ℤ) : ℚ) = (scale : ℚ) * (13 / 44 : ℚ)
    exact eq_smul_div (13) scale (13) (44) (by decide) (by decide)

theorem XZ_scale_1 : toVec (XZ 1) = (scale : ℚ) • XCell7_1 := by
  funext i
  fin_cases i
  · change ((16 : ℤ) : ℚ) = (scale : ℚ) * (4 / 11 : ℚ)
    exact eq_smul_div (16) scale (4) (11) (by decide) (by decide)
  · change ((-17 : ℤ) : ℚ) = (scale : ℚ) * (-17 / 44 : ℚ)
    exact eq_smul_div (-17) scale (-17) (44) (by decide) (by decide)
  · change ((1 : ℤ) : ℚ) = (scale : ℚ) * (1 / 44 : ℚ)
    exact eq_smul_div (1) scale (1) (44) (by decide) (by decide)
  · change ((5 : ℤ) : ℚ) = (scale : ℚ) * (5 / 44 : ℚ)
    exact eq_smul_div (5) scale (5) (44) (by decide) (by decide)
  · change ((-9 : ℤ) : ℚ) = (scale : ℚ) * (-9 / 44 : ℚ)
    exact eq_smul_div (-9) scale (-9) (44) (by decide) (by decide)
  · change ((11 : ℤ) : ℚ) = (scale : ℚ) * (1 / 4 : ℚ)
    exact eq_smul_div (11) scale (1) (4) (by decide) (by decide)
  · change ((-19 : ℤ) : ℚ) = (scale : ℚ) * (-19 / 44 : ℚ)
    exact eq_smul_div (-19) scale (-19) (44) (by decide) (by decide)
  · change ((17 : ℤ) : ℚ) = (scale : ℚ) * (17 / 44 : ℚ)
    exact eq_smul_div (17) scale (17) (44) (by decide) (by decide)
  · change ((1 : ℤ) : ℚ) = (scale : ℚ) * (1 / 44 : ℚ)
    exact eq_smul_div (1) scale (1) (44) (by decide) (by decide)
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-6) scale (-3) (22) (by decide) (by decide)

theorem XZ_scale_2 : toVec (XZ 2) = (scale : ℚ) • XCell7_2 := by
  funext i
  fin_cases i
  · change ((-119 : ℤ) : ℚ) = (scale : ℚ) * (-119 / 44 : ℚ)
    exact eq_smul_div (-119) scale (-119) (44) (by decide) (by decide)
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 22 : ℚ)
    exact eq_smul_div (-2) scale (-1) (22) (by decide) (by decide)
  · change ((-41 : ℤ) : ℚ) = (scale : ℚ) * (-41 / 44 : ℚ)
    exact eq_smul_div (-41) scale (-41) (44) (by decide) (by decide)
  · change ((-108 : ℤ) : ℚ) = (scale : ℚ) * (-27 / 11 : ℚ)
    exact eq_smul_div (-108) scale (-27) (11) (by decide) (by decide)
  · change ((-1 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 44 : ℚ)
    exact eq_smul_div (-1) scale (-1) (44) (by decide) (by decide)
  · change ((-99 : ℤ) : ℚ) = (scale : ℚ) * (-9 / 4 : ℚ)
    exact eq_smul_div (-99) scale (-9) (4) (by decide) (by decide)
  · change ((29 : ℤ) : ℚ) = (scale : ℚ) * (29 / 44 : ℚ)
    exact eq_smul_div (29) scale (29) (44) (by decide) (by decide)
  · change ((-164 : ℤ) : ℚ) = (scale : ℚ) * (-41 / 11 : ℚ)
    exact eq_smul_div (-164) scale (-41) (11) (by decide) (by decide)
  · change ((46 : ℤ) : ℚ) = (scale : ℚ) * (23 / 22 : ℚ)
    exact eq_smul_div (46) scale (23) (22) (by decide) (by decide)
  · change ((-113 : ℤ) : ℚ) = (scale : ℚ) * (-113 / 44 : ℚ)
    exact eq_smul_div (-113) scale (-113) (44) (by decide) (by decide)

theorem XZ_scale_3 : toVec (XZ 3) = (scale : ℚ) • XCell7_3 := by
  funext i
  fin_cases i
  · change ((32 : ℤ) : ℚ) = (scale : ℚ) * (8 / 11 : ℚ)
    exact eq_smul_div (32) scale (8) (11) (by decide) (by decide)
  · change ((70 : ℤ) : ℚ) = (scale : ℚ) * (35 / 22 : ℚ)
    exact eq_smul_div (70) scale (35) (22) (by decide) (by decide)
  · change ((43 : ℤ) : ℚ) = (scale : ℚ) * (43 / 44 : ℚ)
    exact eq_smul_div (43) scale (43) (44) (by decide) (by decide)
  · change ((35 : ℤ) : ℚ) = (scale : ℚ) * (35 / 44 : ℚ)
    exact eq_smul_div (35) scale (35) (44) (by decide) (by decide)
  · change ((11 : ℤ) : ℚ) = (scale : ℚ) * (1 / 4 : ℚ)
    exact eq_smul_div (11) scale (1) (4) (by decide) (by decide)
  · change ((82 : ℤ) : ℚ) = (scale : ℚ) * (41 / 22 : ℚ)
    exact eq_smul_div (82) scale (41) (22) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((61 : ℤ) : ℚ) = (scale : ℚ) * (61 / 44 : ℚ)
    exact eq_smul_div (61) scale (61) (44) (by decide) (by decide)
  · change ((39 : ℤ) : ℚ) = (scale : ℚ) * (39 / 44 : ℚ)
    exact eq_smul_div (39) scale (39) (44) (by decide) (by decide)
  · change ((78 : ℤ) : ℚ) = (scale : ℚ) * (39 / 22 : ℚ)
    exact eq_smul_div (78) scale (39) (22) (by decide) (by decide)

theorem XZ_scale_4 : toVec (XZ 4) = (scale : ℚ) • XCell7_4 := by
  funext i
  fin_cases i
  · change ((16 : ℤ) : ℚ) = (scale : ℚ) * (4 / 11 : ℚ)
    exact eq_smul_div (16) scale (4) (11) (by decide) (by decide)
  · change ((3 : ℤ) : ℚ) = (scale : ℚ) * (3 / 44 : ℚ)
    exact eq_smul_div (3) scale (3) (44) (by decide) (by decide)
  · change ((-5 : ℤ) : ℚ) = (scale : ℚ) * (-5 / 44 : ℚ)
    exact eq_smul_div (-5) scale (-5) (44) (by decide) (by decide)
  · change ((24 : ℤ) : ℚ) = (scale : ℚ) * (6 / 11 : ℚ)
    exact eq_smul_div (24) scale (6) (11) (by decide) (by decide)
  · change ((1 : ℤ) : ℚ) = (scale : ℚ) * (1 / 44 : ℚ)
    exact eq_smul_div (1) scale (1) (44) (by decide) (by decide)
  · change ((-7 : ℤ) : ℚ) = (scale : ℚ) * (-7 / 44 : ℚ)
    exact eq_smul_div (-7) scale (-7) (44) (by decide) (by decide)
  · change ((16 : ℤ) : ℚ) = (scale : ℚ) * (4 / 11 : ℚ)
    exact eq_smul_div (16) scale (4) (11) (by decide) (by decide)
  · change ((15 : ℤ) : ℚ) = (scale : ℚ) * (15 / 44 : ℚ)
    exact eq_smul_div (15) scale (15) (44) (by decide) (by decide)
  · change ((-13 : ℤ) : ℚ) = (scale : ℚ) * (-13 / 44 : ℚ)
    exact eq_smul_div (-13) scale (-13) (44) (by decide) (by decide)
  · change ((16 : ℤ) : ℚ) = (scale : ℚ) * (4 / 11 : ℚ)
    exact eq_smul_div (16) scale (4) (11) (by decide) (by decide)

theorem XZ_scale_5 : toVec (XZ 5) = (scale : ℚ) • XCell7_5 := by
  funext i
  fin_cases i
  · change ((-62 : ℤ) : ℚ) = (scale : ℚ) * (-31 / 22 : ℚ)
    exact eq_smul_div (-62) scale (-31) (22) (by decide) (by decide)
  · change ((-104 : ℤ) : ℚ) = (scale : ℚ) * (-26 / 11 : ℚ)
    exact eq_smul_div (-104) scale (-26) (11) (by decide) (by decide)
  · change ((-58 : ℤ) : ℚ) = (scale : ℚ) * (-29 / 22 : ℚ)
    exact eq_smul_div (-58) scale (-29) (22) (by decide) (by decide)
  · change ((-50 : ℤ) : ℚ) = (scale : ℚ) * (-25 / 22 : ℚ)
    exact eq_smul_div (-50) scale (-25) (22) (by decide) (by decide)
  · change ((-40 : ℤ) : ℚ) = (scale : ℚ) * (-10 / 11 : ℚ)
    exact eq_smul_div (-40) scale (-10) (11) (by decide) (by decide)
  · change ((-144 : ℤ) : ℚ) = (scale : ℚ) * (-36 / 11 : ℚ)
    exact eq_smul_div (-144) scale (-36) (11) (by decide) (by decide)
  · change ((-10 : ℤ) : ℚ) = (scale : ℚ) * (-5 / 22 : ℚ)
    exact eq_smul_div (-10) scale (-5) (22) (by decide) (by decide)
  · change ((-86 : ℤ) : ℚ) = (scale : ℚ) * (-43 / 22 : ℚ)
    exact eq_smul_div (-86) scale (-43) (22) (by decide) (by decide)
  · change ((-50 : ℤ) : ℚ) = (scale : ℚ) * (-25 / 22 : ℚ)
    exact eq_smul_div (-50) scale (-25) (22) (by decide) (by decide)
  · change ((-144 : ℤ) : ℚ) = (scale : ℚ) * (-36 / 11 : ℚ)
    exact eq_smul_div (-144) scale (-36) (11) (by decide) (by decide)

theorem XZ_scale_6 : toVec (XZ 6) = (scale : ℚ) • XCell7_6 := by
  funext i
  fin_cases i
  · change ((38 : ℤ) : ℚ) = (scale : ℚ) * (19 / 22 : ℚ)
    exact eq_smul_div (38) scale (19) (22) (by decide) (by decide)
  · change ((-28 : ℤ) : ℚ) = (scale : ℚ) * (-7 / 11 : ℚ)
    exact eq_smul_div (-28) scale (-7) (11) (by decide) (by decide)
  · change ((24 : ℤ) : ℚ) = (scale : ℚ) * (6 / 11 : ℚ)
    exact eq_smul_div (24) scale (6) (11) (by decide) (by decide)
  · change ((52 : ℤ) : ℚ) = (scale : ℚ) * (13 / 11 : ℚ)
    exact eq_smul_div (52) scale (13) (11) (by decide) (by decide)
  · change ((-16 : ℤ) : ℚ) = (scale : ℚ) * (-4 / 11 : ℚ)
    exact eq_smul_div (-16) scale (-4) (11) (by decide) (by decide)
  · change ((10 : ℤ) : ℚ) = (scale : ℚ) * (5 / 22 : ℚ)
    exact eq_smul_div (10) scale (5) (22) (by decide) (by decide)
  · change ((-18 : ℤ) : ℚ) = (scale : ℚ) * (-9 / 22 : ℚ)
    exact eq_smul_div (-18) scale (-9) (22) (by decide) (by decide)
  · change ((90 : ℤ) : ℚ) = (scale : ℚ) * (45 / 22 : ℚ)
    exact eq_smul_div (90) scale (45) (22) (by decide) (by decide)
  · change ((-46 : ℤ) : ℚ) = (scale : ℚ) * (-23 / 22 : ℚ)
    exact eq_smul_div (-46) scale (-23) (22) (by decide) (by decide)
  · change ((48 : ℤ) : ℚ) = (scale : ℚ) * (12 / 11 : ℚ)
    exact eq_smul_div (48) scale (12) (11) (by decide) (by decide)

theorem XZ_scale_7 : toVec (XZ 7) = (scale : ℚ) • XCell7_7 := by
  funext i
  fin_cases i
  · change ((-138 : ℤ) : ℚ) = (scale : ℚ) * (-69 / 22 : ℚ)
    exact eq_smul_div (-138) scale (-69) (22) (by decide) (by decide)
  · change ((-162 : ℤ) : ℚ) = (scale : ℚ) * (-81 / 22 : ℚ)
    exact eq_smul_div (-162) scale (-81) (22) (by decide) (by decide)
  · change ((-84 : ℤ) : ℚ) = (scale : ℚ) * (-21 / 11 : ℚ)
    exact eq_smul_div (-84) scale (-21) (11) (by decide) (by decide)
  · change ((-142 : ℤ) : ℚ) = (scale : ℚ) * (-71 / 22 : ℚ)
    exact eq_smul_div (-142) scale (-71) (22) (by decide) (by decide)
  · change ((-82 : ℤ) : ℚ) = (scale : ℚ) * (-41 / 22 : ℚ)
    exact eq_smul_div (-82) scale (-41) (22) (by decide) (by decide)
  · change ((-200 : ℤ) : ℚ) = (scale : ℚ) * (-50 / 11 : ℚ)
    exact eq_smul_div (-200) scale (-50) (11) (by decide) (by decide)
  · change ((-30 : ℤ) : ℚ) = (scale : ℚ) * (-15 / 22 : ℚ)
    exact eq_smul_div (-30) scale (-15) (22) (by decide) (by decide)
  · change ((-200 : ℤ) : ℚ) = (scale : ℚ) * (-50 / 11 : ℚ)
    exact eq_smul_div (-200) scale (-50) (11) (by decide) (by decide)
  · change ((-42 : ℤ) : ℚ) = (scale : ℚ) * (-21 / 22 : ℚ)
    exact eq_smul_div (-42) scale (-21) (22) (by decide) (by decide)
  · change ((-240 : ℤ) : ℚ) = (scale : ℚ) * (-60 / 11 : ℚ)
    exact eq_smul_div (-240) scale (-60) (11) (by decide) (by decide)

theorem XZ_scale_8 : toVec (XZ 8) = (scale : ℚ) • XCell7_8 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem XZ_scale_9 : toVec (XZ 9) = (scale : ℚ) • XCell7_9 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem XZ_scale_10 : toVec (XZ 10) = (scale : ℚ) • XCell7_10 := by
  funext i
  fin_cases i
  · change ((22 : ℤ) : ℚ) = (scale : ℚ) * (1 / 2 : ℚ)
    exact eq_smul_div (22) scale (1) (2) (by decide) (by decide)
  · change ((22 : ℤ) : ℚ) = (scale : ℚ) * (1 / 2 : ℚ)
    exact eq_smul_div (22) scale (1) (2) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((22 : ℤ) : ℚ) = (scale : ℚ) * (1 / 2 : ℚ)
    exact eq_smul_div (22) scale (1) (2) (by decide) (by decide)
  · change ((-11 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 4 : ℚ)
    exact eq_smul_div (-11) scale (-1) (4) (by decide) (by decide)
  · change ((22 : ℤ) : ℚ) = (scale : ℚ) * (1 / 2 : ℚ)
    exact eq_smul_div (22) scale (1) (2) (by decide) (by decide)
  · change ((11 : ℤ) : ℚ) = (scale : ℚ) * (1 / 4 : ℚ)
    exact eq_smul_div (11) scale (1) (4) (by decide) (by decide)
  · change ((11 : ℤ) : ℚ) = (scale : ℚ) * (1 / 4 : ℚ)
    exact eq_smul_div (11) scale (1) (4) (by decide) (by decide)
  · change ((22 : ℤ) : ℚ) = (scale : ℚ) * (1 / 2 : ℚ)
    exact eq_smul_div (22) scale (1) (2) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem XZ_scale_11 : toVec (XZ 11) = (scale : ℚ) • XCell7_11 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem XZ_scale_12 : toVec (XZ 12) = (scale : ℚ) • XCell7_12 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem XZ_scale_13 : toVec (XZ 13) = (scale : ℚ) • XCell7_13 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem XZ_scale_14 : toVec (XZ 14) = (scale : ℚ) • XCell7_14 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem XZ_scale_15 : toVec (XZ 15) = (scale : ℚ) • XCell7_15 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem XZ_scale_16 : toVec (XZ 16) = (scale : ℚ) • XCell7_16 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem XZ_scale_17 : toVec (XZ 17) = (scale : ℚ) • XCell7_17 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem XZ_scale_18 : toVec (XZ 18) = (scale : ℚ) • XCell7_18 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem XZ_scale_19 : toVec (XZ 19) = (scale : ℚ) • XCell7_19 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem XZ_scale (k : Fin 20) :
    toVec (XZ k) = (scale : ℚ) • XVec (7 : Fin 10) k := by
  fin_cases k
  · simp [XVec, XRow7]; exact XZ_scale_0
  · simp [XVec, XRow7]; exact XZ_scale_1
  · simp [XVec, XRow7]; exact XZ_scale_2
  · simp [XVec, XRow7]; exact XZ_scale_3
  · simp [XVec, XRow7]; exact XZ_scale_4
  · simp [XVec, XRow7]; exact XZ_scale_5
  · simp [XVec, XRow7]; exact XZ_scale_6
  · simp [XVec, XRow7]; exact XZ_scale_7
  · simp [XVec, XRow7]; exact XZ_scale_8
  · simp [XVec, XRow7]; exact XZ_scale_9
  · simp [XVec, XRow7]; exact XZ_scale_10
  · simp [XVec, XRow7]; exact XZ_scale_11
  · simp [XVec, XRow7]; exact XZ_scale_12
  · simp [XVec, XRow7]; exact XZ_scale_13
  · simp [XVec, XRow7]; exact XZ_scale_14
  · simp [XVec, XRow7]; exact XZ_scale_15
  · simp [XVec, XRow7]; exact XZ_scale_16
  · simp [XVec, XRow7]; exact XZ_scale_17
  · simp [XVec, XRow7]; exact XZ_scale_18
  · simp [XVec, XRow7]; exact XZ_scale_19

theorem AZ_scale_0 : toVec (AZ 0) = (scale : ℚ) • ACell0_2 := by
  funext i
  fin_cases i
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (4) scale (1) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (4) scale (1) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (8) scale (2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem AZ_scale_1 : toVec (AZ 1) = (scale : ℚ) • ACell1_2 := by
  funext i
  fin_cases i
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (4) scale (1) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (4) scale (1) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (8) scale (2) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)

theorem AZ_scale_2 : toVec (AZ 2) = (scale : ℚ) • ACell2_2 := by
  funext i
  fin_cases i
  · change ((32 : ℤ) : ℚ) = (scale : ℚ) * (8 / 11 : ℚ)
    exact eq_smul_div (32) scale (8) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-2) (11) (by decide) (by decide)
  · change ((-12 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 11 : ℚ)
    exact eq_smul_div (-12) scale (-3) (11) (by decide) (by decide)
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-2) (11) (by decide) (by decide)
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-2) (11) (by decide) (by decide)
  · change ((-12 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 11 : ℚ)
    exact eq_smul_div (-12) scale (-3) (11) (by decide) (by decide)
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-2) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)
  · change ((-12 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 11 : ℚ)
    exact eq_smul_div (-12) scale (-3) (11) (by decide) (by decide)

theorem AZ_scale_3 : toVec (AZ 3) = (scale : ℚ) • ACell3_2 := by
  funext i
  fin_cases i
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-2) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-2) (11) (by decide) (by decide)
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-2) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (4) scale (1) (11) (by decide) (by decide)

theorem AZ_scale_4 : toVec (AZ 4) = (scale : ℚ) • ACell4_2 := by
  funext i
  fin_cases i
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-2) (11) (by decide) (by decide)
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-2) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (4) scale (1) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-2) (11) (by decide) (by decide)
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)

theorem AZ_scale_5 : toVec (AZ 5) = (scale : ℚ) • ACell5_2 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-6) scale (-3) (22) (by decide) (by decide)
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (3 / 22 : ℚ)
    exact eq_smul_div (6) scale (3) (22) (by decide) (by decide)
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (3 / 22 : ℚ)
    exact eq_smul_div (6) scale (3) (22) (by decide) (by decide)
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-6) scale (-3) (22) (by decide) (by decide)

theorem AZ_scale_6 : toVec (AZ 6) = (scale : ℚ) • ACell6_2 := by
  funext i
  fin_cases i
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (3 / 22 : ℚ)
    exact eq_smul_div (6) scale (3) (22) (by decide) (by decide)
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (3 / 22 : ℚ)
    exact eq_smul_div (6) scale (3) (22) (by decide) (by decide)
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (3 / 22 : ℚ)
    exact eq_smul_div (6) scale (3) (22) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (3 / 22 : ℚ)
    exact eq_smul_div (6) scale (3) (22) (by decide) (by decide)
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (3 / 22 : ℚ)
    exact eq_smul_div (6) scale (3) (22) (by decide) (by decide)
  · change ((12 : ℤ) : ℚ) = (scale : ℚ) * (3 / 11 : ℚ)
    exact eq_smul_div (12) scale (3) (11) (by decide) (by decide)
  · change ((12 : ℤ) : ℚ) = (scale : ℚ) * (3 / 11 : ℚ)
    exact eq_smul_div (12) scale (3) (11) (by decide) (by decide)
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (3 / 22 : ℚ)
    exact eq_smul_div (6) scale (3) (22) (by decide) (by decide)
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (3 / 22 : ℚ)
    exact eq_smul_div (6) scale (3) (22) (by decide) (by decide)

theorem AZ_scale_7 : toVec (AZ 7) = (scale : ℚ) • ACell7_2 := by
  funext i
  fin_cases i
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-6) scale (-3) (22) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-6) scale (-3) (22) (by decide) (by decide)
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-6) scale (-3) (22) (by decide) (by decide)
  · change ((-12 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 11 : ℚ)
    exact eq_smul_div (-12) scale (-3) (11) (by decide) (by decide)
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-6) scale (-3) (22) (by decide) (by decide)
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-6) scale (-3) (22) (by decide) (by decide)
  · change ((-12 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 11 : ℚ)
    exact eq_smul_div (-12) scale (-3) (11) (by decide) (by decide)
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-6) scale (-3) (22) (by decide) (by decide)
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-6) scale (-3) (22) (by decide) (by decide)

theorem AZ_scale_8 : toVec (AZ 8) = (scale : ℚ) • ACell8_2 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-6) scale (-3) (22) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (3 / 22 : ℚ)
    exact eq_smul_div (6) scale (3) (22) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (3 / 22 : ℚ)
    exact eq_smul_div (6) scale (3) (22) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-6) scale (-3) (22) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem AZ_scale_9 : toVec (AZ 9) = (scale : ℚ) • ACell9_2 := by
  funext i
  fin_cases i
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (3 / 22 : ℚ)
    exact eq_smul_div (6) scale (3) (22) (by decide) (by decide)
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (3 / 22 : ℚ)
    exact eq_smul_div (6) scale (3) (22) (by decide) (by decide)
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (3 / 22 : ℚ)
    exact eq_smul_div (6) scale (3) (22) (by decide) (by decide)
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (3 / 22 : ℚ)
    exact eq_smul_div (6) scale (3) (22) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((12 : ℤ) : ℚ) = (scale : ℚ) * (3 / 11 : ℚ)
    exact eq_smul_div (12) scale (3) (11) (by decide) (by decide)
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (3 / 22 : ℚ)
    exact eq_smul_div (6) scale (3) (22) (by decide) (by decide)
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (3 / 22 : ℚ)
    exact eq_smul_div (6) scale (3) (22) (by decide) (by decide)
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (3 / 22 : ℚ)
    exact eq_smul_div (6) scale (3) (22) (by decide) (by decide)
  · change ((12 : ℤ) : ℚ) = (scale : ℚ) * (3 / 11 : ℚ)
    exact eq_smul_div (12) scale (3) (11) (by decide) (by decide)

theorem AZ_scale_10 : toVec (AZ 10) = (scale : ℚ) • ACell10_2 := by
  funext i
  fin_cases i
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (4) scale (1) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (4) scale (1) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (8) scale (2) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)

theorem AZ_scale_11 : toVec (AZ 11) = (scale : ℚ) • ACell11_2 := by
  funext i
  fin_cases i
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (8) scale (2) (11) (by decide) (by decide)
  · change ((12 : ℤ) : ℚ) = (scale : ℚ) * (3 / 11 : ℚ)
    exact eq_smul_div (12) scale (3) (11) (by decide) (by decide)
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (8) scale (2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (4) scale (1) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (4) scale (1) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (4) scale (1) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (4) scale (1) (11) (by decide) (by decide)

theorem AZ_scale_12 : toVec (AZ 12) = (scale : ℚ) • ACell12_2 := by
  funext i
  fin_cases i
  · change ((52 : ℤ) : ℚ) = (scale : ℚ) * (13 / 11 : ℚ)
    exact eq_smul_div (52) scale (13) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (4) scale (1) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (4) scale (1) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)

theorem AZ_scale_13 : toVec (AZ 13) = (scale : ℚ) • ACell13_2 := by
  funext i
  fin_cases i
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (4) scale (1) (11) (by decide) (by decide)
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (8) scale (2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((12 : ℤ) : ℚ) = (scale : ℚ) * (3 / 11 : ℚ)
    exact eq_smul_div (12) scale (3) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (8) scale (2) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (4) scale (1) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (4) scale (1) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (4) scale (1) (11) (by decide) (by decide)

theorem AZ_scale_14 : toVec (AZ 14) = (scale : ℚ) • ACell14_2 := by
  funext i
  fin_cases i
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-2) (11) (by decide) (by decide)
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-2) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)
  · change ((-12 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 11 : ℚ)
    exact eq_smul_div (-12) scale (-3) (11) (by decide) (by decide)
  · change ((-12 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 11 : ℚ)
    exact eq_smul_div (-12) scale (-3) (11) (by decide) (by decide)
  · change ((-12 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 11 : ℚ)
    exact eq_smul_div (-12) scale (-3) (11) (by decide) (by decide)
  · change ((-12 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 11 : ℚ)
    exact eq_smul_div (-12) scale (-3) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-2) (11) (by decide) (by decide)
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-2) (11) (by decide) (by decide)

theorem AZ_scale_15 : toVec (AZ 15) = (scale : ℚ) • ACell15_2 := by
  funext i
  fin_cases i
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (3 / 22 : ℚ)
    exact eq_smul_div (6) scale (3) (22) (by decide) (by decide)
  · change ((12 : ℤ) : ℚ) = (scale : ℚ) * (3 / 11 : ℚ)
    exact eq_smul_div (12) scale (3) (11) (by decide) (by decide)
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (3 / 22 : ℚ)
    exact eq_smul_div (6) scale (3) (22) (by decide) (by decide)
  · change ((12 : ℤ) : ℚ) = (scale : ℚ) * (3 / 11 : ℚ)
    exact eq_smul_div (12) scale (3) (11) (by decide) (by decide)
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (3 / 22 : ℚ)
    exact eq_smul_div (6) scale (3) (22) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (3 / 22 : ℚ)
    exact eq_smul_div (6) scale (3) (22) (by decide) (by decide)
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (3 / 22 : ℚ)
    exact eq_smul_div (6) scale (3) (22) (by decide) (by decide)
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (3 / 22 : ℚ)
    exact eq_smul_div (6) scale (3) (22) (by decide) (by decide)
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (3 / 22 : ℚ)
    exact eq_smul_div (6) scale (3) (22) (by decide) (by decide)

theorem AZ_scale_16 : toVec (AZ 16) = (scale : ℚ) • ACell16_2 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-6) scale (-3) (22) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (3 / 22 : ℚ)
    exact eq_smul_div (6) scale (3) (22) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (3 / 22 : ℚ)
    exact eq_smul_div (6) scale (3) (22) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-6) scale (-3) (22) (by decide) (by decide)

theorem AZ_scale_17 : toVec (AZ 17) = (scale : ℚ) • ACell17_2 := by
  funext i
  fin_cases i
  · change ((-12 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 11 : ℚ)
    exact eq_smul_div (-12) scale (-3) (11) (by decide) (by decide)
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-6) scale (-3) (22) (by decide) (by decide)
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-6) scale (-3) (22) (by decide) (by decide)
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-6) scale (-3) (22) (by decide) (by decide)
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-6) scale (-3) (22) (by decide) (by decide)
  · change ((-12 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 11 : ℚ)
    exact eq_smul_div (-12) scale (-3) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-6) scale (-3) (22) (by decide) (by decide)
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-6) scale (-3) (22) (by decide) (by decide)
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-6) scale (-3) (22) (by decide) (by decide)

theorem AZ_scale_18 : toVec (AZ 18) = (scale : ℚ) • ACell18_2 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-6) scale (-3) (22) (by decide) (by decide)
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-6) scale (-3) (22) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (3 / 22 : ℚ)
    exact eq_smul_div (6) scale (3) (22) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (3 / 22 : ℚ)
    exact eq_smul_div (6) scale (3) (22) (by decide) (by decide)

theorem AZ_scale_19 : toVec (AZ 19) = (scale : ℚ) • ACell19_2 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (3 / 22 : ℚ)
    exact eq_smul_div (6) scale (3) (22) (by decide) (by decide)
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-6) scale (-3) (22) (by decide) (by decide)
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-6) scale (-3) (22) (by decide) (by decide)
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (3 / 22 : ℚ)
    exact eq_smul_div (6) scale (3) (22) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem AZ_scale (k : Fin 20) :
    toVec (AZ k) = (scale : ℚ) • AVec k (2 : Fin 10) := by
  fin_cases k
  · simp [AVec, ARow0]; exact AZ_scale_0
  · simp [AVec, ARow1]; exact AZ_scale_1
  · simp [AVec, ARow2]; exact AZ_scale_2
  · simp [AVec, ARow3]; exact AZ_scale_3
  · simp [AVec, ARow4]; exact AZ_scale_4
  · simp [AVec, ARow5]; exact AZ_scale_5
  · simp [AVec, ARow6]; exact AZ_scale_6
  · simp [AVec, ARow7]; exact AZ_scale_7
  · simp [AVec, ARow8]; exact AZ_scale_8
  · simp [AVec, ARow9]; exact AZ_scale_9
  · simp [AVec, ARow10]; exact AZ_scale_10
  · simp [AVec, ARow11]; exact AZ_scale_11
  · simp [AVec, ARow12]; exact AZ_scale_12
  · simp [AVec, ARow13]; exact AZ_scale_13
  · simp [AVec, ARow14]; exact AZ_scale_14
  · simp [AVec, ARow15]; exact AZ_scale_15
  · simp [AVec, ARow16]; exact AZ_scale_16
  · simp [AVec, ARow17]; exact AZ_scale_17
  · simp [AVec, ARow18]; exact AZ_scale_18
  · simp [AVec, ARow19]; exact AZ_scale_19

theorem KZ_scale_0 : toVec (KZ 0) = (scale : ℚ) • KCell7_0 := by
  funext i
  fin_cases i
  · change ((22 : ℤ) : ℚ) = (scale : ℚ) * (1 / 2 : ℚ)
    exact eq_smul_div (22) scale (1) (2) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-22 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 2 : ℚ)
    exact eq_smul_div (-22) scale (-1) (2) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((22 : ℤ) : ℚ) = (scale : ℚ) * (1 / 2 : ℚ)
    exact eq_smul_div (22) scale (1) (2) (by decide) (by decide)
  · change ((-22 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 2 : ℚ)
    exact eq_smul_div (-22) scale (-1) (2) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-22 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 2 : ℚ)
    exact eq_smul_div (-22) scale (-1) (2) (by decide) (by decide)

theorem KZ_scale (k : Fin 1) :
    toVec (KZ k) = (scale : ℚ) • KVec (7 : Fin 10) k := by
  fin_cases k
  · simp [KVec, KRow0]; exact KZ_scale_0

theorem YZ_scale_0 : toVec (YZ 0) = (scale : ℚ) • YCell0_2 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem YZ_scale (k : Fin 1) :
    toVec (YZ k) = (scale : ℚ) • YVec k (2 : Fin 10) := by
  fin_cases k
  · simp [YVec, YRow0]; exact YZ_scale_0

theorem entry_eq :
    (matrixMul XVec AVec + matrixMul KVec YVec)
        (7 : Fin 10) (2 : Fin 10) = ![0, 0, 0, 0, 0, 0, 0, 0, 0, 0] := by
  change (∑ k : Fin 20, mul (XVec (7 : Fin 10) k)
      (AVec k (2 : Fin 10))) +
    (∑ k : Fin 1, mul (KVec (7 : Fin 10) k)
      (YVec k (2 : Fin 10))) = _
  refine add_sum_mul_eq_of_scaled scale scale_ne_zero
    (fun k => XVec (7 : Fin 10) k)
    (fun k => AVec k (2 : Fin 10))
    (fun k => KVec (7 : Fin 10) k)
    (fun k => YVec k (2 : Fin 10))
    XZ AZ KZ YZ XZ_scale AZ_scale KZ_scale YZ_scale entryZ rfl _ ?_
  rw [entryZ_eq, toVec_zeroZ_smul, vec_zero_eq]

theorem entry_eq_matrixOne :
    (matrixMul XVec AVec + matrixMul KVec YVec)
        (7 : Fin 10) (2 : Fin 10) =
      matrixOne (Fin 10) (7 : Fin 10) (2 : Fin 10) := by
  rw [entry_eq]
  have hne : (7 : Fin 10) ≠ (2 : Fin 10) := by decide
  funext n
  fin_cases n <;> simp [matrixOne, constVec, basis, *]

end V14Formalization.D12PieceAASplitEntry7_2


namespace V14Formalization.D12PieceAASplitEntry7_3
open D12CyclotomicVec D12CyclotomicVecZ D12PieceAAData
def payloadSha256 : String := "76c6196f29afe1a8398af99502447f48ebeed4bcb3805fc5dbec693940bc04b0"

def scale : ℤ := 44

def XZ (k : Fin 20) : VecZ :=
  match k.val with
  | 0 => #v[18, -70, -4, 34, -33, -15, -19, 54, -77, 13]
  | 1 => #v[16, -17, 1, 5, -9, 11, -19, 17, 1, -6]
  | 2 => #v[-119, -2, -41, -108, -1, -99, 29, -164, 46, -113]
  | 3 => #v[32, 70, 43, 35, 11, 82, 0, 61, 39, 78]
  | 4 => #v[16, 3, -5, 24, 1, -7, 16, 15, -13, 16]
  | 5 => #v[-62, -104, -58, -50, -40, -144, -10, -86, -50, -144]
  | 6 => #v[38, -28, 24, 52, -16, 10, -18, 90, -46, 48]
  | 7 => #v[-138, -162, -84, -142, -82, -200, -30, -200, -42, -240]
  | 8 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  | 9 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  | 10 => #v[22, 22, 0, 22, -11, 22, 11, 11, 22, 0]
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
  | 0 => #v[8, 4, 4, 8, 0, 0, 4, 12, 4, 0]
  | 1 => #v[0, 0, 8, 4, 4, 12, 4, 4, 8, 0]
  | 2 => #v[-8, -4, -4, -8, -8, -4, -4, -8, 0, 4]
  | 3 => #v[40, 0, 4, 4, 0, -4, 0, -4, 8, -4]
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

def KZ (k : Fin 1) : VecZ :=
  match k.val with
  | 0 => #v[22, 0, -22, 0, 0, 0, 22, -22, 0, -22]
  | _ => zeroZ

def YZ (k : Fin 1) : VecZ :=
  match k.val with
  | 0 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  | _ => zeroZ

def xaEntryZ : VecZ := sumFin (fun k => mulZ (XZ k) (AZ k))
def kyEntryZ : VecZ := sumFin (fun k => mulZ (KZ k) (YZ k))
def entryZ : VecZ := addZ xaEntryZ kyEntryZ

theorem entryZ_eq : entryZ = zeroZ := by
  decide +kernel

theorem scale_ne_zero : scale ≠ 0 := by
  decide

theorem XZ_scale_0 : toVec (XZ 0) = (scale : ℚ) • XCell7_0 := by
  funext i
  fin_cases i
  · change ((18 : ℤ) : ℚ) = (scale : ℚ) * (9 / 22 : ℚ)
    exact eq_smul_div (18) scale (9) (22) (by decide) (by decide)
  · change ((-70 : ℤ) : ℚ) = (scale : ℚ) * (-35 / 22 : ℚ)
    exact eq_smul_div (-70) scale (-35) (22) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)
  · change ((34 : ℤ) : ℚ) = (scale : ℚ) * (17 / 22 : ℚ)
    exact eq_smul_div (34) scale (17) (22) (by decide) (by decide)
  · change ((-33 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 4 : ℚ)
    exact eq_smul_div (-33) scale (-3) (4) (by decide) (by decide)
  · change ((-15 : ℤ) : ℚ) = (scale : ℚ) * (-15 / 44 : ℚ)
    exact eq_smul_div (-15) scale (-15) (44) (by decide) (by decide)
  · change ((-19 : ℤ) : ℚ) = (scale : ℚ) * (-19 / 44 : ℚ)
    exact eq_smul_div (-19) scale (-19) (44) (by decide) (by decide)
  · change ((54 : ℤ) : ℚ) = (scale : ℚ) * (27 / 22 : ℚ)
    exact eq_smul_div (54) scale (27) (22) (by decide) (by decide)
  · change ((-77 : ℤ) : ℚ) = (scale : ℚ) * (-7 / 4 : ℚ)
    exact eq_smul_div (-77) scale (-7) (4) (by decide) (by decide)
  · change ((13 : ℤ) : ℚ) = (scale : ℚ) * (13 / 44 : ℚ)
    exact eq_smul_div (13) scale (13) (44) (by decide) (by decide)

theorem XZ_scale_1 : toVec (XZ 1) = (scale : ℚ) • XCell7_1 := by
  funext i
  fin_cases i
  · change ((16 : ℤ) : ℚ) = (scale : ℚ) * (4 / 11 : ℚ)
    exact eq_smul_div (16) scale (4) (11) (by decide) (by decide)
  · change ((-17 : ℤ) : ℚ) = (scale : ℚ) * (-17 / 44 : ℚ)
    exact eq_smul_div (-17) scale (-17) (44) (by decide) (by decide)
  · change ((1 : ℤ) : ℚ) = (scale : ℚ) * (1 / 44 : ℚ)
    exact eq_smul_div (1) scale (1) (44) (by decide) (by decide)
  · change ((5 : ℤ) : ℚ) = (scale : ℚ) * (5 / 44 : ℚ)
    exact eq_smul_div (5) scale (5) (44) (by decide) (by decide)
  · change ((-9 : ℤ) : ℚ) = (scale : ℚ) * (-9 / 44 : ℚ)
    exact eq_smul_div (-9) scale (-9) (44) (by decide) (by decide)
  · change ((11 : ℤ) : ℚ) = (scale : ℚ) * (1 / 4 : ℚ)
    exact eq_smul_div (11) scale (1) (4) (by decide) (by decide)
  · change ((-19 : ℤ) : ℚ) = (scale : ℚ) * (-19 / 44 : ℚ)
    exact eq_smul_div (-19) scale (-19) (44) (by decide) (by decide)
  · change ((17 : ℤ) : ℚ) = (scale : ℚ) * (17 / 44 : ℚ)
    exact eq_smul_div (17) scale (17) (44) (by decide) (by decide)
  · change ((1 : ℤ) : ℚ) = (scale : ℚ) * (1 / 44 : ℚ)
    exact eq_smul_div (1) scale (1) (44) (by decide) (by decide)
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-6) scale (-3) (22) (by decide) (by decide)

theorem XZ_scale_2 : toVec (XZ 2) = (scale : ℚ) • XCell7_2 := by
  funext i
  fin_cases i
  · change ((-119 : ℤ) : ℚ) = (scale : ℚ) * (-119 / 44 : ℚ)
    exact eq_smul_div (-119) scale (-119) (44) (by decide) (by decide)
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 22 : ℚ)
    exact eq_smul_div (-2) scale (-1) (22) (by decide) (by decide)
  · change ((-41 : ℤ) : ℚ) = (scale : ℚ) * (-41 / 44 : ℚ)
    exact eq_smul_div (-41) scale (-41) (44) (by decide) (by decide)
  · change ((-108 : ℤ) : ℚ) = (scale : ℚ) * (-27 / 11 : ℚ)
    exact eq_smul_div (-108) scale (-27) (11) (by decide) (by decide)
  · change ((-1 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 44 : ℚ)
    exact eq_smul_div (-1) scale (-1) (44) (by decide) (by decide)
  · change ((-99 : ℤ) : ℚ) = (scale : ℚ) * (-9 / 4 : ℚ)
    exact eq_smul_div (-99) scale (-9) (4) (by decide) (by decide)
  · change ((29 : ℤ) : ℚ) = (scale : ℚ) * (29 / 44 : ℚ)
    exact eq_smul_div (29) scale (29) (44) (by decide) (by decide)
  · change ((-164 : ℤ) : ℚ) = (scale : ℚ) * (-41 / 11 : ℚ)
    exact eq_smul_div (-164) scale (-41) (11) (by decide) (by decide)
  · change ((46 : ℤ) : ℚ) = (scale : ℚ) * (23 / 22 : ℚ)
    exact eq_smul_div (46) scale (23) (22) (by decide) (by decide)
  · change ((-113 : ℤ) : ℚ) = (scale : ℚ) * (-113 / 44 : ℚ)
    exact eq_smul_div (-113) scale (-113) (44) (by decide) (by decide)

theorem XZ_scale_3 : toVec (XZ 3) = (scale : ℚ) • XCell7_3 := by
  funext i
  fin_cases i
  · change ((32 : ℤ) : ℚ) = (scale : ℚ) * (8 / 11 : ℚ)
    exact eq_smul_div (32) scale (8) (11) (by decide) (by decide)
  · change ((70 : ℤ) : ℚ) = (scale : ℚ) * (35 / 22 : ℚ)
    exact eq_smul_div (70) scale (35) (22) (by decide) (by decide)
  · change ((43 : ℤ) : ℚ) = (scale : ℚ) * (43 / 44 : ℚ)
    exact eq_smul_div (43) scale (43) (44) (by decide) (by decide)
  · change ((35 : ℤ) : ℚ) = (scale : ℚ) * (35 / 44 : ℚ)
    exact eq_smul_div (35) scale (35) (44) (by decide) (by decide)
  · change ((11 : ℤ) : ℚ) = (scale : ℚ) * (1 / 4 : ℚ)
    exact eq_smul_div (11) scale (1) (4) (by decide) (by decide)
  · change ((82 : ℤ) : ℚ) = (scale : ℚ) * (41 / 22 : ℚ)
    exact eq_smul_div (82) scale (41) (22) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((61 : ℤ) : ℚ) = (scale : ℚ) * (61 / 44 : ℚ)
    exact eq_smul_div (61) scale (61) (44) (by decide) (by decide)
  · change ((39 : ℤ) : ℚ) = (scale : ℚ) * (39 / 44 : ℚ)
    exact eq_smul_div (39) scale (39) (44) (by decide) (by decide)
  · change ((78 : ℤ) : ℚ) = (scale : ℚ) * (39 / 22 : ℚ)
    exact eq_smul_div (78) scale (39) (22) (by decide) (by decide)

theorem XZ_scale_4 : toVec (XZ 4) = (scale : ℚ) • XCell7_4 := by
  funext i
  fin_cases i
  · change ((16 : ℤ) : ℚ) = (scale : ℚ) * (4 / 11 : ℚ)
    exact eq_smul_div (16) scale (4) (11) (by decide) (by decide)
  · change ((3 : ℤ) : ℚ) = (scale : ℚ) * (3 / 44 : ℚ)
    exact eq_smul_div (3) scale (3) (44) (by decide) (by decide)
  · change ((-5 : ℤ) : ℚ) = (scale : ℚ) * (-5 / 44 : ℚ)
    exact eq_smul_div (-5) scale (-5) (44) (by decide) (by decide)
  · change ((24 : ℤ) : ℚ) = (scale : ℚ) * (6 / 11 : ℚ)
    exact eq_smul_div (24) scale (6) (11) (by decide) (by decide)
  · change ((1 : ℤ) : ℚ) = (scale : ℚ) * (1 / 44 : ℚ)
    exact eq_smul_div (1) scale (1) (44) (by decide) (by decide)
  · change ((-7 : ℤ) : ℚ) = (scale : ℚ) * (-7 / 44 : ℚ)
    exact eq_smul_div (-7) scale (-7) (44) (by decide) (by decide)
  · change ((16 : ℤ) : ℚ) = (scale : ℚ) * (4 / 11 : ℚ)
    exact eq_smul_div (16) scale (4) (11) (by decide) (by decide)
  · change ((15 : ℤ) : ℚ) = (scale : ℚ) * (15 / 44 : ℚ)
    exact eq_smul_div (15) scale (15) (44) (by decide) (by decide)
  · change ((-13 : ℤ) : ℚ) = (scale : ℚ) * (-13 / 44 : ℚ)
    exact eq_smul_div (-13) scale (-13) (44) (by decide) (by decide)
  · change ((16 : ℤ) : ℚ) = (scale : ℚ) * (4 / 11 : ℚ)
    exact eq_smul_div (16) scale (4) (11) (by decide) (by decide)

theorem XZ_scale_5 : toVec (XZ 5) = (scale : ℚ) • XCell7_5 := by
  funext i
  fin_cases i
  · change ((-62 : ℤ) : ℚ) = (scale : ℚ) * (-31 / 22 : ℚ)
    exact eq_smul_div (-62) scale (-31) (22) (by decide) (by decide)
  · change ((-104 : ℤ) : ℚ) = (scale : ℚ) * (-26 / 11 : ℚ)
    exact eq_smul_div (-104) scale (-26) (11) (by decide) (by decide)
  · change ((-58 : ℤ) : ℚ) = (scale : ℚ) * (-29 / 22 : ℚ)
    exact eq_smul_div (-58) scale (-29) (22) (by decide) (by decide)
  · change ((-50 : ℤ) : ℚ) = (scale : ℚ) * (-25 / 22 : ℚ)
    exact eq_smul_div (-50) scale (-25) (22) (by decide) (by decide)
  · change ((-40 : ℤ) : ℚ) = (scale : ℚ) * (-10 / 11 : ℚ)
    exact eq_smul_div (-40) scale (-10) (11) (by decide) (by decide)
  · change ((-144 : ℤ) : ℚ) = (scale : ℚ) * (-36 / 11 : ℚ)
    exact eq_smul_div (-144) scale (-36) (11) (by decide) (by decide)
  · change ((-10 : ℤ) : ℚ) = (scale : ℚ) * (-5 / 22 : ℚ)
    exact eq_smul_div (-10) scale (-5) (22) (by decide) (by decide)
  · change ((-86 : ℤ) : ℚ) = (scale : ℚ) * (-43 / 22 : ℚ)
    exact eq_smul_div (-86) scale (-43) (22) (by decide) (by decide)
  · change ((-50 : ℤ) : ℚ) = (scale : ℚ) * (-25 / 22 : ℚ)
    exact eq_smul_div (-50) scale (-25) (22) (by decide) (by decide)
  · change ((-144 : ℤ) : ℚ) = (scale : ℚ) * (-36 / 11 : ℚ)
    exact eq_smul_div (-144) scale (-36) (11) (by decide) (by decide)

theorem XZ_scale_6 : toVec (XZ 6) = (scale : ℚ) • XCell7_6 := by
  funext i
  fin_cases i
  · change ((38 : ℤ) : ℚ) = (scale : ℚ) * (19 / 22 : ℚ)
    exact eq_smul_div (38) scale (19) (22) (by decide) (by decide)
  · change ((-28 : ℤ) : ℚ) = (scale : ℚ) * (-7 / 11 : ℚ)
    exact eq_smul_div (-28) scale (-7) (11) (by decide) (by decide)
  · change ((24 : ℤ) : ℚ) = (scale : ℚ) * (6 / 11 : ℚ)
    exact eq_smul_div (24) scale (6) (11) (by decide) (by decide)
  · change ((52 : ℤ) : ℚ) = (scale : ℚ) * (13 / 11 : ℚ)
    exact eq_smul_div (52) scale (13) (11) (by decide) (by decide)
  · change ((-16 : ℤ) : ℚ) = (scale : ℚ) * (-4 / 11 : ℚ)
    exact eq_smul_div (-16) scale (-4) (11) (by decide) (by decide)
  · change ((10 : ℤ) : ℚ) = (scale : ℚ) * (5 / 22 : ℚ)
    exact eq_smul_div (10) scale (5) (22) (by decide) (by decide)
  · change ((-18 : ℤ) : ℚ) = (scale : ℚ) * (-9 / 22 : ℚ)
    exact eq_smul_div (-18) scale (-9) (22) (by decide) (by decide)
  · change ((90 : ℤ) : ℚ) = (scale : ℚ) * (45 / 22 : ℚ)
    exact eq_smul_div (90) scale (45) (22) (by decide) (by decide)
  · change ((-46 : ℤ) : ℚ) = (scale : ℚ) * (-23 / 22 : ℚ)
    exact eq_smul_div (-46) scale (-23) (22) (by decide) (by decide)
  · change ((48 : ℤ) : ℚ) = (scale : ℚ) * (12 / 11 : ℚ)
    exact eq_smul_div (48) scale (12) (11) (by decide) (by decide)

theorem XZ_scale_7 : toVec (XZ 7) = (scale : ℚ) • XCell7_7 := by
  funext i
  fin_cases i
  · change ((-138 : ℤ) : ℚ) = (scale : ℚ) * (-69 / 22 : ℚ)
    exact eq_smul_div (-138) scale (-69) (22) (by decide) (by decide)
  · change ((-162 : ℤ) : ℚ) = (scale : ℚ) * (-81 / 22 : ℚ)
    exact eq_smul_div (-162) scale (-81) (22) (by decide) (by decide)
  · change ((-84 : ℤ) : ℚ) = (scale : ℚ) * (-21 / 11 : ℚ)
    exact eq_smul_div (-84) scale (-21) (11) (by decide) (by decide)
  · change ((-142 : ℤ) : ℚ) = (scale : ℚ) * (-71 / 22 : ℚ)
    exact eq_smul_div (-142) scale (-71) (22) (by decide) (by decide)
  · change ((-82 : ℤ) : ℚ) = (scale : ℚ) * (-41 / 22 : ℚ)
    exact eq_smul_div (-82) scale (-41) (22) (by decide) (by decide)
  · change ((-200 : ℤ) : ℚ) = (scale : ℚ) * (-50 / 11 : ℚ)
    exact eq_smul_div (-200) scale (-50) (11) (by decide) (by decide)
  · change ((-30 : ℤ) : ℚ) = (scale : ℚ) * (-15 / 22 : ℚ)
    exact eq_smul_div (-30) scale (-15) (22) (by decide) (by decide)
  · change ((-200 : ℤ) : ℚ) = (scale : ℚ) * (-50 / 11 : ℚ)
    exact eq_smul_div (-200) scale (-50) (11) (by decide) (by decide)
  · change ((-42 : ℤ) : ℚ) = (scale : ℚ) * (-21 / 22 : ℚ)
    exact eq_smul_div (-42) scale (-21) (22) (by decide) (by decide)
  · change ((-240 : ℤ) : ℚ) = (scale : ℚ) * (-60 / 11 : ℚ)
    exact eq_smul_div (-240) scale (-60) (11) (by decide) (by decide)

theorem XZ_scale_8 : toVec (XZ 8) = (scale : ℚ) • XCell7_8 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem XZ_scale_9 : toVec (XZ 9) = (scale : ℚ) • XCell7_9 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem XZ_scale_10 : toVec (XZ 10) = (scale : ℚ) • XCell7_10 := by
  funext i
  fin_cases i
  · change ((22 : ℤ) : ℚ) = (scale : ℚ) * (1 / 2 : ℚ)
    exact eq_smul_div (22) scale (1) (2) (by decide) (by decide)
  · change ((22 : ℤ) : ℚ) = (scale : ℚ) * (1 / 2 : ℚ)
    exact eq_smul_div (22) scale (1) (2) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((22 : ℤ) : ℚ) = (scale : ℚ) * (1 / 2 : ℚ)
    exact eq_smul_div (22) scale (1) (2) (by decide) (by decide)
  · change ((-11 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 4 : ℚ)
    exact eq_smul_div (-11) scale (-1) (4) (by decide) (by decide)
  · change ((22 : ℤ) : ℚ) = (scale : ℚ) * (1 / 2 : ℚ)
    exact eq_smul_div (22) scale (1) (2) (by decide) (by decide)
  · change ((11 : ℤ) : ℚ) = (scale : ℚ) * (1 / 4 : ℚ)
    exact eq_smul_div (11) scale (1) (4) (by decide) (by decide)
  · change ((11 : ℤ) : ℚ) = (scale : ℚ) * (1 / 4 : ℚ)
    exact eq_smul_div (11) scale (1) (4) (by decide) (by decide)
  · change ((22 : ℤ) : ℚ) = (scale : ℚ) * (1 / 2 : ℚ)
    exact eq_smul_div (22) scale (1) (2) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem XZ_scale_11 : toVec (XZ 11) = (scale : ℚ) • XCell7_11 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem XZ_scale_12 : toVec (XZ 12) = (scale : ℚ) • XCell7_12 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem XZ_scale_13 : toVec (XZ 13) = (scale : ℚ) • XCell7_13 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem XZ_scale_14 : toVec (XZ 14) = (scale : ℚ) • XCell7_14 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem XZ_scale_15 : toVec (XZ 15) = (scale : ℚ) • XCell7_15 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem XZ_scale_16 : toVec (XZ 16) = (scale : ℚ) • XCell7_16 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem XZ_scale_17 : toVec (XZ 17) = (scale : ℚ) • XCell7_17 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem XZ_scale_18 : toVec (XZ 18) = (scale : ℚ) • XCell7_18 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem XZ_scale_19 : toVec (XZ 19) = (scale : ℚ) • XCell7_19 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem XZ_scale (k : Fin 20) :
    toVec (XZ k) = (scale : ℚ) • XVec (7 : Fin 10) k := by
  fin_cases k
  · simp [XVec, XRow7]; exact XZ_scale_0
  · simp [XVec, XRow7]; exact XZ_scale_1
  · simp [XVec, XRow7]; exact XZ_scale_2
  · simp [XVec, XRow7]; exact XZ_scale_3
  · simp [XVec, XRow7]; exact XZ_scale_4
  · simp [XVec, XRow7]; exact XZ_scale_5
  · simp [XVec, XRow7]; exact XZ_scale_6
  · simp [XVec, XRow7]; exact XZ_scale_7
  · simp [XVec, XRow7]; exact XZ_scale_8
  · simp [XVec, XRow7]; exact XZ_scale_9
  · simp [XVec, XRow7]; exact XZ_scale_10
  · simp [XVec, XRow7]; exact XZ_scale_11
  · simp [XVec, XRow7]; exact XZ_scale_12
  · simp [XVec, XRow7]; exact XZ_scale_13
  · simp [XVec, XRow7]; exact XZ_scale_14
  · simp [XVec, XRow7]; exact XZ_scale_15
  · simp [XVec, XRow7]; exact XZ_scale_16
  · simp [XVec, XRow7]; exact XZ_scale_17
  · simp [XVec, XRow7]; exact XZ_scale_18
  · simp [XVec, XRow7]; exact XZ_scale_19

theorem AZ_scale_0 : toVec (AZ 0) = (scale : ℚ) • ACell0_3 := by
  funext i
  fin_cases i
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (8) scale (2) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (4) scale (1) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (4) scale (1) (11) (by decide) (by decide)
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (8) scale (2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (4) scale (1) (11) (by decide) (by decide)
  · change ((12 : ℤ) : ℚ) = (scale : ℚ) * (3 / 11 : ℚ)
    exact eq_smul_div (12) scale (3) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (4) scale (1) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem AZ_scale_1 : toVec (AZ 1) = (scale : ℚ) • ACell1_3 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (8) scale (2) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (4) scale (1) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (4) scale (1) (11) (by decide) (by decide)
  · change ((12 : ℤ) : ℚ) = (scale : ℚ) * (3 / 11 : ℚ)
    exact eq_smul_div (12) scale (3) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (4) scale (1) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (4) scale (1) (11) (by decide) (by decide)
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (8) scale (2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem AZ_scale_2 : toVec (AZ 2) = (scale : ℚ) • ACell2_3 := by
  funext i
  fin_cases i
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-2) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-2) (11) (by decide) (by decide)
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-2) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (4) scale (1) (11) (by decide) (by decide)

theorem AZ_scale_3 : toVec (AZ 3) = (scale : ℚ) • ACell3_3 := by
  funext i
  fin_cases i
  · change ((40 : ℤ) : ℚ) = (scale : ℚ) * (10 / 11 : ℚ)
    exact eq_smul_div (40) scale (10) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (4) scale (1) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (4) scale (1) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (8) scale (2) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)

theorem AZ_scale_4 : toVec (AZ 4) = (scale : ℚ) • ACell4_3 := by
  funext i
  fin_cases i
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (4) scale (1) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (8) scale (2) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (4) scale (1) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)

theorem AZ_scale_5 : toVec (AZ 5) = (scale : ℚ) • ACell5_3 := by
  funext i
  fin_cases i
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (3 / 22 : ℚ)
    exact eq_smul_div (6) scale (3) (22) (by decide) (by decide)
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (3 / 22 : ℚ)
    exact eq_smul_div (6) scale (3) (22) (by decide) (by decide)
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (3 / 22 : ℚ)
    exact eq_smul_div (6) scale (3) (22) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((12 : ℤ) : ℚ) = (scale : ℚ) * (3 / 11 : ℚ)
    exact eq_smul_div (12) scale (3) (11) (by decide) (by decide)
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (3 / 22 : ℚ)
    exact eq_smul_div (6) scale (3) (22) (by decide) (by decide)
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (3 / 22 : ℚ)
    exact eq_smul_div (6) scale (3) (22) (by decide) (by decide)
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (3 / 22 : ℚ)
    exact eq_smul_div (6) scale (3) (22) (by decide) (by decide)
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (3 / 22 : ℚ)
    exact eq_smul_div (6) scale (3) (22) (by decide) (by decide)
  · change ((12 : ℤ) : ℚ) = (scale : ℚ) * (3 / 11 : ℚ)
    exact eq_smul_div (12) scale (3) (11) (by decide) (by decide)

theorem AZ_scale_6 : toVec (AZ 6) = (scale : ℚ) • ACell6_3 := by
  funext i
  fin_cases i
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (3 / 22 : ℚ)
    exact eq_smul_div (6) scale (3) (22) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (3 / 22 : ℚ)
    exact eq_smul_div (6) scale (3) (22) (by decide) (by decide)
  · change ((12 : ℤ) : ℚ) = (scale : ℚ) * (3 / 11 : ℚ)
    exact eq_smul_div (12) scale (3) (11) (by decide) (by decide)
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (3 / 22 : ℚ)
    exact eq_smul_div (6) scale (3) (22) (by decide) (by decide)
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (3 / 22 : ℚ)
    exact eq_smul_div (6) scale (3) (22) (by decide) (by decide)
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (3 / 22 : ℚ)
    exact eq_smul_div (6) scale (3) (22) (by decide) (by decide)
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (3 / 22 : ℚ)
    exact eq_smul_div (6) scale (3) (22) (by decide) (by decide)
  · change ((12 : ℤ) : ℚ) = (scale : ℚ) * (3 / 11 : ℚ)
    exact eq_smul_div (12) scale (3) (11) (by decide) (by decide)
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (3 / 22 : ℚ)
    exact eq_smul_div (6) scale (3) (22) (by decide) (by decide)

theorem AZ_scale_7 : toVec (AZ 7) = (scale : ℚ) • ACell7_3 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-6) scale (-3) (22) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (3 / 22 : ℚ)
    exact eq_smul_div (6) scale (3) (22) (by decide) (by decide)
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (3 / 22 : ℚ)
    exact eq_smul_div (6) scale (3) (22) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-6) scale (-3) (22) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem AZ_scale_8 : toVec (AZ 8) = (scale : ℚ) • ACell8_3 := by
  funext i
  fin_cases i
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (3 / 22 : ℚ)
    exact eq_smul_div (6) scale (3) (22) (by decide) (by decide)
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (3 / 22 : ℚ)
    exact eq_smul_div (6) scale (3) (22) (by decide) (by decide)
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (3 / 22 : ℚ)
    exact eq_smul_div (6) scale (3) (22) (by decide) (by decide)
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (3 / 22 : ℚ)
    exact eq_smul_div (6) scale (3) (22) (by decide) (by decide)
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (3 / 22 : ℚ)
    exact eq_smul_div (6) scale (3) (22) (by decide) (by decide)
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (3 / 22 : ℚ)
    exact eq_smul_div (6) scale (3) (22) (by decide) (by decide)
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (3 / 22 : ℚ)
    exact eq_smul_div (6) scale (3) (22) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((12 : ℤ) : ℚ) = (scale : ℚ) * (3 / 11 : ℚ)
    exact eq_smul_div (12) scale (3) (11) (by decide) (by decide)
  · change ((12 : ℤ) : ℚ) = (scale : ℚ) * (3 / 11 : ℚ)
    exact eq_smul_div (12) scale (3) (11) (by decide) (by decide)

theorem AZ_scale_9 : toVec (AZ 9) = (scale : ℚ) • ACell9_3 := by
  funext i
  fin_cases i
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (3 / 22 : ℚ)
    exact eq_smul_div (6) scale (3) (22) (by decide) (by decide)
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (3 / 22 : ℚ)
    exact eq_smul_div (6) scale (3) (22) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (3 / 22 : ℚ)
    exact eq_smul_div (6) scale (3) (22) (by decide) (by decide)
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (3 / 22 : ℚ)
    exact eq_smul_div (6) scale (3) (22) (by decide) (by decide)
  · change ((12 : ℤ) : ℚ) = (scale : ℚ) * (3 / 11 : ℚ)
    exact eq_smul_div (12) scale (3) (11) (by decide) (by decide)
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (3 / 22 : ℚ)
    exact eq_smul_div (6) scale (3) (22) (by decide) (by decide)
  · change ((12 : ℤ) : ℚ) = (scale : ℚ) * (3 / 11 : ℚ)
    exact eq_smul_div (12) scale (3) (11) (by decide) (by decide)
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (3 / 22 : ℚ)
    exact eq_smul_div (6) scale (3) (22) (by decide) (by decide)
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (3 / 22 : ℚ)
    exact eq_smul_div (6) scale (3) (22) (by decide) (by decide)

theorem AZ_scale_10 : toVec (AZ 10) = (scale : ℚ) • ACell10_3 := by
  funext i
  fin_cases i
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (8) scale (2) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (4) scale (1) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (4) scale (1) (11) (by decide) (by decide)
  · change ((12 : ℤ) : ℚ) = (scale : ℚ) * (3 / 11 : ℚ)
    exact eq_smul_div (12) scale (3) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (4) scale (1) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (4) scale (1) (11) (by decide) (by decide)
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (8) scale (2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem AZ_scale_11 : toVec (AZ 11) = (scale : ℚ) • ACell11_3 := by
  funext i
  fin_cases i
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (4) scale (1) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (4) scale (1) (11) (by decide) (by decide)
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (8) scale (2) (11) (by decide) (by decide)
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (8) scale (2) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (4) scale (1) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (4) scale (1) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((12 : ℤ) : ℚ) = (scale : ℚ) * (3 / 11 : ℚ)
    exact eq_smul_div (12) scale (3) (11) (by decide) (by decide)

theorem AZ_scale_12 : toVec (AZ 12) = (scale : ℚ) • ACell12_3 := by
  funext i
  fin_cases i
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-2) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-2) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-2) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (4) scale (1) (11) (by decide) (by decide)
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-2) (11) (by decide) (by decide)

theorem AZ_scale_13 : toVec (AZ 13) = (scale : ℚ) • ACell13_3 := by
  funext i
  fin_cases i
  · change ((48 : ℤ) : ℚ) = (scale : ℚ) * (12 / 11 : ℚ)
    exact eq_smul_div (48) scale (12) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-2) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-2) (11) (by decide) (by decide)
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-2) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-2) (11) (by decide) (by decide)

theorem AZ_scale_14 : toVec (AZ 14) = (scale : ℚ) • ACell14_3 := by
  funext i
  fin_cases i
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (8) scale (2) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (4) scale (1) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (4) scale (1) (11) (by decide) (by decide)
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (8) scale (2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (4) scale (1) (11) (by decide) (by decide)
  · change ((12 : ℤ) : ℚ) = (scale : ℚ) * (3 / 11 : ℚ)
    exact eq_smul_div (12) scale (3) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (4) scale (1) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem AZ_scale_15 : toVec (AZ 15) = (scale : ℚ) • ACell15_3 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-6) scale (-3) (22) (by decide) (by decide)
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (3 / 22 : ℚ)
    exact eq_smul_div (6) scale (3) (22) (by decide) (by decide)
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (3 / 22 : ℚ)
    exact eq_smul_div (6) scale (3) (22) (by decide) (by decide)
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-6) scale (-3) (22) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem AZ_scale_16 : toVec (AZ 16) = (scale : ℚ) • ACell16_3 := by
  funext i
  fin_cases i
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-6) scale (-3) (22) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-6) scale (-3) (22) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (3 / 22 : ℚ)
    exact eq_smul_div (6) scale (3) (22) (by decide) (by decide)
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (3 / 22 : ℚ)
    exact eq_smul_div (6) scale (3) (22) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem AZ_scale_17 : toVec (AZ 17) = (scale : ℚ) • ACell17_3 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-6) scale (-3) (22) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (3 / 22 : ℚ)
    exact eq_smul_div (6) scale (3) (22) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (3 / 22 : ℚ)
    exact eq_smul_div (6) scale (3) (22) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-6) scale (-3) (22) (by decide) (by decide)

theorem AZ_scale_18 : toVec (AZ 18) = (scale : ℚ) • ACell18_3 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-6) scale (-3) (22) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (3 / 22 : ℚ)
    exact eq_smul_div (6) scale (3) (22) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (3 / 22 : ℚ)
    exact eq_smul_div (6) scale (3) (22) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-6) scale (-3) (22) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem AZ_scale_19 : toVec (AZ 19) = (scale : ℚ) • ACell19_3 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-6) scale (-3) (22) (by decide) (by decide)
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (3 / 22 : ℚ)
    exact eq_smul_div (6) scale (3) (22) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (3 / 22 : ℚ)
    exact eq_smul_div (6) scale (3) (22) (by decide) (by decide)
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-6) scale (-3) (22) (by decide) (by decide)

theorem AZ_scale (k : Fin 20) :
    toVec (AZ k) = (scale : ℚ) • AVec k (3 : Fin 10) := by
  fin_cases k
  · simp [AVec, ARow0]; exact AZ_scale_0
  · simp [AVec, ARow1]; exact AZ_scale_1
  · simp [AVec, ARow2]; exact AZ_scale_2
  · simp [AVec, ARow3]; exact AZ_scale_3
  · simp [AVec, ARow4]; exact AZ_scale_4
  · simp [AVec, ARow5]; exact AZ_scale_5
  · simp [AVec, ARow6]; exact AZ_scale_6
  · simp [AVec, ARow7]; exact AZ_scale_7
  · simp [AVec, ARow8]; exact AZ_scale_8
  · simp [AVec, ARow9]; exact AZ_scale_9
  · simp [AVec, ARow10]; exact AZ_scale_10
  · simp [AVec, ARow11]; exact AZ_scale_11
  · simp [AVec, ARow12]; exact AZ_scale_12
  · simp [AVec, ARow13]; exact AZ_scale_13
  · simp [AVec, ARow14]; exact AZ_scale_14
  · simp [AVec, ARow15]; exact AZ_scale_15
  · simp [AVec, ARow16]; exact AZ_scale_16
  · simp [AVec, ARow17]; exact AZ_scale_17
  · simp [AVec, ARow18]; exact AZ_scale_18
  · simp [AVec, ARow19]; exact AZ_scale_19

theorem KZ_scale_0 : toVec (KZ 0) = (scale : ℚ) • KCell7_0 := by
  funext i
  fin_cases i
  · change ((22 : ℤ) : ℚ) = (scale : ℚ) * (1 / 2 : ℚ)
    exact eq_smul_div (22) scale (1) (2) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-22 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 2 : ℚ)
    exact eq_smul_div (-22) scale (-1) (2) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((22 : ℤ) : ℚ) = (scale : ℚ) * (1 / 2 : ℚ)
    exact eq_smul_div (22) scale (1) (2) (by decide) (by decide)
  · change ((-22 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 2 : ℚ)
    exact eq_smul_div (-22) scale (-1) (2) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-22 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 2 : ℚ)
    exact eq_smul_div (-22) scale (-1) (2) (by decide) (by decide)

theorem KZ_scale (k : Fin 1) :
    toVec (KZ k) = (scale : ℚ) • KVec (7 : Fin 10) k := by
  fin_cases k
  · simp [KVec, KRow0]; exact KZ_scale_0

theorem YZ_scale_0 : toVec (YZ 0) = (scale : ℚ) • YCell0_3 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem YZ_scale (k : Fin 1) :
    toVec (YZ k) = (scale : ℚ) • YVec k (3 : Fin 10) := by
  fin_cases k
  · simp [YVec, YRow0]; exact YZ_scale_0

theorem entry_eq :
    (matrixMul XVec AVec + matrixMul KVec YVec)
        (7 : Fin 10) (3 : Fin 10) = ![0, 0, 0, 0, 0, 0, 0, 0, 0, 0] := by
  change (∑ k : Fin 20, mul (XVec (7 : Fin 10) k)
      (AVec k (3 : Fin 10))) +
    (∑ k : Fin 1, mul (KVec (7 : Fin 10) k)
      (YVec k (3 : Fin 10))) = _
  refine add_sum_mul_eq_of_scaled scale scale_ne_zero
    (fun k => XVec (7 : Fin 10) k)
    (fun k => AVec k (3 : Fin 10))
    (fun k => KVec (7 : Fin 10) k)
    (fun k => YVec k (3 : Fin 10))
    XZ AZ KZ YZ XZ_scale AZ_scale KZ_scale YZ_scale entryZ rfl _ ?_
  rw [entryZ_eq, toVec_zeroZ_smul, vec_zero_eq]

theorem entry_eq_matrixOne :
    (matrixMul XVec AVec + matrixMul KVec YVec)
        (7 : Fin 10) (3 : Fin 10) =
      matrixOne (Fin 10) (7 : Fin 10) (3 : Fin 10) := by
  rw [entry_eq]
  have hne : (7 : Fin 10) ≠ (3 : Fin 10) := by decide
  funext n
  fin_cases n <;> simp [matrixOne, constVec, basis, *]

end V14Formalization.D12PieceAASplitEntry7_3


namespace V14Formalization.D12PieceAASplitEntry7_4
open D12CyclotomicVec D12CyclotomicVecZ D12PieceAAData
def payloadSha256 : String := "76c6196f29afe1a8398af99502447f48ebeed4bcb3805fc5dbec693940bc04b0"

def scale : ℤ := 44

def XZ (k : Fin 20) : VecZ :=
  match k.val with
  | 0 => #v[18, -70, -4, 34, -33, -15, -19, 54, -77, 13]
  | 1 => #v[16, -17, 1, 5, -9, 11, -19, 17, 1, -6]
  | 2 => #v[-119, -2, -41, -108, -1, -99, 29, -164, 46, -113]
  | 3 => #v[32, 70, 43, 35, 11, 82, 0, 61, 39, 78]
  | 4 => #v[16, 3, -5, 24, 1, -7, 16, 15, -13, 16]
  | 5 => #v[-62, -104, -58, -50, -40, -144, -10, -86, -50, -144]
  | 6 => #v[38, -28, 24, 52, -16, 10, -18, 90, -46, 48]
  | 7 => #v[-138, -162, -84, -142, -82, -200, -30, -200, -42, -240]
  | 8 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  | 9 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  | 10 => #v[22, 22, 0, 22, -11, 22, 11, 11, 22, 0]
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
  | 0 => #v[-4, 8, -4, 0, -4, 0, 4, 4, 0, -4]
  | 1 => #v[-4, -12, -8, -8, -12, -12, -8, -8, -12, -4]
  | 2 => #v[-8, -8, -4, 4, -4, -8, -8, 0, -4, -4]
  | 3 => #v[4, -4, 8, -4, 4, 0, -4, 0, 0, -4]
  | 4 => #v[36, -8, -8, -8, 0, -4, -4, 4, -4, -4]
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

def KZ (k : Fin 1) : VecZ :=
  match k.val with
  | 0 => #v[22, 0, -22, 0, 0, 0, 22, -22, 0, -22]
  | _ => zeroZ

def YZ (k : Fin 1) : VecZ :=
  match k.val with
  | 0 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  | _ => zeroZ

def xaEntryZ : VecZ := sumFin (fun k => mulZ (XZ k) (AZ k))
def kyEntryZ : VecZ := sumFin (fun k => mulZ (KZ k) (YZ k))
def entryZ : VecZ := addZ xaEntryZ kyEntryZ

theorem entryZ_eq : entryZ = zeroZ := by
  decide +kernel

theorem scale_ne_zero : scale ≠ 0 := by
  decide

theorem XZ_scale_0 : toVec (XZ 0) = (scale : ℚ) • XCell7_0 := by
  funext i
  fin_cases i
  · change ((18 : ℤ) : ℚ) = (scale : ℚ) * (9 / 22 : ℚ)
    exact eq_smul_div (18) scale (9) (22) (by decide) (by decide)
  · change ((-70 : ℤ) : ℚ) = (scale : ℚ) * (-35 / 22 : ℚ)
    exact eq_smul_div (-70) scale (-35) (22) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)
  · change ((34 : ℤ) : ℚ) = (scale : ℚ) * (17 / 22 : ℚ)
    exact eq_smul_div (34) scale (17) (22) (by decide) (by decide)
  · change ((-33 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 4 : ℚ)
    exact eq_smul_div (-33) scale (-3) (4) (by decide) (by decide)
  · change ((-15 : ℤ) : ℚ) = (scale : ℚ) * (-15 / 44 : ℚ)
    exact eq_smul_div (-15) scale (-15) (44) (by decide) (by decide)
  · change ((-19 : ℤ) : ℚ) = (scale : ℚ) * (-19 / 44 : ℚ)
    exact eq_smul_div (-19) scale (-19) (44) (by decide) (by decide)
  · change ((54 : ℤ) : ℚ) = (scale : ℚ) * (27 / 22 : ℚ)
    exact eq_smul_div (54) scale (27) (22) (by decide) (by decide)
  · change ((-77 : ℤ) : ℚ) = (scale : ℚ) * (-7 / 4 : ℚ)
    exact eq_smul_div (-77) scale (-7) (4) (by decide) (by decide)
  · change ((13 : ℤ) : ℚ) = (scale : ℚ) * (13 / 44 : ℚ)
    exact eq_smul_div (13) scale (13) (44) (by decide) (by decide)

theorem XZ_scale_1 : toVec (XZ 1) = (scale : ℚ) • XCell7_1 := by
  funext i
  fin_cases i
  · change ((16 : ℤ) : ℚ) = (scale : ℚ) * (4 / 11 : ℚ)
    exact eq_smul_div (16) scale (4) (11) (by decide) (by decide)
  · change ((-17 : ℤ) : ℚ) = (scale : ℚ) * (-17 / 44 : ℚ)
    exact eq_smul_div (-17) scale (-17) (44) (by decide) (by decide)
  · change ((1 : ℤ) : ℚ) = (scale : ℚ) * (1 / 44 : ℚ)
    exact eq_smul_div (1) scale (1) (44) (by decide) (by decide)
  · change ((5 : ℤ) : ℚ) = (scale : ℚ) * (5 / 44 : ℚ)
    exact eq_smul_div (5) scale (5) (44) (by decide) (by decide)
  · change ((-9 : ℤ) : ℚ) = (scale : ℚ) * (-9 / 44 : ℚ)
    exact eq_smul_div (-9) scale (-9) (44) (by decide) (by decide)
  · change ((11 : ℤ) : ℚ) = (scale : ℚ) * (1 / 4 : ℚ)
    exact eq_smul_div (11) scale (1) (4) (by decide) (by decide)
  · change ((-19 : ℤ) : ℚ) = (scale : ℚ) * (-19 / 44 : ℚ)
    exact eq_smul_div (-19) scale (-19) (44) (by decide) (by decide)
  · change ((17 : ℤ) : ℚ) = (scale : ℚ) * (17 / 44 : ℚ)
    exact eq_smul_div (17) scale (17) (44) (by decide) (by decide)
  · change ((1 : ℤ) : ℚ) = (scale : ℚ) * (1 / 44 : ℚ)
    exact eq_smul_div (1) scale (1) (44) (by decide) (by decide)
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-6) scale (-3) (22) (by decide) (by decide)

theorem XZ_scale_2 : toVec (XZ 2) = (scale : ℚ) • XCell7_2 := by
  funext i
  fin_cases i
  · change ((-119 : ℤ) : ℚ) = (scale : ℚ) * (-119 / 44 : ℚ)
    exact eq_smul_div (-119) scale (-119) (44) (by decide) (by decide)
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 22 : ℚ)
    exact eq_smul_div (-2) scale (-1) (22) (by decide) (by decide)
  · change ((-41 : ℤ) : ℚ) = (scale : ℚ) * (-41 / 44 : ℚ)
    exact eq_smul_div (-41) scale (-41) (44) (by decide) (by decide)
  · change ((-108 : ℤ) : ℚ) = (scale : ℚ) * (-27 / 11 : ℚ)
    exact eq_smul_div (-108) scale (-27) (11) (by decide) (by decide)
  · change ((-1 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 44 : ℚ)
    exact eq_smul_div (-1) scale (-1) (44) (by decide) (by decide)
  · change ((-99 : ℤ) : ℚ) = (scale : ℚ) * (-9 / 4 : ℚ)
    exact eq_smul_div (-99) scale (-9) (4) (by decide) (by decide)
  · change ((29 : ℤ) : ℚ) = (scale : ℚ) * (29 / 44 : ℚ)
    exact eq_smul_div (29) scale (29) (44) (by decide) (by decide)
  · change ((-164 : ℤ) : ℚ) = (scale : ℚ) * (-41 / 11 : ℚ)
    exact eq_smul_div (-164) scale (-41) (11) (by decide) (by decide)
  · change ((46 : ℤ) : ℚ) = (scale : ℚ) * (23 / 22 : ℚ)
    exact eq_smul_div (46) scale (23) (22) (by decide) (by decide)
  · change ((-113 : ℤ) : ℚ) = (scale : ℚ) * (-113 / 44 : ℚ)
    exact eq_smul_div (-113) scale (-113) (44) (by decide) (by decide)

theorem XZ_scale_3 : toVec (XZ 3) = (scale : ℚ) • XCell7_3 := by
  funext i
  fin_cases i
  · change ((32 : ℤ) : ℚ) = (scale : ℚ) * (8 / 11 : ℚ)
    exact eq_smul_div (32) scale (8) (11) (by decide) (by decide)
  · change ((70 : ℤ) : ℚ) = (scale : ℚ) * (35 / 22 : ℚ)
    exact eq_smul_div (70) scale (35) (22) (by decide) (by decide)
  · change ((43 : ℤ) : ℚ) = (scale : ℚ) * (43 / 44 : ℚ)
    exact eq_smul_div (43) scale (43) (44) (by decide) (by decide)
  · change ((35 : ℤ) : ℚ) = (scale : ℚ) * (35 / 44 : ℚ)
    exact eq_smul_div (35) scale (35) (44) (by decide) (by decide)
  · change ((11 : ℤ) : ℚ) = (scale : ℚ) * (1 / 4 : ℚ)
    exact eq_smul_div (11) scale (1) (4) (by decide) (by decide)
  · change ((82 : ℤ) : ℚ) = (scale : ℚ) * (41 / 22 : ℚ)
    exact eq_smul_div (82) scale (41) (22) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((61 : ℤ) : ℚ) = (scale : ℚ) * (61 / 44 : ℚ)
    exact eq_smul_div (61) scale (61) (44) (by decide) (by decide)
  · change ((39 : ℤ) : ℚ) = (scale : ℚ) * (39 / 44 : ℚ)
    exact eq_smul_div (39) scale (39) (44) (by decide) (by decide)
  · change ((78 : ℤ) : ℚ) = (scale : ℚ) * (39 / 22 : ℚ)
    exact eq_smul_div (78) scale (39) (22) (by decide) (by decide)

theorem XZ_scale_4 : toVec (XZ 4) = (scale : ℚ) • XCell7_4 := by
  funext i
  fin_cases i
  · change ((16 : ℤ) : ℚ) = (scale : ℚ) * (4 / 11 : ℚ)
    exact eq_smul_div (16) scale (4) (11) (by decide) (by decide)
  · change ((3 : ℤ) : ℚ) = (scale : ℚ) * (3 / 44 : ℚ)
    exact eq_smul_div (3) scale (3) (44) (by decide) (by decide)
  · change ((-5 : ℤ) : ℚ) = (scale : ℚ) * (-5 / 44 : ℚ)
    exact eq_smul_div (-5) scale (-5) (44) (by decide) (by decide)
  · change ((24 : ℤ) : ℚ) = (scale : ℚ) * (6 / 11 : ℚ)
    exact eq_smul_div (24) scale (6) (11) (by decide) (by decide)
  · change ((1 : ℤ) : ℚ) = (scale : ℚ) * (1 / 44 : ℚ)
    exact eq_smul_div (1) scale (1) (44) (by decide) (by decide)
  · change ((-7 : ℤ) : ℚ) = (scale : ℚ) * (-7 / 44 : ℚ)
    exact eq_smul_div (-7) scale (-7) (44) (by decide) (by decide)
  · change ((16 : ℤ) : ℚ) = (scale : ℚ) * (4 / 11 : ℚ)
    exact eq_smul_div (16) scale (4) (11) (by decide) (by decide)
  · change ((15 : ℤ) : ℚ) = (scale : ℚ) * (15 / 44 : ℚ)
    exact eq_smul_div (15) scale (15) (44) (by decide) (by decide)
  · change ((-13 : ℤ) : ℚ) = (scale : ℚ) * (-13 / 44 : ℚ)
    exact eq_smul_div (-13) scale (-13) (44) (by decide) (by decide)
  · change ((16 : ℤ) : ℚ) = (scale : ℚ) * (4 / 11 : ℚ)
    exact eq_smul_div (16) scale (4) (11) (by decide) (by decide)

theorem XZ_scale_5 : toVec (XZ 5) = (scale : ℚ) • XCell7_5 := by
  funext i
  fin_cases i
  · change ((-62 : ℤ) : ℚ) = (scale : ℚ) * (-31 / 22 : ℚ)
    exact eq_smul_div (-62) scale (-31) (22) (by decide) (by decide)
  · change ((-104 : ℤ) : ℚ) = (scale : ℚ) * (-26 / 11 : ℚ)
    exact eq_smul_div (-104) scale (-26) (11) (by decide) (by decide)
  · change ((-58 : ℤ) : ℚ) = (scale : ℚ) * (-29 / 22 : ℚ)
    exact eq_smul_div (-58) scale (-29) (22) (by decide) (by decide)
  · change ((-50 : ℤ) : ℚ) = (scale : ℚ) * (-25 / 22 : ℚ)
    exact eq_smul_div (-50) scale (-25) (22) (by decide) (by decide)
  · change ((-40 : ℤ) : ℚ) = (scale : ℚ) * (-10 / 11 : ℚ)
    exact eq_smul_div (-40) scale (-10) (11) (by decide) (by decide)
  · change ((-144 : ℤ) : ℚ) = (scale : ℚ) * (-36 / 11 : ℚ)
    exact eq_smul_div (-144) scale (-36) (11) (by decide) (by decide)
  · change ((-10 : ℤ) : ℚ) = (scale : ℚ) * (-5 / 22 : ℚ)
    exact eq_smul_div (-10) scale (-5) (22) (by decide) (by decide)
  · change ((-86 : ℤ) : ℚ) = (scale : ℚ) * (-43 / 22 : ℚ)
    exact eq_smul_div (-86) scale (-43) (22) (by decide) (by decide)
  · change ((-50 : ℤ) : ℚ) = (scale : ℚ) * (-25 / 22 : ℚ)
    exact eq_smul_div (-50) scale (-25) (22) (by decide) (by decide)
  · change ((-144 : ℤ) : ℚ) = (scale : ℚ) * (-36 / 11 : ℚ)
    exact eq_smul_div (-144) scale (-36) (11) (by decide) (by decide)

theorem XZ_scale_6 : toVec (XZ 6) = (scale : ℚ) • XCell7_6 := by
  funext i
  fin_cases i
  · change ((38 : ℤ) : ℚ) = (scale : ℚ) * (19 / 22 : ℚ)
    exact eq_smul_div (38) scale (19) (22) (by decide) (by decide)
  · change ((-28 : ℤ) : ℚ) = (scale : ℚ) * (-7 / 11 : ℚ)
    exact eq_smul_div (-28) scale (-7) (11) (by decide) (by decide)
  · change ((24 : ℤ) : ℚ) = (scale : ℚ) * (6 / 11 : ℚ)
    exact eq_smul_div (24) scale (6) (11) (by decide) (by decide)
  · change ((52 : ℤ) : ℚ) = (scale : ℚ) * (13 / 11 : ℚ)
    exact eq_smul_div (52) scale (13) (11) (by decide) (by decide)
  · change ((-16 : ℤ) : ℚ) = (scale : ℚ) * (-4 / 11 : ℚ)
    exact eq_smul_div (-16) scale (-4) (11) (by decide) (by decide)
  · change ((10 : ℤ) : ℚ) = (scale : ℚ) * (5 / 22 : ℚ)
    exact eq_smul_div (10) scale (5) (22) (by decide) (by decide)
  · change ((-18 : ℤ) : ℚ) = (scale : ℚ) * (-9 / 22 : ℚ)
    exact eq_smul_div (-18) scale (-9) (22) (by decide) (by decide)
  · change ((90 : ℤ) : ℚ) = (scale : ℚ) * (45 / 22 : ℚ)
    exact eq_smul_div (90) scale (45) (22) (by decide) (by decide)
  · change ((-46 : ℤ) : ℚ) = (scale : ℚ) * (-23 / 22 : ℚ)
    exact eq_smul_div (-46) scale (-23) (22) (by decide) (by decide)
  · change ((48 : ℤ) : ℚ) = (scale : ℚ) * (12 / 11 : ℚ)
    exact eq_smul_div (48) scale (12) (11) (by decide) (by decide)

theorem XZ_scale_7 : toVec (XZ 7) = (scale : ℚ) • XCell7_7 := by
  funext i
  fin_cases i
  · change ((-138 : ℤ) : ℚ) = (scale : ℚ) * (-69 / 22 : ℚ)
    exact eq_smul_div (-138) scale (-69) (22) (by decide) (by decide)
  · change ((-162 : ℤ) : ℚ) = (scale : ℚ) * (-81 / 22 : ℚ)
    exact eq_smul_div (-162) scale (-81) (22) (by decide) (by decide)
  · change ((-84 : ℤ) : ℚ) = (scale : ℚ) * (-21 / 11 : ℚ)
    exact eq_smul_div (-84) scale (-21) (11) (by decide) (by decide)
  · change ((-142 : ℤ) : ℚ) = (scale : ℚ) * (-71 / 22 : ℚ)
    exact eq_smul_div (-142) scale (-71) (22) (by decide) (by decide)
  · change ((-82 : ℤ) : ℚ) = (scale : ℚ) * (-41 / 22 : ℚ)
    exact eq_smul_div (-82) scale (-41) (22) (by decide) (by decide)
  · change ((-200 : ℤ) : ℚ) = (scale : ℚ) * (-50 / 11 : ℚ)
    exact eq_smul_div (-200) scale (-50) (11) (by decide) (by decide)
  · change ((-30 : ℤ) : ℚ) = (scale : ℚ) * (-15 / 22 : ℚ)
    exact eq_smul_div (-30) scale (-15) (22) (by decide) (by decide)
  · change ((-200 : ℤ) : ℚ) = (scale : ℚ) * (-50 / 11 : ℚ)
    exact eq_smul_div (-200) scale (-50) (11) (by decide) (by decide)
  · change ((-42 : ℤ) : ℚ) = (scale : ℚ) * (-21 / 22 : ℚ)
    exact eq_smul_div (-42) scale (-21) (22) (by decide) (by decide)
  · change ((-240 : ℤ) : ℚ) = (scale : ℚ) * (-60 / 11 : ℚ)
    exact eq_smul_div (-240) scale (-60) (11) (by decide) (by decide)

theorem XZ_scale_8 : toVec (XZ 8) = (scale : ℚ) • XCell7_8 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem XZ_scale_9 : toVec (XZ 9) = (scale : ℚ) • XCell7_9 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem XZ_scale_10 : toVec (XZ 10) = (scale : ℚ) • XCell7_10 := by
  funext i
  fin_cases i
  · change ((22 : ℤ) : ℚ) = (scale : ℚ) * (1 / 2 : ℚ)
    exact eq_smul_div (22) scale (1) (2) (by decide) (by decide)
  · change ((22 : ℤ) : ℚ) = (scale : ℚ) * (1 / 2 : ℚ)
    exact eq_smul_div (22) scale (1) (2) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((22 : ℤ) : ℚ) = (scale : ℚ) * (1 / 2 : ℚ)
    exact eq_smul_div (22) scale (1) (2) (by decide) (by decide)
  · change ((-11 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 4 : ℚ)
    exact eq_smul_div (-11) scale (-1) (4) (by decide) (by decide)
  · change ((22 : ℤ) : ℚ) = (scale : ℚ) * (1 / 2 : ℚ)
    exact eq_smul_div (22) scale (1) (2) (by decide) (by decide)
  · change ((11 : ℤ) : ℚ) = (scale : ℚ) * (1 / 4 : ℚ)
    exact eq_smul_div (11) scale (1) (4) (by decide) (by decide)
  · change ((11 : ℤ) : ℚ) = (scale : ℚ) * (1 / 4 : ℚ)
    exact eq_smul_div (11) scale (1) (4) (by decide) (by decide)
  · change ((22 : ℤ) : ℚ) = (scale : ℚ) * (1 / 2 : ℚ)
    exact eq_smul_div (22) scale (1) (2) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem XZ_scale_11 : toVec (XZ 11) = (scale : ℚ) • XCell7_11 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem XZ_scale_12 : toVec (XZ 12) = (scale : ℚ) • XCell7_12 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem XZ_scale_13 : toVec (XZ 13) = (scale : ℚ) • XCell7_13 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem XZ_scale_14 : toVec (XZ 14) = (scale : ℚ) • XCell7_14 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem XZ_scale_15 : toVec (XZ 15) = (scale : ℚ) • XCell7_15 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem XZ_scale_16 : toVec (XZ 16) = (scale : ℚ) • XCell7_16 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem XZ_scale_17 : toVec (XZ 17) = (scale : ℚ) • XCell7_17 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem XZ_scale_18 : toVec (XZ 18) = (scale : ℚ) • XCell7_18 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem XZ_scale_19 : toVec (XZ 19) = (scale : ℚ) • XCell7_19 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem XZ_scale (k : Fin 20) :
    toVec (XZ k) = (scale : ℚ) • XVec (7 : Fin 10) k := by
  fin_cases k
  · simp [XVec, XRow7]; exact XZ_scale_0
  · simp [XVec, XRow7]; exact XZ_scale_1
  · simp [XVec, XRow7]; exact XZ_scale_2
  · simp [XVec, XRow7]; exact XZ_scale_3
  · simp [XVec, XRow7]; exact XZ_scale_4
  · simp [XVec, XRow7]; exact XZ_scale_5
  · simp [XVec, XRow7]; exact XZ_scale_6
  · simp [XVec, XRow7]; exact XZ_scale_7
  · simp [XVec, XRow7]; exact XZ_scale_8
  · simp [XVec, XRow7]; exact XZ_scale_9
  · simp [XVec, XRow7]; exact XZ_scale_10
  · simp [XVec, XRow7]; exact XZ_scale_11
  · simp [XVec, XRow7]; exact XZ_scale_12
  · simp [XVec, XRow7]; exact XZ_scale_13
  · simp [XVec, XRow7]; exact XZ_scale_14
  · simp [XVec, XRow7]; exact XZ_scale_15
  · simp [XVec, XRow7]; exact XZ_scale_16
  · simp [XVec, XRow7]; exact XZ_scale_17
  · simp [XVec, XRow7]; exact XZ_scale_18
  · simp [XVec, XRow7]; exact XZ_scale_19

theorem AZ_scale_0 : toVec (AZ 0) = (scale : ℚ) • ACell0_4 := by
  funext i
  fin_cases i
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (8) scale (2) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (4) scale (1) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (4) scale (1) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)

theorem AZ_scale_1 : toVec (AZ 1) = (scale : ℚ) • ACell1_4 := by
  funext i
  fin_cases i
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)
  · change ((-12 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 11 : ℚ)
    exact eq_smul_div (-12) scale (-3) (11) (by decide) (by decide)
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-2) (11) (by decide) (by decide)
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-2) (11) (by decide) (by decide)
  · change ((-12 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 11 : ℚ)
    exact eq_smul_div (-12) scale (-3) (11) (by decide) (by decide)
  · change ((-12 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 11 : ℚ)
    exact eq_smul_div (-12) scale (-3) (11) (by decide) (by decide)
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-2) (11) (by decide) (by decide)
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-2) (11) (by decide) (by decide)
  · change ((-12 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 11 : ℚ)
    exact eq_smul_div (-12) scale (-3) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)

theorem AZ_scale_2 : toVec (AZ 2) = (scale : ℚ) • ACell2_4 := by
  funext i
  fin_cases i
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-2) (11) (by decide) (by decide)
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-2) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (4) scale (1) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-2) (11) (by decide) (by decide)
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)

theorem AZ_scale_3 : toVec (AZ 3) = (scale : ℚ) • ACell3_4 := by
  funext i
  fin_cases i
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (4) scale (1) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (8) scale (2) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (4) scale (1) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)

theorem AZ_scale_4 : toVec (AZ 4) = (scale : ℚ) • ACell4_4 := by
  funext i
  fin_cases i
  · change ((36 : ℤ) : ℚ) = (scale : ℚ) * (9 / 11 : ℚ)
    exact eq_smul_div (36) scale (9) (11) (by decide) (by decide)
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-2) (11) (by decide) (by decide)
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-2) (11) (by decide) (by decide)
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (4) scale (1) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)

theorem AZ_scale_5 : toVec (AZ 5) = (scale : ℚ) • ACell5_4 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-6) scale (-3) (22) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (3 / 22 : ℚ)
    exact eq_smul_div (6) scale (3) (22) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (3 / 22 : ℚ)
    exact eq_smul_div (6) scale (3) (22) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-6) scale (-3) (22) (by decide) (by decide)

theorem AZ_scale_6 : toVec (AZ 6) = (scale : ℚ) • ACell6_4 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-6) scale (-3) (22) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (3 / 22 : ℚ)
    exact eq_smul_div (6) scale (3) (22) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (3 / 22 : ℚ)
    exact eq_smul_div (6) scale (3) (22) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-6) scale (-3) (22) (by decide) (by decide)

theorem AZ_scale_7 : toVec (AZ 7) = (scale : ℚ) • ACell7_4 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-6) scale (-3) (22) (by decide) (by decide)
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (3 / 22 : ℚ)
    exact eq_smul_div (6) scale (3) (22) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (3 / 22 : ℚ)
    exact eq_smul_div (6) scale (3) (22) (by decide) (by decide)
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-6) scale (-3) (22) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem AZ_scale_8 : toVec (AZ 8) = (scale : ℚ) • ACell8_4 := by
  funext i
  fin_cases i
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-6) scale (-3) (22) (by decide) (by decide)
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-6) scale (-3) (22) (by decide) (by decide)
  · change ((-12 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 11 : ℚ)
    exact eq_smul_div (-12) scale (-3) (11) (by decide) (by decide)
  · change ((-12 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 11 : ℚ)
    exact eq_smul_div (-12) scale (-3) (11) (by decide) (by decide)
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-6) scale (-3) (22) (by decide) (by decide)
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-6) scale (-3) (22) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-6) scale (-3) (22) (by decide) (by decide)
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-6) scale (-3) (22) (by decide) (by decide)
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-6) scale (-3) (22) (by decide) (by decide)

theorem AZ_scale_9 : toVec (AZ 9) = (scale : ℚ) • ACell9_4 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (3 / 22 : ℚ)
    exact eq_smul_div (6) scale (3) (22) (by decide) (by decide)
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-6) scale (-3) (22) (by decide) (by decide)
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-6) scale (-3) (22) (by decide) (by decide)
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (3 / 22 : ℚ)
    exact eq_smul_div (6) scale (3) (22) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem AZ_scale_10 : toVec (AZ 10) = (scale : ℚ) • ACell10_4 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (4) scale (1) (11) (by decide) (by decide)
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (8) scale (2) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (4) scale (1) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)

theorem AZ_scale_11 : toVec (AZ 11) = (scale : ℚ) • ACell11_4 := by
  funext i
  fin_cases i
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (4) scale (1) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (8) scale (2) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (4) scale (1) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)

theorem AZ_scale_12 : toVec (AZ 12) = (scale : ℚ) • ACell12_4 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (8) scale (2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (4) scale (1) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (4) scale (1) (11) (by decide) (by decide)

theorem AZ_scale_13 : toVec (AZ 13) = (scale : ℚ) • ACell13_4 := by
  funext i
  fin_cases i
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (4) scale (1) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (8) scale (2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (4) scale (1) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem AZ_scale_14 : toVec (AZ 14) = (scale : ℚ) • ACell14_4 := by
  funext i
  fin_cases i
  · change ((56 : ℤ) : ℚ) = (scale : ℚ) * (14 / 11 : ℚ)
    exact eq_smul_div (56) scale (14) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (4) scale (1) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (4) scale (1) (11) (by decide) (by decide)
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (8) scale (2) (11) (by decide) (by decide)
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (8) scale (2) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (4) scale (1) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (4) scale (1) (11) (by decide) (by decide)

theorem AZ_scale_15 : toVec (AZ 15) = (scale : ℚ) • ACell15_4 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (3 / 22 : ℚ)
    exact eq_smul_div (6) scale (3) (22) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (3 / 22 : ℚ)
    exact eq_smul_div (6) scale (3) (22) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-6) scale (-3) (22) (by decide) (by decide)
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-6) scale (-3) (22) (by decide) (by decide)

theorem AZ_scale_16 : toVec (AZ 16) = (scale : ℚ) • ACell16_4 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-6) scale (-3) (22) (by decide) (by decide)
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (3 / 22 : ℚ)
    exact eq_smul_div (6) scale (3) (22) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (3 / 22 : ℚ)
    exact eq_smul_div (6) scale (3) (22) (by decide) (by decide)
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-6) scale (-3) (22) (by decide) (by decide)

theorem AZ_scale_17 : toVec (AZ 17) = (scale : ℚ) • ACell17_4 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (3 / 22 : ℚ)
    exact eq_smul_div (6) scale (3) (22) (by decide) (by decide)
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-6) scale (-3) (22) (by decide) (by decide)
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-6) scale (-3) (22) (by decide) (by decide)
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (3 / 22 : ℚ)
    exact eq_smul_div (6) scale (3) (22) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem AZ_scale_18 : toVec (AZ 18) = (scale : ℚ) • ACell18_4 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (3 / 22 : ℚ)
    exact eq_smul_div (6) scale (3) (22) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (3 / 22 : ℚ)
    exact eq_smul_div (6) scale (3) (22) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-6) scale (-3) (22) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-6) scale (-3) (22) (by decide) (by decide)

theorem AZ_scale_19 : toVec (AZ 19) = (scale : ℚ) • ACell19_4 := by
  funext i
  fin_cases i
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-6) scale (-3) (22) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (3 / 22 : ℚ)
    exact eq_smul_div (6) scale (3) (22) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (3 / 22 : ℚ)
    exact eq_smul_div (6) scale (3) (22) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-6) scale (-3) (22) (by decide) (by decide)

theorem AZ_scale (k : Fin 20) :
    toVec (AZ k) = (scale : ℚ) • AVec k (4 : Fin 10) := by
  fin_cases k
  · simp [AVec, ARow0]; exact AZ_scale_0
  · simp [AVec, ARow1]; exact AZ_scale_1
  · simp [AVec, ARow2]; exact AZ_scale_2
  · simp [AVec, ARow3]; exact AZ_scale_3
  · simp [AVec, ARow4]; exact AZ_scale_4
  · simp [AVec, ARow5]; exact AZ_scale_5
  · simp [AVec, ARow6]; exact AZ_scale_6
  · simp [AVec, ARow7]; exact AZ_scale_7
  · simp [AVec, ARow8]; exact AZ_scale_8
  · simp [AVec, ARow9]; exact AZ_scale_9
  · simp [AVec, ARow10]; exact AZ_scale_10
  · simp [AVec, ARow11]; exact AZ_scale_11
  · simp [AVec, ARow12]; exact AZ_scale_12
  · simp [AVec, ARow13]; exact AZ_scale_13
  · simp [AVec, ARow14]; exact AZ_scale_14
  · simp [AVec, ARow15]; exact AZ_scale_15
  · simp [AVec, ARow16]; exact AZ_scale_16
  · simp [AVec, ARow17]; exact AZ_scale_17
  · simp [AVec, ARow18]; exact AZ_scale_18
  · simp [AVec, ARow19]; exact AZ_scale_19

theorem KZ_scale_0 : toVec (KZ 0) = (scale : ℚ) • KCell7_0 := by
  funext i
  fin_cases i
  · change ((22 : ℤ) : ℚ) = (scale : ℚ) * (1 / 2 : ℚ)
    exact eq_smul_div (22) scale (1) (2) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-22 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 2 : ℚ)
    exact eq_smul_div (-22) scale (-1) (2) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((22 : ℤ) : ℚ) = (scale : ℚ) * (1 / 2 : ℚ)
    exact eq_smul_div (22) scale (1) (2) (by decide) (by decide)
  · change ((-22 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 2 : ℚ)
    exact eq_smul_div (-22) scale (-1) (2) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-22 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 2 : ℚ)
    exact eq_smul_div (-22) scale (-1) (2) (by decide) (by decide)

theorem KZ_scale (k : Fin 1) :
    toVec (KZ k) = (scale : ℚ) • KVec (7 : Fin 10) k := by
  fin_cases k
  · simp [KVec, KRow0]; exact KZ_scale_0

theorem YZ_scale_0 : toVec (YZ 0) = (scale : ℚ) • YCell0_4 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem YZ_scale (k : Fin 1) :
    toVec (YZ k) = (scale : ℚ) • YVec k (4 : Fin 10) := by
  fin_cases k
  · simp [YVec, YRow0]; exact YZ_scale_0

theorem entry_eq :
    (matrixMul XVec AVec + matrixMul KVec YVec)
        (7 : Fin 10) (4 : Fin 10) = ![0, 0, 0, 0, 0, 0, 0, 0, 0, 0] := by
  change (∑ k : Fin 20, mul (XVec (7 : Fin 10) k)
      (AVec k (4 : Fin 10))) +
    (∑ k : Fin 1, mul (KVec (7 : Fin 10) k)
      (YVec k (4 : Fin 10))) = _
  refine add_sum_mul_eq_of_scaled scale scale_ne_zero
    (fun k => XVec (7 : Fin 10) k)
    (fun k => AVec k (4 : Fin 10))
    (fun k => KVec (7 : Fin 10) k)
    (fun k => YVec k (4 : Fin 10))
    XZ AZ KZ YZ XZ_scale AZ_scale KZ_scale YZ_scale entryZ rfl _ ?_
  rw [entryZ_eq, toVec_zeroZ_smul, vec_zero_eq]

theorem entry_eq_matrixOne :
    (matrixMul XVec AVec + matrixMul KVec YVec)
        (7 : Fin 10) (4 : Fin 10) =
      matrixOne (Fin 10) (7 : Fin 10) (4 : Fin 10) := by
  rw [entry_eq]
  have hne : (7 : Fin 10) ≠ (4 : Fin 10) := by decide
  funext n
  fin_cases n <;> simp [matrixOne, constVec, basis, *]

end V14Formalization.D12PieceAASplitEntry7_4


namespace V14Formalization.D12PieceAASplitEntry7_5
open D12CyclotomicVec D12CyclotomicVecZ D12PieceAAData
def payloadSha256 : String := "76c6196f29afe1a8398af99502447f48ebeed4bcb3805fc5dbec693940bc04b0"

def scale : ℤ := 44

def XZ (k : Fin 20) : VecZ :=
  match k.val with
  | 0 => #v[18, -70, -4, 34, -33, -15, -19, 54, -77, 13]
  | 1 => #v[16, -17, 1, 5, -9, 11, -19, 17, 1, -6]
  | 2 => #v[-119, -2, -41, -108, -1, -99, 29, -164, 46, -113]
  | 3 => #v[32, 70, 43, 35, 11, 82, 0, 61, 39, 78]
  | 4 => #v[16, 3, -5, 24, 1, -7, 16, 15, -13, 16]
  | 5 => #v[-62, -104, -58, -50, -40, -144, -10, -86, -50, -144]
  | 6 => #v[38, -28, 24, 52, -16, 10, -18, 90, -46, 48]
  | 7 => #v[-138, -162, -84, -142, -82, -200, -30, -200, -42, -240]
  | 8 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  | 9 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  | 10 => #v[22, 22, 0, 22, -11, 22, 11, 11, 22, 0]
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
  | 0 => #v[0, 0, 8, 0, 0, -8, -8, 0, 0, 8]
  | 1 => #v[8, 8, 16, 8, 8, 16, 8, 8, 0, 8]
  | 2 => #v[0, 0, 0, 0, 0, 0, -8, 8, 8, -8]
  | 3 => #v[8, 8, 8, 0, 16, 8, 8, 8, 8, 16]
  | 4 => #v[0, 0, 0, -8, 0, 8, 0, 8, 0, -8]
  | 5 => #v[44, 4, 4, 0, 8, 12, 8, 0, 4, 4]
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

def KZ (k : Fin 1) : VecZ :=
  match k.val with
  | 0 => #v[22, 0, -22, 0, 0, 0, 22, -22, 0, -22]
  | _ => zeroZ

def YZ (k : Fin 1) : VecZ :=
  match k.val with
  | 0 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  | _ => zeroZ

def xaEntryZ : VecZ := sumFin (fun k => mulZ (XZ k) (AZ k))
def kyEntryZ : VecZ := sumFin (fun k => mulZ (KZ k) (YZ k))
def entryZ : VecZ := addZ xaEntryZ kyEntryZ

theorem entryZ_eq : entryZ = zeroZ := by
  decide +kernel

theorem scale_ne_zero : scale ≠ 0 := by
  decide

theorem XZ_scale_0 : toVec (XZ 0) = (scale : ℚ) • XCell7_0 := by
  funext i
  fin_cases i
  · change ((18 : ℤ) : ℚ) = (scale : ℚ) * (9 / 22 : ℚ)
    exact eq_smul_div (18) scale (9) (22) (by decide) (by decide)
  · change ((-70 : ℤ) : ℚ) = (scale : ℚ) * (-35 / 22 : ℚ)
    exact eq_smul_div (-70) scale (-35) (22) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)
  · change ((34 : ℤ) : ℚ) = (scale : ℚ) * (17 / 22 : ℚ)
    exact eq_smul_div (34) scale (17) (22) (by decide) (by decide)
  · change ((-33 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 4 : ℚ)
    exact eq_smul_div (-33) scale (-3) (4) (by decide) (by decide)
  · change ((-15 : ℤ) : ℚ) = (scale : ℚ) * (-15 / 44 : ℚ)
    exact eq_smul_div (-15) scale (-15) (44) (by decide) (by decide)
  · change ((-19 : ℤ) : ℚ) = (scale : ℚ) * (-19 / 44 : ℚ)
    exact eq_smul_div (-19) scale (-19) (44) (by decide) (by decide)
  · change ((54 : ℤ) : ℚ) = (scale : ℚ) * (27 / 22 : ℚ)
    exact eq_smul_div (54) scale (27) (22) (by decide) (by decide)
  · change ((-77 : ℤ) : ℚ) = (scale : ℚ) * (-7 / 4 : ℚ)
    exact eq_smul_div (-77) scale (-7) (4) (by decide) (by decide)
  · change ((13 : ℤ) : ℚ) = (scale : ℚ) * (13 / 44 : ℚ)
    exact eq_smul_div (13) scale (13) (44) (by decide) (by decide)

theorem XZ_scale_1 : toVec (XZ 1) = (scale : ℚ) • XCell7_1 := by
  funext i
  fin_cases i
  · change ((16 : ℤ) : ℚ) = (scale : ℚ) * (4 / 11 : ℚ)
    exact eq_smul_div (16) scale (4) (11) (by decide) (by decide)
  · change ((-17 : ℤ) : ℚ) = (scale : ℚ) * (-17 / 44 : ℚ)
    exact eq_smul_div (-17) scale (-17) (44) (by decide) (by decide)
  · change ((1 : ℤ) : ℚ) = (scale : ℚ) * (1 / 44 : ℚ)
    exact eq_smul_div (1) scale (1) (44) (by decide) (by decide)
  · change ((5 : ℤ) : ℚ) = (scale : ℚ) * (5 / 44 : ℚ)
    exact eq_smul_div (5) scale (5) (44) (by decide) (by decide)
  · change ((-9 : ℤ) : ℚ) = (scale : ℚ) * (-9 / 44 : ℚ)
    exact eq_smul_div (-9) scale (-9) (44) (by decide) (by decide)
  · change ((11 : ℤ) : ℚ) = (scale : ℚ) * (1 / 4 : ℚ)
    exact eq_smul_div (11) scale (1) (4) (by decide) (by decide)
  · change ((-19 : ℤ) : ℚ) = (scale : ℚ) * (-19 / 44 : ℚ)
    exact eq_smul_div (-19) scale (-19) (44) (by decide) (by decide)
  · change ((17 : ℤ) : ℚ) = (scale : ℚ) * (17 / 44 : ℚ)
    exact eq_smul_div (17) scale (17) (44) (by decide) (by decide)
  · change ((1 : ℤ) : ℚ) = (scale : ℚ) * (1 / 44 : ℚ)
    exact eq_smul_div (1) scale (1) (44) (by decide) (by decide)
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-6) scale (-3) (22) (by decide) (by decide)

theorem XZ_scale_2 : toVec (XZ 2) = (scale : ℚ) • XCell7_2 := by
  funext i
  fin_cases i
  · change ((-119 : ℤ) : ℚ) = (scale : ℚ) * (-119 / 44 : ℚ)
    exact eq_smul_div (-119) scale (-119) (44) (by decide) (by decide)
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 22 : ℚ)
    exact eq_smul_div (-2) scale (-1) (22) (by decide) (by decide)
  · change ((-41 : ℤ) : ℚ) = (scale : ℚ) * (-41 / 44 : ℚ)
    exact eq_smul_div (-41) scale (-41) (44) (by decide) (by decide)
  · change ((-108 : ℤ) : ℚ) = (scale : ℚ) * (-27 / 11 : ℚ)
    exact eq_smul_div (-108) scale (-27) (11) (by decide) (by decide)
  · change ((-1 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 44 : ℚ)
    exact eq_smul_div (-1) scale (-1) (44) (by decide) (by decide)
  · change ((-99 : ℤ) : ℚ) = (scale : ℚ) * (-9 / 4 : ℚ)
    exact eq_smul_div (-99) scale (-9) (4) (by decide) (by decide)
  · change ((29 : ℤ) : ℚ) = (scale : ℚ) * (29 / 44 : ℚ)
    exact eq_smul_div (29) scale (29) (44) (by decide) (by decide)
  · change ((-164 : ℤ) : ℚ) = (scale : ℚ) * (-41 / 11 : ℚ)
    exact eq_smul_div (-164) scale (-41) (11) (by decide) (by decide)
  · change ((46 : ℤ) : ℚ) = (scale : ℚ) * (23 / 22 : ℚ)
    exact eq_smul_div (46) scale (23) (22) (by decide) (by decide)
  · change ((-113 : ℤ) : ℚ) = (scale : ℚ) * (-113 / 44 : ℚ)
    exact eq_smul_div (-113) scale (-113) (44) (by decide) (by decide)

theorem XZ_scale_3 : toVec (XZ 3) = (scale : ℚ) • XCell7_3 := by
  funext i
  fin_cases i
  · change ((32 : ℤ) : ℚ) = (scale : ℚ) * (8 / 11 : ℚ)
    exact eq_smul_div (32) scale (8) (11) (by decide) (by decide)
  · change ((70 : ℤ) : ℚ) = (scale : ℚ) * (35 / 22 : ℚ)
    exact eq_smul_div (70) scale (35) (22) (by decide) (by decide)
  · change ((43 : ℤ) : ℚ) = (scale : ℚ) * (43 / 44 : ℚ)
    exact eq_smul_div (43) scale (43) (44) (by decide) (by decide)
  · change ((35 : ℤ) : ℚ) = (scale : ℚ) * (35 / 44 : ℚ)
    exact eq_smul_div (35) scale (35) (44) (by decide) (by decide)
  · change ((11 : ℤ) : ℚ) = (scale : ℚ) * (1 / 4 : ℚ)
    exact eq_smul_div (11) scale (1) (4) (by decide) (by decide)
  · change ((82 : ℤ) : ℚ) = (scale : ℚ) * (41 / 22 : ℚ)
    exact eq_smul_div (82) scale (41) (22) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((61 : ℤ) : ℚ) = (scale : ℚ) * (61 / 44 : ℚ)
    exact eq_smul_div (61) scale (61) (44) (by decide) (by decide)
  · change ((39 : ℤ) : ℚ) = (scale : ℚ) * (39 / 44 : ℚ)
    exact eq_smul_div (39) scale (39) (44) (by decide) (by decide)
  · change ((78 : ℤ) : ℚ) = (scale : ℚ) * (39 / 22 : ℚ)
    exact eq_smul_div (78) scale (39) (22) (by decide) (by decide)

theorem XZ_scale_4 : toVec (XZ 4) = (scale : ℚ) • XCell7_4 := by
  funext i
  fin_cases i
  · change ((16 : ℤ) : ℚ) = (scale : ℚ) * (4 / 11 : ℚ)
    exact eq_smul_div (16) scale (4) (11) (by decide) (by decide)
  · change ((3 : ℤ) : ℚ) = (scale : ℚ) * (3 / 44 : ℚ)
    exact eq_smul_div (3) scale (3) (44) (by decide) (by decide)
  · change ((-5 : ℤ) : ℚ) = (scale : ℚ) * (-5 / 44 : ℚ)
    exact eq_smul_div (-5) scale (-5) (44) (by decide) (by decide)
  · change ((24 : ℤ) : ℚ) = (scale : ℚ) * (6 / 11 : ℚ)
    exact eq_smul_div (24) scale (6) (11) (by decide) (by decide)
  · change ((1 : ℤ) : ℚ) = (scale : ℚ) * (1 / 44 : ℚ)
    exact eq_smul_div (1) scale (1) (44) (by decide) (by decide)
  · change ((-7 : ℤ) : ℚ) = (scale : ℚ) * (-7 / 44 : ℚ)
    exact eq_smul_div (-7) scale (-7) (44) (by decide) (by decide)
  · change ((16 : ℤ) : ℚ) = (scale : ℚ) * (4 / 11 : ℚ)
    exact eq_smul_div (16) scale (4) (11) (by decide) (by decide)
  · change ((15 : ℤ) : ℚ) = (scale : ℚ) * (15 / 44 : ℚ)
    exact eq_smul_div (15) scale (15) (44) (by decide) (by decide)
  · change ((-13 : ℤ) : ℚ) = (scale : ℚ) * (-13 / 44 : ℚ)
    exact eq_smul_div (-13) scale (-13) (44) (by decide) (by decide)
  · change ((16 : ℤ) : ℚ) = (scale : ℚ) * (4 / 11 : ℚ)
    exact eq_smul_div (16) scale (4) (11) (by decide) (by decide)

theorem XZ_scale_5 : toVec (XZ 5) = (scale : ℚ) • XCell7_5 := by
  funext i
  fin_cases i
  · change ((-62 : ℤ) : ℚ) = (scale : ℚ) * (-31 / 22 : ℚ)
    exact eq_smul_div (-62) scale (-31) (22) (by decide) (by decide)
  · change ((-104 : ℤ) : ℚ) = (scale : ℚ) * (-26 / 11 : ℚ)
    exact eq_smul_div (-104) scale (-26) (11) (by decide) (by decide)
  · change ((-58 : ℤ) : ℚ) = (scale : ℚ) * (-29 / 22 : ℚ)
    exact eq_smul_div (-58) scale (-29) (22) (by decide) (by decide)
  · change ((-50 : ℤ) : ℚ) = (scale : ℚ) * (-25 / 22 : ℚ)
    exact eq_smul_div (-50) scale (-25) (22) (by decide) (by decide)
  · change ((-40 : ℤ) : ℚ) = (scale : ℚ) * (-10 / 11 : ℚ)
    exact eq_smul_div (-40) scale (-10) (11) (by decide) (by decide)
  · change ((-144 : ℤ) : ℚ) = (scale : ℚ) * (-36 / 11 : ℚ)
    exact eq_smul_div (-144) scale (-36) (11) (by decide) (by decide)
  · change ((-10 : ℤ) : ℚ) = (scale : ℚ) * (-5 / 22 : ℚ)
    exact eq_smul_div (-10) scale (-5) (22) (by decide) (by decide)
  · change ((-86 : ℤ) : ℚ) = (scale : ℚ) * (-43 / 22 : ℚ)
    exact eq_smul_div (-86) scale (-43) (22) (by decide) (by decide)
  · change ((-50 : ℤ) : ℚ) = (scale : ℚ) * (-25 / 22 : ℚ)
    exact eq_smul_div (-50) scale (-25) (22) (by decide) (by decide)
  · change ((-144 : ℤ) : ℚ) = (scale : ℚ) * (-36 / 11 : ℚ)
    exact eq_smul_div (-144) scale (-36) (11) (by decide) (by decide)

theorem XZ_scale_6 : toVec (XZ 6) = (scale : ℚ) • XCell7_6 := by
  funext i
  fin_cases i
  · change ((38 : ℤ) : ℚ) = (scale : ℚ) * (19 / 22 : ℚ)
    exact eq_smul_div (38) scale (19) (22) (by decide) (by decide)
  · change ((-28 : ℤ) : ℚ) = (scale : ℚ) * (-7 / 11 : ℚ)
    exact eq_smul_div (-28) scale (-7) (11) (by decide) (by decide)
  · change ((24 : ℤ) : ℚ) = (scale : ℚ) * (6 / 11 : ℚ)
    exact eq_smul_div (24) scale (6) (11) (by decide) (by decide)
  · change ((52 : ℤ) : ℚ) = (scale : ℚ) * (13 / 11 : ℚ)
    exact eq_smul_div (52) scale (13) (11) (by decide) (by decide)
  · change ((-16 : ℤ) : ℚ) = (scale : ℚ) * (-4 / 11 : ℚ)
    exact eq_smul_div (-16) scale (-4) (11) (by decide) (by decide)
  · change ((10 : ℤ) : ℚ) = (scale : ℚ) * (5 / 22 : ℚ)
    exact eq_smul_div (10) scale (5) (22) (by decide) (by decide)
  · change ((-18 : ℤ) : ℚ) = (scale : ℚ) * (-9 / 22 : ℚ)
    exact eq_smul_div (-18) scale (-9) (22) (by decide) (by decide)
  · change ((90 : ℤ) : ℚ) = (scale : ℚ) * (45 / 22 : ℚ)
    exact eq_smul_div (90) scale (45) (22) (by decide) (by decide)
  · change ((-46 : ℤ) : ℚ) = (scale : ℚ) * (-23 / 22 : ℚ)
    exact eq_smul_div (-46) scale (-23) (22) (by decide) (by decide)
  · change ((48 : ℤ) : ℚ) = (scale : ℚ) * (12 / 11 : ℚ)
    exact eq_smul_div (48) scale (12) (11) (by decide) (by decide)

theorem XZ_scale_7 : toVec (XZ 7) = (scale : ℚ) • XCell7_7 := by
  funext i
  fin_cases i
  · change ((-138 : ℤ) : ℚ) = (scale : ℚ) * (-69 / 22 : ℚ)
    exact eq_smul_div (-138) scale (-69) (22) (by decide) (by decide)
  · change ((-162 : ℤ) : ℚ) = (scale : ℚ) * (-81 / 22 : ℚ)
    exact eq_smul_div (-162) scale (-81) (22) (by decide) (by decide)
  · change ((-84 : ℤ) : ℚ) = (scale : ℚ) * (-21 / 11 : ℚ)
    exact eq_smul_div (-84) scale (-21) (11) (by decide) (by decide)
  · change ((-142 : ℤ) : ℚ) = (scale : ℚ) * (-71 / 22 : ℚ)
    exact eq_smul_div (-142) scale (-71) (22) (by decide) (by decide)
  · change ((-82 : ℤ) : ℚ) = (scale : ℚ) * (-41 / 22 : ℚ)
    exact eq_smul_div (-82) scale (-41) (22) (by decide) (by decide)
  · change ((-200 : ℤ) : ℚ) = (scale : ℚ) * (-50 / 11 : ℚ)
    exact eq_smul_div (-200) scale (-50) (11) (by decide) (by decide)
  · change ((-30 : ℤ) : ℚ) = (scale : ℚ) * (-15 / 22 : ℚ)
    exact eq_smul_div (-30) scale (-15) (22) (by decide) (by decide)
  · change ((-200 : ℤ) : ℚ) = (scale : ℚ) * (-50 / 11 : ℚ)
    exact eq_smul_div (-200) scale (-50) (11) (by decide) (by decide)
  · change ((-42 : ℤ) : ℚ) = (scale : ℚ) * (-21 / 22 : ℚ)
    exact eq_smul_div (-42) scale (-21) (22) (by decide) (by decide)
  · change ((-240 : ℤ) : ℚ) = (scale : ℚ) * (-60 / 11 : ℚ)
    exact eq_smul_div (-240) scale (-60) (11) (by decide) (by decide)

theorem XZ_scale_8 : toVec (XZ 8) = (scale : ℚ) • XCell7_8 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem XZ_scale_9 : toVec (XZ 9) = (scale : ℚ) • XCell7_9 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem XZ_scale_10 : toVec (XZ 10) = (scale : ℚ) • XCell7_10 := by
  funext i
  fin_cases i
  · change ((22 : ℤ) : ℚ) = (scale : ℚ) * (1 / 2 : ℚ)
    exact eq_smul_div (22) scale (1) (2) (by decide) (by decide)
  · change ((22 : ℤ) : ℚ) = (scale : ℚ) * (1 / 2 : ℚ)
    exact eq_smul_div (22) scale (1) (2) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((22 : ℤ) : ℚ) = (scale : ℚ) * (1 / 2 : ℚ)
    exact eq_smul_div (22) scale (1) (2) (by decide) (by decide)
  · change ((-11 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 4 : ℚ)
    exact eq_smul_div (-11) scale (-1) (4) (by decide) (by decide)
  · change ((22 : ℤ) : ℚ) = (scale : ℚ) * (1 / 2 : ℚ)
    exact eq_smul_div (22) scale (1) (2) (by decide) (by decide)
  · change ((11 : ℤ) : ℚ) = (scale : ℚ) * (1 / 4 : ℚ)
    exact eq_smul_div (11) scale (1) (4) (by decide) (by decide)
  · change ((11 : ℤ) : ℚ) = (scale : ℚ) * (1 / 4 : ℚ)
    exact eq_smul_div (11) scale (1) (4) (by decide) (by decide)
  · change ((22 : ℤ) : ℚ) = (scale : ℚ) * (1 / 2 : ℚ)
    exact eq_smul_div (22) scale (1) (2) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem XZ_scale_11 : toVec (XZ 11) = (scale : ℚ) • XCell7_11 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem XZ_scale_12 : toVec (XZ 12) = (scale : ℚ) • XCell7_12 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem XZ_scale_13 : toVec (XZ 13) = (scale : ℚ) • XCell7_13 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem XZ_scale_14 : toVec (XZ 14) = (scale : ℚ) • XCell7_14 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem XZ_scale_15 : toVec (XZ 15) = (scale : ℚ) • XCell7_15 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem XZ_scale_16 : toVec (XZ 16) = (scale : ℚ) • XCell7_16 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem XZ_scale_17 : toVec (XZ 17) = (scale : ℚ) • XCell7_17 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem XZ_scale_18 : toVec (XZ 18) = (scale : ℚ) • XCell7_18 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem XZ_scale_19 : toVec (XZ 19) = (scale : ℚ) • XCell7_19 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem XZ_scale (k : Fin 20) :
    toVec (XZ k) = (scale : ℚ) • XVec (7 : Fin 10) k := by
  fin_cases k
  · simp [XVec, XRow7]; exact XZ_scale_0
  · simp [XVec, XRow7]; exact XZ_scale_1
  · simp [XVec, XRow7]; exact XZ_scale_2
  · simp [XVec, XRow7]; exact XZ_scale_3
  · simp [XVec, XRow7]; exact XZ_scale_4
  · simp [XVec, XRow7]; exact XZ_scale_5
  · simp [XVec, XRow7]; exact XZ_scale_6
  · simp [XVec, XRow7]; exact XZ_scale_7
  · simp [XVec, XRow7]; exact XZ_scale_8
  · simp [XVec, XRow7]; exact XZ_scale_9
  · simp [XVec, XRow7]; exact XZ_scale_10
  · simp [XVec, XRow7]; exact XZ_scale_11
  · simp [XVec, XRow7]; exact XZ_scale_12
  · simp [XVec, XRow7]; exact XZ_scale_13
  · simp [XVec, XRow7]; exact XZ_scale_14
  · simp [XVec, XRow7]; exact XZ_scale_15
  · simp [XVec, XRow7]; exact XZ_scale_16
  · simp [XVec, XRow7]; exact XZ_scale_17
  · simp [XVec, XRow7]; exact XZ_scale_18
  · simp [XVec, XRow7]; exact XZ_scale_19

theorem AZ_scale_0 : toVec (AZ 0) = (scale : ℚ) • ACell0_5 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (8) scale (2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-2) (11) (by decide) (by decide)
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (8) scale (2) (11) (by decide) (by decide)

theorem AZ_scale_1 : toVec (AZ 1) = (scale : ℚ) • ACell1_5 := by
  funext i
  fin_cases i
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (8) scale (2) (11) (by decide) (by decide)
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (8) scale (2) (11) (by decide) (by decide)
  · change ((16 : ℤ) : ℚ) = (scale : ℚ) * (4 / 11 : ℚ)
    exact eq_smul_div (16) scale (4) (11) (by decide) (by decide)
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (8) scale (2) (11) (by decide) (by decide)
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (8) scale (2) (11) (by decide) (by decide)
  · change ((16 : ℤ) : ℚ) = (scale : ℚ) * (4 / 11 : ℚ)
    exact eq_smul_div (16) scale (4) (11) (by decide) (by decide)
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (8) scale (2) (11) (by decide) (by decide)
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (8) scale (2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (8) scale (2) (11) (by decide) (by decide)

theorem AZ_scale_2 : toVec (AZ 2) = (scale : ℚ) • ACell2_5 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-2) (11) (by decide) (by decide)
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (8) scale (2) (11) (by decide) (by decide)
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (8) scale (2) (11) (by decide) (by decide)
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-2) (11) (by decide) (by decide)

theorem AZ_scale_3 : toVec (AZ 3) = (scale : ℚ) • ACell3_5 := by
  funext i
  fin_cases i
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (8) scale (2) (11) (by decide) (by decide)
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (8) scale (2) (11) (by decide) (by decide)
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (8) scale (2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((16 : ℤ) : ℚ) = (scale : ℚ) * (4 / 11 : ℚ)
    exact eq_smul_div (16) scale (4) (11) (by decide) (by decide)
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (8) scale (2) (11) (by decide) (by decide)
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (8) scale (2) (11) (by decide) (by decide)
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (8) scale (2) (11) (by decide) (by decide)
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (8) scale (2) (11) (by decide) (by decide)
  · change ((16 : ℤ) : ℚ) = (scale : ℚ) * (4 / 11 : ℚ)
    exact eq_smul_div (16) scale (4) (11) (by decide) (by decide)

theorem AZ_scale_4 : toVec (AZ 4) = (scale : ℚ) • ACell4_5 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (8) scale (2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (8) scale (2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-2) (11) (by decide) (by decide)

theorem AZ_scale_5 : toVec (AZ 5) = (scale : ℚ) • ACell5_5 := by
  funext i
  fin_cases i
  · change ((44 : ℤ) : ℚ) = (scale : ℚ) * (1 : ℚ)
    exact eq_smul_int (44) scale (1) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (4) scale (1) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (4) scale (1) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (8) scale (2) (11) (by decide) (by decide)
  · change ((12 : ℤ) : ℚ) = (scale : ℚ) * (3 / 11 : ℚ)
    exact eq_smul_div (12) scale (3) (11) (by decide) (by decide)
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (8) scale (2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (4) scale (1) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (4) scale (1) (11) (by decide) (by decide)

theorem AZ_scale_6 : toVec (AZ 6) = (scale : ℚ) • ACell6_5 := by
  funext i
  fin_cases i
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (4) scale (1) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (4) scale (1) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (4) scale (1) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (4) scale (1) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem AZ_scale_7 : toVec (AZ 7) = (scale : ℚ) • ACell7_5 := by
  funext i
  fin_cases i
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-2) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)
  · change ((-12 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 11 : ℚ)
    exact eq_smul_div (-12) scale (-3) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem AZ_scale_8 : toVec (AZ 8) = (scale : ℚ) • ACell8_5 := by
  funext i
  fin_cases i
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (4) scale (1) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (8) scale (2) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (4) scale (1) (11) (by decide) (by decide)

theorem AZ_scale_9 : toVec (AZ 9) = (scale : ℚ) • ACell9_5 := by
  funext i
  fin_cases i
  · change ((12 : ℤ) : ℚ) = (scale : ℚ) * (3 / 11 : ℚ)
    exact eq_smul_div (12) scale (3) (11) (by decide) (by decide)
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (8) scale (2) (11) (by decide) (by decide)
  · change ((12 : ℤ) : ℚ) = (scale : ℚ) * (3 / 11 : ℚ)
    exact eq_smul_div (12) scale (3) (11) (by decide) (by decide)
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (8) scale (2) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (4) scale (1) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (4) scale (1) (11) (by decide) (by decide)
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (8) scale (2) (11) (by decide) (by decide)
  · change ((12 : ℤ) : ℚ) = (scale : ℚ) * (3 / 11 : ℚ)
    exact eq_smul_div (12) scale (3) (11) (by decide) (by decide)
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (8) scale (2) (11) (by decide) (by decide)
  · change ((12 : ℤ) : ℚ) = (scale : ℚ) * (3 / 11 : ℚ)
    exact eq_smul_div (12) scale (3) (11) (by decide) (by decide)

theorem AZ_scale_10 : toVec (AZ 10) = (scale : ℚ) • ACell10_5 := by
  funext i
  fin_cases i
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (8) scale (2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (8) scale (2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem AZ_scale_11 : toVec (AZ 11) = (scale : ℚ) • ACell11_5 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-2) (11) (by decide) (by decide)
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (8) scale (2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (8) scale (2) (11) (by decide) (by decide)
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem AZ_scale_12 : toVec (AZ 12) = (scale : ℚ) • ACell12_5 := by
  funext i
  fin_cases i
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-2) (11) (by decide) (by decide)
  · change ((-16 : ℤ) : ℚ) = (scale : ℚ) * (-4 / 11 : ℚ)
    exact eq_smul_div (-16) scale (-4) (11) (by decide) (by decide)
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-2) (11) (by decide) (by decide)
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-2) (11) (by decide) (by decide)
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-2) (11) (by decide) (by decide)
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-2) (11) (by decide) (by decide)
  · change ((-16 : ℤ) : ℚ) = (scale : ℚ) * (-4 / 11 : ℚ)
    exact eq_smul_div (-16) scale (-4) (11) (by decide) (by decide)
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-2) (11) (by decide) (by decide)

theorem AZ_scale_13 : toVec (AZ 13) = (scale : ℚ) • ACell13_5 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-2) (11) (by decide) (by decide)
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (8) scale (2) (11) (by decide) (by decide)
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (8) scale (2) (11) (by decide) (by decide)
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem AZ_scale_14 : toVec (AZ 14) = (scale : ℚ) • ACell14_5 := by
  funext i
  fin_cases i
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-2) (11) (by decide) (by decide)
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-2) (11) (by decide) (by decide)
  · change ((-16 : ℤ) : ℚ) = (scale : ℚ) * (-4 / 11 : ℚ)
    exact eq_smul_div (-16) scale (-4) (11) (by decide) (by decide)
  · change ((-16 : ℤ) : ℚ) = (scale : ℚ) * (-4 / 11 : ℚ)
    exact eq_smul_div (-16) scale (-4) (11) (by decide) (by decide)
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-2) (11) (by decide) (by decide)
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-2) (11) (by decide) (by decide)
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-2) (11) (by decide) (by decide)
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-2) (11) (by decide) (by decide)

theorem AZ_scale_15 : toVec (AZ 15) = (scale : ℚ) • ACell15_5 := by
  funext i
  fin_cases i
  · change ((56 : ℤ) : ℚ) = (scale : ℚ) * (14 / 11 : ℚ)
    exact eq_smul_div (56) scale (14) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (8) scale (2) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (4) scale (1) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (4) scale (1) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (4) scale (1) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (4) scale (1) (11) (by decide) (by decide)
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (8) scale (2) (11) (by decide) (by decide)

theorem AZ_scale_16 : toVec (AZ 16) = (scale : ℚ) • ACell16_5 := by
  funext i
  fin_cases i
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-2) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)
  · change ((-12 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 11 : ℚ)
    exact eq_smul_div (-12) scale (-3) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem AZ_scale_17 : toVec (AZ 17) = (scale : ℚ) • ACell17_5 := by
  funext i
  fin_cases i
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (4) scale (1) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (4) scale (1) (11) (by decide) (by decide)
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-2) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (4) scale (1) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (4) scale (1) (11) (by decide) (by decide)

theorem AZ_scale_18 : toVec (AZ 18) = (scale : ℚ) • ACell18_5 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (4) scale (1) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (8) scale (2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (4) scale (1) (11) (by decide) (by decide)

theorem AZ_scale_19 : toVec (AZ 19) = (scale : ℚ) • ACell19_5 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (4) scale (1) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (4) scale (1) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (4) scale (1) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-2) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (4) scale (1) (11) (by decide) (by decide)

theorem AZ_scale (k : Fin 20) :
    toVec (AZ k) = (scale : ℚ) • AVec k (5 : Fin 10) := by
  fin_cases k
  · simp [AVec, ARow0]; exact AZ_scale_0
  · simp [AVec, ARow1]; exact AZ_scale_1
  · simp [AVec, ARow2]; exact AZ_scale_2
  · simp [AVec, ARow3]; exact AZ_scale_3
  · simp [AVec, ARow4]; exact AZ_scale_4
  · simp [AVec, ARow5]; exact AZ_scale_5
  · simp [AVec, ARow6]; exact AZ_scale_6
  · simp [AVec, ARow7]; exact AZ_scale_7
  · simp [AVec, ARow8]; exact AZ_scale_8
  · simp [AVec, ARow9]; exact AZ_scale_9
  · simp [AVec, ARow10]; exact AZ_scale_10
  · simp [AVec, ARow11]; exact AZ_scale_11
  · simp [AVec, ARow12]; exact AZ_scale_12
  · simp [AVec, ARow13]; exact AZ_scale_13
  · simp [AVec, ARow14]; exact AZ_scale_14
  · simp [AVec, ARow15]; exact AZ_scale_15
  · simp [AVec, ARow16]; exact AZ_scale_16
  · simp [AVec, ARow17]; exact AZ_scale_17
  · simp [AVec, ARow18]; exact AZ_scale_18
  · simp [AVec, ARow19]; exact AZ_scale_19

theorem KZ_scale_0 : toVec (KZ 0) = (scale : ℚ) • KCell7_0 := by
  funext i
  fin_cases i
  · change ((22 : ℤ) : ℚ) = (scale : ℚ) * (1 / 2 : ℚ)
    exact eq_smul_div (22) scale (1) (2) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-22 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 2 : ℚ)
    exact eq_smul_div (-22) scale (-1) (2) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((22 : ℤ) : ℚ) = (scale : ℚ) * (1 / 2 : ℚ)
    exact eq_smul_div (22) scale (1) (2) (by decide) (by decide)
  · change ((-22 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 2 : ℚ)
    exact eq_smul_div (-22) scale (-1) (2) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-22 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 2 : ℚ)
    exact eq_smul_div (-22) scale (-1) (2) (by decide) (by decide)

theorem KZ_scale (k : Fin 1) :
    toVec (KZ k) = (scale : ℚ) • KVec (7 : Fin 10) k := by
  fin_cases k
  · simp [KVec, KRow0]; exact KZ_scale_0

theorem YZ_scale_0 : toVec (YZ 0) = (scale : ℚ) • YCell0_5 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem YZ_scale (k : Fin 1) :
    toVec (YZ k) = (scale : ℚ) • YVec k (5 : Fin 10) := by
  fin_cases k
  · simp [YVec, YRow0]; exact YZ_scale_0

theorem entry_eq :
    (matrixMul XVec AVec + matrixMul KVec YVec)
        (7 : Fin 10) (5 : Fin 10) = ![0, 0, 0, 0, 0, 0, 0, 0, 0, 0] := by
  change (∑ k : Fin 20, mul (XVec (7 : Fin 10) k)
      (AVec k (5 : Fin 10))) +
    (∑ k : Fin 1, mul (KVec (7 : Fin 10) k)
      (YVec k (5 : Fin 10))) = _
  refine add_sum_mul_eq_of_scaled scale scale_ne_zero
    (fun k => XVec (7 : Fin 10) k)
    (fun k => AVec k (5 : Fin 10))
    (fun k => KVec (7 : Fin 10) k)
    (fun k => YVec k (5 : Fin 10))
    XZ AZ KZ YZ XZ_scale AZ_scale KZ_scale YZ_scale entryZ rfl _ ?_
  rw [entryZ_eq, toVec_zeroZ_smul, vec_zero_eq]

theorem entry_eq_matrixOne :
    (matrixMul XVec AVec + matrixMul KVec YVec)
        (7 : Fin 10) (5 : Fin 10) =
      matrixOne (Fin 10) (7 : Fin 10) (5 : Fin 10) := by
  rw [entry_eq]
  have hne : (7 : Fin 10) ≠ (5 : Fin 10) := by decide
  funext n
  fin_cases n <;> simp [matrixOne, constVec, basis, *]

end V14Formalization.D12PieceAASplitEntry7_5


namespace V14Formalization.D12PieceAASplitEntry7_6
open D12CyclotomicVec D12CyclotomicVecZ D12PieceAAData
def payloadSha256 : String := "76c6196f29afe1a8398af99502447f48ebeed4bcb3805fc5dbec693940bc04b0"

def scale : ℤ := 44

def XZ (k : Fin 20) : VecZ :=
  match k.val with
  | 0 => #v[18, -70, -4, 34, -33, -15, -19, 54, -77, 13]
  | 1 => #v[16, -17, 1, 5, -9, 11, -19, 17, 1, -6]
  | 2 => #v[-119, -2, -41, -108, -1, -99, 29, -164, 46, -113]
  | 3 => #v[32, 70, 43, 35, 11, 82, 0, 61, 39, 78]
  | 4 => #v[16, 3, -5, 24, 1, -7, 16, 15, -13, 16]
  | 5 => #v[-62, -104, -58, -50, -40, -144, -10, -86, -50, -144]
  | 6 => #v[38, -28, 24, 52, -16, 10, -18, 90, -46, 48]
  | 7 => #v[-138, -162, -84, -142, -82, -200, -30, -200, -42, -240]
  | 8 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  | 9 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  | 10 => #v[22, 22, 0, 22, -11, 22, 11, 11, 22, 0]
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
  | 0 => #v[0, 8, -8, 0, 0, 0, 0, -8, 8, 0]
  | 1 => #v[0, 8, -8, -8, 8, 0, 0, 0, 0, 0]
  | 2 => #v[8, 8, 8, 0, 8, 8, 16, 16, 8, 8]
  | 3 => #v[8, 0, 8, 16, 8, 8, 8, 8, 16, 8]
  | 4 => #v[0, -8, 0, 0, 8, 0, 8, 0, 0, -8]
  | 5 => #v[-4, 4, 4, 0, -8, 0, 4, 4, -4, 0]
  | 6 => #v[40, 0, -4, 8, -4, 0, -4, 0, 4, 4]
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

def KZ (k : Fin 1) : VecZ :=
  match k.val with
  | 0 => #v[22, 0, -22, 0, 0, 0, 22, -22, 0, -22]
  | _ => zeroZ

def YZ (k : Fin 1) : VecZ :=
  match k.val with
  | 0 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  | _ => zeroZ

def xaEntryZ : VecZ := sumFin (fun k => mulZ (XZ k) (AZ k))
def kyEntryZ : VecZ := sumFin (fun k => mulZ (KZ k) (YZ k))
def entryZ : VecZ := addZ xaEntryZ kyEntryZ

theorem entryZ_eq : entryZ = zeroZ := by
  decide +kernel

theorem scale_ne_zero : scale ≠ 0 := by
  decide

theorem XZ_scale_0 : toVec (XZ 0) = (scale : ℚ) • XCell7_0 := by
  funext i
  fin_cases i
  · change ((18 : ℤ) : ℚ) = (scale : ℚ) * (9 / 22 : ℚ)
    exact eq_smul_div (18) scale (9) (22) (by decide) (by decide)
  · change ((-70 : ℤ) : ℚ) = (scale : ℚ) * (-35 / 22 : ℚ)
    exact eq_smul_div (-70) scale (-35) (22) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)
  · change ((34 : ℤ) : ℚ) = (scale : ℚ) * (17 / 22 : ℚ)
    exact eq_smul_div (34) scale (17) (22) (by decide) (by decide)
  · change ((-33 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 4 : ℚ)
    exact eq_smul_div (-33) scale (-3) (4) (by decide) (by decide)
  · change ((-15 : ℤ) : ℚ) = (scale : ℚ) * (-15 / 44 : ℚ)
    exact eq_smul_div (-15) scale (-15) (44) (by decide) (by decide)
  · change ((-19 : ℤ) : ℚ) = (scale : ℚ) * (-19 / 44 : ℚ)
    exact eq_smul_div (-19) scale (-19) (44) (by decide) (by decide)
  · change ((54 : ℤ) : ℚ) = (scale : ℚ) * (27 / 22 : ℚ)
    exact eq_smul_div (54) scale (27) (22) (by decide) (by decide)
  · change ((-77 : ℤ) : ℚ) = (scale : ℚ) * (-7 / 4 : ℚ)
    exact eq_smul_div (-77) scale (-7) (4) (by decide) (by decide)
  · change ((13 : ℤ) : ℚ) = (scale : ℚ) * (13 / 44 : ℚ)
    exact eq_smul_div (13) scale (13) (44) (by decide) (by decide)

theorem XZ_scale_1 : toVec (XZ 1) = (scale : ℚ) • XCell7_1 := by
  funext i
  fin_cases i
  · change ((16 : ℤ) : ℚ) = (scale : ℚ) * (4 / 11 : ℚ)
    exact eq_smul_div (16) scale (4) (11) (by decide) (by decide)
  · change ((-17 : ℤ) : ℚ) = (scale : ℚ) * (-17 / 44 : ℚ)
    exact eq_smul_div (-17) scale (-17) (44) (by decide) (by decide)
  · change ((1 : ℤ) : ℚ) = (scale : ℚ) * (1 / 44 : ℚ)
    exact eq_smul_div (1) scale (1) (44) (by decide) (by decide)
  · change ((5 : ℤ) : ℚ) = (scale : ℚ) * (5 / 44 : ℚ)
    exact eq_smul_div (5) scale (5) (44) (by decide) (by decide)
  · change ((-9 : ℤ) : ℚ) = (scale : ℚ) * (-9 / 44 : ℚ)
    exact eq_smul_div (-9) scale (-9) (44) (by decide) (by decide)
  · change ((11 : ℤ) : ℚ) = (scale : ℚ) * (1 / 4 : ℚ)
    exact eq_smul_div (11) scale (1) (4) (by decide) (by decide)
  · change ((-19 : ℤ) : ℚ) = (scale : ℚ) * (-19 / 44 : ℚ)
    exact eq_smul_div (-19) scale (-19) (44) (by decide) (by decide)
  · change ((17 : ℤ) : ℚ) = (scale : ℚ) * (17 / 44 : ℚ)
    exact eq_smul_div (17) scale (17) (44) (by decide) (by decide)
  · change ((1 : ℤ) : ℚ) = (scale : ℚ) * (1 / 44 : ℚ)
    exact eq_smul_div (1) scale (1) (44) (by decide) (by decide)
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-6) scale (-3) (22) (by decide) (by decide)

theorem XZ_scale_2 : toVec (XZ 2) = (scale : ℚ) • XCell7_2 := by
  funext i
  fin_cases i
  · change ((-119 : ℤ) : ℚ) = (scale : ℚ) * (-119 / 44 : ℚ)
    exact eq_smul_div (-119) scale (-119) (44) (by decide) (by decide)
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 22 : ℚ)
    exact eq_smul_div (-2) scale (-1) (22) (by decide) (by decide)
  · change ((-41 : ℤ) : ℚ) = (scale : ℚ) * (-41 / 44 : ℚ)
    exact eq_smul_div (-41) scale (-41) (44) (by decide) (by decide)
  · change ((-108 : ℤ) : ℚ) = (scale : ℚ) * (-27 / 11 : ℚ)
    exact eq_smul_div (-108) scale (-27) (11) (by decide) (by decide)
  · change ((-1 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 44 : ℚ)
    exact eq_smul_div (-1) scale (-1) (44) (by decide) (by decide)
  · change ((-99 : ℤ) : ℚ) = (scale : ℚ) * (-9 / 4 : ℚ)
    exact eq_smul_div (-99) scale (-9) (4) (by decide) (by decide)
  · change ((29 : ℤ) : ℚ) = (scale : ℚ) * (29 / 44 : ℚ)
    exact eq_smul_div (29) scale (29) (44) (by decide) (by decide)
  · change ((-164 : ℤ) : ℚ) = (scale : ℚ) * (-41 / 11 : ℚ)
    exact eq_smul_div (-164) scale (-41) (11) (by decide) (by decide)
  · change ((46 : ℤ) : ℚ) = (scale : ℚ) * (23 / 22 : ℚ)
    exact eq_smul_div (46) scale (23) (22) (by decide) (by decide)
  · change ((-113 : ℤ) : ℚ) = (scale : ℚ) * (-113 / 44 : ℚ)
    exact eq_smul_div (-113) scale (-113) (44) (by decide) (by decide)

theorem XZ_scale_3 : toVec (XZ 3) = (scale : ℚ) • XCell7_3 := by
  funext i
  fin_cases i
  · change ((32 : ℤ) : ℚ) = (scale : ℚ) * (8 / 11 : ℚ)
    exact eq_smul_div (32) scale (8) (11) (by decide) (by decide)
  · change ((70 : ℤ) : ℚ) = (scale : ℚ) * (35 / 22 : ℚ)
    exact eq_smul_div (70) scale (35) (22) (by decide) (by decide)
  · change ((43 : ℤ) : ℚ) = (scale : ℚ) * (43 / 44 : ℚ)
    exact eq_smul_div (43) scale (43) (44) (by decide) (by decide)
  · change ((35 : ℤ) : ℚ) = (scale : ℚ) * (35 / 44 : ℚ)
    exact eq_smul_div (35) scale (35) (44) (by decide) (by decide)
  · change ((11 : ℤ) : ℚ) = (scale : ℚ) * (1 / 4 : ℚ)
    exact eq_smul_div (11) scale (1) (4) (by decide) (by decide)
  · change ((82 : ℤ) : ℚ) = (scale : ℚ) * (41 / 22 : ℚ)
    exact eq_smul_div (82) scale (41) (22) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((61 : ℤ) : ℚ) = (scale : ℚ) * (61 / 44 : ℚ)
    exact eq_smul_div (61) scale (61) (44) (by decide) (by decide)
  · change ((39 : ℤ) : ℚ) = (scale : ℚ) * (39 / 44 : ℚ)
    exact eq_smul_div (39) scale (39) (44) (by decide) (by decide)
  · change ((78 : ℤ) : ℚ) = (scale : ℚ) * (39 / 22 : ℚ)
    exact eq_smul_div (78) scale (39) (22) (by decide) (by decide)

theorem XZ_scale_4 : toVec (XZ 4) = (scale : ℚ) • XCell7_4 := by
  funext i
  fin_cases i
  · change ((16 : ℤ) : ℚ) = (scale : ℚ) * (4 / 11 : ℚ)
    exact eq_smul_div (16) scale (4) (11) (by decide) (by decide)
  · change ((3 : ℤ) : ℚ) = (scale : ℚ) * (3 / 44 : ℚ)
    exact eq_smul_div (3) scale (3) (44) (by decide) (by decide)
  · change ((-5 : ℤ) : ℚ) = (scale : ℚ) * (-5 / 44 : ℚ)
    exact eq_smul_div (-5) scale (-5) (44) (by decide) (by decide)
  · change ((24 : ℤ) : ℚ) = (scale : ℚ) * (6 / 11 : ℚ)
    exact eq_smul_div (24) scale (6) (11) (by decide) (by decide)
  · change ((1 : ℤ) : ℚ) = (scale : ℚ) * (1 / 44 : ℚ)
    exact eq_smul_div (1) scale (1) (44) (by decide) (by decide)
  · change ((-7 : ℤ) : ℚ) = (scale : ℚ) * (-7 / 44 : ℚ)
    exact eq_smul_div (-7) scale (-7) (44) (by decide) (by decide)
  · change ((16 : ℤ) : ℚ) = (scale : ℚ) * (4 / 11 : ℚ)
    exact eq_smul_div (16) scale (4) (11) (by decide) (by decide)
  · change ((15 : ℤ) : ℚ) = (scale : ℚ) * (15 / 44 : ℚ)
    exact eq_smul_div (15) scale (15) (44) (by decide) (by decide)
  · change ((-13 : ℤ) : ℚ) = (scale : ℚ) * (-13 / 44 : ℚ)
    exact eq_smul_div (-13) scale (-13) (44) (by decide) (by decide)
  · change ((16 : ℤ) : ℚ) = (scale : ℚ) * (4 / 11 : ℚ)
    exact eq_smul_div (16) scale (4) (11) (by decide) (by decide)

theorem XZ_scale_5 : toVec (XZ 5) = (scale : ℚ) • XCell7_5 := by
  funext i
  fin_cases i
  · change ((-62 : ℤ) : ℚ) = (scale : ℚ) * (-31 / 22 : ℚ)
    exact eq_smul_div (-62) scale (-31) (22) (by decide) (by decide)
  · change ((-104 : ℤ) : ℚ) = (scale : ℚ) * (-26 / 11 : ℚ)
    exact eq_smul_div (-104) scale (-26) (11) (by decide) (by decide)
  · change ((-58 : ℤ) : ℚ) = (scale : ℚ) * (-29 / 22 : ℚ)
    exact eq_smul_div (-58) scale (-29) (22) (by decide) (by decide)
  · change ((-50 : ℤ) : ℚ) = (scale : ℚ) * (-25 / 22 : ℚ)
    exact eq_smul_div (-50) scale (-25) (22) (by decide) (by decide)
  · change ((-40 : ℤ) : ℚ) = (scale : ℚ) * (-10 / 11 : ℚ)
    exact eq_smul_div (-40) scale (-10) (11) (by decide) (by decide)
  · change ((-144 : ℤ) : ℚ) = (scale : ℚ) * (-36 / 11 : ℚ)
    exact eq_smul_div (-144) scale (-36) (11) (by decide) (by decide)
  · change ((-10 : ℤ) : ℚ) = (scale : ℚ) * (-5 / 22 : ℚ)
    exact eq_smul_div (-10) scale (-5) (22) (by decide) (by decide)
  · change ((-86 : ℤ) : ℚ) = (scale : ℚ) * (-43 / 22 : ℚ)
    exact eq_smul_div (-86) scale (-43) (22) (by decide) (by decide)
  · change ((-50 : ℤ) : ℚ) = (scale : ℚ) * (-25 / 22 : ℚ)
    exact eq_smul_div (-50) scale (-25) (22) (by decide) (by decide)
  · change ((-144 : ℤ) : ℚ) = (scale : ℚ) * (-36 / 11 : ℚ)
    exact eq_smul_div (-144) scale (-36) (11) (by decide) (by decide)

theorem XZ_scale_6 : toVec (XZ 6) = (scale : ℚ) • XCell7_6 := by
  funext i
  fin_cases i
  · change ((38 : ℤ) : ℚ) = (scale : ℚ) * (19 / 22 : ℚ)
    exact eq_smul_div (38) scale (19) (22) (by decide) (by decide)
  · change ((-28 : ℤ) : ℚ) = (scale : ℚ) * (-7 / 11 : ℚ)
    exact eq_smul_div (-28) scale (-7) (11) (by decide) (by decide)
  · change ((24 : ℤ) : ℚ) = (scale : ℚ) * (6 / 11 : ℚ)
    exact eq_smul_div (24) scale (6) (11) (by decide) (by decide)
  · change ((52 : ℤ) : ℚ) = (scale : ℚ) * (13 / 11 : ℚ)
    exact eq_smul_div (52) scale (13) (11) (by decide) (by decide)
  · change ((-16 : ℤ) : ℚ) = (scale : ℚ) * (-4 / 11 : ℚ)
    exact eq_smul_div (-16) scale (-4) (11) (by decide) (by decide)
  · change ((10 : ℤ) : ℚ) = (scale : ℚ) * (5 / 22 : ℚ)
    exact eq_smul_div (10) scale (5) (22) (by decide) (by decide)
  · change ((-18 : ℤ) : ℚ) = (scale : ℚ) * (-9 / 22 : ℚ)
    exact eq_smul_div (-18) scale (-9) (22) (by decide) (by decide)
  · change ((90 : ℤ) : ℚ) = (scale : ℚ) * (45 / 22 : ℚ)
    exact eq_smul_div (90) scale (45) (22) (by decide) (by decide)
  · change ((-46 : ℤ) : ℚ) = (scale : ℚ) * (-23 / 22 : ℚ)
    exact eq_smul_div (-46) scale (-23) (22) (by decide) (by decide)
  · change ((48 : ℤ) : ℚ) = (scale : ℚ) * (12 / 11 : ℚ)
    exact eq_smul_div (48) scale (12) (11) (by decide) (by decide)

theorem XZ_scale_7 : toVec (XZ 7) = (scale : ℚ) • XCell7_7 := by
  funext i
  fin_cases i
  · change ((-138 : ℤ) : ℚ) = (scale : ℚ) * (-69 / 22 : ℚ)
    exact eq_smul_div (-138) scale (-69) (22) (by decide) (by decide)
  · change ((-162 : ℤ) : ℚ) = (scale : ℚ) * (-81 / 22 : ℚ)
    exact eq_smul_div (-162) scale (-81) (22) (by decide) (by decide)
  · change ((-84 : ℤ) : ℚ) = (scale : ℚ) * (-21 / 11 : ℚ)
    exact eq_smul_div (-84) scale (-21) (11) (by decide) (by decide)
  · change ((-142 : ℤ) : ℚ) = (scale : ℚ) * (-71 / 22 : ℚ)
    exact eq_smul_div (-142) scale (-71) (22) (by decide) (by decide)
  · change ((-82 : ℤ) : ℚ) = (scale : ℚ) * (-41 / 22 : ℚ)
    exact eq_smul_div (-82) scale (-41) (22) (by decide) (by decide)
  · change ((-200 : ℤ) : ℚ) = (scale : ℚ) * (-50 / 11 : ℚ)
    exact eq_smul_div (-200) scale (-50) (11) (by decide) (by decide)
  · change ((-30 : ℤ) : ℚ) = (scale : ℚ) * (-15 / 22 : ℚ)
    exact eq_smul_div (-30) scale (-15) (22) (by decide) (by decide)
  · change ((-200 : ℤ) : ℚ) = (scale : ℚ) * (-50 / 11 : ℚ)
    exact eq_smul_div (-200) scale (-50) (11) (by decide) (by decide)
  · change ((-42 : ℤ) : ℚ) = (scale : ℚ) * (-21 / 22 : ℚ)
    exact eq_smul_div (-42) scale (-21) (22) (by decide) (by decide)
  · change ((-240 : ℤ) : ℚ) = (scale : ℚ) * (-60 / 11 : ℚ)
    exact eq_smul_div (-240) scale (-60) (11) (by decide) (by decide)

theorem XZ_scale_8 : toVec (XZ 8) = (scale : ℚ) • XCell7_8 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem XZ_scale_9 : toVec (XZ 9) = (scale : ℚ) • XCell7_9 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem XZ_scale_10 : toVec (XZ 10) = (scale : ℚ) • XCell7_10 := by
  funext i
  fin_cases i
  · change ((22 : ℤ) : ℚ) = (scale : ℚ) * (1 / 2 : ℚ)
    exact eq_smul_div (22) scale (1) (2) (by decide) (by decide)
  · change ((22 : ℤ) : ℚ) = (scale : ℚ) * (1 / 2 : ℚ)
    exact eq_smul_div (22) scale (1) (2) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((22 : ℤ) : ℚ) = (scale : ℚ) * (1 / 2 : ℚ)
    exact eq_smul_div (22) scale (1) (2) (by decide) (by decide)
  · change ((-11 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 4 : ℚ)
    exact eq_smul_div (-11) scale (-1) (4) (by decide) (by decide)
  · change ((22 : ℤ) : ℚ) = (scale : ℚ) * (1 / 2 : ℚ)
    exact eq_smul_div (22) scale (1) (2) (by decide) (by decide)
  · change ((11 : ℤ) : ℚ) = (scale : ℚ) * (1 / 4 : ℚ)
    exact eq_smul_div (11) scale (1) (4) (by decide) (by decide)
  · change ((11 : ℤ) : ℚ) = (scale : ℚ) * (1 / 4 : ℚ)
    exact eq_smul_div (11) scale (1) (4) (by decide) (by decide)
  · change ((22 : ℤ) : ℚ) = (scale : ℚ) * (1 / 2 : ℚ)
    exact eq_smul_div (22) scale (1) (2) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem XZ_scale_11 : toVec (XZ 11) = (scale : ℚ) • XCell7_11 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem XZ_scale_12 : toVec (XZ 12) = (scale : ℚ) • XCell7_12 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem XZ_scale_13 : toVec (XZ 13) = (scale : ℚ) • XCell7_13 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem XZ_scale_14 : toVec (XZ 14) = (scale : ℚ) • XCell7_14 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem XZ_scale_15 : toVec (XZ 15) = (scale : ℚ) • XCell7_15 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem XZ_scale_16 : toVec (XZ 16) = (scale : ℚ) • XCell7_16 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem XZ_scale_17 : toVec (XZ 17) = (scale : ℚ) • XCell7_17 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem XZ_scale_18 : toVec (XZ 18) = (scale : ℚ) • XCell7_18 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem XZ_scale_19 : toVec (XZ 19) = (scale : ℚ) • XCell7_19 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem XZ_scale (k : Fin 20) :
    toVec (XZ k) = (scale : ℚ) • XVec (7 : Fin 10) k := by
  fin_cases k
  · simp [XVec, XRow7]; exact XZ_scale_0
  · simp [XVec, XRow7]; exact XZ_scale_1
  · simp [XVec, XRow7]; exact XZ_scale_2
  · simp [XVec, XRow7]; exact XZ_scale_3
  · simp [XVec, XRow7]; exact XZ_scale_4
  · simp [XVec, XRow7]; exact XZ_scale_5
  · simp [XVec, XRow7]; exact XZ_scale_6
  · simp [XVec, XRow7]; exact XZ_scale_7
  · simp [XVec, XRow7]; exact XZ_scale_8
  · simp [XVec, XRow7]; exact XZ_scale_9
  · simp [XVec, XRow7]; exact XZ_scale_10
  · simp [XVec, XRow7]; exact XZ_scale_11
  · simp [XVec, XRow7]; exact XZ_scale_12
  · simp [XVec, XRow7]; exact XZ_scale_13
  · simp [XVec, XRow7]; exact XZ_scale_14
  · simp [XVec, XRow7]; exact XZ_scale_15
  · simp [XVec, XRow7]; exact XZ_scale_16
  · simp [XVec, XRow7]; exact XZ_scale_17
  · simp [XVec, XRow7]; exact XZ_scale_18
  · simp [XVec, XRow7]; exact XZ_scale_19

theorem AZ_scale_0 : toVec (AZ 0) = (scale : ℚ) • ACell0_6 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (8) scale (2) (11) (by decide) (by decide)
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-2) (11) (by decide) (by decide)
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (8) scale (2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem AZ_scale_1 : toVec (AZ 1) = (scale : ℚ) • ACell1_6 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (8) scale (2) (11) (by decide) (by decide)
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-2) (11) (by decide) (by decide)
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-2) (11) (by decide) (by decide)
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (8) scale (2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem AZ_scale_2 : toVec (AZ 2) = (scale : ℚ) • ACell2_6 := by
  funext i
  fin_cases i
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (8) scale (2) (11) (by decide) (by decide)
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (8) scale (2) (11) (by decide) (by decide)
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (8) scale (2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (8) scale (2) (11) (by decide) (by decide)
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (8) scale (2) (11) (by decide) (by decide)
  · change ((16 : ℤ) : ℚ) = (scale : ℚ) * (4 / 11 : ℚ)
    exact eq_smul_div (16) scale (4) (11) (by decide) (by decide)
  · change ((16 : ℤ) : ℚ) = (scale : ℚ) * (4 / 11 : ℚ)
    exact eq_smul_div (16) scale (4) (11) (by decide) (by decide)
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (8) scale (2) (11) (by decide) (by decide)
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (8) scale (2) (11) (by decide) (by decide)

theorem AZ_scale_3 : toVec (AZ 3) = (scale : ℚ) • ACell3_6 := by
  funext i
  fin_cases i
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (8) scale (2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (8) scale (2) (11) (by decide) (by decide)
  · change ((16 : ℤ) : ℚ) = (scale : ℚ) * (4 / 11 : ℚ)
    exact eq_smul_div (16) scale (4) (11) (by decide) (by decide)
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (8) scale (2) (11) (by decide) (by decide)
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (8) scale (2) (11) (by decide) (by decide)
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (8) scale (2) (11) (by decide) (by decide)
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (8) scale (2) (11) (by decide) (by decide)
  · change ((16 : ℤ) : ℚ) = (scale : ℚ) * (4 / 11 : ℚ)
    exact eq_smul_div (16) scale (4) (11) (by decide) (by decide)
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (8) scale (2) (11) (by decide) (by decide)

theorem AZ_scale_4 : toVec (AZ 4) = (scale : ℚ) • ACell4_6 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (8) scale (2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (8) scale (2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-2) (11) (by decide) (by decide)

theorem AZ_scale_5 : toVec (AZ 5) = (scale : ℚ) • ACell5_6 := by
  funext i
  fin_cases i
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (4) scale (1) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (4) scale (1) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (4) scale (1) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (4) scale (1) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem AZ_scale_6 : toVec (AZ 6) = (scale : ℚ) • ACell6_6 := by
  funext i
  fin_cases i
  · change ((40 : ℤ) : ℚ) = (scale : ℚ) * (10 / 11 : ℚ)
    exact eq_smul_div (40) scale (10) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (8) scale (2) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (4) scale (1) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (4) scale (1) (11) (by decide) (by decide)

theorem AZ_scale_7 : toVec (AZ 7) = (scale : ℚ) • ACell7_6 := by
  funext i
  fin_cases i
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (4) scale (1) (11) (by decide) (by decide)
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (8) scale (2) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (4) scale (1) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem AZ_scale_8 : toVec (AZ 8) = (scale : ℚ) • ACell8_6 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-2) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)
  · change ((-12 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 11 : ℚ)
    exact eq_smul_div (-12) scale (-3) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-2) (11) (by decide) (by decide)

theorem AZ_scale_9 : toVec (AZ 9) = (scale : ℚ) • ACell9_6 := by
  funext i
  fin_cases i
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (8) scale (2) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (4) scale (1) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (4) scale (1) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (4) scale (1) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (4) scale (1) (11) (by decide) (by decide)
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (8) scale (2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((12 : ℤ) : ℚ) = (scale : ℚ) * (3 / 11 : ℚ)
    exact eq_smul_div (12) scale (3) (11) (by decide) (by decide)

theorem AZ_scale_10 : toVec (AZ 10) = (scale : ℚ) • ACell10_6 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (8) scale (2) (11) (by decide) (by decide)
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-2) (11) (by decide) (by decide)
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-2) (11) (by decide) (by decide)
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (8) scale (2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem AZ_scale_11 : toVec (AZ 11) = (scale : ℚ) • ACell11_6 := by
  funext i
  fin_cases i
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-2) (11) (by decide) (by decide)
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-2) (11) (by decide) (by decide)
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-2) (11) (by decide) (by decide)
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-2) (11) (by decide) (by decide)
  · change ((-16 : ℤ) : ℚ) = (scale : ℚ) * (-4 / 11 : ℚ)
    exact eq_smul_div (-16) scale (-4) (11) (by decide) (by decide)
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-2) (11) (by decide) (by decide)
  · change ((-16 : ℤ) : ℚ) = (scale : ℚ) * (-4 / 11 : ℚ)
    exact eq_smul_div (-16) scale (-4) (11) (by decide) (by decide)
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-2) (11) (by decide) (by decide)

theorem AZ_scale_12 : toVec (AZ 12) = (scale : ℚ) • ACell12_6 := by
  funext i
  fin_cases i
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (8) scale (2) (11) (by decide) (by decide)
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (8) scale (2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (8) scale (2) (11) (by decide) (by decide)
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (8) scale (2) (11) (by decide) (by decide)
  · change ((16 : ℤ) : ℚ) = (scale : ℚ) * (4 / 11 : ℚ)
    exact eq_smul_div (16) scale (4) (11) (by decide) (by decide)
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (8) scale (2) (11) (by decide) (by decide)
  · change ((16 : ℤ) : ℚ) = (scale : ℚ) * (4 / 11 : ℚ)
    exact eq_smul_div (16) scale (4) (11) (by decide) (by decide)
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (8) scale (2) (11) (by decide) (by decide)
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (8) scale (2) (11) (by decide) (by decide)

theorem AZ_scale_13 : toVec (AZ 13) = (scale : ℚ) • ACell13_6 := by
  funext i
  fin_cases i
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (8) scale (2) (11) (by decide) (by decide)
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (8) scale (2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem AZ_scale_14 : toVec (AZ 14) = (scale : ℚ) • ACell14_6 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-2) (11) (by decide) (by decide)
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (8) scale (2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (8) scale (2) (11) (by decide) (by decide)
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem AZ_scale_15 : toVec (AZ 15) = (scale : ℚ) • ACell15_6 := by
  funext i
  fin_cases i
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (4) scale (1) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (4) scale (1) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (4) scale (1) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (4) scale (1) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem AZ_scale_16 : toVec (AZ 16) = (scale : ℚ) • ACell16_6 := by
  funext i
  fin_cases i
  · change ((48 : ℤ) : ℚ) = (scale : ℚ) * (12 / 11 : ℚ)
    exact eq_smul_div (48) scale (12) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-2) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-2) (11) (by decide) (by decide)
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-2) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-2) (11) (by decide) (by decide)

theorem AZ_scale_17 : toVec (AZ 17) = (scale : ℚ) • ACell17_6 := by
  funext i
  fin_cases i
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (4) scale (1) (11) (by decide) (by decide)
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (8) scale (2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((12 : ℤ) : ℚ) = (scale : ℚ) * (3 / 11 : ℚ)
    exact eq_smul_div (12) scale (3) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (8) scale (2) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (4) scale (1) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (4) scale (1) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (4) scale (1) (11) (by decide) (by decide)

theorem AZ_scale_18 : toVec (AZ 18) = (scale : ℚ) • ACell18_6 := by
  funext i
  fin_cases i
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-12 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 11 : ℚ)
    exact eq_smul_div (-12) scale (-3) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-2) (11) (by decide) (by decide)
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-2) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)

theorem AZ_scale_19 : toVec (AZ 19) = (scale : ℚ) • ACell19_6 := by
  funext i
  fin_cases i
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (4) scale (1) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (8) scale (2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (4) scale (1) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem AZ_scale (k : Fin 20) :
    toVec (AZ k) = (scale : ℚ) • AVec k (6 : Fin 10) := by
  fin_cases k
  · simp [AVec, ARow0]; exact AZ_scale_0
  · simp [AVec, ARow1]; exact AZ_scale_1
  · simp [AVec, ARow2]; exact AZ_scale_2
  · simp [AVec, ARow3]; exact AZ_scale_3
  · simp [AVec, ARow4]; exact AZ_scale_4
  · simp [AVec, ARow5]; exact AZ_scale_5
  · simp [AVec, ARow6]; exact AZ_scale_6
  · simp [AVec, ARow7]; exact AZ_scale_7
  · simp [AVec, ARow8]; exact AZ_scale_8
  · simp [AVec, ARow9]; exact AZ_scale_9
  · simp [AVec, ARow10]; exact AZ_scale_10
  · simp [AVec, ARow11]; exact AZ_scale_11
  · simp [AVec, ARow12]; exact AZ_scale_12
  · simp [AVec, ARow13]; exact AZ_scale_13
  · simp [AVec, ARow14]; exact AZ_scale_14
  · simp [AVec, ARow15]; exact AZ_scale_15
  · simp [AVec, ARow16]; exact AZ_scale_16
  · simp [AVec, ARow17]; exact AZ_scale_17
  · simp [AVec, ARow18]; exact AZ_scale_18
  · simp [AVec, ARow19]; exact AZ_scale_19

theorem KZ_scale_0 : toVec (KZ 0) = (scale : ℚ) • KCell7_0 := by
  funext i
  fin_cases i
  · change ((22 : ℤ) : ℚ) = (scale : ℚ) * (1 / 2 : ℚ)
    exact eq_smul_div (22) scale (1) (2) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-22 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 2 : ℚ)
    exact eq_smul_div (-22) scale (-1) (2) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((22 : ℤ) : ℚ) = (scale : ℚ) * (1 / 2 : ℚ)
    exact eq_smul_div (22) scale (1) (2) (by decide) (by decide)
  · change ((-22 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 2 : ℚ)
    exact eq_smul_div (-22) scale (-1) (2) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-22 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 2 : ℚ)
    exact eq_smul_div (-22) scale (-1) (2) (by decide) (by decide)

theorem KZ_scale (k : Fin 1) :
    toVec (KZ k) = (scale : ℚ) • KVec (7 : Fin 10) k := by
  fin_cases k
  · simp [KVec, KRow0]; exact KZ_scale_0

theorem YZ_scale_0 : toVec (YZ 0) = (scale : ℚ) • YCell0_6 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem YZ_scale (k : Fin 1) :
    toVec (YZ k) = (scale : ℚ) • YVec k (6 : Fin 10) := by
  fin_cases k
  · simp [YVec, YRow0]; exact YZ_scale_0

theorem entry_eq :
    (matrixMul XVec AVec + matrixMul KVec YVec)
        (7 : Fin 10) (6 : Fin 10) = ![0, 0, 0, 0, 0, 0, 0, 0, 0, 0] := by
  change (∑ k : Fin 20, mul (XVec (7 : Fin 10) k)
      (AVec k (6 : Fin 10))) +
    (∑ k : Fin 1, mul (KVec (7 : Fin 10) k)
      (YVec k (6 : Fin 10))) = _
  refine add_sum_mul_eq_of_scaled scale scale_ne_zero
    (fun k => XVec (7 : Fin 10) k)
    (fun k => AVec k (6 : Fin 10))
    (fun k => KVec (7 : Fin 10) k)
    (fun k => YVec k (6 : Fin 10))
    XZ AZ KZ YZ XZ_scale AZ_scale KZ_scale YZ_scale entryZ rfl _ ?_
  rw [entryZ_eq, toVec_zeroZ_smul, vec_zero_eq]

theorem entry_eq_matrixOne :
    (matrixMul XVec AVec + matrixMul KVec YVec)
        (7 : Fin 10) (6 : Fin 10) =
      matrixOne (Fin 10) (7 : Fin 10) (6 : Fin 10) := by
  rw [entry_eq]
  have hne : (7 : Fin 10) ≠ (6 : Fin 10) := by decide
  funext n
  fin_cases n <;> simp [matrixOne, constVec, basis, *]

end V14Formalization.D12PieceAASplitEntry7_6


namespace V14Formalization.D12PieceAASplitEntry7_7
open D12CyclotomicVec D12CyclotomicVecZ D12PieceAAData
def payloadSha256 : String := "76c6196f29afe1a8398af99502447f48ebeed4bcb3805fc5dbec693940bc04b0"

def scale : ℤ := 44

def XZ (k : Fin 20) : VecZ :=
  match k.val with
  | 0 => #v[18, -70, -4, 34, -33, -15, -19, 54, -77, 13]
  | 1 => #v[16, -17, 1, 5, -9, 11, -19, 17, 1, -6]
  | 2 => #v[-119, -2, -41, -108, -1, -99, 29, -164, 46, -113]
  | 3 => #v[32, 70, 43, 35, 11, 82, 0, 61, 39, 78]
  | 4 => #v[16, 3, -5, 24, 1, -7, 16, 15, -13, 16]
  | 5 => #v[-62, -104, -58, -50, -40, -144, -10, -86, -50, -144]
  | 6 => #v[38, -28, 24, 52, -16, 10, -18, 90, -46, 48]
  | 7 => #v[-138, -162, -84, -142, -82, -200, -30, -200, -42, -240]
  | 8 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  | 9 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  | 10 => #v[22, 22, 0, 22, -11, 22, 11, 11, 22, 0]
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
  | 0 => #v[0, 0, 8, -8, -8, 8, 0, 0, 0, 0]
  | 1 => #v[-8, -8, -8, -8, 0, -8, -16, -8, -16, -8]
  | 2 => #v[-8, 0, -8, -8, -16, -8, -8, -16, -8, -8]
  | 3 => #v[0, -8, 0, 0, 8, 8, 0, 0, -8, 0]
  | 4 => #v[0, -8, 8, 0, 0, 0, 8, -8, 0, 0]
  | 5 => #v[-8, -4, -4, -12, -4, -4, -8, 0, 0, 0]
  | 6 => #v[-4, 4, 8, 4, -4, 0, 0, -4, -4, 0]
  | 7 => #v[36, 4, -8, 0, -4, -8, -4, -4, -8, -4]
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

def KZ (k : Fin 1) : VecZ :=
  match k.val with
  | 0 => #v[22, 0, -22, 0, 0, 0, 22, -22, 0, -22]
  | _ => zeroZ

def YZ (k : Fin 1) : VecZ :=
  match k.val with
  | 0 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  | _ => zeroZ

def xaEntryZ : VecZ := sumFin (fun k => mulZ (XZ k) (AZ k))
def kyEntryZ : VecZ := sumFin (fun k => mulZ (KZ k) (YZ k))
def entryZ : VecZ := addZ xaEntryZ kyEntryZ

theorem entryZ_eq : entryZ = scaleSqE0 scale := by
  decide +kernel

theorem scale_ne_zero : scale ≠ 0 := by
  decide

theorem XZ_scale_0 : toVec (XZ 0) = (scale : ℚ) • XCell7_0 := by
  funext i
  fin_cases i
  · change ((18 : ℤ) : ℚ) = (scale : ℚ) * (9 / 22 : ℚ)
    exact eq_smul_div (18) scale (9) (22) (by decide) (by decide)
  · change ((-70 : ℤ) : ℚ) = (scale : ℚ) * (-35 / 22 : ℚ)
    exact eq_smul_div (-70) scale (-35) (22) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)
  · change ((34 : ℤ) : ℚ) = (scale : ℚ) * (17 / 22 : ℚ)
    exact eq_smul_div (34) scale (17) (22) (by decide) (by decide)
  · change ((-33 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 4 : ℚ)
    exact eq_smul_div (-33) scale (-3) (4) (by decide) (by decide)
  · change ((-15 : ℤ) : ℚ) = (scale : ℚ) * (-15 / 44 : ℚ)
    exact eq_smul_div (-15) scale (-15) (44) (by decide) (by decide)
  · change ((-19 : ℤ) : ℚ) = (scale : ℚ) * (-19 / 44 : ℚ)
    exact eq_smul_div (-19) scale (-19) (44) (by decide) (by decide)
  · change ((54 : ℤ) : ℚ) = (scale : ℚ) * (27 / 22 : ℚ)
    exact eq_smul_div (54) scale (27) (22) (by decide) (by decide)
  · change ((-77 : ℤ) : ℚ) = (scale : ℚ) * (-7 / 4 : ℚ)
    exact eq_smul_div (-77) scale (-7) (4) (by decide) (by decide)
  · change ((13 : ℤ) : ℚ) = (scale : ℚ) * (13 / 44 : ℚ)
    exact eq_smul_div (13) scale (13) (44) (by decide) (by decide)

theorem XZ_scale_1 : toVec (XZ 1) = (scale : ℚ) • XCell7_1 := by
  funext i
  fin_cases i
  · change ((16 : ℤ) : ℚ) = (scale : ℚ) * (4 / 11 : ℚ)
    exact eq_smul_div (16) scale (4) (11) (by decide) (by decide)
  · change ((-17 : ℤ) : ℚ) = (scale : ℚ) * (-17 / 44 : ℚ)
    exact eq_smul_div (-17) scale (-17) (44) (by decide) (by decide)
  · change ((1 : ℤ) : ℚ) = (scale : ℚ) * (1 / 44 : ℚ)
    exact eq_smul_div (1) scale (1) (44) (by decide) (by decide)
  · change ((5 : ℤ) : ℚ) = (scale : ℚ) * (5 / 44 : ℚ)
    exact eq_smul_div (5) scale (5) (44) (by decide) (by decide)
  · change ((-9 : ℤ) : ℚ) = (scale : ℚ) * (-9 / 44 : ℚ)
    exact eq_smul_div (-9) scale (-9) (44) (by decide) (by decide)
  · change ((11 : ℤ) : ℚ) = (scale : ℚ) * (1 / 4 : ℚ)
    exact eq_smul_div (11) scale (1) (4) (by decide) (by decide)
  · change ((-19 : ℤ) : ℚ) = (scale : ℚ) * (-19 / 44 : ℚ)
    exact eq_smul_div (-19) scale (-19) (44) (by decide) (by decide)
  · change ((17 : ℤ) : ℚ) = (scale : ℚ) * (17 / 44 : ℚ)
    exact eq_smul_div (17) scale (17) (44) (by decide) (by decide)
  · change ((1 : ℤ) : ℚ) = (scale : ℚ) * (1 / 44 : ℚ)
    exact eq_smul_div (1) scale (1) (44) (by decide) (by decide)
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-6) scale (-3) (22) (by decide) (by decide)

theorem XZ_scale_2 : toVec (XZ 2) = (scale : ℚ) • XCell7_2 := by
  funext i
  fin_cases i
  · change ((-119 : ℤ) : ℚ) = (scale : ℚ) * (-119 / 44 : ℚ)
    exact eq_smul_div (-119) scale (-119) (44) (by decide) (by decide)
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 22 : ℚ)
    exact eq_smul_div (-2) scale (-1) (22) (by decide) (by decide)
  · change ((-41 : ℤ) : ℚ) = (scale : ℚ) * (-41 / 44 : ℚ)
    exact eq_smul_div (-41) scale (-41) (44) (by decide) (by decide)
  · change ((-108 : ℤ) : ℚ) = (scale : ℚ) * (-27 / 11 : ℚ)
    exact eq_smul_div (-108) scale (-27) (11) (by decide) (by decide)
  · change ((-1 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 44 : ℚ)
    exact eq_smul_div (-1) scale (-1) (44) (by decide) (by decide)
  · change ((-99 : ℤ) : ℚ) = (scale : ℚ) * (-9 / 4 : ℚ)
    exact eq_smul_div (-99) scale (-9) (4) (by decide) (by decide)
  · change ((29 : ℤ) : ℚ) = (scale : ℚ) * (29 / 44 : ℚ)
    exact eq_smul_div (29) scale (29) (44) (by decide) (by decide)
  · change ((-164 : ℤ) : ℚ) = (scale : ℚ) * (-41 / 11 : ℚ)
    exact eq_smul_div (-164) scale (-41) (11) (by decide) (by decide)
  · change ((46 : ℤ) : ℚ) = (scale : ℚ) * (23 / 22 : ℚ)
    exact eq_smul_div (46) scale (23) (22) (by decide) (by decide)
  · change ((-113 : ℤ) : ℚ) = (scale : ℚ) * (-113 / 44 : ℚ)
    exact eq_smul_div (-113) scale (-113) (44) (by decide) (by decide)

theorem XZ_scale_3 : toVec (XZ 3) = (scale : ℚ) • XCell7_3 := by
  funext i
  fin_cases i
  · change ((32 : ℤ) : ℚ) = (scale : ℚ) * (8 / 11 : ℚ)
    exact eq_smul_div (32) scale (8) (11) (by decide) (by decide)
  · change ((70 : ℤ) : ℚ) = (scale : ℚ) * (35 / 22 : ℚ)
    exact eq_smul_div (70) scale (35) (22) (by decide) (by decide)
  · change ((43 : ℤ) : ℚ) = (scale : ℚ) * (43 / 44 : ℚ)
    exact eq_smul_div (43) scale (43) (44) (by decide) (by decide)
  · change ((35 : ℤ) : ℚ) = (scale : ℚ) * (35 / 44 : ℚ)
    exact eq_smul_div (35) scale (35) (44) (by decide) (by decide)
  · change ((11 : ℤ) : ℚ) = (scale : ℚ) * (1 / 4 : ℚ)
    exact eq_smul_div (11) scale (1) (4) (by decide) (by decide)
  · change ((82 : ℤ) : ℚ) = (scale : ℚ) * (41 / 22 : ℚ)
    exact eq_smul_div (82) scale (41) (22) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((61 : ℤ) : ℚ) = (scale : ℚ) * (61 / 44 : ℚ)
    exact eq_smul_div (61) scale (61) (44) (by decide) (by decide)
  · change ((39 : ℤ) : ℚ) = (scale : ℚ) * (39 / 44 : ℚ)
    exact eq_smul_div (39) scale (39) (44) (by decide) (by decide)
  · change ((78 : ℤ) : ℚ) = (scale : ℚ) * (39 / 22 : ℚ)
    exact eq_smul_div (78) scale (39) (22) (by decide) (by decide)

theorem XZ_scale_4 : toVec (XZ 4) = (scale : ℚ) • XCell7_4 := by
  funext i
  fin_cases i
  · change ((16 : ℤ) : ℚ) = (scale : ℚ) * (4 / 11 : ℚ)
    exact eq_smul_div (16) scale (4) (11) (by decide) (by decide)
  · change ((3 : ℤ) : ℚ) = (scale : ℚ) * (3 / 44 : ℚ)
    exact eq_smul_div (3) scale (3) (44) (by decide) (by decide)
  · change ((-5 : ℤ) : ℚ) = (scale : ℚ) * (-5 / 44 : ℚ)
    exact eq_smul_div (-5) scale (-5) (44) (by decide) (by decide)
  · change ((24 : ℤ) : ℚ) = (scale : ℚ) * (6 / 11 : ℚ)
    exact eq_smul_div (24) scale (6) (11) (by decide) (by decide)
  · change ((1 : ℤ) : ℚ) = (scale : ℚ) * (1 / 44 : ℚ)
    exact eq_smul_div (1) scale (1) (44) (by decide) (by decide)
  · change ((-7 : ℤ) : ℚ) = (scale : ℚ) * (-7 / 44 : ℚ)
    exact eq_smul_div (-7) scale (-7) (44) (by decide) (by decide)
  · change ((16 : ℤ) : ℚ) = (scale : ℚ) * (4 / 11 : ℚ)
    exact eq_smul_div (16) scale (4) (11) (by decide) (by decide)
  · change ((15 : ℤ) : ℚ) = (scale : ℚ) * (15 / 44 : ℚ)
    exact eq_smul_div (15) scale (15) (44) (by decide) (by decide)
  · change ((-13 : ℤ) : ℚ) = (scale : ℚ) * (-13 / 44 : ℚ)
    exact eq_smul_div (-13) scale (-13) (44) (by decide) (by decide)
  · change ((16 : ℤ) : ℚ) = (scale : ℚ) * (4 / 11 : ℚ)
    exact eq_smul_div (16) scale (4) (11) (by decide) (by decide)

theorem XZ_scale_5 : toVec (XZ 5) = (scale : ℚ) • XCell7_5 := by
  funext i
  fin_cases i
  · change ((-62 : ℤ) : ℚ) = (scale : ℚ) * (-31 / 22 : ℚ)
    exact eq_smul_div (-62) scale (-31) (22) (by decide) (by decide)
  · change ((-104 : ℤ) : ℚ) = (scale : ℚ) * (-26 / 11 : ℚ)
    exact eq_smul_div (-104) scale (-26) (11) (by decide) (by decide)
  · change ((-58 : ℤ) : ℚ) = (scale : ℚ) * (-29 / 22 : ℚ)
    exact eq_smul_div (-58) scale (-29) (22) (by decide) (by decide)
  · change ((-50 : ℤ) : ℚ) = (scale : ℚ) * (-25 / 22 : ℚ)
    exact eq_smul_div (-50) scale (-25) (22) (by decide) (by decide)
  · change ((-40 : ℤ) : ℚ) = (scale : ℚ) * (-10 / 11 : ℚ)
    exact eq_smul_div (-40) scale (-10) (11) (by decide) (by decide)
  · change ((-144 : ℤ) : ℚ) = (scale : ℚ) * (-36 / 11 : ℚ)
    exact eq_smul_div (-144) scale (-36) (11) (by decide) (by decide)
  · change ((-10 : ℤ) : ℚ) = (scale : ℚ) * (-5 / 22 : ℚ)
    exact eq_smul_div (-10) scale (-5) (22) (by decide) (by decide)
  · change ((-86 : ℤ) : ℚ) = (scale : ℚ) * (-43 / 22 : ℚ)
    exact eq_smul_div (-86) scale (-43) (22) (by decide) (by decide)
  · change ((-50 : ℤ) : ℚ) = (scale : ℚ) * (-25 / 22 : ℚ)
    exact eq_smul_div (-50) scale (-25) (22) (by decide) (by decide)
  · change ((-144 : ℤ) : ℚ) = (scale : ℚ) * (-36 / 11 : ℚ)
    exact eq_smul_div (-144) scale (-36) (11) (by decide) (by decide)

theorem XZ_scale_6 : toVec (XZ 6) = (scale : ℚ) • XCell7_6 := by
  funext i
  fin_cases i
  · change ((38 : ℤ) : ℚ) = (scale : ℚ) * (19 / 22 : ℚ)
    exact eq_smul_div (38) scale (19) (22) (by decide) (by decide)
  · change ((-28 : ℤ) : ℚ) = (scale : ℚ) * (-7 / 11 : ℚ)
    exact eq_smul_div (-28) scale (-7) (11) (by decide) (by decide)
  · change ((24 : ℤ) : ℚ) = (scale : ℚ) * (6 / 11 : ℚ)
    exact eq_smul_div (24) scale (6) (11) (by decide) (by decide)
  · change ((52 : ℤ) : ℚ) = (scale : ℚ) * (13 / 11 : ℚ)
    exact eq_smul_div (52) scale (13) (11) (by decide) (by decide)
  · change ((-16 : ℤ) : ℚ) = (scale : ℚ) * (-4 / 11 : ℚ)
    exact eq_smul_div (-16) scale (-4) (11) (by decide) (by decide)
  · change ((10 : ℤ) : ℚ) = (scale : ℚ) * (5 / 22 : ℚ)
    exact eq_smul_div (10) scale (5) (22) (by decide) (by decide)
  · change ((-18 : ℤ) : ℚ) = (scale : ℚ) * (-9 / 22 : ℚ)
    exact eq_smul_div (-18) scale (-9) (22) (by decide) (by decide)
  · change ((90 : ℤ) : ℚ) = (scale : ℚ) * (45 / 22 : ℚ)
    exact eq_smul_div (90) scale (45) (22) (by decide) (by decide)
  · change ((-46 : ℤ) : ℚ) = (scale : ℚ) * (-23 / 22 : ℚ)
    exact eq_smul_div (-46) scale (-23) (22) (by decide) (by decide)
  · change ((48 : ℤ) : ℚ) = (scale : ℚ) * (12 / 11 : ℚ)
    exact eq_smul_div (48) scale (12) (11) (by decide) (by decide)

theorem XZ_scale_7 : toVec (XZ 7) = (scale : ℚ) • XCell7_7 := by
  funext i
  fin_cases i
  · change ((-138 : ℤ) : ℚ) = (scale : ℚ) * (-69 / 22 : ℚ)
    exact eq_smul_div (-138) scale (-69) (22) (by decide) (by decide)
  · change ((-162 : ℤ) : ℚ) = (scale : ℚ) * (-81 / 22 : ℚ)
    exact eq_smul_div (-162) scale (-81) (22) (by decide) (by decide)
  · change ((-84 : ℤ) : ℚ) = (scale : ℚ) * (-21 / 11 : ℚ)
    exact eq_smul_div (-84) scale (-21) (11) (by decide) (by decide)
  · change ((-142 : ℤ) : ℚ) = (scale : ℚ) * (-71 / 22 : ℚ)
    exact eq_smul_div (-142) scale (-71) (22) (by decide) (by decide)
  · change ((-82 : ℤ) : ℚ) = (scale : ℚ) * (-41 / 22 : ℚ)
    exact eq_smul_div (-82) scale (-41) (22) (by decide) (by decide)
  · change ((-200 : ℤ) : ℚ) = (scale : ℚ) * (-50 / 11 : ℚ)
    exact eq_smul_div (-200) scale (-50) (11) (by decide) (by decide)
  · change ((-30 : ℤ) : ℚ) = (scale : ℚ) * (-15 / 22 : ℚ)
    exact eq_smul_div (-30) scale (-15) (22) (by decide) (by decide)
  · change ((-200 : ℤ) : ℚ) = (scale : ℚ) * (-50 / 11 : ℚ)
    exact eq_smul_div (-200) scale (-50) (11) (by decide) (by decide)
  · change ((-42 : ℤ) : ℚ) = (scale : ℚ) * (-21 / 22 : ℚ)
    exact eq_smul_div (-42) scale (-21) (22) (by decide) (by decide)
  · change ((-240 : ℤ) : ℚ) = (scale : ℚ) * (-60 / 11 : ℚ)
    exact eq_smul_div (-240) scale (-60) (11) (by decide) (by decide)

theorem XZ_scale_8 : toVec (XZ 8) = (scale : ℚ) • XCell7_8 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem XZ_scale_9 : toVec (XZ 9) = (scale : ℚ) • XCell7_9 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem XZ_scale_10 : toVec (XZ 10) = (scale : ℚ) • XCell7_10 := by
  funext i
  fin_cases i
  · change ((22 : ℤ) : ℚ) = (scale : ℚ) * (1 / 2 : ℚ)
    exact eq_smul_div (22) scale (1) (2) (by decide) (by decide)
  · change ((22 : ℤ) : ℚ) = (scale : ℚ) * (1 / 2 : ℚ)
    exact eq_smul_div (22) scale (1) (2) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((22 : ℤ) : ℚ) = (scale : ℚ) * (1 / 2 : ℚ)
    exact eq_smul_div (22) scale (1) (2) (by decide) (by decide)
  · change ((-11 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 4 : ℚ)
    exact eq_smul_div (-11) scale (-1) (4) (by decide) (by decide)
  · change ((22 : ℤ) : ℚ) = (scale : ℚ) * (1 / 2 : ℚ)
    exact eq_smul_div (22) scale (1) (2) (by decide) (by decide)
  · change ((11 : ℤ) : ℚ) = (scale : ℚ) * (1 / 4 : ℚ)
    exact eq_smul_div (11) scale (1) (4) (by decide) (by decide)
  · change ((11 : ℤ) : ℚ) = (scale : ℚ) * (1 / 4 : ℚ)
    exact eq_smul_div (11) scale (1) (4) (by decide) (by decide)
  · change ((22 : ℤ) : ℚ) = (scale : ℚ) * (1 / 2 : ℚ)
    exact eq_smul_div (22) scale (1) (2) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem XZ_scale_11 : toVec (XZ 11) = (scale : ℚ) • XCell7_11 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem XZ_scale_12 : toVec (XZ 12) = (scale : ℚ) • XCell7_12 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem XZ_scale_13 : toVec (XZ 13) = (scale : ℚ) • XCell7_13 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem XZ_scale_14 : toVec (XZ 14) = (scale : ℚ) • XCell7_14 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem XZ_scale_15 : toVec (XZ 15) = (scale : ℚ) • XCell7_15 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem XZ_scale_16 : toVec (XZ 16) = (scale : ℚ) • XCell7_16 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem XZ_scale_17 : toVec (XZ 17) = (scale : ℚ) • XCell7_17 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem XZ_scale_18 : toVec (XZ 18) = (scale : ℚ) • XCell7_18 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem XZ_scale_19 : toVec (XZ 19) = (scale : ℚ) • XCell7_19 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem XZ_scale (k : Fin 20) :
    toVec (XZ k) = (scale : ℚ) • XVec (7 : Fin 10) k := by
  fin_cases k
  · simp [XVec, XRow7]; exact XZ_scale_0
  · simp [XVec, XRow7]; exact XZ_scale_1
  · simp [XVec, XRow7]; exact XZ_scale_2
  · simp [XVec, XRow7]; exact XZ_scale_3
  · simp [XVec, XRow7]; exact XZ_scale_4
  · simp [XVec, XRow7]; exact XZ_scale_5
  · simp [XVec, XRow7]; exact XZ_scale_6
  · simp [XVec, XRow7]; exact XZ_scale_7
  · simp [XVec, XRow7]; exact XZ_scale_8
  · simp [XVec, XRow7]; exact XZ_scale_9
  · simp [XVec, XRow7]; exact XZ_scale_10
  · simp [XVec, XRow7]; exact XZ_scale_11
  · simp [XVec, XRow7]; exact XZ_scale_12
  · simp [XVec, XRow7]; exact XZ_scale_13
  · simp [XVec, XRow7]; exact XZ_scale_14
  · simp [XVec, XRow7]; exact XZ_scale_15
  · simp [XVec, XRow7]; exact XZ_scale_16
  · simp [XVec, XRow7]; exact XZ_scale_17
  · simp [XVec, XRow7]; exact XZ_scale_18
  · simp [XVec, XRow7]; exact XZ_scale_19

theorem AZ_scale_0 : toVec (AZ 0) = (scale : ℚ) • ACell0_7 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (8) scale (2) (11) (by decide) (by decide)
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-2) (11) (by decide) (by decide)
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-2) (11) (by decide) (by decide)
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (8) scale (2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem AZ_scale_1 : toVec (AZ 1) = (scale : ℚ) • ACell1_7 := by
  funext i
  fin_cases i
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-2) (11) (by decide) (by decide)
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-2) (11) (by decide) (by decide)
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-2) (11) (by decide) (by decide)
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-2) (11) (by decide) (by decide)
  · change ((-16 : ℤ) : ℚ) = (scale : ℚ) * (-4 / 11 : ℚ)
    exact eq_smul_div (-16) scale (-4) (11) (by decide) (by decide)
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-2) (11) (by decide) (by decide)
  · change ((-16 : ℤ) : ℚ) = (scale : ℚ) * (-4 / 11 : ℚ)
    exact eq_smul_div (-16) scale (-4) (11) (by decide) (by decide)
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-2) (11) (by decide) (by decide)

theorem AZ_scale_2 : toVec (AZ 2) = (scale : ℚ) • ACell2_7 := by
  funext i
  fin_cases i
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-2) (11) (by decide) (by decide)
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-2) (11) (by decide) (by decide)
  · change ((-16 : ℤ) : ℚ) = (scale : ℚ) * (-4 / 11 : ℚ)
    exact eq_smul_div (-16) scale (-4) (11) (by decide) (by decide)
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-2) (11) (by decide) (by decide)
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-2) (11) (by decide) (by decide)
  · change ((-16 : ℤ) : ℚ) = (scale : ℚ) * (-4 / 11 : ℚ)
    exact eq_smul_div (-16) scale (-4) (11) (by decide) (by decide)
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-2) (11) (by decide) (by decide)
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-2) (11) (by decide) (by decide)

theorem AZ_scale_3 : toVec (AZ 3) = (scale : ℚ) • ACell3_7 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (8) scale (2) (11) (by decide) (by decide)
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (8) scale (2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem AZ_scale_4 : toVec (AZ 4) = (scale : ℚ) • ACell4_7 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-2) (11) (by decide) (by decide)
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (8) scale (2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (8) scale (2) (11) (by decide) (by decide)
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem AZ_scale_5 : toVec (AZ 5) = (scale : ℚ) • ACell5_7 := by
  funext i
  fin_cases i
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-2) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)
  · change ((-12 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 11 : ℚ)
    exact eq_smul_div (-12) scale (-3) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem AZ_scale_6 : toVec (AZ 6) = (scale : ℚ) • ACell6_7 := by
  funext i
  fin_cases i
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (4) scale (1) (11) (by decide) (by decide)
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (8) scale (2) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (4) scale (1) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem AZ_scale_7 : toVec (AZ 7) = (scale : ℚ) • ACell7_7 := by
  funext i
  fin_cases i
  · change ((36 : ℤ) : ℚ) = (scale : ℚ) * (9 / 11 : ℚ)
    exact eq_smul_div (36) scale (9) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (4) scale (1) (11) (by decide) (by decide)
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-2) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-2) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)

theorem AZ_scale_8 : toVec (AZ 8) = (scale : ℚ) • ACell8_7 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (4) scale (1) (11) (by decide) (by decide)
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (8) scale (2) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (4) scale (1) (11) (by decide) (by decide)
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (8) scale (2) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (8) scale (2) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (4) scale (1) (11) (by decide) (by decide)
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (8) scale (2) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (4) scale (1) (11) (by decide) (by decide)

theorem AZ_scale_9 : toVec (AZ 9) = (scale : ℚ) • ACell9_7 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (8) scale (2) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (4) scale (1) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (4) scale (1) (11) (by decide) (by decide)
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (8) scale (2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (4) scale (1) (11) (by decide) (by decide)
  · change ((12 : ℤ) : ℚ) = (scale : ℚ) * (3 / 11 : ℚ)
    exact eq_smul_div (12) scale (3) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (4) scale (1) (11) (by decide) (by decide)

theorem AZ_scale_10 : toVec (AZ 10) = (scale : ℚ) • ACell10_7 := by
  funext i
  fin_cases i
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (8) scale (2) (11) (by decide) (by decide)
  · change ((16 : ℤ) : ℚ) = (scale : ℚ) * (4 / 11 : ℚ)
    exact eq_smul_div (16) scale (4) (11) (by decide) (by decide)
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (8) scale (2) (11) (by decide) (by decide)
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (8) scale (2) (11) (by decide) (by decide)
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (8) scale (2) (11) (by decide) (by decide)
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (8) scale (2) (11) (by decide) (by decide)
  · change ((16 : ℤ) : ℚ) = (scale : ℚ) * (4 / 11 : ℚ)
    exact eq_smul_div (16) scale (4) (11) (by decide) (by decide)
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (8) scale (2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (8) scale (2) (11) (by decide) (by decide)

theorem AZ_scale_11 : toVec (AZ 11) = (scale : ℚ) • ACell11_7 := by
  funext i
  fin_cases i
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-2) (11) (by decide) (by decide)
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-2) (11) (by decide) (by decide)
  · change ((-16 : ℤ) : ℚ) = (scale : ℚ) * (-4 / 11 : ℚ)
    exact eq_smul_div (-16) scale (-4) (11) (by decide) (by decide)
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-2) (11) (by decide) (by decide)
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-2) (11) (by decide) (by decide)
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-2) (11) (by decide) (by decide)
  · change ((-16 : ℤ) : ℚ) = (scale : ℚ) * (-4 / 11 : ℚ)
    exact eq_smul_div (-16) scale (-4) (11) (by decide) (by decide)
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-2) (11) (by decide) (by decide)
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem AZ_scale_12 : toVec (AZ 12) = (scale : ℚ) • ACell12_7 := by
  funext i
  fin_cases i
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-2) (11) (by decide) (by decide)
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (8) scale (2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (8) scale (2) (11) (by decide) (by decide)
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem AZ_scale_13 : toVec (AZ 13) = (scale : ℚ) • ACell13_7 := by
  funext i
  fin_cases i
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (8) scale (2) (11) (by decide) (by decide)
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (8) scale (2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (8) scale (2) (11) (by decide) (by decide)
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (8) scale (2) (11) (by decide) (by decide)
  · change ((16 : ℤ) : ℚ) = (scale : ℚ) * (4 / 11 : ℚ)
    exact eq_smul_div (16) scale (4) (11) (by decide) (by decide)
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (8) scale (2) (11) (by decide) (by decide)
  · change ((16 : ℤ) : ℚ) = (scale : ℚ) * (4 / 11 : ℚ)
    exact eq_smul_div (16) scale (4) (11) (by decide) (by decide)
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (8) scale (2) (11) (by decide) (by decide)
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (8) scale (2) (11) (by decide) (by decide)

theorem AZ_scale_14 : toVec (AZ 14) = (scale : ℚ) • ACell14_7 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (8) scale (2) (11) (by decide) (by decide)
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-2) (11) (by decide) (by decide)
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-2) (11) (by decide) (by decide)
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (8) scale (2) (11) (by decide) (by decide)

theorem AZ_scale_15 : toVec (AZ 15) = (scale : ℚ) • ACell15_7 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (4) scale (1) (11) (by decide) (by decide)
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (8) scale (2) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (4) scale (1) (11) (by decide) (by decide)
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (8) scale (2) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (8) scale (2) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (4) scale (1) (11) (by decide) (by decide)
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (8) scale (2) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (4) scale (1) (11) (by decide) (by decide)

theorem AZ_scale_16 : toVec (AZ 16) = (scale : ℚ) • ACell16_7 := by
  funext i
  fin_cases i
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-2) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-2) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-2) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (4) scale (1) (11) (by decide) (by decide)
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-2) (11) (by decide) (by decide)

theorem AZ_scale_17 : toVec (AZ 17) = (scale : ℚ) • ACell17_7 := by
  funext i
  fin_cases i
  · change ((52 : ℤ) : ℚ) = (scale : ℚ) * (13 / 11 : ℚ)
    exact eq_smul_div (52) scale (13) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (4) scale (1) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (4) scale (1) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)

theorem AZ_scale_18 : toVec (AZ 18) = (scale : ℚ) • ACell18_7 := by
  funext i
  fin_cases i
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (4) scale (1) (11) (by decide) (by decide)
  · change ((12 : ℤ) : ℚ) = (scale : ℚ) * (3 / 11 : ℚ)
    exact eq_smul_div (12) scale (3) (11) (by decide) (by decide)
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (8) scale (2) (11) (by decide) (by decide)
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (8) scale (2) (11) (by decide) (by decide)
  · change ((12 : ℤ) : ℚ) = (scale : ℚ) * (3 / 11 : ℚ)
    exact eq_smul_div (12) scale (3) (11) (by decide) (by decide)
  · change ((12 : ℤ) : ℚ) = (scale : ℚ) * (3 / 11 : ℚ)
    exact eq_smul_div (12) scale (3) (11) (by decide) (by decide)
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (8) scale (2) (11) (by decide) (by decide)
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (8) scale (2) (11) (by decide) (by decide)
  · change ((12 : ℤ) : ℚ) = (scale : ℚ) * (3 / 11 : ℚ)
    exact eq_smul_div (12) scale (3) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (4) scale (1) (11) (by decide) (by decide)

theorem AZ_scale_19 : toVec (AZ 19) = (scale : ℚ) • ACell19_7 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (8) scale (2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (4) scale (1) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (4) scale (1) (11) (by decide) (by decide)

theorem AZ_scale (k : Fin 20) :
    toVec (AZ k) = (scale : ℚ) • AVec k (7 : Fin 10) := by
  fin_cases k
  · simp [AVec, ARow0]; exact AZ_scale_0
  · simp [AVec, ARow1]; exact AZ_scale_1
  · simp [AVec, ARow2]; exact AZ_scale_2
  · simp [AVec, ARow3]; exact AZ_scale_3
  · simp [AVec, ARow4]; exact AZ_scale_4
  · simp [AVec, ARow5]; exact AZ_scale_5
  · simp [AVec, ARow6]; exact AZ_scale_6
  · simp [AVec, ARow7]; exact AZ_scale_7
  · simp [AVec, ARow8]; exact AZ_scale_8
  · simp [AVec, ARow9]; exact AZ_scale_9
  · simp [AVec, ARow10]; exact AZ_scale_10
  · simp [AVec, ARow11]; exact AZ_scale_11
  · simp [AVec, ARow12]; exact AZ_scale_12
  · simp [AVec, ARow13]; exact AZ_scale_13
  · simp [AVec, ARow14]; exact AZ_scale_14
  · simp [AVec, ARow15]; exact AZ_scale_15
  · simp [AVec, ARow16]; exact AZ_scale_16
  · simp [AVec, ARow17]; exact AZ_scale_17
  · simp [AVec, ARow18]; exact AZ_scale_18
  · simp [AVec, ARow19]; exact AZ_scale_19

theorem KZ_scale_0 : toVec (KZ 0) = (scale : ℚ) • KCell7_0 := by
  funext i
  fin_cases i
  · change ((22 : ℤ) : ℚ) = (scale : ℚ) * (1 / 2 : ℚ)
    exact eq_smul_div (22) scale (1) (2) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-22 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 2 : ℚ)
    exact eq_smul_div (-22) scale (-1) (2) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((22 : ℤ) : ℚ) = (scale : ℚ) * (1 / 2 : ℚ)
    exact eq_smul_div (22) scale (1) (2) (by decide) (by decide)
  · change ((-22 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 2 : ℚ)
    exact eq_smul_div (-22) scale (-1) (2) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-22 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 2 : ℚ)
    exact eq_smul_div (-22) scale (-1) (2) (by decide) (by decide)

theorem KZ_scale (k : Fin 1) :
    toVec (KZ k) = (scale : ℚ) • KVec (7 : Fin 10) k := by
  fin_cases k
  · simp [KVec, KRow0]; exact KZ_scale_0

theorem YZ_scale_0 : toVec (YZ 0) = (scale : ℚ) • YCell0_7 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem YZ_scale (k : Fin 1) :
    toVec (YZ k) = (scale : ℚ) • YVec k (7 : Fin 10) := by
  fin_cases k
  · simp [YVec, YRow0]; exact YZ_scale_0

theorem entry_eq :
    (matrixMul XVec AVec + matrixMul KVec YVec)
        (7 : Fin 10) (7 : Fin 10) = ![1, 0, 0, 0, 0, 0, 0, 0, 0, 0] := by
  change (∑ k : Fin 20, mul (XVec (7 : Fin 10) k)
      (AVec k (7 : Fin 10))) +
    (∑ k : Fin 1, mul (KVec (7 : Fin 10) k)
      (YVec k (7 : Fin 10))) = _
  refine add_sum_mul_eq_of_scaled scale scale_ne_zero
    (fun k => XVec (7 : Fin 10) k)
    (fun k => AVec k (7 : Fin 10))
    (fun k => KVec (7 : Fin 10) k)
    (fun k => YVec k (7 : Fin 10))
    XZ AZ KZ YZ XZ_scale AZ_scale KZ_scale YZ_scale entryZ rfl _ ?_
  rw [entryZ_eq, toVec_scaleSqE0, constVec_one_eq]

theorem entry_eq_matrixOne :
    (matrixMul XVec AVec + matrixMul KVec YVec)
        (7 : Fin 10) (7 : Fin 10) =
      matrixOne (Fin 10) (7 : Fin 10) (7 : Fin 10) := by
  rw [entry_eq]
  funext n
  fin_cases n <;> simp [matrixOne, constVec, basis, *]

end V14Formalization.D12PieceAASplitEntry7_7


namespace V14Formalization.D12PieceAASplitEntry7_8
open D12CyclotomicVec D12CyclotomicVecZ D12PieceAAData
def payloadSha256 : String := "76c6196f29afe1a8398af99502447f48ebeed4bcb3805fc5dbec693940bc04b0"

def scale : ℤ := 44

def XZ (k : Fin 20) : VecZ :=
  match k.val with
  | 0 => #v[18, -70, -4, 34, -33, -15, -19, 54, -77, 13]
  | 1 => #v[16, -17, 1, 5, -9, 11, -19, 17, 1, -6]
  | 2 => #v[-119, -2, -41, -108, -1, -99, 29, -164, 46, -113]
  | 3 => #v[32, 70, 43, 35, 11, 82, 0, 61, 39, 78]
  | 4 => #v[16, 3, -5, 24, 1, -7, 16, 15, -13, 16]
  | 5 => #v[-62, -104, -58, -50, -40, -144, -10, -86, -50, -144]
  | 6 => #v[38, -28, 24, 52, -16, 10, -18, 90, -46, 48]
  | 7 => #v[-138, -162, -84, -142, -82, -200, -30, -200, -42, -240]
  | 8 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  | 9 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  | 10 => #v[22, 22, 0, 22, -11, 22, 11, 11, 22, 0]
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
  | 0 => #v[0, -8, 0, -8, 0, 0, 8, 0, 0, 8]
  | 1 => #v[0, 0, -8, 8, 0, 0, 0, 0, 8, -8]
  | 2 => #v[0, -8, 0, 8, 0, 8, 0, -8, 0, 0]
  | 3 => #v[8, 8, 8, 8, 8, 8, 8, 0, 16, 16]
  | 4 => #v[-8, -8, -16, -16, -8, -8, 0, -8, -8, -8]
  | 5 => #v[-4, 0, 0, -4, 0, 4, -4, 8, -4, 4]
  | 6 => #v[0, 0, 0, -8, -4, -4, -12, -4, -4, -8]
  | 7 => #v[0, 4, 8, 4, 8, -4, 8, 4, 8, 4]
  | 8 => #v[40, -4, 4, 0, 0, 4, -4, -4, 0, 8]
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

def KZ (k : Fin 1) : VecZ :=
  match k.val with
  | 0 => #v[22, 0, -22, 0, 0, 0, 22, -22, 0, -22]
  | _ => zeroZ

def YZ (k : Fin 1) : VecZ :=
  match k.val with
  | 0 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  | _ => zeroZ

def xaEntryZ : VecZ := sumFin (fun k => mulZ (XZ k) (AZ k))
def kyEntryZ : VecZ := sumFin (fun k => mulZ (KZ k) (YZ k))
def entryZ : VecZ := addZ xaEntryZ kyEntryZ

theorem entryZ_eq : entryZ = zeroZ := by
  decide +kernel

theorem scale_ne_zero : scale ≠ 0 := by
  decide

theorem XZ_scale_0 : toVec (XZ 0) = (scale : ℚ) • XCell7_0 := by
  funext i
  fin_cases i
  · change ((18 : ℤ) : ℚ) = (scale : ℚ) * (9 / 22 : ℚ)
    exact eq_smul_div (18) scale (9) (22) (by decide) (by decide)
  · change ((-70 : ℤ) : ℚ) = (scale : ℚ) * (-35 / 22 : ℚ)
    exact eq_smul_div (-70) scale (-35) (22) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)
  · change ((34 : ℤ) : ℚ) = (scale : ℚ) * (17 / 22 : ℚ)
    exact eq_smul_div (34) scale (17) (22) (by decide) (by decide)
  · change ((-33 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 4 : ℚ)
    exact eq_smul_div (-33) scale (-3) (4) (by decide) (by decide)
  · change ((-15 : ℤ) : ℚ) = (scale : ℚ) * (-15 / 44 : ℚ)
    exact eq_smul_div (-15) scale (-15) (44) (by decide) (by decide)
  · change ((-19 : ℤ) : ℚ) = (scale : ℚ) * (-19 / 44 : ℚ)
    exact eq_smul_div (-19) scale (-19) (44) (by decide) (by decide)
  · change ((54 : ℤ) : ℚ) = (scale : ℚ) * (27 / 22 : ℚ)
    exact eq_smul_div (54) scale (27) (22) (by decide) (by decide)
  · change ((-77 : ℤ) : ℚ) = (scale : ℚ) * (-7 / 4 : ℚ)
    exact eq_smul_div (-77) scale (-7) (4) (by decide) (by decide)
  · change ((13 : ℤ) : ℚ) = (scale : ℚ) * (13 / 44 : ℚ)
    exact eq_smul_div (13) scale (13) (44) (by decide) (by decide)

theorem XZ_scale_1 : toVec (XZ 1) = (scale : ℚ) • XCell7_1 := by
  funext i
  fin_cases i
  · change ((16 : ℤ) : ℚ) = (scale : ℚ) * (4 / 11 : ℚ)
    exact eq_smul_div (16) scale (4) (11) (by decide) (by decide)
  · change ((-17 : ℤ) : ℚ) = (scale : ℚ) * (-17 / 44 : ℚ)
    exact eq_smul_div (-17) scale (-17) (44) (by decide) (by decide)
  · change ((1 : ℤ) : ℚ) = (scale : ℚ) * (1 / 44 : ℚ)
    exact eq_smul_div (1) scale (1) (44) (by decide) (by decide)
  · change ((5 : ℤ) : ℚ) = (scale : ℚ) * (5 / 44 : ℚ)
    exact eq_smul_div (5) scale (5) (44) (by decide) (by decide)
  · change ((-9 : ℤ) : ℚ) = (scale : ℚ) * (-9 / 44 : ℚ)
    exact eq_smul_div (-9) scale (-9) (44) (by decide) (by decide)
  · change ((11 : ℤ) : ℚ) = (scale : ℚ) * (1 / 4 : ℚ)
    exact eq_smul_div (11) scale (1) (4) (by decide) (by decide)
  · change ((-19 : ℤ) : ℚ) = (scale : ℚ) * (-19 / 44 : ℚ)
    exact eq_smul_div (-19) scale (-19) (44) (by decide) (by decide)
  · change ((17 : ℤ) : ℚ) = (scale : ℚ) * (17 / 44 : ℚ)
    exact eq_smul_div (17) scale (17) (44) (by decide) (by decide)
  · change ((1 : ℤ) : ℚ) = (scale : ℚ) * (1 / 44 : ℚ)
    exact eq_smul_div (1) scale (1) (44) (by decide) (by decide)
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-6) scale (-3) (22) (by decide) (by decide)

theorem XZ_scale_2 : toVec (XZ 2) = (scale : ℚ) • XCell7_2 := by
  funext i
  fin_cases i
  · change ((-119 : ℤ) : ℚ) = (scale : ℚ) * (-119 / 44 : ℚ)
    exact eq_smul_div (-119) scale (-119) (44) (by decide) (by decide)
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 22 : ℚ)
    exact eq_smul_div (-2) scale (-1) (22) (by decide) (by decide)
  · change ((-41 : ℤ) : ℚ) = (scale : ℚ) * (-41 / 44 : ℚ)
    exact eq_smul_div (-41) scale (-41) (44) (by decide) (by decide)
  · change ((-108 : ℤ) : ℚ) = (scale : ℚ) * (-27 / 11 : ℚ)
    exact eq_smul_div (-108) scale (-27) (11) (by decide) (by decide)
  · change ((-1 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 44 : ℚ)
    exact eq_smul_div (-1) scale (-1) (44) (by decide) (by decide)
  · change ((-99 : ℤ) : ℚ) = (scale : ℚ) * (-9 / 4 : ℚ)
    exact eq_smul_div (-99) scale (-9) (4) (by decide) (by decide)
  · change ((29 : ℤ) : ℚ) = (scale : ℚ) * (29 / 44 : ℚ)
    exact eq_smul_div (29) scale (29) (44) (by decide) (by decide)
  · change ((-164 : ℤ) : ℚ) = (scale : ℚ) * (-41 / 11 : ℚ)
    exact eq_smul_div (-164) scale (-41) (11) (by decide) (by decide)
  · change ((46 : ℤ) : ℚ) = (scale : ℚ) * (23 / 22 : ℚ)
    exact eq_smul_div (46) scale (23) (22) (by decide) (by decide)
  · change ((-113 : ℤ) : ℚ) = (scale : ℚ) * (-113 / 44 : ℚ)
    exact eq_smul_div (-113) scale (-113) (44) (by decide) (by decide)

theorem XZ_scale_3 : toVec (XZ 3) = (scale : ℚ) • XCell7_3 := by
  funext i
  fin_cases i
  · change ((32 : ℤ) : ℚ) = (scale : ℚ) * (8 / 11 : ℚ)
    exact eq_smul_div (32) scale (8) (11) (by decide) (by decide)
  · change ((70 : ℤ) : ℚ) = (scale : ℚ) * (35 / 22 : ℚ)
    exact eq_smul_div (70) scale (35) (22) (by decide) (by decide)
  · change ((43 : ℤ) : ℚ) = (scale : ℚ) * (43 / 44 : ℚ)
    exact eq_smul_div (43) scale (43) (44) (by decide) (by decide)
  · change ((35 : ℤ) : ℚ) = (scale : ℚ) * (35 / 44 : ℚ)
    exact eq_smul_div (35) scale (35) (44) (by decide) (by decide)
  · change ((11 : ℤ) : ℚ) = (scale : ℚ) * (1 / 4 : ℚ)
    exact eq_smul_div (11) scale (1) (4) (by decide) (by decide)
  · change ((82 : ℤ) : ℚ) = (scale : ℚ) * (41 / 22 : ℚ)
    exact eq_smul_div (82) scale (41) (22) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((61 : ℤ) : ℚ) = (scale : ℚ) * (61 / 44 : ℚ)
    exact eq_smul_div (61) scale (61) (44) (by decide) (by decide)
  · change ((39 : ℤ) : ℚ) = (scale : ℚ) * (39 / 44 : ℚ)
    exact eq_smul_div (39) scale (39) (44) (by decide) (by decide)
  · change ((78 : ℤ) : ℚ) = (scale : ℚ) * (39 / 22 : ℚ)
    exact eq_smul_div (78) scale (39) (22) (by decide) (by decide)

theorem XZ_scale_4 : toVec (XZ 4) = (scale : ℚ) • XCell7_4 := by
  funext i
  fin_cases i
  · change ((16 : ℤ) : ℚ) = (scale : ℚ) * (4 / 11 : ℚ)
    exact eq_smul_div (16) scale (4) (11) (by decide) (by decide)
  · change ((3 : ℤ) : ℚ) = (scale : ℚ) * (3 / 44 : ℚ)
    exact eq_smul_div (3) scale (3) (44) (by decide) (by decide)
  · change ((-5 : ℤ) : ℚ) = (scale : ℚ) * (-5 / 44 : ℚ)
    exact eq_smul_div (-5) scale (-5) (44) (by decide) (by decide)
  · change ((24 : ℤ) : ℚ) = (scale : ℚ) * (6 / 11 : ℚ)
    exact eq_smul_div (24) scale (6) (11) (by decide) (by decide)
  · change ((1 : ℤ) : ℚ) = (scale : ℚ) * (1 / 44 : ℚ)
    exact eq_smul_div (1) scale (1) (44) (by decide) (by decide)
  · change ((-7 : ℤ) : ℚ) = (scale : ℚ) * (-7 / 44 : ℚ)
    exact eq_smul_div (-7) scale (-7) (44) (by decide) (by decide)
  · change ((16 : ℤ) : ℚ) = (scale : ℚ) * (4 / 11 : ℚ)
    exact eq_smul_div (16) scale (4) (11) (by decide) (by decide)
  · change ((15 : ℤ) : ℚ) = (scale : ℚ) * (15 / 44 : ℚ)
    exact eq_smul_div (15) scale (15) (44) (by decide) (by decide)
  · change ((-13 : ℤ) : ℚ) = (scale : ℚ) * (-13 / 44 : ℚ)
    exact eq_smul_div (-13) scale (-13) (44) (by decide) (by decide)
  · change ((16 : ℤ) : ℚ) = (scale : ℚ) * (4 / 11 : ℚ)
    exact eq_smul_div (16) scale (4) (11) (by decide) (by decide)

theorem XZ_scale_5 : toVec (XZ 5) = (scale : ℚ) • XCell7_5 := by
  funext i
  fin_cases i
  · change ((-62 : ℤ) : ℚ) = (scale : ℚ) * (-31 / 22 : ℚ)
    exact eq_smul_div (-62) scale (-31) (22) (by decide) (by decide)
  · change ((-104 : ℤ) : ℚ) = (scale : ℚ) * (-26 / 11 : ℚ)
    exact eq_smul_div (-104) scale (-26) (11) (by decide) (by decide)
  · change ((-58 : ℤ) : ℚ) = (scale : ℚ) * (-29 / 22 : ℚ)
    exact eq_smul_div (-58) scale (-29) (22) (by decide) (by decide)
  · change ((-50 : ℤ) : ℚ) = (scale : ℚ) * (-25 / 22 : ℚ)
    exact eq_smul_div (-50) scale (-25) (22) (by decide) (by decide)
  · change ((-40 : ℤ) : ℚ) = (scale : ℚ) * (-10 / 11 : ℚ)
    exact eq_smul_div (-40) scale (-10) (11) (by decide) (by decide)
  · change ((-144 : ℤ) : ℚ) = (scale : ℚ) * (-36 / 11 : ℚ)
    exact eq_smul_div (-144) scale (-36) (11) (by decide) (by decide)
  · change ((-10 : ℤ) : ℚ) = (scale : ℚ) * (-5 / 22 : ℚ)
    exact eq_smul_div (-10) scale (-5) (22) (by decide) (by decide)
  · change ((-86 : ℤ) : ℚ) = (scale : ℚ) * (-43 / 22 : ℚ)
    exact eq_smul_div (-86) scale (-43) (22) (by decide) (by decide)
  · change ((-50 : ℤ) : ℚ) = (scale : ℚ) * (-25 / 22 : ℚ)
    exact eq_smul_div (-50) scale (-25) (22) (by decide) (by decide)
  · change ((-144 : ℤ) : ℚ) = (scale : ℚ) * (-36 / 11 : ℚ)
    exact eq_smul_div (-144) scale (-36) (11) (by decide) (by decide)

theorem XZ_scale_6 : toVec (XZ 6) = (scale : ℚ) • XCell7_6 := by
  funext i
  fin_cases i
  · change ((38 : ℤ) : ℚ) = (scale : ℚ) * (19 / 22 : ℚ)
    exact eq_smul_div (38) scale (19) (22) (by decide) (by decide)
  · change ((-28 : ℤ) : ℚ) = (scale : ℚ) * (-7 / 11 : ℚ)
    exact eq_smul_div (-28) scale (-7) (11) (by decide) (by decide)
  · change ((24 : ℤ) : ℚ) = (scale : ℚ) * (6 / 11 : ℚ)
    exact eq_smul_div (24) scale (6) (11) (by decide) (by decide)
  · change ((52 : ℤ) : ℚ) = (scale : ℚ) * (13 / 11 : ℚ)
    exact eq_smul_div (52) scale (13) (11) (by decide) (by decide)
  · change ((-16 : ℤ) : ℚ) = (scale : ℚ) * (-4 / 11 : ℚ)
    exact eq_smul_div (-16) scale (-4) (11) (by decide) (by decide)
  · change ((10 : ℤ) : ℚ) = (scale : ℚ) * (5 / 22 : ℚ)
    exact eq_smul_div (10) scale (5) (22) (by decide) (by decide)
  · change ((-18 : ℤ) : ℚ) = (scale : ℚ) * (-9 / 22 : ℚ)
    exact eq_smul_div (-18) scale (-9) (22) (by decide) (by decide)
  · change ((90 : ℤ) : ℚ) = (scale : ℚ) * (45 / 22 : ℚ)
    exact eq_smul_div (90) scale (45) (22) (by decide) (by decide)
  · change ((-46 : ℤ) : ℚ) = (scale : ℚ) * (-23 / 22 : ℚ)
    exact eq_smul_div (-46) scale (-23) (22) (by decide) (by decide)
  · change ((48 : ℤ) : ℚ) = (scale : ℚ) * (12 / 11 : ℚ)
    exact eq_smul_div (48) scale (12) (11) (by decide) (by decide)

theorem XZ_scale_7 : toVec (XZ 7) = (scale : ℚ) • XCell7_7 := by
  funext i
  fin_cases i
  · change ((-138 : ℤ) : ℚ) = (scale : ℚ) * (-69 / 22 : ℚ)
    exact eq_smul_div (-138) scale (-69) (22) (by decide) (by decide)
  · change ((-162 : ℤ) : ℚ) = (scale : ℚ) * (-81 / 22 : ℚ)
    exact eq_smul_div (-162) scale (-81) (22) (by decide) (by decide)
  · change ((-84 : ℤ) : ℚ) = (scale : ℚ) * (-21 / 11 : ℚ)
    exact eq_smul_div (-84) scale (-21) (11) (by decide) (by decide)
  · change ((-142 : ℤ) : ℚ) = (scale : ℚ) * (-71 / 22 : ℚ)
    exact eq_smul_div (-142) scale (-71) (22) (by decide) (by decide)
  · change ((-82 : ℤ) : ℚ) = (scale : ℚ) * (-41 / 22 : ℚ)
    exact eq_smul_div (-82) scale (-41) (22) (by decide) (by decide)
  · change ((-200 : ℤ) : ℚ) = (scale : ℚ) * (-50 / 11 : ℚ)
    exact eq_smul_div (-200) scale (-50) (11) (by decide) (by decide)
  · change ((-30 : ℤ) : ℚ) = (scale : ℚ) * (-15 / 22 : ℚ)
    exact eq_smul_div (-30) scale (-15) (22) (by decide) (by decide)
  · change ((-200 : ℤ) : ℚ) = (scale : ℚ) * (-50 / 11 : ℚ)
    exact eq_smul_div (-200) scale (-50) (11) (by decide) (by decide)
  · change ((-42 : ℤ) : ℚ) = (scale : ℚ) * (-21 / 22 : ℚ)
    exact eq_smul_div (-42) scale (-21) (22) (by decide) (by decide)
  · change ((-240 : ℤ) : ℚ) = (scale : ℚ) * (-60 / 11 : ℚ)
    exact eq_smul_div (-240) scale (-60) (11) (by decide) (by decide)

theorem XZ_scale_8 : toVec (XZ 8) = (scale : ℚ) • XCell7_8 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem XZ_scale_9 : toVec (XZ 9) = (scale : ℚ) • XCell7_9 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem XZ_scale_10 : toVec (XZ 10) = (scale : ℚ) • XCell7_10 := by
  funext i
  fin_cases i
  · change ((22 : ℤ) : ℚ) = (scale : ℚ) * (1 / 2 : ℚ)
    exact eq_smul_div (22) scale (1) (2) (by decide) (by decide)
  · change ((22 : ℤ) : ℚ) = (scale : ℚ) * (1 / 2 : ℚ)
    exact eq_smul_div (22) scale (1) (2) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((22 : ℤ) : ℚ) = (scale : ℚ) * (1 / 2 : ℚ)
    exact eq_smul_div (22) scale (1) (2) (by decide) (by decide)
  · change ((-11 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 4 : ℚ)
    exact eq_smul_div (-11) scale (-1) (4) (by decide) (by decide)
  · change ((22 : ℤ) : ℚ) = (scale : ℚ) * (1 / 2 : ℚ)
    exact eq_smul_div (22) scale (1) (2) (by decide) (by decide)
  · change ((11 : ℤ) : ℚ) = (scale : ℚ) * (1 / 4 : ℚ)
    exact eq_smul_div (11) scale (1) (4) (by decide) (by decide)
  · change ((11 : ℤ) : ℚ) = (scale : ℚ) * (1 / 4 : ℚ)
    exact eq_smul_div (11) scale (1) (4) (by decide) (by decide)
  · change ((22 : ℤ) : ℚ) = (scale : ℚ) * (1 / 2 : ℚ)
    exact eq_smul_div (22) scale (1) (2) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem XZ_scale_11 : toVec (XZ 11) = (scale : ℚ) • XCell7_11 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem XZ_scale_12 : toVec (XZ 12) = (scale : ℚ) • XCell7_12 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem XZ_scale_13 : toVec (XZ 13) = (scale : ℚ) • XCell7_13 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem XZ_scale_14 : toVec (XZ 14) = (scale : ℚ) • XCell7_14 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem XZ_scale_15 : toVec (XZ 15) = (scale : ℚ) • XCell7_15 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem XZ_scale_16 : toVec (XZ 16) = (scale : ℚ) • XCell7_16 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem XZ_scale_17 : toVec (XZ 17) = (scale : ℚ) • XCell7_17 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem XZ_scale_18 : toVec (XZ 18) = (scale : ℚ) • XCell7_18 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem XZ_scale_19 : toVec (XZ 19) = (scale : ℚ) • XCell7_19 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem XZ_scale (k : Fin 20) :
    toVec (XZ k) = (scale : ℚ) • XVec (7 : Fin 10) k := by
  fin_cases k
  · simp [XVec, XRow7]; exact XZ_scale_0
  · simp [XVec, XRow7]; exact XZ_scale_1
  · simp [XVec, XRow7]; exact XZ_scale_2
  · simp [XVec, XRow7]; exact XZ_scale_3
  · simp [XVec, XRow7]; exact XZ_scale_4
  · simp [XVec, XRow7]; exact XZ_scale_5
  · simp [XVec, XRow7]; exact XZ_scale_6
  · simp [XVec, XRow7]; exact XZ_scale_7
  · simp [XVec, XRow7]; exact XZ_scale_8
  · simp [XVec, XRow7]; exact XZ_scale_9
  · simp [XVec, XRow7]; exact XZ_scale_10
  · simp [XVec, XRow7]; exact XZ_scale_11
  · simp [XVec, XRow7]; exact XZ_scale_12
  · simp [XVec, XRow7]; exact XZ_scale_13
  · simp [XVec, XRow7]; exact XZ_scale_14
  · simp [XVec, XRow7]; exact XZ_scale_15
  · simp [XVec, XRow7]; exact XZ_scale_16
  · simp [XVec, XRow7]; exact XZ_scale_17
  · simp [XVec, XRow7]; exact XZ_scale_18
  · simp [XVec, XRow7]; exact XZ_scale_19

theorem AZ_scale_0 : toVec (AZ 0) = (scale : ℚ) • ACell0_8 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (8) scale (2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (8) scale (2) (11) (by decide) (by decide)

theorem AZ_scale_1 : toVec (AZ 1) = (scale : ℚ) • ACell1_8 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-2) (11) (by decide) (by decide)
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (8) scale (2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (8) scale (2) (11) (by decide) (by decide)
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-2) (11) (by decide) (by decide)

theorem AZ_scale_2 : toVec (AZ 2) = (scale : ℚ) • ACell2_8 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (8) scale (2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (8) scale (2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem AZ_scale_3 : toVec (AZ 3) = (scale : ℚ) • ACell3_8 := by
  funext i
  fin_cases i
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (8) scale (2) (11) (by decide) (by decide)
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (8) scale (2) (11) (by decide) (by decide)
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (8) scale (2) (11) (by decide) (by decide)
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (8) scale (2) (11) (by decide) (by decide)
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (8) scale (2) (11) (by decide) (by decide)
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (8) scale (2) (11) (by decide) (by decide)
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (8) scale (2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((16 : ℤ) : ℚ) = (scale : ℚ) * (4 / 11 : ℚ)
    exact eq_smul_div (16) scale (4) (11) (by decide) (by decide)
  · change ((16 : ℤ) : ℚ) = (scale : ℚ) * (4 / 11 : ℚ)
    exact eq_smul_div (16) scale (4) (11) (by decide) (by decide)

theorem AZ_scale_4 : toVec (AZ 4) = (scale : ℚ) • ACell4_8 := by
  funext i
  fin_cases i
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-2) (11) (by decide) (by decide)
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-2) (11) (by decide) (by decide)
  · change ((-16 : ℤ) : ℚ) = (scale : ℚ) * (-4 / 11 : ℚ)
    exact eq_smul_div (-16) scale (-4) (11) (by decide) (by decide)
  · change ((-16 : ℤ) : ℚ) = (scale : ℚ) * (-4 / 11 : ℚ)
    exact eq_smul_div (-16) scale (-4) (11) (by decide) (by decide)
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-2) (11) (by decide) (by decide)
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-2) (11) (by decide) (by decide)
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-2) (11) (by decide) (by decide)
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-2) (11) (by decide) (by decide)

theorem AZ_scale_5 : toVec (AZ 5) = (scale : ℚ) • ACell5_8 := by
  funext i
  fin_cases i
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (4) scale (1) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (8) scale (2) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (4) scale (1) (11) (by decide) (by decide)

theorem AZ_scale_6 : toVec (AZ 6) = (scale : ℚ) • ACell6_8 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-2) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)
  · change ((-12 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 11 : ℚ)
    exact eq_smul_div (-12) scale (-3) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-2) (11) (by decide) (by decide)

theorem AZ_scale_7 : toVec (AZ 7) = (scale : ℚ) • ACell7_8 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (4) scale (1) (11) (by decide) (by decide)
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (8) scale (2) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (4) scale (1) (11) (by decide) (by decide)
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (8) scale (2) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (8) scale (2) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (4) scale (1) (11) (by decide) (by decide)
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (8) scale (2) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (4) scale (1) (11) (by decide) (by decide)

theorem AZ_scale_8 : toVec (AZ 8) = (scale : ℚ) • ACell8_8 := by
  funext i
  fin_cases i
  · change ((40 : ℤ) : ℚ) = (scale : ℚ) * (10 / 11 : ℚ)
    exact eq_smul_div (40) scale (10) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (4) scale (1) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (4) scale (1) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (8) scale (2) (11) (by decide) (by decide)

theorem AZ_scale_9 : toVec (AZ 9) = (scale : ℚ) • ACell9_8 := by
  funext i
  fin_cases i
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-2) (11) (by decide) (by decide)
  · change ((-12 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 11 : ℚ)
    exact eq_smul_div (-12) scale (-3) (11) (by decide) (by decide)
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)

theorem AZ_scale_10 : toVec (AZ 10) = (scale : ℚ) • ACell10_8 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-2) (11) (by decide) (by decide)
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (8) scale (2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (8) scale (2) (11) (by decide) (by decide)
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem AZ_scale_11 : toVec (AZ 11) = (scale : ℚ) • ACell11_8 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-16 : ℤ) : ℚ) = (scale : ℚ) * (-4 / 11 : ℚ)
    exact eq_smul_div (-16) scale (-4) (11) (by decide) (by decide)
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-2) (11) (by decide) (by decide)
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-2) (11) (by decide) (by decide)
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-2) (11) (by decide) (by decide)
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-2) (11) (by decide) (by decide)
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-2) (11) (by decide) (by decide)
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-2) (11) (by decide) (by decide)
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-2) (11) (by decide) (by decide)
  · change ((-16 : ℤ) : ℚ) = (scale : ℚ) * (-4 / 11 : ℚ)
    exact eq_smul_div (-16) scale (-4) (11) (by decide) (by decide)

theorem AZ_scale_12 : toVec (AZ 12) = (scale : ℚ) • ACell12_8 := by
  funext i
  fin_cases i
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (8) scale (2) (11) (by decide) (by decide)
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (8) scale (2) (11) (by decide) (by decide)
  · change ((16 : ℤ) : ℚ) = (scale : ℚ) * (4 / 11 : ℚ)
    exact eq_smul_div (16) scale (4) (11) (by decide) (by decide)
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (8) scale (2) (11) (by decide) (by decide)
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (8) scale (2) (11) (by decide) (by decide)
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (8) scale (2) (11) (by decide) (by decide)
  · change ((16 : ℤ) : ℚ) = (scale : ℚ) * (4 / 11 : ℚ)
    exact eq_smul_div (16) scale (4) (11) (by decide) (by decide)
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (8) scale (2) (11) (by decide) (by decide)
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (8) scale (2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem AZ_scale_13 : toVec (AZ 13) = (scale : ℚ) • ACell13_8 := by
  funext i
  fin_cases i
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (8) scale (2) (11) (by decide) (by decide)
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (8) scale (2) (11) (by decide) (by decide)
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (8) scale (2) (11) (by decide) (by decide)
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (8) scale (2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (8) scale (2) (11) (by decide) (by decide)
  · change ((16 : ℤ) : ℚ) = (scale : ℚ) * (4 / 11 : ℚ)
    exact eq_smul_div (16) scale (4) (11) (by decide) (by decide)
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (8) scale (2) (11) (by decide) (by decide)
  · change ((16 : ℤ) : ℚ) = (scale : ℚ) * (4 / 11 : ℚ)
    exact eq_smul_div (16) scale (4) (11) (by decide) (by decide)
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (8) scale (2) (11) (by decide) (by decide)

theorem AZ_scale_14 : toVec (AZ 14) = (scale : ℚ) • ACell14_8 := by
  funext i
  fin_cases i
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-2) (11) (by decide) (by decide)
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-2) (11) (by decide) (by decide)
  · change ((-16 : ℤ) : ℚ) = (scale : ℚ) * (-4 / 11 : ℚ)
    exact eq_smul_div (-16) scale (-4) (11) (by decide) (by decide)
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-2) (11) (by decide) (by decide)
  · change ((-16 : ℤ) : ℚ) = (scale : ℚ) * (-4 / 11 : ℚ)
    exact eq_smul_div (-16) scale (-4) (11) (by decide) (by decide)
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-2) (11) (by decide) (by decide)
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-2) (11) (by decide) (by decide)
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-2) (11) (by decide) (by decide)

theorem AZ_scale_15 : toVec (AZ 15) = (scale : ℚ) • ACell15_8 := by
  funext i
  fin_cases i
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-2) (11) (by decide) (by decide)
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-2) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (4) scale (1) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-2) (11) (by decide) (by decide)
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-2) (11) (by decide) (by decide)

theorem AZ_scale_16 : toVec (AZ 16) = (scale : ℚ) • ACell16_8 := by
  funext i
  fin_cases i
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-2) (11) (by decide) (by decide)
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-2) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-12 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 11 : ℚ)
    exact eq_smul_div (-12) scale (-3) (11) (by decide) (by decide)

theorem AZ_scale_17 : toVec (AZ 17) = (scale : ℚ) • ACell17_8 := by
  funext i
  fin_cases i
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-2) (11) (by decide) (by decide)
  · change ((-12 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 11 : ℚ)
    exact eq_smul_div (-12) scale (-3) (11) (by decide) (by decide)
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)

theorem AZ_scale_18 : toVec (AZ 18) = (scale : ℚ) • ACell18_8 := by
  funext i
  fin_cases i
  · change ((52 : ℤ) : ℚ) = (scale : ℚ) * (13 / 11 : ℚ)
    exact eq_smul_div (52) scale (13) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (4) scale (1) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (4) scale (1) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem AZ_scale_19 : toVec (AZ 19) = (scale : ℚ) • ACell19_8 := by
  funext i
  fin_cases i
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (4) scale (1) (11) (by decide) (by decide)
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-2) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (4) scale (1) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-1) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (4) scale (1) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (4) scale (1) (11) (by decide) (by decide)

theorem AZ_scale (k : Fin 20) :
    toVec (AZ k) = (scale : ℚ) • AVec k (8 : Fin 10) := by
  fin_cases k
  · simp [AVec, ARow0]; exact AZ_scale_0
  · simp [AVec, ARow1]; exact AZ_scale_1
  · simp [AVec, ARow2]; exact AZ_scale_2
  · simp [AVec, ARow3]; exact AZ_scale_3
  · simp [AVec, ARow4]; exact AZ_scale_4
  · simp [AVec, ARow5]; exact AZ_scale_5
  · simp [AVec, ARow6]; exact AZ_scale_6
  · simp [AVec, ARow7]; exact AZ_scale_7
  · simp [AVec, ARow8]; exact AZ_scale_8
  · simp [AVec, ARow9]; exact AZ_scale_9
  · simp [AVec, ARow10]; exact AZ_scale_10
  · simp [AVec, ARow11]; exact AZ_scale_11
  · simp [AVec, ARow12]; exact AZ_scale_12
  · simp [AVec, ARow13]; exact AZ_scale_13
  · simp [AVec, ARow14]; exact AZ_scale_14
  · simp [AVec, ARow15]; exact AZ_scale_15
  · simp [AVec, ARow16]; exact AZ_scale_16
  · simp [AVec, ARow17]; exact AZ_scale_17
  · simp [AVec, ARow18]; exact AZ_scale_18
  · simp [AVec, ARow19]; exact AZ_scale_19

theorem KZ_scale_0 : toVec (KZ 0) = (scale : ℚ) • KCell7_0 := by
  funext i
  fin_cases i
  · change ((22 : ℤ) : ℚ) = (scale : ℚ) * (1 / 2 : ℚ)
    exact eq_smul_div (22) scale (1) (2) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-22 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 2 : ℚ)
    exact eq_smul_div (-22) scale (-1) (2) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((22 : ℤ) : ℚ) = (scale : ℚ) * (1 / 2 : ℚ)
    exact eq_smul_div (22) scale (1) (2) (by decide) (by decide)
  · change ((-22 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 2 : ℚ)
    exact eq_smul_div (-22) scale (-1) (2) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-22 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 2 : ℚ)
    exact eq_smul_div (-22) scale (-1) (2) (by decide) (by decide)

theorem KZ_scale (k : Fin 1) :
    toVec (KZ k) = (scale : ℚ) • KVec (7 : Fin 10) k := by
  fin_cases k
  · simp [KVec, KRow0]; exact KZ_scale_0

theorem YZ_scale_0 : toVec (YZ 0) = (scale : ℚ) • YCell0_8 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem YZ_scale (k : Fin 1) :
    toVec (YZ k) = (scale : ℚ) • YVec k (8 : Fin 10) := by
  fin_cases k
  · simp [YVec, YRow0]; exact YZ_scale_0

theorem entry_eq :
    (matrixMul XVec AVec + matrixMul KVec YVec)
        (7 : Fin 10) (8 : Fin 10) = ![0, 0, 0, 0, 0, 0, 0, 0, 0, 0] := by
  change (∑ k : Fin 20, mul (XVec (7 : Fin 10) k)
      (AVec k (8 : Fin 10))) +
    (∑ k : Fin 1, mul (KVec (7 : Fin 10) k)
      (YVec k (8 : Fin 10))) = _
  refine add_sum_mul_eq_of_scaled scale scale_ne_zero
    (fun k => XVec (7 : Fin 10) k)
    (fun k => AVec k (8 : Fin 10))
    (fun k => KVec (7 : Fin 10) k)
    (fun k => YVec k (8 : Fin 10))
    XZ AZ KZ YZ XZ_scale AZ_scale KZ_scale YZ_scale entryZ rfl _ ?_
  rw [entryZ_eq, toVec_zeroZ_smul, vec_zero_eq]

theorem entry_eq_matrixOne :
    (matrixMul XVec AVec + matrixMul KVec YVec)
        (7 : Fin 10) (8 : Fin 10) =
      matrixOne (Fin 10) (7 : Fin 10) (8 : Fin 10) := by
  rw [entry_eq]
  have hne : (7 : Fin 10) ≠ (8 : Fin 10) := by decide
  funext n
  fin_cases n <;> simp [matrixOne, constVec, basis, *]

end V14Formalization.D12PieceAASplitEntry7_8


namespace V14Formalization.D12PieceAASplitEntry7_9
open D12CyclotomicVec D12CyclotomicVecZ D12PieceAAData
def payloadSha256 : String := "76c6196f29afe1a8398af99502447f48ebeed4bcb3805fc5dbec693940bc04b0"

def scale : ℤ := 132

def XZ (k : Fin 20) : VecZ :=
  match k.val with
  | 0 => #v[54, -210, -12, 102, -99, -45, -57, 162, -231, 39]
  | 1 => #v[48, -51, 3, 15, -27, 33, -57, 51, 3, -18]
  | 2 => #v[-357, -6, -123, -324, -3, -297, 87, -492, 138, -339]
  | 3 => #v[96, 210, 129, 105, 33, 246, 0, 183, 117, 234]
  | 4 => #v[48, 9, -15, 72, 3, -21, 48, 45, -39, 48]
  | 5 => #v[-186, -312, -174, -150, -120, -432, -30, -258, -150, -432]
  | 6 => #v[114, -84, 72, 156, -48, 30, -54, 270, -138, 144]
  | 7 => #v[-414, -486, -252, -426, -246, -600, -90, -600, -126, -720]
  | 8 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  | 9 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  | 10 => #v[66, 66, 0, 66, -33, 66, 33, 33, 66, 0]
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
  | 0 => #v[0, 0, 24, 0, -24, 0, -24, 0, 24, 0]
  | 1 => #v[0, -24, 0, 0, 0, -24, 0, 0, 24, 24]
  | 2 => #v[24, 24, 24, 24, 0, 48, 24, 24, 24, 48]
  | 3 => #v[24, 24, 0, 24, 24, 48, 24, 48, 24, 24]
  | 4 => #v[0, 0, 0, 0, 24, -24, -24, 24, 0, 0]
  | 5 => #v[36, 24, 36, 24, 12, 12, 24, 36, 24, 36]
  | 6 => #v[24, 12, 0, 12, 12, 0, 12, 24, 0, 36]
  | 7 => #v[0, 24, 12, 12, 24, 0, 0, 12, 36, 12]
  | 8 => #v[-24, -36, -24, 0, -12, -12, 0, 0, -12, -12]
  | 9 => #v[132, 24, 12, 12, 36, 12, 12, 24, 0, 0]
  | 10 => #v[24, 24, 48, 48, 24, 24, 0, 24, 24, 24]
  | 11 => #v[24, 24, 48, 24, 48, 24, 24, 0, 24, 24]
  | 12 => #v[0, 0, 0, 0, 0, 0, 24, -24, -24, 24]
  | 13 => #v[0, 0, -24, 24, 0, 0, 0, 24, -24, 0]
  | 14 => #v[-24, 0, -24, 0, 24, 0, 0, 0, 0, 24]
  | 15 => #v[-12, -12, 0, -24, -36, -24, 0, -12, -12, 0]
  | 16 => #v[24, 12, 12, 24, 0, 0, 12, 36, 12, 0]
  | 17 => #v[-24, -24, -12, -36, -36, -36, -36, -12, -24, -24]
  | 18 => #v[-24, -12, 0, -12, -12, 0, -12, -24, 0, -36]
  | 19 => #v[168, 0, 12, 0, 12, 24, 24, 12, 0, 12]
  | _ => zeroZ

def KZ (k : Fin 1) : VecZ :=
  match k.val with
  | 0 => #v[66, 0, -66, 0, 0, 0, 66, -66, 0, -66]
  | _ => zeroZ

def YZ (k : Fin 1) : VecZ :=
  match k.val with
  | 0 => #v[-88, 88, 0, -88, 0, 88, 88, -88, 88, 88]
  | _ => zeroZ

def xaEntryZ : VecZ := sumFin (fun k => mulZ (XZ k) (AZ k))
def kyEntryZ : VecZ := sumFin (fun k => mulZ (KZ k) (YZ k))
def entryZ : VecZ := addZ xaEntryZ kyEntryZ

theorem entryZ_eq : entryZ = zeroZ := by
  decide +kernel

theorem scale_ne_zero : scale ≠ 0 := by
  decide

theorem XZ_scale_0 : toVec (XZ 0) = (scale : ℚ) • XCell7_0 := by
  funext i
  fin_cases i
  · change ((54 : ℤ) : ℚ) = (scale : ℚ) * (9 / 22 : ℚ)
    exact eq_smul_div (54) scale (9) (22) (by decide) (by decide)
  · change ((-210 : ℤ) : ℚ) = (scale : ℚ) * (-35 / 22 : ℚ)
    exact eq_smul_div (-210) scale (-35) (22) (by decide) (by decide)
  · change ((-12 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-12) scale (-1) (11) (by decide) (by decide)
  · change ((102 : ℤ) : ℚ) = (scale : ℚ) * (17 / 22 : ℚ)
    exact eq_smul_div (102) scale (17) (22) (by decide) (by decide)
  · change ((-99 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 4 : ℚ)
    exact eq_smul_div (-99) scale (-3) (4) (by decide) (by decide)
  · change ((-45 : ℤ) : ℚ) = (scale : ℚ) * (-15 / 44 : ℚ)
    exact eq_smul_div (-45) scale (-15) (44) (by decide) (by decide)
  · change ((-57 : ℤ) : ℚ) = (scale : ℚ) * (-19 / 44 : ℚ)
    exact eq_smul_div (-57) scale (-19) (44) (by decide) (by decide)
  · change ((162 : ℤ) : ℚ) = (scale : ℚ) * (27 / 22 : ℚ)
    exact eq_smul_div (162) scale (27) (22) (by decide) (by decide)
  · change ((-231 : ℤ) : ℚ) = (scale : ℚ) * (-7 / 4 : ℚ)
    exact eq_smul_div (-231) scale (-7) (4) (by decide) (by decide)
  · change ((39 : ℤ) : ℚ) = (scale : ℚ) * (13 / 44 : ℚ)
    exact eq_smul_div (39) scale (13) (44) (by decide) (by decide)

theorem XZ_scale_1 : toVec (XZ 1) = (scale : ℚ) • XCell7_1 := by
  funext i
  fin_cases i
  · change ((48 : ℤ) : ℚ) = (scale : ℚ) * (4 / 11 : ℚ)
    exact eq_smul_div (48) scale (4) (11) (by decide) (by decide)
  · change ((-51 : ℤ) : ℚ) = (scale : ℚ) * (-17 / 44 : ℚ)
    exact eq_smul_div (-51) scale (-17) (44) (by decide) (by decide)
  · change ((3 : ℤ) : ℚ) = (scale : ℚ) * (1 / 44 : ℚ)
    exact eq_smul_div (3) scale (1) (44) (by decide) (by decide)
  · change ((15 : ℤ) : ℚ) = (scale : ℚ) * (5 / 44 : ℚ)
    exact eq_smul_div (15) scale (5) (44) (by decide) (by decide)
  · change ((-27 : ℤ) : ℚ) = (scale : ℚ) * (-9 / 44 : ℚ)
    exact eq_smul_div (-27) scale (-9) (44) (by decide) (by decide)
  · change ((33 : ℤ) : ℚ) = (scale : ℚ) * (1 / 4 : ℚ)
    exact eq_smul_div (33) scale (1) (4) (by decide) (by decide)
  · change ((-57 : ℤ) : ℚ) = (scale : ℚ) * (-19 / 44 : ℚ)
    exact eq_smul_div (-57) scale (-19) (44) (by decide) (by decide)
  · change ((51 : ℤ) : ℚ) = (scale : ℚ) * (17 / 44 : ℚ)
    exact eq_smul_div (51) scale (17) (44) (by decide) (by decide)
  · change ((3 : ℤ) : ℚ) = (scale : ℚ) * (1 / 44 : ℚ)
    exact eq_smul_div (3) scale (1) (44) (by decide) (by decide)
  · change ((-18 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-18) scale (-3) (22) (by decide) (by decide)

theorem XZ_scale_2 : toVec (XZ 2) = (scale : ℚ) • XCell7_2 := by
  funext i
  fin_cases i
  · change ((-357 : ℤ) : ℚ) = (scale : ℚ) * (-119 / 44 : ℚ)
    exact eq_smul_div (-357) scale (-119) (44) (by decide) (by decide)
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 22 : ℚ)
    exact eq_smul_div (-6) scale (-1) (22) (by decide) (by decide)
  · change ((-123 : ℤ) : ℚ) = (scale : ℚ) * (-41 / 44 : ℚ)
    exact eq_smul_div (-123) scale (-41) (44) (by decide) (by decide)
  · change ((-324 : ℤ) : ℚ) = (scale : ℚ) * (-27 / 11 : ℚ)
    exact eq_smul_div (-324) scale (-27) (11) (by decide) (by decide)
  · change ((-3 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 44 : ℚ)
    exact eq_smul_div (-3) scale (-1) (44) (by decide) (by decide)
  · change ((-297 : ℤ) : ℚ) = (scale : ℚ) * (-9 / 4 : ℚ)
    exact eq_smul_div (-297) scale (-9) (4) (by decide) (by decide)
  · change ((87 : ℤ) : ℚ) = (scale : ℚ) * (29 / 44 : ℚ)
    exact eq_smul_div (87) scale (29) (44) (by decide) (by decide)
  · change ((-492 : ℤ) : ℚ) = (scale : ℚ) * (-41 / 11 : ℚ)
    exact eq_smul_div (-492) scale (-41) (11) (by decide) (by decide)
  · change ((138 : ℤ) : ℚ) = (scale : ℚ) * (23 / 22 : ℚ)
    exact eq_smul_div (138) scale (23) (22) (by decide) (by decide)
  · change ((-339 : ℤ) : ℚ) = (scale : ℚ) * (-113 / 44 : ℚ)
    exact eq_smul_div (-339) scale (-113) (44) (by decide) (by decide)

theorem XZ_scale_3 : toVec (XZ 3) = (scale : ℚ) • XCell7_3 := by
  funext i
  fin_cases i
  · change ((96 : ℤ) : ℚ) = (scale : ℚ) * (8 / 11 : ℚ)
    exact eq_smul_div (96) scale (8) (11) (by decide) (by decide)
  · change ((210 : ℤ) : ℚ) = (scale : ℚ) * (35 / 22 : ℚ)
    exact eq_smul_div (210) scale (35) (22) (by decide) (by decide)
  · change ((129 : ℤ) : ℚ) = (scale : ℚ) * (43 / 44 : ℚ)
    exact eq_smul_div (129) scale (43) (44) (by decide) (by decide)
  · change ((105 : ℤ) : ℚ) = (scale : ℚ) * (35 / 44 : ℚ)
    exact eq_smul_div (105) scale (35) (44) (by decide) (by decide)
  · change ((33 : ℤ) : ℚ) = (scale : ℚ) * (1 / 4 : ℚ)
    exact eq_smul_div (33) scale (1) (4) (by decide) (by decide)
  · change ((246 : ℤ) : ℚ) = (scale : ℚ) * (41 / 22 : ℚ)
    exact eq_smul_div (246) scale (41) (22) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((183 : ℤ) : ℚ) = (scale : ℚ) * (61 / 44 : ℚ)
    exact eq_smul_div (183) scale (61) (44) (by decide) (by decide)
  · change ((117 : ℤ) : ℚ) = (scale : ℚ) * (39 / 44 : ℚ)
    exact eq_smul_div (117) scale (39) (44) (by decide) (by decide)
  · change ((234 : ℤ) : ℚ) = (scale : ℚ) * (39 / 22 : ℚ)
    exact eq_smul_div (234) scale (39) (22) (by decide) (by decide)

theorem XZ_scale_4 : toVec (XZ 4) = (scale : ℚ) • XCell7_4 := by
  funext i
  fin_cases i
  · change ((48 : ℤ) : ℚ) = (scale : ℚ) * (4 / 11 : ℚ)
    exact eq_smul_div (48) scale (4) (11) (by decide) (by decide)
  · change ((9 : ℤ) : ℚ) = (scale : ℚ) * (3 / 44 : ℚ)
    exact eq_smul_div (9) scale (3) (44) (by decide) (by decide)
  · change ((-15 : ℤ) : ℚ) = (scale : ℚ) * (-5 / 44 : ℚ)
    exact eq_smul_div (-15) scale (-5) (44) (by decide) (by decide)
  · change ((72 : ℤ) : ℚ) = (scale : ℚ) * (6 / 11 : ℚ)
    exact eq_smul_div (72) scale (6) (11) (by decide) (by decide)
  · change ((3 : ℤ) : ℚ) = (scale : ℚ) * (1 / 44 : ℚ)
    exact eq_smul_div (3) scale (1) (44) (by decide) (by decide)
  · change ((-21 : ℤ) : ℚ) = (scale : ℚ) * (-7 / 44 : ℚ)
    exact eq_smul_div (-21) scale (-7) (44) (by decide) (by decide)
  · change ((48 : ℤ) : ℚ) = (scale : ℚ) * (4 / 11 : ℚ)
    exact eq_smul_div (48) scale (4) (11) (by decide) (by decide)
  · change ((45 : ℤ) : ℚ) = (scale : ℚ) * (15 / 44 : ℚ)
    exact eq_smul_div (45) scale (15) (44) (by decide) (by decide)
  · change ((-39 : ℤ) : ℚ) = (scale : ℚ) * (-13 / 44 : ℚ)
    exact eq_smul_div (-39) scale (-13) (44) (by decide) (by decide)
  · change ((48 : ℤ) : ℚ) = (scale : ℚ) * (4 / 11 : ℚ)
    exact eq_smul_div (48) scale (4) (11) (by decide) (by decide)

theorem XZ_scale_5 : toVec (XZ 5) = (scale : ℚ) • XCell7_5 := by
  funext i
  fin_cases i
  · change ((-186 : ℤ) : ℚ) = (scale : ℚ) * (-31 / 22 : ℚ)
    exact eq_smul_div (-186) scale (-31) (22) (by decide) (by decide)
  · change ((-312 : ℤ) : ℚ) = (scale : ℚ) * (-26 / 11 : ℚ)
    exact eq_smul_div (-312) scale (-26) (11) (by decide) (by decide)
  · change ((-174 : ℤ) : ℚ) = (scale : ℚ) * (-29 / 22 : ℚ)
    exact eq_smul_div (-174) scale (-29) (22) (by decide) (by decide)
  · change ((-150 : ℤ) : ℚ) = (scale : ℚ) * (-25 / 22 : ℚ)
    exact eq_smul_div (-150) scale (-25) (22) (by decide) (by decide)
  · change ((-120 : ℤ) : ℚ) = (scale : ℚ) * (-10 / 11 : ℚ)
    exact eq_smul_div (-120) scale (-10) (11) (by decide) (by decide)
  · change ((-432 : ℤ) : ℚ) = (scale : ℚ) * (-36 / 11 : ℚ)
    exact eq_smul_div (-432) scale (-36) (11) (by decide) (by decide)
  · change ((-30 : ℤ) : ℚ) = (scale : ℚ) * (-5 / 22 : ℚ)
    exact eq_smul_div (-30) scale (-5) (22) (by decide) (by decide)
  · change ((-258 : ℤ) : ℚ) = (scale : ℚ) * (-43 / 22 : ℚ)
    exact eq_smul_div (-258) scale (-43) (22) (by decide) (by decide)
  · change ((-150 : ℤ) : ℚ) = (scale : ℚ) * (-25 / 22 : ℚ)
    exact eq_smul_div (-150) scale (-25) (22) (by decide) (by decide)
  · change ((-432 : ℤ) : ℚ) = (scale : ℚ) * (-36 / 11 : ℚ)
    exact eq_smul_div (-432) scale (-36) (11) (by decide) (by decide)

theorem XZ_scale_6 : toVec (XZ 6) = (scale : ℚ) • XCell7_6 := by
  funext i
  fin_cases i
  · change ((114 : ℤ) : ℚ) = (scale : ℚ) * (19 / 22 : ℚ)
    exact eq_smul_div (114) scale (19) (22) (by decide) (by decide)
  · change ((-84 : ℤ) : ℚ) = (scale : ℚ) * (-7 / 11 : ℚ)
    exact eq_smul_div (-84) scale (-7) (11) (by decide) (by decide)
  · change ((72 : ℤ) : ℚ) = (scale : ℚ) * (6 / 11 : ℚ)
    exact eq_smul_div (72) scale (6) (11) (by decide) (by decide)
  · change ((156 : ℤ) : ℚ) = (scale : ℚ) * (13 / 11 : ℚ)
    exact eq_smul_div (156) scale (13) (11) (by decide) (by decide)
  · change ((-48 : ℤ) : ℚ) = (scale : ℚ) * (-4 / 11 : ℚ)
    exact eq_smul_div (-48) scale (-4) (11) (by decide) (by decide)
  · change ((30 : ℤ) : ℚ) = (scale : ℚ) * (5 / 22 : ℚ)
    exact eq_smul_div (30) scale (5) (22) (by decide) (by decide)
  · change ((-54 : ℤ) : ℚ) = (scale : ℚ) * (-9 / 22 : ℚ)
    exact eq_smul_div (-54) scale (-9) (22) (by decide) (by decide)
  · change ((270 : ℤ) : ℚ) = (scale : ℚ) * (45 / 22 : ℚ)
    exact eq_smul_div (270) scale (45) (22) (by decide) (by decide)
  · change ((-138 : ℤ) : ℚ) = (scale : ℚ) * (-23 / 22 : ℚ)
    exact eq_smul_div (-138) scale (-23) (22) (by decide) (by decide)
  · change ((144 : ℤ) : ℚ) = (scale : ℚ) * (12 / 11 : ℚ)
    exact eq_smul_div (144) scale (12) (11) (by decide) (by decide)

theorem XZ_scale_7 : toVec (XZ 7) = (scale : ℚ) • XCell7_7 := by
  funext i
  fin_cases i
  · change ((-414 : ℤ) : ℚ) = (scale : ℚ) * (-69 / 22 : ℚ)
    exact eq_smul_div (-414) scale (-69) (22) (by decide) (by decide)
  · change ((-486 : ℤ) : ℚ) = (scale : ℚ) * (-81 / 22 : ℚ)
    exact eq_smul_div (-486) scale (-81) (22) (by decide) (by decide)
  · change ((-252 : ℤ) : ℚ) = (scale : ℚ) * (-21 / 11 : ℚ)
    exact eq_smul_div (-252) scale (-21) (11) (by decide) (by decide)
  · change ((-426 : ℤ) : ℚ) = (scale : ℚ) * (-71 / 22 : ℚ)
    exact eq_smul_div (-426) scale (-71) (22) (by decide) (by decide)
  · change ((-246 : ℤ) : ℚ) = (scale : ℚ) * (-41 / 22 : ℚ)
    exact eq_smul_div (-246) scale (-41) (22) (by decide) (by decide)
  · change ((-600 : ℤ) : ℚ) = (scale : ℚ) * (-50 / 11 : ℚ)
    exact eq_smul_div (-600) scale (-50) (11) (by decide) (by decide)
  · change ((-90 : ℤ) : ℚ) = (scale : ℚ) * (-15 / 22 : ℚ)
    exact eq_smul_div (-90) scale (-15) (22) (by decide) (by decide)
  · change ((-600 : ℤ) : ℚ) = (scale : ℚ) * (-50 / 11 : ℚ)
    exact eq_smul_div (-600) scale (-50) (11) (by decide) (by decide)
  · change ((-126 : ℤ) : ℚ) = (scale : ℚ) * (-21 / 22 : ℚ)
    exact eq_smul_div (-126) scale (-21) (22) (by decide) (by decide)
  · change ((-720 : ℤ) : ℚ) = (scale : ℚ) * (-60 / 11 : ℚ)
    exact eq_smul_div (-720) scale (-60) (11) (by decide) (by decide)

theorem XZ_scale_8 : toVec (XZ 8) = (scale : ℚ) • XCell7_8 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem XZ_scale_9 : toVec (XZ 9) = (scale : ℚ) • XCell7_9 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem XZ_scale_10 : toVec (XZ 10) = (scale : ℚ) • XCell7_10 := by
  funext i
  fin_cases i
  · change ((66 : ℤ) : ℚ) = (scale : ℚ) * (1 / 2 : ℚ)
    exact eq_smul_div (66) scale (1) (2) (by decide) (by decide)
  · change ((66 : ℤ) : ℚ) = (scale : ℚ) * (1 / 2 : ℚ)
    exact eq_smul_div (66) scale (1) (2) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((66 : ℤ) : ℚ) = (scale : ℚ) * (1 / 2 : ℚ)
    exact eq_smul_div (66) scale (1) (2) (by decide) (by decide)
  · change ((-33 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 4 : ℚ)
    exact eq_smul_div (-33) scale (-1) (4) (by decide) (by decide)
  · change ((66 : ℤ) : ℚ) = (scale : ℚ) * (1 / 2 : ℚ)
    exact eq_smul_div (66) scale (1) (2) (by decide) (by decide)
  · change ((33 : ℤ) : ℚ) = (scale : ℚ) * (1 / 4 : ℚ)
    exact eq_smul_div (33) scale (1) (4) (by decide) (by decide)
  · change ((33 : ℤ) : ℚ) = (scale : ℚ) * (1 / 4 : ℚ)
    exact eq_smul_div (33) scale (1) (4) (by decide) (by decide)
  · change ((66 : ℤ) : ℚ) = (scale : ℚ) * (1 / 2 : ℚ)
    exact eq_smul_div (66) scale (1) (2) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem XZ_scale_11 : toVec (XZ 11) = (scale : ℚ) • XCell7_11 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem XZ_scale_12 : toVec (XZ 12) = (scale : ℚ) • XCell7_12 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem XZ_scale_13 : toVec (XZ 13) = (scale : ℚ) • XCell7_13 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem XZ_scale_14 : toVec (XZ 14) = (scale : ℚ) • XCell7_14 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem XZ_scale_15 : toVec (XZ 15) = (scale : ℚ) • XCell7_15 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem XZ_scale_16 : toVec (XZ 16) = (scale : ℚ) • XCell7_16 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem XZ_scale_17 : toVec (XZ 17) = (scale : ℚ) • XCell7_17 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem XZ_scale_18 : toVec (XZ 18) = (scale : ℚ) • XCell7_18 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem XZ_scale_19 : toVec (XZ 19) = (scale : ℚ) • XCell7_19 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem XZ_scale (k : Fin 20) :
    toVec (XZ k) = (scale : ℚ) • XVec (7 : Fin 10) k := by
  fin_cases k
  · simp [XVec, XRow7]; exact XZ_scale_0
  · simp [XVec, XRow7]; exact XZ_scale_1
  · simp [XVec, XRow7]; exact XZ_scale_2
  · simp [XVec, XRow7]; exact XZ_scale_3
  · simp [XVec, XRow7]; exact XZ_scale_4
  · simp [XVec, XRow7]; exact XZ_scale_5
  · simp [XVec, XRow7]; exact XZ_scale_6
  · simp [XVec, XRow7]; exact XZ_scale_7
  · simp [XVec, XRow7]; exact XZ_scale_8
  · simp [XVec, XRow7]; exact XZ_scale_9
  · simp [XVec, XRow7]; exact XZ_scale_10
  · simp [XVec, XRow7]; exact XZ_scale_11
  · simp [XVec, XRow7]; exact XZ_scale_12
  · simp [XVec, XRow7]; exact XZ_scale_13
  · simp [XVec, XRow7]; exact XZ_scale_14
  · simp [XVec, XRow7]; exact XZ_scale_15
  · simp [XVec, XRow7]; exact XZ_scale_16
  · simp [XVec, XRow7]; exact XZ_scale_17
  · simp [XVec, XRow7]; exact XZ_scale_18
  · simp [XVec, XRow7]; exact XZ_scale_19

theorem AZ_scale_0 : toVec (AZ 0) = (scale : ℚ) • ACell0_9 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((24 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (24) scale (2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-24 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-24) scale (-2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-24 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-24) scale (-2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((24 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (24) scale (2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem AZ_scale_1 : toVec (AZ 1) = (scale : ℚ) • ACell1_9 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-24 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-24) scale (-2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-24 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-24) scale (-2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((24 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (24) scale (2) (11) (by decide) (by decide)
  · change ((24 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (24) scale (2) (11) (by decide) (by decide)

theorem AZ_scale_2 : toVec (AZ 2) = (scale : ℚ) • ACell2_9 := by
  funext i
  fin_cases i
  · change ((24 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (24) scale (2) (11) (by decide) (by decide)
  · change ((24 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (24) scale (2) (11) (by decide) (by decide)
  · change ((24 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (24) scale (2) (11) (by decide) (by decide)
  · change ((24 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (24) scale (2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((48 : ℤ) : ℚ) = (scale : ℚ) * (4 / 11 : ℚ)
    exact eq_smul_div (48) scale (4) (11) (by decide) (by decide)
  · change ((24 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (24) scale (2) (11) (by decide) (by decide)
  · change ((24 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (24) scale (2) (11) (by decide) (by decide)
  · change ((24 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (24) scale (2) (11) (by decide) (by decide)
  · change ((48 : ℤ) : ℚ) = (scale : ℚ) * (4 / 11 : ℚ)
    exact eq_smul_div (48) scale (4) (11) (by decide) (by decide)

theorem AZ_scale_3 : toVec (AZ 3) = (scale : ℚ) • ACell3_9 := by
  funext i
  fin_cases i
  · change ((24 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (24) scale (2) (11) (by decide) (by decide)
  · change ((24 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (24) scale (2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((24 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (24) scale (2) (11) (by decide) (by decide)
  · change ((24 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (24) scale (2) (11) (by decide) (by decide)
  · change ((48 : ℤ) : ℚ) = (scale : ℚ) * (4 / 11 : ℚ)
    exact eq_smul_div (48) scale (4) (11) (by decide) (by decide)
  · change ((24 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (24) scale (2) (11) (by decide) (by decide)
  · change ((48 : ℤ) : ℚ) = (scale : ℚ) * (4 / 11 : ℚ)
    exact eq_smul_div (48) scale (4) (11) (by decide) (by decide)
  · change ((24 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (24) scale (2) (11) (by decide) (by decide)
  · change ((24 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (24) scale (2) (11) (by decide) (by decide)

theorem AZ_scale_4 : toVec (AZ 4) = (scale : ℚ) • ACell4_9 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((24 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (24) scale (2) (11) (by decide) (by decide)
  · change ((-24 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-24) scale (-2) (11) (by decide) (by decide)
  · change ((-24 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-24) scale (-2) (11) (by decide) (by decide)
  · change ((24 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (24) scale (2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem AZ_scale_5 : toVec (AZ 5) = (scale : ℚ) • ACell5_9 := by
  funext i
  fin_cases i
  · change ((36 : ℤ) : ℚ) = (scale : ℚ) * (3 / 11 : ℚ)
    exact eq_smul_div (36) scale (3) (11) (by decide) (by decide)
  · change ((24 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (24) scale (2) (11) (by decide) (by decide)
  · change ((36 : ℤ) : ℚ) = (scale : ℚ) * (3 / 11 : ℚ)
    exact eq_smul_div (36) scale (3) (11) (by decide) (by decide)
  · change ((24 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (24) scale (2) (11) (by decide) (by decide)
  · change ((12 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (12) scale (1) (11) (by decide) (by decide)
  · change ((12 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (12) scale (1) (11) (by decide) (by decide)
  · change ((24 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (24) scale (2) (11) (by decide) (by decide)
  · change ((36 : ℤ) : ℚ) = (scale : ℚ) * (3 / 11 : ℚ)
    exact eq_smul_div (36) scale (3) (11) (by decide) (by decide)
  · change ((24 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (24) scale (2) (11) (by decide) (by decide)
  · change ((36 : ℤ) : ℚ) = (scale : ℚ) * (3 / 11 : ℚ)
    exact eq_smul_div (36) scale (3) (11) (by decide) (by decide)

theorem AZ_scale_6 : toVec (AZ 6) = (scale : ℚ) • ACell6_9 := by
  funext i
  fin_cases i
  · change ((24 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (24) scale (2) (11) (by decide) (by decide)
  · change ((12 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (12) scale (1) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((12 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (12) scale (1) (11) (by decide) (by decide)
  · change ((12 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (12) scale (1) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((12 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (12) scale (1) (11) (by decide) (by decide)
  · change ((24 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (24) scale (2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((36 : ℤ) : ℚ) = (scale : ℚ) * (3 / 11 : ℚ)
    exact eq_smul_div (36) scale (3) (11) (by decide) (by decide)

theorem AZ_scale_7 : toVec (AZ 7) = (scale : ℚ) • ACell7_9 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((24 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (24) scale (2) (11) (by decide) (by decide)
  · change ((12 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (12) scale (1) (11) (by decide) (by decide)
  · change ((12 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (12) scale (1) (11) (by decide) (by decide)
  · change ((24 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (24) scale (2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((12 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (12) scale (1) (11) (by decide) (by decide)
  · change ((36 : ℤ) : ℚ) = (scale : ℚ) * (3 / 11 : ℚ)
    exact eq_smul_div (36) scale (3) (11) (by decide) (by decide)
  · change ((12 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (12) scale (1) (11) (by decide) (by decide)

theorem AZ_scale_8 : toVec (AZ 8) = (scale : ℚ) • ACell8_9 := by
  funext i
  fin_cases i
  · change ((-24 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-24) scale (-2) (11) (by decide) (by decide)
  · change ((-36 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 11 : ℚ)
    exact eq_smul_div (-36) scale (-3) (11) (by decide) (by decide)
  · change ((-24 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-24) scale (-2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-12 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-12) scale (-1) (11) (by decide) (by decide)
  · change ((-12 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-12) scale (-1) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-12 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-12) scale (-1) (11) (by decide) (by decide)
  · change ((-12 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-12) scale (-1) (11) (by decide) (by decide)

theorem AZ_scale_9 : toVec (AZ 9) = (scale : ℚ) • ACell9_9 := by
  funext i
  fin_cases i
  · change ((132 : ℤ) : ℚ) = (scale : ℚ) * (1 : ℚ)
    exact eq_smul_int (132) scale (1) (by decide)
  · change ((24 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (24) scale (2) (11) (by decide) (by decide)
  · change ((12 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (12) scale (1) (11) (by decide) (by decide)
  · change ((12 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (12) scale (1) (11) (by decide) (by decide)
  · change ((36 : ℤ) : ℚ) = (scale : ℚ) * (3 / 11 : ℚ)
    exact eq_smul_div (36) scale (3) (11) (by decide) (by decide)
  · change ((12 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (12) scale (1) (11) (by decide) (by decide)
  · change ((12 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (12) scale (1) (11) (by decide) (by decide)
  · change ((24 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (24) scale (2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem AZ_scale_10 : toVec (AZ 10) = (scale : ℚ) • ACell10_9 := by
  funext i
  fin_cases i
  · change ((24 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (24) scale (2) (11) (by decide) (by decide)
  · change ((24 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (24) scale (2) (11) (by decide) (by decide)
  · change ((48 : ℤ) : ℚ) = (scale : ℚ) * (4 / 11 : ℚ)
    exact eq_smul_div (48) scale (4) (11) (by decide) (by decide)
  · change ((48 : ℤ) : ℚ) = (scale : ℚ) * (4 / 11 : ℚ)
    exact eq_smul_div (48) scale (4) (11) (by decide) (by decide)
  · change ((24 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (24) scale (2) (11) (by decide) (by decide)
  · change ((24 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (24) scale (2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((24 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (24) scale (2) (11) (by decide) (by decide)
  · change ((24 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (24) scale (2) (11) (by decide) (by decide)
  · change ((24 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (24) scale (2) (11) (by decide) (by decide)

theorem AZ_scale_11 : toVec (AZ 11) = (scale : ℚ) • ACell11_9 := by
  funext i
  fin_cases i
  · change ((24 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (24) scale (2) (11) (by decide) (by decide)
  · change ((24 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (24) scale (2) (11) (by decide) (by decide)
  · change ((48 : ℤ) : ℚ) = (scale : ℚ) * (4 / 11 : ℚ)
    exact eq_smul_div (48) scale (4) (11) (by decide) (by decide)
  · change ((24 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (24) scale (2) (11) (by decide) (by decide)
  · change ((48 : ℤ) : ℚ) = (scale : ℚ) * (4 / 11 : ℚ)
    exact eq_smul_div (48) scale (4) (11) (by decide) (by decide)
  · change ((24 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (24) scale (2) (11) (by decide) (by decide)
  · change ((24 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (24) scale (2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((24 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (24) scale (2) (11) (by decide) (by decide)
  · change ((24 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (24) scale (2) (11) (by decide) (by decide)

theorem AZ_scale_12 : toVec (AZ 12) = (scale : ℚ) • ACell12_9 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((24 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (24) scale (2) (11) (by decide) (by decide)
  · change ((-24 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-24) scale (-2) (11) (by decide) (by decide)
  · change ((-24 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-24) scale (-2) (11) (by decide) (by decide)
  · change ((24 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (24) scale (2) (11) (by decide) (by decide)

theorem AZ_scale_13 : toVec (AZ 13) = (scale : ℚ) • ACell13_9 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-24 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-24) scale (-2) (11) (by decide) (by decide)
  · change ((24 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (24) scale (2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((24 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (24) scale (2) (11) (by decide) (by decide)
  · change ((-24 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-24) scale (-2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem AZ_scale_14 : toVec (AZ 14) = (scale : ℚ) • ACell14_9 := by
  funext i
  fin_cases i
  · change ((-24 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-24) scale (-2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-24 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-24) scale (-2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((24 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (24) scale (2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((24 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (24) scale (2) (11) (by decide) (by decide)

theorem AZ_scale_15 : toVec (AZ 15) = (scale : ℚ) • ACell15_9 := by
  funext i
  fin_cases i
  · change ((-12 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-12) scale (-1) (11) (by decide) (by decide)
  · change ((-12 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-12) scale (-1) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-24 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-24) scale (-2) (11) (by decide) (by decide)
  · change ((-36 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 11 : ℚ)
    exact eq_smul_div (-36) scale (-3) (11) (by decide) (by decide)
  · change ((-24 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-24) scale (-2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-12 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-12) scale (-1) (11) (by decide) (by decide)
  · change ((-12 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-12) scale (-1) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem AZ_scale_16 : toVec (AZ 16) = (scale : ℚ) • ACell16_9 := by
  funext i
  fin_cases i
  · change ((24 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (24) scale (2) (11) (by decide) (by decide)
  · change ((12 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (12) scale (1) (11) (by decide) (by decide)
  · change ((12 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (12) scale (1) (11) (by decide) (by decide)
  · change ((24 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (24) scale (2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((12 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (12) scale (1) (11) (by decide) (by decide)
  · change ((36 : ℤ) : ℚ) = (scale : ℚ) * (3 / 11 : ℚ)
    exact eq_smul_div (36) scale (3) (11) (by decide) (by decide)
  · change ((12 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (12) scale (1) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem AZ_scale_17 : toVec (AZ 17) = (scale : ℚ) • ACell17_9 := by
  funext i
  fin_cases i
  · change ((-24 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-24) scale (-2) (11) (by decide) (by decide)
  · change ((-24 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-24) scale (-2) (11) (by decide) (by decide)
  · change ((-12 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-12) scale (-1) (11) (by decide) (by decide)
  · change ((-36 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 11 : ℚ)
    exact eq_smul_div (-36) scale (-3) (11) (by decide) (by decide)
  · change ((-36 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 11 : ℚ)
    exact eq_smul_div (-36) scale (-3) (11) (by decide) (by decide)
  · change ((-36 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 11 : ℚ)
    exact eq_smul_div (-36) scale (-3) (11) (by decide) (by decide)
  · change ((-36 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 11 : ℚ)
    exact eq_smul_div (-36) scale (-3) (11) (by decide) (by decide)
  · change ((-12 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-12) scale (-1) (11) (by decide) (by decide)
  · change ((-24 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-24) scale (-2) (11) (by decide) (by decide)
  · change ((-24 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-24) scale (-2) (11) (by decide) (by decide)

theorem AZ_scale_18 : toVec (AZ 18) = (scale : ℚ) • ACell18_9 := by
  funext i
  fin_cases i
  · change ((-24 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-24) scale (-2) (11) (by decide) (by decide)
  · change ((-12 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-12) scale (-1) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-12 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-12) scale (-1) (11) (by decide) (by decide)
  · change ((-12 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-12) scale (-1) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-12 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-12) scale (-1) (11) (by decide) (by decide)
  · change ((-24 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-24) scale (-2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-36 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 11 : ℚ)
    exact eq_smul_div (-36) scale (-3) (11) (by decide) (by decide)

theorem AZ_scale_19 : toVec (AZ 19) = (scale : ℚ) • ACell19_9 := by
  funext i
  fin_cases i
  · change ((168 : ℤ) : ℚ) = (scale : ℚ) * (14 / 11 : ℚ)
    exact eq_smul_div (168) scale (14) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((12 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (12) scale (1) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((12 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (12) scale (1) (11) (by decide) (by decide)
  · change ((24 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (24) scale (2) (11) (by decide) (by decide)
  · change ((24 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (24) scale (2) (11) (by decide) (by decide)
  · change ((12 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (12) scale (1) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((12 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (12) scale (1) (11) (by decide) (by decide)

theorem AZ_scale (k : Fin 20) :
    toVec (AZ k) = (scale : ℚ) • AVec k (9 : Fin 10) := by
  fin_cases k
  · simp [AVec, ARow0]; exact AZ_scale_0
  · simp [AVec, ARow1]; exact AZ_scale_1
  · simp [AVec, ARow2]; exact AZ_scale_2
  · simp [AVec, ARow3]; exact AZ_scale_3
  · simp [AVec, ARow4]; exact AZ_scale_4
  · simp [AVec, ARow5]; exact AZ_scale_5
  · simp [AVec, ARow6]; exact AZ_scale_6
  · simp [AVec, ARow7]; exact AZ_scale_7
  · simp [AVec, ARow8]; exact AZ_scale_8
  · simp [AVec, ARow9]; exact AZ_scale_9
  · simp [AVec, ARow10]; exact AZ_scale_10
  · simp [AVec, ARow11]; exact AZ_scale_11
  · simp [AVec, ARow12]; exact AZ_scale_12
  · simp [AVec, ARow13]; exact AZ_scale_13
  · simp [AVec, ARow14]; exact AZ_scale_14
  · simp [AVec, ARow15]; exact AZ_scale_15
  · simp [AVec, ARow16]; exact AZ_scale_16
  · simp [AVec, ARow17]; exact AZ_scale_17
  · simp [AVec, ARow18]; exact AZ_scale_18
  · simp [AVec, ARow19]; exact AZ_scale_19

theorem KZ_scale_0 : toVec (KZ 0) = (scale : ℚ) • KCell7_0 := by
  funext i
  fin_cases i
  · change ((66 : ℤ) : ℚ) = (scale : ℚ) * (1 / 2 : ℚ)
    exact eq_smul_div (66) scale (1) (2) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-66 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 2 : ℚ)
    exact eq_smul_div (-66) scale (-1) (2) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((66 : ℤ) : ℚ) = (scale : ℚ) * (1 / 2 : ℚ)
    exact eq_smul_div (66) scale (1) (2) (by decide) (by decide)
  · change ((-66 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 2 : ℚ)
    exact eq_smul_div (-66) scale (-1) (2) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-66 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 2 : ℚ)
    exact eq_smul_div (-66) scale (-1) (2) (by decide) (by decide)

theorem KZ_scale (k : Fin 1) :
    toVec (KZ k) = (scale : ℚ) • KVec (7 : Fin 10) k := by
  fin_cases k
  · simp [KVec, KRow0]; exact KZ_scale_0

theorem YZ_scale_0 : toVec (YZ 0) = (scale : ℚ) • YCell0_9 := by
  funext i
  fin_cases i
  · change ((-88 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 3 : ℚ)
    exact eq_smul_div (-88) scale (-2) (3) (by decide) (by decide)
  · change ((88 : ℤ) : ℚ) = (scale : ℚ) * (2 / 3 : ℚ)
    exact eq_smul_div (88) scale (2) (3) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-88 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 3 : ℚ)
    exact eq_smul_div (-88) scale (-2) (3) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((88 : ℤ) : ℚ) = (scale : ℚ) * (2 / 3 : ℚ)
    exact eq_smul_div (88) scale (2) (3) (by decide) (by decide)
  · change ((88 : ℤ) : ℚ) = (scale : ℚ) * (2 / 3 : ℚ)
    exact eq_smul_div (88) scale (2) (3) (by decide) (by decide)
  · change ((-88 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 3 : ℚ)
    exact eq_smul_div (-88) scale (-2) (3) (by decide) (by decide)
  · change ((88 : ℤ) : ℚ) = (scale : ℚ) * (2 / 3 : ℚ)
    exact eq_smul_div (88) scale (2) (3) (by decide) (by decide)
  · change ((88 : ℤ) : ℚ) = (scale : ℚ) * (2 / 3 : ℚ)
    exact eq_smul_div (88) scale (2) (3) (by decide) (by decide)

theorem YZ_scale (k : Fin 1) :
    toVec (YZ k) = (scale : ℚ) • YVec k (9 : Fin 10) := by
  fin_cases k
  · simp [YVec, YRow0]; exact YZ_scale_0

theorem entry_eq :
    (matrixMul XVec AVec + matrixMul KVec YVec)
        (7 : Fin 10) (9 : Fin 10) = ![0, 0, 0, 0, 0, 0, 0, 0, 0, 0] := by
  change (∑ k : Fin 20, mul (XVec (7 : Fin 10) k)
      (AVec k (9 : Fin 10))) +
    (∑ k : Fin 1, mul (KVec (7 : Fin 10) k)
      (YVec k (9 : Fin 10))) = _
  refine add_sum_mul_eq_of_scaled scale scale_ne_zero
    (fun k => XVec (7 : Fin 10) k)
    (fun k => AVec k (9 : Fin 10))
    (fun k => KVec (7 : Fin 10) k)
    (fun k => YVec k (9 : Fin 10))
    XZ AZ KZ YZ XZ_scale AZ_scale KZ_scale YZ_scale entryZ rfl _ ?_
  rw [entryZ_eq, toVec_zeroZ_smul, vec_zero_eq]

theorem entry_eq_matrixOne :
    (matrixMul XVec AVec + matrixMul KVec YVec)
        (7 : Fin 10) (9 : Fin 10) =
      matrixOne (Fin 10) (7 : Fin 10) (9 : Fin 10) := by
  rw [entry_eq]
  have hne : (7 : Fin 10) ≠ (9 : Fin 10) := by decide
  funext n
  fin_cases n <;> simp [matrixOne, constVec, basis, *]

end V14Formalization.D12PieceAASplitEntry7_9


namespace V14Formalization.D12PieceAASplitRow7
open D12CyclotomicVec D12PieceAAData

public theorem row_eq (j : Fin 10) :
    (matrixMul XVec AVec + matrixMul KVec YVec)
      (7 : Fin 10) j = matrixOne (Fin 10) (7 : Fin 10) j := by
  fin_cases j
  · exact D12PieceAASplitEntry7_0.entry_eq_matrixOne
  · exact D12PieceAASplitEntry7_1.entry_eq_matrixOne
  · exact D12PieceAASplitEntry7_2.entry_eq_matrixOne
  · exact D12PieceAASplitEntry7_3.entry_eq_matrixOne
  · exact D12PieceAASplitEntry7_4.entry_eq_matrixOne
  · exact D12PieceAASplitEntry7_5.entry_eq_matrixOne
  · exact D12PieceAASplitEntry7_6.entry_eq_matrixOne
  · exact D12PieceAASplitEntry7_7.entry_eq_matrixOne
  · exact D12PieceAASplitEntry7_8.entry_eq_matrixOne
  · exact D12PieceAASplitEntry7_9.entry_eq_matrixOne

end V14Formalization.D12PieceAASplitRow7
