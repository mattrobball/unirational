/- PA split identity, entry (2,2). Auto-generated. -/
import V14Formalization.D12PiecePAData
import V14Formalization.D12CyclotomicVecZ

noncomputable section
open Matrix
namespace V14Formalization.D12PiecePASplitEntry2_2
open D12CyclotomicVec D12CyclotomicVecZ D12PiecePAData
def payloadSha256 : String := "76c6196f29afe1a8398af99502447f48ebeed4bcb3805fc5dbec693940bc04b0"

def scale : ℤ := 22

def XZ (k : Fin 20) : VecZ :=
  match k.val with
  | 0 => #v[10, 20, 20, 18, 8, 23, 17, 13, 19, 17]
  | 1 => #v[-8, -6, -3, -4, -13, -6, -10, -6, -12, 2]
  | 2 => #v[-8, 16, 14, 5, 6, 9, 6, -1, 9, 10]
  | 3 => #v[1, 0, 2, 0, -8, 4, 7, 1, 0, 4]
  | 4 => #v[-3, 15, 9, -13, -1, 19, 3, -12, 9, 18]
  | 5 => #v[0, 6, -4, -2, 12, 18, -4, -6, -6, 8]
  | 6 => #v[-4, 2, 12, 4, -2, 8, 8, -12, 0, 6]
  | 7 => #v[14, -2, 0, 16, 0, -16, -4, 14, -4, -18]
  | 8 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  | 9 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  | 10 => #v[0, 0, 0, 0, 0, 11, 11, 0, 0, 0]
  | 11 => #v[-11, 0, 11, 0, -11, 0, 0, -11, 0, 11]
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
  | 0 => #v[2, -2, -2, -2, -2, 2, 0, 0, 4, 0]
  | 1 => #v[2, 2, 0, -2, 0, -2, 4, -2, 0, -2]
  | 2 => #v[-28, -2, -4, -6, -4, -4, -6, -4, -2, -6]
  | 3 => #v[-4, -2, -2, -4, -4, -2, -2, -4, 0, 2]
  | 4 => #v[-4, -4, -2, 2, -2, -4, -4, 0, -2, -2]
  | 5 => #v[0, 0, 0, 0, 0, 0, -3, 3, 3, -3]
  | 6 => #v[3, 3, 3, 0, 3, 3, 6, 6, 3, 3]
  | 7 => #v[-3, 0, -3, -3, -6, -3, -3, -6, -3, -3]
  | 8 => #v[0, -3, 0, 3, 0, 3, 0, -3, 0, 0]
  | 9 => #v[3, 3, 3, 3, 0, 6, 3, 3, 3, 6]
  | 10 => #v[2, 2, 0, -2, 0, -2, 4, -2, 0, -2]
  | 11 => #v[4, 6, 4, 0, 2, 2, 0, 0, 2, 2]
  | 12 => #v[26, 0, -2, -2, 2, 0, 0, 2, -2, -2]
  | 13 => #v[2, 4, 0, 6, 0, 4, 2, 0, 2, 2]
  | 14 => #v[-4, -4, -2, -6, -6, -6, -6, -2, -4, -4]
  | 15 => #v[3, 6, 3, 6, 3, 0, 3, 3, 3, 3]
  | 16 => #v[0, -3, 0, 0, 3, 0, 3, 0, 0, -3]
  | 17 => #v[-6, -3, -3, -3, -3, -6, 0, -3, -3, -3]
  | 18 => #v[0, -3, -3, 0, 0, 3, 0, 0, 0, 3]
  | 19 => #v[0, 0, 3, -3, -3, 3, 0, 0, 0, 0]
  | _ => zeroZ

theorem xaMulZ0 :
    mulZ (XZ 0) (AZ 0) = #v[34, 12, 82, 44, -62, 16, 10, -60, -2, -8] := by
  decide

theorem xaMulZ1 :
    mulZ (XZ 1) (AZ 1) = #v[40, -36, 32, -22, 34, -4, -16, -8, -12, 36] := by
  decide

theorem xaMulZ2 :
    mulZ (XZ 2) (AZ 2) = #v[228, -348, -250, -50, -138, -162, -96, 34, -214, -170] := by
  decide

theorem xaMulZ3 :
    mulZ (XZ 3) (AZ 3) = #v[30, -18, -40, 20, 62, 8, 2, 38, 28, -20] := by
  decide

theorem xaMulZ4 :
    mulZ (XZ 4) (AZ 4) = #v[178, 274, 90, 68, 260, 200, 8, 130, 308, 156] := by
  decide

theorem xaMulZ5 :
    mulZ (XZ 5) (AZ 5) = #v[60, 180, 96, 6, 24, 96, 114, 30, 102, 84] := by
  decide

theorem xaMulZ6 :
    mulZ (XZ 6) (AZ 6) = #v[-42, -60, -78, -72, -66, -96, -42, -54, -54, -30] := by
  decide

theorem xaMulZ7 :
    mulZ (XZ 7) (AZ 7) = #v[0, 150, 156, 6, 18, 96, 42, -66, 42, 84] := by
  decide

theorem xaMulZ8 :
    mulZ (XZ 8) (AZ 8) = #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0] := by
  decide

theorem xaMulZ9 :
    mulZ (XZ 9) (AZ 9) = #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0] := by
  decide

theorem xaMulZ10 :
    mulZ (XZ 10) (AZ 10) = #v[44, 44, 0, 0, 0, 44, 66, 44, 0, 0] := by
  decide

theorem xaMulZ11 :
    mulZ (XZ 11) (AZ 11) = #v[-88, -198, -88, 0, -132, -198, -88, -88, -198, -132] := by
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
  | 0 => #v[34, 12, 82, 44, -62, 16, 10, -60, -2, -8]
  | 1 => #v[40, -36, 32, -22, 34, -4, -16, -8, -12, 36]
  | 2 => #v[228, -348, -250, -50, -138, -162, -96, 34, -214, -170]
  | 3 => #v[30, -18, -40, 20, 62, 8, 2, 38, 28, -20]
  | 4 => #v[178, 274, 90, 68, 260, 200, 8, 130, 308, 156]
  | 5 => #v[60, 180, 96, 6, 24, 96, 114, 30, 102, 84]
  | 6 => #v[-42, -60, -78, -72, -66, -96, -42, -54, -54, -30]
  | 7 => #v[0, 150, 156, 6, 18, 96, 42, -66, 42, 84]
  | 8 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  | 9 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  | 10 => #v[44, 44, 0, 0, 0, 44, 66, 44, 0, 0]
  | 11 => #v[-88, -198, -88, 0, -132, -198, -88, -88, -198, -132]
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
    sumFin (fun k => mulZ (XZ k) (AZ k)) = #v[484, 0, 0, 0, 0, 0, 0, 0, 0, 0] := by
  have h : sumFin (fun k => mulZ (XZ k) (AZ k)) =
      sumFin xaMuls := congrArg sumFin (funext xaMulZ)
  rw [h]
  decide

def entryZ : VecZ := sumFin (fun k => mulZ (XZ k) (AZ k))

theorem entryZ_eq : entryZ = scaleSqE0 scale := by
  unfold entryZ
  rw [xaSum_eq]
  decide

theorem scale_ne_zero : scale ≠ 0 := by
  decide

theorem XZ_scale_0 : toVec (XZ 0) = (scale : ℚ) • XCell2_0 := by
  funext i
  fin_cases i
  · change ((10 : ℤ) : ℚ) = (scale : ℚ) * (5 / 11 : ℚ)
    exact eq_smul_div (10) scale (5) (11) (by decide) (by decide)
  · change ((20 : ℤ) : ℚ) = (scale : ℚ) * (10 / 11 : ℚ)
    exact eq_smul_div (20) scale (10) (11) (by decide) (by decide)
  · change ((20 : ℤ) : ℚ) = (scale : ℚ) * (10 / 11 : ℚ)
    exact eq_smul_div (20) scale (10) (11) (by decide) (by decide)
  · change ((18 : ℤ) : ℚ) = (scale : ℚ) * (9 / 11 : ℚ)
    exact eq_smul_div (18) scale (9) (11) (by decide) (by decide)
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (4 / 11 : ℚ)
    exact eq_smul_div (8) scale (4) (11) (by decide) (by decide)
  · change ((23 : ℤ) : ℚ) = (scale : ℚ) * (23 / 22 : ℚ)
    exact eq_smul_div (23) scale (23) (22) (by decide) (by decide)
  · change ((17 : ℤ) : ℚ) = (scale : ℚ) * (17 / 22 : ℚ)
    exact eq_smul_div (17) scale (17) (22) (by decide) (by decide)
  · change ((13 : ℤ) : ℚ) = (scale : ℚ) * (13 / 22 : ℚ)
    exact eq_smul_div (13) scale (13) (22) (by decide) (by decide)
  · change ((19 : ℤ) : ℚ) = (scale : ℚ) * (19 / 22 : ℚ)
    exact eq_smul_div (19) scale (19) (22) (by decide) (by decide)
  · change ((17 : ℤ) : ℚ) = (scale : ℚ) * (17 / 22 : ℚ)
    exact eq_smul_div (17) scale (17) (22) (by decide) (by decide)

theorem XZ_scale_1 : toVec (XZ 1) = (scale : ℚ) • XCell2_1 := by
  funext i
  fin_cases i
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-4 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-4) (11) (by decide) (by decide)
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 11 : ℚ)
    exact eq_smul_div (-6) scale (-3) (11) (by decide) (by decide)
  · change ((-3 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-3) scale (-3) (22) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((-13 : ℤ) : ℚ) = (scale : ℚ) * (-13 / 22 : ℚ)
    exact eq_smul_div (-13) scale (-13) (22) (by decide) (by decide)
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 11 : ℚ)
    exact eq_smul_div (-6) scale (-3) (11) (by decide) (by decide)
  · change ((-10 : ℤ) : ℚ) = (scale : ℚ) * (-5 / 11 : ℚ)
    exact eq_smul_div (-10) scale (-5) (11) (by decide) (by decide)
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 11 : ℚ)
    exact eq_smul_div (-6) scale (-3) (11) (by decide) (by decide)
  · change ((-12 : ℤ) : ℚ) = (scale : ℚ) * (-6 / 11 : ℚ)
    exact eq_smul_div (-12) scale (-6) (11) (by decide) (by decide)
  · change ((2 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (2) scale (1) (11) (by decide) (by decide)

theorem XZ_scale_2 : toVec (XZ 2) = (scale : ℚ) • XCell2_2 := by
  funext i
  fin_cases i
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-4 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-4) (11) (by decide) (by decide)
  · change ((16 : ℤ) : ℚ) = (scale : ℚ) * (8 / 11 : ℚ)
    exact eq_smul_div (16) scale (8) (11) (by decide) (by decide)
  · change ((14 : ℤ) : ℚ) = (scale : ℚ) * (7 / 11 : ℚ)
    exact eq_smul_div (14) scale (7) (11) (by decide) (by decide)
  · change ((5 : ℤ) : ℚ) = (scale : ℚ) * (5 / 22 : ℚ)
    exact eq_smul_div (5) scale (5) (22) (by decide) (by decide)
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (3 / 11 : ℚ)
    exact eq_smul_div (6) scale (3) (11) (by decide) (by decide)
  · change ((9 : ℤ) : ℚ) = (scale : ℚ) * (9 / 22 : ℚ)
    exact eq_smul_div (9) scale (9) (22) (by decide) (by decide)
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (3 / 11 : ℚ)
    exact eq_smul_div (6) scale (3) (11) (by decide) (by decide)
  · change ((-1 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 22 : ℚ)
    exact eq_smul_div (-1) scale (-1) (22) (by decide) (by decide)
  · change ((9 : ℤ) : ℚ) = (scale : ℚ) * (9 / 22 : ℚ)
    exact eq_smul_div (9) scale (9) (22) (by decide) (by decide)
  · change ((10 : ℤ) : ℚ) = (scale : ℚ) * (5 / 11 : ℚ)
    exact eq_smul_div (10) scale (5) (11) (by decide) (by decide)

theorem XZ_scale_3 : toVec (XZ 3) = (scale : ℚ) • XCell2_3 := by
  funext i
  fin_cases i
  · change ((1 : ℤ) : ℚ) = (scale : ℚ) * (1 / 22 : ℚ)
    exact eq_smul_div (1) scale (1) (22) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((2 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (2) scale (1) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-4 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-4) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (4) scale (2) (11) (by decide) (by decide)
  · change ((7 : ℤ) : ℚ) = (scale : ℚ) * (7 / 22 : ℚ)
    exact eq_smul_div (7) scale (7) (22) (by decide) (by decide)
  · change ((1 : ℤ) : ℚ) = (scale : ℚ) * (1 / 22 : ℚ)
    exact eq_smul_div (1) scale (1) (22) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (4) scale (2) (11) (by decide) (by decide)

theorem XZ_scale_4 : toVec (XZ 4) = (scale : ℚ) • XCell2_4 := by
  funext i
  fin_cases i
  · change ((-3 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-3) scale (-3) (22) (by decide) (by decide)
  · change ((15 : ℤ) : ℚ) = (scale : ℚ) * (15 / 22 : ℚ)
    exact eq_smul_div (15) scale (15) (22) (by decide) (by decide)
  · change ((9 : ℤ) : ℚ) = (scale : ℚ) * (9 / 22 : ℚ)
    exact eq_smul_div (9) scale (9) (22) (by decide) (by decide)
  · change ((-13 : ℤ) : ℚ) = (scale : ℚ) * (-13 / 22 : ℚ)
    exact eq_smul_div (-13) scale (-13) (22) (by decide) (by decide)
  · change ((-1 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 22 : ℚ)
    exact eq_smul_div (-1) scale (-1) (22) (by decide) (by decide)
  · change ((19 : ℤ) : ℚ) = (scale : ℚ) * (19 / 22 : ℚ)
    exact eq_smul_div (19) scale (19) (22) (by decide) (by decide)
  · change ((3 : ℤ) : ℚ) = (scale : ℚ) * (3 / 22 : ℚ)
    exact eq_smul_div (3) scale (3) (22) (by decide) (by decide)
  · change ((-12 : ℤ) : ℚ) = (scale : ℚ) * (-6 / 11 : ℚ)
    exact eq_smul_div (-12) scale (-6) (11) (by decide) (by decide)
  · change ((9 : ℤ) : ℚ) = (scale : ℚ) * (9 / 22 : ℚ)
    exact eq_smul_div (9) scale (9) (22) (by decide) (by decide)
  · change ((18 : ℤ) : ℚ) = (scale : ℚ) * (9 / 11 : ℚ)
    exact eq_smul_div (18) scale (9) (11) (by decide) (by decide)

theorem XZ_scale_5 : toVec (XZ 5) = (scale : ℚ) • XCell2_5 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (3 / 11 : ℚ)
    exact eq_smul_div (6) scale (3) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-2) scale (-1) (11) (by decide) (by decide)
  · change ((12 : ℤ) : ℚ) = (scale : ℚ) * (6 / 11 : ℚ)
    exact eq_smul_div (12) scale (6) (11) (by decide) (by decide)
  · change ((18 : ℤ) : ℚ) = (scale : ℚ) * (9 / 11 : ℚ)
    exact eq_smul_div (18) scale (9) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 11 : ℚ)
    exact eq_smul_div (-6) scale (-3) (11) (by decide) (by decide)
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 11 : ℚ)
    exact eq_smul_div (-6) scale (-3) (11) (by decide) (by decide)
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (4 / 11 : ℚ)
    exact eq_smul_div (8) scale (4) (11) (by decide) (by decide)

theorem XZ_scale_6 : toVec (XZ 6) = (scale : ℚ) • XCell2_6 := by
  funext i
  fin_cases i
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((2 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (2) scale (1) (11) (by decide) (by decide)
  · change ((12 : ℤ) : ℚ) = (scale : ℚ) * (6 / 11 : ℚ)
    exact eq_smul_div (12) scale (6) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (4) scale (2) (11) (by decide) (by decide)
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-2) scale (-1) (11) (by decide) (by decide)
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (4 / 11 : ℚ)
    exact eq_smul_div (8) scale (4) (11) (by decide) (by decide)
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (4 / 11 : ℚ)
    exact eq_smul_div (8) scale (4) (11) (by decide) (by decide)
  · change ((-12 : ℤ) : ℚ) = (scale : ℚ) * (-6 / 11 : ℚ)
    exact eq_smul_div (-12) scale (-6) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (3 / 11 : ℚ)
    exact eq_smul_div (6) scale (3) (11) (by decide) (by decide)

theorem XZ_scale_7 : toVec (XZ 7) = (scale : ℚ) • XCell2_7 := by
  funext i
  fin_cases i
  · change ((14 : ℤ) : ℚ) = (scale : ℚ) * (7 / 11 : ℚ)
    exact eq_smul_div (14) scale (7) (11) (by decide) (by decide)
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-2) scale (-1) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((16 : ℤ) : ℚ) = (scale : ℚ) * (8 / 11 : ℚ)
    exact eq_smul_div (16) scale (8) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-16 : ℤ) : ℚ) = (scale : ℚ) * (-8 / 11 : ℚ)
    exact eq_smul_div (-16) scale (-8) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((14 : ℤ) : ℚ) = (scale : ℚ) * (7 / 11 : ℚ)
    exact eq_smul_div (14) scale (7) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((-18 : ℤ) : ℚ) = (scale : ℚ) * (-9 / 11 : ℚ)
    exact eq_smul_div (-18) scale (-9) (11) (by decide) (by decide)

theorem XZ_scale_8 : toVec (XZ 8) = (scale : ℚ) • XCell2_8 := by
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

theorem XZ_scale_9 : toVec (XZ 9) = (scale : ℚ) • XCell2_9 := by
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

theorem XZ_scale_10 : toVec (XZ 10) = (scale : ℚ) • XCell2_10 := by
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
  · change ((11 : ℤ) : ℚ) = (scale : ℚ) * (1 / 2 : ℚ)
    exact eq_smul_div (11) scale (1) (2) (by decide) (by decide)
  · change ((11 : ℤ) : ℚ) = (scale : ℚ) * (1 / 2 : ℚ)
    exact eq_smul_div (11) scale (1) (2) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem XZ_scale_11 : toVec (XZ 11) = (scale : ℚ) • XCell2_11 := by
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
  · change ((-11 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 2 : ℚ)
    exact eq_smul_div (-11) scale (-1) (2) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-11 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 2 : ℚ)
    exact eq_smul_div (-11) scale (-1) (2) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((11 : ℤ) : ℚ) = (scale : ℚ) * (1 / 2 : ℚ)
    exact eq_smul_div (11) scale (1) (2) (by decide) (by decide)

theorem XZ_scale_12 : toVec (XZ 12) = (scale : ℚ) • XCell2_12 := by
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

theorem XZ_scale_13 : toVec (XZ 13) = (scale : ℚ) • XCell2_13 := by
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

theorem XZ_scale_14 : toVec (XZ 14) = (scale : ℚ) • XCell2_14 := by
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

theorem XZ_scale_15 : toVec (XZ 15) = (scale : ℚ) • XCell2_15 := by
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

theorem XZ_scale_16 : toVec (XZ 16) = (scale : ℚ) • XCell2_16 := by
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

theorem XZ_scale_17 : toVec (XZ 17) = (scale : ℚ) • XCell2_17 := by
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

theorem XZ_scale_18 : toVec (XZ 18) = (scale : ℚ) • XCell2_18 := by
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

theorem XZ_scale_19 : toVec (XZ 19) = (scale : ℚ) • XCell2_19 := by
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
    toVec (XZ k) = (scale : ℚ) • XVec (2 : Fin 10) k := by
  fin_cases k
  · simp [XVec, XRow2]; exact XZ_scale_0
  · simp [XVec, XRow2]; exact XZ_scale_1
  · simp [XVec, XRow2]; exact XZ_scale_2
  · simp [XVec, XRow2]; exact XZ_scale_3
  · simp [XVec, XRow2]; exact XZ_scale_4
  · simp [XVec, XRow2]; exact XZ_scale_5
  · simp [XVec, XRow2]; exact XZ_scale_6
  · simp [XVec, XRow2]; exact XZ_scale_7
  · simp [XVec, XRow2]; exact XZ_scale_8
  · simp [XVec, XRow2]; exact XZ_scale_9
  · simp [XVec, XRow2]; exact XZ_scale_10
  · simp [XVec, XRow2]; exact XZ_scale_11
  · simp [XVec, XRow2]; exact XZ_scale_12
  · simp [XVec, XRow2]; exact XZ_scale_13
  · simp [XVec, XRow2]; exact XZ_scale_14
  · simp [XVec, XRow2]; exact XZ_scale_15
  · simp [XVec, XRow2]; exact XZ_scale_16
  · simp [XVec, XRow2]; exact XZ_scale_17
  · simp [XVec, XRow2]; exact XZ_scale_18
  · simp [XVec, XRow2]; exact XZ_scale_19

theorem AZ_scale_0 : toVec (AZ 0) = (scale : ℚ) • ACell0_2 := by
  funext i
  fin_cases i
  · change ((2 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (2) scale (1) (11) (by decide) (by decide)
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-2) scale (-1) (11) (by decide) (by decide)
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-2) scale (-1) (11) (by decide) (by decide)
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-2) scale (-1) (11) (by decide) (by decide)
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-2) scale (-1) (11) (by decide) (by decide)
  · change ((2 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (2) scale (1) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (4) scale (2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem AZ_scale_1 : toVec (AZ 1) = (scale : ℚ) • ACell1_2 := by
  funext i
  fin_cases i
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
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-2) scale (-1) (11) (by decide) (by decide)

theorem AZ_scale_2 : toVec (AZ 2) = (scale : ℚ) • ACell2_2 := by
  funext i
  fin_cases i
  · change ((-28 : ℤ) : ℚ) = (scale : ℚ) * (-14 / 11 : ℚ)
    exact eq_smul_div (-28) scale (-14) (11) (by decide) (by decide)
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-2) scale (-1) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 11 : ℚ)
    exact eq_smul_div (-6) scale (-3) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 11 : ℚ)
    exact eq_smul_div (-6) scale (-3) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-2) scale (-1) (11) (by decide) (by decide)
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 11 : ℚ)
    exact eq_smul_div (-6) scale (-3) (11) (by decide) (by decide)

theorem AZ_scale_3 : toVec (AZ 3) = (scale : ℚ) • ACell3_2 := by
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

theorem AZ_scale_4 : toVec (AZ 4) = (scale : ℚ) • ACell4_2 := by
  funext i
  fin_cases i
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-2) scale (-1) (11) (by decide) (by decide)
  · change ((2 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (2) scale (1) (11) (by decide) (by decide)
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-2) scale (-1) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-2) scale (-1) (11) (by decide) (by decide)
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-2) scale (-1) (11) (by decide) (by decide)

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
  · change ((-3 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-3) scale (-3) (22) (by decide) (by decide)
  · change ((3 : ℤ) : ℚ) = (scale : ℚ) * (3 / 22 : ℚ)
    exact eq_smul_div (3) scale (3) (22) (by decide) (by decide)
  · change ((3 : ℤ) : ℚ) = (scale : ℚ) * (3 / 22 : ℚ)
    exact eq_smul_div (3) scale (3) (22) (by decide) (by decide)
  · change ((-3 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-3) scale (-3) (22) (by decide) (by decide)

theorem AZ_scale_6 : toVec (AZ 6) = (scale : ℚ) • ACell6_2 := by
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
  · change ((3 : ℤ) : ℚ) = (scale : ℚ) * (3 / 22 : ℚ)
    exact eq_smul_div (3) scale (3) (22) (by decide) (by decide)
  · change ((3 : ℤ) : ℚ) = (scale : ℚ) * (3 / 22 : ℚ)
    exact eq_smul_div (3) scale (3) (22) (by decide) (by decide)
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (3 / 11 : ℚ)
    exact eq_smul_div (6) scale (3) (11) (by decide) (by decide)
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (3 / 11 : ℚ)
    exact eq_smul_div (6) scale (3) (11) (by decide) (by decide)
  · change ((3 : ℤ) : ℚ) = (scale : ℚ) * (3 / 22 : ℚ)
    exact eq_smul_div (3) scale (3) (22) (by decide) (by decide)
  · change ((3 : ℤ) : ℚ) = (scale : ℚ) * (3 / 22 : ℚ)
    exact eq_smul_div (3) scale (3) (22) (by decide) (by decide)

theorem AZ_scale_7 : toVec (AZ 7) = (scale : ℚ) • ACell7_2 := by
  funext i
  fin_cases i
  · change ((-3 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-3) scale (-3) (22) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-3 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-3) scale (-3) (22) (by decide) (by decide)
  · change ((-3 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-3) scale (-3) (22) (by decide) (by decide)
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 11 : ℚ)
    exact eq_smul_div (-6) scale (-3) (11) (by decide) (by decide)
  · change ((-3 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-3) scale (-3) (22) (by decide) (by decide)
  · change ((-3 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-3) scale (-3) (22) (by decide) (by decide)
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 11 : ℚ)
    exact eq_smul_div (-6) scale (-3) (11) (by decide) (by decide)
  · change ((-3 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-3) scale (-3) (22) (by decide) (by decide)
  · change ((-3 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-3) scale (-3) (22) (by decide) (by decide)

theorem AZ_scale_8 : toVec (AZ 8) = (scale : ℚ) • ACell8_2 := by
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

theorem AZ_scale_9 : toVec (AZ 9) = (scale : ℚ) • ACell9_2 := by
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
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (3 / 11 : ℚ)
    exact eq_smul_div (6) scale (3) (11) (by decide) (by decide)

theorem AZ_scale_10 : toVec (AZ 10) = (scale : ℚ) • ACell10_2 := by
  funext i
  fin_cases i
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
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-2) scale (-1) (11) (by decide) (by decide)

theorem AZ_scale_11 : toVec (AZ 11) = (scale : ℚ) • ACell11_2 := by
  funext i
  fin_cases i
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (4) scale (2) (11) (by decide) (by decide)
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (3 / 11 : ℚ)
    exact eq_smul_div (6) scale (3) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (4) scale (2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((2 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (2) scale (1) (11) (by decide) (by decide)
  · change ((2 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (2) scale (1) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((2 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (2) scale (1) (11) (by decide) (by decide)
  · change ((2 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (2) scale (1) (11) (by decide) (by decide)

theorem AZ_scale_12 : toVec (AZ 12) = (scale : ℚ) • ACell12_2 := by
  funext i
  fin_cases i
  · change ((26 : ℤ) : ℚ) = (scale : ℚ) * (13 / 11 : ℚ)
    exact eq_smul_div (26) scale (13) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-2) scale (-1) (11) (by decide) (by decide)
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-2) scale (-1) (11) (by decide) (by decide)
  · change ((2 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (2) scale (1) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((2 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (2) scale (1) (11) (by decide) (by decide)
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-2) scale (-1) (11) (by decide) (by decide)
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-2) scale (-1) (11) (by decide) (by decide)

theorem AZ_scale_13 : toVec (AZ 13) = (scale : ℚ) • ACell13_2 := by
  funext i
  fin_cases i
  · change ((2 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (2) scale (1) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (4) scale (2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (3 / 11 : ℚ)
    exact eq_smul_div (6) scale (3) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (4) scale (2) (11) (by decide) (by decide)
  · change ((2 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (2) scale (1) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((2 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (2) scale (1) (11) (by decide) (by decide)
  · change ((2 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (2) scale (1) (11) (by decide) (by decide)

theorem AZ_scale_14 : toVec (AZ 14) = (scale : ℚ) • ACell14_2 := by
  funext i
  fin_cases i
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-2) scale (-1) (11) (by decide) (by decide)
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 11 : ℚ)
    exact eq_smul_div (-6) scale (-3) (11) (by decide) (by decide)
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 11 : ℚ)
    exact eq_smul_div (-6) scale (-3) (11) (by decide) (by decide)
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 11 : ℚ)
    exact eq_smul_div (-6) scale (-3) (11) (by decide) (by decide)
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 11 : ℚ)
    exact eq_smul_div (-6) scale (-3) (11) (by decide) (by decide)
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-2) scale (-1) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)

theorem AZ_scale_15 : toVec (AZ 15) = (scale : ℚ) • ACell15_2 := by
  funext i
  fin_cases i
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
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((3 : ℤ) : ℚ) = (scale : ℚ) * (3 / 22 : ℚ)
    exact eq_smul_div (3) scale (3) (22) (by decide) (by decide)
  · change ((3 : ℤ) : ℚ) = (scale : ℚ) * (3 / 22 : ℚ)
    exact eq_smul_div (3) scale (3) (22) (by decide) (by decide)
  · change ((3 : ℤ) : ℚ) = (scale : ℚ) * (3 / 22 : ℚ)
    exact eq_smul_div (3) scale (3) (22) (by decide) (by decide)
  · change ((3 : ℤ) : ℚ) = (scale : ℚ) * (3 / 22 : ℚ)
    exact eq_smul_div (3) scale (3) (22) (by decide) (by decide)

theorem AZ_scale_16 : toVec (AZ 16) = (scale : ℚ) • ACell16_2 := by
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

theorem AZ_scale_17 : toVec (AZ 17) = (scale : ℚ) • ACell17_2 := by
  funext i
  fin_cases i
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 11 : ℚ)
    exact eq_smul_div (-6) scale (-3) (11) (by decide) (by decide)
  · change ((-3 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-3) scale (-3) (22) (by decide) (by decide)
  · change ((-3 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-3) scale (-3) (22) (by decide) (by decide)
  · change ((-3 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-3) scale (-3) (22) (by decide) (by decide)
  · change ((-3 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-3) scale (-3) (22) (by decide) (by decide)
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 11 : ℚ)
    exact eq_smul_div (-6) scale (-3) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-3 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-3) scale (-3) (22) (by decide) (by decide)
  · change ((-3 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-3) scale (-3) (22) (by decide) (by decide)
  · change ((-3 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-3) scale (-3) (22) (by decide) (by decide)

theorem AZ_scale_18 : toVec (AZ 18) = (scale : ℚ) • ACell18_2 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-3 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-3) scale (-3) (22) (by decide) (by decide)
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
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((3 : ℤ) : ℚ) = (scale : ℚ) * (3 / 22 : ℚ)
    exact eq_smul_div (3) scale (3) (22) (by decide) (by decide)

theorem AZ_scale_19 : toVec (AZ 19) = (scale : ℚ) • ACell19_2 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((3 : ℤ) : ℚ) = (scale : ℚ) * (3 / 22 : ℚ)
    exact eq_smul_div (3) scale (3) (22) (by decide) (by decide)
  · change ((-3 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-3) scale (-3) (22) (by decide) (by decide)
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

theorem entry_eq :
    (matrixMul XVec AVec) (2 : Fin 10) (2 : Fin 10) =
      ![1, 0, 0, 0, 0, 0, 0, 0, 0, 0] := by
  unfold matrixMul
  refine sum_mul_eq_of_scaled scale scale_ne_zero
    (fun k => XVec (2 : Fin 10) k)
    (fun k => AVec k (2 : Fin 10))
    XZ AZ XZ_scale AZ_scale entryZ rfl _ ?_
  rw [entryZ_eq, toVec_scaleSqE0, constVec_one_eq]

theorem entry_eq_matrixOne :
    (matrixMul XVec AVec) (2 : Fin 10) (2 : Fin 10) =
      matrixOne (Fin 10) (2 : Fin 10) (2 : Fin 10) := by
  rw [entry_eq]
  funext n
  fin_cases n <;> simp [matrixOne, constVec, basis, *]

end V14Formalization.D12PiecePASplitEntry2_2
