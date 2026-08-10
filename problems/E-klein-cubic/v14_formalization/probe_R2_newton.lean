import V14Formalization.GeometricV14Carrier
import Mathlib.LinearAlgebra.Trace
import Mathlib.LinearAlgebra.Matrix.Trace
import Mathlib.LinearAlgebra.Charpoly.Basic
import Mathlib.LinearAlgebra.Charpoly.ToMatrix
import Mathlib.LinearAlgebra.Matrix.Charpoly.Coeff
import Mathlib.LinearAlgebra.FiniteDimensional.Lemmas
import Mathlib.LinearAlgebra.FreeModule.Finite.Basic
import Mathlib.LinearAlgebra.Projection
import Mathlib.LinearAlgebra.ExteriorPower.Basic

open Module LinearMap Matrix Polynomial exteriorPower
open V14Formalization.GeometricV14Carrier
open V14Formalization.CentralizerN
open V14Formalization

set_option maxHeartbeats 32000000
noncomputable section

/-!
## tr(R²) = 0 and χ_Λ²(rotGen) = 0 via Newton

On residual: R² = −id ⇒ tr = −2.
On Wker: companion of R gives R² matrix with tr = 2
(or: S = R² satisfies S² − S + I = 0, charpoly (X²−X+1)², tr = 2).
Total tr(R²) = 0. With tr(R) = 0: Newton ⇒ χ_Λ²(R) = 0.
-/

/-- tr(R² on residual) = −2. -/
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
theorem ambientAct_rotGen_eq_map_Rlin :
    ambientAct (rotGen : GeometricV14Carrier.PSL2F11) = exteriorPower.map 2 Rlin := by
  dsimp [ambientAct, Rlin, rotGen]
  -- ambientAct (mk rot) = pslLambda2Hom (mk (mkRot rotPt)) = weilLambda2 (mkRot) = map 2 (weilU)
  change GeometricFanoCarrier.pslLambda2Hom
      (QuotientGroup.mk (mkRot rotPt)) =
    exteriorPower.map 2 (WeilHom.weilUHom (mkRot rotPt))
  rw [GeometricFanoCarrier.pslLambda2_mk]
  rfl

/-- χ_Λ²(rotGen) = 0 by Newton. -/
theorem chiLambda2_rotGen :
    chiLambda2 (rotGen : GeometricV14Carrier.PSL2F11) = 0 := by
  dsimp [chiLambda2]
  rw [ambientAct_rotGen_eq_map_Rlin]
  have h := trace_exterior_newton (V := U) Rlin
  change LinearMap.trace k (⋀[k]^2 U) (exteriorPower.map 2 Rlin) = 0
  rw [h, Rlin_trace, Rlin_sq_trace]
  norm_num

#print axioms Rrestrict_residual_sq_trace
#print axioms Rrestrict_Wker_sq_trace
#print axioms Rlin_sq_trace
#print axioms ambientAct_rotGen_eq_map_Rlin
#print axioms chiLambda2_rotGen
