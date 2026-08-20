/-
Copyright (c) 2026 V14Formalization contributors.
Released under Apache 2.0 license.
-/
module

public import V14Formalization.CommutantRankTwo
public import V14Formalization.Ord11CharacterSum

/-!
# `M` is *the* ten-dimensional subrepresentation of `Λ²U`

`V₁₄ = Gr(2,U) ∩ ℙ(M)` looks like a choice of linear section.  It is not: `M`
is the only `10`-dimensional `PSL(2,11)`-stable subspace of the `15`-dimensional
`Λ²U`, so requiring the section to carry the group action pins it.

The proof is `CommutantRankTwo.toSubmodule_eq_range` at the ambient
representation.  Its one arithmetic input is the norm of the ambient character,

  `∑_{g ∈ PSL(2,11)} χ_{Λ²U}(g) · χ_{Λ²U}(g⁻¹) = 1320 = 2·660`,

which says the commutant of `Λ²U` is two-dimensional, i.e. that `Λ²U` splits
into exactly two non-isomorphic irreducible summands.  That sum is proved, in
`Ord11CharacterSum.sum_chiLambda2_norm_eq_thirteen_twenty`; class by class it
is `225 + 495 + 0 + 0 + 0 + 600`.

Each result therefore comes in two forms.  The `_of_sum_...` form takes the
sum as a hypothesis and is what the argument actually uses; `eq_Msub` and
`finrank_intertwiningMap` are the same statements with the hypothesis
discharged.

Everything below treats `projectorM` as opaque: only its equivariance, its
idempotence and its trace are used.  No equation ever forces the 660-term sum
to unfold.
-/

set_option linter.unusedSectionVars false
set_option maxRecDepth 8000

noncomputable section

namespace V14Formalization
namespace MsubUnique

open Module GeometricV14Carrier

/-! ## The ambient representation -/

/-- `Λ²U` as a Mathlib `Representation`.  `pslLambda2Hom` is already the
monoid hom `PSL(2,11) →* End(Λ²U)`, which is definitionally a
`Representation`. -/
public abbrev ambientRep : Representation k PSL2F11 Lambda2U :=
  GeometricFanoCarrier.pslLambda2Hom

public theorem ambientRep_apply (g : PSL2F11) : ambientRep g = ambientAct g := rfl

/-- The project's `chiLambda2` is Mathlib's character of `ambientRep`. -/
public theorem character_ambientRep (g : PSL2F11) :
    ambientRep.character g = chiLambda2 g := rfl

/-- `finrank Λ²U = 15`, restated publicly (`GeometricV14Carrier.finrank_Lambda2U`
is module-private). -/
public theorem finrank_ambient : Module.finrank k Lambda2U = 15 := by
  haveI : Module.Free k GeometricV14Carrier.U := inferInstance
  haveI : Module.Finite k GeometricV14Carrier.U := inferInstance
  rw [exteriorPower.finrank_eq (R := k) (M := GeometricV14Carrier.U) (n := 2),
    GeometricFanoCarrier.finrank_U]
  decide

/-! ## `π` as a self-intertwiner -/

/-- `π` commutes with the ambient action, as an equation of linear maps.
Proved pointwise; the projector's 660-term body is never unfolded. -/
public theorem projectorM_comp_ambientRep (g : PSL2F11) :
    projectorM ∘ₗ (ambientRep g) = (ambientRep g) ∘ₗ projectorM := by
  refine LinearMap.ext fun v => ?_
  rw [LinearMap.comp_apply, LinearMap.comp_apply, ambientRep_apply]
  exact projectorM_equivariant g v

/-- The isotypic projector `π`, packaged as a self-intertwiner of `Λ²U`. -/
@[expose] public def projM : ambientRep.IntertwiningMap ambientRep :=
  { toLinearMap := projectorM, isIntertwining' := projectorM_comp_ambientRep }

public theorem projM_toLinearMap : projM.toLinearMap = projectorM := rfl

/-- Idempotence of `π` as an equation in `End(Λ²U)`, proved pointwise. -/
public theorem projectorM_mul_self : projectorM * projectorM = projectorM := by
  refine LinearMap.ext fun v => ?_
  rw [Module.End.mul_apply]
  exact projectorM_sq_apply v

public theorem projM_isIdem : IsIdempotentElem projM :=
  Representation.IntertwiningMap.ext projectorM_mul_self

public theorem trace_projM : LinearMap.trace k Lambda2U projM.toLinearMap = (10 : k) := by
  rw [projM_toLinearMap, projectorM_trace_eq_finrank, Ord11CharacterSum.finrank_Msub_eq_ten]
  norm_num

public theorem projM_ne_zero : projM ≠ 0 := by
  intro h
  have h0 : LinearMap.trace k Lambda2U projM.toLinearMap = 0 := by
    rw [h]; exact map_zero _
  rw [trace_projM] at h0
  exact absurd h0 (by norm_num)

public theorem projM_ne_one : projM ≠ 1 := by
  intro h
  have h1 : LinearMap.trace k Lambda2U projM.toLinearMap = (15 : k) := by
    rw [h]
    show LinearMap.trace k Lambda2U LinearMap.id = (15 : k)
    rw [LinearMap.trace_id, finrank_ambient]; norm_num
  rw [trace_projM] at h1
  exact absurd h1 (by norm_num)

/-! ## The commutant is two-dimensional -/

public theorem natCard_PSL2F11 : Nat.card PSL2F11 = 660 := by
  rw [Nat.card_eq_fintype_card]; exact card_PSL2F11

instance instNeZeroCard : NeZero ((Nat.card PSL2F11 : k)) := by
  refine ⟨?_⟩
  rw [natCard_PSL2F11]
  norm_num

/-- If the ambient character has norm `2`, the commutant of `Λ²U` is
two-dimensional. -/
public theorem finrank_intertwiningMap_of_sum
    (hsum : (∑ g : PSL2F11, chiLambda2 g * chiLambda2 g⁻¹) = (1320 : k)) :
    Module.finrank k (ambientRep.IntertwiningMap ambientRep) = 2 := by
  haveI : Invertible ((Nat.card PSL2F11 : k)) := invertibleOfNonzero (NeZero.ne _)
  have h := Representation.card_inv_mul_sum_char_mul_char_eq_finrank
    (ρ := ambientRep) (σ := ambientRep)
  simp only [character_ambientRep] at h
  rw [hsum, natCard_PSL2F11] at h
  have h2 : ((660 : ℕ) : k)⁻¹ * (1320 : k) = 2 := by
    push_cast
    rw [inv_mul_eq_div]
    norm_num
  rw [h2] at h
  exact_mod_cast h.symm

/-! ## Uniqueness -/

/-- **`M` is the unique ten-dimensional `PSL(2,11)`-stable subspace of `Λ²U`.**

Conditional on the ambient character norm `∑ χ_{Λ²U}(g) χ_{Λ²U}(g⁻¹) = 1320`,
every `PSL(2,11)`-stable subspace `N ⊆ Λ²U` with `finrank N = 10` equals `Msub`.

So `ℙ(M) ⊂ ℙ(Λ²U) = ℙ¹⁴` is not *a* codimension-5 subspace that happens to
work; it is *the* `G`-invariant one, and `V₁₄ = Gr(2,U) ∩ ℙ(M)` is determined
by `U` alone. -/
public theorem eq_Msub_of_sum_chiLambda2_norm
    (hsum : (∑ g : PSL2F11, chiLambda2 g * chiLambda2 g⁻¹) = (1320 : k))
    (N : Submodule k Lambda2U)
    (hN : ∀ (g : PSL2F11) ⦃v : Lambda2U⦄, v ∈ N → ambientAct g v ∈ N)
    (hdim : Module.finrank k N = 10) :
    N = Msub :=
  CommutantRankTwo.toSubmodule_eq_range
    (ρ := ambientRep) (finrank_intertwiningMap_of_sum hsum)
    projM_isIdem projM_ne_zero projM_ne_one
    (by rw [trace_projM]; norm_num)
    (by rw [trace_projM, finrank_ambient]; norm_num)
    (by rw [trace_projM, finrank_ambient]; norm_num)
    ⟨N, fun g v hv => by rw [ambientRep_apply]; exact hN g hv⟩
    (by show ((Module.finrank k N : ℕ) : k) = _; rw [hdim, trace_projM]; norm_num)

/-! ## Unconditional forms

The character norm is proved in `Ord11CharacterSum`, so both results above hold
outright.  The conditional forms are kept: they are what the proofs use, and
they record exactly which arithmetic fact the uniqueness rests on. -/

/-- **The commutant of `Λ²U` is two-dimensional.** -/
public theorem finrank_intertwiningMap :
    Module.finrank k (ambientRep.IntertwiningMap ambientRep) = 2 :=
  finrank_intertwiningMap_of_sum
    Ord11CharacterSum.sum_chiLambda2_norm_eq_thirteen_twenty

/-- **`M` is the unique ten-dimensional `PSL(2,11)`-stable subspace of `Λ²U`.**

Unconditional.  So `ℙ(M) ⊂ ℙ(Λ²U) = ℙ¹⁴` is not *a* codimension-5 subspace that
happens to work; it is *the* `G`-invariant one, and `V₁₄ = Gr(2,U) ∩ ℙ(M)` is
determined by `U` alone. -/
public theorem eq_Msub (N : Submodule k Lambda2U)
    (hN : ∀ (g : PSL2F11) ⦃v : Lambda2U⦄, v ∈ N → ambientAct g v ∈ N)
    (hdim : Module.finrank k N = 10) :
    N = Msub :=
  eq_Msub_of_sum_chiLambda2_norm
    Ord11CharacterSum.sum_chiLambda2_norm_eq_thirteen_twenty N hN hdim

#print axioms eq_Msub_of_sum_chiLambda2_norm
#print axioms finrank_intertwiningMap_of_sum
#print axioms projM_isIdem
#print axioms finrank_intertwiningMap
#print axioms eq_Msub

end MsubUnique
end V14Formalization
