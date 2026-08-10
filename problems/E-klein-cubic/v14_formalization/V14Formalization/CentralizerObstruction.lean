/-
Copyright (c) 2026 V14Formalization contributors.
Released under Apache 2.0 license.

# Theorem 3.1 — Centralizer obstruction (zero axioms, full proof)
-/
import V14Formalization.Foundations

noncomputable section

namespace V14Formalization

universe u

/-! ## Centerless ⇒ non-degeneracy (fully proved) -/

theorem eq_one_of_act_id {k : Type u} [Field k] {G : Type u} [Group G]
    {V : Type u} [AddCommGroup V] [Module k V]
    (R : FaithfulLinearRep k G V) {σ : G}
    (h : R.act σ = LinearMap.id) : σ = 1 := by
  apply R.faithful
  calc R.ρ σ = R.act σ := rfl
    _ = LinearMap.id := h
    _ = R.ρ 1 := (map_one R.ρ).symm

lemma conj_neg_id {k : Type u} [Field k]
    {V : Type u} [AddCommGroup V] [Module k V]
    (f f' : V →ₗ[k] V) (hinv : ∀ v, f (f' v) = v) :
    f ∘ₗ (-LinearMap.id : V →ₗ[k] V) ∘ₗ f' = -LinearMap.id := by
  ext v
  simp only [LinearMap.comp_apply, LinearMap.neg_apply, LinearMap.id_coe, id_eq]
  calc f (- f' v) = - f (f' v) := by rw [map_neg]
    _ = -v := by rw [hinv v]

theorem not_act_neg_id_of_centerless {k : Type u} [Field k] [CharZero k]
    {G : Type u} [Group G]
    {V : Type u} [AddCommGroup V] [Module k V]
    (R : FaithfulLinearRep k G V) {σ : G}
    (hG : IsCenterless G) (hσ : IsInvolution σ)
    (h : R.act σ = -LinearMap.id) : False := by
  have hcentral : σ ∈ Subgroup.center G := by
    rw [mem_center_iff]
    intro g
    have h1 : R.act (g * σ * g⁻¹) =
        R.act g ∘ₗ R.act σ ∘ₗ R.act g⁻¹ := by
      calc R.act (g * σ * g⁻¹)
          = R.act ((g * σ) * g⁻¹) := by simp [mul_assoc]
        _ = R.act (g * σ) ∘ₗ R.act g⁻¹ := R.act_mul (g * σ) g⁻¹
        _ = (R.act g ∘ₗ R.act σ) ∘ₗ R.act g⁻¹ := by rw [R.act_mul g σ]
        _ = R.act g ∘ₗ R.act σ ∘ₗ R.act g⁻¹ := by simp [LinearMap.comp_assoc]
    have hconj : R.act (g * σ * g⁻¹) = R.act σ := by
      rw [h1, h]
      exact conj_neg_id (R.act g) (R.act g⁻¹) (R.act_inv g)
    have heq : g * σ * g⁻¹ = σ := R.faithful hconj
    calc g * σ = (g * σ * g⁻¹) * g := by simp [mul_assoc]
      _ = σ * g := by rw [heq]
  have hσ1 : σ = 1 := by
    have : σ ∈ (⊥ : Subgroup G) := by rwa [hG] at hcentral
    exact Subgroup.mem_bot.mp this
  exact hσ.2 hσ1

theorem noDegenerates_of_centerless_involution
    (k : Type u) [Field k] [CharZero k] (G : Type u) [Group G]
    (hG : IsCenterless G) (σ : G) (hσ : IsInvolution σ) :
    NoFaithfulRepDegenerates k G σ := by
  intro V _ _ R hdeg
  cases hdeg with
  | inl hid => exact hσ.2 (eq_one_of_act_id R hid)
  | inr hneg => exact not_act_neg_id_of_centerless R hG hσ hneg

theorem not_degenerates_of_centerless
    {k : Type u} [Field k] [CharZero k] {G : Type u} [Group G]
    (hG : IsCenterless G) {σ : G} (hσ : IsInvolution σ)
    {V : Type u} [AddCommGroup V] [Module k V]
    (R : FaithfulLinearRep k G V) :
    ¬ R.DegeneratesToPlusMinusId σ :=
  noDegenerates_of_centerless_involution k G hG σ hσ V R

/-! ## Theorem 3.1 -/

/-- **Theorem 3.1 (Centralizer obstruction)** — per-representation form.

Under hyp (a)(b), centerless G, involution σ: no G-equivariant (resolved)
rational map `ℙ(V) → Y` from any faithful linear representation `V`. -/
theorem centralizerObstruction_one_rep
    {k : Type u} [Field k] [CharZero k] {G : Type u} [Group G]
    (Y : SmoothProjectiveGVariety k G)
    (σ : G) (hσ : IsInvolution σ)
    (hG : IsCenterless G)
    (ha : HypothesisA k Y σ)
    (hb : HypothesisB Y (centralizer σ))
    {V : Type u} [AddCommGroup V] [Module k V] [Module.Free k V]
    (R : FaithfulLinearRep k G V) :
    ¬ ReceivesFromRep Y hG R := by
  intro ⟨f⟩
  have hnd : ¬ R.DegeneratesToPlusMinusId σ :=
    not_degenerates_of_centerless hG hσ R
  let F : TrackedStratum (R.projectivizationVariety hG) σ :=
    TrackedStratum.ofPlusStratum R σ hG hσ hnd
  obtain ⟨y, _hyσ, hyN⟩ := morphism_from_tracked_forces_N_fixed f F ha
  have : y ∈ (∅ : Set Y.X) := by
    rw [← hb]
    exact hyN
  exact this

/-- **Theorem 3.1** — universal form over all faithful linear representations. -/
theorem centralizerObstruction
    {k : Type u} [Field k] [CharZero k] {G : Type u} [Group G]
    (Y : SmoothProjectiveGVariety k G)
    (σ : G) (hσ : IsInvolution σ)
    (hG : IsCenterless G)
    (ha : HypothesisA k Y σ)
    (hb : HypothesisB Y (centralizer σ)) :
    ∀ (V : Type u) [AddCommGroup V] [Module k V] [Module.Free k V]
      (R : FaithfulLinearRep k G V),
      ¬ ReceivesFromRep Y hG R :=
  fun _V _ _ _ R => centralizerObstruction_one_rep Y σ hσ hG ha hb R

theorem notWeaklyVersal_of_centralizerObstruction
    {k : Type u} [Field k] [CharZero k] {G : Type u} [Group G]
    (Y : SmoothProjectiveGVariety k G)
    (σ : G) (hσ : IsInvolution σ)
    (hG : IsCenterless G)
    (ha : HypothesisA k Y σ)
    (hb : HypothesisB Y (centralizer σ))
    {V : Type u} [AddCommGroup V] [Module k V] [Module.Free k V]
    (R₀ : FaithfulLinearRep k G V) :
    NotWeaklyVersal Y hG :=
  ⟨V, inferInstance, inferInstance, inferInstance, R₀,
    centralizerObstruction Y σ hσ hG ha hb V R₀⟩

theorem not_GUnirational_of_centralizerObstruction
    {k : Type u} [Field k] [CharZero k] {G : Type u} [Group G]
    (Y : SmoothProjectiveGVariety k G)
    (σ : G) (hσ : IsInvolution σ)
    (hG : IsCenterless G)
    (ha : HypothesisA k Y σ)
    (hb : HypothesisB Y (centralizer σ)) :
    ¬ IsGUnirational Y hG :=
  not_GUnirational_of_forall_no_map (centralizerObstruction Y σ hσ hG ha hb)

end V14Formalization
