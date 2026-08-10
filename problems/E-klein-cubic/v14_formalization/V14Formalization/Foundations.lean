/-
Copyright (c) 2026 V14Formalization contributors.
Released under Apache 2.0 license.

# Foundations for Theorem 3.1 — linear-projective RCC, zero axioms
-/
import V14Formalization.Definitions

noncomputable section

open scoped LinearAlgebra.Projectivization

namespace V14Formalization

universe u

/-! ## Tracked stratum (writeup Claim) -/

/-- N-stable, σ-fixed, linear-RCC, nonempty closed carrier (operational). -/
structure TrackedStratum {k : Type u} [Field k] {G : Type u} [Group G]
    (X : SmoothProjectiveGVariety k G) (σ : G) where
  carrier : Set X.X
  nonempty : carrier.Nonempty
  fixed : carrier ⊆ X.fixedByElement σ
  rcc : IsRCC k X carrier
  N_stable : ∀ (n : centralizer σ) {x}, x ∈ carrier → (n : G) • x ∈ carrier

namespace TrackedStratum

variable {k : Type u} [Field k] {G : Type u} [Group G]

/-- Plus stratum of a faithful linear rep is a tracked stratum. -/
def ofPlusStratum {V : Type u} [AddCommGroup V] [Module k V] [Module.Free k V]
    [CharZero k]
    (R : FaithfulLinearRep k G V) (σ : G) (hG : IsCenterless G)
    (hσ : IsInvolution σ) (hnd : ¬ R.DegeneratesToPlusMinusId σ) :
    TrackedStratum (R.projectivizationVariety hG) σ where
  carrier := R.plusProjectiveStratum σ
  nonempty := R.plusProjectiveStratum_nonempty (σ := σ) hσ hnd
  fixed := R.plusProjectiveStratum_fixed (σ := σ) hG
  rcc := R.plusProjectiveStratum_rcc (σ := σ) hG hσ hnd
  N_stable := fun n x hx => by
    change R.projectiveSMul (n : G) x ∈ R.plusProjectiveStratum σ
    exact R.plusProjectiveStratum_N_stable (σ := σ) n hx

end TrackedStratum

/-! ## Linear-projective image preserves linear RCC -/

theorem isRCC_image_linear {k : Type u} [Field k] {G : Type u} [Group G]
    {X Y : SmoothProjectiveGVariety k G}
    {S : Set X.X} (h : IsRCC k X S) (f : GEquivariantMorphism X Y) :
    IsRCC k Y (f.imageSet S) := by
  unfold IsRCC IsLinearRCC at h ⊢
  obtain ⟨W, hdim, hS⟩ := h
  let W' : Submodule k Y.ambient := Submodule.map f.lin W
  refine ⟨W', ?_, ?_⟩
  · have heq : Module.finrank k W' = Module.finrank k W :=
      LinearEquiv.finrank_eq (Submodule.equivMapOfInjective f.lin f.lin_injective W).symm
    omega
  · -- Two inclusions for set equality
    apply Set.Subset.antisymm
    · -- embed_Y '' (f '' S) ⊆ {p | p.submodule ≤ W'}
      rintro p ⟨y, ⟨x, hxS, rfl⟩, rfl⟩
      have hxW : (X.embed x).submodule ≤ W := by
        have : X.embed x ∈ X.embed '' S := Set.mem_image_of_mem _ hxS
        rwa [hS] at this
      have hrep : (X.embed x).rep ∈ W := by
        have hsub := hxW
        rw [Projectivization.submodule_eq] at hsub
        exact hsub (Submodule.mem_span_singleton_self _)
      have heq := f.induces x
      change (Y.embed (f.toFun x)).submodule ≤ W'
      rw [heq, ← Projectivization.mk_rep (X.embed x), Projectivization.map_mk,
        Projectivization.submodule_mk]
      intro t ht
      rcases Submodule.mem_span_singleton.mp ht with ⟨a, rfl⟩
      exact ⟨a • (X.embed x).rep, W.smul_mem a hrep, by simp [LinearMap.map_smul]⟩
    · -- {p | p.submodule ≤ W'} ⊆ embed_Y '' (f '' S)
      intro p hp
      change p.submodule ≤ W' at hp
      have hrep : p.rep ∈ W' := by
        rw [Projectivization.submodule_eq] at hp
        exact hp (Submodule.mem_span_singleton_self _)
      rcases Submodule.mem_map.mp hrep with ⟨v, hvW, hfv⟩
      have hvne : v ≠ 0 := fun hv0 =>
        (Projectivization.rep_nonzero p) (by simpa [hv0] using hfv.symm)
      have hq : Projectivization.mk k v hvne ∈ X.embed '' S := by
        rw [hS]
        change (k ∙ v : Submodule k X.ambient) ≤ W
        exact (Submodule.span_singleton_le_iff_mem _ _).mpr hvW
      rcases hq with ⟨x, hxS, hqx⟩
      refine ⟨f.toFun x, ⟨x, hxS, rfl⟩, ?_⟩
      -- show Y.embed (f x) = p via matching submodules k∙(f.lin v) = k∙p.rep
      have h1 := f.induces x
      apply Projectivization.submodule_injective
      have hL : (Y.embed (f.toFun x)).submodule = k ∙ f.lin v := by
        rw [h1, hqx, Projectivization.map_mk, Projectivization.submodule_mk]
      have hR : p.submodule = k ∙ p.rep := Projectivization.submodule_eq p
      rw [hL, hR, hfv]

/-! ## Lemma 2.6 operational: image of tracked stratum under linear morphism

Under HypothesisA, the image of a tracked σ-stratum is a singleton in Y^σ.
-/

theorem image_of_trackedStratum_singleton
    {k : Type u} [Field k] {G : Type u} [Group G]
    {X Y : SmoothProjectiveGVariety k G} {σ : G}
    (f : GEquivariantMorphism X Y)
    (F : TrackedStratum X σ)
    (ha : HypothesisA k Y σ) :
    ∃ y : Y.X, y ∈ Y.fixedByElement σ ∧ f.imageSet F.carrier = {y} := by
  have himg_fixed : f.imageSet F.carrier ⊆ Y.fixedByElement σ := by
    intro y hy
    rcases hy with ⟨x, hx, rfl⟩
    have hxσ : x ∈ X.fixedByElement σ := F.fixed hx
    have : σ • x = x := hxσ
    change σ • f.toFun x = f.toFun x
    rw [← f.equivariant, this]
  have himg_rcc : IsRCC k Y (f.imageSet F.carrier) :=
    isRCC_image_linear F.rcc f
  obtain ⟨y, hy⟩ := ha (f.imageSet F.carrier) himg_fixed himg_rcc
  have hy_mem : y ∈ Y.fixedByElement σ := by
    have : y ∈ f.imageSet F.carrier := by
      rw [hy]; exact Set.mem_singleton y
    exact himg_fixed this
  exact ⟨y, hy_mem, hy⟩

/-! ## N-stability of the image point (proved) -/

theorem image_point_N_fixed
    {k : Type u} [Field k] {G : Type u} [Group G]
    {X Y : SmoothProjectiveGVariety k G} {σ : G}
    (f : GEquivariantMorphism X Y)
    (F : TrackedStratum X σ)
    {y : Y.X}
    (himg : f.imageSet F.carrier = {y}) :
    y ∈ Y.fixedBy (centralizer σ) := by
  intro n
  obtain ⟨x, hx⟩ := F.nonempty
  have hfx : f.toFun x = y := by
    have : f.toFun x ∈ f.imageSet F.carrier := Set.mem_image_of_mem _ hx
    rwa [himg, Set.mem_singleton_iff] at this
  have hnx : (n : G) • x ∈ F.carrier := F.N_stable n hx
  have hfnx : f.toFun ((n : G) • x) = (n : G) • y := by
    rw [f.equivariant, hfx]
  have hfnx_y : f.toFun ((n : G) • x) = y := by
    have : f.toFun ((n : G) • x) ∈ f.imageSet F.carrier :=
      Set.mem_image_of_mem _ hnx
    rwa [himg, Set.mem_singleton_iff] at this
  calc (n : G) • y = f.toFun ((n : G) • x) := hfnx.symm
    _ = y := hfnx_y

/-- Combined going-down for a morphism from a tracked stratum. -/
theorem morphism_from_tracked_forces_N_fixed
    {k : Type u} [Field k] {G : Type u} [Group G]
    {X Y : SmoothProjectiveGVariety k G} {σ : G}
    (f : GEquivariantMorphism X Y)
    (F : TrackedStratum X σ)
    (ha : HypothesisA k Y σ) :
    ∃ y : Y.X, y ∈ Y.fixedByElement σ ∧ y ∈ Y.fixedBy (centralizer σ) := by
  obtain ⟨y, hyσ, himg⟩ := image_of_trackedStratum_singleton f F ha
  exact ⟨y, hyσ, image_point_N_fixed f F himg⟩

end V14Formalization
