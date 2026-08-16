/- PP split identity entry (4,6). Auto-generated. -/
import V14Formalization.D12PiecePPData
import V14Formalization.D12CyclotomicVecZ

noncomputable section
open Matrix
namespace V14Formalization.D12PiecePPSplitEntry4_6
open D12CyclotomicVec D12CyclotomicVecZ D12PiecePPData
def payloadSha256 : String := "76c6196f29afe1a8398af99502447f48ebeed4bcb3805fc5dbec693940bc04b0"

def scale : ℤ := 33

def XZ (k : Fin 20) : VecZ :=
  match k.val with
  | 0 => #v[-54, -20, -12, -50, -21, -25, -17, -32, -58, -8]
  | 1 => #v[41, 5, 6, 36, 8, 19, 19, -3, 35, -1]
  | 2 => #v[-16, 1, 2, -17, -3, 23, 11, -18, -15, 10]
  | 3 => #v[-41, -16, -7, -21, -14, -14, -2, -2, -39, -9]
  | 4 => #v[-60, 1, 33, 3, -20, 10, 13, -12, -13, 23]
  | 5 => #v[18, 14, 32, 34, -6, 14, 22, -2, 46, 26]
  | 6 => #v[-76, -20, -10, -58, -42, -46, -40, -22, -72, -10]
  | 7 => #v[30, 16, -40, -10, 46, -16, -34, 36, 4, -32]
  | 8 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  | 9 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  | 10 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
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
  | 0 => #v[0, 6, -6, 0, 0, 0, 0, -6, 6, 0]
  | 1 => #v[0, 6, -6, -6, 6, 0, 0, 0, 0, 0]
  | 2 => #v[6, 6, 6, 0, 6, 6, 12, 12, 6, 6]
  | 3 => #v[6, 0, 6, 12, 6, 6, 6, 6, 12, 6]
  | 4 => #v[0, -6, 0, 0, 6, 0, 6, 0, 0, -6]
  | 5 => #v[-3, 3, 3, 0, -6, 0, 3, 3, -3, 0]
  | 6 => #v[-36, 0, -3, 6, -3, 0, -3, 0, 3, 3]
  | 7 => #v[-3, 3, 6, 3, -3, 0, 0, -3, -3, 0]
  | 8 => #v[0, 0, 0, -6, -3, -3, -9, -3, -3, -6]
  | 9 => #v[6, 3, 0, 3, 3, 0, 3, 6, 0, 9]
  | 10 => #v[0, 0, 0, 0, 0, 6, -6, -6, 6, 0]
  | 11 => #v[-6, -6, -6, -6, 0, -6, -12, -6, -12, -6]
  | 12 => #v[6, 6, 0, 6, 6, 12, 6, 12, 6, 6]
  | 13 => #v[-6, 0, 0, 6, 6, 0, 0, -6, 0, 0]
  | 14 => #v[0, 0, -6, 6, 0, 0, 0, 6, -6, 0]
  | 15 => #v[-3, 3, 3, 3, 3, -3, 0, 0, -6, 0]
  | 16 => #v[-30, 0, -6, -3, -3, -6, -6, -3, -3, -6]
  | 17 => #v[3, 6, 0, 9, 0, 6, 3, 0, 3, 3]
  | 18 => #v[-3, 0, -9, 0, -3, 0, -3, -6, -6, -3]
  | 19 => #v[3, -3, -3, 0, 6, 0, -3, -3, 3, 0]
  | _ => zeroZ

def KZ (k : Fin 2) : VecZ :=
  match k.val with
  | 0 => #v[0, 0, 0, 33, 33, 0, 0, 33, 33, 0]
  | 1 => #v[33, 0, -33, -33, 0, 0, 0, 0, -33, -33]
  | _ => zeroZ

def YZ (k : Fin 2) : VecZ :=
  match k.val with
  | 0 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  | 1 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  | _ => zeroZ

theorem xaMulZ0 :
    mulZ (XZ 0) (AZ 0) = #v[-654, -828, -372, -390, -600, -654, -600, -156, -822, -732] := by
  decide

theorem xaMulZ1 :
    mulZ (XZ 1) (AZ 1) = #v[-138, 546, -138, -156, 480, -90, -30, 252, -114, 312] := by
  decide

theorem xaMulZ2 :
    mulZ (XZ 2) (AZ 2) = #v[120, 48, -24, -168, -258, -102, 30, -66, -264, -240] := by
  decide

theorem xaMulZ3 :
    mulZ (XZ 3) (AZ 3) = #v[-510, -96, -108, -378, -144, -426, -330, -84, -510, -120] := by
  decide

theorem xaMulZ4 :
    mulZ (XZ 4) (AZ 4) = #v[-24, 528, 366, -150, -132, 384, 42, -6, 336, 702] := by
  decide

theorem xaMulZ5 :
    mulZ (XZ 5) (AZ 5) = #v[-114, -210, -210, 30, 258, -174, -330, -66, -30, 54] := by
  decide

theorem xaMulZ6 :
    mulZ (XZ 6) (AZ 6) = #v[2094, 456, 180, 1410, 1254, 1308, 990, 642, 2124, -30] := by
  decide

theorem xaMulZ7 :
    mulZ (XZ 7) (AZ 7) = #v[-774, -444, 306, -198, -858, -246, 228, -516, -720, 54] := by
  decide

theorem xaMulZ8 :
    mulZ (XZ 8) (AZ 8) = #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0] := by
  decide

theorem xaMulZ9 :
    mulZ (XZ 9) (AZ 9) = #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0] := by
  decide

theorem xaMulZ10 :
    mulZ (XZ 10) (AZ 10) = #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0] := by
  decide

theorem xaMulZ11 :
    mulZ (XZ 11) (AZ 11) = #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0] := by
  decide

theorem xaMulZ12 :
    mulZ (XZ 12) (AZ 12) = #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0] := by
  decide

theorem xaMulZ13 :
    mulZ (XZ 13) (AZ 13) = #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0] := by
  decide

theorem xaMulZ14 :
    mulZ (XZ 14) (AZ 14) = #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0] := by
  decide

theorem xaMulZ15 :
    mulZ (XZ 15) (AZ 15) = #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0] := by
  decide

theorem xaMulZ16 :
    mulZ (XZ 16) (AZ 16) = #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0] := by
  decide

theorem xaMulZ17 :
    mulZ (XZ 17) (AZ 17) = #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0] := by
  decide

theorem xaMulZ18 :
    mulZ (XZ 18) (AZ 18) = #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0] := by
  decide

theorem xaMulZ19 :
    mulZ (XZ 19) (AZ 19) = #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0] := by
  decide

def xaMuls (k : Fin 20) : VecZ :=
  match k.val with
  | 0 => #v[-654, -828, -372, -390, -600, -654, -600, -156, -822, -732]
  | 1 => #v[-138, 546, -138, -156, 480, -90, -30, 252, -114, 312]
  | 2 => #v[120, 48, -24, -168, -258, -102, 30, -66, -264, -240]
  | 3 => #v[-510, -96, -108, -378, -144, -426, -330, -84, -510, -120]
  | 4 => #v[-24, 528, 366, -150, -132, 384, 42, -6, 336, 702]
  | 5 => #v[-114, -210, -210, 30, 258, -174, -330, -66, -30, 54]
  | 6 => #v[2094, 456, 180, 1410, 1254, 1308, 990, 642, 2124, -30]
  | 7 => #v[-774, -444, 306, -198, -858, -246, 228, -516, -720, 54]
  | 8 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  | 9 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  | 10 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
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

theorem xaMulZ (k : Fin 20) :
    mulZ (XZ k) (AZ k) = xaMuls k := by
  fin_cases k
  · exact xaMulZ0
  · exact xaMulZ1
  · exact xaMulZ2
  · exact xaMulZ3
  · exact xaMulZ4
  · exact xaMulZ5
  · exact xaMulZ6
  · exact xaMulZ7
  · exact xaMulZ8
  · exact xaMulZ9
  · exact xaMulZ10
  · exact xaMulZ11
  · exact xaMulZ12
  · exact xaMulZ13
  · exact xaMulZ14
  · exact xaMulZ15
  · exact xaMulZ16
  · exact xaMulZ17
  · exact xaMulZ18
  · exact xaMulZ19

theorem xaSum_eq :
    sumFin (fun k => mulZ (XZ k) (AZ k)) = #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0] := by
  have h : sumFin (fun k => mulZ (XZ k) (AZ k)) =
      sumFin xaMuls := congrArg sumFin (funext xaMulZ)
  rw [h]
  decide

theorem kyMulZ0 :
    mulZ (KZ 0) (YZ 0) = #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0] := by
  decide

theorem kyMulZ1 :
    mulZ (KZ 1) (YZ 1) = #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0] := by
  decide

def kyMuls (k : Fin 2) : VecZ :=
  match k.val with
  | 0 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  | 1 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  | _ => zeroZ

theorem kyMulZ (k : Fin 2) :
    mulZ (KZ k) (YZ k) = kyMuls k := by
  fin_cases k
  · exact kyMulZ0
  · exact kyMulZ1

theorem kySum_eq :
    sumFin (fun k => mulZ (KZ k) (YZ k)) = #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0] := by
  have h : sumFin (fun k => mulZ (KZ k) (YZ k)) =
      sumFin kyMuls := congrArg sumFin (funext kyMulZ)
  rw [h]
  decide

def xaEntryZ : VecZ := sumFin (fun k => mulZ (XZ k) (AZ k))
def kyEntryZ : VecZ := sumFin (fun k => mulZ (KZ k) (YZ k))
def entryZ : VecZ := addZ xaEntryZ kyEntryZ

theorem entryZ_eq : entryZ = zeroZ := by
  unfold entryZ xaEntryZ kyEntryZ
  rw [xaSum_eq, kySum_eq]
  decide

theorem scale_ne_zero : scale ≠ 0 := by
  decide

theorem XZ_scale_0 : toVec (XZ 0) = (scale : ℚ) • XCell4_0 := by
  funext i
  fin_cases i
  · change ((-54 : ℤ) : ℚ) = (scale : ℚ) * (-18 / 11 : ℚ)
    exact eq_smul_div (-54) scale (-18) (11) (by decide) (by decide)
  · change ((-20 : ℤ) : ℚ) = (scale : ℚ) * (-20 / 33 : ℚ)
    exact eq_smul_div (-20) scale (-20) (33) (by decide) (by decide)
  · change ((-12 : ℤ) : ℚ) = (scale : ℚ) * (-4 / 11 : ℚ)
    exact eq_smul_div (-12) scale (-4) (11) (by decide) (by decide)
  · change ((-50 : ℤ) : ℚ) = (scale : ℚ) * (-50 / 33 : ℚ)
    exact eq_smul_div (-50) scale (-50) (33) (by decide) (by decide)
  · change ((-21 : ℤ) : ℚ) = (scale : ℚ) * (-7 / 11 : ℚ)
    exact eq_smul_div (-21) scale (-7) (11) (by decide) (by decide)
  · change ((-25 : ℤ) : ℚ) = (scale : ℚ) * (-25 / 33 : ℚ)
    exact eq_smul_div (-25) scale (-25) (33) (by decide) (by decide)
  · change ((-17 : ℤ) : ℚ) = (scale : ℚ) * (-17 / 33 : ℚ)
    exact eq_smul_div (-17) scale (-17) (33) (by decide) (by decide)
  · change ((-32 : ℤ) : ℚ) = (scale : ℚ) * (-32 / 33 : ℚ)
    exact eq_smul_div (-32) scale (-32) (33) (by decide) (by decide)
  · change ((-58 : ℤ) : ℚ) = (scale : ℚ) * (-58 / 33 : ℚ)
    exact eq_smul_div (-58) scale (-58) (33) (by decide) (by decide)
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-8 / 33 : ℚ)
    exact eq_smul_div (-8) scale (-8) (33) (by decide) (by decide)

theorem XZ_scale_1 : toVec (XZ 1) = (scale : ℚ) • XCell4_1 := by
  funext i
  fin_cases i
  · change ((41 : ℤ) : ℚ) = (scale : ℚ) * (41 / 33 : ℚ)
    exact eq_smul_div (41) scale (41) (33) (by decide) (by decide)
  · change ((5 : ℤ) : ℚ) = (scale : ℚ) * (5 / 33 : ℚ)
    exact eq_smul_div (5) scale (5) (33) (by decide) (by decide)
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (6) scale (2) (11) (by decide) (by decide)
  · change ((36 : ℤ) : ℚ) = (scale : ℚ) * (12 / 11 : ℚ)
    exact eq_smul_div (36) scale (12) (11) (by decide) (by decide)
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (8 / 33 : ℚ)
    exact eq_smul_div (8) scale (8) (33) (by decide) (by decide)
  · change ((19 : ℤ) : ℚ) = (scale : ℚ) * (19 / 33 : ℚ)
    exact eq_smul_div (19) scale (19) (33) (by decide) (by decide)
  · change ((19 : ℤ) : ℚ) = (scale : ℚ) * (19 / 33 : ℚ)
    exact eq_smul_div (19) scale (19) (33) (by decide) (by decide)
  · change ((-3 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-3) scale (-1) (11) (by decide) (by decide)
  · change ((35 : ℤ) : ℚ) = (scale : ℚ) * (35 / 33 : ℚ)
    exact eq_smul_div (35) scale (35) (33) (by decide) (by decide)
  · change ((-1 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 33 : ℚ)
    exact eq_smul_div (-1) scale (-1) (33) (by decide) (by decide)

theorem XZ_scale_2 : toVec (XZ 2) = (scale : ℚ) • XCell4_2 := by
  funext i
  fin_cases i
  · change ((-16 : ℤ) : ℚ) = (scale : ℚ) * (-16 / 33 : ℚ)
    exact eq_smul_div (-16) scale (-16) (33) (by decide) (by decide)
  · change ((1 : ℤ) : ℚ) = (scale : ℚ) * (1 / 33 : ℚ)
    exact eq_smul_div (1) scale (1) (33) (by decide) (by decide)
  · change ((2 : ℤ) : ℚ) = (scale : ℚ) * (2 / 33 : ℚ)
    exact eq_smul_div (2) scale (2) (33) (by decide) (by decide)
  · change ((-17 : ℤ) : ℚ) = (scale : ℚ) * (-17 / 33 : ℚ)
    exact eq_smul_div (-17) scale (-17) (33) (by decide) (by decide)
  · change ((-3 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-3) scale (-1) (11) (by decide) (by decide)
  · change ((23 : ℤ) : ℚ) = (scale : ℚ) * (23 / 33 : ℚ)
    exact eq_smul_div (23) scale (23) (33) (by decide) (by decide)
  · change ((11 : ℤ) : ℚ) = (scale : ℚ) * (1 / 3 : ℚ)
    exact eq_smul_div (11) scale (1) (3) (by decide) (by decide)
  · change ((-18 : ℤ) : ℚ) = (scale : ℚ) * (-6 / 11 : ℚ)
    exact eq_smul_div (-18) scale (-6) (11) (by decide) (by decide)
  · change ((-15 : ℤ) : ℚ) = (scale : ℚ) * (-5 / 11 : ℚ)
    exact eq_smul_div (-15) scale (-5) (11) (by decide) (by decide)
  · change ((10 : ℤ) : ℚ) = (scale : ℚ) * (10 / 33 : ℚ)
    exact eq_smul_div (10) scale (10) (33) (by decide) (by decide)

theorem XZ_scale_3 : toVec (XZ 3) = (scale : ℚ) • XCell4_3 := by
  funext i
  fin_cases i
  · change ((-41 : ℤ) : ℚ) = (scale : ℚ) * (-41 / 33 : ℚ)
    exact eq_smul_div (-41) scale (-41) (33) (by decide) (by decide)
  · change ((-16 : ℤ) : ℚ) = (scale : ℚ) * (-16 / 33 : ℚ)
    exact eq_smul_div (-16) scale (-16) (33) (by decide) (by decide)
  · change ((-7 : ℤ) : ℚ) = (scale : ℚ) * (-7 / 33 : ℚ)
    exact eq_smul_div (-7) scale (-7) (33) (by decide) (by decide)
  · change ((-21 : ℤ) : ℚ) = (scale : ℚ) * (-7 / 11 : ℚ)
    exact eq_smul_div (-21) scale (-7) (11) (by decide) (by decide)
  · change ((-14 : ℤ) : ℚ) = (scale : ℚ) * (-14 / 33 : ℚ)
    exact eq_smul_div (-14) scale (-14) (33) (by decide) (by decide)
  · change ((-14 : ℤ) : ℚ) = (scale : ℚ) * (-14 / 33 : ℚ)
    exact eq_smul_div (-14) scale (-14) (33) (by decide) (by decide)
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 33 : ℚ)
    exact eq_smul_div (-2) scale (-2) (33) (by decide) (by decide)
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 33 : ℚ)
    exact eq_smul_div (-2) scale (-2) (33) (by decide) (by decide)
  · change ((-39 : ℤ) : ℚ) = (scale : ℚ) * (-13 / 11 : ℚ)
    exact eq_smul_div (-39) scale (-13) (11) (by decide) (by decide)
  · change ((-9 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 11 : ℚ)
    exact eq_smul_div (-9) scale (-3) (11) (by decide) (by decide)

theorem XZ_scale_4 : toVec (XZ 4) = (scale : ℚ) • XCell4_4 := by
  funext i
  fin_cases i
  · change ((-60 : ℤ) : ℚ) = (scale : ℚ) * (-20 / 11 : ℚ)
    exact eq_smul_div (-60) scale (-20) (11) (by decide) (by decide)
  · change ((1 : ℤ) : ℚ) = (scale : ℚ) * (1 / 33 : ℚ)
    exact eq_smul_div (1) scale (1) (33) (by decide) (by decide)
  · change ((33 : ℤ) : ℚ) = (scale : ℚ) * (1 : ℚ)
    exact eq_smul_int (33) scale (1) (by decide)
  · change ((3 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (3) scale (1) (11) (by decide) (by decide)
  · change ((-20 : ℤ) : ℚ) = (scale : ℚ) * (-20 / 33 : ℚ)
    exact eq_smul_div (-20) scale (-20) (33) (by decide) (by decide)
  · change ((10 : ℤ) : ℚ) = (scale : ℚ) * (10 / 33 : ℚ)
    exact eq_smul_div (10) scale (10) (33) (by decide) (by decide)
  · change ((13 : ℤ) : ℚ) = (scale : ℚ) * (13 / 33 : ℚ)
    exact eq_smul_div (13) scale (13) (33) (by decide) (by decide)
  · change ((-12 : ℤ) : ℚ) = (scale : ℚ) * (-4 / 11 : ℚ)
    exact eq_smul_div (-12) scale (-4) (11) (by decide) (by decide)
  · change ((-13 : ℤ) : ℚ) = (scale : ℚ) * (-13 / 33 : ℚ)
    exact eq_smul_div (-13) scale (-13) (33) (by decide) (by decide)
  · change ((23 : ℤ) : ℚ) = (scale : ℚ) * (23 / 33 : ℚ)
    exact eq_smul_div (23) scale (23) (33) (by decide) (by decide)

theorem XZ_scale_5 : toVec (XZ 5) = (scale : ℚ) • XCell4_5 := by
  funext i
  fin_cases i
  · change ((18 : ℤ) : ℚ) = (scale : ℚ) * (6 / 11 : ℚ)
    exact eq_smul_div (18) scale (6) (11) (by decide) (by decide)
  · change ((14 : ℤ) : ℚ) = (scale : ℚ) * (14 / 33 : ℚ)
    exact eq_smul_div (14) scale (14) (33) (by decide) (by decide)
  · change ((32 : ℤ) : ℚ) = (scale : ℚ) * (32 / 33 : ℚ)
    exact eq_smul_div (32) scale (32) (33) (by decide) (by decide)
  · change ((34 : ℤ) : ℚ) = (scale : ℚ) * (34 / 33 : ℚ)
    exact eq_smul_div (34) scale (34) (33) (by decide) (by decide)
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-6) scale (-2) (11) (by decide) (by decide)
  · change ((14 : ℤ) : ℚ) = (scale : ℚ) * (14 / 33 : ℚ)
    exact eq_smul_div (14) scale (14) (33) (by decide) (by decide)
  · change ((22 : ℤ) : ℚ) = (scale : ℚ) * (2 / 3 : ℚ)
    exact eq_smul_div (22) scale (2) (3) (by decide) (by decide)
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 33 : ℚ)
    exact eq_smul_div (-2) scale (-2) (33) (by decide) (by decide)
  · change ((46 : ℤ) : ℚ) = (scale : ℚ) * (46 / 33 : ℚ)
    exact eq_smul_div (46) scale (46) (33) (by decide) (by decide)
  · change ((26 : ℤ) : ℚ) = (scale : ℚ) * (26 / 33 : ℚ)
    exact eq_smul_div (26) scale (26) (33) (by decide) (by decide)

theorem XZ_scale_6 : toVec (XZ 6) = (scale : ℚ) • XCell4_6 := by
  funext i
  fin_cases i
  · change ((-76 : ℤ) : ℚ) = (scale : ℚ) * (-76 / 33 : ℚ)
    exact eq_smul_div (-76) scale (-76) (33) (by decide) (by decide)
  · change ((-20 : ℤ) : ℚ) = (scale : ℚ) * (-20 / 33 : ℚ)
    exact eq_smul_div (-20) scale (-20) (33) (by decide) (by decide)
  · change ((-10 : ℤ) : ℚ) = (scale : ℚ) * (-10 / 33 : ℚ)
    exact eq_smul_div (-10) scale (-10) (33) (by decide) (by decide)
  · change ((-58 : ℤ) : ℚ) = (scale : ℚ) * (-58 / 33 : ℚ)
    exact eq_smul_div (-58) scale (-58) (33) (by decide) (by decide)
  · change ((-42 : ℤ) : ℚ) = (scale : ℚ) * (-14 / 11 : ℚ)
    exact eq_smul_div (-42) scale (-14) (11) (by decide) (by decide)
  · change ((-46 : ℤ) : ℚ) = (scale : ℚ) * (-46 / 33 : ℚ)
    exact eq_smul_div (-46) scale (-46) (33) (by decide) (by decide)
  · change ((-40 : ℤ) : ℚ) = (scale : ℚ) * (-40 / 33 : ℚ)
    exact eq_smul_div (-40) scale (-40) (33) (by decide) (by decide)
  · change ((-22 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 3 : ℚ)
    exact eq_smul_div (-22) scale (-2) (3) (by decide) (by decide)
  · change ((-72 : ℤ) : ℚ) = (scale : ℚ) * (-24 / 11 : ℚ)
    exact eq_smul_div (-72) scale (-24) (11) (by decide) (by decide)
  · change ((-10 : ℤ) : ℚ) = (scale : ℚ) * (-10 / 33 : ℚ)
    exact eq_smul_div (-10) scale (-10) (33) (by decide) (by decide)

theorem XZ_scale_7 : toVec (XZ 7) = (scale : ℚ) • XCell4_7 := by
  funext i
  fin_cases i
  · change ((30 : ℤ) : ℚ) = (scale : ℚ) * (10 / 11 : ℚ)
    exact eq_smul_div (30) scale (10) (11) (by decide) (by decide)
  · change ((16 : ℤ) : ℚ) = (scale : ℚ) * (16 / 33 : ℚ)
    exact eq_smul_div (16) scale (16) (33) (by decide) (by decide)
  · change ((-40 : ℤ) : ℚ) = (scale : ℚ) * (-40 / 33 : ℚ)
    exact eq_smul_div (-40) scale (-40) (33) (by decide) (by decide)
  · change ((-10 : ℤ) : ℚ) = (scale : ℚ) * (-10 / 33 : ℚ)
    exact eq_smul_div (-10) scale (-10) (33) (by decide) (by decide)
  · change ((46 : ℤ) : ℚ) = (scale : ℚ) * (46 / 33 : ℚ)
    exact eq_smul_div (46) scale (46) (33) (by decide) (by decide)
  · change ((-16 : ℤ) : ℚ) = (scale : ℚ) * (-16 / 33 : ℚ)
    exact eq_smul_div (-16) scale (-16) (33) (by decide) (by decide)
  · change ((-34 : ℤ) : ℚ) = (scale : ℚ) * (-34 / 33 : ℚ)
    exact eq_smul_div (-34) scale (-34) (33) (by decide) (by decide)
  · change ((36 : ℤ) : ℚ) = (scale : ℚ) * (12 / 11 : ℚ)
    exact eq_smul_div (36) scale (12) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (4 / 33 : ℚ)
    exact eq_smul_div (4) scale (4) (33) (by decide) (by decide)
  · change ((-32 : ℤ) : ℚ) = (scale : ℚ) * (-32 / 33 : ℚ)
    exact eq_smul_div (-32) scale (-32) (33) (by decide) (by decide)

theorem XZ_scale_8 : toVec (XZ 8) = (scale : ℚ) • XCell4_8 := by
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

theorem XZ_scale_9 : toVec (XZ 9) = (scale : ℚ) • XCell4_9 := by
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

theorem XZ_scale_10 : toVec (XZ 10) = (scale : ℚ) • XCell4_10 := by
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

theorem XZ_scale_11 : toVec (XZ 11) = (scale : ℚ) • XCell4_11 := by
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

theorem XZ_scale_12 : toVec (XZ 12) = (scale : ℚ) • XCell4_12 := by
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

theorem XZ_scale_13 : toVec (XZ 13) = (scale : ℚ) • XCell4_13 := by
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

theorem XZ_scale_14 : toVec (XZ 14) = (scale : ℚ) • XCell4_14 := by
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

theorem XZ_scale_15 : toVec (XZ 15) = (scale : ℚ) • XCell4_15 := by
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

theorem XZ_scale_16 : toVec (XZ 16) = (scale : ℚ) • XCell4_16 := by
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

theorem XZ_scale_17 : toVec (XZ 17) = (scale : ℚ) • XCell4_17 := by
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

theorem XZ_scale_18 : toVec (XZ 18) = (scale : ℚ) • XCell4_18 := by
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

theorem XZ_scale_19 : toVec (XZ 19) = (scale : ℚ) • XCell4_19 := by
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
    toVec (XZ k) = (scale : ℚ) • XVec (4 : Fin 10) k := by
  fin_cases k
  · simp [XVec, XRow4]; exact XZ_scale_0
  · simp [XVec, XRow4]; exact XZ_scale_1
  · simp [XVec, XRow4]; exact XZ_scale_2
  · simp [XVec, XRow4]; exact XZ_scale_3
  · simp [XVec, XRow4]; exact XZ_scale_4
  · simp [XVec, XRow4]; exact XZ_scale_5
  · simp [XVec, XRow4]; exact XZ_scale_6
  · simp [XVec, XRow4]; exact XZ_scale_7
  · simp [XVec, XRow4]; exact XZ_scale_8
  · simp [XVec, XRow4]; exact XZ_scale_9
  · simp [XVec, XRow4]; exact XZ_scale_10
  · simp [XVec, XRow4]; exact XZ_scale_11
  · simp [XVec, XRow4]; exact XZ_scale_12
  · simp [XVec, XRow4]; exact XZ_scale_13
  · simp [XVec, XRow4]; exact XZ_scale_14
  · simp [XVec, XRow4]; exact XZ_scale_15
  · simp [XVec, XRow4]; exact XZ_scale_16
  · simp [XVec, XRow4]; exact XZ_scale_17
  · simp [XVec, XRow4]; exact XZ_scale_18
  · simp [XVec, XRow4]; exact XZ_scale_19

theorem AZ_scale_0 : toVec (AZ 0) = (scale : ℚ) • ACell0_6 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (6) scale (2) (11) (by decide) (by decide)
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-6) scale (-2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-6) scale (-2) (11) (by decide) (by decide)
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (6) scale (2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem AZ_scale_1 : toVec (AZ 1) = (scale : ℚ) • ACell1_6 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (6) scale (2) (11) (by decide) (by decide)
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-6) scale (-2) (11) (by decide) (by decide)
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-6) scale (-2) (11) (by decide) (by decide)
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (6) scale (2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
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
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (6) scale (2) (11) (by decide) (by decide)
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (6) scale (2) (11) (by decide) (by decide)
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (6) scale (2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (6) scale (2) (11) (by decide) (by decide)
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (6) scale (2) (11) (by decide) (by decide)
  · change ((12 : ℤ) : ℚ) = (scale : ℚ) * (4 / 11 : ℚ)
    exact eq_smul_div (12) scale (4) (11) (by decide) (by decide)
  · change ((12 : ℤ) : ℚ) = (scale : ℚ) * (4 / 11 : ℚ)
    exact eq_smul_div (12) scale (4) (11) (by decide) (by decide)
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (6) scale (2) (11) (by decide) (by decide)
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (6) scale (2) (11) (by decide) (by decide)

theorem AZ_scale_3 : toVec (AZ 3) = (scale : ℚ) • ACell3_6 := by
  funext i
  fin_cases i
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (6) scale (2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (6) scale (2) (11) (by decide) (by decide)
  · change ((12 : ℤ) : ℚ) = (scale : ℚ) * (4 / 11 : ℚ)
    exact eq_smul_div (12) scale (4) (11) (by decide) (by decide)
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (6) scale (2) (11) (by decide) (by decide)
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (6) scale (2) (11) (by decide) (by decide)
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (6) scale (2) (11) (by decide) (by decide)
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (6) scale (2) (11) (by decide) (by decide)
  · change ((12 : ℤ) : ℚ) = (scale : ℚ) * (4 / 11 : ℚ)
    exact eq_smul_div (12) scale (4) (11) (by decide) (by decide)
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (6) scale (2) (11) (by decide) (by decide)

theorem AZ_scale_4 : toVec (AZ 4) = (scale : ℚ) • ACell4_6 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-6) scale (-2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (6) scale (2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (6) scale (2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-6) scale (-2) (11) (by decide) (by decide)

theorem AZ_scale_5 : toVec (AZ 5) = (scale : ℚ) • ACell5_6 := by
  funext i
  fin_cases i
  · change ((-3 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-3) scale (-1) (11) (by decide) (by decide)
  · change ((3 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (3) scale (1) (11) (by decide) (by decide)
  · change ((3 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (3) scale (1) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-6) scale (-2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((3 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (3) scale (1) (11) (by decide) (by decide)
  · change ((3 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (3) scale (1) (11) (by decide) (by decide)
  · change ((-3 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-3) scale (-1) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem AZ_scale_6 : toVec (AZ 6) = (scale : ℚ) • ACell6_6 := by
  funext i
  fin_cases i
  · change ((-36 : ℤ) : ℚ) = (scale : ℚ) * (-12 / 11 : ℚ)
    exact eq_smul_div (-36) scale (-12) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-3 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-3) scale (-1) (11) (by decide) (by decide)
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (6) scale (2) (11) (by decide) (by decide)
  · change ((-3 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-3) scale (-1) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-3 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-3) scale (-1) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((3 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (3) scale (1) (11) (by decide) (by decide)
  · change ((3 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (3) scale (1) (11) (by decide) (by decide)

theorem AZ_scale_7 : toVec (AZ 7) = (scale : ℚ) • ACell7_6 := by
  funext i
  fin_cases i
  · change ((-3 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-3) scale (-1) (11) (by decide) (by decide)
  · change ((3 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (3) scale (1) (11) (by decide) (by decide)
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (6) scale (2) (11) (by decide) (by decide)
  · change ((3 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (3) scale (1) (11) (by decide) (by decide)
  · change ((-3 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-3) scale (-1) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-3 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-3) scale (-1) (11) (by decide) (by decide)
  · change ((-3 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-3) scale (-1) (11) (by decide) (by decide)
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
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-6) scale (-2) (11) (by decide) (by decide)
  · change ((-3 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-3) scale (-1) (11) (by decide) (by decide)
  · change ((-3 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-3) scale (-1) (11) (by decide) (by decide)
  · change ((-9 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 11 : ℚ)
    exact eq_smul_div (-9) scale (-3) (11) (by decide) (by decide)
  · change ((-3 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-3) scale (-1) (11) (by decide) (by decide)
  · change ((-3 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-3) scale (-1) (11) (by decide) (by decide)
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-6) scale (-2) (11) (by decide) (by decide)

theorem AZ_scale_9 : toVec (AZ 9) = (scale : ℚ) • ACell9_6 := by
  funext i
  fin_cases i
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (6) scale (2) (11) (by decide) (by decide)
  · change ((3 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (3) scale (1) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((3 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (3) scale (1) (11) (by decide) (by decide)
  · change ((3 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (3) scale (1) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((3 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (3) scale (1) (11) (by decide) (by decide)
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (6) scale (2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((9 : ℤ) : ℚ) = (scale : ℚ) * (3 / 11 : ℚ)
    exact eq_smul_div (9) scale (3) (11) (by decide) (by decide)

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
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (6) scale (2) (11) (by decide) (by decide)
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-6) scale (-2) (11) (by decide) (by decide)
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-6) scale (-2) (11) (by decide) (by decide)
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (6) scale (2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem AZ_scale_11 : toVec (AZ 11) = (scale : ℚ) • ACell11_6 := by
  funext i
  fin_cases i
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-6) scale (-2) (11) (by decide) (by decide)
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-6) scale (-2) (11) (by decide) (by decide)
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-6) scale (-2) (11) (by decide) (by decide)
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-6) scale (-2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-6) scale (-2) (11) (by decide) (by decide)
  · change ((-12 : ℤ) : ℚ) = (scale : ℚ) * (-4 / 11 : ℚ)
    exact eq_smul_div (-12) scale (-4) (11) (by decide) (by decide)
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-6) scale (-2) (11) (by decide) (by decide)
  · change ((-12 : ℤ) : ℚ) = (scale : ℚ) * (-4 / 11 : ℚ)
    exact eq_smul_div (-12) scale (-4) (11) (by decide) (by decide)
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-6) scale (-2) (11) (by decide) (by decide)

theorem AZ_scale_12 : toVec (AZ 12) = (scale : ℚ) • ACell12_6 := by
  funext i
  fin_cases i
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (6) scale (2) (11) (by decide) (by decide)
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (6) scale (2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (6) scale (2) (11) (by decide) (by decide)
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (6) scale (2) (11) (by decide) (by decide)
  · change ((12 : ℤ) : ℚ) = (scale : ℚ) * (4 / 11 : ℚ)
    exact eq_smul_div (12) scale (4) (11) (by decide) (by decide)
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (6) scale (2) (11) (by decide) (by decide)
  · change ((12 : ℤ) : ℚ) = (scale : ℚ) * (4 / 11 : ℚ)
    exact eq_smul_div (12) scale (4) (11) (by decide) (by decide)
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (6) scale (2) (11) (by decide) (by decide)
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (6) scale (2) (11) (by decide) (by decide)

theorem AZ_scale_13 : toVec (AZ 13) = (scale : ℚ) • ACell13_6 := by
  funext i
  fin_cases i
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-6) scale (-2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (6) scale (2) (11) (by decide) (by decide)
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (6) scale (2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-6) scale (-2) (11) (by decide) (by decide)
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
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-6) scale (-2) (11) (by decide) (by decide)
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (6) scale (2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (6) scale (2) (11) (by decide) (by decide)
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-6) scale (-2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem AZ_scale_15 : toVec (AZ 15) = (scale : ℚ) • ACell15_6 := by
  funext i
  fin_cases i
  · change ((-3 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-3) scale (-1) (11) (by decide) (by decide)
  · change ((3 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (3) scale (1) (11) (by decide) (by decide)
  · change ((3 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (3) scale (1) (11) (by decide) (by decide)
  · change ((3 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (3) scale (1) (11) (by decide) (by decide)
  · change ((3 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (3) scale (1) (11) (by decide) (by decide)
  · change ((-3 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-3) scale (-1) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-6) scale (-2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem AZ_scale_16 : toVec (AZ 16) = (scale : ℚ) • ACell16_6 := by
  funext i
  fin_cases i
  · change ((-30 : ℤ) : ℚ) = (scale : ℚ) * (-10 / 11 : ℚ)
    exact eq_smul_div (-30) scale (-10) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-6) scale (-2) (11) (by decide) (by decide)
  · change ((-3 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-3) scale (-1) (11) (by decide) (by decide)
  · change ((-3 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-3) scale (-1) (11) (by decide) (by decide)
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-6) scale (-2) (11) (by decide) (by decide)
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-6) scale (-2) (11) (by decide) (by decide)
  · change ((-3 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-3) scale (-1) (11) (by decide) (by decide)
  · change ((-3 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-3) scale (-1) (11) (by decide) (by decide)
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-6) scale (-2) (11) (by decide) (by decide)

theorem AZ_scale_17 : toVec (AZ 17) = (scale : ℚ) • ACell17_6 := by
  funext i
  fin_cases i
  · change ((3 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (3) scale (1) (11) (by decide) (by decide)
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (6) scale (2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((9 : ℤ) : ℚ) = (scale : ℚ) * (3 / 11 : ℚ)
    exact eq_smul_div (9) scale (3) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (6) scale (2) (11) (by decide) (by decide)
  · change ((3 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (3) scale (1) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((3 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (3) scale (1) (11) (by decide) (by decide)
  · change ((3 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (3) scale (1) (11) (by decide) (by decide)

theorem AZ_scale_18 : toVec (AZ 18) = (scale : ℚ) • ACell18_6 := by
  funext i
  fin_cases i
  · change ((-3 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-3) scale (-1) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-9 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 11 : ℚ)
    exact eq_smul_div (-9) scale (-3) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-3 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-3) scale (-1) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-3 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-3) scale (-1) (11) (by decide) (by decide)
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-6) scale (-2) (11) (by decide) (by decide)
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-6) scale (-2) (11) (by decide) (by decide)
  · change ((-3 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-3) scale (-1) (11) (by decide) (by decide)

theorem AZ_scale_19 : toVec (AZ 19) = (scale : ℚ) • ACell19_6 := by
  funext i
  fin_cases i
  · change ((3 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (3) scale (1) (11) (by decide) (by decide)
  · change ((-3 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-3) scale (-1) (11) (by decide) (by decide)
  · change ((-3 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-3) scale (-1) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (6) scale (2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-3 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-3) scale (-1) (11) (by decide) (by decide)
  · change ((-3 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-3) scale (-1) (11) (by decide) (by decide)
  · change ((3 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (3) scale (1) (11) (by decide) (by decide)
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

theorem KZ_scale_0 : toVec (KZ 0) = (scale : ℚ) • KCell4_0 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((33 : ℤ) : ℚ) = (scale : ℚ) * (1 : ℚ)
    exact eq_smul_int (33) scale (1) (by decide)
  · change ((33 : ℤ) : ℚ) = (scale : ℚ) * (1 : ℚ)
    exact eq_smul_int (33) scale (1) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((33 : ℤ) : ℚ) = (scale : ℚ) * (1 : ℚ)
    exact eq_smul_int (33) scale (1) (by decide)
  · change ((33 : ℤ) : ℚ) = (scale : ℚ) * (1 : ℚ)
    exact eq_smul_int (33) scale (1) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem KZ_scale_1 : toVec (KZ 1) = (scale : ℚ) • KCell4_1 := by
  funext i
  fin_cases i
  · change ((33 : ℤ) : ℚ) = (scale : ℚ) * (1 : ℚ)
    exact eq_smul_int (33) scale (1) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-33 : ℤ) : ℚ) = (scale : ℚ) * (-1 : ℚ)
    exact eq_smul_int (-33) scale (-1) (by decide)
  · change ((-33 : ℤ) : ℚ) = (scale : ℚ) * (-1 : ℚ)
    exact eq_smul_int (-33) scale (-1) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-33 : ℤ) : ℚ) = (scale : ℚ) * (-1 : ℚ)
    exact eq_smul_int (-33) scale (-1) (by decide)
  · change ((-33 : ℤ) : ℚ) = (scale : ℚ) * (-1 : ℚ)
    exact eq_smul_int (-33) scale (-1) (by decide)

theorem KZ_scale (k : Fin 2) :
    toVec (KZ k) = (scale : ℚ) • KVec (4 : Fin 10) k := by
  fin_cases k
  · simp [KVec, KRow0]; exact KZ_scale_0
  · simp [KVec, KRow1]; exact KZ_scale_1

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

theorem YZ_scale_1 : toVec (YZ 1) = (scale : ℚ) • YCell1_6 := by
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

theorem YZ_scale (k : Fin 2) :
    toVec (YZ k) = (scale : ℚ) • YVec k (6 : Fin 10) := by
  fin_cases k
  · simp [YVec, YRow0]; exact YZ_scale_0
  · simp [YVec, YRow1]; exact YZ_scale_1

theorem entry_eq :
    (matrixMul XVec AVec + matrixMul KVec YVec)
        (4 : Fin 10) (6 : Fin 10) = ![0, 0, 0, 0, 0, 0, 0, 0, 0, 0] := by
  change (∑ k : Fin 20, mul (XVec (4 : Fin 10) k)
      (AVec k (6 : Fin 10))) +
    (∑ k : Fin 2, mul (KVec (4 : Fin 10) k)
      (YVec k (6 : Fin 10))) = _
  refine add_sum_mul_eq_of_scaled scale scale_ne_zero
    (fun k => XVec (4 : Fin 10) k)
    (fun k => AVec k (6 : Fin 10))
    (fun k => KVec (4 : Fin 10) k)
    (fun k => YVec k (6 : Fin 10))
    XZ AZ KZ YZ XZ_scale AZ_scale KZ_scale YZ_scale entryZ rfl _ ?_
  rw [entryZ_eq, toVec_zeroZ_smul, vec_zero_eq]

theorem entry_eq_matrixOne :
    (matrixMul XVec AVec + matrixMul KVec YVec)
        (4 : Fin 10) (6 : Fin 10) =
      matrixOne (Fin 10) (4 : Fin 10) (6 : Fin 10) := by
  rw [entry_eq]
  have hne : (4 : Fin 10) ≠ (6 : Fin 10) := by decide
  funext n
  fin_cases n <;> simp [matrixOne, constVec, basis, *]

end V14Formalization.D12PiecePPSplitEntry4_6
