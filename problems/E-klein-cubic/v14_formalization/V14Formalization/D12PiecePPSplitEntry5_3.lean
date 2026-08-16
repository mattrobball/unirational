/- PP split identity entry (5,3). Auto-generated. -/
import V14Formalization.D12PiecePPData
import V14Formalization.D12CyclotomicVecZ

noncomputable section
open Matrix
namespace V14Formalization.D12PiecePPSplitEntry5_3
open D12CyclotomicVec D12CyclotomicVecZ D12PiecePPData
def payloadSha256 : String := "76c6196f29afe1a8398af99502447f48ebeed4bcb3805fc5dbec693940bc04b0"

def scale : ℤ := 22

def XZ (k : Fin 20) : VecZ :=
  match k.val with
  | 0 => #v[49, -12, 0, 46, -27, 40, 36, -40, 52, -1]
  | 1 => #v[-91, -6, -42, -78, 7, -62, -54, -2, -71, -41]
  | 2 => #v[14, -5, -3, 1, -4, 16, 1, -12, -6, 9]
  | 3 => #v[45, 2, 6, 47, -21, 24, 33, -21, 43, 7]
  | 4 => #v[9, 7, 16, 17, -3, 7, 11, -1, 23, 13]
  | 5 => #v[-104, 12, -22, -52, 2, -56, -42, 10, -46, -32]
  | 6 => #v[116, 12, 40, 110, -4, 82, 84, -6, 100, 60]
  | 7 => #v[50, -10, -2, 40, -12, 24, 32, -20, 38, -8]
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
  | 0 => #v[4, 2, 2, 4, 0, 0, 2, 6, 2, 0]
  | 1 => #v[0, 0, 4, 2, 2, 6, 2, 2, 4, 0]
  | 2 => #v[-4, -2, -2, -4, -4, -2, -2, -4, 0, 2]
  | 3 => #v[-24, 0, 2, 2, 0, -2, 0, -2, 4, -2]
  | 4 => #v[2, -2, 4, -2, 2, 0, -2, 0, 0, -2]
  | 5 => #v[3, 3, 3, 0, 6, 3, 3, 3, 3, 6]
  | 6 => #v[3, 0, 3, 6, 3, 3, 3, 3, 6, 3]
  | 7 => #v[0, -3, 0, 0, 3, 3, 0, 0, -3, 0]
  | 8 => #v[3, 3, 3, 3, 3, 3, 3, 0, 6, 6]
  | 9 => #v[3, 3, 0, 3, 3, 6, 3, 6, 3, 3]
  | 10 => #v[4, 2, 2, 6, 2, 2, 4, 0, 0, 0]
  | 11 => #v[2, 0, 2, 4, 4, 2, 0, 2, 0, 6]
  | 12 => #v[-2, -4, -2, -2, -4, -2, 0, -4, 2, -4]
  | 13 => #v[-20, 0, -4, -2, -2, -4, -4, -2, -2, -4]
  | 14 => #v[4, 2, 2, 4, 0, 0, 2, 6, 2, 0]
  | 15 => #v[0, 0, 0, -3, 3, 3, -3, 0, 0, 0]
  | 16 => #v[-3, 0, 0, 0, -3, 0, 0, 3, 3, 0]
  | 17 => #v[0, -3, 0, 0, 3, 0, 3, 0, 0, -3]
  | 18 => #v[0, -3, 0, 3, 0, 3, 0, -3, 0, 0]
  | 19 => #v[0, 0, 0, -3, 3, 0, 0, 0, 3, -3]
  | _ => zeroZ

def KZ (k : Fin 2) : VecZ :=
  match k.val with
  | 0 => #v[-11, 0, 11, 0, 0, -11, -11, 0, 0, 11]
  | 1 => #v[0, 0, 0, -22, -11, 11, 11, -11, -22, 0]
  | _ => zeroZ

def YZ (k : Fin 2) : VecZ :=
  match k.val with
  | 0 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  | 1 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  | _ => zeroZ

theorem xaMulZ0 :
    mulZ (XZ 0) (AZ 0) = #v[248, 140, 126, 128, 2, 132, 286, -10, 222, 68] := by
  decide

theorem xaMulZ1 :
    mulZ (XZ 1) (AZ 1) = #v[22, 638, -154, 264, 484, -242, 484, 242, -176, 616] := by
  decide

theorem xaMulZ2 :
    mulZ (XZ 2) (AZ 2) = #v[-26, -60, -18, 30, -8, -114, -50, 4, 22, -22] := by
  decide

theorem xaMulZ3 :
    mulZ (XZ 3) (AZ 3) = #v[-750, -140, 10, -844, 362, -282, -724, 472, -758, -118] := by
  decide

theorem xaMulZ4 :
    mulZ (XZ 4) (AZ 4) = #v[-106, -122, 6, -130, -102, -10, -152, -78, -42, -166] := by
  decide

theorem xaMulZ5 :
    mulZ (XZ 5) (AZ 5) = #v[-126, -324, -126, -54, -498, 66, -270, -312, 78, -546] := by
  decide

theorem xaMulZ6 :
    mulZ (XZ 6) (AZ 6) = #v[1020, 126, 306, 918, -132, 606, 708, -138, 858, 414] := by
  decide

theorem xaMulZ7 :
    mulZ (XZ 7) (AZ 7) = #v[-282, -258, -150, -312, -108, -156, -282, -180, -204, -246] := by
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
  | 0 => #v[248, 140, 126, 128, 2, 132, 286, -10, 222, 68]
  | 1 => #v[22, 638, -154, 264, 484, -242, 484, 242, -176, 616]
  | 2 => #v[-26, -60, -18, 30, -8, -114, -50, 4, 22, -22]
  | 3 => #v[-750, -140, 10, -844, 362, -282, -724, 472, -758, -118]
  | 4 => #v[-106, -122, 6, -130, -102, -10, -152, -78, -42, -166]
  | 5 => #v[-126, -324, -126, -54, -498, 66, -270, -312, 78, -546]
  | 6 => #v[1020, 126, 306, 918, -132, 606, 708, -138, 858, 414]
  | 7 => #v[-282, -258, -150, -312, -108, -156, -282, -180, -204, -246]
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

theorem XZ_scale_0 : toVec (XZ 0) = (scale : ℚ) • XCell5_0 := by
  funext i
  fin_cases i
  · change ((49 : ℤ) : ℚ) = (scale : ℚ) * (49 / 22 : ℚ)
    exact eq_smul_div (49) scale (49) (22) (by decide) (by decide)
  · change ((-12 : ℤ) : ℚ) = (scale : ℚ) * (-6 / 11 : ℚ)
    exact eq_smul_div (-12) scale (-6) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((46 : ℤ) : ℚ) = (scale : ℚ) * (23 / 11 : ℚ)
    exact eq_smul_div (46) scale (23) (11) (by decide) (by decide)
  · change ((-27 : ℤ) : ℚ) = (scale : ℚ) * (-27 / 22 : ℚ)
    exact eq_smul_div (-27) scale (-27) (22) (by decide) (by decide)
  · change ((40 : ℤ) : ℚ) = (scale : ℚ) * (20 / 11 : ℚ)
    exact eq_smul_div (40) scale (20) (11) (by decide) (by decide)
  · change ((36 : ℤ) : ℚ) = (scale : ℚ) * (18 / 11 : ℚ)
    exact eq_smul_div (36) scale (18) (11) (by decide) (by decide)
  · change ((-40 : ℤ) : ℚ) = (scale : ℚ) * (-20 / 11 : ℚ)
    exact eq_smul_div (-40) scale (-20) (11) (by decide) (by decide)
  · change ((52 : ℤ) : ℚ) = (scale : ℚ) * (26 / 11 : ℚ)
    exact eq_smul_div (52) scale (26) (11) (by decide) (by decide)
  · change ((-1 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 22 : ℚ)
    exact eq_smul_div (-1) scale (-1) (22) (by decide) (by decide)

theorem XZ_scale_1 : toVec (XZ 1) = (scale : ℚ) • XCell5_1 := by
  funext i
  fin_cases i
  · change ((-91 : ℤ) : ℚ) = (scale : ℚ) * (-91 / 22 : ℚ)
    exact eq_smul_div (-91) scale (-91) (22) (by decide) (by decide)
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 11 : ℚ)
    exact eq_smul_div (-6) scale (-3) (11) (by decide) (by decide)
  · change ((-42 : ℤ) : ℚ) = (scale : ℚ) * (-21 / 11 : ℚ)
    exact eq_smul_div (-42) scale (-21) (11) (by decide) (by decide)
  · change ((-78 : ℤ) : ℚ) = (scale : ℚ) * (-39 / 11 : ℚ)
    exact eq_smul_div (-78) scale (-39) (11) (by decide) (by decide)
  · change ((7 : ℤ) : ℚ) = (scale : ℚ) * (7 / 22 : ℚ)
    exact eq_smul_div (7) scale (7) (22) (by decide) (by decide)
  · change ((-62 : ℤ) : ℚ) = (scale : ℚ) * (-31 / 11 : ℚ)
    exact eq_smul_div (-62) scale (-31) (11) (by decide) (by decide)
  · change ((-54 : ℤ) : ℚ) = (scale : ℚ) * (-27 / 11 : ℚ)
    exact eq_smul_div (-54) scale (-27) (11) (by decide) (by decide)
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-2) scale (-1) (11) (by decide) (by decide)
  · change ((-71 : ℤ) : ℚ) = (scale : ℚ) * (-71 / 22 : ℚ)
    exact eq_smul_div (-71) scale (-71) (22) (by decide) (by decide)
  · change ((-41 : ℤ) : ℚ) = (scale : ℚ) * (-41 / 22 : ℚ)
    exact eq_smul_div (-41) scale (-41) (22) (by decide) (by decide)

theorem XZ_scale_2 : toVec (XZ 2) = (scale : ℚ) • XCell5_2 := by
  funext i
  fin_cases i
  · change ((14 : ℤ) : ℚ) = (scale : ℚ) * (7 / 11 : ℚ)
    exact eq_smul_div (14) scale (7) (11) (by decide) (by decide)
  · change ((-5 : ℤ) : ℚ) = (scale : ℚ) * (-5 / 22 : ℚ)
    exact eq_smul_div (-5) scale (-5) (22) (by decide) (by decide)
  · change ((-3 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-3) scale (-3) (22) (by decide) (by decide)
  · change ((1 : ℤ) : ℚ) = (scale : ℚ) * (1 / 22 : ℚ)
    exact eq_smul_div (1) scale (1) (22) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((16 : ℤ) : ℚ) = (scale : ℚ) * (8 / 11 : ℚ)
    exact eq_smul_div (16) scale (8) (11) (by decide) (by decide)
  · change ((1 : ℤ) : ℚ) = (scale : ℚ) * (1 / 22 : ℚ)
    exact eq_smul_div (1) scale (1) (22) (by decide) (by decide)
  · change ((-12 : ℤ) : ℚ) = (scale : ℚ) * (-6 / 11 : ℚ)
    exact eq_smul_div (-12) scale (-6) (11) (by decide) (by decide)
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 11 : ℚ)
    exact eq_smul_div (-6) scale (-3) (11) (by decide) (by decide)
  · change ((9 : ℤ) : ℚ) = (scale : ℚ) * (9 / 22 : ℚ)
    exact eq_smul_div (9) scale (9) (22) (by decide) (by decide)

theorem XZ_scale_3 : toVec (XZ 3) = (scale : ℚ) • XCell5_3 := by
  funext i
  fin_cases i
  · change ((45 : ℤ) : ℚ) = (scale : ℚ) * (45 / 22 : ℚ)
    exact eq_smul_div (45) scale (45) (22) (by decide) (by decide)
  · change ((2 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (2) scale (1) (11) (by decide) (by decide)
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (3 / 11 : ℚ)
    exact eq_smul_div (6) scale (3) (11) (by decide) (by decide)
  · change ((47 : ℤ) : ℚ) = (scale : ℚ) * (47 / 22 : ℚ)
    exact eq_smul_div (47) scale (47) (22) (by decide) (by decide)
  · change ((-21 : ℤ) : ℚ) = (scale : ℚ) * (-21 / 22 : ℚ)
    exact eq_smul_div (-21) scale (-21) (22) (by decide) (by decide)
  · change ((24 : ℤ) : ℚ) = (scale : ℚ) * (12 / 11 : ℚ)
    exact eq_smul_div (24) scale (12) (11) (by decide) (by decide)
  · change ((33 : ℤ) : ℚ) = (scale : ℚ) * (3 / 2 : ℚ)
    exact eq_smul_div (33) scale (3) (2) (by decide) (by decide)
  · change ((-21 : ℤ) : ℚ) = (scale : ℚ) * (-21 / 22 : ℚ)
    exact eq_smul_div (-21) scale (-21) (22) (by decide) (by decide)
  · change ((43 : ℤ) : ℚ) = (scale : ℚ) * (43 / 22 : ℚ)
    exact eq_smul_div (43) scale (43) (22) (by decide) (by decide)
  · change ((7 : ℤ) : ℚ) = (scale : ℚ) * (7 / 22 : ℚ)
    exact eq_smul_div (7) scale (7) (22) (by decide) (by decide)

theorem XZ_scale_4 : toVec (XZ 4) = (scale : ℚ) • XCell5_4 := by
  funext i
  fin_cases i
  · change ((9 : ℤ) : ℚ) = (scale : ℚ) * (9 / 22 : ℚ)
    exact eq_smul_div (9) scale (9) (22) (by decide) (by decide)
  · change ((7 : ℤ) : ℚ) = (scale : ℚ) * (7 / 22 : ℚ)
    exact eq_smul_div (7) scale (7) (22) (by decide) (by decide)
  · change ((16 : ℤ) : ℚ) = (scale : ℚ) * (8 / 11 : ℚ)
    exact eq_smul_div (16) scale (8) (11) (by decide) (by decide)
  · change ((17 : ℤ) : ℚ) = (scale : ℚ) * (17 / 22 : ℚ)
    exact eq_smul_div (17) scale (17) (22) (by decide) (by decide)
  · change ((-3 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-3) scale (-3) (22) (by decide) (by decide)
  · change ((7 : ℤ) : ℚ) = (scale : ℚ) * (7 / 22 : ℚ)
    exact eq_smul_div (7) scale (7) (22) (by decide) (by decide)
  · change ((11 : ℤ) : ℚ) = (scale : ℚ) * (1 / 2 : ℚ)
    exact eq_smul_div (11) scale (1) (2) (by decide) (by decide)
  · change ((-1 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 22 : ℚ)
    exact eq_smul_div (-1) scale (-1) (22) (by decide) (by decide)
  · change ((23 : ℤ) : ℚ) = (scale : ℚ) * (23 / 22 : ℚ)
    exact eq_smul_div (23) scale (23) (22) (by decide) (by decide)
  · change ((13 : ℤ) : ℚ) = (scale : ℚ) * (13 / 22 : ℚ)
    exact eq_smul_div (13) scale (13) (22) (by decide) (by decide)

theorem XZ_scale_5 : toVec (XZ 5) = (scale : ℚ) • XCell5_5 := by
  funext i
  fin_cases i
  · change ((-104 : ℤ) : ℚ) = (scale : ℚ) * (-52 / 11 : ℚ)
    exact eq_smul_div (-104) scale (-52) (11) (by decide) (by decide)
  · change ((12 : ℤ) : ℚ) = (scale : ℚ) * (6 / 11 : ℚ)
    exact eq_smul_div (12) scale (6) (11) (by decide) (by decide)
  · change ((-22 : ℤ) : ℚ) = (scale : ℚ) * (-1 : ℚ)
    exact eq_smul_int (-22) scale (-1) (by decide)
  · change ((-52 : ℤ) : ℚ) = (scale : ℚ) * (-26 / 11 : ℚ)
    exact eq_smul_div (-52) scale (-26) (11) (by decide) (by decide)
  · change ((2 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (2) scale (1) (11) (by decide) (by decide)
  · change ((-56 : ℤ) : ℚ) = (scale : ℚ) * (-28 / 11 : ℚ)
    exact eq_smul_div (-56) scale (-28) (11) (by decide) (by decide)
  · change ((-42 : ℤ) : ℚ) = (scale : ℚ) * (-21 / 11 : ℚ)
    exact eq_smul_div (-42) scale (-21) (11) (by decide) (by decide)
  · change ((10 : ℤ) : ℚ) = (scale : ℚ) * (5 / 11 : ℚ)
    exact eq_smul_div (10) scale (5) (11) (by decide) (by decide)
  · change ((-46 : ℤ) : ℚ) = (scale : ℚ) * (-23 / 11 : ℚ)
    exact eq_smul_div (-46) scale (-23) (11) (by decide) (by decide)
  · change ((-32 : ℤ) : ℚ) = (scale : ℚ) * (-16 / 11 : ℚ)
    exact eq_smul_div (-32) scale (-16) (11) (by decide) (by decide)

theorem XZ_scale_6 : toVec (XZ 6) = (scale : ℚ) • XCell5_6 := by
  funext i
  fin_cases i
  · change ((116 : ℤ) : ℚ) = (scale : ℚ) * (58 / 11 : ℚ)
    exact eq_smul_div (116) scale (58) (11) (by decide) (by decide)
  · change ((12 : ℤ) : ℚ) = (scale : ℚ) * (6 / 11 : ℚ)
    exact eq_smul_div (12) scale (6) (11) (by decide) (by decide)
  · change ((40 : ℤ) : ℚ) = (scale : ℚ) * (20 / 11 : ℚ)
    exact eq_smul_div (40) scale (20) (11) (by decide) (by decide)
  · change ((110 : ℤ) : ℚ) = (scale : ℚ) * (5 : ℚ)
    exact eq_smul_int (110) scale (5) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((82 : ℤ) : ℚ) = (scale : ℚ) * (41 / 11 : ℚ)
    exact eq_smul_div (82) scale (41) (11) (by decide) (by decide)
  · change ((84 : ℤ) : ℚ) = (scale : ℚ) * (42 / 11 : ℚ)
    exact eq_smul_div (84) scale (42) (11) (by decide) (by decide)
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 11 : ℚ)
    exact eq_smul_div (-6) scale (-3) (11) (by decide) (by decide)
  · change ((100 : ℤ) : ℚ) = (scale : ℚ) * (50 / 11 : ℚ)
    exact eq_smul_div (100) scale (50) (11) (by decide) (by decide)
  · change ((60 : ℤ) : ℚ) = (scale : ℚ) * (30 / 11 : ℚ)
    exact eq_smul_div (60) scale (30) (11) (by decide) (by decide)

theorem XZ_scale_7 : toVec (XZ 7) = (scale : ℚ) • XCell5_7 := by
  funext i
  fin_cases i
  · change ((50 : ℤ) : ℚ) = (scale : ℚ) * (25 / 11 : ℚ)
    exact eq_smul_div (50) scale (25) (11) (by decide) (by decide)
  · change ((-10 : ℤ) : ℚ) = (scale : ℚ) * (-5 / 11 : ℚ)
    exact eq_smul_div (-10) scale (-5) (11) (by decide) (by decide)
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-2) scale (-1) (11) (by decide) (by decide)
  · change ((40 : ℤ) : ℚ) = (scale : ℚ) * (20 / 11 : ℚ)
    exact eq_smul_div (40) scale (20) (11) (by decide) (by decide)
  · change ((-12 : ℤ) : ℚ) = (scale : ℚ) * (-6 / 11 : ℚ)
    exact eq_smul_div (-12) scale (-6) (11) (by decide) (by decide)
  · change ((24 : ℤ) : ℚ) = (scale : ℚ) * (12 / 11 : ℚ)
    exact eq_smul_div (24) scale (12) (11) (by decide) (by decide)
  · change ((32 : ℤ) : ℚ) = (scale : ℚ) * (16 / 11 : ℚ)
    exact eq_smul_div (32) scale (16) (11) (by decide) (by decide)
  · change ((-20 : ℤ) : ℚ) = (scale : ℚ) * (-10 / 11 : ℚ)
    exact eq_smul_div (-20) scale (-10) (11) (by decide) (by decide)
  · change ((38 : ℤ) : ℚ) = (scale : ℚ) * (19 / 11 : ℚ)
    exact eq_smul_div (38) scale (19) (11) (by decide) (by decide)
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-4 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-4) (11) (by decide) (by decide)

theorem XZ_scale_8 : toVec (XZ 8) = (scale : ℚ) • XCell5_8 := by
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

theorem XZ_scale_9 : toVec (XZ 9) = (scale : ℚ) • XCell5_9 := by
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

theorem XZ_scale_10 : toVec (XZ 10) = (scale : ℚ) • XCell5_10 := by
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

theorem XZ_scale_11 : toVec (XZ 11) = (scale : ℚ) • XCell5_11 := by
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

theorem XZ_scale_12 : toVec (XZ 12) = (scale : ℚ) • XCell5_12 := by
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

theorem XZ_scale_13 : toVec (XZ 13) = (scale : ℚ) • XCell5_13 := by
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

theorem XZ_scale_14 : toVec (XZ 14) = (scale : ℚ) • XCell5_14 := by
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

theorem XZ_scale_15 : toVec (XZ 15) = (scale : ℚ) • XCell5_15 := by
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

theorem XZ_scale_16 : toVec (XZ 16) = (scale : ℚ) • XCell5_16 := by
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

theorem XZ_scale_17 : toVec (XZ 17) = (scale : ℚ) • XCell5_17 := by
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

theorem XZ_scale_18 : toVec (XZ 18) = (scale : ℚ) • XCell5_18 := by
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

theorem XZ_scale_19 : toVec (XZ 19) = (scale : ℚ) • XCell5_19 := by
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
    toVec (XZ k) = (scale : ℚ) • XVec (5 : Fin 10) k := by
  fin_cases k
  · simp [XVec, XRow5]; exact XZ_scale_0
  · simp [XVec, XRow5]; exact XZ_scale_1
  · simp [XVec, XRow5]; exact XZ_scale_2
  · simp [XVec, XRow5]; exact XZ_scale_3
  · simp [XVec, XRow5]; exact XZ_scale_4
  · simp [XVec, XRow5]; exact XZ_scale_5
  · simp [XVec, XRow5]; exact XZ_scale_6
  · simp [XVec, XRow5]; exact XZ_scale_7
  · simp [XVec, XRow5]; exact XZ_scale_8
  · simp [XVec, XRow5]; exact XZ_scale_9
  · simp [XVec, XRow5]; exact XZ_scale_10
  · simp [XVec, XRow5]; exact XZ_scale_11
  · simp [XVec, XRow5]; exact XZ_scale_12
  · simp [XVec, XRow5]; exact XZ_scale_13
  · simp [XVec, XRow5]; exact XZ_scale_14
  · simp [XVec, XRow5]; exact XZ_scale_15
  · simp [XVec, XRow5]; exact XZ_scale_16
  · simp [XVec, XRow5]; exact XZ_scale_17
  · simp [XVec, XRow5]; exact XZ_scale_18
  · simp [XVec, XRow5]; exact XZ_scale_19

theorem AZ_scale_0 : toVec (AZ 0) = (scale : ℚ) • ACell0_3 := by
  funext i
  fin_cases i
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (4) scale (2) (11) (by decide) (by decide)
  · change ((2 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (2) scale (1) (11) (by decide) (by decide)
  · change ((2 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (2) scale (1) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (4) scale (2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((2 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (2) scale (1) (11) (by decide) (by decide)
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (3 / 11 : ℚ)
    exact eq_smul_div (6) scale (3) (11) (by decide) (by decide)
  · change ((2 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (2) scale (1) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem AZ_scale_1 : toVec (AZ 1) = (scale : ℚ) • ACell1_3 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (4) scale (2) (11) (by decide) (by decide)
  · change ((2 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (2) scale (1) (11) (by decide) (by decide)
  · change ((2 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (2) scale (1) (11) (by decide) (by decide)
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (3 / 11 : ℚ)
    exact eq_smul_div (6) scale (3) (11) (by decide) (by decide)
  · change ((2 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (2) scale (1) (11) (by decide) (by decide)
  · change ((2 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (2) scale (1) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (4) scale (2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem AZ_scale_2 : toVec (AZ 2) = (scale : ℚ) • ACell2_3 := by
  funext i
  fin_cases i
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-2) scale (-1) (11) (by decide) (by decide)
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-2) scale (-1) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-2) scale (-1) (11) (by decide) (by decide)
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-2) scale (-1) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((2 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (2) scale (1) (11) (by decide) (by decide)

theorem AZ_scale_3 : toVec (AZ 3) = (scale : ℚ) • ACell3_3 := by
  funext i
  fin_cases i
  · change ((-24 : ℤ) : ℚ) = (scale : ℚ) * (-12 / 11 : ℚ)
    exact eq_smul_div (-24) scale (-12) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((2 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (2) scale (1) (11) (by decide) (by decide)
  · change ((2 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (2) scale (1) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-2) scale (-1) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-2) scale (-1) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (4) scale (2) (11) (by decide) (by decide)
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-2) scale (-1) (11) (by decide) (by decide)

theorem AZ_scale_4 : toVec (AZ 4) = (scale : ℚ) • ACell4_3 := by
  funext i
  fin_cases i
  · change ((2 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (2) scale (1) (11) (by decide) (by decide)
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-2) scale (-1) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (4) scale (2) (11) (by decide) (by decide)
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-2) scale (-1) (11) (by decide) (by decide)
  · change ((2 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (2) scale (1) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-2) scale (-1) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-2) scale (-1) (11) (by decide) (by decide)

theorem AZ_scale_5 : toVec (AZ 5) = (scale : ℚ) • ACell5_3 := by
  funext i
  fin_cases i
  · change ((3 : ℤ) : ℚ) = (scale : ℚ) * (3 / 22 : ℚ)
    exact eq_smul_div (3) scale (3) (22) (by decide) (by decide)
  · change ((3 : ℤ) : ℚ) = (scale : ℚ) * (3 / 22 : ℚ)
    exact eq_smul_div (3) scale (3) (22) (by decide) (by decide)
  · change ((3 : ℤ) : ℚ) = (scale : ℚ) * (3 / 22 : ℚ)
    exact eq_smul_div (3) scale (3) (22) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (3 / 11 : ℚ)
    exact eq_smul_div (6) scale (3) (11) (by decide) (by decide)
  · change ((3 : ℤ) : ℚ) = (scale : ℚ) * (3 / 22 : ℚ)
    exact eq_smul_div (3) scale (3) (22) (by decide) (by decide)
  · change ((3 : ℤ) : ℚ) = (scale : ℚ) * (3 / 22 : ℚ)
    exact eq_smul_div (3) scale (3) (22) (by decide) (by decide)
  · change ((3 : ℤ) : ℚ) = (scale : ℚ) * (3 / 22 : ℚ)
    exact eq_smul_div (3) scale (3) (22) (by decide) (by decide)
  · change ((3 : ℤ) : ℚ) = (scale : ℚ) * (3 / 22 : ℚ)
    exact eq_smul_div (3) scale (3) (22) (by decide) (by decide)
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (3 / 11 : ℚ)
    exact eq_smul_div (6) scale (3) (11) (by decide) (by decide)

theorem AZ_scale_6 : toVec (AZ 6) = (scale : ℚ) • ACell6_3 := by
  funext i
  fin_cases i
  · change ((3 : ℤ) : ℚ) = (scale : ℚ) * (3 / 22 : ℚ)
    exact eq_smul_div (3) scale (3) (22) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((3 : ℤ) : ℚ) = (scale : ℚ) * (3 / 22 : ℚ)
    exact eq_smul_div (3) scale (3) (22) (by decide) (by decide)
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (3 / 11 : ℚ)
    exact eq_smul_div (6) scale (3) (11) (by decide) (by decide)
  · change ((3 : ℤ) : ℚ) = (scale : ℚ) * (3 / 22 : ℚ)
    exact eq_smul_div (3) scale (3) (22) (by decide) (by decide)
  · change ((3 : ℤ) : ℚ) = (scale : ℚ) * (3 / 22 : ℚ)
    exact eq_smul_div (3) scale (3) (22) (by decide) (by decide)
  · change ((3 : ℤ) : ℚ) = (scale : ℚ) * (3 / 22 : ℚ)
    exact eq_smul_div (3) scale (3) (22) (by decide) (by decide)
  · change ((3 : ℤ) : ℚ) = (scale : ℚ) * (3 / 22 : ℚ)
    exact eq_smul_div (3) scale (3) (22) (by decide) (by decide)
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (3 / 11 : ℚ)
    exact eq_smul_div (6) scale (3) (11) (by decide) (by decide)
  · change ((3 : ℤ) : ℚ) = (scale : ℚ) * (3 / 22 : ℚ)
    exact eq_smul_div (3) scale (3) (22) (by decide) (by decide)

theorem AZ_scale_7 : toVec (AZ 7) = (scale : ℚ) • ACell7_3 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-3 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-3) scale (-3) (22) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((3 : ℤ) : ℚ) = (scale : ℚ) * (3 / 22 : ℚ)
    exact eq_smul_div (3) scale (3) (22) (by decide) (by decide)
  · change ((3 : ℤ) : ℚ) = (scale : ℚ) * (3 / 22 : ℚ)
    exact eq_smul_div (3) scale (3) (22) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-3 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-3) scale (-3) (22) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem AZ_scale_8 : toVec (AZ 8) = (scale : ℚ) • ACell8_3 := by
  funext i
  fin_cases i
  · change ((3 : ℤ) : ℚ) = (scale : ℚ) * (3 / 22 : ℚ)
    exact eq_smul_div (3) scale (3) (22) (by decide) (by decide)
  · change ((3 : ℤ) : ℚ) = (scale : ℚ) * (3 / 22 : ℚ)
    exact eq_smul_div (3) scale (3) (22) (by decide) (by decide)
  · change ((3 : ℤ) : ℚ) = (scale : ℚ) * (3 / 22 : ℚ)
    exact eq_smul_div (3) scale (3) (22) (by decide) (by decide)
  · change ((3 : ℤ) : ℚ) = (scale : ℚ) * (3 / 22 : ℚ)
    exact eq_smul_div (3) scale (3) (22) (by decide) (by decide)
  · change ((3 : ℤ) : ℚ) = (scale : ℚ) * (3 / 22 : ℚ)
    exact eq_smul_div (3) scale (3) (22) (by decide) (by decide)
  · change ((3 : ℤ) : ℚ) = (scale : ℚ) * (3 / 22 : ℚ)
    exact eq_smul_div (3) scale (3) (22) (by decide) (by decide)
  · change ((3 : ℤ) : ℚ) = (scale : ℚ) * (3 / 22 : ℚ)
    exact eq_smul_div (3) scale (3) (22) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (3 / 11 : ℚ)
    exact eq_smul_div (6) scale (3) (11) (by decide) (by decide)
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (3 / 11 : ℚ)
    exact eq_smul_div (6) scale (3) (11) (by decide) (by decide)

theorem AZ_scale_9 : toVec (AZ 9) = (scale : ℚ) • ACell9_3 := by
  funext i
  fin_cases i
  · change ((3 : ℤ) : ℚ) = (scale : ℚ) * (3 / 22 : ℚ)
    exact eq_smul_div (3) scale (3) (22) (by decide) (by decide)
  · change ((3 : ℤ) : ℚ) = (scale : ℚ) * (3 / 22 : ℚ)
    exact eq_smul_div (3) scale (3) (22) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((3 : ℤ) : ℚ) = (scale : ℚ) * (3 / 22 : ℚ)
    exact eq_smul_div (3) scale (3) (22) (by decide) (by decide)
  · change ((3 : ℤ) : ℚ) = (scale : ℚ) * (3 / 22 : ℚ)
    exact eq_smul_div (3) scale (3) (22) (by decide) (by decide)
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (3 / 11 : ℚ)
    exact eq_smul_div (6) scale (3) (11) (by decide) (by decide)
  · change ((3 : ℤ) : ℚ) = (scale : ℚ) * (3 / 22 : ℚ)
    exact eq_smul_div (3) scale (3) (22) (by decide) (by decide)
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (3 / 11 : ℚ)
    exact eq_smul_div (6) scale (3) (11) (by decide) (by decide)
  · change ((3 : ℤ) : ℚ) = (scale : ℚ) * (3 / 22 : ℚ)
    exact eq_smul_div (3) scale (3) (22) (by decide) (by decide)
  · change ((3 : ℤ) : ℚ) = (scale : ℚ) * (3 / 22 : ℚ)
    exact eq_smul_div (3) scale (3) (22) (by decide) (by decide)

theorem AZ_scale_10 : toVec (AZ 10) = (scale : ℚ) • ACell10_3 := by
  funext i
  fin_cases i
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (4) scale (2) (11) (by decide) (by decide)
  · change ((2 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (2) scale (1) (11) (by decide) (by decide)
  · change ((2 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (2) scale (1) (11) (by decide) (by decide)
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (3 / 11 : ℚ)
    exact eq_smul_div (6) scale (3) (11) (by decide) (by decide)
  · change ((2 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (2) scale (1) (11) (by decide) (by decide)
  · change ((2 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (2) scale (1) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (4) scale (2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem AZ_scale_11 : toVec (AZ 11) = (scale : ℚ) • ACell11_3 := by
  funext i
  fin_cases i
  · change ((2 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (2) scale (1) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((2 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (2) scale (1) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (4) scale (2) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (4) scale (2) (11) (by decide) (by decide)
  · change ((2 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (2) scale (1) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((2 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (2) scale (1) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (3 / 11 : ℚ)
    exact eq_smul_div (6) scale (3) (11) (by decide) (by decide)

theorem AZ_scale_12 : toVec (AZ 12) = (scale : ℚ) • ACell12_3 := by
  funext i
  fin_cases i
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-2) scale (-1) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-2) scale (-1) (11) (by decide) (by decide)
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-2) scale (-1) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-2) scale (-1) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((2 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (2) scale (1) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)

theorem AZ_scale_13 : toVec (AZ 13) = (scale : ℚ) • ACell13_3 := by
  funext i
  fin_cases i
  · change ((-20 : ℤ) : ℚ) = (scale : ℚ) * (-10 / 11 : ℚ)
    exact eq_smul_div (-20) scale (-10) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-2) scale (-1) (11) (by decide) (by decide)
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-2) scale (-1) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-2) scale (-1) (11) (by decide) (by decide)
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-2) scale (-1) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)

theorem AZ_scale_14 : toVec (AZ 14) = (scale : ℚ) • ACell14_3 := by
  funext i
  fin_cases i
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (4) scale (2) (11) (by decide) (by decide)
  · change ((2 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (2) scale (1) (11) (by decide) (by decide)
  · change ((2 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (2) scale (1) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (4) scale (2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((2 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (2) scale (1) (11) (by decide) (by decide)
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (3 / 11 : ℚ)
    exact eq_smul_div (6) scale (3) (11) (by decide) (by decide)
  · change ((2 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (2) scale (1) (11) (by decide) (by decide)
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
  · change ((-3 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-3) scale (-3) (22) (by decide) (by decide)
  · change ((3 : ℤ) : ℚ) = (scale : ℚ) * (3 / 22 : ℚ)
    exact eq_smul_div (3) scale (3) (22) (by decide) (by decide)
  · change ((3 : ℤ) : ℚ) = (scale : ℚ) * (3 / 22 : ℚ)
    exact eq_smul_div (3) scale (3) (22) (by decide) (by decide)
  · change ((-3 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-3) scale (-3) (22) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem AZ_scale_16 : toVec (AZ 16) = (scale : ℚ) • ACell16_3 := by
  funext i
  fin_cases i
  · change ((-3 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-3) scale (-3) (22) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-3 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-3) scale (-3) (22) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((3 : ℤ) : ℚ) = (scale : ℚ) * (3 / 22 : ℚ)
    exact eq_smul_div (3) scale (3) (22) (by decide) (by decide)
  · change ((3 : ℤ) : ℚ) = (scale : ℚ) * (3 / 22 : ℚ)
    exact eq_smul_div (3) scale (3) (22) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem AZ_scale_17 : toVec (AZ 17) = (scale : ℚ) • ACell17_3 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-3 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-3) scale (-3) (22) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((3 : ℤ) : ℚ) = (scale : ℚ) * (3 / 22 : ℚ)
    exact eq_smul_div (3) scale (3) (22) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((3 : ℤ) : ℚ) = (scale : ℚ) * (3 / 22 : ℚ)
    exact eq_smul_div (3) scale (3) (22) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-3 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-3) scale (-3) (22) (by decide) (by decide)

theorem AZ_scale_18 : toVec (AZ 18) = (scale : ℚ) • ACell18_3 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-3 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-3) scale (-3) (22) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((3 : ℤ) : ℚ) = (scale : ℚ) * (3 / 22 : ℚ)
    exact eq_smul_div (3) scale (3) (22) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((3 : ℤ) : ℚ) = (scale : ℚ) * (3 / 22 : ℚ)
    exact eq_smul_div (3) scale (3) (22) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-3 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-3) scale (-3) (22) (by decide) (by decide)
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
  · change ((-3 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-3) scale (-3) (22) (by decide) (by decide)
  · change ((3 : ℤ) : ℚ) = (scale : ℚ) * (3 / 22 : ℚ)
    exact eq_smul_div (3) scale (3) (22) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((3 : ℤ) : ℚ) = (scale : ℚ) * (3 / 22 : ℚ)
    exact eq_smul_div (3) scale (3) (22) (by decide) (by decide)
  · change ((-3 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-3) scale (-3) (22) (by decide) (by decide)

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

theorem KZ_scale_0 : toVec (KZ 0) = (scale : ℚ) • KCell5_0 := by
  funext i
  fin_cases i
  · change ((-11 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 2 : ℚ)
    exact eq_smul_div (-11) scale (-1) (2) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((11 : ℤ) : ℚ) = (scale : ℚ) * (1 / 2 : ℚ)
    exact eq_smul_div (11) scale (1) (2) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-11 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 2 : ℚ)
    exact eq_smul_div (-11) scale (-1) (2) (by decide) (by decide)
  · change ((-11 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 2 : ℚ)
    exact eq_smul_div (-11) scale (-1) (2) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((11 : ℤ) : ℚ) = (scale : ℚ) * (1 / 2 : ℚ)
    exact eq_smul_div (11) scale (1) (2) (by decide) (by decide)

theorem KZ_scale_1 : toVec (KZ 1) = (scale : ℚ) • KCell5_1 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-22 : ℤ) : ℚ) = (scale : ℚ) * (-1 : ℚ)
    exact eq_smul_int (-22) scale (-1) (by decide)
  · change ((-11 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 2 : ℚ)
    exact eq_smul_div (-11) scale (-1) (2) (by decide) (by decide)
  · change ((11 : ℤ) : ℚ) = (scale : ℚ) * (1 / 2 : ℚ)
    exact eq_smul_div (11) scale (1) (2) (by decide) (by decide)
  · change ((11 : ℤ) : ℚ) = (scale : ℚ) * (1 / 2 : ℚ)
    exact eq_smul_div (11) scale (1) (2) (by decide) (by decide)
  · change ((-11 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 2 : ℚ)
    exact eq_smul_div (-11) scale (-1) (2) (by decide) (by decide)
  · change ((-22 : ℤ) : ℚ) = (scale : ℚ) * (-1 : ℚ)
    exact eq_smul_int (-22) scale (-1) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem KZ_scale (k : Fin 2) :
    toVec (KZ k) = (scale : ℚ) • KVec (5 : Fin 10) k := by
  fin_cases k
  · simp [KVec, KRow0]; exact KZ_scale_0
  · simp [KVec, KRow1]; exact KZ_scale_1

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

theorem YZ_scale_1 : toVec (YZ 1) = (scale : ℚ) • YCell1_3 := by
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
    toVec (YZ k) = (scale : ℚ) • YVec k (3 : Fin 10) := by
  fin_cases k
  · simp [YVec, YRow0]; exact YZ_scale_0
  · simp [YVec, YRow1]; exact YZ_scale_1

theorem entry_eq :
    (matrixMul XVec AVec + matrixMul KVec YVec)
        (5 : Fin 10) (3 : Fin 10) = ![0, 0, 0, 0, 0, 0, 0, 0, 0, 0] := by
  change (∑ k : Fin 20, mul (XVec (5 : Fin 10) k)
      (AVec k (3 : Fin 10))) +
    (∑ k : Fin 2, mul (KVec (5 : Fin 10) k)
      (YVec k (3 : Fin 10))) = _
  refine add_sum_mul_eq_of_scaled scale scale_ne_zero
    (fun k => XVec (5 : Fin 10) k)
    (fun k => AVec k (3 : Fin 10))
    (fun k => KVec (5 : Fin 10) k)
    (fun k => YVec k (3 : Fin 10))
    XZ AZ KZ YZ XZ_scale AZ_scale KZ_scale YZ_scale entryZ rfl _ ?_
  rw [entryZ_eq, toVec_zeroZ_smul, vec_zero_eq]

theorem entry_eq_matrixOne :
    (matrixMul XVec AVec + matrixMul KVec YVec)
        (5 : Fin 10) (3 : Fin 10) =
      matrixOne (Fin 10) (5 : Fin 10) (3 : Fin 10) := by
  rw [entry_eq]
  have hne : (5 : Fin 10) ≠ (3 : Fin 10) := by decide
  funext n
  fin_cases n <;> simp [matrixOne, constVec, basis, *]

end V14Formalization.D12PiecePPSplitEntry5_3
