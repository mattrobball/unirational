/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import BConicBundleMultisections.BiprojectiveFiberEquationBaseChange
public import Mathlib.Algebra.Category.Ring.Constructions
public import Mathlib.AlgebraicGeometry.Pullbacks

/-!
# Base change of a biprojective standard chart along a point of the second factor

The chart identification that `exists_chartEquation_openImmersion`
(`PointedConicRationalFamilies.lean`) needs, at the level of rings.

Fix a standard product chart `(i, j)` of `ℙᵐ_R × ℙⁿ_R`, whose coordinate ring is
`Sₓ ⊗[R] S_y` with `Sₓ`, `S_y` the coordinate rings of the two factor charts.  A point of the
`j`-th chart of `ℙⁿ_R` with values in an `R`-algebra `K` is an `R`-algebra map `y : S_y →ₐ[R] K`,
and `BiprojectiveSpace.sndFiberChartMap y : Sₓ ⊗[R] S_y →ₐ[R] K ⊗[R] Sₓ` substitutes it into the
second block.

The point of this file is that this really is a *base change*: the square

```
S_y  --------- y --------->  K
 |                           |
 | includeRight              | includeLeft
 ↓                           ↓
Sₓ ⊗[R] S_y  -- sndFiber -->  K ⊗[R] Sₓ
```

is a pushout of commutative rings.  Applying `Spec` therefore turns it into a pullback square of
schemes (`AlgebraicGeometry.isPullback_SpecMap_of_isPushout`), which is what identifies the chart
of the base-changed conic bundle with an explicit affine scheme over `K`.

The proof is pure pasting: the square sits to the right of the tensor-product pushout
`R → Sₓ`, `R → S_y`, and the composite rectangle is the tensor-product pushout `R → K`, `R → Sₓ`.
No tensor-product computation is performed by hand.
-/

@[expose] public section

open CategoryTheory Limits
open scoped TensorProduct

namespace BConicBundleMultisections.BiprojectiveSpace

noncomputable section

universe u

open AlgebraicGeometry CommRingCat

attribute [local instance] _root_.MvPolynomial.gradedAlgebra

variable {m n : ℕ} {R K : Type u} [CommRing R] [CommRing K] [Algebra R K]
variable {i : Fin (m + 1)} {j : Fin (n + 1)}

/-! ### Quotienting is a base change

Absent from Mathlib at the pinned revision: `Algebra.TensorProduct.quotIdealMapEquivQuotTensor`
gives the ring isomorphism `B ⧸ I·B ≅ (A ⧸ I) ⊗[A] B`, but there is no categorical `IsPushout` for
the quotient square, which is what pastes with `isPushout_sndFiberChartMap`.
-/

/-- **Quotienting by an ideal is a base change.**

For a ring map `f : P ⟶ T` and an ideal `I` of `P`, the square

```
P ------ mk ------> P ⧸ I
|                     |
| f                   |
↓                     ↓
T -- mk --> T ⧸ (I.map f)
```

is a pushout of commutative rings: a map out of `T` killing `f '' I` is exactly a map out of
`T ⧸ I·T`.  Uniqueness is surjectivity of `Ideal.Quotient.mk`. -/
theorem isPushout_quotientMk {P T : CommRingCat.{u}} (f : P ⟶ T) (I : Ideal P) :
    IsPushout (ofHom (Ideal.Quotient.mk I)) f
      (ofHom (Ideal.Quotient.lift I
        ((Ideal.Quotient.mk (I.map f.hom)).comp f.hom)
        (fun _ ha => Ideal.Quotient.eq_zero_iff_mem.mpr (Ideal.mem_map_of_mem _ ha))))
      (ofHom (Ideal.Quotient.mk (I.map f.hom))) := by
  have hw : CommSq (ofHom (Ideal.Quotient.mk I)) f
      (ofHom (Ideal.Quotient.lift I
        ((Ideal.Quotient.mk (I.map f.hom)).comp f.hom)
        (fun _ ha => Ideal.Quotient.eq_zero_iff_mem.mpr (Ideal.mem_map_of_mem _ ha))))
      (ofHom (Ideal.Quotient.mk (I.map f.hom))) := ⟨by ext p; rfl⟩
  refine IsPushout.of_isColimit' hw (PushoutCocone.isColimitAux' _ fun s => ?_)
  have hker : I ≤ Ideal.comap f.hom (RingHom.ker (PushoutCocone.inr s).hom) := by
    intro a ha
    have h := congrArg (fun φ => (CommRingCat.Hom.hom φ) a) s.condition
    simp only [CommRingCat.hom_comp, RingHom.coe_comp, Function.comp_apply,
      CommRingCat.hom_ofHom] at h
    have h0 : (PushoutCocone.inl s).hom (Ideal.Quotient.mk I a) = 0 := by
      rw [Ideal.Quotient.eq_zero_iff_mem.mpr ha, map_zero]
    exact RingHom.mem_ker.mpr (h.symm.trans h0)
  refine ⟨ofHom (Ideal.Quotient.lift (I.map f.hom) (PushoutCocone.inr s).hom
      (fun x hx => RingHom.mem_ker.mp (Ideal.map_le_iff_le_comap.mpr hker hx))), ?_, ?_, ?_⟩
  · ext p
    have h := congrArg (fun φ => (CommRingCat.Hom.hom φ) p) s.condition
    exact h.symm
  · ext x
    rfl
  · intro l _ hl2
    ext u
    obtain ⟨v, rfl⟩ := Ideal.Quotient.mk_surjective (I := Ideal.map f.hom I) u
    exact RingHom.congr_fun (congrArg CommRingCat.Hom.hom hl2) v

/-- Substituting a point of the `j`-th chart into the second block sends the first-block
inclusion to the first-block inclusion: `a ↦ a ⊗ₜ 1 ↦ 1 ⊗ₜ a`. -/
theorem includeLeft_comp_sndFiberChartMap
    (y : ProjectiveSpace.StandardChartRing n R j →ₐ[R] K) :
    (ofHom (Algebra.TensorProduct.includeLeftRingHom
        (A := ProjectiveSpace.StandardChartRing m R i)
        (B := ProjectiveSpace.StandardChartRing n R j))) ≫
        ofHom (sndFiberChartMap (i := i) y).toRingHom =
      ofHom (Algebra.TensorProduct.includeRight
        (A := K) (B := ProjectiveSpace.StandardChartRing m R i)).toRingHom := by
  ext a
  change sndFiberChartMap (i := i) y (a ⊗ₜ[R] 1) = _
  rw [sndFiberChartMap_tmul]
  simp

/-- Substituting a point of the `j`-th chart into the second block sends the second-block
inclusion to the point itself: `b ↦ 1 ⊗ₜ b ↦ y b ⊗ₜ 1`. -/
theorem includeRight_comp_sndFiberChartMap
    (y : ProjectiveSpace.StandardChartRing n R j →ₐ[R] K) :
    (ofHom (Algebra.TensorProduct.includeRight
        (A := ProjectiveSpace.StandardChartRing m R i)
        (B := ProjectiveSpace.StandardChartRing n R j)).toRingHom) ≫
        ofHom (sndFiberChartMap (i := i) y).toRingHom =
      ofHom y.toRingHom ≫
        ofHom (Algebra.TensorProduct.includeLeftRingHom
          (A := K) (B := ProjectiveSpace.StandardChartRing m R i)) := by
  ext b
  change sndFiberChartMap (i := i) y (1 ⊗ₜ[R] b) = _
  rw [sndFiberChartMap_tmul]
  simp

/-- The structure map of the chart ring over `R` factors through the second-block inclusion. -/
theorem algebraMap_comp_includeRight
    (y : ProjectiveSpace.StandardChartRing n R j →ₐ[R] K) :
    ofHom (algebraMap R (ProjectiveSpace.StandardChartRing n R j)) ≫ ofHom y.toRingHom =
      ofHom (algebraMap R K) := by
  ext r
  exact y.commutes r

/--
**Substituting a point of the `j`-th chart into the second block is a base change.**

The square

```
S_y --- y ---> K
 |             |
 ↓             ↓
Sₓ ⊗ S_y --> K ⊗ Sₓ
```

is a pushout of commutative rings.  Proof by pasting: it is the right-hand square of a rectangle
whose left-hand square is the tensor-product pushout for `R → Sₓ`, `R → S_y`, and whose composite
is the tensor-product pushout for `R → K`, `R → Sₓ`.
-/
theorem isPushout_sndFiberChartMap
    (y : ProjectiveSpace.StandardChartRing n R j →ₐ[R] K) :
    IsPushout (ofHom y.toRingHom)
      (ofHom (Algebra.TensorProduct.includeRight
        (A := ProjectiveSpace.StandardChartRing m R i)
        (B := ProjectiveSpace.StandardChartRing n R j)).toRingHom)
      (ofHom (Algebra.TensorProduct.includeLeftRingHom
        (A := K) (B := ProjectiveSpace.StandardChartRing m R i)))
      (ofHom (sndFiberChartMap (i := i) y).toRingHom) := by
  refine ((CommRingCat.isPushout_tensorProduct R
    (ProjectiveSpace.StandardChartRing m R i)
    (ProjectiveSpace.StandardChartRing n R j)).flip.paste_horiz_iff
      (includeRight_comp_sndFiberChartMap (i := i) y).symm).mp ?_
  rw [algebraMap_comp_includeRight y, includeLeft_comp_sndFiberChartMap (i := i) y]
  exact CommRingCat.isPushout_tensorProduct R K (ProjectiveSpace.StandardChartRing m R i)


/-! ### The two squares pasted -/

/--
**The chart of the base-changed zero locus is a fibre product** (ring level).

Pasting `isPushout_sndFiberChartMap` on top of `isPushout_quotientMk` for the chart-equation
ideal: for any ideal `I` of the product-chart ring,

```
S_y  ------------- y -------------->  K
 |                                    |
 | includeRight ≫ mk                  | includeLeft ≫ mk
 ↓                                    ↓
(Sₓ ⊗ S_y) ⧸ I  -----------------> (K ⊗ Sₓ) ⧸ I.map(sndFiber)
```

is a pushout.  Taking `I = Ideal.span {chartEquation m n R i j F}`, the bottom-right corner is
`(K ⊗ Sₓ) ⧸ (substituted equation)` by `map_span_chartEquation_sndFiberChartMap`, which is the
affine model of the base-changed conic bundle.
-/
theorem isPushout_chartQuotient
    (y : ProjectiveSpace.StandardChartRing n R j →ₐ[R] K)
    (I : Ideal (StandardChartRing m n R i j)) :
    IsPushout (ofHom y.toRingHom)
      (ofHom (Algebra.TensorProduct.includeRight
          (A := ProjectiveSpace.StandardChartRing m R i)
          (B := ProjectiveSpace.StandardChartRing n R j)).toRingHom ≫
        ofHom (Ideal.Quotient.mk I))
      (ofHom (Algebra.TensorProduct.includeLeftRingHom
          (A := K) (B := ProjectiveSpace.StandardChartRing m R i)) ≫
        ofHom (Ideal.Quotient.mk (I.map (sndFiberChartMap (i := i) y).toRingHom)))
      (ofHom (Ideal.Quotient.lift I
        ((Ideal.Quotient.mk (I.map (sndFiberChartMap (i := i) y).toRingHom)).comp
          (sndFiberChartMap (i := i) y).toRingHom)
        (fun _ ha => Ideal.Quotient.eq_zero_iff_mem.mpr (Ideal.mem_map_of_mem _ ha)))) :=
  (isPushout_sndFiberChartMap (i := i) y).paste_vert
    (isPushout_quotientMk (ofHom (sndFiberChartMap (i := i) y).toRingHom) I).flip

/--
**The scheme-level chart identification.**

`Spec` of `isPushout_chartQuotient`: the affine scheme
`Spec ((K ⊗ Sₓ) ⧸ I.map (sndFiberChartMap y))` is the fibre product of the chart of the zero locus
`Spec ((Sₓ ⊗ S_y) ⧸ I)` with `Spec K` over the `j`-th chart of `ℙⁿ_R`.

This is the square that `exists_chartEquation_openImmersion` needs in order to exhibit the affine
model as an open subscheme of the base change: pasting it with the open immersion of the chart into
the zero locus, and with the base change of `ψ : Spec A ⟶ T`, produces the required `r`.
-/
theorem isPullback_SpecMap_chartQuotient
    (y : ProjectiveSpace.StandardChartRing n R j →ₐ[R] K)
    (I : Ideal (StandardChartRing m n R i j)) :
    IsPullback
      (Spec.map (ofHom (Algebra.TensorProduct.includeLeftRingHom
          (A := K) (B := ProjectiveSpace.StandardChartRing m R i)) ≫
        ofHom (Ideal.Quotient.mk (I.map (sndFiberChartMap (i := i) y).toRingHom))))
      (Spec.map (ofHom (Ideal.Quotient.lift I
        ((Ideal.Quotient.mk (I.map (sndFiberChartMap (i := i) y).toRingHom)).comp
          (sndFiberChartMap (i := i) y).toRingHom)
        (fun _ ha => Ideal.Quotient.eq_zero_iff_mem.mpr (Ideal.mem_map_of_mem _ ha)))))
      (Spec.map (ofHom y.toRingHom))
      (Spec.map (ofHom (Algebra.TensorProduct.includeRight
          (A := ProjectiveSpace.StandardChartRing m R i)
          (B := ProjectiveSpace.StandardChartRing n R j)).toRingHom ≫
        ofHom (Ideal.Quotient.mk I))) :=
  isPullback_SpecMap_of_isPushout _ _ _ _ (isPushout_chartQuotient (i := i) y I)

/--
**The scheme-level form: the chart of the base change is a fibre product.**

`Spec` turns the pushout of `isPushout_sndFiberChartMap` into a pullback square, so
`Spec (K ⊗[R] Sₓ)` is the fibre product of the standard product chart with `Spec K` over the
`j`-th chart of `ℙⁿ_R`.
-/
theorem isPullback_SpecMap_sndFiberChartMap
    (y : ProjectiveSpace.StandardChartRing n R j →ₐ[R] K) :
    IsPullback
      (Spec.map (ofHom (Algebra.TensorProduct.includeLeftRingHom
        (A := K) (B := ProjectiveSpace.StandardChartRing m R i))))
      (Spec.map (ofHom (sndFiberChartMap (i := i) y).toRingHom))
      (Spec.map (ofHom y.toRingHom))
      (Spec.map (ofHom (Algebra.TensorProduct.includeRight
        (A := ProjectiveSpace.StandardChartRing m R i)
        (B := ProjectiveSpace.StandardChartRing n R j)).toRingHom)) :=
  isPullback_SpecMap_of_isPushout _ _ _ _ (isPushout_sndFiberChartMap (i := i) y)

end

end BConicBundleMultisections.BiprojectiveSpace
