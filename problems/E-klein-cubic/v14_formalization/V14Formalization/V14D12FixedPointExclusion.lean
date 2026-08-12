/-
Copyright (c) 2026 V14Formalization contributors.
Released under Apache 2.0 license.
-/
import V14Formalization.D12MatrixCertificate
import V14Formalization.ProjectiveEigenvectorReduction
import V14Formalization.SchemeRationalConstancy
import V14Formalization.V14FixedPointEquations

/-!
# Excluding base-field fixed sections from a D12 certificate

This module connects the abstract matrix certificate to the actual V14 scheme.
It starts with an honest section of the scheme-theoretic sigma fixed locus,
extracts normalized ambient coordinates, and applies the certificate to the
actual rotation and reflection matrices.  The dihedral relations are derived
from the group action rather than included as certificate hypotheses.
-/

noncomputable section

open CategoryTheory Matrix
open scoped AlgebraicGeometry

namespace V14Formalization.SchemeGeometry

open AlgebraicGeometry BConicBundleMultisections
open GeometricV14Carrier Lambda2Coordinates
open D12Certificate

private abbrev G := V14SchemeModel.G

/-- The actual ambient matrix of the distinguished D12 rotation. -/
abbrev d12ActualRotMatrix :
    Matrix (Fin 15) (Fin 15) V14SchemeModel.k :=
  (lambda2MatrixRepresentation.ρ
    (CentralizerN.rotGen : G) :
      Matrix (Fin 15) (Fin 15) V14SchemeModel.k)

/-- The actual ambient matrix of the distinguished D12 reflection. -/
abbrev d12ActualReflMatrix :
    Matrix (Fin 15) (Fin 15) V14SchemeModel.k :=
  (lambda2MatrixRepresentation.ρ
    (CentralizerN.reflGen : G) :
      Matrix (Fin 15) (Fin 15) V14SchemeModel.k)

private abbrev actualRotInv :
    Matrix (Fin 15) (Fin 15) V14SchemeModel.k :=
  (((lambda2MatrixRepresentation.ρ
    (CentralizerN.rotGen : G))⁻¹ : GL (Fin 15) V14SchemeModel.k) :
      Matrix (Fin 15) (Fin 15) V14SchemeModel.k)

private abbrev actualReflInv :
    Matrix (Fin 15) (Fin 15) V14SchemeModel.k :=
  (((lambda2MatrixRepresentation.ρ
    (CentralizerN.reflGen : G))⁻¹ : GL (Fin 15) V14SchemeModel.k) :
      Matrix (Fin 15) (Fin 15) V14SchemeModel.k)

private theorem d12ActualReflMatrix_sq :
    d12ActualReflMatrix * d12ActualReflMatrix = 1 := by
  have hg : (CentralizerN.reflGen : G) * CentralizerN.reflGen = 1 :=
    congrArg Subtype.val CentralizerN.reflGen_mul_self
  rw [← show (lambda2MatrixRepresentation.ρ
        ((CentralizerN.reflGen : G) * CentralizerN.reflGen) :
      Matrix (Fin 15) (Fin 15) V14SchemeModel.k) =
        d12ActualReflMatrix * d12ActualReflMatrix by
    rw [map_mul]
    rfl]
  rw [hg]
  simp

private theorem d12ActualReflRotReflRot :
    d12ActualReflMatrix * d12ActualRotMatrix *
        d12ActualReflMatrix * d12ActualRotMatrix = 1 := by
  have hconj :
      (CentralizerN.reflGen : G) * CentralizerN.rotGen *
          CentralizerN.reflGen = CentralizerN.rotGen⁻¹ :=
    congrArg Subtype.val CentralizerN.reflGen_conj_rotGen
  have hg :
      (CentralizerN.reflGen : G) * CentralizerN.rotGen *
          CentralizerN.reflGen * CentralizerN.rotGen = 1 := by
    rw [hconj]
    simp
  rw [← show (lambda2MatrixRepresentation.ρ
        ((CentralizerN.reflGen : G) * CentralizerN.rotGen *
          CentralizerN.reflGen * CentralizerN.rotGen) :
      Matrix (Fin 15) (Fin 15) V14SchemeModel.k) =
        d12ActualReflMatrix * d12ActualRotMatrix *
          d12ActualReflMatrix * d12ActualRotMatrix by
    simp only [map_mul]
    rfl]
  rw [hg]
  simp

private theorem no_centralizer_fixed_section_of_certificate_core
    (C : D12Certificate.Certificate (Ω := V14SchemeModel.k))
    (hP : C.P = V14SchemeModel.projectorMatrix)
    (hR : C.R = d12ActualRotMatrix)
    (hF : C.F = d12ActualReflMatrix) :
    ¬ ∃ y : Spec (.of V14SchemeModel.k) ⟶
        (FixedBy V14SchemeModel.actionOver sigma).left,
      y ≫ (FixedBy V14SchemeModel.actionOver sigma).hom = 𝟙 _ ∧
        ∀ n : Subgroup.centralizer ({sigma} : Set G),
          y ≫ (fixedByCentralizerHom
            V14SchemeModel.actionOver sigma n).left = y := by
  rintro ⟨y, hybase, hyfixed⟩
  let p : v14FieldPointOver V14SchemeModel.k ⟶
      FixedBy V14SchemeModel.actionOver sigma :=
    Over.homMk y (by
      change y ≫ (FixedBy V14SchemeModel.actionOver sigma).hom =
        Spec.map (CommRingCat.ofHom
          (algebraMap V14SchemeModel.k V14SchemeModel.k))
      rw [hybase]
      simp)
  obtain ⟨j, x, hxj, hxpoint, hPx, hplucker⟩ :=
    exists_normalizedCoordinates_v14FixedBy_projector_fixed
      V14SchemeModel.k p
  let z : Spec (.of V14SchemeModel.k) ⟶ V14SchemeModel.actionOver.V.left :=
    y ≫ (fixedByι V14SchemeModel.actionOver sigma).left
  have hzfixed (n : Subgroup.centralizer ({sigma} : Set G)) :
      z ≫ (V14SchemeModel.actionOver.ρ n.1).left = z := by
    dsimp only [z]
    calc
      (y ≫ (fixedByι V14SchemeModel.actionOver sigma).left) ≫
          (V14SchemeModel.actionOver.ρ n.1).left =
          y ≫ ((fixedByι V14SchemeModel.actionOver sigma).left ≫
            (V14SchemeModel.actionOver.ρ n.1).left) := Category.assoc _ _ _
      _ = y ≫ (fixedByCentralizerHom
            V14SchemeModel.actionOver sigma n).left ≫
              (fixedByι V14SchemeModel.actionOver sigma).left := by
        have hn := congrArg Over.Hom.left
          (fixedByCentralizerHom_ι V14SchemeModel.actionOver sigma n)
        change (fixedByCentralizerHom V14SchemeModel.actionOver sigma n).left ≫
            (fixedByι V14SchemeModel.actionOver sigma).left =
          (fixedByι V14SchemeModel.actionOver sigma).left ≫
            (V14SchemeModel.actionOver.ρ n.1).left at hn
        rw [← hn]
      _ = (y ≫ (fixedByCentralizerHom
            V14SchemeModel.actionOver sigma n).left) ≫
              (fixedByι V14SchemeModel.actionOver sigma).left :=
        (Category.assoc _ _ _).symm
      _ = y ≫ (fixedByι V14SchemeModel.actionOver sigma).left := by
        rw [hyfixed n]
  have hambR : ambientPointOfV14FixedBy V14SchemeModel.k p ≫
        projectiveActionHom lambda2MatrixRepresentation.ρ
          (CentralizerN.rotGen : G) =
      ambientPointOfV14FixedBy V14SchemeModel.k p := by
    exact V14SchemeModel.fixed_comp_v14Schemeι
      (CentralizerN.rotGen : G) z (hzfixed CentralizerN.rotGen)
  have hambF : ambientPointOfV14FixedBy V14SchemeModel.k p ≫
        projectiveActionHom lambda2MatrixRepresentation.ρ
          (CentralizerN.reflGen : G) =
      ambientPointOfV14FixedBy V14SchemeModel.k p := by
    exact V14SchemeModel.fixed_comp_v14Schemeι
      (CentralizerN.reflGen : G) z (hzfixed CentralizerN.reflGen)
  obtain ⟨a, _ha, hRx⟩ :=
    exists_eigenScalar_of_mapLinearSubst_fixed
      14 d12ActualRotMatrix actualRotInv
      (by simp [d12ActualRotMatrix, actualRotInv]) j x hxj
      (ambientPointOfV14FixedBy V14SchemeModel.k p) hxpoint
      (by simpa only [projectiveActionHom, d12ActualRotMatrix,
        actualRotInv] using hambR)
  obtain ⟨b, _hb, hFx⟩ :=
    exists_eigenScalar_of_mapLinearSubst_fixed
      14 d12ActualReflMatrix actualReflInv
      (by simp [d12ActualReflMatrix, actualReflInv]) j x hxj
      (ambientPointOfV14FixedBy V14SchemeModel.k p) hxpoint
      (by simpa only [projectiveActionHom, d12ActualReflMatrix,
        actualReflInv] using hambF)
  have hxne : x ≠ 0 := by
    intro hxzero
    have : (1 : V14SchemeModel.k) = 0 := by
      simpa [hxj] using congrFun hxzero j
    exact one_ne_zero this
  have hpl : ∀ q : Fin 15, D12Certificate.pluckerValue x q = 0 := by
    intro q
    simpa [D12Certificate.pluckerValue, pluckerQuadric] using hplucker q
  have hF2 : C.F * C.F = 1 := by
    rw [hF, d12ActualReflMatrix_sq]
  have hFRFR : C.F * C.R * C.F * C.R = 1 := by
    rw [hF, hR, d12ActualReflRotReflRot]
  apply C.no_common_projective_eigenline hF2 hFRFR hxne
    (by simpa [hP] using hPx) hpl (a := a) (b := b)
  · simpa [hR] using hRx
  · simpa [hF] using hFx

/-- A checked D12 matrix certificate rules out every honest base-field section
of the centralizer-fixed sigma locus. -/
theorem no_centralizer_fixed_section_of_certificate
    (C : D12Certificate.Certificate (Ω := V14SchemeModel.k))
    (hP : C.P = V14SchemeModel.projectorMatrix)
    (hR : C.R = d12ActualRotMatrix)
    (hF : C.F = d12ActualReflMatrix) :
    ¬ ∃ y : Spec (.of V14SchemeModel.k) ⟶
        (fixedByCentralizerAction V14SchemeModel.actionOver sigma).V.left,
      y ≫ (fixedByCentralizerAction V14SchemeModel.actionOver sigma).V.hom =
          𝟙 _ ∧
        ∀ n : Subgroup.centralizer ({sigma} : Set G),
          y ≫ ((fixedByCentralizerAction
            V14SchemeModel.actionOver sigma).ρ n).left = y := by
  change ¬ ∃ y : Spec (.of V14SchemeModel.k) ⟶
        (FixedBy V14SchemeModel.actionOver sigma).left,
      y ≫ (FixedBy V14SchemeModel.actionOver sigma).hom = 𝟙 _ ∧
        ∀ n : Subgroup.centralizer ({sigma} : Set G),
          y ≫ (fixedByCentralizerHom
            V14SchemeModel.actionOver sigma n).left = y
  exact no_centralizer_fixed_section_of_certificate_core C hP hR hF

/-- Terminal reduction for the V14 target: normal specialization and
rational-map constancy reduce nonexistence to the three semantic matrix seals
of a checked D12 certificate.  No dominance hypothesis is imposed on the
rational map. -/
theorem noEquivariantRationalMap_of_d12_certificate
    (X : Action (Over (Spec (.of V14SchemeModel.k))) G)
    [IsIntegral X.V.left]
    {E : Action (Over (Spec (.of V14SchemeModel.k)))
      (Subgroup.centralizer ({sigma} : Set G))}
    [IsIntegral E.V.left]
    (D : EquivariantNormalValuationData
      ((Action.res (Over (Spec (.of V14SchemeModel.k)))
        (Subgroup.subtype _)).obj X) E)
    (hsigma : D.exceptionalFunctionFieldAction (sigmaInCentralizer sigma) =
      𝟙 (Spec (.of E.V.left.functionField)))
    (hconst : ∀ q : Scheme.RationalMap E.V.left
        (fixedByCentralizerAction V14SchemeModel.actionOver sigma).V.left,
      q.IsOver (Spec (.of V14SchemeModel.k)) →
        RationalMapIsConstantOver (E := E.V)
          (Z := (fixedByCentralizerAction
            V14SchemeModel.actionOver sigma).V) q)
    (C : D12Certificate.Certificate (Ω := V14SchemeModel.k))
    (hP : C.P = V14SchemeModel.projectorMatrix)
    (hR : C.R = d12ActualRotMatrix)
    (hF : C.F = d12ActualReflMatrix) :
    ¬ HasEquivariantRationalMap X V14SchemeModel.actionOver := by
  letI : IsProper V14SchemeModel.actionOver.V.hom := by
    change IsProper
      (V14SchemeModel.v14Schemeι ≫
        ProjectiveSpace.toSpec 14 V14SchemeModel.k)
    infer_instance
  exact D.noEquivariantRationalMap_of_constant_fixedSpecialization_section
    X V14SchemeModel.actionOver sigma hsigma hconst
      (no_centralizer_fixed_section_of_certificate C hP hR hF)

end V14Formalization.SchemeGeometry
