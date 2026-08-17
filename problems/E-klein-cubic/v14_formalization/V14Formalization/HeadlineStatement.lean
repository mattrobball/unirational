/-
Copyright (c) 2026 V14Formalization contributors.
Released under Apache 2.0 license.
-/
module

public import V14Formalization.ProjectiveGVariety
public import V14Formalization.CentralizerObstruction
public import V14Formalization.SchemeModelAliases

/-!
# Public no-map statement (vocabulary only)

Defines the numbered projectivization of a faithful representation.  The
proof that there is no equivariant rational map lives in `FaithfulHeadline`.
This module is the trusted vocabulary for the Comparator challenge.
-/

noncomputable section

open CategoryTheory
open scoped AlgebraicGeometry

namespace V14Formalization.SchemeGeometry

open AlgebraicGeometry GeometricV14Carrier Module


public abbrev ambientFor
    {V : Type} [AddCommGroup V] [Module k V]
    (R : FaithfulLinearRep k G V) (p q : ℕ)
    (bp : Basis (Fin (p + 1)) k (R.plusEigenspace sigma))
    (bm : Basis (Fin (q + 1)) k (R.minusEigenspace sigma)) :=
  ambientProjectiveActionOver R (p + q + 1)
    (plusMinusAmbientBasis R sigma sigma_isInvolution p q bp bm)

/-- `σ` cannot act as `±id` on a faithful representation of this centerless
group, so both eigenspaces are available for coordinates. -/
public theorem not_degenerates
    {V : Type} [AddCommGroup V] [Module k V]
    (R : FaithfulLinearRep k G V) :
    ¬ R.DegeneratesToPlusMinusId sigma :=
  not_degenerates_of_centerless
    GeometricFanoCarrier.PSL2F11_isCenterless sigma_isInvolution R

/-- Plus/minus homogeneous coordinates used by the normal chart.  Not a
hypothesis of the public theorem: any faithful `R` supplies some. -/
public structure PlusMinusCoords
    {V : Type} [AddCommGroup V] [Module k V]
    (R : FaithfulLinearRep k G V) where
  p : ℕ
  q : ℕ
  bp : Basis (Fin (p + 1)) k (R.plusEigenspace sigma)
  bm : Basis (Fin (q + 1)) k (R.minusEigenspace sigma)

/-- Choose plus/minus bases from nondegeneracy.  The numbered `Proj` and the
`(u,T,v)` chart are built from this choice; this is not a basis-free
identification of `ℙ(V)`. -/
@[expose] public noncomputable def PlusMinusCoords.ofRep
    {V : Type} [AddCommGroup V] [Module k V]
    (R : FaithfulLinearRep k G V) : PlusMinusCoords R :=
  let h := exists_plus_minus_projective_bases R sigma sigma_isInvolution
    (not_degenerates R)
  { p := h.choose
    q := h.choose_spec.choose
    bp := Classical.choice h.choose_spec.choose_spec.1
    bm := Classical.choice h.choose_spec.choose_spec.2 }

/-- The numbered projective action of `R` in the chosen plus/minus
coordinates. -/
public abbrev ambientOf
    {V : Type} [AddCommGroup V] [Module k V]
    (R : FaithfulLinearRep k G V) :
    Action (Over (Spec (.of k))) G :=
  ambientFor R (PlusMinusCoords.ofRep R).p (PlusMinusCoords.ofRep R).q
    (PlusMinusCoords.ofRep R).bp (PlusMinusCoords.ofRep R).bm

namespace ProjectiveGVariety

/-- Projectivization of a faithful linear representation, as a closed
subscheme of the numbered `Proj` in the chosen plus/minus coordinates. -/
public abbrev ofFaithfulRep
    {V : Type} [AddCommGroup V] [Module k V]
    (R : FaithfulLinearRep k G V) : ProjectiveGVariety k G :=
  ofLinearRep R
    ((PlusMinusCoords.ofRep R).p + (PlusMinusCoords.ofRep R).q + 1)
    (plusMinusAmbientBasis R sigma sigma_isInvolution
      (PlusMinusCoords.ofRep R).p (PlusMinusCoords.ofRep R).q
      (PlusMinusCoords.ofRep R).bp (PlusMinusCoords.ofRep R).bm)

@[expose] public instance ofFaithfulRep_irreducible
    {V : Type} [AddCommGroup V] [Module k V]
    (R : FaithfulLinearRep k G V) :
    IrreducibleSpace (ofFaithfulRep R).toScheme :=
  ofLinearRep_irreducible R
    ((PlusMinusCoords.ofRep R).p + (PlusMinusCoords.ofRep R).q + 1)
    (plusMinusAmbientBasis R sigma sigma_isInvolution
      (PlusMinusCoords.ofRep R).p (PlusMinusCoords.ofRep R).q
      (PlusMinusCoords.ofRep R).bp (PlusMinusCoords.ofRep R).bm)

end ProjectiveGVariety

end V14Formalization.SchemeGeometry
