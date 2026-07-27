/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import BConicBundleMultisections.ResidualTargetExhaustionMembership
public import BConicBundleMultisections.ResidualDiscriminantConsumer
public import BConicBundleMultisections.ResidualDiscriminantHorizontality
public import BConicBundleMultisections.ResidualYNonvanishingLine
public import BConicBundleMultisections.TargetRelationGenericFiber

/-!
# Geometry sufficient for residual target-relation membership

This module records the exact geometric input needed by the discriminant route to residual
horizontality.  For every irreducible homogeneous relation `H(y)` which does not divide the conic
discriminant, three facts are required:

* the projective complete intersection `V(F, H(y))` is integral;
* its generic fibre over the first projective plane is locally Artinian;
* the unsaturated Cox ideal `(F, H(y))` is radical.

The first two facts make a residual component which dominates the first factor exhaust the whole
projective complete intersection.  The third fact then converts projective vanishing into literal
polynomial-ideal membership.  Keeping these properties separate is important: integrality of the
projective complete intersection does not by itself assert reducedness at the irrelevant vertex of
its affine cone.  A prime Cox ideal is retained below as a stronger sufficient interface.
-/

@[expose] public section

open CategoryTheory Topology TopologicalSpace
open scoped AlgebraicGeometry Matrix

namespace BConicBundleMultisections

noncomputable section

universe u

open AlgebraicGeometry BiprojectiveSpace
open _root_.MvPolynomial

/-- Projective integrality for all irreducible target relations away from the conic
discriminant. -/
def TargetRelationsProjectivelyIntegralAwayDiscriminant
    {k : Type u} [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) : Prop :=
  ∀ (H : MvPolynomial (Fin 3) k) (d : ℕ),
    Irreducible H → H.IsHomogeneous d → 0 < d →
      ¬ H ∣ sndConicDiscriminant F →
        IsIntegral (targetRelationZeroLocus F H)

/-- Local Artinianness of the first-projection generic fibre for all irreducible target
relations away from the conic discriminant. -/
def TargetRelationsGenericFiberArtinianAwayDiscriminant
    {k : Type u} [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) : Prop :=
  ∀ (H : MvPolynomial (Fin 3) k) (d : ℕ),
    Irreducible H → H.IsHomogeneous d → 0 < d →
      ¬ H ∣ sndConicDiscriminant F →
        IsLocallyArtinian
          ((targetRelationToFirst F H).fiber
            (genericPoint (ProjectiveSpace 2 k)))

/-- Reducedness of the literal two-generated Cox ideal for all irreducible target relations away
from the conic discriminant.  This includes the affine-cone saturation statement at the
irrelevant vertex and is therefore intentionally not conflated with projective integrality. -/
def TargetRelationsCoxRadicalAwayDiscriminant
    {k : Type u} [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) : Prop :=
  ∀ (H : MvPolynomial (Fin 3) k) (d : ℕ),
    Irreducible H → H.IsHomogeneous d → 0 < d →
      ¬ H ∣ sndConicDiscriminant F →
        (Ideal.span {F, MvPolynomial.rename Sum.inr H}).IsRadical

/-- The stronger prime form of the preceding affine-cone property. -/
def TargetRelationsCoxPrimeAwayDiscriminant
    {k : Type u} [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) : Prop :=
  ∀ (H : MvPolynomial (Fin 3) k) (d : ℕ),
    Irreducible H → H.IsHomogeneous d → 0 < d →
      ¬ H ∣ sndConicDiscriminant F →
        (Ideal.span {F, MvPolynomial.rename Sum.inr H}).IsPrime

/-- Projective integrality, an Artinian generic fibre, and Cox-ideal reducedness imply the exact
target-relation membership package used by the discriminant horizontality argument.

The chosen residual chart is independent of `H`.  Its denominator is nonzero by the clean
transported residual-point nonvanishing theorem.  For each `H`, dominance over `P²_x` becomes
surjectivity by properness; integrality and the Artinian generic fibre then make the residual
closed immersion an isomorphism. -/
theorem residualTargetRelationMembershipAwayDiscriminantOn_of_reducedGeometry
    {k : Type u} [Field k] [IsAlgClosed k] [CharZero k]
    (p₀ q₀ r : Fin 3 → k) (N : Matrix (Fin 3) (Fin 3) k)
    (hMN : lineFrame p₀ q₀ r * N = 1)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (biprojectiveZeroLocusToSpec 2 2 k F)]
    (v : Fin 3 → Polynomial k) (hv0 : v ≠ 0)
    (hv : TernaryQuadraticPoly.eval (lineTernaryQuadraticPoly p₀ q₀ F) v = 0)
    (hv2 : v 2 ≠ 0)
    (hpolar : lineStereoPolarForm p₀ q₀ F v ≠ 0)
    (hintegral : TargetRelationsProjectivelyIntegralAwayDiscriminant F)
    (hartinian : TargetRelationsGenericFiberArtinianAwayDiscriminant F)
    (hradical : TargetRelationsCoxRadicalAwayDiscriminant F) :
    ResidualTargetRelationMembershipAwayDiscriminantOn p₀ q₀ r N F v := by
  have hX : stereoFirstCoordsOn p₀ q₀ F v ≠ 0 :=
    stereoFirstCoordsOn_ne_zero_of_polar p₀ q₀ F hF v hv (by
      simpa [lineStereoPolarForm] using hpolar)
  have hY : residualYCoordsOn p₀ q₀ r N F v ≠ 0 :=
    residualYCoordsOn_ne_zero_of_smooth_transport
      p₀ q₀ r N hMN F hF hF0 v hv0 hv hv2 hpolar
  obtain ⟨i, j, hdenom⟩ :=
    exists_residualComponentOnDenom_ne_zero p₀ q₀ r N F v hX hY
  intro H d hHirr hHhom hd hvan hdisc
  letI : IsIntegral (targetRelationZeroLocus F H) :=
    hintegral H d hHirr hHhom hd hdisc
  have hdom : IsDominant
      (residualTargetComponentOnToFirst
        p₀ q₀ r N hMN F hF v hv i j H hHhom hvan) :=
    isDominant_residualTargetComponentOnToFirst_of_smooth
      p₀ q₀ r N hMN F hF hF0 v hv hv2 i j hdenom H hHhom hvan
  letI : Surjective
      (residualTargetComponentOnToFirst
        p₀ q₀ r N hMN F hF v hv i j H hHhom hvan) :=
    surjective_residualTargetComponentOnToFirst
      p₀ q₀ r N hMN F hF v hv i j H hHhom hvan hdom
  letI : IsLocallyArtinian
      ((targetRelationToFirst F H).fiber
        (genericPoint (ProjectiveSpace 2 k))) :=
    hartinian H d hHirr hHhom hd hdisc
  letI : IsIso
      (residualTargetComponentOnι
        p₀ q₀ r N hMN F hF v hv i j H hHhom hvan) :=
    BConicBundleMultisections.TargetRelationGenericFiber.residualTargetComponentOnι_isIso_of_isLocallyArtinian_genericFiber
        p₀ q₀ r N hMN F hF v hv i j H hHhom hvan
  exact residualEquationOn_mem_span_targetRelation_of_isIso_of_isRadical
    p₀ q₀ r N hMN F hF v hv i j H hHhom hvan
      (hradical H d hHirr hHhom hd hdisc)

/-- Prime Cox ideals supply the reduced affine-cone input in the preceding theorem. -/
theorem residualTargetRelationMembershipAwayDiscriminantOn_of_geometry
    {k : Type u} [Field k] [IsAlgClosed k] [CharZero k]
    (p₀ q₀ r : Fin 3 → k) (N : Matrix (Fin 3) (Fin 3) k)
    (hMN : lineFrame p₀ q₀ r * N = 1)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (biprojectiveZeroLocusToSpec 2 2 k F)]
    (v : Fin 3 → Polynomial k) (hv0 : v ≠ 0)
    (hv : TernaryQuadraticPoly.eval (lineTernaryQuadraticPoly p₀ q₀ F) v = 0)
    (hv2 : v 2 ≠ 0)
    (hpolar : lineStereoPolarForm p₀ q₀ F v ≠ 0)
    (hintegral : TargetRelationsProjectivelyIntegralAwayDiscriminant F)
    (hartinian : TargetRelationsGenericFiberArtinianAwayDiscriminant F)
    (hprime : TargetRelationsCoxPrimeAwayDiscriminant F) :
    ResidualTargetRelationMembershipAwayDiscriminantOn p₀ q₀ r N F v := by
  apply residualTargetRelationMembershipAwayDiscriminantOn_of_reducedGeometry
    p₀ q₀ r N hMN F hF hF0 v hv0 hv hv2 hpolar hintegral hartinian
  intro H d hHirr hHhom hd hdisc
  exact (hprime H d hHirr hHhom hd hdisc).isRadical

/-- Full tangent-residual consumer under the three target-relation geometry properties.

Unlike the old Jacobian-determinant route, the hypotheses below expose only the actual geometric
inputs: one line satisfying G3 and G4, a nondegenerate Tsen section on that line, and uniform
integrality/Artinianness/Cox-reducedness for the target relations encountered in a putative
homogeneous dependence. -/
theorem hasUnirationalParametrization3_biprojectiveZeroLocus_of_targetRelationGeometry
    {k : Type u} [Field k] [IsAlgClosed k] [CharZero k]
    (p₀ q₀ r : Fin 3 → k) (N : Matrix (Fin 3) (Fin 3) k)
    (hMN : lineFrame p₀ q₀ r * N = 1)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (biprojectiveZeroLocusToSpec 2 2 k F)]
    (hgood : ResidualLineNonconstantOn (lineFrame p₀ q₀ r) N F)
    (v : Fin 3 → Polynomial k) (hv0 : v ≠ 0)
    (hv : TernaryQuadraticPoly.eval (lineTernaryQuadraticPoly p₀ q₀ F) v = 0)
    (hv2 : v 2 ≠ 0)
    (hpolar : lineStereoPolarForm p₀ q₀ F v ≠ 0)
    (havoid : ResidualAvoidsConicDiscriminantOn p₀ q₀ r N F v)
    (hintegral : TargetRelationsProjectivelyIntegralAwayDiscriminant F)
    (hartinian : TargetRelationsGenericFiberArtinianAwayDiscriminant F)
    (hradical : TargetRelationsCoxRadicalAwayDiscriminant F) :
    HasUnirationalParametrization 3 (biprojectiveZeroLocusToSpec 2 2 k F) := by
  have hmembership :
      ResidualTargetRelationMembershipAwayDiscriminantOn p₀ q₀ r N F v :=
    residualTargetRelationMembershipAwayDiscriminantOn_of_reducedGeometry
      p₀ q₀ r N hMN F hF hF0 v hv0 hv hv2 hpolar
        hintegral hartinian hradical
  exact hasUnirationalParametrization3_biprojectiveZeroLocus_of_membershipAwayDiscriminant
    p₀ q₀ r N hMN F hF hF0 v hv hpolar hgood havoid hmembership

end

end BConicBundleMultisections
