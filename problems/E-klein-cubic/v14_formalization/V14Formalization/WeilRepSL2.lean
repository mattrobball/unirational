/-
Weil representation pieces for SL₂(F₁₁) on (Fun E) and even U.

* Diagonal Dfull, unipotent Nfull, Fourier Wfull
* Bruhat assembly weilFun / weilU
* Generators Tmat, Smat match Nfull 1 and Wfull
* weilU (−I) = −id on the even module
-/
module

public import V14Formalization.WeilRep
public import Mathlib.LinearAlgebra.Matrix.SpecialLinearGroup
public import Mathlib.Data.Matrix.Basic

open Matrix Matrix.SpecialLinearGroup AddChar MulChar BigOperators
open V14Formalization.WeilRep

noncomputable section

universe u

namespace V14Formalization
namespace WeilRepSL2

variable {E : Type u} [Field E] [CharZero E] [IsCycl11 E]

public abbrev F := ZMod 11
public abbrev SLG := SpecialLinearGroup (Fin 2) F

@[expose] public instance : Fact (Nat.Prime 11) := ⟨Nat.prime_eleven⟩

/-! ## Entries -/

@[expose] public def ea (g : SLG) : F := (g : Matrix (Fin 2) (Fin 2) F) 0 0
@[expose] public def eb (g : SLG) : F := (g : Matrix (Fin 2) (Fin 2) F) 0 1
@[expose] public def ec (g : SLG) : F := (g : Matrix (Fin 2) (Fin 2) F) 1 0
@[expose] public def ed (g : SLG) : F := (g : Matrix (Fin 2) (Fin 2) F) 1 1

public theorem det_entries (g : SLG) : ea g * ed g - eb g * ec g = 1 := by
  have h : (g : Matrix (Fin 2) (Fin 2) F).det = 1 := g.property
  rw [Matrix.det_fin_two] at h
  exact h

public theorem ea_ne_zero_of_ec_zero (g : SLG) (hc : ec g = 0) : ea g ≠ 0 := by
  intro ha
  have h := det_entries g
  rw [hc, ha] at h
  -- 0 * ed - eb * 0 = 0 ≠ 1
  simp only [zero_mul, mul_zero, sub_zero] at h
  exact zero_ne_one h

/-! ## Diagonal action -/

/-- ρ(diag(t)): f(x) ↦ χ₂(t) · f(t · x).  (Right scaling so D∘N(t)=N(t s²)∘D.) -/
@[expose] public def Dfull (t : F) (_ht : t ≠ 0) : (Fun E) →ₗ[E] (Fun E) where
  toFun f := fun x => χ₂ t * f (t * x)
  map_add' := by
    intro f g; funext x; simp [Pi.add_apply]; ring
  map_smul' := by
    intro r f; funext x; simp [Pi.smul_apply, smul_eq_mul]; ring

omit [CharZero E] [IsCycl11 E] in
public theorem Dfull_preserves_even (t : F) (ht : t ≠ 0) {f : (Fun E)}
    (hf : ∀ x, f (-x) = f x) (x : ZMod 11) :
    Dfull t ht f (-x) = Dfull t ht f x := by
  dsimp [Dfull]
  have hneg : t * (-x) = -(t * x) := by ring
  rw [hneg, hf (t * x)]

omit [CharZero E] [IsCycl11 E] in
public theorem χ₂_one : (χ₂ : MulChar (ZMod 11) E) (1 : F) = 1 := by
  change (algebraMap ℤ E) (χ₂ℤ 1) = 1
  have : χ₂ℤ 1 = 1 := by
    change quadraticChar (ZMod 11) 1 = 1
    exact map_one (quadraticChar (ZMod 11))
  rw [this, map_one]

omit [CharZero E] [IsCycl11 E] in
theorem Dfull_one : (Dfull (1 : F) one_ne_zero : (Fun E) →ₗ[E] (Fun E)) = LinearMap.id := by
  apply LinearMap.ext
  intro f
  funext x
  dsimp [Dfull]
  rw [χ₂_one, one_mul, one_mul]

/-! ## Unipotent / Fourier -/

@[expose] public def Nfull (t : F) : (Fun E) →ₗ[E] (Fun E) := Tfull_b t
@[expose] public def Wfull : (Fun E) →ₗ[E] (Fun E) := Sfull

omit [CharZero E] in
public theorem Nfull_zero : (Nfull 0 : (Fun E) →ₗ[E] (Fun E)) = LinearMap.id := by
  apply LinearMap.ext
  intro f
  funext x
  dsimp [Nfull, Tfull_b]
  -- ψ(0 * x² * twoInv) = ψ(0) = 1
  have h0 : (0 : ZMod 11) * x ^ 2 * twoInv = 0 := by ring
  rw [h0, ψ_zero, one_mul]

omit [CharZero E] in
public theorem Nfull_add (s t : F) : (Nfull (s + t) : (Fun E) →ₗ[E] (Fun E)) = Nfull s ∘ₗ Nfull t := by
  apply LinearMap.ext
  intro f
  funext x
  dsimp [Nfull, Tfull_b]
  have hψ : (ψ : AddChar (ZMod 11) E) ((s + t) * x ^ 2 * twoInv) =
      ψ (s * x ^ 2 * twoInv) * ψ (t * x ^ 2 * twoInv) := by
    rw [← ψ_add]; congr 1; ring
  rw [hψ]; ring

/-! ## Bruhat assembly -/

@[expose] public def borelFun (g : SLG) (hc : ec g = 0) : (Fun E) →ₗ[E] (Fun E) :=
  Nfull (eb g * ea g) ∘ₗ Dfull (ea g) (ea_ne_zero_of_ec_zero g hc)

/-- Positive NWDN kernel of a big-cell Bruhat factor. -/
@[expose] public def bigCellPos (g : SLG) (hc : ec g ≠ 0) : (Fun E) →ₗ[E] (Fun E) :=
  Nfull (ea g * (ec g)⁻¹) ∘ₗ Wfull ∘ₗ Dfull (ec g) hc ∘ₗ
    Nfull ((ec g)⁻¹ * ed g)

/-- Big-cell factor with the metaplectic sign so that the even Weil
representation of SL₂ is a true monoid homomorphism (D(−ec) = −D(ec)
on even functions forces this overall minus). -/
@[expose] public def bigCellFun (g : SLG) (hc : ec g ≠ 0) : (Fun E) →ₗ[E] (Fun E) :=
  - bigCellPos g hc

@[expose] public def weilFun (g : SLG) : (Fun E) →ₗ[E] (Fun E) :=
  if hc : ec g = 0 then borelFun g hc else bigCellFun g hc

omit [CharZero E] in
public theorem weilFun_preserves_even (g : SLG) {f : (Fun E)}
    (hf : ∀ x, f (-x) = f x) (x : ZMod 11) :
    weilFun g f (-x) = weilFun g f x := by
  dsimp [weilFun]
  split_ifs with hc
  · dsimp [borelFun]
    have hfD : ∀ y, Dfull (ea g) (ea_ne_zero_of_ec_zero g hc) f (-y) =
        Dfull (ea g) (ea_ne_zero_of_ec_zero g hc) f y :=
      fun y => Dfull_preserves_even _ _ hf y
    exact Tfull_b_preserves_even (eb g * ea g) hfD x
  · -- bigCellFun = −bigCellPos; negation preserves evenness
    dsimp [bigCellFun, bigCellPos]
    -- show Pos preserves even, then negate
    have hN : ∀ y, Nfull ((ec g)⁻¹ * ed g) f (-y) = Nfull ((ec g)⁻¹ * ed g) f y :=
      fun y => Tfull_b_preserves_even _ hf y
    have hD : ∀ y,
        Dfull (ec g) hc (Nfull ((ec g)⁻¹ * ed g) f) (-y) =
          Dfull (ec g) hc (Nfull ((ec g)⁻¹ * ed g) f) y :=
      fun y => Dfull_preserves_even _ _ hN y
    have hW : ∀ y,
        Wfull (Dfull (ec g) hc (Nfull ((ec g)⁻¹ * ed g) f)) (-y) =
          Wfull (Dfull (ec g) hc (Nfull ((ec g)⁻¹ * ed g) f)) y :=
      fun y => Sfull_preserves_even hD y
    have hPos :
        (Nfull (ea g * (ec g)⁻¹)
          (Wfull (Dfull (ec g) hc (Nfull ((ec g)⁻¹ * ed g) f)))) (-x) =
        (Nfull (ea g * (ec g)⁻¹)
          (Wfull (Dfull (ec g) hc (Nfull ((ec g)⁻¹ * ed g) f)))) x :=
      Tfull_b_preserves_even (ea g * (ec g)⁻¹) hW x
    -- goal is (−Pos f)(−x) = (−Pos f) x
    change
      - (Nfull (ea g * (ec g)⁻¹)
          (Wfull (Dfull (ec g) hc (Nfull ((ec g)⁻¹ * ed g) f))) (-x)) =
      - (Nfull (ea g * (ec g)⁻¹)
          (Wfull (Dfull (ec g) hc (Nfull ((ec g)⁻¹ * ed g) f))) x)
    rw [hPos]

/-- Weil action on the even module U. -/
@[expose] public def weilU (g : SLG) : (WeilRep.U E) →ₗ[E] (WeilRep.U E) where
  toFun f := ⟨weilFun g f.1, fun x => weilFun_preserves_even g (fun z => f.2 z) x⟩
  map_add' := by
    intro f₁ f₂
    apply Subtype.ext
    exact (weilFun g).map_add f₁.1 f₂.1
  map_smul' := by
    intro r f
    apply Subtype.ext
    exact (weilFun g).map_smul r f.1

/-! ## Generators -/

omit [CharZero E] in
theorem weilFun_Tmat : (weilFun Tmat : (Fun E) →ₗ[E] (Fun E)) = Nfull 1 := by
  have hc : ec Tmat = 0 := by simp [ec, Tmat]
  have ha : ea Tmat = 1 := by simp [ea, Tmat]
  have hb : eb Tmat = 1 := by simp [eb, Tmat]
  dsimp [weilFun]
  rw [dif_pos hc]
  dsimp [borelFun]
  simp only [ha, hb, one_mul]
  rw [Dfull_one, LinearMap.comp_id]

omit [CharZero E] in
/-- With the big-cell metaplectic sign, ρ(S) = −W on (Fun E) (and −S_even on U).
Still S² ↦ (−W)² = W² = −R ≡ −id on even U, matching S² = −I. -/
theorem weilFun_Smat : (weilFun Smat : (Fun E) →ₗ[E] (Fun E)) = -Wfull := by
  have hc : ec Smat ≠ 0 := by simp [ec, Smat]
  have ha0 : ea Smat = 0 := by simp [ea, Smat]
  have hd0 : ed Smat = 0 := by simp [ed, Smat]
  have hcc : ec Smat = 1 := by simp [ec, Smat]
  dsimp [weilFun]
  rw [dif_neg hc]
  dsimp [bigCellFun, bigCellPos]
  simp only [ha0, hd0, hcc, zero_mul, mul_zero, inv_one]
  rw [Nfull_zero, Dfull_one]
  simp only [LinearMap.comp_id, LinearMap.id_comp]

/-! ## ρ(−I) = −id on even U -/

@[expose] public def negI : SLG :=
  ⟨(-1 : Matrix (Fin 2) (Fin 2) F), by
    simp [det_neg, Fintype.card_fin]⟩

theorem ec_negI : ec negI = 0 := by
  simp [ec, negI, Matrix.neg_apply]

theorem ea_negI : ea negI = -1 := by
  simp [ea, negI, Matrix.neg_apply]

theorem eb_negI : eb negI = 0 := by
  simp [eb, negI, Matrix.neg_apply]

omit [CharZero E] in
public theorem weilU_negI : (weilU negI : (WeilRep.U E) →ₗ[E] (WeilRep.U E)) = -LinearMap.id := by
  apply LinearMap.ext
  intro f
  apply Subtype.ext
  funext x
  change weilFun negI f.1 x = -f.1 x
  dsimp [weilFun]
  rw [dif_pos ec_negI]
  -- borelFun = Nfull 0 ∘ Dfull (-1) = Dfull (-1)
  have hborel : (borelFun negI ec_negI : (Fun E) →ₗ[E] (Fun E)) = Dfull (-1) (by decide : (-1 : F) ≠ 0) := by
    dsimp [borelFun]
    simp only [ea_negI, eb_negI, zero_mul, Nfull_zero, LinearMap.id_comp]
  rw [hborel]
  dsimp [Dfull]
  -- χ₂(-1) * f((-1)*x) = (-1) * f(-x) = -f(x) on even functions
  have hx : (-1 : F) * x = -x := by ring
  rw [hx, f.2 x, χ₂_neg_one]
  ring

/-! ## Invertibility of unipotents -/

omit [CharZero E] in
theorem Nfull_leftInv (t : F) : (Nfull (-t) : (Fun E) →ₗ[E] (Fun E)) ∘ₗ Nfull t = LinearMap.id := by
  rw [← Nfull_add, neg_add_cancel, Nfull_zero]

omit [CharZero E] in
theorem Nfull_rightInv (t : F) : (Nfull t : (Fun E) →ₗ[E] (Fun E)) ∘ₗ Nfull (-t) = LinearMap.id := by
  rw [← Nfull_add, add_neg_cancel, Nfull_zero]

/-- On the even module, S² = −id (re-export). -/
theorem S_even_sq' : S_even ∘ₗ S_even = (-LinearMap.id : (WeilRep.U E) →ₗ[E] (WeilRep.U E)) :=
  S_even_sq

omit [CharZero E] in
/-- Weil operator for Tmat on even U is T_even_b 1. -/
public theorem weilU_Tmat : (weilU Tmat : (WeilRep.U E) →ₗ[E] (WeilRep.U E)) = T_even_b 1 := by
  apply LinearMap.ext
  intro f
  apply Subtype.ext
  funext x
  dsimp [weilU]
  rw [weilFun_Tmat]
  dsimp [Nfull, Tfull_b, T_even_b]

omit [CharZero E] in
/-- Weil operator for Smat on even U is −S_even (metaplectic big-cell sign). -/
public theorem weilU_Smat : (weilU Smat : (WeilRep.U E) →ₗ[E] (WeilRep.U E)) = -S_even := by
  apply LinearMap.ext
  intro f
  apply Subtype.ext
  change weilFun Smat f.1 = - (S_even f).1
  rw [weilFun_Smat]
  rfl


/-! ## MonoidHom: map_one -/

theorem ea_one : ea (1 : SLG) = 1 := by simp [ea]
theorem eb_one : eb (1 : SLG) = 0 := by simp [eb]
theorem ec_one : ec (1 : SLG) = 0 := by simp [ec]

omit [CharZero E] in
theorem weilFun_one : (weilFun (1 : SLG) : (Fun E) →ₗ[E] (Fun E)) = LinearMap.id := by
  have hc : ec (1 : SLG) = 0 := ec_one
  dsimp [weilFun]
  rw [dif_pos hc]
  dsimp [borelFun]
  simp only [ea_one, eb_one, zero_mul]
  rw [Nfull_zero, Dfull_one, LinearMap.id_comp]

omit [CharZero E] in
public theorem weilU_one : (weilU (1 : SLG) : (WeilRep.U E) →ₗ[E] (WeilRep.U E)) = LinearMap.id := by
  apply LinearMap.ext
  intro f
  apply Subtype.ext
  change weilFun 1 f.1 = f.1
  rw [weilFun_one]
  rfl

omit [CharZero E] [IsCycl11 E] in
/-- On subspaces (and projective space), `L` and `-L` induce the same action. -/
theorem submodule_map_neg {W : Submodule E (WeilRep.U E)} (L : (WeilRep.U E) →ₗ[E] (WeilRep.U E)) :
    Submodule.map (-L) W = Submodule.map L W := by
  ext x
  constructor
  · intro hx
    rcases Submodule.mem_map.mp hx with ⟨y, hy, rfl⟩
    refine Submodule.mem_map.mpr ⟨-y, W.neg_mem hy, ?_⟩
    simp only [LinearMap.neg_apply, map_neg]
  · intro hx
    rcases Submodule.mem_map.mp hx with ⟨y, hy, rfl⟩
    refine Submodule.mem_map.mpr ⟨-y, W.neg_mem hy, ?_⟩
    simp only [LinearMap.neg_apply, map_neg, neg_neg]

end WeilRepSL2
end V14Formalization
