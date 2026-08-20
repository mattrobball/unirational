/-
Copyright (c) 2026 V14Formalization contributors.
Released under Apache 2.0 license.
-/
module

public import V14Formalization.SymmetricAlgebraGraded
public import Mathlib.LinearAlgebra.SymmetricAlgebra.Basis
public import Mathlib.RingTheory.MvPolynomial.Homogeneous
public import Mathlib.RingTheory.GradedAlgebra.AlgHom
public import Mathlib.RingTheory.GradedAlgebra.Homogeneous.Maps

/-!
# Functoriality of `SymmetricAlgebra`, and the bridge to `MvPolynomial`

`ExteriorAlgebra.map` exists in Mathlib; the symmetric analogue does not.  This
module supplies it (`SymmetricAlgebra.map`), shows it respects the grading of
`SymmetricAlgebraGraded` (`SymmetricAlgebra.gradedMap`), and proves the functor
laws.

The second half is **the bridge**: `SymmetricAlgebra.equivMvPolynomial b`, the
basis isomorphism already in Mathlib, is upgraded to an isomorphism of *graded*
algebras onto `MvPolynomial.homogeneousSubmodule`.  This is what connects the
coordinate-free `Proj (Sym (Module.Dual k V))` to the `ProjectiveSpace n k` on
which every existing V14 proof lives.

The bridge is short because Mathlib already proves
`MvPolynomial.homogeneousSubmodule_one_pow`, so only the degree-1 statement has
any content: `equivMvPolynomial b` carries `LinearMap.range (ι R M)` onto the
span of the variables.
-/

noncomputable section

@[expose] public section

open Module

attribute [local instance] MvPolynomial.gradedAlgebra

namespace SymmetricAlgebra

variable {κ R M N L : Type*} [CommSemiring R]
  [AddCommMonoid M] [Module R M] [AddCommMonoid N] [Module R N]
  [AddCommMonoid L] [Module R L]

/-! ## Functoriality -/

/-- Functoriality of the symmetric algebra: a linear map `M →ₗ[R] N` induces an
algebra map `SymmetricAlgebra R M →ₐ[R] SymmetricAlgebra R N`.  This is the
symmetric-algebra analogue of `ExteriorAlgebra.map`. -/
def map (f : M →ₗ[R] N) : SymmetricAlgebra R M →ₐ[R] SymmetricAlgebra R N :=
  lift (ι R N ∘ₗ f)

@[simp] lemma map_ι (f : M →ₗ[R] N) (m : M) : map f (ι R M m) = ι R N (f m) := by
  simp [map]

lemma map_range_le (f : M →ₗ[R] N) :
    Submodule.map (map f).toLinearMap (LinearMap.range (ι R M)) ≤ LinearMap.range (ι R N) := by
  rintro _ ⟨_, ⟨m, rfl⟩, rfl⟩
  exact ⟨f m, by simp⟩

lemma map_mem_grade (f : M →ₗ[R] N) {i : ℕ} {x : SymmetricAlgebra R M}
    (hx : x ∈ grade R M i) : map f x ∈ grade R N i := by
  have h := Submodule.mem_map_of_mem (f := (map f).toLinearMap) hx
  rw [Submodule.map_pow] at h
  exact pow_le_pow_left' (map_range_le f) i h

@[simp] lemma map_id : map (LinearMap.id : M →ₗ[R] M) = AlgHom.id R (SymmetricAlgebra R M) :=
  algHom_ext (LinearMap.ext fun m => by simp)

lemma map_comp (f : N →ₗ[R] L) (g : M →ₗ[R] N) :
    (map f).comp (map g) = map (f ∘ₗ g) :=
  algHom_ext (LinearMap.ext fun m => by simp)

/-- The symmetric algebra of a linear map, as a morphism of graded algebras. -/
def gradedMap (f : M →ₗ[R] N) : grade R M →ₐᵍ[R] grade R N :=
  { map f with map_mem := map_mem_grade f }

/-- Functor law: `gradedMap` of the identity is the identity. -/
@[simp] lemma gradedMap_id :
    gradedMap (LinearMap.id : M →ₗ[R] M) = GradedAlgHom.id R (grade R M) :=
  GradedAlgHom.ext fun x => by
    change map LinearMap.id x = x
    rw [map_id]; rfl

/-- Functor law: `gradedMap` takes composition to composition. -/
lemma gradedMap_comp (f : N →ₗ[R] L) (g : M →ₗ[R] N) :
    (gradedMap f).comp (gradedMap g) = gradedMap (f ∘ₗ g) :=
  GradedAlgHom.ext fun x => by
    change map f (map g x) = map (f ∘ₗ g) x
    exact congr($(map_comp f g) x)

end SymmetricAlgebra

/-! ## A general criterion for `Proj.map`'s side condition -/

open scoped HomogeneousIdeal in
/-- If a graded algebra map `f` has a graded right inverse `g`, then the
irrelevant ideal of the target is contained in the image of the irrelevant
ideal of the source — which is exactly the side condition `Proj.map` demands.
This is the only thing needed to turn an isomorphism of graded algebras into a
morphism of `Proj`s. -/
lemma irrelevant_le_map_of_rightInverse
    {R A B : Type*} [CommRing R] [CommRing A] [CommRing B] [Algebra R A] [Algebra R B]
    {𝒜 : ℕ → Submodule R A} {ℬ : ℕ → Submodule R B} [GradedAlgebra 𝒜] [GradedAlgebra ℬ]
    (f : 𝒜 →ₐᵍ[R] ℬ) (g : ℬ →ₐᵍ[R] 𝒜) (h : ∀ y, f (g y) = y) :
    ℬ₊ ≤ HomogeneousIdeal.map f.toGradedRingHom (𝒜₊) := by
  rw [HomogeneousIdeal.irrelevant_le]
  intro i hi y hy
  have hy' : g y ∈ 𝒜 i := GradedFunLike.map_mem g hy
  have key : (f.toGradedRingHom : A →+* B) (g y) = y := h y
  have hmem : (f.toGradedRingHom : A →+* B) (g y)
      ∈ Ideal.map (f.toGradedRingHom : A →+* B) (𝒜₊ : HomogeneousIdeal 𝒜).toIdeal :=
    Ideal.mem_map_of_mem _ (HomogeneousIdeal.mem_irrelevant_of_mem _ hi hy')
  rw [key] at hmem
  exact hmem

/-! ## The bridge -/

namespace SymmetricAlgebra

variable {κ R M : Type*} [CommSemiring R] [AddCommMonoid M] [Module R M]

/-- The basis isomorphism, composed with `ι`, is exactly `Basis.constr b R X`. -/
lemma equivMvPolynomial_comp_ι (b : Basis κ R M) :
    (equivMvPolynomial b).toAlgHom.toLinearMap ∘ₗ ι R M
      = Basis.constr b R (MvPolynomial.X : κ → MvPolynomial κ R) :=
  LinearMap.ext fun m => by simp [equivMvPolynomial]

/-- Degree-1 case of the bridge: the basis isomorphism carries the range of `ι`
onto the degree-1 homogeneous polynomials. -/
lemma map_range_ι_equivMvPolynomial (b : Basis κ R M) :
    Submodule.map (equivMvPolynomial b).toAlgHom.toLinearMap (LinearMap.range (ι R M))
      = MvPolynomial.homogeneousSubmodule κ R 1 := by
  rw [← LinearMap.range_comp, equivMvPolynomial_comp_ι b, Basis.constr_range,
    MvPolynomial.homogeneousSubmodule_one_eq_span_X]

/-- **The bridge.**  The basis isomorphism
`SymmetricAlgebra R M ≃ₐ[R] MvPolynomial κ R` carries the symmetric-algebra
grading onto the homogeneous grading, degree by degree. -/
theorem map_grade_equivMvPolynomial (b : Basis κ R M) (i : ℕ) :
    Submodule.map (equivMvPolynomial b).toAlgHom.toLinearMap (grade R M i)
      = MvPolynomial.homogeneousSubmodule κ R i := by
  rw [grade, Submodule.map_pow, map_range_ι_equivMvPolynomial b,
    MvPolynomial.homogeneousSubmodule_one_pow]

lemma mem_grade_equivMvPolynomial (b : Basis κ R M) {i : ℕ} {x : SymmetricAlgebra R M}
    (hx : x ∈ grade R M i) : equivMvPolynomial b x ∈ MvPolynomial.homogeneousSubmodule κ R i := by
  rw [← map_grade_equivMvPolynomial b i]
  exact Submodule.mem_map_of_mem hx

lemma mem_grade_equivMvPolynomial_symm (b : Basis κ R M) {i : ℕ} {y : MvPolynomial κ R}
    (hy : y ∈ MvPolynomial.homogeneousSubmodule κ R i) :
    (equivMvPolynomial b).symm y ∈ grade R M i := by
  rw [← map_grade_equivMvPolynomial b i] at hy
  obtain ⟨x, hx, rfl⟩ := hy
  simpa using hx

variable (b : Basis κ R M)

/-- The bridge, packaged as a morphism of graded algebras. -/
def gradedEquivMvPolynomial :
    grade R M →ₐᵍ[R] MvPolynomial.homogeneousSubmodule κ R :=
  { (equivMvPolynomial b).toAlgHom with map_mem := mem_grade_equivMvPolynomial b }

/-- The inverse of the bridge, packaged as a morphism of graded algebras. -/
def gradedEquivMvPolynomialSymm :
    MvPolynomial.homogeneousSubmodule κ R →ₐᵍ[R] grade R M :=
  { (equivMvPolynomial b).symm.toAlgHom with map_mem := mem_grade_equivMvPolynomial_symm b }

-- Both are reached by `simp` in the two round-trip lemmas below; they are not
-- referenced by name anywhere, and deleting them breaks those proofs.
@[simp] lemma gradedEquivMvPolynomial_apply (x : SymmetricAlgebra R M) :
    gradedEquivMvPolynomial b x = equivMvPolynomial b x := rfl

@[simp] lemma gradedEquivMvPolynomialSymm_apply (y : MvPolynomial κ R) :
    gradedEquivMvPolynomialSymm b y = (equivMvPolynomial b).symm y := rfl

lemma gradedEquivMvPolynomial_leftInverse (x : SymmetricAlgebra R M) :
    gradedEquivMvPolynomialSymm b (gradedEquivMvPolynomial b x) = x := by simp

lemma gradedEquivMvPolynomial_rightInverse (y : MvPolynomial κ R) :
    gradedEquivMvPolynomial b (gradedEquivMvPolynomialSymm b y) = y := by simp

end SymmetricAlgebra
