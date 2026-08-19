module

public import Mathlib

/-! # Trusted base

Target: `V14Formalization.SchemeGeometry.noEquivariantRationalMap_ambientFree_of_target`

Boundary: V14Formalization, BConicBundleMultisections

47 declarations from 11 modules, inlined in dependency order with every proof replaced by `sorry`. Imports above are outside the boundary and are trusted as given.
-/

universe u v w

-- ═══ ProjectiveSpace ═══

@[expose] public section
open CategoryTheory Limits
open scoped AlgebraicGeometry
namespace BConicBundleMultisections
noncomputable section
open AlgebraicGeometry
attribute [local instance] MvPolynomial.gradedAlgebra

/-- Scheme-level projective `n`-space over a commutative ring `R`. -/
abbrev ProjectiveSpace (n : ℕ) (R : Type u) [CommRing R] : Scheme.{u} :=
  Proj (MvPolynomial.homogeneousSubmodule (Fin (n + 1)) R)

namespace ProjectiveSpace

/-- The structure morphism from projective `n`-space over `R` to `Spec R`. -/
def toSpec (n : ℕ) (R : Type u) [CommRing R] : ProjectiveSpace n R ⟶ Spec (.of R) :=
  Proj.toSpecZero (MvPolynomial.homogeneousSubmodule (Fin (n + 1)) R) ≫
    Spec.map (CommRingCat.ofHom
      (algebraMap R (MvPolynomial.homogeneousSubmodule (Fin (n + 1)) R 0)))

end ProjectiveSpace

/-- The scheme `ℙᵐ_R ×_{Spec R} ℙⁿ_R`. -/
abbrev BiprojectiveSpace (m n : ℕ) (R : Type u) [CommRing R] : Scheme.{u} :=
  pullback (ProjectiveSpace.toSpec m R) (ProjectiveSpace.toSpec n R)

namespace BiprojectiveSpace

/-- The first projection from `ℙᵐ_R ×_{Spec R} ℙⁿ_R`. -/
abbrev fst (m n : ℕ) (R : Type u) [CommRing R] :
    BiprojectiveSpace m n R ⟶ ProjectiveSpace m R :=
  pullback.fst (ProjectiveSpace.toSpec m R) (ProjectiveSpace.toSpec n R)

/-- The structure morphism from `ℙᵐ_R ×_{Spec R} ℙⁿ_R` to `Spec R`. -/
def toSpec (m n : ℕ) (R : Type u) [CommRing R] :
    BiprojectiveSpace m n R ⟶ Spec (.of R) :=
  fst m n R ≫ ProjectiveSpace.toSpec m R

instance (m n : ℕ) (R : Type u) [CommRing R] :
    (BiprojectiveSpace m n R).CanonicallyOver (Spec (.of R)) where
  hom := toSpec m n R

end BiprojectiveSpace
end
end BConicBundleMultisections


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


-- ═══ SchemeFixedLocus ═══

noncomputable section
open CategoryTheory CategoryTheory.Limits
open scoped AlgebraicGeometry
namespace V14Formalization
namespace SchemeGeometry
open AlgebraicGeometry
variable {S : Scheme.{u}} {G : Type v} [Group G]

/-- The scheme-theoretic fixed locus of `g`, formed in schemes over `S`. -/
public abbrev FixedBy (X : Action (Over S) G) (g : G) : Over S :=
  equalizer (𝟙 X.V) (X.ρ g)

/-- The canonical inclusion of the fixed locus into the original scheme. -/
public abbrev fixedByι (X : Action (Over S) G) (g : G) : FixedBy X g ⟶ X.V :=
  equalizer.ι (𝟙 X.V) (X.ρ g)

@[reassoc]
public theorem fixedByι_comp_action (X : Action (Over S) G) (g : G) :
    fixedByι X g ≫ X.ρ g = fixedByι X g  := sorry

/-- A map whose image is fixed by `g` factors through the fixed subscheme. -/
@[expose] public noncomputable def fixedByLift {Z : Over S} (X : Action (Over S) G) (g : G)
    (p : Z ⟶ X.V) (hp : p ≫ X.ρ g = p) : Z ⟶ FixedBy X g :=
  equalizer.lift p (by simpa only [Category.comp_id] using hp.symm)

/-- An element centralizing `sigma` restricts to an automorphism of the
scheme-theoretic `sigma`-fixed locus. -/
@[expose] public noncomputable def fixedByCentralizerHom (X : Action (Over S) G) (sigma : G)
    (n : Subgroup.centralizer ({sigma} : Set G)) :
    FixedBy X sigma ⟶ FixedBy X sigma :=
  fixedByLift X sigma (fixedByι X sigma ≫ X.ρ n.1) (by
    have hn : n.1 * sigma = sigma * n.1 :=
      (Subgroup.mem_centralizer_iff.mp n.2 sigma (by simp)).symm
    have hsigma_n := X.ρ.map_mul sigma n.1
    change X.ρ (sigma * n.1) = X.ρ n.1 ≫ X.ρ sigma at hsigma_n
    have hn_sigma := X.ρ.map_mul n.1 sigma
    change X.ρ (n.1 * sigma) = X.ρ sigma ≫ X.ρ n.1 at hn_sigma
    calc
      (fixedByι X sigma ≫ X.ρ n.1) ≫ X.ρ sigma =
          fixedByι X sigma ≫ (X.ρ n.1 ≫ X.ρ sigma) := Category.assoc _ _ _
      _ = fixedByι X sigma ≫ X.ρ (sigma * n.1) := by rw [hsigma_n]
      _ = fixedByι X sigma ≫ X.ρ (n.1 * sigma) := by rw [hn]
      _ = fixedByι X sigma ≫ (X.ρ sigma ≫ X.ρ n.1) := by rw [hn_sigma]
      _ = (fixedByι X sigma ≫ X.ρ sigma) ≫ X.ρ n.1 :=
        (Category.assoc _ _ _).symm
      _ = fixedByι X sigma ≫ X.ρ n.1 := by rw [fixedByι_comp_action])

@[simp]
public theorem fixedByCentralizerHom_one (X : Action (Over S) G) (sigma : G) :
    fixedByCentralizerHom X sigma 1 = 𝟙 _  := sorry

public theorem fixedByCentralizerHom_mul (X : Action (Over S) G) (sigma : G)
    (n m : Subgroup.centralizer ({sigma} : Set G)) :
    fixedByCentralizerHom X sigma (n * m) =
      fixedByCentralizerHom X sigma m ≫ fixedByCentralizerHom X sigma n  := sorry

/-- The centralizer of `sigma` acts canonically on the scheme-theoretic
`sigma`-fixed locus. -/
@[expose] public noncomputable def fixedByCentralizerAction (X : Action (Over S) G) (sigma : G) :
    Action (Over S) (Subgroup.centralizer ({sigma} : Set G)) where
  V := FixedBy X sigma
  ρ :=
    { toFun := fixedByCentralizerHom X sigma
      map_one' := fixedByCentralizerHom_one X sigma
      map_mul' := fixedByCentralizerHom_mul X sigma }

end SchemeGeometry
end V14Formalization


-- ═══ Definitions ═══

noncomputable section
open scoped LinearAlgebra.Projectivization MatrixGroups
namespace V14Formalization

@[expose] public def IsInvolution {G : Type u} [Monoid G] (σ : G) : Prop :=
  σ ^ 2 = 1 ∧ σ ≠ 1

@[expose] public def IsCenterless (G : Type u) [Group G] : Prop :=
  Subgroup.center G = ⊥

public structure FaithfulLinearRep (k : Type u) [Field k] (G : Type u) [Monoid G]
    (V : Type u) [AddCommGroup V] [Module k V] where
  ρ : Representation k G V
  finiteDimensional : FiniteDimensional k V
  faithful : Function.Injective ρ

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

/-- The coordinate-free ambient projective space of a faithful representation,
with its action.  Compare `ambientProjectiveActionOver`, which needs a basis. -/
@[expose] public def ambientFree (R : FaithfulLinearRep k G V) :
    Action (Over (Spec (.of k))) G :=
  projectiveActionOverOfRep R.ρ

end SchemeGeometry
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

@[expose] public instance ambientFree_irreducibleSpace
    [FiniteDimensional k V] [Nontrivial V] (R : FaithfulLinearRep k G V) :
    IrreducibleSpace (ambientFree R).V.left  := sorry

end SchemeGeometry
end V14Formalization


-- ═══ SchemeRationalConstancy ═══

noncomputable section
open CategoryTheory
open scoped AlgebraicGeometry
namespace V14Formalization
namespace SchemeGeometry
open AlgebraicGeometry
variable {S : Scheme.{u}} {N : Type u} [Group N]
variable {k : Type u} [Field k]

/-- A rational map between schemes over the base is induced by a base-field
point of the target.  The definition is deliberately independent of any
group actions carried by the two schemes. -/
@[expose] public def RationalMapIsConstantOver
    {E Z : Over (Spec (.of k))}
    (q : Scheme.RationalMap E.left Z.left) : Prop :=
  ∃ y : Spec (.of k) ⟶ Z.left,
    q = (E.hom ≫ y).toRationalMap

variable {E Z : Over (Spec (.of k))}
  [IsIntegral E.left]
variable {E Z : Action (Over (Spec (.of k))) N}
  [IsIntegral E.V.left]
end SchemeGeometry
end V14Formalization


-- ═══ AbstractTargetHeadline ═══

noncomputable section
open CategoryTheory
open scoped AlgebraicGeometry
namespace V14Formalization.SchemeGeometry
open AlgebraicGeometry BConicBundleMultisections Module
variable (F : Type u) [Field F] {G : Type u} [Group G]

/-- **Hypothesis (a) for a target.**  Every rational map over `Spec F` from a
biprojective space to the scheme-theoretic `σ`-fixed locus of `Y` is constant.

Geometrically: the positive-dimensional part of `Y^σ` contains no rational
curve, so the exceptional divisor of the blow-up along `ℙ(V₊)` cannot map to it
non-constantly.  The biprojective space is the exceptional divisor of that
blow-up, in the chart the normal valuation uses; `p` and `q` are the projective
dimensions of the two `σ`-eigenspaces, which are not known in advance, hence
the quantifier over both. -/
@[expose] public def TargetHypothesisA
    (Y : Action (Over (Spec (.of F))) G) (σ : G) : Prop :=
  ∀ (p q : ℕ) (z : Scheme.RationalMap (BiprojectiveSpace p q F)
      (fixedByCentralizerAction Y σ).V.left),
    z.IsOver (Spec (.of F)) →
      RationalMapIsConstantOver
        (E := Over.mk (BiprojectiveSpace.toSpec p q F))
        (Z := (fixedByCentralizerAction Y σ).V) z

/-- **Hypothesis (b) for a target.**  `Y^σ` has no `F`-section fixed by the
whole centralizer `N = C_G(σ)`; that is, `Y^N(F) = ∅`.

Sections rather than arbitrary morphisms `Spec F ⟶ Y^σ` suffice, because the
constant value produced by hypothesis (a) is automatically a section of the
structure morphism (`noEquivariantRationalMap_of_constant_section`). -/
@[expose] public def TargetHypothesisB
    (Y : Action (Over (Spec (.of F))) G) (σ : G) : Prop :=
  ¬ ∃ y : Spec (.of F) ⟶ (fixedByCentralizerAction Y σ).V.left,
      y ≫ (fixedByCentralizerAction Y σ).V.hom = 𝟙 _ ∧
        ∀ n : Subgroup.centralizer ({σ} : Set G),
          y ≫ ((fixedByCentralizerAction Y σ).ρ n).left = y

/-- **The centralizer obstruction against an abstract target, coordinate-free.**

There is no `G`-equivariant rational map from `ℙ(V) = Proj (Sym (V*))`, the
projectivization of a faithful `F`-linear representation of a centerless group
`G`, to any proper `G`-scheme `Y` over `Spec F` whose `σ`-fixed locus satisfies
hypotheses (a) and (b) for some involution `σ`.

No basis of `V` and no system of homogeneous coordinates appears: the
`σ`-eigenspace decomposition is chosen inside the proof.

`noEquivariantRationalMap_ambientFree` is this theorem at `F = ℚ(ζ₁₁)`,
`G = PSL(2,11)`, `σ` the distinguished involution and `Y` the coordinate V14;
see `V14TargetInterface`. -/
public theorem noEquivariantRationalMap_ambientFree_of_target
    [CharZero F]
    (Y : Action (Over (Spec (.of F))) G) [IsProper Y.V.hom]
    (σ : G) (hσ : IsInvolution σ) (hG : IsCenterless G)
    (ha : TargetHypothesisA F Y σ) (hb : TargetHypothesisB F Y σ)
    {V : Type u} [AddCommGroup V] [Module F V]
    [FiniteDimensional F V] [Nontrivial V]
    (R : FaithfulLinearRep F G V) :
    ¬ HasEquivariantRationalMap (ambientFree R) Y  := sorry

end V14Formalization.SchemeGeometry
