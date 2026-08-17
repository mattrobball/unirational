/-
Writeup Cor 6.1 geometric carrier (minimal green path):

* U = even Weil module, finrank 6
* Λ²U carries linear PSL₂(F₁₁)-action via `weilUHom` (center {±I} acts as id on Λ²)
* Ambient = full Λ²U; carrier X = ℙ(Λ²U) with faithful linear-projective G-action
* Packaged as `SmoothProjectiveGVariety` (`V14Variety`)
-/
module

public import V14Formalization.WeilHom
public import V14Formalization.Definitions
public import Mathlib.LinearAlgebra.ExteriorPower.Basic
public import Mathlib.LinearAlgebra.ExteriorPower.Basis
public import Mathlib.LinearAlgebra.Dimension.Finrank
public import Mathlib.LinearAlgebra.Dimension.StrongRankCondition
public import Mathlib.LinearAlgebra.FreeModule.Finite.Basic
public import Mathlib.LinearAlgebra.Basis.VectorSpace
public import Mathlib.LinearAlgebra.Projectivization.Basic
public import Mathlib.LinearAlgebra.Projectivization.PSL.PSL2
public import Mathlib.LinearAlgebra.Center
public import Mathlib.GroupTheory.QuotientGroup.Basic
public import Mathlib.GroupTheory.Subgroup.Center
public import Mathlib.GroupTheory.Subgroup.Simple
public import Mathlib.LinearAlgebra.Matrix.Determinant.Basic
public import Mathlib.Data.Matrix.Basic
public import Mathlib.NumberTheory.LegendreSymbol.AddCharacter
public import Mathlib.Data.Set.PowersetCard
public import Mathlib.Order.Hom.PowersetCard
public import Mathlib.Data.Finset.Sort
public import Mathlib.Tactic.FinCases

open scoped BigOperators LinearAlgebra.Projectivization MatrixGroups
open Matrix Matrix.SpecialLinearGroup exteriorPower Module

noncomputable section

namespace V14Formalization
namespace GeometricFanoCarrier

public abbrev k := WeilRep.K
public abbrev F := ZMod 11
public abbrev SLG := SpecialLinearGroup (Fin 2) F
public abbrev PSL2F11 : Type := PSL(2, F)
public abbrev U := WeilRep.U

@[expose] public instance : Fact (Nat.Prime 11) := ⟨Nat.prime_eleven⟩
@[expose] public instance : Group PSL2F11 := inferInstance

/-! ## finrank U = 6 via evalEven / extendEven -/

/-- Evaluation of even functions at coordinates 0..5. -/
@[expose] public def evalEven : U →ₗ[k] (Fin 6 → k) where
  toFun f j := f.1 (j.val : ZMod 11)
  map_add' _ _ := funext fun _ => rfl
  map_smul' _ _ := funext fun _ => rfl

/-- Pointwise even extension of a 6-tuple (before packaging as an element of `U`). -/
@[expose] public def extendEvenFun (v : Fin 6 → k) : ZMod 11 → k := fun x =>
  if hle : x.val ≤ 5 then v ⟨x.val, Nat.lt_succ_of_le hle⟩
  else v ⟨11 - x.val, by
    have : 6 ≤ x.val := by omega
    have : x.val ≤ 10 := Nat.lt_succ_iff.mp (ZMod.val_lt x)
    omega⟩

public theorem extendEvenFun_even (v : Fin 6 → k) (x : ZMod 11) :
    extendEvenFun v (-x) = extendEvenFun v x := by
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
@[expose] public def extendEven : (Fin 6 → k) →ₗ[k] U where
  toFun v := ⟨extendEvenFun v, extendEvenFun_even v⟩
  map_add' := by
    intro v w
    apply Subtype.ext
    funext x
    change extendEvenFun (v + w) x = extendEvenFun v x + extendEvenFun w x
    simp only [extendEvenFun, Pi.add_apply]
    split_ifs <;> rfl
  map_smul' := by
    intro r v
    apply Subtype.ext
    funext x
    change extendEvenFun (r • v) x = (r • extendEvenFun v) x
    simp only [extendEvenFun, Pi.smul_apply, smul_eq_mul]
    split_ifs <;> rfl

public theorem evalEven_extendEven : evalEven ∘ₗ extendEven = LinearMap.id := by
  apply LinearMap.ext; intro v; funext j
  have hjlt : j.val < 11 := Nat.lt_trans j.isLt (by decide : 6 < 11)
  have hval : ((j.val : ZMod 11)).val = j.val := ZMod.val_cast_of_lt hjlt
  have hjle : j.val ≤ 5 := Nat.lt_succ_iff.mp j.isLt
  -- evalEven (extendEven v) j = extendEvenFun v (j.val : ZMod 11)
  change extendEvenFun v (j.val : ZMod 11) = v j
  unfold extendEvenFun
  rw [dif_pos (by rwa [hval] : ((j.val : ZMod 11)).val ≤ 5)]
  -- now v ⟨((j.val:ZMod).val), _⟩ = v j and ((j.val:ZMod).val)=j.val
  congr 1
  exact Fin.ext hval

public theorem evalEven_injective : Function.Injective evalEven := by
  intro f g heq
  apply Subtype.ext; funext x
  have hfun := congr_fun heq
  by_cases hle : x.val ≤ 5
  · have hxlt : x.val < 6 := Nat.lt_succ_of_le hle
    have hcast : ((x.val : ZMod 11)).val = x.val :=
      ZMod.val_cast_of_lt (Nat.lt_trans hxlt (by decide : 6 < 11))
    have hxeq : (x.val : ZMod 11) = x := (ZMod.val_injective 11) hcast
    simpa [evalEven, hxeq] using hfun ⟨x.val, hxlt⟩
  · -- use evenness and evaluate at -x (which has val ≤ 5)
    have hx0 : x ≠ 0 := by
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

theorem extendEven_injective : Function.Injective extendEven := by
  intro v w h
  have he := congrArg evalEven h
  have hv : evalEven (extendEven v) = v := LinearMap.congr_fun evalEven_extendEven v
  have hw : evalEven (extendEven w) = w := LinearMap.congr_fun evalEven_extendEven w
  rwa [hv, hw] at he

public theorem finrank_U : Module.finrank k U = 6 := by
  have hfin6 : Module.finrank k (Fin 6 → k) = 6 := by
    rw [Module.finrank_fintype_fun_eq_card]; decide
  have hle : Module.finrank k U ≤ 6 := by
    have := LinearMap.finrank_le_finrank_of_injective (f := evalEven) evalEven_injective
    rwa [hfin6] at this
  have hge : 6 ≤ Module.finrank k U := by
    have := LinearMap.finrank_le_finrank_of_injective (f := extendEven) extendEven_injective
    rwa [hfin6] at this
  omega

@[expose] public instance : FiniteDimensional k U :=
  Module.finite_of_finrank_eq_succ (n := 5) (by rw [finrank_U])
@[expose] public instance : Module.Free k U := Module.Free.of_divisionRing k U

/-! ## Λ²U -/

public abbrev Lambda2U : Type := ↥(⋀[k]^2 U)
@[expose] public instance : AddCommGroup Lambda2U := inferInstance
@[expose] public instance : Module k Lambda2U := inferInstance
@[expose] public instance : Module.Free k Lambda2U := inferInstance
@[expose] public instance : FiniteDimensional k Lambda2U := inferInstance

/-! ## SL₂ / PSL action on Λ²U -/

@[expose] public def weilLambda2 (g : SLG) : Lambda2U →ₗ[k] Lambda2U :=
  exteriorPower.map 2 (WeilHom.weilUHom g)

public theorem weilLambda2_one : weilLambda2 1 = LinearMap.id := by
  dsimp [weilLambda2]
  rw [map_one]
  exact exteriorPower.map_id

public theorem weilLambda2_mul (g h : SLG) :
    weilLambda2 (g * h) = weilLambda2 g ∘ₗ weilLambda2 h := by
  dsimp [weilLambda2]
  rw [map_mul, Module.End.mul_eq_comp, exteriorPower.map_comp]

theorem exteriorPower_map_smul_id (c : k) :
    exteriorPower.map (R := k) (n := 2) (c • LinearMap.id : U →ₗ[k] U) =
      (c ^ 2) • (LinearMap.id : Lambda2U →ₗ[k] Lambda2U) := by
  apply exteriorPower.linearMap_ext (R := k) (n := 2) (M := U) (N := Lambda2U)
  apply AlternatingMap.ext
  intro m
  have hsmul :
      (exteriorPower.ιMulti (R := k) (n := 2) (M := U)) (fun i : Fin 2 => c • m i) =
        c ^ 2 • (exteriorPower.ιMulti (R := k) (n := 2) (M := U) m) := by
    have h :=
      (exteriorPower.ιMulti (R := k) (n := 2) (M := U)).map_smul_univ
        (fun _ : Fin 2 => c) m
    simpa [Finset.prod_const, Fintype.card_fin, pow_two] using h
  simp only [LinearMap.compAlternatingMap_apply, exteriorPower.map_apply_ιMulti,
    LinearMap.smul_apply, LinearMap.id_apply]
  change exteriorPower.ιMulti (R := k) (n := 2) (M := U)
      ((c • LinearMap.id : U →ₗ[k] U) ∘ m) =
    c ^ 2 • exteriorPower.ιMulti (R := k) (n := 2) (M := U) m
  have hcomp : ((c • LinearMap.id : U →ₗ[k] U) ∘ m) = fun i => c • m i := by
    funext i; simp
  rw [hcomp, hsmul]

theorem exteriorPower_map_neg_id :
    exteriorPower.map (R := k) (n := 2) (-LinearMap.id : U →ₗ[k] U) =
      LinearMap.id := by
  have h : (-LinearMap.id : U →ₗ[k] U) = (-1 : k) • LinearMap.id := by
    ext; simp
  rw [h, exteriorPower_map_smul_id]
  norm_num

theorem weilLambda2_negI :
    weilLambda2 WeilRepSL2.negI = LinearMap.id := by
  dsimp [weilLambda2]
  rw [show WeilHom.weilUHom WeilRepSL2.negI = (-LinearMap.id : U →ₗ[k] U) from
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
    weilLambda2 z = LinearMap.id := by
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
  · convert weilLambda2_one using 2
    exact scalar_one_eq_one
  · convert weilLambda2_negI using 2
    exact scalar_neg_eq_negI

@[expose] public def weilLambda2Hom : SLG →* (Lambda2U →ₗ[k] Lambda2U) where
  toFun := weilLambda2
  map_one' := weilLambda2_one
  map_mul' := weilLambda2_mul

public theorem weilLambda2Hom_ker_center :
    Subgroup.center SLG ≤ weilLambda2Hom.ker := by
  intro z hz
  rw [MonoidHom.mem_ker, Module.End.one_eq_id]
  exact weilLambda2_center z hz

@[expose] public def pslLambda2Hom : PSL2F11 →* (Lambda2U →ₗ[k] Lambda2U) :=
  QuotientGroup.lift (N := Subgroup.center SLG) weilLambda2Hom weilLambda2Hom_ker_center

@[simp] public theorem pslLambda2_mk (g : SLG) :
    pslLambda2Hom (QuotientGroup.mk g) = weilLambda2 g := by
  rfl

/-! ## Nontriviality of Λ²(T) -/

@[expose] public def pureWedge (u v : U) : Lambda2U :=
  exteriorPower.ιMulti k 2 ![u, v]

@[expose] public def b0 : U := extendEven (fun i => if i = (0 : Fin 6) then (1 : k) else 0)
@[expose] public def b1 : U := extendEven (fun i => if i = (1 : Fin 6) then (1 : k) else 0)

public theorem evalEven_b0 :
    evalEven b0 = fun i => if i = (0 : Fin 6) then (1 : k) else 0 := by
  funext i
  simpa [b0, LinearMap.comp_apply] using
    congrFun (LinearMap.congr_fun evalEven_extendEven
      (fun i => if i = (0 : Fin 6) then (1 : k) else 0)) i

public theorem evalEven_b1 :
    evalEven b1 = fun i => if i = (1 : Fin 6) then (1 : k) else 0 := by
  funext i
  simpa [b1, LinearMap.comp_apply] using
    congrFun (LinearMap.congr_fun evalEven_extendEven
      (fun i => if i = (1 : Fin 6) then (1 : k) else 0)) i

/-- Standard Plücker generator e₀∧e₁ is nonzero in Λ²(k⁶) (exterior dual = 1). -/
theorem std_wedge_ne_zero :
    exteriorPower.ιMulti k 2
      ![Pi.basisFun k (Fin 6) 0, Pi.basisFun k (Fin 6) 1] ≠ 0 := by
  let B := Pi.basisFun k (Fin 6)
  have hcard : ({(0 : Fin 6), (1 : Fin 6)} : Finset (Fin 6)).card = 2 := by decide
  let s : Set.powersetCard (Fin 6) 2 := Set.powersetCard.ofCard hcard
  have hdiag :
      exteriorPower.ιMultiDual k 2 B s (exteriorPower.ιMulti_family k 2 B s) = 1 :=
    exteriorPower.ιMultiDual_apply_diag k 2 B s
  have hne1 : ({(1 : Fin 6)} : Finset (Fin 6)).Nonempty := Finset.singleton_nonempty _
  have hord0 : Set.powersetCard.ofFinEmbEquiv.symm s (0 : Fin 2) = (0 : Fin 6) := by
    change Finset.orderEmbOfFin ({(0 : Fin 6), 1}) hcard ⟨0, by decide⟩ = 0
    rw [Finset.orderEmbOfFin_zero hcard (by decide)]
    rw [Finset.min'_insert 0 {1} hne1, Finset.min'_singleton,
      min_eq_left (by decide : (0 : Fin 6) ≤ 1)]
  have hord1 : Set.powersetCard.ofFinEmbEquiv.symm s (1 : Fin 2) = (1 : Fin 6) := by
    change Finset.orderEmbOfFin ({(0 : Fin 6), 1}) hcard ⟨1, by decide⟩ = 1
    have hmem := Finset.orderEmbOfFin_mem ({(0 : Fin 6), 1}) hcard ⟨1, by decide⟩
    have hne0 :
        Finset.orderEmbOfFin ({(0 : Fin 6), 1}) hcard ⟨1, by decide⟩ ≠ 0 := by
      intro heq
      have h0eq :
          Finset.orderEmbOfFin ({(0 : Fin 6), 1}) hcard ⟨0, by decide⟩ = 0 := by
        rw [Finset.orderEmbOfFin_zero hcard (by decide)]
        rw [Finset.min'_insert 0 {1} hne1, Finset.min'_singleton,
          min_eq_left (by decide : (0 : Fin 6) ≤ 1)]
      have := (Finset.orderEmbOfFin ({(0 : Fin 6), 1}) hcard).injective
        (h0eq.trans heq.symm)
      exact absurd (Fin.ext_iff.mp this) (by decide : ¬(0 : ℕ) = 1)
    simp only [Finset.mem_insert, Finset.mem_singleton] at hmem
    rcases hmem with h | h
    · exact absurd h hne0
    · exact h
  have hfam :
      exteriorPower.ιMulti_family k 2 B s =
        exteriorPower.ιMulti k 2 ![B 0, B 1] := by
    change exteriorPower.ιMulti k 2
        (fun i => B (Set.powersetCard.ofFinEmbEquiv.symm s i)) =
      exteriorPower.ιMulti k 2 ![B 0, B 1]
    congr 1
    funext i
    fin_cases i <;> simp [hord0, hord1]
  intro hz
  have : (1 : k) = 0 := by
    calc (1 : k)
        = exteriorPower.ιMultiDual k 2 B s
            (exteriorPower.ιMulti_family k 2 B s) := hdiag.symm
      _ = exteriorPower.ιMultiDual k 2 B s
            (exteriorPower.ιMulti k 2 ![B 0, B 1]) := by rw [hfam]
      _ = exteriorPower.ιMultiDual k 2 B s 0 := by rw [hz]
      _ = 0 := by simp
  exact absurd this one_ne_zero

public theorem evalEven_b0_basis :
    evalEven b0 = Pi.basisFun k (Fin 6) 0 := by
  funext i
  rw [evalEven_b0, Pi.basisFun_apply]
  simp [Pi.single_apply]

public theorem evalEven_b1_basis :
    evalEven b1 = Pi.basisFun k (Fin 6) 1 := by
  funext i
  rw [evalEven_b1, Pi.basisFun_apply]
  simp [Pi.single_apply]

/-- Pure wedge b₀∧b₁ is nonzero (transport std wedge along evalEven). -/
theorem pure_b01_ne : pureWedge b0 b1 ≠ 0 := by
  intro hz
  have hmap :
      exteriorPower.map (R := k) (n := 2) evalEven (pureWedge b0 b1) =
        exteriorPower.ιMulti k 2 ![evalEven b0, evalEven b1] := by
    dsimp [pureWedge]
    rw [exteriorPower.map_apply_ιMulti]
    congr 1; funext i; fin_cases i <;> rfl
  have hstd :
      exteriorPower.ιMulti k 2
        ![Pi.basisFun k (Fin 6) 0, Pi.basisFun k (Fin 6) 1] = 0 := by
    calc exteriorPower.ιMulti k 2
          ![Pi.basisFun k (Fin 6) 0, Pi.basisFun k (Fin 6) 1]
        = exteriorPower.ιMulti k 2 ![evalEven b0, evalEven b1] := by
            congr 1; funext i; fin_cases i <;>
              simp [evalEven_b0_basis, evalEven_b1_basis]
      _ = exteriorPower.map (R := k) (n := 2) evalEven (pureWedge b0 b1) := hmap.symm
      _ = 0 := by rw [hz, map_zero]
  exact std_wedge_ne_zero hstd

public theorem ψ_half_ne_one :
    WeilRep.ψ ((1 : F) * (2 : F)⁻¹) ≠ 1 := by
  intro h
  have hz : (1 : F) * (2 : F)⁻¹ = 0 :=
    (AddChar.IsPrimitive.zmod_char_eq_one_iff 11 WeilRep.ψ_primitive _).mp h
  exact (mul_ne_zero (by decide : (1 : F) ≠ 0)
    (inv_ne_zero (by decide : (2 : F) ≠ 0))) hz

private theorem b0_support {x : ZMod 11} (hx : b0.1 x ≠ 0) : x = 0 := by
  dsimp [b0, extendEven, extendEvenFun] at hx
  by_cases hle : x.val ≤ 5
  · rw [dif_pos hle] at hx
    -- hx : (if ⟨x.val⟩ = 0 then 1 else 0) ≠ 0
    by_cases hv : (⟨x.val, Nat.lt_succ_of_le hle⟩ : Fin 6) = 0
    · exact (ZMod.val_eq_zero x).mp (by simpa using congrArg Fin.val hv)
    · simp [hv] at hx
  · rw [dif_neg hle] at hx
    by_cases hv : (⟨11 - x.val, by
        have : 6 ≤ x.val := by omega
        have : x.val ≤ 10 := Nat.lt_succ_iff.mp (ZMod.val_lt x)
        omega⟩ : Fin 6) = 0
    · have : 11 - x.val = 0 := by simpa using congrArg Fin.val hv
      have : 6 ≤ x.val := by omega
      have : x.val ≤ 10 := Nat.lt_succ_iff.mp (ZMod.val_lt x)
      omega
    · simp [hv] at hx

private theorem F_val_one : (1 : F).val = 1 :=
  ZMod.val_one 11

private theorem F_val_neg_one : (-1 : F).val = 10 :=
  ZMod.val_neg_one 10

private theorem b1_support {x : ZMod 11} (hx : b1.1 x ≠ 0) :
    x = 1 ∨ x = (-1 : F) := by
  dsimp [b1, extendEven, extendEvenFun] at hx
  by_cases hle : x.val ≤ 5
  · rw [dif_pos hle] at hx
    by_cases hv : (⟨x.val, Nat.lt_succ_of_le hle⟩ : Fin 6) = 1
    · left
      exact (ZMod.val_injective 11) (by
        have : x.val = 1 := by simpa using congrArg Fin.val hv
        simpa [F_val_one] using this)
    · simp [hv] at hx
  · rw [dif_neg hle] at hx
    by_cases hv : (⟨11 - x.val, by
        have : 6 ≤ x.val := by omega
        have : x.val ≤ 10 := Nat.lt_succ_iff.mp (ZMod.val_lt x)
        omega⟩ : Fin 6) = 1
    · right
      exact (ZMod.val_injective 11) (by
        have hval : 11 - x.val = 1 := by simpa using congrArg Fin.val hv
        have : x.val = 10 := by
          have : 6 ≤ x.val := by omega
          have : x.val ≤ 10 := Nat.lt_succ_iff.mp (ZMod.val_lt x)
          omega
        simpa [F_val_neg_one] using this)
    · simp [hv] at hx

public theorem T_b0 : WeilRep.T_even_b 1 b0 = b0 := by
  apply Subtype.ext; funext x
  change WeilRep.ψ (1 * x ^ 2 * WeilRep.twoInv) * b0.1 x = b0.1 x
  by_cases hx : b0.1 x = 0
  · rw [hx, mul_zero]
  · have hx0 : x = 0 := b0_support hx
    simp [hx0, WeilRep.twoInv, WeilRep.ψ_zero]

public theorem T_b1 : WeilRep.T_even_b 1 b1 =
    WeilRep.ψ ((1 : F) * (2 : F)⁻¹) • b1 := by
  apply Subtype.ext; funext x
  change WeilRep.ψ (1 * x ^ 2 * WeilRep.twoInv) * b1.1 x =
    WeilRep.ψ ((1 : F) * (2 : F)⁻¹) * b1.1 x
  simp only [WeilRep.twoInv, one_mul]
  by_cases hx : b1.1 x = 0
  · rw [hx, mul_zero, mul_zero]
  · have hxsq : x ^ 2 = (1 : F) := by
      rcases b1_support hx with rfl | rfl
      · ring
      · ring
    simp only [hxsq, one_mul]

theorem weilLambda2_Tmat_ne_id : weilLambda2 WeilRep.Tmat ≠ LinearMap.id := by
  intro h
  have hU : WeilHom.weilUHom WeilRep.Tmat = WeilRep.T_even_b 1 := WeilRepSL2.weilU_Tmat
  have hmap : exteriorPower.map (R := k) (n := 2) (WeilRep.T_even_b 1) =
      (LinearMap.id : Lambda2U →ₗ[k] Lambda2U) := by
    simpa [weilLambda2, hU] using h
  have hwedge :
      pureWedge (WeilRep.T_even_b 1 b0) (WeilRep.T_even_b 1 b1) = pureWedge b0 b1 := by
    have happly :=
      congrArg (fun L : Lambda2U →ₗ[k] Lambda2U => L (pureWedge b0 b1)) hmap
    -- map T (b0∧b1) = b0∧b1 and map T (b0∧b1) = T b0 ∧ T b1
    dsimp [pureWedge] at happly ⊢
    have hι := exteriorPower.map_apply_ιMulti (R := k) (n := 2) (WeilRep.T_even_b 1) ![b0, b1]
    -- hι : map T (ιMulti ![b0,b1]) = ιMulti (T ∘ ![b0,b1])
    have hcomp : (WeilRep.T_even_b 1 ∘ ![b0, b1]) =
        ![WeilRep.T_even_b 1 b0, WeilRep.T_even_b 1 b1] := by
      funext i; fin_cases i <;> rfl
    rw [hι, hcomp] at happly
    exact happly
  rw [T_b0, T_b1] at hwedge
  have hsc :
      pureWedge b0 (WeilRep.ψ ((1 : F) * (2 : F)⁻¹) • b1) =
        WeilRep.ψ ((1 : F) * (2 : F)⁻¹) • pureWedge b0 b1 := by
    dsimp [pureWedge]
    -- ιMulti ![b0, λ•b1] = λ • ιMulti ![b0,b1] via map_update_smul at index 1
    have hh :=
      (exteriorPower.ιMulti (R := k) (n := 2) (M := U)).map_update_smul
        ![b0, b1] (1 : Fin 2) (WeilRep.ψ ((1 : F) * (2 : F)⁻¹)) b1
    -- hh : ιMulti (update ![b0,b1] 1 (λ•b1)) = λ • ιMulti (update ![b0,b1] 1 b1)
    have hup : Function.update ![b0, b1] 1 b1 = ![b0, b1] := by
      funext i; fin_cases i <;> simp
    have hup' :
        Function.update ![b0, b1] 1 (WeilRep.ψ ((1 : F) * (2 : F)⁻¹) • b1) =
          ![b0, WeilRep.ψ ((1 : F) * (2 : F)⁻¹) • b1] := by
      funext i; fin_cases i <;> simp
    rw [hup, hup'] at hh
    exact hh
  rw [hsc] at hwedge
  have hψ : WeilRep.ψ ((1 : F) * (2 : F)⁻¹) = 1 := by
    have hne := pure_b01_ne
    have : (WeilRep.ψ ((1 : F) * (2 : F)⁻¹) - 1) • pureWedge b0 b1 = 0 := by
      rw [sub_smul, hwedge, one_smul, sub_self]
    exact sub_eq_zero.mp ((smul_eq_zero.mp this).resolve_right hne)
  exact ψ_half_ne_one hψ

@[expose] public instance PSL2F11_isSimple : IsSimpleGroup PSL2F11 :=
  Matrix.ProjectiveSpecialLinearGroup.rank_two_simple (F := F)
    (by simp only [Nat.card_zmod]; decide)

public theorem pslLambda2Hom_injective : Function.Injective pslLambda2Hom := by
  have hN : pslLambda2Hom.ker.Normal := inferInstance
  rcases hN.eq_bot_or_eq_top with hbot | htop
  · exact (MonoidHom.ker_eq_bot_iff _).mp hbot
  · exfalso
    have h1 : pslLambda2Hom (QuotientGroup.mk WeilRep.Tmat) = 1 :=
      MonoidHom.mem_ker.mp (by rw [htop]; exact Subgroup.mem_top _)
    have : weilLambda2 WeilRep.Tmat = LinearMap.id := by
      simpa [pslLambda2_mk, Module.End.one_eq_id] using h1
    exact weilLambda2_Tmat_ne_id this

/-! ## Centerlessness of PSL(2, F₁₁) via simplicity + nonabelian -/

private theorem coe_Smat_Tmat :
    (WeilRep.Smat * WeilRep.Tmat).1 = !![0, -1; 1, 1] := by
  ext i j; fin_cases i <;> fin_cases j <;>
    simp [WeilRep.Smat, WeilRep.Tmat, SpecialLinearGroup.coe_mul,
      Matrix.mul_apply, Fin.sum_univ_two]

private theorem coe_Tmat_Smat :
    (WeilRep.Tmat * WeilRep.Smat).1 = !![1, -1; 1, 0] := by
  ext i j; fin_cases i <;> fin_cases j <;>
    simp [WeilRep.Smat, WeilRep.Tmat, SpecialLinearGroup.coe_mul,
      Matrix.mul_apply, Fin.sum_univ_two]

/-- S and T do not commute in PSL₂(F₁₁). -/
theorem ST_ne_TS_psl :
    (QuotientGroup.mk (WeilRep.Smat * WeilRep.Tmat) : PSL2F11) ≠
      QuotientGroup.mk (WeilRep.Tmat * WeilRep.Smat) := by
  intro heq
  have hmem :
      WeilRep.Smat * WeilRep.Tmat * (WeilRep.Tmat * WeilRep.Smat)⁻¹ ∈
        Subgroup.center SLG := by
    have : QuotientGroup.mk (WeilRep.Smat * WeilRep.Tmat * (WeilRep.Tmat * WeilRep.Smat)⁻¹) =
        (1 : PSL2F11) := by
      rw [QuotientGroup.mk_mul, QuotientGroup.mk_inv, heq, mul_inv_cancel]
    exact (QuotientGroup.eq_one_iff _).mp this
  obtain ⟨r, hr, heqr⟩ :=
    (Matrix.SpecialLinearGroup.mem_center_iff (n := Fin 2) (R := F)).mp hmem
  -- ST = (scalar r) * TS as matrices
  have heqmat :
      (WeilRep.Smat * WeilRep.Tmat).1 =
        Matrix.scalar (Fin 2) r * (WeilRep.Tmat * WeilRep.Smat).1 := by
    have hmul :
        WeilRep.Smat * WeilRep.Tmat =
          ⟨Matrix.scalar (Fin 2) r, by
              have : (Matrix.scalar (Fin 2) r).det = r ^ 2 := by
                rw [Matrix.scalar_apply, Matrix.det_diagonal]
                simp [Finset.prod_const, Fintype.card_fin, pow_two]
              rw [this]; simpa [Fintype.card_fin] using hr⟩ *
            (WeilRep.Tmat * WeilRep.Smat) := by
      apply Subtype.ext
      have hassoc :
          (WeilRep.Smat * WeilRep.Tmat * (WeilRep.Tmat * WeilRep.Smat)⁻¹ *
            (WeilRep.Tmat * WeilRep.Smat)).1 =
          (WeilRep.Smat * WeilRep.Tmat).1 := by
        simp [SpecialLinearGroup.coe_mul, mul_assoc, inv_mul_cancel]
      calc (WeilRep.Smat * WeilRep.Tmat).1
          = (WeilRep.Smat * WeilRep.Tmat * (WeilRep.Tmat * WeilRep.Smat)⁻¹ *
              (WeilRep.Tmat * WeilRep.Smat)).1 := hassoc.symm
        _ = (WeilRep.Smat * WeilRep.Tmat * (WeilRep.Tmat * WeilRep.Smat)⁻¹).1 *
              (WeilRep.Tmat * WeilRep.Smat).1 := by simp [SpecialLinearGroup.coe_mul]
        _ = Matrix.scalar (Fin 2) r * (WeilRep.Tmat * WeilRep.Smat).1 := by rw [heqr.symm]
    simpa [SpecialLinearGroup.coe_mul] using congrArg (fun g : SLG => g.1) hmul
  rw [coe_Smat_Tmat, coe_Tmat_Smat] at heqmat
  -- entry (0,0): 0 = r * 1 ⇒ r = 0, but r² = 1
  have hr0 : r = 0 := by
    have h00 := congrArg (fun m : Matrix (Fin 2) (Fin 2) F => m 0 0) heqmat
    simp [Matrix.mul_apply, Matrix.scalar_apply, Matrix.diagonal, Fin.sum_univ_two] at h00
    -- 0 = r * 1
    simpa using h00.symm
  have hr2 : r ^ 2 = 1 := by simpa [Fintype.card_fin] using hr
  simp [hr0] at hr2

public theorem PSL2F11_isCenterless : IsCenterless PSL2F11 := by
  haveI : IsSimpleGroup PSL2F11 := inferInstance
  have hZ : (Subgroup.center PSL2F11).Normal := inferInstance
  rcases hZ.eq_bot_or_eq_top with h | h
  · exact h
  · exfalso
    let s : PSL2F11 := QuotientGroup.mk WeilRep.Smat
    let t : PSL2F11 := QuotientGroup.mk WeilRep.Tmat
    have hab : s * t = t * s := by
      have hs := Subgroup.mem_center_iff.mp (by rw [h]; exact Subgroup.mem_top s) t
      exact hs.symm
    exact ST_ne_TS_psl (by simpa [s, t, QuotientGroup.mk_mul] using hab)


/-! ## Projectivization variety on Λ²U (ambient of the Plücker model) -/

def lambda2Rep : FaithfulLinearRep k PSL2F11 Lambda2U where
  ρ := pslLambda2Hom
  finiteDimensional := inferInstance
  faithful := pslLambda2Hom_injective

/-- Ambient projective space ℙ(Λ²U) with faithful linear-projective PSL action.
Used as the Plücker ambient of Gr(2,U); the geometric Gr carrier is in
`GeometricV14Carrier`. -/
def ambientProjectiveVariety : SmoothProjectiveGVariety k PSL2F11 :=
  lambda2Rep.projectivizationVariety PSL2F11_isCenterless

#print axioms finrank_U
#print axioms pslLambda2Hom_injective
#print axioms ambientProjectiveVariety

end GeometricFanoCarrier
end V14Formalization
