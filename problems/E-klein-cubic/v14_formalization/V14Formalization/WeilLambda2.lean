/-
Copyright (c) 2026 V14Formalization contributors.
Released under Apache 2.0 license.
-/
module

public import V14Formalization.WeilHom
-- for the `Fintype PSL2F11` instance: `projectorM` sums over the group, and the
-- instance it bakes in must be the one `GeometricV14Carrier` bakes in, or the
-- two projectors are only defeq through a 660-element quotient evaluation.
public import V14Formalization.CentralizerD12
public import Mathlib.LinearAlgebra.ExteriorPower.Basic
public import Mathlib.LinearAlgebra.ExteriorPower.Basis
public import Mathlib.LinearAlgebra.Dimension.Finrank
public import Mathlib.LinearAlgebra.Dimension.StrongRankCondition
public import Mathlib.LinearAlgebra.FreeModule.Finite.Basic
public import Mathlib.LinearAlgebra.Basis.VectorSpace
public import Mathlib.LinearAlgebra.Projectivization.PSL.PSL2
public import Mathlib.LinearAlgebra.Center
public import Mathlib.GroupTheory.QuotientGroup.Basic
public import Mathlib.GroupTheory.Subgroup.Center
public import Mathlib.Tactic.FinCases

/-!
# `Λ²U` and the `PSL(2,11)`-action, over any field with a primitive 11th root

This is `GeometricFanoCarrier`'s ambient block with the base field released
from `ℚ(ζ₁₁)`.  Everything here takes a field `E` with `[WeilRep.HasCycl11 E]`
— a chosen primitive 11th root of unity — and nothing else; `GeometricFanoCarrier`
is the instantiation at `E = ℚ(ζ₁₁)` and keeps every name it had.

Three facts are proved, in the order the intrinsic `V₁₄` needs them:

* `finrank_U : finrank E (U E) = 6`, by sandwiching between `evalEven` and
  `extendEven`, both injective for index-combinatorial reasons that mention no
  field at all;
* `pslLambda2Hom`, the action of `PSL₂(𝔽₁₁)` on `⋀²U` — it descends from
  `SL₂(𝔽₁₁)` because `−I` acts on `U` by `−id`, hence trivially on `⋀²`;
* `projectorM` and `Msub`, the isotypic projector onto the `10′` summand and
  its range, with `projectorM_equivariant`.

None of the proofs uses a property of the field beyond `char = 0` and the
existence of the root: see `FIELD_CRITERIA_2026-08-18.md`.
-/

open scoped BigOperators LinearAlgebra.Projectivization MatrixGroups
open Matrix Matrix.SpecialLinearGroup exteriorPower Module

noncomputable section

namespace V14Formalization
namespace WeilLambda2

open V14Formalization.WeilRep (HasCycl11)

/-- The finite field the group is defined over. -/
public abbrev F := ZMod 11
/-- `SL₂(𝔽₁₁)`. -/
public abbrev SLG := SpecialLinearGroup (Fin 2) F
/-- `PSL₂(𝔽₁₁)`. -/
public abbrev PSL2F11 : Type := PSL(2, F)

@[expose] public instance : Fact (Nat.Prime 11) := ⟨Nat.prime_eleven⟩
@[expose] public instance : Group PSL2F11 := inferInstance

variable (E : Type) [Field E] [CharZero E] [HasCycl11 E]

/-! ## `finrank U = 6`, by evaluation and even extension -/

/-- Evaluation of even functions at coordinates `0,…,5`. -/
@[expose] public def evalEven : WeilRep.U E →ₗ[E] (Fin 6 → E) where
  toFun f j := f.1 (j.val : ZMod 11)
  map_add' _ _ := funext fun _ => rfl
  map_smul' _ _ := funext fun _ => rfl

/-- Pointwise even extension of a 6-tuple. -/
@[expose] public def extendEvenFun (v : Fin 6 → E) : ZMod 11 → E := fun x =>
  if hle : x.val ≤ 5 then v ⟨x.val, Nat.lt_succ_of_le hle⟩
  else v ⟨11 - x.val, by
    have : 6 ≤ x.val := by omega
    have : x.val ≤ 10 := Nat.lt_succ_iff.mp (ZMod.val_lt x)
    omega⟩

omit [CharZero E] [HasCycl11 E] in
set_option linter.unusedSectionVars false in
public theorem extendEvenFun_even (v : Fin 6 → E) (x : ZMod 11) :
    extendEvenFun E v (-x) = extendEvenFun E v x := by
  simp only [extendEvenFun]
  by_cases hx0 : x = 0
  · subst hx0
    simp
  · haveI : NeZero x := ⟨hx0⟩
    have hneg : (-x).val = 11 - x.val := ZMod.val_neg_of_ne_zero x
    by_cases hle : x.val ≤ 5
    · have hge : ¬ (-x).val ≤ 5 := by
        rw [hneg]
        have : 0 < x.val := Nat.pos_of_ne_zero (fun h => hx0 ((ZMod.val_eq_zero x).mp h))
        omega
      rw [dif_pos hle, dif_neg hge]
      congr 1
      apply Fin.ext
      show 11 - (-x).val = x.val
      rw [hneg]; omega
    · have hle' : (-x).val ≤ 5 := by
        rw [hneg]
        have : 6 ≤ x.val := by omega
        have : x.val ≤ 10 := Nat.lt_succ_iff.mp (ZMod.val_lt x)
        omega
      rw [dif_neg hle, dif_pos hle']
      congr 1
      apply Fin.ext
      show (-x).val = 11 - x.val
      exact hneg

/-- Even extension of a 6-tuple of values. -/
@[expose] public def extendEven : (Fin 6 → E) →ₗ[E] WeilRep.U E where
  toFun v := ⟨extendEvenFun E v, extendEvenFun_even E v⟩
  map_add' := by
    intro v w
    apply Subtype.ext
    funext x
    change extendEvenFun E (v + w) x = extendEvenFun E v x + extendEvenFun E w x
    simp only [extendEvenFun, Pi.add_apply]
    split_ifs <;> rfl
  map_smul' := by
    intro r v
    apply Subtype.ext
    funext x
    change extendEvenFun E (r • v) x = (r • extendEvenFun E v) x
    simp only [extendEvenFun, Pi.smul_apply, smul_eq_mul]
    split_ifs <;> rfl

omit [CharZero E] [HasCycl11 E] in
public theorem evalEven_extendEven : evalEven E ∘ₗ extendEven E = LinearMap.id := by
  apply LinearMap.ext; intro v; funext j
  have hjlt : j.val < 11 := Nat.lt_trans j.isLt (by decide : 6 < 11)
  have hval : ((j.val : ZMod 11)).val = j.val := ZMod.val_cast_of_lt hjlt
  have hjle : j.val ≤ 5 := Nat.lt_succ_iff.mp j.isLt
  change extendEvenFun E v (j.val : ZMod 11) = v j
  unfold extendEvenFun
  rw [dif_pos (by rwa [hval] : ((j.val : ZMod 11)).val ≤ 5)]
  congr 1
  exact Fin.ext hval

omit [CharZero E] [HasCycl11 E] in
public theorem evalEven_injective : Function.Injective (evalEven E) := by
  intro f g heq
  apply Subtype.ext; funext x
  have hfun := congr_fun heq
  by_cases hle : x.val ≤ 5
  · have hxlt : x.val < 6 := Nat.lt_succ_of_le hle
    have hcast : ((x.val : ZMod 11)).val = x.val :=
      ZMod.val_cast_of_lt (Nat.lt_trans hxlt (by decide : 6 < 11))
    have hxeq : (x.val : ZMod 11) = x := (ZMod.val_injective 11) hcast
    simpa [evalEven, hxeq] using hfun ⟨x.val, hxlt⟩
  · have hx0 : x ≠ 0 := by
      intro h; subst h; exact hle (by decide : (0 : ZMod 11).val ≤ 5)
    haveI : NeZero x := ⟨hx0⟩
    have hneg : (-x).val = 11 - x.val := ZMod.val_neg_of_ne_zero x
    have hle' : 11 - x.val ≤ 5 := by
      have : 6 ≤ x.val := by omega
      have : x.val ≤ 10 := Nat.lt_succ_iff.mp (ZMod.val_lt x)
      omega
    have hcast : ((11 - x.val : ℕ) : ZMod 11).val = 11 - x.val :=
      ZMod.val_cast_of_lt (by omega : 11 - x.val < 11)
    have hxeq : (-x : ZMod 11) = ((11 - x.val : ℕ) : ZMod 11) :=
      (ZMod.val_injective 11) (by rw [hneg, hcast])
    have hfeq : f.1 (-x) = g.1 (-x) := by
      simpa [evalEven, hxeq] using hfun ⟨11 - x.val, Nat.lt_succ_of_le hle'⟩
    calc f.1 x = f.1 (-x) := (f.2 x).symm
      _ = g.1 (-x) := hfeq
      _ = g.1 x := g.2 x

omit [CharZero E] [HasCycl11 E] in
public theorem extendEven_injective : Function.Injective (extendEven E) := by
  intro v w h
  have he := congrArg (evalEven E) h
  have hv : evalEven E (extendEven E v) = v := LinearMap.congr_fun (evalEven_extendEven E) v
  have hw : evalEven E (extendEven E w) = w := LinearMap.congr_fun (evalEven_extendEven E) w
  rwa [hv, hw] at he

omit [CharZero E] [HasCycl11 E] in
public theorem finrank_U : Module.finrank E (WeilRep.U E) = 6 := by
  have hfin6 : Module.finrank E (Fin 6 → E) = 6 := by
    rw [Module.finrank_fintype_fun_eq_card]; decide
  have hle : Module.finrank E (WeilRep.U E) ≤ 6 := by
    have := LinearMap.finrank_le_finrank_of_injective
      (f := evalEven E) (evalEven_injective E)
    rwa [hfin6] at this
  have hge : 6 ≤ Module.finrank E (WeilRep.U E) := by
    have := LinearMap.finrank_le_finrank_of_injective
      (f := extendEven E) (extendEven_injective E)
    rwa [hfin6] at this
  omega

@[expose] public instance : FiniteDimensional E (WeilRep.U E) :=
  Module.finite_of_finrank_eq_succ (n := 5) (by rw [finrank_U])
@[expose] public instance : Module.Free E (WeilRep.U E) :=
  Module.Free.of_divisionRing E (WeilRep.U E)

/-! ## `Λ²U` -/

/-- The exterior square of the even Weil module. -/
public abbrev Lambda2U : Type := ↥(⋀[E]^2 (WeilRep.U E))

@[expose] public instance : AddCommGroup (Lambda2U E) := inferInstance
@[expose] public instance : Module E (Lambda2U E) := inferInstance
@[expose] public instance : Module.Free E (Lambda2U E) := inferInstance
@[expose] public instance : FiniteDimensional E (Lambda2U E) := inferInstance

/-! ## The `SL₂` / `PSL₂` action on `Λ²U` -/

/-- `⋀²` of the even Weil representation of `SL₂(𝔽₁₁)`. -/
@[expose] public def weilLambda2 (g : SLG) : Lambda2U E →ₗ[E] Lambda2U E :=
  exteriorPower.map 2 (WeilHom.weilUHom g)

public theorem weilLambda2_one : weilLambda2 E 1 = LinearMap.id := by
  dsimp [weilLambda2]
  rw [map_one]
  exact exteriorPower.map_id

public theorem weilLambda2_mul (g h : SLG) :
    weilLambda2 E (g * h) = weilLambda2 E g ∘ₗ weilLambda2 E h := by
  dsimp [weilLambda2]
  rw [map_mul, Module.End.mul_eq_comp, exteriorPower.map_comp]

omit [CharZero E] [HasCycl11 E] in
theorem exteriorPower_map_smul_id (c : E) :
    exteriorPower.map (R := E) (n := 2) (c • LinearMap.id : WeilRep.U E →ₗ[E] WeilRep.U E) =
      (c ^ 2) • (LinearMap.id : Lambda2U E →ₗ[E] Lambda2U E) := by
  apply exteriorPower.linearMap_ext (R := E) (n := 2) (M := WeilRep.U E) (N := Lambda2U E)
  apply AlternatingMap.ext
  intro m
  have hsmul :
      (exteriorPower.ιMulti (R := E) (n := 2) (M := WeilRep.U E)) (fun i : Fin 2 => c • m i) =
        c ^ 2 • (exteriorPower.ιMulti (R := E) (n := 2) (M := WeilRep.U E) m) := by
    have h :=
      (exteriorPower.ιMulti (R := E) (n := 2) (M := WeilRep.U E)).map_smul_univ
        (fun _ : Fin 2 => c) m
    simpa [Finset.prod_const, Fintype.card_fin, pow_two] using h
  simp only [LinearMap.compAlternatingMap_apply, exteriorPower.map_apply_ιMulti,
    LinearMap.smul_apply, LinearMap.id_apply]
  change exteriorPower.ιMulti (R := E) (n := 2) (M := WeilRep.U E)
      ((c • LinearMap.id : WeilRep.U E →ₗ[E] WeilRep.U E) ∘ m) =
    c ^ 2 • exteriorPower.ιMulti (R := E) (n := 2) (M := WeilRep.U E) m
  have hcomp : ((c • LinearMap.id : WeilRep.U E →ₗ[E] WeilRep.U E) ∘ m) = fun i => c • m i := by
    funext i; simp
  rw [hcomp, hsmul]

omit [CharZero E] [HasCycl11 E] in
theorem exteriorPower_map_neg_id :
    exteriorPower.map (R := E) (n := 2) (-LinearMap.id : WeilRep.U E →ₗ[E] WeilRep.U E) =
      LinearMap.id := by
  have h : (-LinearMap.id : WeilRep.U E →ₗ[E] WeilRep.U E) = (-1 : E) • LinearMap.id := by
    ext; simp
  rw [h, exteriorPower_map_smul_id]
  norm_num

theorem weilLambda2_negI : weilLambda2 E WeilRepSL2.negI = LinearMap.id := by
  dsimp [weilLambda2]
  rw [show WeilHom.weilUHom WeilRepSL2.negI = (-LinearMap.id : WeilRep.U E →ₗ[E] WeilRep.U E) from
    WeilRepSL2.weilU_negI, exteriorPower_map_neg_id]

private theorem scalar_one_eq_one :
    (⟨Matrix.scalar (Fin 2) (1 : F), by
      rw [Matrix.scalar_apply, Matrix.det_diagonal]
      simp [Finset.prod_const, Fintype.card_fin]⟩ : SLG) = (1 : SLG) := by
  apply Subtype.ext
  ext i j
  change (Matrix.scalar (Fin 2) (1 : F)) i j = (1 : Matrix (Fin 2) (Fin 2) F) i j
  simp [Matrix.scalar_apply, Matrix.diagonal, Matrix.one_apply]

private theorem scalar_neg_eq_negI :
    (⟨Matrix.scalar (Fin 2) (-1 : F), by
      rw [Matrix.scalar_apply, Matrix.det_diagonal]
      simp [Finset.prod_const, Fintype.card_fin]⟩ : SLG) = WeilRepSL2.negI := by
  apply Subtype.ext
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [Matrix.scalar_apply, Matrix.diagonal, WeilRepSL2.negI, Matrix.neg_apply]

theorem weilLambda2_center (z : SLG) (hz : z ∈ Subgroup.center SLG) :
    weilLambda2 E z = LinearMap.id := by
  obtain ⟨r, hr, heq⟩ :=
    (Matrix.SpecialLinearGroup.mem_center_iff (n := Fin 2) (R := F)).mp hz
  have hrpm : r = 1 ∨ r = -1 := by
    have hr' : r ^ 2 = 1 := by simpa [Fintype.card_fin] using hr
    have hfac : (r - 1) * (r + 1) = 0 := by
      have : r ^ 2 - 1 = 0 := by rw [hr', sub_self]
      convert this using 1; ring
    rcases mul_eq_zero.mp hfac with h | h
    · exact Or.inl (sub_eq_zero.mp h)
    · exact Or.inr (eq_neg_of_add_eq_zero_left h)
  have hz' : z = ⟨Matrix.scalar (Fin 2) r, by
      have : (Matrix.scalar (Fin 2) r).det = r ^ 2 := by
        rw [Matrix.scalar_apply, Matrix.det_diagonal]
        simp [Finset.prod_const, Fintype.card_fin, pow_two]
      rw [this]; simpa [Fintype.card_fin] using hr⟩ := by
    apply Subtype.ext
    exact heq.symm
  rw [hz']
  rcases hrpm with rfl | rfl
  · convert weilLambda2_one E using 2
    exact scalar_one_eq_one
  · convert weilLambda2_negI E using 2
    exact scalar_neg_eq_negI

/-- `⋀²` of the Weil representation, as a monoid homomorphism. -/
@[expose] public def weilLambda2Hom : SLG →* (Lambda2U E →ₗ[E] Lambda2U E) where
  toFun := weilLambda2 E
  map_one' := weilLambda2_one E
  map_mul' := weilLambda2_mul E

public theorem weilLambda2Hom_ker_center :
    Subgroup.center SLG ≤ (weilLambda2Hom E).ker := by
  intro z hz
  rw [MonoidHom.mem_ker, Module.End.one_eq_id]
  exact weilLambda2_center E z hz

/-- **The `PSL₂(𝔽₁₁)`-action on `⋀²U`.**  The centre of `SL₂` acts by `±id` on
`U`, hence trivially on `⋀²U`, so the action descends. -/
@[expose] public def pslLambda2Hom : PSL2F11 →* (Lambda2U E →ₗ[E] Lambda2U E) :=
  QuotientGroup.lift (N := Subgroup.center SLG) (weilLambda2Hom E)
    (weilLambda2Hom_ker_center E)

@[simp] public theorem pslLambda2_mk (g : SLG) :
    pslLambda2Hom E (QuotientGroup.mk g) = weilLambda2 E g := rfl

/-! ## The isotypic projector onto the `10′` summand -/

/-- The ambient action of `PSL₂(𝔽₁₁)` on `⋀²U`. -/
@[expose] public def ambientAct (g : PSL2F11) : Lambda2U E →ₗ[E] Lambda2U E :=
  pslLambda2Hom E g

theorem ambientAct_one : ambientAct E 1 = LinearMap.id := by
  change pslLambda2Hom E 1 = LinearMap.id
  rw [map_one, Module.End.one_eq_id]

theorem ambientAct_mul (g h : PSL2F11) :
    ambientAct E (g * h) = ambientAct E g ∘ₗ ambientAct E h := by
  ext x; simp [ambientAct, map_mul, LinearMap.comp_apply]

/-- Character values of the irreducible `10′` of `PSL₂(𝔽₁₁)`, determined by
element order: `1A↦10, 2A↦2, 3A↦1, 5A/5B↦0, 6A↦-1, 11A/11B↦-1`.  All six values
are rational integers, so this definition is the same over every field. -/
@[expose] public noncomputable def chi10' (g : PSL2F11) : E :=
  let n := orderOf g
  if n = 1 then 10
  else if n = 2 then 2
  else if n = 3 then 1
  else if n = 5 then 0
  else if n = 6 then -1
  else if n = 11 then -1
  else 0

omit [CharZero E] [HasCycl11 E] in
theorem chi10'_eq_of_orderOf_eq {g h : PSL2F11} (ho : orderOf g = orderOf h) :
    chi10' E g = chi10' E h := by
  simp [chi10', ho]

theorem orderOf_conj (g h : PSL2F11) : orderOf (h * g * h⁻¹) = orderOf g := by
  have hpow : ∀ n : ℕ, (h * g * h⁻¹) ^ n = h * (g ^ n) * h⁻¹ := by
    intro n
    induction n with
    | zero => simp
    | succ n ih =>
      rw [pow_succ, pow_succ, ih]
      simp [mul_assoc]
  apply Eq.symm
  rw [orderOf_eq_orderOf_iff]
  intro n
  constructor
  · intro hg
    rw [hpow, hg]
    simp
  · intro hconj
    have h1 : h * (g ^ n) * h⁻¹ = 1 := by rwa [← hpow]
    calc g ^ n = h⁻¹ * (h * (g ^ n) * h⁻¹) * h := by simp [mul_assoc]
      _ = h⁻¹ * 1 * h := by rw [h1]
      _ = 1 := by simp

omit [CharZero E] [HasCycl11 E] in
theorem chi10'_conj (g h : PSL2F11) : chi10' E (h * g * h⁻¹) = chi10' E g :=
  chi10'_eq_of_orderOf_eq E (orderOf_conj g h)

/-- The isotypic projector onto the `10′` summand of `⋀²U`:
`π = (10/|G|) ∑_g χ₁₀'(g) · ρ(g)`, with `|G| = 660`. -/
@[expose] public noncomputable def projectorM : Module.End E (Lambda2U E) :=
  (10 * (660 : E)⁻¹) •
    ∑ g : PSL2F11, chi10' E g • (ambientAct E g : Module.End E (Lambda2U E))

/-- **The `10′` summand `M ⊆ ⋀²U`.** -/
@[expose] public noncomputable def Msub : Submodule E (Lambda2U E) :=
  LinearMap.range (projectorM E)

theorem projectorM_apply (v : Lambda2U E) :
    projectorM E v =
      (10 * (660 : E)⁻¹) • (∑ g : PSL2F11, chi10' E g • ambientAct E g v) := by
  dsimp [projectorM]
  simp only [LinearMap.smul_apply, LinearMap.sum_apply]

/-- Conjugation reindexing equivalence on `PSL₂(𝔽₁₁)`. -/
def conjEquiv (h : PSL2F11) : PSL2F11 ≃ PSL2F11 where
  toFun g := h⁻¹ * g * h
  invFun t := h * t * h⁻¹
  left_inv g := by
    change h * (h⁻¹ * g * h) * h⁻¹ = g
    calc h * (h⁻¹ * g * h) * h⁻¹
        = (h * h⁻¹) * g * (h * h⁻¹) := by simp [mul_assoc]
      _ = g := by simp
  right_inv t := by
    change h⁻¹ * (h * t * h⁻¹) * h = t
    calc h⁻¹ * (h * t * h⁻¹) * h
        = (h⁻¹ * h) * t * (h⁻¹ * h) := by simp [mul_assoc]
      _ = t := by simp

theorem sum_chi_ambient_equivariant (h : PSL2F11) (v : Lambda2U E) :
    (∑ g : PSL2F11, chi10' E g • ambientAct E g (ambientAct E h v)) =
      ambientAct E h (∑ g : PSL2F11, chi10' E g • ambientAct E g v) := by
  have hlink :
      (∑ g : PSL2F11, chi10' E g • ambientAct E g (ambientAct E h v)) =
        ∑ g : PSL2F11, chi10' E g • ambientAct E h (ambientAct E (h⁻¹ * g * h) v) := by
    refine Finset.sum_congr rfl fun g _ => ?_
    have hgh : g * h = h * (h⁻¹ * g * h) := by
      calc g * h = (h * h⁻¹) * g * h := by simp
        _ = h * (h⁻¹ * g * h) := by simp [mul_assoc]
    calc chi10' E g • ambientAct E g (ambientAct E h v)
        = chi10' E g • ambientAct E (g * h) v := by
          rw [← LinearMap.comp_apply, ← ambientAct_mul]
      _ = chi10' E g • ambientAct E (h * (h⁻¹ * g * h)) v := by rw [hgh]
      _ = chi10' E g • ambientAct E h (ambientAct E (h⁻¹ * g * h) v) := by
          rw [ambientAct_mul, LinearMap.comp_apply]
  rw [hlink]
  have hχsum :
      (∑ g : PSL2F11, chi10' E g • ambientAct E h (ambientAct E (h⁻¹ * g * h) v)) =
        ∑ g : PSL2F11,
          chi10' E (h⁻¹ * g * h) • ambientAct E h (ambientAct E (h⁻¹ * g * h) v) := by
    refine Finset.sum_congr rfl fun g _ => ?_
    have hχ : chi10' E g = chi10' E (h⁻¹ * g * h) := by
      have hraw : chi10' E g = chi10' E (h⁻¹ * g * (h⁻¹)⁻¹) := (chi10'_conj E g h⁻¹).symm
      rwa [inv_inv] at hraw
    rw [hχ]
  rw [hχsum]
  have hpull :
      (∑ g : PSL2F11,
          chi10' E (h⁻¹ * g * h) • ambientAct E h (ambientAct E (h⁻¹ * g * h) v)) =
        ∑ g : PSL2F11,
          ambientAct E h (chi10' E (h⁻¹ * g * h) • ambientAct E (h⁻¹ * g * h) v) := by
    refine Finset.sum_congr rfl fun g _ => ?_
    rw [LinearMap.map_smul]
  rw [hpull]
  have hmap :
      (∑ g : PSL2F11,
          ambientAct E h (chi10' E (h⁻¹ * g * h) • ambientAct E (h⁻¹ * g * h) v)) =
        ambientAct E h
          (∑ g : PSL2F11, chi10' E (h⁻¹ * g * h) • ambientAct E (h⁻¹ * g * h) v) :=
    (map_sum (ambientAct E h)
      (fun g => chi10' E (h⁻¹ * g * h) • ambientAct E (h⁻¹ * g * h) v) _).symm
  rw [hmap]
  apply congrArg
  exact Fintype.sum_equiv (conjEquiv h)
    (fun g => chi10' E (h⁻¹ * g * h) • ambientAct E (h⁻¹ * g * h) v)
    (fun t => chi10' E t • ambientAct E t v)
    (fun g => rfl)

/-- **The character projector intertwines the ambient action**, so its range
`M` is a subrepresentation. -/
public theorem projectorM_equivariant (h : PSL2F11) (v : Lambda2U E) :
    projectorM E (ambientAct E h v) = ambientAct E h (projectorM E v) := by
  rw [projectorM_apply, projectorM_apply, map_smul, sum_chi_ambient_equivariant]

/-- `M` is stable under the ambient action. -/
public theorem ambientAct_mem (g : PSL2F11) {v : Lambda2U E} (hv : v ∈ Msub E) :
    ambientAct E g v ∈ Msub E := by
  obtain ⟨w, rfl⟩ := hv
  exact ⟨ambientAct E g w, projectorM_equivariant E g w⟩

end WeilLambda2
end V14Formalization
