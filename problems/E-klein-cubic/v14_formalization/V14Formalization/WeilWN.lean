/-
Fourier–unipotent conjugation for the Weil representation.

Key identity (t ≠ 0):
  W ∘ N(t) ∘ W = N(−1/(4t)) ∘ W ∘ D(−2t) ∘ N(−1/(4t))
-/
import V14Formalization.WeilMul

open BigOperators
open V14Formalization.WeilRep
open V14Formalization.WeilRepSL2
open V14Formalization.WeilMul

noncomputable section

namespace V14Formalization
namespace WeilWN

set_option maxHeartbeats 8000000

abbrev F := ZMod 11

private lemma two_ne : (2 : F) ≠ 0 := by decide
private lemma four_ne : (4 : F) ≠ 0 := by decide

/-! ## Σ ψ(a x²) = χ₂(a) · gauss -/

theorem sum_ψ_scaled_sq (a : F) (ha : a ≠ 0) :
    (∑ x : ZMod 11, ψ (a * x ^ 2)) = χ₂ a * gauss := by
  classical
  -- Group by square class: Σ_x ψ(a x²) = Σ_b (1+χ₂ b) ψ(a b)
  have hsum :
      (∑ x : ZMod 11, ψ (a * x ^ 2)) =
        ∑ b : ZMod 11, (χ₂ b + 1) * ψ (a * b) := by
    have hx : ∀ x,
        ψ (a * x ^ 2) =
          ∑ b : ZMod 11, (if x ^ 2 = b then (1 : K) else 0) * ψ (a * b) := by
      intro x
      rw [Finset.sum_eq_single (x ^ 2)]
      · simp
      · intro b _ hb; simp [Ne.symm hb]
      · intro h; exact absurd (Finset.mem_univ _) h
    rw [Finset.sum_congr rfl fun x _ => hx x, Finset.sum_comm]
    refine Finset.sum_congr rfl fun b _ => ?_
    have hcnt :
        (∑ x : ZMod 11, if x ^ 2 = b then (1 : K) else 0) =
          ((Finset.univ.filter (fun x : ZMod 11 => x ^ 2 = b)).card : K) := by
      simp [Finset.sum_boole]
    calc (∑ x : ZMod 11, (if x ^ 2 = b then (1 : K) else 0) * ψ (a * b))
        = (∑ x : ZMod 11, if x ^ 2 = b then (1 : K) else 0) * ψ (a * b) := by
          simp_rw [mul_comm _ (ψ (a * b))]; exact (Finset.mul_sum _ _ _).symm
      _ = ((Finset.univ.filter (fun x : ZMod 11 => x ^ 2 = b)).card : K) * ψ (a * b) := by
          rw [hcnt]
      _ = (χ₂ b + 1) * ψ (a * b) := by rw [card_sq_eq]
  rw [hsum]
  have hsplit :
      (∑ b : ZMod 11, (χ₂ b + 1) * ψ (a * b)) =
        (∑ b : ZMod 11, χ₂ b * ψ (a * b)) + ∑ b : ZMod 11, ψ (a * b) := by
    simp_rw [add_mul, one_mul, Finset.sum_add_distrib]
  rw [hsplit]
  have hzero : (∑ b : ZMod 11, ψ (a * b)) = 0 := by
    have h := sum_ψ_mul a
    rw [if_neg ha] at h
    refine Eq.trans ?_ h
    exact Finset.sum_congr rfl fun b _ => by rw [mul_comm]
  rw [hzero, add_zero]
  -- Reindex c = a·b
  have hbij : Function.Bijective (fun c : ZMod 11 => a⁻¹ * c) :=
    ⟨mul_right_injective₀ (inv_ne_zero ha), fun b => ⟨a * b, by
      calc a⁻¹ * (a * b) = (a⁻¹ * a) * b := by ring
        _ = (1 : F) * b := by rw [inv_mul_cancel₀ ha]
        _ = b := one_mul b⟩⟩
  have hreindex :
      (∑ b : ZMod 11, χ₂ b * ψ (a * b)) =
        ∑ c : ZMod 11, χ₂ (a⁻¹ * c) * ψ c := by
    refine (Fintype.sum_bijective (fun c => a⁻¹ * c) hbij
      (fun c => χ₂ (a⁻¹ * c) * ψ (a * (a⁻¹ * c)))
      (fun b => χ₂ b * ψ (a * b)) fun c => by
        have : a * (a⁻¹ * c) = c := by
          calc a * (a⁻¹ * c) = (a * a⁻¹) * c := by ring
            _ = (1 : F) * c := by rw [mul_inv_cancel₀ ha]
            _ = c := one_mul c
        rw [this]).symm.trans
      (Finset.sum_congr rfl fun c _ => by
        have : a * (a⁻¹ * c) = c := by
          calc a * (a⁻¹ * c) = (a * a⁻¹) * c := by ring
            _ = (1 : F) * c := by rw [mul_inv_cancel₀ ha]
            _ = c := one_mul c
        rw [this])
  have hfactor :
      (∑ c : ZMod 11, χ₂ (a⁻¹ * c) * ψ c) =
        χ₂ a⁻¹ * ∑ c : ZMod 11, χ₂ c * ψ c := by
    simp_rw [map_mul χ₂]
    rw [Finset.mul_sum]
    exact Finset.sum_congr rfl fun c _ => by ring
  rw [hreindex, hfactor, χ₂_inv ha]
  change χ₂ a * ∑ c : ZMod 11, χ₂ c * ψ c = χ₂ a * gauss
  have : (∑ c : ZMod 11, χ₂ c * ψ c) = gaussSum χ₂ ψ := rfl
  rw [this, ← gauss_eq_gaussSum]

/-! ## Complete the square for additive character sums -/

theorem sum_ψ_quadratic (t b : F) (ht : t ≠ 0) :
    (∑ y : ZMod 11, ψ (t * y ^ 2 + b * y)) =
      χ₂ t * gauss * ψ (-((4 : F) * t)⁻¹ * b ^ 2) := by
  classical
  have h2t : (2 : F) * t ≠ 0 := mul_ne_zero two_ne ht
  have h4t : (4 : F) * t ≠ 0 := mul_ne_zero four_ne ht
  -- Algebraic identity: t y² + b y = t (y + b/(2t))² − b²/(4t)
  have hshift : ∀ y : ZMod 11,
      t * y ^ 2 + b * y =
        t * (y + ((2 : F) * t)⁻¹ * b) ^ 2 - ((4 : F) * t)⁻¹ * b ^ 2 := by
    intro y
    have hmid : t * (2 * y * ((2 * t)⁻¹ * b)) = b * y := by
      field_simp [h2t, two_ne, ht]
    have hlast : t * (((2 : F) * t)⁻¹ * b) ^ 2 = ((4 : F) * t)⁻¹ * b ^ 2 := by
      field_simp [h2t, h4t, two_ne, four_ne, ht]
      ring
    have hexp : (y + ((2 : F) * t)⁻¹ * b) ^ 2 =
        y ^ 2 + 2 * y * ((2 * t)⁻¹ * b) + (((2 : F) * t)⁻¹ * b) ^ 2 := by ring
    calc t * y ^ 2 + b * y
        = t * y ^ 2 + t * (2 * y * ((2 * t)⁻¹ * b)) + t * (((2 : F) * t)⁻¹ * b) ^ 2
            - ((4 : F) * t)⁻¹ * b ^ 2 := by
          rw [hmid, hlast]; ring
      _ = t * (y ^ 2 + 2 * y * ((2 * t)⁻¹ * b) + (((2 : F) * t)⁻¹ * b) ^ 2)
            - ((4 : F) * t)⁻¹ * b ^ 2 := by ring
      _ = t * (y + ((2 : F) * t)⁻¹ * b) ^ 2 - ((4 : F) * t)⁻¹ * b ^ 2 := by
          rw [hexp]
  have hψ : ∀ y,
      ψ (t * y ^ 2 + b * y) =
        ψ (-((4 : F) * t)⁻¹ * b ^ 2) *
          ψ (t * (y + ((2 : F) * t)⁻¹ * b) ^ 2) := by
    intro y
    have heq : t * y ^ 2 + b * y =
        t * (y + ((2 : F) * t)⁻¹ * b) ^ 2 + (-((4 : F) * t)⁻¹ * b ^ 2) := by
      rw [hshift y]; ring
    rw [heq, ψ_add, mul_comm]
  simp_rw [hψ]
  rw [← Finset.mul_sum]
  have hbij : Function.Bijective (fun y : ZMod 11 => y + ((2 : F) * t)⁻¹ * b) :=
    ⟨fun _ _ h => add_right_cancel h,
      fun u => ⟨u - ((2 : F) * t)⁻¹ * b, by ring⟩⟩
  have hre :
      (∑ y : ZMod 11, ψ (t * (y + ((2 : F) * t)⁻¹ * b) ^ 2)) =
        ∑ u : ZMod 11, ψ (t * u ^ 2) :=
    Fintype.sum_bijective _ hbij _ _ fun _ => rfl
  rw [hre, sum_ψ_scaled_sq t ht]
  ring

/-! ## W N(t) W = N(−t⁻¹) W D(−t) N(−t⁻¹)  (with ψ(· x²/2) normalization) -/

/-- Character sum for the half-quadratic phase: Σ ψ((t/2) y² + b y). -/
theorem sum_ψ_quadratic_half (t b : F) (ht : t ≠ 0) :
    (∑ y : ZMod 11, ψ (t * y ^ 2 * twoInv + b * y)) =
      χ₂ t * (-1 : K) * gauss * ψ (- t⁻¹ * b ^ 2 * twoInv) := by
  classical
  have h2t : (2 : F) * t ≠ 0 := mul_ne_zero two_ne ht
  -- (t/2) y² + b y = (t/2)(y + b/t)² - b²/(2t)
  have hshift : ∀ y : ZMod 11,
      t * y ^ 2 * twoInv + b * y =
        t * (y + t⁻¹ * b) ^ 2 * twoInv - t⁻¹ * b ^ 2 * twoInv := by
    intro y
    have htinv : t * t⁻¹ = 1 := mul_inv_cancel₀ ht
    have h2i : (2 : F) * twoInv = 1 := two_mul_twoInv
    -- (t/2)(y + b/t)² - b²/(2t) = (t/2)y² + b y + b²/(2t) - b²/(2t)
    have hexp : (y + t⁻¹ * b) ^ 2 =
        y ^ 2 + (2 : F) * y * (t⁻¹ * b) + (t⁻¹ * b) ^ 2 := by ring
    have hmid : t * twoInv * ((2 : F) * y * (t⁻¹ * b)) = b * y := by
      calc t * twoInv * ((2 : F) * y * (t⁻¹ * b))
          = (t * t⁻¹) * ((2 : F) * twoInv) * (y * b) := by ring
        _ = (1 : F) * 1 * (y * b) := by rw [htinv, h2i]
        _ = b * y := by ring
    have hlast : t * twoInv * (t⁻¹ * b) ^ 2 = t⁻¹ * b ^ 2 * twoInv := by
      calc t * twoInv * (t⁻¹ * b) ^ 2
          = (t * t⁻¹) * twoInv * t⁻¹ * b ^ 2 := by ring
        _ = 1 * twoInv * t⁻¹ * b ^ 2 := by rw [htinv]
        _ = t⁻¹ * b ^ 2 * twoInv := by ring
    calc t * y ^ 2 * twoInv + b * y
        = t * twoInv * y ^ 2 + t * twoInv * ((2 : F) * y * (t⁻¹ * b)) +
            t * twoInv * (t⁻¹ * b) ^ 2 - t⁻¹ * b ^ 2 * twoInv := by
          rw [hmid, hlast]; ring
      _ = t * twoInv * (y ^ 2 + (2 : F) * y * (t⁻¹ * b) + (t⁻¹ * b) ^ 2) -
            t⁻¹ * b ^ 2 * twoInv := by ring
      _ = t * (y + t⁻¹ * b) ^ 2 * twoInv - t⁻¹ * b ^ 2 * twoInv := by
          rw [hexp]; ring
  have hψ : ∀ y,
      ψ (t * y ^ 2 * twoInv + b * y) =
        ψ (- t⁻¹ * b ^ 2 * twoInv) *
          ψ (t * (y + t⁻¹ * b) ^ 2 * twoInv) := by
    intro y
    have heq : t * y ^ 2 * twoInv + b * y =
        t * (y + t⁻¹ * b) ^ 2 * twoInv + (- t⁻¹ * b ^ 2 * twoInv) := by
      rw [hshift y]; ring
    rw [heq, ψ_add, mul_comm]
  simp_rw [hψ]
  rw [← Finset.mul_sum]
  have hbij : Function.Bijective (fun y : ZMod 11 => y + t⁻¹ * b) :=
    ⟨fun _ _ h => add_right_cancel h,
      fun u => ⟨u - t⁻¹ * b, by ring⟩⟩
  have hre :
      (∑ y : ZMod 11, ψ (t * (y + t⁻¹ * b) ^ 2 * twoInv)) =
        ∑ u : ZMod 11, ψ (t * u ^ 2 * twoInv) :=
    Fintype.sum_bijective _ hbij _ _ fun _ => rfl
  rw [hre]
  -- Σ ψ((t/2) u²) = χ₂(t/2) * gauss = χ₂(t) χ₂(2⁻¹) gauss = -χ₂(t) gauss
  have hscaled : (∑ u : ZMod 11, ψ (t * u ^ 2 * twoInv)) =
      χ₂ (t * twoInv) * gauss := by
    -- ψ((t*twoInv) u²) form of sum_ψ_scaled_sq
    have hne : t * twoInv ≠ 0 := mul_ne_zero ht (inv_ne_zero two_ne)
    convert sum_ψ_scaled_sq (t * twoInv) hne using 1
    refine Finset.sum_congr rfl fun u _ => ?_
    congr 1; ring
  have hχ : χ₂ (t * twoInv) = - χ₂ t := by
    rw [map_mul]
    have h2 : χ₂ twoInv = (-1 : K) := by
      have : χ₂ twoInv = χ₂ (2 : F) := by
        change χ₂ ((2 : F)⁻¹) = χ₂ (2 : F)
        exact χ₂_inv two_ne
      rw [this, χ₂_two]
    rw [h2]
    ring
  rw [hscaled, hχ]
  ring

/-- Temporary: old-style identity for N_raw(t) := multipy by ψ(t x²), recovered as N(2t).
    W N(2t) W = N(-t⁻¹) W D(-t) N(-t⁻¹) under the NEW N (= ψ(·x²/2)).
    Because N(2t) f = ψ(t x²) f (old N(t)), and old WNW gives
    W N_old(t) W = N_old(-1/(4t)) W D(-2t) N_old(-1/(4t)).
    N_old(u) = N_new(2u), so N_old(-1/(4t)) = N_new(-1/(2t)), D(-2t) stays.
    Then W N_new(2t) W = N_new(-1/(2t)) W D(-2t) N_new(-1/(2t)).
    Set s = 2t (so t = s/2): W N_new(s) W = N_new(-1/s) W D(-s) N_new(-1/s). ✓ -/

theorem Wfull_Nfull_Wfull (t : F) (ht : t ≠ 0) :
    Wfull ∘ₗ Nfull t ∘ₗ Wfull =
      Nfull (-t⁻¹) ∘ₗ Wfull ∘ₗ Dfull (-t) (neg_ne_zero.mpr ht) ∘ₗ
        Nfull (-t⁻¹) := by
  -- Reduce to the double-angle form via s = t/2? 
  -- Direct proof using sum_ψ_quadratic_half
  apply LinearMap.ext; intro f; funext x
  classical
  -- Use the same architecture as the proved full-quadratic case, with twoInv.
  -- Left side double Fourier:
  have hL :
      (Wfull ∘ₗ Nfull t ∘ₗ Wfull) f x =
        cFourier ^ 2 * χ₂ t * (-1 : K) * gauss *
          ψ (-t⁻¹ * x ^ 2 * twoInv) *
          ∑ z : ZMod 11, ψ (-t⁻¹ * z ^ 2 * twoInv) *
            ψ (-t⁻¹ * x * z) * f z := by
    -- Unfold once
    have h0 : (Wfull ∘ₗ Nfull t ∘ₗ Wfull) f x =
        Wfull (Nfull t (Wfull f)) x := by
      simp only [LinearMap.comp_apply]
    rw [h0]
    -- First Fourier
    have h1 : Wfull (Nfull t (Wfull f)) x =
        cFourier * ∑ y, ψ (x * y + t * y ^ 2 * twoInv) * (Wfull f y) := by
      dsimp [Wfull, Nfull, Tfull_b, Sfull]
      congr 1
      refine Finset.sum_congr rfl fun y _ => ?_
      have hp : ψ (x * y) * ψ (t * y ^ 2 * twoInv) =
          ψ (x * y + t * y ^ 2 * twoInv) := (ψ_add _ _).symm
      calc ψ (x * y) * (ψ (t * y ^ 2 * twoInv) * Wfull f y)
          = (ψ (x * y) * ψ (t * y ^ 2 * twoInv)) * Wfull f y := by ring
        _ = ψ (x * y + t * y ^ 2 * twoInv) * Wfull f y := by rw [hp]
    rw [h1]
    -- Expand W f and swap
    simp only [Wfull, Sfull, LinearMap.coe_mk, AddHom.coe_mk]
    have h2 :
        cFourier * ∑ y, ψ (x * y + t * y ^ 2 * twoInv) *
            (cFourier * ∑ z, ψ (y * z) * f z) =
          cFourier ^ 2 * ∑ z, f z *
            ∑ y, ψ (t * y ^ 2 * twoInv + (x + z) * y) := by
      have hsum :
          (∑ y, ψ (x * y + t * y ^ 2 * twoInv) *
              (cFourier * ∑ z, ψ (y * z) * f z)) =
            cFourier * ∑ y, ∑ z, ψ (x * y + t * y ^ 2 * twoInv) *
              (ψ (y * z) * f z) := by
        rw [Finset.mul_sum]
        refine Finset.sum_congr rfl fun y _ => ?_
        have hm := Finset.mul_sum (Finset.univ : Finset (ZMod 11))
          (fun z => ψ (y * z) * f z) (ψ (x * y + t * y ^ 2 * twoInv))
        calc ψ (x * y + t * y ^ 2 * twoInv) *
              (cFourier * ∑ z, ψ (y * z) * f z)
            = cFourier * (ψ (x * y + t * y ^ 2 * twoInv) *
                ∑ z, ψ (y * z) * f z) := by ring
          _ = cFourier * ∑ z, ψ (x * y + t * y ^ 2 * twoInv) *
                (ψ (y * z) * f z) := by rw [hm]
      have hswap :
          (∑ y, ∑ z, ψ (x * y + t * y ^ 2 * twoInv) * (ψ (y * z) * f z)) =
            ∑ z, f z * ∑ y, ψ (t * y ^ 2 * twoInv + (x + z) * y) := by
        rw [Finset.sum_comm]
        refine Finset.sum_congr rfl fun z _ => ?_
        have hpull := (Finset.mul_sum (Finset.univ : Finset (ZMod 11))
          (fun y => ψ (t * y ^ 2 * twoInv + (x + z) * y)) (f z)).symm
        refine Eq.trans ?_ hpull
        refine Finset.sum_congr rfl fun y _ => ?_
        have harg : x * y + t * y ^ 2 * twoInv + y * z =
            t * y ^ 2 * twoInv + (x + z) * y := by ring
        have hp : ψ (x * y + t * y ^ 2 * twoInv) * ψ (y * z) =
            ψ (t * y ^ 2 * twoInv + (x + z) * y) := by rw [← ψ_add, harg]
        calc ψ (x * y + t * y ^ 2 * twoInv) * (ψ (y * z) * f z)
            = (ψ (x * y + t * y ^ 2 * twoInv) * ψ (y * z)) * f z := by ring
          _ = ψ (t * y ^ 2 * twoInv + (x + z) * y) * f z := by rw [hp]
          _ = f z * ψ (t * y ^ 2 * twoInv + (x + z) * y) := by ring
      calc cFourier * ∑ y, ψ (x * y + t * y ^ 2 * twoInv) *
            (cFourier * ∑ z, ψ (y * z) * f z)
          = cFourier * (cFourier * ∑ y, ∑ z,
              ψ (x * y + t * y ^ 2 * twoInv) * (ψ (y * z) * f z)) := by
            rw [hsum]
        _ = cFourier ^ 2 * ∑ z, f z *
              ∑ y, ψ (t * y ^ 2 * twoInv + (x + z) * y) := by
            rw [hswap]; ring
    rw [h2]
    have hin : ∀ z, ∑ y, ψ (t * y ^ 2 * twoInv + (x + z) * y) =
        χ₂ t * (-1 : K) * gauss * ψ (-t⁻¹ * (x + z) ^ 2 * twoInv) :=
      fun z => sum_ψ_quadratic_half t (x + z) ht
    simp_rw [hin]
    have hpull :
        (∑ z, f z * (χ₂ t * (-1 : K) * gauss *
          ψ (-t⁻¹ * (x + z) ^ 2 * twoInv))) =
          χ₂ t * (-1 : K) * gauss *
            ∑ z, f z * ψ (-t⁻¹ * (x + z) ^ 2 * twoInv) := by
      rw [Finset.mul_sum]
      exact Finset.sum_congr rfl fun z _ => by ring
    rw [hpull]
    -- Expand phases
    have hphase : ∀ z,
        ψ (-t⁻¹ * (x + z) ^ 2 * twoInv) =
          ψ (-t⁻¹ * x ^ 2 * twoInv) * ψ (-t⁻¹ * z ^ 2 * twoInv) *
            ψ (-t⁻¹ * x * z) := by
      intro z
      have hexp : (x + z) ^ 2 = x ^ 2 + 2 * x * z + z ^ 2 := by ring
      have h2i := two_mul_twoInv
      have hcross : (-t⁻¹) * (2 * x * z) * twoInv = -t⁻¹ * x * z := by
        calc (-t⁻¹) * (2 * x * z) * twoInv
            = (-t⁻¹) * x * z * ((2 : F) * twoInv) := by ring
          _ = (-t⁻¹) * x * z * 1 := by rw [h2i]
          _ = -t⁻¹ * x * z := by ring
      have hsum :
          -t⁻¹ * (x + z) ^ 2 * twoInv =
            -t⁻¹ * x ^ 2 * twoInv + -t⁻¹ * z ^ 2 * twoInv + -t⁻¹ * x * z := by
        rw [hexp]
        calc -t⁻¹ * (x ^ 2 + 2 * x * z + z ^ 2) * twoInv
            = -t⁻¹ * x ^ 2 * twoInv + (-t⁻¹) * (2 * x * z) * twoInv +
                -t⁻¹ * z ^ 2 * twoInv := by ring
          _ = -t⁻¹ * x ^ 2 * twoInv + -t⁻¹ * z ^ 2 * twoInv +
                -t⁻¹ * x * z := by rw [hcross]; ring
      rw [hsum, ψ_add, ψ_add]
    simp_rw [hphase]
    have hpull2 :
        (∑ z, f z * (ψ (-t⁻¹ * x ^ 2 * twoInv) *
          ψ (-t⁻¹ * z ^ 2 * twoInv) * ψ (-t⁻¹ * x * z))) =
          ψ (-t⁻¹ * x ^ 2 * twoInv) *
            ∑ z, ψ (-t⁻¹ * z ^ 2 * twoInv) * ψ (-t⁻¹ * x * z) * f z := by
      rw [Finset.mul_sum]
      exact Finset.sum_congr rfl fun z _ => by ring
    rw [hpull2]; ring
  -- Right side
  have hR :
      (Nfull (-t⁻¹) ∘ₗ Wfull ∘ₗ Dfull (-t) (neg_ne_zero.mpr ht) ∘ₗ
          Nfull (-t⁻¹)) f x =
        ψ (-t⁻¹ * x ^ 2 * twoInv) * cFourier * χ₂ (-t) *
          ∑ z, ψ (-t⁻¹ * x * z) * ψ (-t⁻¹ * z ^ 2 * twoInv) * f z := by
    have hβne : (-t : F) ≠ 0 := neg_ne_zero.mpr ht
    -- Expand
    dsimp [Nfull, Tfull_b, Wfull, Sfull, Dfull, LinearMap.comp_apply]
    -- Get to sum form with reindex z = (-t)*u
    have hbij : Function.Bijective (fun u : ZMod 11 => (-t) * u) :=
      ⟨mul_right_injective₀ hβne, fun z => ⟨(-t)⁻¹ * z, by
        calc (-t) * ((-t)⁻¹ * z) = ((-t) * (-t)⁻¹) * z := by ring
          _ = (1 : F) * z := by rw [mul_inv_cancel₀ hβne]
          _ = z := one_mul z⟩⟩
    have hinv : (-t : F)⁻¹ = -t⁻¹ := inv_neg
    have hsum :
        (∑ u, ψ (x * u) * (χ₂ (-t) * ψ (-t⁻¹ * ((-t) * u) ^ 2 * twoInv) *
          f ((-t) * u))) =
          χ₂ (-t) * ∑ z, ψ (-t⁻¹ * x * z) * ψ (-t⁻¹ * z ^ 2 * twoInv) * f z := by
      have hre := Fintype.sum_bijective (fun u => (-t) * u) hbij
        (fun u => ψ (x * u) * (χ₂ (-t) * ψ (-t⁻¹ * ((-t) * u) ^ 2 * twoInv) *
          f ((-t) * u)))
        (fun z => ψ (x * ((-t)⁻¹ * z)) * (χ₂ (-t) *
          ψ (-t⁻¹ * z ^ 2 * twoInv) * f z))
        (fun u => by
          have : (-t)⁻¹ * ((-t) * u) = u := by
            calc (-t)⁻¹ * ((-t) * u) = ((-t)⁻¹ * (-t)) * u := by ring
              _ = (1 : F) * u := by rw [inv_mul_cancel₀ hβne]
              _ = u := one_mul u
          rw [this])
      have h1 :
          (∑ z, ψ (x * ((-t)⁻¹ * z)) * (χ₂ (-t) *
            ψ (-t⁻¹ * z ^ 2 * twoInv) * f z)) =
            χ₂ (-t) * ∑ z, ψ (x * ((-t)⁻¹ * z)) *
              ψ (-t⁻¹ * z ^ 2 * twoInv) * f z := by
        rw [Finset.mul_sum]
        exact Finset.sum_congr rfl fun z _ => by ring
      have h2 :
          χ₂ (-t) * ∑ z, ψ (x * ((-t)⁻¹ * z)) *
              ψ (-t⁻¹ * z ^ 2 * twoInv) * f z =
            χ₂ (-t) * ∑ z, ψ (-t⁻¹ * x * z) *
              ψ (-t⁻¹ * z ^ 2 * twoInv) * f z := by
        refine congrArg (fun s => χ₂ (-t) * s) ?_
        refine Finset.sum_congr rfl fun z _ => ?_
        have : x * ((-t)⁻¹ * z) = -t⁻¹ * x * z := by rw [hinv]; ring
        rw [this]
      exact (hre.trans h1).trans h2
    -- Also simplify ψ(-t⁻¹ * ((-t)*u)² * twoInv) = ψ(-t⁻¹ * z² * twoInv) after reindex
    -- In hre we used ψ(-t⁻¹ * z² * twoInv) on the right - need to check left has same after (β u)²
    -- α (β u)² twoInv with α=-t⁻¹, β=-t: (-t⁻¹)*((-t)*u)²*twoInv = (-t⁻¹)*t²*u²*twoInv = -t * u² * twoInv
    -- Wait: (-t)² = t², (-t⁻¹)*t² = -t. Not equal to -t⁻¹ * z² * twoInv with z=(-t)u = -t u, z² = t² u², -t⁻¹ * t² u² twoInv = -t u² twoInv.
    -- And left α (β u)² twoInv = -t u² twoInv. Good match.
    -- Normalize summand association so hsum applies
    have hassoc :
        (∑ u, ψ (x * u) * (χ₂ (-t) * (ψ (-t⁻¹ * ((-t) * u) ^ 2 * twoInv) *
          f ((-t) * u)))) =
          ∑ u, ψ (x * u) * (χ₂ (-t) * ψ (-t⁻¹ * ((-t) * u) ^ 2 * twoInv) *
            f ((-t) * u)) :=
      Finset.sum_congr rfl fun u _ => by ring
    calc ψ (-t⁻¹ * x ^ 2 * twoInv) * (cFourier *
          ∑ u, ψ (x * u) * (χ₂ (-t) * (ψ (-t⁻¹ * ((-t) * u) ^ 2 * twoInv) *
            f ((-t) * u))))
        = ψ (-t⁻¹ * x ^ 2 * twoInv) * (cFourier *
            ∑ u, ψ (x * u) * (χ₂ (-t) * ψ (-t⁻¹ * ((-t) * u) ^ 2 * twoInv) *
              f ((-t) * u))) := by rw [hassoc]
      _ = ψ (-t⁻¹ * x ^ 2 * twoInv) * (cFourier *
            (χ₂ (-t) * ∑ z, ψ (-t⁻¹ * x * z) *
              ψ (-t⁻¹ * z ^ 2 * twoInv) * f z)) := by rw [hsum]
      _ = ψ (-t⁻¹ * x ^ 2 * twoInv) * cFourier * χ₂ (-t) *
            ∑ z, ψ (-t⁻¹ * x * z) * ψ (-t⁻¹ * z ^ 2 * twoInv) * f z := by ring
  -- Scalar match
  have hχβ : χ₂ (-t) = -χ₂ t := by
    rw [show (-t : F) = (-1) * t by ring, map_mul, χ₂_neg_one]
    ring
  have hscal : cFourier ^ 2 * χ₂ t * (-1 : K) * gauss =
      cFourier * χ₂ (-t) := by
    have hc : cFourier * gauss = 1 := inv_mul_cancel₀ gauss_ne_zero
    rw [hχβ]
    calc cFourier ^ 2 * χ₂ t * (-1) * gauss
        = cFourier * (cFourier * gauss) * (χ₂ t * (-1)) := by ring
      _ = cFourier * 1 * (χ₂ t * (-1)) := by rw [hc]
      _ = cFourier * (-χ₂ t) := by ring
  have hsum_ord :
      (∑ z, ψ (-t⁻¹ * z ^ 2 * twoInv) * ψ (-t⁻¹ * x * z) * f z) =
        ∑ z, ψ (-t⁻¹ * x * z) * ψ (-t⁻¹ * z ^ 2 * twoInv) * f z :=
    Finset.sum_congr rfl fun z _ => by ring
  calc (Wfull ∘ₗ Nfull t ∘ₗ Wfull) f x
      = cFourier ^ 2 * χ₂ t * (-1 : K) * gauss *
          ψ (-t⁻¹ * x ^ 2 * twoInv) *
          ∑ z, ψ (-t⁻¹ * z ^ 2 * twoInv) * ψ (-t⁻¹ * x * z) * f z := hL
    _ = cFourier ^ 2 * χ₂ t * (-1 : K) * gauss *
          ψ (-t⁻¹ * x ^ 2 * twoInv) *
          ∑ z, ψ (-t⁻¹ * x * z) * ψ (-t⁻¹ * z ^ 2 * twoInv) * f z := by
        rw [hsum_ord]
    _ = (cFourier ^ 2 * χ₂ t * (-1 : K) * gauss) *
          ψ (-t⁻¹ * x ^ 2 * twoInv) *
          ∑ z, ψ (-t⁻¹ * x * z) * ψ (-t⁻¹ * z ^ 2 * twoInv) * f z := by ring
    _ = (cFourier * χ₂ (-t)) *
          ψ (-t⁻¹ * x ^ 2 * twoInv) *
          ∑ z, ψ (-t⁻¹ * x * z) * ψ (-t⁻¹ * z ^ 2 * twoInv) * f z := by
        rw [hscal]
    _ = ψ (-t⁻¹ * x ^ 2 * twoInv) * cFourier * χ₂ (-t) *
          ∑ z, ψ (-t⁻¹ * x * z) * ψ (-t⁻¹ * z ^ 2 * twoInv) * f z := by ring
    _ = (Nfull (-t⁻¹) ∘ₗ Wfull ∘ₗ Dfull (-t) (neg_ne_zero.mpr ht) ∘ₗ
          Nfull (-t⁻¹)) f x := hR.symm

end WeilWN
end V14Formalization
