/-
Copyright (c) 2026 V14Formalization contributors.
Released under Apache 2.0 license.
-/
module

public import V14Formalization.WeilRep
public import Mathlib.Algebra.BigOperators.Fin

/-!
# A bounded rational-vector model of `Q(zeta_11)`

The generated D12 character-piece certificates are checked in the power basis
`1,zeta,...,zeta^9`.  Multiplication reduces a basis product with only the two
relations `zeta^10 = -(1+...+zeta^9)` and `zeta^11 = 1`.
-/

noncomputable section

open Polynomial
open scoped BigOperators

namespace V14Formalization.D12CyclotomicVec

public abbrev Vec := Fin 10 → ℚ

@[expose] public def basis (i : Fin 10) : Vec := fun j => if j = i then 1 else 0

def basisMul (i j : Fin 10) : Vec :=
  let n := i.val + j.val
  if h : n < 10 then basis ⟨n, h⟩
  else if n = 10 then fun _ => -1
  else basis ⟨n - 11, by omega⟩

@[expose] public def coeffAt (a : Vec) (n : ℕ) : ℚ := if h : n < 10 then a ⟨n, h⟩ else 0

@[simp] public theorem coeffAt_zero (n : ℕ) : coeffAt 0 n = 0 := by
  unfold coeffAt
  split <;> rfl

/-- Coefficient of degree `n` in the ordinary product before cyclotomic
reduction.  This is a single ten-term convolution, rather than a nested
hundred-term sum. -/
@[expose] public def conv (a b : Vec) (n : ℕ) : ℚ :=
  ∑ i : Fin 10, if hi : i.val ≤ n then a i * coeffAt b (n - i.val) else 0

/-- Multiplication reduced by `zeta^10 = -(1+...+zeta^9)` and
`zeta^11 = 1`.  Since an unreduced product has degree at most 18, the three
displayed convolution coefficients are exhaustive. -/
@[expose] public def mul (a b : Vec) : Vec := fun k =>
  conv a b k.val + conv a b (k.val + 11) - conv a b 10

@[simp] public theorem mul_zero_left (b : Vec) : mul 0 b = 0 := by
  funext k
  simp [mul, conv]

@[simp] public theorem mul_zero_right (a : Vec) : mul a 0 = 0 := by
  funext k
  simp [mul, conv]

@[expose] public def eval (v : Vec) : WeilRep.K :=
  ∑ i : Fin 10, algebraMap ℚ WeilRep.K (v i) * WeilRep.ζ ^ i.val

@[simp] public theorem eval_zero : eval 0 = 0 := by
  simp [eval]

public theorem eval_add (a b : Vec) : eval (a + b) = eval a + eval b := by
  simp [eval, Pi.add_apply, map_add, add_mul, Finset.sum_add_distrib]

public theorem eval_smul (r : ℚ) (a : Vec) :
    eval (r • a) = algebraMap ℚ WeilRep.K r * eval a := by
  simp [eval, Pi.smul_apply, smul_eq_mul, map_mul, mul_assoc, Finset.mul_sum]

theorem eval_neg (a : Vec) : eval (-a) = -eval a := by
  simpa only [neg_one_smul, map_neg, map_one, neg_one_mul] using
    eval_smul (-1 : ℚ) a

public theorem eval_sub (a b : Vec) : eval (a - b) = eval a - eval b := by
  rw [sub_eq_add_neg, eval_add, eval_neg, sub_eq_add_neg]

theorem eval_sum {ι : Type*} (s : Finset ι) (f : ι → Vec) :
    eval (∑ i ∈ s, f i) = ∑ i ∈ s, eval (f i) := by
  classical
  induction s using Finset.induction_on with
  | empty => simp
  | insert x s hx => simp [hx, eval_add, *]

theorem eval_basis (i : Fin 10) : eval (basis i) = WeilRep.ζ ^ i.val := by
  unfold eval basis
  rw [Finset.sum_eq_single i]
  · simp
  · intro b _ hne
    simp [hne]
  · intro h
    exact (h (Finset.mem_univ i)).elim

private theorem Phi11_eq_geom :
    WeilRep.Φ11 = ∑ i ∈ Finset.range 11, (X : ℚ[X]) ^ i := by
  simpa [WeilRep.Φ11] using cyclotomic_prime (R := ℚ) 11

private theorem zeta_pow_ten :
    (WeilRep.ζ : WeilRep.K) ^ (10 : ℕ) = -∑ i ∈ Finset.range 10, WeilRep.ζ ^ i := by
  have h := WeilRep.aeval_ζ_Φ11
  rw [Phi11_eq_geom] at h
  simp only [map_sum, map_pow, aeval_X] at h
  rw [Finset.sum_range_succ] at h
  linear_combination h

private theorem eval_all_neg_one :
    eval (fun _ => (-1 : ℚ)) =
      -∑ i ∈ Finset.range 10, WeilRep.ζ ^ i := by
  simp only [eval, map_neg, map_one, neg_one_mul]
  have h : (∑ x : Fin 10, (-WeilRep.ζ ^ x.val : WeilRep.K)) =
      -∑ x : Fin 10, WeilRep.ζ ^ x.val := by
    simpa only [Finset.sum_neg_distrib] using
      (Finset.sum_neg_distrib (s := (Finset.univ : Finset (Fin 10)))
        (f := fun x : Fin 10 => WeilRep.ζ ^ x.val))
  rw [h, Fin.sum_univ_eq_sum_range (fun i => WeilRep.ζ ^ i) 10]

theorem eval_basisMul (i j : Fin 10) :
    eval (basisMul i j) = WeilRep.ζ ^ i.val * WeilRep.ζ ^ j.val := by
  rw [← pow_add]
  set n := i.val + j.val with hn
  change eval (basisMul i j) = WeilRep.ζ ^ n
  unfold basisMul
  simp only [← hn]
  split_ifs with hlt heq
  · simpa using eval_basis ⟨n, hlt⟩
  · rw [eval_all_neg_one, ← zeta_pow_ten, heq]
  · have hge : 11 ≤ n := by omega
    rw [eval_basis]
    calc
      (WeilRep.ζ : WeilRep.K) ^ (n - 11) =
          1 * WeilRep.ζ ^ (n - 11) := (one_mul _).symm
      _ = WeilRep.ζ ^ 11 * WeilRep.ζ ^ (n - 11) := by
        rw [WeilRep.ζ_pow_eleven]
      _ = WeilRep.ζ ^ (11 + (n - 11)) :=
        (pow_add _ _ _).symm
      _ = WeilRep.ζ ^ n := by congr 1 <;> omega

theorem conv_basis (i j : Fin 10) (n : ℕ) :
    conv (basis i) (basis j) n = if n = i.val + j.val then 1 else 0 := by
  unfold conv
  rw [Finset.sum_eq_single i]
  · simp only [basis, if_pos]
    by_cases hi : i.val ≤ n
    · rw [dif_pos hi]
      unfold coeffAt
      by_cases hj : n - i.val < 10
      · rw [dif_pos hj]
        simp only [if_pos, one_mul]
        by_cases h : n = i.val + j.val
        · subst n
          simp [basis]
        · have hne : (⟨n - i.val, hj⟩ : Fin 10) ≠ j := by
            intro heq
            apply h
            have := Fin.mk.inj_iff.mp heq
            omega
          simp [basis, hne, h]
      · rw [dif_neg hj]
        simp only [mul_zero]
        have h : n ≠ i.val + j.val := by intro h; omega
        simp [h]
    · rw [dif_neg hi]
      have h : n ≠ i.val + j.val := by intro h; omega
      simp [h]
  · intro a _ hai
    simp [basis, show a ≠ i from hai]
  · intro h
    exact (h (Finset.mem_univ i)).elim

theorem mul_basis (i j : Fin 10) : mul (basis i) (basis j) = basisMul i j := by
  funext k
  rw [mul, conv_basis, conv_basis, conv_basis]
  set n := i.val + j.val with hn
  change
    (if k.val = n then 1 else 0) +
        (if k.val + 11 = n then 1 else 0) -
          (if 10 = n then 1 else 0) = basisMul i j k
  unfold basisMul
  simp only [← hn]
  by_cases hlt : n < 10
  · rw [dif_pos hlt]
    have h11 : k.val + 11 ≠ n := by omega
    have h10 : 10 ≠ n := by omega
    rw [if_neg h11, if_neg h10]
    by_cases hk : k.val = n
    · rw [if_pos hk]
      have hkfin : k = ⟨n, hlt⟩ := Fin.ext hk
      rw [hkfin]
      simp [basis]
    · rw [if_neg hk]
      have hkfin : k ≠ ⟨n, hlt⟩ := by
        intro heq
        apply hk
        exact Fin.mk.inj_iff.mp heq
      simp [basis, hkfin]
  · by_cases hten : n = 10
    · rw [dif_neg hlt, if_pos hten]
      have hk : k.val ≠ n := by omega
      have hk11 : k.val + 11 ≠ n := by omega
      have h10 : 10 = n := hten.symm
      rw [if_neg hk, if_neg hk11, if_pos h10]
      simp
    · rw [dif_neg hlt, if_neg hten]
      have hn11 : 11 ≤ n := by omega
      have hn19 : n < 19 := by
        subst n
        omega
      have hk0 : k.val ≠ n := by omega
      have h10 : 10 ≠ n := by omega
      rw [if_neg hk0, if_neg h10]
      by_cases hk : k.val + 11 = n
      · rw [if_pos hk]
        have hkval : k.val = n - 11 := by omega
        have hkfin : k = ⟨n - 11, by omega⟩ := Fin.ext hkval
        rw [hkfin]
        simp [basis]
      · rw [if_neg hk]
        have hkfin : k ≠ ⟨n - 11, by omega⟩ := by
          intro heq
          apply hk
          have := Fin.mk.inj_iff.mp heq
          omega
        simp [basis, hkfin]

theorem coeffAt_add (a b : Vec) (n : ℕ) :
    coeffAt (a + b) n = coeffAt a n + coeffAt b n := by
  unfold coeffAt
  split <;> simp

theorem coeffAt_smul (r : ℚ) (a : Vec) (n : ℕ) :
    coeffAt (r • a) n = r * coeffAt a n := by
  unfold coeffAt
  split <;> simp [smul_eq_mul]

theorem conv_add_left (a b c : Vec) (n : ℕ) :
    conv (a + b) c n = conv a c n + conv b c n := by
  unfold conv
  rw [← Finset.sum_add_distrib]
  apply Finset.sum_congr rfl
  intro i _
  by_cases hi : i.val ≤ n
  · simp [hi, add_mul]
  · simp [hi]

theorem conv_add_right (a b c : Vec) (n : ℕ) :
    conv a (b + c) n = conv a b n + conv a c n := by
  unfold conv
  rw [← Finset.sum_add_distrib]
  apply Finset.sum_congr rfl
  intro i _
  by_cases hi : i.val ≤ n
  · simp [hi, coeffAt_add, mul_add]
  · simp [hi]

theorem conv_smul_left (r : ℚ) (a b : Vec) (n : ℕ) :
    conv (r • a) b n = r * conv a b n := by
  unfold conv
  rw [Finset.mul_sum]
  apply Finset.sum_congr rfl
  intro i _
  by_cases hi : i.val ≤ n
  · simp [hi, smul_eq_mul]
    ring
  · simp [hi]

theorem conv_smul_right (r : ℚ) (a b : Vec) (n : ℕ) :
    conv a (r • b) n = r * conv a b n := by
  unfold conv
  rw [Finset.mul_sum]
  apply Finset.sum_congr rfl
  intro i _
  by_cases hi : i.val ≤ n
  · simp [hi, coeffAt_smul]
    ring
  · simp [hi]

theorem mul_add_left (a b c : Vec) : mul (a + b) c = mul a c + mul b c := by
  funext k
  simp only [mul, Pi.add_apply, conv_add_left]
  ring

theorem mul_add_right (a b c : Vec) : mul a (b + c) = mul a b + mul a c := by
  funext k
  simp only [mul, Pi.add_apply, conv_add_right]
  ring

public theorem mul_smul_left (r : ℚ) (a b : Vec) : mul (r • a) b = r • mul a b := by
  funext k
  simp only [mul, Pi.smul_apply, smul_eq_mul, conv_smul_left]
  ring

public theorem mul_smul_right (r : ℚ) (a b : Vec) : mul a (r • b) = r • mul a b := by
  funext k
  simp only [mul, Pi.smul_apply, smul_eq_mul, conv_smul_right]
  ring

theorem eq_sum_basis (a : Vec) : a = ∑ i : Fin 10, a i • basis i := by
  funext j
  simp only [Finset.sum_apply, Pi.smul_apply, basis, smul_eq_mul]
  rw [Finset.sum_eq_single j]
  · simp
  · intro i _ hi
    simp [show j ≠ i from hi.symm]
  · intro h
    exact (h (Finset.mem_univ j)).elim

theorem mul_sum_left {ι : Type*} (s : Finset ι) (f : ι → Vec) (b : Vec) :
    mul (∑ i ∈ s, f i) b = ∑ i ∈ s, mul (f i) b := by
  classical
  induction s using Finset.induction_on with
  | empty =>
      funext k
      simp [mul, conv]
  | insert i s hi => simp [hi, mul_add_left, *]

theorem mul_sum_right {ι : Type*} (a : Vec) (s : Finset ι) (f : ι → Vec) :
    mul a (∑ i ∈ s, f i) = ∑ i ∈ s, mul a (f i) := by
  classical
  induction s using Finset.induction_on with
  | empty =>
      funext k
      simp [mul, conv]
  | insert i s hi => simp [hi, mul_add_right, *]

public theorem eval_mul (a b : Vec) : eval (mul a b) = eval a * eval b := by
  have hmul : mul a b = ∑ i : Fin 10, ∑ j : Fin 10,
      (a i * b j) • basisMul i j := by
    calc
      mul a b = mul (∑ i : Fin 10, a i • basis i)
          (∑ j : Fin 10, b j • basis j) := by
            rw [← eq_sum_basis a, ← eq_sum_basis b]
      _ = ∑ i : Fin 10, mul (a i • basis i)
          (∑ j : Fin 10, b j • basis j) := by
            simpa using mul_sum_left Finset.univ
              (fun i : Fin 10 => a i • basis i)
              (∑ j : Fin 10, b j • basis j)
      _ = ∑ i : Fin 10, ∑ j : Fin 10,
          mul (a i • basis i) (b j • basis j) := by
            apply Finset.sum_congr rfl
            intro i _
            simpa using mul_sum_right (a i • basis i) Finset.univ
              (fun j : Fin 10 => b j • basis j)
      _ = ∑ i : Fin 10, ∑ j : Fin 10,
          (a i * b j) • basisMul i j := by
            apply Finset.sum_congr rfl
            intro i _
            apply Finset.sum_congr rfl
            intro j _
            rw [mul_smul_left, mul_smul_right, mul_basis, smul_smul]
  rw [hmul, eval_sum]
  simp_rw [eval_sum, eval_smul, eval_basisMul]
  unfold eval
  rw [Finset.sum_mul]
  apply Finset.sum_congr rfl
  intro i _
  rw [Finset.mul_sum]
  apply Finset.sum_congr rfl
  intro j _
  simp only [map_mul]
  ring

def powerBasis : PowerBasis ℚ WeilRep.K :=
  AdjoinRoot.powerBasis WeilRep.Φ11_irreducible.ne_zero

theorem powerBasis_dim : powerBasis.dim = 10 := WeilRep.Φ11_natDegree

theorem eval_eq_basis_sum (v : Vec) :
    eval v = ∑ i : Fin 10,
      v i • powerBasis.basis ⟨i.val, by rw [powerBasis_dim]; exact i.isLt⟩ := by
  have hpow (i : Fin 10) :
      powerBasis.basis ⟨i.val, by rw [powerBasis_dim]; exact i.isLt⟩ =
        WeilRep.ζ ^ i.val := by
    rw [powerBasis.basis_eq_pow]
    rfl
  simp only [eval, hpow, Algebra.smul_def]

public theorem eval_eq_zero_iff (v : Vec) : eval v = 0 ↔ v = 0 := by
  constructor
  · intro hv
    have hsum : (∑ i : Fin 10,
        v i • powerBasis.basis
          ⟨i.val, by rw [powerBasis_dim]; exact i.isLt⟩) = 0 := by
      rw [← eval_eq_basis_sum, hv]
    have hli : LinearIndependent ℚ
        (fun i : Fin 10 => powerBasis.basis
          ⟨i.val, by rw [powerBasis_dim]; exact i.isLt⟩) := by
      refine LinearIndependent.comp powerBasis.basis.linearIndependent
        (fun i : Fin 10 => ⟨i.val, by rw [powerBasis_dim]; exact i.isLt⟩) ?_
      intro i j h
      exact Fin.ext (Fin.mk.inj_iff.mp h)
    exact funext (Fintype.linearIndependent_iff.mp hli v hsum)
  · rintro rfl
    exact eval_zero

public theorem eval_injective : Function.Injective eval := by
  intro a b h
  have hvec : a - b = 0 := (eval_eq_zero_iff (a - b)).mp (by
    unfold eval
    simp only [Pi.sub_apply, map_sub, sub_mul, Finset.sum_sub_distrib]
    exact sub_eq_zero.mpr h)
  exact sub_eq_zero.mp hvec

/-! ### Bounded matrix arithmetic in the vector model -/

@[expose] public def constVec (r : ℚ) : Vec := r • basis 0

@[simp] public theorem eval_constVec (r : ℚ) :
    eval (constVec r) = algebraMap ℚ WeilRep.K r := by
  rw [constVec, eval_smul, eval_basis]
  simp

@[expose] public def matrixMul {m n p : Type*} [Fintype n]
    (A : Matrix m n Vec) (B : Matrix n p Vec) : Matrix m p Vec :=
  fun i j => ∑ k : n, mul (A i k) (B k j)

/-- The entry equation for `matrixMul`, published so that the split
certificates can `rw` with it instead of saying
`change (∑ k, mul (XVec i k) (AVec k j)) + … = _`.  A `change` forces the
exported context to reduce the whole goal, which is both a wider exposure
requirement than the certificate needs and the same reduction repeated once
per certificate. -/
public theorem matrixMul_apply {m n p : Type*} [Fintype n]
    (A : Matrix m n Vec) (B : Matrix n p Vec) (i : m) (j : p) :
    matrixMul A B i j = ∑ k : n, mul (A i k) (B k j) := by
  rfl

@[expose] public def evalMatrix {m n : Type*} (A : Matrix m n Vec) :
    Matrix m n WeilRep.K := fun i j => eval (A i j)

@[expose] public def matrixOne (n : Type*) [DecidableEq n] : Matrix n n Vec :=
  fun i j => if i = j then constVec 1 else 0

public theorem evalMatrix_add {m n : Type*} (A B : Matrix m n Vec) :
    evalMatrix (A + B) = evalMatrix A + evalMatrix B := by
  ext i j
  exact eval_add (A i j) (B i j)

public theorem evalMatrix_mul {m n p : Type*} [Fintype n]
    (A : Matrix m n Vec) (B : Matrix n p Vec) :
    evalMatrix (matrixMul A B) = evalMatrix A * evalMatrix B := by
  ext i j
  simp only [evalMatrix, matrixMul, Matrix.mul_apply]
  rw [eval_sum]
  apply Finset.sum_congr rfl
  intro k _
  exact eval_mul (A i k) (B k j)

public theorem evalMatrix_one {n : Type*} [DecidableEq n] :
    evalMatrix (matrixOne n) = (1 : Matrix n n WeilRep.K) := by
  ext i j
  change eval (if i = j then constVec 1 else 0) = if i = j then 1 else 0
  by_cases h : i = j <;> simp [h]

theorem evalMatrix_eq_of_eq {m n : Type*} {A B : Matrix m n Vec}
    (h : A = B) : evalMatrix A = evalMatrix B := congrArg evalMatrix h


/-- Coordinate `k` of a reduced product, written out.  `mul` is three
ten-term convolutions, and every generated Plucker certificate used to make
`norm_num` expand all three (`Fin.sum_univ_succ` ten times over `mul`, `conv`,
`coeffAt`) before it could do any arithmetic -- ~18,000 `Expr` nodes per
coordinate.  Expanding it once per coordinate here leaves the certificates with
nothing but the arithmetic. -/
public theorem mul_apply_0 (a b : Vec) :
    mul a b 0 = a 0 * b 0 +
      (a 2 * b 9 + a 3 * b 8 + a 4 * b 7 + a 5 * b 6 + a 6 * b 5 + a 7 * b 4 + a 8 * b 3 + a 9 * b 2) -
      (a 1 * b 9 + a 2 * b 8 + a 3 * b 7 + a 4 * b 6 + a 5 * b 5 + a 6 * b 4 + a 7 * b 3 + a 8 * b 2 + a 9 * b 1) := by
  simp [mul, conv, coeffAt, Fin.sum_univ_succ]
  try ring

public theorem mul_apply_1 (a b : Vec) :
    mul a b 1 = a 0 * b 1 + a 1 * b 0 +
      (a 3 * b 9 + a 4 * b 8 + a 5 * b 7 + a 6 * b 6 + a 7 * b 5 + a 8 * b 4 + a 9 * b 3) -
      (a 1 * b 9 + a 2 * b 8 + a 3 * b 7 + a 4 * b 6 + a 5 * b 5 + a 6 * b 4 + a 7 * b 3 + a 8 * b 2 + a 9 * b 1) := by
  simp [mul, conv, coeffAt, Fin.sum_univ_succ]
  try ring

public theorem mul_apply_2 (a b : Vec) :
    mul a b 2 = a 0 * b 2 + a 1 * b 1 + a 2 * b 0 +
      (a 4 * b 9 + a 5 * b 8 + a 6 * b 7 + a 7 * b 6 + a 8 * b 5 + a 9 * b 4) -
      (a 1 * b 9 + a 2 * b 8 + a 3 * b 7 + a 4 * b 6 + a 5 * b 5 + a 6 * b 4 + a 7 * b 3 + a 8 * b 2 + a 9 * b 1) := by
  simp [mul, conv, coeffAt, Fin.sum_univ_succ]
  try ring

public theorem mul_apply_3 (a b : Vec) :
    mul a b 3 = a 0 * b 3 + a 1 * b 2 + a 2 * b 1 + a 3 * b 0 +
      (a 5 * b 9 + a 6 * b 8 + a 7 * b 7 + a 8 * b 6 + a 9 * b 5) -
      (a 1 * b 9 + a 2 * b 8 + a 3 * b 7 + a 4 * b 6 + a 5 * b 5 + a 6 * b 4 + a 7 * b 3 + a 8 * b 2 + a 9 * b 1) := by
  simp [mul, conv, coeffAt, Fin.sum_univ_succ]
  try ring

public theorem mul_apply_4 (a b : Vec) :
    mul a b 4 = a 0 * b 4 + a 1 * b 3 + a 2 * b 2 + a 3 * b 1 + a 4 * b 0 +
      (a 6 * b 9 + a 7 * b 8 + a 8 * b 7 + a 9 * b 6) -
      (a 1 * b 9 + a 2 * b 8 + a 3 * b 7 + a 4 * b 6 + a 5 * b 5 + a 6 * b 4 + a 7 * b 3 + a 8 * b 2 + a 9 * b 1) := by
  simp [mul, conv, coeffAt, Fin.sum_univ_succ]
  try ring

public theorem mul_apply_5 (a b : Vec) :
    mul a b 5 = a 0 * b 5 + a 1 * b 4 + a 2 * b 3 + a 3 * b 2 + a 4 * b 1 + a 5 * b 0 +
      (a 7 * b 9 + a 8 * b 8 + a 9 * b 7) -
      (a 1 * b 9 + a 2 * b 8 + a 3 * b 7 + a 4 * b 6 + a 5 * b 5 + a 6 * b 4 + a 7 * b 3 + a 8 * b 2 + a 9 * b 1) := by
  simp [mul, conv, coeffAt, Fin.sum_univ_succ]
  try ring

public theorem mul_apply_6 (a b : Vec) :
    mul a b 6 = a 0 * b 6 + a 1 * b 5 + a 2 * b 4 + a 3 * b 3 + a 4 * b 2 + a 5 * b 1 + a 6 * b 0 +
      (a 8 * b 9 + a 9 * b 8) -
      (a 1 * b 9 + a 2 * b 8 + a 3 * b 7 + a 4 * b 6 + a 5 * b 5 + a 6 * b 4 + a 7 * b 3 + a 8 * b 2 + a 9 * b 1) := by
  simp [mul, conv, coeffAt, Fin.sum_univ_succ]
  try ring

public theorem mul_apply_7 (a b : Vec) :
    mul a b 7 = a 0 * b 7 + a 1 * b 6 + a 2 * b 5 + a 3 * b 4 + a 4 * b 3 + a 5 * b 2 + a 6 * b 1 + a 7 * b 0 +
      (a 9 * b 9) -
      (a 1 * b 9 + a 2 * b 8 + a 3 * b 7 + a 4 * b 6 + a 5 * b 5 + a 6 * b 4 + a 7 * b 3 + a 8 * b 2 + a 9 * b 1) := by
  simp [mul, conv, coeffAt, Fin.sum_univ_succ]
  try ring

public theorem mul_apply_8 (a b : Vec) :
    mul a b 8 = a 0 * b 8 + a 1 * b 7 + a 2 * b 6 + a 3 * b 5 + a 4 * b 4 + a 5 * b 3 + a 6 * b 2 + a 7 * b 1 + a 8 * b 0 -
      (a 1 * b 9 + a 2 * b 8 + a 3 * b 7 + a 4 * b 6 + a 5 * b 5 + a 6 * b 4 + a 7 * b 3 + a 8 * b 2 + a 9 * b 1) := by
  simp [mul, conv, coeffAt, Fin.sum_univ_succ]
  try ring

public theorem mul_apply_9 (a b : Vec) :
    mul a b 9 = a 0 * b 9 + a 1 * b 8 + a 2 * b 7 + a 3 * b 6 + a 4 * b 5 + a 5 * b 4 + a 6 * b 3 + a 7 * b 2 + a 8 * b 1 + a 9 * b 0 -
      (a 1 * b 9 + a 2 * b 8 + a 3 * b 7 + a 4 * b 6 + a 5 * b 5 + a 6 * b 4 + a 7 * b 3 + a 8 * b 2 + a 9 * b 1) := by
  simp [mul, conv, coeffAt, Fin.sum_univ_succ]
  try ring


/-- Coordinatewise extensionality, with `fin_cases` paid once.  The generated
certificates used to write `funext n; fin_cases n <;> norm_num [..]`, and
`fin_cases` inlines a `List.Mem.casesOn` over `List.finRange 10` into every one
of the ten coordinate goals. -/
public theorem vec_ext {a b : Vec}
    (h0 : a ⟨0, by omega⟩ = b ⟨0, by omega⟩) (h1 : a ⟨1, by omega⟩ = b ⟨1, by omega⟩)
    (h2 : a ⟨2, by omega⟩ = b ⟨2, by omega⟩) (h3 : a ⟨3, by omega⟩ = b ⟨3, by omega⟩)
    (h4 : a ⟨4, by omega⟩ = b ⟨4, by omega⟩) (h5 : a ⟨5, by omega⟩ = b ⟨5, by omega⟩)
    (h6 : a ⟨6, by omega⟩ = b ⟨6, by omega⟩) (h7 : a ⟨7, by omega⟩ = b ⟨7, by omega⟩)
    (h8 : a ⟨8, by omega⟩ = b ⟨8, by omega⟩) (h9 : a ⟨9, by omega⟩ = b ⟨9, by omega⟩) : a = b := by
  funext n
  fin_cases n <;> assumption


end V14Formalization.D12CyclotomicVec
