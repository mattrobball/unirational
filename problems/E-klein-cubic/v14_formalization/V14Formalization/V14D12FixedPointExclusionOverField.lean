/-
Copyright (c) 2026 V14Formalization contributors.
Released under Apache 2.0 license.
-/
module

public import V14Formalization.D12CertificateOverField
public import V14Formalization.V14D12FixedPointExclusion
public import V14Formalization.SchemeModelAliases

/-!
# Hypothesis (b) over an arbitrary field

`V14D12FixedPointExclusion.no_centralizer_fixed_section_of_certificate` rules
out a `k`-point of the sigma fixed locus that is fixed by the whole centralizer
`N = D₁₂`, where `k = ℚ(ζ₁₁)`.  A statement about `k`-points says nothing about
`L`-points for a larger field `L`, and hypothesis (b) of the paper is
`V₁₄^N = ∅`, which is a statement about points over *every* field.

This file proves it over every field: `V₁₄^{D₁₂}(L) = ∅` for every field `L`
receiving a ring map from `ℚ(ζ₁₁)`.  The only new input is
`D12CertificateK.certificateOver`, the base-changed four-piece certificate; all
the point-extraction machinery (`exists_normalizedCoordinates_v14FixedBy_*`,
`exists_eigenScalar_of_mapLinearSubst_fixed`,
`V14SchemeModel.fixed_comp_v14Schemeι`) was already stated over an arbitrary
field over `k`.
-/

noncomputable section

open CategoryTheory Matrix
open scoped AlgebraicGeometry

namespace V14Formalization.SchemeGeometry

open AlgebraicGeometry BConicBundleMultisections
open GeometricV14Carrier Lambda2Coordinates
open D12Certificate

/-- No point of the scheme-theoretic sigma fixed locus with values in *any*
field over the cyclotomic base is fixed by the whole centralizer of `σ`.
This is hypothesis (b), `V₁₄^{D₁₂} = ∅`, in its base-change-stable form. -/
public theorem no_centralizer_fixed_point_over
    (L : Type) [Field L] [Algebra V14SchemeModel.k L] :
    ¬ ∃ y : Spec (.of L) ⟶ (FixedBy V14SchemeModel.actionOver sigma).left,
      y ≫ (FixedBy V14SchemeModel.actionOver sigma).hom =
          Spec.map (CommRingCat.ofHom (algebraMap V14SchemeModel.k L)) ∧
        ∀ n : Subgroup.centralizer ({sigma} : Set G),
          y ≫ (fixedByCentralizerHom V14SchemeModel.actionOver sigma n).left =
            y := by
  rintro ⟨y, hybase, hyfixed⟩
  set C := D12CertificateK.certificateOver L with hCdef
  let p : v14FieldPointOver L ⟶
      FixedBy V14SchemeModel.actionOver sigma :=
    Over.homMk y hybase
  obtain ⟨j, x, hxj, hxpoint, hPx, hplucker⟩ :=
    exists_normalizedCoordinates_v14FixedBy_projector_fixed L p
  let z : Spec (.of L) ⟶ V14SchemeModel.actionOver.V.left :=
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
  have hambR : ambientPointOfV14FixedBy L p ≫
        projectiveActionHom lambda2MatrixRepresentation.ρ
          (CentralizerN.rotGen : G) =
      ambientPointOfV14FixedBy L p :=
    V14SchemeModel.fixed_comp_v14Schemeι
      (CentralizerN.rotGen : G) z (hzfixed CentralizerN.rotGen)
  have hambF : ambientPointOfV14FixedBy L p ≫
        projectiveActionHom lambda2MatrixRepresentation.ρ
          (CentralizerN.reflGen : G) =
      ambientPointOfV14FixedBy L p :=
    V14SchemeModel.fixed_comp_v14Schemeι
      (CentralizerN.reflGen : G) z (hzfixed CentralizerN.reflGen)
  obtain ⟨a, _ha, hRx⟩ :=
    exists_eigenScalar_of_mapLinearSubst_fixed
      (L := L) 14 d12ActualRotMatrix actualRotInv
      (by simp [d12ActualRotMatrix, actualRotInv]) j x hxj
      (ambientPointOfV14FixedBy L p) hxpoint
      (by simpa only [projectiveActionHom, d12ActualRotMatrix,
        actualRotInv] using hambR)
  obtain ⟨b, _hb, hFx⟩ :=
    exists_eigenScalar_of_mapLinearSubst_fixed
      (L := L) 14 d12ActualReflMatrix actualReflInv
      (by simp [d12ActualReflMatrix, actualReflInv]) j x hxj
      (ambientPointOfV14FixedBy L p) hxpoint
      (by simpa only [projectiveActionHom, d12ActualReflMatrix,
        actualReflInv] using hambF)
  have hxne : x ≠ 0 := by
    intro hxzero
    have : (1 : L) = 0 := by simpa [hxj] using congrFun hxzero j
    exact one_ne_zero this
  have hpl : ∀ q : Fin 15, D12Certificate.pluckerValue x q = 0 := by
    intro q
    simpa [D12Certificate.pluckerValue, pluckerQuadric] using hplucker q
  have hF2 : C.F * C.F = 1 := by
    have h := congrArg (fun M : Matrix (Fin 15) (Fin 15) V14SchemeModel.k =>
      M.map (algebraMap V14SchemeModel.k L)) d12ActualReflMatrix_sq
    rw [Matrix.map_mul] at h
    rw [hCdef]
    simpa only [D12CertificateK.certificateOver_F, D12CertificateK.certificate_F,
      Matrix.map_one _ (map_zero _) (map_one _)] using h
  have hFRFR : C.F * C.R * C.F * C.R = 1 := by
    have h := congrArg (fun M : Matrix (Fin 15) (Fin 15) V14SchemeModel.k =>
      M.map (algebraMap V14SchemeModel.k L)) d12ActualReflRotReflRot
    rw [Matrix.map_mul, Matrix.map_mul, Matrix.map_mul] at h
    rw [hCdef]
    simpa only [D12CertificateK.certificateOver_F, D12CertificateK.certificateOver_R,
      D12CertificateK.certificate_F, D12CertificateK.certificate_R,
      Matrix.map_one _ (map_zero _) (map_one _)] using h
  refine C.no_common_projective_eigenline hF2 hFRFR hxne ?_ hpl
    (a := a) (b := b) ?_ ?_
  · rw [hCdef]
    simpa only [D12CertificateK.certificateOver_P,
      D12CertificateK.certificate_P] using hPx
  · rw [hCdef]
    simpa only [D12CertificateK.certificateOver_R,
      D12CertificateK.certificate_R] using hRx
  · rw [hCdef]
    simpa only [D12CertificateK.certificateOver_F,
      D12CertificateK.certificate_F] using hFx

end V14Formalization.SchemeGeometry
