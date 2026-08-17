/-
Copyright (c) 2026 V14Formalization contributors.
Released under Apache 2.0 license.
-/
module

public import V14Formalization.MultiProjectiveZeroLocus
public import BConicBundleMultisections.LinearSubstitution

/-!
# The coordinate scheme `Gr(2,6) ∩ P(im P)`

The fifteen homogeneous coordinates use the lexicographic order
`01,02,03,04,05,12,13,14,15,23,24,25,34,35,45`.  The fifteen
quadrics below are the Plücker relations in the matching lexicographic
order on four-subsets.  A `15 × 15` projector supplies the linear
equations `(P - I)x = 0`.
-/

noncomputable section

universe u

open scoped BigOperators
open AlgebraicGeometry BConicBundleMultisections

namespace V14Formalization
namespace SchemeGeometry

/-- Six coordinate indices in one relation
`x_ab*x_cd - x_ac*x_bd + x_ad*x_bc`. -/
public structure PluckerRelation where
  p1 : Fin 15
  p2 : Fin 15
  p3 : Fin 15
  p4 : Fin 15
  p5 : Fin 15
  p6 : Fin 15

/-- The fifteen Plücker relations, in lexicographic `Λ⁴` order. -/
@[expose] public def pluckerRelation : Fin 15 → PluckerRelation := ![
  ⟨0,  9, 1,  6, 2,  5⟩,
  ⟨0, 10, 1,  7, 3,  5⟩,
  ⟨0, 11, 1,  8, 4,  5⟩,
  ⟨0, 12, 2,  7, 3,  6⟩,
  ⟨0, 13, 2,  8, 4,  6⟩,
  ⟨0, 14, 3,  8, 4,  7⟩,
  ⟨1, 12, 2, 10, 3,  9⟩,
  ⟨1, 13, 2, 11, 4,  9⟩,
  ⟨1, 14, 3, 11, 4, 10⟩,
  ⟨2, 14, 3, 13, 4, 12⟩,
  ⟨5, 12, 6, 10, 7,  9⟩,
  ⟨5, 13, 6, 11, 8,  9⟩,
  ⟨5, 14, 7, 11, 8, 10⟩,
  ⟨6, 14, 7, 13, 8, 12⟩,
  ⟨9, 14, 10, 13, 11, 12⟩
]

variable (R : Type u) [CommRing R]

/-- One Plücker quadric in the coordinate order fixed above. -/
@[expose] public def pluckerQuadric (q : Fin 15) : MvPolynomial (Fin 15) R :=
  let d := pluckerRelation q
  MvPolynomial.X d.p1 * MvPolynomial.X d.p2 -
    MvPolynomial.X d.p3 * MvPolynomial.X d.p4 +
      MvPolynomial.X d.p5 * MvPolynomial.X d.p6

/-- The `i`-th linear coordinate of `(P-I)x`. -/
@[expose] public def projectorLinearCut
    (P : Matrix (Fin 15) (Fin 15) R) (i : Fin 15) :
    MvPolynomial (Fin 15) R :=
  ∑ j : Fin 15,
    MvPolynomial.C (P i j - if i = j then 1 else 0) * MvPolynomial.X j

@[simp]
public theorem eval_pluckerQuadric (q : Fin 15) (x : Fin 15 → R) :
    MvPolynomial.eval x (pluckerQuadric R q) =
      let d := pluckerRelation q
      x d.p1 * x d.p2 - x d.p3 * x d.p4 + x d.p5 * x d.p6 := by
  simp [pluckerQuadric]

@[simp]
theorem eval_projectorLinearCut
    (P : Matrix (Fin 15) (Fin 15) R) (i : Fin 15) (x : Fin 15 → R) :
    MvPolynomial.eval x (projectorLinearCut R P i) = P.mulVec x i - x i := by
  simp only [projectorLinearCut, map_sum, MvPolynomial.eval_mul, MvPolynomial.eval_C,
    MvPolynomial.eval_X, Matrix.mulVec, dotProduct]
  simp_rw [sub_mul]
  rw [Finset.sum_sub_distrib]
  congr 1
  simp

public theorem projectorLinearCuts_vanish_iff
    (P : Matrix (Fin 15) (Fin 15) R) (x : Fin 15 → R) :
    (∀ i : Fin 15, MvPolynomial.eval x (projectorLinearCut R P i) = 0) ↔
      P.mulVec x = x := by
  constructor
  · intro h
    funext i
    exact sub_eq_zero.mp (by simpa using h i)
  · intro h i
    rw [eval_projectorLinearCut, congrFun h i, sub_self]

/-- Every Plücker relation is homogeneous of degree two. -/
public theorem pluckerQuadric_isHomogeneous (q : Fin 15) :
    (pluckerQuadric R q).IsHomogeneous 2 := by
  dsimp [pluckerQuadric]
  exact (((MvPolynomial.isHomogeneous_X R _).mul
      (MvPolynomial.isHomogeneous_X R _)).sub
    ((MvPolynomial.isHomogeneous_X R _).mul
      (MvPolynomial.isHomogeneous_X R _))).add
    ((MvPolynomial.isHomogeneous_X R _).mul
      (MvPolynomial.isHomogeneous_X R _))

/-- Every projector-image equation is homogeneous of degree one. -/
public theorem projectorLinearCut_isHomogeneous
    (P : Matrix (Fin 15) (Fin 15) R) (i : Fin 15) :
    (projectorLinearCut R P i).IsHomogeneous 1 := by
  apply MvPolynomial.IsHomogeneous.sum
  intro j _
  have hC : (MvPolynomial.C (P i j - if i = j then 1 else 0) :
      MvPolynomial (Fin 15) R).IsHomogeneous 0 :=
    MvPolynomial.isHomogeneous_C _ _
  have hX : (MvPolynomial.X j : MvPolynomial (Fin 15) R).IsHomogeneous 1 :=
    MvPolynomial.isHomogeneous_X _ _
  simpa using hC.mul hX

/-- Substitution by a matrix commuting with `P` carries each equation of
`P(M)` to the corresponding linear combination of the same equations. -/
theorem aeval_linearSubst_projectorLinearCut
    (P M : Matrix (Fin 15) (Fin 15) R) (hcomm : P * M = M * P)
    (i : Fin 15) :
    (MvPolynomial.aeval (linearSubst 14 M) : _ →ₐ[R] _)
        (projectorLinearCut R P i) =
      ∑ j : Fin 15, MvPolynomial.C (M i j) * projectorLinearCut R P j := by
  classical
  have hcut (Q : Matrix (Fin 15) (Fin 15) R) (j : Fin 15) :
      projectorLinearCut R Q j = linearSubst 14 (Q - 1) j := by
    simp [projectorLinearCut, linearSubst, Matrix.sub_apply, Matrix.one_apply]
  rw [hcut, aeval_linearSubst_linearSubst]
  have hmat : (P - 1) * M = M * (P - 1) := by
    rw [Matrix.sub_mul, Matrix.mul_sub, hcomm, Matrix.one_mul, Matrix.mul_one]
  rw [hmat, ← aeval_linearSubst_linearSubst 14 (P - 1) M i]
  simp only [linearSubst, map_sum, map_mul, MvPolynomial.aeval_C,
    MvPolynomial.aeval_X, MvPolynomial.algebraMap_eq, hcut]

/-- The transformed projector-image equations lie in the ideal generated by
the original projector-image equations. -/
public theorem span_aeval_projectorLinearCut_le
    (P M : Matrix (Fin 15) (Fin 15) R) (hcomm : P * M = M * P) :
    Ideal.span (Set.range (fun i : Fin 15 =>
      (MvPolynomial.aeval (linearSubst 14 M) : _ →ₐ[R] _)
        (projectorLinearCut R P i))) ≤
      Ideal.span (Set.range (projectorLinearCut R P)) := by
  rw [Ideal.span_le]
  rintro _ ⟨i, rfl⟩
  change (MvPolynomial.aeval (linearSubst 14 M))
      (projectorLinearCut R P i) ∈ _
  rw [aeval_linearSubst_projectorLinearCut R P M hcomm i]
  apply Ideal.sum_mem
  intro j _
  apply Ideal.mul_mem_left
  exact Ideal.subset_span ⟨j, rfl⟩

/-- Plücker equations followed by the projector-image equations. -/
@[expose] public def grassmannianLinearSectionEquations
    (P : Matrix (Fin 15) (Fin 15) R) :
    Fin 15 ⊕ Fin 15 → MvPolynomial (Fin 15) R
  | Sum.inl q => pluckerQuadric R q
  | Sum.inr i => projectorLinearCut R P i

/-- If the Plücker equations and the projector equations are separately stable
under a linear substitution, then their combined V14 equation family is
stable as well. -/
public theorem grassmannianLinearSection_span_le_of_parts
    (P M : Matrix (Fin 15) (Fin 15) R)
    (hplucker :
      Ideal.span (Set.range (fun q : Fin 15 =>
        (MvPolynomial.aeval (linearSubst 14 M) : _ →ₐ[R] _)
          (pluckerQuadric R q))) ≤
        Ideal.span (Set.range (pluckerQuadric R)))
    (hlinear :
      Ideal.span (Set.range (fun i : Fin 15 =>
        (MvPolynomial.aeval (linearSubst 14 M) : _ →ₐ[R] _)
          (projectorLinearCut R P i))) ≤
        Ideal.span (Set.range (projectorLinearCut R P))) :
    Ideal.span (Set.range (fun s : Fin 15 ⊕ Fin 15 =>
      (MvPolynomial.aeval (linearSubst 14 M) : _ →ₐ[R] _)
        (grassmannianLinearSectionEquations R P s))) ≤
      Ideal.span (Set.range (grassmannianLinearSectionEquations R P)) := by
  rw [Ideal.span_le]
  rintro _ ⟨s, rfl⟩
  rcases s with q | i
  · have hq :
        (MvPolynomial.aeval (linearSubst 14 M) : _ →ₐ[R] _)
            (pluckerQuadric R q) ∈
          Ideal.span (Set.range (pluckerQuadric R)) :=
      hplucker (Ideal.subset_span ⟨q, rfl⟩)
    exact (Ideal.span_mono (by
      rintro _ ⟨q, rfl⟩
      exact ⟨Sum.inl q, rfl⟩)) hq
  · have hi :
        (MvPolynomial.aeval (linearSubst 14 M) : _ →ₐ[R] _)
            (projectorLinearCut R P i) ∈
          Ideal.span (Set.range (projectorLinearCut R P)) :=
      hlinear (Ideal.subset_span ⟨i, rfl⟩)
    exact (Ideal.span_mono (by
      rintro _ ⟨i, rfl⟩
      exact ⟨Sum.inr i, rfl⟩)) hi

/-- The actual scheme-theoretic intersection `Gr(2,6) ∩ P(im P)`
for a supplied coordinate projector `P`. -/
public abbrev grassmannianLinearSection
    (P : Matrix (Fin 15) (Fin 15) R) : Scheme :=
  projectiveZeroLocusFamily 14 R (grassmannianLinearSectionEquations R P)

/-- Its canonical closed immersion into coordinate `P¹⁴`. -/
public abbrev grassmannianLinearSectionι
    (P : Matrix (Fin 15) (Fin 15) R) :
    grassmannianLinearSection R P ⟶ ProjectiveSpace 14 R :=
  projectiveZeroLocusFamilyι 14 R (grassmannianLinearSectionEquations R P)

end SchemeGeometry
end V14Formalization
