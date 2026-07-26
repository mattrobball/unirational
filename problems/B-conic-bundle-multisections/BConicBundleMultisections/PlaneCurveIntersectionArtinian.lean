/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import BConicBundleMultisections.ResidualComponentExhaustion
public import Mathlib.AlgebraicGeometry.Morphisms.QuasiFinite
public import Mathlib.AlgebraicGeometry.ProjectiveSpectrum.Proper
public import Mathlib.RingTheory.Algebraic.Integral
public import Mathlib.RingTheory.HopkinsLevitzki
public import Mathlib.RingTheory.IntegralClosure.IsIntegralClosure.Basic
public import Mathlib.RingTheory.Polynomial.Resultant.Basic

/-!
# Artinian certificates for intersections of plane curves

This file isolates the commutative-algebra input behind the generic-plane-intersection step in
the tangent--residual argument.

For an ideal `I` in a polynomial ring over a field, the quotient is finite over the field once
the images of all coordinate variables are algebraic.  Consequently the quotient is Artinian.
The algebraicity hypotheses are deliberately stated as explicit nonzero univariate eliminants:
this is the form produced by a resultant computation.  A second criterion, convenient for
zero-supported affine intersections, asks for powers of the coordinates to lie in `I`.

The scheme-level theorem packages the usual three-chart projective argument.  If an open cover is
identified with spectra of affine plane-intersection quotients and each chart has coordinate
eliminants, then the scheme is locally Artinian.  This avoids pretending that Mathlib currently
contains a projective Bezout theorem: deriving these eliminants and chart identifications from
"the two homogeneous plane curves have no common component" remains a separate input.

Finally, finite underlying point fibres of a locally finite type morphism are converted into
locally Artinian scheme-theoretic fibres.  This is the exact scheme-theoretic endpoint needed for
`targetRelationToFirst` once a projective-intersection finiteness theorem is available.
-/

@[expose] public section

open CategoryTheory Topology TopologicalSpace
open scoped AlgebraicGeometry
open AlgebraicGeometry

namespace BConicBundleMultisections
namespace PlaneCurveIntersectionArtinian

noncomputable section

universe u v

open _root_.MvPolynomial

variable {K : Type u} [Field K]

/-! ## Polynomial-quotient certificates -/

/-- If all coordinate classes in a multivariate-polynomial quotient are integral, then the
whole quotient algebra is integral.  No finiteness assumption on the variable type is needed for
this closure argument. -/
theorem quotient_isIntegral_of_coordinate_isIntegral
    {σ : Type v} (I : Ideal (MvPolynomial σ K))
    (hX : ∀ i : σ, IsIntegral K
      (Ideal.Quotient.mk I (MvPolynomial.X i))) :
    Algebra.IsIntegral K (MvPolynomial σ K ⧸ I) := by
  constructor
  intro z
  obtain ⟨p, rfl⟩ := Ideal.Quotient.mk_surjective z
  induction p using MvPolynomial.induction_on with
  | C a =>
      rw [show MvPolynomial.C a =
        algebraMap K (MvPolynomial σ K) a from rfl,
        Ideal.Quotient.mk_algebraMap]
      exact isIntegral_algebraMap
  | add p q hp hq =>
      simpa only [map_add] using hp.add hq
  | mul_X p i hp =>
      simpa only [map_mul, map_X] using hp.mul (hX i)

/-- With finitely many variables, integrality of the coordinate classes makes the polynomial
quotient a finite-dimensional algebra, hence an Artinian ring. -/
theorem quotient_isArtinian_of_coordinate_isIntegral
    {σ : Type v} [Finite σ] (I : Ideal (MvPolynomial σ K))
    (hX : ∀ i : σ, IsIntegral K
      (Ideal.Quotient.mk I (MvPolynomial.X i))) :
    IsArtinianRing (MvPolynomial σ K ⧸ I) := by
  letI : Algebra.IsIntegral K (MvPolynomial σ K ⧸ I) :=
    quotient_isIntegral_of_coordinate_isIntegral I hX
  letI : Module.Finite K (MvPolynomial σ K ⧸ I) :=
    Algebra.IsIntegral.finite
  exact IsArtinianRing.of_finite K _

/-- Explicit elimination form of the preceding criterion.  For each affine coordinate, it is
enough to exhibit a nonzero univariate polynomial which vanishes on its class in the quotient.
Over a field, algebraic and integral elements coincide. -/
theorem quotient_isArtinian_of_coordinate_eliminants
    {σ : Type v} [Finite σ] (I : Ideal (MvPolynomial σ K))
    (helim : ∀ i : σ, ∃ P : Polynomial K, P ≠ 0 ∧
      Polynomial.eval₂ (algebraMap K (MvPolynomial σ K ⧸ I))
        (Ideal.Quotient.mk I (MvPolynomial.X i)) P = 0) :
    IsArtinianRing (MvPolynomial σ K ⧸ I) := by
  apply quotient_isArtinian_of_coordinate_isIntegral I
  intro i
  obtain ⟨P, hP, hroot⟩ := helim i
  exact (IsAlgebraic.isIntegral ⟨P, hP, hroot⟩)

/-- A particularly concrete Artinian certificate: a power of each coordinate belongs to the
ideal.  This applies, for example, to an affine intersection whose only geometric support is the
origin. -/
theorem quotient_isArtinian_of_coordinate_powers_mem
    {σ : Type v} [Finite σ] (I : Ideal (MvPolynomial σ K))
    (hpow : ∀ i : σ, ∃ n : ℕ, MvPolynomial.X i ^ n ∈ I) :
    IsArtinianRing (MvPolynomial σ K ⧸ I) := by
  apply quotient_isArtinian_of_coordinate_isIntegral I
  intro i
  obtain ⟨n, hmem⟩ := hpow i
  refine ⟨Polynomial.X ^ n, Polynomial.monic_X_pow n, ?_⟩
  rw [Polynomial.eval₂_X_pow, ← map_pow]
  exact Ideal.Quotient.eq_zero_iff_mem.mpr hmem

/-- The affine coordinate ring of the intersection of two plane-chart equations. -/
abbrev affinePlaneIntersectionRing
    (f g : MvPolynomial (Fin 2) K) :=
  MvPolynomial (Fin 2) K ⧸ Ideal.span ({f, g} : Set (MvPolynomial (Fin 2) K))

/-- Resultant/elimination certificate for an affine plane-curve intersection. -/
def HasAffinePlaneCoordinateEliminants
    (f g : MvPolynomial (Fin 2) K) : Prop :=
  ∀ i : Fin 2, ∃ P : Polynomial K, P ≠ 0 ∧
    Polynomial.eval₂ (algebraMap K (affinePlaneIntersectionRing f g))
      (Ideal.Quotient.mk (Ideal.span ({f, g} : Set (MvPolynomial (Fin 2) K)))
        (MvPolynomial.X i)) P = 0

/-- Two affine plane equations with coordinate eliminants cut out an Artinian affine scheme.
The eliminants can be supplied by nonzero resultants; this theorem contains the algebraic
finite-dimensionality step after those resultant nonvanishing statements. -/
theorem affinePlaneIntersectionRing_isArtinian_of_coordinateEliminants
    (f g : MvPolynomial (Fin 2) K)
    (h : HasAffinePlaneCoordinateEliminants f g) :
    IsArtinianRing (affinePlaneIntersectionRing f g) := by
  exact quotient_isArtinian_of_coordinate_eliminants
    (Ideal.span ({f, g} : Set (MvPolynomial (Fin 2) K))) h

/-! ### Resultants supply the eliminants -/

/-- Regard an affine plane polynomial as a univariate polynomial after first reordering its two
coordinates.  The coordinate sent to `0` is the outer polynomial variable; the coordinate sent
to `1` remains in the coefficient ring. -/
noncomputable def orderedAffinePlaneEquiv (e : Fin 2 ≃ Fin 2) :
    MvPolynomial (Fin 2) K ≃ₐ[K] Polynomial (MvPolynomial (Fin 1) K) :=
  (MvPolynomial.renameEquiv K e).trans (MvPolynomial.finSuccEquiv K 1)

private theorem finSuccEquiv_rename_succ (r : MvPolynomial (Fin 1) K) :
    MvPolynomial.finSuccEquiv K 1 (MvPolynomial.rename Fin.succ r) =
      Polynomial.C r := by
  let lhs : MvPolynomial (Fin 1) K →+* Polynomial (MvPolynomial (Fin 1) K) :=
    (MvPolynomial.finSuccEquiv K 1).toRingEquiv.toRingHom.comp
      (MvPolynomial.rename Fin.succ).toRingHom
  have hhom : lhs = Polynomial.C := by
    apply MvPolynomial.ringHom_ext
    · intro a
      simp [lhs, MvPolynomial.finSuccEquiv_apply]
    · intro j
      simp [lhs, MvPolynomial.finSuccEquiv_X_succ]
  exact DFunLike.congr_fun hhom r

private theorem orderedAffinePlaneEquiv_symm_C (e : Fin 2 ≃ Fin 2)
    (r : MvPolynomial (Fin 1) K) :
    (orderedAffinePlaneEquiv (K := K) e).symm (Polynomial.C r) =
      MvPolynomial.rename (fun j : Fin 1 ↦ e.symm j.succ) r := by
  apply (orderedAffinePlaneEquiv (K := K) e).injective
  rw [AlgEquiv.apply_symm_apply]
  unfold orderedAffinePlaneEquiv
  rw [AlgEquiv.trans_apply, MvPolynomial.renameEquiv_apply,
    MvPolynomial.rename_rename]
  have hfun : e ∘ (fun j : Fin 1 ↦ e.symm j.succ) = Fin.succ := by
    funext j
    exact e.apply_symm_apply j.succ
  rw [hfun, finSuccEquiv_rename_succ]

private theorem quotient_mk_eq_eval₂
    (I : Ideal (MvPolynomial (Fin 2) K))
    (p : MvPolynomial (Fin 2) K) :
    MvPolynomial.eval₂ (algebraMap K (MvPolynomial (Fin 2) K ⧸ I))
      (fun i ↦ Ideal.Quotient.mk I (MvPolynomial.X i)) p =
      Ideal.Quotient.mk I p := by
  induction p using MvPolynomial.induction_on with
  | C a =>
      rw [MvPolynomial.eval₂_C]
      rw [show MvPolynomial.C a =
        algebraMap K (MvPolynomial (Fin 2) K) a from rfl,
        Ideal.Quotient.mk_algebraMap]
  | add p q hp hq =>
      rw [MvPolynomial.eval₂_add, map_add, hp, hq]
  | mul_X p i hp =>
      rw [MvPolynomial.eval₂_mul, MvPolynomial.eval₂_X, map_mul, hp]

/-- A nonzero resultant in a chosen coordinate order gives a nonzero univariate eliminant for
the other coordinate in the affine intersection ring.  The degree hypothesis rules out the
degree-zero convention under which the resultant is `1` without carrying a Bezout identity.

This is the direct formal bridge from a resultant nonvanishing certificate to the coordinate
algebraicity used above. -/
theorem exists_coordinateEliminant_of_orderedResultant
    (f g : MvPolynomial (Fin 2) K) (e : Fin 2 ≃ Fin 2)
    (hdeg : ((orderedAffinePlaneEquiv (K := K) e) f).natDegree ≠ 0 ∨
      ((orderedAffinePlaneEquiv (K := K) e) g).natDegree ≠ 0)
    (hres : ((orderedAffinePlaneEquiv (K := K) e) f).resultant
      ((orderedAffinePlaneEquiv (K := K) e) g) ≠ 0) :
    let I := Ideal.span ({f, g} : Set (MvPolynomial (Fin 2) K))
    ∃ P : Polynomial K, P ≠ 0 ∧
      Polynomial.eval₂ (algebraMap K (MvPolynomial (Fin 2) K ⧸ I))
        (Ideal.Quotient.mk I (MvPolynomial.X (e.symm (1 : Fin 2)))) P = 0 := by
  dsimp only
  let I := Ideal.span ({f, g} : Set (MvPolynomial (Fin 2) K))
  let f' := (orderedAffinePlaneEquiv (K := K) e) f
  let g' := (orderedAffinePlaneEquiv (K := K) e) g
  let r : MvPolynomial (Fin 1) K :=
    f'.resultant g' f'.natDegree g'.natDegree
  let P : Polynomial K := MvPolynomial.uniqueAlgEquiv K (Fin 1) r
  have hr : r ≠ 0 := hres
  have hP : P ≠ 0 :=
    (MvPolynomial.uniqueAlgEquiv K (Fin 1)).injective.ne hr
  refine ⟨P, hP, ?_⟩
  obtain ⟨a, b, _ha, _hb, hab⟩ :=
    Polynomial.exists_mul_add_mul_eq_C_resultant f' g'
      (m := f'.natDegree) (n := g'.natDegree) le_rfl le_rfl hdeg
  let Φ : Polynomial (MvPolynomial (Fin 1) K) →+*
      (MvPolynomial (Fin 2) K ⧸ I) :=
    (Ideal.Quotient.mk I).comp
      (orderedAffinePlaneEquiv (K := K) e).symm.toRingEquiv.toRingHom
  have hmapped := congrArg Φ hab
  have hfzero : Ideal.Quotient.mk I f = 0 :=
    Ideal.Quotient.eq_zero_iff_mem.mpr (Ideal.subset_span (by simp))
  have hgzero : Ideal.Quotient.mk I g = 0 :=
    Ideal.Quotient.eq_zero_iff_mem.mpr (Ideal.subset_span (by simp))
  have hrzero : Ideal.Quotient.mk I
      (MvPolynomial.rename (fun j : Fin 1 ↦ e.symm j.succ) r) = 0 := by
    have hzero_rev : 0 = Ideal.Quotient.mk I
        (MvPolynomial.rename (fun j : Fin 1 ↦ e.symm j.succ) r) := by
      simpa [Φ, f', g', r, hfzero, hgzero,
        orderedAffinePlaneEquiv_symm_C] using hmapped
    exact hzero_rev.symm
  dsimp [P]
  rw [MvPolynomial.eval₂_const_uniqueAlgEquiv]
  have heval :
      MvPolynomial.eval₂ (algebraMap K (MvPolynomial (Fin 2) K ⧸ I))
          (fun _ : Fin 1 ↦ Ideal.Quotient.mk I
            (MvPolynomial.X (e.symm (1 : Fin 2)))) r =
        MvPolynomial.eval₂ (algebraMap K (MvPolynomial (Fin 2) K ⧸ I))
          (fun j : Fin 1 ↦ Ideal.Quotient.mk I
            (MvPolynomial.X (e.symm j.succ))) r := by
    congr 1
    funext j
    fin_cases j
    rfl
  rw [heval]
  calc
    _ = MvPolynomial.eval₂ (algebraMap K (MvPolynomial (Fin 2) K ⧸ I))
        ((fun i ↦ Ideal.Quotient.mk I (MvPolynomial.X i)) ∘
          (fun j : Fin 1 ↦ e.symm j.succ)) r := by rfl
    _ = MvPolynomial.eval₂ (algebraMap K (MvPolynomial (Fin 2) K ⧸ I))
        (fun i ↦ Ideal.Quotient.mk I (MvPolynomial.X i))
        (MvPolynomial.rename (fun j : Fin 1 ↦ e.symm j.succ) r) :=
      (MvPolynomial.eval₂_rename
        (algebraMap K (MvPolynomial (Fin 2) K ⧸ I))
        (fun j : Fin 1 ↦ e.symm j.succ)
        (fun i ↦ Ideal.Quotient.mk I (MvPolynomial.X i)) r).symm
    _ = Ideal.Quotient.mk I
        (MvPolynomial.rename (fun j : Fin 1 ↦ e.symm j.succ) r) :=
      quotient_mk_eq_eval₂ I _
    _ = 0 := hrzero

/-- The precise two-resultant hypothesis used for a two-variable affine intersection. -/
def HasNonzeroOrderedResultant
    (f g : MvPolynomial (Fin 2) K) (e : Fin 2 ≃ Fin 2) : Prop :=
  (((orderedAffinePlaneEquiv (K := K) e) f).natDegree ≠ 0 ∨
      ((orderedAffinePlaneEquiv (K := K) e) g).natDegree ≠ 0) ∧
    ((orderedAffinePlaneEquiv (K := K) e) f).resultant
      ((orderedAffinePlaneEquiv (K := K) e) g) ≠ 0

/-- Coprimality after viewing the two-variable polynomials as univariate polynomials over the
fraction field of the other coordinate.  This is the algebraic "no common component in this
coordinate order" hypothesis directly recognized by the polynomial resultant API. -/
def IsCoprimeOverFractionFieldInOrder
    (f g : MvPolynomial (Fin 2) K) (e : Fin 2 ≃ Fin 2) : Prop :=
  let R := MvPolynomial (Fin 1) K
  IsCoprime
    (((orderedAffinePlaneEquiv (K := K) e) f).map
      (algebraMap R (FractionRing R)))
    (((orderedAffinePlaneEquiv (K := K) e) g).map
      (algebraMap R (FractionRing R)))

/-- Coprimality over the coefficient fraction field implies nonvanishing of the ordered
resultant. -/
theorem hasNonzeroOrderedResultant_of_isCoprimeOverFractionField
    (f g : MvPolynomial (Fin 2) K) (e : Fin 2 ≃ Fin 2)
    (hdeg : ((orderedAffinePlaneEquiv (K := K) e) f).natDegree ≠ 0 ∨
      ((orderedAffinePlaneEquiv (K := K) e) g).natDegree ≠ 0)
    (hcop : IsCoprimeOverFractionFieldInOrder f g e) :
    HasNonzeroOrderedResultant f g e := by
  refine ⟨hdeg, ?_⟩
  let R := MvPolynomial (Fin 1) K
  let φ : R →+* FractionRing R := algebraMap R (FractionRing R)
  let f' := (orderedAffinePlaneEquiv (K := K) e) f
  let g' := (orderedAffinePlaneEquiv (K := K) e) g
  have hφ : Function.Injective φ :=
    IsFractionRing.injective R (FractionRing R)
  have hresmap : (f'.map φ).resultant (g'.map φ) ≠ 0 :=
    Polynomial.resultant_ne_zero _ _ hcop
  intro hres
  apply hresmap
  rw [show (f'.map φ).natDegree = f'.natDegree from
      Polynomial.natDegree_map_eq_of_injective hφ f',
    show (g'.map φ).natDegree = g'.natDegree from
      Polynomial.natDegree_map_eq_of_injective hφ g']
  rw [Polynomial.resultant_map_map, hres, map_zero]

/-- Nonzero resultants in both coordinate orders make the affine intersection Artinian.

This is an effective coprimality theorem: no appeal to a not-yet-formalized projective Bezout
statement remains after the two resultant nonvanishing certificates are supplied. -/
theorem affinePlaneIntersectionRing_isArtinian_of_orderedResultants
    (f g : MvPolynomial (Fin 2) K)
    (hid : HasNonzeroOrderedResultant f g (Equiv.refl (Fin 2)))
    (hswap : HasNonzeroOrderedResultant f g
      (Equiv.swap (0 : Fin 2) (1 : Fin 2))) :
    IsArtinianRing (affinePlaneIntersectionRing f g) := by
  apply quotient_isArtinian_of_coordinate_isIntegral
    (Ideal.span ({f, g} : Set (MvPolynomial (Fin 2) K)))
  intro i
  fin_cases i
  · obtain ⟨P, hP, hroot⟩ := exists_coordinateEliminant_of_orderedResultant f g
      (Equiv.swap (0 : Fin 2) (1 : Fin 2)) hswap.1 hswap.2
    exact IsAlgebraic.isIntegral ⟨P, hP, by
      rw [Polynomial.aeval_def]
      convert hroot using 1
      all_goals simp⟩
  · obtain ⟨P, hP, hroot⟩ := exists_coordinateEliminant_of_orderedResultant f g
      (Equiv.refl (Fin 2)) hid.1 hid.2
    exact IsAlgebraic.isIntegral ⟨P, hP, by
      rw [Polynomial.aeval_def]
      convert hroot using 1
      all_goals simp⟩

/-- Effective no-common-component criterion for an affine plane intersection.  If the two chart
equations have positive degree in each eliminated coordinate and are coprime over the opposite
coordinate's fraction field in both orders, then their quotient ring is Artinian. -/
theorem affinePlaneIntersectionRing_isArtinian_of_isCoprimeOverFractionField
    (f g : MvPolynomial (Fin 2) K)
    (hidDeg : ((orderedAffinePlaneEquiv (K := K) (Equiv.refl (Fin 2))) f).natDegree ≠ 0 ∨
      ((orderedAffinePlaneEquiv (K := K) (Equiv.refl (Fin 2))) g).natDegree ≠ 0)
    (hidCop : IsCoprimeOverFractionFieldInOrder f g (Equiv.refl (Fin 2)))
    (hswapDeg :
      ((orderedAffinePlaneEquiv (K := K)
        (Equiv.swap (0 : Fin 2) (1 : Fin 2))) f).natDegree ≠ 0 ∨
      ((orderedAffinePlaneEquiv (K := K)
        (Equiv.swap (0 : Fin 2) (1 : Fin 2))) g).natDegree ≠ 0)
    (hswapCop : IsCoprimeOverFractionFieldInOrder f g
      (Equiv.swap (0 : Fin 2) (1 : Fin 2))) :
    IsArtinianRing (affinePlaneIntersectionRing f g) :=
  affinePlaneIntersectionRing_isArtinian_of_orderedResultants f g
    (hasNonzeroOrderedResultant_of_isCoprimeOverFractionField
      f g (Equiv.refl (Fin 2)) hidDeg hidCop)
    (hasNonzeroOrderedResultant_of_isCoprimeOverFractionField
      f g (Equiv.swap (0 : Fin 2) (1 : Fin 2)) hswapDeg hswapCop)

/-! ## Gluing affine intersection charts -/

/-- A scheme covered by spectra of affine two-curve intersection rings is locally Artinian once
each chart has coordinate eliminants.

For a projective intersection of two homogeneous plane curves, the intended cover has three
members, obtained by setting one homogeneous coordinate equal to one. -/
theorem isLocallyArtinian_of_affinePlaneIntersectionCover
    (X : Scheme.{u}) (𝒰 : X.OpenCover)
    (f g : 𝒰.I₀ → MvPolynomial (Fin 2) K)
    (e : ∀ i, 𝒰.X i ≅ Spec (.of (affinePlaneIntersectionRing (f i) (g i))))
    (helim : ∀ i, HasAffinePlaneCoordinateEliminants (f i) (g i)) :
    IsLocallyArtinian X := by
  rw [isLocallyArtinian_iff_openCover 𝒰]
  intro i
  letI : IsArtinianRing (affinePlaneIntersectionRing (f i) (g i)) :=
    affinePlaneIntersectionRing_isArtinian_of_coordinateEliminants
      (f i) (g i) (helim i)
  letI : IsLocallyArtinian
      (Spec (.of (affinePlaneIntersectionRing (f i) (g i)))) :=
    Scheme.isLocallyArtinianScheme_Spec.mpr inferInstance
  exact IsLocallyArtinian.of_isImmersion (e i).hom

/-- Coprimality form of `isLocallyArtinian_of_affinePlaneIntersectionCover`.  Each member of the
cover is an affine two-curve intersection, and the two equations are coprime over the opposite
coordinate's fraction field in both coordinate orders. -/
theorem isLocallyArtinian_of_affinePlaneIntersectionCover_of_isCoprimeOverFractionField
    (X : Scheme.{u}) (𝒰 : X.OpenCover)
    (f g : 𝒰.I₀ → MvPolynomial (Fin 2) K)
    (e : ∀ i, 𝒰.X i ≅ Spec (.of (affinePlaneIntersectionRing (f i) (g i))))
    (hidDeg : ∀ i,
      ((orderedAffinePlaneEquiv (K := K) (Equiv.refl (Fin 2))) (f i)).natDegree ≠ 0 ∨
      ((orderedAffinePlaneEquiv (K := K) (Equiv.refl (Fin 2))) (g i)).natDegree ≠ 0)
    (hidCop : ∀ i,
      IsCoprimeOverFractionFieldInOrder (f i) (g i) (Equiv.refl (Fin 2)))
    (hswapDeg : ∀ i,
      ((orderedAffinePlaneEquiv (K := K)
        (Equiv.swap (0 : Fin 2) (1 : Fin 2))) (f i)).natDegree ≠ 0 ∨
      ((orderedAffinePlaneEquiv (K := K)
        (Equiv.swap (0 : Fin 2) (1 : Fin 2))) (g i)).natDegree ≠ 0)
    (hswapCop : ∀ i,
      IsCoprimeOverFractionFieldInOrder (f i) (g i)
        (Equiv.swap (0 : Fin 2) (1 : Fin 2))) :
    IsLocallyArtinian X := by
  rw [isLocallyArtinian_iff_openCover 𝒰]
  intro i
  letI : IsArtinianRing (affinePlaneIntersectionRing (f i) (g i)) :=
    affinePlaneIntersectionRing_isArtinian_of_isCoprimeOverFractionField
      (f i) (g i) (hidDeg i) (hidCop i) (hswapDeg i) (hswapCop i)
  letI : IsLocallyArtinian
      (Spec (.of (affinePlaneIntersectionRing (f i) (g i)))) :=
    Scheme.isLocallyArtinianScheme_Spec.mpr inferInstance
  exact IsLocallyArtinian.of_isImmersion (e i).hom

/-! ## From finite point fibres to Artinian scheme fibres -/

/-- A finite underlying point fibre of a locally finite type morphism has locally Artinian
scheme-theoretic fibre.  The proof uses the canonical homeomorphism from the scheme fibre to the
set-theoretic preimage, then Mathlib's finite-fibre criterion for local quasi-finiteness. -/
theorem fiber_isLocallyArtinian_of_finite_preimage
    {X Y : Scheme.{u}} (p : X ⟶ Y) (y : Y) [LocallyOfFiniteType p]
    (hfinite : (p ⁻¹' {y}).Finite) :
    IsLocallyArtinian (p.fiber y) := by
  letI : Fintype (p ⁻¹' {y}) := hfinite.fintype
  letI : Finite (p.fiber y) :=
    Finite.of_injective (p.fiberHomeo y) (p.fiberHomeo y).injective
  letI : LocallyOfFiniteType (p.fiberToSpecResidueField y) :=
    MorphismProperty.pullback_snd _ _ inferInstance
  letI : LocallyQuasiFinite (p.fiberToSpecResidueField y) :=
    LocallyQuasiFinite.of_finite_preimage_singleton _
      (fun _ ↦ Set.toFinite _)
  exact IsLocallyArtinian.of_locallyQuasiFinite
    (p.fiberToSpecResidueField y)

/-- Typeclass form of the finite-fibre criterion, phrased using the project's
`schemePointFiber`. -/
theorem fiber_isLocallyArtinian_of_finite_schemePointFiber
    {X Y : Scheme.{u}} (p : X ⟶ Y) (y : Y) [LocallyOfFiniteType p]
    [Finite (schemePointFiber p y)] :
    IsLocallyArtinian (p.fiber y) := by
  let ι : p.fiber y → schemePointFiber p y := fun z ↦
    ⟨p.fiberι y z, by
      have h := congrArg (fun q : p.fiber y ⟶ Y ↦ q z) (p.fiber_fac y)
      simpa [Scheme.Hom.comp_apply] using h⟩
  letI : Finite (p.fiber y) :=
    Finite.of_injective ι (fun a b hab ↦
      (p.fiberι y).isEmbedding.injective (congrArg Subtype.val hab))
  letI : LocallyOfFiniteType (p.fiberToSpecResidueField y) :=
    MorphismProperty.pullback_snd _ _ inferInstance
  letI : LocallyQuasiFinite (p.fiberToSpecResidueField y) :=
    LocallyQuasiFinite.of_finite_preimage_singleton _
      (fun _ ↦ Set.toFinite _)
  exact IsLocallyArtinian.of_locallyQuasiFinite
    (p.fiberToSpecResidueField y)

/-- Target-relation specialization of `fiber_isLocallyArtinian_of_finite_schemePointFiber`.
Thus a finite projective intersection at the generic point is already enough to supply the
`IsLocallyArtinian` hypothesis used by the exhaustion argument. -/
theorem targetRelation_genericFiber_isLocallyArtinian_of_finite_pointFiber
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) K)
    (H : MvPolynomial (Fin 3) K)
    [Finite
      (schemePointFiber (targetRelationToFirst F H)
        (genericPoint (ProjectiveSpace 2 K)))] :
    IsLocallyArtinian
      ((targetRelationToFirst F H).fiber
        (genericPoint (ProjectiveSpace 2 K))) := by
  letI : LocallyOfFiniteType (targetRelationToFirst F H) := by
    change LocallyOfFiniteType
      (targetRelationι F H ≫ BiprojectiveSpace.fst 2 2 K)
    infer_instance
  exact fiber_isLocallyArtinian_of_finite_schemePointFiber
    (targetRelationToFirst F H) (genericPoint (ProjectiveSpace 2 K))

end

end PlaneCurveIntersectionArtinian
end BConicBundleMultisections
