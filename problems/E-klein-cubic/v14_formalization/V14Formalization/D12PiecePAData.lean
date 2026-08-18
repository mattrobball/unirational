/- PA vector data. Auto-generated; arithmetic lives in entry shards. -/
module

public import V14Formalization.D12PieceVecBase
public import V14Formalization.D12VecScaleIntro

noncomputable section
open Matrix
namespace V14Formalization.D12PiecePAData
open D12CyclotomicVec D12CyclotomicVecZ D12PieceVecBase
def payloadSha256 : String := "76c6196f29afe1a8398af99502447f48ebeed4bcb3805fc5dbec693940bc04b0"

public def XCell0_0 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (-1 / 11 : ℚ)
  | 1 => (3 / 22 : ℚ)
  | 2 => 0
  | 3 => (4 / 11 : ℚ)
  | 4 => (-1 / 22 : ℚ)
  | 5 => (-1 / 11 : ℚ)
  | 6 => (4 / 11 : ℚ)
  | 7 => (-1 / 11 : ℚ)
  | 8 => (5 / 22 : ℚ)
  | 9 => (5 / 22 : ℚ)
  | _ => 0

public theorem XCell0_0_def : XCell0_0 = ![(-1 / 11 : ℚ), (3 / 22 : ℚ), 0, (4 / 11 : ℚ), (-1 / 22 : ℚ), (-1 / 11 : ℚ), (4 / 11 : ℚ), (-1 / 11 : ℚ), (5 / 22 : ℚ), (5 / 22 : ℚ)] := by
  funext i
  fin_cases i <;> rfl

public theorem XCell0_0_scaled :
    toVec #v[-2, 3, 0, 8, -1, -2, 8, -2, 5, 5] = ((22 : ℤ) : ℚ) • XCell0_0 :=
  toVec_eq_smul10 #v[-2, 3, 0, 8, -1, -2, 8, -2, 5, 5] 22 XCell0_0
    (eq_smul_div (-2) 22 (-1) (11) (by decide) (by decide))
    (eq_smul_div (3) 22 (3) (22) (by decide) (by decide))
    (eq_smul_zero 22)
    (eq_smul_div (8) 22 (4) (11) (by decide) (by decide))
    (eq_smul_div (-1) 22 (-1) (22) (by decide) (by decide))
    (eq_smul_div (-2) 22 (-1) (11) (by decide) (by decide))
    (eq_smul_div (8) 22 (4) (11) (by decide) (by decide))
    (eq_smul_div (-2) 22 (-1) (11) (by decide) (by decide))
    (eq_smul_div (5) 22 (5) (22) (by decide) (by decide))
    (eq_smul_div (5) 22 (5) (22) (by decide) (by decide))

public def XCell0_1 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (-4 / 11 : ℚ)
  | 1 => (-3 / 22 : ℚ)
  | 2 => (-1 / 22 : ℚ)
  | 3 => (-4 / 11 : ℚ)
  | 4 => (-3 / 22 : ℚ)
  | 5 => (-1 / 22 : ℚ)
  | 6 => (-7 / 22 : ℚ)
  | 7 => (-1 / 11 : ℚ)
  | 8 => (-3 / 22 : ℚ)
  | 9 => (-4 / 11 : ℚ)
  | _ => 0

public theorem XCell0_1_def : XCell0_1 = ![(-4 / 11 : ℚ), (-3 / 22 : ℚ), (-1 / 22 : ℚ), (-4 / 11 : ℚ), (-3 / 22 : ℚ), (-1 / 22 : ℚ), (-7 / 22 : ℚ), (-1 / 11 : ℚ), (-3 / 22 : ℚ), (-4 / 11 : ℚ)] := by
  funext i
  fin_cases i <;> rfl

public theorem XCell0_1_scaled :
    toVec #v[-8, -3, -1, -8, -3, -1, -7, -2, -3, -8] = ((22 : ℤ) : ℚ) • XCell0_1 :=
  toVec_eq_smul10 #v[-8, -3, -1, -8, -3, -1, -7, -2, -3, -8] 22 XCell0_1
    (eq_smul_div (-8) 22 (-4) (11) (by decide) (by decide))
    (eq_smul_div (-3) 22 (-3) (22) (by decide) (by decide))
    (eq_smul_div (-1) 22 (-1) (22) (by decide) (by decide))
    (eq_smul_div (-8) 22 (-4) (11) (by decide) (by decide))
    (eq_smul_div (-3) 22 (-3) (22) (by decide) (by decide))
    (eq_smul_div (-1) 22 (-1) (22) (by decide) (by decide))
    (eq_smul_div (-7) 22 (-7) (22) (by decide) (by decide))
    (eq_smul_div (-2) 22 (-1) (11) (by decide) (by decide))
    (eq_smul_div (-3) 22 (-3) (22) (by decide) (by decide))
    (eq_smul_div (-8) 22 (-4) (11) (by decide) (by decide))

public def XCell0_2 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (3 / 22 : ℚ)
  | 1 => (1 / 11 : ℚ)
  | 2 => (2 / 11 : ℚ)
  | 3 => (5 / 22 : ℚ)
  | 4 => 0
  | 5 => 0
  | 6 => (5 / 22 : ℚ)
  | 7 => (3 / 22 : ℚ)
  | 8 => (-1 / 22 : ℚ)
  | 9 => (1 / 22 : ℚ)
  | _ => 0

public theorem XCell0_2_def : XCell0_2 = ![(3 / 22 : ℚ), (1 / 11 : ℚ), (2 / 11 : ℚ), (5 / 22 : ℚ), 0, 0, (5 / 22 : ℚ), (3 / 22 : ℚ), (-1 / 22 : ℚ), (1 / 22 : ℚ)] := by
  funext i
  fin_cases i <;> rfl

public theorem XCell0_2_scaled :
    toVec #v[3, 2, 4, 5, 0, 0, 5, 3, -1, 1] = ((22 : ℤ) : ℚ) • XCell0_2 :=
  toVec_eq_smul10 #v[3, 2, 4, 5, 0, 0, 5, 3, -1, 1] 22 XCell0_2
    (eq_smul_div (3) 22 (3) (22) (by decide) (by decide))
    (eq_smul_div (2) 22 (1) (11) (by decide) (by decide))
    (eq_smul_div (4) 22 (2) (11) (by decide) (by decide))
    (eq_smul_div (5) 22 (5) (22) (by decide) (by decide))
    (eq_smul_zero 22)
    (eq_smul_zero 22)
    (eq_smul_div (5) 22 (5) (22) (by decide) (by decide))
    (eq_smul_div (3) 22 (3) (22) (by decide) (by decide))
    (eq_smul_div (-1) 22 (-1) (22) (by decide) (by decide))
    (eq_smul_div (1) 22 (1) (22) (by decide) (by decide))

public def XCell0_3 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (2 / 11 : ℚ)
  | 1 => (3 / 22 : ℚ)
  | 2 => (-1 / 22 : ℚ)
  | 3 => (7 / 22 : ℚ)
  | 4 => (1 / 11 : ℚ)
  | 5 => (1 / 22 : ℚ)
  | 6 => (3 / 11 : ℚ)
  | 7 => (-2 / 11 : ℚ)
  | 8 => (1 / 11 : ℚ)
  | 9 => (1 / 11 : ℚ)
  | _ => 0

public theorem XCell0_3_def : XCell0_3 = ![(2 / 11 : ℚ), (3 / 22 : ℚ), (-1 / 22 : ℚ), (7 / 22 : ℚ), (1 / 11 : ℚ), (1 / 22 : ℚ), (3 / 11 : ℚ), (-2 / 11 : ℚ), (1 / 11 : ℚ), (1 / 11 : ℚ)] := by
  funext i
  fin_cases i <;> rfl

public theorem XCell0_3_scaled :
    toVec #v[4, 3, -1, 7, 2, 1, 6, -4, 2, 2] = ((22 : ℤ) : ℚ) • XCell0_3 :=
  toVec_eq_smul10 #v[4, 3, -1, 7, 2, 1, 6, -4, 2, 2] 22 XCell0_3
    (eq_smul_div (4) 22 (2) (11) (by decide) (by decide))
    (eq_smul_div (3) 22 (3) (22) (by decide) (by decide))
    (eq_smul_div (-1) 22 (-1) (22) (by decide) (by decide))
    (eq_smul_div (7) 22 (7) (22) (by decide) (by decide))
    (eq_smul_div (2) 22 (1) (11) (by decide) (by decide))
    (eq_smul_div (1) 22 (1) (22) (by decide) (by decide))
    (eq_smul_div (6) 22 (3) (11) (by decide) (by decide))
    (eq_smul_div (-4) 22 (-2) (11) (by decide) (by decide))
    (eq_smul_div (2) 22 (1) (11) (by decide) (by decide))
    (eq_smul_div (2) 22 (1) (11) (by decide) (by decide))

public def XCell0_4 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (-1 / 11 : ℚ)
  | 1 => (-3 / 11 : ℚ)
  | 2 => (-1 / 11 : ℚ)
  | 3 => (1 / 22 : ℚ)
  | 4 => (-1 / 22 : ℚ)
  | 5 => (-3 / 22 : ℚ)
  | 6 => 0
  | 7 => (-1 / 11 : ℚ)
  | 8 => (-2 / 11 : ℚ)
  | 9 => (-3 / 22 : ℚ)
  | _ => 0

public theorem XCell0_4_def : XCell0_4 = ![(-1 / 11 : ℚ), (-3 / 11 : ℚ), (-1 / 11 : ℚ), (1 / 22 : ℚ), (-1 / 22 : ℚ), (-3 / 22 : ℚ), 0, (-1 / 11 : ℚ), (-2 / 11 : ℚ), (-3 / 22 : ℚ)] := by
  funext i
  fin_cases i <;> rfl

public theorem XCell0_4_scaled :
    toVec #v[-2, -6, -2, 1, -1, -3, 0, -2, -4, -3] = ((22 : ℤ) : ℚ) • XCell0_4 :=
  toVec_eq_smul10 #v[-2, -6, -2, 1, -1, -3, 0, -2, -4, -3] 22 XCell0_4
    (eq_smul_div (-2) 22 (-1) (11) (by decide) (by decide))
    (eq_smul_div (-6) 22 (-3) (11) (by decide) (by decide))
    (eq_smul_div (-2) 22 (-1) (11) (by decide) (by decide))
    (eq_smul_div (1) 22 (1) (22) (by decide) (by decide))
    (eq_smul_div (-1) 22 (-1) (22) (by decide) (by decide))
    (eq_smul_div (-3) 22 (-3) (22) (by decide) (by decide))
    (eq_smul_zero 22)
    (eq_smul_div (-2) 22 (-1) (11) (by decide) (by decide))
    (eq_smul_div (-4) 22 (-2) (11) (by decide) (by decide))
    (eq_smul_div (-3) 22 (-3) (22) (by decide) (by decide))

public def XCell0_5 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (-5 / 11 : ℚ)
  | 1 => (-4 / 11 : ℚ)
  | 2 => (-4 / 11 : ℚ)
  | 3 => (-6 / 11 : ℚ)
  | 4 => (-3 / 11 : ℚ)
  | 5 => (-4 / 11 : ℚ)
  | 6 => (-5 / 11 : ℚ)
  | 7 => (-4 / 11 : ℚ)
  | 8 => (-3 / 11 : ℚ)
  | 9 => (-6 / 11 : ℚ)
  | _ => 0

public theorem XCell0_5_def : XCell0_5 = ![(-5 / 11 : ℚ), (-4 / 11 : ℚ), (-4 / 11 : ℚ), (-6 / 11 : ℚ), (-3 / 11 : ℚ), (-4 / 11 : ℚ), (-5 / 11 : ℚ), (-4 / 11 : ℚ), (-3 / 11 : ℚ), (-6 / 11 : ℚ)] := by
  funext i
  fin_cases i <;> rfl

public theorem XCell0_5_scaled :
    toVec #v[-5, -4, -4, -6, -3, -4, -5, -4, -3, -6] = ((11 : ℤ) : ℚ) • XCell0_5 :=
  toVec_eq_smul10 #v[-5, -4, -4, -6, -3, -4, -5, -4, -3, -6] 11 XCell0_5
    (eq_smul_div (-5) 11 (-5) (11) (by decide) (by decide))
    (eq_smul_div (-4) 11 (-4) (11) (by decide) (by decide))
    (eq_smul_div (-4) 11 (-4) (11) (by decide) (by decide))
    (eq_smul_div (-6) 11 (-6) (11) (by decide) (by decide))
    (eq_smul_div (-3) 11 (-3) (11) (by decide) (by decide))
    (eq_smul_div (-4) 11 (-4) (11) (by decide) (by decide))
    (eq_smul_div (-5) 11 (-5) (11) (by decide) (by decide))
    (eq_smul_div (-4) 11 (-4) (11) (by decide) (by decide))
    (eq_smul_div (-3) 11 (-3) (11) (by decide) (by decide))
    (eq_smul_div (-6) 11 (-6) (11) (by decide) (by decide))

public def XCell0_6 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (4 / 11 : ℚ)
  | 1 => (1 / 11 : ℚ)
  | 2 => 0
  | 3 => (5 / 11 : ℚ)
  | 4 => (-1 / 11 : ℚ)
  | 5 => 0
  | 6 => (5 / 11 : ℚ)
  | 7 => (1 / 11 : ℚ)
  | 8 => (2 / 11 : ℚ)
  | 9 => (5 / 11 : ℚ)
  | _ => 0

public theorem XCell0_6_def : XCell0_6 = ![(4 / 11 : ℚ), (1 / 11 : ℚ), 0, (5 / 11 : ℚ), (-1 / 11 : ℚ), 0, (5 / 11 : ℚ), (1 / 11 : ℚ), (2 / 11 : ℚ), (5 / 11 : ℚ)] := by
  funext i
  fin_cases i <;> rfl

public theorem XCell0_6_scaled :
    toVec #v[4, 1, 0, 5, -1, 0, 5, 1, 2, 5] = ((11 : ℤ) : ℚ) • XCell0_6 :=
  toVec_eq_smul10 #v[4, 1, 0, 5, -1, 0, 5, 1, 2, 5] 11 XCell0_6
    (eq_smul_div (4) 11 (4) (11) (by decide) (by decide))
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_div (5) 11 (5) (11) (by decide) (by decide))
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_div (5) 11 (5) (11) (by decide) (by decide))
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_div (5) 11 (5) (11) (by decide) (by decide))

public def XCell0_7 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (3 / 11 : ℚ)
  | 1 => (5 / 11 : ℚ)
  | 2 => (1 / 11 : ℚ)
  | 3 => (3 / 11 : ℚ)
  | 4 => (4 / 11 : ℚ)
  | 5 => (3 / 11 : ℚ)
  | 6 => (4 / 11 : ℚ)
  | 7 => (1 / 11 : ℚ)
  | 8 => (5 / 11 : ℚ)
  | 9 => (4 / 11 : ℚ)
  | _ => 0

public theorem XCell0_7_def : XCell0_7 = ![(3 / 11 : ℚ), (5 / 11 : ℚ), (1 / 11 : ℚ), (3 / 11 : ℚ), (4 / 11 : ℚ), (3 / 11 : ℚ), (4 / 11 : ℚ), (1 / 11 : ℚ), (5 / 11 : ℚ), (4 / 11 : ℚ)] := by
  funext i
  fin_cases i <;> rfl

public theorem XCell0_7_scaled :
    toVec #v[3, 5, 1, 3, 4, 3, 4, 1, 5, 4] = ((11 : ℤ) : ℚ) • XCell0_7 :=
  toVec_eq_smul10 #v[3, 5, 1, 3, 4, 3, 4, 1, 5, 4] 11 XCell0_7
    (eq_smul_div (3) 11 (3) (11) (by decide) (by decide))
    (eq_smul_div (5) 11 (5) (11) (by decide) (by decide))
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))
    (eq_smul_div (3) 11 (3) (11) (by decide) (by decide))
    (eq_smul_div (4) 11 (4) (11) (by decide) (by decide))
    (eq_smul_div (3) 11 (3) (11) (by decide) (by decide))
    (eq_smul_div (4) 11 (4) (11) (by decide) (by decide))
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))
    (eq_smul_div (5) 11 (5) (11) (by decide) (by decide))
    (eq_smul_div (4) 11 (4) (11) (by decide) (by decide))

public def XCell0_8 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => 0
  | 1 => 0
  | 2 => 0
  | 3 => 0
  | 4 => 0
  | 5 => 0
  | 6 => 0
  | 7 => 0
  | 8 => 0
  | 9 => 0
  | _ => 0

public theorem XCell0_8_def : XCell0_8 = ![0, 0, 0, 0, 0, 0, 0, 0, 0, 0] := by
  funext i
  fin_cases i <;> rfl

public theorem XCell0_8_scaled :
    toVec #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0] = ((1 : ℤ) : ℚ) • XCell0_8 :=
  toVec_eq_smul10 #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0] 1 XCell0_8
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)

public def XCell0_9 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => 0
  | 1 => 0
  | 2 => 0
  | 3 => 0
  | 4 => 0
  | 5 => 0
  | 6 => 0
  | 7 => 0
  | 8 => 0
  | 9 => 0
  | _ => 0

public theorem XCell0_9_def : XCell0_9 = ![0, 0, 0, 0, 0, 0, 0, 0, 0, 0] := by
  funext i
  fin_cases i <;> rfl

public theorem XCell0_9_scaled :
    toVec #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0] = ((1 : ℤ) : ℚ) • XCell0_9 :=
  toVec_eq_smul10 #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0] 1 XCell0_9
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)

public def XCell0_10 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (1 / 2 : ℚ)
  | 1 => 0
  | 2 => 0
  | 3 => 0
  | 4 => 0
  | 5 => 0
  | 6 => 0
  | 7 => 0
  | 8 => 0
  | 9 => 0
  | _ => 0

public theorem XCell0_10_def : XCell0_10 = ![(1 / 2 : ℚ), 0, 0, 0, 0, 0, 0, 0, 0, 0] := by
  funext i
  fin_cases i <;> rfl

public theorem XCell0_10_scaled :
    toVec #v[1, 0, 0, 0, 0, 0, 0, 0, 0, 0] = ((2 : ℤ) : ℚ) • XCell0_10 :=
  toVec_eq_smul10 #v[1, 0, 0, 0, 0, 0, 0, 0, 0, 0] 2 XCell0_10
    (eq_smul_div (1) 2 (1) (2) (by decide) (by decide))
    (eq_smul_zero 2)
    (eq_smul_zero 2)
    (eq_smul_zero 2)
    (eq_smul_zero 2)
    (eq_smul_zero 2)
    (eq_smul_zero 2)
    (eq_smul_zero 2)
    (eq_smul_zero 2)
    (eq_smul_zero 2)

public def XCell0_11 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => 0
  | 1 => 0
  | 2 => 0
  | 3 => 0
  | 4 => 0
  | 5 => 0
  | 6 => 0
  | 7 => 0
  | 8 => 0
  | 9 => 0
  | _ => 0

public theorem XCell0_11_def : XCell0_11 = ![0, 0, 0, 0, 0, 0, 0, 0, 0, 0] := by
  funext i
  fin_cases i <;> rfl

public theorem XCell0_11_scaled :
    toVec #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0] = ((1 : ℤ) : ℚ) • XCell0_11 :=
  toVec_eq_smul10 #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0] 1 XCell0_11
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)

public def XCell0_12 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => 0
  | 1 => 0
  | 2 => 0
  | 3 => 0
  | 4 => 0
  | 5 => 0
  | 6 => 0
  | 7 => 0
  | 8 => 0
  | 9 => 0
  | _ => 0

public theorem XCell0_12_def : XCell0_12 = ![0, 0, 0, 0, 0, 0, 0, 0, 0, 0] := by
  funext i
  fin_cases i <;> rfl

public theorem XCell0_12_scaled :
    toVec #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0] = ((1 : ℤ) : ℚ) • XCell0_12 :=
  toVec_eq_smul10 #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0] 1 XCell0_12
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)

public def XCell0_13 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => 0
  | 1 => 0
  | 2 => 0
  | 3 => 0
  | 4 => 0
  | 5 => 0
  | 6 => 0
  | 7 => 0
  | 8 => 0
  | 9 => 0
  | _ => 0

public theorem XCell0_13_def : XCell0_13 = ![0, 0, 0, 0, 0, 0, 0, 0, 0, 0] := by
  funext i
  fin_cases i <;> rfl

public theorem XCell0_13_scaled :
    toVec #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0] = ((1 : ℤ) : ℚ) • XCell0_13 :=
  toVec_eq_smul10 #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0] 1 XCell0_13
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)

public def XCell0_14 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => 0
  | 1 => 0
  | 2 => 0
  | 3 => 0
  | 4 => 0
  | 5 => 0
  | 6 => 0
  | 7 => 0
  | 8 => 0
  | 9 => 0
  | _ => 0

public theorem XCell0_14_def : XCell0_14 = ![0, 0, 0, 0, 0, 0, 0, 0, 0, 0] := by
  funext i
  fin_cases i <;> rfl

public theorem XCell0_14_scaled :
    toVec #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0] = ((1 : ℤ) : ℚ) • XCell0_14 :=
  toVec_eq_smul10 #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0] 1 XCell0_14
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)

public def XCell0_15 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => 0
  | 1 => 0
  | 2 => 0
  | 3 => 0
  | 4 => 0
  | 5 => 0
  | 6 => 0
  | 7 => 0
  | 8 => 0
  | 9 => 0
  | _ => 0

public theorem XCell0_15_def : XCell0_15 = ![0, 0, 0, 0, 0, 0, 0, 0, 0, 0] := by
  funext i
  fin_cases i <;> rfl

public theorem XCell0_15_scaled :
    toVec #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0] = ((1 : ℤ) : ℚ) • XCell0_15 :=
  toVec_eq_smul10 #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0] 1 XCell0_15
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)

public def XCell0_16 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => 0
  | 1 => 0
  | 2 => 0
  | 3 => 0
  | 4 => 0
  | 5 => 0
  | 6 => 0
  | 7 => 0
  | 8 => 0
  | 9 => 0
  | _ => 0

public theorem XCell0_16_def : XCell0_16 = ![0, 0, 0, 0, 0, 0, 0, 0, 0, 0] := by
  funext i
  fin_cases i <;> rfl

public theorem XCell0_16_scaled :
    toVec #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0] = ((1 : ℤ) : ℚ) • XCell0_16 :=
  toVec_eq_smul10 #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0] 1 XCell0_16
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)

public def XCell0_17 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => 0
  | 1 => 0
  | 2 => 0
  | 3 => 0
  | 4 => 0
  | 5 => 0
  | 6 => 0
  | 7 => 0
  | 8 => 0
  | 9 => 0
  | _ => 0

public theorem XCell0_17_def : XCell0_17 = ![0, 0, 0, 0, 0, 0, 0, 0, 0, 0] := by
  funext i
  fin_cases i <;> rfl

public theorem XCell0_17_scaled :
    toVec #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0] = ((1 : ℤ) : ℚ) • XCell0_17 :=
  toVec_eq_smul10 #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0] 1 XCell0_17
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)

public def XCell0_18 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => 0
  | 1 => 0
  | 2 => 0
  | 3 => 0
  | 4 => 0
  | 5 => 0
  | 6 => 0
  | 7 => 0
  | 8 => 0
  | 9 => 0
  | _ => 0

public theorem XCell0_18_def : XCell0_18 = ![0, 0, 0, 0, 0, 0, 0, 0, 0, 0] := by
  funext i
  fin_cases i <;> rfl

public theorem XCell0_18_scaled :
    toVec #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0] = ((1 : ℤ) : ℚ) • XCell0_18 :=
  toVec_eq_smul10 #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0] 1 XCell0_18
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)

public def XCell0_19 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => 0
  | 1 => 0
  | 2 => 0
  | 3 => 0
  | 4 => 0
  | 5 => 0
  | 6 => 0
  | 7 => 0
  | 8 => 0
  | 9 => 0
  | _ => 0

public theorem XCell0_19_def : XCell0_19 = ![0, 0, 0, 0, 0, 0, 0, 0, 0, 0] := by
  funext i
  fin_cases i <;> rfl

public theorem XCell0_19_scaled :
    toVec #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0] = ((1 : ℤ) : ℚ) • XCell0_19 :=
  toVec_eq_smul10 #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0] 1 XCell0_19
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)

public def XRow0 (j : Fin 20) : Vec :=
  match j.val with
  | 0 => XCell0_0
  | 1 => XCell0_1
  | 2 => XCell0_2
  | 3 => XCell0_3
  | 4 => XCell0_4
  | 5 => XCell0_5
  | 6 => XCell0_6
  | 7 => XCell0_7
  | 8 => XCell0_8
  | 9 => XCell0_9
  | 10 => XCell0_10
  | 11 => XCell0_11
  | 12 => XCell0_12
  | 13 => XCell0_13
  | 14 => XCell0_14
  | 15 => XCell0_15
  | 16 => XCell0_16
  | 17 => XCell0_17
  | 18 => XCell0_18
  | 19 => XCell0_19
  | _ => 0

public def XCell1_0 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (-3 / 22 : ℚ)
  | 1 => (-3 / 11 : ℚ)
  | 2 => (-5 / 22 : ℚ)
  | 3 => (-5 / 22 : ℚ)
  | 4 => (-5 / 22 : ℚ)
  | 5 => (-3 / 22 : ℚ)
  | 6 => (-2 / 11 : ℚ)
  | 7 => (-3 / 22 : ℚ)
  | 8 => (-3 / 22 : ℚ)
  | 9 => (-7 / 22 : ℚ)
  | _ => 0

public theorem XCell1_0_def : XCell1_0 = ![(-3 / 22 : ℚ), (-3 / 11 : ℚ), (-5 / 22 : ℚ), (-5 / 22 : ℚ), (-5 / 22 : ℚ), (-3 / 22 : ℚ), (-2 / 11 : ℚ), (-3 / 22 : ℚ), (-3 / 22 : ℚ), (-7 / 22 : ℚ)] := by
  funext i
  fin_cases i <;> rfl

public theorem XCell1_0_scaled :
    toVec #v[-3, -6, -5, -5, -5, -3, -4, -3, -3, -7] = ((22 : ℤ) : ℚ) • XCell1_0 :=
  toVec_eq_smul10 #v[-3, -6, -5, -5, -5, -3, -4, -3, -3, -7] 22 XCell1_0
    (eq_smul_div (-3) 22 (-3) (22) (by decide) (by decide))
    (eq_smul_div (-6) 22 (-3) (11) (by decide) (by decide))
    (eq_smul_div (-5) 22 (-5) (22) (by decide) (by decide))
    (eq_smul_div (-5) 22 (-5) (22) (by decide) (by decide))
    (eq_smul_div (-5) 22 (-5) (22) (by decide) (by decide))
    (eq_smul_div (-3) 22 (-3) (22) (by decide) (by decide))
    (eq_smul_div (-4) 22 (-2) (11) (by decide) (by decide))
    (eq_smul_div (-3) 22 (-3) (22) (by decide) (by decide))
    (eq_smul_div (-3) 22 (-3) (22) (by decide) (by decide))
    (eq_smul_div (-7) 22 (-7) (22) (by decide) (by decide))

public def XCell1_1 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (-3 / 11 : ℚ)
  | 1 => (1 / 11 : ℚ)
  | 2 => (-1 / 11 : ℚ)
  | 3 => (1 / 22 : ℚ)
  | 4 => 0
  | 5 => (-3 / 22 : ℚ)
  | 6 => 0
  | 7 => (-2 / 11 : ℚ)
  | 8 => 0
  | 9 => (1 / 22 : ℚ)
  | _ => 0

public theorem XCell1_1_def : XCell1_1 = ![(-3 / 11 : ℚ), (1 / 11 : ℚ), (-1 / 11 : ℚ), (1 / 22 : ℚ), 0, (-3 / 22 : ℚ), 0, (-2 / 11 : ℚ), 0, (1 / 22 : ℚ)] := by
  funext i
  fin_cases i <;> rfl

public theorem XCell1_1_scaled :
    toVec #v[-6, 2, -2, 1, 0, -3, 0, -4, 0, 1] = ((22 : ℤ) : ℚ) • XCell1_1 :=
  toVec_eq_smul10 #v[-6, 2, -2, 1, 0, -3, 0, -4, 0, 1] 22 XCell1_1
    (eq_smul_div (-6) 22 (-3) (11) (by decide) (by decide))
    (eq_smul_div (2) 22 (1) (11) (by decide) (by decide))
    (eq_smul_div (-2) 22 (-1) (11) (by decide) (by decide))
    (eq_smul_div (1) 22 (1) (22) (by decide) (by decide))
    (eq_smul_zero 22)
    (eq_smul_div (-3) 22 (-3) (22) (by decide) (by decide))
    (eq_smul_zero 22)
    (eq_smul_div (-4) 22 (-2) (11) (by decide) (by decide))
    (eq_smul_zero 22)
    (eq_smul_div (1) 22 (1) (22) (by decide) (by decide))

public def XCell1_2 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (1 / 11 : ℚ)
  | 1 => (-1 / 22 : ℚ)
  | 2 => (-1 / 11 : ℚ)
  | 3 => 0
  | 4 => 0
  | 5 => 0
  | 6 => (-2 / 11 : ℚ)
  | 7 => (-1 / 22 : ℚ)
  | 8 => (-2 / 11 : ℚ)
  | 9 => (-1 / 22 : ℚ)
  | _ => 0

public theorem XCell1_2_def : XCell1_2 = ![(1 / 11 : ℚ), (-1 / 22 : ℚ), (-1 / 11 : ℚ), 0, 0, 0, (-2 / 11 : ℚ), (-1 / 22 : ℚ), (-2 / 11 : ℚ), (-1 / 22 : ℚ)] := by
  funext i
  fin_cases i <;> rfl

public theorem XCell1_2_scaled :
    toVec #v[2, -1, -2, 0, 0, 0, -4, -1, -4, -1] = ((22 : ℤ) : ℚ) • XCell1_2 :=
  toVec_eq_smul10 #v[2, -1, -2, 0, 0, 0, -4, -1, -4, -1] 22 XCell1_2
    (eq_smul_div (2) 22 (1) (11) (by decide) (by decide))
    (eq_smul_div (-1) 22 (-1) (22) (by decide) (by decide))
    (eq_smul_div (-2) 22 (-1) (11) (by decide) (by decide))
    (eq_smul_zero 22)
    (eq_smul_zero 22)
    (eq_smul_zero 22)
    (eq_smul_div (-4) 22 (-2) (11) (by decide) (by decide))
    (eq_smul_div (-1) 22 (-1) (22) (by decide) (by decide))
    (eq_smul_div (-4) 22 (-2) (11) (by decide) (by decide))
    (eq_smul_div (-1) 22 (-1) (22) (by decide) (by decide))

public def XCell1_3 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => 0
  | 1 => (-1 / 22 : ℚ)
  | 2 => (1 / 22 : ℚ)
  | 3 => (1 / 22 : ℚ)
  | 4 => (1 / 11 : ℚ)
  | 5 => (-1 / 22 : ℚ)
  | 6 => 0
  | 7 => 0
  | 8 => 0
  | 9 => (-1 / 11 : ℚ)
  | _ => 0

public theorem XCell1_3_def : XCell1_3 = ![0, (-1 / 22 : ℚ), (1 / 22 : ℚ), (1 / 22 : ℚ), (1 / 11 : ℚ), (-1 / 22 : ℚ), 0, 0, 0, (-1 / 11 : ℚ)] := by
  funext i
  fin_cases i <;> rfl

public theorem XCell1_3_scaled :
    toVec #v[0, -1, 1, 1, 2, -1, 0, 0, 0, -2] = ((22 : ℤ) : ℚ) • XCell1_3 :=
  toVec_eq_smul10 #v[0, -1, 1, 1, 2, -1, 0, 0, 0, -2] 22 XCell1_3
    (eq_smul_zero 22)
    (eq_smul_div (-1) 22 (-1) (22) (by decide) (by decide))
    (eq_smul_div (1) 22 (1) (22) (by decide) (by decide))
    (eq_smul_div (1) 22 (1) (22) (by decide) (by decide))
    (eq_smul_div (2) 22 (1) (11) (by decide) (by decide))
    (eq_smul_div (-1) 22 (-1) (22) (by decide) (by decide))
    (eq_smul_zero 22)
    (eq_smul_zero 22)
    (eq_smul_zero 22)
    (eq_smul_div (-2) 22 (-1) (11) (by decide) (by decide))

public def XCell1_4 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (3 / 22 : ℚ)
  | 1 => 0
  | 2 => (3 / 22 : ℚ)
  | 3 => (3 / 22 : ℚ)
  | 4 => (3 / 22 : ℚ)
  | 5 => (-3 / 22 : ℚ)
  | 6 => 0
  | 7 => (3 / 22 : ℚ)
  | 8 => (1 / 11 : ℚ)
  | 9 => (-3 / 22 : ℚ)
  | _ => 0

public theorem XCell1_4_def : XCell1_4 = ![(3 / 22 : ℚ), 0, (3 / 22 : ℚ), (3 / 22 : ℚ), (3 / 22 : ℚ), (-3 / 22 : ℚ), 0, (3 / 22 : ℚ), (1 / 11 : ℚ), (-3 / 22 : ℚ)] := by
  funext i
  fin_cases i <;> rfl

public theorem XCell1_4_scaled :
    toVec #v[3, 0, 3, 3, 3, -3, 0, 3, 2, -3] = ((22 : ℤ) : ℚ) • XCell1_4 :=
  toVec_eq_smul10 #v[3, 0, 3, 3, 3, -3, 0, 3, 2, -3] 22 XCell1_4
    (eq_smul_div (3) 22 (3) (22) (by decide) (by decide))
    (eq_smul_zero 22)
    (eq_smul_div (3) 22 (3) (22) (by decide) (by decide))
    (eq_smul_div (3) 22 (3) (22) (by decide) (by decide))
    (eq_smul_div (3) 22 (3) (22) (by decide) (by decide))
    (eq_smul_div (-3) 22 (-3) (22) (by decide) (by decide))
    (eq_smul_zero 22)
    (eq_smul_div (3) 22 (3) (22) (by decide) (by decide))
    (eq_smul_div (2) 22 (1) (11) (by decide) (by decide))
    (eq_smul_div (-3) 22 (-3) (22) (by decide) (by decide))

public def XCell1_5 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (-1 / 11 : ℚ)
  | 1 => 0
  | 2 => 0
  | 3 => 0
  | 4 => 0
  | 5 => (-2 / 11 : ℚ)
  | 6 => (1 / 11 : ℚ)
  | 7 => (1 / 11 : ℚ)
  | 8 => (1 / 11 : ℚ)
  | 9 => 0
  | _ => 0

public theorem XCell1_5_def : XCell1_5 = ![(-1 / 11 : ℚ), 0, 0, 0, 0, (-2 / 11 : ℚ), (1 / 11 : ℚ), (1 / 11 : ℚ), (1 / 11 : ℚ), 0] := by
  funext i
  fin_cases i <;> rfl

public theorem XCell1_5_scaled :
    toVec #v[-1, 0, 0, 0, 0, -2, 1, 1, 1, 0] = ((11 : ℤ) : ℚ) • XCell1_5 :=
  toVec_eq_smul10 #v[-1, 0, 0, 0, 0, -2, 1, 1, 1, 0] 11 XCell1_5
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_zero 11)
    (eq_smul_zero 11)
    (eq_smul_zero 11)
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))
    (eq_smul_zero 11)

public def XCell1_6 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (-1 / 11 : ℚ)
  | 1 => (-4 / 11 : ℚ)
  | 2 => (-2 / 11 : ℚ)
  | 3 => (-2 / 11 : ℚ)
  | 4 => (-2 / 11 : ℚ)
  | 5 => (-2 / 11 : ℚ)
  | 6 => (-4 / 11 : ℚ)
  | 7 => 0
  | 8 => (-2 / 11 : ℚ)
  | 9 => (-3 / 11 : ℚ)
  | _ => 0

public theorem XCell1_6_def : XCell1_6 = ![(-1 / 11 : ℚ), (-4 / 11 : ℚ), (-2 / 11 : ℚ), (-2 / 11 : ℚ), (-2 / 11 : ℚ), (-2 / 11 : ℚ), (-4 / 11 : ℚ), 0, (-2 / 11 : ℚ), (-3 / 11 : ℚ)] := by
  funext i
  fin_cases i <;> rfl

public theorem XCell1_6_scaled :
    toVec #v[-1, -4, -2, -2, -2, -2, -4, 0, -2, -3] = ((11 : ℤ) : ℚ) • XCell1_6 :=
  toVec_eq_smul10 #v[-1, -4, -2, -2, -2, -2, -4, 0, -2, -3] 11 XCell1_6
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_div (-4) 11 (-4) (11) (by decide) (by decide))
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))
    (eq_smul_div (-4) 11 (-4) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))
    (eq_smul_div (-3) 11 (-3) (11) (by decide) (by decide))

public def XCell1_7 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (-2 / 11 : ℚ)
  | 1 => 0
  | 2 => 0
  | 3 => (-3 / 11 : ℚ)
  | 4 => (-2 / 11 : ℚ)
  | 5 => 0
  | 6 => (-1 / 11 : ℚ)
  | 7 => (-3 / 11 : ℚ)
  | 8 => 0
  | 9 => 0
  | _ => 0

public theorem XCell1_7_def : XCell1_7 = ![(-2 / 11 : ℚ), 0, 0, (-3 / 11 : ℚ), (-2 / 11 : ℚ), 0, (-1 / 11 : ℚ), (-3 / 11 : ℚ), 0, 0] := by
  funext i
  fin_cases i <;> rfl

public theorem XCell1_7_scaled :
    toVec #v[-2, 0, 0, -3, -2, 0, -1, -3, 0, 0] = ((11 : ℤ) : ℚ) • XCell1_7 :=
  toVec_eq_smul10 #v[-2, 0, 0, -3, -2, 0, -1, -3, 0, 0] 11 XCell1_7
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_zero 11)
    (eq_smul_div (-3) 11 (-3) (11) (by decide) (by decide))
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_div (-3) 11 (-3) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_zero 11)

public def XCell1_8 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => 0
  | 1 => 0
  | 2 => 0
  | 3 => 0
  | 4 => 0
  | 5 => 0
  | 6 => 0
  | 7 => 0
  | 8 => 0
  | 9 => 0
  | _ => 0

public theorem XCell1_8_def : XCell1_8 = ![0, 0, 0, 0, 0, 0, 0, 0, 0, 0] := by
  funext i
  fin_cases i <;> rfl

public theorem XCell1_8_scaled :
    toVec #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0] = ((1 : ℤ) : ℚ) • XCell1_8 :=
  toVec_eq_smul10 #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0] 1 XCell1_8
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)

public def XCell1_9 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => 0
  | 1 => 0
  | 2 => 0
  | 3 => 0
  | 4 => 0
  | 5 => 0
  | 6 => 0
  | 7 => 0
  | 8 => 0
  | 9 => 0
  | _ => 0

public theorem XCell1_9_def : XCell1_9 = ![0, 0, 0, 0, 0, 0, 0, 0, 0, 0] := by
  funext i
  fin_cases i <;> rfl

public theorem XCell1_9_scaled :
    toVec #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0] = ((1 : ℤ) : ℚ) • XCell1_9 :=
  toVec_eq_smul10 #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0] 1 XCell1_9
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)

public def XCell1_10 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => 0
  | 1 => 0
  | 2 => 0
  | 3 => 0
  | 4 => 0
  | 5 => 0
  | 6 => 0
  | 7 => 0
  | 8 => 0
  | 9 => 0
  | _ => 0

public theorem XCell1_10_def : XCell1_10 = ![0, 0, 0, 0, 0, 0, 0, 0, 0, 0] := by
  funext i
  fin_cases i <;> rfl

public theorem XCell1_10_scaled :
    toVec #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0] = ((1 : ℤ) : ℚ) • XCell1_10 :=
  toVec_eq_smul10 #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0] 1 XCell1_10
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)

public def XCell1_11 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (1 / 2 : ℚ)
  | 1 => 0
  | 2 => 0
  | 3 => 0
  | 4 => 0
  | 5 => 0
  | 6 => 0
  | 7 => 0
  | 8 => 0
  | 9 => 0
  | _ => 0

public theorem XCell1_11_def : XCell1_11 = ![(1 / 2 : ℚ), 0, 0, 0, 0, 0, 0, 0, 0, 0] := by
  funext i
  fin_cases i <;> rfl

public theorem XCell1_11_scaled :
    toVec #v[1, 0, 0, 0, 0, 0, 0, 0, 0, 0] = ((2 : ℤ) : ℚ) • XCell1_11 :=
  toVec_eq_smul10 #v[1, 0, 0, 0, 0, 0, 0, 0, 0, 0] 2 XCell1_11
    (eq_smul_div (1) 2 (1) (2) (by decide) (by decide))
    (eq_smul_zero 2)
    (eq_smul_zero 2)
    (eq_smul_zero 2)
    (eq_smul_zero 2)
    (eq_smul_zero 2)
    (eq_smul_zero 2)
    (eq_smul_zero 2)
    (eq_smul_zero 2)
    (eq_smul_zero 2)

public def XCell1_12 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => 0
  | 1 => 0
  | 2 => 0
  | 3 => 0
  | 4 => 0
  | 5 => 0
  | 6 => 0
  | 7 => 0
  | 8 => 0
  | 9 => 0
  | _ => 0

public theorem XCell1_12_def : XCell1_12 = ![0, 0, 0, 0, 0, 0, 0, 0, 0, 0] := by
  funext i
  fin_cases i <;> rfl

public theorem XCell1_12_scaled :
    toVec #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0] = ((1 : ℤ) : ℚ) • XCell1_12 :=
  toVec_eq_smul10 #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0] 1 XCell1_12
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)

public def XCell1_13 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => 0
  | 1 => 0
  | 2 => 0
  | 3 => 0
  | 4 => 0
  | 5 => 0
  | 6 => 0
  | 7 => 0
  | 8 => 0
  | 9 => 0
  | _ => 0

public theorem XCell1_13_def : XCell1_13 = ![0, 0, 0, 0, 0, 0, 0, 0, 0, 0] := by
  funext i
  fin_cases i <;> rfl

public theorem XCell1_13_scaled :
    toVec #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0] = ((1 : ℤ) : ℚ) • XCell1_13 :=
  toVec_eq_smul10 #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0] 1 XCell1_13
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)

public def XCell1_14 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => 0
  | 1 => 0
  | 2 => 0
  | 3 => 0
  | 4 => 0
  | 5 => 0
  | 6 => 0
  | 7 => 0
  | 8 => 0
  | 9 => 0
  | _ => 0

public theorem XCell1_14_def : XCell1_14 = ![0, 0, 0, 0, 0, 0, 0, 0, 0, 0] := by
  funext i
  fin_cases i <;> rfl

public theorem XCell1_14_scaled :
    toVec #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0] = ((1 : ℤ) : ℚ) • XCell1_14 :=
  toVec_eq_smul10 #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0] 1 XCell1_14
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)

public def XCell1_15 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => 0
  | 1 => 0
  | 2 => 0
  | 3 => 0
  | 4 => 0
  | 5 => 0
  | 6 => 0
  | 7 => 0
  | 8 => 0
  | 9 => 0
  | _ => 0

public theorem XCell1_15_def : XCell1_15 = ![0, 0, 0, 0, 0, 0, 0, 0, 0, 0] := by
  funext i
  fin_cases i <;> rfl

public theorem XCell1_15_scaled :
    toVec #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0] = ((1 : ℤ) : ℚ) • XCell1_15 :=
  toVec_eq_smul10 #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0] 1 XCell1_15
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)

public def XCell1_16 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => 0
  | 1 => 0
  | 2 => 0
  | 3 => 0
  | 4 => 0
  | 5 => 0
  | 6 => 0
  | 7 => 0
  | 8 => 0
  | 9 => 0
  | _ => 0

public theorem XCell1_16_def : XCell1_16 = ![0, 0, 0, 0, 0, 0, 0, 0, 0, 0] := by
  funext i
  fin_cases i <;> rfl

public theorem XCell1_16_scaled :
    toVec #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0] = ((1 : ℤ) : ℚ) • XCell1_16 :=
  toVec_eq_smul10 #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0] 1 XCell1_16
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)

public def XCell1_17 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => 0
  | 1 => 0
  | 2 => 0
  | 3 => 0
  | 4 => 0
  | 5 => 0
  | 6 => 0
  | 7 => 0
  | 8 => 0
  | 9 => 0
  | _ => 0

public theorem XCell1_17_def : XCell1_17 = ![0, 0, 0, 0, 0, 0, 0, 0, 0, 0] := by
  funext i
  fin_cases i <;> rfl

public theorem XCell1_17_scaled :
    toVec #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0] = ((1 : ℤ) : ℚ) • XCell1_17 :=
  toVec_eq_smul10 #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0] 1 XCell1_17
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)

public def XCell1_18 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => 0
  | 1 => 0
  | 2 => 0
  | 3 => 0
  | 4 => 0
  | 5 => 0
  | 6 => 0
  | 7 => 0
  | 8 => 0
  | 9 => 0
  | _ => 0

public theorem XCell1_18_def : XCell1_18 = ![0, 0, 0, 0, 0, 0, 0, 0, 0, 0] := by
  funext i
  fin_cases i <;> rfl

public theorem XCell1_18_scaled :
    toVec #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0] = ((1 : ℤ) : ℚ) • XCell1_18 :=
  toVec_eq_smul10 #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0] 1 XCell1_18
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)

public def XCell1_19 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => 0
  | 1 => 0
  | 2 => 0
  | 3 => 0
  | 4 => 0
  | 5 => 0
  | 6 => 0
  | 7 => 0
  | 8 => 0
  | 9 => 0
  | _ => 0

public theorem XCell1_19_def : XCell1_19 = ![0, 0, 0, 0, 0, 0, 0, 0, 0, 0] := by
  funext i
  fin_cases i <;> rfl

public theorem XCell1_19_scaled :
    toVec #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0] = ((1 : ℤ) : ℚ) • XCell1_19 :=
  toVec_eq_smul10 #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0] 1 XCell1_19
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)

public def XRow1 (j : Fin 20) : Vec :=
  match j.val with
  | 0 => XCell1_0
  | 1 => XCell1_1
  | 2 => XCell1_2
  | 3 => XCell1_3
  | 4 => XCell1_4
  | 5 => XCell1_5
  | 6 => XCell1_6
  | 7 => XCell1_7
  | 8 => XCell1_8
  | 9 => XCell1_9
  | 10 => XCell1_10
  | 11 => XCell1_11
  | 12 => XCell1_12
  | 13 => XCell1_13
  | 14 => XCell1_14
  | 15 => XCell1_15
  | 16 => XCell1_16
  | 17 => XCell1_17
  | 18 => XCell1_18
  | 19 => XCell1_19
  | _ => 0

public def XCell2_0 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (5 / 11 : ℚ)
  | 1 => (10 / 11 : ℚ)
  | 2 => (10 / 11 : ℚ)
  | 3 => (9 / 11 : ℚ)
  | 4 => (4 / 11 : ℚ)
  | 5 => (23 / 22 : ℚ)
  | 6 => (17 / 22 : ℚ)
  | 7 => (13 / 22 : ℚ)
  | 8 => (19 / 22 : ℚ)
  | 9 => (17 / 22 : ℚ)
  | _ => 0

public theorem XCell2_0_def : XCell2_0 = ![(5 / 11 : ℚ), (10 / 11 : ℚ), (10 / 11 : ℚ), (9 / 11 : ℚ), (4 / 11 : ℚ), (23 / 22 : ℚ), (17 / 22 : ℚ), (13 / 22 : ℚ), (19 / 22 : ℚ), (17 / 22 : ℚ)] := by
  funext i
  fin_cases i <;> rfl

public theorem XCell2_0_scaled :
    toVec #v[10, 20, 20, 18, 8, 23, 17, 13, 19, 17] = ((22 : ℤ) : ℚ) • XCell2_0 :=
  toVec_eq_smul10 #v[10, 20, 20, 18, 8, 23, 17, 13, 19, 17] 22 XCell2_0
    (eq_smul_div (10) 22 (5) (11) (by decide) (by decide))
    (eq_smul_div (20) 22 (10) (11) (by decide) (by decide))
    (eq_smul_div (20) 22 (10) (11) (by decide) (by decide))
    (eq_smul_div (18) 22 (9) (11) (by decide) (by decide))
    (eq_smul_div (8) 22 (4) (11) (by decide) (by decide))
    (eq_smul_div (23) 22 (23) (22) (by decide) (by decide))
    (eq_smul_div (17) 22 (17) (22) (by decide) (by decide))
    (eq_smul_div (13) 22 (13) (22) (by decide) (by decide))
    (eq_smul_div (19) 22 (19) (22) (by decide) (by decide))
    (eq_smul_div (17) 22 (17) (22) (by decide) (by decide))

public def XCell2_1 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (-4 / 11 : ℚ)
  | 1 => (-3 / 11 : ℚ)
  | 2 => (-3 / 22 : ℚ)
  | 3 => (-2 / 11 : ℚ)
  | 4 => (-13 / 22 : ℚ)
  | 5 => (-3 / 11 : ℚ)
  | 6 => (-5 / 11 : ℚ)
  | 7 => (-3 / 11 : ℚ)
  | 8 => (-6 / 11 : ℚ)
  | 9 => (1 / 11 : ℚ)
  | _ => 0

public theorem XCell2_1_def : XCell2_1 = ![(-4 / 11 : ℚ), (-3 / 11 : ℚ), (-3 / 22 : ℚ), (-2 / 11 : ℚ), (-13 / 22 : ℚ), (-3 / 11 : ℚ), (-5 / 11 : ℚ), (-3 / 11 : ℚ), (-6 / 11 : ℚ), (1 / 11 : ℚ)] := by
  funext i
  fin_cases i <;> rfl

public theorem XCell2_1_scaled :
    toVec #v[-8, -6, -3, -4, -13, -6, -10, -6, -12, 2] = ((22 : ℤ) : ℚ) • XCell2_1 :=
  toVec_eq_smul10 #v[-8, -6, -3, -4, -13, -6, -10, -6, -12, 2] 22 XCell2_1
    (eq_smul_div (-8) 22 (-4) (11) (by decide) (by decide))
    (eq_smul_div (-6) 22 (-3) (11) (by decide) (by decide))
    (eq_smul_div (-3) 22 (-3) (22) (by decide) (by decide))
    (eq_smul_div (-4) 22 (-2) (11) (by decide) (by decide))
    (eq_smul_div (-13) 22 (-13) (22) (by decide) (by decide))
    (eq_smul_div (-6) 22 (-3) (11) (by decide) (by decide))
    (eq_smul_div (-10) 22 (-5) (11) (by decide) (by decide))
    (eq_smul_div (-6) 22 (-3) (11) (by decide) (by decide))
    (eq_smul_div (-12) 22 (-6) (11) (by decide) (by decide))
    (eq_smul_div (2) 22 (1) (11) (by decide) (by decide))

public def XCell2_2 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (-4 / 11 : ℚ)
  | 1 => (8 / 11 : ℚ)
  | 2 => (7 / 11 : ℚ)
  | 3 => (5 / 22 : ℚ)
  | 4 => (3 / 11 : ℚ)
  | 5 => (9 / 22 : ℚ)
  | 6 => (3 / 11 : ℚ)
  | 7 => (-1 / 22 : ℚ)
  | 8 => (9 / 22 : ℚ)
  | 9 => (5 / 11 : ℚ)
  | _ => 0

public theorem XCell2_2_def : XCell2_2 = ![(-4 / 11 : ℚ), (8 / 11 : ℚ), (7 / 11 : ℚ), (5 / 22 : ℚ), (3 / 11 : ℚ), (9 / 22 : ℚ), (3 / 11 : ℚ), (-1 / 22 : ℚ), (9 / 22 : ℚ), (5 / 11 : ℚ)] := by
  funext i
  fin_cases i <;> rfl

public theorem XCell2_2_scaled :
    toVec #v[-8, 16, 14, 5, 6, 9, 6, -1, 9, 10] = ((22 : ℤ) : ℚ) • XCell2_2 :=
  toVec_eq_smul10 #v[-8, 16, 14, 5, 6, 9, 6, -1, 9, 10] 22 XCell2_2
    (eq_smul_div (-8) 22 (-4) (11) (by decide) (by decide))
    (eq_smul_div (16) 22 (8) (11) (by decide) (by decide))
    (eq_smul_div (14) 22 (7) (11) (by decide) (by decide))
    (eq_smul_div (5) 22 (5) (22) (by decide) (by decide))
    (eq_smul_div (6) 22 (3) (11) (by decide) (by decide))
    (eq_smul_div (9) 22 (9) (22) (by decide) (by decide))
    (eq_smul_div (6) 22 (3) (11) (by decide) (by decide))
    (eq_smul_div (-1) 22 (-1) (22) (by decide) (by decide))
    (eq_smul_div (9) 22 (9) (22) (by decide) (by decide))
    (eq_smul_div (10) 22 (5) (11) (by decide) (by decide))

public def XCell2_3 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (1 / 22 : ℚ)
  | 1 => 0
  | 2 => (1 / 11 : ℚ)
  | 3 => 0
  | 4 => (-4 / 11 : ℚ)
  | 5 => (2 / 11 : ℚ)
  | 6 => (7 / 22 : ℚ)
  | 7 => (1 / 22 : ℚ)
  | 8 => 0
  | 9 => (2 / 11 : ℚ)
  | _ => 0

public theorem XCell2_3_def : XCell2_3 = ![(1 / 22 : ℚ), 0, (1 / 11 : ℚ), 0, (-4 / 11 : ℚ), (2 / 11 : ℚ), (7 / 22 : ℚ), (1 / 22 : ℚ), 0, (2 / 11 : ℚ)] := by
  funext i
  fin_cases i <;> rfl

public theorem XCell2_3_scaled :
    toVec #v[1, 0, 2, 0, -8, 4, 7, 1, 0, 4] = ((22 : ℤ) : ℚ) • XCell2_3 :=
  toVec_eq_smul10 #v[1, 0, 2, 0, -8, 4, 7, 1, 0, 4] 22 XCell2_3
    (eq_smul_div (1) 22 (1) (22) (by decide) (by decide))
    (eq_smul_zero 22)
    (eq_smul_div (2) 22 (1) (11) (by decide) (by decide))
    (eq_smul_zero 22)
    (eq_smul_div (-8) 22 (-4) (11) (by decide) (by decide))
    (eq_smul_div (4) 22 (2) (11) (by decide) (by decide))
    (eq_smul_div (7) 22 (7) (22) (by decide) (by decide))
    (eq_smul_div (1) 22 (1) (22) (by decide) (by decide))
    (eq_smul_zero 22)
    (eq_smul_div (4) 22 (2) (11) (by decide) (by decide))

public def XCell2_4 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (-3 / 22 : ℚ)
  | 1 => (15 / 22 : ℚ)
  | 2 => (9 / 22 : ℚ)
  | 3 => (-13 / 22 : ℚ)
  | 4 => (-1 / 22 : ℚ)
  | 5 => (19 / 22 : ℚ)
  | 6 => (3 / 22 : ℚ)
  | 7 => (-6 / 11 : ℚ)
  | 8 => (9 / 22 : ℚ)
  | 9 => (9 / 11 : ℚ)
  | _ => 0

public theorem XCell2_4_def : XCell2_4 = ![(-3 / 22 : ℚ), (15 / 22 : ℚ), (9 / 22 : ℚ), (-13 / 22 : ℚ), (-1 / 22 : ℚ), (19 / 22 : ℚ), (3 / 22 : ℚ), (-6 / 11 : ℚ), (9 / 22 : ℚ), (9 / 11 : ℚ)] := by
  funext i
  fin_cases i <;> rfl

public theorem XCell2_4_scaled :
    toVec #v[-3, 15, 9, -13, -1, 19, 3, -12, 9, 18] = ((22 : ℤ) : ℚ) • XCell2_4 :=
  toVec_eq_smul10 #v[-3, 15, 9, -13, -1, 19, 3, -12, 9, 18] 22 XCell2_4
    (eq_smul_div (-3) 22 (-3) (22) (by decide) (by decide))
    (eq_smul_div (15) 22 (15) (22) (by decide) (by decide))
    (eq_smul_div (9) 22 (9) (22) (by decide) (by decide))
    (eq_smul_div (-13) 22 (-13) (22) (by decide) (by decide))
    (eq_smul_div (-1) 22 (-1) (22) (by decide) (by decide))
    (eq_smul_div (19) 22 (19) (22) (by decide) (by decide))
    (eq_smul_div (3) 22 (3) (22) (by decide) (by decide))
    (eq_smul_div (-12) 22 (-6) (11) (by decide) (by decide))
    (eq_smul_div (9) 22 (9) (22) (by decide) (by decide))
    (eq_smul_div (18) 22 (9) (11) (by decide) (by decide))

public def XCell2_5 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => 0
  | 1 => (3 / 11 : ℚ)
  | 2 => (-2 / 11 : ℚ)
  | 3 => (-1 / 11 : ℚ)
  | 4 => (6 / 11 : ℚ)
  | 5 => (9 / 11 : ℚ)
  | 6 => (-2 / 11 : ℚ)
  | 7 => (-3 / 11 : ℚ)
  | 8 => (-3 / 11 : ℚ)
  | 9 => (4 / 11 : ℚ)
  | _ => 0

public theorem XCell2_5_def : XCell2_5 = ![0, (3 / 11 : ℚ), (-2 / 11 : ℚ), (-1 / 11 : ℚ), (6 / 11 : ℚ), (9 / 11 : ℚ), (-2 / 11 : ℚ), (-3 / 11 : ℚ), (-3 / 11 : ℚ), (4 / 11 : ℚ)] := by
  funext i
  fin_cases i <;> rfl

public theorem XCell2_5_scaled :
    toVec #v[0, 3, -2, -1, 6, 9, -2, -3, -3, 4] = ((11 : ℤ) : ℚ) • XCell2_5 :=
  toVec_eq_smul10 #v[0, 3, -2, -1, 6, 9, -2, -3, -3, 4] 11 XCell2_5
    (eq_smul_zero 11)
    (eq_smul_div (3) 11 (3) (11) (by decide) (by decide))
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_div (6) 11 (6) (11) (by decide) (by decide))
    (eq_smul_div (9) 11 (9) (11) (by decide) (by decide))
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))
    (eq_smul_div (-3) 11 (-3) (11) (by decide) (by decide))
    (eq_smul_div (-3) 11 (-3) (11) (by decide) (by decide))
    (eq_smul_div (4) 11 (4) (11) (by decide) (by decide))

public def XCell2_6 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (-2 / 11 : ℚ)
  | 1 => (1 / 11 : ℚ)
  | 2 => (6 / 11 : ℚ)
  | 3 => (2 / 11 : ℚ)
  | 4 => (-1 / 11 : ℚ)
  | 5 => (4 / 11 : ℚ)
  | 6 => (4 / 11 : ℚ)
  | 7 => (-6 / 11 : ℚ)
  | 8 => 0
  | 9 => (3 / 11 : ℚ)
  | _ => 0

public theorem XCell2_6_def : XCell2_6 = ![(-2 / 11 : ℚ), (1 / 11 : ℚ), (6 / 11 : ℚ), (2 / 11 : ℚ), (-1 / 11 : ℚ), (4 / 11 : ℚ), (4 / 11 : ℚ), (-6 / 11 : ℚ), 0, (3 / 11 : ℚ)] := by
  funext i
  fin_cases i <;> rfl

public theorem XCell2_6_scaled :
    toVec #v[-2, 1, 6, 2, -1, 4, 4, -6, 0, 3] = ((11 : ℤ) : ℚ) • XCell2_6 :=
  toVec_eq_smul10 #v[-2, 1, 6, 2, -1, 4, 4, -6, 0, 3] 11 XCell2_6
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))
    (eq_smul_div (6) 11 (6) (11) (by decide) (by decide))
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_div (4) 11 (4) (11) (by decide) (by decide))
    (eq_smul_div (4) 11 (4) (11) (by decide) (by decide))
    (eq_smul_div (-6) 11 (-6) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_div (3) 11 (3) (11) (by decide) (by decide))

public def XCell2_7 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (7 / 11 : ℚ)
  | 1 => (-1 / 11 : ℚ)
  | 2 => 0
  | 3 => (8 / 11 : ℚ)
  | 4 => 0
  | 5 => (-8 / 11 : ℚ)
  | 6 => (-2 / 11 : ℚ)
  | 7 => (7 / 11 : ℚ)
  | 8 => (-2 / 11 : ℚ)
  | 9 => (-9 / 11 : ℚ)
  | _ => 0

public theorem XCell2_7_def : XCell2_7 = ![(7 / 11 : ℚ), (-1 / 11 : ℚ), 0, (8 / 11 : ℚ), 0, (-8 / 11 : ℚ), (-2 / 11 : ℚ), (7 / 11 : ℚ), (-2 / 11 : ℚ), (-9 / 11 : ℚ)] := by
  funext i
  fin_cases i <;> rfl

public theorem XCell2_7_scaled :
    toVec #v[7, -1, 0, 8, 0, -8, -2, 7, -2, -9] = ((11 : ℤ) : ℚ) • XCell2_7 :=
  toVec_eq_smul10 #v[7, -1, 0, 8, 0, -8, -2, 7, -2, -9] 11 XCell2_7
    (eq_smul_div (7) 11 (7) (11) (by decide) (by decide))
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_div (8) 11 (8) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_div (-8) 11 (-8) (11) (by decide) (by decide))
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))
    (eq_smul_div (7) 11 (7) (11) (by decide) (by decide))
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))
    (eq_smul_div (-9) 11 (-9) (11) (by decide) (by decide))

public def XCell2_8 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => 0
  | 1 => 0
  | 2 => 0
  | 3 => 0
  | 4 => 0
  | 5 => 0
  | 6 => 0
  | 7 => 0
  | 8 => 0
  | 9 => 0
  | _ => 0

public theorem XCell2_8_def : XCell2_8 = ![0, 0, 0, 0, 0, 0, 0, 0, 0, 0] := by
  funext i
  fin_cases i <;> rfl

public theorem XCell2_8_scaled :
    toVec #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0] = ((1 : ℤ) : ℚ) • XCell2_8 :=
  toVec_eq_smul10 #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0] 1 XCell2_8
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)

public def XCell2_9 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => 0
  | 1 => 0
  | 2 => 0
  | 3 => 0
  | 4 => 0
  | 5 => 0
  | 6 => 0
  | 7 => 0
  | 8 => 0
  | 9 => 0
  | _ => 0

public theorem XCell2_9_def : XCell2_9 = ![0, 0, 0, 0, 0, 0, 0, 0, 0, 0] := by
  funext i
  fin_cases i <;> rfl

public theorem XCell2_9_scaled :
    toVec #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0] = ((1 : ℤ) : ℚ) • XCell2_9 :=
  toVec_eq_smul10 #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0] 1 XCell2_9
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)

public def XCell2_10 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => 0
  | 1 => 0
  | 2 => 0
  | 3 => 0
  | 4 => 0
  | 5 => (1 / 2 : ℚ)
  | 6 => (1 / 2 : ℚ)
  | 7 => 0
  | 8 => 0
  | 9 => 0
  | _ => 0

public theorem XCell2_10_def : XCell2_10 = ![0, 0, 0, 0, 0, (1 / 2 : ℚ), (1 / 2 : ℚ), 0, 0, 0] := by
  funext i
  fin_cases i <;> rfl

public theorem XCell2_10_scaled :
    toVec #v[0, 0, 0, 0, 0, 1, 1, 0, 0, 0] = ((2 : ℤ) : ℚ) • XCell2_10 :=
  toVec_eq_smul10 #v[0, 0, 0, 0, 0, 1, 1, 0, 0, 0] 2 XCell2_10
    (eq_smul_zero 2)
    (eq_smul_zero 2)
    (eq_smul_zero 2)
    (eq_smul_zero 2)
    (eq_smul_zero 2)
    (eq_smul_div (1) 2 (1) (2) (by decide) (by decide))
    (eq_smul_div (1) 2 (1) (2) (by decide) (by decide))
    (eq_smul_zero 2)
    (eq_smul_zero 2)
    (eq_smul_zero 2)

public def XCell2_11 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (-1 / 2 : ℚ)
  | 1 => 0
  | 2 => (1 / 2 : ℚ)
  | 3 => 0
  | 4 => (-1 / 2 : ℚ)
  | 5 => 0
  | 6 => 0
  | 7 => (-1 / 2 : ℚ)
  | 8 => 0
  | 9 => (1 / 2 : ℚ)
  | _ => 0

public theorem XCell2_11_def : XCell2_11 = ![(-1 / 2 : ℚ), 0, (1 / 2 : ℚ), 0, (-1 / 2 : ℚ), 0, 0, (-1 / 2 : ℚ), 0, (1 / 2 : ℚ)] := by
  funext i
  fin_cases i <;> rfl

public theorem XCell2_11_scaled :
    toVec #v[-1, 0, 1, 0, -1, 0, 0, -1, 0, 1] = ((2 : ℤ) : ℚ) • XCell2_11 :=
  toVec_eq_smul10 #v[-1, 0, 1, 0, -1, 0, 0, -1, 0, 1] 2 XCell2_11
    (eq_smul_div (-1) 2 (-1) (2) (by decide) (by decide))
    (eq_smul_zero 2)
    (eq_smul_div (1) 2 (1) (2) (by decide) (by decide))
    (eq_smul_zero 2)
    (eq_smul_div (-1) 2 (-1) (2) (by decide) (by decide))
    (eq_smul_zero 2)
    (eq_smul_zero 2)
    (eq_smul_div (-1) 2 (-1) (2) (by decide) (by decide))
    (eq_smul_zero 2)
    (eq_smul_div (1) 2 (1) (2) (by decide) (by decide))

public def XCell2_12 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => 0
  | 1 => 0
  | 2 => 0
  | 3 => 0
  | 4 => 0
  | 5 => 0
  | 6 => 0
  | 7 => 0
  | 8 => 0
  | 9 => 0
  | _ => 0

public theorem XCell2_12_def : XCell2_12 = ![0, 0, 0, 0, 0, 0, 0, 0, 0, 0] := by
  funext i
  fin_cases i <;> rfl

public theorem XCell2_12_scaled :
    toVec #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0] = ((1 : ℤ) : ℚ) • XCell2_12 :=
  toVec_eq_smul10 #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0] 1 XCell2_12
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)

public def XCell2_13 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => 0
  | 1 => 0
  | 2 => 0
  | 3 => 0
  | 4 => 0
  | 5 => 0
  | 6 => 0
  | 7 => 0
  | 8 => 0
  | 9 => 0
  | _ => 0

public theorem XCell2_13_def : XCell2_13 = ![0, 0, 0, 0, 0, 0, 0, 0, 0, 0] := by
  funext i
  fin_cases i <;> rfl

public theorem XCell2_13_scaled :
    toVec #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0] = ((1 : ℤ) : ℚ) • XCell2_13 :=
  toVec_eq_smul10 #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0] 1 XCell2_13
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)

public def XCell2_14 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => 0
  | 1 => 0
  | 2 => 0
  | 3 => 0
  | 4 => 0
  | 5 => 0
  | 6 => 0
  | 7 => 0
  | 8 => 0
  | 9 => 0
  | _ => 0

public theorem XCell2_14_def : XCell2_14 = ![0, 0, 0, 0, 0, 0, 0, 0, 0, 0] := by
  funext i
  fin_cases i <;> rfl

public theorem XCell2_14_scaled :
    toVec #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0] = ((1 : ℤ) : ℚ) • XCell2_14 :=
  toVec_eq_smul10 #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0] 1 XCell2_14
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)

public def XCell2_15 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => 0
  | 1 => 0
  | 2 => 0
  | 3 => 0
  | 4 => 0
  | 5 => 0
  | 6 => 0
  | 7 => 0
  | 8 => 0
  | 9 => 0
  | _ => 0

public theorem XCell2_15_def : XCell2_15 = ![0, 0, 0, 0, 0, 0, 0, 0, 0, 0] := by
  funext i
  fin_cases i <;> rfl

public theorem XCell2_15_scaled :
    toVec #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0] = ((1 : ℤ) : ℚ) • XCell2_15 :=
  toVec_eq_smul10 #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0] 1 XCell2_15
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)

public def XCell2_16 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => 0
  | 1 => 0
  | 2 => 0
  | 3 => 0
  | 4 => 0
  | 5 => 0
  | 6 => 0
  | 7 => 0
  | 8 => 0
  | 9 => 0
  | _ => 0

public theorem XCell2_16_def : XCell2_16 = ![0, 0, 0, 0, 0, 0, 0, 0, 0, 0] := by
  funext i
  fin_cases i <;> rfl

public theorem XCell2_16_scaled :
    toVec #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0] = ((1 : ℤ) : ℚ) • XCell2_16 :=
  toVec_eq_smul10 #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0] 1 XCell2_16
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)

public def XCell2_17 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => 0
  | 1 => 0
  | 2 => 0
  | 3 => 0
  | 4 => 0
  | 5 => 0
  | 6 => 0
  | 7 => 0
  | 8 => 0
  | 9 => 0
  | _ => 0

public theorem XCell2_17_def : XCell2_17 = ![0, 0, 0, 0, 0, 0, 0, 0, 0, 0] := by
  funext i
  fin_cases i <;> rfl

public theorem XCell2_17_scaled :
    toVec #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0] = ((1 : ℤ) : ℚ) • XCell2_17 :=
  toVec_eq_smul10 #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0] 1 XCell2_17
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)

public def XCell2_18 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => 0
  | 1 => 0
  | 2 => 0
  | 3 => 0
  | 4 => 0
  | 5 => 0
  | 6 => 0
  | 7 => 0
  | 8 => 0
  | 9 => 0
  | _ => 0

public theorem XCell2_18_def : XCell2_18 = ![0, 0, 0, 0, 0, 0, 0, 0, 0, 0] := by
  funext i
  fin_cases i <;> rfl

public theorem XCell2_18_scaled :
    toVec #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0] = ((1 : ℤ) : ℚ) • XCell2_18 :=
  toVec_eq_smul10 #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0] 1 XCell2_18
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)

public def XCell2_19 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => 0
  | 1 => 0
  | 2 => 0
  | 3 => 0
  | 4 => 0
  | 5 => 0
  | 6 => 0
  | 7 => 0
  | 8 => 0
  | 9 => 0
  | _ => 0

public theorem XCell2_19_def : XCell2_19 = ![0, 0, 0, 0, 0, 0, 0, 0, 0, 0] := by
  funext i
  fin_cases i <;> rfl

public theorem XCell2_19_scaled :
    toVec #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0] = ((1 : ℤ) : ℚ) • XCell2_19 :=
  toVec_eq_smul10 #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0] 1 XCell2_19
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)

public def XRow2 (j : Fin 20) : Vec :=
  match j.val with
  | 0 => XCell2_0
  | 1 => XCell2_1
  | 2 => XCell2_2
  | 3 => XCell2_3
  | 4 => XCell2_4
  | 5 => XCell2_5
  | 6 => XCell2_6
  | 7 => XCell2_7
  | 8 => XCell2_8
  | 9 => XCell2_9
  | 10 => XCell2_10
  | 11 => XCell2_11
  | 12 => XCell2_12
  | 13 => XCell2_13
  | 14 => XCell2_14
  | 15 => XCell2_15
  | 16 => XCell2_16
  | 17 => XCell2_17
  | 18 => XCell2_18
  | 19 => XCell2_19
  | _ => 0

public def XCell3_0 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (3 / 22 : ℚ)
  | 1 => (-10 / 11 : ℚ)
  | 2 => (1 / 22 : ℚ)
  | 3 => (9 / 22 : ℚ)
  | 4 => (-3 / 11 : ℚ)
  | 5 => (3 / 22 : ℚ)
  | 6 => (-1 / 22 : ℚ)
  | 7 => 0
  | 8 => (5 / 22 : ℚ)
  | 9 => (-8 / 11 : ℚ)
  | _ => 0

public theorem XCell3_0_def : XCell3_0 = ![(3 / 22 : ℚ), (-10 / 11 : ℚ), (1 / 22 : ℚ), (9 / 22 : ℚ), (-3 / 11 : ℚ), (3 / 22 : ℚ), (-1 / 22 : ℚ), 0, (5 / 22 : ℚ), (-8 / 11 : ℚ)] := by
  funext i
  fin_cases i <;> rfl

public theorem XCell3_0_scaled :
    toVec #v[3, -20, 1, 9, -6, 3, -1, 0, 5, -16] = ((22 : ℤ) : ℚ) • XCell3_0 :=
  toVec_eq_smul10 #v[3, -20, 1, 9, -6, 3, -1, 0, 5, -16] 22 XCell3_0
    (eq_smul_div (3) 22 (3) (22) (by decide) (by decide))
    (eq_smul_div (-20) 22 (-10) (11) (by decide) (by decide))
    (eq_smul_div (1) 22 (1) (22) (by decide) (by decide))
    (eq_smul_div (9) 22 (9) (22) (by decide) (by decide))
    (eq_smul_div (-6) 22 (-3) (11) (by decide) (by decide))
    (eq_smul_div (3) 22 (3) (22) (by decide) (by decide))
    (eq_smul_div (-1) 22 (-1) (22) (by decide) (by decide))
    (eq_smul_zero 22)
    (eq_smul_div (5) 22 (5) (22) (by decide) (by decide))
    (eq_smul_div (-16) 22 (-8) (11) (by decide) (by decide))

public def XCell3_1 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (3 / 11 : ℚ)
  | 1 => (9 / 11 : ℚ)
  | 2 => (-3 / 22 : ℚ)
  | 3 => (5 / 11 : ℚ)
  | 4 => (8 / 11 : ℚ)
  | 5 => (1 / 22 : ℚ)
  | 6 => (5 / 11 : ℚ)
  | 7 => (9 / 22 : ℚ)
  | 8 => (5 / 22 : ℚ)
  | 9 => (8 / 11 : ℚ)
  | _ => 0

public theorem XCell3_1_def : XCell3_1 = ![(3 / 11 : ℚ), (9 / 11 : ℚ), (-3 / 22 : ℚ), (5 / 11 : ℚ), (8 / 11 : ℚ), (1 / 22 : ℚ), (5 / 11 : ℚ), (9 / 22 : ℚ), (5 / 22 : ℚ), (8 / 11 : ℚ)] := by
  funext i
  fin_cases i <;> rfl

public theorem XCell3_1_scaled :
    toVec #v[6, 18, -3, 10, 16, 1, 10, 9, 5, 16] = ((22 : ℤ) : ℚ) • XCell3_1 :=
  toVec_eq_smul10 #v[6, 18, -3, 10, 16, 1, 10, 9, 5, 16] 22 XCell3_1
    (eq_smul_div (6) 22 (3) (11) (by decide) (by decide))
    (eq_smul_div (18) 22 (9) (11) (by decide) (by decide))
    (eq_smul_div (-3) 22 (-3) (22) (by decide) (by decide))
    (eq_smul_div (10) 22 (5) (11) (by decide) (by decide))
    (eq_smul_div (16) 22 (8) (11) (by decide) (by decide))
    (eq_smul_div (1) 22 (1) (22) (by decide) (by decide))
    (eq_smul_div (10) 22 (5) (11) (by decide) (by decide))
    (eq_smul_div (9) 22 (9) (22) (by decide) (by decide))
    (eq_smul_div (5) 22 (5) (22) (by decide) (by decide))
    (eq_smul_div (16) 22 (8) (11) (by decide) (by decide))

public def XCell3_2 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => 0
  | 1 => (-5 / 11 : ℚ)
  | 2 => (1 / 22 : ℚ)
  | 3 => (7 / 22 : ℚ)
  | 4 => (-1 / 11 : ℚ)
  | 5 => (-9 / 22 : ℚ)
  | 6 => (-1 / 22 : ℚ)
  | 7 => 0
  | 8 => (-4 / 11 : ℚ)
  | 9 => (-1 / 2 : ℚ)
  | _ => 0

public theorem XCell3_2_def : XCell3_2 = ![0, (-5 / 11 : ℚ), (1 / 22 : ℚ), (7 / 22 : ℚ), (-1 / 11 : ℚ), (-9 / 22 : ℚ), (-1 / 22 : ℚ), 0, (-4 / 11 : ℚ), (-1 / 2 : ℚ)] := by
  funext i
  fin_cases i <;> rfl

public theorem XCell3_2_scaled :
    toVec #v[0, -10, 1, 7, -2, -9, -1, 0, -8, -11] = ((22 : ℤ) : ℚ) • XCell3_2 :=
  toVec_eq_smul10 #v[0, -10, 1, 7, -2, -9, -1, 0, -8, -11] 22 XCell3_2
    (eq_smul_zero 22)
    (eq_smul_div (-10) 22 (-5) (11) (by decide) (by decide))
    (eq_smul_div (1) 22 (1) (22) (by decide) (by decide))
    (eq_smul_div (7) 22 (7) (22) (by decide) (by decide))
    (eq_smul_div (-2) 22 (-1) (11) (by decide) (by decide))
    (eq_smul_div (-9) 22 (-9) (22) (by decide) (by decide))
    (eq_smul_div (-1) 22 (-1) (22) (by decide) (by decide))
    (eq_smul_zero 22)
    (eq_smul_div (-8) 22 (-4) (11) (by decide) (by decide))
    (eq_smul_div (-11) 22 (-1) (2) (by decide) (by decide))

public def XCell3_3 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (-2 / 11 : ℚ)
  | 1 => (-5 / 22 : ℚ)
  | 2 => (-5 / 22 : ℚ)
  | 3 => (1 / 22 : ℚ)
  | 4 => (-7 / 22 : ℚ)
  | 5 => (3 / 22 : ℚ)
  | 6 => (-1 / 11 : ℚ)
  | 7 => (3 / 22 : ℚ)
  | 8 => (7 / 22 : ℚ)
  | 9 => (-1 / 11 : ℚ)
  | _ => 0

public theorem XCell3_3_def : XCell3_3 = ![(-2 / 11 : ℚ), (-5 / 22 : ℚ), (-5 / 22 : ℚ), (1 / 22 : ℚ), (-7 / 22 : ℚ), (3 / 22 : ℚ), (-1 / 11 : ℚ), (3 / 22 : ℚ), (7 / 22 : ℚ), (-1 / 11 : ℚ)] := by
  funext i
  fin_cases i <;> rfl

public theorem XCell3_3_scaled :
    toVec #v[-4, -5, -5, 1, -7, 3, -2, 3, 7, -2] = ((22 : ℤ) : ℚ) • XCell3_3 :=
  toVec_eq_smul10 #v[-4, -5, -5, 1, -7, 3, -2, 3, 7, -2] 22 XCell3_3
    (eq_smul_div (-4) 22 (-2) (11) (by decide) (by decide))
    (eq_smul_div (-5) 22 (-5) (22) (by decide) (by decide))
    (eq_smul_div (-5) 22 (-5) (22) (by decide) (by decide))
    (eq_smul_div (1) 22 (1) (22) (by decide) (by decide))
    (eq_smul_div (-7) 22 (-7) (22) (by decide) (by decide))
    (eq_smul_div (3) 22 (3) (22) (by decide) (by decide))
    (eq_smul_div (-2) 22 (-1) (11) (by decide) (by decide))
    (eq_smul_div (3) 22 (3) (22) (by decide) (by decide))
    (eq_smul_div (7) 22 (7) (22) (by decide) (by decide))
    (eq_smul_div (-2) 22 (-1) (11) (by decide) (by decide))

public def XCell3_4 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (1 / 22 : ℚ)
  | 1 => -1
  | 2 => (-17 / 22 : ℚ)
  | 3 => (1 / 22 : ℚ)
  | 4 => (-13 / 22 : ℚ)
  | 5 => (-23 / 22 : ℚ)
  | 6 => (-1 / 2 : ℚ)
  | 7 => (1 / 11 : ℚ)
  | 8 => (-9 / 11 : ℚ)
  | 9 => (-21 / 22 : ℚ)
  | _ => 0

public theorem XCell3_4_def : XCell3_4 = ![(1 / 22 : ℚ), -1, (-17 / 22 : ℚ), (1 / 22 : ℚ), (-13 / 22 : ℚ), (-23 / 22 : ℚ), (-1 / 2 : ℚ), (1 / 11 : ℚ), (-9 / 11 : ℚ), (-21 / 22 : ℚ)] := by
  funext i
  fin_cases i <;> rfl

public theorem XCell3_4_scaled :
    toVec #v[1, -22, -17, 1, -13, -23, -11, 2, -18, -21] = ((22 : ℤ) : ℚ) • XCell3_4 :=
  toVec_eq_smul10 #v[1, -22, -17, 1, -13, -23, -11, 2, -18, -21] 22 XCell3_4
    (eq_smul_div (1) 22 (1) (22) (by decide) (by decide))
    (eq_smul_int (-22) 22 (-1) (by decide))
    (eq_smul_div (-17) 22 (-17) (22) (by decide) (by decide))
    (eq_smul_div (1) 22 (1) (22) (by decide) (by decide))
    (eq_smul_div (-13) 22 (-13) (22) (by decide) (by decide))
    (eq_smul_div (-23) 22 (-23) (22) (by decide) (by decide))
    (eq_smul_div (-11) 22 (-1) (2) (by decide) (by decide))
    (eq_smul_div (2) 22 (1) (11) (by decide) (by decide))
    (eq_smul_div (-18) 22 (-9) (11) (by decide) (by decide))
    (eq_smul_div (-21) 22 (-21) (22) (by decide) (by decide))

public def XCell3_5 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (-3 / 11 : ℚ)
  | 1 => (-2 / 11 : ℚ)
  | 2 => (-5 / 11 : ℚ)
  | 3 => (2 / 11 : ℚ)
  | 4 => 0
  | 5 => (-5 / 11 : ℚ)
  | 6 => (1 / 11 : ℚ)
  | 7 => (2 / 11 : ℚ)
  | 8 => (-9 / 11 : ℚ)
  | 9 => (-3 / 11 : ℚ)
  | _ => 0

public theorem XCell3_5_def : XCell3_5 = ![(-3 / 11 : ℚ), (-2 / 11 : ℚ), (-5 / 11 : ℚ), (2 / 11 : ℚ), 0, (-5 / 11 : ℚ), (1 / 11 : ℚ), (2 / 11 : ℚ), (-9 / 11 : ℚ), (-3 / 11 : ℚ)] := by
  funext i
  fin_cases i <;> rfl

public theorem XCell3_5_scaled :
    toVec #v[-3, -2, -5, 2, 0, -5, 1, 2, -9, -3] = ((11 : ℤ) : ℚ) • XCell3_5 :=
  toVec_eq_smul10 #v[-3, -2, -5, 2, 0, -5, 1, 2, -9, -3] 11 XCell3_5
    (eq_smul_div (-3) 11 (-3) (11) (by decide) (by decide))
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))
    (eq_smul_div (-5) 11 (-5) (11) (by decide) (by decide))
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_div (-5) 11 (-5) (11) (by decide) (by decide))
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_div (-9) 11 (-9) (11) (by decide) (by decide))
    (eq_smul_div (-3) 11 (-3) (11) (by decide) (by decide))

public def XCell3_6 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (5 / 11 : ℚ)
  | 1 => (-6 / 11 : ℚ)
  | 2 => (2 / 11 : ℚ)
  | 3 => (3 / 11 : ℚ)
  | 4 => (-1 / 11 : ℚ)
  | 5 => (3 / 11 : ℚ)
  | 6 => (-3 / 11 : ℚ)
  | 7 => (1 / 11 : ℚ)
  | 8 => (4 / 11 : ℚ)
  | 9 => (-8 / 11 : ℚ)
  | _ => 0

public theorem XCell3_6_def : XCell3_6 = ![(5 / 11 : ℚ), (-6 / 11 : ℚ), (2 / 11 : ℚ), (3 / 11 : ℚ), (-1 / 11 : ℚ), (3 / 11 : ℚ), (-3 / 11 : ℚ), (1 / 11 : ℚ), (4 / 11 : ℚ), (-8 / 11 : ℚ)] := by
  funext i
  fin_cases i <;> rfl

public theorem XCell3_6_scaled :
    toVec #v[5, -6, 2, 3, -1, 3, -3, 1, 4, -8] = ((11 : ℤ) : ℚ) • XCell3_6 :=
  toVec_eq_smul10 #v[5, -6, 2, 3, -1, 3, -3, 1, 4, -8] 11 XCell3_6
    (eq_smul_div (5) 11 (5) (11) (by decide) (by decide))
    (eq_smul_div (-6) 11 (-6) (11) (by decide) (by decide))
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_div (3) 11 (3) (11) (by decide) (by decide))
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_div (3) 11 (3) (11) (by decide) (by decide))
    (eq_smul_div (-3) 11 (-3) (11) (by decide) (by decide))
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))
    (eq_smul_div (4) 11 (4) (11) (by decide) (by decide))
    (eq_smul_div (-8) 11 (-8) (11) (by decide) (by decide))

public def XCell3_7 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (2 / 11 : ℚ)
  | 1 => 1
  | 2 => (12 / 11 : ℚ)
  | 3 => 0
  | 4 => (2 / 11 : ℚ)
  | 5 => (14 / 11 : ℚ)
  | 6 => (1 / 11 : ℚ)
  | 7 => (-2 / 11 : ℚ)
  | 8 => (9 / 11 : ℚ)
  | 9 => (6 / 11 : ℚ)
  | _ => 0

public theorem XCell3_7_def : XCell3_7 = ![(2 / 11 : ℚ), 1, (12 / 11 : ℚ), 0, (2 / 11 : ℚ), (14 / 11 : ℚ), (1 / 11 : ℚ), (-2 / 11 : ℚ), (9 / 11 : ℚ), (6 / 11 : ℚ)] := by
  funext i
  fin_cases i <;> rfl

public theorem XCell3_7_scaled :
    toVec #v[2, 11, 12, 0, 2, 14, 1, -2, 9, 6] = ((11 : ℤ) : ℚ) • XCell3_7 :=
  toVec_eq_smul10 #v[2, 11, 12, 0, 2, 14, 1, -2, 9, 6] 11 XCell3_7
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_int (11) 11 (1) (by decide))
    (eq_smul_div (12) 11 (12) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_div (14) 11 (14) (11) (by decide) (by decide))
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))
    (eq_smul_div (9) 11 (9) (11) (by decide) (by decide))
    (eq_smul_div (6) 11 (6) (11) (by decide) (by decide))

public def XCell3_8 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => 0
  | 1 => 0
  | 2 => 0
  | 3 => 0
  | 4 => 0
  | 5 => 0
  | 6 => 0
  | 7 => 0
  | 8 => 0
  | 9 => 0
  | _ => 0

public theorem XCell3_8_def : XCell3_8 = ![0, 0, 0, 0, 0, 0, 0, 0, 0, 0] := by
  funext i
  fin_cases i <;> rfl

public theorem XCell3_8_scaled :
    toVec #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0] = ((1 : ℤ) : ℚ) • XCell3_8 :=
  toVec_eq_smul10 #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0] 1 XCell3_8
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)

public def XCell3_9 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => 0
  | 1 => 0
  | 2 => 0
  | 3 => 0
  | 4 => 0
  | 5 => 0
  | 6 => 0
  | 7 => 0
  | 8 => 0
  | 9 => 0
  | _ => 0

public theorem XCell3_9_def : XCell3_9 = ![0, 0, 0, 0, 0, 0, 0, 0, 0, 0] := by
  funext i
  fin_cases i <;> rfl

public theorem XCell3_9_scaled :
    toVec #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0] = ((1 : ℤ) : ℚ) • XCell3_9 :=
  toVec_eq_smul10 #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0] 1 XCell3_9
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)

public def XCell3_10 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (1 / 2 : ℚ)
  | 1 => 0
  | 2 => 0
  | 3 => (1 / 2 : ℚ)
  | 4 => (1 / 2 : ℚ)
  | 5 => (1 / 2 : ℚ)
  | 6 => (1 / 2 : ℚ)
  | 7 => (1 / 2 : ℚ)
  | 8 => (1 / 2 : ℚ)
  | 9 => 0
  | _ => 0

public theorem XCell3_10_def : XCell3_10 = ![(1 / 2 : ℚ), 0, 0, (1 / 2 : ℚ), (1 / 2 : ℚ), (1 / 2 : ℚ), (1 / 2 : ℚ), (1 / 2 : ℚ), (1 / 2 : ℚ), 0] := by
  funext i
  fin_cases i <;> rfl

public theorem XCell3_10_scaled :
    toVec #v[1, 0, 0, 1, 1, 1, 1, 1, 1, 0] = ((2 : ℤ) : ℚ) • XCell3_10 :=
  toVec_eq_smul10 #v[1, 0, 0, 1, 1, 1, 1, 1, 1, 0] 2 XCell3_10
    (eq_smul_div (1) 2 (1) (2) (by decide) (by decide))
    (eq_smul_zero 2)
    (eq_smul_zero 2)
    (eq_smul_div (1) 2 (1) (2) (by decide) (by decide))
    (eq_smul_div (1) 2 (1) (2) (by decide) (by decide))
    (eq_smul_div (1) 2 (1) (2) (by decide) (by decide))
    (eq_smul_div (1) 2 (1) (2) (by decide) (by decide))
    (eq_smul_div (1) 2 (1) (2) (by decide) (by decide))
    (eq_smul_div (1) 2 (1) (2) (by decide) (by decide))
    (eq_smul_zero 2)

public def XCell3_11 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (1 / 2 : ℚ)
  | 1 => 0
  | 2 => 0
  | 3 => (1 / 2 : ℚ)
  | 4 => (1 / 2 : ℚ)
  | 5 => 0
  | 6 => 0
  | 7 => (1 / 2 : ℚ)
  | 8 => (1 / 2 : ℚ)
  | 9 => 0
  | _ => 0

public theorem XCell3_11_def : XCell3_11 = ![(1 / 2 : ℚ), 0, 0, (1 / 2 : ℚ), (1 / 2 : ℚ), 0, 0, (1 / 2 : ℚ), (1 / 2 : ℚ), 0] := by
  funext i
  fin_cases i <;> rfl

public theorem XCell3_11_scaled :
    toVec #v[1, 0, 0, 1, 1, 0, 0, 1, 1, 0] = ((2 : ℤ) : ℚ) • XCell3_11 :=
  toVec_eq_smul10 #v[1, 0, 0, 1, 1, 0, 0, 1, 1, 0] 2 XCell3_11
    (eq_smul_div (1) 2 (1) (2) (by decide) (by decide))
    (eq_smul_zero 2)
    (eq_smul_zero 2)
    (eq_smul_div (1) 2 (1) (2) (by decide) (by decide))
    (eq_smul_div (1) 2 (1) (2) (by decide) (by decide))
    (eq_smul_zero 2)
    (eq_smul_zero 2)
    (eq_smul_div (1) 2 (1) (2) (by decide) (by decide))
    (eq_smul_div (1) 2 (1) (2) (by decide) (by decide))
    (eq_smul_zero 2)

public def XCell3_12 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => 0
  | 1 => 0
  | 2 => 0
  | 3 => 0
  | 4 => 0
  | 5 => 0
  | 6 => 0
  | 7 => 0
  | 8 => 0
  | 9 => 0
  | _ => 0

public theorem XCell3_12_def : XCell3_12 = ![0, 0, 0, 0, 0, 0, 0, 0, 0, 0] := by
  funext i
  fin_cases i <;> rfl

public theorem XCell3_12_scaled :
    toVec #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0] = ((1 : ℤ) : ℚ) • XCell3_12 :=
  toVec_eq_smul10 #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0] 1 XCell3_12
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)

public def XCell3_13 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => 0
  | 1 => 0
  | 2 => 0
  | 3 => 0
  | 4 => 0
  | 5 => 0
  | 6 => 0
  | 7 => 0
  | 8 => 0
  | 9 => 0
  | _ => 0

public theorem XCell3_13_def : XCell3_13 = ![0, 0, 0, 0, 0, 0, 0, 0, 0, 0] := by
  funext i
  fin_cases i <;> rfl

public theorem XCell3_13_scaled :
    toVec #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0] = ((1 : ℤ) : ℚ) • XCell3_13 :=
  toVec_eq_smul10 #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0] 1 XCell3_13
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)

public def XCell3_14 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => 0
  | 1 => 0
  | 2 => 0
  | 3 => 0
  | 4 => 0
  | 5 => 0
  | 6 => 0
  | 7 => 0
  | 8 => 0
  | 9 => 0
  | _ => 0

public theorem XCell3_14_def : XCell3_14 = ![0, 0, 0, 0, 0, 0, 0, 0, 0, 0] := by
  funext i
  fin_cases i <;> rfl

public theorem XCell3_14_scaled :
    toVec #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0] = ((1 : ℤ) : ℚ) • XCell3_14 :=
  toVec_eq_smul10 #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0] 1 XCell3_14
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)

public def XCell3_15 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => 0
  | 1 => 0
  | 2 => 0
  | 3 => 0
  | 4 => 0
  | 5 => 0
  | 6 => 0
  | 7 => 0
  | 8 => 0
  | 9 => 0
  | _ => 0

public theorem XCell3_15_def : XCell3_15 = ![0, 0, 0, 0, 0, 0, 0, 0, 0, 0] := by
  funext i
  fin_cases i <;> rfl

public theorem XCell3_15_scaled :
    toVec #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0] = ((1 : ℤ) : ℚ) • XCell3_15 :=
  toVec_eq_smul10 #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0] 1 XCell3_15
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)

public def XCell3_16 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => 0
  | 1 => 0
  | 2 => 0
  | 3 => 0
  | 4 => 0
  | 5 => 0
  | 6 => 0
  | 7 => 0
  | 8 => 0
  | 9 => 0
  | _ => 0

public theorem XCell3_16_def : XCell3_16 = ![0, 0, 0, 0, 0, 0, 0, 0, 0, 0] := by
  funext i
  fin_cases i <;> rfl

public theorem XCell3_16_scaled :
    toVec #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0] = ((1 : ℤ) : ℚ) • XCell3_16 :=
  toVec_eq_smul10 #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0] 1 XCell3_16
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)

public def XCell3_17 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => 0
  | 1 => 0
  | 2 => 0
  | 3 => 0
  | 4 => 0
  | 5 => 0
  | 6 => 0
  | 7 => 0
  | 8 => 0
  | 9 => 0
  | _ => 0

public theorem XCell3_17_def : XCell3_17 = ![0, 0, 0, 0, 0, 0, 0, 0, 0, 0] := by
  funext i
  fin_cases i <;> rfl

public theorem XCell3_17_scaled :
    toVec #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0] = ((1 : ℤ) : ℚ) • XCell3_17 :=
  toVec_eq_smul10 #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0] 1 XCell3_17
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)

public def XCell3_18 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => 0
  | 1 => 0
  | 2 => 0
  | 3 => 0
  | 4 => 0
  | 5 => 0
  | 6 => 0
  | 7 => 0
  | 8 => 0
  | 9 => 0
  | _ => 0

public theorem XCell3_18_def : XCell3_18 = ![0, 0, 0, 0, 0, 0, 0, 0, 0, 0] := by
  funext i
  fin_cases i <;> rfl

public theorem XCell3_18_scaled :
    toVec #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0] = ((1 : ℤ) : ℚ) • XCell3_18 :=
  toVec_eq_smul10 #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0] 1 XCell3_18
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)

public def XCell3_19 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => 0
  | 1 => 0
  | 2 => 0
  | 3 => 0
  | 4 => 0
  | 5 => 0
  | 6 => 0
  | 7 => 0
  | 8 => 0
  | 9 => 0
  | _ => 0

public theorem XCell3_19_def : XCell3_19 = ![0, 0, 0, 0, 0, 0, 0, 0, 0, 0] := by
  funext i
  fin_cases i <;> rfl

public theorem XCell3_19_scaled :
    toVec #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0] = ((1 : ℤ) : ℚ) • XCell3_19 :=
  toVec_eq_smul10 #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0] 1 XCell3_19
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)

public def XRow3 (j : Fin 20) : Vec :=
  match j.val with
  | 0 => XCell3_0
  | 1 => XCell3_1
  | 2 => XCell3_2
  | 3 => XCell3_3
  | 4 => XCell3_4
  | 5 => XCell3_5
  | 6 => XCell3_6
  | 7 => XCell3_7
  | 8 => XCell3_8
  | 9 => XCell3_9
  | 10 => XCell3_10
  | 11 => XCell3_11
  | 12 => XCell3_12
  | 13 => XCell3_13
  | 14 => XCell3_14
  | 15 => XCell3_15
  | 16 => XCell3_16
  | 17 => XCell3_17
  | 18 => XCell3_18
  | 19 => XCell3_19
  | _ => 0

public def XCell4_0 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (-3 / 11 : ℚ)
  | 1 => (-17 / 22 : ℚ)
  | 2 => (-9 / 11 : ℚ)
  | 3 => (-4 / 11 : ℚ)
  | 4 => 0
  | 5 => (-7 / 22 : ℚ)
  | 6 => (-2 / 11 : ℚ)
  | 7 => (-5 / 11 : ℚ)
  | 8 => (-8 / 11 : ℚ)
  | 9 => (-13 / 22 : ℚ)
  | _ => 0

public theorem XCell4_0_def : XCell4_0 = ![(-3 / 11 : ℚ), (-17 / 22 : ℚ), (-9 / 11 : ℚ), (-4 / 11 : ℚ), 0, (-7 / 22 : ℚ), (-2 / 11 : ℚ), (-5 / 11 : ℚ), (-8 / 11 : ℚ), (-13 / 22 : ℚ)] := by
  funext i
  fin_cases i <;> rfl

public theorem XCell4_0_scaled :
    toVec #v[-6, -17, -18, -8, 0, -7, -4, -10, -16, -13] = ((22 : ℤ) : ℚ) • XCell4_0 :=
  toVec_eq_smul10 #v[-6, -17, -18, -8, 0, -7, -4, -10, -16, -13] 22 XCell4_0
    (eq_smul_div (-6) 22 (-3) (11) (by decide) (by decide))
    (eq_smul_div (-17) 22 (-17) (22) (by decide) (by decide))
    (eq_smul_div (-18) 22 (-9) (11) (by decide) (by decide))
    (eq_smul_div (-8) 22 (-4) (11) (by decide) (by decide))
    (eq_smul_zero 22)
    (eq_smul_div (-7) 22 (-7) (22) (by decide) (by decide))
    (eq_smul_div (-4) 22 (-2) (11) (by decide) (by decide))
    (eq_smul_div (-10) 22 (-5) (11) (by decide) (by decide))
    (eq_smul_div (-16) 22 (-8) (11) (by decide) (by decide))
    (eq_smul_div (-13) 22 (-13) (22) (by decide) (by decide))

public def XCell4_1 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (4 / 11 : ℚ)
  | 1 => (9 / 22 : ℚ)
  | 2 => (5 / 22 : ℚ)
  | 3 => (-1 / 22 : ℚ)
  | 4 => (2 / 11 : ℚ)
  | 5 => (5 / 22 : ℚ)
  | 6 => (1 / 22 : ℚ)
  | 7 => (1 / 22 : ℚ)
  | 8 => (1 / 11 : ℚ)
  | 9 => (-1 / 22 : ℚ)
  | _ => 0

public theorem XCell4_1_def : XCell4_1 = ![(4 / 11 : ℚ), (9 / 22 : ℚ), (5 / 22 : ℚ), (-1 / 22 : ℚ), (2 / 11 : ℚ), (5 / 22 : ℚ), (1 / 22 : ℚ), (1 / 22 : ℚ), (1 / 11 : ℚ), (-1 / 22 : ℚ)] := by
  funext i
  fin_cases i <;> rfl

public theorem XCell4_1_scaled :
    toVec #v[8, 9, 5, -1, 4, 5, 1, 1, 2, -1] = ((22 : ℤ) : ℚ) • XCell4_1 :=
  toVec_eq_smul10 #v[8, 9, 5, -1, 4, 5, 1, 1, 2, -1] 22 XCell4_1
    (eq_smul_div (8) 22 (4) (11) (by decide) (by decide))
    (eq_smul_div (9) 22 (9) (22) (by decide) (by decide))
    (eq_smul_div (5) 22 (5) (22) (by decide) (by decide))
    (eq_smul_div (-1) 22 (-1) (22) (by decide) (by decide))
    (eq_smul_div (4) 22 (2) (11) (by decide) (by decide))
    (eq_smul_div (5) 22 (5) (22) (by decide) (by decide))
    (eq_smul_div (1) 22 (1) (22) (by decide) (by decide))
    (eq_smul_div (1) 22 (1) (22) (by decide) (by decide))
    (eq_smul_div (2) 22 (1) (11) (by decide) (by decide))
    (eq_smul_div (-1) 22 (-1) (22) (by decide) (by decide))

public def XCell4_2 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (3 / 22 : ℚ)
  | 1 => (-1 / 22 : ℚ)
  | 2 => (-3 / 22 : ℚ)
  | 3 => (-1 / 22 : ℚ)
  | 4 => (1 / 11 : ℚ)
  | 5 => 0
  | 6 => (-1 / 11 : ℚ)
  | 7 => (-5 / 22 : ℚ)
  | 8 => (-4 / 11 : ℚ)
  | 9 => (-7 / 22 : ℚ)
  | _ => 0

public theorem XCell4_2_def : XCell4_2 = ![(3 / 22 : ℚ), (-1 / 22 : ℚ), (-3 / 22 : ℚ), (-1 / 22 : ℚ), (1 / 11 : ℚ), 0, (-1 / 11 : ℚ), (-5 / 22 : ℚ), (-4 / 11 : ℚ), (-7 / 22 : ℚ)] := by
  funext i
  fin_cases i <;> rfl

public theorem XCell4_2_scaled :
    toVec #v[3, -1, -3, -1, 2, 0, -2, -5, -8, -7] = ((22 : ℤ) : ℚ) • XCell4_2 :=
  toVec_eq_smul10 #v[3, -1, -3, -1, 2, 0, -2, -5, -8, -7] 22 XCell4_2
    (eq_smul_div (3) 22 (3) (22) (by decide) (by decide))
    (eq_smul_div (-1) 22 (-1) (22) (by decide) (by decide))
    (eq_smul_div (-3) 22 (-3) (22) (by decide) (by decide))
    (eq_smul_div (-1) 22 (-1) (22) (by decide) (by decide))
    (eq_smul_div (2) 22 (1) (11) (by decide) (by decide))
    (eq_smul_zero 22)
    (eq_smul_div (-2) 22 (-1) (11) (by decide) (by decide))
    (eq_smul_div (-5) 22 (-5) (22) (by decide) (by decide))
    (eq_smul_div (-8) 22 (-4) (11) (by decide) (by decide))
    (eq_smul_div (-7) 22 (-7) (22) (by decide) (by decide))

public def XCell4_3 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (-3 / 22 : ℚ)
  | 1 => (-7 / 22 : ℚ)
  | 2 => (-7 / 22 : ℚ)
  | 3 => (1 / 22 : ℚ)
  | 4 => (-1 / 22 : ℚ)
  | 5 => (-7 / 22 : ℚ)
  | 6 => (-3 / 22 : ℚ)
  | 7 => (1 / 11 : ℚ)
  | 8 => (-1 / 22 : ℚ)
  | 9 => (2 / 11 : ℚ)
  | _ => 0

public theorem XCell4_3_def : XCell4_3 = ![(-3 / 22 : ℚ), (-7 / 22 : ℚ), (-7 / 22 : ℚ), (1 / 22 : ℚ), (-1 / 22 : ℚ), (-7 / 22 : ℚ), (-3 / 22 : ℚ), (1 / 11 : ℚ), (-1 / 22 : ℚ), (2 / 11 : ℚ)] := by
  funext i
  fin_cases i <;> rfl

public theorem XCell4_3_scaled :
    toVec #v[-3, -7, -7, 1, -1, -7, -3, 2, -1, 4] = ((22 : ℤ) : ℚ) • XCell4_3 :=
  toVec_eq_smul10 #v[-3, -7, -7, 1, -1, -7, -3, 2, -1, 4] 22 XCell4_3
    (eq_smul_div (-3) 22 (-3) (22) (by decide) (by decide))
    (eq_smul_div (-7) 22 (-7) (22) (by decide) (by decide))
    (eq_smul_div (-7) 22 (-7) (22) (by decide) (by decide))
    (eq_smul_div (1) 22 (1) (22) (by decide) (by decide))
    (eq_smul_div (-1) 22 (-1) (22) (by decide) (by decide))
    (eq_smul_div (-7) 22 (-7) (22) (by decide) (by decide))
    (eq_smul_div (-3) 22 (-3) (22) (by decide) (by decide))
    (eq_smul_div (2) 22 (1) (11) (by decide) (by decide))
    (eq_smul_div (-1) 22 (-1) (22) (by decide) (by decide))
    (eq_smul_div (4) 22 (2) (11) (by decide) (by decide))

public def XCell4_4 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (-9 / 22 : ℚ)
  | 1 => (-5 / 22 : ℚ)
  | 2 => (-1 / 22 : ℚ)
  | 3 => (5 / 11 : ℚ)
  | 4 => 0
  | 5 => (-6 / 11 : ℚ)
  | 6 => (-3 / 11 : ℚ)
  | 7 => (7 / 22 : ℚ)
  | 8 => (-1 / 22 : ℚ)
  | 9 => (-5 / 22 : ℚ)
  | _ => 0

public theorem XCell4_4_def : XCell4_4 = ![(-9 / 22 : ℚ), (-5 / 22 : ℚ), (-1 / 22 : ℚ), (5 / 11 : ℚ), 0, (-6 / 11 : ℚ), (-3 / 11 : ℚ), (7 / 22 : ℚ), (-1 / 22 : ℚ), (-5 / 22 : ℚ)] := by
  funext i
  fin_cases i <;> rfl

public theorem XCell4_4_scaled :
    toVec #v[-9, -5, -1, 10, 0, -12, -6, 7, -1, -5] = ((22 : ℤ) : ℚ) • XCell4_4 :=
  toVec_eq_smul10 #v[-9, -5, -1, 10, 0, -12, -6, 7, -1, -5] 22 XCell4_4
    (eq_smul_div (-9) 22 (-9) (22) (by decide) (by decide))
    (eq_smul_div (-5) 22 (-5) (22) (by decide) (by decide))
    (eq_smul_div (-1) 22 (-1) (22) (by decide) (by decide))
    (eq_smul_div (10) 22 (5) (11) (by decide) (by decide))
    (eq_smul_zero 22)
    (eq_smul_div (-12) 22 (-6) (11) (by decide) (by decide))
    (eq_smul_div (-6) 22 (-3) (11) (by decide) (by decide))
    (eq_smul_div (7) 22 (7) (22) (by decide) (by decide))
    (eq_smul_div (-1) 22 (-1) (22) (by decide) (by decide))
    (eq_smul_div (-5) 22 (-5) (22) (by decide) (by decide))

public def XCell4_5 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (3 / 11 : ℚ)
  | 1 => (5 / 11 : ℚ)
  | 2 => (9 / 11 : ℚ)
  | 3 => (9 / 11 : ℚ)
  | 4 => (3 / 11 : ℚ)
  | 5 => 0
  | 6 => (5 / 11 : ℚ)
  | 7 => (10 / 11 : ℚ)
  | 8 => (8 / 11 : ℚ)
  | 9 => (3 / 11 : ℚ)
  | _ => 0

public theorem XCell4_5_def : XCell4_5 = ![(3 / 11 : ℚ), (5 / 11 : ℚ), (9 / 11 : ℚ), (9 / 11 : ℚ), (3 / 11 : ℚ), 0, (5 / 11 : ℚ), (10 / 11 : ℚ), (8 / 11 : ℚ), (3 / 11 : ℚ)] := by
  funext i
  fin_cases i <;> rfl

public theorem XCell4_5_scaled :
    toVec #v[3, 5, 9, 9, 3, 0, 5, 10, 8, 3] = ((11 : ℤ) : ℚ) • XCell4_5 :=
  toVec_eq_smul10 #v[3, 5, 9, 9, 3, 0, 5, 10, 8, 3] 11 XCell4_5
    (eq_smul_div (3) 11 (3) (11) (by decide) (by decide))
    (eq_smul_div (5) 11 (5) (11) (by decide) (by decide))
    (eq_smul_div (9) 11 (9) (11) (by decide) (by decide))
    (eq_smul_div (9) 11 (9) (11) (by decide) (by decide))
    (eq_smul_div (3) 11 (3) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_div (5) 11 (5) (11) (by decide) (by decide))
    (eq_smul_div (10) 11 (10) (11) (by decide) (by decide))
    (eq_smul_div (8) 11 (8) (11) (by decide) (by decide))
    (eq_smul_div (3) 11 (3) (11) (by decide) (by decide))

public def XCell4_6 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (2 / 11 : ℚ)
  | 1 => (2 / 11 : ℚ)
  | 2 => (-2 / 11 : ℚ)
  | 3 => (2 / 11 : ℚ)
  | 4 => (3 / 11 : ℚ)
  | 5 => (1 / 11 : ℚ)
  | 6 => 0
  | 7 => (2 / 11 : ℚ)
  | 8 => 0
  | 9 => (1 / 11 : ℚ)
  | _ => 0

public theorem XCell4_6_def : XCell4_6 = ![(2 / 11 : ℚ), (2 / 11 : ℚ), (-2 / 11 : ℚ), (2 / 11 : ℚ), (3 / 11 : ℚ), (1 / 11 : ℚ), 0, (2 / 11 : ℚ), 0, (1 / 11 : ℚ)] := by
  funext i
  fin_cases i <;> rfl

public theorem XCell4_6_scaled :
    toVec #v[2, 2, -2, 2, 3, 1, 0, 2, 0, 1] = ((11 : ℤ) : ℚ) • XCell4_6 :=
  toVec_eq_smul10 #v[2, 2, -2, 2, 3, 1, 0, 2, 0, 1] 11 XCell4_6
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_div (3) 11 (3) (11) (by decide) (by decide))
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))

public def XCell4_7 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (-2 / 11 : ℚ)
  | 1 => (1 / 11 : ℚ)
  | 2 => (-1 / 11 : ℚ)
  | 3 => (-2 / 11 : ℚ)
  | 4 => (2 / 11 : ℚ)
  | 5 => (5 / 11 : ℚ)
  | 6 => (-4 / 11 : ℚ)
  | 7 => (-9 / 11 : ℚ)
  | 8 => (-4 / 11 : ℚ)
  | 9 => (3 / 11 : ℚ)
  | _ => 0

public theorem XCell4_7_def : XCell4_7 = ![(-2 / 11 : ℚ), (1 / 11 : ℚ), (-1 / 11 : ℚ), (-2 / 11 : ℚ), (2 / 11 : ℚ), (5 / 11 : ℚ), (-4 / 11 : ℚ), (-9 / 11 : ℚ), (-4 / 11 : ℚ), (3 / 11 : ℚ)] := by
  funext i
  fin_cases i <;> rfl

public theorem XCell4_7_scaled :
    toVec #v[-2, 1, -1, -2, 2, 5, -4, -9, -4, 3] = ((11 : ℤ) : ℚ) • XCell4_7 :=
  toVec_eq_smul10 #v[-2, 1, -1, -2, 2, 5, -4, -9, -4, 3] 11 XCell4_7
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_div (5) 11 (5) (11) (by decide) (by decide))
    (eq_smul_div (-4) 11 (-4) (11) (by decide) (by decide))
    (eq_smul_div (-9) 11 (-9) (11) (by decide) (by decide))
    (eq_smul_div (-4) 11 (-4) (11) (by decide) (by decide))
    (eq_smul_div (3) 11 (3) (11) (by decide) (by decide))

public def XCell4_8 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => 0
  | 1 => 0
  | 2 => 0
  | 3 => 0
  | 4 => 0
  | 5 => 0
  | 6 => 0
  | 7 => 0
  | 8 => 0
  | 9 => 0
  | _ => 0

public theorem XCell4_8_def : XCell4_8 = ![0, 0, 0, 0, 0, 0, 0, 0, 0, 0] := by
  funext i
  fin_cases i <;> rfl

public theorem XCell4_8_scaled :
    toVec #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0] = ((1 : ℤ) : ℚ) • XCell4_8 :=
  toVec_eq_smul10 #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0] 1 XCell4_8
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)

public def XCell4_9 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => 0
  | 1 => 0
  | 2 => 0
  | 3 => 0
  | 4 => 0
  | 5 => 0
  | 6 => 0
  | 7 => 0
  | 8 => 0
  | 9 => 0
  | _ => 0

public theorem XCell4_9_def : XCell4_9 = ![0, 0, 0, 0, 0, 0, 0, 0, 0, 0] := by
  funext i
  fin_cases i <;> rfl

public theorem XCell4_9_scaled :
    toVec #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0] = ((1 : ℤ) : ℚ) • XCell4_9 :=
  toVec_eq_smul10 #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0] 1 XCell4_9
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)

public def XCell4_10 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => 0
  | 1 => 0
  | 2 => 0
  | 3 => (1 / 2 : ℚ)
  | 4 => (1 / 2 : ℚ)
  | 5 => 0
  | 6 => 0
  | 7 => (1 / 2 : ℚ)
  | 8 => (1 / 2 : ℚ)
  | 9 => 0
  | _ => 0

public theorem XCell4_10_def : XCell4_10 = ![0, 0, 0, (1 / 2 : ℚ), (1 / 2 : ℚ), 0, 0, (1 / 2 : ℚ), (1 / 2 : ℚ), 0] := by
  funext i
  fin_cases i <;> rfl

public theorem XCell4_10_scaled :
    toVec #v[0, 0, 0, 1, 1, 0, 0, 1, 1, 0] = ((2 : ℤ) : ℚ) • XCell4_10 :=
  toVec_eq_smul10 #v[0, 0, 0, 1, 1, 0, 0, 1, 1, 0] 2 XCell4_10
    (eq_smul_zero 2)
    (eq_smul_zero 2)
    (eq_smul_zero 2)
    (eq_smul_div (1) 2 (1) (2) (by decide) (by decide))
    (eq_smul_div (1) 2 (1) (2) (by decide) (by decide))
    (eq_smul_zero 2)
    (eq_smul_zero 2)
    (eq_smul_div (1) 2 (1) (2) (by decide) (by decide))
    (eq_smul_div (1) 2 (1) (2) (by decide) (by decide))
    (eq_smul_zero 2)

public def XCell4_11 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (1 / 2 : ℚ)
  | 1 => 0
  | 2 => (-1 / 2 : ℚ)
  | 3 => (-1 / 2 : ℚ)
  | 4 => 0
  | 5 => 0
  | 6 => 0
  | 7 => 0
  | 8 => (-1 / 2 : ℚ)
  | 9 => (-1 / 2 : ℚ)
  | _ => 0

public theorem XCell4_11_def : XCell4_11 = ![(1 / 2 : ℚ), 0, (-1 / 2 : ℚ), (-1 / 2 : ℚ), 0, 0, 0, 0, (-1 / 2 : ℚ), (-1 / 2 : ℚ)] := by
  funext i
  fin_cases i <;> rfl

public theorem XCell4_11_scaled :
    toVec #v[1, 0, -1, -1, 0, 0, 0, 0, -1, -1] = ((2 : ℤ) : ℚ) • XCell4_11 :=
  toVec_eq_smul10 #v[1, 0, -1, -1, 0, 0, 0, 0, -1, -1] 2 XCell4_11
    (eq_smul_div (1) 2 (1) (2) (by decide) (by decide))
    (eq_smul_zero 2)
    (eq_smul_div (-1) 2 (-1) (2) (by decide) (by decide))
    (eq_smul_div (-1) 2 (-1) (2) (by decide) (by decide))
    (eq_smul_zero 2)
    (eq_smul_zero 2)
    (eq_smul_zero 2)
    (eq_smul_zero 2)
    (eq_smul_div (-1) 2 (-1) (2) (by decide) (by decide))
    (eq_smul_div (-1) 2 (-1) (2) (by decide) (by decide))

public def XCell4_12 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => 0
  | 1 => 0
  | 2 => 0
  | 3 => 0
  | 4 => 0
  | 5 => 0
  | 6 => 0
  | 7 => 0
  | 8 => 0
  | 9 => 0
  | _ => 0

public theorem XCell4_12_def : XCell4_12 = ![0, 0, 0, 0, 0, 0, 0, 0, 0, 0] := by
  funext i
  fin_cases i <;> rfl

public theorem XCell4_12_scaled :
    toVec #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0] = ((1 : ℤ) : ℚ) • XCell4_12 :=
  toVec_eq_smul10 #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0] 1 XCell4_12
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)

public def XCell4_13 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => 0
  | 1 => 0
  | 2 => 0
  | 3 => 0
  | 4 => 0
  | 5 => 0
  | 6 => 0
  | 7 => 0
  | 8 => 0
  | 9 => 0
  | _ => 0

public theorem XCell4_13_def : XCell4_13 = ![0, 0, 0, 0, 0, 0, 0, 0, 0, 0] := by
  funext i
  fin_cases i <;> rfl

public theorem XCell4_13_scaled :
    toVec #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0] = ((1 : ℤ) : ℚ) • XCell4_13 :=
  toVec_eq_smul10 #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0] 1 XCell4_13
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)

public def XCell4_14 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => 0
  | 1 => 0
  | 2 => 0
  | 3 => 0
  | 4 => 0
  | 5 => 0
  | 6 => 0
  | 7 => 0
  | 8 => 0
  | 9 => 0
  | _ => 0

public theorem XCell4_14_def : XCell4_14 = ![0, 0, 0, 0, 0, 0, 0, 0, 0, 0] := by
  funext i
  fin_cases i <;> rfl

public theorem XCell4_14_scaled :
    toVec #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0] = ((1 : ℤ) : ℚ) • XCell4_14 :=
  toVec_eq_smul10 #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0] 1 XCell4_14
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)

public def XCell4_15 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => 0
  | 1 => 0
  | 2 => 0
  | 3 => 0
  | 4 => 0
  | 5 => 0
  | 6 => 0
  | 7 => 0
  | 8 => 0
  | 9 => 0
  | _ => 0

public theorem XCell4_15_def : XCell4_15 = ![0, 0, 0, 0, 0, 0, 0, 0, 0, 0] := by
  funext i
  fin_cases i <;> rfl

public theorem XCell4_15_scaled :
    toVec #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0] = ((1 : ℤ) : ℚ) • XCell4_15 :=
  toVec_eq_smul10 #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0] 1 XCell4_15
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)

public def XCell4_16 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => 0
  | 1 => 0
  | 2 => 0
  | 3 => 0
  | 4 => 0
  | 5 => 0
  | 6 => 0
  | 7 => 0
  | 8 => 0
  | 9 => 0
  | _ => 0

public theorem XCell4_16_def : XCell4_16 = ![0, 0, 0, 0, 0, 0, 0, 0, 0, 0] := by
  funext i
  fin_cases i <;> rfl

public theorem XCell4_16_scaled :
    toVec #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0] = ((1 : ℤ) : ℚ) • XCell4_16 :=
  toVec_eq_smul10 #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0] 1 XCell4_16
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)

public def XCell4_17 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => 0
  | 1 => 0
  | 2 => 0
  | 3 => 0
  | 4 => 0
  | 5 => 0
  | 6 => 0
  | 7 => 0
  | 8 => 0
  | 9 => 0
  | _ => 0

public theorem XCell4_17_def : XCell4_17 = ![0, 0, 0, 0, 0, 0, 0, 0, 0, 0] := by
  funext i
  fin_cases i <;> rfl

public theorem XCell4_17_scaled :
    toVec #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0] = ((1 : ℤ) : ℚ) • XCell4_17 :=
  toVec_eq_smul10 #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0] 1 XCell4_17
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)

public def XCell4_18 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => 0
  | 1 => 0
  | 2 => 0
  | 3 => 0
  | 4 => 0
  | 5 => 0
  | 6 => 0
  | 7 => 0
  | 8 => 0
  | 9 => 0
  | _ => 0

public theorem XCell4_18_def : XCell4_18 = ![0, 0, 0, 0, 0, 0, 0, 0, 0, 0] := by
  funext i
  fin_cases i <;> rfl

public theorem XCell4_18_scaled :
    toVec #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0] = ((1 : ℤ) : ℚ) • XCell4_18 :=
  toVec_eq_smul10 #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0] 1 XCell4_18
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)

public def XCell4_19 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => 0
  | 1 => 0
  | 2 => 0
  | 3 => 0
  | 4 => 0
  | 5 => 0
  | 6 => 0
  | 7 => 0
  | 8 => 0
  | 9 => 0
  | _ => 0

public theorem XCell4_19_def : XCell4_19 = ![0, 0, 0, 0, 0, 0, 0, 0, 0, 0] := by
  funext i
  fin_cases i <;> rfl

public theorem XCell4_19_scaled :
    toVec #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0] = ((1 : ℤ) : ℚ) • XCell4_19 :=
  toVec_eq_smul10 #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0] 1 XCell4_19
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)

public def XRow4 (j : Fin 20) : Vec :=
  match j.val with
  | 0 => XCell4_0
  | 1 => XCell4_1
  | 2 => XCell4_2
  | 3 => XCell4_3
  | 4 => XCell4_4
  | 5 => XCell4_5
  | 6 => XCell4_6
  | 7 => XCell4_7
  | 8 => XCell4_8
  | 9 => XCell4_9
  | 10 => XCell4_10
  | 11 => XCell4_11
  | 12 => XCell4_12
  | 13 => XCell4_13
  | 14 => XCell4_14
  | 15 => XCell4_15
  | 16 => XCell4_16
  | 17 => XCell4_17
  | 18 => XCell4_18
  | 19 => XCell4_19
  | _ => 0

public def XCell5_0 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (-1 / 2 : ℚ)
  | 1 => (-2 / 11 : ℚ)
  | 2 => (-23 / 44 : ℚ)
  | 3 => (-8 / 11 : ℚ)
  | 4 => (-5 / 44 : ℚ)
  | 5 => (-1 / 22 : ℚ)
  | 6 => (-27 / 44 : ℚ)
  | 7 => (-23 / 44 : ℚ)
  | 8 => (-7 / 11 : ℚ)
  | 9 => (-3 / 22 : ℚ)
  | _ => 0

public theorem XCell5_0_def : XCell5_0 = ![(-1 / 2 : ℚ), (-2 / 11 : ℚ), (-23 / 44 : ℚ), (-8 / 11 : ℚ), (-5 / 44 : ℚ), (-1 / 22 : ℚ), (-27 / 44 : ℚ), (-23 / 44 : ℚ), (-7 / 11 : ℚ), (-3 / 22 : ℚ)] := by
  funext i
  fin_cases i <;> rfl

public theorem XCell5_0_scaled :
    toVec #v[-22, -8, -23, -32, -5, -2, -27, -23, -28, -6] = ((44 : ℤ) : ℚ) • XCell5_0 :=
  toVec_eq_smul10 #v[-22, -8, -23, -32, -5, -2, -27, -23, -28, -6] 44 XCell5_0
    (eq_smul_div (-22) 44 (-1) (2) (by decide) (by decide))
    (eq_smul_div (-8) 44 (-2) (11) (by decide) (by decide))
    (eq_smul_div (-23) 44 (-23) (44) (by decide) (by decide))
    (eq_smul_div (-32) 44 (-8) (11) (by decide) (by decide))
    (eq_smul_div (-5) 44 (-5) (44) (by decide) (by decide))
    (eq_smul_div (-2) 44 (-1) (22) (by decide) (by decide))
    (eq_smul_div (-27) 44 (-27) (44) (by decide) (by decide))
    (eq_smul_div (-23) 44 (-23) (44) (by decide) (by decide))
    (eq_smul_div (-28) 44 (-7) (11) (by decide) (by decide))
    (eq_smul_div (-6) 44 (-3) (22) (by decide) (by decide))

public def XCell5_1 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => 0
  | 1 => (-5 / 44 : ℚ)
  | 2 => (-1 / 11 : ℚ)
  | 3 => 0
  | 4 => (-3 / 11 : ℚ)
  | 5 => (1 / 11 : ℚ)
  | 6 => (3 / 22 : ℚ)
  | 7 => (-3 / 22 : ℚ)
  | 8 => (-1 / 11 : ℚ)
  | 9 => (-1 / 44 : ℚ)
  | _ => 0

public theorem XCell5_1_def : XCell5_1 = ![0, (-5 / 44 : ℚ), (-1 / 11 : ℚ), 0, (-3 / 11 : ℚ), (1 / 11 : ℚ), (3 / 22 : ℚ), (-3 / 22 : ℚ), (-1 / 11 : ℚ), (-1 / 44 : ℚ)] := by
  funext i
  fin_cases i <;> rfl

public theorem XCell5_1_scaled :
    toVec #v[0, -5, -4, 0, -12, 4, 6, -6, -4, -1] = ((44 : ℤ) : ℚ) • XCell5_1 :=
  toVec_eq_smul10 #v[0, -5, -4, 0, -12, 4, 6, -6, -4, -1] 44 XCell5_1
    (eq_smul_zero 44)
    (eq_smul_div (-5) 44 (-5) (44) (by decide) (by decide))
    (eq_smul_div (-4) 44 (-1) (11) (by decide) (by decide))
    (eq_smul_zero 44)
    (eq_smul_div (-12) 44 (-3) (11) (by decide) (by decide))
    (eq_smul_div (4) 44 (1) (11) (by decide) (by decide))
    (eq_smul_div (6) 44 (3) (22) (by decide) (by decide))
    (eq_smul_div (-6) 44 (-3) (22) (by decide) (by decide))
    (eq_smul_div (-4) 44 (-1) (11) (by decide) (by decide))
    (eq_smul_div (-1) 44 (-1) (44) (by decide) (by decide))

public def XCell5_2 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (-3 / 44 : ℚ)
  | 1 => (-3 / 44 : ℚ)
  | 2 => (-3 / 22 : ℚ)
  | 3 => (-7 / 22 : ℚ)
  | 4 => (3 / 22 : ℚ)
  | 5 => (3 / 22 : ℚ)
  | 6 => (-1 / 44 : ℚ)
  | 7 => (-4 / 11 : ℚ)
  | 8 => (-7 / 44 : ℚ)
  | 9 => (5 / 44 : ℚ)
  | _ => 0

public theorem XCell5_2_def : XCell5_2 = ![(-3 / 44 : ℚ), (-3 / 44 : ℚ), (-3 / 22 : ℚ), (-7 / 22 : ℚ), (3 / 22 : ℚ), (3 / 22 : ℚ), (-1 / 44 : ℚ), (-4 / 11 : ℚ), (-7 / 44 : ℚ), (5 / 44 : ℚ)] := by
  funext i
  fin_cases i <;> rfl

public theorem XCell5_2_scaled :
    toVec #v[-3, -3, -6, -14, 6, 6, -1, -16, -7, 5] = ((44 : ℤ) : ℚ) • XCell5_2 :=
  toVec_eq_smul10 #v[-3, -3, -6, -14, 6, 6, -1, -16, -7, 5] 44 XCell5_2
    (eq_smul_div (-3) 44 (-3) (44) (by decide) (by decide))
    (eq_smul_div (-3) 44 (-3) (44) (by decide) (by decide))
    (eq_smul_div (-6) 44 (-3) (22) (by decide) (by decide))
    (eq_smul_div (-14) 44 (-7) (22) (by decide) (by decide))
    (eq_smul_div (6) 44 (3) (22) (by decide) (by decide))
    (eq_smul_div (6) 44 (3) (22) (by decide) (by decide))
    (eq_smul_div (-1) 44 (-1) (44) (by decide) (by decide))
    (eq_smul_div (-16) 44 (-4) (11) (by decide) (by decide))
    (eq_smul_div (-7) 44 (-7) (44) (by decide) (by decide))
    (eq_smul_div (5) 44 (5) (44) (by decide) (by decide))

public def XCell5_3 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (-21 / 44 : ℚ)
  | 1 => (-9 / 44 : ℚ)
  | 2 => (3 / 44 : ℚ)
  | 3 => (-7 / 44 : ℚ)
  | 4 => (-7 / 44 : ℚ)
  | 5 => (-3 / 44 : ℚ)
  | 6 => (-19 / 44 : ℚ)
  | 7 => (-1 / 11 : ℚ)
  | 8 => (-13 / 44 : ℚ)
  | 9 => (-2 / 11 : ℚ)
  | _ => 0

public theorem XCell5_3_def : XCell5_3 = ![(-21 / 44 : ℚ), (-9 / 44 : ℚ), (3 / 44 : ℚ), (-7 / 44 : ℚ), (-7 / 44 : ℚ), (-3 / 44 : ℚ), (-19 / 44 : ℚ), (-1 / 11 : ℚ), (-13 / 44 : ℚ), (-2 / 11 : ℚ)] := by
  funext i
  fin_cases i <;> rfl

public theorem XCell5_3_scaled :
    toVec #v[-21, -9, 3, -7, -7, -3, -19, -4, -13, -8] = ((44 : ℤ) : ℚ) • XCell5_3 :=
  toVec_eq_smul10 #v[-21, -9, 3, -7, -7, -3, -19, -4, -13, -8] 44 XCell5_3
    (eq_smul_div (-21) 44 (-21) (44) (by decide) (by decide))
    (eq_smul_div (-9) 44 (-9) (44) (by decide) (by decide))
    (eq_smul_div (3) 44 (3) (44) (by decide) (by decide))
    (eq_smul_div (-7) 44 (-7) (44) (by decide) (by decide))
    (eq_smul_div (-7) 44 (-7) (44) (by decide) (by decide))
    (eq_smul_div (-3) 44 (-3) (44) (by decide) (by decide))
    (eq_smul_div (-19) 44 (-19) (44) (by decide) (by decide))
    (eq_smul_div (-4) 44 (-1) (11) (by decide) (by decide))
    (eq_smul_div (-13) 44 (-13) (44) (by decide) (by decide))
    (eq_smul_div (-8) 44 (-2) (11) (by decide) (by decide))

public def XCell5_4 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (-1 / 22 : ℚ)
  | 1 => (13 / 22 : ℚ)
  | 2 => (13 / 22 : ℚ)
  | 3 => (3 / 22 : ℚ)
  | 4 => (13 / 44 : ℚ)
  | 5 => (23 / 44 : ℚ)
  | 6 => (7 / 22 : ℚ)
  | 7 => (1 / 11 : ℚ)
  | 8 => (23 / 44 : ℚ)
  | 9 => (8 / 11 : ℚ)
  | _ => 0

public theorem XCell5_4_def : XCell5_4 = ![(-1 / 22 : ℚ), (13 / 22 : ℚ), (13 / 22 : ℚ), (3 / 22 : ℚ), (13 / 44 : ℚ), (23 / 44 : ℚ), (7 / 22 : ℚ), (1 / 11 : ℚ), (23 / 44 : ℚ), (8 / 11 : ℚ)] := by
  funext i
  fin_cases i <;> rfl

public theorem XCell5_4_scaled :
    toVec #v[-2, 26, 26, 6, 13, 23, 14, 4, 23, 32] = ((44 : ℤ) : ℚ) • XCell5_4 :=
  toVec_eq_smul10 #v[-2, 26, 26, 6, 13, 23, 14, 4, 23, 32] 44 XCell5_4
    (eq_smul_div (-2) 44 (-1) (22) (by decide) (by decide))
    (eq_smul_div (26) 44 (13) (22) (by decide) (by decide))
    (eq_smul_div (26) 44 (13) (22) (by decide) (by decide))
    (eq_smul_div (6) 44 (3) (22) (by decide) (by decide))
    (eq_smul_div (13) 44 (13) (44) (by decide) (by decide))
    (eq_smul_div (23) 44 (23) (44) (by decide) (by decide))
    (eq_smul_div (14) 44 (7) (22) (by decide) (by decide))
    (eq_smul_div (4) 44 (1) (11) (by decide) (by decide))
    (eq_smul_div (23) 44 (23) (44) (by decide) (by decide))
    (eq_smul_div (32) 44 (8) (11) (by decide) (by decide))

public def XCell5_5 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (-5 / 22 : ℚ)
  | 1 => (17 / 22 : ℚ)
  | 2 => (15 / 22 : ℚ)
  | 3 => (7 / 11 : ℚ)
  | 4 => (-1 / 22 : ℚ)
  | 5 => (7 / 22 : ℚ)
  | 6 => (4 / 11 : ℚ)
  | 7 => (7 / 11 : ℚ)
  | 8 => (19 / 22 : ℚ)
  | 9 => (1 / 2 : ℚ)
  | _ => 0

public theorem XCell5_5_def : XCell5_5 = ![(-5 / 22 : ℚ), (17 / 22 : ℚ), (15 / 22 : ℚ), (7 / 11 : ℚ), (-1 / 22 : ℚ), (7 / 22 : ℚ), (4 / 11 : ℚ), (7 / 11 : ℚ), (19 / 22 : ℚ), (1 / 2 : ℚ)] := by
  funext i
  fin_cases i <;> rfl

public theorem XCell5_5_scaled :
    toVec #v[-5, 17, 15, 14, -1, 7, 8, 14, 19, 11] = ((22 : ℤ) : ℚ) • XCell5_5 :=
  toVec_eq_smul10 #v[-5, 17, 15, 14, -1, 7, 8, 14, 19, 11] 22 XCell5_5
    (eq_smul_div (-5) 22 (-5) (22) (by decide) (by decide))
    (eq_smul_div (17) 22 (17) (22) (by decide) (by decide))
    (eq_smul_div (15) 22 (15) (22) (by decide) (by decide))
    (eq_smul_div (14) 22 (7) (11) (by decide) (by decide))
    (eq_smul_div (-1) 22 (-1) (22) (by decide) (by decide))
    (eq_smul_div (7) 22 (7) (22) (by decide) (by decide))
    (eq_smul_div (8) 22 (4) (11) (by decide) (by decide))
    (eq_smul_div (14) 22 (7) (11) (by decide) (by decide))
    (eq_smul_div (19) 22 (19) (22) (by decide) (by decide))
    (eq_smul_div (11) 22 (1) (2) (by decide) (by decide))

public def XCell5_6 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (-6 / 11 : ℚ)
  | 1 => (-3 / 11 : ℚ)
  | 2 => (-1 / 22 : ℚ)
  | 3 => (-8 / 11 : ℚ)
  | 4 => (-3 / 22 : ℚ)
  | 5 => (-1 / 11 : ℚ)
  | 6 => (-4 / 11 : ℚ)
  | 7 => (-4 / 11 : ℚ)
  | 8 => (-4 / 11 : ℚ)
  | 9 => (-1 / 11 : ℚ)
  | _ => 0

public theorem XCell5_6_def : XCell5_6 = ![(-6 / 11 : ℚ), (-3 / 11 : ℚ), (-1 / 22 : ℚ), (-8 / 11 : ℚ), (-3 / 22 : ℚ), (-1 / 11 : ℚ), (-4 / 11 : ℚ), (-4 / 11 : ℚ), (-4 / 11 : ℚ), (-1 / 11 : ℚ)] := by
  funext i
  fin_cases i <;> rfl

public theorem XCell5_6_scaled :
    toVec #v[-12, -6, -1, -16, -3, -2, -8, -8, -8, -2] = ((22 : ℤ) : ℚ) • XCell5_6 :=
  toVec_eq_smul10 #v[-12, -6, -1, -16, -3, -2, -8, -8, -8, -2] 22 XCell5_6
    (eq_smul_div (-12) 22 (-6) (11) (by decide) (by decide))
    (eq_smul_div (-6) 22 (-3) (11) (by decide) (by decide))
    (eq_smul_div (-1) 22 (-1) (22) (by decide) (by decide))
    (eq_smul_div (-16) 22 (-8) (11) (by decide) (by decide))
    (eq_smul_div (-3) 22 (-3) (22) (by decide) (by decide))
    (eq_smul_div (-2) 22 (-1) (11) (by decide) (by decide))
    (eq_smul_div (-8) 22 (-4) (11) (by decide) (by decide))
    (eq_smul_div (-8) 22 (-4) (11) (by decide) (by decide))
    (eq_smul_div (-8) 22 (-4) (11) (by decide) (by decide))
    (eq_smul_div (-2) 22 (-1) (11) (by decide) (by decide))

public def XCell5_7 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (-3 / 11 : ℚ)
  | 1 => (-9 / 11 : ℚ)
  | 2 => (-21 / 22 : ℚ)
  | 3 => (-1 / 11 : ℚ)
  | 4 => (-1 / 11 : ℚ)
  | 5 => (-13 / 22 : ℚ)
  | 6 => (-6 / 11 : ℚ)
  | 7 => (-3 / 11 : ℚ)
  | 8 => (-17 / 22 : ℚ)
  | 9 => (-13 / 22 : ℚ)
  | _ => 0

public theorem XCell5_7_def : XCell5_7 = ![(-3 / 11 : ℚ), (-9 / 11 : ℚ), (-21 / 22 : ℚ), (-1 / 11 : ℚ), (-1 / 11 : ℚ), (-13 / 22 : ℚ), (-6 / 11 : ℚ), (-3 / 11 : ℚ), (-17 / 22 : ℚ), (-13 / 22 : ℚ)] := by
  funext i
  fin_cases i <;> rfl

public theorem XCell5_7_scaled :
    toVec #v[-6, -18, -21, -2, -2, -13, -12, -6, -17, -13] = ((22 : ℤ) : ℚ) • XCell5_7 :=
  toVec_eq_smul10 #v[-6, -18, -21, -2, -2, -13, -12, -6, -17, -13] 22 XCell5_7
    (eq_smul_div (-6) 22 (-3) (11) (by decide) (by decide))
    (eq_smul_div (-18) 22 (-9) (11) (by decide) (by decide))
    (eq_smul_div (-21) 22 (-21) (22) (by decide) (by decide))
    (eq_smul_div (-2) 22 (-1) (11) (by decide) (by decide))
    (eq_smul_div (-2) 22 (-1) (11) (by decide) (by decide))
    (eq_smul_div (-13) 22 (-13) (22) (by decide) (by decide))
    (eq_smul_div (-12) 22 (-6) (11) (by decide) (by decide))
    (eq_smul_div (-6) 22 (-3) (11) (by decide) (by decide))
    (eq_smul_div (-17) 22 (-17) (22) (by decide) (by decide))
    (eq_smul_div (-13) 22 (-13) (22) (by decide) (by decide))

public def XCell5_8 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => 0
  | 1 => 0
  | 2 => 0
  | 3 => 0
  | 4 => 0
  | 5 => 0
  | 6 => 0
  | 7 => 0
  | 8 => 0
  | 9 => 0
  | _ => 0

public theorem XCell5_8_def : XCell5_8 = ![0, 0, 0, 0, 0, 0, 0, 0, 0, 0] := by
  funext i
  fin_cases i <;> rfl

public theorem XCell5_8_scaled :
    toVec #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0] = ((1 : ℤ) : ℚ) • XCell5_8 :=
  toVec_eq_smul10 #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0] 1 XCell5_8
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)

public def XCell5_9 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => 0
  | 1 => 0
  | 2 => 0
  | 3 => 0
  | 4 => 0
  | 5 => 0
  | 6 => 0
  | 7 => 0
  | 8 => 0
  | 9 => 0
  | _ => 0

public theorem XCell5_9_def : XCell5_9 = ![0, 0, 0, 0, 0, 0, 0, 0, 0, 0] := by
  funext i
  fin_cases i <;> rfl

public theorem XCell5_9_scaled :
    toVec #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0] = ((1 : ℤ) : ℚ) • XCell5_9 :=
  toVec_eq_smul10 #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0] 1 XCell5_9
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)

public def XCell5_10 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (-1 / 4 : ℚ)
  | 1 => 0
  | 2 => (1 / 4 : ℚ)
  | 3 => 0
  | 4 => 0
  | 5 => (-1 / 4 : ℚ)
  | 6 => (-1 / 4 : ℚ)
  | 7 => 0
  | 8 => 0
  | 9 => (1 / 4 : ℚ)
  | _ => 0

public theorem XCell5_10_def : XCell5_10 = ![(-1 / 4 : ℚ), 0, (1 / 4 : ℚ), 0, 0, (-1 / 4 : ℚ), (-1 / 4 : ℚ), 0, 0, (1 / 4 : ℚ)] := by
  funext i
  fin_cases i <;> rfl

public theorem XCell5_10_scaled :
    toVec #v[-1, 0, 1, 0, 0, -1, -1, 0, 0, 1] = ((4 : ℤ) : ℚ) • XCell5_10 :=
  toVec_eq_smul10 #v[-1, 0, 1, 0, 0, -1, -1, 0, 0, 1] 4 XCell5_10
    (eq_smul_div (-1) 4 (-1) (4) (by decide) (by decide))
    (eq_smul_zero 4)
    (eq_smul_div (1) 4 (1) (4) (by decide) (by decide))
    (eq_smul_zero 4)
    (eq_smul_zero 4)
    (eq_smul_div (-1) 4 (-1) (4) (by decide) (by decide))
    (eq_smul_div (-1) 4 (-1) (4) (by decide) (by decide))
    (eq_smul_zero 4)
    (eq_smul_zero 4)
    (eq_smul_div (1) 4 (1) (4) (by decide) (by decide))

public def XCell5_11 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => 0
  | 1 => 0
  | 2 => 0
  | 3 => (-1 / 2 : ℚ)
  | 4 => (-1 / 4 : ℚ)
  | 5 => (1 / 4 : ℚ)
  | 6 => (1 / 4 : ℚ)
  | 7 => (-1 / 4 : ℚ)
  | 8 => (-1 / 2 : ℚ)
  | 9 => 0
  | _ => 0

public theorem XCell5_11_def : XCell5_11 = ![0, 0, 0, (-1 / 2 : ℚ), (-1 / 4 : ℚ), (1 / 4 : ℚ), (1 / 4 : ℚ), (-1 / 4 : ℚ), (-1 / 2 : ℚ), 0] := by
  funext i
  fin_cases i <;> rfl

public theorem XCell5_11_scaled :
    toVec #v[0, 0, 0, -2, -1, 1, 1, -1, -2, 0] = ((4 : ℤ) : ℚ) • XCell5_11 :=
  toVec_eq_smul10 #v[0, 0, 0, -2, -1, 1, 1, -1, -2, 0] 4 XCell5_11
    (eq_smul_zero 4)
    (eq_smul_zero 4)
    (eq_smul_zero 4)
    (eq_smul_div (-2) 4 (-1) (2) (by decide) (by decide))
    (eq_smul_div (-1) 4 (-1) (4) (by decide) (by decide))
    (eq_smul_div (1) 4 (1) (4) (by decide) (by decide))
    (eq_smul_div (1) 4 (1) (4) (by decide) (by decide))
    (eq_smul_div (-1) 4 (-1) (4) (by decide) (by decide))
    (eq_smul_div (-2) 4 (-1) (2) (by decide) (by decide))
    (eq_smul_zero 4)

public def XCell5_12 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => 0
  | 1 => 0
  | 2 => 0
  | 3 => 0
  | 4 => 0
  | 5 => 0
  | 6 => 0
  | 7 => 0
  | 8 => 0
  | 9 => 0
  | _ => 0

public theorem XCell5_12_def : XCell5_12 = ![0, 0, 0, 0, 0, 0, 0, 0, 0, 0] := by
  funext i
  fin_cases i <;> rfl

public theorem XCell5_12_scaled :
    toVec #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0] = ((1 : ℤ) : ℚ) • XCell5_12 :=
  toVec_eq_smul10 #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0] 1 XCell5_12
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)

public def XCell5_13 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => 0
  | 1 => 0
  | 2 => 0
  | 3 => 0
  | 4 => 0
  | 5 => 0
  | 6 => 0
  | 7 => 0
  | 8 => 0
  | 9 => 0
  | _ => 0

public theorem XCell5_13_def : XCell5_13 = ![0, 0, 0, 0, 0, 0, 0, 0, 0, 0] := by
  funext i
  fin_cases i <;> rfl

public theorem XCell5_13_scaled :
    toVec #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0] = ((1 : ℤ) : ℚ) • XCell5_13 :=
  toVec_eq_smul10 #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0] 1 XCell5_13
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)

public def XCell5_14 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => 0
  | 1 => 0
  | 2 => 0
  | 3 => 0
  | 4 => 0
  | 5 => 0
  | 6 => 0
  | 7 => 0
  | 8 => 0
  | 9 => 0
  | _ => 0

public theorem XCell5_14_def : XCell5_14 = ![0, 0, 0, 0, 0, 0, 0, 0, 0, 0] := by
  funext i
  fin_cases i <;> rfl

public theorem XCell5_14_scaled :
    toVec #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0] = ((1 : ℤ) : ℚ) • XCell5_14 :=
  toVec_eq_smul10 #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0] 1 XCell5_14
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)

public def XCell5_15 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => 0
  | 1 => 0
  | 2 => 0
  | 3 => 0
  | 4 => 0
  | 5 => 0
  | 6 => 0
  | 7 => 0
  | 8 => 0
  | 9 => 0
  | _ => 0

public theorem XCell5_15_def : XCell5_15 = ![0, 0, 0, 0, 0, 0, 0, 0, 0, 0] := by
  funext i
  fin_cases i <;> rfl

public theorem XCell5_15_scaled :
    toVec #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0] = ((1 : ℤ) : ℚ) • XCell5_15 :=
  toVec_eq_smul10 #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0] 1 XCell5_15
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)

public def XCell5_16 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => 0
  | 1 => 0
  | 2 => 0
  | 3 => 0
  | 4 => 0
  | 5 => 0
  | 6 => 0
  | 7 => 0
  | 8 => 0
  | 9 => 0
  | _ => 0

public theorem XCell5_16_def : XCell5_16 = ![0, 0, 0, 0, 0, 0, 0, 0, 0, 0] := by
  funext i
  fin_cases i <;> rfl

public theorem XCell5_16_scaled :
    toVec #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0] = ((1 : ℤ) : ℚ) • XCell5_16 :=
  toVec_eq_smul10 #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0] 1 XCell5_16
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)

public def XCell5_17 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => 0
  | 1 => 0
  | 2 => 0
  | 3 => 0
  | 4 => 0
  | 5 => 0
  | 6 => 0
  | 7 => 0
  | 8 => 0
  | 9 => 0
  | _ => 0

public theorem XCell5_17_def : XCell5_17 = ![0, 0, 0, 0, 0, 0, 0, 0, 0, 0] := by
  funext i
  fin_cases i <;> rfl

public theorem XCell5_17_scaled :
    toVec #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0] = ((1 : ℤ) : ℚ) • XCell5_17 :=
  toVec_eq_smul10 #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0] 1 XCell5_17
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)

public def XCell5_18 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => 0
  | 1 => 0
  | 2 => 0
  | 3 => 0
  | 4 => 0
  | 5 => 0
  | 6 => 0
  | 7 => 0
  | 8 => 0
  | 9 => 0
  | _ => 0

public theorem XCell5_18_def : XCell5_18 = ![0, 0, 0, 0, 0, 0, 0, 0, 0, 0] := by
  funext i
  fin_cases i <;> rfl

public theorem XCell5_18_scaled :
    toVec #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0] = ((1 : ℤ) : ℚ) • XCell5_18 :=
  toVec_eq_smul10 #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0] 1 XCell5_18
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)

public def XCell5_19 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => 0
  | 1 => 0
  | 2 => 0
  | 3 => 0
  | 4 => 0
  | 5 => 0
  | 6 => 0
  | 7 => 0
  | 8 => 0
  | 9 => 0
  | _ => 0

public theorem XCell5_19_def : XCell5_19 = ![0, 0, 0, 0, 0, 0, 0, 0, 0, 0] := by
  funext i
  fin_cases i <;> rfl

public theorem XCell5_19_scaled :
    toVec #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0] = ((1 : ℤ) : ℚ) • XCell5_19 :=
  toVec_eq_smul10 #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0] 1 XCell5_19
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)

public def XRow5 (j : Fin 20) : Vec :=
  match j.val with
  | 0 => XCell5_0
  | 1 => XCell5_1
  | 2 => XCell5_2
  | 3 => XCell5_3
  | 4 => XCell5_4
  | 5 => XCell5_5
  | 6 => XCell5_6
  | 7 => XCell5_7
  | 8 => XCell5_8
  | 9 => XCell5_9
  | 10 => XCell5_10
  | 11 => XCell5_11
  | 12 => XCell5_12
  | 13 => XCell5_13
  | 14 => XCell5_14
  | 15 => XCell5_15
  | 16 => XCell5_16
  | 17 => XCell5_17
  | 18 => XCell5_18
  | 19 => XCell5_19
  | _ => 0

public def XCell6_0 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (-5 / 44 : ℚ)
  | 1 => (-47 / 44 : ℚ)
  | 2 => (-7 / 22 : ℚ)
  | 3 => (-5 / 11 : ℚ)
  | 4 => (-12 / 11 : ℚ)
  | 5 => (-1 / 2 : ℚ)
  | 6 => (-43 / 44 : ℚ)
  | 7 => (-9 / 22 : ℚ)
  | 8 => (-23 / 44 : ℚ)
  | 9 => (-23 / 22 : ℚ)
  | _ => 0

public theorem XCell6_0_def : XCell6_0 = ![(-5 / 44 : ℚ), (-47 / 44 : ℚ), (-7 / 22 : ℚ), (-5 / 11 : ℚ), (-12 / 11 : ℚ), (-1 / 2 : ℚ), (-43 / 44 : ℚ), (-9 / 22 : ℚ), (-23 / 44 : ℚ), (-23 / 22 : ℚ)] := by
  funext i
  fin_cases i <;> rfl

public theorem XCell6_0_scaled :
    toVec #v[-5, -47, -14, -20, -48, -22, -43, -18, -23, -46] = ((44 : ℤ) : ℚ) • XCell6_0 :=
  toVec_eq_smul10 #v[-5, -47, -14, -20, -48, -22, -43, -18, -23, -46] 44 XCell6_0
    (eq_smul_div (-5) 44 (-5) (44) (by decide) (by decide))
    (eq_smul_div (-47) 44 (-47) (44) (by decide) (by decide))
    (eq_smul_div (-14) 44 (-7) (22) (by decide) (by decide))
    (eq_smul_div (-20) 44 (-5) (11) (by decide) (by decide))
    (eq_smul_div (-48) 44 (-12) (11) (by decide) (by decide))
    (eq_smul_div (-22) 44 (-1) (2) (by decide) (by decide))
    (eq_smul_div (-43) 44 (-43) (44) (by decide) (by decide))
    (eq_smul_div (-18) 44 (-9) (22) (by decide) (by decide))
    (eq_smul_div (-23) 44 (-23) (44) (by decide) (by decide))
    (eq_smul_div (-46) 44 (-23) (22) (by decide) (by decide))

public def XCell6_1 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (13 / 44 : ℚ)
  | 1 => (31 / 44 : ℚ)
  | 2 => (-2 / 11 : ℚ)
  | 3 => (5 / 11 : ℚ)
  | 4 => (13 / 22 : ℚ)
  | 5 => (9 / 44 : ℚ)
  | 6 => (7 / 11 : ℚ)
  | 7 => (13 / 22 : ℚ)
  | 8 => (3 / 22 : ℚ)
  | 9 => (9 / 11 : ℚ)
  | _ => 0

public theorem XCell6_1_def : XCell6_1 = ![(13 / 44 : ℚ), (31 / 44 : ℚ), (-2 / 11 : ℚ), (5 / 11 : ℚ), (13 / 22 : ℚ), (9 / 44 : ℚ), (7 / 11 : ℚ), (13 / 22 : ℚ), (3 / 22 : ℚ), (9 / 11 : ℚ)] := by
  funext i
  fin_cases i <;> rfl

public theorem XCell6_1_scaled :
    toVec #v[13, 31, -8, 20, 26, 9, 28, 26, 6, 36] = ((44 : ℤ) : ℚ) • XCell6_1 :=
  toVec_eq_smul10 #v[13, 31, -8, 20, 26, 9, 28, 26, 6, 36] 44 XCell6_1
    (eq_smul_div (13) 44 (13) (44) (by decide) (by decide))
    (eq_smul_div (31) 44 (31) (44) (by decide) (by decide))
    (eq_smul_div (-8) 44 (-2) (11) (by decide) (by decide))
    (eq_smul_div (20) 44 (5) (11) (by decide) (by decide))
    (eq_smul_div (26) 44 (13) (22) (by decide) (by decide))
    (eq_smul_div (9) 44 (9) (44) (by decide) (by decide))
    (eq_smul_div (28) 44 (7) (11) (by decide) (by decide))
    (eq_smul_div (26) 44 (13) (22) (by decide) (by decide))
    (eq_smul_div (6) 44 (3) (22) (by decide) (by decide))
    (eq_smul_div (36) 44 (9) (11) (by decide) (by decide))

public def XCell6_2 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (-9 / 44 : ℚ)
  | 1 => (-29 / 44 : ℚ)
  | 2 => (-5 / 11 : ℚ)
  | 3 => (-4 / 11 : ℚ)
  | 4 => (-17 / 44 : ℚ)
  | 5 => (-4 / 11 : ℚ)
  | 6 => (-2 / 11 : ℚ)
  | 7 => (-1 / 11 : ℚ)
  | 8 => (-7 / 44 : ℚ)
  | 9 => (-17 / 44 : ℚ)
  | _ => 0

public theorem XCell6_2_def : XCell6_2 = ![(-9 / 44 : ℚ), (-29 / 44 : ℚ), (-5 / 11 : ℚ), (-4 / 11 : ℚ), (-17 / 44 : ℚ), (-4 / 11 : ℚ), (-2 / 11 : ℚ), (-1 / 11 : ℚ), (-7 / 44 : ℚ), (-17 / 44 : ℚ)] := by
  funext i
  fin_cases i <;> rfl

public theorem XCell6_2_scaled :
    toVec #v[-9, -29, -20, -16, -17, -16, -8, -4, -7, -17] = ((44 : ℤ) : ℚ) • XCell6_2 :=
  toVec_eq_smul10 #v[-9, -29, -20, -16, -17, -16, -8, -4, -7, -17] 44 XCell6_2
    (eq_smul_div (-9) 44 (-9) (44) (by decide) (by decide))
    (eq_smul_div (-29) 44 (-29) (44) (by decide) (by decide))
    (eq_smul_div (-20) 44 (-5) (11) (by decide) (by decide))
    (eq_smul_div (-16) 44 (-4) (11) (by decide) (by decide))
    (eq_smul_div (-17) 44 (-17) (44) (by decide) (by decide))
    (eq_smul_div (-16) 44 (-4) (11) (by decide) (by decide))
    (eq_smul_div (-8) 44 (-2) (11) (by decide) (by decide))
    (eq_smul_div (-4) 44 (-1) (11) (by decide) (by decide))
    (eq_smul_div (-7) 44 (-7) (44) (by decide) (by decide))
    (eq_smul_div (-17) 44 (-17) (44) (by decide) (by decide))

public def XCell6_3 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (3 / 22 : ℚ)
  | 1 => (-3 / 11 : ℚ)
  | 2 => (7 / 22 : ℚ)
  | 3 => (3 / 11 : ℚ)
  | 4 => (-1 / 22 : ℚ)
  | 5 => (2 / 11 : ℚ)
  | 6 => (-4 / 11 : ℚ)
  | 7 => (-1 / 11 : ℚ)
  | 8 => (-3 / 22 : ℚ)
  | 9 => (-1 / 2 : ℚ)
  | _ => 0

public theorem XCell6_3_def : XCell6_3 = ![(3 / 22 : ℚ), (-3 / 11 : ℚ), (7 / 22 : ℚ), (3 / 11 : ℚ), (-1 / 22 : ℚ), (2 / 11 : ℚ), (-4 / 11 : ℚ), (-1 / 11 : ℚ), (-3 / 22 : ℚ), (-1 / 2 : ℚ)] := by
  funext i
  fin_cases i <;> rfl

public theorem XCell6_3_scaled :
    toVec #v[3, -6, 7, 6, -1, 4, -8, -2, -3, -11] = ((22 : ℤ) : ℚ) • XCell6_3 :=
  toVec_eq_smul10 #v[3, -6, 7, 6, -1, 4, -8, -2, -3, -11] 22 XCell6_3
    (eq_smul_div (3) 22 (3) (22) (by decide) (by decide))
    (eq_smul_div (-6) 22 (-3) (11) (by decide) (by decide))
    (eq_smul_div (7) 22 (7) (22) (by decide) (by decide))
    (eq_smul_div (6) 22 (3) (11) (by decide) (by decide))
    (eq_smul_div (-1) 22 (-1) (22) (by decide) (by decide))
    (eq_smul_div (4) 22 (2) (11) (by decide) (by decide))
    (eq_smul_div (-8) 22 (-4) (11) (by decide) (by decide))
    (eq_smul_div (-2) 22 (-1) (11) (by decide) (by decide))
    (eq_smul_div (-3) 22 (-3) (22) (by decide) (by decide))
    (eq_smul_div (-11) 22 (-1) (2) (by decide) (by decide))

public def XCell6_4 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (-1 / 44 : ℚ)
  | 1 => (-13 / 22 : ℚ)
  | 2 => (-3 / 11 : ℚ)
  | 3 => (15 / 44 : ℚ)
  | 4 => (-1 / 11 : ℚ)
  | 5 => (-19 / 44 : ℚ)
  | 6 => (-5 / 44 : ℚ)
  | 7 => (7 / 22 : ℚ)
  | 8 => (-7 / 22 : ℚ)
  | 9 => (-25 / 44 : ℚ)
  | _ => 0

public theorem XCell6_4_def : XCell6_4 = ![(-1 / 44 : ℚ), (-13 / 22 : ℚ), (-3 / 11 : ℚ), (15 / 44 : ℚ), (-1 / 11 : ℚ), (-19 / 44 : ℚ), (-5 / 44 : ℚ), (7 / 22 : ℚ), (-7 / 22 : ℚ), (-25 / 44 : ℚ)] := by
  funext i
  fin_cases i <;> rfl

public theorem XCell6_4_scaled :
    toVec #v[-1, -26, -12, 15, -4, -19, -5, 14, -14, -25] = ((44 : ℤ) : ℚ) • XCell6_4 :=
  toVec_eq_smul10 #v[-1, -26, -12, 15, -4, -19, -5, 14, -14, -25] 44 XCell6_4
    (eq_smul_div (-1) 44 (-1) (44) (by decide) (by decide))
    (eq_smul_div (-26) 44 (-13) (22) (by decide) (by decide))
    (eq_smul_div (-12) 44 (-3) (11) (by decide) (by decide))
    (eq_smul_div (15) 44 (15) (44) (by decide) (by decide))
    (eq_smul_div (-4) 44 (-1) (11) (by decide) (by decide))
    (eq_smul_div (-19) 44 (-19) (44) (by decide) (by decide))
    (eq_smul_div (-5) 44 (-5) (44) (by decide) (by decide))
    (eq_smul_div (14) 44 (7) (22) (by decide) (by decide))
    (eq_smul_div (-14) 44 (-7) (22) (by decide) (by decide))
    (eq_smul_div (-25) 44 (-25) (44) (by decide) (by decide))

public def XCell6_5 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (2 / 11 : ℚ)
  | 1 => (3 / 11 : ℚ)
  | 2 => (-7 / 22 : ℚ)
  | 3 => (7 / 22 : ℚ)
  | 4 => (1 / 22 : ℚ)
  | 5 => (-9 / 22 : ℚ)
  | 6 => (3 / 22 : ℚ)
  | 7 => (7 / 22 : ℚ)
  | 8 => (-3 / 22 : ℚ)
  | 9 => (13 / 22 : ℚ)
  | _ => 0

public theorem XCell6_5_def : XCell6_5 = ![(2 / 11 : ℚ), (3 / 11 : ℚ), (-7 / 22 : ℚ), (7 / 22 : ℚ), (1 / 22 : ℚ), (-9 / 22 : ℚ), (3 / 22 : ℚ), (7 / 22 : ℚ), (-3 / 22 : ℚ), (13 / 22 : ℚ)] := by
  funext i
  fin_cases i <;> rfl

public theorem XCell6_5_scaled :
    toVec #v[4, 6, -7, 7, 1, -9, 3, 7, -3, 13] = ((22 : ℤ) : ℚ) • XCell6_5 :=
  toVec_eq_smul10 #v[4, 6, -7, 7, 1, -9, 3, 7, -3, 13] 22 XCell6_5
    (eq_smul_div (4) 22 (2) (11) (by decide) (by decide))
    (eq_smul_div (6) 22 (3) (11) (by decide) (by decide))
    (eq_smul_div (-7) 22 (-7) (22) (by decide) (by decide))
    (eq_smul_div (7) 22 (7) (22) (by decide) (by decide))
    (eq_smul_div (1) 22 (1) (22) (by decide) (by decide))
    (eq_smul_div (-9) 22 (-9) (22) (by decide) (by decide))
    (eq_smul_div (3) 22 (3) (22) (by decide) (by decide))
    (eq_smul_div (7) 22 (7) (22) (by decide) (by decide))
    (eq_smul_div (-3) 22 (-3) (22) (by decide) (by decide))
    (eq_smul_div (13) 22 (13) (22) (by decide) (by decide))

public def XCell6_6 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (-8 / 11 : ℚ)
  | 1 => (-27 / 22 : ℚ)
  | 2 => (-3 / 11 : ℚ)
  | 3 => (-8 / 11 : ℚ)
  | 4 => (-9 / 11 : ℚ)
  | 5 => (-4 / 11 : ℚ)
  | 6 => (-19 / 22 : ℚ)
  | 7 => (-4 / 11 : ℚ)
  | 8 => 0
  | 9 => (-25 / 22 : ℚ)
  | _ => 0

public theorem XCell6_6_def : XCell6_6 = ![(-8 / 11 : ℚ), (-27 / 22 : ℚ), (-3 / 11 : ℚ), (-8 / 11 : ℚ), (-9 / 11 : ℚ), (-4 / 11 : ℚ), (-19 / 22 : ℚ), (-4 / 11 : ℚ), 0, (-25 / 22 : ℚ)] := by
  funext i
  fin_cases i <;> rfl

public theorem XCell6_6_scaled :
    toVec #v[-16, -27, -6, -16, -18, -8, -19, -8, 0, -25] = ((22 : ℤ) : ℚ) • XCell6_6 :=
  toVec_eq_smul10 #v[-16, -27, -6, -16, -18, -8, -19, -8, 0, -25] 22 XCell6_6
    (eq_smul_div (-16) 22 (-8) (11) (by decide) (by decide))
    (eq_smul_div (-27) 22 (-27) (22) (by decide) (by decide))
    (eq_smul_div (-6) 22 (-3) (11) (by decide) (by decide))
    (eq_smul_div (-16) 22 (-8) (11) (by decide) (by decide))
    (eq_smul_div (-18) 22 (-9) (11) (by decide) (by decide))
    (eq_smul_div (-8) 22 (-4) (11) (by decide) (by decide))
    (eq_smul_div (-19) 22 (-19) (22) (by decide) (by decide))
    (eq_smul_div (-8) 22 (-4) (11) (by decide) (by decide))
    (eq_smul_zero 22)
    (eq_smul_div (-25) 22 (-25) (22) (by decide) (by decide))

public def XCell6_7 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (-5 / 22 : ℚ)
  | 1 => (-1 / 11 : ℚ)
  | 2 => 0
  | 3 => (-17 / 22 : ℚ)
  | 4 => (-5 / 22 : ℚ)
  | 5 => (19 / 22 : ℚ)
  | 6 => (-2 / 11 : ℚ)
  | 7 => (-1 / 22 : ℚ)
  | 8 => (8 / 11 : ℚ)
  | 9 => (5 / 11 : ℚ)
  | _ => 0

public theorem XCell6_7_def : XCell6_7 = ![(-5 / 22 : ℚ), (-1 / 11 : ℚ), 0, (-17 / 22 : ℚ), (-5 / 22 : ℚ), (19 / 22 : ℚ), (-2 / 11 : ℚ), (-1 / 22 : ℚ), (8 / 11 : ℚ), (5 / 11 : ℚ)] := by
  funext i
  fin_cases i <;> rfl

public theorem XCell6_7_scaled :
    toVec #v[-5, -2, 0, -17, -5, 19, -4, -1, 16, 10] = ((22 : ℤ) : ℚ) • XCell6_7 :=
  toVec_eq_smul10 #v[-5, -2, 0, -17, -5, 19, -4, -1, 16, 10] 22 XCell6_7
    (eq_smul_div (-5) 22 (-5) (22) (by decide) (by decide))
    (eq_smul_div (-2) 22 (-1) (11) (by decide) (by decide))
    (eq_smul_zero 22)
    (eq_smul_div (-17) 22 (-17) (22) (by decide) (by decide))
    (eq_smul_div (-5) 22 (-5) (22) (by decide) (by decide))
    (eq_smul_div (19) 22 (19) (22) (by decide) (by decide))
    (eq_smul_div (-4) 22 (-2) (11) (by decide) (by decide))
    (eq_smul_div (-1) 22 (-1) (22) (by decide) (by decide))
    (eq_smul_div (16) 22 (8) (11) (by decide) (by decide))
    (eq_smul_div (10) 22 (5) (11) (by decide) (by decide))

public def XCell6_8 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => 0
  | 1 => 0
  | 2 => 0
  | 3 => 0
  | 4 => 0
  | 5 => 0
  | 6 => 0
  | 7 => 0
  | 8 => 0
  | 9 => 0
  | _ => 0

public theorem XCell6_8_def : XCell6_8 = ![0, 0, 0, 0, 0, 0, 0, 0, 0, 0] := by
  funext i
  fin_cases i <;> rfl

public theorem XCell6_8_scaled :
    toVec #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0] = ((1 : ℤ) : ℚ) • XCell6_8 :=
  toVec_eq_smul10 #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0] 1 XCell6_8
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)

public def XCell6_9 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => 0
  | 1 => 0
  | 2 => 0
  | 3 => 0
  | 4 => 0
  | 5 => 0
  | 6 => 0
  | 7 => 0
  | 8 => 0
  | 9 => 0
  | _ => 0

public theorem XCell6_9_def : XCell6_9 = ![0, 0, 0, 0, 0, 0, 0, 0, 0, 0] := by
  funext i
  fin_cases i <;> rfl

public theorem XCell6_9_scaled :
    toVec #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0] = ((1 : ℤ) : ℚ) • XCell6_9 :=
  toVec_eq_smul10 #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0] 1 XCell6_9
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)

public def XCell6_10 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (1 / 4 : ℚ)
  | 1 => 0
  | 2 => (-1 / 4 : ℚ)
  | 3 => 0
  | 4 => (-1 / 4 : ℚ)
  | 5 => (-1 / 2 : ℚ)
  | 6 => (-1 / 2 : ℚ)
  | 7 => (-1 / 4 : ℚ)
  | 8 => 0
  | 9 => (-1 / 4 : ℚ)
  | _ => 0

public theorem XCell6_10_def : XCell6_10 = ![(1 / 4 : ℚ), 0, (-1 / 4 : ℚ), 0, (-1 / 4 : ℚ), (-1 / 2 : ℚ), (-1 / 2 : ℚ), (-1 / 4 : ℚ), 0, (-1 / 4 : ℚ)] := by
  funext i
  fin_cases i <;> rfl

public theorem XCell6_10_scaled :
    toVec #v[1, 0, -1, 0, -1, -2, -2, -1, 0, -1] = ((4 : ℤ) : ℚ) • XCell6_10 :=
  toVec_eq_smul10 #v[1, 0, -1, 0, -1, -2, -2, -1, 0, -1] 4 XCell6_10
    (eq_smul_div (1) 4 (1) (4) (by decide) (by decide))
    (eq_smul_zero 4)
    (eq_smul_div (-1) 4 (-1) (4) (by decide) (by decide))
    (eq_smul_zero 4)
    (eq_smul_div (-1) 4 (-1) (4) (by decide) (by decide))
    (eq_smul_div (-2) 4 (-1) (2) (by decide) (by decide))
    (eq_smul_div (-2) 4 (-1) (2) (by decide) (by decide))
    (eq_smul_div (-1) 4 (-1) (4) (by decide) (by decide))
    (eq_smul_zero 4)
    (eq_smul_div (-1) 4 (-1) (4) (by decide) (by decide))

public def XCell6_11 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (1 / 4 : ℚ)
  | 1 => 0
  | 2 => (-1 / 4 : ℚ)
  | 3 => 0
  | 4 => (1 / 4 : ℚ)
  | 5 => 0
  | 6 => 0
  | 7 => (1 / 4 : ℚ)
  | 8 => 0
  | 9 => (-1 / 4 : ℚ)
  | _ => 0

public theorem XCell6_11_def : XCell6_11 = ![(1 / 4 : ℚ), 0, (-1 / 4 : ℚ), 0, (1 / 4 : ℚ), 0, 0, (1 / 4 : ℚ), 0, (-1 / 4 : ℚ)] := by
  funext i
  fin_cases i <;> rfl

public theorem XCell6_11_scaled :
    toVec #v[1, 0, -1, 0, 1, 0, 0, 1, 0, -1] = ((4 : ℤ) : ℚ) • XCell6_11 :=
  toVec_eq_smul10 #v[1, 0, -1, 0, 1, 0, 0, 1, 0, -1] 4 XCell6_11
    (eq_smul_div (1) 4 (1) (4) (by decide) (by decide))
    (eq_smul_zero 4)
    (eq_smul_div (-1) 4 (-1) (4) (by decide) (by decide))
    (eq_smul_zero 4)
    (eq_smul_div (1) 4 (1) (4) (by decide) (by decide))
    (eq_smul_zero 4)
    (eq_smul_zero 4)
    (eq_smul_div (1) 4 (1) (4) (by decide) (by decide))
    (eq_smul_zero 4)
    (eq_smul_div (-1) 4 (-1) (4) (by decide) (by decide))

public def XCell6_12 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => 0
  | 1 => 0
  | 2 => 0
  | 3 => 0
  | 4 => 0
  | 5 => 0
  | 6 => 0
  | 7 => 0
  | 8 => 0
  | 9 => 0
  | _ => 0

public theorem XCell6_12_def : XCell6_12 = ![0, 0, 0, 0, 0, 0, 0, 0, 0, 0] := by
  funext i
  fin_cases i <;> rfl

public theorem XCell6_12_scaled :
    toVec #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0] = ((1 : ℤ) : ℚ) • XCell6_12 :=
  toVec_eq_smul10 #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0] 1 XCell6_12
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)

public def XCell6_13 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => 0
  | 1 => 0
  | 2 => 0
  | 3 => 0
  | 4 => 0
  | 5 => 0
  | 6 => 0
  | 7 => 0
  | 8 => 0
  | 9 => 0
  | _ => 0

public theorem XCell6_13_def : XCell6_13 = ![0, 0, 0, 0, 0, 0, 0, 0, 0, 0] := by
  funext i
  fin_cases i <;> rfl

public theorem XCell6_13_scaled :
    toVec #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0] = ((1 : ℤ) : ℚ) • XCell6_13 :=
  toVec_eq_smul10 #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0] 1 XCell6_13
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)

public def XCell6_14 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => 0
  | 1 => 0
  | 2 => 0
  | 3 => 0
  | 4 => 0
  | 5 => 0
  | 6 => 0
  | 7 => 0
  | 8 => 0
  | 9 => 0
  | _ => 0

public theorem XCell6_14_def : XCell6_14 = ![0, 0, 0, 0, 0, 0, 0, 0, 0, 0] := by
  funext i
  fin_cases i <;> rfl

public theorem XCell6_14_scaled :
    toVec #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0] = ((1 : ℤ) : ℚ) • XCell6_14 :=
  toVec_eq_smul10 #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0] 1 XCell6_14
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)

public def XCell6_15 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => 0
  | 1 => 0
  | 2 => 0
  | 3 => 0
  | 4 => 0
  | 5 => 0
  | 6 => 0
  | 7 => 0
  | 8 => 0
  | 9 => 0
  | _ => 0

public theorem XCell6_15_def : XCell6_15 = ![0, 0, 0, 0, 0, 0, 0, 0, 0, 0] := by
  funext i
  fin_cases i <;> rfl

public theorem XCell6_15_scaled :
    toVec #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0] = ((1 : ℤ) : ℚ) • XCell6_15 :=
  toVec_eq_smul10 #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0] 1 XCell6_15
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)

public def XCell6_16 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => 0
  | 1 => 0
  | 2 => 0
  | 3 => 0
  | 4 => 0
  | 5 => 0
  | 6 => 0
  | 7 => 0
  | 8 => 0
  | 9 => 0
  | _ => 0

public theorem XCell6_16_def : XCell6_16 = ![0, 0, 0, 0, 0, 0, 0, 0, 0, 0] := by
  funext i
  fin_cases i <;> rfl

public theorem XCell6_16_scaled :
    toVec #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0] = ((1 : ℤ) : ℚ) • XCell6_16 :=
  toVec_eq_smul10 #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0] 1 XCell6_16
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)

public def XCell6_17 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => 0
  | 1 => 0
  | 2 => 0
  | 3 => 0
  | 4 => 0
  | 5 => 0
  | 6 => 0
  | 7 => 0
  | 8 => 0
  | 9 => 0
  | _ => 0

public theorem XCell6_17_def : XCell6_17 = ![0, 0, 0, 0, 0, 0, 0, 0, 0, 0] := by
  funext i
  fin_cases i <;> rfl

public theorem XCell6_17_scaled :
    toVec #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0] = ((1 : ℤ) : ℚ) • XCell6_17 :=
  toVec_eq_smul10 #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0] 1 XCell6_17
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)

public def XCell6_18 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => 0
  | 1 => 0
  | 2 => 0
  | 3 => 0
  | 4 => 0
  | 5 => 0
  | 6 => 0
  | 7 => 0
  | 8 => 0
  | 9 => 0
  | _ => 0

public theorem XCell6_18_def : XCell6_18 = ![0, 0, 0, 0, 0, 0, 0, 0, 0, 0] := by
  funext i
  fin_cases i <;> rfl

public theorem XCell6_18_scaled :
    toVec #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0] = ((1 : ℤ) : ℚ) • XCell6_18 :=
  toVec_eq_smul10 #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0] 1 XCell6_18
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)

public def XCell6_19 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => 0
  | 1 => 0
  | 2 => 0
  | 3 => 0
  | 4 => 0
  | 5 => 0
  | 6 => 0
  | 7 => 0
  | 8 => 0
  | 9 => 0
  | _ => 0

public theorem XCell6_19_def : XCell6_19 = ![0, 0, 0, 0, 0, 0, 0, 0, 0, 0] := by
  funext i
  fin_cases i <;> rfl

public theorem XCell6_19_scaled :
    toVec #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0] = ((1 : ℤ) : ℚ) • XCell6_19 :=
  toVec_eq_smul10 #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0] 1 XCell6_19
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)

public def XRow6 (j : Fin 20) : Vec :=
  match j.val with
  | 0 => XCell6_0
  | 1 => XCell6_1
  | 2 => XCell6_2
  | 3 => XCell6_3
  | 4 => XCell6_4
  | 5 => XCell6_5
  | 6 => XCell6_6
  | 7 => XCell6_7
  | 8 => XCell6_8
  | 9 => XCell6_9
  | 10 => XCell6_10
  | 11 => XCell6_11
  | 12 => XCell6_12
  | 13 => XCell6_13
  | 14 => XCell6_14
  | 15 => XCell6_15
  | 16 => XCell6_16
  | 17 => XCell6_17
  | 18 => XCell6_18
  | 19 => XCell6_19
  | _ => 0

public def XCell7_0 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (5 / 44 : ℚ)
  | 1 => (5 / 22 : ℚ)
  | 2 => (3 / 44 : ℚ)
  | 3 => (1 / 22 : ℚ)
  | 4 => (1 / 4 : ℚ)
  | 5 => (-1 / 11 : ℚ)
  | 6 => (3 / 22 : ℚ)
  | 7 => (-2 / 11 : ℚ)
  | 8 => (5 / 22 : ℚ)
  | 9 => (9 / 44 : ℚ)
  | _ => 0

public theorem XCell7_0_def : XCell7_0 = ![(5 / 44 : ℚ), (5 / 22 : ℚ), (3 / 44 : ℚ), (1 / 22 : ℚ), (1 / 4 : ℚ), (-1 / 11 : ℚ), (3 / 22 : ℚ), (-2 / 11 : ℚ), (5 / 22 : ℚ), (9 / 44 : ℚ)] := by
  funext i
  fin_cases i <;> rfl

public theorem XCell7_0_scaled :
    toVec #v[5, 10, 3, 2, 11, -4, 6, -8, 10, 9] = ((44 : ℤ) : ℚ) • XCell7_0 :=
  toVec_eq_smul10 #v[5, 10, 3, 2, 11, -4, 6, -8, 10, 9] 44 XCell7_0
    (eq_smul_div (5) 44 (5) (44) (by decide) (by decide))
    (eq_smul_div (10) 44 (5) (22) (by decide) (by decide))
    (eq_smul_div (3) 44 (3) (44) (by decide) (by decide))
    (eq_smul_div (2) 44 (1) (22) (by decide) (by decide))
    (eq_smul_div (11) 44 (1) (4) (by decide) (by decide))
    (eq_smul_div (-4) 44 (-1) (11) (by decide) (by decide))
    (eq_smul_div (6) 44 (3) (22) (by decide) (by decide))
    (eq_smul_div (-8) 44 (-2) (11) (by decide) (by decide))
    (eq_smul_div (10) 44 (5) (22) (by decide) (by decide))
    (eq_smul_div (9) 44 (9) (44) (by decide) (by decide))

public def XCell7_1 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (-3 / 22 : ℚ)
  | 1 => (-5 / 22 : ℚ)
  | 2 => (-7 / 44 : ℚ)
  | 3 => (-15 / 44 : ℚ)
  | 4 => (-2 / 11 : ℚ)
  | 5 => (-9 / 22 : ℚ)
  | 6 => (-3 / 11 : ℚ)
  | 7 => (-2 / 11 : ℚ)
  | 8 => (-3 / 44 : ℚ)
  | 9 => (-3 / 11 : ℚ)
  | _ => 0

public theorem XCell7_1_def : XCell7_1 = ![(-3 / 22 : ℚ), (-5 / 22 : ℚ), (-7 / 44 : ℚ), (-15 / 44 : ℚ), (-2 / 11 : ℚ), (-9 / 22 : ℚ), (-3 / 11 : ℚ), (-2 / 11 : ℚ), (-3 / 44 : ℚ), (-3 / 11 : ℚ)] := by
  funext i
  fin_cases i <;> rfl

public theorem XCell7_1_scaled :
    toVec #v[-6, -10, -7, -15, -8, -18, -12, -8, -3, -12] = ((44 : ℤ) : ℚ) • XCell7_1 :=
  toVec_eq_smul10 #v[-6, -10, -7, -15, -8, -18, -12, -8, -3, -12] 44 XCell7_1
    (eq_smul_div (-6) 44 (-3) (22) (by decide) (by decide))
    (eq_smul_div (-10) 44 (-5) (22) (by decide) (by decide))
    (eq_smul_div (-7) 44 (-7) (44) (by decide) (by decide))
    (eq_smul_div (-15) 44 (-15) (44) (by decide) (by decide))
    (eq_smul_div (-8) 44 (-2) (11) (by decide) (by decide))
    (eq_smul_div (-18) 44 (-9) (22) (by decide) (by decide))
    (eq_smul_div (-12) 44 (-3) (11) (by decide) (by decide))
    (eq_smul_div (-8) 44 (-2) (11) (by decide) (by decide))
    (eq_smul_div (-3) 44 (-3) (44) (by decide) (by decide))
    (eq_smul_div (-12) 44 (-3) (11) (by decide) (by decide))

public def XCell7_2 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (1 / 22 : ℚ)
  | 1 => (-1 / 22 : ℚ)
  | 2 => (-1 / 11 : ℚ)
  | 3 => (1 / 44 : ℚ)
  | 4 => (-1 / 44 : ℚ)
  | 5 => (-3 / 44 : ℚ)
  | 6 => (-3 / 22 : ℚ)
  | 7 => 0
  | 8 => 0
  | 9 => (1 / 22 : ℚ)
  | _ => 0

public theorem XCell7_2_def : XCell7_2 = ![(1 / 22 : ℚ), (-1 / 22 : ℚ), (-1 / 11 : ℚ), (1 / 44 : ℚ), (-1 / 44 : ℚ), (-3 / 44 : ℚ), (-3 / 22 : ℚ), 0, 0, (1 / 22 : ℚ)] := by
  funext i
  fin_cases i <;> rfl

public theorem XCell7_2_scaled :
    toVec #v[2, -2, -4, 1, -1, -3, -6, 0, 0, 2] = ((44 : ℤ) : ℚ) • XCell7_2 :=
  toVec_eq_smul10 #v[2, -2, -4, 1, -1, -3, -6, 0, 0, 2] 44 XCell7_2
    (eq_smul_div (2) 44 (1) (22) (by decide) (by decide))
    (eq_smul_div (-2) 44 (-1) (22) (by decide) (by decide))
    (eq_smul_div (-4) 44 (-1) (11) (by decide) (by decide))
    (eq_smul_div (1) 44 (1) (44) (by decide) (by decide))
    (eq_smul_div (-1) 44 (-1) (44) (by decide) (by decide))
    (eq_smul_div (-3) 44 (-3) (44) (by decide) (by decide))
    (eq_smul_div (-6) 44 (-3) (22) (by decide) (by decide))
    (eq_smul_zero 44)
    (eq_smul_zero 44)
    (eq_smul_div (2) 44 (1) (22) (by decide) (by decide))

public def XCell7_3 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (13 / 44 : ℚ)
  | 1 => (1 / 2 : ℚ)
  | 2 => (2 / 11 : ℚ)
  | 3 => (9 / 44 : ℚ)
  | 4 => (4 / 11 : ℚ)
  | 5 => (1 / 4 : ℚ)
  | 6 => (7 / 22 : ℚ)
  | 7 => (3 / 22 : ℚ)
  | 8 => (13 / 44 : ℚ)
  | 9 => (9 / 44 : ℚ)
  | _ => 0

public theorem XCell7_3_def : XCell7_3 = ![(13 / 44 : ℚ), (1 / 2 : ℚ), (2 / 11 : ℚ), (9 / 44 : ℚ), (4 / 11 : ℚ), (1 / 4 : ℚ), (7 / 22 : ℚ), (3 / 22 : ℚ), (13 / 44 : ℚ), (9 / 44 : ℚ)] := by
  funext i
  fin_cases i <;> rfl

public theorem XCell7_3_scaled :
    toVec #v[13, 22, 8, 9, 16, 11, 14, 6, 13, 9] = ((44 : ℤ) : ℚ) • XCell7_3 :=
  toVec_eq_smul10 #v[13, 22, 8, 9, 16, 11, 14, 6, 13, 9] 44 XCell7_3
    (eq_smul_div (13) 44 (13) (44) (by decide) (by decide))
    (eq_smul_div (22) 44 (1) (2) (by decide) (by decide))
    (eq_smul_div (8) 44 (2) (11) (by decide) (by decide))
    (eq_smul_div (9) 44 (9) (44) (by decide) (by decide))
    (eq_smul_div (16) 44 (4) (11) (by decide) (by decide))
    (eq_smul_div (11) 44 (1) (4) (by decide) (by decide))
    (eq_smul_div (14) 44 (7) (22) (by decide) (by decide))
    (eq_smul_div (6) 44 (3) (22) (by decide) (by decide))
    (eq_smul_div (13) 44 (13) (44) (by decide) (by decide))
    (eq_smul_div (9) 44 (9) (44) (by decide) (by decide))

public def XCell7_4 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (5 / 22 : ℚ)
  | 1 => (13 / 44 : ℚ)
  | 2 => (1 / 22 : ℚ)
  | 3 => (1 / 22 : ℚ)
  | 4 => (3 / 22 : ℚ)
  | 5 => (1 / 4 : ℚ)
  | 6 => (1 / 11 : ℚ)
  | 7 => (3 / 11 : ℚ)
  | 8 => (1 / 4 : ℚ)
  | 9 => (3 / 22 : ℚ)
  | _ => 0

public theorem XCell7_4_def : XCell7_4 = ![(5 / 22 : ℚ), (13 / 44 : ℚ), (1 / 22 : ℚ), (1 / 22 : ℚ), (3 / 22 : ℚ), (1 / 4 : ℚ), (1 / 11 : ℚ), (3 / 11 : ℚ), (1 / 4 : ℚ), (3 / 22 : ℚ)] := by
  funext i
  fin_cases i <;> rfl

public theorem XCell7_4_scaled :
    toVec #v[10, 13, 2, 2, 6, 11, 4, 12, 11, 6] = ((44 : ℤ) : ℚ) • XCell7_4 :=
  toVec_eq_smul10 #v[10, 13, 2, 2, 6, 11, 4, 12, 11, 6] 44 XCell7_4
    (eq_smul_div (10) 44 (5) (22) (by decide) (by decide))
    (eq_smul_div (13) 44 (13) (44) (by decide) (by decide))
    (eq_smul_div (2) 44 (1) (22) (by decide) (by decide))
    (eq_smul_div (2) 44 (1) (22) (by decide) (by decide))
    (eq_smul_div (6) 44 (3) (22) (by decide) (by decide))
    (eq_smul_div (11) 44 (1) (4) (by decide) (by decide))
    (eq_smul_div (4) 44 (1) (11) (by decide) (by decide))
    (eq_smul_div (12) 44 (3) (11) (by decide) (by decide))
    (eq_smul_div (11) 44 (1) (4) (by decide) (by decide))
    (eq_smul_div (6) 44 (3) (22) (by decide) (by decide))

public def XCell7_5 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (-1 / 11 : ℚ)
  | 1 => (-3 / 22 : ℚ)
  | 2 => 0
  | 3 => (-2 / 11 : ℚ)
  | 4 => (-3 / 22 : ℚ)
  | 5 => (-5 / 22 : ℚ)
  | 6 => (1 / 11 : ℚ)
  | 7 => (-5 / 22 : ℚ)
  | 8 => (-5 / 22 : ℚ)
  | 9 => (-4 / 11 : ℚ)
  | _ => 0

public theorem XCell7_5_def : XCell7_5 = ![(-1 / 11 : ℚ), (-3 / 22 : ℚ), 0, (-2 / 11 : ℚ), (-3 / 22 : ℚ), (-5 / 22 : ℚ), (1 / 11 : ℚ), (-5 / 22 : ℚ), (-5 / 22 : ℚ), (-4 / 11 : ℚ)] := by
  funext i
  fin_cases i <;> rfl

public theorem XCell7_5_scaled :
    toVec #v[-2, -3, 0, -4, -3, -5, 2, -5, -5, -8] = ((22 : ℤ) : ℚ) • XCell7_5 :=
  toVec_eq_smul10 #v[-2, -3, 0, -4, -3, -5, 2, -5, -5, -8] 22 XCell7_5
    (eq_smul_div (-2) 22 (-1) (11) (by decide) (by decide))
    (eq_smul_div (-3) 22 (-3) (22) (by decide) (by decide))
    (eq_smul_zero 22)
    (eq_smul_div (-4) 22 (-2) (11) (by decide) (by decide))
    (eq_smul_div (-3) 22 (-3) (22) (by decide) (by decide))
    (eq_smul_div (-5) 22 (-5) (22) (by decide) (by decide))
    (eq_smul_div (2) 22 (1) (11) (by decide) (by decide))
    (eq_smul_div (-5) 22 (-5) (22) (by decide) (by decide))
    (eq_smul_div (-5) 22 (-5) (22) (by decide) (by decide))
    (eq_smul_div (-8) 22 (-4) (11) (by decide) (by decide))

public def XCell7_6 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (4 / 11 : ℚ)
  | 1 => (9 / 22 : ℚ)
  | 2 => (-1 / 22 : ℚ)
  | 3 => (3 / 11 : ℚ)
  | 4 => (3 / 11 : ℚ)
  | 5 => (2 / 11 : ℚ)
  | 6 => (1 / 11 : ℚ)
  | 7 => (5 / 22 : ℚ)
  | 8 => (7 / 22 : ℚ)
  | 9 => (9 / 22 : ℚ)
  | _ => 0

public theorem XCell7_6_def : XCell7_6 = ![(4 / 11 : ℚ), (9 / 22 : ℚ), (-1 / 22 : ℚ), (3 / 11 : ℚ), (3 / 11 : ℚ), (2 / 11 : ℚ), (1 / 11 : ℚ), (5 / 22 : ℚ), (7 / 22 : ℚ), (9 / 22 : ℚ)] := by
  funext i
  fin_cases i <;> rfl

public theorem XCell7_6_scaled :
    toVec #v[8, 9, -1, 6, 6, 4, 2, 5, 7, 9] = ((22 : ℤ) : ℚ) • XCell7_6 :=
  toVec_eq_smul10 #v[8, 9, -1, 6, 6, 4, 2, 5, 7, 9] 22 XCell7_6
    (eq_smul_div (8) 22 (4) (11) (by decide) (by decide))
    (eq_smul_div (9) 22 (9) (22) (by decide) (by decide))
    (eq_smul_div (-1) 22 (-1) (22) (by decide) (by decide))
    (eq_smul_div (6) 22 (3) (11) (by decide) (by decide))
    (eq_smul_div (6) 22 (3) (11) (by decide) (by decide))
    (eq_smul_div (4) 22 (2) (11) (by decide) (by decide))
    (eq_smul_div (2) 22 (1) (11) (by decide) (by decide))
    (eq_smul_div (5) 22 (5) (22) (by decide) (by decide))
    (eq_smul_div (7) 22 (7) (22) (by decide) (by decide))
    (eq_smul_div (9) 22 (9) (22) (by decide) (by decide))

public def XCell7_7 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (-17 / 22 : ℚ)
  | 1 => (-7 / 22 : ℚ)
  | 2 => (-1 / 22 : ℚ)
  | 3 => (-3 / 22 : ℚ)
  | 4 => (-9 / 22 : ℚ)
  | 5 => (-4 / 11 : ℚ)
  | 6 => (1 / 22 : ℚ)
  | 7 => (-3 / 22 : ℚ)
  | 8 => (-5 / 22 : ℚ)
  | 9 => (-3 / 22 : ℚ)
  | _ => 0

public theorem XCell7_7_def : XCell7_7 = ![(-17 / 22 : ℚ), (-7 / 22 : ℚ), (-1 / 22 : ℚ), (-3 / 22 : ℚ), (-9 / 22 : ℚ), (-4 / 11 : ℚ), (1 / 22 : ℚ), (-3 / 22 : ℚ), (-5 / 22 : ℚ), (-3 / 22 : ℚ)] := by
  funext i
  fin_cases i <;> rfl

public theorem XCell7_7_scaled :
    toVec #v[-17, -7, -1, -3, -9, -8, 1, -3, -5, -3] = ((22 : ℤ) : ℚ) • XCell7_7 :=
  toVec_eq_smul10 #v[-17, -7, -1, -3, -9, -8, 1, -3, -5, -3] 22 XCell7_7
    (eq_smul_div (-17) 22 (-17) (22) (by decide) (by decide))
    (eq_smul_div (-7) 22 (-7) (22) (by decide) (by decide))
    (eq_smul_div (-1) 22 (-1) (22) (by decide) (by decide))
    (eq_smul_div (-3) 22 (-3) (22) (by decide) (by decide))
    (eq_smul_div (-9) 22 (-9) (22) (by decide) (by decide))
    (eq_smul_div (-8) 22 (-4) (11) (by decide) (by decide))
    (eq_smul_div (1) 22 (1) (22) (by decide) (by decide))
    (eq_smul_div (-3) 22 (-3) (22) (by decide) (by decide))
    (eq_smul_div (-5) 22 (-5) (22) (by decide) (by decide))
    (eq_smul_div (-3) 22 (-3) (22) (by decide) (by decide))

public def XCell7_8 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => 0
  | 1 => 0
  | 2 => 0
  | 3 => 0
  | 4 => 0
  | 5 => 0
  | 6 => 0
  | 7 => 0
  | 8 => 0
  | 9 => 0
  | _ => 0

public theorem XCell7_8_def : XCell7_8 = ![0, 0, 0, 0, 0, 0, 0, 0, 0, 0] := by
  funext i
  fin_cases i <;> rfl

public theorem XCell7_8_scaled :
    toVec #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0] = ((1 : ℤ) : ℚ) • XCell7_8 :=
  toVec_eq_smul10 #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0] 1 XCell7_8
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)

public def XCell7_9 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => 0
  | 1 => 0
  | 2 => 0
  | 3 => 0
  | 4 => 0
  | 5 => 0
  | 6 => 0
  | 7 => 0
  | 8 => 0
  | 9 => 0
  | _ => 0

public theorem XCell7_9_def : XCell7_9 = ![0, 0, 0, 0, 0, 0, 0, 0, 0, 0] := by
  funext i
  fin_cases i <;> rfl

public theorem XCell7_9_scaled :
    toVec #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0] = ((1 : ℤ) : ℚ) • XCell7_9 :=
  toVec_eq_smul10 #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0] 1 XCell7_9
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)

public def XCell7_10 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => 0
  | 1 => 0
  | 2 => 0
  | 3 => (-1 / 4 : ℚ)
  | 4 => (-1 / 4 : ℚ)
  | 5 => 0
  | 6 => 0
  | 7 => (-1 / 4 : ℚ)
  | 8 => (-1 / 4 : ℚ)
  | 9 => 0
  | _ => 0

public theorem XCell7_10_def : XCell7_10 = ![0, 0, 0, (-1 / 4 : ℚ), (-1 / 4 : ℚ), 0, 0, (-1 / 4 : ℚ), (-1 / 4 : ℚ), 0] := by
  funext i
  fin_cases i <;> rfl

public theorem XCell7_10_scaled :
    toVec #v[0, 0, 0, -1, -1, 0, 0, -1, -1, 0] = ((4 : ℤ) : ℚ) • XCell7_10 :=
  toVec_eq_smul10 #v[0, 0, 0, -1, -1, 0, 0, -1, -1, 0] 4 XCell7_10
    (eq_smul_zero 4)
    (eq_smul_zero 4)
    (eq_smul_zero 4)
    (eq_smul_div (-1) 4 (-1) (4) (by decide) (by decide))
    (eq_smul_div (-1) 4 (-1) (4) (by decide) (by decide))
    (eq_smul_zero 4)
    (eq_smul_zero 4)
    (eq_smul_div (-1) 4 (-1) (4) (by decide) (by decide))
    (eq_smul_div (-1) 4 (-1) (4) (by decide) (by decide))
    (eq_smul_zero 4)

public def XCell7_11 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => 0
  | 1 => 0
  | 2 => 0
  | 3 => 0
  | 4 => 0
  | 5 => (-1 / 4 : ℚ)
  | 6 => (-1 / 4 : ℚ)
  | 7 => 0
  | 8 => 0
  | 9 => 0
  | _ => 0

public theorem XCell7_11_def : XCell7_11 = ![0, 0, 0, 0, 0, (-1 / 4 : ℚ), (-1 / 4 : ℚ), 0, 0, 0] := by
  funext i
  fin_cases i <;> rfl

public theorem XCell7_11_scaled :
    toVec #v[0, 0, 0, 0, 0, -1, -1, 0, 0, 0] = ((4 : ℤ) : ℚ) • XCell7_11 :=
  toVec_eq_smul10 #v[0, 0, 0, 0, 0, -1, -1, 0, 0, 0] 4 XCell7_11
    (eq_smul_zero 4)
    (eq_smul_zero 4)
    (eq_smul_zero 4)
    (eq_smul_zero 4)
    (eq_smul_zero 4)
    (eq_smul_div (-1) 4 (-1) (4) (by decide) (by decide))
    (eq_smul_div (-1) 4 (-1) (4) (by decide) (by decide))
    (eq_smul_zero 4)
    (eq_smul_zero 4)
    (eq_smul_zero 4)

public def XCell7_12 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => 0
  | 1 => 0
  | 2 => 0
  | 3 => 0
  | 4 => 0
  | 5 => 0
  | 6 => 0
  | 7 => 0
  | 8 => 0
  | 9 => 0
  | _ => 0

public theorem XCell7_12_def : XCell7_12 = ![0, 0, 0, 0, 0, 0, 0, 0, 0, 0] := by
  funext i
  fin_cases i <;> rfl

public theorem XCell7_12_scaled :
    toVec #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0] = ((1 : ℤ) : ℚ) • XCell7_12 :=
  toVec_eq_smul10 #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0] 1 XCell7_12
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)

public def XCell7_13 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => 0
  | 1 => 0
  | 2 => 0
  | 3 => 0
  | 4 => 0
  | 5 => 0
  | 6 => 0
  | 7 => 0
  | 8 => 0
  | 9 => 0
  | _ => 0

public theorem XCell7_13_def : XCell7_13 = ![0, 0, 0, 0, 0, 0, 0, 0, 0, 0] := by
  funext i
  fin_cases i <;> rfl

public theorem XCell7_13_scaled :
    toVec #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0] = ((1 : ℤ) : ℚ) • XCell7_13 :=
  toVec_eq_smul10 #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0] 1 XCell7_13
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)

public def XCell7_14 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => 0
  | 1 => 0
  | 2 => 0
  | 3 => 0
  | 4 => 0
  | 5 => 0
  | 6 => 0
  | 7 => 0
  | 8 => 0
  | 9 => 0
  | _ => 0

public theorem XCell7_14_def : XCell7_14 = ![0, 0, 0, 0, 0, 0, 0, 0, 0, 0] := by
  funext i
  fin_cases i <;> rfl

public theorem XCell7_14_scaled :
    toVec #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0] = ((1 : ℤ) : ℚ) • XCell7_14 :=
  toVec_eq_smul10 #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0] 1 XCell7_14
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)

public def XCell7_15 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => 0
  | 1 => 0
  | 2 => 0
  | 3 => 0
  | 4 => 0
  | 5 => 0
  | 6 => 0
  | 7 => 0
  | 8 => 0
  | 9 => 0
  | _ => 0

public theorem XCell7_15_def : XCell7_15 = ![0, 0, 0, 0, 0, 0, 0, 0, 0, 0] := by
  funext i
  fin_cases i <;> rfl

public theorem XCell7_15_scaled :
    toVec #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0] = ((1 : ℤ) : ℚ) • XCell7_15 :=
  toVec_eq_smul10 #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0] 1 XCell7_15
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)

public def XCell7_16 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => 0
  | 1 => 0
  | 2 => 0
  | 3 => 0
  | 4 => 0
  | 5 => 0
  | 6 => 0
  | 7 => 0
  | 8 => 0
  | 9 => 0
  | _ => 0

public theorem XCell7_16_def : XCell7_16 = ![0, 0, 0, 0, 0, 0, 0, 0, 0, 0] := by
  funext i
  fin_cases i <;> rfl

public theorem XCell7_16_scaled :
    toVec #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0] = ((1 : ℤ) : ℚ) • XCell7_16 :=
  toVec_eq_smul10 #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0] 1 XCell7_16
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)

public def XCell7_17 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => 0
  | 1 => 0
  | 2 => 0
  | 3 => 0
  | 4 => 0
  | 5 => 0
  | 6 => 0
  | 7 => 0
  | 8 => 0
  | 9 => 0
  | _ => 0

public theorem XCell7_17_def : XCell7_17 = ![0, 0, 0, 0, 0, 0, 0, 0, 0, 0] := by
  funext i
  fin_cases i <;> rfl

public theorem XCell7_17_scaled :
    toVec #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0] = ((1 : ℤ) : ℚ) • XCell7_17 :=
  toVec_eq_smul10 #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0] 1 XCell7_17
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)

public def XCell7_18 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => 0
  | 1 => 0
  | 2 => 0
  | 3 => 0
  | 4 => 0
  | 5 => 0
  | 6 => 0
  | 7 => 0
  | 8 => 0
  | 9 => 0
  | _ => 0

public theorem XCell7_18_def : XCell7_18 = ![0, 0, 0, 0, 0, 0, 0, 0, 0, 0] := by
  funext i
  fin_cases i <;> rfl

public theorem XCell7_18_scaled :
    toVec #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0] = ((1 : ℤ) : ℚ) • XCell7_18 :=
  toVec_eq_smul10 #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0] 1 XCell7_18
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)

public def XCell7_19 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => 0
  | 1 => 0
  | 2 => 0
  | 3 => 0
  | 4 => 0
  | 5 => 0
  | 6 => 0
  | 7 => 0
  | 8 => 0
  | 9 => 0
  | _ => 0

public theorem XCell7_19_def : XCell7_19 = ![0, 0, 0, 0, 0, 0, 0, 0, 0, 0] := by
  funext i
  fin_cases i <;> rfl

public theorem XCell7_19_scaled :
    toVec #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0] = ((1 : ℤ) : ℚ) • XCell7_19 :=
  toVec_eq_smul10 #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0] 1 XCell7_19
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)

public def XRow7 (j : Fin 20) : Vec :=
  match j.val with
  | 0 => XCell7_0
  | 1 => XCell7_1
  | 2 => XCell7_2
  | 3 => XCell7_3
  | 4 => XCell7_4
  | 5 => XCell7_5
  | 6 => XCell7_6
  | 7 => XCell7_7
  | 8 => XCell7_8
  | 9 => XCell7_9
  | 10 => XCell7_10
  | 11 => XCell7_11
  | 12 => XCell7_12
  | 13 => XCell7_13
  | 14 => XCell7_14
  | 15 => XCell7_15
  | 16 => XCell7_16
  | 17 => XCell7_17
  | 18 => XCell7_18
  | 19 => XCell7_19
  | _ => 0

public def XCell8_0 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (29 / 44 : ℚ)
  | 1 => (-2 / 11 : ℚ)
  | 2 => (19 / 44 : ℚ)
  | 3 => (9 / 22 : ℚ)
  | 4 => (-3 / 11 : ℚ)
  | 5 => (9 / 22 : ℚ)
  | 6 => (13 / 44 : ℚ)
  | 7 => (-9 / 44 : ℚ)
  | 8 => (13 / 44 : ℚ)
  | 9 => (9 / 22 : ℚ)
  | _ => 0

public theorem XCell8_0_def : XCell8_0 = ![(29 / 44 : ℚ), (-2 / 11 : ℚ), (19 / 44 : ℚ), (9 / 22 : ℚ), (-3 / 11 : ℚ), (9 / 22 : ℚ), (13 / 44 : ℚ), (-9 / 44 : ℚ), (13 / 44 : ℚ), (9 / 22 : ℚ)] := by
  funext i
  fin_cases i <;> rfl

public theorem XCell8_0_scaled :
    toVec #v[29, -8, 19, 18, -12, 18, 13, -9, 13, 18] = ((44 : ℤ) : ℚ) • XCell8_0 :=
  toVec_eq_smul10 #v[29, -8, 19, 18, -12, 18, 13, -9, 13, 18] 44 XCell8_0
    (eq_smul_div (29) 44 (29) (44) (by decide) (by decide))
    (eq_smul_div (-8) 44 (-2) (11) (by decide) (by decide))
    (eq_smul_div (19) 44 (19) (44) (by decide) (by decide))
    (eq_smul_div (18) 44 (9) (22) (by decide) (by decide))
    (eq_smul_div (-12) 44 (-3) (11) (by decide) (by decide))
    (eq_smul_div (18) 44 (9) (22) (by decide) (by decide))
    (eq_smul_div (13) 44 (13) (44) (by decide) (by decide))
    (eq_smul_div (-9) 44 (-9) (44) (by decide) (by decide))
    (eq_smul_div (13) 44 (13) (44) (by decide) (by decide))
    (eq_smul_div (18) 44 (9) (22) (by decide) (by decide))

public def XCell8_1 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (-1 / 22 : ℚ)
  | 1 => (7 / 44 : ℚ)
  | 2 => (-7 / 44 : ℚ)
  | 3 => 0
  | 4 => (17 / 44 : ℚ)
  | 5 => (3 / 44 : ℚ)
  | 6 => (1 / 4 : ℚ)
  | 7 => (1 / 2 : ℚ)
  | 8 => (1 / 22 : ℚ)
  | 9 => (1 / 22 : ℚ)
  | _ => 0

public theorem XCell8_1_def : XCell8_1 = ![(-1 / 22 : ℚ), (7 / 44 : ℚ), (-7 / 44 : ℚ), 0, (17 / 44 : ℚ), (3 / 44 : ℚ), (1 / 4 : ℚ), (1 / 2 : ℚ), (1 / 22 : ℚ), (1 / 22 : ℚ)] := by
  funext i
  fin_cases i <;> rfl

public theorem XCell8_1_scaled :
    toVec #v[-2, 7, -7, 0, 17, 3, 11, 22, 2, 2] = ((44 : ℤ) : ℚ) • XCell8_1 :=
  toVec_eq_smul10 #v[-2, 7, -7, 0, 17, 3, 11, 22, 2, 2] 44 XCell8_1
    (eq_smul_div (-2) 44 (-1) (22) (by decide) (by decide))
    (eq_smul_div (7) 44 (7) (44) (by decide) (by decide))
    (eq_smul_div (-7) 44 (-7) (44) (by decide) (by decide))
    (eq_smul_zero 44)
    (eq_smul_div (17) 44 (17) (44) (by decide) (by decide))
    (eq_smul_div (3) 44 (3) (44) (by decide) (by decide))
    (eq_smul_div (11) 44 (1) (4) (by decide) (by decide))
    (eq_smul_div (22) 44 (1) (2) (by decide) (by decide))
    (eq_smul_div (2) 44 (1) (22) (by decide) (by decide))
    (eq_smul_div (2) 44 (1) (22) (by decide) (by decide))

public def XCell8_2 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (-3 / 22 : ℚ)
  | 1 => (-1 / 44 : ℚ)
  | 2 => (5 / 44 : ℚ)
  | 3 => (1 / 11 : ℚ)
  | 4 => (-1 / 22 : ℚ)
  | 5 => (1 / 4 : ℚ)
  | 6 => (5 / 11 : ℚ)
  | 7 => (3 / 22 : ℚ)
  | 8 => (9 / 22 : ℚ)
  | 9 => (1 / 4 : ℚ)
  | _ => 0

public theorem XCell8_2_def : XCell8_2 = ![(-3 / 22 : ℚ), (-1 / 44 : ℚ), (5 / 44 : ℚ), (1 / 11 : ℚ), (-1 / 22 : ℚ), (1 / 4 : ℚ), (5 / 11 : ℚ), (3 / 22 : ℚ), (9 / 22 : ℚ), (1 / 4 : ℚ)] := by
  funext i
  fin_cases i <;> rfl

public theorem XCell8_2_scaled :
    toVec #v[-6, -1, 5, 4, -2, 11, 20, 6, 18, 11] = ((44 : ℤ) : ℚ) • XCell8_2 :=
  toVec_eq_smul10 #v[-6, -1, 5, 4, -2, 11, 20, 6, 18, 11] 44 XCell8_2
    (eq_smul_div (-6) 44 (-3) (22) (by decide) (by decide))
    (eq_smul_div (-1) 44 (-1) (44) (by decide) (by decide))
    (eq_smul_div (5) 44 (5) (44) (by decide) (by decide))
    (eq_smul_div (4) 44 (1) (11) (by decide) (by decide))
    (eq_smul_div (-2) 44 (-1) (22) (by decide) (by decide))
    (eq_smul_div (11) 44 (1) (4) (by decide) (by decide))
    (eq_smul_div (20) 44 (5) (11) (by decide) (by decide))
    (eq_smul_div (6) 44 (3) (22) (by decide) (by decide))
    (eq_smul_div (18) 44 (9) (22) (by decide) (by decide))
    (eq_smul_div (11) 44 (1) (4) (by decide) (by decide))

public def XCell8_3 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (9 / 22 : ℚ)
  | 1 => 0
  | 2 => (15 / 44 : ℚ)
  | 3 => (8 / 11 : ℚ)
  | 4 => (1 / 44 : ℚ)
  | 5 => (15 / 44 : ℚ)
  | 6 => (3 / 11 : ℚ)
  | 7 => (-3 / 22 : ℚ)
  | 8 => (13 / 44 : ℚ)
  | 9 => (5 / 22 : ℚ)
  | _ => 0

public theorem XCell8_3_def : XCell8_3 = ![(9 / 22 : ℚ), 0, (15 / 44 : ℚ), (8 / 11 : ℚ), (1 / 44 : ℚ), (15 / 44 : ℚ), (3 / 11 : ℚ), (-3 / 22 : ℚ), (13 / 44 : ℚ), (5 / 22 : ℚ)] := by
  funext i
  fin_cases i <;> rfl

public theorem XCell8_3_scaled :
    toVec #v[18, 0, 15, 32, 1, 15, 12, -6, 13, 10] = ((44 : ℤ) : ℚ) • XCell8_3 :=
  toVec_eq_smul10 #v[18, 0, 15, 32, 1, 15, 12, -6, 13, 10] 44 XCell8_3
    (eq_smul_div (18) 44 (9) (22) (by decide) (by decide))
    (eq_smul_zero 44)
    (eq_smul_div (15) 44 (15) (44) (by decide) (by decide))
    (eq_smul_div (32) 44 (8) (11) (by decide) (by decide))
    (eq_smul_div (1) 44 (1) (44) (by decide) (by decide))
    (eq_smul_div (15) 44 (15) (44) (by decide) (by decide))
    (eq_smul_div (12) 44 (3) (11) (by decide) (by decide))
    (eq_smul_div (-6) 44 (-3) (22) (by decide) (by decide))
    (eq_smul_div (13) 44 (13) (44) (by decide) (by decide))
    (eq_smul_div (10) 44 (5) (22) (by decide) (by decide))

public def XCell8_4 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (-3 / 11 : ℚ)
  | 1 => (-7 / 44 : ℚ)
  | 2 => (1 / 22 : ℚ)
  | 3 => (1 / 44 : ℚ)
  | 4 => (-2 / 11 : ℚ)
  | 5 => (5 / 22 : ℚ)
  | 6 => (5 / 44 : ℚ)
  | 7 => (-7 / 44 : ℚ)
  | 8 => (-1 / 4 : ℚ)
  | 9 => (-3 / 22 : ℚ)
  | _ => 0

public theorem XCell8_4_def : XCell8_4 = ![(-3 / 11 : ℚ), (-7 / 44 : ℚ), (1 / 22 : ℚ), (1 / 44 : ℚ), (-2 / 11 : ℚ), (5 / 22 : ℚ), (5 / 44 : ℚ), (-7 / 44 : ℚ), (-1 / 4 : ℚ), (-3 / 22 : ℚ)] := by
  funext i
  fin_cases i <;> rfl

public theorem XCell8_4_scaled :
    toVec #v[-12, -7, 2, 1, -8, 10, 5, -7, -11, -6] = ((44 : ℤ) : ℚ) • XCell8_4 :=
  toVec_eq_smul10 #v[-12, -7, 2, 1, -8, 10, 5, -7, -11, -6] 44 XCell8_4
    (eq_smul_div (-12) 44 (-3) (11) (by decide) (by decide))
    (eq_smul_div (-7) 44 (-7) (44) (by decide) (by decide))
    (eq_smul_div (2) 44 (1) (22) (by decide) (by decide))
    (eq_smul_div (1) 44 (1) (44) (by decide) (by decide))
    (eq_smul_div (-8) 44 (-2) (11) (by decide) (by decide))
    (eq_smul_div (10) 44 (5) (22) (by decide) (by decide))
    (eq_smul_div (5) 44 (5) (44) (by decide) (by decide))
    (eq_smul_div (-7) 44 (-7) (44) (by decide) (by decide))
    (eq_smul_div (-11) 44 (-1) (4) (by decide) (by decide))
    (eq_smul_div (-6) 44 (-3) (22) (by decide) (by decide))

public def XCell8_5 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (-4 / 11 : ℚ)
  | 1 => (1 / 22 : ℚ)
  | 2 => (-1 / 22 : ℚ)
  | 3 => (-13 / 22 : ℚ)
  | 4 => (-1 / 22 : ℚ)
  | 5 => (-9 / 22 : ℚ)
  | 6 => (-2 / 11 : ℚ)
  | 7 => (1 / 11 : ℚ)
  | 8 => (-1 / 2 : ℚ)
  | 9 => 0
  | _ => 0

public theorem XCell8_5_def : XCell8_5 = ![(-4 / 11 : ℚ), (1 / 22 : ℚ), (-1 / 22 : ℚ), (-13 / 22 : ℚ), (-1 / 22 : ℚ), (-9 / 22 : ℚ), (-2 / 11 : ℚ), (1 / 11 : ℚ), (-1 / 2 : ℚ), 0] := by
  funext i
  fin_cases i <;> rfl

public theorem XCell8_5_scaled :
    toVec #v[-8, 1, -1, -13, -1, -9, -4, 2, -11, 0] = ((22 : ℤ) : ℚ) • XCell8_5 :=
  toVec_eq_smul10 #v[-8, 1, -1, -13, -1, -9, -4, 2, -11, 0] 22 XCell8_5
    (eq_smul_div (-8) 22 (-4) (11) (by decide) (by decide))
    (eq_smul_div (1) 22 (1) (22) (by decide) (by decide))
    (eq_smul_div (-1) 22 (-1) (22) (by decide) (by decide))
    (eq_smul_div (-13) 22 (-13) (22) (by decide) (by decide))
    (eq_smul_div (-1) 22 (-1) (22) (by decide) (by decide))
    (eq_smul_div (-9) 22 (-9) (22) (by decide) (by decide))
    (eq_smul_div (-4) 22 (-2) (11) (by decide) (by decide))
    (eq_smul_div (2) 22 (1) (11) (by decide) (by decide))
    (eq_smul_div (-11) 22 (-1) (2) (by decide) (by decide))
    (eq_smul_zero 22)

public def XCell8_6 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (3 / 11 : ℚ)
  | 1 => (-3 / 11 : ℚ)
  | 2 => (-2 / 11 : ℚ)
  | 3 => (1 / 11 : ℚ)
  | 4 => (-15 / 22 : ℚ)
  | 5 => (-1 / 22 : ℚ)
  | 6 => (3 / 22 : ℚ)
  | 7 => (-6 / 11 : ℚ)
  | 8 => (5 / 22 : ℚ)
  | 9 => 0
  | _ => 0

public theorem XCell8_6_def : XCell8_6 = ![(3 / 11 : ℚ), (-3 / 11 : ℚ), (-2 / 11 : ℚ), (1 / 11 : ℚ), (-15 / 22 : ℚ), (-1 / 22 : ℚ), (3 / 22 : ℚ), (-6 / 11 : ℚ), (5 / 22 : ℚ), 0] := by
  funext i
  fin_cases i <;> rfl

public theorem XCell8_6_scaled :
    toVec #v[6, -6, -4, 2, -15, -1, 3, -12, 5, 0] = ((22 : ℤ) : ℚ) • XCell8_6 :=
  toVec_eq_smul10 #v[6, -6, -4, 2, -15, -1, 3, -12, 5, 0] 22 XCell8_6
    (eq_smul_div (6) 22 (3) (11) (by decide) (by decide))
    (eq_smul_div (-6) 22 (-3) (11) (by decide) (by decide))
    (eq_smul_div (-4) 22 (-2) (11) (by decide) (by decide))
    (eq_smul_div (2) 22 (1) (11) (by decide) (by decide))
    (eq_smul_div (-15) 22 (-15) (22) (by decide) (by decide))
    (eq_smul_div (-1) 22 (-1) (22) (by decide) (by decide))
    (eq_smul_div (3) 22 (3) (22) (by decide) (by decide))
    (eq_smul_div (-12) 22 (-6) (11) (by decide) (by decide))
    (eq_smul_div (5) 22 (5) (22) (by decide) (by decide))
    (eq_smul_zero 22)

public def XCell8_7 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (7 / 22 : ℚ)
  | 1 => (-9 / 22 : ℚ)
  | 2 => (-4 / 11 : ℚ)
  | 3 => (3 / 22 : ℚ)
  | 4 => (2 / 11 : ℚ)
  | 5 => (5 / 22 : ℚ)
  | 6 => (-3 / 22 : ℚ)
  | 7 => (7 / 22 : ℚ)
  | 8 => (13 / 22 : ℚ)
  | 9 => (3 / 22 : ℚ)
  | _ => 0

public theorem XCell8_7_def : XCell8_7 = ![(7 / 22 : ℚ), (-9 / 22 : ℚ), (-4 / 11 : ℚ), (3 / 22 : ℚ), (2 / 11 : ℚ), (5 / 22 : ℚ), (-3 / 22 : ℚ), (7 / 22 : ℚ), (13 / 22 : ℚ), (3 / 22 : ℚ)] := by
  funext i
  fin_cases i <;> rfl

public theorem XCell8_7_scaled :
    toVec #v[7, -9, -8, 3, 4, 5, -3, 7, 13, 3] = ((22 : ℤ) : ℚ) • XCell8_7 :=
  toVec_eq_smul10 #v[7, -9, -8, 3, 4, 5, -3, 7, 13, 3] 22 XCell8_7
    (eq_smul_div (7) 22 (7) (22) (by decide) (by decide))
    (eq_smul_div (-9) 22 (-9) (22) (by decide) (by decide))
    (eq_smul_div (-8) 22 (-4) (11) (by decide) (by decide))
    (eq_smul_div (3) 22 (3) (22) (by decide) (by decide))
    (eq_smul_div (4) 22 (2) (11) (by decide) (by decide))
    (eq_smul_div (5) 22 (5) (22) (by decide) (by decide))
    (eq_smul_div (-3) 22 (-3) (22) (by decide) (by decide))
    (eq_smul_div (7) 22 (7) (22) (by decide) (by decide))
    (eq_smul_div (13) 22 (13) (22) (by decide) (by decide))
    (eq_smul_div (3) 22 (3) (22) (by decide) (by decide))

public def XCell8_8 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => 0
  | 1 => 0
  | 2 => 0
  | 3 => 0
  | 4 => 0
  | 5 => 0
  | 6 => 0
  | 7 => 0
  | 8 => 0
  | 9 => 0
  | _ => 0

public theorem XCell8_8_def : XCell8_8 = ![0, 0, 0, 0, 0, 0, 0, 0, 0, 0] := by
  funext i
  fin_cases i <;> rfl

public theorem XCell8_8_scaled :
    toVec #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0] = ((1 : ℤ) : ℚ) • XCell8_8 :=
  toVec_eq_smul10 #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0] 1 XCell8_8
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)

public def XCell8_9 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => 0
  | 1 => 0
  | 2 => 0
  | 3 => 0
  | 4 => 0
  | 5 => 0
  | 6 => 0
  | 7 => 0
  | 8 => 0
  | 9 => 0
  | _ => 0

public theorem XCell8_9_def : XCell8_9 = ![0, 0, 0, 0, 0, 0, 0, 0, 0, 0] := by
  funext i
  fin_cases i <;> rfl

public theorem XCell8_9_scaled :
    toVec #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0] = ((1 : ℤ) : ℚ) • XCell8_9 :=
  toVec_eq_smul10 #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0] 1 XCell8_9
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)

public def XCell8_10 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (1 / 4 : ℚ)
  | 1 => 0
  | 2 => (1 / 4 : ℚ)
  | 3 => (1 / 4 : ℚ)
  | 4 => 0
  | 5 => 0
  | 6 => 0
  | 7 => 0
  | 8 => (1 / 4 : ℚ)
  | 9 => (1 / 4 : ℚ)
  | _ => 0

public theorem XCell8_10_def : XCell8_10 = ![(1 / 4 : ℚ), 0, (1 / 4 : ℚ), (1 / 4 : ℚ), 0, 0, 0, 0, (1 / 4 : ℚ), (1 / 4 : ℚ)] := by
  funext i
  fin_cases i <;> rfl

public theorem XCell8_10_scaled :
    toVec #v[1, 0, 1, 1, 0, 0, 0, 0, 1, 1] = ((4 : ℤ) : ℚ) • XCell8_10 :=
  toVec_eq_smul10 #v[1, 0, 1, 1, 0, 0, 0, 0, 1, 1] 4 XCell8_10
    (eq_smul_div (1) 4 (1) (4) (by decide) (by decide))
    (eq_smul_zero 4)
    (eq_smul_div (1) 4 (1) (4) (by decide) (by decide))
    (eq_smul_div (1) 4 (1) (4) (by decide) (by decide))
    (eq_smul_zero 4)
    (eq_smul_zero 4)
    (eq_smul_zero 4)
    (eq_smul_zero 4)
    (eq_smul_div (1) 4 (1) (4) (by decide) (by decide))
    (eq_smul_div (1) 4 (1) (4) (by decide) (by decide))

public def XCell8_11 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (1 / 4 : ℚ)
  | 1 => 0
  | 2 => (-1 / 4 : ℚ)
  | 3 => 0
  | 4 => 0
  | 5 => (1 / 4 : ℚ)
  | 6 => (1 / 4 : ℚ)
  | 7 => 0
  | 8 => 0
  | 9 => (-1 / 4 : ℚ)
  | _ => 0

public theorem XCell8_11_def : XCell8_11 = ![(1 / 4 : ℚ), 0, (-1 / 4 : ℚ), 0, 0, (1 / 4 : ℚ), (1 / 4 : ℚ), 0, 0, (-1 / 4 : ℚ)] := by
  funext i
  fin_cases i <;> rfl

public theorem XCell8_11_scaled :
    toVec #v[1, 0, -1, 0, 0, 1, 1, 0, 0, -1] = ((4 : ℤ) : ℚ) • XCell8_11 :=
  toVec_eq_smul10 #v[1, 0, -1, 0, 0, 1, 1, 0, 0, -1] 4 XCell8_11
    (eq_smul_div (1) 4 (1) (4) (by decide) (by decide))
    (eq_smul_zero 4)
    (eq_smul_div (-1) 4 (-1) (4) (by decide) (by decide))
    (eq_smul_zero 4)
    (eq_smul_zero 4)
    (eq_smul_div (1) 4 (1) (4) (by decide) (by decide))
    (eq_smul_div (1) 4 (1) (4) (by decide) (by decide))
    (eq_smul_zero 4)
    (eq_smul_zero 4)
    (eq_smul_div (-1) 4 (-1) (4) (by decide) (by decide))

public def XCell8_12 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => 0
  | 1 => 0
  | 2 => 0
  | 3 => 0
  | 4 => 0
  | 5 => 0
  | 6 => 0
  | 7 => 0
  | 8 => 0
  | 9 => 0
  | _ => 0

public theorem XCell8_12_def : XCell8_12 = ![0, 0, 0, 0, 0, 0, 0, 0, 0, 0] := by
  funext i
  fin_cases i <;> rfl

public theorem XCell8_12_scaled :
    toVec #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0] = ((1 : ℤ) : ℚ) • XCell8_12 :=
  toVec_eq_smul10 #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0] 1 XCell8_12
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)

public def XCell8_13 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => 0
  | 1 => 0
  | 2 => 0
  | 3 => 0
  | 4 => 0
  | 5 => 0
  | 6 => 0
  | 7 => 0
  | 8 => 0
  | 9 => 0
  | _ => 0

public theorem XCell8_13_def : XCell8_13 = ![0, 0, 0, 0, 0, 0, 0, 0, 0, 0] := by
  funext i
  fin_cases i <;> rfl

public theorem XCell8_13_scaled :
    toVec #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0] = ((1 : ℤ) : ℚ) • XCell8_13 :=
  toVec_eq_smul10 #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0] 1 XCell8_13
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)

public def XCell8_14 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => 0
  | 1 => 0
  | 2 => 0
  | 3 => 0
  | 4 => 0
  | 5 => 0
  | 6 => 0
  | 7 => 0
  | 8 => 0
  | 9 => 0
  | _ => 0

public theorem XCell8_14_def : XCell8_14 = ![0, 0, 0, 0, 0, 0, 0, 0, 0, 0] := by
  funext i
  fin_cases i <;> rfl

public theorem XCell8_14_scaled :
    toVec #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0] = ((1 : ℤ) : ℚ) • XCell8_14 :=
  toVec_eq_smul10 #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0] 1 XCell8_14
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)

public def XCell8_15 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => 0
  | 1 => 0
  | 2 => 0
  | 3 => 0
  | 4 => 0
  | 5 => 0
  | 6 => 0
  | 7 => 0
  | 8 => 0
  | 9 => 0
  | _ => 0

public theorem XCell8_15_def : XCell8_15 = ![0, 0, 0, 0, 0, 0, 0, 0, 0, 0] := by
  funext i
  fin_cases i <;> rfl

public theorem XCell8_15_scaled :
    toVec #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0] = ((1 : ℤ) : ℚ) • XCell8_15 :=
  toVec_eq_smul10 #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0] 1 XCell8_15
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)

public def XCell8_16 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => 0
  | 1 => 0
  | 2 => 0
  | 3 => 0
  | 4 => 0
  | 5 => 0
  | 6 => 0
  | 7 => 0
  | 8 => 0
  | 9 => 0
  | _ => 0

public theorem XCell8_16_def : XCell8_16 = ![0, 0, 0, 0, 0, 0, 0, 0, 0, 0] := by
  funext i
  fin_cases i <;> rfl

public theorem XCell8_16_scaled :
    toVec #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0] = ((1 : ℤ) : ℚ) • XCell8_16 :=
  toVec_eq_smul10 #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0] 1 XCell8_16
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)

public def XCell8_17 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => 0
  | 1 => 0
  | 2 => 0
  | 3 => 0
  | 4 => 0
  | 5 => 0
  | 6 => 0
  | 7 => 0
  | 8 => 0
  | 9 => 0
  | _ => 0

public theorem XCell8_17_def : XCell8_17 = ![0, 0, 0, 0, 0, 0, 0, 0, 0, 0] := by
  funext i
  fin_cases i <;> rfl

public theorem XCell8_17_scaled :
    toVec #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0] = ((1 : ℤ) : ℚ) • XCell8_17 :=
  toVec_eq_smul10 #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0] 1 XCell8_17
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)

public def XCell8_18 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => 0
  | 1 => 0
  | 2 => 0
  | 3 => 0
  | 4 => 0
  | 5 => 0
  | 6 => 0
  | 7 => 0
  | 8 => 0
  | 9 => 0
  | _ => 0

public theorem XCell8_18_def : XCell8_18 = ![0, 0, 0, 0, 0, 0, 0, 0, 0, 0] := by
  funext i
  fin_cases i <;> rfl

public theorem XCell8_18_scaled :
    toVec #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0] = ((1 : ℤ) : ℚ) • XCell8_18 :=
  toVec_eq_smul10 #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0] 1 XCell8_18
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)

public def XCell8_19 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => 0
  | 1 => 0
  | 2 => 0
  | 3 => 0
  | 4 => 0
  | 5 => 0
  | 6 => 0
  | 7 => 0
  | 8 => 0
  | 9 => 0
  | _ => 0

public theorem XCell8_19_def : XCell8_19 = ![0, 0, 0, 0, 0, 0, 0, 0, 0, 0] := by
  funext i
  fin_cases i <;> rfl

public theorem XCell8_19_scaled :
    toVec #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0] = ((1 : ℤ) : ℚ) • XCell8_19 :=
  toVec_eq_smul10 #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0] 1 XCell8_19
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)

public def XRow8 (j : Fin 20) : Vec :=
  match j.val with
  | 0 => XCell8_0
  | 1 => XCell8_1
  | 2 => XCell8_2
  | 3 => XCell8_3
  | 4 => XCell8_4
  | 5 => XCell8_5
  | 6 => XCell8_6
  | 7 => XCell8_7
  | 8 => XCell8_8
  | 9 => XCell8_9
  | 10 => XCell8_10
  | 11 => XCell8_11
  | 12 => XCell8_12
  | 13 => XCell8_13
  | 14 => XCell8_14
  | 15 => XCell8_15
  | 16 => XCell8_16
  | 17 => XCell8_17
  | 18 => XCell8_18
  | 19 => XCell8_19
  | _ => 0

public def XCell9_0 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (-15 / 44 : ℚ)
  | 1 => (-3 / 44 : ℚ)
  | 2 => (-3 / 44 : ℚ)
  | 3 => (-2 / 11 : ℚ)
  | 4 => (1 / 22 : ℚ)
  | 5 => (-19 / 22 : ℚ)
  | 6 => (-29 / 44 : ℚ)
  | 7 => (6 / 11 : ℚ)
  | 8 => (-5 / 11 : ℚ)
  | 9 => (-9 / 44 : ℚ)
  | _ => 0

public theorem XCell9_0_def : XCell9_0 = ![(-15 / 44 : ℚ), (-3 / 44 : ℚ), (-3 / 44 : ℚ), (-2 / 11 : ℚ), (1 / 22 : ℚ), (-19 / 22 : ℚ), (-29 / 44 : ℚ), (6 / 11 : ℚ), (-5 / 11 : ℚ), (-9 / 44 : ℚ)] := by
  funext i
  fin_cases i <;> rfl

public theorem XCell9_0_scaled :
    toVec #v[-15, -3, -3, -8, 2, -38, -29, 24, -20, -9] = ((44 : ℤ) : ℚ) • XCell9_0 :=
  toVec_eq_smul10 #v[-15, -3, -3, -8, 2, -38, -29, 24, -20, -9] 44 XCell9_0
    (eq_smul_div (-15) 44 (-15) (44) (by decide) (by decide))
    (eq_smul_div (-3) 44 (-3) (44) (by decide) (by decide))
    (eq_smul_div (-3) 44 (-3) (44) (by decide) (by decide))
    (eq_smul_div (-8) 44 (-2) (11) (by decide) (by decide))
    (eq_smul_div (2) 44 (1) (22) (by decide) (by decide))
    (eq_smul_div (-38) 44 (-19) (22) (by decide) (by decide))
    (eq_smul_div (-29) 44 (-29) (44) (by decide) (by decide))
    (eq_smul_div (24) 44 (6) (11) (by decide) (by decide))
    (eq_smul_div (-20) 44 (-5) (11) (by decide) (by decide))
    (eq_smul_div (-9) 44 (-9) (44) (by decide) (by decide))

public def XCell9_1 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (57 / 44 : ℚ)
  | 1 => (15 / 44 : ℚ)
  | 2 => (13 / 22 : ℚ)
  | 3 => (49 / 44 : ℚ)
  | 4 => (15 / 44 : ℚ)
  | 5 => (8 / 11 : ℚ)
  | 6 => (17 / 44 : ℚ)
  | 7 => (3 / 11 : ℚ)
  | 8 => (43 / 44 : ℚ)
  | 9 => (31 / 44 : ℚ)
  | _ => 0

public theorem XCell9_1_def : XCell9_1 = ![(57 / 44 : ℚ), (15 / 44 : ℚ), (13 / 22 : ℚ), (49 / 44 : ℚ), (15 / 44 : ℚ), (8 / 11 : ℚ), (17 / 44 : ℚ), (3 / 11 : ℚ), (43 / 44 : ℚ), (31 / 44 : ℚ)] := by
  funext i
  fin_cases i <;> rfl

public theorem XCell9_1_scaled :
    toVec #v[57, 15, 26, 49, 15, 32, 17, 12, 43, 31] = ((44 : ℤ) : ℚ) • XCell9_1 :=
  toVec_eq_smul10 #v[57, 15, 26, 49, 15, 32, 17, 12, 43, 31] 44 XCell9_1
    (eq_smul_div (57) 44 (57) (44) (by decide) (by decide))
    (eq_smul_div (15) 44 (15) (44) (by decide) (by decide))
    (eq_smul_div (26) 44 (13) (22) (by decide) (by decide))
    (eq_smul_div (49) 44 (49) (44) (by decide) (by decide))
    (eq_smul_div (15) 44 (15) (44) (by decide) (by decide))
    (eq_smul_div (32) 44 (8) (11) (by decide) (by decide))
    (eq_smul_div (17) 44 (17) (44) (by decide) (by decide))
    (eq_smul_div (12) 44 (3) (11) (by decide) (by decide))
    (eq_smul_div (43) 44 (43) (44) (by decide) (by decide))
    (eq_smul_div (31) 44 (31) (44) (by decide) (by decide))

public def XCell9_2 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (-3 / 22 : ℚ)
  | 1 => (-5 / 44 : ℚ)
  | 2 => (1 / 44 : ℚ)
  | 3 => (7 / 44 : ℚ)
  | 4 => (1 / 11 : ℚ)
  | 5 => (-4 / 11 : ℚ)
  | 6 => (1 / 44 : ℚ)
  | 7 => (2 / 11 : ℚ)
  | 8 => (1 / 11 : ℚ)
  | 9 => (-9 / 44 : ℚ)
  | _ => 0

public theorem XCell9_2_def : XCell9_2 = ![(-3 / 22 : ℚ), (-5 / 44 : ℚ), (1 / 44 : ℚ), (7 / 44 : ℚ), (1 / 11 : ℚ), (-4 / 11 : ℚ), (1 / 44 : ℚ), (2 / 11 : ℚ), (1 / 11 : ℚ), (-9 / 44 : ℚ)] := by
  funext i
  fin_cases i <;> rfl

public theorem XCell9_2_scaled :
    toVec #v[-6, -5, 1, 7, 4, -16, 1, 8, 4, -9] = ((44 : ℤ) : ℚ) • XCell9_2 :=
  toVec_eq_smul10 #v[-6, -5, 1, 7, 4, -16, 1, 8, 4, -9] 44 XCell9_2
    (eq_smul_div (-6) 44 (-3) (22) (by decide) (by decide))
    (eq_smul_div (-5) 44 (-5) (44) (by decide) (by decide))
    (eq_smul_div (1) 44 (1) (44) (by decide) (by decide))
    (eq_smul_div (7) 44 (7) (44) (by decide) (by decide))
    (eq_smul_div (4) 44 (1) (11) (by decide) (by decide))
    (eq_smul_div (-16) 44 (-4) (11) (by decide) (by decide))
    (eq_smul_div (1) 44 (1) (44) (by decide) (by decide))
    (eq_smul_div (8) 44 (2) (11) (by decide) (by decide))
    (eq_smul_div (4) 44 (1) (11) (by decide) (by decide))
    (eq_smul_div (-9) 44 (-9) (44) (by decide) (by decide))

public def XCell9_3 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => 0
  | 1 => (1 / 44 : ℚ)
  | 2 => (-1 / 22 : ℚ)
  | 3 => (-2 / 11 : ℚ)
  | 4 => (13 / 22 : ℚ)
  | 5 => (3 / 44 : ℚ)
  | 6 => (-3 / 44 : ℚ)
  | 7 => (15 / 22 : ℚ)
  | 8 => (-7 / 44 : ℚ)
  | 9 => (-7 / 44 : ℚ)
  | _ => 0

public theorem XCell9_3_def : XCell9_3 = ![0, (1 / 44 : ℚ), (-1 / 22 : ℚ), (-2 / 11 : ℚ), (13 / 22 : ℚ), (3 / 44 : ℚ), (-3 / 44 : ℚ), (15 / 22 : ℚ), (-7 / 44 : ℚ), (-7 / 44 : ℚ)] := by
  funext i
  fin_cases i <;> rfl

public theorem XCell9_3_scaled :
    toVec #v[0, 1, -2, -8, 26, 3, -3, 30, -7, -7] = ((44 : ℤ) : ℚ) • XCell9_3 :=
  toVec_eq_smul10 #v[0, 1, -2, -8, 26, 3, -3, 30, -7, -7] 44 XCell9_3
    (eq_smul_zero 44)
    (eq_smul_div (1) 44 (1) (44) (by decide) (by decide))
    (eq_smul_div (-2) 44 (-1) (22) (by decide) (by decide))
    (eq_smul_div (-8) 44 (-2) (11) (by decide) (by decide))
    (eq_smul_div (26) 44 (13) (22) (by decide) (by decide))
    (eq_smul_div (3) 44 (3) (44) (by decide) (by decide))
    (eq_smul_div (-3) 44 (-3) (44) (by decide) (by decide))
    (eq_smul_div (30) 44 (15) (22) (by decide) (by decide))
    (eq_smul_div (-7) 44 (-7) (44) (by decide) (by decide))
    (eq_smul_div (-7) 44 (-7) (44) (by decide) (by decide))

public def XCell9_4 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (1 / 4 : ℚ)
  | 1 => (-15 / 22 : ℚ)
  | 2 => (-8 / 11 : ℚ)
  | 3 => (1 / 11 : ℚ)
  | 4 => (13 / 44 : ℚ)
  | 5 => (-27 / 44 : ℚ)
  | 6 => (-7 / 22 : ℚ)
  | 7 => (19 / 44 : ℚ)
  | 8 => (-19 / 44 : ℚ)
  | 9 => (-35 / 44 : ℚ)
  | _ => 0

public theorem XCell9_4_def : XCell9_4 = ![(1 / 4 : ℚ), (-15 / 22 : ℚ), (-8 / 11 : ℚ), (1 / 11 : ℚ), (13 / 44 : ℚ), (-27 / 44 : ℚ), (-7 / 22 : ℚ), (19 / 44 : ℚ), (-19 / 44 : ℚ), (-35 / 44 : ℚ)] := by
  funext i
  fin_cases i <;> rfl

public theorem XCell9_4_scaled :
    toVec #v[11, -30, -32, 4, 13, -27, -14, 19, -19, -35] = ((44 : ℤ) : ℚ) • XCell9_4 :=
  toVec_eq_smul10 #v[11, -30, -32, 4, 13, -27, -14, 19, -19, -35] 44 XCell9_4
    (eq_smul_div (11) 44 (1) (4) (by decide) (by decide))
    (eq_smul_div (-30) 44 (-15) (22) (by decide) (by decide))
    (eq_smul_div (-32) 44 (-8) (11) (by decide) (by decide))
    (eq_smul_div (4) 44 (1) (11) (by decide) (by decide))
    (eq_smul_div (13) 44 (13) (44) (by decide) (by decide))
    (eq_smul_div (-27) 44 (-27) (44) (by decide) (by decide))
    (eq_smul_div (-14) 44 (-7) (22) (by decide) (by decide))
    (eq_smul_div (19) 44 (19) (44) (by decide) (by decide))
    (eq_smul_div (-19) 44 (-19) (44) (by decide) (by decide))
    (eq_smul_div (-35) 44 (-35) (44) (by decide) (by decide))

public def XCell9_5 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (17 / 22 : ℚ)
  | 1 => (-17 / 22 : ℚ)
  | 2 => (-7 / 22 : ℚ)
  | 3 => (3 / 11 : ℚ)
  | 4 => (-4 / 11 : ℚ)
  | 5 => (1 / 11 : ℚ)
  | 6 => (-1 / 22 : ℚ)
  | 7 => (-4 / 11 : ℚ)
  | 8 => (-4 / 11 : ℚ)
  | 9 => (1 / 11 : ℚ)
  | _ => 0

public theorem XCell9_5_def : XCell9_5 = ![(17 / 22 : ℚ), (-17 / 22 : ℚ), (-7 / 22 : ℚ), (3 / 11 : ℚ), (-4 / 11 : ℚ), (1 / 11 : ℚ), (-1 / 22 : ℚ), (-4 / 11 : ℚ), (-4 / 11 : ℚ), (1 / 11 : ℚ)] := by
  funext i
  fin_cases i <;> rfl

public theorem XCell9_5_scaled :
    toVec #v[17, -17, -7, 6, -8, 2, -1, -8, -8, 2] = ((22 : ℤ) : ℚ) • XCell9_5 :=
  toVec_eq_smul10 #v[17, -17, -7, 6, -8, 2, -1, -8, -8, 2] 22 XCell9_5
    (eq_smul_div (17) 22 (17) (22) (by decide) (by decide))
    (eq_smul_div (-17) 22 (-17) (22) (by decide) (by decide))
    (eq_smul_div (-7) 22 (-7) (22) (by decide) (by decide))
    (eq_smul_div (6) 22 (3) (11) (by decide) (by decide))
    (eq_smul_div (-8) 22 (-4) (11) (by decide) (by decide))
    (eq_smul_div (2) 22 (1) (11) (by decide) (by decide))
    (eq_smul_div (-1) 22 (-1) (22) (by decide) (by decide))
    (eq_smul_div (-8) 22 (-4) (11) (by decide) (by decide))
    (eq_smul_div (-8) 22 (-4) (11) (by decide) (by decide))
    (eq_smul_div (2) 22 (1) (11) (by decide) (by decide))

public def XCell9_6 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (-6 / 11 : ℚ)
  | 1 => (1 / 11 : ℚ)
  | 2 => (-6 / 11 : ℚ)
  | 3 => -1
  | 4 => (4 / 11 : ℚ)
  | 5 => (-23 / 22 : ℚ)
  | 6 => (-13 / 11 : ℚ)
  | 7 => (5 / 22 : ℚ)
  | 8 => (-6 / 11 : ℚ)
  | 9 => (-9 / 11 : ℚ)
  | _ => 0

public theorem XCell9_6_def : XCell9_6 = ![(-6 / 11 : ℚ), (1 / 11 : ℚ), (-6 / 11 : ℚ), -1, (4 / 11 : ℚ), (-23 / 22 : ℚ), (-13 / 11 : ℚ), (5 / 22 : ℚ), (-6 / 11 : ℚ), (-9 / 11 : ℚ)] := by
  funext i
  fin_cases i <;> rfl

public theorem XCell9_6_scaled :
    toVec #v[-12, 2, -12, -22, 8, -23, -26, 5, -12, -18] = ((22 : ℤ) : ℚ) • XCell9_6 :=
  toVec_eq_smul10 #v[-12, 2, -12, -22, 8, -23, -26, 5, -12, -18] 22 XCell9_6
    (eq_smul_div (-12) 22 (-6) (11) (by decide) (by decide))
    (eq_smul_div (2) 22 (1) (11) (by decide) (by decide))
    (eq_smul_div (-12) 22 (-6) (11) (by decide) (by decide))
    (eq_smul_int (-22) 22 (-1) (by decide))
    (eq_smul_div (8) 22 (4) (11) (by decide) (by decide))
    (eq_smul_div (-23) 22 (-23) (22) (by decide) (by decide))
    (eq_smul_div (-26) 22 (-13) (11) (by decide) (by decide))
    (eq_smul_div (5) 22 (5) (22) (by decide) (by decide))
    (eq_smul_div (-12) 22 (-6) (11) (by decide) (by decide))
    (eq_smul_div (-18) 22 (-9) (11) (by decide) (by decide))

public def XCell9_7 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (-17 / 22 : ℚ)
  | 1 => (6 / 11 : ℚ)
  | 2 => (8 / 11 : ℚ)
  | 3 => (-1 / 2 : ℚ)
  | 4 => (-3 / 11 : ℚ)
  | 5 => (3 / 22 : ℚ)
  | 6 => (-1 / 11 : ℚ)
  | 7 => (-1 / 22 : ℚ)
  | 8 => (-7 / 22 : ℚ)
  | 9 => (13 / 22 : ℚ)
  | _ => 0

public theorem XCell9_7_def : XCell9_7 = ![(-17 / 22 : ℚ), (6 / 11 : ℚ), (8 / 11 : ℚ), (-1 / 2 : ℚ), (-3 / 11 : ℚ), (3 / 22 : ℚ), (-1 / 11 : ℚ), (-1 / 22 : ℚ), (-7 / 22 : ℚ), (13 / 22 : ℚ)] := by
  funext i
  fin_cases i <;> rfl

public theorem XCell9_7_scaled :
    toVec #v[-17, 12, 16, -11, -6, 3, -2, -1, -7, 13] = ((22 : ℤ) : ℚ) • XCell9_7 :=
  toVec_eq_smul10 #v[-17, 12, 16, -11, -6, 3, -2, -1, -7, 13] 22 XCell9_7
    (eq_smul_div (-17) 22 (-17) (22) (by decide) (by decide))
    (eq_smul_div (12) 22 (6) (11) (by decide) (by decide))
    (eq_smul_div (16) 22 (8) (11) (by decide) (by decide))
    (eq_smul_div (-11) 22 (-1) (2) (by decide) (by decide))
    (eq_smul_div (-6) 22 (-3) (11) (by decide) (by decide))
    (eq_smul_div (3) 22 (3) (22) (by decide) (by decide))
    (eq_smul_div (-2) 22 (-1) (11) (by decide) (by decide))
    (eq_smul_div (-1) 22 (-1) (22) (by decide) (by decide))
    (eq_smul_div (-7) 22 (-7) (22) (by decide) (by decide))
    (eq_smul_div (13) 22 (13) (22) (by decide) (by decide))

public def XCell9_8 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => 0
  | 1 => 0
  | 2 => 0
  | 3 => 0
  | 4 => 0
  | 5 => 0
  | 6 => 0
  | 7 => 0
  | 8 => 0
  | 9 => 0
  | _ => 0

public theorem XCell9_8_def : XCell9_8 = ![0, 0, 0, 0, 0, 0, 0, 0, 0, 0] := by
  funext i
  fin_cases i <;> rfl

public theorem XCell9_8_scaled :
    toVec #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0] = ((1 : ℤ) : ℚ) • XCell9_8 :=
  toVec_eq_smul10 #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0] 1 XCell9_8
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)

public def XCell9_9 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => 0
  | 1 => 0
  | 2 => 0
  | 3 => 0
  | 4 => 0
  | 5 => 0
  | 6 => 0
  | 7 => 0
  | 8 => 0
  | 9 => 0
  | _ => 0

public theorem XCell9_9_def : XCell9_9 = ![0, 0, 0, 0, 0, 0, 0, 0, 0, 0] := by
  funext i
  fin_cases i <;> rfl

public theorem XCell9_9_scaled :
    toVec #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0] = ((1 : ℤ) : ℚ) • XCell9_9 :=
  toVec_eq_smul10 #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0] 1 XCell9_9
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)

public def XCell9_10 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (1 / 4 : ℚ)
  | 1 => 0
  | 2 => (-1 / 4 : ℚ)
  | 3 => 0
  | 4 => 0
  | 5 => (-1 / 4 : ℚ)
  | 6 => (-1 / 4 : ℚ)
  | 7 => 0
  | 8 => 0
  | 9 => (-1 / 4 : ℚ)
  | _ => 0

public theorem XCell9_10_def : XCell9_10 = ![(1 / 4 : ℚ), 0, (-1 / 4 : ℚ), 0, 0, (-1 / 4 : ℚ), (-1 / 4 : ℚ), 0, 0, (-1 / 4 : ℚ)] := by
  funext i
  fin_cases i <;> rfl

public theorem XCell9_10_scaled :
    toVec #v[1, 0, -1, 0, 0, -1, -1, 0, 0, -1] = ((4 : ℤ) : ℚ) • XCell9_10 :=
  toVec_eq_smul10 #v[1, 0, -1, 0, 0, -1, -1, 0, 0, -1] 4 XCell9_10
    (eq_smul_div (1) 4 (1) (4) (by decide) (by decide))
    (eq_smul_zero 4)
    (eq_smul_div (-1) 4 (-1) (4) (by decide) (by decide))
    (eq_smul_zero 4)
    (eq_smul_zero 4)
    (eq_smul_div (-1) 4 (-1) (4) (by decide) (by decide))
    (eq_smul_div (-1) 4 (-1) (4) (by decide) (by decide))
    (eq_smul_zero 4)
    (eq_smul_zero 4)
    (eq_smul_div (-1) 4 (-1) (4) (by decide) (by decide))

public def XCell9_11 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (1 / 2 : ℚ)
  | 1 => 0
  | 2 => 0
  | 3 => (1 / 2 : ℚ)
  | 4 => (1 / 2 : ℚ)
  | 5 => (-1 / 4 : ℚ)
  | 6 => (-1 / 4 : ℚ)
  | 7 => (1 / 2 : ℚ)
  | 8 => (1 / 2 : ℚ)
  | 9 => 0
  | _ => 0

public theorem XCell9_11_def : XCell9_11 = ![(1 / 2 : ℚ), 0, 0, (1 / 2 : ℚ), (1 / 2 : ℚ), (-1 / 4 : ℚ), (-1 / 4 : ℚ), (1 / 2 : ℚ), (1 / 2 : ℚ), 0] := by
  funext i
  fin_cases i <;> rfl

public theorem XCell9_11_scaled :
    toVec #v[2, 0, 0, 2, 2, -1, -1, 2, 2, 0] = ((4 : ℤ) : ℚ) • XCell9_11 :=
  toVec_eq_smul10 #v[2, 0, 0, 2, 2, -1, -1, 2, 2, 0] 4 XCell9_11
    (eq_smul_div (2) 4 (1) (2) (by decide) (by decide))
    (eq_smul_zero 4)
    (eq_smul_zero 4)
    (eq_smul_div (2) 4 (1) (2) (by decide) (by decide))
    (eq_smul_div (2) 4 (1) (2) (by decide) (by decide))
    (eq_smul_div (-1) 4 (-1) (4) (by decide) (by decide))
    (eq_smul_div (-1) 4 (-1) (4) (by decide) (by decide))
    (eq_smul_div (2) 4 (1) (2) (by decide) (by decide))
    (eq_smul_div (2) 4 (1) (2) (by decide) (by decide))
    (eq_smul_zero 4)

public def XCell9_12 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => 0
  | 1 => 0
  | 2 => 0
  | 3 => 0
  | 4 => 0
  | 5 => 0
  | 6 => 0
  | 7 => 0
  | 8 => 0
  | 9 => 0
  | _ => 0

public theorem XCell9_12_def : XCell9_12 = ![0, 0, 0, 0, 0, 0, 0, 0, 0, 0] := by
  funext i
  fin_cases i <;> rfl

public theorem XCell9_12_scaled :
    toVec #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0] = ((1 : ℤ) : ℚ) • XCell9_12 :=
  toVec_eq_smul10 #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0] 1 XCell9_12
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)

public def XCell9_13 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => 0
  | 1 => 0
  | 2 => 0
  | 3 => 0
  | 4 => 0
  | 5 => 0
  | 6 => 0
  | 7 => 0
  | 8 => 0
  | 9 => 0
  | _ => 0

public theorem XCell9_13_def : XCell9_13 = ![0, 0, 0, 0, 0, 0, 0, 0, 0, 0] := by
  funext i
  fin_cases i <;> rfl

public theorem XCell9_13_scaled :
    toVec #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0] = ((1 : ℤ) : ℚ) • XCell9_13 :=
  toVec_eq_smul10 #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0] 1 XCell9_13
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)

public def XCell9_14 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => 0
  | 1 => 0
  | 2 => 0
  | 3 => 0
  | 4 => 0
  | 5 => 0
  | 6 => 0
  | 7 => 0
  | 8 => 0
  | 9 => 0
  | _ => 0

public theorem XCell9_14_def : XCell9_14 = ![0, 0, 0, 0, 0, 0, 0, 0, 0, 0] := by
  funext i
  fin_cases i <;> rfl

public theorem XCell9_14_scaled :
    toVec #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0] = ((1 : ℤ) : ℚ) • XCell9_14 :=
  toVec_eq_smul10 #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0] 1 XCell9_14
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)

public def XCell9_15 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => 0
  | 1 => 0
  | 2 => 0
  | 3 => 0
  | 4 => 0
  | 5 => 0
  | 6 => 0
  | 7 => 0
  | 8 => 0
  | 9 => 0
  | _ => 0

public theorem XCell9_15_def : XCell9_15 = ![0, 0, 0, 0, 0, 0, 0, 0, 0, 0] := by
  funext i
  fin_cases i <;> rfl

public theorem XCell9_15_scaled :
    toVec #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0] = ((1 : ℤ) : ℚ) • XCell9_15 :=
  toVec_eq_smul10 #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0] 1 XCell9_15
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)

public def XCell9_16 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => 0
  | 1 => 0
  | 2 => 0
  | 3 => 0
  | 4 => 0
  | 5 => 0
  | 6 => 0
  | 7 => 0
  | 8 => 0
  | 9 => 0
  | _ => 0

public theorem XCell9_16_def : XCell9_16 = ![0, 0, 0, 0, 0, 0, 0, 0, 0, 0] := by
  funext i
  fin_cases i <;> rfl

public theorem XCell9_16_scaled :
    toVec #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0] = ((1 : ℤ) : ℚ) • XCell9_16 :=
  toVec_eq_smul10 #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0] 1 XCell9_16
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)

public def XCell9_17 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => 0
  | 1 => 0
  | 2 => 0
  | 3 => 0
  | 4 => 0
  | 5 => 0
  | 6 => 0
  | 7 => 0
  | 8 => 0
  | 9 => 0
  | _ => 0

public theorem XCell9_17_def : XCell9_17 = ![0, 0, 0, 0, 0, 0, 0, 0, 0, 0] := by
  funext i
  fin_cases i <;> rfl

public theorem XCell9_17_scaled :
    toVec #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0] = ((1 : ℤ) : ℚ) • XCell9_17 :=
  toVec_eq_smul10 #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0] 1 XCell9_17
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)

public def XCell9_18 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => 0
  | 1 => 0
  | 2 => 0
  | 3 => 0
  | 4 => 0
  | 5 => 0
  | 6 => 0
  | 7 => 0
  | 8 => 0
  | 9 => 0
  | _ => 0

public theorem XCell9_18_def : XCell9_18 = ![0, 0, 0, 0, 0, 0, 0, 0, 0, 0] := by
  funext i
  fin_cases i <;> rfl

public theorem XCell9_18_scaled :
    toVec #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0] = ((1 : ℤ) : ℚ) • XCell9_18 :=
  toVec_eq_smul10 #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0] 1 XCell9_18
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)

public def XCell9_19 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => 0
  | 1 => 0
  | 2 => 0
  | 3 => 0
  | 4 => 0
  | 5 => 0
  | 6 => 0
  | 7 => 0
  | 8 => 0
  | 9 => 0
  | _ => 0

public theorem XCell9_19_def : XCell9_19 = ![0, 0, 0, 0, 0, 0, 0, 0, 0, 0] := by
  funext i
  fin_cases i <;> rfl

public theorem XCell9_19_scaled :
    toVec #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0] = ((1 : ℤ) : ℚ) • XCell9_19 :=
  toVec_eq_smul10 #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0] 1 XCell9_19
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)
    (eq_smul_zero 1)

public def XRow9 (j : Fin 20) : Vec :=
  match j.val with
  | 0 => XCell9_0
  | 1 => XCell9_1
  | 2 => XCell9_2
  | 3 => XCell9_3
  | 4 => XCell9_4
  | 5 => XCell9_5
  | 6 => XCell9_6
  | 7 => XCell9_7
  | 8 => XCell9_8
  | 9 => XCell9_9
  | 10 => XCell9_10
  | 11 => XCell9_11
  | 12 => XCell9_12
  | 13 => XCell9_13
  | 14 => XCell9_14
  | 15 => XCell9_15
  | 16 => XCell9_16
  | 17 => XCell9_17
  | 18 => XCell9_18
  | 19 => XCell9_19
  | _ => 0

public def ACell0_0 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (-12 / 11 : ℚ)
  | 1 => (-1 / 11 : ℚ)
  | 2 => 0
  | 3 => 0
  | 4 => (-1 / 11 : ℚ)
  | 5 => (1 / 11 : ℚ)
  | 6 => (2 / 11 : ℚ)
  | 7 => (1 / 11 : ℚ)
  | 8 => (-1 / 11 : ℚ)
  | 9 => 0
  | _ => 0

public theorem ACell0_0_def : ACell0_0 = ![(-12 / 11 : ℚ), (-1 / 11 : ℚ), 0, 0, (-1 / 11 : ℚ), (1 / 11 : ℚ), (2 / 11 : ℚ), (1 / 11 : ℚ), (-1 / 11 : ℚ), 0] := by
  funext i
  fin_cases i <;> rfl

public theorem ACell0_0_scaled :
    toVec #v[-12, -1, 0, 0, -1, 1, 2, 1, -1, 0] = ((11 : ℤ) : ℚ) • ACell0_0 :=
  toVec_eq_smul10 #v[-12, -1, 0, 0, -1, 1, 2, 1, -1, 0] 11 ACell0_0
    (eq_smul_div (-12) 11 (-12) (11) (by decide) (by decide))
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_zero 11)
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_zero 11)

public def ACell0_1 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (-1 / 11 : ℚ)
  | 1 => 0
  | 2 => (1 / 11 : ℚ)
  | 3 => (-1 / 11 : ℚ)
  | 4 => (2 / 11 : ℚ)
  | 5 => (-1 / 11 : ℚ)
  | 6 => (1 / 11 : ℚ)
  | 7 => 0
  | 8 => (-1 / 11 : ℚ)
  | 9 => 0
  | _ => 0

public theorem ACell0_1_def : ACell0_1 = ![(-1 / 11 : ℚ), 0, (1 / 11 : ℚ), (-1 / 11 : ℚ), (2 / 11 : ℚ), (-1 / 11 : ℚ), (1 / 11 : ℚ), 0, (-1 / 11 : ℚ), 0] := by
  funext i
  fin_cases i <;> rfl

public theorem ACell0_1_scaled :
    toVec #v[-1, 0, 1, -1, 2, -1, 1, 0, -1, 0] = ((11 : ℤ) : ℚ) • ACell0_1 :=
  toVec_eq_smul10 #v[-1, 0, 1, -1, 2, -1, 1, 0, -1, 0] 11 ACell0_1
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_zero 11)

public def ACell0_2 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (1 / 11 : ℚ)
  | 1 => (-1 / 11 : ℚ)
  | 2 => (-1 / 11 : ℚ)
  | 3 => (-1 / 11 : ℚ)
  | 4 => (-1 / 11 : ℚ)
  | 5 => (1 / 11 : ℚ)
  | 6 => 0
  | 7 => 0
  | 8 => (2 / 11 : ℚ)
  | 9 => 0
  | _ => 0

public theorem ACell0_2_def : ACell0_2 = ![(1 / 11 : ℚ), (-1 / 11 : ℚ), (-1 / 11 : ℚ), (-1 / 11 : ℚ), (-1 / 11 : ℚ), (1 / 11 : ℚ), 0, 0, (2 / 11 : ℚ), 0] := by
  funext i
  fin_cases i <;> rfl

public theorem ACell0_2_scaled :
    toVec #v[1, -1, -1, -1, -1, 1, 0, 0, 2, 0] = ((11 : ℤ) : ℚ) • ACell0_2 :=
  toVec_eq_smul10 #v[1, -1, -1, -1, -1, 1, 0, 0, 2, 0] 11 ACell0_2
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_zero 11)
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_zero 11)

public def ACell0_3 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (2 / 11 : ℚ)
  | 1 => (1 / 11 : ℚ)
  | 2 => (1 / 11 : ℚ)
  | 3 => (2 / 11 : ℚ)
  | 4 => 0
  | 5 => 0
  | 6 => (1 / 11 : ℚ)
  | 7 => (3 / 11 : ℚ)
  | 8 => (1 / 11 : ℚ)
  | 9 => 0
  | _ => 0

public theorem ACell0_3_def : ACell0_3 = ![(2 / 11 : ℚ), (1 / 11 : ℚ), (1 / 11 : ℚ), (2 / 11 : ℚ), 0, 0, (1 / 11 : ℚ), (3 / 11 : ℚ), (1 / 11 : ℚ), 0] := by
  funext i
  fin_cases i <;> rfl

public theorem ACell0_3_scaled :
    toVec #v[2, 1, 1, 2, 0, 0, 1, 3, 1, 0] = ((11 : ℤ) : ℚ) • ACell0_3 :=
  toVec_eq_smul10 #v[2, 1, 1, 2, 0, 0, 1, 3, 1, 0] 11 ACell0_3
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_zero 11)
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))
    (eq_smul_div (3) 11 (3) (11) (by decide) (by decide))
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))
    (eq_smul_zero 11)

public def ACell0_4 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (-1 / 11 : ℚ)
  | 1 => (2 / 11 : ℚ)
  | 2 => (-1 / 11 : ℚ)
  | 3 => 0
  | 4 => (-1 / 11 : ℚ)
  | 5 => 0
  | 6 => (1 / 11 : ℚ)
  | 7 => (1 / 11 : ℚ)
  | 8 => 0
  | 9 => (-1 / 11 : ℚ)
  | _ => 0

public theorem ACell0_4_def : ACell0_4 = ![(-1 / 11 : ℚ), (2 / 11 : ℚ), (-1 / 11 : ℚ), 0, (-1 / 11 : ℚ), 0, (1 / 11 : ℚ), (1 / 11 : ℚ), 0, (-1 / 11 : ℚ)] := by
  funext i
  fin_cases i <;> rfl

public theorem ACell0_4_scaled :
    toVec #v[-1, 2, -1, 0, -1, 0, 1, 1, 0, -1] = ((11 : ℤ) : ℚ) • ACell0_4 :=
  toVec_eq_smul10 #v[-1, 2, -1, 0, -1, 0, 1, 1, 0, -1] 11 ACell0_4
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))

public def ACell0_5 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => 0
  | 1 => 0
  | 2 => (2 / 11 : ℚ)
  | 3 => 0
  | 4 => 0
  | 5 => (-2 / 11 : ℚ)
  | 6 => (-2 / 11 : ℚ)
  | 7 => 0
  | 8 => 0
  | 9 => (2 / 11 : ℚ)
  | _ => 0

public theorem ACell0_5_def : ACell0_5 = ![0, 0, (2 / 11 : ℚ), 0, 0, (-2 / 11 : ℚ), (-2 / 11 : ℚ), 0, 0, (2 / 11 : ℚ)] := by
  funext i
  fin_cases i <;> rfl

public theorem ACell0_5_scaled :
    toVec #v[0, 0, 2, 0, 0, -2, -2, 0, 0, 2] = ((11 : ℤ) : ℚ) • ACell0_5 :=
  toVec_eq_smul10 #v[0, 0, 2, 0, 0, -2, -2, 0, 0, 2] 11 ACell0_5
    (eq_smul_zero 11)
    (eq_smul_zero 11)
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_zero 11)
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_zero 11)
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))

public def ACell0_6 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => 0
  | 1 => (2 / 11 : ℚ)
  | 2 => (-2 / 11 : ℚ)
  | 3 => 0
  | 4 => 0
  | 5 => 0
  | 6 => 0
  | 7 => (-2 / 11 : ℚ)
  | 8 => (2 / 11 : ℚ)
  | 9 => 0
  | _ => 0

public theorem ACell0_6_def : ACell0_6 = ![0, (2 / 11 : ℚ), (-2 / 11 : ℚ), 0, 0, 0, 0, (-2 / 11 : ℚ), (2 / 11 : ℚ), 0] := by
  funext i
  fin_cases i <;> rfl

public theorem ACell0_6_scaled :
    toVec #v[0, 2, -2, 0, 0, 0, 0, -2, 2, 0] = ((11 : ℤ) : ℚ) • ACell0_6 :=
  toVec_eq_smul10 #v[0, 2, -2, 0, 0, 0, 0, -2, 2, 0] 11 ACell0_6
    (eq_smul_zero 11)
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_zero 11)
    (eq_smul_zero 11)
    (eq_smul_zero 11)
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_zero 11)

public def ACell0_7 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => 0
  | 1 => 0
  | 2 => (2 / 11 : ℚ)
  | 3 => (-2 / 11 : ℚ)
  | 4 => (-2 / 11 : ℚ)
  | 5 => (2 / 11 : ℚ)
  | 6 => 0
  | 7 => 0
  | 8 => 0
  | 9 => 0
  | _ => 0

public theorem ACell0_7_def : ACell0_7 = ![0, 0, (2 / 11 : ℚ), (-2 / 11 : ℚ), (-2 / 11 : ℚ), (2 / 11 : ℚ), 0, 0, 0, 0] := by
  funext i
  fin_cases i <;> rfl

public theorem ACell0_7_scaled :
    toVec #v[0, 0, 2, -2, -2, 2, 0, 0, 0, 0] = ((11 : ℤ) : ℚ) • ACell0_7 :=
  toVec_eq_smul10 #v[0, 0, 2, -2, -2, 2, 0, 0, 0, 0] 11 ACell0_7
    (eq_smul_zero 11)
    (eq_smul_zero 11)
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_zero 11)
    (eq_smul_zero 11)
    (eq_smul_zero 11)

public def ACell0_8 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => 0
  | 1 => (-2 / 11 : ℚ)
  | 2 => 0
  | 3 => (-2 / 11 : ℚ)
  | 4 => 0
  | 5 => 0
  | 6 => (2 / 11 : ℚ)
  | 7 => 0
  | 8 => 0
  | 9 => (2 / 11 : ℚ)
  | _ => 0

public theorem ACell0_8_def : ACell0_8 = ![0, (-2 / 11 : ℚ), 0, (-2 / 11 : ℚ), 0, 0, (2 / 11 : ℚ), 0, 0, (2 / 11 : ℚ)] := by
  funext i
  fin_cases i <;> rfl

public theorem ACell0_8_scaled :
    toVec #v[0, -2, 0, -2, 0, 0, 2, 0, 0, 2] = ((11 : ℤ) : ℚ) • ACell0_8 :=
  toVec_eq_smul10 #v[0, -2, 0, -2, 0, 0, 2, 0, 0, 2] 11 ACell0_8
    (eq_smul_zero 11)
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_zero 11)
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_zero 11)
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))

public def ACell0_9 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => 0
  | 1 => 0
  | 2 => (2 / 11 : ℚ)
  | 3 => 0
  | 4 => (-2 / 11 : ℚ)
  | 5 => 0
  | 6 => (-2 / 11 : ℚ)
  | 7 => 0
  | 8 => (2 / 11 : ℚ)
  | 9 => 0
  | _ => 0

public theorem ACell0_9_def : ACell0_9 = ![0, 0, (2 / 11 : ℚ), 0, (-2 / 11 : ℚ), 0, (-2 / 11 : ℚ), 0, (2 / 11 : ℚ), 0] := by
  funext i
  fin_cases i <;> rfl

public theorem ACell0_9_scaled :
    toVec #v[0, 0, 2, 0, -2, 0, -2, 0, 2, 0] = ((11 : ℤ) : ℚ) • ACell0_9 :=
  toVec_eq_smul10 #v[0, 0, 2, 0, -2, 0, -2, 0, 2, 0] 11 ACell0_9
    (eq_smul_zero 11)
    (eq_smul_zero 11)
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_zero 11)

public def ARow0 (j : Fin 10) : Vec :=
  match j.val with
  | 0 => ACell0_0
  | 1 => ACell0_1
  | 2 => ACell0_2
  | 3 => ACell0_3
  | 4 => ACell0_4
  | 5 => ACell0_5
  | 6 => ACell0_6
  | 7 => ACell0_7
  | 8 => ACell0_8
  | 9 => ACell0_9
  | _ => 0

public def ACell1_0 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (-1 / 11 : ℚ)
  | 1 => 0
  | 2 => (1 / 11 : ℚ)
  | 3 => (-1 / 11 : ℚ)
  | 4 => (2 / 11 : ℚ)
  | 5 => (-1 / 11 : ℚ)
  | 6 => (1 / 11 : ℚ)
  | 7 => 0
  | 8 => (-1 / 11 : ℚ)
  | 9 => 0
  | _ => 0

public theorem ACell1_0_def : ACell1_0 = ![(-1 / 11 : ℚ), 0, (1 / 11 : ℚ), (-1 / 11 : ℚ), (2 / 11 : ℚ), (-1 / 11 : ℚ), (1 / 11 : ℚ), 0, (-1 / 11 : ℚ), 0] := by
  funext i
  fin_cases i <;> rfl

public theorem ACell1_0_scaled :
    toVec #v[-1, 0, 1, -1, 2, -1, 1, 0, -1, 0] = ((11 : ℤ) : ℚ) • ACell1_0 :=
  toVec_eq_smul10 #v[-1, 0, 1, -1, 2, -1, 1, 0, -1, 0] 11 ACell1_0
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_zero 11)

public def ACell1_1 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => -1
  | 1 => (1 / 11 : ℚ)
  | 2 => (3 / 11 : ℚ)
  | 3 => (1 / 11 : ℚ)
  | 4 => 0
  | 5 => 0
  | 6 => (2 / 11 : ℚ)
  | 7 => (1 / 11 : ℚ)
  | 8 => (1 / 11 : ℚ)
  | 9 => (2 / 11 : ℚ)
  | _ => 0

public theorem ACell1_1_def : ACell1_1 = ![-1, (1 / 11 : ℚ), (3 / 11 : ℚ), (1 / 11 : ℚ), 0, 0, (2 / 11 : ℚ), (1 / 11 : ℚ), (1 / 11 : ℚ), (2 / 11 : ℚ)] := by
  funext i
  fin_cases i <;> rfl

public theorem ACell1_1_scaled :
    toVec #v[-11, 1, 3, 1, 0, 0, 2, 1, 1, 2] = ((11 : ℤ) : ℚ) • ACell1_1 :=
  toVec_eq_smul10 #v[-11, 1, 3, 1, 0, 0, 2, 1, 1, 2] 11 ACell1_1
    (eq_smul_int (-11) 11 (-1) (by decide))
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))
    (eq_smul_div (3) 11 (3) (11) (by decide) (by decide))
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_zero 11)
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))

public def ACell1_2 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (1 / 11 : ℚ)
  | 1 => (1 / 11 : ℚ)
  | 2 => 0
  | 3 => (-1 / 11 : ℚ)
  | 4 => 0
  | 5 => (-1 / 11 : ℚ)
  | 6 => (2 / 11 : ℚ)
  | 7 => (-1 / 11 : ℚ)
  | 8 => 0
  | 9 => (-1 / 11 : ℚ)
  | _ => 0

public theorem ACell1_2_def : ACell1_2 = ![(1 / 11 : ℚ), (1 / 11 : ℚ), 0, (-1 / 11 : ℚ), 0, (-1 / 11 : ℚ), (2 / 11 : ℚ), (-1 / 11 : ℚ), 0, (-1 / 11 : ℚ)] := by
  funext i
  fin_cases i <;> rfl

public theorem ACell1_2_scaled :
    toVec #v[1, 1, 0, -1, 0, -1, 2, -1, 0, -1] = ((11 : ℤ) : ℚ) • ACell1_2 :=
  toVec_eq_smul10 #v[1, 1, 0, -1, 0, -1, 2, -1, 0, -1] 11 ACell1_2
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))

public def ACell1_3 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => 0
  | 1 => 0
  | 2 => (2 / 11 : ℚ)
  | 3 => (1 / 11 : ℚ)
  | 4 => (1 / 11 : ℚ)
  | 5 => (3 / 11 : ℚ)
  | 6 => (1 / 11 : ℚ)
  | 7 => (1 / 11 : ℚ)
  | 8 => (2 / 11 : ℚ)
  | 9 => 0
  | _ => 0

public theorem ACell1_3_def : ACell1_3 = ![0, 0, (2 / 11 : ℚ), (1 / 11 : ℚ), (1 / 11 : ℚ), (3 / 11 : ℚ), (1 / 11 : ℚ), (1 / 11 : ℚ), (2 / 11 : ℚ), 0] := by
  funext i
  fin_cases i <;> rfl

public theorem ACell1_3_scaled :
    toVec #v[0, 0, 2, 1, 1, 3, 1, 1, 2, 0] = ((11 : ℤ) : ℚ) • ACell1_3 :=
  toVec_eq_smul10 #v[0, 0, 2, 1, 1, 3, 1, 1, 2, 0] 11 ACell1_3
    (eq_smul_zero 11)
    (eq_smul_zero 11)
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))
    (eq_smul_div (3) 11 (3) (11) (by decide) (by decide))
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_zero 11)

public def ACell1_4 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (-1 / 11 : ℚ)
  | 1 => (-3 / 11 : ℚ)
  | 2 => (-2 / 11 : ℚ)
  | 3 => (-2 / 11 : ℚ)
  | 4 => (-3 / 11 : ℚ)
  | 5 => (-3 / 11 : ℚ)
  | 6 => (-2 / 11 : ℚ)
  | 7 => (-2 / 11 : ℚ)
  | 8 => (-3 / 11 : ℚ)
  | 9 => (-1 / 11 : ℚ)
  | _ => 0

public theorem ACell1_4_def : ACell1_4 = ![(-1 / 11 : ℚ), (-3 / 11 : ℚ), (-2 / 11 : ℚ), (-2 / 11 : ℚ), (-3 / 11 : ℚ), (-3 / 11 : ℚ), (-2 / 11 : ℚ), (-2 / 11 : ℚ), (-3 / 11 : ℚ), (-1 / 11 : ℚ)] := by
  funext i
  fin_cases i <;> rfl

public theorem ACell1_4_scaled :
    toVec #v[-1, -3, -2, -2, -3, -3, -2, -2, -3, -1] = ((11 : ℤ) : ℚ) • ACell1_4 :=
  toVec_eq_smul10 #v[-1, -3, -2, -2, -3, -3, -2, -2, -3, -1] 11 ACell1_4
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_div (-3) 11 (-3) (11) (by decide) (by decide))
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))
    (eq_smul_div (-3) 11 (-3) (11) (by decide) (by decide))
    (eq_smul_div (-3) 11 (-3) (11) (by decide) (by decide))
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))
    (eq_smul_div (-3) 11 (-3) (11) (by decide) (by decide))
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))

public def ACell1_5 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (2 / 11 : ℚ)
  | 1 => (2 / 11 : ℚ)
  | 2 => (4 / 11 : ℚ)
  | 3 => (2 / 11 : ℚ)
  | 4 => (2 / 11 : ℚ)
  | 5 => (4 / 11 : ℚ)
  | 6 => (2 / 11 : ℚ)
  | 7 => (2 / 11 : ℚ)
  | 8 => 0
  | 9 => (2 / 11 : ℚ)
  | _ => 0

public theorem ACell1_5_def : ACell1_5 = ![(2 / 11 : ℚ), (2 / 11 : ℚ), (4 / 11 : ℚ), (2 / 11 : ℚ), (2 / 11 : ℚ), (4 / 11 : ℚ), (2 / 11 : ℚ), (2 / 11 : ℚ), 0, (2 / 11 : ℚ)] := by
  funext i
  fin_cases i <;> rfl

public theorem ACell1_5_scaled :
    toVec #v[2, 2, 4, 2, 2, 4, 2, 2, 0, 2] = ((11 : ℤ) : ℚ) • ACell1_5 :=
  toVec_eq_smul10 #v[2, 2, 4, 2, 2, 4, 2, 2, 0, 2] 11 ACell1_5
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_div (4) 11 (4) (11) (by decide) (by decide))
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_div (4) 11 (4) (11) (by decide) (by decide))
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))

public def ACell1_6 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => 0
  | 1 => (2 / 11 : ℚ)
  | 2 => (-2 / 11 : ℚ)
  | 3 => (-2 / 11 : ℚ)
  | 4 => (2 / 11 : ℚ)
  | 5 => 0
  | 6 => 0
  | 7 => 0
  | 8 => 0
  | 9 => 0
  | _ => 0

public theorem ACell1_6_def : ACell1_6 = ![0, (2 / 11 : ℚ), (-2 / 11 : ℚ), (-2 / 11 : ℚ), (2 / 11 : ℚ), 0, 0, 0, 0, 0] := by
  funext i
  fin_cases i <;> rfl

public theorem ACell1_6_scaled :
    toVec #v[0, 2, -2, -2, 2, 0, 0, 0, 0, 0] = ((11 : ℤ) : ℚ) • ACell1_6 :=
  toVec_eq_smul10 #v[0, 2, -2, -2, 2, 0, 0, 0, 0, 0] 11 ACell1_6
    (eq_smul_zero 11)
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_zero 11)
    (eq_smul_zero 11)
    (eq_smul_zero 11)
    (eq_smul_zero 11)

public def ACell1_7 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (-2 / 11 : ℚ)
  | 1 => (-2 / 11 : ℚ)
  | 2 => (-2 / 11 : ℚ)
  | 3 => (-2 / 11 : ℚ)
  | 4 => 0
  | 5 => (-2 / 11 : ℚ)
  | 6 => (-4 / 11 : ℚ)
  | 7 => (-2 / 11 : ℚ)
  | 8 => (-4 / 11 : ℚ)
  | 9 => (-2 / 11 : ℚ)
  | _ => 0

public theorem ACell1_7_def : ACell1_7 = ![(-2 / 11 : ℚ), (-2 / 11 : ℚ), (-2 / 11 : ℚ), (-2 / 11 : ℚ), 0, (-2 / 11 : ℚ), (-4 / 11 : ℚ), (-2 / 11 : ℚ), (-4 / 11 : ℚ), (-2 / 11 : ℚ)] := by
  funext i
  fin_cases i <;> rfl

public theorem ACell1_7_scaled :
    toVec #v[-2, -2, -2, -2, 0, -2, -4, -2, -4, -2] = ((11 : ℤ) : ℚ) • ACell1_7 :=
  toVec_eq_smul10 #v[-2, -2, -2, -2, 0, -2, -4, -2, -4, -2] 11 ACell1_7
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))
    (eq_smul_div (-4) 11 (-4) (11) (by decide) (by decide))
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))
    (eq_smul_div (-4) 11 (-4) (11) (by decide) (by decide))
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))

public def ACell1_8 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => 0
  | 1 => 0
  | 2 => (-2 / 11 : ℚ)
  | 3 => (2 / 11 : ℚ)
  | 4 => 0
  | 5 => 0
  | 6 => 0
  | 7 => 0
  | 8 => (2 / 11 : ℚ)
  | 9 => (-2 / 11 : ℚ)
  | _ => 0

public theorem ACell1_8_def : ACell1_8 = ![0, 0, (-2 / 11 : ℚ), (2 / 11 : ℚ), 0, 0, 0, 0, (2 / 11 : ℚ), (-2 / 11 : ℚ)] := by
  funext i
  fin_cases i <;> rfl

public theorem ACell1_8_scaled :
    toVec #v[0, 0, -2, 2, 0, 0, 0, 0, 2, -2] = ((11 : ℤ) : ℚ) • ACell1_8 :=
  toVec_eq_smul10 #v[0, 0, -2, 2, 0, 0, 0, 0, 2, -2] 11 ACell1_8
    (eq_smul_zero 11)
    (eq_smul_zero 11)
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_zero 11)
    (eq_smul_zero 11)
    (eq_smul_zero 11)
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))

public def ACell1_9 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => 0
  | 1 => (-2 / 11 : ℚ)
  | 2 => 0
  | 3 => 0
  | 4 => 0
  | 5 => (-2 / 11 : ℚ)
  | 6 => 0
  | 7 => 0
  | 8 => (2 / 11 : ℚ)
  | 9 => (2 / 11 : ℚ)
  | _ => 0

public theorem ACell1_9_def : ACell1_9 = ![0, (-2 / 11 : ℚ), 0, 0, 0, (-2 / 11 : ℚ), 0, 0, (2 / 11 : ℚ), (2 / 11 : ℚ)] := by
  funext i
  fin_cases i <;> rfl

public theorem ACell1_9_scaled :
    toVec #v[0, -2, 0, 0, 0, -2, 0, 0, 2, 2] = ((11 : ℤ) : ℚ) • ACell1_9 :=
  toVec_eq_smul10 #v[0, -2, 0, 0, 0, -2, 0, 0, 2, 2] 11 ACell1_9
    (eq_smul_zero 11)
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_zero 11)
    (eq_smul_zero 11)
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_zero 11)
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))

public def ARow1 (j : Fin 10) : Vec :=
  match j.val with
  | 0 => ACell1_0
  | 1 => ACell1_1
  | 2 => ACell1_2
  | 3 => ACell1_3
  | 4 => ACell1_4
  | 5 => ACell1_5
  | 6 => ACell1_6
  | 7 => ACell1_7
  | 8 => ACell1_8
  | 9 => ACell1_9
  | _ => 0

public def ACell2_0 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (1 / 11 : ℚ)
  | 1 => (-1 / 11 : ℚ)
  | 2 => (-1 / 11 : ℚ)
  | 3 => (-1 / 11 : ℚ)
  | 4 => (-1 / 11 : ℚ)
  | 5 => (1 / 11 : ℚ)
  | 6 => 0
  | 7 => 0
  | 8 => (2 / 11 : ℚ)
  | 9 => 0
  | _ => 0

public theorem ACell2_0_def : ACell2_0 = ![(1 / 11 : ℚ), (-1 / 11 : ℚ), (-1 / 11 : ℚ), (-1 / 11 : ℚ), (-1 / 11 : ℚ), (1 / 11 : ℚ), 0, 0, (2 / 11 : ℚ), 0] := by
  funext i
  fin_cases i <;> rfl

public theorem ACell2_0_scaled :
    toVec #v[1, -1, -1, -1, -1, 1, 0, 0, 2, 0] = ((11 : ℤ) : ℚ) • ACell2_0 :=
  toVec_eq_smul10 #v[1, -1, -1, -1, -1, 1, 0, 0, 2, 0] 11 ACell2_0
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_zero 11)
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_zero 11)

public def ACell2_1 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (1 / 11 : ℚ)
  | 1 => (1 / 11 : ℚ)
  | 2 => 0
  | 3 => (-1 / 11 : ℚ)
  | 4 => 0
  | 5 => (-1 / 11 : ℚ)
  | 6 => (2 / 11 : ℚ)
  | 7 => (-1 / 11 : ℚ)
  | 8 => 0
  | 9 => (-1 / 11 : ℚ)
  | _ => 0

public theorem ACell2_1_def : ACell2_1 = ![(1 / 11 : ℚ), (1 / 11 : ℚ), 0, (-1 / 11 : ℚ), 0, (-1 / 11 : ℚ), (2 / 11 : ℚ), (-1 / 11 : ℚ), 0, (-1 / 11 : ℚ)] := by
  funext i
  fin_cases i <;> rfl

public theorem ACell2_1_scaled :
    toVec #v[1, 1, 0, -1, 0, -1, 2, -1, 0, -1] = ((11 : ℤ) : ℚ) • ACell2_1 :=
  toVec_eq_smul10 #v[1, 1, 0, -1, 0, -1, 2, -1, 0, -1] 11 ACell2_1
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))

public def ACell2_2 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (-14 / 11 : ℚ)
  | 1 => (-1 / 11 : ℚ)
  | 2 => (-2 / 11 : ℚ)
  | 3 => (-3 / 11 : ℚ)
  | 4 => (-2 / 11 : ℚ)
  | 5 => (-2 / 11 : ℚ)
  | 6 => (-3 / 11 : ℚ)
  | 7 => (-2 / 11 : ℚ)
  | 8 => (-1 / 11 : ℚ)
  | 9 => (-3 / 11 : ℚ)
  | _ => 0

public theorem ACell2_2_def : ACell2_2 = ![(-14 / 11 : ℚ), (-1 / 11 : ℚ), (-2 / 11 : ℚ), (-3 / 11 : ℚ), (-2 / 11 : ℚ), (-2 / 11 : ℚ), (-3 / 11 : ℚ), (-2 / 11 : ℚ), (-1 / 11 : ℚ), (-3 / 11 : ℚ)] := by
  funext i
  fin_cases i <;> rfl

public theorem ACell2_2_scaled :
    toVec #v[-14, -1, -2, -3, -2, -2, -3, -2, -1, -3] = ((11 : ℤ) : ℚ) • ACell2_2 :=
  toVec_eq_smul10 #v[-14, -1, -2, -3, -2, -2, -3, -2, -1, -3] 11 ACell2_2
    (eq_smul_div (-14) 11 (-14) (11) (by decide) (by decide))
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))
    (eq_smul_div (-3) 11 (-3) (11) (by decide) (by decide))
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))
    (eq_smul_div (-3) 11 (-3) (11) (by decide) (by decide))
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_div (-3) 11 (-3) (11) (by decide) (by decide))

public def ACell2_3 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (-2 / 11 : ℚ)
  | 1 => (-1 / 11 : ℚ)
  | 2 => (-1 / 11 : ℚ)
  | 3 => (-2 / 11 : ℚ)
  | 4 => (-2 / 11 : ℚ)
  | 5 => (-1 / 11 : ℚ)
  | 6 => (-1 / 11 : ℚ)
  | 7 => (-2 / 11 : ℚ)
  | 8 => 0
  | 9 => (1 / 11 : ℚ)
  | _ => 0

public theorem ACell2_3_def : ACell2_3 = ![(-2 / 11 : ℚ), (-1 / 11 : ℚ), (-1 / 11 : ℚ), (-2 / 11 : ℚ), (-2 / 11 : ℚ), (-1 / 11 : ℚ), (-1 / 11 : ℚ), (-2 / 11 : ℚ), 0, (1 / 11 : ℚ)] := by
  funext i
  fin_cases i <;> rfl

public theorem ACell2_3_scaled :
    toVec #v[-2, -1, -1, -2, -2, -1, -1, -2, 0, 1] = ((11 : ℤ) : ℚ) • ACell2_3 :=
  toVec_eq_smul10 #v[-2, -1, -1, -2, -2, -1, -1, -2, 0, 1] 11 ACell2_3
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))

public def ACell2_4 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (-2 / 11 : ℚ)
  | 1 => (-2 / 11 : ℚ)
  | 2 => (-1 / 11 : ℚ)
  | 3 => (1 / 11 : ℚ)
  | 4 => (-1 / 11 : ℚ)
  | 5 => (-2 / 11 : ℚ)
  | 6 => (-2 / 11 : ℚ)
  | 7 => 0
  | 8 => (-1 / 11 : ℚ)
  | 9 => (-1 / 11 : ℚ)
  | _ => 0

public theorem ACell2_4_def : ACell2_4 = ![(-2 / 11 : ℚ), (-2 / 11 : ℚ), (-1 / 11 : ℚ), (1 / 11 : ℚ), (-1 / 11 : ℚ), (-2 / 11 : ℚ), (-2 / 11 : ℚ), 0, (-1 / 11 : ℚ), (-1 / 11 : ℚ)] := by
  funext i
  fin_cases i <;> rfl

public theorem ACell2_4_scaled :
    toVec #v[-2, -2, -1, 1, -1, -2, -2, 0, -1, -1] = ((11 : ℤ) : ℚ) • ACell2_4 :=
  toVec_eq_smul10 #v[-2, -2, -1, 1, -1, -2, -2, 0, -1, -1] 11 ACell2_4
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))

public def ACell2_5 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => 0
  | 1 => 0
  | 2 => 0
  | 3 => 0
  | 4 => 0
  | 5 => 0
  | 6 => (-2 / 11 : ℚ)
  | 7 => (2 / 11 : ℚ)
  | 8 => (2 / 11 : ℚ)
  | 9 => (-2 / 11 : ℚ)
  | _ => 0

public theorem ACell2_5_def : ACell2_5 = ![0, 0, 0, 0, 0, 0, (-2 / 11 : ℚ), (2 / 11 : ℚ), (2 / 11 : ℚ), (-2 / 11 : ℚ)] := by
  funext i
  fin_cases i <;> rfl

public theorem ACell2_5_scaled :
    toVec #v[0, 0, 0, 0, 0, 0, -2, 2, 2, -2] = ((11 : ℤ) : ℚ) • ACell2_5 :=
  toVec_eq_smul10 #v[0, 0, 0, 0, 0, 0, -2, 2, 2, -2] 11 ACell2_5
    (eq_smul_zero 11)
    (eq_smul_zero 11)
    (eq_smul_zero 11)
    (eq_smul_zero 11)
    (eq_smul_zero 11)
    (eq_smul_zero 11)
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))

public def ACell2_6 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (2 / 11 : ℚ)
  | 1 => (2 / 11 : ℚ)
  | 2 => (2 / 11 : ℚ)
  | 3 => 0
  | 4 => (2 / 11 : ℚ)
  | 5 => (2 / 11 : ℚ)
  | 6 => (4 / 11 : ℚ)
  | 7 => (4 / 11 : ℚ)
  | 8 => (2 / 11 : ℚ)
  | 9 => (2 / 11 : ℚ)
  | _ => 0

public theorem ACell2_6_def : ACell2_6 = ![(2 / 11 : ℚ), (2 / 11 : ℚ), (2 / 11 : ℚ), 0, (2 / 11 : ℚ), (2 / 11 : ℚ), (4 / 11 : ℚ), (4 / 11 : ℚ), (2 / 11 : ℚ), (2 / 11 : ℚ)] := by
  funext i
  fin_cases i <;> rfl

public theorem ACell2_6_scaled :
    toVec #v[2, 2, 2, 0, 2, 2, 4, 4, 2, 2] = ((11 : ℤ) : ℚ) • ACell2_6 :=
  toVec_eq_smul10 #v[2, 2, 2, 0, 2, 2, 4, 4, 2, 2] 11 ACell2_6
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_div (4) 11 (4) (11) (by decide) (by decide))
    (eq_smul_div (4) 11 (4) (11) (by decide) (by decide))
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))

public def ACell2_7 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (-2 / 11 : ℚ)
  | 1 => 0
  | 2 => (-2 / 11 : ℚ)
  | 3 => (-2 / 11 : ℚ)
  | 4 => (-4 / 11 : ℚ)
  | 5 => (-2 / 11 : ℚ)
  | 6 => (-2 / 11 : ℚ)
  | 7 => (-4 / 11 : ℚ)
  | 8 => (-2 / 11 : ℚ)
  | 9 => (-2 / 11 : ℚ)
  | _ => 0

public theorem ACell2_7_def : ACell2_7 = ![(-2 / 11 : ℚ), 0, (-2 / 11 : ℚ), (-2 / 11 : ℚ), (-4 / 11 : ℚ), (-2 / 11 : ℚ), (-2 / 11 : ℚ), (-4 / 11 : ℚ), (-2 / 11 : ℚ), (-2 / 11 : ℚ)] := by
  funext i
  fin_cases i <;> rfl

public theorem ACell2_7_scaled :
    toVec #v[-2, 0, -2, -2, -4, -2, -2, -4, -2, -2] = ((11 : ℤ) : ℚ) • ACell2_7 :=
  toVec_eq_smul10 #v[-2, 0, -2, -2, -4, -2, -2, -4, -2, -2] 11 ACell2_7
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))
    (eq_smul_div (-4) 11 (-4) (11) (by decide) (by decide))
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))
    (eq_smul_div (-4) 11 (-4) (11) (by decide) (by decide))
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))

public def ACell2_8 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => 0
  | 1 => (-2 / 11 : ℚ)
  | 2 => 0
  | 3 => (2 / 11 : ℚ)
  | 4 => 0
  | 5 => (2 / 11 : ℚ)
  | 6 => 0
  | 7 => (-2 / 11 : ℚ)
  | 8 => 0
  | 9 => 0
  | _ => 0

public theorem ACell2_8_def : ACell2_8 = ![0, (-2 / 11 : ℚ), 0, (2 / 11 : ℚ), 0, (2 / 11 : ℚ), 0, (-2 / 11 : ℚ), 0, 0] := by
  funext i
  fin_cases i <;> rfl

public theorem ACell2_8_scaled :
    toVec #v[0, -2, 0, 2, 0, 2, 0, -2, 0, 0] = ((11 : ℤ) : ℚ) • ACell2_8 :=
  toVec_eq_smul10 #v[0, -2, 0, 2, 0, 2, 0, -2, 0, 0] 11 ACell2_8
    (eq_smul_zero 11)
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_zero 11)

public def ACell2_9 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (2 / 11 : ℚ)
  | 1 => (2 / 11 : ℚ)
  | 2 => (2 / 11 : ℚ)
  | 3 => (2 / 11 : ℚ)
  | 4 => 0
  | 5 => (4 / 11 : ℚ)
  | 6 => (2 / 11 : ℚ)
  | 7 => (2 / 11 : ℚ)
  | 8 => (2 / 11 : ℚ)
  | 9 => (4 / 11 : ℚ)
  | _ => 0

public theorem ACell2_9_def : ACell2_9 = ![(2 / 11 : ℚ), (2 / 11 : ℚ), (2 / 11 : ℚ), (2 / 11 : ℚ), 0, (4 / 11 : ℚ), (2 / 11 : ℚ), (2 / 11 : ℚ), (2 / 11 : ℚ), (4 / 11 : ℚ)] := by
  funext i
  fin_cases i <;> rfl

public theorem ACell2_9_scaled :
    toVec #v[2, 2, 2, 2, 0, 4, 2, 2, 2, 4] = ((11 : ℤ) : ℚ) • ACell2_9 :=
  toVec_eq_smul10 #v[2, 2, 2, 2, 0, 4, 2, 2, 2, 4] 11 ACell2_9
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_div (4) 11 (4) (11) (by decide) (by decide))
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_div (4) 11 (4) (11) (by decide) (by decide))

public def ARow2 (j : Fin 10) : Vec :=
  match j.val with
  | 0 => ACell2_0
  | 1 => ACell2_1
  | 2 => ACell2_2
  | 3 => ACell2_3
  | 4 => ACell2_4
  | 5 => ACell2_5
  | 6 => ACell2_6
  | 7 => ACell2_7
  | 8 => ACell2_8
  | 9 => ACell2_9
  | _ => 0

public def ACell3_0 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (2 / 11 : ℚ)
  | 1 => (1 / 11 : ℚ)
  | 2 => (1 / 11 : ℚ)
  | 3 => (2 / 11 : ℚ)
  | 4 => 0
  | 5 => 0
  | 6 => (1 / 11 : ℚ)
  | 7 => (3 / 11 : ℚ)
  | 8 => (1 / 11 : ℚ)
  | 9 => 0
  | _ => 0

public theorem ACell3_0_def : ACell3_0 = ![(2 / 11 : ℚ), (1 / 11 : ℚ), (1 / 11 : ℚ), (2 / 11 : ℚ), 0, 0, (1 / 11 : ℚ), (3 / 11 : ℚ), (1 / 11 : ℚ), 0] := by
  funext i
  fin_cases i <;> rfl

public theorem ACell3_0_scaled :
    toVec #v[2, 1, 1, 2, 0, 0, 1, 3, 1, 0] = ((11 : ℤ) : ℚ) • ACell3_0 :=
  toVec_eq_smul10 #v[2, 1, 1, 2, 0, 0, 1, 3, 1, 0] 11 ACell3_0
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_zero 11)
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))
    (eq_smul_div (3) 11 (3) (11) (by decide) (by decide))
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))
    (eq_smul_zero 11)

public def ACell3_1 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => 0
  | 1 => 0
  | 2 => (2 / 11 : ℚ)
  | 3 => (1 / 11 : ℚ)
  | 4 => (1 / 11 : ℚ)
  | 5 => (3 / 11 : ℚ)
  | 6 => (1 / 11 : ℚ)
  | 7 => (1 / 11 : ℚ)
  | 8 => (2 / 11 : ℚ)
  | 9 => 0
  | _ => 0

public theorem ACell3_1_def : ACell3_1 = ![0, 0, (2 / 11 : ℚ), (1 / 11 : ℚ), (1 / 11 : ℚ), (3 / 11 : ℚ), (1 / 11 : ℚ), (1 / 11 : ℚ), (2 / 11 : ℚ), 0] := by
  funext i
  fin_cases i <;> rfl

public theorem ACell3_1_scaled :
    toVec #v[0, 0, 2, 1, 1, 3, 1, 1, 2, 0] = ((11 : ℤ) : ℚ) • ACell3_1 :=
  toVec_eq_smul10 #v[0, 0, 2, 1, 1, 3, 1, 1, 2, 0] 11 ACell3_1
    (eq_smul_zero 11)
    (eq_smul_zero 11)
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))
    (eq_smul_div (3) 11 (3) (11) (by decide) (by decide))
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_zero 11)

public def ACell3_2 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (-2 / 11 : ℚ)
  | 1 => (-1 / 11 : ℚ)
  | 2 => (-1 / 11 : ℚ)
  | 3 => (-2 / 11 : ℚ)
  | 4 => (-2 / 11 : ℚ)
  | 5 => (-1 / 11 : ℚ)
  | 6 => (-1 / 11 : ℚ)
  | 7 => (-2 / 11 : ℚ)
  | 8 => 0
  | 9 => (1 / 11 : ℚ)
  | _ => 0

public theorem ACell3_2_def : ACell3_2 = ![(-2 / 11 : ℚ), (-1 / 11 : ℚ), (-1 / 11 : ℚ), (-2 / 11 : ℚ), (-2 / 11 : ℚ), (-1 / 11 : ℚ), (-1 / 11 : ℚ), (-2 / 11 : ℚ), 0, (1 / 11 : ℚ)] := by
  funext i
  fin_cases i <;> rfl

public theorem ACell3_2_scaled :
    toVec #v[-2, -1, -1, -2, -2, -1, -1, -2, 0, 1] = ((11 : ℤ) : ℚ) • ACell3_2 :=
  toVec_eq_smul10 #v[-2, -1, -1, -2, -2, -1, -1, -2, 0, 1] 11 ACell3_2
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))

public def ACell3_3 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (-12 / 11 : ℚ)
  | 1 => 0
  | 2 => (1 / 11 : ℚ)
  | 3 => (1 / 11 : ℚ)
  | 4 => 0
  | 5 => (-1 / 11 : ℚ)
  | 6 => 0
  | 7 => (-1 / 11 : ℚ)
  | 8 => (2 / 11 : ℚ)
  | 9 => (-1 / 11 : ℚ)
  | _ => 0

public theorem ACell3_3_def : ACell3_3 = ![(-12 / 11 : ℚ), 0, (1 / 11 : ℚ), (1 / 11 : ℚ), 0, (-1 / 11 : ℚ), 0, (-1 / 11 : ℚ), (2 / 11 : ℚ), (-1 / 11 : ℚ)] := by
  funext i
  fin_cases i <;> rfl

public theorem ACell3_3_scaled :
    toVec #v[-12, 0, 1, 1, 0, -1, 0, -1, 2, -1] = ((11 : ℤ) : ℚ) • ACell3_3 :=
  toVec_eq_smul10 #v[-12, 0, 1, 1, 0, -1, 0, -1, 2, -1] 11 ACell3_3
    (eq_smul_div (-12) 11 (-12) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))

public def ACell3_4 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (1 / 11 : ℚ)
  | 1 => (-1 / 11 : ℚ)
  | 2 => (2 / 11 : ℚ)
  | 3 => (-1 / 11 : ℚ)
  | 4 => (1 / 11 : ℚ)
  | 5 => 0
  | 6 => (-1 / 11 : ℚ)
  | 7 => 0
  | 8 => 0
  | 9 => (-1 / 11 : ℚ)
  | _ => 0

public theorem ACell3_4_def : ACell3_4 = ![(1 / 11 : ℚ), (-1 / 11 : ℚ), (2 / 11 : ℚ), (-1 / 11 : ℚ), (1 / 11 : ℚ), 0, (-1 / 11 : ℚ), 0, 0, (-1 / 11 : ℚ)] := by
  funext i
  fin_cases i <;> rfl

public theorem ACell3_4_scaled :
    toVec #v[1, -1, 2, -1, 1, 0, -1, 0, 0, -1] = ((11 : ℤ) : ℚ) • ACell3_4 :=
  toVec_eq_smul10 #v[1, -1, 2, -1, 1, 0, -1, 0, 0, -1] 11 ACell3_4
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_zero 11)
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))

public def ACell3_5 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (2 / 11 : ℚ)
  | 1 => (2 / 11 : ℚ)
  | 2 => (2 / 11 : ℚ)
  | 3 => 0
  | 4 => (4 / 11 : ℚ)
  | 5 => (2 / 11 : ℚ)
  | 6 => (2 / 11 : ℚ)
  | 7 => (2 / 11 : ℚ)
  | 8 => (2 / 11 : ℚ)
  | 9 => (4 / 11 : ℚ)
  | _ => 0

public theorem ACell3_5_def : ACell3_5 = ![(2 / 11 : ℚ), (2 / 11 : ℚ), (2 / 11 : ℚ), 0, (4 / 11 : ℚ), (2 / 11 : ℚ), (2 / 11 : ℚ), (2 / 11 : ℚ), (2 / 11 : ℚ), (4 / 11 : ℚ)] := by
  funext i
  fin_cases i <;> rfl

public theorem ACell3_5_scaled :
    toVec #v[2, 2, 2, 0, 4, 2, 2, 2, 2, 4] = ((11 : ℤ) : ℚ) • ACell3_5 :=
  toVec_eq_smul10 #v[2, 2, 2, 0, 4, 2, 2, 2, 2, 4] 11 ACell3_5
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_div (4) 11 (4) (11) (by decide) (by decide))
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_div (4) 11 (4) (11) (by decide) (by decide))

public def ACell3_6 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (2 / 11 : ℚ)
  | 1 => 0
  | 2 => (2 / 11 : ℚ)
  | 3 => (4 / 11 : ℚ)
  | 4 => (2 / 11 : ℚ)
  | 5 => (2 / 11 : ℚ)
  | 6 => (2 / 11 : ℚ)
  | 7 => (2 / 11 : ℚ)
  | 8 => (4 / 11 : ℚ)
  | 9 => (2 / 11 : ℚ)
  | _ => 0

public theorem ACell3_6_def : ACell3_6 = ![(2 / 11 : ℚ), 0, (2 / 11 : ℚ), (4 / 11 : ℚ), (2 / 11 : ℚ), (2 / 11 : ℚ), (2 / 11 : ℚ), (2 / 11 : ℚ), (4 / 11 : ℚ), (2 / 11 : ℚ)] := by
  funext i
  fin_cases i <;> rfl

public theorem ACell3_6_scaled :
    toVec #v[2, 0, 2, 4, 2, 2, 2, 2, 4, 2] = ((11 : ℤ) : ℚ) • ACell3_6 :=
  toVec_eq_smul10 #v[2, 0, 2, 4, 2, 2, 2, 2, 4, 2] 11 ACell3_6
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_div (4) 11 (4) (11) (by decide) (by decide))
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_div (4) 11 (4) (11) (by decide) (by decide))
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))

public def ACell3_7 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => 0
  | 1 => (-2 / 11 : ℚ)
  | 2 => 0
  | 3 => 0
  | 4 => (2 / 11 : ℚ)
  | 5 => (2 / 11 : ℚ)
  | 6 => 0
  | 7 => 0
  | 8 => (-2 / 11 : ℚ)
  | 9 => 0
  | _ => 0

public theorem ACell3_7_def : ACell3_7 = ![0, (-2 / 11 : ℚ), 0, 0, (2 / 11 : ℚ), (2 / 11 : ℚ), 0, 0, (-2 / 11 : ℚ), 0] := by
  funext i
  fin_cases i <;> rfl

public theorem ACell3_7_scaled :
    toVec #v[0, -2, 0, 0, 2, 2, 0, 0, -2, 0] = ((11 : ℤ) : ℚ) • ACell3_7 :=
  toVec_eq_smul10 #v[0, -2, 0, 0, 2, 2, 0, 0, -2, 0] 11 ACell3_7
    (eq_smul_zero 11)
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_zero 11)
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_zero 11)
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))
    (eq_smul_zero 11)

public def ACell3_8 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (2 / 11 : ℚ)
  | 1 => (2 / 11 : ℚ)
  | 2 => (2 / 11 : ℚ)
  | 3 => (2 / 11 : ℚ)
  | 4 => (2 / 11 : ℚ)
  | 5 => (2 / 11 : ℚ)
  | 6 => (2 / 11 : ℚ)
  | 7 => 0
  | 8 => (4 / 11 : ℚ)
  | 9 => (4 / 11 : ℚ)
  | _ => 0

public theorem ACell3_8_def : ACell3_8 = ![(2 / 11 : ℚ), (2 / 11 : ℚ), (2 / 11 : ℚ), (2 / 11 : ℚ), (2 / 11 : ℚ), (2 / 11 : ℚ), (2 / 11 : ℚ), 0, (4 / 11 : ℚ), (4 / 11 : ℚ)] := by
  funext i
  fin_cases i <;> rfl

public theorem ACell3_8_scaled :
    toVec #v[2, 2, 2, 2, 2, 2, 2, 0, 4, 4] = ((11 : ℤ) : ℚ) • ACell3_8 :=
  toVec_eq_smul10 #v[2, 2, 2, 2, 2, 2, 2, 0, 4, 4] 11 ACell3_8
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_div (4) 11 (4) (11) (by decide) (by decide))
    (eq_smul_div (4) 11 (4) (11) (by decide) (by decide))

public def ACell3_9 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (2 / 11 : ℚ)
  | 1 => (2 / 11 : ℚ)
  | 2 => 0
  | 3 => (2 / 11 : ℚ)
  | 4 => (2 / 11 : ℚ)
  | 5 => (4 / 11 : ℚ)
  | 6 => (2 / 11 : ℚ)
  | 7 => (4 / 11 : ℚ)
  | 8 => (2 / 11 : ℚ)
  | 9 => (2 / 11 : ℚ)
  | _ => 0

public theorem ACell3_9_def : ACell3_9 = ![(2 / 11 : ℚ), (2 / 11 : ℚ), 0, (2 / 11 : ℚ), (2 / 11 : ℚ), (4 / 11 : ℚ), (2 / 11 : ℚ), (4 / 11 : ℚ), (2 / 11 : ℚ), (2 / 11 : ℚ)] := by
  funext i
  fin_cases i <;> rfl

public theorem ACell3_9_scaled :
    toVec #v[2, 2, 0, 2, 2, 4, 2, 4, 2, 2] = ((11 : ℤ) : ℚ) • ACell3_9 :=
  toVec_eq_smul10 #v[2, 2, 0, 2, 2, 4, 2, 4, 2, 2] 11 ACell3_9
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_div (4) 11 (4) (11) (by decide) (by decide))
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_div (4) 11 (4) (11) (by decide) (by decide))
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))

public def ARow3 (j : Fin 10) : Vec :=
  match j.val with
  | 0 => ACell3_0
  | 1 => ACell3_1
  | 2 => ACell3_2
  | 3 => ACell3_3
  | 4 => ACell3_4
  | 5 => ACell3_5
  | 6 => ACell3_6
  | 7 => ACell3_7
  | 8 => ACell3_8
  | 9 => ACell3_9
  | _ => 0

public def ACell4_0 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (-1 / 11 : ℚ)
  | 1 => (2 / 11 : ℚ)
  | 2 => (-1 / 11 : ℚ)
  | 3 => 0
  | 4 => (-1 / 11 : ℚ)
  | 5 => 0
  | 6 => (1 / 11 : ℚ)
  | 7 => (1 / 11 : ℚ)
  | 8 => 0
  | 9 => (-1 / 11 : ℚ)
  | _ => 0

public theorem ACell4_0_def : ACell4_0 = ![(-1 / 11 : ℚ), (2 / 11 : ℚ), (-1 / 11 : ℚ), 0, (-1 / 11 : ℚ), 0, (1 / 11 : ℚ), (1 / 11 : ℚ), 0, (-1 / 11 : ℚ)] := by
  funext i
  fin_cases i <;> rfl

public theorem ACell4_0_scaled :
    toVec #v[-1, 2, -1, 0, -1, 0, 1, 1, 0, -1] = ((11 : ℤ) : ℚ) • ACell4_0 :=
  toVec_eq_smul10 #v[-1, 2, -1, 0, -1, 0, 1, 1, 0, -1] 11 ACell4_0
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))

public def ACell4_1 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (-1 / 11 : ℚ)
  | 1 => (-3 / 11 : ℚ)
  | 2 => (-2 / 11 : ℚ)
  | 3 => (-2 / 11 : ℚ)
  | 4 => (-3 / 11 : ℚ)
  | 5 => (-3 / 11 : ℚ)
  | 6 => (-2 / 11 : ℚ)
  | 7 => (-2 / 11 : ℚ)
  | 8 => (-3 / 11 : ℚ)
  | 9 => (-1 / 11 : ℚ)
  | _ => 0

public theorem ACell4_1_def : ACell4_1 = ![(-1 / 11 : ℚ), (-3 / 11 : ℚ), (-2 / 11 : ℚ), (-2 / 11 : ℚ), (-3 / 11 : ℚ), (-3 / 11 : ℚ), (-2 / 11 : ℚ), (-2 / 11 : ℚ), (-3 / 11 : ℚ), (-1 / 11 : ℚ)] := by
  funext i
  fin_cases i <;> rfl

public theorem ACell4_1_scaled :
    toVec #v[-1, -3, -2, -2, -3, -3, -2, -2, -3, -1] = ((11 : ℤ) : ℚ) • ACell4_1 :=
  toVec_eq_smul10 #v[-1, -3, -2, -2, -3, -3, -2, -2, -3, -1] 11 ACell4_1
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_div (-3) 11 (-3) (11) (by decide) (by decide))
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))
    (eq_smul_div (-3) 11 (-3) (11) (by decide) (by decide))
    (eq_smul_div (-3) 11 (-3) (11) (by decide) (by decide))
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))
    (eq_smul_div (-3) 11 (-3) (11) (by decide) (by decide))
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))

public def ACell4_2 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (-2 / 11 : ℚ)
  | 1 => (-2 / 11 : ℚ)
  | 2 => (-1 / 11 : ℚ)
  | 3 => (1 / 11 : ℚ)
  | 4 => (-1 / 11 : ℚ)
  | 5 => (-2 / 11 : ℚ)
  | 6 => (-2 / 11 : ℚ)
  | 7 => 0
  | 8 => (-1 / 11 : ℚ)
  | 9 => (-1 / 11 : ℚ)
  | _ => 0

public theorem ACell4_2_def : ACell4_2 = ![(-2 / 11 : ℚ), (-2 / 11 : ℚ), (-1 / 11 : ℚ), (1 / 11 : ℚ), (-1 / 11 : ℚ), (-2 / 11 : ℚ), (-2 / 11 : ℚ), 0, (-1 / 11 : ℚ), (-1 / 11 : ℚ)] := by
  funext i
  fin_cases i <;> rfl

public theorem ACell4_2_scaled :
    toVec #v[-2, -2, -1, 1, -1, -2, -2, 0, -1, -1] = ((11 : ℤ) : ℚ) • ACell4_2 :=
  toVec_eq_smul10 #v[-2, -2, -1, 1, -1, -2, -2, 0, -1, -1] 11 ACell4_2
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))

public def ACell4_3 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (1 / 11 : ℚ)
  | 1 => (-1 / 11 : ℚ)
  | 2 => (2 / 11 : ℚ)
  | 3 => (-1 / 11 : ℚ)
  | 4 => (1 / 11 : ℚ)
  | 5 => 0
  | 6 => (-1 / 11 : ℚ)
  | 7 => 0
  | 8 => 0
  | 9 => (-1 / 11 : ℚ)
  | _ => 0

public theorem ACell4_3_def : ACell4_3 = ![(1 / 11 : ℚ), (-1 / 11 : ℚ), (2 / 11 : ℚ), (-1 / 11 : ℚ), (1 / 11 : ℚ), 0, (-1 / 11 : ℚ), 0, 0, (-1 / 11 : ℚ)] := by
  funext i
  fin_cases i <;> rfl

public theorem ACell4_3_scaled :
    toVec #v[1, -1, 2, -1, 1, 0, -1, 0, 0, -1] = ((11 : ℤ) : ℚ) • ACell4_3 :=
  toVec_eq_smul10 #v[1, -1, 2, -1, 1, 0, -1, 0, 0, -1] 11 ACell4_3
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_zero 11)
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))

public def ACell4_4 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (-13 / 11 : ℚ)
  | 1 => (-2 / 11 : ℚ)
  | 2 => (-2 / 11 : ℚ)
  | 3 => (-2 / 11 : ℚ)
  | 4 => 0
  | 5 => (-1 / 11 : ℚ)
  | 6 => (-1 / 11 : ℚ)
  | 7 => (1 / 11 : ℚ)
  | 8 => (-1 / 11 : ℚ)
  | 9 => (-1 / 11 : ℚ)
  | _ => 0

public theorem ACell4_4_def : ACell4_4 = ![(-13 / 11 : ℚ), (-2 / 11 : ℚ), (-2 / 11 : ℚ), (-2 / 11 : ℚ), 0, (-1 / 11 : ℚ), (-1 / 11 : ℚ), (1 / 11 : ℚ), (-1 / 11 : ℚ), (-1 / 11 : ℚ)] := by
  funext i
  fin_cases i <;> rfl

public theorem ACell4_4_scaled :
    toVec #v[-13, -2, -2, -2, 0, -1, -1, 1, -1, -1] = ((11 : ℤ) : ℚ) • ACell4_4 :=
  toVec_eq_smul10 #v[-13, -2, -2, -2, 0, -1, -1, 1, -1, -1] 11 ACell4_4
    (eq_smul_div (-13) 11 (-13) (11) (by decide) (by decide))
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))

public def ACell4_5 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => 0
  | 1 => 0
  | 2 => 0
  | 3 => (-2 / 11 : ℚ)
  | 4 => 0
  | 5 => (2 / 11 : ℚ)
  | 6 => 0
  | 7 => (2 / 11 : ℚ)
  | 8 => 0
  | 9 => (-2 / 11 : ℚ)
  | _ => 0

public theorem ACell4_5_def : ACell4_5 = ![0, 0, 0, (-2 / 11 : ℚ), 0, (2 / 11 : ℚ), 0, (2 / 11 : ℚ), 0, (-2 / 11 : ℚ)] := by
  funext i
  fin_cases i <;> rfl

public theorem ACell4_5_scaled :
    toVec #v[0, 0, 0, -2, 0, 2, 0, 2, 0, -2] = ((11 : ℤ) : ℚ) • ACell4_5 :=
  toVec_eq_smul10 #v[0, 0, 0, -2, 0, 2, 0, 2, 0, -2] 11 ACell4_5
    (eq_smul_zero 11)
    (eq_smul_zero 11)
    (eq_smul_zero 11)
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))

public def ACell4_6 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => 0
  | 1 => (-2 / 11 : ℚ)
  | 2 => 0
  | 3 => 0
  | 4 => (2 / 11 : ℚ)
  | 5 => 0
  | 6 => (2 / 11 : ℚ)
  | 7 => 0
  | 8 => 0
  | 9 => (-2 / 11 : ℚ)
  | _ => 0

public theorem ACell4_6_def : ACell4_6 = ![0, (-2 / 11 : ℚ), 0, 0, (2 / 11 : ℚ), 0, (2 / 11 : ℚ), 0, 0, (-2 / 11 : ℚ)] := by
  funext i
  fin_cases i <;> rfl

public theorem ACell4_6_scaled :
    toVec #v[0, -2, 0, 0, 2, 0, 2, 0, 0, -2] = ((11 : ℤ) : ℚ) • ACell4_6 :=
  toVec_eq_smul10 #v[0, -2, 0, 0, 2, 0, 2, 0, 0, -2] 11 ACell4_6
    (eq_smul_zero 11)
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_zero 11)
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_zero 11)
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))

public def ACell4_7 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => 0
  | 1 => (-2 / 11 : ℚ)
  | 2 => (2 / 11 : ℚ)
  | 3 => 0
  | 4 => 0
  | 5 => 0
  | 6 => (2 / 11 : ℚ)
  | 7 => (-2 / 11 : ℚ)
  | 8 => 0
  | 9 => 0
  | _ => 0

public theorem ACell4_7_def : ACell4_7 = ![0, (-2 / 11 : ℚ), (2 / 11 : ℚ), 0, 0, 0, (2 / 11 : ℚ), (-2 / 11 : ℚ), 0, 0] := by
  funext i
  fin_cases i <;> rfl

public theorem ACell4_7_scaled :
    toVec #v[0, -2, 2, 0, 0, 0, 2, -2, 0, 0] = ((11 : ℤ) : ℚ) • ACell4_7 :=
  toVec_eq_smul10 #v[0, -2, 2, 0, 0, 0, 2, -2, 0, 0] 11 ACell4_7
    (eq_smul_zero 11)
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_zero 11)
    (eq_smul_zero 11)
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_zero 11)

public def ACell4_8 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (-2 / 11 : ℚ)
  | 1 => (-2 / 11 : ℚ)
  | 2 => (-4 / 11 : ℚ)
  | 3 => (-4 / 11 : ℚ)
  | 4 => (-2 / 11 : ℚ)
  | 5 => (-2 / 11 : ℚ)
  | 6 => 0
  | 7 => (-2 / 11 : ℚ)
  | 8 => (-2 / 11 : ℚ)
  | 9 => (-2 / 11 : ℚ)
  | _ => 0

public theorem ACell4_8_def : ACell4_8 = ![(-2 / 11 : ℚ), (-2 / 11 : ℚ), (-4 / 11 : ℚ), (-4 / 11 : ℚ), (-2 / 11 : ℚ), (-2 / 11 : ℚ), 0, (-2 / 11 : ℚ), (-2 / 11 : ℚ), (-2 / 11 : ℚ)] := by
  funext i
  fin_cases i <;> rfl

public theorem ACell4_8_scaled :
    toVec #v[-2, -2, -4, -4, -2, -2, 0, -2, -2, -2] = ((11 : ℤ) : ℚ) • ACell4_8 :=
  toVec_eq_smul10 #v[-2, -2, -4, -4, -2, -2, 0, -2, -2, -2] 11 ACell4_8
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))
    (eq_smul_div (-4) 11 (-4) (11) (by decide) (by decide))
    (eq_smul_div (-4) 11 (-4) (11) (by decide) (by decide))
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))

public def ACell4_9 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => 0
  | 1 => 0
  | 2 => 0
  | 3 => 0
  | 4 => (2 / 11 : ℚ)
  | 5 => (-2 / 11 : ℚ)
  | 6 => (-2 / 11 : ℚ)
  | 7 => (2 / 11 : ℚ)
  | 8 => 0
  | 9 => 0
  | _ => 0

public theorem ACell4_9_def : ACell4_9 = ![0, 0, 0, 0, (2 / 11 : ℚ), (-2 / 11 : ℚ), (-2 / 11 : ℚ), (2 / 11 : ℚ), 0, 0] := by
  funext i
  fin_cases i <;> rfl

public theorem ACell4_9_scaled :
    toVec #v[0, 0, 0, 0, 2, -2, -2, 2, 0, 0] = ((11 : ℤ) : ℚ) • ACell4_9 :=
  toVec_eq_smul10 #v[0, 0, 0, 0, 2, -2, -2, 2, 0, 0] 11 ACell4_9
    (eq_smul_zero 11)
    (eq_smul_zero 11)
    (eq_smul_zero 11)
    (eq_smul_zero 11)
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_zero 11)

public def ARow4 (j : Fin 10) : Vec :=
  match j.val with
  | 0 => ACell4_0
  | 1 => ACell4_1
  | 2 => ACell4_2
  | 3 => ACell4_3
  | 4 => ACell4_4
  | 5 => ACell4_5
  | 6 => ACell4_6
  | 7 => ACell4_7
  | 8 => ACell4_8
  | 9 => ACell4_9
  | _ => 0

public def ACell5_0 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => 0
  | 1 => 0
  | 2 => (3 / 22 : ℚ)
  | 3 => 0
  | 4 => 0
  | 5 => (-3 / 22 : ℚ)
  | 6 => (-3 / 22 : ℚ)
  | 7 => 0
  | 8 => 0
  | 9 => (3 / 22 : ℚ)
  | _ => 0

public theorem ACell5_0_def : ACell5_0 = ![0, 0, (3 / 22 : ℚ), 0, 0, (-3 / 22 : ℚ), (-3 / 22 : ℚ), 0, 0, (3 / 22 : ℚ)] := by
  funext i
  fin_cases i <;> rfl

public theorem ACell5_0_scaled :
    toVec #v[0, 0, 3, 0, 0, -3, -3, 0, 0, 3] = ((22 : ℤ) : ℚ) • ACell5_0 :=
  toVec_eq_smul10 #v[0, 0, 3, 0, 0, -3, -3, 0, 0, 3] 22 ACell5_0
    (eq_smul_zero 22)
    (eq_smul_zero 22)
    (eq_smul_div (3) 22 (3) (22) (by decide) (by decide))
    (eq_smul_zero 22)
    (eq_smul_zero 22)
    (eq_smul_div (-3) 22 (-3) (22) (by decide) (by decide))
    (eq_smul_div (-3) 22 (-3) (22) (by decide) (by decide))
    (eq_smul_zero 22)
    (eq_smul_zero 22)
    (eq_smul_div (3) 22 (3) (22) (by decide) (by decide))

public def ACell5_1 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (3 / 22 : ℚ)
  | 1 => (3 / 22 : ℚ)
  | 2 => (3 / 11 : ℚ)
  | 3 => (3 / 22 : ℚ)
  | 4 => (3 / 22 : ℚ)
  | 5 => (3 / 11 : ℚ)
  | 6 => (3 / 22 : ℚ)
  | 7 => (3 / 22 : ℚ)
  | 8 => 0
  | 9 => (3 / 22 : ℚ)
  | _ => 0

public theorem ACell5_1_def : ACell5_1 = ![(3 / 22 : ℚ), (3 / 22 : ℚ), (3 / 11 : ℚ), (3 / 22 : ℚ), (3 / 22 : ℚ), (3 / 11 : ℚ), (3 / 22 : ℚ), (3 / 22 : ℚ), 0, (3 / 22 : ℚ)] := by
  funext i
  fin_cases i <;> rfl

public theorem ACell5_1_scaled :
    toVec #v[3, 3, 6, 3, 3, 6, 3, 3, 0, 3] = ((22 : ℤ) : ℚ) • ACell5_1 :=
  toVec_eq_smul10 #v[3, 3, 6, 3, 3, 6, 3, 3, 0, 3] 22 ACell5_1
    (eq_smul_div (3) 22 (3) (22) (by decide) (by decide))
    (eq_smul_div (3) 22 (3) (22) (by decide) (by decide))
    (eq_smul_div (6) 22 (3) (11) (by decide) (by decide))
    (eq_smul_div (3) 22 (3) (22) (by decide) (by decide))
    (eq_smul_div (3) 22 (3) (22) (by decide) (by decide))
    (eq_smul_div (6) 22 (3) (11) (by decide) (by decide))
    (eq_smul_div (3) 22 (3) (22) (by decide) (by decide))
    (eq_smul_div (3) 22 (3) (22) (by decide) (by decide))
    (eq_smul_zero 22)
    (eq_smul_div (3) 22 (3) (22) (by decide) (by decide))

public def ACell5_2 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => 0
  | 1 => 0
  | 2 => 0
  | 3 => 0
  | 4 => 0
  | 5 => 0
  | 6 => (-3 / 22 : ℚ)
  | 7 => (3 / 22 : ℚ)
  | 8 => (3 / 22 : ℚ)
  | 9 => (-3 / 22 : ℚ)
  | _ => 0

public theorem ACell5_2_def : ACell5_2 = ![0, 0, 0, 0, 0, 0, (-3 / 22 : ℚ), (3 / 22 : ℚ), (3 / 22 : ℚ), (-3 / 22 : ℚ)] := by
  funext i
  fin_cases i <;> rfl

public theorem ACell5_2_scaled :
    toVec #v[0, 0, 0, 0, 0, 0, -3, 3, 3, -3] = ((22 : ℤ) : ℚ) • ACell5_2 :=
  toVec_eq_smul10 #v[0, 0, 0, 0, 0, 0, -3, 3, 3, -3] 22 ACell5_2
    (eq_smul_zero 22)
    (eq_smul_zero 22)
    (eq_smul_zero 22)
    (eq_smul_zero 22)
    (eq_smul_zero 22)
    (eq_smul_zero 22)
    (eq_smul_div (-3) 22 (-3) (22) (by decide) (by decide))
    (eq_smul_div (3) 22 (3) (22) (by decide) (by decide))
    (eq_smul_div (3) 22 (3) (22) (by decide) (by decide))
    (eq_smul_div (-3) 22 (-3) (22) (by decide) (by decide))

public def ACell5_3 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (3 / 22 : ℚ)
  | 1 => (3 / 22 : ℚ)
  | 2 => (3 / 22 : ℚ)
  | 3 => 0
  | 4 => (3 / 11 : ℚ)
  | 5 => (3 / 22 : ℚ)
  | 6 => (3 / 22 : ℚ)
  | 7 => (3 / 22 : ℚ)
  | 8 => (3 / 22 : ℚ)
  | 9 => (3 / 11 : ℚ)
  | _ => 0

public theorem ACell5_3_def : ACell5_3 = ![(3 / 22 : ℚ), (3 / 22 : ℚ), (3 / 22 : ℚ), 0, (3 / 11 : ℚ), (3 / 22 : ℚ), (3 / 22 : ℚ), (3 / 22 : ℚ), (3 / 22 : ℚ), (3 / 11 : ℚ)] := by
  funext i
  fin_cases i <;> rfl

public theorem ACell5_3_scaled :
    toVec #v[3, 3, 3, 0, 6, 3, 3, 3, 3, 6] = ((22 : ℤ) : ℚ) • ACell5_3 :=
  toVec_eq_smul10 #v[3, 3, 3, 0, 6, 3, 3, 3, 3, 6] 22 ACell5_3
    (eq_smul_div (3) 22 (3) (22) (by decide) (by decide))
    (eq_smul_div (3) 22 (3) (22) (by decide) (by decide))
    (eq_smul_div (3) 22 (3) (22) (by decide) (by decide))
    (eq_smul_zero 22)
    (eq_smul_div (6) 22 (3) (11) (by decide) (by decide))
    (eq_smul_div (3) 22 (3) (22) (by decide) (by decide))
    (eq_smul_div (3) 22 (3) (22) (by decide) (by decide))
    (eq_smul_div (3) 22 (3) (22) (by decide) (by decide))
    (eq_smul_div (3) 22 (3) (22) (by decide) (by decide))
    (eq_smul_div (6) 22 (3) (11) (by decide) (by decide))

public def ACell5_4 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => 0
  | 1 => 0
  | 2 => 0
  | 3 => (-3 / 22 : ℚ)
  | 4 => 0
  | 5 => (3 / 22 : ℚ)
  | 6 => 0
  | 7 => (3 / 22 : ℚ)
  | 8 => 0
  | 9 => (-3 / 22 : ℚ)
  | _ => 0

public theorem ACell5_4_def : ACell5_4 = ![0, 0, 0, (-3 / 22 : ℚ), 0, (3 / 22 : ℚ), 0, (3 / 22 : ℚ), 0, (-3 / 22 : ℚ)] := by
  funext i
  fin_cases i <;> rfl

public theorem ACell5_4_scaled :
    toVec #v[0, 0, 0, -3, 0, 3, 0, 3, 0, -3] = ((22 : ℤ) : ℚ) • ACell5_4 :=
  toVec_eq_smul10 #v[0, 0, 0, -3, 0, 3, 0, 3, 0, -3] 22 ACell5_4
    (eq_smul_zero 22)
    (eq_smul_zero 22)
    (eq_smul_zero 22)
    (eq_smul_div (-3) 22 (-3) (22) (by decide) (by decide))
    (eq_smul_zero 22)
    (eq_smul_div (3) 22 (3) (22) (by decide) (by decide))
    (eq_smul_zero 22)
    (eq_smul_div (3) 22 (3) (22) (by decide) (by decide))
    (eq_smul_zero 22)
    (eq_smul_div (-3) 22 (-3) (22) (by decide) (by decide))

public def ACell5_5 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => -1
  | 1 => (1 / 11 : ℚ)
  | 2 => (1 / 11 : ℚ)
  | 3 => 0
  | 4 => (2 / 11 : ℚ)
  | 5 => (3 / 11 : ℚ)
  | 6 => (2 / 11 : ℚ)
  | 7 => 0
  | 8 => (1 / 11 : ℚ)
  | 9 => (1 / 11 : ℚ)
  | _ => 0

public theorem ACell5_5_def : ACell5_5 = ![-1, (1 / 11 : ℚ), (1 / 11 : ℚ), 0, (2 / 11 : ℚ), (3 / 11 : ℚ), (2 / 11 : ℚ), 0, (1 / 11 : ℚ), (1 / 11 : ℚ)] := by
  funext i
  fin_cases i <;> rfl

public theorem ACell5_5_scaled :
    toVec #v[-11, 1, 1, 0, 2, 3, 2, 0, 1, 1] = ((11 : ℤ) : ℚ) • ACell5_5 :=
  toVec_eq_smul10 #v[-11, 1, 1, 0, 2, 3, 2, 0, 1, 1] 11 ACell5_5
    (eq_smul_int (-11) 11 (-1) (by decide))
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_div (3) 11 (3) (11) (by decide) (by decide))
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))

public def ACell5_6 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (-1 / 11 : ℚ)
  | 1 => (1 / 11 : ℚ)
  | 2 => (1 / 11 : ℚ)
  | 3 => 0
  | 4 => (-2 / 11 : ℚ)
  | 5 => 0
  | 6 => (1 / 11 : ℚ)
  | 7 => (1 / 11 : ℚ)
  | 8 => (-1 / 11 : ℚ)
  | 9 => 0
  | _ => 0

public theorem ACell5_6_def : ACell5_6 = ![(-1 / 11 : ℚ), (1 / 11 : ℚ), (1 / 11 : ℚ), 0, (-2 / 11 : ℚ), 0, (1 / 11 : ℚ), (1 / 11 : ℚ), (-1 / 11 : ℚ), 0] := by
  funext i
  fin_cases i <;> rfl

public theorem ACell5_6_scaled :
    toVec #v[-1, 1, 1, 0, -2, 0, 1, 1, -1, 0] = ((11 : ℤ) : ℚ) • ACell5_6 :=
  toVec_eq_smul10 #v[-1, 1, 1, 0, -2, 0, 1, 1, -1, 0] 11 ACell5_6
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_zero 11)

public def ACell5_7 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (-2 / 11 : ℚ)
  | 1 => (-1 / 11 : ℚ)
  | 2 => (-1 / 11 : ℚ)
  | 3 => (-3 / 11 : ℚ)
  | 4 => (-1 / 11 : ℚ)
  | 5 => (-1 / 11 : ℚ)
  | 6 => (-2 / 11 : ℚ)
  | 7 => 0
  | 8 => 0
  | 9 => 0
  | _ => 0

public theorem ACell5_7_def : ACell5_7 = ![(-2 / 11 : ℚ), (-1 / 11 : ℚ), (-1 / 11 : ℚ), (-3 / 11 : ℚ), (-1 / 11 : ℚ), (-1 / 11 : ℚ), (-2 / 11 : ℚ), 0, 0, 0] := by
  funext i
  fin_cases i <;> rfl

public theorem ACell5_7_scaled :
    toVec #v[-2, -1, -1, -3, -1, -1, -2, 0, 0, 0] = ((11 : ℤ) : ℚ) • ACell5_7 :=
  toVec_eq_smul10 #v[-2, -1, -1, -3, -1, -1, -2, 0, 0, 0] 11 ACell5_7
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_div (-3) 11 (-3) (11) (by decide) (by decide))
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_zero 11)
    (eq_smul_zero 11)

public def ACell5_8 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (-1 / 11 : ℚ)
  | 1 => 0
  | 2 => 0
  | 3 => (-1 / 11 : ℚ)
  | 4 => 0
  | 5 => (1 / 11 : ℚ)
  | 6 => (-1 / 11 : ℚ)
  | 7 => (2 / 11 : ℚ)
  | 8 => (-1 / 11 : ℚ)
  | 9 => (1 / 11 : ℚ)
  | _ => 0

public theorem ACell5_8_def : ACell5_8 = ![(-1 / 11 : ℚ), 0, 0, (-1 / 11 : ℚ), 0, (1 / 11 : ℚ), (-1 / 11 : ℚ), (2 / 11 : ℚ), (-1 / 11 : ℚ), (1 / 11 : ℚ)] := by
  funext i
  fin_cases i <;> rfl

public theorem ACell5_8_scaled :
    toVec #v[-1, 0, 0, -1, 0, 1, -1, 2, -1, 1] = ((11 : ℤ) : ℚ) • ACell5_8 :=
  toVec_eq_smul10 #v[-1, 0, 0, -1, 0, 1, -1, 2, -1, 1] 11 ACell5_8
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_zero 11)
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))

public def ACell5_9 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (3 / 11 : ℚ)
  | 1 => (2 / 11 : ℚ)
  | 2 => (3 / 11 : ℚ)
  | 3 => (2 / 11 : ℚ)
  | 4 => (1 / 11 : ℚ)
  | 5 => (1 / 11 : ℚ)
  | 6 => (2 / 11 : ℚ)
  | 7 => (3 / 11 : ℚ)
  | 8 => (2 / 11 : ℚ)
  | 9 => (3 / 11 : ℚ)
  | _ => 0

public theorem ACell5_9_def : ACell5_9 = ![(3 / 11 : ℚ), (2 / 11 : ℚ), (3 / 11 : ℚ), (2 / 11 : ℚ), (1 / 11 : ℚ), (1 / 11 : ℚ), (2 / 11 : ℚ), (3 / 11 : ℚ), (2 / 11 : ℚ), (3 / 11 : ℚ)] := by
  funext i
  fin_cases i <;> rfl

public theorem ACell5_9_scaled :
    toVec #v[3, 2, 3, 2, 1, 1, 2, 3, 2, 3] = ((11 : ℤ) : ℚ) • ACell5_9 :=
  toVec_eq_smul10 #v[3, 2, 3, 2, 1, 1, 2, 3, 2, 3] 11 ACell5_9
    (eq_smul_div (3) 11 (3) (11) (by decide) (by decide))
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_div (3) 11 (3) (11) (by decide) (by decide))
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_div (3) 11 (3) (11) (by decide) (by decide))
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_div (3) 11 (3) (11) (by decide) (by decide))

public def ARow5 (j : Fin 10) : Vec :=
  match j.val with
  | 0 => ACell5_0
  | 1 => ACell5_1
  | 2 => ACell5_2
  | 3 => ACell5_3
  | 4 => ACell5_4
  | 5 => ACell5_5
  | 6 => ACell5_6
  | 7 => ACell5_7
  | 8 => ACell5_8
  | 9 => ACell5_9
  | _ => 0

public def ACell6_0 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => 0
  | 1 => (3 / 22 : ℚ)
  | 2 => (-3 / 22 : ℚ)
  | 3 => 0
  | 4 => 0
  | 5 => 0
  | 6 => 0
  | 7 => (-3 / 22 : ℚ)
  | 8 => (3 / 22 : ℚ)
  | 9 => 0
  | _ => 0

public theorem ACell6_0_def : ACell6_0 = ![0, (3 / 22 : ℚ), (-3 / 22 : ℚ), 0, 0, 0, 0, (-3 / 22 : ℚ), (3 / 22 : ℚ), 0] := by
  funext i
  fin_cases i <;> rfl

public theorem ACell6_0_scaled :
    toVec #v[0, 3, -3, 0, 0, 0, 0, -3, 3, 0] = ((22 : ℤ) : ℚ) • ACell6_0 :=
  toVec_eq_smul10 #v[0, 3, -3, 0, 0, 0, 0, -3, 3, 0] 22 ACell6_0
    (eq_smul_zero 22)
    (eq_smul_div (3) 22 (3) (22) (by decide) (by decide))
    (eq_smul_div (-3) 22 (-3) (22) (by decide) (by decide))
    (eq_smul_zero 22)
    (eq_smul_zero 22)
    (eq_smul_zero 22)
    (eq_smul_zero 22)
    (eq_smul_div (-3) 22 (-3) (22) (by decide) (by decide))
    (eq_smul_div (3) 22 (3) (22) (by decide) (by decide))
    (eq_smul_zero 22)

public def ACell6_1 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => 0
  | 1 => (3 / 22 : ℚ)
  | 2 => (-3 / 22 : ℚ)
  | 3 => (-3 / 22 : ℚ)
  | 4 => (3 / 22 : ℚ)
  | 5 => 0
  | 6 => 0
  | 7 => 0
  | 8 => 0
  | 9 => 0
  | _ => 0

public theorem ACell6_1_def : ACell6_1 = ![0, (3 / 22 : ℚ), (-3 / 22 : ℚ), (-3 / 22 : ℚ), (3 / 22 : ℚ), 0, 0, 0, 0, 0] := by
  funext i
  fin_cases i <;> rfl

public theorem ACell6_1_scaled :
    toVec #v[0, 3, -3, -3, 3, 0, 0, 0, 0, 0] = ((22 : ℤ) : ℚ) • ACell6_1 :=
  toVec_eq_smul10 #v[0, 3, -3, -3, 3, 0, 0, 0, 0, 0] 22 ACell6_1
    (eq_smul_zero 22)
    (eq_smul_div (3) 22 (3) (22) (by decide) (by decide))
    (eq_smul_div (-3) 22 (-3) (22) (by decide) (by decide))
    (eq_smul_div (-3) 22 (-3) (22) (by decide) (by decide))
    (eq_smul_div (3) 22 (3) (22) (by decide) (by decide))
    (eq_smul_zero 22)
    (eq_smul_zero 22)
    (eq_smul_zero 22)
    (eq_smul_zero 22)
    (eq_smul_zero 22)

public def ACell6_2 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (3 / 22 : ℚ)
  | 1 => (3 / 22 : ℚ)
  | 2 => (3 / 22 : ℚ)
  | 3 => 0
  | 4 => (3 / 22 : ℚ)
  | 5 => (3 / 22 : ℚ)
  | 6 => (3 / 11 : ℚ)
  | 7 => (3 / 11 : ℚ)
  | 8 => (3 / 22 : ℚ)
  | 9 => (3 / 22 : ℚ)
  | _ => 0

public theorem ACell6_2_def : ACell6_2 = ![(3 / 22 : ℚ), (3 / 22 : ℚ), (3 / 22 : ℚ), 0, (3 / 22 : ℚ), (3 / 22 : ℚ), (3 / 11 : ℚ), (3 / 11 : ℚ), (3 / 22 : ℚ), (3 / 22 : ℚ)] := by
  funext i
  fin_cases i <;> rfl

public theorem ACell6_2_scaled :
    toVec #v[3, 3, 3, 0, 3, 3, 6, 6, 3, 3] = ((22 : ℤ) : ℚ) • ACell6_2 :=
  toVec_eq_smul10 #v[3, 3, 3, 0, 3, 3, 6, 6, 3, 3] 22 ACell6_2
    (eq_smul_div (3) 22 (3) (22) (by decide) (by decide))
    (eq_smul_div (3) 22 (3) (22) (by decide) (by decide))
    (eq_smul_div (3) 22 (3) (22) (by decide) (by decide))
    (eq_smul_zero 22)
    (eq_smul_div (3) 22 (3) (22) (by decide) (by decide))
    (eq_smul_div (3) 22 (3) (22) (by decide) (by decide))
    (eq_smul_div (6) 22 (3) (11) (by decide) (by decide))
    (eq_smul_div (6) 22 (3) (11) (by decide) (by decide))
    (eq_smul_div (3) 22 (3) (22) (by decide) (by decide))
    (eq_smul_div (3) 22 (3) (22) (by decide) (by decide))

public def ACell6_3 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (3 / 22 : ℚ)
  | 1 => 0
  | 2 => (3 / 22 : ℚ)
  | 3 => (3 / 11 : ℚ)
  | 4 => (3 / 22 : ℚ)
  | 5 => (3 / 22 : ℚ)
  | 6 => (3 / 22 : ℚ)
  | 7 => (3 / 22 : ℚ)
  | 8 => (3 / 11 : ℚ)
  | 9 => (3 / 22 : ℚ)
  | _ => 0

public theorem ACell6_3_def : ACell6_3 = ![(3 / 22 : ℚ), 0, (3 / 22 : ℚ), (3 / 11 : ℚ), (3 / 22 : ℚ), (3 / 22 : ℚ), (3 / 22 : ℚ), (3 / 22 : ℚ), (3 / 11 : ℚ), (3 / 22 : ℚ)] := by
  funext i
  fin_cases i <;> rfl

public theorem ACell6_3_scaled :
    toVec #v[3, 0, 3, 6, 3, 3, 3, 3, 6, 3] = ((22 : ℤ) : ℚ) • ACell6_3 :=
  toVec_eq_smul10 #v[3, 0, 3, 6, 3, 3, 3, 3, 6, 3] 22 ACell6_3
    (eq_smul_div (3) 22 (3) (22) (by decide) (by decide))
    (eq_smul_zero 22)
    (eq_smul_div (3) 22 (3) (22) (by decide) (by decide))
    (eq_smul_div (6) 22 (3) (11) (by decide) (by decide))
    (eq_smul_div (3) 22 (3) (22) (by decide) (by decide))
    (eq_smul_div (3) 22 (3) (22) (by decide) (by decide))
    (eq_smul_div (3) 22 (3) (22) (by decide) (by decide))
    (eq_smul_div (3) 22 (3) (22) (by decide) (by decide))
    (eq_smul_div (6) 22 (3) (11) (by decide) (by decide))
    (eq_smul_div (3) 22 (3) (22) (by decide) (by decide))

public def ACell6_4 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => 0
  | 1 => (-3 / 22 : ℚ)
  | 2 => 0
  | 3 => 0
  | 4 => (3 / 22 : ℚ)
  | 5 => 0
  | 6 => (3 / 22 : ℚ)
  | 7 => 0
  | 8 => 0
  | 9 => (-3 / 22 : ℚ)
  | _ => 0

public theorem ACell6_4_def : ACell6_4 = ![0, (-3 / 22 : ℚ), 0, 0, (3 / 22 : ℚ), 0, (3 / 22 : ℚ), 0, 0, (-3 / 22 : ℚ)] := by
  funext i
  fin_cases i <;> rfl

public theorem ACell6_4_scaled :
    toVec #v[0, -3, 0, 0, 3, 0, 3, 0, 0, -3] = ((22 : ℤ) : ℚ) • ACell6_4 :=
  toVec_eq_smul10 #v[0, -3, 0, 0, 3, 0, 3, 0, 0, -3] 22 ACell6_4
    (eq_smul_zero 22)
    (eq_smul_div (-3) 22 (-3) (22) (by decide) (by decide))
    (eq_smul_zero 22)
    (eq_smul_zero 22)
    (eq_smul_div (3) 22 (3) (22) (by decide) (by decide))
    (eq_smul_zero 22)
    (eq_smul_div (3) 22 (3) (22) (by decide) (by decide))
    (eq_smul_zero 22)
    (eq_smul_zero 22)
    (eq_smul_div (-3) 22 (-3) (22) (by decide) (by decide))

public def ACell6_5 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (-1 / 11 : ℚ)
  | 1 => (1 / 11 : ℚ)
  | 2 => (1 / 11 : ℚ)
  | 3 => 0
  | 4 => (-2 / 11 : ℚ)
  | 5 => 0
  | 6 => (1 / 11 : ℚ)
  | 7 => (1 / 11 : ℚ)
  | 8 => (-1 / 11 : ℚ)
  | 9 => 0
  | _ => 0

public theorem ACell6_5_def : ACell6_5 = ![(-1 / 11 : ℚ), (1 / 11 : ℚ), (1 / 11 : ℚ), 0, (-2 / 11 : ℚ), 0, (1 / 11 : ℚ), (1 / 11 : ℚ), (-1 / 11 : ℚ), 0] := by
  funext i
  fin_cases i <;> rfl

public theorem ACell6_5_scaled :
    toVec #v[-1, 1, 1, 0, -2, 0, 1, 1, -1, 0] = ((11 : ℤ) : ℚ) • ACell6_5 :=
  toVec_eq_smul10 #v[-1, 1, 1, 0, -2, 0, 1, 1, -1, 0] 11 ACell6_5
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_zero 11)

public def ACell6_6 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (-12 / 11 : ℚ)
  | 1 => 0
  | 2 => (-1 / 11 : ℚ)
  | 3 => (2 / 11 : ℚ)
  | 4 => (-1 / 11 : ℚ)
  | 5 => 0
  | 6 => (-1 / 11 : ℚ)
  | 7 => 0
  | 8 => (1 / 11 : ℚ)
  | 9 => (1 / 11 : ℚ)
  | _ => 0

public theorem ACell6_6_def : ACell6_6 = ![(-12 / 11 : ℚ), 0, (-1 / 11 : ℚ), (2 / 11 : ℚ), (-1 / 11 : ℚ), 0, (-1 / 11 : ℚ), 0, (1 / 11 : ℚ), (1 / 11 : ℚ)] := by
  funext i
  fin_cases i <;> rfl

public theorem ACell6_6_scaled :
    toVec #v[-12, 0, -1, 2, -1, 0, -1, 0, 1, 1] = ((11 : ℤ) : ℚ) • ACell6_6 :=
  toVec_eq_smul10 #v[-12, 0, -1, 2, -1, 0, -1, 0, 1, 1] 11 ACell6_6
    (eq_smul_div (-12) 11 (-12) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))

public def ACell6_7 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (-1 / 11 : ℚ)
  | 1 => (1 / 11 : ℚ)
  | 2 => (2 / 11 : ℚ)
  | 3 => (1 / 11 : ℚ)
  | 4 => (-1 / 11 : ℚ)
  | 5 => 0
  | 6 => 0
  | 7 => (-1 / 11 : ℚ)
  | 8 => (-1 / 11 : ℚ)
  | 9 => 0
  | _ => 0

public theorem ACell6_7_def : ACell6_7 = ![(-1 / 11 : ℚ), (1 / 11 : ℚ), (2 / 11 : ℚ), (1 / 11 : ℚ), (-1 / 11 : ℚ), 0, 0, (-1 / 11 : ℚ), (-1 / 11 : ℚ), 0] := by
  funext i
  fin_cases i <;> rfl

public theorem ACell6_7_scaled :
    toVec #v[-1, 1, 2, 1, -1, 0, 0, -1, -1, 0] = ((11 : ℤ) : ℚ) • ACell6_7 :=
  toVec_eq_smul10 #v[-1, 1, 2, 1, -1, 0, 0, -1, -1, 0] 11 ACell6_7
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_zero 11)
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_zero 11)

public def ACell6_8 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => 0
  | 1 => 0
  | 2 => 0
  | 3 => (-2 / 11 : ℚ)
  | 4 => (-1 / 11 : ℚ)
  | 5 => (-1 / 11 : ℚ)
  | 6 => (-3 / 11 : ℚ)
  | 7 => (-1 / 11 : ℚ)
  | 8 => (-1 / 11 : ℚ)
  | 9 => (-2 / 11 : ℚ)
  | _ => 0

public theorem ACell6_8_def : ACell6_8 = ![0, 0, 0, (-2 / 11 : ℚ), (-1 / 11 : ℚ), (-1 / 11 : ℚ), (-3 / 11 : ℚ), (-1 / 11 : ℚ), (-1 / 11 : ℚ), (-2 / 11 : ℚ)] := by
  funext i
  fin_cases i <;> rfl

public theorem ACell6_8_scaled :
    toVec #v[0, 0, 0, -2, -1, -1, -3, -1, -1, -2] = ((11 : ℤ) : ℚ) • ACell6_8 :=
  toVec_eq_smul10 #v[0, 0, 0, -2, -1, -1, -3, -1, -1, -2] 11 ACell6_8
    (eq_smul_zero 11)
    (eq_smul_zero 11)
    (eq_smul_zero 11)
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_div (-3) 11 (-3) (11) (by decide) (by decide))
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))

public def ACell6_9 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (2 / 11 : ℚ)
  | 1 => (1 / 11 : ℚ)
  | 2 => 0
  | 3 => (1 / 11 : ℚ)
  | 4 => (1 / 11 : ℚ)
  | 5 => 0
  | 6 => (1 / 11 : ℚ)
  | 7 => (2 / 11 : ℚ)
  | 8 => 0
  | 9 => (3 / 11 : ℚ)
  | _ => 0

public theorem ACell6_9_def : ACell6_9 = ![(2 / 11 : ℚ), (1 / 11 : ℚ), 0, (1 / 11 : ℚ), (1 / 11 : ℚ), 0, (1 / 11 : ℚ), (2 / 11 : ℚ), 0, (3 / 11 : ℚ)] := by
  funext i
  fin_cases i <;> rfl

public theorem ACell6_9_scaled :
    toVec #v[2, 1, 0, 1, 1, 0, 1, 2, 0, 3] = ((11 : ℤ) : ℚ) • ACell6_9 :=
  toVec_eq_smul10 #v[2, 1, 0, 1, 1, 0, 1, 2, 0, 3] 11 ACell6_9
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_div (3) 11 (3) (11) (by decide) (by decide))

public def ARow6 (j : Fin 10) : Vec :=
  match j.val with
  | 0 => ACell6_0
  | 1 => ACell6_1
  | 2 => ACell6_2
  | 3 => ACell6_3
  | 4 => ACell6_4
  | 5 => ACell6_5
  | 6 => ACell6_6
  | 7 => ACell6_7
  | 8 => ACell6_8
  | 9 => ACell6_9
  | _ => 0

public def ACell7_0 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => 0
  | 1 => 0
  | 2 => (3 / 22 : ℚ)
  | 3 => (-3 / 22 : ℚ)
  | 4 => (-3 / 22 : ℚ)
  | 5 => (3 / 22 : ℚ)
  | 6 => 0
  | 7 => 0
  | 8 => 0
  | 9 => 0
  | _ => 0

public theorem ACell7_0_def : ACell7_0 = ![0, 0, (3 / 22 : ℚ), (-3 / 22 : ℚ), (-3 / 22 : ℚ), (3 / 22 : ℚ), 0, 0, 0, 0] := by
  funext i
  fin_cases i <;> rfl

public theorem ACell7_0_scaled :
    toVec #v[0, 0, 3, -3, -3, 3, 0, 0, 0, 0] = ((22 : ℤ) : ℚ) • ACell7_0 :=
  toVec_eq_smul10 #v[0, 0, 3, -3, -3, 3, 0, 0, 0, 0] 22 ACell7_0
    (eq_smul_zero 22)
    (eq_smul_zero 22)
    (eq_smul_div (3) 22 (3) (22) (by decide) (by decide))
    (eq_smul_div (-3) 22 (-3) (22) (by decide) (by decide))
    (eq_smul_div (-3) 22 (-3) (22) (by decide) (by decide))
    (eq_smul_div (3) 22 (3) (22) (by decide) (by decide))
    (eq_smul_zero 22)
    (eq_smul_zero 22)
    (eq_smul_zero 22)
    (eq_smul_zero 22)

public def ACell7_1 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (-3 / 22 : ℚ)
  | 1 => (-3 / 22 : ℚ)
  | 2 => (-3 / 22 : ℚ)
  | 3 => (-3 / 22 : ℚ)
  | 4 => 0
  | 5 => (-3 / 22 : ℚ)
  | 6 => (-3 / 11 : ℚ)
  | 7 => (-3 / 22 : ℚ)
  | 8 => (-3 / 11 : ℚ)
  | 9 => (-3 / 22 : ℚ)
  | _ => 0

public theorem ACell7_1_def : ACell7_1 = ![(-3 / 22 : ℚ), (-3 / 22 : ℚ), (-3 / 22 : ℚ), (-3 / 22 : ℚ), 0, (-3 / 22 : ℚ), (-3 / 11 : ℚ), (-3 / 22 : ℚ), (-3 / 11 : ℚ), (-3 / 22 : ℚ)] := by
  funext i
  fin_cases i <;> rfl

public theorem ACell7_1_scaled :
    toVec #v[-3, -3, -3, -3, 0, -3, -6, -3, -6, -3] = ((22 : ℤ) : ℚ) • ACell7_1 :=
  toVec_eq_smul10 #v[-3, -3, -3, -3, 0, -3, -6, -3, -6, -3] 22 ACell7_1
    (eq_smul_div (-3) 22 (-3) (22) (by decide) (by decide))
    (eq_smul_div (-3) 22 (-3) (22) (by decide) (by decide))
    (eq_smul_div (-3) 22 (-3) (22) (by decide) (by decide))
    (eq_smul_div (-3) 22 (-3) (22) (by decide) (by decide))
    (eq_smul_zero 22)
    (eq_smul_div (-3) 22 (-3) (22) (by decide) (by decide))
    (eq_smul_div (-6) 22 (-3) (11) (by decide) (by decide))
    (eq_smul_div (-3) 22 (-3) (22) (by decide) (by decide))
    (eq_smul_div (-6) 22 (-3) (11) (by decide) (by decide))
    (eq_smul_div (-3) 22 (-3) (22) (by decide) (by decide))

public def ACell7_2 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (-3 / 22 : ℚ)
  | 1 => 0
  | 2 => (-3 / 22 : ℚ)
  | 3 => (-3 / 22 : ℚ)
  | 4 => (-3 / 11 : ℚ)
  | 5 => (-3 / 22 : ℚ)
  | 6 => (-3 / 22 : ℚ)
  | 7 => (-3 / 11 : ℚ)
  | 8 => (-3 / 22 : ℚ)
  | 9 => (-3 / 22 : ℚ)
  | _ => 0

public theorem ACell7_2_def : ACell7_2 = ![(-3 / 22 : ℚ), 0, (-3 / 22 : ℚ), (-3 / 22 : ℚ), (-3 / 11 : ℚ), (-3 / 22 : ℚ), (-3 / 22 : ℚ), (-3 / 11 : ℚ), (-3 / 22 : ℚ), (-3 / 22 : ℚ)] := by
  funext i
  fin_cases i <;> rfl

public theorem ACell7_2_scaled :
    toVec #v[-3, 0, -3, -3, -6, -3, -3, -6, -3, -3] = ((22 : ℤ) : ℚ) • ACell7_2 :=
  toVec_eq_smul10 #v[-3, 0, -3, -3, -6, -3, -3, -6, -3, -3] 22 ACell7_2
    (eq_smul_div (-3) 22 (-3) (22) (by decide) (by decide))
    (eq_smul_zero 22)
    (eq_smul_div (-3) 22 (-3) (22) (by decide) (by decide))
    (eq_smul_div (-3) 22 (-3) (22) (by decide) (by decide))
    (eq_smul_div (-6) 22 (-3) (11) (by decide) (by decide))
    (eq_smul_div (-3) 22 (-3) (22) (by decide) (by decide))
    (eq_smul_div (-3) 22 (-3) (22) (by decide) (by decide))
    (eq_smul_div (-6) 22 (-3) (11) (by decide) (by decide))
    (eq_smul_div (-3) 22 (-3) (22) (by decide) (by decide))
    (eq_smul_div (-3) 22 (-3) (22) (by decide) (by decide))

public def ACell7_3 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => 0
  | 1 => (-3 / 22 : ℚ)
  | 2 => 0
  | 3 => 0
  | 4 => (3 / 22 : ℚ)
  | 5 => (3 / 22 : ℚ)
  | 6 => 0
  | 7 => 0
  | 8 => (-3 / 22 : ℚ)
  | 9 => 0
  | _ => 0

public theorem ACell7_3_def : ACell7_3 = ![0, (-3 / 22 : ℚ), 0, 0, (3 / 22 : ℚ), (3 / 22 : ℚ), 0, 0, (-3 / 22 : ℚ), 0] := by
  funext i
  fin_cases i <;> rfl

public theorem ACell7_3_scaled :
    toVec #v[0, -3, 0, 0, 3, 3, 0, 0, -3, 0] = ((22 : ℤ) : ℚ) • ACell7_3 :=
  toVec_eq_smul10 #v[0, -3, 0, 0, 3, 3, 0, 0, -3, 0] 22 ACell7_3
    (eq_smul_zero 22)
    (eq_smul_div (-3) 22 (-3) (22) (by decide) (by decide))
    (eq_smul_zero 22)
    (eq_smul_zero 22)
    (eq_smul_div (3) 22 (3) (22) (by decide) (by decide))
    (eq_smul_div (3) 22 (3) (22) (by decide) (by decide))
    (eq_smul_zero 22)
    (eq_smul_zero 22)
    (eq_smul_div (-3) 22 (-3) (22) (by decide) (by decide))
    (eq_smul_zero 22)

public def ACell7_4 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => 0
  | 1 => (-3 / 22 : ℚ)
  | 2 => (3 / 22 : ℚ)
  | 3 => 0
  | 4 => 0
  | 5 => 0
  | 6 => (3 / 22 : ℚ)
  | 7 => (-3 / 22 : ℚ)
  | 8 => 0
  | 9 => 0
  | _ => 0

public theorem ACell7_4_def : ACell7_4 = ![0, (-3 / 22 : ℚ), (3 / 22 : ℚ), 0, 0, 0, (3 / 22 : ℚ), (-3 / 22 : ℚ), 0, 0] := by
  funext i
  fin_cases i <;> rfl

public theorem ACell7_4_scaled :
    toVec #v[0, -3, 3, 0, 0, 0, 3, -3, 0, 0] = ((22 : ℤ) : ℚ) • ACell7_4 :=
  toVec_eq_smul10 #v[0, -3, 3, 0, 0, 0, 3, -3, 0, 0] 22 ACell7_4
    (eq_smul_zero 22)
    (eq_smul_div (-3) 22 (-3) (22) (by decide) (by decide))
    (eq_smul_div (3) 22 (3) (22) (by decide) (by decide))
    (eq_smul_zero 22)
    (eq_smul_zero 22)
    (eq_smul_zero 22)
    (eq_smul_div (3) 22 (3) (22) (by decide) (by decide))
    (eq_smul_div (-3) 22 (-3) (22) (by decide) (by decide))
    (eq_smul_zero 22)
    (eq_smul_zero 22)

public def ACell7_5 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (-2 / 11 : ℚ)
  | 1 => (-1 / 11 : ℚ)
  | 2 => (-1 / 11 : ℚ)
  | 3 => (-3 / 11 : ℚ)
  | 4 => (-1 / 11 : ℚ)
  | 5 => (-1 / 11 : ℚ)
  | 6 => (-2 / 11 : ℚ)
  | 7 => 0
  | 8 => 0
  | 9 => 0
  | _ => 0

public theorem ACell7_5_def : ACell7_5 = ![(-2 / 11 : ℚ), (-1 / 11 : ℚ), (-1 / 11 : ℚ), (-3 / 11 : ℚ), (-1 / 11 : ℚ), (-1 / 11 : ℚ), (-2 / 11 : ℚ), 0, 0, 0] := by
  funext i
  fin_cases i <;> rfl

public theorem ACell7_5_scaled :
    toVec #v[-2, -1, -1, -3, -1, -1, -2, 0, 0, 0] = ((11 : ℤ) : ℚ) • ACell7_5 :=
  toVec_eq_smul10 #v[-2, -1, -1, -3, -1, -1, -2, 0, 0, 0] 11 ACell7_5
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_div (-3) 11 (-3) (11) (by decide) (by decide))
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_zero 11)
    (eq_smul_zero 11)

public def ACell7_6 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (-1 / 11 : ℚ)
  | 1 => (1 / 11 : ℚ)
  | 2 => (2 / 11 : ℚ)
  | 3 => (1 / 11 : ℚ)
  | 4 => (-1 / 11 : ℚ)
  | 5 => 0
  | 6 => 0
  | 7 => (-1 / 11 : ℚ)
  | 8 => (-1 / 11 : ℚ)
  | 9 => 0
  | _ => 0

public theorem ACell7_6_def : ACell7_6 = ![(-1 / 11 : ℚ), (1 / 11 : ℚ), (2 / 11 : ℚ), (1 / 11 : ℚ), (-1 / 11 : ℚ), 0, 0, (-1 / 11 : ℚ), (-1 / 11 : ℚ), 0] := by
  funext i
  fin_cases i <;> rfl

public theorem ACell7_6_scaled :
    toVec #v[-1, 1, 2, 1, -1, 0, 0, -1, -1, 0] = ((11 : ℤ) : ℚ) • ACell7_6 :=
  toVec_eq_smul10 #v[-1, 1, 2, 1, -1, 0, 0, -1, -1, 0] 11 ACell7_6
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_zero 11)
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_zero 11)

public def ACell7_7 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (-13 / 11 : ℚ)
  | 1 => (1 / 11 : ℚ)
  | 2 => (-2 / 11 : ℚ)
  | 3 => 0
  | 4 => (-1 / 11 : ℚ)
  | 5 => (-2 / 11 : ℚ)
  | 6 => (-1 / 11 : ℚ)
  | 7 => (-1 / 11 : ℚ)
  | 8 => (-2 / 11 : ℚ)
  | 9 => (-1 / 11 : ℚ)
  | _ => 0

public theorem ACell7_7_def : ACell7_7 = ![(-13 / 11 : ℚ), (1 / 11 : ℚ), (-2 / 11 : ℚ), 0, (-1 / 11 : ℚ), (-2 / 11 : ℚ), (-1 / 11 : ℚ), (-1 / 11 : ℚ), (-2 / 11 : ℚ), (-1 / 11 : ℚ)] := by
  funext i
  fin_cases i <;> rfl

public theorem ACell7_7_scaled :
    toVec #v[-13, 1, -2, 0, -1, -2, -1, -1, -2, -1] = ((11 : ℤ) : ℚ) • ACell7_7 :=
  toVec_eq_smul10 #v[-13, 1, -2, 0, -1, -2, -1, -1, -2, -1] 11 ACell7_7
    (eq_smul_div (-13) 11 (-13) (11) (by decide) (by decide))
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))

public def ACell7_8 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => 0
  | 1 => (1 / 11 : ℚ)
  | 2 => (2 / 11 : ℚ)
  | 3 => (1 / 11 : ℚ)
  | 4 => (2 / 11 : ℚ)
  | 5 => (-1 / 11 : ℚ)
  | 6 => (2 / 11 : ℚ)
  | 7 => (1 / 11 : ℚ)
  | 8 => (2 / 11 : ℚ)
  | 9 => (1 / 11 : ℚ)
  | _ => 0

public theorem ACell7_8_def : ACell7_8 = ![0, (1 / 11 : ℚ), (2 / 11 : ℚ), (1 / 11 : ℚ), (2 / 11 : ℚ), (-1 / 11 : ℚ), (2 / 11 : ℚ), (1 / 11 : ℚ), (2 / 11 : ℚ), (1 / 11 : ℚ)] := by
  funext i
  fin_cases i <;> rfl

public theorem ACell7_8_scaled :
    toVec #v[0, 1, 2, 1, 2, -1, 2, 1, 2, 1] = ((11 : ℤ) : ℚ) • ACell7_8 :=
  toVec_eq_smul10 #v[0, 1, 2, 1, 2, -1, 2, 1, 2, 1] 11 ACell7_8
    (eq_smul_zero 11)
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))

public def ACell7_9 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => 0
  | 1 => (2 / 11 : ℚ)
  | 2 => (1 / 11 : ℚ)
  | 3 => (1 / 11 : ℚ)
  | 4 => (2 / 11 : ℚ)
  | 5 => 0
  | 6 => 0
  | 7 => (1 / 11 : ℚ)
  | 8 => (3 / 11 : ℚ)
  | 9 => (1 / 11 : ℚ)
  | _ => 0

public theorem ACell7_9_def : ACell7_9 = ![0, (2 / 11 : ℚ), (1 / 11 : ℚ), (1 / 11 : ℚ), (2 / 11 : ℚ), 0, 0, (1 / 11 : ℚ), (3 / 11 : ℚ), (1 / 11 : ℚ)] := by
  funext i
  fin_cases i <;> rfl

public theorem ACell7_9_scaled :
    toVec #v[0, 2, 1, 1, 2, 0, 0, 1, 3, 1] = ((11 : ℤ) : ℚ) • ACell7_9 :=
  toVec_eq_smul10 #v[0, 2, 1, 1, 2, 0, 0, 1, 3, 1] 11 ACell7_9
    (eq_smul_zero 11)
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_zero 11)
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))
    (eq_smul_div (3) 11 (3) (11) (by decide) (by decide))
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))

public def ARow7 (j : Fin 10) : Vec :=
  match j.val with
  | 0 => ACell7_0
  | 1 => ACell7_1
  | 2 => ACell7_2
  | 3 => ACell7_3
  | 4 => ACell7_4
  | 5 => ACell7_5
  | 6 => ACell7_6
  | 7 => ACell7_7
  | 8 => ACell7_8
  | 9 => ACell7_9
  | _ => 0

public def ACell8_0 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => 0
  | 1 => (-3 / 22 : ℚ)
  | 2 => 0
  | 3 => (-3 / 22 : ℚ)
  | 4 => 0
  | 5 => 0
  | 6 => (3 / 22 : ℚ)
  | 7 => 0
  | 8 => 0
  | 9 => (3 / 22 : ℚ)
  | _ => 0

public theorem ACell8_0_def : ACell8_0 = ![0, (-3 / 22 : ℚ), 0, (-3 / 22 : ℚ), 0, 0, (3 / 22 : ℚ), 0, 0, (3 / 22 : ℚ)] := by
  funext i
  fin_cases i <;> rfl

public theorem ACell8_0_scaled :
    toVec #v[0, -3, 0, -3, 0, 0, 3, 0, 0, 3] = ((22 : ℤ) : ℚ) • ACell8_0 :=
  toVec_eq_smul10 #v[0, -3, 0, -3, 0, 0, 3, 0, 0, 3] 22 ACell8_0
    (eq_smul_zero 22)
    (eq_smul_div (-3) 22 (-3) (22) (by decide) (by decide))
    (eq_smul_zero 22)
    (eq_smul_div (-3) 22 (-3) (22) (by decide) (by decide))
    (eq_smul_zero 22)
    (eq_smul_zero 22)
    (eq_smul_div (3) 22 (3) (22) (by decide) (by decide))
    (eq_smul_zero 22)
    (eq_smul_zero 22)
    (eq_smul_div (3) 22 (3) (22) (by decide) (by decide))

public def ACell8_1 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => 0
  | 1 => 0
  | 2 => (-3 / 22 : ℚ)
  | 3 => (3 / 22 : ℚ)
  | 4 => 0
  | 5 => 0
  | 6 => 0
  | 7 => 0
  | 8 => (3 / 22 : ℚ)
  | 9 => (-3 / 22 : ℚ)
  | _ => 0

public theorem ACell8_1_def : ACell8_1 = ![0, 0, (-3 / 22 : ℚ), (3 / 22 : ℚ), 0, 0, 0, 0, (3 / 22 : ℚ), (-3 / 22 : ℚ)] := by
  funext i
  fin_cases i <;> rfl

public theorem ACell8_1_scaled :
    toVec #v[0, 0, -3, 3, 0, 0, 0, 0, 3, -3] = ((22 : ℤ) : ℚ) • ACell8_1 :=
  toVec_eq_smul10 #v[0, 0, -3, 3, 0, 0, 0, 0, 3, -3] 22 ACell8_1
    (eq_smul_zero 22)
    (eq_smul_zero 22)
    (eq_smul_div (-3) 22 (-3) (22) (by decide) (by decide))
    (eq_smul_div (3) 22 (3) (22) (by decide) (by decide))
    (eq_smul_zero 22)
    (eq_smul_zero 22)
    (eq_smul_zero 22)
    (eq_smul_zero 22)
    (eq_smul_div (3) 22 (3) (22) (by decide) (by decide))
    (eq_smul_div (-3) 22 (-3) (22) (by decide) (by decide))

public def ACell8_2 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => 0
  | 1 => (-3 / 22 : ℚ)
  | 2 => 0
  | 3 => (3 / 22 : ℚ)
  | 4 => 0
  | 5 => (3 / 22 : ℚ)
  | 6 => 0
  | 7 => (-3 / 22 : ℚ)
  | 8 => 0
  | 9 => 0
  | _ => 0

public theorem ACell8_2_def : ACell8_2 = ![0, (-3 / 22 : ℚ), 0, (3 / 22 : ℚ), 0, (3 / 22 : ℚ), 0, (-3 / 22 : ℚ), 0, 0] := by
  funext i
  fin_cases i <;> rfl

public theorem ACell8_2_scaled :
    toVec #v[0, -3, 0, 3, 0, 3, 0, -3, 0, 0] = ((22 : ℤ) : ℚ) • ACell8_2 :=
  toVec_eq_smul10 #v[0, -3, 0, 3, 0, 3, 0, -3, 0, 0] 22 ACell8_2
    (eq_smul_zero 22)
    (eq_smul_div (-3) 22 (-3) (22) (by decide) (by decide))
    (eq_smul_zero 22)
    (eq_smul_div (3) 22 (3) (22) (by decide) (by decide))
    (eq_smul_zero 22)
    (eq_smul_div (3) 22 (3) (22) (by decide) (by decide))
    (eq_smul_zero 22)
    (eq_smul_div (-3) 22 (-3) (22) (by decide) (by decide))
    (eq_smul_zero 22)
    (eq_smul_zero 22)

public def ACell8_3 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (3 / 22 : ℚ)
  | 1 => (3 / 22 : ℚ)
  | 2 => (3 / 22 : ℚ)
  | 3 => (3 / 22 : ℚ)
  | 4 => (3 / 22 : ℚ)
  | 5 => (3 / 22 : ℚ)
  | 6 => (3 / 22 : ℚ)
  | 7 => 0
  | 8 => (3 / 11 : ℚ)
  | 9 => (3 / 11 : ℚ)
  | _ => 0

public theorem ACell8_3_def : ACell8_3 = ![(3 / 22 : ℚ), (3 / 22 : ℚ), (3 / 22 : ℚ), (3 / 22 : ℚ), (3 / 22 : ℚ), (3 / 22 : ℚ), (3 / 22 : ℚ), 0, (3 / 11 : ℚ), (3 / 11 : ℚ)] := by
  funext i
  fin_cases i <;> rfl

public theorem ACell8_3_scaled :
    toVec #v[3, 3, 3, 3, 3, 3, 3, 0, 6, 6] = ((22 : ℤ) : ℚ) • ACell8_3 :=
  toVec_eq_smul10 #v[3, 3, 3, 3, 3, 3, 3, 0, 6, 6] 22 ACell8_3
    (eq_smul_div (3) 22 (3) (22) (by decide) (by decide))
    (eq_smul_div (3) 22 (3) (22) (by decide) (by decide))
    (eq_smul_div (3) 22 (3) (22) (by decide) (by decide))
    (eq_smul_div (3) 22 (3) (22) (by decide) (by decide))
    (eq_smul_div (3) 22 (3) (22) (by decide) (by decide))
    (eq_smul_div (3) 22 (3) (22) (by decide) (by decide))
    (eq_smul_div (3) 22 (3) (22) (by decide) (by decide))
    (eq_smul_zero 22)
    (eq_smul_div (6) 22 (3) (11) (by decide) (by decide))
    (eq_smul_div (6) 22 (3) (11) (by decide) (by decide))

public def ACell8_4 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (-3 / 22 : ℚ)
  | 1 => (-3 / 22 : ℚ)
  | 2 => (-3 / 11 : ℚ)
  | 3 => (-3 / 11 : ℚ)
  | 4 => (-3 / 22 : ℚ)
  | 5 => (-3 / 22 : ℚ)
  | 6 => 0
  | 7 => (-3 / 22 : ℚ)
  | 8 => (-3 / 22 : ℚ)
  | 9 => (-3 / 22 : ℚ)
  | _ => 0

public theorem ACell8_4_def : ACell8_4 = ![(-3 / 22 : ℚ), (-3 / 22 : ℚ), (-3 / 11 : ℚ), (-3 / 11 : ℚ), (-3 / 22 : ℚ), (-3 / 22 : ℚ), 0, (-3 / 22 : ℚ), (-3 / 22 : ℚ), (-3 / 22 : ℚ)] := by
  funext i
  fin_cases i <;> rfl

public theorem ACell8_4_scaled :
    toVec #v[-3, -3, -6, -6, -3, -3, 0, -3, -3, -3] = ((22 : ℤ) : ℚ) • ACell8_4 :=
  toVec_eq_smul10 #v[-3, -3, -6, -6, -3, -3, 0, -3, -3, -3] 22 ACell8_4
    (eq_smul_div (-3) 22 (-3) (22) (by decide) (by decide))
    (eq_smul_div (-3) 22 (-3) (22) (by decide) (by decide))
    (eq_smul_div (-6) 22 (-3) (11) (by decide) (by decide))
    (eq_smul_div (-6) 22 (-3) (11) (by decide) (by decide))
    (eq_smul_div (-3) 22 (-3) (22) (by decide) (by decide))
    (eq_smul_div (-3) 22 (-3) (22) (by decide) (by decide))
    (eq_smul_zero 22)
    (eq_smul_div (-3) 22 (-3) (22) (by decide) (by decide))
    (eq_smul_div (-3) 22 (-3) (22) (by decide) (by decide))
    (eq_smul_div (-3) 22 (-3) (22) (by decide) (by decide))

public def ACell8_5 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (-1 / 11 : ℚ)
  | 1 => 0
  | 2 => 0
  | 3 => (-1 / 11 : ℚ)
  | 4 => 0
  | 5 => (1 / 11 : ℚ)
  | 6 => (-1 / 11 : ℚ)
  | 7 => (2 / 11 : ℚ)
  | 8 => (-1 / 11 : ℚ)
  | 9 => (1 / 11 : ℚ)
  | _ => 0

public theorem ACell8_5_def : ACell8_5 = ![(-1 / 11 : ℚ), 0, 0, (-1 / 11 : ℚ), 0, (1 / 11 : ℚ), (-1 / 11 : ℚ), (2 / 11 : ℚ), (-1 / 11 : ℚ), (1 / 11 : ℚ)] := by
  funext i
  fin_cases i <;> rfl

public theorem ACell8_5_scaled :
    toVec #v[-1, 0, 0, -1, 0, 1, -1, 2, -1, 1] = ((11 : ℤ) : ℚ) • ACell8_5 :=
  toVec_eq_smul10 #v[-1, 0, 0, -1, 0, 1, -1, 2, -1, 1] 11 ACell8_5
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_zero 11)
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))

public def ACell8_6 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => 0
  | 1 => 0
  | 2 => 0
  | 3 => (-2 / 11 : ℚ)
  | 4 => (-1 / 11 : ℚ)
  | 5 => (-1 / 11 : ℚ)
  | 6 => (-3 / 11 : ℚ)
  | 7 => (-1 / 11 : ℚ)
  | 8 => (-1 / 11 : ℚ)
  | 9 => (-2 / 11 : ℚ)
  | _ => 0

public theorem ACell8_6_def : ACell8_6 = ![0, 0, 0, (-2 / 11 : ℚ), (-1 / 11 : ℚ), (-1 / 11 : ℚ), (-3 / 11 : ℚ), (-1 / 11 : ℚ), (-1 / 11 : ℚ), (-2 / 11 : ℚ)] := by
  funext i
  fin_cases i <;> rfl

public theorem ACell8_6_scaled :
    toVec #v[0, 0, 0, -2, -1, -1, -3, -1, -1, -2] = ((11 : ℤ) : ℚ) • ACell8_6 :=
  toVec_eq_smul10 #v[0, 0, 0, -2, -1, -1, -3, -1, -1, -2] 11 ACell8_6
    (eq_smul_zero 11)
    (eq_smul_zero 11)
    (eq_smul_zero 11)
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_div (-3) 11 (-3) (11) (by decide) (by decide))
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))

public def ACell8_7 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => 0
  | 1 => (1 / 11 : ℚ)
  | 2 => (2 / 11 : ℚ)
  | 3 => (1 / 11 : ℚ)
  | 4 => (2 / 11 : ℚ)
  | 5 => (-1 / 11 : ℚ)
  | 6 => (2 / 11 : ℚ)
  | 7 => (1 / 11 : ℚ)
  | 8 => (2 / 11 : ℚ)
  | 9 => (1 / 11 : ℚ)
  | _ => 0

public theorem ACell8_7_def : ACell8_7 = ![0, (1 / 11 : ℚ), (2 / 11 : ℚ), (1 / 11 : ℚ), (2 / 11 : ℚ), (-1 / 11 : ℚ), (2 / 11 : ℚ), (1 / 11 : ℚ), (2 / 11 : ℚ), (1 / 11 : ℚ)] := by
  funext i
  fin_cases i <;> rfl

public theorem ACell8_7_scaled :
    toVec #v[0, 1, 2, 1, 2, -1, 2, 1, 2, 1] = ((11 : ℤ) : ℚ) • ACell8_7 :=
  toVec_eq_smul10 #v[0, 1, 2, 1, 2, -1, 2, 1, 2, 1] 11 ACell8_7
    (eq_smul_zero 11)
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))

public def ACell8_8 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (-12 / 11 : ℚ)
  | 1 => (-1 / 11 : ℚ)
  | 2 => (1 / 11 : ℚ)
  | 3 => 0
  | 4 => 0
  | 5 => (1 / 11 : ℚ)
  | 6 => (-1 / 11 : ℚ)
  | 7 => (-1 / 11 : ℚ)
  | 8 => 0
  | 9 => (2 / 11 : ℚ)
  | _ => 0

public theorem ACell8_8_def : ACell8_8 = ![(-12 / 11 : ℚ), (-1 / 11 : ℚ), (1 / 11 : ℚ), 0, 0, (1 / 11 : ℚ), (-1 / 11 : ℚ), (-1 / 11 : ℚ), 0, (2 / 11 : ℚ)] := by
  funext i
  fin_cases i <;> rfl

public theorem ACell8_8_scaled :
    toVec #v[-12, -1, 1, 0, 0, 1, -1, -1, 0, 2] = ((11 : ℤ) : ℚ) • ACell8_8 :=
  toVec_eq_smul10 #v[-12, -1, 1, 0, 0, 1, -1, -1, 0, 2] 11 ACell8_8
    (eq_smul_div (-12) 11 (-12) (11) (by decide) (by decide))
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_zero 11)
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))

public def ACell8_9 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (-2 / 11 : ℚ)
  | 1 => (-3 / 11 : ℚ)
  | 2 => (-2 / 11 : ℚ)
  | 3 => 0
  | 4 => (-1 / 11 : ℚ)
  | 5 => (-1 / 11 : ℚ)
  | 6 => 0
  | 7 => 0
  | 8 => (-1 / 11 : ℚ)
  | 9 => (-1 / 11 : ℚ)
  | _ => 0

public theorem ACell8_9_def : ACell8_9 = ![(-2 / 11 : ℚ), (-3 / 11 : ℚ), (-2 / 11 : ℚ), 0, (-1 / 11 : ℚ), (-1 / 11 : ℚ), 0, 0, (-1 / 11 : ℚ), (-1 / 11 : ℚ)] := by
  funext i
  fin_cases i <;> rfl

public theorem ACell8_9_scaled :
    toVec #v[-2, -3, -2, 0, -1, -1, 0, 0, -1, -1] = ((11 : ℤ) : ℚ) • ACell8_9 :=
  toVec_eq_smul10 #v[-2, -3, -2, 0, -1, -1, 0, 0, -1, -1] 11 ACell8_9
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))
    (eq_smul_div (-3) 11 (-3) (11) (by decide) (by decide))
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_zero 11)
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))

public def ARow8 (j : Fin 10) : Vec :=
  match j.val with
  | 0 => ACell8_0
  | 1 => ACell8_1
  | 2 => ACell8_2
  | 3 => ACell8_3
  | 4 => ACell8_4
  | 5 => ACell8_5
  | 6 => ACell8_6
  | 7 => ACell8_7
  | 8 => ACell8_8
  | 9 => ACell8_9
  | _ => 0

public def ACell9_0 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => 0
  | 1 => 0
  | 2 => (3 / 22 : ℚ)
  | 3 => 0
  | 4 => (-3 / 22 : ℚ)
  | 5 => 0
  | 6 => (-3 / 22 : ℚ)
  | 7 => 0
  | 8 => (3 / 22 : ℚ)
  | 9 => 0
  | _ => 0

public theorem ACell9_0_def : ACell9_0 = ![0, 0, (3 / 22 : ℚ), 0, (-3 / 22 : ℚ), 0, (-3 / 22 : ℚ), 0, (3 / 22 : ℚ), 0] := by
  funext i
  fin_cases i <;> rfl

public theorem ACell9_0_scaled :
    toVec #v[0, 0, 3, 0, -3, 0, -3, 0, 3, 0] = ((22 : ℤ) : ℚ) • ACell9_0 :=
  toVec_eq_smul10 #v[0, 0, 3, 0, -3, 0, -3, 0, 3, 0] 22 ACell9_0
    (eq_smul_zero 22)
    (eq_smul_zero 22)
    (eq_smul_div (3) 22 (3) (22) (by decide) (by decide))
    (eq_smul_zero 22)
    (eq_smul_div (-3) 22 (-3) (22) (by decide) (by decide))
    (eq_smul_zero 22)
    (eq_smul_div (-3) 22 (-3) (22) (by decide) (by decide))
    (eq_smul_zero 22)
    (eq_smul_div (3) 22 (3) (22) (by decide) (by decide))
    (eq_smul_zero 22)

public def ACell9_1 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => 0
  | 1 => (-3 / 22 : ℚ)
  | 2 => 0
  | 3 => 0
  | 4 => 0
  | 5 => (-3 / 22 : ℚ)
  | 6 => 0
  | 7 => 0
  | 8 => (3 / 22 : ℚ)
  | 9 => (3 / 22 : ℚ)
  | _ => 0

public theorem ACell9_1_def : ACell9_1 = ![0, (-3 / 22 : ℚ), 0, 0, 0, (-3 / 22 : ℚ), 0, 0, (3 / 22 : ℚ), (3 / 22 : ℚ)] := by
  funext i
  fin_cases i <;> rfl

public theorem ACell9_1_scaled :
    toVec #v[0, -3, 0, 0, 0, -3, 0, 0, 3, 3] = ((22 : ℤ) : ℚ) • ACell9_1 :=
  toVec_eq_smul10 #v[0, -3, 0, 0, 0, -3, 0, 0, 3, 3] 22 ACell9_1
    (eq_smul_zero 22)
    (eq_smul_div (-3) 22 (-3) (22) (by decide) (by decide))
    (eq_smul_zero 22)
    (eq_smul_zero 22)
    (eq_smul_zero 22)
    (eq_smul_div (-3) 22 (-3) (22) (by decide) (by decide))
    (eq_smul_zero 22)
    (eq_smul_zero 22)
    (eq_smul_div (3) 22 (3) (22) (by decide) (by decide))
    (eq_smul_div (3) 22 (3) (22) (by decide) (by decide))

public def ACell9_2 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (3 / 22 : ℚ)
  | 1 => (3 / 22 : ℚ)
  | 2 => (3 / 22 : ℚ)
  | 3 => (3 / 22 : ℚ)
  | 4 => 0
  | 5 => (3 / 11 : ℚ)
  | 6 => (3 / 22 : ℚ)
  | 7 => (3 / 22 : ℚ)
  | 8 => (3 / 22 : ℚ)
  | 9 => (3 / 11 : ℚ)
  | _ => 0

public theorem ACell9_2_def : ACell9_2 = ![(3 / 22 : ℚ), (3 / 22 : ℚ), (3 / 22 : ℚ), (3 / 22 : ℚ), 0, (3 / 11 : ℚ), (3 / 22 : ℚ), (3 / 22 : ℚ), (3 / 22 : ℚ), (3 / 11 : ℚ)] := by
  funext i
  fin_cases i <;> rfl

public theorem ACell9_2_scaled :
    toVec #v[3, 3, 3, 3, 0, 6, 3, 3, 3, 6] = ((22 : ℤ) : ℚ) • ACell9_2 :=
  toVec_eq_smul10 #v[3, 3, 3, 3, 0, 6, 3, 3, 3, 6] 22 ACell9_2
    (eq_smul_div (3) 22 (3) (22) (by decide) (by decide))
    (eq_smul_div (3) 22 (3) (22) (by decide) (by decide))
    (eq_smul_div (3) 22 (3) (22) (by decide) (by decide))
    (eq_smul_div (3) 22 (3) (22) (by decide) (by decide))
    (eq_smul_zero 22)
    (eq_smul_div (6) 22 (3) (11) (by decide) (by decide))
    (eq_smul_div (3) 22 (3) (22) (by decide) (by decide))
    (eq_smul_div (3) 22 (3) (22) (by decide) (by decide))
    (eq_smul_div (3) 22 (3) (22) (by decide) (by decide))
    (eq_smul_div (6) 22 (3) (11) (by decide) (by decide))

public def ACell9_3 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (3 / 22 : ℚ)
  | 1 => (3 / 22 : ℚ)
  | 2 => 0
  | 3 => (3 / 22 : ℚ)
  | 4 => (3 / 22 : ℚ)
  | 5 => (3 / 11 : ℚ)
  | 6 => (3 / 22 : ℚ)
  | 7 => (3 / 11 : ℚ)
  | 8 => (3 / 22 : ℚ)
  | 9 => (3 / 22 : ℚ)
  | _ => 0

public theorem ACell9_3_def : ACell9_3 = ![(3 / 22 : ℚ), (3 / 22 : ℚ), 0, (3 / 22 : ℚ), (3 / 22 : ℚ), (3 / 11 : ℚ), (3 / 22 : ℚ), (3 / 11 : ℚ), (3 / 22 : ℚ), (3 / 22 : ℚ)] := by
  funext i
  fin_cases i <;> rfl

public theorem ACell9_3_scaled :
    toVec #v[3, 3, 0, 3, 3, 6, 3, 6, 3, 3] = ((22 : ℤ) : ℚ) • ACell9_3 :=
  toVec_eq_smul10 #v[3, 3, 0, 3, 3, 6, 3, 6, 3, 3] 22 ACell9_3
    (eq_smul_div (3) 22 (3) (22) (by decide) (by decide))
    (eq_smul_div (3) 22 (3) (22) (by decide) (by decide))
    (eq_smul_zero 22)
    (eq_smul_div (3) 22 (3) (22) (by decide) (by decide))
    (eq_smul_div (3) 22 (3) (22) (by decide) (by decide))
    (eq_smul_div (6) 22 (3) (11) (by decide) (by decide))
    (eq_smul_div (3) 22 (3) (22) (by decide) (by decide))
    (eq_smul_div (6) 22 (3) (11) (by decide) (by decide))
    (eq_smul_div (3) 22 (3) (22) (by decide) (by decide))
    (eq_smul_div (3) 22 (3) (22) (by decide) (by decide))

public def ACell9_4 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => 0
  | 1 => 0
  | 2 => 0
  | 3 => 0
  | 4 => (3 / 22 : ℚ)
  | 5 => (-3 / 22 : ℚ)
  | 6 => (-3 / 22 : ℚ)
  | 7 => (3 / 22 : ℚ)
  | 8 => 0
  | 9 => 0
  | _ => 0

public theorem ACell9_4_def : ACell9_4 = ![0, 0, 0, 0, (3 / 22 : ℚ), (-3 / 22 : ℚ), (-3 / 22 : ℚ), (3 / 22 : ℚ), 0, 0] := by
  funext i
  fin_cases i <;> rfl

public theorem ACell9_4_scaled :
    toVec #v[0, 0, 0, 0, 3, -3, -3, 3, 0, 0] = ((22 : ℤ) : ℚ) • ACell9_4 :=
  toVec_eq_smul10 #v[0, 0, 0, 0, 3, -3, -3, 3, 0, 0] 22 ACell9_4
    (eq_smul_zero 22)
    (eq_smul_zero 22)
    (eq_smul_zero 22)
    (eq_smul_zero 22)
    (eq_smul_div (3) 22 (3) (22) (by decide) (by decide))
    (eq_smul_div (-3) 22 (-3) (22) (by decide) (by decide))
    (eq_smul_div (-3) 22 (-3) (22) (by decide) (by decide))
    (eq_smul_div (3) 22 (3) (22) (by decide) (by decide))
    (eq_smul_zero 22)
    (eq_smul_zero 22)

public def ACell9_5 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (3 / 11 : ℚ)
  | 1 => (2 / 11 : ℚ)
  | 2 => (3 / 11 : ℚ)
  | 3 => (2 / 11 : ℚ)
  | 4 => (1 / 11 : ℚ)
  | 5 => (1 / 11 : ℚ)
  | 6 => (2 / 11 : ℚ)
  | 7 => (3 / 11 : ℚ)
  | 8 => (2 / 11 : ℚ)
  | 9 => (3 / 11 : ℚ)
  | _ => 0

public theorem ACell9_5_def : ACell9_5 = ![(3 / 11 : ℚ), (2 / 11 : ℚ), (3 / 11 : ℚ), (2 / 11 : ℚ), (1 / 11 : ℚ), (1 / 11 : ℚ), (2 / 11 : ℚ), (3 / 11 : ℚ), (2 / 11 : ℚ), (3 / 11 : ℚ)] := by
  funext i
  fin_cases i <;> rfl

public theorem ACell9_5_scaled :
    toVec #v[3, 2, 3, 2, 1, 1, 2, 3, 2, 3] = ((11 : ℤ) : ℚ) • ACell9_5 :=
  toVec_eq_smul10 #v[3, 2, 3, 2, 1, 1, 2, 3, 2, 3] 11 ACell9_5
    (eq_smul_div (3) 11 (3) (11) (by decide) (by decide))
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_div (3) 11 (3) (11) (by decide) (by decide))
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_div (3) 11 (3) (11) (by decide) (by decide))
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_div (3) 11 (3) (11) (by decide) (by decide))

public def ACell9_6 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (2 / 11 : ℚ)
  | 1 => (1 / 11 : ℚ)
  | 2 => 0
  | 3 => (1 / 11 : ℚ)
  | 4 => (1 / 11 : ℚ)
  | 5 => 0
  | 6 => (1 / 11 : ℚ)
  | 7 => (2 / 11 : ℚ)
  | 8 => 0
  | 9 => (3 / 11 : ℚ)
  | _ => 0

public theorem ACell9_6_def : ACell9_6 = ![(2 / 11 : ℚ), (1 / 11 : ℚ), 0, (1 / 11 : ℚ), (1 / 11 : ℚ), 0, (1 / 11 : ℚ), (2 / 11 : ℚ), 0, (3 / 11 : ℚ)] := by
  funext i
  fin_cases i <;> rfl

public theorem ACell9_6_scaled :
    toVec #v[2, 1, 0, 1, 1, 0, 1, 2, 0, 3] = ((11 : ℤ) : ℚ) • ACell9_6 :=
  toVec_eq_smul10 #v[2, 1, 0, 1, 1, 0, 1, 2, 0, 3] 11 ACell9_6
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_div (3) 11 (3) (11) (by decide) (by decide))

public def ACell9_7 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => 0
  | 1 => (2 / 11 : ℚ)
  | 2 => (1 / 11 : ℚ)
  | 3 => (1 / 11 : ℚ)
  | 4 => (2 / 11 : ℚ)
  | 5 => 0
  | 6 => 0
  | 7 => (1 / 11 : ℚ)
  | 8 => (3 / 11 : ℚ)
  | 9 => (1 / 11 : ℚ)
  | _ => 0

public theorem ACell9_7_def : ACell9_7 = ![0, (2 / 11 : ℚ), (1 / 11 : ℚ), (1 / 11 : ℚ), (2 / 11 : ℚ), 0, 0, (1 / 11 : ℚ), (3 / 11 : ℚ), (1 / 11 : ℚ)] := by
  funext i
  fin_cases i <;> rfl

public theorem ACell9_7_scaled :
    toVec #v[0, 2, 1, 1, 2, 0, 0, 1, 3, 1] = ((11 : ℤ) : ℚ) • ACell9_7 :=
  toVec_eq_smul10 #v[0, 2, 1, 1, 2, 0, 0, 1, 3, 1] 11 ACell9_7
    (eq_smul_zero 11)
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_zero 11)
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))
    (eq_smul_div (3) 11 (3) (11) (by decide) (by decide))
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))

public def ACell9_8 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (-2 / 11 : ℚ)
  | 1 => (-3 / 11 : ℚ)
  | 2 => (-2 / 11 : ℚ)
  | 3 => 0
  | 4 => (-1 / 11 : ℚ)
  | 5 => (-1 / 11 : ℚ)
  | 6 => 0
  | 7 => 0
  | 8 => (-1 / 11 : ℚ)
  | 9 => (-1 / 11 : ℚ)
  | _ => 0

public theorem ACell9_8_def : ACell9_8 = ![(-2 / 11 : ℚ), (-3 / 11 : ℚ), (-2 / 11 : ℚ), 0, (-1 / 11 : ℚ), (-1 / 11 : ℚ), 0, 0, (-1 / 11 : ℚ), (-1 / 11 : ℚ)] := by
  funext i
  fin_cases i <;> rfl

public theorem ACell9_8_scaled :
    toVec #v[-2, -3, -2, 0, -1, -1, 0, 0, -1, -1] = ((11 : ℤ) : ℚ) • ACell9_8 :=
  toVec_eq_smul10 #v[-2, -3, -2, 0, -1, -1, 0, 0, -1, -1] 11 ACell9_8
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))
    (eq_smul_div (-3) 11 (-3) (11) (by decide) (by decide))
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_zero 11)
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))

public def ACell9_9 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => -1
  | 1 => (2 / 11 : ℚ)
  | 2 => (1 / 11 : ℚ)
  | 3 => (1 / 11 : ℚ)
  | 4 => (3 / 11 : ℚ)
  | 5 => (1 / 11 : ℚ)
  | 6 => (1 / 11 : ℚ)
  | 7 => (2 / 11 : ℚ)
  | 8 => 0
  | 9 => 0
  | _ => 0

public theorem ACell9_9_def : ACell9_9 = ![-1, (2 / 11 : ℚ), (1 / 11 : ℚ), (1 / 11 : ℚ), (3 / 11 : ℚ), (1 / 11 : ℚ), (1 / 11 : ℚ), (2 / 11 : ℚ), 0, 0] := by
  funext i
  fin_cases i <;> rfl

public theorem ACell9_9_scaled :
    toVec #v[-11, 2, 1, 1, 3, 1, 1, 2, 0, 0] = ((11 : ℤ) : ℚ) • ACell9_9 :=
  toVec_eq_smul10 #v[-11, 2, 1, 1, 3, 1, 1, 2, 0, 0] 11 ACell9_9
    (eq_smul_int (-11) 11 (-1) (by decide))
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))
    (eq_smul_div (3) 11 (3) (11) (by decide) (by decide))
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_zero 11)

public def ARow9 (j : Fin 10) : Vec :=
  match j.val with
  | 0 => ACell9_0
  | 1 => ACell9_1
  | 2 => ACell9_2
  | 3 => ACell9_3
  | 4 => ACell9_4
  | 5 => ACell9_5
  | 6 => ACell9_6
  | 7 => ACell9_7
  | 8 => ACell9_8
  | 9 => ACell9_9
  | _ => 0

public def ACell10_0 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (14 / 11 : ℚ)
  | 1 => 0
  | 2 => (2 / 11 : ℚ)
  | 3 => (1 / 11 : ℚ)
  | 4 => 0
  | 5 => (1 / 11 : ℚ)
  | 6 => (1 / 11 : ℚ)
  | 7 => 0
  | 8 => (1 / 11 : ℚ)
  | 9 => (2 / 11 : ℚ)
  | _ => 0

public theorem ACell10_0_def : ACell10_0 = ![(14 / 11 : ℚ), 0, (2 / 11 : ℚ), (1 / 11 : ℚ), 0, (1 / 11 : ℚ), (1 / 11 : ℚ), 0, (1 / 11 : ℚ), (2 / 11 : ℚ)] := by
  funext i
  fin_cases i <;> rfl

public theorem ACell10_0_scaled :
    toVec #v[14, 0, 2, 1, 0, 1, 1, 0, 1, 2] = ((11 : ℤ) : ℚ) • ACell10_0 :=
  toVec_eq_smul10 #v[14, 0, 2, 1, 0, 1, 1, 0, 1, 2] 11 ACell10_0
    (eq_smul_div (14) 11 (14) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))

public def ACell10_1 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => 0
  | 1 => (1 / 11 : ℚ)
  | 2 => (-1 / 11 : ℚ)
  | 3 => (-1 / 11 : ℚ)
  | 4 => 0
  | 5 => (2 / 11 : ℚ)
  | 6 => 0
  | 7 => (-1 / 11 : ℚ)
  | 8 => (-1 / 11 : ℚ)
  | 9 => (1 / 11 : ℚ)
  | _ => 0

public theorem ACell10_1_def : ACell10_1 = ![0, (1 / 11 : ℚ), (-1 / 11 : ℚ), (-1 / 11 : ℚ), 0, (2 / 11 : ℚ), 0, (-1 / 11 : ℚ), (-1 / 11 : ℚ), (1 / 11 : ℚ)] := by
  funext i
  fin_cases i <;> rfl

public theorem ACell10_1_scaled :
    toVec #v[0, 1, -1, -1, 0, 2, 0, -1, -1, 1] = ((11 : ℤ) : ℚ) • ACell10_1 :=
  toVec_eq_smul10 #v[0, 1, -1, -1, 0, 2, 0, -1, -1, 1] 11 ACell10_1
    (eq_smul_zero 11)
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))

public def ACell10_2 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (1 / 11 : ℚ)
  | 1 => (1 / 11 : ℚ)
  | 2 => 0
  | 3 => (-1 / 11 : ℚ)
  | 4 => 0
  | 5 => (-1 / 11 : ℚ)
  | 6 => (2 / 11 : ℚ)
  | 7 => (-1 / 11 : ℚ)
  | 8 => 0
  | 9 => (-1 / 11 : ℚ)
  | _ => 0

public theorem ACell10_2_def : ACell10_2 = ![(1 / 11 : ℚ), (1 / 11 : ℚ), 0, (-1 / 11 : ℚ), 0, (-1 / 11 : ℚ), (2 / 11 : ℚ), (-1 / 11 : ℚ), 0, (-1 / 11 : ℚ)] := by
  funext i
  fin_cases i <;> rfl

public theorem ACell10_2_scaled :
    toVec #v[1, 1, 0, -1, 0, -1, 2, -1, 0, -1] = ((11 : ℤ) : ℚ) • ACell10_2 :=
  toVec_eq_smul10 #v[1, 1, 0, -1, 0, -1, 2, -1, 0, -1] 11 ACell10_2
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))

public def ACell10_3 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (2 / 11 : ℚ)
  | 1 => (1 / 11 : ℚ)
  | 2 => (1 / 11 : ℚ)
  | 3 => (3 / 11 : ℚ)
  | 4 => (1 / 11 : ℚ)
  | 5 => (1 / 11 : ℚ)
  | 6 => (2 / 11 : ℚ)
  | 7 => 0
  | 8 => 0
  | 9 => 0
  | _ => 0

public theorem ACell10_3_def : ACell10_3 = ![(2 / 11 : ℚ), (1 / 11 : ℚ), (1 / 11 : ℚ), (3 / 11 : ℚ), (1 / 11 : ℚ), (1 / 11 : ℚ), (2 / 11 : ℚ), 0, 0, 0] := by
  funext i
  fin_cases i <;> rfl

public theorem ACell10_3_scaled :
    toVec #v[2, 1, 1, 3, 1, 1, 2, 0, 0, 0] = ((11 : ℤ) : ℚ) • ACell10_3 :=
  toVec_eq_smul10 #v[2, 1, 1, 3, 1, 1, 2, 0, 0, 0] 11 ACell10_3
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))
    (eq_smul_div (3) 11 (3) (11) (by decide) (by decide))
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_zero 11)
    (eq_smul_zero 11)

public def ACell10_4 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => 0
  | 1 => (-1 / 11 : ℚ)
  | 2 => (-1 / 11 : ℚ)
  | 3 => 0
  | 4 => 0
  | 5 => (-1 / 11 : ℚ)
  | 6 => (1 / 11 : ℚ)
  | 7 => (2 / 11 : ℚ)
  | 8 => (1 / 11 : ℚ)
  | 9 => (-1 / 11 : ℚ)
  | _ => 0

public theorem ACell10_4_def : ACell10_4 = ![0, (-1 / 11 : ℚ), (-1 / 11 : ℚ), 0, 0, (-1 / 11 : ℚ), (1 / 11 : ℚ), (2 / 11 : ℚ), (1 / 11 : ℚ), (-1 / 11 : ℚ)] := by
  funext i
  fin_cases i <;> rfl

public theorem ACell10_4_scaled :
    toVec #v[0, -1, -1, 0, 0, -1, 1, 2, 1, -1] = ((11 : ℤ) : ℚ) • ACell10_4 :=
  toVec_eq_smul10 #v[0, -1, -1, 0, 0, -1, 1, 2, 1, -1] 11 ACell10_4
    (eq_smul_zero 11)
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_zero 11)
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))

public def ACell10_5 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (2 / 11 : ℚ)
  | 1 => 0
  | 2 => 0
  | 3 => (-2 / 11 : ℚ)
  | 4 => 0
  | 5 => (-2 / 11 : ℚ)
  | 6 => 0
  | 7 => 0
  | 8 => (2 / 11 : ℚ)
  | 9 => 0
  | _ => 0

public theorem ACell10_5_def : ACell10_5 = ![(2 / 11 : ℚ), 0, 0, (-2 / 11 : ℚ), 0, (-2 / 11 : ℚ), 0, 0, (2 / 11 : ℚ), 0] := by
  funext i
  fin_cases i <;> rfl

public theorem ACell10_5_scaled :
    toVec #v[2, 0, 0, -2, 0, -2, 0, 0, 2, 0] = ((11 : ℤ) : ℚ) • ACell10_5 :=
  toVec_eq_smul10 #v[2, 0, 0, -2, 0, -2, 0, 0, 2, 0] 11 ACell10_5
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_zero 11)
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_zero 11)
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_zero 11)

public def ACell10_6 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => 0
  | 1 => 0
  | 2 => 0
  | 3 => 0
  | 4 => 0
  | 5 => (2 / 11 : ℚ)
  | 6 => (-2 / 11 : ℚ)
  | 7 => (-2 / 11 : ℚ)
  | 8 => (2 / 11 : ℚ)
  | 9 => 0
  | _ => 0

public theorem ACell10_6_def : ACell10_6 = ![0, 0, 0, 0, 0, (2 / 11 : ℚ), (-2 / 11 : ℚ), (-2 / 11 : ℚ), (2 / 11 : ℚ), 0] := by
  funext i
  fin_cases i <;> rfl

public theorem ACell10_6_scaled :
    toVec #v[0, 0, 0, 0, 0, 2, -2, -2, 2, 0] = ((11 : ℤ) : ℚ) • ACell10_6 :=
  toVec_eq_smul10 #v[0, 0, 0, 0, 0, 2, -2, -2, 2, 0] 11 ACell10_6
    (eq_smul_zero 11)
    (eq_smul_zero 11)
    (eq_smul_zero 11)
    (eq_smul_zero 11)
    (eq_smul_zero 11)
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_zero 11)

public def ACell10_7 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (2 / 11 : ℚ)
  | 1 => (4 / 11 : ℚ)
  | 2 => (2 / 11 : ℚ)
  | 3 => (2 / 11 : ℚ)
  | 4 => (2 / 11 : ℚ)
  | 5 => (2 / 11 : ℚ)
  | 6 => (4 / 11 : ℚ)
  | 7 => (2 / 11 : ℚ)
  | 8 => 0
  | 9 => (2 / 11 : ℚ)
  | _ => 0

public theorem ACell10_7_def : ACell10_7 = ![(2 / 11 : ℚ), (4 / 11 : ℚ), (2 / 11 : ℚ), (2 / 11 : ℚ), (2 / 11 : ℚ), (2 / 11 : ℚ), (4 / 11 : ℚ), (2 / 11 : ℚ), 0, (2 / 11 : ℚ)] := by
  funext i
  fin_cases i <;> rfl

public theorem ACell10_7_scaled :
    toVec #v[2, 4, 2, 2, 2, 2, 4, 2, 0, 2] = ((11 : ℤ) : ℚ) • ACell10_7 :=
  toVec_eq_smul10 #v[2, 4, 2, 2, 2, 2, 4, 2, 0, 2] 11 ACell10_7
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_div (4) 11 (4) (11) (by decide) (by decide))
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_div (4) 11 (4) (11) (by decide) (by decide))
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))

public def ACell10_8 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => 0
  | 1 => (-2 / 11 : ℚ)
  | 2 => (2 / 11 : ℚ)
  | 3 => 0
  | 4 => 0
  | 5 => 0
  | 6 => 0
  | 7 => (2 / 11 : ℚ)
  | 8 => (-2 / 11 : ℚ)
  | 9 => 0
  | _ => 0

public theorem ACell10_8_def : ACell10_8 = ![0, (-2 / 11 : ℚ), (2 / 11 : ℚ), 0, 0, 0, 0, (2 / 11 : ℚ), (-2 / 11 : ℚ), 0] := by
  funext i
  fin_cases i <;> rfl

public theorem ACell10_8_scaled :
    toVec #v[0, -2, 2, 0, 0, 0, 0, 2, -2, 0] = ((11 : ℤ) : ℚ) • ACell10_8 :=
  toVec_eq_smul10 #v[0, -2, 2, 0, 0, 0, 0, 2, -2, 0] 11 ACell10_8
    (eq_smul_zero 11)
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_zero 11)
    (eq_smul_zero 11)
    (eq_smul_zero 11)
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))
    (eq_smul_zero 11)

public def ACell10_9 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (2 / 11 : ℚ)
  | 1 => (2 / 11 : ℚ)
  | 2 => (4 / 11 : ℚ)
  | 3 => (4 / 11 : ℚ)
  | 4 => (2 / 11 : ℚ)
  | 5 => (2 / 11 : ℚ)
  | 6 => 0
  | 7 => (2 / 11 : ℚ)
  | 8 => (2 / 11 : ℚ)
  | 9 => (2 / 11 : ℚ)
  | _ => 0

public theorem ACell10_9_def : ACell10_9 = ![(2 / 11 : ℚ), (2 / 11 : ℚ), (4 / 11 : ℚ), (4 / 11 : ℚ), (2 / 11 : ℚ), (2 / 11 : ℚ), 0, (2 / 11 : ℚ), (2 / 11 : ℚ), (2 / 11 : ℚ)] := by
  funext i
  fin_cases i <;> rfl

public theorem ACell10_9_scaled :
    toVec #v[2, 2, 4, 4, 2, 2, 0, 2, 2, 2] = ((11 : ℤ) : ℚ) • ACell10_9 :=
  toVec_eq_smul10 #v[2, 2, 4, 4, 2, 2, 0, 2, 2, 2] 11 ACell10_9
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_div (4) 11 (4) (11) (by decide) (by decide))
    (eq_smul_div (4) 11 (4) (11) (by decide) (by decide))
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))

public def ARow10 (j : Fin 10) : Vec :=
  match j.val with
  | 0 => ACell10_0
  | 1 => ACell10_1
  | 2 => ACell10_2
  | 3 => ACell10_3
  | 4 => ACell10_4
  | 5 => ACell10_5
  | 6 => ACell10_6
  | 7 => ACell10_7
  | 8 => ACell10_8
  | 9 => ACell10_9
  | _ => 0

public def ACell11_0 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (-1 / 11 : ℚ)
  | 1 => (-1 / 11 : ℚ)
  | 2 => 0
  | 3 => (-2 / 11 : ℚ)
  | 4 => (-2 / 11 : ℚ)
  | 5 => (-1 / 11 : ℚ)
  | 6 => (1 / 11 : ℚ)
  | 7 => (-1 / 11 : ℚ)
  | 8 => (-2 / 11 : ℚ)
  | 9 => (-2 / 11 : ℚ)
  | _ => 0

public theorem ACell11_0_def : ACell11_0 = ![(-1 / 11 : ℚ), (-1 / 11 : ℚ), 0, (-2 / 11 : ℚ), (-2 / 11 : ℚ), (-1 / 11 : ℚ), (1 / 11 : ℚ), (-1 / 11 : ℚ), (-2 / 11 : ℚ), (-2 / 11 : ℚ)] := by
  funext i
  fin_cases i <;> rfl

public theorem ACell11_0_scaled :
    toVec #v[-1, -1, 0, -2, -2, -1, 1, -1, -2, -2] = ((11 : ℤ) : ℚ) • ACell11_0 :=
  toVec_eq_smul10 #v[-1, -1, 0, -2, -2, -1, 1, -1, -2, -2] 11 ACell11_0
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))

public def ACell11_1 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (13 / 11 : ℚ)
  | 1 => 0
  | 2 => 0
  | 3 => (1 / 11 : ℚ)
  | 4 => (-1 / 11 : ℚ)
  | 5 => (-1 / 11 : ℚ)
  | 6 => (-1 / 11 : ℚ)
  | 7 => (-1 / 11 : ℚ)
  | 8 => (1 / 11 : ℚ)
  | 9 => 0
  | _ => 0

public theorem ACell11_1_def : ACell11_1 = ![(13 / 11 : ℚ), 0, 0, (1 / 11 : ℚ), (-1 / 11 : ℚ), (-1 / 11 : ℚ), (-1 / 11 : ℚ), (-1 / 11 : ℚ), (1 / 11 : ℚ), 0] := by
  funext i
  fin_cases i <;> rfl

public theorem ACell11_1_scaled :
    toVec #v[13, 0, 0, 1, -1, -1, -1, -1, 1, 0] = ((11 : ℤ) : ℚ) • ACell11_1 :=
  toVec_eq_smul10 #v[13, 0, 0, 1, -1, -1, -1, -1, 1, 0] 11 ACell11_1
    (eq_smul_div (13) 11 (13) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_zero 11)
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))
    (eq_smul_zero 11)

public def ACell11_2 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (2 / 11 : ℚ)
  | 1 => (3 / 11 : ℚ)
  | 2 => (2 / 11 : ℚ)
  | 3 => 0
  | 4 => (1 / 11 : ℚ)
  | 5 => (1 / 11 : ℚ)
  | 6 => 0
  | 7 => 0
  | 8 => (1 / 11 : ℚ)
  | 9 => (1 / 11 : ℚ)
  | _ => 0

public theorem ACell11_2_def : ACell11_2 = ![(2 / 11 : ℚ), (3 / 11 : ℚ), (2 / 11 : ℚ), 0, (1 / 11 : ℚ), (1 / 11 : ℚ), 0, 0, (1 / 11 : ℚ), (1 / 11 : ℚ)] := by
  funext i
  fin_cases i <;> rfl

public theorem ACell11_2_scaled :
    toVec #v[2, 3, 2, 0, 1, 1, 0, 0, 1, 1] = ((11 : ℤ) : ℚ) • ACell11_2 :=
  toVec_eq_smul10 #v[2, 3, 2, 0, 1, 1, 0, 0, 1, 1] 11 ACell11_2
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_div (3) 11 (3) (11) (by decide) (by decide))
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_zero 11)
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))

public def ACell11_3 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (1 / 11 : ℚ)
  | 1 => 0
  | 2 => (1 / 11 : ℚ)
  | 3 => (2 / 11 : ℚ)
  | 4 => (2 / 11 : ℚ)
  | 5 => (1 / 11 : ℚ)
  | 6 => 0
  | 7 => (1 / 11 : ℚ)
  | 8 => 0
  | 9 => (3 / 11 : ℚ)
  | _ => 0

public theorem ACell11_3_def : ACell11_3 = ![(1 / 11 : ℚ), 0, (1 / 11 : ℚ), (2 / 11 : ℚ), (2 / 11 : ℚ), (1 / 11 : ℚ), 0, (1 / 11 : ℚ), 0, (3 / 11 : ℚ)] := by
  funext i
  fin_cases i <;> rfl

public theorem ACell11_3_scaled :
    toVec #v[1, 0, 1, 2, 2, 1, 0, 1, 0, 3] = ((11 : ℤ) : ℚ) • ACell11_3 :=
  toVec_eq_smul10 #v[1, 0, 1, 2, 2, 1, 0, 1, 0, 3] 11 ACell11_3
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_div (3) 11 (3) (11) (by decide) (by decide))

public def ACell11_4 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (1 / 11 : ℚ)
  | 1 => (-1 / 11 : ℚ)
  | 2 => (2 / 11 : ℚ)
  | 3 => (-1 / 11 : ℚ)
  | 4 => (1 / 11 : ℚ)
  | 5 => 0
  | 6 => (-1 / 11 : ℚ)
  | 7 => 0
  | 8 => 0
  | 9 => (-1 / 11 : ℚ)
  | _ => 0

public theorem ACell11_4_def : ACell11_4 = ![(1 / 11 : ℚ), (-1 / 11 : ℚ), (2 / 11 : ℚ), (-1 / 11 : ℚ), (1 / 11 : ℚ), 0, (-1 / 11 : ℚ), 0, 0, (-1 / 11 : ℚ)] := by
  funext i
  fin_cases i <;> rfl

public theorem ACell11_4_scaled :
    toVec #v[1, -1, 2, -1, 1, 0, -1, 0, 0, -1] = ((11 : ℤ) : ℚ) • ACell11_4 :=
  toVec_eq_smul10 #v[1, -1, 2, -1, 1, 0, -1, 0, 0, -1] 11 ACell11_4
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_zero 11)
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))

public def ACell11_5 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => 0
  | 1 => (-2 / 11 : ℚ)
  | 2 => (2 / 11 : ℚ)
  | 3 => 0
  | 4 => 0
  | 5 => 0
  | 6 => 0
  | 7 => (2 / 11 : ℚ)
  | 8 => (-2 / 11 : ℚ)
  | 9 => 0
  | _ => 0

public theorem ACell11_5_def : ACell11_5 = ![0, (-2 / 11 : ℚ), (2 / 11 : ℚ), 0, 0, 0, 0, (2 / 11 : ℚ), (-2 / 11 : ℚ), 0] := by
  funext i
  fin_cases i <;> rfl

public theorem ACell11_5_scaled :
    toVec #v[0, -2, 2, 0, 0, 0, 0, 2, -2, 0] = ((11 : ℤ) : ℚ) • ACell11_5 :=
  toVec_eq_smul10 #v[0, -2, 2, 0, 0, 0, 0, 2, -2, 0] 11 ACell11_5
    (eq_smul_zero 11)
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_zero 11)
    (eq_smul_zero 11)
    (eq_smul_zero 11)
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))
    (eq_smul_zero 11)

public def ACell11_6 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (-2 / 11 : ℚ)
  | 1 => (-2 / 11 : ℚ)
  | 2 => (-2 / 11 : ℚ)
  | 3 => (-2 / 11 : ℚ)
  | 4 => 0
  | 5 => (-2 / 11 : ℚ)
  | 6 => (-4 / 11 : ℚ)
  | 7 => (-2 / 11 : ℚ)
  | 8 => (-4 / 11 : ℚ)
  | 9 => (-2 / 11 : ℚ)
  | _ => 0

public theorem ACell11_6_def : ACell11_6 = ![(-2 / 11 : ℚ), (-2 / 11 : ℚ), (-2 / 11 : ℚ), (-2 / 11 : ℚ), 0, (-2 / 11 : ℚ), (-4 / 11 : ℚ), (-2 / 11 : ℚ), (-4 / 11 : ℚ), (-2 / 11 : ℚ)] := by
  funext i
  fin_cases i <;> rfl

public theorem ACell11_6_scaled :
    toVec #v[-2, -2, -2, -2, 0, -2, -4, -2, -4, -2] = ((11 : ℤ) : ℚ) • ACell11_6 :=
  toVec_eq_smul10 #v[-2, -2, -2, -2, 0, -2, -4, -2, -4, -2] 11 ACell11_6
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))
    (eq_smul_div (-4) 11 (-4) (11) (by decide) (by decide))
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))
    (eq_smul_div (-4) 11 (-4) (11) (by decide) (by decide))
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))

public def ACell11_7 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (-2 / 11 : ℚ)
  | 1 => (-2 / 11 : ℚ)
  | 2 => (-4 / 11 : ℚ)
  | 3 => (-2 / 11 : ℚ)
  | 4 => (-2 / 11 : ℚ)
  | 5 => (-2 / 11 : ℚ)
  | 6 => (-4 / 11 : ℚ)
  | 7 => (-2 / 11 : ℚ)
  | 8 => (-2 / 11 : ℚ)
  | 9 => 0
  | _ => 0

public theorem ACell11_7_def : ACell11_7 = ![(-2 / 11 : ℚ), (-2 / 11 : ℚ), (-4 / 11 : ℚ), (-2 / 11 : ℚ), (-2 / 11 : ℚ), (-2 / 11 : ℚ), (-4 / 11 : ℚ), (-2 / 11 : ℚ), (-2 / 11 : ℚ), 0] := by
  funext i
  fin_cases i <;> rfl

public theorem ACell11_7_scaled :
    toVec #v[-2, -2, -4, -2, -2, -2, -4, -2, -2, 0] = ((11 : ℤ) : ℚ) • ACell11_7 :=
  toVec_eq_smul10 #v[-2, -2, -4, -2, -2, -2, -4, -2, -2, 0] 11 ACell11_7
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))
    (eq_smul_div (-4) 11 (-4) (11) (by decide) (by decide))
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))
    (eq_smul_div (-4) 11 (-4) (11) (by decide) (by decide))
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))
    (eq_smul_zero 11)

public def ACell11_8 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => 0
  | 1 => (-4 / 11 : ℚ)
  | 2 => (-2 / 11 : ℚ)
  | 3 => (-2 / 11 : ℚ)
  | 4 => (-2 / 11 : ℚ)
  | 5 => (-2 / 11 : ℚ)
  | 6 => (-2 / 11 : ℚ)
  | 7 => (-2 / 11 : ℚ)
  | 8 => (-2 / 11 : ℚ)
  | 9 => (-4 / 11 : ℚ)
  | _ => 0

public theorem ACell11_8_def : ACell11_8 = ![0, (-4 / 11 : ℚ), (-2 / 11 : ℚ), (-2 / 11 : ℚ), (-2 / 11 : ℚ), (-2 / 11 : ℚ), (-2 / 11 : ℚ), (-2 / 11 : ℚ), (-2 / 11 : ℚ), (-4 / 11 : ℚ)] := by
  funext i
  fin_cases i <;> rfl

public theorem ACell11_8_scaled :
    toVec #v[0, -4, -2, -2, -2, -2, -2, -2, -2, -4] = ((11 : ℤ) : ℚ) • ACell11_8 :=
  toVec_eq_smul10 #v[0, -4, -2, -2, -2, -2, -2, -2, -2, -4] 11 ACell11_8
    (eq_smul_zero 11)
    (eq_smul_div (-4) 11 (-4) (11) (by decide) (by decide))
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))
    (eq_smul_div (-4) 11 (-4) (11) (by decide) (by decide))

public def ACell11_9 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (2 / 11 : ℚ)
  | 1 => (2 / 11 : ℚ)
  | 2 => (4 / 11 : ℚ)
  | 3 => (2 / 11 : ℚ)
  | 4 => (4 / 11 : ℚ)
  | 5 => (2 / 11 : ℚ)
  | 6 => (2 / 11 : ℚ)
  | 7 => 0
  | 8 => (2 / 11 : ℚ)
  | 9 => (2 / 11 : ℚ)
  | _ => 0

public theorem ACell11_9_def : ACell11_9 = ![(2 / 11 : ℚ), (2 / 11 : ℚ), (4 / 11 : ℚ), (2 / 11 : ℚ), (4 / 11 : ℚ), (2 / 11 : ℚ), (2 / 11 : ℚ), 0, (2 / 11 : ℚ), (2 / 11 : ℚ)] := by
  funext i
  fin_cases i <;> rfl

public theorem ACell11_9_scaled :
    toVec #v[2, 2, 4, 2, 4, 2, 2, 0, 2, 2] = ((11 : ℤ) : ℚ) • ACell11_9 :=
  toVec_eq_smul10 #v[2, 2, 4, 2, 4, 2, 2, 0, 2, 2] 11 ACell11_9
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_div (4) 11 (4) (11) (by decide) (by decide))
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_div (4) 11 (4) (11) (by decide) (by decide))
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))

public def ARow11 (j : Fin 10) : Vec :=
  match j.val with
  | 0 => ACell11_0
  | 1 => ACell11_1
  | 2 => ACell11_2
  | 3 => ACell11_3
  | 4 => ACell11_4
  | 5 => ACell11_5
  | 6 => ACell11_6
  | 7 => ACell11_7
  | 8 => ACell11_8
  | 9 => ACell11_9
  | _ => 0

public def ACell12_0 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => 0
  | 1 => (-1 / 11 : ℚ)
  | 2 => (-2 / 11 : ℚ)
  | 3 => (-1 / 11 : ℚ)
  | 4 => (-2 / 11 : ℚ)
  | 5 => (1 / 11 : ℚ)
  | 6 => (-2 / 11 : ℚ)
  | 7 => (-1 / 11 : ℚ)
  | 8 => (-2 / 11 : ℚ)
  | 9 => (-1 / 11 : ℚ)
  | _ => 0

public theorem ACell12_0_def : ACell12_0 = ![0, (-1 / 11 : ℚ), (-2 / 11 : ℚ), (-1 / 11 : ℚ), (-2 / 11 : ℚ), (1 / 11 : ℚ), (-2 / 11 : ℚ), (-1 / 11 : ℚ), (-2 / 11 : ℚ), (-1 / 11 : ℚ)] := by
  funext i
  fin_cases i <;> rfl

public theorem ACell12_0_scaled :
    toVec #v[0, -1, -2, -1, -2, 1, -2, -1, -2, -1] = ((11 : ℤ) : ℚ) • ACell12_0 :=
  toVec_eq_smul10 #v[0, -1, -2, -1, -2, 1, -2, -1, -2, -1] 11 ACell12_0
    (eq_smul_zero 11)
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))

public def ACell12_1 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (-1 / 11 : ℚ)
  | 1 => (-3 / 11 : ℚ)
  | 2 => (-2 / 11 : ℚ)
  | 3 => (-2 / 11 : ℚ)
  | 4 => (-3 / 11 : ℚ)
  | 5 => (-3 / 11 : ℚ)
  | 6 => (-2 / 11 : ℚ)
  | 7 => (-2 / 11 : ℚ)
  | 8 => (-3 / 11 : ℚ)
  | 9 => (-1 / 11 : ℚ)
  | _ => 0

public theorem ACell12_1_def : ACell12_1 = ![(-1 / 11 : ℚ), (-3 / 11 : ℚ), (-2 / 11 : ℚ), (-2 / 11 : ℚ), (-3 / 11 : ℚ), (-3 / 11 : ℚ), (-2 / 11 : ℚ), (-2 / 11 : ℚ), (-3 / 11 : ℚ), (-1 / 11 : ℚ)] := by
  funext i
  fin_cases i <;> rfl

public theorem ACell12_1_scaled :
    toVec #v[-1, -3, -2, -2, -3, -3, -2, -2, -3, -1] = ((11 : ℤ) : ℚ) • ACell12_1 :=
  toVec_eq_smul10 #v[-1, -3, -2, -2, -3, -3, -2, -2, -3, -1] 11 ACell12_1
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_div (-3) 11 (-3) (11) (by decide) (by decide))
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))
    (eq_smul_div (-3) 11 (-3) (11) (by decide) (by decide))
    (eq_smul_div (-3) 11 (-3) (11) (by decide) (by decide))
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))
    (eq_smul_div (-3) 11 (-3) (11) (by decide) (by decide))
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))

public def ACell12_2 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (13 / 11 : ℚ)
  | 1 => 0
  | 2 => (-1 / 11 : ℚ)
  | 3 => (-1 / 11 : ℚ)
  | 4 => (1 / 11 : ℚ)
  | 5 => 0
  | 6 => 0
  | 7 => (1 / 11 : ℚ)
  | 8 => (-1 / 11 : ℚ)
  | 9 => (-1 / 11 : ℚ)
  | _ => 0

public theorem ACell12_2_def : ACell12_2 = ![(13 / 11 : ℚ), 0, (-1 / 11 : ℚ), (-1 / 11 : ℚ), (1 / 11 : ℚ), 0, 0, (1 / 11 : ℚ), (-1 / 11 : ℚ), (-1 / 11 : ℚ)] := by
  funext i
  fin_cases i <;> rfl

public theorem ACell12_2_scaled :
    toVec #v[13, 0, -1, -1, 1, 0, 0, 1, -1, -1] = ((11 : ℤ) : ℚ) • ACell12_2 :=
  toVec_eq_smul10 #v[13, 0, -1, -1, 1, 0, 0, 1, -1, -1] 11 ACell12_2
    (eq_smul_div (13) 11 (13) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_zero 11)
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))

public def ACell12_3 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (-1 / 11 : ℚ)
  | 1 => (-2 / 11 : ℚ)
  | 2 => (-1 / 11 : ℚ)
  | 3 => (-1 / 11 : ℚ)
  | 4 => (-2 / 11 : ℚ)
  | 5 => (-1 / 11 : ℚ)
  | 6 => 0
  | 7 => (-2 / 11 : ℚ)
  | 8 => (1 / 11 : ℚ)
  | 9 => (-2 / 11 : ℚ)
  | _ => 0

public theorem ACell12_3_def : ACell12_3 = ![(-1 / 11 : ℚ), (-2 / 11 : ℚ), (-1 / 11 : ℚ), (-1 / 11 : ℚ), (-2 / 11 : ℚ), (-1 / 11 : ℚ), 0, (-2 / 11 : ℚ), (1 / 11 : ℚ), (-2 / 11 : ℚ)] := by
  funext i
  fin_cases i <;> rfl

public theorem ACell12_3_scaled :
    toVec #v[-1, -2, -1, -1, -2, -1, 0, -2, 1, -2] = ((11 : ℤ) : ℚ) • ACell12_3 :=
  toVec_eq_smul10 #v[-1, -2, -1, -1, -2, -1, 0, -2, 1, -2] 11 ACell12_3
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))

public def ACell12_4 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => 0
  | 1 => (2 / 11 : ℚ)
  | 2 => 0
  | 3 => 0
  | 4 => (1 / 11 : ℚ)
  | 5 => (-1 / 11 : ℚ)
  | 6 => (-1 / 11 : ℚ)
  | 7 => (-1 / 11 : ℚ)
  | 8 => (-1 / 11 : ℚ)
  | 9 => (1 / 11 : ℚ)
  | _ => 0

public theorem ACell12_4_def : ACell12_4 = ![0, (2 / 11 : ℚ), 0, 0, (1 / 11 : ℚ), (-1 / 11 : ℚ), (-1 / 11 : ℚ), (-1 / 11 : ℚ), (-1 / 11 : ℚ), (1 / 11 : ℚ)] := by
  funext i
  fin_cases i <;> rfl

public theorem ACell12_4_scaled :
    toVec #v[0, 2, 0, 0, 1, -1, -1, -1, -1, 1] = ((11 : ℤ) : ℚ) • ACell12_4 :=
  toVec_eq_smul10 #v[0, 2, 0, 0, 1, -1, -1, -1, -1, 1] 11 ACell12_4
    (eq_smul_zero 11)
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_zero 11)
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))

public def ACell12_5 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (-2 / 11 : ℚ)
  | 1 => (-4 / 11 : ℚ)
  | 2 => (-2 / 11 : ℚ)
  | 3 => (-2 / 11 : ℚ)
  | 4 => (-2 / 11 : ℚ)
  | 5 => (-2 / 11 : ℚ)
  | 6 => (-4 / 11 : ℚ)
  | 7 => (-2 / 11 : ℚ)
  | 8 => 0
  | 9 => (-2 / 11 : ℚ)
  | _ => 0

public theorem ACell12_5_def : ACell12_5 = ![(-2 / 11 : ℚ), (-4 / 11 : ℚ), (-2 / 11 : ℚ), (-2 / 11 : ℚ), (-2 / 11 : ℚ), (-2 / 11 : ℚ), (-4 / 11 : ℚ), (-2 / 11 : ℚ), 0, (-2 / 11 : ℚ)] := by
  funext i
  fin_cases i <;> rfl

public theorem ACell12_5_scaled :
    toVec #v[-2, -4, -2, -2, -2, -2, -4, -2, 0, -2] = ((11 : ℤ) : ℚ) • ACell12_5 :=
  toVec_eq_smul10 #v[-2, -4, -2, -2, -2, -2, -4, -2, 0, -2] 11 ACell12_5
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))
    (eq_smul_div (-4) 11 (-4) (11) (by decide) (by decide))
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))
    (eq_smul_div (-4) 11 (-4) (11) (by decide) (by decide))
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))

public def ACell12_6 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (2 / 11 : ℚ)
  | 1 => (2 / 11 : ℚ)
  | 2 => 0
  | 3 => (2 / 11 : ℚ)
  | 4 => (2 / 11 : ℚ)
  | 5 => (4 / 11 : ℚ)
  | 6 => (2 / 11 : ℚ)
  | 7 => (4 / 11 : ℚ)
  | 8 => (2 / 11 : ℚ)
  | 9 => (2 / 11 : ℚ)
  | _ => 0

public theorem ACell12_6_def : ACell12_6 = ![(2 / 11 : ℚ), (2 / 11 : ℚ), 0, (2 / 11 : ℚ), (2 / 11 : ℚ), (4 / 11 : ℚ), (2 / 11 : ℚ), (4 / 11 : ℚ), (2 / 11 : ℚ), (2 / 11 : ℚ)] := by
  funext i
  fin_cases i <;> rfl

public theorem ACell12_6_scaled :
    toVec #v[2, 2, 0, 2, 2, 4, 2, 4, 2, 2] = ((11 : ℤ) : ℚ) • ACell12_6 :=
  toVec_eq_smul10 #v[2, 2, 0, 2, 2, 4, 2, 4, 2, 2] 11 ACell12_6
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_div (4) 11 (4) (11) (by decide) (by decide))
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_div (4) 11 (4) (11) (by decide) (by decide))
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))

public def ACell12_7 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (-2 / 11 : ℚ)
  | 1 => (2 / 11 : ℚ)
  | 2 => 0
  | 3 => 0
  | 4 => 0
  | 5 => (2 / 11 : ℚ)
  | 6 => (-2 / 11 : ℚ)
  | 7 => 0
  | 8 => 0
  | 9 => 0
  | _ => 0

public theorem ACell12_7_def : ACell12_7 = ![(-2 / 11 : ℚ), (2 / 11 : ℚ), 0, 0, 0, (2 / 11 : ℚ), (-2 / 11 : ℚ), 0, 0, 0] := by
  funext i
  fin_cases i <;> rfl

public theorem ACell12_7_scaled :
    toVec #v[-2, 2, 0, 0, 0, 2, -2, 0, 0, 0] = ((11 : ℤ) : ℚ) • ACell12_7 :=
  toVec_eq_smul10 #v[-2, 2, 0, 0, 0, 2, -2, 0, 0, 0] 11 ACell12_7
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_zero 11)
    (eq_smul_zero 11)
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_zero 11)
    (eq_smul_zero 11)

public def ACell12_8 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (2 / 11 : ℚ)
  | 1 => (2 / 11 : ℚ)
  | 2 => (4 / 11 : ℚ)
  | 3 => (2 / 11 : ℚ)
  | 4 => (2 / 11 : ℚ)
  | 5 => (2 / 11 : ℚ)
  | 6 => (4 / 11 : ℚ)
  | 7 => (2 / 11 : ℚ)
  | 8 => (2 / 11 : ℚ)
  | 9 => 0
  | _ => 0

public theorem ACell12_8_def : ACell12_8 = ![(2 / 11 : ℚ), (2 / 11 : ℚ), (4 / 11 : ℚ), (2 / 11 : ℚ), (2 / 11 : ℚ), (2 / 11 : ℚ), (4 / 11 : ℚ), (2 / 11 : ℚ), (2 / 11 : ℚ), 0] := by
  funext i
  fin_cases i <;> rfl

public theorem ACell12_8_scaled :
    toVec #v[2, 2, 4, 2, 2, 2, 4, 2, 2, 0] = ((11 : ℤ) : ℚ) • ACell12_8 :=
  toVec_eq_smul10 #v[2, 2, 4, 2, 2, 2, 4, 2, 2, 0] 11 ACell12_8
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_div (4) 11 (4) (11) (by decide) (by decide))
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_div (4) 11 (4) (11) (by decide) (by decide))
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_zero 11)

public def ACell12_9 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => 0
  | 1 => 0
  | 2 => 0
  | 3 => 0
  | 4 => 0
  | 5 => 0
  | 6 => (2 / 11 : ℚ)
  | 7 => (-2 / 11 : ℚ)
  | 8 => (-2 / 11 : ℚ)
  | 9 => (2 / 11 : ℚ)
  | _ => 0

public theorem ACell12_9_def : ACell12_9 = ![0, 0, 0, 0, 0, 0, (2 / 11 : ℚ), (-2 / 11 : ℚ), (-2 / 11 : ℚ), (2 / 11 : ℚ)] := by
  funext i
  fin_cases i <;> rfl

public theorem ACell12_9_scaled :
    toVec #v[0, 0, 0, 0, 0, 0, 2, -2, -2, 2] = ((11 : ℤ) : ℚ) • ACell12_9 :=
  toVec_eq_smul10 #v[0, 0, 0, 0, 0, 0, 2, -2, -2, 2] 11 ACell12_9
    (eq_smul_zero 11)
    (eq_smul_zero 11)
    (eq_smul_zero 11)
    (eq_smul_zero 11)
    (eq_smul_zero 11)
    (eq_smul_zero 11)
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))

public def ARow12 (j : Fin 10) : Vec :=
  match j.val with
  | 0 => ACell12_0
  | 1 => ACell12_1
  | 2 => ACell12_2
  | 3 => ACell12_3
  | 4 => ACell12_4
  | 5 => ACell12_5
  | 6 => ACell12_6
  | 7 => ACell12_7
  | 8 => ACell12_8
  | 9 => ACell12_9
  | _ => 0

public def ACell13_0 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (1 / 11 : ℚ)
  | 1 => (-1 / 11 : ℚ)
  | 2 => (-1 / 11 : ℚ)
  | 3 => (-1 / 11 : ℚ)
  | 4 => (-1 / 11 : ℚ)
  | 5 => (1 / 11 : ℚ)
  | 6 => 0
  | 7 => 0
  | 8 => (2 / 11 : ℚ)
  | 9 => 0
  | _ => 0

public theorem ACell13_0_def : ACell13_0 = ![(1 / 11 : ℚ), (-1 / 11 : ℚ), (-1 / 11 : ℚ), (-1 / 11 : ℚ), (-1 / 11 : ℚ), (1 / 11 : ℚ), 0, 0, (2 / 11 : ℚ), 0] := by
  funext i
  fin_cases i <;> rfl

public theorem ACell13_0_scaled :
    toVec #v[1, -1, -1, -1, -1, 1, 0, 0, 2, 0] = ((11 : ℤ) : ℚ) • ACell13_0 :=
  toVec_eq_smul10 #v[1, -1, -1, -1, -1, 1, 0, 0, 2, 0] 11 ACell13_0
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_zero 11)
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_zero 11)

public def ACell13_1 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (1 / 11 : ℚ)
  | 1 => 0
  | 2 => (3 / 11 : ℚ)
  | 3 => 0
  | 4 => (1 / 11 : ℚ)
  | 5 => 0
  | 6 => (1 / 11 : ℚ)
  | 7 => (2 / 11 : ℚ)
  | 8 => (2 / 11 : ℚ)
  | 9 => (1 / 11 : ℚ)
  | _ => 0

public theorem ACell13_1_def : ACell13_1 = ![(1 / 11 : ℚ), 0, (3 / 11 : ℚ), 0, (1 / 11 : ℚ), 0, (1 / 11 : ℚ), (2 / 11 : ℚ), (2 / 11 : ℚ), (1 / 11 : ℚ)] := by
  funext i
  fin_cases i <;> rfl

public theorem ACell13_1_scaled :
    toVec #v[1, 0, 3, 0, 1, 0, 1, 2, 2, 1] = ((11 : ℤ) : ℚ) • ACell13_1 :=
  toVec_eq_smul10 #v[1, 0, 3, 0, 1, 0, 1, 2, 2, 1] 11 ACell13_1
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_div (3) 11 (3) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))

public def ACell13_2 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (1 / 11 : ℚ)
  | 1 => (2 / 11 : ℚ)
  | 2 => 0
  | 3 => (3 / 11 : ℚ)
  | 4 => 0
  | 5 => (2 / 11 : ℚ)
  | 6 => (1 / 11 : ℚ)
  | 7 => 0
  | 8 => (1 / 11 : ℚ)
  | 9 => (1 / 11 : ℚ)
  | _ => 0

public theorem ACell13_2_def : ACell13_2 = ![(1 / 11 : ℚ), (2 / 11 : ℚ), 0, (3 / 11 : ℚ), 0, (2 / 11 : ℚ), (1 / 11 : ℚ), 0, (1 / 11 : ℚ), (1 / 11 : ℚ)] := by
  funext i
  fin_cases i <;> rfl

public theorem ACell13_2_scaled :
    toVec #v[1, 2, 0, 3, 0, 2, 1, 0, 1, 1] = ((11 : ℤ) : ℚ) • ACell13_2 :=
  toVec_eq_smul10 #v[1, 2, 0, 3, 0, 2, 1, 0, 1, 1] 11 ACell13_2
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_div (3) 11 (3) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))

public def ACell13_3 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (12 / 11 : ℚ)
  | 1 => 0
  | 2 => (-2 / 11 : ℚ)
  | 3 => (-1 / 11 : ℚ)
  | 4 => (-1 / 11 : ℚ)
  | 5 => (-2 / 11 : ℚ)
  | 6 => (-2 / 11 : ℚ)
  | 7 => (-1 / 11 : ℚ)
  | 8 => (-1 / 11 : ℚ)
  | 9 => (-2 / 11 : ℚ)
  | _ => 0

public theorem ACell13_3_def : ACell13_3 = ![(12 / 11 : ℚ), 0, (-2 / 11 : ℚ), (-1 / 11 : ℚ), (-1 / 11 : ℚ), (-2 / 11 : ℚ), (-2 / 11 : ℚ), (-1 / 11 : ℚ), (-1 / 11 : ℚ), (-2 / 11 : ℚ)] := by
  funext i
  fin_cases i <;> rfl

public theorem ACell13_3_scaled :
    toVec #v[12, 0, -2, -1, -1, -2, -2, -1, -1, -2] = ((11 : ℤ) : ℚ) • ACell13_3 :=
  toVec_eq_smul10 #v[12, 0, -2, -1, -1, -2, -2, -1, -1, -2] 11 ACell13_3
    (eq_smul_div (12) 11 (12) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))

public def ACell13_4 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (1 / 11 : ℚ)
  | 1 => (-1 / 11 : ℚ)
  | 2 => (-1 / 11 : ℚ)
  | 3 => 0
  | 4 => (2 / 11 : ℚ)
  | 5 => 0
  | 6 => (-1 / 11 : ℚ)
  | 7 => (-1 / 11 : ℚ)
  | 8 => (1 / 11 : ℚ)
  | 9 => 0
  | _ => 0

public theorem ACell13_4_def : ACell13_4 = ![(1 / 11 : ℚ), (-1 / 11 : ℚ), (-1 / 11 : ℚ), 0, (2 / 11 : ℚ), 0, (-1 / 11 : ℚ), (-1 / 11 : ℚ), (1 / 11 : ℚ), 0] := by
  funext i
  fin_cases i <;> rfl

public theorem ACell13_4_scaled :
    toVec #v[1, -1, -1, 0, 2, 0, -1, -1, 1, 0] = ((11 : ℤ) : ℚ) • ACell13_4 :=
  toVec_eq_smul10 #v[1, -1, -1, 0, 2, 0, -1, -1, 1, 0] 11 ACell13_4
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))
    (eq_smul_zero 11)

public def ACell13_5 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => 0
  | 1 => 0
  | 2 => 0
  | 3 => 0
  | 4 => 0
  | 5 => (-2 / 11 : ℚ)
  | 6 => (2 / 11 : ℚ)
  | 7 => (2 / 11 : ℚ)
  | 8 => (-2 / 11 : ℚ)
  | 9 => 0
  | _ => 0

public theorem ACell13_5_def : ACell13_5 = ![0, 0, 0, 0, 0, (-2 / 11 : ℚ), (2 / 11 : ℚ), (2 / 11 : ℚ), (-2 / 11 : ℚ), 0] := by
  funext i
  fin_cases i <;> rfl

public theorem ACell13_5_scaled :
    toVec #v[0, 0, 0, 0, 0, -2, 2, 2, -2, 0] = ((11 : ℤ) : ℚ) • ACell13_5 :=
  toVec_eq_smul10 #v[0, 0, 0, 0, 0, -2, 2, 2, -2, 0] 11 ACell13_5
    (eq_smul_zero 11)
    (eq_smul_zero 11)
    (eq_smul_zero 11)
    (eq_smul_zero 11)
    (eq_smul_zero 11)
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))
    (eq_smul_zero 11)

public def ACell13_6 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (-2 / 11 : ℚ)
  | 1 => 0
  | 2 => 0
  | 3 => (2 / 11 : ℚ)
  | 4 => (2 / 11 : ℚ)
  | 5 => 0
  | 6 => 0
  | 7 => (-2 / 11 : ℚ)
  | 8 => 0
  | 9 => 0
  | _ => 0

public theorem ACell13_6_def : ACell13_6 = ![(-2 / 11 : ℚ), 0, 0, (2 / 11 : ℚ), (2 / 11 : ℚ), 0, 0, (-2 / 11 : ℚ), 0, 0] := by
  funext i
  fin_cases i <;> rfl

public theorem ACell13_6_scaled :
    toVec #v[-2, 0, 0, 2, 2, 0, 0, -2, 0, 0] = ((11 : ℤ) : ℚ) • ACell13_6 :=
  toVec_eq_smul10 #v[-2, 0, 0, 2, 2, 0, 0, -2, 0, 0] 11 ACell13_6
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_zero 11)
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_zero 11)
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_zero 11)

public def ACell13_7 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (2 / 11 : ℚ)
  | 1 => (2 / 11 : ℚ)
  | 2 => 0
  | 3 => (2 / 11 : ℚ)
  | 4 => (2 / 11 : ℚ)
  | 5 => (4 / 11 : ℚ)
  | 6 => (2 / 11 : ℚ)
  | 7 => (4 / 11 : ℚ)
  | 8 => (2 / 11 : ℚ)
  | 9 => (2 / 11 : ℚ)
  | _ => 0

public theorem ACell13_7_def : ACell13_7 = ![(2 / 11 : ℚ), (2 / 11 : ℚ), 0, (2 / 11 : ℚ), (2 / 11 : ℚ), (4 / 11 : ℚ), (2 / 11 : ℚ), (4 / 11 : ℚ), (2 / 11 : ℚ), (2 / 11 : ℚ)] := by
  funext i
  fin_cases i <;> rfl

public theorem ACell13_7_scaled :
    toVec #v[2, 2, 0, 2, 2, 4, 2, 4, 2, 2] = ((11 : ℤ) : ℚ) • ACell13_7 :=
  toVec_eq_smul10 #v[2, 2, 0, 2, 2, 4, 2, 4, 2, 2] 11 ACell13_7
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_div (4) 11 (4) (11) (by decide) (by decide))
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_div (4) 11 (4) (11) (by decide) (by decide))
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))

public def ACell13_8 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (2 / 11 : ℚ)
  | 1 => (2 / 11 : ℚ)
  | 2 => (2 / 11 : ℚ)
  | 3 => (2 / 11 : ℚ)
  | 4 => 0
  | 5 => (2 / 11 : ℚ)
  | 6 => (4 / 11 : ℚ)
  | 7 => (2 / 11 : ℚ)
  | 8 => (4 / 11 : ℚ)
  | 9 => (2 / 11 : ℚ)
  | _ => 0

public theorem ACell13_8_def : ACell13_8 = ![(2 / 11 : ℚ), (2 / 11 : ℚ), (2 / 11 : ℚ), (2 / 11 : ℚ), 0, (2 / 11 : ℚ), (4 / 11 : ℚ), (2 / 11 : ℚ), (4 / 11 : ℚ), (2 / 11 : ℚ)] := by
  funext i
  fin_cases i <;> rfl

public theorem ACell13_8_scaled :
    toVec #v[2, 2, 2, 2, 0, 2, 4, 2, 4, 2] = ((11 : ℤ) : ℚ) • ACell13_8 :=
  toVec_eq_smul10 #v[2, 2, 2, 2, 0, 2, 4, 2, 4, 2] 11 ACell13_8
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_div (4) 11 (4) (11) (by decide) (by decide))
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_div (4) 11 (4) (11) (by decide) (by decide))
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))

public def ACell13_9 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => 0
  | 1 => 0
  | 2 => (-2 / 11 : ℚ)
  | 3 => (2 / 11 : ℚ)
  | 4 => 0
  | 5 => 0
  | 6 => 0
  | 7 => (2 / 11 : ℚ)
  | 8 => (-2 / 11 : ℚ)
  | 9 => 0
  | _ => 0

public theorem ACell13_9_def : ACell13_9 = ![0, 0, (-2 / 11 : ℚ), (2 / 11 : ℚ), 0, 0, 0, (2 / 11 : ℚ), (-2 / 11 : ℚ), 0] := by
  funext i
  fin_cases i <;> rfl

public theorem ACell13_9_scaled :
    toVec #v[0, 0, -2, 2, 0, 0, 0, 2, -2, 0] = ((11 : ℤ) : ℚ) • ACell13_9 :=
  toVec_eq_smul10 #v[0, 0, -2, 2, 0, 0, 0, 2, -2, 0] 11 ACell13_9
    (eq_smul_zero 11)
    (eq_smul_zero 11)
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_zero 11)
    (eq_smul_zero 11)
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))
    (eq_smul_zero 11)

public def ARow13 (j : Fin 10) : Vec :=
  match j.val with
  | 0 => ACell13_0
  | 1 => ACell13_1
  | 2 => ACell13_2
  | 3 => ACell13_3
  | 4 => ACell13_4
  | 5 => ACell13_5
  | 6 => ACell13_6
  | 7 => ACell13_7
  | 8 => ACell13_8
  | 9 => ACell13_9
  | _ => 0

public def ACell14_0 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (1 / 11 : ℚ)
  | 1 => (1 / 11 : ℚ)
  | 2 => 0
  | 3 => (2 / 11 : ℚ)
  | 4 => (3 / 11 : ℚ)
  | 5 => (2 / 11 : ℚ)
  | 6 => 0
  | 7 => (1 / 11 : ℚ)
  | 8 => (1 / 11 : ℚ)
  | 9 => 0
  | _ => 0

public theorem ACell14_0_def : ACell14_0 = ![(1 / 11 : ℚ), (1 / 11 : ℚ), 0, (2 / 11 : ℚ), (3 / 11 : ℚ), (2 / 11 : ℚ), 0, (1 / 11 : ℚ), (1 / 11 : ℚ), 0] := by
  funext i
  fin_cases i <;> rfl

public theorem ACell14_0_scaled :
    toVec #v[1, 1, 0, 2, 3, 2, 0, 1, 1, 0] = ((11 : ℤ) : ℚ) • ACell14_0 :=
  toVec_eq_smul10 #v[1, 1, 0, 2, 3, 2, 0, 1, 1, 0] 11 ACell14_0
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_div (3) 11 (3) (11) (by decide) (by decide))
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))
    (eq_smul_zero 11)

public def ACell14_1 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (2 / 11 : ℚ)
  | 1 => (1 / 11 : ℚ)
  | 2 => 0
  | 3 => (1 / 11 : ℚ)
  | 4 => (1 / 11 : ℚ)
  | 5 => 0
  | 6 => (1 / 11 : ℚ)
  | 7 => (2 / 11 : ℚ)
  | 8 => 0
  | 9 => (3 / 11 : ℚ)
  | _ => 0

public theorem ACell14_1_def : ACell14_1 = ![(2 / 11 : ℚ), (1 / 11 : ℚ), 0, (1 / 11 : ℚ), (1 / 11 : ℚ), 0, (1 / 11 : ℚ), (2 / 11 : ℚ), 0, (3 / 11 : ℚ)] := by
  funext i
  fin_cases i <;> rfl

public theorem ACell14_1_scaled :
    toVec #v[2, 1, 0, 1, 1, 0, 1, 2, 0, 3] = ((11 : ℤ) : ℚ) • ACell14_1 :=
  toVec_eq_smul10 #v[2, 1, 0, 1, 1, 0, 1, 2, 0, 3] 11 ACell14_1
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_div (3) 11 (3) (11) (by decide) (by decide))

public def ACell14_2 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (-2 / 11 : ℚ)
  | 1 => (-2 / 11 : ℚ)
  | 2 => (-1 / 11 : ℚ)
  | 3 => (-3 / 11 : ℚ)
  | 4 => (-3 / 11 : ℚ)
  | 5 => (-3 / 11 : ℚ)
  | 6 => (-3 / 11 : ℚ)
  | 7 => (-1 / 11 : ℚ)
  | 8 => (-2 / 11 : ℚ)
  | 9 => (-2 / 11 : ℚ)
  | _ => 0

public theorem ACell14_2_def : ACell14_2 = ![(-2 / 11 : ℚ), (-2 / 11 : ℚ), (-1 / 11 : ℚ), (-3 / 11 : ℚ), (-3 / 11 : ℚ), (-3 / 11 : ℚ), (-3 / 11 : ℚ), (-1 / 11 : ℚ), (-2 / 11 : ℚ), (-2 / 11 : ℚ)] := by
  funext i
  fin_cases i <;> rfl

public theorem ACell14_2_scaled :
    toVec #v[-2, -2, -1, -3, -3, -3, -3, -1, -2, -2] = ((11 : ℤ) : ℚ) • ACell14_2 :=
  toVec_eq_smul10 #v[-2, -2, -1, -3, -3, -3, -3, -1, -2, -2] 11 ACell14_2
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_div (-3) 11 (-3) (11) (by decide) (by decide))
    (eq_smul_div (-3) 11 (-3) (11) (by decide) (by decide))
    (eq_smul_div (-3) 11 (-3) (11) (by decide) (by decide))
    (eq_smul_div (-3) 11 (-3) (11) (by decide) (by decide))
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))

public def ACell14_3 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (2 / 11 : ℚ)
  | 1 => (1 / 11 : ℚ)
  | 2 => (1 / 11 : ℚ)
  | 3 => (2 / 11 : ℚ)
  | 4 => 0
  | 5 => 0
  | 6 => (1 / 11 : ℚ)
  | 7 => (3 / 11 : ℚ)
  | 8 => (1 / 11 : ℚ)
  | 9 => 0
  | _ => 0

public theorem ACell14_3_def : ACell14_3 = ![(2 / 11 : ℚ), (1 / 11 : ℚ), (1 / 11 : ℚ), (2 / 11 : ℚ), 0, 0, (1 / 11 : ℚ), (3 / 11 : ℚ), (1 / 11 : ℚ), 0] := by
  funext i
  fin_cases i <;> rfl

public theorem ACell14_3_scaled :
    toVec #v[2, 1, 1, 2, 0, 0, 1, 3, 1, 0] = ((11 : ℤ) : ℚ) • ACell14_3 :=
  toVec_eq_smul10 #v[2, 1, 1, 2, 0, 0, 1, 3, 1, 0] 11 ACell14_3
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_zero 11)
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))
    (eq_smul_div (3) 11 (3) (11) (by decide) (by decide))
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))
    (eq_smul_zero 11)

public def ACell14_4 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (14 / 11 : ℚ)
  | 1 => 0
  | 2 => (1 / 11 : ℚ)
  | 3 => 0
  | 4 => (1 / 11 : ℚ)
  | 5 => (2 / 11 : ℚ)
  | 6 => (2 / 11 : ℚ)
  | 7 => (1 / 11 : ℚ)
  | 8 => 0
  | 9 => (1 / 11 : ℚ)
  | _ => 0

public theorem ACell14_4_def : ACell14_4 = ![(14 / 11 : ℚ), 0, (1 / 11 : ℚ), 0, (1 / 11 : ℚ), (2 / 11 : ℚ), (2 / 11 : ℚ), (1 / 11 : ℚ), 0, (1 / 11 : ℚ)] := by
  funext i
  fin_cases i <;> rfl

public theorem ACell14_4_scaled :
    toVec #v[14, 0, 1, 0, 1, 2, 2, 1, 0, 1] = ((11 : ℤ) : ℚ) • ACell14_4 :=
  toVec_eq_smul10 #v[14, 0, 1, 0, 1, 2, 2, 1, 0, 1] 11 ACell14_4
    (eq_smul_div (14) 11 (14) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))

public def ACell14_5 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (-2 / 11 : ℚ)
  | 1 => (-2 / 11 : ℚ)
  | 2 => (-4 / 11 : ℚ)
  | 3 => (-4 / 11 : ℚ)
  | 4 => (-2 / 11 : ℚ)
  | 5 => (-2 / 11 : ℚ)
  | 6 => 0
  | 7 => (-2 / 11 : ℚ)
  | 8 => (-2 / 11 : ℚ)
  | 9 => (-2 / 11 : ℚ)
  | _ => 0

public theorem ACell14_5_def : ACell14_5 = ![(-2 / 11 : ℚ), (-2 / 11 : ℚ), (-4 / 11 : ℚ), (-4 / 11 : ℚ), (-2 / 11 : ℚ), (-2 / 11 : ℚ), 0, (-2 / 11 : ℚ), (-2 / 11 : ℚ), (-2 / 11 : ℚ)] := by
  funext i
  fin_cases i <;> rfl

public theorem ACell14_5_scaled :
    toVec #v[-2, -2, -4, -4, -2, -2, 0, -2, -2, -2] = ((11 : ℤ) : ℚ) • ACell14_5 :=
  toVec_eq_smul10 #v[-2, -2, -4, -4, -2, -2, 0, -2, -2, -2] 11 ACell14_5
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))
    (eq_smul_div (-4) 11 (-4) (11) (by decide) (by decide))
    (eq_smul_div (-4) 11 (-4) (11) (by decide) (by decide))
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))

public def ACell14_6 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => 0
  | 1 => 0
  | 2 => (-2 / 11 : ℚ)
  | 3 => (2 / 11 : ℚ)
  | 4 => 0
  | 5 => 0
  | 6 => 0
  | 7 => (2 / 11 : ℚ)
  | 8 => (-2 / 11 : ℚ)
  | 9 => 0
  | _ => 0

public theorem ACell14_6_def : ACell14_6 = ![0, 0, (-2 / 11 : ℚ), (2 / 11 : ℚ), 0, 0, 0, (2 / 11 : ℚ), (-2 / 11 : ℚ), 0] := by
  funext i
  fin_cases i <;> rfl

public theorem ACell14_6_scaled :
    toVec #v[0, 0, -2, 2, 0, 0, 0, 2, -2, 0] = ((11 : ℤ) : ℚ) • ACell14_6 :=
  toVec_eq_smul10 #v[0, 0, -2, 2, 0, 0, 0, 2, -2, 0] 11 ACell14_6
    (eq_smul_zero 11)
    (eq_smul_zero 11)
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_zero 11)
    (eq_smul_zero 11)
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))
    (eq_smul_zero 11)

public def ACell14_7 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => 0
  | 1 => 0
  | 2 => 0
  | 3 => 0
  | 4 => 0
  | 5 => 0
  | 6 => (2 / 11 : ℚ)
  | 7 => (-2 / 11 : ℚ)
  | 8 => (-2 / 11 : ℚ)
  | 9 => (2 / 11 : ℚ)
  | _ => 0

public theorem ACell14_7_def : ACell14_7 = ![0, 0, 0, 0, 0, 0, (2 / 11 : ℚ), (-2 / 11 : ℚ), (-2 / 11 : ℚ), (2 / 11 : ℚ)] := by
  funext i
  fin_cases i <;> rfl

public theorem ACell14_7_scaled :
    toVec #v[0, 0, 0, 0, 0, 0, 2, -2, -2, 2] = ((11 : ℤ) : ℚ) • ACell14_7 :=
  toVec_eq_smul10 #v[0, 0, 0, 0, 0, 0, 2, -2, -2, 2] 11 ACell14_7
    (eq_smul_zero 11)
    (eq_smul_zero 11)
    (eq_smul_zero 11)
    (eq_smul_zero 11)
    (eq_smul_zero 11)
    (eq_smul_zero 11)
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))

public def ACell14_8 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (-2 / 11 : ℚ)
  | 1 => (-2 / 11 : ℚ)
  | 2 => (-4 / 11 : ℚ)
  | 3 => (-2 / 11 : ℚ)
  | 4 => (-4 / 11 : ℚ)
  | 5 => (-2 / 11 : ℚ)
  | 6 => (-2 / 11 : ℚ)
  | 7 => 0
  | 8 => (-2 / 11 : ℚ)
  | 9 => (-2 / 11 : ℚ)
  | _ => 0

public theorem ACell14_8_def : ACell14_8 = ![(-2 / 11 : ℚ), (-2 / 11 : ℚ), (-4 / 11 : ℚ), (-2 / 11 : ℚ), (-4 / 11 : ℚ), (-2 / 11 : ℚ), (-2 / 11 : ℚ), 0, (-2 / 11 : ℚ), (-2 / 11 : ℚ)] := by
  funext i
  fin_cases i <;> rfl

public theorem ACell14_8_scaled :
    toVec #v[-2, -2, -4, -2, -4, -2, -2, 0, -2, -2] = ((11 : ℤ) : ℚ) • ACell14_8 :=
  toVec_eq_smul10 #v[-2, -2, -4, -2, -4, -2, -2, 0, -2, -2] 11 ACell14_8
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))
    (eq_smul_div (-4) 11 (-4) (11) (by decide) (by decide))
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))
    (eq_smul_div (-4) 11 (-4) (11) (by decide) (by decide))
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))

public def ACell14_9 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (-2 / 11 : ℚ)
  | 1 => 0
  | 2 => (-2 / 11 : ℚ)
  | 3 => 0
  | 4 => (2 / 11 : ℚ)
  | 5 => 0
  | 6 => 0
  | 7 => 0
  | 8 => 0
  | 9 => (2 / 11 : ℚ)
  | _ => 0

public theorem ACell14_9_def : ACell14_9 = ![(-2 / 11 : ℚ), 0, (-2 / 11 : ℚ), 0, (2 / 11 : ℚ), 0, 0, 0, 0, (2 / 11 : ℚ)] := by
  funext i
  fin_cases i <;> rfl

public theorem ACell14_9_scaled :
    toVec #v[-2, 0, -2, 0, 2, 0, 0, 0, 0, 2] = ((11 : ℤ) : ℚ) • ACell14_9 :=
  toVec_eq_smul10 #v[-2, 0, -2, 0, 2, 0, 0, 0, 0, 2] 11 ACell14_9
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_zero 11)
    (eq_smul_zero 11)
    (eq_smul_zero 11)
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))

public def ARow14 (j : Fin 10) : Vec :=
  match j.val with
  | 0 => ACell14_0
  | 1 => ACell14_1
  | 2 => ACell14_2
  | 3 => ACell14_3
  | 4 => ACell14_4
  | 5 => ACell14_5
  | 6 => ACell14_6
  | 7 => ACell14_7
  | 8 => ACell14_8
  | 9 => ACell14_9
  | _ => 0

public def ACell15_0 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (3 / 22 : ℚ)
  | 1 => 0
  | 2 => 0
  | 3 => (3 / 22 : ℚ)
  | 4 => 0
  | 5 => 0
  | 6 => (-3 / 22 : ℚ)
  | 7 => 0
  | 8 => (-3 / 22 : ℚ)
  | 9 => 0
  | _ => 0

public theorem ACell15_0_def : ACell15_0 = ![(3 / 22 : ℚ), 0, 0, (3 / 22 : ℚ), 0, 0, (-3 / 22 : ℚ), 0, (-3 / 22 : ℚ), 0] := by
  funext i
  fin_cases i <;> rfl

public theorem ACell15_0_scaled :
    toVec #v[3, 0, 0, 3, 0, 0, -3, 0, -3, 0] = ((22 : ℤ) : ℚ) • ACell15_0 :=
  toVec_eq_smul10 #v[3, 0, 0, 3, 0, 0, -3, 0, -3, 0] 22 ACell15_0
    (eq_smul_div (3) 22 (3) (22) (by decide) (by decide))
    (eq_smul_zero 22)
    (eq_smul_zero 22)
    (eq_smul_div (3) 22 (3) (22) (by decide) (by decide))
    (eq_smul_zero 22)
    (eq_smul_zero 22)
    (eq_smul_div (-3) 22 (-3) (22) (by decide) (by decide))
    (eq_smul_zero 22)
    (eq_smul_div (-3) 22 (-3) (22) (by decide) (by decide))
    (eq_smul_zero 22)

public def ACell15_1 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (3 / 22 : ℚ)
  | 1 => (3 / 22 : ℚ)
  | 2 => (3 / 22 : ℚ)
  | 3 => 0
  | 4 => (3 / 11 : ℚ)
  | 5 => (3 / 22 : ℚ)
  | 6 => (3 / 22 : ℚ)
  | 7 => (3 / 22 : ℚ)
  | 8 => (3 / 22 : ℚ)
  | 9 => (3 / 11 : ℚ)
  | _ => 0

public theorem ACell15_1_def : ACell15_1 = ![(3 / 22 : ℚ), (3 / 22 : ℚ), (3 / 22 : ℚ), 0, (3 / 11 : ℚ), (3 / 22 : ℚ), (3 / 22 : ℚ), (3 / 22 : ℚ), (3 / 22 : ℚ), (3 / 11 : ℚ)] := by
  funext i
  fin_cases i <;> rfl

public theorem ACell15_1_scaled :
    toVec #v[3, 3, 3, 0, 6, 3, 3, 3, 3, 6] = ((22 : ℤ) : ℚ) • ACell15_1 :=
  toVec_eq_smul10 #v[3, 3, 3, 0, 6, 3, 3, 3, 3, 6] 22 ACell15_1
    (eq_smul_div (3) 22 (3) (22) (by decide) (by decide))
    (eq_smul_div (3) 22 (3) (22) (by decide) (by decide))
    (eq_smul_div (3) 22 (3) (22) (by decide) (by decide))
    (eq_smul_zero 22)
    (eq_smul_div (6) 22 (3) (11) (by decide) (by decide))
    (eq_smul_div (3) 22 (3) (22) (by decide) (by decide))
    (eq_smul_div (3) 22 (3) (22) (by decide) (by decide))
    (eq_smul_div (3) 22 (3) (22) (by decide) (by decide))
    (eq_smul_div (3) 22 (3) (22) (by decide) (by decide))
    (eq_smul_div (6) 22 (3) (11) (by decide) (by decide))

public def ACell15_2 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (3 / 22 : ℚ)
  | 1 => (3 / 11 : ℚ)
  | 2 => (3 / 22 : ℚ)
  | 3 => (3 / 11 : ℚ)
  | 4 => (3 / 22 : ℚ)
  | 5 => 0
  | 6 => (3 / 22 : ℚ)
  | 7 => (3 / 22 : ℚ)
  | 8 => (3 / 22 : ℚ)
  | 9 => (3 / 22 : ℚ)
  | _ => 0

public theorem ACell15_2_def : ACell15_2 = ![(3 / 22 : ℚ), (3 / 11 : ℚ), (3 / 22 : ℚ), (3 / 11 : ℚ), (3 / 22 : ℚ), 0, (3 / 22 : ℚ), (3 / 22 : ℚ), (3 / 22 : ℚ), (3 / 22 : ℚ)] := by
  funext i
  fin_cases i <;> rfl

public theorem ACell15_2_scaled :
    toVec #v[3, 6, 3, 6, 3, 0, 3, 3, 3, 3] = ((22 : ℤ) : ℚ) • ACell15_2 :=
  toVec_eq_smul10 #v[3, 6, 3, 6, 3, 0, 3, 3, 3, 3] 22 ACell15_2
    (eq_smul_div (3) 22 (3) (22) (by decide) (by decide))
    (eq_smul_div (6) 22 (3) (11) (by decide) (by decide))
    (eq_smul_div (3) 22 (3) (22) (by decide) (by decide))
    (eq_smul_div (6) 22 (3) (11) (by decide) (by decide))
    (eq_smul_div (3) 22 (3) (22) (by decide) (by decide))
    (eq_smul_zero 22)
    (eq_smul_div (3) 22 (3) (22) (by decide) (by decide))
    (eq_smul_div (3) 22 (3) (22) (by decide) (by decide))
    (eq_smul_div (3) 22 (3) (22) (by decide) (by decide))
    (eq_smul_div (3) 22 (3) (22) (by decide) (by decide))

public def ACell15_3 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => 0
  | 1 => 0
  | 2 => 0
  | 3 => (-3 / 22 : ℚ)
  | 4 => (3 / 22 : ℚ)
  | 5 => (3 / 22 : ℚ)
  | 6 => (-3 / 22 : ℚ)
  | 7 => 0
  | 8 => 0
  | 9 => 0
  | _ => 0

public theorem ACell15_3_def : ACell15_3 = ![0, 0, 0, (-3 / 22 : ℚ), (3 / 22 : ℚ), (3 / 22 : ℚ), (-3 / 22 : ℚ), 0, 0, 0] := by
  funext i
  fin_cases i <;> rfl

public theorem ACell15_3_scaled :
    toVec #v[0, 0, 0, -3, 3, 3, -3, 0, 0, 0] = ((22 : ℤ) : ℚ) • ACell15_3 :=
  toVec_eq_smul10 #v[0, 0, 0, -3, 3, 3, -3, 0, 0, 0] 22 ACell15_3
    (eq_smul_zero 22)
    (eq_smul_zero 22)
    (eq_smul_zero 22)
    (eq_smul_div (-3) 22 (-3) (22) (by decide) (by decide))
    (eq_smul_div (3) 22 (3) (22) (by decide) (by decide))
    (eq_smul_div (3) 22 (3) (22) (by decide) (by decide))
    (eq_smul_div (-3) 22 (-3) (22) (by decide) (by decide))
    (eq_smul_zero 22)
    (eq_smul_zero 22)
    (eq_smul_zero 22)

public def ACell15_4 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => 0
  | 1 => (3 / 22 : ℚ)
  | 2 => 0
  | 3 => 0
  | 4 => 0
  | 5 => (3 / 22 : ℚ)
  | 6 => 0
  | 7 => 0
  | 8 => (-3 / 22 : ℚ)
  | 9 => (-3 / 22 : ℚ)
  | _ => 0

public theorem ACell15_4_def : ACell15_4 = ![0, (3 / 22 : ℚ), 0, 0, 0, (3 / 22 : ℚ), 0, 0, (-3 / 22 : ℚ), (-3 / 22 : ℚ)] := by
  funext i
  fin_cases i <;> rfl

public theorem ACell15_4_scaled :
    toVec #v[0, 3, 0, 0, 0, 3, 0, 0, -3, -3] = ((22 : ℤ) : ℚ) • ACell15_4 :=
  toVec_eq_smul10 #v[0, 3, 0, 0, 0, 3, 0, 0, -3, -3] 22 ACell15_4
    (eq_smul_zero 22)
    (eq_smul_div (3) 22 (3) (22) (by decide) (by decide))
    (eq_smul_zero 22)
    (eq_smul_zero 22)
    (eq_smul_zero 22)
    (eq_smul_div (3) 22 (3) (22) (by decide) (by decide))
    (eq_smul_zero 22)
    (eq_smul_zero 22)
    (eq_smul_div (-3) 22 (-3) (22) (by decide) (by decide))
    (eq_smul_div (-3) 22 (-3) (22) (by decide) (by decide))

public def ACell15_5 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (14 / 11 : ℚ)
  | 1 => 0
  | 2 => (2 / 11 : ℚ)
  | 3 => (1 / 11 : ℚ)
  | 4 => 0
  | 5 => (1 / 11 : ℚ)
  | 6 => (1 / 11 : ℚ)
  | 7 => 0
  | 8 => (1 / 11 : ℚ)
  | 9 => (2 / 11 : ℚ)
  | _ => 0

public theorem ACell15_5_def : ACell15_5 = ![(14 / 11 : ℚ), 0, (2 / 11 : ℚ), (1 / 11 : ℚ), 0, (1 / 11 : ℚ), (1 / 11 : ℚ), 0, (1 / 11 : ℚ), (2 / 11 : ℚ)] := by
  funext i
  fin_cases i <;> rfl

public theorem ACell15_5_scaled :
    toVec #v[14, 0, 2, 1, 0, 1, 1, 0, 1, 2] = ((11 : ℤ) : ℚ) • ACell15_5 :=
  toVec_eq_smul10 #v[14, 0, 2, 1, 0, 1, 1, 0, 1, 2] 11 ACell15_5
    (eq_smul_div (14) 11 (14) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))

public def ACell15_6 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (-1 / 11 : ℚ)
  | 1 => (1 / 11 : ℚ)
  | 2 => (1 / 11 : ℚ)
  | 3 => (1 / 11 : ℚ)
  | 4 => (1 / 11 : ℚ)
  | 5 => (-1 / 11 : ℚ)
  | 6 => 0
  | 7 => 0
  | 8 => (-2 / 11 : ℚ)
  | 9 => 0
  | _ => 0

public theorem ACell15_6_def : ACell15_6 = ![(-1 / 11 : ℚ), (1 / 11 : ℚ), (1 / 11 : ℚ), (1 / 11 : ℚ), (1 / 11 : ℚ), (-1 / 11 : ℚ), 0, 0, (-2 / 11 : ℚ), 0] := by
  funext i
  fin_cases i <;> rfl

public theorem ACell15_6_scaled :
    toVec #v[-1, 1, 1, 1, 1, -1, 0, 0, -2, 0] = ((11 : ℤ) : ℚ) • ACell15_6 :=
  toVec_eq_smul10 #v[-1, 1, 1, 1, 1, -1, 0, 0, -2, 0] 11 ACell15_6
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_zero 11)
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))
    (eq_smul_zero 11)

public def ACell15_7 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => 0
  | 1 => (1 / 11 : ℚ)
  | 2 => (2 / 11 : ℚ)
  | 3 => (1 / 11 : ℚ)
  | 4 => (2 / 11 : ℚ)
  | 5 => (-1 / 11 : ℚ)
  | 6 => (2 / 11 : ℚ)
  | 7 => (1 / 11 : ℚ)
  | 8 => (2 / 11 : ℚ)
  | 9 => (1 / 11 : ℚ)
  | _ => 0

public theorem ACell15_7_def : ACell15_7 = ![0, (1 / 11 : ℚ), (2 / 11 : ℚ), (1 / 11 : ℚ), (2 / 11 : ℚ), (-1 / 11 : ℚ), (2 / 11 : ℚ), (1 / 11 : ℚ), (2 / 11 : ℚ), (1 / 11 : ℚ)] := by
  funext i
  fin_cases i <;> rfl

public theorem ACell15_7_scaled :
    toVec #v[0, 1, 2, 1, 2, -1, 2, 1, 2, 1] = ((11 : ℤ) : ℚ) • ACell15_7 :=
  toVec_eq_smul10 #v[0, 1, 2, 1, 2, -1, 2, 1, 2, 1] 11 ACell15_7
    (eq_smul_zero 11)
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))

public def ACell15_8 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (-1 / 11 : ℚ)
  | 1 => (-1 / 11 : ℚ)
  | 2 => 0
  | 3 => (-2 / 11 : ℚ)
  | 4 => (-2 / 11 : ℚ)
  | 5 => (-1 / 11 : ℚ)
  | 6 => (1 / 11 : ℚ)
  | 7 => (-1 / 11 : ℚ)
  | 8 => (-2 / 11 : ℚ)
  | 9 => (-2 / 11 : ℚ)
  | _ => 0

public theorem ACell15_8_def : ACell15_8 = ![(-1 / 11 : ℚ), (-1 / 11 : ℚ), 0, (-2 / 11 : ℚ), (-2 / 11 : ℚ), (-1 / 11 : ℚ), (1 / 11 : ℚ), (-1 / 11 : ℚ), (-2 / 11 : ℚ), (-2 / 11 : ℚ)] := by
  funext i
  fin_cases i <;> rfl

public theorem ACell15_8_scaled :
    toVec #v[-1, -1, 0, -2, -2, -1, 1, -1, -2, -2] = ((11 : ℤ) : ℚ) • ACell15_8 :=
  toVec_eq_smul10 #v[-1, -1, 0, -2, -2, -1, 1, -1, -2, -2] 11 ACell15_8
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))

public def ACell15_9 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (-1 / 11 : ℚ)
  | 1 => (-1 / 11 : ℚ)
  | 2 => 0
  | 3 => (-2 / 11 : ℚ)
  | 4 => (-3 / 11 : ℚ)
  | 5 => (-2 / 11 : ℚ)
  | 6 => 0
  | 7 => (-1 / 11 : ℚ)
  | 8 => (-1 / 11 : ℚ)
  | 9 => 0
  | _ => 0

public theorem ACell15_9_def : ACell15_9 = ![(-1 / 11 : ℚ), (-1 / 11 : ℚ), 0, (-2 / 11 : ℚ), (-3 / 11 : ℚ), (-2 / 11 : ℚ), 0, (-1 / 11 : ℚ), (-1 / 11 : ℚ), 0] := by
  funext i
  fin_cases i <;> rfl

public theorem ACell15_9_scaled :
    toVec #v[-1, -1, 0, -2, -3, -2, 0, -1, -1, 0] = ((11 : ℤ) : ℚ) • ACell15_9 :=
  toVec_eq_smul10 #v[-1, -1, 0, -2, -3, -2, 0, -1, -1, 0] 11 ACell15_9
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))
    (eq_smul_div (-3) 11 (-3) (11) (by decide) (by decide))
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_zero 11)

public def ARow15 (j : Fin 10) : Vec :=
  match j.val with
  | 0 => ACell15_0
  | 1 => ACell15_1
  | 2 => ACell15_2
  | 3 => ACell15_3
  | 4 => ACell15_4
  | 5 => ACell15_5
  | 6 => ACell15_6
  | 7 => ACell15_7
  | 8 => ACell15_8
  | 9 => ACell15_9
  | _ => 0

public def ACell16_0 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => 0
  | 1 => 0
  | 2 => 0
  | 3 => (3 / 22 : ℚ)
  | 4 => (-3 / 22 : ℚ)
  | 5 => (-3 / 22 : ℚ)
  | 6 => (3 / 22 : ℚ)
  | 7 => 0
  | 8 => 0
  | 9 => 0
  | _ => 0

public theorem ACell16_0_def : ACell16_0 = ![0, 0, 0, (3 / 22 : ℚ), (-3 / 22 : ℚ), (-3 / 22 : ℚ), (3 / 22 : ℚ), 0, 0, 0] := by
  funext i
  fin_cases i <;> rfl

public theorem ACell16_0_scaled :
    toVec #v[0, 0, 0, 3, -3, -3, 3, 0, 0, 0] = ((22 : ℤ) : ℚ) • ACell16_0 :=
  toVec_eq_smul10 #v[0, 0, 0, 3, -3, -3, 3, 0, 0, 0] 22 ACell16_0
    (eq_smul_zero 22)
    (eq_smul_zero 22)
    (eq_smul_zero 22)
    (eq_smul_div (3) 22 (3) (22) (by decide) (by decide))
    (eq_smul_div (-3) 22 (-3) (22) (by decide) (by decide))
    (eq_smul_div (-3) 22 (-3) (22) (by decide) (by decide))
    (eq_smul_div (3) 22 (3) (22) (by decide) (by decide))
    (eq_smul_zero 22)
    (eq_smul_zero 22)
    (eq_smul_zero 22)

public def ACell16_1 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => 0
  | 1 => (3 / 22 : ℚ)
  | 2 => 0
  | 3 => (-3 / 22 : ℚ)
  | 4 => 0
  | 5 => (-3 / 22 : ℚ)
  | 6 => 0
  | 7 => (3 / 22 : ℚ)
  | 8 => 0
  | 9 => 0
  | _ => 0

public theorem ACell16_1_def : ACell16_1 = ![0, (3 / 22 : ℚ), 0, (-3 / 22 : ℚ), 0, (-3 / 22 : ℚ), 0, (3 / 22 : ℚ), 0, 0] := by
  funext i
  fin_cases i <;> rfl

public theorem ACell16_1_scaled :
    toVec #v[0, 3, 0, -3, 0, -3, 0, 3, 0, 0] = ((22 : ℤ) : ℚ) • ACell16_1 :=
  toVec_eq_smul10 #v[0, 3, 0, -3, 0, -3, 0, 3, 0, 0] 22 ACell16_1
    (eq_smul_zero 22)
    (eq_smul_div (3) 22 (3) (22) (by decide) (by decide))
    (eq_smul_zero 22)
    (eq_smul_div (-3) 22 (-3) (22) (by decide) (by decide))
    (eq_smul_zero 22)
    (eq_smul_div (-3) 22 (-3) (22) (by decide) (by decide))
    (eq_smul_zero 22)
    (eq_smul_div (3) 22 (3) (22) (by decide) (by decide))
    (eq_smul_zero 22)
    (eq_smul_zero 22)

public def ACell16_2 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => 0
  | 1 => (-3 / 22 : ℚ)
  | 2 => 0
  | 3 => 0
  | 4 => (3 / 22 : ℚ)
  | 5 => 0
  | 6 => (3 / 22 : ℚ)
  | 7 => 0
  | 8 => 0
  | 9 => (-3 / 22 : ℚ)
  | _ => 0

public theorem ACell16_2_def : ACell16_2 = ![0, (-3 / 22 : ℚ), 0, 0, (3 / 22 : ℚ), 0, (3 / 22 : ℚ), 0, 0, (-3 / 22 : ℚ)] := by
  funext i
  fin_cases i <;> rfl

public theorem ACell16_2_scaled :
    toVec #v[0, -3, 0, 0, 3, 0, 3, 0, 0, -3] = ((22 : ℤ) : ℚ) • ACell16_2 :=
  toVec_eq_smul10 #v[0, -3, 0, 0, 3, 0, 3, 0, 0, -3] 22 ACell16_2
    (eq_smul_zero 22)
    (eq_smul_div (-3) 22 (-3) (22) (by decide) (by decide))
    (eq_smul_zero 22)
    (eq_smul_zero 22)
    (eq_smul_div (3) 22 (3) (22) (by decide) (by decide))
    (eq_smul_zero 22)
    (eq_smul_div (3) 22 (3) (22) (by decide) (by decide))
    (eq_smul_zero 22)
    (eq_smul_zero 22)
    (eq_smul_div (-3) 22 (-3) (22) (by decide) (by decide))

public def ACell16_3 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (-3 / 22 : ℚ)
  | 1 => 0
  | 2 => 0
  | 3 => 0
  | 4 => (-3 / 22 : ℚ)
  | 5 => 0
  | 6 => 0
  | 7 => (3 / 22 : ℚ)
  | 8 => (3 / 22 : ℚ)
  | 9 => 0
  | _ => 0

public theorem ACell16_3_def : ACell16_3 = ![(-3 / 22 : ℚ), 0, 0, 0, (-3 / 22 : ℚ), 0, 0, (3 / 22 : ℚ), (3 / 22 : ℚ), 0] := by
  funext i
  fin_cases i <;> rfl

public theorem ACell16_3_scaled :
    toVec #v[-3, 0, 0, 0, -3, 0, 0, 3, 3, 0] = ((22 : ℤ) : ℚ) • ACell16_3 :=
  toVec_eq_smul10 #v[-3, 0, 0, 0, -3, 0, 0, 3, 3, 0] 22 ACell16_3
    (eq_smul_div (-3) 22 (-3) (22) (by decide) (by decide))
    (eq_smul_zero 22)
    (eq_smul_zero 22)
    (eq_smul_zero 22)
    (eq_smul_div (-3) 22 (-3) (22) (by decide) (by decide))
    (eq_smul_zero 22)
    (eq_smul_zero 22)
    (eq_smul_div (3) 22 (3) (22) (by decide) (by decide))
    (eq_smul_div (3) 22 (3) (22) (by decide) (by decide))
    (eq_smul_zero 22)

public def ACell16_4 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => 0
  | 1 => 0
  | 2 => 0
  | 3 => (-3 / 22 : ℚ)
  | 4 => (3 / 22 : ℚ)
  | 5 => 0
  | 6 => 0
  | 7 => 0
  | 8 => (3 / 22 : ℚ)
  | 9 => (-3 / 22 : ℚ)
  | _ => 0

public theorem ACell16_4_def : ACell16_4 = ![0, 0, 0, (-3 / 22 : ℚ), (3 / 22 : ℚ), 0, 0, 0, (3 / 22 : ℚ), (-3 / 22 : ℚ)] := by
  funext i
  fin_cases i <;> rfl

public theorem ACell16_4_scaled :
    toVec #v[0, 0, 0, -3, 3, 0, 0, 0, 3, -3] = ((22 : ℤ) : ℚ) • ACell16_4 :=
  toVec_eq_smul10 #v[0, 0, 0, -3, 3, 0, 0, 0, 3, -3] 22 ACell16_4
    (eq_smul_zero 22)
    (eq_smul_zero 22)
    (eq_smul_zero 22)
    (eq_smul_div (-3) 22 (-3) (22) (by decide) (by decide))
    (eq_smul_div (3) 22 (3) (22) (by decide) (by decide))
    (eq_smul_zero 22)
    (eq_smul_zero 22)
    (eq_smul_zero 22)
    (eq_smul_div (3) 22 (3) (22) (by decide) (by decide))
    (eq_smul_div (-3) 22 (-3) (22) (by decide) (by decide))

public def ACell16_5 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (-2 / 11 : ℚ)
  | 1 => (-1 / 11 : ℚ)
  | 2 => (-1 / 11 : ℚ)
  | 3 => (-3 / 11 : ℚ)
  | 4 => (-1 / 11 : ℚ)
  | 5 => (-1 / 11 : ℚ)
  | 6 => (-2 / 11 : ℚ)
  | 7 => 0
  | 8 => 0
  | 9 => 0
  | _ => 0

public theorem ACell16_5_def : ACell16_5 = ![(-2 / 11 : ℚ), (-1 / 11 : ℚ), (-1 / 11 : ℚ), (-3 / 11 : ℚ), (-1 / 11 : ℚ), (-1 / 11 : ℚ), (-2 / 11 : ℚ), 0, 0, 0] := by
  funext i
  fin_cases i <;> rfl

public theorem ACell16_5_scaled :
    toVec #v[-2, -1, -1, -3, -1, -1, -2, 0, 0, 0] = ((11 : ℤ) : ℚ) • ACell16_5 :=
  toVec_eq_smul10 #v[-2, -1, -1, -3, -1, -1, -2, 0, 0, 0] 11 ACell16_5
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_div (-3) 11 (-3) (11) (by decide) (by decide))
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_zero 11)
    (eq_smul_zero 11)

public def ACell16_6 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (12 / 11 : ℚ)
  | 1 => 0
  | 2 => (-2 / 11 : ℚ)
  | 3 => (-1 / 11 : ℚ)
  | 4 => (-1 / 11 : ℚ)
  | 5 => (-2 / 11 : ℚ)
  | 6 => (-2 / 11 : ℚ)
  | 7 => (-1 / 11 : ℚ)
  | 8 => (-1 / 11 : ℚ)
  | 9 => (-2 / 11 : ℚ)
  | _ => 0

public theorem ACell16_6_def : ACell16_6 = ![(12 / 11 : ℚ), 0, (-2 / 11 : ℚ), (-1 / 11 : ℚ), (-1 / 11 : ℚ), (-2 / 11 : ℚ), (-2 / 11 : ℚ), (-1 / 11 : ℚ), (-1 / 11 : ℚ), (-2 / 11 : ℚ)] := by
  funext i
  fin_cases i <;> rfl

public theorem ACell16_6_scaled :
    toVec #v[12, 0, -2, -1, -1, -2, -2, -1, -1, -2] = ((11 : ℤ) : ℚ) • ACell16_6 :=
  toVec_eq_smul10 #v[12, 0, -2, -1, -1, -2, -2, -1, -1, -2] 11 ACell16_6
    (eq_smul_div (12) 11 (12) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))

public def ACell16_7 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (-1 / 11 : ℚ)
  | 1 => (-2 / 11 : ℚ)
  | 2 => (-1 / 11 : ℚ)
  | 3 => (-1 / 11 : ℚ)
  | 4 => (-2 / 11 : ℚ)
  | 5 => (-1 / 11 : ℚ)
  | 6 => 0
  | 7 => (-2 / 11 : ℚ)
  | 8 => (1 / 11 : ℚ)
  | 9 => (-2 / 11 : ℚ)
  | _ => 0

public theorem ACell16_7_def : ACell16_7 = ![(-1 / 11 : ℚ), (-2 / 11 : ℚ), (-1 / 11 : ℚ), (-1 / 11 : ℚ), (-2 / 11 : ℚ), (-1 / 11 : ℚ), 0, (-2 / 11 : ℚ), (1 / 11 : ℚ), (-2 / 11 : ℚ)] := by
  funext i
  fin_cases i <;> rfl

public theorem ACell16_7_scaled :
    toVec #v[-1, -2, -1, -1, -2, -1, 0, -2, 1, -2] = ((11 : ℤ) : ℚ) • ACell16_7 :=
  toVec_eq_smul10 #v[-1, -2, -1, -1, -2, -1, 0, -2, 1, -2] 11 ACell16_7
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))

public def ACell16_8 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (-1 / 11 : ℚ)
  | 1 => 0
  | 2 => (-1 / 11 : ℚ)
  | 3 => (-2 / 11 : ℚ)
  | 4 => (-2 / 11 : ℚ)
  | 5 => (-1 / 11 : ℚ)
  | 6 => 0
  | 7 => (-1 / 11 : ℚ)
  | 8 => 0
  | 9 => (-3 / 11 : ℚ)
  | _ => 0

public theorem ACell16_8_def : ACell16_8 = ![(-1 / 11 : ℚ), 0, (-1 / 11 : ℚ), (-2 / 11 : ℚ), (-2 / 11 : ℚ), (-1 / 11 : ℚ), 0, (-1 / 11 : ℚ), 0, (-3 / 11 : ℚ)] := by
  funext i
  fin_cases i <;> rfl

public theorem ACell16_8_scaled :
    toVec #v[-1, 0, -1, -2, -2, -1, 0, -1, 0, -3] = ((11 : ℤ) : ℚ) • ACell16_8 :=
  toVec_eq_smul10 #v[-1, 0, -1, -2, -2, -1, 0, -1, 0, -3] 11 ACell16_8
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_div (-3) 11 (-3) (11) (by decide) (by decide))

public def ACell16_9 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (2 / 11 : ℚ)
  | 1 => (1 / 11 : ℚ)
  | 2 => (1 / 11 : ℚ)
  | 3 => (2 / 11 : ℚ)
  | 4 => 0
  | 5 => 0
  | 6 => (1 / 11 : ℚ)
  | 7 => (3 / 11 : ℚ)
  | 8 => (1 / 11 : ℚ)
  | 9 => 0
  | _ => 0

public theorem ACell16_9_def : ACell16_9 = ![(2 / 11 : ℚ), (1 / 11 : ℚ), (1 / 11 : ℚ), (2 / 11 : ℚ), 0, 0, (1 / 11 : ℚ), (3 / 11 : ℚ), (1 / 11 : ℚ), 0] := by
  funext i
  fin_cases i <;> rfl

public theorem ACell16_9_scaled :
    toVec #v[2, 1, 1, 2, 0, 0, 1, 3, 1, 0] = ((11 : ℤ) : ℚ) • ACell16_9 :=
  toVec_eq_smul10 #v[2, 1, 1, 2, 0, 0, 1, 3, 1, 0] 11 ACell16_9
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_zero 11)
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))
    (eq_smul_div (3) 11 (3) (11) (by decide) (by decide))
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))
    (eq_smul_zero 11)

public def ARow16 (j : Fin 10) : Vec :=
  match j.val with
  | 0 => ACell16_0
  | 1 => ACell16_1
  | 2 => ACell16_2
  | 3 => ACell16_3
  | 4 => ACell16_4
  | 5 => ACell16_5
  | 6 => ACell16_6
  | 7 => ACell16_7
  | 8 => ACell16_8
  | 9 => ACell16_9
  | _ => 0

public def ACell17_0 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (-3 / 22 : ℚ)
  | 1 => (-3 / 11 : ℚ)
  | 2 => (-3 / 22 : ℚ)
  | 3 => (-3 / 11 : ℚ)
  | 4 => (-3 / 22 : ℚ)
  | 5 => 0
  | 6 => (-3 / 22 : ℚ)
  | 7 => (-3 / 22 : ℚ)
  | 8 => (-3 / 22 : ℚ)
  | 9 => (-3 / 22 : ℚ)
  | _ => 0

public theorem ACell17_0_def : ACell17_0 = ![(-3 / 22 : ℚ), (-3 / 11 : ℚ), (-3 / 22 : ℚ), (-3 / 11 : ℚ), (-3 / 22 : ℚ), 0, (-3 / 22 : ℚ), (-3 / 22 : ℚ), (-3 / 22 : ℚ), (-3 / 22 : ℚ)] := by
  funext i
  fin_cases i <;> rfl

public theorem ACell17_0_scaled :
    toVec #v[-3, -6, -3, -6, -3, 0, -3, -3, -3, -3] = ((22 : ℤ) : ℚ) • ACell17_0 :=
  toVec_eq_smul10 #v[-3, -6, -3, -6, -3, 0, -3, -3, -3, -3] 22 ACell17_0
    (eq_smul_div (-3) 22 (-3) (22) (by decide) (by decide))
    (eq_smul_div (-6) 22 (-3) (11) (by decide) (by decide))
    (eq_smul_div (-3) 22 (-3) (22) (by decide) (by decide))
    (eq_smul_div (-6) 22 (-3) (11) (by decide) (by decide))
    (eq_smul_div (-3) 22 (-3) (22) (by decide) (by decide))
    (eq_smul_zero 22)
    (eq_smul_div (-3) 22 (-3) (22) (by decide) (by decide))
    (eq_smul_div (-3) 22 (-3) (22) (by decide) (by decide))
    (eq_smul_div (-3) 22 (-3) (22) (by decide) (by decide))
    (eq_smul_div (-3) 22 (-3) (22) (by decide) (by decide))

public def ACell17_1 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => 0
  | 1 => (3 / 22 : ℚ)
  | 2 => (3 / 22 : ℚ)
  | 3 => 0
  | 4 => 0
  | 5 => (-3 / 22 : ℚ)
  | 6 => 0
  | 7 => 0
  | 8 => 0
  | 9 => (-3 / 22 : ℚ)
  | _ => 0

public theorem ACell17_1_def : ACell17_1 = ![0, (3 / 22 : ℚ), (3 / 22 : ℚ), 0, 0, (-3 / 22 : ℚ), 0, 0, 0, (-3 / 22 : ℚ)] := by
  funext i
  fin_cases i <;> rfl

public theorem ACell17_1_scaled :
    toVec #v[0, 3, 3, 0, 0, -3, 0, 0, 0, -3] = ((22 : ℤ) : ℚ) • ACell17_1 :=
  toVec_eq_smul10 #v[0, 3, 3, 0, 0, -3, 0, 0, 0, -3] 22 ACell17_1
    (eq_smul_zero 22)
    (eq_smul_div (3) 22 (3) (22) (by decide) (by decide))
    (eq_smul_div (3) 22 (3) (22) (by decide) (by decide))
    (eq_smul_zero 22)
    (eq_smul_zero 22)
    (eq_smul_div (-3) 22 (-3) (22) (by decide) (by decide))
    (eq_smul_zero 22)
    (eq_smul_zero 22)
    (eq_smul_zero 22)
    (eq_smul_div (-3) 22 (-3) (22) (by decide) (by decide))

public def ACell17_2 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (-3 / 11 : ℚ)
  | 1 => (-3 / 22 : ℚ)
  | 2 => (-3 / 22 : ℚ)
  | 3 => (-3 / 22 : ℚ)
  | 4 => (-3 / 22 : ℚ)
  | 5 => (-3 / 11 : ℚ)
  | 6 => 0
  | 7 => (-3 / 22 : ℚ)
  | 8 => (-3 / 22 : ℚ)
  | 9 => (-3 / 22 : ℚ)
  | _ => 0

public theorem ACell17_2_def : ACell17_2 = ![(-3 / 11 : ℚ), (-3 / 22 : ℚ), (-3 / 22 : ℚ), (-3 / 22 : ℚ), (-3 / 22 : ℚ), (-3 / 11 : ℚ), 0, (-3 / 22 : ℚ), (-3 / 22 : ℚ), (-3 / 22 : ℚ)] := by
  funext i
  fin_cases i <;> rfl

public theorem ACell17_2_scaled :
    toVec #v[-6, -3, -3, -3, -3, -6, 0, -3, -3, -3] = ((22 : ℤ) : ℚ) • ACell17_2 :=
  toVec_eq_smul10 #v[-6, -3, -3, -3, -3, -6, 0, -3, -3, -3] 22 ACell17_2
    (eq_smul_div (-6) 22 (-3) (11) (by decide) (by decide))
    (eq_smul_div (-3) 22 (-3) (22) (by decide) (by decide))
    (eq_smul_div (-3) 22 (-3) (22) (by decide) (by decide))
    (eq_smul_div (-3) 22 (-3) (22) (by decide) (by decide))
    (eq_smul_div (-3) 22 (-3) (22) (by decide) (by decide))
    (eq_smul_div (-6) 22 (-3) (11) (by decide) (by decide))
    (eq_smul_zero 22)
    (eq_smul_div (-3) 22 (-3) (22) (by decide) (by decide))
    (eq_smul_div (-3) 22 (-3) (22) (by decide) (by decide))
    (eq_smul_div (-3) 22 (-3) (22) (by decide) (by decide))

public def ACell17_3 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => 0
  | 1 => (-3 / 22 : ℚ)
  | 2 => 0
  | 3 => 0
  | 4 => (3 / 22 : ℚ)
  | 5 => 0
  | 6 => (3 / 22 : ℚ)
  | 7 => 0
  | 8 => 0
  | 9 => (-3 / 22 : ℚ)
  | _ => 0

public theorem ACell17_3_def : ACell17_3 = ![0, (-3 / 22 : ℚ), 0, 0, (3 / 22 : ℚ), 0, (3 / 22 : ℚ), 0, 0, (-3 / 22 : ℚ)] := by
  funext i
  fin_cases i <;> rfl

public theorem ACell17_3_scaled :
    toVec #v[0, -3, 0, 0, 3, 0, 3, 0, 0, -3] = ((22 : ℤ) : ℚ) • ACell17_3 :=
  toVec_eq_smul10 #v[0, -3, 0, 0, 3, 0, 3, 0, 0, -3] 22 ACell17_3
    (eq_smul_zero 22)
    (eq_smul_div (-3) 22 (-3) (22) (by decide) (by decide))
    (eq_smul_zero 22)
    (eq_smul_zero 22)
    (eq_smul_div (3) 22 (3) (22) (by decide) (by decide))
    (eq_smul_zero 22)
    (eq_smul_div (3) 22 (3) (22) (by decide) (by decide))
    (eq_smul_zero 22)
    (eq_smul_zero 22)
    (eq_smul_div (-3) 22 (-3) (22) (by decide) (by decide))

public def ACell17_4 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => 0
  | 1 => 0
  | 2 => (3 / 22 : ℚ)
  | 3 => (-3 / 22 : ℚ)
  | 4 => (-3 / 22 : ℚ)
  | 5 => (3 / 22 : ℚ)
  | 6 => 0
  | 7 => 0
  | 8 => 0
  | 9 => 0
  | _ => 0

public theorem ACell17_4_def : ACell17_4 = ![0, 0, (3 / 22 : ℚ), (-3 / 22 : ℚ), (-3 / 22 : ℚ), (3 / 22 : ℚ), 0, 0, 0, 0] := by
  funext i
  fin_cases i <;> rfl

public theorem ACell17_4_scaled :
    toVec #v[0, 0, 3, -3, -3, 3, 0, 0, 0, 0] = ((22 : ℤ) : ℚ) • ACell17_4 :=
  toVec_eq_smul10 #v[0, 0, 3, -3, -3, 3, 0, 0, 0, 0] 22 ACell17_4
    (eq_smul_zero 22)
    (eq_smul_zero 22)
    (eq_smul_div (3) 22 (3) (22) (by decide) (by decide))
    (eq_smul_div (-3) 22 (-3) (22) (by decide) (by decide))
    (eq_smul_div (-3) 22 (-3) (22) (by decide) (by decide))
    (eq_smul_div (3) 22 (3) (22) (by decide) (by decide))
    (eq_smul_zero 22)
    (eq_smul_zero 22)
    (eq_smul_zero 22)
    (eq_smul_zero 22)

public def ACell17_5 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (-1 / 11 : ℚ)
  | 1 => (-1 / 11 : ℚ)
  | 2 => 0
  | 3 => (1 / 11 : ℚ)
  | 4 => 0
  | 5 => (1 / 11 : ℚ)
  | 6 => (-2 / 11 : ℚ)
  | 7 => (1 / 11 : ℚ)
  | 8 => 0
  | 9 => (1 / 11 : ℚ)
  | _ => 0

public theorem ACell17_5_def : ACell17_5 = ![(-1 / 11 : ℚ), (-1 / 11 : ℚ), 0, (1 / 11 : ℚ), 0, (1 / 11 : ℚ), (-2 / 11 : ℚ), (1 / 11 : ℚ), 0, (1 / 11 : ℚ)] := by
  funext i
  fin_cases i <;> rfl

public theorem ACell17_5_scaled :
    toVec #v[-1, -1, 0, 1, 0, 1, -2, 1, 0, 1] = ((11 : ℤ) : ℚ) • ACell17_5 :=
  toVec_eq_smul10 #v[-1, -1, 0, 1, 0, 1, -2, 1, 0, 1] 11 ACell17_5
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))

public def ACell17_6 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (1 / 11 : ℚ)
  | 1 => (2 / 11 : ℚ)
  | 2 => 0
  | 3 => (3 / 11 : ℚ)
  | 4 => 0
  | 5 => (2 / 11 : ℚ)
  | 6 => (1 / 11 : ℚ)
  | 7 => 0
  | 8 => (1 / 11 : ℚ)
  | 9 => (1 / 11 : ℚ)
  | _ => 0

public theorem ACell17_6_def : ACell17_6 = ![(1 / 11 : ℚ), (2 / 11 : ℚ), 0, (3 / 11 : ℚ), 0, (2 / 11 : ℚ), (1 / 11 : ℚ), 0, (1 / 11 : ℚ), (1 / 11 : ℚ)] := by
  funext i
  fin_cases i <;> rfl

public theorem ACell17_6_scaled :
    toVec #v[1, 2, 0, 3, 0, 2, 1, 0, 1, 1] = ((11 : ℤ) : ℚ) • ACell17_6 :=
  toVec_eq_smul10 #v[1, 2, 0, 3, 0, 2, 1, 0, 1, 1] 11 ACell17_6
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_div (3) 11 (3) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))

public def ACell17_7 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (13 / 11 : ℚ)
  | 1 => 0
  | 2 => (-1 / 11 : ℚ)
  | 3 => (-1 / 11 : ℚ)
  | 4 => (1 / 11 : ℚ)
  | 5 => 0
  | 6 => 0
  | 7 => (1 / 11 : ℚ)
  | 8 => (-1 / 11 : ℚ)
  | 9 => (-1 / 11 : ℚ)
  | _ => 0

public theorem ACell17_7_def : ACell17_7 = ![(13 / 11 : ℚ), 0, (-1 / 11 : ℚ), (-1 / 11 : ℚ), (1 / 11 : ℚ), 0, 0, (1 / 11 : ℚ), (-1 / 11 : ℚ), (-1 / 11 : ℚ)] := by
  funext i
  fin_cases i <;> rfl

public theorem ACell17_7_scaled :
    toVec #v[13, 0, -1, -1, 1, 0, 0, 1, -1, -1] = ((11 : ℤ) : ℚ) • ACell17_7 :=
  toVec_eq_smul10 #v[13, 0, -1, -1, 1, 0, 0, 1, -1, -1] 11 ACell17_7
    (eq_smul_div (13) 11 (13) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_zero 11)
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))

public def ACell17_8 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (-2 / 11 : ℚ)
  | 1 => (-3 / 11 : ℚ)
  | 2 => (-2 / 11 : ℚ)
  | 3 => 0
  | 4 => (-1 / 11 : ℚ)
  | 5 => (-1 / 11 : ℚ)
  | 6 => 0
  | 7 => 0
  | 8 => (-1 / 11 : ℚ)
  | 9 => (-1 / 11 : ℚ)
  | _ => 0

public theorem ACell17_8_def : ACell17_8 = ![(-2 / 11 : ℚ), (-3 / 11 : ℚ), (-2 / 11 : ℚ), 0, (-1 / 11 : ℚ), (-1 / 11 : ℚ), 0, 0, (-1 / 11 : ℚ), (-1 / 11 : ℚ)] := by
  funext i
  fin_cases i <;> rfl

public theorem ACell17_8_scaled :
    toVec #v[-2, -3, -2, 0, -1, -1, 0, 0, -1, -1] = ((11 : ℤ) : ℚ) • ACell17_8 :=
  toVec_eq_smul10 #v[-2, -3, -2, 0, -1, -1, 0, 0, -1, -1] 11 ACell17_8
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))
    (eq_smul_div (-3) 11 (-3) (11) (by decide) (by decide))
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_zero 11)
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))

public def ACell17_9 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (-2 / 11 : ℚ)
  | 1 => (-2 / 11 : ℚ)
  | 2 => (-1 / 11 : ℚ)
  | 3 => (-3 / 11 : ℚ)
  | 4 => (-3 / 11 : ℚ)
  | 5 => (-3 / 11 : ℚ)
  | 6 => (-3 / 11 : ℚ)
  | 7 => (-1 / 11 : ℚ)
  | 8 => (-2 / 11 : ℚ)
  | 9 => (-2 / 11 : ℚ)
  | _ => 0

public theorem ACell17_9_def : ACell17_9 = ![(-2 / 11 : ℚ), (-2 / 11 : ℚ), (-1 / 11 : ℚ), (-3 / 11 : ℚ), (-3 / 11 : ℚ), (-3 / 11 : ℚ), (-3 / 11 : ℚ), (-1 / 11 : ℚ), (-2 / 11 : ℚ), (-2 / 11 : ℚ)] := by
  funext i
  fin_cases i <;> rfl

public theorem ACell17_9_scaled :
    toVec #v[-2, -2, -1, -3, -3, -3, -3, -1, -2, -2] = ((11 : ℤ) : ℚ) • ACell17_9 :=
  toVec_eq_smul10 #v[-2, -2, -1, -3, -3, -3, -3, -1, -2, -2] 11 ACell17_9
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_div (-3) 11 (-3) (11) (by decide) (by decide))
    (eq_smul_div (-3) 11 (-3) (11) (by decide) (by decide))
    (eq_smul_div (-3) 11 (-3) (11) (by decide) (by decide))
    (eq_smul_div (-3) 11 (-3) (11) (by decide) (by decide))
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))

public def ARow17 (j : Fin 10) : Vec :=
  match j.val with
  | 0 => ACell17_0
  | 1 => ACell17_1
  | 2 => ACell17_2
  | 3 => ACell17_3
  | 4 => ACell17_4
  | 5 => ACell17_5
  | 6 => ACell17_6
  | 7 => ACell17_7
  | 8 => ACell17_8
  | 9 => ACell17_9
  | _ => 0

public def ACell18_0 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (3 / 22 : ℚ)
  | 1 => (3 / 22 : ℚ)
  | 2 => (3 / 22 : ℚ)
  | 3 => 0
  | 4 => (3 / 11 : ℚ)
  | 5 => (3 / 22 : ℚ)
  | 6 => (3 / 22 : ℚ)
  | 7 => (3 / 22 : ℚ)
  | 8 => (3 / 22 : ℚ)
  | 9 => (3 / 11 : ℚ)
  | _ => 0

public theorem ACell18_0_def : ACell18_0 = ![(3 / 22 : ℚ), (3 / 22 : ℚ), (3 / 22 : ℚ), 0, (3 / 11 : ℚ), (3 / 22 : ℚ), (3 / 22 : ℚ), (3 / 22 : ℚ), (3 / 22 : ℚ), (3 / 11 : ℚ)] := by
  funext i
  fin_cases i <;> rfl

public theorem ACell18_0_scaled :
    toVec #v[3, 3, 3, 0, 6, 3, 3, 3, 3, 6] = ((22 : ℤ) : ℚ) • ACell18_0 :=
  toVec_eq_smul10 #v[3, 3, 3, 0, 6, 3, 3, 3, 3, 6] 22 ACell18_0
    (eq_smul_div (3) 22 (3) (22) (by decide) (by decide))
    (eq_smul_div (3) 22 (3) (22) (by decide) (by decide))
    (eq_smul_div (3) 22 (3) (22) (by decide) (by decide))
    (eq_smul_zero 22)
    (eq_smul_div (6) 22 (3) (11) (by decide) (by decide))
    (eq_smul_div (3) 22 (3) (22) (by decide) (by decide))
    (eq_smul_div (3) 22 (3) (22) (by decide) (by decide))
    (eq_smul_div (3) 22 (3) (22) (by decide) (by decide))
    (eq_smul_div (3) 22 (3) (22) (by decide) (by decide))
    (eq_smul_div (6) 22 (3) (11) (by decide) (by decide))

public def ACell18_1 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (3 / 11 : ℚ)
  | 1 => (3 / 11 : ℚ)
  | 2 => 0
  | 3 => (3 / 22 : ℚ)
  | 4 => (3 / 22 : ℚ)
  | 5 => (3 / 22 : ℚ)
  | 6 => (3 / 22 : ℚ)
  | 7 => (3 / 22 : ℚ)
  | 8 => (3 / 22 : ℚ)
  | 9 => (3 / 22 : ℚ)
  | _ => 0

public theorem ACell18_1_def : ACell18_1 = ![(3 / 11 : ℚ), (3 / 11 : ℚ), 0, (3 / 22 : ℚ), (3 / 22 : ℚ), (3 / 22 : ℚ), (3 / 22 : ℚ), (3 / 22 : ℚ), (3 / 22 : ℚ), (3 / 22 : ℚ)] := by
  funext i
  fin_cases i <;> rfl

public theorem ACell18_1_scaled :
    toVec #v[6, 6, 0, 3, 3, 3, 3, 3, 3, 3] = ((22 : ℤ) : ℚ) • ACell18_1 :=
  toVec_eq_smul10 #v[6, 6, 0, 3, 3, 3, 3, 3, 3, 3] 22 ACell18_1
    (eq_smul_div (6) 22 (3) (11) (by decide) (by decide))
    (eq_smul_div (6) 22 (3) (11) (by decide) (by decide))
    (eq_smul_zero 22)
    (eq_smul_div (3) 22 (3) (22) (by decide) (by decide))
    (eq_smul_div (3) 22 (3) (22) (by decide) (by decide))
    (eq_smul_div (3) 22 (3) (22) (by decide) (by decide))
    (eq_smul_div (3) 22 (3) (22) (by decide) (by decide))
    (eq_smul_div (3) 22 (3) (22) (by decide) (by decide))
    (eq_smul_div (3) 22 (3) (22) (by decide) (by decide))
    (eq_smul_div (3) 22 (3) (22) (by decide) (by decide))

public def ACell18_2 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => 0
  | 1 => (-3 / 22 : ℚ)
  | 2 => (-3 / 22 : ℚ)
  | 3 => 0
  | 4 => 0
  | 5 => (3 / 22 : ℚ)
  | 6 => 0
  | 7 => 0
  | 8 => 0
  | 9 => (3 / 22 : ℚ)
  | _ => 0

public theorem ACell18_2_def : ACell18_2 = ![0, (-3 / 22 : ℚ), (-3 / 22 : ℚ), 0, 0, (3 / 22 : ℚ), 0, 0, 0, (3 / 22 : ℚ)] := by
  funext i
  fin_cases i <;> rfl

public theorem ACell18_2_scaled :
    toVec #v[0, -3, -3, 0, 0, 3, 0, 0, 0, 3] = ((22 : ℤ) : ℚ) • ACell18_2 :=
  toVec_eq_smul10 #v[0, -3, -3, 0, 0, 3, 0, 0, 0, 3] 22 ACell18_2
    (eq_smul_zero 22)
    (eq_smul_div (-3) 22 (-3) (22) (by decide) (by decide))
    (eq_smul_div (-3) 22 (-3) (22) (by decide) (by decide))
    (eq_smul_zero 22)
    (eq_smul_zero 22)
    (eq_smul_div (3) 22 (3) (22) (by decide) (by decide))
    (eq_smul_zero 22)
    (eq_smul_zero 22)
    (eq_smul_zero 22)
    (eq_smul_div (3) 22 (3) (22) (by decide) (by decide))

public def ACell18_3 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => 0
  | 1 => (-3 / 22 : ℚ)
  | 2 => 0
  | 3 => (3 / 22 : ℚ)
  | 4 => 0
  | 5 => (3 / 22 : ℚ)
  | 6 => 0
  | 7 => (-3 / 22 : ℚ)
  | 8 => 0
  | 9 => 0
  | _ => 0

public theorem ACell18_3_def : ACell18_3 = ![0, (-3 / 22 : ℚ), 0, (3 / 22 : ℚ), 0, (3 / 22 : ℚ), 0, (-3 / 22 : ℚ), 0, 0] := by
  funext i
  fin_cases i <;> rfl

public theorem ACell18_3_scaled :
    toVec #v[0, -3, 0, 3, 0, 3, 0, -3, 0, 0] = ((22 : ℤ) : ℚ) • ACell18_3 :=
  toVec_eq_smul10 #v[0, -3, 0, 3, 0, 3, 0, -3, 0, 0] 22 ACell18_3
    (eq_smul_zero 22)
    (eq_smul_div (-3) 22 (-3) (22) (by decide) (by decide))
    (eq_smul_zero 22)
    (eq_smul_div (3) 22 (3) (22) (by decide) (by decide))
    (eq_smul_zero 22)
    (eq_smul_div (3) 22 (3) (22) (by decide) (by decide))
    (eq_smul_zero 22)
    (eq_smul_div (-3) 22 (-3) (22) (by decide) (by decide))
    (eq_smul_zero 22)
    (eq_smul_zero 22)

public def ACell18_4 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => 0
  | 1 => (3 / 22 : ℚ)
  | 2 => 0
  | 3 => 0
  | 4 => (3 / 22 : ℚ)
  | 5 => 0
  | 6 => 0
  | 7 => (-3 / 22 : ℚ)
  | 8 => 0
  | 9 => (-3 / 22 : ℚ)
  | _ => 0

public theorem ACell18_4_def : ACell18_4 = ![0, (3 / 22 : ℚ), 0, 0, (3 / 22 : ℚ), 0, 0, (-3 / 22 : ℚ), 0, (-3 / 22 : ℚ)] := by
  funext i
  fin_cases i <;> rfl

public theorem ACell18_4_scaled :
    toVec #v[0, 3, 0, 0, 3, 0, 0, -3, 0, -3] = ((22 : ℤ) : ℚ) • ACell18_4 :=
  toVec_eq_smul10 #v[0, 3, 0, 0, 3, 0, 0, -3, 0, -3] 22 ACell18_4
    (eq_smul_zero 22)
    (eq_smul_div (3) 22 (3) (22) (by decide) (by decide))
    (eq_smul_zero 22)
    (eq_smul_zero 22)
    (eq_smul_div (3) 22 (3) (22) (by decide) (by decide))
    (eq_smul_zero 22)
    (eq_smul_zero 22)
    (eq_smul_div (-3) 22 (-3) (22) (by decide) (by decide))
    (eq_smul_zero 22)
    (eq_smul_div (-3) 22 (-3) (22) (by decide) (by decide))

public def ACell18_5 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => 0
  | 1 => (1 / 11 : ℚ)
  | 2 => (-1 / 11 : ℚ)
  | 3 => (-1 / 11 : ℚ)
  | 4 => 0
  | 5 => (2 / 11 : ℚ)
  | 6 => 0
  | 7 => (-1 / 11 : ℚ)
  | 8 => (-1 / 11 : ℚ)
  | 9 => (1 / 11 : ℚ)
  | _ => 0

public theorem ACell18_5_def : ACell18_5 = ![0, (1 / 11 : ℚ), (-1 / 11 : ℚ), (-1 / 11 : ℚ), 0, (2 / 11 : ℚ), 0, (-1 / 11 : ℚ), (-1 / 11 : ℚ), (1 / 11 : ℚ)] := by
  funext i
  fin_cases i <;> rfl

public theorem ACell18_5_scaled :
    toVec #v[0, 1, -1, -1, 0, 2, 0, -1, -1, 1] = ((11 : ℤ) : ℚ) • ACell18_5 :=
  toVec_eq_smul10 #v[0, 1, -1, -1, 0, 2, 0, -1, -1, 1] 11 ACell18_5
    (eq_smul_zero 11)
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))

public def ACell18_6 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (-1 / 11 : ℚ)
  | 1 => 0
  | 2 => (-3 / 11 : ℚ)
  | 3 => 0
  | 4 => (-1 / 11 : ℚ)
  | 5 => 0
  | 6 => (-1 / 11 : ℚ)
  | 7 => (-2 / 11 : ℚ)
  | 8 => (-2 / 11 : ℚ)
  | 9 => (-1 / 11 : ℚ)
  | _ => 0

public theorem ACell18_6_def : ACell18_6 = ![(-1 / 11 : ℚ), 0, (-3 / 11 : ℚ), 0, (-1 / 11 : ℚ), 0, (-1 / 11 : ℚ), (-2 / 11 : ℚ), (-2 / 11 : ℚ), (-1 / 11 : ℚ)] := by
  funext i
  fin_cases i <;> rfl

public theorem ACell18_6_scaled :
    toVec #v[-1, 0, -3, 0, -1, 0, -1, -2, -2, -1] = ((11 : ℤ) : ℚ) • ACell18_6 :=
  toVec_eq_smul10 #v[-1, 0, -3, 0, -1, 0, -1, -2, -2, -1] 11 ACell18_6
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_div (-3) 11 (-3) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))

public def ACell18_7 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (1 / 11 : ℚ)
  | 1 => (3 / 11 : ℚ)
  | 2 => (2 / 11 : ℚ)
  | 3 => (2 / 11 : ℚ)
  | 4 => (3 / 11 : ℚ)
  | 5 => (3 / 11 : ℚ)
  | 6 => (2 / 11 : ℚ)
  | 7 => (2 / 11 : ℚ)
  | 8 => (3 / 11 : ℚ)
  | 9 => (1 / 11 : ℚ)
  | _ => 0

public theorem ACell18_7_def : ACell18_7 = ![(1 / 11 : ℚ), (3 / 11 : ℚ), (2 / 11 : ℚ), (2 / 11 : ℚ), (3 / 11 : ℚ), (3 / 11 : ℚ), (2 / 11 : ℚ), (2 / 11 : ℚ), (3 / 11 : ℚ), (1 / 11 : ℚ)] := by
  funext i
  fin_cases i <;> rfl

public theorem ACell18_7_scaled :
    toVec #v[1, 3, 2, 2, 3, 3, 2, 2, 3, 1] = ((11 : ℤ) : ℚ) • ACell18_7 :=
  toVec_eq_smul10 #v[1, 3, 2, 2, 3, 3, 2, 2, 3, 1] 11 ACell18_7
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))
    (eq_smul_div (3) 11 (3) (11) (by decide) (by decide))
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_div (3) 11 (3) (11) (by decide) (by decide))
    (eq_smul_div (3) 11 (3) (11) (by decide) (by decide))
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_div (3) 11 (3) (11) (by decide) (by decide))
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))

public def ACell18_8 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (13 / 11 : ℚ)
  | 1 => 0
  | 2 => 0
  | 3 => (1 / 11 : ℚ)
  | 4 => (-1 / 11 : ℚ)
  | 5 => (-1 / 11 : ℚ)
  | 6 => (-1 / 11 : ℚ)
  | 7 => (-1 / 11 : ℚ)
  | 8 => (1 / 11 : ℚ)
  | 9 => 0
  | _ => 0

public theorem ACell18_8_def : ACell18_8 = ![(13 / 11 : ℚ), 0, 0, (1 / 11 : ℚ), (-1 / 11 : ℚ), (-1 / 11 : ℚ), (-1 / 11 : ℚ), (-1 / 11 : ℚ), (1 / 11 : ℚ), 0] := by
  funext i
  fin_cases i <;> rfl

public theorem ACell18_8_scaled :
    toVec #v[13, 0, 0, 1, -1, -1, -1, -1, 1, 0] = ((11 : ℤ) : ℚ) • ACell18_8 :=
  toVec_eq_smul10 #v[13, 0, 0, 1, -1, -1, -1, -1, 1, 0] 11 ACell18_8
    (eq_smul_div (13) 11 (13) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_zero 11)
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))
    (eq_smul_zero 11)

public def ACell18_9 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (-2 / 11 : ℚ)
  | 1 => (-1 / 11 : ℚ)
  | 2 => 0
  | 3 => (-1 / 11 : ℚ)
  | 4 => (-1 / 11 : ℚ)
  | 5 => 0
  | 6 => (-1 / 11 : ℚ)
  | 7 => (-2 / 11 : ℚ)
  | 8 => 0
  | 9 => (-3 / 11 : ℚ)
  | _ => 0

public theorem ACell18_9_def : ACell18_9 = ![(-2 / 11 : ℚ), (-1 / 11 : ℚ), 0, (-1 / 11 : ℚ), (-1 / 11 : ℚ), 0, (-1 / 11 : ℚ), (-2 / 11 : ℚ), 0, (-3 / 11 : ℚ)] := by
  funext i
  fin_cases i <;> rfl

public theorem ACell18_9_scaled :
    toVec #v[-2, -1, 0, -1, -1, 0, -1, -2, 0, -3] = ((11 : ℤ) : ℚ) • ACell18_9 :=
  toVec_eq_smul10 #v[-2, -1, 0, -1, -1, 0, -1, -2, 0, -3] 11 ACell18_9
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_div (-3) 11 (-3) (11) (by decide) (by decide))

public def ARow18 (j : Fin 10) : Vec :=
  match j.val with
  | 0 => ACell18_0
  | 1 => ACell18_1
  | 2 => ACell18_2
  | 3 => ACell18_3
  | 4 => ACell18_4
  | 5 => ACell18_5
  | 6 => ACell18_6
  | 7 => ACell18_7
  | 8 => ACell18_8
  | 9 => ACell18_9
  | _ => 0

public def ACell19_0 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => 0
  | 1 => (-3 / 22 : ℚ)
  | 2 => 0
  | 3 => 0
  | 4 => 0
  | 5 => (-3 / 22 : ℚ)
  | 6 => 0
  | 7 => 0
  | 8 => (3 / 22 : ℚ)
  | 9 => (3 / 22 : ℚ)
  | _ => 0

public theorem ACell19_0_def : ACell19_0 = ![0, (-3 / 22 : ℚ), 0, 0, 0, (-3 / 22 : ℚ), 0, 0, (3 / 22 : ℚ), (3 / 22 : ℚ)] := by
  funext i
  fin_cases i <;> rfl

public theorem ACell19_0_scaled :
    toVec #v[0, -3, 0, 0, 0, -3, 0, 0, 3, 3] = ((22 : ℤ) : ℚ) • ACell19_0 :=
  toVec_eq_smul10 #v[0, -3, 0, 0, 0, -3, 0, 0, 3, 3] 22 ACell19_0
    (eq_smul_zero 22)
    (eq_smul_div (-3) 22 (-3) (22) (by decide) (by decide))
    (eq_smul_zero 22)
    (eq_smul_zero 22)
    (eq_smul_zero 22)
    (eq_smul_div (-3) 22 (-3) (22) (by decide) (by decide))
    (eq_smul_zero 22)
    (eq_smul_zero 22)
    (eq_smul_div (3) 22 (3) (22) (by decide) (by decide))
    (eq_smul_div (3) 22 (3) (22) (by decide) (by decide))

public def ACell19_1 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => 0
  | 1 => (-3 / 22 : ℚ)
  | 2 => 0
  | 3 => 0
  | 4 => (-3 / 22 : ℚ)
  | 5 => 0
  | 6 => 0
  | 7 => (3 / 22 : ℚ)
  | 8 => 0
  | 9 => (3 / 22 : ℚ)
  | _ => 0

public theorem ACell19_1_def : ACell19_1 = ![0, (-3 / 22 : ℚ), 0, 0, (-3 / 22 : ℚ), 0, 0, (3 / 22 : ℚ), 0, (3 / 22 : ℚ)] := by
  funext i
  fin_cases i <;> rfl

public theorem ACell19_1_scaled :
    toVec #v[0, -3, 0, 0, -3, 0, 0, 3, 0, 3] = ((22 : ℤ) : ℚ) • ACell19_1 :=
  toVec_eq_smul10 #v[0, -3, 0, 0, -3, 0, 0, 3, 0, 3] 22 ACell19_1
    (eq_smul_zero 22)
    (eq_smul_div (-3) 22 (-3) (22) (by decide) (by decide))
    (eq_smul_zero 22)
    (eq_smul_zero 22)
    (eq_smul_div (-3) 22 (-3) (22) (by decide) (by decide))
    (eq_smul_zero 22)
    (eq_smul_zero 22)
    (eq_smul_div (3) 22 (3) (22) (by decide) (by decide))
    (eq_smul_zero 22)
    (eq_smul_div (3) 22 (3) (22) (by decide) (by decide))

public def ACell19_2 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => 0
  | 1 => 0
  | 2 => (3 / 22 : ℚ)
  | 3 => (-3 / 22 : ℚ)
  | 4 => (-3 / 22 : ℚ)
  | 5 => (3 / 22 : ℚ)
  | 6 => 0
  | 7 => 0
  | 8 => 0
  | 9 => 0
  | _ => 0

public theorem ACell19_2_def : ACell19_2 = ![0, 0, (3 / 22 : ℚ), (-3 / 22 : ℚ), (-3 / 22 : ℚ), (3 / 22 : ℚ), 0, 0, 0, 0] := by
  funext i
  fin_cases i <;> rfl

public theorem ACell19_2_scaled :
    toVec #v[0, 0, 3, -3, -3, 3, 0, 0, 0, 0] = ((22 : ℤ) : ℚ) • ACell19_2 :=
  toVec_eq_smul10 #v[0, 0, 3, -3, -3, 3, 0, 0, 0, 0] 22 ACell19_2
    (eq_smul_zero 22)
    (eq_smul_zero 22)
    (eq_smul_div (3) 22 (3) (22) (by decide) (by decide))
    (eq_smul_div (-3) 22 (-3) (22) (by decide) (by decide))
    (eq_smul_div (-3) 22 (-3) (22) (by decide) (by decide))
    (eq_smul_div (3) 22 (3) (22) (by decide) (by decide))
    (eq_smul_zero 22)
    (eq_smul_zero 22)
    (eq_smul_zero 22)
    (eq_smul_zero 22)

public def ACell19_3 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => 0
  | 1 => 0
  | 2 => 0
  | 3 => (-3 / 22 : ℚ)
  | 4 => (3 / 22 : ℚ)
  | 5 => 0
  | 6 => 0
  | 7 => 0
  | 8 => (3 / 22 : ℚ)
  | 9 => (-3 / 22 : ℚ)
  | _ => 0

public theorem ACell19_3_def : ACell19_3 = ![0, 0, 0, (-3 / 22 : ℚ), (3 / 22 : ℚ), 0, 0, 0, (3 / 22 : ℚ), (-3 / 22 : ℚ)] := by
  funext i
  fin_cases i <;> rfl

public theorem ACell19_3_scaled :
    toVec #v[0, 0, 0, -3, 3, 0, 0, 0, 3, -3] = ((22 : ℤ) : ℚ) • ACell19_3 :=
  toVec_eq_smul10 #v[0, 0, 0, -3, 3, 0, 0, 0, 3, -3] 22 ACell19_3
    (eq_smul_zero 22)
    (eq_smul_zero 22)
    (eq_smul_zero 22)
    (eq_smul_div (-3) 22 (-3) (22) (by decide) (by decide))
    (eq_smul_div (3) 22 (3) (22) (by decide) (by decide))
    (eq_smul_zero 22)
    (eq_smul_zero 22)
    (eq_smul_zero 22)
    (eq_smul_div (3) 22 (3) (22) (by decide) (by decide))
    (eq_smul_div (-3) 22 (-3) (22) (by decide) (by decide))

public def ACell19_4 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (-3 / 22 : ℚ)
  | 1 => 0
  | 2 => (3 / 22 : ℚ)
  | 3 => 0
  | 4 => 0
  | 5 => 0
  | 6 => 0
  | 7 => (3 / 22 : ℚ)
  | 8 => 0
  | 9 => (-3 / 22 : ℚ)
  | _ => 0

public theorem ACell19_4_def : ACell19_4 = ![(-3 / 22 : ℚ), 0, (3 / 22 : ℚ), 0, 0, 0, 0, (3 / 22 : ℚ), 0, (-3 / 22 : ℚ)] := by
  funext i
  fin_cases i <;> rfl

public theorem ACell19_4_scaled :
    toVec #v[-3, 0, 3, 0, 0, 0, 0, 3, 0, -3] = ((22 : ℤ) : ℚ) • ACell19_4 :=
  toVec_eq_smul10 #v[-3, 0, 3, 0, 0, 0, 0, 3, 0, -3] 22 ACell19_4
    (eq_smul_div (-3) 22 (-3) (22) (by decide) (by decide))
    (eq_smul_zero 22)
    (eq_smul_div (3) 22 (3) (22) (by decide) (by decide))
    (eq_smul_zero 22)
    (eq_smul_zero 22)
    (eq_smul_zero 22)
    (eq_smul_zero 22)
    (eq_smul_div (3) 22 (3) (22) (by decide) (by decide))
    (eq_smul_zero 22)
    (eq_smul_div (-3) 22 (-3) (22) (by decide) (by decide))

public def ACell19_5 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => 0
  | 1 => (1 / 11 : ℚ)
  | 2 => (1 / 11 : ℚ)
  | 3 => 0
  | 4 => 0
  | 5 => (1 / 11 : ℚ)
  | 6 => (-1 / 11 : ℚ)
  | 7 => (-2 / 11 : ℚ)
  | 8 => (-1 / 11 : ℚ)
  | 9 => (1 / 11 : ℚ)
  | _ => 0

public theorem ACell19_5_def : ACell19_5 = ![0, (1 / 11 : ℚ), (1 / 11 : ℚ), 0, 0, (1 / 11 : ℚ), (-1 / 11 : ℚ), (-2 / 11 : ℚ), (-1 / 11 : ℚ), (1 / 11 : ℚ)] := by
  funext i
  fin_cases i <;> rfl

public theorem ACell19_5_scaled :
    toVec #v[0, 1, 1, 0, 0, 1, -1, -2, -1, 1] = ((11 : ℤ) : ℚ) • ACell19_5 :=
  toVec_eq_smul10 #v[0, 1, 1, 0, 0, 1, -1, -2, -1, 1] 11 ACell19_5
    (eq_smul_zero 11)
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_zero 11)
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))

public def ACell19_6 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (1 / 11 : ℚ)
  | 1 => (-1 / 11 : ℚ)
  | 2 => (-1 / 11 : ℚ)
  | 3 => 0
  | 4 => (2 / 11 : ℚ)
  | 5 => 0
  | 6 => (-1 / 11 : ℚ)
  | 7 => (-1 / 11 : ℚ)
  | 8 => (1 / 11 : ℚ)
  | 9 => 0
  | _ => 0

public theorem ACell19_6_def : ACell19_6 = ![(1 / 11 : ℚ), (-1 / 11 : ℚ), (-1 / 11 : ℚ), 0, (2 / 11 : ℚ), 0, (-1 / 11 : ℚ), (-1 / 11 : ℚ), (1 / 11 : ℚ), 0] := by
  funext i
  fin_cases i <;> rfl

public theorem ACell19_6_scaled :
    toVec #v[1, -1, -1, 0, 2, 0, -1, -1, 1, 0] = ((11 : ℤ) : ℚ) • ACell19_6 :=
  toVec_eq_smul10 #v[1, -1, -1, 0, 2, 0, -1, -1, 1, 0] 11 ACell19_6
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))
    (eq_smul_zero 11)

public def ACell19_7 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => 0
  | 1 => (2 / 11 : ℚ)
  | 2 => 0
  | 3 => 0
  | 4 => (1 / 11 : ℚ)
  | 5 => (-1 / 11 : ℚ)
  | 6 => (-1 / 11 : ℚ)
  | 7 => (-1 / 11 : ℚ)
  | 8 => (-1 / 11 : ℚ)
  | 9 => (1 / 11 : ℚ)
  | _ => 0

public theorem ACell19_7_def : ACell19_7 = ![0, (2 / 11 : ℚ), 0, 0, (1 / 11 : ℚ), (-1 / 11 : ℚ), (-1 / 11 : ℚ), (-1 / 11 : ℚ), (-1 / 11 : ℚ), (1 / 11 : ℚ)] := by
  funext i
  fin_cases i <;> rfl

public theorem ACell19_7_scaled :
    toVec #v[0, 2, 0, 0, 1, -1, -1, -1, -1, 1] = ((11 : ℤ) : ℚ) • ACell19_7 :=
  toVec_eq_smul10 #v[0, 2, 0, 0, 1, -1, -1, -1, -1, 1] 11 ACell19_7
    (eq_smul_zero 11)
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_zero 11)
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))

public def ACell19_8 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (-1 / 11 : ℚ)
  | 1 => (1 / 11 : ℚ)
  | 2 => (-2 / 11 : ℚ)
  | 3 => (1 / 11 : ℚ)
  | 4 => (-1 / 11 : ℚ)
  | 5 => 0
  | 6 => (1 / 11 : ℚ)
  | 7 => 0
  | 8 => 0
  | 9 => (1 / 11 : ℚ)
  | _ => 0

public theorem ACell19_8_def : ACell19_8 = ![(-1 / 11 : ℚ), (1 / 11 : ℚ), (-2 / 11 : ℚ), (1 / 11 : ℚ), (-1 / 11 : ℚ), 0, (1 / 11 : ℚ), 0, 0, (1 / 11 : ℚ)] := by
  funext i
  fin_cases i <;> rfl

public theorem ACell19_8_scaled :
    toVec #v[-1, 1, -2, 1, -1, 0, 1, 0, 0, 1] = ((11 : ℤ) : ℚ) • ACell19_8 :=
  toVec_eq_smul10 #v[-1, 1, -2, 1, -1, 0, 1, 0, 0, 1] 11 ACell19_8
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))
    (eq_smul_div (-2) 11 (-2) (11) (by decide) (by decide))
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))
    (eq_smul_div (-1) 11 (-1) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_zero 11)
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))

public def ACell19_9 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (14 / 11 : ℚ)
  | 1 => 0
  | 2 => (1 / 11 : ℚ)
  | 3 => 0
  | 4 => (1 / 11 : ℚ)
  | 5 => (2 / 11 : ℚ)
  | 6 => (2 / 11 : ℚ)
  | 7 => (1 / 11 : ℚ)
  | 8 => 0
  | 9 => (1 / 11 : ℚ)
  | _ => 0

public theorem ACell19_9_def : ACell19_9 = ![(14 / 11 : ℚ), 0, (1 / 11 : ℚ), 0, (1 / 11 : ℚ), (2 / 11 : ℚ), (2 / 11 : ℚ), (1 / 11 : ℚ), 0, (1 / 11 : ℚ)] := by
  funext i
  fin_cases i <;> rfl

public theorem ACell19_9_scaled :
    toVec #v[14, 0, 1, 0, 1, 2, 2, 1, 0, 1] = ((11 : ℤ) : ℚ) • ACell19_9 :=
  toVec_eq_smul10 #v[14, 0, 1, 0, 1, 2, 2, 1, 0, 1] 11 ACell19_9
    (eq_smul_div (14) 11 (14) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_div (2) 11 (2) (11) (by decide) (by decide))
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))
    (eq_smul_zero 11)
    (eq_smul_div (1) 11 (1) (11) (by decide) (by decide))

public def ARow19 (j : Fin 10) : Vec :=
  match j.val with
  | 0 => ACell19_0
  | 1 => ACell19_1
  | 2 => ACell19_2
  | 3 => ACell19_3
  | 4 => ACell19_4
  | 5 => ACell19_5
  | 6 => ACell19_6
  | 7 => ACell19_7
  | 8 => ACell19_8
  | 9 => ACell19_9
  | _ => 0

public def XVec : Matrix (Fin 10) (Fin 20) Vec :=
  fun i j => match i.val with
  | 0 => XRow0 j
  | 1 => XRow1 j
  | 2 => XRow2 j
  | 3 => XRow3 j
  | 4 => XRow4 j
  | 5 => XRow5 j
  | 6 => XRow6 j
  | 7 => XRow7 j
  | 8 => XRow8 j
  | 9 => XRow9 j
  | _ => 0

public def AVec : Matrix (Fin 20) (Fin 10) Vec :=
  fun i j => match i.val with
  | 0 => ARow0 j
  | 1 => ARow1 j
  | 2 => ARow2 j
  | 3 => ARow3 j
  | 4 => ARow4 j
  | 5 => ARow5 j
  | 6 => ARow6 j
  | 7 => ARow7 j
  | 8 => ARow8 j
  | 9 => ARow9 j
  | 10 => ARow10 j
  | 11 => ARow11 j
  | 12 => ARow12 j
  | 13 => ARow13 j
  | 14 => ARow14 j
  | 15 => ARow15 j
  | 16 => ARow16 j
  | 17 => ARow17 j
  | 18 => ARow18 j
  | 19 => ARow19 j
  | _ => 0

public theorem XVec_apply_0_0 :
    XVec (0 : Fin 10) (0 : Fin 20) = XCell0_0 := by
  rfl

public theorem XVec_apply_0_1 :
    XVec (0 : Fin 10) (1 : Fin 20) = XCell0_1 := by
  rfl

public theorem XVec_apply_0_2 :
    XVec (0 : Fin 10) (2 : Fin 20) = XCell0_2 := by
  rfl

public theorem XVec_apply_0_3 :
    XVec (0 : Fin 10) (3 : Fin 20) = XCell0_3 := by
  rfl

public theorem XVec_apply_0_4 :
    XVec (0 : Fin 10) (4 : Fin 20) = XCell0_4 := by
  rfl

public theorem XVec_apply_0_5 :
    XVec (0 : Fin 10) (5 : Fin 20) = XCell0_5 := by
  rfl

public theorem XVec_apply_0_6 :
    XVec (0 : Fin 10) (6 : Fin 20) = XCell0_6 := by
  rfl

public theorem XVec_apply_0_7 :
    XVec (0 : Fin 10) (7 : Fin 20) = XCell0_7 := by
  rfl

public theorem XVec_apply_0_8 :
    XVec (0 : Fin 10) (8 : Fin 20) = XCell0_8 := by
  rfl

public theorem XVec_apply_0_9 :
    XVec (0 : Fin 10) (9 : Fin 20) = XCell0_9 := by
  rfl

public theorem XVec_apply_0_10 :
    XVec (0 : Fin 10) (10 : Fin 20) = XCell0_10 := by
  rfl

public theorem XVec_apply_0_11 :
    XVec (0 : Fin 10) (11 : Fin 20) = XCell0_11 := by
  rfl

public theorem XVec_apply_0_12 :
    XVec (0 : Fin 10) (12 : Fin 20) = XCell0_12 := by
  rfl

public theorem XVec_apply_0_13 :
    XVec (0 : Fin 10) (13 : Fin 20) = XCell0_13 := by
  rfl

public theorem XVec_apply_0_14 :
    XVec (0 : Fin 10) (14 : Fin 20) = XCell0_14 := by
  rfl

public theorem XVec_apply_0_15 :
    XVec (0 : Fin 10) (15 : Fin 20) = XCell0_15 := by
  rfl

public theorem XVec_apply_0_16 :
    XVec (0 : Fin 10) (16 : Fin 20) = XCell0_16 := by
  rfl

public theorem XVec_apply_0_17 :
    XVec (0 : Fin 10) (17 : Fin 20) = XCell0_17 := by
  rfl

public theorem XVec_apply_0_18 :
    XVec (0 : Fin 10) (18 : Fin 20) = XCell0_18 := by
  rfl

public theorem XVec_apply_0_19 :
    XVec (0 : Fin 10) (19 : Fin 20) = XCell0_19 := by
  rfl

public theorem XVec_apply_1_0 :
    XVec (1 : Fin 10) (0 : Fin 20) = XCell1_0 := by
  rfl

public theorem XVec_apply_1_1 :
    XVec (1 : Fin 10) (1 : Fin 20) = XCell1_1 := by
  rfl

public theorem XVec_apply_1_2 :
    XVec (1 : Fin 10) (2 : Fin 20) = XCell1_2 := by
  rfl

public theorem XVec_apply_1_3 :
    XVec (1 : Fin 10) (3 : Fin 20) = XCell1_3 := by
  rfl

public theorem XVec_apply_1_4 :
    XVec (1 : Fin 10) (4 : Fin 20) = XCell1_4 := by
  rfl

public theorem XVec_apply_1_5 :
    XVec (1 : Fin 10) (5 : Fin 20) = XCell1_5 := by
  rfl

public theorem XVec_apply_1_6 :
    XVec (1 : Fin 10) (6 : Fin 20) = XCell1_6 := by
  rfl

public theorem XVec_apply_1_7 :
    XVec (1 : Fin 10) (7 : Fin 20) = XCell1_7 := by
  rfl

public theorem XVec_apply_1_8 :
    XVec (1 : Fin 10) (8 : Fin 20) = XCell1_8 := by
  rfl

public theorem XVec_apply_1_9 :
    XVec (1 : Fin 10) (9 : Fin 20) = XCell1_9 := by
  rfl

public theorem XVec_apply_1_10 :
    XVec (1 : Fin 10) (10 : Fin 20) = XCell1_10 := by
  rfl

public theorem XVec_apply_1_11 :
    XVec (1 : Fin 10) (11 : Fin 20) = XCell1_11 := by
  rfl

public theorem XVec_apply_1_12 :
    XVec (1 : Fin 10) (12 : Fin 20) = XCell1_12 := by
  rfl

public theorem XVec_apply_1_13 :
    XVec (1 : Fin 10) (13 : Fin 20) = XCell1_13 := by
  rfl

public theorem XVec_apply_1_14 :
    XVec (1 : Fin 10) (14 : Fin 20) = XCell1_14 := by
  rfl

public theorem XVec_apply_1_15 :
    XVec (1 : Fin 10) (15 : Fin 20) = XCell1_15 := by
  rfl

public theorem XVec_apply_1_16 :
    XVec (1 : Fin 10) (16 : Fin 20) = XCell1_16 := by
  rfl

public theorem XVec_apply_1_17 :
    XVec (1 : Fin 10) (17 : Fin 20) = XCell1_17 := by
  rfl

public theorem XVec_apply_1_18 :
    XVec (1 : Fin 10) (18 : Fin 20) = XCell1_18 := by
  rfl

public theorem XVec_apply_1_19 :
    XVec (1 : Fin 10) (19 : Fin 20) = XCell1_19 := by
  rfl

public theorem XVec_apply_2_0 :
    XVec (2 : Fin 10) (0 : Fin 20) = XCell2_0 := by
  rfl

public theorem XVec_apply_2_1 :
    XVec (2 : Fin 10) (1 : Fin 20) = XCell2_1 := by
  rfl

public theorem XVec_apply_2_2 :
    XVec (2 : Fin 10) (2 : Fin 20) = XCell2_2 := by
  rfl

public theorem XVec_apply_2_3 :
    XVec (2 : Fin 10) (3 : Fin 20) = XCell2_3 := by
  rfl

public theorem XVec_apply_2_4 :
    XVec (2 : Fin 10) (4 : Fin 20) = XCell2_4 := by
  rfl

public theorem XVec_apply_2_5 :
    XVec (2 : Fin 10) (5 : Fin 20) = XCell2_5 := by
  rfl

public theorem XVec_apply_2_6 :
    XVec (2 : Fin 10) (6 : Fin 20) = XCell2_6 := by
  rfl

public theorem XVec_apply_2_7 :
    XVec (2 : Fin 10) (7 : Fin 20) = XCell2_7 := by
  rfl

public theorem XVec_apply_2_8 :
    XVec (2 : Fin 10) (8 : Fin 20) = XCell2_8 := by
  rfl

public theorem XVec_apply_2_9 :
    XVec (2 : Fin 10) (9 : Fin 20) = XCell2_9 := by
  rfl

public theorem XVec_apply_2_10 :
    XVec (2 : Fin 10) (10 : Fin 20) = XCell2_10 := by
  rfl

public theorem XVec_apply_2_11 :
    XVec (2 : Fin 10) (11 : Fin 20) = XCell2_11 := by
  rfl

public theorem XVec_apply_2_12 :
    XVec (2 : Fin 10) (12 : Fin 20) = XCell2_12 := by
  rfl

public theorem XVec_apply_2_13 :
    XVec (2 : Fin 10) (13 : Fin 20) = XCell2_13 := by
  rfl

public theorem XVec_apply_2_14 :
    XVec (2 : Fin 10) (14 : Fin 20) = XCell2_14 := by
  rfl

public theorem XVec_apply_2_15 :
    XVec (2 : Fin 10) (15 : Fin 20) = XCell2_15 := by
  rfl

public theorem XVec_apply_2_16 :
    XVec (2 : Fin 10) (16 : Fin 20) = XCell2_16 := by
  rfl

public theorem XVec_apply_2_17 :
    XVec (2 : Fin 10) (17 : Fin 20) = XCell2_17 := by
  rfl

public theorem XVec_apply_2_18 :
    XVec (2 : Fin 10) (18 : Fin 20) = XCell2_18 := by
  rfl

public theorem XVec_apply_2_19 :
    XVec (2 : Fin 10) (19 : Fin 20) = XCell2_19 := by
  rfl

public theorem XVec_apply_3_0 :
    XVec (3 : Fin 10) (0 : Fin 20) = XCell3_0 := by
  rfl

public theorem XVec_apply_3_1 :
    XVec (3 : Fin 10) (1 : Fin 20) = XCell3_1 := by
  rfl

public theorem XVec_apply_3_2 :
    XVec (3 : Fin 10) (2 : Fin 20) = XCell3_2 := by
  rfl

public theorem XVec_apply_3_3 :
    XVec (3 : Fin 10) (3 : Fin 20) = XCell3_3 := by
  rfl

public theorem XVec_apply_3_4 :
    XVec (3 : Fin 10) (4 : Fin 20) = XCell3_4 := by
  rfl

public theorem XVec_apply_3_5 :
    XVec (3 : Fin 10) (5 : Fin 20) = XCell3_5 := by
  rfl

public theorem XVec_apply_3_6 :
    XVec (3 : Fin 10) (6 : Fin 20) = XCell3_6 := by
  rfl

public theorem XVec_apply_3_7 :
    XVec (3 : Fin 10) (7 : Fin 20) = XCell3_7 := by
  rfl

public theorem XVec_apply_3_8 :
    XVec (3 : Fin 10) (8 : Fin 20) = XCell3_8 := by
  rfl

public theorem XVec_apply_3_9 :
    XVec (3 : Fin 10) (9 : Fin 20) = XCell3_9 := by
  rfl

public theorem XVec_apply_3_10 :
    XVec (3 : Fin 10) (10 : Fin 20) = XCell3_10 := by
  rfl

public theorem XVec_apply_3_11 :
    XVec (3 : Fin 10) (11 : Fin 20) = XCell3_11 := by
  rfl

public theorem XVec_apply_3_12 :
    XVec (3 : Fin 10) (12 : Fin 20) = XCell3_12 := by
  rfl

public theorem XVec_apply_3_13 :
    XVec (3 : Fin 10) (13 : Fin 20) = XCell3_13 := by
  rfl

public theorem XVec_apply_3_14 :
    XVec (3 : Fin 10) (14 : Fin 20) = XCell3_14 := by
  rfl

public theorem XVec_apply_3_15 :
    XVec (3 : Fin 10) (15 : Fin 20) = XCell3_15 := by
  rfl

public theorem XVec_apply_3_16 :
    XVec (3 : Fin 10) (16 : Fin 20) = XCell3_16 := by
  rfl

public theorem XVec_apply_3_17 :
    XVec (3 : Fin 10) (17 : Fin 20) = XCell3_17 := by
  rfl

public theorem XVec_apply_3_18 :
    XVec (3 : Fin 10) (18 : Fin 20) = XCell3_18 := by
  rfl

public theorem XVec_apply_3_19 :
    XVec (3 : Fin 10) (19 : Fin 20) = XCell3_19 := by
  rfl

public theorem XVec_apply_4_0 :
    XVec (4 : Fin 10) (0 : Fin 20) = XCell4_0 := by
  rfl

public theorem XVec_apply_4_1 :
    XVec (4 : Fin 10) (1 : Fin 20) = XCell4_1 := by
  rfl

public theorem XVec_apply_4_2 :
    XVec (4 : Fin 10) (2 : Fin 20) = XCell4_2 := by
  rfl

public theorem XVec_apply_4_3 :
    XVec (4 : Fin 10) (3 : Fin 20) = XCell4_3 := by
  rfl

public theorem XVec_apply_4_4 :
    XVec (4 : Fin 10) (4 : Fin 20) = XCell4_4 := by
  rfl

public theorem XVec_apply_4_5 :
    XVec (4 : Fin 10) (5 : Fin 20) = XCell4_5 := by
  rfl

public theorem XVec_apply_4_6 :
    XVec (4 : Fin 10) (6 : Fin 20) = XCell4_6 := by
  rfl

public theorem XVec_apply_4_7 :
    XVec (4 : Fin 10) (7 : Fin 20) = XCell4_7 := by
  rfl

public theorem XVec_apply_4_8 :
    XVec (4 : Fin 10) (8 : Fin 20) = XCell4_8 := by
  rfl

public theorem XVec_apply_4_9 :
    XVec (4 : Fin 10) (9 : Fin 20) = XCell4_9 := by
  rfl

public theorem XVec_apply_4_10 :
    XVec (4 : Fin 10) (10 : Fin 20) = XCell4_10 := by
  rfl

public theorem XVec_apply_4_11 :
    XVec (4 : Fin 10) (11 : Fin 20) = XCell4_11 := by
  rfl

public theorem XVec_apply_4_12 :
    XVec (4 : Fin 10) (12 : Fin 20) = XCell4_12 := by
  rfl

public theorem XVec_apply_4_13 :
    XVec (4 : Fin 10) (13 : Fin 20) = XCell4_13 := by
  rfl

public theorem XVec_apply_4_14 :
    XVec (4 : Fin 10) (14 : Fin 20) = XCell4_14 := by
  rfl

public theorem XVec_apply_4_15 :
    XVec (4 : Fin 10) (15 : Fin 20) = XCell4_15 := by
  rfl

public theorem XVec_apply_4_16 :
    XVec (4 : Fin 10) (16 : Fin 20) = XCell4_16 := by
  rfl

public theorem XVec_apply_4_17 :
    XVec (4 : Fin 10) (17 : Fin 20) = XCell4_17 := by
  rfl

public theorem XVec_apply_4_18 :
    XVec (4 : Fin 10) (18 : Fin 20) = XCell4_18 := by
  rfl

public theorem XVec_apply_4_19 :
    XVec (4 : Fin 10) (19 : Fin 20) = XCell4_19 := by
  rfl

public theorem XVec_apply_5_0 :
    XVec (5 : Fin 10) (0 : Fin 20) = XCell5_0 := by
  rfl

public theorem XVec_apply_5_1 :
    XVec (5 : Fin 10) (1 : Fin 20) = XCell5_1 := by
  rfl

public theorem XVec_apply_5_2 :
    XVec (5 : Fin 10) (2 : Fin 20) = XCell5_2 := by
  rfl

public theorem XVec_apply_5_3 :
    XVec (5 : Fin 10) (3 : Fin 20) = XCell5_3 := by
  rfl

public theorem XVec_apply_5_4 :
    XVec (5 : Fin 10) (4 : Fin 20) = XCell5_4 := by
  rfl

public theorem XVec_apply_5_5 :
    XVec (5 : Fin 10) (5 : Fin 20) = XCell5_5 := by
  rfl

public theorem XVec_apply_5_6 :
    XVec (5 : Fin 10) (6 : Fin 20) = XCell5_6 := by
  rfl

public theorem XVec_apply_5_7 :
    XVec (5 : Fin 10) (7 : Fin 20) = XCell5_7 := by
  rfl

public theorem XVec_apply_5_8 :
    XVec (5 : Fin 10) (8 : Fin 20) = XCell5_8 := by
  rfl

public theorem XVec_apply_5_9 :
    XVec (5 : Fin 10) (9 : Fin 20) = XCell5_9 := by
  rfl

public theorem XVec_apply_5_10 :
    XVec (5 : Fin 10) (10 : Fin 20) = XCell5_10 := by
  rfl

public theorem XVec_apply_5_11 :
    XVec (5 : Fin 10) (11 : Fin 20) = XCell5_11 := by
  rfl

public theorem XVec_apply_5_12 :
    XVec (5 : Fin 10) (12 : Fin 20) = XCell5_12 := by
  rfl

public theorem XVec_apply_5_13 :
    XVec (5 : Fin 10) (13 : Fin 20) = XCell5_13 := by
  rfl

public theorem XVec_apply_5_14 :
    XVec (5 : Fin 10) (14 : Fin 20) = XCell5_14 := by
  rfl

public theorem XVec_apply_5_15 :
    XVec (5 : Fin 10) (15 : Fin 20) = XCell5_15 := by
  rfl

public theorem XVec_apply_5_16 :
    XVec (5 : Fin 10) (16 : Fin 20) = XCell5_16 := by
  rfl

public theorem XVec_apply_5_17 :
    XVec (5 : Fin 10) (17 : Fin 20) = XCell5_17 := by
  rfl

public theorem XVec_apply_5_18 :
    XVec (5 : Fin 10) (18 : Fin 20) = XCell5_18 := by
  rfl

public theorem XVec_apply_5_19 :
    XVec (5 : Fin 10) (19 : Fin 20) = XCell5_19 := by
  rfl

public theorem XVec_apply_6_0 :
    XVec (6 : Fin 10) (0 : Fin 20) = XCell6_0 := by
  rfl

public theorem XVec_apply_6_1 :
    XVec (6 : Fin 10) (1 : Fin 20) = XCell6_1 := by
  rfl

public theorem XVec_apply_6_2 :
    XVec (6 : Fin 10) (2 : Fin 20) = XCell6_2 := by
  rfl

public theorem XVec_apply_6_3 :
    XVec (6 : Fin 10) (3 : Fin 20) = XCell6_3 := by
  rfl

public theorem XVec_apply_6_4 :
    XVec (6 : Fin 10) (4 : Fin 20) = XCell6_4 := by
  rfl

public theorem XVec_apply_6_5 :
    XVec (6 : Fin 10) (5 : Fin 20) = XCell6_5 := by
  rfl

public theorem XVec_apply_6_6 :
    XVec (6 : Fin 10) (6 : Fin 20) = XCell6_6 := by
  rfl

public theorem XVec_apply_6_7 :
    XVec (6 : Fin 10) (7 : Fin 20) = XCell6_7 := by
  rfl

public theorem XVec_apply_6_8 :
    XVec (6 : Fin 10) (8 : Fin 20) = XCell6_8 := by
  rfl

public theorem XVec_apply_6_9 :
    XVec (6 : Fin 10) (9 : Fin 20) = XCell6_9 := by
  rfl

public theorem XVec_apply_6_10 :
    XVec (6 : Fin 10) (10 : Fin 20) = XCell6_10 := by
  rfl

public theorem XVec_apply_6_11 :
    XVec (6 : Fin 10) (11 : Fin 20) = XCell6_11 := by
  rfl

public theorem XVec_apply_6_12 :
    XVec (6 : Fin 10) (12 : Fin 20) = XCell6_12 := by
  rfl

public theorem XVec_apply_6_13 :
    XVec (6 : Fin 10) (13 : Fin 20) = XCell6_13 := by
  rfl

public theorem XVec_apply_6_14 :
    XVec (6 : Fin 10) (14 : Fin 20) = XCell6_14 := by
  rfl

public theorem XVec_apply_6_15 :
    XVec (6 : Fin 10) (15 : Fin 20) = XCell6_15 := by
  rfl

public theorem XVec_apply_6_16 :
    XVec (6 : Fin 10) (16 : Fin 20) = XCell6_16 := by
  rfl

public theorem XVec_apply_6_17 :
    XVec (6 : Fin 10) (17 : Fin 20) = XCell6_17 := by
  rfl

public theorem XVec_apply_6_18 :
    XVec (6 : Fin 10) (18 : Fin 20) = XCell6_18 := by
  rfl

public theorem XVec_apply_6_19 :
    XVec (6 : Fin 10) (19 : Fin 20) = XCell6_19 := by
  rfl

public theorem XVec_apply_7_0 :
    XVec (7 : Fin 10) (0 : Fin 20) = XCell7_0 := by
  rfl

public theorem XVec_apply_7_1 :
    XVec (7 : Fin 10) (1 : Fin 20) = XCell7_1 := by
  rfl

public theorem XVec_apply_7_2 :
    XVec (7 : Fin 10) (2 : Fin 20) = XCell7_2 := by
  rfl

public theorem XVec_apply_7_3 :
    XVec (7 : Fin 10) (3 : Fin 20) = XCell7_3 := by
  rfl

public theorem XVec_apply_7_4 :
    XVec (7 : Fin 10) (4 : Fin 20) = XCell7_4 := by
  rfl

public theorem XVec_apply_7_5 :
    XVec (7 : Fin 10) (5 : Fin 20) = XCell7_5 := by
  rfl

public theorem XVec_apply_7_6 :
    XVec (7 : Fin 10) (6 : Fin 20) = XCell7_6 := by
  rfl

public theorem XVec_apply_7_7 :
    XVec (7 : Fin 10) (7 : Fin 20) = XCell7_7 := by
  rfl

public theorem XVec_apply_7_8 :
    XVec (7 : Fin 10) (8 : Fin 20) = XCell7_8 := by
  rfl

public theorem XVec_apply_7_9 :
    XVec (7 : Fin 10) (9 : Fin 20) = XCell7_9 := by
  rfl

public theorem XVec_apply_7_10 :
    XVec (7 : Fin 10) (10 : Fin 20) = XCell7_10 := by
  rfl

public theorem XVec_apply_7_11 :
    XVec (7 : Fin 10) (11 : Fin 20) = XCell7_11 := by
  rfl

public theorem XVec_apply_7_12 :
    XVec (7 : Fin 10) (12 : Fin 20) = XCell7_12 := by
  rfl

public theorem XVec_apply_7_13 :
    XVec (7 : Fin 10) (13 : Fin 20) = XCell7_13 := by
  rfl

public theorem XVec_apply_7_14 :
    XVec (7 : Fin 10) (14 : Fin 20) = XCell7_14 := by
  rfl

public theorem XVec_apply_7_15 :
    XVec (7 : Fin 10) (15 : Fin 20) = XCell7_15 := by
  rfl

public theorem XVec_apply_7_16 :
    XVec (7 : Fin 10) (16 : Fin 20) = XCell7_16 := by
  rfl

public theorem XVec_apply_7_17 :
    XVec (7 : Fin 10) (17 : Fin 20) = XCell7_17 := by
  rfl

public theorem XVec_apply_7_18 :
    XVec (7 : Fin 10) (18 : Fin 20) = XCell7_18 := by
  rfl

public theorem XVec_apply_7_19 :
    XVec (7 : Fin 10) (19 : Fin 20) = XCell7_19 := by
  rfl

public theorem XVec_apply_8_0 :
    XVec (8 : Fin 10) (0 : Fin 20) = XCell8_0 := by
  rfl

public theorem XVec_apply_8_1 :
    XVec (8 : Fin 10) (1 : Fin 20) = XCell8_1 := by
  rfl

public theorem XVec_apply_8_2 :
    XVec (8 : Fin 10) (2 : Fin 20) = XCell8_2 := by
  rfl

public theorem XVec_apply_8_3 :
    XVec (8 : Fin 10) (3 : Fin 20) = XCell8_3 := by
  rfl

public theorem XVec_apply_8_4 :
    XVec (8 : Fin 10) (4 : Fin 20) = XCell8_4 := by
  rfl

public theorem XVec_apply_8_5 :
    XVec (8 : Fin 10) (5 : Fin 20) = XCell8_5 := by
  rfl

public theorem XVec_apply_8_6 :
    XVec (8 : Fin 10) (6 : Fin 20) = XCell8_6 := by
  rfl

public theorem XVec_apply_8_7 :
    XVec (8 : Fin 10) (7 : Fin 20) = XCell8_7 := by
  rfl

public theorem XVec_apply_8_8 :
    XVec (8 : Fin 10) (8 : Fin 20) = XCell8_8 := by
  rfl

public theorem XVec_apply_8_9 :
    XVec (8 : Fin 10) (9 : Fin 20) = XCell8_9 := by
  rfl

public theorem XVec_apply_8_10 :
    XVec (8 : Fin 10) (10 : Fin 20) = XCell8_10 := by
  rfl

public theorem XVec_apply_8_11 :
    XVec (8 : Fin 10) (11 : Fin 20) = XCell8_11 := by
  rfl

public theorem XVec_apply_8_12 :
    XVec (8 : Fin 10) (12 : Fin 20) = XCell8_12 := by
  rfl

public theorem XVec_apply_8_13 :
    XVec (8 : Fin 10) (13 : Fin 20) = XCell8_13 := by
  rfl

public theorem XVec_apply_8_14 :
    XVec (8 : Fin 10) (14 : Fin 20) = XCell8_14 := by
  rfl

public theorem XVec_apply_8_15 :
    XVec (8 : Fin 10) (15 : Fin 20) = XCell8_15 := by
  rfl

public theorem XVec_apply_8_16 :
    XVec (8 : Fin 10) (16 : Fin 20) = XCell8_16 := by
  rfl

public theorem XVec_apply_8_17 :
    XVec (8 : Fin 10) (17 : Fin 20) = XCell8_17 := by
  rfl

public theorem XVec_apply_8_18 :
    XVec (8 : Fin 10) (18 : Fin 20) = XCell8_18 := by
  rfl

public theorem XVec_apply_8_19 :
    XVec (8 : Fin 10) (19 : Fin 20) = XCell8_19 := by
  rfl

public theorem XVec_apply_9_0 :
    XVec (9 : Fin 10) (0 : Fin 20) = XCell9_0 := by
  rfl

public theorem XVec_apply_9_1 :
    XVec (9 : Fin 10) (1 : Fin 20) = XCell9_1 := by
  rfl

public theorem XVec_apply_9_2 :
    XVec (9 : Fin 10) (2 : Fin 20) = XCell9_2 := by
  rfl

public theorem XVec_apply_9_3 :
    XVec (9 : Fin 10) (3 : Fin 20) = XCell9_3 := by
  rfl

public theorem XVec_apply_9_4 :
    XVec (9 : Fin 10) (4 : Fin 20) = XCell9_4 := by
  rfl

public theorem XVec_apply_9_5 :
    XVec (9 : Fin 10) (5 : Fin 20) = XCell9_5 := by
  rfl

public theorem XVec_apply_9_6 :
    XVec (9 : Fin 10) (6 : Fin 20) = XCell9_6 := by
  rfl

public theorem XVec_apply_9_7 :
    XVec (9 : Fin 10) (7 : Fin 20) = XCell9_7 := by
  rfl

public theorem XVec_apply_9_8 :
    XVec (9 : Fin 10) (8 : Fin 20) = XCell9_8 := by
  rfl

public theorem XVec_apply_9_9 :
    XVec (9 : Fin 10) (9 : Fin 20) = XCell9_9 := by
  rfl

public theorem XVec_apply_9_10 :
    XVec (9 : Fin 10) (10 : Fin 20) = XCell9_10 := by
  rfl

public theorem XVec_apply_9_11 :
    XVec (9 : Fin 10) (11 : Fin 20) = XCell9_11 := by
  rfl

public theorem XVec_apply_9_12 :
    XVec (9 : Fin 10) (12 : Fin 20) = XCell9_12 := by
  rfl

public theorem XVec_apply_9_13 :
    XVec (9 : Fin 10) (13 : Fin 20) = XCell9_13 := by
  rfl

public theorem XVec_apply_9_14 :
    XVec (9 : Fin 10) (14 : Fin 20) = XCell9_14 := by
  rfl

public theorem XVec_apply_9_15 :
    XVec (9 : Fin 10) (15 : Fin 20) = XCell9_15 := by
  rfl

public theorem XVec_apply_9_16 :
    XVec (9 : Fin 10) (16 : Fin 20) = XCell9_16 := by
  rfl

public theorem XVec_apply_9_17 :
    XVec (9 : Fin 10) (17 : Fin 20) = XCell9_17 := by
  rfl

public theorem XVec_apply_9_18 :
    XVec (9 : Fin 10) (18 : Fin 20) = XCell9_18 := by
  rfl

public theorem XVec_apply_9_19 :
    XVec (9 : Fin 10) (19 : Fin 20) = XCell9_19 := by
  rfl

public theorem AVec_apply_0_0 :
    AVec (0 : Fin 20) (0 : Fin 10) = ACell0_0 := by
  rfl

public theorem AVec_apply_0_1 :
    AVec (0 : Fin 20) (1 : Fin 10) = ACell0_1 := by
  rfl

public theorem AVec_apply_0_2 :
    AVec (0 : Fin 20) (2 : Fin 10) = ACell0_2 := by
  rfl

public theorem AVec_apply_0_3 :
    AVec (0 : Fin 20) (3 : Fin 10) = ACell0_3 := by
  rfl

public theorem AVec_apply_0_4 :
    AVec (0 : Fin 20) (4 : Fin 10) = ACell0_4 := by
  rfl

public theorem AVec_apply_0_5 :
    AVec (0 : Fin 20) (5 : Fin 10) = ACell0_5 := by
  rfl

public theorem AVec_apply_0_6 :
    AVec (0 : Fin 20) (6 : Fin 10) = ACell0_6 := by
  rfl

public theorem AVec_apply_0_7 :
    AVec (0 : Fin 20) (7 : Fin 10) = ACell0_7 := by
  rfl

public theorem AVec_apply_0_8 :
    AVec (0 : Fin 20) (8 : Fin 10) = ACell0_8 := by
  rfl

public theorem AVec_apply_0_9 :
    AVec (0 : Fin 20) (9 : Fin 10) = ACell0_9 := by
  rfl

public theorem AVec_apply_1_0 :
    AVec (1 : Fin 20) (0 : Fin 10) = ACell1_0 := by
  rfl

public theorem AVec_apply_1_1 :
    AVec (1 : Fin 20) (1 : Fin 10) = ACell1_1 := by
  rfl

public theorem AVec_apply_1_2 :
    AVec (1 : Fin 20) (2 : Fin 10) = ACell1_2 := by
  rfl

public theorem AVec_apply_1_3 :
    AVec (1 : Fin 20) (3 : Fin 10) = ACell1_3 := by
  rfl

public theorem AVec_apply_1_4 :
    AVec (1 : Fin 20) (4 : Fin 10) = ACell1_4 := by
  rfl

public theorem AVec_apply_1_5 :
    AVec (1 : Fin 20) (5 : Fin 10) = ACell1_5 := by
  rfl

public theorem AVec_apply_1_6 :
    AVec (1 : Fin 20) (6 : Fin 10) = ACell1_6 := by
  rfl

public theorem AVec_apply_1_7 :
    AVec (1 : Fin 20) (7 : Fin 10) = ACell1_7 := by
  rfl

public theorem AVec_apply_1_8 :
    AVec (1 : Fin 20) (8 : Fin 10) = ACell1_8 := by
  rfl

public theorem AVec_apply_1_9 :
    AVec (1 : Fin 20) (9 : Fin 10) = ACell1_9 := by
  rfl

public theorem AVec_apply_2_0 :
    AVec (2 : Fin 20) (0 : Fin 10) = ACell2_0 := by
  rfl

public theorem AVec_apply_2_1 :
    AVec (2 : Fin 20) (1 : Fin 10) = ACell2_1 := by
  rfl

public theorem AVec_apply_2_2 :
    AVec (2 : Fin 20) (2 : Fin 10) = ACell2_2 := by
  rfl

public theorem AVec_apply_2_3 :
    AVec (2 : Fin 20) (3 : Fin 10) = ACell2_3 := by
  rfl

public theorem AVec_apply_2_4 :
    AVec (2 : Fin 20) (4 : Fin 10) = ACell2_4 := by
  rfl

public theorem AVec_apply_2_5 :
    AVec (2 : Fin 20) (5 : Fin 10) = ACell2_5 := by
  rfl

public theorem AVec_apply_2_6 :
    AVec (2 : Fin 20) (6 : Fin 10) = ACell2_6 := by
  rfl

public theorem AVec_apply_2_7 :
    AVec (2 : Fin 20) (7 : Fin 10) = ACell2_7 := by
  rfl

public theorem AVec_apply_2_8 :
    AVec (2 : Fin 20) (8 : Fin 10) = ACell2_8 := by
  rfl

public theorem AVec_apply_2_9 :
    AVec (2 : Fin 20) (9 : Fin 10) = ACell2_9 := by
  rfl

public theorem AVec_apply_3_0 :
    AVec (3 : Fin 20) (0 : Fin 10) = ACell3_0 := by
  rfl

public theorem AVec_apply_3_1 :
    AVec (3 : Fin 20) (1 : Fin 10) = ACell3_1 := by
  rfl

public theorem AVec_apply_3_2 :
    AVec (3 : Fin 20) (2 : Fin 10) = ACell3_2 := by
  rfl

public theorem AVec_apply_3_3 :
    AVec (3 : Fin 20) (3 : Fin 10) = ACell3_3 := by
  rfl

public theorem AVec_apply_3_4 :
    AVec (3 : Fin 20) (4 : Fin 10) = ACell3_4 := by
  rfl

public theorem AVec_apply_3_5 :
    AVec (3 : Fin 20) (5 : Fin 10) = ACell3_5 := by
  rfl

public theorem AVec_apply_3_6 :
    AVec (3 : Fin 20) (6 : Fin 10) = ACell3_6 := by
  rfl

public theorem AVec_apply_3_7 :
    AVec (3 : Fin 20) (7 : Fin 10) = ACell3_7 := by
  rfl

public theorem AVec_apply_3_8 :
    AVec (3 : Fin 20) (8 : Fin 10) = ACell3_8 := by
  rfl

public theorem AVec_apply_3_9 :
    AVec (3 : Fin 20) (9 : Fin 10) = ACell3_9 := by
  rfl

public theorem AVec_apply_4_0 :
    AVec (4 : Fin 20) (0 : Fin 10) = ACell4_0 := by
  rfl

public theorem AVec_apply_4_1 :
    AVec (4 : Fin 20) (1 : Fin 10) = ACell4_1 := by
  rfl

public theorem AVec_apply_4_2 :
    AVec (4 : Fin 20) (2 : Fin 10) = ACell4_2 := by
  rfl

public theorem AVec_apply_4_3 :
    AVec (4 : Fin 20) (3 : Fin 10) = ACell4_3 := by
  rfl

public theorem AVec_apply_4_4 :
    AVec (4 : Fin 20) (4 : Fin 10) = ACell4_4 := by
  rfl

public theorem AVec_apply_4_5 :
    AVec (4 : Fin 20) (5 : Fin 10) = ACell4_5 := by
  rfl

public theorem AVec_apply_4_6 :
    AVec (4 : Fin 20) (6 : Fin 10) = ACell4_6 := by
  rfl

public theorem AVec_apply_4_7 :
    AVec (4 : Fin 20) (7 : Fin 10) = ACell4_7 := by
  rfl

public theorem AVec_apply_4_8 :
    AVec (4 : Fin 20) (8 : Fin 10) = ACell4_8 := by
  rfl

public theorem AVec_apply_4_9 :
    AVec (4 : Fin 20) (9 : Fin 10) = ACell4_9 := by
  rfl

public theorem AVec_apply_5_0 :
    AVec (5 : Fin 20) (0 : Fin 10) = ACell5_0 := by
  rfl

public theorem AVec_apply_5_1 :
    AVec (5 : Fin 20) (1 : Fin 10) = ACell5_1 := by
  rfl

public theorem AVec_apply_5_2 :
    AVec (5 : Fin 20) (2 : Fin 10) = ACell5_2 := by
  rfl

public theorem AVec_apply_5_3 :
    AVec (5 : Fin 20) (3 : Fin 10) = ACell5_3 := by
  rfl

public theorem AVec_apply_5_4 :
    AVec (5 : Fin 20) (4 : Fin 10) = ACell5_4 := by
  rfl

public theorem AVec_apply_5_5 :
    AVec (5 : Fin 20) (5 : Fin 10) = ACell5_5 := by
  rfl

public theorem AVec_apply_5_6 :
    AVec (5 : Fin 20) (6 : Fin 10) = ACell5_6 := by
  rfl

public theorem AVec_apply_5_7 :
    AVec (5 : Fin 20) (7 : Fin 10) = ACell5_7 := by
  rfl

public theorem AVec_apply_5_8 :
    AVec (5 : Fin 20) (8 : Fin 10) = ACell5_8 := by
  rfl

public theorem AVec_apply_5_9 :
    AVec (5 : Fin 20) (9 : Fin 10) = ACell5_9 := by
  rfl

public theorem AVec_apply_6_0 :
    AVec (6 : Fin 20) (0 : Fin 10) = ACell6_0 := by
  rfl

public theorem AVec_apply_6_1 :
    AVec (6 : Fin 20) (1 : Fin 10) = ACell6_1 := by
  rfl

public theorem AVec_apply_6_2 :
    AVec (6 : Fin 20) (2 : Fin 10) = ACell6_2 := by
  rfl

public theorem AVec_apply_6_3 :
    AVec (6 : Fin 20) (3 : Fin 10) = ACell6_3 := by
  rfl

public theorem AVec_apply_6_4 :
    AVec (6 : Fin 20) (4 : Fin 10) = ACell6_4 := by
  rfl

public theorem AVec_apply_6_5 :
    AVec (6 : Fin 20) (5 : Fin 10) = ACell6_5 := by
  rfl

public theorem AVec_apply_6_6 :
    AVec (6 : Fin 20) (6 : Fin 10) = ACell6_6 := by
  rfl

public theorem AVec_apply_6_7 :
    AVec (6 : Fin 20) (7 : Fin 10) = ACell6_7 := by
  rfl

public theorem AVec_apply_6_8 :
    AVec (6 : Fin 20) (8 : Fin 10) = ACell6_8 := by
  rfl

public theorem AVec_apply_6_9 :
    AVec (6 : Fin 20) (9 : Fin 10) = ACell6_9 := by
  rfl

public theorem AVec_apply_7_0 :
    AVec (7 : Fin 20) (0 : Fin 10) = ACell7_0 := by
  rfl

public theorem AVec_apply_7_1 :
    AVec (7 : Fin 20) (1 : Fin 10) = ACell7_1 := by
  rfl

public theorem AVec_apply_7_2 :
    AVec (7 : Fin 20) (2 : Fin 10) = ACell7_2 := by
  rfl

public theorem AVec_apply_7_3 :
    AVec (7 : Fin 20) (3 : Fin 10) = ACell7_3 := by
  rfl

public theorem AVec_apply_7_4 :
    AVec (7 : Fin 20) (4 : Fin 10) = ACell7_4 := by
  rfl

public theorem AVec_apply_7_5 :
    AVec (7 : Fin 20) (5 : Fin 10) = ACell7_5 := by
  rfl

public theorem AVec_apply_7_6 :
    AVec (7 : Fin 20) (6 : Fin 10) = ACell7_6 := by
  rfl

public theorem AVec_apply_7_7 :
    AVec (7 : Fin 20) (7 : Fin 10) = ACell7_7 := by
  rfl

public theorem AVec_apply_7_8 :
    AVec (7 : Fin 20) (8 : Fin 10) = ACell7_8 := by
  rfl

public theorem AVec_apply_7_9 :
    AVec (7 : Fin 20) (9 : Fin 10) = ACell7_9 := by
  rfl

public theorem AVec_apply_8_0 :
    AVec (8 : Fin 20) (0 : Fin 10) = ACell8_0 := by
  rfl

public theorem AVec_apply_8_1 :
    AVec (8 : Fin 20) (1 : Fin 10) = ACell8_1 := by
  rfl

public theorem AVec_apply_8_2 :
    AVec (8 : Fin 20) (2 : Fin 10) = ACell8_2 := by
  rfl

public theorem AVec_apply_8_3 :
    AVec (8 : Fin 20) (3 : Fin 10) = ACell8_3 := by
  rfl

public theorem AVec_apply_8_4 :
    AVec (8 : Fin 20) (4 : Fin 10) = ACell8_4 := by
  rfl

public theorem AVec_apply_8_5 :
    AVec (8 : Fin 20) (5 : Fin 10) = ACell8_5 := by
  rfl

public theorem AVec_apply_8_6 :
    AVec (8 : Fin 20) (6 : Fin 10) = ACell8_6 := by
  rfl

public theorem AVec_apply_8_7 :
    AVec (8 : Fin 20) (7 : Fin 10) = ACell8_7 := by
  rfl

public theorem AVec_apply_8_8 :
    AVec (8 : Fin 20) (8 : Fin 10) = ACell8_8 := by
  rfl

public theorem AVec_apply_8_9 :
    AVec (8 : Fin 20) (9 : Fin 10) = ACell8_9 := by
  rfl

public theorem AVec_apply_9_0 :
    AVec (9 : Fin 20) (0 : Fin 10) = ACell9_0 := by
  rfl

public theorem AVec_apply_9_1 :
    AVec (9 : Fin 20) (1 : Fin 10) = ACell9_1 := by
  rfl

public theorem AVec_apply_9_2 :
    AVec (9 : Fin 20) (2 : Fin 10) = ACell9_2 := by
  rfl

public theorem AVec_apply_9_3 :
    AVec (9 : Fin 20) (3 : Fin 10) = ACell9_3 := by
  rfl

public theorem AVec_apply_9_4 :
    AVec (9 : Fin 20) (4 : Fin 10) = ACell9_4 := by
  rfl

public theorem AVec_apply_9_5 :
    AVec (9 : Fin 20) (5 : Fin 10) = ACell9_5 := by
  rfl

public theorem AVec_apply_9_6 :
    AVec (9 : Fin 20) (6 : Fin 10) = ACell9_6 := by
  rfl

public theorem AVec_apply_9_7 :
    AVec (9 : Fin 20) (7 : Fin 10) = ACell9_7 := by
  rfl

public theorem AVec_apply_9_8 :
    AVec (9 : Fin 20) (8 : Fin 10) = ACell9_8 := by
  rfl

public theorem AVec_apply_9_9 :
    AVec (9 : Fin 20) (9 : Fin 10) = ACell9_9 := by
  rfl

public theorem AVec_apply_10_0 :
    AVec (10 : Fin 20) (0 : Fin 10) = ACell10_0 := by
  rfl

public theorem AVec_apply_10_1 :
    AVec (10 : Fin 20) (1 : Fin 10) = ACell10_1 := by
  rfl

public theorem AVec_apply_10_2 :
    AVec (10 : Fin 20) (2 : Fin 10) = ACell10_2 := by
  rfl

public theorem AVec_apply_10_3 :
    AVec (10 : Fin 20) (3 : Fin 10) = ACell10_3 := by
  rfl

public theorem AVec_apply_10_4 :
    AVec (10 : Fin 20) (4 : Fin 10) = ACell10_4 := by
  rfl

public theorem AVec_apply_10_5 :
    AVec (10 : Fin 20) (5 : Fin 10) = ACell10_5 := by
  rfl

public theorem AVec_apply_10_6 :
    AVec (10 : Fin 20) (6 : Fin 10) = ACell10_6 := by
  rfl

public theorem AVec_apply_10_7 :
    AVec (10 : Fin 20) (7 : Fin 10) = ACell10_7 := by
  rfl

public theorem AVec_apply_10_8 :
    AVec (10 : Fin 20) (8 : Fin 10) = ACell10_8 := by
  rfl

public theorem AVec_apply_10_9 :
    AVec (10 : Fin 20) (9 : Fin 10) = ACell10_9 := by
  rfl

public theorem AVec_apply_11_0 :
    AVec (11 : Fin 20) (0 : Fin 10) = ACell11_0 := by
  rfl

public theorem AVec_apply_11_1 :
    AVec (11 : Fin 20) (1 : Fin 10) = ACell11_1 := by
  rfl

public theorem AVec_apply_11_2 :
    AVec (11 : Fin 20) (2 : Fin 10) = ACell11_2 := by
  rfl

public theorem AVec_apply_11_3 :
    AVec (11 : Fin 20) (3 : Fin 10) = ACell11_3 := by
  rfl

public theorem AVec_apply_11_4 :
    AVec (11 : Fin 20) (4 : Fin 10) = ACell11_4 := by
  rfl

public theorem AVec_apply_11_5 :
    AVec (11 : Fin 20) (5 : Fin 10) = ACell11_5 := by
  rfl

public theorem AVec_apply_11_6 :
    AVec (11 : Fin 20) (6 : Fin 10) = ACell11_6 := by
  rfl

public theorem AVec_apply_11_7 :
    AVec (11 : Fin 20) (7 : Fin 10) = ACell11_7 := by
  rfl

public theorem AVec_apply_11_8 :
    AVec (11 : Fin 20) (8 : Fin 10) = ACell11_8 := by
  rfl

public theorem AVec_apply_11_9 :
    AVec (11 : Fin 20) (9 : Fin 10) = ACell11_9 := by
  rfl

public theorem AVec_apply_12_0 :
    AVec (12 : Fin 20) (0 : Fin 10) = ACell12_0 := by
  rfl

public theorem AVec_apply_12_1 :
    AVec (12 : Fin 20) (1 : Fin 10) = ACell12_1 := by
  rfl

public theorem AVec_apply_12_2 :
    AVec (12 : Fin 20) (2 : Fin 10) = ACell12_2 := by
  rfl

public theorem AVec_apply_12_3 :
    AVec (12 : Fin 20) (3 : Fin 10) = ACell12_3 := by
  rfl

public theorem AVec_apply_12_4 :
    AVec (12 : Fin 20) (4 : Fin 10) = ACell12_4 := by
  rfl

public theorem AVec_apply_12_5 :
    AVec (12 : Fin 20) (5 : Fin 10) = ACell12_5 := by
  rfl

public theorem AVec_apply_12_6 :
    AVec (12 : Fin 20) (6 : Fin 10) = ACell12_6 := by
  rfl

public theorem AVec_apply_12_7 :
    AVec (12 : Fin 20) (7 : Fin 10) = ACell12_7 := by
  rfl

public theorem AVec_apply_12_8 :
    AVec (12 : Fin 20) (8 : Fin 10) = ACell12_8 := by
  rfl

public theorem AVec_apply_12_9 :
    AVec (12 : Fin 20) (9 : Fin 10) = ACell12_9 := by
  rfl

public theorem AVec_apply_13_0 :
    AVec (13 : Fin 20) (0 : Fin 10) = ACell13_0 := by
  rfl

public theorem AVec_apply_13_1 :
    AVec (13 : Fin 20) (1 : Fin 10) = ACell13_1 := by
  rfl

public theorem AVec_apply_13_2 :
    AVec (13 : Fin 20) (2 : Fin 10) = ACell13_2 := by
  rfl

public theorem AVec_apply_13_3 :
    AVec (13 : Fin 20) (3 : Fin 10) = ACell13_3 := by
  rfl

public theorem AVec_apply_13_4 :
    AVec (13 : Fin 20) (4 : Fin 10) = ACell13_4 := by
  rfl

public theorem AVec_apply_13_5 :
    AVec (13 : Fin 20) (5 : Fin 10) = ACell13_5 := by
  rfl

public theorem AVec_apply_13_6 :
    AVec (13 : Fin 20) (6 : Fin 10) = ACell13_6 := by
  rfl

public theorem AVec_apply_13_7 :
    AVec (13 : Fin 20) (7 : Fin 10) = ACell13_7 := by
  rfl

public theorem AVec_apply_13_8 :
    AVec (13 : Fin 20) (8 : Fin 10) = ACell13_8 := by
  rfl

public theorem AVec_apply_13_9 :
    AVec (13 : Fin 20) (9 : Fin 10) = ACell13_9 := by
  rfl

public theorem AVec_apply_14_0 :
    AVec (14 : Fin 20) (0 : Fin 10) = ACell14_0 := by
  rfl

public theorem AVec_apply_14_1 :
    AVec (14 : Fin 20) (1 : Fin 10) = ACell14_1 := by
  rfl

public theorem AVec_apply_14_2 :
    AVec (14 : Fin 20) (2 : Fin 10) = ACell14_2 := by
  rfl

public theorem AVec_apply_14_3 :
    AVec (14 : Fin 20) (3 : Fin 10) = ACell14_3 := by
  rfl

public theorem AVec_apply_14_4 :
    AVec (14 : Fin 20) (4 : Fin 10) = ACell14_4 := by
  rfl

public theorem AVec_apply_14_5 :
    AVec (14 : Fin 20) (5 : Fin 10) = ACell14_5 := by
  rfl

public theorem AVec_apply_14_6 :
    AVec (14 : Fin 20) (6 : Fin 10) = ACell14_6 := by
  rfl

public theorem AVec_apply_14_7 :
    AVec (14 : Fin 20) (7 : Fin 10) = ACell14_7 := by
  rfl

public theorem AVec_apply_14_8 :
    AVec (14 : Fin 20) (8 : Fin 10) = ACell14_8 := by
  rfl

public theorem AVec_apply_14_9 :
    AVec (14 : Fin 20) (9 : Fin 10) = ACell14_9 := by
  rfl

public theorem AVec_apply_15_0 :
    AVec (15 : Fin 20) (0 : Fin 10) = ACell15_0 := by
  rfl

public theorem AVec_apply_15_1 :
    AVec (15 : Fin 20) (1 : Fin 10) = ACell15_1 := by
  rfl

public theorem AVec_apply_15_2 :
    AVec (15 : Fin 20) (2 : Fin 10) = ACell15_2 := by
  rfl

public theorem AVec_apply_15_3 :
    AVec (15 : Fin 20) (3 : Fin 10) = ACell15_3 := by
  rfl

public theorem AVec_apply_15_4 :
    AVec (15 : Fin 20) (4 : Fin 10) = ACell15_4 := by
  rfl

public theorem AVec_apply_15_5 :
    AVec (15 : Fin 20) (5 : Fin 10) = ACell15_5 := by
  rfl

public theorem AVec_apply_15_6 :
    AVec (15 : Fin 20) (6 : Fin 10) = ACell15_6 := by
  rfl

public theorem AVec_apply_15_7 :
    AVec (15 : Fin 20) (7 : Fin 10) = ACell15_7 := by
  rfl

public theorem AVec_apply_15_8 :
    AVec (15 : Fin 20) (8 : Fin 10) = ACell15_8 := by
  rfl

public theorem AVec_apply_15_9 :
    AVec (15 : Fin 20) (9 : Fin 10) = ACell15_9 := by
  rfl

public theorem AVec_apply_16_0 :
    AVec (16 : Fin 20) (0 : Fin 10) = ACell16_0 := by
  rfl

public theorem AVec_apply_16_1 :
    AVec (16 : Fin 20) (1 : Fin 10) = ACell16_1 := by
  rfl

public theorem AVec_apply_16_2 :
    AVec (16 : Fin 20) (2 : Fin 10) = ACell16_2 := by
  rfl

public theorem AVec_apply_16_3 :
    AVec (16 : Fin 20) (3 : Fin 10) = ACell16_3 := by
  rfl

public theorem AVec_apply_16_4 :
    AVec (16 : Fin 20) (4 : Fin 10) = ACell16_4 := by
  rfl

public theorem AVec_apply_16_5 :
    AVec (16 : Fin 20) (5 : Fin 10) = ACell16_5 := by
  rfl

public theorem AVec_apply_16_6 :
    AVec (16 : Fin 20) (6 : Fin 10) = ACell16_6 := by
  rfl

public theorem AVec_apply_16_7 :
    AVec (16 : Fin 20) (7 : Fin 10) = ACell16_7 := by
  rfl

public theorem AVec_apply_16_8 :
    AVec (16 : Fin 20) (8 : Fin 10) = ACell16_8 := by
  rfl

public theorem AVec_apply_16_9 :
    AVec (16 : Fin 20) (9 : Fin 10) = ACell16_9 := by
  rfl

public theorem AVec_apply_17_0 :
    AVec (17 : Fin 20) (0 : Fin 10) = ACell17_0 := by
  rfl

public theorem AVec_apply_17_1 :
    AVec (17 : Fin 20) (1 : Fin 10) = ACell17_1 := by
  rfl

public theorem AVec_apply_17_2 :
    AVec (17 : Fin 20) (2 : Fin 10) = ACell17_2 := by
  rfl

public theorem AVec_apply_17_3 :
    AVec (17 : Fin 20) (3 : Fin 10) = ACell17_3 := by
  rfl

public theorem AVec_apply_17_4 :
    AVec (17 : Fin 20) (4 : Fin 10) = ACell17_4 := by
  rfl

public theorem AVec_apply_17_5 :
    AVec (17 : Fin 20) (5 : Fin 10) = ACell17_5 := by
  rfl

public theorem AVec_apply_17_6 :
    AVec (17 : Fin 20) (6 : Fin 10) = ACell17_6 := by
  rfl

public theorem AVec_apply_17_7 :
    AVec (17 : Fin 20) (7 : Fin 10) = ACell17_7 := by
  rfl

public theorem AVec_apply_17_8 :
    AVec (17 : Fin 20) (8 : Fin 10) = ACell17_8 := by
  rfl

public theorem AVec_apply_17_9 :
    AVec (17 : Fin 20) (9 : Fin 10) = ACell17_9 := by
  rfl

public theorem AVec_apply_18_0 :
    AVec (18 : Fin 20) (0 : Fin 10) = ACell18_0 := by
  rfl

public theorem AVec_apply_18_1 :
    AVec (18 : Fin 20) (1 : Fin 10) = ACell18_1 := by
  rfl

public theorem AVec_apply_18_2 :
    AVec (18 : Fin 20) (2 : Fin 10) = ACell18_2 := by
  rfl

public theorem AVec_apply_18_3 :
    AVec (18 : Fin 20) (3 : Fin 10) = ACell18_3 := by
  rfl

public theorem AVec_apply_18_4 :
    AVec (18 : Fin 20) (4 : Fin 10) = ACell18_4 := by
  rfl

public theorem AVec_apply_18_5 :
    AVec (18 : Fin 20) (5 : Fin 10) = ACell18_5 := by
  rfl

public theorem AVec_apply_18_6 :
    AVec (18 : Fin 20) (6 : Fin 10) = ACell18_6 := by
  rfl

public theorem AVec_apply_18_7 :
    AVec (18 : Fin 20) (7 : Fin 10) = ACell18_7 := by
  rfl

public theorem AVec_apply_18_8 :
    AVec (18 : Fin 20) (8 : Fin 10) = ACell18_8 := by
  rfl

public theorem AVec_apply_18_9 :
    AVec (18 : Fin 20) (9 : Fin 10) = ACell18_9 := by
  rfl

public theorem AVec_apply_19_0 :
    AVec (19 : Fin 20) (0 : Fin 10) = ACell19_0 := by
  rfl

public theorem AVec_apply_19_1 :
    AVec (19 : Fin 20) (1 : Fin 10) = ACell19_1 := by
  rfl

public theorem AVec_apply_19_2 :
    AVec (19 : Fin 20) (2 : Fin 10) = ACell19_2 := by
  rfl

public theorem AVec_apply_19_3 :
    AVec (19 : Fin 20) (3 : Fin 10) = ACell19_3 := by
  rfl

public theorem AVec_apply_19_4 :
    AVec (19 : Fin 20) (4 : Fin 10) = ACell19_4 := by
  rfl

public theorem AVec_apply_19_5 :
    AVec (19 : Fin 20) (5 : Fin 10) = ACell19_5 := by
  rfl

public theorem AVec_apply_19_6 :
    AVec (19 : Fin 20) (6 : Fin 10) = ACell19_6 := by
  rfl

public theorem AVec_apply_19_7 :
    AVec (19 : Fin 20) (7 : Fin 10) = ACell19_7 := by
  rfl

public theorem AVec_apply_19_8 :
    AVec (19 : Fin 20) (8 : Fin 10) = ACell19_8 := by
  rfl

public theorem AVec_apply_19_9 :
    AVec (19 : Fin 20) (9 : Fin 10) = ACell19_9 := by
  rfl

end V14Formalization.D12PiecePAData
