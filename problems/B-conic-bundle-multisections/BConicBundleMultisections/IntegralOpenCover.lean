/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import Mathlib.AlgebraicGeometry.Properties
public import Mathlib.Topology.Sets.OpenCover

/-!
# Integrality from an overlapping integral open cover

Reducedness is local, while irreducibility can be checked on an open cover whose members are
irreducible and have pairwise nonempty intersections.  This packages those two facts in the form
used by projective hypersurface chart covers.
-/

@[expose] public section

open CategoryTheory
open scoped AlgebraicGeometry

namespace BConicBundleMultisections

open AlgebraicGeometry

universe u v

/-- A nonempty scheme covered by integral opens with pairwise nonempty intersections is integral.

The hypothesis is stated as non-disjointness of the corresponding `Opens`; for ordinary sets this
is equivalent to nonemptiness of their intersection. -/
theorem isIntegral_of_openCover_of_pairwise_nonempty
    {X : Scheme.{u}} (U : X.OpenCover.{v})
    [Nonempty X] [hUi : ∀ i, IsIntegral (U.X i)]
    (hpair : _root_.Pairwise
      (Function.onFun (fun V W : X.Opens => ¬ Disjoint V W)
        (fun i => (U.f i).opensRange))) :
    IsIntegral X := by
  haveI hred : IsReduced X := IsReduced.of_openCover X U
  have hopen : TopologicalSpace.IsOpenCover (fun i => (U.f i).opensRange) := by
    rw [TopologicalSpace.IsOpenCover, U.iSup_opensRange]
  have hpre (i) : IsPreirreducible ((U.f i).opensRange : Set X) := by
    have himage :=
      (IrreducibleSpace.isIrreducible_univ (U.X i)).2.image
        (U.f i).base (Scheme.Hom.continuous (U.f i)).continuousOn
    simpa [Set.image_univ] using himage
  have huniv : IsPreirreducible (Set.univ : Set X) :=
    IsPreirreducible.of_subset_iUnion hpair hpre isOpen_univ
      (by simpa using hopen.iSup_set_eq_univ)
  haveI hpreX : PreirreducibleSpace X := ⟨by simpa using huniv⟩
  haveI hirr : IrreducibleSpace X := IrreducibleSpace.mk inferInstance
  exact isIntegral_of_irreducibleSpace_of_isReduced X

end BConicBundleMultisections
