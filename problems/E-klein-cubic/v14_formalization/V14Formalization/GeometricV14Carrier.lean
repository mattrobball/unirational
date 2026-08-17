/-
Geometric Cor 6.1 carrier: Gr(2,U) ⊂ ℙ(Λ²U) as decomposable points.
-/
module

public import V14Formalization.GeometricFanoCarrier
public import V14Formalization.CentralizerD12
public import V14Formalization.PSLCard
public import Mathlib.LinearAlgebra.Projectivization.Basic
public import Mathlib.LinearAlgebra.Matrix.GeneralLinearGroup.Card
public import Mathlib.GroupTheory.Index
public import Mathlib.Algebra.Field.ZMod
public import Mathlib.GroupTheory.SpecificGroups.Cyclic
public import Mathlib.RingTheory.RootsOfUnity.Basic
public import Mathlib.NumberTheory.Cyclotomic.PrimitiveRoots
public import Mathlib.RingTheory.RootsOfUnity.PrimitiveRoots
public import Mathlib.RingTheory.PowerBasis
public import Mathlib.RingTheory.Polynomial.Cyclotomic.Basic
public import Mathlib.FieldTheory.IntermediateField.Adjoin.Basic
public import Mathlib.FieldTheory.IntermediateField.Algebraic
public import Mathlib.FieldTheory.KummerPolynomial
public import Mathlib.FieldTheory.Minpoly.Field
public import Mathlib.RingTheory.PrincipalIdealDomain
public import Mathlib.LinearAlgebra.FreeModule.Basic
public import Mathlib.LinearAlgebra.FreeModule.Finite.Basic
public import Mathlib.LinearAlgebra.Basis.VectorSpace
public import Mathlib.LinearAlgebra.Charpoly.Basic
public import Mathlib.Algebra.Module.LinearMap.End
public import Mathlib.Algebra.Polynomial.Degree.SmallDegree
public import Mathlib.Algebra.Polynomial.EraseLead
public import Mathlib.Algebra.Polynomial.RingDivision
public import Mathlib.Algebra.Polynomial.Div
public import Mathlib.Algebra.Polynomial.FieldDivision
public import Mathlib.Algebra.Polynomial.SpecificDegree
public import Mathlib.Data.Rat.Lemmas
public import Mathlib.Data.Set.PowersetCard
public import Mathlib.Order.Hom.PowersetCard
public import Mathlib.Data.Finset.Sort
public import Mathlib.Tactic.FinCases
public import Mathlib.LinearAlgebra.FiniteDimensional.Lemmas
public import Mathlib.LinearAlgebra.Dimension.OrzechProperty
public import Mathlib.LinearAlgebra.Dual.Lemmas
public import Mathlib.GroupTheory.Coset.Card
public import Mathlib.GroupTheory.Sylow
public import Mathlib.GroupTheory.PGroup
public import Mathlib.GroupTheory.Index
public import Mathlib.Algebra.Group.Subgroup.Finite
public import Mathlib.Data.Nat.Factorization.Basic
public import Mathlib.Data.Fintype.Card
public import Mathlib.Data.Set.Card
public import Mathlib.LinearAlgebra.Trace
public import Mathlib.LinearAlgebra.Projection
public import Mathlib.Algebra.Group.Idempotent
public import Mathlib.LinearAlgebra.Semisimple
public import Mathlib.LinearAlgebra.ExteriorPower.Basic
public import Mathlib.LinearAlgebra.ExteriorPower.Basis
public import Mathlib.LinearAlgebra.Matrix.Charpoly.Coeff
public import Mathlib.LinearAlgebra.Charpoly.ToMatrix
public import Mathlib.RingTheory.AdjoinRoot
public import Mathlib.RingTheory.Trace.Basic
public import Mathlib.LinearAlgebra.Dimension.Constructions
public import Mathlib.RingTheory.AlgebraTower
public import Mathlib.LinearAlgebra.Matrix.ToLin
public import Mathlib.LinearAlgebra.Matrix.Trace
public import Mathlib.Algebra.Polynomial.Eval.Defs
public import Mathlib.RingTheory.Ideal.Quotient.Defs
public import Mathlib.Algebra.BigOperators.Ring.Finset
public import Mathlib.Data.Fintype.BigOperators
public import Mathlib.Data.Finset.Card
public import Mathlib.RingTheory.Polynomial.Basic
public import Mathlib.Algebra.GroupWithZero.Associated
public import Mathlib.LinearAlgebra.FiniteDimensional.Lemmas
public import Mathlib.LinearAlgebra.Charpoly.Basic
public import Mathlib.FieldTheory.Minpoly.Field
public import Mathlib.RingTheory.PrincipalIdealDomain

open scoped LinearAlgebra.Projectivization MatrixGroups
open Matrix Matrix.SpecialLinearGroup exteriorPower Module Polynomial IntermediateField
open LinearMap (IsProj)
open AdjoinRoot
open BigOperators Set

noncomputable section

namespace V14Formalization
namespace GeometricV14Carrier

open GeometricFanoCarrier

public abbrev k := GeometricFanoCarrier.k
public abbrev F := GeometricFanoCarrier.F
public abbrev SLG := GeometricFanoCarrier.SLG
public abbrev PSL2F11 := GeometricFanoCarrier.PSL2F11
public abbrev U := GeometricFanoCarrier.U
public abbrev Lambda2U := GeometricFanoCarrier.Lambda2U

/-! ## Decomposable points -/

@[expose] public def IsDecomposable (p : ℙ k Lambda2U) : Prop :=
  ∃ (u v : U) (hne : pureWedge u v ≠ 0),
    LinearIndependent k ![u, v] ∧
      p = Projectivization.mk k (pureWedge u v) hne

@[expose] public def V14Point : Type := { p : ℙ k Lambda2U // IsDecomposable p }

theorem b01_independent : LinearIndependent k ![b0, b1] := by
  rw [LinearIndependent.pair_iff]
  intro a b hab
  have he := congrArg evalEven hab
  have r0 := congrFun he ⟨0, by decide⟩
  have r1 := congrFun he ⟨1, by decide⟩
  simp [map_add, map_smul, evalEven_b0, evalEven_b1, Pi.add_apply, Pi.smul_apply,
    smul_eq_mul] at r0 r1
  exact ⟨by simpa using r0, by simpa using r1⟩

@[expose] public def ambientAct (g : PSL2F11) : Lambda2U →ₗ[k] Lambda2U := pslLambda2Hom g

theorem ambientAct_one : ambientAct 1 = LinearMap.id := by
  change pslLambda2Hom 1 = LinearMap.id
  rw [map_one, Module.End.one_eq_id]

theorem ambientAct_mul (g h : PSL2F11) :
    ambientAct (g * h) = ambientAct g ∘ₗ ambientAct h := by
  ext x; simp [ambientAct, map_mul, LinearMap.comp_apply]

public theorem ambientAct_injective (g : PSL2F11) : Function.Injective (ambientAct g) := by
  intro a b hab
  have hinv : ambientAct g⁻¹ ∘ₗ ambientAct g = LinearMap.id := by
    rw [← ambientAct_mul, inv_mul_cancel, ambientAct_one]
  have h := congrArg (ambientAct g⁻¹) hab
  -- ambientAct g⁻¹ (ambientAct g a) = ambientAct g⁻¹ (ambientAct g b)
  change (ambientAct g⁻¹ ∘ₗ ambientAct g) a = (ambientAct g⁻¹ ∘ₗ ambientAct g) b at h
  rwa [hinv, LinearMap.id_apply, LinearMap.id_apply] at h

@[expose] public def actPM (g : PSL2F11) (p : ℙ k Lambda2U) : ℙ k Lambda2U :=
  Projectivization.map (ambientAct g) (ambientAct_injective g) p

theorem pureWedge_map (g : SLG) (u v : U) :
    pureWedge (WeilHom.weilUHom g u) (WeilHom.weilUHom g v) =
      weilLambda2 g (pureWedge u v) := by
  dsimp [pureWedge, weilLambda2]
  rw [exteriorPower.map_apply_ιMulti]
  congr 1; funext i; fin_cases i <;> rfl

public theorem actPM_preserves_decomposable (g : PSL2F11) {p : ℙ k Lambda2U}
    (hp : IsDecomposable p) : IsDecomposable (actPM g p) := by
  obtain ⟨u, v, hne, ⟨hI, rfl⟩⟩ := hp
  classical
  -- lift g ∈ PSL to a representative in SL
  set gLift : SLG := Quotient.out g with hgLift
  have hg : (QuotientGroup.mk gLift : PSL2F11) = g := by
    rw [hgLift]; exact Quotient.out_eq g
  set u' := WeilHom.weilUHom gLift u
  set v' := WeilHom.weilUHom gLift v
  have hU_left :
      WeilHom.weilUHom gLift⁻¹ ∘ₗ WeilHom.weilUHom gLift = LinearMap.id := by
    have h : WeilRepSL2.weilU gLift⁻¹ ∘ₗ WeilRepSL2.weilU gLift = LinearMap.id := by
      rw [← WeilHom.weilU_mul, inv_mul_cancel]
      exact WeilRepSL2.weilU_one
    exact h
  have hinjU : Function.Injective (WeilHom.weilUHom gLift) := by
    intro x y hxy
    have hx : WeilHom.weilUHom gLift⁻¹ (WeilHom.weilUHom gLift x) = x := by
      have := LinearMap.congr_fun hU_left x
      rwa [LinearMap.comp_apply, LinearMap.id_apply] at this
    have hy : WeilHom.weilUHom gLift⁻¹ (WeilHom.weilUHom gLift y) = y := by
      have := LinearMap.congr_fun hU_left y
      rwa [LinearMap.comp_apply, LinearMap.id_apply] at this
    rw [← hx, ← hy, hxy]
  have hI' : LinearIndependent k ![u', v'] := by
    have hcomp : ![u', v'] = ⇑(WeilHom.weilUHom gLift) ∘ ![u, v] := by
      funext i; fin_cases i <;> rfl
    rw [hcomp]
    exact hI.map' _ (LinearMap.ker_eq_bot_of_injective hinjU)
  have hpure := pureWedge_map gLift u v
  have hL_left : weilLambda2 gLift⁻¹ ∘ₗ weilLambda2 gLift = LinearMap.id := by
    rw [← weilLambda2_mul, inv_mul_cancel, weilLambda2_one]
  have hne' : pureWedge u' v' ≠ 0 := by
    intro hz
    have h0 : (weilLambda2 gLift⁻¹ ∘ₗ weilLambda2 gLift) (pureWedge u v) = 0 := by
      -- hpure : u'∧v' = weilLambda2 gLift (u∧v)
      rw [LinearMap.comp_apply, ← hpure, hz, map_zero]
    rw [hL_left, LinearMap.id_apply] at h0
    exact hne h0
  refine ⟨u', v', hne', hI', ?_⟩
  dsimp [actPM]
  rw [Projectivization.map_mk]
  -- mk (ambientAct g pure) _ = mk (u' ∧ v') hne'
  apply (Projectivization.mk_eq_mk_iff k _ _ _ hne').mpr
  refine ⟨1, ?_⟩
  -- goal: 1 • (u' ∧ v') = ambientAct g pure
  rw [one_smul]
  dsimp [ambientAct, u', v']
  -- pslLambda2Hom g = weilLambda2 gLift, and u'∧v' = weilLambda2 gLift (u∧v)
  rw [← hg, pslLambda2_mk]
  exact hpure

@[expose] public def actV14 (g : PSL2F11) (x : V14Point) : V14Point :=
  ⟨actPM g x.1, actPM_preserves_decomposable g x.2⟩

theorem actPM_one (p : ℙ k Lambda2U) : actPM 1 p = p := by
  induction p using Projectivization.ind with
  | h v hv =>
    dsimp [actPM]
    rw [Projectivization.map_mk]
    have hA : ambientAct 1 v = v := by rw [ambientAct_one, LinearMap.id_apply]
    exact (Projectivization.mk_eq_mk_iff' k (ambientAct 1 v) v
      (by rw [hA]; exact hv) hv).mpr ⟨1, by rw [one_smul, hA]⟩

theorem actPM_mul (g h : PSL2F11) (p : ℙ k Lambda2U) :
    actPM (g * h) p = actPM g (actPM h p) := by
  induction p using Projectivization.ind with
  | h v hv =>
    dsimp [actPM]
    rw [Projectivization.map_mk, Projectivization.map_mk, Projectivization.map_mk]
    have hA : ambientAct (g * h) v = ambientAct g (ambientAct h v) := by
      rw [ambientAct_mul, LinearMap.comp_apply]
    exact (Projectivization.mk_eq_mk_iff' k _ _ _ _).mpr ⟨1, by rw [one_smul, hA]⟩

public theorem actV14_one (x : V14Point) : actV14 1 x = x :=
  Subtype.ext (actPM_one x.1)

public theorem actV14_mul (g h : PSL2F11) (x : V14Point) :
    actV14 (g * h) x = actV14 g (actV14 h x) :=
  Subtype.ext (actPM_mul g h x.1)

@[expose] public instance : SMul PSL2F11 V14Point where smul := actV14
@[expose] public instance : MulAction PSL2F11 V14Point where
  one_smul := actV14_one
  mul_smul := actV14_mul

/-! ## b2, pure wedge, Tmat moves -/

def b2 : U := extendEven (fun i => if i = (2 : Fin 6) then (1 : k) else 0)

theorem evalEven_b2 :
    evalEven b2 = fun i => if i = (2 : Fin 6) then (1 : k) else 0 := by
  funext i
  simpa [b2, LinearMap.comp_apply] using
    congrFun (LinearMap.congr_fun evalEven_extendEven
      (fun i => if i = (2 : Fin 6) then (1 : k) else 0)) i

theorem evalEven_b2_basis : evalEven b2 = Pi.basisFun k (Fin 6) 2 := by
  funext i; rw [evalEven_b2, Pi.basisFun_apply]; simp [Pi.single_apply]

theorem b0b1_b2_independent : LinearIndependent k ![b0 + b1, b2] := by
  rw [LinearIndependent.pair_iff]
  intro a b hab
  have he := congrArg evalEven hab
  have r0 := congrFun he ⟨0, by decide⟩
  have r2 := congrFun he ⟨2, by decide⟩
  simp [map_add, map_smul, evalEven_b0, evalEven_b1, evalEven_b2,
    Pi.add_apply, Pi.smul_apply, smul_eq_mul] at r0 r2
  exact ⟨by simpa using r0, by simpa using r2⟩

theorem pure_b0b1_b2_ne : pureWedge (b0 + b1) b2 ≠ 0 := by
  intro hz
  let B := Pi.basisFun k (Fin 6)
  have hmap :
      exteriorPower.map (R := k) (n := 2) evalEven (pureWedge (b0 + b1) b2) =
        exteriorPower.ιMulti k 2 ![evalEven (b0 + b1), evalEven b2] := by
    dsimp [pureWedge]; rw [exteriorPower.map_apply_ιMulti]
    congr 1; funext i; fin_cases i <;> rfl
  have he01 : evalEven (b0 + b1) = B 0 + B 1 := by
    rw [map_add, evalEven_b0_basis, evalEven_b1_basis]
  have he2 : evalEven b2 = B 2 := evalEven_b2_basis
  have hsum :
      exteriorPower.ιMulti k 2 ![B 0 + B 1, B 2] =
        exteriorPower.ιMulti k 2 ![B 0, B 2] +
          exteriorPower.ιMulti k 2 ![B 1, B 2] := by
    have h := (exteriorPower.ιMulti k 2 (M := Fin 6 → k)).map_update_add
      (fun _ : Fin 2 => B 2) (0 : Fin 2) (B 0) (B 1)
    have hu : Function.update (fun _ : Fin 2 => B 2) 0 (B 0 + B 1) = ![B 0 + B 1, B 2] := by
      funext i; fin_cases i <;> simp
    have hu0 : Function.update (fun _ : Fin 2 => B 2) 0 (B 0) = ![B 0, B 2] := by
      funext i; fin_cases i <;> simp
    have hu1 : Function.update (fun _ : Fin 2 => B 2) 0 (B 1) = ![B 1, B 2] := by
      funext i; fin_cases i <;> simp
    simpa [hu, hu0, hu1] using h
  have hz' : exteriorPower.ιMulti k 2 ![B 0 + B 1, B 2] = 0 := by
    have := congrArg (exteriorPower.map (R := k) (n := 2) evalEven) hz
    rw [map_zero, hmap, he01, he2] at this
    exact this
  have h0 : exteriorPower.ιMulti k 2 ![B 0, B 2] =
      - exteriorPower.ιMulti k 2 ![B 1, B 2] :=
    eq_neg_of_add_eq_zero_left (by rw [← hsum, hz'])
  have hcard : ({(0 : Fin 6), (2 : Fin 6)} : Finset (Fin 6)).card = 2 := by decide
  let s : Set.powersetCard (Fin 6) 2 := Set.powersetCard.ofCard hcard
  have hdiag := exteriorPower.ιMultiDual_apply_diag k 2 B s
  have hne2 : ({(2 : Fin 6)} : Finset (Fin 6)).Nonempty := Finset.singleton_nonempty _
  have hord0 : Set.powersetCard.ofFinEmbEquiv.symm s (0 : Fin 2) = (0 : Fin 6) := by
    change Finset.orderEmbOfFin ({(0 : Fin 6), 2}) hcard ⟨0, by decide⟩ = 0
    rw [Finset.orderEmbOfFin_zero hcard (by decide),
      Finset.min'_insert 0 {2} hne2, Finset.min'_singleton,
      min_eq_left (by decide : (0 : Fin 6) ≤ 2)]
  have hord1 : Set.powersetCard.ofFinEmbEquiv.symm s (1 : Fin 2) = (2 : Fin 6) := by
    change Finset.orderEmbOfFin ({(0 : Fin 6), 2}) hcard ⟨1, by decide⟩ = 2
    have hmem := Finset.orderEmbOfFin_mem ({(0 : Fin 6), 2}) hcard ⟨1, by decide⟩
    have hne0 :
        Finset.orderEmbOfFin ({(0 : Fin 6), 2}) hcard ⟨1, by decide⟩ ≠ 0 := by
      intro heq
      have h0eq :
          Finset.orderEmbOfFin ({(0 : Fin 6), 2}) hcard ⟨0, by decide⟩ = 0 := by
        rw [Finset.orderEmbOfFin_zero hcard (by decide),
          Finset.min'_insert 0 {2} hne2, Finset.min'_singleton,
          min_eq_left (by decide : (0 : Fin 6) ≤ 2)]
      have := (Finset.orderEmbOfFin ({(0 : Fin 6), 2}) hcard).injective
        (h0eq.trans heq.symm)
      exact absurd (Fin.ext_iff.mp this) (by decide : ¬(0 : ℕ) = 1)
    simp only [Finset.mem_insert, Finset.mem_singleton] at hmem
    rcases hmem with h | h
    · exact absurd h hne0
    · exact h
  have hfam :
      exteriorPower.ιMulti_family k 2 B s = exteriorPower.ιMulti k 2 ![B 0, B 2] := by
    change exteriorPower.ιMulti k 2 (fun i => B (Set.powersetCard.ofFinEmbEquiv.symm s i)) =
      exteriorPower.ιMulti k 2 ![B 0, B 2]
    congr 1; funext i; fin_cases i <;> simp [hord0, hord1]
  have h1 : exteriorPower.ιMultiDual k 2 B s (exteriorPower.ιMulti k 2 ![B 0, B 2]) = 1 := by
    rw [← hfam, hdiag]
  have hnd :
      exteriorPower.ιMultiDual k 2 B s (exteriorPower.ιMulti k 2 ![B 1, B 2]) = 0 := by
    rw [exteriorPower.ιMultiDual_apply_ιMulti]
    simp only [Matrix.det_fin_two, Basis.coord_apply]
    change
      (B.repr (B 1)) (Set.powersetCard.ofFinEmbEquiv.symm s 0) *
        (B.repr (B 2)) (Set.powersetCard.ofFinEmbEquiv.symm s 1) -
      (B.repr (B 1)) (Set.powersetCard.ofFinEmbEquiv.symm s 1) *
        (B.repr (B 2)) (Set.powersetCard.ofFinEmbEquiv.symm s 0) = 0
    rw [hord0, hord1]
    simp [Pi.basisFun_repr, Pi.single_apply]
  have : (1 : k) = 0 := by
    have hd := congrArg (exteriorPower.ιMultiDual k 2 B s) h0
    rw [h1, map_neg, hnd, neg_zero] at hd
    exact hd
  exact absurd this one_ne_zero

private theorem b2_support {x : ZMod 11} (hx : b2.1 x ≠ 0) :
    x = (2 : F) ∨ x = (-2 : F) := by
  dsimp [b2, extendEven, extendEvenFun] at hx
  by_cases hle : x.val ≤ 5
  · rw [dif_pos hle] at hx
    by_cases hv : (⟨x.val, Nat.lt_succ_of_le hle⟩ : Fin 6) = 2
    · left
      have hval : x.val = 2 := by simpa using congrArg Fin.val hv
      have h2 : (2 : F).val = 2 := ZMod.val_cast_of_lt (by decide : 2 < 11)
      exact (ZMod.val_injective 11).eq_iff.mp (hval.trans h2.symm)
    · simp [hv] at hx
  · rw [dif_neg hle] at hx
    by_cases hv : (⟨11 - x.val, by
        have : 6 ≤ x.val := by omega
        have : x.val ≤ 10 := Nat.lt_succ_iff.mp (ZMod.val_lt x)
        omega⟩ : Fin 6) = 2
    · right
      have hdiff : 11 - x.val = 2 := by simpa using congrArg Fin.val hv
      have hxval : x.val = 9 := by omega
      haveI : NeZero (2 : F) := ⟨by decide⟩
      have hneg : (-(2 : F)).val = 11 - (2 : F).val := ZMod.val_neg_of_ne_zero _
      have h2 : (2 : F).val = 2 := ZMod.val_cast_of_lt (by decide : 2 < 11)
      have hnegval : (-(2 : F)).val = 9 := by simp [hneg, h2]
      exact (ZMod.val_injective 11).eq_iff.mp (hxval.trans hnegval.symm)
    · simp [hv] at hx

theorem T_b2 : WeilRep.T_even_b 1 b2 =
    WeilRep.ψ ((2 : F) ^ 2 * (2 : F)⁻¹) • b2 := by
  -- Same shape as GeometricFanoCarrier.T_b1
  apply Subtype.ext; funext x
  change WeilRep.ψ (1 * x ^ 2 * WeilRep.twoInv) * b2.1 x =
    WeilRep.ψ ((2 : F) ^ 2 * WeilRep.twoInv) * b2.1 x
  simp only [WeilRep.twoInv, one_mul]
  by_cases hx : b2.1 x = 0
  · rw [hx]; simp only [mul_zero]
  · -- On support of b2, x ∈ {2, -2}, so x² = 2²
    cases b2_support hx with
    | inl h => rw [h]
    | inr h =>
      rw [h]
      have hsq : (-(2 : F)) ^ 2 = (2 : F) ^ 2 := by ring
      rw [hsq]

/-- If (b0 + ψ(1/2) b1) ∧ b2 is parallel to (b0 + b1) ∧ b2 then ψ(1/2) = 1. -/
theorem plane_ratio_forces_ψ_half (μ : k)
    (hμ : pureWedge (b0 + WeilRep.ψ ((1 : F) * (2 : F)⁻¹) • b1) b2 =
      μ • pureWedge (b0 + b1) b2) : False := by
  -- Work after evalEven in Λ²(Fin 6 → k) with basis vectors B i
  let B := Pi.basisFun k (Fin 6)
  let ψh : k := WeilRep.ψ ((1 : F) * (2 : F)⁻¹)
  have hmapL :
      exteriorPower.map (R := k) (n := 2) evalEven
        (pureWedge (b0 + ψh • b1) b2) =
        exteriorPower.ιMulti k 2 ![B 0 + ψh • B 1, B 2] := by
    dsimp [pureWedge]
    rw [exteriorPower.map_apply_ιMulti]
    have he : evalEven (b0 + ψh • b1) = B 0 + ψh • B 1 := by
      rw [map_add, map_smul, evalEven_b0_basis, evalEven_b1_basis]
    have he2 : evalEven b2 = B 2 := evalEven_b2_basis
    congr 1; funext i; fin_cases i <;> simp [he, he2]
  have hmapR :
      exteriorPower.map (R := k) (n := 2) evalEven
        (μ • pureWedge (b0 + b1) b2) =
        μ • exteriorPower.ιMulti k 2 ![B 0 + B 1, B 2] := by
    rw [map_smul]
    dsimp [pureWedge]
    have h := exteriorPower.map_apply_ιMulti (R := k) (n := 2) evalEven ![b0 + b1, b2]
    have he : evalEven (b0 + b1) = B 0 + B 1 := by
      rw [map_add, evalEven_b0_basis, evalEven_b1_basis]
    have he2 : evalEven b2 = B 2 := evalEven_b2_basis
    have hcomp : evalEven ∘ ![b0 + b1, b2] = ![B 0 + B 1, B 2] := by
      funext i; fin_cases i <;> simp [he, he2]
    simpa [hcomp] using congrArg (fun z => μ • z) h
  -- Expand wedges by bilinearity
  have hsumL :
      exteriorPower.ιMulti k 2 ![B 0 + ψh • B 1, B 2] =
        exteriorPower.ιMulti k 2 ![B 0, B 2] +
          ψh • exteriorPower.ιMulti k 2 ![B 1, B 2] := by
    have hadd := (exteriorPower.ιMulti k 2 (M := Fin 6 → k)).map_update_add
      (fun _ : Fin 2 => B 2) (0 : Fin 2) (B 0) (ψh • B 1)
    have hsm := (exteriorPower.ιMulti k 2 (M := Fin 6 → k)).map_update_smul
      (fun _ : Fin 2 => B 2) (0 : Fin 2) ψh (B 1)
    have hu : Function.update (fun _ : Fin 2 => B 2) 0 (B 0 + ψh • B 1) =
        ![B 0 + ψh • B 1, B 2] := by funext i; fin_cases i <;> simp
    have hu0 : Function.update (fun _ : Fin 2 => B 2) 0 (B 0) = ![B 0, B 2] := by
      funext i; fin_cases i <;> simp
    have hu1 : Function.update (fun _ : Fin 2 => B 2) 0 (ψh • B 1) =
        ![ψh • B 1, B 2] := by funext i; fin_cases i <;> simp
    have hu1' : Function.update (fun _ : Fin 2 => B 2) 0 (B 1) = ![B 1, B 2] := by
      funext i; fin_cases i <;> simp
    have h1 : exteriorPower.ιMulti k 2 ![ψh • B 1, B 2] =
        ψh • exteriorPower.ιMulti k 2 ![B 1, B 2] := by
      rwa [hu1, hu1'] at hsm
    have h2 : exteriorPower.ιMulti k 2 ![B 0 + ψh • B 1, B 2] =
        exteriorPower.ιMulti k 2 ![B 0, B 2] +
          exteriorPower.ιMulti k 2 ![ψh • B 1, B 2] := by
      rwa [hu, hu0, hu1] at hadd
    rw [h2, h1]
  have hsumR :
      exteriorPower.ιMulti k 2 ![B 0 + B 1, B 2] =
        exteriorPower.ιMulti k 2 ![B 0, B 2] +
          exteriorPower.ιMulti k 2 ![B 1, B 2] := by
    have h := (exteriorPower.ιMulti k 2 (M := Fin 6 → k)).map_update_add
      (fun _ : Fin 2 => B 2) (0 : Fin 2) (B 0) (B 1)
    have hu : Function.update (fun _ : Fin 2 => B 2) 0 (B 0 + B 1) =
        ![B 0 + B 1, B 2] := by funext i; fin_cases i <;> simp
    have hu0 : Function.update (fun _ : Fin 2 => B 2) 0 (B 0) = ![B 0, B 2] := by
      funext i; fin_cases i <;> simp
    have hu1 : Function.update (fun _ : Fin 2 => B 2) 0 (B 1) = ![B 1, B 2] := by
      funext i; fin_cases i <;> simp
    rwa [hu, hu0, hu1] at h
  -- Equality after map
  have heq :
      exteriorPower.ιMulti k 2 ![B 0, B 2] +
          ψh • exteriorPower.ιMulti k 2 ![B 1, B 2] =
        μ • exteriorPower.ιMulti k 2 ![B 0, B 2] +
          μ • exteriorPower.ιMulti k 2 ![B 1, B 2] := by
    have := congrArg (exteriorPower.map (R := k) (n := 2) evalEven) hμ
    -- LHS of hμ maps to hmapL, RHS to hmapR; expand via hsumL/hsumR
    rw [hmapL, hmapR, hsumL, hsumR, smul_add] at this
    exact this
  -- Dualize against e0∧e2 and e1∧e2
  have hcard02 : ({(0 : Fin 6), (2 : Fin 6)} : Finset (Fin 6)).card = 2 := by decide
  have hcard12 : ({(1 : Fin 6), (2 : Fin 6)} : Finset (Fin 6)).card = 2 := by decide
  let s02 : Set.powersetCard (Fin 6) 2 := Set.powersetCard.ofCard hcard02
  let s12 : Set.powersetCard (Fin 6) 2 := Set.powersetCard.ofCard hcard12
  -- Ordering lemmas for ofFinEmbEquiv
  have hord02_0 : Set.powersetCard.ofFinEmbEquiv.symm s02 (0 : Fin 2) = (0 : Fin 6) := by
    change Finset.orderEmbOfFin ({(0 : Fin 6), 2}) hcard02 ⟨0, by decide⟩ = 0
    rw [Finset.orderEmbOfFin_zero hcard02 (by decide),
      Finset.min'_insert 0 {2} (Finset.singleton_nonempty _), Finset.min'_singleton,
      min_eq_left (by decide : (0 : Fin 6) ≤ 2)]
  have hord02_1 : Set.powersetCard.ofFinEmbEquiv.symm s02 (1 : Fin 2) = (2 : Fin 6) := by
    change Finset.orderEmbOfFin ({(0 : Fin 6), 2}) hcard02 ⟨1, by decide⟩ = 2
    have hmem := Finset.orderEmbOfFin_mem ({(0 : Fin 6), 2}) hcard02 ⟨1, by decide⟩
    have hne0 :
        Finset.orderEmbOfFin ({(0 : Fin 6), 2}) hcard02 ⟨1, by decide⟩ ≠ 0 := by
      intro heq
      have h0eq :
          Finset.orderEmbOfFin ({(0 : Fin 6), 2}) hcard02 ⟨0, by decide⟩ = 0 := by
        rw [Finset.orderEmbOfFin_zero hcard02 (by decide),
          Finset.min'_insert 0 {2} (Finset.singleton_nonempty _), Finset.min'_singleton,
          min_eq_left (by decide : (0 : Fin 6) ≤ 2)]
      exact absurd (Fin.ext_iff.mp
        ((Finset.orderEmbOfFin ({(0 : Fin 6), 2}) hcard02).injective
          (h0eq.trans heq.symm))) (by decide : ¬(0 : ℕ) = 1)
    simp only [Finset.mem_insert, Finset.mem_singleton] at hmem
    rcases hmem with h | h
    · exact absurd h hne0
    · exact h
  have hord12_0 : Set.powersetCard.ofFinEmbEquiv.symm s12 (0 : Fin 2) = (1 : Fin 6) := by
    change Finset.orderEmbOfFin ({(1 : Fin 6), 2}) hcard12 ⟨0, by decide⟩ = 1
    rw [Finset.orderEmbOfFin_zero hcard12 (by decide),
      Finset.min'_insert 1 {2} (Finset.singleton_nonempty _), Finset.min'_singleton,
      min_eq_left (by decide : (1 : Fin 6) ≤ 2)]
  have hord12_1 : Set.powersetCard.ofFinEmbEquiv.symm s12 (1 : Fin 2) = (2 : Fin 6) := by
    change Finset.orderEmbOfFin ({(1 : Fin 6), 2}) hcard12 ⟨1, by decide⟩ = 2
    have hmem := Finset.orderEmbOfFin_mem ({(1 : Fin 6), 2}) hcard12 ⟨1, by decide⟩
    have hne1 :
        Finset.orderEmbOfFin ({(1 : Fin 6), 2}) hcard12 ⟨1, by decide⟩ ≠ 1 := by
      intro heq
      have h0eq :
          Finset.orderEmbOfFin ({(1 : Fin 6), 2}) hcard12 ⟨0, by decide⟩ = 1 := by
        rw [Finset.orderEmbOfFin_zero hcard12 (by decide),
          Finset.min'_insert 1 {2} (Finset.singleton_nonempty _), Finset.min'_singleton,
          min_eq_left (by decide : (1 : Fin 6) ≤ 2)]
      exact absurd (Fin.ext_iff.mp
        ((Finset.orderEmbOfFin ({(1 : Fin 6), 2}) hcard12).injective
          (h0eq.trans heq.symm))) (by decide : ¬(0 : ℕ) = 1)
    simp only [Finset.mem_insert, Finset.mem_singleton] at hmem
    rcases hmem with h | h
    · exact absurd h hne1
    · exact h
  -- Dual values
  have d02_02 : exteriorPower.ιMultiDual k 2 B s02
      (exteriorPower.ιMulti k 2 ![B 0, B 2]) = 1 := by
    have hfam : exteriorPower.ιMulti_family k 2 B s02 =
        exteriorPower.ιMulti k 2 ![B 0, B 2] := by
      change exteriorPower.ιMulti k 2
          (fun i => B (Set.powersetCard.ofFinEmbEquiv.symm s02 i)) =
        exteriorPower.ιMulti k 2 ![B 0, B 2]
      congr 1; funext i; fin_cases i <;> simp [hord02_0, hord02_1]
    rw [← hfam, exteriorPower.ιMultiDual_apply_diag]
  have d02_12 : exteriorPower.ιMultiDual k 2 B s02
      (exteriorPower.ιMulti k 2 ![B 1, B 2]) = 0 := by
    rw [exteriorPower.ιMultiDual_apply_ιMulti]
    simp only [Matrix.det_fin_two, Basis.coord_apply]
    change
      (B.repr (B 1)) (Set.powersetCard.ofFinEmbEquiv.symm s02 0) *
        (B.repr (B 2)) (Set.powersetCard.ofFinEmbEquiv.symm s02 1) -
      (B.repr (B 1)) (Set.powersetCard.ofFinEmbEquiv.symm s02 1) *
        (B.repr (B 2)) (Set.powersetCard.ofFinEmbEquiv.symm s02 0) = 0
    rw [hord02_0, hord02_1]; simp
  have d12_12 : exteriorPower.ιMultiDual k 2 B s12
      (exteriorPower.ιMulti k 2 ![B 1, B 2]) = 1 := by
    have hfam : exteriorPower.ιMulti_family k 2 B s12 =
        exteriorPower.ιMulti k 2 ![B 1, B 2] := by
      change exteriorPower.ιMulti k 2
          (fun i => B (Set.powersetCard.ofFinEmbEquiv.symm s12 i)) =
        exteriorPower.ιMulti k 2 ![B 1, B 2]
      congr 1; funext i; fin_cases i <;> simp [hord12_0, hord12_1]
    rw [← hfam, exteriorPower.ιMultiDual_apply_diag]
  have d12_02 : exteriorPower.ιMultiDual k 2 B s12
      (exteriorPower.ιMulti k 2 ![B 0, B 2]) = 0 := by
    rw [exteriorPower.ιMultiDual_apply_ιMulti]
    simp only [Matrix.det_fin_two, Basis.coord_apply]
    change
      (B.repr (B 0)) (Set.powersetCard.ofFinEmbEquiv.symm s12 0) *
        (B.repr (B 2)) (Set.powersetCard.ofFinEmbEquiv.symm s12 1) -
      (B.repr (B 0)) (Set.powersetCard.ofFinEmbEquiv.symm s12 1) *
        (B.repr (B 2)) (Set.powersetCard.ofFinEmbEquiv.symm s12 0) = 0
    rw [hord12_0, hord12_1]; simp
  -- Apply duals to heq
  have hmu : μ = 1 := by
    have hd := congrArg (exteriorPower.ιMultiDual k 2 B s02) heq
    simp only [map_add, map_smul, d02_02, d02_12, smul_eq_mul, mul_zero, add_zero,
      zero_add, mul_one] at hd
    -- hd : 1 = μ
    exact hd.symm
  have hψ : ψh = 1 := by
    have hd := congrArg (exteriorPower.ιMultiDual k 2 B s12) heq
    simp only [map_add, map_smul, d12_02, d12_12, smul_eq_mul, mul_zero, add_zero,
      zero_add, mul_one, hmu] at hd
    -- hd : ψh = 1
    exact hd
  exact ψ_half_ne_one hψ

theorem Tmat_moves_plane :
    ¬ ∃ μ : k,
      pureWedge (WeilRep.T_even_b 1 (b0 + b1)) (WeilRep.T_even_b 1 b2) =
        μ • pureWedge (b0 + b1) b2 := by
  rintro ⟨μ, hμ⟩
  have hT0 : WeilRep.T_even_b 1 (b0 + b1) =
      b0 + WeilRep.ψ ((1 : F) * (2 : F)⁻¹) • b1 := by
    rw [map_add, T_b0, T_b1]
  have hμ' :
      pureWedge (b0 + WeilRep.ψ ((1 : F) * (2 : F)⁻¹) • b1)
        (WeilRep.ψ ((2 : F) ^ 2 * (2 : F)⁻¹) • b2) =
        μ • pureWedge (b0 + b1) b2 := by
    rwa [hT0, T_b2] at hμ
  have hψ2ne : WeilRep.ψ ((2 : F) ^ 2 * (2 : F)⁻¹) ≠ 0 := by
    intro h0
    have : WeilRep.ψ ((2 : F) ^ 2 * (2 : F)⁻¹) *
        WeilRep.ψ (-((2 : F) ^ 2 * (2 : F)⁻¹)) = 1 := by
      rw [← WeilRep.ψ_add]; simp
    rw [h0, zero_mul] at this
    exact absurd this (by norm_num)
  -- Factor ψ2 from second slot: ιMulti ![v, c•b2] = c • ιMulti ![v, b2]
  have hpull :
      pureWedge (b0 + WeilRep.ψ ((1 : F) * (2 : F)⁻¹) • b1)
        (WeilRep.ψ ((2 : F) ^ 2 * (2 : F)⁻¹) • b2) =
      WeilRep.ψ ((2 : F) ^ 2 * (2 : F)⁻¹) •
        pureWedge (b0 + WeilRep.ψ ((1 : F) * (2 : F)⁻¹) • b1) b2 := by
    dsimp [pureWedge]
    have hh :=
      (exteriorPower.ιMulti (R := k) (n := 2) (M := U)).map_update_smul
        ![b0 + WeilRep.ψ ((1 : F) * (2 : F)⁻¹) • b1, b2] (1 : Fin 2)
        (WeilRep.ψ ((2 : F) ^ 2 * (2 : F)⁻¹)) b2
    have hup :
        Function.update
          ![b0 + WeilRep.ψ ((1 : F) * (2 : F)⁻¹) • b1, b2] 1 b2 =
          ![b0 + WeilRep.ψ ((1 : F) * (2 : F)⁻¹) • b1, b2] := by
      funext i; fin_cases i <;> simp
    have hup' :
        Function.update
          ![b0 + WeilRep.ψ ((1 : F) * (2 : F)⁻¹) • b1, b2] 1
          (WeilRep.ψ ((2 : F) ^ 2 * (2 : F)⁻¹) • b2) =
          ![b0 + WeilRep.ψ ((1 : F) * (2 : F)⁻¹) • b1,
            WeilRep.ψ ((2 : F) ^ 2 * (2 : F)⁻¹) • b2] := by
      funext i; fin_cases i <;> simp
    rw [hup, hup'] at hh
    exact hh
  have hpar : pureWedge (b0 + WeilRep.ψ ((1 : F) * (2 : F)⁻¹) • b1) b2 =
      (μ * (WeilRep.ψ ((2 : F) ^ 2 * (2 : F)⁻¹))⁻¹) • pureWedge (b0 + b1) b2 := by
    -- ψ2 • mid = μ • right, so mid = (ψ2⁻¹ * μ) • right = (μ * ψ2⁻¹) • right
    have h' : WeilRep.ψ ((2 : F) ^ 2 * (2 : F)⁻¹) •
        pureWedge (b0 + WeilRep.ψ ((1 : F) * (2 : F)⁻¹) • b1) b2 =
        μ • pureWedge (b0 + b1) b2 := by
      rw [← hpull, hμ']
    apply_fun (fun z => (WeilRep.ψ ((2 : F) ^ 2 * (2 : F)⁻¹))⁻¹ • z) at h'
    simp only [smul_smul, inv_mul_cancel₀ hψ2ne, one_smul] at h'
    -- h' : mid = (ψ2⁻¹ * μ) • right
    simpa [mul_comm] using h'
  exact plane_ratio_forces_ψ_half _ hpar

def movedPoint : V14Point :=
  ⟨Projectivization.mk k (pureWedge (b0 + b1) b2) pure_b0b1_b2_ne,
    ⟨b0 + b1, b2, pure_b0b1_b2_ne, b0b1_b2_independent, rfl⟩⟩

theorem Tmat_moves_movedPoint :
    actV14 (QuotientGroup.mk WeilRep.Tmat) movedPoint ≠ movedPoint := by
  intro heq
  have hcoe := congrArg Subtype.val heq
  dsimp [movedPoint, actV14, actPM] at hcoe
  rw [Projectivization.map_mk, Projectivization.mk_eq_mk_iff] at hcoe
  obtain ⟨μ, hμ⟩ := hcoe
  have hU : WeilHom.weilUHom WeilRep.Tmat = WeilRep.T_even_b 1 := WeilRepSL2.weilU_Tmat
  have hL :
      ambientAct (QuotientGroup.mk WeilRep.Tmat) (pureWedge (b0 + b1) b2) =
        pureWedge (WeilRep.T_even_b 1 (b0 + b1)) (WeilRep.T_even_b 1 b2) := by
    dsimp [ambientAct]
    rw [pslLambda2_mk, weilLambda2, hU]
    dsimp [pureWedge]; rw [exteriorPower.map_apply_ιMulti]
    congr 1; funext i; fin_cases i <;> rfl
  -- mk_eq_mk_iff after map_mk gives: μ • pure = ambientAct T pure
  -- so ambientAct T pure = μ • pure, and with hL that is T-wedges = μ • pure
  have : ∃ μ' : k,
      pureWedge (WeilRep.T_even_b 1 (b0 + b1)) (WeilRep.T_even_b 1 b2) =
        μ' • pureWedge (b0 + b1) b2 :=
    ⟨(μ : k), hL.symm.trans hμ.symm⟩
  exact Tmat_moves_plane this

theorem actV14_faithful (g : PSL2F11)
    (hg : ∀ x : V14Point, actV14 g x = x) : g = 1 := by
  let φ : PSL2F11 →* Equiv.Perm V14Point := MulAction.toPermHom PSL2F11 V14Point
  have hgker : g ∈ φ.ker := by
    rw [MonoidHom.mem_ker]; ext x; exact hg x
  have hN : φ.ker.Normal := inferInstance
  rcases hN.eq_bot_or_eq_top with hbot | htop
  · exact Subgroup.mem_bot.mp (hbot ▸ hgker)
  · exfalso
    have hT : QuotientGroup.mk WeilRep.Tmat ∈ φ.ker := by
      rw [htop]; exact Subgroup.mem_top _
    have hfix : actV14 (QuotientGroup.mk WeilRep.Tmat) movedPoint = movedPoint := by
      have := MonoidHom.mem_ker.mp hT
      exact congrFun (congrArg (fun e : Equiv.Perm V14Point =>
        (e : V14Point → V14Point)) this) movedPoint
    exact Tmat_moves_movedPoint hfix

def embedV14 : V14Point ↪ ℙ k Lambda2U where
  toFun x := x.1
  inj' := Subtype.coe_injective

theorem embedV14_smul (g : PSL2F11) (x : V14Point) :
    embedV14 (actV14 g x) =
      Projectivization.map (ambientAct g) (ambientAct_injective g) (embedV14 x) :=
  rfl

def V14Variety : SmoothProjectiveGVariety k PSL2F11 where
  X := V14Point
  ambient := Lambda2U
  ambientAdd := inferInstance
  ambientModule := inferInstance
  ambientFree := inferInstance
  ambientFD := inferInstance
  embed := embedV14
  smul := actV14
  one_smul' := actV14_one
  mul_smul' := actV14_mul
  faithful := actV14_faithful
  ambientAct := ambientAct
  ambientAct_one := ambientAct_one
  ambientAct_mul := ambientAct_mul
  embed_smul := embedV14_smul

@[expose] public def sigma : PSL2F11 := QuotientGroup.mk WeilRep.Smat

public theorem sigma_isInvolution : IsInvolution sigma := by
  constructor
  · have hmem : WeilRep.Smat ^ 2 ∈ Subgroup.center SLG := by
      rw [Matrix.SpecialLinearGroup.mem_center_iff]
      refine ⟨(-1 : F), by decide, ?_⟩
      ext i j
      fin_cases i <;> fin_cases j <;>
        simp [WeilRep.Smat, pow_two, Matrix.mul_apply, Fin.sum_univ_two,
          Matrix.scalar_apply, Matrix.diagonal]
    change (QuotientGroup.mk WeilRep.Smat : PSL2F11) ^ 2 = 1
    rw [← QuotientGroup.mk_pow]
    exact (QuotientGroup.eq_one_iff _).mpr hmem
  · intro h1
    have hc : WeilRep.Smat ∈ Subgroup.center SLG :=
      (QuotientGroup.eq_one_iff _).mp h1
    rw [Matrix.SpecialLinearGroup.mem_center_iff] at hc
    obtain ⟨r, hr, heq⟩ := hc
    have hr0 : r = 0 := by
      have := congr_fun (congr_fun heq 0) 0
      simpa [WeilRep.Smat, Matrix.scalar_apply, Matrix.diagonal] using this
    have : (0 : F) ^ 2 = 1 := by simpa [hr0, Fintype.card_fin, pow_two] using hr
    exact absurd this (by decide)

/-! ## Cyclotomic nonsquares -/

theorem finrank_K : Module.finrank ℚ k = 10 := by
  let hpb := AdjoinRoot.powerBasis (K := ℚ) (f := WeilRep.Φ11)
    WeilRep.Φ11_irreducible.ne_zero
  calc Module.finrank ℚ k
      = hpb.dim := PowerBasis.finrank hpb
    _ = WeilRep.Φ11.natDegree := AdjoinRoot.powerBasis_dim WeilRep.Φ11_irreducible.ne_zero
    _ = 10 := WeilRep.Φ11_natDegree

theorem isPrimitiveRoot_ζ : IsPrimitiveRoot WeilRep.ζ 11 :=
  (IsPrimitiveRoot.iff_orderOf).2 WeilRep.orderOf_ζ

theorem not_isSquare_neg_one : ¬ IsSquare (-1 : k) := by
  rintro ⟨c, hc⟩
  have hc2 : c ^ (2 : ℕ) = (-1 : k) := by rw [pow_two]; exact hc.symm
  have hc4 : c ^ (4 : ℕ) = 1 := by
    calc c ^ 4 = (c ^ 2) ^ 2 := by ring
      _ = (-1) ^ 2 := by rw [hc2]
      _ = 1 := by norm_num
  have hne1 : c ≠ 1 := by
    intro h; have : (1 : k) ^ 2 = -1 := by simpa [h] using hc2
    exact absurd this (by norm_num)
  have hord : orderOf c = 4 := by
    apply (orderOf_eq_iff (by decide : 0 < (4 : ℕ))).2
    refine ⟨hc4, fun m hm4 hm0 => ?_⟩
    match m with
    | 0 => exact absurd hm0 (Nat.lt_irrefl 0)
    | 1 => show c ^ 1 ≠ 1; simpa [pow_one] using hne1
    | 2 => intro hcm; exact absurd (hcm.symm.trans hc2) (by norm_num)
    | 3 =>
      intro hcm
      have h := congrArg (fun t => t * c) hcm
      change c ^ 3 * c = 1 * c at h
      rw [← pow_succ, hc4, one_mul] at h
      exact hne1 h.symm
    | n + 4 => omega
  have hprim_c : IsPrimitiveRoot c 4 := (IsPrimitiveRoot.iff_orderOf).2 hord
  let hpb := AdjoinRoot.powerBasis (K := ℚ) (f := WeilRep.Φ11)
    WeilRep.Φ11_irreducible.ne_zero
  haveI : Module.Finite ℚ k := Module.Finite.of_basis hpb.basis
  haveI : FiniteDimensional ℚ k := inferInstance
  have hirr : Irreducible (cyclotomic (Nat.lcm 4 11) ℚ) :=
    cyclotomic.irreducible_rat (Nat.lcm_pos (by decide) (by decide))
  have hle : (Nat.lcm 4 11).totient ≤ Module.finrank ℚ k :=
    IsPrimitiveRoot.lcm_totient_le_finrank (K := ℚ) (L := k) hprim_c isPrimitiveRoot_ζ hirr
  have hnum : Nat.lcm 4 11 = 44 := by decide
  have htot : Nat.totient 44 = 20 := by decide
  rw [hnum, htot, finrank_K] at hle
  exact absurd hle (by decide : ¬(20 ≤ 10))

theorem not_isSquare_neg_three : ¬ IsSquare (-3 : k) := by
  rintro ⟨c, hc⟩
  have hc2 : c ^ 2 = (-3 : k) := by simpa [pow_two, eq_comm] using hc
  let z : k := (-1 + c) * (2 : k)⁻¹
  have h2 : (2 : k) ≠ 0 := by norm_num
  have hz : z ^ 2 + z + 1 = 0 := by
    dsimp [z]
    have hcalc : ((-1 + c) * (2 : k)⁻¹) ^ 2 + ((-1 + c) * (2 : k)⁻¹) + 1 =
        (c ^ 2 + 3) * (4 : k)⁻¹ := by field_simp [h2]; ring
    have hc3 : c ^ 2 + 3 = 0 := by linear_combination hc2
    rw [hcalc, hc3, zero_mul]
  have hz3 : z ^ 3 = 1 := by
    have hfac : z ^ 3 - 1 = (z - 1) * (z ^ 2 + z + 1) := by ring
    exact sub_eq_zero.mp (by rw [hfac, hz, mul_zero])
  have hzne1 : z ≠ 1 := by
    intro h
    have : (1 : k) ^ 2 + (1 : k) + 1 = 0 := by simpa [h] using hz
    have h3 : (3 : k) = 0 := by convert this using 1; ring
    exact absurd h3 (by norm_num)
  have hord : orderOf z = 3 := by
    apply (orderOf_eq_iff (by decide : 0 < (3 : ℕ))).2
    refine ⟨hz3, fun m hm3 hm0 => ?_⟩
    match m with
    | 0 => exact absurd hm0 (Nat.lt_irrefl 0)
    | 1 => show z ^ 1 ≠ 1; simpa [pow_one] using hzne1
    | 2 =>
      intro hcm
      have h := congrArg (fun t => t * z) hcm
      change z ^ 2 * z = 1 * z at h
      rw [← pow_succ, hz3, one_mul] at h
      exact hzne1 h.symm
    | n + 3 => omega
  have hprim : IsPrimitiveRoot z 3 := (IsPrimitiveRoot.iff_orderOf).2 hord
  let hpb := AdjoinRoot.powerBasis (K := ℚ) (f := WeilRep.Φ11)
    WeilRep.Φ11_irreducible.ne_zero
  haveI : Module.Finite ℚ k := Module.Finite.of_basis hpb.basis
  haveI : FiniteDimensional ℚ k := inferInstance
  have hirr : Irreducible (cyclotomic (Nat.lcm 3 11) ℚ) :=
    cyclotomic.irreducible_rat (Nat.lcm_pos (by decide) (by decide))
  have hle : (Nat.lcm 3 11).totient ≤ Module.finrank ℚ k :=
    IsPrimitiveRoot.lcm_totient_le_finrank (K := ℚ) (L := k) hprim isPrimitiveRoot_ζ hirr
  have hnum : Nat.lcm 3 11 = 33 := by decide
  have htot : Nat.totient 33 = 20 := by decide
  rw [hnum, htot, finrank_K] at hle
  exact absurd hle (by decide : ¬(20 ≤ 10))

/-! ## √3 ∉ K = ℚ(ζ₁₁)

Unique quadratic subfield of ℚ(ζ₁₁) is ℚ(√−11) (Gauss sum).  If √3 ∈ K then
ℚ(√3)=ℚ(√−11), so √−11 = a + b√3 over ℚ, and (a+b√3)² = −11 forces 2ab = 0
and a²+3b² = −11, impossible over ℚ.  Used for residual-plane classification:
N-fixed planes of Φ₁₂ type would require tr(R|_P)² = 3. -/

theorem not_isSquare_three_nat : ¬ IsSquare (3 : ℕ) := by
  rintro ⟨n, hn⟩
  have h : n * n = 3 := hn.symm
  match n with
  | 0 => norm_num at h
  | 1 => norm_num at h
  | n + 2 => nlinarith

theorem not_isSquare_three_rat : ¬ IsSquare (3 : ℚ) := by
  rw [show (3 : ℚ) = ((3 : ℕ) : ℚ) from rfl, Rat.isSquare_natCast_iff]
  exact not_isSquare_three_nat

theorem not_isSquare_neg_eleven_rat : ¬ IsSquare (-11 : ℚ) := by
  intro ⟨r, hr⟩
  have : (0 : ℚ) ≤ r * r := mul_self_nonneg r
  linarith [show r * r = -11 from hr.symm]

theorem irr_X2_sub_3 : Irreducible (X ^ 2 - C (3 : ℚ)) :=
  (X_pow_sub_C_irreducible_iff_of_prime (by decide : Nat.Prime 2) (a := (3 : ℚ))).2
    fun b hb => not_isSquare_three_rat ⟨b, by simpa [pow_two] using hb.symm⟩

theorem irr_X2_add_11 : Irreducible (X ^ 2 + C (11 : ℚ)) := by
  have heq : (X ^ 2 + C (11 : ℚ)) = X ^ 2 - C (-11 : ℚ) := by
    ext n; simp [sub_eq_add_neg]
  rw [heq]
  exact (X_pow_sub_C_irreducible_iff_of_prime (by decide : Nat.Prime 2)
    (a := (-11 : ℚ))).2 fun b hb =>
      not_isSquare_neg_eleven_rat ⟨b, by simpa [pow_two] using hb.symm⟩

theorem minpoly_gauss : minpoly ℚ (WeilRep.gauss : k) = X ^ 2 + C (11 : ℚ) := by
  symm
  refine minpoly.eq_of_irreducible_of_monic irr_X2_add_11 ?_
    (monic_X_pow_add_C (a := (11 : ℚ)) (n := 2) (by decide))
  have hG : (WeilRep.gauss : k) ^ 2 = (-11 : k) := WeilRep.gauss_sq
  calc aeval WeilRep.gauss (X ^ 2 + C (11 : ℚ))
      = WeilRep.gauss ^ 2 + algebraMap ℚ k 11 := by simp
    _ = -11 + algebraMap ℚ k 11 := by rw [hG]
    _ = -11 + 11 := by norm_cast; simp
    _ = 0 := by norm_num

theorem finrank_adjoin_gauss : Module.finrank ℚ (ℚ⟮WeilRep.gauss⟯) = 2 := by
  have hx : IsIntegral ℚ (WeilRep.gauss : k) := IsIntegral.of_finite ℚ WeilRep.gauss
  rw [adjoin.finrank hx, minpoly_gauss, natDegree_X_pow_add_C]

theorem minpoly_sq_three (c : k) (hc2 : c ^ 2 = (3 : k)) :
    minpoly ℚ c = X ^ 2 - C (3 : ℚ) := by
  symm
  refine minpoly.eq_of_irreducible_of_monic irr_X2_sub_3 ?_
    (monic_X_pow_sub_C (a := (3 : ℚ)) (n := 2) (by decide))
  simp [hc2]

theorem finrank_adjoin_sq_three (c : k) (hc2 : c ^ 2 = (3 : k)) :
    Module.finrank ℚ (ℚ⟮c⟯) = 2 := by
  have hx : IsIntegral ℚ c := IsIntegral.of_finite ℚ c
  rw [adjoin.finrank hx, minpoly_sq_three c hc2, natDegree_X_pow_sub_C]

theorem exists_coords_sq_three (c : k) (hc2 : c ^ 2 = (3 : k)) (x : k)
    (hx : x ∈ ℚ⟮c⟯) :
    ∃ a b : ℚ, x = algebraMap ℚ k a + algebraMap ℚ k b * c := by
  let pb := IntermediateField.adjoin.powerBasis (IsIntegral.of_finite ℚ c)
  have hdeg : Module.finrank ℚ (ℚ⟮c⟯) = 2 := finrank_adjoin_sq_three c hc2
  have hdim : pb.dim = 2 := (PowerBasis.finrank pb).symm.trans hdeg
  let b2 : Module.Basis (Fin 2) ℚ ↥(ℚ⟮c⟯) := pb.basis.reindex (finCongr hdim)
  let xF : ↥(ℚ⟮c⟯) := ⟨x, hx⟩
  have hsum : xF = b2.repr xF 0 • b2 0 + b2.repr xF 1 • b2 1 := by
    have h := (Basis.sum_repr b2 xF).symm
    rw [Fin.sum_univ_two] at h
    exact h
  have hre (i : Fin 2) : b2 i = pb.basis ((finCongr hdim).symm i) := by
    simp [b2, Basis.reindex_apply]
  have hcast0 : (finCongr hdim).symm 0 = ⟨0, by rw [hdim]; omega⟩ := by
    apply Fin.ext
    exact Fin.val_cast hdim.symm (0 : Fin 2)
  have hcast1 : (finCongr hdim).symm 1 = ⟨1, by rw [hdim]; omega⟩ := by
    apply Fin.ext
    exact Fin.val_cast hdim.symm (1 : Fin 2)
  have hb0 : (b2 0 : k) = 1 := by
    rw [hre, hcast0, pb.basis_eq_pow, pow_zero]; rfl
  have hb1 : (b2 1 : k) = c := by
    rw [hre, hcast1, pb.basis_eq_pow, pow_one]
    exact AdjoinSimple.coe_gen ℚ c
  refine ⟨b2.repr xF 0, b2.repr xF 1, ?_⟩
  calc x = (xF : k) := rfl
    _ = ((b2.repr xF 0 • b2 0 + b2.repr xF 1 • b2 1 : ↥(ℚ⟮c⟯)) : k) :=
        congrArg Subtype.val hsum
    _ = b2.repr xF 0 • (1 : k) + b2.repr xF 1 • c := by
        rw [IntermediateField.coe_add, IntermediateField.coe_smul,
          IntermediateField.coe_smul, hb0, hb1]
    _ = algebraMap ℚ k (b2.repr xF 0) + algebraMap ℚ k (b2.repr xF 1) * c := by
        simp only [Algebra.smul_def, mul_one]

/-- If A + B·c = 0 with c² = 3 and [ℚ(c):ℚ]=2, then A = B = 0. -/
theorem coords_unique_sq_three (c : k) (hc2 : c ^ 2 = (3 : k)) (A B : ℚ)
    (h : algebraMap ℚ k A + algebraMap ℚ k B * c = 0) : A = 0 ∧ B = 0 := by
  by_cases hB : B = 0
  · subst hB
    simp only [map_zero, zero_mul, add_zero] at h
    exact ⟨(algebraMap ℚ k).injective (by simpa using h), rfl⟩
  · have hBne : algebraMap ℚ k B ≠ 0 :=
      fun h0 => hB ((algebraMap ℚ k).injective (by simpa using h0))
    have hcQ : c = algebraMap ℚ k (-A * B⁻¹) := by
      have h1 : algebraMap ℚ k B * c = -algebraMap ℚ k A := by
        linear_combination h
      calc c
          = (algebraMap ℚ k B)⁻¹ * (algebraMap ℚ k B * c) := by field_simp [hBne]
        _ = (algebraMap ℚ k B)⁻¹ * (-algebraMap ℚ k A) := by rw [h1]
        _ = algebraMap ℚ k B⁻¹ * algebraMap ℚ k (-A) := by simp [map_inv₀]
        _ = algebraMap ℚ k (B⁻¹ * (-A)) := (map_mul _ _ _).symm
        _ = algebraMap ℚ k (-A * B⁻¹) := by ring_nf
    have hmem : c ∈ (⊥ : IntermediateField ℚ k) := by
      rw [hcQ]; exact IntermediateField.algebraMap_mem ⊥ _
    have hbot : ℚ⟮c⟯ = ⊥ := adjoin_simple_eq_bot_iff.mpr hmem
    have hdeg1 : Module.finrank ℚ (ℚ⟮c⟯) = 1 := by
      rw [hbot]; exact IntermediateField.finrank_bot
    exact absurd (hdeg1.symm.trans (finrank_adjoin_sq_three c hc2)) (by decide)

theorem not_isSquare_three : ¬ IsSquare (3 : k) := by
  rintro ⟨c, hc⟩
  have hc2 : c ^ 2 = (3 : k) := by simpa [pow_two, eq_comm] using hc
  haveI : FiniteDimensional ℚ k := by
    let hpb := AdjoinRoot.powerBasis (K := ℚ) (f := WeilRep.Φ11)
      WeilRep.Φ11_irreducible.ne_zero
    exact Module.Finite.of_basis hpb.basis
  set Fc : IntermediateField ℚ k := ℚ⟮c⟯
  set Fg : IntermediateField ℚ k := ℚ⟮WeilRep.gauss⟯
  have hdegc : Module.finrank ℚ Fc = 2 := finrank_adjoin_sq_three c hc2
  have hdegg : Module.finrank ℚ Fg = 2 := finrank_adjoin_gauss
  have hsup_le : Module.finrank ℚ ↥(Fc ⊔ Fg) ≤ 4 := by
    have := IntermediateField.finrank_sup_le (E1 := Fc) (E2 := Fg)
    simpa [hdegc, hdegg] using this
  have hsup_div : Module.finrank ℚ ↥(Fc ⊔ Fg) ∣ 10 := by
    have hmul := (finrank_mul_finrank ℚ ↥(Fc ⊔ Fg) k).symm
    rw [finrank_K] at hmul
    exact ⟨_, hmul⟩
  have h2le : 2 ≤ Module.finrank ℚ ↥(Fc ⊔ Fg) := by
    have hle : Module.finrank ℚ Fc ≤ Module.finrank ℚ ↥(Fc ⊔ Fg) :=
      IntermediateField.finrank_le_of_le_right (K := ℚ) (F := Fc) (E := Fc ⊔ Fg)
        le_sup_left
    omega
  have hsup2 : Module.finrank ℚ ↥(Fc ⊔ Fg) = 2 := by
    set n := Module.finrank ℚ ↥(Fc ⊔ Fg)
    have hn2 : 2 ≤ n := h2le
    have hn4 : n ≤ 4 := hsup_le
    have hd : n ∣ 10 := hsup_div
    match n with
    | 0 | 1 => omega
    | 2 => rfl
    | 3 => exact absurd (show 3 ∣ 10 from hd) (by decide)
    | 4 => exact absurd (show 4 ∣ 10 from hd) (by decide)
    | _ + 5 => omega
  have hFc_eq : Fc = Fc ⊔ Fg :=
    IntermediateField.eq_of_le_of_finrank_eq le_sup_left (by rw [hdegc, hsup2])
  have hFg_eq : Fg = Fc ⊔ Fg :=
    IntermediateField.eq_of_le_of_finrank_eq le_sup_right (by rw [hdegg, hsup2])
  have heq : Fc = Fg := hFc_eq.trans hFg_eq.symm
  have hgin : (WeilRep.gauss : k) ∈ Fc := by
    rw [heq]; exact mem_adjoin_simple_self ℚ WeilRep.gauss
  obtain ⟨a, b, hab⟩ := exists_coords_sq_three c hc2 WeilRep.gauss hgin
  have hsq :
      (algebraMap ℚ k a + algebraMap ℚ k b * c) ^ 2 = (-11 : k) := by
    rw [← hab, WeilRep.gauss_sq]
  have hexp :
      algebraMap ℚ k (a ^ 2 + 3 * b ^ 2 + 11) +
        algebraMap ℚ k (2 * a * b) * c = 0 := by
    have h0 : (algebraMap ℚ k a + algebraMap ℚ k b * c) ^ 2 + (11 : k) = 0 := by
      rw [hsq]; exact neg_add_cancel (11 : k)
    have h1 :
        (algebraMap ℚ k a + algebraMap ℚ k b * c) ^ 2 =
          algebraMap ℚ k a ^ 2 + (2 : k) * algebraMap ℚ k a * algebraMap ℚ k b * c +
            algebraMap ℚ k b ^ 2 * c ^ 2 := by ring
    have h2 :
        algebraMap ℚ k a ^ 2 + (2 : k) * algebraMap ℚ k a * algebraMap ℚ k b * c +
            algebraMap ℚ k b ^ 2 * c ^ 2 =
          algebraMap ℚ k a ^ 2 + (3 : k) * algebraMap ℚ k b ^ 2 +
            (2 : k) * algebraMap ℚ k a * algebraMap ℚ k b * c := by
      rw [hc2]; ring
    have hA :
        algebraMap ℚ k a ^ 2 + (3 : k) * algebraMap ℚ k b ^ 2 + (11 : k) =
          algebraMap ℚ k (a ^ 2 + 3 * b ^ 2 + 11) := by
      have e1 : algebraMap ℚ k a ^ 2 = algebraMap ℚ k (a ^ 2) := (map_pow _ a 2).symm
      have e2 : (3 : k) = algebraMap ℚ k 3 := by norm_num
      have e3 : algebraMap ℚ k b ^ 2 = algebraMap ℚ k (b ^ 2) := (map_pow _ b 2).symm
      have e4 : (11 : k) = algebraMap ℚ k 11 := by norm_num
      rw [e1, e2, e3, e4, ← map_mul, ← map_add, ← map_add]
    have hB :
        (2 : k) * algebraMap ℚ k a * algebraMap ℚ k b * c =
          algebraMap ℚ k (2 * a * b) * c := by
      have e2 : (2 : k) = algebraMap ℚ k 2 := by norm_num
      rw [e2, ← map_mul, ← map_mul]
    calc algebraMap ℚ k (a ^ 2 + 3 * b ^ 2 + 11) + algebraMap ℚ k (2 * a * b) * c
        = algebraMap ℚ k a ^ 2 + (3 : k) * algebraMap ℚ k b ^ 2 + (11 : k) +
            (2 : k) * algebraMap ℚ k a * algebraMap ℚ k b * c := by rw [← hA, ← hB]
      _ = algebraMap ℚ k a ^ 2 + (3 : k) * algebraMap ℚ k b ^ 2 +
            (2 : k) * algebraMap ℚ k a * algebraMap ℚ k b * c + (11 : k) := by abel
      _ = algebraMap ℚ k a ^ 2 + (2 : k) * algebraMap ℚ k a * algebraMap ℚ k b * c +
            algebraMap ℚ k b ^ 2 * c ^ 2 + (11 : k) := by rw [← h2]
      _ = (algebraMap ℚ k a + algebraMap ℚ k b * c) ^ 2 + (11 : k) := by rw [← h1]
      _ = 0 := h0
  obtain ⟨hA0, hB0⟩ :=
    coords_unique_sq_three c hc2 (a ^ 2 + 3 * b ^ 2 + 11) (2 * a * b) hexp
  have hab0 : a = 0 ∨ b = 0 := by
    have h2ab : (2 : ℚ) * a * b = 0 := hB0
    have h2ne : (2 : ℚ) ≠ 0 := by norm_num
    have : (2 : ℚ) * (a * b) = 0 := by
      rw [← mul_assoc]; exact h2ab
    exact mul_eq_zero.mp ((mul_eq_zero.mp this).resolve_left h2ne)
  rcases hab0 with ha0 | hb0
  · have : (3 : ℚ) * b ^ 2 + 11 = 0 := by simpa [ha0] using hA0
    have hneg : (3 : ℚ) * b ^ 2 = -11 := by linarith
    have hpos : (0 : ℚ) ≤ 3 * b ^ 2 := by positivity
    linarith
  · have : a ^ 2 + 11 = 0 := by simpa [hb0] using hA0
    have hneg : a ^ 2 = -11 := by linarith
    have hpos : (0 : ℚ) ≤ a ^ 2 := sq_nonneg _
    linarith

/-! ## Algebraic bridges for hyp (a)(b)

Green classical lemmas used by the geometric fixed-locus arguments.
Full HypothesisA/B proofs (pencil classification + N-stable plane) are the
remaining gap before rewiring Cor 6.1 off the coset carrier.
-/

theorem ambientAct_sigma :
    ambientAct sigma = weilLambda2 WeilRep.Smat := by
  dsimp [ambientAct, sigma]; rw [pslLambda2_mk]

theorem weilU_S_sq :
    WeilHom.weilUHom WeilRep.Smat ∘ₗ WeilHom.weilUHom WeilRep.Smat =
      (-LinearMap.id : U →ₗ[k] U) := by
  have hS2 : WeilRep.Smat ^ 2 = WeilRepSL2.negI := by
    apply Subtype.ext; ext i j
    fin_cases i <;> fin_cases j <;>
      simp [WeilRep.Smat, WeilRepSL2.negI, pow_two,
        Matrix.mul_apply, Fin.sum_univ_two, Matrix.neg_apply]
  have hmul' : WeilRepSL2.weilU (WeilRep.Smat * WeilRep.Smat) =
      WeilRepSL2.weilU WeilRep.Smat ∘ₗ WeilRepSL2.weilU WeilRep.Smat :=
    WeilHom.weilU_mul _ _
  change WeilRepSL2.weilU WeilRep.Smat ∘ₗ WeilRepSL2.weilU WeilRep.Smat = -LinearMap.id
  rw [← hmul', ← pow_two, hS2, WeilRepSL2.weilU_negI]

public abbrev Jlin : U →ₗ[k] U := WeilHom.weilUHom WeilRep.Smat
theorem Jlin_sq : Jlin ∘ₗ Jlin = (-LinearMap.id : U →ₗ[k] U) := weilU_S_sq

theorem eigenline_forces_neg_one {u : U} (hu : u ≠ 0) {μ : k}
    (h : Jlin u = μ • u) : IsSquare (-1 : k) := by
  have hJJ : Jlin (Jlin u) = (μ * μ) • u := by rw [h, map_smul, h, smul_smul]
  have hneg : Jlin (Jlin u) = -u := by
    simpa [LinearMap.comp_apply, LinearMap.neg_apply, LinearMap.id_apply] using
      LinearMap.congr_fun Jlin_sq u
  have heq : (μ * μ) • u = (-u : U) := by rw [← hJJ, hneg]
  have h0 : (μ * μ + 1) • u = 0 := by
    calc (μ * μ + 1) • u = (μ * μ) • u + (1 : k) • u := add_smul _ _ _
      _ = (μ * μ) • u + u := by rw [one_smul]
      _ = -u + u := by rw [heq]
      _ = 0 := by abel
  have hμ : μ * μ + 1 = 0 := (smul_eq_zero.mp h0).resolve_right hu
  refine ⟨μ, ?_⟩
  -- μ*μ + 1 = 0 ⇒ μ^2 = -1
  have : μ * μ = -1 := eq_neg_of_add_eq_zero_left hμ
  simpa [pow_two, eq_comm] using this

theorem order_three_forces_neg_three {z : k} (hz : z ^ 3 = 1) (hne : z ≠ 1) :
    IsSquare (-3 : k) := by
  have hzpoly : z ^ 2 + z + 1 = 0 := by
    have hfac : z ^ 3 - 1 = (z - 1) * (z ^ 2 + z + 1) := by ring
    have : (z - 1) * (z ^ 2 + z + 1) = 0 := by rw [← hfac, hz, sub_self]
    exact (mul_eq_zero.mp this).resolve_left (sub_ne_zero.mpr hne)
  refine ⟨2 * z + 1, ?_⟩
  have : (2 * z + 1) ^ 2 = (-3 : k) := by
    have h := hzpoly
    -- 4(z²+z+1) - 3 = -3
    calc (2 * z + 1) ^ 2 = 4 * z ^ 2 + 4 * z + 1 := by ring
      _ = 4 * (z ^ 2 + z + 1) - 3 := by ring
      _ = 4 * 0 - 3 := by rw [h]
      _ = -3 := by ring
  simpa [pow_two, eq_comm] using this

/-- Only ±1 are 6th roots of unity in K = ℚ(ζ₁₁). -/
theorem sixth_roots_pm_one {z : k} (hz : z ^ 6 = 1) : z = 1 ∨ z = -1 := by
  have : (z ^ 3 - 1) * (z ^ 3 + 1) = 0 := by
    have h : z ^ 6 - 1 = 0 := sub_eq_zero.mpr hz
    have : z ^ 6 - 1 = (z ^ 3 - 1) * (z ^ 3 + 1) := by ring
    rwa [← this]
  rcases mul_eq_zero.mp this with h | h
  · have hz3 : z ^ 3 = 1 := sub_eq_zero.mp h
    by_cases h1 : z = 1
    · exact Or.inl h1
    · exact False.elim (not_isSquare_neg_three (order_three_forces_neg_three hz3 h1))
  · have hz3 : z ^ 3 = -1 := eq_neg_of_add_eq_zero_left (by linear_combination h)
    have hfac : (z + 1) * (z ^ 2 - z + 1) = 0 := by
      have : z ^ 3 + 1 = 0 := by rw [hz3]; ring
      have : (z + 1) * (z ^ 2 - z + 1) = z ^ 3 + 1 := by ring
      rwa [this]
    rcases mul_eq_zero.mp hfac with h1 | h2
    · exact Or.inr (eq_neg_of_add_eq_zero_left h1)
    · refine False.elim (not_isSquare_neg_three ⟨2 * z - 1, ?_⟩)
      have : (2 * z - 1) ^ 2 = -3 := by
        calc (2 * z - 1) ^ 2 = 4 * (z ^ 2 - z + 1) - 3 := by ring
          _ = -3 := by rw [h2]; ring
      simpa [pow_two, eq_comm] using this

theorem mkRot_rotPt_pow_three :
    CentralizerN.mkRot CentralizerN.rotPt ^ 3 = WeilRep.Smat := by
  apply Subtype.ext
  -- R = [[3,5],[-5,3]] over ZMod 11; R³ = S = [[0,-1],[1,0]]
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp only [pow_three, pow_two, SpecialLinearGroup.coe_mul, Matrix.mul_apply,
      Fin.sum_univ_two, CentralizerN.mkRot, CentralizerN.rotPt, WeilRep.Smat,
      Matrix.of_apply, Matrix.cons_val_zero, Matrix.cons_val_one, Matrix.head_cons] <;>
    (try norm_cast) <;> decide

theorem rotGen_pow_three_eq_sigma :
    (CentralizerN.rotGen : PSL2F11) ^ 3 = sigma := by
  change (QuotientGroup.mk (CentralizerN.mkRot CentralizerN.rotPt) : PSL2F11) ^ 3 =
    QuotientGroup.mk WeilRep.Smat
  rw [← QuotientGroup.mk_pow, mkRot_rotPt_pow_three]

theorem fixed_point_plucker_character (g : PSL2F11) (y : V14Point)
    (hy : actV14 g y = y) :
    ∃ μ : kˣ,
      ambientAct g (Projectivization.rep y.1) =
        (μ : k) • Projectivization.rep y.1 := by
  have hcoe : Projectivization.map (ambientAct g) (ambientAct_injective g) y.1 = y.1 :=
    congrArg Subtype.val hy
  rw [← Projectivization.mk_rep y.1, Projectivization.map_mk,
    Projectivization.mk_eq_mk_iff] at hcoe
  obtain ⟨μ, hμ⟩ := hcoe
  refine ⟨μ, ?_⟩
  exact hμ.symm


/-! ## J-restriction and odd-dimensional √−1 obstruction -/

/-- Restriction of `Jlin` to a J-stable submodule. -/
noncomputable def Jrestrict (L : Submodule k U) (hL : ∀ x ∈ L, Jlin x ∈ L) :
    L →ₗ[k] L where
  toFun x := ⟨Jlin (x : U), hL (x : U) x.property⟩
  map_add' := by
    intro x y
    apply Subtype.ext
    change Jlin (x + y : U) = Jlin x + Jlin y
    exact map_add Jlin _ _
  map_smul' := by
    intro r x
    apply Subtype.ext
    change Jlin (r • (x : U)) = r • Jlin x
    exact map_smul Jlin r _

theorem Jrestrict_sq (L : Submodule k U) (hL : ∀ x ∈ L, Jlin x ∈ L) :
    ∀ x : L, Jrestrict L hL (Jrestrict L hL x) = -x := by
  intro x
  apply Subtype.ext
  have h := LinearMap.congr_fun Jlin_sq (x : U)
  -- h : (Jlin ∘ₗ Jlin) x = -x, i.e. Jlin (Jlin x) = -x
  change Jlin (Jlin (x : U)) = - (x : U) at h
  simpa [Jrestrict] using h

/-- Odd-dimensional J-stable subspace forces √−1 via det(J)² = (−1)^{odd} = −1. -/
theorem j_stable_odd_forces_neg_one (L : Submodule k U)
    (hL : ∀ x ∈ L, Jlin x ∈ L)
    (hodd : Odd (Module.finrank k L)) :
    IsSquare (-1 : k) := by
  classical
  have hpos : 0 < Module.finrank k L := Odd.pos hodd
  haveI : Module.Free k L := Module.Free.of_divisionRing k L
  haveI : Module.Finite k L := by
    refine Module.finite_of_finrank_eq_succ (n := Module.finrank k L - 1) ?_
    omega
  -- Matrix of J|_L w.r.t. any basis; J² = −id ⇒ M² = −I ⇒ det(M)² = (−1)^n
  let b := Module.finBasis k L
  let n := Module.finrank k L
  let M : Matrix (Fin n) (Fin n) k := LinearMap.toMatrix b b (Jrestrict L hL)
  have hM2 : M * M = (-1 : Matrix (Fin n) (Fin n) k) := by
    have hcomp : LinearMap.toMatrix b b (Jrestrict L hL ∘ₗ Jrestrict L hL) = M * M := by
      simpa [M] using LinearMap.toMatrix_comp b b b (Jrestrict L hL) (Jrestrict L hL)
    ext i j
    have hLHS : (M * M) i j = b.repr (-b j) i := by
      rw [← hcomp]
      simp only [LinearMap.toMatrix_apply, LinearMap.comp_apply]
      rw [Jrestrict_sq L hL (b j)]
    rw [hLHS, Matrix.neg_apply, Matrix.one_apply]
    -- b.repr (-bj) i = -δ_ij
    have : b.repr (-b j) i = - (if i = j then (1 : k) else 0) := by
      have hrepr : b.repr (-b j) = -b.repr (b j) := map_neg b.repr (b j)
      rw [hrepr, Basis.repr_self]
      change -((Finsupp.single j (1 : k)) i) = - (if i = j then (1 : k) else 0)
      congr 1
      rw [Finsupp.single_apply]
      -- single j 1 at i equals 1 iff j = i iff i = j
      by_cases hji : j = i
      · rw [if_pos hji, if_pos hji.symm]
      · rw [if_neg hji, if_neg (Ne.symm hji)]
    exact this
  have hdet : (M.det) ^ 2 = (-1 : k) ^ n := by
    have hmul : (M * M).det = M.det * M.det := Matrix.det_mul M M
    have hL : (M * M).det = (-1 : k) ^ n := by
      rw [hM2, Matrix.det_neg, Matrix.det_one, mul_one, Fintype.card_fin]
    calc (M.det) ^ 2 = M.det * M.det := pow_two _
      _ = (M * M).det := hmul.symm
      _ = (-1 : k) ^ n := hL
  have hpow : (-1 : k) ^ n = -1 := by
    dsimp [n]; exact Odd.neg_one_pow hodd
  rw [hpow] at hdet
  exact ⟨M.det, by simpa [pow_two, eq_comm] using hdet⟩

/-! ## Exterior product of pure wedges (Plücker quadric) -/

open ExteriorAlgebra

theorem pureWedge_coe (u v : U) :
    ((pureWedge u v : Lambda2U) : ExteriorAlgebra k U) =
      ExteriorAlgebra.ιMulti k 2 ![u, v] := by
  -- pureWedge = exteriorPower.ιMulti, and coe is the subtype
  rfl

/-- A pure wedge squares to zero in the exterior algebra (Plücker relation). -/
theorem pureWedge_sq (u v : U) :
    ((pureWedge u v : Lambda2U) : ExteriorAlgebra k U) *
      ((pureWedge u v : Lambda2U) : ExteriorAlgebra k U) = 0 := by
  rw [pureWedge_coe, ExteriorAlgebra.ιMulti_mul_ιMulti]
  exact ExteriorAlgebra.ιMulti_eq_zero_of_not_inj (by
    intro hinj
    have h02 : (![u, v, u, v] : Fin 4 → U) 0 = ![u, v, u, v] 2 := by simp
    have : (0 : Fin 4) = 2 := hinj h02
    exact absurd (congrArg Fin.val this) (by decide))

/-- Polarization: if ω₁, ω₂ and ω₁+ω₂ all square to 0, then ω₁ω₂ + ω₂ω₁ = 0. -/
theorem bivector_polar_zero {ω₁ ω₂ : Lambda2U}
    (h1 : ((ω₁ : ExteriorAlgebra k U) * (ω₁ : ExteriorAlgebra k U) = 0))
    (h2 : ((ω₂ : ExteriorAlgebra k U) * (ω₂ : ExteriorAlgebra k U) = 0))
    (h12 : (((ω₁ + ω₂ : Lambda2U) : ExteriorAlgebra k U) *
      ((ω₁ + ω₂ : Lambda2U) : ExteriorAlgebra k U) = 0)) :
    (ω₁ : ExteriorAlgebra k U) * (ω₂ : ExteriorAlgebra k U) +
      (ω₂ : ExteriorAlgebra k U) * (ω₁ : ExteriorAlgebra k U) = 0 := by
  set a := (ω₁ : ExteriorAlgebra k U)
  set b := (ω₂ : ExteriorAlgebra k U)
  have hcoe : ((ω₁ + ω₂ : Lambda2U) : ExteriorAlgebra k U) = a + b := rfl
  -- (a+b)*(a+b) = 0
  have hsum : (a + b) * (a + b) = 0 := by rwa [← hcoe]
  -- expand
  have : a * a + a * b + b * a + b * b = 0 := by
    calc a * a + a * b + b * a + b * b
        = (a + b) * (a + b) := by
          simp only [mul_add, add_mul, add_assoc, add_left_comm]
        _ = 0 := hsum
  -- cancel squares
  rw [h1, h2, zero_add, add_zero] at this
  -- this : a*b + b*a = 0 (up to assoc)
  simpa [add_assoc] using this

/-! ## Pure-wedge products and nonzero independent exterior products -/

open ExteriorAlgebra

theorem pureWedges_mul (u v u' v' : U) :
    ((pureWedge u v : Lambda2U) : ExteriorAlgebra k U) *
        ((pureWedge u' v' : Lambda2U) : ExteriorAlgebra k U) =
      ExteriorAlgebra.ιMulti k 4 ![u, v, u', v'] := by
  rw [pureWedge_coe, pureWedge_coe, ExteriorAlgebra.ιMulti_mul_ιMulti]
  congr 1
  funext i; fin_cases i <;> rfl

/-- Linearly independent n-tuple has nonzero exterior product. -/
theorem ιMulti_ne_zero_of_linearIndependent {n : ℕ} {v : Fin n → U}
    (hv : LinearIndependent k v) :
    ExteriorAlgebra.ιMulti k n v ≠ 0 := by
  classical
  have hli :=
    exteriorPower.ιMulti_family_linearIndependent_field (K := k) (E := U) (n := n) hv
  have hcard : (Finset.univ : Finset (Fin n)).card = n := by
    simp [Finset.card_univ, Fintype.card_fin]
  let s : Set.powersetCard (Fin n) n := ⟨Finset.univ, hcard⟩
  have hne : exteriorPower.ιMulti_family (R := k) (n := n) (M := U) v s ≠ 0 :=
    hli.ne_zero s
  -- ιMulti_family v s = exteriorPower.ιMulti (v ∘ orderEmb) and orderEmb = id
  have hord :
      (Finset.orderEmbOfFin (Finset.univ : Finset (Fin n)) hcard : Fin n → Fin n) = id :=
    (Finset.orderEmbOfFin_unique hcard (fun _ => Finset.mem_univ _) strictMono_id).symm
  have hfam :
      exteriorPower.ιMulti_family (R := k) (n := n) (M := U) v s =
        exteriorPower.ιMulti k n v := by
    dsimp [exteriorPower.ιMulti_family]
    -- ofFinEmbEquiv.symm s = orderEmbOfFin univ
    have hsymm : (Set.powersetCard.ofFinEmbEquiv.symm s : Fin n → Fin n) =
        Finset.orderEmbOfFin Finset.univ hcard := rfl
    rw [hsymm, hord]
    simp only [Function.comp_id]
  intro hz
  apply hne
  rw [hfam]
  -- exteriorPower.ιMulti coe is ExteriorAlgebra.ιMulti
  exact Subtype.ext (by
    change (exteriorPower.ιMulti k n v : ExteriorAlgebra k U) = 0
    simpa using hz)

theorem pure_wedges_product_ne_zero {u v u' v' : U}
    (h : LinearIndependent k ![u, v, u', v']) :
    ((pureWedge u v : Lambda2U) : ExteriorAlgebra k U) *
        ((pureWedge u' v' : Lambda2U) : ExteriorAlgebra k U) ≠ 0 := by
  rw [pureWedges_mul]
  exact ιMulti_ne_zero_of_linearIndependent h

/-- Two pure-wedge products commute via an even permutation of factors. -/
theorem pureWedges_mul_comm (u v u' v' : U) :
    ((pureWedge u v : Lambda2U) : ExteriorAlgebra k U) *
        ((pureWedge u' v' : Lambda2U) : ExteriorAlgebra k U) =
      ((pureWedge u' v' : Lambda2U) : ExteriorAlgebra k U) *
        ((pureWedge u v : Lambda2U) : ExteriorAlgebra k U) := by
  rw [pureWedges_mul, pureWedges_mul]
  let σ : Equiv.Perm (Fin 4) := Equiv.swap (0 : Fin 4) 2 * Equiv.swap (1 : Fin 4) 3
  have hsign : Equiv.Perm.sign σ = 1 := by
    dsimp [σ]
    rw [map_mul, Equiv.Perm.sign_swap, Equiv.Perm.sign_swap] <;> decide
  have hcomp : (![u', v', u, v] : Fin 4 → U) = fun i => ![u, v, u', v'] (σ i) := by
    ext i
    match i with
    | ⟨0, _⟩ => rfl
    | ⟨1, _⟩ => rfl
    | ⟨2, _⟩ => rfl
    | ⟨3, _⟩ => rfl
  have halt :=
    (ExteriorAlgebra.ιMulti k 4 (M := U)).map_congr_perm (v := ![u, v, u', v']) σ
  rw [show ExteriorAlgebra.ιMulti k 4 ![u', v', u, v] =
      ExteriorAlgebra.ιMulti k 4 (![u, v, u', v'] ∘ σ) from hcomp ▸ rfl, halt, hsign, one_smul]

theorem pure_wedges_product_zero {u v u' v' : U}
    (h1 : ((pureWedge u v : Lambda2U) : ExteriorAlgebra k U) *
      ((pureWedge u v : Lambda2U) : ExteriorAlgebra k U) = 0)
    (h2 : ((pureWedge u' v' : Lambda2U) : ExteriorAlgebra k U) *
      ((pureWedge u' v' : Lambda2U) : ExteriorAlgebra k U) = 0)
    (h12 : (((pureWedge u v + pureWedge u' v') : Lambda2U) : ExteriorAlgebra k U) *
      (((pureWedge u v + pureWedge u' v') : Lambda2U) : ExteriorAlgebra k U) = 0) :
    ((pureWedge u v : Lambda2U) : ExteriorAlgebra k U) *
      ((pureWedge u' v' : Lambda2U) : ExteriorAlgebra k U) = 0 := by
  have hpolar := bivector_polar_zero h1 h2 h12
  have hcomm := pureWedges_mul_comm u v u' v'
  -- hpolar : a*b + b*a = 0; with a*b = b*a get 2*(b*a) = 0
  have h2ba : (2 : k) •
      (((pureWedge u' v' : Lambda2U) : ExteriorAlgebra k U) *
        ((pureWedge u v : Lambda2U) : ExteriorAlgebra k U)) = 0 := by
    have h' : ((pureWedge u' v' : Lambda2U) : ExteriorAlgebra k U) *
          ((pureWedge u v : Lambda2U) : ExteriorAlgebra k U) +
        ((pureWedge u' v' : Lambda2U) : ExteriorAlgebra k U) *
          ((pureWedge u v : Lambda2U) : ExteriorAlgebra k U) = 0 := by
      -- rewrite a*b to b*a in hpolar
      simpa [hcomm] using hpolar
    simpa [two_smul] using h'
  -- transfer to a*b
  have h2ab : (2 : k) •
      (((pureWedge u v : Lambda2U) : ExteriorAlgebra k U) *
        ((pureWedge u' v' : Lambda2U) : ExteriorAlgebra k U)) = 0 := by
    rwa [hcomm]
  exact (smul_eq_zero.mp h2ab).resolve_left (by norm_num)

theorem finrank_span_pair {u v : U} (hI : LinearIndependent k ![u, v]) :
    Module.finrank k ((k ∙ u) ⊔ (k ∙ v) : Submodule k U) = 2 := by
  have hcard : Module.finrank k (Submodule.span k (Set.range ![u, v])) = 2 := by
    have := finrank_span_eq_card (R := k) (b := ![u, v]) hI
    simpa [Fintype.card_fin] using this
  have heq : ((k ∙ u) ⊔ (k ∙ v) : Submodule k U) = Submodule.span k (Set.range ![u, v]) := by
    apply le_antisymm
    · apply sup_le
      · exact Submodule.span_mono (fun x hx => by rcases hx with rfl; exact ⟨0, rfl⟩)
      · exact Submodule.span_mono (fun x hx => by rcases hx with rfl; exact ⟨1, rfl⟩)
    · rw [Submodule.span_le]; intro x hx; obtain ⟨i, rfl⟩ := hx
      fin_cases i
      · exact Submodule.mem_sup_left (Submodule.mem_span_singleton_self _)
      · exact Submodule.mem_sup_right (Submodule.mem_span_singleton_self _)
  rwa [heq]


/-- Product zero of independent pure wedges ⇒ support planes meet. -/
theorem planes_meet_of_product_zero {u v u' v' : U}
    (hI : LinearIndependent k ![u, v])
    (hI' : LinearIndependent k ![u', v'])
    (hprod : ((pureWedge u v : Lambda2U) : ExteriorAlgebra k U) *
      ((pureWedge u' v' : Lambda2U) : ExteriorAlgebra k U) = 0) :
    (((k ∙ u) ⊔ (k ∙ v)) ⊓ ((k ∙ u') ⊔ (k ∙ v')) : Submodule k U) ≠ ⊥ := by
  intro hbot
  let P : Submodule k U := (k ∙ u) ⊔ (k ∙ v)
  let Q : Submodule k U := (k ∙ u') ⊔ (k ∙ v')
  have hP2 : Module.finrank k P = 2 := finrank_span_pair hI
  have hQ2 : Module.finrank k Q = 2 := finrank_span_pair hI'
  haveI : Module.Free k P := Module.Free.of_divisionRing k P
  haveI : Module.Free k Q := Module.Free.of_divisionRing k Q
  haveI : Module.Finite k P := Module.finite_of_finrank_eq_succ (by rw [hP2] : Module.finrank k P = (1 : ℕ).succ)
  haveI : Module.Finite k Q := Module.finite_of_finrank_eq_succ (by rw [hQ2] : Module.finrank k Q = (1 : ℕ).succ)
  haveI : FiniteDimensional k P := inferInstance
  haveI : FiniteDimensional k Q := inferInstance
  have hsum_eq :
      Module.finrank k ↥(P ⊔ Q) + Module.finrank k ↥(P ⊓ Q) =
        Module.finrank k ↥P + Module.finrank k ↥Q :=
    Submodule.finrank_sup_add_finrank_inf_eq (K := k) (V := U) P Q
  have hsum4 : Module.finrank k ↥(P ⊔ Q) = 4 := by
    have hinf0 : Module.finrank k ↥(P ⊓ Q) = 0 := by
      have hbot' : P ⊓ Q = (⊥ : Submodule k U) := by simpa [P, Q] using hbot
      rw [hbot', finrank_bot]
    have : Module.finrank k ↥(P ⊔ Q) + 0 = 2 + 2 := by
      simpa [hinf0, hP2, hQ2] using hsum_eq
    omega
  have hspanEQ : Submodule.span k (Set.range ![u, v, u', v']) = P ⊔ Q := by
    apply le_antisymm
    · rw [Submodule.span_le]; intro x hx; obtain ⟨i, rfl⟩ := hx
      fin_cases i
      · exact Submodule.mem_sup_left (Submodule.mem_sup_left (Submodule.mem_span_singleton_self _))
      · exact Submodule.mem_sup_left (Submodule.mem_sup_right (Submodule.mem_span_singleton_self _))
      · exact Submodule.mem_sup_right (Submodule.mem_sup_left (Submodule.mem_span_singleton_self _))
      · exact Submodule.mem_sup_right (Submodule.mem_sup_right (Submodule.mem_span_singleton_self _))
    · apply sup_le
      · apply sup_le
        · exact Submodule.span_mono (by intro x hx; rcases hx with rfl; exact ⟨0, rfl⟩)
        · exact Submodule.span_mono (by intro x hx; rcases hx with rfl; exact ⟨1, rfl⟩)
      · apply sup_le
        · exact Submodule.span_mono (by intro x hx; rcases hx with rfl; exact ⟨2, rfl⟩)
        · exact Submodule.span_mono (by intro x hx; rcases hx with rfl; exact ⟨3, rfl⟩)
  have hli4 : LinearIndependent k ![u, v, u', v'] := by
    rw [linearIndependent_iff_card_eq_finrank_span]
    simp only [Fintype.card_fin]
    change 4 = Module.finrank k (Submodule.span k (Set.range ![u, v, u', v']))
    rw [hspanEQ, hsum4]
  exact pure_wedges_product_ne_zero hli4 hprod

/-- Span of `![u,v]` equals the pair sup. -/
theorem span_pair_eq_sup (u v : U) :
    Submodule.span k (Set.range ![u, v]) = (k ∙ u) ⊔ (k ∙ v) := by
  apply le_antisymm
  · rw [Submodule.span_le]; intro x hx; obtain ⟨i, rfl⟩ := hx
    fin_cases i
    · exact Submodule.mem_sup_left (Submodule.mem_span_singleton_self _)
    · exact Submodule.mem_sup_right (Submodule.mem_span_singleton_self _)
  · apply sup_le
    · exact Submodule.span_mono (fun x hx => by rcases hx with rfl; exact ⟨0, rfl⟩)
    · exact Submodule.span_mono (fun x hx => by rcases hx with rfl; exact ⟨1, rfl⟩)

/-- Parallel pure wedges determine the same support plane. -/
theorem support_eq_of_parallel_pure {u v u' v' : U} {μ : k}
    (hI : LinearIndependent k ![u, v])
    (hI' : LinearIndependent k ![u', v'])
    (hμ : μ ≠ 0)
    (heq : pureWedge u v = μ • pureWedge u' v') :
    ((k ∙ u) ⊔ (k ∙ v) : Submodule k U) = (k ∙ u') ⊔ (k ∙ v') := by
  have hP2 := finrank_span_pair hI
  have hQ2 := finrank_span_pair hI'
  have hu' : u' ∈ (k ∙ u) ⊔ (k ∙ v) := by
    by_contra hnot
    have hspan : Submodule.span k (Set.range ![u, v]) = (k ∙ u) ⊔ (k ∙ v) := span_pair_eq_sup u v
    have hli3 : LinearIndependent k (Fin.snoc ![u, v] u') :=
      hI.finSnoc (by rwa [hspan])
    -- Fin.snoc ![u,v] u' = ![u,v,u']
    have hsnoc : Fin.snoc ![u, v] u' = ![u, v, u'] := by
      funext i; fin_cases i <;> rfl
    rw [hsnoc] at hli3
    have hne3 := ιMulti_ne_zero_of_linearIndependent hli3
    have hprod0 : ExteriorAlgebra.ιMulti k 3 ![u, v, u'] = 0 := by
      have happ : Fin.append ![u, v] ![u'] = ![u, v, u'] := by
        funext i; fin_cases i <;> rfl
      have happend :=
        ExteriorAlgebra.ιMulti_mul_ιMulti (R := k) (M := U) (a := ![u, v]) (b := ![u'])
      have h1 : ExteriorAlgebra.ιMulti (R := k) (M := U) (n := 1) ![u'] =
          ExteriorAlgebra.ι (R := k) (M := U) u' := by
        rw [ExteriorAlgebra.ιMulti_apply, List.ofFn_succ, List.ofFn_zero]
        simp only [List.prod_cons, List.prod_nil, mul_one, Matrix.cons_val_fin_one]
      have hform : ExteriorAlgebra.ιMulti k 3 ![u, v, u'] =
          ExteriorAlgebra.ιMulti k 2 ![u, v] * ExteriorAlgebra.ι (R := k) (M := U) u' := by
        rw [← happ, ← happend, h1]
      rw [hform, ← pureWedge_coe, heq]
      have hcoe_smul :
          ((μ • pureWedge u' v' : Lambda2U) : ExteriorAlgebra k U) =
            μ • ((pureWedge u' v' : Lambda2U) : ExteriorAlgebra k U) := by
        simp only [Submodule.coe_smul]
      rw [hcoe_smul, smul_mul_assoc, pureWedge_coe]
      have hzero :
          ExteriorAlgebra.ιMulti k 2 ![u', v'] * ExteriorAlgebra.ιMulti k 1 ![u'] = 0 := by
        rw [ExteriorAlgebra.ιMulti_mul_ιMulti]
        apply ExteriorAlgebra.ιMulti_eq_zero_of_not_inj
        intro hinj
        have h0 : (Fin.append ![u', v'] ![u'] : Fin 3 → U) 0 = u' := rfl
        have h2 : (Fin.append ![u', v'] ![u'] : Fin 3 → U) 2 = u' := rfl
        exact absurd (congrArg Fin.val (hinj (h0.trans h2.symm))) (by decide)
      have h1' : ExteriorAlgebra.ι (R := k) (M := U) u' =
          ExteriorAlgebra.ιMulti (R := k) (M := U) 1 ![u'] := h1.symm
      rw [h1', hzero, smul_zero]
    exact hne3 hprod0
  have hv' : v' ∈ (k ∙ u) ⊔ (k ∙ v) := by
    by_contra hnot
    have hspan : Submodule.span k (Set.range ![u, v]) = (k ∙ u) ⊔ (k ∙ v) := span_pair_eq_sup u v
    have hli3 : LinearIndependent k (Fin.snoc ![u, v] v') :=
      hI.finSnoc (by rwa [hspan])
    have hsnoc : Fin.snoc ![u, v] v' = ![u, v, v'] := by
      funext i; fin_cases i <;> rfl
    rw [hsnoc] at hli3
    have hne3 := ιMulti_ne_zero_of_linearIndependent hli3
    have hprod0 : ExteriorAlgebra.ιMulti k 3 ![u, v, v'] = 0 := by
      have happ : Fin.append ![u, v] ![v'] = ![u, v, v'] := by
        funext i; fin_cases i <;> rfl
      have happend :=
        ExteriorAlgebra.ιMulti_mul_ιMulti (R := k) (M := U) (a := ![u, v]) (b := ![v'])
      have h1 : ExteriorAlgebra.ιMulti (R := k) (M := U) (n := 1) ![v'] =
          ExteriorAlgebra.ι (R := k) (M := U) v' := by
        rw [ExteriorAlgebra.ιMulti_apply, List.ofFn_succ, List.ofFn_zero]
        simp only [List.prod_cons, List.prod_nil, mul_one, Matrix.cons_val_fin_one]
      have hform : ExteriorAlgebra.ιMulti k 3 ![u, v, v'] =
          ExteriorAlgebra.ιMulti k 2 ![u, v] * ExteriorAlgebra.ι (R := k) (M := U) v' := by
        rw [← happ, ← happend, h1]
      rw [hform, ← pureWedge_coe, heq]
      have hcoe_smul :
          ((μ • pureWedge u' v' : Lambda2U) : ExteriorAlgebra k U) =
            μ • ((pureWedge u' v' : Lambda2U) : ExteriorAlgebra k U) := by
        simp only [Submodule.coe_smul]
      rw [hcoe_smul, smul_mul_assoc, pureWedge_coe]
      have hzero :
          ExteriorAlgebra.ιMulti k 2 ![u', v'] * ExteriorAlgebra.ιMulti k 1 ![v'] = 0 := by
        rw [ExteriorAlgebra.ιMulti_mul_ιMulti]
        apply ExteriorAlgebra.ιMulti_eq_zero_of_not_inj
        intro hinj
        have h1eq : (Fin.append ![u', v'] ![v'] : Fin 3 → U) 1 = v' := rfl
        have h2eq : (Fin.append ![u', v'] ![v'] : Fin 3 → U) 2 = v' := rfl
        exact absurd (congrArg Fin.val (hinj (h1eq.trans h2eq.symm))) (by decide)
      have h1' : ExteriorAlgebra.ι (R := k) (M := U) v' =
          ExteriorAlgebra.ιMulti (R := k) (M := U) 1 ![v'] := h1.symm
      rw [h1', hzero, smul_zero]
    exact hne3 hprod0
  have hQP : (k ∙ u') ⊔ (k ∙ v') ≤ (k ∙ u) ⊔ (k ∙ v) := by
    apply sup_le
    · exact (Submodule.span_singleton_le_iff_mem _ _).mpr hu'
    · exact (Submodule.span_singleton_le_iff_mem _ _).mpr hv'
  exact (Submodule.eq_of_le_of_finrank_eq hQP (by rw [hQ2, hP2])).symm

#print axioms support_eq_of_parallel_pure
#print axioms planes_meet_of_product_zero
#print axioms pure_wedges_product_zero
#print axioms pureWedges_mul_comm
#print axioms j_stable_odd_forces_neg_one
#print axioms pureWedge_sq
#print axioms bivector_polar_zero
#print axioms ιMulti_ne_zero_of_linearIndependent

/-! ## Hypothesis A: polar → plane-meet → J-stable axis → √−1 -/

theorem ambientAct_sigma_pure (u v : U) :
    ambientAct sigma (pureWedge u v) = pureWedge (Jlin u) (Jlin v) := by
  rw [ambientAct_sigma]
  exact (pureWedge_map WeilRep.Smat u v).symm

theorem Jlin_injective : Function.Injective Jlin := by
  intro a b hab
  have ha : Jlin (Jlin a) = -a := by
    simpa [LinearMap.comp_apply, LinearMap.neg_apply, LinearMap.id_apply] using
      LinearMap.congr_fun Jlin_sq a
  have hb : Jlin (Jlin b) = -b := by
    simpa [LinearMap.comp_apply, LinearMap.neg_apply, LinearMap.id_apply] using
      LinearMap.congr_fun Jlin_sq b
  exact neg_injective (by rw [← ha, ← hb, hab])

theorem Jlin_pair_independent {u v : U} (hI : LinearIndependent k ![u, v]) :
    LinearIndependent k ![Jlin u, Jlin v] := by
  have hcomp : ![Jlin u, Jlin v] = Jlin ∘ ![u, v] := by
    funext i; fin_cases i <;> rfl
  rw [hcomp]
  exact hI.map' _ (LinearMap.ker_eq_bot_of_injective Jlin_injective)

/-- A σ-fixed pure wedge is an eigenline of Λ²J: Ju∧Jv ∥ u∧v. -/
theorem sigma_fixed_parallel_J {u v : U} {hne : pureWedge u v ≠ 0}
    {y : V14Point}
    (hy : y.1 = Projectivization.mk k (pureWedge u v) hne)
    (hfix : actV14 sigma y = y) :
    ∃ μ : kˣ, pureWedge (Jlin u) (Jlin v) = (μ : k) • pureWedge u v := by
  have hcoe : actPM sigma y.1 = y.1 := congrArg Subtype.val hfix
  rw [hy, actPM, Projectivization.map_mk, Projectivization.mk_eq_mk_iff] at hcoe
  obtain ⟨μ, hμ⟩ := hcoe
  refine ⟨μ, ?_⟩
  calc pureWedge (Jlin u) (Jlin v)
      = ambientAct sigma (pureWedge u v) := (ambientAct_sigma_pure u v).symm
    _ = (μ : k) • pureWedge u v := hμ.symm

/-- σ-fixed decomposable ⇒ its support plane is J-stable. -/
theorem sigma_fixed_plane_j_stable {u v : U} (hI : LinearIndependent k ![u, v])
    {hne : pureWedge u v ≠ 0} {y : V14Point}
    (hy : y.1 = Projectivization.mk k (pureWedge u v) hne)
    (hfix : actV14 sigma y = y) :
    ∀ t ∈ ((k ∙ u) ⊔ (k ∙ v) : Submodule k U),
      Jlin t ∈ ((k ∙ u) ⊔ (k ∙ v) : Submodule k U) := by
  obtain ⟨μ, hμ⟩ := sigma_fixed_parallel_J hy hfix
  have hJli := Jlin_pair_independent hI
  have hplane :
      ((k ∙ Jlin u) ⊔ (k ∙ Jlin v) : Submodule k U) = (k ∙ u) ⊔ (k ∙ v) :=
    support_eq_of_parallel_pure hJli hI (Units.ne_zero μ) hμ
  intro t ht
  obtain ⟨t1, ht1, t2, ht2, rfl⟩ := Submodule.mem_sup.mp ht
  obtain ⟨a, rfl⟩ := Submodule.mem_span_singleton.mp ht1
  obtain ⟨b, rfl⟩ := Submodule.mem_span_singleton.mp ht2
  have hJu : Jlin u ∈ (k ∙ u) ⊔ (k ∙ v) := by
    rw [← hplane]; exact Submodule.mem_sup_left (Submodule.mem_span_singleton_self _)
  have hJv : Jlin v ∈ (k ∙ u) ⊔ (k ∙ v) := by
    rw [← hplane]; exact Submodule.mem_sup_right (Submodule.mem_span_singleton_self _)
  rw [map_add, map_smul, map_smul]
  exact add_mem (Submodule.smul_mem _ a hJu) (Submodule.smul_mem _ b hJv)

/-- Pure wedge is alternating: v∧u = −u∧v. -/
public theorem pureWedge_swap (u v : U) : pureWedge v u = -pureWedge u v := by
  dsimp [pureWedge]
  let σ : Equiv.Perm (Fin 2) := Equiv.swap (0 : Fin 2) 1
  have hsign : Equiv.Perm.sign σ = -1 := by
    dsimp [σ]; rw [Equiv.Perm.sign_swap]; decide
  have hcomp : (![v, u] : Fin 2 → U) = fun i => ![u, v] (σ i) := by
    ext i; match i with
    | ⟨0, _⟩ => rfl
    | ⟨1, _⟩ => rfl
  -- map_congr_perm: f v = sign σ • f (v ∘ σ)
  have halt :=
    (exteriorPower.ιMulti k 2 (M := U)).map_congr_perm (v := ![u, v]) σ
  have hcomp' : exteriorPower.ιMulti k 2 ![v, u] =
      exteriorPower.ιMulti k 2 (![u, v] ∘ σ) := hcomp ▸ rfl
  have hneg : exteriorPower.ιMulti k 2 ![u, v] =
      - exteriorPower.ιMulti k 2 (![u, v] ∘ σ) := by
    simpa [hsign, neg_smul, one_smul] using halt
  have hside : exteriorPower.ιMulti k 2 (![u, v] ∘ σ) =
      - exteriorPower.ιMulti k 2 ![u, v] :=
    (neg_eq_iff_eq_neg.mp hneg.symm)
  rw [hcomp', hside]

theorem pureWedge_add_left (u u' v : U) :
    pureWedge (u + u') v = pureWedge u v + pureWedge u' v := by
  dsimp [pureWedge]
  have h :=
    (exteriorPower.ιMulti k 2 (M := U)).map_update_add
      (fun _ : Fin 2 => v) (0 : Fin 2) u u'
  have hu : Function.update (fun _ : Fin 2 => v) 0 (u + u') = ![u + u', v] := by
    funext i; fin_cases i <;> simp
  have hu0 : Function.update (fun _ : Fin 2 => v) 0 u = ![u, v] := by
    funext i; fin_cases i <;> simp
  have hu1 : Function.update (fun _ : Fin 2 => v) 0 u' = ![u', v] := by
    funext i; fin_cases i <;> simp
  simpa [hu, hu0, hu1] using h

theorem pureWedge_smul_left (a : k) (u v : U) :
    pureWedge (a • u) v = a • pureWedge u v := by
  dsimp [pureWedge]
  have h :=
    (exteriorPower.ιMulti k 2 (M := U)).map_update_smul
      (fun _ : Fin 2 => v) (0 : Fin 2) a u
  have hu : Function.update (fun _ : Fin 2 => v) 0 (a • u) = ![a • u, v] := by
    funext i; fin_cases i <;> simp
  have hu0 : Function.update (fun _ : Fin 2 => v) 0 u = ![u, v] := by
    funext i; fin_cases i <;> simp
  simpa [hu, hu0] using h

theorem pureWedge_add_right (u v v' : U) :
    pureWedge u (v + v') = pureWedge u v + pureWedge u v' := by
  have h1 := pureWedge_swap (v + v') u
  rw [h1, pureWedge_add_left, pureWedge_swap v u, pureWedge_swap v' u]
  abel

public theorem pureWedge_smul_right (a : k) (u v : U) :
    pureWedge u (a • v) = a • pureWedge u v := by
  calc pureWedge u (a • v)
      = - pureWedge (a • v) u := pureWedge_swap (a • v) u
    _ = - (a • pureWedge v u) := by rw [pureWedge_smul_left]
    _ = - (a • (- pureWedge u v)) := by rw [pureWedge_swap u v]
    _ = a • pureWedge u v := by simp [smul_neg, neg_neg]

theorem pureWedge_self (u : U) : pureWedge u u = 0 := by
  dsimp [pureWedge]
  exact (exteriorPower.ιMulti k 2 (M := U)).map_eq_zero_of_eq ![u, u]
    (by simp : (![u, u] : Fin 2 → U) 0 = ![u, u] 1) (by decide : (0 : Fin 2) ≠ 1)

/-- Change-of-basis formula on a 2-plane: (au+bv)∧(cu+dv) = (ad−bc) u∧v. -/
theorem pureWedge_linear_combo (a b c d : k) (u v : U) :
    pureWedge (a • u + b • v) (c • u + d • v) =
      (a * d - b * c) • pureWedge u v := by
  calc pureWedge (a • u + b • v) (c • u + d • v)
      = pureWedge (a • u) (c • u + d • v) + pureWedge (b • v) (c • u + d • v) :=
        pureWedge_add_left _ _ _
    _ = pureWedge (a • u) (c • u) + pureWedge (a • u) (d • v) +
          (pureWedge (b • v) (c • u) + pureWedge (b • v) (d • v)) := by
        rw [pureWedge_add_right, pureWedge_add_right]
    _ = a • pureWedge u (c • u) + a • pureWedge u (d • v) +
          (b • pureWedge v (c • u) + b • pureWedge v (d • v)) := by
        simp only [pureWedge_smul_left]
    _ = a • (c • pureWedge u u) + a • (d • pureWedge u v) +
          (b • (c • pureWedge v u) + b • (d • pureWedge v v)) := by
        simp only [pureWedge_smul_right]
    _ = a • (c • (0 : Lambda2U)) + a • (d • pureWedge u v) +
          (b • (c • (-pureWedge u v)) + b • (d • (0 : Lambda2U))) := by
        simp only [pureWedge_self, pureWedge_swap u v]
    _ = (a * d) • pureWedge u v + (-(b * c)) • pureWedge u v := by
        simp only [smul_zero, zero_add, add_zero, smul_neg, smul_smul, neg_smul]
    _ = (a * d - b * c) • pureWedge u v := by
        rw [← add_smul, sub_eq_add_neg]

/-- Same support plane ⇒ parallel pure wedges (Λ²P is 1-dimensional). -/
theorem same_plane_parallel_pure {u v u' v' : U}
    (_hI : LinearIndependent k ![u, v])
    (hI' : LinearIndependent k ![u', v'])
    (heq : ((k ∙ u) ⊔ (k ∙ v) : Submodule k U) = (k ∙ u') ⊔ (k ∙ v')) :
    ∃ μ : k, μ ≠ 0 ∧ pureWedge u v = μ • pureWedge u' v' := by
  have hu' : u' ∈ (k ∙ u) ⊔ (k ∙ v) := by
    rw [heq]; exact Submodule.mem_sup_left (Submodule.mem_span_singleton_self _)
  have hv' : v' ∈ (k ∙ u) ⊔ (k ∙ v) := by
    rw [heq]; exact Submodule.mem_sup_right (Submodule.mem_span_singleton_self _)
  obtain ⟨xu, hxu, xv, hxv, hu'sum⟩ := Submodule.mem_sup.mp hu'
  obtain ⟨a, rfl⟩ := Submodule.mem_span_singleton.mp hxu
  obtain ⟨b, rfl⟩ := Submodule.mem_span_singleton.mp hxv
  obtain ⟨yu, hyu, yv, hyv, hv'sum⟩ := Submodule.mem_sup.mp hv'
  obtain ⟨c, rfl⟩ := Submodule.mem_span_singleton.mp hyu
  obtain ⟨d, rfl⟩ := Submodule.mem_span_singleton.mp hyv
  have hform : pureWedge u' v' = (a * d - b * c) • pureWedge u v := by
    rw [← hu'sum, ← hv'sum, pureWedge_linear_combo]
  have hdet : a * d - b * c ≠ 0 := by
    intro h0
    have hzero : pureWedge u' v' = 0 := by rw [hform, h0, zero_smul]
    have hne : ExteriorAlgebra.ιMulti k 2 ![u', v'] ≠ 0 :=
      ιMulti_ne_zero_of_linearIndependent hI'
    apply hne
    simpa [pureWedge_coe, pureWedge] using
      congrArg (fun w : Lambda2U => (w : ExteriorAlgebra k U)) hzero
  refine ⟨(a * d - b * c)⁻¹, inv_ne_zero hdet, ?_⟩
  have hμ : pureWedge u v =
      (a * d - b * c)⁻¹ • pureWedge u' v' := by
    rw [hform, smul_smul, inv_mul_cancel₀ hdet, one_smul]
  exact hμ

/-- Unpack a decomposable line: the representing pure wedge is a unit multiple. -/
theorem decomposable_rep_parallel {w : Lambda2U} (hw : w ≠ 0)
    (hdec : IsDecomposable (Projectivization.mk k w hw)) :
    ∃ (u v : U) (hne : pureWedge u v ≠ 0),
      LinearIndependent k ![u, v] ∧ ∃ α : kˣ, pureWedge u v = (α : k) • w := by
  obtain ⟨u, v, hne, hI, hmk⟩ := hdec
  -- hmk : mk w = mk (pureWedge u v)
  refine ⟨u, v, hne, hI, ?_⟩
  obtain ⟨α, hα⟩ := (Projectivization.mk_eq_mk_iff k w (pureWedge u v) hw hne).mp hmk
  -- hα : α • pure = w  (Units.smul)
  refine ⟨α⁻¹, ?_⟩
  have hα0 : (α : k) ≠ 0 := Units.ne_zero α
  have h1 : (α : k) • pureWedge u v = w := by
    simpa only [Units.smul_def] using hα
  have h2 := congrArg (fun z => (α : k)⁻¹ • z) h1
  -- (α)⁻¹ • (α • pure) = (α)⁻¹ • w
  rw [smul_smul, inv_mul_cancel₀ hα0, one_smul] at h2
  -- h2 : pure = (α)⁻¹ • w; goal pure = ↑α⁻¹ • w
  simpa [Units.val_inv_eq_inv_val] using h2

/-- Two lin-ind pure wedges whose sum is pure have vanishing exterior product. -/
theorem pure_pair_product_zero_of_sum_pure {u v u' v' us vs : U}
    {α β γ : kˣ} {w1 w2 : Lambda2U}
    (hα : pureWedge u v = (α : k) • w1)
    (hβ : pureWedge u' v' = (β : k) • w2)
    (hγ : pureWedge us vs = (γ : k) • (w1 + w2)) :
    ((pureWedge u v : Lambda2U) : ExteriorAlgebra k U) *
      ((pureWedge u' v' : Lambda2U) : ExteriorAlgebra k U) = 0 := by
  have hw1 : w1 = (α : k)⁻¹ • pureWedge u v := by
    have := congrArg (fun z => (α : k)⁻¹ • z) hα
    simp only [smul_smul, inv_mul_cancel₀ (Units.ne_zero α), one_smul] at this
    exact this.symm
  have hw2 : w2 = (β : k)⁻¹ • pureWedge u' v' := by
    have := congrArg (fun z => (β : k)⁻¹ • z) hβ
    simp only [smul_smul, inv_mul_cancel₀ (Units.ne_zero β), one_smul] at this
    exact this.symm
  have hw12 : w1 + w2 = (γ : k)⁻¹ • pureWedge us vs := by
    have := congrArg (fun z => (γ : k)⁻¹ • z) hγ
    simp only [smul_smul, inv_mul_cancel₀ (Units.ne_zero γ), one_smul] at this
    exact this.symm
  have h1sq : ((w1 : ExteriorAlgebra k U) * (w1 : ExteriorAlgebra k U) = 0) := by
    have hcoe : (w1 : ExteriorAlgebra k U) =
        (α : k)⁻¹ • ((pureWedge u v : Lambda2U) : ExteriorAlgebra k U) := by
      rw [hw1]; simp only [Submodule.coe_smul]
    rw [hcoe, smul_mul_smul_comm, pureWedge_sq, smul_zero]
  have h2sq : ((w2 : ExteriorAlgebra k U) * (w2 : ExteriorAlgebra k U) = 0) := by
    have hcoe : (w2 : ExteriorAlgebra k U) =
        (β : k)⁻¹ • ((pureWedge u' v' : Lambda2U) : ExteriorAlgebra k U) := by
      rw [hw2]; simp only [Submodule.coe_smul]
    rw [hcoe, smul_mul_smul_comm, pureWedge_sq, smul_zero]
  have h12sq :
      (((w1 + w2 : Lambda2U) : ExteriorAlgebra k U) *
        ((w1 + w2 : Lambda2U) : ExteriorAlgebra k U) = 0) := by
    have hcoe : ((w1 + w2 : Lambda2U) : ExteriorAlgebra k U) =
        (γ : k)⁻¹ • ((pureWedge us vs : Lambda2U) : ExteriorAlgebra k U) := by
      rw [hw12]; simp only [Submodule.coe_smul]
    rw [hcoe, smul_mul_smul_comm, pureWedge_sq, smul_zero]
  have hpolar := bivector_polar_zero h1sq h2sq h12sq
  have hcomm :
      (w1 : ExteriorAlgebra k U) * (w2 : ExteriorAlgebra k U) =
        (w2 : ExteriorAlgebra k U) * (w1 : ExteriorAlgebra k U) := by
    have c1 : (w1 : ExteriorAlgebra k U) =
        (α : k)⁻¹ • ((pureWedge u v : Lambda2U) : ExteriorAlgebra k U) := by
      rw [hw1]; simp only [Submodule.coe_smul]
    have c2 : (w2 : ExteriorAlgebra k U) =
        (β : k)⁻¹ • ((pureWedge u' v' : Lambda2U) : ExteriorAlgebra k U) := by
      rw [hw2]; simp only [Submodule.coe_smul]
    rw [c1, c2, smul_mul_smul_comm, smul_mul_smul_comm,
      pureWedges_mul_comm u v u' v', mul_comm ((α : k)⁻¹)]
  have hprod0 : (w1 : ExteriorAlgebra k U) * (w2 : ExteriorAlgebra k U) = 0 := by
    have h2w : (2 : k) •
        ((w1 : ExteriorAlgebra k U) * (w2 : ExteriorAlgebra k U)) = 0 := by
      have : (w1 : ExteriorAlgebra k U) * w2 + w1 * w2 = 0 := by
        simpa [hcomm] using hpolar
      simpa [two_smul] using this
    exact (smul_eq_zero.mp h2w).resolve_left (by norm_num)
  have c1 : ((pureWedge u v : Lambda2U) : ExteriorAlgebra k U) =
      (α : k) • (w1 : ExteriorAlgebra k U) := by
    rw [hα]; simp only [Submodule.coe_smul]
  have c2 : ((pureWedge u' v' : Lambda2U) : ExteriorAlgebra k U) =
      (β : k) • (w2 : ExteriorAlgebra k U) := by
    rw [hβ]; simp only [Submodule.coe_smul]
  rw [c1, c2, smul_mul_smul_comm, hprod0, smul_zero]

/-- Linear-RCC subsets of Y^σ are singletons (writeup hyp (a)).

If `finrank W ≥ 2`, a linear family of σ-fixed pure wedges forces a
1-dimensional J-stable axis (plane-meet of two supports), hence √−1 ∈ K. -/
theorem V14_hypothesisA : HypothesisA k V14Variety sigma := by
  intro S hS hRCC
  rcases hRCC with ⟨W0, hdim, hSeq⟩
  -- Align ambient with Lambda2U (definitionally equal, helps typeclass search)
  let W : Submodule k Lambda2U := W0
  have hdimW : Module.finrank k W ≥ 1 := hdim
  have hSeqW : V14Variety.embed '' S =
      { x : ℙ k Lambda2U | x.submodule ≤ W } := hSeq
  have hpos : 0 < Module.finrank k W := by omega
  by_cases hge : 2 ≤ Module.finrank k W
  · exfalso
    have hWne : W ≠ ⊥ := by
      intro hbot
      have : Module.finrank k W = 0 := by rw [hbot, finrank_bot]
      omega
    obtain ⟨w1, hw1W, hw1ne⟩ := Submodule.exists_mem_ne_zero_of_ne_bot hWne
    have hnot : ¬ (W ≤ (k ∙ w1 : Submodule k Lambda2U)) := by
      intro hle
      have hfr : Module.finrank k W ≤ 1 :=
        (Submodule.finrank_mono hle).trans_eq (finrank_span_singleton hw1ne)
      omega
    obtain ⟨w2, hw2W, hw2not⟩ : ∃ w2 ∈ W, w2 ∉ (k ∙ w1 : Submodule k Lambda2U) := by
      by_contra h
      have hall : ∀ x ∈ W, x ∈ (k ∙ w1 : Submodule k Lambda2U) := by
        intro x hx
        by_contra hnotin
        exact h ⟨x, hx, hnotin⟩
      exact hnot hall
    have hw2ne : w2 ≠ 0 := by
      intro h0; apply hw2not; rw [h0]; exact Submodule.zero_mem _
    have hw12 : LinearIndependent k ![w1, w2] := by
      rw [LinearIndependent.pair_iff]
      intro a b hab
      have hb0 : b = 0 := by
        by_contra hbne
        have hsmul := congrArg (fun z => b⁻¹ • z) hab
        simp only [smul_add, smul_smul, inv_mul_cancel₀ hbne, one_smul, smul_zero] at hsmul
        -- hsmul : (b⁻¹ * a) • w1 + w2 = 0
        have hw2eq : w2 = -((b⁻¹ * a) • w1) := eq_neg_of_add_eq_zero_right hsmul
        exact hw2not (Submodule.mem_span_singleton.mpr
          ⟨-(b⁻¹ * a), by rw [neg_smul]; exact hw2eq.symm⟩)
      have ha0 : a = 0 := by
        rw [hb0, zero_smul, add_zero] at hab
        exact (smul_eq_zero.mp hab).resolve_right hw1ne
      exact ⟨ha0, hb0⟩
    have hmk1_mem : Projectivization.mk k w1 hw1ne ∈ V14Variety.embed '' S := by
      rw [hSeqW]
      change (Projectivization.mk k w1 hw1ne).submodule ≤ W
      rw [Projectivization.submodule_mk]
      exact (Submodule.span_singleton_le_iff_mem _ _).mpr hw1W
    have hmk2_mem : Projectivization.mk k w2 hw2ne ∈ V14Variety.embed '' S := by
      rw [hSeqW]
      change (Projectivization.mk k w2 hw2ne).submodule ≤ W
      rw [Projectivization.submodule_mk]
      exact (Submodule.span_singleton_le_iff_mem _ _).mpr hw2W
    obtain ⟨y1, hy1S, hy1eq⟩ := hmk1_mem
    obtain ⟨y2, hy2S, hy2eq⟩ := hmk2_mem
    have hy1fix : actV14 sigma y1 = y1 := hS hy1S
    have hy2fix : actV14 sigma y2 = y2 := hS hy2S
    obtain ⟨u, v, hne, hI, ⟨α, hα⟩⟩ :=
      decomposable_rep_parallel hw1ne (by
        have : y1.1 = Projectivization.mk k w1 hw1ne := hy1eq
        rw [← this]; exact y1.2)
    obtain ⟨u', v', hne', hI', ⟨β, hβ⟩⟩ :=
      decomposable_rep_parallel hw2ne (by
        have : y2.1 = Projectivization.mk k w2 hw2ne := hy2eq
        rw [← this]; exact y2.2)
    have hy1mk : y1.1 = Projectivization.mk k (pureWedge u v) hne := by
      have hmk : Projectivization.mk k (pureWedge u v) hne =
          Projectivization.mk k w1 hw1ne :=
        (Projectivization.mk_eq_mk_iff k _ _ hne hw1ne).mpr ⟨α, hα.symm⟩
      -- hy1eq : embed y1 = mk w1, and embed = Subtype.val
      change V14Variety.embed y1 = Projectivization.mk k (pureWedge u v) hne
      rw [hy1eq, hmk]
    have hy2mk : y2.1 = Projectivization.mk k (pureWedge u' v') hne' := by
      have hmk : Projectivization.mk k (pureWedge u' v') hne' =
          Projectivization.mk k w2 hw2ne :=
        (Projectivization.mk_eq_mk_iff k _ _ hne' hw2ne).mpr ⟨β, hβ.symm⟩
      change V14Variety.embed y2 = Projectivization.mk k (pureWedge u' v') hne'
      rw [hy2eq, hmk]
    have hwsum_ne : w1 + w2 ≠ 0 := by
      intro h
      have : (1 : k) • w1 + (1 : k) • w2 = 0 := by simpa [one_smul] using h
      exact one_ne_zero ((LinearIndependent.pair_iff.mp hw12) 1 1 this).1
    have hsum_mem : w1 + w2 ∈ W := add_mem hw1W hw2W
    have hmksum_mem :
        Projectivization.mk k (w1 + w2) hwsum_ne ∈ V14Variety.embed '' S := by
      rw [hSeqW]
      change (Projectivization.mk k (w1 + w2) hwsum_ne).submodule ≤ W
      rw [Projectivization.submodule_mk]
      exact (Submodule.span_singleton_le_iff_mem _ _).mpr hsum_mem
    obtain ⟨ys, hysS, hyseq⟩ := hmksum_mem
    obtain ⟨us, vs, hnes, hIs, ⟨γ, hγ⟩⟩ :=
      decomposable_rep_parallel hwsum_ne (by
        have : ys.1 = Projectivization.mk k (w1 + w2) hwsum_ne := hyseq
        rw [← this]; exact ys.2)
    have hpure_prod := pure_pair_product_zero_of_sum_pure hα hβ hγ
    have hmeet := planes_meet_of_product_zero hI hI' hpure_prod
    let P : Submodule k U := (k ∙ u) ⊔ (k ∙ v)
    let Q : Submodule k U := (k ∙ u') ⊔ (k ∙ v')
    have hP2 : Module.finrank k P = 2 := finrank_span_pair hI
    have hQ2 : Module.finrank k Q = 2 := finrank_span_pair hI'
    have hJ_P := sigma_fixed_plane_j_stable hI hy1mk hy1fix
    have hJ_Q := sigma_fixed_plane_j_stable hI' hy2mk hy2fix
    have hJmeet : ∀ x ∈ (P ⊓ Q : Submodule k U), Jlin x ∈ P ⊓ Q := by
      intro x hx; exact ⟨hJ_P x hx.1, hJ_Q x hx.2⟩
    have hdim_meet : Module.finrank k (P ⊓ Q : Submodule k U) = 1 := by
      have hpos' : 0 < Module.finrank k (P ⊓ Q : Submodule k U) := by
        by_contra hnp
        have h0 : Module.finrank k (P ⊓ Q : Submodule k U) = 0 :=
          Nat.eq_zero_of_not_pos hnp
        have hbot : P ⊓ Q = (⊥ : Submodule k U) :=
          Submodule.finrank_eq_zero.mp h0
        exact hmeet hbot
      have hle : Module.finrank k (P ⊓ Q : Submodule k U) ≤ 2 :=
        (Submodule.finrank_mono (inf_le_left : P ⊓ Q ≤ P)).trans_eq hP2
      by_cases h2 : Module.finrank k (P ⊓ Q : Submodule k U) = 2
      · exfalso
        have hPQ : P = Q := by
          have hinfP : P ⊓ Q = P :=
            Submodule.eq_of_le_of_finrank_eq inf_le_left (by rw [h2, hP2])
          have hPleQ : P ≤ Q := by rw [← hinfP]; exact inf_le_right
          exact Submodule.eq_of_le_of_finrank_eq hPleQ (by rw [hP2, hQ2])
        obtain ⟨μ, hμne, hμeq⟩ := same_plane_parallel_pure hI hI' hPQ
        set c : k := (α : k)⁻¹ * (μ * (β : k))
        have hpar : w1 = c • w2 := by
          have heqα : (α : k) • w1 = (μ * (β : k)) • w2 := by
            have hαk : pureWedge u v = (α : k) • w1 := by
              simpa only [Units.smul_def] using hα
            have hβk : pureWedge u' v' = (β : k) • w2 := by
              simpa only [Units.smul_def] using hβ
            rw [← hαk, hμeq, hβk, smul_smul]
          have h := congrArg (fun z => (α : k)⁻¹ • z) heqα
          have hα0 : (α : k) ≠ 0 := Units.ne_zero α
          rw [smul_smul, inv_mul_cancel₀ hα0, one_smul] at h
          -- h : w1 = (α)⁻¹ • ((μ*β) • w2)
          rwa [smul_smul] at h
        have hlin : (1 : k) • w1 + (-c) • w2 = 0 := by
          rw [one_smul, hpar, ← add_smul, add_neg_cancel, zero_smul]
        exact one_ne_zero ((LinearIndependent.pair_iff.mp hw12) 1 (-c) hlin).1
      · omega
    exact not_isSquare_neg_one
      (j_stable_odd_forces_neg_one (P ⊓ Q) hJmeet (by rw [hdim_meet]; decide))
  · -- finrank W = 1 ⇒ S singleton
    have h1 : Module.finrank k W = 1 := le_antisymm (by omega) (by omega)
    obtain ⟨v, hv0, hW⟩ : ∃ v : Lambda2U, v ≠ 0 ∧ W = k ∙ v := by
      haveI : Nontrivial W :=
        Module.nontrivial_of_finrank_eq_succ (n := 0) (by simpa using h1)
      obtain ⟨w, hwne⟩ := exists_ne (0 : W)
      refine ⟨(w : Lambda2U), fun h => hwne (Subtype.ext h), ?_⟩
      exact (Submodule.eq_of_le_of_finrank_eq
        ((Submodule.span_singleton_le_iff_mem _ _).mpr w.property)
        (by rw [finrank_span_singleton (fun h => hwne (Subtype.ext h)), h1])).symm
    have hP : V14Variety.embed '' S =
        ({Projectivization.mk k v hv0} : Set (ℙ k Lambda2U)) := by
      rw [hSeqW, hW]
      ext x
      constructor
      · intro hx
        have hxW : x.submodule ≤ k ∙ v := hx
        rw [← Projectivization.mk_rep x]
        set w := Projectivization.rep x
        have hw0 : w ≠ 0 := Projectivization.rep_nonzero x
        have hx_sub : x.submodule = k ∙ w := by
          have hmk : Projectivization.mk k w hw0 = x := Projectivization.mk_rep x
          rw [← hmk, Projectivization.submodule_mk]
        have hle : (k ∙ w : Submodule k Lambda2U) ≤ k ∙ v := by
          rwa [← hx_sub]
        have hwmem : w ∈ k ∙ v := hle (Submodule.mem_span_singleton_self w)
        obtain ⟨a, ha⟩ := Submodule.mem_span_singleton.mp hwmem
        have ha0 : a ≠ 0 := fun hc => hw0 (by rw [← ha, hc, zero_smul])
        have hw_eq : Projectivization.mk k w hw0 =
            Projectivization.mk k (a • v) (smul_ne_zero ha0 hv0) := by
          apply (Projectivization.mk_eq_mk_iff' k w (a • v) hw0
            (smul_ne_zero ha0 hv0)).mpr
          refine ⟨1, ?_⟩
          rw [one_smul, ha]
        rw [hw_eq]
        exact (Projectivization.mk_eq_mk_iff' k (a • v) v
          (smul_ne_zero ha0 hv0) hv0).mpr ⟨a, rfl⟩
      · intro hx
        rw [Set.mem_singleton_iff] at hx
        rw [hx]
        change (Projectivization.mk k v hv0).submodule ≤ k ∙ v
        rw [Projectivization.submodule_mk]
    have hinj : Function.Injective V14Variety.embed := V14Variety.embed.injective
    obtain ⟨y, hyS, hyeq⟩ :
        ∃ y ∈ S, V14Variety.embed y = Projectivization.mk k v hv0 := by
      have : (V14Variety.embed '' S).Nonempty := by
        rw [hP]; exact Set.singleton_nonempty _
      obtain ⟨z, hz⟩ := this
      obtain ⟨y, hyS, rfl⟩ := hz
      refine ⟨y, hyS, ?_⟩
      have hy : V14Variety.embed y ∈
          ({Projectivization.mk k v hv0} : Set _) := by
        rw [← hP]; exact Set.mem_image_of_mem _ hyS
      exact Set.mem_singleton_iff.mp hy
    refine ⟨y, ?_⟩
    ext x
    constructor
    · intro hx
      have : V14Variety.embed x = Projectivization.mk k v hv0 := by
        have hmem : V14Variety.embed x ∈ V14Variety.embed '' S :=
          Set.mem_image_of_mem _ hx
        rw [hP] at hmem
        exact Set.mem_singleton_iff.mp hmem
      exact Set.mem_singleton_iff.mpr (hinj (this.trans hyeq.symm))
    · intro hx
      rw [Set.mem_singleton_iff] at hx
      rwa [hx]

#print axioms ambientAct_sigma_pure
#print axioms sigma_fixed_plane_j_stable
#print axioms same_plane_parallel_pure
#print axioms pureWedge_linear_combo
#print axioms pure_pair_product_zero_of_sum_pure
#print axioms V14_hypothesisA
#print axioms support_eq_of_parallel_pure
#print axioms planes_meet_of_product_zero
#print axioms j_stable_odd_forces_neg_one
#print axioms not_isSquare_neg_one

/-! ## Hypothesis B infrastructure

### Mathematical status (char-0 / modular audit)

The operator `R = Weil(mkRot rotPt)` satisfies `R⁶ = -id` and `R³ = J` on `U`.
Numerically and exactly over `K = ℚ(ζ₁₁)`:

* `rank(R² + id) = 4`, so `dim ker(R² + id) = 2`
* that kernel plane is stable under the full dihedral `N = C_G(σ)`
* its Plücker pure wedge is therefore an **N-fixed point of pure Gr(2,U)**

Hence `HypothesisB` is **false** for the pure-Grassmannian carrier
`IsDecomposable` (operational `Y = Gr(2,U)`). The writeup seals hyp (b) only
after the M-cut `Y = Gr(2,U) ∩ ℙ(M)` with `M = 10'` isotypic of `Λ²U`
(writeup Input 3: character pieces of `M|_N` have dims `(2,1,1,0)` and meet
no decomposable). The residual pure-Gr fixed point has a nonzero `W₅`
component, so lies off `M`.

The lemmas below record the true R-engine. Full `V14_hypothesisB` requires the
M-cut carrier (isotypic projector for `χ₁₀'`, integer-valued on element orders).
-/

/-- Weil operator of the order-12 rotation generating the cyclic half of `N`. -/
public abbrev Rlin : U →ₗ[k] U :=
  WeilHom.weilUHom (CentralizerN.mkRot CentralizerN.rotPt)

theorem Rlin_pow_three_eq_Jlin : (Rlin ^ 3 : Module.End k U) = Jlin := by
  have h : CentralizerN.mkRot CentralizerN.rotPt ^ 3 = WeilRep.Smat :=
    mkRot_rotPt_pow_three
  calc (Rlin : Module.End k U) ^ 3
      = WeilHom.weilUHom (CentralizerN.mkRot CentralizerN.rotPt) ^ 3 := rfl
    _ = WeilHom.weilUHom (CentralizerN.mkRot CentralizerN.rotPt ^ 3) :=
        (map_pow (WeilHom.weilUHom) _ 3).symm
    _ = WeilHom.weilUHom WeilRep.Smat := by rw [h]
    _ = Jlin := rfl

theorem Rlin_pow_six_eq_neg_id :
    (Rlin ^ 6 : Module.End k U) = -LinearMap.id := by
  have h : CentralizerN.mkRot CentralizerN.rotPt ^ 6 = CentralizerN.negI :=
    CentralizerN.mkRot_pow_six
  have hneg : CentralizerN.negI = WeilRepSL2.negI := by
    apply Subtype.ext
    ext i j
    fin_cases i <;> fin_cases j <;>
      simp [CentralizerN.negI, WeilRepSL2.negI, Matrix.neg_apply]
  calc (Rlin ^ 6 : Module.End k U)
      = WeilHom.weilUHom (CentralizerN.mkRot CentralizerN.rotPt) ^ 6 := rfl
    _ = WeilHom.weilUHom (CentralizerN.mkRot CentralizerN.rotPt ^ 6) :=
        (map_pow (WeilHom.weilUHom) _ 6).symm
    _ = WeilHom.weilUHom CentralizerN.negI := by rw [h]
    _ = WeilHom.weilUHom WeilRepSL2.negI := by rw [hneg]
    _ = -LinearMap.id := by
        change WeilRepSL2.weilU WeilRepSL2.negI = -LinearMap.id
        exact WeilRepSL2.weilU_negI

theorem Rlin_injective : Function.Injective Rlin := by
  intro a b hab
  have hsub : Rlin (a - b) = 0 := by simpa [map_sub] using sub_eq_zero.mpr hab
  have h6 := LinearMap.congr_fun Rlin_pow_six_eq_neg_id (a - b)
  -- h6 : (Rlin^6) (a-b) = -(a-b)
  have hzero : (Rlin ^ 6 : Module.End k U) (a - b) = 0 := by
    -- R^6 = R^5 * R, so (R^6)(a-b) = (R^5)(R(a-b)) = (R^5) 0 = 0
    have hform : (Rlin ^ 6 : Module.End k U) = Rlin ^ 5 * Rlin := (pow_succ' Rlin 5).symm
    rw [hform, Module.End.mul_apply, hsub, map_zero]
  -- 0 = -(a-b) ⇒ a = b
  have hid0 : (-LinearMap.id : Module.End k U) (a - b) = 0 := h6.symm.trans hzero
  have hab0 : a - b = 0 := by
    have : -(a - b) = 0 := by simpa using hid0
    exact neg_eq_zero.mp this
  exact sub_eq_zero.mp hab0

/-! ### Character of the writeup 10′ isotypic (integer-valued on orders)

PSL₂(𝔽₁₁) character table: `χ₁₀'` takes values
`1A↦10, 2A↦2, 3A↦1, 5A/5B↦0, 6A↦-1, 11A/11B↦-1`.
All are determined by element order (no need to split 5A/5B or 11A/11B).
Modular check: `⟨χ_{Λ²U}, χ₁₀'⟩ = 1` and `⟨χ_{Λ²U}, χ₁₀⟩ = 0`. -/

/-- Character values of the irreducible `10'` of `PSL₂(𝔽₁₁)`, determined by element order.
    Table: `1A↦10, 2A↦2, 3A↦1, 5A/5B↦0, 6A↦-1, 11A/11B↦-1`. -/
@[expose] public noncomputable def chi10' (g : PSL2F11) : k :=
  let n := orderOf g
  if n = 1 then 10
  else if n = 2 then 2
  else if n = 3 then 1
  else if n = 5 then 0
  else if n = 6 then -1
  else if n = 11 then -1
  else 0

theorem chi10'_one : chi10' (1 : PSL2F11) = 10 := by
  simp [chi10', orderOf_one]

theorem chi10'_eq_of_orderOf_eq {g h : PSL2F11} (ho : orderOf g = orderOf h) :
    chi10' g = chi10' h := by
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
    -- h * g^n * h⁻¹ = 1 ⇒ g^n = 1
    have h1 : h * (g ^ n) * h⁻¹ = 1 := by rwa [← hpow]
    calc g ^ n = h⁻¹ * (h * (g ^ n) * h⁻¹) * h := by simp [mul_assoc]
      _ = h⁻¹ * 1 * h := by rw [h1]
      _ = 1 := by simp

/-- `χ₁₀'` is a class function (depends only on conjugacy via order). -/
theorem chi10'_conj (g h : PSL2F11) : chi10' (h * g * h⁻¹) = chi10' g :=
  chi10'_eq_of_orderOf_eq (orderOf_conj g h)

/-- Isotypic projector onto the 10′ summand `M ⊂ Λ²U`.
    `π = (10/|G|) ∑_g χ₁₀'(g) · ambientAct g`, with `|G| = 660`. -/
@[expose] public noncomputable def projectorM : Module.End k Lambda2U :=
  (10 * (660 : k)⁻¹) •
    ∑ g : PSL2F11, chi10' g • (ambientAct g : Module.End k Lambda2U)

/-- The writeup ambient summand `M = 10'`. -/
@[expose] public noncomputable def Msub : Submodule k Lambda2U :=
  LinearMap.range projectorM

theorem projectorM_apply (v : Lambda2U) :
    projectorM v =
      (10 * (660 : k)⁻¹) • (∑ g : PSL2F11, chi10' g • ambientAct g v) := by
  dsimp [projectorM]
  simp only [LinearMap.smul_apply, LinearMap.sum_apply]

/-- Conjugation reindexing equivalence on `PSL`. -/
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

/-- Character-sum form of the projector is G-equivariant. -/
theorem sum_chi_ambient_equivariant (h : PSL2F11) (v : Lambda2U) :
    (∑ g : PSL2F11, chi10' g • ambientAct g (ambientAct h v)) =
      ambientAct h (∑ g : PSL2F11, chi10' g • ambientAct g v) := by
  -- First rewrite each term: ρ(g)ρ(h) = ρ(h)ρ(h⁻¹gh)
  have hlink :
      (∑ g : PSL2F11, chi10' g • ambientAct g (ambientAct h v)) =
        ∑ g : PSL2F11, chi10' g • ambientAct h (ambientAct (h⁻¹ * g * h) v) := by
    refine Finset.sum_congr rfl fun g _ => ?_
    have hgh : g * h = h * (h⁻¹ * g * h) := by
      calc g * h = (h * h⁻¹) * g * h := by simp
        _ = h * (h⁻¹ * g * h) := by simp [mul_assoc]
    calc chi10' g • ambientAct g (ambientAct h v)
        = chi10' g • ambientAct (g * h) v := by
          rw [← LinearMap.comp_apply, ← ambientAct_mul]
      _ = chi10' g • ambientAct (h * (h⁻¹ * g * h)) v := by rw [hgh]
      _ = chi10' g • ambientAct h (ambientAct (h⁻¹ * g * h) v) := by
          rw [ambientAct_mul, LinearMap.comp_apply]
  rw [hlink]
  -- Replace χ(g) by χ(h⁻¹gh)
  have hχsum :
      (∑ g : PSL2F11, chi10' g • ambientAct h (ambientAct (h⁻¹ * g * h) v)) =
        ∑ g : PSL2F11,
          chi10' (h⁻¹ * g * h) • ambientAct h (ambientAct (h⁻¹ * g * h) v) := by
    refine Finset.sum_congr rfl fun g _ => ?_
    have hχ : chi10' g = chi10' (h⁻¹ * g * h) := by
      have hraw : chi10' g = chi10' (h⁻¹ * g * (h⁻¹)⁻¹) := (chi10'_conj g h⁻¹).symm
      rwa [inv_inv] at hraw
    rw [hχ]
  rw [hχsum]
  -- Pull ambientAct h out of the sum
  have hpull :
      (∑ g : PSL2F11,
          chi10' (h⁻¹ * g * h) • ambientAct h (ambientAct (h⁻¹ * g * h) v)) =
        ∑ g : PSL2F11,
          ambientAct h (chi10' (h⁻¹ * g * h) • ambientAct (h⁻¹ * g * h) v) := by
    refine Finset.sum_congr rfl fun g _ => ?_
    rw [LinearMap.map_smul]
  rw [hpull]
  have hmap :
      (∑ g : PSL2F11,
          ambientAct h (chi10' (h⁻¹ * g * h) • ambientAct (h⁻¹ * g * h) v)) =
        ambientAct h
          (∑ g : PSL2F11, chi10' (h⁻¹ * g * h) • ambientAct (h⁻¹ * g * h) v) :=
    (map_sum (ambientAct h)
      (fun g => chi10' (h⁻¹ * g * h) • ambientAct (h⁻¹ * g * h) v) _).symm
  rw [hmap]
  -- Reindex g ↦ h⁻¹gh via conjEquiv
  apply congrArg
  exact Fintype.sum_equiv (conjEquiv h)
    (fun g => chi10' (h⁻¹ * g * h) • ambientAct (h⁻¹ * g * h) v)
    (fun t => chi10' t • ambientAct t v)
    (fun g => rfl)

/-- The character projector intertwines the ambient G-action. -/
public theorem projectorM_equivariant (h : PSL2F11) (v : Lambda2U) :
    projectorM (ambientAct h v) = ambientAct h (projectorM v) := by
  rw [projectorM_apply, projectorM_apply, map_smul, sum_chi_ambient_equivariant]

/-- `M` is G-invariant. -/
theorem Msub_smul_mem (h : PSL2F11) {v : Lambda2U} (hv : v ∈ Msub) :
    ambientAct h v ∈ Msub := by
  obtain ⟨w, rfl⟩ := LinearMap.mem_range.mp hv
  rw [← projectorM_equivariant]
  exact LinearMap.mem_range_self _ _

/-- Writeup V₁₄ point: decomposable with Plücker representative in `M`. -/
@[expose] public def IsV14MPoint (p : ℙ k Lambda2U) : Prop :=
  IsDecomposable p ∧ Projectivization.rep p ∈ Msub

public theorem IsV14MPoint_actPM (g : PSL2F11) {p : ℙ k Lambda2U}
    (hp : IsV14MPoint p) : IsV14MPoint (actPM g p) := by
  obtain ⟨hdec, hM⟩ := hp
  refine ⟨actPM_preserves_decomposable g hdec, ?_⟩
  induction p using Projectivization.ind with
  | h v hv =>
    -- hM : (mk v).rep ∈ M; ha : a • v = (mk v).rep
    obtain ⟨a, ha⟩ := Projectivization.exists_smul_eq_mk_rep k v hv
    have hvM : v ∈ Msub := by
      have haM : a • v ∈ Msub := by rw [ha]; exact hM
      have := Submodule.smul_mem Msub (a⁻¹ : kˣ) haM
      -- a⁻¹ • (a • v) = v
      simpa [smul_smul, inv_mul_cancel] using this
    dsimp [actPM]
    rw [Projectivization.map_mk]
    set w := ambientAct g v with hw
    have hw0 : w ≠ 0 := fun h0 =>
      hv (ambientAct_injective g (by simpa [hw] using h0))
    obtain ⟨b, hb⟩ := Projectivization.exists_smul_eq_mk_rep k w hw0
    have hwM : w ∈ Msub := by
      rw [hw]; exact Msub_smul_mem g hvM
    -- rep (mk w) = b • w ∈ M
    have : Projectivization.rep (Projectivization.mk k w hw0) = (b : k) • w := hb.symm
    rw [this]
    exact Submodule.smul_mem Msub (b : k) hwM

/-! ## Writeup V₁₄ = Gr(2,U) ∩ ℙ(M) packaging (M-cut points)

`IsV14MPoint` = decomposable + Plücker rep ∈ `Msub`.
G acts via `actPM` (preservation: `IsV14MPoint_actPM`).
Full `SmoothProjectiveGVariety` instance and hyp (b) require:
* an explicit M-point for faithfulness of the set action (or a simplicity+nontrivial argument),
* residual N-fixed pure-Gr plane ∉ `Msub`.
Both are recorded below as the next proof targets; equivariance of `projectorM` is sealed. -/

@[expose] public def V14MPoint : Type := { p : ℙ k Lambda2U // IsV14MPoint p }

@[expose] public def actV14M (g : PSL2F11) (x : V14MPoint) : V14MPoint :=
  ⟨actPM g x.1, IsV14MPoint_actPM g x.2⟩

public theorem actV14M_one (x : V14MPoint) : actV14M 1 x = x :=
  Subtype.ext (actPM_one x.1)

public theorem actV14M_mul (g h : PSL2F11) (x : V14MPoint) :
    actV14M (g * h) x = actV14M g (actV14M h x) :=
  Subtype.ext (actPM_mul g h x.1)

@[expose] public instance : SMul PSL2F11 V14MPoint where smul := actV14M
@[expose] public instance : MulAction PSL2F11 V14MPoint where
  one_smul := actV14M_one
  mul_smul := actV14M_mul

def embedV14M : V14MPoint ↪ ℙ k Lambda2U where
  toFun x := x.1
  inj' := Subtype.coe_injective

theorem embedV14M_smul (g : PSL2F11) (x : V14MPoint) :
    embedV14M (g • x) =
      Projectivization.map (ambientAct g) (ambientAct_injective g) (embedV14M x) :=
  rfl

/-- Kernel of the set-action on M-cut points (a normal subgroup of the simple group). -/
def actionKernelM : Subgroup PSL2F11 where
  carrier := {g | ∀ x : V14MPoint, g • x = x}
  one_mem' := by intro x; exact one_smul _ x
  mul_mem' := by
    intro a b ha hb x
    rw [mul_smul, hb, ha]
  inv_mem' := by
    intro a ha x
    -- a fixes a⁻¹•x, and a•(a⁻¹•x)=x, so x = a⁻¹•x
    have hy : a • (a⁻¹ • x) = a⁻¹ • x := ha (a⁻¹ • x)
    have hx : a • (a⁻¹ • x) = x := by rw [← mul_smul, mul_inv_cancel, one_smul]
    exact (hx.symm.trans hy).symm

theorem actionKernelM_normal : actionKernelM.Normal := by
  constructor
  intro n hn g
  intro x
  -- (g n g⁻¹) • x = g • n • g⁻¹ • x = g • (g⁻¹ • x) = x
  change (g * n * g⁻¹) • x = x
  rw [mul_smul, mul_smul]
  have hfix : n • (g⁻¹ • x) = g⁻¹ • x := hn (g⁻¹ • x)
  rw [hfix, ← mul_smul, mul_inv_cancel, one_smul]


/-! ## Residual plane `ker(R² + id)`

N-fixed decomposable planes over K are residual type (R²=-id on support):
the Φ₁₂ branch forces `tr(R|_P)² = 3`, impossible in K=ℚ(ζ₁₁) (unique
quadratic subfield ℚ(√−11)).  Residual Plücker is the unique N-fixed pure-Gr
point; writeup hyp (b) requires it to miss M=10′.

Scaffolded here: `residualKer` and R-stability.  `not_isSquare_three` is proved
above (classical).  Remaining for hyp B: N-fixed ⇒ R²=-id on support, residual
Plücker ∉ Msub, V14MVariety faithfulness, rewire Application. -/

@[expose] public noncomputable def residualKer : Submodule k U :=
  LinearMap.ker (Rlin ∘ₗ Rlin + LinearMap.id)

public theorem mem_residualKer_iff {u : U} :
    u ∈ residualKer ↔ Rlin (Rlin u) + u = 0 := by
  simp [residualKer, LinearMap.mem_ker, LinearMap.add_apply, LinearMap.comp_apply]

public theorem residualKer_R2 {u : U} (hu : u ∈ residualKer) :
    Rlin (Rlin u) = -u :=
  eq_neg_of_add_eq_zero_left (mem_residualKer_iff.mp hu)

theorem residualKer_R_stable {u : U} (hu : u ∈ residualKer) :
    Rlin u ∈ residualKer := by
  rw [mem_residualKer_iff] at hu ⊢
  have hR2 := residualKer_R2 (mem_residualKer_iff.mpr hu)
  calc Rlin (Rlin (Rlin u)) + Rlin u
      = Rlin (-u) + Rlin u := by rw [hR2]
    _ = -Rlin u + Rlin u := by rw [map_neg]
    _ = 0 := by abel

/-! ### No 6th roots of −1 in K -/

theorem no_elem_order_four {z : k} (h : orderOf z = 4) : False := by
  have hprim : IsPrimitiveRoot z 4 := (IsPrimitiveRoot.iff_orderOf).2 h
  let hpb := AdjoinRoot.powerBasis (K := ℚ) (f := WeilRep.Φ11)
    WeilRep.Φ11_irreducible.ne_zero
  haveI : Module.Finite ℚ k := Module.Finite.of_basis hpb.basis
  haveI : FiniteDimensional ℚ k := inferInstance
  have hirr : Irreducible (cyclotomic (Nat.lcm 4 11) ℚ) :=
    cyclotomic.irreducible_rat (Nat.lcm_pos (by decide) (by decide))
  have hle : (Nat.lcm 4 11).totient ≤ Module.finrank ℚ k :=
    IsPrimitiveRoot.lcm_totient_le_finrank (K := ℚ) (L := k) hprim
      isPrimitiveRoot_ζ hirr
  have hnum : Nat.lcm 4 11 = 44 := by decide
  have htot : Nat.totient 44 = 20 := by decide
  rw [hnum, htot, finrank_K] at hle
  exact absurd hle (by decide : ¬(20 ≤ 10))

theorem no_elem_order_twelve {z : k} (h : orderOf z = 12) : False := by
  have hprim : IsPrimitiveRoot z 12 := (IsPrimitiveRoot.iff_orderOf).2 h
  let hpb := AdjoinRoot.powerBasis (K := ℚ) (f := WeilRep.Φ11)
    WeilRep.Φ11_irreducible.ne_zero
  haveI : Module.Finite ℚ k := Module.Finite.of_basis hpb.basis
  haveI : FiniteDimensional ℚ k := inferInstance
  have hirr : Irreducible (cyclotomic (Nat.lcm 12 11) ℚ) :=
    cyclotomic.irreducible_rat (Nat.lcm_pos (by decide) (by decide))
  have hle : (Nat.lcm 12 11).totient ≤ Module.finrank ℚ k :=
    IsPrimitiveRoot.lcm_totient_le_finrank (K := ℚ) (L := k) hprim
      isPrimitiveRoot_ζ hirr
  have hnum : Nat.lcm 12 11 = 132 := by decide
  have htot : Nat.totient 132 = 40 := by decide
  rw [hnum, htot, finrank_K] at hle
  exact absurd hle (by decide : ¬(40 ≤ 10))

/-- No element of `K` satisfies `z⁶ = −1` (order would be 4 or 12). -/
theorem no_sixth_root_neg_one {z : k} (h : z ^ 6 = (-1 : k)) : False := by
  have h12 : z ^ 12 = 1 := by
    calc z ^ 12 = (z ^ 6) ^ 2 := by ring
      _ = (-1) ^ 2 := by rw [h]
      _ = 1 := by norm_num
  have hfin : IsOfFinOrder z :=
    isOfFinOrder_iff_pow_eq_one.mpr ⟨12, by decide, h12⟩
  have hord_dvd : orderOf z ∣ 12 := orderOf_dvd_of_pow_eq_one h12
  have hne : z ^ 6 ≠ 1 := by
    intro heq; exact absurd (h.symm.trans heq) (by norm_num)
  have not6 : ¬ (orderOf z ∣ 6) := fun hd =>
    hne (orderOf_dvd_iff_pow_eq_one.mp hd)
  have hpos : 0 < orderOf z := hfin.orderOf_pos
  have hle : orderOf z ≤ 12 := Nat.le_of_dvd (by decide : 0 < 12) hord_dvd
  -- Possible positive divisors of 12: 1,2,3,4,6,12; exclude those | 6
  have h4or12 : orderOf z = 4 ∨ orderOf z = 12 := by
    set n := orderOf z with hn
    have hnpos : 0 < n := hpos
    have hnle : n ≤ 12 := hle
    have hnd : n ∣ 12 := hord_dvd
    have hn6 : ¬ n ∣ 6 := not6
    match n with
    | 0 => exact absurd hnpos (by decide)
    | 1 => exact absurd (show 1 ∣ 6 from by decide) hn6
    | 2 => exact absurd (show 2 ∣ 6 from by decide) hn6
    | 3 => exact absurd (show 3 ∣ 6 from by decide) hn6
    | 4 => exact Or.inl rfl
    | 5 => exact absurd (show 5 ∣ 12 from hnd) (by decide)
    | 6 => exact absurd (show 6 ∣ 6 from by decide) hn6
    | 7 => exact absurd (show 7 ∣ 12 from hnd) (by decide)
    | 8 => exact absurd (show 8 ∣ 12 from hnd) (by decide)
    | 9 => exact absurd (show 9 ∣ 12 from hnd) (by decide)
    | 10 => exact absurd (show 10 ∣ 12 from hnd) (by decide)
    | 11 => exact absurd (show 11 ∣ 12 from hnd) (by decide)
    | 12 => exact Or.inr rfl
    | _ + 13 => omega
  rcases h4or12 with h4 | h12ord
  · exact no_elem_order_four h4
  · exact no_elem_order_twelve h12ord

/-- Restriction of `Rlin` to an R-stable submodule. -/
noncomputable def Rrestrict (L : Submodule k U) (hL : ∀ x ∈ L, Rlin x ∈ L) :
    L →ₗ[k] L where
  toFun x := ⟨Rlin (x : U), hL (x : U) x.property⟩
  map_add' := by
    intro x y; apply Subtype.ext; exact map_add Rlin _ _
  map_smul' := by
    intro r x; apply Subtype.ext; exact map_smul Rlin r _

theorem Rrestrict_apply (L : Submodule k U) (hL : ∀ x ∈ L, Rlin x ∈ L) (x : L) :
    (Rrestrict L hL x : U) = Rlin (x : U) := rfl

theorem Rrestrict_pow_coe (L : Submodule k U) (hL : ∀ x ∈ L, Rlin x ∈ L) (n : ℕ)
    (x : L) :
    ((Rrestrict L hL ^ n : Module.End k L) x : U) =
      (Rlin ^ n : Module.End k U) (x : U) := by
  induction n generalizing x with
  | zero =>
    simp only [pow_zero, Module.End.one_eq_id, LinearMap.id_apply]
  | succ n ih =>
    rw [pow_succ, pow_succ, Module.End.mul_apply, Module.End.mul_apply]
    rw [ih (Rrestrict L hL x), Rrestrict_apply]

theorem Rrestrict_pow_six_add_id (L : Submodule k U) (hL : ∀ x ∈ L, Rlin x ∈ L) :
    (Rrestrict L hL ^ 6 + LinearMap.id : Module.End k L) = 0 := by
  apply LinearMap.ext
  intro x
  apply Subtype.coe_injective
  have h := LinearMap.congr_fun Rlin_pow_six_eq_neg_id (x : U)
  change (Rlin ^ 6 : Module.End k U) (x : U) = -(x : U) at h
  have hcoe := Rrestrict_pow_coe L hL 6 x
  have hadd :
      (((Rrestrict L hL ^ 6 + LinearMap.id : Module.End k L) x : L) : U) =
        ((Rrestrict L hL ^ 6 : Module.End k L) x : U) + (x : U) := by
    rw [LinearMap.add_apply, LinearMap.id_apply, Submodule.coe_add]
  calc (((Rrestrict L hL ^ 6 + LinearMap.id : Module.End k L) x : L) : U)
      = ((Rrestrict L hL ^ 6 : Module.End k L) x : U) + (x : U) := hadd
    _ = (Rlin ^ 6 : Module.End k U) (x : U) + (x : U) := by rw [hcoe]
    _ = -(x : U) + (x : U) := by rw [h]
    _ = (0 : U) := by abel
    _ = (((0 : Module.End k L) x : L) : U) := by
        simp only [LinearMap.zero_apply, ZeroMemClass.coe_zero]


/-! ### Monic quadratic divisors of X⁶+1; residual planes -/

theorem monic_of_natDegree_eq_two_form {p : k[X]} (hp : p.Monic) (hd : p.natDegree = 2) :
    p = X ^ 2 + C (p.coeff 1) * X + C (p.coeff 0) := by
  set a := p.coeff 1
  set b := p.coeff 0
  have h' : p = eraseLead p + X ^ 2 := by
    have h := eraseLead_add_C_mul_X_pow p
    rw [hp.leadingCoeff, C_1, one_mul, hd] at h
    exact h.symm
  have hdeg : (eraseLead p).natDegree ≤ 1 :=
    (eraseLead_natDegree_le p).trans (by omega)
  have herase : eraseLead p = C a * X + C b := by
    have hform := eq_X_add_C_of_natDegree_le_one (p := eraseLead p) hdeg
    have hc1 : (eraseLead p).coeff 1 = a := eraseLead_coeff_of_ne _ (by omega)
    have hc0 : (eraseLead p).coeff 0 = b := eraseLead_coeff_of_ne _ (by omega)
    rwa [hc1, hc0] at hform
  rw [h', herase]; abel

theorem monic_X2_add_one : ((X : k[X]) ^ 2 + 1).Monic :=
  monic_X_pow_add_C (1 : k) (by decide)

theorem natDegree_X2_add_one : ((X : k[X]) ^ 2 + 1).natDegree = 2 :=
  natDegree_X_pow_add_C

theorem monic_X4_sub_X2_add_one : ((X : k[X]) ^ 4 - X ^ 2 + 1).Monic := by
  have h : ((X : k[X]) ^ 4 + (-X ^ 2 + 1)).Monic := by
    refine monic_X_pow_add ?_
    have : ((-X ^ 2 + (1 : k[X]))).natDegree ≤ 2 := by
      apply (natDegree_add_le _ _).trans
      simp only [natDegree_neg, natDegree_X_pow, natDegree_one]
      exact Nat.max_le.mpr ⟨le_rfl, by decide⟩
    exact (degree_le_of_natDegree_le this).trans_lt
      (by exact_mod_cast (by decide : (2 : ℕ) < 4))
  convert h using 1; abel

theorem natDegree_X4_sub_X2_add_one :
    ((X : k[X]) ^ 4 - X ^ 2 + 1).natDegree = 4 := by
  have heq : ((X : k[X]) ^ 4 - X ^ 2 + 1) = X ^ 4 + (-X ^ 2 + 1) := by abel
  rw [heq]
  have hlt : degree (-X ^ 2 + (1 : k[X])) < degree ((X : k[X]) ^ 4) := by
    have hle : ((-X ^ 2 + (1 : k[X]))).natDegree ≤ 2 := by
      apply (natDegree_add_le _ _).trans
      simp only [natDegree_neg, natDegree_X_pow, natDegree_one]
      exact Nat.max_le.mpr ⟨le_rfl, by decide⟩
    have : degree (-X ^ 2 + (1 : k[X])) ≤ (2 : ℕ) := degree_le_of_natDegree_le hle
    have hx : degree ((X : k[X]) ^ 4) = (4 : ℕ) := degree_X_pow 4
    apply this.trans_lt; rw [hx]; exact_mod_cast (by decide : (2 : ℕ) < 4)
  have hdeg : degree (X ^ 4 + (-X ^ 2 + (1 : k[X]))) = (4 : ℕ) := by
    rw [degree_add_eq_left_of_degree_lt hlt, degree_X_pow]
  simpa using (natDegree_eq_of_degree_eq_some hdeg)

theorem X6_add_one_factor :
    ((X : k[X]) ^ 6 + 1) = (X ^ 2 + 1) * (X ^ 4 - X ^ 2 + 1) := by ring

theorem sq_eq_three_of_two_sub (a : k) (h : (2 : k) - a ^ 2 = -1) : a ^ 2 = 3 := by
  have h' : (2 : k) = a ^ 2 - 1 := by
    calc (2 : k) = (2 - a ^ 2) + a ^ 2 := by ring
      _ = -1 + a ^ 2 := by rw [h]
      _ = a ^ 2 - 1 := by ring
  calc a ^ 2 = (a ^ 2 - 1) + 1 := by ring
    _ = 2 + 1 := by rw [← h']
    _ = 3 := by norm_num

theorem sq_eq_neg_one_of_neg_two_sub (a : k) (h : (-2 : k) - a ^ 2 = -1) : a ^ 2 = -1 := by
  have h' : (-2 : k) = a ^ 2 - 1 := by
    calc (-2 : k) = ((-2) - a ^ 2) + a ^ 2 := by ring
      _ = -1 + a ^ 2 := by rw [h]
      _ = a ^ 2 - 1 := by ring
  calc a ^ 2 = (a ^ 2 - 1) + 1 := by ring
    _ = -2 + 1 := by rw [← h']
    _ = -1 := by norm_num

theorem monic_quad_form_mul (a b c e : k) :
    (X ^ 2 + C a * X + C b) * (X ^ 2 + C c * X + C e) =
      X ^ 4 + C (a + c) * X ^ 3 + C (b + e + a * c) * X ^ 2 +
        C (a * e + b * c) * X + C (b * e) := by
  simp only [C_add, C_mul]
  ring

theorem quartic_form_coeff_three (p3 p2 p1 p0 : k) :
    (X ^ 4 + C p3 * X ^ 3 + C p2 * X ^ 2 + C p1 * X + C p0 : k[X]).coeff 3 = p3 := by
  simp [coeff_add, coeff_C_mul, coeff_X_pow]

theorem quartic_form_coeff_two (p3 p2 p1 p0 : k) :
    (X ^ 4 + C p3 * X ^ 3 + C p2 * X ^ 2 + C p1 * X + C p0 : k[X]).coeff 2 = p2 := by
  simp [coeff_add, coeff_C_mul, coeff_X_pow]

theorem quartic_form_coeff_one (p3 p2 p1 p0 : k) :
    (X ^ 4 + C p3 * X ^ 3 + C p2 * X ^ 2 + C p1 * X + C p0 : k[X]).coeff 1 = p1 := by
  simp [coeff_add, coeff_C_mul, coeff_X_pow]

theorem quartic_form_coeff_zero (p3 p2 p1 p0 : k) :
    (X ^ 4 + C p3 * X ^ 3 + C p2 * X ^ 2 + C p1 * X + C p0 : k[X]).coeff 0 = p0 := by
  simp [coeff_add, coeff_C_mul, coeff_X_pow, coeff_X, coeff_C]

theorem monic_quad_dvd_X6_eq_X2_add_one
    (f : k[X]) (hm : f.Monic) (hd : f.natDegree = 2)
    (hdiv : f ∣ (X : k[X]) ^ 6 + 1) :
    f = X ^ 2 + 1 := by
  have hno_root : ∀ α : k, ¬ IsRoot f α := by
    intro α hr
    have hev : aeval α ((X : k[X]) ^ 6 + 1) = 0 :=
      aeval_eq_zero_of_dvd_aeval_eq_zero hdiv (by simpa [IsRoot.def] using hr)
    have : α ^ 6 + 1 = 0 := by simpa [map_add, map_pow, map_one, aeval_X] using hev
    exact no_sixth_root_neg_one (eq_neg_of_add_eq_zero_left this)
  have hirr : Irreducible f :=
    irreducible_of_degree_le_three_of_not_isRoot (by simp [Finset.mem_Icc, hd]) hno_root
  have hprime : Prime f := hirr.prime
  rw [X6_add_one_factor] at hdiv
  rcases hprime.dvd_or_dvd hdiv with h1 | h2
  · exact (eq_of_monic_of_dvd_of_natDegree_le hm monic_X2_add_one h1
      (by rw [natDegree_X2_add_one, hd])).symm
  · obtain ⟨g, hg⟩ := h2
    -- hg : X^4 - X^2 + 1 = f * g
    have hprod_mon := monic_X4_sub_X2_add_one
    have hg_mon : g.Monic := by
      have hlc : (f * g).leadingCoeff = f.leadingCoeff * g.leadingCoeff :=
        leadingCoeff_mul f g
      change g.leadingCoeff = 1
      have hfg1 : (f * g).leadingCoeff = 1 := by
        rw [← hg]; exact hprod_mon
      have : (1 : k) = 1 * g.leadingCoeff := by
        calc (1 : k) = (f * g).leadingCoeff := hfg1.symm
          _ = f.leadingCoeff * g.leadingCoeff := hlc
          _ = 1 * g.leadingCoeff := by rw [hm]
      simpa using this.symm
    have hdeg_sum : f.natDegree + g.natDegree = 4 := by
      have := natDegree_mul hm.ne_zero hg_mon.ne_zero
      rw [← this, ← hg, natDegree_X4_sub_X2_add_one]
    have hgdeg : g.natDegree = 2 := by omega
    set a := f.coeff 1
    set b := f.coeff 0
    set c := g.coeff 1
    set e := g.coeff 0
    have hf' : f = X ^ 2 + C a * X + C b := monic_of_natDegree_eq_two_form hm hd
    have hg' : g = X ^ 2 + C c * X + C e := monic_of_natDegree_eq_two_form hg_mon hgdeg
    have hprod :
        f * g =
          X ^ 4 + C (a + c) * X ^ 3 + C (b + e + a * c) * X ^ 2 +
            C (a * e + b * c) * X + C (b * e) := by
      rw [hf', hg']
      exact monic_quad_form_mul a b c e
    have heq_coeff (n : ℕ) :
        ((X : k[X]) ^ 4 - X ^ 2 + 1).coeff n =
          (X ^ 4 + C (a + c) * X ^ 3 + C (b + e + a * c) * X ^ 2 +
            C (a * e + b * c) * X + C (b * e)).coeff n :=
      congrArg (fun p => p.coeff n) (hg.trans hprod)
    have h3 : a + c = (0 : k) := by
      have := heq_coeff 3
      have hl : ((X : k[X]) ^ 4 - X ^ 2 + 1).coeff 3 = 0 := by
        simp [coeff_X_pow, coeff_sub, coeff_add, coeff_one]
      have hr :
          (X ^ 4 + C (a + c) * X ^ 3 + C (b + e + a * c) * X ^ 2 +
            C (a * e + b * c) * X + C (b * e)).coeff 3 = a + c := by
        exact quartic_form_coeff_three _ _ _ _
      rw [hl, hr] at this; exact this.symm
    have h2c : b + e + a * c = (-1 : k) := by
      have := heq_coeff 2
      have hl : ((X : k[X]) ^ 4 - X ^ 2 + 1).coeff 2 = -1 := by
        simp [coeff_X_pow, coeff_sub, coeff_add, coeff_one]
      have hr :
          (X ^ 4 + C (a + c) * X ^ 3 + C (b + e + a * c) * X ^ 2 +
            C (a * e + b * c) * X + C (b * e)).coeff 2 = b + e + a * c := by
        exact quartic_form_coeff_two _ _ _ _
      rw [hl, hr] at this; exact this.symm
    have h1c : a * e + b * c = (0 : k) := by
      have := heq_coeff 1
      have hl : ((X : k[X]) ^ 4 - X ^ 2 + 1).coeff 1 = 0 := by
        simp [coeff_X_pow, coeff_sub, coeff_add, coeff_one]
      have hr :
          (X ^ 4 + C (a + c) * X ^ 3 + C (b + e + a * c) * X ^ 2 +
            C (a * e + b * c) * X + C (b * e)).coeff 1 = a * e + b * c := by
        exact quartic_form_coeff_one _ _ _ _
      rw [hl, hr] at this; exact this.symm
    have h0c : b * e = (1 : k) := by
      have := heq_coeff 0
      have hl : ((X : k[X]) ^ 4 - X ^ 2 + 1).coeff 0 = 1 := by
        simp [coeff_X_pow, coeff_sub, coeff_add, coeff_one]
      have hr :
          (X ^ 4 + C (a + c) * X ^ 3 + C (b + e + a * c) * X ^ 2 +
            C (a * e + b * c) * X + C (b * e)).coeff 0 = b * e := by
        exact quartic_form_coeff_zero _ _ _ _
      rw [hl, hr] at this; exact this.symm
    have hc : c = -a := eq_neg_of_add_eq_zero_left (by rw [add_comm]; exact h3)
    have hbne : b ≠ 0 := fun hb => by simp [hb] at h0c
    have he : e = b⁻¹ := (inv_eq_of_mul_eq_one_right h0c).symm
    -- a/b - a b = 0
    have hrel : a * b⁻¹ - a * b = 0 := by
      have := h1c
      rw [hc, he] at this
      convert this using 1; ring
    have hfactor : a * (b⁻¹ - b) = 0 := by convert hrel using 1; ring
    rcases mul_eq_zero.mp hfactor with ha0 | hbb
    · -- a=0: b + b⁻¹ = -1
      have hsum : b + b⁻¹ = -1 := by
        have := h2c
        -- b + e + a*c = -1, a=0, c=-a=0, e=b⁻¹
        simp only [ha0, zero_mul, add_zero] at this
        rwa [he] at this
      have hbpoly : b ^ 2 + b + 1 = 0 := by
        have := hsum
        field_simp [hbne] at this
        linear_combination this
      have : (2 * b + 1) ^ 2 = (-3 : k) := by
        calc (2 * b + 1) ^ 2 = 4 * (b ^ 2 + b + 1) - 3 := by ring
          _ = -3 := by rw [hbpoly]; ring
      exact False.elim (not_isSquare_neg_three ⟨2 * b + 1,
        by simpa [pow_two, eq_comm] using this⟩)
    · have hinv : b⁻¹ = b := sub_eq_zero.mp hbb
      have hb2 : b ^ 2 = 1 := by
        have : b * b⁻¹ = 1 := mul_inv_cancel₀ hbne
        rwa [hinv, ← pow_two] at this
      have hbpm : b = 1 ∨ b = -1 := by
        have : (b - 1) * (b + 1) = 0 := by linear_combination hb2
        rcases mul_eq_zero.mp this with h | h
        · exact Or.inl (eq_of_sub_eq_zero h)
        · exact Or.inr (eq_neg_of_add_eq_zero_left h)
      rcases hbpm with hb1 | hbm1
      · -- b=1: 1 + 1 - a^2 = -1
        have hsum : (2 : k) - a ^ 2 = -1 := by
          have := h2c
          rw [hb1, hc, he, hb1, inv_one] at this
          -- b + e + a*c = 1 + 1 + a*(-a) = 2 - a^2
          convert this using 1; ring
        exact False.elim (not_isSquare_three ⟨a, by
          simpa [pow_two, eq_comm] using sq_eq_three_of_two_sub a hsum⟩)
      · have hsum : (-2 : k) - a ^ 2 = -1 := by
          have := h2c
          have he' : e = -1 := by rw [he, hbm1, inv_neg, inv_one]
          rw [hbm1, hc, he'] at this
          convert this using 1; ring
        exact False.elim (not_isSquare_neg_one ⟨a, by
          simpa [pow_two, eq_comm] using sq_eq_neg_one_of_neg_two_sub a hsum⟩)



/-! ### Residual plane classification

Any R-stable 2-plane has minpoly dividing X⁶+1 of degree ≤2. Degree 1 would
force a 6th root of −1 (impossible). Degree 2 is X²+1 by
`monic_quad_dvd_X6_eq_X2_add_one`, so R² = −id on the plane (= residualKer).

`Module.End k ↥P` has a known AddCommMonoid diamond that blocks Ring/Algebra,
so we conjugate via a Fin-2 basis to `Module.End k (Fin 2 → k)`. -/

/-- Conjugate an endomorphism along a linear equivalence (avoids End-on-submodule
Ring TC diamond). -/
@[expose] public noncomputable def conjEnd {R M N : Type*} [Semiring R]
    [AddCommMonoid M] [Module R M] [AddCommMonoid N] [Module R N]
    (e : M ≃ₗ[R] N) (f : Module.End R M) : Module.End R N :=
  e.toLinearMap ∘ₗ f ∘ₗ e.symm.toLinearMap

@[simp] public theorem conjEnd_apply {R M N : Type*} [Semiring R]
    [AddCommMonoid M] [Module R M] [AddCommMonoid N] [Module R N]
    (e : M ≃ₗ[R] N) (f : Module.End R M) (x : N) :
    conjEnd e f x = e (f (e.symm x)) := rfl

theorem conjEnd_pow {R M N : Type*} [Semiring R]
    [AddCommMonoid M] [Module R M] [AddCommMonoid N] [Module R N]
    (e : M ≃ₗ[R] N) (f : Module.End R M) (n : ℕ) :
    conjEnd e (f ^ n) = conjEnd e f ^ n := by
  induction n with
  | zero => ext x; simp [pow_zero, Module.End.one_eq_id]
  | succ n ih =>
    rw [pow_succ, pow_succ]
    ext x
    have ihy := LinearMap.congr_fun ih (conjEnd e f x)
    simp only [conjEnd_apply, Module.End.mul_apply, LinearEquiv.symm_apply_apply] at ihy ⊢
    exact ihy

theorem conjEnd_add {R M N : Type*} [Semiring R]
    [AddCommMonoid M] [Module R M] [AddCommMonoid N] [Module R N]
    (e : M ≃ₗ[R] N) (f g : Module.End R M) :
    conjEnd e (f + g) = conjEnd e f + conjEnd e g := by
  ext; simp [map_add]

theorem conjEnd_one {R M N : Type*} [Semiring R]
    [AddCommMonoid M] [Module R M] [AddCommMonoid N] [Module R N]
    (e : M ≃ₗ[R] N) : conjEnd e (1 : Module.End R M) = 1 := by
  ext; simp [Module.End.one_eq_id]

theorem conjEnd_zero_iff {R M N : Type*} [Semiring R]
    [AddCommMonoid M] [Module R M] [AddCommMonoid N] [Module R N]
    (e : M ≃ₗ[R] N) (f : Module.End R M) :
    conjEnd e f = 0 ↔ f = 0 := by
  constructor
  · intro h
    ext m
    have : e (f m) = 0 := by
      have := LinearMap.congr_fun h (e m)
      simpa [LinearEquiv.symm_apply_apply, LinearMap.zero_apply] using this
    exact e.injective (by simpa using this)
  · intro h; simp [h]; ext; simp

/-- An R-stable 2-plane is residual: R²x + x = 0 for all x ∈ P. -/
theorem R_stable_plane_residual
    (P : Submodule k U)
    (hdim : Module.finrank k P = 2)
    (hR : ∀ x ∈ P, Rlin x ∈ P) :
    ∀ x ∈ P, Rlin (Rlin x) + x = 0 := by
  intro x hx
  haveI : Module.Free k P := Module.Free.of_divisionRing k P
  haveI : Module.Finite k P :=
    Module.finite_of_finrank_eq_succ (by rw [hdim] : Module.finrank k P = (1 : ℕ).succ)
  haveI : FiniteDimensional k P := inferInstance
  let b0 := Module.Free.chooseBasis k P
  have hcard : Fintype.card (Module.Free.ChooseBasisIndex k P) = 2 := by
    rw [← Module.finrank_eq_card_chooseBasisIndex, hdim]
  let eIdx : Module.Free.ChooseBasisIndex k P ≃ Fin 2 := Fintype.equivFinOfCardEq hcard
  let b : Module.Basis (Fin 2) k P := b0.reindex eIdx
  let eFun : P ≃ₗ[k] (Fin 2 → k) := b.equivFun
  let R0 : Module.End k P := Rrestrict P hR
  let T : Module.End k (Fin 2 → k) := conjEnd eFun R0
  have hR0_6 : R0 ^ 6 + 1 = 0 := Rrestrict_pow_six_add_id P hR
  have hT6 : T ^ 6 + 1 = 0 := by
    calc T ^ 6 + 1
        = conjEnd eFun (R0 ^ 6) + conjEnd eFun 1 := by
          rw [← conjEnd_pow, conjEnd_one]
      _ = conjEnd eFun (R0 ^ 6 + 1) := (conjEnd_add eFun _ _).symm
      _ = conjEnd eFun 0 := by rw [hR0_6]
      _ = 0 := by ext; simp
  have hmin_dvd : minpoly k T ∣ (X : k[X]) ^ 6 + 1 := by
    refine minpoly.dvd k T ?_
    have hmap : aeval T ((X : k[X]) ^ 6 + 1) = T ^ 6 + 1 := by
      simp only [map_add, map_pow, map_one, aeval_X, Module.End.one_eq_id]
    rwa [hmap]
  have hmon : (minpoly k T).Monic := minpoly.monic (IsIntegral.of_finite k T)
  have hdeg_le : (minpoly k T).natDegree ≤ 2 := by
    have hcp := LinearMap.minpoly_dvd_charpoly (f := T)
    have hcpdeg : (LinearMap.charpoly T).natDegree = 2 := by
      have h := LinearMap.charpoly_natDegree (R := k) (M := Fin 2 → k) T
      rw [h, Module.finrank_fintype_fun_eq_card (R := k) (η := Fin 2)]
      exact Fintype.card_fin 2
    exact (natDegree_le_of_dvd hcp (LinearMap.charpoly_monic T).ne_zero).trans_eq hcpdeg
  have hdeg_pos : 0 < (minpoly k T).natDegree := by
    by_contra h
    have h0 : (minpoly k T).natDegree = 0 := by omega
    have heq1 : minpoly k T = 1 := (Monic.natDegree_eq_zero hmon).mp h0
    have : aeval T (1 : k[X]) = 0 := by rw [← heq1]; exact minpoly.aeval k T
    have : (1 : Module.End k (Fin 2 → k)) = 0 := by simpa using this
    exact one_ne_zero this
  by_cases hdeg1 : (minpoly k T).natDegree = 1
  · have hzform := hmon.eq_X_add_C hdeg1
    set z : k := -(minpoly k T).coeff 0
    have hae : aeval T (X - C z) = 0 := by
      have : (X - C z : k[X]) = X + C ((minpoly k T).coeff 0) := by
        simp [z, sub_eq_add_neg, neg_neg]
      rw [this, ← hzform]; exact minpoly.aeval k T
    have hTeq : T = z • (1 : Module.End k (Fin 2 → k)) := by
      have : T - z • (1 : Module.End k (Fin 2 → k)) = 0 := by
        simpa [map_sub, aeval_X, aeval_C, Algebra.algebraMap_eq_smul_one,
          Module.End.one_eq_id] using hae
      exact eq_of_sub_eq_zero this
    have hpow : ∀ n : ℕ, (z • (1 : Module.End k (Fin 2 → k))) ^ n =
        (z ^ n) • (1 : Module.End k (Fin 2 → k)) := by
      intro n; induction n with
      | zero => ext; simp
      | succ n ih =>
        apply LinearMap.ext
        intro w
        rw [pow_succ, Module.End.mul_apply, ih]
        simp only [LinearMap.smul_apply, Module.End.one_eq_id, LinearMap.id_apply]
        rw [smul_smul, ← pow_succ]
    have hneg : T ^ 6 = (-1 : Module.End k (Fin 2 → k)) :=
      eq_neg_of_add_eq_zero_left hT6
    have hzsmul : (z ^ 6 : k) • (1 : Module.End k (Fin 2 → k)) = -1 := by
      calc (z ^ 6) • (1 : Module.End k (Fin 2 → k))
          = (z • (1 : Module.End k (Fin 2 → k))) ^ 6 := (hpow 6).symm
        _ = T ^ 6 := by rw [← hTeq]
        _ = -1 := hneg
    have hz6 : z ^ 6 = (-1 : k) := by
      have happ := LinearMap.congr_fun hzsmul (1 : Fin 2 → k)
      simp only [LinearMap.smul_apply, Module.End.one_eq_id, LinearMap.id_apply,
        LinearMap.neg_apply] at happ
      have h0 := congrFun happ (0 : Fin 2)
      simpa [Pi.smul_apply, Pi.neg_apply, Pi.one_apply, smul_eq_mul, mul_one] using h0
    exact False.elim (no_sixth_root_neg_one hz6)
  · have hdeg2 : (minpoly k T).natDegree = 2 := by omega
    have heq : minpoly k T = (X : k[X]) ^ 2 + 1 :=
      monic_quad_dvd_X6_eq_X2_add_one _ hmon hdeg2 hmin_dvd
    have hae : aeval T ((X : k[X]) ^ 2 + 1) = 0 := by
      rw [← heq]; exact minpoly.aeval k T
    have hT2 : T ^ 2 + 1 = 0 := by
      simpa [map_add, map_pow, map_one, aeval_X, Algebra.algebraMap_eq_smul_one,
        Module.End.one_eq_id, one_smul] using hae
    have hR0_2 : R0 ^ 2 + 1 = 0 := by
      have : conjEnd eFun (R0 ^ 2 + 1) = T ^ 2 + 1 := by
        dsimp [T]
        rw [conjEnd_add, conjEnd_pow eFun R0 2, conjEnd_one]
      rw [hT2] at this
      exact (conjEnd_zero_iff eFun _).mp this
    have hval := LinearMap.congr_fun hR0_2 ⟨x, hx⟩
    have hsum : (R0 ^ 2) ⟨x, hx⟩ + ⟨x, hx⟩ = 0 := by
      simpa [LinearMap.add_apply, Module.End.one_eq_id] using hval
    have hcoe : (((R0 ^ 2) ⟨x, hx⟩ : P) : U) = Rlin (Rlin x) := by
      rw [show R0 ^ 2 = R0 * R0 from pow_two R0, Module.End.mul_apply]
      dsimp only [R0]
      rw [Rrestrict_apply P hR, Rrestrict_apply P hR]
    have hU := congrArg Subtype.val hsum
    rw [Submodule.coe_add, hcoe] at hU
    simpa using hU

theorem R_stable_plane_mem_residualKer
    (P : Submodule k U)
    (hdim : Module.finrank k P = 2)
    (hR : ∀ x ∈ P, Rlin x ∈ P) :
    ∀ x ∈ P, x ∈ residualKer := by
  intro x hx
  exact mem_residualKer_iff.mpr (R_stable_plane_residual P hdim hR x hx)

/-! ### N-fixed pure planes are residual -/

/-- `rotGen` acts on pure wedges by applying `Rlin` to both factors. -/
theorem ambientAct_rotGen_pure (u v : U) :
    ambientAct (CentralizerN.rotGen : PSL2F11) (pureWedge u v) =
      pureWedge (Rlin u) (Rlin v) := by
  dsimp [ambientAct, pureWedge, Rlin, CentralizerN.rotGen]
  change pslLambda2Hom (QuotientGroup.mk (CentralizerN.mkRot CentralizerN.rotPt))
      (exteriorPower.ιMulti k 2 ![u, v]) =
    exteriorPower.ιMulti k 2
      ![WeilHom.weilUHom (CentralizerN.mkRot CentralizerN.rotPt) u,
        WeilHom.weilUHom (CentralizerN.mkRot CentralizerN.rotPt) v]
  rw [pslLambda2_mk, weilLambda2, exteriorPower.map_apply_ιMulti]
  congr 1; funext i; fin_cases i <;> rfl

/-- Support plane of an R-character pure wedge is R-stable of rank 2. -/
theorem R_character_plane_stable {u v : U} {μ : k}
    (hI : LinearIndependent k ![u, v])
    (hμ : μ ≠ 0)
    (hRpure : pureWedge (Rlin u) (Rlin v) = μ • pureWedge u v) :
    let P := (k ∙ u) ⊔ (k ∙ v)
    Module.finrank k P = 2 ∧ ∀ x ∈ P, Rlin x ∈ P := by
  intro P
  have hRinj : Function.Injective Rlin := Rlin_injective
  have hRli : LinearIndependent k ![Rlin u, Rlin v] := by
    have hcomp : ![Rlin u, Rlin v] = ⇑Rlin ∘ ![u, v] := by
      funext i; fin_cases i <;> rfl
    rw [hcomp]
    exact hI.map' Rlin (LinearMap.ker_eq_bot_of_injective hRinj)
  have hplane : ((k ∙ Rlin u) ⊔ (k ∙ Rlin v) : Submodule k U) = P :=
    support_eq_of_parallel_pure hRli hI hμ hRpure
  refine ⟨finrank_span_pair hI, ?_⟩
  intro t ht
  have hRu : Rlin u ∈ P := by
    rw [← hplane]; exact Submodule.mem_sup_left (Submodule.mem_span_singleton_self _)
  have hRv : Rlin v ∈ P := by
    rw [← hplane]; exact Submodule.mem_sup_right (Submodule.mem_span_singleton_self _)
  obtain ⟨t1, ht1, t2, ht2, rfl⟩ := Submodule.mem_sup.mp ht
  obtain ⟨a, rfl⟩ := Submodule.mem_span_singleton.mp ht1
  obtain ⟨b, rfl⟩ := Submodule.mem_span_singleton.mp ht2
  rw [map_add, map_smul, map_smul]
  exact add_mem (Submodule.smul_mem _ a hRu) (Submodule.smul_mem _ b hRv)

/-- An R-character rank-2 pure wedge has residual support (R² = −id). -/
theorem R_character_plane_residual {u v : U} {μ : k}
    (hI : LinearIndependent k ![u, v])
    (hμ : μ ≠ 0)
    (hRpure : pureWedge (Rlin u) (Rlin v) = μ • pureWedge u v) :
    Rlin (Rlin u) + u = 0 ∧ Rlin (Rlin v) + v = 0 := by
  obtain ⟨hdim, hstab⟩ := R_character_plane_stable hI hμ hRpure
  have hu : u ∈ (k ∙ u) ⊔ (k ∙ v) :=
    Submodule.mem_sup_left (Submodule.mem_span_singleton_self _)
  have hv : v ∈ (k ∙ u) ⊔ (k ∙ v) :=
    Submodule.mem_sup_right (Submodule.mem_span_singleton_self _)
  exact ⟨R_stable_plane_residual _ hdim hstab u hu,
    R_stable_plane_residual _ hdim hstab v hv⟩

/-- Order of `rotGen` as an element of `PSL`. -/
theorem orderOf_rotGen_psl : orderOf (CentralizerN.rotGen : PSL2F11) = 6 := by
  have hpow : (CentralizerN.rotGen : PSL2F11) ^ 6 = 1 :=
    congrArg Subtype.val CentralizerN.rotGen_pow_six
  refine (orderOf_eq_iff (by decide : 0 < 6)).2 ⟨hpow, ?_⟩
  intro m hm6 hm0 hpowm
  have hsub : CentralizerN.rotGen ^ m = 1 := Subtype.ext hpowm
  have hdvd : orderOf CentralizerN.rotGen ∣ m := orderOf_dvd_of_pow_eq_one hsub
  rw [CentralizerN.orderOf_rotGen] at hdvd
  have hmle : m < 6 := hm6
  have : m = 0 := Nat.eq_zero_of_dvd_of_lt hdvd hmle
  exact absurd this (Nat.pos_iff_ne_zero.mp hm0)

theorem orderOf_sigma_eq_two : orderOf sigma = 2 := by
  refine (orderOf_eq_iff (by decide : 0 < 2)).2 ⟨sigma_isInvolution.left, ?_⟩
  intro m hm2 hm0
  match m with
  | 0 => exact absurd hm0 (Nat.lt_irrefl 0)
  | 1 => simpa [pow_one] using sigma_isInvolution.right
  | n + 2 => omega

theorem orderOf_reflGen_psl : orderOf (CentralizerN.reflGen : PSL2F11) = 2 := by
  have h2 : (CentralizerN.reflGen : PSL2F11) ^ 2 = 1 := by
    have h := congrArg Subtype.val CentralizerN.reflGen_mul_self
    -- ↑(refl * refl) = ↑1, and ↑(refl*refl) = ↑refl * ↑refl = ↑refl^2
    change (CentralizerN.reflGen : PSL2F11) * CentralizerN.reflGen = 1 at h
    rwa [← pow_two] at h
  refine (orderOf_eq_iff (by decide : 0 < 2)).2 ⟨h2, ?_⟩
  intro m hm2 hm0 hpow
  match m with
  | 0 => exact absurd hm0 (Nat.lt_irrefl 0)
  | 1 =>
    have hne : (CentralizerN.reflGen : PSL2F11) ≠ 1 := by
      intro heq
      have : CentralizerN.reflGen = 1 := Subtype.ext heq
      have hpow0 : CentralizerN.reflGen = CentralizerN.rotGen ^ 0 := by
        simpa [pow_zero] using this
      exact CentralizerN.reflGen_ne_rot_pow 0 hpow0
    exact hne (by simpa [pow_one] using hpow)
  | n + 2 => omega

/-- Sign-character inner product of `chi10'` on generators of `N ≃ D₁₂`.

Rotations contribute `10+2+1+1+(-1)+(-1)=12`; six reflections contribute
`6·2·(−1)=−12`; total `0`. (Full N-sum is 12⟨χ,sgn⟩; vanishing is the
writeup multiplicity-0 residual character.) -/
theorem chi10'_N_sign_inner_zero :
    (chi10' (1 : PSL2F11) : k) + chi10' sigma +
      chi10' ((CentralizerN.rotGen : PSL2F11) ^ 2) +
      chi10' ((CentralizerN.rotGen : PSL2F11) ^ 4) +
      chi10' (CentralizerN.rotGen : PSL2F11) +
      chi10' ((CentralizerN.rotGen : PSL2F11) ^ 5) +
      (6 : k) * (-chi10' (CentralizerN.reflGen : PSL2F11)) = 0 := by
  have hord6 := orderOf_rotGen_psl
  have hr2 : orderOf ((CentralizerN.rotGen : PSL2F11) ^ 2) = 3 := by
    have := orderOf_pow (x := (CentralizerN.rotGen : PSL2F11)) (n := 2)
    rw [hord6] at this
    simpa using this
  have hr4 : orderOf ((CentralizerN.rotGen : PSL2F11) ^ 4) = 3 := by
    have := orderOf_pow (x := (CentralizerN.rotGen : PSL2F11)) (n := 4)
    rw [hord6] at this
    simpa using this
  have hr5 : orderOf ((CentralizerN.rotGen : PSL2F11) ^ 5) = 6 := by
    have := orderOf_pow (x := (CentralizerN.rotGen : PSL2F11)) (n := 5)
    rw [hord6] at this
    simpa using this
  have hrefl := orderOf_reflGen_psl
  have c1 : chi10' (1 : PSL2F11) = 10 := chi10'_one
  have cσ : chi10' sigma = 2 := by simp [chi10', orderOf_sigma_eq_two]
  have cr : chi10' (CentralizerN.rotGen : PSL2F11) = -1 := by simp [chi10', hord6]
  have cr2 : chi10' ((CentralizerN.rotGen : PSL2F11) ^ 2) = 1 := by simp [chi10', hr2]
  have cr4 : chi10' ((CentralizerN.rotGen : PSL2F11) ^ 4) = 1 := by simp [chi10', hr4]
  have cr5 : chi10' ((CentralizerN.rotGen : PSL2F11) ^ 5) = -1 := by simp [chi10', hr5]
  have crefl : chi10' (CentralizerN.reflGen : PSL2F11) = 2 := by
    simp only [chi10', hrefl]
    norm_num
  rw [c1, cσ, cr, cr2, cr4, cr5, crefl]
  norm_num

/-- From an N-fixed pure-Gr point, the support plane is residual. -/
theorem N_fixed_pure_residual {u v : U}
    (hI : LinearIndependent k ![u, v])
    (hne : pureWedge u v ≠ 0)
    (hfix : actPM (CentralizerN.rotGen : PSL2F11)
      (Projectivization.mk k (pureWedge u v) hne) =
        Projectivization.mk k (pureWedge u v) hne) :
    Rlin (Rlin u) + u = 0 ∧ Rlin (Rlin v) + v = 0 := by
  have hcoe := hfix
  rw [actPM, Projectivization.map_mk, Projectivization.mk_eq_mk_iff] at hcoe
  obtain ⟨μ, hμ⟩ := hcoe
  -- hμ : μ • pure = ambientAct rotGen pure
  have hRpure : pureWedge (Rlin u) (Rlin v) = (μ : k) • pureWedge u v := by
    have hA := ambientAct_rotGen_pure u v
    exact hA.symm.trans hμ.symm
  exact R_character_plane_residual hI (Units.ne_zero μ) hRpure

/-- On a residual line, `R` has no eigenvalue in `K` (would force √−1 ∈ K). -/
theorem residual_no_eigenvalue {u : U} (hu0 : u ≠ 0)
    (hR2 : Rlin (Rlin u) + u = 0) :
    ¬ ∃ a : k, Rlin u = a • u := by
  intro ⟨a, ha⟩
  have hR2' : Rlin (Rlin u) = a ^ 2 • u := by
    rw [ha, map_smul, ha, smul_smul, pow_two]
  have hneg : a ^ 2 • u = -u := by
    have := hR2
    rw [hR2'] at this
    exact eq_neg_of_add_eq_zero_left this
  have hsum0 : (a ^ 2 + 1) • u = 0 := by
    calc (a ^ 2 + 1) • u = a ^ 2 • u + u := by rw [add_smul, one_smul]
      _ = -u + u := by rw [hneg]
      _ = 0 := by abel
  have ha2 : a ^ 2 = (-1 : k) := by
    have hcoef : a ^ 2 + 1 = 0 := (smul_eq_zero.mp hsum0).resolve_right hu0
    exact eq_neg_of_add_eq_zero_left hcoef
  exact not_isSquare_neg_one ⟨a, by simpa [pow_two, eq_comm] using ha2⟩

/-- `{u, Ru}` is a basis of a residual line through `u`. -/
public theorem residual_pair_independent {u : U} (hu0 : u ≠ 0)
    (hR2 : Rlin (Rlin u) + u = 0) :
    LinearIndependent k ![u, Rlin u] := by
  rw [LinearIndependent.pair_iff]
  intro a b hab
  have hb0 : b = 0 := by
    by_contra hb
    have h' : b⁻¹ • (a • u + b • Rlin u) = 0 := by rw [hab, smul_zero]
    simp only [smul_add, smul_smul] at h'
    have hsum : (b⁻¹ * a) • u + (b⁻¹ * b) • Rlin u = 0 := by simpa [smul_smul] using h'
    have hsum' : (b⁻¹ * a) • u + Rlin u = 0 := by
      rwa [inv_mul_cancel₀ hb, one_smul] at hsum
    have hsum'' : Rlin u + (b⁻¹ * a) • u = 0 := by rwa [add_comm] at hsum'
    have hneg : Rlin u = -((b⁻¹ * a) • u) := eq_neg_of_add_eq_zero_left hsum''
    have hneg' : Rlin u = (-(b⁻¹ * a)) • u :=
      hneg.trans (neg_smul (b⁻¹ * a) u).symm
    exact residual_no_eigenvalue hu0 hR2 ⟨_, hneg'⟩
  subst hb0
  simp only [zero_smul, add_zero] at hab
  exact ⟨(smul_eq_zero.mp hab).resolve_right hu0, rfl⟩

/-- Residual pure wedge is fixed by `rotGen` with det +1: `Ru ∧ R²u = u ∧ Ru`. -/
theorem residual_plucker_rotGen_det_one {u : U} (_hu0 : u ≠ 0)
    (hR2 : Rlin (Rlin u) + u = 0) :
    pureWedge (Rlin u) (Rlin (Rlin u)) = pureWedge u (Rlin u) := by
  have hR2u : Rlin (Rlin u) = -u := eq_neg_of_add_eq_zero_left hR2
  have hneg : (-u : U) = (-1 : k) • u := (neg_one_smul k u).symm
  calc pureWedge (Rlin u) (Rlin (Rlin u))
      = pureWedge (Rlin u) (-u) := by rw [hR2u]
    _ = pureWedge (Rlin u) ((-1 : k) • u) := by rw [hneg]
    _ = (-1 : k) • pureWedge (Rlin u) u := pureWedge_smul_right _ _ _
    _ = -pureWedge (Rlin u) u := by rw [neg_one_smul]
    _ = -(-pureWedge u (Rlin u)) := by rw [pureWedge_swap]
    _ = pureWedge u (Rlin u) := by rw [neg_neg]


/-! ### Reflection Weil operator

`S = Weil(mkRefl)`, `S² = -id` on `U`. Full residual-Plücker sign/character
packaging uses `S R = -R S` on residualKer (from SL conjugacy) — in progress.
-/

public abbrev Slin : U →ₗ[k] U :=
  WeilHom.weilUHom (CentralizerN.mkRefl CentralizerN.reflPt)

theorem Slin_sq : (Slin ∘ₗ Slin : U →ₗ[k] U) = -LinearMap.id := by
  have h : CentralizerN.mkRefl CentralizerN.reflPt ^ 2 = CentralizerN.negI :=
    CentralizerN.mkRefl_pow_two
  have hneg : CentralizerN.negI = WeilRepSL2.negI := by
    apply Subtype.ext
    ext i j
    fin_cases i <;> fin_cases j <;>
      simp [CentralizerN.negI, WeilRepSL2.negI, Matrix.neg_apply]
  calc Slin ∘ₗ Slin
      = WeilHom.weilUHom
          (CentralizerN.mkRefl CentralizerN.reflPt *
            CentralizerN.mkRefl CentralizerN.reflPt) :=
        (WeilHom.weilU_mul _ _).symm
    _ = WeilHom.weilUHom (CentralizerN.mkRefl CentralizerN.reflPt ^ 2) := by
        rw [pow_two]
    _ = WeilHom.weilUHom CentralizerN.negI := by rw [h]
    _ = WeilHom.weilUHom WeilRepSL2.negI := by rw [hneg]
    _ = -LinearMap.id := by
        change WeilRepSL2.weilU WeilRepSL2.negI = -LinearMap.id
        exact WeilRepSL2.weilU_negI

theorem ambientAct_reflGen_pure (u v : U) :
    ambientAct (CentralizerN.reflGen : PSL2F11) (pureWedge u v) =
      pureWedge (Slin u) (Slin v) := by
  dsimp [ambientAct, pureWedge, Slin, CentralizerN.reflGen]
  change pslLambda2Hom (QuotientGroup.mk (CentralizerN.mkRefl CentralizerN.reflPt))
      (exteriorPower.ιMulti k 2 ![u, v]) =
    exteriorPower.ιMulti k 2
      ![WeilHom.weilUHom (CentralizerN.mkRefl CentralizerN.reflPt) u,
        WeilHom.weilUHom (CentralizerN.mkRefl CentralizerN.reflPt) v]
  rw [pslLambda2_mk, weilLambda2, exteriorPower.map_apply_ιMulti]
  congr 1; funext i; fin_cases i <;> rfl

/-- `Slin` left-inverse is `-Slin`. -/
theorem Slin_comp_neg_Slin : Slin ∘ₗ (-Slin) = LinearMap.id := by
  apply LinearMap.ext
  intro x
  have h : Slin (Slin x) = -x := by
    simpa [LinearMap.comp_apply] using LinearMap.congr_fun Slin_sq x
  calc (Slin ∘ₗ (-Slin)) x
      = Slin (-Slin x) := rfl
    _ = -Slin (Slin x) := map_neg Slin _
    _ = -(-x) := by rw [h]
    _ = x := neg_neg x

/-- From `mkRefl_conj_mkRot`: `S * R * S = negI * R⁻¹` in SL, and
`R⁻¹ = R⁵ * negI` (since `R⁶ = negI`), so `S R S = R⁵` after central
cancellation, hence `Slin ∘ Rlin ∘ Slin = Rlin^5` on `U`. -/
theorem Slin_Rlin_Slin_eq_R5 :
    Slin ∘ₗ Rlin ∘ₗ Slin = (Rlin ^ 5 : Module.End k U) := by
  have hconj := CentralizerN.mkRefl_conj_mkRot
  have hL : Slin ∘ₗ Rlin ∘ₗ Slin =
      WeilHom.weilUHom
        (CentralizerN.mkRefl CentralizerN.reflPt *
          CentralizerN.mkRot CentralizerN.rotPt *
          CentralizerN.mkRefl CentralizerN.reflPt) := by
    have hRS : Rlin ∘ₗ Slin =
        WeilHom.weilUHom (CentralizerN.mkRot CentralizerN.rotPt *
          CentralizerN.mkRefl CentralizerN.reflPt) :=
      (WeilHom.weilU_mul _ _).symm
    calc Slin ∘ₗ Rlin ∘ₗ Slin
        = Slin ∘ₗ (Rlin ∘ₗ Slin) := by ext; rfl
      _ = Slin ∘ₗ WeilHom.weilUHom (CentralizerN.mkRot CentralizerN.rotPt *
            CentralizerN.mkRefl CentralizerN.reflPt) := by rw [hRS]
      _ = WeilHom.weilUHom (CentralizerN.mkRefl CentralizerN.reflPt *
            (CentralizerN.mkRot CentralizerN.rotPt *
              CentralizerN.mkRefl CentralizerN.reflPt)) :=
          (WeilHom.weilU_mul _ _).symm
      _ = WeilHom.weilUHom
            (CentralizerN.mkRefl CentralizerN.reflPt *
              CentralizerN.mkRot CentralizerN.rotPt *
              CentralizerN.mkRefl CentralizerN.reflPt) := by
          congr 1; simp only [mul_assoc]
  rw [hL, hconj]
  have h6 : CentralizerN.mkRot CentralizerN.rotPt ^ 6 = CentralizerN.negI :=
    CentralizerN.mkRot_pow_six
  have hRot_inv : (CentralizerN.mkRot CentralizerN.rotPt)⁻¹ =
      CentralizerN.mkRot CentralizerN.rotPt ^ 5 * CentralizerN.negI := by
    apply inv_eq_iff_mul_eq_one.mpr
    calc CentralizerN.mkRot CentralizerN.rotPt *
          (CentralizerN.mkRot CentralizerN.rotPt ^ 5 * CentralizerN.negI)
        = (CentralizerN.mkRot CentralizerN.rotPt ^ 6) * CentralizerN.negI := by
          rw [← mul_assoc, ← pow_succ']
      _ = CentralizerN.negI * CentralizerN.negI := by rw [h6]
      _ = 1 := by
          apply Subtype.ext
          ext i j
          fin_cases i <;> fin_cases j <;>
            simp [CentralizerN.negI, Matrix.neg_apply]
  rw [hRot_inv]
  have hcent : CentralizerN.negI ∈ Subgroup.center
      (SpecialLinearGroup (Fin 2) (ZMod 11)) := CentralizerN.negI_mem_center
  have hcomm := (Subgroup.mem_center_iff.mp hcent)
    (CentralizerN.mkRot CentralizerN.rotPt ^ 5)
  have hrew : CentralizerN.negI *
      (CentralizerN.mkRot CentralizerN.rotPt ^ 5 * CentralizerN.negI) =
        CentralizerN.mkRot CentralizerN.rotPt ^ 5 := by
    calc CentralizerN.negI *
          (CentralizerN.mkRot CentralizerN.rotPt ^ 5 * CentralizerN.negI)
        = (CentralizerN.negI * CentralizerN.mkRot CentralizerN.rotPt ^ 5) *
            CentralizerN.negI := by rw [mul_assoc]
      _ = (CentralizerN.mkRot CentralizerN.rotPt ^ 5 * CentralizerN.negI) *
            CentralizerN.negI := by rw [hcomm]
      _ = CentralizerN.mkRot CentralizerN.rotPt ^ 5 *
            (CentralizerN.negI * CentralizerN.negI) := by rw [mul_assoc]
      _ = CentralizerN.mkRot CentralizerN.rotPt ^ 5 * 1 := by
          congr 1
          apply Subtype.ext
          ext i j
          fin_cases i <;> fin_cases j <;>
            simp [CentralizerN.negI, Matrix.neg_apply]
      _ = CentralizerN.mkRot CentralizerN.rotPt ^ 5 := mul_one _
  rw [hrew, map_pow]


/-- `S R = -R⁵ S` as endomorphisms. -/
theorem Slin_comp_Rlin_eq :
    Slin ∘ₗ Rlin = -((Rlin ^ 5 : Module.End k U) ∘ₗ Slin) := by
  calc Slin ∘ₗ Rlin
      = Slin ∘ₗ Rlin ∘ₗ LinearMap.id := by
          apply LinearMap.ext; intro; simp [LinearMap.comp_apply]
    _ = Slin ∘ₗ Rlin ∘ₗ (Slin ∘ₗ (-Slin)) := by rw [Slin_comp_neg_Slin]
    _ = (Slin ∘ₗ Rlin ∘ₗ Slin) ∘ₗ (-Slin) := by
          apply LinearMap.ext; intro; simp only [LinearMap.comp_apply]
    _ = (Rlin ^ 5 : Module.End k U) ∘ₗ (-Slin) := by rw [Slin_Rlin_Slin_eq_R5]
    _ = -((Rlin ^ 5 : Module.End k U) ∘ₗ Slin) := by
          apply LinearMap.ext; intro; simp [LinearMap.comp_apply]

/-- On residual vectors, `R⁵ = R`. -/
theorem Rlin_pow_five_of_residual {u : U} (hR2 : Rlin (Rlin u) + u = 0) :
    (Rlin ^ 5 : Module.End k U) u = Rlin u := by
  have hR2u : Rlin (Rlin u) = -u := eq_neg_of_add_eq_zero_left hR2
  have h4 : (Rlin ^ 4 : Module.End k U) u = u := by
    have h2 : (Rlin ^ 2 : Module.End k U) u = -u := hR2u
    have hpow : (Rlin ^ 4 : Module.End k U) =
        (Rlin ^ 2 : Module.End k U) * (Rlin ^ 2 : Module.End k U) :=
      (pow_add Rlin 2 2).symm
    rw [hpow, Module.End.mul_apply, h2, map_neg, h2, neg_neg]
  have hpow5 : (Rlin ^ 5 : Module.End k U) =
      (Rlin : Module.End k U) * (Rlin ^ 4 : Module.End k U) := by
    have h : (5 : ℕ) = 1 + 4 := by norm_num
    rw [h, pow_add, pow_one]
  rw [hpow5, Module.End.mul_apply, h4]

/-- `S` preserves `residualKer`. -/
theorem Slin_mem_residualKer {u : U} (hu : u ∈ residualKer) :
    Slin u ∈ residualKer := by
  rw [mem_residualKer_iff] at hu ⊢
  have hR2u : Rlin (Rlin u) = -u := eq_neg_of_add_eq_zero_left hu
  have h2 : (Rlin ^ 2 : Module.End k U) u = -u := hR2u
  have h4 : (Rlin ^ 4 : Module.End k U) u = u := by
    have hpow : (Rlin ^ 4 : Module.End k U) =
        (Rlin ^ 2 : Module.End k U) * (Rlin ^ 2 : Module.End k U) :=
      (pow_add Rlin 2 2).symm
    rw [hpow, Module.End.mul_apply, h2, map_neg, h2, neg_neg]
  have h10 : (Rlin ^ 10 : Module.End k U) u = -u := by
    have h64 : (10 : ℕ) = 6 + 4 := by decide
    calc (Rlin ^ 10 : Module.End k U) u
        = ((Rlin ^ 6 : Module.End k U) * (Rlin ^ 4 : Module.End k U)) u := by
          rw [h64, pow_add]
      _ = (Rlin ^ 6 : Module.End k U) ((Rlin ^ 4 : Module.End k U) u) :=
          Module.End.mul_apply _ _ _
      _ = (Rlin ^ 6 : Module.End k U) u := by rw [h4]
      _ = -u := LinearMap.congr_fun Rlin_pow_six_eq_neg_id u
  have hS_R2_S : Slin (Rlin (Rlin (Slin u))) =
      -((Rlin ^ 10 : Module.End k U) u) := by
    have hy : Slin (Rlin (Rlin (Slin u))) =
        -((Rlin ^ 5 : Module.End k U) (Slin (Rlin (Slin u)))) := by
      have := LinearMap.congr_fun Slin_comp_Rlin_eq (Rlin (Slin u))
      simpa [LinearMap.comp_apply] using this
    have hx : Slin (Rlin (Slin u)) = (Rlin ^ 5 : Module.End k U) u :=
      LinearMap.congr_fun Slin_Rlin_Slin_eq_R5 u
    rw [hy, hx]
    have h55 : (Rlin ^ 5 : Module.End k U) ((Rlin ^ 5 : Module.End k U) u) =
        (Rlin ^ 10 : Module.End k U) u := by
      have h55n : (10 : ℕ) = 5 + 5 := by decide
      calc (Rlin ^ 5 : Module.End k U) ((Rlin ^ 5 : Module.End k U) u)
          = ((Rlin ^ 5 : Module.End k U) * (Rlin ^ 5 : Module.End k U)) u :=
            (Module.End.mul_apply _ _ _).symm
        _ = (Rlin ^ 10 : Module.End k U) u := by rw [h55n, pow_add]
    rw [h55]
  have hSRSu : Slin (Rlin (Rlin (Slin u))) = u := by
    rw [hS_R2_S, h10, neg_neg]
  have hSS : Slin (Slin (Rlin (Rlin (Slin u)))) = Slin u := by rw [hSRSu]
  have hneg : (-LinearMap.id : U →ₗ[k] U) (Rlin (Rlin (Slin u))) = Slin u := by
    have : (Slin ∘ₗ Slin) (Rlin (Rlin (Slin u))) = Slin u := hSS
    rwa [Slin_sq] at this
  have hR2Su : Rlin (Rlin (Slin u)) = -Slin u := by
    have h' : -(Rlin (Rlin (Slin u))) = Slin u := by
      change (-LinearMap.id : U →ₗ[k] U) (Rlin (Rlin (Slin u))) = Slin u at hneg
      simpa only [LinearMap.neg_apply, LinearMap.id_apply] using hneg
    exact neg_eq_iff_eq_neg.mp h'
  calc Rlin (Rlin (Slin u)) + Slin u
      = -Slin u + Slin u := by rw [hR2Su]
    _ = 0 := by abel

/-- On residual vectors, `S R = -R S`. -/
theorem Slin_Rlin_anticomm {u : U} (hu : u ∈ residualKer) :
    Slin (Rlin u) = -Rlin (Slin u) := by
  have h := LinearMap.congr_fun Slin_comp_Rlin_eq u
  have h1 : Slin (Rlin u) = -((Rlin ^ 5 : Module.End k U) (Slin u)) := by
    simpa [LinearMap.comp_apply] using h
  have hSu : Slin u ∈ residualKer := Slin_mem_residualKer hu
  have hR5 : (Rlin ^ 5 : Module.End k U) (Slin u) = Rlin (Slin u) :=
    Rlin_pow_five_of_residual (mem_residualKer_iff.mp hSu)
  rw [h1, hR5]

/-- Residual Plücker is fixed by `reflGen` on an `S`-stable residual plane.

`Su = a u + b Ru`, anticommutation gives `R Su = -b u + a Ru`, and
`pureWedge_linear_combo` yields `Su ∧ R Su = (a²+b²)(u∧Ru)`.  From
`S² = -id` one has `a²+b² = -1`, so
`ambientAct(s)(u∧Ru) = Su ∧ S(Ru) = Su ∧ (-R Su) = -(Su ∧ R Su) = u∧Ru`.
-/
theorem residual_plucker_reflGen_of_S_stable {u : U} (hu0 : u ≠ 0)
    (hR2 : Rlin (Rlin u) + u = 0)
    (hSstab : Slin u ∈ (k ∙ u) ⊔ (k ∙ Rlin u)) :
    ambientAct (CentralizerN.reflGen : PSL2F11) (pureWedge u (Rlin u)) =
      pureWedge u (Rlin u) := by
  have huK : u ∈ residualKer := mem_residualKer_iff.mpr hR2
  have hanti := Slin_Rlin_anticomm huK
  rw [ambientAct_reflGen_pure, hanti]
  -- Su ∧ (-R Su) = - (Su ∧ R Su)
  have hsmul : pureWedge (Slin u) (-Rlin (Slin u)) =
      -pureWedge (Slin u) (Rlin (Slin u)) := by
    have : (-Rlin (Slin u) : U) = (-1 : k) • Rlin (Slin u) :=
      (neg_one_smul k _).symm
    rw [this, pureWedge_smul_right, neg_one_smul]
  rw [hsmul]
  obtain ⟨t1, ht1, t2, ht2, hsum⟩ := Submodule.mem_sup.mp hSstab
  obtain ⟨a, ha⟩ := Submodule.mem_span_singleton.mp ht1
  obtain ⟨b, hb⟩ := Submodule.mem_span_singleton.mp ht2
  have hSu : Slin u = a • u + b • Rlin u := by
    rw [← hsum, ha, hb]
  have hR2u : Rlin (Rlin u) = -u := eq_neg_of_add_eq_zero_left hR2
  -- R(Su) = a Ru + b R²u = a Ru - b u
  have hRSu : Rlin (Slin u) = (-b) • u + a • Rlin u := by
    calc Rlin (Slin u)
        = Rlin (a • u + b • Rlin u) := by rw [hSu]
      _ = a • Rlin u + b • Rlin (Rlin u) := by rw [map_add, map_smul, map_smul]
      _ = a • Rlin u + b • (-u) := by rw [hR2u]
      _ = a • Rlin u + (-b) • u := by
          rw [smul_neg, ← neg_smul]
      _ = (-b) • u + a • Rlin u := by abel
  -- Rewrite first arg then second (order matters: do not rewrite under Rlin)
  have hwedge : pureWedge (Slin u) (Rlin (Slin u)) =
      (a * a + b * b) • pureWedge u (Rlin u) := by
    calc pureWedge (Slin u) (Rlin (Slin u))
        = pureWedge (a • u + b • Rlin u) (Rlin (Slin u)) := by rw [hSu]
      _ = pureWedge (a • u + b • Rlin u) ((-b) • u + a • Rlin u) := by rw [hRSu]
      _ = (a * a - b * (-b)) • pureWedge u (Rlin u) :=
          pureWedge_linear_combo a b (-b) a u (Rlin u)
      _ = (a * a + b * b) • pureWedge u (Rlin u) := by
          congr 1
          ring
  have hS2u : Slin (Slin u) = -u := by
    simpa [LinearMap.comp_apply] using LinearMap.congr_fun Slin_sq u
  -- S²u = a Su + b S Ru = a Su - b R Su = (a²+b²)u
  have hcoef : (a * a + b * b) • u = -u := by
    -- S(Su) = S(a u + b Ru) = a Su + b S(Ru)
    have step1 : Slin (Slin u) = a • Slin u + b • Slin (Rlin u) := by
      calc Slin (Slin u)
          = Slin (a • u + b • Rlin u) := by rw [hSu]
        _ = a • Slin u + b • Slin (Rlin u) := by
            rw [map_add, map_smul, map_smul]
    -- a Su + b S(Ru) = a(a u + b Ru) + b(-R Su)   [anticomm]
    have step2 : a • Slin u + b • Slin (Rlin u) =
        a • (a • u + b • Rlin u) + b • (-Rlin (Slin u)) := by
      have h1 : a • Slin u = a • (a • u + b • Rlin u) := by rw [hSu]
      have h2 : b • Slin (Rlin u) = b • (-Rlin (Slin u)) := by rw [hanti]
      rw [h1, h2]
    -- -R Su = -((-b)u + a Ru) = b u + (-a) Ru
    -- Note: Mathlib `neg_smul` is `(-r)•x = -(r•x)`, so use `.symm`.
    have hneg_sum : -((-b) • u + a • Rlin u) = b • u + (-a) • Rlin u := by
      have h1 : -((-b) • u) = b • u := by
        calc -((-b) • u)
            = (-(-b)) • u := (neg_smul (-b) u).symm
          _ = b • u := by rw [neg_neg]
      have h2 : -(a • Rlin u) = (-a) • Rlin u := (neg_smul a (Rlin u)).symm
      rw [neg_add, h1, h2]
    have hRSu_neg : -Rlin (Slin u) = -((-b) • u + a • Rlin u) := by rw [hRSu]
    -- Expand scalar combination to (a²+b²)u
    have step4 : a • (a • u + b • Rlin u) + b • (-((-b) • u + a • Rlin u)) =
        (a * a + b * b) • u := by
      rw [hneg_sum]
      -- a•(a•u+b•Ru) + b•(b•u+(-a)•Ru)
      have hexp :
          a • (a • u + b • Rlin u) + b • (b • u + (-a) • Rlin u) =
            (a * a) • u + (a * b) • Rlin u + ((b * b) • u + (-(b * a)) • Rlin u) := by
        have hL : a • (a • u + b • Rlin u) = (a * a) • u + (a * b) • Rlin u := by
          rw [smul_add, smul_smul, smul_smul]
        have hR : b • (b • u + (-a) • Rlin u) =
            (b * b) • u + (-(b * a)) • Rlin u := by
          rw [smul_add, smul_smul, smul_smul, mul_neg]
        rw [hL, hR]
      have hcross : (a * b) • Rlin u + (-(b * a)) • Rlin u = (0 : U) := by
        rw [mul_comm b a, ← add_smul, add_neg_cancel, zero_smul]
      rw [hexp]
      -- reassociate then cancel cross terms
      calc (a * a) • u + (a * b) • Rlin u + ((b * b) • u + (-(b * a)) • Rlin u)
          = (a * a) • u + (b * b) • u +
              ((a * b) • Rlin u + (-(b * a)) • Rlin u) := by abel
        _ = (a * a) • u + (b * b) • u + 0 := by rw [hcross]
        _ = (a * a) • u + (b * b) • u := by rw [add_zero]
        _ = (a * a + b * b) • u := by rw [← add_smul]
    calc (a * a + b * b) • u
        = a • (a • u + b • Rlin u) + b • (-((-b) • u + a • Rlin u)) := step4.symm
      _ = a • (a • u + b • Rlin u) + b • (-Rlin (Slin u)) := by rw [← hRSu_neg]
      _ = a • Slin u + b • Slin (Rlin u) := step2.symm
      _ = Slin (Slin u) := step1.symm
      _ = -u := hS2u
  have hab : a * a + b * b = (-1 : k) := by
    have hsum0 : (a * a + b * b + 1) • u = 0 := by
      calc (a * a + b * b + 1) • u
          = (a * a + b * b) • u + u := by rw [add_smul, one_smul]
        _ = -u + u := by rw [hcoef]
        _ = 0 := by abel
    exact eq_neg_of_add_eq_zero_left
      ((smul_eq_zero.mp hsum0).resolve_right hu0)
  rw [hwedge, hab]
  simp only [neg_smul, one_smul, neg_neg]

/-- Residual Plücker is fixed by both generators of `N` (trivial N-character)
when the residual plane is `S`-stable.

Requires `hne : pureWedge ≠ 0` (follows from `residual_pair_independent` once
the independent-pair ⇒ nonzero-wedge lemma is packaged; held as a hypothesis
here to avoid a heavy exterior dual argument). -/
theorem residual_plucker_N_fixed_of_S_stable {u : U} (hu0 : u ≠ 0)
    (hR2 : Rlin (Rlin u) + u = 0)
    (hSstab : Slin u ∈ (k ∙ u) ⊔ (k ∙ Rlin u))
    (hne : pureWedge u (Rlin u) ≠ 0) :
    actPM (CentralizerN.rotGen : PSL2F11)
        (Projectivization.mk k (pureWedge u (Rlin u)) hne) =
      Projectivization.mk k (pureWedge u (Rlin u)) hne ∧
    actPM (CentralizerN.reflGen : PSL2F11)
        (Projectivization.mk k (pureWedge u (Rlin u)) hne) =
      Projectivization.mk k (pureWedge u (Rlin u)) hne := by
  constructor
  · -- rotGen fixes the pure wedge by det +1
    have hA := ambientAct_rotGen_pure u (Rlin u)
    have hR2u : Rlin (Rlin u) = -u := eq_neg_of_add_eq_zero_left hR2
    have hfix_vec :
        ambientAct (CentralizerN.rotGen : PSL2F11) (pureWedge u (Rlin u)) =
          pureWedge u (Rlin u) := by
      calc ambientAct (CentralizerN.rotGen : PSL2F11) (pureWedge u (Rlin u))
          = pureWedge (Rlin u) (Rlin (Rlin u)) := hA
        _ = pureWedge (Rlin u) (-u) := by rw [hR2u]
        _ = pureWedge u (Rlin u) := by
            have : pureWedge (Rlin u) (-u) = -pureWedge (Rlin u) u := by
              have hsm : (-u : U) = (-1 : k) • u := (neg_one_smul k u).symm
              rw [hsm, pureWedge_smul_right, neg_one_smul]
            rw [this, pureWedge_swap, neg_neg]
    rw [actPM, Projectivization.map_mk, Projectivization.mk_eq_mk_iff]
    refine ⟨1, ?_⟩
    simpa [Units.val_one, one_smul] using hfix_vec.symm
  · have hfix := residual_plucker_reflGen_of_S_stable hu0 hR2 hSstab
    rw [actPM, Projectivization.map_mk, Projectivization.mk_eq_mk_iff]
    refine ⟨1, ?_⟩
    simpa [Units.val_one, one_smul] using hfix.symm

/-- Trivial-character inner product of `chi10'` on generators of `N ≃ D₁₂`.

Identity contributes 10; the order-2 rotation `σ` and six reflections contribute
`2` each (`7·2=14`); two order-3 rotations contribute `1` each; two order-6
rotations contribute `-1` each. Total `10+14+2-2=24`, so
`⟨χ₁₀', 1⟩_N = 24/12 = 2` (writeup dim of the trivial piece of `M|_N`). -/
theorem chi10'_N_trivial_inner_two :
    (chi10' (1 : PSL2F11) : k) + chi10' sigma +
      chi10' ((CentralizerN.rotGen : PSL2F11) ^ 2) +
      chi10' ((CentralizerN.rotGen : PSL2F11) ^ 4) +
      chi10' (CentralizerN.rotGen : PSL2F11) +
      chi10' ((CentralizerN.rotGen : PSL2F11) ^ 5) +
      (6 : k) * chi10' (CentralizerN.reflGen : PSL2F11) = 24 := by
  have hord6 := orderOf_rotGen_psl
  have hr2 : orderOf ((CentralizerN.rotGen : PSL2F11) ^ 2) = 3 := by
    have := orderOf_pow (x := (CentralizerN.rotGen : PSL2F11)) (n := 2)
    rw [hord6] at this
    simpa using this
  have hr4 : orderOf ((CentralizerN.rotGen : PSL2F11) ^ 4) = 3 := by
    have := orderOf_pow (x := (CentralizerN.rotGen : PSL2F11)) (n := 4)
    rw [hord6] at this
    simpa using this
  have hr5 : orderOf ((CentralizerN.rotGen : PSL2F11) ^ 5) = 6 := by
    have := orderOf_pow (x := (CentralizerN.rotGen : PSL2F11)) (n := 5)
    rw [hord6] at this
    simpa using this
  have hrefl := orderOf_reflGen_psl
  have c1 : chi10' (1 : PSL2F11) = 10 := chi10'_one
  have cσ : chi10' sigma = 2 := by simp [chi10', orderOf_sigma_eq_two]
  have cr : chi10' (CentralizerN.rotGen : PSL2F11) = -1 := by simp [chi10', hord6]
  have cr2 : chi10' ((CentralizerN.rotGen : PSL2F11) ^ 2) = 1 := by simp [chi10', hr2]
  have cr4 : chi10' ((CentralizerN.rotGen : PSL2F11) ^ 4) = 1 := by simp [chi10', hr4]
  have cr5 : chi10' ((CentralizerN.rotGen : PSL2F11) ^ 5) = -1 := by simp [chi10', hr5]
  have crefl : chi10' (CentralizerN.reflGen : PSL2F11) = 2 := by
    simp only [chi10', hrefl]
    norm_num
  rw [c1, cσ, cr, cr2, cr4, cr5, crefl]
  norm_num

/-! ## Residual Plücker vector N-fixation and projector coefficient lemmas -/

/-- `4/11 ≠ 1` in `k` (char 0). -/
theorem four_div_eleven_ne_one : (4 : k) * (11 : k)⁻¹ ≠ 1 := by
  intro h
  have h11 : (11 : k) ≠ 0 := by norm_num
  have := congrArg (fun x : k => x * 11) h
  simp only [mul_assoc, inv_mul_cancel₀ h11, mul_one, one_mul] at this
  exact absurd this (by norm_num : (4 : k) ≠ 11)

theorem ten_div_sixsixty_mul_twentyfour :
    (10 * (660 : k)⁻¹) * 24 = (4 : k) * (11 : k)⁻¹ := by
  have h660 : (660 : k) = 60 * 11 := by norm_num
  have h240 : (10 : k) * 24 = 240 := by norm_num
  have h60 : (240 : k) = 4 * 60 := by norm_num
  have h60ne : (60 : k) ≠ 0 := by norm_num
  calc (10 * (660 : k)⁻¹) * 24
      = (10 * 24) * (660 : k)⁻¹ := by ring
    _ = 240 * (660 : k)⁻¹ := by rw [h240]
    _ = 240 * (60 * 11 : k)⁻¹ := by rw [h660]
    _ = 240 * ((60 : k)⁻¹ * (11 : k)⁻¹) := by rw [mul_inv]
    _ = (4 * 60) * ((60 : k)⁻¹ * (11 : k)⁻¹) := by rw [h60]
    _ = 4 * (60 * (60 : k)⁻¹) * (11 : k)⁻¹ := by ring
    _ = 4 * (1 : k) * (11 : k)⁻¹ := by rw [mul_inv_cancel₀ h60ne]
    _ = (4 : k) * (11 : k)⁻¹ := by ring

/-- Residual pure wedge is fixed (as a vector) by `rotGen` and `reflGen`. -/
public theorem residual_plucker_N_vec_fixed {u : U} (hu0 : u ≠ 0)
    (hR2 : Rlin (Rlin u) + u = 0)
    (hSstab : Slin u ∈ (k ∙ u) ⊔ (k ∙ Rlin u)) :
    ambientAct (CentralizerN.rotGen : PSL2F11) (pureWedge u (Rlin u)) =
      pureWedge u (Rlin u) ∧
    ambientAct (CentralizerN.reflGen : PSL2F11) (pureWedge u (Rlin u)) =
      pureWedge u (Rlin u) := by
  constructor
  · have hA := ambientAct_rotGen_pure u (Rlin u)
    have hR2u : Rlin (Rlin u) = -u := eq_neg_of_add_eq_zero_left hR2
    calc ambientAct (CentralizerN.rotGen : PSL2F11) (pureWedge u (Rlin u))
        = pureWedge (Rlin u) (Rlin (Rlin u)) := hA
      _ = pureWedge (Rlin u) (-u) := by rw [hR2u]
      _ = pureWedge u (Rlin u) := by
          have : pureWedge (Rlin u) (-u) = -pureWedge (Rlin u) u := by
            have hsm : (-u : U) = (-1 : k) • u := (neg_one_smul k u).symm
            rw [hsm, pureWedge_smul_right, neg_one_smul]
          rw [this, pureWedge_swap, neg_neg]
  · exact residual_plucker_reflGen_of_S_stable hu0 hR2 hSstab

/-- `ambientAct` of `rotGen ^ 2` is not the identity (order-3 element acts nontrivially).

Used to show `residualKer ≠ U`: if `R² = -id` on all of `U` then
`ambientAct(rotGen²) = id` on `Λ²U`, contradicting faithfulness of the PSL action
on `Λ²U` once `rotGen² ≠ 1`. -/
theorem ambientAct_rotGen_pow_two_ne_id :
    ambientAct ((CentralizerN.rotGen : PSL2F11) ^ 2) ≠ LinearMap.id := by
  intro h
  -- rotGen^2 has order 3
  have hord6 := orderOf_rotGen_psl
  have hr2 : orderOf ((CentralizerN.rotGen : PSL2F11) ^ 2) = 3 := by
    have := orderOf_pow (x := (CentralizerN.rotGen : PSL2F11)) (n := 2)
    rw [hord6] at this
    simpa using this
  have hne : (CentralizerN.rotGen : PSL2F11) ^ 2 ≠ 1 := by
    intro heq
    have : orderOf ((CentralizerN.rotGen : PSL2F11) ^ 2) ∣ 1 :=
      orderOf_dvd_of_pow_eq_one (by simpa using heq)
    rw [hr2] at this
    exact absurd this (by decide : ¬(3 ∣ 1))
  -- ambientAct faithful on image of PSL: ker is normal, G simple, not all of G
  -- Use that ambientAct(rotGen^2)=id and actV14_faithful-style argument on pure wedges.
  -- From h: ambientAct(rotGen^2) = id, so for all pure wedges, fixed.
  -- In particular actPM (rotGen^2) = id on PP(Λ²U).
  have hact : ∀ p : ℙ k Lambda2U, actPM ((CentralizerN.rotGen : PSL2F11) ^ 2) p = p := by
    intro p
    induction p using Projectivization.ind with
    | h v hv =>
      dsimp [actPM]
      rw [Projectivization.map_mk]
      have hA : ambientAct ((CentralizerN.rotGen : PSL2F11) ^ 2) v = v := by
        rw [h, LinearMap.id_apply]
      exact (Projectivization.mk_eq_mk_iff' k _ v (by rw [hA]; exact hv) hv).mpr
        ⟨1, by rw [one_smul, hA]⟩
  -- Now use a point moved by rotGen^2 if one exists; from pure Gr faithfulness
  -- actV14_faithful says if g fixes all V14Points then g=1.
  have hfix_all : ∀ x : V14Point, actV14 ((CentralizerN.rotGen : PSL2F11) ^ 2) x = x := by
    intro x
    apply Subtype.ext
    exact hact x.1
  exact hne (actV14_faithful _ hfix_all)

/-- `residualKer ≠ U`: otherwise `R² = -id` on `U`, so `ambientAct(rotGen²) = id`. -/
theorem residualKer_ne_top : residualKer ≠ (⊤ : Submodule k U) := by
  intro htop
  have hR2 : ∀ u : U, Rlin (Rlin u) + u = 0 := by
    intro u
    have : u ∈ residualKer := by rw [htop]; trivial
    exact (mem_residualKer_iff).mp this
  have hR2eq : (Rlin ∘ₗ Rlin : Module.End k U) = -LinearMap.id := by
    apply LinearMap.ext
    intro u
    exact eq_neg_of_add_eq_zero_left (hR2 u)
  have hA :
      ambientAct ((CentralizerN.rotGen : PSL2F11) ^ 2) = LinearMap.id := by
    have hmk : (CentralizerN.rotGen : PSL2F11) =
        QuotientGroup.mk (CentralizerN.mkRot CentralizerN.rotPt) := rfl
    have hA1 : ambientAct (CentralizerN.rotGen : PSL2F11) =
        weilLambda2 (CentralizerN.mkRot CentralizerN.rotPt) := by
      rw [hmk]; exact pslLambda2_mk _
    have hpowA :
        ambientAct ((CentralizerN.rotGen : PSL2F11) ^ 2) =
          weilLambda2 (CentralizerN.mkRot CentralizerN.rotPt) ∘ₗ
            weilLambda2 (CentralizerN.mkRot CentralizerN.rotPt) := by
      rw [pow_two, ambientAct_mul, hA1]
    have hR2U : WeilHom.weilUHom (CentralizerN.mkRot CentralizerN.rotPt) ∘ₗ
        WeilHom.weilUHom (CentralizerN.mkRot CentralizerN.rotPt) =
        (-LinearMap.id : U →ₗ[k] U) := by
      change (Rlin ∘ₗ Rlin : Module.End k U) = -LinearMap.id
      exact hR2eq
    -- exterior(-id) = exterior(weilU(-I)) = weilLambda2(-I) = ambientAct(1) = id
    have hnegI_eq : CentralizerN.negI = WeilRepSL2.negI := by
      apply Subtype.ext
      ext i j
      fin_cases i <;> fin_cases j <;>
        simp [CentralizerN.negI, WeilRepSL2.negI, Matrix.neg_apply]
    have hweil_neg : WeilHom.weilUHom CentralizerN.negI =
        (-LinearMap.id : U →ₗ[k] U) := by
      change WeilRepSL2.weilU CentralizerN.negI = -LinearMap.id
      rw [hnegI_eq]; exact WeilRepSL2.weilU_negI
    have hmk_neg : (QuotientGroup.mk CentralizerN.negI : PSL2F11) = 1 :=
      CentralizerN.mk_negI
    have hmap_neg :
        exteriorPower.map (R := k) (n := 2) (-LinearMap.id : U →ₗ[k] U) =
          LinearMap.id := by
      have h1 :
          exteriorPower.map (R := k) (n := 2) (-LinearMap.id : U →ₗ[k] U) =
            exteriorPower.map (R := k) (n := 2)
              (WeilHom.weilUHom CentralizerN.negI) := by
        rw [hweil_neg]
      have h2 :
          exteriorPower.map (R := k) (n := 2)
              (WeilHom.weilUHom CentralizerN.negI) =
            weilLambda2 CentralizerN.negI := rfl
      have h3 : weilLambda2 CentralizerN.negI =
          ambientAct (QuotientGroup.mk CentralizerN.negI : PSL2F11) :=
        (pslLambda2_mk CentralizerN.negI).symm
      rw [h1, h2, h3, hmk_neg, ambientAct_one]
    have hWL : weilLambda2 (CentralizerN.mkRot CentralizerN.rotPt) ∘ₗ
        weilLambda2 (CentralizerN.mkRot CentralizerN.rotPt) = LinearMap.id := by
      dsimp [weilLambda2]
      have hmap_comp :
          exteriorPower.map (R := k) (n := 2)
              (WeilHom.weilUHom (CentralizerN.mkRot CentralizerN.rotPt)) ∘ₗ
            exteriorPower.map (R := k) (n := 2)
              (WeilHom.weilUHom (CentralizerN.mkRot CentralizerN.rotPt)) =
          exteriorPower.map (R := k) (n := 2)
            (WeilHom.weilUHom (CentralizerN.mkRot CentralizerN.rotPt) ∘ₗ
              WeilHom.weilUHom (CentralizerN.mkRot CentralizerN.rotPt)) :=
        (exteriorPower.map_comp _ _).symm
      rw [hmap_comp, hR2U, hmap_neg]
    rw [hpowA, hWL]
  exact ambientAct_rotGen_pow_two_ne_id hA

/-- All powers of `rotGen` fix the residual pure wedge (as a vector). -/
theorem residual_plucker_rot_pow_fixed {u : U} (hu0 : u ≠ 0)
    (hR2 : Rlin (Rlin u) + u = 0) (n : ℕ) :
    ambientAct ((CentralizerN.rotGen : PSL2F11) ^ n) (pureWedge u (Rlin u)) =
      pureWedge u (Rlin u) := by
  induction n with
  | zero =>
    rw [pow_zero, ambientAct_one, LinearMap.id_apply]
  | succ n ih =>
    have hR : ambientAct (CentralizerN.rotGen : PSL2F11) (pureWedge u (Rlin u)) =
        pureWedge u (Rlin u) := by
      have hA := ambientAct_rotGen_pure u (Rlin u)
      have hR2u : Rlin (Rlin u) = -u := eq_neg_of_add_eq_zero_left hR2
      calc ambientAct (CentralizerN.rotGen : PSL2F11) (pureWedge u (Rlin u))
          = pureWedge (Rlin u) (Rlin (Rlin u)) := hA
        _ = pureWedge (Rlin u) (-u) := by rw [hR2u]
        _ = pureWedge u (Rlin u) := by
            have : pureWedge (Rlin u) (-u) = -pureWedge (Rlin u) u := by
              have hsm : (-u : U) = (-1 : k) • u := (neg_one_smul k u).symm
              rw [hsm, pureWedge_smul_right, neg_one_smul]
            rw [this, pureWedge_swap, neg_neg]
    calc ambientAct ((CentralizerN.rotGen : PSL2F11) ^ (n + 1)) (pureWedge u (Rlin u))
        = ambientAct ((CentralizerN.rotGen : PSL2F11) ^ n *
            CentralizerN.rotGen) (pureWedge u (Rlin u)) := by rw [pow_succ]
      _ = ambientAct ((CentralizerN.rotGen : PSL2F11) ^ n)
            (ambientAct (CentralizerN.rotGen : PSL2F11) (pureWedge u (Rlin u))) := by
          rw [ambientAct_mul, LinearMap.comp_apply]
      _ = ambientAct ((CentralizerN.rotGen : PSL2F11) ^ n) (pureWedge u (Rlin u)) := by
          rw [hR]
      _ = pureWedge u (Rlin u) := ih

/-- The N-character weight of the isotypic projector is `4/11 ≠ 1`.

This is the Fourier coefficient of a vector fixed by all of `N` along its line,
when the only contributing summands are those in `N` (or any stabilizer with the
same χ-sum 24).  Used to exclude residual Plücker from `Fix(π) = M`. -/
theorem projector_N_weight_ne_one :
    (10 * (660 : k)⁻¹) *
      (chi10' (1 : PSL2F11) + chi10' sigma +
        chi10' ((CentralizerN.rotGen : PSL2F11) ^ 2) +
        chi10' ((CentralizerN.rotGen : PSL2F11) ^ 4) +
        chi10' (CentralizerN.rotGen : PSL2F11) +
        chi10' ((CentralizerN.rotGen : PSL2F11) ^ 5) +
        (6 : k) * chi10' (CentralizerN.reflGen : PSL2F11)) ≠ 1 := by
  rw [chi10'_N_trivial_inner_two, ten_div_sixsixty_mul_twentyfour]
  exact four_div_eleven_ne_one


/-! ## Card of G; residual Plücker ∉ Fix(π) -/


/-- `M` as the 1-eigenspace of the character projector (Fix(π)).

`v ∈ Mfix ↔ projectorM v = v`.  Once convolution gives `π² = π`, this equals
`range(π)` and the writeup 10′ summand.  Residual exclusion targets `Mfix`. -/
@[expose] public noncomputable def Mfix : Submodule k Lambda2U :=
  LinearMap.ker (projectorM - LinearMap.id)

public theorem mem_Mfix_iff {v : Lambda2U} :
    v ∈ Mfix ↔ projectorM v = v := by
  simp only [Mfix, LinearMap.mem_ker, LinearMap.sub_apply, LinearMap.id_apply, sub_eq_zero]

theorem Mfix_smul_mem (h : PSL2F11) {v : Lambda2U} (hv : v ∈ Mfix) :
    ambientAct h v ∈ Mfix := by
  rw [mem_Mfix_iff] at hv ⊢
  calc projectorM (ambientAct h v)
      = ambientAct h (projectorM v) := projectorM_equivariant h v
    _ = ambientAct h v := by rw [hv]

/-! ## Residual N-stabilizer, dual sum, residual ∉ Mfix -/

private theorem dihedralToNHom_bijective :
    Function.Bijective CentralizerN.dihedralToNHom := by
  classical
  have hcard : Fintype.card (DihedralGroup 6) =
      Fintype.card (Subgroup.centralizer ({CentralizerN.sigma} : Set PSL2F11)) := by
    rw [DihedralGroup.card, CentralizerN.centralizer_sigma_card]
  exact (Fintype.bijective_iff_injective_and_card _).2
    ⟨CentralizerN.dihedralToNHom_injective, hcard⟩

/-- All of `N = C_G(σ)` fixes the residual pure wedge as a **vector**
(trivial N-character), under residual + S-stability of the plane. -/
theorem residual_plucker_N_all_fixed {u : U} (hu0 : u ≠ 0)
    (hR2 : Rlin (Rlin u) + u = 0)
    (hSstab : Slin u ∈ (k ∙ u) ⊔ (k ∙ Rlin u))
    (n : Subgroup.centralizer ({CentralizerN.sigma} : Set PSL2F11)) :
    ambientAct (n : PSL2F11) (pureWedge u (Rlin u)) =
      pureWedge u (Rlin u) := by
  classical
  obtain ⟨d, hd⟩ := dihedralToNHom_bijective.surjective n
  -- `hd : dihedralToNHom d = n`
  have hrotpow (m : ℕ) :
      ambientAct ((CentralizerN.rotGen : PSL2F11) ^ m) (pureWedge u (Rlin u)) =
        pureWedge u (Rlin u) :=
    residual_plucker_rot_pow_fixed hu0 hR2 m
  have hrefl :
      ambientAct (CentralizerN.reflGen : PSL2F11) (pureWedge u (Rlin u)) =
        pureWedge u (Rlin u) :=
    (residual_plucker_N_vec_fixed hu0 hR2 hSstab).2
  cases d with
  | r i =>
    -- dihedralToN (.r i) = rotGen ^ i.val
    have hcoe : (n : PSL2F11) = (CentralizerN.rotGen : PSL2F11) ^ i.val := by
      rw [← hd]
      rfl
    rw [hcoe]
    exact hrotpow i.val
  | sr i =>
    -- dihedralToN (.sr i) = reflGen * rotGen ^ i.val
    have hcoe : (n : PSL2F11) =
        (CentralizerN.reflGen : PSL2F11) *
          (CentralizerN.rotGen : PSL2F11) ^ i.val := by
      rw [← hd]
      rfl
    rw [hcoe, ambientAct_mul, LinearMap.comp_apply, hrotpow i.val, hrefl]

/-- Order of every reflection word `s r^i` is 2. -/
private theorem orderOf_refl_rot_pow (i : ZMod 6) :
    orderOf ((CentralizerN.reflGen : PSL2F11) *
      (CentralizerN.rotGen : PSL2F11) ^ i.val) = 2 := by
  haveI : Fact (Nat.Prime 2) := ⟨Nat.prime_two⟩
  have hsq : ((CentralizerN.reflGen : PSL2F11) *
      (CentralizerN.rotGen : PSL2F11) ^ i.val) ^ 2 = 1 := by
    have hconj : (CentralizerN.reflGen : PSL2F11) *
        (CentralizerN.rotGen : PSL2F11) ^ i.val *
        (CentralizerN.reflGen : PSL2F11) =
        ((CentralizerN.rotGen : PSL2F11)⁻¹) ^ i.val := by
      have h2 :=
        congrArg (fun g : Subgroup.centralizer ({CentralizerN.sigma} : Set PSL2F11) =>
          CentralizerN.reflGen * g)
          (CentralizerN.rotGen_pow_mul_reflGen i.val)
      have hL : CentralizerN.reflGen * CentralizerN.rotGen ^ i.val * CentralizerN.reflGen =
          CentralizerN.reflGen * (CentralizerN.rotGen ^ i.val * CentralizerN.reflGen) := by
        simp [mul_assoc]
      have hR : CentralizerN.reflGen *
          (CentralizerN.reflGen * (CentralizerN.rotGen⁻¹) ^ i.val) =
          (CentralizerN.rotGen⁻¹) ^ i.val := by
        rw [← mul_assoc, CentralizerN.reflGen_mul_self, one_mul]
      exact congrArg Subtype.val (hL.trans (h2.trans hR))
    calc ((CentralizerN.reflGen : PSL2F11) *
            (CentralizerN.rotGen : PSL2F11) ^ i.val) ^ 2
        = (CentralizerN.reflGen : PSL2F11) *
            ((CentralizerN.rotGen : PSL2F11) ^ i.val *
              ((CentralizerN.reflGen : PSL2F11) *
                (CentralizerN.rotGen : PSL2F11) ^ i.val)) := by
              simp [pow_two, mul_assoc]
      _ = (CentralizerN.reflGen : PSL2F11) *
            ((CentralizerN.rotGen : PSL2F11) ^ i.val *
              (CentralizerN.reflGen : PSL2F11)) *
            (CentralizerN.rotGen : PSL2F11) ^ i.val := by
              simp [mul_assoc]
      _ = ((CentralizerN.reflGen : PSL2F11) *
            (CentralizerN.rotGen : PSL2F11) ^ i.val *
            (CentralizerN.reflGen : PSL2F11)) *
            (CentralizerN.rotGen : PSL2F11) ^ i.val := by
              simp [mul_assoc]
      _ = ((CentralizerN.rotGen : PSL2F11)⁻¹) ^ i.val *
            (CentralizerN.rotGen : PSL2F11) ^ i.val := by rw [hconj]
      _ = ((CentralizerN.rotGen : PSL2F11) ^ i.val)⁻¹ *
            (CentralizerN.rotGen : PSL2F11) ^ i.val := by
              rw [(inv_pow (CentralizerN.rotGen : PSL2F11) i.val).symm]
      _ = 1 := inv_mul_cancel _
  have hne : (CentralizerN.reflGen : PSL2F11) *
      (CentralizerN.rotGen : PSL2F11) ^ i.val ≠ 1 := by
    intro heq
    have h1 : CentralizerN.reflGen = (CentralizerN.rotGen ^ i.val)⁻¹ := by
      apply Subtype.ext
      exact eq_inv_of_mul_eq_one_left heq
    have : CentralizerN.reflGen = CentralizerN.rotGen ^ ((5 * i.val) % 6) := by
      rw [h1]
      apply Subtype.ext
      change ((CentralizerN.rotGen : PSL2F11) ^ i.val)⁻¹ =
        (CentralizerN.rotGen : PSL2F11) ^ ((5 * i.val) % 6)
      have hinv : ((CentralizerN.rotGen : PSL2F11) ^ i.val)⁻¹ =
          ((CentralizerN.rotGen : PSL2F11)⁻¹) ^ i.val :=
        (inv_pow (CentralizerN.rotGen : PSL2F11) i.val).symm
      have hinvr : (CentralizerN.rotGen : PSL2F11)⁻¹ =
          (CentralizerN.rotGen : PSL2F11) ^ 5 :=
        congrArg Subtype.val CentralizerN.rotGen_inv_eq
      rw [hinv, hinvr, ← pow_mul]
      exact congrArg Subtype.val (CentralizerN.rotGen_pow_mod (5 * i.val))
    exact CentralizerN.reflGen_ne_rot_pow _ this
  exact orderOf_eq_prime hsq hne

/-- χ-sum of `chi10'` over the whole centralizer N equals 24. -/
theorem chi10'_sum_centralizer :
    (∑ n : Subgroup.centralizer ({CentralizerN.sigma} : Set PSL2F11),
      chi10' (n : PSL2F11)) = (24 : k) := by
  classical
  let e : DihedralGroup 6 ≃
      Subgroup.centralizer ({CentralizerN.sigma} : Set PSL2F11) :=
    Equiv.ofBijective CentralizerN.dihedralToNHom dihedralToNHom_bijective
  have hreindex :
      (∑ n : Subgroup.centralizer ({CentralizerN.sigma} : Set PSL2F11),
        chi10' (n : PSL2F11)) =
      ∑ d : DihedralGroup 6, chi10' (e d : PSL2F11) :=
    (Fintype.sum_equiv e (fun d => chi10' (e d : PSL2F11))
      (fun n => chi10' (n : PSL2F11)) (fun _ => rfl)).symm
  rw [hreindex]
  -- Split via Bool × ZMod 6 → Dihedral
  let f : Bool × ZMod 6 → DihedralGroup 6 :=
    fun p => if p.1 then DihedralGroup.sr p.2 else DihedralGroup.r p.2
  have hbijf : Function.Bijective f := by
    constructor
    · intro ⟨b1, i1⟩ ⟨b2, i2⟩ h
      cases b1 <;> cases b2 <;> simp [f] at h <;> cases h <;> rfl
    · intro d
      cases d with
      | r i => exact ⟨(false, i), rfl⟩
      | sr i => exact ⟨(true, i), rfl⟩
  have hsum_dih :
      (∑ d : DihedralGroup 6, chi10' (e d : PSL2F11)) =
        (∑ p : Bool × ZMod 6, chi10' (e (f p) : PSL2F11)) :=
    (Fintype.sum_bijective f hbijf
      (fun p => chi10' (e (f p) : PSL2F11))
      (fun d => chi10' (e d : PSL2F11))
      (fun _ => rfl)).symm
  rw [hsum_dih, Fintype.sum_prod_type, Fintype.sum_bool]
  -- false branch = rotations; true branch = reflections
  have hrot_term (i : ZMod 6) :
      chi10' (e (f (false, i)) : PSL2F11) =
        chi10' ((CentralizerN.rotGen : PSL2F11) ^ i.val) := by
    -- e (r i) = rotGen ^ i.val
    change chi10' (CentralizerN.dihedralToNHom (DihedralGroup.r i) : PSL2F11) =
      chi10' ((CentralizerN.rotGen : PSL2F11) ^ i.val)
    rfl
  have hrefl_term (i : ZMod 6) :
      chi10' (e (f (true, i)) : PSL2F11) =
        chi10' ((CentralizerN.reflGen : PSL2F11) *
          (CentralizerN.rotGen : PSL2F11) ^ i.val) := by
    change chi10' (CentralizerN.dihedralToNHom (DihedralGroup.sr i) : PSL2F11) =
      chi10' ((CentralizerN.reflGen : PSL2F11) *
        (CentralizerN.rotGen : PSL2F11) ^ i.val)
    rfl
  simp_rw [hrot_term, hrefl_term]
  -- Order table for rotations
  have hord6 := orderOf_rotGen_psl
  have hr2 : orderOf ((CentralizerN.rotGen : PSL2F11) ^ 2) = 3 := by
    have := orderOf_pow (x := (CentralizerN.rotGen : PSL2F11)) (n := 2)
    rw [hord6] at this; simpa using this
  have hr3 : orderOf ((CentralizerN.rotGen : PSL2F11) ^ 3) = 2 := by
    have := orderOf_pow (x := (CentralizerN.rotGen : PSL2F11)) (n := 3)
    rw [hord6] at this; simpa using this
  have hr4 : orderOf ((CentralizerN.rotGen : PSL2F11) ^ 4) = 3 := by
    have := orderOf_pow (x := (CentralizerN.rotGen : PSL2F11)) (n := 4)
    rw [hord6] at this; simpa using this
  have hr5 : orderOf ((CentralizerN.rotGen : PSL2F11) ^ 5) = 6 := by
    have := orderOf_pow (x := (CentralizerN.rotGen : PSL2F11)) (n := 5)
    rw [hord6] at this; simpa using this
  -- Character values on rotation powers
  have c0 : chi10' ((CentralizerN.rotGen : PSL2F11) ^ 0) = 10 := by
    simp [pow_zero, chi10'_one]
  have c1 : chi10' ((CentralizerN.rotGen : PSL2F11) ^ 1) = -1 := by
    simp [pow_one, chi10', hord6]
  have c2 : chi10' ((CentralizerN.rotGen : PSL2F11) ^ 2) = 1 := by
    simp [chi10', hr2]
  have c3 : chi10' ((CentralizerN.rotGen : PSL2F11) ^ 3) = 2 := by
    simp [chi10', hr3]
  have c4 : chi10' ((CentralizerN.rotGen : PSL2F11) ^ 4) = 1 := by
    simp [chi10', hr4]
  have c5 : chi10' ((CentralizerN.rotGen : PSL2F11) ^ 5) = -1 := by
    simp [chi10', hr5]
  have sum_rot :
      (∑ i : ZMod 6, chi10' ((CentralizerN.rotGen : PSL2F11) ^ i.val)) =
        (12 : k) := by
    -- Explicit expansion over ZMod 6 = {0,...,5}
    have hvals : (Finset.univ : Finset (ZMod 6)) = {0, 1, 2, 3, 4, 5} := by decide
    have v0 : (0 : ZMod 6).val = 0 := by decide
    have v1 : (1 : ZMod 6).val = 1 := by decide
    have v2 : (2 : ZMod 6).val = 2 := by decide
    have v3 : (3 : ZMod 6).val = 3 := by decide
    have v4 : (4 : ZMod 6).val = 4 := by decide
    have v5 : (5 : ZMod 6).val = 5 := by decide
    rw [hvals]
    -- Unfold sum over explicit insert chain
    have hne01 : (0 : ZMod 6) ≠ 1 := by decide
    have hne02 : (0 : ZMod 6) ≠ 2 := by decide
    have hne03 : (0 : ZMod 6) ≠ 3 := by decide
    have hne04 : (0 : ZMod 6) ≠ 4 := by decide
    have hne05 : (0 : ZMod 6) ≠ 5 := by decide
    have hne12 : (1 : ZMod 6) ≠ 2 := by decide
    have hne13 : (1 : ZMod 6) ≠ 3 := by decide
    have hne14 : (1 : ZMod 6) ≠ 4 := by decide
    have hne15 : (1 : ZMod 6) ≠ 5 := by decide
    have hne23 : (2 : ZMod 6) ≠ 3 := by decide
    have hne24 : (2 : ZMod 6) ≠ 4 := by decide
    have hne25 : (2 : ZMod 6) ≠ 5 := by decide
    have hne34 : (3 : ZMod 6) ≠ 4 := by decide
    have hne35 : (3 : ZMod 6) ≠ 5 := by decide
    have hne45 : (4 : ZMod 6) ≠ 5 := by decide
    rw [Finset.sum_insert (by simp [hne01, hne02, hne03, hne04, hne05]),
        Finset.sum_insert (by simp [hne12, hne13, hne14, hne15]),
        Finset.sum_insert (by simp [hne23, hne24, hne25]),
        Finset.sum_insert (by simp [hne34, hne35]),
        Finset.sum_insert (by simp [hne45]),
        Finset.sum_singleton, v0, v1, v2, v3, v4, v5, c0, c1, c2, c3, c4, c5]
    norm_num
  have sum_refl :
      (∑ i : ZMod 6, chi10' ((CentralizerN.reflGen : PSL2F11) *
        (CentralizerN.rotGen : PSL2F11) ^ i.val)) = (12 : k) := by
    have hchi (i : ZMod 6) :
        chi10' ((CentralizerN.reflGen : PSL2F11) *
          (CentralizerN.rotGen : PSL2F11) ^ i.val) = (2 : k) := by
      simp only [chi10', orderOf_refl_rot_pow i]; norm_num
    simp only [hchi, Finset.sum_const, nsmul_eq_mul, Finset.card_univ, ZMod.card]
    norm_num
  rw [sum_rot, sum_refl]
  norm_num

/-- Dual-bridge: `φ(ω)=1` and `∑ χ(g)φ(g·ω)=24` ⇒ `projectorM ω ≠ ω`. -/
theorem projectorM_ne_of_dual_sum_eq_twentyfour {ω : Lambda2U}
    (φ : Lambda2U →ₗ[k] k) (hφ1 : φ ω = 1)
    (hS : (∑ g : PSL2F11, chi10' g * φ (ambientAct g ω)) = 24) :
    projectorM ω ≠ ω := by
  intro hfix
  have hφπ : φ (projectorM ω) = 1 := by rw [hfix, hφ1]
  have happly : φ (projectorM ω) =
      (10 * (660 : k)⁻¹) * ∑ g : PSL2F11, chi10' g * φ (ambientAct g ω) := by
    rw [projectorM_apply, map_smul]
    simp only [smul_eq_mul, map_sum, map_smul]
  rw [happly, hS, ten_div_sixsixty_mul_twentyfour] at hφπ
  exact four_div_eleven_ne_one hφπ

/-- Residual ∉ `Mfix` given a residual dual with dual-sum 24. -/
theorem residual_plucker_not_mem_Mfix_of_dual {u : U}
    (φ : Lambda2U →ₗ[k] k)
    (hφ1 : φ (pureWedge u (Rlin u)) = 1)
    (hS : (∑ g : PSL2F11, chi10' g *
      φ (ambientAct g (pureWedge u (Rlin u)))) = 24) :
    pureWedge u (Rlin u) ∉ Mfix := by
  rw [mem_Mfix_iff]
  exact projectorM_ne_of_dual_sum_eq_twentyfour φ hφ1 hS

/-- N-contribution: under N-fixation, `∑_{n∈N} χ(n) φ(n·ω) = 24 · φ(ω)`. -/
theorem dual_sum_N_contribution {ω : Lambda2U}
    (hN : ∀ n : Subgroup.centralizer ({CentralizerN.sigma} : Set PSL2F11),
      ambientAct (n : PSL2F11) ω = ω)
    (φ : Lambda2U →ₗ[k] k) :
    (∑ n : Subgroup.centralizer ({CentralizerN.sigma} : Set PSL2F11),
      chi10' (n : PSL2F11) * φ (ambientAct (n : PSL2F11) ω)) =
      24 * φ ω := by
  classical
  have hterm : ∀ n : Subgroup.centralizer ({CentralizerN.sigma} : Set PSL2F11),
      chi10' (n : PSL2F11) * φ (ambientAct (n : PSL2F11) ω) =
        chi10' (n : PSL2F11) * φ ω := fun n => by rw [hN n]
  simp only [hterm]
  calc (∑ n : Subgroup.centralizer ({CentralizerN.sigma} : Set PSL2F11),
        chi10' (n : PSL2F11) * φ ω)
      = (∑ n : Subgroup.centralizer ({CentralizerN.sigma} : Set PSL2F11),
          chi10' (n : PSL2F11)) * φ ω := by rw [← Finset.sum_mul]
    _ = 24 * φ ω := by rw [chi10'_sum_centralizer]


/-! ## Residual pure ≠ 0 and N-partial projector (4/11 weight) -/

/-- Residual pure wedge is nonzero. -/
public theorem pureWedge_residual_ne_zero {u : U} (hu0 : u ≠ 0)
    (hR2 : Rlin (Rlin u) + u = 0) :
    pureWedge u (Rlin u) ≠ 0 := by
  intro hz
  have hI := residual_pair_independent hu0 hR2
  have hne := ιMulti_ne_zero_of_linearIndependent hI
  apply hne
  -- pureWedge coe is ExteriorAlgebra.ιMulti
  simpa [pureWedge, pureWedge_coe] using congrArg Subtype.val hz

/-- N-partial isotypic sum (centralizer terms only). -/
noncomputable def projectorM_N_partial : Module.End k Lambda2U :=
  (10 * (660 : k)⁻¹) •
    ∑ n : Subgroup.centralizer ({CentralizerN.sigma} : Set PSL2F11),
      chi10' (n : PSL2F11) • (ambientAct (n : PSL2F11) : Module.End k Lambda2U)

theorem projectorM_N_partial_apply_N_fixed {ω : Lambda2U}
    (hN : ∀ n : Subgroup.centralizer ({CentralizerN.sigma} : Set PSL2F11),
      ambientAct (n : PSL2F11) ω = ω) :
    projectorM_N_partial ω = ((4 : k) * (11 : k)⁻¹) • ω := by
  classical
  dsimp [projectorM_N_partial]
  have hterm : ∀ n : Subgroup.centralizer ({CentralizerN.sigma} : Set PSL2F11),
      (chi10' (n : PSL2F11) • ambientAct (n : PSL2F11)) ω =
        chi10' (n : PSL2F11) • ω := fun n => by
    rw [LinearMap.smul_apply, hN n]
  simp only [LinearMap.smul_apply, LinearMap.sum_apply, hterm]
  have hsum :
      (∑ n : Subgroup.centralizer ({CentralizerN.sigma} : Set PSL2F11),
        chi10' (n : PSL2F11) • ω) =
      (∑ n : Subgroup.centralizer ({CentralizerN.sigma} : Set PSL2F11),
        chi10' (n : PSL2F11)) • ω := by
    rw [← Finset.sum_smul]
  rw [hsum, chi10'_sum_centralizer]
  -- (10/660) • (24 • ω) = ((10/660)*24) • ω = (4/11) • ω
  have hsc : (10 * (660 : k)⁻¹) • ((24 : k) • ω) =
      ((10 * (660 : k)⁻¹) * 24) • ω := by rw [smul_smul]
  rw [hsc, ten_div_sixsixty_mul_twentyfour]

theorem projectorM_N_partial_residual_ne_id {u : U} (hu0 : u ≠ 0)
    (hR2 : Rlin (Rlin u) + u = 0)
    (hSstab : Slin u ∈ (k ∙ u) ⊔ (k ∙ Rlin u)) :
    projectorM_N_partial (pureWedge u (Rlin u)) ≠ pureWedge u (Rlin u) := by
  have hN := residual_plucker_N_all_fixed hu0 hR2 hSstab
  rw [projectorM_N_partial_apply_N_fixed hN]
  intro heq
  have hne := pureWedge_residual_ne_zero hu0 hR2
  have hsmul : ((4 : k) * (11 : k)⁻¹ - 1) • pureWedge u (Rlin u) = 0 := by
    calc ((4 : k) * (11 : k)⁻¹ - 1) • pureWedge u (Rlin u)
        = ((4 : k) * (11 : k)⁻¹) • pureWedge u (Rlin u) -
            (1 : k) • pureWedge u (Rlin u) := sub_smul _ _ _
      _ = pureWedge u (Rlin u) - pureWedge u (Rlin u) := by
          rw [heq, one_smul]
      _ = 0 := sub_self _
  have hcoeff : (4 : k) * (11 : k)⁻¹ - 1 = 0 :=
    (smul_eq_zero.mp hsmul).resolve_right hne
  exact four_div_eleven_ne_one (eq_of_sub_eq_zero hcoeff)


/-- `finrank Λ²U = 15`. -/
theorem finrank_Lambda2U : Module.finrank k Lambda2U = 15 := by
  have hU : Module.finrank k U = 6 := finrank_U
  -- exteriorPower.finrank_eq : finrank (⋀^n M) = choose (finrank M) n
  haveI : Module.Free k U := inferInstance
  haveI : Module.Finite k U := inferInstance
  rw [exteriorPower.finrank_eq (R := k) (M := U) (n := 2), hU]
  decide

public theorem card_PSL2F11 : Fintype.card PSL2F11 = 660 :=
  PSLCard.card_PSL2_F11_fintype

/-! ## Cross-term algebra: N-fixed `πω = ω` ⇔ `cross = 42 · ω` -/

/-- Character sum outside the N-contribution, for bookkeeping on N-fixed vectors. -/
@[expose] public noncomputable def chiCrossTerm (ω : Lambda2U) : Lambda2U :=
  (∑ g : PSL2F11, chi10' g • ambientAct g ω) -
    (∑ n : Subgroup.centralizer ({CentralizerN.sigma} : Set PSL2F11),
      chi10' (n : PSL2F11) • ambientAct (n : PSL2F11) ω)

/-- Under N-fixation, `∑_g χ(g) · g·ω = 24 · ω + chiCrossTerm ω`. -/
theorem sum_chi_eq_N_plus_cross {ω : Lambda2U}
    (hN : ∀ n : Subgroup.centralizer ({CentralizerN.sigma} : Set PSL2F11),
      ambientAct (n : PSL2F11) ω = ω) :
    (∑ g : PSL2F11, chi10' g • ambientAct g ω) =
      (24 : k) • ω + chiCrossTerm ω := by
  classical
  dsimp [chiCrossTerm]
  have hNsum :
      (∑ n : Subgroup.centralizer ({CentralizerN.sigma} : Set PSL2F11),
        chi10' (n : PSL2F11) • ambientAct (n : PSL2F11) ω) =
      (24 : k) • ω := by
    have hterm : ∀ n : Subgroup.centralizer ({CentralizerN.sigma} : Set PSL2F11),
        chi10' (n : PSL2F11) • ambientAct (n : PSL2F11) ω =
          chi10' (n : PSL2F11) • ω := fun n => by rw [hN n]
    simp only [hterm]
    calc (∑ n : Subgroup.centralizer ({CentralizerN.sigma} : Set PSL2F11),
          chi10' (n : PSL2F11) • ω)
        = (∑ n : Subgroup.centralizer ({CentralizerN.sigma} : Set PSL2F11),
            chi10' (n : PSL2F11)) • ω := by rw [← Finset.sum_smul]
      _ = (24 : k) • ω := by rw [chi10'_sum_centralizer]
  -- full = N + (full - N)
  rw [← hNsum, eq_comm]
  exact add_sub_cancel _ _

/-- Scalar identity: `660 / 10 = 66` in `k`. -/
theorem sixsixty_div_ten : (660 : k) * (10 : k)⁻¹ = 66 := by
  have h10 : (10 : k) ≠ 0 := by norm_num
  calc (660 : k) * (10 : k)⁻¹
      = (66 * 10 : k) * (10 : k)⁻¹ := by norm_num
    _ = 66 * (10 * (10 : k)⁻¹) := by ring
    _ = 66 * 1 := by rw [mul_inv_cancel₀ h10]
    _ = 66 := by ring

/-- Scalar identity: `(10/660) * 66 = 1`. -/
theorem ten_div_sixsixty_mul_sixtysix :
    (10 * (660 : k)⁻¹) * 66 = 1 := by
  have h660 : (660 : k) ≠ 0 := by norm_num
  calc (10 * (660 : k)⁻¹) * 66
      = (10 * 66) * (660 : k)⁻¹ := by ring
    _ = 660 * (660 : k)⁻¹ := by norm_num
    _ = 1 := mul_inv_cancel₀ h660

/-- Coefficient identity: `(660/10)*(10/660) = 1`. -/
theorem sixsixty_div_ten_mul_ten_div_sixsixty :
    ((660 : k) * (10 : k)⁻¹) * (10 * (660 : k)⁻¹) = 1 := by
  have h10 : (10 : k) ≠ 0 := by norm_num
  have h660 : (660 : k) ≠ 0 := by norm_num
  calc ((660 : k) * (10 : k)⁻¹) * (10 * (660 : k)⁻¹)
      = 660 * (660 : k)⁻¹ * (10 * (10 : k)⁻¹) := by ring
    _ = 1 * 1 := by rw [mul_inv_cancel₀ h660, mul_inv_cancel₀ h10]
    _ = 1 := by ring

/-- For N-fixed `ω`, `πω = (10/660) • (24 · ω + cross)`. -/
theorem projectorM_eq_N_plus_cross {ω : Lambda2U}
    (hN : ∀ n : Subgroup.centralizer ({CentralizerN.sigma} : Set PSL2F11),
      ambientAct (n : PSL2F11) ω = ω) :
    projectorM ω =
      (10 * (660 : k)⁻¹) • ((24 : k) • ω + chiCrossTerm ω) := by
  rw [projectorM_apply, sum_chi_eq_N_plus_cross hN]

/-- `πω = ω` + N-fixation ⇒ `chiCrossTerm ω = 42 · ω`. -/
theorem chiCrossTerm_of_mem_Mfix {ω : Lambda2U}
    (hN : ∀ n : Subgroup.centralizer ({CentralizerN.sigma} : Set PSL2F11),
      ambientAct (n : PSL2F11) ω = ω)
    (hfix : projectorM ω = ω) :
    chiCrossTerm ω = (42 : k) • ω := by
  have h1 : ω = (10 * (660 : k)⁻¹) • ((24 : k) • ω + chiCrossTerm ω) := by
    calc ω = projectorM ω := hfix.symm
      _ = (10 * (660 : k)⁻¹) • ((24 : k) • ω + chiCrossTerm ω) :=
          projectorM_eq_N_plus_cross hN
  have hscale : (66 : k) • ω = (24 : k) • ω + chiCrossTerm ω := by
    have h := congrArg (fun v => ((660 : k) * (10 : k)⁻¹) • v) h1
    have hL : ((660 : k) * (10 : k)⁻¹) • ω = (66 : k) • ω := by
      rw [sixsixty_div_ten]
    have hR : ((660 : k) * (10 : k)⁻¹) •
        ((10 * (660 : k)⁻¹) • ((24 : k) • ω + chiCrossTerm ω)) =
        (24 : k) • ω + chiCrossTerm ω := by
      rw [smul_smul, sixsixty_div_ten_mul_ten_div_sixsixty, one_smul]
    rw [hL] at h
    exact h.trans hR
  have hsub : chiCrossTerm ω = (66 : k) • ω - (24 : k) • ω := by
    -- from 66ω = 24ω + cross
    exact eq_sub_of_add_eq' hscale.symm
  calc chiCrossTerm ω
      = (66 : k) • ω - (24 : k) • ω := hsub
    _ = ((66 : k) - 24) • ω := (sub_smul (66 : k) 24 ω).symm
    _ = (42 : k) • ω := by norm_num

/-- Converse: N-fixation + `cross = 42 · ω` ⇒ `πω = ω`. -/
theorem mem_Mfix_of_chiCrossTerm_eq_forty_two {ω : Lambda2U}
    (hN : ∀ n : Subgroup.centralizer ({CentralizerN.sigma} : Set PSL2F11),
      ambientAct (n : PSL2F11) ω = ω)
    (hcross : chiCrossTerm ω = (42 : k) • ω) :
    projectorM ω = ω := by
  rw [projectorM_eq_N_plus_cross hN, hcross]
  have hsum : (24 : k) • ω + (42 : k) • ω = (66 : k) • ω := by
    rw [← add_smul]; norm_num
  rw [hsum, smul_smul, ten_div_sixsixty_mul_sixtysix, one_smul]

/-- Dual sum under N-fixation: `∑ χ(g) φ(g·ω) = 24 φ(ω) + φ(cross)`. -/
theorem dual_sum_eq_N_plus_cross {ω : Lambda2U}
    (hN : ∀ n : Subgroup.centralizer ({CentralizerN.sigma} : Set PSL2F11),
      ambientAct (n : PSL2F11) ω = ω)
    (φ : Lambda2U →ₗ[k] k) :
    (∑ g : PSL2F11, chi10' g * φ (ambientAct g ω)) =
      24 * φ ω + φ (chiCrossTerm ω) := by
  have hsplit := sum_chi_eq_N_plus_cross hN
  have happly :
      φ (∑ g : PSL2F11, chi10' g • ambientAct g ω) =
        ∑ g : PSL2F11, chi10' g * φ (ambientAct g ω) := by
    rw [map_sum]
    refine Finset.sum_congr rfl fun g _ => ?_
    rw [map_smul, smul_eq_mul]
  have hL : φ (∑ g : PSL2F11, chi10' g • ambientAct g ω) =
      φ ((24 : k) • ω + chiCrossTerm ω) := by rw [hsplit]
  calc (∑ g : PSL2F11, chi10' g * φ (ambientAct g ω))
      = φ ((24 : k) • ω + chiCrossTerm ω) := by rw [← happly, hL]
    _ = 24 * φ ω + φ (chiCrossTerm ω) := by
        rw [map_add, map_smul, smul_eq_mul]

/-- If `cross = 0` for N-fixed `ω ≠ 0`, dual-sum is 24 for any dual with `φ(ω)=1`. -/
theorem exists_dual_sum_twentyfour_of_cross_eq_zero {ω : Lambda2U}
    (hω0 : ω ≠ 0)
    (hN : ∀ n : Subgroup.centralizer ({CentralizerN.sigma} : Set PSL2F11),
      ambientAct (n : PSL2F11) ω = ω)
    (hcz : chiCrossTerm ω = 0) :
    ∃ φ : Lambda2U →ₗ[k] k, φ ω = 1 ∧
      (∑ g : PSL2F11, chi10' g * φ (ambientAct g ω)) = 24 := by
  classical
  haveI : Module.Free k Lambda2U := inferInstance
  haveI : Module.Projective k Lambda2U := Module.Projective.of_free
  obtain ⟨φ, hφ1⟩ := Projective.exists_dual_eq_one (K := k) (V := Lambda2U) hω0
  refine ⟨φ, hφ1, ?_⟩
  rw [dual_sum_eq_N_plus_cross hN φ, hφ1, hcz, map_zero, mul_one, add_zero]

/-- Parallel cross with scale `c ≠ 42` ⇒ `ω ∉ Mfix`. -/
theorem not_mem_Mfix_of_cross_parallel_ne_forty_two {ω : Lambda2U}
    (hω0 : ω ≠ 0)
    (hN : ∀ n : Subgroup.centralizer ({CentralizerN.sigma} : Set PSL2F11),
      ambientAct (n : PSL2F11) ω = ω)
    (c : k) (hc : chiCrossTerm ω = c • ω) (hc42 : c ≠ 42) :
    ¬ projectorM ω = ω := by
  intro hfix
  have hcross42 := chiCrossTerm_of_mem_Mfix hN hfix
  have hceq : c • ω = (42 : k) • ω := by
    calc c • ω = chiCrossTerm ω := hc.symm
      _ = (42 : k) • ω := hcross42
  have hsmul : (c - 42 : k) • ω = 0 := by
    calc (c - 42 : k) • ω = c • ω - (42 : k) • ω := sub_smul c 42 ω
      _ = 0 := by rw [hceq, sub_self]
  exact hc42 (eq_of_sub_eq_zero ((smul_eq_zero.mp hsmul).resolve_right hω0))

/-- If `cross = c · ω` with `c ≠ 42`, then `¬ πω = ω`.  Combined with the zero-cross
dual (S=24), this covers every N-fixed pure-isotypic case except pure-M (`c = 42`). -/
theorem not_mem_Mfix_of_cross_eq_smul_ne_forty_two {ω : Lambda2U}
    (hω0 : ω ≠ 0)
    (hN : ∀ n : Subgroup.centralizer ({CentralizerN.sigma} : Set PSL2F11),
      ambientAct (n : PSL2F11) ω = ω)
    (c : k) (hc : chiCrossTerm ω = c • ω) (hc42 : c ≠ 42) :
    ¬ projectorM ω = ω :=
  not_mem_Mfix_of_cross_parallel_ne_forty_two hω0 hN c hc hc42

/-- Zero cross-term ⇒ residual-style N-fixed vector not in `Mfix` (weight 4/11). -/
theorem not_mem_Mfix_of_cross_eq_zero {ω : Lambda2U}
    (hω0 : ω ≠ 0)
    (hN : ∀ n : Subgroup.centralizer ({CentralizerN.sigma} : Set PSL2F11),
      ambientAct (n : PSL2F11) ω = ω)
    (hcz : chiCrossTerm ω = 0) :
    ¬ projectorM ω = ω := by
  obtain ⟨φ, hφ1, hS⟩ :=
    exists_dual_sum_twentyfour_of_cross_eq_zero hω0 hN hcz
  exact projectorM_ne_of_dual_sum_eq_twentyfour φ hφ1 hS

/-- Residual pure wedge with `cross = c · ω` and `c ≠ 42` is not fixed by `projectorM`. -/
theorem residual_plucker_projectorM_ne_of_cross_smul_ne_forty_two {u : U}
    (hu0 : u ≠ 0)
    (hR2 : Rlin (Rlin u) + u = 0)
    (hSstab : Slin u ∈ (k ∙ u) ⊔ (k ∙ Rlin u))
    (c : k)
    (hc : chiCrossTerm (pureWedge u (Rlin u)) = c • pureWedge u (Rlin u))
    (hc42 : c ≠ 42) :
    projectorM (pureWedge u (Rlin u)) ≠ pureWedge u (Rlin u) :=
  not_mem_Mfix_of_cross_eq_smul_ne_forty_two
    (pureWedge_residual_ne_zero hu0 hR2)
    (residual_plucker_N_all_fixed hu0 hR2 hSstab) c hc hc42

/-- Residual pure wedge with vanishing cross-term is not fixed by `projectorM`. -/
theorem residual_plucker_projectorM_ne_of_cross_eq_zero {u : U}
    (hu0 : u ≠ 0)
    (hR2 : Rlin (Rlin u) + u = 0)
    (hSstab : Slin u ∈ (k ∙ u) ⊔ (k ∙ Rlin u))
    (hcz : chiCrossTerm (pureWedge u (Rlin u)) = 0) :
    projectorM (pureWedge u (Rlin u)) ≠ pureWedge u (Rlin u) :=
  not_mem_Mfix_of_cross_eq_zero
    (pureWedge_residual_ne_zero hu0 hR2)
    (residual_plucker_N_all_fixed hu0 hR2 hSstab) hcz

/-! ## Non-parallel cross: dual with `φ(ω)=1`, `φ(cross)=0` -/

/-- If `ω ∉ k · cross`, extend the zero map on `k · cross` by `φ(ω) = 1`. -/
theorem exists_dual_one_kill_cross {ω : Lambda2U}
    (hnot : ω ∉ (k ∙ chiCrossTerm ω : Submodule k Lambda2U)) :
    ∃ φ : Lambda2U →ₗ[k] k, φ ω = 1 ∧ φ (chiCrossTerm ω) = 0 := by
  classical
  obtain ⟨φ, hφ_comp, hφω⟩ :=
    LinearMap.exists_extend_of_notMem
      (0 : (k ∙ chiCrossTerm ω : Submodule k Lambda2U) →ₗ[k] k) hnot (1 : k)
  refine ⟨φ, hφω, ?_⟩
  -- φ vanishes on k · cross, hence on cross itself
  have hmem : chiCrossTerm ω ∈ (k ∙ chiCrossTerm ω : Submodule k Lambda2U) :=
    Submodule.mem_span_singleton_self _
  have hker : φ (chiCrossTerm ω) = 0 := by
    have := congrArg (fun f : (k ∙ chiCrossTerm ω : Submodule k Lambda2U) →ₗ[k] k =>
      f ⟨chiCrossTerm ω, hmem⟩) hφ_comp
    -- hφ_comp : φ.comp subtype = 0
    simpa [LinearMap.comp_apply, Submodule.subtype_apply] using this
  exact hker

/-- Non-parallel cross ⇒ dual-sum 24. -/
theorem exists_dual_sum_twentyfour_of_cross_not_parallel {ω : Lambda2U}
    (hω0 : ω ≠ 0)
    (hN : ∀ n : Subgroup.centralizer ({CentralizerN.sigma} : Set PSL2F11),
      ambientAct (n : PSL2F11) ω = ω)
    (hpar : chiCrossTerm ω ∉ (k ∙ ω : Submodule k Lambda2U)) :
    ∃ φ : Lambda2U →ₗ[k] k, φ ω = 1 ∧
      (∑ g : PSL2F11, chi10' g * φ (ambientAct g ω)) = 24 := by
  classical
  -- ω ∉ k · cross (else cross ∥ ω)
  have hnot : ω ∉ (k ∙ chiCrossTerm ω : Submodule k Lambda2U) := by
    intro hωmem
    obtain ⟨a, ha⟩ := Submodule.mem_span_singleton.mp hωmem
    -- ha : a • cross = ω
    by_cases ha0 : a = 0
    · rw [ha0, zero_smul] at ha
      exact hω0 ha.symm
    · -- a ≠ 0, ha : a • cross = ω ⇒ cross = a⁻¹ • ω ⇒ cross ∈ k · ω
      have hainv : a⁻¹ • ω = chiCrossTerm ω := by
        -- from a • cross = ω, left-multiply by a⁻¹
        have h := congrArg (fun v => a⁻¹ • v) ha
        -- a⁻¹ • (a • cross) = a⁻¹ • ω
        -- LHS = (a⁻¹ * a) • cross = 1 • cross = cross
        have hL : a⁻¹ • (a • chiCrossTerm ω) = chiCrossTerm ω := by
          rw [← mul_smul, inv_mul_cancel₀ ha0, one_smul]
        exact h.symm.trans hL
      exact hpar (Submodule.mem_span_singleton.mpr ⟨a⁻¹, hainv⟩)
  obtain ⟨φ, hφ1, hφcross⟩ := exists_dual_one_kill_cross hnot
  refine ⟨φ, hφ1, ?_⟩
  rw [dual_sum_eq_N_plus_cross hN φ, hφ1, hφcross, mul_one, add_zero]

/-- Non-parallel cross ⇒ `πω ≠ ω`. -/
theorem not_mem_Mfix_of_cross_not_parallel {ω : Lambda2U}
    (hω0 : ω ≠ 0)
    (hN : ∀ n : Subgroup.centralizer ({CentralizerN.sigma} : Set PSL2F11),
      ambientAct (n : PSL2F11) ω = ω)
    (hpar : chiCrossTerm ω ∉ (k ∙ ω : Submodule k Lambda2U)) :
    ¬ projectorM ω = ω := by
  obtain ⟨φ, hφ1, hS⟩ :=
    exists_dual_sum_twentyfour_of_cross_not_parallel hω0 hN hpar
  exact projectorM_ne_of_dual_sum_eq_twentyfour φ hφ1 hS

/-- `cross ≠ 42 · ω` for N-fixed `ω ≠ 0` ⇒ `πω ≠ ω` (all cases). -/
theorem not_mem_Mfix_of_cross_ne_forty_two {ω : Lambda2U}
    (hω0 : ω ≠ 0)
    (hN : ∀ n : Subgroup.centralizer ({CentralizerN.sigma} : Set PSL2F11),
      ambientAct (n : PSL2F11) ω = ω)
    (hne42 : chiCrossTerm ω ≠ (42 : k) • ω) :
    ¬ projectorM ω = ω := by
  classical
  by_cases hpar : chiCrossTerm ω ∈ (k ∙ ω : Submodule k Lambda2U)
  · obtain ⟨c, hc⟩ := Submodule.mem_span_singleton.mp hpar
    -- hc : c • ω = chiCrossTerm ω
    have hc' : chiCrossTerm ω = c • ω := hc.symm
    have hc42 : c ≠ 42 := fun hceq => hne42 (by rw [hc', hceq])
    exact not_mem_Mfix_of_cross_parallel_ne_forty_two hω0 hN c hc' hc42
  · exact not_mem_Mfix_of_cross_not_parallel hω0 hN hpar


/-! ## Exterior pure-M gate and residual ∉ Mfix bridges -/

open ExteriorAlgebra

theorem coe_Lambda2U_smul (a : k) (x : Lambda2U) :
    ((a • x : Lambda2U) : ExteriorAlgebra k U) =
      a • (x : ExteriorAlgebra k U) := rfl

theorem coe_Lambda2U_add (x y : Lambda2U) :
    ((x + y : Lambda2U) : ExteriorAlgebra k U) =
      (x : ExteriorAlgebra k U) + (y : ExteriorAlgebra k U) := rfl

/-- Pure-M forces `cross * ω = 0` in the exterior algebra. -/
theorem chiCrossTerm_mul_eq_zero_of_eq_forty_two {ω : Lambda2U}
    (hωω : ((ω : ExteriorAlgebra k U) * (ω : ExteriorAlgebra k U) = 0))
    (hcross : chiCrossTerm ω = (42 : k) • ω) :
    ((chiCrossTerm ω : ExteriorAlgebra k U) * (ω : ExteriorAlgebra k U)) = 0 := by
  rw [hcross, coe_Lambda2U_smul, smul_mul_assoc, hωω, smul_zero]

/-- Residual pure squares to zero. -/
theorem residual_plucker_sq (u : U) :
    ((pureWedge u (Rlin u) : Lambda2U) : ExteriorAlgebra k U) *
      ((pureWedge u (Rlin u) : Lambda2U) : ExteriorAlgebra k U) = 0 :=
  pureWedge_sq u (Rlin u)

/-- If residual `cross * ω ≠ 0`, then `cross ≠ 42 · ω`. -/
theorem residual_cross_ne_forty_two_of_mul_ne_zero {u : U}
    (hmul : ((chiCrossTerm (pureWedge u (Rlin u)) : ExteriorAlgebra k U) *
      ((pureWedge u (Rlin u) : Lambda2U) : ExteriorAlgebra k U)) ≠ 0) :
    chiCrossTerm (pureWedge u (Rlin u)) ≠
      (42 : k) • pureWedge u (Rlin u) := by
  intro hcross
  exact hmul (chiCrossTerm_mul_eq_zero_of_eq_forty_two
    (residual_plucker_sq u) hcross)

/-- Residual pure-M exclusion from exterior product. -/
theorem residual_chiCrossTerm_ne_forty_two_of_mul {u : U}
    (hmul : ((chiCrossTerm (pureWedge u (Rlin u)) : ExteriorAlgebra k U) *
      ((pureWedge u (Rlin u) : Lambda2U) : ExteriorAlgebra k U)) ≠ 0) :
    chiCrossTerm (pureWedge u (Rlin u)) ≠
      (42 : k) • pureWedge u (Rlin u) :=
  residual_cross_ne_forty_two_of_mul_ne_zero hmul

/-- Residual pure wedge not fixed by `projectorM` from `cross ≠ 42 · ω`. -/
public theorem residual_plucker_projectorM_ne_of_cross_ne_forty_two {u : U}
    (hu0 : u ≠ 0)
    (hR2 : Rlin (Rlin u) + u = 0)
    (hSstab : Slin u ∈ (k ∙ u) ⊔ (k ∙ Rlin u))
    (hne42 : chiCrossTerm (pureWedge u (Rlin u)) ≠
      (42 : k) • pureWedge u (Rlin u)) :
    projectorM (pureWedge u (Rlin u)) ≠ pureWedge u (Rlin u) :=
  not_mem_Mfix_of_cross_ne_forty_two
    (pureWedge_residual_ne_zero hu0 hR2)
    (residual_plucker_N_all_fixed hu0 hR2 hSstab) hne42

/-- Residual pure wedge not fixed by `projectorM` under non-parallel cross. -/
theorem residual_plucker_projectorM_ne_of_cross_not_parallel {u : U}
    (hu0 : u ≠ 0)
    (hR2 : Rlin (Rlin u) + u = 0)
    (hSstab : Slin u ∈ (k ∙ u) ⊔ (k ∙ Rlin u))
    (hpar : chiCrossTerm (pureWedge u (Rlin u)) ∉
      (k ∙ pureWedge u (Rlin u) : Submodule k Lambda2U)) :
    projectorM (pureWedge u (Rlin u)) ≠ pureWedge u (Rlin u) :=
  not_mem_Mfix_of_cross_not_parallel
    (pureWedge_residual_ne_zero hu0 hR2)
    (residual_plucker_N_all_fixed hu0 hR2 hSstab) hpar

/-! ### Character norm of χ₁₀': ∑_g χ(g)² = 660

From `PSLCard.chi10Int_sum_sq_psl` (SL native count + 2-to-1 quotient sum). -/

public theorem chi10'_eq_chi10Int (g : PSL2F11) :
    chi10' g = (PSLCard.chi10Int (orderOf g) : k) := by
  unfold chi10' PSLCard.chi10Int
  by_cases h1 : orderOf g = 1
  · simp [h1]
  by_cases h2 : orderOf g = 2
  · simp [h1, h2]
  by_cases h3 : orderOf g = 3
  · simp [h1, h2, h3]
  by_cases h5 : orderOf g = 5
  · simp [h1, h2, h3, h5]
  by_cases h6 : orderOf g = 6
  · simp [h1, h2, h3, h5, h6]
  by_cases h11 : orderOf g = 11
  · simp [h1, h2, h3, h5, h6, h11]
  · simp [h1, h2, h3, h5, h6, h11]

/-- ∑_g χ₁₀'(g)² = 660 (character norm 1). -/
theorem chi10'_sum_sq :
    (∑ g : PSL2F11, chi10' g * chi10' g) = (660 : k) := by
  classical
  have hterm : ∀ g : PSL2F11,
      chi10' g * chi10' g =
        ((PSLCard.chi10Int (orderOf g) * PSLCard.chi10Int (orderOf g) : ℤ) : k) := by
    intro g
    rw [chi10'_eq_chi10Int g, ← Int.cast_mul]
  have hsum :
      (∑ g : PSL2F11, chi10' g * chi10' g) =
        ∑ g : PSL2F11,
          ((PSLCard.chi10Int (orderOf g) * PSLCard.chi10Int (orderOf g) : ℤ) : k) :=
    Fintype.sum_congr _ _ hterm
  rw [hsum]
  have hcast :
      (∑ g : PSL2F11,
          ((PSLCard.chi10Int (orderOf g) * PSLCard.chi10Int (orderOf g) : ℤ) : k)) =
        ((∑ g : PSL2F11,
            PSLCard.chi10Int (orderOf g) * PSLCard.chi10Int (orderOf g) : ℤ) : k) := by
    simp only [Int.cast_sum]
  rw [hcast, PSLCard.chi10Int_sum_sq_psl]
  norm_num


/-! ### Pure-M infrastructure: χ-sum operator acts as 66 on pure-M vectors -/

/-- Unnormalized isotypic sum `T = ∑_g χ(g) · ρ(g)`. -/
@[expose] public noncomputable def chiSumOp : Module.End k Lambda2U :=
  ∑ g : PSL2F11, chi10' g • ambientAct g

theorem chiSumOp_apply (v : Lambda2U) :
    chiSumOp v = ∑ g : PSL2F11, chi10' g • ambientAct g v := by
  dsimp [chiSumOp]
  simp only [LinearMap.sum_apply, LinearMap.smul_apply]

theorem projectorM_eq_smul_chiSumOp (v : Lambda2U) :
    projectorM v = (10 * (660 : k)⁻¹) • chiSumOp v := by
  rw [projectorM_apply, chiSumOp_apply]

/-- Pure-M (`πω = ω`) implies `T ω = 66 ω`. -/
public theorem chiSumOp_eq_sixty_six_of_mem_Mfix {ω : Lambda2U}
    (hfix : projectorM ω = ω) :
    chiSumOp ω = (66 : k) • ω := by
  have h1 : ω = (10 * (660 : k)⁻¹) • chiSumOp ω := by
    calc ω = projectorM ω := hfix.symm
      _ = (10 * (660 : k)⁻¹) • chiSumOp ω := projectorM_eq_smul_chiSumOp ω
  have h := congrArg (fun v => (660 * (10 : k)⁻¹) • v) h1
  have hL : (660 * (10 : k)⁻¹) • ω = (66 : k) • ω := by
    rw [sixsixty_div_ten]
  have hR : (660 * (10 : k)⁻¹) • ((10 * (660 : k)⁻¹) • chiSumOp ω) =
      chiSumOp ω := by
    rw [smul_smul, sixsixty_div_ten_mul_ten_div_sixsixty, one_smul]
  rw [hL] at h
  exact (h.trans hR).symm

/-- `T` is G-equivariant. -/
theorem chiSumOp_equivariant (h : PSL2F11) (v : Lambda2U) :
    chiSumOp (ambientAct h v) = ambientAct h (chiSumOp v) := by
  rw [chiSumOp_apply, chiSumOp_apply, sum_chi_ambient_equivariant]

/-- Pure-M + N-fixation ⇒ `cross = 42 ω` (already have) and `T` acts as 66 on
the full G-orbit of `ω`. -/
theorem chiSumOp_orbit_eq_sixty_six_of_pureM {ω : Lambda2U}
    (hfix : projectorM ω = ω) (g : PSL2F11) :
    chiSumOp (ambientAct g ω) = (66 : k) • ambientAct g ω := by
  calc chiSumOp (ambientAct g ω)
      = ambientAct g (chiSumOp ω) := chiSumOp_equivariant g ω
    _ = ambientAct g ((66 : k) • ω) := by rw [chiSumOp_eq_sixty_six_of_mem_Mfix hfix]
    _ = (66 : k) • ambientAct g ω := map_smul _ _ _

/-- G-orbit vectors of a pure-M vector are 66-eigenvectors of `T`. -/
theorem gspan_mem_eigen_of_pureM {ω : Lambda2U}
    (hfix : projectorM ω = ω) (g : PSL2F11) :
    chiSumOp (ambientAct g ω) = (66 : k) • ambientAct g ω :=
  chiSumOp_orbit_eq_sixty_six_of_pureM hfix g

/-! ### Character convolution over `k` and projector idempotence `π² = π` -/

/-- Field-level convolution: `∑_g χ(g)χ(g⁻¹m) = 66 χ(m)`. -/
theorem chi10'_convolution (m : PSL2F11) :
    (∑ g : PSL2F11, chi10' g * chi10' (g⁻¹ * m)) = (66 : k) * chi10' m := by
  classical
  have hInt := PSLCard.chi10Int_convolution m
  -- Lift the integer identity to `k` via `chi10'_eq_chi10Int`
  have hterm : ∀ g : PSL2F11,
      chi10' g * chi10' (g⁻¹ * m) =
        ((PSLCard.chi10Int (orderOf g) *
          PSLCard.chi10Int (orderOf (g⁻¹ * m)) : ℤ) : k) := by
    intro g
    rw [chi10'_eq_chi10Int g, chi10'_eq_chi10Int (g⁻¹ * m), ← Int.cast_mul]
  calc (∑ g : PSL2F11, chi10' g * chi10' (g⁻¹ * m))
      = ∑ g : PSL2F11,
          ((PSLCard.chi10Int (orderOf g) *
            PSLCard.chi10Int (orderOf (g⁻¹ * m)) : ℤ) : k) :=
          Fintype.sum_congr _ _ hterm
    _ = ((∑ g : PSL2F11,
            PSLCard.chi10Int (orderOf g) *
              PSLCard.chi10Int (orderOf (g⁻¹ * m)) : ℤ) : k) := by
          simp only [Int.cast_sum]
    _ = ((66 * PSLCard.chi10Int (orderOf m) : ℤ) : k) :=
          congrArg (fun n : ℤ => (n : k)) hInt
    _ = ((66 : ℤ) : k) * ((PSLCard.chi10Int (orderOf m) : ℤ) : k) := by
          rw [Int.cast_mul]
    _ = (66 : k) * chi10' m := by
          have h66 : ((66 : ℤ) : k) = (66 : k) := by norm_num
          rw [h66, chi10'_eq_chi10Int m]

/-- Scalar identity: `(10/660)² · 66 = 10/660`. -/
theorem ten_div_sixsixty_sq_mul_sixtysix :
    (10 * (660 : k)⁻¹) * (10 * (660 : k)⁻¹) * 66 = 10 * (660 : k)⁻¹ := by
  have h660 : (660 : k) ≠ 0 := by norm_num
  calc (10 * (660 : k)⁻¹) * (10 * (660 : k)⁻¹) * 66
      = (10 * 10 * 66) * ((660 : k)⁻¹ * (660 : k)⁻¹) := by ring
    _ = (6600 : k) * ((660 : k)⁻¹ * (660 : k)⁻¹) := by norm_num
    _ = (10 * 660) * ((660 : k)⁻¹ * (660 : k)⁻¹) := by norm_num
    _ = 10 * (660 * (660 : k)⁻¹) * (660 : k)⁻¹ := by ring
    _ = 10 * 1 * (660 : k)⁻¹ := by rw [mul_inv_cancel₀ h660]
    _ = 10 * (660 : k)⁻¹ := by ring

/-- Pointwise form of `T² = 66 · T`. -/
theorem chiSumOp_sq_apply (v : Lambda2U) :
    chiSumOp (chiSumOp v) = (66 : k) • chiSumOp v := by
  classical
  -- Expand T(Tv)
  have hexpand :
      chiSumOp (chiSumOp v) =
        ∑ h : PSL2F11, ∑ g : PSL2F11,
          (chi10' h * chi10' g) • ambientAct (h * g) v := by
    rw [chiSumOp_apply]
    refine Finset.sum_congr rfl fun h _ => ?_
    rw [chiSumOp_apply, map_sum, Finset.smul_sum]
    refine Finset.sum_congr rfl fun g _ => ?_
    rw [LinearMap.map_smul, smul_smul, ambientAct_mul, LinearMap.comp_apply]
  -- Reindex g ↦ t = h*g  (avoid shadowing field `k`)
  have hreindex :
      (∑ h : PSL2F11, ∑ g : PSL2F11,
          (chi10' h * chi10' g) • ambientAct (h * g) v) =
        ∑ h : PSL2F11, ∑ t : PSL2F11,
          (chi10' h * chi10' (h⁻¹ * t)) • ambientAct t v := by
    refine Fintype.sum_congr _ _ fun h => ?_
    let e : PSL2F11 ≃ PSL2F11 :=
      { toFun := fun g => h * g
        invFun := fun t => h⁻¹ * t
        left_inv := fun g => by group
        right_inv := fun t => by group }
    exact Fintype.sum_equiv e
      (fun g => (chi10' h * chi10' g) • ambientAct (h * g) v)
      (fun t => (chi10' h * chi10' (h⁻¹ * t)) • ambientAct t v)
      (fun g => by
        have hg : h⁻¹ * (h * g) = g := by group
        change (chi10' h * chi10' g) • ambientAct (h * g) v =
          (chi10' h * chi10' (h⁻¹ * (h * g))) • ambientAct (h * g) v
        rw [hg])
  have hswap :
      (∑ h : PSL2F11, ∑ t : PSL2F11,
          (chi10' h * chi10' (h⁻¹ * t)) • ambientAct t v) =
        ∑ t : PSL2F11, ∑ h : PSL2F11,
          (chi10' h * chi10' (h⁻¹ * t)) • ambientAct t v := by
    rw [Finset.sum_comm]
  have hconv :
      (∑ t : PSL2F11, ∑ h : PSL2F11,
          (chi10' h * chi10' (h⁻¹ * t)) • ambientAct t v) =
        ∑ t : PSL2F11, ((66 : k) * chi10' t) • ambientAct t v := by
    refine Finset.sum_congr rfl fun t _ => ?_
    -- ∑_h (c_h • w) = (∑_h c_h) • w
    have hpull :
        (∑ h : PSL2F11, (chi10' h * chi10' (h⁻¹ * t)) • ambientAct t v) =
          (∑ h : PSL2F11, chi10' h * chi10' (h⁻¹ * t)) • ambientAct t v := by
      rw [← Finset.sum_smul]
    rw [hpull, chi10'_convolution t]
  have h66 :
      (∑ t : PSL2F11, ((66 : k) * chi10' t) • ambientAct t v) =
        (66 : k) • (∑ t : PSL2F11, chi10' t • ambientAct t v) := by
    rw [Finset.smul_sum]
    refine Finset.sum_congr rfl fun t _ => ?_
    rw [mul_smul]
  calc chiSumOp (chiSumOp v)
      = ∑ h : PSL2F11, ∑ g : PSL2F11,
          (chi10' h * chi10' g) • ambientAct (h * g) v := hexpand
    _ = ∑ h : PSL2F11, ∑ t : PSL2F11,
          (chi10' h * chi10' (h⁻¹ * t)) • ambientAct t v := hreindex
    _ = ∑ t : PSL2F11, ∑ h : PSL2F11,
          (chi10' h * chi10' (h⁻¹ * t)) • ambientAct t v := hswap
    _ = ∑ t : PSL2F11, ((66 : k) * chi10' t) • ambientAct t v := hconv
    _ = (66 : k) • (∑ t : PSL2F11, chi10' t • ambientAct t v) := h66
    _ = (66 : k) • chiSumOp v := by rw [← chiSumOp_apply]

/-- Pointwise projector idempotence: `π(π v) = π v`. -/
public theorem projectorM_sq_apply (v : Lambda2U) :
    projectorM (projectorM v) = projectorM v := by
  set c : k := 10 * (660 : k)⁻¹
  have hc (w : Lambda2U) : projectorM w = c • chiSumOp w := by
    simpa [c] using projectorM_eq_smul_chiSumOp w
  -- After rewriting π = c•T on both sides and the argument: c•T(c•T v)=c•T v
  rw [hc (projectorM v)]
  rw [show projectorM v = c • chiSumOp v from hc v]
  have hTT := chiSumOp_sq_apply v
  have hstep :
      c • chiSumOp (c • chiSumOp v) = c • (c • chiSumOp (chiSumOp v)) := by
    rw [map_smul]
  have hstep2 :
      c • (c • chiSumOp (chiSumOp v)) = c • (c • ((66 : k) • chiSumOp v)) := by
    rw [hTT]
  have hstep3 :
      c • (c • ((66 : k) • chiSumOp v)) = (c * c * 66) • chiSumOp v := by
    simp only [smul_smul, mul_assoc]
  have hstep4 : (c * c * 66) • chiSumOp v = c • chiSumOp v := by
    have hid : c * c * 66 = c := by
      dsimp [c]
      exact ten_div_sixsixty_sq_mul_sixtysix
    rw [hid]
  exact hstep.trans (hstep2.trans (hstep3.trans hstep4))

/-- Fixed space of π equals its range (since π is a projector). -/
public theorem Mfix_eq_Msub : Mfix = Msub := by
  classical
  apply le_antisymm
  · intro v hv
    exact LinearMap.mem_range.mpr ⟨v, (mem_Mfix_iff (v := v)).1 hv⟩
  · intro v hv
    obtain ⟨w, rfl⟩ := LinearMap.mem_range.mp hv
    exact (mem_Mfix_iff (v := projectorM w)).2 (projectorM_sq_apply w)

/-! ### Pure-M rank/dim infrastructure

From `π = (10/660)·T` and `T² = 66 T` we get `T = 66·π`.  Pure-M vectors
lie in `Msub`, and their full G-orbit is in `Msub` (G-invariant).  Hence under
pure-M the cyclic G-span of residual sits in a G-submodule of `Msub`.  Writeup
Input 3 / modular audit: `rank(π)=10` and residual G-span has dim 15, so pure-M
is impossible; sealed here: the inclusion `G-span ⊆ Msub` under pure-M. -/

/-- `T = 66 · π` pointwise. -/
theorem chiSumOp_eq_smul_projectorM (v : Lambda2U) :
    chiSumOp v = (66 : k) • projectorM v := by
  have h := projectorM_eq_smul_chiSumOp v
  -- π v = (10/660) • T v  ⇒  T v = 66 • π v
  have h1 : projectorM v = (10 * (660 : k)⁻¹) • chiSumOp v := h
  have hscale := congrArg (fun w => ((660 : k) * (10 : k)⁻¹) • w) h1
  have hL : ((660 : k) * (10 : k)⁻¹) • projectorM v = (66 : k) • projectorM v := by
    rw [sixsixty_div_ten]
  have hR : ((660 : k) * (10 : k)⁻¹) • ((10 * (660 : k)⁻¹) • chiSumOp v) =
      chiSumOp v := by
    rw [smul_smul, sixsixty_div_ten_mul_ten_div_sixsixty, one_smul]
  rw [hL] at hscale
  exact (hscale.trans hR).symm

/-- `v ∈ Mfix` iff `v ∈ Msub`. -/
theorem mem_Msub_iff_mem_Mfix {v : Lambda2U} :
    v ∈ Msub ↔ v ∈ Mfix := by
  rw [Mfix_eq_Msub]

/-- Pure-M (`πω = ω`) places `ω` in the range of `π`. -/
theorem mem_Msub_of_mem_Mfix {ω : Lambda2U} (hfix : projectorM ω = ω) :
    ω ∈ Msub :=
  LinearMap.mem_range.mpr ⟨ω, hfix⟩

/-- G-orbit of a pure-M vector lies in `Msub`. -/
theorem ambientAct_mem_Msub_of_pureM {ω : Lambda2U}
    (hfix : projectorM ω = ω) (g : PSL2F11) :
    ambientAct g ω ∈ Msub := by
  have hω : ω ∈ Msub := mem_Msub_of_mem_Mfix hfix
  exact Msub_smul_mem g hω

/-- Pure-M residual pure wedge lies in `Msub = Mfix`. -/
theorem residual_plucker_mem_Msub_of_pureM {u : U}
    (hu0 : u ≠ 0)
    (hR2 : Rlin (Rlin u) + u = 0)
    (hSstab : Slin u ∈ (k ∙ u) ⊔ (k ∙ Rlin u))
    (hfix : projectorM (pureWedge u (Rlin u)) = pureWedge u (Rlin u)) :
    pureWedge u (Rlin u) ∈ Msub :=
  mem_Msub_of_mem_Mfix hfix

/-- Under pure-M, the residual pure wedge itself (not just its projectivization rep)
lies in `Msub`. Combined with `IsDecomposable` of `mk(u∧Ru)`, this is the pure-M
obstruction input for hyp (b) on the M-cut: a pure-M residual would be an
N-fixed V₁₄ point. -/
theorem residual_plucker_mem_Msub_of_mem_Mfix {u : U}
    (hu0 : u ≠ 0)
    (hR2 : Rlin (Rlin u) + u = 0)
    (hSstab : Slin u ∈ (k ∙ u) ⊔ (k ∙ Rlin u))
    (hfix : projectorM (pureWedge u (Rlin u)) = pureWedge u (Rlin u)) :
    pureWedge u (Rlin u) ∈ Msub :=
  residual_plucker_mem_Msub_of_pureM hu0 hR2 hSstab hfix

/-! ### Rank of `π`: `finrank Msub = tr(π)` via projector trace

`π` is idempotent (`projectorM_sq_apply`), so `IsProj` applies and
`LinearMap.IsProj.trace` gives `tr(π) = finrank(range π)`. -/

/-- `π` is the projection onto `Msub` (constructed pointwise, avoiding `LinearMap.ext`
maxRecDepth on exterior-power modules). -/
theorem projectorM_isProj : IsProj Msub projectorM where
  map_mem := fun v => by
    -- πv ∈ range π = Msub
    simpa [Msub] using LinearMap.mem_range_self projectorM v
  map_id := fun v hv => by
    -- v ∈ Msub = Mfix ⇒ πv = v
    have hv' : v ∈ Mfix := by rwa [← Mfix_eq_Msub] at hv
    exact (mem_Mfix_iff (v := v)).mp hv'

/-- Trace of the isotypic projector equals `finrank Msub`. -/
public theorem projectorM_trace_eq_finrank :
    LinearMap.trace k Lambda2U projectorM =
      (Module.finrank k Msub : k) := by
  haveI : Module.Free k Msub := inferInstance
  haveI : Module.Finite k Msub := inferInstance
  haveI : Module.Free k (LinearMap.ker projectorM) := inferInstance
  haveI : Module.Finite k (LinearMap.ker projectorM) := inferInstance
  exact projectorM_isProj.trace

/-- Character of the ambient Λ² representation. -/
@[expose] public noncomputable def chiLambda2 (g : PSL2F11) : k :=
  LinearMap.trace k Lambda2U (ambientAct g)

theorem chiLambda2_one : chiLambda2 1 = 15 := by
  dsimp [chiLambda2]
  rw [ambientAct_one, LinearMap.trace_id, finrank_Lambda2U]
  norm_num

/-! ### Conjugacy of involutions

Class size of `σ` is `|G|/|C_G(σ)| = 660/12 = 55`, equal to the number of
order-2 elements, so every involution is conjugate to `σ`. -/

open ConjAct ConjClasses

theorem sigma_eq_CentralizerN_sigma : sigma = CentralizerN.sigma := rfl

/-- Conjugacy class of `σ` has 55 elements. -/
theorem card_carrier_sigma :
    Fintype.card (ConjClasses.mk sigma).carrier = 55 := by
  classical
  have hG : Fintype.card PSL2F11 = 660 := card_PSL2F11
  have hcentN : Nat.card (Subgroup.centralizer ({sigma} : Set PSL2F11)) = 12 := by
    rw [sigma_eq_CentralizerN_sigma, Nat.card_eq_fintype_card]
    exact CentralizerN.centralizer_sigma_card
  have hstab : Fintype.card (MulAction.stabilizer (ConjAct PSL2F11) sigma) = 12 := by
    have heq := Subgroup.nat_card_centralizer_nat_card_stabilizer (G := PSL2F11) sigma
    have hN : Nat.card (MulAction.stabilizer (ConjAct PSL2F11) sigma) = 12 :=
      heq.symm.trans hcentN
    rwa [Nat.card_eq_fintype_card] at hN
  have h := ConjClasses.card_carrier (G := PSL2F11) sigma
  calc Fintype.card (ConjClasses.mk sigma).carrier
      = Fintype.card PSL2F11 /
          Fintype.card (MulAction.stabilizer (ConjAct PSL2F11) sigma) := h
    _ = 660 / 12 := by rw [hG, hstab]
    _ = 55 := by decide

/-- `χ_Λ²` is a class function. -/
public theorem chiLambda2_isConj {g h : PSL2F11} (hc : IsConj g h) :
    chiLambda2 g = chiLambda2 h := by
  obtain ⟨c, rfl⟩ := isConj_iff.mp hc
  dsimp [chiLambda2]
  have hρ : ambientAct (c * g * c⁻¹) =
      ambientAct c ∘ₗ ambientAct g ∘ₗ ambientAct c⁻¹ := by
    rw [ambientAct_mul, ambientAct_mul, LinearMap.comp_assoc]
  rw [hρ]
  let e : (Module.End k Lambda2U)ˣ :=
    ⟨ambientAct c, ambientAct c⁻¹,
      by rw [Module.End.mul_eq_comp, ← ambientAct_mul, mul_inv_cancel, ambientAct_one]; rfl,
      by rw [Module.End.mul_eq_comp, ← ambientAct_mul, inv_mul_cancel, ambientAct_one]; rfl⟩
  -- tr(e * ρ(g) * e⁻¹) = tr(ρ(g)); identify e with ambientAct c
  have htr := LinearMap.trace_conj (R := k) (M := Lambda2U) (ambientAct g) e
  convert htr.symm
  simp only [Module.End.mul_eq_comp, Units.val_inv_eq_inv_val, Units.inv_mk]
  rfl

/-- Every order-2 element is conjugate to `σ`. -/
theorem isConj_sigma_of_order_two {g : PSL2F11} (hg : orderOf g = 2) :
    IsConj sigma g := by
  classical
  have hσ2 : orderOf sigma = 2 := orderOf_sigma_eq_two
  have hsub : (ConjClasses.mk sigma).carrier ⊆ {x : PSL2F11 | orderOf x = 2} := by
    intro x hx
    have hmk : ConjClasses.mk x = ConjClasses.mk sigma := mem_carrier_iff_mk_eq.mp hx
    have hc : IsConj sigma x := isConj_comm.mp ((mk_eq_mk_iff_isConj).mp hmk)
    obtain ⟨c, hc'⟩ := isConj_iff.mp hc
    change orderOf x = 2
    calc orderOf x
        = orderOf (c * sigma * c⁻¹) := by rw [hc']
      _ = orderOf sigma := orderOf_conj sigma c
      _ = 2 := hσ2
  have hcl := card_carrier_sigma
  have h2 : Fintype.card { x : PSL2F11 // orderOf x = 2 } = 55 :=
    PSLCard.card_psl_order_two
  let ι : (ConjClasses.mk sigma).carrier → { x : PSL2F11 // orderOf x = 2 } :=
    fun x => ⟨x.1, hsub x.2⟩
  have hι_inj : Function.Injective ι := by
    intro a b h
    apply Subtype.ext
    have : (ι a).val = (ι b).val := by rw [h]
    simpa [ι] using this
  have : Fintype.card (ConjClasses.mk sigma).carrier =
      Fintype.card { x : PSL2F11 // orderOf x = 2 } := by omega
  have hι_bi : Function.Bijective ι :=
    (Fintype.bijective_iff_injective_and_card ι).2 ⟨hι_inj, this⟩
  obtain ⟨y, hy⟩ := hι_bi.surjective ⟨g, hg⟩
  have hcar : g ∈ (ConjClasses.mk sigma).carrier := by
    have : (ι y).val = g := congrArg Subtype.val hy
    convert y.property
    exact this.symm
  have hmk : ConjClasses.mk g = ConjClasses.mk sigma := mem_carrier_iff_mk_eq.mp hcar
  exact isConj_comm.mp ((mk_eq_mk_iff_isConj).mp hmk)

/-- Order-2 ambient character equals the value at `σ`. -/
theorem chiLambda2_eq_of_order_two {g : PSL2F11} (hg : orderOf g = 2) :
    chiLambda2 g = chiLambda2 sigma :=
  (chiLambda2_isConj (isConj_sigma_of_order_two hg)).symm

/-! ### Character of `M = range(π)` and rank of the isotypic projector

Trace expansion: `tr(π) = (10/660) ∑ χ χ_Λ²` and `∑ χ χ_Λ² = 66 · finrank Msub`.
Open gate: evaluate `∑ χ χ_Λ² = 660` to get `finrank Msub = 10`. -/

/-- Character of the G-representation on `Msub`. -/
noncomputable def chiM (g : PSL2F11) : k :=
  LinearMap.trace k Msub
    ((ambientAct g).restrict (fun m hm => Msub_smul_mem g hm))

theorem chiM_one : chiM 1 = (Module.finrank k Msub : k) := by
  dsimp [chiM]
  have h1 : (ambientAct 1).restrict (fun m hm => Msub_smul_mem 1 hm) =
      (LinearMap.id : Msub →ₗ[k] Msub) := by
    ext x
    simp [LinearMap.restrict_apply, ambientAct_one]
  rw [h1, LinearMap.trace_id]

/-- On `Msub`, `T` acts as scalar `66`. -/
theorem chiSumOp_eq_sixty_six_on_Msub {m : Lambda2U} (hm : m ∈ Msub) :
    chiSumOp m = (66 : k) • m := by
  have hfix : projectorM m = m :=
    (mem_Mfix_iff (v := m)).mp (mem_Msub_iff_mem_Mfix.mp hm)
  exact chiSumOp_eq_sixty_six_of_mem_Mfix hfix

/-- Ambient character expansion: `tr(T) = ∑ χ χ_Λ²`. -/
theorem chiSumOp_trace :
    LinearMap.trace k Lambda2U chiSumOp =
      ∑ g : PSL2F11, chi10' g * chiLambda2 g := by
  classical
  dsimp [chiSumOp, chiLambda2]
  rw [map_sum]
  refine Finset.sum_congr rfl fun g _ => ?_
  rw [(LinearMap.trace k Lambda2U).map_smul]
  rfl

/-- Pointwise `T v = 66 · π v` lifts to equal traces via matrix representations. -/
theorem chiSumOp_trace_eq_sixty_six_finrank :
    LinearMap.trace k Lambda2U chiSumOp =
      (66 : k) * (Module.finrank k Msub : k) := by
  classical
  haveI : Module.Free k Lambda2U := inferInstance
  haveI : Module.Finite k Lambda2U := inferInstance
  let b := Module.Free.chooseBasis k Lambda2U
  have hmat :
      LinearMap.toMatrix b b chiSumOp =
        LinearMap.toMatrix b b ((66 : k) • projectorM) := by
    ext i j
    simp only [LinearMap.toMatrix_apply, LinearMap.smul_apply]
    rw [chiSumOp_eq_smul_projectorM, map_smul, Finsupp.coe_smul, Pi.smul_apply]
  have htrT :
      LinearMap.trace k Lambda2U chiSumOp =
        LinearMap.trace k Lambda2U ((66 : k) • projectorM) := by
    rw [LinearMap.trace_eq_matrix_trace k b chiSumOp,
      LinearMap.trace_eq_matrix_trace k b ((66 : k) • projectorM), hmat]
  rw [htrT, (LinearMap.trace k Lambda2U).map_smul, projectorM_trace_eq_finrank]
  rfl

/-- Weighted ambient character sum equals `66 · finrank Msub`. -/
theorem sum_chi_chiLambda2 :
    (∑ g : PSL2F11, chi10' g * chiLambda2 g) =
      (66 : k) * (Module.finrank k Msub : k) := by
  rw [← chiSumOp_trace, chiSumOp_trace_eq_sixty_six_finrank]

/-- `tr(π) = (10/660) ∑_g χ(g) χ_Λ²(g)`. -/
theorem projectorM_trace_eq_scaled_sum :
    LinearMap.trace k Lambda2U projectorM =
      (10 * (660 : k)⁻¹) * ∑ g : PSL2F11, chi10' g * chiLambda2 g := by
  classical
  haveI : Module.Free k Lambda2U := inferInstance
  haveI : Module.Finite k Lambda2U := inferInstance
  let b := Module.Free.chooseBasis k Lambda2U
  have hmat :
      LinearMap.toMatrix b b projectorM =
        LinearMap.toMatrix b b ((10 * (660 : k)⁻¹) • chiSumOp) := by
    ext i j
    simp only [LinearMap.toMatrix_apply, LinearMap.smul_apply]
    rw [projectorM_eq_smul_chiSumOp, map_smul, Finsupp.coe_smul, Pi.smul_apply]
  have htr :
      LinearMap.trace k Lambda2U projectorM =
        LinearMap.trace k Lambda2U ((10 * (660 : k)⁻¹) • chiSumOp) := by
    rw [LinearMap.trace_eq_matrix_trace k b projectorM,
      LinearMap.trace_eq_matrix_trace k b ((10 * (660 : k)⁻¹) • chiSumOp), hmat]
  rw [htr, (LinearMap.trace k Lambda2U).map_smul, chiSumOp_trace]
  rfl

/-- Scalar identity: `(10/660) * 660 = 10`. -/
theorem ten_div_sixsixty_mul_sixsixty :
    (10 * (660 : k)⁻¹) * 660 = 10 := by
  have h660 : (660 : k) ≠ 0 := by norm_num
  calc (10 * (660 : k)⁻¹) * 660
      = 10 * ((660 : k)⁻¹ * 660) := by ring
    _ = 10 * 1 := by rw [inv_mul_cancel₀ h660]
    _ = 10 := by ring

/-- If the weighted ambient sum is `660`, then `finrank Msub = 10`. -/
public theorem finrank_Msub_eq_ten_of_sum_chi_chiLambda2
    (hsum : (∑ g : PSL2F11, chi10' g * chiLambda2 g) = (660 : k)) :
    Module.finrank k Msub = 10 := by
  have htr : LinearMap.trace k Lambda2U projectorM = (10 : k) := by
    rw [projectorM_trace_eq_scaled_sum, hsum, ten_div_sixsixty_mul_sixsixty]
  have : (Module.finrank k Msub : k) = (10 : k) := by
    rw [← projectorM_trace_eq_finrank, htr]
  exact Nat.cast_injective (R := k) this

/-! ### L = k[J] module structure and tr(J) = 0

`Jlin² = -id` and `¬IsSquare(-1)` ⇒ `X²+1` irreducible. Adjoin root `i` and equip
`U` with the `L`-module structure via `i • u = Jlin u`. Power-basis smulTower shows
the matrix of `Jlin` is block-diagonal of `[[0,-1],[1,0]]` blocks, so `tr(Jlin)=0`.
-/

public theorem irr_X_sq_add_one : Irreducible ((X : k[X]) ^ 2 + C (1 : k)) := by
  have heq : (X : k[X]) ^ 2 + C 1 = X ^ 2 - C (-1 : k) := by
    ext n; simp [sub_eq_add_neg]
  rw [heq]
  exact (X_pow_sub_C_irreducible_iff_of_prime (by decide : Nat.Prime 2)
      (a := (-1 : k))).2 fun b hb =>
    not_isSquare_neg_one ⟨b, by simpa [pow_two] using hb.symm⟩

@[expose] public instance fact_irr_X2p1 : Fact (Irreducible ((X : k[X]) ^ 2 + C (1 : k))) :=
  ⟨irr_X_sq_add_one⟩

/-- `L = k[i] = k[X]/(X²+1)`. -/
public abbrev Ladj : Type := AdjoinRoot ((X : k[X]) ^ 2 + C (1 : k))
@[expose] public def iRoot : Ladj := root ((X : k[X]) ^ 2 + C (1 : k))

public theorem aeval_iRoot : aeval iRoot ((X : k[X]) ^ 2 + C (1 : k)) = 0 :=
  (aeval_eq (f := (X : k[X]) ^ 2 + C 1) (p := (X : k[X]) ^ 2 + C 1)).trans
    (mk_self (f := (X : k[X]) ^ 2 + C 1))

theorem monic_X2p1 : ((X : k[X]) ^ 2 + C (1 : k)).Monic :=
  monic_X_pow_add_C (1 : k) (by decide : (2 : ℕ) ≠ 0)

theorem minpoly_iRoot : minpoly k iRoot = (X : k[X]) ^ 2 + C 1 :=
  (minpoly.eq_of_irreducible_of_monic irr_X_sq_add_one aeval_iRoot monic_X2p1).symm

theorem nextCoeff_X2p1 : nextCoeff ((X : k[X]) ^ 2 + C (1 : k)) = 0 := by
  have hdeg : natDegree ((X : k[X]) ^ 2 + C 1) = 2 := natDegree_X_pow_add_C
  unfold nextCoeff
  rw [hdeg]
  simp only [OfNat.ofNat_ne_zero, ite_false]
  change ((X : k[X]) ^ 2 + C (1 : k)).coeff 1 = 0
  rw [coeff_add, coeff_X_pow, if_neg (by decide : (1 : ℕ) ≠ 2)]
  rw [coeff_C, if_neg (by decide : (1 : ℕ) ≠ 0)]
  simp

theorem algebra_trace_iRoot : Algebra.trace k Ladj iRoot = 0 := by
  let hpb := powerBasis (K := k) (f := (X : k[X]) ^ 2 + C (1 : k))
    irr_X_sq_add_one.ne_zero
  have hgen : hpb.gen = iRoot := rfl
  have htr := PowerBasis.trace_gen_eq_nextCoeff_minpoly hpb
  calc Algebra.trace k Ladj iRoot
      = Algebra.trace k Ladj hpb.gen := by rw [hgen]
    _ = - (minpoly k hpb.gen).nextCoeff := htr
    _ = - (minpoly k iRoot).nextCoeff := by rw [hgen]
    _ = - nextCoeff ((X : k[X]) ^ 2 + C 1) := by rw [minpoly_iRoot]
    _ = 0 := by rw [nextCoeff_X2p1, neg_zero]

public theorem algebraMap_end_commute (r : k) :
    Commute (algebraMap k (Module.End k U) r) (Jlin : Module.End k U) := by
  rw [commute_iff_eq]
  ext u
  simp only [Algebra.algebraMap_eq_smul_one, Module.End.mul_eq_comp,
    LinearMap.comp_apply, LinearMap.smul_apply, Module.End.one_eq_id,
    LinearMap.id_apply, map_smul]

@[expose] public noncomputable def eval₂Jlin : k[X] →+* Module.End k U :=
  eval₂RingHom' (algebraMap k (Module.End k U)) Jlin algebraMap_end_commute

theorem eval₂Jlin_X2p1 : eval₂Jlin ((X : k[X]) ^ 2 + C 1) = 0 := by
  change eval₂ (algebraMap k (Module.End k U)) Jlin ((X : k[X]) ^ 2 + C 1) = 0
  have h : eval₂ (algebraMap k (Module.End k U)) Jlin ((X : k[X]) ^ 2 + C 1) =
      (Jlin : Module.End k U) ^ 2 + algebraMap k (Module.End k U) 1 := by
    simp only [eval₂_add, eval₂_X_pow, eval₂_C]
  rw [h, map_one]
  have hpow : (Jlin : Module.End k U) ^ 2 = -1 := by
    rw [pow_two, Module.End.mul_eq_comp, Jlin_sq]
    ext x; simp [Module.End.one_eq_id]
  rw [hpow]
  ext x; simp [Module.End.one_eq_id]

public theorem eval₂Jlin_span_eq_zero :
    ∀ g : k[X], g ∈ Ideal.span {((X : k[X]) ^ 2 + C (1 : k))} → eval₂Jlin g = 0 := by
  intro g hg
  obtain ⟨h, rfl⟩ := Ideal.mem_span_singleton.mp hg
  rw [map_mul, eval₂Jlin_X2p1, zero_mul]

public abbrev Ipoly : Ideal k[X] := Ideal.span {((X : k[X]) ^ 2 + C (1 : k))}

@[expose] public noncomputable def LtoEndQuot : (k[X] ⧸ Ipoly) →+* Module.End k U :=
  Ideal.Quotient.lift Ipoly eval₂Jlin eval₂Jlin_span_eq_zero

@[expose] public noncomputable def LtoEnd : Ladj →+* Module.End k U := LtoEndQuot

theorem LtoEnd_root : LtoEnd iRoot = Jlin := by
  show LtoEndQuot (Ideal.Quotient.mk Ipoly X) = Jlin
  rw [LtoEndQuot, Ideal.Quotient.lift_mk]
  exact eval₂_X (algebraMap k (Module.End k U)) Jlin

public theorem LtoEnd_of (r : k) :
    LtoEnd (algebraMap k Ladj r) = algebraMap k (Module.End k U) r := by
  show LtoEndQuot (Ideal.Quotient.mk Ipoly (C r)) = algebraMap k (Module.End k U) r
  rw [LtoEndQuot, Ideal.Quotient.lift_mk]
  change eval₂ (algebraMap k (Module.End k U)) Jlin (C r) =
    algebraMap k (Module.End k U) r
  rw [eval₂_C]

@[expose] public instance moduleL_U : Module Ladj U := Module.compHom U LtoEnd

@[expose] public instance isScalarTower_kLU : IsScalarTower k Ladj U where
  smul_assoc r l u := by
    have hdef : (r • l : Ladj) = algebraMap k Ladj r * l := Algebra.smul_def r l
    show LtoEnd (r • l) u = r • (LtoEnd l u)
    rw [hdef, map_mul, LtoEnd_of]
    show (algebraMap k (Module.End k U) r * LtoEnd l) u = r • LtoEnd l u
    rw [Algebra.algebraMap_eq_smul_one, Module.End.mul_eq_comp]
    simp only [LinearMap.comp_apply, LinearMap.smul_apply, Module.End.one_eq_id,
      LinearMap.id_apply]

theorem finrank_Ladj : Module.finrank k Ladj = 2 := by
  let hpb := powerBasis (K := k) (f := (X : k[X]) ^ 2 + C 1) irr_X_sq_add_one.ne_zero
  have h : Module.finrank k (AdjoinRoot ((X : k[X]) ^ 2 + C 1)) = hpb.dim := hpb.finrank
  have hdim : hpb.dim = 2 := by
    change ((X : k[X]) ^ 2 + C 1).natDegree = 2
    exact natDegree_X_pow_add_C
  exact h.trans hdim

@[expose] public instance instFreeLadj : Module.Free k Ladj := Module.Free.of_basis
  (powerBasis (K := k) (f := (X : k[X]) ^ 2 + C 1) irr_X_sq_add_one.ne_zero).basis

@[expose] public instance instFiniteLadj : Module.Finite k Ladj := Module.Finite.of_basis
  (powerBasis (K := k) (f := (X : k[X]) ^ 2 + C 1) irr_X_sq_add_one.ne_zero).basis

@[expose] public instance instFreeLadjU : Module.Free Ladj U := Module.Free.of_divisionRing Ladj U

public theorem finrank_Ladj_U : Module.finrank Ladj U = 3 := by
  have hmul : Module.finrank k Ladj * Module.finrank Ladj U = Module.finrank k U :=
    Module.finrank_mul_finrank k Ladj U
  have hU : Module.finrank k U = 6 := GeometricFanoCarrier.finrank_U
  have hL : Module.finrank k Ladj = 2 := finrank_Ladj
  have h : 2 * Module.finrank Ladj U = 6 := by
    calc 2 * Module.finrank Ladj U
        = Module.finrank k Ladj * Module.finrank Ladj U := by rw [hL]
      _ = Module.finrank k U := hmul
      _ = 6 := hU
  exact Nat.eq_of_mul_eq_mul_left (by decide : 0 < 2) h

@[expose] public instance instFiniteLadjU : Module.Finite Ladj U :=
  Module.finite_of_finrank_eq_succ (n := 2) (by rw [finrank_Ladj_U])

theorem iRoot_smul_eq_Jlin (u : U) : iRoot • u = Jlin u := by
  change LtoEnd iRoot u = Jlin u
  rw [LtoEnd_root]

theorem iRoot_mul_self : iRoot * iRoot = (-1 : Ladj) := by
  have h0 : iRoot ^ 2 + (1 : Ladj) = 0 := by
    simpa [map_add, map_pow, map_one, aeval_X] using aeval_iRoot
  have : iRoot ^ 2 = -1 := eq_neg_of_add_eq_zero_left h0
  rwa [pow_two] at this

noncomputable def pbL : PowerBasis k Ladj :=
  powerBasis (K := k) (f := (X : k[X]) ^ 2 + C 1) irr_X_sq_add_one.ne_zero

theorem pbL_gen : pbL.gen = iRoot := rfl

theorem pbL_dim : pbL.dim = 2 := by
  change ((X : k[X]) ^ 2 + C 1).natDegree = 2
  exact natDegree_X_pow_add_C

noncomputable def bL2 : Basis (Fin 2) k Ladj :=
  pbL.basis.reindex (finCongr pbL_dim)

theorem bL2_zero : bL2 0 = (1 : Ladj) := by
  simp only [bL2, Basis.reindex_apply]
  have heq : (finCongr pbL_dim).symm (0 : Fin 2) =
      ⟨0, by rw [pbL_dim]; decide⟩ := Fin.ext (by simp)
  rw [heq, pbL.basis_eq_pow, pow_zero]

theorem bL2_one : bL2 1 = iRoot := by
  simp only [bL2, Basis.reindex_apply]
  have heq : (finCongr pbL_dim).symm (1 : Fin 2) =
      ⟨1, by rw [pbL_dim]; decide⟩ := Fin.ext (by simp)
  rw [heq, pbL.basis_eq_pow, pbL_gen, pow_one]

theorem bL2_eq_zero (h : (0 : ℕ) < 2) : bL2 ⟨0, h⟩ = (1 : Ladj) := by
  convert bL2_zero <;> rfl

theorem bL2_eq_one (h : (1 : ℕ) < 2) : bL2 ⟨1, h⟩ = iRoot := by
  convert bL2_one <;> rfl

noncomputable def jTraceBasisU :
    Basis (Module.Free.ChooseBasisIndex Ladj U) Ladj U :=
  Module.Free.chooseBasis Ladj U

noncomputable def jTraceBasis :
    Basis (Fin 2 × Module.Free.ChooseBasisIndex Ladj U) k U :=
  bL2.smulTower jTraceBasisU

theorem jTraceBasis_apply (i : Fin 2) (x : Module.Free.ChooseBasisIndex Ladj U) :
    jTraceBasis (i, x) = bL2 i • (jTraceBasisU x : U) := by
  exact Basis.smulTower_apply bL2 jTraceBasisU (i, x)

theorem Jlin_diag_zero_zero (x : Module.Free.ChooseBasisIndex Ladj U) :
    LinearMap.toMatrix jTraceBasis jTraceBasis Jlin (0, x) (0, x) = 0 := by
  rw [LinearMap.toMatrix_apply]
  have hJ : Jlin (jTraceBasis (0, x)) =
      (iRoot * bL2 0) • (jTraceBasisU x : U) := by
    rw [jTraceBasis_apply, ← iRoot_smul_eq_Jlin, smul_smul]
  rw [hJ, bL2_zero, mul_one]
  have hbx : iRoot • (jTraceBasisU x : U) = jTraceBasis ((1 : Fin 2), x) := by
    rw [jTraceBasis_apply, bL2_one]
  rw [hbx, Basis.repr_self]
  exact Finsupp.single_eq_of_ne (fun h => by cases h)

theorem Jlin_diag_zero_one (x : Module.Free.ChooseBasisIndex Ladj U) :
    LinearMap.toMatrix jTraceBasis jTraceBasis Jlin (1, x) (1, x) = 0 := by
  rw [LinearMap.toMatrix_apply]
  have hJ : Jlin (jTraceBasis (1, x)) =
      (iRoot * bL2 1) • (jTraceBasisU x : U) := by
    rw [jTraceBasis_apply, ← iRoot_smul_eq_Jlin, smul_smul]
  rw [hJ, bL2_one, iRoot_mul_self]
  have hbx : ((-1 : Ladj) • (jTraceBasisU x : U)) =
      -jTraceBasis ((0 : Fin 2), x) := by
    rw [neg_one_smul, jTraceBasis_apply, bL2_zero, one_smul]
  rw [hbx, map_neg, Basis.repr_self]
  have hne : ((0 : Fin 2), x) ≠ ((1 : Fin 2), x) := fun h => by cases h
  simpa using Finsupp.single_eq_of_ne (a := ((0 : Fin 2), x)) (b := ((1 : Fin 2), x))
    (v := (1 : k)) hne

theorem Jlin_diag_zero (i : Fin 2) (x : Module.Free.ChooseBasisIndex Ladj U) :
    LinearMap.toMatrix jTraceBasis jTraceBasis Jlin (i, x) (i, x) = 0 := by
  fin_cases i
  · exact Jlin_diag_zero_zero x
  · exact Jlin_diag_zero_one x

/-- Trace of `Jlin` is zero. -/
theorem Jlin_trace : LinearMap.trace k U Jlin = 0 := by
  rw [LinearMap.trace_eq_matrix_trace k jTraceBasis Jlin, Matrix.trace]
  simp_rw [Matrix.diag_apply]
  exact Finset.sum_eq_zero fun ij _ => Jlin_diag_zero ij.1 ij.2

/-! ### χ_Λ²(σ) = 3 via Newton exterior identity

`tr(Λ² f) = (tr f)²/2 - tr(f²)/2`. For `f = Jlin`: `tr J = 0`, `tr(J²) = -6`
⇒ `χ_Λ²(σ) = 3`. Conjugacy of involutions lifts this to every order-2 element.
-/

theorem ambientAct_sigma_eq_map_Jlin :
    ambientAct sigma = exteriorPower.map 2 Jlin := by
  rw [ambientAct_sigma]; rfl

theorem Jlin_comp_trace : LinearMap.trace k U (Jlin ∘ₗ Jlin) = (-6 : k) := by
  rw [Jlin_sq]
  have hneg := map_neg (LinearMap.trace k U) (LinearMap.id : Module.End k U)
  rw [hneg, LinearMap.trace_id, GeometricFanoCarrier.finrank_U]
  norm_num

theorem matrix_trace_sq_sub_sq {ι : Type*} [Fintype ι] [DecidableEq ι]
    (A : Matrix ι ι k) :
    (A.trace) ^ 2 - (A * A).trace =
      ∑ i : ι, ∑ j : ι,
        if i = j then (0 : k) else (A i i * A j j - A i j * A j i) := by
  have htr2 : (A.trace) ^ 2 = ∑ i : ι, ∑ j : ι, A i i * A j j := by
    simp only [Matrix.trace, pow_two]; exact Finset.sum_mul_sum _ _ _ _
  have hA2 : (A * A).trace = ∑ i : ι, ∑ j : ι, A i j * A j i := by
    simp only [Matrix.trace]
    refine Finset.sum_congr rfl fun i _ => ?_
    change (A * A) i i = ∑ j, A i j * A j i; rw [Matrix.mul_apply]
  rw [htr2, hA2]; simp only [← Finset.sum_sub_distrib]
  refine Finset.sum_congr rfl fun i _ => Finset.sum_congr rfl fun j _ => ?_
  split_ifs with h <;> [simp [h]; ring]

theorem matrix_sum_off_diag_symm {ι : Type*} [Fintype ι] [DecidableEq ι] [LinearOrder ι]
    (f : ι → ι → k) (hf : ∀ i j, f i j = f j i) :
    (∑ i : ι, ∑ j : ι, if i = j then (0 : k) else f i j) =
      (2 : k) * ∑ i : ι, ∑ j : ι, if i < j then f i j else (0 : k) := by
  have hpt (i j : ι) :
      (if i = j then (0 : k) else f i j) =
        (if i < j then f i j else (0 : k)) +
        (if j < i then f i j else (0 : k)) := by
    rcases lt_trichotomy i j with h | rfl | h
    · rw [if_neg (ne_of_lt h), if_pos h, if_neg (lt_asymm h), add_zero]
    · simp only [lt_irrefl, ↓reduceIte, add_zero]
    · rw [if_neg (ne_of_gt h), if_neg (lt_asymm h), if_pos h, zero_add]
  rw [Finset.sum_congr rfl fun i _ => Finset.sum_congr rfl fun j _ => hpt i j]
  simp only [Finset.sum_add_distrib]
  have hswap :
      (∑ i : ι, ∑ j : ι, if j < i then f i j else (0 : k)) =
        (∑ i : ι, ∑ j : ι, if i < j then f i j else (0 : k)) := by
    rw [Finset.sum_comm]
    refine Finset.sum_congr rfl fun i _ => Finset.sum_congr rfl fun j _ => ?_
    by_cases h : i < j <;> simp [h, hf]
  rw [hswap, two_mul]

theorem exterior_repr_map_eq_det
    {ι : Type*} [LinearOrder ι] [Fintype ι] [DecidableEq ι]
    {V : Type*} [AddCommGroup V] [Module k V]
    (b : Basis ι k V) (f : Module.End k V)
    (s : powersetCard ι 2) :
    (b.exteriorPower (n := 2)).repr
        (exteriorPower.map 2 f (b.exteriorPower (n := 2) s)) s =
      ((LinearMap.toMatrix b b f).submatrix
        (powersetCard.ofFinEmbEquiv.symm s)
        (powersetCard.ofFinEmbEquiv.symm s)).det := by
  set B := b.exteriorPower (n := 2)
  set emb := powersetCard.ofFinEmbEquiv.symm s
  have hBs : B s = exteriorPower.ιMulti_family k 2 (b : ι → V) s := by
    simp only [B]; exact exteriorPower.basis_apply (R := k) (n := 2) b s
  rw [hBs, exteriorPower.basis_repr_apply (R := k) (n := 2) b]
  have hmap :
      exteriorPower.map 2 f (exteriorPower.ιMulti_family k 2 (b : ι → V) s) =
        exteriorPower.ιMulti k 2 (fun i : Fin 2 => f (b (emb i))) := by
    dsimp [exteriorPower.ιMulti_family, emb]; rw [exteriorPower.map_apply_ιMulti]; rfl
  rw [hmap, exteriorPower.ιMultiDual_apply_ιMulti (R := k) (n := 2) b s]
  have hT :
      (Matrix.of fun i j : Fin 2 => b.coord (emb j) (f (b (emb i)))) =
        ((LinearMap.toMatrix b b f).submatrix emb emb)ᵀ := by
    ext i j
    simp [Matrix.transpose_apply, Matrix.of_apply, Matrix.submatrix_apply,
      LinearMap.toMatrix_apply, Basis.coord_apply]
  rw [hT, Matrix.det_transpose]

theorem det_submatrix_emb {ι : Type*} [DecidableEq ι]
    (M : Matrix ι ι k) (emb : Fin 2 → ι) :
    (M.submatrix emb emb).det =
      M (emb 0) (emb 0) * M (emb 1) (emb 1) -
        M (emb 0) (emb 1) * M (emb 1) (emb 0) := by
  rw [Matrix.det_fin_two]
  simp [Matrix.submatrix_apply]

/-- Newton identity for the exterior square: `tr(Λ² f) = ((tr f)² - tr(f²))/2`. -/
public theorem trace_exterior_newton
    {V : Type*} [AddCommGroup V] [Module k V]
    [Module.Free k V] [Module.Finite k V]
    (f : Module.End k V) :
    LinearMap.trace k (⋀[k]^2 V) (exteriorPower.map 2 f) =
      (2 : k)⁻¹ * ((LinearMap.trace k V f) ^ 2 -
        LinearMap.trace k V (f ∘ₗ f)) := by
  classical
  let b0 := Module.Free.chooseBasis k V
  let n := Fintype.card (Module.Free.ChooseBasisIndex k V)
  let equivIdx : Module.Free.ChooseBasisIndex k V ≃ Fin n :=
    Fintype.equivFinOfCardEq rfl
  let b : Basis (Fin n) k V := b0.reindex equivIdx
  let B := b.exteriorPower (n := 2)
  let M := LinearMap.toMatrix b b f
  have htrB :
      LinearMap.trace k (⋀[k]^2 V) (exteriorPower.map 2 f) =
        ∑ s : powersetCard (Fin n) 2,
          B.repr (exteriorPower.map 2 f (B s)) s := by
    rw [LinearMap.trace_eq_matrix_trace k B (exteriorPower.map 2 f)]
    simp only [Matrix.trace, Matrix.diag_apply, LinearMap.toMatrix_apply]
  have hdet (s : powersetCard (Fin n) 2) :
      B.repr (exteriorPower.map 2 f (B s)) s =
        M ((powersetCard.ofFinEmbEquiv.symm s) 0)
            ((powersetCard.ofFinEmbEquiv.symm s) 0) *
          M ((powersetCard.ofFinEmbEquiv.symm s) 1)
            ((powersetCard.ofFinEmbEquiv.symm s) 1) -
        M ((powersetCard.ofFinEmbEquiv.symm s) 0)
            ((powersetCard.ofFinEmbEquiv.symm s) 1) *
          M ((powersetCard.ofFinEmbEquiv.symm s) 1)
            ((powersetCard.ofFinEmbEquiv.symm s) 0) := by
    have h := exterior_repr_map_eq_det b f s
    dsimp [M, B] at *
    rw [h, det_submatrix_emb]
  rw [htrB]; simp_rw [hdet]
  let detPair (i j : Fin n) : k := M i i * M j j - M i j * M j i
  have heq :
      (∑ s : powersetCard (Fin n) 2,
        detPair ((powersetCard.ofFinEmbEquiv.symm s) 0)
          ((powersetCard.ofFinEmbEquiv.symm s) 1)) =
      ∑ e : Fin 2 ↪o Fin n, detPair (e 0) (e 1) :=
    Fintype.sum_equiv
      (powersetCard.ofFinEmbEquiv (I := Fin n) (n := 2)).symm
      (fun s => detPair ((powersetCard.ofFinEmbEquiv.symm s) 0)
        ((powersetCard.ofFinEmbEquiv.symm s) 1))
      (fun e => detPair (e 0) (e 1))
      (fun _ => rfl)
  have hpairs :
      (∑ e : Fin 2 ↪o Fin n, detPair (e 0) (e 1)) =
      ∑ i : Fin n, ∑ j : Fin n, if i < j then detPair i j else (0 : k) := by
    classical
    let S : Finset (Fin n × Fin n) :=
      (Finset.univ ×ˢ Finset.univ).filter (fun p => p.1 < p.2)
    have hrhs :
        (∑ i : Fin n, ∑ j : Fin n, if i < j then detPair i j else (0 : k)) =
          ∑ p ∈ S, detPair p.1 p.2 := by
      calc (∑ i : Fin n, ∑ j : Fin n, if i < j then detPair i j else (0 : k))
          = ∑ p : Fin n × Fin n,
              if p.1 < p.2 then detPair p.1 p.2 else (0 : k) := by
            rw [← Finset.univ_product_univ, Finset.sum_product]
          _ = ∑ p ∈ S, detPair p.1 p.2 := by
            dsimp [S]; rw [Finset.sum_filter]
    rw [hrhs]
    refine Finset.sum_bij (fun e _ => ((e 0 : Fin n), (e 1 : Fin n)))
      (fun e _ => by
        simp only [S, Finset.mem_filter, Finset.mem_product, Finset.mem_univ, true_and]
        exact e.strictMono (by decide : (0 : Fin 2) < 1))
      (fun e₁ e₂ _ _ h => by
        apply RelEmbedding.ext; intro a
        fin_cases a
        · exact congrArg Prod.fst h
        · exact congrArg Prod.snd h)
      (fun p hp => by
        simp only [S, Finset.mem_filter, Finset.mem_product, Finset.mem_univ,
          true_and] at hp
        have hne : p.1 ≠ p.2 := ne_of_lt hp
        have hcard : ({p.1, p.2} : Finset (Fin n)).card = 2 := by
          rw [Finset.card_insert_of_notMem, Finset.card_singleton]
          simp [hne]
        have hpos : (0 : ℕ) < 2 := by decide
        refine ⟨Finset.orderEmbOfFin ({p.1, p.2} : Finset (Fin n)) hcard,
          Finset.mem_univ _, ?_⟩
        apply Prod.ext
        · change Finset.orderEmbOfFin _ hcard ⟨0, hpos⟩ = p.1
          rw [Finset.orderEmbOfFin_zero hcard hpos]
          have hneS : ({p.2} : Finset (Fin n)).Nonempty := Finset.singleton_nonempty _
          rw [Finset.min'_insert p.1 {p.2} hneS, Finset.min'_singleton,
            min_eq_left (le_of_lt hp)]
        · change Finset.orderEmbOfFin _ hcard ⟨1, by decide⟩ = p.2
          have hidx : (⟨1, by decide⟩ : Fin 2) =
              ⟨2 - 1, Nat.sub_lt hpos Nat.one_pos⟩ := rfl
          rw [hidx, Finset.orderEmbOfFin_last hcard hpos]
          have hneS : ({p.2} : Finset (Fin n)).Nonempty := Finset.singleton_nonempty _
          rw [Finset.max'_insert p.1 {p.2} hneS, Finset.max'_singleton,
            max_eq_right (le_of_lt hp)])
      (fun e _ => rfl)
  change ∑ s : powersetCard (Fin n) 2,
      detPair ((powersetCard.ofFinEmbEquiv.symm s) 0)
        ((powersetCard.ofFinEmbEquiv.symm s) 1) = _
  rw [heq, hpairs]
  have hnewton := matrix_trace_sq_sub_sq M
  have hsym : ∀ i j : Fin n, detPair i j = detPair j i := fun _ _ => by
    dsimp [detPair]; ring
  have hoff := matrix_sum_off_diag_symm detPair hsym
  have h2ne : (2 : k) ≠ 0 := by norm_num
  have hlt :
      (∑ i : Fin n, ∑ j : Fin n, if i < j then detPair i j else (0 : k)) =
        (2 : k)⁻¹ * ((M.trace) ^ 2 - (M * M).trace) := by
    have h1 :
        (∑ i : Fin n, ∑ j : Fin n, if i = j then (0 : k) else detPair i j) =
          (M.trace) ^ 2 - (M * M).trace := by
      trans (∑ i : Fin n, ∑ j : Fin n,
          if i = j then (0 : k) else (M i i * M j j - M i j * M j i))
      · refine Finset.sum_congr rfl fun i _ => Finset.sum_congr rfl fun j _ => ?_
        simp only [detPair]
      · exact hnewton.symm
    rw [eq_comm, inv_mul_eq_iff_eq_mul₀ h2ne, eq_comm, ← hoff, h1]
  rw [hlt]
  have htrM : M.trace = LinearMap.trace k V f :=
    (LinearMap.trace_eq_matrix_trace k b f).symm
  have htrM2 : (M * M).trace = LinearMap.trace k V (f ∘ₗ f) := by
    have hc : LinearMap.toMatrix b b (f ∘ₗ f) = M * M :=
      LinearMap.toMatrix_comp b b b f f
    rw [LinearMap.trace_eq_matrix_trace k b (f ∘ₗ f), hc]
  rw [htrM, htrM2]

/-- `χ_Λ²(σ) = 3`. -/
theorem chiLambda2_sigma : chiLambda2 sigma = 3 := by
  dsimp [chiLambda2]
  rw [ambientAct_sigma_eq_map_Jlin]
  have h := trace_exterior_newton (V := U) Jlin
  change LinearMap.trace k (⋀[k]^2 U) (exteriorPower.map 2 Jlin) = (3 : k)
  rw [h, Jlin_trace, Jlin_comp_trace]
  norm_num

/-- Every order-2 element has ambient character `3`. -/
theorem chiLambda2_eq_three_of_order_two {g : PSL2F11} (hg : orderOf g = 2) :
    chiLambda2 g = 3 := by
  rw [chiLambda2_eq_of_order_two hg, chiLambda2_sigma]

/-- Order-2 contribution to `∑ χ χ_Λ²` is `330`. -/
public theorem sum_chi_chiLambda2_order_two :
    (∑ g : {g : PSL2F11 // orderOf g = 2}, chi10' g.1 * chiLambda2 g.1) =
      (330 : k) := by
  classical
  have hcard : Fintype.card {g : PSL2F11 // orderOf g = 2} = 55 :=
    PSLCard.card_psl_order_two
  have hval : ∀ g : {g : PSL2F11 // orderOf g = 2},
      chi10' g.1 * chiLambda2 g.1 = (6 : k) := by
    intro g
    have ho : orderOf g.1 = 2 := g.2
    have hc : chi10' g.1 = 2 := by simp [chi10', ho]
    have hΛ : chiLambda2 g.1 = 3 := chiLambda2_eq_three_of_order_two ho
    rw [hc, hΛ]; norm_num
  calc (∑ g : {g : PSL2F11 // orderOf g = 2}, chi10' g.1 * chiLambda2 g.1)
      = ∑ g : {g : PSL2F11 // orderOf g = 2}, (6 : k) :=
        Finset.sum_congr rfl fun g _ => hval g
    _ = (Fintype.card {g : PSL2F11 // orderOf g = 2} : k) * 6 := by
        rw [Finset.sum_const, nsmul_eq_mul]; rfl
    _ = (55 : k) * 6 := by rw [hcard]; norm_num
    _ = 330 := by norm_num

/-- Identity contribution: `χ(1)·χ_Λ²(1) = 10·15 = 150`. -/
public theorem sum_chi_chiLambda2_order_one :
    chi10' (1 : PSL2F11) * chiLambda2 (1 : PSL2F11) = (150 : k) := by
  rw [chi10'_one, chiLambda2_one]; norm_num

/-- On order-5 elements, `χ₁₀' = 0`, so the weighted sum vanishes. -/
public theorem sum_chi_chiLambda2_order_five :
    (∑ g : {g : PSL2F11 // orderOf g = 5}, chi10' g.1 * chiLambda2 g.1) =
      (0 : k) := by
  classical
  refine Finset.sum_eq_zero fun g _ => ?_
  have ho : orderOf g.1 = 5 := g.2
  have hc : chi10' g.1 = 0 := by simp [chi10', ho]
  rw [hc, zero_mul]

/-- Identity + order-2 contributions sum to `480`. -/
theorem sum_chi_chiLambda2_orders_one_two :
    chi10' (1 : PSL2F11) * chiLambda2 (1 : PSL2F11) +
      (∑ g : {g : PSL2F11 // orderOf g = 2}, chi10' g.1 * chiLambda2 g.1) =
      (480 : k) := by
  rw [sum_chi_chiLambda2_order_one, sum_chi_chiLambda2_order_two]; norm_num


/-! ### Residual decomposition of `Rlin` and χ_Λ² on cyclic orders

`R⁶ + id = 0` factors as `(R²+id)(R⁴−R²+id)=0` with coprime factors, so
`U = residualKer ⊕ Wker`.  Irreducibility of `X⁴−X²+1` forces
`finrank residualKer = 2` and `finrank Wker = 4`, whence `tr(R)=tr(R²)=0`
and Newton gives `χ_Λ²=0` on orders 3 and 6.
-/

theorem aeval_Rlin_X6_add_one :
    aeval (Rlin : Module.End k U) ((X : k[X]) ^ 6 + 1) = 0 := by
  have h :
      aeval (Rlin : Module.End k U) ((X : k[X]) ^ 6 + 1) =
        (Rlin : Module.End k U) ^ 6 + LinearMap.id := by
    simp only [map_add, map_pow, map_one, aeval_X, Module.End.one_eq_id]
  rw [h, Rlin_pow_six_eq_neg_id]
  exact neg_add_cancel (LinearMap.id : Module.End k U)

theorem poly_ident_X4_X2 :
    (X ^ 4 - X ^ 2 + 1 : k[X]) - (X ^ 2 - 2) * (X ^ 2 + 1) = 3 := by
  ring

theorem isCoprime_X2p1_X4 :
    IsCoprime ((X : k[X]) ^ 2 + 1) (X ^ 4 - X ^ 2 + 1) := by
  have h3ne : (3 : k) ≠ 0 := by norm_num
  refine ⟨-C (3 : k)⁻¹ * (X ^ 2 - 2), C (3 : k)⁻¹, ?_⟩
  have hC3 : (3 : k[X]) = C (3 : k) := by simp only [map_ofNat]
  calc (-C (3 : k)⁻¹ * (X ^ 2 - 2)) * (X ^ 2 + 1) + C (3 : k)⁻¹ * (X ^ 4 - X ^ 2 + 1)
      = C (3 : k)⁻¹ * ((X ^ 4 - X ^ 2 + 1) - (X ^ 2 - 2) * (X ^ 2 + 1)) := by ring
    _ = C (3 : k)⁻¹ * (3 : k[X]) := by rw [poly_ident_X4_X2]
    _ = C (3 : k)⁻¹ * C (3 : k) := by rw [hC3]
    _ = C ((3 : k)⁻¹ * 3) := by rw [← map_mul]
    _ = C (1 : k) := by rw [inv_mul_cancel₀ h3ne]
    _ = 1 := by simp

theorem residualKer_eq_ker_X2 :
    residualKer =
      LinearMap.ker (aeval (Rlin : Module.End k U) ((X : k[X]) ^ 2 + 1)) := by
  ext u
  have haev :
      aeval (Rlin : Module.End k U) ((X : k[X]) ^ 2 + 1) =
        (Rlin : Module.End k U) ^ 2 + LinearMap.id := by
    simp only [map_add, map_pow, map_one, aeval_X, Module.End.one_eq_id]
  constructor
  · intro hu
    have : Rlin (Rlin u) + u = 0 := (mem_residualKer_iff).mp hu
    rw [LinearMap.mem_ker, haev, LinearMap.add_apply, pow_two, Module.End.mul_apply]
    exact this
  · intro hu
    rw [LinearMap.mem_ker, haev, LinearMap.add_apply, pow_two, Module.End.mul_apply] at hu
    exact (mem_residualKer_iff).mpr hu

/-- Complementary primary component `ker(R⁴ − R² + id)`. -/
noncomputable def Wker : Submodule k U :=
  LinearMap.ker (aeval (Rlin : Module.End k U) ((X : k[X]) ^ 4 - X ^ 2 + 1))

theorem residualKer_sup_Wker_eq_top :
    residualKer ⊔ Wker = (⊤ : Submodule k U) := by
  have hpq := isCoprime_X2p1_X4
  have hsup :=
    Polynomial.sup_ker_aeval_eq_ker_aeval_mul_of_coprime (Rlin : Module.End k U) hpq
  have hmul :
      ((X : k[X]) ^ 2 + 1) * (X ^ 4 - X ^ 2 + 1) = X ^ 6 + 1 :=
    (X6_add_one_factor).symm
  have htop :
      LinearMap.ker (aeval (Rlin : Module.End k U)
        (((X : k[X]) ^ 2 + 1) * (X ^ 4 - X ^ 2 + 1))) = ⊤ := by
    rw [hmul]
    ext u
    simp only [Submodule.mem_top, LinearMap.mem_ker, iff_true]
    exact LinearMap.congr_fun aeval_Rlin_X6_add_one u
  -- Unfold `Wker` so `hsup` matches the goal
  dsimp [Wker]
  rw [residualKer_eq_ker_X2, hsup, htop]

theorem residualKer_disjoint_Wker : Disjoint residualKer Wker := by
  dsimp [Wker]
  rw [residualKer_eq_ker_X2]
  exact Polynomial.disjoint_ker_aeval_of_isCoprime _ isCoprime_X2p1_X4

theorem isCompl_residualKer_Wker : IsCompl residualKer Wker := by
  refine ⟨residualKer_disjoint_Wker, ?_⟩
  exact codisjoint_iff.mpr residualKer_sup_Wker_eq_top

theorem not_dvd_X2p1_X4 :
    ¬ ((X : k[X]) ^ 2 + 1) ∣ (X ^ 4 - X ^ 2 + 1) := by
  rintro ⟨q, hq⟩
  -- 3 = (X⁴−X²+1) − (X²−2)(X²+1) = (X²+1)·(q − (X²−2))
  have h3 :
      (3 : k[X]) = (X ^ 2 + 1) * (q - (X ^ 2 - 2)) := by
    calc (3 : k[X])
        = (X ^ 4 - X ^ 2 + 1) - (X ^ 2 - 2) * (X ^ 2 + 1) :=
          poly_ident_X4_X2.symm
      _ = (X ^ 2 + 1) * q - (X ^ 2 - 2) * (X ^ 2 + 1) := by rw [hq]
      _ = (X ^ 2 + 1) * (q - (X ^ 2 - 2)) := by ring
  by_cases hz : q - (X ^ 2 - 2) = 0
  · -- then 3 = 0
    simp only [hz, mul_zero] at h3
    have hcoeff : (3 : k) = 0 := by
      have hc := congrArg (fun p : k[X] => p.coeff 0) h3
      simpa [coeff_zero, coeff_natCast_ite] using hc
    exact absurd hcoeff (by norm_num : (3 : k) ≠ 0)
  · -- deg RHS ≥ deg(X²+1) = 2 > 0 = deg 3
    have hne_left : (X ^ 2 + 1 : k[X]) ≠ 0 := by
      intro h0
      have := congrArg (fun p : k[X] => p.coeff 0) h0
      simp [coeff_X_pow, coeff_one, coeff_add] at this
    have hdegR :
        ((X ^ 2 + 1 : k[X]) * (q - (X ^ 2 - 2))).natDegree =
          ((X ^ 2 + 1 : k[X]).natDegree) + (q - (X ^ 2 - 2)).natDegree :=
      natDegree_mul hne_left hz
    have hdegX2 : ((X : k[X]) ^ 2 + 1).natDegree = 2 := by
      have h1 : (1 : k[X]) = C (1 : k) := by simp
      rw [h1]; exact natDegree_X_pow_add_C
    have hdeg3 : (3 : k[X]).natDegree = 0 := natDegree_natCast 3
    have : 2 ≤ (3 : k[X]).natDegree := by
      calc 2 = ((X : k[X]) ^ 2 + 1).natDegree := hdegX2.symm
        _ ≤ ((X : k[X]) ^ 2 + 1).natDegree + (q - (X ^ 2 - 2)).natDegree :=
            Nat.le_add_right _ _
        _ = ((X ^ 2 + 1 : k[X]) * (q - (X ^ 2 - 2))).natDegree := hdegR.symm
        _ = (3 : k[X]).natDegree := by rw [← h3]
    omega

theorem no_root_X4_sub_X2_add_one (α : k) :
    ¬ IsRoot ((X : k[X]) ^ 4 - X ^ 2 + 1) α := by
  intro h
  have ha : aeval α ((X : k[X]) ^ 4 - X ^ 2 + 1) = 0 := by
    simpa [IsRoot.def] using h
  have h6 : α ^ 6 + 1 = 0 := by
    have : aeval α ((X : k[X]) ^ 6 + 1) = 0 := by
      rw [X6_add_one_factor, map_mul, ha, mul_zero]
    simpa [map_add, map_pow, map_one, aeval_X] using this
  exact no_sixth_root_neg_one (eq_neg_of_add_eq_zero_left h6)

theorem not_exists_monic_quad_dvd_X4 :
    ¬ ∃ f : k[X], f.Monic ∧ f.natDegree = 2 ∧ f ∣ (X ^ 4 - X ^ 2 + 1) := by
  rintro ⟨f, hmon, hdeg, hdiv⟩
  have hdiv6 : f ∣ ((X : k[X]) ^ 6 + 1) := by
    rw [X6_add_one_factor]
    exact hdiv.trans (dvd_mul_left _ _)
  have hf := monic_quad_dvd_X6_eq_X2_add_one f hmon hdeg hdiv6
  rw [hf] at hdiv
  exact not_dvd_X2p1_X4 hdiv

theorem irreducible_X4_sub_X2_add_one :
    Irreducible ((X : k[X]) ^ 4 - X ^ 2 + 1) := by
  classical
  have hmon : ((X : k[X]) ^ 4 - X ^ 2 + 1).Monic := monic_X4_sub_X2_add_one
  have hdeg : ((X : k[X]) ^ 4 - X ^ 2 + 1).natDegree = 4 :=
    natDegree_X4_sub_X2_add_one
  have hne1 : ((X : k[X]) ^ 4 - X ^ 2 + 1) ≠ 1 := by
    intro h
    have := congrArg natDegree h
    simp only [hdeg, natDegree_one] at this
    omega
  rw [hmon.irreducible_iff_lt_natDegree_lt hne1]
  intro q hqmon hqdeg hdiv
  have hmem : 0 < q.natDegree ∧ q.natDegree ≤ 2 := by
    have : q.natDegree ∈ Finset.Ioc 0 (4 / 2) := by simpa [hdeg] using hqdeg
    simpa [Finset.mem_Ioc] using this
  have hq0 : q ≠ 0 := hqmon.ne_zero
  match hqd : q.natDegree with
  | 0 => omega
  | 1 =>
    have hdeg1 : degree q = 1 := (degree_eq_iff_natDegree_eq hq0).2 hqd
    obtain ⟨α, hα⟩ := exists_root_of_degree_eq_one hdeg1
    have hroot : IsRoot ((X : k[X]) ^ 4 - X ^ 2 + 1) α := by
      have : aeval α ((X : k[X]) ^ 4 - X ^ 2 + 1) = 0 :=
        aeval_eq_zero_of_dvd_aeval_eq_zero hdiv (by simpa [IsRoot.def] using hα)
      simpa [IsRoot.def] using this
    exact no_root_X4_sub_X2_add_one α hroot
  | 2 =>
    exact not_exists_monic_quad_dvd_X4 ⟨q, hqmon, hqd, hdiv⟩
  | n + 3 =>
    omega

theorem aeval_Rlin_X4_eq :
    aeval (Rlin : Module.End k U) ((X : k[X]) ^ 4 - X ^ 2 + 1) =
      (Rlin : Module.End k U) ^ 4 - Rlin ^ 2 + LinearMap.id := by
  simp only [map_add, map_sub, map_pow, map_one, aeval_X, Module.End.one_eq_id]

theorem Rlin_mem_Wker {u : U} (hu : u ∈ Wker) : Rlin u ∈ Wker := by
  dsimp [Wker] at hu ⊢
  rw [LinearMap.mem_ker] at hu ⊢
  -- aeval R p (R u) = R (aeval R p u) = R 0 = 0
  have hcomm :
      aeval (Rlin : Module.End k U) ((X : k[X]) ^ 4 - X ^ 2 + 1) (Rlin u) =
        Rlin (aeval (Rlin : Module.End k U) ((X : k[X]) ^ 4 - X ^ 2 + 1) u) := by
    rw [aeval_Rlin_X4_eq]
    -- expand (R⁴ − R² + id)(R u) = R((R⁴ − R² + id)u)
    have e (n : ℕ) :
        ((Rlin : Module.End k U) ^ n) (Rlin u) = Rlin ((Rlin ^ n) u) := by
      have hc : Commute (Rlin : Module.End k U) Rlin := Commute.refl _
      rw [← Module.End.mul_apply, (hc.pow_left n).eq]
      rfl
    simp only [LinearMap.add_apply, LinearMap.sub_apply, LinearMap.id_apply, e,
      map_add, map_sub]
  rw [hcomm, hu, map_zero]

theorem Wker_ne_bot : Wker ≠ (⊥ : Submodule k U) := by
  intro hbot
  have htop : residualKer = ⊤ := by
    have : residualKer ⊔ Wker = ⊤ := residualKer_sup_Wker_eq_top
    rwa [hbot, sup_bot_eq] at this
  exact residualKer_ne_top htop

/-- The polynomial annihilating the non-residual primary component. -/
abbrev pW : k[X] := (X : k[X]) ^ 4 - X ^ 2 + (1 : k[X])

/-- If `residualKer = ⊥` then `aeval R pW = 0` on all of `U`. -/
theorem aeval_Rlin_pW_of_residual_bot (hbot : residualKer = ⊥) :
    aeval (Rlin : Module.End k U) pW = 0 := by
  have hW : Wker = ⊤ := by
    have : residualKer ⊔ Wker = ⊤ := residualKer_sup_Wker_eq_top
    rwa [hbot, bot_sup_eq] at this
  apply LinearMap.ext
  intro u
  have hu : u ∈ Wker := by rw [hW]; trivial
  dsimp [Wker] at hu
  have h := LinearMap.mem_ker.mp hu
  simpa [pW] using h


/-- `residualKer ≠ ⊥`: otherwise `U` is a module over `k[X]/(X⁴−X²+1)` of degree 4,
so `4 ∣ finrank U = 6`, contradiction. -/
theorem residualKer_ne_bot : residualKer ≠ (⊥ : Submodule k U) := by
  intro hbot
  haveI : Module.Finite k U := inferInstance
  haveI : Module.Free k U := inferInstance
  have hann : aeval (Rlin : Module.End k U) pW = 0 :=
    aeval_Rlin_pW_of_residual_bot hbot
  let L := AdjoinRoot pW
  haveI : Fact (Irreducible pW) := ⟨irreducible_X4_sub_X2_add_one⟩
  have hcomm (r : k) :
      Commute (algebraMap k (Module.End k U) r) (Rlin : Module.End k U) := by
    rw [commute_iff_eq]; ext u
    simp only [Algebra.algebraMap_eq_smul_one, Module.End.mul_eq_comp,
      LinearMap.comp_apply, LinearMap.smul_apply, Module.End.one_eq_id,
      LinearMap.id_apply, map_smul]
  let eval₂R : k[X] →+* Module.End k U :=
    eval₂RingHom' (algebraMap k (Module.End k U)) Rlin hcomm
  have heval0 : eval₂R pW = 0 := by
    change eval₂ (algebraMap k (Module.End k U)) Rlin pW = 0
    have : aeval (Rlin : Module.End k U) pW =
        eval₂ (algebraMap k (Module.End k U)) Rlin pW := rfl
    rwa [← this]
  have hspan : ∀ g ∈ Ideal.span ({pW} : Set k[X]), eval₂R g = 0 := by
    intro g hg
    obtain ⟨h, rfl⟩ := Ideal.mem_span_singleton.mp hg
    rw [map_mul, heval0, zero_mul]
  let LtoE : L →+* Module.End k U :=
    Ideal.Quotient.lift (Ideal.span ({pW} : Set k[X])) eval₂R hspan
  let _instMod : Module L U := Module.compHom U LtoE
  haveI : IsScalarTower k L U := by
    refine ⟨fun r l u => ?_⟩
    have hdef : (r • l : L) = algebraMap k L r * l := Algebra.smul_def r l
    change LtoE (r • l) u = r • LtoE l u
    rw [hdef, map_mul]
    have hof : LtoE (algebraMap k L r) = algebraMap k (Module.End k U) r := by
      change Ideal.Quotient.lift _ eval₂R hspan
          (Ideal.Quotient.mk _ (C r)) = algebraMap k (Module.End k U) r
      rw [Ideal.Quotient.lift_mk]
      change eval₂ (algebraMap k (Module.End k U)) Rlin (C r) =
        algebraMap k (Module.End k U) r
      rw [eval₂_C]
    rw [hof, Algebra.algebraMap_eq_smul_one, Module.End.mul_eq_comp]
    simp only [LinearMap.comp_apply, LinearMap.smul_apply, Module.End.one_eq_id,
      LinearMap.id_apply]
  have hpb_ne : pW ≠ 0 := irreducible_X4_sub_X2_add_one.ne_zero
  haveI : Module.Free k L :=
    Module.Free.of_basis (powerBasis (K := k) (f := pW) hpb_ne).basis
  haveI : Module.Finite k L :=
    Module.Finite.of_basis (powerBasis (K := k) (f := pW) hpb_ne).basis
  haveI : Module.Free L U := Module.Free.of_divisionRing L U
  have hmul : Module.finrank k L * Module.finrank L U = Module.finrank k U :=
    Module.finrank_mul_finrank k L U
  have hL : Module.finrank k L = 4 := by
    let hpb := powerBasis (K := k) (f := pW) hpb_ne
    have : Module.finrank k (AdjoinRoot pW) = hpb.dim := hpb.finrank
    have hdim : hpb.dim = 4 := by
      change pW.natDegree = 4; exact natDegree_X4_sub_X2_add_one
    exact this.trans hdim
  have hU : Module.finrank k U = 6 := GeometricFanoCarrier.finrank_U
  have : 4 * Module.finrank L U = 6 := by
    calc 4 * Module.finrank L U
        = Module.finrank k L * Module.finrank L U := by rw [hL]
      _ = Module.finrank k U := hmul
      _ = 6 := hU
  omega

/-! ### Primary component dimensions: residualKer dim 2, Wker dim 4 -/

theorem finrank_residualKer_ge_two : 2 ≤ Module.finrank k residualKer := by
  classical
  haveI : Module.Finite k U := inferInstance
  haveI : Module.Finite k residualKer := inferInstance
  obtain ⟨u, hu, hune⟩ := Submodule.exists_mem_ne_zero_of_ne_bot residualKer_ne_bot
  have hR2add : Rlin (Rlin u) + u = 0 := (mem_residualKer_iff).mp hu
  have hli := residual_pair_independent hune hR2add
  have hRu : Rlin u ∈ residualKer := residualKer_R_stable hu
  let S : Submodule k U := Submodule.span k (Set.range ![u, Rlin u])
  have hSle : S ≤ residualKer := by
    apply Submodule.span_le.mpr
    intro x hx
    obtain ⟨i, rfl⟩ := hx
    fin_cases i <;> [exact hu; exact hRu]
  have hSdim : Module.finrank k S = 2 := by
    simpa using (finrank_span_eq_card hli)
  have hle := Submodule.finrank_mono hSle
  omega

theorem finrank_residual_add_Wker :
    Module.finrank k residualKer + Module.finrank k Wker = 6 := by
  classical
  haveI : Module.Finite k U := inferInstance
  have h := Submodule.finrank_add_eq_of_isCompl (V := U) isCompl_residualKer_Wker
  have hU : Module.finrank k U = 6 :=
    GeometricFanoCarrier.finrank_U
  rwa [hU] at h

theorem aeval_Rlin_pW_apply {w : U} (hw : w ∈ Wker) :
    aeval (Rlin : Module.End k U) pW w = 0 := by
  dsimp [Wker, pW] at hw
  exact LinearMap.mem_ker.mp hw

theorem Rpow_mem_Wker (w : U) (hw : w ∈ Wker) (n : ℕ) :
    ((Rlin : Module.End k U) ^ n) w ∈ Wker := by
  induction n with
  | zero => simpa [pow_zero, Module.End.one_eq_id] using hw
  | succ n ih =>
    -- R^{n+1} w = R (R^n w)
    have : (Rlin ^ (n + 1) : Module.End k U) =
        Rlin * (Rlin ^ n) := (pow_succ' Rlin n)
    rw [this, Module.End.mul_eq_comp, LinearMap.comp_apply]
    exact Rlin_mem_Wker ih

theorem linearIndependent_Rpow_Wker {w : U} (hw : w ∈ Wker) (hwne : w ≠ 0) :
    LinearIndependent k fun i : Fin 4 => ((Rlin : Module.End k U) ^ (i : ℕ)) w := by
  rw [Fintype.linearIndependent_iff]
  intro s hs
  let q : k[X] := ∑ i : Fin 4, monomial (i : ℕ) (s i)
  have haq : aeval (Rlin : Module.End k U) q w = 0 := by
    calc aeval (Rlin : Module.End k U) q w
        = (∑ i : Fin 4,
            aeval (Rlin : Module.End k U) (monomial (i : ℕ) (s i))) w := by
          simp only [q, map_sum]
      _ = ∑ i : Fin 4,
            aeval (Rlin : Module.End k U) (monomial (i : ℕ) (s i)) w := by
          simp only [LinearMap.coeFn_sum, Finset.sum_apply]
      _ = ∑ i : Fin 4, s i • ((Rlin : Module.End k U) ^ (i : ℕ)) w := by
          refine Finset.sum_congr rfl fun i _ => ?_
          rw [aeval_monomial]
          simp only [Algebra.algebraMap_eq_smul_one, Module.End.one_eq_id,
            Module.End.mul_eq_comp, LinearMap.comp_apply, LinearMap.smul_apply,
            LinearMap.id_apply]
      _ = 0 := hs
  have hpW : aeval (Rlin : Module.End k U) pW w = 0 := aeval_Rlin_pW_apply hw
  by_cases hq0 : q = 0
  · intro i
    have hci : q.coeff i.val = s i := by
      simp only [q, finsetSum_coeff]
      rw [Finset.sum_eq_single i]
      · simp [coeff_monomial]
      · intro j _ hj
        rw [coeff_monomial]
        split_ifs with h
        · exact absurd (Fin.eq_of_val_eq h) hj
        · rfl
      · intro; exact absurd (Finset.mem_univ _) (by assumption)
    have : s i = 0 := by rw [← hci, hq0, coeff_zero]
    exact this
  · have hndvd : ¬ pW ∣ q := by
      intro hdiv
      have hle := natDegree_le_of_dvd hdiv hq0
      have hpw : pW.natDegree = 4 := natDegree_X4_sub_X2_add_one
      have hqle : q.natDegree ≤ 3 := by
        refine (natDegree_sum_le _ _).trans ?_
        apply Finset.sup_le
        intro i _
        calc (monomial (i.val) (s i)).natDegree
            ≤ i.val := natDegree_monomial_le _
          _ ≤ 3 := Nat.lt_succ_iff.mp i.isLt
      omega
    have hcop : IsCoprime pW q := by
      rcases dvd_or_isCoprime pW q irreducible_X4_sub_X2_add_one with h | h
      · exact absurd h hndvd
      · exact h
    obtain ⟨a, b, hab⟩ := hcop
    have hw0 : w = 0 := by
      have h1 : aeval (Rlin : Module.End k U) (1 : k[X]) w = 0 := by
        have hab' : aeval (Rlin : Module.End k U) (a * pW + b * q) w =
            aeval (Rlin : Module.End k U) (1 : k[X]) w := by rw [hab]
        rw [← hab']
        have hA : aeval (Rlin : Module.End k U) (a * pW) w = 0 := by
          rw [map_mul, Module.End.mul_eq_comp, LinearMap.comp_apply, hpW, map_zero]
        have hB : aeval (Rlin : Module.End k U) (b * q) w = 0 := by
          rw [map_mul, Module.End.mul_eq_comp, LinearMap.comp_apply, haq, map_zero]
        simp only [map_add, LinearMap.add_apply, hA, hB, add_zero]
      simpa [map_one, Module.End.one_eq_id, LinearMap.id_apply] using h1
    exact absurd hw0 hwne

theorem finrank_Wker_ge_four : 4 ≤ Module.finrank k Wker := by
  classical
  haveI : Module.Finite k U := inferInstance
  haveI : Module.Finite k Wker := inferInstance
  obtain ⟨w0, hw0, hw0ne⟩ := Submodule.exists_mem_ne_zero_of_ne_bot Wker_ne_bot
  have hind := linearIndependent_Rpow_Wker hw0 hw0ne
  have hspan_dim :
      Module.finrank k
        (Submodule.span k (Set.range fun i : Fin 4 =>
          ((Rlin : Module.End k U) ^ (i : ℕ)) w0)) = 4 := by
    simpa using (finrank_span_eq_card hind)
  have hspan_le :
      Submodule.span k (Set.range fun i : Fin 4 =>
          ((Rlin : Module.End k U) ^ (i : ℕ)) w0) ≤ Wker := by
    apply Submodule.span_le.mpr
    intro x hx
    obtain ⟨i, rfl⟩ := hx
    exact Rpow_mem_Wker w0 hw0 i
  have hle := Submodule.finrank_mono hspan_le
  omega

theorem finrank_residualKer_eq_two : Module.finrank k residualKer = 2 := by
  have hsum := finrank_residual_add_Wker
  have hr := finrank_residualKer_ge_two
  have hw := finrank_Wker_ge_four
  omega

theorem finrank_Wker_eq_four : Module.finrank k Wker = 4 := by
  have hsum := finrank_residual_add_Wker
  have hr := finrank_residualKer_eq_two
  omega

/-! ### Uniqueness of the residual plane

Any R-stable 2-plane equals `residualKer` (inclusion from residual character of
R-stable planes + equal finrank).  Consequently the residual pure wedge is the
**unique** N-fixed pure/decomposable bivector up to scale: an N-fixed pure Gr
point has R-stable support (N-fixed pure residual), hence support = residualKer.

Writeup Input 3 / hyp (b): this unique N-fixed pure-Gr point must miss `M = 10'`.
That is pure-M exclusion (`residual Plücker ∉ Mfix = Msub`). -/

/-- Any R-stable rank-2 plane equals the residual plane `ker(R²+id)`. -/
theorem eq_residualKer_of_R_stable_plane (P : Submodule k U)
    (hdim : Module.finrank k P = 2)
    (hR : ∀ x ∈ P, Rlin x ∈ P) :
    P = residualKer := by
  have hle : P ≤ residualKer := by
    intro x hx
    exact R_stable_plane_mem_residualKer P hdim hR x hx
  have hfr : Module.finrank k P = Module.finrank k residualKer := by
    rw [hdim, finrank_residualKer_eq_two]
  exact Submodule.eq_of_le_of_finrank_eq hle hfr

/-- Support of an R-character pure wedge is exactly `residualKer`. -/
public theorem support_eq_residualKer_of_R_character {u v : U} {μ : k}
    (hI : LinearIndependent k ![u, v])
    (hμ : μ ≠ 0)
    (hRpure : pureWedge (Rlin u) (Rlin v) = μ • pureWedge u v) :
    (k ∙ u) ⊔ (k ∙ v) = residualKer := by
  obtain ⟨hdim, hstab⟩ := R_character_plane_stable hI hμ hRpure
  exact eq_residualKer_of_R_stable_plane _ hdim hstab

/-- An N-fixed pure-Gr plane (rotGen-fixed as a projective point) has support
exactly `residualKer`. -/
theorem support_eq_residualKer_of_N_fixed_pure {u v : U}
    (hI : LinearIndependent k ![u, v])
    (hne : pureWedge u v ≠ 0)
    (hfix : actPM (CentralizerN.rotGen : PSL2F11)
      (Projectivization.mk k (pureWedge u v) hne) =
        Projectivization.mk k (pureWedge u v) hne) :
    (k ∙ u) ⊔ (k ∙ v) = residualKer := by
  have hcoe := hfix
  rw [actPM, Projectivization.map_mk, Projectivization.mk_eq_mk_iff] at hcoe
  obtain ⟨μ, hμ⟩ := hcoe
  have hRpure : pureWedge (Rlin u) (Rlin v) = (μ : k) • pureWedge u v := by
    have hA := ambientAct_rotGen_pure u v
    exact hA.symm.trans hμ.symm
  exact support_eq_residualKer_of_R_character hI (Units.ne_zero μ) hRpure

/-! ### Pure-M exclusion gate (writeup Input 3)

For N-fixed residual pure wedge `ω = u ∧ Ru`:
* `πω = ω` ⇔ `cross = 42 · ω` (pure-M)
* `πω = 0` ⇔ `cross = -24 · ω` (pure W₅; already excluded from `Mfix` by
  `not_mem_Mfix_of_cross_parallel_ne_forty_two`)
* non-parallel cross ⇒ `πω ≠ ω` (dual sum 24)

So residual ∉ `Mfix` reduces to pure-M exclusion: `cross ≠ 42 · ω`.
Equivalently (since residual is the unique N-fixed pure bivector): `M^N` contains
no rank-2 Plücker vector — the writeup’s sealed `(2,1,1,0)` piece computation
(“rank 6 or 4, never 2 on the trivial pencil”).

Modular audit (FIX_IX_SEAL / F₂₃): residual is **mixed** (`Tω ∦ ω`, rank(M+ω)=11),
so pure-M is false.  Lean seal still needs either that modular certificate
lifted to `K = ℚ(ζ₁₁)`, or an independent pure-math non-parallel argument. -/

/-- Pure-M residual ⇔ residual pure wedge lies in `Msub` (for residual data). -/
theorem residual_plucker_mem_Msub_iff_pureM {u : U}
    (hu0 : u ≠ 0)
    (hR2 : Rlin (Rlin u) + u = 0)
    (hSstab : Slin u ∈ (k ∙ u) ⊔ (k ∙ Rlin u)) :
    pureWedge u (Rlin u) ∈ Msub ↔
      projectorM (pureWedge u (Rlin u)) = pureWedge u (Rlin u) := by
  constructor
  · intro hM
    -- Msub = Mfix, so πω = ω
    have hFix : pureWedge u (Rlin u) ∈ Mfix := by
      rwa [← Mfix_eq_Msub] at hM
    exact (mem_Mfix_iff (v := pureWedge u (Rlin u))).mp hFix
  · intro hfix
    exact residual_plucker_mem_Msub_of_pureM hu0 hR2 hSstab hfix

/-- Residual pure-M exclusion from non-membership in `Msub`. -/
theorem residual_plucker_projectorM_ne_of_not_mem_Msub {u : U}
    (hu0 : u ≠ 0)
    (hR2 : Rlin (Rlin u) + u = 0)
    (hSstab : Slin u ∈ (k ∙ u) ⊔ (k ∙ Rlin u))
    (hnot : pureWedge u (Rlin u) ∉ Msub) :
    projectorM (pureWedge u (Rlin u)) ≠ pureWedge u (Rlin u) := by
  intro hfix
  exact hnot (residual_plucker_mem_Msub_of_pureM hu0 hR2 hSstab hfix)

/-! ### Trace of Rlin on residualKer / Wker / U

Sealed: `tr(R|_res)=0` (2×2 Cayley–Hamilton + no √−1),
`tr(R|_W)=0` (companion of cyclic basis), `tr(R)=0` via isCompl.
-/

theorem Rrestrict_residual_sq_add_id
    (hR : ∀ x ∈ residualKer, Rlin x ∈ residualKer) :
    Rrestrict residualKer hR ∘ₗ Rrestrict residualKer hR + LinearMap.id = 0 := by
  apply LinearMap.ext
  intro x
  apply Subtype.ext
  have hR2 : Rlin (Rlin (x : U)) + (x : U) = 0 :=
    (mem_residualKer_iff).mp x.property
  simp only [LinearMap.add_apply, LinearMap.comp_apply, LinearMap.id_apply,
    Rrestrict_apply, Submodule.coe_add, LinearMap.zero_apply, ZeroMemClass.coe_zero]
  exact hR2

theorem Rrestrict_residual_no_eigen
    (hR : ∀ x ∈ residualKer, Rlin x ∈ residualKer) {μ : k} {x : residualKer}
    (hx0 : x ≠ 0) (hμ : Rrestrict residualKer hR x = μ • x) : False := by
  have hu0 : (x : U) ≠ 0 := fun h => hx0 (Subtype.ext h)
  have hR2add : Rlin (Rlin (x : U)) + (x : U) = 0 :=
    (mem_residualKer_iff).mp x.property
  have heig : Rlin (x : U) = μ • (x : U) := by
    have := congrArg Subtype.val hμ
    simpa [Rrestrict_apply, Submodule.coe_smul] using this
  exact residual_no_eigenvalue hu0 hR2add ⟨μ, heig⟩

theorem smul_one_mul_matrix (r : k) (A : Matrix (Fin 2) (Fin 2) k) :
    (r • (1 : Matrix (Fin 2) (Fin 2) k)) * A = r • A := by
  ext i j
  simp only [Matrix.mul_apply, Matrix.smul_apply, Matrix.one_apply, smul_eq_mul, mul_ite,
    mul_one, mul_zero]
  -- ∑ x, (if i = x then r else 0) * A x j = r * A i j
  rw [Finset.sum_eq_single (a := i)]
  · simp [mul_comm]
  · intro x _ hx
    simp only [ite_mul, zero_mul, one_mul]
    split_ifs with h
    · exact absurd h.symm hx
    · rfl
  · intro; exact absurd (Finset.mem_univ _) (by assumption)

theorem matrix_fin_two_trace_ne_zero_offdiag_zero
    (A : Matrix (Fin 2) (Fin 2) k) (hA2 : A * A + 1 = 0) (htr : A.trace ≠ 0) :
    A 1 0 = 0 := by
  have ht : A 0 0 + A 1 1 ≠ 0 := by
    simpa [Matrix.trace, Fin.sum_univ_two] using htr
  have hentry := congrArg (fun M : Matrix (Fin 2) (Fin 2) k => M 1 0) hA2
  have hmul : (A 0 0 + A 1 1) * A 1 0 = 0 := by
    have hentry' : A 1 0 * A 0 0 + A 1 1 * A 1 0 = 0 := by
      simpa only [Matrix.add_apply, Matrix.mul_apply, Fin.sum_univ_two, Matrix.one_apply,
        ne_eq, one_ne_zero, ↓reduceIte, add_zero, Matrix.zero_apply] using hentry
    calc
      (A 0 0 + A 1 1) * A 1 0 = A 1 0 * A 0 0 + A 1 1 * A 1 0 := by ring
      _ = 0 := hentry'
  exact (mul_eq_zero.mp hmul).resolve_left ht

theorem trace_eq_zero_of_sq_eq_neg_one_of_no_eigen
    {V : Type*} [AddCommGroup V] [Module k V] [Module.Finite k V] [Module.Free k V]
    (T : Module.End k V) (hdim : Module.finrank k V = 2)
    (hT2 : T ∘ₗ T + LinearMap.id = 0)
    (hnoeig : ∀ (mu : k) (x : V), x ≠ 0 → T x = mu • x → False) :
    LinearMap.trace k V T = 0 := by
  have hcard : Fintype.card (Module.Free.ChooseBasisIndex k V) = 2 := by
    rw [← Module.finrank_eq_card_chooseBasisIndex k V, hdim]
  let eIdx : Module.Free.ChooseBasisIndex k V ≃ Fin 2 :=
    Fintype.equivFinOfCardEq hcard
  let b : Basis (Fin 2) k V := (Module.Free.chooseBasis k V).reindex eIdx
  let A : Matrix (Fin 2) (Fin 2) k := LinearMap.toMatrix b b T
  have htr : LinearMap.trace k V T = A.trace :=
    LinearMap.trace_eq_matrix_trace k b T
  rw [htr]
  by_contra ht
  have hA2 : A * A + 1 = 0 := by
    have hcomp : LinearMap.toMatrix b b (T ∘ₗ T) = A * A :=
      LinearMap.toMatrix_comp b b b T T
    have hid : LinearMap.toMatrix b b (LinearMap.id : V →ₗ[k] V) =
        (1 : Matrix (Fin 2) (Fin 2) k) := LinearMap.toMatrix_id b
    have hsum : LinearMap.toMatrix b b (T ∘ₗ T + LinearMap.id) =
        LinearMap.toMatrix b b (T ∘ₗ T) + LinearMap.toMatrix b b LinearMap.id :=
      map_add (LinearMap.toMatrix b b) _ _
    have hzero : LinearMap.toMatrix b b (0 : V →ₗ[k] V) = 0 := map_zero _
    calc
      A * A + 1 = LinearMap.toMatrix b b (T ∘ₗ T) +
          LinearMap.toMatrix b b LinearMap.id := by rw [hcomp, hid]
      _ = LinearMap.toMatrix b b (T ∘ₗ T + LinearMap.id) := hsum.symm
      _ = LinearMap.toMatrix b b 0 := by rw [hT2]
      _ = 0 := hzero
  have h10 : A 1 0 = 0 := matrix_fin_two_trace_ne_zero_offdiag_zero A hA2 ht
  have h10' : b.repr (T (b 0)) 1 = 0 := by
    simpa only [A, LinearMap.toMatrix_apply] using h10
  have heig : T (b 0) = A 0 0 • b 0 := by
    apply b.repr.injective
    ext i
    fin_cases i
    · simp [A, LinearMap.toMatrix_apply]
    · simp [h10']
  exact hnoeig (A 0 0) (b 0) (b.ne_zero 0) heig

theorem Rrestrict_residual_trace :
    let hR : ∀ x ∈ residualKer, Rlin x ∈ residualKer := fun _ hx => residualKer_R_stable hx
    LinearMap.trace k residualKer (Rrestrict residualKer hR) = 0 := by
  classical
  haveI : Module.Finite k residualKer := inferInstance
  haveI : Module.Free k residualKer := Module.Free.of_divisionRing k residualKer
  let hR : ∀ x ∈ residualKer, Rlin x ∈ residualKer := fun _ hx => residualKer_R_stable hx
  let RW := Rrestrict residualKer hR
  change LinearMap.trace k residualKer RW = 0
  apply trace_eq_zero_of_sq_eq_neg_one_of_no_eigen (V := residualKer) RW
    finrank_residualKer_eq_two
  · exact Rrestrict_residual_sq_add_id hR
  · intro mu x hx hmu
    exact Rrestrict_residual_no_eigen hR hx hmu

/-! ### Wker: companion matrix of cyclic basis has zero diagonal -/

theorem Rrestrict_Wker_trace :
    let hR : ∀ x ∈ Wker, Rlin x ∈ Wker := fun _ hx => Rlin_mem_Wker hx
    LinearMap.trace k Wker (Rrestrict Wker hR) = 0 := by
  classical
  haveI : Module.Finite k Wker := inferInstance
  haveI : Module.Free k Wker := Module.Free.of_divisionRing k Wker
  let hR : ∀ x ∈ Wker, Rlin x ∈ Wker := fun _ hx => Rlin_mem_Wker hx
  let RW := Rrestrict Wker hR
  have hdim : Module.finrank k Wker = 4 := finrank_Wker_eq_four
  obtain ⟨w0, hw0, hw0ne⟩ := Submodule.exists_mem_ne_zero_of_ne_bot Wker_ne_bot
  have hindU := linearIndependent_Rpow_Wker hw0 hw0ne
  -- cyclic family in Wker
  let v : Fin 4 → Wker := fun i =>
    ⟨((Rlin : Module.End k U) ^ (i : ℕ)) w0, Rpow_mem_Wker w0 hw0 i⟩
  have hli : LinearIndependent k v := by
    have hcoe : LinearIndependent k (fun i : Fin 4 => (v i : U)) := hindU
    exact LinearIndependent.of_comp Wker.subtype hcoe
  have hspan : Submodule.span k (Set.range v) = (⊤ : Submodule k Wker) := by
    have hfr : Module.finrank k (Submodule.span k (Set.range v)) = 4 := by
      simpa using (finrank_span_eq_card hli)
    have heq : Module.finrank k (Submodule.span k (Set.range v)) =
        Module.finrank k Wker := by
      rw [hfr, hdim]
    exact Submodule.eq_top_of_finrank_eq (K := k) (V := Wker)
      (S := Submodule.span k (Set.range v)) heq
  let bas : Basis (Fin 4) k Wker := Basis.mk hli hspan.ge
  have hb (i : Fin 4) : bas i = v i := by simp [bas, Basis.mk_apply]
  -- R : v_i ↦ v_{i+1} for i < 3
  have hR01 : RW (v 0) = v 1 := by
    apply Subtype.ext
    simp only [RW, Rrestrict_apply, v]
    change Rlin ((Rlin ^ (0 : ℕ)) w0) = (Rlin ^ (1 : ℕ)) w0
    rw [pow_zero, pow_one, Module.End.one_eq_id, LinearMap.id_apply]
  have hR12 : RW (v 1) = v 2 := by
    apply Subtype.ext
    simp only [RW, Rrestrict_apply, v]
    change Rlin ((Rlin ^ (1 : ℕ)) w0) = (Rlin ^ (2 : ℕ)) w0
    rw [pow_one, pow_two, Module.End.mul_eq_comp, LinearMap.comp_apply]
  have hR23 : RW (v 2) = v 3 := by
    apply Subtype.ext
    simp only [RW, Rrestrict_apply, v]
    change Rlin ((Rlin ^ (2 : ℕ)) w0) = (Rlin ^ (3 : ℕ)) w0
    have : (Rlin ^ (3 : ℕ) : Module.End k U) = Rlin * (Rlin ^ 2) := by rw [pow_succ']
    rw [this, Module.End.mul_apply]
  -- R⁴ w0 = R² w0 − w0, so RW v3 = (−1)•v0 + v2
  have hR30 : RW (v 3) = (-1 : k) • v 0 + v 2 := by
    apply Subtype.ext
    have hpW : aeval (Rlin : Module.End k U) pW w0 = 0 := aeval_Rlin_pW_apply hw0
    have hEq : (Rlin ^ 4 : Module.End k U) w0 - (Rlin ^ 2) w0 + w0 = 0 := by
      simpa [pW, map_add, map_sub, map_pow, map_one, aeval_X, Module.End.one_eq_id,
        LinearMap.add_apply, LinearMap.sub_apply, LinearMap.id_apply] using hpW
    have hR4 : (Rlin ^ 4 : Module.End k U) w0 = (Rlin ^ 2) w0 + (-w0) := by
      have h' : (Rlin ^ 4) w0 + w0 = (Rlin ^ 2) w0 := by
        -- R⁴w − R²w + w = 0 ⇒ R⁴w + w = R²w
        have h1 : (Rlin ^ 4) w0 - (Rlin ^ 2) w0 + w0 + (Rlin ^ 2) w0 =
            0 + (Rlin ^ 2) w0 := by rw [hEq]
        convert h1 using 1 <;> abel
      have : (Rlin ^ 4) w0 = (Rlin ^ 2) w0 - w0 := (eq_sub_iff_add_eq).mpr h'
      simpa [sub_eq_add_neg] using this
    simp only [RW, Rrestrict_apply, v, Submodule.coe_add, Submodule.coe_smul]
    change Rlin ((Rlin ^ (3 : ℕ)) w0) = (-1 : k) • w0 + (Rlin ^ (2 : ℕ)) w0
    have hpow : Rlin ((Rlin ^ (3 : ℕ)) w0) = (Rlin ^ (4 : ℕ)) w0 := by
      have : (Rlin ^ (4 : ℕ) : Module.End k U) = Rlin * (Rlin ^ 3) := by rw [pow_succ']
      rw [this, Module.End.mul_apply]
    rw [hpow, hR4]
    -- R²w + (-w) = (-1)•w + R²w
    rw [← neg_one_smul k w0]
    abel
  -- Diagonal of companion is zero
  have hdiag (i : Fin 4) : (LinearMap.toMatrix bas bas RW) i i = 0 := by
    rw [LinearMap.toMatrix_apply, hb]
    fin_cases i
    · -- i = 0
      change (bas.repr (RW (v 0))) (0 : Fin 4) = 0
      rw [hR01]
      have hv : bas.repr (v 1) = Finsupp.single (1 : Fin 4) 1 := by
        rw [show v 1 = bas 1 from (hb 1).symm, Basis.repr_self]
      rw [hv]
      exact Finsupp.single_eq_of_ne (show (0 : Fin 4) ≠ 1 by decide)
    · change (bas.repr (RW (v 1))) (1 : Fin 4) = 0
      rw [hR12]
      have hv : bas.repr (v 2) = Finsupp.single (2 : Fin 4) 1 := by
        rw [show v 2 = bas 2 from (hb 2).symm, Basis.repr_self]
      rw [hv]
      exact Finsupp.single_eq_of_ne (show (1 : Fin 4) ≠ 2 by decide)
    · change (bas.repr (RW (v 2))) (2 : Fin 4) = 0
      rw [hR23]
      have hv : bas.repr (v 3) = Finsupp.single (3 : Fin 4) 1 := by
        rw [show v 3 = bas 3 from (hb 3).symm, Basis.repr_self]
      rw [hv]
      exact Finsupp.single_eq_of_ne (show (2 : Fin 4) ≠ 3 by decide)
    · change (bas.repr (RW (v 3))) (3 : Fin 4) = 0
      rw [hR30, map_add, map_smul]
      have hr0 : bas.repr (v 0) = Finsupp.single (0 : Fin 4) 1 := by
        rw [show v 0 = bas 0 from (hb 0).symm, Basis.repr_self]
      have hr2 : bas.repr (v 2) = Finsupp.single (2 : Fin 4) 1 := by
        rw [show v 2 = bas 2 from (hb 2).symm, Basis.repr_self]
      rw [hr0, hr2]
      simp [Finsupp.single_apply]
  have htrM : (LinearMap.toMatrix bas bas RW).trace = 0 := by
    simp only [Matrix.trace, Matrix.diag_apply]
    exact Finset.sum_eq_zero fun i _ => hdiag i
  change LinearMap.trace k Wker RW = 0
  rw [LinearMap.trace_eq_matrix_trace k bas RW, htrM]

/-! ### Global tr(R) = 0 via residual ⊕ Wker -/

theorem Rlin_eq_conj_prodMap :
    let hR : ∀ x ∈ residualKer, Rlin x ∈ residualKer := fun _ hx => residualKer_R_stable hx
    let hW : ∀ x ∈ Wker, Rlin x ∈ Wker := fun _ hx => Rlin_mem_Wker hx
    let e := residualKer.prodEquivOfIsCompl Wker isCompl_residualKer_Wker
    (Rlin : Module.End k U) =
      e.conj (LinearMap.prodMap (Rrestrict residualKer hR) (Rrestrict Wker hW)) := by
  classical
  let hR : ∀ x ∈ residualKer, Rlin x ∈ residualKer := fun _ hx => residualKer_R_stable hx
  let hW : ∀ x ∈ Wker, Rlin x ∈ Wker := fun _ hx => Rlin_mem_Wker hx
  let e := residualKer.prodEquivOfIsCompl Wker isCompl_residualKer_Wker
  let f := LinearMap.prodMap (Rrestrict residualKer hR) (Rrestrict Wker hW)
  apply LinearMap.ext
  intro u
  have hu : u ∈ residualKer ⊔ Wker := by
    rw [residualKer_sup_Wker_eq_top]; trivial
  obtain ⟨r, hr, w, hw, rfl⟩ := Submodule.mem_sup.mp hu
  have he_apply : e (⟨r, hr⟩, ⟨w, hw⟩) = (r + w : U) := by
    exact Submodule.coe_prodEquivOfIsCompl' (p := residualKer) (q := Wker)
      isCompl_residualKer_Wker (⟨r, hr⟩, ⟨w, hw⟩)
  have hesym : e.symm (r + w) = (⟨r, hr⟩, ⟨w, hw⟩) := by
    apply e.injective
    rw [e.apply_symm_apply, he_apply]
  change Rlin (r + w) = e (f (e.symm (r + w)))
  rw [hesym]
  -- f (r,w) = (Rr, Rw)
  change Rlin (r + w) =
    e (Rrestrict residualKer hR ⟨r, hr⟩, Rrestrict Wker hW ⟨w, hw⟩)
  have he' : e (Rrestrict residualKer hR ⟨r, hr⟩, Rrestrict Wker hW ⟨w, hw⟩) =
      Rlin r + Rlin w := by
    have h := Submodule.coe_prodEquivOfIsCompl' (p := residualKer) (q := Wker)
      isCompl_residualKer_Wker
      (Rrestrict residualKer hR ⟨r, hr⟩, Rrestrict Wker hW ⟨w, hw⟩)
    -- h : e (Rr, Rw) = ↑(Rr) + ↑(Rw) = R r + R w
    simpa only [Rrestrict_apply] using h
  rw [he', map_add]

theorem Rlin_trace : LinearMap.trace k U Rlin = 0 := by
  classical
  haveI : Module.Finite k residualKer := inferInstance
  haveI : Module.Free k residualKer := Module.Free.of_divisionRing k residualKer
  haveI : Module.Finite k Wker := inferInstance
  haveI : Module.Free k Wker := Module.Free.of_divisionRing k Wker
  haveI : Module.Finite k U := inferInstance
  haveI : Module.Free k U := inferInstance
  -- Force AddCommGroup monoid for product so trace_conj' unifies
  let hR : ∀ x ∈ residualKer, Rlin x ∈ residualKer := fun _ hx => residualKer_R_stable hx
  let hW : ∀ x ∈ Wker, Rlin x ∈ Wker := fun _ hx => Rlin_mem_Wker hx
  let e := residualKer.prodEquivOfIsCompl Wker isCompl_residualKer_Wker
  let f : residualKer × Wker →ₗ[k] residualKer × Wker :=
    LinearMap.prodMap (Rrestrict residualKer hR) (Rrestrict Wker hW)
  have hconj : Rlin = e.conj f := Rlin_eq_conj_prodMap
  rw [hconj]
  rw [LinearMap.trace_conj' (R := k) (M := residualKer × Wker) (N := U) f e]
  rw [LinearMap.trace_prodMap']
  rw [show LinearMap.trace k residualKer (Rrestrict residualKer hR) = 0 from
    Rrestrict_residual_trace]
  rw [show LinearMap.trace k Wker (Rrestrict Wker hW) = 0 from Rrestrict_Wker_trace]
  simp only [zero_add]

/-! ### tr(R²)=0 and χ_Λ²(rotGen)=0 via Newton

Sealed: tr(R²|_res)=−2, tr(R²|_W)=2 ⇒ tr(R²)=0;
`ambientAct rotGen = map 2 Rlin`, Newton ⇒ χ_Λ²(rotGen)=0.
-/

theorem Rrestrict_residual_sq_trace :
    let hR : ∀ x ∈ residualKer, Rlin x ∈ residualKer := fun _ hx => residualKer_R_stable hx
    let RW := Rrestrict residualKer hR
    LinearMap.trace k residualKer (RW ∘ₗ RW) = (-2 : k) := by
  classical
  haveI : Module.Finite k residualKer := inferInstance
  haveI : Module.Free k residualKer := Module.Free.of_divisionRing k residualKer
  let hR : ∀ x ∈ residualKer, Rlin x ∈ residualKer := fun _ hx => residualKer_R_stable hx
  let RW := Rrestrict residualKer hR
  have hsq : RW ∘ₗ RW + LinearMap.id = 0 := Rrestrict_residual_sq_add_id hR
  have htr0 : LinearMap.trace k residualKer (RW ∘ₗ RW + LinearMap.id) = 0 := by
    rw [hsq, map_zero]
  rw [map_add] at htr0
  -- tr(id) = finrank = 2
  have hid : LinearMap.trace k residualKer (LinearMap.id : residualKer →ₗ[k] residualKer) =
      (2 : k) := by
    have h := LinearMap.trace_id (R := k) (M := residualKer)
    rw [h, finrank_residualKer_eq_two]
    norm_num
  rw [hid] at htr0
  -- htr0 : tr(R²) + 2 = 0
  change LinearMap.trace k residualKer (RW ∘ₗ RW) = -2
  exact eq_neg_of_add_eq_zero_left htr0

/-- tr(R² on Wker) = 2 via companion matrix of cyclic basis. -/
theorem Rrestrict_Wker_sq_trace :
    let hR : ∀ x ∈ Wker, Rlin x ∈ Wker := fun _ hx => Rlin_mem_Wker hx
    let RW := Rrestrict Wker hR
    LinearMap.trace k Wker (RW ∘ₗ RW) = (2 : k) := by
  classical
  haveI : Module.Finite k Wker := inferInstance
  haveI : Module.Free k Wker := Module.Free.of_divisionRing k Wker
  let hR : ∀ x ∈ Wker, Rlin x ∈ Wker := fun _ hx => Rlin_mem_Wker hx
  let RW := Rrestrict Wker hR
  have hdim : Module.finrank k Wker = 4 := finrank_Wker_eq_four
  obtain ⟨w0, hw0, hw0ne⟩ := Submodule.exists_mem_ne_zero_of_ne_bot Wker_ne_bot
  have hindU := linearIndependent_Rpow_Wker hw0 hw0ne
  let v : Fin 4 → Wker := fun i =>
    ⟨((Rlin : Module.End k U) ^ (i : ℕ)) w0, Rpow_mem_Wker w0 hw0 i⟩
  have hli : LinearIndependent k v := by
    exact LinearIndependent.of_comp Wker.subtype hindU
  have hspan : Submodule.span k (Set.range v) = (⊤ : Submodule k Wker) := by
    have hfr : Module.finrank k (Submodule.span k (Set.range v)) = 4 := by
      simpa using (finrank_span_eq_card hli)
    have heq : Module.finrank k (Submodule.span k (Set.range v)) =
        Module.finrank k Wker := by rw [hfr, hdim]
    exact Submodule.eq_top_of_finrank_eq (K := k) (V := Wker)
      (S := Submodule.span k (Set.range v)) heq
  let bas : Basis (Fin 4) k Wker := Basis.mk hli hspan.ge
  have hb (i : Fin 4) : bas i = v i := by simp [bas, Basis.mk_apply]
  -- R² maps: v0→v2, v1→v3, v2→R²v2=R⁴w0=R²w0−w0 = −v0+v2,
  --           v3→R²v3=R⁵w0=R(R⁴w0)=R(R²w0−w0)=R³w0−Rw0 = v3−v1
  -- Companion of X⁴−X²+1 for S=R²:
  -- Actually compute diagonal of toMatrix (RW∘RW):
  -- (RW∘RW) v0 = v2, diag contrib at 0: 0
  -- (RW∘RW) v1 = v3, at 1: 0
  -- (RW∘RW) v2 = −v0 + v2, at 2: 1
  -- (RW∘RW) v3 = −v1 + v3, at 3: 1
  -- tr = 0+0+1+1 = 2
  have hR01 : RW (v 0) = v 1 := by
    apply Subtype.ext
    simp only [RW, Rrestrict_apply, v]
    change Rlin ((Rlin ^ (0 : ℕ)) w0) = (Rlin ^ (1 : ℕ)) w0
    rw [pow_zero, pow_one, Module.End.one_eq_id, LinearMap.id_apply]
  have hR12 : RW (v 1) = v 2 := by
    apply Subtype.ext
    simp only [RW, Rrestrict_apply, v]
    change Rlin ((Rlin ^ (1 : ℕ)) w0) = (Rlin ^ (2 : ℕ)) w0
    rw [pow_one, pow_two, Module.End.mul_eq_comp, LinearMap.comp_apply]
  have hR23 : RW (v 2) = v 3 := by
    apply Subtype.ext
    simp only [RW, Rrestrict_apply, v]
    change Rlin ((Rlin ^ (2 : ℕ)) w0) = (Rlin ^ (3 : ℕ)) w0
    have : (Rlin ^ (3 : ℕ) : Module.End k U) = Rlin * (Rlin ^ 2) := by rw [pow_succ']
    rw [this, Module.End.mul_apply]
  have hR30 : RW (v 3) = (-1 : k) • v 0 + v 2 := by
    -- reuse logic from Rrestrict_Wker_trace
    apply Subtype.ext
    have hpW : aeval (Rlin : Module.End k U) pW w0 = 0 := aeval_Rlin_pW_apply hw0
    have hEq : (Rlin ^ 4 : Module.End k U) w0 - (Rlin ^ 2) w0 + w0 = 0 := by
      simpa [pW, map_add, map_sub, map_pow, map_one, aeval_X, Module.End.one_eq_id,
        LinearMap.add_apply, LinearMap.sub_apply, LinearMap.id_apply] using hpW
    have hR4 : (Rlin ^ 4 : Module.End k U) w0 = (Rlin ^ 2) w0 + (-w0) := by
      have h' : (Rlin ^ 4) w0 + w0 = (Rlin ^ 2) w0 := by
        have h1 : (Rlin ^ 4) w0 - (Rlin ^ 2) w0 + w0 + (Rlin ^ 2) w0 =
            0 + (Rlin ^ 2) w0 := by rw [hEq]
        convert h1 using 1 <;> abel
      have : (Rlin ^ 4) w0 = (Rlin ^ 2) w0 - w0 := (eq_sub_iff_add_eq).mpr h'
      simpa [sub_eq_add_neg] using this
    simp only [RW, Rrestrict_apply, v, Submodule.coe_add, Submodule.coe_smul]
    change Rlin ((Rlin ^ (3 : ℕ)) w0) = (-1 : k) • w0 + (Rlin ^ (2 : ℕ)) w0
    have hpow : Rlin ((Rlin ^ (3 : ℕ)) w0) = (Rlin ^ (4 : ℕ)) w0 := by
      have : (Rlin ^ (4 : ℕ) : Module.End k U) = Rlin * (Rlin ^ 3) := by rw [pow_succ']
      rw [this, Module.End.mul_apply]
    rw [hpow, hR4, ← neg_one_smul k w0]
    abel
  let S := RW ∘ₗ RW
  have hS0 : S (v 0) = v 2 := by
    simp only [S, LinearMap.comp_apply, hR01, hR12]
  have hS1 : S (v 1) = v 3 := by
    simp only [S, LinearMap.comp_apply, hR12, hR23]
  have hS2 : S (v 2) = (-1 : k) • v 0 + v 2 := by
    simp only [S, LinearMap.comp_apply, hR23, hR30]
  have hS3 : S (v 3) = (-1 : k) • v 1 + v 3 := by
    -- S v3 = RW (RW v3) = RW ((-1)•v0 + v2) = (-1)•RW v0 + RW v2 = (-1)•v1 + v3
    simp only [S, LinearMap.comp_apply]
    rw [hR30, map_add, map_smul, hR01, hR23]
  have hdiag (i : Fin 4) : (LinearMap.toMatrix bas bas S) i i =
      if i = 2 ∨ i = 3 then (1 : k) else 0 := by
    rw [LinearMap.toMatrix_apply, hb]
    fin_cases i
    · change (bas.repr (S (v 0))) 0 = _
      rw [hS0]
      have hv : bas.repr (v 2) = Finsupp.single (2 : Fin 4) 1 := by
        rw [show v 2 = bas 2 from (hb 2).symm, Basis.repr_self]
      rw [hv, Finsupp.single_eq_of_ne (show (0 : Fin 4) ≠ 2 by decide)]
      simp
    · change (bas.repr (S (v 1))) 1 = _
      rw [hS1]
      have hv : bas.repr (v 3) = Finsupp.single (3 : Fin 4) 1 := by
        rw [show v 3 = bas 3 from (hb 3).symm, Basis.repr_self]
      rw [hv, Finsupp.single_eq_of_ne (show (1 : Fin 4) ≠ 3 by decide)]
      simp
    · change (bas.repr (S (v 2))) 2 = _
      rw [hS2, map_add, map_smul]
      have hr0 : bas.repr (v 0) = Finsupp.single (0 : Fin 4) 1 := by
        rw [show v 0 = bas 0 from (hb 0).symm, Basis.repr_self]
      have hr2 : bas.repr (v 2) = Finsupp.single (2 : Fin 4) 1 := by
        rw [show v 2 = bas 2 from (hb 2).symm, Basis.repr_self]
      rw [hr0, hr2]
      simp [Finsupp.single_apply]
    · change (bas.repr (S (v 3))) 3 = _
      rw [hS3, map_add, map_smul]
      have hr1 : bas.repr (v 1) = Finsupp.single (1 : Fin 4) 1 := by
        rw [show v 1 = bas 1 from (hb 1).symm, Basis.repr_self]
      have hr3 : bas.repr (v 3) = Finsupp.single (3 : Fin 4) 1 := by
        rw [show v 3 = bas 3 from (hb 3).symm, Basis.repr_self]
      rw [hr1, hr3]
      simp [Finsupp.single_apply]
  have htrM : (LinearMap.toMatrix bas bas S).trace = 2 := by
    simp only [Matrix.trace, Matrix.diag_apply]
    have e0 : (LinearMap.toMatrix bas bas S) 0 0 = 0 := by simpa using hdiag 0
    have e1 : (LinearMap.toMatrix bas bas S) 1 1 = 0 := by simpa using hdiag 1
    have e2 : (LinearMap.toMatrix bas bas S) 2 2 = 1 := by simpa using hdiag 2
    have e3 : (LinearMap.toMatrix bas bas S) 3 3 = 1 := by simpa using hdiag 3
    rw [Fin.sum_univ_four, e0, e1, e2, e3]
    norm_num
  change LinearMap.trace k Wker (RW ∘ₗ RW) = 2
  rw [LinearMap.trace_eq_matrix_trace k bas S, htrM]

/-- Global tr(R²) = 0. -/
theorem Rlin_sq_trace :
    LinearMap.trace k U (Rlin ∘ₗ Rlin) = 0 := by
  classical
  haveI : Module.Finite k residualKer := inferInstance
  haveI : Module.Free k residualKer := Module.Free.of_divisionRing k residualKer
  haveI : Module.Finite k Wker := inferInstance
  haveI : Module.Free k Wker := Module.Free.of_divisionRing k Wker
  haveI : Module.Finite k U := inferInstance
  haveI : Module.Free k U := inferInstance
  let hR : ∀ x ∈ residualKer, Rlin x ∈ residualKer := fun _ hx => residualKer_R_stable hx
  let hW : ∀ x ∈ Wker, Rlin x ∈ Wker := fun _ hx => Rlin_mem_Wker hx
  let e := residualKer.prodEquivOfIsCompl Wker isCompl_residualKer_Wker
  let fR := Rrestrict residualKer hR
  let fW := Rrestrict Wker hW
  let f := LinearMap.prodMap fR fW
  have hconj : Rlin = e.conj f := Rlin_eq_conj_prodMap
  -- R² = e.conj f ∘ e.conj f = e.conj (f ∘ f)
  have hconj2 : Rlin ∘ₗ Rlin = e.conj (f ∘ₗ f) := by
    rw [hconj]
    -- e.conj f ∘ e.conj f = e.conj (f ∘ f)
    exact (LinearEquiv.conj_comp e f f).symm
  rw [hconj2]
  rw [LinearMap.trace_conj' (R := k) (M := residualKer × Wker) (N := U) (f ∘ₗ f) e]
  -- f ∘ f = prodMap (fR∘fR) (fW∘fW)
  have hff : f ∘ₗ f = LinearMap.prodMap (fR ∘ₗ fR) (fW ∘ₗ fW) := by
    ext ⟨x, y⟩ <;> simp [f, fR, fW, LinearMap.prodMap_apply, LinearMap.comp_apply]
  rw [hff, LinearMap.trace_prodMap']
  have ht1 : LinearMap.trace k residualKer (fR ∘ₗ fR) = (-2 : k) :=
    Rrestrict_residual_sq_trace
  have ht2 : LinearMap.trace k Wker (fW ∘ₗ fW) = (2 : k) :=
    Rrestrict_Wker_sq_trace
  rw [ht1, ht2]
  norm_num

/-- ambientAct rotGen = exteriorPower.map 2 Rlin. -/
public theorem ambientAct_rotGen_eq_map_Rlin :
    ambientAct (CentralizerN.rotGen : PSL2F11) = exteriorPower.map 2 Rlin := by
  dsimp [ambientAct, Rlin, CentralizerN.rotGen]
  -- ambientAct (mk rot) = pslLambda2Hom (mk (mkRot rotPt)) = weilLambda2 (mkRot) = map 2 (weilU)
  change pslLambda2Hom
      (QuotientGroup.mk (CentralizerN.mkRot CentralizerN.rotPt)) =
    exteriorPower.map 2 (WeilHom.weilUHom (CentralizerN.mkRot CentralizerN.rotPt))
  rw [pslLambda2_mk]
  rfl

/-- χ_Λ²(rotGen) = 0 by Newton. -/
theorem chiLambda2_rotGen :
    chiLambda2 (CentralizerN.rotGen : PSL2F11) = 0 := by
  dsimp [chiLambda2]
  rw [ambientAct_rotGen_eq_map_Rlin]
  have h := trace_exterior_newton (V := U) Rlin
  change LinearMap.trace k (⋀[k]^2 U) (exteriorPower.map 2 Rlin) = 0
  rw [h, Rlin_trace, Rlin_sq_trace]
  norm_num

/-! ### tr(R⁴)=0 and χ_Λ²(rotGen²)=0 (order 3)

Newton on R²: tr(R²)=tr(R⁴)=0 ⇒ χ_Λ²(rotGen²)=0.
-/

theorem Rrestrict_residual_pow4_trace :
    let hR : ∀ x ∈ residualKer, Rlin x ∈ residualKer := fun _ hx => residualKer_R_stable hx
    let RW := Rrestrict residualKer hR
    LinearMap.trace k residualKer (RW ∘ₗ RW ∘ₗ RW ∘ₗ RW) = (2 : k) := by
  classical
  haveI : Module.Finite k residualKer := inferInstance
  haveI : Module.Free k residualKer := Module.Free.of_divisionRing k residualKer
  let hR : ∀ x ∈ residualKer, Rlin x ∈ residualKer := fun _ hx => residualKer_R_stable hx
  let RW := Rrestrict residualKer hR
  have hsq : RW ∘ₗ RW + LinearMap.id = 0 := Rrestrict_residual_sq_add_id hR
  have h4 : RW ∘ₗ RW ∘ₗ RW ∘ₗ RW = LinearMap.id := by
    apply LinearMap.ext
    intro x
    apply Subtype.ext
    have hu : (x : U) ∈ residualKer := x.property
    have hR2 : Rlin (Rlin (x : U)) = -(x : U) := residualKer_R2 hu
    have hR4 : Rlin (Rlin (Rlin (Rlin (x : U)))) = (x : U) := by
      calc Rlin (Rlin (Rlin (Rlin (x : U))))
          = Rlin (Rlin (-(x : U))) := by rw [hR2]
        _ = Rlin (-Rlin (x : U)) := by rw [map_neg]
        _ = -Rlin (Rlin (x : U)) := by rw [map_neg]
        _ = -(-(x : U)) := by rw [hR2]
        _ = (x : U) := neg_neg _
    simp only [LinearMap.comp_apply, Rrestrict_apply, LinearMap.id_apply]
    exact hR4
  change LinearMap.trace k residualKer (RW ∘ₗ RW ∘ₗ RW ∘ₗ RW) = 2
  rw [h4]
  have hid := LinearMap.trace_id (R := k) (M := residualKer)
  rw [hid, finrank_residualKer_eq_two]
  norm_num

/-- tr(R⁴ on Wker) = −2. -/
theorem Rrestrict_Wker_pow4_trace :
    let hR : ∀ x ∈ Wker, Rlin x ∈ Wker := fun _ hx => Rlin_mem_Wker hx
    let RW := Rrestrict Wker hR
    LinearMap.trace k Wker (RW ∘ₗ RW ∘ₗ RW ∘ₗ RW) = (-2 : k) := by
  classical
  haveI : Module.Finite k Wker := inferInstance
  haveI : Module.Free k Wker := Module.Free.of_divisionRing k Wker
  let hR : ∀ x ∈ Wker, Rlin x ∈ Wker := fun _ hx => Rlin_mem_Wker hx
  let RW := Rrestrict Wker hR
  have hrel : RW ∘ₗ RW ∘ₗ RW ∘ₗ RW + LinearMap.id = RW ∘ₗ RW := by
    apply LinearMap.ext
    intro x
    apply Subtype.ext
    have hx : (x : U) ∈ Wker := x.property
    have hker : aeval (Rlin : Module.End k U) pW (x : U) = 0 := by
      dsimp [Wker, pW] at hx; rwa [LinearMap.mem_ker] at hx
    have hexp : (Rlin ^ 4 - Rlin ^ 2 + LinearMap.id : Module.End k U) (x : U) = 0 := by
      simpa [pW, map_add, map_sub, map_pow, map_one, aeval_X, Module.End.one_eq_id,
        LinearMap.add_apply, LinearMap.sub_apply, LinearMap.id_apply] using hker
    have hR4 : (Rlin ^ 4 : Module.End k U) (x : U) + (x : U) =
        (Rlin ^ 2 : Module.End k U) (x : U) := by
      have : (Rlin ^ 4) (x : U) - (Rlin ^ 2) (x : U) + (x : U) = 0 := hexp
      have h1 : (Rlin ^ 4) (x : U) + (x : U) =
          (Rlin ^ 4) (x : U) - (Rlin ^ 2) (x : U) + (x : U) + (Rlin ^ 2) (x : U) := by abel
      rw [h1, this, zero_add]
    have hpow4 : ((RW ∘ₗ RW ∘ₗ RW ∘ₗ RW) x : U) = (Rlin ^ 4) (x : U) := by
      simp only [LinearMap.comp_apply, Rrestrict_apply]
      change Rlin (Rlin (Rlin (Rlin (x : U)))) = (Rlin ^ 4) (x : U)
      simp only [pow_succ, pow_zero, Module.End.one_eq_id, Module.End.mul_eq_comp,
        LinearMap.comp_apply, LinearMap.id_apply]
    have hpow2 : ((RW ∘ₗ RW) x : U) = (Rlin ^ 2) (x : U) := by
      simp only [LinearMap.comp_apply, Rrestrict_apply]
      change Rlin (Rlin (x : U)) = (Rlin ^ 2) (x : U)
      simp only [pow_two, Module.End.mul_eq_comp, LinearMap.comp_apply]
    simp only [LinearMap.add_apply, LinearMap.id_apply, Submodule.coe_add]
    rw [hpow4, hpow2]
    exact hR4
  have htr : LinearMap.trace k Wker (RW ∘ₗ RW ∘ₗ RW ∘ₗ RW + LinearMap.id) =
      LinearMap.trace k Wker (RW ∘ₗ RW) := by rw [hrel]
  rw [map_add] at htr
  have hid : LinearMap.trace k Wker (LinearMap.id : Wker →ₗ[k] Wker) = (4 : k) := by
    have h := LinearMap.trace_id (R := k) (M := Wker)
    rw [h, finrank_Wker_eq_four]; norm_num
  have ht2 : LinearMap.trace k Wker (RW ∘ₗ RW) = (2 : k) := Rrestrict_Wker_sq_trace
  change LinearMap.trace k Wker (RW ∘ₗ RW ∘ₗ RW ∘ₗ RW) = -2
  have hsum : LinearMap.trace k Wker (RW ∘ₗ RW ∘ₗ RW ∘ₗ RW) + 4 = 2 := by
    rwa [hid, ht2] at htr
  -- tr + 4 = 2 ⇒ tr = -2
  calc LinearMap.trace k Wker (RW ∘ₗ RW ∘ₗ RW ∘ₗ RW)
      = LinearMap.trace k Wker (RW ∘ₗ RW ∘ₗ RW ∘ₗ RW) + 4 - 4 := by ring
    _ = 2 - 4 := by rw [hsum]
    _ = -2 := by norm_num

/-- (R∘R)∘(R∘R) = R∘R∘R∘R. -/
theorem Rlin_pow4_eq_sq_sq :
    (Rlin ∘ₗ Rlin) ∘ₗ (Rlin ∘ₗ Rlin) = Rlin ∘ₗ Rlin ∘ₗ Rlin ∘ₗ Rlin := by
  ext u; simp [LinearMap.comp_apply]

/-- Global tr(R⁴) = 0. -/
theorem Rlin_pow4_trace :
    LinearMap.trace k U (Rlin ∘ₗ Rlin ∘ₗ Rlin ∘ₗ Rlin) = 0 := by
  classical
  haveI : Module.Finite k residualKer := inferInstance
  haveI : Module.Free k residualKer := Module.Free.of_divisionRing k residualKer
  haveI : Module.Finite k Wker := inferInstance
  haveI : Module.Free k Wker := Module.Free.of_divisionRing k Wker
  haveI : Module.Finite k U := inferInstance
  haveI : Module.Free k U := inferInstance
  let hR : ∀ x ∈ residualKer, Rlin x ∈ residualKer := fun _ hx => residualKer_R_stable hx
  let hW : ∀ x ∈ Wker, Rlin x ∈ Wker := fun _ hx => Rlin_mem_Wker hx
  let e := residualKer.prodEquivOfIsCompl Wker isCompl_residualKer_Wker
  let fR := Rrestrict residualKer hR
  let fW := Rrestrict Wker hW
  let f := LinearMap.prodMap fR fW
  have hconj : Rlin = e.conj f := Rlin_eq_conj_prodMap
  -- R⁴ = (R²)² = e.conj(f)⁴ related
  have hR2 : Rlin ∘ₗ Rlin = e.conj (f ∘ₗ f) := by
    rw [hconj]
    exact (LinearEquiv.conj_comp e f f).symm
  have hR4 : Rlin ∘ₗ Rlin ∘ₗ Rlin ∘ₗ Rlin = e.conj (f ∘ₗ f ∘ₗ f ∘ₗ f) := by
    rw [← Rlin_pow4_eq_sq_sq, hR2]
    -- (e.conj (f∘f)) ∘ (e.conj (f∘f)) = e.conj ((f∘f)∘(f∘f))
    have h := (LinearEquiv.conj_comp e (f ∘ₗ f) (f ∘ₗ f)).symm
    convert h using 2
    ext ⟨x, y⟩ <;> simp [f, fR, fW, LinearMap.prodMap_apply, LinearMap.comp_apply]
  rw [hR4]
  rw [LinearMap.trace_conj' (R := k) (M := residualKer × Wker) (N := U)
    (f ∘ₗ f ∘ₗ f ∘ₗ f) e]
  have hff : f ∘ₗ f ∘ₗ f ∘ₗ f =
      LinearMap.prodMap (fR ∘ₗ fR ∘ₗ fR ∘ₗ fR) (fW ∘ₗ fW ∘ₗ fW ∘ₗ fW) := by
    ext ⟨x, y⟩ <;> simp [f, fR, fW, LinearMap.prodMap_apply, LinearMap.comp_apply]
  rw [hff, LinearMap.trace_prodMap']
  have ht1 : LinearMap.trace k residualKer (fR ∘ₗ fR ∘ₗ fR ∘ₗ fR) = (2 : k) :=
    Rrestrict_residual_pow4_trace
  have ht2 : LinearMap.trace k Wker (fW ∘ₗ fW ∘ₗ fW ∘ₗ fW) = (-2 : k) :=
    Rrestrict_Wker_pow4_trace
  rw [ht1, ht2]
  norm_num

/-- ambientAct(rotGen²) = exteriorPower.map 2 (R ∘ R). -/
theorem ambientAct_rotGen_pow_two_eq_map_R2 :
    ambientAct ((CentralizerN.rotGen : PSL2F11) ^ 2) =
      exteriorPower.map 2 (Rlin ∘ₗ Rlin) := by
  have h1 : ambientAct (CentralizerN.rotGen : PSL2F11) = exteriorPower.map 2 Rlin :=
    ambientAct_rotGen_eq_map_Rlin
  rw [pow_two, ambientAct_mul, h1]
  exact (exteriorPower.map_comp Rlin Rlin).symm

/-- χ_Λ²(rotGen²) = 0 by Newton. -/
theorem chiLambda2_rotGen_pow_two :
    chiLambda2 ((CentralizerN.rotGen : PSL2F11) ^ 2) = 0 := by
  dsimp [chiLambda2]
  rw [ambientAct_rotGen_pow_two_eq_map_R2]
  have h := trace_exterior_newton (V := U) (Rlin ∘ₗ Rlin)
  change LinearMap.trace k (⋀[k]^2 U) (exteriorPower.map 2 (Rlin ∘ₗ Rlin)) = 0
  rw [h, Rlin_sq_trace]
  -- tr((R∘R)∘(R∘R)) = tr(R⁴)
  have htr4 : LinearMap.trace k U ((Rlin ∘ₗ Rlin) ∘ₗ (Rlin ∘ₗ Rlin)) =
      LinearMap.trace k U (Rlin ∘ₗ Rlin ∘ₗ Rlin ∘ₗ Rlin) := by
    rw [Rlin_pow4_eq_sq_sq]
  rw [htr4, Rlin_pow4_trace]
  norm_num

/-- Order of rotGen² is 3. -/
theorem orderOf_rotGen_pow_two : orderOf ((CentralizerN.rotGen : PSL2F11) ^ 2) = 3 := by
  have hord6 := orderOf_rotGen_psl
  have h := orderOf_pow (x := (CentralizerN.rotGen : PSL2F11)) (n := 2)
  rw [hord6] at h
  simpa using h

/-! ### Order-6 conjugacy: χ_Λ² = 0 on all order-6 elements

|C_G(rotGen)|=6 ⇒ class size 110 = #order-6 ⇒ all conjugate to rotGen.
-/

theorem mem_centralizer_sigma_of_mem_centralizer_rotGen
    {g : PSL2F11}
    (h : g ∈ Subgroup.centralizer ({(CentralizerN.rotGen : PSL2F11)} : Set PSL2F11)) :
    g ∈ Subgroup.centralizer ({sigma} : Set PSL2F11) := by
  rw [Subgroup.mem_centralizer_singleton_iff] at h ⊢
  have hr3 : (CentralizerN.rotGen : PSL2F11) ^ 3 = sigma := rotGen_pow_three_eq_sigma
  have hcomm (n : ℕ) :
      g * (CentralizerN.rotGen : PSL2F11) ^ n =
        (CentralizerN.rotGen : PSL2F11) ^ n * g := by
    induction n with
    | zero => simp
    | succ n ih =>
      calc g * ((CentralizerN.rotGen : PSL2F11) ^ n * CentralizerN.rotGen)
          = (g * (CentralizerN.rotGen : PSL2F11) ^ n) * CentralizerN.rotGen := by
            rw [← mul_assoc]
        _ = ((CentralizerN.rotGen : PSL2F11) ^ n * g) * CentralizerN.rotGen := by rw [ih]
        _ = (CentralizerN.rotGen : PSL2F11) ^ n * (g * CentralizerN.rotGen) := by
            rw [mul_assoc]
        _ = (CentralizerN.rotGen : PSL2F11) ^ n * (CentralizerN.rotGen * g) := by rw [h]
        _ = ((CentralizerN.rotGen : PSL2F11) ^ n * CentralizerN.rotGen) * g := by
            rw [mul_assoc]
  have hpow : g * (CentralizerN.rotGen : PSL2F11) ^ 3 =
      (CentralizerN.rotGen : PSL2F11) ^ 3 * g := by
    simpa only [← pow_succ'] using hcomm 3
  rwa [hr3] at hpow

theorem centralizer_rotGen_le_centralizer_sigma :
    Subgroup.centralizer ({(CentralizerN.rotGen : PSL2F11)} : Set PSL2F11) ≤
      Subgroup.centralizer ({sigma} : Set PSL2F11) :=
  fun _ hx => mem_centralizer_sigma_of_mem_centralizer_rotGen hx

theorem reflGen_not_mem_centralizer_rotGen :
    (CentralizerN.reflGen : PSL2F11) ∉
      Subgroup.centralizer ({(CentralizerN.rotGen : PSL2F11)} : Set PSL2F11) := by
  intro h
  rw [Subgroup.mem_centralizer_singleton_iff] at h
  have hmr : (CentralizerN.rotGen : PSL2F11) * CentralizerN.reflGen =
      CentralizerN.reflGen * ((CentralizerN.rotGen : PSL2F11)⁻¹) :=
    congrArg Subtype.val CentralizerN.rotGen_mul_reflGen
  have heq : (CentralizerN.reflGen : PSL2F11) * CentralizerN.rotGen =
      CentralizerN.reflGen * ((CentralizerN.rotGen : PSL2F11)⁻¹) := by
    calc (CentralizerN.reflGen : PSL2F11) * CentralizerN.rotGen
        = CentralizerN.rotGen * CentralizerN.reflGen := h
      _ = CentralizerN.reflGen * ((CentralizerN.rotGen : PSL2F11)⁻¹) := hmr
  have hcancel : (CentralizerN.rotGen : PSL2F11) =
      (CentralizerN.rotGen : PSL2F11)⁻¹ := mul_left_cancel heq
  have hpow2 : (CentralizerN.rotGen : PSL2F11) ^ 2 = 1 := by
    have h1 : (CentralizerN.rotGen : PSL2F11) * CentralizerN.rotGen =
        (CentralizerN.rotGen : PSL2F11) *
          ((CentralizerN.rotGen : PSL2F11)⁻¹) := by
      exact congrArg (fun z => (CentralizerN.rotGen : PSL2F11) * z) hcancel
    rw [pow_two, h1]
    exact mul_inv_cancel (CentralizerN.rotGen : PSL2F11)
  have : orderOf (CentralizerN.rotGen : PSL2F11) ∣ 2 :=
    orderOf_dvd_of_pow_eq_one hpow2
  rw [orderOf_rotGen_psl] at this
  exact absurd this (by decide : ¬(6 ∣ 2))

theorem card_centralizer_rotGen :
    Nat.card (Subgroup.centralizer
      ({(CentralizerN.rotGen : PSL2F11)} : Set PSL2F11)) = 6 := by
  classical
  let C : Subgroup PSL2F11 :=
    Subgroup.centralizer ({(CentralizerN.rotGen : PSL2F11)} : Set PSL2F11)
  -- Use CentralizerN.sigma so Fintype instance from CentralizerD12 applies
  let N : Subgroup PSL2F11 :=
    Subgroup.centralizer ({CentralizerN.sigma} : Set PSL2F11)
  have hle : C ≤ N := by
    intro g hg
    have : g ∈ Subgroup.centralizer ({sigma} : Set PSL2F11) :=
      mem_centralizer_sigma_of_mem_centralizer_rotGen hg
    rwa [show sigma = CentralizerN.sigma from sigma_eq_CentralizerN_sigma] at this
  have hNcard : Nat.card N = 12 := by
    rw [Nat.card_eq_fintype_card]
    exact CentralizerN.centralizer_sigma_card
  have hrot_mem : (CentralizerN.rotGen : PSL2F11) ∈ C := by
    rw [Subgroup.mem_centralizer_singleton_iff]
  haveI : Fintype N := inferInstance
  haveI : Fintype C :=
    Fintype.ofInjective (Subgroup.inclusion hle) (Subgroup.inclusion_injective hle)
  have hdvd6 : 6 ∣ Nat.card C := by
    let x : C := ⟨CentralizerN.rotGen, hrot_mem⟩
    have hord : orderOf x = 6 := by
      rw [Subgroup.orderOf_mk, orderOf_rotGen_psl]
    have h := orderOf_dvd_card (x := x)
    rwa [hord, ← Nat.card_eq_fintype_card] at h
  have hdvd12 : Nat.card C ∣ 12 := by
    have h := Subgroup.card_dvd_of_le hle
    rwa [hNcard] at h
  have hCneN : C ≠ N := by
    intro hCN
    have hmem : (CentralizerN.reflGen : PSL2F11) ∈ N :=
      CentralizerN.reflGen.property
    have hmemC : (CentralizerN.reflGen : PSL2F11) ∈ C := hCN ▸ hmem
    exact reflGen_not_mem_centralizer_rotGen hmemC
  have hnot12 : Nat.card C ≠ 12 := by
    intro h12
    have hCN : C = N := by
      have hs : (C : Set PSL2F11) ⊆ (N : Set PSL2F11) := SetLike.coe_subset_coe.mpr hle
      have hC : (C : Set PSL2F11).ncard = Nat.card C :=
        (Nat.card_coe_set_eq (s := (C : Set PSL2F11))).symm
      have hN : (N : Set PSL2F11).ncard = Nat.card N :=
        (Nat.card_coe_set_eq (s := (N : Set PSL2F11))).symm
      have hcard : (N : Set PSL2F11).ncard ≤ (C : Set PSL2F11).ncard := by
        rw [hC, hN, h12, hNcard]
      have heq : (C : Set PSL2F11) = (N : Set PSL2F11) :=
        Set.eq_of_subset_of_ncard_le hs hcard (Set.toFinite _)
      exact SetLike.coe_injective heq
    exact hCneN hCN
  -- 6 | n, n | 12, n > 0 ⇒ n = 6 or 12
  have hpos : 0 < Nat.card C := Nat.card_pos
  obtain ⟨k, hk⟩ := hdvd6
  have h6k : 6 * k ∣ 12 := by
    rwa [hk] at hdvd12
  have hk_le : k ≤ 2 := by
    have : 6 * k ≤ 12 := Nat.le_of_dvd (by decide : 0 < 12) h6k
    omega
  have hk_pos : 0 < k := by
    have : 0 < 6 * k := by rwa [← hk]
    omega
  have hcases : Nat.card C = 6 ∨ Nat.card C = 12 := by
    have : k = 1 ∨ k = 2 := by omega
    cases this with
    | inl h1 =>
      left
      calc Nat.card C = 6 * k := hk
        _ = 6 * 1 := by rw [h1]
        _ = 6 := by norm_num
    | inr h2 =>
      right
      calc Nat.card C = 6 * k := hk
        _ = 6 * 2 := by rw [h2]
        _ = 12 := by norm_num
  cases hcases with
  | inl h => exact h
  | inr h => exact absurd h hnot12

theorem card_carrier_rotGen :
    Fintype.card (ConjClasses.mk (CentralizerN.rotGen : PSL2F11)).carrier = 110 := by
  classical
  have hG : Fintype.card PSL2F11 = 660 := card_PSL2F11
  let g0 : PSL2F11 := CentralizerN.rotGen
  have hcent : Nat.card (Subgroup.centralizer ({g0} : Set PSL2F11)) = 6 := by
    change Nat.card (Subgroup.centralizer
      ({(CentralizerN.rotGen : PSL2F11)} : Set PSL2F11)) = 6
    exact card_centralizer_rotGen
  have heq : Nat.card (Subgroup.centralizer ({g0} : Set PSL2F11)) =
      Nat.card (MulAction.stabilizer (ConjAct PSL2F11) g0) :=
    Subgroup.nat_card_centralizer_nat_card_stabilizer (G := PSL2F11) g0
  have hstab_nat : Nat.card (MulAction.stabilizer (ConjAct PSL2F11) g0) = 6 :=
    heq.symm.trans hcent
  haveI : Fintype (MulAction.stabilizer (ConjAct PSL2F11) g0) :=
    inferInstance
  have hstab : Fintype.card (MulAction.stabilizer (ConjAct PSL2F11) g0) = 6 := by
    rwa [← Nat.card_eq_fintype_card]
  have h := ConjClasses.card_carrier (G := PSL2F11) g0
  change Fintype.card (ConjClasses.mk g0).carrier = 110
  calc Fintype.card (ConjClasses.mk g0).carrier
      = Fintype.card PSL2F11 /
          Fintype.card (MulAction.stabilizer (ConjAct PSL2F11) g0) := h
    _ = 660 / 6 := by rw [hG, hstab]
    _ = 110 := by decide

theorem isConj_rotGen_of_order_six {g : PSL2F11} (hg : orderOf g = 6) :
    IsConj (CentralizerN.rotGen : PSL2F11) g := by
  classical
  have hordR : orderOf (CentralizerN.rotGen : PSL2F11) = 6 := orderOf_rotGen_psl
  have hsub : (ConjClasses.mk (CentralizerN.rotGen : PSL2F11)).carrier ⊆
      {x : PSL2F11 | orderOf x = 6} := by
    intro x hx
    have hmk : ConjClasses.mk x = ConjClasses.mk (CentralizerN.rotGen : PSL2F11) :=
      mem_carrier_iff_mk_eq.mp hx
    have hc : IsConj (CentralizerN.rotGen : PSL2F11) x :=
      isConj_comm.mp ((mk_eq_mk_iff_isConj).mp hmk)
    obtain ⟨c, hc'⟩ := isConj_iff.mp hc
    change orderOf x = 6
    calc orderOf x
        = orderOf (c * CentralizerN.rotGen * c⁻¹) := by rw [hc']
      _ = orderOf (CentralizerN.rotGen : PSL2F11) := orderOf_conj _ c
      _ = 6 := hordR
  have hcl := card_carrier_rotGen
  have h6 : Fintype.card {x : PSL2F11 // orderOf x = 6} = 110 :=
    PSLCard.card_psl_order_six
  let ι : (ConjClasses.mk (CentralizerN.rotGen : PSL2F11)).carrier →
      {x : PSL2F11 // orderOf x = 6} := fun x => ⟨x.1, hsub x.2⟩
  have hι_inj : Function.Injective ι := by
    intro a b hab
    have hval : a.val = b.val := by
      have := congrArg (fun z : {x : PSL2F11 // orderOf x = 6} => z.val) hab
      simpa [ι] using this
    exact Subtype.ext hval
  have hcard_eq : Fintype.card (ConjClasses.mk (CentralizerN.rotGen : PSL2F11)).carrier =
      Fintype.card {x : PSL2F11 // orderOf x = 6} := by omega
  have hι_bi : Function.Bijective ι :=
    (Fintype.bijective_iff_injective_and_card ι).2 ⟨hι_inj, hcard_eq⟩
  obtain ⟨y, hy⟩ := hι_bi.surjective ⟨g, hg⟩
  have hcar : g ∈ (ConjClasses.mk (CentralizerN.rotGen : PSL2F11)).carrier := by
    have : (ι y).val = g := congrArg Subtype.val hy
    convert y.property; exact this.symm
  have hmk : ConjClasses.mk g = ConjClasses.mk (CentralizerN.rotGen : PSL2F11) :=
    mem_carrier_iff_mk_eq.mp hcar
  exact isConj_comm.mp ((mk_eq_mk_iff_isConj).mp hmk)

theorem chiLambda2_eq_zero_of_order_six {g : PSL2F11} (hg : orderOf g = 6) :
    chiLambda2 g = 0 := by
  have hc := isConj_rotGen_of_order_six hg
  have h := chiLambda2_isConj hc
  rw [← h, chiLambda2_rotGen]

public theorem sum_chi_chiLambda2_order_six :
    (∑ g : {g : PSL2F11 // orderOf g = 6}, chi10' g.1 * chiLambda2 g.1) =
      (0 : k) := by
  classical
  refine Finset.sum_eq_zero fun g _ => ?_
  have ho : orderOf g.1 = 6 := g.2
  have hc : chi10' g.1 = (-1 : k) := by simp [chi10', ho]
  have hΛ : chiLambda2 g.1 = 0 := chiLambda2_eq_zero_of_order_six ho
  rw [hc, hΛ, mul_zero]


/-! ## Order-3 conjugacy: χ_Λ² = 0 on all order-3 elements -/

private abbrev rGen : PSL2F11 := CentralizerN.rotGen
private abbrev sGen : PSL2F11 := CentralizerN.reflGen
private abbrev r2 : PSL2F11 := rGen ^ 2

/-! ### Basic facts -/

theorem centralizer_rotGen_le_centralizer_rotGen_pow_two :
    Subgroup.centralizer ({rGen} : Set PSL2F11) ≤
      Subgroup.centralizer ({r2} : Set PSL2F11) := by
  intro g hg
  rw [Subgroup.mem_centralizer_singleton_iff] at hg ⊢
  have : g * (rGen * rGen) = (rGen * rGen) * g := by
    calc g * (rGen * rGen)
        = (g * rGen) * rGen := by rw [mul_assoc]
      _ = (rGen * g) * rGen := by rw [hg]
      _ = rGen * (g * rGen) := by rw [mul_assoc]
      _ = rGen * (rGen * g) := by rw [hg]
      _ = (rGen * rGen) * g := by rw [mul_assoc]
  simpa [pow_two] using this

private theorem sGen_mul_self : sGen * sGen = 1 := by
  have h := pow_orderOf_eq_one sGen
  rwa [orderOf_reflGen_psl, pow_two] at h

private theorem sGen_inv : sGen⁻¹ = sGen :=
  inv_eq_of_mul_eq_one_left sGen_mul_self

private theorem sGen_conj_rGen : sGen * rGen * sGen = rGen⁻¹ :=
  congrArg Subtype.val CentralizerN.reflGen_conj_rotGen

/-- s r² s = (r²)⁻¹ -/
private theorem sGen_conj_r2 : sGen * r2 * sGen = r2⁻¹ := by
  -- Expand r2 = r*r and insert s*s = 1 in the middle
  have h : sGen * rGen * rGen * sGen = rGen⁻¹ * rGen⁻¹ := by
    have hins :
        sGen * rGen * rGen * sGen =
          sGen * rGen * sGen * sGen * rGen * sGen := by
      calc sGen * rGen * rGen * sGen
          = sGen * rGen * (1 : PSL2F11) * rGen * sGen := by
            simp only [mul_one, mul_assoc]
        _ = sGen * rGen * (sGen * sGen) * rGen * sGen := by rw [← sGen_mul_self]
        _ = sGen * rGen * sGen * sGen * rGen * sGen := by simp only [mul_assoc]
    calc sGen * rGen * rGen * sGen
        = sGen * rGen * sGen * sGen * rGen * sGen := hins
      _ = (sGen * rGen * sGen) * (sGen * rGen * sGen) := by simp only [mul_assoc]
      _ = rGen⁻¹ * rGen⁻¹ := by rw [sGen_conj_rGen]
  calc sGen * r2 * sGen
      = sGen * (rGen ^ 2) * sGen := rfl
    _ = sGen * (rGen * rGen) * sGen := by rw [pow_two]
    _ = sGen * rGen * rGen * sGen := by simp only [mul_assoc]
    _ = rGen⁻¹ * rGen⁻¹ := h
    _ = (rGen⁻¹) ^ 2 := by rw [pow_two]
    _ = (rGen ^ 2)⁻¹ := by rw [← inv_pow]
    _ = r2⁻¹ := rfl

private theorem r2_inv_eq_pow_two : r2⁻¹ = r2 ^ 2 := by
  have hord : orderOf r2 = 3 := orderOf_rotGen_pow_two
  have h3 : r2 ^ 3 = 1 := by
    have := pow_orderOf_eq_one r2
    rwa [hord] at this
  -- r2 * r2^2 = r2^3 = 1 ⇒ r2⁻¹ = r2^2
  have hmul : r2 * r2 ^ 2 = 1 := by
    calc r2 * r2 ^ 2
        = r2 ^ 1 * r2 ^ 2 := by rw [pow_one]
      _ = r2 ^ (1 + 2) := (pow_add r2 1 2).symm
      _ = r2 ^ 3 := by norm_num
      _ = 1 := h3
  exact inv_eq_of_mul_eq_one_right hmul

private theorem sGen_conj_r2_as_pow : sGen * r2 * sGen = r2 ^ 2 := by
  rw [sGen_conj_r2, r2_inv_eq_pow_two]

/-- reflGen does not centralize r². -/
theorem reflGen_not_mem_centralizer_rotGen_pow_two :
    sGen ∉ Subgroup.centralizer ({r2} : Set PSL2F11) := by
  intro h
  rw [Subgroup.mem_centralizer_singleton_iff] at h
  have hsr2 : sGen * r2 = r2⁻¹ * sGen := by
    have := congrArg (fun z => z * sGen) sGen_conj_r2
    simpa [mul_assoc, sGen_mul_self] using this
  have hcancel : r2 = r2⁻¹ := mul_right_cancel (h.symm.trans hsr2)
  have hpow : r2 ^ 2 = 1 := by
    have := congrArg (fun z => z * r2) hcancel
    -- this: r2 * r2 = r2⁻¹ * r2
    have hL : r2 * r2 = r2 ^ 2 := (pow_two r2).symm
    have hR : r2⁻¹ * r2 = 1 := inv_mul_cancel r2
    rw [hL] at this
    rwa [hR] at this
  have hdvd : orderOf r2 ∣ 2 := orderOf_dvd_of_pow_eq_one hpow
  rw [orderOf_rotGen_pow_two] at hdvd
  exact absurd hdvd (by decide : ¬(3 ∣ 2))

/-! ### C({r2}) ≤ N(⟨r2⟩) -/

private theorem centralizer_r2_le_normalizer :
    Subgroup.centralizer ({r2} : Set PSL2F11) ≤
      Subgroup.normalizer (Subgroup.zpowers r2 : Set PSL2F11) := by
  intro g hg
  rw [Subgroup.mem_centralizer_singleton_iff] at hg
  -- g * r2 = r2 * g ⇒ g * r2 * g⁻¹ = r2
  have hconj : g * r2 * g⁻¹ = r2 := by
    calc g * r2 * g⁻¹
        = (g * r2) * g⁻¹ := by rw [mul_assoc]
      _ = (r2 * g) * g⁻¹ := by rw [hg]
      _ = r2 * (g * g⁻¹) := by rw [mul_assoc]
      _ = r2 := by rw [mul_inv_cancel, mul_one]
  -- so g conjugates powers of r2 to themselves
  refine Subgroup.mem_normalizer_fintype (S := (Subgroup.zpowers r2 : Set PSL2F11)) ?_
  intro n hn
  obtain ⟨k, rfl⟩ := Subgroup.mem_zpowers_iff.mp hn
  -- g * r2^k * g⁻¹ = (g r2 g⁻¹)^k = r2^k
  have : g * (r2 ^ k) * g⁻¹ = r2 ^ k := by
    rw [← conj_zpow, hconj]
  rw [this]
  exact Subgroup.mem_zpowers_iff.mpr ⟨k, rfl⟩

/-- s normalizes ⟨r2⟩. -/
private theorem sGen_mem_normalizer_r2 :
    sGen ∈ Subgroup.normalizer (Subgroup.zpowers r2 : Set PSL2F11) := by
  refine Subgroup.mem_normalizer_fintype (S := (Subgroup.zpowers r2 : Set PSL2F11)) ?_
  intro n hn
  obtain ⟨k, rfl⟩ := Subgroup.mem_zpowers_iff.mp hn
  -- s * r2^k * s⁻¹ = (s r2 s)^k = (r2^2)^k = r2^{2k}
  have hbase : sGen * r2 * sGen⁻¹ = r2 ^ (2 : ℤ) := by
    rw [sGen_inv, sGen_conj_r2_as_pow]
    exact (zpow_natCast r2 2).symm
  have : sGen * (r2 ^ k) * sGen⁻¹ = (r2 ^ (2 : ℤ)) ^ k := by
    rw [← conj_zpow, hbase]
  rw [this, ← zpow_mul]
  exact Subgroup.mem_zpowers_iff.mpr ⟨(2 : ℤ) * k, rfl⟩

/-! ### ⟨r²⟩ is Sylow 3; n₃ = 55; |N_G(⟨r²⟩)| = 12 -/

private theorem card_G : Nat.card PSL2F11 = 660 := by
  rw [Nat.card_eq_fintype_card, card_PSL2F11]

private theorem zpowers_r2_card : Nat.card (Subgroup.zpowers r2) = 3 := by
  rw [Nat.card_zpowers, orderOf_rotGen_pow_two]

private theorem zpowers_r2_index : (Subgroup.zpowers r2).index = 220 := by
  have hmul := Subgroup.index_mul_card (Subgroup.zpowers r2)
  rw [zpowers_r2_card, card_G] at hmul
  omega

private theorem zpowers_r2_isPGroup : IsPGroup 3 (Subgroup.zpowers r2) :=
  IsPGroup.of_card (n := 1) (by rw [zpowers_r2_card]; norm_num)

private theorem zpowers_r2_not_dvd_index : ¬(3 ∣ (Subgroup.zpowers r2).index) := by
  rw [zpowers_r2_index]; decide

private noncomputable def sylow_r2 : Sylow 3 PSL2F11 := by
  haveI : Fact (Nat.Prime 3) := ⟨by decide⟩
  exact zpowers_r2_isPGroup.toSylow zpowers_r2_not_dvd_index

private theorem sylow_r2_coe :
    (sylow_r2 : Subgroup PSL2F11) = Subgroup.zpowers r2 := by
  haveI : Fact (Nat.Prime 3) := ⟨by decide⟩
  exact IsPGroup.toSylow_coe zpowers_r2_isPGroup zpowers_r2_not_dvd_index

private theorem card_sylow3 (Q : Sylow 3 PSL2F11) : Nat.card Q = 3 := by
  haveI : Fact (Nat.Prime 3) := ⟨by decide⟩
  rw [Sylow.card_eq_multiplicity]
  have hfac : Nat.factorization (Nat.card PSL2F11) 3 = 1 := by
    rw [card_G]
    have hp : Nat.Prime 3 := by decide
    rw [show 660 = 3 * 220 by norm_num,
      Nat.factorization_mul (by norm_num) (by norm_num), Finsupp.add_apply,
      hp.factorization_self,
      Nat.factorization_eq_zero_of_not_dvd (by norm_num : ¬ 3 ∣ 220)]
  rw [hfac]; norm_num

private theorem orderOf_ne_one_of_mem_sylow3 (Q : Sylow 3 PSL2F11)
    (y : Q) (hne : (y : PSL2F11) ≠ 1) : orderOf (y : PSL2F11) = 3 := by
  haveI : Fact (Nat.Prime 3) := ⟨by decide⟩
  haveI : Fintype Q := Fintype.ofFinite _
  -- Lagrange: y^{|Q|} = 1 in the finite group Q
  have hy_card : y ^ Fintype.card Q = 1 := pow_card_eq_one
  have hcardQ : Fintype.card Q = 3 := by
    have h := card_sylow3 Q
    rwa [Nat.card_eq_fintype_card] at h
  have hy3_Q : y ^ 3 = 1 := by rwa [hcardQ] at hy_card
  have hy3 : (y : PSL2F11) ^ 3 = 1 := by
    simpa [SubmonoidClass.coe_pow] using congrArg Subtype.val hy3_Q
  exact orderOf_eq_prime hy3 hne

/-- Non-identity elements of a Sylow 3-subgroup, as ambient group elements. -/
private abbrev sylow3NonId (Q : Sylow 3 PSL2F11) : Type :=
  {g : PSL2F11 // g ∈ (Q : Set PSL2F11) ∧ g ≠ 1}

private theorem card_sylow3NonId (Q : Sylow 3 PSL2F11) : Nat.card (sylow3NonId Q) = 2 := by
  classical
  haveI : Fintype Q := Fintype.ofFinite _
  have hcardQ : Nat.card Q = 3 := card_sylow3 Q
  -- Equiv with {y : Q // y ≠ 1}
  let e : sylow3NonId Q ≃ {y : Q // y ≠ 1} := by
    refine ⟨?toFun, ?invFun, ?li, ?ri⟩
    · intro ⟨g, hg, hne⟩
      exact ⟨⟨g, hg⟩, fun h => hne (congrArg Subtype.val h)⟩
    · intro ⟨y, hyne⟩
      exact ⟨(y : PSL2F11), y.property, fun h => hyne (Subtype.ext h)⟩
    · intro ⟨g, hg, hne⟩; rfl
    · intro ⟨y, hyne⟩; rfl
  haveI : Fintype {y : Q // y ≠ 1} := Fintype.ofFinite _
  haveI : Fintype {y : Q // y = 1} := Fintype.ofFinite _
  have hne : Nat.card {y : Q // y ≠ 1} = 2 := by
    have h1 : Fintype.card {y : Q // y = 1} = 1 := by
      rw [Fintype.card_eq_one_iff]
      exact ⟨⟨1, rfl⟩, fun z => Subtype.ext z.property⟩
    have hcompl := Fintype.card_subtype_compl (fun y : Q => y = 1)
    -- hcompl: card {¬ = 1} = card Q - card {= 1}; ≠ is ¬=
    calc Nat.card {y : Q // y ≠ 1}
        = Fintype.card {y : Q // y ≠ 1} := Nat.card_eq_fintype_card
      _ = Fintype.card Q - Fintype.card {y : Q // y = 1} := hcompl
      _ = Fintype.card Q - 1 := by rw [h1]
      _ = Nat.card Q - 1 := by rw [← Nat.card_eq_fintype_card]
      _ = 3 - 1 := by rw [hcardQ]
      _ = 2 := by norm_num
  rwa [Nat.card_congr e]

private noncomputable def sylowOfOrderThree
    (x : {g : PSL2F11 // orderOf g = 3}) : Sylow 3 PSL2F11 := by
  haveI : Fact (Nat.Prime 3) := ⟨by decide⟩
  have hord : orderOf x.1 = 3 := x.2
  have hc : Nat.card (Subgroup.zpowers x.1) = 3 := by rw [Nat.card_zpowers, hord]
  have hIP : IsPGroup 3 (Subgroup.zpowers x.1) :=
    IsPGroup.of_card (n := 1) (by rw [hc]; norm_num)
  have hix : (Subgroup.zpowers x.1).index = 220 := by
    have hmul := Subgroup.index_mul_card (Subgroup.zpowers x.1)
    rw [hc, card_G] at hmul
    omega
  have hnd : ¬(3 ∣ (Subgroup.zpowers x.1).index) := by rw [hix]; decide
  exact hIP.toSylow hnd

private theorem sylowOfOrderThree_coe (x : {g : PSL2F11 // orderOf g = 3}) :
    (sylowOfOrderThree x : Subgroup PSL2F11) = Subgroup.zpowers x.1 := by
  haveI : Fact (Nat.Prime 3) := ⟨by decide⟩
  simp only [sylowOfOrderThree]
  exact IsPGroup.toSylow_coe _ _

private theorem card_sylow3_eq_fifty_five : Nat.card (Sylow 3 PSL2F11) = 55 := by
  classical
  haveI : Fact (Nat.Prime 3) := ⟨by decide⟩
  haveI : Fintype (Sylow 3 PSL2F11) := Fintype.ofFinite _
  have hcard3 : Fintype.card {x : PSL2F11 // orderOf x = 3} = 110 :=
    PSLCard.card_psl_order_three
  -- Equiv: order-3 elements ↔ Σ Q, non-id ambient elements of Q
  let e : {g : PSL2F11 // orderOf g = 3} ≃
      Σ Q : Sylow 3 PSL2F11, sylow3NonId Q := by
    refine ⟨?toFun, ?invFun, ?left_inv, ?right_inv⟩
    · intro x
      refine ⟨sylowOfOrderThree x, ⟨x.1, ?mem, ?ne⟩⟩
      · have : x.1 ∈ Subgroup.zpowers x.1 := Subgroup.mem_zpowers x.1
        rwa [← sylowOfOrderThree_coe x] at this
      · intro heq
        have hord1 : orderOf (1 : PSL2F11) = 3 := by
          convert x.2; exact heq.symm
        exact absurd hord1 (by simp)
    · intro ⟨Q, ⟨g, hg, hne⟩⟩
      exact ⟨g, orderOf_ne_one_of_mem_sylow3 Q ⟨g, hg⟩ hne⟩
    · intro x; rfl
    · intro ⟨Q, ⟨g, hg, hne⟩⟩
      have hordy : orderOf g = 3 :=
        orderOf_ne_one_of_mem_sylow3 Q ⟨g, hg⟩ hne
      have hle : Subgroup.zpowers g ≤ (Q : Subgroup PSL2F11) :=
        Subgroup.zpowers_le.mpr hg
      have hcard_z : Nat.card (Subgroup.zpowers g) = 3 := by
        rw [Nat.card_zpowers, hordy]
      have hcard_Q := card_sylow3 Q
      have heq_sub : Subgroup.zpowers g = (Q : Subgroup PSL2F11) :=
        Subgroup.eq_of_le_of_card_ge hle (by rw [hcard_Q, hcard_z])
      have hsy : (sylowOfOrderThree ⟨g, hordy⟩ : Subgroup PSL2F11) =
          (Q : Subgroup PSL2F11) := by
        rw [sylowOfOrderThree_coe, heq_sub]
      have hQeq : sylowOfOrderThree ⟨g, hordy⟩ = Q := Sylow.ext hsy
      -- Σ Q, {g : G // g ∈ Q ∧ g ≠ 1} — subtype_ext with fixed base G
      exact Sigma.subtype_ext hQeq rfl
  have hsum : Nat.card {g : PSL2F11 // orderOf g = 3} =
      Nat.card (Sylow 3 PSL2F11) * 2 := by
    have heq_card := Nat.card_congr e
    -- Each fiber is finite (card 2)
    haveI : ∀ Q : Sylow 3 PSL2F11, Finite (sylow3NonId Q) := fun Q => by
      have h := card_sylow3NonId Q
      exact Nat.finite_of_card_ne_zero (by rw [h]; norm_num)
    have hsig : Nat.card (Σ Q : Sylow 3 PSL2F11, sylow3NonId Q) =
        ∑ Q : Sylow 3 PSL2F11, Nat.card (sylow3NonId Q) :=
      Nat.card_sigma
    calc Nat.card {g : PSL2F11 // orderOf g = 3}
        = Nat.card (Σ Q : Sylow 3 PSL2F11, sylow3NonId Q) := heq_card
      _ = ∑ Q : Sylow 3 PSL2F11, Nat.card (sylow3NonId Q) := hsig
      _ = ∑ _Q : Sylow 3 PSL2F11, (2 : ℕ) :=
          Finset.sum_congr rfl fun Q _ => card_sylow3NonId Q
      _ = Fintype.card (Sylow 3 PSL2F11) * 2 := by
          rw [Finset.sum_const, Finset.card_univ, smul_eq_mul, mul_comm]
      _ = Nat.card (Sylow 3 PSL2F11) * 2 := by rw [← Nat.card_eq_fintype_card]
  have : Nat.card (Sylow 3 PSL2F11) * 2 = 110 := by
    rw [← hsum, Nat.card_eq_fintype_card, hcard3]
  omega

private theorem card_normalizer_r2 :
    Nat.card (Subgroup.normalizer (Subgroup.zpowers r2 : Set PSL2F11)) = 12 := by
  haveI : Fact (Nat.Prime 3) := ⟨by decide⟩
  have hidx : Nat.card (Sylow 3 PSL2F11) =
      (Subgroup.normalizer (sylow_r2 : Set PSL2F11)).index :=
    Sylow.card_eq_index_normalizer sylow_r2
  have hN_eq : Subgroup.normalizer (Subgroup.zpowers r2 : Set PSL2F11) =
      Subgroup.normalizer (sylow_r2 : Set PSL2F11) := by
    -- carriers of sylow_r2 and zpowers r2 agree
    have hc : (sylow_r2 : Set PSL2F11) = (Subgroup.zpowers r2 : Set PSL2F11) := by
      change ((sylow_r2 : Subgroup PSL2F11) : Set PSL2F11) =
        (Subgroup.zpowers r2 : Set PSL2F11)
      rw [sylow_r2_coe]
    rw [hc]
  rw [hN_eq]
  have hmul :=
    Subgroup.index_mul_card (Subgroup.normalizer (sylow_r2 : Set PSL2F11))
  -- hmul: index * card N = card G; index = n_3 = 55
  rw [← hidx, card_sylow3_eq_fifty_five, card_G] at hmul
  -- 55 * Nat.card N = 660
  omega

/-! ### |C_G(r²)| = 6 -/

theorem card_centralizer_rotGen_pow_two :
    Nat.card (Subgroup.centralizer ({r2} : Set PSL2F11)) = 6 := by
  classical
  let C := Subgroup.centralizer ({r2} : Set PSL2F11)
  let Cr := Subgroup.centralizer ({rGen} : Set PSL2F11)
  let N := Subgroup.normalizer (Subgroup.zpowers r2 : Set PSL2F11)
  have hle : Cr ≤ C := centralizer_rotGen_le_centralizer_rotGen_pow_two
  have hCr : Nat.card Cr = 6 := card_centralizer_rotGen
  have hdvd6 : 6 ∣ Nat.card C := by
    have h := Subgroup.card_dvd_of_le hle
    rwa [hCr] at h
  have hC_le_N : C ≤ N := centralizer_r2_le_normalizer
  have hNG : Nat.card N = 12 := card_normalizer_r2
  have hdvd12 : Nat.card C ∣ 12 := by
    have h := Subgroup.card_dvd_of_le hC_le_N
    rwa [hNG] at h
  have hrefl_norm : sGen ∈ N := sGen_mem_normalizer_r2
  have hnot12 : Nat.card C ≠ 12 := by
    intro h12
    have hCN : C = N := by
      have hs : (C : Set PSL2F11) ⊆ (N : Set PSL2F11) :=
        SetLike.coe_subset_coe.mpr hC_le_N
      have hC : (C : Set PSL2F11).ncard = Nat.card C :=
        (Nat.card_coe_set_eq (s := (C : Set PSL2F11))).symm
      have hN : (N : Set PSL2F11).ncard = Nat.card N :=
        (Nat.card_coe_set_eq (s := (N : Set PSL2F11))).symm
      have hcard : (N : Set PSL2F11).ncard ≤ (C : Set PSL2F11).ncard := by
        rw [hC, hN, h12, hNG]
      exact SetLike.coe_injective
        (Set.eq_of_subset_of_ncard_le hs hcard (Set.toFinite _))
    have : sGen ∈ C := by rw [hCN]; exact hrefl_norm
    exact reflGen_not_mem_centralizer_rotGen_pow_two this
  have hpos : 0 < Nat.card C := Nat.card_pos
  obtain ⟨k, hk⟩ := hdvd6
  have h6k : 6 * k ∣ 12 := by rwa [hk] at hdvd12
  have hk_le : k ≤ 2 := by
    have : 6 * k ≤ 12 := Nat.le_of_dvd (by decide : 0 < 12) h6k
    omega
  have hk_pos : 0 < k := by
    have : 0 < 6 * k := by rwa [← hk]
    omega
  have hcases : Nat.card C = 6 ∨ Nat.card C = 12 := by
    have : k = 1 ∨ k = 2 := by omega
    cases this with
    | inl h1 =>
      left
      calc Nat.card C = 6 * k := hk
        _ = 6 * 1 := by rw [h1]
        _ = 6 := by norm_num
    | inr h2 =>
      right
      calc Nat.card C = 6 * k := hk
        _ = 6 * 2 := by rw [h2]
        _ = 12 := by norm_num
  cases hcases with
  | inl h => exact h
  | inr h => exact absurd h hnot12

/-! ### Class size 110, conjugacy, χ_Λ² = 0 -/

theorem card_carrier_rotGen_pow_two :
    Fintype.card (ConjClasses.mk r2).carrier = 110 := by
  classical
  have hG : Fintype.card PSL2F11 = 660 := card_PSL2F11
  have hcent : Nat.card (Subgroup.centralizer ({r2} : Set PSL2F11)) = 6 :=
    card_centralizer_rotGen_pow_two
  have heq : Nat.card (Subgroup.centralizer ({r2} : Set PSL2F11)) =
      Nat.card (MulAction.stabilizer (ConjAct PSL2F11) r2) :=
    Subgroup.nat_card_centralizer_nat_card_stabilizer (G := PSL2F11) r2
  have hstab_nat : Nat.card (MulAction.stabilizer (ConjAct PSL2F11) r2) = 6 :=
    heq.symm.trans hcent
  haveI : Fintype (MulAction.stabilizer (ConjAct PSL2F11) r2) := inferInstance
  have hstab : Fintype.card (MulAction.stabilizer (ConjAct PSL2F11) r2) = 6 := by
    rwa [← Nat.card_eq_fintype_card]
  have h := ConjClasses.card_carrier (G := PSL2F11) r2
  calc Fintype.card (ConjClasses.mk r2).carrier
      = Fintype.card PSL2F11 /
          Fintype.card (MulAction.stabilizer (ConjAct PSL2F11) r2) := h
    _ = 660 / 6 := by rw [hG, hstab]
    _ = 110 := by decide

theorem isConj_rotGen_pow_two_of_order_three {g : PSL2F11} (hg : orderOf g = 3) :
    IsConj r2 g := by
  classical
  have hordR : orderOf r2 = 3 := orderOf_rotGen_pow_two
  have hsub : (ConjClasses.mk r2).carrier ⊆ {x : PSL2F11 | orderOf x = 3} := by
    intro x hx
    have hmk : ConjClasses.mk x = ConjClasses.mk r2 := mem_carrier_iff_mk_eq.mp hx
    have hc : IsConj r2 x := isConj_comm.mp ((mk_eq_mk_iff_isConj).mp hmk)
    obtain ⟨c, hc'⟩ := isConj_iff.mp hc
    change orderOf x = 3
    calc orderOf x
        = orderOf (c * r2 * c⁻¹) := by rw [hc']
      _ = orderOf r2 := orderOf_conj _ c
      _ = 3 := hordR
  have hcl := card_carrier_rotGen_pow_two
  have h3 : Fintype.card {x : PSL2F11 // orderOf x = 3} = 110 :=
    PSLCard.card_psl_order_three
  let ι : (ConjClasses.mk r2).carrier → {x : PSL2F11 // orderOf x = 3} :=
    fun x => ⟨x.1, hsub x.2⟩
  have hι_inj : Function.Injective ι := by
    intro a b hab
    have hval : a.val = b.val := by
      have := congrArg (fun z : {x : PSL2F11 // orderOf x = 3} => z.val) hab
      simpa [ι] using this
    exact Subtype.ext hval
  have hcard_eq : Fintype.card (ConjClasses.mk r2).carrier =
      Fintype.card {x : PSL2F11 // orderOf x = 3} := by omega
  have hι_bi : Function.Bijective ι :=
    (Fintype.bijective_iff_injective_and_card ι).2 ⟨hι_inj, hcard_eq⟩
  obtain ⟨y, hy⟩ := hι_bi.surjective ⟨g, hg⟩
  have hcar : g ∈ (ConjClasses.mk r2).carrier := by
    have : (ι y).val = g := congrArg Subtype.val hy
    convert y.property; exact this.symm
  have hmk : ConjClasses.mk g = ConjClasses.mk r2 := mem_carrier_iff_mk_eq.mp hcar
  exact isConj_comm.mp ((mk_eq_mk_iff_isConj).mp hmk)

theorem chiLambda2_eq_zero_of_order_three {g : PSL2F11} (hg : orderOf g = 3) :
    chiLambda2 g = 0 := by
  have hc := isConj_rotGen_pow_two_of_order_three hg
  have h := chiLambda2_isConj hc
  rw [← h, chiLambda2_rotGen_pow_two]

public theorem sum_chi_chiLambda2_order_three :
    (∑ g : {g : PSL2F11 // orderOf g = 3}, chi10' g.1 * chiLambda2 g.1) =
      (0 : k) := by
  classical
  refine Finset.sum_eq_zero fun g _ => ?_
  have ho : orderOf g.1 = 3 := g.2
  have hc : chi10' g.1 = (1 : k) := by simp [chi10', ho]
  have hΛ : chiLambda2 g.1 = 0 := chiLambda2_eq_zero_of_order_three ho
  rw [hc, hΛ, mul_zero]

/-! ### Residual pure-M exclusion (unconditional)

Sealed: ∑χ²=660, χ-convolution, `π²=π`, `MFix=Msub`, pure-M ⇒ residual ∈ Msub
and G-orbit ⊂ Msub, `IsProj Msub π`, `tr(π)=finrank Msub`,
`tr(π)=(10/660)∑ χ χ_Λ²`, `∑ χ χ_Λ² = 66 d`.
Sealed: `χ_Λ²(σ)=3` (Newton), order-2 contrib `330`, id contrib `150`,
order-5 contrib `0` (χ=0); id+ord2 = `480`.
Sealed: order-6 and order-3 conjugacy ⇒ χ_Λ²=0, class sums 0.
**Closed:** order-11 weighted 180 via `Ord11CharacterSum`
(`sum_chi_chiLambda2_eq_sixsixty`, `finrank_Msub_eq_ten`).
Bridges: `residual_plucker_projectorM_ne_of_cross_ne_forty_two`. -/

#print axioms Rrestrict_residual_sq_add_id
#print axioms Rrestrict_residual_no_eigen
#print axioms smul_one_mul_matrix
#print axioms mem_centralizer_sigma_of_mem_centralizer_rotGen
#print axioms reflGen_not_mem_centralizer_rotGen
#print axioms card_centralizer_rotGen
#print axioms card_carrier_rotGen
#print axioms isConj_rotGen_of_order_six
#print axioms chiLambda2_eq_zero_of_order_six
#print axioms sum_chi_chiLambda2_order_six
#print axioms card_centralizer_rotGen_pow_two
#print axioms isConj_rotGen_pow_two_of_order_three
#print axioms chiLambda2_eq_zero_of_order_three
#print axioms sum_chi_chiLambda2_order_three
#print axioms Rrestrict_residual_pow4_trace
#print axioms Rrestrict_Wker_pow4_trace
#print axioms Rlin_pow4_trace
#print axioms ambientAct_rotGen_pow_two_eq_map_R2
#print axioms chiLambda2_rotGen_pow_two
#print axioms orderOf_rotGen_pow_two
#print axioms Rrestrict_residual_sq_trace
#print axioms Rrestrict_Wker_sq_trace
#print axioms Rlin_sq_trace
#print axioms ambientAct_rotGen_eq_map_Rlin
#print axioms chiLambda2_rotGen
#print axioms Rrestrict_residual_trace
#print axioms Rrestrict_Wker_trace
#print axioms Rlin_eq_conj_prodMap
#print axioms Rlin_trace
#print axioms sum_chi_eq_N_plus_cross
#print axioms chiCrossTerm_of_mem_Mfix
#print axioms not_mem_Mfix_of_cross_ne_forty_two
#print axioms not_mem_Mfix_of_cross_not_parallel
#print axioms exists_dual_sum_twentyfour_of_cross_not_parallel
#print axioms residual_plucker_projectorM_ne_of_cross_ne_forty_two
#print axioms residual_plucker_projectorM_ne_of_cross_not_parallel
#print axioms residual_cross_ne_forty_two_of_mul_ne_zero
#print axioms pureWedge_residual_ne_zero
#print axioms projectorM_N_partial_residual_ne_id
#print axioms finrank_Lambda2U
#print axioms residual_plucker_N_all_fixed
#print axioms projectorM_ne_of_dual_sum_eq_twentyfour
#print axioms chi10'_sum_sq
#print axioms chiSumOp_orbit_eq_sixty_six_of_pureM
#print axioms gspan_mem_eigen_of_pureM
#print axioms PSLCard.sum_comp_mk
#print axioms PSLCard.chi10Int_sum_sq_psl
#print axioms PSLCard.chi10Int_convolution
#print axioms chi10'_convolution
#print axioms chiSumOp_sq_apply
#print axioms projectorM_sq_apply
#print axioms Mfix_eq_Msub
#print axioms chiSumOp_eq_smul_projectorM
#print axioms mem_Msub_of_mem_Mfix
#print axioms ambientAct_mem_Msub_of_pureM
#print axioms residual_plucker_mem_Msub_of_pureM
#print axioms residual_plucker_mem_Msub_of_mem_Mfix
#print axioms projectorM_isProj
#print axioms projectorM_trace_eq_finrank
#print axioms chiLambda2_one
#print axioms card_carrier_sigma
#print axioms chiLambda2_isConj
#print axioms isConj_sigma_of_order_two
#print axioms chiLambda2_eq_of_order_two
#print axioms chiSumOp_trace
#print axioms sum_chi_chiLambda2
#print axioms projectorM_trace_eq_scaled_sum
#print axioms finrank_Msub_eq_ten_of_sum_chi_chiLambda2
#print axioms algebra_trace_iRoot
#print axioms LtoEnd_root
#print axioms finrank_Ladj_U
#print axioms Jlin_trace
#print axioms chiLambda2_sigma
#print axioms trace_exterior_newton
#print axioms chiLambda2_eq_three_of_order_two
#print axioms sum_chi_chiLambda2_order_two
#print axioms sum_chi_chiLambda2_order_one
#print axioms sum_chi_chiLambda2_order_five
#print axioms sum_chi_chiLambda2_orders_one_two

#print axioms aeval_Rlin_X6_add_one
#print axioms isCoprime_X2p1_X4
#print axioms isCompl_residualKer_Wker
#print axioms not_dvd_X2p1_X4
#print axioms no_root_X4_sub_X2_add_one
#print axioms not_exists_monic_quad_dvd_X4

#print axioms irreducible_X4_sub_X2_add_one
#print axioms Rlin_mem_Wker
#print axioms Wker_ne_bot
#print axioms residualKer_ne_bot
#print axioms aeval_Rlin_pW_of_residual_bot

#print axioms finrank_residualKer_ge_two
#print axioms finrank_Wker_ge_four
#print axioms finrank_residualKer_eq_two
#print axioms finrank_Wker_eq_four
#print axioms linearIndependent_Rpow_Wker

#print axioms finrank_residualKer_ge_two
#print axioms finrank_Wker_ge_four
#print axioms finrank_residualKer_eq_two
#print axioms finrank_Wker_eq_four
#print axioms linearIndependent_Rpow_Wker

end GeometricV14Carrier
end V14Formalization
