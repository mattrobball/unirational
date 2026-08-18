/-
Copyright (c) 2026 V14Formalization contributors.
Released under Apache 2.0 license.
-/
module

public import V14Formalization.ProjectiveEigenvectorReduction
public import V14Formalization.V14FixedPointEquations
public import V14Formalization.V14ProjectorEigenspaceFactorization

/-!
# Carrier factorization of field-valued V14 fixed points

This file composes the scheme-theoretic fixed-point equations with the general
projective eigenvector theorem and the abstract projector/involution splitting.
The only remaining inputs are the finite matrix factorizations identifying the
plus and minus carrier bases.
-/

noncomputable section

open CategoryTheory Matrix
open scoped AlgebraicGeometry

namespace V14Formalization.SchemeGeometry

open AlgebraicGeometry BConicBundleMultisections
open GeometricV14Carrier Lambda2Coordinates
open SigmaProjectorLinearAlgebra

/-- A field-valued point of the scheme-theoretic sigma fixed locus factors
through either the supplied plus carrier or the supplied minus carrier.

The matrices `Bplus, Lplus, Bminus, Lminus` are the finite certificate
interface.  Everything before their two factorization identities is proved
from the actual V14 scheme action. -/
public theorem exists_normalizedCoordinates_v14FixedBy_plus_or_minus_carrier
    (L : Type) [Field L] [Algebra V14SchemeModel.k L] [NeZero (2 : L)]
    (p : v14FieldPointOver L ⟶
      FixedBy V14SchemeModel.actionOver GeometricV14Carrier.sigma)
    (Bplus : Matrix (Fin 15) (Fin 6) L)
    (Lplus : Matrix (Fin 6) (Fin 15) L)
    (Bminus : Matrix (Fin 15) (Fin 4) L)
    (Lminus : Matrix (Fin 4) (Fin 15) L)
    (hBLplus : Bplus * Lplus =
      plusProjector
        (V14SchemeModel.projectorMatrix.map
          (algebraMap V14SchemeModel.k L))
        ((lambda2MatrixRepresentation.ρ GeometricV14Carrier.sigma :
          Matrix (Fin 15) (Fin 15) V14SchemeModel.k).map
            (algebraMap V14SchemeModel.k L)))
    (hBLminus : Bminus * Lminus =
      minusProjector
        (V14SchemeModel.projectorMatrix.map
          (algebraMap V14SchemeModel.k L))
        ((lambda2MatrixRepresentation.ρ GeometricV14Carrier.sigma :
          Matrix (Fin 15) (Fin 15) V14SchemeModel.k).map
            (algebraMap V14SchemeModel.k L))) :
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
      ((a = 1 ∧
          (plusProjector
            (V14SchemeModel.projectorMatrix.map
              (algebraMap V14SchemeModel.k L))
            ((lambda2MatrixRepresentation.ρ GeometricV14Carrier.sigma :
              Matrix (Fin 15) (Fin 15) V14SchemeModel.k).map
                (algebraMap V14SchemeModel.k L))).mulVec x = x ∧
          x = Bplus.mulVec (Lplus.mulVec x)) ∨
        (a = -1 ∧
          (minusProjector
            (V14SchemeModel.projectorMatrix.map
              (algebraMap V14SchemeModel.k L))
            ((lambda2MatrixRepresentation.ρ GeometricV14Carrier.sigma :
              Matrix (Fin 15) (Fin 15) V14SchemeModel.k).map
                (algebraMap V14SchemeModel.k L))).mulVec x = x ∧
          x = Bminus.mulVec (Lminus.mulVec x))) := by
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
  have hP2 : P * P = P := by
    dsimp only [P]
    rw [← Matrix.map_mul]
    exact congrArg
      (fun M : Matrix (Fin 15) (Fin 15) V14SchemeModel.k ↦
        M.map (algebraMap V14SchemeModel.k L))
      V14SchemeModel.projectorMatrix_idempotent
  have hPS : P * S = S * P := by
    dsimp only [P, S]
    rw [← Matrix.map_mul, ← Matrix.map_mul]
    exact congrArg
      (fun M : Matrix (Fin 15) (Fin 15) V14SchemeModel.k ↦
        M.map (algebraMap V14SchemeModel.k L))
      (V14SchemeModel.projectorMatrix_commutes GeometricV14Carrier.sigma)
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
  have hcarrier := fin15_eq_plus6_or_minus4_carrier
    P S Bplus Lplus Bminus Lminus x a hP2 hPS hS2
    (by simpa only [P] using hPx) hx
    (by simpa only [S] using hSx)
    (by simpa only [P, S] using hBLplus)
    (by simpa only [P, S] using hBLminus)
  exact ⟨j, x, a, hxj, hxpoint, hPx, hplucker, ha,
    by simpa only [P, S] using hcarrier⟩

end V14Formalization.SchemeGeometry
