import V14Formalization.GeometricV14Carrier
import Mathlib.LinearAlgebra.Trace
import Mathlib.LinearAlgebra.Matrix.Trace
import Mathlib.LinearAlgebra.FiniteDimensional.Lemmas
import Mathlib.LinearAlgebra.FreeModule.Finite.Basic
import Mathlib.LinearAlgebra.Projection
import Mathlib.LinearAlgebra.ExteriorPower.Basic

open Module LinearMap Matrix Polynomial exteriorPower
open V14Formalization.GeometricV14Carrier
open V14Formalization

set_option maxHeartbeats 32000000
noncomputable section

/-! ## tr(R⁴)=0, χ_Λ²(rotGen²)=0 -/

/-- tr(R⁴ on residual) = 2 (R⁴ = id). -/
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

#print axioms Rrestrict_residual_pow4_trace
#print axioms Rrestrict_Wker_pow4_trace
#print axioms Rlin_pow4_trace
#print axioms ambientAct_rotGen_pow_two_eq_map_R2
#print axioms chiLambda2_rotGen_pow_two
#print axioms orderOf_rotGen_pow_two
