/-
Even Weil module over K = ℚ(ζ₁₁).

* Cyclotomic field, primitive additive character ψ.
* Gauss sum G = Σ ψ(x²) with G² = −11 (Mathlib `gaussSum_sq`).
* Full Schrödinger Fourier S̃ on Fun = (ZMod 11 → K): (S̃² f)(x) = −f(−x).
* Even subspace U ⊆ Fun; restriction S of S̃ satisfies S² = −id.
* Coordinate model `Ucoord ≃ K⁶` and seal matrices T₆, S₆.
-/
module

public import Mathlib.RingTheory.Polynomial.Cyclotomic.Basic
public import Mathlib.RingTheory.Polynomial.Cyclotomic.Roots
public import Mathlib.RingTheory.AdjoinRoot
public import Mathlib.NumberTheory.LegendreSymbol.AddCharacter
public import Mathlib.NumberTheory.GaussSum
public import Mathlib.NumberTheory.MulChar.Basic
public import Mathlib.NumberTheory.LegendreSymbol.QuadraticChar.Basic
public import Mathlib.LinearAlgebra.Dimension.Finrank
public import Mathlib.LinearAlgebra.FreeModule.Finite.Basic
public import Mathlib.Data.ZMod.Basic
public import Mathlib.Algebra.Field.ZMod
public import Mathlib.Data.Nat.Prime.Basic
public import Mathlib.GroupTheory.OrderOfElement
public import Mathlib.Algebra.Module.Pi
public import Mathlib.Algebra.BigOperators.Group.Finset.Basic
public import Mathlib.Algebra.BigOperators.Ring.Finset
public import Mathlib.Data.Fintype.BigOperators
public import Mathlib.Algebra.Algebra.Basic
public import Mathlib.Algebra.CharP.Basic
public import Mathlib.FieldTheory.Minpoly.Field
public import Mathlib.LinearAlgebra.Matrix.ToLin
public import Mathlib.LinearAlgebra.Matrix.NonsingularInverse
public import Mathlib.LinearAlgebra.Matrix.SpecialLinearGroup

open Polynomial AddChar MulChar Matrix BigOperators

noncomputable section

namespace V14Formalization
namespace WeilRep

@[expose] public instance : Fact (Nat.Prime 11) := ⟨Nat.prime_eleven⟩
@[expose] public instance : NeZero (11 : ℕ) := ⟨by decide⟩

/-! ## K = ℚ(ζ₁₁) -/

@[expose] public def Φ11 : ℚ[X] := cyclotomic 11 ℚ
public lemma Φ11_irreducible : Irreducible Φ11 :=
  cyclotomic.irreducible_rat (by decide : 0 < 11)
@[expose] public instance : Fact (Irreducible Φ11) := ⟨Φ11_irreducible⟩

public abbrev K := AdjoinRoot Φ11
@[expose] public instance : Field K := inferInstance
@[expose] public instance : CharZero K := inferInstance
@[expose] public instance : Algebra ℚ K := inferInstance

@[expose] public def ζ : K := AdjoinRoot.root Φ11

public theorem aeval_ζ_Φ11 : aeval ζ Φ11 = 0 := by
  exact (AdjoinRoot.aeval_eq (f := Φ11) (p := Φ11)).trans (AdjoinRoot.mk_self (f := Φ11))

public theorem ζ_pow_eleven : ζ ^ (11 : ℕ) = 1 := by
  have hdiv : Φ11 ∣ (X : ℚ[X]) ^ 11 - 1 := cyclotomic.dvd_X_pow_sub_one 11 ℚ
  have hroot : aeval ζ ((X : ℚ[X]) ^ 11 - 1) = 0 :=
    aeval_eq_zero_of_dvd_aeval_eq_zero hdiv aeval_ζ_Φ11
  exact sub_eq_zero.mp (by simpa [map_sub, map_pow, aeval_X, map_one] using hroot)

public lemma Φ11_monic : Φ11.Monic := cyclotomic.monic 11 ℚ

public lemma minpoly_ζ : minpoly ℚ ζ = Φ11 :=
  (minpoly.eq_of_irreducible_of_monic Φ11_irreducible aeval_ζ_Φ11 Φ11_monic).symm

public lemma Φ11_natDegree : Φ11.natDegree = 10 := by
  change (cyclotomic 11 ℚ).natDegree = 10
  exact natDegree_cyclotomic 11 ℚ

theorem ζ_ne_one : ζ ≠ 1 := by
  intro heq
  have hdiv : Φ11 ∣ (X - C (1 : ℚ)) := by
    have : minpoly ℚ ζ ∣ (X - C (1 : ℚ)) := minpoly.dvd ℚ ζ (by simp [heq])
    rwa [minpoly_ζ] at this
  have : Φ11.natDegree ≤ (X - C (1 : ℚ)).natDegree :=
    natDegree_le_of_dvd hdiv (X_sub_C_ne_zero 1)
  rw [Φ11_natDegree, natDegree_X_sub_C] at this
  omega

public theorem orderOf_ζ : orderOf ζ = 11 := by
  have hdvd : orderOf ζ ∣ 11 := orderOf_dvd_of_pow_eq_one ζ_pow_eleven
  exact ((Nat.dvd_prime Nat.prime_eleven).mp hdvd).resolve_left fun h1 =>
    ζ_ne_one (orderOf_eq_one_iff.mp h1)

@[expose] public def ψ : AddChar (ZMod 11) K := zmodChar 11 ζ_pow_eleven

public theorem ψ_primitive : IsPrimitive ψ :=
  zmod_char_primitive_of_eq_one_only_at_zero 11 ψ fun a ha => by
    change ζ ^ a.val = 1 at ha
    have : orderOf ζ ∣ a.val := orderOf_dvd_iff_pow_eq_one.mpr ha
    rw [orderOf_ζ] at this
    exact (ZMod.val_eq_zero a).mp (Nat.eq_zero_of_dvd_of_lt this (ZMod.val_lt a))

public theorem ψ_apply (a : ZMod 11) : ψ a = ζ ^ a.val := rfl

theorem ψ_ne_one : ψ ≠ 1 := by
  intro h
  have := congr_fun (congr_arg DFunLike.coe h) 1
  change ζ ^ (1 : ZMod 11).val = 1 at this
  simp only [ZMod.val_one, pow_one] at this
  exact ζ_ne_one this

public theorem sum_ψ_eq_zero : (∑ a : ZMod 11, ψ a) = 0 :=
  AddChar.sum_eq_zero_of_ne_one ψ_ne_one

public theorem ψ_zero : ψ (0 : ZMod 11) = 1 := map_zero_eq_one ψ

public theorem ψ_add (a b : ZMod 11) : ψ (a + b) = ψ a * ψ b := map_add_eq_mul ψ a b

/-! ## Gauss sum G² = −11 -/

lemma ringChar_zmod11_ne_2 : ringChar (ZMod 11) ≠ 2 := by
  rw [ZMod.ringChar_zmod_n]; decide

@[expose] public def χ₂ℤ : MulChar (ZMod 11) ℤ := quadraticChar (ZMod 11)
@[expose] public def χ₂ : MulChar (ZMod 11) K := χ₂ℤ.ringHomComp (algebraMap ℤ K)

public theorem χ₂_isQuadratic : IsQuadratic χ₂ :=
  (quadraticChar_isQuadratic (ZMod 11)).comp (algebraMap ℤ K)

public theorem χ₂_ne_one : χ₂ ≠ 1 := by
  have hinj : Function.Injective (algebraMap ℤ K) :=
    FaithfulSMul.algebraMap_injective ℤ K
  have hχ : χ₂ℤ ≠ 1 := by
    change quadraticChar (ZMod 11) ≠ 1
    exact quadraticChar_ne_one ringChar_zmod11_ne_2
  exact (MulChar.ringHomComp_ne_one_iff hinj).mpr hχ

public theorem χ₂_neg_one : χ₂ (-1) = -1 := by
  have hℤ : χ₂ℤ (-1) = -1 := by
    change quadraticChar (ZMod 11) (-1) = -1
    rw [quadraticChar_neg_one_iff_not_isSquare]
    decide
  change (algebraMap ℤ K) (χ₂ℤ (-1)) = -1
  rw [hℤ, map_neg, map_one]

theorem gaussSum_χ₂_sq : (gaussSum χ₂ ψ) ^ 2 = (-11 : K) := by
  have h := gaussSum_sq (R := ZMod 11) (R' := K) χ₂_ne_one χ₂_isQuadratic ψ_primitive
  have hcard : (Fintype.card (ZMod 11) : K) = 11 := by
    rw [ZMod.card]; norm_cast
  calc (gaussSum χ₂ ψ) ^ 2
      = χ₂ (-1) * (Fintype.card (ZMod 11) : K) := h
    _ = (-1 : K) * (Fintype.card (ZMod 11) : K) := by rw [χ₂_neg_one]
    _ = (-1) * 11 := by rw [hcard]
    _ = -11 := by ring

@[expose] public def gauss : K := ∑ x : ZMod 11, ψ (x ^ 2)

public theorem card_sq_eq (a : ZMod 11) :
    ((Finset.univ.filter (fun x : ZMod 11 => x ^ 2 = a)).card : K) = χ₂ a + 1 := by
  have h := quadraticChar_card_sqrts (F := ZMod 11) ringChar_zmod11_ne_2 a
  have hset : ({x : ZMod 11 | x ^ 2 = a}).toFinset =
      Finset.univ.filter (fun x => x ^ 2 = a) := by
    ext x; simp
  have hN : ((Finset.univ.filter (fun x : ZMod 11 => x ^ 2 = a)).card : ℤ) =
      χ₂ℤ a + 1 := by
    simpa [hset, χ₂ℤ] using h
  have hL : (algebraMap ℤ K) (↑(Finset.univ.filter (fun x : ZMod 11 => x ^ 2 = a)).card) =
      ((Finset.univ.filter (fun x : ZMod 11 => x ^ 2 = a)).card : K) := by
    change (Int.castRingHom K) _ = _
    rfl
  have : ((Finset.univ.filter (fun x : ZMod 11 => x ^ 2 = a)).card : K) =
      (algebraMap ℤ K) (χ₂ℤ a + 1) :=
    hL.symm.trans (congr_arg (algebraMap ℤ K) hN)
  rw [this, map_add, map_one]
  rfl

public theorem gauss_eq_gaussSum : gauss = gaussSum χ₂ ψ := by
  classical
  have hx : ∀ x : ZMod 11, ψ (x ^ 2) =
      ∑ a : ZMod 11, (if x ^ 2 = a then (1 : K) else 0) * ψ a := by
    intro x
    rw [Finset.sum_eq_single (x ^ 2)]
    · simp only [↓reduceIte, one_mul]
    · intro b _ hb
      have : x ^ 2 ≠ b := Ne.symm hb
      simp [this]
    · intro h; exact absurd (Finset.mem_univ _) h
  simp only [gauss, gaussSum]
  have h1 : (∑ x : ZMod 11, ψ (x ^ 2)) =
      ∑ x : ZMod 11, ∑ a : ZMod 11, (if x ^ 2 = a then (1 : K) else 0) * ψ a :=
    Finset.sum_congr rfl fun x _ => hx x
  rw [h1, Finset.sum_comm]
  have h2 : (∑ a : ZMod 11, ∑ x : ZMod 11, (if x ^ 2 = a then (1 : K) else 0) * ψ a) =
      ∑ a : ZMod 11, (∑ x : ZMod 11, if x ^ 2 = a then (1 : K) else 0) * ψ a := by
    apply Finset.sum_congr rfl
    intro a _
    simp_rw [mul_comm _ (ψ a)]
    exact (Finset.mul_sum _ _ _).symm
  rw [h2]
  have hcnt : ∀ a, (∑ x : ZMod 11, if x ^ 2 = a then (1 : K) else 0) = χ₂ a + 1 := by
    intro a
    have : (∑ x : ZMod 11, if x ^ 2 = a then (1 : K) else 0) =
        ((Finset.univ.filter (fun x : ZMod 11 => x ^ 2 = a)).card : K) := by
      simp [Finset.sum_boole]
    rw [this, card_sq_eq]
  simp_rw [hcnt, add_mul, one_mul, Finset.sum_add_distrib, sum_ψ_eq_zero, add_zero]

public theorem gauss_sq : gauss ^ 2 = (-11 : K) := by
  rw [gauss_eq_gaussSum, gaussSum_χ₂_sq]

public theorem gauss_ne_zero : gauss ≠ 0 := by
  intro h
  have := congrArg (fun t => t ^ 2) h
  simp only [gauss_sq, zero_pow (by decide : (2 : ℕ) ≠ 0)] at this
  exact absurd this (by norm_num : (-11 : K) ≠ 0)

@[expose] public def cFourier : K := gauss⁻¹

public theorem cFourier_sq_mul_eleven : cFourier ^ 2 * 11 = (-1 : K) := by
  have h11 : (11 : K) ≠ 0 := by norm_num
  calc cFourier ^ 2 * 11
      = (gauss⁻¹) ^ 2 * 11 := rfl
    _ = (gauss ^ 2)⁻¹ * 11 := by rw [inv_pow]
    _ = (-11 : K)⁻¹ * 11 := by rw [gauss_sq]
    _ = 11 * (-11 : K)⁻¹ := by ring
    _ = 11 / (-11) := (div_eq_mul_inv _ _).symm
    _ = -1 := by field_simp

/-! ## Schrödinger representation on Fun = F₁₁ → K -/

public abbrev Fun := ZMod 11 → K
@[expose] public instance : AddCommGroup Fun := inferInstance
@[expose] public instance : Module K Fun := inferInstance

/-- Mathlib character sum: Σ_x ψ(x·b) = 11 if b=0 else 0. -/
public theorem sum_ψ_mul (b : ZMod 11) :
    (∑ x : ZMod 11, ψ (x * b)) = if b = 0 then (11 : K) else 0 := by
  have h := sum_mulShift (ψ := ψ) b ψ_primitive
  -- h: sum = ↑(if b=0 then card else 0)
  rw [h]
  split_ifs with hb
  · simp [ZMod.card]
  · simp

/-- Full Fourier transform. -/
@[expose] public def Sfull : Fun →ₗ[K] Fun where
  toFun f := fun x => cFourier * ∑ y : ZMod 11, ψ (x * y) * f y
  map_add' f g := by
    funext x
    simp only [Pi.add_apply]
    rw [← mul_add, ← Finset.sum_add_distrib]
    congr 1
    exact Finset.sum_congr rfl fun y _ => by ring
  map_smul' r f := by
    funext x
    simp only [Pi.smul_apply, smul_eq_mul, RingHom.id_apply]
    -- c * Σ ψ*(r*f) = c * r * Σ ψ*f
    have h : (∑ y : ZMod 11, ψ (x * y) * (r * f y)) =
        r * ∑ y : ZMod 11, ψ (x * y) * f y := by
      rw [Finset.mul_sum]
      exact Finset.sum_congr rfl fun y _ => by ring
    rw [h, mul_left_comm]

/-- Core identity: (S̃² f)(x) = − f(−x). -/
public theorem Sfull_sq_apply (f : Fun) (x : ZMod 11) :
    Sfull (Sfull f) x = - f (-x) := by
  classical
  change cFourier * ∑ y : ZMod 11, ψ (x * y) * Sfull f y = -f (-x)
  simp only [Sfull, LinearMap.coe_mk, AddHom.coe_mk]
  have hψ : ∀ y z : ZMod 11, ψ (x * y) * ψ (y * z) = ψ (y * (x + z)) := by
    intro y z; rw [← ψ_add]; congr 1; ring
  -- Establish the double-sum identity
  have hinner : ∀ y : ZMod 11,
      ψ (x * y) * (cFourier * ∑ z : ZMod 11, ψ (y * z) * f z) =
        cFourier * ∑ z : ZMod 11, ψ (y * (x + z)) * f z := by
    intro y
    have hpull :
        ψ (x * y) * ∑ z : ZMod 11, ψ (y * z) * f z =
          ∑ z : ZMod 11, ψ (x * y) * (ψ (y * z) * f z) :=
      Finset.mul_sum (Finset.univ : Finset (ZMod 11))
        (fun z => ψ (y * z) * f z) (ψ (x * y))
    have hch :
        (∑ z : ZMod 11, ψ (x * y) * (ψ (y * z) * f z)) =
          ∑ z : ZMod 11, ψ (y * (x + z)) * f z := by
      refine Finset.sum_congr rfl fun z _ => ?_
      calc ψ (x * y) * (ψ (y * z) * f z)
          = (ψ (x * y) * ψ (y * z)) * f z := by ring
        _ = ψ (y * (x + z)) * f z := by rw [hψ]
    calc ψ (x * y) * (cFourier * ∑ z : ZMod 11, ψ (y * z) * f z)
        = cFourier * (ψ (x * y) * ∑ z : ZMod 11, ψ (y * z) * f z) := by ring
      _ = cFourier * ∑ z : ZMod 11, ψ (x * y) * (ψ (y * z) * f z) := by rw [hpull]
      _ = cFourier * ∑ z : ZMod 11, ψ (y * (x + z)) * f z := by rw [hch]
  have hsum :
      (∑ y : ZMod 11, ψ (x * y) * (cFourier * ∑ z : ZMod 11, ψ (y * z) * f z)) =
        ∑ y : ZMod 11, cFourier * ∑ z : ZMod 11, ψ (y * (x + z)) * f z :=
    Finset.sum_congr rfl fun y _ => hinner y
  have hfactor :
      (∑ y : ZMod 11, cFourier * ∑ z : ZMod 11, ψ (y * (x + z)) * f z) =
        cFourier * ∑ y : ZMod 11, ∑ z : ZMod 11, ψ (y * (x + z)) * f z :=
    (Finset.mul_sum (Finset.univ : Finset (ZMod 11))
      (fun y => ∑ z : ZMod 11, ψ (y * (x + z)) * f z) cFourier).symm
  have hswap :
      (∑ y : ZMod 11, ∑ z : ZMod 11, ψ (y * (x + z)) * f z) =
        ∑ z : ZMod 11, f z * ∑ y : ZMod 11, ψ (y * (x + z)) := by
    rw [Finset.sum_comm]
    refine Finset.sum_congr rfl fun z _ => ?_
    have h := Finset.mul_sum (Finset.univ : Finset (ZMod 11))
      (fun y => ψ (y * (x + z))) (f z)
    refine Eq.trans ?_ h.symm
    refine Finset.sum_congr rfl fun y _ => mul_comm _ _
  -- Assemble: LHS = c * (c * Σ_z f z * charsum) = c² * ...
  have hLHS :
      cFourier * ∑ y : ZMod 11, ψ (x * y) *
          (cFourier * ∑ z : ZMod 11, ψ (y * z) * f z) =
        cFourier ^ 2 * ∑ z : ZMod 11, f z * ∑ y : ZMod 11, ψ (y * (x + z)) := by
    rw [hsum, hfactor, hswap]
    ring
  rw [hLHS]
  simp_rw [sum_ψ_mul]
  have h3 :
      (∑ z : ZMod 11, f z * (if x + z = 0 then (11 : K) else 0)) = 11 * f (-x) := by
    rw [Finset.sum_eq_single (-x)]
    · simp [add_neg_cancel, mul_comm]
    · intro z _ hz
      have hne : x + z ≠ 0 := fun h =>
        hz (by rw [add_comm] at h; exact eq_neg_of_add_eq_zero_left h)
      simp [hne]
    · intro h; exact absurd (Finset.mem_univ _) h
  rw [h3]
  have hc := cFourier_sq_mul_eleven
  calc cFourier ^ 2 * (11 * f (-x))
      = (cFourier ^ 2 * 11) * f (-x) := by ring
    _ = (-1) * f (-x) := by rw [hc]
    _ = -f (-x) := by ring

/-! ## Even subspace U and S² = −id -/

/-- Even functions f(−x) = f(x). -/
@[expose] public def EvenSub : Submodule K Fun where
  carrier := {f | ∀ x, f (-x) = f x}
  add_mem' := fun {f g} hf hg x => by simp [hf x, hg x]
  zero_mem' := fun x => rfl
  smul_mem' := fun r {f} hf x => by simp [hf x]

public abbrev U := EvenSub

@[expose] public instance : Module K U := inferInstance

public theorem Sfull_preserves_even {f : Fun} (hf : ∀ x, f (-x) = f x) (x : ZMod 11) :
    Sfull f (-x) = Sfull f x := by
  simp only [Sfull, LinearMap.coe_mk, AddHom.coe_mk]
  congr 1
  have hbij : Function.Bijective (fun y : ZMod 11 => -y) :=
    ⟨neg_injective, fun y => ⟨-y, neg_neg y⟩⟩
  -- Σ_y ψ((-x)y) f(y) = Σ_y ψ(x y) f(y) via y ↦ -y
  refine (Fintype.sum_bijective (fun y : ZMod 11 => -y) hbij
    (fun y => ψ ((-x) * y) * f y)
    (fun z => ψ (x * z) * f z) ?_).trans ?_
  · intro y
    have hψ : ψ ((-x) * y) = ψ (x * (-y)) := by congr 1; ring
    rw [hψ, hf y]
  · -- after bijective: Σ_z ψ(x z) f z = goal RHS
    rfl

/-- Fourier transform on the even subspace. -/
@[expose] public def S_even : U →ₗ[K] U where
  toFun f :=
    ⟨Sfull f.1, fun x => Sfull_preserves_even (fun t => f.2 t) x⟩
  map_add' := by
    intro f g
    apply Subtype.ext
    exact Sfull.map_add f.1 g.1
  map_smul' := by
    intro r f
    apply Subtype.ext
    exact Sfull.map_smul r f.1

/-- S² = −id on the even Weil module. -/
public theorem S_even_sq : S_even ∘ₗ S_even = -LinearMap.id := by
  apply LinearMap.ext
  intro f
  apply Subtype.ext
  funext x
  have h := Sfull_sq_apply f.1 x
  -- h: Sfull (Sfull f) x = -f (-x) = -f x since even
  simp only [S_even, LinearMap.comp_apply, LinearMap.neg_apply, LinearMap.id_apply,
    LinearMap.coe_mk, AddHom.coe_mk] at h ⊢
  -- Goal: (S_even (S_even f)).1 x = -f.1 x
  change Sfull (Sfull f.1) x = -f.1 x
  rw [h, f.2 x]

/-! ## Coordinate model K⁶ and seal matrices -/

public abbrev Ucoord := Fin 6 → K
@[expose] public instance : AddCommGroup Ucoord := inferInstance
@[expose] public instance : Module K Ucoord := inferInstance
@[expose] public instance : Module.Free K Ucoord := inferInstance
@[expose] public instance : FiniteDimensional K Ucoord :=
  Module.Finite.equiv (Finsupp.linearEquivFunOnFinite K K (Fin 6))

theorem finrank_Ucoord : Module.finrank K Ucoord = 6 := by
  rw [Module.finrank_fintype_fun_eq_card]; decide

/-- Diagonal T₆: multiplication by ψ(j²) on coordinate j. -/
@[expose] public def T6 : Matrix (Fin 6) (Fin 6) K :=
  Matrix.diagonal fun j => ψ ((j.val : ZMod 11) ^ 2)

/-- Fourier S₆ (seal formula). -/
@[expose] public def S6 : Matrix (Fin 6) (Fin 6) K :=
  Matrix.of fun i j =>
    if j.val = 0 then cFourier
    else cFourier * (ψ ((i.val : ZMod 11) * (j.val : ZMod 11)) +
      ψ (-((i.val : ZMod 11) * (j.val : ZMod 11))))

def T6lin : Ucoord →ₗ[K] Ucoord := Matrix.toLin' T6
def S6lin : Ucoord →ₗ[K] Ucoord := Matrix.toLin' S6

/-- Multiplication by ψ(x² / 2) preserves even functions. (Matches `Tfull_b 1`.) -/
def Tfull : Fun →ₗ[K] Fun where
  toFun f := fun x => ψ (x ^ 2 * (2 : ZMod 11)⁻¹) * f x
  map_add' := by
    intro f g; funext x
    simp only [Pi.add_apply]; ring
  map_smul' := by
    intro r f; funext x
    simp only [Pi.smul_apply, smul_eq_mul, RingHom.id_apply]; ring

theorem Tfull_preserves_even {f : Fun} (hf : ∀ x, f (-x) = f x) (x : ZMod 11) :
    Tfull f (-x) = Tfull f x := by
  simp only [Tfull, LinearMap.coe_mk, AddHom.coe_mk]
  have : ψ ((-x) ^ 2 * (2 : ZMod 11)⁻¹) = ψ (x ^ 2 * (2 : ZMod 11)⁻¹) := by
    congr 1; ring
  rw [this, hf x]

def T_even : U →ₗ[K] U where
  toFun f := ⟨Tfull f.1, fun x => Tfull_preserves_even (fun t => f.2 t) x⟩
  map_add' := by
    intro f g; apply Subtype.ext
    exact Tfull.map_add f.1 g.1
  map_smul' := by
    intro r f; apply Subtype.ext
    exact Tfull.map_smul r f.1


/-! ## Unipotent family T_b and standard generators -/

/-- Half-quadratic phase: ψ(b · x² / 2). Standard Weil normalization so that
the Bruhat big-cell formula matches the Fourier–unipotent identity W N(t) W. -/
@[expose] public def twoInv : ZMod 11 := (2 : ZMod 11)⁻¹

lemma twoInv_eq : twoInv = (2 : ZMod 11)⁻¹ := rfl

public lemma two_mul_twoInv : (2 : ZMod 11) * twoInv = 1 :=
  mul_inv_cancel₀ (by decide : (2 : ZMod 11) ≠ 0)

/-- Multiplication by ψ(b · x² / 2) on Fun; preserves even functions. -/
@[expose] public def Tfull_b (b : ZMod 11) : Fun →ₗ[K] Fun where
  toFun f := fun x => ψ (b * x ^ 2 * twoInv) * f x
  map_add' := by
    intro f g; funext x
    simp only [Pi.add_apply]; ring
  map_smul' := by
    intro r f; funext x
    simp only [Pi.smul_apply, smul_eq_mul, RingHom.id_apply]; ring

public theorem Tfull_b_preserves_even (b : ZMod 11) {f : Fun}
    (hf : ∀ x, f (-x) = f x) (x : ZMod 11) :
    Tfull_b b f (-x) = Tfull_b b f x := by
  simp only [Tfull_b, LinearMap.coe_mk, AddHom.coe_mk]
  have : ψ (b * (-x) ^ 2 * twoInv) = ψ (b * x ^ 2 * twoInv) := by congr 1; ring
  rw [this, hf x]

@[expose] public def T_even_b (b : ZMod 11) : U →ₗ[K] U where
  toFun f := ⟨Tfull_b b f.1, fun x => Tfull_b_preserves_even b (fun t => f.2 t) x⟩
  map_add' := by
    intro f g; apply Subtype.ext
    exact (Tfull_b b).map_add f.1 g.1
  map_smul' := by
    intro r f; apply Subtype.ext
    exact (Tfull_b b).map_smul r f.1

public theorem T_even_b_zero : T_even_b 0 = LinearMap.id := by
  apply LinearMap.ext
  intro f
  apply Subtype.ext
  funext x
  simp only [T_even_b, Tfull_b, LinearMap.coe_mk, AddHom.coe_mk, LinearMap.id_apply,
    zero_mul, ψ_zero, one_mul]

public theorem T_even_b_add (b c : ZMod 11) :
    T_even_b (b + c) = T_even_b b ∘ₗ T_even_b c := by
  apply LinearMap.ext
  intro f
  apply Subtype.ext
  funext x
  simp only [T_even_b, Tfull_b, LinearMap.comp_apply, LinearMap.coe_mk, AddHom.coe_mk]
  have hψ : ψ ((b + c) * x ^ 2 * twoInv) =
      ψ (b * x ^ 2 * twoInv) * ψ (c * x ^ 2 * twoInv) := by
    rw [← ψ_add]; congr 1; ring
  rw [hψ]; ring

/-- Standard unipotent t = [[1,1],[0,1]] acts as T_even_b 1. -/
def T_gen : U →ₗ[K] U := T_even_b 1

theorem T_gen_eq_T_even : T_gen = T_even := by
  apply LinearMap.ext
  intro f
  apply Subtype.ext
  funext x
  simp only [T_gen, T_even_b, Tfull_b, T_even, Tfull, LinearMap.coe_mk, AddHom.coe_mk,
    twoInv, one_mul]

/-- Weyl element S acts as S_even; S² = −id. -/
def S_gen : U →ₗ[K] U := S_even

theorem S_gen_sq : S_gen ∘ₗ S_gen = -LinearMap.id := S_even_sq

/-- The matrix S = [[0,-1],[1,0]] in SL₂(F₁₁). -/
@[expose] public def Smat : SpecialLinearGroup (Fin 2) (ZMod 11) :=
  ⟨!![0, -1; 1, 0], by
    simp [Matrix.det_fin_two_of]⟩

/-- The matrix T = [[1,1],[0,1]] in SL₂(F₁₁). -/
@[expose] public def Tmat : SpecialLinearGroup (Fin 2) (ZMod 11) :=
  ⟨!![1, 1; 0, 1], by
    simp [Matrix.det_fin_two_of]⟩

theorem Smat_sq : Smat * Smat = -1 := by
  apply Subtype.ext
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [Smat, Matrix.mul_apply, Fin.sum_univ_two, Matrix.neg_apply]

end WeilRep
end V14Formalization
