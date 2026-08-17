/- PA split identity row 1: entry certificates inlined. Auto-generated. -/
module

import all Init.Data.Vector.Basic
import all Init.Data.Array.DecidableEq
public import V14Formalization.D12PiecePAData
public import V14Formalization.D12CyclotomicVecZ

noncomputable section
open Matrix

namespace V14Formalization.D12PiecePASplitEntry1_0
open D12CyclotomicVec D12CyclotomicVecZ D12PiecePAData
def payloadSha256 : String := "76c6196f29afe1a8398af99502447f48ebeed4bcb3805fc5dbec693940bc04b0"

def scale : ℤ := 22

def XZ (k : Fin 20) : VecZ :=
  match k.val with
  | 0 => #v[-3, -6, -5, -5, -5, -3, -4, -3, -3, -7]
  | 1 => #v[-6, 2, -2, 1, 0, -3, 0, -4, 0, 1]
  | 2 => #v[2, -1, -2, 0, 0, 0, -4, -1, -4, -1]
  | 3 => #v[0, -1, 1, 1, 2, -1, 0, 0, 0, -2]
  | 4 => #v[3, 0, 3, 3, 3, -3, 0, 3, 2, -3]
  | 5 => #v[-2, 0, 0, 0, 0, -4, 2, 2, 2, 0]
  | 6 => #v[-2, -8, -4, -4, -4, -4, -8, 0, -4, -6]
  | 7 => #v[-4, 0, 0, -6, -4, 0, -2, -6, 0, 0]
  | 8 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  | 9 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  | 10 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  | 11 => #v[11, 0, 0, 0, 0, 0, 0, 0, 0, 0]
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
  | 0 => #v[-24, -2, 0, 0, -2, 2, 4, 2, -2, 0]
  | 1 => #v[-2, 0, 2, -2, 4, -2, 2, 0, -2, 0]
  | 2 => #v[2, -2, -2, -2, -2, 2, 0, 0, 4, 0]
  | 3 => #v[4, 2, 2, 4, 0, 0, 2, 6, 2, 0]
  | 4 => #v[-2, 4, -2, 0, -2, 0, 2, 2, 0, -2]
  | 5 => #v[0, 0, 3, 0, 0, -3, -3, 0, 0, 3]
  | 6 => #v[0, 3, -3, 0, 0, 0, 0, -3, 3, 0]
  | 7 => #v[0, 0, 3, -3, -3, 3, 0, 0, 0, 0]
  | 8 => #v[0, -3, 0, -3, 0, 0, 3, 0, 0, 3]
  | 9 => #v[0, 0, 3, 0, -3, 0, -3, 0, 3, 0]
  | 10 => #v[28, 0, 4, 2, 0, 2, 2, 0, 2, 4]
  | 11 => #v[-2, -2, 0, -4, -4, -2, 2, -2, -4, -4]
  | 12 => #v[0, -2, -4, -2, -4, 2, -4, -2, -4, -2]
  | 13 => #v[2, -2, -2, -2, -2, 2, 0, 0, 4, 0]
  | 14 => #v[2, 2, 0, 4, 6, 4, 0, 2, 2, 0]
  | 15 => #v[3, 0, 0, 3, 0, 0, -3, 0, -3, 0]
  | 16 => #v[0, 0, 0, 3, -3, -3, 3, 0, 0, 0]
  | 17 => #v[-3, -6, -3, -6, -3, 0, -3, -3, -3, -3]
  | 18 => #v[3, 3, 3, 0, 6, 3, 3, 3, 3, 6]
  | 19 => #v[0, -3, 0, 0, 0, -3, 0, 0, 3, 3]
  | _ => zeroZ

def entryZ : VecZ := sumFin (fun k => mulZ (XZ k) (AZ k))

theorem entryZ_eq : entryZ = zeroZ := by
  decide +kernel

theorem scale_ne_zero : scale ≠ 0 := by
  decide

theorem XZ_scale_0 : toVec (XZ 0) = (scale : ℚ) • XCell1_0 := by
  funext i
  fin_cases i
  · change ((-3 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-3) scale (-3) (22) (by decide) (by decide)
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 11 : ℚ)
    exact eq_smul_div (-6) scale (-3) (11) (by decide) (by decide)
  · change ((-5 : ℤ) : ℚ) = (scale : ℚ) * (-5 / 22 : ℚ)
    exact eq_smul_div (-5) scale (-5) (22) (by decide) (by decide)
  · change ((-5 : ℤ) : ℚ) = (scale : ℚ) * (-5 / 22 : ℚ)
    exact eq_smul_div (-5) scale (-5) (22) (by decide) (by decide)
  · change ((-5 : ℤ) : ℚ) = (scale : ℚ) * (-5 / 22 : ℚ)
    exact eq_smul_div (-5) scale (-5) (22) (by decide) (by decide)
  · change ((-3 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-3) scale (-3) (22) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((-3 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-3) scale (-3) (22) (by decide) (by decide)
  · change ((-3 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-3) scale (-3) (22) (by decide) (by decide)
  · change ((-7 : ℤ) : ℚ) = (scale : ℚ) * (-7 / 22 : ℚ)
    exact eq_smul_div (-7) scale (-7) (22) (by decide) (by decide)

theorem XZ_scale_1 : toVec (XZ 1) = (scale : ℚ) • XCell1_1 := by
  funext i
  fin_cases i
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 11 : ℚ)
    exact eq_smul_div (-6) scale (-3) (11) (by decide) (by decide)
  · change ((2 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (2) scale (1) (11) (by decide) (by decide)
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-2) scale (-1) (11) (by decide) (by decide)
  · change ((1 : ℤ) : ℚ) = (scale : ℚ) * (1 / 22 : ℚ)
    exact eq_smul_div (1) scale (1) (22) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-3 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-3) scale (-3) (22) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((1 : ℤ) : ℚ) = (scale : ℚ) * (1 / 22 : ℚ)
    exact eq_smul_div (1) scale (1) (22) (by decide) (by decide)

theorem XZ_scale_2 : toVec (XZ 2) = (scale : ℚ) • XCell1_2 := by
  funext i
  fin_cases i
  · change ((2 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (2) scale (1) (11) (by decide) (by decide)
  · change ((-1 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 22 : ℚ)
    exact eq_smul_div (-1) scale (-1) (22) (by decide) (by decide)
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-2) scale (-1) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((-1 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 22 : ℚ)
    exact eq_smul_div (-1) scale (-1) (22) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((-1 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 22 : ℚ)
    exact eq_smul_div (-1) scale (-1) (22) (by decide) (by decide)

theorem XZ_scale_3 : toVec (XZ 3) = (scale : ℚ) • XCell1_3 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-1 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 22 : ℚ)
    exact eq_smul_div (-1) scale (-1) (22) (by decide) (by decide)
  · change ((1 : ℤ) : ℚ) = (scale : ℚ) * (1 / 22 : ℚ)
    exact eq_smul_div (1) scale (1) (22) (by decide) (by decide)
  · change ((1 : ℤ) : ℚ) = (scale : ℚ) * (1 / 22 : ℚ)
    exact eq_smul_div (1) scale (1) (22) (by decide) (by decide)
  · change ((2 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (2) scale (1) (11) (by decide) (by decide)
  · change ((-1 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 22 : ℚ)
    exact eq_smul_div (-1) scale (-1) (22) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-2) scale (-1) (11) (by decide) (by decide)

theorem XZ_scale_4 : toVec (XZ 4) = (scale : ℚ) • XCell1_4 := by
  funext i
  fin_cases i
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
  · change ((-3 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-3) scale (-3) (22) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((3 : ℤ) : ℚ) = (scale : ℚ) * (3 / 22 : ℚ)
    exact eq_smul_div (3) scale (3) (22) (by decide) (by decide)
  · change ((2 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (2) scale (1) (11) (by decide) (by decide)
  · change ((-3 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-3) scale (-3) (22) (by decide) (by decide)

theorem XZ_scale_5 : toVec (XZ 5) = (scale : ℚ) • XCell1_5 := by
  funext i
  fin_cases i
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-2) scale (-1) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((2 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (2) scale (1) (11) (by decide) (by decide)
  · change ((2 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (2) scale (1) (11) (by decide) (by decide)
  · change ((2 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (2) scale (1) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem XZ_scale_6 : toVec (XZ 6) = (scale : ℚ) • XCell1_6 := by
  funext i
  fin_cases i
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-2) scale (-1) (11) (by decide) (by decide)
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-4 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-4) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-4 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-4) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 11 : ℚ)
    exact eq_smul_div (-6) scale (-3) (11) (by decide) (by decide)

theorem XZ_scale_7 : toVec (XZ 7) = (scale : ℚ) • XCell1_7 := by
  funext i
  fin_cases i
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 11 : ℚ)
    exact eq_smul_div (-6) scale (-3) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-2) scale (-1) (11) (by decide) (by decide)
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 11 : ℚ)
    exact eq_smul_div (-6) scale (-3) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem XZ_scale_8 : toVec (XZ 8) = (scale : ℚ) • XCell1_8 := by
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

theorem XZ_scale_9 : toVec (XZ 9) = (scale : ℚ) • XCell1_9 := by
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

theorem XZ_scale_10 : toVec (XZ 10) = (scale : ℚ) • XCell1_10 := by
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

theorem XZ_scale_11 : toVec (XZ 11) = (scale : ℚ) • XCell1_11 := by
  funext i
  fin_cases i
  · change ((11 : ℤ) : ℚ) = (scale : ℚ) * (1 / 2 : ℚ)
    exact eq_smul_div (11) scale (1) (2) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem XZ_scale_12 : toVec (XZ 12) = (scale : ℚ) • XCell1_12 := by
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

theorem XZ_scale_13 : toVec (XZ 13) = (scale : ℚ) • XCell1_13 := by
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

theorem XZ_scale_14 : toVec (XZ 14) = (scale : ℚ) • XCell1_14 := by
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

theorem XZ_scale_15 : toVec (XZ 15) = (scale : ℚ) • XCell1_15 := by
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

theorem XZ_scale_16 : toVec (XZ 16) = (scale : ℚ) • XCell1_16 := by
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

theorem XZ_scale_17 : toVec (XZ 17) = (scale : ℚ) • XCell1_17 := by
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

theorem XZ_scale_18 : toVec (XZ 18) = (scale : ℚ) • XCell1_18 := by
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

theorem XZ_scale_19 : toVec (XZ 19) = (scale : ℚ) • XCell1_19 := by
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
    toVec (XZ k) = (scale : ℚ) • XVec (1 : Fin 10) k := by
  fin_cases k
  · simp [XVec, XRow1]; exact XZ_scale_0
  · simp [XVec, XRow1]; exact XZ_scale_1
  · simp [XVec, XRow1]; exact XZ_scale_2
  · simp [XVec, XRow1]; exact XZ_scale_3
  · simp [XVec, XRow1]; exact XZ_scale_4
  · simp [XVec, XRow1]; exact XZ_scale_5
  · simp [XVec, XRow1]; exact XZ_scale_6
  · simp [XVec, XRow1]; exact XZ_scale_7
  · simp [XVec, XRow1]; exact XZ_scale_8
  · simp [XVec, XRow1]; exact XZ_scale_9
  · simp [XVec, XRow1]; exact XZ_scale_10
  · simp [XVec, XRow1]; exact XZ_scale_11
  · simp [XVec, XRow1]; exact XZ_scale_12
  · simp [XVec, XRow1]; exact XZ_scale_13
  · simp [XVec, XRow1]; exact XZ_scale_14
  · simp [XVec, XRow1]; exact XZ_scale_15
  · simp [XVec, XRow1]; exact XZ_scale_16
  · simp [XVec, XRow1]; exact XZ_scale_17
  · simp [XVec, XRow1]; exact XZ_scale_18
  · simp [XVec, XRow1]; exact XZ_scale_19

theorem AZ_scale_0 : toVec (AZ 0) = (scale : ℚ) • ACell0_0 := by
  funext i
  fin_cases i
  · change ((-24 : ℤ) : ℚ) = (scale : ℚ) * (-12 / 11 : ℚ)
    exact eq_smul_div (-24) scale (-12) (11) (by decide) (by decide)
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-2) scale (-1) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-2) scale (-1) (11) (by decide) (by decide)
  · change ((2 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (2) scale (1) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (4) scale (2) (11) (by decide) (by decide)
  · change ((2 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (2) scale (1) (11) (by decide) (by decide)
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-2) scale (-1) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem AZ_scale_1 : toVec (AZ 1) = (scale : ℚ) • ACell1_0 := by
  funext i
  fin_cases i
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-2) scale (-1) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
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

theorem AZ_scale_2 : toVec (AZ 2) = (scale : ℚ) • ACell2_0 := by
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

theorem AZ_scale_3 : toVec (AZ 3) = (scale : ℚ) • ACell3_0 := by
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

theorem AZ_scale_4 : toVec (AZ 4) = (scale : ℚ) • ACell4_0 := by
  funext i
  fin_cases i
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

theorem AZ_scale_5 : toVec (AZ 5) = (scale : ℚ) • ACell5_0 := by
  funext i
  fin_cases i
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

theorem AZ_scale_6 : toVec (AZ 6) = (scale : ℚ) • ACell6_0 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
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
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-3 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-3) scale (-3) (22) (by decide) (by decide)
  · change ((3 : ℤ) : ℚ) = (scale : ℚ) * (3 / 22 : ℚ)
    exact eq_smul_div (3) scale (3) (22) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem AZ_scale_7 : toVec (AZ 7) = (scale : ℚ) • ACell7_0 := by
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

theorem AZ_scale_8 : toVec (AZ 8) = (scale : ℚ) • ACell8_0 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-3 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-3) scale (-3) (22) (by decide) (by decide)
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
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((3 : ℤ) : ℚ) = (scale : ℚ) * (3 / 22 : ℚ)
    exact eq_smul_div (3) scale (3) (22) (by decide) (by decide)

theorem AZ_scale_9 : toVec (AZ 9) = (scale : ℚ) • ACell9_0 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
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
  · change ((-3 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-3) scale (-3) (22) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((3 : ℤ) : ℚ) = (scale : ℚ) * (3 / 22 : ℚ)
    exact eq_smul_div (3) scale (3) (22) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem AZ_scale_10 : toVec (AZ 10) = (scale : ℚ) • ACell10_0 := by
  funext i
  fin_cases i
  · change ((28 : ℤ) : ℚ) = (scale : ℚ) * (14 / 11 : ℚ)
    exact eq_smul_div (28) scale (14) (11) (by decide) (by decide)
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
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((2 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (2) scale (1) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (4) scale (2) (11) (by decide) (by decide)

theorem AZ_scale_11 : toVec (AZ 11) = (scale : ℚ) • ACell11_0 := by
  funext i
  fin_cases i
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-2) scale (-1) (11) (by decide) (by decide)
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-2) scale (-1) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
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

theorem AZ_scale_12 : toVec (AZ 12) = (scale : ℚ) • ACell12_0 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-2) scale (-1) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-2) scale (-1) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((2 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (2) scale (1) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-2) scale (-1) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-2) scale (-1) (11) (by decide) (by decide)

theorem AZ_scale_13 : toVec (AZ 13) = (scale : ℚ) • ACell13_0 := by
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

theorem AZ_scale_14 : toVec (AZ 14) = (scale : ℚ) • ACell14_0 := by
  funext i
  fin_cases i
  · change ((2 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (2) scale (1) (11) (by decide) (by decide)
  · change ((2 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (2) scale (1) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
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

theorem AZ_scale_15 : toVec (AZ 15) = (scale : ℚ) • ACell15_0 := by
  funext i
  fin_cases i
  · change ((3 : ℤ) : ℚ) = (scale : ℚ) * (3 / 22 : ℚ)
    exact eq_smul_div (3) scale (3) (22) (by decide) (by decide)
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
  · change ((-3 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-3) scale (-3) (22) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-3 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-3) scale (-3) (22) (by decide) (by decide)
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

theorem AZ_scale_17 : toVec (AZ 17) = (scale : ℚ) • ACell17_0 := by
  funext i
  fin_cases i
  · change ((-3 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-3) scale (-3) (22) (by decide) (by decide)
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 11 : ℚ)
    exact eq_smul_div (-6) scale (-3) (11) (by decide) (by decide)
  · change ((-3 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-3) scale (-3) (22) (by decide) (by decide)
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 11 : ℚ)
    exact eq_smul_div (-6) scale (-3) (11) (by decide) (by decide)
  · change ((-3 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-3) scale (-3) (22) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-3 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-3) scale (-3) (22) (by decide) (by decide)
  · change ((-3 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-3) scale (-3) (22) (by decide) (by decide)
  · change ((-3 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-3) scale (-3) (22) (by decide) (by decide)
  · change ((-3 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-3) scale (-3) (22) (by decide) (by decide)

theorem AZ_scale_18 : toVec (AZ 18) = (scale : ℚ) • ACell18_0 := by
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

theorem AZ_scale_19 : toVec (AZ 19) = (scale : ℚ) • ACell19_0 := by
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

theorem entry_eq :
    (matrixMul XVec AVec) (1 : Fin 10) (0 : Fin 10) =
      ![0, 0, 0, 0, 0, 0, 0, 0, 0, 0] := by
  unfold matrixMul
  refine sum_mul_eq_of_scaled scale scale_ne_zero
    (fun k => XVec (1 : Fin 10) k)
    (fun k => AVec k (0 : Fin 10))
    XZ AZ XZ_scale AZ_scale entryZ rfl _ ?_
  rw [entryZ_eq, toVec_zeroZ_smul, vec_zero_eq]

theorem entry_eq_matrixOne :
    (matrixMul XVec AVec) (1 : Fin 10) (0 : Fin 10) =
      matrixOne (Fin 10) (1 : Fin 10) (0 : Fin 10) := by
  rw [entry_eq]
  have hne : (1 : Fin 10) ≠ (0 : Fin 10) := by decide
  funext n
  fin_cases n <;> simp [matrixOne, constVec, basis, *]

end V14Formalization.D12PiecePASplitEntry1_0


namespace V14Formalization.D12PiecePASplitEntry1_1
open D12CyclotomicVec D12CyclotomicVecZ D12PiecePAData
def payloadSha256 : String := "76c6196f29afe1a8398af99502447f48ebeed4bcb3805fc5dbec693940bc04b0"

def scale : ℤ := 22

def XZ (k : Fin 20) : VecZ :=
  match k.val with
  | 0 => #v[-3, -6, -5, -5, -5, -3, -4, -3, -3, -7]
  | 1 => #v[-6, 2, -2, 1, 0, -3, 0, -4, 0, 1]
  | 2 => #v[2, -1, -2, 0, 0, 0, -4, -1, -4, -1]
  | 3 => #v[0, -1, 1, 1, 2, -1, 0, 0, 0, -2]
  | 4 => #v[3, 0, 3, 3, 3, -3, 0, 3, 2, -3]
  | 5 => #v[-2, 0, 0, 0, 0, -4, 2, 2, 2, 0]
  | 6 => #v[-2, -8, -4, -4, -4, -4, -8, 0, -4, -6]
  | 7 => #v[-4, 0, 0, -6, -4, 0, -2, -6, 0, 0]
  | 8 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  | 9 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  | 10 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  | 11 => #v[11, 0, 0, 0, 0, 0, 0, 0, 0, 0]
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
  | 0 => #v[-2, 0, 2, -2, 4, -2, 2, 0, -2, 0]
  | 1 => #v[-22, 2, 6, 2, 0, 0, 4, 2, 2, 4]
  | 2 => #v[2, 2, 0, -2, 0, -2, 4, -2, 0, -2]
  | 3 => #v[0, 0, 4, 2, 2, 6, 2, 2, 4, 0]
  | 4 => #v[-2, -6, -4, -4, -6, -6, -4, -4, -6, -2]
  | 5 => #v[3, 3, 6, 3, 3, 6, 3, 3, 0, 3]
  | 6 => #v[0, 3, -3, -3, 3, 0, 0, 0, 0, 0]
  | 7 => #v[-3, -3, -3, -3, 0, -3, -6, -3, -6, -3]
  | 8 => #v[0, 0, -3, 3, 0, 0, 0, 0, 3, -3]
  | 9 => #v[0, -3, 0, 0, 0, -3, 0, 0, 3, 3]
  | 10 => #v[0, 2, -2, -2, 0, 4, 0, -2, -2, 2]
  | 11 => #v[26, 0, 0, 2, -2, -2, -2, -2, 2, 0]
  | 12 => #v[-2, -6, -4, -4, -6, -6, -4, -4, -6, -2]
  | 13 => #v[2, 0, 6, 0, 2, 0, 2, 4, 4, 2]
  | 14 => #v[4, 2, 0, 2, 2, 0, 2, 4, 0, 6]
  | 15 => #v[3, 3, 3, 0, 6, 3, 3, 3, 3, 6]
  | 16 => #v[0, 3, 0, -3, 0, -3, 0, 3, 0, 0]
  | 17 => #v[0, 3, 3, 0, 0, -3, 0, 0, 0, -3]
  | 18 => #v[6, 6, 0, 3, 3, 3, 3, 3, 3, 3]
  | 19 => #v[0, -3, 0, 0, -3, 0, 0, 3, 0, 3]
  | _ => zeroZ

def entryZ : VecZ := sumFin (fun k => mulZ (XZ k) (AZ k))

theorem entryZ_eq : entryZ = scaleSqE0 scale := by
  decide +kernel

theorem scale_ne_zero : scale ≠ 0 := by
  decide

theorem XZ_scale_0 : toVec (XZ 0) = (scale : ℚ) • XCell1_0 := by
  funext i
  fin_cases i
  · change ((-3 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-3) scale (-3) (22) (by decide) (by decide)
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 11 : ℚ)
    exact eq_smul_div (-6) scale (-3) (11) (by decide) (by decide)
  · change ((-5 : ℤ) : ℚ) = (scale : ℚ) * (-5 / 22 : ℚ)
    exact eq_smul_div (-5) scale (-5) (22) (by decide) (by decide)
  · change ((-5 : ℤ) : ℚ) = (scale : ℚ) * (-5 / 22 : ℚ)
    exact eq_smul_div (-5) scale (-5) (22) (by decide) (by decide)
  · change ((-5 : ℤ) : ℚ) = (scale : ℚ) * (-5 / 22 : ℚ)
    exact eq_smul_div (-5) scale (-5) (22) (by decide) (by decide)
  · change ((-3 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-3) scale (-3) (22) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((-3 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-3) scale (-3) (22) (by decide) (by decide)
  · change ((-3 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-3) scale (-3) (22) (by decide) (by decide)
  · change ((-7 : ℤ) : ℚ) = (scale : ℚ) * (-7 / 22 : ℚ)
    exact eq_smul_div (-7) scale (-7) (22) (by decide) (by decide)

theorem XZ_scale_1 : toVec (XZ 1) = (scale : ℚ) • XCell1_1 := by
  funext i
  fin_cases i
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 11 : ℚ)
    exact eq_smul_div (-6) scale (-3) (11) (by decide) (by decide)
  · change ((2 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (2) scale (1) (11) (by decide) (by decide)
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-2) scale (-1) (11) (by decide) (by decide)
  · change ((1 : ℤ) : ℚ) = (scale : ℚ) * (1 / 22 : ℚ)
    exact eq_smul_div (1) scale (1) (22) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-3 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-3) scale (-3) (22) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((1 : ℤ) : ℚ) = (scale : ℚ) * (1 / 22 : ℚ)
    exact eq_smul_div (1) scale (1) (22) (by decide) (by decide)

theorem XZ_scale_2 : toVec (XZ 2) = (scale : ℚ) • XCell1_2 := by
  funext i
  fin_cases i
  · change ((2 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (2) scale (1) (11) (by decide) (by decide)
  · change ((-1 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 22 : ℚ)
    exact eq_smul_div (-1) scale (-1) (22) (by decide) (by decide)
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-2) scale (-1) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((-1 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 22 : ℚ)
    exact eq_smul_div (-1) scale (-1) (22) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((-1 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 22 : ℚ)
    exact eq_smul_div (-1) scale (-1) (22) (by decide) (by decide)

theorem XZ_scale_3 : toVec (XZ 3) = (scale : ℚ) • XCell1_3 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-1 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 22 : ℚ)
    exact eq_smul_div (-1) scale (-1) (22) (by decide) (by decide)
  · change ((1 : ℤ) : ℚ) = (scale : ℚ) * (1 / 22 : ℚ)
    exact eq_smul_div (1) scale (1) (22) (by decide) (by decide)
  · change ((1 : ℤ) : ℚ) = (scale : ℚ) * (1 / 22 : ℚ)
    exact eq_smul_div (1) scale (1) (22) (by decide) (by decide)
  · change ((2 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (2) scale (1) (11) (by decide) (by decide)
  · change ((-1 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 22 : ℚ)
    exact eq_smul_div (-1) scale (-1) (22) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-2) scale (-1) (11) (by decide) (by decide)

theorem XZ_scale_4 : toVec (XZ 4) = (scale : ℚ) • XCell1_4 := by
  funext i
  fin_cases i
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
  · change ((-3 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-3) scale (-3) (22) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((3 : ℤ) : ℚ) = (scale : ℚ) * (3 / 22 : ℚ)
    exact eq_smul_div (3) scale (3) (22) (by decide) (by decide)
  · change ((2 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (2) scale (1) (11) (by decide) (by decide)
  · change ((-3 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-3) scale (-3) (22) (by decide) (by decide)

theorem XZ_scale_5 : toVec (XZ 5) = (scale : ℚ) • XCell1_5 := by
  funext i
  fin_cases i
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-2) scale (-1) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((2 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (2) scale (1) (11) (by decide) (by decide)
  · change ((2 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (2) scale (1) (11) (by decide) (by decide)
  · change ((2 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (2) scale (1) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem XZ_scale_6 : toVec (XZ 6) = (scale : ℚ) • XCell1_6 := by
  funext i
  fin_cases i
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-2) scale (-1) (11) (by decide) (by decide)
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-4 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-4) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-4 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-4) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 11 : ℚ)
    exact eq_smul_div (-6) scale (-3) (11) (by decide) (by decide)

theorem XZ_scale_7 : toVec (XZ 7) = (scale : ℚ) • XCell1_7 := by
  funext i
  fin_cases i
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 11 : ℚ)
    exact eq_smul_div (-6) scale (-3) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-2) scale (-1) (11) (by decide) (by decide)
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 11 : ℚ)
    exact eq_smul_div (-6) scale (-3) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem XZ_scale_8 : toVec (XZ 8) = (scale : ℚ) • XCell1_8 := by
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

theorem XZ_scale_9 : toVec (XZ 9) = (scale : ℚ) • XCell1_9 := by
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

theorem XZ_scale_10 : toVec (XZ 10) = (scale : ℚ) • XCell1_10 := by
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

theorem XZ_scale_11 : toVec (XZ 11) = (scale : ℚ) • XCell1_11 := by
  funext i
  fin_cases i
  · change ((11 : ℤ) : ℚ) = (scale : ℚ) * (1 / 2 : ℚ)
    exact eq_smul_div (11) scale (1) (2) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem XZ_scale_12 : toVec (XZ 12) = (scale : ℚ) • XCell1_12 := by
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

theorem XZ_scale_13 : toVec (XZ 13) = (scale : ℚ) • XCell1_13 := by
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

theorem XZ_scale_14 : toVec (XZ 14) = (scale : ℚ) • XCell1_14 := by
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

theorem XZ_scale_15 : toVec (XZ 15) = (scale : ℚ) • XCell1_15 := by
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

theorem XZ_scale_16 : toVec (XZ 16) = (scale : ℚ) • XCell1_16 := by
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

theorem XZ_scale_17 : toVec (XZ 17) = (scale : ℚ) • XCell1_17 := by
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

theorem XZ_scale_18 : toVec (XZ 18) = (scale : ℚ) • XCell1_18 := by
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

theorem XZ_scale_19 : toVec (XZ 19) = (scale : ℚ) • XCell1_19 := by
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
    toVec (XZ k) = (scale : ℚ) • XVec (1 : Fin 10) k := by
  fin_cases k
  · simp [XVec, XRow1]; exact XZ_scale_0
  · simp [XVec, XRow1]; exact XZ_scale_1
  · simp [XVec, XRow1]; exact XZ_scale_2
  · simp [XVec, XRow1]; exact XZ_scale_3
  · simp [XVec, XRow1]; exact XZ_scale_4
  · simp [XVec, XRow1]; exact XZ_scale_5
  · simp [XVec, XRow1]; exact XZ_scale_6
  · simp [XVec, XRow1]; exact XZ_scale_7
  · simp [XVec, XRow1]; exact XZ_scale_8
  · simp [XVec, XRow1]; exact XZ_scale_9
  · simp [XVec, XRow1]; exact XZ_scale_10
  · simp [XVec, XRow1]; exact XZ_scale_11
  · simp [XVec, XRow1]; exact XZ_scale_12
  · simp [XVec, XRow1]; exact XZ_scale_13
  · simp [XVec, XRow1]; exact XZ_scale_14
  · simp [XVec, XRow1]; exact XZ_scale_15
  · simp [XVec, XRow1]; exact XZ_scale_16
  · simp [XVec, XRow1]; exact XZ_scale_17
  · simp [XVec, XRow1]; exact XZ_scale_18
  · simp [XVec, XRow1]; exact XZ_scale_19

theorem AZ_scale_0 : toVec (AZ 0) = (scale : ℚ) • ACell0_1 := by
  funext i
  fin_cases i
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-2) scale (-1) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
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

theorem AZ_scale_1 : toVec (AZ 1) = (scale : ℚ) • ACell1_1 := by
  funext i
  fin_cases i
  · change ((-22 : ℤ) : ℚ) = (scale : ℚ) * (-1 : ℚ)
    exact eq_smul_int (-22) scale (-1) (by decide)
  · change ((2 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (2) scale (1) (11) (by decide) (by decide)
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (3 / 11 : ℚ)
    exact eq_smul_div (6) scale (3) (11) (by decide) (by decide)
  · change ((2 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (2) scale (1) (11) (by decide) (by decide)
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
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (4) scale (2) (11) (by decide) (by decide)

theorem AZ_scale_2 : toVec (AZ 2) = (scale : ℚ) • ACell2_1 := by
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

theorem AZ_scale_3 : toVec (AZ 3) = (scale : ℚ) • ACell3_1 := by
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

theorem AZ_scale_4 : toVec (AZ 4) = (scale : ℚ) • ACell4_1 := by
  funext i
  fin_cases i
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-2) scale (-1) (11) (by decide) (by decide)
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 11 : ℚ)
    exact eq_smul_div (-6) scale (-3) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 11 : ℚ)
    exact eq_smul_div (-6) scale (-3) (11) (by decide) (by decide)
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 11 : ℚ)
    exact eq_smul_div (-6) scale (-3) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 11 : ℚ)
    exact eq_smul_div (-6) scale (-3) (11) (by decide) (by decide)
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-2) scale (-1) (11) (by decide) (by decide)

theorem AZ_scale_5 : toVec (AZ 5) = (scale : ℚ) • ACell5_1 := by
  funext i
  fin_cases i
  · change ((3 : ℤ) : ℚ) = (scale : ℚ) * (3 / 22 : ℚ)
    exact eq_smul_div (3) scale (3) (22) (by decide) (by decide)
  · change ((3 : ℤ) : ℚ) = (scale : ℚ) * (3 / 22 : ℚ)
    exact eq_smul_div (3) scale (3) (22) (by decide) (by decide)
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (3 / 11 : ℚ)
    exact eq_smul_div (6) scale (3) (11) (by decide) (by decide)
  · change ((3 : ℤ) : ℚ) = (scale : ℚ) * (3 / 22 : ℚ)
    exact eq_smul_div (3) scale (3) (22) (by decide) (by decide)
  · change ((3 : ℤ) : ℚ) = (scale : ℚ) * (3 / 22 : ℚ)
    exact eq_smul_div (3) scale (3) (22) (by decide) (by decide)
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (3 / 11 : ℚ)
    exact eq_smul_div (6) scale (3) (11) (by decide) (by decide)
  · change ((3 : ℤ) : ℚ) = (scale : ℚ) * (3 / 22 : ℚ)
    exact eq_smul_div (3) scale (3) (22) (by decide) (by decide)
  · change ((3 : ℤ) : ℚ) = (scale : ℚ) * (3 / 22 : ℚ)
    exact eq_smul_div (3) scale (3) (22) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((3 : ℤ) : ℚ) = (scale : ℚ) * (3 / 22 : ℚ)
    exact eq_smul_div (3) scale (3) (22) (by decide) (by decide)

theorem AZ_scale_6 : toVec (AZ 6) = (scale : ℚ) • ACell6_1 := by
  funext i
  fin_cases i
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
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem AZ_scale_7 : toVec (AZ 7) = (scale : ℚ) • ACell7_1 := by
  funext i
  fin_cases i
  · change ((-3 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-3) scale (-3) (22) (by decide) (by decide)
  · change ((-3 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-3) scale (-3) (22) (by decide) (by decide)
  · change ((-3 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-3) scale (-3) (22) (by decide) (by decide)
  · change ((-3 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-3) scale (-3) (22) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-3 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-3) scale (-3) (22) (by decide) (by decide)
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 11 : ℚ)
    exact eq_smul_div (-6) scale (-3) (11) (by decide) (by decide)
  · change ((-3 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-3) scale (-3) (22) (by decide) (by decide)
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 11 : ℚ)
    exact eq_smul_div (-6) scale (-3) (11) (by decide) (by decide)
  · change ((-3 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-3) scale (-3) (22) (by decide) (by decide)

theorem AZ_scale_8 : toVec (AZ 8) = (scale : ℚ) • ACell8_1 := by
  funext i
  fin_cases i
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
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((3 : ℤ) : ℚ) = (scale : ℚ) * (3 / 22 : ℚ)
    exact eq_smul_div (3) scale (3) (22) (by decide) (by decide)
  · change ((-3 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-3) scale (-3) (22) (by decide) (by decide)

theorem AZ_scale_9 : toVec (AZ 9) = (scale : ℚ) • ACell9_1 := by
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

theorem AZ_scale_10 : toVec (AZ 10) = (scale : ℚ) • ACell10_1 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((2 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (2) scale (1) (11) (by decide) (by decide)
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-2) scale (-1) (11) (by decide) (by decide)
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-2) scale (-1) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (4) scale (2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-2) scale (-1) (11) (by decide) (by decide)
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-2) scale (-1) (11) (by decide) (by decide)
  · change ((2 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (2) scale (1) (11) (by decide) (by decide)

theorem AZ_scale_11 : toVec (AZ 11) = (scale : ℚ) • ACell11_1 := by
  funext i
  fin_cases i
  · change ((26 : ℤ) : ℚ) = (scale : ℚ) * (13 / 11 : ℚ)
    exact eq_smul_div (26) scale (13) (11) (by decide) (by decide)
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
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-2) scale (-1) (11) (by decide) (by decide)
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-2) scale (-1) (11) (by decide) (by decide)
  · change ((2 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (2) scale (1) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem AZ_scale_12 : toVec (AZ 12) = (scale : ℚ) • ACell12_1 := by
  funext i
  fin_cases i
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-2) scale (-1) (11) (by decide) (by decide)
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 11 : ℚ)
    exact eq_smul_div (-6) scale (-3) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 11 : ℚ)
    exact eq_smul_div (-6) scale (-3) (11) (by decide) (by decide)
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 11 : ℚ)
    exact eq_smul_div (-6) scale (-3) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 11 : ℚ)
    exact eq_smul_div (-6) scale (-3) (11) (by decide) (by decide)
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-2) scale (-1) (11) (by decide) (by decide)

theorem AZ_scale_13 : toVec (AZ 13) = (scale : ℚ) • ACell13_1 := by
  funext i
  fin_cases i
  · change ((2 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (2) scale (1) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (3 / 11 : ℚ)
    exact eq_smul_div (6) scale (3) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
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

theorem AZ_scale_14 : toVec (AZ 14) = (scale : ℚ) • ACell14_1 := by
  funext i
  fin_cases i
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
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((2 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (2) scale (1) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (4) scale (2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (3 / 11 : ℚ)
    exact eq_smul_div (6) scale (3) (11) (by decide) (by decide)

theorem AZ_scale_15 : toVec (AZ 15) = (scale : ℚ) • ACell15_1 := by
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

theorem AZ_scale_16 : toVec (AZ 16) = (scale : ℚ) • ACell16_1 := by
  funext i
  fin_cases i
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
  · change ((-3 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-3) scale (-3) (22) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((3 : ℤ) : ℚ) = (scale : ℚ) * (3 / 22 : ℚ)
    exact eq_smul_div (3) scale (3) (22) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem AZ_scale_17 : toVec (AZ 17) = (scale : ℚ) • ACell17_1 := by
  funext i
  fin_cases i
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
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-3 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-3) scale (-3) (22) (by decide) (by decide)

theorem AZ_scale_18 : toVec (AZ 18) = (scale : ℚ) • ACell18_1 := by
  funext i
  fin_cases i
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (3 / 11 : ℚ)
    exact eq_smul_div (6) scale (3) (11) (by decide) (by decide)
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (3 / 11 : ℚ)
    exact eq_smul_div (6) scale (3) (11) (by decide) (by decide)
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
  · change ((3 : ℤ) : ℚ) = (scale : ℚ) * (3 / 22 : ℚ)
    exact eq_smul_div (3) scale (3) (22) (by decide) (by decide)
  · change ((3 : ℤ) : ℚ) = (scale : ℚ) * (3 / 22 : ℚ)
    exact eq_smul_div (3) scale (3) (22) (by decide) (by decide)
  · change ((3 : ℤ) : ℚ) = (scale : ℚ) * (3 / 22 : ℚ)
    exact eq_smul_div (3) scale (3) (22) (by decide) (by decide)

theorem AZ_scale_19 : toVec (AZ 19) = (scale : ℚ) • ACell19_1 := by
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

theorem entry_eq :
    (matrixMul XVec AVec) (1 : Fin 10) (1 : Fin 10) =
      ![1, 0, 0, 0, 0, 0, 0, 0, 0, 0] := by
  unfold matrixMul
  refine sum_mul_eq_of_scaled scale scale_ne_zero
    (fun k => XVec (1 : Fin 10) k)
    (fun k => AVec k (1 : Fin 10))
    XZ AZ XZ_scale AZ_scale entryZ rfl _ ?_
  rw [entryZ_eq, toVec_scaleSqE0, constVec_one_eq]

theorem entry_eq_matrixOne :
    (matrixMul XVec AVec) (1 : Fin 10) (1 : Fin 10) =
      matrixOne (Fin 10) (1 : Fin 10) (1 : Fin 10) := by
  rw [entry_eq]
  funext n
  fin_cases n <;> simp [matrixOne, constVec, basis, *]

end V14Formalization.D12PiecePASplitEntry1_1


namespace V14Formalization.D12PiecePASplitEntry1_2
open D12CyclotomicVec D12CyclotomicVecZ D12PiecePAData
def payloadSha256 : String := "76c6196f29afe1a8398af99502447f48ebeed4bcb3805fc5dbec693940bc04b0"

def scale : ℤ := 22

def XZ (k : Fin 20) : VecZ :=
  match k.val with
  | 0 => #v[-3, -6, -5, -5, -5, -3, -4, -3, -3, -7]
  | 1 => #v[-6, 2, -2, 1, 0, -3, 0, -4, 0, 1]
  | 2 => #v[2, -1, -2, 0, 0, 0, -4, -1, -4, -1]
  | 3 => #v[0, -1, 1, 1, 2, -1, 0, 0, 0, -2]
  | 4 => #v[3, 0, 3, 3, 3, -3, 0, 3, 2, -3]
  | 5 => #v[-2, 0, 0, 0, 0, -4, 2, 2, 2, 0]
  | 6 => #v[-2, -8, -4, -4, -4, -4, -8, 0, -4, -6]
  | 7 => #v[-4, 0, 0, -6, -4, 0, -2, -6, 0, 0]
  | 8 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  | 9 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  | 10 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  | 11 => #v[11, 0, 0, 0, 0, 0, 0, 0, 0, 0]
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

def entryZ : VecZ := sumFin (fun k => mulZ (XZ k) (AZ k))

theorem entryZ_eq : entryZ = zeroZ := by
  decide +kernel

theorem scale_ne_zero : scale ≠ 0 := by
  decide

theorem XZ_scale_0 : toVec (XZ 0) = (scale : ℚ) • XCell1_0 := by
  funext i
  fin_cases i
  · change ((-3 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-3) scale (-3) (22) (by decide) (by decide)
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 11 : ℚ)
    exact eq_smul_div (-6) scale (-3) (11) (by decide) (by decide)
  · change ((-5 : ℤ) : ℚ) = (scale : ℚ) * (-5 / 22 : ℚ)
    exact eq_smul_div (-5) scale (-5) (22) (by decide) (by decide)
  · change ((-5 : ℤ) : ℚ) = (scale : ℚ) * (-5 / 22 : ℚ)
    exact eq_smul_div (-5) scale (-5) (22) (by decide) (by decide)
  · change ((-5 : ℤ) : ℚ) = (scale : ℚ) * (-5 / 22 : ℚ)
    exact eq_smul_div (-5) scale (-5) (22) (by decide) (by decide)
  · change ((-3 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-3) scale (-3) (22) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((-3 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-3) scale (-3) (22) (by decide) (by decide)
  · change ((-3 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-3) scale (-3) (22) (by decide) (by decide)
  · change ((-7 : ℤ) : ℚ) = (scale : ℚ) * (-7 / 22 : ℚ)
    exact eq_smul_div (-7) scale (-7) (22) (by decide) (by decide)

theorem XZ_scale_1 : toVec (XZ 1) = (scale : ℚ) • XCell1_1 := by
  funext i
  fin_cases i
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 11 : ℚ)
    exact eq_smul_div (-6) scale (-3) (11) (by decide) (by decide)
  · change ((2 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (2) scale (1) (11) (by decide) (by decide)
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-2) scale (-1) (11) (by decide) (by decide)
  · change ((1 : ℤ) : ℚ) = (scale : ℚ) * (1 / 22 : ℚ)
    exact eq_smul_div (1) scale (1) (22) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-3 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-3) scale (-3) (22) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((1 : ℤ) : ℚ) = (scale : ℚ) * (1 / 22 : ℚ)
    exact eq_smul_div (1) scale (1) (22) (by decide) (by decide)

theorem XZ_scale_2 : toVec (XZ 2) = (scale : ℚ) • XCell1_2 := by
  funext i
  fin_cases i
  · change ((2 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (2) scale (1) (11) (by decide) (by decide)
  · change ((-1 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 22 : ℚ)
    exact eq_smul_div (-1) scale (-1) (22) (by decide) (by decide)
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-2) scale (-1) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((-1 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 22 : ℚ)
    exact eq_smul_div (-1) scale (-1) (22) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((-1 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 22 : ℚ)
    exact eq_smul_div (-1) scale (-1) (22) (by decide) (by decide)

theorem XZ_scale_3 : toVec (XZ 3) = (scale : ℚ) • XCell1_3 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-1 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 22 : ℚ)
    exact eq_smul_div (-1) scale (-1) (22) (by decide) (by decide)
  · change ((1 : ℤ) : ℚ) = (scale : ℚ) * (1 / 22 : ℚ)
    exact eq_smul_div (1) scale (1) (22) (by decide) (by decide)
  · change ((1 : ℤ) : ℚ) = (scale : ℚ) * (1 / 22 : ℚ)
    exact eq_smul_div (1) scale (1) (22) (by decide) (by decide)
  · change ((2 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (2) scale (1) (11) (by decide) (by decide)
  · change ((-1 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 22 : ℚ)
    exact eq_smul_div (-1) scale (-1) (22) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-2) scale (-1) (11) (by decide) (by decide)

theorem XZ_scale_4 : toVec (XZ 4) = (scale : ℚ) • XCell1_4 := by
  funext i
  fin_cases i
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
  · change ((-3 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-3) scale (-3) (22) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((3 : ℤ) : ℚ) = (scale : ℚ) * (3 / 22 : ℚ)
    exact eq_smul_div (3) scale (3) (22) (by decide) (by decide)
  · change ((2 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (2) scale (1) (11) (by decide) (by decide)
  · change ((-3 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-3) scale (-3) (22) (by decide) (by decide)

theorem XZ_scale_5 : toVec (XZ 5) = (scale : ℚ) • XCell1_5 := by
  funext i
  fin_cases i
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-2) scale (-1) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((2 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (2) scale (1) (11) (by decide) (by decide)
  · change ((2 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (2) scale (1) (11) (by decide) (by decide)
  · change ((2 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (2) scale (1) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem XZ_scale_6 : toVec (XZ 6) = (scale : ℚ) • XCell1_6 := by
  funext i
  fin_cases i
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-2) scale (-1) (11) (by decide) (by decide)
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-4 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-4) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-4 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-4) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 11 : ℚ)
    exact eq_smul_div (-6) scale (-3) (11) (by decide) (by decide)

theorem XZ_scale_7 : toVec (XZ 7) = (scale : ℚ) • XCell1_7 := by
  funext i
  fin_cases i
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 11 : ℚ)
    exact eq_smul_div (-6) scale (-3) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-2) scale (-1) (11) (by decide) (by decide)
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 11 : ℚ)
    exact eq_smul_div (-6) scale (-3) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem XZ_scale_8 : toVec (XZ 8) = (scale : ℚ) • XCell1_8 := by
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

theorem XZ_scale_9 : toVec (XZ 9) = (scale : ℚ) • XCell1_9 := by
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

theorem XZ_scale_10 : toVec (XZ 10) = (scale : ℚ) • XCell1_10 := by
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

theorem XZ_scale_11 : toVec (XZ 11) = (scale : ℚ) • XCell1_11 := by
  funext i
  fin_cases i
  · change ((11 : ℤ) : ℚ) = (scale : ℚ) * (1 / 2 : ℚ)
    exact eq_smul_div (11) scale (1) (2) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem XZ_scale_12 : toVec (XZ 12) = (scale : ℚ) • XCell1_12 := by
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

theorem XZ_scale_13 : toVec (XZ 13) = (scale : ℚ) • XCell1_13 := by
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

theorem XZ_scale_14 : toVec (XZ 14) = (scale : ℚ) • XCell1_14 := by
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

theorem XZ_scale_15 : toVec (XZ 15) = (scale : ℚ) • XCell1_15 := by
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

theorem XZ_scale_16 : toVec (XZ 16) = (scale : ℚ) • XCell1_16 := by
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

theorem XZ_scale_17 : toVec (XZ 17) = (scale : ℚ) • XCell1_17 := by
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

theorem XZ_scale_18 : toVec (XZ 18) = (scale : ℚ) • XCell1_18 := by
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

theorem XZ_scale_19 : toVec (XZ 19) = (scale : ℚ) • XCell1_19 := by
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
    toVec (XZ k) = (scale : ℚ) • XVec (1 : Fin 10) k := by
  fin_cases k
  · simp [XVec, XRow1]; exact XZ_scale_0
  · simp [XVec, XRow1]; exact XZ_scale_1
  · simp [XVec, XRow1]; exact XZ_scale_2
  · simp [XVec, XRow1]; exact XZ_scale_3
  · simp [XVec, XRow1]; exact XZ_scale_4
  · simp [XVec, XRow1]; exact XZ_scale_5
  · simp [XVec, XRow1]; exact XZ_scale_6
  · simp [XVec, XRow1]; exact XZ_scale_7
  · simp [XVec, XRow1]; exact XZ_scale_8
  · simp [XVec, XRow1]; exact XZ_scale_9
  · simp [XVec, XRow1]; exact XZ_scale_10
  · simp [XVec, XRow1]; exact XZ_scale_11
  · simp [XVec, XRow1]; exact XZ_scale_12
  · simp [XVec, XRow1]; exact XZ_scale_13
  · simp [XVec, XRow1]; exact XZ_scale_14
  · simp [XVec, XRow1]; exact XZ_scale_15
  · simp [XVec, XRow1]; exact XZ_scale_16
  · simp [XVec, XRow1]; exact XZ_scale_17
  · simp [XVec, XRow1]; exact XZ_scale_18
  · simp [XVec, XRow1]; exact XZ_scale_19

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
    (matrixMul XVec AVec) (1 : Fin 10) (2 : Fin 10) =
      ![0, 0, 0, 0, 0, 0, 0, 0, 0, 0] := by
  unfold matrixMul
  refine sum_mul_eq_of_scaled scale scale_ne_zero
    (fun k => XVec (1 : Fin 10) k)
    (fun k => AVec k (2 : Fin 10))
    XZ AZ XZ_scale AZ_scale entryZ rfl _ ?_
  rw [entryZ_eq, toVec_zeroZ_smul, vec_zero_eq]

theorem entry_eq_matrixOne :
    (matrixMul XVec AVec) (1 : Fin 10) (2 : Fin 10) =
      matrixOne (Fin 10) (1 : Fin 10) (2 : Fin 10) := by
  rw [entry_eq]
  have hne : (1 : Fin 10) ≠ (2 : Fin 10) := by decide
  funext n
  fin_cases n <;> simp [matrixOne, constVec, basis, *]

end V14Formalization.D12PiecePASplitEntry1_2


namespace V14Formalization.D12PiecePASplitEntry1_3
open D12CyclotomicVec D12CyclotomicVecZ D12PiecePAData
def payloadSha256 : String := "76c6196f29afe1a8398af99502447f48ebeed4bcb3805fc5dbec693940bc04b0"

def scale : ℤ := 22

def XZ (k : Fin 20) : VecZ :=
  match k.val with
  | 0 => #v[-3, -6, -5, -5, -5, -3, -4, -3, -3, -7]
  | 1 => #v[-6, 2, -2, 1, 0, -3, 0, -4, 0, 1]
  | 2 => #v[2, -1, -2, 0, 0, 0, -4, -1, -4, -1]
  | 3 => #v[0, -1, 1, 1, 2, -1, 0, 0, 0, -2]
  | 4 => #v[3, 0, 3, 3, 3, -3, 0, 3, 2, -3]
  | 5 => #v[-2, 0, 0, 0, 0, -4, 2, 2, 2, 0]
  | 6 => #v[-2, -8, -4, -4, -4, -4, -8, 0, -4, -6]
  | 7 => #v[-4, 0, 0, -6, -4, 0, -2, -6, 0, 0]
  | 8 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  | 9 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  | 10 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  | 11 => #v[11, 0, 0, 0, 0, 0, 0, 0, 0, 0]
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
  | 13 => #v[24, 0, -4, -2, -2, -4, -4, -2, -2, -4]
  | 14 => #v[4, 2, 2, 4, 0, 0, 2, 6, 2, 0]
  | 15 => #v[0, 0, 0, -3, 3, 3, -3, 0, 0, 0]
  | 16 => #v[-3, 0, 0, 0, -3, 0, 0, 3, 3, 0]
  | 17 => #v[0, -3, 0, 0, 3, 0, 3, 0, 0, -3]
  | 18 => #v[0, -3, 0, 3, 0, 3, 0, -3, 0, 0]
  | 19 => #v[0, 0, 0, -3, 3, 0, 0, 0, 3, -3]
  | _ => zeroZ

def entryZ : VecZ := sumFin (fun k => mulZ (XZ k) (AZ k))

theorem entryZ_eq : entryZ = zeroZ := by
  decide +kernel

theorem scale_ne_zero : scale ≠ 0 := by
  decide

theorem XZ_scale_0 : toVec (XZ 0) = (scale : ℚ) • XCell1_0 := by
  funext i
  fin_cases i
  · change ((-3 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-3) scale (-3) (22) (by decide) (by decide)
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 11 : ℚ)
    exact eq_smul_div (-6) scale (-3) (11) (by decide) (by decide)
  · change ((-5 : ℤ) : ℚ) = (scale : ℚ) * (-5 / 22 : ℚ)
    exact eq_smul_div (-5) scale (-5) (22) (by decide) (by decide)
  · change ((-5 : ℤ) : ℚ) = (scale : ℚ) * (-5 / 22 : ℚ)
    exact eq_smul_div (-5) scale (-5) (22) (by decide) (by decide)
  · change ((-5 : ℤ) : ℚ) = (scale : ℚ) * (-5 / 22 : ℚ)
    exact eq_smul_div (-5) scale (-5) (22) (by decide) (by decide)
  · change ((-3 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-3) scale (-3) (22) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((-3 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-3) scale (-3) (22) (by decide) (by decide)
  · change ((-3 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-3) scale (-3) (22) (by decide) (by decide)
  · change ((-7 : ℤ) : ℚ) = (scale : ℚ) * (-7 / 22 : ℚ)
    exact eq_smul_div (-7) scale (-7) (22) (by decide) (by decide)

theorem XZ_scale_1 : toVec (XZ 1) = (scale : ℚ) • XCell1_1 := by
  funext i
  fin_cases i
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 11 : ℚ)
    exact eq_smul_div (-6) scale (-3) (11) (by decide) (by decide)
  · change ((2 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (2) scale (1) (11) (by decide) (by decide)
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-2) scale (-1) (11) (by decide) (by decide)
  · change ((1 : ℤ) : ℚ) = (scale : ℚ) * (1 / 22 : ℚ)
    exact eq_smul_div (1) scale (1) (22) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-3 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-3) scale (-3) (22) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((1 : ℤ) : ℚ) = (scale : ℚ) * (1 / 22 : ℚ)
    exact eq_smul_div (1) scale (1) (22) (by decide) (by decide)

theorem XZ_scale_2 : toVec (XZ 2) = (scale : ℚ) • XCell1_2 := by
  funext i
  fin_cases i
  · change ((2 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (2) scale (1) (11) (by decide) (by decide)
  · change ((-1 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 22 : ℚ)
    exact eq_smul_div (-1) scale (-1) (22) (by decide) (by decide)
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-2) scale (-1) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((-1 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 22 : ℚ)
    exact eq_smul_div (-1) scale (-1) (22) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((-1 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 22 : ℚ)
    exact eq_smul_div (-1) scale (-1) (22) (by decide) (by decide)

theorem XZ_scale_3 : toVec (XZ 3) = (scale : ℚ) • XCell1_3 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-1 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 22 : ℚ)
    exact eq_smul_div (-1) scale (-1) (22) (by decide) (by decide)
  · change ((1 : ℤ) : ℚ) = (scale : ℚ) * (1 / 22 : ℚ)
    exact eq_smul_div (1) scale (1) (22) (by decide) (by decide)
  · change ((1 : ℤ) : ℚ) = (scale : ℚ) * (1 / 22 : ℚ)
    exact eq_smul_div (1) scale (1) (22) (by decide) (by decide)
  · change ((2 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (2) scale (1) (11) (by decide) (by decide)
  · change ((-1 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 22 : ℚ)
    exact eq_smul_div (-1) scale (-1) (22) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-2) scale (-1) (11) (by decide) (by decide)

theorem XZ_scale_4 : toVec (XZ 4) = (scale : ℚ) • XCell1_4 := by
  funext i
  fin_cases i
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
  · change ((-3 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-3) scale (-3) (22) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((3 : ℤ) : ℚ) = (scale : ℚ) * (3 / 22 : ℚ)
    exact eq_smul_div (3) scale (3) (22) (by decide) (by decide)
  · change ((2 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (2) scale (1) (11) (by decide) (by decide)
  · change ((-3 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-3) scale (-3) (22) (by decide) (by decide)

theorem XZ_scale_5 : toVec (XZ 5) = (scale : ℚ) • XCell1_5 := by
  funext i
  fin_cases i
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-2) scale (-1) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((2 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (2) scale (1) (11) (by decide) (by decide)
  · change ((2 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (2) scale (1) (11) (by decide) (by decide)
  · change ((2 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (2) scale (1) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem XZ_scale_6 : toVec (XZ 6) = (scale : ℚ) • XCell1_6 := by
  funext i
  fin_cases i
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-2) scale (-1) (11) (by decide) (by decide)
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-4 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-4) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-4 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-4) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 11 : ℚ)
    exact eq_smul_div (-6) scale (-3) (11) (by decide) (by decide)

theorem XZ_scale_7 : toVec (XZ 7) = (scale : ℚ) • XCell1_7 := by
  funext i
  fin_cases i
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 11 : ℚ)
    exact eq_smul_div (-6) scale (-3) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-2) scale (-1) (11) (by decide) (by decide)
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 11 : ℚ)
    exact eq_smul_div (-6) scale (-3) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem XZ_scale_8 : toVec (XZ 8) = (scale : ℚ) • XCell1_8 := by
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

theorem XZ_scale_9 : toVec (XZ 9) = (scale : ℚ) • XCell1_9 := by
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

theorem XZ_scale_10 : toVec (XZ 10) = (scale : ℚ) • XCell1_10 := by
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

theorem XZ_scale_11 : toVec (XZ 11) = (scale : ℚ) • XCell1_11 := by
  funext i
  fin_cases i
  · change ((11 : ℤ) : ℚ) = (scale : ℚ) * (1 / 2 : ℚ)
    exact eq_smul_div (11) scale (1) (2) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem XZ_scale_12 : toVec (XZ 12) = (scale : ℚ) • XCell1_12 := by
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

theorem XZ_scale_13 : toVec (XZ 13) = (scale : ℚ) • XCell1_13 := by
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

theorem XZ_scale_14 : toVec (XZ 14) = (scale : ℚ) • XCell1_14 := by
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

theorem XZ_scale_15 : toVec (XZ 15) = (scale : ℚ) • XCell1_15 := by
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

theorem XZ_scale_16 : toVec (XZ 16) = (scale : ℚ) • XCell1_16 := by
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

theorem XZ_scale_17 : toVec (XZ 17) = (scale : ℚ) • XCell1_17 := by
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

theorem XZ_scale_18 : toVec (XZ 18) = (scale : ℚ) • XCell1_18 := by
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

theorem XZ_scale_19 : toVec (XZ 19) = (scale : ℚ) • XCell1_19 := by
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
    toVec (XZ k) = (scale : ℚ) • XVec (1 : Fin 10) k := by
  fin_cases k
  · simp [XVec, XRow1]; exact XZ_scale_0
  · simp [XVec, XRow1]; exact XZ_scale_1
  · simp [XVec, XRow1]; exact XZ_scale_2
  · simp [XVec, XRow1]; exact XZ_scale_3
  · simp [XVec, XRow1]; exact XZ_scale_4
  · simp [XVec, XRow1]; exact XZ_scale_5
  · simp [XVec, XRow1]; exact XZ_scale_6
  · simp [XVec, XRow1]; exact XZ_scale_7
  · simp [XVec, XRow1]; exact XZ_scale_8
  · simp [XVec, XRow1]; exact XZ_scale_9
  · simp [XVec, XRow1]; exact XZ_scale_10
  · simp [XVec, XRow1]; exact XZ_scale_11
  · simp [XVec, XRow1]; exact XZ_scale_12
  · simp [XVec, XRow1]; exact XZ_scale_13
  · simp [XVec, XRow1]; exact XZ_scale_14
  · simp [XVec, XRow1]; exact XZ_scale_15
  · simp [XVec, XRow1]; exact XZ_scale_16
  · simp [XVec, XRow1]; exact XZ_scale_17
  · simp [XVec, XRow1]; exact XZ_scale_18
  · simp [XVec, XRow1]; exact XZ_scale_19

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
  · change ((24 : ℤ) : ℚ) = (scale : ℚ) * (12 / 11 : ℚ)
    exact eq_smul_div (24) scale (12) (11) (by decide) (by decide)
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

theorem entry_eq :
    (matrixMul XVec AVec) (1 : Fin 10) (3 : Fin 10) =
      ![0, 0, 0, 0, 0, 0, 0, 0, 0, 0] := by
  unfold matrixMul
  refine sum_mul_eq_of_scaled scale scale_ne_zero
    (fun k => XVec (1 : Fin 10) k)
    (fun k => AVec k (3 : Fin 10))
    XZ AZ XZ_scale AZ_scale entryZ rfl _ ?_
  rw [entryZ_eq, toVec_zeroZ_smul, vec_zero_eq]

theorem entry_eq_matrixOne :
    (matrixMul XVec AVec) (1 : Fin 10) (3 : Fin 10) =
      matrixOne (Fin 10) (1 : Fin 10) (3 : Fin 10) := by
  rw [entry_eq]
  have hne : (1 : Fin 10) ≠ (3 : Fin 10) := by decide
  funext n
  fin_cases n <;> simp [matrixOne, constVec, basis, *]

end V14Formalization.D12PiecePASplitEntry1_3


namespace V14Formalization.D12PiecePASplitEntry1_4
open D12CyclotomicVec D12CyclotomicVecZ D12PiecePAData
def payloadSha256 : String := "76c6196f29afe1a8398af99502447f48ebeed4bcb3805fc5dbec693940bc04b0"

def scale : ℤ := 22

def XZ (k : Fin 20) : VecZ :=
  match k.val with
  | 0 => #v[-3, -6, -5, -5, -5, -3, -4, -3, -3, -7]
  | 1 => #v[-6, 2, -2, 1, 0, -3, 0, -4, 0, 1]
  | 2 => #v[2, -1, -2, 0, 0, 0, -4, -1, -4, -1]
  | 3 => #v[0, -1, 1, 1, 2, -1, 0, 0, 0, -2]
  | 4 => #v[3, 0, 3, 3, 3, -3, 0, 3, 2, -3]
  | 5 => #v[-2, 0, 0, 0, 0, -4, 2, 2, 2, 0]
  | 6 => #v[-2, -8, -4, -4, -4, -4, -8, 0, -4, -6]
  | 7 => #v[-4, 0, 0, -6, -4, 0, -2, -6, 0, 0]
  | 8 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  | 9 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  | 10 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  | 11 => #v[11, 0, 0, 0, 0, 0, 0, 0, 0, 0]
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
  | 0 => #v[-2, 4, -2, 0, -2, 0, 2, 2, 0, -2]
  | 1 => #v[-2, -6, -4, -4, -6, -6, -4, -4, -6, -2]
  | 2 => #v[-4, -4, -2, 2, -2, -4, -4, 0, -2, -2]
  | 3 => #v[2, -2, 4, -2, 2, 0, -2, 0, 0, -2]
  | 4 => #v[-26, -4, -4, -4, 0, -2, -2, 2, -2, -2]
  | 5 => #v[0, 0, 0, -3, 0, 3, 0, 3, 0, -3]
  | 6 => #v[0, -3, 0, 0, 3, 0, 3, 0, 0, -3]
  | 7 => #v[0, -3, 3, 0, 0, 0, 3, -3, 0, 0]
  | 8 => #v[-3, -3, -6, -6, -3, -3, 0, -3, -3, -3]
  | 9 => #v[0, 0, 0, 0, 3, -3, -3, 3, 0, 0]
  | 10 => #v[0, -2, -2, 0, 0, -2, 2, 4, 2, -2]
  | 11 => #v[2, -2, 4, -2, 2, 0, -2, 0, 0, -2]
  | 12 => #v[0, 4, 0, 0, 2, -2, -2, -2, -2, 2]
  | 13 => #v[2, -2, -2, 0, 4, 0, -2, -2, 2, 0]
  | 14 => #v[28, 0, 2, 0, 2, 4, 4, 2, 0, 2]
  | 15 => #v[0, 3, 0, 0, 0, 3, 0, 0, -3, -3]
  | 16 => #v[0, 0, 0, -3, 3, 0, 0, 0, 3, -3]
  | 17 => #v[0, 0, 3, -3, -3, 3, 0, 0, 0, 0]
  | 18 => #v[0, 3, 0, 0, 3, 0, 0, -3, 0, -3]
  | 19 => #v[-3, 0, 3, 0, 0, 0, 0, 3, 0, -3]
  | _ => zeroZ

def entryZ : VecZ := sumFin (fun k => mulZ (XZ k) (AZ k))

theorem entryZ_eq : entryZ = zeroZ := by
  decide +kernel

theorem scale_ne_zero : scale ≠ 0 := by
  decide

theorem XZ_scale_0 : toVec (XZ 0) = (scale : ℚ) • XCell1_0 := by
  funext i
  fin_cases i
  · change ((-3 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-3) scale (-3) (22) (by decide) (by decide)
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 11 : ℚ)
    exact eq_smul_div (-6) scale (-3) (11) (by decide) (by decide)
  · change ((-5 : ℤ) : ℚ) = (scale : ℚ) * (-5 / 22 : ℚ)
    exact eq_smul_div (-5) scale (-5) (22) (by decide) (by decide)
  · change ((-5 : ℤ) : ℚ) = (scale : ℚ) * (-5 / 22 : ℚ)
    exact eq_smul_div (-5) scale (-5) (22) (by decide) (by decide)
  · change ((-5 : ℤ) : ℚ) = (scale : ℚ) * (-5 / 22 : ℚ)
    exact eq_smul_div (-5) scale (-5) (22) (by decide) (by decide)
  · change ((-3 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-3) scale (-3) (22) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((-3 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-3) scale (-3) (22) (by decide) (by decide)
  · change ((-3 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-3) scale (-3) (22) (by decide) (by decide)
  · change ((-7 : ℤ) : ℚ) = (scale : ℚ) * (-7 / 22 : ℚ)
    exact eq_smul_div (-7) scale (-7) (22) (by decide) (by decide)

theorem XZ_scale_1 : toVec (XZ 1) = (scale : ℚ) • XCell1_1 := by
  funext i
  fin_cases i
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 11 : ℚ)
    exact eq_smul_div (-6) scale (-3) (11) (by decide) (by decide)
  · change ((2 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (2) scale (1) (11) (by decide) (by decide)
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-2) scale (-1) (11) (by decide) (by decide)
  · change ((1 : ℤ) : ℚ) = (scale : ℚ) * (1 / 22 : ℚ)
    exact eq_smul_div (1) scale (1) (22) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-3 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-3) scale (-3) (22) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((1 : ℤ) : ℚ) = (scale : ℚ) * (1 / 22 : ℚ)
    exact eq_smul_div (1) scale (1) (22) (by decide) (by decide)

theorem XZ_scale_2 : toVec (XZ 2) = (scale : ℚ) • XCell1_2 := by
  funext i
  fin_cases i
  · change ((2 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (2) scale (1) (11) (by decide) (by decide)
  · change ((-1 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 22 : ℚ)
    exact eq_smul_div (-1) scale (-1) (22) (by decide) (by decide)
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-2) scale (-1) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((-1 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 22 : ℚ)
    exact eq_smul_div (-1) scale (-1) (22) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((-1 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 22 : ℚ)
    exact eq_smul_div (-1) scale (-1) (22) (by decide) (by decide)

theorem XZ_scale_3 : toVec (XZ 3) = (scale : ℚ) • XCell1_3 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-1 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 22 : ℚ)
    exact eq_smul_div (-1) scale (-1) (22) (by decide) (by decide)
  · change ((1 : ℤ) : ℚ) = (scale : ℚ) * (1 / 22 : ℚ)
    exact eq_smul_div (1) scale (1) (22) (by decide) (by decide)
  · change ((1 : ℤ) : ℚ) = (scale : ℚ) * (1 / 22 : ℚ)
    exact eq_smul_div (1) scale (1) (22) (by decide) (by decide)
  · change ((2 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (2) scale (1) (11) (by decide) (by decide)
  · change ((-1 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 22 : ℚ)
    exact eq_smul_div (-1) scale (-1) (22) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-2) scale (-1) (11) (by decide) (by decide)

theorem XZ_scale_4 : toVec (XZ 4) = (scale : ℚ) • XCell1_4 := by
  funext i
  fin_cases i
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
  · change ((-3 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-3) scale (-3) (22) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((3 : ℤ) : ℚ) = (scale : ℚ) * (3 / 22 : ℚ)
    exact eq_smul_div (3) scale (3) (22) (by decide) (by decide)
  · change ((2 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (2) scale (1) (11) (by decide) (by decide)
  · change ((-3 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-3) scale (-3) (22) (by decide) (by decide)

theorem XZ_scale_5 : toVec (XZ 5) = (scale : ℚ) • XCell1_5 := by
  funext i
  fin_cases i
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-2) scale (-1) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((2 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (2) scale (1) (11) (by decide) (by decide)
  · change ((2 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (2) scale (1) (11) (by decide) (by decide)
  · change ((2 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (2) scale (1) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem XZ_scale_6 : toVec (XZ 6) = (scale : ℚ) • XCell1_6 := by
  funext i
  fin_cases i
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-2) scale (-1) (11) (by decide) (by decide)
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-4 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-4) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-4 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-4) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 11 : ℚ)
    exact eq_smul_div (-6) scale (-3) (11) (by decide) (by decide)

theorem XZ_scale_7 : toVec (XZ 7) = (scale : ℚ) • XCell1_7 := by
  funext i
  fin_cases i
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 11 : ℚ)
    exact eq_smul_div (-6) scale (-3) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-2) scale (-1) (11) (by decide) (by decide)
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 11 : ℚ)
    exact eq_smul_div (-6) scale (-3) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem XZ_scale_8 : toVec (XZ 8) = (scale : ℚ) • XCell1_8 := by
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

theorem XZ_scale_9 : toVec (XZ 9) = (scale : ℚ) • XCell1_9 := by
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

theorem XZ_scale_10 : toVec (XZ 10) = (scale : ℚ) • XCell1_10 := by
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

theorem XZ_scale_11 : toVec (XZ 11) = (scale : ℚ) • XCell1_11 := by
  funext i
  fin_cases i
  · change ((11 : ℤ) : ℚ) = (scale : ℚ) * (1 / 2 : ℚ)
    exact eq_smul_div (11) scale (1) (2) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem XZ_scale_12 : toVec (XZ 12) = (scale : ℚ) • XCell1_12 := by
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

theorem XZ_scale_13 : toVec (XZ 13) = (scale : ℚ) • XCell1_13 := by
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

theorem XZ_scale_14 : toVec (XZ 14) = (scale : ℚ) • XCell1_14 := by
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

theorem XZ_scale_15 : toVec (XZ 15) = (scale : ℚ) • XCell1_15 := by
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

theorem XZ_scale_16 : toVec (XZ 16) = (scale : ℚ) • XCell1_16 := by
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

theorem XZ_scale_17 : toVec (XZ 17) = (scale : ℚ) • XCell1_17 := by
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

theorem XZ_scale_18 : toVec (XZ 18) = (scale : ℚ) • XCell1_18 := by
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

theorem XZ_scale_19 : toVec (XZ 19) = (scale : ℚ) • XCell1_19 := by
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
    toVec (XZ k) = (scale : ℚ) • XVec (1 : Fin 10) k := by
  fin_cases k
  · simp [XVec, XRow1]; exact XZ_scale_0
  · simp [XVec, XRow1]; exact XZ_scale_1
  · simp [XVec, XRow1]; exact XZ_scale_2
  · simp [XVec, XRow1]; exact XZ_scale_3
  · simp [XVec, XRow1]; exact XZ_scale_4
  · simp [XVec, XRow1]; exact XZ_scale_5
  · simp [XVec, XRow1]; exact XZ_scale_6
  · simp [XVec, XRow1]; exact XZ_scale_7
  · simp [XVec, XRow1]; exact XZ_scale_8
  · simp [XVec, XRow1]; exact XZ_scale_9
  · simp [XVec, XRow1]; exact XZ_scale_10
  · simp [XVec, XRow1]; exact XZ_scale_11
  · simp [XVec, XRow1]; exact XZ_scale_12
  · simp [XVec, XRow1]; exact XZ_scale_13
  · simp [XVec, XRow1]; exact XZ_scale_14
  · simp [XVec, XRow1]; exact XZ_scale_15
  · simp [XVec, XRow1]; exact XZ_scale_16
  · simp [XVec, XRow1]; exact XZ_scale_17
  · simp [XVec, XRow1]; exact XZ_scale_18
  · simp [XVec, XRow1]; exact XZ_scale_19

theorem AZ_scale_0 : toVec (AZ 0) = (scale : ℚ) • ACell0_4 := by
  funext i
  fin_cases i
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

theorem AZ_scale_1 : toVec (AZ 1) = (scale : ℚ) • ACell1_4 := by
  funext i
  fin_cases i
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-2) scale (-1) (11) (by decide) (by decide)
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 11 : ℚ)
    exact eq_smul_div (-6) scale (-3) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 11 : ℚ)
    exact eq_smul_div (-6) scale (-3) (11) (by decide) (by decide)
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 11 : ℚ)
    exact eq_smul_div (-6) scale (-3) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 11 : ℚ)
    exact eq_smul_div (-6) scale (-3) (11) (by decide) (by decide)
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-2) scale (-1) (11) (by decide) (by decide)

theorem AZ_scale_2 : toVec (AZ 2) = (scale : ℚ) • ACell2_4 := by
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

theorem AZ_scale_3 : toVec (AZ 3) = (scale : ℚ) • ACell3_4 := by
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

theorem AZ_scale_4 : toVec (AZ 4) = (scale : ℚ) • ACell4_4 := by
  funext i
  fin_cases i
  · change ((-26 : ℤ) : ℚ) = (scale : ℚ) * (-13 / 11 : ℚ)
    exact eq_smul_div (-26) scale (-13) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
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
  · change ((2 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (2) scale (1) (11) (by decide) (by decide)
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-2) scale (-1) (11) (by decide) (by decide)
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-2) scale (-1) (11) (by decide) (by decide)

theorem AZ_scale_5 : toVec (AZ 5) = (scale : ℚ) • ACell5_4 := by
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

theorem AZ_scale_6 : toVec (AZ 6) = (scale : ℚ) • ACell6_4 := by
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

theorem AZ_scale_7 : toVec (AZ 7) = (scale : ℚ) • ACell7_4 := by
  funext i
  fin_cases i
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
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem AZ_scale_8 : toVec (AZ 8) = (scale : ℚ) • ACell8_4 := by
  funext i
  fin_cases i
  · change ((-3 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-3) scale (-3) (22) (by decide) (by decide)
  · change ((-3 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-3) scale (-3) (22) (by decide) (by decide)
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 11 : ℚ)
    exact eq_smul_div (-6) scale (-3) (11) (by decide) (by decide)
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 11 : ℚ)
    exact eq_smul_div (-6) scale (-3) (11) (by decide) (by decide)
  · change ((-3 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-3) scale (-3) (22) (by decide) (by decide)
  · change ((-3 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-3) scale (-3) (22) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-3 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-3) scale (-3) (22) (by decide) (by decide)
  · change ((-3 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-3) scale (-3) (22) (by decide) (by decide)
  · change ((-3 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-3) scale (-3) (22) (by decide) (by decide)

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

theorem AZ_scale_10 : toVec (AZ 10) = (scale : ℚ) • ACell10_4 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-2) scale (-1) (11) (by decide) (by decide)
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-2) scale (-1) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-2) scale (-1) (11) (by decide) (by decide)
  · change ((2 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (2) scale (1) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (4) scale (2) (11) (by decide) (by decide)
  · change ((2 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (2) scale (1) (11) (by decide) (by decide)
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-2) scale (-1) (11) (by decide) (by decide)

theorem AZ_scale_11 : toVec (AZ 11) = (scale : ℚ) • ACell11_4 := by
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

theorem AZ_scale_12 : toVec (AZ 12) = (scale : ℚ) • ACell12_4 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (4) scale (2) (11) (by decide) (by decide)
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
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-2) scale (-1) (11) (by decide) (by decide)
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-2) scale (-1) (11) (by decide) (by decide)
  · change ((2 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (2) scale (1) (11) (by decide) (by decide)

theorem AZ_scale_13 : toVec (AZ 13) = (scale : ℚ) • ACell13_4 := by
  funext i
  fin_cases i
  · change ((2 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (2) scale (1) (11) (by decide) (by decide)
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-2) scale (-1) (11) (by decide) (by decide)
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-2) scale (-1) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (4) scale (2) (11) (by decide) (by decide)
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

theorem AZ_scale_14 : toVec (AZ 14) = (scale : ℚ) • ACell14_4 := by
  funext i
  fin_cases i
  · change ((28 : ℤ) : ℚ) = (scale : ℚ) * (14 / 11 : ℚ)
    exact eq_smul_div (28) scale (14) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
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

theorem AZ_scale_15 : toVec (AZ 15) = (scale : ℚ) • ACell15_4 := by
  funext i
  fin_cases i
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
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-3 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-3) scale (-3) (22) (by decide) (by decide)
  · change ((-3 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-3) scale (-3) (22) (by decide) (by decide)

theorem AZ_scale_16 : toVec (AZ 16) = (scale : ℚ) • ACell16_4 := by
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

theorem AZ_scale_17 : toVec (AZ 17) = (scale : ℚ) • ACell17_4 := by
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

theorem AZ_scale_18 : toVec (AZ 18) = (scale : ℚ) • ACell18_4 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((3 : ℤ) : ℚ) = (scale : ℚ) * (3 / 22 : ℚ)
    exact eq_smul_div (3) scale (3) (22) (by decide) (by decide)
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
  · change ((-3 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-3) scale (-3) (22) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-3 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-3) scale (-3) (22) (by decide) (by decide)

theorem AZ_scale_19 : toVec (AZ 19) = (scale : ℚ) • ACell19_4 := by
  funext i
  fin_cases i
  · change ((-3 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-3) scale (-3) (22) (by decide) (by decide)
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
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((3 : ℤ) : ℚ) = (scale : ℚ) * (3 / 22 : ℚ)
    exact eq_smul_div (3) scale (3) (22) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-3 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-3) scale (-3) (22) (by decide) (by decide)

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

theorem entry_eq :
    (matrixMul XVec AVec) (1 : Fin 10) (4 : Fin 10) =
      ![0, 0, 0, 0, 0, 0, 0, 0, 0, 0] := by
  unfold matrixMul
  refine sum_mul_eq_of_scaled scale scale_ne_zero
    (fun k => XVec (1 : Fin 10) k)
    (fun k => AVec k (4 : Fin 10))
    XZ AZ XZ_scale AZ_scale entryZ rfl _ ?_
  rw [entryZ_eq, toVec_zeroZ_smul, vec_zero_eq]

theorem entry_eq_matrixOne :
    (matrixMul XVec AVec) (1 : Fin 10) (4 : Fin 10) =
      matrixOne (Fin 10) (1 : Fin 10) (4 : Fin 10) := by
  rw [entry_eq]
  have hne : (1 : Fin 10) ≠ (4 : Fin 10) := by decide
  funext n
  fin_cases n <;> simp [matrixOne, constVec, basis, *]

end V14Formalization.D12PiecePASplitEntry1_4


namespace V14Formalization.D12PiecePASplitEntry1_5
open D12CyclotomicVec D12CyclotomicVecZ D12PiecePAData
def payloadSha256 : String := "76c6196f29afe1a8398af99502447f48ebeed4bcb3805fc5dbec693940bc04b0"

def scale : ℤ := 22

def XZ (k : Fin 20) : VecZ :=
  match k.val with
  | 0 => #v[-3, -6, -5, -5, -5, -3, -4, -3, -3, -7]
  | 1 => #v[-6, 2, -2, 1, 0, -3, 0, -4, 0, 1]
  | 2 => #v[2, -1, -2, 0, 0, 0, -4, -1, -4, -1]
  | 3 => #v[0, -1, 1, 1, 2, -1, 0, 0, 0, -2]
  | 4 => #v[3, 0, 3, 3, 3, -3, 0, 3, 2, -3]
  | 5 => #v[-2, 0, 0, 0, 0, -4, 2, 2, 2, 0]
  | 6 => #v[-2, -8, -4, -4, -4, -4, -8, 0, -4, -6]
  | 7 => #v[-4, 0, 0, -6, -4, 0, -2, -6, 0, 0]
  | 8 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  | 9 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  | 10 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  | 11 => #v[11, 0, 0, 0, 0, 0, 0, 0, 0, 0]
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
  | 0 => #v[0, 0, 4, 0, 0, -4, -4, 0, 0, 4]
  | 1 => #v[4, 4, 8, 4, 4, 8, 4, 4, 0, 4]
  | 2 => #v[0, 0, 0, 0, 0, 0, -4, 4, 4, -4]
  | 3 => #v[4, 4, 4, 0, 8, 4, 4, 4, 4, 8]
  | 4 => #v[0, 0, 0, -4, 0, 4, 0, 4, 0, -4]
  | 5 => #v[-22, 2, 2, 0, 4, 6, 4, 0, 2, 2]
  | 6 => #v[-2, 2, 2, 0, -4, 0, 2, 2, -2, 0]
  | 7 => #v[-4, -2, -2, -6, -2, -2, -4, 0, 0, 0]
  | 8 => #v[-2, 0, 0, -2, 0, 2, -2, 4, -2, 2]
  | 9 => #v[6, 4, 6, 4, 2, 2, 4, 6, 4, 6]
  | 10 => #v[4, 0, 0, -4, 0, -4, 0, 0, 4, 0]
  | 11 => #v[0, -4, 4, 0, 0, 0, 0, 4, -4, 0]
  | 12 => #v[-4, -8, -4, -4, -4, -4, -8, -4, 0, -4]
  | 13 => #v[0, 0, 0, 0, 0, -4, 4, 4, -4, 0]
  | 14 => #v[-4, -4, -8, -8, -4, -4, 0, -4, -4, -4]
  | 15 => #v[28, 0, 4, 2, 0, 2, 2, 0, 2, 4]
  | 16 => #v[-4, -2, -2, -6, -2, -2, -4, 0, 0, 0]
  | 17 => #v[-2, -2, 0, 2, 0, 2, -4, 2, 0, 2]
  | 18 => #v[0, 2, -2, -2, 0, 4, 0, -2, -2, 2]
  | 19 => #v[0, 2, 2, 0, 0, 2, -2, -4, -2, 2]
  | _ => zeroZ

def entryZ : VecZ := sumFin (fun k => mulZ (XZ k) (AZ k))

theorem entryZ_eq : entryZ = zeroZ := by
  decide +kernel

theorem scale_ne_zero : scale ≠ 0 := by
  decide

theorem XZ_scale_0 : toVec (XZ 0) = (scale : ℚ) • XCell1_0 := by
  funext i
  fin_cases i
  · change ((-3 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-3) scale (-3) (22) (by decide) (by decide)
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 11 : ℚ)
    exact eq_smul_div (-6) scale (-3) (11) (by decide) (by decide)
  · change ((-5 : ℤ) : ℚ) = (scale : ℚ) * (-5 / 22 : ℚ)
    exact eq_smul_div (-5) scale (-5) (22) (by decide) (by decide)
  · change ((-5 : ℤ) : ℚ) = (scale : ℚ) * (-5 / 22 : ℚ)
    exact eq_smul_div (-5) scale (-5) (22) (by decide) (by decide)
  · change ((-5 : ℤ) : ℚ) = (scale : ℚ) * (-5 / 22 : ℚ)
    exact eq_smul_div (-5) scale (-5) (22) (by decide) (by decide)
  · change ((-3 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-3) scale (-3) (22) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((-3 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-3) scale (-3) (22) (by decide) (by decide)
  · change ((-3 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-3) scale (-3) (22) (by decide) (by decide)
  · change ((-7 : ℤ) : ℚ) = (scale : ℚ) * (-7 / 22 : ℚ)
    exact eq_smul_div (-7) scale (-7) (22) (by decide) (by decide)

theorem XZ_scale_1 : toVec (XZ 1) = (scale : ℚ) • XCell1_1 := by
  funext i
  fin_cases i
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 11 : ℚ)
    exact eq_smul_div (-6) scale (-3) (11) (by decide) (by decide)
  · change ((2 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (2) scale (1) (11) (by decide) (by decide)
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-2) scale (-1) (11) (by decide) (by decide)
  · change ((1 : ℤ) : ℚ) = (scale : ℚ) * (1 / 22 : ℚ)
    exact eq_smul_div (1) scale (1) (22) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-3 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-3) scale (-3) (22) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((1 : ℤ) : ℚ) = (scale : ℚ) * (1 / 22 : ℚ)
    exact eq_smul_div (1) scale (1) (22) (by decide) (by decide)

theorem XZ_scale_2 : toVec (XZ 2) = (scale : ℚ) • XCell1_2 := by
  funext i
  fin_cases i
  · change ((2 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (2) scale (1) (11) (by decide) (by decide)
  · change ((-1 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 22 : ℚ)
    exact eq_smul_div (-1) scale (-1) (22) (by decide) (by decide)
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-2) scale (-1) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((-1 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 22 : ℚ)
    exact eq_smul_div (-1) scale (-1) (22) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((-1 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 22 : ℚ)
    exact eq_smul_div (-1) scale (-1) (22) (by decide) (by decide)

theorem XZ_scale_3 : toVec (XZ 3) = (scale : ℚ) • XCell1_3 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-1 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 22 : ℚ)
    exact eq_smul_div (-1) scale (-1) (22) (by decide) (by decide)
  · change ((1 : ℤ) : ℚ) = (scale : ℚ) * (1 / 22 : ℚ)
    exact eq_smul_div (1) scale (1) (22) (by decide) (by decide)
  · change ((1 : ℤ) : ℚ) = (scale : ℚ) * (1 / 22 : ℚ)
    exact eq_smul_div (1) scale (1) (22) (by decide) (by decide)
  · change ((2 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (2) scale (1) (11) (by decide) (by decide)
  · change ((-1 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 22 : ℚ)
    exact eq_smul_div (-1) scale (-1) (22) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-2) scale (-1) (11) (by decide) (by decide)

theorem XZ_scale_4 : toVec (XZ 4) = (scale : ℚ) • XCell1_4 := by
  funext i
  fin_cases i
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
  · change ((-3 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-3) scale (-3) (22) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((3 : ℤ) : ℚ) = (scale : ℚ) * (3 / 22 : ℚ)
    exact eq_smul_div (3) scale (3) (22) (by decide) (by decide)
  · change ((2 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (2) scale (1) (11) (by decide) (by decide)
  · change ((-3 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-3) scale (-3) (22) (by decide) (by decide)

theorem XZ_scale_5 : toVec (XZ 5) = (scale : ℚ) • XCell1_5 := by
  funext i
  fin_cases i
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-2) scale (-1) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((2 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (2) scale (1) (11) (by decide) (by decide)
  · change ((2 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (2) scale (1) (11) (by decide) (by decide)
  · change ((2 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (2) scale (1) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem XZ_scale_6 : toVec (XZ 6) = (scale : ℚ) • XCell1_6 := by
  funext i
  fin_cases i
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-2) scale (-1) (11) (by decide) (by decide)
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-4 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-4) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-4 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-4) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 11 : ℚ)
    exact eq_smul_div (-6) scale (-3) (11) (by decide) (by decide)

theorem XZ_scale_7 : toVec (XZ 7) = (scale : ℚ) • XCell1_7 := by
  funext i
  fin_cases i
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 11 : ℚ)
    exact eq_smul_div (-6) scale (-3) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-2) scale (-1) (11) (by decide) (by decide)
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 11 : ℚ)
    exact eq_smul_div (-6) scale (-3) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem XZ_scale_8 : toVec (XZ 8) = (scale : ℚ) • XCell1_8 := by
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

theorem XZ_scale_9 : toVec (XZ 9) = (scale : ℚ) • XCell1_9 := by
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

theorem XZ_scale_10 : toVec (XZ 10) = (scale : ℚ) • XCell1_10 := by
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

theorem XZ_scale_11 : toVec (XZ 11) = (scale : ℚ) • XCell1_11 := by
  funext i
  fin_cases i
  · change ((11 : ℤ) : ℚ) = (scale : ℚ) * (1 / 2 : ℚ)
    exact eq_smul_div (11) scale (1) (2) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem XZ_scale_12 : toVec (XZ 12) = (scale : ℚ) • XCell1_12 := by
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

theorem XZ_scale_13 : toVec (XZ 13) = (scale : ℚ) • XCell1_13 := by
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

theorem XZ_scale_14 : toVec (XZ 14) = (scale : ℚ) • XCell1_14 := by
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

theorem XZ_scale_15 : toVec (XZ 15) = (scale : ℚ) • XCell1_15 := by
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

theorem XZ_scale_16 : toVec (XZ 16) = (scale : ℚ) • XCell1_16 := by
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

theorem XZ_scale_17 : toVec (XZ 17) = (scale : ℚ) • XCell1_17 := by
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

theorem XZ_scale_18 : toVec (XZ 18) = (scale : ℚ) • XCell1_18 := by
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

theorem XZ_scale_19 : toVec (XZ 19) = (scale : ℚ) • XCell1_19 := by
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
    toVec (XZ k) = (scale : ℚ) • XVec (1 : Fin 10) k := by
  fin_cases k
  · simp [XVec, XRow1]; exact XZ_scale_0
  · simp [XVec, XRow1]; exact XZ_scale_1
  · simp [XVec, XRow1]; exact XZ_scale_2
  · simp [XVec, XRow1]; exact XZ_scale_3
  · simp [XVec, XRow1]; exact XZ_scale_4
  · simp [XVec, XRow1]; exact XZ_scale_5
  · simp [XVec, XRow1]; exact XZ_scale_6
  · simp [XVec, XRow1]; exact XZ_scale_7
  · simp [XVec, XRow1]; exact XZ_scale_8
  · simp [XVec, XRow1]; exact XZ_scale_9
  · simp [XVec, XRow1]; exact XZ_scale_10
  · simp [XVec, XRow1]; exact XZ_scale_11
  · simp [XVec, XRow1]; exact XZ_scale_12
  · simp [XVec, XRow1]; exact XZ_scale_13
  · simp [XVec, XRow1]; exact XZ_scale_14
  · simp [XVec, XRow1]; exact XZ_scale_15
  · simp [XVec, XRow1]; exact XZ_scale_16
  · simp [XVec, XRow1]; exact XZ_scale_17
  · simp [XVec, XRow1]; exact XZ_scale_18
  · simp [XVec, XRow1]; exact XZ_scale_19

theorem AZ_scale_0 : toVec (AZ 0) = (scale : ℚ) • ACell0_5 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (4) scale (2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (4) scale (2) (11) (by decide) (by decide)

theorem AZ_scale_1 : toVec (AZ 1) = (scale : ℚ) • ACell1_5 := by
  funext i
  fin_cases i
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (4) scale (2) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (4) scale (2) (11) (by decide) (by decide)
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (4 / 11 : ℚ)
    exact eq_smul_div (8) scale (4) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (4) scale (2) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (4) scale (2) (11) (by decide) (by decide)
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (4 / 11 : ℚ)
    exact eq_smul_div (8) scale (4) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (4) scale (2) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (4) scale (2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (4) scale (2) (11) (by decide) (by decide)

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
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (4) scale (2) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (4) scale (2) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)

theorem AZ_scale_3 : toVec (AZ 3) = (scale : ℚ) • ACell3_5 := by
  funext i
  fin_cases i
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (4) scale (2) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (4) scale (2) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (4) scale (2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (4 / 11 : ℚ)
    exact eq_smul_div (8) scale (4) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (4) scale (2) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (4) scale (2) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (4) scale (2) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (4) scale (2) (11) (by decide) (by decide)
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (4 / 11 : ℚ)
    exact eq_smul_div (8) scale (4) (11) (by decide) (by decide)

theorem AZ_scale_4 : toVec (AZ 4) = (scale : ℚ) • ACell4_5 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (4) scale (2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (4) scale (2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)

theorem AZ_scale_5 : toVec (AZ 5) = (scale : ℚ) • ACell5_5 := by
  funext i
  fin_cases i
  · change ((-22 : ℤ) : ℚ) = (scale : ℚ) * (-1 : ℚ)
    exact eq_smul_int (-22) scale (-1) (by decide)
  · change ((2 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (2) scale (1) (11) (by decide) (by decide)
  · change ((2 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (2) scale (1) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
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

theorem AZ_scale_6 : toVec (AZ 6) = (scale : ℚ) • ACell6_5 := by
  funext i
  fin_cases i
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-2) scale (-1) (11) (by decide) (by decide)
  · change ((2 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (2) scale (1) (11) (by decide) (by decide)
  · change ((2 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (2) scale (1) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((2 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (2) scale (1) (11) (by decide) (by decide)
  · change ((2 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (2) scale (1) (11) (by decide) (by decide)
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-2) scale (-1) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem AZ_scale_7 : toVec (AZ 7) = (scale : ℚ) • ACell7_5 := by
  funext i
  fin_cases i
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-2) scale (-1) (11) (by decide) (by decide)
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-2) scale (-1) (11) (by decide) (by decide)
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 11 : ℚ)
    exact eq_smul_div (-6) scale (-3) (11) (by decide) (by decide)
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-2) scale (-1) (11) (by decide) (by decide)
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-2) scale (-1) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem AZ_scale_8 : toVec (AZ 8) = (scale : ℚ) • ACell8_5 := by
  funext i
  fin_cases i
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-2) scale (-1) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-2) scale (-1) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
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

theorem AZ_scale_9 : toVec (AZ 9) = (scale : ℚ) • ACell9_5 := by
  funext i
  fin_cases i
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (3 / 11 : ℚ)
    exact eq_smul_div (6) scale (3) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (4) scale (2) (11) (by decide) (by decide)
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (3 / 11 : ℚ)
    exact eq_smul_div (6) scale (3) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (4) scale (2) (11) (by decide) (by decide)
  · change ((2 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (2) scale (1) (11) (by decide) (by decide)
  · change ((2 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (2) scale (1) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (4) scale (2) (11) (by decide) (by decide)
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (3 / 11 : ℚ)
    exact eq_smul_div (6) scale (3) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (4) scale (2) (11) (by decide) (by decide)
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (3 / 11 : ℚ)
    exact eq_smul_div (6) scale (3) (11) (by decide) (by decide)

theorem AZ_scale_10 : toVec (AZ 10) = (scale : ℚ) • ACell10_5 := by
  funext i
  fin_cases i
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (4) scale (2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (4) scale (2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem AZ_scale_11 : toVec (AZ 11) = (scale : ℚ) • ACell11_5 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (4) scale (2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (4) scale (2) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem AZ_scale_12 : toVec (AZ 12) = (scale : ℚ) • ACell12_5 := by
  funext i
  fin_cases i
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-4 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-4) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-4 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-4) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)

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
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (4) scale (2) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (4) scale (2) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem AZ_scale_14 : toVec (AZ 14) = (scale : ℚ) • ACell14_5 := by
  funext i
  fin_cases i
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-4 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-4) (11) (by decide) (by decide)
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-4 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-4) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)

theorem AZ_scale_15 : toVec (AZ 15) = (scale : ℚ) • ACell15_5 := by
  funext i
  fin_cases i
  · change ((28 : ℤ) : ℚ) = (scale : ℚ) * (14 / 11 : ℚ)
    exact eq_smul_div (28) scale (14) (11) (by decide) (by decide)
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
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((2 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (2) scale (1) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (4) scale (2) (11) (by decide) (by decide)

theorem AZ_scale_16 : toVec (AZ 16) = (scale : ℚ) • ACell16_5 := by
  funext i
  fin_cases i
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-2) scale (-1) (11) (by decide) (by decide)
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-2) scale (-1) (11) (by decide) (by decide)
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 11 : ℚ)
    exact eq_smul_div (-6) scale (-3) (11) (by decide) (by decide)
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-2) scale (-1) (11) (by decide) (by decide)
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-2) scale (-1) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem AZ_scale_17 : toVec (AZ 17) = (scale : ℚ) • ACell17_5 := by
  funext i
  fin_cases i
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-2) scale (-1) (11) (by decide) (by decide)
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-2) scale (-1) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((2 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (2) scale (1) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((2 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (2) scale (1) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((2 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (2) scale (1) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((2 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (2) scale (1) (11) (by decide) (by decide)

theorem AZ_scale_18 : toVec (AZ 18) = (scale : ℚ) • ACell18_5 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((2 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (2) scale (1) (11) (by decide) (by decide)
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-2) scale (-1) (11) (by decide) (by decide)
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-2) scale (-1) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (4) scale (2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-2) scale (-1) (11) (by decide) (by decide)
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-2) scale (-1) (11) (by decide) (by decide)
  · change ((2 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (2) scale (1) (11) (by decide) (by decide)

theorem AZ_scale_19 : toVec (AZ 19) = (scale : ℚ) • ACell19_5 := by
  funext i
  fin_cases i
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
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-2) scale (-1) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-2) scale (-1) (11) (by decide) (by decide)
  · change ((2 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (2) scale (1) (11) (by decide) (by decide)

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

theorem entry_eq :
    (matrixMul XVec AVec) (1 : Fin 10) (5 : Fin 10) =
      ![0, 0, 0, 0, 0, 0, 0, 0, 0, 0] := by
  unfold matrixMul
  refine sum_mul_eq_of_scaled scale scale_ne_zero
    (fun k => XVec (1 : Fin 10) k)
    (fun k => AVec k (5 : Fin 10))
    XZ AZ XZ_scale AZ_scale entryZ rfl _ ?_
  rw [entryZ_eq, toVec_zeroZ_smul, vec_zero_eq]

theorem entry_eq_matrixOne :
    (matrixMul XVec AVec) (1 : Fin 10) (5 : Fin 10) =
      matrixOne (Fin 10) (1 : Fin 10) (5 : Fin 10) := by
  rw [entry_eq]
  have hne : (1 : Fin 10) ≠ (5 : Fin 10) := by decide
  funext n
  fin_cases n <;> simp [matrixOne, constVec, basis, *]

end V14Formalization.D12PiecePASplitEntry1_5


namespace V14Formalization.D12PiecePASplitEntry1_6
open D12CyclotomicVec D12CyclotomicVecZ D12PiecePAData
def payloadSha256 : String := "76c6196f29afe1a8398af99502447f48ebeed4bcb3805fc5dbec693940bc04b0"

def scale : ℤ := 22

def XZ (k : Fin 20) : VecZ :=
  match k.val with
  | 0 => #v[-3, -6, -5, -5, -5, -3, -4, -3, -3, -7]
  | 1 => #v[-6, 2, -2, 1, 0, -3, 0, -4, 0, 1]
  | 2 => #v[2, -1, -2, 0, 0, 0, -4, -1, -4, -1]
  | 3 => #v[0, -1, 1, 1, 2, -1, 0, 0, 0, -2]
  | 4 => #v[3, 0, 3, 3, 3, -3, 0, 3, 2, -3]
  | 5 => #v[-2, 0, 0, 0, 0, -4, 2, 2, 2, 0]
  | 6 => #v[-2, -8, -4, -4, -4, -4, -8, 0, -4, -6]
  | 7 => #v[-4, 0, 0, -6, -4, 0, -2, -6, 0, 0]
  | 8 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  | 9 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  | 10 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  | 11 => #v[11, 0, 0, 0, 0, 0, 0, 0, 0, 0]
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
  | 0 => #v[0, 4, -4, 0, 0, 0, 0, -4, 4, 0]
  | 1 => #v[0, 4, -4, -4, 4, 0, 0, 0, 0, 0]
  | 2 => #v[4, 4, 4, 0, 4, 4, 8, 8, 4, 4]
  | 3 => #v[4, 0, 4, 8, 4, 4, 4, 4, 8, 4]
  | 4 => #v[0, -4, 0, 0, 4, 0, 4, 0, 0, -4]
  | 5 => #v[-2, 2, 2, 0, -4, 0, 2, 2, -2, 0]
  | 6 => #v[-24, 0, -2, 4, -2, 0, -2, 0, 2, 2]
  | 7 => #v[-2, 2, 4, 2, -2, 0, 0, -2, -2, 0]
  | 8 => #v[0, 0, 0, -4, -2, -2, -6, -2, -2, -4]
  | 9 => #v[4, 2, 0, 2, 2, 0, 2, 4, 0, 6]
  | 10 => #v[0, 0, 0, 0, 0, 4, -4, -4, 4, 0]
  | 11 => #v[-4, -4, -4, -4, 0, -4, -8, -4, -8, -4]
  | 12 => #v[4, 4, 0, 4, 4, 8, 4, 8, 4, 4]
  | 13 => #v[-4, 0, 0, 4, 4, 0, 0, -4, 0, 0]
  | 14 => #v[0, 0, -4, 4, 0, 0, 0, 4, -4, 0]
  | 15 => #v[-2, 2, 2, 2, 2, -2, 0, 0, -4, 0]
  | 16 => #v[24, 0, -4, -2, -2, -4, -4, -2, -2, -4]
  | 17 => #v[2, 4, 0, 6, 0, 4, 2, 0, 2, 2]
  | 18 => #v[-2, 0, -6, 0, -2, 0, -2, -4, -4, -2]
  | 19 => #v[2, -2, -2, 0, 4, 0, -2, -2, 2, 0]
  | _ => zeroZ

def entryZ : VecZ := sumFin (fun k => mulZ (XZ k) (AZ k))

theorem entryZ_eq : entryZ = zeroZ := by
  decide +kernel

theorem scale_ne_zero : scale ≠ 0 := by
  decide

theorem XZ_scale_0 : toVec (XZ 0) = (scale : ℚ) • XCell1_0 := by
  funext i
  fin_cases i
  · change ((-3 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-3) scale (-3) (22) (by decide) (by decide)
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 11 : ℚ)
    exact eq_smul_div (-6) scale (-3) (11) (by decide) (by decide)
  · change ((-5 : ℤ) : ℚ) = (scale : ℚ) * (-5 / 22 : ℚ)
    exact eq_smul_div (-5) scale (-5) (22) (by decide) (by decide)
  · change ((-5 : ℤ) : ℚ) = (scale : ℚ) * (-5 / 22 : ℚ)
    exact eq_smul_div (-5) scale (-5) (22) (by decide) (by decide)
  · change ((-5 : ℤ) : ℚ) = (scale : ℚ) * (-5 / 22 : ℚ)
    exact eq_smul_div (-5) scale (-5) (22) (by decide) (by decide)
  · change ((-3 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-3) scale (-3) (22) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((-3 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-3) scale (-3) (22) (by decide) (by decide)
  · change ((-3 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-3) scale (-3) (22) (by decide) (by decide)
  · change ((-7 : ℤ) : ℚ) = (scale : ℚ) * (-7 / 22 : ℚ)
    exact eq_smul_div (-7) scale (-7) (22) (by decide) (by decide)

theorem XZ_scale_1 : toVec (XZ 1) = (scale : ℚ) • XCell1_1 := by
  funext i
  fin_cases i
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 11 : ℚ)
    exact eq_smul_div (-6) scale (-3) (11) (by decide) (by decide)
  · change ((2 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (2) scale (1) (11) (by decide) (by decide)
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-2) scale (-1) (11) (by decide) (by decide)
  · change ((1 : ℤ) : ℚ) = (scale : ℚ) * (1 / 22 : ℚ)
    exact eq_smul_div (1) scale (1) (22) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-3 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-3) scale (-3) (22) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((1 : ℤ) : ℚ) = (scale : ℚ) * (1 / 22 : ℚ)
    exact eq_smul_div (1) scale (1) (22) (by decide) (by decide)

theorem XZ_scale_2 : toVec (XZ 2) = (scale : ℚ) • XCell1_2 := by
  funext i
  fin_cases i
  · change ((2 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (2) scale (1) (11) (by decide) (by decide)
  · change ((-1 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 22 : ℚ)
    exact eq_smul_div (-1) scale (-1) (22) (by decide) (by decide)
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-2) scale (-1) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((-1 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 22 : ℚ)
    exact eq_smul_div (-1) scale (-1) (22) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((-1 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 22 : ℚ)
    exact eq_smul_div (-1) scale (-1) (22) (by decide) (by decide)

theorem XZ_scale_3 : toVec (XZ 3) = (scale : ℚ) • XCell1_3 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-1 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 22 : ℚ)
    exact eq_smul_div (-1) scale (-1) (22) (by decide) (by decide)
  · change ((1 : ℤ) : ℚ) = (scale : ℚ) * (1 / 22 : ℚ)
    exact eq_smul_div (1) scale (1) (22) (by decide) (by decide)
  · change ((1 : ℤ) : ℚ) = (scale : ℚ) * (1 / 22 : ℚ)
    exact eq_smul_div (1) scale (1) (22) (by decide) (by decide)
  · change ((2 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (2) scale (1) (11) (by decide) (by decide)
  · change ((-1 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 22 : ℚ)
    exact eq_smul_div (-1) scale (-1) (22) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-2) scale (-1) (11) (by decide) (by decide)

theorem XZ_scale_4 : toVec (XZ 4) = (scale : ℚ) • XCell1_4 := by
  funext i
  fin_cases i
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
  · change ((-3 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-3) scale (-3) (22) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((3 : ℤ) : ℚ) = (scale : ℚ) * (3 / 22 : ℚ)
    exact eq_smul_div (3) scale (3) (22) (by decide) (by decide)
  · change ((2 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (2) scale (1) (11) (by decide) (by decide)
  · change ((-3 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-3) scale (-3) (22) (by decide) (by decide)

theorem XZ_scale_5 : toVec (XZ 5) = (scale : ℚ) • XCell1_5 := by
  funext i
  fin_cases i
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-2) scale (-1) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((2 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (2) scale (1) (11) (by decide) (by decide)
  · change ((2 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (2) scale (1) (11) (by decide) (by decide)
  · change ((2 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (2) scale (1) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem XZ_scale_6 : toVec (XZ 6) = (scale : ℚ) • XCell1_6 := by
  funext i
  fin_cases i
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-2) scale (-1) (11) (by decide) (by decide)
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-4 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-4) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-4 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-4) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 11 : ℚ)
    exact eq_smul_div (-6) scale (-3) (11) (by decide) (by decide)

theorem XZ_scale_7 : toVec (XZ 7) = (scale : ℚ) • XCell1_7 := by
  funext i
  fin_cases i
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 11 : ℚ)
    exact eq_smul_div (-6) scale (-3) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-2) scale (-1) (11) (by decide) (by decide)
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 11 : ℚ)
    exact eq_smul_div (-6) scale (-3) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem XZ_scale_8 : toVec (XZ 8) = (scale : ℚ) • XCell1_8 := by
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

theorem XZ_scale_9 : toVec (XZ 9) = (scale : ℚ) • XCell1_9 := by
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

theorem XZ_scale_10 : toVec (XZ 10) = (scale : ℚ) • XCell1_10 := by
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

theorem XZ_scale_11 : toVec (XZ 11) = (scale : ℚ) • XCell1_11 := by
  funext i
  fin_cases i
  · change ((11 : ℤ) : ℚ) = (scale : ℚ) * (1 / 2 : ℚ)
    exact eq_smul_div (11) scale (1) (2) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem XZ_scale_12 : toVec (XZ 12) = (scale : ℚ) • XCell1_12 := by
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

theorem XZ_scale_13 : toVec (XZ 13) = (scale : ℚ) • XCell1_13 := by
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

theorem XZ_scale_14 : toVec (XZ 14) = (scale : ℚ) • XCell1_14 := by
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

theorem XZ_scale_15 : toVec (XZ 15) = (scale : ℚ) • XCell1_15 := by
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

theorem XZ_scale_16 : toVec (XZ 16) = (scale : ℚ) • XCell1_16 := by
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

theorem XZ_scale_17 : toVec (XZ 17) = (scale : ℚ) • XCell1_17 := by
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

theorem XZ_scale_18 : toVec (XZ 18) = (scale : ℚ) • XCell1_18 := by
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

theorem XZ_scale_19 : toVec (XZ 19) = (scale : ℚ) • XCell1_19 := by
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
    toVec (XZ k) = (scale : ℚ) • XVec (1 : Fin 10) k := by
  fin_cases k
  · simp [XVec, XRow1]; exact XZ_scale_0
  · simp [XVec, XRow1]; exact XZ_scale_1
  · simp [XVec, XRow1]; exact XZ_scale_2
  · simp [XVec, XRow1]; exact XZ_scale_3
  · simp [XVec, XRow1]; exact XZ_scale_4
  · simp [XVec, XRow1]; exact XZ_scale_5
  · simp [XVec, XRow1]; exact XZ_scale_6
  · simp [XVec, XRow1]; exact XZ_scale_7
  · simp [XVec, XRow1]; exact XZ_scale_8
  · simp [XVec, XRow1]; exact XZ_scale_9
  · simp [XVec, XRow1]; exact XZ_scale_10
  · simp [XVec, XRow1]; exact XZ_scale_11
  · simp [XVec, XRow1]; exact XZ_scale_12
  · simp [XVec, XRow1]; exact XZ_scale_13
  · simp [XVec, XRow1]; exact XZ_scale_14
  · simp [XVec, XRow1]; exact XZ_scale_15
  · simp [XVec, XRow1]; exact XZ_scale_16
  · simp [XVec, XRow1]; exact XZ_scale_17
  · simp [XVec, XRow1]; exact XZ_scale_18
  · simp [XVec, XRow1]; exact XZ_scale_19

theorem AZ_scale_0 : toVec (AZ 0) = (scale : ℚ) • ACell0_6 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (4) scale (2) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (4) scale (2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem AZ_scale_1 : toVec (AZ 1) = (scale : ℚ) • ACell1_6 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (4) scale (2) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (4) scale (2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
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
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (4) scale (2) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (4) scale (2) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (4) scale (2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (4) scale (2) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (4) scale (2) (11) (by decide) (by decide)
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (4 / 11 : ℚ)
    exact eq_smul_div (8) scale (4) (11) (by decide) (by decide)
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (4 / 11 : ℚ)
    exact eq_smul_div (8) scale (4) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (4) scale (2) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (4) scale (2) (11) (by decide) (by decide)

theorem AZ_scale_3 : toVec (AZ 3) = (scale : ℚ) • ACell3_6 := by
  funext i
  fin_cases i
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (4) scale (2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (4) scale (2) (11) (by decide) (by decide)
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (4 / 11 : ℚ)
    exact eq_smul_div (8) scale (4) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (4) scale (2) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (4) scale (2) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (4) scale (2) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (4) scale (2) (11) (by decide) (by decide)
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (4 / 11 : ℚ)
    exact eq_smul_div (8) scale (4) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (4) scale (2) (11) (by decide) (by decide)

theorem AZ_scale_4 : toVec (AZ 4) = (scale : ℚ) • ACell4_6 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (4) scale (2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (4) scale (2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)

theorem AZ_scale_5 : toVec (AZ 5) = (scale : ℚ) • ACell5_6 := by
  funext i
  fin_cases i
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-2) scale (-1) (11) (by decide) (by decide)
  · change ((2 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (2) scale (1) (11) (by decide) (by decide)
  · change ((2 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (2) scale (1) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((2 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (2) scale (1) (11) (by decide) (by decide)
  · change ((2 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (2) scale (1) (11) (by decide) (by decide)
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-2) scale (-1) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem AZ_scale_6 : toVec (AZ 6) = (scale : ℚ) • ACell6_6 := by
  funext i
  fin_cases i
  · change ((-24 : ℤ) : ℚ) = (scale : ℚ) * (-12 / 11 : ℚ)
    exact eq_smul_div (-24) scale (-12) (11) (by decide) (by decide)
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
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((2 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (2) scale (1) (11) (by decide) (by decide)
  · change ((2 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (2) scale (1) (11) (by decide) (by decide)

theorem AZ_scale_7 : toVec (AZ 7) = (scale : ℚ) • ACell7_6 := by
  funext i
  fin_cases i
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-2) scale (-1) (11) (by decide) (by decide)
  · change ((2 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (2) scale (1) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (4) scale (2) (11) (by decide) (by decide)
  · change ((2 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (2) scale (1) (11) (by decide) (by decide)
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-2) scale (-1) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-2) scale (-1) (11) (by decide) (by decide)
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-2) scale (-1) (11) (by decide) (by decide)
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
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-2) scale (-1) (11) (by decide) (by decide)
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-2) scale (-1) (11) (by decide) (by decide)
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 11 : ℚ)
    exact eq_smul_div (-6) scale (-3) (11) (by decide) (by decide)
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-2) scale (-1) (11) (by decide) (by decide)
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-2) scale (-1) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)

theorem AZ_scale_9 : toVec (AZ 9) = (scale : ℚ) • ACell9_6 := by
  funext i
  fin_cases i
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
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((2 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (2) scale (1) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (4) scale (2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (3 / 11 : ℚ)
    exact eq_smul_div (6) scale (3) (11) (by decide) (by decide)

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
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (4) scale (2) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (4) scale (2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem AZ_scale_11 : toVec (AZ 11) = (scale : ℚ) • ACell11_6 := by
  funext i
  fin_cases i
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-4 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-4) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-4 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-4) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)

theorem AZ_scale_12 : toVec (AZ 12) = (scale : ℚ) • ACell12_6 := by
  funext i
  fin_cases i
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (4) scale (2) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (4) scale (2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (4) scale (2) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (4) scale (2) (11) (by decide) (by decide)
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (4 / 11 : ℚ)
    exact eq_smul_div (8) scale (4) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (4) scale (2) (11) (by decide) (by decide)
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (4 / 11 : ℚ)
    exact eq_smul_div (8) scale (4) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (4) scale (2) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (4) scale (2) (11) (by decide) (by decide)

theorem AZ_scale_13 : toVec (AZ 13) = (scale : ℚ) • ACell13_6 := by
  funext i
  fin_cases i
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (4) scale (2) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (4) scale (2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
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
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (4) scale (2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (4) scale (2) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem AZ_scale_15 : toVec (AZ 15) = (scale : ℚ) • ACell15_6 := by
  funext i
  fin_cases i
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-2) scale (-1) (11) (by decide) (by decide)
  · change ((2 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (2) scale (1) (11) (by decide) (by decide)
  · change ((2 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (2) scale (1) (11) (by decide) (by decide)
  · change ((2 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (2) scale (1) (11) (by decide) (by decide)
  · change ((2 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (2) scale (1) (11) (by decide) (by decide)
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-2) scale (-1) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem AZ_scale_16 : toVec (AZ 16) = (scale : ℚ) • ACell16_6 := by
  funext i
  fin_cases i
  · change ((24 : ℤ) : ℚ) = (scale : ℚ) * (12 / 11 : ℚ)
    exact eq_smul_div (24) scale (12) (11) (by decide) (by decide)
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

theorem AZ_scale_17 : toVec (AZ 17) = (scale : ℚ) • ACell17_6 := by
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

theorem AZ_scale_18 : toVec (AZ 18) = (scale : ℚ) • ACell18_6 := by
  funext i
  fin_cases i
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-2) scale (-1) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 11 : ℚ)
    exact eq_smul_div (-6) scale (-3) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-2) scale (-1) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-2) scale (-1) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-2) scale (-1) (11) (by decide) (by decide)

theorem AZ_scale_19 : toVec (AZ 19) = (scale : ℚ) • ACell19_6 := by
  funext i
  fin_cases i
  · change ((2 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (2) scale (1) (11) (by decide) (by decide)
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-2) scale (-1) (11) (by decide) (by decide)
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-2) scale (-1) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (4) scale (2) (11) (by decide) (by decide)
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

theorem entry_eq :
    (matrixMul XVec AVec) (1 : Fin 10) (6 : Fin 10) =
      ![0, 0, 0, 0, 0, 0, 0, 0, 0, 0] := by
  unfold matrixMul
  refine sum_mul_eq_of_scaled scale scale_ne_zero
    (fun k => XVec (1 : Fin 10) k)
    (fun k => AVec k (6 : Fin 10))
    XZ AZ XZ_scale AZ_scale entryZ rfl _ ?_
  rw [entryZ_eq, toVec_zeroZ_smul, vec_zero_eq]

theorem entry_eq_matrixOne :
    (matrixMul XVec AVec) (1 : Fin 10) (6 : Fin 10) =
      matrixOne (Fin 10) (1 : Fin 10) (6 : Fin 10) := by
  rw [entry_eq]
  have hne : (1 : Fin 10) ≠ (6 : Fin 10) := by decide
  funext n
  fin_cases n <;> simp [matrixOne, constVec, basis, *]

end V14Formalization.D12PiecePASplitEntry1_6


namespace V14Formalization.D12PiecePASplitEntry1_7
open D12CyclotomicVec D12CyclotomicVecZ D12PiecePAData
def payloadSha256 : String := "76c6196f29afe1a8398af99502447f48ebeed4bcb3805fc5dbec693940bc04b0"

def scale : ℤ := 22

def XZ (k : Fin 20) : VecZ :=
  match k.val with
  | 0 => #v[-3, -6, -5, -5, -5, -3, -4, -3, -3, -7]
  | 1 => #v[-6, 2, -2, 1, 0, -3, 0, -4, 0, 1]
  | 2 => #v[2, -1, -2, 0, 0, 0, -4, -1, -4, -1]
  | 3 => #v[0, -1, 1, 1, 2, -1, 0, 0, 0, -2]
  | 4 => #v[3, 0, 3, 3, 3, -3, 0, 3, 2, -3]
  | 5 => #v[-2, 0, 0, 0, 0, -4, 2, 2, 2, 0]
  | 6 => #v[-2, -8, -4, -4, -4, -4, -8, 0, -4, -6]
  | 7 => #v[-4, 0, 0, -6, -4, 0, -2, -6, 0, 0]
  | 8 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  | 9 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  | 10 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  | 11 => #v[11, 0, 0, 0, 0, 0, 0, 0, 0, 0]
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
  | 0 => #v[0, 0, 4, -4, -4, 4, 0, 0, 0, 0]
  | 1 => #v[-4, -4, -4, -4, 0, -4, -8, -4, -8, -4]
  | 2 => #v[-4, 0, -4, -4, -8, -4, -4, -8, -4, -4]
  | 3 => #v[0, -4, 0, 0, 4, 4, 0, 0, -4, 0]
  | 4 => #v[0, -4, 4, 0, 0, 0, 4, -4, 0, 0]
  | 5 => #v[-4, -2, -2, -6, -2, -2, -4, 0, 0, 0]
  | 6 => #v[-2, 2, 4, 2, -2, 0, 0, -2, -2, 0]
  | 7 => #v[-26, 2, -4, 0, -2, -4, -2, -2, -4, -2]
  | 8 => #v[0, 2, 4, 2, 4, -2, 4, 2, 4, 2]
  | 9 => #v[0, 4, 2, 2, 4, 0, 0, 2, 6, 2]
  | 10 => #v[4, 8, 4, 4, 4, 4, 8, 4, 0, 4]
  | 11 => #v[-4, -4, -8, -4, -4, -4, -8, -4, -4, 0]
  | 12 => #v[-4, 4, 0, 0, 0, 4, -4, 0, 0, 0]
  | 13 => #v[4, 4, 0, 4, 4, 8, 4, 8, 4, 4]
  | 14 => #v[0, 0, 0, 0, 0, 0, 4, -4, -4, 4]
  | 15 => #v[0, 2, 4, 2, 4, -2, 4, 2, 4, 2]
  | 16 => #v[-2, -4, -2, -2, -4, -2, 0, -4, 2, -4]
  | 17 => #v[26, 0, -2, -2, 2, 0, 0, 2, -2, -2]
  | 18 => #v[2, 6, 4, 4, 6, 6, 4, 4, 6, 2]
  | 19 => #v[0, 4, 0, 0, 2, -2, -2, -2, -2, 2]
  | _ => zeroZ

def entryZ : VecZ := sumFin (fun k => mulZ (XZ k) (AZ k))

theorem entryZ_eq : entryZ = zeroZ := by
  decide +kernel

theorem scale_ne_zero : scale ≠ 0 := by
  decide

theorem XZ_scale_0 : toVec (XZ 0) = (scale : ℚ) • XCell1_0 := by
  funext i
  fin_cases i
  · change ((-3 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-3) scale (-3) (22) (by decide) (by decide)
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 11 : ℚ)
    exact eq_smul_div (-6) scale (-3) (11) (by decide) (by decide)
  · change ((-5 : ℤ) : ℚ) = (scale : ℚ) * (-5 / 22 : ℚ)
    exact eq_smul_div (-5) scale (-5) (22) (by decide) (by decide)
  · change ((-5 : ℤ) : ℚ) = (scale : ℚ) * (-5 / 22 : ℚ)
    exact eq_smul_div (-5) scale (-5) (22) (by decide) (by decide)
  · change ((-5 : ℤ) : ℚ) = (scale : ℚ) * (-5 / 22 : ℚ)
    exact eq_smul_div (-5) scale (-5) (22) (by decide) (by decide)
  · change ((-3 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-3) scale (-3) (22) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((-3 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-3) scale (-3) (22) (by decide) (by decide)
  · change ((-3 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-3) scale (-3) (22) (by decide) (by decide)
  · change ((-7 : ℤ) : ℚ) = (scale : ℚ) * (-7 / 22 : ℚ)
    exact eq_smul_div (-7) scale (-7) (22) (by decide) (by decide)

theorem XZ_scale_1 : toVec (XZ 1) = (scale : ℚ) • XCell1_1 := by
  funext i
  fin_cases i
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 11 : ℚ)
    exact eq_smul_div (-6) scale (-3) (11) (by decide) (by decide)
  · change ((2 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (2) scale (1) (11) (by decide) (by decide)
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-2) scale (-1) (11) (by decide) (by decide)
  · change ((1 : ℤ) : ℚ) = (scale : ℚ) * (1 / 22 : ℚ)
    exact eq_smul_div (1) scale (1) (22) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-3 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-3) scale (-3) (22) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((1 : ℤ) : ℚ) = (scale : ℚ) * (1 / 22 : ℚ)
    exact eq_smul_div (1) scale (1) (22) (by decide) (by decide)

theorem XZ_scale_2 : toVec (XZ 2) = (scale : ℚ) • XCell1_2 := by
  funext i
  fin_cases i
  · change ((2 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (2) scale (1) (11) (by decide) (by decide)
  · change ((-1 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 22 : ℚ)
    exact eq_smul_div (-1) scale (-1) (22) (by decide) (by decide)
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-2) scale (-1) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((-1 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 22 : ℚ)
    exact eq_smul_div (-1) scale (-1) (22) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((-1 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 22 : ℚ)
    exact eq_smul_div (-1) scale (-1) (22) (by decide) (by decide)

theorem XZ_scale_3 : toVec (XZ 3) = (scale : ℚ) • XCell1_3 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-1 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 22 : ℚ)
    exact eq_smul_div (-1) scale (-1) (22) (by decide) (by decide)
  · change ((1 : ℤ) : ℚ) = (scale : ℚ) * (1 / 22 : ℚ)
    exact eq_smul_div (1) scale (1) (22) (by decide) (by decide)
  · change ((1 : ℤ) : ℚ) = (scale : ℚ) * (1 / 22 : ℚ)
    exact eq_smul_div (1) scale (1) (22) (by decide) (by decide)
  · change ((2 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (2) scale (1) (11) (by decide) (by decide)
  · change ((-1 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 22 : ℚ)
    exact eq_smul_div (-1) scale (-1) (22) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-2) scale (-1) (11) (by decide) (by decide)

theorem XZ_scale_4 : toVec (XZ 4) = (scale : ℚ) • XCell1_4 := by
  funext i
  fin_cases i
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
  · change ((-3 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-3) scale (-3) (22) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((3 : ℤ) : ℚ) = (scale : ℚ) * (3 / 22 : ℚ)
    exact eq_smul_div (3) scale (3) (22) (by decide) (by decide)
  · change ((2 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (2) scale (1) (11) (by decide) (by decide)
  · change ((-3 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-3) scale (-3) (22) (by decide) (by decide)

theorem XZ_scale_5 : toVec (XZ 5) = (scale : ℚ) • XCell1_5 := by
  funext i
  fin_cases i
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-2) scale (-1) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((2 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (2) scale (1) (11) (by decide) (by decide)
  · change ((2 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (2) scale (1) (11) (by decide) (by decide)
  · change ((2 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (2) scale (1) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem XZ_scale_6 : toVec (XZ 6) = (scale : ℚ) • XCell1_6 := by
  funext i
  fin_cases i
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-2) scale (-1) (11) (by decide) (by decide)
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-4 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-4) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-4 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-4) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 11 : ℚ)
    exact eq_smul_div (-6) scale (-3) (11) (by decide) (by decide)

theorem XZ_scale_7 : toVec (XZ 7) = (scale : ℚ) • XCell1_7 := by
  funext i
  fin_cases i
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 11 : ℚ)
    exact eq_smul_div (-6) scale (-3) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-2) scale (-1) (11) (by decide) (by decide)
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 11 : ℚ)
    exact eq_smul_div (-6) scale (-3) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem XZ_scale_8 : toVec (XZ 8) = (scale : ℚ) • XCell1_8 := by
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

theorem XZ_scale_9 : toVec (XZ 9) = (scale : ℚ) • XCell1_9 := by
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

theorem XZ_scale_10 : toVec (XZ 10) = (scale : ℚ) • XCell1_10 := by
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

theorem XZ_scale_11 : toVec (XZ 11) = (scale : ℚ) • XCell1_11 := by
  funext i
  fin_cases i
  · change ((11 : ℤ) : ℚ) = (scale : ℚ) * (1 / 2 : ℚ)
    exact eq_smul_div (11) scale (1) (2) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem XZ_scale_12 : toVec (XZ 12) = (scale : ℚ) • XCell1_12 := by
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

theorem XZ_scale_13 : toVec (XZ 13) = (scale : ℚ) • XCell1_13 := by
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

theorem XZ_scale_14 : toVec (XZ 14) = (scale : ℚ) • XCell1_14 := by
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

theorem XZ_scale_15 : toVec (XZ 15) = (scale : ℚ) • XCell1_15 := by
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

theorem XZ_scale_16 : toVec (XZ 16) = (scale : ℚ) • XCell1_16 := by
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

theorem XZ_scale_17 : toVec (XZ 17) = (scale : ℚ) • XCell1_17 := by
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

theorem XZ_scale_18 : toVec (XZ 18) = (scale : ℚ) • XCell1_18 := by
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

theorem XZ_scale_19 : toVec (XZ 19) = (scale : ℚ) • XCell1_19 := by
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
    toVec (XZ k) = (scale : ℚ) • XVec (1 : Fin 10) k := by
  fin_cases k
  · simp [XVec, XRow1]; exact XZ_scale_0
  · simp [XVec, XRow1]; exact XZ_scale_1
  · simp [XVec, XRow1]; exact XZ_scale_2
  · simp [XVec, XRow1]; exact XZ_scale_3
  · simp [XVec, XRow1]; exact XZ_scale_4
  · simp [XVec, XRow1]; exact XZ_scale_5
  · simp [XVec, XRow1]; exact XZ_scale_6
  · simp [XVec, XRow1]; exact XZ_scale_7
  · simp [XVec, XRow1]; exact XZ_scale_8
  · simp [XVec, XRow1]; exact XZ_scale_9
  · simp [XVec, XRow1]; exact XZ_scale_10
  · simp [XVec, XRow1]; exact XZ_scale_11
  · simp [XVec, XRow1]; exact XZ_scale_12
  · simp [XVec, XRow1]; exact XZ_scale_13
  · simp [XVec, XRow1]; exact XZ_scale_14
  · simp [XVec, XRow1]; exact XZ_scale_15
  · simp [XVec, XRow1]; exact XZ_scale_16
  · simp [XVec, XRow1]; exact XZ_scale_17
  · simp [XVec, XRow1]; exact XZ_scale_18
  · simp [XVec, XRow1]; exact XZ_scale_19

theorem AZ_scale_0 : toVec (AZ 0) = (scale : ℚ) • ACell0_7 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (4) scale (2) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (4) scale (2) (11) (by decide) (by decide)
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
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-4 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-4) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-4 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-4) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)

theorem AZ_scale_2 : toVec (AZ 2) = (scale : ℚ) • ACell2_7 := by
  funext i
  fin_cases i
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-4 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-4) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-4 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-4) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)

theorem AZ_scale_3 : toVec (AZ 3) = (scale : ℚ) • ACell3_7 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (4) scale (2) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (4) scale (2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem AZ_scale_4 : toVec (AZ 4) = (scale : ℚ) • ACell4_7 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (4) scale (2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (4) scale (2) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem AZ_scale_5 : toVec (AZ 5) = (scale : ℚ) • ACell5_7 := by
  funext i
  fin_cases i
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-2) scale (-1) (11) (by decide) (by decide)
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-2) scale (-1) (11) (by decide) (by decide)
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 11 : ℚ)
    exact eq_smul_div (-6) scale (-3) (11) (by decide) (by decide)
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-2) scale (-1) (11) (by decide) (by decide)
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-2) scale (-1) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem AZ_scale_6 : toVec (AZ 6) = (scale : ℚ) • ACell6_7 := by
  funext i
  fin_cases i
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-2) scale (-1) (11) (by decide) (by decide)
  · change ((2 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (2) scale (1) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (4) scale (2) (11) (by decide) (by decide)
  · change ((2 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (2) scale (1) (11) (by decide) (by decide)
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-2) scale (-1) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-2) scale (-1) (11) (by decide) (by decide)
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-2) scale (-1) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem AZ_scale_7 : toVec (AZ 7) = (scale : ℚ) • ACell7_7 := by
  funext i
  fin_cases i
  · change ((-26 : ℤ) : ℚ) = (scale : ℚ) * (-13 / 11 : ℚ)
    exact eq_smul_div (-26) scale (-13) (11) (by decide) (by decide)
  · change ((2 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (2) scale (1) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
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

theorem AZ_scale_8 : toVec (AZ 8) = (scale : ℚ) • ACell8_7 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((2 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (2) scale (1) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (4) scale (2) (11) (by decide) (by decide)
  · change ((2 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (2) scale (1) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (4) scale (2) (11) (by decide) (by decide)
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-2) scale (-1) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (4) scale (2) (11) (by decide) (by decide)
  · change ((2 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (2) scale (1) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (4) scale (2) (11) (by decide) (by decide)
  · change ((2 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (2) scale (1) (11) (by decide) (by decide)

theorem AZ_scale_9 : toVec (AZ 9) = (scale : ℚ) • ACell9_7 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
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

theorem AZ_scale_10 : toVec (AZ 10) = (scale : ℚ) • ACell10_7 := by
  funext i
  fin_cases i
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (4) scale (2) (11) (by decide) (by decide)
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (4 / 11 : ℚ)
    exact eq_smul_div (8) scale (4) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (4) scale (2) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (4) scale (2) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (4) scale (2) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (4) scale (2) (11) (by decide) (by decide)
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (4 / 11 : ℚ)
    exact eq_smul_div (8) scale (4) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (4) scale (2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (4) scale (2) (11) (by decide) (by decide)

theorem AZ_scale_11 : toVec (AZ 11) = (scale : ℚ) • ACell11_7 := by
  funext i
  fin_cases i
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-4 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-4) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-4 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-4) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem AZ_scale_12 : toVec (AZ 12) = (scale : ℚ) • ACell12_7 := by
  funext i
  fin_cases i
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (4) scale (2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (4) scale (2) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem AZ_scale_13 : toVec (AZ 13) = (scale : ℚ) • ACell13_7 := by
  funext i
  fin_cases i
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (4) scale (2) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (4) scale (2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (4) scale (2) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (4) scale (2) (11) (by decide) (by decide)
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (4 / 11 : ℚ)
    exact eq_smul_div (8) scale (4) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (4) scale (2) (11) (by decide) (by decide)
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (4 / 11 : ℚ)
    exact eq_smul_div (8) scale (4) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (4) scale (2) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (4) scale (2) (11) (by decide) (by decide)

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
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (4) scale (2) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (4) scale (2) (11) (by decide) (by decide)

theorem AZ_scale_15 : toVec (AZ 15) = (scale : ℚ) • ACell15_7 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((2 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (2) scale (1) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (4) scale (2) (11) (by decide) (by decide)
  · change ((2 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (2) scale (1) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (4) scale (2) (11) (by decide) (by decide)
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-2) scale (-1) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (4) scale (2) (11) (by decide) (by decide)
  · change ((2 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (2) scale (1) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (4) scale (2) (11) (by decide) (by decide)
  · change ((2 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (2) scale (1) (11) (by decide) (by decide)

theorem AZ_scale_16 : toVec (AZ 16) = (scale : ℚ) • ACell16_7 := by
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

theorem AZ_scale_17 : toVec (AZ 17) = (scale : ℚ) • ACell17_7 := by
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

theorem AZ_scale_18 : toVec (AZ 18) = (scale : ℚ) • ACell18_7 := by
  funext i
  fin_cases i
  · change ((2 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (2) scale (1) (11) (by decide) (by decide)
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (3 / 11 : ℚ)
    exact eq_smul_div (6) scale (3) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (4) scale (2) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (4) scale (2) (11) (by decide) (by decide)
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (3 / 11 : ℚ)
    exact eq_smul_div (6) scale (3) (11) (by decide) (by decide)
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (3 / 11 : ℚ)
    exact eq_smul_div (6) scale (3) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (4) scale (2) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (4) scale (2) (11) (by decide) (by decide)
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (3 / 11 : ℚ)
    exact eq_smul_div (6) scale (3) (11) (by decide) (by decide)
  · change ((2 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (2) scale (1) (11) (by decide) (by decide)

theorem AZ_scale_19 : toVec (AZ 19) = (scale : ℚ) • ACell19_7 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (4) scale (2) (11) (by decide) (by decide)
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
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-2) scale (-1) (11) (by decide) (by decide)
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-2) scale (-1) (11) (by decide) (by decide)
  · change ((2 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (2) scale (1) (11) (by decide) (by decide)

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

theorem entry_eq :
    (matrixMul XVec AVec) (1 : Fin 10) (7 : Fin 10) =
      ![0, 0, 0, 0, 0, 0, 0, 0, 0, 0] := by
  unfold matrixMul
  refine sum_mul_eq_of_scaled scale scale_ne_zero
    (fun k => XVec (1 : Fin 10) k)
    (fun k => AVec k (7 : Fin 10))
    XZ AZ XZ_scale AZ_scale entryZ rfl _ ?_
  rw [entryZ_eq, toVec_zeroZ_smul, vec_zero_eq]

theorem entry_eq_matrixOne :
    (matrixMul XVec AVec) (1 : Fin 10) (7 : Fin 10) =
      matrixOne (Fin 10) (1 : Fin 10) (7 : Fin 10) := by
  rw [entry_eq]
  have hne : (1 : Fin 10) ≠ (7 : Fin 10) := by decide
  funext n
  fin_cases n <;> simp [matrixOne, constVec, basis, *]

end V14Formalization.D12PiecePASplitEntry1_7


namespace V14Formalization.D12PiecePASplitEntry1_8
open D12CyclotomicVec D12CyclotomicVecZ D12PiecePAData
def payloadSha256 : String := "76c6196f29afe1a8398af99502447f48ebeed4bcb3805fc5dbec693940bc04b0"

def scale : ℤ := 22

def XZ (k : Fin 20) : VecZ :=
  match k.val with
  | 0 => #v[-3, -6, -5, -5, -5, -3, -4, -3, -3, -7]
  | 1 => #v[-6, 2, -2, 1, 0, -3, 0, -4, 0, 1]
  | 2 => #v[2, -1, -2, 0, 0, 0, -4, -1, -4, -1]
  | 3 => #v[0, -1, 1, 1, 2, -1, 0, 0, 0, -2]
  | 4 => #v[3, 0, 3, 3, 3, -3, 0, 3, 2, -3]
  | 5 => #v[-2, 0, 0, 0, 0, -4, 2, 2, 2, 0]
  | 6 => #v[-2, -8, -4, -4, -4, -4, -8, 0, -4, -6]
  | 7 => #v[-4, 0, 0, -6, -4, 0, -2, -6, 0, 0]
  | 8 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  | 9 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  | 10 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  | 11 => #v[11, 0, 0, 0, 0, 0, 0, 0, 0, 0]
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
  | 0 => #v[0, -4, 0, -4, 0, 0, 4, 0, 0, 4]
  | 1 => #v[0, 0, -4, 4, 0, 0, 0, 0, 4, -4]
  | 2 => #v[0, -4, 0, 4, 0, 4, 0, -4, 0, 0]
  | 3 => #v[4, 4, 4, 4, 4, 4, 4, 0, 8, 8]
  | 4 => #v[-4, -4, -8, -8, -4, -4, 0, -4, -4, -4]
  | 5 => #v[-2, 0, 0, -2, 0, 2, -2, 4, -2, 2]
  | 6 => #v[0, 0, 0, -4, -2, -2, -6, -2, -2, -4]
  | 7 => #v[0, 2, 4, 2, 4, -2, 4, 2, 4, 2]
  | 8 => #v[-24, -2, 2, 0, 0, 2, -2, -2, 0, 4]
  | 9 => #v[-4, -6, -4, 0, -2, -2, 0, 0, -2, -2]
  | 10 => #v[0, -4, 4, 0, 0, 0, 0, 4, -4, 0]
  | 11 => #v[0, -8, -4, -4, -4, -4, -4, -4, -4, -8]
  | 12 => #v[4, 4, 8, 4, 4, 4, 8, 4, 4, 0]
  | 13 => #v[4, 4, 4, 4, 0, 4, 8, 4, 8, 4]
  | 14 => #v[-4, -4, -8, -4, -8, -4, -4, 0, -4, -4]
  | 15 => #v[-2, -2, 0, -4, -4, -2, 2, -2, -4, -4]
  | 16 => #v[-2, 0, -2, -4, -4, -2, 0, -2, 0, -6]
  | 17 => #v[-4, -6, -4, 0, -2, -2, 0, 0, -2, -2]
  | 18 => #v[26, 0, 0, 2, -2, -2, -2, -2, 2, 0]
  | 19 => #v[-2, 2, -4, 2, -2, 0, 2, 0, 0, 2]
  | _ => zeroZ

def entryZ : VecZ := sumFin (fun k => mulZ (XZ k) (AZ k))

theorem entryZ_eq : entryZ = zeroZ := by
  decide +kernel

theorem scale_ne_zero : scale ≠ 0 := by
  decide

theorem XZ_scale_0 : toVec (XZ 0) = (scale : ℚ) • XCell1_0 := by
  funext i
  fin_cases i
  · change ((-3 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-3) scale (-3) (22) (by decide) (by decide)
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 11 : ℚ)
    exact eq_smul_div (-6) scale (-3) (11) (by decide) (by decide)
  · change ((-5 : ℤ) : ℚ) = (scale : ℚ) * (-5 / 22 : ℚ)
    exact eq_smul_div (-5) scale (-5) (22) (by decide) (by decide)
  · change ((-5 : ℤ) : ℚ) = (scale : ℚ) * (-5 / 22 : ℚ)
    exact eq_smul_div (-5) scale (-5) (22) (by decide) (by decide)
  · change ((-5 : ℤ) : ℚ) = (scale : ℚ) * (-5 / 22 : ℚ)
    exact eq_smul_div (-5) scale (-5) (22) (by decide) (by decide)
  · change ((-3 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-3) scale (-3) (22) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((-3 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-3) scale (-3) (22) (by decide) (by decide)
  · change ((-3 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-3) scale (-3) (22) (by decide) (by decide)
  · change ((-7 : ℤ) : ℚ) = (scale : ℚ) * (-7 / 22 : ℚ)
    exact eq_smul_div (-7) scale (-7) (22) (by decide) (by decide)

theorem XZ_scale_1 : toVec (XZ 1) = (scale : ℚ) • XCell1_1 := by
  funext i
  fin_cases i
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 11 : ℚ)
    exact eq_smul_div (-6) scale (-3) (11) (by decide) (by decide)
  · change ((2 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (2) scale (1) (11) (by decide) (by decide)
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-2) scale (-1) (11) (by decide) (by decide)
  · change ((1 : ℤ) : ℚ) = (scale : ℚ) * (1 / 22 : ℚ)
    exact eq_smul_div (1) scale (1) (22) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-3 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-3) scale (-3) (22) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((1 : ℤ) : ℚ) = (scale : ℚ) * (1 / 22 : ℚ)
    exact eq_smul_div (1) scale (1) (22) (by decide) (by decide)

theorem XZ_scale_2 : toVec (XZ 2) = (scale : ℚ) • XCell1_2 := by
  funext i
  fin_cases i
  · change ((2 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (2) scale (1) (11) (by decide) (by decide)
  · change ((-1 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 22 : ℚ)
    exact eq_smul_div (-1) scale (-1) (22) (by decide) (by decide)
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-2) scale (-1) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((-1 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 22 : ℚ)
    exact eq_smul_div (-1) scale (-1) (22) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((-1 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 22 : ℚ)
    exact eq_smul_div (-1) scale (-1) (22) (by decide) (by decide)

theorem XZ_scale_3 : toVec (XZ 3) = (scale : ℚ) • XCell1_3 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-1 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 22 : ℚ)
    exact eq_smul_div (-1) scale (-1) (22) (by decide) (by decide)
  · change ((1 : ℤ) : ℚ) = (scale : ℚ) * (1 / 22 : ℚ)
    exact eq_smul_div (1) scale (1) (22) (by decide) (by decide)
  · change ((1 : ℤ) : ℚ) = (scale : ℚ) * (1 / 22 : ℚ)
    exact eq_smul_div (1) scale (1) (22) (by decide) (by decide)
  · change ((2 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (2) scale (1) (11) (by decide) (by decide)
  · change ((-1 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 22 : ℚ)
    exact eq_smul_div (-1) scale (-1) (22) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-2) scale (-1) (11) (by decide) (by decide)

theorem XZ_scale_4 : toVec (XZ 4) = (scale : ℚ) • XCell1_4 := by
  funext i
  fin_cases i
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
  · change ((-3 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-3) scale (-3) (22) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((3 : ℤ) : ℚ) = (scale : ℚ) * (3 / 22 : ℚ)
    exact eq_smul_div (3) scale (3) (22) (by decide) (by decide)
  · change ((2 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (2) scale (1) (11) (by decide) (by decide)
  · change ((-3 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-3) scale (-3) (22) (by decide) (by decide)

theorem XZ_scale_5 : toVec (XZ 5) = (scale : ℚ) • XCell1_5 := by
  funext i
  fin_cases i
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-2) scale (-1) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((2 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (2) scale (1) (11) (by decide) (by decide)
  · change ((2 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (2) scale (1) (11) (by decide) (by decide)
  · change ((2 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (2) scale (1) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem XZ_scale_6 : toVec (XZ 6) = (scale : ℚ) • XCell1_6 := by
  funext i
  fin_cases i
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-2) scale (-1) (11) (by decide) (by decide)
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-4 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-4) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-4 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-4) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 11 : ℚ)
    exact eq_smul_div (-6) scale (-3) (11) (by decide) (by decide)

theorem XZ_scale_7 : toVec (XZ 7) = (scale : ℚ) • XCell1_7 := by
  funext i
  fin_cases i
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 11 : ℚ)
    exact eq_smul_div (-6) scale (-3) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-2) scale (-1) (11) (by decide) (by decide)
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 11 : ℚ)
    exact eq_smul_div (-6) scale (-3) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem XZ_scale_8 : toVec (XZ 8) = (scale : ℚ) • XCell1_8 := by
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

theorem XZ_scale_9 : toVec (XZ 9) = (scale : ℚ) • XCell1_9 := by
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

theorem XZ_scale_10 : toVec (XZ 10) = (scale : ℚ) • XCell1_10 := by
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

theorem XZ_scale_11 : toVec (XZ 11) = (scale : ℚ) • XCell1_11 := by
  funext i
  fin_cases i
  · change ((11 : ℤ) : ℚ) = (scale : ℚ) * (1 / 2 : ℚ)
    exact eq_smul_div (11) scale (1) (2) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem XZ_scale_12 : toVec (XZ 12) = (scale : ℚ) • XCell1_12 := by
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

theorem XZ_scale_13 : toVec (XZ 13) = (scale : ℚ) • XCell1_13 := by
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

theorem XZ_scale_14 : toVec (XZ 14) = (scale : ℚ) • XCell1_14 := by
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

theorem XZ_scale_15 : toVec (XZ 15) = (scale : ℚ) • XCell1_15 := by
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

theorem XZ_scale_16 : toVec (XZ 16) = (scale : ℚ) • XCell1_16 := by
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

theorem XZ_scale_17 : toVec (XZ 17) = (scale : ℚ) • XCell1_17 := by
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

theorem XZ_scale_18 : toVec (XZ 18) = (scale : ℚ) • XCell1_18 := by
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

theorem XZ_scale_19 : toVec (XZ 19) = (scale : ℚ) • XCell1_19 := by
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
    toVec (XZ k) = (scale : ℚ) • XVec (1 : Fin 10) k := by
  fin_cases k
  · simp [XVec, XRow1]; exact XZ_scale_0
  · simp [XVec, XRow1]; exact XZ_scale_1
  · simp [XVec, XRow1]; exact XZ_scale_2
  · simp [XVec, XRow1]; exact XZ_scale_3
  · simp [XVec, XRow1]; exact XZ_scale_4
  · simp [XVec, XRow1]; exact XZ_scale_5
  · simp [XVec, XRow1]; exact XZ_scale_6
  · simp [XVec, XRow1]; exact XZ_scale_7
  · simp [XVec, XRow1]; exact XZ_scale_8
  · simp [XVec, XRow1]; exact XZ_scale_9
  · simp [XVec, XRow1]; exact XZ_scale_10
  · simp [XVec, XRow1]; exact XZ_scale_11
  · simp [XVec, XRow1]; exact XZ_scale_12
  · simp [XVec, XRow1]; exact XZ_scale_13
  · simp [XVec, XRow1]; exact XZ_scale_14
  · simp [XVec, XRow1]; exact XZ_scale_15
  · simp [XVec, XRow1]; exact XZ_scale_16
  · simp [XVec, XRow1]; exact XZ_scale_17
  · simp [XVec, XRow1]; exact XZ_scale_18
  · simp [XVec, XRow1]; exact XZ_scale_19

theorem AZ_scale_0 : toVec (AZ 0) = (scale : ℚ) • ACell0_8 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (4) scale (2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (4) scale (2) (11) (by decide) (by decide)

theorem AZ_scale_1 : toVec (AZ 1) = (scale : ℚ) • ACell1_8 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (4) scale (2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (4) scale (2) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)

theorem AZ_scale_2 : toVec (AZ 2) = (scale : ℚ) • ACell2_8 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (4) scale (2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (4) scale (2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem AZ_scale_3 : toVec (AZ 3) = (scale : ℚ) • ACell3_8 := by
  funext i
  fin_cases i
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (4) scale (2) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (4) scale (2) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (4) scale (2) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (4) scale (2) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (4) scale (2) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (4) scale (2) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (4) scale (2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (4 / 11 : ℚ)
    exact eq_smul_div (8) scale (4) (11) (by decide) (by decide)
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (4 / 11 : ℚ)
    exact eq_smul_div (8) scale (4) (11) (by decide) (by decide)

theorem AZ_scale_4 : toVec (AZ 4) = (scale : ℚ) • ACell4_8 := by
  funext i
  fin_cases i
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-4 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-4) (11) (by decide) (by decide)
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-4 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-4) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)

theorem AZ_scale_5 : toVec (AZ 5) = (scale : ℚ) • ACell5_8 := by
  funext i
  fin_cases i
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-2) scale (-1) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-2) scale (-1) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
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

theorem AZ_scale_6 : toVec (AZ 6) = (scale : ℚ) • ACell6_8 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-2) scale (-1) (11) (by decide) (by decide)
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-2) scale (-1) (11) (by decide) (by decide)
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 11 : ℚ)
    exact eq_smul_div (-6) scale (-3) (11) (by decide) (by decide)
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-2) scale (-1) (11) (by decide) (by decide)
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-2) scale (-1) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)

theorem AZ_scale_7 : toVec (AZ 7) = (scale : ℚ) • ACell7_8 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((2 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (2) scale (1) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (4) scale (2) (11) (by decide) (by decide)
  · change ((2 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (2) scale (1) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (4) scale (2) (11) (by decide) (by decide)
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-2) scale (-1) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (4) scale (2) (11) (by decide) (by decide)
  · change ((2 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (2) scale (1) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (4) scale (2) (11) (by decide) (by decide)
  · change ((2 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (2) scale (1) (11) (by decide) (by decide)

theorem AZ_scale_8 : toVec (AZ 8) = (scale : ℚ) • ACell8_8 := by
  funext i
  fin_cases i
  · change ((-24 : ℤ) : ℚ) = (scale : ℚ) * (-12 / 11 : ℚ)
    exact eq_smul_div (-24) scale (-12) (11) (by decide) (by decide)
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
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (4) scale (2) (11) (by decide) (by decide)

theorem AZ_scale_9 : toVec (AZ 9) = (scale : ℚ) • ACell9_8 := by
  funext i
  fin_cases i
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 11 : ℚ)
    exact eq_smul_div (-6) scale (-3) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-2) scale (-1) (11) (by decide) (by decide)
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-2) scale (-1) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-2) scale (-1) (11) (by decide) (by decide)
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-2) scale (-1) (11) (by decide) (by decide)

theorem AZ_scale_10 : toVec (AZ 10) = (scale : ℚ) • ACell10_8 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (4) scale (2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (4) scale (2) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem AZ_scale_11 : toVec (AZ 11) = (scale : ℚ) • ACell11_8 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-4 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-4) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-4 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-4) (11) (by decide) (by decide)

theorem AZ_scale_12 : toVec (AZ 12) = (scale : ℚ) • ACell12_8 := by
  funext i
  fin_cases i
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (4) scale (2) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (4) scale (2) (11) (by decide) (by decide)
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (4 / 11 : ℚ)
    exact eq_smul_div (8) scale (4) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (4) scale (2) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (4) scale (2) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (4) scale (2) (11) (by decide) (by decide)
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (4 / 11 : ℚ)
    exact eq_smul_div (8) scale (4) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (4) scale (2) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (4) scale (2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem AZ_scale_13 : toVec (AZ 13) = (scale : ℚ) • ACell13_8 := by
  funext i
  fin_cases i
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (4) scale (2) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (4) scale (2) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (4) scale (2) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (4) scale (2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (4) scale (2) (11) (by decide) (by decide)
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (4 / 11 : ℚ)
    exact eq_smul_div (8) scale (4) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (4) scale (2) (11) (by decide) (by decide)
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (4 / 11 : ℚ)
    exact eq_smul_div (8) scale (4) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (4) scale (2) (11) (by decide) (by decide)

theorem AZ_scale_14 : toVec (AZ 14) = (scale : ℚ) • ACell14_8 := by
  funext i
  fin_cases i
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-4 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-4) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-4 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-4) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)

theorem AZ_scale_15 : toVec (AZ 15) = (scale : ℚ) • ACell15_8 := by
  funext i
  fin_cases i
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-2) scale (-1) (11) (by decide) (by decide)
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-2) scale (-1) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
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

theorem AZ_scale_16 : toVec (AZ 16) = (scale : ℚ) • ACell16_8 := by
  funext i
  fin_cases i
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-2) scale (-1) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-2) scale (-1) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-2) scale (-1) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-2) scale (-1) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 11 : ℚ)
    exact eq_smul_div (-6) scale (-3) (11) (by decide) (by decide)

theorem AZ_scale_17 : toVec (AZ 17) = (scale : ℚ) • ACell17_8 := by
  funext i
  fin_cases i
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 11 : ℚ)
    exact eq_smul_div (-6) scale (-3) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-2) scale (-1) (11) (by decide) (by decide)
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-2) scale (-1) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-2) scale (-1) (11) (by decide) (by decide)
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-2) scale (-1) (11) (by decide) (by decide)

theorem AZ_scale_18 : toVec (AZ 18) = (scale : ℚ) • ACell18_8 := by
  funext i
  fin_cases i
  · change ((26 : ℤ) : ℚ) = (scale : ℚ) * (13 / 11 : ℚ)
    exact eq_smul_div (26) scale (13) (11) (by decide) (by decide)
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
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-2) scale (-1) (11) (by decide) (by decide)
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-2) scale (-1) (11) (by decide) (by decide)
  · change ((2 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (2) scale (1) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem AZ_scale_19 : toVec (AZ 19) = (scale : ℚ) • ACell19_8 := by
  funext i
  fin_cases i
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-2) scale (-1) (11) (by decide) (by decide)
  · change ((2 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (2) scale (1) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((2 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (2) scale (1) (11) (by decide) (by decide)
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-2) scale (-1) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((2 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (2) scale (1) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((2 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (2) scale (1) (11) (by decide) (by decide)

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

theorem entry_eq :
    (matrixMul XVec AVec) (1 : Fin 10) (8 : Fin 10) =
      ![0, 0, 0, 0, 0, 0, 0, 0, 0, 0] := by
  unfold matrixMul
  refine sum_mul_eq_of_scaled scale scale_ne_zero
    (fun k => XVec (1 : Fin 10) k)
    (fun k => AVec k (8 : Fin 10))
    XZ AZ XZ_scale AZ_scale entryZ rfl _ ?_
  rw [entryZ_eq, toVec_zeroZ_smul, vec_zero_eq]

theorem entry_eq_matrixOne :
    (matrixMul XVec AVec) (1 : Fin 10) (8 : Fin 10) =
      matrixOne (Fin 10) (1 : Fin 10) (8 : Fin 10) := by
  rw [entry_eq]
  have hne : (1 : Fin 10) ≠ (8 : Fin 10) := by decide
  funext n
  fin_cases n <;> simp [matrixOne, constVec, basis, *]

end V14Formalization.D12PiecePASplitEntry1_8


namespace V14Formalization.D12PiecePASplitEntry1_9
open D12CyclotomicVec D12CyclotomicVecZ D12PiecePAData
def payloadSha256 : String := "76c6196f29afe1a8398af99502447f48ebeed4bcb3805fc5dbec693940bc04b0"

def scale : ℤ := 22

def XZ (k : Fin 20) : VecZ :=
  match k.val with
  | 0 => #v[-3, -6, -5, -5, -5, -3, -4, -3, -3, -7]
  | 1 => #v[-6, 2, -2, 1, 0, -3, 0, -4, 0, 1]
  | 2 => #v[2, -1, -2, 0, 0, 0, -4, -1, -4, -1]
  | 3 => #v[0, -1, 1, 1, 2, -1, 0, 0, 0, -2]
  | 4 => #v[3, 0, 3, 3, 3, -3, 0, 3, 2, -3]
  | 5 => #v[-2, 0, 0, 0, 0, -4, 2, 2, 2, 0]
  | 6 => #v[-2, -8, -4, -4, -4, -4, -8, 0, -4, -6]
  | 7 => #v[-4, 0, 0, -6, -4, 0, -2, -6, 0, 0]
  | 8 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  | 9 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  | 10 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  | 11 => #v[11, 0, 0, 0, 0, 0, 0, 0, 0, 0]
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
  | 0 => #v[0, 0, 4, 0, -4, 0, -4, 0, 4, 0]
  | 1 => #v[0, -4, 0, 0, 0, -4, 0, 0, 4, 4]
  | 2 => #v[4, 4, 4, 4, 0, 8, 4, 4, 4, 8]
  | 3 => #v[4, 4, 0, 4, 4, 8, 4, 8, 4, 4]
  | 4 => #v[0, 0, 0, 0, 4, -4, -4, 4, 0, 0]
  | 5 => #v[6, 4, 6, 4, 2, 2, 4, 6, 4, 6]
  | 6 => #v[4, 2, 0, 2, 2, 0, 2, 4, 0, 6]
  | 7 => #v[0, 4, 2, 2, 4, 0, 0, 2, 6, 2]
  | 8 => #v[-4, -6, -4, 0, -2, -2, 0, 0, -2, -2]
  | 9 => #v[-22, 4, 2, 2, 6, 2, 2, 4, 0, 0]
  | 10 => #v[4, 4, 8, 8, 4, 4, 0, 4, 4, 4]
  | 11 => #v[4, 4, 8, 4, 8, 4, 4, 0, 4, 4]
  | 12 => #v[0, 0, 0, 0, 0, 0, 4, -4, -4, 4]
  | 13 => #v[0, 0, -4, 4, 0, 0, 0, 4, -4, 0]
  | 14 => #v[-4, 0, -4, 0, 4, 0, 0, 0, 0, 4]
  | 15 => #v[-2, -2, 0, -4, -6, -4, 0, -2, -2, 0]
  | 16 => #v[4, 2, 2, 4, 0, 0, 2, 6, 2, 0]
  | 17 => #v[-4, -4, -2, -6, -6, -6, -6, -2, -4, -4]
  | 18 => #v[-4, -2, 0, -2, -2, 0, -2, -4, 0, -6]
  | 19 => #v[28, 0, 2, 0, 2, 4, 4, 2, 0, 2]
  | _ => zeroZ

def entryZ : VecZ := sumFin (fun k => mulZ (XZ k) (AZ k))

theorem entryZ_eq : entryZ = zeroZ := by
  decide +kernel

theorem scale_ne_zero : scale ≠ 0 := by
  decide

theorem XZ_scale_0 : toVec (XZ 0) = (scale : ℚ) • XCell1_0 := by
  funext i
  fin_cases i
  · change ((-3 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-3) scale (-3) (22) (by decide) (by decide)
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 11 : ℚ)
    exact eq_smul_div (-6) scale (-3) (11) (by decide) (by decide)
  · change ((-5 : ℤ) : ℚ) = (scale : ℚ) * (-5 / 22 : ℚ)
    exact eq_smul_div (-5) scale (-5) (22) (by decide) (by decide)
  · change ((-5 : ℤ) : ℚ) = (scale : ℚ) * (-5 / 22 : ℚ)
    exact eq_smul_div (-5) scale (-5) (22) (by decide) (by decide)
  · change ((-5 : ℤ) : ℚ) = (scale : ℚ) * (-5 / 22 : ℚ)
    exact eq_smul_div (-5) scale (-5) (22) (by decide) (by decide)
  · change ((-3 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-3) scale (-3) (22) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((-3 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-3) scale (-3) (22) (by decide) (by decide)
  · change ((-3 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-3) scale (-3) (22) (by decide) (by decide)
  · change ((-7 : ℤ) : ℚ) = (scale : ℚ) * (-7 / 22 : ℚ)
    exact eq_smul_div (-7) scale (-7) (22) (by decide) (by decide)

theorem XZ_scale_1 : toVec (XZ 1) = (scale : ℚ) • XCell1_1 := by
  funext i
  fin_cases i
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 11 : ℚ)
    exact eq_smul_div (-6) scale (-3) (11) (by decide) (by decide)
  · change ((2 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (2) scale (1) (11) (by decide) (by decide)
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-2) scale (-1) (11) (by decide) (by decide)
  · change ((1 : ℤ) : ℚ) = (scale : ℚ) * (1 / 22 : ℚ)
    exact eq_smul_div (1) scale (1) (22) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-3 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-3) scale (-3) (22) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((1 : ℤ) : ℚ) = (scale : ℚ) * (1 / 22 : ℚ)
    exact eq_smul_div (1) scale (1) (22) (by decide) (by decide)

theorem XZ_scale_2 : toVec (XZ 2) = (scale : ℚ) • XCell1_2 := by
  funext i
  fin_cases i
  · change ((2 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (2) scale (1) (11) (by decide) (by decide)
  · change ((-1 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 22 : ℚ)
    exact eq_smul_div (-1) scale (-1) (22) (by decide) (by decide)
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-2) scale (-1) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((-1 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 22 : ℚ)
    exact eq_smul_div (-1) scale (-1) (22) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((-1 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 22 : ℚ)
    exact eq_smul_div (-1) scale (-1) (22) (by decide) (by decide)

theorem XZ_scale_3 : toVec (XZ 3) = (scale : ℚ) • XCell1_3 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-1 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 22 : ℚ)
    exact eq_smul_div (-1) scale (-1) (22) (by decide) (by decide)
  · change ((1 : ℤ) : ℚ) = (scale : ℚ) * (1 / 22 : ℚ)
    exact eq_smul_div (1) scale (1) (22) (by decide) (by decide)
  · change ((1 : ℤ) : ℚ) = (scale : ℚ) * (1 / 22 : ℚ)
    exact eq_smul_div (1) scale (1) (22) (by decide) (by decide)
  · change ((2 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (2) scale (1) (11) (by decide) (by decide)
  · change ((-1 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 22 : ℚ)
    exact eq_smul_div (-1) scale (-1) (22) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-2) scale (-1) (11) (by decide) (by decide)

theorem XZ_scale_4 : toVec (XZ 4) = (scale : ℚ) • XCell1_4 := by
  funext i
  fin_cases i
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
  · change ((-3 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-3) scale (-3) (22) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((3 : ℤ) : ℚ) = (scale : ℚ) * (3 / 22 : ℚ)
    exact eq_smul_div (3) scale (3) (22) (by decide) (by decide)
  · change ((2 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (2) scale (1) (11) (by decide) (by decide)
  · change ((-3 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 22 : ℚ)
    exact eq_smul_div (-3) scale (-3) (22) (by decide) (by decide)

theorem XZ_scale_5 : toVec (XZ 5) = (scale : ℚ) • XCell1_5 := by
  funext i
  fin_cases i
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-2) scale (-1) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((2 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (2) scale (1) (11) (by decide) (by decide)
  · change ((2 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (2) scale (1) (11) (by decide) (by decide)
  · change ((2 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (2) scale (1) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem XZ_scale_6 : toVec (XZ 6) = (scale : ℚ) • XCell1_6 := by
  funext i
  fin_cases i
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-2) scale (-1) (11) (by decide) (by decide)
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-4 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-4) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((-8 : ℤ) : ℚ) = (scale : ℚ) * (-4 / 11 : ℚ)
    exact eq_smul_div (-8) scale (-4) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 11 : ℚ)
    exact eq_smul_div (-6) scale (-3) (11) (by decide) (by decide)

theorem XZ_scale_7 : toVec (XZ 7) = (scale : ℚ) • XCell1_7 := by
  funext i
  fin_cases i
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 11 : ℚ)
    exact eq_smul_div (-6) scale (-3) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-2) scale (-1) (11) (by decide) (by decide)
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 11 : ℚ)
    exact eq_smul_div (-6) scale (-3) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem XZ_scale_8 : toVec (XZ 8) = (scale : ℚ) • XCell1_8 := by
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

theorem XZ_scale_9 : toVec (XZ 9) = (scale : ℚ) • XCell1_9 := by
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

theorem XZ_scale_10 : toVec (XZ 10) = (scale : ℚ) • XCell1_10 := by
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

theorem XZ_scale_11 : toVec (XZ 11) = (scale : ℚ) • XCell1_11 := by
  funext i
  fin_cases i
  · change ((11 : ℤ) : ℚ) = (scale : ℚ) * (1 / 2 : ℚ)
    exact eq_smul_div (11) scale (1) (2) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem XZ_scale_12 : toVec (XZ 12) = (scale : ℚ) • XCell1_12 := by
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

theorem XZ_scale_13 : toVec (XZ 13) = (scale : ℚ) • XCell1_13 := by
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

theorem XZ_scale_14 : toVec (XZ 14) = (scale : ℚ) • XCell1_14 := by
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

theorem XZ_scale_15 : toVec (XZ 15) = (scale : ℚ) • XCell1_15 := by
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

theorem XZ_scale_16 : toVec (XZ 16) = (scale : ℚ) • XCell1_16 := by
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

theorem XZ_scale_17 : toVec (XZ 17) = (scale : ℚ) • XCell1_17 := by
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

theorem XZ_scale_18 : toVec (XZ 18) = (scale : ℚ) • XCell1_18 := by
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

theorem XZ_scale_19 : toVec (XZ 19) = (scale : ℚ) • XCell1_19 := by
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
    toVec (XZ k) = (scale : ℚ) • XVec (1 : Fin 10) k := by
  fin_cases k
  · simp [XVec, XRow1]; exact XZ_scale_0
  · simp [XVec, XRow1]; exact XZ_scale_1
  · simp [XVec, XRow1]; exact XZ_scale_2
  · simp [XVec, XRow1]; exact XZ_scale_3
  · simp [XVec, XRow1]; exact XZ_scale_4
  · simp [XVec, XRow1]; exact XZ_scale_5
  · simp [XVec, XRow1]; exact XZ_scale_6
  · simp [XVec, XRow1]; exact XZ_scale_7
  · simp [XVec, XRow1]; exact XZ_scale_8
  · simp [XVec, XRow1]; exact XZ_scale_9
  · simp [XVec, XRow1]; exact XZ_scale_10
  · simp [XVec, XRow1]; exact XZ_scale_11
  · simp [XVec, XRow1]; exact XZ_scale_12
  · simp [XVec, XRow1]; exact XZ_scale_13
  · simp [XVec, XRow1]; exact XZ_scale_14
  · simp [XVec, XRow1]; exact XZ_scale_15
  · simp [XVec, XRow1]; exact XZ_scale_16
  · simp [XVec, XRow1]; exact XZ_scale_17
  · simp [XVec, XRow1]; exact XZ_scale_18
  · simp [XVec, XRow1]; exact XZ_scale_19

theorem AZ_scale_0 : toVec (AZ 0) = (scale : ℚ) • ACell0_9 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (4) scale (2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (4) scale (2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem AZ_scale_1 : toVec (AZ 1) = (scale : ℚ) • ACell1_9 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (4) scale (2) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (4) scale (2) (11) (by decide) (by decide)

theorem AZ_scale_2 : toVec (AZ 2) = (scale : ℚ) • ACell2_9 := by
  funext i
  fin_cases i
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (4) scale (2) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (4) scale (2) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (4) scale (2) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (4) scale (2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (4 / 11 : ℚ)
    exact eq_smul_div (8) scale (4) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (4) scale (2) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (4) scale (2) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (4) scale (2) (11) (by decide) (by decide)
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (4 / 11 : ℚ)
    exact eq_smul_div (8) scale (4) (11) (by decide) (by decide)

theorem AZ_scale_3 : toVec (AZ 3) = (scale : ℚ) • ACell3_9 := by
  funext i
  fin_cases i
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (4) scale (2) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (4) scale (2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (4) scale (2) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (4) scale (2) (11) (by decide) (by decide)
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (4 / 11 : ℚ)
    exact eq_smul_div (8) scale (4) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (4) scale (2) (11) (by decide) (by decide)
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (4 / 11 : ℚ)
    exact eq_smul_div (8) scale (4) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (4) scale (2) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (4) scale (2) (11) (by decide) (by decide)

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
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (4) scale (2) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (4) scale (2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem AZ_scale_5 : toVec (AZ 5) = (scale : ℚ) • ACell5_9 := by
  funext i
  fin_cases i
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (3 / 11 : ℚ)
    exact eq_smul_div (6) scale (3) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (4) scale (2) (11) (by decide) (by decide)
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (3 / 11 : ℚ)
    exact eq_smul_div (6) scale (3) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (4) scale (2) (11) (by decide) (by decide)
  · change ((2 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (2) scale (1) (11) (by decide) (by decide)
  · change ((2 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (2) scale (1) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (4) scale (2) (11) (by decide) (by decide)
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (3 / 11 : ℚ)
    exact eq_smul_div (6) scale (3) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (4) scale (2) (11) (by decide) (by decide)
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (3 / 11 : ℚ)
    exact eq_smul_div (6) scale (3) (11) (by decide) (by decide)

theorem AZ_scale_6 : toVec (AZ 6) = (scale : ℚ) • ACell6_9 := by
  funext i
  fin_cases i
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
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((2 : ℤ) : ℚ) = (scale : ℚ) * (1 / 11 : ℚ)
    exact eq_smul_div (2) scale (1) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (4) scale (2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((6 : ℤ) : ℚ) = (scale : ℚ) * (3 / 11 : ℚ)
    exact eq_smul_div (6) scale (3) (11) (by decide) (by decide)

theorem AZ_scale_7 : toVec (AZ 7) = (scale : ℚ) • ACell7_9 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
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

theorem AZ_scale_8 : toVec (AZ 8) = (scale : ℚ) • ACell8_9 := by
  funext i
  fin_cases i
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 11 : ℚ)
    exact eq_smul_div (-6) scale (-3) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-2) scale (-1) (11) (by decide) (by decide)
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-2) scale (-1) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-2) scale (-1) (11) (by decide) (by decide)
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-2) scale (-1) (11) (by decide) (by decide)

theorem AZ_scale_9 : toVec (AZ 9) = (scale : ℚ) • ACell9_9 := by
  funext i
  fin_cases i
  · change ((-22 : ℤ) : ℚ) = (scale : ℚ) * (-1 : ℚ)
    exact eq_smul_int (-22) scale (-1) (by decide)
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

theorem AZ_scale_10 : toVec (AZ 10) = (scale : ℚ) • ACell10_9 := by
  funext i
  fin_cases i
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (4) scale (2) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (4) scale (2) (11) (by decide) (by decide)
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (4 / 11 : ℚ)
    exact eq_smul_div (8) scale (4) (11) (by decide) (by decide)
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (4 / 11 : ℚ)
    exact eq_smul_div (8) scale (4) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (4) scale (2) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (4) scale (2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (4) scale (2) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (4) scale (2) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (4) scale (2) (11) (by decide) (by decide)

theorem AZ_scale_11 : toVec (AZ 11) = (scale : ℚ) • ACell11_9 := by
  funext i
  fin_cases i
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (4) scale (2) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (4) scale (2) (11) (by decide) (by decide)
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (4 / 11 : ℚ)
    exact eq_smul_div (8) scale (4) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (4) scale (2) (11) (by decide) (by decide)
  · change ((8 : ℤ) : ℚ) = (scale : ℚ) * (4 / 11 : ℚ)
    exact eq_smul_div (8) scale (4) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (4) scale (2) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (4) scale (2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (4) scale (2) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (4) scale (2) (11) (by decide) (by decide)

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
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (4) scale (2) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (4) scale (2) (11) (by decide) (by decide)

theorem AZ_scale_13 : toVec (AZ 13) = (scale : ℚ) • ACell13_9 := by
  funext i
  fin_cases i
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (4) scale (2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (4) scale (2) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem AZ_scale_14 : toVec (AZ 14) = (scale : ℚ) • ACell14_9 := by
  funext i
  fin_cases i
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (4) scale (2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((4 : ℤ) : ℚ) = (scale : ℚ) * (2 / 11 : ℚ)
    exact eq_smul_div (4) scale (2) (11) (by decide) (by decide)

theorem AZ_scale_15 : toVec (AZ 15) = (scale : ℚ) • ACell15_9 := by
  funext i
  fin_cases i
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-2) scale (-1) (11) (by decide) (by decide)
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-2) scale (-1) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 11 : ℚ)
    exact eq_smul_div (-6) scale (-3) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-2) scale (-1) (11) (by decide) (by decide)
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-2) scale (-1) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale

theorem AZ_scale_16 : toVec (AZ 16) = (scale : ℚ) • ACell16_9 := by
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

theorem AZ_scale_17 : toVec (AZ 17) = (scale : ℚ) • ACell17_9 := by
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

theorem AZ_scale_18 : toVec (AZ 18) = (scale : ℚ) • ACell18_9 := by
  funext i
  fin_cases i
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-2) scale (-1) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-2) scale (-1) (11) (by decide) (by decide)
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-2) scale (-1) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-2 : ℤ) : ℚ) = (scale : ℚ) * (-1 / 11 : ℚ)
    exact eq_smul_div (-2) scale (-1) (11) (by decide) (by decide)
  · change ((-4 : ℤ) : ℚ) = (scale : ℚ) * (-2 / 11 : ℚ)
    exact eq_smul_div (-4) scale (-2) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
  · change ((-6 : ℤ) : ℚ) = (scale : ℚ) * (-3 / 11 : ℚ)
    exact eq_smul_div (-6) scale (-3) (11) (by decide) (by decide)

theorem AZ_scale_19 : toVec (AZ 19) = (scale : ℚ) • ACell19_9 := by
  funext i
  fin_cases i
  · change ((28 : ℤ) : ℚ) = (scale : ℚ) * (14 / 11 : ℚ)
    exact eq_smul_div (28) scale (14) (11) (by decide) (by decide)
  · change ((0 : ℤ) : ℚ) = (scale : ℚ) * (0 : ℚ)
    exact eq_smul_zero scale
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

theorem entry_eq :
    (matrixMul XVec AVec) (1 : Fin 10) (9 : Fin 10) =
      ![0, 0, 0, 0, 0, 0, 0, 0, 0, 0] := by
  unfold matrixMul
  refine sum_mul_eq_of_scaled scale scale_ne_zero
    (fun k => XVec (1 : Fin 10) k)
    (fun k => AVec k (9 : Fin 10))
    XZ AZ XZ_scale AZ_scale entryZ rfl _ ?_
  rw [entryZ_eq, toVec_zeroZ_smul, vec_zero_eq]

theorem entry_eq_matrixOne :
    (matrixMul XVec AVec) (1 : Fin 10) (9 : Fin 10) =
      matrixOne (Fin 10) (1 : Fin 10) (9 : Fin 10) := by
  rw [entry_eq]
  have hne : (1 : Fin 10) ≠ (9 : Fin 10) := by decide
  funext n
  fin_cases n <;> simp [matrixOne, constVec, basis, *]

end V14Formalization.D12PiecePASplitEntry1_9


namespace V14Formalization.D12PiecePASplitRow1
open D12CyclotomicVec D12PiecePAData

public theorem row_eq (j : Fin 10) :
    (matrixMul XVec AVec) (1 : Fin 10) j =
      matrixOne (Fin 10) (1 : Fin 10) j := by
  fin_cases j
  · exact D12PiecePASplitEntry1_0.entry_eq_matrixOne
  · exact D12PiecePASplitEntry1_1.entry_eq_matrixOne
  · exact D12PiecePASplitEntry1_2.entry_eq_matrixOne
  · exact D12PiecePASplitEntry1_3.entry_eq_matrixOne
  · exact D12PiecePASplitEntry1_4.entry_eq_matrixOne
  · exact D12PiecePASplitEntry1_5.entry_eq_matrixOne
  · exact D12PiecePASplitEntry1_6.entry_eq_matrixOne
  · exact D12PiecePASplitEntry1_7.entry_eq_matrixOne
  · exact D12PiecePASplitEntry1_8.entry_eq_matrixOne
  · exact D12PiecePASplitEntry1_9.entry_eq_matrixOne

end V14Formalization.D12PiecePASplitRow1
