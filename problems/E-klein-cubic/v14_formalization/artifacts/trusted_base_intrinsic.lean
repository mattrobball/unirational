module

public import Mathlib

/-! # Trusted base

Target: `V14Formalization.IntrinsicHeadline.noEquivariantRationalMap_intrinsicV14`

Boundary: V14Formalization, BConicBundleMultisections

145 declarations from 18 modules, inlined in dependency order with every proof replaced by `sorry`. Imports above are outside the boundary and are trusted as given.
-/

universe u v w

-- ═══ WeilRep ═══

open Polynomial AddChar MulChar Matrix BigOperators
noncomputable section
namespace V14Formalization
namespace WeilRep

@[expose] public instance : Fact (Nat.Prime 11)  := sorry

@[expose] public instance : NeZero (11 : ℕ)  := sorry

/-- **A field with a chosen primitive 11th root of unity.**

This is the whole of what the even Weil representation of `SL(2,11)` asks of
its coefficient field: the additive character `ψ`, the Gauss sum and the
Fourier operator are built out of `zeta` and nothing else.  It is a
data-carrying class on purpose — the representation depends on *which* root is
chosen, and two choices give genuinely different (though isomorphic) models. -/
public class HasCycl11 (E : Type u) [Field E] where
  /-- The chosen root. -/
  zeta : E
  /-- It is a primitive 11th root of unity. -/
  isPrimitiveRoot_zeta : IsPrimitiveRoot zeta 11

@[expose] public def Φ11 : ℚ[X] := cyclotomic 11 ℚ

@[expose] public instance : Fact (Irreducible Φ11)  := sorry

public abbrev K := AdjoinRoot Φ11

@[expose] public instance : Field K := inferInstance

@[expose] public instance : CharZero K  := sorry

/-- The image of `X` in `ℚ[X]/(Φ₁₁)`: a primitive 11th root of unity. -/
@[expose] public def rootK : K := AdjoinRoot.root Φ11

public theorem orderOf_rootK : orderOf rootK = 11  := sorry

/-- `K = ℚ(ζ₁₁)` is a field with a primitive 11th root of unity, so everything
below applies to it.  This is the only place `AdjoinRoot Φ₁₁` is used. -/
@[expose] public instance : HasCycl11 K := ⟨rootK, IsPrimitiveRoot.iff_orderOf.2 orderOf_rootK⟩

variable {E : Type u} [Field E] [CharZero E] [HasCycl11 E]

/-- The chosen primitive 11th root of unity of the base field. -/
@[expose] public def ζ : E := HasCycl11.zeta

omit [CharZero E] in
public theorem ζ_pow_eleven : (ζ : E) ^ (11 : ℕ) = 1  := sorry

@[expose] public def ψ : AddChar (ZMod 11) E := zmodChar 11 (ζ_pow_eleven (E := E))

@[expose] public def χ₂ℤ : MulChar (ZMod 11) ℤ := quadraticChar (ZMod 11)

omit [CharZero E] [HasCycl11 E] in
@[expose] public def χ₂ : MulChar (ZMod 11) E := χ₂ℤ.ringHomComp (algebraMap ℤ E)

@[expose] public def gauss : E := ∑ x : ZMod 11, ψ (x ^ 2)

@[expose] public def cFourier : E := gauss⁻¹

public abbrev Fun (L : Type u) [Field L] : Type u := ZMod 11 → L

omit [CharZero E] [HasCycl11 E] in
@[expose] public instance : AddCommGroup (Fun E) := inferInstance

omit [CharZero E] [HasCycl11 E] in
@[expose] public instance : Module E (Fun E) := inferInstance

/-- Full Fourier transform. -/
@[expose] public def Sfull : (Fun E) →ₗ[E] (Fun E) where
  toFun f := fun x => cFourier * ∑ y : ZMod 11, ψ (x * y) * f y
  map_add' f g := sorry
  map_smul' r f := sorry

/-- Even functions f(−x) = f(x). -/
@[expose] public def EvenSub (L : Type u) [Field L] : Submodule L (Fun L) where
  carrier := {f | ∀ x, f (-x) = f x}
  add_mem' := sorry
  zero_mem' := sorry
  smul_mem' := sorry

public protected abbrev U (L : Type u) [Field L] : Submodule L (Fun L) := EvenSub L

omit [CharZero E] [HasCycl11 E] in
@[expose] public instance : Module E (WeilRep.U E) := inferInstance

/-- Half-quadratic phase: ψ(b · x² / 2). Standard Weil normalization so that
the Bruhat big-cell formula matches the Fourier–unipotent identity W N(t) W. -/
@[expose] public def twoInv : ZMod 11 := (2 : ZMod 11)⁻¹

/-- Multiplication by ψ(b · x² / 2) on (Fun E); preserves even functions. -/
@[expose] public def Tfull_b (b : ZMod 11) : (Fun E) →ₗ[E] (Fun E) where
  toFun f := fun x => ψ (b * x ^ 2 * twoInv) * f x
  map_add' := sorry
  map_smul' := sorry

end WeilRep
end V14Formalization


-- ═══ WeilRepSL2 ═══

open Matrix Matrix.SpecialLinearGroup AddChar MulChar BigOperators
open V14Formalization.WeilRep
noncomputable section
namespace V14Formalization
namespace WeilRepSL2
variable {E : Type u} [Field E] [CharZero E] [HasCycl11 E]

public abbrev F := ZMod 11

public abbrev SLG := SpecialLinearGroup (Fin 2) F

@[expose] public instance : Fact (Nat.Prime 11)  := sorry

@[expose] public def ea (g : SLG) : F := (g : Matrix (Fin 2) (Fin 2) F) 0 0

@[expose] public def eb (g : SLG) : F := (g : Matrix (Fin 2) (Fin 2) F) 0 1

@[expose] public def ec (g : SLG) : F := (g : Matrix (Fin 2) (Fin 2) F) 1 0

@[expose] public def ed (g : SLG) : F := (g : Matrix (Fin 2) (Fin 2) F) 1 1

public theorem ea_ne_zero_of_ec_zero (g : SLG) (hc : ec g = 0) : ea g ≠ 0  := sorry

/-- ρ(diag(t)): f(x) ↦ χ₂(t) · f(t · x).  (Right scaling so D∘N(t)=N(t s²)∘D.) -/
@[expose] public def Dfull (t : F) (_ht : t ≠ 0) : (Fun E) →ₗ[E] (Fun E) where
  toFun f := fun x => χ₂ t * f (t * x)
  map_add' := sorry
  map_smul' := sorry

@[expose] public def Nfull (t : F) : (Fun E) →ₗ[E] (Fun E) := Tfull_b t

@[expose] public def Wfull : (Fun E) →ₗ[E] (Fun E) := Sfull

@[expose] public def borelFun (g : SLG) (hc : ec g = 0) : (Fun E) →ₗ[E] (Fun E) :=
  Nfull (eb g * ea g) ∘ₗ Dfull (ea g) (ea_ne_zero_of_ec_zero g hc)

/-- Positive NWDN kernel of a big-cell Bruhat factor. -/
@[expose] public def bigCellPos (g : SLG) (hc : ec g ≠ 0) : (Fun E) →ₗ[E] (Fun E) :=
  Nfull (ea g * (ec g)⁻¹) ∘ₗ Wfull ∘ₗ Dfull (ec g) hc ∘ₗ
    Nfull ((ec g)⁻¹ * ed g)

/-- Big-cell factor with the metaplectic sign so that the even Weil
representation of SL₂ is a true monoid homomorphism (D(−ec) = −D(ec)
on even functions forces this overall minus). -/
@[expose] public def bigCellFun (g : SLG) (hc : ec g ≠ 0) : (Fun E) →ₗ[E] (Fun E) :=
  - bigCellPos g hc

@[expose] public def weilFun (g : SLG) : (Fun E) →ₗ[E] (Fun E) :=
  if hc : ec g = 0 then borelFun g hc else bigCellFun g hc

omit [CharZero E] in
public theorem weilFun_preserves_even (g : SLG) {f : (Fun E)}
    (hf : ∀ x, f (-x) = f x) (x : ZMod 11) :
    weilFun g f (-x) = weilFun g f x  := sorry

/-- Weil action on the even module U. -/
@[expose] public def weilU (g : SLG) : (WeilRep.U E) →ₗ[E] (WeilRep.U E) where
  toFun f := ⟨weilFun g f.1, fun x => weilFun_preserves_even g (fun z => f.2 z) x⟩
  map_add' := sorry
  map_smul' := sorry

omit [CharZero E] in
public theorem weilU_one : (weilU (1 : SLG) : (WeilRep.U E) →ₗ[E] (WeilRep.U E)) = LinearMap.id  := sorry

end WeilRepSL2
end V14Formalization


-- ═══ WeilHom ═══

open Matrix Matrix.SpecialLinearGroup
open V14Formalization.WeilRep
open V14Formalization.WeilRepSL2
noncomputable section
namespace V14Formalization
namespace WeilHom
variable {E : Type u} [Field E] [CharZero E] [HasCycl11 E]

public abbrev F := ZMod 11

public abbrev SLG := SpecialLinearGroup (Fin 2) F

public theorem weilU_mul (g h : SLG) : (weilU (g * h) : (WeilRep.U E) →ₗ[E] (WeilRep.U E)) = weilU g ∘ₗ weilU h  := sorry

/-- The even Weil representation as a monoid homomorphism SL₂(F₁₁) → End(U). -/
@[expose] public def weilUHom : SLG →* ((WeilRep.U E) →ₗ[E] (WeilRep.U E)) where
  toFun := weilU
  map_one' := sorry
  map_mul' := sorry

end WeilHom
end V14Formalization


-- ═══ Definitions ═══

noncomputable section
open scoped LinearAlgebra.Projectivization MatrixGroups
namespace V14Formalization

public structure FaithfulLinearRep (k : Type u) [Field k] (G : Type u) [Monoid G]
    (V : Type u) [AddCommGroup V] [Module k V] where
  ρ : Representation k G V
  finiteDimensional : FiniteDimensional k V
  faithful : Function.Injective ρ

end V14Formalization


-- ═══ GeometricFanoCarrier ═══

open scoped BigOperators LinearAlgebra.Projectivization MatrixGroups
open Matrix Matrix.SpecialLinearGroup exteriorPower Module
noncomputable section
namespace V14Formalization
namespace GeometricFanoCarrier

public abbrev k := WeilRep.K

public abbrev F := ZMod 11

public abbrev SLG := SpecialLinearGroup (Fin 2) F

public abbrev PSL2F11 : Type := PSL(2, F)

public abbrev U := WeilRep.U k

@[expose] public instance : Group PSL2F11 := inferInstance

public abbrev Lambda2U : Type := ↥(⋀[k]^2 U)

@[expose] public instance : AddCommGroup Lambda2U := inferInstance

@[expose] public instance : Module k Lambda2U := inferInstance

@[expose] public instance : FiniteDimensional k Lambda2U  := sorry

@[expose] public def weilLambda2 (g : SLG) : Lambda2U →ₗ[k] Lambda2U :=
  exteriorPower.map 2 (WeilHom.weilUHom g)

public theorem weilLambda2_one : weilLambda2 1 = LinearMap.id  := sorry

public theorem weilLambda2_mul (g h : SLG) :
    weilLambda2 (g * h) = weilLambda2 g ∘ₗ weilLambda2 h  := sorry

@[expose] public def weilLambda2Hom : SLG →* (Lambda2U →ₗ[k] Lambda2U) where
  toFun := weilLambda2
  map_one' := sorry
  map_mul' := sorry

public theorem weilLambda2Hom_ker_center :
    Subgroup.center SLG ≤ weilLambda2Hom.ker  := sorry

@[expose] public def pslLambda2Hom : PSL2F11 →* (Lambda2U →ₗ[k] Lambda2U) :=
  QuotientGroup.lift (N := Subgroup.center SLG) weilLambda2Hom weilLambda2Hom_ker_center

end GeometricFanoCarrier
end V14Formalization


-- ═══ SchemeEquivariant ═══

noncomputable section
open CategoryTheory
open scoped AlgebraicGeometry
namespace V14Formalization
namespace SchemeGeometry
open AlgebraicGeometry
open TopologicalSpace

/-- Package an absolute scheme action over `S` after proving that every action
morphism preserves the structure map. -/
@[expose] public noncomputable def actionOverOfIsOver
    {S : Scheme.{u}} {G : Type v} [Group G]
    (X : Action Scheme G) [X.V.Over S]
    (h : ∀ g : G, (X.ρ g).IsOver S) :
    Action (Over S) G where
  V := OverClass.asOver X.V S
  ρ :=
    { toFun := fun g ↦ by
        letI : (X.ρ g).IsOver S := h g
        exact (X.ρ g).asOver S
      map_one' := by
        apply Over.OverMorphism.ext
        simp
      map_mul' := fun g h ↦ by
        apply Over.OverMorphism.ext
        simp }

/-- Precompose a rational map by one automorphism from a group action. -/
@[expose] public noncomputable def actionPrecomp {S : Scheme.{u}} {G : Type v} [Group G]
    (X : Action (Over S) G) [IrreducibleSpace X.V.left]
    {Y : Scheme.{u}} (g : G)
    (f : X.V.left ⤏ Y) : X.V.left ⤏ Y := by
  let e : X.V.left ≅ X.V.left := (Over.forget S).mapIso (X.ρAut g)
  letI : IsIso (X.ρ g).left := by
    change IsIso e.hom
    infer_instance
  letI : IsDominant (X.ρ g).left := inferInstance
  letI : ((X.ρ g).left.toRationalMap).IsDominant := inferInstance
  exact (X.ρ g).left.toRationalMap.comp f

/-- A rational map over `S` commuting with the actions of `G`. -/
public structure EquivariantRationalMap {S : Scheme.{u}} {G : Type v} [Group G]
    (X Y : Action (Over S) G) [IrreducibleSpace X.V.left] where
  map : X.V.left ⤏ Y.V.left
  isOver : map.IsOver S
  equivariant : ∀ g : G,
    actionPrecomp X g map = map.compHom (Y.ρ g).left

/-- Existence of a genuine equivariant rational map of schemes. -/
@[expose] public def HasEquivariantRationalMap {S : Scheme.{u}} {G : Type v} [Group G]
    (X Y : Action (Over S) G) [IrreducibleSpace X.V.left] : Prop :=
  Nonempty (EquivariantRationalMap X Y)

end SchemeGeometry
end V14Formalization


-- ═══ SymmetricAlgebraGraded ═══

@[expose] public section
namespace SymmetricAlgebra
variable {R M : Type*} [CommSemiring R] [AddCommMonoid M] [Module R M]
open scoped DirectSum
variable (R M)

/-- A version of `SymmetricAlgebra.ι` that maps directly into the graded
structure.  This is primarily an auxiliary construction used to provide
`SymmetricAlgebra.gradedAlgebra`. -/
nonrec def GradedAlgebra.ι : M →ₗ[R] ⨁ i : ℕ, ↥(LinearMap.range (ι R M) ^ i) :=
  DirectSum.lof R ℕ (fun i => ↥(LinearMap.range (ι R M) ^ i)) 1 ∘ₗ
    (ι R M).codRestrict _ fun m => by simpa only [pow_one] using LinearMap.mem_range_self _ m

theorem GradedAlgebra.ι_apply (m : M) :
    GradedAlgebra.ι R M m =
      DirectSum.of (fun i : ℕ => ↥(LinearMap.range (SymmetricAlgebra.ι R M) ^ i)) 1
        ⟨SymmetricAlgebra.ι R M m, by
          simpa only [pow_one] using LinearMap.mem_range_self _ m⟩  := sorry

variable {R M}

/-- The symmetric algebra is graded by the powers of the submodule
`(SymmetricAlgebra.ι R M).range`. -/
instance gradedAlgebra :
    GradedAlgebra ((LinearMap.range (ι R M) ^ ·) : ℕ → Submodule R (SymmetricAlgebra R M)) :=
  fast_instance% GradedAlgebra.ofAlgHom _ (lift (GradedAlgebra.ι R M))
    (by
      ext m
      change DirectSum.coeAlgHom (fun i : ℕ => LinearMap.range (ι R M) ^ i)
          (lift (GradedAlgebra.ι R M) (ι R M m)) = ι R M m
      rw [lift_ι_apply, GradedAlgebra.ι_apply R M, DirectSum.coeAlgHom_of])
    fun i x => by
    obtain ⟨x, hx⟩ := x
    dsimp only [Subtype.coe_mk, DirectSum.lof_eq_of]
    induction hx using Submodule.pow_induction_on_left' with
    | algebraMap r =>
      rw [AlgHom.commutes, DirectSum.algebraMap_apply]; rfl
    | add x y i hx hy ihx ihy =>
      rw [map_add, ihx, ihy, ← map_add]
      rfl
    | mem_mul m hm i x hx ih =>
      obtain ⟨_, rfl⟩ := hm
      rw [map_mul, ih, lift_ι_apply, GradedAlgebra.ι_apply R M, DirectSum.of_mul_of]
      exact DirectSum.of_eq_of_gradedMonoid_eq (Sigma.subtype_ext (add_comm _ _) rfl)

/-- The grading on `SymmetricAlgebra R M`, as a named family.  `grade R M i` is
the `R`-submodule of elements of degree `i`. -/
abbrev grade (R M : Type*) [CommSemiring R] [AddCommMonoid M] [Module R M] :
    ℕ → Submodule R (SymmetricAlgebra R M) :=
  fun i => LinearMap.range (ι R M) ^ i

end SymmetricAlgebra


-- ═══ SymmetricAlgebraFunctor ═══

noncomputable section
@[expose] public section
open Module
attribute [local instance] MvPolynomial.gradedAlgebra
namespace SymmetricAlgebra
variable {κ R M N L : Type*} [CommSemiring R]
  [AddCommMonoid M] [Module R M] [AddCommMonoid N] [Module R N]
  [AddCommMonoid L] [Module R L]

/-- Functoriality of the symmetric algebra: a linear map `M →ₗ[R] N` induces an
algebra map `SymmetricAlgebra R M →ₐ[R] SymmetricAlgebra R N`.  This is the
symmetric-algebra analogue of `ExteriorAlgebra.map`. -/
def map (f : M →ₗ[R] N) : SymmetricAlgebra R M →ₐ[R] SymmetricAlgebra R N :=
  lift (ι R N ∘ₗ f)

lemma map_mem_grade (f : M →ₗ[R] N) {i : ℕ} {x : SymmetricAlgebra R M}
    (hx : x ∈ grade R M i) : map f x ∈ grade R N i  := sorry

/-- The symmetric algebra of a linear map, as a morphism of graded algebras. -/
def gradedMap (f : M →ₗ[R] N) : grade R M →ₐᵍ[R] grade R N :=
  { map f with map_mem := sorry }

end SymmetricAlgebra


-- ═══ GradedQuotient ═══

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
    y ∈ grading 𝒜 I i ↔ ∃ a ∈ 𝒜 i, Ideal.Quotient.mk I.toIdeal a = y  := sorry

public theorem mk_mem_grading {i : ι} {a : A} (ha : a ∈ 𝒜 i) :
    Ideal.Quotient.mk I.toIdeal a ∈ grading 𝒜 I i  := sorry

public instance : SetLike.GradedMonoid (grading 𝒜 I)  := sorry

public theorem coeAddMonoidHom_bijective :
    Function.Bijective (DirectSum.coeAddMonoidHom (grading 𝒜 I))  := sorry

/-- **The missing instance.**  The quotient of a graded algebra by a homogeneous
ideal is graded by the images of the graded pieces. -/
public instance gradedAlgebraQuotient : GradedAlgebra (grading 𝒜 I) where
  decompose' := (Equiv.ofBijective _ (coeAddMonoidHom_bijective 𝒜 I)).symm
  left_inv x := sorry
  right_inv x := sorry

/-- The quotient map, as a graded ring hom. -/
@[expose] public def mkGraded : 𝒜 →+*ᵍ grading 𝒜 I where
  __ := Ideal.Quotient.mk I.toIdeal
  map_mem := sorry

end GradedQuotient
end V14Formalization
namespace V14Formalization
namespace GradedQuotient
open HomogeneousIdeal
variable {ι R A B : Type*} [DecidableEq ι] [AddMonoid ι] [CommRing R]
  [CommRing A] [Algebra R A] [CommRing B] [Algebra R B]
variable {𝒜 : ι → Submodule R A} [GradedAlgebra 𝒜] {ℬ : ι → Submodule R B} [GradedAlgebra ℬ]
variable (I : HomogeneousIdeal 𝒜) (J : HomogeneousIdeal ℬ)

/-- A graded ring hom carrying `I` into `J` descends to the quotients. -/
@[expose] public def mapQuot (f : 𝒜 →+*ᵍ ℬ) (hf : I.map f ≤ J) :
    grading 𝒜 I →+*ᵍ grading ℬ J where
  __ := Ideal.Quotient.lift I.toIdeal
    ((Ideal.Quotient.mk J.toIdeal).comp (f : A →+* B)) (by
      intro a ha
      simp only [RingHom.coe_comp, Function.comp_apply, Ideal.Quotient.eq_zero_iff_mem]
      exact hf (Ideal.mem_map_of_mem _ ha))
  map_mem := sorry

variable {C : Type*} [CommRing C] [Algebra R C] {𝒞 : ι → Submodule R C} [GradedAlgebra 𝒞]
end GradedQuotient
end V14Formalization


-- ═══ IntrinsicQuadrics ═══

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

/-- The quadrics attached to a bilinear map `w : M →ₗ M →ₗ N`: for each
functional on `N`, a degree-two element of `Sym (M*)`.  No basis of `M`, and no
system of coordinates on `N`, is involved. -/
@[expose] public def quadrics (w : M →ₗ[k] M →ₗ[k] N) :
    Dual k N →ₗ[k] SymmetricAlgebra k (Dual k M) :=
  symMul2 k M ∘ₗ (TensorProduct.dualDistribEquiv k M M).symm.toLinearMap ∘ₗ
    (TensorProduct.lift w).dualMap

/-- The quadrics are homogeneous of degree two. -/
public theorem quadrics_mem_grade_two (w : M →ₗ[k] M →ₗ[k] N) (φ : Dual k N) :
    quadrics w φ ∈ SymmetricAlgebra.grade k (Dual k M) 2  := sorry

/-- The homogeneous ideal of `Sym (M*)` generated by the quadrics of `w`. -/
@[expose] public def quadricIdeal (w : M →ₗ[k] M →ₗ[k] N) :
    HomogeneousIdeal (SymmetricAlgebra.grade k (Dual k M)) :=
  ⟨Ideal.span (Set.range (quadrics w)), by
    refine Ideal.homogeneous_span _ _ ?_
    rintro _ ⟨φ, rfl⟩
    exact ⟨2, quadrics_mem_grade_two w φ⟩⟩

end IntrinsicQuadrics
end V14Formalization


-- ═══ IntrinsicV14 ═══

noncomputable section
open Module AlgebraicGeometry SymmetricAlgebra
namespace V14Formalization
namespace IntrinsicV14
variable (k U : Type u) [Field k] [AddCommGroup U] [Module k U] [FiniteDimensional k U]
  [Module.Free k U]

/-- The wedge product of two bivectors, valued in `⋀⁴`.  This is the graded
multiplication of the exterior algebra in degrees `2 + 2 = 4`. -/
@[expose] public def wedgePairing :
    ↥(⋀[k]^2 U) →ₗ[k] ↥(⋀[k]^2 U) →ₗ[k] ↥(⋀[k]^4 U) :=
  DirectSum.gMulLHom k (fun n => ⋀[k]^n U)

variable {M : Type u} [AddCommGroup M] [Module k M] [FiniteDimensional k M]
  (incl : M →ₗ[k] ↥(⋀[k]^2 U))

/-- The wedge pairing pulled back to `M` along `incl`. -/
@[expose] public def wedgeOn : M →ₗ[k] M →ₗ[k] ↥(⋀[k]^4 U) :=
  (wedgePairing k U).compl₁₂ incl incl

/-- The homogeneous ideal of `Sym (M*)` generated by the `⋀⁴`-components of
`ω ↦ ω ∧ ω`.  For `dim U = 6` these are the 15 Plücker quadrics. -/
@[expose] public def pluckerIdeal :
    HomogeneousIdeal (SymmetricAlgebra.grade k (Dual k M)) :=
  IntrinsicQuadrics.quadricIdeal (wedgeOn k U incl)

/-- The homogeneous coordinate ring of `V₁₄`, graded. -/
@[expose] public def coordinateRing :
    ℕ → Submodule k (SymmetricAlgebra k (Dual k M) ⧸ (pluckerIdeal k U incl).toIdeal) :=
  GradedQuotient.grading (SymmetricAlgebra.grade k (Dual k M)) (pluckerIdeal k U incl)

public instance : GradedAlgebra (coordinateRing k U incl) :=
  GradedQuotient.gradedAlgebraQuotient _ _

/-- **`V₁₄`, intrinsically.**  `Proj` of the quotient of `Sym (M*)` by the
Plücker quadrics. -/
@[expose] public def scheme : Scheme.{u} :=
  Proj (coordinateRing k U incl)

end IntrinsicV14
end V14Formalization


-- ═══ ProjectiveSpaceIntrinsic ═══

noncomputable section
open CategoryTheory
open scoped AlgebraicGeometry HomogeneousIdeal
namespace V14Formalization
namespace SchemeGeometry
open AlgebraicGeometry Module SymmetricAlgebra
variable {k : Type u} [Field k] {V : Type u} [AddCommGroup V] [Module k V]

/-- Coordinate-free projective space: `Proj` of the symmetric algebra on the
dual of `V`.  This is `ℙ(V)` with no basis in sight. -/
@[expose] public def projectiveSpaceOfModule (k V : Type u) [Field k] [AddCommGroup V]
    [Module k V] : Scheme.{u} :=
  Proj (grade k (Dual k V))

/-- The structure morphism `ℙ(V) ⟶ Spec k`, built exactly as for `Proj` of a
polynomial ring. -/
@[expose] public def projectiveSpaceOfModule.toSpec (k V : Type u) [Field k] [AddCommGroup V]
    [Module k V] : projectiveSpaceOfModule k V ⟶ Spec (.of k) :=
  Proj.toSpecZero (grade k (Dual k V)) ≫
    Spec.map (CommRingCat.ofHom (algebraMap k (grade k (Dual k V) 0)))

public instance projectiveSpaceOfModule_over :
    (projectiveSpaceOfModule k V).CanonicallyOver (Spec (.of k)) where
  hom := projectiveSpaceOfModule.toSpec k V

/-- The graded algebra endomorphism of `Sym (V*)` induced by a linear
endomorphism of `V`, by transposing and applying `Sym`. -/
@[expose] public def dualGradedMap (f : V →ₗ[k] V) :
    grade k (Dual k V) →ₐᵍ[k] grade k (Dual k V) :=
  gradedMap (Module.Dual.transpose (R := k) f)

/-- The side condition of `Proj.map`, discharged whenever the endomorphism has
a two-sided partner making the composite the identity. -/
public theorem irrelevant_le_dualGradedMap (f g : V →ₗ[k] V) (h : g ∘ₗ f = LinearMap.id) :
    (grade k (Dual k V))₊ ≤ ((grade k (Dual k V))₊).map (dualGradedMap f).toGradedRingHom  := sorry

/-- The morphism of schemes `ℙ(V) ⟶ ℙ(V)` induced by a linear automorphism of
`V`, presented by the map and its inverse. -/
@[expose] public def projMapDual (f g : V →ₗ[k] V) (h : g ∘ₗ f = LinearMap.id) :
    projectiveSpaceOfModule k V ⟶ projectiveSpaceOfModule k V :=
  Proj.map (dualGradedMap f).toGradedRingHom (irrelevant_le_dualGradedMap f g h)

@[expose] public instance projMapDual_isOver (f g : V →ₗ[k] V) (h : g ∘ₗ f = LinearMap.id) :
    (projMapDual f g h).IsOver (Spec (.of k))  := sorry

end SchemeGeometry
end V14Formalization


-- ═══ ProjectiveSpaceIntrinsicAction ═══

noncomputable section
open CategoryTheory
open scoped AlgebraicGeometry
namespace V14Formalization
namespace SchemeGeometry
open AlgebraicGeometry Module SymmetricAlgebra
variable {k : Type u} [Field k] {G : Type u} [Group G]
  {V : Type u} [AddCommGroup V] [Module k V]

public theorem rep_inv_comp (ρ : Representation k G V) (g : G) :
    ρ g⁻¹ ∘ₗ ρ g = LinearMap.id  := sorry

/-- The automorphism of `ℙ(V)` attached to a group element. -/
@[expose] public def projRepHom (ρ : Representation k G V) (g : G) :
    projectiveSpaceOfModule k V ⟶ projectiveSpaceOfModule k V :=
  projMapDual (ρ g) (ρ g⁻¹) (rep_inv_comp ρ g)

@[simp] public theorem projRepHom_one (ρ : Representation k G V) :
    projRepHom ρ (1 : G) = 𝟙 _  := sorry

public theorem projRepHom_mul (ρ : Representation k G V) (a b : G) :
    projRepHom ρ (a * b) = projRepHom ρ b ≫ projRepHom ρ a  := sorry

/-- `ℙ(V)` with its `G`-action, in `Scheme`. -/
@[expose] public def projectiveActionOfRep (ρ : Representation k G V) : Action Scheme G where
  V := projectiveSpaceOfModule k V
  ρ :=
    { toFun := projRepHom ρ
      map_one' := projRepHom_one ρ
      map_mul' := projRepHom_mul ρ }

/-- `ℙ(V)` with its `G`-action, as a scheme over `Spec k`.  This is the
coordinate-free replacement for `ambientProjectiveActionOver`. -/
@[expose] public def projectiveActionOverOfRep (ρ : Representation k G V) :
    Action (Over (Spec (.of k))) G := by
  letI : (projectiveActionOfRep ρ).V.Over (Spec (.of k)) := by
    change (projectiveSpaceOfModule k V).Over (Spec (.of k))
    infer_instance
  exact actionOverOfIsOver (projectiveActionOfRep ρ) fun g ↦ by
    change (projRepHom ρ g).IsOver (Spec (.of k))
    exact projMapDual_isOver _ _ _

/-- `ℙ(V) = Proj (Sym (Module.Dual k V))` for a faithful representation `R`,
carrying the `G`-action it inherits by functoriality.  No basis and no system
of homogeneous coordinates enters; compare `ambientProjectiveActionOver`,
which needs both. -/
@[expose] public def projectiveSpaceOfRep (R : FaithfulLinearRep k G V) :
    Action (Over (Spec (.of k))) G :=
  projectiveActionOverOfRep R.ρ

end SchemeGeometry
end V14Formalization


-- ═══ IntrinsicV14Action ═══

noncomputable section
open CategoryTheory
open scoped AlgebraicGeometry HomogeneousIdeal
namespace V14Formalization
namespace IntrinsicV14
open AlgebraicGeometry Module SymmetricAlgebra

/-- A representation sends `g⁻¹` to a left inverse of the image of `g`. -/
public theorem repInvComp {R N H : Type*} [CommSemiring R] [AddCommMonoid N] [Module R N]
    [Group H] (ρ : Representation R H N) (g : H) : ρ g⁻¹ ∘ₗ ρ g = LinearMap.id  := sorry

variable (k U : Type u) [Field k] [AddCommGroup U] [Module k U] [FiniteDimensional k U]
  [Module.Free k U]
variable {M : Type u} [AddCommGroup M] [Module k M] [FiniteDimensional k M]
  (incl : M →ₗ[k] ↥(⋀[k]^2 U))

/-- `α : M →ₗ M` is **covered** when it is the restriction along `incl` of
`⋀²f` for some endomorphism `f` of `U`.  The covering `f` is existentially
quantified because a group acting on `⋀²U` need not act on `U`: for
`PSL₂(F₁₁)` only `SL₂(F₁₁)` acts on `U`, and the two lifts of an element of
`PSL₂` differ by `-1`, which acts trivially on `⋀²U`. -/
@[expose] public def Covers (α : M →ₗ[k] M) : Prop :=
  ∃ f : U →ₗ[k] U, ∀ x, incl (α x) = exteriorPower.map 2 f (incl x)

omit [FiniteDimensional k U] [Module.Free k U] in
/-- The Plücker ideal is stable under every covered endomorphism. -/
public theorem pluckerIdeal_map_le' (α : M →ₗ[k] M) (hcov : Covers k U incl α) :
    (pluckerIdeal k U incl).map
        (SymmetricAlgebra.gradedMap (α.dualMap)).toGradedRingHom ≤ pluckerIdeal k U incl  := sorry

/-- The endomorphism of the homogeneous coordinate ring of `V₁₄` induced by an
endomorphism `α` of `M` covered by an endomorphism `f` of `U`.  It is
`Sym (αᵀ)` descended to the quotient by the Plücker ideal, which is legitimate
because `pluckerIdeal_map_le` says the ideal is stable. -/
@[expose] public def quotMap (α : M →ₗ[k] M) (hcov : Covers k U incl α) :
    coordinateRing k U incl →+*ᵍ coordinateRing k U incl :=
  GradedQuotient.mapQuot (pluckerIdeal k U incl) (pluckerIdeal k U incl)
    (SymmetricAlgebra.gradedMap α.dualMap).toGradedRingHom
    (pluckerIdeal_map_le' k U incl α hcov)

omit [FiniteDimensional k U] [Module.Free k U] in
/-- `Proj.map`'s side condition for `quotMap`, inherited from the same
statement for `Sym (αᵀ)` upstairs. -/
public theorem irrelevant_le_quotMap (α β : M →ₗ[k] M) (hcov : Covers k U incl α)
    (hinv : β ∘ₗ α = LinearMap.id) :
    (coordinateRing k U incl)₊ ≤
      ((coordinateRing k U incl)₊).map (quotMap k U incl α hcov)  := sorry

/-- The endomorphism of `V₁₄` induced by an automorphism `α` of `M` covered by
an endomorphism `f` of `U`, presented by `α` together with a left inverse. -/
@[expose] public def schemeMap (α β : M →ₗ[k] M) (hcov : Covers k U incl α)
    (hinv : β ∘ₗ α = LinearMap.id) :
    scheme k U incl ⟶ scheme k U incl :=
  Proj.map (quotMap k U incl α hcov) (irrelevant_le_quotMap k U incl α β hcov hinv)

/-- The structure morphism `V₁₄ ⟶ Spec k`, built exactly as for `Proj` of a
polynomial ring. -/
@[expose] public def toSpec : scheme k U incl ⟶ Spec (.of k) :=
  Proj.toSpecZero (coordinateRing k U incl) ≫
    Spec.map (CommRingCat.ofHom (algebraMap k (coordinateRing k U incl 0)))

public instance canonicallyOver :
    (scheme k U incl).CanonicallyOver (Spec (.of k)) where
  hom := toSpec k U incl

@[expose] public instance schemeMap_isOver (α β : M →ₗ[k] M) (hcov : Covers k U incl α)
    (hinv : β ∘ₗ α = LinearMap.id) :
    (schemeMap k U incl α β hcov hinv).IsOver (Spec (.of k))  := sorry

variable {G : Type u} [Group G]

/-- The automorphism of `V₁₄` attached to a group element. -/
@[expose] public def repHom (ρ : Representation k G M)
    (hcov : ∀ g : G, Covers k U incl (ρ g)) (g : G) :
    scheme k U incl ⟶ scheme k U incl :=
  schemeMap k U incl (ρ g) (ρ g⁻¹) (hcov g) (repInvComp ρ g)

omit [FiniteDimensional k U] [Module.Free k U] in
@[simp] public theorem repHom_one (ρ : Representation k G M)
    (hcov : ∀ g : G, Covers k U incl (ρ g)) :
    repHom k U incl ρ hcov (1 : G) = 𝟙 _  := sorry

omit [FiniteDimensional k U] [Module.Free k U] in
public theorem repHom_mul (ρ : Representation k G M)
    (hcov : ∀ g : G, Covers k U incl (ρ g)) (a b : G) :
    repHom k U incl ρ hcov (a * b)
      = repHom k U incl ρ hcov b ≫ repHom k U incl ρ hcov a  := sorry

/-- **`V₁₄` with its `G`-action**, in `Scheme`. -/
@[expose] public def action (ρ : Representation k G M)
    (hcov : ∀ g : G, Covers k U incl (ρ g)) :
    Action Scheme.{u} G where
  V := scheme k U incl
  ρ :=
    { toFun := repHom k U incl ρ hcov
      map_one' := repHom_one k U incl ρ hcov
      map_mul' := repHom_mul k U incl ρ hcov }

/-- **`V₁₄` with its `G`-action, as a scheme over `Spec k`.**  This is the
coordinate-free replacement for `V14SchemeModel.actionOver`. -/
@[expose] public def actionOver (ρ : Representation k G M)
    (hcov : ∀ g : G, Covers k U incl (ρ g)) :
    Action (Over (Spec (.of k))) G := by
  letI : (action k U incl ρ hcov).V.Over (Spec (.of k)) := by
    change (scheme k U incl).Over (Spec (.of k))
    infer_instance
  exact SchemeGeometry.actionOverOfIsOver (action k U incl ρ hcov) fun g ↦ by
    change (repHom k U incl ρ hcov g).IsOver (Spec (.of k))
    exact schemeMap_isOver _ _ _ _ _ _ _

end IntrinsicV14
end V14Formalization


-- ═══ ProjectiveSpaceIntrinsicIrreducible ═══

noncomputable section
open CategoryTheory
open scoped AlgebraicGeometry HomogeneousIdeal
namespace V14Formalization
namespace SchemeGeometry
open AlgebraicGeometry Module SymmetricAlgebra
variable {k : Type u} [Field k] {G : Type u} [Group G]
  {V : Type u} [AddCommGroup V] [Module k V] {d : ℕ}

@[expose] public instance projectiveSpaceOfRep_irreducibleSpace
    [FiniteDimensional k V] [Nontrivial V] (R : FaithfulLinearRep k G V) :
    IrreducibleSpace (projectiveSpaceOfRep R).V.left  := sorry

end SchemeGeometry
end V14Formalization


-- ═══ CentralizerD12 ═══

open scoped MatrixGroups
open Matrix Matrix.SpecialLinearGroup
noncomputable section
namespace V14Formalization
namespace CentralizerN

@[expose] public instance fact_prime_eleven' : Fact (Nat.Prime 11)  := sorry

public abbrev F := ZMod 11

public abbrev PSL2F11 := PSL(2, F)

@[expose] public def Circle1 := { p : F × F // p.1 ^ 2 + p.2 ^ 2 = 1 }

@[expose] public instance : Fintype Circle1 :=
  Fintype.subtype ((Finset.univ : Finset (F × F)).filter fun p => p.1 ^ 2 + p.2 ^ 2 = 1)
    (by intro; simp)

@[expose] public instance : Fintype PSL2F11 := QuotientGroup.fintype _

end CentralizerN
end V14Formalization


-- ═══ GeometricV14Carrier ═══

open scoped LinearAlgebra.Projectivization MatrixGroups
open Matrix Matrix.SpecialLinearGroup exteriorPower Module Polynomial IntermediateField
open LinearMap (IsProj)
open AdjoinRoot
open BigOperators Set
noncomputable section
namespace V14Formalization
namespace GeometricV14Carrier
open GeometricFanoCarrier

public abbrev k := GeometricFanoCarrier.k

public abbrev PSL2F11 := GeometricFanoCarrier.PSL2F11

public abbrev U := GeometricFanoCarrier.U

public abbrev Lambda2U := GeometricFanoCarrier.Lambda2U

@[expose] public def ambientAct (g : PSL2F11) : Lambda2U →ₗ[k] Lambda2U := pslLambda2Hom g

open ExteriorAlgebra
open ExteriorAlgebra

/-- Character values of the irreducible `10'` of `PSL₂(𝔽₁₁)`, determined by element order.
    Table: `1A↦10, 2A↦2, 3A↦1, 5A/5B↦0, 6A↦-1, 11A/11B↦-1`. -/
@[expose] public noncomputable def chi10' (g : PSL2F11) : k :=
  let n := orderOf g
  if n = 1 then 10
  else if n = 2 then 2
  else if n = 3 then 1
  else if n = 5 then 0
  else if n = 6 then -1
  else if n = 11 then -1
  else 0

/-- Isotypic projector onto the 10′ summand `M ⊂ Λ²U`.
    `π = (10/|G|) ∑_g χ₁₀'(g) · ambientAct g`, with `|G| = 660`. -/
@[expose] public noncomputable def projectorM : Module.End k Lambda2U :=
  (10 * (660 : k)⁻¹) •
    ∑ g : PSL2F11, chi10' g • (ambientAct g : Module.End k Lambda2U)

/-- The writeup ambient summand `M = 10'`. -/
@[expose] public noncomputable def Msub : Submodule k Lambda2U :=
  LinearMap.range projectorM

open ExteriorAlgebra
open ConjAct ConjClasses
end GeometricV14Carrier
end V14Formalization


-- ═══ IntrinsicV14Headline ═══

noncomputable section
open CategoryTheory
open scoped AlgebraicGeometry
namespace V14Formalization
namespace IntrinsicHeadline
open AlgebraicGeometry Module GeometricV14Carrier

/-- The inclusion of the `10′` summand `M ⊆ ⋀²U`. -/
@[expose] public def inclM : ↥Msub →ₗ[k] Lambda2U := Msub.subtype

public theorem ambientAct_mem (g : PSL2F11) {v : Lambda2U} (hv : v ∈ Msub) :
    ambientAct g v ∈ Msub  := sorry

/-- The `PSL(2,11)`-representation on the `10′` summand. -/
@[expose] public def repM : Representation k PSL2F11 ↥Msub where
  toFun g := LinearMap.restrict (ambientAct g) fun v hv => ambientAct_mem g hv
  map_one' := sorry
  map_mul' := sorry

/-- Every element of `PSL(2,11)` acts on `M` through the exterior square of an
endomorphism of `U`: lift it to `SL(2,11)`, where the Weil representation
lives. -/
public theorem coversM (g : PSL2F11) : IntrinsicV14.Covers k U inclM (repM g)  := sorry

/-- **The intrinsic `V₁₄` of the Weil representation, with its
`PSL(2,11)`-action, over `Spec k`.**  `Proj (Sym (M*) ⧸ I)` with `I` generated
by the `⋀⁴`-components of `ω ↦ ω ∧ ω`; no basis and no Plücker coordinate
enters its definition. -/
@[expose] public def intrinsicV14 : Action (Over (Spec (.of k))) PSL2F11 :=
  IntrinsicV14.actionOver k U inclM repM coversM

/-- **There is no `PSL(2,11)`-equivariant rational map from `ℙ(V)` to the
intrinsic `V₁₄`.**

`V` is any faithful linear representation, `ℙ(V) = Proj (Sym (V*))` carries its
action by functoriality, and the target is `Proj (Sym (M*) ⧸ I)` for the
Plücker ideal `I` of the wedge pairing on the `10′` summand `M ⊆ ⋀²U`.  Nothing
in the statement mentions a basis, a matrix, or a coordinate. -/
public theorem noEquivariantRationalMap_intrinsicV14
    {V : Type} [AddCommGroup V] [Module k V] [FiniteDimensional k V] [Nontrivial V]
    (R : FaithfulLinearRep k PSL2F11 V) :
    ¬ SchemeGeometry.HasEquivariantRationalMap (SchemeGeometry.projectiveSpaceOfRep R) intrinsicV14  := sorry

end IntrinsicHeadline
end V14Formalization
