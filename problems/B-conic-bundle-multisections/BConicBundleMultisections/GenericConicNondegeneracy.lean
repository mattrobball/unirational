/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import BConicBundleMultisections.GoodLineCondition
public import BConicBundleMultisections.GenericConicBaseChange
public import BConicBundleMultisections.HomogeneousJacobianChart
public import BConicBundleMultisections.PointedConicAffineModel
public import BConicBundleMultisections.PointedConicChartBaseChange
public import BConicBundleMultisections.ProjectiveSpaceChartDominance
public import Mathlib.RingTheory.TensorProduct.MvPolynomial

/-!
# Nondegeneracy of the generic conic without generic smoothness

This file packages the bidegree-`(2,3)` substitute for scheme-theoretic generic smoothness used by
the pointed-conic construction.  On the standard chart `Y₀ ≠ 0`, the universal fibre is a ternary
quadratic over `k[Y₁/Y₀,Y₂/Y₀]`.  Restricting it to `Y₂ = 0` gives exactly the coordinate-line
quadratic of `GoodLineCondition`; hence smoothness of the total biprojective hypersurface makes its
polar determinant nonzero.  A dominant map from the standard chart carries that determinant
injectively to the function field of the residual component, so the marked point of the generic
affine conic has nonzero gradient.
-/

@[expose] public section

open CategoryTheory
open scoped AlgebraicGeometry Matrix TensorProduct

namespace BConicBundleMultisections

noncomputable section

universe u

open AlgebraicGeometry MvPolynomial BiprojectiveSpace

attribute [local instance] MvPolynomial.gradedAlgebra

/-- The universal ternary conic over the standard base chart `Y₀ ≠ 0`. -/
def genericSndConicChartZero
    {k : Type u} [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) :
    MvPolynomial (Fin 3) (ProjectiveSpace.StandardChartRing 2 k 0) :=
  specializeSecondCoordinates
    (fun l => ProjectiveSpace.normalizedCoordinate 2 k 0 l)
    (MvPolynomial.map (algebraMap k (ProjectiveSpace.StandardChartRing 2 k 0)) F)

/-- Evaluate the standard base chart on the coordinate line `[1:t:0]`. -/
def coordinateLineChartEval
    {k : Type u} [Field k] :
    ProjectiveSpace.StandardChartRing 2 k 0 →ₐ[k] Polynomial k :=
  (MvPolynomial.aeval ![Polynomial.X, 0]).comp
    (ProjectiveSpace.standardChartRingEquivMvPolynomial 2 k 0).toAlgHom

@[simp]
theorem coordinateLineChartEval_normalizedCoordinate
    {k : Type u} [Field k] (l : Fin 3) :
    coordinateLineChartEval
        (ProjectiveSpace.normalizedCoordinate 2 k 0 l) =
      coordinateLinePoint (Polynomial k) Polynomial.X l := by
  rcases Fin.eq_self_or_eq_succAbove (0 : Fin 3) l with h | ⟨r, h⟩
  · subst h
    simp [coordinateLineChartEval, coordinateLinePoint]
  · subst h
    unfold coordinateLineChartEval
    rw [AlgHom.comp_apply]
    change MvPolynomial.aeval ![Polynomial.X, 0]
      ((ProjectiveSpace.standardChartRingEquivMvPolynomial 2 k 0)
        (ProjectiveSpace.normalizedCoordinate 2 k 0 ((0 : Fin 3).succAbove r))) = _
    rw [ProjectiveSpace.standardChartRingEquivMvPolynomial_normalizedCoordinate_succAbove]
    fin_cases r <;> simp [coordinateLinePoint]

/-- Restricting the universal chart conic to `Y₂ = 0` recovers the coordinate-line conic. -/
theorem map_genericSndConicChartZero_coordinateLine
    {k : Type u} [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) :
    MvPolynomial.map coordinateLineChartEval.toRingHom (genericSndConicChartZero F) =
      coordinateLineSpecializedConicPoly F := by
  rw [genericSndConicChartZero, coordinateLineSpecializedConicPoly,
    map_specializeSecondCoordinates, MvPolynomial.map_map]
  have hcoeff : coordinateLineChartEval.toRingHom.comp
      (algebraMap k (ProjectiveSpace.StandardChartRing 2 k 0)) = Polynomial.C := by
    ext a
    simp [coordinateLineChartEval]
  rw [hcoeff]
  have hcoords :
      (fun l => coordinateLineChartEval.toRingHom
        (ProjectiveSpace.normalizedCoordinate 2 k 0 l)) =
        coordinateLinePoint (Polynomial k) Polynomial.X := by
    funext l
    exact coordinateLineChartEval_normalizedCoordinate l
  rw [hcoords]

/-- The universal chart conic has nonzero polar determinant. -/
theorem det_polarMatrix_genericSndConicChartZero_ne_zero_of_smooth
    {k : Type u} [Field k] [IsAlgClosed k] [CharZero k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (biprojectiveZeroLocusToSpec 2 2 k F)] :
    (polarMatrix (genericSndConicChartZero F)).det ≠ 0 := by
  intro hdet
  have hmapQ := map_genericSndConicChartZero_coordinateLine F
  have hmapM :
      polarMatrix (coordinateLineSpecializedConicPoly F) =
        (polarMatrix (genericSndConicChartZero F)).map coordinateLineChartEval.toRingHom := by
    rw [← hmapQ]
    apply Matrix.ext
    intro a b
    simp only [polarMatrix_apply, Matrix.map_apply]
    have hsingle (c : Fin 3) :
        (fun d : Fin 3 => coordinateLineChartEval
          ((Pi.single c (1 : ProjectiveSpace.StandardChartRing 2 k 0) :
            Fin 3 → ProjectiveSpace.StandardChartRing 2 k 0) d)) =
          (Pi.single c (1 : Polynomial k) : Fin 3 → Polynomial k) := by
      funext d
      by_cases hdc : d = c
      · subst hdc; simp [Pi.single_eq_same]
      · simp [Pi.single_eq_of_ne hdc]
    have h := polarEval_map coordinateLineChartEval.toRingHom
      (genericSndConicChartZero F)
      (Pi.single a 1) (Pi.single b 1)
    rw [← hsingle a, ← hsingle b]
    exact h
  apply coordinateLineConicDiscriminant_ne_zero_of_smooth F hF hF0
  rw [coordinateLineConicDiscriminant, hmapM]
  have hmatrix :
      (polarMatrix (genericSndConicChartZero F)).map coordinateLineChartEval.toRingHom =
        coordinateLineChartEval.toRingHom.mapMatrix
          (polarMatrix (genericSndConicChartZero F)) := by
    rfl
  rw [hmatrix, ← RingHom.map_det, hdet, map_zero]

/-- Dominant base-chart maps preserve nondegeneracy of the generic conic. -/
theorem det_polarMatrix_map_genericSndConicChartZero_ne_zero
    {k A : Type u} [Field k] [CommRing A] [IsDomain A] [Algebra k A]
    [IsAlgClosed k] [CharZero k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (biprojectiveZeroLocusToSpec 2 2 k F)]
    (y : ProjectiveSpace.StandardChartRing 2 k 0 →ₐ[k] A)
    [IsDominant (Spec.map (CommRingCat.ofHom y.toRingHom))] :
    (polarMatrix (MvPolynomial.map y.toRingHom (genericSndConicChartZero F))).det ≠ 0 := by
  have hd : DenseRange (PrimeSpectrum.comap y.toRingHom) :=
    IsDominant.denseRange (f := Spec.map (CommRingCat.ofHom y.toRingHom))
  have hker : RingHom.ker y.toRingHom ≤
      _root_.nilradical (ProjectiveSpace.StandardChartRing 2 k 0) :=
    (PrimeSpectrum.denseRange_comap_iff_ker_le_nilRadical y.toRingHom).mp hd
  rw [nilradical_eq_zero] at hker
  have hy : Function.Injective y.toRingHom :=
    (RingHom.injective_iff_ker_eq_bot y.toRingHom).mpr (le_antisymm hker bot_le)
  have hmapM :
      polarMatrix (MvPolynomial.map y.toRingHom (genericSndConicChartZero F)) =
        (polarMatrix (genericSndConicChartZero F)).map y.toRingHom := by
    apply Matrix.ext
    intro a b
    simp only [polarMatrix_apply, Matrix.map_apply]
    have hsingle (c : Fin 3) :
        (fun d : Fin 3 => y
          ((Pi.single c (1 : ProjectiveSpace.StandardChartRing 2 k 0) :
            Fin 3 → ProjectiveSpace.StandardChartRing 2 k 0) d)) =
          (Pi.single c (1 : A) : Fin 3 → A) := by
      funext d
      by_cases hdc : d = c
      · subst hdc; simp [Pi.single_eq_same]
      · simp [Pi.single_eq_of_ne hdc]
    have h := polarEval_map y.toRingHom (genericSndConicChartZero F)
      (Pi.single a 1) (Pi.single b 1)
    rw [← hsingle a, ← hsingle b]
    exact h
  rw [hmapM]
  have hmatrix :
      (polarMatrix (genericSndConicChartZero F)).map y.toRingHom =
        y.toRingHom.mapMatrix (polarMatrix (genericSndConicChartZero F)) := by
    rfl
  rw [hmatrix, ← RingHom.map_det]
  intro hz
  apply det_polarMatrix_genericSndConicChartZero_ne_zero_of_smooth F hF hF0
  exact hy (by simpa using hz)

/-! ### Comparison with the affine chart equation -/

/-- Mapping the universal conic along a base-chart point is the usual specialized fibre
quadratic. -/
theorem map_genericSndConicChartZero
    {k K : Type u} [Field k] [CommRing K] [Algebra k K]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (y : ProjectiveSpace.StandardChartRing 2 k 0 →ₐ[k] K) :
    MvPolynomial.map y.toRingHom (genericSndConicChartZero F) =
      specializeSecondCoordinates (secondNormalizedCoordinates y)
        (MvPolynomial.map (algebraMap k K) F) := by
  rw [genericSndConicChartZero, map_specializeSecondCoordinates, MvPolynomial.map_map]
  have hcoeff : y.toRingHom.comp
      (algebraMap k (ProjectiveSpace.StandardChartRing 2 k 0)) = algebraMap k K := by
    ext a
    exact y.commutes a
  rw [hcoeff]
  rfl

/-- The base-changed affine equation is the dehomogenization of the mapped universal ternary
conic. -/
theorem baseChangedChartEquation_eq_chartDehomogenization_generic
    {k K : Type u} [Field k] [CommRing K] [Algebra k K]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (i : Fin 3) (y : ProjectiveSpace.StandardChartRing 2 k 0 →ₐ[k] K) :
    baseChangedChartEquation (i := i) (j := 0) y F =
      ProjectiveSpace.chartDehomogenization 2 K i
        (MvPolynomial.map y.toRingHom (genericSndConicChartZero F)) := by
  let Q : MvPolynomial (Fin 3) K :=
    specializeSecondCoordinates (secondNormalizedCoordinates y)
      (MvPolynomial.map (algebraMap k K) F)
  change tensorStandardChartEquivMvPolynomial 2 k K i
      (sndFiberChartMap (i := i) y (chartEquation 2 2 k i 0 F)) =
    ProjectiveSpace.chartDehomogenization 2 K i
      (MvPolynomial.map y.toRingHom (genericSndConicChartZero F))
  have hmap := sndFiberChartMap_chartEquation (i := i) y F
  rw [hmap]
  let φ : Fin 3 → K ⊗[k] ProjectiveSpace.StandardChartRing 2 k i := fun l =>
    Algebra.TensorProduct.includeRight
      (R := k) (A := K) (B := ProjectiveSpace.StandardChartRing 2 k i)
      (ProjectiveSpace.normalizedCoordinate 2 k i l)
  have hX (l : Fin 3) :
      tensorStandardChartEquivMvPolynomial 2 k K i (φ l) =
        ProjectiveSpace.chartDehomogenization 2 K i (MvPolynomial.X l) := by
    dsimp [φ]
    by_cases hl : l = i
    · rw [hl, ProjectiveSpace.normalizedCoordinate_self,
        ProjectiveSpace.chartDehomogenization_X_self]
      have h1 : ((1 : K) ⊗ₜ[k] (1 : ProjectiveSpace.StandardChartRing 2 k i)) =
          algebraMap K (K ⊗[k] ProjectiveSpace.StandardChartRing 2 k i) 1 := by
        rw [Algebra.TensorProduct.algebraMap_apply]
        simp
      rw [h1, AlgEquiv.commutes, map_one]
    · obtain ⟨r, hr⟩ := Fin.exists_succAbove_eq hl
      rw [← hr, ProjectiveSpace.chartDehomogenization_X_succAbove]
      change (MvPolynomial.algebraTensorAlgEquiv k K)
          ((Algebra.TensorProduct.congr (AlgEquiv.refl (R := k) (A₁ := K))
            (ProjectiveSpace.standardChartRingEquivMvPolynomial 2 k i))
            ((1 : K) ⊗ₜ[k]
              ProjectiveSpace.normalizedCoordinate 2 k i (i.succAbove r))) = MvPolynomial.X r
      rw [Algebra.TensorProduct.congr_apply, Algebra.TensorProduct.map_tmul]
      convert MvPolynomial.algebraTensorAlgEquiv_tmul (R := k) (A := K) (1 : K)
        (ProjectiveSpace.standardChartRingEquivMvPolynomial 2 k i
          (ProjectiveSpace.normalizedCoordinate 2 k i (i.succAbove r))) using 2
      · simp
      · rw [ProjectiveSpace.standardChartRingEquivMvPolynomial_normalizedCoordinate_succAbove]
        simp [MvPolynomial.map_X, one_smul]
  have hagree :
      (tensorStandardChartEquivMvPolynomial 2 k K i).toAlgHom.comp
          (MvPolynomial.aeval φ) =
        ProjectiveSpace.chartDehomogenization 2 K i := by
    refine MvPolynomial.algHom_ext fun l => ?_
    simp only [AlgHom.comp_apply, MvPolynomial.aeval_X]
    exact hX l
  have hφ : (fun l =>
      Algebra.TensorProduct.includeRight
        (R := k) (A := K) (B := ProjectiveSpace.StandardChartRing 2 k i)
        (ProjectiveSpace.normalizedCoordinate 2 k i l)) = φ := rfl
  rw [hφ, ← map_genericSndConicChartZero F y]
  exact congrArg
    (fun ψ : MvPolynomial (Fin 3) K →ₐ[K] MvPolynomial (Fin 2) K =>
      ψ (MvPolynomial.map y.toRingHom (genericSndConicChartZero F))) hagree

/-! ### The marked generic point has nonzero affine gradient -/

/-- A nondegenerate polar matrix makes every projective zero of a ternary quadratic
Jacobian-nonsingular. -/
theorem exists_eval_pderiv_ne_zero_of_det_polarMatrix_ne_zero
    {K : Type u} [Field K]
    (Q : MvPolynomial (Fin 3) K) (hQ : Q.IsHomogeneous 2)
    (hdet : (polarMatrix Q).det ≠ 0)
    (v : Fin 3 → K) (hv0 : v ≠ 0) :
    ∃ a : Fin 3, MvPolynomial.eval v (MvPolynomial.pderiv a Q) ≠ 0 := by
  by_contra h
  push Not at h
  apply hdet
  apply det_polarMatrix_eq_zero_of_polarEval_eq_zero hQ hv0
  intro a
  rw [← eval_pderiv_eq_polarEval_single hQ]
  exact h a

/-- At a rational point of the generic affine conic, the two affine partials cannot both vanish.
This is the exact replacement for the old appeal to a smooth dense open. -/
theorem slopeLin_baseChangedChartEquation_ne_zero_of_smooth
    {k A : Type u} [Field k] [CommRing A] [IsDomain A] [Algebra k A]
    [IsAlgClosed k] [CharZero k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (biprojectiveZeroLocusToSpec 2 2 k F)]
    (i : Fin 3) (y : ProjectiveSpace.StandardChartRing 2 k 0 →ₐ[k] A)
    [IsDominant (Spec.map (CommRingCat.ofHom y.toRingHom))]
    (p₁ p₂ : A)
    (hp : MvPolynomial.eval ![p₁, p₂]
      (baseChangedChartEquation (i := i) (j := 0) y F) = 0) :
    PointedConic.slopeLin
      (MvPolynomial.eval ![p₁, p₂]
        (MvPolynomial.pderiv 0 (baseChangedChartEquation (i := i) (j := 0) y F)))
      (MvPolynomial.eval ![p₁, p₂]
        (MvPolynomial.pderiv 1 (baseChangedChartEquation (i := i) (j := 0) y F))) ≠ 0 := by
  classical
  let K := FractionRing A
  let ι : A →+* K := algebraMap A K
  let yK : ProjectiveSpace.StandardChartRing 2 k 0 →ₐ[k] K :=
    (IsScalarTower.toAlgHom k A K).comp y
  let Q : MvPolynomial (Fin 3) K :=
    MvPolynomial.map yK.toRingHom (genericSndConicChartZero F)
  let g : MvPolynomial (Fin 2) A := baseChangedChartEquation (i := i) (j := 0) y F
  let gK : MvPolynomial (Fin 2) K := MvPolynomial.map ι g
  let pK : Fin 2 → K := ![ι p₁, ι p₂]
  let v : Fin 3 → K := Fin.insertNth (α := fun _ => K) i 1 pK
  have hQhom : Q.IsHomogeneous 2 := by
    rw [show Q = specializeSecondCoordinates (secondNormalizedCoordinates yK)
      (MvPolynomial.map (algebraMap k K) F) from map_genericSndConicChartZero F yK]
    exact (hF.map_coefficients (algebraMap k K)).specializeSecondCoordinates_isHomogeneous
      (secondNormalizedCoordinates yK)
  have hQdef : Q = MvPolynomial.map ι
      (MvPolynomial.map y.toRingHom (genericSndConicChartZero F)) := by
    dsimp only [Q, yK]
    rw [MvPolynomial.map_map]
    congr 1
  have hdetA := det_polarMatrix_map_genericSndConicChartZero_ne_zero
    F hF hF0 y
  have hdet : (polarMatrix Q).det ≠ 0 := by
    rw [hQdef]
    have hmapM :
        polarMatrix (MvPolynomial.map ι
            (MvPolynomial.map y.toRingHom (genericSndConicChartZero F))) =
          (polarMatrix
            (MvPolynomial.map y.toRingHom (genericSndConicChartZero F))).map ι := by
      apply Matrix.ext
      intro a b
      simp only [polarMatrix_apply, Matrix.map_apply]
      have hsingle (c : Fin 3) :
          (fun d : Fin 3 => ι
            ((Pi.single c (1 : A) : Fin 3 → A) d)) =
            (Pi.single c (1 : K) : Fin 3 → K) := by
        funext d
        by_cases hdc : d = c
        · subst hdc; simp [Pi.single_eq_same]
        · simp [Pi.single_eq_of_ne hdc]
      have h := polarEval_map ι
        (MvPolynomial.map y.toRingHom (genericSndConicChartZero F))
        (Pi.single a 1) (Pi.single b 1)
      rw [← hsingle a, ← hsingle b]
      exact h
    rw [hmapM]
    have hmatrix :
        (polarMatrix
          (MvPolynomial.map y.toRingHom (genericSndConicChartZero F))).map ι =
          ι.mapMatrix
            (polarMatrix
              (MvPolynomial.map y.toRingHom (genericSndConicChartZero F))) := by
      rfl
    rw [hmatrix, ← RingHom.map_det]
    intro hz
    have hz' : ι
        (polarMatrix
          (MvPolynomial.map y.toRingHom (genericSndConicChartZero F))).det = ι 0 := by
      simpa using hz
    exact hdetA (IsFractionRing.injective A K hz')
  have hvself : v i = 1 := by
    dsimp only [v]
    exact Fin.insertNth_apply_same (α := fun _ => K) i 1 pK
  have hv0 : v ≠ 0 := by
    intro hz
    have := congrFun hz i
    simp [hvself] at this
  have haff : affineCoords v i (by simpa [hvself]) = pK := by
    funext r
    simp [affineCoords, v, hvself]
  have hgK : gK = ProjectiveSpace.chartDehomogenization 2 K i Q := by
    have hbaseA := baseChangedChartEquation_eq_chartDehomogenization_generic F i y
    dsimp only [gK, g]
    rw [hbaseA, hQdef]
    exact (chartDehomogenization_map i
      (MvPolynomial.map y.toRingHom (genericSndConicChartZero F))).symm
  have hpK : MvPolynomial.eval pK gK = 0 := by
    have hpmap : (fun x => ι (x)) ∘ ![p₁, p₂] = pK := by
      funext r
      fin_cases r <;> rfl
    calc
      MvPolynomial.eval pK gK =
          MvPolynomial.eval (ι ∘ ![p₁, p₂]) (MvPolynomial.map ι g) := by
            rw [hpmap]
      _ = MvPolynomial.eval₂ ι (ι ∘ ![p₁, p₂]) g := by rw [MvPolynomial.eval_map]
      _ = ι (MvPolynomial.eval ![p₁, p₂] g) :=
        (MvPolynomial.eval₂_comp ι ![p₁, p₂] g).symm
      _ = 0 := by simpa [g] using congrArg ι hp
  have hQv : MvPolynomial.eval v Q = 0 := by
    have hchart := eval_chartDehomogenization Q v i (by simpa [hvself])
    rw [← hgK, haff, hpK] at hchart
    simpa [hvself] using hchart.symm
  obtain ⟨a, ha⟩ := exists_eval_pderiv_ne_zero_of_det_polarMatrix_ne_zero
    Q hQhom hdet v hv0
  intro hlin
  obtain ⟨hzero, hone⟩ := (PointedConic.slopeLin_eq_zero_iff _ _).mp hlin
  have hfree (r : Fin 2) : MvPolynomial.eval v (MvPolynomial.pderiv (i.succAbove r) Q) = 0 := by
    have hrel := eval_pderiv_chartDehomogenization Q hQhom v i (by simpa [hvself]) r
    rw [haff, ← hgK] at hrel
    have hmapDeriv : MvPolynomial.pderiv r gK =
        MvPolynomial.map ι (MvPolynomial.pderiv r g) := MvPolynomial.pderiv_map
    have hz : MvPolynomial.eval pK (MvPolynomial.pderiv r gK) = 0 := by
      rw [hmapDeriv, MvPolynomial.eval_map]
      have hpmap : (ι ∘ ![p₁, p₂]) = pK := by
        funext q
        fin_cases q <;> rfl
      rw [← hpmap, ← MvPolynomial.eval₂_comp]
      fin_cases r
      · simpa [g] using congrArg ι hzero
      · simpa [g] using congrArg ι hone
    rw [hz] at hrel
    simpa [hvself] using hrel.symm
  have hself : MvPolynomial.eval v (MvPolynomial.pderiv i Q) = 0 := by
    have hEuler := congrArg (MvPolynomial.eval v) hQhom.sum_X_mul_pderiv
    simp only [map_sum, map_mul, MvPolynomial.eval_X, nsmul_eq_mul] at hEuler
    have hsumfree : ∑ r : Fin 2,
        v (i.succAbove r) * MvPolynomial.eval v (MvPolynomial.pderiv (i.succAbove r) Q) = 0 :=
      Finset.sum_eq_zero fun r _ => by rw [hfree r, mul_zero]
    have hsplit := Fin.sum_univ_succAbove
      (fun a => v a * MvPolynomial.eval v (MvPolynomial.pderiv a Q)) i
    rw [hQv, mul_zero, hsplit, hsumfree, add_zero, hvself, one_mul] at hEuler
    exact hEuler
  rcases Fin.eq_self_or_eq_succAbove i a with rfl | ⟨r, rfl⟩
  · exact ha hself
  · exact ha (hfree r)

end

end BConicBundleMultisections
