import V14Formalization.GeometricV14Carrier
import Mathlib.LinearAlgebra.Trace
import Mathlib.LinearAlgebra.Matrix.Trace
import Mathlib.LinearAlgebra.Charpoly.Basic
import Mathlib.LinearAlgebra.Charpoly.ToMatrix
import Mathlib.LinearAlgebra.Matrix.Charpoly.Coeff
import Mathlib.LinearAlgebra.Matrix.Charpoly.Minpoly
import Mathlib.LinearAlgebra.FiniteDimensional.Lemmas
import Mathlib.LinearAlgebra.FreeModule.Finite.Basic
import Mathlib.LinearAlgebra.Dimension.Constructions
import Mathlib.LinearAlgebra.Projection
import Mathlib.Data.Matrix.Basic
import Mathlib.FieldTheory.Minpoly.Field
import Mathlib.Algebra.GroupWithZero.Associated

open Module LinearMap Matrix Polynomial
open V14Formalization.GeometricV14Carrier

set_option maxHeartbeats 32000000
noncomputable section

/-!
## tr(R|_residual) = 0 via 2×2 matrix Cayley–Hamilton

On residualKer: R² + id = 0. Matrix A of R satisfies A² + I = 0.
Charpoly = X² − tr·X + det, CH ⇒ A² − tr·A + det·I = 0.
⇒ tr·A = (det−1)·I. If tr ≠ 0 then A is scalar ⇒ eigenvalue of R
⇒ √−1 ∈ k, contradiction. Hence tr = 0.
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

theorem Rrestrict_residual_trace :
    let hR : ∀ x ∈ residualKer, Rlin x ∈ residualKer := fun _ hx => residualKer_R_stable hx
    LinearMap.trace k residualKer (Rrestrict residualKer hR) = 0 := by
  classical
  haveI : Module.Finite k residualKer := inferInstance
  haveI : Module.Free k residualKer := Module.Free.of_divisionRing k residualKer
  let hR : ∀ x ∈ residualKer, Rlin x ∈ residualKer := fun _ hx => residualKer_R_stable hx
  let RW := Rrestrict residualKer hR
  have hdim : Module.finrank k residualKer = 2 := finrank_residualKer_eq_two
  have hcard : Fintype.card (Module.Free.ChooseBasisIndex k residualKer) = 2 := by
    rw [← Module.finrank_eq_card_chooseBasisIndex k residualKer, hdim]
  let eIdx : Module.Free.ChooseBasisIndex k residualKer ≃ Fin 2 :=
    Fintype.equivFinOfCardEq hcard
  let b : Basis (Fin 2) k residualKer :=
    (Module.Free.chooseBasis k residualKer).reindex eIdx
  let A : Matrix (Fin 2) (Fin 2) k := LinearMap.toMatrix b b RW
  have htr : LinearMap.trace k residualKer RW = A.trace :=
    LinearMap.trace_eq_matrix_trace k b RW
  -- A² + I = 0
  have hA2 : A * A + 1 = 0 := by
    have h0map : LinearMap.toMatrix b b (0 : residualKer →ₗ[k] residualKer) = 0 :=
      map_zero _
    have hsum : LinearMap.toMatrix b b (RW ∘ₗ RW + LinearMap.id) =
        LinearMap.toMatrix b b (RW ∘ₗ RW) + LinearMap.toMatrix b b LinearMap.id :=
      map_add (LinearMap.toMatrix b b) _ _
    have hR2 : RW ∘ₗ RW + LinearMap.id = 0 := Rrestrict_residual_sq_add_id hR
    have hcomp : LinearMap.toMatrix b b (RW ∘ₗ RW) = A * A :=
      LinearMap.toMatrix_comp b b b RW RW
    have hid : LinearMap.toMatrix b b (LinearMap.id : residualKer →ₗ[k] residualKer) =
        (1 : Matrix (Fin 2) (Fin 2) k) :=
      LinearMap.toMatrix_id b
    calc A * A + 1
        = LinearMap.toMatrix b b (RW ∘ₗ RW) +
            LinearMap.toMatrix b b LinearMap.id := by rw [← hcomp, ← hid]
      _ = LinearMap.toMatrix b b (RW ∘ₗ RW + LinearMap.id) := hsum.symm
      _ = LinearMap.toMatrix b b 0 := by rw [hR2]
      _ = 0 := h0map
  have hA2' : A * A = -1 := eq_neg_of_add_eq_zero_left hA2
  -- Cayley–Hamilton: A² − tr•A + det•I = 0
  have hCH : A * A - A.trace • A + A.det • (1 : Matrix (Fin 2) (Fin 2) k) = 0 := by
    have h0 : aeval A A.charpoly = 0 := Matrix.aeval_self_charpoly A
    have hcp : A.charpoly = X ^ 2 - C A.trace * X + C A.det := Matrix.charpoly_fin_two A
    rw [hcp] at h0
    -- aeval expands to A^2 - (tr • 1) * A + det • 1
    have h0' : A ^ 2 - (A.trace • (1 : Matrix (Fin 2) (Fin 2) k)) * A +
        A.det • (1 : Matrix (Fin 2) (Fin 2) k) = 0 := by
      simpa [map_add, map_sub, map_mul, map_pow, aeval_X, aeval_C,
        Algebra.algebraMap_eq_smul_one] using h0
    -- rewrite (tr•1)*A = tr•A and A^2 = A*A
    rw [smul_one_mul_matrix, sq] at h0'
    exact h0'
  -- tr • A = (det − 1) • I
  have hsc : A.trace • A = (A.det - 1) • (1 : Matrix (Fin 2) (Fin 2) k) := by
    -- CH with A² = -I: -I - tr•A + det•I = 0
    have h1 : -(1 : Matrix (Fin 2) (Fin 2) k) - A.trace • A + A.det • 1 = 0 := by
      have h := hCH
      rwa [hA2'] at h
    -- From h1: tr•A = -1 + det•1  (add 1 + tr•A to both sides of h1 = 0)
    have hsum : A.trace • A =
        -(1 : Matrix (Fin 2) (Fin 2) k) + A.det • 1 := by
      have h1' : (A.trace • A) + (-(1 : Matrix (Fin 2) (Fin 2) k) - A.trace • A + A.det • 1) =
          -(1) + A.det • 1 := by abel
      rwa [h1, add_zero] at h1'
    -- -1 + det•1 = (det - 1)•1
    convert hsum using 1
    ext i j
    simp only [Matrix.add_apply, Matrix.neg_apply, Matrix.smul_apply, Matrix.one_apply,
      sub_smul, one_smul]
    ring
  -- tr = 0
  change LinearMap.trace k residualKer RW = 0
  rw [htr]
  by_cases ht : A.trace = 0
  · exact ht
  · let c : k := (A.det - 1) * A.trace⁻¹
    have hAscal : A = c • (1 : Matrix (Fin 2) (Fin 2) k) := by
      have hA : A = A.trace⁻¹ • (A.trace • A) := by
        rw [smul_smul, inv_mul_cancel₀ ht, one_smul]
      rw [hA, hsc, smul_smul]
      -- A.trace⁻¹ * (A.det - 1) = (A.det - 1) * A.trace⁻¹
      simp only [c, mul_comm]
    have hRWscal : RW = c • LinearMap.id := by
      apply (LinearMap.toMatrix b b).injective
      calc LinearMap.toMatrix b b RW = A := rfl
        _ = c • (1 : Matrix (Fin 2) (Fin 2) k) := hAscal
        _ = c • LinearMap.toMatrix b b (LinearMap.id : residualKer →ₗ[k] residualKer) := by
            rw [LinearMap.toMatrix_id]
        _ = LinearMap.toMatrix b b (c • LinearMap.id) :=
            (map_smul (LinearMap.toMatrix b b) c LinearMap.id).symm
    have hx0 : b 0 ≠ 0 := b.ne_zero 0
    have heig : RW (b 0) = c • b 0 := by
      rw [hRWscal, LinearMap.smul_apply, LinearMap.id_apply]
    exact False.elim (Rrestrict_residual_no_eigen hR hx0 heig)

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

#print axioms Rrestrict_residual_sq_add_id
#print axioms Rrestrict_residual_no_eigen
#print axioms smul_one_mul_matrix
#print axioms Rrestrict_residual_trace
#print axioms Rrestrict_Wker_trace
#print axioms Rlin_eq_conj_prodMap
#print axioms Rlin_trace
