/-
Copyright (c) 2026 V14Formalization contributors.
Released under Apache 2.0 license.

Internal numerical D12 seal over `WeilRep.K` with base change along injective
`algebraMap WeilRep.K Ω`. No geometric bridge is claimed.

## Proved

* Power-basis `KVec` arithmetic (`ofKVec_mul`, `ofKVec_eq_zero_iff`).
* Transparent nested/flat decoders (definitions).
* Explicit pure-ℚ sparse `B₀`, `L₀`, `P₀` with
  `L₀ * B₀ = 1`, `B₀ * L₀ = P₀`, `P₀ * P₀ = P₀`.
* `stackA` via `Fin.addCases` and the action-kernel characterisation
  (generic in `RM`/`SM`, and over base-changed `Ω`).
* Base-change helpers: `mapMatrix`, multiplicativity, one, det, nonzero transport.
* Exported Plücker `C` is the *raw* wedge form (= 2 · normalized
  `pluckerValue`).  Normalized matrices are `PP_C = (1/2) • PP_C_raw`, etc.;
  for 3×3, `det(c • M) = c³ det M` so the PP scale is `/8`.
* Nonvanishing of exported `deltaPP` / `deltaAP` / `deltaAA` in `K`.

## Exact missing package

`missing_for_certificateK` lists the dense finite identities still required
for a full `D12Certificate.Certificate`.  No `sorry`, no `native_decide`,
no unfinished proof terms.  Endpoints `certificateK` / base change / four
`no_*` are **not** declared until that package is closed.
-/
import V14Formalization.D12SealData
import V14Formalization.D12MatrixCertificate
import V14Formalization.WeilRep
import Mathlib.Algebra.BigOperators.Fin
import Mathlib.Data.Matrix.Basic
import Mathlib.Tactic.FinCases
import Mathlib.Tactic.NormNum
import Mathlib.Tactic.Ring
import Mathlib.Tactic.LinearCombination
import Mathlib.LinearAlgebra.Matrix.NonsingularInverse
import Mathlib.RingTheory.AdjoinRoot

noncomputable section

open scoped BigOperators Matrix
open Polynomial AdjoinRoot

namespace V14Formalization
namespace D12SealProof

open WeilRep D12SealData D12Certificate

instance : Fact (Nat.Prime 11) := ⟨Nat.prime_eleven⟩

/-! ### Coefficient vectors for K = ℚ(ζ₁₁) -/

abbrev KVec := Fin 10 → ℚ

def ofKVec (v : KVec) : K :=
  ∑ i : Fin 10, (algebraMap ℚ K) (v i) * ζ ^ (i.val : ℕ)

def eBasis (i : Fin 10) : KVec := fun j => if j = i then (1 : ℚ) else 0

def basisProd (i j : Fin 10) : KVec :=
  let n := i.val + j.val
  if h : n < 10 then
    eBasis ⟨n, h⟩
  else if n = 10 then
    fun _ => (-1 : ℚ)
  else
    eBasis ⟨n - 11, by
      have hi := Nat.lt_of_succ_le (Nat.succ_le_of_lt i.isLt)
      have hj := Nat.lt_of_succ_le (Nat.succ_le_of_lt j.isLt)
      omega⟩

def kMul (a b : KVec) : KVec :=
  ∑ i : Fin 10, ∑ j : Fin 10, (a i * b j) • basisProd i j

theorem ofKVec_add (a b : KVec) : ofKVec (a + b) = ofKVec a + ofKVec b := by
  simp [ofKVec, Pi.add_apply, map_add, add_mul, Finset.sum_add_distrib]

theorem ofKVec_zero : ofKVec (0 : KVec) = 0 := by simp [ofKVec]

theorem ofKVec_neg (a : KVec) : ofKVec (-a) = -ofKVec a := by
  simp [ofKVec, Pi.neg_apply, map_neg, neg_mul, Finset.sum_neg_distrib]

theorem ofKVec_sub (a b : KVec) : ofKVec (a - b) = ofKVec a - ofKVec b := by
  simp [sub_eq_add_neg, ofKVec_add, ofKVec_neg]

theorem ofKVec_sum {ι : Type*} (s : Finset ι) (f : ι → KVec) :
    ofKVec (∑ i ∈ s, f i) = ∑ i ∈ s, ofKVec (f i) := by
  classical
  induction s using Finset.induction_on with
  | empty => simp [ofKVec_zero]
  | insert x s hx ih =>
    rw [Finset.sum_insert hx, Finset.sum_insert hx, ofKVec_add, ih]

theorem ofKVec_smul (r : ℚ) (a : KVec) :
    ofKVec (r • a) = (algebraMap ℚ K) r * ofKVec a := by
  simp [ofKVec, Pi.smul_apply, smul_eq_mul, map_mul, mul_assoc, Finset.mul_sum]

theorem ofKVec_e (i : Fin 10) : ofKVec (eBasis i) = ζ ^ i.val := by
  unfold ofKVec eBasis
  rw [Finset.sum_eq_single i]
  · simp [map_one]
  · intro b _ hne; simp [hne]
  · intro h; exact (h (Finset.mem_univ i)).elim

theorem ofKVec_basis0 : ofKVec (eBasis 0) = 1 := by
  simpa using ofKVec_e 0

theorem ofKVec_rat (r : ℚ) :
    ofKVec (fun i => if i = 0 then r else 0) = (algebraMap ℚ K) r := by
  unfold ofKVec
  rw [Finset.sum_eq_single (0 : Fin 10)]
  · simp
  · intro b _ hb; simp [hb]
  · intro h; exact (h (Finset.mem_univ 0)).elim

theorem Φ11_eq_geom : Φ11 = ∑ i ∈ Finset.range 11, (X : ℚ[X]) ^ i := by
  simpa [Φ11] using cyclotomic_prime (R := ℚ) 11

theorem sum_ζ_pow : ∑ i ∈ Finset.range 11, ζ ^ i = 0 := by
  have h := aeval_ζ_Φ11
  rw [Φ11_eq_geom] at h
  simpa [map_sum, aeval_X_pow] using h

theorem ζ_pow_ten : ζ ^ (10 : ℕ) = -∑ i ∈ Finset.range 10, ζ ^ i := by
  have h := sum_ζ_pow
  rw [Finset.sum_range_succ] at h
  linear_combination h

theorem ofKVec_all_neg_one :
    ofKVec (fun _ => (-1 : ℚ)) = -∑ i ∈ Finset.range 10, ζ ^ i := by
  simp only [ofKVec, map_neg, map_one, neg_one_mul]
  have h1 : (∑ x : Fin 10, (-ζ ^ x.val : K)) = -∑ x : Fin 10, ζ ^ x.val :=
    Finset.sum_neg_distrib (f := fun x : Fin 10 => (ζ ^ x.val : K))
  rw [h1, Fin.sum_univ_eq_sum_range (fun i => ζ ^ i) 10]

theorem ofKVec_basisProd (i j : Fin 10) :
    ofKVec (basisProd i j) = ζ ^ i.val * ζ ^ j.val := by
  rw [← pow_add]
  set n := i.val + j.val with hn
  change ofKVec (basisProd i j) = ζ ^ n
  unfold basisProd
  simp only [← hn]
  split_ifs with hlt heq
  · simpa using ofKVec_e ⟨n, hlt⟩
  · rw [ofKVec_all_neg_one, ← ζ_pow_ten, heq]
  · have hge : 11 ≤ n := by omega
    rw [ofKVec_e]
    change ζ ^ (n - 11) = ζ ^ n
    have h11 : ζ ^ 11 = 1 := ζ_pow_eleven
    calc ζ ^ (n - 11) = 1 * ζ ^ (n - 11) := (one_mul _).symm
      _ = ζ ^ 11 * ζ ^ (n - 11) := by rw [h11]
      _ = ζ ^ (11 + (n - 11)) := (pow_add _ _ _).symm
      _ = ζ ^ n := by congr 1; omega

theorem eq_sum_basis (a : KVec) :
    a = ∑ i : Fin 10, a i • eBasis i := by
  ext j
  simp only [Finset.sum_apply, Pi.smul_apply, eBasis, smul_eq_mul]
  rw [Finset.sum_eq_single j]
  · simp
  · intro b _ hb; simp [show j ≠ b from hb.symm]
  · intro h; exact (h (Finset.mem_univ j)).elim

theorem ofKVec_mul (a b : KVec) :
    ofKVec a * ofKVec b = ofKVec (kMul a b) := by
  have ha : ofKVec a =
      ∑ i : Fin 10, (algebraMap ℚ K) (a i) * ofKVec (eBasis i) := by
    have := congrArg ofKVec (eq_sum_basis a)
    rw [this, ofKVec_sum]
    refine Finset.sum_congr rfl fun i _ => ofKVec_smul (a i) (eBasis i)
  have hb : ofKVec b =
      ∑ j : Fin 10, (algebraMap ℚ K) (b j) * ofKVec (eBasis j) := by
    have := congrArg ofKVec (eq_sum_basis b)
    rw [this, ofKVec_sum]
    refine Finset.sum_congr rfl fun j _ => ofKVec_smul (b j) (eBasis j)
  rw [ha, hb, Finset.sum_mul]
  simp only [Finset.mul_sum]
  have hreassoc :
      (∑ i : Fin 10, ∑ j : Fin 10,
          ((algebraMap ℚ K) (a i) * ofKVec (eBasis i)) *
            ((algebraMap ℚ K) (b j) * ofKVec (eBasis j))) =
        ∑ i : Fin 10, ∑ j : Fin 10,
          (algebraMap ℚ K) (a i * b j) *
            (ofKVec (eBasis i) * ofKVec (eBasis j)) := by
    refine Finset.sum_congr rfl fun i _ => Finset.sum_congr rfl fun j _ => ?_
    simp only [map_mul]; ring
  rw [hreassoc]
  have hbp : ∀ i j : Fin 10,
      ofKVec (eBasis i) * ofKVec (eBasis j) = ofKVec (basisProd i j) := by
    intro i j; rw [ofKVec_e, ofKVec_e, ofKVec_basisProd]
  simp_rw [hbp]
  have hsm :
      (∑ i : Fin 10, ∑ j : Fin 10,
          (algebraMap ℚ K) (a i * b j) * ofKVec (basisProd i j)) =
        ∑ i : Fin 10, ∑ j : Fin 10,
          ofKVec ((a i * b j) • basisProd i j) := by
    refine Finset.sum_congr rfl fun i _ => Finset.sum_congr rfl fun j _ => ?_
    rw [← ofKVec_smul]
  rw [hsm]
  have hsum :
      (∑ i : Fin 10, ∑ j : Fin 10, ofKVec ((a i * b j) • basisProd i j)) =
        ofKVec (∑ i : Fin 10, ∑ j : Fin 10, (a i * b j) • basisProd i j) := by
    simp_rw [← ofKVec_sum]
  rw [hsum]; rfl

/-! ### Power-basis independence -/

theorem Φ11_ne_zero : Φ11 ≠ 0 := Φ11_irreducible.ne_zero

def pbK : PowerBasis ℚ K := powerBasis Φ11_ne_zero

theorem pbK_dim : pbK.dim = 10 := by
  change Φ11.natDegree = 10
  exact Φ11_natDegree

theorem pbK_gen : pbK.gen = ζ := rfl

theorem ofKVec_eq_basis_sum (v : KVec) :
    ofKVec v =
      ∑ i : Fin 10, v i • pbK.basis ⟨i.val, by have := pbK_dim; omega⟩ := by
  have hpow : ∀ i : Fin 10,
      pbK.basis ⟨i.val, by have := pbK_dim; omega⟩ = ζ ^ i.val := by
    intro i; rw [pbK.basis_eq_pow, pbK_gen]
  simp only [ofKVec, hpow, Algebra.smul_def]

theorem ofKVec_eq_zero_iff (v : KVec) : ofKVec v = 0 ↔ v = 0 := by
  constructor
  · intro hv
    have hsum' : (∑ i : Fin 10,
        v i • pbK.basis ⟨i.val, by have := pbK_dim; omega⟩) = 0 := by
      rw [← ofKVec_eq_basis_sum, hv]
    have hli : LinearIndependent ℚ
        (fun i : Fin 10 => pbK.basis ⟨i.val, by have := pbK_dim; omega⟩) := by
      refine LinearIndependent.comp pbK.basis.linearIndependent
        (fun i : Fin 10 => ⟨i.val, by have := pbK_dim; omega⟩) ?_
      intro a b hab
      exact Fin.ext (Fin.mk.inj_iff.mp hab)
    exact funext (Fintype.linearIndependent_iff.1 hli v hsum')
  · intro h; simp [h, ofKVec]

theorem ofKVec_injective : Function.Injective ofKVec := by
  intro a b h
  have : ofKVec (a - b) = 0 := by rw [ofKVec_sub, h, sub_self]
  exact sub_eq_zero.mp ((ofKVec_eq_zero_iff (a - b)).mp this)

/-! ### Decoders -/

def decodeRatPair (p : Int × Nat) : K := (p.1 : K) / (p.2 : K)

def decodeKCoeff (c : KCoeff10) : K :=
  ∑ i : Fin 10, decodeRatPair (c.getD i.val (0, 1)) * ζ ^ (i.val : ℕ)

def decodeKCoeffVec (c : KCoeff10) : KVec :=
  fun i =>
    let p := c.getD i.val (0, 1)
    (p.1 : ℚ) / (p.2 : ℚ)

theorem decodeKCoeff_eq_ofKVec (c : KCoeff10) :
    decodeKCoeff c = ofKVec (decodeKCoeffVec c) := by
  simp only [decodeKCoeff, decodeKCoeffVec, ofKVec, decodeRatPair]
  refine Finset.sum_congr rfl fun i _ => ?_
  have :
      ((c.getD i.val (0, 1)).1 : K) / ((c.getD i.val (0, 1)).2 : K) =
        algebraMap ℚ K
          (((c.getD i.val (0, 1)).1 : ℚ) / ((c.getD i.val (0, 1)).2 : ℚ)) := by
    simp [map_div₀, map_intCast, map_natCast]
  rw [this]

def decodeFlatEntryVec (flat : Array Int) (idx : Nat) : KVec :=
  fun i =>
    let num := flat.getD (20 * idx + 2 * i.val) 0
    let den := flat.getD (20 * idx + 2 * i.val + 1) 1
    (num : ℚ) / (den : ℚ)

def decodeFlatEntry (flat : Array Int) (idx : Nat) : K :=
  ofKVec (decodeFlatEntryVec flat idx)

def decodeMatrixVec (rows cols : Nat) (flat : Array Int) :
    Matrix (Fin rows) (Fin cols) KVec :=
  Matrix.of fun i j => decodeFlatEntryVec flat (i.val * cols + j.val)

def decodeMatrix (rows cols : Nat) (flat : Array Int) :
    Matrix (Fin rows) (Fin cols) K :=
  (decodeMatrixVec rows cols flat).map ofKVec

def decodeNestedMatrix (rows cols : Nat) (M : Array (Array KCoeff10)) :
    Matrix (Fin rows) (Fin cols) K :=
  Matrix.of fun i j => decodeKCoeff ((M.getD i.val #[]).getD j.val #[])

/-! ### Flat-decoded dense operators -/

def R : Matrix (Fin 15) (Fin 15) K := decodeMatrix 15 15 R15x15_flat
def F : Matrix (Fin 15) (Fin 15) K := decodeMatrix 15 15 F15x15_flat
def RM : Matrix (Fin 10) (Fin 10) K := decodeMatrix 10 10 RM10x10_flat
def SM : Matrix (Fin 10) (Fin 10) K := decodeMatrix 10 10 SM10x10_flat

/-! ### Explicit pure-ℚ sparse B₀, L₀, P₀ -/

def B₀ : Matrix (Fin 15) (Fin 10) K := Matrix.of fun i j =>
  match i.val, j.val with
  | 0, 0 => 1 | 1, 1 => 1 | 2, 2 => 1 | 3, 3 => 1 | 4, 4 => 1
  | 5, 3 => -1/2 | 6, 5 => 1 | 7, 6 => 1 | 8, 1 => 1/2
  | 9, 7 => 1 | 10, 2 => -1/2 | 11, 8 => 1 | 12, 4 => 1/2
  | 13, 0 => -1/2 | 14, 9 => 1
  | _, _ => 0

def L₀ : Matrix (Fin 10) (Fin 15) K := Matrix.of fun i j =>
  match i.val, j.val with
  | 0, 0 => 2/3 | 0, 13 => -2/3
  | 1, 1 => 2/3 | 1, 8 => 2/3
  | 2, 2 => 2/3 | 2, 10 => -2/3
  | 3, 3 => 2/3 | 3, 5 => -2/3
  | 4, 4 => 2/3 | 4, 12 => 2/3
  | 5, 6 => 1 | 6, 7 => 1 | 7, 9 => 1 | 8, 11 => 1 | 9, 14 => 1
  | _, _ => 0

def P₀ : Matrix (Fin 15) (Fin 15) K := Matrix.of fun i j =>
  match i.val, j.val with
  | 0, 0 => 2/3 | 0, 13 => -2/3
  | 1, 1 => 2/3 | 1, 8 => 2/3
  | 2, 2 => 2/3 | 2, 10 => -2/3
  | 3, 3 => 2/3 | 3, 5 => -2/3
  | 4, 4 => 2/3 | 4, 12 => 2/3
  | 5, 3 => -1/3 | 5, 5 => 1/3
  | 6, 6 => 1 | 7, 7 => 1
  | 8, 1 => 1/3 | 8, 8 => 1/3
  | 9, 9 => 1
  | 10, 2 => -1/3 | 10, 10 => 1/3
  | 11, 11 => 1
  | 12, 4 => 1/3 | 12, 12 => 1/3
  | 13, 0 => -1/3 | 13, 13 => 1/3
  | 14, 14 => 1
  | _, _ => 0

theorem L₀_mul_B₀ : L₀ * B₀ = 1 := by
  ext i j
  simp only [Matrix.mul_apply, Matrix.one_apply, L₀, B₀, Matrix.of_apply]
  fin_cases i <;> fin_cases j <;> simp [Fin.sum_univ_succ] <;> norm_num

theorem B₀_mul_L₀ : B₀ * L₀ = P₀ := by
  ext i j
  simp only [Matrix.mul_apply, B₀, L₀, P₀, Matrix.of_apply]
  fin_cases i <;> fin_cases j <;> simp [Fin.sum_univ_succ] <;> norm_num

theorem P₀_mul_P₀ : P₀ * P₀ = P₀ := by
  calc
    P₀ * P₀ = (B₀ * L₀) * (B₀ * L₀) := by rw [B₀_mul_L₀]
    _ = B₀ * (L₀ * B₀) * L₀ := by simp [Matrix.mul_assoc]
    _ = B₀ * (1 : Matrix (Fin 10) (Fin 10) K) * L₀ := by rw [L₀_mul_B₀]
    _ = B₀ * L₀ := by simp
    _ = P₀ := B₀_mul_L₀

theorem projector_factor₀ : B₀ * L₀ * P₀ = P₀ := by
  rw [B₀_mul_L₀, P₀_mul_P₀]

/-! ### Action kernel stacks via Fin.addCases -/

def stackA (rotSign reflSign : K) : Matrix (Fin 20) (Fin 10) K :=
  Matrix.of fun i j =>
    Fin.addCases
      (fun r : Fin 10 => RM r j - if r = j then rotSign else 0)
      (fun s : Fin 10 => SM s j - if s = j then reflSign else 0)
      (i : Fin (10 + 10))

def PP_A : Matrix (Fin 20) (Fin 10) K := stackA 1 1
def PA_A : Matrix (Fin 20) (Fin 10) K := stackA 1 (-1)
def AP_A : Matrix (Fin 20) (Fin 10) K := stackA (-1) 1
def AA_A : Matrix (Fin 20) (Fin 10) K := stackA (-1) (-1)

private theorem sum_delta_mul
    {n : Type*} [Fintype n] [DecidableEq n] (c : K) (m : n → K) (j : n) :
    (∑ k : n, (if j = k then c else 0) * m k) = c * m j := by
  rw [Finset.sum_eq_single j] <;> intros <;> simp_all [eq_comm]

theorem stack_row_rot (rotSign reflSign : K) (m : Fin 10 → K) (j : Fin 10) :
    (stackA rotSign reflSign).mulVec m (Fin.castAdd 10 j) =
      RM.mulVec m j - rotSign * m j := by
  dsimp [stackA, Matrix.mulVec, dotProduct]
  simp only [Fin.addCases_left, sub_mul, Finset.sum_sub_distrib]
  rw [sum_delta_mul]

theorem stack_row_refl (rotSign reflSign : K) (m : Fin 10 → K) (j : Fin 10) :
    (stackA rotSign reflSign).mulVec m (Fin.natAdd 10 j) =
      SM.mulVec m j - reflSign * m j := by
  dsimp [stackA, Matrix.mulVec, dotProduct]
  simp only [Fin.addCases_right, sub_mul, Finset.sum_sub_distrib]
  rw [sum_delta_mul]

theorem castAdd_eq (i : Fin (10 + 10)) (hi : i.val < 10) :
    i = Fin.castAdd 10 ⟨i.val, hi⟩ := by
  ext; rfl

theorem natAdd_eq (i : Fin (10 + 10)) (hi : 10 ≤ i.val) :
    i = Fin.natAdd 10 ⟨i.val - 10, Nat.sub_lt_left_of_lt_add hi i.isLt⟩ := by
  ext
  change i.val = 10 + (i.val - 10)
  exact (Nat.add_sub_of_le hi).symm

theorem action_kernel_stack (rotSign reflSign : K) (m : Fin 10 → K) :
    (stackA rotSign reflSign).mulVec m = 0 ↔
      RM.mulVec m = rotSign • m ∧ SM.mulVec m = reflSign • m := by
  constructor
  · intro hzero
    constructor
    · funext j
      have hrow := congrFun hzero (Fin.castAdd 10 j)
      rw [stack_row_rot] at hrow
      have : RM.mulVec m j = rotSign * m j := sub_eq_zero.mp hrow
      simpa [Pi.smul_apply, smul_eq_mul] using this
    · funext j
      have hrow := congrFun hzero (Fin.natAdd 10 j)
      rw [stack_row_refl] at hrow
      have : SM.mulVec m j = reflSign * m j := sub_eq_zero.mp hrow
      simpa [Pi.smul_apply, smul_eq_mul] using this
  · intro ⟨hR, hS⟩
    funext i
    by_cases hi : i.val < 10
    · rw [castAdd_eq i hi, stack_row_rot]
      have := congrFun hR ⟨i.val, hi⟩
      simp only [Pi.smul_apply, smul_eq_mul] at this ⊢
      simp [this]
    · have hi' : 10 ≤ i.val := Nat.le_of_not_lt hi
      rw [natAdd_eq i hi', stack_row_refl]
      have := congrFun hS ⟨i.val - 10, Nat.sub_lt_left_of_lt_add hi' i.isLt⟩
      simp only [Pi.smul_apply, smul_eq_mul] at this ⊢
      simp [this]

theorem PP_action_kernel (m : Fin 10 → K) :
    PP_A.mulVec m = 0 ↔
      RM.mulVec m = (1 : K) • m ∧ SM.mulVec m = (1 : K) • m :=
  action_kernel_stack 1 1 m

theorem PA_action_kernel (m : Fin 10 → K) :
    PA_A.mulVec m = 0 ↔
      RM.mulVec m = (1 : K) • m ∧ SM.mulVec m = (-1 : K) • m :=
  action_kernel_stack 1 (-1) m

theorem AP_action_kernel (m : Fin 10 → K) :
    AP_A.mulVec m = 0 ↔
      RM.mulVec m = (-1 : K) • m ∧ SM.mulVec m = (1 : K) • m :=
  action_kernel_stack (-1) 1 m

theorem AA_action_kernel (m : Fin 10 → K) :
    AA_A.mulVec m = 0 ↔
      RM.mulVec m = (-1 : K) • m ∧ SM.mulVec m = (-1 : K) • m :=
  action_kernel_stack (-1) (-1) m

/-! ### Nested piece data; raw vs normalized Plücker C -/

def PP_K : Matrix (Fin 10) (Fin 2) K := decodeNestedMatrix 10 2 piecePP_K10xd
def PP_Y : Matrix (Fin 2) (Fin 10) K := decodeNestedMatrix 2 10 piecePP_Ydx10
def AP_K : Matrix (Fin 10) (Fin 1) K := decodeNestedMatrix 10 1 pieceAP_K10xd
def AP_Y : Matrix (Fin 1) (Fin 10) K := decodeNestedMatrix 1 10 pieceAP_Ydx10
def AA_K : Matrix (Fin 10) (Fin 1) K := decodeNestedMatrix 10 1 pieceAA_K10xd
def AA_Y : Matrix (Fin 1) (Fin 10) K := decodeNestedMatrix 1 10 pieceAA_Ydx10
def PA_K : Matrix (Fin 10) (Fin 0) K := Matrix.of fun _ _ => 0
def PA_Y : Matrix (Fin 0) (Fin 10) K := Matrix.of fun _ _ => 0

def PP_X : Matrix (Fin 10) (Fin 20) K := decodeMatrix 10 20 piecePP_X10x20_flat
def PA_X : Matrix (Fin 10) (Fin 20) K := decodeMatrix 10 20 piecePA_X10x20_flat
def AP_X : Matrix (Fin 10) (Fin 20) K := decodeMatrix 10 20 pieceAP_X10x20_flat
def AA_X : Matrix (Fin 10) (Fin 20) K := decodeMatrix 10 20 pieceAA_X10x20_flat

def deltaPP_K : K := decodeKCoeff deltaPP
def deltaAP_K : K := decodeKCoeff deltaAP
def deltaAA_K : K := decodeKCoeff deltaAA

/-- Raw exported C (wedge form = 2 · normalized pluckerValue coefficients). -/
def PP_C_raw : Matrix (Fin 3) (Fin 3) K :=
  decodeNestedMatrix 3 3 piecePP_coeffMatrix
def AP_C_raw : Matrix (Fin 1) (Fin 1) K :=
  decodeNestedMatrix 1 1 pieceAP_coeffMatrix
def AA_C_raw : Matrix (Fin 1) (Fin 1) K :=
  decodeNestedMatrix 1 1 pieceAA_coeffMatrix

/-- Normalized C for `D12Certificate.pluckerValue` (raw / 2). -/
def PP_C : Matrix (Fin 3) (Fin 3) K := (1 / 2 : K) • PP_C_raw
def AP_C : Matrix (Fin 1) (Fin 1) K := (1 / 2 : K) • AP_C_raw
def AA_C : Matrix (Fin 1) (Fin 1) K := (1 / 2 : K) • AA_C_raw

theorem deltaPP_K_ne_zero : deltaPP_K ≠ 0 := by
  intro h
  have hv : decodeKCoeffVec deltaPP = 0 :=
    (ofKVec_eq_zero_iff _).mp (by simpa [deltaPP_K, decodeKCoeff_eq_ofKVec] using h)
  have h0 : ((8 : ℚ) / 1) = 0 := by
    simpa [decodeKCoeffVec, deltaPP] using congrFun hv (0 : Fin 10)
  norm_num at h0

theorem deltaAP_K_ne_zero : deltaAP_K ≠ 0 := by
  intro h
  have hv : decodeKCoeffVec deltaAP = 0 :=
    (ofKVec_eq_zero_iff _).mp (by simpa [deltaAP_K, decodeKCoeff_eq_ofKVec] using h)
  have h0 : ((2 : ℚ) / 1) = 0 := by
    simpa [decodeKCoeffVec, deltaAP] using congrFun hv (1 : Fin 10)
  norm_num at h0

theorem deltaAA_K_ne_zero : deltaAA_K ≠ 0 := by
  intro h
  have hv : decodeKCoeffVec deltaAA = 0 :=
    (ofKVec_eq_zero_iff _).mp (by simpa [deltaAA_K, decodeKCoeff_eq_ofKVec] using h)
  have h0 : ((-2 : ℚ) / 1) = 0 := by
    simpa [decodeKCoeffVec, deltaAA] using congrFun hv (0 : Fin 10)
  norm_num at h0

theorem two_ne_zero_K : (2 : K) ≠ 0 := by
  exact_mod_cast (by norm_num : (2 : ℚ) ≠ 0)

theorem eight_ne_zero_K : (8 : K) ≠ 0 := by
  exact_mod_cast (by norm_num : (8 : ℚ) ≠ 0)

theorem det_smul_three (c : K) (M : Matrix (Fin 3) (Fin 3) K) :
    ((c • M).det) = c ^ 3 * M.det := by
  simpa using Matrix.det_smul (n := Fin 3) (R := K) M c

theorem det_PP_C_of_raw (h : PP_C_raw.det = deltaPP_K) :
    PP_C.det = deltaPP_K / 8 := by
  have : PP_C.det = (1 / 2 : K) ^ 3 * PP_C_raw.det := by
    simpa [PP_C] using det_smul_three (1 / 2 : K) PP_C_raw
  rw [this, h]
  field_simp
  ring

/-! ### Base change along injective algebraMap K → Ω -/

/-- Entrywise base change of a matrix along `algebraMap K Ω`. -/
def mapMatrix (Ω : Type*) [Field Ω] [Algebra K Ω] {m n : Type*}
    (A : Matrix m n K) : Matrix m n Ω :=
  A.map (algebraMap K Ω)

theorem mapMatrix_mul (Ω : Type*) [Field Ω] [Algebra K Ω] {m n p : Type*}
    [Fintype n]
    (A : Matrix m n K) (B : Matrix n p K) :
    mapMatrix Ω (A * B) = mapMatrix Ω A * mapMatrix Ω B := by
  ext i j
  simp [mapMatrix, Matrix.mul_apply, map_sum, map_mul]

theorem mapMatrix_one (Ω : Type*) [Field Ω] [Algebra K Ω] {n : Type*}
    [Fintype n] [DecidableEq n] :
    mapMatrix Ω (1 : Matrix n n K) = 1 := by
  ext i j
  simp [mapMatrix, Matrix.one_apply, apply_ite (algebraMap K Ω), map_zero, map_one]

theorem mapMatrix_add (Ω : Type*) [Field Ω] [Algebra K Ω] {m n : Type*}
    (A B : Matrix m n K) :
    mapMatrix Ω (A + B) = mapMatrix Ω A + mapMatrix Ω B := by
  ext; simp [mapMatrix, map_add]

theorem mapMatrix_smul (Ω : Type*) [Field Ω] [Algebra K Ω] {m n : Type*}
    (c : K) (A : Matrix m n K) :
    mapMatrix Ω (c • A) = algebraMap K Ω c • mapMatrix Ω A := by
  ext; simp [mapMatrix, map_mul, Algebra.smul_def]

theorem mapMatrix_mulVec (Ω : Type*) [Field Ω] [Algebra K Ω] {m n : Type*}
    [Fintype n] (A : Matrix m n K) (v : n → K) :
    (mapMatrix Ω A).mulVec (fun i => algebraMap K Ω (v i)) =
      fun i => algebraMap K Ω (A.mulVec v i) := by
  ext i
  simp [mapMatrix, Matrix.mulVec, dotProduct, map_sum, map_mul]

theorem algebraMap_injective_iff_ker (Ω : Type*) [Field Ω] [Algebra K Ω]
    (hinj : Function.Injective (algebraMap K Ω)) {x : K} :
    algebraMap K Ω x = 0 ↔ x = 0 :=
  ⟨fun h => hinj (by simpa using h), fun h => by simp [h]⟩

theorem algebraMap_ne_zero_of_injective (Ω : Type*) [Field Ω] [Algebra K Ω]
    (hinj : Function.Injective (algebraMap K Ω)) {x : K} (hx : x ≠ 0) :
    algebraMap K Ω x ≠ 0 := by
  intro h
  exact hx ((algebraMap_injective_iff_ker Ω hinj).mp h)

theorem mapMatrix_det (Ω : Type*) [Field Ω] [Algebra K Ω] {n : Type*}
    [Fintype n] [DecidableEq n] (A : Matrix n n K) :
    (mapMatrix Ω A).det = algebraMap K Ω A.det := by
  simpa [mapMatrix] using (RingHom.map_det (algebraMap K Ω) A)

theorem L₀_mul_B₀_base (Ω : Type*) [Field Ω] [Algebra K Ω] :
    mapMatrix Ω L₀ * mapMatrix Ω B₀ = (1 : Matrix (Fin 10) (Fin 10) Ω) := by
  rw [← mapMatrix_mul, L₀_mul_B₀, mapMatrix_one]

theorem B₀_mul_L₀_base (Ω : Type*) [Field Ω] [Algebra K Ω] :
    mapMatrix Ω B₀ * mapMatrix Ω L₀ = mapMatrix Ω P₀ := by
  rw [← mapMatrix_mul, B₀_mul_L₀]

theorem projector_factor₀_base (Ω : Type*) [Field Ω] [Algebra K Ω] :
    mapMatrix Ω B₀ * mapMatrix Ω L₀ * mapMatrix Ω P₀ = mapMatrix Ω P₀ := by
  rw [B₀_mul_L₀_base, ← mapMatrix_mul, P₀_mul_P₀]

/-- Generic stack over an arbitrary field, for re-proving action-kernel after
transport of the finite matrices `RM`, `SM`. -/
def stackAΩ {Ω : Type*} [Field Ω]
    (RMΩ SMΩ : Matrix (Fin 10) (Fin 10) Ω) (rotSign reflSign : Ω) :
    Matrix (Fin 20) (Fin 10) Ω :=
  Matrix.of fun i j =>
    Fin.addCases
      (fun r : Fin 10 => RMΩ r j - if r = j then rotSign else 0)
      (fun s : Fin 10 => SMΩ s j - if s = j then reflSign else 0)
      (i : Fin (10 + 10))

private theorem sum_delta_mulΩ {Ω : Type*} [Field Ω]
    {n : Type*} [Fintype n] [DecidableEq n] (c : Ω) (m : n → Ω) (j : n) :
    (∑ k : n, (if j = k then c else 0) * m k) = c * m j := by
  rw [Finset.sum_eq_single j] <;> intros <;> simp_all [eq_comm]

theorem stack_row_rotΩ {Ω : Type*} [Field Ω]
    (RMΩ SMΩ : Matrix (Fin 10) (Fin 10) Ω) (rotSign reflSign : Ω)
    (m : Fin 10 → Ω) (j : Fin 10) :
    (stackAΩ RMΩ SMΩ rotSign reflSign).mulVec m (Fin.castAdd 10 j) =
      RMΩ.mulVec m j - rotSign * m j := by
  dsimp [stackAΩ, Matrix.mulVec, dotProduct]
  simp only [Fin.addCases_left, sub_mul, Finset.sum_sub_distrib]
  rw [sum_delta_mulΩ]

theorem stack_row_reflΩ {Ω : Type*} [Field Ω]
    (RMΩ SMΩ : Matrix (Fin 10) (Fin 10) Ω) (rotSign reflSign : Ω)
    (m : Fin 10 → Ω) (j : Fin 10) :
    (stackAΩ RMΩ SMΩ rotSign reflSign).mulVec m (Fin.natAdd 10 j) =
      SMΩ.mulVec m j - reflSign * m j := by
  dsimp [stackAΩ, Matrix.mulVec, dotProduct]
  simp only [Fin.addCases_right, sub_mul, Finset.sum_sub_distrib]
  rw [sum_delta_mulΩ]

theorem action_kernel_stackΩ {Ω : Type*} [Field Ω]
    (RMΩ SMΩ : Matrix (Fin 10) (Fin 10) Ω) (rotSign reflSign : Ω)
    (m : Fin 10 → Ω) :
    (stackAΩ RMΩ SMΩ rotSign reflSign).mulVec m = 0 ↔
      RMΩ.mulVec m = rotSign • m ∧ SMΩ.mulVec m = reflSign • m := by
  constructor
  · intro hzero
    constructor
    · funext j
      have hrow := congrFun hzero (Fin.castAdd 10 j)
      rw [stack_row_rotΩ] at hrow
      have : RMΩ.mulVec m j = rotSign * m j := sub_eq_zero.mp hrow
      simpa [Pi.smul_apply, smul_eq_mul] using this
    · funext j
      have hrow := congrFun hzero (Fin.natAdd 10 j)
      rw [stack_row_reflΩ] at hrow
      have : SMΩ.mulVec m j = reflSign * m j := sub_eq_zero.mp hrow
      simpa [Pi.smul_apply, smul_eq_mul] using this
  · intro ⟨hR, hS⟩
    funext i
    by_cases hi : i.val < 10
    · rw [castAdd_eq i hi, stack_row_rotΩ]
      have := congrFun hR ⟨i.val, hi⟩
      simp only [Pi.smul_apply, smul_eq_mul] at this ⊢
      simp [this]
    · have hi' : 10 ≤ i.val := Nat.le_of_not_lt hi
      rw [natAdd_eq i hi', stack_row_reflΩ]
      have := congrFun hS ⟨i.val - 10, Nat.sub_lt_left_of_lt_add hi' i.isLt⟩
      simp only [Pi.smul_apply, smul_eq_mul] at this ⊢
      simp [this]

theorem mapMatrix_stackA (Ω : Type*) [Field Ω] [Algebra K Ω]
    (rotSign reflSign : K) :
    mapMatrix Ω (stackA rotSign reflSign) =
      stackAΩ (mapMatrix Ω RM) (mapMatrix Ω SM)
        (algebraMap K Ω rotSign) (algebraMap K Ω reflSign) := by
  ext i j
  simp only [mapMatrix, stackA, stackAΩ, Matrix.map_apply, Matrix.of_apply]
  refine Fin.addCases (motive := fun i : Fin (10 + 10) =>
      algebraMap K Ω
          (Fin.addCases
            (fun r => RM r j - if r = j then rotSign else 0)
            (fun s => SM s j - if s = j then reflSign else 0) i) =
        Fin.addCases
          (fun r => algebraMap K Ω (RM r j) -
            if r = j then algebraMap K Ω rotSign else 0)
          (fun s => algebraMap K Ω (SM s j) -
            if s = j then algebraMap K Ω reflSign else 0) i) ?_ ?_ i
  · intro r
    simp [Fin.addCases_left, map_sub, apply_ite (algebraMap K Ω), map_zero]
  · intro s
    simp [Fin.addCases_right, map_sub, apply_ite (algebraMap K Ω), map_zero]

/-! ### Exact missing theorem for a full seal -/

/-- **Missing package for `certificateK`.**

Required over `WeilRep.K`:

1. Restriction: `R * B₀ = B₀ * RM` and `F * B₀ = B₀ * SM`.
2. Piece splits:
   * `PP_X * PP_A + PP_K * PP_Y = 1`
   * `PA_X * PA_A = 1`
   * `AP_X * AP_A + AP_K * AP_Y = 1`
   * `AA_X * AA_A + AA_K * AA_Y = 1`
3. Plücker coefficient identities with **normalized** (halved) `C`:
   * `∀ t, PP_C.mulVec (squareMonomials t) =
        ![pluckerValue ((B₀ * PP_K).mulVec t) 1,
          pluckerValue ((B₀ * PP_K).mulVec t) 2,
          pluckerValue ((B₀ * PP_K).mulVec t) 9]`
   * `∀ t, pluckerValue ((B₀ * AP_K).mulVec t) 0 =
        (deltaAP_K / 2) * (t 0 * t 0)`
   * `∀ t, pluckerValue ((B₀ * AA_K).mulVec t) 0 =
        (deltaAA_K / 2) * (t 0 * t 0)`
4. Determinant seals: `PP_C_raw.det = deltaPP_K` (hence
   `PP_C.det = deltaPP_K / 8`), and `AP_C_raw 0 0 = deltaAP_K`,
   `AA_C_raw 0 0 = deltaAA_K`.

On any field `Ω` with injective `algebraMap K Ω`, map the finite matrix and
coefficient identities, then re-prove action-kernel via `action_kernel_stackΩ`
and Plücker emptiness via the abstract `plucker_empty_fin{0,1,2}_of_coeff`
lemmas, preserving nonzero determinants by injectivity of `algebraMap`.
-/
def missing_for_certificateK : Prop :=
  R * B₀ = B₀ * RM ∧
  F * B₀ = B₀ * SM ∧
  PP_X * PP_A + PP_K * PP_Y = 1 ∧
  PA_X * PA_A = 1 ∧
  AP_X * AP_A + AP_K * AP_Y = 1 ∧
  AA_X * AA_A + AA_K * AA_Y = 1 ∧
  PP_C_raw.det = deltaPP_K ∧
  AP_C_raw 0 0 = deltaAP_K ∧
  AA_C_raw 0 0 = deltaAA_K ∧
  (∀ t : Fin 2 → K,
      PP_C.mulVec (squareMonomials t) =
        ![pluckerValue ((B₀ * PP_K).mulVec t) 1,
          pluckerValue ((B₀ * PP_K).mulVec t) 2,
          pluckerValue ((B₀ * PP_K).mulVec t) 9]) ∧
  (∀ t : Fin 1 → K,
      pluckerValue ((B₀ * AP_K).mulVec t) 0 =
        (deltaAP_K / 2) * (t 0 * t 0)) ∧
  (∀ t : Fin 1 → K,
      pluckerValue ((B₀ * AA_K).mulVec t) 0 =
        (deltaAA_K / 2) * (t 0 * t 0))

end D12SealProof
end V14Formalization
