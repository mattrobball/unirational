/-
Order-11 unipotent character sum: Newton, Sylow partition, weighted 180.
Leads to ∑_g χ₁₀' χ_Λ² = 660 and finrank Msub = 10.
-/
module

public import V14Formalization.GeometricV14Carrier
public import V14Formalization.PSLCard
public import Mathlib.GroupTheory.Sylow
public import Mathlib.GroupTheory.PGroup
public import Mathlib.GroupTheory.Index
public import Mathlib.Data.Nat.Factorization.Basic
public import Mathlib.LinearAlgebra.Trace
public import Mathlib.LinearAlgebra.Dimension.Finite
public import Mathlib.LinearAlgebra.FiniteDimensional.Lemmas
public import Mathlib.LinearAlgebra.Matrix.ToLin
public import Mathlib.LinearAlgebra.Matrix.Diagonal
public import Mathlib.Data.Matrix.Mul
public import Mathlib.Tactic.Abel

open Module LinearMap BigOperators Finset
open V14Formalization.GeometricV14Carrier
open V14Formalization
open WeilRep

noncomputable section

namespace V14Formalization
namespace Ord11CharacterSum

/-! ## Order-11: scaled Gauss sums and half-sum -/

/-- ∑_x ψ(a x²) = 11 if a=0, else χ₂(a)·gauss. -/
theorem sum_ψ_sq_mul (a : ZMod 11) :
    (∑ x : ZMod 11, ψ (a * x ^ 2)) =
      if a = 0 then (11 : k) else χ₂ a * gauss := by
  classical
  by_cases ha : a = 0
  · subst ha
    simp only [zero_mul, ψ_zero, Finset.sum_const, Finset.card_univ, ZMod.card,
      nsmul_eq_mul, mul_one, ↓reduceIte]
    norm_cast
  · have hx : ∀ x : ZMod 11, ψ (a * x ^ 2) =
        ∑ y : ZMod 11, (if a * x ^ 2 = y then (1 : k) else 0) * ψ y := by
      intro x
      rw [Finset.sum_eq_single (a * x ^ 2)]
      · simp only [↓reduceIte, one_mul]
      · intro b _ hb
        simp only [Ne.symm hb, ↓reduceIte, zero_mul]
      · intro h; exact absurd (Finset.mem_univ _) h
    have h1 : (∑ x : ZMod 11, ψ (a * x ^ 2)) =
        ∑ x : ZMod 11, ∑ y : ZMod 11,
          (if a * x ^ 2 = y then (1 : k) else 0) * ψ y :=
      Finset.sum_congr rfl fun x _ => hx x
    rw [h1, Finset.sum_comm]
    have h2 : (∑ y : ZMod 11, ∑ x : ZMod 11,
          (if a * x ^ 2 = y then (1 : k) else 0) * ψ y) =
        ∑ y : ZMod 11,
          (∑ x : ZMod 11, if a * x ^ 2 = y then (1 : k) else 0) * ψ y := by
      refine Finset.sum_congr rfl fun y _ => ?_
      simp_rw [mul_comm _ (ψ y)]
      exact (Finset.mul_sum _ _ _).symm
    rw [h2]
    have hcnt (y : ZMod 11) :
        (∑ x : ZMod 11, if a * x ^ 2 = y then (1 : k) else 0) =
          χ₂ (a⁻¹ * y) + 1 := by
      have hset : (∑ x : ZMod 11, if a * x ^ 2 = y then (1 : k) else 0) =
          (∑ x : ZMod 11, if x ^ 2 = a⁻¹ * y then (1 : k) else 0) := by
        refine Finset.sum_congr rfl fun x _ => ?_
        have : a * x ^ 2 = y ↔ x ^ 2 = a⁻¹ * y := by
          constructor
          · intro h
            have := congrArg (fun z => a⁻¹ * z) h
            rwa [← mul_assoc, inv_mul_cancel₀ ha, one_mul] at this
          · intro h
            have := congrArg (fun z => a * z) h
            rwa [← mul_assoc, mul_inv_cancel₀ ha, one_mul] at this
        simp only [this]
      rw [hset]
      have : (∑ x : ZMod 11, if x ^ 2 = a⁻¹ * y then (1 : k) else 0) =
          ((Finset.univ.filter (fun x : ZMod 11 => x ^ 2 = a⁻¹ * y)).card : k) := by
        simp [Finset.sum_boole]
      rw [this, card_sq_eq]
    simp_rw [hcnt, add_mul, one_mul, Finset.sum_add_distrib, sum_ψ_eq_zero, add_zero]
    have hχinv : χ₂ a⁻¹ = χ₂ a := by
      have h1 : χ₂ a⁻¹ = χ₂⁻¹ a := (MulChar.inv_apply' χ₂ a).symm
      have h2 : χ₂⁻¹ = χ₂ := χ₂_isQuadratic.inv
      rwa [h2] at h1
    have hmul (y : ZMod 11) : χ₂ (a⁻¹ * y) = χ₂ a⁻¹ * χ₂ y :=
      map_mul χ₂ a⁻¹ y
    have hpull : (∑ y : ZMod 11, χ₂ (a⁻¹ * y) * ψ y) =
        χ₂ a⁻¹ * ∑ y : ZMod 11, χ₂ y * ψ y := by
      simp_rw [hmul, mul_assoc]
      exact (Finset.mul_sum _ _ _).symm
    have hgs : (∑ y : ZMod 11, χ₂ y * ψ y) = gauss := by
      rw [gauss_eq_gaussSum]; rfl
    rw [hpull, hχinv, hgs]
    simp only [ha, ↓reduceIte]

private theorem sum_fin6 (f : Fin 6 → k) :
    (∑ i : Fin 6, f i) = f 0 + f 1 + f 2 + f 3 + f 4 + f 5 := by
  have h : (univ : Finset (Fin 6)) = {0, 1, 2, 3, 4, 5} := by decide
  rw [h]
  rw [sum_insert (by decide : (0 : Fin 6) ∉ ({1, 2, 3, 4, 5} : Finset (Fin 6)))]
  rw [sum_insert (by decide : (1 : Fin 6) ∉ ({2, 3, 4, 5} : Finset (Fin 6)))]
  rw [sum_insert (by decide : (2 : Fin 6) ∉ ({3, 4, 5} : Finset (Fin 6)))]
  rw [sum_insert (by decide : (3 : Fin 6) ∉ ({4, 5} : Finset (Fin 6)))]
  rw [sum_insert (by decide : (4 : Fin 6) ∉ ({5} : Finset (Fin 6)))]
  rw [sum_singleton]
  abel

private theorem sum_fin11 (f : Fin 11 → k) :
    (∑ i : Fin 11, f i) =
      f 0 + f 1 + f 2 + f 3 + f 4 + f 5 + f 6 + f 7 + f 8 + f 9 + f 10 := by
  have h : (univ : Finset (Fin 11)) =
      {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10} := by decide
  rw [h]
  rw [sum_insert (by decide : (0 : Fin 11) ∉
    ({1, 2, 3, 4, 5, 6, 7, 8, 9, 10} : Finset (Fin 11)))]
  rw [sum_insert (by decide : (1 : Fin 11) ∉
    ({2, 3, 4, 5, 6, 7, 8, 9, 10} : Finset (Fin 11)))]
  rw [sum_insert (by decide : (2 : Fin 11) ∉
    ({3, 4, 5, 6, 7, 8, 9, 10} : Finset (Fin 11)))]
  rw [sum_insert (by decide : (3 : Fin 11) ∉
    ({4, 5, 6, 7, 8, 9, 10} : Finset (Fin 11)))]
  rw [sum_insert (by decide : (4 : Fin 11) ∉
    ({5, 6, 7, 8, 9, 10} : Finset (Fin 11)))]
  rw [sum_insert (by decide : (5 : Fin 11) ∉
    ({6, 7, 8, 9, 10} : Finset (Fin 11)))]
  rw [sum_insert (by decide : (6 : Fin 11) ∉
    ({7, 8, 9, 10} : Finset (Fin 11)))]
  rw [sum_insert (by decide : (7 : Fin 11) ∉
    ({8, 9, 10} : Finset (Fin 11)))]
  rw [sum_insert (by decide : (8 : Fin 11) ∉
    ({9, 10} : Finset (Fin 11)))]
  rw [sum_insert (by decide : (9 : Fin 11) ∉ ({10} : Finset (Fin 11)))]
  rw [sum_singleton]
  abel

private theorem sum_ψ_sq_full_paired (a : ZMod 11) :
    (∑ x : ZMod 11, ψ (a * x ^ 2)) =
      1 + 2 * (ψ (a * (1 : ZMod 11) ^ 2) + ψ (a * (2 : ZMod 11) ^ 2) +
        ψ (a * (3 : ZMod 11) ^ 2) + ψ (a * (4 : ZMod 11) ^ 2) +
        ψ (a * (5 : ZMod 11) ^ 2)) := by
  classical
  -- Expand univ as explicit Finset of ZMod elements
  have huniv : (univ : Finset (ZMod 11)) =
      {(0 : ZMod 11), 1, 2, 3, 4, 5, 6, 7, 8, 9, 10} := by decide
  rw [show (∑ x : ZMod 11, ψ (a * x ^ 2)) = ∑ x ∈ univ, ψ (a * x ^ 2) from rfl, huniv]
  -- Insert-chain
  rw [sum_insert (by decide : (0 : ZMod 11) ∉
        ({1, 2, 3, 4, 5, 6, 7, 8, 9, 10} : Finset (ZMod 11)))]
  rw [sum_insert (by decide : (1 : ZMod 11) ∉
        ({2, 3, 4, 5, 6, 7, 8, 9, 10} : Finset (ZMod 11)))]
  rw [sum_insert (by decide : (2 : ZMod 11) ∉
        ({3, 4, 5, 6, 7, 8, 9, 10} : Finset (ZMod 11)))]
  rw [sum_insert (by decide : (3 : ZMod 11) ∉
        ({4, 5, 6, 7, 8, 9, 10} : Finset (ZMod 11)))]
  rw [sum_insert (by decide : (4 : ZMod 11) ∉
        ({5, 6, 7, 8, 9, 10} : Finset (ZMod 11)))]
  rw [sum_insert (by decide : (5 : ZMod 11) ∉
        ({6, 7, 8, 9, 10} : Finset (ZMod 11)))]
  rw [sum_insert (by decide : (6 : ZMod 11) ∉
        ({7, 8, 9, 10} : Finset (ZMod 11)))]
  rw [sum_insert (by decide : (7 : ZMod 11) ∉
        ({8, 9, 10} : Finset (ZMod 11)))]
  rw [sum_insert (by decide : (8 : ZMod 11) ∉
        ({9, 10} : Finset (ZMod 11)))]
  rw [sum_insert (by decide : (9 : ZMod 11) ∉ ({10} : Finset (ZMod 11)))]
  rw [sum_singleton]
  -- Square pairings
  have p6 : ((6 : ZMod 11) ^ 2) = ((5 : ZMod 11) ^ 2) := by decide
  have p7 : ((7 : ZMod 11) ^ 2) = ((4 : ZMod 11) ^ 2) := by decide
  have p8 : ((8 : ZMod 11) ^ 2) = ((3 : ZMod 11) ^ 2) := by decide
  have p9 : ((9 : ZMod 11) ^ 2) = ((2 : ZMod 11) ^ 2) := by decide
  have p10 : ((10 : ZMod 11) ^ 2) = ((1 : ZMod 11) ^ 2) := by decide
  simp only [p6, p7, p8, p9, p10]
  have hz : ψ (a * (0 : ZMod 11) ^ 2) = 1 := by
    simp [zero_pow (by decide : (2 : ℕ) ≠ 0), ψ_zero]
  rw [hz]
  ring

private theorem sum_ψ_sq_half_explicit (a : ZMod 11) :
    (∑ j : Fin 6, ψ (a * (j.val : ZMod 11) ^ 2)) =
      1 + ψ (a * (1 : ZMod 11) ^ 2) + ψ (a * (2 : ZMod 11) ^ 2) +
        ψ (a * (3 : ZMod 11) ^ 2) + ψ (a * (4 : ZMod 11) ^ 2) +
        ψ (a * (5 : ZMod 11) ^ 2) := by
  have h := sum_fin6 (fun j => ψ (a * (j.val : ZMod 11) ^ 2))
  rw [h]
  have e0 : ((0 : Fin 6).val : ZMod 11) = 0 := by decide
  have e1 : ((1 : Fin 6).val : ZMod 11) = 1 := by decide
  have e2 : ((2 : Fin 6).val : ZMod 11) = 2 := by decide
  have e3 : ((3 : Fin 6).val : ZMod 11) = 3 := by decide
  have e4 : ((4 : Fin 6).val : ZMod 11) = 4 := by decide
  have e5 : ((5 : Fin 6).val : ZMod 11) = 5 := by decide
  rw [e0, e1, e2, e3, e4, e5]
  -- ψ(a * 0^2) = ψ 0 = 1; sides match up to association
  simp [zero_pow (by decide : (2 : ℕ) ≠ 0), mul_zero, ψ_zero]

/-- ∑_{j=0..5} ψ(a j²) = (1 + ∑_x ψ(a x²))/2. -/
theorem sum_ψ_sq_mul_half (a : ZMod 11) :
    (∑ j : Fin 6, ψ (a * (j.val : ZMod 11) ^ 2)) =
      (1 + ∑ x : ZMod 11, ψ (a * x ^ 2)) * (2 : k)⁻¹ := by
  have hF := sum_ψ_sq_full_paired a
  have hH := sum_ψ_sq_half_explicit a
  set S := ψ (a * (1 : ZMod 11) ^ 2) + ψ (a * (2 : ZMod 11) ^ 2) +
    ψ (a * (3 : ZMod 11) ^ 2) + ψ (a * (4 : ZMod 11) ^ 2) +
    ψ (a * (5 : ZMod 11) ^ 2)
  have hF' : (∑ x : ZMod 11, ψ (a * x ^ 2)) = 1 + 2 * S := hF
  have hH' : (∑ j : Fin 6, ψ (a * (j.val : ZMod 11) ^ 2)) = 1 + S := by
    rw [hH]; ring
  rw [hH', hF']
  -- S is defeq to the expanded sum in hF
  change 1 + S = (1 + (1 + 2 * S)) * (2 : k)⁻¹
  field_simp
  ring

theorem sum_ψ_sq_mul_half_ne (a : ZMod 11) (ha : a ≠ 0) :
    (∑ j : Fin 6, ψ (a * (j.val : ZMod 11) ^ 2)) =
      (1 + χ₂ a * gauss) * (2 : k)⁻¹ := by
  rw [sum_ψ_sq_mul_half, sum_ψ_sq_mul]
  simp only [ha, ↓reduceIte]

/-! ### Trace of T_even_b via evalEven diagonalization -/

/-- evalEven conjugates T_even_b to diagonal multiplication. -/
theorem evalEven_T_even_b (b : ZMod 11) (f : GeometricV14Carrier.U) (j : Fin 6) :
    GeometricFanoCarrier.evalEven (T_even_b b f) j =
      ψ (b * (j.val : ZMod 11) ^ 2 * twoInv) *
        GeometricFanoCarrier.evalEven f j := by
  change (T_even_b b f).1 (j.val : ZMod 11) =
    ψ (b * (j.val : ZMod 11) ^ 2 * twoInv) * f.1 (j.val : ZMod 11)
  simp only [T_even_b, Tfull_b, LinearMap.coe_mk, AddHom.coe_mk]

/-- Diagonal multiplication operator on `Fin 6 → k`. -/
noncomputable def diagMul (c : Fin 6 → k) : Module.End k (Fin 6 → k) where
  toFun v j := c j * v j
  map_add' := by
    intro v w; funext j
    simp only [Pi.add_apply]; ring
  map_smul' := by
    intro r v; funext j
    simp only [Pi.smul_apply, smul_eq_mul, RingHom.id_apply]; ring

theorem diagMul_apply (c v : Fin 6 → k) (j : Fin 6) :
    diagMul c v j = c j * v j := rfl

/-- `diagMul c` equals the linear map of the diagonal matrix. -/
theorem diagMul_eq_toLin' (c : Fin 6 → k) :
    diagMul c = Matrix.toLin' (Matrix.diagonal c) := by
  apply LinearMap.ext
  intro v
  funext i
  rw [diagMul_apply, Matrix.toLin'_apply, Matrix.mulVec_diagonal]

/-- Trace of a diagonal operator is the sum of diagonal entries. -/
theorem trace_diagMul (c : Fin 6 → k) :
    LinearMap.trace k (Fin 6 → k) (diagMul c) = ∑ j : Fin 6, c j := by
  rw [diagMul_eq_toLin', Matrix.trace_toLin'_eq, Matrix.trace_diagonal]

/-- evalEven is a linear equivalence U ≃ (Fin 6 → k). -/
noncomputable def evalEvenEquiv : GeometricV14Carrier.U ≃ₗ[k] (Fin 6 → k) := by
  have hfin :
      Module.finrank k GeometricV14Carrier.U = Module.finrank k (Fin 6 → k) := by
    rw [GeometricFanoCarrier.finrank_U, Module.finrank_fintype_fun_eq_card]
    decide
  have hbi : Function.Bijective GeometricFanoCarrier.evalEven :=
    ⟨GeometricFanoCarrier.evalEven_injective,
      (LinearMap.injective_iff_surjective_of_finrank_eq_finrank hfin).1
        GeometricFanoCarrier.evalEven_injective⟩
  exact LinearEquiv.ofBijective GeometricFanoCarrier.evalEven hbi

theorem evalEvenEquiv_apply (f : GeometricV14Carrier.U) :
    evalEvenEquiv f = GeometricFanoCarrier.evalEven f := rfl

theorem evalEven_conj_T_even_b (b : ZMod 11) :
    evalEvenEquiv.conj (T_even_b b) =
      diagMul (fun j => ψ (b * (j.val : ZMod 11) ^ 2 * twoInv)) := by
  apply LinearMap.ext
  intro v
  ext j
  -- LHS: (evalEvenEquiv.conj T) v j
  -- = evalEvenEquiv (T (evalEvenEquiv.symm v)) j
  -- = evalEven (T (evalEvenEquiv.symm v)) j
  change GeometricFanoCarrier.evalEven
      (T_even_b b (evalEvenEquiv.symm v)) j =
    ψ (b * (j.val : ZMod 11) ^ 2 * twoInv) * v j
  rw [evalEven_T_even_b]
  have hsymm : GeometricFanoCarrier.evalEven (evalEvenEquiv.symm v) = v :=
    evalEvenEquiv.apply_symm_apply v
  rw [hsymm]

/-- `tr(T_even_b b) = ∑_j ψ(b j² twoInv)`. -/
theorem T_even_b_trace (b : ZMod 11) :
    LinearMap.trace k GeometricV14Carrier.U (T_even_b b) =
      ∑ j : Fin 6, ψ (b * (j.val : ZMod 11) ^ 2 * twoInv) := by
  have htr := (LinearMap.trace_conj' (T_even_b b) evalEvenEquiv).symm
  -- htr: tr(conj T) = tr T, so tr T = tr (conj T)
  rw [htr, evalEven_conj_T_even_b, trace_diagMul]

/-- For b ≠ 0: `tr(T_b) = (1 + χ₂(b·twoInv)·gauss)/2`. -/
theorem T_even_b_trace_ne (b : ZMod 11) (hb : b ≠ 0) :
    LinearMap.trace k GeometricV14Carrier.U (T_even_b b) =
      (1 + χ₂ (b * twoInv) * gauss) * (2 : k)⁻¹ := by
  rw [T_even_b_trace]
  have h2ne : (2 : ZMod 11) ≠ 0 := by decide
  have hbt : b * twoInv ≠ 0 := mul_ne_zero hb (inv_ne_zero h2ne)
  have h := sum_ψ_sq_mul_half_ne (b * twoInv) hbt
  -- ∑ ψ(b j² twoInv) = ∑ ψ((b twoInv) j²)
  convert h using 1
  refine Finset.sum_congr rfl fun j _ => ?_
  have : b * (j.val : ZMod 11) ^ 2 * twoInv =
      (b * twoInv) * (j.val : ZMod 11) ^ 2 := by ring
  rw [this]

/-! ### Newton χ_Λ² on unipotents and order-11 weighted sum -/

open V14Formalization.WeilMul

noncomputable def tGen : PSL2F11 := QuotientGroup.mk WeilRep.Tmat

/-- `weilU (Tmat^n) = T_even_b n`. -/
theorem weilU_Tmat_pow (n : ℕ) :
    WeilHom.weilUHom (WeilRep.Tmat ^ n) = T_even_b (n : ZMod 11) := by
  have hT : WeilHom.weilUHom WeilRep.Tmat = T_even_b 1 := WeilRepSL2.weilU_Tmat
  rw [map_pow, hT]
  induction n with
  | zero =>
    simp only [pow_zero, Nat.cast_zero, T_even_b_zero, Module.End.one_eq_id]
  | succ n ih =>
    rw [pow_succ, Nat.cast_succ, ih, Module.End.mul_eq_comp, ← T_even_b_add]

theorem ambientAct_tGen_pow (n : ℕ) :
    ambientAct (tGen ^ n) =
      exteriorPower.map (R := k) (n := 2) (T_even_b (n : ZMod 11)) := by
  have hpow : tGen ^ n = QuotientGroup.mk (WeilRep.Tmat ^ n) := by
    dsimp only [tGen]
    exact (map_pow
        (QuotientGroup.mk' (G := GeometricFanoCarrier.SLG)
          (N := Subgroup.center GeometricFanoCarrier.SLG))
        WeilRep.Tmat n).symm
  calc ambientAct (tGen ^ n)
      = ambientAct (QuotientGroup.mk (WeilRep.Tmat ^ n)) := by rw [hpow]
    _ = GeometricFanoCarrier.weilLambda2 (WeilRep.Tmat ^ n) := by
        dsimp only [ambientAct]
        exact GeometricFanoCarrier.pslLambda2_mk (WeilRep.Tmat ^ n)
    _ = exteriorPower.map 2 (WeilHom.weilUHom (WeilRep.Tmat ^ n)) := rfl
    _ = exteriorPower.map 2 (T_even_b (n : ZMod 11)) := by rw [weilU_Tmat_pow]

theorem T_even_b_comp_self (b : ZMod 11) :
    T_even_b b ∘ₗ T_even_b b = T_even_b (2 * b) := by
  rw [← T_even_b_add]
  congr 1
  ring

/-- χ_Λ²(tGen^n) = 2⁻¹ · ((tr T_n)² − tr T_{2n}) by Newton. -/
theorem chiLambda2_tGen_pow (n : ℕ) :
    chiLambda2 (tGen ^ n) =
      (2 : k)⁻¹ *
        ((LinearMap.trace k GeometricV14Carrier.U (T_even_b (n : ZMod 11))) ^ 2 -
          LinearMap.trace k GeometricV14Carrier.U
            (T_even_b ((2 : ZMod 11) * n))) := by
  dsimp [chiLambda2]
  rw [ambientAct_tGen_pow n]
  have h :=
    trace_exterior_newton (V := GeometricV14Carrier.U) (T_even_b (n : ZMod 11))
  rw [h, T_even_b_comp_self]

theorem χ₂_twoInv : χ₂ twoInv = -1 := by
  have : twoInv = (2 : ZMod 11)⁻¹ := rfl
  rw [this, χ₂_inv (by decide : (2 : ZMod 11) ≠ 0), WeilMul.χ₂_two]

/-- Explicit: χ_Λ²(t^n) = (−3 − χ₂(n)·gauss)·2⁻¹ for n ≠ 0 mod 11.
Uses τ = (1 − χg)/2, τ₂ = (1 + χg)/2 with χg² = −11. -/
theorem chiLambda2_tGen_pow_eq (n : ℕ) (hn : (n : ZMod 11) ≠ 0) :
    chiLambda2 (tGen ^ n) =
      (-3 - χ₂ (n : ZMod 11) * gauss) * (2 : k)⁻¹ := by
  rw [chiLambda2_tGen_pow n]
  have htr := T_even_b_trace_ne (n : ZMod 11) hn
  have h2ne : (2 : ZMod 11) ≠ 0 := by decide
  have h2n : (2 : ZMod 11) * n ≠ 0 := mul_ne_zero h2ne hn
  have htr2 := T_even_b_trace_ne ((2 : ZMod 11) * n) h2n
  have hχ1 : χ₂ ((n : ZMod 11) * twoInv) = -χ₂ (n : ZMod 11) := by
    rw [map_mul χ₂, χ₂_twoInv]; ring
  have hχ2' : χ₂ ((2 : ZMod 11) * n * twoInv) = χ₂ (n : ZMod 11) := by
    have heq : (2 : ZMod 11) * n * twoInv = n := by
      calc (2 : ZMod 11) * n * twoInv
          = n * (2 * twoInv) := by ring
        _ = n * 1 := by rw [two_mul_twoInv]
        _ = n := mul_one _
    rw [heq]
  rw [htr, htr2, hχ1, hχ2']
  set χg : k := χ₂ (n : ZMod 11) * gauss with hχg
  have hχgsq : χg ^ 2 = (-11 : k) := by
    rw [hχg, mul_pow, pow_two]
    have hχsq : χ₂ (n : ZMod 11) * χ₂ (n : ZMod 11) = 1 := χ₂_sq_one hn
    rw [hχsq, one_mul, gauss_sq]
  have hform :
      (2 : k)⁻¹ *
          (((1 + -χg) * (2 : k)⁻¹) ^ 2 - (1 + χg) * (2 : k)⁻¹) =
        (-3 - χg) * (2 : k)⁻¹ := by
    have h2ne' : (2 : k) ≠ 0 := by norm_num
    field_simp [h2ne']
    -- residual: (1 - χg)² - 2(1+χg) = 4(-3-χg)
    have hexpand :
        (1 + -χg) ^ 2 - 2 * (1 + χg) = χg ^ 2 - 4 * χg - 1 := by ring
    rw [hexpand, hχgsq]
    ring
  convert hform using 2 <;> ring

/-- ∑_{b=1}^{10} χ₂(b) = 0. -/
theorem sum_χ₂_Icc_one_ten :
    (∑ b ∈ Finset.Icc (1 : ℕ) 10, χ₂ (b : ZMod 11)) = 0 := by
  classical
  have hfull : (∑ x : ZMod 11, χ₂ x) = 0 :=
    MulChar.sum_eq_zero_of_ne_one χ₂_ne_one
  have h0 : χ₂ (0 : ZMod 11) = 0 :=
    MulChar.map_nonunit χ₂ (by decide : ¬IsUnit (0 : ZMod 11))
  have hsum :
      (∑ b ∈ Finset.Icc (1 : ℕ) 10, χ₂ (b : ZMod 11)) =
        ∑ x ∈ (Finset.univ : Finset (ZMod 11)).erase 0, χ₂ x := by
    refine Finset.sum_bij (fun (b : ℕ) (_ : b ∈ Finset.Icc (1 : ℕ) 10) => (b : ZMod 11))
      ?mem ?inj ?surj ?eq
    · intro b hb
      have ⟨_hb1, hb10⟩ := Finset.mem_Icc.mp hb
      refine Finset.mem_erase.mpr ⟨?_, Finset.mem_univ _⟩
      intro h0b
      have hlt : b < 11 := Nat.lt_succ_of_le hb10
      have : b = 0 := by
        have := congrArg ZMod.val h0b
        rwa [ZMod.val_cast_of_lt hlt, ZMod.val_zero] at this
      omega
    · intro a ha b hb heq
      have ⟨_ha1, ha10⟩ := Finset.mem_Icc.mp ha
      have ⟨_hb1, hb10⟩ := Finset.mem_Icc.mp hb
      have hlt_a : a < 11 := Nat.lt_succ_of_le ha10
      have hlt_b : b < 11 := Nat.lt_succ_of_le hb10
      have := congrArg ZMod.val heq
      rwa [ZMod.val_cast_of_lt hlt_a, ZMod.val_cast_of_lt hlt_b] at this
    · intro x hx
      have ⟨hx0, _⟩ := Finset.mem_erase.mp hx
      refine ⟨x.val, ?_, ?_⟩
      · refine Finset.mem_Icc.mpr ⟨?_, Nat.lt_succ_iff.mp (ZMod.val_lt x)⟩
        exact Nat.pos_of_ne_zero (fun h => hx0 ((ZMod.val_eq_zero x).mp h))
      · exact ZMod.natCast_zmod_val x
    · intro b hb; rfl
  rw [hsum, Finset.sum_erase (Finset.univ : Finset (ZMod 11)) h0, hfull]

/-- ∑_{b=1}^{10} χ_Λ²(t^b) = −15. -/
theorem sum_chiLambda2_tGen_pow_range :
    (∑ b ∈ Finset.Icc (1 : ℕ) 10, chiLambda2 (tGen ^ b)) = (-15 : k) := by
  classical
  have hval : ∀ b ∈ Finset.Icc (1 : ℕ) 10,
      chiLambda2 (tGen ^ b) =
        (-3 - χ₂ (b : ZMod 11) * gauss) * (2 : k)⁻¹ := by
    intro b hb
    have ⟨_hb1, hb10⟩ := Finset.mem_Icc.mp hb
    have hn : (b : ZMod 11) ≠ 0 := by
      intro h0
      have hlt : b < 11 := Nat.lt_succ_of_le hb10
      have : b = 0 := by
        have := congrArg ZMod.val h0
        rwa [ZMod.val_cast_of_lt hlt, ZMod.val_zero] at this
      omega
    exact chiLambda2_tGen_pow_eq b hn
  rw [Finset.sum_congr rfl hval]
  have hfactor :
      (∑ b ∈ Finset.Icc (1 : ℕ) 10,
          (-3 - χ₂ (b : ZMod 11) * gauss) * (2 : k)⁻¹) =
        (2 : k)⁻¹ *
          ∑ b ∈ Finset.Icc (1 : ℕ) 10, (-3 - χ₂ (b : ZMod 11) * gauss) := by
    rw [Finset.mul_sum]
    refine Finset.sum_congr rfl fun _ _ => mul_comm _ _
  rw [hfactor]
  have hsplit :
      (∑ b ∈ Finset.Icc (1 : ℕ) 10, (-3 - χ₂ (b : ZMod 11) * gauss) : k) =
        (-30 : k) := by
    have hcard : (Finset.Icc (1 : ℕ) 10).card = 10 := by decide
    have hsub :
        (∑ b ∈ Finset.Icc (1 : ℕ) 10, (-3 - χ₂ (b : ZMod 11) * gauss) : k) =
          (∑ b ∈ Finset.Icc (1 : ℕ) 10, (-3 : k)) -
            ∑ b ∈ Finset.Icc (1 : ℕ) 10, (χ₂ (b : ZMod 11) * gauss : k) := by
      exact Finset.sum_sub_distrib
        (f := fun _ : ℕ => (-3 : k))
        (g := fun b : ℕ => χ₂ (b : ZMod 11) * gauss)
    rw [hsub]
    have hconst : (∑ b ∈ Finset.Icc (1 : ℕ) 10, (-3 : k)) = (-30 : k) := by
      rw [Finset.sum_const, hcard, nsmul_eq_mul]
      norm_num
    have hpull :
        (∑ b ∈ Finset.Icc (1 : ℕ) 10, (χ₂ (b : ZMod 11) * gauss : k)) =
          gauss * ∑ b ∈ Finset.Icc (1 : ℕ) 10, χ₂ (b : ZMod 11) := by
      rw [Finset.mul_sum]
      refine Finset.sum_congr rfl fun _ _ => mul_comm _ _
    rw [hconst, hpull, sum_χ₂_Icc_one_ten, mul_zero, sub_zero]
  rw [hsplit]
  have : (2 : k)⁻¹ * (-30 : k) = (-15 : k) := by
    field_simp
    ring
  exact this

/-! ### Order of `tGen`, Sylow-11 partition, weighted sum 180 -/

open V14Formalization.CentralizerN (center_eq_one_or_negI negI)
open scoped Pointwise

private theorem Tmat_pow_matrix (n : ℕ) :
    (WeilRep.Tmat ^ n).1 = !![(1 : ZMod 11), (n : ZMod 11); 0, 1] := by
  induction n with
  | zero =>
    ext i j; fin_cases i <;> fin_cases j <;> simp [pow_zero, WeilRep.Tmat]
  | succ n ih =>
    change ((WeilRep.Tmat ^ n * WeilRep.Tmat : WeilRepSL2.SLG) :
        Matrix (Fin 2) (Fin 2) (ZMod 11)) =
      !![(1 : ZMod 11), ((n + 1 : ℕ) : ZMod 11); 0, 1]
    have hmul :
        ((WeilRep.Tmat ^ n * WeilRep.Tmat : WeilRepSL2.SLG) :
            Matrix (Fin 2) (Fin 2) (ZMod 11)) =
          (WeilRep.Tmat ^ n : Matrix (Fin 2) (Fin 2) (ZMod 11)) *
            (WeilRep.Tmat : Matrix (Fin 2) (Fin 2) (ZMod 11)) := rfl
    rw [hmul, show (WeilRep.Tmat ^ n : Matrix (Fin 2) (Fin 2) (ZMod 11)) =
        !![(1 : ZMod 11), (n : ZMod 11); 0, 1] from ih]
    ext i j; fin_cases i <;> fin_cases j <;>
      simp [WeilRep.Tmat, Matrix.mul_apply, Fin.sum_univ_two, Nat.cast_succ]
    all_goals ring

private theorem Tmat_pow_eleven : WeilRep.Tmat ^ 11 = 1 := by
  apply Subtype.ext
  rw [Tmat_pow_matrix]
  ext i j; fin_cases i <;> fin_cases j <;> simp
  decide

private theorem tGen_pow_eleven : tGen ^ 11 = 1 := by
  dsimp [tGen]
  rw [← QuotientGroup.mk_pow, Tmat_pow_eleven, QuotientGroup.mk_one]

private theorem tGen_pow_ne_one (m : ℕ) (hm0 : 0 < m) (hm11 : m < 11) :
    tGen ^ m ≠ 1 := by
  intro h
  have hmk : (QuotientGroup.mk (WeilRep.Tmat ^ m) : PSL2F11) = 1 := by
    dsimp [tGen] at h
    rwa [← QuotientGroup.mk_pow] at h
  have hz : WeilRep.Tmat ^ m ∈ Subgroup.center WeilRepSL2.SLG :=
    (QuotientGroup.eq_one_iff _).mp hmk
  rcases center_eq_one_or_negI (WeilRep.Tmat ^ m) hz with h1 | hneg
  · have h01 : (WeilRep.Tmat ^ m).1 0 1 = 0 := by rw [h1]; simp
    have h01' : (m : ZMod 11) = 0 := by rw [Tmat_pow_matrix] at h01; simpa using h01
    have : 11 ∣ m := (ZMod.natCast_eq_zero_iff m 11).mp h01'
    exact absurd (Nat.eq_zero_of_dvd_of_lt this hm11) (Nat.pos_iff_ne_zero.mp hm0)
  · have h00 : (WeilRep.Tmat ^ m).1 0 0 = -1 := by
      rw [hneg]; simp [negI]
    have : (1 : ZMod 11) = -1 := by rw [Tmat_pow_matrix] at h00; simpa using h00
    exact absurd this (by decide)

theorem orderOf_tGen : orderOf tGen = 11 :=
  (orderOf_eq_iff (by decide : 0 < 11)).2 ⟨tGen_pow_eleven,
    fun m hm11 hm0 h => tGen_pow_ne_one m hm0 hm11 h⟩

theorem orderOf_tGen_pow {b : ℕ} (hb : b ∈ Finset.Icc (1 : ℕ) 10) :
    orderOf (tGen ^ b) = 11 := by
  have ⟨hb1, hb10⟩ := Finset.mem_Icc.mp hb
  have hpow := orderOf_pow (x := tGen) (n := b)
  rw [orderOf_tGen] at hpow
  have hgcd : Nat.gcd 11 b = 1 := by
    have hlt : b < 11 := Nat.lt_succ_of_le hb10
    have hbpos : b ≠ 0 := Nat.pos_iff_ne_zero.mp (Nat.succ_le_iff.mp hb1)
    exact Nat.coprime_iff_gcd_eq_one.mp
      (Nat.coprime_of_lt_prime hbpos hlt (by decide : Nat.Prime 11))
  rwa [hgcd, Nat.div_one] at hpow

private theorem tGen_pow_injOn_Icc :
    Set.InjOn (fun b : ℕ => tGen ^ b) (Finset.Icc (1 : ℕ) 10) := by
  intro a ha b hb heq
  have ⟨_, ha10⟩ := Finset.mem_Icc.mp ha
  have ⟨_, hb10⟩ := Finset.mem_Icc.mp hb
  have hmod : a % orderOf tGen = b % orderOf tGen := (pow_inj_mod).mp heq
  rw [orderOf_tGen] at hmod
  have ha_lt : a < 11 := Nat.lt_succ_of_le ha10
  have hb_lt : b < 11 := Nat.lt_succ_of_le hb10
  rwa [Nat.mod_eq_of_lt ha_lt, Nat.mod_eq_of_lt hb_lt] at hmod

/-- ∑_{b=1}^{10} χ_Λ²(tGen^b) reindexed as sum over ⟨tGen⟩\{1}. -/
theorem sum_chiLambda2_zpowers_tGen_ne_one :
    (∑ g ∈ Finset.univ.filter (fun g : PSL2F11 =>
        g ∈ Subgroup.zpowers tGen ∧ g ≠ 1), chiLambda2 g) = (-15 : k) := by
  classical
  have himg :
      Finset.univ.filter (fun g : PSL2F11 => g ∈ Subgroup.zpowers tGen ∧ g ≠ 1) =
        Finset.image (fun b : ℕ => tGen ^ b) (Finset.Icc 1 10) := by
    ext g
    simp only [Finset.mem_filter, Finset.mem_univ, true_and, Finset.mem_image]
    constructor
    · intro ⟨hg, hne⟩
      obtain ⟨k, hk⟩ := Subgroup.mem_zpowers_iff.mp hg
      have hord : orderOf tGen = 11 := orderOf_tGen
      -- tGen ^ k = tGen ^ (k % 11)
      have hk_mod : tGen ^ k = tGen ^ (k % (11 : ℤ)) := by
        simpa [hord] using (zpow_mod_orderOf tGen k).symm
      set m : ℕ := (k % (11 : ℤ)).toNat
      have hnonneg : 0 ≤ k % (11 : ℤ) := Int.emod_nonneg _ (by decide)
      have hm_eq : (m : ℤ) = k % 11 := Int.toNat_of_nonneg hnonneg
      have hm_lt : m < 11 := by
        have : k % (11 : ℤ) < 11 := Int.emod_lt_of_pos _ (by decide)
        omega
      have hg_pow : g = tGen ^ m := by
        have : tGen ^ k = tGen ^ (m : ℤ) := by
          rw [hk_mod, hm_eq]
        rw [← hk, this, zpow_natCast]
      refine ⟨m, ?_, hg_pow.symm⟩
      have hne0 : m ≠ 0 := by
        intro h0
        have : g = 1 := by rw [hg_pow, h0, pow_zero]
        exact hne this
      exact Finset.mem_Icc.mpr ⟨Nat.pos_of_ne_zero hne0, Nat.lt_succ_iff.mp hm_lt⟩
    · rintro ⟨b, hb, rfl⟩
      refine ⟨Subgroup.mem_zpowers_iff.mpr ⟨(b : ℤ), by rw [zpow_natCast]⟩, ?_⟩
      intro h1
      have hord1 : orderOf (tGen ^ b) = 1 := by rw [h1, orderOf_one]
      have hord11 : orderOf (tGen ^ b) = 11 := orderOf_tGen_pow hb
      omega
  have hsum_img :
      (∑ g ∈ Finset.image (fun b : ℕ => tGen ^ b) (Finset.Icc 1 10), chiLambda2 g) =
        ∑ b ∈ Finset.Icc (1 : ℕ) 10, chiLambda2 (tGen ^ b) :=
    Finset.sum_image tGen_pow_injOn_Icc
  rw [himg, hsum_img, sum_chiLambda2_tGen_pow_range]

/-! #### Sylow 11 infrastructure (pattern from order-3 conjugacy) -/

private theorem card_G_nat : Nat.card PSL2F11 = 660 := by
  rw [Nat.card_eq_fintype_card, card_PSL2F11]

private theorem zpowers_tGen_card : Nat.card (Subgroup.zpowers tGen) = 11 := by
  rw [Nat.card_zpowers, orderOf_tGen]

private theorem zpowers_tGen_isPGroup : IsPGroup 11 (Subgroup.zpowers tGen) :=
  IsPGroup.of_card (n := 1) (by rw [zpowers_tGen_card]; norm_num)

private theorem zpowers_tGen_index : (Subgroup.zpowers tGen).index = 60 := by
  have hmul := Subgroup.index_mul_card (Subgroup.zpowers tGen)
  rw [zpowers_tGen_card, card_G_nat] at hmul
  omega

private theorem zpowers_tGen_not_dvd_index : ¬(11 ∣ (Subgroup.zpowers tGen).index) := by
  rw [zpowers_tGen_index]; decide

private noncomputable def sylow_tGen : Sylow 11 PSL2F11 := by
  haveI : Fact (Nat.Prime 11) := ⟨by decide⟩
  exact zpowers_tGen_isPGroup.toSylow zpowers_tGen_not_dvd_index

private theorem sylow_tGen_coe :
    (sylow_tGen : Subgroup PSL2F11) = Subgroup.zpowers tGen := by
  haveI : Fact (Nat.Prime 11) := ⟨by decide⟩
  exact IsPGroup.toSylow_coe zpowers_tGen_isPGroup zpowers_tGen_not_dvd_index

private theorem card_sylow11 (Q : Sylow 11 PSL2F11) : Nat.card Q = 11 := by
  haveI : Fact (Nat.Prime 11) := ⟨by decide⟩
  rw [Sylow.card_eq_multiplicity]
  have hfac : Nat.factorization (Nat.card PSL2F11) 11 = 1 := by
    rw [card_G_nat]
    have hp : Nat.Prime 11 := by decide
    rw [show 660 = 11 * 60 by norm_num,
      Nat.factorization_mul (by norm_num) (by norm_num), Finsupp.add_apply,
      hp.factorization_self,
      Nat.factorization_eq_zero_of_not_dvd (by norm_num : ¬ 11 ∣ 60)]
  rw [hfac]; norm_num

private theorem orderOf_ne_one_of_mem_sylow11 (Q : Sylow 11 PSL2F11)
    (y : Q) (hne : (y : PSL2F11) ≠ 1) : orderOf (y : PSL2F11) = 11 := by
  haveI : Fact (Nat.Prime 11) := ⟨by decide⟩
  haveI : Fintype Q := Fintype.ofFinite _
  have hy_card : y ^ Fintype.card Q = 1 := pow_card_eq_one
  have hcardQ : Fintype.card Q = 11 := by
    have h := card_sylow11 Q; rwa [Nat.card_eq_fintype_card] at h
  have hy11_Q : y ^ 11 = 1 := by rwa [hcardQ] at hy_card
  have hy11 : (y : PSL2F11) ^ 11 = 1 := by
    simpa [SubmonoidClass.coe_pow] using congrArg Subtype.val hy11_Q
  exact orderOf_eq_prime hy11 hne

private abbrev sylow11NonId (Q : Sylow 11 PSL2F11) : Type :=
  {g : PSL2F11 // g ∈ (Q : Set PSL2F11) ∧ g ≠ 1}

private theorem card_sylow11NonId (Q : Sylow 11 PSL2F11) : Nat.card (sylow11NonId Q) = 10 := by
  classical
  haveI : Fintype Q := Fintype.ofFinite _
  have hcardQ : Nat.card Q = 11 := card_sylow11 Q
  let e : sylow11NonId Q ≃ {y : Q // y ≠ 1} :=
    { toFun := fun ⟨g, hg, hne⟩ => ⟨⟨g, hg⟩, fun h => hne (congrArg Subtype.val h)⟩
      invFun := fun ⟨y, hyne⟩ => ⟨y.1, y.2, fun h => hyne (Subtype.ext h)⟩
      left_inv := fun ⟨g, hg, hne⟩ => rfl
      right_inv := fun ⟨y, hyne⟩ => rfl }
  haveI : Fintype {y : Q // y ≠ 1} := Fintype.ofFinite _
  haveI : Fintype {y : Q // y = 1} := Fintype.ofFinite _
  have hne : Nat.card {y : Q // y ≠ 1} = 10 := by
    have h1 : Fintype.card {y : Q // y = 1} = 1 := by
      rw [Fintype.card_eq_one_iff]
      exact ⟨⟨1, rfl⟩, fun z => Subtype.ext z.property⟩
    have hcompl := Fintype.card_subtype_compl (fun y : Q => y = 1)
    calc Nat.card {y : Q // y ≠ 1}
        = Fintype.card {y : Q // y ≠ 1} := Nat.card_eq_fintype_card
      _ = Fintype.card Q - Fintype.card {y : Q // y = 1} := hcompl
      _ = Fintype.card Q - 1 := by rw [h1]
      _ = Nat.card Q - 1 := by rw [← Nat.card_eq_fintype_card]
      _ = 11 - 1 := by rw [hcardQ]
      _ = 10 := by norm_num
  rwa [Nat.card_congr e]

private noncomputable def sylowOfOrderEleven
    (x : {g : PSL2F11 // orderOf g = 11}) : Sylow 11 PSL2F11 := by
  haveI : Fact (Nat.Prime 11) := ⟨by decide⟩
  have hord : orderOf x.1 = 11 := x.2
  have hc : Nat.card (Subgroup.zpowers x.1) = 11 := by rw [Nat.card_zpowers, hord]
  have hIP : IsPGroup 11 (Subgroup.zpowers x.1) :=
    IsPGroup.of_card (n := 1) (by rw [hc]; norm_num)
  have hix : (Subgroup.zpowers x.1).index = 60 := by
    have hmul := Subgroup.index_mul_card (Subgroup.zpowers x.1)
    rw [hc, card_G_nat] at hmul; omega
  have hnd : ¬(11 ∣ (Subgroup.zpowers x.1).index) := by rw [hix]; decide
  exact hIP.toSylow hnd

private theorem sylowOfOrderEleven_coe (x : {g : PSL2F11 // orderOf g = 11}) :
    (sylowOfOrderEleven x : Subgroup PSL2F11) = Subgroup.zpowers x.1 := by
  haveI : Fact (Nat.Prime 11) := ⟨by decide⟩
  simp only [sylowOfOrderEleven]
  exact IsPGroup.toSylow_coe _ _

private theorem card_sylow11_eq_twelve : Nat.card (Sylow 11 PSL2F11) = 12 := by
  classical
  haveI : Fact (Nat.Prime 11) := ⟨by decide⟩
  haveI : Fintype (Sylow 11 PSL2F11) := Fintype.ofFinite _
  have hcard11 : Fintype.card {x : PSL2F11 // orderOf x = 11} = 120 :=
    PSLCard.card_psl_order_eleven
  let e : {g : PSL2F11 // orderOf g = 11} ≃
      Σ Q : Sylow 11 PSL2F11, sylow11NonId Q := by
    refine ⟨?toFun, ?invFun, ?left_inv, ?right_inv⟩
    · intro x
      refine ⟨sylowOfOrderEleven x, ⟨x.1, ?mem, ?ne⟩⟩
      · have : x.1 ∈ Subgroup.zpowers x.1 := Subgroup.mem_zpowers x.1
        rwa [← sylowOfOrderEleven_coe x] at this
      · intro heq
        have hord1 : orderOf (1 : PSL2F11) = 11 := by convert x.2; exact heq.symm
        exact absurd hord1 (by simp)
    · intro ⟨Q, ⟨g, hg, hne⟩⟩
      exact ⟨g, orderOf_ne_one_of_mem_sylow11 Q ⟨g, hg⟩ hne⟩
    · intro x; rfl
    · intro ⟨Q, ⟨g, hg, hne⟩⟩
      have hordy : orderOf g = 11 :=
        orderOf_ne_one_of_mem_sylow11 Q ⟨g, hg⟩ hne
      have hle : Subgroup.zpowers g ≤ (Q : Subgroup PSL2F11) :=
        Subgroup.zpowers_le.mpr hg
      have hcard_z : Nat.card (Subgroup.zpowers g) = 11 := by
        rw [Nat.card_zpowers, hordy]
      have hcard_Q := card_sylow11 Q
      have heq_sub : Subgroup.zpowers g = (Q : Subgroup PSL2F11) :=
        Subgroup.eq_of_le_of_card_ge hle (by rw [hcard_Q, hcard_z])
      have hsy : (sylowOfOrderEleven ⟨g, hordy⟩ : Subgroup PSL2F11) =
          (Q : Subgroup PSL2F11) := by
        rw [sylowOfOrderEleven_coe, heq_sub]
      have hQeq : sylowOfOrderEleven ⟨g, hordy⟩ = Q := Sylow.ext hsy
      exact Sigma.subtype_ext hQeq rfl
  have hsum : Nat.card {g : PSL2F11 // orderOf g = 11} =
      Nat.card (Sylow 11 PSL2F11) * 10 := by
    have heq_card := Nat.card_congr e
    haveI : ∀ Q : Sylow 11 PSL2F11, Finite (sylow11NonId Q) := fun Q => by
      have h := card_sylow11NonId Q
      exact Nat.finite_of_card_ne_zero (by rw [h]; norm_num)
    have hsig : Nat.card (Σ Q : Sylow 11 PSL2F11, sylow11NonId Q) =
        ∑ Q : Sylow 11 PSL2F11, Nat.card (sylow11NonId Q) :=
      Nat.card_sigma
    calc Nat.card {g : PSL2F11 // orderOf g = 11}
        = Nat.card (Σ Q : Sylow 11 PSL2F11, sylow11NonId Q) := heq_card
      _ = ∑ Q : Sylow 11 PSL2F11, Nat.card (sylow11NonId Q) := hsig
      _ = ∑ _Q : Sylow 11 PSL2F11, (10 : ℕ) :=
          Finset.sum_congr rfl fun Q _ => card_sylow11NonId Q
      _ = Fintype.card (Sylow 11 PSL2F11) * 10 := by
          rw [Finset.sum_const, Finset.card_univ, smul_eq_mul, mul_comm]
      _ = Nat.card (Sylow 11 PSL2F11) * 10 := by rw [← Nat.card_eq_fintype_card]
  have : Nat.card (Sylow 11 PSL2F11) * 10 = 120 := by
    rw [← hsum, Nat.card_eq_fintype_card, hcard11]
  omega

/-! ### Fintype on non-id + conjugacy + weighted 180 -/

private noncomputable instance (Q : Sylow 11 PSL2F11) : Fintype (sylow11NonId Q) := by
  classical
  exact Subtype.fintype _

/-- Reindex a filtered finite sum through its predicate subtype.  This small
equivalence avoids the large elaboration term produced by `Finset.sum_nbij`
on the concrete quotient-group types below. -/
private theorem sum_filter_eq_subtype
    {A M : Type} [Fintype A] [DecidableEq A] [AddCommMonoid M]
    (p : A → Prop) [DecidablePred p] (f : A → M) :
    ∑ x ∈ (Finset.univ : Finset A).filter p, f x =
      ∑ x : {x : A // p x}, f x := by
  classical
  let e : {x : A // p x} ≃
      {x // x ∈ (Finset.univ : Finset A).filter p} :=
    { toFun := fun x ↦ ⟨x.1, by simp [x.2]⟩
      invFun := fun x ↦ ⟨x.1, (Finset.mem_filter.mp x.2).2⟩
      left_inv := fun x ↦ Subtype.ext rfl
      right_inv := fun x ↦ Subtype.ext rfl }
  symm
  calc
    (∑ x : {x : A // p x}, f x) =
        ∑ x : {x // x ∈ (Finset.univ : Finset A).filter p}, f x :=
      Fintype.sum_equiv e _ _ (fun _ ↦ rfl)
    _ = ∑ x ∈ (Finset.univ : Finset A).filter p, f x :=
      Finset.sum_attach _ _

/-- Non-id sum on ⟨tGen⟩ = −15. -/
private theorem sum_chiLambda2_sylow_tGen_nonId :
    (∑ y : sylow11NonId sylow_tGen, chiLambda2 y.1) = (-15 : k) := by
  classical
  have hcoe := sylow_tGen_coe
  have h1 :
      (∑ y : sylow11NonId sylow_tGen, chiLambda2 y.1) =
        ∑ g ∈ Finset.univ.filter (fun g : PSL2F11 =>
          g ∈ (sylow_tGen : Set PSL2F11) ∧ g ≠ 1), chiLambda2 g := by
    exact (sum_filter_eq_subtype
      (fun g : PSL2F11 ↦ g ∈ (sylow_tGen : Set PSL2F11) ∧ g ≠ 1)
      chiLambda2).symm
  have h2 :
      Finset.univ.filter (fun g : PSL2F11 =>
          g ∈ (sylow_tGen : Set PSL2F11) ∧ g ≠ 1) =
        Finset.univ.filter (fun g : PSL2F11 =>
          g ∈ Subgroup.zpowers tGen ∧ g ≠ 1) := by
    apply Finset.filter_congr
    intro g _
    constructor
    · intro ⟨hg, hne⟩
      refine ⟨?_, hne⟩
      change g ∈ (sylow_tGen : Subgroup PSL2F11) at hg
      rwa [hcoe] at hg
    · intro ⟨hg, hne⟩
      refine ⟨?_, hne⟩
      change g ∈ (sylow_tGen : Subgroup PSL2F11)
      rwa [hcoe]
  rw [h1, h2, sum_chiLambda2_zpowers_tGen_ne_one]

/-- Every Sylow non-id sum is −15 by conjugacy. -/
theorem sum_chiLambda2_sylow11NonId (Q : Sylow 11 PSL2F11) :
    (∑ y : sylow11NonId Q, chiLambda2 y.1) = (-15 : k) := by
  classical
  haveI : Fact (Nat.Prime 11) := ⟨by decide⟩
  obtain ⟨c, hc⟩ := MulAction.exists_smul_eq (M := PSL2F11) sylow_tGen Q
  let φ : sylow11NonId sylow_tGen → sylow11NonId Q := fun y => by
    refine ⟨c * y.1 * c⁻¹, ?_, ?_⟩
    · have hy : y.1 ∈ (sylow_tGen : Set PSL2F11) := y.2.1
      have hset : c * y.1 * c⁻¹ ∈
          ((c • sylow_tGen : Sylow 11 PSL2F11) : Set PSL2F11) := by
        rw [Sylow.coe_smul]
        exact Set.mem_smul_set.mpr ⟨y.1, hy, rfl⟩
      rwa [hc] at hset
    · intro h1
      have : y.1 = 1 := by
        have := congrArg (fun z => c⁻¹ * z * c) h1
        simpa [mul_assoc, inv_mul_cancel_left, mul_inv_cancel_right] using this
      exact y.2.2 this
  have hφ_inj : Function.Injective φ := by
    intro a b hab
    apply Subtype.ext
    have hval : c * a.1 * c⁻¹ = c * b.1 * c⁻¹ := congrArg Subtype.val hab
    have := congrArg (fun z => c⁻¹ * z * c) hval
    simpa [mul_assoc, inv_mul_cancel_left, mul_inv_cancel_right] using this
  have hφ_card : Fintype.card (sylow11NonId sylow_tGen) =
      Fintype.card (sylow11NonId Q) := by
    rw [← Nat.card_eq_fintype_card, ← Nat.card_eq_fintype_card,
      card_sylow11NonId, card_sylow11NonId]
  have hφ_bi : Function.Bijective φ :=
    (Fintype.bijective_iff_injective_and_card φ).2 ⟨hφ_inj, hφ_card⟩
  let e := Equiv.ofBijective φ hφ_bi
  have hsum := Fintype.sum_equiv e
    (fun y => chiLambda2 y.1) (fun z => chiLambda2 z.1)
    (fun y => by
      change chiLambda2 y.1 = chiLambda2 (c * y.1 * c⁻¹)
      exact chiLambda2_isConj (isConj_iff.mpr ⟨c, rfl⟩))
  exact hsum.symm.trans sum_chiLambda2_sylow_tGen_nonId

/-- ∑_{ord g = 11} χ_Λ²(g) = −180. -/
theorem sum_chiLambda2_order_eleven :
    (∑ g : {g : PSL2F11 // orderOf g = 11}, chiLambda2 g.1) = (-180 : k) := by
  classical
  haveI : Fact (Nat.Prime 11) := ⟨by decide⟩
  haveI : Fintype (Sylow 11 PSL2F11) := Fintype.ofFinite _
  -- Reuse the Σ-equiv from card_sylow11_eq_twelve
  let e : {g : PSL2F11 // orderOf g = 11} ≃
      Σ Q : Sylow 11 PSL2F11, sylow11NonId Q := by
    refine ⟨?toFun, ?invFun, ?left_inv, ?right_inv⟩
    · intro x
      refine ⟨sylowOfOrderEleven x, ⟨x.1, ?mem, ?ne⟩⟩
      · have : x.1 ∈ Subgroup.zpowers x.1 := Subgroup.mem_zpowers x.1
        rwa [← sylowOfOrderEleven_coe x] at this
      · intro heq
        have hord1 : orderOf (1 : PSL2F11) = 11 := by convert x.2; exact heq.symm
        exact absurd hord1 (by simp)
    · intro ⟨Q, ⟨g, hg, hne⟩⟩
      exact ⟨g, orderOf_ne_one_of_mem_sylow11 Q ⟨g, hg⟩ hne⟩
    · intro x; rfl
    · intro ⟨Q, ⟨g, hg, hne⟩⟩
      have hordy : orderOf g = 11 :=
        orderOf_ne_one_of_mem_sylow11 Q ⟨g, hg⟩ hne
      have hle : Subgroup.zpowers g ≤ (Q : Subgroup PSL2F11) :=
        Subgroup.zpowers_le.mpr hg
      have hcard_z : Nat.card (Subgroup.zpowers g) = 11 := by
        rw [Nat.card_zpowers, hordy]
      have hcard_Q := card_sylow11 Q
      have heq_sub : Subgroup.zpowers g = (Q : Subgroup PSL2F11) :=
        Subgroup.eq_of_le_of_card_ge hle (by rw [hcard_Q, hcard_z])
      have hsy : (sylowOfOrderEleven ⟨g, hordy⟩ : Subgroup PSL2F11) =
          (Q : Subgroup PSL2F11) := by
        rw [sylowOfOrderEleven_coe, heq_sub]
      have hQeq : sylowOfOrderEleven ⟨g, hordy⟩ = Q := Sylow.ext hsy
      exact Sigma.subtype_ext hQeq rfl
  have hsum :
      (∑ g : {g : PSL2F11 // orderOf g = 11}, chiLambda2 g.1) =
        ∑ Q : Sylow 11 PSL2F11, ∑ y : sylow11NonId Q, chiLambda2 y.1 := by
    have he := Fintype.sum_equiv e (fun g => chiLambda2 g.1)
      (fun p => chiLambda2 p.2.1) (fun _ => rfl)
    rw [he, Fintype.sum_sigma]
  rw [hsum]
  have hQ : ∀ Q, (∑ y : sylow11NonId Q, chiLambda2 y.1) = (-15 : k) :=
    sum_chiLambda2_sylow11NonId
  simp only [hQ, Finset.sum_const, nsmul_eq_mul]
  have hcard : ((Finset.univ : Finset (Sylow 11 PSL2F11)).card : k) = 12 := by
    change (Fintype.card (Sylow 11 PSL2F11) : k) = 12
    rw [← Nat.card_eq_fintype_card, card_sylow11_eq_twelve]
    norm_num
  rw [hcard]; norm_num

/-- Order-11 weighted contribution: ∑ χ₁₀' χ_Λ² = 180. -/
theorem sum_chi_chiLambda2_order_eleven :
    (∑ g : {g : PSL2F11 // orderOf g = 11}, chi10' g.1 * chiLambda2 g.1) =
      (180 : k) := by
  classical
  have hval : ∀ g : {g : PSL2F11 // orderOf g = 11},
      chi10' g.1 * chiLambda2 g.1 = -(chiLambda2 g.1) := by
    intro g
    have ho : orderOf g.1 = 11 := g.2
    have hc : chi10' g.1 = (-1 : k) := by simp [chi10', ho]
    rw [hc]; ring
  rw [Finset.sum_congr rfl fun g _ => hval g, Finset.sum_neg_distrib,
    sum_chiLambda2_order_eleven]
  norm_num

/-! ## Full weighted sum = 660 and finrank Msub = 10 -/

/-- Element orders in `PSL₂(𝔽₁₁)` are exactly `{1,2,3,5,6,11}`. -/
theorem orderOf_eq_spectrum (g : PSL2F11) :
    orderOf g = 1 ∨ orderOf g = 2 ∨ orderOf g = 3 ∨
      orderOf g = 5 ∨ orderOf g = 6 ∨ orderOf g = 11 := by
  obtain ⟨A, hA⟩ := QuotientGroup.mk_surjective (s := Subgroup.center WeilRepSL2.SLG) g
  have := PSLCard.orderOf_mk_eq_pslOrd A
  rw [← hA, this]
  exact PSLCard.pslOrd_eq_spectrum A

private theorem sum_over_order_fiber (n : ℕ) :
    (∑ g ∈ Finset.univ.filter (fun g : PSL2F11 => orderOf g = n),
        chi10' g * chiLambda2 g) =
      ∑ g : {g : PSL2F11 // orderOf g = n}, chi10' g.1 * chiLambda2 g.1 := by
  classical
  exact sum_filter_eq_subtype (fun g : PSL2F11 ↦ orderOf g = n)
    (fun g ↦ chi10' g * chiLambda2 g)

private theorem sum_order_one_fiber :
    (∑ g : {g : PSL2F11 // orderOf g = 1}, chi10' g.1 * chiLambda2 g.1) =
      chi10' (1 : PSL2F11) * chiLambda2 (1 : PSL2F11) := by
  classical
  have huniq : ∀ g : {g : PSL2F11 // orderOf g = 1}, g = ⟨1, orderOf_one⟩ := fun g =>
    Subtype.ext (orderOf_eq_one_iff.mp g.2)
  haveI : Unique {g : PSL2F11 // orderOf g = 1} :=
    ⟨⟨⟨1, orderOf_one⟩⟩, fun g => huniq g⟩
  rw [Fintype.sum_unique]
  -- default = ⟨1, orderOf_one⟩
  change chi10' (default : {g : PSL2F11 // orderOf g = 1}).1 * chiLambda2 _ =
    chi10' (1 : PSL2F11) * chiLambda2 1
  have hdef : (default : {g : PSL2F11 // orderOf g = 1}) = ⟨1, orderOf_one⟩ :=
    Unique.default_eq _
  rw [hdef]

/-- Partition of the group sum by element order. -/
theorem sum_chi_chiLambda2_by_orders :
    (∑ g : PSL2F11, chi10' g * chiLambda2 g) =
      chi10' (1 : PSL2F11) * chiLambda2 (1 : PSL2F11) +
      (∑ g : {g : PSL2F11 // orderOf g = 2}, chi10' g.1 * chiLambda2 g.1) +
      (∑ g : {g : PSL2F11 // orderOf g = 3}, chi10' g.1 * chiLambda2 g.1) +
      (∑ g : {g : PSL2F11 // orderOf g = 5}, chi10' g.1 * chiLambda2 g.1) +
      (∑ g : {g : PSL2F11 // orderOf g = 6}, chi10' g.1 * chiLambda2 g.1) +
      (∑ g : {g : PSL2F11 // orderOf g = 11}, chi10' g.1 * chiLambda2 g.1) := by
  classical
  set t : Finset ℕ := {1, 2, 3, 5, 6, 11}
  have hsup : ∀ g ∈ (Finset.univ : Finset PSL2F11), orderOf g ∈ t := by
    intro g _
    rcases orderOf_eq_spectrum g with h | h | h | h | h | h <;>
      (simp only [t, Finset.mem_insert, Finset.mem_singleton]; omega)
  -- ∑_n∈t ∑_{ord=n} f = ∑_g f
  have hfib :
      (∑ n ∈ t, ∑ g ∈ Finset.univ.filter (fun g : PSL2F11 => orderOf g = n),
          chi10' g * chiLambda2 g) =
        ∑ g : PSL2F11, chi10' g * chiLambda2 g :=
    Finset.sum_fiberwise_of_maps_to hsup (fun g => chi10' g * chiLambda2 g)
  calc (∑ g : PSL2F11, chi10' g * chiLambda2 g)
      = ∑ n ∈ t, ∑ g ∈ Finset.univ.filter (fun g : PSL2F11 => orderOf g = n),
          chi10' g * chiLambda2 g := hfib.symm
    _ = ∑ n ∈ t, ∑ g : {g : PSL2F11 // orderOf g = n},
          chi10' g.1 * chiLambda2 g.1 := by
        refine Finset.sum_congr rfl fun n _ => sum_over_order_fiber n
    _ = (∑ g : {g : PSL2F11 // orderOf g = 1}, chi10' g.1 * chiLambda2 g.1) +
          (∑ g : {g : PSL2F11 // orderOf g = 2}, chi10' g.1 * chiLambda2 g.1) +
          (∑ g : {g : PSL2F11 // orderOf g = 3}, chi10' g.1 * chiLambda2 g.1) +
          (∑ g : {g : PSL2F11 // orderOf g = 5}, chi10' g.1 * chiLambda2 g.1) +
          (∑ g : {g : PSL2F11 // orderOf g = 6}, chi10' g.1 * chiLambda2 g.1) +
          (∑ g : {g : PSL2F11 // orderOf g = 11}, chi10' g.1 * chiLambda2 g.1) := by
        simp only [t]
        have h1 : (1 : ℕ) ∉ ({2, 3, 5, 6, 11} : Finset ℕ) := by decide
        have h2 : (2 : ℕ) ∉ ({3, 5, 6, 11} : Finset ℕ) := by decide
        have h3 : (3 : ℕ) ∉ ({5, 6, 11} : Finset ℕ) := by decide
        have h5 : (5 : ℕ) ∉ ({6, 11} : Finset ℕ) := by decide
        have h6 : (6 : ℕ) ∉ ({11} : Finset ℕ) := by decide
        rw [Finset.sum_insert h1, Finset.sum_insert h2, Finset.sum_insert h3,
          Finset.sum_insert h5, Finset.sum_insert h6, Finset.sum_singleton]
        ring
    _ = chi10' (1 : PSL2F11) * chiLambda2 (1 : PSL2F11) +
          (∑ g : {g : PSL2F11 // orderOf g = 2}, chi10' g.1 * chiLambda2 g.1) +
          (∑ g : {g : PSL2F11 // orderOf g = 3}, chi10' g.1 * chiLambda2 g.1) +
          (∑ g : {g : PSL2F11 // orderOf g = 5}, chi10' g.1 * chiLambda2 g.1) +
          (∑ g : {g : PSL2F11 // orderOf g = 6}, chi10' g.1 * chiLambda2 g.1) +
          (∑ g : {g : PSL2F11 // orderOf g = 11}, chi10' g.1 * chiLambda2 g.1) := by
        rw [sum_order_one_fiber]

/-- Full weighted ambient character sum equals 660. -/
theorem sum_chi_chiLambda2_eq_sixsixty :
    (∑ g : PSL2F11, chi10' g * chiLambda2 g) = (660 : k) := by
  rw [sum_chi_chiLambda2_by_orders]
  rw [sum_chi_chiLambda2_order_one, sum_chi_chiLambda2_order_two,
    sum_chi_chiLambda2_order_three, sum_chi_chiLambda2_order_five,
    sum_chi_chiLambda2_order_six, sum_chi_chiLambda2_order_eleven]
  norm_num

/-- Unconditional: `finrank Msub = 10`. -/
public theorem finrank_Msub_eq_ten :
    Module.finrank k Msub = 10 :=
  finrank_Msub_eq_ten_of_sum_chi_chiLambda2 sum_chi_chiLambda2_eq_sixsixty

#print axioms sum_chi_chiLambda2_order_eleven
#print axioms sum_chi_chiLambda2_eq_sixsixty
#print axioms finrank_Msub_eq_ten

/-! ## The norm of the ambient character

`∑_{g} χ_Λ²(g) · χ_Λ²(g⁻¹) = 1320 = 2·660`.  This says the commutant of `Λ²U`
is two-dimensional, i.e. that `Λ²U` splits into exactly two non-isomorphic
irreducibles, and it is what makes `Msub` *the* ten-dimensional
`PSL(2,11)`-stable subspace of `Λ²U` (`MsubUnique`).

Class by class the sum is `225 + 495 + 0 + 0 + 0 + 600`.  Orders 1, 2, 3 and 6
come from `GeometricV14Carrier`.  The two values proved here are the ones the
weighted sum `∑ χ₁₀' χ_Λ²` never needed:

* `χ_Λ²` on **order-5** elements is `0` — the weighted sum did not need it
  because `χ₁₀'` vanishes there.  An order-5 element is conjugate to a
  *diagonal* one, and a diagonal `SL₂` element acts on `U` as `χ₂(t)` times a
  permutation of the six `evalEven` coordinates.  That permutation fixes only
  the coordinate `0`, so the trace is `χ₂(t) = 1`, for `t` and for `t²`, and
  Newton gives `½(1 − 1) = 0`.
* the product `χ_Λ²(g)·χ_Λ²(g⁻¹)` on **order-11** elements is the constant `5`:
  `χ_Λ²(t^n) = (−3 − χ₂(n)γ)/2` with `γ² = −11` and `χ₂(−1) = −1`, so the two
  factors are conjugate over `ℚ` and their product is `(9 + 11)/4`.
-/

/-! ### Order 11, pointwise -/

private theorem isConj_inv_of_isConj {a b : PSL2F11} (h : IsConj a b) :
    IsConj a⁻¹ b⁻¹ := by
  obtain ⟨c, hc⟩ := isConj_iff.mp h
  refine isConj_iff.mpr ⟨c, ?_⟩
  rw [← hc, mul_inv_rev, mul_inv_rev, inv_inv, mul_assoc]

private theorem χ₂_neg (n : ZMod 11) : χ₂ (-n) = -χ₂ n := by
  have h : (-n) = (-1 : ZMod 11) * n := by ring
  rw [h, map_mul, χ₂_neg_one]
  ring

/-- On a pair of mutually inverse order-11 powers the product of characters is
the constant `5`: the two Gauss-sum terms are conjugate. -/
private theorem chiLambda2_tGen_pow_mul (n m : ℕ) (hn : (n : ZMod 11) ≠ 0)
    (hm : (m : ZMod 11) = -(n : ZMod 11)) :
    chiLambda2 (tGen ^ n) * chiLambda2 (tGen ^ m) = (5 : k) := by
  have hm0 : (m : ZMod 11) ≠ 0 := by
    rw [hm]; simpa using hn
  rw [chiLambda2_tGen_pow_eq n hn, chiLambda2_tGen_pow_eq m hm0, hm, χ₂_neg]
  set c : k := χ₂ (n : ZMod 11) * gauss with hc
  have hcsq : c * c = (-11 : k) := by
    have h1 : c * c = (χ₂ (n : ZMod 11) * χ₂ (n : ZMod 11)) * gauss ^ 2 := by
      rw [hc]; ring
    rw [h1, χ₂_sq_one hn, gauss_sq, one_mul]
  have hstep :
      (-3 - χ₂ (n : ZMod 11) * gauss) * (2 : k)⁻¹ *
          ((-3 - -χ₂ (n : ZMod 11) * gauss) * (2 : k)⁻¹) =
        (9 - c * c) * ((2 : k)⁻¹ * (2 : k)⁻¹) := by
    rw [hc]; ring
  rw [hstep, hcsq]
  have h2 : (2 : k) ≠ 0 := by norm_num
  field_simp
  norm_num

/-- `tGen` is the class of the `PSLCard` unipotent generator. -/
private theorem tGen_eq_mk_Tmat :
    tGen = (QuotientGroup.mk PSLCard.Tmat : PSL2F11) := rfl

private theorem mk_Tmat_pow (n : ℕ) :
    (QuotientGroup.mk (PSLCard.Tmat ^ n) : PSL2F11) = tGen ^ n := by
  rw [tGen_eq_mk_Tmat, ← QuotientGroup.mk_pow]

/-- **`χ_Λ²(g) · χ_Λ²(g⁻¹) = 5` on every order-11 element.** -/
public theorem chiLambda2_mul_inv_of_order_eleven {g : PSL2F11} (hg : orderOf g = 11) :
    chiLambda2 g * chiLambda2 g⁻¹ = (5 : k) := by
  have key : ∀ n m : ℕ, (n : ZMod 11) ≠ 0 → ((m : ℕ) : ZMod 11) = -(n : ZMod 11) →
      (tGen ^ n)⁻¹ = tGen ^ m → IsConj (tGen ^ n) g →
      chiLambda2 g * chiLambda2 g⁻¹ = (5 : k) := by
    intro n m hn hm hinv hconj
    rw [← chiLambda2_isConj hconj, ← chiLambda2_isConj (isConj_inv_of_isConj hconj),
      hinv]
    exact chiLambda2_tGen_pow_mul n m hn hm
  have h11 : tGen ^ 11 = 1 := tGen_pow_eleven
  rcases PSLCard.isConj_Tmat_or_pow_of_order_eleven hg with h | h
  · refine key 1 10 (by decide) (by decide) ?_ ?_
    · rw [pow_one]
      refine (inv_eq_of_mul_eq_one_right ?_)
      calc tGen * tGen ^ 10 = tGen ^ 11 := by rw [← pow_succ']
        _ = 1 := h11
    · rw [pow_one, tGen_eq_mk_Tmat]; exact h
  · refine key 2 9 (by decide) (by decide) ?_ ?_
    · refine (inv_eq_of_mul_eq_one_right ?_)
      calc tGen ^ 2 * tGen ^ 9 = tGen ^ 11 := by rw [← pow_add]
        _ = 1 := h11
    · rw [← mk_Tmat_pow 2]; exact h

/-! ### Order 5: a diagonal element acts by a scaled permutation of coordinates -/

section OrderFive

open Matrix

/-- `c` times the permutation matrix of `σ`, acting on `Fin 6 → k`. -/
private def scaledPerm (c : k) (σ : Fin 6 → Fin 6) : Matrix (Fin 6) (Fin 6) k :=
  fun j i => if i = σ j then c else 0

private theorem toLin'_scaledPerm (c : k) (σ : Fin 6 → Fin 6) (v : Fin 6 → k)
    (j : Fin 6) :
    Matrix.toLin' (scaledPerm c σ) v j = c * v (σ j) := by
  classical
  have hexp : Matrix.toLin' (scaledPerm c σ) v j =
      ∑ i : Fin 6, (if i = σ j then c else 0) * v i := rfl
  rw [hexp, Finset.sum_eq_single (σ j)]
  · rw [if_pos rfl]
  · intro b _ hb
    rw [if_neg hb, zero_mul]
  · intro h
    exact absurd (Finset.mem_univ (σ j)) h

private theorem trace_scaledPerm (c : k) (σ : Fin 6 → Fin 6) :
    LinearMap.trace k (Fin 6 → k) (Matrix.toLin' (scaledPerm c σ)) =
      ∑ j : Fin 6, (if j = σ j then c else 0) := by
  rw [Matrix.trace_toLin'_eq]
  rfl

/-- On a lower-left-zero, upper-right-zero `SL₂` element the Weil action of `U`
is `f ↦ χ₂(a)·f(a·−)`: the Bruhat factorisation degenerates to `Dfull a`. -/
private theorem weilU_apply_of_diag (A : WeilRepSL2.SLG)
    (hc : WeilRepSL2.ec A = 0) (hb : WeilRepSL2.eb A = 0)
    (f : GeometricV14Carrier.U) (x : ZMod 11) :
    (WeilHom.weilUHom A f).1 x =
      χ₂ (WeilRepSL2.ea A) * f.1 (WeilRepSL2.ea A * x) := by
  show WeilRepSL2.weilFun A f.1 x = _
  dsimp only [WeilRepSL2.weilFun]
  rw [dif_pos hc]
  dsimp only [WeilRepSL2.borelFun]
  rw [LinearMap.comp_apply, hb, zero_mul, WeilRepSL2.Nfull_zero, LinearMap.id_apply]
  rfl

/-- **Trace of a diagonal Weil operator.**  If multiplication by `a = ea A`
permutes the six `evalEven` coordinates by `σ` (up to the sign that evenness
absorbs) and `σ` fixes only the coordinate `0`, then `tr_U ρ(A) = χ₂(a)`. -/
private theorem trace_weilU_of_diag (A : WeilRepSL2.SLG)
    (hc : WeilRepSL2.ec A = 0) (hb : WeilRepSL2.eb A = 0)
    (σ : Fin 6 → Fin 6)
    (hσ : ∀ j : Fin 6,
      WeilRepSL2.ea A * ((j.val : ℕ) : ZMod 11) = (((σ j).val : ℕ) : ZMod 11) ∨
        WeilRepSL2.ea A * ((j.val : ℕ) : ZMod 11) = -((((σ j).val : ℕ)) : ZMod 11))
    (hfix : ∀ j : Fin 6, σ j = j ↔ j = 0) :
    LinearMap.trace k GeometricV14Carrier.U (WeilHom.weilUHom A) =
      χ₂ (WeilRepSL2.ea A) := by
  classical
  have hsv : ∀ (v : Fin 6 → k) (i : Fin 6),
      (evalEvenEquiv.symm v).1 ((i.val : ℕ) : ZMod 11) = v i := by
    intro v i
    have h : GeometricFanoCarrier.evalEven (evalEvenEquiv.symm v) = v :=
      evalEvenEquiv.apply_symm_apply v
    calc (evalEvenEquiv.symm v).1 ((i.val : ℕ) : ZMod 11)
        = GeometricFanoCarrier.evalEven (evalEvenEquiv.symm v) i := rfl
      _ = v i := by rw [h]
  have hconj : evalEvenEquiv.conj (WeilHom.weilUHom A) =
      Matrix.toLin' (scaledPerm (χ₂ (WeilRepSL2.ea A)) σ) := by
    apply LinearMap.ext
    intro v
    funext j
    rw [toLin'_scaledPerm]
    have hL : (evalEvenEquiv.conj (WeilHom.weilUHom A)) v j =
        (WeilHom.weilUHom A (evalEvenEquiv.symm v)).1 ((j.val : ℕ) : ZMod 11) := rfl
    rw [hL, weilU_apply_of_diag A hc hb]
    rcases hσ j with h | h
    · rw [h, hsv]
    · rw [h, (evalEvenEquiv.symm v).2 ((((σ j).val : ℕ)) : ZMod 11), hsv]
  have htr := (LinearMap.trace_conj' (WeilHom.weilUHom A) evalEvenEquiv).symm
  rw [htr, hconj, trace_scaledPerm]
  have hcond : ∀ j : Fin 6, (j = σ j) = (j = 0) := by
    intro j
    exact propext ⟨fun h => (hfix j).mp h.symm, fun h => ((hfix j).mpr h).symm⟩
  simp only [hcond]
  simp

/-! #### The three diagonal representatives -/

/-- `diag(9, 5)`: an order-5 element of the split torus. -/
private def dm9 : WeilRepSL2.SLG :=
  ⟨!![9, 0; 0, 5], by rw [Matrix.det_fin_two_of]; decide⟩

/-- `dm9² = diag(4, 3)`. -/
private def dm4 : WeilRepSL2.SLG :=
  ⟨!![4, 0; 0, 3], by rw [Matrix.det_fin_two_of]; decide⟩

/-- `dm9⁴ = diag(5, 9)`. -/
private def dm5 : WeilRepSL2.SLG :=
  ⟨!![5, 0; 0, 9], by rw [Matrix.det_fin_two_of]; decide⟩

/-- Conjugates `el5` into the split torus: `cm5 · el5 · cm5⁻¹ = dm9`. -/
private def cm5 : WeilRepSL2.SLG :=
  ⟨!![3, 5; 10, 6], by rw [Matrix.det_fin_two_of]; decide⟩

private theorem trace_weilU_dm9 :
    LinearMap.trace k GeometricV14Carrier.U (WeilHom.weilUHom dm9) = 1 := by
  rw [trace_weilU_of_diag dm9 (by decide) (by decide)
      ![0, 2, 4, 5, 3, 1] (by decide) (by decide)]
  rw [show WeilRepSL2.ea dm9 = 3 * 3 from by decide, map_mul]
  exact χ₂_sq_one (by decide)

private theorem trace_weilU_dm4 :
    LinearMap.trace k GeometricV14Carrier.U (WeilHom.weilUHom dm4) = 1 := by
  rw [trace_weilU_of_diag dm4 (by decide) (by decide)
      ![0, 4, 3, 1, 5, 2] (by decide) (by decide)]
  rw [show WeilRepSL2.ea dm4 = 2 * 2 from by decide, map_mul]
  exact χ₂_sq_one (by decide)

private theorem trace_weilU_dm5 :
    LinearMap.trace k GeometricV14Carrier.U (WeilHom.weilUHom dm5) = 1 := by
  rw [trace_weilU_of_diag dm5 (by decide) (by decide)
      ![0, 5, 1, 4, 2, 3] (by decide) (by decide)]
  rw [show WeilRepSL2.ea dm5 = 4 * 4 from by decide, map_mul]
  exact χ₂_sq_one (by decide)

private theorem dm9_sq : dm9 * dm9 = dm4 := by decide
private theorem dm4_sq : dm4 * dm4 = dm5 := by decide

/-! #### Newton on an `SL₂` element -/

private theorem chiLambda2_mk_sl (A : WeilRepSL2.SLG) :
    chiLambda2 (QuotientGroup.mk A) =
      (2 : k)⁻¹ *
        ((LinearMap.trace k GeometricV14Carrier.U (WeilHom.weilUHom A)) ^ 2 -
          LinearMap.trace k GeometricV14Carrier.U (WeilHom.weilUHom (A * A))) := by
  dsimp [chiLambda2]
  have h1 : ambientAct (QuotientGroup.mk A) =
      exteriorPower.map (R := k) (n := 2) (WeilHom.weilUHom A) := by
    dsimp only [ambientAct]
    rw [GeometricFanoCarrier.pslLambda2_mk A]
    rfl
  have hmul : WeilHom.weilUHom A ∘ₗ WeilHom.weilUHom A =
      WeilHom.weilUHom (A * A) := by
    rw [map_mul]; rfl
  rw [h1, trace_exterior_newton, hmul]

private theorem chiLambda2_mk_dm9 :
    chiLambda2 (QuotientGroup.mk dm9 : PSL2F11) = 0 := by
  rw [chiLambda2_mk_sl dm9, trace_weilU_dm9, dm9_sq, trace_weilU_dm4]
  norm_num

private theorem chiLambda2_mk_dm4 :
    chiLambda2 (QuotientGroup.mk dm4 : PSL2F11) = 0 := by
  rw [chiLambda2_mk_sl dm4, trace_weilU_dm4, dm4_sq, trace_weilU_dm5]
  norm_num

/-! #### `el5` is conjugate into the split torus -/

private theorem cm5_mul_el5 : cm5 * PSLCard.el5 = dm9 * cm5 := by decide

private theorem conj_el5 : cm5 * PSLCard.el5 * cm5⁻¹ = dm9 := by
  rw [cm5_mul_el5, mul_assoc, mul_inv_cancel, mul_one]

private theorem conj_el5_sq : cm5 * PSLCard.el5 ^ 2 * cm5⁻¹ = dm4 := by
  have h : cm5 * PSLCard.el5 ^ 2 * cm5⁻¹ =
      (cm5 * PSLCard.el5 * cm5⁻¹) * (cm5 * PSLCard.el5 * cm5⁻¹) := by
    rw [sq]; group
  rw [h, conj_el5, dm9_sq]

private theorem isConj_mk_el5_dm9 :
    IsConj (QuotientGroup.mk PSLCard.el5 : PSL2F11) (QuotientGroup.mk dm9) := by
  refine isConj_iff.mpr ⟨QuotientGroup.mk cm5, ?_⟩
  rw [← QuotientGroup.mk_inv, ← QuotientGroup.mk_mul, ← QuotientGroup.mk_mul,
    conj_el5]

private theorem isConj_mk_el5_sq_dm4 :
    IsConj (QuotientGroup.mk (PSLCard.el5 ^ 2) : PSL2F11) (QuotientGroup.mk dm4) := by
  refine isConj_iff.mpr ⟨QuotientGroup.mk cm5, ?_⟩
  rw [← QuotientGroup.mk_inv, ← QuotientGroup.mk_mul, ← QuotientGroup.mk_mul,
    conj_el5_sq]

/-- **`χ_Λ² = 0` on every order-5 element.**  This is the value the weighted sum
`∑ χ₁₀'·χ_Λ² = 660` never needed, because `χ₁₀'` vanishes on the two order-5
classes; the quadratic sum has no such weight. -/
public theorem chiLambda2_eq_zero_of_order_five {g : PSL2F11} (hg : orderOf g = 5) :
    chiLambda2 g = 0 := by
  rcases PSLCard.isConj_el5_or_pow_of_order_five hg with h | h
  · rw [← chiLambda2_isConj h, chiLambda2_isConj isConj_mk_el5_dm9, chiLambda2_mk_dm9]
  · rw [← chiLambda2_isConj h, chiLambda2_isConj isConj_mk_el5_sq_dm4,
      chiLambda2_mk_dm4]

end OrderFive

/-! ### The norm sum, class by class

| class | size | `χ_Λ²` | `χ(g)χ(g⁻¹)` | contribution |
|---|---:|---|---:|---:|
| 1A | 1 | 15 | 225 | 225 |
| 2A | 55 | 3 | 9 | 495 |
| 3A | 110 | 0 | 0 | 0 |
| 5A, 5B | 132+132 | 0 | 0 | 0 |
| 6A | 110 | 0 | 0 | 0 |
| 11A, 11B | 60+60 | `(-3 ± √-11)/2` | 5 | 600 |
|  |  |  |  | **1320** |
-/

/-- The summand of the character norm, named so that the partition below can be
rewritten without leaving beta-redexes behind. -/
private noncomputable def chiNorm (g : PSL2F11) : k := chiLambda2 g * chiLambda2 g⁻¹

private theorem sum_over_order_fiber_gen (f : PSL2F11 → k) (n : ℕ) :
    (∑ g ∈ Finset.univ.filter (fun g : PSL2F11 => orderOf g = n), f g) =
      ∑ g : {g : PSL2F11 // orderOf g = n}, f g.1 := by
  classical
  exact sum_filter_eq_subtype (fun g : PSL2F11 ↦ orderOf g = n) f

private theorem sum_order_one_fiber_gen (f : PSL2F11 → k) :
    (∑ g : {g : PSL2F11 // orderOf g = 1}, f g.1) = f 1 := by
  classical
  have huniq : ∀ g : {g : PSL2F11 // orderOf g = 1}, g = ⟨1, orderOf_one⟩ := fun g =>
    Subtype.ext (orderOf_eq_one_iff.mp g.2)
  haveI : Unique {g : PSL2F11 // orderOf g = 1} :=
    ⟨⟨⟨1, orderOf_one⟩⟩, fun g => huniq g⟩
  rw [Fintype.sum_unique]
  change f (default : {g : PSL2F11 // orderOf g = 1}).1 = f 1
  have hdef : (default : {g : PSL2F11 // orderOf g = 1}) = ⟨1, orderOf_one⟩ :=
    Unique.default_eq _
  rw [hdef]

/-- Partition of a group sum by element order, for an arbitrary summand.  The
weighted sum `sum_chi_chiLambda2_by_orders` is the same statement specialised to
`χ₁₀'·χ_Λ²`; it is kept as it was. -/
private theorem sum_by_orders (f : PSL2F11 → k) :
    (∑ g : PSL2F11, f g) =
      f 1 +
      (∑ g : {g : PSL2F11 // orderOf g = 2}, f g.1) +
      (∑ g : {g : PSL2F11 // orderOf g = 3}, f g.1) +
      (∑ g : {g : PSL2F11 // orderOf g = 5}, f g.1) +
      (∑ g : {g : PSL2F11 // orderOf g = 6}, f g.1) +
      (∑ g : {g : PSL2F11 // orderOf g = 11}, f g.1) := by
  classical
  set t : Finset ℕ := {1, 2, 3, 5, 6, 11}
  have hsup : ∀ g ∈ (Finset.univ : Finset PSL2F11), orderOf g ∈ t := by
    intro g _
    rcases orderOf_eq_spectrum g with h | h | h | h | h | h <;>
      (simp only [t, Finset.mem_insert, Finset.mem_singleton]; omega)
  have hfib :
      (∑ n ∈ t, ∑ g ∈ Finset.univ.filter (fun g : PSL2F11 => orderOf g = n), f g) =
        ∑ g : PSL2F11, f g :=
    Finset.sum_fiberwise_of_maps_to hsup f
  calc (∑ g : PSL2F11, f g)
      = ∑ n ∈ t, ∑ g ∈ Finset.univ.filter (fun g : PSL2F11 => orderOf g = n), f g :=
        hfib.symm
    _ = ∑ n ∈ t, ∑ g : {g : PSL2F11 // orderOf g = n}, f g.1 :=
        Finset.sum_congr rfl fun n _ => sum_over_order_fiber_gen f n
    _ = (∑ g : {g : PSL2F11 // orderOf g = 1}, f g.1) +
          (∑ g : {g : PSL2F11 // orderOf g = 2}, f g.1) +
          (∑ g : {g : PSL2F11 // orderOf g = 3}, f g.1) +
          (∑ g : {g : PSL2F11 // orderOf g = 5}, f g.1) +
          (∑ g : {g : PSL2F11 // orderOf g = 6}, f g.1) +
          (∑ g : {g : PSL2F11 // orderOf g = 11}, f g.1) := by
        simp only [t]
        have h1 : (1 : ℕ) ∉ ({2, 3, 5, 6, 11} : Finset ℕ) := by decide
        have h2 : (2 : ℕ) ∉ ({3, 5, 6, 11} : Finset ℕ) := by decide
        have h3 : (3 : ℕ) ∉ ({5, 6, 11} : Finset ℕ) := by decide
        have h5 : (5 : ℕ) ∉ ({6, 11} : Finset ℕ) := by decide
        have h6 : (6 : ℕ) ∉ ({11} : Finset ℕ) := by decide
        rw [Finset.sum_insert h1, Finset.sum_insert h2, Finset.sum_insert h3,
          Finset.sum_insert h5, Finset.sum_insert h6, Finset.sum_singleton]
        ring
    _ = f 1 +
          (∑ g : {g : PSL2F11 // orderOf g = 2}, f g.1) +
          (∑ g : {g : PSL2F11 // orderOf g = 3}, f g.1) +
          (∑ g : {g : PSL2F11 // orderOf g = 5}, f g.1) +
          (∑ g : {g : PSL2F11 // orderOf g = 6}, f g.1) +
          (∑ g : {g : PSL2F11 // orderOf g = 11}, f g.1) := by
        rw [sum_order_one_fiber_gen]

private theorem chiNorm_one : chiNorm (1 : PSL2F11) = (225 : k) := by
  show chiLambda2 (1 : PSL2F11) * chiLambda2 (1 : PSL2F11)⁻¹ = (225 : k)
  rw [inv_one, chiLambda2_one]
  norm_num

private theorem sum_chiNorm_order_two :
    (∑ g : {g : PSL2F11 // orderOf g = 2}, chiNorm g.1) = (495 : k) := by
  classical
  have hcard : Fintype.card {g : PSL2F11 // orderOf g = 2} = 55 :=
    PSLCard.card_psl_order_two
  have hval : ∀ g : {g : PSL2F11 // orderOf g = 2}, chiNorm g.1 = (9 : k) := by
    intro g
    have ho : orderOf g.1 = 2 := g.2
    have hoi : orderOf g.1⁻¹ = 2 := by rw [orderOf_inv]; exact ho
    show chiLambda2 g.1 * chiLambda2 g.1⁻¹ = (9 : k)
    rw [chiLambda2_eq_three_of_order_two ho, chiLambda2_eq_three_of_order_two hoi]
    norm_num
  calc (∑ g : {g : PSL2F11 // orderOf g = 2}, chiNorm g.1)
      = ∑ _g : {g : PSL2F11 // orderOf g = 2}, (9 : k) :=
        Finset.sum_congr rfl fun g _ => hval g
    _ = (Fintype.card {g : PSL2F11 // orderOf g = 2} : k) * 9 := by
        rw [Finset.sum_const, nsmul_eq_mul]; rfl
    _ = (55 : k) * 9 := by rw [hcard]; norm_num
    _ = 495 := by norm_num

private theorem sum_chiNorm_order_three :
    (∑ g : {g : PSL2F11 // orderOf g = 3}, chiNorm g.1) = (0 : k) := by
  classical
  refine Finset.sum_eq_zero fun g _ => ?_
  show chiLambda2 g.1 * chiLambda2 g.1⁻¹ = 0
  rw [chiLambda2_eq_zero_of_order_three g.2, zero_mul]

private theorem sum_chiNorm_order_five :
    (∑ g : {g : PSL2F11 // orderOf g = 5}, chiNorm g.1) = (0 : k) := by
  classical
  refine Finset.sum_eq_zero fun g _ => ?_
  show chiLambda2 g.1 * chiLambda2 g.1⁻¹ = 0
  rw [chiLambda2_eq_zero_of_order_five g.2, zero_mul]

private theorem sum_chiNorm_order_six :
    (∑ g : {g : PSL2F11 // orderOf g = 6}, chiNorm g.1) = (0 : k) := by
  classical
  refine Finset.sum_eq_zero fun g _ => ?_
  show chiLambda2 g.1 * chiLambda2 g.1⁻¹ = 0
  rw [chiLambda2_eq_zero_of_order_six g.2, zero_mul]

private theorem sum_chiNorm_order_eleven :
    (∑ g : {g : PSL2F11 // orderOf g = 11}, chiNorm g.1) = (600 : k) := by
  classical
  have hcard : Fintype.card {g : PSL2F11 // orderOf g = 11} = 120 :=
    PSLCard.card_psl_order_eleven
  have hval : ∀ g : {g : PSL2F11 // orderOf g = 11}, chiNorm g.1 = (5 : k) :=
    fun g => chiLambda2_mul_inv_of_order_eleven g.2
  calc (∑ g : {g : PSL2F11 // orderOf g = 11}, chiNorm g.1)
      = ∑ _g : {g : PSL2F11 // orderOf g = 11}, (5 : k) :=
        Finset.sum_congr rfl fun g _ => hval g
    _ = (Fintype.card {g : PSL2F11 // orderOf g = 11} : k) * 5 := by
        rw [Finset.sum_const, nsmul_eq_mul]; rfl
    _ = (120 : k) * 5 := by rw [hcard]; norm_num
    _ = 600 := by norm_num

/-- **The norm of the ambient character: `∑_g χ_Λ²(g) χ_Λ²(g⁻¹) = 1320 = 2·660`.**

Equivalently, `⟨χ_Λ², χ_Λ²⟩ = 2`: the commutant of `Λ²U` is two-dimensional, so
`Λ²U` is the sum of exactly two non-isomorphic irreducible summands.  This is
the arithmetic input of `MsubUnique.eq_Msub`. -/
public theorem sum_chiLambda2_norm_eq_thirteen_twenty :
    (∑ g : PSL2F11, chiLambda2 g * chiLambda2 g⁻¹) = (1320 : k) := by
  have hfun : (∑ g : PSL2F11, chiLambda2 g * chiLambda2 g⁻¹) =
      ∑ g : PSL2F11, chiNorm g := rfl
  rw [hfun, sum_by_orders chiNorm, chiNorm_one, sum_chiNorm_order_two,
    sum_chiNorm_order_three, sum_chiNorm_order_five, sum_chiNorm_order_six,
    sum_chiNorm_order_eleven]
  norm_num

#print axioms chiLambda2_eq_zero_of_order_five
#print axioms chiLambda2_mul_inv_of_order_eleven
#print axioms sum_chiLambda2_norm_eq_thirteen_twenty

end Ord11CharacterSum
end V14Formalization
