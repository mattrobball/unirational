/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import BConicBundleMultisections.Unirationality
public import Mathlib.AlgebraicGeometry.Morphisms.Flat
public import Mathlib.AlgebraicGeometry.Morphisms.QuasiCompact
public import Mathlib.AlgebraicGeometry.Morphisms.SchemeTheoreticallyDominant
public import Mathlib.AlgebraicGeometry.Pullbacks

/-!
# Abstract multisection principle for conic fibrations

This module packages the scheme-theoretic skeleton of the classical multisection principle
(WP12 ingredients U01–U12), without assuming Tsen’s theorem or pointed-conic rationality.

## Classical statement

If `π : X → B` is a flat conic fibration and `T → B` is a dominant multisection source equipped
with a section of the pullback `X ×_B T → T` (equivalently, a morphism `T → X` over `B`), then:

1. the base-changed fibration `X_T := X ×_B T` carries a tautological section over `T`;
2. under the geometric hypothesis that a pointed conic fibration is rational over its base
   (U06; requires Tsen/`C₁` when the generic fibre is a smooth conic), `X_T` is rational over `T`
   of relative dimension one;
3. if in addition `T` is rational over a base `S` of dimension `d`, then `X_T` is rational over
   `S` of dimension `d + 1`;
4. the projection `X_T → X` is dominant (U09: flat base change of a scheme-theoretically dominant
   quasi-compact multisection map);
5. composing a unirational parametrization of `X_T` with that projection yields a unirational
   parametrization of `X` (U11–U12).

Steps (1), (4), and the composition (5) are formalized here as thin wrappers around Mathlib
pullbacks, scheme-theoretic dominance, and the project unirationality API.  Steps (2)–(3) are
recorded as named hypotheses / specializations: their geometric content is blocked by missing
Tsen/`C₁` and product-of-rational-schemes infrastructure in Mathlib.

## Blockers (not formalized here)

* **Tsen / `C₁`**: a smooth conic over a function field in one variable has a rational point.
* **Pointed-conic rationality (U06)**: a conic with a rational point is birational to `ℙ¹`.
* **Product rationality (U07)**: if `T` is rational over `S` and `X_T` is rational over `T` of
  relative dimension one, then `X_T` is rational over `S` of dimension `dim T + 1`.
-/

@[expose] public section

open CategoryTheory Limits
open scoped AlgebraicGeometry

noncomputable section

universe u

open AlgebraicGeometry
open Scheme

namespace BConicBundleMultisections

variable {X B : Scheme.{u}}

/-! ### U01: Multisection data -/

/--
A (regular) multisection of a morphism `π : X → B`.

This is a scheme `T` with morphisms to the total space and base making the obvious triangle
commute.  Horizontality / dominance of `toBase` is recorded separately when needed (U01, U09).
-/
structure Multisection (π : X ⟶ B) where
  /-- Multisection source. -/
  carrier : Scheme.{u}
  /-- Structure map of the multisection to the base of the fibration. -/
  toBase : carrier ⟶ B
  /-- Structure map of the multisection into the total space. -/
  toTotal : carrier ⟶ X
  /-- The multisection is a map of schemes over `B`. -/
  toTotal_comp : toTotal ≫ π = toBase

namespace Multisection

variable {π : X ⟶ B} (m : Multisection π)

/-- The base-changed total space `X ×_B T` (U03). -/
def baseChange : Scheme.{u} :=
  pullback π m.toBase

/-- Projection of the base change to the original total space. -/
def baseChangeFst : m.baseChange ⟶ X :=
  pullback.fst π m.toBase

/-- Projection of the base change to the multisection source. -/
def baseChangeSnd : m.baseChange ⟶ m.carrier :=
  pullback.snd π m.toBase

/-- The defining pullback square for the multisection base change. -/
lemma baseChange_isPullback :
    IsPullback m.baseChangeFst m.baseChangeSnd π m.toBase :=
  IsPullback.of_hasPullback _ _

/--
Tautological section of the base-changed fibration (U04).

Geometrically this is the diagonal copy of `T` inside `X ×_B T` associated with the multisection
morphism `T → X`.
-/
def tautologicalSection : m.carrier ⟶ m.baseChange :=
  pullback.lift m.toTotal (𝟙 m.carrier) (by
    rw [Category.id_comp]
    exact m.toTotal_comp)

@[reassoc (attr := simp)]
lemma tautologicalSection_fst :
    m.tautologicalSection ≫ m.baseChangeFst = m.toTotal := by
  dsimp [tautologicalSection, baseChangeFst]
  exact pullback.lift_fst _ _ _

@[reassoc (attr := simp)]
lemma tautologicalSection_snd :
    m.tautologicalSection ≫ m.baseChangeSnd = 𝟙 m.carrier := by
  dsimp [tautologicalSection, baseChangeSnd]
  exact pullback.lift_snd _ _ _

/-- The tautological map is literally a section of `baseChangeSnd`. -/
lemma is_split_section :
    m.tautologicalSection ≫ m.baseChangeSnd = 𝟙 m.carrier :=
  m.tautologicalSection_snd

/-- A multisection is **horizontal** (dominant over the base) when `toBase` is dominant. -/
class IsHorizontal : Prop where
  isDominant_toBase : IsDominant m.toBase

instance [IsDominant m.toBase] : m.IsHorizontal :=
  ⟨‹_›⟩

instance [m.IsHorizontal] : IsDominant m.toBase :=
  IsHorizontal.isDominant_toBase

/-- Scheme-theoretic dominance of the multisection map to the base (strengthens horizontality). -/
class IsSchemeTheoreticallyHorizontal : Prop where
  isSchemeTheoreticallyDominant_toBase : IsSchemeTheoreticallyDominant m.toBase
  quasiCompact_toBase : QuasiCompact m.toBase

instance [IsSchemeTheoreticallyDominant m.toBase] [QuasiCompact m.toBase] :
    m.IsSchemeTheoreticallyHorizontal where
  isSchemeTheoreticallyDominant_toBase := ‹_›
  quasiCompact_toBase := ‹_›

instance [m.IsSchemeTheoreticallyHorizontal] : IsSchemeTheoreticallyDominant m.toBase :=
  IsSchemeTheoreticallyHorizontal.isSchemeTheoreticallyDominant_toBase

instance [m.IsSchemeTheoreticallyHorizontal] : QuasiCompact m.toBase :=
  IsSchemeTheoreticallyHorizontal.quasiCompact_toBase

instance [m.IsSchemeTheoreticallyHorizontal] : m.IsHorizontal :=
  ⟨inferInstance⟩

/-! ### U09: Dominance of the projection `X_T → X` -/

/--
Under flatness of `π` and scheme-theoretic dominance + quasi-compactness of the multisection base
map, the projection `X_T → X` is scheme-theoretically dominant (U09).

This is the Mathlib instance `IsSchemeTheoreticallyDominant.pullbackFst` applied to the
multisection triangle.
-/
instance isSchemeTheoreticallyDominant_baseChangeFst [Flat π]
    [m.IsSchemeTheoreticallyHorizontal] :
    IsSchemeTheoreticallyDominant m.baseChangeFst :=
  show IsSchemeTheoreticallyDominant (pullback.fst π m.toBase) from
    IsSchemeTheoreticallyDominant.pullbackFst π m.toBase

/-- Consequently the projection `X_T → X` is dominant (U09, topological form).

Scheme-theoretic dominance plus quasi-compactness (stable under base change) imply topological
dominance.
-/
instance isDominant_baseChangeFst [Flat π] [m.IsSchemeTheoreticallyHorizontal] :
    IsDominant m.baseChangeFst :=
  -- Priority-low Mathlib instance: scheme-theoretically dominant + quasi-compact ⇒ dominant.
  (inferInstance : IsDominant (pullback.fst π m.toBase))

/-! ### U11–U12: Transfer of unirational parametrizations -/

/--
**Abstract multisection principle (parametrization form).**

If the base change `X_T` admits a unirational parametrization of dimension `n` over `S`, and the
projection `X_T → X` is dominant and lies over `S`, then so does `X`.

The geometric input that produces the parametrization of `X_T` (pointed-conic rationality, Tsen,
rationality of `T`) is supplied by the caller; this lemma is pure composition (U11–U12).
-/
theorem hasUnirationalParametrization_of_baseChange {S : Scheme.{u}} {n : ℕ}
    (sX : X ⟶ S) [IsDominant m.baseChangeFst]
    (h : HasUnirationalParametrization n (m.baseChangeFst ≫ sX)) :
    HasUnirationalParametrization n sX :=
  h.postcomp m.baseChangeFst rfl

/-- Specialization of the abstract principle under the flat / scheme-theoretic-horizontal package
that makes `baseChangeFst` automatically dominant (U09 + U11–U12). -/
theorem hasUnirationalParametrization_of_flat_horizontal_baseChange {S : Scheme.{u}} {n : ℕ}
    (sX : X ⟶ S) [Flat π] [m.IsSchemeTheoreticallyHorizontal]
    (h : HasUnirationalParametrization n (m.baseChangeFst ≫ sX)) :
    HasUnirationalParametrization n sX :=
  m.hasUnirationalParametrization_of_baseChange sX h

/-- Existential form: unirationality of the base change over `S` implies unirationality of `X`. -/
theorem isUnirationalOver_of_baseChange {S : Scheme.{u}} (sX : X ⟶ S)
    [IsDominant m.baseChangeFst] [IsUnirationalOver (m.baseChangeFst ≫ sX)] :
    IsUnirationalOver sX :=
  IsUnirationalOver.postcomp m.baseChangeFst rfl

/-- Existential form under the flat / horizontal package. -/
theorem isUnirationalOver_of_flat_horizontal_baseChange {S : Scheme.{u}} (sX : X ⟶ S)
    [Flat π] [m.IsSchemeTheoreticallyHorizontal]
    [IsUnirationalOver (m.baseChangeFst ≫ sX)] :
    IsUnirationalOver sX :=
  m.isUnirationalOver_of_baseChange sX

/--
If the base change is finite-dimensionally birational over `S` to affine `n`-space and the
projection to `X` is dominant, then `X` has a unirational parametrization of dimension `n`
(U08 + U11–U12).
-/
theorem hasUnirationalParametrization_of_baseChange_birational_affine {S : Scheme.{u}} {n : ℕ}
    (sX : X ⟶ S) [IsDominant m.baseChangeFst]
    (h : BirationalOver (m.baseChangeFst ≫ sX) (𝔸(ULift.{u} (Fin n); S) ↘ S)) :
    HasUnirationalParametrization n sX :=
  (HasUnirationalParametrization.of_partialIso h.partialIso.symm h.partialIso_isOver.symm).postcomp
    m.baseChangeFst rfl

end Multisection

/-! ### U04′: Sections of an arbitrary pullback, converse construction -/

variable {T : Scheme.{u}}

/--
A section of the base-changed fibration `pullback π t → T`, packaged as a splitting of
`pullback.snd`.

Every `Multisection` produces such a section via `Multisection.tautologicalSection`; conversely,
composing a section with `pullback.fst` recovers a multisection morphism `T → X`.
-/
structure PullbackSection (π : X ⟶ B) (t : T ⟶ B) where
  /-- The section morphism. -/
  σ : T ⟶ pullback π t
  /-- `σ` splits the projection to the multisection source. -/
  is_section : σ ≫ pullback.snd π t = 𝟙 T

namespace PullbackSection

variable {π : X ⟶ B} {t : T ⟶ B} (s : PullbackSection π t)

/-- The multisection morphism `T → X` recovered from a section of the pullback. -/
def toTotal : T ⟶ X :=
  s.σ ≫ pullback.fst π t

lemma toTotal_comp : s.toTotal ≫ π = t := by
  simp [toTotal, pullback.condition, reassoc_of% s.is_section]

/-- Convert a pullback section into multisection data (U01 ↔ U04). -/
def toMultisection : Multisection π where
  carrier := T
  toBase := t
  toTotal := s.toTotal
  toTotal_comp := s.toTotal_comp

@[simp]
lemma toMultisection_toBase : s.toMultisection.toBase = t := rfl

@[simp]
lemma toMultisection_toTotal : s.toMultisection.toTotal = s.toTotal := rfl

end PullbackSection

namespace Multisection

variable {π : X ⟶ B} (m : Multisection π)

/-- The tautological section, rephrased as `PullbackSection` data. -/
def tautologicalPullbackSection : PullbackSection π m.toBase where
  σ := m.tautologicalSection
  is_section := m.tautologicalSection_snd

@[simp]
lemma tautologicalPullbackSection_toTotal :
    m.tautologicalPullbackSection.toTotal = m.toTotal := by
  dsimp [PullbackSection.toTotal, tautologicalPullbackSection, baseChangeFst]
  exact m.tautologicalSection_fst

end Multisection

/-! ### U06 hypothesis: pointed base change is rational over the multisection source -/

/--
**Geometric hypothesis (U06).** The pointed base-changed fibration is birational over `T` to
relative affine 1-space.

For a smooth conic fibration this is the classical “pointed conic is rational” statement, and
producing the point on the generic fibre over a curve base uses Tsen/`C₁`.  Both are **missing**
from Mathlib at the pinned revision; callers of the multisection principle must supply this
hypothesis (or a stronger finite-dimensional birationality of the base change over the absolute
base `S`).
-/
def IsPointedConicRationalOver (π : X ⟶ B) (t : T ⟶ B)
    (_sec : PullbackSection π t) : Prop :=
  BirationalOver (pullback.snd π t) (𝔸(ULift.{u} (Fin 1); T) ↘ T)

/-! ### Specialization: rational surface multisection → threefold unirationality -/

/--
**Specialized multisection principle (dimension 3).**

If `B` is a surface base, `T` is a rational multisection source, and the base change of the
(conic) fibration is finite-dimensionally birational over `S` to affine 3-space, then `X` admits a
unirational parametrization of dimension 3.

The birationality hypothesis packages the blocked steps U06–U08 (pointed-conic rationality over a
rational surface, giving relative dimension `2 + 1 = 3`).  Dominance of the projection is the
standard flat/horizontal package (U09).
-/
theorem hasUnirationalParametrization_three_of_rational_surface_multisection
    {S : Scheme.{u}} {π : X ⟶ B} (m : Multisection π)
    (sX : X ⟶ S) [Flat π] [m.IsSchemeTheoreticallyHorizontal]
    (hBaseChange : BirationalOver (m.baseChangeFst ≫ sX)
      (𝔸(ULift.{u} (Fin 3); S) ↘ S)) :
    HasUnirationalParametrization 3 sX :=
  m.hasUnirationalParametrization_of_baseChange_birational_affine sX hBaseChange

/-- Existential form of the dimension-3 specialization. -/
theorem isUnirationalOver_three_of_rational_surface_multisection
    {S : Scheme.{u}} {π : X ⟶ B} (m : Multisection π)
    (sX : X ⟶ S) [Flat π] [m.IsSchemeTheoreticallyHorizontal]
    (hBaseChange : BirationalOver (m.baseChangeFst ≫ sX)
      (𝔸(ULift.{u} (Fin 3); S) ↘ S)) :
    IsUnirationalOver sX :=
  (hasUnirationalParametrization_three_of_rational_surface_multisection
    m sX hBaseChange).isUnirationalOver

/--
Parametrization form with an already-constructed unirational parametrization of the base change
of dimension 3 (e.g. after applying a future Tsen + product-rationality package).
-/
theorem hasUnirationalParametrization_three_of_baseChange_parametrization
    {S : Scheme.{u}} {π : X ⟶ B} (m : Multisection π)
    (sX : X ⟶ S) [Flat π] [m.IsSchemeTheoreticallyHorizontal]
    (h : HasUnirationalParametrization 3 (m.baseChangeFst ≫ sX)) :
    HasUnirationalParametrization 3 sX :=
  m.hasUnirationalParametrization_of_flat_horizontal_baseChange sX h

end BConicBundleMultisections

end
