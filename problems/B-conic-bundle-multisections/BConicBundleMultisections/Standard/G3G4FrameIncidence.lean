/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import BConicBundleMultisections.Standard.G3G4NonsingularLineSelection
public import BConicBundleMultisections.ResidualComponentExhaustion
public import Mathlib.LinearAlgebra.Matrix.MvPolynomial

/-!
# The invertible-frame incidence over a smooth plane cubic

This file gives explicit affine coordinates for the incidence of invertible `3 x 3` frames whose
first column lies on a fixed smooth plane cubic.  The first column is indexed by the second summand
of `FrameIncidenceCoordinate`; the other two columns are indexed by the first summand.  With this
choice the incidence equation is literally `rename Sum.inr g`.  Splitting the variables by
`MvPolynomial.sumAlgEquiv` therefore identifies its principal ideal with the extension of `(g)` by
six polynomial variables.

The basic intersection theorem below is deliberately affine.  Invertibility is one of the target
principal opens, so a point produced by the Nullstellensatz automatically has nonzero first column;
there is no irrelevant-origin exception to remove.
-/

@[expose] public section

namespace BConicBundleMultisections.Standard

noncomputable section

universe u

open MvPolynomial
open _root_.MvPolynomial
open ResidualDivisor
open scoped Matrix

/-- The six coordinates in the second and third columns of a `3 x 3` frame. -/
abbrev FrameTailCoordinate := Fin 3 × Fin 2

/-- Affine coordinates on the space of `3 x 3` frames.

The first summand records columns one and two, while the second summand records column zero.  This
ordering makes the cubic incidence equation a `rename Sum.inr`. -/
abbrev FrameIncidenceCoordinate := FrameTailCoordinate ⊕ Fin 3

variable {K : Type u} [Field K]

/-- The generic first column of a frame. -/
def genericFramePoint : Fin 3 → MvPolynomial FrameIncidenceCoordinate K :=
  fun i ↦ X (Sum.inr i)

/-- The generic second column of a frame. -/
def genericFrameDirection : Fin 3 → MvPolynomial FrameIncidenceCoordinate K :=
  fun i ↦ X (Sum.inl (i, 0))

/-- The generic third column of a frame. -/
def genericFrameCompletion : Fin 3 → MvPolynomial FrameIncidenceCoordinate K :=
  fun i ↦ X (Sum.inl (i, 1))

/-- The generic matrix, written in the same column convention as `lineFrame`. -/
def genericLineFrame : Matrix (Fin 3) (Fin 3) (MvPolynomial FrameIncidenceCoordinate K) :=
  lineFrame genericFramePoint genericFrameDirection genericFrameCompletion

/-- The determinant cutting out the principal open of invertible frames. -/
def genericLineFrameDet : MvPolynomial FrameIncidenceCoordinate K :=
  (genericLineFrame (K := K)).det

/-- The affine hypersurface equation saying that the first column lies on `g`. -/
def frameIncidenceEquation (g : MvPolynomial (Fin 3) K) :
    MvPolynomial FrameIncidenceCoordinate K :=
  rename Sum.inr g

/-- Coordinates of a concrete frame as a point of affine frame space. -/
def frameCoordinatePoint (p q r : Fin 3 → K) : FrameIncidenceCoordinate → K
  | Sum.inl (i, j) => ![q i, r i] j
  | Sum.inr i => p i

/-- Recover the first column from an arbitrary affine frame-space point. -/
def framePointOfCoordinate (z : FrameIncidenceCoordinate → K) : Fin 3 → K :=
  fun i ↦ z (Sum.inr i)

/-- Recover the second column from an arbitrary affine frame-space point. -/
def frameDirectionOfCoordinate (z : FrameIncidenceCoordinate → K) : Fin 3 → K :=
  fun i ↦ z (Sum.inl (i, 0))

/-- Recover the third column from an arbitrary affine frame-space point. -/
def frameCompletionOfCoordinate (z : FrameIncidenceCoordinate → K) : Fin 3 → K :=
  fun i ↦ z (Sum.inl (i, 1))

omit [Field K] in
/-- The coordinate constructor and the three column projections are mutually exhaustive. -/
@[simp] theorem frameCoordinatePoint_ofCoordinate (z : FrameIncidenceCoordinate → K) :
    frameCoordinatePoint (framePointOfCoordinate z) (frameDirectionOfCoordinate z)
      (frameCompletionOfCoordinate z) = z := by
  funext w
  rcases w with ⟨i, j⟩ | i
  · fin_cases j <;> rfl
  · rfl

omit [Field K] in
@[simp] theorem frameCoordinatePoint_inr (p q r : Fin 3 → K) (i : Fin 3) :
    frameCoordinatePoint p q r (Sum.inr i) = p i := rfl

omit [Field K] in
@[simp] theorem frameCoordinatePoint_inl_zero (p q r : Fin 3 → K) (i : Fin 3) :
    frameCoordinatePoint p q r (Sum.inl (i, 0)) = q i := by
  simp [frameCoordinatePoint]

omit [Field K] in
@[simp] theorem frameCoordinatePoint_inl_one (p q r : Fin 3 → K) (i : Fin 3) :
    frameCoordinatePoint p q r (Sum.inl (i, 1)) = r i := by
  simp [frameCoordinatePoint]

@[simp] theorem eval_genericFramePoint (p q r : Fin 3 → K) (i : Fin 3) :
    eval (frameCoordinatePoint p q r) (genericFramePoint i) = p i := by
  simp [genericFramePoint]

@[simp] theorem eval_genericFrameDirection (p q r : Fin 3 → K) (i : Fin 3) :
    eval (frameCoordinatePoint p q r) (genericFrameDirection i) = q i := by
  simp [genericFrameDirection]

@[simp] theorem eval_genericFrameCompletion (p q r : Fin 3 → K) (i : Fin 3) :
    eval (frameCoordinatePoint p q r) (genericFrameCompletion i) = r i := by
  simp [genericFrameCompletion]

/-- Evaluating the generic frame gives the concrete `lineFrame`. -/
theorem map_genericLineFrame_eval (p q r : Fin 3 → K) :
    (genericLineFrame (K := K)).map (eval (frameCoordinatePoint p q r)) = lineFrame p q r := by
  ext i j
  fin_cases j <;> simp [genericLineFrame, genericFramePoint, genericFrameDirection,
    genericFrameCompletion]

/-- Evaluation of the generic determinant is the determinant of the concrete frame. -/
@[simp] theorem eval_genericLineFrameDet (p q r : Fin 3 → K) :
    eval (frameCoordinatePoint p q r) (genericLineFrameDet (K := K)) =
      (lineFrame p q r).det := by
  rw [genericLineFrameDet, (eval (frameCoordinatePoint p q r)).map_det]
  congr 1
  exact map_genericLineFrame_eval p q r

/-- Evaluation of the incidence equation is evaluation of the cubic at the first column. -/
@[simp] theorem eval_frameIncidenceEquation
    (g : MvPolynomial (Fin 3) K) (p q r : Fin 3 → K) :
    eval (frameCoordinatePoint p q r) (frameIncidenceEquation g) = eval p g := by
  simp [frameIncidenceEquation, eval_rename, Function.comp_def]

/-- Pull a polynomial on the first-column space back to frame space. -/
def frameFirstColumnTarget (H : MvPolynomial (Fin 3) K) :
    MvPolynomial FrameIncidenceCoordinate K :=
  rename Sum.inr H

@[simp] theorem eval_frameFirstColumnTarget
    (H : MvPolynomial (Fin 3) K) (p q r : Fin 3 → K) :
    eval (frameCoordinatePoint p q r) (frameFirstColumnTarget H) = eval p H := by
  simp [frameFirstColumnTarget, eval_rename, Function.comp_def]

/-! ## Integrality of the incidence hypersurface -/

/-- Renaming a prime polynomial into the first-column block remains prime after adjoining the six
other frame coordinates. -/
theorem prime_frameIncidenceEquation_of_prime
    (g : MvPolynomial (Fin 3) K) (hg : Prime g) :
    Prime (frameIncidenceEquation g) := by
  let e :=
    (MvPolynomial.sumAlgEquiv K FrameTailCoordinate (Fin 3)).toRingEquiv
  have heq : e (frameIncidenceEquation g) = C g := by
    change MvPolynomial.sumAlgEquiv K FrameTailCoordinate (Fin 3)
      (rename Sum.inr g) = C g
    have h := DFunLike.congr_fun
      (MvPolynomial.sumAlgEquiv_comp_rename_inr
        (R := K) (S₁ := FrameTailCoordinate) (S₂ := Fin 3)) g
    simpa using h
  have hC : Prime (C g : MvPolynomial FrameTailCoordinate (MvPolynomial (Fin 3) K)) :=
    (MvPolynomial.prime_C_iff FrameTailCoordinate).2 hg
  have heprime : Prime (e (frameIncidenceEquation g)) := by
    rwa [heq]
  exact (MulEquiv.prime_iff e.toMulEquiv).mp heprime

/-- The incidence hypersurface over a smooth cubic has prime defining ideal. -/
theorem isPrime_span_frameIncidenceEquation_of_isSmoothPlaneCubic
    [IsAlgClosed K] (g : MvPolynomial (Fin 3) K) (hsmooth : IsSmoothPlaneCubic g) :
    (Ideal.span ({frameIncidenceEquation g} :
      Set (MvPolynomial FrameIncidenceCoordinate K))).IsPrime := by
  have hp : Prime (frameIncidenceEquation g) :=
    prime_frameIncidenceEquation_of_prime g
      (irreducible_of_isSmoothPlaneCubic g hsmooth).prime
  exact (Ideal.span_singleton_prime hp.ne_zero).2 hp

/-- The determinant principal open is nonempty on the incidence as soon as the cubic has one
nonzero affine-cone point. -/
theorem exists_frameIncidencePoint_det_ne_zero
    (g : MvPolynomial (Fin 3) K)
    (hpoint : ∃ p : Fin 3 → K, p ≠ 0 ∧ eval p g = 0) :
    ∃ z : FrameIncidenceCoordinate → K,
      eval z (frameIncidenceEquation g) = 0 ∧
      eval z (genericLineFrameDet (K := K)) ≠ 0 := by
  obtain ⟨p, hp0, hpg⟩ := hpoint
  obtain ⟨q, hpq⟩ :=
    exists_linearIndependent_pair_of_one_lt_finrank (R := K) (M := Fin 3 → K) (by simp) hp0
  obtain ⟨r, N, hMN⟩ := exists_lineFrame_inverse_of_pair_linearIndependent p q hpq
  refine ⟨frameCoordinatePoint p q r, ?_, ?_⟩
  · simpa using hpg
  · simpa using Matrix.det_ne_zero_of_right_inverse hMN

/-- A nonempty first-column principal open pulls back to a nonempty principal open on the frame
incidence. -/
theorem exists_frameIncidencePoint_firstColumnTarget_ne_zero
    (g H : MvPolynomial (Fin 3) K)
    (hpoint : ∃ p : Fin 3 → K, eval p g = 0 ∧ eval p H ≠ 0) :
    ∃ z : FrameIncidenceCoordinate → K,
      eval z (frameIncidenceEquation g) = 0 ∧
      eval z (frameFirstColumnTarget H) ≠ 0 := by
  obtain ⟨p, hpg, hpH⟩ := hpoint
  exact ⟨frameCoordinatePoint p 0 0, by simpa using hpg, by simpa using hpH⟩

/-! ## Clearing the inverse-frame denominator -/

/-- The coefficient vector of the coordinate residual equation after transporting by `M`, before
transporting the resulting line back by the inverse frame. -/
def transportedResidualCoefficientVector
    {R : Type*} [CommRing R]
    (M : Matrix (Fin 3) (Fin 3) R)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) R) :
    Fin 3 → MvPolynomial (Fin 3) R :=
  let G := secondBlockSubst M F
  ![residualCoeffU_of G, residualCoeffV_of G, residualCoeffW_of G]

/-- Explicit matrix formula for an arbitrary-frame residual-line coefficient.  In particular, the
dependence on the inverse frame `N` is linear. -/
theorem residualLineCoeffOn_eq_matrix_sum
    {R : Type*} [CommRing R]
    (M N : Matrix (Fin 3) (Fin 3) R)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) R) (a : Fin 3) :
    residualLineCoeffOn M N F a =
      ∑ j : Fin 3, C (N j a) * transportedResidualCoefficientVector M F j := by
  classical
  let q := transportedResidualCoefficientVector M F
  have hres : residualEquation (secondBlockSubst M F) =
      ∑ j : Fin 3, liftSecondLinear (q j) j := by
    rw [residualEquation, Fin.sum_univ_three]
    simp [q, transportedResidualCoefficientVector]
  have hstep : ∀ j : Fin 3,
      secondBlockSubst N (liftSecondLinear (q j) j) =
        ∑ l : Fin 3, liftSecondLinear (C (N j l) * q j) l := by
    intro j
    rw [liftSecondLinear, liftFirstBlock, map_mul, secondBlockSubst_rename_inl,
      secondBlockSubst_X_inr, Finset.mul_sum]
    refine Finset.sum_congr rfl fun l _ => ?_
    rw [liftSecondLinear, liftFirstBlock, map_mul, rename_C]
    ring
  have heq : residualEquationOn M N F =
      ∑ l : Fin 3, liftSecondLinear (∑ j : Fin 3, C (N j l) * q j) l := by
    rw [residualEquationOn, hres, map_sum,
      Finset.sum_congr rfl fun j _ => hstep j, Finset.sum_comm]
    exact Finset.sum_congr rfl fun l _ => (liftSecondLinear_sum _ _ l).symm
  simpa [q] using residualLineCoeffOn_eq_of_eq_sum M N F
    (fun l ↦ ∑ j : Fin 3, C (N j l) * q j) heq a

/-- Scaling the inverse-frame matrix scales every residual-line coefficient by the same scalar. -/
theorem residualLineCoeffOn_smul_right
    {R : Type*} [CommRing R]
    (M N : Matrix (Fin 3) (Fin 3) R) (c : R)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) R) (a : Fin 3) :
    residualLineCoeffOn M (c • N) F a = C c * residualLineCoeffOn M N F a := by
  rw [residualLineCoeffOn_eq_matrix_sum, residualLineCoeffOn_eq_matrix_sum,
    Finset.mul_sum]
  refine Finset.sum_congr rfl fun j _ => ?_
  simp only [Matrix.smul_apply, smul_eq_mul, C_mul]
  ring

/-- Every `2 x 2` G3 coefficient minor scales by `c²` when the inverse frame is scaled by `c`. -/
theorem residualLineCoeffMinor_smul_right
    {R : Type*} [CommRing R]
    (M N : Matrix (Fin 3) (Fin 3) R) (c : R)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) R)
    (a b : Fin 3) (m n : Fin 3 →₀ ℕ) :
    coeff m (residualLineCoeffOn M (c • N) F a) *
          coeff n (residualLineCoeffOn M (c • N) F b) -
        coeff n (residualLineCoeffOn M (c • N) F a) *
          coeff m (residualLineCoeffOn M (c • N) F b) =
      c ^ 2 *
        (coeff m (residualLineCoeffOn M N F a) *
            coeff n (residualLineCoeffOn M N F b) -
          coeff n (residualLineCoeffOn M N F a) *
            coeff m (residualLineCoeffOn M N F b)) := by
  simp only [residualLineCoeffOn_smul_right, coeff_C_mul]
  ring

/-- Scaling the matrix used to read frame coordinates by `c` scales the frame-defined tangent
direction of a cubic by `c³`. -/
theorem frameTangentDir_smul_right
    {R : Type*} [CommRing R]
    (M N : Matrix (Fin 3) (Fin 3) R) (c : R)
    (G : MvPolynomial (Fin 3) R) (hG : G.IsHomogeneous 3) (p : Fin 3 → R) :
    frameTangentDir M (c • N) G p = c ^ 3 • frameTangentDir M N G p := by
  let Gb :=
    (aeval (linearSubst 2 M) : MvPolynomial (Fin 3) R →ₐ[R] _) G
  have hGb : Gb.IsHomogeneous 3 := isHomogeneous_aeval_linearSubst M hG
  have hp : Matrix.mulVec (c • N) p = c • Matrix.mulVec N p := by
    rw [Matrix.smul_mulVec]
  have hgrad : tangentGradient Gb (c • Matrix.mulVec N p) =
      c ^ 2 • tangentGradient Gb (Matrix.mulVec N p) := by
    simpa using tangentGradient_smul_point hGb c (Matrix.mulVec N p)
  have hcross : complementaryTangentDir Gb (c • Matrix.mulVec N p) =
      c ^ 3 • complementaryTangentDir Gb (Matrix.mulVec N p) := by
    rw [complementaryTangentDir, hgrad]
    funext i
    fin_cases i <;>
      simp [complementaryTangentDir, cross3, Pi.smul_apply, smul_eq_mul] <;> ring
  change Matrix.mulVec M (complementaryTangentDir Gb (Matrix.mulVec (c • N) p)) =
    c ^ 3 • Matrix.mulVec M (complementaryTangentDir Gb (Matrix.mulVec N p))
  rw [hp, hcross, Matrix.mulVec_smul]

/-- Replacing a true inverse frame by `c` times that inverse scales its frame-tangent residual
representative by `c⁹`. -/
theorem frameTangentResidual_smul_inverse
    (p q r : Fin 3 → K) (N : Matrix (Fin 3) (Fin 3) K)
    (hMN : lineFrame p q r * N = 1) (c : K)
    (G : MvPolynomial (Fin 3) K) (hG : G.IsHomogeneous 3)
    (hp : eval p G = 0) :
    residualAmbientRep p
        (frameTangentDir (lineFrame p q r) (c • N) G p)
        (binaryLineRestriction p
          (frameTangentDir (lineFrame p q r) (c • N) G p) G) =
      c ^ 9 •
        residualAmbientRep p
          (frameTangentDir (lineFrame p q r) N G p)
          (binaryLineRestriction p
            (frameTangentDir (lineFrame p q r) N G p) G) := by
  let d := frameTangentDir (lineFrame p q r) N G p
  let f := binaryLineRestriction p d G
  have hdmem : d ∈ tangentHyperplaneCone G p :=
    frameTangentDir_mem_tangentHyperplaneCone p q r N hMN G
  have hfhom : f.IsHomogeneous 3 := binaryLineRestriction_isHomogeneous hG p d
  obtain ⟨h30, h21⟩ := coeff_binaryLineRestriction_double_contact G hG p d hp hdmem
  have hdir : frameTangentDir (lineFrame p q r) (c • N) G p =
      fun i ↦ c ^ 3 * d i + 0 * p i := by
    have h := frameTangentDir_smul_right (lineFrame p q r) N c G hG p
    change frameTangentDir (lineFrame p q r) (c • N) G p =
      (fun i ↦ c ^ 3 * d i) at h
    simpa only [zero_mul, add_zero] using h
  rw [hdir, binaryLineRestriction_reparam,
    residualAmbientRep_reparam p d (c ^ 3) 0 f hfhom h30 h21]
  funext i
  simp only [Pi.smul_apply, smul_eq_mul]
  ring

/-! ### The adjugate-cleared G3 polynomial -/

/-- Residual-line coefficients commute with extension or specialization of the coefficient ring. -/
theorem map_residualLineCoeffOn
    {R S : Type u} [CommRing R] [CommRing S]
    (f : R →+* S) (M N : Matrix (Fin 3) (Fin 3) R)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) R) (a : Fin 3) :
    map f (residualLineCoeffOn M N F a) =
      residualLineCoeffOn (M.map f) (N.map f) (map f F) a := by
  unfold residualLineCoeffOn
  rw [← map_secondBlockCoeff]
  congr 1
  exact (map_residualEquationOn f M N F).symm

/-- The adjugate of the generic frame, with polynomial entries. -/
def genericLineFrameAdjugate :
    Matrix (Fin 3) (Fin 3) (MvPolynomial FrameIncidenceCoordinate K) :=
  (genericLineFrame (K := K)).adjugate

/-- One fixed `2 x 2` G3 coefficient minor, with the inverse frame replaced by the adjugate.

All entries are polynomials in the nine frame coordinates. -/
def genericG3MinorTarget
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) K)
    (a b : Fin 3) (m n : Fin 3 →₀ ℕ) :
    MvPolynomial FrameIncidenceCoordinate K :=
  let P := MvPolynomial FrameIncidenceCoordinate K
  let M := genericLineFrame (K := K)
  let A := genericLineFrameAdjugate (K := K)
  let FP := map (C : K →+* P) F
  coeff m (residualLineCoeffOn M A FP a) *
      coeff n (residualLineCoeffOn M A FP b) -
    coeff n (residualLineCoeffOn M A FP a) *
      coeff m (residualLineCoeffOn M A FP b)

/-- Specializing the adjugate-cleared G3 target gives the corresponding minor for the concrete
frame and its adjugate. -/
theorem eval_genericG3MinorTarget
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) K)
    (a b : Fin 3) (m n : Fin 3 →₀ ℕ) (p q r : Fin 3 → K) :
    eval (frameCoordinatePoint p q r) (genericG3MinorTarget F a b m n) =
      coeff m (residualLineCoeffOn (lineFrame p q r) (lineFrame p q r).adjugate F a) *
          coeff n (residualLineCoeffOn (lineFrame p q r) (lineFrame p q r).adjugate F b) -
        coeff n (residualLineCoeffOn (lineFrame p q r) (lineFrame p q r).adjugate F a) *
          coeff m (residualLineCoeffOn (lineFrame p q r) (lineFrame p q r).adjugate F b) := by
  let P := MvPolynomial FrameIncidenceCoordinate K
  let φ : P →+* K := eval (frameCoordinatePoint p q r)
  let M := genericLineFrame (K := K)
  let A := genericLineFrameAdjugate (K := K)
  let FP := map (C : K →+* P) F
  have hM : M.map φ = lineFrame p q r := map_genericLineFrame_eval p q r
  have hA : A.map φ = (lineFrame p q r).adjugate := by
    change φ.mapMatrix M.adjugate = _
    rw [RingHom.map_adjugate]
    simpa using congrArg Matrix.adjugate hM
  have hF : map φ FP = F := by
    have hφC : φ.comp (C : K →+* P) = RingHom.id K := by
      ext c
      simp [φ, P]
    dsimp only [FP]
    rw [map_map, hφC, map_id]
  have hcoeff (c : Fin 3) (e : Fin 3 →₀ ℕ) :
      φ (coeff e (residualLineCoeffOn M A FP c)) =
        coeff e (residualLineCoeffOn (lineFrame p q r) (lineFrame p q r).adjugate F c) := by
    rw [← coeff_map, map_residualLineCoeffOn, hM, hA, hF]
  simp only [genericG3MinorTarget, map_sub, map_mul]
  rw [hcoeff a m, hcoeff b n, hcoeff a n, hcoeff b m]

/-- A right inverse identifies the adjugate with the determinant times that inverse. -/
theorem adjugate_eq_det_smul_of_right_inverse
    {R : Type*} [CommRing R]
    (M N : Matrix (Fin 3) (Fin 3) R) (hMN : M * N = 1) :
    M.adjugate = M.det • N := by
  calc
    M.adjugate = M.adjugate * 1 := by rw [Matrix.mul_one]
    _ = M.adjugate * (M * N) := by rw [hMN]
    _ = (M.adjugate * M) * N := by rw [Matrix.mul_assoc]
    _ = (M.det • (1 : Matrix (Fin 3) (Fin 3) R)) * N := by
      rw [Matrix.adjugate_mul]
    _ = M.det • N := by rw [Matrix.smul_mul, Matrix.one_mul]

/-- A framed G3 point of the incidence supplies one concrete adjugate-cleared minor which is
nonzero there. -/
theorem exists_genericG3MinorTarget_ne_zero_at_G3_incidencePoint
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) K)
    (g : MvPolynomial (Fin 3) K)
    (p q r : Fin 3 → K) (N : Matrix (Fin 3) (Fin 3) K)
    (hMN : lineFrame p q r * N = 1)
    (hG3 : ResidualLineNonconstantOn (lineFrame p q r) N F)
    (hpg : eval p g = 0) :
    ∃ (a b : Fin 3) (m n : Fin 3 →₀ ℕ) (z : FrameIncidenceCoordinate → K),
      eval z (frameIncidenceEquation g) = 0 ∧
      eval z (genericG3MinorTarget F a b m n) ≠ 0 := by
  obtain ⟨a, b, m, n, hminor⟩ :=
    (residualLineNonconstantOn_iff_exists_coeff_minor_ne_zero
      (lineFrame p q r) N F).mp hG3
  refine ⟨a, b, m, n, frameCoordinatePoint p q r, by simpa using hpg, ?_⟩
  rw [eval_genericG3MinorTarget,
    adjugate_eq_det_smul_of_right_inverse (lineFrame p q r) N hMN,
    residualLineCoeffMinor_smul_right]
  exact mul_ne_zero (pow_ne_zero 2 (Matrix.det_ne_zero_of_right_inverse hMN)) hminor

/-- Conversely, a nonzero adjugate-cleared minor at an invertible affine frame gives G3 for the
true inverse frame. -/
theorem exists_inverse_residualLineNonconstantOn_of_genericG3MinorTarget_ne_zero
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) K)
    (a b : Fin 3) (m n : Fin 3 →₀ ℕ)
    (z : FrameIncidenceCoordinate → K)
    (hdet : eval z (genericLineFrameDet (K := K)) ≠ 0)
    (hminor : eval z (genericG3MinorTarget F a b m n) ≠ 0) :
    ∃ N : Matrix (Fin 3) (Fin 3) K,
      lineFrame (framePointOfCoordinate z) (frameDirectionOfCoordinate z)
          (frameCompletionOfCoordinate z) * N = 1 ∧
      ResidualLineNonconstantOn
        (lineFrame (framePointOfCoordinate z) (frameDirectionOfCoordinate z)
          (frameCompletionOfCoordinate z)) N F := by
  let p := framePointOfCoordinate z
  let q := frameDirectionOfCoordinate z
  let r := frameCompletionOfCoordinate z
  let M := lineFrame p q r
  have hz : frameCoordinatePoint p q r = z := by
    exact frameCoordinatePoint_ofCoordinate z
  have hdetM : M.det ≠ 0 := by
    rw [← eval_genericLineFrameDet p q r, hz]
    exact hdet
  have hunit : IsUnit M.det := isUnit_iff_ne_zero.mpr hdetM
  let N := M⁻¹
  have hMN : M * N = 1 := M.mul_nonsing_inv hunit
  have hminorAdj :
      coeff m (residualLineCoeffOn M M.adjugate F a) *
            coeff n (residualLineCoeffOn M M.adjugate F b) -
          coeff n (residualLineCoeffOn M M.adjugate F a) *
            coeff m (residualLineCoeffOn M M.adjugate F b) ≠ 0 := by
    rw [← eval_genericG3MinorTarget F a b m n p q r, hz]
    exact hminor
  have hminorN :
      coeff m (residualLineCoeffOn M N F a) *
            coeff n (residualLineCoeffOn M N F b) -
          coeff n (residualLineCoeffOn M N F a) *
            coeff m (residualLineCoeffOn M N F b) ≠ 0 := by
    rw [adjugate_eq_det_smul_of_right_inverse M N hMN,
      residualLineCoeffMinor_smul_right] at hminorAdj
    exact (mul_ne_zero_iff.mp hminorAdj).2
  exact ⟨N, hMN,
    residualLineNonconstantOn_of_coeff_minor_ne_zero M N F a b m n hminorN⟩

/-! ### The adjugate-cleared frame-tangent residual target -/

/-- Evaluation of a homogeneous target on the frame-tangent residual point, with the inverse frame
replaced by the polynomial adjugate.  This is an honest polynomial in the nine frame entries. -/
def genericFrameTangentResidualTarget
    (g H : MvPolynomial (Fin 3) K) : MvPolynomial FrameIncidenceCoordinate K :=
  let P := MvPolynomial FrameIncidenceCoordinate K
  let p := genericFramePoint (K := K)
  let M := genericLineFrame (K := K)
  let A := genericLineFrameAdjugate (K := K)
  let gP := map (C : K →+* P) g
  let HP := map (C : K →+* P) H
  eval
    (residualAmbientRep p (frameTangentDir M A gP p)
      (binaryLineRestriction p (frameTangentDir M A gP p) gP)) HP

/-- Specializing the adjugate-cleared frame-tangent target gives the same construction for the
concrete frame and its adjugate. -/
theorem eval_genericFrameTangentResidualTarget
    (g H : MvPolynomial (Fin 3) K) (p q r : Fin 3 → K) :
    eval (frameCoordinatePoint p q r) (genericFrameTangentResidualTarget g H) =
      eval
        (residualAmbientRep p
          (frameTangentDir (lineFrame p q r) (lineFrame p q r).adjugate g p)
          (binaryLineRestriction p
            (frameTangentDir (lineFrame p q r) (lineFrame p q r).adjugate g p) g)) H := by
  let P := MvPolynomial FrameIncidenceCoordinate K
  let φ : P →+* K := eval (frameCoordinatePoint p q r)
  let pP := genericFramePoint (K := K)
  let M := genericLineFrame (K := K)
  let A := genericLineFrameAdjugate (K := K)
  let gP := map (C : K →+* P) g
  let HP := map (C : K →+* P) H
  have hpP : φ ∘ pP = p := by
    funext i
    exact eval_genericFramePoint p q r i
  have hM : M.map φ = lineFrame p q r := map_genericLineFrame_eval p q r
  have hA : A.map φ = (lineFrame p q r).adjugate := by
    change φ.mapMatrix M.adjugate = _
    rw [RingHom.map_adjugate]
    simpa using congrArg Matrix.adjugate hM
  have hφC : φ.comp (C : K →+* P) = RingHom.id K := by
    ext c
    simp [φ, P]
  have hgP : map φ gP = g := by
    dsimp only [gP]
    rw [map_map, hφC, map_id]
  have hHP : map φ HP = H := by
    dsimp only [HP]
    rw [map_map, hφC, map_id]
  let yP := residualAmbientRep pP (frameTangentDir M A gP pP)
    (binaryLineRestriction pP (frameTangentDir M A gP pP) gP)
  have hyP : φ ∘ yP =
      residualAmbientRep p
        (frameTangentDir (lineFrame p q r) (lineFrame p q r).adjugate g p)
        (binaryLineRestriction p
          (frameTangentDir (lineFrame p q r) (lineFrame p q r).adjugate g p) g) := by
    have hmap := map_frameTangentResidual φ M A gP pP
    rw [hpP, hM, hA, hgP] at hmap
    exact hmap
  change φ (eval yP HP) = _
  rw [MvPolynomial.map_eval, hyP, hHP]

/-- Evaluating a homogeneous target on the adjugate-cleared frame-tangent residual differs from
evaluation using a true inverse only by the displayed determinant power. -/
theorem eval_smul_point_of_isHomogeneous_module
    (H : MvPolynomial (Fin 3) K) {e : ℕ} (hH : H.IsHomogeneous e)
    (c : K) (y : Fin 3 → K) :
    eval (c • y) H = c ^ e * eval y H := by
  change eval (fun i ↦ c * y i) H = c ^ e * eval y H
  exact eval_smul_point_of_isHomogeneous hH c y

theorem eval_frameTangentResidual_adjugate
    (p q r : Fin 3 → K) (N : Matrix (Fin 3) (Fin 3) K)
    (hMN : lineFrame p q r * N = 1)
    (g : MvPolynomial (Fin 3) K) (hg : g.IsHomogeneous 3)
    (hp : eval p g = 0)
    (H : MvPolynomial (Fin 3) K) {e : ℕ} (hH : H.IsHomogeneous e) :
    eval
        (residualAmbientRep p
          (frameTangentDir (lineFrame p q r) (lineFrame p q r).adjugate g p)
          (binaryLineRestriction p
            (frameTangentDir (lineFrame p q r) (lineFrame p q r).adjugate g p) g)) H =
      ((lineFrame p q r).det ^ 9) ^ e *
        eval
          (residualAmbientRep p
            (frameTangentDir (lineFrame p q r) N g p)
            (binaryLineRestriction p
              (frameTangentDir (lineFrame p q r) N g p) g)) H := by
  rw [adjugate_eq_det_smul_of_right_inverse (lineFrame p q r) N hMN,
    frameTangentResidual_smul_inverse p q r N hMN (lineFrame p q r).det g hg hp]
  exact eval_smul_point_of_isHomogeneous_module H hH ((lineFrame p q r).det ^ 9)
    (residualAmbientRep p
      (frameTangentDir (lineFrame p q r) N g p)
      (binaryLineRestriction p (frameTangentDir (lineFrame p q r) N g p) g))

/-- A framed incidence point whose true frame-tangent residual avoids `H` makes the polynomial
adjugate-cleared target nonzero. -/
theorem genericFrameTangentResidualTarget_ne_zero_at_incidencePoint
    (g H : MvPolynomial (Fin 3) K) {e : ℕ}
    (hg : g.IsHomogeneous 3) (hH : H.IsHomogeneous e)
    (p q r : Fin 3 → K) (N : Matrix (Fin 3) (Fin 3) K)
    (hMN : lineFrame p q r * N = 1)
    (hp : eval p g = 0)
    (havoid : eval
      (residualAmbientRep p
        (frameTangentDir (lineFrame p q r) N g p)
        (binaryLineRestriction p (frameTangentDir (lineFrame p q r) N g p) g)) H ≠ 0) :
    eval (frameCoordinatePoint p q r) (genericFrameTangentResidualTarget g H) ≠ 0 := by
  rw [eval_genericFrameTangentResidualTarget,
    eval_frameTangentResidual_adjugate p q r N hMN g hg hp H hH]
  exact mul_ne_zero
    (pow_ne_zero e (pow_ne_zero 9 (Matrix.det_ne_zero_of_right_inverse hMN))) havoid

/-- Conversely, nonvanishing of the adjugate-cleared target at an invertible incidence point gives
nonvanishing for any displayed true inverse. -/
theorem eval_frameTangentResidual_ne_zero_of_genericTarget
    (g H : MvPolynomial (Fin 3) K) {e : ℕ}
    (hg : g.IsHomogeneous 3) (hH : H.IsHomogeneous e)
    (p q r : Fin 3 → K) (N : Matrix (Fin 3) (Fin 3) K)
    (hMN : lineFrame p q r * N = 1)
    (hp : eval p g = 0)
    (hgeneric : eval (frameCoordinatePoint p q r)
      (genericFrameTangentResidualTarget g H) ≠ 0) :
    eval
      (residualAmbientRep p
        (frameTangentDir (lineFrame p q r) N g p)
        (binaryLineRestriction p (frameTangentDir (lineFrame p q r) N g p) g)) H ≠ 0 := by
  rw [eval_genericFrameTangentResidualTarget,
    eval_frameTangentResidual_adjugate p q r N hMN g hg hp H hH] at hgeneric
  exact (mul_ne_zero_iff.mp hgeneric).2

/-! ## Intersecting affine principal opens on a prime hypersurface -/

/-- Four separately nonempty principal opens on a prime affine hypersurface meet.

The proof uses only primality and the affine Nullstellensatz.  The four-target form matches the
frame application: determinant, one G3 coefficient minor, the base discriminant, and the residual
discriminant. -/
theorem exists_affine_point_off_four_targets_of_prime_hypersurface
    [IsAlgClosed K]
    {S : Type*} [Finite S]
    (g H₁ H₂ H₃ H₄ : MvPolynomial S K)
    (hprime : (Ideal.span ({g} : Set (MvPolynomial S K))).IsPrime)
    (h₁ : ∃ z : S → K, eval z g = 0 ∧ eval z H₁ ≠ 0)
    (h₂ : ∃ z : S → K, eval z g = 0 ∧ eval z H₂ ≠ 0)
    (h₃ : ∃ z : S → K, eval z g = 0 ∧ eval z H₃ ≠ 0)
    (h₄ : ∃ z : S → K, eval z g = 0 ∧ eval z H₄ ≠ 0) :
    ∃ z : S → K, eval z g = 0 ∧
      eval z H₁ ≠ 0 ∧ eval z H₂ ≠ 0 ∧ eval z H₃ ≠ 0 ∧ eval z H₄ ≠ 0 := by
  let I : Ideal (MvPolynomial S K) := Ideal.span ({g} : Set _)
  have hnot (H : MvPolynomial S K)
      (hH : ∃ z : S → K, eval z g = 0 ∧ eval z H ≠ 0) : H ∉ I := by
    rintro hmem
    obtain ⟨z, hzg, hzH⟩ := hH
    obtain ⟨a, ha⟩ := Ideal.mem_span_singleton.mp hmem
    apply hzH
    rw [ha, eval_mul, hzg, zero_mul]
  have hprodNot : H₁ * H₂ * H₃ * H₄ ∉ I := by
    intro hmem
    obtain hleft | hfour := hprime.mem_or_mem hmem
    · obtain hleft' | hthree := hprime.mem_or_mem hleft
      · obtain hone | htwo := hprime.mem_or_mem hleft'
        · exact hnot H₁ h₁ hone
        · exact hnot H₂ h₂ htwo
      · exact hnot H₃ h₃ hthree
    · exact hnot H₄ h₄ hfour
  have hprodNotRad : H₁ * H₂ * H₃ * H₄ ∉ I.radical := by
    have hIprime : I.IsPrime := hprime
    rw [hIprime.radical]
    exact hprodNot
  have hexists : ∃ z : S → K, eval z g = 0 ∧ eval z (H₁ * H₂ * H₃ * H₄) ≠ 0 := by
    by_contra hex
    apply hprodNotRad
    rw [← MvPolynomial.vanishingIdeal_zeroLocus_eq_radical (K := K)]
    rw [MvPolynomial.mem_vanishingIdeal_iff]
    intro z hz
    rw [MvPolynomial.mem_zeroLocus_iff] at hz
    have hzg : eval z g = 0 := hz g (Ideal.subset_span (by simp))
    by_contra hzprod
    exact hex ⟨z, hzg, hzprod⟩
  obtain ⟨z, hzg, hzprod⟩ := hexists
  simp only [eval_mul, mul_ne_zero_iff] at hzprod
  exact ⟨z, hzg, hzprod.1.1.1, hzprod.1.1.2, hzprod.1.2, hzprod.2⟩

/-! ## The concrete four-open intersection -/

/-- The determinant, G3, base-target, and frame-tangent-residual opens meet on the prime affine
frame incidence.

The two displayed input points only certify that the G3 open and the two target opens are nonempty.
The output is a new common frame.  No openness or incidence statement is assumed. -/
theorem exists_commonFrame_of_G3_incidencePoint_of_frameTangent_targetPoint
    [IsAlgClosed K]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) K)
    (g H : MvPolynomial (Fin 3) K) {e : ℕ}
    (hsmooth : IsSmoothPlaneCubic g) (hH : H.IsHomogeneous e)
    (p₃ q₃ r₃ : Fin 3 → K) (N₃ : Matrix (Fin 3) (Fin 3) K)
    (hMN₃ : lineFrame p₃ q₃ r₃ * N₃ = 1)
    (hG3₃ : ResidualLineNonconstantOn (lineFrame p₃ q₃ r₃) N₃ F)
    (hp₃g : eval p₃ g = 0)
    (p₄ q₄ r₄ : Fin 3 → K) (N₄ : Matrix (Fin 3) (Fin 3) K)
    (hMN₄ : lineFrame p₄ q₄ r₄ * N₄ = 1)
    (hp₄g : eval p₄ g = 0) (hp₄H : eval p₄ H ≠ 0)
    (hres₄ : eval
      (residualAmbientRep p₄
        (frameTangentDir (lineFrame p₄ q₄ r₄) N₄ g p₄)
        (binaryLineRestriction p₄
          (frameTangentDir (lineFrame p₄ q₄ r₄) N₄ g p₄) g)) H ≠ 0) :
    ∃ (p q r : Fin 3 → K) (N : Matrix (Fin 3) (Fin 3) K),
      lineFrame p q r * N = 1 ∧
      ResidualLineNonconstantOn (lineFrame p q r) N F ∧
      p ≠ 0 ∧ eval p g = 0 ∧ eval p H ≠ 0 ∧
      eval
        (residualAmbientRep p
          (frameTangentDir (lineFrame p q r) N g p)
          (binaryLineRestriction p (frameTangentDir (lineFrame p q r) N g p) g)) H ≠ 0 := by
  obtain ⟨a, b, m, n, z₃, hz₃g, hz₃minor⟩ :=
    exists_genericG3MinorTarget_ne_zero_at_G3_incidencePoint
      F g p₃ q₃ r₃ N₃ hMN₃ hG3₃ hp₃g
  let z₄ := frameCoordinatePoint p₄ q₄ r₄
  have hdetOpen : ∃ z : FrameIncidenceCoordinate → K,
      eval z (frameIncidenceEquation g) = 0 ∧
      eval z (genericLineFrameDet (K := K)) ≠ 0 := by
    refine ⟨z₄, by simpa [z₄] using hp₄g, ?_⟩
    simpa [z₄] using Matrix.det_ne_zero_of_right_inverse hMN₄
  have hG3Open : ∃ z : FrameIncidenceCoordinate → K,
      eval z (frameIncidenceEquation g) = 0 ∧
      eval z (genericG3MinorTarget F a b m n) ≠ 0 :=
    ⟨z₃, hz₃g, hz₃minor⟩
  have hbaseOpen : ∃ z : FrameIncidenceCoordinate → K,
      eval z (frameIncidenceEquation g) = 0 ∧
      eval z (frameFirstColumnTarget H) ≠ 0 := by
    refine ⟨z₄, by simpa [z₄] using hp₄g, ?_⟩
    simpa [z₄] using hp₄H
  have hresOpen : ∃ z : FrameIncidenceCoordinate → K,
      eval z (frameIncidenceEquation g) = 0 ∧
      eval z (genericFrameTangentResidualTarget g H) ≠ 0 := by
    refine ⟨z₄, by simpa [z₄] using hp₄g, ?_⟩
    exact genericFrameTangentResidualTarget_ne_zero_at_incidencePoint
      g H hsmooth.1 hH p₄ q₄ r₄ N₄ hMN₄ hp₄g hres₄
  have hprime := isPrime_span_frameIncidenceEquation_of_isSmoothPlaneCubic g hsmooth
  obtain ⟨z, hzg, hzdet, hzG3, hzbase, hzres⟩ :=
    exists_affine_point_off_four_targets_of_prime_hypersurface
      (frameIncidenceEquation g)
      (genericLineFrameDet (K := K)) (genericG3MinorTarget F a b m n)
      (frameFirstColumnTarget H) (genericFrameTangentResidualTarget g H)
      hprime hdetOpen hG3Open hbaseOpen hresOpen
  let p := framePointOfCoordinate z
  let q := frameDirectionOfCoordinate z
  let r := frameCompletionOfCoordinate z
  have hzeta : frameCoordinatePoint p q r = z := frameCoordinatePoint_ofCoordinate z
  have hp : eval p g = 0 := by
    have : eval (frameCoordinatePoint p q r) (frameIncidenceEquation g) = 0 := by
      rwa [hzeta]
    simpa using this
  have hpH : eval p H ≠ 0 := by
    have : eval (frameCoordinatePoint p q r) (frameFirstColumnTarget H) ≠ 0 := by
      rwa [hzeta]
    simpa using this
  obtain ⟨N, hMNz, hG3z⟩ :=
    exists_inverse_residualLineNonconstantOn_of_genericG3MinorTarget_ne_zero
      F a b m n z hzdet hzG3
  have hMN : lineFrame p q r * N = 1 := by
    simpa [p, q, r] using hMNz
  have hG3 : ResidualLineNonconstantOn (lineFrame p q r) N F := by
    simpa [p, q, r] using hG3z
  have hp0 : p ≠ 0 := by
    intro hpzero
    have hdetM : (lineFrame p q r).det ≠ 0 := Matrix.det_ne_zero_of_right_inverse hMN
    apply hdetM
    apply Matrix.det_eq_zero_of_column_eq_zero 0
    intro i
    simp [lineFrame_apply, hpzero]
  have hzres' : eval (frameCoordinatePoint p q r)
      (genericFrameTangentResidualTarget g H) ≠ 0 := by
    rwa [hzeta]
  have hres := eval_frameTangentResidual_ne_zero_of_genericTarget
    g H hsmooth.1 hH p q r N hMN hp hzres'
  exact ⟨p, q, r, N, hMN, hG3, hp0, hp, hpH, hres⟩

/-! ## Application to the two discriminant opens -/

/-- The pointwise-G4 construction gives a nonempty point of both concrete discriminant opens on
the fixed smooth-cubic frame incidence. -/
theorem exists_nonsingularFrameOpenPoint_on_smooth_cubic
    [IsAlgClosed K] [NeZero (2 : K)] [NeZero (3 : K)]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) K) (hF : IsBidegree23 F)
    (x : Fin 3 → K)
    (hsmooth : IsSmoothPlaneCubic (specializeFirstCoordinates (n := 2) x F))
    (hproper : ∃ y : Fin 3 → K,
      y ≠ 0 ∧
      eval y (specializeFirstCoordinates (n := 2) x F) = 0 ∧
      eval y (sndConicDiscriminant F) ≠ 0) :
    ∃ (p q r : Fin 3 → K) (N : Matrix (Fin 3) (Fin 3) K),
      lineFrame p q r * N = 1 ∧
      p ≠ 0 ∧
      eval p (specializeFirstCoordinates (n := 2) x F) = 0 ∧
      eval p (sndConicDiscriminant F) ≠ 0 ∧
      eval
        (residualAmbientRep p
          (frameTangentDir (lineFrame p q r) N
            (specializeFirstCoordinates (n := 2) x F) p)
          (binaryLineRestriction p
            (frameTangentDir (lineFrame p q r) N
              (specializeFirstCoordinates (n := 2) x F) p)
            (specializeFirstCoordinates (n := 2) x F)))
        (sndConicDiscriminant F) ≠ 0 := by
  let g := specializeFirstCoordinates (n := 2) x F
  obtain ⟨p, q, hp0, hp, hpdisc, hpq, hq, hresdisc⟩ :=
    exists_tangentResidual_base_and_image_avoid_homogeneous_target
      g hsmooth (sndConicDiscriminant F)
      (sndConicDiscriminant_isHomogeneous F hF) (by norm_num) hproper
  obtain ⟨r, N, hMN⟩ := exists_lineFrame_inverse_of_pair_linearIndependent p q hpq
  have hframeDisc :
      eval
        (residualAmbientRep p
          (frameTangentDir (lineFrame p q r) N g p)
          (binaryLineRestriction p (frameTangentDir (lineFrame p q r) N g p) g))
        (sndConicDiscriminant F) ≠ 0 := by
    exact eval_frameTangentResidual_ne_zero_of_smooth_tangent
      p q r N hMN g hsmooth hp hq
      (sndConicDiscriminant F) 9 (sndConicDiscriminant_isHomogeneous F hF) hresdisc
  exact ⟨p, q, r, N, hMN, hp0, hp, hpdisc, hframeDisc⟩

/-- A single G3 frame whose first column lies on the fixed smooth cubic is enough: the explicit
prime-incidence intersection above combines it with the already-proved nonempty G4 frame open. -/
theorem hasG3NonsingularFrameIntersectionAt_of_G3_incidencePoint
    [IsAlgClosed K] [NeZero (2 : K)] [NeZero (3 : K)]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) K) (hF : IsBidegree23 F)
    (x : Fin 3 → K)
    (hsmooth : IsSmoothPlaneCubic (specializeFirstCoordinates (n := 2) x F))
    (hproper : ∃ y : Fin 3 → K,
      y ≠ 0 ∧
      eval y (specializeFirstCoordinates (n := 2) x F) = 0 ∧
      eval y (sndConicDiscriminant F) ≠ 0)
    (p₃ q₃ r₃ : Fin 3 → K) (N₃ : Matrix (Fin 3) (Fin 3) K)
    (hMN₃ : lineFrame p₃ q₃ r₃ * N₃ = 1)
    (hG3₃ : ResidualLineNonconstantOn (lineFrame p₃ q₃ r₃) N₃ F)
    (hp₃g : eval p₃ (specializeFirstCoordinates (n := 2) x F) = 0) :
    HasG3NonsingularFrameIntersectionAt F x := by
  obtain ⟨p₄, q₄, r₄, N₄, hMN₄, hp₄0, hp₄g, hp₄disc, hres₄⟩ :=
    exists_nonsingularFrameOpenPoint_on_smooth_cubic F hF x hsmooth hproper
  obtain ⟨p, q, r, N, hMN, hG3, hp0, hp, hpdisc, hres⟩ :=
    exists_commonFrame_of_G3_incidencePoint_of_frameTangent_targetPoint
      F (specializeFirstCoordinates (n := 2) x F) (sndConicDiscriminant F)
      hsmooth (sndConicDiscriminant_isHomogeneous F hF)
      p₃ q₃ r₃ N₃ hMN₃ hG3₃ hp₃g
      p₄ q₄ r₄ N₄ hMN₄ hp₄g hp₄disc hres₄
  exact ⟨p, q, r, N, hMN, hG3, hp0, hp, hpdisc, hres⟩

end

end BConicBundleMultisections.Standard
