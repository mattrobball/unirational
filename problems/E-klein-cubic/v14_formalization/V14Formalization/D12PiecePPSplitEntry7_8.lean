/- PP split identity entry (7,8). Auto-generated. -/
import V14Formalization.D12PiecePPData
import V14Formalization.D12CyclotomicVecZ

noncomputable section
open Matrix
namespace V14Formalization.D12PiecePPSplitEntry7_8
open D12CyclotomicVec D12CyclotomicVecZ D12PiecePPData
def payloadSha256 : String := "76c6196f29afe1a8398af99502447f48ebeed4bcb3805fc5dbec693940bc04b0"

def scale : ℤ := 66

def XZ (k : Fin 20) : VecZ :=
  match k.val with
  | 0 => #v[-132, 33, -69, -111, 102, -126, -105, 63, -87, -63]
  | 1 => #v[141, -15, 57, 138, -60, 111, 138, -54, 177, 60]
  | 2 => #v[15, -3, -24, 18, 30, -39, -30, 66, 12, -12]
  | 3 => #v[-96, 39, -36, -114, 54, -78, -114, 18, -78, -57]
  | 4 => #v[45, 24, -60, -15, 69, -24, -51, 54, 6, -48]
  | 5 => #v[150, -30, -6, 120, -36, 72, 96, -60, 114, -24]
  | 6 => #v[-186, 24, -90, -216, 108, -114, -192, 114, -156, -84]
  | 7 => #v[-294, -60, 0, -162, -78, -90, -36, -48, -162, 6]
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
  | 0 => #v[0, -12, 0, -12, 0, 0, 12, 0, 0, 12]
  | 1 => #v[0, 0, -12, 12, 0, 0, 0, 0, 12, -12]
  | 2 => #v[0, -12, 0, 12, 0, 12, 0, -12, 0, 0]
  | 3 => #v[12, 12, 12, 12, 12, 12, 12, 0, 24, 24]
  | 4 => #v[-12, -12, -24, -24, -12, -12, 0, -12, -12, -12]
  | 5 => #v[-6, 0, 0, -6, 0, 6, -6, 12, -6, 6]
  | 6 => #v[0, 0, 0, -12, -6, -6, -18, -6, -6, -12]
  | 7 => #v[0, 6, 12, 6, 12, -6, 12, 6, 12, 6]
  | 8 => #v[-72, -6, 6, 0, 0, 6, -6, -6, 0, 12]
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

def KZ (k : Fin 2) : VecZ :=
  match k.val with
  | 0 => #v[0, 0, 0, -33, -33, 0, 0, -33, -33, 0]
  | 1 => #v[0, 0, 0, 0, 0, -33, -33, 0, 0, 0]
  | _ => zeroZ

def YZ (k : Fin 2) : VecZ :=
  match k.val with
  | 0 => #v[44, 0, 88, 44, 0, 44, 44, 0, 44, 88]
  | 1 => #v[0, 0, 0, 0, 44, 0, 0, 44, 0, 0]
  | _ => zeroZ

theorem xaMulZ0 :
    mulZ (XZ 0) (AZ 0) = #v[-2916, -1872, -36, -1764, -2700, -1260, -1404, -1944, -1692, -2232] := by
  decide

theorem xaMulZ1 :
    mulZ (XZ 1) (AZ 1) = #v[4284, 252, 2268, 4104, -1260, 3708, 2880, -864, 3276, 2340] := by
  decide

theorem xaMulZ2 :
    mulZ (XZ 2) (AZ 2) = #v[-828, 684, 288, -720, -648, -576, 396, 0, -1260, -108] := by
  decide

theorem xaMulZ3 :
    mulZ (XZ 3) (AZ 3) = #v[-5472, -1908, -108, -5724, -1836, -1224, -4392, -1152, -3492, -2808] := by
  decide

theorem xaMulZ4 :
    mulZ (XZ 4) (AZ 4) = #v[-144, -1404, -720, -576, -1080, -360, -108, -828, -1044, -864] := by
  decide

theorem xaMulZ5 :
    mulZ (XZ 5) (AZ 5) = #v[-4932, -1116, -720, -5616, 540, -3132, -3852, 72, -3924, -2664] := by
  decide

theorem xaMulZ6 :
    mulZ (XZ 6) (AZ 6) = #v[6048, 7272, -144, 7308, 4824, 2052, 8640, 2160, 4536, 8784] := by
  decide

theorem xaMulZ7 :
    mulZ (XZ 7) (AZ 7) = #v[-396, -1908, -828, -1368, -2196, 792, -2160, -1800, -756, -2448] := by
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
  | 0 => #v[-2916, -1872, -36, -1764, -2700, -1260, -1404, -1944, -1692, -2232]
  | 1 => #v[4284, 252, 2268, 4104, -1260, 3708, 2880, -864, 3276, 2340]
  | 2 => #v[-828, 684, 288, -720, -648, -576, 396, 0, -1260, -108]
  | 3 => #v[-5472, -1908, -108, -5724, -1836, -1224, -4392, -1152, -3492, -2808]
  | 4 => #v[-144, -1404, -720, -576, -1080, -360, -108, -828, -1044, -864]
  | 5 => #v[-4932, -1116, -720, -5616, 540, -3132, -3852, 72, -3924, -2664]
  | 6 => #v[6048, 7272, -144, 7308, 4824, 2052, 8640, 2160, 4536, 8784]
  | 7 => #v[-396, -1908, -828, -1368, -2196, 792, -2160, -1800, -756, -2448]
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
    sumFin (fun k => mulZ (XZ k) (AZ k)) = #v[-4356, 0, 0, -4356, -4356, 0, 0, -4356, -4356, 0] := by
  have h : sumFin (fun k => mulZ (XZ k) (AZ k)) =
      sumFin xaMuls := congrArg sumFin (funext xaMulZ)
  rw [h]
  decide

theorem kyMulZ0 :
    mulZ (KZ 0) (YZ 0) = #v[2904, 0, 0, 2904, 2904, -1452, -1452, 2904, 2904, 0] := by
  decide

theorem kyMulZ1 :
    mulZ (KZ 1) (YZ 1) = #v[1452, 0, 0, 1452, 1452, 1452, 1452, 1452, 1452, 0] := by
  decide

def kyMuls (k : Fin 2) : VecZ :=
  match k.val with
  | 0 => #v[2904, 0, 0, 2904, 2904, -1452, -1452, 2904, 2904, 0]
  | 1 => #v[1452, 0, 0, 1452, 1452, 1452, 1452, 1452, 1452, 0]
  | _ => zeroZ

theorem kyMulZ (k : Fin 2) :
    mulZ (KZ k) (YZ k) = kyMuls k := by
  fin_cases k
  · exact kyMulZ0
  · exact kyMulZ1

theorem kySum_eq :
    sumFin (fun k => mulZ (KZ k) (YZ k)) = #v[4356, 0, 0, 4356, 4356, 0, 0, 4356, 4356, 0] := by
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

theorem XZ_scale_0 : toVec (XZ 0) = (scale : ℚ) • XCell7_0 := by
  funext i
  fin_cases i
  · change ((-132 : ℤ) : ℚ) = (scale : ℚ) * (-2 : ℚ)
    exact eq_smul_int (-132) scale (-2) (by decide)
  · change ((33 : ℤ) : ℚ) = (scale : ℚ) * (1 / 2 : ℚ)
    exact eq_smul_div (33) scale (1) (2) (by decide) (by decide)
  · change ((-69 : ℤ) : ℚ) = (scale : ℚ) * (-23 / 22 : ℚ)
    exact eq_smul_div (-69) scale (-23) (22) (by decide) (by decide)
  · change ((-111 : ℤ) : ℚ) = (scale : ℚ) * (-37 / 22 : ℚ)
    exact eq_smul_div (-111) scale (-37) (22) (by decide) (by decide)
  · change ((102 : ℤ) : ℚ) = (scale : ℚ) * (17 / 11 : ℚ)
    exact eq_smul_div (102) scale (17) (11) (by decide) (by decide)
  · change ((-126 : ℤ) : ℚ) = (scale : ℚ) * (-21 / 11 : ℚ)
    exact eq_smul_div (-126) scale (-21) (11) (by decide) (by decide)
  · change ((-105 : ℤ) : ℚ) = (scale : ℚ) * (-35 / 22 : ℚ)
    exact eq_smul_div (-105) scale (-35) (22) (by decide) (by decide)
  · change ((63 : ℤ) : ℚ) = (scale : ℚ) * (21 / 22 : ℚ)
    exact eq_smul_div (63) scale (21) (22) (by decide) (by decide)
  · change ((-87 : ℤ) : ℚ) = (scale : ℚ) * (-29 / 22 : ℚ)
    exact eq_smul_div (-87) scale (-29) (22) (by decide) (by decide)
  · change ((-63 : ℤ) : ℚ) = (scale : ℚ) * (-21 / 22 : ℚ)
    exact eq_smul_div (-63) scale (-21) (22) (by decide) (by decide)

theorem XZ_scale_1 : toVec (XZ 1) = (scale : ℚ) • XCell7_1 := by
  funext i
  fin_cases i
  · change ((141 : ℤ) : ℚ) = (scale : ℚ) * (47 / 22 : ℚ)
    exact eq_smul_div (141) scale (47) (22) (by decide) (by decide)
  · change ((-15 : ℤ) : ℚ) = (scale : ℚ) * (-5 / 22 : ℚ)
    exact eq_smul_div (-15) scale (-5) (22) (by decide) (by decide)
  · change ((57 : ℤ) : ℚ) = (scale : ℚ) * (19 / 22 : ℚ)
    exact eq_smul_div (57) scale (19) (22) (by decide) (by decide)
  · change ((138 : ℤ) : ℚ) = (scale : ℚ) * (23 / 11 : ℚ)
    exact eq_smul_div (138) scale (23) (11) (by decide) (by decide)
  · change ((-60 : ℤ) : ℚ) = (scale : ℚ) * (-10 / 11 : ℚ)
    exact eq_smul_div (-60) scale (-10) (11) (by decide) (by decide)
  · change ((111 : ℤ) : ℚ) = (scale : ℚ) * (37 / 22 : ℚ)
    exact eq_smul_div (111) scale (37) (22) (by decide) (by decide)
  · change ((138 : ℤ) : ℚ) = (scale : ℚ) * (23 / 11 : ℚ)
    exact eq_smul_div (138) scale (23) (11) (by decide) (by decide)
  · change ((-54 : ℤ) : ℚ) = (scale : ℚ) * (-9 / 11 : ℚ)
    exact eq_smul_div (-54) scale (-9) (11) (by decide) (by decide)
  · change ((177 : ℤ) : ℚ) = (scale : ℚ) * (59 / 22 : ℚ)
    exact eq_smul_div (177) scale (59) (22) (by decide) (by decide)
  · change ((60 : ℤ) : ℚ) = (scale : ℚ) * (10 / 11 : ℚ)
    exact eq_smul_div (60) scale (10) (11) (by decide) (by decide)

theorem XZ_scale_2 : toVec (XZ 2) = (scale : ℚ) • XCell7_2 := by
  funext i
  fin_cases i
  · change ((15 : ℤ) : ℚ) = (scale : ℚ) * (5 / 22 : ℚ)
    exact eq_smul_div (15) scale (5) (22) (by decide) (by decide)
  · change ((-3 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 22 : ℚ)
    exact eq_smul_div (-3) scale (-1) (22) (by decide) (by decide)
  · change ((-24 : ℤ) : ℚ) = (scale : ℚ) * (-4 / 11 : ℚ)
    exact eq_smul_div (-24) scale (-4) (11) (by decide) (by decide)
  · change ((18 : ℤ) : ℚ) = (scale : ℚ) * (3 / 11 : ℚ)
    exact eq_smul_div (18) scale (3) (11) (by decide) (by decide)
  · change ((30 : ℤ) : ℚ) = (scale : ℚ) * (5 / 11 : ℚ)
    exact eq_smul_div (30) scale (5) (11) (by decide) (by decide)
  · change ((-39 : ℤ) : ℚ) = (scale : ℚ) * (-13 / 22 : ℚ)
    exact eq_smul_div (-39) scale (-13) (22) (by decide) (by decide)
  · change ((-30 : ℤ) : ℚ) = (scale : ℚ) * (-5 / 11 : ℚ)
    exact eq_smul_div (-30) scale (-5) (11) (by decide) (by decide)
  · change ((66 : ℤ) : ℚ) = (scale : ℚ) * (1 : ℚ)
    exact eq_smul_int (66) scale (1) (by decide)
  · change ((12 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (12) scale (2) (11) (by decide) (by decide)
  · change ((-12 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-12) scale (-2) (11) (by decide) (by decide)

theorem XZ_scale_3 : toVec (XZ 3) = (scale : ℚ) • XCell7_3 := by
  funext i
  fin_cases i
  · change ((-96 : ℤ) : ℚ) = (scale : ℚ) * (-16 / 11 : ℚ)
    exact eq_smul_div (-96) scale (-16) (11) (by decide) (by decide)
  · change ((39 : ℤ) : ℚ) = (scale : ℚ) * (13 / 22 : ℚ)
    exact eq_smul_div (39) scale (13) (22) (by decide) (by decide)
  · change ((-36 : ℤ) : ℚ) = (scale : ℚ) * (-6 / 11 : ℚ)
    exact eq_smul_div (-36) scale (-6) (11) (by decide) (by decide)
  · change ((-114 : ℤ) : ℚ) = (scale : ℚ) * (-19 / 11 : ℚ)
    exact eq_smul_div (-114) scale (-19) (11) (by decide) (by decide)
  · change ((54 : ℤ) : ℚ) = (scale : ℚ) * (9 / 11 : ℚ)
    exact eq_smul_div (54) scale (9) (11) (by decide) (by decide)
  · change ((-78 : ℤ) : ℚ) = (scale : ℚ) * (-13 / 11 : ℚ)
    exact eq_smul_div (-78) scale (-13) (11) (by decide) (by decide)
  · change ((-114 : ℤ) : ℚ) = (scale : ℚ) * (-19 / 11 : ℚ)
    exact eq_smul_div (-114) scale (-19) (11) (by decide) (by decide)
  · change ((18 : ℤ) : ℚ) = (scale : ℚ) * (3 / 11 : ℚ)
    exact eq_smul_div (18) scale (3) (11) (by decide) (by decide)
  · change ((-78 : ℤ) : ℚ) = (scale : ℚ) * (-13 / 11 : ℚ)
    exact eq_smul_div (-78) scale (-13) (11) (by decide) (by decide)
  · change ((-57 : ℤ) : ℚ) = (scale : ℚ) * (-19 / 22 : ℚ)
    exact eq_smul_div (-57) scale (-19) (22) (by decide) (by decide)

theorem XZ_scale_4 : toVec (XZ 4) = (scale : ℚ) • XCell7_4 := by
  funext i
  fin_cases i
  · change ((45 : ℤ) : ℚ) = (scale : ℚ) * (15 / 22 : ℚ)
    exact eq_smul_div (45) scale (15) (22) (by decide) (by decide)
  · change ((24 : ℤ) : ℚ) = (scale : ℚ) * (4 / 11 : ℚ)
    exact eq_smul_div (24) scale (4) (11) (by decide) (by decide)
  · change ((-60 : ℤ) : ℚ) = (scale : ℚ) * (-10 / 11 : ℚ)
    exact eq_smul_div (-60) scale (-10) (11) (by decide) (by decide)
  · change ((-15 : ℤ) : ℚ) = (scale : ℚ) * (-5 / 22 : ℚ)
    exact eq_smul_div (-15) scale (-5) (22) (by decide) (by decide)
  · change ((69 : ℤ) : ℚ) = (scale : ℚ) * (23 / 22 : ℚ)
    exact eq_smul_div (69) scale (23) (22) (by decide) (by decide)
  · change ((-24 : ℤ) : ℚ) = (scale : ℚ) * (-4 / 11 : ℚ)
    exact eq_smul_div (-24) scale (-4) (11) (by decide) (by decide)
  · change ((-51 : ℤ) : ℚ) = (scale : ℚ) * (-17 / 22 : ℚ)
    exact eq_smul_div (-51) scale (-17) (22) (by decide) (by decide)
  · change ((54 : ℤ) : ℚ) = (scale : ℚ) * (9 / 11 : ℚ)
    exact eq_smul_div (54) scale (9) (11) (by decide) (by decide)
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (6) scale (1) (11) (by decide) (by decide)
  · change ((-48 : ℤ) : ℚ) = (scale : ℚ) * (-8 / 11 : ℚ)
    exact eq_smul_div (-48) scale (-8) (11) (by decide) (by decide)

theorem XZ_scale_5 : toVec (XZ 5) = (scale : ℚ) • XCell7_5 := by
  funext i
  fin_cases i
  · change ((150 : ℤ) : ℚ) = (scale : ℚ) * (25 / 11 : ℚ)
    exact eq_smul_div (150) scale (25) (11) (by decide) (by decide)
  · change ((-30 : ℤ) : ℚ) = (scale : ℚ) * (-5 / 11 : ℚ)
    exact eq_smul_div (-30) scale (-5) (11) (by decide) (by decide)
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-6) scale (-1) (11) (by decide) (by decide)
  · change ((120 : ℤ) : ℚ) = (scale : ℚ) * (20 / 11 : ℚ)
    exact eq_smul_div (120) scale (20) (11) (by decide) (by decide)
  · change ((-36 : ℤ) : ℚ) = (scale : ℚ) * (-6 / 11 : ℚ)
    exact eq_smul_div (-36) scale (-6) (11) (by decide) (by decide)
  · change ((72 : ℤ) : ℚ) = (scale : ℚ) * (12 / 11 : ℚ)
    exact eq_smul_div (72) scale (12) (11) (by decide) (by decide)
  · change ((96 : ℤ) : ℚ) = (scale : ℚ) * (16 / 11 : ℚ)
    exact eq_smul_div (96) scale (16) (11) (by decide) (by decide)
  · change ((-60 : ℤ) : ℚ) = (scale : ℚ) * (-10 / 11 : ℚ)
    exact eq_smul_div (-60) scale (-10) (11) (by decide) (by decide)
  · change ((114 : ℤ) : ℚ) = (scale : ℚ) * (19 / 11 : ℚ)
    exact eq_smul_div (114) scale (19) (11) (by decide) (by decide)
  · change ((-24 : ℤ) : ℚ) = (scale : ℚ) * (-4 / 11 : ℚ)
    exact eq_smul_div (-24) scale (-4) (11) (by decide) (by decide)

theorem XZ_scale_6 : toVec (XZ 6) = (scale : ℚ) • XCell7_6 := by
  funext i
  fin_cases i
  · change ((-186 : ℤ) : ℚ) = (scale : ℚ) * (-31 / 11 : ℚ)
    exact eq_smul_div (-186) scale (-31) (11) (by decide) (by decide)
  · change ((24 : ℤ) : ℚ) = (scale : ℚ) * (4 / 11 : ℚ)
    exact eq_smul_div (24) scale (4) (11) (by decide) (by decide)
  · change ((-90 : ℤ) : ℚ) = (scale : ℚ) * (-15 / 11 : ℚ)
    exact eq_smul_div (-90) scale (-15) (11) (by decide) (by decide)
  · change ((-216 : ℤ) : ℚ) = (scale : ℚ) * (-36 / 11 : ℚ)
    exact eq_smul_div (-216) scale (-36) (11) (by decide) (by decide)
  · change ((108 : ℤ) : ℚ) = (scale : ℚ) * (18 / 11 : ℚ)
    exact eq_smul_div (108) scale (18) (11) (by decide) (by decide)
  · change ((-114 : ℤ) : ℚ) = (scale : ℚ) * (-19 / 11 : ℚ)
    exact eq_smul_div (-114) scale (-19) (11) (by decide) (by decide)
  · change ((-192 : ℤ) : ℚ) = (scale : ℚ) * (-32 / 11 : ℚ)
    exact eq_smul_div (-192) scale (-32) (11) (by decide) (by decide)
  · change ((114 : ℤ) : ℚ) = (scale : ℚ) * (19 / 11 : ℚ)
    exact eq_smul_div (114) scale (19) (11) (by decide) (by decide)
  · change ((-156 : ℤ) : ℚ) = (scale : ℚ) * (-26 / 11 : ℚ)
    exact eq_smul_div (-156) scale (-26) (11) (by decide) (by decide)
  · change ((-84 : ℤ) : ℚ) = (scale : ℚ) * (-14 / 11 : ℚ)
    exact eq_smul_div (-84) scale (-14) (11) (by decide) (by decide)

theorem XZ_scale_7 : toVec (XZ 7) = (scale : ℚ) • XCell7_7 := by
  funext i
  fin_cases i
  · change ((-294 : ℤ) : ℚ) = (scale : ℚ) * (-49 / 11 : ℚ)
    exact eq_smul_div (-294) scale (-49) (11) (by decide) (by decide)
  · change ((-60 : ℤ) : ℚ) = (scale : ℚ) * (-10 / 11 : ℚ)
    exact eq_smul_div (-60) scale (-10) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-162 : ℤ) : ℚ) = (scale : ℚ) * (-27 / 11 : ℚ)
    exact eq_smul_div (-162) scale (-27) (11) (by decide) (by decide)
  · change ((-78 : ℤ) : ℚ) = (scale : ℚ) * (-13 / 11 : ℚ)
    exact eq_smul_div (-78) scale (-13) (11) (by decide) (by decide)
  · change ((-90 : ℤ) : ℚ) = (scale : ℚ) * (-15 / 11 : ℚ)
    exact eq_smul_div (-90) scale (-15) (11) (by decide) (by decide)
  · change ((-36 : ℤ) : ℚ) = (scale : ℚ) * (-6 / 11 : ℚ)
    exact eq_smul_div (-36) scale (-6) (11) (by decide) (by decide)
  · change ((-48 : ℤ) : ℚ) = (scale : ℚ) * (-8 / 11 : ℚ)
    exact eq_smul_div (-48) scale (-8) (11) (by decide) (by decide)
  · change ((-162 : ℤ) : ℚ) = (scale : ℚ) * (-27 / 11 : ℚ)
    exact eq_smul_div (-162) scale (-27) (11) (by decide) (by decide)
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (6) scale (1) (11) (by decide) (by decide)

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
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
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
  · change ((-12 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-12) scale (-2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-12 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-12) scale (-2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((12 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (12) scale (2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((12 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (12) scale (2) (11) (by decide) (by decide)

theorem AZ_scale_1 : toVec (AZ 1) = (scale : ℚ) • ACell1_8 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-12 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-12) scale (-2) (11) (by decide) (by decide)
  · change ((12 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (12) scale (2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((12 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (12) scale (2) (11) (by decide) (by decide)
  · change ((-12 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-12) scale (-2) (11) (by decide) (by decide)

theorem AZ_scale_2 : toVec (AZ 2) = (scale : ℚ) • ACell2_8 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-12 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-12) scale (-2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((12 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (12) scale (2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((12 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (12) scale (2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-12 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-12) scale (-2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem AZ_scale_3 : toVec (AZ 3) = (scale : ℚ) • ACell3_8 := by
  funext i
  fin_cases i
  · change ((12 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (12) scale (2) (11) (by decide) (by decide)
  · change ((12 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (12) scale (2) (11) (by decide) (by decide)
  · change ((12 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (12) scale (2) (11) (by decide) (by decide)
  · change ((12 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (12) scale (2) (11) (by decide) (by decide)
  · change ((12 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (12) scale (2) (11) (by decide) (by decide)
  · change ((12 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (12) scale (2) (11) (by decide) (by decide)
  · change ((12 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (12) scale (2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((24 : ℤ) : ℚ) = (scale : ℚ) * (4 / 11 : ℚ)
    exact eq_smul_div (24) scale (4) (11) (by decide) (by decide)
  · change ((24 : ℤ) : ℚ) = (scale : ℚ) * (4 / 11 : ℚ)
    exact eq_smul_div (24) scale (4) (11) (by decide) (by decide)

theorem AZ_scale_4 : toVec (AZ 4) = (scale : ℚ) • ACell4_8 := by
  funext i
  fin_cases i
  · change ((-12 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-12) scale (-2) (11) (by decide) (by decide)
  · change ((-12 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-12) scale (-2) (11) (by decide) (by decide)
  · change ((-24 : ℤ) : ℚ) = (scale : ℚ) * (-4 / 11 : ℚ)
    exact eq_smul_div (-24) scale (-4) (11) (by decide) (by decide)
  · change ((-24 : ℤ) : ℚ) = (scale : ℚ) * (-4 / 11 : ℚ)
    exact eq_smul_div (-24) scale (-4) (11) (by decide) (by decide)
  · change ((-12 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-12) scale (-2) (11) (by decide) (by decide)
  · change ((-12 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-12) scale (-2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-12 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-12) scale (-2) (11) (by decide) (by decide)
  · change ((-12 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-12) scale (-2) (11) (by decide) (by decide)
  · change ((-12 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-12) scale (-2) (11) (by decide) (by decide)

theorem AZ_scale_5 : toVec (AZ 5) = (scale : ℚ) • ACell5_8 := by
  funext i
  fin_cases i
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-6) scale (-1) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-6) scale (-1) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (6) scale (1) (11) (by decide) (by decide)
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-6) scale (-1) (11) (by decide) (by decide)
  · change ((12 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (12) scale (2) (11) (by decide) (by decide)
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-6) scale (-1) (11) (by decide) (by decide)
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (6) scale (1) (11) (by decide) (by decide)

theorem AZ_scale_6 : toVec (AZ 6) = (scale : ℚ) • ACell6_8 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-12 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-12) scale (-2) (11) (by decide) (by decide)
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-6) scale (-1) (11) (by decide) (by decide)
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-6) scale (-1) (11) (by decide) (by decide)
  · change ((-18 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 11 : ℚ)
    exact eq_smul_div (-18) scale (-3) (11) (by decide) (by decide)
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-6) scale (-1) (11) (by decide) (by decide)
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-6) scale (-1) (11) (by decide) (by decide)
  · change ((-12 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-12) scale (-2) (11) (by decide) (by decide)

theorem AZ_scale_7 : toVec (AZ 7) = (scale : ℚ) • ACell7_8 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (6) scale (1) (11) (by decide) (by decide)
  · change ((12 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (12) scale (2) (11) (by decide) (by decide)
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (6) scale (1) (11) (by decide) (by decide)
  · change ((12 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (12) scale (2) (11) (by decide) (by decide)
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-6) scale (-1) (11) (by decide) (by decide)
  · change ((12 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (12) scale (2) (11) (by decide) (by decide)
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (6) scale (1) (11) (by decide) (by decide)
  · change ((12 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (12) scale (2) (11) (by decide) (by decide)
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (6) scale (1) (11) (by decide) (by decide)

theorem AZ_scale_8 : toVec (AZ 8) = (scale : ℚ) • ACell8_8 := by
  funext i
  fin_cases i
  · change ((-72 : ℤ) : ℚ) = (scale : ℚ) * (-12 / 11 : ℚ)
    exact eq_smul_div (-72) scale (-12) (11) (by decide) (by decide)
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-6) scale (-1) (11) (by decide) (by decide)
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (6) scale (1) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (6) scale (1) (11) (by decide) (by decide)
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-6) scale (-1) (11) (by decide) (by decide)
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-6) scale (-1) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((12 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (12) scale (2) (11) (by decide) (by decide)

theorem AZ_scale_9 : toVec (AZ 9) = (scale : ℚ) • ACell9_8 := by
  funext i
  fin_cases i
  · change ((-12 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-12) scale (-2) (11) (by decide) (by decide)
  · change ((-18 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 11 : ℚ)
    exact eq_smul_div (-18) scale (-3) (11) (by decide) (by decide)
  · change ((-12 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-12) scale (-2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-6) scale (-1) (11) (by decide) (by decide)
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-6) scale (-1) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-6) scale (-1) (11) (by decide) (by decide)
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-6) scale (-1) (11) (by decide) (by decide)

theorem AZ_scale_10 : toVec (AZ 10) = (scale : ℚ) • ACell10_8 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-12 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-12) scale (-2) (11) (by decide) (by decide)
  · change ((12 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (12) scale (2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((12 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (12) scale (2) (11) (by decide) (by decide)
  · change ((-12 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-12) scale (-2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem AZ_scale_11 : toVec (AZ 11) = (scale : ℚ) • ACell11_8 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-24 : ℤ) : ℚ) = (scale : ℚ) * (-4 / 11 : ℚ)
    exact eq_smul_div (-24) scale (-4) (11) (by decide) (by decide)
  · change ((-12 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-12) scale (-2) (11) (by decide) (by decide)
  · change ((-12 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-12) scale (-2) (11) (by decide) (by decide)
  · change ((-12 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-12) scale (-2) (11) (by decide) (by decide)
  · change ((-12 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-12) scale (-2) (11) (by decide) (by decide)
  · change ((-12 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-12) scale (-2) (11) (by decide) (by decide)
  · change ((-12 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-12) scale (-2) (11) (by decide) (by decide)
  · change ((-12 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-12) scale (-2) (11) (by decide) (by decide)
  · change ((-24 : ℤ) : ℚ) = (scale : ℚ) * (-4 / 11 : ℚ)
    exact eq_smul_div (-24) scale (-4) (11) (by decide) (by decide)

theorem AZ_scale_12 : toVec (AZ 12) = (scale : ℚ) • ACell12_8 := by
  funext i
  fin_cases i
  · change ((12 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (12) scale (2) (11) (by decide) (by decide)
  · change ((12 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (12) scale (2) (11) (by decide) (by decide)
  · change ((24 : ℤ) : ℚ) = (scale : ℚ) * (4 / 11 : ℚ)
    exact eq_smul_div (24) scale (4) (11) (by decide) (by decide)
  · change ((12 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (12) scale (2) (11) (by decide) (by decide)
  · change ((12 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (12) scale (2) (11) (by decide) (by decide)
  · change ((12 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (12) scale (2) (11) (by decide) (by decide)
  · change ((24 : ℤ) : ℚ) = (scale : ℚ) * (4 / 11 : ℚ)
    exact eq_smul_div (24) scale (4) (11) (by decide) (by decide)
  · change ((12 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (12) scale (2) (11) (by decide) (by decide)
  · change ((12 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (12) scale (2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem AZ_scale_13 : toVec (AZ 13) = (scale : ℚ) • ACell13_8 := by
  funext i
  fin_cases i
  · change ((12 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (12) scale (2) (11) (by decide) (by decide)
  · change ((12 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (12) scale (2) (11) (by decide) (by decide)
  · change ((12 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (12) scale (2) (11) (by decide) (by decide)
  · change ((12 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (12) scale (2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((12 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (12) scale (2) (11) (by decide) (by decide)
  · change ((24 : ℤ) : ℚ) = (scale : ℚ) * (4 / 11 : ℚ)
    exact eq_smul_div (24) scale (4) (11) (by decide) (by decide)
  · change ((12 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (12) scale (2) (11) (by decide) (by decide)
  · change ((24 : ℤ) : ℚ) = (scale : ℚ) * (4 / 11 : ℚ)
    exact eq_smul_div (24) scale (4) (11) (by decide) (by decide)
  · change ((12 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (12) scale (2) (11) (by decide) (by decide)

theorem AZ_scale_14 : toVec (AZ 14) = (scale : ℚ) • ACell14_8 := by
  funext i
  fin_cases i
  · change ((-12 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-12) scale (-2) (11) (by decide) (by decide)
  · change ((-12 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-12) scale (-2) (11) (by decide) (by decide)
  · change ((-24 : ℤ) : ℚ) = (scale : ℚ) * (-4 / 11 : ℚ)
    exact eq_smul_div (-24) scale (-4) (11) (by decide) (by decide)
  · change ((-12 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-12) scale (-2) (11) (by decide) (by decide)
  · change ((-24 : ℤ) : ℚ) = (scale : ℚ) * (-4 / 11 : ℚ)
    exact eq_smul_div (-24) scale (-4) (11) (by decide) (by decide)
  · change ((-12 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-12) scale (-2) (11) (by decide) (by decide)
  · change ((-12 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-12) scale (-2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-12 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-12) scale (-2) (11) (by decide) (by decide)
  · change ((-12 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-12) scale (-2) (11) (by decide) (by decide)

theorem AZ_scale_15 : toVec (AZ 15) = (scale : ℚ) • ACell15_8 := by
  funext i
  fin_cases i
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-6) scale (-1) (11) (by decide) (by decide)
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-6) scale (-1) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-12 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-12) scale (-2) (11) (by decide) (by decide)
  · change ((-12 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-12) scale (-2) (11) (by decide) (by decide)
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-6) scale (-1) (11) (by decide) (by decide)
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (6) scale (1) (11) (by decide) (by decide)
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-6) scale (-1) (11) (by decide) (by decide)
  · change ((-12 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-12) scale (-2) (11) (by decide) (by decide)
  · change ((-12 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-12) scale (-2) (11) (by decide) (by decide)

theorem AZ_scale_16 : toVec (AZ 16) = (scale : ℚ) • ACell16_8 := by
  funext i
  fin_cases i
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-6) scale (-1) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-6) scale (-1) (11) (by decide) (by decide)
  · change ((-12 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-12) scale (-2) (11) (by decide) (by decide)
  · change ((-12 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-12) scale (-2) (11) (by decide) (by decide)
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-6) scale (-1) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-6) scale (-1) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-18 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 11 : ℚ)
    exact eq_smul_div (-18) scale (-3) (11) (by decide) (by decide)

theorem AZ_scale_17 : toVec (AZ 17) = (scale : ℚ) • ACell17_8 := by
  funext i
  fin_cases i
  · change ((-12 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-12) scale (-2) (11) (by decide) (by decide)
  · change ((-18 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 11 : ℚ)
    exact eq_smul_div (-18) scale (-3) (11) (by decide) (by decide)
  · change ((-12 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-12) scale (-2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-6) scale (-1) (11) (by decide) (by decide)
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-6) scale (-1) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-6) scale (-1) (11) (by decide) (by decide)
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-6) scale (-1) (11) (by decide) (by decide)

theorem AZ_scale_18 : toVec (AZ 18) = (scale : ℚ) • ACell18_8 := by
  funext i
  fin_cases i
  · change ((-54 : ℤ) : ℚ) = (scale : ℚ) * (-9 / 11 : ℚ)
    exact eq_smul_div (-54) scale (-9) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (6) scale (1) (11) (by decide) (by decide)
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-6) scale (-1) (11) (by decide) (by decide)
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-6) scale (-1) (11) (by decide) (by decide)
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-6) scale (-1) (11) (by decide) (by decide)
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-6) scale (-1) (11) (by decide) (by decide)
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (6) scale (1) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem AZ_scale_19 : toVec (AZ 19) = (scale : ℚ) • ACell19_8 := by
  funext i
  fin_cases i
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-6) scale (-1) (11) (by decide) (by decide)
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (6) scale (1) (11) (by decide) (by decide)
  · change ((-12 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-12) scale (-2) (11) (by decide) (by decide)
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (6) scale (1) (11) (by decide) (by decide)
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-6) scale (-1) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (6) scale (1) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (6) scale (1) (11) (by decide) (by decide)

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
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-33 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 2 : ℚ)
    exact eq_smul_div (-33) scale (-1) (2) (by decide) (by decide)
  · change ((-33 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 2 : ℚ)
    exact eq_smul_div (-33) scale (-1) (2) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-33 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 2 : ℚ)
    exact eq_smul_div (-33) scale (-1) (2) (by decide) (by decide)
  · change ((-33 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 2 : ℚ)
    exact eq_smul_div (-33) scale (-1) (2) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem KZ_scale_1 : toVec (KZ 1) = (scale : ℚ) • KCell7_1 := by
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
  · change ((-33 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 2 : ℚ)
    exact eq_smul_div (-33) scale (-1) (2) (by decide) (by decide)
  · change ((-33 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 2 : ℚ)
    exact eq_smul_div (-33) scale (-1) (2) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem KZ_scale (k : Fin 2) :
    toVec (KZ k) = (scale : ℚ) • KVec (7 : Fin 10) k := by
  fin_cases k
  · simp [KVec, KRow0]; exact KZ_scale_0
  · simp [KVec, KRow1]; exact KZ_scale_1

theorem YZ_scale_0 : toVec (YZ 0) = (scale : ℚ) • YCell0_8 := by
  funext i
  fin_cases i
  · change ((44 : ℤ) : ℚ) = (scale : ℚ) * (2 / 3 : ℚ)
    exact eq_smul_div (44) scale (2) (3) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((88 : ℤ) : ℚ) = (scale : ℚ) * (4 / 3 : ℚ)
    exact eq_smul_div (88) scale (4) (3) (by decide) (by decide)
  · change ((44 : ℤ) : ℚ) = (scale : ℚ) * (2 / 3 : ℚ)
    exact eq_smul_div (44) scale (2) (3) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((44 : ℤ) : ℚ) = (scale : ℚ) * (2 / 3 : ℚ)
    exact eq_smul_div (44) scale (2) (3) (by decide) (by decide)
  · change ((44 : ℤ) : ℚ) = (scale : ℚ) * (2 / 3 : ℚ)
    exact eq_smul_div (44) scale (2) (3) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((44 : ℤ) : ℚ) = (scale : ℚ) * (2 / 3 : ℚ)
    exact eq_smul_div (44) scale (2) (3) (by decide) (by decide)
  · change ((88 : ℤ) : ℚ) = (scale : ℚ) * (4 / 3 : ℚ)
    exact eq_smul_div (88) scale (4) (3) (by decide) (by decide)

theorem YZ_scale_1 : toVec (YZ 1) = (scale : ℚ) • YCell1_8 := by
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
  · change ((44 : ℤ) : ℚ) = (scale : ℚ) * (2 / 3 : ℚ)
    exact eq_smul_div (44) scale (2) (3) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((44 : ℤ) : ℚ) = (scale : ℚ) * (2 / 3 : ℚ)
    exact eq_smul_div (44) scale (2) (3) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem YZ_scale (k : Fin 2) :
    toVec (YZ k) = (scale : ℚ) • YVec k (8 : Fin 10) := by
  fin_cases k
  · simp [YVec, YRow0]; exact YZ_scale_0
  · simp [YVec, YRow1]; exact YZ_scale_1

theorem entry_eq :
    (matrixMul XVec AVec + matrixMul KVec YVec)
        (7 : Fin 10) (8 : Fin 10) = ![0, 0, 0, 0, 0, 0, 0, 0, 0, 0] := by
  change (∑ k : Fin 20, mul (XVec (7 : Fin 10) k)
      (AVec k (8 : Fin 10))) +
    (∑ k : Fin 2, mul (KVec (7 : Fin 10) k)
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

end V14Formalization.D12PiecePPSplitEntry7_8
