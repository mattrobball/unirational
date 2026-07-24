/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import BConicBundleMultisections.BinaryResultant
public import BConicBundleMultisections.PlaneCubicTangentForm
public import BConicBundleMultisections.ProjectiveLineRestriction

/-!
# Coordinate-line restriction and the universal tangent-polar resultant

This file packages the algebraic setup for the universal residual identity on a plane cubic:
restriction to the last-coordinate hyperplane (specialized to a coordinate line in the plane),
the first polar, its universal coefficient-ring form, and the fixed `(3,2)` resultant of the
coordinate-line cubic against that polar.

The identity `Res(g,P) + Δ(g) F = W² q` is proved in a later module; this file only installs the
shared constructions and their specialization lemmas.
-/

@[expose] public section

open MvPolynomial

namespace BConicBundleMultisections

noncomputable section

universe u v

variable {R : Type u} [CommSemiring R]

/-- Restrict a polynomial in the homogeneous coordinates of projective `n`-space to the
coordinate hyperplane on which the last coordinate vanishes. -/
def lastCoordinateHyperplaneRestriction (n : ℕ) :
    MvPolynomial (Fin (n + 1)) R →ₐ[R] MvPolynomial (Fin n) R :=
  aeval (Fin.lastCases 0 X)

/-- The coordinate inclusion underlying `lastCoordinateHyperplaneRestriction`. -/
def lastCoordinateHyperplanePoint (n : ℕ) (p : Fin n → R) : Fin (n + 1) → R :=
  Fin.lastCases 0 p

@[simp]
theorem lastCoordinateHyperplaneRestriction_X_castSucc (n : ℕ) (i : Fin n) :
    lastCoordinateHyperplaneRestriction (R := R) n (X i.castSucc) = X i := by
  simp [lastCoordinateHyperplaneRestriction]

@[simp]
theorem lastCoordinateHyperplaneRestriction_X_last (n : ℕ) :
    lastCoordinateHyperplaneRestriction (R := R) n (X (Fin.last n)) = 0 := by
  simp [lastCoordinateHyperplaneRestriction]

@[simp]
theorem lastCoordinateHyperplaneRestriction_C (n : ℕ) (r : R) :
    lastCoordinateHyperplaneRestriction (R := R) n (C r) = C r := by
  simp [lastCoordinateHyperplaneRestriction]

/-- Restriction to the last coordinate hyperplane preserves homogeneous degree. -/
theorem lastCoordinateHyperplaneRestriction_isHomogeneous
    {n d : ℕ} {f : MvPolynomial (Fin (n + 1)) R} (hf : f.IsHomogeneous d) :
    (lastCoordinateHyperplaneRestriction n f).IsHomogeneous d := by
  unfold lastCoordinateHyperplaneRestriction
  let g : Fin (n + 1) → MvPolynomial (Fin n) R :=
    Fin.lastCases 0 X
  have hg : ∀ i, (g i).IsHomogeneous 1 := by
    intro i
    dsimp [g]
    refine Fin.lastCases ?_ (fun j ↦ ?_) i
    · simpa only [Fin.lastCases_last] using isHomogeneous_zero (Fin n) R 1
    · simpa only [Fin.lastCases_castSucc] using isHomogeneous_X R j
  simpa only [one_mul] using hf.aeval g hg

/-- Evaluation after coordinate-hyperplane restriction is evaluation at the point obtained by
appending a zero last coordinate. -/
theorem eval_lastCoordinateHyperplaneRestriction
    {n : ℕ} (p : Fin n → R) (f : MvPolynomial (Fin (n + 1)) R) :
    eval p (lastCoordinateHyperplaneRestriction n f) =
      eval (lastCoordinateHyperplanePoint n p) f := by
  unfold lastCoordinateHyperplaneRestriction lastCoordinateHyperplanePoint
  change eval p (eval₂ C (Fin.lastCases 0 X) f) = _
  rw [eval_eval₂]
  rw [show (eval p).comp C = RingHom.id R by ext r; simp]
  apply eval₂_congr
  intro i c hi hc
  refine Fin.lastCases ?_ (fun j ↦ ?_) i
  · simp
  · simp

/-- Coefficient maps commute with restriction to the last coordinate hyperplane. -/
theorem map_lastCoordinateHyperplaneRestriction
    {S : Type v} [CommSemiring S] (n : ℕ) (f : MvPolynomial (Fin (n + 1)) R)
    (phi : R →+* S) :
    MvPolynomial.map phi (lastCoordinateHyperplaneRestriction n f) =
      lastCoordinateHyperplaneRestriction n (MvPolynomial.map phi f) := by
  unfold lastCoordinateHyperplaneRestriction
  change MvPolynomial.map phi (eval₂ C (Fin.lastCases 0 X) f) =
    eval₂ C (Fin.lastCases 0 X) (MvPolynomial.map phi f)
  rw [MvPolynomial.map_eval₂]
  congr 1
  funext i
  refine Fin.lastCases ?_ (fun j ↦ ?_) i <;> simp

/-- The first polar of `f` with pole `q`. -/
def firstPolar {σ : Type v} [Fintype σ] (f : MvPolynomial σ R)
    (q : σ → R) : MvPolynomial σ R :=
  ∑ i : σ, C (q i) * pderiv i f

/-- The first polar of a degree-`d` form is homogeneous of degree `d - 1`. -/
theorem firstPolar_isHomogeneous {σ : Type v} [Fintype σ] {d : ℕ}
    {f : MvPolynomial σ R} (hf : f.IsHomogeneous d)
    (q : σ → R) : (firstPolar f q).IsHomogeneous (d - 1) := by
  apply (homogeneousSubmodule σ R (d - 1)).sum_mem
  intro i hi
  exact hf.pderiv.C_mul (q i)

/-- Evaluating the first polar at `p` agrees with evaluating the tangent form at its pole. -/
theorem eval_firstPolar {σ : Type v} [Fintype σ] (f : MvPolynomial σ R)
    (p q : σ → R) :
    eval p (firstPolar f q) = eval q (tangentForm f p) := by
  simp [firstPolar, eval_tangentForm, mul_comm]

/-- The universal first polar, with the base point constrained to the last coordinate
hyperplane and with the target coordinates retained in the coefficient ring. -/
def universalLastCoordinateFirstPolar (n : ℕ)
    (f : MvPolynomial (Fin (n + 1)) R) :
    MvPolynomial (Fin n) (MvPolynomial (Fin (n + 1)) R) :=
  ∑ i : Fin (n + 1), C (X i) *
    MvPolynomial.map (C : R →+* MvPolynomial (Fin (n + 1)) R)
      (lastCoordinateHyperplaneRestriction n (pderiv i f))

/-- In the constrained base-point variables, the universal first polar of a degree-`d` form is
homogeneous of degree `d - 1`. -/
theorem universalLastCoordinateFirstPolar_isHomogeneous {n d : ℕ}
    {f : MvPolynomial (Fin (n + 1)) R} (hf : f.IsHomogeneous d) :
    (universalLastCoordinateFirstPolar n f).IsHomogeneous (d - 1) := by
  apply (homogeneousSubmodule (Fin n) (MvPolynomial (Fin (n + 1)) R) (d - 1)).sum_mem
  intro i hi
  change (C (X i) * MvPolynomial.map C
    (lastCoordinateHyperplaneRestriction n (pderiv i f))).IsHomogeneous (d - 1)
  simpa only [zero_add] using (isHomogeneous_C (Fin n) (X i)).mul
    ((lastCoordinateHyperplaneRestriction_isHomogeneous
      (hf.pderiv (i := i))).map C)

/-- Specializing the target-coordinate coefficients of the universal first polar gives the
restriction of the ordinary first polar to the last coordinate hyperplane. -/
theorem map_universalLastCoordinateFirstPolar_eval {n : ℕ}
    (f : MvPolynomial (Fin (n + 1)) R) (q : Fin (n + 1) → R) :
    MvPolynomial.map (eval q) (universalLastCoordinateFirstPolar n f) =
      lastCoordinateHyperplaneRestriction n (firstPolar f q) := by
  classical
  have hcomp : (eval q).comp (C : R →+* MvPolynomial (Fin (n + 1)) R) =
      RingHom.id R := by
    ext r
    simp
  unfold universalLastCoordinateFirstPolar firstPolar
  simp only [map_sum, map_mul, map_C, eval_X]
  apply Finset.sum_congr rfl
  intro i hi
  rw [lastCoordinateHyperplaneRestriction_C]
  congr 1
  rw [MvPolynomial.map_map, hcomp, MvPolynomial.map_id]

/-- Simultaneous coefficient specialization and target-point evaluation of the universal first
polar gives the last-coordinate-hyperplane restriction of the specialized first polar. -/
theorem map_universalLastCoordinateFirstPolar_eval₂
    {S : Type v} [CommSemiring S] {n : ℕ}
    (f : MvPolynomial (Fin (n + 1)) R) (phi : R →+* S)
    (q : Fin (n + 1) → S) :
    MvPolynomial.map (eval₂Hom phi q) (universalLastCoordinateFirstPolar n f) =
      lastCoordinateHyperplaneRestriction n (firstPolar (MvPolynomial.map phi f) q) := by
  classical
  have hcomp : (eval₂Hom phi q).comp
      (C : R →+* MvPolynomial (Fin (n + 1)) R) = phi := by
    ext r
    simp
  unfold universalLastCoordinateFirstPolar firstPolar
  simp only [map_sum, map_mul, map_C]
  apply Finset.sum_congr rfl
  intro i hi
  rw [eval₂Hom_X']
  rw [lastCoordinateHyperplaneRestriction_C]
  congr 1
  rw [MvPolynomial.map_map, hcomp, pderiv_map,
    map_lastCoordinateHyperplaneRestriction]

/-- Evaluating both sets of variables in the universal first polar recovers tangent incidence
with the base point constrained to the last coordinate hyperplane. -/
theorem eval_map_universalLastCoordinateFirstPolar
    {n : ℕ} (f : MvPolynomial (Fin (n + 1)) R)
    (p : Fin n → R) (q : Fin (n + 1) → R) :
    eval p (MvPolynomial.map (eval q) (universalLastCoordinateFirstPolar n f)) =
      eval q (tangentForm f (lastCoordinateHyperplanePoint n p)) := by
  rw [map_universalLastCoordinateFirstPolar_eval,
    eval_lastCoordinateHyperplaneRestriction, eval_firstPolar]

/-- Restriction of plane forms to the coordinate line on which the last coordinate vanishes. -/
def planeCoordinateLineRestriction :
    MvPolynomial (Fin (2 + 1)) R →ₐ[R] MvPolynomial (Fin 2) R :=
  lastCoordinateHyperplaneRestriction 2

/-- The first two plane coordinates restrict to the corresponding binary coordinates. -/
@[simp]
theorem planeCoordinateLineRestriction_X_castSucc (i : Fin 2) :
    planeCoordinateLineRestriction (R := R) (X i.castSucc) = X i := by
  simp [planeCoordinateLineRestriction]

/-- The last plane coordinate vanishes on the chosen coordinate line. -/
@[simp]
theorem planeCoordinateLineRestriction_X_last :
    planeCoordinateLineRestriction (R := R) (X (Fin.last 2)) = 0 := by
  exact lastCoordinateHyperplaneRestriction_X_last 2

/-- Restriction of a homogeneous plane form to the coordinate line preserves its degree. -/
theorem planeCoordinateLineRestriction_isHomogeneous
    {d : ℕ} {f : MvPolynomial (Fin (2 + 1)) R} (hf : f.IsHomogeneous d) :
    (planeCoordinateLineRestriction f).IsHomogeneous d :=
  lastCoordinateHyperplaneRestriction_isHomogeneous hf

/-- Restriction of a plane form to the coordinate line on which the last coordinate vanishes. -/
def planeCoordinateLineForm {d : ℕ} {f : MvPolynomial (Fin (2 + 1)) R}
    (hf : f.IsHomogeneous d) : BinaryForm.Form R d :=
  ⟨planeCoordinateLineRestriction f,
    planeCoordinateLineRestriction_isHomogeneous hf⟩

/-- The coordinate-line restriction of a plane cubic, with its coefficients lifted to the
target-coordinate ring. -/
def planeCoordinateLineCubicOverTarget
    {f : MvPolynomial (Fin (2 + 1)) R} (hf : f.IsHomogeneous 3) :
    BinaryForm.Form (MvPolynomial (Fin (2 + 1)) R) 3 :=
  BinaryForm.map C (planeCoordinateLineForm hf)

/-- The underlying polynomial of the lifted coordinate-line cubic is obtained by applying the
coefficient inclusion into the target-coordinate ring. -/
theorem coe_planeCoordinateLineCubicOverTarget
    {f : MvPolynomial (Fin (2 + 1)) R} (hf : f.IsHomogeneous 3) :
    (planeCoordinateLineCubicOverTarget hf :
      MvPolynomial (Fin 2) (MvPolynomial (Fin (2 + 1)) R)) =
        MvPolynomial.map C (planeCoordinateLineRestriction f) :=
  rfl

/-- The universal tangent-polar binary quadratic associated to a plane cubic. -/
def planeCoordinateTangentPolarForm
    {f : MvPolynomial (Fin (2 + 1)) R} (hf : f.IsHomogeneous 3) :
    BinaryForm.Form (MvPolynomial (Fin (2 + 1)) R) 2 :=
  ⟨universalLastCoordinateFirstPolar 2 f, by
    simpa using universalLastCoordinateFirstPolar_isHomogeneous hf⟩

/-- The underlying universal tangent-polar quadratic is the sum of target coordinates times
the coordinate-line restrictions of the corresponding partial derivatives. -/
theorem coe_planeCoordinateTangentPolarForm
    {f : MvPolynomial (Fin (2 + 1)) R} (hf : f.IsHomogeneous 3) :
    (planeCoordinateTangentPolarForm hf :
      MvPolynomial (Fin 2) (MvPolynomial (Fin (2 + 1)) R)) =
        ∑ i : Fin (2 + 1), C (X i) *
          MvPolynomial.map (C : R →+* MvPolynomial (Fin (2 + 1)) R)
            (planeCoordinateLineRestriction (pderiv i f)) :=
  rfl

/-- The specialization of the tangent-polar binary quadratic at a target point. -/
def planeCoordinateTangentPolarFormAt
    {f : MvPolynomial (Fin (2 + 1)) R} (hf : f.IsHomogeneous 3)
    (q : Fin (2 + 1) → R) : BinaryForm.Form R 2 :=
  ⟨lastCoordinateHyperplaneRestriction 2 (firstPolar f q), by
    simpa using lastCoordinateHyperplaneRestriction_isHomogeneous
      (firstPolar_isHomogeneous hf q)⟩

@[simp]
theorem planeCoordinateLineCubicOverTarget_map_eval
    {f : MvPolynomial (Fin (2 + 1)) R} (hf : f.IsHomogeneous 3)
    (q : Fin (2 + 1) → R) :
    BinaryForm.map (eval q) (planeCoordinateLineCubicOverTarget hf) =
      planeCoordinateLineForm hf := by
  apply Subtype.ext
  have hcomp : (eval q).comp (C : R →+* MvPolynomial (Fin (2 + 1)) R) =
      RingHom.id R := by
    ext r
    simp
  change MvPolynomial.map (eval q)
      (MvPolynomial.map C (planeCoordinateLineForm hf : MvPolynomial (Fin 2) R)) = _
  rw [MvPolynomial.map_map, hcomp, MvPolynomial.map_id]

@[simp]
theorem planeCoordinateTangentPolarForm_map_eval
    {f : MvPolynomial (Fin (2 + 1)) R} (hf : f.IsHomogeneous 3)
    (q : Fin (2 + 1) → R) :
    BinaryForm.map (eval q) (planeCoordinateTangentPolarForm hf) =
      planeCoordinateTangentPolarFormAt hf q := by
  apply Subtype.ext
  exact map_universalLastCoordinateFirstPolar_eval f q

/-- Simultaneous coefficient specialization and target-point evaluation sends the lifted
coordinate-line cubic to the coordinate-line restriction of the specialized cubic. -/
theorem planeCoordinateLineCubicOverTarget_map_eval₂
    {S : Type v} [CommSemiring S]
    {f : MvPolynomial (Fin (2 + 1)) R} (hf : f.IsHomogeneous 3)
    (phi : R →+* S) (q : Fin (2 + 1) → S) :
    BinaryForm.map (eval₂Hom phi q) (planeCoordinateLineCubicOverTarget hf) =
      planeCoordinateLineForm (hf.map phi) := by
  apply Subtype.ext
  have hcomp : (eval₂Hom phi q).comp
      (C : R →+* MvPolynomial (Fin (2 + 1)) R) = phi := by
    ext r
    simp
  change MvPolynomial.map (eval₂Hom phi q)
      (MvPolynomial.map C (planeCoordinateLineForm hf : MvPolynomial (Fin 2) R)) = _
  rw [MvPolynomial.map_map, hcomp]
  exact map_lastCoordinateHyperplaneRestriction 2 f phi

/-- Simultaneous coefficient specialization and target-point evaluation sends the universal
tangent polar to the tangent polar of the specialized cubic. -/
theorem planeCoordinateTangentPolarForm_map_eval₂
    {S : Type v} [CommSemiring S]
    {f : MvPolynomial (Fin (2 + 1)) R} (hf : f.IsHomogeneous 3)
    (phi : R →+* S) (q : Fin (2 + 1) → S) :
    BinaryForm.map (eval₂Hom phi q) (planeCoordinateTangentPolarForm hf) =
      planeCoordinateTangentPolarFormAt (hf.map phi) q := by
  apply Subtype.ext
  exact map_universalLastCoordinateFirstPolar_eval₂ f phi q

section CommRing

variable {A : Type u} [CommRing A]

/-- The fixed `(3,2)` resultant of the coordinate-line cubic and its universal tangent polar. -/
def planeCoordinateTangentResultant
    {f : MvPolynomial (Fin (2 + 1)) A} (hf : f.IsHomogeneous 3) :
    MvPolynomial (Fin (2 + 1)) A :=
  BinaryForm.resultant (planeCoordinateLineCubicOverTarget hf)
    (planeCoordinateTangentPolarForm hf)

/-- Evaluation of the universal `(3,2)` resultant is the fixed-degree resultant of the
specialized coordinate-line cubic and tangent-polar quadratic. -/
@[simp]
theorem eval_planeCoordinateTangentResultant
    {f : MvPolynomial (Fin (2 + 1)) A} (hf : f.IsHomogeneous 3)
    (q : Fin (2 + 1) → A) :
    eval q (planeCoordinateTangentResultant hf) =
      BinaryForm.resultant (planeCoordinateLineForm hf)
        (planeCoordinateTangentPolarFormAt hf q) := by
  unfold planeCoordinateTangentResultant
  rw [← BinaryForm.resultant_map (eval q)
    (planeCoordinateLineCubicOverTarget hf) (planeCoordinateTangentPolarForm hf)]
  simp

/-- The universal `(3,2)` resultant commutes with arbitrary coefficient specialization and
target-point evaluation. -/
theorem eval₂_planeCoordinateTangentResultant
    {S : Type v} [CommRing S]
    {f : MvPolynomial (Fin (2 + 1)) A} (hf : f.IsHomogeneous 3)
    (phi : A →+* S) (q : Fin (2 + 1) → S) :
    eval₂ phi q (planeCoordinateTangentResultant hf) =
      BinaryForm.resultant (planeCoordinateLineForm (hf.map phi))
        (planeCoordinateTangentPolarFormAt (hf.map phi) q) := by
  unfold planeCoordinateTangentResultant
  change (eval₂Hom phi q)
      (BinaryForm.resultant (planeCoordinateLineCubicOverTarget hf)
        (planeCoordinateTangentPolarForm hf)) = _
  rw [← BinaryForm.resultant_map (eval₂Hom phi q)
    (planeCoordinateLineCubicOverTarget hf) (planeCoordinateTangentPolarForm hf)]
  rw [planeCoordinateLineCubicOverTarget_map_eval₂ hf phi q,
    planeCoordinateTangentPolarForm_map_eval₂ hf phi q]

end CommRing

end

end BConicBundleMultisections
