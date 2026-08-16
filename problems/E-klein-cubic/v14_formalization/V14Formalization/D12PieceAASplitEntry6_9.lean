/- AA split identity entry (6,9). Auto-generated. -/
import V14Formalization.D12PieceAAData
import V14Formalization.D12CyclotomicVecZ

noncomputable section
open Matrix
namespace V14Formalization.D12PieceAASplitEntry6_9
open D12CyclotomicVec D12CyclotomicVecZ D12PieceAAData
def payloadSha256 : String := "76c6196f29afe1a8398af99502447f48ebeed4bcb3805fc5dbec693940bc04b0"

def scale : ℤ := 132

def XZ (k : Fin 20) : VecZ :=
  match k.val with
  | 0 => #v[-207, -219, -276, -63, -171, -225, -213, -165, -129, -246]
  | 1 => #v[-72, -69, -15, 0, -30, -42, -84, -33, 27, -78]
  | 2 => #v[321, 60, 336, 66, 204, 225, 153, 213, -12, 381]
  | 3 => #v[-153, 75, -15, -30, -66, -45, 24, -117, 51, -87]
  | 4 => #v[48, 36, -3, 57, 12, -6, 15, 39, -12, 12]
  | 5 => #v[222, -96, 60, 66, 126, 42, -36, 150, -66, 60]
  | 6 => #v[-66, -24, -102, 30, -78, -156, -90, -72, -24, -210]
  | 7 => #v[300, -210, 204, 24, 132, 90, -36, 234, -78, 198]
  | 8 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  | 9 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  | 10 => #v[99, 99, 99, 33, 33, 66, 132, 99, 66, 0]
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
  | 0 => #v[0, -132, -66, 0, 66, 0, -66, -66, 0, 66]
  | _ => zeroZ

def YZ (k : Fin 1) : VecZ :=
  match k.val with
  | 0 => #v[-88, 88, 0, -88, 0, 88, 88, -88, 88, 88]
  | _ => zeroZ

theorem xaMulZ0 :
    mulZ (XZ 0) (AZ 0) = #v[2448, 4608, 0, -6768, 792, 1152, 2088, 1872, 1152, -1800] := by
  decide

theorem xaMulZ1 :
    mulZ (XZ 1) (AZ 1) = #v[792, 936, -1584, -1656, -3672, 1440, 576, -360, -1800, -4176] := by
  decide

theorem xaMulZ2 :
    mulZ (XZ 2) (AZ 2) = #v[9720, 3456, -1584, 14184, -4896, 12240, -7488, 20448, -7920, 11736] := by
  decide

theorem xaMulZ3 :
    mulZ (XZ 3) (AZ 3) = #v[-1368, -4176, 5544, -5760, 2016, -6264, 5544, -4824, 1944, 216] := by
  decide

theorem xaMulZ4 :
    mulZ (XZ 4) (AZ 4) = #v[-576, -3312, -1584, -648, -1008, -1584, -3672, 144, -1728, -3456] := by
  decide

theorem xaMulZ5 :
    mulZ (XZ 5) (AZ 5) = #v[13104, 4248, 9504, 4752, 3888, 9720, 3672, 12312, 432, 10440] := by
  decide

theorem xaMulZ6 :
    mulZ (XZ 6) (AZ 6) = #v[-4608, -2376, -5544, -3384, -3384, -8280, -1008, -7272, -504, -7200] := by
  decide

theorem xaMulZ7 :
    mulZ (XZ 7) (AZ 7) = #v[1080, 2952, -3168, -2304, 3888, -7632, 4248, -2520, 6840, -9720] := by
  decide

theorem xaMulZ8 :
    mulZ (XZ 8) (AZ 8) = #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0] := by
  decide

theorem xaMulZ9 :
    mulZ (XZ 9) (AZ 9) = #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0] := by
  decide

theorem xaMulZ10 :
    mulZ (XZ 10) (AZ 10) = #v[-3168, -6336, -1584, 1584, 2376, -792, -3960, -2376, 1584, 3960] := by
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
  | 0 => #v[2448, 4608, 0, -6768, 792, 1152, 2088, 1872, 1152, -1800]
  | 1 => #v[792, 936, -1584, -1656, -3672, 1440, 576, -360, -1800, -4176]
  | 2 => #v[9720, 3456, -1584, 14184, -4896, 12240, -7488, 20448, -7920, 11736]
  | 3 => #v[-1368, -4176, 5544, -5760, 2016, -6264, 5544, -4824, 1944, 216]
  | 4 => #v[-576, -3312, -1584, -648, -1008, -1584, -3672, 144, -1728, -3456]
  | 5 => #v[13104, 4248, 9504, 4752, 3888, 9720, 3672, 12312, 432, 10440]
  | 6 => #v[-4608, -2376, -5544, -3384, -3384, -8280, -1008, -7272, -504, -7200]
  | 7 => #v[1080, 2952, -3168, -2304, 3888, -7632, 4248, -2520, 6840, -9720]
  | 8 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  | 9 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  | 10 => #v[-3168, -6336, -1584, 1584, 2376, -792, -3960, -2376, 1584, 3960]
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
    sumFin (fun k => mulZ (XZ k) (AZ k)) = #v[17424, 0, 0, 0, 0, 0, 0, 17424, 0, 0] := by
  have h : sumFin (fun k => mulZ (XZ k) (AZ k)) =
      sumFin xaMuls := congrArg sumFin (funext xaMulZ)
  rw [h]
  decide

theorem kyMulZ0 :
    mulZ (KZ 0) (YZ 0) = #v[-17424, 0, 0, 0, 0, 0, 0, -17424, 0, 0] := by
  decide

def kyMuls (k : Fin 1) : VecZ :=
  match k.val with
  | 0 => #v[-17424, 0, 0, 0, 0, 0, 0, -17424, 0, 0]
  | _ => zeroZ

theorem kyMulZ (k : Fin 1) :
    mulZ (KZ k) (YZ k) = kyMuls k := by
  fin_cases k
  · exact kyMulZ0

theorem kySum_eq :
    sumFin (fun k => mulZ (KZ k) (YZ k)) = #v[-17424, 0, 0, 0, 0, 0, 0, -17424, 0, 0] := by
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

theorem XZ_scale_0 : toVec (XZ 0) = (scale : ℚ) • XCell6_0 := by
  funext i
  fin_cases i
  · change ((-207 : ℤ) : ℚ) = (scale : ℚ) * (-69 / 44 : ℚ)
    exact eq_smul_div (-207) scale (-69) (44) (by decide) (by decide)
  · change ((-219 : ℤ) : ℚ) = (scale : ℚ) * (-73 / 44 : ℚ)
    exact eq_smul_div (-219) scale (-73) (44) (by decide) (by decide)
  · change ((-276 : ℤ) : ℚ) = (scale : ℚ) * (-23 / 11 : ℚ)
    exact eq_smul_div (-276) scale (-23) (11) (by decide) (by decide)
  · change ((-63 : ℤ) : ℚ) = (scale : ℚ) * (-21 / 44 : ℚ)
    exact eq_smul_div (-63) scale (-21) (44) (by decide) (by decide)
  · change ((-171 : ℤ) : ℚ) = (scale : ℚ) * (-57 / 44 : ℚ)
    exact eq_smul_div (-171) scale (-57) (44) (by decide) (by decide)
  · change ((-225 : ℤ) : ℚ) = (scale : ℚ) * (-75 / 44 : ℚ)
    exact eq_smul_div (-225) scale (-75) (44) (by decide) (by decide)
  · change ((-213 : ℤ) : ℚ) = (scale : ℚ) * (-71 / 44 : ℚ)
    exact eq_smul_div (-213) scale (-71) (44) (by decide) (by decide)
  · change ((-165 : ℤ) : ℚ) = (scale : ℚ) * (-5 / 4 : ℚ)
    exact eq_smul_div (-165) scale (-5) (4) (by decide) (by decide)
  · change ((-129 : ℤ) : ℚ) = (scale : ℚ) * (-43 / 44 : ℚ)
    exact eq_smul_div (-129) scale (-43) (44) (by decide) (by decide)
  · change ((-246 : ℤ) : ℚ) = (scale : ℚ) * (-41 / 22 : ℚ)
    exact eq_smul_div (-246) scale (-41) (22) (by decide) (by decide)

theorem XZ_scale_1 : toVec (XZ 1) = (scale : ℚ) • XCell6_1 := by
  funext i
  fin_cases i
  · change ((-72 : ℤ) : ℚ) = (scale : ℚ) * (-6 / 11 : ℚ)
    exact eq_smul_div (-72) scale (-6) (11) (by decide) (by decide)
  · change ((-69 : ℤ) : ℚ) = (scale : ℚ) * (-23 / 44 : ℚ)
    exact eq_smul_div (-69) scale (-23) (44) (by decide) (by decide)
  · change ((-15 : ℤ) : ℚ) = (scale : ℚ) * (-5 / 44 : ℚ)
    exact eq_smul_div (-15) scale (-5) (44) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-30 : ℤ) : ℚ) = (scale : ℚ) * (-5 / 22 : ℚ)
    exact eq_smul_div (-30) scale (-5) (22) (by decide) (by decide)
  · change ((-42 : ℤ) : ℚ) = (scale : ℚ) * (-7 / 22 : ℚ)
    exact eq_smul_div (-42) scale (-7) (22) (by decide) (by decide)
  · change ((-84 : ℤ) : ℚ) = (scale : ℚ) * (-7 / 11 : ℚ)
    exact eq_smul_div (-84) scale (-7) (11) (by decide) (by decide)
  · change ((-33 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 4 : ℚ)
    exact eq_smul_div (-33) scale (-1) (4) (by decide) (by decide)
  · change ((27 : ℤ) : ℚ) = (scale : ℚ) * (9 / 44 : ℚ)
    exact eq_smul_div (27) scale (9) (44) (by decide) (by decide)
  · change ((-78 : ℤ) : ℚ) = (scale : ℚ) * (-13 / 22 : ℚ)
    exact eq_smul_div (-78) scale (-13) (22) (by decide) (by decide)

theorem XZ_scale_2 : toVec (XZ 2) = (scale : ℚ) • XCell6_2 := by
  funext i
  fin_cases i
  · change ((321 : ℤ) : ℚ) = (scale : ℚ) * (107 / 44 : ℚ)
    exact eq_smul_div (321) scale (107) (44) (by decide) (by decide)
  · change ((60 : ℤ) : ℚ) = (scale : ℚ) * (5 / 11 : ℚ)
    exact eq_smul_div (60) scale (5) (11) (by decide) (by decide)
  · change ((336 : ℤ) : ℚ) = (scale : ℚ) * (28 / 11 : ℚ)
    exact eq_smul_div (336) scale (28) (11) (by decide) (by decide)
  · change ((66 : ℤ) : ℚ) = (scale : ℚ) * (1 / 2 : ℚ)
    exact eq_smul_div (66) scale (1) (2) (by decide) (by decide)
  · change ((204 : ℤ) : ℚ) = (scale : ℚ) * (17 / 11 : ℚ)
    exact eq_smul_div (204) scale (17) (11) (by decide) (by decide)
  · change ((225 : ℤ) : ℚ) = (scale : ℚ) * (75 / 44 : ℚ)
    exact eq_smul_div (225) scale (75) (44) (by decide) (by decide)
  · change ((153 : ℤ) : ℚ) = (scale : ℚ) * (51 / 44 : ℚ)
    exact eq_smul_div (153) scale (51) (44) (by decide) (by decide)
  · change ((213 : ℤ) : ℚ) = (scale : ℚ) * (71 / 44 : ℚ)
    exact eq_smul_div (213) scale (71) (44) (by decide) (by decide)
  · change ((-12 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-12) scale (-1) (11) (by decide) (by decide)
  · change ((381 : ℤ) : ℚ) = (scale : ℚ) * (127 / 44 : ℚ)
    exact eq_smul_div (381) scale (127) (44) (by decide) (by decide)

theorem XZ_scale_3 : toVec (XZ 3) = (scale : ℚ) • XCell6_3 := by
  funext i
  fin_cases i
  · change ((-153 : ℤ) : ℚ) = (scale : ℚ) * (-51 / 44 : ℚ)
    exact eq_smul_div (-153) scale (-51) (44) (by decide) (by decide)
  · change ((75 : ℤ) : ℚ) = (scale : ℚ) * (25 / 44 : ℚ)
    exact eq_smul_div (75) scale (25) (44) (by decide) (by decide)
  · change ((-15 : ℤ) : ℚ) = (scale : ℚ) * (-5 / 44 : ℚ)
    exact eq_smul_div (-15) scale (-5) (44) (by decide) (by decide)
  · change ((-30 : ℤ) : ℚ) = (scale : ℚ) * (-5 / 22 : ℚ)
    exact eq_smul_div (-30) scale (-5) (22) (by decide) (by decide)
  · change ((-66 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 2 : ℚ)
    exact eq_smul_div (-66) scale (-1) (2) (by decide) (by decide)
  · change ((-45 : ℤ) : ℚ) = (scale : ℚ) * (-15 / 44 : ℚ)
    exact eq_smul_div (-45) scale (-15) (44) (by decide) (by decide)
  · change ((24 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (24) scale (2) (11) (by decide) (by decide)
  · change ((-117 : ℤ) : ℚ) = (scale : ℚ) * (-39 / 44 : ℚ)
    exact eq_smul_div (-117) scale (-39) (44) (by decide) (by decide)
  · change ((51 : ℤ) : ℚ) = (scale : ℚ) * (17 / 44 : ℚ)
    exact eq_smul_div (51) scale (17) (44) (by decide) (by decide)
  · change ((-87 : ℤ) : ℚ) = (scale : ℚ) * (-29 / 44 : ℚ)
    exact eq_smul_div (-87) scale (-29) (44) (by decide) (by decide)

theorem XZ_scale_4 : toVec (XZ 4) = (scale : ℚ) • XCell6_4 := by
  funext i
  fin_cases i
  · change ((48 : ℤ) : ℚ) = (scale : ℚ) * (4 / 11 : ℚ)
    exact eq_smul_div (48) scale (4) (11) (by decide) (by decide)
  · change ((36 : ℤ) : ℚ) = (scale : ℚ) * (3 / 11 : ℚ)
    exact eq_smul_div (36) scale (3) (11) (by decide) (by decide)
  · change ((-3 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 44 : ℚ)
    exact eq_smul_div (-3) scale (-1) (44) (by decide) (by decide)
  · change ((57 : ℤ) : ℚ) = (scale : ℚ) * (19 / 44 : ℚ)
    exact eq_smul_div (57) scale (19) (44) (by decide) (by decide)
  · change ((12 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (12) scale (1) (11) (by decide) (by decide)
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 22 : ℚ)
    exact eq_smul_div (-6) scale (-1) (22) (by decide) (by decide)
  · change ((15 : ℤ) : ℚ) = (scale : ℚ) * (5 / 44 : ℚ)
    exact eq_smul_div (15) scale (5) (44) (by decide) (by decide)
  · change ((39 : ℤ) : ℚ) = (scale : ℚ) * (13 / 44 : ℚ)
    exact eq_smul_div (39) scale (13) (44) (by decide) (by decide)
  · change ((-12 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-12) scale (-1) (11) (by decide) (by decide)
  · change ((12 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (12) scale (1) (11) (by decide) (by decide)

theorem XZ_scale_5 : toVec (XZ 5) = (scale : ℚ) • XCell6_5 := by
  funext i
  fin_cases i
  · change ((222 : ℤ) : ℚ) = (scale : ℚ) * (37 / 22 : ℚ)
    exact eq_smul_div (222) scale (37) (22) (by decide) (by decide)
  · change ((-96 : ℤ) : ℚ) = (scale : ℚ) * (-8 / 11 : ℚ)
    exact eq_smul_div (-96) scale (-8) (11) (by decide) (by decide)
  · change ((60 : ℤ) : ℚ) = (scale : ℚ) * (5 / 11 : ℚ)
    exact eq_smul_div (60) scale (5) (11) (by decide) (by decide)
  · change ((66 : ℤ) : ℚ) = (scale : ℚ) * (1 / 2 : ℚ)
    exact eq_smul_div (66) scale (1) (2) (by decide) (by decide)
  · change ((126 : ℤ) : ℚ) = (scale : ℚ) * (21 / 22 : ℚ)
    exact eq_smul_div (126) scale (21) (22) (by decide) (by decide)
  · change ((42 : ℤ) : ℚ) = (scale : ℚ) * (7 / 22 : ℚ)
    exact eq_smul_div (42) scale (7) (22) (by decide) (by decide)
  · change ((-36 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 11 : ℚ)
    exact eq_smul_div (-36) scale (-3) (11) (by decide) (by decide)
  · change ((150 : ℤ) : ℚ) = (scale : ℚ) * (25 / 22 : ℚ)
    exact eq_smul_div (150) scale (25) (22) (by decide) (by decide)
  · change ((-66 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 2 : ℚ)
    exact eq_smul_div (-66) scale (-1) (2) (by decide) (by decide)
  · change ((60 : ℤ) : ℚ) = (scale : ℚ) * (5 / 11 : ℚ)
    exact eq_smul_div (60) scale (5) (11) (by decide) (by decide)

theorem XZ_scale_6 : toVec (XZ 6) = (scale : ℚ) • XCell6_6 := by
  funext i
  fin_cases i
  · change ((-66 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 2 : ℚ)
    exact eq_smul_div (-66) scale (-1) (2) (by decide) (by decide)
  · change ((-24 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-24) scale (-2) (11) (by decide) (by decide)
  · change ((-102 : ℤ) : ℚ) = (scale : ℚ) * (-17 / 22 : ℚ)
    exact eq_smul_div (-102) scale (-17) (22) (by decide) (by decide)
  · change ((30 : ℤ) : ℚ) = (scale : ℚ) * (5 / 22 : ℚ)
    exact eq_smul_div (30) scale (5) (22) (by decide) (by decide)
  · change ((-78 : ℤ) : ℚ) = (scale : ℚ) * (-13 / 22 : ℚ)
    exact eq_smul_div (-78) scale (-13) (22) (by decide) (by decide)
  · change ((-156 : ℤ) : ℚ) = (scale : ℚ) * (-13 / 11 : ℚ)
    exact eq_smul_div (-156) scale (-13) (11) (by decide) (by decide)
  · change ((-90 : ℤ) : ℚ) = (scale : ℚ) * (-15 / 22 : ℚ)
    exact eq_smul_div (-90) scale (-15) (22) (by decide) (by decide)
  · change ((-72 : ℤ) : ℚ) = (scale : ℚ) * (-6 / 11 : ℚ)
    exact eq_smul_div (-72) scale (-6) (11) (by decide) (by decide)
  · change ((-24 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-24) scale (-2) (11) (by decide) (by decide)
  · change ((-210 : ℤ) : ℚ) = (scale : ℚ) * (-35 / 22 : ℚ)
    exact eq_smul_div (-210) scale (-35) (22) (by decide) (by decide)

theorem XZ_scale_7 : toVec (XZ 7) = (scale : ℚ) • XCell6_7 := by
  funext i
  fin_cases i
  · change ((300 : ℤ) : ℚ) = (scale : ℚ) * (25 / 11 : ℚ)
    exact eq_smul_div (300) scale (25) (11) (by decide) (by decide)
  · change ((-210 : ℤ) : ℚ) = (scale : ℚ) * (-35 / 22 : ℚ)
    exact eq_smul_div (-210) scale (-35) (22) (by decide) (by decide)
  · change ((204 : ℤ) : ℚ) = (scale : ℚ) * (17 / 11 : ℚ)
    exact eq_smul_div (204) scale (17) (11) (by decide) (by decide)
  · change ((24 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (24) scale (2) (11) (by decide) (by decide)
  · change ((132 : ℤ) : ℚ) = (scale : ℚ) * (1 : ℚ)
    exact eq_smul_int (132) scale (1) (by decide)
  · change ((90 : ℤ) : ℚ) = (scale : ℚ) * (15 / 22 : ℚ)
    exact eq_smul_div (90) scale (15) (22) (by decide) (by decide)
  · change ((-36 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 11 : ℚ)
    exact eq_smul_div (-36) scale (-3) (11) (by decide) (by decide)
  · change ((234 : ℤ) : ℚ) = (scale : ℚ) * (39 / 22 : ℚ)
    exact eq_smul_div (234) scale (39) (22) (by decide) (by decide)
  · change ((-78 : ℤ) : ℚ) = (scale : ℚ) * (-13 / 22 : ℚ)
    exact eq_smul_div (-78) scale (-13) (22) (by decide) (by decide)
  · change ((198 : ℤ) : ℚ) = (scale : ℚ) * (3 / 2 : ℚ)
    exact eq_smul_div (198) scale (3) (2) (by decide) (by decide)

theorem XZ_scale_8 : toVec (XZ 8) = (scale : ℚ) • XCell6_8 := by
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

theorem XZ_scale_9 : toVec (XZ 9) = (scale : ℚ) • XCell6_9 := by
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

theorem XZ_scale_10 : toVec (XZ 10) = (scale : ℚ) • XCell6_10 := by
  funext i
  fin_cases i
  · change ((99 : ℤ) : ℚ) = (scale : ℚ) * (3 / 4 : ℚ)
    exact eq_smul_div (99) scale (3) (4) (by decide) (by decide)
  · change ((99 : ℤ) : ℚ) = (scale : ℚ) * (3 / 4 : ℚ)
    exact eq_smul_div (99) scale (3) (4) (by decide) (by decide)
  · change ((99 : ℤ) : ℚ) = (scale : ℚ) * (3 / 4 : ℚ)
    exact eq_smul_div (99) scale (3) (4) (by decide) (by decide)
  · change ((33 : ℤ) : ℚ) = (scale : ℚ) * (1 / 4 : ℚ)
    exact eq_smul_div (33) scale (1) (4) (by decide) (by decide)
  · change ((33 : ℤ) : ℚ) = (scale : ℚ) * (1 / 4 : ℚ)
    exact eq_smul_div (33) scale (1) (4) (by decide) (by decide)
  · change ((66 : ℤ) : ℚ) = (scale : ℚ) * (1 / 2 : ℚ)
    exact eq_smul_div (66) scale (1) (2) (by decide) (by decide)
  · change ((132 : ℤ) : ℚ) = (scale : ℚ) * (1 : ℚ)
    exact eq_smul_int (132) scale (1) (by decide)
  · change ((99 : ℤ) : ℚ) = (scale : ℚ) * (3 / 4 : ℚ)
    exact eq_smul_div (99) scale (3) (4) (by decide) (by decide)
  · change ((66 : ℤ) : ℚ) = (scale : ℚ) * (1 / 2 : ℚ)
    exact eq_smul_div (66) scale (1) (2) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem XZ_scale_11 : toVec (XZ 11) = (scale : ℚ) • XCell6_11 := by
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

theorem XZ_scale_12 : toVec (XZ 12) = (scale : ℚ) • XCell6_12 := by
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

theorem XZ_scale_13 : toVec (XZ 13) = (scale : ℚ) • XCell6_13 := by
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

theorem XZ_scale_14 : toVec (XZ 14) = (scale : ℚ) • XCell6_14 := by
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

theorem XZ_scale_15 : toVec (XZ 15) = (scale : ℚ) • XCell6_15 := by
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

theorem XZ_scale_16 : toVec (XZ 16) = (scale : ℚ) • XCell6_16 := by
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

theorem XZ_scale_17 : toVec (XZ 17) = (scale : ℚ) • XCell6_17 := by
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

theorem XZ_scale_18 : toVec (XZ 18) = (scale : ℚ) • XCell6_18 := by
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

theorem XZ_scale_19 : toVec (XZ 19) = (scale : ℚ) • XCell6_19 := by
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
    toVec (XZ k) = (scale : ℚ) • XVec (6 : Fin 10) k := by
  fin_cases k
  · simp [XVec, XRow6]; exact XZ_scale_0
  · simp [XVec, XRow6]; exact XZ_scale_1
  · simp [XVec, XRow6]; exact XZ_scale_2
  · simp [XVec, XRow6]; exact XZ_scale_3
  · simp [XVec, XRow6]; exact XZ_scale_4
  · simp [XVec, XRow6]; exact XZ_scale_5
  · simp [XVec, XRow6]; exact XZ_scale_6
  · simp [XVec, XRow6]; exact XZ_scale_7
  · simp [XVec, XRow6]; exact XZ_scale_8
  · simp [XVec, XRow6]; exact XZ_scale_9
  · simp [XVec, XRow6]; exact XZ_scale_10
  · simp [XVec, XRow6]; exact XZ_scale_11
  · simp [XVec, XRow6]; exact XZ_scale_12
  · simp [XVec, XRow6]; exact XZ_scale_13
  · simp [XVec, XRow6]; exact XZ_scale_14
  · simp [XVec, XRow6]; exact XZ_scale_15
  · simp [XVec, XRow6]; exact XZ_scale_16
  · simp [XVec, XRow6]; exact XZ_scale_17
  · simp [XVec, XRow6]; exact XZ_scale_18
  · simp [XVec, XRow6]; exact XZ_scale_19

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

theorem KZ_scale_0 : toVec (KZ 0) = (scale : ℚ) • KCell6_0 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-132 : ℤ) : ℚ) = (scale : ℚ) * (-1 : ℚ)
    exact eq_smul_int (-132) scale (-1) (by decide)
  · change ((-66 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 2 : ℚ)
    exact eq_smul_div (-66) scale (-1) (2) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((66 : ℤ) : ℚ) = (scale : ℚ) * (1 / 2 : ℚ)
    exact eq_smul_div (66) scale (1) (2) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-66 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 2 : ℚ)
    exact eq_smul_div (-66) scale (-1) (2) (by decide) (by decide)
  · change ((-66 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 2 : ℚ)
    exact eq_smul_div (-66) scale (-1) (2) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((66 : ℤ) : ℚ) = (scale : ℚ) * (1 / 2 : ℚ)
    exact eq_smul_div (66) scale (1) (2) (by decide) (by decide)

theorem KZ_scale (k : Fin 1) :
    toVec (KZ k) = (scale : ℚ) • KVec (6 : Fin 10) k := by
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
        (6 : Fin 10) (9 : Fin 10) = ![0, 0, 0, 0, 0, 0, 0, 0, 0, 0] := by
  change (∑ k : Fin 20, mul (XVec (6 : Fin 10) k)
      (AVec k (9 : Fin 10))) +
    (∑ k : Fin 1, mul (KVec (6 : Fin 10) k)
      (YVec k (9 : Fin 10))) = _
  refine add_sum_mul_eq_of_scaled scale scale_ne_zero
    (fun k => XVec (6 : Fin 10) k)
    (fun k => AVec k (9 : Fin 10))
    (fun k => KVec (6 : Fin 10) k)
    (fun k => YVec k (9 : Fin 10))
    XZ AZ KZ YZ XZ_scale AZ_scale KZ_scale YZ_scale entryZ rfl _ ?_
  rw [entryZ_eq, toVec_zeroZ_smul, vec_zero_eq]

theorem entry_eq_matrixOne :
    (matrixMul XVec AVec + matrixMul KVec YVec)
        (6 : Fin 10) (9 : Fin 10) =
      matrixOne (Fin 10) (6 : Fin 10) (9 : Fin 10) := by
  rw [entry_eq]
  have hne : (6 : Fin 10) ≠ (9 : Fin 10) := by decide
  funext n
  fin_cases n <;> simp [matrixOne, constVec, basis, *]

end V14Formalization.D12PieceAASplitEntry6_9
