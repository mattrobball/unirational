/-
Copyright (c) 2026 V14Formalization contributors.
Released under Apache 2.0 license.

# Zero-axiom vocabulary for Theorem 3.1
-/
module

public import V14Formalization.Basic
public import Mathlib.LinearAlgebra.Center
public import Mathlib.LinearAlgebra.FreeModule.Basic
public import Mathlib.LinearAlgebra.Dimension.Finrank
public import Mathlib.LinearAlgebra.Dimension.Finite

noncomputable section

open scoped LinearAlgebra.Projectivization MatrixGroups

namespace V14Formalization

universe u

/-! ## Group primitives -/

@[expose] public def IsInvolution {G : Type u} [Monoid G] (σ : G) : Prop :=
  σ ^ 2 = 1 ∧ σ ≠ 1

@[expose] public def centralizer {G : Type u} [Group G] (σ : G) : Subgroup G :=
  Subgroup.centralizer ({σ} : Set G)

public lemma mem_centralizer_iff {G : Type u} [Group G] {σ g : G} :
    g ∈ centralizer σ ↔ Commute g σ := by
  simp only [centralizer, Subgroup.mem_centralizer_iff, Set.mem_singleton_iff]
  constructor
  · intro h; exact (h σ rfl).symm
  · intro h x hx; rw [hx]; exact h.symm

@[expose] public def IsCenterless (G : Type u) [Group G] : Prop :=
  Subgroup.center G = ⊥

public lemma mem_center_iff {G : Type u} [Group G] {z : G} :
    z ∈ Subgroup.center G ↔ ∀ g : G, g * z = z * g :=
  Subgroup.mem_center_iff

/-! ## Faithful linear representations -/

public structure FaithfulLinearRep (k : Type u) [Field k] (G : Type u) [Monoid G]
    (V : Type u) [AddCommGroup V] [Module k V] where
  ρ : Representation k G V
  finiteDimensional : FiniteDimensional k V
  faithful : Function.Injective ρ

namespace FaithfulLinearRep

variable {k : Type u} [Field k] {G : Type u} [Group G]
  {V : Type u} [AddCommGroup V] [Module k V]

@[expose] public def act (R : FaithfulLinearRep k G V) (g : G) : V →ₗ[k] V := R.ρ g

@[simp] public lemma act_one (R : FaithfulLinearRep k G V) :
    R.act (1 : G) = LinearMap.id := map_one R.ρ

public lemma act_mul (R : FaithfulLinearRep k G V) (g h : G) :
    R.act (g * h) = R.act g ∘ₗ R.act h := map_mul R.ρ g h

public lemma act_inv (R : FaithfulLinearRep k G V) (g : G) (v : V) :
    R.act g (R.act g⁻¹ v) = v := by
  have h := congr_arg (fun L : V →ₗ[k] V => L v) (R.act_mul g g⁻¹)
  rw [mul_inv_cancel, act_one, LinearMap.id_coe, id_eq] at h
  exact h.symm

lemma act_inv' (R : FaithfulLinearRep k G V) (g : G) (v : V) :
    R.act g⁻¹ (R.act g v) = v := by
  have h := congr_arg (fun L : V →ₗ[k] V => L v) (R.act_mul g⁻¹ g)
  rw [inv_mul_cancel, act_one, LinearMap.id_coe, id_eq] at h
  exact h.symm

public lemma act_injective (R : FaithfulLinearRep k G V) (g : G) :
    Function.Injective (R.act g) := by
  intro v w hvw
  calc v = R.act g⁻¹ (R.act g v) := (R.act_inv' g v).symm
    _ = R.act g⁻¹ (R.act g w) := by rw [hvw]
    _ = w := R.act_inv' g w

@[expose] public def DegeneratesToPlusMinusId (R : FaithfulLinearRep k G V) (σ : G) : Prop :=
  R.act σ = LinearMap.id ∨ R.act σ = -LinearMap.id

@[expose] public def plusEigenspace (R : FaithfulLinearRep k G V) (σ : G) : Submodule k V :=
  Module.End.eigenspace (R.act σ) (1 : k)

@[expose] public def minusEigenspace (R : FaithfulLinearRep k G V) (σ : G) : Submodule k V :=
  Module.End.eigenspace (R.act σ) (-1 : k)

lemma act_sq_of_involution (R : FaithfulLinearRep k G V) {σ : G}
    (hσ : IsInvolution σ) : R.act σ ∘ₗ R.act σ = LinearMap.id := by
  have h : σ * σ = (1 : G) := by simpa [pow_two] using hσ.1
  rw [← act_mul, h, act_one]

public lemma mem_plusEigenspace_iff (R : FaithfulLinearRep k G V) (σ : G) {v : V} :
    v ∈ R.plusEigenspace σ ↔ R.act σ v = v := by
  simp [plusEigenspace, Module.End.mem_eigenspace_iff, one_smul]

public lemma mem_minusEigenspace_iff (R : FaithfulLinearRep k G V) (σ : G) {v : V} :
    v ∈ R.minusEigenspace σ ↔ R.act σ v = -v := by
  simp [minusEigenspace, Module.End.mem_eigenspace_iff]

/-- The centralizer of `σ` preserves its `+1` eigenspace in every honest
linear representation. -/
public theorem plusEigenspace_centralizer_stable
    (R : FaithfulLinearRep k G V) (σ : G)
    (n : centralizer σ) {v : V}
    (hv : v ∈ R.plusEigenspace σ) :
    R.act (n : G) v ∈ R.plusEigenspace σ := by
  rw [R.mem_plusEigenspace_iff] at hv ⊢
  have hc : (n : G) * σ = σ * (n : G) :=
    mem_centralizer_iff.mp n.property
  calc
    R.act σ (R.act (n : G) v) = R.act (σ * (n : G)) v := by
      rw [R.act_mul]
      rfl
    _ = R.act ((n : G) * σ) v := by rw [hc]
    _ = R.act (n : G) (R.act σ v) := by
      rw [R.act_mul]
      rfl
    _ = R.act (n : G) v := by rw [hv]

/-- The centralizer of `σ` preserves its `-1` eigenspace in every honest
linear representation. -/
public theorem minusEigenspace_centralizer_stable
    (R : FaithfulLinearRep k G V) (σ : G)
    (n : centralizer σ) {v : V}
    (hv : v ∈ R.minusEigenspace σ) :
    R.act (n : G) v ∈ R.minusEigenspace σ := by
  rw [R.mem_minusEigenspace_iff] at hv ⊢
  have hc : (n : G) * σ = σ * (n : G) :=
    mem_centralizer_iff.mp n.property
  calc
    R.act σ (R.act (n : G) v) = R.act (σ * (n : G)) v := by
      rw [R.act_mul]
      rfl
    _ = R.act ((n : G) * σ) v := by rw [hc]
    _ = R.act (n : G) (R.act σ v) := by
      rw [R.act_mul]
      rfl
    _ = -R.act (n : G) v := by rw [hv, map_neg]

public lemma act_act (R : FaithfulLinearRep k G V) {σ : G} (hσ : IsInvolution σ) (v : V) :
    R.act σ (R.act σ v) = v := by
  simpa [LinearMap.comp_apply] using
    congr_arg (fun L : V →ₗ[k] V => L v) (R.act_sq_of_involution hσ)

/-- In characteristic zero, an involution splits every honest linear
representation as its `+1` and `-1` eigenspaces. -/
public theorem isCompl_plus_minus (R : FaithfulLinearRep k G V) {σ : G}
    [CharZero k] (hσ : IsInvolution σ) :
    IsCompl (R.plusEigenspace σ) (R.minusEigenspace σ) := by
  apply IsCompl.of_eq
  · apply le_antisymm
    · intro v hv
      have hvp : v ∈ R.plusEigenspace σ := hv.1
      have hvm : v ∈ R.minusEigenspace σ := hv.2
      rw [R.mem_plusEigenspace_iff] at hvp
      rw [R.mem_minusEigenspace_iff] at hvm
      have hneg : v = -v := hvp.symm.trans hvm
      have hadd : v + v = 0 := by
        calc
          v + v = -v + v := congrArg (fun z => z + v) hneg
          _ = 0 := neg_add_cancel v
      have hsmul : (2 : k) • v = 0 := by simpa [two_smul k v] using hadd
      have h2 : (2 : k) ≠ 0 := by norm_num
      have hv0 : v = 0 := (smul_eq_zero.mp hsmul).resolve_left h2
      simpa [Submodule.mem_bot] using hv0
    · exact bot_le
  · apply top_unique
    intro v _
    have h2 : (2 : k) ≠ 0 := by norm_num
    let vp : V := (2 : k)⁻¹ • (v + R.act σ v)
    let vm : V := (2 : k)⁻¹ • (v - R.act σ v)
    have hvp : vp ∈ R.plusEigenspace σ := by
      rw [R.mem_plusEigenspace_iff]
      dsimp [vp]
      rw [map_smul, map_add, R.act_act hσ]
      congr 1
      abel
    have hvm : vm ∈ R.minusEigenspace σ := by
      rw [R.mem_minusEigenspace_iff]
      dsimp [vm]
      rw [map_smul, map_sub, R.act_act hσ]
      module
    have hvsum : vp + vm = v := by
      dsimp [vp, vm]
      rw [← smul_add]
      calc
        (2 : k)⁻¹ • ((v + R.act σ v) + (v - R.act σ v)) =
            (2 : k)⁻¹ • ((2 : k) • v) := by congr 1; module
        _ = v := by rw [smul_smul, inv_mul_cancel₀ h2, one_smul]
    rw [← hvsum]
    exact (R.plusEigenspace σ ⊔ R.minusEigenspace σ).add_mem
      ((le_sup_left : R.plusEigenspace σ ≤
        R.plusEigenspace σ ⊔ R.minusEigenspace σ) hvp)
      ((le_sup_right : R.minusEigenspace σ ≤
        R.plusEigenspace σ ⊔ R.minusEigenspace σ) hvm)

/-- If V₊ = ⊥ then ρ(σ) = −id. -/
theorem act_eq_neg_id_of_plus_bot (R : FaithfulLinearRep k G V) {σ : G}
    [CharZero k] (hσ : IsInvolution σ) (hbot : R.plusEigenspace σ = ⊥) :
    R.act σ = -LinearMap.id := by
  ext v
  -- v = v₊ + v₋ with v₊ = (v+σv)/2 ∈ V₊ = 0, so σv = -v
  have h2 : (2 : k) ≠ 0 := by norm_num
  let vpos : V := (2 : k)⁻¹ • (v + R.act σ v)
  have hvpos : vpos ∈ R.plusEigenspace σ := by
    rw [mem_plusEigenspace_iff]
    dsimp [vpos]
    calc R.act σ ((2 : k)⁻¹ • (v + R.act σ v))
        = (2 : k)⁻¹ • (R.act σ v + R.act σ (R.act σ v)) := by rw [map_smul, map_add]
      _ = (2 : k)⁻¹ • (R.act σ v + v) := by rw [R.act_act hσ]
      _ = (2 : k)⁻¹ • (v + R.act σ v) := by abel
  have hvpos0 : vpos = 0 := by
    rw [hbot, Submodule.mem_bot] at hvpos; exact hvpos
  have : v + R.act σ v = 0 := by
    have h := congr_arg (fun z => (2 : k) • z) hvpos0
    dsimp [vpos] at h
    rw [smul_smul, mul_inv_cancel₀ h2, one_smul, smul_zero] at h
    exact h
  have : R.act σ v = -v := eq_neg_of_add_eq_zero_right this
  simpa [LinearMap.neg_apply, LinearMap.id_apply] using this

/-- If `V₋ = ⊥` then `ρ(σ) = id`. -/
theorem act_eq_id_of_minus_bot (R : FaithfulLinearRep k G V) {σ : G}
    [CharZero k] (hσ : IsInvolution σ) (hbot : R.minusEigenspace σ = ⊥) :
    R.act σ = LinearMap.id := by
  ext v
  have h2 : (2 : k) ≠ 0 := by norm_num
  let vneg : V := (2 : k)⁻¹ • (v - R.act σ v)
  have hvneg : vneg ∈ R.minusEigenspace σ := by
    rw [mem_minusEigenspace_iff]
    dsimp [vneg]
    have hee := R.act_act hσ v
    calc R.act σ ((2 : k)⁻¹ • (v - R.act σ v))
        = (2 : k)⁻¹ • (R.act σ v - R.act σ (R.act σ v)) := by rw [map_smul, map_sub]
      _ = (2 : k)⁻¹ • (R.act σ v - v) := by rw [hee]
      _ = (2 : k)⁻¹ • (-(v - R.act σ v)) := by abel
      _ = -((2 : k)⁻¹ • (v - R.act σ v)) := by rw [smul_neg]
  have hvneg0 : vneg = 0 := by
    rw [hbot, Submodule.mem_bot] at hvneg; exact hvneg
  have hsub : v - R.act σ v = 0 := by
    have h := congr_arg (fun z => (2 : k) • z) hvneg0
    dsimp [vneg] at h
    rw [smul_smul, mul_inv_cancel₀ h2, one_smul, smul_zero] at h
    exact h
  have : R.act σ v = v := (eq_of_sub_eq_zero hsub).symm
  simpa [LinearMap.id_apply] using this

public theorem both_eigenspaces_nontrivial (R : FaithfulLinearRep k G V) {σ : G}
    [CharZero k] (hσ : IsInvolution σ) (hnd : ¬ R.DegeneratesToPlusMinusId σ) :
    R.plusEigenspace σ ≠ ⊥ ∧ R.minusEigenspace σ ≠ ⊥ := by
  constructor
  · intro h; exact hnd (Or.inr (R.act_eq_neg_id_of_plus_bot hσ h))
  · intro h; exact hnd (Or.inl (R.act_eq_id_of_minus_bot hσ h))

end FaithfulLinearRep

@[expose] public def NoFaithfulRepDegenerates (k : Type u) [Field k] (G : Type u) [Group G] (σ : G) : Prop :=
  ∀ (V : Type u) [AddCommGroup V] [Module k V] (R : FaithfulLinearRep k G V),
    ¬ R.DegeneratesToPlusMinusId σ

/-! ## Smooth projective G-varieties (linear-algebra point model)

This is the **point-set** model used by the older RCC writeup: an abstract
type of points, a linear-algebra embedding into `ℙ k V`, and a set-theoretic
`G`-action.  It does **not** carry a Mathlib `AlgebraicGeometry.Scheme`
structure.  Morphisms are total functions induced by injective linear maps,
not `Scheme.RationalMap`.

The scheme-theoretic object is `SchemeGeometry.ProjectiveGVariety` in
`ProjectiveGVariety.lean`: a closed subscheme of `Proj` with a `G`-action
over `Spec k`.
-/

public structure SmoothProjectiveGVariety (k : Type u) [Field k] (G : Type u) [Group G] where
  X : Type u
  ambient : Type u
  ambientAdd : AddCommGroup ambient := by infer_instance
  ambientModule : Module k ambient := by infer_instance
  ambientFree : Module.Free k ambient := by infer_instance
  ambientFD : FiniteDimensional k ambient := by infer_instance
  /-- Projective embedding `X ↪ ℙ(ambient)`. -/
  embed : X ↪ ℙ k ambient
  smul : G → X → X
  one_smul' : ∀ x, smul 1 x = x
  mul_smul' : ∀ g h x, smul (g * h) x = smul g (smul h x)
  faithful : ∀ g : G, (∀ x, smul g x = x) → g = 1
  /-- Linear G-action on the ambient module. -/
  ambientAct : G → (ambient →ₗ[k] ambient)
  ambientAct_one : ambientAct 1 = LinearMap.id
  ambientAct_mul : ∀ g h, ambientAct (g * h) = ambientAct g ∘ₗ ambientAct h
  /-- Embedding intertwines the two G-actions. -/
  embed_smul : ∀ (g : G) (x : X),
    embed (smul g x) =
      Projectivization.map (ambientAct g)
        (fun v w h => by
          have := congr_arg (ambientAct g⁻¹) h
          simp only [← LinearMap.comp_apply, ← ambientAct_mul, inv_mul_cancel,
            ambientAct_one, LinearMap.id_apply] at this
          exact this) (embed x)

attribute [instance] SmoothProjectiveGVariety.ambientAdd
attribute [instance] SmoothProjectiveGVariety.ambientModule
attribute [instance] SmoothProjectiveGVariety.ambientFree
attribute [instance] SmoothProjectiveGVariety.ambientFD

namespace SmoothProjectiveGVariety

variable {k : Type u} [Field k] {G : Type u} [Group G]
  (Y : SmoothProjectiveGVariety k G)

@[expose] public instance : SMul G Y.X where smul := Y.smul
@[expose] public instance : MulAction G Y.X where
  one_smul := Y.one_smul'
  mul_smul := Y.mul_smul'

@[expose] public def fixedBy (H : Subgroup G) : Set Y.X :=
  { y | ∀ h : H, (h : G) • y = y }

@[expose] public def fixedByElement (σ : G) : Set Y.X :=
  { y | σ • y = y }

@[simp] public lemma mem_fixedByElement_iff {σ : G} {y : Y.X} :
    y ∈ Y.fixedByElement σ ↔ σ • y = y := Iff.rfl

/-- Legacy Prop: embedding data implies projectively embedded. -/
def IsProjectivelyEmbedded (k : Type u) [Field k] (X : Type u) : Prop :=
  ∃ (V : Type u) (_ : AddCommGroup V) (_ : Module k V)
    (_ : Module.Free k V) (_ : FiniteDimensional k V),
      Nonempty (X ↪ ℙ k V)

theorem projectivelyEmbedded (Y : SmoothProjectiveGVariety k G) :
    IsProjectivelyEmbedded k Y.X :=
  ⟨Y.ambient, Y.ambientAdd, Y.ambientModule, Y.ambientFree, Y.ambientFD, ⟨Y.embed⟩⟩

end SmoothProjectiveGVariety

/-! ## Linear-projective RCC and hypotheses

`IsRCC` means the set is a full linear projective subspace in the ambient
embedding of `Y` (image of `ℙ(W)` under a linear injection into ambient).
This matches writeup rational-chain / rational-curve content for the
centralizer obstruction without set-theoretic collapse on genus-1 loci:
a degree-≥2 curve contains no linear `ℙ¹`.
-/

/-- Linear RCC inside `ℙ(V)`: the full projectivization of a nonzero linear subspace. -/
@[expose] public def IsLinearRCC (k : Type u) [Field k] {V : Type u}
    [AddCommGroup V] [Module k V] (S : Set (ℙ k V)) : Prop :=
  ∃ (W : Submodule k V),
    Module.finrank k W ≥ 1 ∧
    S = { x : ℙ k V | x.submodule ≤ W }

/-- Operational RCC for a subset of a projectively embedded G-variety:
the embedded image is a linear projective subspace of the ambient. -/
@[expose] public def IsRCC (k : Type u) [Field k] {G : Type u} [Group G]
    (Y : SmoothProjectiveGVariety k G) (S : Set Y.X) : Prop :=
  IsLinearRCC k (Y.embed '' S)

/-- **Hypothesis (a)** (linear-projective): every linear-RCC subset of `Y^σ`
is a singleton.  Equivalently, `Y^σ` contains no positive-dimensional linear
subspace of the ambient projective space. -/
@[expose] public def HypothesisA (k : Type u) [Field k] {G : Type u} [Group G]
    (Y : SmoothProjectiveGVariety k G) (σ : G) : Prop :=
  ∀ (S : Set Y.X), S ⊆ Y.fixedByElement σ → IsRCC k Y S → ∃ y : Y.X, S = {y}

/-- **Hypothesis (b)**. -/
@[expose] public def HypothesisB {k : Type u} [Field k] {G : Type u} [Group G]
    (Y : SmoothProjectiveGVariety k G) (N : Subgroup G) : Prop :=
  Y.fixedBy N = ∅

/-! ## Linear-projective G-equivariant morphisms -/

/-- A G-equivariant map induced by a linear map of ambients (writeup: morphism
of projective varieties after resolving the graph). -/
public structure GEquivariantMorphism {k : Type u} [Field k] {G : Type u} [Group G]
    (X Y : SmoothProjectiveGVariety k G) where
  toFun : X.X → Y.X
  equivariant : ∀ (g : G) (x : X.X), toFun (g • x) = g • toFun x
  /-- Linear map of ambients inducing `toFun` on the projective embeddings. -/
  lin : X.ambient →ₗ[k] Y.ambient
  lin_injective : Function.Injective lin
  lin_equivariant : ∀ (g : G),
    lin ∘ₗ X.ambientAct g = Y.ambientAct g ∘ₗ lin
  induces : ∀ (x : X.X),
    Y.embed (toFun x) =
      Projectivization.map lin lin_injective (X.embed x)

@[expose] public def GEquivariantMorphism.imageSet {k : Type u} [Field k] {G : Type u} [Group G]
    {X Y : SmoothProjectiveGVariety k G}
    (f : GEquivariantMorphism X Y) (S : Set X.X) : Set Y.X :=
  f.toFun '' S

@[expose] public def HasGEquivariantRationalMap {k : Type u} [Field k] {G : Type u} [Group G]
    (X Y : SmoothProjectiveGVariety k G) : Prop :=
  Nonempty (GEquivariantMorphism X Y)

@[expose] public def HasDominantGEquivariantRationalMap {k : Type u} [Field k] {G : Type u} [Group G]
    (X Y : SmoothProjectiveGVariety k G) : Prop :=
  ∃ f : GEquivariantMorphism X Y, Function.Surjective f.toFun

theorem dominant_implies_rationalMap {k : Type u} [Field k] {G : Type u} [Group G]
    {X Y : SmoothProjectiveGVariety k G}
    (h : HasDominantGEquivariantRationalMap X Y) : HasGEquivariantRationalMap X Y := by
  obtain ⟨f, _⟩ := h
  exact ⟨f⟩

/-! ## Projectivization of FaithfulLinearRep -/

namespace FaithfulLinearRep

variable {k : Type u} [Field k] {G : Type u} [Group G]
  {V : Type u} [AddCommGroup V] [Module k V]

@[expose] public def projectiveSMul (R : FaithfulLinearRep k G V) (g : G) (x : ℙ k V) : ℙ k V :=
  Projectivization.map (R.act g) (R.act_injective g) x

public lemma projectiveSMul_one (R : FaithfulLinearRep k G V) (x : ℙ k V) :
    R.projectiveSMul 1 x = x := by
  simp only [projectiveSMul, act_one]
  exact congr_fun (Projectivization.map_id (K := k) (V := V)) x

public lemma projectiveSMul_mk (R : FaithfulLinearRep k G V) (g : G) {v : V} (hv : v ≠ 0) :
    R.projectiveSMul g (Projectivization.mk k v hv) =
      Projectivization.mk k (R.act g v)
        (fun h0 => hv ((R.act_injective g) (by simpa using h0))) := by
  simp only [projectiveSMul, Projectivization.map_mk]

public lemma projectiveSMul_mul (R : FaithfulLinearRep k G V) (g h : G) (x : ℙ k V) :
    R.projectiveSMul (g * h) x = R.projectiveSMul g (R.projectiveSMul h x) := by
  classical
  rw [← Projectivization.mk_rep x]
  have hv : x.rep ≠ 0 := Projectivization.rep_nonzero x
  have hne_h : R.act h x.rep ≠ 0 := fun h0 => hv ((R.act_injective h) (by simpa using h0))
  have hne_gh : R.act (g * h) x.rep ≠ 0 :=
    fun h0 => hv ((R.act_injective (g * h)) (by simpa using h0))
  have hgh : R.act (g * h) x.rep = R.act g (R.act h x.rep) := by rw [R.act_mul]; rfl
  calc R.projectiveSMul (g * h) (Projectivization.mk k x.rep hv)
      = Projectivization.mk k (R.act (g * h) x.rep) hne_gh := R.projectiveSMul_mk (g * h) hv
    _ = Projectivization.mk k (R.act g (R.act h x.rep)) (by rw [← hgh]; exact hne_gh) := by
        simp only [hgh]
    _ = R.projectiveSMul g (Projectivization.mk k (R.act h x.rep) hne_h) :=
        (R.projectiveSMul_mk g hne_h).symm
    _ = R.projectiveSMul g (R.projectiveSMul h (Projectivization.mk k x.rep hv)) := by
        rw [R.projectiveSMul_mk h hv]

theorem central_of_act_scalar (R : FaithfulLinearRep k G V) (g : G) (c : k)
    (h : R.act g = c • LinearMap.id) : g ∈ Subgroup.center G := by
  rw [mem_center_iff]
  intro x
  -- need g * x = x * g
  have hgx : R.act (g * x) = R.act (x * g) := by
    calc R.act (g * x) = R.act g ∘ₗ R.act x := R.act_mul g x
      _ = (c • LinearMap.id) ∘ₗ R.act x := by rw [h]
      _ = R.act x ∘ₗ (c • LinearMap.id) := by ext v; simp
      _ = R.act x ∘ₗ R.act g := by rw [h]
      _ = R.act (x * g) := (R.act_mul x g).symm
  -- need x * g = g * x, i.e. ρ(x*g) = ρ(g*x)
  exact R.faithful hgx.symm

/-- Line-preserving ⇒ scalar (Mathlib) + centerless ⇒ g = 1. -/
public theorem projectiveAction_faithful [Module.Free k V] (R : FaithfulLinearRep k G V)
    (hG : IsCenterless G) (g : G)
    (hg : ∀ x : ℙ k V, R.projectiveSMul g x = x) : g = 1 := by
  have hcoll : ∀ v : V, ¬ LinearIndependent k ![v, R.act g v] := by
    intro v
    by_cases hv : v = 0
    · subst hv
      intro h
      exact (h.ne_zero 0) (by simp)
    · have hfix : R.projectiveSMul g (Projectivization.mk k v hv) =
          Projectivization.mk k v hv := hg _
      rw [projectiveSMul_mk, Projectivization.mk_eq_mk_iff] at hfix
      obtain ⟨μ, hμ⟩ := hfix
      have heq : R.act g v = μ • v := by simpa using hμ.symm
      intro h
      have h' : LinearIndependent k ![v, μ • v] := by simpa [heq] using h
      rw [LinearIndependent.pair_iff] at h'
      have hsum : μ • v + (-1 : k) • (μ • v) = 0 := by simp [neg_smul]
      have hμ1 := h' μ (-1) hsum
      exact absurd hμ1.2 (by norm_num : (-1 : k) ≠ 0)
  obtain ⟨μ, hμ⟩ :=
    LinearMap.exists_eq_smul_id_of_forall_notLinearIndependent (R := k) (V := V)
      (f := R.act g) hcoll
  have hact : R.act g = μ • LinearMap.id := by
    rw [hμ]; ext v; simp
  have hcent := central_of_act_scalar R g μ hact
  have : g ∈ (⊥ : Subgroup G) := by rwa [hG] at hcent
  exact Subgroup.mem_bot.mp this

@[expose] public def projectivizationVariety [Module.Free k V] (R : FaithfulLinearRep k G V)
    (hG : IsCenterless G) : SmoothProjectiveGVariety k G where
  X := ℙ k V
  ambient := V
  ambientAdd := inferInstance
  ambientModule := inferInstance
  ambientFree := inferInstance
  ambientFD := R.finiteDimensional
  embed := { toFun := id, inj' := fun _ _ h => h }
  smul := R.projectiveSMul
  one_smul' := R.projectiveSMul_one
  mul_smul' := R.projectiveSMul_mul
  faithful := fun g hg => R.projectiveAction_faithful hG g hg
  ambientAct := R.act
  ambientAct_one := R.act_one
  ambientAct_mul := R.act_mul
  embed_smul := by
    intro g x
    -- embed = id, smul = projectiveSMul
    change R.projectiveSMul g x =
      Projectivization.map (R.act g) _ x
    rfl

/-- Plus stratum = projective points in V₊ (coupled to plusEigenspace). -/
@[expose] public def plusProjectiveStratum (R : FaithfulLinearRep k G V) (σ : G) : Set (ℙ k V) :=
  { x : ℙ k V | x.submodule ≤ R.plusEigenspace σ }

public theorem mem_plusProjectiveStratum_iff (R : FaithfulLinearRep k G V) (σ : G) {x : ℙ k V} :
    x ∈ R.plusProjectiveStratum σ ↔ x.rep ∈ R.plusEigenspace σ := by
  constructor
  · intro hx
    have : x.submodule ≤ R.plusEigenspace σ := hx
    rw [Projectivization.submodule_eq] at this
    exact this (Submodule.mem_span_singleton_self _)
  · intro hrep
    change x.submodule ≤ R.plusEigenspace σ
    rw [Projectivization.submodule_eq]
    exact (Submodule.span_singleton_le_iff_mem _ _).mpr hrep

public theorem plusProjectiveStratum_nonempty (R : FaithfulLinearRep k G V) {σ : G}
    [CharZero k] (hσ : IsInvolution σ) (hnd : ¬ R.DegeneratesToPlusMinusId σ) :
    (R.plusProjectiveStratum σ).Nonempty := by
  obtain ⟨hplus, _⟩ := R.both_eigenspaces_nontrivial hσ hnd
  obtain ⟨v, hv, hvne⟩ := Submodule.exists_mem_ne_zero_of_ne_bot hplus
  refine ⟨Projectivization.mk k v hvne, ?_⟩
  change (Projectivization.mk k v hvne).submodule ≤ R.plusEigenspace σ
  rw [Projectivization.submodule_mk]
  exact (Submodule.span_singleton_le_iff_mem _ _).mpr hv

public theorem plusProjectiveStratum_fixed [Module.Free k V] (R : FaithfulLinearRep k G V)
    (σ : G) (hG : IsCenterless G) :
    R.plusProjectiveStratum σ ⊆ (R.projectivizationVariety hG).fixedByElement σ := by
  intro x hx
  change R.projectiveSMul σ x = x
  have hrep : x.rep ∈ R.plusEigenspace σ := (R.mem_plusProjectiveStratum_iff σ).mp hx
  have heig : R.act σ x.rep = x.rep := (R.mem_plusEigenspace_iff σ).mp hrep
  have hv : x.rep ≠ 0 := Projectivization.rep_nonzero x
  calc R.projectiveSMul σ x
      = R.projectiveSMul σ (Projectivization.mk k x.rep hv) := by rw [Projectivization.mk_rep]
    _ = Projectivization.mk k (R.act σ x.rep)
          (fun h0 => hv ((R.act_injective σ) (by simpa using h0))) := R.projectiveSMul_mk _ hv
    _ = Projectivization.mk k x.rep hv := by simp only [heig]
    _ = x := Projectivization.mk_rep x

public theorem plusProjectiveStratum_N_stable (R : FaithfulLinearRep k G V) (σ : G)
    (n : centralizer σ) {x : ℙ k V} (hx : x ∈ R.plusProjectiveStratum σ) :
    R.projectiveSMul (n : G) x ∈ R.plusProjectiveStratum σ := by
  have hcomm : Commute (n : G) σ := (mem_centralizer_iff).mp n.property
  have hrep : x.rep ∈ R.plusEigenspace σ := (R.mem_plusProjectiveStratum_iff σ).mp hx
  have heig : R.act σ x.rep = x.rep := (R.mem_plusEigenspace_iff σ).mp hrep
  have hv : x.rep ≠ 0 := Projectivization.rep_nonzero x
  have hne : R.act (n : G) x.rep ≠ 0 :=
    fun h0 => hv ((R.act_injective (n : G)) (by simpa using h0))
  have hx' : R.projectiveSMul (n : G) x =
      Projectivization.mk k (R.act (n : G) x.rep) hne := by
    calc R.projectiveSMul (n : G) x
        = R.projectiveSMul (n : G) (Projectivization.mk k x.rep hv) := by
            rw [Projectivization.mk_rep]
      _ = Projectivization.mk k (R.act (n : G) x.rep) hne := R.projectiveSMul_mk _ hv
  have hnrep : R.act (n : G) x.rep ∈ R.plusEigenspace σ := by
    rw [mem_plusEigenspace_iff]
    have h1 : R.act σ (R.act (n : G) x.rep) = R.act (σ * (n : G)) x.rep := by
      have := R.act_mul σ (n : G)
      exact congr_arg (fun L : V →ₗ[k] V => L x.rep) this.symm |>.trans (by rfl)
    -- simpler:
    calc R.act σ (R.act (n : G) x.rep)
        = (R.act σ ∘ₗ R.act (n : G)) x.rep := rfl
      _ = R.act (σ * (n : G)) x.rep := by rw [← R.act_mul]
      _ = R.act ((n : G) * σ) x.rep := by rw [hcomm.eq]
      _ = (R.act (n : G) ∘ₗ R.act σ) x.rep := by rw [R.act_mul]
      _ = R.act (n : G) (R.act σ x.rep) := rfl
      _ = R.act (n : G) x.rep := by rw [heig]
  change (R.projectiveSMul (n : G) x).submodule ≤ R.plusEigenspace σ
  rw [hx', Projectivization.submodule_mk]
  exact (Submodule.span_singleton_le_iff_mem _ _).mpr hnrep


public theorem plusProjectiveStratum_rcc (R : FaithfulLinearRep k G V) (σ : G)
    [CharZero k] [Module.Free k V] (hG : IsCenterless G)
    (hσ : IsInvolution σ) (hnd : ¬ R.DegeneratesToPlusMinusId σ) :
    IsRCC k (R.projectivizationVariety hG) (R.plusProjectiveStratum σ) := by
  obtain ⟨hplus, _⟩ := R.both_eigenspaces_nontrivial hσ hnd
  -- IsRCC = IsLinearRCC (embed '' S); embed = id (Function.Embedding.refl)
  show IsLinearRCC k ((R.projectivizationVariety hG).embed '' R.plusProjectiveStratum σ)
  have hembed :
      (R.projectivizationVariety hG).embed '' R.plusProjectiveStratum σ =
        R.plusProjectiveStratum σ := by
    ext x
    constructor
    · rintro ⟨y, hy, hyx⟩
      -- embed = refl so hyx : y = x
      change (y : ℙ k V) = x at hyx
      rwa [← hyx]
    · intro hx
      exact ⟨x, hx, rfl⟩
  rw [hembed]
  refine ⟨R.plusEigenspace σ, ?_, rfl⟩
  · -- finrank ≥ 1 from W ≠ ⊥
    haveI : FiniteDimensional k (R.plusEigenspace σ) := by
      haveI := R.finiteDimensional; infer_instance
    haveI : Nontrivial (R.plusEigenspace σ) := by
      obtain ⟨v, hv, hvne⟩ := Submodule.exists_mem_ne_zero_of_ne_bot hplus
      exact ⟨⟨v, hv⟩, 0, fun h => hvne (congrArg Subtype.val h)⟩
    exact Module.finrank_pos (R := k) (M := R.plusEigenspace σ)

end FaithfulLinearRep

/-! ## Weak versality -/

@[expose] public def ReceivesFromRep {k : Type u} [Field k] {G : Type u} [Group G]
    (Y : SmoothProjectiveGVariety k G) (hG : IsCenterless G)
    {V : Type u} [AddCommGroup V] [Module k V] [Module.Free k V]
    (R : FaithfulLinearRep k G V) : Prop :=
  HasGEquivariantRationalMap (R.projectivizationVariety hG) Y

@[expose] public def NotWeaklyVersal {k : Type u} [Field k] {G : Type u} [Group G]
    (Y : SmoothProjectiveGVariety k G) (hG : IsCenterless G) : Prop :=
  ∃ (V : Type u) (_ : AddCommGroup V) (_ : Module k V) (_ : Module.Free k V)
    (R : FaithfulLinearRep k G V), ¬ ReceivesFromRep Y hG R

@[expose] public def IsGUnirational {k : Type u} [Field k] {G : Type u} [Group G]
    (Y : SmoothProjectiveGVariety k G) (hG : IsCenterless G) : Prop :=
  ∃ (V : Type u) (_ : AddCommGroup V) (_ : Module k V) (_ : Module.Free k V)
    (R : FaithfulLinearRep k G V),
    HasDominantGEquivariantRationalMap (R.projectivizationVariety hG) Y

public lemma not_GUnirational_of_forall_no_map {k : Type u} [Field k] {G : Type u} [Group G]
    {Y : SmoothProjectiveGVariety k G} {hG : IsCenterless G}
    (h : ∀ (V : Type u) [AddCommGroup V] [Module k V] [Module.Free k V]
      (R : FaithfulLinearRep k G V), ¬ ReceivesFromRep Y hG R) :
    ¬ IsGUnirational Y hG := by
  rintro ⟨V, _, _, _, R, hdom⟩
  exact h V R (dominant_implies_rationalMap hdom)

end V14Formalization
