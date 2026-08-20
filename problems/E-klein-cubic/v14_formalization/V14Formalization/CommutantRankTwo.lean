/-
Copyright (c) 2026 V14Formalization contributors.
Released under Apache 2.0 license.
-/
module

public import Mathlib.RepresentationTheory.Character
public import Mathlib.RepresentationTheory.Maschke
public import Mathlib.RepresentationTheory.Semisimple
public import Mathlib.LinearAlgebra.Projection

/-!
# A rank-two commutant pins every subrepresentation

Let `ρ` be a finite-dimensional representation of a finite group `G` over a
field `k` whose order is invertible in `k`.  Suppose

* the algebra `A = End_G(V)` of self-intertwiners is two-dimensional, and
* `A` contains an idempotent `p` other than `0` and `1`.

Then `1` and `p` are a basis of `A`, the only idempotents of `A` are
`0, 1, p, 1 - p`, and — because Maschke makes every `G`-stable subspace the
range of an idempotent of `A` — the only `G`-stable subspaces of `V` are

  `0`,  `range p`,  `range (1 - p)`,  `V`,

of dimensions `0`, `tr p`, `finrank V - tr p`, `finrank V`.  So a `G`-stable
subspace is *determined by its dimension* as soon as those four numbers are
pairwise distinct in `k`.

This is the abstract content of "`M` is the unique 10-dimensional
`PSL(2,11)`-subrepresentation of `Λ²U`": there `finrank V = 15` and `tr p = 10`,
and `0, 10, 5, 15` are pairwise distinct.

Nothing here mentions the projector's *construction*; only its trace.  That
matters downstream, where the projector is a sum over all 660 group elements
and must never be unfolded.
-/

set_option linter.unusedSectionVars false

noncomputable section

namespace V14Formalization
namespace CommutantRankTwo

open Module Representation

/-! ## Idempotents in a two-dimensional algebra -/

section Algebra

variable {k A : Type*} [Field k] [Ring A] [Algebra k A] [Nontrivial A] {p : A}

/-- A nontrivial idempotent of a `k`-algebra is not a scalar. -/
public theorem ne_algebraMap_of_isIdem (hp : IsIdempotentElem p) (hp0 : p ≠ 0)
    (hp1 : p ≠ 1) (c : k) : p ≠ algebraMap k A c := by
  intro hc
  have hsq : algebraMap k A (c * c) = algebraMap k A c := by
    rw [map_mul, ← hc]; exact hp
  have hcc : IsIdempotentElem c := (algebraMap k A).injective hsq
  rcases IsIdempotentElem.iff_eq_zero_or_one.mp hcc with h | h
  · exact hp0 (by rw [hc, h, map_zero])
  · exact hp1 (by rw [hc, h, map_one])

/-- `1` and a nontrivial idempotent are linearly independent over `k`. -/
public theorem linearIndependent_one_isIdem (hp : IsIdempotentElem p) (hp0 : p ≠ 0)
    (hp1 : p ≠ 1) : LinearIndependent k ![(1 : A), p] := by
  rw [LinearIndependent.pair_iff]
  intro s t hst
  by_cases ht : t = 0
  · subst ht
    refine ⟨?_, rfl⟩
    have h : s • (1 : A) = 0 := by simpa using hst
    rw [smul_eq_zero] at h
    exact h.resolve_right one_ne_zero
  · exfalso
    have h1 : t • p = -(s • (1 : A)) := by
      rw [eq_neg_iff_add_eq_zero, add_comm]; exact hst
    have h2 : p = (-(t⁻¹ * s)) • (1 : A) := by
      have h3 := congrArg (fun z => t⁻¹ • z) h1
      simp only [smul_smul, inv_mul_cancel₀ ht, one_smul, smul_neg] at h3
      rw [neg_smul]; exact h3
    exact ne_algebraMap_of_isIdem hp hp0 hp1 (-(t⁻¹ * s))
      (by rw [h2, Algebra.algebraMap_eq_smul_one])

variable [FiniteDimensional k A]

/-- With `finrank A = 2`, the pair `1, p` spans. -/
public theorem exists_smul_add_smul (hdim : finrank k A = 2)
    (hp : IsIdempotentElem p) (hp0 : p ≠ 0) (hp1 : p ≠ 1) (e : A) :
    ∃ a b : k, a • (1 : A) + b • p = e := by
  have hli := linearIndependent_one_isIdem (k := k) hp hp0 hp1
  have hrange : Set.range ![(1 : A), p] = {(1 : A), p} := by
    ext x; simp [Fin.exists_fin_two]; tauto
  have hspan : Submodule.span k ({(1 : A), p} : Set A) = ⊤ := by
    refine Submodule.eq_top_of_finrank_eq ?_
    rw [← hrange, finrank_span_eq_card hli, hdim]
    simp
  have hmem : e ∈ Submodule.span k ({(1 : A), p} : Set A) := by rw [hspan]; trivial
  exact Submodule.mem_span_pair.mp hmem

/-- The idempotents of a two-dimensional algebra containing a nontrivial
idempotent `p` are exactly `0`, `1`, `p` and `1 - p`. -/
public theorem isIdem_cases (hdim : finrank k A = 2)
    (hp : IsIdempotentElem p) (hp0 : p ≠ 0) (hp1 : p ≠ 1) {e : A}
    (he : IsIdempotentElem e) :
    e = 0 ∨ e = 1 ∨ e = p ∨ e = 1 - p := by
  obtain ⟨a, b, rfl⟩ := exists_smul_add_smul hdim hp hp0 hp1 e
  have hli := linearIndependent_one_isIdem (k := k) hp hp0 hp1
  rw [LinearIndependent.pair_iff] at hli
  have hsq : (a • (1 : A) + b • p) * (a • (1 : A) + b • p)
      = (a * a) • (1 : A) + (a * b + b * a + b * b) • p := by
    have hpp : p * p = p := hp
    simp only [add_mul, mul_add, smul_mul_smul_comm, mul_one, one_mul, hpp, add_smul]
    abel
  have he' : (a • (1 : A) + b • p) * (a • (1 : A) + b • p) = a • (1 : A) + b • p := he
  rw [hsq] at he'
  have hzero : (a * a - a) • (1 : A) + (a * b + b * a + b * b - b) • p = 0 := by
    rw [sub_smul, sub_smul,
      show (a * a) • (1 : A) - a • (1 : A) + ((a * b + b * a + b * b) • p - b • p)
        = ((a * a) • (1 : A) + (a * b + b * a + b * b) • p)
          - (a • (1 : A) + b • p) by abel, he', sub_self]
  obtain ⟨h1, h2⟩ := hli _ _ hzero
  have ha : IsIdempotentElem a := sub_eq_zero.mp h1
  have hb : a * b + b * a + b * b = b := sub_eq_zero.mp h2
  rcases IsIdempotentElem.iff_eq_zero_or_one.mp ha with rfl | rfl
  · have hb' : IsIdempotentElem b := by
      show b * b = b; linear_combination hb
    rcases IsIdempotentElem.iff_eq_zero_or_one.mp hb' with rfl | rfl
    · left; module
    · right; right; left; module
  · have hb' : b * (b + 1) = 0 := by linear_combination hb
    rcases mul_eq_zero.mp hb' with rfl | hb1
    · right; left; module
    · have hbneg : b = -1 := by linear_combination hb1
      subst hbneg
      right; right; right; module

end Algebra

/-! ## Maschke: every stable subspace is the range of an idempotent intertwiner -/

section Rep

variable {k G V : Type*} [Field k] [Group G] [Finite G] [NeZero (Nat.card G : k)]
  [AddCommGroup V] [Module k V] [FiniteDimensional k V] {ρ : Representation k G V}

/-- Mathlib gives `Representation.IntertwiningMap ρ ρ` a `Semiring` and an
`AddCommGroup` but no `Ring`; the two agree on the additive structure, so this
just assembles them. -/
public instance instRingIntertwiningMap : Ring (ρ.IntertwiningMap ρ) :=
  { (inferInstance : Semiring (ρ.IntertwiningMap ρ)),
    (inferInstance : AddCommGroup (ρ.IntertwiningMap ρ)) with }

open LinearMap in
/-- **Maschke, in projector form.**  Every subrepresentation is the range of an
idempotent self-intertwiner. -/
public theorem exists_isIdem_range (N : Subrepresentation ρ) :
    ∃ e : ρ.IntertwiningMap ρ, IsIdempotentElem e ∧
      LinearMap.range e.toLinearMap = N.toSubmodule := by
  obtain ⟨N', hcompl⟩ := exists_isCompl N
  have hbot : (⊥ : Subrepresentation ρ).toSubmodule = ⊥ := rfl
  have htop : (⊤ : Subrepresentation ρ).toSubmodule = ⊤ := rfl
  have hsub : IsCompl N.toSubmodule N'.toSubmodule := by
    constructor
    · rw [disjoint_iff, ← Subrepresentation.toSubmodule_inf, ← hbot]
      exact congrArg Subrepresentation.toSubmodule (disjoint_iff.mp hcompl.disjoint)
    · rw [codisjoint_iff, ← Subrepresentation.toSubmodule_sup, ← htop]
      exact congrArg Subrepresentation.toSubmodule (codisjoint_iff.mp hcompl.codisjoint)
  set e₀ : V →ₗ[k] V := N.toSubmodule.projection N'.toSubmodule hsub with he₀
  have hmem : ∀ x : V, e₀ x ∈ N.toSubmodule := fun x => (N.toSubmodule.projectionOnto _ hsub x).2
  have hleft : ∀ x ∈ N.toSubmodule, e₀ x = x := by
    intro x hx
    rw [he₀, Submodule.projection, LinearMap.comp_apply,
      Submodule.projectionOnto_apply_of_mem_left hsub hx]
    rfl
  have hright : ∀ x ∈ N'.toSubmodule, e₀ x = 0 := by
    intro x hx
    rw [he₀, Submodule.projection, LinearMap.comp_apply,
      Submodule.projectionOnto_apply_of_mem_right hsub hx]
    rfl
  have hequiv : ∀ (g : G) (v : V), e₀ (ρ g v) = ρ g (e₀ v) := by
    intro g v
    have hv : v ∈ N.toSubmodule ⊔ N'.toSubmodule := by rw [hsub.sup_eq_top]; trivial
    obtain ⟨n, hn, n', hn', rfl⟩ := Submodule.mem_sup.mp hv
    rw [map_add, map_add, map_add, map_add,
      hleft _ (N.apply_mem_toSubmodule g hn), hright _ (N'.apply_mem_toSubmodule g hn'),
      hleft _ hn, hright _ hn', map_zero, add_zero]
  refine ⟨LinearMap.intertwiningMap_of_isIntertwiningMap ρ ρ e₀ hequiv, ?_, ?_⟩
  · refine Representation.IntertwiningMap.ext (LinearMap.ext fun v => ?_)
    show e₀ (e₀ v) = e₀ v
    exact hleft _ (hmem v)
  · refine le_antisymm ?_ ?_
    · rintro x ⟨v, rfl⟩; exact hmem v
    · intro x hx; exact ⟨x, hleft x hx⟩

/-! ## The four stable subspaces -/

open LinearMap in
/-- Trace picks out the range of the idempotent.

If the commutant of `ρ` is two-dimensional and `p` is an idempotent
self-intertwiner other than `0` and `1`, then a subrepresentation whose
dimension equals `tr p` is exactly `range p` — provided `tr p` is none of the
other three available traces `0`, `finrank V`, `finrank V - tr p`. -/
public theorem toSubmodule_eq_range
    (hdim2 : Module.finrank k (ρ.IntertwiningMap ρ) = 2)
    {p : ρ.IntertwiningMap ρ} (hp : IsIdempotentElem p) (hp0 : p ≠ 0) (hp1 : p ≠ 1)
    (htp0 : LinearMap.trace k V p.toLinearMap ≠ 0)
    (htpV : LinearMap.trace k V p.toLinearMap ≠ (Module.finrank k V : k))
    (htpc : LinearMap.trace k V p.toLinearMap
      ≠ (Module.finrank k V : k) - LinearMap.trace k V p.toLinearMap)
    (N : Subrepresentation ρ)
    (hdimN : (Module.finrank k N.toSubmodule : k) = LinearMap.trace k V p.toLinearMap) :
    N.toSubmodule = LinearMap.range p.toLinearMap := by
  haveI : Nontrivial (ρ.IntertwiningMap ρ) := by
    rcases subsingleton_or_nontrivial (ρ.IntertwiningMap ρ) with h | _
    · exact absurd (Subsingleton.elim p 1) hp1
    · assumption
  obtain ⟨e, he, hre⟩ := exists_isIdem_range N
  -- the dimension of `N` is the trace of `e`
  have hIsProj : IsProj (LinearMap.range e.toLinearMap) e.toLinearMap := by
    refine (LinearMap.isProj_range_iff_isIdempotentElem e.toLinearMap).mpr ?_
    exact congrArg Representation.IntertwiningMap.toLinearMap he
  have htrE : LinearMap.trace k V e.toLinearMap = (Module.finrank k N.toSubmodule : k) := by
    rw [hIsProj.trace, hre]
  have h0 : (0 : ρ.IntertwiningMap ρ).toLinearMap = 0 := rfl
  have h1 : (1 : ρ.IntertwiningMap ρ).toLinearMap = LinearMap.id := rfl
  have hchain : LinearMap.trace k V p.toLinearMap = LinearMap.trace k V e.toLinearMap :=
    hdimN.symm.trans htrE.symm
  rcases isIdem_cases (k := k) hdim2 hp hp0 hp1 he with h | h | h | h
  · exact absurd (by rw [hchain, h, h0, map_zero]) htp0
  · exact absurd (by rw [hchain, h, h1, LinearMap.trace_id]) htpV
  · rw [← hre, h]
  · refine absurd ?_ htpc
    conv_lhs => rw [hchain]
    rw [h, Representation.IntertwiningMap.sub_toLinearMap, map_sub, h1, LinearMap.trace_id]

end Rep

end CommutantRankTwo
end V14Formalization

