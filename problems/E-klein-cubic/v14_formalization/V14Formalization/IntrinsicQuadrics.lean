/-
Copyright (c) 2026 V14Formalization contributors.
Released under Apache 2.0 license.
-/
module

public import V14Formalization.SymmetricAlgebraGraded
public import V14Formalization.SymmetricAlgebraFunctor
public import V14Formalization.GradedQuotient
public import Mathlib.LinearAlgebra.Contraction
public import Mathlib.LinearAlgebra.Dimension.Free
public import Mathlib.Algebra.MvPolynomial.Funext

/-!
# Degree-two generators from a bilinear map, without a basis

A bilinear map `w : M →ₗ M →ₗ N` on a finite-dimensional `M` determines a
family of quadrics on `M`, one for each functional on `N`: the quadratic form
`x ↦ φ (w x x)`.  To cut a subscheme out of `ℙ(M) = Proj (Sym (M*))` these
quadrics have to be *elements of* `Sym (M*)`, not functions, and the passage
from one to the other is the only place a basis is usually introduced.

It is not needed.  The composite

    N*  --(lift w)ᵀ-->  (M ⊗ M)*  --dualDistribEquiv⁻¹-->  M* ⊗ M*  --mul-->  Sym (M*)

is three canonical maps; `dualDistribEquiv` is basis-free in its statement and
needs only `Module.Finite`/`Module.Free`.  `quadrics w` is that composite, and
`quadrics_mem_grade_two` says it lands in degree two.

For the Grassmannian quadrics take `w` to be the wedge product
`⋀²U →ₗ ⋀²U →ₗ ⋀⁴U`, which Mathlib supplies as `DirectSum.gMulLHom` on the
graded pieces of the exterior algebra, restricted along `M ↪ ⋀²U`.
-/

noncomputable section

open Module TensorProduct SymmetricAlgebra

namespace V14Formalization
namespace IntrinsicQuadrics

variable {k M N : Type*} [Field k] [AddCommGroup M] [Module k M]
  [FiniteDimensional k M] [AddCommGroup N] [Module k N]

/-- Multiplication of two linear forms inside the symmetric algebra. -/
@[expose] public def symMul2 (k M : Type*) [Field k] [AddCommGroup M] [Module k M] :
    Dual k M ⊗[k] Dual k M →ₗ[k] SymmetricAlgebra k (Dual k M) :=
  TensorProduct.lift
    ((LinearMap.mul k (SymmetricAlgebra k (Dual k M))).compl₁₂
      (SymmetricAlgebra.ι k (Dual k M)) (SymmetricAlgebra.ι k (Dual k M)))

omit [FiniteDimensional k M] in
public theorem symMul2_tmul (f g : Dual k M) :
    symMul2 k M (f ⊗ₜ g) = SymmetricAlgebra.ι k _ f * SymmetricAlgebra.ι k _ g :=
  rfl

/-- The quadrics attached to a bilinear map `w : M →ₗ M →ₗ N`: for each
functional on `N`, a degree-two element of `Sym (M*)`.  No basis of `M`, and no
system of coordinates on `N`, is involved. -/
@[expose] public def quadrics (w : M →ₗ[k] M →ₗ[k] N) :
    Dual k N →ₗ[k] SymmetricAlgebra k (Dual k M) :=
  symMul2 k M ∘ₗ (TensorProduct.dualDistribEquiv k M M).symm.toLinearMap ∘ₗ
    (TensorProduct.lift w).dualMap

/-- The quadrics are homogeneous of degree two. -/
public theorem quadrics_mem_grade_two (w : M →ₗ[k] M →ₗ[k] N) (φ : Dual k N) :
    quadrics w φ ∈ SymmetricAlgebra.grade k (Dual k M) 2 := by
  show symMul2 k M _ ∈ _
  generalize (((TensorProduct.dualDistribEquiv k M M).symm.toLinearMap ∘ₗ
    (TensorProduct.lift w).dualMap) φ) = t
  induction t using TensorProduct.induction_on with
  | zero => simp
  | tmul f g =>
    rw [symMul2_tmul]
    show _ ∈ LinearMap.range (SymmetricAlgebra.ι k (Dual k M)) ^ 2
    rw [sq]
    exact Submodule.mul_mem_mul (LinearMap.mem_range_self _ f) (LinearMap.mem_range_self _ g)
  | add x y hx hy => rw [map_add]; exact Submodule.add_mem _ hx hy

/-! ## Naturality

`quadrics` is natural: a self-map `α` of `M` intertwining `w` with a self-map
`ψ` of `N` transports the quadrics of `w` to the quadrics of `w`.  This is what
makes the ideal they generate stable under a group acting on `M` and `N`
compatibly, and hence what gives `Proj` of the quotient a group action.
-/

omit [FiniteDimensional k M] in
private theorem symMul2_map (α : M →ₗ[k] M) (t : Dual k M ⊗[k] Dual k M) :
    SymmetricAlgebra.map (α.dualMap) (symMul2 k M t) =
      symMul2 k M (TensorProduct.map α.dualMap α.dualMap t) := by
  induction t using TensorProduct.induction_on with
  | zero => simp
  | tmul f g => simp [symMul2_tmul]
  | add x y hx hy => simp [hx, hy]

omit [FiniteDimensional k M] in
private theorem dualDistrib_map (α : M →ₗ[k] M) (t : Dual k M ⊗[k] Dual k M) :
    TensorProduct.dualDistrib k M M (TensorProduct.map α.dualMap α.dualMap t) =
      (TensorProduct.map α α).dualMap (TensorProduct.dualDistrib k M M t) := by
  induction t using TensorProduct.induction_on with
  | zero => simp
  | tmul f g => exact TensorProduct.ext' fun m n => by simp
  | add x y hx hy => simp [hx, hy]

private theorem dualDistribEquiv_apply (t : Dual k M ⊗[k] Dual k M) :
    TensorProduct.dualDistribEquiv k M M t = TensorProduct.dualDistrib k M M t := rfl

/-- **Naturality of `quadrics`.**  If `α` on `M` and `ψ` on `N` intertwine `w`,
then pulling a functional back along `ψ` is the same as pushing the quadric
forward along `α`. -/
public theorem quadrics_naturality (w : M →ₗ[k] M →ₗ[k] N) (α : M →ₗ[k] M) (ψ : N →ₗ[k] N)
    (hw : ∀ x y, w (α x) (α y) = ψ (w x y)) (φ : Dual k N) :
    SymmetricAlgebra.map (α.dualMap) (quadrics w φ) = quadrics w (ψ.dualMap φ) := by
  have hlift : ∀ z : M ⊗[k] M,
      (TensorProduct.lift w) ((TensorProduct.map α α) z) = ψ ((TensorProduct.lift w) z) := by
    intro z
    induction z using TensorProduct.induction_on with
    | zero => simp
    | tmul x y => simpa using hw x y
    | add u v hu hv => simp [hu, hv]
  set t : Dual k M ⊗[k] Dual k M :=
    (TensorProduct.dualDistribEquiv k M M).symm ((TensorProduct.lift w).dualMap φ) with ht
  have hlhs : quadrics w φ = symMul2 k M t := rfl
  have hrhs : quadrics w (ψ.dualMap φ) =
      symMul2 k M ((TensorProduct.dualDistribEquiv k M M).symm
        ((TensorProduct.lift w).dualMap (ψ.dualMap φ))) := rfl
  rw [hlhs, symMul2_map, hrhs]
  congr 1
  apply (TensorProduct.dualDistribEquiv k M M).injective
  rw [LinearEquiv.apply_symm_apply, dualDistribEquiv_apply, dualDistrib_map,
    ← dualDistribEquiv_apply, ht, LinearEquiv.apply_symm_apply]
  refine LinearMap.ext fun z => ?_
  exact congrArg φ (hlift z)

/-! ## Naturality in the module, and evaluation

`quadrics_naturality` moves `w` along an endomorphism of `M`.  The comparison
with a coordinate model needs the version that moves along a map `M →ₗ L` into
a *larger* space, restricting `w` to `M`; and it needs to know what a quadric
evaluates to at a point of `M`.  Both are proved here.
-/

section Restrict

variable {L : Type*} [AddCommGroup L] [Module k L] [FiniteDimensional k L]

omit [FiniteDimensional k M] [FiniteDimensional k L] in
private theorem symMul2_comp (α : M →ₗ[k] L) (t : Dual k L ⊗[k] Dual k L) :
    SymmetricAlgebra.map (α.dualMap) (symMul2 k L t) =
      symMul2 k M (TensorProduct.map α.dualMap α.dualMap t) := by
  induction t using TensorProduct.induction_on with
  | zero => simp
  | tmul f g => simp [symMul2_tmul]
  | add x y hx hy => simp [hx, hy]

omit [FiniteDimensional k M] [FiniteDimensional k L] in
private theorem dualDistrib_comp (α : M →ₗ[k] L) (t : Dual k L ⊗[k] Dual k L) :
    TensorProduct.dualDistrib k M M (TensorProduct.map α.dualMap α.dualMap t) =
      (TensorProduct.map α α).dualMap (TensorProduct.dualDistrib k L L t) := by
  induction t using TensorProduct.induction_on with
  | zero => simp
  | tmul f g => exact TensorProduct.ext' fun m n => by simp
  | add x y hx hy => simp [hx, hy]

/-- **Naturality of `quadrics` in the module.**  Restricting the bilinear map
along `α : M →ₗ L` restricts its quadrics along `Sym (αᵀ)`.  With `α` the
inclusion of a subspace this is what says that the quadrics of `V₁₄ ⊆ ℙ(M)`
are the restrictions of the Plücker quadrics on `ℙ(⋀²U)`. -/
public theorem quadrics_comp (w : L →ₗ[k] L →ₗ[k] N) (α : M →ₗ[k] L) (φ : Dual k N) :
    SymmetricAlgebra.map (α.dualMap) (quadrics w φ) = quadrics (w.compl₁₂ α α) φ := by
  set t : Dual k L ⊗[k] Dual k L :=
    (TensorProduct.dualDistribEquiv k L L).symm ((TensorProduct.lift w).dualMap φ) with ht
  have hlhs : quadrics w φ = symMul2 k L t := rfl
  rw [hlhs, symMul2_comp]
  show _ = symMul2 k M ((TensorProduct.dualDistribEquiv k M M).symm
    ((TensorProduct.lift (w.compl₁₂ α α)).dualMap φ))
  congr 1
  apply (TensorProduct.dualDistribEquiv k M M).injective
  rw [LinearEquiv.apply_symm_apply, dualDistribEquiv_apply, dualDistrib_comp,
    ← dualDistribEquiv_apply, ht, LinearEquiv.apply_symm_apply]
  refine LinearMap.ext fun z => ?_
  induction z using TensorProduct.induction_on with
  | zero => simp
  | tmul x y => rfl
  | add u v hu hv => simp only [map_add, hu, hv]

end Restrict

/-! ### Evaluation at a point -/

/-- Evaluation of a symmetric-algebra element on `M*` at a point of `M`. -/
@[expose] public def evalAt (x : M) : SymmetricAlgebra k (Dual k M) →ₐ[k] k :=
  SymmetricAlgebra.lift (Module.Dual.eval k M x)

omit [FiniteDimensional k M] in
@[simp] public theorem evalAt_ι (x : M) (φ : Dual k M) :
    evalAt x (SymmetricAlgebra.ι k (Dual k M) φ) = φ x := by
  simp [evalAt]

omit [FiniteDimensional k M] in
private theorem evalAt_symMul2 (x : M) (t : Dual k M ⊗[k] Dual k M) :
    evalAt x (symMul2 k M t) = TensorProduct.dualDistrib k M M t (x ⊗ₜ[k] x) := by
  induction t using TensorProduct.induction_on with
  | zero => simp
  | tmul f g => simp [symMul2_tmul]
  | add u v hu hv => simp [hu, hv]

/-- **A quadric evaluates to the obvious thing.** -/
public theorem evalAt_quadrics (w : M →ₗ[k] M →ₗ[k] N) (φ : Dual k N) (x : M) :
    evalAt x (quadrics w φ) = φ (w x x) := by
  show evalAt x (symMul2 k M ((TensorProduct.dualDistribEquiv k M M).symm
    ((TensorProduct.lift w).dualMap φ))) = _
  rw [evalAt_symMul2, ← dualDistribEquiv_apply, LinearEquiv.apply_symm_apply]
  rfl

/-- Two elements of `Sym (M*)` with the same values on `M` are equal, over an
infinite field. -/
public theorem eq_of_evalAt_eq [Infinite k] {p q : SymmetricAlgebra k (Dual k M)}
    (h : ∀ x : M, evalAt x p = evalAt x q) : p = q := by
  classical
  set c : Basis (Fin (Module.finrank k M)) k M := Module.finBasis k M with hc
  have key : ∀ (r : SymmetricAlgebra k (Dual k M)) (x : M),
      evalAt x r = MvPolynomial.eval (fun i => c.repr x i)
        (SymmetricAlgebra.equivMvPolynomial c.dualBasis r) := by
    intro r x
    have hext : (evalAt x : SymmetricAlgebra k (Dual k M) →ₐ[k] k) =
        (MvPolynomial.aeval (fun i => (c.repr x i : k))).comp
          (SymmetricAlgebra.equivMvPolynomial c.dualBasis).toAlgHom := by
      apply SymmetricAlgebra.algHom_ext
      apply Basis.ext c.dualBasis
      intro i
      show evalAt x (SymmetricAlgebra.ι k (Dual k M) (c.dualBasis i)) = _
      rw [evalAt_ι]
      show _ = MvPolynomial.aeval (fun j => (c.repr x j : k))
        (SymmetricAlgebra.equivMvPolynomial c.dualBasis
          (SymmetricAlgebra.ι k (Dual k M) (c.dualBasis i)))
      rw [SymmetricAlgebra.equivMvPolynomial_ι_apply, MvPolynomial.aeval_X]
      simp
    exact congr($hext r)
  apply (SymmetricAlgebra.equivMvPolynomial c.dualBasis).injective
  apply MvPolynomial.funext
  intro y
  obtain ⟨x, hx⟩ : ∃ x : M, (fun i => c.repr x i) = y :=
    ⟨c.repr.symm (Finsupp.equivFunOnFinite.symm y), by funext i; simp⟩
  rw [← hx, ← key p x, ← key q x]
  exact h x

/-- The homogeneous ideal of `Sym (M*)` generated by the quadrics of `w`. -/
@[expose] public def quadricIdeal (w : M →ₗ[k] M →ₗ[k] N) :
    HomogeneousIdeal (SymmetricAlgebra.grade k (Dual k M)) :=
  ⟨Ideal.span (Set.range (quadrics w)), by
    refine Ideal.homogeneous_span _ _ ?_
    rintro _ ⟨φ, rfl⟩
    exact ⟨2, quadrics_mem_grade_two w φ⟩⟩

public theorem quadrics_mem_quadricIdeal (w : M →ₗ[k] M →ₗ[k] N) (φ : Dual k N) :
    quadrics w φ ∈ (quadricIdeal w).toIdeal :=
  Ideal.subset_span ⟨φ, rfl⟩

/-- **The quadric ideal is stable** under any endomorphism of `M` that
intertwines `w` with an endomorphism of `N`.  This is what makes `Proj` of the
quotient carry a group action. -/
public theorem quadricIdeal_map_le (w : M →ₗ[k] M →ₗ[k] N) (α : M →ₗ[k] M) (ψ : N →ₗ[k] N)
    (hw : ∀ x y, w (α x) (α y) = ψ (w x y)) :
    (quadricIdeal w).map (SymmetricAlgebra.gradedMap (α.dualMap)).toGradedRingHom ≤
      quadricIdeal w := by
  show Ideal.map _ (Ideal.span (Set.range (quadrics w))) ≤ (quadricIdeal w).toIdeal
  rw [Ideal.map_span, Ideal.span_le]
  rintro _ ⟨_, ⟨φ, rfl⟩, rfl⟩
  have h := quadrics_naturality w α ψ hw φ
  show (SymmetricAlgebra.gradedMap (α.dualMap)).toGradedRingHom (quadrics w φ) ∈ _
  rw [show (SymmetricAlgebra.gradedMap (α.dualMap)).toGradedRingHom (quadrics w φ) =
    SymmetricAlgebra.map (α.dualMap) (quadrics w φ) from rfl, h]
  exact quadrics_mem_quadricIdeal w _

end IntrinsicQuadrics
end V14Formalization
