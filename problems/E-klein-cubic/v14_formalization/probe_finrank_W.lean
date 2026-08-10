import V14Formalization.GeometricV14Carrier
import Mathlib.RingTheory.AdjoinRoot
import Mathlib.LinearAlgebra.Dimension.Constructions
import Mathlib.LinearAlgebra.FreeModule.Finite.Basic
import Mathlib.LinearAlgebra.FiniteDimensional.Lemmas
import Mathlib.RingTheory.Ideal.Quotient.Defs
import Mathlib.Algebra.Polynomial.Eval.Defs

open Polynomial Module LinearMap AdjoinRoot
open V14Formalization.GeometricV14Carrier

set_option maxHeartbeats 32000000
noncomputable section

abbrev pW : k[X] := (X : k[X]) ^ 4 - X ^ 2 + (1 : k[X])

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
  -- h : aeval Rlin (X^4 − X^2 + 1) u = 0, and pW is that poly
  simpa [pW] using h

theorem residualKer_ne_bot : residualKer ≠ (⊥ : Submodule k U) := by
  intro hbot
  haveI : Module.Finite k U := inferInstance
  haveI : Module.Free k U := inferInstance
  have hann : aeval (Rlin : Module.End k U) pW = 0 :=
    aeval_Rlin_pW_of_residual_bot hbot
  -- L = AdjoinRoot pW acts on U via R
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
    -- aeval = eval₂ algebraMap
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
  have hU : Module.finrank k U = 6 :=
    V14Formalization.GeometricFanoCarrier.finrank_U
  have : 4 * Module.finrank L U = 6 := by
    calc 4 * Module.finrank L U
        = Module.finrank k L * Module.finrank L U := by rw [hL]
      _ = Module.finrank k U := hmul
      _ = 6 := hU
  omega

#print axioms residualKer_ne_bot
#print axioms aeval_Rlin_pW_of_residual_bot
