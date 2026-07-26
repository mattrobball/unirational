/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import BConicBundleMultisections.ProjectiveHypersurfaceFunctionField
public import BConicBundleMultisections.ProjectiveHypersurfaceNegativeTwist

/-!
# The canonical global-section comparison for a projective hypersurface chart
-/

@[expose] public section

open CategoryTheory TopologicalSpace
open scoped AlgebraicGeometry

namespace BConicBundleMultisections

noncomputable section

universe u

open AlgebraicGeometry MvPolynomial

namespace ProjectiveSpace

attribute [local instance] MvPolynomial.gradedAlgebra

variable {k : Type u} [Field k]

/-- The explicit spectrum presentation of a retained hypersurface chart has the expected
structural morphism to `Spec k`. -/
theorem hypersurfaceChartIsoSpecAffineQuotient_inv_toSpec
    (H : MvPolynomial (Fin 3) k) {d : ℕ}
    (hH : H.IsHomogeneous d) (i : Fin 3) :
    (hypersurfaceChartIsoSpecAffineQuotient 2 k i H).inv ≫
        hypersurfaceChartToGlobal 2 k H hH i ≫
        projectiveZeroLocusToSpec H =
      Spec.map (CommRingCat.ofHom
        (algebraMap k (HypersurfaceChartQuotient H i))) := by
  unfold projectiveZeroLocusToSpec
  let e := hypersurfaceChartIsoSpecAffineQuotient 2 k i H
  let f := hypersurfaceChartToGlobal 2 k H hH i
  let ιH := (hypersurfaceChartIdealSheaf 2 k i H).subschemeι
  let ιU := standardChartι 2 k i
  let φ := hypersurfaceAffineChartQuotientMap 2 k i H
  have hf : f ≫ projectiveZeroLocusι 2 k H = ιH ≫ ιU :=
    hypersurfaceChartToGlobal_ι 2 k H hH i
  have he : e.inv ≫ ιH = Spec.map (CommRingCat.ofHom φ) := by
    have he' : e.hom ≫ Spec.map (CommRingCat.ofHom φ) = ιH :=
      hypersurfaceChartIsoSpecAffineQuotient_hom_subschemeι 2 k i H
    rw [← he']
    simp
  calc
    e.inv ≫ f ≫ projectiveZeroLocusι 2 k H ≫ toSpec 2 k =
        e.inv ≫ ιH ≫ ιU ≫ toSpec 2 k := by
      simpa only [Category.assoc] using
        congrArg (fun z ↦ e.inv ≫ z ≫ toSpec 2 k) hf
    _ = Spec.map (CommRingCat.ofHom φ) ≫ ιU ≫ toSpec 2 k := by
      simpa only [Category.assoc] using
        congrArg (fun z ↦ z ≫ ιU ≫ toSpec 2 k) he
    _ = Spec.map (CommRingCat.ofHom φ) ≫
        Spec.map (CommRingCat.ofHom
          (algebraMap k (StandardChartRing 2 k i))) := by
      rw [ProjectiveSpace.standardChartι_toSpec]
    _ = Spec.map (CommRingCat.ofHom
        (φ.comp (algebraMap k (StandardChartRing 2 k i)))) := by
      rw [← Spec.map_comp]
      rfl
    _ = Spec.map (CommRingCat.ofHom
        (algebraMap k (HypersurfaceChartQuotient H i))) := by
      congr 1
      ext c
      simpa [φ, hypersurfaceAffineChartQuotientMap] using
        (Ideal.Quotient.mk_algebraMap
          (R₁ := k)
          (Ideal.span {chartDehomogenization 2 k i H}) c)

/-- Restrict a global function to a retained chart, identify its coordinate ring with the
explicit dehomogenized quotient, and then include it in that quotient's fraction field. -/
noncomputable def globalSectionsToHypersurfaceFunctionField
    (H : MvPolynomial (Fin 3) k) {d : ℕ}
    (hH : H.IsHomogeneous d) (_hHirr : Irreducible H)
    (i : NonemptyHypersurfaceChart H) :
    Γ(projectiveZeroLocus 2 k H, ⊤) →+* HypersurfaceFunctionField H i :=
  (algebraMap (HypersurfaceChartQuotient H i.1)
      (HypersurfaceFunctionField H i)).comp
    ((hypersurfaceChartQuotientEquivSections H hH i).symm.toRingHom.comp
      ((projectiveZeroLocus 2 k H).presheaf.map
        (homOfLE (show hypersurfaceRetainedChartOpen H hH i ≤
          (⊤ : (projectiveZeroLocus 2 k H).Opens) from le_top)).op).hom)

/-- The restriction comparison carries base-field global functions to the ordinary scalar map
in the explicit chart fraction field. -/
theorem globalSectionsToHypersurfaceFunctionField_map_base
    (H : MvPolynomial (Fin 3) k) {d : ℕ}
    (hH : H.IsHomogeneous d) (hHirr : Irreducible H)
    (i : NonemptyHypersurfaceChart H) (c : k) :
    globalSectionsToHypersurfaceFunctionField H hH hHirr i
        (globalSectionsMapFromBase k (projectiveZeroLocusToSpec H) c) =
      hypersurfaceBaseToFunctionField H hH hHirr i c := by
  let A := HypersurfaceChartQuotient H i.1
  let K := HypersurfaceFunctionField H i
  letI : IsDomain A :=
    isDomain_chartDehomogenization_quotient_of_irreducible
      i.1 H hH hHirr i.2
  rw [show hypersurfaceBaseToFunctionField H hH hHirr i c =
      algebraMap A K (algebraMap k A c) by
    exact (IsScalarTower.algebraMap_apply k A K c).symm]
  unfold globalSectionsToHypersurfaceFunctionField
  simp only [RingHom.comp_apply]
  change algebraMap A K
      ((hypersurfaceChartQuotientEquivSections H hH i).symm
        ((projectiveZeroLocus 2 k H).presheaf.map
          (homOfLE (show hypersurfaceRetainedChartOpen H hH i ≤
            (⊤ : (projectiveZeroLocus 2 k H).Opens) from le_top)).op
          (globalSectionsMapFromBase k (projectiveZeroLocusToSpec H) c))) =
    algebraMap A K (algebraMap k A c)
  congr 1
  rw [hypersurfaceChartQuotientEquivSections_symm_restrict]
  let e := hypersurfaceChartIsoSpecAffineQuotient 2 k i.1 H
  let f := hypersurfaceChartToGlobal 2 k H hH i.1
  let g := projectiveZeroLocusToSpec H
  let φ : k →+* A := algebraMap k A
  have hstruct : e.inv ≫ f ≫ g = Spec.map (CommRingCat.ofHom φ) :=
    hypersurfaceChartIsoSpecAffineQuotient_inv_toSpec H hH i.1
  change (Scheme.ΓSpecIso (.of A)).hom
      (e.inv.appTop (f.appTop
        (g.appTop ((Scheme.ΓSpecIso (.of k)).inv c)))) = φ c
  calc
    (Scheme.ΓSpecIso (.of A)).hom
        (e.inv.appTop (f.appTop
          (g.appTop ((Scheme.ΓSpecIso (.of k)).inv c)))) =
      (Scheme.ΓSpecIso (.of A)).hom
        ((e.inv ≫ f ≫ g).appTop
          ((Scheme.ΓSpecIso (.of k)).inv c)) := by
            simp only [Scheme.Hom.comp_appTop, CommRingCat.comp_apply]
    _ = (Scheme.ΓSpecIso (.of A)).hom
        ((Spec.map (CommRingCat.ofHom φ)).appTop
          ((Scheme.ΓSpecIso (.of k)).inv c)) := by rw [hstruct]
    _ = φ c := by
      rw [← CommRingCat.comp_apply,
        Scheme.ΓSpecIso_naturality,
        CommRingCat.comp_apply, Iso.inv_hom_id_apply]
      change φ c = φ c
      rfl

/-- The canonical instance of the comparison datum consumed by the negative-twist theorem. -/
noncomputable def canonicalGlobalSectionsToHypersurfaceFunctionFieldComparison
    (H : MvPolynomial (Fin 3) k) {d : ℕ}
    (hH : H.IsHomogeneous d) (hHirr : Irreducible H)
    (i : NonemptyHypersurfaceChart H) :
    GlobalSectionsToHypersurfaceFunctionFieldComparison H hH hHirr i where
  toFunctionField := globalSectionsToHypersurfaceFunctionField H hH hHirr i
  map_base := globalSectionsToHypersurfaceFunctionField_map_base H hH hHirr i

end ProjectiveSpace

end

end BConicBundleMultisections

end
