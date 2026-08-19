/-
Copyright (c) 2026 V14Formalization contributors.
Released under Apache 2.0 license.
-/
module

public import Mathlib.RingTheory.GradedAlgebra.Homogeneous.Maps
public import Mathlib.RingTheory.Ideal.Quotient.Operations

/-!
# The grading on a quotient by a homogeneous ideal

Mathlib has functoriality of `Proj` (`AlgebraicGeometry.Proj.map`, along a
graded ring hom `𝒜 →+*ᵍ ℬ` satisfying `ℬ₊ ≤ 𝒜₊.map f`), and it has closed
subschemes cut by a quasi-coherent ideal sheaf on an arbitrary scheme
(`Scheme.IdealSheafData.subscheme`).  What it does not have — in the pin or on
master, where it is the subject of the stalled PR chain #27307 → #40749 →
#36501 — is the graded structure on `A ⧸ I` for a homogeneous ideal `I`.  That
single missing instance is what blocks writing `Proj (A ⧸ I) ⟶ Proj A`, and it
is what this module supplies.

The graded pieces are the images `(𝒜 i).map (Ideal.Quotient.mk I)`.  The
decomposition is obtained by showing `DirectSum.coeAddMonoidHom` is bijective:
surjectivity because `mk` is surjective and every element of `A` decomposes,
injectivity because a homogeneous ideal contains the homogeneous components of
each of its elements.

With `mkGraded` and `irrelevant_le_map_mkGraded` in hand,

    AlgebraicGeometry.Proj.map (mkGraded 𝒜 I) (irrelevant_le_map_mkGraded 𝒜 I)
      : Proj (grading 𝒜 I) ⟶ Proj 𝒜

is the closed subscheme of `Proj 𝒜` cut out by `I`, with its map to the
ambient.
-/

noncomputable section

open DirectSum

namespace V14Formalization
namespace GradedQuotient

variable {ι R A : Type*} [DecidableEq ι] [AddMonoid ι] [CommRing R] [CommRing A]
  [Algebra R A]
variable (𝒜 : ι → Submodule R A) [GradedAlgebra 𝒜] (I : HomogeneousIdeal 𝒜)

/-- The image of the `i`-th graded piece in the quotient by a homogeneous ideal. -/
@[expose] public def grading (i : ι) : Submodule R (A ⧸ I.toIdeal) :=
  (𝒜 i).map (Ideal.Quotient.mkₐ R I.toIdeal).toLinearMap

public theorem mem_grading {i : ι} {y : A ⧸ I.toIdeal} :
    y ∈ grading 𝒜 I i ↔ ∃ a ∈ 𝒜 i, Ideal.Quotient.mk I.toIdeal a = y := by
  simp [grading, Submodule.mem_map]

public theorem mk_mem_grading {i : ι} {a : A} (ha : a ∈ 𝒜 i) :
    Ideal.Quotient.mk I.toIdeal a ∈ grading 𝒜 I i :=
  (mem_grading 𝒜 I).2 ⟨a, ha, rfl⟩

public instance : SetLike.GradedMonoid (grading 𝒜 I) where
  one_mem := by
    have := mk_mem_grading 𝒜 I (SetLike.one_mem_graded 𝒜)
    simpa using this
  mul_mem := by
    rintro i j x y hx hy
    obtain ⟨a, ha, rfl⟩ := (mem_grading 𝒜 I).1 hx
    obtain ⟨b, hb, rfl⟩ := (mem_grading 𝒜 I).1 hy
    have := mk_mem_grading 𝒜 I (SetLike.mul_mem_graded ha hb)
    simpa using this

/-- The quotient map, restricted to a single graded piece. -/
def gradeMk (i : ι) : 𝒜 i →+ grading 𝒜 I i where
  toFun a := ⟨Ideal.Quotient.mk I.toIdeal a, mk_mem_grading 𝒜 I a.2⟩
  map_zero' := by ext; simp
  map_add' _ _ := by ext; simp

private theorem gradeMk_surjective (i : ι) : Function.Surjective (gradeMk 𝒜 I i) := by
  rintro ⟨y, hy⟩
  obtain ⟨a, ha, rfl⟩ := (mem_grading 𝒜 I).1 hy
  exact ⟨⟨a, ha⟩, rfl⟩

/-- The quotient map on direct sums of graded pieces. -/
def mapDirectSum : (⨁ i, 𝒜 i) →+ ⨁ i, grading 𝒜 I i :=
  DirectSum.map (gradeMk 𝒜 I)

private theorem mapDirectSum_surjective : Function.Surjective (mapDirectSum 𝒜 I) := by
  intro x
  induction x using DirectSum.induction_on with
  | zero => exact ⟨0, map_zero _⟩
  | of i b =>
    obtain ⟨a, ha⟩ := gradeMk_surjective 𝒜 I i b
    exact ⟨DirectSum.of _ i a, by simp [mapDirectSum, ha]⟩
  | add x y hx hy =>
    obtain ⟨u, hu⟩ := hx
    obtain ⟨v, hv⟩ := hy
    exact ⟨u + v, by simp [hu, hv]⟩

private theorem coe_mapDirectSum (y : ⨁ i, 𝒜 i) :
    DirectSum.coeAddMonoidHom (grading 𝒜 I) (mapDirectSum 𝒜 I y) =
      Ideal.Quotient.mk I.toIdeal (DirectSum.coeAddMonoidHom 𝒜 y) := by
  induction y using DirectSum.induction_on with
  | zero => simp
  | of i a => simp [mapDirectSum, gradeMk]
  | add u v hu hv => simp [hu, hv]

public theorem coeAddMonoidHom_bijective :
    Function.Bijective (DirectSum.coeAddMonoidHom (grading 𝒜 I)) := by
  constructor
  · rw [injective_iff_map_eq_zero]
    intro x hx
    obtain ⟨y, rfl⟩ := mapDirectSum_surjective 𝒜 I x
    rw [coe_mapDirectSum] at hx
    have ha : DirectSum.coeAddMonoidHom 𝒜 y ∈ I.toIdeal := by
      simpa [Ideal.Quotient.eq_zero_iff_mem] using hx
    have hdec : DirectSum.decompose 𝒜 (DirectSum.coeAddMonoidHom 𝒜 y) = y := by
      simpa using DirectSum.Decomposition.right_inv (ℳ := 𝒜) y
    have key : ∀ i, ((y i : A)) ∈ I.toIdeal := by
      intro i
      have := (I.isHomogeneous.mem_iff (x := DirectSum.coeAddMonoidHom 𝒜 y)).1 ha i
      rwa [hdec] at this
    ext i
    have hzero : (gradeMk 𝒜 I i) (y i) = 0 := by
      ext
      simpa [gradeMk] using (Ideal.Quotient.eq_zero_iff_mem).2 (key i)
    simp [mapDirectSum, hzero]
  · intro y
    obtain ⟨a, rfl⟩ := Ideal.Quotient.mk_surjective y
    refine ⟨mapDirectSum 𝒜 I (DirectSum.decompose 𝒜 a), ?_⟩
    rw [coe_mapDirectSum]
    congr 1
    simpa using DirectSum.Decomposition.left_inv (ℳ := 𝒜) a

/-- **The missing instance.**  The quotient of a graded algebra by a homogeneous
ideal is graded by the images of the graded pieces. -/
public instance gradedAlgebraQuotient : GradedAlgebra (grading 𝒜 I) where
  decompose' := (Equiv.ofBijective _ (coeAddMonoidHom_bijective 𝒜 I)).symm
  left_inv x := (Equiv.ofBijective _ (coeAddMonoidHom_bijective 𝒜 I)).apply_symm_apply x
  right_inv x := (Equiv.ofBijective _ (coeAddMonoidHom_bijective 𝒜 I)).symm_apply_apply x

/-- The quotient map, as a graded ring hom. -/
@[expose] public def mkGraded : 𝒜 →+*ᵍ grading 𝒜 I where
  __ := Ideal.Quotient.mk I.toIdeal
  map_mem := fun {_ _} hx => mk_mem_grading 𝒜 I hx

public theorem mkGraded_surjective : Function.Surjective (mkGraded 𝒜 I) :=
  Ideal.Quotient.mk_surjective

end GradedQuotient
end V14Formalization

namespace V14Formalization
namespace GradedQuotient

open HomogeneousIdeal

variable {R A : Type*} [CommRing R] [CommRing A] [Algebra R A]
variable (𝒜 : ℕ → Submodule R A) [GradedAlgebra 𝒜] (I : HomogeneousIdeal 𝒜)

/-- The `AlgebraicGeometry.Proj.map` side condition holds for the quotient map:
the irrelevant ideal of `A ⧸ I` is the image of the irrelevant ideal of `A`. -/
public theorem irrelevant_le_map_mkGraded :
    (grading 𝒜 I)₊ ≤ 𝒜₊.map (mkGraded 𝒜 I) := by
  rintro y hy
  obtain ⟨a, rfl⟩ := Ideal.Quotient.mk_surjective y
  have hd := GradedRingHom.map_directSumDecompose (𝒜 := 𝒜) (ℬ := grading 𝒜 I)
    (mkGraded 𝒜 I) (x := a) (i := 0)
  have hgr : (mkGraded 𝒜 I) ((DirectSum.decompose 𝒜 a 0 : A)) = 0 := by
    rw [hd]; exact hy
  set a₀ : A := (DirectSum.decompose 𝒜 a 0 : A) with ha₀
  have hmem : a - a₀ ∈ 𝒜₊ := by
    rw [mem_irrelevant_iff, GradedRing.proj_apply, decompose_sub,
      DirectSum.decompose_of_mem 𝒜 (SetLike.coe_mem (DirectSum.decompose 𝒜 a 0))]
    simp
  have himg : (mkGraded 𝒜 I) (a - a₀) = Ideal.Quotient.mk I.toIdeal a := by
    rw [map_sub, hgr, sub_zero]; rfl
  rw [← HomogeneousIdeal.mem_iff, HomogeneousIdeal.toIdeal_map, ← himg]
  exact Ideal.mem_map_of_mem _ hmem

end GradedQuotient
end V14Formalization
