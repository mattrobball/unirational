/- AP split identity row 5: entry certificates inlined. Auto-generated. -/
module

public import V14Formalization.D12PieceAPData
public import V14Formalization.D12CyclotomicVecZ
public import V14Formalization.D12VecScaleIntro

noncomputable section
open Matrix

namespace V14Formalization.D12PieceAPSplitEntry5_0
open D12CyclotomicVec D12CyclotomicVecZ D12PieceAPData
def payloadSha256 : String := "76c6196f29afe1a8398af99502447f48ebeed4bcb3805fc5dbec693940bc04b0"

def scale : ℤ := 44

def XZ (k : Fin 20) : VecZ :=
  match k.val with
  | 0 => #v[-27, -34, -51, -12, -13, -86, -28, -22, -26, -86]
  | 1 => #v[-7, -3, -20, -10, 0, -16, -7, 0, 9, -12]
  | 2 => #v[76, 28, 95, 45, 23, 101, 37, 79, -13, 134]
  | 3 => #v[-69, -14, -29, -51, -37, -32, 5, -76, -2, -36]
  | 4 => #v[14, 6, -1, 21, 24, 1, 15, 19, -5, -6]
  | 5 => #v[104, -10, 6, 56, 46, 22, 0, 104, 0, 24]
  | 6 => #v[-34, -52, -60, -10, -8, -60, -16, -42, -14, -78]
  | 7 => #v[108, -26, 42, 60, 20, 42, -6, 124, -46, 78]
  | 8 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  | 9 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  | 10 => #v[0, 11, 11, 0, 0, -11, -11, 11, -11, 0]
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
  | 10 => #v[-32, 0, 8, 4, 0, 4, 4, 0, 4, 8]
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
  | 0 => #v[22, 0, 0, 22, 0, 22, 22, 22, 0, 0]
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

theorem XZ_scale_0 : toVec (XZ 0) = (scale : ℚ) • XCell5_0 :=
  toVec_eq_smul_of_scaledZ (XZ 0) scale XCell5_0_scaled (by decide) rfl

theorem XZ_scale_1 : toVec (XZ 1) = (scale : ℚ) • XCell5_1 :=
  toVec_eq_smul_of_scaledZ (XZ 1) scale XCell5_1_scaled (by decide) rfl

theorem XZ_scale_2 : toVec (XZ 2) = (scale : ℚ) • XCell5_2 :=
  toVec_eq_smul_of_scaledZ (XZ 2) scale XCell5_2_scaled (by decide) rfl

theorem XZ_scale_3 : toVec (XZ 3) = (scale : ℚ) • XCell5_3 :=
  toVec_eq_smul_of_scaledZ (XZ 3) scale XCell5_3_scaled (by decide) rfl

theorem XZ_scale_4 : toVec (XZ 4) = (scale : ℚ) • XCell5_4 :=
  toVec_eq_smul_of_scaledZ (XZ 4) scale XCell5_4_scaled (by decide) rfl

theorem XZ_scale_5 : toVec (XZ 5) = (scale : ℚ) • XCell5_5 :=
  toVec_eq_smul_of_scaledZ (XZ 5) scale XCell5_5_scaled (by decide) rfl

theorem XZ_scale_6 : toVec (XZ 6) = (scale : ℚ) • XCell5_6 :=
  toVec_eq_smul_of_scaledZ (XZ 6) scale XCell5_6_scaled (by decide) rfl

theorem XZ_scale_7 : toVec (XZ 7) = (scale : ℚ) • XCell5_7 :=
  toVec_eq_smul_of_scaledZ (XZ 7) scale XCell5_7_scaled (by decide) rfl

theorem XZ_scale_8 : toVec (XZ 8) = (scale : ℚ) • XCell5_8 :=
  toVec_eq_smul_of_scaledZ (XZ 8) scale XCell5_8_scaled (by decide) rfl

theorem XZ_scale_9 : toVec (XZ 9) = (scale : ℚ) • XCell5_9 :=
  toVec_eq_smul_of_scaledZ (XZ 9) scale XCell5_9_scaled (by decide) rfl

theorem XZ_scale_10 : toVec (XZ 10) = (scale : ℚ) • XCell5_10 :=
  toVec_eq_smul_of_scaledZ (XZ 10) scale XCell5_10_scaled (by decide) rfl

theorem XZ_scale_11 : toVec (XZ 11) = (scale : ℚ) • XCell5_11 :=
  toVec_eq_smul_of_scaledZ (XZ 11) scale XCell5_11_scaled (by decide) rfl

theorem XZ_scale_12 : toVec (XZ 12) = (scale : ℚ) • XCell5_12 :=
  toVec_eq_smul_of_scaledZ (XZ 12) scale XCell5_12_scaled (by decide) rfl

theorem XZ_scale_13 : toVec (XZ 13) = (scale : ℚ) • XCell5_13 :=
  toVec_eq_smul_of_scaledZ (XZ 13) scale XCell5_13_scaled (by decide) rfl

theorem XZ_scale_14 : toVec (XZ 14) = (scale : ℚ) • XCell5_14 :=
  toVec_eq_smul_of_scaledZ (XZ 14) scale XCell5_14_scaled (by decide) rfl

theorem XZ_scale_15 : toVec (XZ 15) = (scale : ℚ) • XCell5_15 :=
  toVec_eq_smul_of_scaledZ (XZ 15) scale XCell5_15_scaled (by decide) rfl

theorem XZ_scale_16 : toVec (XZ 16) = (scale : ℚ) • XCell5_16 :=
  toVec_eq_smul_of_scaledZ (XZ 16) scale XCell5_16_scaled (by decide) rfl

theorem XZ_scale_17 : toVec (XZ 17) = (scale : ℚ) • XCell5_17 :=
  toVec_eq_smul_of_scaledZ (XZ 17) scale XCell5_17_scaled (by decide) rfl

theorem XZ_scale_18 : toVec (XZ 18) = (scale : ℚ) • XCell5_18 :=
  toVec_eq_smul_of_scaledZ (XZ 18) scale XCell5_18_scaled (by decide) rfl

theorem XZ_scale_19 : toVec (XZ 19) = (scale : ℚ) • XCell5_19 :=
  toVec_eq_smul_of_scaledZ (XZ 19) scale XCell5_19_scaled (by decide) rfl

theorem XZ_scale (k : Fin 20) :
    toVec (XZ k) = (scale : ℚ) • XVec (5 : Fin 10) k :=
  forall_fin20 (P := fun k => toVec (XZ k) = (scale : ℚ) • XVec (5 : Fin 10) k)
    (toVec_smul_congr XZ_scale_0 XVec_apply_5_0)
    (toVec_smul_congr XZ_scale_1 XVec_apply_5_1)
    (toVec_smul_congr XZ_scale_2 XVec_apply_5_2)
    (toVec_smul_congr XZ_scale_3 XVec_apply_5_3)
    (toVec_smul_congr XZ_scale_4 XVec_apply_5_4)
    (toVec_smul_congr XZ_scale_5 XVec_apply_5_5)
    (toVec_smul_congr XZ_scale_6 XVec_apply_5_6)
    (toVec_smul_congr XZ_scale_7 XVec_apply_5_7)
    (toVec_smul_congr XZ_scale_8 XVec_apply_5_8)
    (toVec_smul_congr XZ_scale_9 XVec_apply_5_9)
    (toVec_smul_congr XZ_scale_10 XVec_apply_5_10)
    (toVec_smul_congr XZ_scale_11 XVec_apply_5_11)
    (toVec_smul_congr XZ_scale_12 XVec_apply_5_12)
    (toVec_smul_congr XZ_scale_13 XVec_apply_5_13)
    (toVec_smul_congr XZ_scale_14 XVec_apply_5_14)
    (toVec_smul_congr XZ_scale_15 XVec_apply_5_15)
    (toVec_smul_congr XZ_scale_16 XVec_apply_5_16)
    (toVec_smul_congr XZ_scale_17 XVec_apply_5_17)
    (toVec_smul_congr XZ_scale_18 XVec_apply_5_18)
    (toVec_smul_congr XZ_scale_19 XVec_apply_5_19)
    k

theorem AZ_scale_0 : toVec (AZ 0) = (scale : ℚ) • ACell0_0 :=
  toVec_eq_smul_of_scaledZ (AZ 0) scale ACell0_0_scaled (by decide) rfl

theorem AZ_scale_1 : toVec (AZ 1) = (scale : ℚ) • ACell1_0 :=
  toVec_eq_smul_of_scaledZ (AZ 1) scale ACell1_0_scaled (by decide) rfl

theorem AZ_scale_2 : toVec (AZ 2) = (scale : ℚ) • ACell2_0 :=
  toVec_eq_smul_of_scaledZ (AZ 2) scale ACell2_0_scaled (by decide) rfl

theorem AZ_scale_3 : toVec (AZ 3) = (scale : ℚ) • ACell3_0 :=
  toVec_eq_smul_of_scaledZ (AZ 3) scale ACell3_0_scaled (by decide) rfl

theorem AZ_scale_4 : toVec (AZ 4) = (scale : ℚ) • ACell4_0 :=
  toVec_eq_smul_of_scaledZ (AZ 4) scale ACell4_0_scaled (by decide) rfl

theorem AZ_scale_5 : toVec (AZ 5) = (scale : ℚ) • ACell5_0 :=
  toVec_eq_smul_of_scaledZ (AZ 5) scale ACell5_0_scaled (by decide) rfl

theorem AZ_scale_6 : toVec (AZ 6) = (scale : ℚ) • ACell6_0 :=
  toVec_eq_smul_of_scaledZ (AZ 6) scale ACell6_0_scaled (by decide) rfl

theorem AZ_scale_7 : toVec (AZ 7) = (scale : ℚ) • ACell7_0 :=
  toVec_eq_smul_of_scaledZ (AZ 7) scale ACell7_0_scaled (by decide) rfl

theorem AZ_scale_8 : toVec (AZ 8) = (scale : ℚ) • ACell8_0 :=
  toVec_eq_smul_of_scaledZ (AZ 8) scale ACell8_0_scaled (by decide) rfl

theorem AZ_scale_9 : toVec (AZ 9) = (scale : ℚ) • ACell9_0 :=
  toVec_eq_smul_of_scaledZ (AZ 9) scale ACell9_0_scaled (by decide) rfl

theorem AZ_scale_10 : toVec (AZ 10) = (scale : ℚ) • ACell10_0 :=
  toVec_eq_smul_of_scaledZ (AZ 10) scale ACell10_0_scaled (by decide) rfl

theorem AZ_scale_11 : toVec (AZ 11) = (scale : ℚ) • ACell11_0 :=
  toVec_eq_smul_of_scaledZ (AZ 11) scale ACell11_0_scaled (by decide) rfl

theorem AZ_scale_12 : toVec (AZ 12) = (scale : ℚ) • ACell12_0 :=
  toVec_eq_smul_of_scaledZ (AZ 12) scale ACell12_0_scaled (by decide) rfl

theorem AZ_scale_13 : toVec (AZ 13) = (scale : ℚ) • ACell13_0 :=
  toVec_eq_smul_of_scaledZ (AZ 13) scale ACell13_0_scaled (by decide) rfl

theorem AZ_scale_14 : toVec (AZ 14) = (scale : ℚ) • ACell14_0 :=
  toVec_eq_smul_of_scaledZ (AZ 14) scale ACell14_0_scaled (by decide) rfl

theorem AZ_scale_15 : toVec (AZ 15) = (scale : ℚ) • ACell15_0 :=
  toVec_eq_smul_of_scaledZ (AZ 15) scale ACell15_0_scaled (by decide) rfl

theorem AZ_scale_16 : toVec (AZ 16) = (scale : ℚ) • ACell16_0 :=
  toVec_eq_smul_of_scaledZ (AZ 16) scale ACell16_0_scaled (by decide) rfl

theorem AZ_scale_17 : toVec (AZ 17) = (scale : ℚ) • ACell17_0 :=
  toVec_eq_smul_of_scaledZ (AZ 17) scale ACell17_0_scaled (by decide) rfl

theorem AZ_scale_18 : toVec (AZ 18) = (scale : ℚ) • ACell18_0 :=
  toVec_eq_smul_of_scaledZ (AZ 18) scale ACell18_0_scaled (by decide) rfl

theorem AZ_scale_19 : toVec (AZ 19) = (scale : ℚ) • ACell19_0 :=
  toVec_eq_smul_of_scaledZ (AZ 19) scale ACell19_0_scaled (by decide) rfl

theorem AZ_scale (k : Fin 20) :
    toVec (AZ k) = (scale : ℚ) • AVec k (0 : Fin 10) :=
  forall_fin20 (P := fun k => toVec (AZ k) = (scale : ℚ) • AVec k (0 : Fin 10))
    (toVec_smul_congr AZ_scale_0 AVec_apply_0_0)
    (toVec_smul_congr AZ_scale_1 AVec_apply_1_0)
    (toVec_smul_congr AZ_scale_2 AVec_apply_2_0)
    (toVec_smul_congr AZ_scale_3 AVec_apply_3_0)
    (toVec_smul_congr AZ_scale_4 AVec_apply_4_0)
    (toVec_smul_congr AZ_scale_5 AVec_apply_5_0)
    (toVec_smul_congr AZ_scale_6 AVec_apply_6_0)
    (toVec_smul_congr AZ_scale_7 AVec_apply_7_0)
    (toVec_smul_congr AZ_scale_8 AVec_apply_8_0)
    (toVec_smul_congr AZ_scale_9 AVec_apply_9_0)
    (toVec_smul_congr AZ_scale_10 AVec_apply_10_0)
    (toVec_smul_congr AZ_scale_11 AVec_apply_11_0)
    (toVec_smul_congr AZ_scale_12 AVec_apply_12_0)
    (toVec_smul_congr AZ_scale_13 AVec_apply_13_0)
    (toVec_smul_congr AZ_scale_14 AVec_apply_14_0)
    (toVec_smul_congr AZ_scale_15 AVec_apply_15_0)
    (toVec_smul_congr AZ_scale_16 AVec_apply_16_0)
    (toVec_smul_congr AZ_scale_17 AVec_apply_17_0)
    (toVec_smul_congr AZ_scale_18 AVec_apply_18_0)
    (toVec_smul_congr AZ_scale_19 AVec_apply_19_0)
    k

theorem KZ_scale_0 : toVec (KZ 0) = (scale : ℚ) • KCell5_0 :=
  toVec_eq_smul_of_scaledZ (KZ 0) scale KCell5_0_scaled (by decide) rfl

theorem KZ_scale (k : Fin 1) :
    toVec (KZ k) = (scale : ℚ) • KVec (5 : Fin 10) k :=
  forall_fin1 (P := fun k => toVec (KZ k) = (scale : ℚ) • KVec (5 : Fin 10) k)
    (toVec_smul_congr KZ_scale_0 KVec_apply_5_0)
    k

theorem YZ_scale_0 : toVec (YZ 0) = (scale : ℚ) • YCell0_0 :=
  toVec_eq_smul_of_scaledZ (YZ 0) scale YCell0_0_scaled (by decide) rfl

theorem YZ_scale (k : Fin 1) :
    toVec (YZ k) = (scale : ℚ) • YVec k (0 : Fin 10) :=
  forall_fin1 (P := fun k => toVec (YZ k) = (scale : ℚ) • YVec k (0 : Fin 10))
    (toVec_smul_congr YZ_scale_0 YVec_apply_0_0)
    k

theorem entry_eq :
    (matrixMul XVec AVec + matrixMul KVec YVec)
        (5 : Fin 10) (0 : Fin 10) = ![0, 0, 0, 0, 0, 0, 0, 0, 0, 0] := by
  rw [Matrix.add_apply, matrixMul_apply, matrixMul_apply]
  refine add_sum_mul_eq_of_scaled scale scale_ne_zero
    (fun k => XVec (5 : Fin 10) k)
    (fun k => AVec k (0 : Fin 10))
    (fun k => KVec (5 : Fin 10) k)
    (fun k => YVec k (0 : Fin 10))
    XZ AZ KZ YZ XZ_scale AZ_scale KZ_scale YZ_scale entryZ rfl _ ?_
  rw [entryZ_eq, toVec_zeroZ_smul, vec_zero_eq]

theorem entry_eq_matrixOne :
    (matrixMul XVec AVec + matrixMul KVec YVec)
        (5 : Fin 10) (0 : Fin 10) =
      matrixOne (Fin 10) (5 : Fin 10) (0 : Fin 10) :=
  entry_eq.trans (matrixOne_off10 (5 : Fin 10) (0 : Fin 10) (by decide)).symm

end V14Formalization.D12PieceAPSplitEntry5_0


namespace V14Formalization.D12PieceAPSplitEntry5_1
open D12CyclotomicVec D12CyclotomicVecZ D12PieceAPData
def payloadSha256 : String := "76c6196f29afe1a8398af99502447f48ebeed4bcb3805fc5dbec693940bc04b0"

def scale : ℤ := 44

def XZ (k : Fin 20) : VecZ :=
  match k.val with
  | 0 => #v[-27, -34, -51, -12, -13, -86, -28, -22, -26, -86]
  | 1 => #v[-7, -3, -20, -10, 0, -16, -7, 0, 9, -12]
  | 2 => #v[76, 28, 95, 45, 23, 101, 37, 79, -13, 134]
  | 3 => #v[-69, -14, -29, -51, -37, -32, 5, -76, -2, -36]
  | 4 => #v[14, 6, -1, 21, 24, 1, 15, 19, -5, -6]
  | 5 => #v[104, -10, 6, 56, 46, 22, 0, 104, 0, 24]
  | 6 => #v[-34, -52, -60, -10, -8, -60, -16, -42, -14, -78]
  | 7 => #v[108, -26, 42, 60, 20, 42, -6, 124, -46, 78]
  | 8 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  | 9 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  | 10 => #v[0, 11, 11, 0, 0, -11, -11, 11, -11, 0]
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
  | 11 => #v[-36, 0, 0, 4, -4, -4, -4, -4, 4, 0]
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
  | 0 => #v[22, 0, 0, 22, 0, 22, 22, 22, 0, 0]
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

theorem XZ_scale_0 : toVec (XZ 0) = (scale : ℚ) • XCell5_0 :=
  toVec_eq_smul_of_scaledZ (XZ 0) scale XCell5_0_scaled (by decide) rfl

theorem XZ_scale_1 : toVec (XZ 1) = (scale : ℚ) • XCell5_1 :=
  toVec_eq_smul_of_scaledZ (XZ 1) scale XCell5_1_scaled (by decide) rfl

theorem XZ_scale_2 : toVec (XZ 2) = (scale : ℚ) • XCell5_2 :=
  toVec_eq_smul_of_scaledZ (XZ 2) scale XCell5_2_scaled (by decide) rfl

theorem XZ_scale_3 : toVec (XZ 3) = (scale : ℚ) • XCell5_3 :=
  toVec_eq_smul_of_scaledZ (XZ 3) scale XCell5_3_scaled (by decide) rfl

theorem XZ_scale_4 : toVec (XZ 4) = (scale : ℚ) • XCell5_4 :=
  toVec_eq_smul_of_scaledZ (XZ 4) scale XCell5_4_scaled (by decide) rfl

theorem XZ_scale_5 : toVec (XZ 5) = (scale : ℚ) • XCell5_5 :=
  toVec_eq_smul_of_scaledZ (XZ 5) scale XCell5_5_scaled (by decide) rfl

theorem XZ_scale_6 : toVec (XZ 6) = (scale : ℚ) • XCell5_6 :=
  toVec_eq_smul_of_scaledZ (XZ 6) scale XCell5_6_scaled (by decide) rfl

theorem XZ_scale_7 : toVec (XZ 7) = (scale : ℚ) • XCell5_7 :=
  toVec_eq_smul_of_scaledZ (XZ 7) scale XCell5_7_scaled (by decide) rfl

theorem XZ_scale_8 : toVec (XZ 8) = (scale : ℚ) • XCell5_8 :=
  toVec_eq_smul_of_scaledZ (XZ 8) scale XCell5_8_scaled (by decide) rfl

theorem XZ_scale_9 : toVec (XZ 9) = (scale : ℚ) • XCell5_9 :=
  toVec_eq_smul_of_scaledZ (XZ 9) scale XCell5_9_scaled (by decide) rfl

theorem XZ_scale_10 : toVec (XZ 10) = (scale : ℚ) • XCell5_10 :=
  toVec_eq_smul_of_scaledZ (XZ 10) scale XCell5_10_scaled (by decide) rfl

theorem XZ_scale_11 : toVec (XZ 11) = (scale : ℚ) • XCell5_11 :=
  toVec_eq_smul_of_scaledZ (XZ 11) scale XCell5_11_scaled (by decide) rfl

theorem XZ_scale_12 : toVec (XZ 12) = (scale : ℚ) • XCell5_12 :=
  toVec_eq_smul_of_scaledZ (XZ 12) scale XCell5_12_scaled (by decide) rfl

theorem XZ_scale_13 : toVec (XZ 13) = (scale : ℚ) • XCell5_13 :=
  toVec_eq_smul_of_scaledZ (XZ 13) scale XCell5_13_scaled (by decide) rfl

theorem XZ_scale_14 : toVec (XZ 14) = (scale : ℚ) • XCell5_14 :=
  toVec_eq_smul_of_scaledZ (XZ 14) scale XCell5_14_scaled (by decide) rfl

theorem XZ_scale_15 : toVec (XZ 15) = (scale : ℚ) • XCell5_15 :=
  toVec_eq_smul_of_scaledZ (XZ 15) scale XCell5_15_scaled (by decide) rfl

theorem XZ_scale_16 : toVec (XZ 16) = (scale : ℚ) • XCell5_16 :=
  toVec_eq_smul_of_scaledZ (XZ 16) scale XCell5_16_scaled (by decide) rfl

theorem XZ_scale_17 : toVec (XZ 17) = (scale : ℚ) • XCell5_17 :=
  toVec_eq_smul_of_scaledZ (XZ 17) scale XCell5_17_scaled (by decide) rfl

theorem XZ_scale_18 : toVec (XZ 18) = (scale : ℚ) • XCell5_18 :=
  toVec_eq_smul_of_scaledZ (XZ 18) scale XCell5_18_scaled (by decide) rfl

theorem XZ_scale_19 : toVec (XZ 19) = (scale : ℚ) • XCell5_19 :=
  toVec_eq_smul_of_scaledZ (XZ 19) scale XCell5_19_scaled (by decide) rfl

theorem XZ_scale (k : Fin 20) :
    toVec (XZ k) = (scale : ℚ) • XVec (5 : Fin 10) k :=
  forall_fin20 (P := fun k => toVec (XZ k) = (scale : ℚ) • XVec (5 : Fin 10) k)
    (toVec_smul_congr XZ_scale_0 XVec_apply_5_0)
    (toVec_smul_congr XZ_scale_1 XVec_apply_5_1)
    (toVec_smul_congr XZ_scale_2 XVec_apply_5_2)
    (toVec_smul_congr XZ_scale_3 XVec_apply_5_3)
    (toVec_smul_congr XZ_scale_4 XVec_apply_5_4)
    (toVec_smul_congr XZ_scale_5 XVec_apply_5_5)
    (toVec_smul_congr XZ_scale_6 XVec_apply_5_6)
    (toVec_smul_congr XZ_scale_7 XVec_apply_5_7)
    (toVec_smul_congr XZ_scale_8 XVec_apply_5_8)
    (toVec_smul_congr XZ_scale_9 XVec_apply_5_9)
    (toVec_smul_congr XZ_scale_10 XVec_apply_5_10)
    (toVec_smul_congr XZ_scale_11 XVec_apply_5_11)
    (toVec_smul_congr XZ_scale_12 XVec_apply_5_12)
    (toVec_smul_congr XZ_scale_13 XVec_apply_5_13)
    (toVec_smul_congr XZ_scale_14 XVec_apply_5_14)
    (toVec_smul_congr XZ_scale_15 XVec_apply_5_15)
    (toVec_smul_congr XZ_scale_16 XVec_apply_5_16)
    (toVec_smul_congr XZ_scale_17 XVec_apply_5_17)
    (toVec_smul_congr XZ_scale_18 XVec_apply_5_18)
    (toVec_smul_congr XZ_scale_19 XVec_apply_5_19)
    k

theorem AZ_scale_0 : toVec (AZ 0) = (scale : ℚ) • ACell0_1 :=
  toVec_eq_smul_of_scaledZ (AZ 0) scale ACell0_1_scaled (by decide) rfl

theorem AZ_scale_1 : toVec (AZ 1) = (scale : ℚ) • ACell1_1 :=
  toVec_eq_smul_of_scaledZ (AZ 1) scale ACell1_1_scaled (by decide) rfl

theorem AZ_scale_2 : toVec (AZ 2) = (scale : ℚ) • ACell2_1 :=
  toVec_eq_smul_of_scaledZ (AZ 2) scale ACell2_1_scaled (by decide) rfl

theorem AZ_scale_3 : toVec (AZ 3) = (scale : ℚ) • ACell3_1 :=
  toVec_eq_smul_of_scaledZ (AZ 3) scale ACell3_1_scaled (by decide) rfl

theorem AZ_scale_4 : toVec (AZ 4) = (scale : ℚ) • ACell4_1 :=
  toVec_eq_smul_of_scaledZ (AZ 4) scale ACell4_1_scaled (by decide) rfl

theorem AZ_scale_5 : toVec (AZ 5) = (scale : ℚ) • ACell5_1 :=
  toVec_eq_smul_of_scaledZ (AZ 5) scale ACell5_1_scaled (by decide) rfl

theorem AZ_scale_6 : toVec (AZ 6) = (scale : ℚ) • ACell6_1 :=
  toVec_eq_smul_of_scaledZ (AZ 6) scale ACell6_1_scaled (by decide) rfl

theorem AZ_scale_7 : toVec (AZ 7) = (scale : ℚ) • ACell7_1 :=
  toVec_eq_smul_of_scaledZ (AZ 7) scale ACell7_1_scaled (by decide) rfl

theorem AZ_scale_8 : toVec (AZ 8) = (scale : ℚ) • ACell8_1 :=
  toVec_eq_smul_of_scaledZ (AZ 8) scale ACell8_1_scaled (by decide) rfl

theorem AZ_scale_9 : toVec (AZ 9) = (scale : ℚ) • ACell9_1 :=
  toVec_eq_smul_of_scaledZ (AZ 9) scale ACell9_1_scaled (by decide) rfl

theorem AZ_scale_10 : toVec (AZ 10) = (scale : ℚ) • ACell10_1 :=
  toVec_eq_smul_of_scaledZ (AZ 10) scale ACell10_1_scaled (by decide) rfl

theorem AZ_scale_11 : toVec (AZ 11) = (scale : ℚ) • ACell11_1 :=
  toVec_eq_smul_of_scaledZ (AZ 11) scale ACell11_1_scaled (by decide) rfl

theorem AZ_scale_12 : toVec (AZ 12) = (scale : ℚ) • ACell12_1 :=
  toVec_eq_smul_of_scaledZ (AZ 12) scale ACell12_1_scaled (by decide) rfl

theorem AZ_scale_13 : toVec (AZ 13) = (scale : ℚ) • ACell13_1 :=
  toVec_eq_smul_of_scaledZ (AZ 13) scale ACell13_1_scaled (by decide) rfl

theorem AZ_scale_14 : toVec (AZ 14) = (scale : ℚ) • ACell14_1 :=
  toVec_eq_smul_of_scaledZ (AZ 14) scale ACell14_1_scaled (by decide) rfl

theorem AZ_scale_15 : toVec (AZ 15) = (scale : ℚ) • ACell15_1 :=
  toVec_eq_smul_of_scaledZ (AZ 15) scale ACell15_1_scaled (by decide) rfl

theorem AZ_scale_16 : toVec (AZ 16) = (scale : ℚ) • ACell16_1 :=
  toVec_eq_smul_of_scaledZ (AZ 16) scale ACell16_1_scaled (by decide) rfl

theorem AZ_scale_17 : toVec (AZ 17) = (scale : ℚ) • ACell17_1 :=
  toVec_eq_smul_of_scaledZ (AZ 17) scale ACell17_1_scaled (by decide) rfl

theorem AZ_scale_18 : toVec (AZ 18) = (scale : ℚ) • ACell18_1 :=
  toVec_eq_smul_of_scaledZ (AZ 18) scale ACell18_1_scaled (by decide) rfl

theorem AZ_scale_19 : toVec (AZ 19) = (scale : ℚ) • ACell19_1 :=
  toVec_eq_smul_of_scaledZ (AZ 19) scale ACell19_1_scaled (by decide) rfl

theorem AZ_scale (k : Fin 20) :
    toVec (AZ k) = (scale : ℚ) • AVec k (1 : Fin 10) :=
  forall_fin20 (P := fun k => toVec (AZ k) = (scale : ℚ) • AVec k (1 : Fin 10))
    (toVec_smul_congr AZ_scale_0 AVec_apply_0_1)
    (toVec_smul_congr AZ_scale_1 AVec_apply_1_1)
    (toVec_smul_congr AZ_scale_2 AVec_apply_2_1)
    (toVec_smul_congr AZ_scale_3 AVec_apply_3_1)
    (toVec_smul_congr AZ_scale_4 AVec_apply_4_1)
    (toVec_smul_congr AZ_scale_5 AVec_apply_5_1)
    (toVec_smul_congr AZ_scale_6 AVec_apply_6_1)
    (toVec_smul_congr AZ_scale_7 AVec_apply_7_1)
    (toVec_smul_congr AZ_scale_8 AVec_apply_8_1)
    (toVec_smul_congr AZ_scale_9 AVec_apply_9_1)
    (toVec_smul_congr AZ_scale_10 AVec_apply_10_1)
    (toVec_smul_congr AZ_scale_11 AVec_apply_11_1)
    (toVec_smul_congr AZ_scale_12 AVec_apply_12_1)
    (toVec_smul_congr AZ_scale_13 AVec_apply_13_1)
    (toVec_smul_congr AZ_scale_14 AVec_apply_14_1)
    (toVec_smul_congr AZ_scale_15 AVec_apply_15_1)
    (toVec_smul_congr AZ_scale_16 AVec_apply_16_1)
    (toVec_smul_congr AZ_scale_17 AVec_apply_17_1)
    (toVec_smul_congr AZ_scale_18 AVec_apply_18_1)
    (toVec_smul_congr AZ_scale_19 AVec_apply_19_1)
    k

theorem KZ_scale_0 : toVec (KZ 0) = (scale : ℚ) • KCell5_0 :=
  toVec_eq_smul_of_scaledZ (KZ 0) scale KCell5_0_scaled (by decide) rfl

theorem KZ_scale (k : Fin 1) :
    toVec (KZ k) = (scale : ℚ) • KVec (5 : Fin 10) k :=
  forall_fin1 (P := fun k => toVec (KZ k) = (scale : ℚ) • KVec (5 : Fin 10) k)
    (toVec_smul_congr KZ_scale_0 KVec_apply_5_0)
    k

theorem YZ_scale_0 : toVec (YZ 0) = (scale : ℚ) • YCell0_1 :=
  toVec_eq_smul_of_scaledZ (YZ 0) scale YCell0_1_scaled (by decide) rfl

theorem YZ_scale (k : Fin 1) :
    toVec (YZ k) = (scale : ℚ) • YVec k (1 : Fin 10) :=
  forall_fin1 (P := fun k => toVec (YZ k) = (scale : ℚ) • YVec k (1 : Fin 10))
    (toVec_smul_congr YZ_scale_0 YVec_apply_0_1)
    k

theorem entry_eq :
    (matrixMul XVec AVec + matrixMul KVec YVec)
        (5 : Fin 10) (1 : Fin 10) = ![0, 0, 0, 0, 0, 0, 0, 0, 0, 0] := by
  rw [Matrix.add_apply, matrixMul_apply, matrixMul_apply]
  refine add_sum_mul_eq_of_scaled scale scale_ne_zero
    (fun k => XVec (5 : Fin 10) k)
    (fun k => AVec k (1 : Fin 10))
    (fun k => KVec (5 : Fin 10) k)
    (fun k => YVec k (1 : Fin 10))
    XZ AZ KZ YZ XZ_scale AZ_scale KZ_scale YZ_scale entryZ rfl _ ?_
  rw [entryZ_eq, toVec_zeroZ_smul, vec_zero_eq]

theorem entry_eq_matrixOne :
    (matrixMul XVec AVec + matrixMul KVec YVec)
        (5 : Fin 10) (1 : Fin 10) =
      matrixOne (Fin 10) (5 : Fin 10) (1 : Fin 10) :=
  entry_eq.trans (matrixOne_off10 (5 : Fin 10) (1 : Fin 10) (by decide)).symm

end V14Formalization.D12PieceAPSplitEntry5_1


namespace V14Formalization.D12PieceAPSplitEntry5_2
open D12CyclotomicVec D12CyclotomicVecZ D12PieceAPData
def payloadSha256 : String := "76c6196f29afe1a8398af99502447f48ebeed4bcb3805fc5dbec693940bc04b0"

def scale : ℤ := 44

def XZ (k : Fin 20) : VecZ :=
  match k.val with
  | 0 => #v[-27, -34, -51, -12, -13, -86, -28, -22, -26, -86]
  | 1 => #v[-7, -3, -20, -10, 0, -16, -7, 0, 9, -12]
  | 2 => #v[76, 28, 95, 45, 23, 101, 37, 79, -13, 134]
  | 3 => #v[-69, -14, -29, -51, -37, -32, 5, -76, -2, -36]
  | 4 => #v[14, 6, -1, 21, 24, 1, 15, 19, -5, -6]
  | 5 => #v[104, -10, 6, 56, 46, 22, 0, 104, 0, 24]
  | 6 => #v[-34, -52, -60, -10, -8, -60, -16, -42, -14, -78]
  | 7 => #v[108, -26, 42, 60, 20, 42, -6, 124, -46, 78]
  | 8 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  | 9 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  | 10 => #v[0, 11, 11, 0, 0, -11, -11, 11, -11, 0]
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
  | 12 => #v[-36, 0, -4, -4, 4, 0, 0, 4, -4, -4]
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
  | 0 => #v[22, 0, 0, 22, 0, 22, 22, 22, 0, 0]
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

theorem XZ_scale_0 : toVec (XZ 0) = (scale : ℚ) • XCell5_0 :=
  toVec_eq_smul_of_scaledZ (XZ 0) scale XCell5_0_scaled (by decide) rfl

theorem XZ_scale_1 : toVec (XZ 1) = (scale : ℚ) • XCell5_1 :=
  toVec_eq_smul_of_scaledZ (XZ 1) scale XCell5_1_scaled (by decide) rfl

theorem XZ_scale_2 : toVec (XZ 2) = (scale : ℚ) • XCell5_2 :=
  toVec_eq_smul_of_scaledZ (XZ 2) scale XCell5_2_scaled (by decide) rfl

theorem XZ_scale_3 : toVec (XZ 3) = (scale : ℚ) • XCell5_3 :=
  toVec_eq_smul_of_scaledZ (XZ 3) scale XCell5_3_scaled (by decide) rfl

theorem XZ_scale_4 : toVec (XZ 4) = (scale : ℚ) • XCell5_4 :=
  toVec_eq_smul_of_scaledZ (XZ 4) scale XCell5_4_scaled (by decide) rfl

theorem XZ_scale_5 : toVec (XZ 5) = (scale : ℚ) • XCell5_5 :=
  toVec_eq_smul_of_scaledZ (XZ 5) scale XCell5_5_scaled (by decide) rfl

theorem XZ_scale_6 : toVec (XZ 6) = (scale : ℚ) • XCell5_6 :=
  toVec_eq_smul_of_scaledZ (XZ 6) scale XCell5_6_scaled (by decide) rfl

theorem XZ_scale_7 : toVec (XZ 7) = (scale : ℚ) • XCell5_7 :=
  toVec_eq_smul_of_scaledZ (XZ 7) scale XCell5_7_scaled (by decide) rfl

theorem XZ_scale_8 : toVec (XZ 8) = (scale : ℚ) • XCell5_8 :=
  toVec_eq_smul_of_scaledZ (XZ 8) scale XCell5_8_scaled (by decide) rfl

theorem XZ_scale_9 : toVec (XZ 9) = (scale : ℚ) • XCell5_9 :=
  toVec_eq_smul_of_scaledZ (XZ 9) scale XCell5_9_scaled (by decide) rfl

theorem XZ_scale_10 : toVec (XZ 10) = (scale : ℚ) • XCell5_10 :=
  toVec_eq_smul_of_scaledZ (XZ 10) scale XCell5_10_scaled (by decide) rfl

theorem XZ_scale_11 : toVec (XZ 11) = (scale : ℚ) • XCell5_11 :=
  toVec_eq_smul_of_scaledZ (XZ 11) scale XCell5_11_scaled (by decide) rfl

theorem XZ_scale_12 : toVec (XZ 12) = (scale : ℚ) • XCell5_12 :=
  toVec_eq_smul_of_scaledZ (XZ 12) scale XCell5_12_scaled (by decide) rfl

theorem XZ_scale_13 : toVec (XZ 13) = (scale : ℚ) • XCell5_13 :=
  toVec_eq_smul_of_scaledZ (XZ 13) scale XCell5_13_scaled (by decide) rfl

theorem XZ_scale_14 : toVec (XZ 14) = (scale : ℚ) • XCell5_14 :=
  toVec_eq_smul_of_scaledZ (XZ 14) scale XCell5_14_scaled (by decide) rfl

theorem XZ_scale_15 : toVec (XZ 15) = (scale : ℚ) • XCell5_15 :=
  toVec_eq_smul_of_scaledZ (XZ 15) scale XCell5_15_scaled (by decide) rfl

theorem XZ_scale_16 : toVec (XZ 16) = (scale : ℚ) • XCell5_16 :=
  toVec_eq_smul_of_scaledZ (XZ 16) scale XCell5_16_scaled (by decide) rfl

theorem XZ_scale_17 : toVec (XZ 17) = (scale : ℚ) • XCell5_17 :=
  toVec_eq_smul_of_scaledZ (XZ 17) scale XCell5_17_scaled (by decide) rfl

theorem XZ_scale_18 : toVec (XZ 18) = (scale : ℚ) • XCell5_18 :=
  toVec_eq_smul_of_scaledZ (XZ 18) scale XCell5_18_scaled (by decide) rfl

theorem XZ_scale_19 : toVec (XZ 19) = (scale : ℚ) • XCell5_19 :=
  toVec_eq_smul_of_scaledZ (XZ 19) scale XCell5_19_scaled (by decide) rfl

theorem XZ_scale (k : Fin 20) :
    toVec (XZ k) = (scale : ℚ) • XVec (5 : Fin 10) k :=
  forall_fin20 (P := fun k => toVec (XZ k) = (scale : ℚ) • XVec (5 : Fin 10) k)
    (toVec_smul_congr XZ_scale_0 XVec_apply_5_0)
    (toVec_smul_congr XZ_scale_1 XVec_apply_5_1)
    (toVec_smul_congr XZ_scale_2 XVec_apply_5_2)
    (toVec_smul_congr XZ_scale_3 XVec_apply_5_3)
    (toVec_smul_congr XZ_scale_4 XVec_apply_5_4)
    (toVec_smul_congr XZ_scale_5 XVec_apply_5_5)
    (toVec_smul_congr XZ_scale_6 XVec_apply_5_6)
    (toVec_smul_congr XZ_scale_7 XVec_apply_5_7)
    (toVec_smul_congr XZ_scale_8 XVec_apply_5_8)
    (toVec_smul_congr XZ_scale_9 XVec_apply_5_9)
    (toVec_smul_congr XZ_scale_10 XVec_apply_5_10)
    (toVec_smul_congr XZ_scale_11 XVec_apply_5_11)
    (toVec_smul_congr XZ_scale_12 XVec_apply_5_12)
    (toVec_smul_congr XZ_scale_13 XVec_apply_5_13)
    (toVec_smul_congr XZ_scale_14 XVec_apply_5_14)
    (toVec_smul_congr XZ_scale_15 XVec_apply_5_15)
    (toVec_smul_congr XZ_scale_16 XVec_apply_5_16)
    (toVec_smul_congr XZ_scale_17 XVec_apply_5_17)
    (toVec_smul_congr XZ_scale_18 XVec_apply_5_18)
    (toVec_smul_congr XZ_scale_19 XVec_apply_5_19)
    k

theorem AZ_scale_0 : toVec (AZ 0) = (scale : ℚ) • ACell0_2 :=
  toVec_eq_smul_of_scaledZ (AZ 0) scale ACell0_2_scaled (by decide) rfl

theorem AZ_scale_1 : toVec (AZ 1) = (scale : ℚ) • ACell1_2 :=
  toVec_eq_smul_of_scaledZ (AZ 1) scale ACell1_2_scaled (by decide) rfl

theorem AZ_scale_2 : toVec (AZ 2) = (scale : ℚ) • ACell2_2 :=
  toVec_eq_smul_of_scaledZ (AZ 2) scale ACell2_2_scaled (by decide) rfl

theorem AZ_scale_3 : toVec (AZ 3) = (scale : ℚ) • ACell3_2 :=
  toVec_eq_smul_of_scaledZ (AZ 3) scale ACell3_2_scaled (by decide) rfl

theorem AZ_scale_4 : toVec (AZ 4) = (scale : ℚ) • ACell4_2 :=
  toVec_eq_smul_of_scaledZ (AZ 4) scale ACell4_2_scaled (by decide) rfl

theorem AZ_scale_5 : toVec (AZ 5) = (scale : ℚ) • ACell5_2 :=
  toVec_eq_smul_of_scaledZ (AZ 5) scale ACell5_2_scaled (by decide) rfl

theorem AZ_scale_6 : toVec (AZ 6) = (scale : ℚ) • ACell6_2 :=
  toVec_eq_smul_of_scaledZ (AZ 6) scale ACell6_2_scaled (by decide) rfl

theorem AZ_scale_7 : toVec (AZ 7) = (scale : ℚ) • ACell7_2 :=
  toVec_eq_smul_of_scaledZ (AZ 7) scale ACell7_2_scaled (by decide) rfl

theorem AZ_scale_8 : toVec (AZ 8) = (scale : ℚ) • ACell8_2 :=
  toVec_eq_smul_of_scaledZ (AZ 8) scale ACell8_2_scaled (by decide) rfl

theorem AZ_scale_9 : toVec (AZ 9) = (scale : ℚ) • ACell9_2 :=
  toVec_eq_smul_of_scaledZ (AZ 9) scale ACell9_2_scaled (by decide) rfl

theorem AZ_scale_10 : toVec (AZ 10) = (scale : ℚ) • ACell10_2 :=
  toVec_eq_smul_of_scaledZ (AZ 10) scale ACell10_2_scaled (by decide) rfl

theorem AZ_scale_11 : toVec (AZ 11) = (scale : ℚ) • ACell11_2 :=
  toVec_eq_smul_of_scaledZ (AZ 11) scale ACell11_2_scaled (by decide) rfl

theorem AZ_scale_12 : toVec (AZ 12) = (scale : ℚ) • ACell12_2 :=
  toVec_eq_smul_of_scaledZ (AZ 12) scale ACell12_2_scaled (by decide) rfl

theorem AZ_scale_13 : toVec (AZ 13) = (scale : ℚ) • ACell13_2 :=
  toVec_eq_smul_of_scaledZ (AZ 13) scale ACell13_2_scaled (by decide) rfl

theorem AZ_scale_14 : toVec (AZ 14) = (scale : ℚ) • ACell14_2 :=
  toVec_eq_smul_of_scaledZ (AZ 14) scale ACell14_2_scaled (by decide) rfl

theorem AZ_scale_15 : toVec (AZ 15) = (scale : ℚ) • ACell15_2 :=
  toVec_eq_smul_of_scaledZ (AZ 15) scale ACell15_2_scaled (by decide) rfl

theorem AZ_scale_16 : toVec (AZ 16) = (scale : ℚ) • ACell16_2 :=
  toVec_eq_smul_of_scaledZ (AZ 16) scale ACell16_2_scaled (by decide) rfl

theorem AZ_scale_17 : toVec (AZ 17) = (scale : ℚ) • ACell17_2 :=
  toVec_eq_smul_of_scaledZ (AZ 17) scale ACell17_2_scaled (by decide) rfl

theorem AZ_scale_18 : toVec (AZ 18) = (scale : ℚ) • ACell18_2 :=
  toVec_eq_smul_of_scaledZ (AZ 18) scale ACell18_2_scaled (by decide) rfl

theorem AZ_scale_19 : toVec (AZ 19) = (scale : ℚ) • ACell19_2 :=
  toVec_eq_smul_of_scaledZ (AZ 19) scale ACell19_2_scaled (by decide) rfl

theorem AZ_scale (k : Fin 20) :
    toVec (AZ k) = (scale : ℚ) • AVec k (2 : Fin 10) :=
  forall_fin20 (P := fun k => toVec (AZ k) = (scale : ℚ) • AVec k (2 : Fin 10))
    (toVec_smul_congr AZ_scale_0 AVec_apply_0_2)
    (toVec_smul_congr AZ_scale_1 AVec_apply_1_2)
    (toVec_smul_congr AZ_scale_2 AVec_apply_2_2)
    (toVec_smul_congr AZ_scale_3 AVec_apply_3_2)
    (toVec_smul_congr AZ_scale_4 AVec_apply_4_2)
    (toVec_smul_congr AZ_scale_5 AVec_apply_5_2)
    (toVec_smul_congr AZ_scale_6 AVec_apply_6_2)
    (toVec_smul_congr AZ_scale_7 AVec_apply_7_2)
    (toVec_smul_congr AZ_scale_8 AVec_apply_8_2)
    (toVec_smul_congr AZ_scale_9 AVec_apply_9_2)
    (toVec_smul_congr AZ_scale_10 AVec_apply_10_2)
    (toVec_smul_congr AZ_scale_11 AVec_apply_11_2)
    (toVec_smul_congr AZ_scale_12 AVec_apply_12_2)
    (toVec_smul_congr AZ_scale_13 AVec_apply_13_2)
    (toVec_smul_congr AZ_scale_14 AVec_apply_14_2)
    (toVec_smul_congr AZ_scale_15 AVec_apply_15_2)
    (toVec_smul_congr AZ_scale_16 AVec_apply_16_2)
    (toVec_smul_congr AZ_scale_17 AVec_apply_17_2)
    (toVec_smul_congr AZ_scale_18 AVec_apply_18_2)
    (toVec_smul_congr AZ_scale_19 AVec_apply_19_2)
    k

theorem KZ_scale_0 : toVec (KZ 0) = (scale : ℚ) • KCell5_0 :=
  toVec_eq_smul_of_scaledZ (KZ 0) scale KCell5_0_scaled (by decide) rfl

theorem KZ_scale (k : Fin 1) :
    toVec (KZ k) = (scale : ℚ) • KVec (5 : Fin 10) k :=
  forall_fin1 (P := fun k => toVec (KZ k) = (scale : ℚ) • KVec (5 : Fin 10) k)
    (toVec_smul_congr KZ_scale_0 KVec_apply_5_0)
    k

theorem YZ_scale_0 : toVec (YZ 0) = (scale : ℚ) • YCell0_2 :=
  toVec_eq_smul_of_scaledZ (YZ 0) scale YCell0_2_scaled (by decide) rfl

theorem YZ_scale (k : Fin 1) :
    toVec (YZ k) = (scale : ℚ) • YVec k (2 : Fin 10) :=
  forall_fin1 (P := fun k => toVec (YZ k) = (scale : ℚ) • YVec k (2 : Fin 10))
    (toVec_smul_congr YZ_scale_0 YVec_apply_0_2)
    k

theorem entry_eq :
    (matrixMul XVec AVec + matrixMul KVec YVec)
        (5 : Fin 10) (2 : Fin 10) = ![0, 0, 0, 0, 0, 0, 0, 0, 0, 0] := by
  rw [Matrix.add_apply, matrixMul_apply, matrixMul_apply]
  refine add_sum_mul_eq_of_scaled scale scale_ne_zero
    (fun k => XVec (5 : Fin 10) k)
    (fun k => AVec k (2 : Fin 10))
    (fun k => KVec (5 : Fin 10) k)
    (fun k => YVec k (2 : Fin 10))
    XZ AZ KZ YZ XZ_scale AZ_scale KZ_scale YZ_scale entryZ rfl _ ?_
  rw [entryZ_eq, toVec_zeroZ_smul, vec_zero_eq]

theorem entry_eq_matrixOne :
    (matrixMul XVec AVec + matrixMul KVec YVec)
        (5 : Fin 10) (2 : Fin 10) =
      matrixOne (Fin 10) (5 : Fin 10) (2 : Fin 10) :=
  entry_eq.trans (matrixOne_off10 (5 : Fin 10) (2 : Fin 10) (by decide)).symm

end V14Formalization.D12PieceAPSplitEntry5_2


namespace V14Formalization.D12PieceAPSplitEntry5_3
open D12CyclotomicVec D12CyclotomicVecZ D12PieceAPData
def payloadSha256 : String := "76c6196f29afe1a8398af99502447f48ebeed4bcb3805fc5dbec693940bc04b0"

def scale : ℤ := 44

def XZ (k : Fin 20) : VecZ :=
  match k.val with
  | 0 => #v[-27, -34, -51, -12, -13, -86, -28, -22, -26, -86]
  | 1 => #v[-7, -3, -20, -10, 0, -16, -7, 0, 9, -12]
  | 2 => #v[76, 28, 95, 45, 23, 101, 37, 79, -13, 134]
  | 3 => #v[-69, -14, -29, -51, -37, -32, 5, -76, -2, -36]
  | 4 => #v[14, 6, -1, 21, 24, 1, 15, 19, -5, -6]
  | 5 => #v[104, -10, 6, 56, 46, 22, 0, 104, 0, 24]
  | 6 => #v[-34, -52, -60, -10, -8, -60, -16, -42, -14, -78]
  | 7 => #v[108, -26, 42, 60, 20, 42, -6, 124, -46, 78]
  | 8 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  | 9 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  | 10 => #v[0, 11, 11, 0, 0, -11, -11, 11, -11, 0]
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
  | 13 => #v[-40, 0, -8, -4, -4, -8, -8, -4, -4, -8]
  | 14 => #v[8, 4, 4, 8, 0, 0, 4, 12, 4, 0]
  | 15 => #v[0, 0, 0, -6, 6, 6, -6, 0, 0, 0]
  | 16 => #v[-6, 0, 0, 0, -6, 0, 0, 6, 6, 0]
  | 17 => #v[0, -6, 0, 0, 6, 0, 6, 0, 0, -6]
  | 18 => #v[0, -6, 0, 6, 0, 6, 0, -6, 0, 0]
  | 19 => #v[0, 0, 0, -6, 6, 0, 0, 0, 6, -6]
  | _ => zeroZ

def KZ (k : Fin 1) : VecZ :=
  match k.val with
  | 0 => #v[22, 0, 0, 22, 0, 22, 22, 22, 0, 0]
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

theorem XZ_scale_0 : toVec (XZ 0) = (scale : ℚ) • XCell5_0 :=
  toVec_eq_smul_of_scaledZ (XZ 0) scale XCell5_0_scaled (by decide) rfl

theorem XZ_scale_1 : toVec (XZ 1) = (scale : ℚ) • XCell5_1 :=
  toVec_eq_smul_of_scaledZ (XZ 1) scale XCell5_1_scaled (by decide) rfl

theorem XZ_scale_2 : toVec (XZ 2) = (scale : ℚ) • XCell5_2 :=
  toVec_eq_smul_of_scaledZ (XZ 2) scale XCell5_2_scaled (by decide) rfl

theorem XZ_scale_3 : toVec (XZ 3) = (scale : ℚ) • XCell5_3 :=
  toVec_eq_smul_of_scaledZ (XZ 3) scale XCell5_3_scaled (by decide) rfl

theorem XZ_scale_4 : toVec (XZ 4) = (scale : ℚ) • XCell5_4 :=
  toVec_eq_smul_of_scaledZ (XZ 4) scale XCell5_4_scaled (by decide) rfl

theorem XZ_scale_5 : toVec (XZ 5) = (scale : ℚ) • XCell5_5 :=
  toVec_eq_smul_of_scaledZ (XZ 5) scale XCell5_5_scaled (by decide) rfl

theorem XZ_scale_6 : toVec (XZ 6) = (scale : ℚ) • XCell5_6 :=
  toVec_eq_smul_of_scaledZ (XZ 6) scale XCell5_6_scaled (by decide) rfl

theorem XZ_scale_7 : toVec (XZ 7) = (scale : ℚ) • XCell5_7 :=
  toVec_eq_smul_of_scaledZ (XZ 7) scale XCell5_7_scaled (by decide) rfl

theorem XZ_scale_8 : toVec (XZ 8) = (scale : ℚ) • XCell5_8 :=
  toVec_eq_smul_of_scaledZ (XZ 8) scale XCell5_8_scaled (by decide) rfl

theorem XZ_scale_9 : toVec (XZ 9) = (scale : ℚ) • XCell5_9 :=
  toVec_eq_smul_of_scaledZ (XZ 9) scale XCell5_9_scaled (by decide) rfl

theorem XZ_scale_10 : toVec (XZ 10) = (scale : ℚ) • XCell5_10 :=
  toVec_eq_smul_of_scaledZ (XZ 10) scale XCell5_10_scaled (by decide) rfl

theorem XZ_scale_11 : toVec (XZ 11) = (scale : ℚ) • XCell5_11 :=
  toVec_eq_smul_of_scaledZ (XZ 11) scale XCell5_11_scaled (by decide) rfl

theorem XZ_scale_12 : toVec (XZ 12) = (scale : ℚ) • XCell5_12 :=
  toVec_eq_smul_of_scaledZ (XZ 12) scale XCell5_12_scaled (by decide) rfl

theorem XZ_scale_13 : toVec (XZ 13) = (scale : ℚ) • XCell5_13 :=
  toVec_eq_smul_of_scaledZ (XZ 13) scale XCell5_13_scaled (by decide) rfl

theorem XZ_scale_14 : toVec (XZ 14) = (scale : ℚ) • XCell5_14 :=
  toVec_eq_smul_of_scaledZ (XZ 14) scale XCell5_14_scaled (by decide) rfl

theorem XZ_scale_15 : toVec (XZ 15) = (scale : ℚ) • XCell5_15 :=
  toVec_eq_smul_of_scaledZ (XZ 15) scale XCell5_15_scaled (by decide) rfl

theorem XZ_scale_16 : toVec (XZ 16) = (scale : ℚ) • XCell5_16 :=
  toVec_eq_smul_of_scaledZ (XZ 16) scale XCell5_16_scaled (by decide) rfl

theorem XZ_scale_17 : toVec (XZ 17) = (scale : ℚ) • XCell5_17 :=
  toVec_eq_smul_of_scaledZ (XZ 17) scale XCell5_17_scaled (by decide) rfl

theorem XZ_scale_18 : toVec (XZ 18) = (scale : ℚ) • XCell5_18 :=
  toVec_eq_smul_of_scaledZ (XZ 18) scale XCell5_18_scaled (by decide) rfl

theorem XZ_scale_19 : toVec (XZ 19) = (scale : ℚ) • XCell5_19 :=
  toVec_eq_smul_of_scaledZ (XZ 19) scale XCell5_19_scaled (by decide) rfl

theorem XZ_scale (k : Fin 20) :
    toVec (XZ k) = (scale : ℚ) • XVec (5 : Fin 10) k :=
  forall_fin20 (P := fun k => toVec (XZ k) = (scale : ℚ) • XVec (5 : Fin 10) k)
    (toVec_smul_congr XZ_scale_0 XVec_apply_5_0)
    (toVec_smul_congr XZ_scale_1 XVec_apply_5_1)
    (toVec_smul_congr XZ_scale_2 XVec_apply_5_2)
    (toVec_smul_congr XZ_scale_3 XVec_apply_5_3)
    (toVec_smul_congr XZ_scale_4 XVec_apply_5_4)
    (toVec_smul_congr XZ_scale_5 XVec_apply_5_5)
    (toVec_smul_congr XZ_scale_6 XVec_apply_5_6)
    (toVec_smul_congr XZ_scale_7 XVec_apply_5_7)
    (toVec_smul_congr XZ_scale_8 XVec_apply_5_8)
    (toVec_smul_congr XZ_scale_9 XVec_apply_5_9)
    (toVec_smul_congr XZ_scale_10 XVec_apply_5_10)
    (toVec_smul_congr XZ_scale_11 XVec_apply_5_11)
    (toVec_smul_congr XZ_scale_12 XVec_apply_5_12)
    (toVec_smul_congr XZ_scale_13 XVec_apply_5_13)
    (toVec_smul_congr XZ_scale_14 XVec_apply_5_14)
    (toVec_smul_congr XZ_scale_15 XVec_apply_5_15)
    (toVec_smul_congr XZ_scale_16 XVec_apply_5_16)
    (toVec_smul_congr XZ_scale_17 XVec_apply_5_17)
    (toVec_smul_congr XZ_scale_18 XVec_apply_5_18)
    (toVec_smul_congr XZ_scale_19 XVec_apply_5_19)
    k

theorem AZ_scale_0 : toVec (AZ 0) = (scale : ℚ) • ACell0_3 :=
  toVec_eq_smul_of_scaledZ (AZ 0) scale ACell0_3_scaled (by decide) rfl

theorem AZ_scale_1 : toVec (AZ 1) = (scale : ℚ) • ACell1_3 :=
  toVec_eq_smul_of_scaledZ (AZ 1) scale ACell1_3_scaled (by decide) rfl

theorem AZ_scale_2 : toVec (AZ 2) = (scale : ℚ) • ACell2_3 :=
  toVec_eq_smul_of_scaledZ (AZ 2) scale ACell2_3_scaled (by decide) rfl

theorem AZ_scale_3 : toVec (AZ 3) = (scale : ℚ) • ACell3_3 :=
  toVec_eq_smul_of_scaledZ (AZ 3) scale ACell3_3_scaled (by decide) rfl

theorem AZ_scale_4 : toVec (AZ 4) = (scale : ℚ) • ACell4_3 :=
  toVec_eq_smul_of_scaledZ (AZ 4) scale ACell4_3_scaled (by decide) rfl

theorem AZ_scale_5 : toVec (AZ 5) = (scale : ℚ) • ACell5_3 :=
  toVec_eq_smul_of_scaledZ (AZ 5) scale ACell5_3_scaled (by decide) rfl

theorem AZ_scale_6 : toVec (AZ 6) = (scale : ℚ) • ACell6_3 :=
  toVec_eq_smul_of_scaledZ (AZ 6) scale ACell6_3_scaled (by decide) rfl

theorem AZ_scale_7 : toVec (AZ 7) = (scale : ℚ) • ACell7_3 :=
  toVec_eq_smul_of_scaledZ (AZ 7) scale ACell7_3_scaled (by decide) rfl

theorem AZ_scale_8 : toVec (AZ 8) = (scale : ℚ) • ACell8_3 :=
  toVec_eq_smul_of_scaledZ (AZ 8) scale ACell8_3_scaled (by decide) rfl

theorem AZ_scale_9 : toVec (AZ 9) = (scale : ℚ) • ACell9_3 :=
  toVec_eq_smul_of_scaledZ (AZ 9) scale ACell9_3_scaled (by decide) rfl

theorem AZ_scale_10 : toVec (AZ 10) = (scale : ℚ) • ACell10_3 :=
  toVec_eq_smul_of_scaledZ (AZ 10) scale ACell10_3_scaled (by decide) rfl

theorem AZ_scale_11 : toVec (AZ 11) = (scale : ℚ) • ACell11_3 :=
  toVec_eq_smul_of_scaledZ (AZ 11) scale ACell11_3_scaled (by decide) rfl

theorem AZ_scale_12 : toVec (AZ 12) = (scale : ℚ) • ACell12_3 :=
  toVec_eq_smul_of_scaledZ (AZ 12) scale ACell12_3_scaled (by decide) rfl

theorem AZ_scale_13 : toVec (AZ 13) = (scale : ℚ) • ACell13_3 :=
  toVec_eq_smul_of_scaledZ (AZ 13) scale ACell13_3_scaled (by decide) rfl

theorem AZ_scale_14 : toVec (AZ 14) = (scale : ℚ) • ACell14_3 :=
  toVec_eq_smul_of_scaledZ (AZ 14) scale ACell14_3_scaled (by decide) rfl

theorem AZ_scale_15 : toVec (AZ 15) = (scale : ℚ) • ACell15_3 :=
  toVec_eq_smul_of_scaledZ (AZ 15) scale ACell15_3_scaled (by decide) rfl

theorem AZ_scale_16 : toVec (AZ 16) = (scale : ℚ) • ACell16_3 :=
  toVec_eq_smul_of_scaledZ (AZ 16) scale ACell16_3_scaled (by decide) rfl

theorem AZ_scale_17 : toVec (AZ 17) = (scale : ℚ) • ACell17_3 :=
  toVec_eq_smul_of_scaledZ (AZ 17) scale ACell17_3_scaled (by decide) rfl

theorem AZ_scale_18 : toVec (AZ 18) = (scale : ℚ) • ACell18_3 :=
  toVec_eq_smul_of_scaledZ (AZ 18) scale ACell18_3_scaled (by decide) rfl

theorem AZ_scale_19 : toVec (AZ 19) = (scale : ℚ) • ACell19_3 :=
  toVec_eq_smul_of_scaledZ (AZ 19) scale ACell19_3_scaled (by decide) rfl

theorem AZ_scale (k : Fin 20) :
    toVec (AZ k) = (scale : ℚ) • AVec k (3 : Fin 10) :=
  forall_fin20 (P := fun k => toVec (AZ k) = (scale : ℚ) • AVec k (3 : Fin 10))
    (toVec_smul_congr AZ_scale_0 AVec_apply_0_3)
    (toVec_smul_congr AZ_scale_1 AVec_apply_1_3)
    (toVec_smul_congr AZ_scale_2 AVec_apply_2_3)
    (toVec_smul_congr AZ_scale_3 AVec_apply_3_3)
    (toVec_smul_congr AZ_scale_4 AVec_apply_4_3)
    (toVec_smul_congr AZ_scale_5 AVec_apply_5_3)
    (toVec_smul_congr AZ_scale_6 AVec_apply_6_3)
    (toVec_smul_congr AZ_scale_7 AVec_apply_7_3)
    (toVec_smul_congr AZ_scale_8 AVec_apply_8_3)
    (toVec_smul_congr AZ_scale_9 AVec_apply_9_3)
    (toVec_smul_congr AZ_scale_10 AVec_apply_10_3)
    (toVec_smul_congr AZ_scale_11 AVec_apply_11_3)
    (toVec_smul_congr AZ_scale_12 AVec_apply_12_3)
    (toVec_smul_congr AZ_scale_13 AVec_apply_13_3)
    (toVec_smul_congr AZ_scale_14 AVec_apply_14_3)
    (toVec_smul_congr AZ_scale_15 AVec_apply_15_3)
    (toVec_smul_congr AZ_scale_16 AVec_apply_16_3)
    (toVec_smul_congr AZ_scale_17 AVec_apply_17_3)
    (toVec_smul_congr AZ_scale_18 AVec_apply_18_3)
    (toVec_smul_congr AZ_scale_19 AVec_apply_19_3)
    k

theorem KZ_scale_0 : toVec (KZ 0) = (scale : ℚ) • KCell5_0 :=
  toVec_eq_smul_of_scaledZ (KZ 0) scale KCell5_0_scaled (by decide) rfl

theorem KZ_scale (k : Fin 1) :
    toVec (KZ k) = (scale : ℚ) • KVec (5 : Fin 10) k :=
  forall_fin1 (P := fun k => toVec (KZ k) = (scale : ℚ) • KVec (5 : Fin 10) k)
    (toVec_smul_congr KZ_scale_0 KVec_apply_5_0)
    k

theorem YZ_scale_0 : toVec (YZ 0) = (scale : ℚ) • YCell0_3 :=
  toVec_eq_smul_of_scaledZ (YZ 0) scale YCell0_3_scaled (by decide) rfl

theorem YZ_scale (k : Fin 1) :
    toVec (YZ k) = (scale : ℚ) • YVec k (3 : Fin 10) :=
  forall_fin1 (P := fun k => toVec (YZ k) = (scale : ℚ) • YVec k (3 : Fin 10))
    (toVec_smul_congr YZ_scale_0 YVec_apply_0_3)
    k

theorem entry_eq :
    (matrixMul XVec AVec + matrixMul KVec YVec)
        (5 : Fin 10) (3 : Fin 10) = ![0, 0, 0, 0, 0, 0, 0, 0, 0, 0] := by
  rw [Matrix.add_apply, matrixMul_apply, matrixMul_apply]
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
      matrixOne (Fin 10) (5 : Fin 10) (3 : Fin 10) :=
  entry_eq.trans (matrixOne_off10 (5 : Fin 10) (3 : Fin 10) (by decide)).symm

end V14Formalization.D12PieceAPSplitEntry5_3


namespace V14Formalization.D12PieceAPSplitEntry5_4
open D12CyclotomicVec D12CyclotomicVecZ D12PieceAPData
def payloadSha256 : String := "76c6196f29afe1a8398af99502447f48ebeed4bcb3805fc5dbec693940bc04b0"

def scale : ℤ := 44

def XZ (k : Fin 20) : VecZ :=
  match k.val with
  | 0 => #v[-27, -34, -51, -12, -13, -86, -28, -22, -26, -86]
  | 1 => #v[-7, -3, -20, -10, 0, -16, -7, 0, 9, -12]
  | 2 => #v[76, 28, 95, 45, 23, 101, 37, 79, -13, 134]
  | 3 => #v[-69, -14, -29, -51, -37, -32, 5, -76, -2, -36]
  | 4 => #v[14, 6, -1, 21, 24, 1, 15, 19, -5, -6]
  | 5 => #v[104, -10, 6, 56, 46, 22, 0, 104, 0, 24]
  | 6 => #v[-34, -52, -60, -10, -8, -60, -16, -42, -14, -78]
  | 7 => #v[108, -26, 42, 60, 20, 42, -6, 124, -46, 78]
  | 8 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  | 9 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  | 10 => #v[0, 11, 11, 0, 0, -11, -11, 11, -11, 0]
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
  | 14 => #v[-32, 0, 4, 0, 4, 8, 8, 4, 0, 4]
  | 15 => #v[0, 6, 0, 0, 0, 6, 0, 0, -6, -6]
  | 16 => #v[0, 0, 0, -6, 6, 0, 0, 0, 6, -6]
  | 17 => #v[0, 0, 6, -6, -6, 6, 0, 0, 0, 0]
  | 18 => #v[0, 6, 0, 0, 6, 0, 0, -6, 0, -6]
  | 19 => #v[-6, 0, 6, 0, 0, 0, 0, 6, 0, -6]
  | _ => zeroZ

def KZ (k : Fin 1) : VecZ :=
  match k.val with
  | 0 => #v[22, 0, 0, 22, 0, 22, 22, 22, 0, 0]
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

theorem XZ_scale_0 : toVec (XZ 0) = (scale : ℚ) • XCell5_0 :=
  toVec_eq_smul_of_scaledZ (XZ 0) scale XCell5_0_scaled (by decide) rfl

theorem XZ_scale_1 : toVec (XZ 1) = (scale : ℚ) • XCell5_1 :=
  toVec_eq_smul_of_scaledZ (XZ 1) scale XCell5_1_scaled (by decide) rfl

theorem XZ_scale_2 : toVec (XZ 2) = (scale : ℚ) • XCell5_2 :=
  toVec_eq_smul_of_scaledZ (XZ 2) scale XCell5_2_scaled (by decide) rfl

theorem XZ_scale_3 : toVec (XZ 3) = (scale : ℚ) • XCell5_3 :=
  toVec_eq_smul_of_scaledZ (XZ 3) scale XCell5_3_scaled (by decide) rfl

theorem XZ_scale_4 : toVec (XZ 4) = (scale : ℚ) • XCell5_4 :=
  toVec_eq_smul_of_scaledZ (XZ 4) scale XCell5_4_scaled (by decide) rfl

theorem XZ_scale_5 : toVec (XZ 5) = (scale : ℚ) • XCell5_5 :=
  toVec_eq_smul_of_scaledZ (XZ 5) scale XCell5_5_scaled (by decide) rfl

theorem XZ_scale_6 : toVec (XZ 6) = (scale : ℚ) • XCell5_6 :=
  toVec_eq_smul_of_scaledZ (XZ 6) scale XCell5_6_scaled (by decide) rfl

theorem XZ_scale_7 : toVec (XZ 7) = (scale : ℚ) • XCell5_7 :=
  toVec_eq_smul_of_scaledZ (XZ 7) scale XCell5_7_scaled (by decide) rfl

theorem XZ_scale_8 : toVec (XZ 8) = (scale : ℚ) • XCell5_8 :=
  toVec_eq_smul_of_scaledZ (XZ 8) scale XCell5_8_scaled (by decide) rfl

theorem XZ_scale_9 : toVec (XZ 9) = (scale : ℚ) • XCell5_9 :=
  toVec_eq_smul_of_scaledZ (XZ 9) scale XCell5_9_scaled (by decide) rfl

theorem XZ_scale_10 : toVec (XZ 10) = (scale : ℚ) • XCell5_10 :=
  toVec_eq_smul_of_scaledZ (XZ 10) scale XCell5_10_scaled (by decide) rfl

theorem XZ_scale_11 : toVec (XZ 11) = (scale : ℚ) • XCell5_11 :=
  toVec_eq_smul_of_scaledZ (XZ 11) scale XCell5_11_scaled (by decide) rfl

theorem XZ_scale_12 : toVec (XZ 12) = (scale : ℚ) • XCell5_12 :=
  toVec_eq_smul_of_scaledZ (XZ 12) scale XCell5_12_scaled (by decide) rfl

theorem XZ_scale_13 : toVec (XZ 13) = (scale : ℚ) • XCell5_13 :=
  toVec_eq_smul_of_scaledZ (XZ 13) scale XCell5_13_scaled (by decide) rfl

theorem XZ_scale_14 : toVec (XZ 14) = (scale : ℚ) • XCell5_14 :=
  toVec_eq_smul_of_scaledZ (XZ 14) scale XCell5_14_scaled (by decide) rfl

theorem XZ_scale_15 : toVec (XZ 15) = (scale : ℚ) • XCell5_15 :=
  toVec_eq_smul_of_scaledZ (XZ 15) scale XCell5_15_scaled (by decide) rfl

theorem XZ_scale_16 : toVec (XZ 16) = (scale : ℚ) • XCell5_16 :=
  toVec_eq_smul_of_scaledZ (XZ 16) scale XCell5_16_scaled (by decide) rfl

theorem XZ_scale_17 : toVec (XZ 17) = (scale : ℚ) • XCell5_17 :=
  toVec_eq_smul_of_scaledZ (XZ 17) scale XCell5_17_scaled (by decide) rfl

theorem XZ_scale_18 : toVec (XZ 18) = (scale : ℚ) • XCell5_18 :=
  toVec_eq_smul_of_scaledZ (XZ 18) scale XCell5_18_scaled (by decide) rfl

theorem XZ_scale_19 : toVec (XZ 19) = (scale : ℚ) • XCell5_19 :=
  toVec_eq_smul_of_scaledZ (XZ 19) scale XCell5_19_scaled (by decide) rfl

theorem XZ_scale (k : Fin 20) :
    toVec (XZ k) = (scale : ℚ) • XVec (5 : Fin 10) k :=
  forall_fin20 (P := fun k => toVec (XZ k) = (scale : ℚ) • XVec (5 : Fin 10) k)
    (toVec_smul_congr XZ_scale_0 XVec_apply_5_0)
    (toVec_smul_congr XZ_scale_1 XVec_apply_5_1)
    (toVec_smul_congr XZ_scale_2 XVec_apply_5_2)
    (toVec_smul_congr XZ_scale_3 XVec_apply_5_3)
    (toVec_smul_congr XZ_scale_4 XVec_apply_5_4)
    (toVec_smul_congr XZ_scale_5 XVec_apply_5_5)
    (toVec_smul_congr XZ_scale_6 XVec_apply_5_6)
    (toVec_smul_congr XZ_scale_7 XVec_apply_5_7)
    (toVec_smul_congr XZ_scale_8 XVec_apply_5_8)
    (toVec_smul_congr XZ_scale_9 XVec_apply_5_9)
    (toVec_smul_congr XZ_scale_10 XVec_apply_5_10)
    (toVec_smul_congr XZ_scale_11 XVec_apply_5_11)
    (toVec_smul_congr XZ_scale_12 XVec_apply_5_12)
    (toVec_smul_congr XZ_scale_13 XVec_apply_5_13)
    (toVec_smul_congr XZ_scale_14 XVec_apply_5_14)
    (toVec_smul_congr XZ_scale_15 XVec_apply_5_15)
    (toVec_smul_congr XZ_scale_16 XVec_apply_5_16)
    (toVec_smul_congr XZ_scale_17 XVec_apply_5_17)
    (toVec_smul_congr XZ_scale_18 XVec_apply_5_18)
    (toVec_smul_congr XZ_scale_19 XVec_apply_5_19)
    k

theorem AZ_scale_0 : toVec (AZ 0) = (scale : ℚ) • ACell0_4 :=
  toVec_eq_smul_of_scaledZ (AZ 0) scale ACell0_4_scaled (by decide) rfl

theorem AZ_scale_1 : toVec (AZ 1) = (scale : ℚ) • ACell1_4 :=
  toVec_eq_smul_of_scaledZ (AZ 1) scale ACell1_4_scaled (by decide) rfl

theorem AZ_scale_2 : toVec (AZ 2) = (scale : ℚ) • ACell2_4 :=
  toVec_eq_smul_of_scaledZ (AZ 2) scale ACell2_4_scaled (by decide) rfl

theorem AZ_scale_3 : toVec (AZ 3) = (scale : ℚ) • ACell3_4 :=
  toVec_eq_smul_of_scaledZ (AZ 3) scale ACell3_4_scaled (by decide) rfl

theorem AZ_scale_4 : toVec (AZ 4) = (scale : ℚ) • ACell4_4 :=
  toVec_eq_smul_of_scaledZ (AZ 4) scale ACell4_4_scaled (by decide) rfl

theorem AZ_scale_5 : toVec (AZ 5) = (scale : ℚ) • ACell5_4 :=
  toVec_eq_smul_of_scaledZ (AZ 5) scale ACell5_4_scaled (by decide) rfl

theorem AZ_scale_6 : toVec (AZ 6) = (scale : ℚ) • ACell6_4 :=
  toVec_eq_smul_of_scaledZ (AZ 6) scale ACell6_4_scaled (by decide) rfl

theorem AZ_scale_7 : toVec (AZ 7) = (scale : ℚ) • ACell7_4 :=
  toVec_eq_smul_of_scaledZ (AZ 7) scale ACell7_4_scaled (by decide) rfl

theorem AZ_scale_8 : toVec (AZ 8) = (scale : ℚ) • ACell8_4 :=
  toVec_eq_smul_of_scaledZ (AZ 8) scale ACell8_4_scaled (by decide) rfl

theorem AZ_scale_9 : toVec (AZ 9) = (scale : ℚ) • ACell9_4 :=
  toVec_eq_smul_of_scaledZ (AZ 9) scale ACell9_4_scaled (by decide) rfl

theorem AZ_scale_10 : toVec (AZ 10) = (scale : ℚ) • ACell10_4 :=
  toVec_eq_smul_of_scaledZ (AZ 10) scale ACell10_4_scaled (by decide) rfl

theorem AZ_scale_11 : toVec (AZ 11) = (scale : ℚ) • ACell11_4 :=
  toVec_eq_smul_of_scaledZ (AZ 11) scale ACell11_4_scaled (by decide) rfl

theorem AZ_scale_12 : toVec (AZ 12) = (scale : ℚ) • ACell12_4 :=
  toVec_eq_smul_of_scaledZ (AZ 12) scale ACell12_4_scaled (by decide) rfl

theorem AZ_scale_13 : toVec (AZ 13) = (scale : ℚ) • ACell13_4 :=
  toVec_eq_smul_of_scaledZ (AZ 13) scale ACell13_4_scaled (by decide) rfl

theorem AZ_scale_14 : toVec (AZ 14) = (scale : ℚ) • ACell14_4 :=
  toVec_eq_smul_of_scaledZ (AZ 14) scale ACell14_4_scaled (by decide) rfl

theorem AZ_scale_15 : toVec (AZ 15) = (scale : ℚ) • ACell15_4 :=
  toVec_eq_smul_of_scaledZ (AZ 15) scale ACell15_4_scaled (by decide) rfl

theorem AZ_scale_16 : toVec (AZ 16) = (scale : ℚ) • ACell16_4 :=
  toVec_eq_smul_of_scaledZ (AZ 16) scale ACell16_4_scaled (by decide) rfl

theorem AZ_scale_17 : toVec (AZ 17) = (scale : ℚ) • ACell17_4 :=
  toVec_eq_smul_of_scaledZ (AZ 17) scale ACell17_4_scaled (by decide) rfl

theorem AZ_scale_18 : toVec (AZ 18) = (scale : ℚ) • ACell18_4 :=
  toVec_eq_smul_of_scaledZ (AZ 18) scale ACell18_4_scaled (by decide) rfl

theorem AZ_scale_19 : toVec (AZ 19) = (scale : ℚ) • ACell19_4 :=
  toVec_eq_smul_of_scaledZ (AZ 19) scale ACell19_4_scaled (by decide) rfl

theorem AZ_scale (k : Fin 20) :
    toVec (AZ k) = (scale : ℚ) • AVec k (4 : Fin 10) :=
  forall_fin20 (P := fun k => toVec (AZ k) = (scale : ℚ) • AVec k (4 : Fin 10))
    (toVec_smul_congr AZ_scale_0 AVec_apply_0_4)
    (toVec_smul_congr AZ_scale_1 AVec_apply_1_4)
    (toVec_smul_congr AZ_scale_2 AVec_apply_2_4)
    (toVec_smul_congr AZ_scale_3 AVec_apply_3_4)
    (toVec_smul_congr AZ_scale_4 AVec_apply_4_4)
    (toVec_smul_congr AZ_scale_5 AVec_apply_5_4)
    (toVec_smul_congr AZ_scale_6 AVec_apply_6_4)
    (toVec_smul_congr AZ_scale_7 AVec_apply_7_4)
    (toVec_smul_congr AZ_scale_8 AVec_apply_8_4)
    (toVec_smul_congr AZ_scale_9 AVec_apply_9_4)
    (toVec_smul_congr AZ_scale_10 AVec_apply_10_4)
    (toVec_smul_congr AZ_scale_11 AVec_apply_11_4)
    (toVec_smul_congr AZ_scale_12 AVec_apply_12_4)
    (toVec_smul_congr AZ_scale_13 AVec_apply_13_4)
    (toVec_smul_congr AZ_scale_14 AVec_apply_14_4)
    (toVec_smul_congr AZ_scale_15 AVec_apply_15_4)
    (toVec_smul_congr AZ_scale_16 AVec_apply_16_4)
    (toVec_smul_congr AZ_scale_17 AVec_apply_17_4)
    (toVec_smul_congr AZ_scale_18 AVec_apply_18_4)
    (toVec_smul_congr AZ_scale_19 AVec_apply_19_4)
    k

theorem KZ_scale_0 : toVec (KZ 0) = (scale : ℚ) • KCell5_0 :=
  toVec_eq_smul_of_scaledZ (KZ 0) scale KCell5_0_scaled (by decide) rfl

theorem KZ_scale (k : Fin 1) :
    toVec (KZ k) = (scale : ℚ) • KVec (5 : Fin 10) k :=
  forall_fin1 (P := fun k => toVec (KZ k) = (scale : ℚ) • KVec (5 : Fin 10) k)
    (toVec_smul_congr KZ_scale_0 KVec_apply_5_0)
    k

theorem YZ_scale_0 : toVec (YZ 0) = (scale : ℚ) • YCell0_4 :=
  toVec_eq_smul_of_scaledZ (YZ 0) scale YCell0_4_scaled (by decide) rfl

theorem YZ_scale (k : Fin 1) :
    toVec (YZ k) = (scale : ℚ) • YVec k (4 : Fin 10) :=
  forall_fin1 (P := fun k => toVec (YZ k) = (scale : ℚ) • YVec k (4 : Fin 10))
    (toVec_smul_congr YZ_scale_0 YVec_apply_0_4)
    k

theorem entry_eq :
    (matrixMul XVec AVec + matrixMul KVec YVec)
        (5 : Fin 10) (4 : Fin 10) = ![0, 0, 0, 0, 0, 0, 0, 0, 0, 0] := by
  rw [Matrix.add_apply, matrixMul_apply, matrixMul_apply]
  refine add_sum_mul_eq_of_scaled scale scale_ne_zero
    (fun k => XVec (5 : Fin 10) k)
    (fun k => AVec k (4 : Fin 10))
    (fun k => KVec (5 : Fin 10) k)
    (fun k => YVec k (4 : Fin 10))
    XZ AZ KZ YZ XZ_scale AZ_scale KZ_scale YZ_scale entryZ rfl _ ?_
  rw [entryZ_eq, toVec_zeroZ_smul, vec_zero_eq]

theorem entry_eq_matrixOne :
    (matrixMul XVec AVec + matrixMul KVec YVec)
        (5 : Fin 10) (4 : Fin 10) =
      matrixOne (Fin 10) (5 : Fin 10) (4 : Fin 10) :=
  entry_eq.trans (matrixOne_off10 (5 : Fin 10) (4 : Fin 10) (by decide)).symm

end V14Formalization.D12PieceAPSplitEntry5_4


namespace V14Formalization.D12PieceAPSplitEntry5_5
open D12CyclotomicVec D12CyclotomicVecZ D12PieceAPData
def payloadSha256 : String := "76c6196f29afe1a8398af99502447f48ebeed4bcb3805fc5dbec693940bc04b0"

def scale : ℤ := 44

def XZ (k : Fin 20) : VecZ :=
  match k.val with
  | 0 => #v[-27, -34, -51, -12, -13, -86, -28, -22, -26, -86]
  | 1 => #v[-7, -3, -20, -10, 0, -16, -7, 0, 9, -12]
  | 2 => #v[76, 28, 95, 45, 23, 101, 37, 79, -13, 134]
  | 3 => #v[-69, -14, -29, -51, -37, -32, 5, -76, -2, -36]
  | 4 => #v[14, 6, -1, 21, 24, 1, 15, 19, -5, -6]
  | 5 => #v[104, -10, 6, 56, 46, 22, 0, 104, 0, 24]
  | 6 => #v[-34, -52, -60, -10, -8, -60, -16, -42, -14, -78]
  | 7 => #v[108, -26, 42, 60, 20, 42, -6, 124, -46, 78]
  | 8 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  | 9 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  | 10 => #v[0, 11, 11, 0, 0, -11, -11, 11, -11, 0]
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
  | 15 => #v[-32, 0, 8, 4, 0, 4, 4, 0, 4, 8]
  | 16 => #v[-8, -4, -4, -12, -4, -4, -8, 0, 0, 0]
  | 17 => #v[-4, -4, 0, 4, 0, 4, -8, 4, 0, 4]
  | 18 => #v[0, 4, -4, -4, 0, 8, 0, -4, -4, 4]
  | 19 => #v[0, 4, 4, 0, 0, 4, -4, -8, -4, 4]
  | _ => zeroZ

def KZ (k : Fin 1) : VecZ :=
  match k.val with
  | 0 => #v[22, 0, 0, 22, 0, 22, 22, 22, 0, 0]
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

theorem XZ_scale_0 : toVec (XZ 0) = (scale : ℚ) • XCell5_0 :=
  toVec_eq_smul_of_scaledZ (XZ 0) scale XCell5_0_scaled (by decide) rfl

theorem XZ_scale_1 : toVec (XZ 1) = (scale : ℚ) • XCell5_1 :=
  toVec_eq_smul_of_scaledZ (XZ 1) scale XCell5_1_scaled (by decide) rfl

theorem XZ_scale_2 : toVec (XZ 2) = (scale : ℚ) • XCell5_2 :=
  toVec_eq_smul_of_scaledZ (XZ 2) scale XCell5_2_scaled (by decide) rfl

theorem XZ_scale_3 : toVec (XZ 3) = (scale : ℚ) • XCell5_3 :=
  toVec_eq_smul_of_scaledZ (XZ 3) scale XCell5_3_scaled (by decide) rfl

theorem XZ_scale_4 : toVec (XZ 4) = (scale : ℚ) • XCell5_4 :=
  toVec_eq_smul_of_scaledZ (XZ 4) scale XCell5_4_scaled (by decide) rfl

theorem XZ_scale_5 : toVec (XZ 5) = (scale : ℚ) • XCell5_5 :=
  toVec_eq_smul_of_scaledZ (XZ 5) scale XCell5_5_scaled (by decide) rfl

theorem XZ_scale_6 : toVec (XZ 6) = (scale : ℚ) • XCell5_6 :=
  toVec_eq_smul_of_scaledZ (XZ 6) scale XCell5_6_scaled (by decide) rfl

theorem XZ_scale_7 : toVec (XZ 7) = (scale : ℚ) • XCell5_7 :=
  toVec_eq_smul_of_scaledZ (XZ 7) scale XCell5_7_scaled (by decide) rfl

theorem XZ_scale_8 : toVec (XZ 8) = (scale : ℚ) • XCell5_8 :=
  toVec_eq_smul_of_scaledZ (XZ 8) scale XCell5_8_scaled (by decide) rfl

theorem XZ_scale_9 : toVec (XZ 9) = (scale : ℚ) • XCell5_9 :=
  toVec_eq_smul_of_scaledZ (XZ 9) scale XCell5_9_scaled (by decide) rfl

theorem XZ_scale_10 : toVec (XZ 10) = (scale : ℚ) • XCell5_10 :=
  toVec_eq_smul_of_scaledZ (XZ 10) scale XCell5_10_scaled (by decide) rfl

theorem XZ_scale_11 : toVec (XZ 11) = (scale : ℚ) • XCell5_11 :=
  toVec_eq_smul_of_scaledZ (XZ 11) scale XCell5_11_scaled (by decide) rfl

theorem XZ_scale_12 : toVec (XZ 12) = (scale : ℚ) • XCell5_12 :=
  toVec_eq_smul_of_scaledZ (XZ 12) scale XCell5_12_scaled (by decide) rfl

theorem XZ_scale_13 : toVec (XZ 13) = (scale : ℚ) • XCell5_13 :=
  toVec_eq_smul_of_scaledZ (XZ 13) scale XCell5_13_scaled (by decide) rfl

theorem XZ_scale_14 : toVec (XZ 14) = (scale : ℚ) • XCell5_14 :=
  toVec_eq_smul_of_scaledZ (XZ 14) scale XCell5_14_scaled (by decide) rfl

theorem XZ_scale_15 : toVec (XZ 15) = (scale : ℚ) • XCell5_15 :=
  toVec_eq_smul_of_scaledZ (XZ 15) scale XCell5_15_scaled (by decide) rfl

theorem XZ_scale_16 : toVec (XZ 16) = (scale : ℚ) • XCell5_16 :=
  toVec_eq_smul_of_scaledZ (XZ 16) scale XCell5_16_scaled (by decide) rfl

theorem XZ_scale_17 : toVec (XZ 17) = (scale : ℚ) • XCell5_17 :=
  toVec_eq_smul_of_scaledZ (XZ 17) scale XCell5_17_scaled (by decide) rfl

theorem XZ_scale_18 : toVec (XZ 18) = (scale : ℚ) • XCell5_18 :=
  toVec_eq_smul_of_scaledZ (XZ 18) scale XCell5_18_scaled (by decide) rfl

theorem XZ_scale_19 : toVec (XZ 19) = (scale : ℚ) • XCell5_19 :=
  toVec_eq_smul_of_scaledZ (XZ 19) scale XCell5_19_scaled (by decide) rfl

theorem XZ_scale (k : Fin 20) :
    toVec (XZ k) = (scale : ℚ) • XVec (5 : Fin 10) k :=
  forall_fin20 (P := fun k => toVec (XZ k) = (scale : ℚ) • XVec (5 : Fin 10) k)
    (toVec_smul_congr XZ_scale_0 XVec_apply_5_0)
    (toVec_smul_congr XZ_scale_1 XVec_apply_5_1)
    (toVec_smul_congr XZ_scale_2 XVec_apply_5_2)
    (toVec_smul_congr XZ_scale_3 XVec_apply_5_3)
    (toVec_smul_congr XZ_scale_4 XVec_apply_5_4)
    (toVec_smul_congr XZ_scale_5 XVec_apply_5_5)
    (toVec_smul_congr XZ_scale_6 XVec_apply_5_6)
    (toVec_smul_congr XZ_scale_7 XVec_apply_5_7)
    (toVec_smul_congr XZ_scale_8 XVec_apply_5_8)
    (toVec_smul_congr XZ_scale_9 XVec_apply_5_9)
    (toVec_smul_congr XZ_scale_10 XVec_apply_5_10)
    (toVec_smul_congr XZ_scale_11 XVec_apply_5_11)
    (toVec_smul_congr XZ_scale_12 XVec_apply_5_12)
    (toVec_smul_congr XZ_scale_13 XVec_apply_5_13)
    (toVec_smul_congr XZ_scale_14 XVec_apply_5_14)
    (toVec_smul_congr XZ_scale_15 XVec_apply_5_15)
    (toVec_smul_congr XZ_scale_16 XVec_apply_5_16)
    (toVec_smul_congr XZ_scale_17 XVec_apply_5_17)
    (toVec_smul_congr XZ_scale_18 XVec_apply_5_18)
    (toVec_smul_congr XZ_scale_19 XVec_apply_5_19)
    k

theorem AZ_scale_0 : toVec (AZ 0) = (scale : ℚ) • ACell0_5 :=
  toVec_eq_smul_of_scaledZ (AZ 0) scale ACell0_5_scaled (by decide) rfl

theorem AZ_scale_1 : toVec (AZ 1) = (scale : ℚ) • ACell1_5 :=
  toVec_eq_smul_of_scaledZ (AZ 1) scale ACell1_5_scaled (by decide) rfl

theorem AZ_scale_2 : toVec (AZ 2) = (scale : ℚ) • ACell2_5 :=
  toVec_eq_smul_of_scaledZ (AZ 2) scale ACell2_5_scaled (by decide) rfl

theorem AZ_scale_3 : toVec (AZ 3) = (scale : ℚ) • ACell3_5 :=
  toVec_eq_smul_of_scaledZ (AZ 3) scale ACell3_5_scaled (by decide) rfl

theorem AZ_scale_4 : toVec (AZ 4) = (scale : ℚ) • ACell4_5 :=
  toVec_eq_smul_of_scaledZ (AZ 4) scale ACell4_5_scaled (by decide) rfl

theorem AZ_scale_5 : toVec (AZ 5) = (scale : ℚ) • ACell5_5 :=
  toVec_eq_smul_of_scaledZ (AZ 5) scale ACell5_5_scaled (by decide) rfl

theorem AZ_scale_6 : toVec (AZ 6) = (scale : ℚ) • ACell6_5 :=
  toVec_eq_smul_of_scaledZ (AZ 6) scale ACell6_5_scaled (by decide) rfl

theorem AZ_scale_7 : toVec (AZ 7) = (scale : ℚ) • ACell7_5 :=
  toVec_eq_smul_of_scaledZ (AZ 7) scale ACell7_5_scaled (by decide) rfl

theorem AZ_scale_8 : toVec (AZ 8) = (scale : ℚ) • ACell8_5 :=
  toVec_eq_smul_of_scaledZ (AZ 8) scale ACell8_5_scaled (by decide) rfl

theorem AZ_scale_9 : toVec (AZ 9) = (scale : ℚ) • ACell9_5 :=
  toVec_eq_smul_of_scaledZ (AZ 9) scale ACell9_5_scaled (by decide) rfl

theorem AZ_scale_10 : toVec (AZ 10) = (scale : ℚ) • ACell10_5 :=
  toVec_eq_smul_of_scaledZ (AZ 10) scale ACell10_5_scaled (by decide) rfl

theorem AZ_scale_11 : toVec (AZ 11) = (scale : ℚ) • ACell11_5 :=
  toVec_eq_smul_of_scaledZ (AZ 11) scale ACell11_5_scaled (by decide) rfl

theorem AZ_scale_12 : toVec (AZ 12) = (scale : ℚ) • ACell12_5 :=
  toVec_eq_smul_of_scaledZ (AZ 12) scale ACell12_5_scaled (by decide) rfl

theorem AZ_scale_13 : toVec (AZ 13) = (scale : ℚ) • ACell13_5 :=
  toVec_eq_smul_of_scaledZ (AZ 13) scale ACell13_5_scaled (by decide) rfl

theorem AZ_scale_14 : toVec (AZ 14) = (scale : ℚ) • ACell14_5 :=
  toVec_eq_smul_of_scaledZ (AZ 14) scale ACell14_5_scaled (by decide) rfl

theorem AZ_scale_15 : toVec (AZ 15) = (scale : ℚ) • ACell15_5 :=
  toVec_eq_smul_of_scaledZ (AZ 15) scale ACell15_5_scaled (by decide) rfl

theorem AZ_scale_16 : toVec (AZ 16) = (scale : ℚ) • ACell16_5 :=
  toVec_eq_smul_of_scaledZ (AZ 16) scale ACell16_5_scaled (by decide) rfl

theorem AZ_scale_17 : toVec (AZ 17) = (scale : ℚ) • ACell17_5 :=
  toVec_eq_smul_of_scaledZ (AZ 17) scale ACell17_5_scaled (by decide) rfl

theorem AZ_scale_18 : toVec (AZ 18) = (scale : ℚ) • ACell18_5 :=
  toVec_eq_smul_of_scaledZ (AZ 18) scale ACell18_5_scaled (by decide) rfl

theorem AZ_scale_19 : toVec (AZ 19) = (scale : ℚ) • ACell19_5 :=
  toVec_eq_smul_of_scaledZ (AZ 19) scale ACell19_5_scaled (by decide) rfl

theorem AZ_scale (k : Fin 20) :
    toVec (AZ k) = (scale : ℚ) • AVec k (5 : Fin 10) :=
  forall_fin20 (P := fun k => toVec (AZ k) = (scale : ℚ) • AVec k (5 : Fin 10))
    (toVec_smul_congr AZ_scale_0 AVec_apply_0_5)
    (toVec_smul_congr AZ_scale_1 AVec_apply_1_5)
    (toVec_smul_congr AZ_scale_2 AVec_apply_2_5)
    (toVec_smul_congr AZ_scale_3 AVec_apply_3_5)
    (toVec_smul_congr AZ_scale_4 AVec_apply_4_5)
    (toVec_smul_congr AZ_scale_5 AVec_apply_5_5)
    (toVec_smul_congr AZ_scale_6 AVec_apply_6_5)
    (toVec_smul_congr AZ_scale_7 AVec_apply_7_5)
    (toVec_smul_congr AZ_scale_8 AVec_apply_8_5)
    (toVec_smul_congr AZ_scale_9 AVec_apply_9_5)
    (toVec_smul_congr AZ_scale_10 AVec_apply_10_5)
    (toVec_smul_congr AZ_scale_11 AVec_apply_11_5)
    (toVec_smul_congr AZ_scale_12 AVec_apply_12_5)
    (toVec_smul_congr AZ_scale_13 AVec_apply_13_5)
    (toVec_smul_congr AZ_scale_14 AVec_apply_14_5)
    (toVec_smul_congr AZ_scale_15 AVec_apply_15_5)
    (toVec_smul_congr AZ_scale_16 AVec_apply_16_5)
    (toVec_smul_congr AZ_scale_17 AVec_apply_17_5)
    (toVec_smul_congr AZ_scale_18 AVec_apply_18_5)
    (toVec_smul_congr AZ_scale_19 AVec_apply_19_5)
    k

theorem KZ_scale_0 : toVec (KZ 0) = (scale : ℚ) • KCell5_0 :=
  toVec_eq_smul_of_scaledZ (KZ 0) scale KCell5_0_scaled (by decide) rfl

theorem KZ_scale (k : Fin 1) :
    toVec (KZ k) = (scale : ℚ) • KVec (5 : Fin 10) k :=
  forall_fin1 (P := fun k => toVec (KZ k) = (scale : ℚ) • KVec (5 : Fin 10) k)
    (toVec_smul_congr KZ_scale_0 KVec_apply_5_0)
    k

theorem YZ_scale_0 : toVec (YZ 0) = (scale : ℚ) • YCell0_5 :=
  toVec_eq_smul_of_scaledZ (YZ 0) scale YCell0_5_scaled (by decide) rfl

theorem YZ_scale (k : Fin 1) :
    toVec (YZ k) = (scale : ℚ) • YVec k (5 : Fin 10) :=
  forall_fin1 (P := fun k => toVec (YZ k) = (scale : ℚ) • YVec k (5 : Fin 10))
    (toVec_smul_congr YZ_scale_0 YVec_apply_0_5)
    k

theorem entry_eq :
    (matrixMul XVec AVec + matrixMul KVec YVec)
        (5 : Fin 10) (5 : Fin 10) = ![1, 0, 0, 0, 0, 0, 0, 0, 0, 0] := by
  rw [Matrix.add_apply, matrixMul_apply, matrixMul_apply]
  refine add_sum_mul_eq_of_scaled scale scale_ne_zero
    (fun k => XVec (5 : Fin 10) k)
    (fun k => AVec k (5 : Fin 10))
    (fun k => KVec (5 : Fin 10) k)
    (fun k => YVec k (5 : Fin 10))
    XZ AZ KZ YZ XZ_scale AZ_scale KZ_scale YZ_scale entryZ rfl _ ?_
  rw [entryZ_eq, toVec_scaleSqE0, constVec_one_eq]

theorem entry_eq_matrixOne :
    (matrixMul XVec AVec + matrixMul KVec YVec)
        (5 : Fin 10) (5 : Fin 10) =
      matrixOne (Fin 10) (5 : Fin 10) (5 : Fin 10) :=
  entry_eq.trans (matrixOne_diag10 (5 : Fin 10)).symm

end V14Formalization.D12PieceAPSplitEntry5_5


namespace V14Formalization.D12PieceAPSplitEntry5_6
open D12CyclotomicVec D12CyclotomicVecZ D12PieceAPData
def payloadSha256 : String := "76c6196f29afe1a8398af99502447f48ebeed4bcb3805fc5dbec693940bc04b0"

def scale : ℤ := 44

def XZ (k : Fin 20) : VecZ :=
  match k.val with
  | 0 => #v[-27, -34, -51, -12, -13, -86, -28, -22, -26, -86]
  | 1 => #v[-7, -3, -20, -10, 0, -16, -7, 0, 9, -12]
  | 2 => #v[76, 28, 95, 45, 23, 101, 37, 79, -13, 134]
  | 3 => #v[-69, -14, -29, -51, -37, -32, 5, -76, -2, -36]
  | 4 => #v[14, 6, -1, 21, 24, 1, 15, 19, -5, -6]
  | 5 => #v[104, -10, 6, 56, 46, 22, 0, 104, 0, 24]
  | 6 => #v[-34, -52, -60, -10, -8, -60, -16, -42, -14, -78]
  | 7 => #v[108, -26, 42, 60, 20, 42, -6, 124, -46, 78]
  | 8 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  | 9 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  | 10 => #v[0, 11, 11, 0, 0, -11, -11, 11, -11, 0]
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
  | 16 => #v[-40, 0, -8, -4, -4, -8, -8, -4, -4, -8]
  | 17 => #v[4, 8, 0, 12, 0, 8, 4, 0, 4, 4]
  | 18 => #v[-4, 0, -12, 0, -4, 0, -4, -8, -8, -4]
  | 19 => #v[4, -4, -4, 0, 8, 0, -4, -4, 4, 0]
  | _ => zeroZ

def KZ (k : Fin 1) : VecZ :=
  match k.val with
  | 0 => #v[22, 0, 0, 22, 0, 22, 22, 22, 0, 0]
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

theorem XZ_scale_0 : toVec (XZ 0) = (scale : ℚ) • XCell5_0 :=
  toVec_eq_smul_of_scaledZ (XZ 0) scale XCell5_0_scaled (by decide) rfl

theorem XZ_scale_1 : toVec (XZ 1) = (scale : ℚ) • XCell5_1 :=
  toVec_eq_smul_of_scaledZ (XZ 1) scale XCell5_1_scaled (by decide) rfl

theorem XZ_scale_2 : toVec (XZ 2) = (scale : ℚ) • XCell5_2 :=
  toVec_eq_smul_of_scaledZ (XZ 2) scale XCell5_2_scaled (by decide) rfl

theorem XZ_scale_3 : toVec (XZ 3) = (scale : ℚ) • XCell5_3 :=
  toVec_eq_smul_of_scaledZ (XZ 3) scale XCell5_3_scaled (by decide) rfl

theorem XZ_scale_4 : toVec (XZ 4) = (scale : ℚ) • XCell5_4 :=
  toVec_eq_smul_of_scaledZ (XZ 4) scale XCell5_4_scaled (by decide) rfl

theorem XZ_scale_5 : toVec (XZ 5) = (scale : ℚ) • XCell5_5 :=
  toVec_eq_smul_of_scaledZ (XZ 5) scale XCell5_5_scaled (by decide) rfl

theorem XZ_scale_6 : toVec (XZ 6) = (scale : ℚ) • XCell5_6 :=
  toVec_eq_smul_of_scaledZ (XZ 6) scale XCell5_6_scaled (by decide) rfl

theorem XZ_scale_7 : toVec (XZ 7) = (scale : ℚ) • XCell5_7 :=
  toVec_eq_smul_of_scaledZ (XZ 7) scale XCell5_7_scaled (by decide) rfl

theorem XZ_scale_8 : toVec (XZ 8) = (scale : ℚ) • XCell5_8 :=
  toVec_eq_smul_of_scaledZ (XZ 8) scale XCell5_8_scaled (by decide) rfl

theorem XZ_scale_9 : toVec (XZ 9) = (scale : ℚ) • XCell5_9 :=
  toVec_eq_smul_of_scaledZ (XZ 9) scale XCell5_9_scaled (by decide) rfl

theorem XZ_scale_10 : toVec (XZ 10) = (scale : ℚ) • XCell5_10 :=
  toVec_eq_smul_of_scaledZ (XZ 10) scale XCell5_10_scaled (by decide) rfl

theorem XZ_scale_11 : toVec (XZ 11) = (scale : ℚ) • XCell5_11 :=
  toVec_eq_smul_of_scaledZ (XZ 11) scale XCell5_11_scaled (by decide) rfl

theorem XZ_scale_12 : toVec (XZ 12) = (scale : ℚ) • XCell5_12 :=
  toVec_eq_smul_of_scaledZ (XZ 12) scale XCell5_12_scaled (by decide) rfl

theorem XZ_scale_13 : toVec (XZ 13) = (scale : ℚ) • XCell5_13 :=
  toVec_eq_smul_of_scaledZ (XZ 13) scale XCell5_13_scaled (by decide) rfl

theorem XZ_scale_14 : toVec (XZ 14) = (scale : ℚ) • XCell5_14 :=
  toVec_eq_smul_of_scaledZ (XZ 14) scale XCell5_14_scaled (by decide) rfl

theorem XZ_scale_15 : toVec (XZ 15) = (scale : ℚ) • XCell5_15 :=
  toVec_eq_smul_of_scaledZ (XZ 15) scale XCell5_15_scaled (by decide) rfl

theorem XZ_scale_16 : toVec (XZ 16) = (scale : ℚ) • XCell5_16 :=
  toVec_eq_smul_of_scaledZ (XZ 16) scale XCell5_16_scaled (by decide) rfl

theorem XZ_scale_17 : toVec (XZ 17) = (scale : ℚ) • XCell5_17 :=
  toVec_eq_smul_of_scaledZ (XZ 17) scale XCell5_17_scaled (by decide) rfl

theorem XZ_scale_18 : toVec (XZ 18) = (scale : ℚ) • XCell5_18 :=
  toVec_eq_smul_of_scaledZ (XZ 18) scale XCell5_18_scaled (by decide) rfl

theorem XZ_scale_19 : toVec (XZ 19) = (scale : ℚ) • XCell5_19 :=
  toVec_eq_smul_of_scaledZ (XZ 19) scale XCell5_19_scaled (by decide) rfl

theorem XZ_scale (k : Fin 20) :
    toVec (XZ k) = (scale : ℚ) • XVec (5 : Fin 10) k :=
  forall_fin20 (P := fun k => toVec (XZ k) = (scale : ℚ) • XVec (5 : Fin 10) k)
    (toVec_smul_congr XZ_scale_0 XVec_apply_5_0)
    (toVec_smul_congr XZ_scale_1 XVec_apply_5_1)
    (toVec_smul_congr XZ_scale_2 XVec_apply_5_2)
    (toVec_smul_congr XZ_scale_3 XVec_apply_5_3)
    (toVec_smul_congr XZ_scale_4 XVec_apply_5_4)
    (toVec_smul_congr XZ_scale_5 XVec_apply_5_5)
    (toVec_smul_congr XZ_scale_6 XVec_apply_5_6)
    (toVec_smul_congr XZ_scale_7 XVec_apply_5_7)
    (toVec_smul_congr XZ_scale_8 XVec_apply_5_8)
    (toVec_smul_congr XZ_scale_9 XVec_apply_5_9)
    (toVec_smul_congr XZ_scale_10 XVec_apply_5_10)
    (toVec_smul_congr XZ_scale_11 XVec_apply_5_11)
    (toVec_smul_congr XZ_scale_12 XVec_apply_5_12)
    (toVec_smul_congr XZ_scale_13 XVec_apply_5_13)
    (toVec_smul_congr XZ_scale_14 XVec_apply_5_14)
    (toVec_smul_congr XZ_scale_15 XVec_apply_5_15)
    (toVec_smul_congr XZ_scale_16 XVec_apply_5_16)
    (toVec_smul_congr XZ_scale_17 XVec_apply_5_17)
    (toVec_smul_congr XZ_scale_18 XVec_apply_5_18)
    (toVec_smul_congr XZ_scale_19 XVec_apply_5_19)
    k

theorem AZ_scale_0 : toVec (AZ 0) = (scale : ℚ) • ACell0_6 :=
  toVec_eq_smul_of_scaledZ (AZ 0) scale ACell0_6_scaled (by decide) rfl

theorem AZ_scale_1 : toVec (AZ 1) = (scale : ℚ) • ACell1_6 :=
  toVec_eq_smul_of_scaledZ (AZ 1) scale ACell1_6_scaled (by decide) rfl

theorem AZ_scale_2 : toVec (AZ 2) = (scale : ℚ) • ACell2_6 :=
  toVec_eq_smul_of_scaledZ (AZ 2) scale ACell2_6_scaled (by decide) rfl

theorem AZ_scale_3 : toVec (AZ 3) = (scale : ℚ) • ACell3_6 :=
  toVec_eq_smul_of_scaledZ (AZ 3) scale ACell3_6_scaled (by decide) rfl

theorem AZ_scale_4 : toVec (AZ 4) = (scale : ℚ) • ACell4_6 :=
  toVec_eq_smul_of_scaledZ (AZ 4) scale ACell4_6_scaled (by decide) rfl

theorem AZ_scale_5 : toVec (AZ 5) = (scale : ℚ) • ACell5_6 :=
  toVec_eq_smul_of_scaledZ (AZ 5) scale ACell5_6_scaled (by decide) rfl

theorem AZ_scale_6 : toVec (AZ 6) = (scale : ℚ) • ACell6_6 :=
  toVec_eq_smul_of_scaledZ (AZ 6) scale ACell6_6_scaled (by decide) rfl

theorem AZ_scale_7 : toVec (AZ 7) = (scale : ℚ) • ACell7_6 :=
  toVec_eq_smul_of_scaledZ (AZ 7) scale ACell7_6_scaled (by decide) rfl

theorem AZ_scale_8 : toVec (AZ 8) = (scale : ℚ) • ACell8_6 :=
  toVec_eq_smul_of_scaledZ (AZ 8) scale ACell8_6_scaled (by decide) rfl

theorem AZ_scale_9 : toVec (AZ 9) = (scale : ℚ) • ACell9_6 :=
  toVec_eq_smul_of_scaledZ (AZ 9) scale ACell9_6_scaled (by decide) rfl

theorem AZ_scale_10 : toVec (AZ 10) = (scale : ℚ) • ACell10_6 :=
  toVec_eq_smul_of_scaledZ (AZ 10) scale ACell10_6_scaled (by decide) rfl

theorem AZ_scale_11 : toVec (AZ 11) = (scale : ℚ) • ACell11_6 :=
  toVec_eq_smul_of_scaledZ (AZ 11) scale ACell11_6_scaled (by decide) rfl

theorem AZ_scale_12 : toVec (AZ 12) = (scale : ℚ) • ACell12_6 :=
  toVec_eq_smul_of_scaledZ (AZ 12) scale ACell12_6_scaled (by decide) rfl

theorem AZ_scale_13 : toVec (AZ 13) = (scale : ℚ) • ACell13_6 :=
  toVec_eq_smul_of_scaledZ (AZ 13) scale ACell13_6_scaled (by decide) rfl

theorem AZ_scale_14 : toVec (AZ 14) = (scale : ℚ) • ACell14_6 :=
  toVec_eq_smul_of_scaledZ (AZ 14) scale ACell14_6_scaled (by decide) rfl

theorem AZ_scale_15 : toVec (AZ 15) = (scale : ℚ) • ACell15_6 :=
  toVec_eq_smul_of_scaledZ (AZ 15) scale ACell15_6_scaled (by decide) rfl

theorem AZ_scale_16 : toVec (AZ 16) = (scale : ℚ) • ACell16_6 :=
  toVec_eq_smul_of_scaledZ (AZ 16) scale ACell16_6_scaled (by decide) rfl

theorem AZ_scale_17 : toVec (AZ 17) = (scale : ℚ) • ACell17_6 :=
  toVec_eq_smul_of_scaledZ (AZ 17) scale ACell17_6_scaled (by decide) rfl

theorem AZ_scale_18 : toVec (AZ 18) = (scale : ℚ) • ACell18_6 :=
  toVec_eq_smul_of_scaledZ (AZ 18) scale ACell18_6_scaled (by decide) rfl

theorem AZ_scale_19 : toVec (AZ 19) = (scale : ℚ) • ACell19_6 :=
  toVec_eq_smul_of_scaledZ (AZ 19) scale ACell19_6_scaled (by decide) rfl

theorem AZ_scale (k : Fin 20) :
    toVec (AZ k) = (scale : ℚ) • AVec k (6 : Fin 10) :=
  forall_fin20 (P := fun k => toVec (AZ k) = (scale : ℚ) • AVec k (6 : Fin 10))
    (toVec_smul_congr AZ_scale_0 AVec_apply_0_6)
    (toVec_smul_congr AZ_scale_1 AVec_apply_1_6)
    (toVec_smul_congr AZ_scale_2 AVec_apply_2_6)
    (toVec_smul_congr AZ_scale_3 AVec_apply_3_6)
    (toVec_smul_congr AZ_scale_4 AVec_apply_4_6)
    (toVec_smul_congr AZ_scale_5 AVec_apply_5_6)
    (toVec_smul_congr AZ_scale_6 AVec_apply_6_6)
    (toVec_smul_congr AZ_scale_7 AVec_apply_7_6)
    (toVec_smul_congr AZ_scale_8 AVec_apply_8_6)
    (toVec_smul_congr AZ_scale_9 AVec_apply_9_6)
    (toVec_smul_congr AZ_scale_10 AVec_apply_10_6)
    (toVec_smul_congr AZ_scale_11 AVec_apply_11_6)
    (toVec_smul_congr AZ_scale_12 AVec_apply_12_6)
    (toVec_smul_congr AZ_scale_13 AVec_apply_13_6)
    (toVec_smul_congr AZ_scale_14 AVec_apply_14_6)
    (toVec_smul_congr AZ_scale_15 AVec_apply_15_6)
    (toVec_smul_congr AZ_scale_16 AVec_apply_16_6)
    (toVec_smul_congr AZ_scale_17 AVec_apply_17_6)
    (toVec_smul_congr AZ_scale_18 AVec_apply_18_6)
    (toVec_smul_congr AZ_scale_19 AVec_apply_19_6)
    k

theorem KZ_scale_0 : toVec (KZ 0) = (scale : ℚ) • KCell5_0 :=
  toVec_eq_smul_of_scaledZ (KZ 0) scale KCell5_0_scaled (by decide) rfl

theorem KZ_scale (k : Fin 1) :
    toVec (KZ k) = (scale : ℚ) • KVec (5 : Fin 10) k :=
  forall_fin1 (P := fun k => toVec (KZ k) = (scale : ℚ) • KVec (5 : Fin 10) k)
    (toVec_smul_congr KZ_scale_0 KVec_apply_5_0)
    k

theorem YZ_scale_0 : toVec (YZ 0) = (scale : ℚ) • YCell0_6 :=
  toVec_eq_smul_of_scaledZ (YZ 0) scale YCell0_6_scaled (by decide) rfl

theorem YZ_scale (k : Fin 1) :
    toVec (YZ k) = (scale : ℚ) • YVec k (6 : Fin 10) :=
  forall_fin1 (P := fun k => toVec (YZ k) = (scale : ℚ) • YVec k (6 : Fin 10))
    (toVec_smul_congr YZ_scale_0 YVec_apply_0_6)
    k

theorem entry_eq :
    (matrixMul XVec AVec + matrixMul KVec YVec)
        (5 : Fin 10) (6 : Fin 10) = ![0, 0, 0, 0, 0, 0, 0, 0, 0, 0] := by
  rw [Matrix.add_apply, matrixMul_apply, matrixMul_apply]
  refine add_sum_mul_eq_of_scaled scale scale_ne_zero
    (fun k => XVec (5 : Fin 10) k)
    (fun k => AVec k (6 : Fin 10))
    (fun k => KVec (5 : Fin 10) k)
    (fun k => YVec k (6 : Fin 10))
    XZ AZ KZ YZ XZ_scale AZ_scale KZ_scale YZ_scale entryZ rfl _ ?_
  rw [entryZ_eq, toVec_zeroZ_smul, vec_zero_eq]

theorem entry_eq_matrixOne :
    (matrixMul XVec AVec + matrixMul KVec YVec)
        (5 : Fin 10) (6 : Fin 10) =
      matrixOne (Fin 10) (5 : Fin 10) (6 : Fin 10) :=
  entry_eq.trans (matrixOne_off10 (5 : Fin 10) (6 : Fin 10) (by decide)).symm

end V14Formalization.D12PieceAPSplitEntry5_6


namespace V14Formalization.D12PieceAPSplitEntry5_7
open D12CyclotomicVec D12CyclotomicVecZ D12PieceAPData
def payloadSha256 : String := "76c6196f29afe1a8398af99502447f48ebeed4bcb3805fc5dbec693940bc04b0"

def scale : ℤ := 44

def XZ (k : Fin 20) : VecZ :=
  match k.val with
  | 0 => #v[-27, -34, -51, -12, -13, -86, -28, -22, -26, -86]
  | 1 => #v[-7, -3, -20, -10, 0, -16, -7, 0, 9, -12]
  | 2 => #v[76, 28, 95, 45, 23, 101, 37, 79, -13, 134]
  | 3 => #v[-69, -14, -29, -51, -37, -32, 5, -76, -2, -36]
  | 4 => #v[14, 6, -1, 21, 24, 1, 15, 19, -5, -6]
  | 5 => #v[104, -10, 6, 56, 46, 22, 0, 104, 0, 24]
  | 6 => #v[-34, -52, -60, -10, -8, -60, -16, -42, -14, -78]
  | 7 => #v[108, -26, 42, 60, 20, 42, -6, 124, -46, 78]
  | 8 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  | 9 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  | 10 => #v[0, 11, 11, 0, 0, -11, -11, 11, -11, 0]
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
  | 17 => #v[-36, 0, -4, -4, 4, 0, 0, 4, -4, -4]
  | 18 => #v[4, 12, 8, 8, 12, 12, 8, 8, 12, 4]
  | 19 => #v[0, 8, 0, 0, 4, -4, -4, -4, -4, 4]
  | _ => zeroZ

def KZ (k : Fin 1) : VecZ :=
  match k.val with
  | 0 => #v[22, 0, 0, 22, 0, 22, 22, 22, 0, 0]
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

theorem XZ_scale_0 : toVec (XZ 0) = (scale : ℚ) • XCell5_0 :=
  toVec_eq_smul_of_scaledZ (XZ 0) scale XCell5_0_scaled (by decide) rfl

theorem XZ_scale_1 : toVec (XZ 1) = (scale : ℚ) • XCell5_1 :=
  toVec_eq_smul_of_scaledZ (XZ 1) scale XCell5_1_scaled (by decide) rfl

theorem XZ_scale_2 : toVec (XZ 2) = (scale : ℚ) • XCell5_2 :=
  toVec_eq_smul_of_scaledZ (XZ 2) scale XCell5_2_scaled (by decide) rfl

theorem XZ_scale_3 : toVec (XZ 3) = (scale : ℚ) • XCell5_3 :=
  toVec_eq_smul_of_scaledZ (XZ 3) scale XCell5_3_scaled (by decide) rfl

theorem XZ_scale_4 : toVec (XZ 4) = (scale : ℚ) • XCell5_4 :=
  toVec_eq_smul_of_scaledZ (XZ 4) scale XCell5_4_scaled (by decide) rfl

theorem XZ_scale_5 : toVec (XZ 5) = (scale : ℚ) • XCell5_5 :=
  toVec_eq_smul_of_scaledZ (XZ 5) scale XCell5_5_scaled (by decide) rfl

theorem XZ_scale_6 : toVec (XZ 6) = (scale : ℚ) • XCell5_6 :=
  toVec_eq_smul_of_scaledZ (XZ 6) scale XCell5_6_scaled (by decide) rfl

theorem XZ_scale_7 : toVec (XZ 7) = (scale : ℚ) • XCell5_7 :=
  toVec_eq_smul_of_scaledZ (XZ 7) scale XCell5_7_scaled (by decide) rfl

theorem XZ_scale_8 : toVec (XZ 8) = (scale : ℚ) • XCell5_8 :=
  toVec_eq_smul_of_scaledZ (XZ 8) scale XCell5_8_scaled (by decide) rfl

theorem XZ_scale_9 : toVec (XZ 9) = (scale : ℚ) • XCell5_9 :=
  toVec_eq_smul_of_scaledZ (XZ 9) scale XCell5_9_scaled (by decide) rfl

theorem XZ_scale_10 : toVec (XZ 10) = (scale : ℚ) • XCell5_10 :=
  toVec_eq_smul_of_scaledZ (XZ 10) scale XCell5_10_scaled (by decide) rfl

theorem XZ_scale_11 : toVec (XZ 11) = (scale : ℚ) • XCell5_11 :=
  toVec_eq_smul_of_scaledZ (XZ 11) scale XCell5_11_scaled (by decide) rfl

theorem XZ_scale_12 : toVec (XZ 12) = (scale : ℚ) • XCell5_12 :=
  toVec_eq_smul_of_scaledZ (XZ 12) scale XCell5_12_scaled (by decide) rfl

theorem XZ_scale_13 : toVec (XZ 13) = (scale : ℚ) • XCell5_13 :=
  toVec_eq_smul_of_scaledZ (XZ 13) scale XCell5_13_scaled (by decide) rfl

theorem XZ_scale_14 : toVec (XZ 14) = (scale : ℚ) • XCell5_14 :=
  toVec_eq_smul_of_scaledZ (XZ 14) scale XCell5_14_scaled (by decide) rfl

theorem XZ_scale_15 : toVec (XZ 15) = (scale : ℚ) • XCell5_15 :=
  toVec_eq_smul_of_scaledZ (XZ 15) scale XCell5_15_scaled (by decide) rfl

theorem XZ_scale_16 : toVec (XZ 16) = (scale : ℚ) • XCell5_16 :=
  toVec_eq_smul_of_scaledZ (XZ 16) scale XCell5_16_scaled (by decide) rfl

theorem XZ_scale_17 : toVec (XZ 17) = (scale : ℚ) • XCell5_17 :=
  toVec_eq_smul_of_scaledZ (XZ 17) scale XCell5_17_scaled (by decide) rfl

theorem XZ_scale_18 : toVec (XZ 18) = (scale : ℚ) • XCell5_18 :=
  toVec_eq_smul_of_scaledZ (XZ 18) scale XCell5_18_scaled (by decide) rfl

theorem XZ_scale_19 : toVec (XZ 19) = (scale : ℚ) • XCell5_19 :=
  toVec_eq_smul_of_scaledZ (XZ 19) scale XCell5_19_scaled (by decide) rfl

theorem XZ_scale (k : Fin 20) :
    toVec (XZ k) = (scale : ℚ) • XVec (5 : Fin 10) k :=
  forall_fin20 (P := fun k => toVec (XZ k) = (scale : ℚ) • XVec (5 : Fin 10) k)
    (toVec_smul_congr XZ_scale_0 XVec_apply_5_0)
    (toVec_smul_congr XZ_scale_1 XVec_apply_5_1)
    (toVec_smul_congr XZ_scale_2 XVec_apply_5_2)
    (toVec_smul_congr XZ_scale_3 XVec_apply_5_3)
    (toVec_smul_congr XZ_scale_4 XVec_apply_5_4)
    (toVec_smul_congr XZ_scale_5 XVec_apply_5_5)
    (toVec_smul_congr XZ_scale_6 XVec_apply_5_6)
    (toVec_smul_congr XZ_scale_7 XVec_apply_5_7)
    (toVec_smul_congr XZ_scale_8 XVec_apply_5_8)
    (toVec_smul_congr XZ_scale_9 XVec_apply_5_9)
    (toVec_smul_congr XZ_scale_10 XVec_apply_5_10)
    (toVec_smul_congr XZ_scale_11 XVec_apply_5_11)
    (toVec_smul_congr XZ_scale_12 XVec_apply_5_12)
    (toVec_smul_congr XZ_scale_13 XVec_apply_5_13)
    (toVec_smul_congr XZ_scale_14 XVec_apply_5_14)
    (toVec_smul_congr XZ_scale_15 XVec_apply_5_15)
    (toVec_smul_congr XZ_scale_16 XVec_apply_5_16)
    (toVec_smul_congr XZ_scale_17 XVec_apply_5_17)
    (toVec_smul_congr XZ_scale_18 XVec_apply_5_18)
    (toVec_smul_congr XZ_scale_19 XVec_apply_5_19)
    k

theorem AZ_scale_0 : toVec (AZ 0) = (scale : ℚ) • ACell0_7 :=
  toVec_eq_smul_of_scaledZ (AZ 0) scale ACell0_7_scaled (by decide) rfl

theorem AZ_scale_1 : toVec (AZ 1) = (scale : ℚ) • ACell1_7 :=
  toVec_eq_smul_of_scaledZ (AZ 1) scale ACell1_7_scaled (by decide) rfl

theorem AZ_scale_2 : toVec (AZ 2) = (scale : ℚ) • ACell2_7 :=
  toVec_eq_smul_of_scaledZ (AZ 2) scale ACell2_7_scaled (by decide) rfl

theorem AZ_scale_3 : toVec (AZ 3) = (scale : ℚ) • ACell3_7 :=
  toVec_eq_smul_of_scaledZ (AZ 3) scale ACell3_7_scaled (by decide) rfl

theorem AZ_scale_4 : toVec (AZ 4) = (scale : ℚ) • ACell4_7 :=
  toVec_eq_smul_of_scaledZ (AZ 4) scale ACell4_7_scaled (by decide) rfl

theorem AZ_scale_5 : toVec (AZ 5) = (scale : ℚ) • ACell5_7 :=
  toVec_eq_smul_of_scaledZ (AZ 5) scale ACell5_7_scaled (by decide) rfl

theorem AZ_scale_6 : toVec (AZ 6) = (scale : ℚ) • ACell6_7 :=
  toVec_eq_smul_of_scaledZ (AZ 6) scale ACell6_7_scaled (by decide) rfl

theorem AZ_scale_7 : toVec (AZ 7) = (scale : ℚ) • ACell7_7 :=
  toVec_eq_smul_of_scaledZ (AZ 7) scale ACell7_7_scaled (by decide) rfl

theorem AZ_scale_8 : toVec (AZ 8) = (scale : ℚ) • ACell8_7 :=
  toVec_eq_smul_of_scaledZ (AZ 8) scale ACell8_7_scaled (by decide) rfl

theorem AZ_scale_9 : toVec (AZ 9) = (scale : ℚ) • ACell9_7 :=
  toVec_eq_smul_of_scaledZ (AZ 9) scale ACell9_7_scaled (by decide) rfl

theorem AZ_scale_10 : toVec (AZ 10) = (scale : ℚ) • ACell10_7 :=
  toVec_eq_smul_of_scaledZ (AZ 10) scale ACell10_7_scaled (by decide) rfl

theorem AZ_scale_11 : toVec (AZ 11) = (scale : ℚ) • ACell11_7 :=
  toVec_eq_smul_of_scaledZ (AZ 11) scale ACell11_7_scaled (by decide) rfl

theorem AZ_scale_12 : toVec (AZ 12) = (scale : ℚ) • ACell12_7 :=
  toVec_eq_smul_of_scaledZ (AZ 12) scale ACell12_7_scaled (by decide) rfl

theorem AZ_scale_13 : toVec (AZ 13) = (scale : ℚ) • ACell13_7 :=
  toVec_eq_smul_of_scaledZ (AZ 13) scale ACell13_7_scaled (by decide) rfl

theorem AZ_scale_14 : toVec (AZ 14) = (scale : ℚ) • ACell14_7 :=
  toVec_eq_smul_of_scaledZ (AZ 14) scale ACell14_7_scaled (by decide) rfl

theorem AZ_scale_15 : toVec (AZ 15) = (scale : ℚ) • ACell15_7 :=
  toVec_eq_smul_of_scaledZ (AZ 15) scale ACell15_7_scaled (by decide) rfl

theorem AZ_scale_16 : toVec (AZ 16) = (scale : ℚ) • ACell16_7 :=
  toVec_eq_smul_of_scaledZ (AZ 16) scale ACell16_7_scaled (by decide) rfl

theorem AZ_scale_17 : toVec (AZ 17) = (scale : ℚ) • ACell17_7 :=
  toVec_eq_smul_of_scaledZ (AZ 17) scale ACell17_7_scaled (by decide) rfl

theorem AZ_scale_18 : toVec (AZ 18) = (scale : ℚ) • ACell18_7 :=
  toVec_eq_smul_of_scaledZ (AZ 18) scale ACell18_7_scaled (by decide) rfl

theorem AZ_scale_19 : toVec (AZ 19) = (scale : ℚ) • ACell19_7 :=
  toVec_eq_smul_of_scaledZ (AZ 19) scale ACell19_7_scaled (by decide) rfl

theorem AZ_scale (k : Fin 20) :
    toVec (AZ k) = (scale : ℚ) • AVec k (7 : Fin 10) :=
  forall_fin20 (P := fun k => toVec (AZ k) = (scale : ℚ) • AVec k (7 : Fin 10))
    (toVec_smul_congr AZ_scale_0 AVec_apply_0_7)
    (toVec_smul_congr AZ_scale_1 AVec_apply_1_7)
    (toVec_smul_congr AZ_scale_2 AVec_apply_2_7)
    (toVec_smul_congr AZ_scale_3 AVec_apply_3_7)
    (toVec_smul_congr AZ_scale_4 AVec_apply_4_7)
    (toVec_smul_congr AZ_scale_5 AVec_apply_5_7)
    (toVec_smul_congr AZ_scale_6 AVec_apply_6_7)
    (toVec_smul_congr AZ_scale_7 AVec_apply_7_7)
    (toVec_smul_congr AZ_scale_8 AVec_apply_8_7)
    (toVec_smul_congr AZ_scale_9 AVec_apply_9_7)
    (toVec_smul_congr AZ_scale_10 AVec_apply_10_7)
    (toVec_smul_congr AZ_scale_11 AVec_apply_11_7)
    (toVec_smul_congr AZ_scale_12 AVec_apply_12_7)
    (toVec_smul_congr AZ_scale_13 AVec_apply_13_7)
    (toVec_smul_congr AZ_scale_14 AVec_apply_14_7)
    (toVec_smul_congr AZ_scale_15 AVec_apply_15_7)
    (toVec_smul_congr AZ_scale_16 AVec_apply_16_7)
    (toVec_smul_congr AZ_scale_17 AVec_apply_17_7)
    (toVec_smul_congr AZ_scale_18 AVec_apply_18_7)
    (toVec_smul_congr AZ_scale_19 AVec_apply_19_7)
    k

theorem KZ_scale_0 : toVec (KZ 0) = (scale : ℚ) • KCell5_0 :=
  toVec_eq_smul_of_scaledZ (KZ 0) scale KCell5_0_scaled (by decide) rfl

theorem KZ_scale (k : Fin 1) :
    toVec (KZ k) = (scale : ℚ) • KVec (5 : Fin 10) k :=
  forall_fin1 (P := fun k => toVec (KZ k) = (scale : ℚ) • KVec (5 : Fin 10) k)
    (toVec_smul_congr KZ_scale_0 KVec_apply_5_0)
    k

theorem YZ_scale_0 : toVec (YZ 0) = (scale : ℚ) • YCell0_7 :=
  toVec_eq_smul_of_scaledZ (YZ 0) scale YCell0_7_scaled (by decide) rfl

theorem YZ_scale (k : Fin 1) :
    toVec (YZ k) = (scale : ℚ) • YVec k (7 : Fin 10) :=
  forall_fin1 (P := fun k => toVec (YZ k) = (scale : ℚ) • YVec k (7 : Fin 10))
    (toVec_smul_congr YZ_scale_0 YVec_apply_0_7)
    k

theorem entry_eq :
    (matrixMul XVec AVec + matrixMul KVec YVec)
        (5 : Fin 10) (7 : Fin 10) = ![0, 0, 0, 0, 0, 0, 0, 0, 0, 0] := by
  rw [Matrix.add_apply, matrixMul_apply, matrixMul_apply]
  refine add_sum_mul_eq_of_scaled scale scale_ne_zero
    (fun k => XVec (5 : Fin 10) k)
    (fun k => AVec k (7 : Fin 10))
    (fun k => KVec (5 : Fin 10) k)
    (fun k => YVec k (7 : Fin 10))
    XZ AZ KZ YZ XZ_scale AZ_scale KZ_scale YZ_scale entryZ rfl _ ?_
  rw [entryZ_eq, toVec_zeroZ_smul, vec_zero_eq]

theorem entry_eq_matrixOne :
    (matrixMul XVec AVec + matrixMul KVec YVec)
        (5 : Fin 10) (7 : Fin 10) =
      matrixOne (Fin 10) (5 : Fin 10) (7 : Fin 10) :=
  entry_eq.trans (matrixOne_off10 (5 : Fin 10) (7 : Fin 10) (by decide)).symm

end V14Formalization.D12PieceAPSplitEntry5_7


namespace V14Formalization.D12PieceAPSplitEntry5_8
open D12CyclotomicVec D12CyclotomicVecZ D12PieceAPData
def payloadSha256 : String := "76c6196f29afe1a8398af99502447f48ebeed4bcb3805fc5dbec693940bc04b0"

def scale : ℤ := 44

def XZ (k : Fin 20) : VecZ :=
  match k.val with
  | 0 => #v[-27, -34, -51, -12, -13, -86, -28, -22, -26, -86]
  | 1 => #v[-7, -3, -20, -10, 0, -16, -7, 0, 9, -12]
  | 2 => #v[76, 28, 95, 45, 23, 101, 37, 79, -13, 134]
  | 3 => #v[-69, -14, -29, -51, -37, -32, 5, -76, -2, -36]
  | 4 => #v[14, 6, -1, 21, 24, 1, 15, 19, -5, -6]
  | 5 => #v[104, -10, 6, 56, 46, 22, 0, 104, 0, 24]
  | 6 => #v[-34, -52, -60, -10, -8, -60, -16, -42, -14, -78]
  | 7 => #v[108, -26, 42, 60, 20, 42, -6, 124, -46, 78]
  | 8 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  | 9 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  | 10 => #v[0, 11, 11, 0, 0, -11, -11, 11, -11, 0]
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
  | 18 => #v[-36, 0, 0, 4, -4, -4, -4, -4, 4, 0]
  | 19 => #v[-4, 4, -8, 4, -4, 0, 4, 0, 0, 4]
  | _ => zeroZ

def KZ (k : Fin 1) : VecZ :=
  match k.val with
  | 0 => #v[22, 0, 0, 22, 0, 22, 22, 22, 0, 0]
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

theorem XZ_scale_0 : toVec (XZ 0) = (scale : ℚ) • XCell5_0 :=
  toVec_eq_smul_of_scaledZ (XZ 0) scale XCell5_0_scaled (by decide) rfl

theorem XZ_scale_1 : toVec (XZ 1) = (scale : ℚ) • XCell5_1 :=
  toVec_eq_smul_of_scaledZ (XZ 1) scale XCell5_1_scaled (by decide) rfl

theorem XZ_scale_2 : toVec (XZ 2) = (scale : ℚ) • XCell5_2 :=
  toVec_eq_smul_of_scaledZ (XZ 2) scale XCell5_2_scaled (by decide) rfl

theorem XZ_scale_3 : toVec (XZ 3) = (scale : ℚ) • XCell5_3 :=
  toVec_eq_smul_of_scaledZ (XZ 3) scale XCell5_3_scaled (by decide) rfl

theorem XZ_scale_4 : toVec (XZ 4) = (scale : ℚ) • XCell5_4 :=
  toVec_eq_smul_of_scaledZ (XZ 4) scale XCell5_4_scaled (by decide) rfl

theorem XZ_scale_5 : toVec (XZ 5) = (scale : ℚ) • XCell5_5 :=
  toVec_eq_smul_of_scaledZ (XZ 5) scale XCell5_5_scaled (by decide) rfl

theorem XZ_scale_6 : toVec (XZ 6) = (scale : ℚ) • XCell5_6 :=
  toVec_eq_smul_of_scaledZ (XZ 6) scale XCell5_6_scaled (by decide) rfl

theorem XZ_scale_7 : toVec (XZ 7) = (scale : ℚ) • XCell5_7 :=
  toVec_eq_smul_of_scaledZ (XZ 7) scale XCell5_7_scaled (by decide) rfl

theorem XZ_scale_8 : toVec (XZ 8) = (scale : ℚ) • XCell5_8 :=
  toVec_eq_smul_of_scaledZ (XZ 8) scale XCell5_8_scaled (by decide) rfl

theorem XZ_scale_9 : toVec (XZ 9) = (scale : ℚ) • XCell5_9 :=
  toVec_eq_smul_of_scaledZ (XZ 9) scale XCell5_9_scaled (by decide) rfl

theorem XZ_scale_10 : toVec (XZ 10) = (scale : ℚ) • XCell5_10 :=
  toVec_eq_smul_of_scaledZ (XZ 10) scale XCell5_10_scaled (by decide) rfl

theorem XZ_scale_11 : toVec (XZ 11) = (scale : ℚ) • XCell5_11 :=
  toVec_eq_smul_of_scaledZ (XZ 11) scale XCell5_11_scaled (by decide) rfl

theorem XZ_scale_12 : toVec (XZ 12) = (scale : ℚ) • XCell5_12 :=
  toVec_eq_smul_of_scaledZ (XZ 12) scale XCell5_12_scaled (by decide) rfl

theorem XZ_scale_13 : toVec (XZ 13) = (scale : ℚ) • XCell5_13 :=
  toVec_eq_smul_of_scaledZ (XZ 13) scale XCell5_13_scaled (by decide) rfl

theorem XZ_scale_14 : toVec (XZ 14) = (scale : ℚ) • XCell5_14 :=
  toVec_eq_smul_of_scaledZ (XZ 14) scale XCell5_14_scaled (by decide) rfl

theorem XZ_scale_15 : toVec (XZ 15) = (scale : ℚ) • XCell5_15 :=
  toVec_eq_smul_of_scaledZ (XZ 15) scale XCell5_15_scaled (by decide) rfl

theorem XZ_scale_16 : toVec (XZ 16) = (scale : ℚ) • XCell5_16 :=
  toVec_eq_smul_of_scaledZ (XZ 16) scale XCell5_16_scaled (by decide) rfl

theorem XZ_scale_17 : toVec (XZ 17) = (scale : ℚ) • XCell5_17 :=
  toVec_eq_smul_of_scaledZ (XZ 17) scale XCell5_17_scaled (by decide) rfl

theorem XZ_scale_18 : toVec (XZ 18) = (scale : ℚ) • XCell5_18 :=
  toVec_eq_smul_of_scaledZ (XZ 18) scale XCell5_18_scaled (by decide) rfl

theorem XZ_scale_19 : toVec (XZ 19) = (scale : ℚ) • XCell5_19 :=
  toVec_eq_smul_of_scaledZ (XZ 19) scale XCell5_19_scaled (by decide) rfl

theorem XZ_scale (k : Fin 20) :
    toVec (XZ k) = (scale : ℚ) • XVec (5 : Fin 10) k :=
  forall_fin20 (P := fun k => toVec (XZ k) = (scale : ℚ) • XVec (5 : Fin 10) k)
    (toVec_smul_congr XZ_scale_0 XVec_apply_5_0)
    (toVec_smul_congr XZ_scale_1 XVec_apply_5_1)
    (toVec_smul_congr XZ_scale_2 XVec_apply_5_2)
    (toVec_smul_congr XZ_scale_3 XVec_apply_5_3)
    (toVec_smul_congr XZ_scale_4 XVec_apply_5_4)
    (toVec_smul_congr XZ_scale_5 XVec_apply_5_5)
    (toVec_smul_congr XZ_scale_6 XVec_apply_5_6)
    (toVec_smul_congr XZ_scale_7 XVec_apply_5_7)
    (toVec_smul_congr XZ_scale_8 XVec_apply_5_8)
    (toVec_smul_congr XZ_scale_9 XVec_apply_5_9)
    (toVec_smul_congr XZ_scale_10 XVec_apply_5_10)
    (toVec_smul_congr XZ_scale_11 XVec_apply_5_11)
    (toVec_smul_congr XZ_scale_12 XVec_apply_5_12)
    (toVec_smul_congr XZ_scale_13 XVec_apply_5_13)
    (toVec_smul_congr XZ_scale_14 XVec_apply_5_14)
    (toVec_smul_congr XZ_scale_15 XVec_apply_5_15)
    (toVec_smul_congr XZ_scale_16 XVec_apply_5_16)
    (toVec_smul_congr XZ_scale_17 XVec_apply_5_17)
    (toVec_smul_congr XZ_scale_18 XVec_apply_5_18)
    (toVec_smul_congr XZ_scale_19 XVec_apply_5_19)
    k

theorem AZ_scale_0 : toVec (AZ 0) = (scale : ℚ) • ACell0_8 :=
  toVec_eq_smul_of_scaledZ (AZ 0) scale ACell0_8_scaled (by decide) rfl

theorem AZ_scale_1 : toVec (AZ 1) = (scale : ℚ) • ACell1_8 :=
  toVec_eq_smul_of_scaledZ (AZ 1) scale ACell1_8_scaled (by decide) rfl

theorem AZ_scale_2 : toVec (AZ 2) = (scale : ℚ) • ACell2_8 :=
  toVec_eq_smul_of_scaledZ (AZ 2) scale ACell2_8_scaled (by decide) rfl

theorem AZ_scale_3 : toVec (AZ 3) = (scale : ℚ) • ACell3_8 :=
  toVec_eq_smul_of_scaledZ (AZ 3) scale ACell3_8_scaled (by decide) rfl

theorem AZ_scale_4 : toVec (AZ 4) = (scale : ℚ) • ACell4_8 :=
  toVec_eq_smul_of_scaledZ (AZ 4) scale ACell4_8_scaled (by decide) rfl

theorem AZ_scale_5 : toVec (AZ 5) = (scale : ℚ) • ACell5_8 :=
  toVec_eq_smul_of_scaledZ (AZ 5) scale ACell5_8_scaled (by decide) rfl

theorem AZ_scale_6 : toVec (AZ 6) = (scale : ℚ) • ACell6_8 :=
  toVec_eq_smul_of_scaledZ (AZ 6) scale ACell6_8_scaled (by decide) rfl

theorem AZ_scale_7 : toVec (AZ 7) = (scale : ℚ) • ACell7_8 :=
  toVec_eq_smul_of_scaledZ (AZ 7) scale ACell7_8_scaled (by decide) rfl

theorem AZ_scale_8 : toVec (AZ 8) = (scale : ℚ) • ACell8_8 :=
  toVec_eq_smul_of_scaledZ (AZ 8) scale ACell8_8_scaled (by decide) rfl

theorem AZ_scale_9 : toVec (AZ 9) = (scale : ℚ) • ACell9_8 :=
  toVec_eq_smul_of_scaledZ (AZ 9) scale ACell9_8_scaled (by decide) rfl

theorem AZ_scale_10 : toVec (AZ 10) = (scale : ℚ) • ACell10_8 :=
  toVec_eq_smul_of_scaledZ (AZ 10) scale ACell10_8_scaled (by decide) rfl

theorem AZ_scale_11 : toVec (AZ 11) = (scale : ℚ) • ACell11_8 :=
  toVec_eq_smul_of_scaledZ (AZ 11) scale ACell11_8_scaled (by decide) rfl

theorem AZ_scale_12 : toVec (AZ 12) = (scale : ℚ) • ACell12_8 :=
  toVec_eq_smul_of_scaledZ (AZ 12) scale ACell12_8_scaled (by decide) rfl

theorem AZ_scale_13 : toVec (AZ 13) = (scale : ℚ) • ACell13_8 :=
  toVec_eq_smul_of_scaledZ (AZ 13) scale ACell13_8_scaled (by decide) rfl

theorem AZ_scale_14 : toVec (AZ 14) = (scale : ℚ) • ACell14_8 :=
  toVec_eq_smul_of_scaledZ (AZ 14) scale ACell14_8_scaled (by decide) rfl

theorem AZ_scale_15 : toVec (AZ 15) = (scale : ℚ) • ACell15_8 :=
  toVec_eq_smul_of_scaledZ (AZ 15) scale ACell15_8_scaled (by decide) rfl

theorem AZ_scale_16 : toVec (AZ 16) = (scale : ℚ) • ACell16_8 :=
  toVec_eq_smul_of_scaledZ (AZ 16) scale ACell16_8_scaled (by decide) rfl

theorem AZ_scale_17 : toVec (AZ 17) = (scale : ℚ) • ACell17_8 :=
  toVec_eq_smul_of_scaledZ (AZ 17) scale ACell17_8_scaled (by decide) rfl

theorem AZ_scale_18 : toVec (AZ 18) = (scale : ℚ) • ACell18_8 :=
  toVec_eq_smul_of_scaledZ (AZ 18) scale ACell18_8_scaled (by decide) rfl

theorem AZ_scale_19 : toVec (AZ 19) = (scale : ℚ) • ACell19_8 :=
  toVec_eq_smul_of_scaledZ (AZ 19) scale ACell19_8_scaled (by decide) rfl

theorem AZ_scale (k : Fin 20) :
    toVec (AZ k) = (scale : ℚ) • AVec k (8 : Fin 10) :=
  forall_fin20 (P := fun k => toVec (AZ k) = (scale : ℚ) • AVec k (8 : Fin 10))
    (toVec_smul_congr AZ_scale_0 AVec_apply_0_8)
    (toVec_smul_congr AZ_scale_1 AVec_apply_1_8)
    (toVec_smul_congr AZ_scale_2 AVec_apply_2_8)
    (toVec_smul_congr AZ_scale_3 AVec_apply_3_8)
    (toVec_smul_congr AZ_scale_4 AVec_apply_4_8)
    (toVec_smul_congr AZ_scale_5 AVec_apply_5_8)
    (toVec_smul_congr AZ_scale_6 AVec_apply_6_8)
    (toVec_smul_congr AZ_scale_7 AVec_apply_7_8)
    (toVec_smul_congr AZ_scale_8 AVec_apply_8_8)
    (toVec_smul_congr AZ_scale_9 AVec_apply_9_8)
    (toVec_smul_congr AZ_scale_10 AVec_apply_10_8)
    (toVec_smul_congr AZ_scale_11 AVec_apply_11_8)
    (toVec_smul_congr AZ_scale_12 AVec_apply_12_8)
    (toVec_smul_congr AZ_scale_13 AVec_apply_13_8)
    (toVec_smul_congr AZ_scale_14 AVec_apply_14_8)
    (toVec_smul_congr AZ_scale_15 AVec_apply_15_8)
    (toVec_smul_congr AZ_scale_16 AVec_apply_16_8)
    (toVec_smul_congr AZ_scale_17 AVec_apply_17_8)
    (toVec_smul_congr AZ_scale_18 AVec_apply_18_8)
    (toVec_smul_congr AZ_scale_19 AVec_apply_19_8)
    k

theorem KZ_scale_0 : toVec (KZ 0) = (scale : ℚ) • KCell5_0 :=
  toVec_eq_smul_of_scaledZ (KZ 0) scale KCell5_0_scaled (by decide) rfl

theorem KZ_scale (k : Fin 1) :
    toVec (KZ k) = (scale : ℚ) • KVec (5 : Fin 10) k :=
  forall_fin1 (P := fun k => toVec (KZ k) = (scale : ℚ) • KVec (5 : Fin 10) k)
    (toVec_smul_congr KZ_scale_0 KVec_apply_5_0)
    k

theorem YZ_scale_0 : toVec (YZ 0) = (scale : ℚ) • YCell0_8 :=
  toVec_eq_smul_of_scaledZ (YZ 0) scale YCell0_8_scaled (by decide) rfl

theorem YZ_scale (k : Fin 1) :
    toVec (YZ k) = (scale : ℚ) • YVec k (8 : Fin 10) :=
  forall_fin1 (P := fun k => toVec (YZ k) = (scale : ℚ) • YVec k (8 : Fin 10))
    (toVec_smul_congr YZ_scale_0 YVec_apply_0_8)
    k

theorem entry_eq :
    (matrixMul XVec AVec + matrixMul KVec YVec)
        (5 : Fin 10) (8 : Fin 10) = ![0, 0, 0, 0, 0, 0, 0, 0, 0, 0] := by
  rw [Matrix.add_apply, matrixMul_apply, matrixMul_apply]
  refine add_sum_mul_eq_of_scaled scale scale_ne_zero
    (fun k => XVec (5 : Fin 10) k)
    (fun k => AVec k (8 : Fin 10))
    (fun k => KVec (5 : Fin 10) k)
    (fun k => YVec k (8 : Fin 10))
    XZ AZ KZ YZ XZ_scale AZ_scale KZ_scale YZ_scale entryZ rfl _ ?_
  rw [entryZ_eq, toVec_zeroZ_smul, vec_zero_eq]

theorem entry_eq_matrixOne :
    (matrixMul XVec AVec + matrixMul KVec YVec)
        (5 : Fin 10) (8 : Fin 10) =
      matrixOne (Fin 10) (5 : Fin 10) (8 : Fin 10) :=
  entry_eq.trans (matrixOne_off10 (5 : Fin 10) (8 : Fin 10) (by decide)).symm

end V14Formalization.D12PieceAPSplitEntry5_8


namespace V14Formalization.D12PieceAPSplitEntry5_9
open D12CyclotomicVec D12CyclotomicVecZ D12PieceAPData
def payloadSha256 : String := "76c6196f29afe1a8398af99502447f48ebeed4bcb3805fc5dbec693940bc04b0"

def scale : ℤ := 132

def XZ (k : Fin 20) : VecZ :=
  match k.val with
  | 0 => #v[-81, -102, -153, -36, -39, -258, -84, -66, -78, -258]
  | 1 => #v[-21, -9, -60, -30, 0, -48, -21, 0, 27, -36]
  | 2 => #v[228, 84, 285, 135, 69, 303, 111, 237, -39, 402]
  | 3 => #v[-207, -42, -87, -153, -111, -96, 15, -228, -6, -108]
  | 4 => #v[42, 18, -3, 63, 72, 3, 45, 57, -15, -18]
  | 5 => #v[312, -30, 18, 168, 138, 66, 0, 312, 0, 72]
  | 6 => #v[-102, -156, -180, -30, -24, -180, -48, -126, -42, -234]
  | 7 => #v[324, -78, 126, 180, 60, 126, -18, 372, -138, 234]
  | 8 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  | 9 => #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  | 10 => #v[0, 33, 33, 0, 0, -33, -33, 33, -33, 0]
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
  | 19 => #v[-96, 0, 12, 0, 12, 24, 24, 12, 0, 12]
  | _ => zeroZ

def KZ (k : Fin 1) : VecZ :=
  match k.val with
  | 0 => #v[66, 0, 0, 66, 0, 66, 66, 66, 0, 0]
  | _ => zeroZ

def YZ (k : Fin 1) : VecZ :=
  match k.val with
  | 0 => #v[-176, -88, 0, 0, -176, 0, 0, -88, -176, -88]
  | _ => zeroZ

def xaEntryZ : VecZ := sumFin (fun k => mulZ (XZ k) (AZ k))
def kyEntryZ : VecZ := sumFin (fun k => mulZ (KZ k) (YZ k))
def entryZ : VecZ := addZ xaEntryZ kyEntryZ

theorem entryZ_eq : entryZ = zeroZ :=
  eq_of_eqZ (by decide +kernel)

theorem scale_ne_zero : scale ≠ 0 := by
  decide

theorem XZ_scale_0 : toVec (XZ 0) = (scale : ℚ) • XCell5_0 :=
  toVec_eq_smul_of_scaledZ (XZ 0) scale XCell5_0_scaled (by decide) rfl

theorem XZ_scale_1 : toVec (XZ 1) = (scale : ℚ) • XCell5_1 :=
  toVec_eq_smul_of_scaledZ (XZ 1) scale XCell5_1_scaled (by decide) rfl

theorem XZ_scale_2 : toVec (XZ 2) = (scale : ℚ) • XCell5_2 :=
  toVec_eq_smul_of_scaledZ (XZ 2) scale XCell5_2_scaled (by decide) rfl

theorem XZ_scale_3 : toVec (XZ 3) = (scale : ℚ) • XCell5_3 :=
  toVec_eq_smul_of_scaledZ (XZ 3) scale XCell5_3_scaled (by decide) rfl

theorem XZ_scale_4 : toVec (XZ 4) = (scale : ℚ) • XCell5_4 :=
  toVec_eq_smul_of_scaledZ (XZ 4) scale XCell5_4_scaled (by decide) rfl

theorem XZ_scale_5 : toVec (XZ 5) = (scale : ℚ) • XCell5_5 :=
  toVec_eq_smul_of_scaledZ (XZ 5) scale XCell5_5_scaled (by decide) rfl

theorem XZ_scale_6 : toVec (XZ 6) = (scale : ℚ) • XCell5_6 :=
  toVec_eq_smul_of_scaledZ (XZ 6) scale XCell5_6_scaled (by decide) rfl

theorem XZ_scale_7 : toVec (XZ 7) = (scale : ℚ) • XCell5_7 :=
  toVec_eq_smul_of_scaledZ (XZ 7) scale XCell5_7_scaled (by decide) rfl

theorem XZ_scale_8 : toVec (XZ 8) = (scale : ℚ) • XCell5_8 :=
  toVec_eq_smul_of_scaledZ (XZ 8) scale XCell5_8_scaled (by decide) rfl

theorem XZ_scale_9 : toVec (XZ 9) = (scale : ℚ) • XCell5_9 :=
  toVec_eq_smul_of_scaledZ (XZ 9) scale XCell5_9_scaled (by decide) rfl

theorem XZ_scale_10 : toVec (XZ 10) = (scale : ℚ) • XCell5_10 :=
  toVec_eq_smul_of_scaledZ (XZ 10) scale XCell5_10_scaled (by decide) rfl

theorem XZ_scale_11 : toVec (XZ 11) = (scale : ℚ) • XCell5_11 :=
  toVec_eq_smul_of_scaledZ (XZ 11) scale XCell5_11_scaled (by decide) rfl

theorem XZ_scale_12 : toVec (XZ 12) = (scale : ℚ) • XCell5_12 :=
  toVec_eq_smul_of_scaledZ (XZ 12) scale XCell5_12_scaled (by decide) rfl

theorem XZ_scale_13 : toVec (XZ 13) = (scale : ℚ) • XCell5_13 :=
  toVec_eq_smul_of_scaledZ (XZ 13) scale XCell5_13_scaled (by decide) rfl

theorem XZ_scale_14 : toVec (XZ 14) = (scale : ℚ) • XCell5_14 :=
  toVec_eq_smul_of_scaledZ (XZ 14) scale XCell5_14_scaled (by decide) rfl

theorem XZ_scale_15 : toVec (XZ 15) = (scale : ℚ) • XCell5_15 :=
  toVec_eq_smul_of_scaledZ (XZ 15) scale XCell5_15_scaled (by decide) rfl

theorem XZ_scale_16 : toVec (XZ 16) = (scale : ℚ) • XCell5_16 :=
  toVec_eq_smul_of_scaledZ (XZ 16) scale XCell5_16_scaled (by decide) rfl

theorem XZ_scale_17 : toVec (XZ 17) = (scale : ℚ) • XCell5_17 :=
  toVec_eq_smul_of_scaledZ (XZ 17) scale XCell5_17_scaled (by decide) rfl

theorem XZ_scale_18 : toVec (XZ 18) = (scale : ℚ) • XCell5_18 :=
  toVec_eq_smul_of_scaledZ (XZ 18) scale XCell5_18_scaled (by decide) rfl

theorem XZ_scale_19 : toVec (XZ 19) = (scale : ℚ) • XCell5_19 :=
  toVec_eq_smul_of_scaledZ (XZ 19) scale XCell5_19_scaled (by decide) rfl

theorem XZ_scale (k : Fin 20) :
    toVec (XZ k) = (scale : ℚ) • XVec (5 : Fin 10) k :=
  forall_fin20 (P := fun k => toVec (XZ k) = (scale : ℚ) • XVec (5 : Fin 10) k)
    (toVec_smul_congr XZ_scale_0 XVec_apply_5_0)
    (toVec_smul_congr XZ_scale_1 XVec_apply_5_1)
    (toVec_smul_congr XZ_scale_2 XVec_apply_5_2)
    (toVec_smul_congr XZ_scale_3 XVec_apply_5_3)
    (toVec_smul_congr XZ_scale_4 XVec_apply_5_4)
    (toVec_smul_congr XZ_scale_5 XVec_apply_5_5)
    (toVec_smul_congr XZ_scale_6 XVec_apply_5_6)
    (toVec_smul_congr XZ_scale_7 XVec_apply_5_7)
    (toVec_smul_congr XZ_scale_8 XVec_apply_5_8)
    (toVec_smul_congr XZ_scale_9 XVec_apply_5_9)
    (toVec_smul_congr XZ_scale_10 XVec_apply_5_10)
    (toVec_smul_congr XZ_scale_11 XVec_apply_5_11)
    (toVec_smul_congr XZ_scale_12 XVec_apply_5_12)
    (toVec_smul_congr XZ_scale_13 XVec_apply_5_13)
    (toVec_smul_congr XZ_scale_14 XVec_apply_5_14)
    (toVec_smul_congr XZ_scale_15 XVec_apply_5_15)
    (toVec_smul_congr XZ_scale_16 XVec_apply_5_16)
    (toVec_smul_congr XZ_scale_17 XVec_apply_5_17)
    (toVec_smul_congr XZ_scale_18 XVec_apply_5_18)
    (toVec_smul_congr XZ_scale_19 XVec_apply_5_19)
    k

theorem AZ_scale_0 : toVec (AZ 0) = (scale : ℚ) • ACell0_9 :=
  toVec_eq_smul_of_scaledZ (AZ 0) scale ACell0_9_scaled (by decide) rfl

theorem AZ_scale_1 : toVec (AZ 1) = (scale : ℚ) • ACell1_9 :=
  toVec_eq_smul_of_scaledZ (AZ 1) scale ACell1_9_scaled (by decide) rfl

theorem AZ_scale_2 : toVec (AZ 2) = (scale : ℚ) • ACell2_9 :=
  toVec_eq_smul_of_scaledZ (AZ 2) scale ACell2_9_scaled (by decide) rfl

theorem AZ_scale_3 : toVec (AZ 3) = (scale : ℚ) • ACell3_9 :=
  toVec_eq_smul_of_scaledZ (AZ 3) scale ACell3_9_scaled (by decide) rfl

theorem AZ_scale_4 : toVec (AZ 4) = (scale : ℚ) • ACell4_9 :=
  toVec_eq_smul_of_scaledZ (AZ 4) scale ACell4_9_scaled (by decide) rfl

theorem AZ_scale_5 : toVec (AZ 5) = (scale : ℚ) • ACell5_9 :=
  toVec_eq_smul_of_scaledZ (AZ 5) scale ACell5_9_scaled (by decide) rfl

theorem AZ_scale_6 : toVec (AZ 6) = (scale : ℚ) • ACell6_9 :=
  toVec_eq_smul_of_scaledZ (AZ 6) scale ACell6_9_scaled (by decide) rfl

theorem AZ_scale_7 : toVec (AZ 7) = (scale : ℚ) • ACell7_9 :=
  toVec_eq_smul_of_scaledZ (AZ 7) scale ACell7_9_scaled (by decide) rfl

theorem AZ_scale_8 : toVec (AZ 8) = (scale : ℚ) • ACell8_9 :=
  toVec_eq_smul_of_scaledZ (AZ 8) scale ACell8_9_scaled (by decide) rfl

theorem AZ_scale_9 : toVec (AZ 9) = (scale : ℚ) • ACell9_9 :=
  toVec_eq_smul_of_scaledZ (AZ 9) scale ACell9_9_scaled (by decide) rfl

theorem AZ_scale_10 : toVec (AZ 10) = (scale : ℚ) • ACell10_9 :=
  toVec_eq_smul_of_scaledZ (AZ 10) scale ACell10_9_scaled (by decide) rfl

theorem AZ_scale_11 : toVec (AZ 11) = (scale : ℚ) • ACell11_9 :=
  toVec_eq_smul_of_scaledZ (AZ 11) scale ACell11_9_scaled (by decide) rfl

theorem AZ_scale_12 : toVec (AZ 12) = (scale : ℚ) • ACell12_9 :=
  toVec_eq_smul_of_scaledZ (AZ 12) scale ACell12_9_scaled (by decide) rfl

theorem AZ_scale_13 : toVec (AZ 13) = (scale : ℚ) • ACell13_9 :=
  toVec_eq_smul_of_scaledZ (AZ 13) scale ACell13_9_scaled (by decide) rfl

theorem AZ_scale_14 : toVec (AZ 14) = (scale : ℚ) • ACell14_9 :=
  toVec_eq_smul_of_scaledZ (AZ 14) scale ACell14_9_scaled (by decide) rfl

theorem AZ_scale_15 : toVec (AZ 15) = (scale : ℚ) • ACell15_9 :=
  toVec_eq_smul_of_scaledZ (AZ 15) scale ACell15_9_scaled (by decide) rfl

theorem AZ_scale_16 : toVec (AZ 16) = (scale : ℚ) • ACell16_9 :=
  toVec_eq_smul_of_scaledZ (AZ 16) scale ACell16_9_scaled (by decide) rfl

theorem AZ_scale_17 : toVec (AZ 17) = (scale : ℚ) • ACell17_9 :=
  toVec_eq_smul_of_scaledZ (AZ 17) scale ACell17_9_scaled (by decide) rfl

theorem AZ_scale_18 : toVec (AZ 18) = (scale : ℚ) • ACell18_9 :=
  toVec_eq_smul_of_scaledZ (AZ 18) scale ACell18_9_scaled (by decide) rfl

theorem AZ_scale_19 : toVec (AZ 19) = (scale : ℚ) • ACell19_9 :=
  toVec_eq_smul_of_scaledZ (AZ 19) scale ACell19_9_scaled (by decide) rfl

theorem AZ_scale (k : Fin 20) :
    toVec (AZ k) = (scale : ℚ) • AVec k (9 : Fin 10) :=
  forall_fin20 (P := fun k => toVec (AZ k) = (scale : ℚ) • AVec k (9 : Fin 10))
    (toVec_smul_congr AZ_scale_0 AVec_apply_0_9)
    (toVec_smul_congr AZ_scale_1 AVec_apply_1_9)
    (toVec_smul_congr AZ_scale_2 AVec_apply_2_9)
    (toVec_smul_congr AZ_scale_3 AVec_apply_3_9)
    (toVec_smul_congr AZ_scale_4 AVec_apply_4_9)
    (toVec_smul_congr AZ_scale_5 AVec_apply_5_9)
    (toVec_smul_congr AZ_scale_6 AVec_apply_6_9)
    (toVec_smul_congr AZ_scale_7 AVec_apply_7_9)
    (toVec_smul_congr AZ_scale_8 AVec_apply_8_9)
    (toVec_smul_congr AZ_scale_9 AVec_apply_9_9)
    (toVec_smul_congr AZ_scale_10 AVec_apply_10_9)
    (toVec_smul_congr AZ_scale_11 AVec_apply_11_9)
    (toVec_smul_congr AZ_scale_12 AVec_apply_12_9)
    (toVec_smul_congr AZ_scale_13 AVec_apply_13_9)
    (toVec_smul_congr AZ_scale_14 AVec_apply_14_9)
    (toVec_smul_congr AZ_scale_15 AVec_apply_15_9)
    (toVec_smul_congr AZ_scale_16 AVec_apply_16_9)
    (toVec_smul_congr AZ_scale_17 AVec_apply_17_9)
    (toVec_smul_congr AZ_scale_18 AVec_apply_18_9)
    (toVec_smul_congr AZ_scale_19 AVec_apply_19_9)
    k

theorem KZ_scale_0 : toVec (KZ 0) = (scale : ℚ) • KCell5_0 :=
  toVec_eq_smul_of_scaledZ (KZ 0) scale KCell5_0_scaled (by decide) rfl

theorem KZ_scale (k : Fin 1) :
    toVec (KZ k) = (scale : ℚ) • KVec (5 : Fin 10) k :=
  forall_fin1 (P := fun k => toVec (KZ k) = (scale : ℚ) • KVec (5 : Fin 10) k)
    (toVec_smul_congr KZ_scale_0 KVec_apply_5_0)
    k

theorem YZ_scale_0 : toVec (YZ 0) = (scale : ℚ) • YCell0_9 :=
  toVec_eq_smul_of_scaledZ (YZ 0) scale YCell0_9_scaled (by decide) rfl

theorem YZ_scale (k : Fin 1) :
    toVec (YZ k) = (scale : ℚ) • YVec k (9 : Fin 10) :=
  forall_fin1 (P := fun k => toVec (YZ k) = (scale : ℚ) • YVec k (9 : Fin 10))
    (toVec_smul_congr YZ_scale_0 YVec_apply_0_9)
    k

theorem entry_eq :
    (matrixMul XVec AVec + matrixMul KVec YVec)
        (5 : Fin 10) (9 : Fin 10) = ![0, 0, 0, 0, 0, 0, 0, 0, 0, 0] := by
  rw [Matrix.add_apply, matrixMul_apply, matrixMul_apply]
  refine add_sum_mul_eq_of_scaled scale scale_ne_zero
    (fun k => XVec (5 : Fin 10) k)
    (fun k => AVec k (9 : Fin 10))
    (fun k => KVec (5 : Fin 10) k)
    (fun k => YVec k (9 : Fin 10))
    XZ AZ KZ YZ XZ_scale AZ_scale KZ_scale YZ_scale entryZ rfl _ ?_
  rw [entryZ_eq, toVec_zeroZ_smul, vec_zero_eq]

theorem entry_eq_matrixOne :
    (matrixMul XVec AVec + matrixMul KVec YVec)
        (5 : Fin 10) (9 : Fin 10) =
      matrixOne (Fin 10) (5 : Fin 10) (9 : Fin 10) :=
  entry_eq.trans (matrixOne_off10 (5 : Fin 10) (9 : Fin 10) (by decide)).symm

end V14Formalization.D12PieceAPSplitEntry5_9


namespace V14Formalization.D12PieceAPSplitRow5
open D12CyclotomicVec D12PieceAPData

public theorem row_eq (j : Fin 10) :
    (matrixMul XVec AVec + matrixMul KVec YVec)
      (5 : Fin 10) j = matrixOne (Fin 10) (5 : Fin 10) j :=
  D12CyclotomicVecZ.forall_fin10
    (P := fun j => (matrixMul XVec AVec + matrixMul KVec YVec) (5 : Fin 10) j = matrixOne (Fin 10) (5 : Fin 10) j)
    D12PieceAPSplitEntry5_0.entry_eq_matrixOne
    D12PieceAPSplitEntry5_1.entry_eq_matrixOne
    D12PieceAPSplitEntry5_2.entry_eq_matrixOne
    D12PieceAPSplitEntry5_3.entry_eq_matrixOne
    D12PieceAPSplitEntry5_4.entry_eq_matrixOne
    D12PieceAPSplitEntry5_5.entry_eq_matrixOne
    D12PieceAPSplitEntry5_6.entry_eq_matrixOne
    D12PieceAPSplitEntry5_7.entry_eq_matrixOne
    D12PieceAPSplitEntry5_8.entry_eq_matrixOne
    D12PieceAPSplitEntry5_9.entry_eq_matrixOne
    j

end V14Formalization.D12PieceAPSplitRow5
