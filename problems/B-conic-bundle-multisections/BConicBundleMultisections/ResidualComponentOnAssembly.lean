/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import BConicBundleMultisections.PointedConicRationalFamilies
public import BConicBundleMultisections.GenericConicFiberIntegral
public import BConicBundleMultisections.PointedConicOpenConsumer
public import BConicBundleMultisections.ResidualComponentOnHorizontality
public import BConicBundleMultisections.UnirationalTower

/-!
# Assembling the arbitrary-line residual component

This is the scheme-level replacement for the old coordinate-line assembly.  Once a framed line,
an isotropic polynomial section, a nonempty residual chart, and dominance over `P^2_y` have been
constructed, the component is an integral unirational surface.  Pointed-conic rationality over
that surface and the unirational tower then give a three-dimensional parametrization of the base
change.
-/

@[expose] public section

open CategoryTheory Limits
open scoped AlgebraicGeometry Matrix

namespace BConicBundleMultisections

noncomputable section

universe u

open AlgebraicGeometry MvPolynomial BiprojectiveSpace

variable {k : Type u} [Field k]
  (p₀ q₀ r : Fin 3 → k) (N : Matrix (Fin 3) (Fin 3) k)
  (hMN : lineFrame p₀ q₀ r * N = 1)
  (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
  (v : Fin 3 → Polynomial k)
  (hv : TernaryQuadraticPoly.eval (lineTernaryQuadraticPoly p₀ q₀ F) v = 0)
  (i j : Fin 3)

/-- The two ways from the arbitrary-line base change to `Spec k` agree. -/
theorem residualComponentOnMultisection_baseChangeSnd_comp_toSpec :
    (residualComponentOnMultisection p₀ q₀ r N hMN F hF v hv i j).baseChangeSnd ≫
        residualComponentOnToSpec p₀ q₀ r N hMN F hF v hv i j =
      (residualComponentOnMultisection p₀ q₀ r N hMN F hF v hv i j).baseChangeFst ≫
        biprojectiveZeroLocusToSpec 2 2 k F := by
  let m := residualComponentOnMultisection p₀ q₀ r N hMN F hF v hv i j
  have hw := m.baseChange_isPullback.w
  have hπ := biprojectiveZeroLocusSnd_toSpec 2 2 k F
  have hT :
      residualComponentOnToBase p₀ q₀ r N hMN F hF v hv i j ≫
          ProjectiveSpace.toSpec 2 k =
        residualComponentOnToSpec p₀ q₀ r N hMN F hF v hv i j := by
    simp only [residualComponentOnToBase, residualComponentOnToSpec, Category.assoc]
    rw [hπ]
  have hw' := congrArg (· ≫ ProjectiveSpace.toSpec 2 k) hw
  simp only [Category.assoc] at hw'
  rw [← hT, ← hπ]
  exact hw'.symm

/-- Pointed-conic rationality supplies the relative one-dimensional parametrization. -/
theorem hasUnirationalParametrization1_residualComponentOnBaseChangeSnd
    (h : IsPointedConicRationalOver
      (biprojectiveZeroLocusSnd 2 2 k F)
      (residualComponentOnToBase p₀ q₀ r N hMN F hF v hv i j)
      (residualComponentOnMultisection
        p₀ q₀ r N hMN F hF v hv i j).tautologicalPullbackSection) :
    HasUnirationalParametrization 1
      (residualComponentOnMultisection
        p₀ q₀ r N hMN F hF v hv i j).baseChangeSnd :=
  ⟨UnirationalParametrization.ofBirationalOverAffine h⟩

/-- The axiom-free tower interface for an arbitrary-line component.  Once pointed-conic
rationality is supplied explicitly, its two-dimensional rational parametrization and the general
`2 + 1` tower give a three-dimensional parametrization of the base change. -/
theorem hasUnirationalParametrization3_residualComponentOnBaseChange_of_pointed
    (hdenom : residualComponentOnDenom p₀ q₀ r N F v i j ≠ 0)
    (hpointed : IsPointedConicRationalOver
      (biprojectiveZeroLocusSnd 2 2 k F)
      (residualComponentOnToBase p₀ q₀ r N hMN F hF v hv i j)
      (residualComponentOnMultisection
        p₀ q₀ r N hMN F hF v hv i j).tautologicalPullbackSection) :
    HasUnirationalParametrization 3
      ((residualComponentOnMultisection
        p₀ q₀ r N hMN F hF v hv i j).baseChangeFst ≫
          biprojectiveZeroLocusToSpec 2 2 k F) := by
  have h2 := hasUnirationalParametrization2_residualComponentOn
    p₀ q₀ r N hMN F hF v hv i j hdenom
  have h1 := hasUnirationalParametrization1_residualComponentOnBaseChangeSnd
    p₀ q₀ r N hMN F hF v hv i j hpointed
  haveI : Nonempty (residualComponentOn p₀ q₀ r N hMN F hF v hv i j) :=
    nonempty_of_hasUnirationalParametrization h2
  rw [← residualComponentOnMultisection_baseChangeSnd_comp_toSpec
    p₀ q₀ r N hMN F hF v hv i j]
  exact hasUnirationalParametrization_succ_of_tower
    (R := CommRingCat.of k)
    (residualComponentOnToSpec p₀ q₀ r N hMN F hF v hv i j)
    (residualComponentOnMultisection
      p₀ q₀ r N hMN F hF v hv i j).baseChangeSnd h2 h1

/-- The axiom-free arbitrary-line interface all the way to the original zero locus.  The two
geometric inputs are kept independent: `hdom` makes the pullback projection dominant, while
`hpointed` rationalizes its conic fibres. -/
theorem hasUnirationalParametrization3_biprojectiveZeroLocus_of_residualComponentOn_of_pointed
    (hdenom : residualComponentOnDenom p₀ q₀ r N F v i j ≠ 0)
    (hdom : IsDominant
      (residualComponentOnToBase p₀ q₀ r N hMN F hF v hv i j))
    (hpointed : IsPointedConicRationalOver
      (biprojectiveZeroLocusSnd 2 2 k F)
      (residualComponentOnToBase p₀ q₀ r N hMN F hF v hv i j)
      (residualComponentOnMultisection
        p₀ q₀ r N hMN F hF v hv i j).tautologicalPullbackSection) :
    HasUnirationalParametrization 3 (biprojectiveZeroLocusToSpec 2 2 k F) := by
  let m := residualComponentOnMultisection p₀ q₀ r N hMN F hF v hv i j
  haveI : IsDominant m.baseChangeFst := by
    dsimp only [m]
    exact isDominant_residualComponentOnMultisection_baseChangeFst
      p₀ q₀ r N hMN F hF v hv i j hdom
  exact m.hasUnirationalParametrization_of_baseChange
    (biprojectiveZeroLocusToSpec 2 2 k F)
    (hasUnirationalParametrization3_residualComponentOnBaseChange_of_pointed
      p₀ q₀ r N hMN F hF v hv i j hdenom hpointed)

/-- The pointed conic over a horizontal integral arbitrary-line component is rational. -/
theorem isPointedConicRationalOver_residualComponentOn_of_smooth
    [IsAlgClosed k] [NeZero (2 : k)] [NeZero (3 : k)]
    (hF0 : F ≠ 0)
    [Smooth (biprojectiveZeroLocusToSpec 2 2 k F)]
    (hdenom : residualComponentOnDenom p₀ q₀ r N F v i j ≠ 0)
    (hdom : IsDominant
      (residualComponentOnToBase p₀ q₀ r N hMN F hF v hv i j)) :
    IsPointedConicRationalOver
      (biprojectiveZeroLocusSnd 2 2 k F)
      (residualComponentOnToBase p₀ q₀ r N hMN F hF v hv i j)
      (residualComponentOnMultisection
        p₀ q₀ r N hMN F hF v hv i j).tautologicalPullbackSection := by
  haveI : IsIntegral (residualComponentOn p₀ q₀ r N hMN F hF v hv i j) :=
    isIntegral_residualComponentOn p₀ q₀ r N hMN F hF v hv i j hdenom
  haveI : IsDominant
      (residualComponentOnToBase p₀ q₀ r N hMN F hF v hv i j) := hdom
  exact isPointedConicRationalOver_of_smooth F hF hF0
    (residualComponentOnToBase p₀ q₀ r N hMN F hF v hv i j)
    (residualComponentOnMultisection
      p₀ q₀ r N hMN F hF v hv i j).tautologicalPullbackSection

/-- The arbitrary-line residual base change is unirational in dimension three. -/
theorem hasUnirationalParametrization3_residualComponentOnBaseChange
    [IsAlgClosed k] [NeZero (2 : k)] [NeZero (3 : k)]
    (hF0 : F ≠ 0)
    [Smooth (biprojectiveZeroLocusToSpec 2 2 k F)]
    (hdenom : residualComponentOnDenom p₀ q₀ r N F v i j ≠ 0)
    (hdom : IsDominant
      (residualComponentOnToBase p₀ q₀ r N hMN F hF v hv i j)) :
    HasUnirationalParametrization 3
      ((residualComponentOnMultisection
        p₀ q₀ r N hMN F hF v hv i j).baseChangeFst ≫
          biprojectiveZeroLocusToSpec 2 2 k F) := by
  have hpointed := isPointedConicRationalOver_residualComponentOn_of_smooth
    p₀ q₀ r N hMN F hF v hv i j hF0 hdenom hdom
  exact hasUnirationalParametrization3_residualComponentOnBaseChange_of_pointed
    p₀ q₀ r N hMN F hF v hv i j hdenom hpointed

/-- The source-faithful open-chart route to the original zero locus.  Unlike
`hasUnirationalParametrization3_residualComponentOnBaseChange`, this does not assert that the
entire pointed-conic pullback is rational or integral.  Global flatness and the directly proved
integrality of the generic conic fibre make the explicit stereographic open dense, which is all
the unirationality argument needs. -/
theorem hasUnirationalParametrization3_biprojectiveZeroLocus_of_residualComponentOn_open
    [NeZero (2 : k)] [NeZero (3 : k)]
    (hF0 : F ≠ 0)
    [Smooth (biprojectiveZeroLocusToSpec 2 2 k F)]
    [Flat (biprojectiveZeroLocusSnd 2 2 k F)]
    (hdenom : residualComponentOnDenom p₀ q₀ r N F v i j ≠ 0)
    (hdom : IsDominant
      (residualComponentOnToBase p₀ q₀ r N hMN F hF v hv i j)) :
    HasUnirationalParametrization 3 (biprojectiveZeroLocusToSpec 2 2 k F) := by
  let T := residualComponentOn p₀ q₀ r N hMN F hF v hv i j
  let t := residualComponentOnToBase p₀ q₀ r N hMN F hF v hv i j
  let s := (residualComponentOnMultisection
    p₀ q₀ r N hMN F hF v hv i j).tautologicalPullbackSection
  haveI : IsIntegral T := by
    dsimp only [T]
    exact isIntegral_residualComponentOn p₀ q₀ r N hMN F hF v hv i j hdenom
  haveI : IsDominant t := by
    dsimp only [t]
    exact hdom
  haveI : IrreducibleSpace
      ((Limits.pullback.snd (biprojectiveZeroLocusSnd 2 2 k F) t).fiber
        (genericPoint T)) := by
    letI : IsIntegral
        ((Limits.pullback.snd (biprojectiveZeroLocusSnd 2 2 k F) t).fiber
          (genericPoint T)) :=
      isIntegral_genericFiber_pullback_biprojectiveZeroLocusSnd_direct F hF hF0 t
    infer_instance
  have htSpec :
      t ≫ ProjectiveSpace.toSpec 2 k =
        residualComponentOnToSpec p₀ q₀ r N hMN F hF v hv i j := by
    dsimp only [t, residualComponentOnToBase, residualComponentOnToSpec]
    simp only [Category.assoc]
    rw [biprojectiveZeroLocusSnd_toSpec 2 2 k F]
  have hT : HasUnirationalParametrization 2
      (t ≫ ProjectiveSpace.toSpec 2 k) := by
    rw [htSpec]
    exact hasUnirationalParametrization2_residualComponentOn
      p₀ q₀ r N hMN F hF v hv i j hdenom
  exact hasUnirationalParametrization3_of_pointedConicOpen_of_flat
    F hF hF0 t s hT

/-- A horizontal arbitrary-line residual component parametrizes the original bidegree-`(2,3)`
zero locus, not only its base change.  Properness upgrades `hdom` to surjectivity of the
component over `P²_y`; surjectivity survives base change, so the first pullback projection is
dominant and the general multisection composition theorem applies. -/
theorem hasUnirationalParametrization3_biprojectiveZeroLocus_of_residualComponentOn
    [IsAlgClosed k] [NeZero (2 : k)] [NeZero (3 : k)]
    (hF0 : F ≠ 0)
    [Smooth (biprojectiveZeroLocusToSpec 2 2 k F)]
    (hdenom : residualComponentOnDenom p₀ q₀ r N F v i j ≠ 0)
    (hdom : IsDominant
      (residualComponentOnToBase p₀ q₀ r N hMN F hF v hv i j)) :
    HasUnirationalParametrization 3 (biprojectiveZeroLocusToSpec 2 2 k F) := by
  have hpointed := isPointedConicRationalOver_residualComponentOn_of_smooth
    p₀ q₀ r N hMN F hF v hv i j hF0 hdenom hdom
  exact
    hasUnirationalParametrization3_biprojectiveZeroLocus_of_residualComponentOn_of_pointed
      p₀ q₀ r N hMN F hF v hv i j hdenom hdom hpointed

include hMN hF hv

/-- The complete arbitrary-line tower, with chart indices eliminated.

The geometric inputs are stated exactly where they enter: `hgood` rules out a constant residual
line, while `hv2` and `hpolar` rule out the two collapses of the stereographic parametrization.
The arbitrary-line
horizontality theorem chooses a nonzero chart and proves dominance; the preceding theorem then
assembles the rational surface, pointed conic, tower, and dominant projection to the original
threefold. -/
theorem hasUnirationalParametrization3_biprojectiveZeroLocus_of_goodLineOn
    [IsAlgClosed k] [NeZero (2 : k)] [NeZero (3 : k)]
    (hF0 : F ≠ 0)
    [Smooth (biprojectiveZeroLocusToSpec 2 2 k F)]
    (hgood : ResidualLineNonconstantOn (lineFrame p₀ q₀ r) N F)
    (hv0 : v ≠ 0)
    (hv2 : v 2 ≠ 0)
    (hpolar : lineStereoPolarForm p₀ q₀ F v ≠ 0) :
    HasUnirationalParametrization 3 (biprojectiveZeroLocusToSpec 2 2 k F) := by
  obtain ⟨i, j, hdenom, hdom⟩ :=
    exists_isDominant_residualComponentOnToBase
      p₀ q₀ r N hMN F hF hF0 hgood v hv0 hv hv2 hpolar
  exact hasUnirationalParametrization3_biprojectiveZeroLocus_of_residualComponentOn
    p₀ q₀ r N hMN F hF v hv i j hF0 hdenom hdom

end

end BConicBundleMultisections
