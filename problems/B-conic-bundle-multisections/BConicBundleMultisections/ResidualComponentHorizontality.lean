/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import BConicBundleMultisections.AlgebraicIndependenceJacobian
public import BConicBundleMultisections.JacobianCriterionCharFree
public import BConicBundleMultisections.PlaneCubicResidualTransport
public import BConicBundleMultisections.ProjectiveSpaceAlgebraPoint
public import BConicBundleMultisections.ProjectiveSpaceChartDominance
public import BConicBundleMultisections.ResidualComponent
public import BConicBundleMultisections.ResidualHorizontalityLine
public import BConicBundleMultisections.ResidualYFormVanishing

/-!
# Obligation 2: the residual surface is not contained in a fibre

One of the four outstanding obligations of the unirationality proof; see
`ResidualComponentAssembly.lean` for the inventory and `PLAN.md` WP-B for the work package.

Everything downstream of this obligation is proved: `isDominant_residualComponentToBase_iff`
turns it into horizontality of the residual component, and
`isDominant_residualComponentMultisection_baseChangeFst` turns that into dominance of
`baseChangeFst`, which is what the multisection principle consumes.

## State of the reduction

The obligation is now assembled from exactly two statements, both isolated below:

* `ProjectiveSpace.isDominant_standardChartι` — the standard chart is a dense open of `ℙ²_k`.
  Topology plumbing; belongs to the `ℙⁿ` chart-cover work package, not to this one.
* `eq_zero_of_aeval_residualYCoords_of_isHomogeneous` — **the content**: no nonzero form in the
  three `Y`-variables vanishes on the residual `Y`-coordinates in `k[t,s]`.  This is now **proved**
  from a single determinant leaf `det_residualYCoords_ne_zero` by the Jacobian criterion
  `AlgebraicIndependenceJacobian.eq_zero_of_isHomogeneous_of_aeval_eq_zero`.

Everything between them is proved: `ChartHomogenization` turns "no nonzero form vanishes" into
injectivity of `aeval` at the affine coordinate ratios, and `ResidualYFormVanishing` transports
that across the chart normalization and the Away localization.

## Choice of line (rewired)

The source proves horizontality for a **chosen** good line `L` (G3 + polar).  This module's
coordinate-line statements now take those hypotheses explicitly; the false unconditional form of
`det_residualYCoords_ne_zero` is retired.  Polar nondegeneracy on the coordinate frame is the same
form as `StereoNondegenerate` (`lineStereoPolarForm_coordinate`).  Global G3 for the hardcoded
coordinate line of every smooth `F` is still not true — assembly obtains it from a packaging leaf
(`exists_residualChart_of_smooth`) that records the remaining good-line / linear `y`-change step.
The mathematical §4 content is `ResidualHorizontalityLine.det_residualYCoordsOn_ne_zero`.
-/

@[expose] public section

open CategoryTheory
open scoped AlgebraicGeometry

namespace BConicBundleMultisections

noncomputable section

universe u

open AlgebraicGeometry MvPolynomial BiprojectiveSpace ProjectiveSpace ResidualDivisor

attribute [local instance] MvPolynomial.gradedAlgebra
open _root_.MvPolynomial

/-! ### Bridging lemmas: the composite in coordinates

Both are exact algebra-valued analogues of proved statements, and both are mechanical.  They are
the last thing standing between obligation 2 and the concrete injectivity core.
-/

/--
**Bridging lemma (mechanical).**  The algebra-valued biprojective chart evaluation restricts along
the right tensor factor to the algebra-valued projective chart evaluation.

Analogue of `biprojectiveChartEval_comp_includeRight`
(`BiprojectiveZeroLocusClosedPoints.lean:327`).  That proof reduces to
`biprojectiveChartEval_tmul_mvPolynomialToStandardChart` (`:259`), which is **`private`**, so the
algebra version cannot reuse it — it needs its own induction on the polynomial, mirroring the
original.  No mathematics, but not a one-liner. -/
theorem biprojectiveChartEvalAlgebra_comp_includeRight
    {R S : Type u} [CommRing R] [CommRing S] [Algebra R S]
    (m n : ℕ) (i : Fin (m + 1)) (j : Fin (n + 1))
    (x : Fin (m + 1) → S) (y : Fin (n + 1) → S) :
    (biprojectiveChartEvalAlgebra (R := R) m n i j x y).comp
        (Algebra.TensorProduct.includeRight
          (R := R)
          (A := ProjectiveSpace.StandardChartRing m R i)
          (B := ProjectiveSpace.StandardChartRing n R j)).toRingHom =
      ProjectiveSpace.standardChartEvalAlgebra (R := R) n j y := by
  have hX : ∀ r : Fin n,
      (ProjectiveSpace.standardChartRingEquivMvPolynomial n R j).symm (MvPolynomial.X r)
        = ProjectiveSpace.normalizedCoordinate n R j (j.succAbove r) := by
    intro r
    rw [AlgEquiv.symm_apply_eq]
    exact (ProjectiveSpace.standardChartRingEquivMvPolynomial_normalizedCoordinate_succAbove
      n R j r).symm
  have key : ∀ p : MvPolynomial (Fin n) R,
      biprojectiveChartEvalAlgebra (R := R) m n i j x y
          (1 ⊗ₜ[R] (ProjectiveSpace.standardChartRingEquivMvPolynomial n R j).symm p)
        = ProjectiveSpace.standardChartEvalAlgebra (R := R) n j y
            ((ProjectiveSpace.standardChartRingEquivMvPolynomial n R j).symm p) := by
    intro p
    induction p using MvPolynomial.induction_on with
    | C a =>
        have h1 : (ProjectiveSpace.standardChartRingEquivMvPolynomial n R j).symm
            (MvPolynomial.C a) = algebraMap R (ProjectiveSpace.StandardChartRing n R j) a := by
          rw [AlgEquiv.symm_apply_eq]; simp
        have h2 : (1 : ProjectiveSpace.StandardChartRing m R i) ⊗ₜ[R]
            algebraMap R (ProjectiveSpace.StandardChartRing n R j) a
            = algebraMap R (BiprojectiveSpace.StandardChartRing m n R i j) a :=
          AlgHom.commutes (Algebra.TensorProduct.includeRight
            (R := R) (A := ProjectiveSpace.StandardChartRing m R i)
            (B := ProjectiveSpace.StandardChartRing n R j)) a
        rw [h1, h2]
        have hL : biprojectiveChartEvalAlgebra (R := R) m n i j x y
            (algebraMap R (BiprojectiveSpace.StandardChartRing m n R i j) a)
              = algebraMap R S a :=
          DFunLike.congr_fun
            (biprojectiveChartEvalAlgebra_comp_algebraMap (R := R) m n i j x y) a
        rw [hL]
        simp [ProjectiveSpace.standardChartEvalAlgebra, MvPolynomial.algebraMap_eq]
    | add p q hp hq =>
        simp only [map_add, TensorProduct.tmul_add, hp, hq]
    | mul_X p r hp =>
        rw [map_mul, hX r]
        rw [show (1 : ProjectiveSpace.StandardChartRing m R i) ⊗ₜ[R]
            ((ProjectiveSpace.standardChartRingEquivMvPolynomial n R j).symm p *
              ProjectiveSpace.normalizedCoordinate n R j (j.succAbove r))
            = ((1 : ProjectiveSpace.StandardChartRing m R i) ⊗ₜ[R]
                (ProjectiveSpace.standardChartRingEquivMvPolynomial n R j).symm p) *
              ((1 : ProjectiveSpace.StandardChartRing m R i) ⊗ₜ[R]
                ProjectiveSpace.normalizedCoordinate n R j (j.succAbove r)) by
          rw [Algebra.TensorProduct.tmul_mul_tmul, one_mul]]
        rw [map_mul, map_mul, hp]
        congr 1
        simp [biprojectiveChartEvalAlgebra, affineChartPoint,
          ProjectiveSpace.standardChartEvalAlgebra, ProjectiveSpace.affineCoordinates]
  ext z
  have hz := key ((ProjectiveSpace.standardChartRingEquivMvPolynomial n R j) z)
  simp only [AlgEquiv.symm_apply_apply] at hz
  exact hz

/--
**Bridging lemma (mechanical).**  Going to `ℙⁿ_R` through the biprojective chart agrees with the
algebra-valued projective point of the second block of coordinates.

Analogue of `biprojectiveChartPointOfNormalized_comp_standardChartι_snd`
(`BiprojectiveZeroLocusClosedPoints.lean:346`); the original proof is four rewrites
(`standardChartι_snd`, `standardChartIsoSpec_inv_snd_assoc`, `← Spec.map_comp`, then the ring
identity above) and transcribes directly once the previous lemma is available. -/
theorem biprojectiveChartPointOfNormalizedAlgebra_comp_standardChartι_snd
    {R S : Type u} [CommRing R] [CommRing S] [Algebra R S]
    (m n : ℕ) (i : Fin (m + 1)) (j : Fin (n + 1))
    (x : Fin (m + 1) → S) (y : Fin (n + 1) → S) :
    biprojectiveChartPointOfNormalizedAlgebra (R := R) m n i j x y ≫
        standardChartι m n R i j ≫ snd m n R =
      ProjectiveSpace.pointOfNormalizedCoordinatesAlgebra (R := R) n j y := by
  rw [standardChartι_snd]
  unfold biprojectiveChartPointOfNormalizedAlgebra
    ProjectiveSpace.pointOfNormalizedCoordinatesAlgebra
  rw [Category.assoc, standardChartIsoSpec_inv_snd_assoc]
  rw [← Category.assoc (Spec.map _), ← Spec.map_comp]
  have hring := biprojectiveChartEvalAlgebra_comp_includeRight (R := R) m n i j x y
  have hmor :
      CommRingCat.ofHom
            (Algebra.TensorProduct.includeRight
              (R := R)
              (A := ProjectiveSpace.StandardChartRing m R i)
              (B := ProjectiveSpace.StandardChartRing n R j)).toRingHom ≫
          CommRingCat.ofHom (biprojectiveChartEvalAlgebra (R := R) m n i j x y) =
        CommRingCat.ofHom (ProjectiveSpace.standardChartEvalAlgebra (R := R) n j y) := by
    rw [← CommRingCat.ofHom_comp]
    exact congrArg CommRingCat.ofHom hring
  rw [congrArg Spec.map hmor]

/-- **The composite to the conic-bundle base, in coordinates.**

Algebra-valued analogue of `residualImagePointOfNormalized_toBase`
(`ResidualMultisectionDominant.lean:507`): going from an algebra-valued residual-image point down
to `ℙ²_y` is exactly the projective point of its `y`-coordinates.

This is the step that turns obligation 2 from a statement about a scheme-theoretic map into a
statement about an explicit ring homomorphism. -/
theorem residualImagePointOfNormalizedAlgebra_toBase
    {R S : Type u} [CommRing R] [CommRing S] [Algebra R S]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) R)
    (i j : Fin 3) (x y : Fin 3 → S)
    (hxi : x i = 1) (hyj : y j = 1)
    (hF : aeval (Sum.elim x y) F = 0)
    (hRes : aeval (Sum.elim x y) (residualEquation F) = 0) :
    residualImagePointOfNormalizedAlgebra F i j x y hxi hyj hF hRes ≫ residualImageToBase F =
      ProjectiveSpace.pointOfNormalizedCoordinatesAlgebra (R := R) 2 j y := by
  unfold residualImageToBase
  rw [← Category.assoc, residualImagePointOfNormalizedAlgebra_ι]
  exact biprojectiveChartPointOfNormalizedAlgebra_comp_standardChartι_snd
    (R := R) (S := S) 2 2 i j x y

/-- The localized residual chart map, composed down to `ℙ²_y`, is the projective point of the
normalized residual `Y`-coordinates.

With this, obligation 2 is exactly a dominance statement about
`ProjectiveSpace.pointOfNormalizedCoordinatesAlgebra` — see its docstring. -/
theorem residualImagePointOfNormalizedLoc_toBase
    {k : Type u} [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (v : Fin 3 → Polynomial k)
    (hv : TernaryQuadraticPoly.eval (coordinateLineTernaryQuadraticPoly F) v = 0)
    (i j : Fin 3) :
    residualImagePointOfNormalizedLoc F hF v hv i j ≫ residualImageToBase F =
      ProjectiveSpace.pointOfNormalizedCoordinatesAlgebra (R := k) 2 j
        (residualYCoordsNorm F v i j) :=
  residualImagePointOfNormalizedAlgebra_toBase F i j _ _ _ _ _ _

/-! ### Reducing dominance to a ring-map injectivity -/

/-- `Spec.map` of an injective ring map is dominant: the kernel is `⊥`, hence contained in the
nilradical, and `PrimeSpectrum.denseRange_comap_iff_ker_le_nilRadical` applies. -/
theorem isDominant_Spec_map_of_injective {R S : CommRingCat.{u}} (φ : R ⟶ S)
    (h : Function.Injective φ.hom) : IsDominant (Spec.map φ) := by
  rw [isDominant_iff]
  refine (PrimeSpectrum.denseRange_comap_iff_ker_le_nilRadical (f := φ.hom)).mpr ?_
  intro a ha
  simp only [RingHom.mem_ker] at ha
  have : a = 0 := h (by simpa using ha)
  simp [this]

/-- **The algebra-valued projective point is dominant as soon as its chart evaluation is
injective** (and the chart itself is dominant).

`pointOfNormalizedCoordinatesAlgebra` is by definition `Spec.map (chart evaluation)` followed by
the chart immersion, so this is just the two factors. -/
theorem isDominant_pointOfNormalizedCoordinatesAlgebra
    {R S : Type u} [CommRing R] [CommRing S] [Algebra R S]
    (n : ℕ) (j : Fin (n + 1)) (y : Fin (n + 1) → S)
    (hchart : IsDominant (ProjectiveSpace.standardChartι n R j))
    (hinj : Function.Injective (ProjectiveSpace.standardChartEvalAlgebra (R := R) n j y)) :
    IsDominant (ProjectiveSpace.pointOfNormalizedCoordinatesAlgebra (R := R) n j y) := by
  unfold ProjectiveSpace.pointOfNormalizedCoordinatesAlgebra
  haveI := hchart
  haveI : IsDominant (Spec.map (CommRingCat.ofHom
      (ProjectiveSpace.standardChartEvalAlgebra (R := R) n j y))) :=
    isDominant_Spec_map_of_injective _ hinj
  infer_instance

/-- **Obligation 2, reduced.**  Horizontality follows from two inputs: that the standard chart of
`ℙ²_y` is dominant, and that the chart evaluation at the normalized residual `Y`-coordinates is
injective.

The second is the whole content — unfolding `standardChartEvalAlgebra`, it says no nonzero
polynomial vanishes on the residual `Y`-coordinate ratios, i.e. those ratios are algebraically
independent over `k` in `k(t,s)`.  That is the concrete statement the source proof's Picard
argument was a proxy for. -/
theorem isDominant_residualImagePointOfNormalizedLoc_toBase_of_injective
    {k : Type u} [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (v : Fin 3 → Polynomial k)
    (hv : TernaryQuadraticPoly.eval (coordinateLineTernaryQuadraticPoly F) v = 0)
    (i j : Fin 3)
    (hchart : IsDominant (ProjectiveSpace.standardChartι 2 k j))
    (hinj : Function.Injective
      (ProjectiveSpace.standardChartEvalAlgebra (R := k) 2 j (residualYCoordsNorm F v i j))) :
    IsDominant (residualImagePointOfNormalizedLoc F hF v hv i j ≫ residualImageToBase F) := by
  rw [residualImagePointOfNormalizedLoc_toBase]
  exact isDominant_pointOfNormalizedCoordinatesAlgebra 2 j _ hchart hinj

/-! ### The Jacobian leaf and its corollary -/

open scoped Matrix

/--
**Polar nondegeneracy on the coordinate line is the stereo polar.**

`lineStereoPolarForm` for the standard frame is definitionally
`polarEval (specializedConicPullback F) …`, via `lineSpecializedConicPullback_coordinate`.
That is exactly the form packaged as `StereoNondegenerate` in `ResidualYNonvanishing`.
-/
theorem lineStereoPolarForm_coordinate
    {k : Type u} [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (v : Fin 3 → Polynomial k) :
    lineStereoPolarForm ![1, 0, 0] ![0, 1, 0] F v =
      polarEval (specializedConicPullback F) (liftTsenSection v) affineTwoStereoDir := by
  simp only [lineStereoPolarForm, lineSpecializedConicPullback_coordinate]

theorem lineStereoPolarForm_coordinate_ne_zero_of
    {k : Type u} [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (v : Fin 3 → Polynomial k)
    (hnd : polarEval (specializedConicPullback F) (liftTsenSection v) affineTwoStereoDir ≠ 0) :
    lineStereoPolarForm ![1, 0, 0] ![0, 1, 0] F v ≠ 0 := by
  rwa [lineStereoPolarForm_coordinate]

/--
**Coordinate-line Jacobian determinant under G3 + stereo nondegeneracy.**

By `residualYCoordsOn_coordinateLine`, this matrix is identical to the general-line matrix in
`ResidualHorizontalityLine.det_residualYCoordsOn_ne_zero` for the standard frame.  The unconditional
form (without G3 or the two section nondegeneracy conditions) was retired: it is false for bad lines
(`sum_smul_residualYCoordsOn_eq_zero_of_constant_residualLine`,
`stereoFirstCoordsOn_eq_smul_of_lineStereoPolarForm_eq_zero`).  Call sites must supply G3 for the
coordinate line (source chooses `L`; after a linear `y`-change a good line becomes the coordinate
line), `v 2 ≠ 0`, and polar nondegeneracy (available from the stereo polar via
`lineStereoPolarForm_coordinate_ne_zero_of`).

*Status: reduced to the general-line §4 det leaf.*
-/
theorem det_residualYCoords_ne_zero
    {k : Type u} [Field k] [IsAlgClosed k] [CharZero k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (biprojectiveZeroLocusToSpec 2 2 k F)]
    (hgood : ResidualLineNonconstant F)
    (v : Fin 3 → Polynomial k) (hv0 : v ≠ 0)
    (hv : TernaryQuadraticPoly.eval (coordinateLineTernaryQuadraticPoly F) v = 0)
    (hv2 : v 2 ≠ 0)
    (hpolar : lineStereoPolarForm ![1, 0, 0] ![0, 1, 0] F v ≠ 0) :
    (Matrix.of ![residualYCoords F v,
        fun a => pderiv (ULift.up 0) (residualYCoords F v a),
        fun a => pderiv (ULift.up 1) (residualYCoords F v a)]).det ≠ 0 := by
  have hMN :
      lineFrame ![1, 0, 0] ![0, 1, 0] ![0, 0, (1 : k)] *
        (1 : Matrix (Fin 3) (Fin 3) k) = 1 := by
    simp [lineFrame_coordinate]
  have hgood' : ResidualLineNonconstantOn
      (lineFrame ![1, 0, 0] ![0, 1, 0] ![0, 0, (1 : k)]) 1 F := by
    rw [lineFrame_coordinate]
    exact (residualLineNonconstantOn_one F).mpr hgood
  have hv' :
      TernaryQuadraticPoly.eval (lineTernaryQuadraticPoly ![1, 0, 0] ![0, 1, 0] F) v = 0 := by
    rwa [← coordinateLineTernaryQuadraticPoly_eq]
  have hdet :=
    det_residualYCoordsOn_ne_zero
      ![1, 0, 0] ![0, 1, 0] ![0, 0, (1 : k)] 1 hMN F hF hF0 hgood' v hv0 hv' hv2 hpolar
  have hy :
      residualYCoordsOn ![1, 0, 0] ![0, 1, 0] ![0, 0, (1 : k)] 1 F v =
        residualYCoords F v :=
    residualYCoordsOn_coordinateLine F v
  convert hdet using 1
  simp only [hy]

/-- Alias retained for call sites that already use the long name. -/
theorem det_residualYCoords_ne_zero_of_residualLineNonconstant
    {k : Type u} [Field k] [IsAlgClosed k] [CharZero k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (biprojectiveZeroLocusToSpec 2 2 k F)]
    (hgood : ResidualLineNonconstant F)
    (v : Fin 3 → Polynomial k) (hv0 : v ≠ 0)
    (hv : TernaryQuadraticPoly.eval (coordinateLineTernaryQuadraticPoly F) v = 0)
    (hv2 : v 2 ≠ 0)
    (hpolar : lineStereoPolarForm ![1, 0, 0] ![0, 1, 0] F v ≠ 0) :
    (Matrix.of ![residualYCoords F v,
        fun a => pderiv (ULift.up 0) (residualYCoords F v a),
        fun a => pderiv (ULift.up 1) (residualYCoords F v a)]).det ≠ 0 :=
  det_residualYCoords_ne_zero F hF hF0 hgood v hv0 hv hv2 hpolar

/--
**No nonzero form vanishes on the residual `Y`-coordinates** (coordinate line, under G3 + polar).

Proved from `det_residualYCoords_ne_zero` by the Jacobian criterion.  Callers must supply G3 and
polar; see the det docstring.
-/
theorem eq_zero_of_aeval_residualYCoords_of_isHomogeneous
    {k : Type u} [Field k] [IsAlgClosed k] [CharZero k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (biprojectiveZeroLocusToSpec 2 2 k F)]
    (hgood : ResidualLineNonconstant F)
    (v : Fin 3 → Polynomial k) (hv0 : v ≠ 0)
    (hv : TernaryQuadraticPoly.eval (coordinateLineTernaryQuadraticPoly F) v = 0)
    (hv2 : v 2 ≠ 0)
    (hpolar : lineStereoPolarForm ![1, 0, 0] ![0, 1, 0] F v ≠ 0)
    (d : ℕ) (Ψ : MvPolynomial (Fin 3) k) (hΨ : Ψ.IsHomogeneous d)
    (hvan : aeval (residualYCoords F v) Ψ = 0) :
    Ψ = 0 :=
  eq_zero_of_isHomogeneous_of_aeval_eq_zero_of_perfectField (residualYCoords F v)
    (ULift.up 0) (ULift.up 1)
    (det_residualYCoords_ne_zero F hF hF0 hgood v hv0 hv hv2 hpolar) d Ψ hΨ hvan

/-! ### The obligation -/

/--
**Obligation 2.**  The localized residual chart map dominates the conic-bundle base `ℙ²_y`.

Under G3 for the coordinate line and polar nondegeneracy of the stereographic section, this is the
Jacobian assembly: chart density + injectivity of chart evaluation from
`eq_zero_of_aeval_residualYCoords_of_isHomogeneous`, itself from the general-line §4 det.

*What remains globally.*  The residual track still hardcodes the coordinate line.  For arbitrary
smooth `F` the coordinate line need not be good; the source chooses `L` (§3).  Callers must supply
`hgood` (e.g. after a linear `y`-change that moves a line from `exists_good_line` to the coordinate
line) and `hpolar` (from `StereoNondegenerate`).

`CharZero` is carried because the Jacobian criterion uses it (Euler + induction on degree).
-/
theorem isDominant_residualImagePointOfNormalizedLoc_toBase
    {k : Type u} [Field k] [IsAlgClosed k] [CharZero k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (biprojectiveZeroLocusToSpec 2 2 k F)]
    (hgood : ResidualLineNonconstant F)
    (v : Fin 3 → Polynomial k) (hv0 : v ≠ 0)
    (hv : TernaryQuadraticPoly.eval (coordinateLineTernaryQuadraticPoly F) v = 0)
    (hv2 : v 2 ≠ 0)
    (hpolar : lineStereoPolarForm ![1, 0, 0] ![0, 1, 0] F v ≠ 0)
    (i j : Fin 3) (hdenom : residualChartDenom F v i j ≠ 0) :
    IsDominant (residualImagePointOfNormalizedLoc F hF v hv i j ≫ residualImageToBase F) :=
  isDominant_residualImagePointOfNormalizedLoc_toBase_of_injective F hF v hv i j
    (ProjectiveSpace.isDominant_standardChartι 2 k j)
    (injective_standardChartEvalAlgebra_residualYCoordsNorm F v i j hdenom
      fun d Ψ hΨ hvan =>
        eq_zero_of_aeval_residualYCoords_of_isHomogeneous
          F hF hF0 hgood v hv0 hv hv2 hpolar d Ψ hΨ hvan)

end

end BConicBundleMultisections
