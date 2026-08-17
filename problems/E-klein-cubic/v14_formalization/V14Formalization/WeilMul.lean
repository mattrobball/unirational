/-
Weil representation multiplication: Borel×Borel, operator identities.
-/
module

public import V14Formalization.WeilRepSL2
public import Mathlib.Algebra.BigOperators.Ring.Finset
public import Mathlib.NumberTheory.LegendreSymbol.QuadraticChar.Basic

open Matrix Matrix.SpecialLinearGroup BigOperators
open V14Formalization.WeilRep
open V14Formalization.WeilRepSL2

noncomputable section

namespace V14Formalization
namespace WeilMul

public abbrev F := ZMod 11
public abbrev SLG := SpecialLinearGroup (Fin 2) F

/-! ## Operator identities -/

public theorem Dfull_conj_Nfull (s t : F) (hs : s ≠ 0) :
    Dfull s hs ∘ₗ Nfull t = Nfull (s * s * t) ∘ₗ Dfull s hs := by
  apply LinearMap.ext
  intro f
  funext x
  dsimp [Dfull, Nfull, Tfull_b]
  -- ψ(t (s x)² / 2) = ψ(s² t x² / 2)
  have hψ : ψ (t * (s * x) ^ 2 * twoInv) = ψ (s * s * t * x ^ 2 * twoInv) := by
    congr 1; ring
  rw [hψ]
  ring

public theorem Dfull_mul (s t : F) (hs : s ≠ 0) (ht : t ≠ 0) :
    Dfull (s * t) (mul_ne_zero hs ht) = Dfull s hs ∘ₗ Dfull t ht := by
  apply LinearMap.ext
  intro f
  funext x
  dsimp [Dfull]
  have hχ : χ₂ (s * t) = χ₂ s * χ₂ t := map_mul χ₂ s t
  rw [hχ]
  have hx : (s * t) * x = t * (s * x) := by ring
  rw [hx]
  ring

theorem Dfull_proof_irrel (t : F) (h1 h2 : t ≠ 0) :
    Dfull t h1 = Dfull t h2 := rfl

/-- Congruence for Dfull under equality of the scaling parameter. -/
public theorem Dfull_congr {t s : F} (h : t = s) (ht : t ≠ 0) (hs : s ≠ 0) :
    Dfull t ht = Dfull s hs := by
  subst h
  exact Dfull_proof_irrel t _ _

/-! ## Borel matrix arithmetic -/

theorem ec_mul_borel {g h : SLG} (hg : ec g = 0) (hh : ec h = 0) :
    ec (g * h) = 0 := by
  change ((g : Matrix (Fin 2) (Fin 2) F) * (h : Matrix (Fin 2) (Fin 2) F)) 1 0 = 0
  rw [Matrix.mul_apply, Fin.sum_univ_two]
  change g 1 0 * h 0 0 + g 1 1 * h 1 0 = 0
  have hg10 : (g : Matrix (Fin 2) (Fin 2) F) 1 0 = 0 := hg
  have hh10 : (h : Matrix (Fin 2) (Fin 2) F) 1 0 = 0 := hh
  rw [hg10, hh10, zero_mul, mul_zero, zero_add]

public theorem ea_mul_borel {g h : SLG} (hh : ec h = 0) :
    ea (g * h) = ea g * ea h := by
  change ((g : Matrix (Fin 2) (Fin 2) F) * (h : Matrix (Fin 2) (Fin 2) F)) 0 0 =
    ea g * ea h
  rw [Matrix.mul_apply, Fin.sum_univ_two]
  change g 0 0 * h 0 0 + g 0 1 * h 1 0 = g 0 0 * h 0 0
  have hh10 : (h : Matrix (Fin 2) (Fin 2) F) 1 0 = 0 := hh
  rw [hh10, mul_zero, add_zero]

theorem eb_mul_borel {g h : SLG} :
    eb (g * h) = ea g * eb h + eb g * ed h := by
  change ((g : Matrix (Fin 2) (Fin 2) F) * (h : Matrix (Fin 2) (Fin 2) F)) 0 1 =
    ea g * eb h + eb g * ed h
  rw [Matrix.mul_apply, Fin.sum_univ_two]
  rfl

public theorem ed_of_borel {g : SLG} (hg : ec g = 0) : ed g = (ea g)⁻¹ := by
  have h := det_entries g
  change ea g * ed g - eb g * ec g = 1 at h
  rw [hg, mul_zero, sub_zero] at h
  exact eq_inv_of_mul_eq_one_right h

theorem borel_N_param {g h : SLG} (_hg : ec g = 0) (hh : ec h = 0) :
    eb (g * h) * ea (g * h) =
      eb g * ea g + ea g * ea g * (eb h * ea h) := by
  have hah := ea_ne_zero_of_ec_zero h hh
  rw [eb_mul_borel, ea_mul_borel hh, ed_of_borel hh]
  have hinv : (ea h)⁻¹ * ea h = 1 := inv_mul_cancel₀ hah
  calc (ea g * eb h + eb g * (ea h)⁻¹) * (ea g * ea h)
      = ea g * eb h * ea g * ea h + eb g * (ea h)⁻¹ * ea g * ea h := by ring
    _ = ea g * ea g * eb h * ea h + eb g * ea g * ((ea h)⁻¹ * ea h) := by ring
    _ = ea g * ea g * eb h * ea h + eb g * ea g * 1 := by rw [hinv]
    _ = ea g * ea g * (eb h * ea h) + eb g * ea g := by ring
    _ = eb g * ea g + ea g * ea g * (eb h * ea h) := by ring

/-! ## Borel operator composition -/

theorem borel_comp_expand {ag ah bg bh : F} (hag : ag ≠ 0) (hah : ah ≠ 0) :
    Nfull (bg * ag) ∘ₗ Dfull ag hag ∘ₗ Nfull (bh * ah) ∘ₗ Dfull ah hah =
      Nfull (bg * ag + ag * ag * (bh * ah)) ∘ₗ
        Dfull (ag * ah) (mul_ne_zero hag hah) := by
  have hconj :
      Dfull ag hag ∘ₗ Nfull (bh * ah) =
        Nfull (ag * ag * (bh * ah)) ∘ₗ Dfull ag hag :=
    Dfull_conj_Nfull ag (bh * ah) hag
  calc Nfull (bg * ag) ∘ₗ Dfull ag hag ∘ₗ Nfull (bh * ah) ∘ₗ Dfull ah hah
      = Nfull (bg * ag) ∘ₗ (Dfull ag hag ∘ₗ Nfull (bh * ah)) ∘ₗ Dfull ah hah := by
        ext f x; simp only [LinearMap.comp_apply]
    _ = Nfull (bg * ag) ∘ₗ (Nfull (ag * ag * (bh * ah)) ∘ₗ Dfull ag hag) ∘ₗ
          Dfull ah hah := by rw [hconj]
    _ = (Nfull (bg * ag) ∘ₗ Nfull (ag * ag * (bh * ah))) ∘ₗ
          (Dfull ag hag ∘ₗ Dfull ah hah) := by
        ext f x; simp only [LinearMap.comp_apply]
    _ = Nfull (bg * ag + ag * ag * (bh * ah)) ∘ₗ
          (Dfull ag hag ∘ₗ Dfull ah hah) := by rw [← Nfull_add]
    _ = Nfull (bg * ag + ag * ag * (bh * ah)) ∘ₗ
          Dfull (ag * ah) (mul_ne_zero hag hah) := by rw [Dfull_mul]

/-! ## Borel × Borel map_mul -/

private def borelProductNormal (g h : SLG) (hg : ec g = 0) (hh : ec h = 0) :
    Fun →ₗ[K] Fun :=
  Nfull (eb g * ea g + ea g * ea g * (eb h * ea h)) ∘ₗ
    Dfull (ea g * ea h)
      (mul_ne_zero (ea_ne_zero_of_ec_zero g hg) (ea_ne_zero_of_ec_zero h hh))

private theorem borelFun_mul_eq_normal {g h : SLG}
    (hg : ec g = 0) (hh : ec h = 0) :
    borelFun (g * h) (ec_mul_borel hg hh) = borelProductNormal g h hg hh := by
  let hgh := ec_mul_borel hg hh
  let hag := ea_ne_zero_of_ec_zero g hg
  let hah := ea_ne_zero_of_ec_zero h hh
  let hagh := ea_ne_zero_of_ec_zero (g * h) hgh
  change Nfull (eb (g * h) * ea (g * h)) ∘ₗ Dfull (ea (g * h)) hagh =
    borelProductNormal g h hg hh
  have hparam := borel_N_param hg hh
  have hea := ea_mul_borel (g := g) hh
  have hN : Nfull (eb (g * h) * ea (g * h)) =
      Nfull (eb g * ea g + ea g * ea g * (eb h * ea h)) := by rw [hparam]
  have hD : Dfull (ea (g * h)) hagh =
      Dfull (ea g * ea h) (mul_ne_zero hag hah) :=
    Dfull_congr hea hagh (mul_ne_zero hag hah)
  rw [hN, hD]
  rfl

private theorem borelFun_comp_apply_eq_normal {g h : SLG}
    (hg : ec g = 0) (hh : ec h = 0) (f : Fun) :
    (borelFun g hg ∘ₗ borelFun h hh) f = borelProductNormal g h hg hh f := by
  let hag := ea_ne_zero_of_ec_zero g hg
  let hah := ea_ne_zero_of_ec_zero h hh
  let bg := eb g * ea g
  let bh := eb h * ea h
  let middle := ea g * ea g * bh
  change Nfull bg (Dfull (ea g) hag (Nfull bh (Dfull (ea h) hah f))) =
    Nfull (bg + middle)
      (Dfull (ea g * ea h) (mul_ne_zero hag hah) f)
  have hconj := congrArg (fun L : Fun →ₗ[K] Fun => L (Dfull (ea h) hah f))
    (Dfull_conj_Nfull (ea g) bh hag)
  have hadd := congrArg (fun L : Fun →ₗ[K] Fun =>
      L (Dfull (ea g) hag (Dfull (ea h) hah f))) (Nfull_add bg middle)
  have hmul := congrArg (fun L : Fun →ₗ[K] Fun => L f)
    (Dfull_mul (ea g) (ea h) hag hah)
  calc
    Nfull bg (Dfull (ea g) hag (Nfull bh (Dfull (ea h) hah f))) =
        Nfull bg (Nfull middle (Dfull (ea g) hag (Dfull (ea h) hah f))) :=
      congrArg (Nfull bg) hconj
    _ = Nfull (bg + middle) (Dfull (ea g) hag (Dfull (ea h) hah f)) := by
      simpa only [LinearMap.comp_apply] using hadd.symm
    _ = Nfull (bg + middle)
        (Dfull (ea g * ea h) (mul_ne_zero hag hah) f) := by
      exact congrArg (Nfull (bg + middle)) hmul.symm

theorem weilFun_mul_borel {g h : SLG} (hg : ec g = 0) (hh : ec h = 0) :
    weilFun (g * h) = weilFun g ∘ₗ weilFun h := by
  let hgh := ec_mul_borel hg hh
  apply LinearMap.ext
  intro f
  have hgh' : weilFun (g * h) = borelFun (g * h) hgh := by
    dsimp [weilFun]
    rw [dif_pos hgh]
  have hg' : weilFun g = borelFun g hg := by
    dsimp [weilFun]
    rw [dif_pos hg]
  have hh' : weilFun h = borelFun h hh := by
    dsimp [weilFun]
    rw [dif_pos hh]
  calc
    weilFun (g * h) f = borelFun (g * h) hgh f := congrArg (fun L => L f) hgh'
    _ = borelProductNormal g h hg hh f :=
      congrArg (fun L : Fun →ₗ[K] Fun => L f) (borelFun_mul_eq_normal hg hh)
    _ = (borelFun g hg ∘ₗ borelFun h hh) f :=
      (borelFun_comp_apply_eq_normal hg hh f).symm
    _ = (weilFun g ∘ₗ weilFun h) f := by rw [hg', hh']

public theorem weilU_mul_borel {g h : SLG} (hg : ec g = 0) (hh : ec h = 0) :
    weilU (g * h) = weilU g ∘ₗ weilU h := by
  apply LinearMap.ext
  intro f
  apply Subtype.ext
  have h := congr_arg (fun L : Fun →ₗ[K] Fun => L f.1) (weilFun_mul_borel hg hh)
  simpa [LinearMap.comp_apply, weilU] using h

/-! ## Quadratic character: χ(s⁻¹) = χ(s) for s ≠ 0 -/

public theorem χ₂_sq_one {s : F} (hs : s ≠ 0) : χ₂ s * χ₂ s = 1 := by
  have hℤ : (quadraticChar (ZMod 11) s) ^ 2 = 1 :=
    quadraticChar_sq_one (F := ZMod 11) hs
  have hℤ' : χ₂ℤ s * χ₂ℤ s = 1 := by
    simpa [χ₂ℤ, pow_two] using hℤ
  calc χ₂ s * χ₂ s
      = (algebraMap ℤ K) (χ₂ℤ s) * (algebraMap ℤ K) (χ₂ℤ s) := rfl
    _ = (algebraMap ℤ K) (χ₂ℤ s * χ₂ℤ s) := (map_mul _ _ _).symm
    _ = (algebraMap ℤ K) 1 := by rw [hℤ']
    _ = 1 := map_one _

public theorem χ₂_inv {s : F} (hs : s ≠ 0) : χ₂ s⁻¹ = χ₂ s := by
  have h1 : χ₂ s * χ₂ s⁻¹ = 1 := by
    rw [← map_mul, mul_inv_cancel₀ hs, χ₂_one]
  have hsq := χ₂_sq_one hs
  have heq : χ₂ s * χ₂ s = χ₂ s * χ₂ s⁻¹ := by rw [hsq, h1]
  have hne : χ₂ s ≠ 0 := by
    intro hz
    have : (0 : K) = 1 := by
      calc (0 : K) = χ₂ s * χ₂ s := by rw [hz, zero_mul]
        _ = 1 := hsq
    exact zero_ne_one this
  exact (mul_left_cancel₀ hne heq).symm

/-! ## Fourier–diagonal: D(s) ∘ W = W ∘ D(s⁻¹) -/

public theorem Dfull_conj_Wfull (s : F) (hs : s ≠ 0) :
    Dfull s hs ∘ₗ Wfull = Wfull ∘ₗ Dfull s⁻¹ (inv_ne_zero hs) := by
  apply LinearMap.ext
  intro f
  funext x
  dsimp [Dfull, Wfull, Sfull]
  classical
  have hχ := χ₂_inv hs
  have hbij : Function.Bijective (fun z : ZMod 11 => s * z) := by
    refine ⟨mul_right_injective₀ hs, fun w => ⟨s⁻¹ * w, ?_⟩⟩
    calc s * (s⁻¹ * w) = (s * s⁻¹) * w := by ring
      _ = (1 : F) * w := by rw [mul_inv_cancel₀ hs]
      _ = w := one_mul w
  -- ∑_y ψ(x y) χ(s⁻¹) f(s⁻¹ y) = χ(s⁻¹) ∑_z ψ((s x) z) f z
  have hsum :
      (∑ y : ZMod 11, ψ (x * y) * (χ₂ s⁻¹ * f (s⁻¹ * y))) =
        χ₂ s⁻¹ * ∑ z : ZMod 11, ψ ((s * x) * z) * f z := by
    have hre :
        (∑ z : ZMod 11, ψ (x * (s * z)) * (χ₂ s⁻¹ * f (s⁻¹ * (s * z)))) =
          ∑ y : ZMod 11, ψ (x * y) * (χ₂ s⁻¹ * f (s⁻¹ * y)) :=
      Fintype.sum_bijective (fun z : ZMod 11 => s * z) hbij
        (fun z => ψ (x * (s * z)) * (χ₂ s⁻¹ * f (s⁻¹ * (s * z))))
        (fun y => ψ (x * y) * (χ₂ s⁻¹ * f (s⁻¹ * y)))
        (fun _ => rfl)
    calc (∑ y : ZMod 11, ψ (x * y) * (χ₂ s⁻¹ * f (s⁻¹ * y)))
        = ∑ z : ZMod 11, ψ (x * (s * z)) * (χ₂ s⁻¹ * f (s⁻¹ * (s * z))) := hre.symm
      _ = ∑ z : ZMod 11, ψ (x * (s * z)) * (χ₂ s⁻¹ * f z) := by
          apply Finset.sum_congr rfl
          intro z _
          have : s⁻¹ * (s * z) = z := by
            calc s⁻¹ * (s * z) = (s⁻¹ * s) * z := by ring
              _ = (1 : F) * z := by rw [inv_mul_cancel₀ hs]
              _ = z := one_mul z
          rw [this]
      _ = χ₂ s⁻¹ * ∑ z : ZMod 11, ψ ((s * x) * z) * f z := by
          rw [Finset.mul_sum]
          apply Finset.sum_congr rfl
          intro z _
          have : x * (s * z) = (s * x) * z := by ring
          rw [this]
          ring
  calc χ₂ s * (cFourier * ∑ y : ZMod 11, ψ ((s * x) * y) * f y)
      = cFourier * (χ₂ s * ∑ y : ZMod 11, ψ ((s * x) * y) * f y) := by ring
    _ = cFourier * (χ₂ s⁻¹ * ∑ y : ZMod 11, ψ ((s * x) * y) * f y) := by rw [hχ]
    _ = cFourier * ∑ y : ZMod 11, ψ (x * y) * (χ₂ s⁻¹ * f (s⁻¹ * y)) := by
        rw [← hsum]

/-! ## Reflection R f (x) = f(-x); W² = -R -/

@[expose] public def Rfull : Fun →ₗ[K] Fun where
  toFun f := fun x => f (-x)
  map_add' := by intro f g; funext x; rfl
  map_smul' := by intro r f; funext x; rfl

public theorem Rfull_sq : Rfull ∘ₗ Rfull = LinearMap.id := by
  ext f x
  dsimp [Rfull]
  rw [neg_neg]

public theorem Wfull_sq_R : Wfull ∘ₗ Wfull = -Rfull := by
  apply LinearMap.ext
  intro f
  funext x
  dsimp [Wfull, Rfull]
  simpa [LinearMap.comp_apply, LinearMap.neg_apply] using Sfull_sq_apply f x

public theorem Rfull_Nfull (t : F) : Rfull ∘ₗ Nfull t = Nfull t ∘ₗ Rfull := by
  apply LinearMap.ext
  intro f
  funext x
  dsimp [Rfull, Nfull, Tfull_b]
  -- ψ(t (-x)²) f(-x) = ψ(t x²) f(-x)
  have : (-x) ^ 2 = x ^ 2 := by ring
  rw [this]

theorem Rfull_Dfull (s : F) (hs : s ≠ 0) :
    Rfull ∘ₗ Dfull s hs = Dfull s hs ∘ₗ Rfull := by
  apply LinearMap.ext
  intro f
  funext x
  dsimp [Rfull, Dfull]
  have : s * (-x) = -(s * x) := by ring
  rw [this]

/-! ## Product lower-left entry formulas -/

public theorem ec_mul_borel_big {g h : SLG} (hg : ec g = 0) :
    ec (g * h) = ed g * ec h := by
  change ((g : Matrix (Fin 2) (Fin 2) F) * (h : Matrix (Fin 2) (Fin 2) F)) 1 0 =
    ed g * ec h
  rw [Matrix.mul_apply, Fin.sum_univ_two]
  change g 1 0 * h 0 0 + g 1 1 * h 1 0 = ed g * ec h
  have hg10 : (g : Matrix (Fin 2) (Fin 2) F) 1 0 = 0 := hg
  rw [hg10, zero_mul, zero_add]
  rfl

public theorem ec_mul_big_borel {g h : SLG} (hh : ec h = 0) :
    ec (g * h) = ec g * ea h := by
  change ((g : Matrix (Fin 2) (Fin 2) F) * (h : Matrix (Fin 2) (Fin 2) F)) 1 0 =
    ec g * ea h
  rw [Matrix.mul_apply, Fin.sum_univ_two]
  change g 1 0 * h 0 0 + g 1 1 * h 1 0 = ec g * ea h
  have hh10 : (h : Matrix (Fin 2) (Fin 2) F) 1 0 = 0 := hh
  rw [hh10, mul_zero, add_zero]
  rfl

public theorem ec_borel_big_ne {g h : SLG} (hg : ec g = 0) (hh : ec h ≠ 0) :
    ec (g * h) ≠ 0 := by
  rw [ec_mul_borel_big hg]
  have ha := ea_ne_zero_of_ec_zero g hg
  have hed : ed g = (ea g)⁻¹ := ed_of_borel hg
  rw [hed]
  exact mul_ne_zero (inv_ne_zero ha) hh

public theorem ec_big_borel_ne {g h : SLG} (hg : ec g ≠ 0) (hh : ec h = 0) :
    ec (g * h) ≠ 0 := by
  rw [ec_mul_big_borel hh]
  exact mul_ne_zero hg (ea_ne_zero_of_ec_zero h hh)


/-! ## Quadratic character values used by Fourier conjugation -/

public theorem χ₂_two : χ₂ (2 : F) = -1 := by
  have hℤ : χ₂ℤ (2 : ZMod 11) = -1 := by
    change quadraticChar (ZMod 11) 2 = -1
    exact quadraticChar_neg_one_iff_not_isSquare.mpr
      (by decide : ¬ IsSquare (2 : ZMod 11))
  change (algebraMap ℤ K) (χ₂ℤ 2) = -1
  rw [hℤ, map_neg, map_one]

theorem χ₂_neg_two : χ₂ (-2 : F) = 1 := by
  have : (-2 : F) = (-1) * (2 : F) := by ring
  rw [this, map_mul, χ₂_neg_one, χ₂_two]
  ring

end WeilMul
end V14Formalization
