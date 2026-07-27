/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import BConicBundleMultisections.Bidegree23Example
public import BConicBundleMultisections.GoodLine
public import BConicBundleMultisections.MainTheorem

/-!
# Guards on the headline theorem

Mechanical checks that the main theorem still says what it is supposed to say, and that the
results advertised as proved are still proved.  Every check here is a compile-time failure, so the
existing `lake build` CI enforces them on each push with no extra configuration.

## Why this file exists

The failure mode this project has already suffered is not an unsound proof — it is a *statement*
that drifted.  An earlier version of the main theorem type-checked, contained no `sorry`, and
reported only the three standard axioms, while carrying a hypothesis
`HasResidualBaseChangeUnirationalParametrization3` that is false whenever the residual image is
reducible.  Neither an axiom check nor a `sorry` census detects that; only reading the statement
does.  So:

* `headline_statement_guard` pins the exact type of the main theorem.  Adding a hypothesis breaks
  the build here, which forces the change to appear in the diff of a file whose whole purpose is
  to be read.
* `#guard_no_sorry` pins the results that must stay independent of the outstanding obligations.
  These are load-bearing: if one of them silently came to depend on an obligation, the remaining
  work would look smaller than it is.
* `#guard_axioms_standard` allows `sorryAx` but nothing else, so legacy results whose old proof
  routes still contain isolated obligations cannot silently acquire any further axiom.
* `#guard_no_sorry` on the headline theorem is the mechanical definition of completion: the exact
  statement above must depend on no axiom beyond the standard three.
-/

open Lean Elab Command in
/-- Fail unless the named constant's axiom set is contained in
`{propext, Classical.choice, Quot.sound, sorryAx}`. -/
elab "#guard_axioms_standard " id:ident : command => do
  let n ← liftCoreM <| realizeGlobalConstNoOverloadWithInfo id
  let axs ← liftCoreM <| collectAxioms n
  let allowed : Array Name := #[``propext, ``Classical.choice, ``Quot.sound, ``sorryAx]
  let bad := axs.filter fun a => !allowed.contains a
  unless bad.isEmpty do
    throwError "{n} depends on unexpected axioms: {bad}"

open Lean Elab Command in
/-- Fail unless the named constant is fully proved: axiom set contained in the three standard
axioms, with no `sorryAx`. -/
elab "#guard_no_sorry " id:ident : command => do
  let n ← liftCoreM <| realizeGlobalConstNoOverloadWithInfo id
  let axs ← liftCoreM <| collectAxioms n
  let allowed : Array Name := #[``propext, ``Classical.choice, ``Quot.sound]
  let bad := axs.filter fun a => !allowed.contains a
  unless bad.isEmpty do
    throwError "{n} was expected to be fully proved but depends on: {bad}"

@[expose] public section

open scoped AlgebraicGeometry

namespace BConicBundleMultisections

universe u

open AlgebraicGeometry MvPolynomial

/-- **Statement guard.**  Fails to compile if the headline theorem acquires a hypothesis, changes
its conclusion, or weakens its dimension.  The right-hand side is the theorem itself; the
left-hand side is the statement we intend it to have, written out.

Do not "fix" a failure here by editing the expected type.  A failure means the theorem changed;
decide whether that change was intended before touching this file. -/
theorem headline_statement_guard :
    ∀ (k : Type u) [Field k] [IsAlgClosed k] [NeZero (2 : k)] [NeZero (3 : k)]
      (F : MvPolynomial (BiprojectiveCoordinate 2 2) k),
      IsBidegree23 F → F ≠ 0 →
        ∀ [Smooth (Bidegree23ZeroLocus.toSpec k F)],
          HasUnirationalParametrization 3 (Bidegree23ZeroLocus.toSpec k F) :=
  smooth_bidegree23_hasUnirationalParametrization

end BConicBundleMultisections

/-! ### Axiom guards -/

-- The exact headline statement and its statement guard are fully proved.
#guard_no_sorry BConicBundleMultisections.smooth_bidegree23_hasUnirationalParametrization
#guard_no_sorry BConicBundleMultisections.headline_statement_guard

-- The new unconditional assembly chain is guarded explicitly, so a future refactor cannot hide a
-- `sorry` below the already-guarded headline theorem.
#guard_no_sorry
  BConicBundleMultisections.Standard.exists_actualG3G4LineSection_via_frameIncidence
#guard_no_sorry
  BConicBundleMultisections.targetRelationsProjectivelyIntegralAwayDiscriminant_of_smooth
#guard_no_sorry
  BConicBundleMultisections.targetRelationsResidualNegativeTwistGluingAwayDiscriminantOn
#guard_no_sorry
  BConicBundleMultisections.BiprojectiveSpace.residualEquationOn_mem_span_targetRelation_of_isIso_of_negativeTwist
#guard_no_sorry
  BConicBundleMultisections.hasUnirationalParametrization3_biprojectiveZeroLocus_of_projectivelyIntegralTargetRelations
#guard_no_sorry
  BConicBundleMultisections.hasUnirationalParametrization3_biprojectiveZeroLocus

-- Load-bearing results that must remain fully proved.  If one of these starts depending on an
-- obligation, the remaining work is larger than the obligation list suggests.
#guard_no_sorry BConicBundleMultisections.exists_isotropic_ternary_quadratic_poly
#guard_no_sorry BConicBundleMultisections.residualImageXCoords_ne_zero_of_smooth
#guard_no_sorry BConicBundleMultisections.specializedConicFreeDirForm_ne_zero_of_smooth
#guard_no_sorry BConicBundleMultisections.hasUnirationalParametrization2_residualComponent
#guard_no_sorry BConicBundleMultisections.isDominant_residualComponentMultisection_baseChangeFst
#guard_no_sorry BConicBundleMultisections.isDominant_residualComponentToBase_iff
#guard_no_sorry BConicBundleMultisections.residual_baseChange_package_summary
#guard_no_sorry
  BConicBundleMultisections.smooth_bidegree23_hasUnirationalParametrization_of_multisection_dominant

-- Legacy determinant-backed route, retained for reference but not consumed by the headline.
#guard_axioms_standard BConicBundleMultisections.residualYCoords_ne_zero_of_smooth

-- WP-4 is closed: the tower and its residual-component instance are fully proved.
#guard_no_sorry BConicBundleMultisections.hasUnirationalParametrization_succ_of_tower
#guard_no_sorry BConicBundleMultisections.hasUnirationalParametrization3_of_component_tower
#guard_no_sorry BConicBundleMultisections.comp_hom_over
#guard_no_sorry BConicBundleMultisections.mapPartialMap_hom_over

-- §1(b) of the source proof is fully proved and must stay that way.
#guard_no_sorry BConicBundleMultisections.not_eq_rename_mul_rename_of_smooth

-- **Non-vacuity.**  A concrete smooth bidegree-(2,3) hypersurface exists, so the `Smooth`
-- hypothesis of the headline theorem is satisfiable.  This is the one guard that `#print axioms`
-- on the main theorem structurally cannot provide: a vacuous theorem passes every axiom check and
-- every `sorry` census.  If this ever breaks, the main theorem may be about the empty set.
#guard_no_sorry BConicBundleMultisections.Bidegree23Example.smooth_F

-- The obvious Fermat candidate is singular; that is machine-checked, not assumed, and the
-- witness above had to couple every `x` to every `y` to avoid it.
#guard_no_sorry BConicBundleMultisections.Bidegree23Example.not_smooth_fermatF
