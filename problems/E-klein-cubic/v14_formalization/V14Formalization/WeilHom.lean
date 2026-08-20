/-
Complete monoidHom SL₂ → End(U) for the even Weil representation.

Big-cell factors carry a global minus (metaplectic sign) so that
D(−ec) ≡ −D(ec) on the even module U is absorbed into a true homomorphism.
-/
module

public import V14Formalization.WeilMul
public import V14Formalization.WeilWN

open Matrix Matrix.SpecialLinearGroup
open V14Formalization.WeilRep
open V14Formalization.WeilRepSL2
open V14Formalization.WeilMul
open V14Formalization.WeilWN

noncomputable section

namespace V14Formalization
namespace WeilHom

public abbrev F := ZMod 11
public abbrev SLG := SpecialLinearGroup (Fin 2) F

public theorem weilFun_of_big {g : SLG} (hg : ec g ≠ 0) :
    weilFun g = - bigCellPos g hg := by
  dsimp [weilFun, bigCellFun]
  rw [dif_neg hg]

theorem ea_mul_general (g h : SLG) :
    ea (g * h) = ea g * ea h + eb g * ec h := by
  change ((g : Matrix (Fin 2) (Fin 2) F) * h) 0 0 = _
  rw [Matrix.mul_apply, Fin.sum_univ_two]
  rfl

theorem ed_mul_borel_right {g h : SLG} (hg : ec g = 0) :
    ed (g * h) = ed g * ed h := by
  change ((g : Matrix (Fin 2) (Fin 2) F) * h) 1 1 = _
  rw [Matrix.mul_apply, Fin.sum_univ_two]
  have hg10 : (g : Matrix (Fin 2) (Fin 2) F) 1 0 = 0 := hg
  rw [hg10, zero_mul, zero_add]
  rfl

theorem ec_mul_general (g h : SLG) :
    ec (g * h) = ec g * ea h + ed g * ec h := by
  change ((g : Matrix (Fin 2) (Fin 2) F) * h) 1 0 = _
  rw [Matrix.mul_apply, Fin.sum_univ_two]
  rfl

/-! ## Borel × Big -/

theorem weilFun_mul_borel_big {g h : SLG} (hg : ec g = 0) (hh : ec h ≠ 0) :
    weilFun (g * h) = weilFun g ∘ₗ weilFun h := by
  have hgh_ne := ec_borel_big_ne hg hh
  have hag := ea_ne_zero_of_ec_zero g hg
  have hed_g : ed g = (ea g)⁻¹ := ed_of_borel hg
  have hec_gh : ec (g * h) = (ea g)⁻¹ * ec h := by
    rw [ec_mul_borel_big hg, hed_g]
  have hform_g : weilFun g = Nfull (eb g * ea g) ∘ₗ Dfull (ea g) hag := by
    dsimp [weilFun]; rw [dif_pos hg]; rfl
  rw [hform_g, weilFun_of_big hh, weilFun_of_big hgh_ne]
  -- −Pos(gh) = borel_g ∘ (−Pos h)  ⇔  Pos(gh) = borel_g ∘ Pos h
  have hpos :
      bigCellPos (g * h) hgh_ne =
        Nfull (eb g * ea g) ∘ₗ Dfull (ea g) hag ∘ₗ bigCellPos h hh := by
    dsimp [bigCellPos]
    have hconjN := Dfull_conj_Nfull (ea g) (ea h * (ec h)⁻¹) hag
    have hconjW := Dfull_conj_Wfull (ea g) hag
    have hrhs :
        Nfull (eb g * ea g) ∘ₗ Dfull (ea g) hag ∘ₗ Nfull (ea h * (ec h)⁻¹) ∘ₗ
            Wfull ∘ₗ Dfull (ec h) hh ∘ₗ Nfull ((ec h)⁻¹ * ed h) =
          Nfull (eb g * ea g + ea g * ea g * (ea h * (ec h)⁻¹)) ∘ₗ Wfull ∘ₗ
            Dfull ((ea g)⁻¹ * ec h) (mul_ne_zero (inv_ne_zero hag) hh) ∘ₗ
            Nfull ((ec h)⁻¹ * ed h) := by
      calc Nfull (eb g * ea g) ∘ₗ Dfull (ea g) hag ∘ₗ Nfull (ea h * (ec h)⁻¹) ∘ₗ
              Wfull ∘ₗ Dfull (ec h) hh ∘ₗ Nfull ((ec h)⁻¹ * ed h)
          = Nfull (eb g * ea g) ∘ₗ (Dfull (ea g) hag ∘ₗ Nfull (ea h * (ec h)⁻¹)) ∘ₗ
              Wfull ∘ₗ Dfull (ec h) hh ∘ₗ Nfull ((ec h)⁻¹ * ed h) := by
              ext f x; simp only [LinearMap.comp_apply]
        _ = Nfull (eb g * ea g) ∘ₗ (Nfull (ea g * ea g * (ea h * (ec h)⁻¹)) ∘ₗ
              Dfull (ea g) hag) ∘ₗ Wfull ∘ₗ Dfull (ec h) hh ∘ₗ
              Nfull ((ec h)⁻¹ * ed h) := by rw [hconjN]
        _ = (Nfull (eb g * ea g) ∘ₗ Nfull (ea g * ea g * (ea h * (ec h)⁻¹))) ∘ₗ
              (Dfull (ea g) hag ∘ₗ Wfull) ∘ₗ Dfull (ec h) hh ∘ₗ
              Nfull ((ec h)⁻¹ * ed h) := by
              ext f x; simp only [LinearMap.comp_apply]
        _ = Nfull (eb g * ea g + ea g * ea g * (ea h * (ec h)⁻¹)) ∘ₗ
              (Dfull (ea g) hag ∘ₗ Wfull) ∘ₗ Dfull (ec h) hh ∘ₗ
              Nfull ((ec h)⁻¹ * ed h) := by rw [← Nfull_add]
        _ = Nfull (eb g * ea g + ea g * ea g * (ea h * (ec h)⁻¹)) ∘ₗ
              (Wfull ∘ₗ Dfull (ea g)⁻¹ (inv_ne_zero hag)) ∘ₗ Dfull (ec h) hh ∘ₗ
              Nfull ((ec h)⁻¹ * ed h) := by rw [hconjW]
        _ = Nfull (eb g * ea g + ea g * ea g * (ea h * (ec h)⁻¹)) ∘ₗ Wfull ∘ₗ
              (Dfull (ea g)⁻¹ (inv_ne_zero hag) ∘ₗ Dfull (ec h) hh) ∘ₗ
              Nfull ((ec h)⁻¹ * ed h) := by
              ext f x; simp only [LinearMap.comp_apply]
        _ = Nfull (eb g * ea g + ea g * ea g * (ea h * (ec h)⁻¹)) ∘ₗ Wfull ∘ₗ
              Dfull ((ea g)⁻¹ * ec h) (mul_ne_zero (inv_ne_zero hag) hh) ∘ₗ
              Nfull ((ec h)⁻¹ * ed h) := by rw [Dfull_mul]
    have hNparam :
        ea (g * h) * (ec (g * h))⁻¹ =
          eb g * ea g + ea g * ea g * (ea h * (ec h)⁻¹) := by
      rw [ea_mul_general g h, hec_gh]
      have hinv_ec : ((ea g)⁻¹ * ec h)⁻¹ = (ec h)⁻¹ * ea g := by
        rw [_root_.mul_inv_rev, inv_inv]
      rw [hinv_ec]
      have : ec h * (ec h)⁻¹ = 1 := mul_inv_cancel₀ hh
      calc (ea g * ea h + eb g * ec h) * ((ec h)⁻¹ * ea g)
          = ea g * ea h * (ec h)⁻¹ * ea g + eb g * ec h * (ec h)⁻¹ * ea g := by ring
        _ = ea g * ea g * ea h * (ec h)⁻¹ + eb g * ea g * (ec h * (ec h)⁻¹) := by ring
        _ = ea g * ea g * ea h * (ec h)⁻¹ + eb g * ea g * 1 := by rw [this]
        _ = ea g * ea g * (ea h * (ec h)⁻¹) + eb g * ea g * 1 := by ring
        _ = eb g * ea g + ea g * ea g * (ea h * (ec h)⁻¹) := by ring
    have hNparam2 :
        (ec (g * h))⁻¹ * ed (g * h) = (ec h)⁻¹ * ed h := by
      rw [ed_mul_borel_right hg, hec_gh, hed_g]
      have hinv : ((ea g)⁻¹ * ec h)⁻¹ = (ec h)⁻¹ * ea g := by
        rw [_root_.mul_inv_rev, inv_inv]
      rw [hinv]
      have : ea g * (ea g)⁻¹ = 1 := mul_inv_cancel₀ hag
      calc (ec h)⁻¹ * ea g * ((ea g)⁻¹ * ed h)
          = (ec h)⁻¹ * (ea g * (ea g)⁻¹) * ed h := by ring
        _ = (ec h)⁻¹ * 1 * ed h := by rw [this]
        _ = (ec h)⁻¹ * ed h := by ring
    have hN' : Nfull (ea (g * h) * (ec (g * h))⁻¹) =
        Nfull (eb g * ea g + ea g * ea g * (ea h * (ec h)⁻¹)) := by rw [hNparam]
    have hD' : Dfull (ec (g * h)) hgh_ne =
        Dfull ((ea g)⁻¹ * ec h) (mul_ne_zero (inv_ne_zero hag) hh) :=
      Dfull_congr hec_gh hgh_ne (mul_ne_zero (inv_ne_zero hag) hh)
    have hN2' : Nfull ((ec (g * h))⁻¹ * ed (g * h)) =
        Nfull ((ec h)⁻¹ * ed h) := by rw [hNparam2]
    rw [hN', hD', hN2']
    exact hrhs.symm
  rw [hpos]
  apply LinearMap.ext; intro φ
  simp only [LinearMap.comp_apply, LinearMap.neg_apply, map_neg]

/-! ## N–D commutation -/

theorem Nfull_Dfull (t s : F) (hs : s ≠ 0) :
    Nfull t ∘ₗ Dfull s hs =
      Dfull s hs ∘ₗ Nfull (s⁻¹ * s⁻¹ * t) := by
  have h := Dfull_conj_Nfull s (s⁻¹ * s⁻¹ * t) hs
  have hs2 : s * s * (s⁻¹ * s⁻¹ * t) = t := by
    have : s * s⁻¹ = 1 := mul_inv_cancel₀ hs
    calc s * s * (s⁻¹ * s⁻¹ * t) = (s * s⁻¹) * (s * s⁻¹) * t := by ring
      _ = (1 : F) * 1 * t := by rw [this]
      _ = t := by ring
  have h' : Dfull s hs ∘ₗ Nfull (s⁻¹ * s⁻¹ * t) =
      Nfull t ∘ₗ Dfull s hs := by
    simpa [hs2] using h
  exact h'.symm

/-! ## Big × Borel -/

theorem ea_mul_big_borel {g h : SLG} (hh : ec h = 0) :
    ea (g * h) = ea g * ea h :=
  ea_mul_borel (g := g) hh

theorem ed_mul_big_borel {g h : SLG} (_hh : ec h = 0) :
    ed (g * h) = ec g * eb h + ed g * ed h := by
  change ((g : Matrix (Fin 2) (Fin 2) F) * h) 1 1 = _
  rw [Matrix.mul_apply, Fin.sum_univ_two]
  rfl

private theorem big_borel_N1_param {g h : SLG} (hg : ec g ≠ 0) (hh : ec h = 0) :
    ea (g * h) * (ec (g * h))⁻¹ = ea g * (ec g)⁻¹ := by
  have hah := ea_ne_zero_of_ec_zero h hh
  rw [ea_mul_big_borel hh, ec_mul_big_borel hh, _root_.mul_inv_rev]
  calc
    (ea g * ea h) * ((ea h)⁻¹ * (ec g)⁻¹) =
        ea g * (ea h * (ea h)⁻¹) * (ec g)⁻¹ := by ring
    _ = ea g * 1 * (ec g)⁻¹ := by rw [mul_inv_cancel₀ hah]
    _ = ea g * (ec g)⁻¹ := by ring

private theorem big_borel_N2_param {g h : SLG} (hg : ec g ≠ 0) (hh : ec h = 0) :
    (ec (g * h))⁻¹ * ed (g * h) =
      (ec g * ea h)⁻¹ * (ec g * ea h)⁻¹ *
        (ec g * ec g * ((ec g)⁻¹ * ed g + eb h * ea h)) := by
  have hah := ea_ne_zero_of_ec_zero h hh
  have hed_h : ed h = (ea h)⁻¹ := ed_of_borel hh
  rw [ec_mul_big_borel hh, ed_mul_big_borel hh, hed_h]
  have hinv : (ec g * ea h)⁻¹ = (ea h)⁻¹ * (ec g)⁻¹ := by
    rw [_root_.mul_inv_rev]
  have hs' :
      (ec g * ea h)⁻¹ * (ec g * ea h)⁻¹ *
          (ec g * ec g * ((ec g)⁻¹ * ed g + eb h * ea h)) =
        (ea h)⁻¹ * eb h + (ec g)⁻¹ * ed g * (ea h)⁻¹ * (ea h)⁻¹ := by
    rw [hinv]
    have hcg : (ec g)⁻¹ * ec g = 1 := inv_mul_cancel₀ hg
    calc
      ((ea h)⁻¹ * (ec g)⁻¹) * ((ea h)⁻¹ * (ec g)⁻¹) *
            (ec g * ec g * ((ec g)⁻¹ * ed g + eb h * ea h)) =
          (ea h)⁻¹ * (ea h)⁻¹ * (ec g)⁻¹ * (ec g)⁻¹ * ec g * ec g *
            ((ec g)⁻¹ * ed g + eb h * ea h) := by ring
      _ = (ea h)⁻¹ * (ea h)⁻¹ * ((ec g)⁻¹ * ec g) * ((ec g)⁻¹ * ec g) *
            ((ec g)⁻¹ * ed g + eb h * ea h) := by ring
      _ = (ea h)⁻¹ * (ea h)⁻¹ * 1 * 1 *
            ((ec g)⁻¹ * ed g + eb h * ea h) := by rw [hcg]
      _ = (ea h)⁻¹ * (ea h)⁻¹ * ((ec g)⁻¹ * ed g) +
            (ea h)⁻¹ * (ea h)⁻¹ * (eb h * ea h) := by ring
      _ = (ec g)⁻¹ * ed g * (ea h)⁻¹ * (ea h)⁻¹ +
            (ea h)⁻¹ * eb h * ((ea h)⁻¹ * ea h) := by ring
      _ = (ec g)⁻¹ * ed g * (ea h)⁻¹ * (ea h)⁻¹ +
            (ea h)⁻¹ * eb h * 1 := by rw [inv_mul_cancel₀ hah]
      _ = (ea h)⁻¹ * eb h + (ec g)⁻¹ * ed g * (ea h)⁻¹ * (ea h)⁻¹ := by ring
  have hL :
      (ec g * ea h)⁻¹ * (ec g * eb h + ed g * (ea h)⁻¹) =
        (ea h)⁻¹ * eb h + (ec g)⁻¹ * ed g * (ea h)⁻¹ * (ea h)⁻¹ := by
    rw [hinv]
    have hcg : (ec g)⁻¹ * ec g = 1 := inv_mul_cancel₀ hg
    calc
      ((ea h)⁻¹ * (ec g)⁻¹) * (ec g * eb h + ed g * (ea h)⁻¹) =
          (ea h)⁻¹ * (ec g)⁻¹ * ec g * eb h +
            (ea h)⁻¹ * (ec g)⁻¹ * ed g * (ea h)⁻¹ := by ring
      _ = (ea h)⁻¹ * ((ec g)⁻¹ * ec g) * eb h +
            (ec g)⁻¹ * ed g * (ea h)⁻¹ * (ea h)⁻¹ := by ring
      _ = (ea h)⁻¹ * 1 * eb h +
            (ec g)⁻¹ * ed g * (ea h)⁻¹ * (ea h)⁻¹ := by rw [hcg]
      _ = (ea h)⁻¹ * eb h + (ec g)⁻¹ * ed g * (ea h)⁻¹ * (ea h)⁻¹ := by ring
  exact hL.trans hs'.symm

private def bigBorelNormal (g h : SLG) (hg : ec g ≠ 0) (hh : ec h = 0) :
    Fun →ₗ[K] Fun :=
  let hah := ea_ne_zero_of_ec_zero h hh
  Nfull (ea g * (ec g)⁻¹) ∘ₗ Wfull ∘ₗ
    Dfull (ec g * ea h) (mul_ne_zero hg hah) ∘ₗ
    Nfull ((ec g * ea h)⁻¹ * (ec g * ea h)⁻¹ *
      (ec g * ec g * ((ec g)⁻¹ * ed g + eb h * ea h)))

private theorem bigCellPos_mul_eq_bigBorelNormal {g h : SLG}
    (hg : ec g ≠ 0) (hh : ec h = 0) :
    bigCellPos (g * h) (ec_big_borel_ne hg hh) = bigBorelNormal g h hg hh := by
  let hah := ea_ne_zero_of_ec_zero h hh
  let hgh := ec_big_borel_ne hg hh
  change Nfull (ea (g * h) * (ec (g * h))⁻¹) ∘ₗ Wfull ∘ₗ
      Dfull (ec (g * h)) hgh ∘ₗ Nfull ((ec (g * h))⁻¹ * ed (g * h)) =
    bigBorelNormal g h hg hh
  have hN1 := congrArg Nfull (big_borel_N1_param hg hh)
  have hD := Dfull_congr (ec_mul_big_borel hh) hgh (mul_ne_zero hg hah)
  have hN2 := congrArg Nfull (big_borel_N2_param hg hh)
  rw [hN1, hD, hN2]
  rfl

private theorem bigBorel_comp_apply_eq_normal {g h : SLG}
    (hg : ec g ≠ 0) (hh : ec h = 0) (f : Fun) :
    (bigCellPos g hg ∘ₗ Nfull (eb h * ea h) ∘ₗ
      Dfull (ea h) (ea_ne_zero_of_ec_zero h hh)) f = bigBorelNormal g h hg hh f := by
  let hah := ea_ne_zero_of_ec_zero h hh
  let n := (ec g)⁻¹ * ed g + eb h * ea h
  let t := ec g * ec g * n
  let s := ec g * ea h
  let u := s⁻¹ * s⁻¹ * t
  have hNadd := congrArg (fun L : Fun →ₗ[K] Fun => L (Dfull (ea h) hah f))
    (Nfull_add ((ec g)⁻¹ * ed g) (eb h * ea h))
  have hconj := congrArg (fun L : Fun →ₗ[K] Fun => L (Dfull (ea h) hah f))
    (Dfull_conj_Nfull (ec g) n hg)
  have hDmul := congrArg (fun L : Fun →ₗ[K] Fun => L f)
    (Dfull_mul (ec g) (ea h) hg hah)
  have hND := congrArg (fun L : Fun →ₗ[K] Fun => L f)
    (Nfull_Dfull t s (mul_ne_zero hg hah))
  change Nfull (ea g * (ec g)⁻¹)
      (Wfull (Dfull (ec g) hg
        (Nfull ((ec g)⁻¹ * ed g)
          (Nfull (eb h * ea h) (Dfull (ea h) hah f))))) =
    Nfull (ea g * (ec g)⁻¹)
      (Wfull (Dfull s (mul_ne_zero hg hah) (Nfull u f)))
  apply congrArg (fun z => Nfull (ea g * (ec g)⁻¹) (Wfull z))
  calc
    Dfull (ec g) hg
        (Nfull ((ec g)⁻¹ * ed g)
          (Nfull (eb h * ea h) (Dfull (ea h) hah f))) =
      Dfull (ec g) hg (Nfull n (Dfull (ea h) hah f)) := by
        exact congrArg (Dfull (ec g) hg) (by simpa [n, LinearMap.comp_apply] using hNadd.symm)
    _ = Nfull t (Dfull (ec g) hg (Dfull (ea h) hah f)) := by
      simpa [n, t, LinearMap.comp_apply] using hconj
    _ = Nfull t (Dfull s (mul_ne_zero hg hah) f) := by
      exact congrArg (Nfull t) (by simpa [s, LinearMap.comp_apply] using hDmul.symm)
    _ = Dfull s (mul_ne_zero hg hah) (Nfull u f) := by
      simpa [t, s, u, LinearMap.comp_apply] using hND

public theorem weilFun_mul_big_borel {g h : SLG} (hg : ec g ≠ 0) (hh : ec h = 0) :
    weilFun (g * h) = weilFun g ∘ₗ weilFun h := by
  apply LinearMap.ext
  intro f
  have hgh := ec_big_borel_ne hg hh
  have hah := ea_ne_zero_of_ec_zero h hh
  have hL := congrArg (fun L : Fun →ₗ[K] Fun => L f)
    (bigCellPos_mul_eq_bigBorelNormal hg hh)
  have hR := bigBorel_comp_apply_eq_normal hg hh f
  rw [weilFun_of_big hgh, weilFun_of_big hg]
  have hform : weilFun h = Nfull (eb h * ea h) ∘ₗ Dfull (ea h) hah := by
    dsimp [weilFun]
    rw [dif_pos hh]
    rfl
  rw [hform]
  simpa only [LinearMap.comp_apply, LinearMap.neg_apply] using
    congrArg (fun z : Fun => -z) (hL.trans hR.symm)

/-! ## D(−1) = −R; on even functions R = id so D(−1) = −id -/

theorem Dfull_neg_one :
    Dfull (-1 : F) (by decide : (-1 : F) ≠ 0) = -Rfull := by
  apply LinearMap.ext; intro f; funext x
  dsimp [Dfull, Rfull]
  rw [χ₂_neg_one]
  have : (-1 : F) * x = -x := by ring
  rw [this]
  ring

theorem Dfull_neg (t : F) (ht : t ≠ 0) :
    Dfull (-t) (neg_ne_zero.mpr ht) =
      Dfull (-1 : F) (by decide) ∘ₗ Dfull t ht := by
  have h : (-t : F) = (-1) * t := by ring
  exact (Dfull_congr h (neg_ne_zero.mpr ht)
    (mul_ne_zero (by decide : (-1 : F) ≠ 0) ht)).trans
    (Dfull_mul (-1) t (by decide) ht)

/-- On even functions, R acts as the identity. -/
theorem Rfull_even {f : Fun} (hf : ∀ x, f (-x) = f x) (x : ZMod 11) :
    Rfull f x = f x := by
  dsimp [Rfull]; exact hf x

/-- On even functions, D(−t) = − D(t). -/
theorem Dfull_neg_even (t : F) (ht : t ≠ 0) {f : Fun}
    (hf : ∀ x, f (-x) = f x) (x : ZMod 11) :
    Dfull (-t) (neg_ne_zero.mpr ht) f x = - Dfull t ht f x := by
  have hD := Dfull_neg t ht
  have hR : Rfull (Dfull t ht f) x = Dfull t ht f x := by
    apply Rfull_even
    intro y; exact Dfull_preserves_even t ht hf y
  -- D(-t) f = D(-1) (D t f) = (-R) (D t f) = - R (D t f)
  calc Dfull (-t) (neg_ne_zero.mpr ht) f x
      = (Dfull (-1 : F) (by decide) ∘ₗ Dfull t ht) f x := by rw [hD]
    _ = Dfull (-1 : F) (by decide) (Dfull t ht f) x := rfl
    _ = (-Rfull) (Dfull t ht f) x := by rw [Dfull_neg_one]
    _ = - Rfull (Dfull t ht f) x := by simp [LinearMap.neg_apply]
    _ = - Dfull t ht f x := by rw [hR]

/-! ## W N W re-export -/

theorem W_N_W (t : F) (ht : t ≠ 0) :
    Wfull ∘ₗ Nfull t ∘ₗ Wfull =
      Nfull (-t⁻¹) ∘ₗ Wfull ∘ₗ Dfull (-t) (neg_ne_zero.mpr ht) ∘ₗ Nfull (-t⁻¹) :=
  Wfull_Nfull_Wfull t ht

/-! ## Positive kernels of two big cells → N W N W D N -/

theorem big_big_pos_reduce {g h : SLG} (hg : ec g ≠ 0) (hh : ec h ≠ 0) :
    bigCellPos g hg ∘ₗ bigCellPos h hh =
      Nfull (ea g * (ec g)⁻¹) ∘ₗ Wfull ∘ₗ
        Nfull (ec g * ec g * ((ec g)⁻¹ * ed g + ea h * (ec h)⁻¹)) ∘ₗ Wfull ∘ₗ
        Dfull ((ec g)⁻¹ * ec h) (mul_ne_zero (inv_ne_zero hg) hh) ∘ₗ
        Nfull ((ec h)⁻¹ * ed h) := by
  dsimp [bigCellPos]
  set cg := ec g; set ag := ea g; set dg := ed g
  set ch := ec h; set ah := ea h; set dh := ed h
  set t := cg⁻¹ * dg + ah * ch⁻¹
  set s := cg * cg * t
  apply LinearMap.ext; intro φ
  have hNadd :
      Nfull (cg⁻¹ * dg) (Nfull (ah * ch⁻¹)
        (Wfull (Dfull ch hh (Nfull (ch⁻¹ * dh) φ)))) =
        Nfull t (Wfull (Dfull ch hh (Nfull (ch⁻¹ * dh) φ))) := by
    have heq : Nfull (cg⁻¹ * dg) ∘ₗ Nfull (ah * ch⁻¹) = Nfull t := by
      change _ = Nfull (cg⁻¹ * dg + ah * ch⁻¹)
      exact (Nfull_add _ _).symm
    exact LinearMap.ext_iff.mp heq _
  have hDconj :
      Dfull cg hg (Nfull t (Wfull (Dfull ch hh (Nfull (ch⁻¹ * dh) φ)))) =
        Nfull s (Dfull cg hg (Wfull (Dfull ch hh (Nfull (ch⁻¹ * dh) φ)))) := by
    have heq := Dfull_conj_Nfull cg t hg
    simpa [s, LinearMap.comp_apply] using
      LinearMap.ext_iff.mp heq (Wfull (Dfull ch hh (Nfull (ch⁻¹ * dh) φ)))
  have hDW :
      Dfull cg hg (Wfull (Dfull ch hh (Nfull (ch⁻¹ * dh) φ))) =
        Wfull (Dfull cg⁻¹ (inv_ne_zero hg)
          (Dfull ch hh (Nfull (ch⁻¹ * dh) φ))) := by
    have heq := Dfull_conj_Wfull cg hg
    simpa [LinearMap.comp_apply] using
      LinearMap.ext_iff.mp heq (Dfull ch hh (Nfull (ch⁻¹ * dh) φ))
  have hDmul :
      Dfull cg⁻¹ (inv_ne_zero hg) (Dfull ch hh (Nfull (ch⁻¹ * dh) φ)) =
        Dfull (cg⁻¹ * ch) (mul_ne_zero (inv_ne_zero hg) hh)
          (Nfull (ch⁻¹ * dh) φ) := by
    simpa [LinearMap.comp_apply] using
      LinearMap.ext_iff.mp (Dfull_mul cg⁻¹ ch (inv_ne_zero hg) hh).symm
        (Nfull (ch⁻¹ * dh) φ)
  change Nfull (ag * cg⁻¹) (Wfull (Dfull cg hg (Nfull (cg⁻¹ * dg)
      (Nfull (ah * ch⁻¹) (Wfull (Dfull ch hh (Nfull (ch⁻¹ * dh) φ))))))) =
    Nfull (ag * cg⁻¹) (Wfull (Nfull s (Wfull
      (Dfull (cg⁻¹ * ch) (mul_ne_zero (inv_ne_zero hg) hh)
        (Nfull (ch⁻¹ * dh) φ)))))
  rw [hNadd, hDconj, hDW, hDmul]

theorem big_big_op_reduce {g h : SLG} (hg : ec g ≠ 0) (hh : ec h ≠ 0) :
    weilFun g ∘ₗ weilFun h =
      Nfull (ea g * (ec g)⁻¹) ∘ₗ Wfull ∘ₗ
        Nfull (ec g * ec g * ((ec g)⁻¹ * ed g + ea h * (ec h)⁻¹)) ∘ₗ Wfull ∘ₗ
        Dfull ((ec g)⁻¹ * ec h) (mul_ne_zero (inv_ne_zero hg) hh) ∘ₗ
        Nfull ((ec h)⁻¹ * ed h) := by
  rw [weilFun_of_big hg, weilFun_of_big hh]
  have h : (- bigCellPos g hg) ∘ₗ (- bigCellPos h hh) =
      bigCellPos g hg ∘ₗ bigCellPos h hh := by
    apply LinearMap.ext; intro φ
    change - bigCellPos g hg (- bigCellPos h hh φ) =
      bigCellPos g hg (bigCellPos h hh φ)
    rw [map_neg (bigCellPos g hg), neg_neg]
  rw [h, big_big_pos_reduce]

/-! ## Bruhat parameters for big × big product -/

/-- Intermediate unipotent parameter s = c_g² (d_g/c_g + a_h/c_h). -/
def bigBigS (g h : SLG) : F :=
  ec g * ec g * ((ec g)⁻¹ * ed g + ea h * (ec h)⁻¹)

theorem bigBigS_mul_beta {g h : SLG} (hg : ec g ≠ 0) (hh : ec h ≠ 0) :
    bigBigS g h * ((ec g)⁻¹ * ec h) = ec g * ea h + ed g * ec h := by
  dsimp [bigBigS]
  have h1 : ec g * (ec g)⁻¹ = 1 := mul_inv_cancel₀ hg
  have h2 : ec h * (ec h)⁻¹ = 1 := mul_inv_cancel₀ hh
  calc ec g * ec g * ((ec g)⁻¹ * ed g + ea h * (ec h)⁻¹) * ((ec g)⁻¹ * ec h)
      = ec g * ec g * (ec g)⁻¹ * ed g * (ec g)⁻¹ * ec h +
          ec g * ec g * (ea h * (ec h)⁻¹) * ((ec g)⁻¹ * ec h) := by ring
    _ = ec g * (ec g * (ec g)⁻¹) * ed g * (ec g)⁻¹ * ec h +
          ec g * ea h * (ec g * (ec g)⁻¹) * ((ec h)⁻¹ * ec h) := by ring
    _ = ec g * 1 * ed g * (ec g)⁻¹ * ec h +
          ec g * ea h * 1 * ((ec h)⁻¹ * ec h) := by rw [h1]
    _ = ec g * 1 * ed g * (ec g)⁻¹ * ec h +
          ec g * ea h * 1 * 1 := by rw [inv_mul_cancel₀ hh]
    _ = ed g * (ec g * (ec g)⁻¹) * ec h + ec g * ea h := by ring
    _ = ed g * 1 * ec h + ec g * ea h := by rw [h1]
    _ = ec g * ea h + ed g * ec h := by ring

theorem bigBigS_mul_beta_ec {g h : SLG} (hg : ec g ≠ 0) (hh : ec h ≠ 0) :
    bigBigS g h * ((ec g)⁻¹ * ec h) = ec (g * h) := by
  rw [bigBigS_mul_beta hg hh, ec_mul_general]

theorem bigBigS_ne_of_ec_ne {g h : SLG} (hg : ec g ≠ 0) (hh : ec h ≠ 0)
    (hgh : ec (g * h) ≠ 0) : bigBigS g h ≠ 0 := by
  intro hs
  have := bigBigS_mul_beta_ec hg hh
  rw [hs, zero_mul] at this
  exact hgh this.symm

theorem bigBigS_eq_zero_of_ec_zero {g h : SLG} (hg : ec g ≠ 0) (hh : ec h ≠ 0)
    (hgh : ec (g * h) = 0) : bigBigS g h = 0 := by
  have hβ : (ec g)⁻¹ * ec h ≠ 0 := mul_ne_zero (inv_ne_zero hg) hh
  have := bigBigS_mul_beta_ec hg hh
  rw [hgh] at this
  exact (mul_eq_zero.mp this).resolve_right hβ

/-! ## After WNW when s ≠ 0 -/

theorem big_big_after_WNW {g h : SLG} (hg : ec g ≠ 0) (hh : ec h ≠ 0)
    (hs : bigBigS g h ≠ 0) :
    bigCellPos g hg ∘ₗ bigCellPos h hh =
      Nfull (ea g * (ec g)⁻¹ + (-(bigBigS g h)⁻¹)) ∘ₗ Wfull ∘ₗ
        Dfull (-bigBigS g h) (neg_ne_zero.mpr hs) ∘ₗ
        Nfull (-(bigBigS g h)⁻¹) ∘ₗ
        Dfull ((ec g)⁻¹ * ec h) (mul_ne_zero (inv_ne_zero hg) hh) ∘ₗ
        Nfull ((ec h)⁻¹ * ed h) := by
  have hred := big_big_pos_reduce (g := g) (h := h) hg hh
  -- rewrite s-parameter as bigBigS
  have hsdef : ec g * ec g * ((ec g)⁻¹ * ed g + ea h * (ec h)⁻¹) = bigBigS g h := rfl
  rw [hsdef] at hred
  have hWNW := W_N_W (bigBigS g h) hs
  -- Prove the identity pointwise to avoid association issues
  apply LinearMap.ext; intro φ
  have hredφ := LinearMap.ext_iff.mp hred φ
  -- hredφ: Posg (Posh φ) = N(α) (W (N(s) (W (D(β) (N δ φ)))))
  change bigCellPos g hg (bigCellPos h hh φ) =
    Nfull (ea g * (ec g)⁻¹ + (-(bigBigS g h)⁻¹))
      (Wfull (Dfull (-bigBigS g h) (neg_ne_zero.mpr hs)
        (Nfull (-(bigBigS g h)⁻¹)
          (Dfull ((ec g)⁻¹ * ec h) (mul_ne_zero (inv_ne_zero hg) hh)
            (Nfull ((ec h)⁻¹ * ed h) φ)))))
  -- Start from hredφ and apply WNW inside
  have hWNWφ := LinearMap.ext_iff.mp hWNW
    (Dfull ((ec g)⁻¹ * ec h) (mul_ne_zero (inv_ne_zero hg) hh)
      (Nfull ((ec h)⁻¹ * ed h) φ))
  -- hWNWφ: W (N s (W ψ)) = N(-s⁻¹) (W (D(-s) (N(-s⁻¹) ψ)))
  have hNaddφ :
      Nfull (ea g * (ec g)⁻¹)
          (Nfull (-(bigBigS g h)⁻¹)
            (Wfull (Dfull (-bigBigS g h) (neg_ne_zero.mpr hs)
              (Nfull (-(bigBigS g h)⁻¹)
                (Dfull ((ec g)⁻¹ * ec h) (mul_ne_zero (inv_ne_zero hg) hh)
                  (Nfull ((ec h)⁻¹ * ed h) φ)))))) =
        Nfull (ea g * (ec g)⁻¹ + (-(bigBigS g h)⁻¹))
          (Wfull (Dfull (-bigBigS g h) (neg_ne_zero.mpr hs)
            (Nfull (-(bigBigS g h)⁻¹)
              (Dfull ((ec g)⁻¹ * ec h) (mul_ne_zero (inv_ne_zero hg) hh)
                (Nfull ((ec h)⁻¹ * ed h) φ))))) := by
    simpa [LinearMap.comp_apply] using
      LinearMap.ext_iff.mp (Nfull_add (ea g * (ec g)⁻¹) (-(bigBigS g h)⁻¹)).symm
        (Wfull (Dfull (-bigBigS g h) (neg_ne_zero.mpr hs)
          (Nfull (-(bigBigS g h)⁻¹)
            (Dfull ((ec g)⁻¹ * ec h) (mul_ne_zero (inv_ne_zero hg) hh)
              (Nfull ((ec h)⁻¹ * ed h) φ)))))
  -- Chain
  calc bigCellPos g hg (bigCellPos h hh φ)
      = Nfull (ea g * (ec g)⁻¹)
          (Wfull (Nfull (bigBigS g h)
            (Wfull (Dfull ((ec g)⁻¹ * ec h) (mul_ne_zero (inv_ne_zero hg) hh)
              (Nfull ((ec h)⁻¹ * ed h) φ))))) := by
          simpa [LinearMap.comp_apply, hsdef] using hredφ
    _ = Nfull (ea g * (ec g)⁻¹)
          (Nfull (-(bigBigS g h)⁻¹)
            (Wfull (Dfull (-bigBigS g h) (neg_ne_zero.mpr hs)
              (Nfull (-(bigBigS g h)⁻¹)
                (Dfull ((ec g)⁻¹ * ec h) (mul_ne_zero (inv_ne_zero hg) hh)
                  (Nfull ((ec h)⁻¹ * ed h) φ)))))) := by
          simpa [LinearMap.comp_apply] using congrArg (Nfull (ea g * (ec g)⁻¹)) hWNWφ
    _ = Nfull (ea g * (ec g)⁻¹ + (-(bigBigS g h)⁻¹))
          (Wfull (Dfull (-bigBigS g h) (neg_ne_zero.mpr hs)
            (Nfull (-(bigBigS g h)⁻¹)
              (Dfull ((ec g)⁻¹ * ec h) (mul_ne_zero (inv_ne_zero hg) hh)
                (Nfull ((ec h)⁻¹ * ed h) φ))))) := hNaddφ

/-! ## Parameter match for Big×Big → big cell of gh -/

theorem big_big_N1_param {g h : SLG} (hg : ec g ≠ 0) (hh : ec h ≠ 0)
    (hgh : ec (g * h) ≠ 0) :
    ea g * (ec g)⁻¹ + (-(bigBigS g h)⁻¹) = ea (g * h) * (ec (g * h))⁻¹ := by
  have hs : bigBigS g h ≠ 0 := bigBigS_ne_of_ec_ne hg hh hgh
  have hsβ : bigBigS g h * ((ec g)⁻¹ * ec h) = ec (g * h) :=
    bigBigS_mul_beta_ec hg hh
  have hinvs : (bigBigS g h)⁻¹ = ((ec g)⁻¹ * ec h) * (ec (g * h))⁻¹ := by
    have : bigBigS g h * (((ec g)⁻¹ * ec h) * (ec (g * h))⁻¹) = 1 := by
      calc bigBigS g h * (((ec g)⁻¹ * ec h) * (ec (g * h))⁻¹)
          = (bigBigS g h * ((ec g)⁻¹ * ec h)) * (ec (g * h))⁻¹ := by ring
        _ = ec (g * h) * (ec (g * h))⁻¹ := by rw [hsβ]
        _ = 1 := mul_inv_cancel₀ hgh
    exact inv_eq_of_mul_eq_one_right this
  have hecgh : ec (g * h) = ec g * ea h + ed g * ec h := ec_mul_general g h
  have hdet : ea g * ed g - eb g * ec g = 1 := det_entries g
  have hdiff : ea g * ed g - 1 = eb g * ec g := by
    calc ea g * ed g - 1
        = ea g * ed g - (ea g * ed g - eb g * ec g) := by rw [hdet]
      _ = eb g * ec g := by ring
  have hcancel1 : ea g * (ec g)⁻¹ * (ec g * ea h) = ea g * ea h := by
    calc ea g * (ec g)⁻¹ * (ec g * ea h)
        = ea g * ((ec g)⁻¹ * ec g) * ea h := by ring
      _ = ea g * 1 * ea h := by rw [inv_mul_cancel₀ hg]
      _ = ea g * ea h := by ring
  have hcancel2 :
      ea g * (ec g)⁻¹ * (ed g * ec h) - (ec g)⁻¹ * ec h = eb g * ec h := by
    calc ea g * (ec g)⁻¹ * (ed g * ec h) - (ec g)⁻¹ * ec h
        = (ec g)⁻¹ * ec h * (ea g * ed g) - (ec g)⁻¹ * ec h := by ring
      _ = (ec g)⁻¹ * ec h * (ea g * ed g - 1) := by ring
      _ = (ec g)⁻¹ * ec h * (eb g * ec g) := by rw [hdiff]
      _ = eb g * ec h * ((ec g)⁻¹ * ec g) := by ring
      _ = eb g * ec h * 1 := by rw [inv_mul_cancel₀ hg]
      _ = eb g * ec h := by ring
  have hnum :
      ea g * (ec g)⁻¹ * ec (g * h) - (ec g)⁻¹ * ec h =
        ea g * ea h + eb g * ec h := by
    rw [hecgh]
    calc ea g * (ec g)⁻¹ * (ec g * ea h + ed g * ec h) - (ec g)⁻¹ * ec h
        = ea g * (ec g)⁻¹ * (ec g * ea h) +
            (ea g * (ec g)⁻¹ * (ed g * ec h) - (ec g)⁻¹ * ec h) := by ring
      _ = ea g * ea h + eb g * ec h := by rw [hcancel1, hcancel2]
  have hL :
      ea g * (ec g)⁻¹ + -((bigBigS g h)⁻¹) =
        (ea g * (ec g)⁻¹ * ec (g * h) - (ec g)⁻¹ * ec h) * (ec (g * h))⁻¹ := by
    rw [hinvs]
    have h1 : ec (g * h) * (ec (g * h))⁻¹ = 1 := mul_inv_cancel₀ hgh
    calc ea g * (ec g)⁻¹ + -(((ec g)⁻¹ * ec h) * (ec (g * h))⁻¹)
        = ea g * (ec g)⁻¹ * (1 : F) +
            -(((ec g)⁻¹ * ec h) * (ec (g * h))⁻¹) := by ring
      _ = ea g * (ec g)⁻¹ * (ec (g * h) * (ec (g * h))⁻¹) +
            -(((ec g)⁻¹ * ec h) * (ec (g * h))⁻¹) := by rw [h1]
      _ = (ea g * (ec g)⁻¹ * ec (g * h) - (ec g)⁻¹ * ec h) * (ec (g * h))⁻¹ := by ring
  rw [hL, hnum, ea_mul_general]


/-- Trailing N-parameter after commuting N(−s⁻¹) past D(β). -/
theorem big_big_N2_param {g h : SLG} (hg : ec g ≠ 0) (hh : ec h ≠ 0)
    (hgh : ec (g * h) ≠ 0) :
    let β := (ec g)⁻¹ * ec h
    let s := bigBigS g h
    β⁻¹ * β⁻¹ * (-s⁻¹) + (ec h)⁻¹ * ed h = (ec (g * h))⁻¹ * ed (g * h) := by
  intro β s
  have hs : s ≠ 0 := bigBigS_ne_of_ec_ne hg hh hgh
  have hβ : β ≠ 0 := mul_ne_zero (inv_ne_zero hg) hh
  have hsβ : s * β = ec (g * h) := by
    change bigBigS g h * ((ec g)⁻¹ * ec h) = ec (g * h)
    exact bigBigS_mul_beta_ec hg hh
  -- s⁻¹ = β / ec(gh)
  have hinvs : s⁻¹ = β * (ec (g * h))⁻¹ := by
    have : s * (β * (ec (g * h))⁻¹) = 1 := by
      calc s * (β * (ec (g * h))⁻¹)
          = (s * β) * (ec (g * h))⁻¹ := by ring
        _ = ec (g * h) * (ec (g * h))⁻¹ := by rw [hsβ]
        _ = 1 := mul_inv_cancel₀ hgh
    exact inv_eq_of_mul_eq_one_right this
  -- β⁻¹ = ch⁻¹ * cg
  have hβinv : β⁻¹ = (ec h)⁻¹ * ec g := by
    change ((ec g)⁻¹ * ec h)⁻¹ = (ec h)⁻¹ * ec g
    rw [_root_.mul_inv_rev, inv_inv]
  -- β⁻² (-s⁻¹) = - β⁻² * β / ec(gh) = - β⁻¹ / ec(gh)
  have hterm1 : β⁻¹ * β⁻¹ * (-s⁻¹) = -β⁻¹ * (ec (g * h))⁻¹ := by
    rw [hinvs]
    calc β⁻¹ * β⁻¹ * (-(β * (ec (g * h))⁻¹))
        = - β⁻¹ * β⁻¹ * β * (ec (g * h))⁻¹ := by ring
      _ = - β⁻¹ * (β⁻¹ * β) * (ec (g * h))⁻¹ := by ring
      _ = - β⁻¹ * 1 * (ec (g * h))⁻¹ := by rw [inv_mul_cancel₀ hβ]
      _ = -β⁻¹ * (ec (g * h))⁻¹ := by ring
  -- ed(gh) = cg * bh + dg * dh
  have hedgh : ed (g * h) = ec g * eb h + ed g * ed h := by
    change ((g : Matrix (Fin 2) (Fin 2) F) * h) 1 1 = _
    rw [Matrix.mul_apply, Fin.sum_univ_two]; rfl
  have hdet_h : ea h * ed h - eb h * ec h = 1 := det_entries h
  have hdiff_h : ea h * ed h - 1 = eb h * ec h := by
    calc ea h * ed h - 1
        = ea h * ed h - (ea h * ed h - eb h * ec h) := by rw [hdet_h]
      _ = eb h * ec h := by ring
  -- LHS = -β⁻¹/ec(gh) + dh/ch
  --     = (-β⁻¹ + dh/ch * ec(gh)) / ec(gh)
  have hecgh : ec (g * h) = ec g * ea h + ed g * ec h := ec_mul_general g h
  -- Want LHS = ed(gh)/ec(gh)
  rw [hterm1]
  -- -β⁻¹ * (ec gh)⁻¹ + dh/ch = (ed gh) * (ec gh)⁻¹
  -- ⇔ -β⁻¹ + (dh/ch) * ec(gh) = ed(gh)
  have htarget :
      -β⁻¹ + (ec h)⁻¹ * ed h * ec (g * h) = ed (g * h) := by
    rw [hβinv, hecgh, hedgh]
    -- -ch⁻¹ cg + ch⁻¹ dh (cg ah + dg ch) = cg bh + dg dh
    have h1 : (ec h)⁻¹ * ed h * (ec g * ea h) =
        (ec h)⁻¹ * ec g * (ed h * ea h) := by ring
    have h2 : (ec h)⁻¹ * ed h * (ed g * ec h) = ed h * ed g := by
      calc (ec h)⁻¹ * ed h * (ed g * ec h)
          = ed h * ed g * ((ec h)⁻¹ * ec h) := by ring
        _ = ed h * ed g * 1 := by rw [inv_mul_cancel₀ hh]
        _ = ed h * ed g := by ring
    -- LHS = -ch⁻¹ cg + ch⁻¹ dh cg ah + dh dg
    --     = ch⁻¹ cg ( -1 + dh ah) + dh dg
    --     = ch⁻¹ cg (ah dh - 1) + dh dg   (commute)
    --     = ch⁻¹ cg (bh ch) + dh dg
    --     = cg bh + dh dg
    have hcomm : ed h * ea h = ea h * ed h := by ring
    calc -( (ec h)⁻¹ * ec g) + (ec h)⁻¹ * ed h * (ec g * ea h + ed g * ec h)
        = -( (ec h)⁻¹ * ec g) + (ec h)⁻¹ * ed h * (ec g * ea h) +
            (ec h)⁻¹ * ed h * (ed g * ec h) := by ring
      _ = -( (ec h)⁻¹ * ec g) + (ec h)⁻¹ * ec g * (ed h * ea h) +
            ed h * ed g := by rw [h2]; ring
      _ = (ec h)⁻¹ * ec g * (-1 + ed h * ea h) + ed g * ed h := by ring
      _ = (ec h)⁻¹ * ec g * (ea h * ed h - 1) + ed g * ed h := by
          rw [hcomm]; ring
      _ = (ec h)⁻¹ * ec g * (eb h * ec h) + ed g * ed h := by rw [hdiff_h]
      _ = ec g * eb h * ((ec h)⁻¹ * ec h) + ed g * ed h := by ring
      _ = ec g * eb h * 1 + ed g * ed h := by rw [inv_mul_cancel₀ hh]
      _ = ec g * eb h + ed g * ed h := by ring
  -- Conclude by multiplying by (ec gh)⁻¹
  have h1 : ec (g * h) * (ec (g * h))⁻¹ = 1 := mul_inv_cancel₀ hgh
  calc -β⁻¹ * (ec (g * h))⁻¹ + (ec h)⁻¹ * ed h
      = -β⁻¹ * (ec (g * h))⁻¹ + (ec h)⁻¹ * ed h * 1 := by ring
    _ = -β⁻¹ * (ec (g * h))⁻¹ +
          (ec h)⁻¹ * ed h * (ec (g * h) * (ec (g * h))⁻¹) := by rw [h1]
    _ = (-β⁻¹ + (ec h)⁻¹ * ed h * ec (g * h)) * (ec (g * h))⁻¹ := by ring
    _ = ed (g * h) * (ec (g * h))⁻¹ := by rw [htarget]
    _ = (ec (g * h))⁻¹ * ed (g * h) := by ring


/-! ## R commutes with N, W, D -/

theorem Wfull_Rfull : Wfull ∘ₗ Rfull = Rfull ∘ₗ Wfull := by
  apply LinearMap.ext; intro f; funext x
  dsimp [Wfull, Rfull, Sfull]
  classical
  -- (W (R f)) x = c ∑_y ψ(x y) f(-y)
  -- (R (W f)) x = c ∑_y ψ((-x) y) f y
  refine congrArg (fun s => cFourier * s) ?_
  have hbij : Function.Bijective (fun y : ZMod 11 => (-y : ZMod 11)) :=
    ⟨neg_injective, fun z => ⟨-z, neg_neg z⟩⟩
  -- First: ∑ ψ((-x)y) f y = ∑ ψ(x (-y)) f y
  have h1 : (∑ y : ZMod 11, ψ ((-x) * y) * f y) =
      ∑ y : ZMod 11, ψ (x * (-y)) * f y :=
    Finset.sum_congr rfl fun y _ => by congr 1; ring
  -- Second: reindex y ↦ -z gives ∑ ψ(x z) f(-z)
  have h2 : (∑ y : ZMod 11, ψ (x * (-y)) * f y) =
      ∑ z : ZMod 11, ψ (x * z) * f (-z) :=
    (Fintype.sum_bijective (fun z : ZMod 11 => (-z : ZMod 11)) hbij
      (fun z => ψ (x * z) * f (-z))
      (fun y => ψ (x * (-y)) * f y)
      (fun z => by
        -- right side at -z: ψ(x*(-(-z))) f(-z) = ψ(x z) f(-z)
        have : (- (-z) : ZMod 11) = z := neg_neg z
        simp only [this])).symm
  -- Goal after dsimp: ∑ ψ(x y) f(-y) = ∑ ψ((-x) y) f y
  exact (h1.trans h2).symm

theorem Rfull_Wfull : Rfull ∘ₗ Wfull = Wfull ∘ₗ Rfull := Wfull_Rfull.symm

/-- N W (−R) = (−R) N W as operators (R centralizes the Bruhat generators). -/
theorem N_W_negR (α : F) :
    Nfull α ∘ₗ Wfull ∘ₗ (-Rfull) = (-Rfull) ∘ₗ Nfull α ∘ₗ Wfull := by
  apply LinearMap.ext; intro f
  -- LHS: N (W (-R f)) = N (- (W (R f))) = - N (W (R f))
  -- RHS: - R (N (W f))
  change Nfull α (Wfull (-Rfull f)) = - Rfull (Nfull α (Wfull f))
  have h1 : Wfull (-Rfull f) = - Wfull (Rfull f) := map_neg Wfull (Rfull f)
  rw [h1, map_neg (Nfull α)]
  apply congrArg (fun t => -t)
  -- N (W (R f)) = R (N (W f))
  have hWR : Wfull (Rfull f) = Rfull (Wfull f) := by
    simpa [LinearMap.comp_apply] using congrArg (fun L : Fun →ₗ[K] Fun => L f) Wfull_Rfull
  rw [hWR]
  -- N (R (W f)) = R (N (W f))
  simpa [LinearMap.comp_apply] using
    (congrArg (fun L : Fun →ₗ[K] Fun => L (Wfull f)) (Rfull_Nfull α)).symm

/-! ## Big×Big: Pos∘Pos = (−R) ∘ Pos(gh) when product is big -/

public theorem big_big_pos_eq_negR_pos {g h : SLG} (hg : ec g ≠ 0) (hh : ec h ≠ 0)
    (hgh : ec (g * h) ≠ 0) :
    bigCellPos g hg ∘ₗ bigCellPos h hh =
      (-Rfull) ∘ₗ bigCellPos (g * h) hgh := by
  have hs : bigBigS g h ≠ 0 := bigBigS_ne_of_ec_ne hg hh hgh
  have hβne : (ec g)⁻¹ * ec h ≠ 0 := mul_ne_zero (inv_ne_zero hg) hh
  have hform := big_big_after_WNW hg hh hs
  have hND := Nfull_Dfull (-(bigBigS g h)⁻¹) ((ec g)⁻¹ * ec h) hβne
  have hsβ : bigBigS g h * ((ec g)⁻¹ * ec h) = ec (g * h) :=
    bigBigS_mul_beta_ec hg hh
  have hDneg_mul : (-bigBigS g h) * ((ec g)⁻¹ * ec h) = -ec (g * h) := by
    calc (-bigBigS g h) * ((ec g)⁻¹ * ec h)
        = -(bigBigS g h * ((ec g)⁻¹ * ec h)) := by ring
      _ = -ec (g * h) := by rw [hsβ]
  have hDmul :
      Dfull (-bigBigS g h) (neg_ne_zero.mpr hs) ∘ₗ
          Dfull ((ec g)⁻¹ * ec h) hβne =
        Dfull (-ec (g * h)) (neg_ne_zero.mpr hgh) := by
    have h := Dfull_mul (-bigBigS g h) ((ec g)⁻¹ * ec h)
      (neg_ne_zero.mpr hs) hβne
    exact h.symm.trans (Dfull_congr hDneg_mul
      (mul_ne_zero (neg_ne_zero.mpr hs) hβne) (neg_ne_zero.mpr hgh))
  have hN1 := big_big_N1_param hg hh hgh
  have hN2 := big_big_N2_param hg hh hgh
  have hDneg_ec :
      Dfull (-ec (g * h)) (neg_ne_zero.mpr hgh) =
        (-Rfull) ∘ₗ Dfull (ec (g * h)) hgh := by
    rw [Dfull_neg (ec (g * h)) hgh, Dfull_neg_one]
  -- Chain of rewrites
  rw [hform]
  -- Apply N-D commute inside
  have hmid :
      Nfull (ea g * (ec g)⁻¹ + (-(bigBigS g h)⁻¹)) ∘ₗ Wfull ∘ₗ
          Dfull (-bigBigS g h) (neg_ne_zero.mpr hs) ∘ₗ
          Nfull (-(bigBigS g h)⁻¹) ∘ₗ
          Dfull ((ec g)⁻¹ * ec h) hβne ∘ₗ
          Nfull ((ec h)⁻¹ * ed h) =
        Nfull (ea g * (ec g)⁻¹ + (-(bigBigS g h)⁻¹)) ∘ₗ Wfull ∘ₗ
          Dfull (-bigBigS g h) (neg_ne_zero.mpr hs) ∘ₗ
          Dfull ((ec g)⁻¹ * ec h) hβne ∘ₗ
          Nfull (((ec g)⁻¹ * ec h)⁻¹ * ((ec g)⁻¹ * ec h)⁻¹ *
            (-(bigBigS g h)⁻¹) + (ec h)⁻¹ * ed h) := by
    apply LinearMap.ext; intro φ
    have hnd := LinearMap.ext_iff.mp hND (Nfull ((ec h)⁻¹ * ed h) φ)
    have hadd := LinearMap.ext_iff.mp
      (Nfull_add (((ec g)⁻¹ * ec h)⁻¹ * ((ec g)⁻¹ * ec h)⁻¹ *
        (-(bigBigS g h)⁻¹)) ((ec h)⁻¹ * ed h)).symm φ
    -- Pointwise: N(α) (W (D(-s) (N(-s⁻¹) (D(β) (N δ φ)))))
    --         = N(α) (W (D(-s) (D(β) (N(β⁻²(-s⁻¹)+δ) φ))))
    simp only [LinearMap.comp_apply]
    refine congrArg (fun t =>
      Nfull (ea g * (ec g)⁻¹ + (-(bigBigS g h)⁻¹))
        (Wfull (Dfull (-bigBigS g h) (neg_ne_zero.mpr hs) t))) ?_
    -- hnd: N(-s⁻¹) (D(β) (Nδ φ)) = D(β) (N(β⁻² (-s⁻¹)) (Nδ φ))
    -- hadd: N(β⁻² (-s⁻¹)) (Nδ φ) = N(β⁻² (-s⁻¹)+δ) φ
    calc Nfull (-(bigBigS g h)⁻¹)
            (Dfull ((ec g)⁻¹ * ec h) hβne (Nfull ((ec h)⁻¹ * ed h) φ))
        = Dfull ((ec g)⁻¹ * ec h) hβne
            (Nfull (((ec g)⁻¹ * ec h)⁻¹ * ((ec g)⁻¹ * ec h)⁻¹ *
              (-(bigBigS g h)⁻¹))
              (Nfull ((ec h)⁻¹ * ed h) φ)) := hnd
      _ = Dfull ((ec g)⁻¹ * ec h) hβne
            (Nfull (((ec g)⁻¹ * ec h)⁻¹ * ((ec g)⁻¹ * ec h)⁻¹ *
              (-(bigBigS g h)⁻¹) + (ec h)⁻¹ * ed h) φ) :=
            congrArg _ hadd
  rw [hmid]
  -- D mul
  have hmid2 :
      Nfull (ea g * (ec g)⁻¹ + (-(bigBigS g h)⁻¹)) ∘ₗ Wfull ∘ₗ
          Dfull (-bigBigS g h) (neg_ne_zero.mpr hs) ∘ₗ
          Dfull ((ec g)⁻¹ * ec h) hβne ∘ₗ
          Nfull (((ec g)⁻¹ * ec h)⁻¹ * ((ec g)⁻¹ * ec h)⁻¹ *
            (-(bigBigS g h)⁻¹) + (ec h)⁻¹ * ed h) =
        Nfull (ea g * (ec g)⁻¹ + (-(bigBigS g h)⁻¹)) ∘ₗ Wfull ∘ₗ
          Dfull (-ec (g * h)) (neg_ne_zero.mpr hgh) ∘ₗ
          Nfull (((ec g)⁻¹ * ec h)⁻¹ * ((ec g)⁻¹ * ec h)⁻¹ *
            (-(bigBigS g h)⁻¹) + (ec h)⁻¹ * ed h) := by
    apply LinearMap.ext; intro φ
    have hdm := LinearMap.ext_iff.mp hDmul
      (Nfull (((ec g)⁻¹ * ec h)⁻¹ * ((ec g)⁻¹ * ec h)⁻¹ *
        (-(bigBigS g h)⁻¹) + (ec h)⁻¹ * ed h) φ)
    simp only [LinearMap.comp_apply]
    exact congrArg (fun t =>
      Nfull (ea g * (ec g)⁻¹ + (-(bigBigS g h)⁻¹)) (Wfull t)) hdm
  rw [hmid2]
  -- Param match
  have hN1' : Nfull (ea g * (ec g)⁻¹ + (-(bigBigS g h)⁻¹)) =
      Nfull (ea (g * h) * (ec (g * h))⁻¹) := by rw [hN1]
  have hN2' :
      Nfull (((ec g)⁻¹ * ec h)⁻¹ * ((ec g)⁻¹ * ec h)⁻¹ *
          (-(bigBigS g h)⁻¹) + (ec h)⁻¹ * ed h) =
        Nfull ((ec (g * h))⁻¹ * ed (g * h)) := by
    simpa using congrArg Nfull hN2
  rw [hN1', hN2', hDneg_ec]
  -- N W (-R) D N = (-R) N W D N
  dsimp [bigCellPos]
  -- Goal: N ∘ W ∘ (-R) ∘ D ∘ N = (-R) ∘ N ∘ W ∘ D ∘ N
  have hcomm := N_W_negR (ea (g * h) * (ec (g * h))⁻¹)
  -- hcomm: N W (-R) = (-R) N W
  apply LinearMap.ext; intro φ
  have hc := LinearMap.ext_iff.mp hcomm
    (Dfull (ec (g * h)) hgh (Nfull ((ec (g * h))⁻¹ * ed (g * h)) φ))
  -- hc: N (W (-R (D N φ))) = (-R) (N (W (D N φ)))
  simpa [LinearMap.comp_apply] using hc

/-! ## Even restriction: R = id, so Pos∘Pos = −Pos(gh) on even vectors -/

theorem big_big_pos_even {g h : SLG} (hg : ec g ≠ 0) (hh : ec h ≠ 0)
    (hgh : ec (g * h) ≠ 0) {f : Fun} (hf : ∀ x, f (-x) = f x) :
    bigCellPos g hg (bigCellPos h hh f) =
      - bigCellPos (g * h) hgh f := by
  have hop := congrArg (fun L : Fun →ₗ[K] Fun => L f)
    (big_big_pos_eq_negR_pos hg hh hgh)
  -- hop: Posg (Posh f) = (-R) (Pos gh f)
  change bigCellPos g hg (bigCellPos h hh f) =
    (-Rfull) (bigCellPos (g * h) hgh f) at hop
  rw [hop]
  -- (-R) ψ = - R ψ; on even ψ = Pos(gh)f (even), R ψ = ψ
  funext x
  have hψeven : ∀ y, bigCellPos (g * h) hgh f (-y) =
      bigCellPos (g * h) hgh f y := by
    -- Pos preserves evenness (same as bigCell without the minus)
    intro y
    -- use weilFun_preserves_even path: bigCellPos = N W D N preserves even
    have hN : ∀ z, Nfull ((ec (g * h))⁻¹ * ed (g * h)) f (-z) =
        Nfull ((ec (g * h))⁻¹ * ed (g * h)) f z :=
      fun z => Tfull_b_preserves_even _ hf z
    have hD : ∀ z,
        Dfull (ec (g * h)) hgh
          (Nfull ((ec (g * h))⁻¹ * ed (g * h)) f) (-z) =
        Dfull (ec (g * h)) hgh
          (Nfull ((ec (g * h))⁻¹ * ed (g * h)) f) z :=
      fun z => Dfull_preserves_even _ _ hN z
    have hW : ∀ z,
        Wfull (Dfull (ec (g * h)) hgh
          (Nfull ((ec (g * h))⁻¹ * ed (g * h)) f)) (-z) =
        Wfull (Dfull (ec (g * h)) hgh
          (Nfull ((ec (g * h))⁻¹ * ed (g * h)) f)) z :=
      fun z => Sfull_preserves_even hD z
    dsimp [bigCellPos]
    exact Tfull_b_preserves_even _ hW y
  simp only [LinearMap.neg_apply, LinearMap.comp_apply]
  -- goal: - R (Pos f) x = - Pos f x
  change - Rfull (bigCellPos (g * h) hgh f) x = - bigCellPos (g * h) hgh f x
  rw [Rfull_even hψeven x]

/-! ## Big×Big multiplicativity on even U (product still big) -/

theorem weilU_mul_big_big_ne {g h : SLG} (hg : ec g ≠ 0) (hh : ec h ≠ 0)
    (hgh : ec (g * h) ≠ 0) :
    weilU (g * h) = weilU g ∘ₗ weilU h := by
  apply LinearMap.ext; intro f
  apply Subtype.ext
  -- underlying: weilFun(gh) f.1 = weilFun g (weilFun h f.1)
  change weilFun (g * h) f.1 = weilFun g (weilFun h f.1)
  have hf : ∀ x, f.1 (-x) = f.1 x := fun x => f.2 x
  -- both sides are −Pos on big cells; two minuses cancel on RHS
  rw [weilFun_of_big hgh, weilFun_of_big hg, weilFun_of_big hh]
  -- LHS: - Pos(gh) f
  -- RHS: (-Pos g) ((-Pos h) f) = Pos g (Pos h f)
  change - bigCellPos (g * h) hgh f.1 =
    (- bigCellPos g hg) ((- bigCellPos h hh) f.1)
  have hneg : (- bigCellPos g hg) ((- bigCellPos h hh) f.1) =
      bigCellPos g hg (bigCellPos h hh f.1) := by
    simp only [LinearMap.neg_apply, map_neg, neg_neg]
  rw [hneg, big_big_pos_even hg hh hgh hf]

/-! ## Big×Big when product is Borel (s = 0): W² = −R -/

theorem big_big_s_zero_ec {g h : SLG} (hg : ec g ≠ 0) (hh : ec h ≠ 0)
    (hs : bigBigS g h = 0) : ec (g * h) = 0 := by
  have := bigBigS_mul_beta_ec hg hh
  rw [hs, zero_mul] at this
  exact this.symm

theorem Wfull_Nfull_zero_Wfull :
    Wfull ∘ₗ Nfull (0 : F) ∘ₗ Wfull = -Rfull := by
  rw [Nfull_zero]
  simp only [LinearMap.comp_id, LinearMap.id_comp, Wfull_sq_R]



/-! ## s = 0 parameter identities (algebraic) -/

theorem big_big_ht0 {g h : SLG} (hg : ec g ≠ 0) (hh : ec h ≠ 0)
    (hgh : ec (g * h) = 0) :
    (ec g)⁻¹ * ed g + ea h * (ec h)⁻¹ = 0 := by
  have hs : bigBigS g h = 0 := bigBigS_eq_zero_of_ec_zero hg hh hgh
  have hcg2 : ec g * ec g ≠ 0 := mul_ne_zero hg hg
  change ec g * ec g * ((ec g)⁻¹ * ed g + ea h * (ec h)⁻¹) = 0 at hs
  exact (mul_eq_zero.mp hs).resolve_left hcg2

theorem big_big_edg_rel {g h : SLG} (hg : ec g ≠ 0) (hh : ec h ≠ 0)
    (hgh : ec (g * h) = 0) :
    ed g * ec h = - ec g * ea h := by
  have ht0 := big_big_ht0 hg hh hgh
  have hmul0 : ((ec g)⁻¹ * ed g + ea h * (ec h)⁻¹) * ec h = 0 := by
    rw [ht0, zero_mul]
  have h' : (ec g)⁻¹ * ed g * ec h + ea h = 0 := by
    have : (ec g)⁻¹ * ed g * ec h + ea h * ((ec h)⁻¹ * ec h) = 0 := by
      convert hmul0 using 1; ring
    rwa [inv_mul_cancel₀ hh, mul_one] at this
  have hsum : ed g * ec h + ec g * ea h = 0 := by
    -- From h': (ec g)⁻¹ * (ed g * ec h) + ea h = 0
    have h'2 : (ec g)⁻¹ * (ed g * ec h) + ea h = 0 := by convert h' using 1; ring
    have := congrArg (fun u : F => ec g * u) h'2
    -- ec g * ((ec g)⁻¹ * (ed g * ec h) + ea h) = 0
    calc ed g * ec h + ec g * ea h
        = (ec g * (ec g)⁻¹) * (ed g * ec h) + ec g * ea h := by
          rw [mul_inv_cancel₀ hg]; ring
      _ = ec g * ((ec g)⁻¹ * (ed g * ec h)) + ec g * ea h := by ring
      _ = ec g * ((ec g)⁻¹ * (ed g * ec h) + ea h) := by ring
      _ = ec g * 0 := by rw [h'2]
      _ = 0 := mul_zero _
  -- ed g * ec h = -(ec g * ea h) = -ec g * ea h
  calc ed g * ec h = - (ec g * ea h) := eq_neg_of_add_eq_zero_left hsum
    _ = -ec g * ea h := by ring

theorem big_big_beta_eq_neg_ea {g h : SLG} (hg : ec g ≠ 0) (hh : ec h ≠ 0)
    (hgh : ec (g * h) = 0) :
    (ec g)⁻¹ * ec h = - ea (g * h) := by
  have hdg := big_big_edg_rel hg hh hgh
  have hdet : ea g * ed g - eb g * ec g = 1 := det_entries g
  have h1p : (1 : F) + eb g * ec g = ea g * ed g := by
    calc (1 : F) + eb g * ec g
        = (ea g * ed g - eb g * ec g) + eb g * ec g := by rw [hdet]
      _ = ea g * ed g := by ring
  -- ch * (1 + bg cg) = ch * ag * dg = ag * (ch dg) = ag (-cg ah) = -ag cg ah
  have hgoal : ec h * ((1 : F) + eb g * ec g) = - ec g * ea g * ea h := by
    calc ec h * ((1 : F) + eb g * ec g)
        = ec h * (ea g * ed g) := by rw [h1p]
      _ = ea g * (ec h * ed g) := by ring
      _ = ea g * (ed g * ec h) := by ring
      _ = ea g * (- ec g * ea h) := by rw [hdg]
      _ = - ec g * ea g * ea h := by ring
  -- ch + cg bg ch + cg ag ah = 0
  have hsum : ec h + ec g * (ea g * ea h + eb g * ec h) = 0 := by
    have : ec h * ((1 : F) + eb g * ec g) + ec g * ea g * ea h = 0 := by
      rw [hgoal]; ring
    convert this using 1; ring
  have hsum' : (ec g)⁻¹ * ec h + (ea g * ea h + eb g * ec h) = 0 := by
    have h1 : (ec g)⁻¹ * (ec h + ec g * (ea g * ea h + eb g * ec h)) = 0 := by
      rw [hsum, mul_zero]
    have h2 : (ec g)⁻¹ * ec h + (ea g * ea h + eb g * ec h) =
        (ec g)⁻¹ * (ec h + ec g * (ea g * ea h + eb g * ec h)) := by
      have hcg : (ec g)⁻¹ * (ec g * (ea g * ea h + eb g * ec h)) =
          ea g * ea h + eb g * ec h := by
        calc (ec g)⁻¹ * (ec g * (ea g * ea h + eb g * ec h))
            = ((ec g)⁻¹ * ec g) * (ea g * ea h + eb g * ec h) := by ring
          _ = 1 * _ := by rw [inv_mul_cancel₀ hg]
          _ = _ := by ring
      rw [mul_add, hcg]
    rwa [h2]
  rw [ea_mul_general]
  exact eq_neg_of_add_eq_zero_left hsum'




theorem big_big_borel_N_param {g h : SLG} (hg : ec g ≠ 0) (hh : ec h ≠ 0)
    (hgh : ec (g * h) = 0) :
    ea g * (ec g)⁻¹ +
      ea (g * h) * ea (g * h) * ((ec h)⁻¹ * ed h) =
      eb (g * h) * ea (g * h) := by
  have hea : ea (g * h) = ea g * ea h + eb g * ec h := ea_mul_general g h
  have heb : eb (g * h) = ea g * eb h + eb g * ed h := by
    change ((g : Matrix (Fin 2) (Fin 2) F) * h) 0 1 = _
    rw [Matrix.mul_apply, Fin.sum_univ_two]; rfl
  have hdg := big_big_edg_rel hg hh hgh
  have hdetg : ea g * ed g - eb g * ec g = (1 : F) := det_entries g
  have hdeth : ea h * ed h - eb h * ec h = (1 : F) := det_entries h
  have hC : ec g * (ec g)⁻¹ = 1 := mul_inv_cancel₀ hg
  have hc : ec h * (ec h)⁻¹ = 1 := mul_inv_cancel₀ hh
  -- ed g = - ec g * ea h * (ec h)⁻¹
  have hD : ed g = - ec g * ea h * (ec h)⁻¹ := by
    have : ed g * ec h = - ec g * ea h := hdg
    calc ed g = ed g * (ec h * (ec h)⁻¹) := by rw [hc]; ring
      _ = (ed g * ec h) * (ec h)⁻¹ := by ring
      _ = (- ec g * ea h) * (ec h)⁻¹ := by rw [this]
      _ = - ec g * ea h * (ec h)⁻¹ := by ring
  -- eb g = (ea g * ed g - 1) * (ec g)⁻¹
  have hB : eb g = (ea g * ed g - 1) * (ec g)⁻¹ := by
    have : eb g * ec g = ea g * ed g - 1 := by
      calc eb g * ec g = ea g * ed g - (ea g * ed g - eb g * ec g) := by ring
        _ = ea g * ed g - 1 := by rw [hdetg]
    calc eb g = eb g * (ec g * (ec g)⁻¹) := by rw [hC]; ring
      _ = (eb g * ec g) * (ec g)⁻¹ := by ring
      _ = (ea g * ed g - 1) * (ec g)⁻¹ := by rw [this]
  -- Combined: eb g = - ea g * ea h * (ec h)⁻¹ - (ec g)⁻¹
  have hbg : eb g = - ea g * ea h * (ec h)⁻¹ - (ec g)⁻¹ := by
    rw [hB, hD]
    calc (ea g * (- ec g * ea h * (ec h)⁻¹) - 1) * (ec g)⁻¹
        = (- ea g * ec g * ea h * (ec h)⁻¹ - 1) * (ec g)⁻¹ := by ring
      _ = - ea g * ea h * (ec h)⁻¹ * (ec g * (ec g)⁻¹) - (ec g)⁻¹ := by ring
      _ = - ea g * ea h * (ec h)⁻¹ * 1 - (ec g)⁻¹ := by rw [hC]
      _ = - ea g * ea h * (ec h)⁻¹ - (ec g)⁻¹ := by ring
  -- ea(gh) = - ec h * (ec g)⁻¹
  have hea_simp : ea g * ea h + eb g * ec h = - ec h * (ec g)⁻¹ := by
    rw [hbg]
    have hstep :
        ea g * ea h + (- ea g * ea h * (ec h)⁻¹ - (ec g)⁻¹) * ec h =
          ea g * ea h - ea g * ea h * ((ec h)⁻¹ * ec h) - (ec g)⁻¹ * ec h := by ring
    calc ea g * ea h + (- ea g * ea h * (ec h)⁻¹ - (ec g)⁻¹) * ec h
        = ea g * ea h - ea g * ea h * ((ec h)⁻¹ * ec h) - (ec g)⁻¹ * ec h := hstep
      _ = ea g * ea h - ea g * ea h * 1 - (ec g)⁻¹ * ec h := by
          rw [inv_mul_cancel₀ hh]
      _ = - (ec g)⁻¹ * ec h := by ring
      _ = - ec h * (ec g)⁻¹ := by ring
  -- LHS = ag/cg + ea(gh)² (dh/ch) = ag/cg + ch dh / cg²
  have hLHS :
      ea g * (ec g)⁻¹ +
          (ea g * ea h + eb g * ec h) * (ea g * ea h + eb g * ec h) *
            ((ec h)⁻¹ * ed h) =
        ea g * (ec g)⁻¹ + ec h * ed h * (ec g)⁻¹ * (ec g)⁻¹ := by
    rw [hea_simp]
    calc ea g * (ec g)⁻¹ +
            (- ec h * (ec g)⁻¹) * (- ec h * (ec g)⁻¹) * ((ec h)⁻¹ * ed h)
        = ea g * (ec g)⁻¹ +
            (ec h * (ec g)⁻¹) * (ec h * (ec g)⁻¹) * ((ec h)⁻¹ * ed h) := by ring
      _ = ea g * (ec g)⁻¹ +
            ec h * (ec g)⁻¹ * (ec g)⁻¹ * (ec h * (ec h)⁻¹) * ed h := by ring
      _ = ea g * (ec g)⁻¹ + ec h * (ec g)⁻¹ * (ec g)⁻¹ * 1 * ed h := by rw [hc]
      _ = ea g * (ec g)⁻¹ + ec h * ed h * (ec g)⁻¹ * (ec g)⁻¹ := by ring
  -- eb(gh) = ag bh + bg dh = ag bh + (-ag ah/ch - 1/cg) dh
  have heb_simp :
      ea g * eb h + eb g * ed h =
        ea g * eb h + (- ea g * ea h * (ec h)⁻¹ - (ec g)⁻¹) * ed h := by
    rw [hbg]
  -- RHS = eb(gh) * ea(gh)
  have hRHS :
      (ea g * eb h + eb g * ed h) * (ea g * ea h + eb g * ec h) =
        (ea g * eb h + (- ea g * ea h * (ec h)⁻¹ - (ec g)⁻¹) * ed h) *
          (- ec h * (ec g)⁻¹) := by
    rw [heb_simp, hea_simp]
  -- Expand RHS and match using det h
  have hRexp :
      (ea g * eb h + (- ea g * ea h * (ec h)⁻¹ - (ec g)⁻¹) * ed h) *
          (- ec h * (ec g)⁻¹) =
        - ea g * eb h * ec h * (ec g)⁻¹ +
          ea g * ea h * ed h * (ec g)⁻¹ +
          ed h * ec h * (ec g)⁻¹ * (ec g)⁻¹ := by
    have hstep :
        (ea g * eb h + (- ea g * ea h * (ec h)⁻¹ - (ec g)⁻¹) * ed h) *
            (- ec h * (ec g)⁻¹) =
          - ea g * eb h * ec h * (ec g)⁻¹ +
            ea g * ea h * ed h * ((ec h)⁻¹ * ec h) * (ec g)⁻¹ +
            ed h * ec h * (ec g)⁻¹ * (ec g)⁻¹ := by ring
    rw [hstep, inv_mul_cancel₀ hh]
    ring
  have hLexp :
      ea g * (ec g)⁻¹ + ec h * ed h * (ec g)⁻¹ * (ec g)⁻¹ =
        - ea g * eb h * ec h * (ec g)⁻¹ +
          ea g * ea h * ed h * (ec g)⁻¹ +
          ed h * ec h * (ec g)⁻¹ * (ec g)⁻¹ := by
    calc ea g * (ec g)⁻¹ + ec h * ed h * (ec g)⁻¹ * (ec g)⁻¹
        = ea g * (ec g)⁻¹ * (1 : F) +
            ec h * ed h * (ec g)⁻¹ * (ec g)⁻¹ := by ring
      _ = ea g * (ec g)⁻¹ * (ea h * ed h - eb h * ec h) +
            ec h * ed h * (ec g)⁻¹ * (ec g)⁻¹ := by rw [hdeth]
      _ = ea g * (ec g)⁻¹ * (ea h * ed h) - ea g * (ec g)⁻¹ * (eb h * ec h) +
            ec h * ed h * (ec g)⁻¹ * (ec g)⁻¹ := by ring
      _ = ea g * ea h * ed h * (ec g)⁻¹ - ea g * eb h * ec h * (ec g)⁻¹ +
            ed h * ec h * (ec g)⁻¹ * (ec g)⁻¹ := by ring
      _ = - ea g * eb h * ec h * (ec g)⁻¹ +
            ea g * ea h * ed h * (ec g)⁻¹ +
            ed h * ec h * (ec g)⁻¹ * (ec g)⁻¹ := by ring
  -- Conclude
  rw [hea, heb, hLHS, hLexp, ← hRexp, ← hRHS]

/- theorem big_big_pos_borel_even {g h : SLG} (hg : ec g ≠ 0) (hh : ec h ≠ 0)
    (hgh : ec (g * h) = 0) {f : Fun} (hf : ∀ x, f (-x) = f x) :
    bigCellPos g hg (bigCellPos h hh f) = borelFun (g * h) hgh f := by
  have hs : bigBigS g h = 0 := bigBigS_eq_zero_of_ec_zero hg hh hgh
  have hag := ea_ne_zero_of_ec_zero (g * h) hgh
  have hβne : (ec g)⁻¹ * ec h ≠ 0 := mul_ne_zero (inv_ne_zero hg) hh
  have hred := big_big_pos_reduce hg hh
  have hsdef :
      ec g * ec g * ((ec g)⁻¹ * ed g + ea h * (ec h)⁻¹) = bigBigS g h := rfl
  -- Pos∘Pos f = N(α) W N(s) W D(β) N(δ) f with s=0
  have hop := congrArg (fun L : Fun →ₗ[K] Fun => L f) hred
  -- Rewrite s ↦ 0 ↦ id inside the operator product
  have hop' :
      bigCellPos g hg (bigCellPos h hh f) =
        Nfull (ea g * (ec g)⁻¹)
          (Wfull (Wfull (Dfull ((ec g)⁻¹ * ec h) hβne
            (Nfull ((ec h)⁻¹ * ed h) f)))) := by
    -- hop = LinearMap.ext_iff of big_big_pos_reduce applied to f
    have hredφ := LinearMap.ext_iff.mp hred f
    -- rewrite the N(s) parameter using s = 0
    have hs0 :
        Nfull (ec g * ec g * ((ec g)⁻¹ * ed g + ea h * (ec h)⁻¹)) =
          LinearMap.id := by
      rw [hsdef, hs, Nfull_zero]
    simpa [LinearMap.comp_apply, hs0, LinearMap.id_apply] using hredφ
  rw [hop']
  -- W W = -R
  have hWW :
      Wfull (Wfull (Dfull ((ec g)⁻¹ * ec h) hβne
        (Nfull ((ec h)⁻¹ * ed h) f))) =
      (-Rfull) (Dfull ((ec g)⁻¹ * ec h) hβne
        (Nfull ((ec h)⁻¹ * ed h) f)) := by
    simpa [LinearMap.comp_apply] using
      congrArg (fun L : Fun →ₗ[K] Fun =>
        L (Dfull ((ec g)⁻¹ * ec h) hβne (Nfull ((ec h)⁻¹ * ed h) f)))
        Wfull_sq_R
  rw [hWW]
  -- β = -ea(gh), D(β) = D(-ea) = (-R) ∘ D(ea)
  have hβ : (ec g)⁻¹ * ec h = - ea (g * h) := big_big_beta_eq_neg_ea hg hh hgh
  have hDβ :
      Dfull ((ec g)⁻¹ * ec h) hβne =
        Dfull (- ea (g * h)) (neg_ne_zero.mpr hag) :=
    Dfull_congr hβ hβne (neg_ne_zero.mpr hag)
  rw [hDβ]
  have hDneg :
      Dfull (- ea (g * h)) (neg_ne_zero.mpr hag) =
        (-Rfull) ∘ₗ Dfull (ea (g * h)) hag := by
    rw [Dfull_neg (ea (g * h)) hag, Dfull_neg_one]
  rw [hDneg]
  -- Now: N(α) ((-R) ((-R) (D(ea) (N δ f)))) = N(α) (R² (D N f)) = N(α) (D N f)
  -- since R² = id, and (-R)(-R) = R² = id
  have hRR : ∀ ψ : Fun, (-Rfull) ((-Rfull) ψ) = ψ := by
    intro ψ
    have hR2 : Rfull (Rfull ψ) = ψ := by
      simpa [LinearMap.comp_apply] using LinearMap.ext_iff.mp Rfull_sq ψ
    calc (-Rfull) ((-Rfull) ψ)
        = - Rfull ((-Rfull) ψ) := rfl
      _ = - Rfull (- Rfull ψ) := rfl
      _ = - (- Rfull (Rfull ψ)) := by rw [map_neg Rfull]
      _ = Rfull (Rfull ψ) := neg_neg _
      _ = ψ := hR2
  -- D(ea) (N δ f) is even when f is, so R acts as id — but we use R²=id fully.
  set ψ := Dfull (ea (g * h)) hag (Nfull ((ec h)⁻¹ * ed h) f)
  -- LHS becomes N(α) ((-R) ((-R) ψ)) = N(α) ψ after hRR
  have hsimp : (-Rfull) ((-Rfull) ψ) = ψ := hRR ψ
  -- Goal currently:
  -- N(α) ((-R) ((-R) (D N f))) = borel f = N(eb*ea) (D(ea) f_id)
  change Nfull (ea g * (ec g)⁻¹) ((-Rfull) ((-Rfull) ψ)) =
    borelFun (g * h) hgh f
  rw [hsimp]
  -- ψ = D(ea) (N(δ) f); need N(α) D(ea) N(δ) f = N(eb*ea) D(ea) f
  -- = N(α + ea² δ) D(ea) f via N-D commute
  have hND := Nfull_Dfull ((ec h)⁻¹ * ed h) (ea (g * h)) hag
  -- N(δ) then... we have N(α) (D (N δ f)) = N(α) (N(ea⁻²? wait) 
  -- Nfull_Dfull: N t ∘ D s = D s ∘ N(s⁻¹ s⁻¹ t)
  -- So D (N δ f) is not N something D — we need reverse:
  -- From Dfull_conj_Nfull: D s ∘ N t = N(s² t) ∘ D s
  -- So D (N δ f) = N(ea² δ) (D f) only if... D N = N(s²) D, so
  -- D (N δ f) = N(ea² δ) (D f) YES if starting from f not Nδf.
  -- We have D (N δ f). Yes: (D ∘ N δ) f = (N(ea² δ) ∘ D) f
  have hconj := Dfull_conj_Nfull (ea (g * h)) ((ec h)⁻¹ * ed h) hag
  have hconj' : Dfull (ea (g * h)) hag (Nfull ((ec h)⁻¹ * ed h) f) =
      Nfull (ea (g * h) * ea (g * h) * ((ec h)⁻¹ * ed h))
        (Dfull (ea (g * h)) hag f) := by
    simpa [LinearMap.comp_apply] using congrArg (fun L => L f) hconj
  -- ψ = N(ea² δ) (D f)
  change Nfull (ea g * (ec g)⁻¹) ψ = borelFun (g * h) hgh f
  rw [show ψ = Nfull (ea (g * h) * ea (g * h) * ((ec h)⁻¹ * ed h))
      (Dfull (ea (g * h)) hag f) from hconj']
  -- N(α) N(ea² δ) D f = N(α+ea²δ) D f
  have hNadd :
      Nfull (ea g * (ec g)⁻¹)
          (Nfull (ea (g * h) * ea (g * h) * ((ec h)⁻¹ * ed h))
            (Dfull (ea (g * h)) hag f)) =
        Nfull (ea g * (ec g)⁻¹ +
            ea (g * h) * ea (g * h) * ((ec h)⁻¹ * ed h))
          (Dfull (ea (g * h)) hag f) := by
    have := LinearMap.ext_iff.mp
      (Nfull_add (ea g * (ec g)⁻¹)
        (ea (g * h) * ea (g * h) * ((ec h)⁻¹ * ed h))).symm
      (Dfull (ea (g * h)) hag f)
    exact this
  rw [hNadd, big_big_borel_N_param hg hh hgh]
  -- borelFun = N(eb*ea) ∘ D(ea)
  rfl -/

private theorem big_big_pos_borel_reduce_zero_op {g h : SLG}
    (hg : ec g ≠ 0) (hh : ec h ≠ 0) (hgh : ec (g * h) = 0) :
    bigCellPos g hg ∘ₗ bigCellPos h hh =
      Nfull (ea g * (ec g)⁻¹) ∘ₗ Wfull ∘ₗ Wfull ∘ₗ
        Dfull ((ec g)⁻¹ * ec h) (mul_ne_zero (inv_ne_zero hg) hh) ∘ₗ
        Nfull ((ec h)⁻¹ * ed h) := by
  rw [big_big_pos_reduce hg hh]
  have hs : bigBigS g h = 0 := bigBigS_eq_zero_of_ec_zero hg hh hgh
  have hs0 :
      Nfull (ec g * ec g * ((ec g)⁻¹ * ed g + ea h * (ec h)⁻¹)) =
        LinearMap.id := by
    change Nfull (bigBigS g h) = LinearMap.id
    rw [hs, Nfull_zero]
  rw [hs0]
  apply LinearMap.ext
  intro f
  rfl

private theorem big_big_pos_borel_reduce_zero {g h : SLG}
    (hg : ec g ≠ 0) (hh : ec h ≠ 0) (hgh : ec (g * h) = 0) (f : Fun) :
    bigCellPos g hg (bigCellPos h hh f) =
      Nfull (ea g * (ec g)⁻¹)
        (Wfull (Wfull (Dfull ((ec g)⁻¹ * ec h)
          (mul_ne_zero (inv_ne_zero hg) hh) (Nfull ((ec h)⁻¹ * ed h) f)))) := by
  simpa only [LinearMap.comp_apply] using
    congrArg (fun L : Fun →ₗ[K] Fun => L f)
      (big_big_pos_borel_reduce_zero_op hg hh hgh)

private theorem Wfull_twice_eq_negR (f : Fun) :
    Wfull (Wfull f) = (-Rfull) f := by
  simpa [LinearMap.comp_apply] using
    congrArg (fun L : Fun →ₗ[K] Fun => L f) Wfull_sq_R

private theorem negR_twice (f : Fun) : (-Rfull) ((-Rfull) f) = f := by
  have hR2 : Rfull (Rfull f) = f := by
    simpa [LinearMap.comp_apply] using
      congrArg (fun L : Fun →ₗ[K] Fun => L f) Rfull_sq
  calc
    (-Rfull) ((-Rfull) f) = -Rfull (-Rfull f) := rfl
    _ = -(-Rfull (Rfull f)) := by rw [map_neg Rfull]
    _ = Rfull (Rfull f) := neg_neg _
    _ = f := hR2

private theorem big_big_pos_borel_to_double_negR {g h : SLG}
    (hg : ec g ≠ 0) (hh : ec h ≠ 0) (hgh : ec (g * h) = 0) (f : Fun) :
    bigCellPos g hg (bigCellPos h hh f) =
      Nfull (ea g * (ec g)⁻¹)
        ((-Rfull) ((-Rfull)
          (Dfull (ea (g * h)) (ea_ne_zero_of_ec_zero (g * h) hgh)
            (Nfull ((ec h)⁻¹ * ed h) f)))) := by
  let hag := ea_ne_zero_of_ec_zero (g * h) hgh
  let hβne : (ec g)⁻¹ * ec h ≠ 0 := mul_ne_zero (inv_ne_zero hg) hh
  rw [big_big_pos_borel_reduce_zero hg hh hgh f]
  rw [Wfull_twice_eq_negR]
  have hβ : (ec g)⁻¹ * ec h = -ea (g * h) := big_big_beta_eq_neg_ea hg hh hgh
  have hDβ :
      Dfull ((ec g)⁻¹ * ec h) hβne = Dfull (-ea (g * h)) (neg_ne_zero.mpr hag) :=
    Dfull_congr hβ hβne (neg_ne_zero.mpr hag)
  rw [hDβ]
  have hDneg :
      Dfull (-ea (g * h)) (neg_ne_zero.mpr hag) =
        (-Rfull) ∘ₗ Dfull (ea (g * h)) hag := by
    rw [Dfull_neg (ea (g * h)) hag, Dfull_neg_one]
  rw [hDneg]
  rfl

private theorem big_big_borel_DN_eq {g h : SLG}
    (hg : ec g ≠ 0) (hh : ec h ≠ 0) (hgh : ec (g * h) = 0) (f : Fun) :
    Nfull (ea g * (ec g)⁻¹)
        (Dfull (ea (g * h)) (ea_ne_zero_of_ec_zero (g * h) hgh)
          (Nfull ((ec h)⁻¹ * ed h) f)) =
      borelFun (g * h) hgh f := by
  let hag := ea_ne_zero_of_ec_zero (g * h) hgh
  let α := ea g * (ec g)⁻¹
  let δ := (ec h)⁻¹ * ed h
  let γ := ea (g * h) * ea (g * h) * δ
  have hconj := congrArg (fun L : Fun →ₗ[K] Fun => L f)
    (Dfull_conj_Nfull (ea (g * h)) δ hag)
  have hNadd := congrArg
    (fun L : Fun →ₗ[K] Fun => L (Dfull (ea (g * h)) hag f))
    (Nfull_add α γ)
  change Nfull α (Dfull (ea (g * h)) hag (Nfull δ f)) = borelFun (g * h) hgh f
  calc
    Nfull α (Dfull (ea (g * h)) hag (Nfull δ f)) =
        Nfull α (Nfull γ (Dfull (ea (g * h)) hag f)) := by
      exact congrArg (Nfull α) (by simpa [γ, LinearMap.comp_apply] using hconj)
    _ = Nfull (α + γ) (Dfull (ea (g * h)) hag f) := by
      simpa [LinearMap.comp_apply] using hNadd.symm
    _ = Nfull (eb (g * h) * ea (g * h)) (Dfull (ea (g * h)) hag f) := by
      rw [big_big_borel_N_param hg hh hgh]
    _ = borelFun (g * h) hgh f := rfl

theorem big_big_pos_borel_even {g h : SLG} (hg : ec g ≠ 0) (hh : ec h ≠ 0)
    (hgh : ec (g * h) = 0) {f : Fun} (_hf : ∀ x, f (-x) = f x) :
    bigCellPos g hg (bigCellPos h hh f) = borelFun (g * h) hgh f := by
  calc
    bigCellPos g hg (bigCellPos h hh f) =
        Nfull (ea g * (ec g)⁻¹)
          ((-Rfull) ((-Rfull)
            (Dfull (ea (g * h)) (ea_ne_zero_of_ec_zero (g * h) hgh)
              (Nfull ((ec h)⁻¹ * ed h) f)))) :=
      big_big_pos_borel_to_double_negR hg hh hgh f
    _ = Nfull (ea g * (ec g)⁻¹)
          (Dfull (ea (g * h)) (ea_ne_zero_of_ec_zero (g * h) hgh)
            (Nfull ((ec h)⁻¹ * ed h) f)) := by
      rw [negR_twice]
    _ = borelFun (g * h) hgh f := big_big_borel_DN_eq hg hh hgh f

theorem weilU_mul_big_big_zero {g h : SLG} (hg : ec g ≠ 0) (hh : ec h ≠ 0)
    (hgh : ec (g * h) = 0) :
    weilU (g * h) = weilU g ∘ₗ weilU h := by
  apply LinearMap.ext; intro f
  apply Subtype.ext
  change weilFun (g * h) f.1 = weilFun g (weilFun h f.1)
  have hf : ∀ x, f.1 (-x) = f.1 x := fun x => f.2 x
  have hL : weilFun (g * h) = borelFun (g * h) hgh := by
    dsimp [weilFun]; rw [dif_pos hgh]
  have hR : weilFun g (weilFun h f.1) =
      bigCellPos g hg (bigCellPos h hh f.1) := by
    rw [weilFun_of_big (g := g) hg, weilFun_of_big (g := h) hh]
    simp only [LinearMap.neg_apply, map_neg, neg_neg]
  rw [hL, hR, big_big_pos_borel_even hg hh hgh hf]

/-! ## Assemble monoidhom on even U -/

theorem weilU_mul_borel_big {g h : SLG} (hg : ec g = 0) (hh : ec h ≠ 0) :
    weilU (g * h) = weilU g ∘ₗ weilU h := by
  apply LinearMap.ext; intro f
  apply Subtype.ext
  have h := congrArg (fun L : Fun →ₗ[K] Fun => L f.1)
    (weilFun_mul_borel_big hg hh)
  simpa [LinearMap.comp_apply, weilU] using h

theorem weilU_mul_big_borel {g h : SLG} (hg : ec g ≠ 0) (hh : ec h = 0) :
    weilU (g * h) = weilU g ∘ₗ weilU h := by
  apply LinearMap.ext; intro f
  apply Subtype.ext
  have h := congrArg (fun L : Fun →ₗ[K] Fun => L f.1)
    (weilFun_mul_big_borel hg hh)
  simpa [LinearMap.comp_apply, weilU] using h

theorem weilU_mul_big_big {g h : SLG} (hg : ec g ≠ 0) (hh : ec h ≠ 0) :
    weilU (g * h) = weilU g ∘ₗ weilU h := by
  by_cases hgh : ec (g * h) = 0
  · exact weilU_mul_big_big_zero hg hh hgh
  · exact weilU_mul_big_big_ne hg hh hgh

public theorem weilU_mul (g h : SLG) : weilU (g * h) = weilU g ∘ₗ weilU h := by
  by_cases hg : ec g = 0
  · by_cases hh : ec h = 0
    · exact weilU_mul_borel hg hh
    · exact weilU_mul_borel_big hg hh
  · by_cases hh : ec h = 0
    · exact weilU_mul_big_borel hg hh
    · exact weilU_mul_big_big hg hh

/-- The even Weil representation as a monoid homomorphism SL₂(F₁₁) → End(U). -/
@[expose] public def weilUHom : SLG →* (WeilRep.U →ₗ[K] WeilRep.U) where
  toFun := weilU
  map_one' := weilU_one
  map_mul' := weilU_mul

#print axioms weilUHom
#print axioms weilU_mul
#print axioms weilFun_mul_big_borel
#print axioms big_big_pos_eq_negR_pos

end WeilHom
end V14Formalization
