/-
Copyright (c) 2026 V14Formalization contributors.
Released under Apache 2.0 license.
-/
import V14Formalization.V14CarrierDimensionFactorization
import V14Formalization.V14FixedPointEquations
import V14Formalization.ProjectiveEigenvectorReduction
import V14Formalization.D12ActionCoreCertificate

/-!
# Dimension-based carrier factorization of V14 fixed field points

This file composes the scheme-theoretic fixed-point equations with the
dimension-based sigma-carrier splitting. The finite certificate interface is
now only two left inverses, two inclusions in the checked ten-dimensional D12
basis, and two sigma-eigenvector identities over the base field; all identities
transport automatically to a field extension.
-/

noncomputable section

open CategoryTheory Matrix
open scoped AlgebraicGeometry

namespace V14Formalization.SchemeGeometry

open AlgebraicGeometry BConicBundleMultisections
open GeometricV14Carrier Lambda2Coordinates
open SigmaProjectorLinearAlgebra

/-- A field-valued point of the scheme-theoretic sigma fixed locus factors
through either the six-dimensional plus carrier or the four-dimensional minus
carrier. The proof uses the checked rank-ten D12 projector factorization. -/
theorem exists_normalizedCoordinates_v14FixedBy_plus_or_minus_carrier_of_dimension
    (L : Type) [Field L] [Algebra V14SchemeModel.k L] [NeZero (2 : L)]
    (p : v14FieldPointOver L ⟶
      FixedBy V14SchemeModel.actionOver GeometricV14Carrier.sigma)
    (Bplus : Matrix (Fin 15) (Fin 6) V14SchemeModel.k)
    (Lplus : Matrix (Fin 6) (Fin 15) V14SchemeModel.k)
    (Bminus : Matrix (Fin 15) (Fin 4) V14SchemeModel.k)
    (Lminus : Matrix (Fin 4) (Fin 15) V14SchemeModel.k)
    (hLBplus : Lplus * Bplus = 1)
    (hLBminus : Lminus * Bminus = 1)
    (hBplus :
      D12ActionCoreCertificate.actionCore.B *
        D12ActionCoreCertificate.actionCore.L * Bplus = Bplus)
    (hBminus :
      D12ActionCoreCertificate.actionCore.B *
        D12ActionCoreCertificate.actionCore.L * Bminus = Bminus)
    (hSplus :
      (lambda2MatrixRepresentation.ρ GeometricV14Carrier.sigma :
        Matrix (Fin 15) (Fin 15) V14SchemeModel.k) * Bplus = Bplus)
    (hSminus :
      (lambda2MatrixRepresentation.ρ GeometricV14Carrier.sigma :
        Matrix (Fin 15) (Fin 15) V14SchemeModel.k) * Bminus = -Bminus) :
    ∃ (j : Fin 15) (x : Fin 15 → L) (a : L),
      x j = 1 ∧
      ambientPointOfV14FixedBy L p =
        ProjectiveSpace.pointOfNormalizedCoordinatesAlgebra
          (R := V14SchemeModel.k) 14 j x ∧
      (V14SchemeModel.projectorMatrix.map
        (algebraMap V14SchemeModel.k L)).mulVec x = x ∧
      (∀ q : Fin 15,
        MvPolynomial.eval x
          (MvPolynomial.map (algebraMap V14SchemeModel.k L)
            (pluckerQuadric V14SchemeModel.k q)) = 0) ∧
      a ≠ 0 ∧
      ((∃ u : Fin 6 → L, u ≠ 0 ∧
          x = (Bplus.map (algebraMap V14SchemeModel.k L)).mulVec u ∧
          a = 1) ∨
        (∃ v : Fin 4 → L, v ≠ 0 ∧
          x = (Bminus.map (algebraMap V14SchemeModel.k L)).mulVec v ∧
          a = -1)) := by
  obtain ⟨j, x, hxj, hxpoint, hPx, hplucker⟩ :=
    exists_normalizedCoordinates_v14FixedBy_projector_fixed L p
  have hambientFixed := (ambientPointOfV14FixedBy_isOver_and_fixed L p).2
  obtain ⟨a, ha, hSx⟩ :=
    exists_eigenScalar_of_mapLinearSubst_fixed
      14
      (↑(lambda2MatrixRepresentation.ρ GeometricV14Carrier.sigma) :
        Matrix (Fin 15) (Fin 15) V14SchemeModel.k)
      (↑((lambda2MatrixRepresentation.ρ
        GeometricV14Carrier.sigma)⁻¹) :
        Matrix (Fin 15) (Fin 15) V14SchemeModel.k)
      (by simp) j x hxj (ambientPointOfV14FixedBy L p) hxpoint
      (by simpa only [projectiveActionHom] using hambientFixed)
  let P : Matrix (Fin 15) (Fin 15) L :=
    V14SchemeModel.projectorMatrix.map (algebraMap V14SchemeModel.k L)
  let S : Matrix (Fin 15) (Fin 15) L :=
    (↑(lambda2MatrixRepresentation.ρ GeometricV14Carrier.sigma) :
      Matrix (Fin 15) (Fin 15) V14SchemeModel.k).map
        (algebraMap V14SchemeModel.k L)
  let B : Matrix (Fin 15) (Fin 10) L :=
    D12ActionCoreCertificate.actionCore.B.map
      (algebraMap V14SchemeModel.k L)
  let Lmat : Matrix (Fin 10) (Fin 15) L :=
    D12ActionCoreCertificate.actionCore.L.map
      (algebraMap V14SchemeModel.k L)
  let Bp : Matrix (Fin 15) (Fin 6) L :=
    Bplus.map (algebraMap V14SchemeModel.k L)
  let Lp : Matrix (Fin 6) (Fin 15) L :=
    Lplus.map (algebraMap V14SchemeModel.k L)
  let Bm : Matrix (Fin 15) (Fin 4) L :=
    Bminus.map (algebraMap V14SchemeModel.k L)
  let Lm : Matrix (Fin 4) (Fin 15) L :=
    Lminus.map (algebraMap V14SchemeModel.k L)
  have hPBbase :
      V14SchemeModel.projectorMatrix *
          D12ActionCoreCertificate.actionCore.B =
        D12ActionCoreCertificate.actionCore.B := by
    change V14SchemeModel.projectorMatrix *
        D12PolynomialEvaluation.evalMatrixK D12PolynomialData.B_poly =
      D12PolynomialEvaluation.evalMatrixK D12PolynomialData.B_poly
    rw [D12RestrictedProjector.projector_mul_B_eq_restrictedProjector,
      D12RestrictedProjector.restrictedProjector_eq_one, Matrix.mul_one]
  have hPplusBase : V14SchemeModel.projectorMatrix * Bplus = Bplus := by
    calc
      V14SchemeModel.projectorMatrix * Bplus =
          V14SchemeModel.projectorMatrix *
            (D12ActionCoreCertificate.actionCore.B *
              D12ActionCoreCertificate.actionCore.L * Bplus) := by
                rw [hBplus]
      _ = (V14SchemeModel.projectorMatrix *
            D12ActionCoreCertificate.actionCore.B) *
              D12ActionCoreCertificate.actionCore.L * Bplus := by
                simp only [Matrix.mul_assoc]
      _ = D12ActionCoreCertificate.actionCore.B *
            D12ActionCoreCertificate.actionCore.L * Bplus := by
              rw [hPBbase]
      _ = Bplus := hBplus
  have hPminusBase : V14SchemeModel.projectorMatrix * Bminus = Bminus := by
    calc
      V14SchemeModel.projectorMatrix * Bminus =
          V14SchemeModel.projectorMatrix *
            (D12ActionCoreCertificate.actionCore.B *
              D12ActionCoreCertificate.actionCore.L * Bminus) := by
                rw [hBminus]
      _ = (V14SchemeModel.projectorMatrix *
            D12ActionCoreCertificate.actionCore.B) *
              D12ActionCoreCertificate.actionCore.L * Bminus := by
                simp only [Matrix.mul_assoc]
      _ = D12ActionCoreCertificate.actionCore.B *
            D12ActionCoreCertificate.actionCore.L * Bminus := by
              rw [hPBbase]
      _ = Bminus := hBminus
  have hfactor : B * Lmat * P = P := by
    dsimp only [B, Lmat, P]
    rw [← Matrix.map_mul, ← Matrix.map_mul]
    exact congrArg
      (fun M : Matrix (Fin 15) (Fin 15) V14SchemeModel.k ↦
        M.map (algebraMap V14SchemeModel.k L))
      D12ActionCoreCertificate.actionCore.projector_factor
  have hLBp : Lp * Bp = 1 := by
    dsimp only [Lp, Bp]
    rw [← Matrix.map_mul, hLBplus]
    ext i j
    simp [Matrix.one_apply]
  have hLBm : Lm * Bm = 1 := by
    dsimp only [Lm, Bm]
    rw [← Matrix.map_mul, hLBminus]
    ext i j
    simp [Matrix.one_apply]
  have hPp : P * Bp = Bp := by
    dsimp only [P, Bp]
    rw [← Matrix.map_mul, hPplusBase]
  have hPm : P * Bm = Bm := by
    dsimp only [P, Bm]
    rw [← Matrix.map_mul, hPminusBase]
  have hSp : S * Bp = Bp := by
    dsimp only [S, Bp]
    rw [← Matrix.map_mul, hSplus]
  have hSm : S * Bm = -Bm := by
    dsimp only [S, Bm]
    rw [← Matrix.map_mul, hSminus]
    ext i j
    simp
  have hS2base :
      (↑(lambda2MatrixRepresentation.ρ GeometricV14Carrier.sigma) :
          Matrix (Fin 15) (Fin 15) V14SchemeModel.k) *
        (↑(lambda2MatrixRepresentation.ρ GeometricV14Carrier.sigma) :
          Matrix (Fin 15) (Fin 15) V14SchemeModel.k) = 1 := by
    have hsigma2 : GeometricV14Carrier.sigma *
        GeometricV14Carrier.sigma = 1 := by
      simpa [pow_two] using GeometricV14Carrier.sigma_isInvolution.1
    have h := congrArg
      (fun g : GeometricV14Carrier.PSL2F11 ↦
        (↑(lambda2MatrixRepresentation.ρ g) :
          Matrix (Fin 15) (Fin 15) V14SchemeModel.k)) hsigma2
    simpa using h
  have hS2 : S * S = 1 := by
    dsimp only [S]
    rw [← Matrix.map_mul, hS2base]
    ext i j
    simp [Matrix.one_apply]
  have hx : x ≠ 0 := by
    intro hzero
    have hone : (1 : L) = 0 := by
      simpa [hxj] using congrFun hzero j
    exact one_ne_zero hone
  have hcarrier := exists_plus_or_minus_carrier_of_eigen
    P S B Lmat Bp Lp Bm Lm hfactor hLBp hLBm hPp hPm hSp hSm
    (by simpa only [P] using hPx)
    (by simpa only [S] using hSx) hx hS2
  exact ⟨j, x, a, hxj, hxpoint, hPx, hplucker, ha,
    by simpa only [Bp, Bm] using hcarrier⟩

end V14Formalization.SchemeGeometry
