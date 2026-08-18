/-
Copyright (c) 2026 V14Formalization contributors.
Released under Apache 2.0 license.
-/
module

public import V14Formalization.D12CyclotomicVec

/-!
# Kernel-reducing integer model of `ℤ[ζ₁₁]`

`Vec` is valued in `ℚ`, and `Rat.add` / `Rat.mul` are irreducible, so the
kernel cannot check a cyclotomic product by reduction.  `VecZ` stores the
same ten coefficients as integers.  After a per-module denominator LCM,
`decide` discharges the identity, and `sum_mul_eq_of_scaled` lifts it back
to the published `Vec` statement.
-/

namespace V14Formalization.D12CyclotomicVecZ

open V14Formalization.D12CyclotomicVec
open scoped BigOperators

public abbrev VecZ := Vector Int 10

@[expose] public def coeffAtZ (a : VecZ) (n : ℕ) : Int :=
  if h : n < 10 then a[n] else 0

/-- One convolution term.  Written as a closed `if` so the kernel reduces it. -/
@[expose] public def convTerm (a b : VecZ) (n i : ℕ) : Int :=
  if h : i < 10 ∧ i ≤ n then a[i] * coeffAtZ b (n - i) else 0

/-- Unrolled ten-term convolution; `Fin.foldl` does not reduce under `decide`. -/
@[expose] public def convZ (a b : VecZ) (n : ℕ) : Int :=
  convTerm a b n 0 + convTerm a b n 1 + convTerm a b n 2 + convTerm a b n 3 +
    convTerm a b n 4 + convTerm a b n 5 + convTerm a b n 6 + convTerm a b n 7 +
      convTerm a b n 8 + convTerm a b n 9

@[expose] public def mulCoeff (a b : VecZ) (k : ℕ) : Int :=
  convZ a b k + convZ a b (k + 11) - convZ a b 10

@[expose] public def mulZ (a b : VecZ) : VecZ :=
  #v[mulCoeff a b 0, mulCoeff a b 1, mulCoeff a b 2, mulCoeff a b 3, mulCoeff a b 4,
    mulCoeff a b 5, mulCoeff a b 6, mulCoeff a b 7, mulCoeff a b 8, mulCoeff a b 9]

@[expose] public def addZ (x y : VecZ) : VecZ :=
  #v[x[0] + y[0], x[1] + y[1], x[2] + y[2], x[3] + y[3], x[4] + y[4],
    x[5] + y[5], x[6] + y[6], x[7] + y[7], x[8] + y[8], x[9] + y[9]]

@[expose] public def zeroZ : VecZ := #v[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]

/-- Structural recursion, so a concrete `n` reduces under `decide`. -/
@[expose] public def sumFin {n : ℕ} (f : Fin n → VecZ) : VecZ :=
  go n (Nat.le_refl n)
where
  go : (k : ℕ) → k ≤ n → VecZ
  | 0, _ => zeroZ
  | k + 1, h => addZ (go k (Nat.le_of_succ_le h)) (f ⟨k, Nat.lt_of_succ_le h⟩)

@[expose] public def scaleSqE0 (s : Int) : VecZ :=
  #v[s * s, 0, 0, 0, 0, 0, 0, 0, 0, 0]

@[expose] public def toVec (v : VecZ) : Vec :=
  fun i => (v[i.val] : ℚ)

/-- Integer scaling of a `VecZ`, written out coordinatewise so the kernel
reduces it (the same reason `mulZ` and `addZ` are written this way). -/
@[expose] public def smulZ (s : Int) (v : VecZ) : VecZ :=
  #v[s * v[0], s * v[1], s * v[2], s * v[3], s * v[4],
    s * v[5], s * v[6], s * v[7], s * v[8], s * v[9]]

/-! ### Kernel-reducible equality test

`VecZ = Vector Int 10`, and `Vector`'s `DecidableEq` instance does **not**
reduce: `instDecidableEqVector.decEq` and `Array.instDecidableEqImpl` are
`public` but not `@[expose]`d in the Lean 4.32.1 toolchain, so `decide` — and
`decide +kernel` — get stuck even on `#v[1,2,3] = #v[1,2,3]`.  Project-side
annotations cannot fix a toolchain declaration, and the previous remedy was
`import all Init.Data.Vector.Basic` / `import all Init.Data.Array.DecidableEq`
in every deciding module.

`eqZ` replaces that with a coordinatewise `Bool` test.  `Int`'s `BEq` and
`Bool`'s `&&` reduce in the kernel, so `decide +kernel` discharges `eqZ a b`
with no `import all` anywhere, and the two lemmas below carry the result to
the `Eq`/`Ne` the certificates state.  The arithmetic content is unchanged:
the kernel still evaluates every convolution coefficient and compares all ten
of them. -/

/-- Coordinatewise equality test on `VecZ`, in a form the kernel reduces. -/
@[expose] public def eqZ (a b : VecZ) : Bool :=
  a[0] == b[0] && a[1] == b[1] && a[2] == b[2] && a[3] == b[3] && a[4] == b[4] &&
    a[5] == b[5] && a[6] == b[6] && a[7] == b[7] && a[8] == b[8] && a[9] == b[9]

/-- All ten coordinates agree, so the vectors are equal. -/
public theorem eq_of_eqZ {a b : VecZ} (h : eqZ a b = true) : a = b := by
  simp only [eqZ, Bool.and_eq_true, beq_iff_eq] at h
  obtain ⟨⟨⟨⟨⟨⟨⟨⟨⟨h0, h1⟩, h2⟩, h3⟩, h4⟩, h5⟩, h6⟩, h7⟩, h8⟩, h9⟩ := h
  ext i hi
  match i, hi with
  | 0, _ => exact h0
  | 1, _ => exact h1
  | 2, _ => exact h2
  | 3, _ => exact h3
  | 4, _ => exact h4
  | 5, _ => exact h5
  | 6, _ => exact h6
  | 7, _ => exact h7
  | 8, _ => exact h8
  | 9, _ => exact h9

/-- Some coordinate differs, so the vectors are distinct. -/
public theorem ne_of_eqZ_false {a b : VecZ} (h : eqZ a b = false) : a ≠ b := by
  intro hab
  rw [hab] at h
  simp [eqZ] at h

/-! ### Sample product from `D12PieceAPSplitEntry7_9`, first nonzero XA term.

Scaled by the entry LCM `132`.  `decide` succeeds on the true product and
fails (the inequality is proved) after mutating one literal. -/

def sampleX : VecZ := #v[-15, 81, -156, 39, 57, -48, -63, 78, 54, -93]
def sampleA : VecZ := #v[0, 0, 24, 0, -24, 0, -24, 0, 24, 0]
def sampleProd : VecZ :=
  #v[288, 3888, 1152, 1440, 3024, 2592, 5544, -1728, 2808, 6336]
def sampleProdMutated : VecZ :=
  #v[289, 3888, 1152, 1440, 3024, 2592, 5544, -1728, 2808, 6336]

theorem sample_mul_eq : mulZ sampleX sampleA = sampleProd :=
  eq_of_eqZ (by decide +kernel)

/-- Canary: the deliberately mutated product must NOT be provable.  The kernel
still evaluates the full convolution and compares all ten coordinates, so a
silent arithmetic regression fails this. -/
theorem sample_mul_ne_mutated : mulZ sampleX sampleA ≠ sampleProdMutated :=
  ne_of_eqZ_false (by decide +kernel)

/-! ### Cast and homomorphism -/

theorem toVec_get (v : VecZ) (i : Fin 10) : toVec v i = (v[i.val] : ℚ) :=
  rfl

theorem coeffAtZ_toVec (a : VecZ) (n : ℕ) :
    (coeffAtZ a n : ℚ) = coeffAt (toVec a) n := by
  unfold coeffAtZ coeffAt toVec
  split_ifs <;> rfl

theorem convTerm_toVec (a b : VecZ) (n : ℕ) (i : Fin 10) :
    (convTerm a b n i.val : ℚ) =
      if _hi : i.val ≤ n then toVec a i * coeffAt (toVec b) (n - i.val) else 0 := by
  unfold convTerm
  have hi : i.val < 10 := i.isLt
  by_cases hle : i.val ≤ n
  · simp [hi, hle, toVec, coeffAtZ_toVec]
  · simp [hle]

theorem convZ_eq_sum (a b : VecZ) (n : ℕ) :
    convZ a b n = ∑ i : Fin 10, convTerm a b n i.val := by
  simp [convZ, Fin.sum_univ_succ]
  ring

theorem convZ_toVec (a b : VecZ) (n : ℕ) :
    (convZ a b n : ℚ) = conv (toVec a) (toVec b) n := by
  rw [convZ_eq_sum, conv, Int.cast_sum]
  refine Finset.sum_congr rfl fun i _ => ?_
  exact convTerm_toVec a b n i

theorem mulCoeff_toVec (a b : VecZ) (k : ℕ) :
    (mulCoeff a b k : ℚ) =
      conv (toVec a) (toVec b) k + conv (toVec a) (toVec b) (k + 11) -
        conv (toVec a) (toVec b) 10 := by
  simp [mulCoeff, convZ_toVec]

theorem toVec_mul (a b : VecZ) : toVec (mulZ a b) = mul (toVec a) (toVec b) := by
  funext k
  fin_cases k <;> simp [toVec, mulZ, mul, mulCoeff_toVec]

public theorem toVec_smulZ (s : ℤ) (v : VecZ) :
    toVec (smulZ s v) = (s : ℚ) • toVec v := by
  funext i
  match i with
  | ⟨0, _⟩ | ⟨1, _⟩ | ⟨2, _⟩ | ⟨3, _⟩ | ⟨4, _⟩
  | ⟨5, _⟩ | ⟨6, _⟩ | ⟨7, _⟩ | ⟨8, _⟩ | ⟨9, _⟩ =>
      simp [toVec, smulZ]
  | ⟨n + 10, h⟩ => exact absurd h (by omega)

theorem toVec_add (x y : VecZ) : toVec (addZ x y) = toVec x + toVec y := by
  funext i
  fin_cases i <;> simp [toVec, addZ, Pi.add_apply]

theorem toVec_zeroZ : toVec zeroZ = 0 := by
  funext i
  fin_cases i <;> simp [toVec, zeroZ]

theorem toVec_sumFin_go {n : ℕ} (f : Fin n → VecZ) :
    ∀ k hk, toVec (sumFin.go f k hk) =
      ∑ i : Fin k, toVec (f ⟨i.val, Nat.lt_of_lt_of_le i.isLt hk⟩) := by
  intro k hk
  induction k with
  | zero =>
      simp [sumFin.go, toVec_zeroZ]
  | succ k ih =>
      rw [sumFin.go, toVec_add, ih (Nat.le_of_succ_le hk), Fin.sum_univ_castSucc]
      simp

theorem toVec_sumFin {n : ℕ} (f : Fin n → VecZ) :
    toVec (sumFin f) = ∑ i : Fin n, toVec (f i) := by
  simpa [sumFin] using toVec_sumFin_go f n (Nat.le_refl n)

public theorem toVec_scaleSqE0 (s : ℤ) :
    toVec (scaleSqE0 s) = ((s : ℚ) * s) • constVec 1 := by
  funext i
  fin_cases i <;> simp [toVec, scaleSqE0, constVec, basis, Pi.smul_apply, smul_eq_mul]

public theorem toVec_zeroZ_smul (s : ℤ) :
    toVec zeroZ = ((s : ℚ) * s) • (0 : Vec) := by
  simp [toVec_zeroZ]

/-! ### Rational scaling lemmas used by generated shards -/

public theorem eq_smul_div (n s num den : ℤ) (hden : den ≠ 0)
    (h : n * den = s * num) :
    (n : ℚ) = (s : ℚ) * (num / den : ℚ) := by
  have : (den : ℚ) ≠ 0 := Int.cast_ne_zero.mpr hden
  field_simp
  exact_mod_cast h

public theorem eq_smul_int (n s m : ℤ) (h : n = s * m) :
    (n : ℚ) = (s : ℚ) * (m : ℚ) := by
  exact_mod_cast h

public theorem eq_smul_zero (s : ℤ) : ((0 : ℤ) : ℚ) = (s : ℚ) * (0 : ℚ) := by
  simp

theorem eq_smul_inv (n s den : ℤ) (hden : den ≠ 0) (h : n * den = s) :
    (n : ℚ) = (s : ℚ) * (den : ℚ)⁻¹ := by
  have : (den : ℚ) ≠ 0 := Int.cast_ne_zero.mpr hden
  field_simp
  exact_mod_cast h

theorem eq_smul_neg_inv (n s den : ℤ) (hden : den ≠ 0) (h : n * den = -s) :
    (n : ℚ) = (s : ℚ) * (-(den : ℚ)⁻¹) := by
  have := eq_smul_inv n (-s) den hden (by simpa using h)
  simpa [neg_mul, mul_neg] using this

theorem eq_smul_mul_inv (n s num den : ℤ) (hden : den ≠ 0)
    (h : n * den = s * num) :
    (n : ℚ) = (s : ℚ) * ((num : ℚ) * (den : ℚ)⁻¹) := by
  simpa [div_eq_mul_inv] using eq_smul_div n s num den hden h

theorem eq_smul_neg_mul_inv (n s num den : ℤ) (hden : den ≠ 0)
    (h : n * den = -(s * num)) :
    (n : ℚ) = (s : ℚ) * (-((num : ℚ) * (den : ℚ)⁻¹)) := by
  have := eq_smul_mul_inv n (-s) num den hden (by simpa [neg_mul] using h)
  simpa [neg_mul, mul_neg] using this

public theorem constVec_one_eq :
    constVec 1 = ![1, 0, 0, 0, 0, 0, 0, 0, 0, 0] := by
  funext i
  fin_cases i <;> simp [constVec, basis]

public theorem vec_zero_eq : (0 : Vec) = ![0, 0, 0, 0, 0, 0, 0, 0, 0, 0] := by
  funext i
  fin_cases i <;> rfl

/-- Close a coordinate goal `(n : ℚ) = (s : ℚ) * q` after unfolding cell tables. -/
macro "discharge_scale" s:term : tactic =>
  `(tactic| first
      | rfl
      | exact eq_smul_zero $s
      | (apply eq_smul_int; decide; decide)
      | (apply eq_smul_inv; decide; decide)
      | (apply eq_smul_neg_inv; decide; decide)
      | (apply eq_smul_div; decide; decide)
      | (apply eq_smul_mul_inv; decide; decide)
      | (apply eq_smul_neg_mul_inv; decide; decide))

public theorem smul_Vec_injective {s : ℚ} (hs : s ≠ 0) :
    Function.Injective fun v : Vec => s • v := by
  intro a b h
  funext i
  have hi := congrFun h i
  simp only [Pi.smul_apply, smul_eq_mul] at hi
  exact mul_left_cancel₀ hs hi

theorem mul_smul_smul (s : ℚ) (a b : Vec) :
    mul (s • a) (s • b) = (s * s) • mul a b := by
  rw [mul_smul_left, mul_smul_right, smul_smul]

/-- One shared lift: a scaled integer sum of products implies the `Vec` sum. -/
public theorem sum_mul_eq_of_scaled {n : ℕ} (s : ℤ) (hs : s ≠ 0)
    (left right : Fin n → Vec) (leftZ rightZ : Fin n → VecZ)
    (hleft : ∀ k, toVec (leftZ k) = (s : ℚ) • left k)
    (hright : ∀ k, toVec (rightZ k) = (s : ℚ) • right k)
    (sumZ : VecZ)
    (hsumZ : sumFin (fun k => mulZ (leftZ k) (rightZ k)) = sumZ)
    (target : Vec)
    (htarget : toVec sumZ = ((s : ℚ) * s) • target) :
    (∑ k : Fin n, mul (left k) (right k)) = target := by
  have hsQ : (s : ℚ) ≠ 0 := Int.cast_ne_zero.mpr hs
  have hss : ((s : ℚ) * s) ≠ 0 := mul_ne_zero hsQ hsQ
  have hcast :
      toVec (sumFin (fun k => mulZ (leftZ k) (rightZ k))) =
        (s * s : ℚ) • ∑ k : Fin n, mul (left k) (right k) := by
    rw [toVec_sumFin]
    refine Eq.trans ?_ (Finset.smul_sum.symm)
    refine Finset.sum_congr rfl fun k _ => ?_
    rw [toVec_mul, hleft k, hright k, mul_smul_smul]
  rw [hsumZ] at hcast
  exact smul_Vec_injective hss (hcast.symm.trans htarget)

/-- Two-family form used by AP / AA / PP (`XA + KY`). -/
public theorem add_sum_mul_eq_of_scaled {n m : ℕ} (s : ℤ) (hs : s ≠ 0)
    (X A : Fin n → Vec) (K Y : Fin m → Vec)
    (XZ AZ : Fin n → VecZ) (KZ YZ : Fin m → VecZ)
    (hX : ∀ k, toVec (XZ k) = (s : ℚ) • X k)
    (hA : ∀ k, toVec (AZ k) = (s : ℚ) • A k)
    (hK : ∀ k, toVec (KZ k) = (s : ℚ) • K k)
    (hY : ∀ k, toVec (YZ k) = (s : ℚ) • Y k)
    (sumZ : VecZ)
    (hsumZ :
      addZ (sumFin (fun k => mulZ (XZ k) (AZ k)))
        (sumFin (fun k => mulZ (KZ k) (YZ k))) = sumZ)
    (target : Vec)
    (htarget : toVec sumZ = ((s : ℚ) * s) • target) :
    (∑ k : Fin n, mul (X k) (A k)) + (∑ k : Fin m, mul (K k) (Y k)) =
      target := by
  have hsQ : (s : ℚ) ≠ 0 := Int.cast_ne_zero.mpr hs
  have hss : ((s : ℚ) * s) ≠ 0 := mul_ne_zero hsQ hsQ
  have hXA :
      toVec (sumFin (fun k => mulZ (XZ k) (AZ k))) =
        (s * s : ℚ) • ∑ k : Fin n, mul (X k) (A k) := by
    rw [toVec_sumFin]
    refine Eq.trans ?_ (Finset.smul_sum.symm)
    refine Finset.sum_congr rfl fun k _ => ?_
    rw [toVec_mul, hX k, hA k, mul_smul_smul]
  have hKY :
      toVec (sumFin (fun k => mulZ (KZ k) (YZ k))) =
        (s * s : ℚ) • ∑ k : Fin m, mul (K k) (Y k) := by
    rw [toVec_sumFin]
    refine Eq.trans ?_ (Finset.smul_sum.symm)
    refine Finset.sum_congr rfl fun k _ => ?_
    rw [toVec_mul, hK k, hY k, mul_smul_smul]
  have hcast :
      toVec (addZ (sumFin (fun k => mulZ (XZ k) (AZ k)))
          (sumFin (fun k => mulZ (KZ k) (YZ k)))) =
        (s * s : ℚ) •
          ((∑ k : Fin n, mul (X k) (A k)) +
            ∑ k : Fin m, mul (K k) (Y k)) := by
    rw [toVec_add, hXA, hKY, smul_add]
  rw [hsumZ] at hcast
  exact smul_Vec_injective hss (hcast.symm.trans htarget)

end V14Formalization.D12CyclotomicVecZ
