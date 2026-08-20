/-
Copyright (c) 2026 V14Formalization contributors.
Released under Apache 2.0 license.
-/
module

public import V14Formalization.WeilLambda2
public import V14Formalization.V14SchemeModel
public import V14Formalization.Lambda4Coordinates
public import V14Formalization.PluckerNaturality

/-!
# The Weil model commutes with extension of the base field

Everything in `WeilRep`, `WeilRepSL2`, `WeilHom` and `WeilLambda2` is built out
of one datum: a chosen primitive 11th root of unity `ζ` in the base field.  This
file proves the obvious consequence, which nothing in the tree had recorded: a
field homomorphism `φ : A → B` that *matches the two chosen roots* carries the
whole model over.

Concretely, `bcFun φ f = φ ∘ f` on `Fun A = 𝔽₁₁ → A` intertwines every operator
the Bruhat formula is assembled from — the quadratic phase `Tfull_b`, the
diagonal `Dfull`, and the Fourier transform `Sfull` — because

* `ψ(a) = ζ^a` and `φ ζ_A = ζ_B`,
* `χ₂` takes values in `ℤ ⊆ A`, and ring maps fix integers,
* `cFourier = gauss⁻¹` with `gauss = ∑ ψ(x²) ≠ 0`, and a field map inverts.

Consequently `weilFun`, `weilU`, `⋀²` and the character projector `projectorM`
all have matrices over `B` that are the entrywise `φ`-images of their matrices
over `A`.  The exterior-square step is `PluckerNaturality`'s compound-matrix
identity together with `RingHom.map_det`.

The payoff, at the bottom of the file: for `F` a field over `ℚ(ζ₁₁)` whose
chosen root is the image of the root of `ℚ(ζ₁₁)`,

* `lambda2Matrix_map` — the `15 × 15` matrices of the `PSL(2,11)`-action over
  `F` are the `φ`-images of `Lambda2Coordinates.lambda2MatrixRepresentation`;
* `projectorMatrix_map_mulVec_inclM` — the *`k`-defined* projector matrix
  `V14SchemeModel.projectorMatrix`, mapped to `F`, fixes the Plücker coordinate
  vector of every element of the `10′` summand `M_F ⊆ ⋀²U_F`.

The second is exactly the side condition `IntrinsicV14Compare.compare` asks for,
with the *`k`-form* of the linear cuts.  That is what lets the intrinsic `V₁₄`
over `F` map to the coordinate `V₁₄` over `k`.
-/

set_option linter.unusedSectionVars false
-- The three `ℚ(ζ₁₁)` bridge lemmas at the bottom are `rfl`, but the defeq check
-- walks the `ExteriorAlgebra` instance chain and the 660-element character sum.
set_option maxRecDepth 100000
set_option maxHeartbeats 4000000

noncomputable section

universe u

open Set Matrix Module exteriorPower

namespace V14Formalization
namespace WeilModelBaseChange

open V14Formalization.WeilRep (HasCycl11)

variable {A B : Type} [Field A] [Field B] [CharZero A] [CharZero B]
  [HasCycl11 A] [HasCycl11 B] (φ : A →+* B)

/-! ## The scalars -/

variable (hz : φ (WeilRep.ζ : A) = (WeilRep.ζ : B))

include hz in
public theorem map_ψ (a : ZMod 11) :
    φ ((WeilRep.ψ : AddChar (ZMod 11) A) a) = (WeilRep.ψ : AddChar (ZMod 11) B) a := by
  rw [WeilRep.ψ_apply, WeilRep.ψ_apply, map_pow, hz]

public theorem map_χ₂ (t : ZMod 11) :
    φ ((WeilRep.χ₂ : MulChar (ZMod 11) A) t) = (WeilRep.χ₂ : MulChar (ZMod 11) B) t := by
  show φ (algebraMap ℤ A (WeilRep.χ₂ℤ t)) = algebraMap ℤ B (WeilRep.χ₂ℤ t)
  simp [algebraMap_int_eq]

include hz in
public theorem map_gauss : φ (WeilRep.gauss : A) = (WeilRep.gauss : B) := by
  show φ (∑ x : ZMod 11, (WeilRep.ψ : AddChar (ZMod 11) A) (x ^ 2)) = _
  rw [map_sum]
  exact Finset.sum_congr rfl fun x _ => map_ψ φ hz (x ^ 2)

include hz in
public theorem map_cFourier : φ (WeilRep.cFourier : A) = (WeilRep.cFourier : B) := by
  show φ (WeilRep.gauss : A)⁻¹ = (WeilRep.gauss : B)⁻¹
  rw [map_inv₀, map_gauss φ hz]

/-! ## The operators on `Fun` -/

/-- Extension of scalars on `𝔽₁₁ → A`. -/
@[expose] public def bcFun (f : WeilRep.Fun A) : WeilRep.Fun B := fun x => φ (f x)

include hz in
public theorem bcFun_Tfull_b (b : ZMod 11) (f : WeilRep.Fun A) :
    bcFun φ (WeilRep.Tfull_b b f) = WeilRep.Tfull_b b (bcFun φ f) := by
  funext x
  show φ ((WeilRep.ψ : AddChar (ZMod 11) A) (b * x ^ 2 * WeilRep.twoInv) * f x) =
    (WeilRep.ψ : AddChar (ZMod 11) B) (b * x ^ 2 * WeilRep.twoInv) * φ (f x)
  rw [map_mul, map_ψ φ hz]

public theorem bcFun_Dfull (t : ZMod 11) (ht : t ≠ 0) (f : WeilRep.Fun A) :
    bcFun φ (WeilRepSL2.Dfull t ht f) = WeilRepSL2.Dfull t ht (bcFun φ f) := by
  funext x
  show φ ((WeilRep.χ₂ : MulChar (ZMod 11) A) t * f (t * x)) =
    (WeilRep.χ₂ : MulChar (ZMod 11) B) t * φ (f (t * x))
  rw [map_mul, map_χ₂ φ]

include hz in
public theorem bcFun_Sfull (f : WeilRep.Fun A) :
    bcFun φ (WeilRep.Sfull f) = WeilRep.Sfull (bcFun φ f) := by
  funext x
  show φ ((WeilRep.cFourier : A) *
      ∑ y : ZMod 11, (WeilRep.ψ : AddChar (ZMod 11) A) (x * y) * f y) =
    (WeilRep.cFourier : B) *
      ∑ y : ZMod 11, (WeilRep.ψ : AddChar (ZMod 11) B) (x * y) * φ (f y)
  rw [map_mul, map_cFourier φ hz, map_sum]
  congr 1
  exact Finset.sum_congr rfl fun y _ => by rw [map_mul, map_ψ φ hz]

include hz in
public theorem bcFun_weilFun (g : WeilLambda2.SLG) (f : WeilRep.Fun A) :
    bcFun φ (WeilRepSL2.weilFun g f) = WeilRepSL2.weilFun g (bcFun φ f) := by
  unfold WeilRepSL2.weilFun
  split_ifs with hc
  · show bcFun φ (WeilRep.Tfull_b _ (WeilRepSL2.Dfull _ _ f)) = _
    rw [bcFun_Tfull_b φ hz, bcFun_Dfull φ]
    rfl
  · show bcFun φ (-(WeilRep.Tfull_b _
        (WeilRep.Sfull (WeilRepSL2.Dfull _ hc (WeilRep.Tfull_b _ f))))) = _
    have hneg : ∀ w : WeilRep.Fun A, bcFun φ (-w) = -(bcFun φ w) := by
      intro w; funext x; show φ (-(w x)) = -(φ (w x)); rw [map_neg]
    rw [hneg, bcFun_Tfull_b φ hz, bcFun_Sfull φ hz, bcFun_Dfull φ,
      bcFun_Tfull_b φ hz]
    rfl

/-! ## The operators on `U` -/

/-- Extension of scalars on the even Weil module. -/
@[expose] public def bcU (f : WeilRep.U A) : WeilRep.U B :=
  ⟨bcFun φ f.1, fun x => by
    show φ (f.1 (-x)) = φ (f.1 x)
    rw [f.2 x]⟩

public theorem bcU_coe (f : WeilRep.U A) : (bcU φ f : WeilRep.Fun B) = bcFun φ f.1 := rfl

include hz in
public theorem bcU_weilU (g : WeilLambda2.SLG) (f : WeilRep.U A) :
    bcU φ (WeilRepSL2.weilU g f) = WeilRepSL2.weilU g (bcU φ f) := by
  apply Subtype.ext
  exact bcFun_weilFun φ hz g f.1

include hz in
public theorem bcU_weilUHom (g : WeilLambda2.SLG) (f : WeilRep.U A) :
    bcU φ (WeilHom.weilUHom g f) = WeilHom.weilUHom g (bcU φ f) :=
  bcU_weilU φ hz g f

/-! ## The coordinate basis of `U`, over any base field -/

/-- Evaluation at `0,…,5` is an isomorphism `U ≃ 𝔽₁₁⁶`, over any base field.
`Lambda2Coordinates.evalEvenEquivCore` is the instance at `ℚ(ζ₁₁)`. -/
@[expose] public def evalEvenEquiv (E : Type) [Field E] [CharZero E] [HasCycl11 E] :
    WeilRep.U E ≃ₗ[E] (Fin 6 → E) :=
  LinearEquiv.ofBijective (WeilLambda2.evalEven E)
    ⟨WeilLambda2.evalEven_injective E, fun v =>
      ⟨WeilLambda2.extendEven E v, by
        simpa [LinearMap.comp_apply] using
          LinearMap.congr_fun (WeilLambda2.evalEven_extendEven E) v⟩⟩

/-- The coordinate basis of `U` dual to evaluation at `0,…,5`, over any base
field.  `Lambda2Coordinates.uBasisCore` is the instance at `ℚ(ζ₁₁)`. -/
@[expose] public def uBasis (E : Type) [Field E] [CharZero E] [HasCycl11 E] :
    Basis (Fin 6) E (WeilRep.U E) :=
  Basis.ofEquivFun (evalEvenEquiv E)

public theorem evalEvenEquiv_symm (E : Type) [Field E] [CharZero E] [HasCycl11 E]
    (v : Fin 6 → E) : (evalEvenEquiv E).symm v = WeilLambda2.extendEven E v := by
  apply (evalEvenEquiv E).injective
  rw [LinearEquiv.apply_symm_apply]
  simpa [LinearMap.comp_apply, evalEvenEquiv] using
    (LinearMap.congr_fun (WeilLambda2.evalEven_extendEven E) v).symm

public theorem uBasis_repr (E : Type) [Field E] [CharZero E] [HasCycl11 E]
    (v : WeilRep.U E) (i : Fin 6) :
    (uBasis E).repr v i = (v : WeilRep.Fun E) (i.val : ZMod 11) :=
  Basis.ofEquivFun_repr_apply (evalEvenEquiv E) v i

public theorem uBasis_apply (E : Type) [Field E] [CharZero E] [HasCycl11 E] (j : Fin 6) :
    uBasis E j = WeilLambda2.extendEven E (Pi.single j 1) := by
  rw [show uBasis E j = (evalEvenEquiv E).symm (Pi.single j 1) from
      congrFun (Basis.coe_ofEquivFun (evalEvenEquiv E)) j, evalEvenEquiv_symm]

/-- At `ℚ(ζ₁₁)` this is the basis the sealed Plücker coordinates are written
in. -/
public theorem uBasis_k : uBasis V14SchemeModel.k = Lambda2Coordinates.uBasisCore := by
  have h : evalEvenEquiv V14SchemeModel.k = Lambda2Coordinates.evalEvenEquivCore :=
    LinearEquiv.ext fun _ => rfl
  rw [uBasis, h]
  rfl

/-! ## Base change on `U` respects the coordinate basis -/

public theorem bcU_extendEven (v : Fin 6 → A) :
    bcU φ (WeilLambda2.extendEven A v) =
      WeilLambda2.extendEven B (fun i => φ (v i)) := by
  apply Subtype.ext
  funext x
  show φ (WeilLambda2.extendEvenFun A v x) =
    WeilLambda2.extendEvenFun B (fun i => φ (v i)) x
  unfold WeilLambda2.extendEvenFun
  split_ifs <;> rfl

public theorem bcU_uBasis (j : Fin 6) : bcU φ (uBasis A j) = uBasis B j := by
  rw [uBasis_apply, uBasis_apply, bcU_extendEven]
  congr 1
  funext i
  by_cases h : i = j
  · subst h; simp
  · simp [h]

public theorem uBasis_repr_bcU (w : WeilRep.U A) (i : Fin 6) :
    (uBasis B).repr (bcU φ w) i = φ ((uBasis A).repr w i) := by
  rw [uBasis_repr, uBasis_repr]
  rfl

include hz in
/-- **The `6 × 6` Weil matrices base-change entrywise.** -/
public theorem toMatrix_weilUHom_map (t : WeilLambda2.SLG) :
    LinearMap.toMatrix (uBasis B) (uBasis B) (WeilHom.weilUHom t) =
      (LinearMap.toMatrix (uBasis A) (uBasis A) (WeilHom.weilUHom t)).map φ := by
  ext i j
  rw [LinearMap.toMatrix_apply, Matrix.map_apply, LinearMap.toMatrix_apply,
    ← bcU_uBasis φ j, ← bcU_weilUHom φ hz, uBasis_repr_bcU]

/-! ## The exterior square, in lex Plücker coordinates

`PluckerNaturality` proves the compound-matrix identity, but only for the
`ℚ(ζ₁₁)` instance and with the two general steps kept module-private.  The two
statements below are those steps, restated for an arbitrary basis of an
arbitrary module — nothing about them is field-specific — followed by the one
new fact: the compound construction commutes with a ring map, because a `2 × 2`
determinant does.
-/

section Exterior

variable {R : Type u} [Field R] {W : Type u} [AddCommGroup W] [Module R W]

/-- The matrix entry of `exteriorPower.map n f` in the exterior basis is an
`n × n` minor determinant.  (`PluckerNaturality.exterior_repr_map_eq_det_cross`,
which is module-private there.) -/
public theorem exterior_repr_map_eq_det
    (n : ℕ) {ι : Type*} [LinearOrder ι] [Fintype ι] [DecidableEq ι]
    (b : Basis ι R W) (f : Module.End R W) (s t : powersetCard ι n) :
    (b.exteriorPower n).repr (exteriorPower.map n f (b.exteriorPower n s)) t =
      ((LinearMap.toMatrix b b f).submatrix
        (powersetCard.ofFinEmbEquiv.symm t)
        (powersetCard.ofFinEmbEquiv.symm s)).det := by
  set Bx := b.exteriorPower n
  set embS := powersetCard.ofFinEmbEquiv.symm s
  set embT := powersetCard.ofFinEmbEquiv.symm t
  have hBs : Bx s = exteriorPower.ιMulti_family R n (b : ι → W) s := by
    simp only [Bx]
    exact exteriorPower.basis_apply (R := R) (n := n) b s
  rw [hBs, exteriorPower.basis_repr_apply (R := R) (n := n) b]
  have hmap :
      exteriorPower.map n f (exteriorPower.ιMulti_family R n (b : ι → W) s) =
        exteriorPower.ιMulti R n (fun i : Fin n => f (b (embS i))) := by
    dsimp [exteriorPower.ιMulti_family, embS]
    rw [exteriorPower.map_apply_ιMulti]
    rfl
  rw [hmap, exteriorPower.ιMultiDual_apply_ιMulti (R := R) (n := n) b t]
  have hT :
      (Matrix.of fun i j : Fin n => b.coord (embT j) (f (b (embS i)))) =
        ((LinearMap.toMatrix b b f).submatrix embT embS)ᵀ := by
    ext i j
    simp [Matrix.transpose_apply, Matrix.of_apply, Matrix.submatrix_apply,
      LinearMap.toMatrix_apply, Basis.coord_apply]
  rw [hT, Matrix.det_transpose]

/-- In the lexicographic Plücker basis attached to a basis `c` of a
six-dimensional space, the matrix of `⋀²f` is the order-two compound matrix of
the matrix of `f`. -/
public theorem toMatrix_lex2_eq_compound2Lex
    (c : Basis (Fin 6) R W) (f : Module.End R W) :
    LinearMap.toMatrix (Lambda4Coordinates.lex2 c) (Lambda4Coordinates.lex2 c)
        (exteriorPower.map 2 f) =
      PluckerNaturality.compound2Lex (LinearMap.toMatrix c c f) := by
  have hsymm : ∀ i : Fin 15,
      Lambda2Coordinates.pluckerPairEquiv.symm i = Lambda2Coordinates.pairEnumeration i :=
    fun i => Equiv.ofBijective_apply Lambda2Coordinates.pairEnumeration
      Lambda2Coordinates.pairEnumeration_bijective i
  ext i j
  have hre : LinearMap.toMatrix (Lambda4Coordinates.lex2 c) (Lambda4Coordinates.lex2 c)
        (exteriorPower.map 2 f) i j =
      (c.exteriorPower 2).repr
        (exteriorPower.map 2 f ((c.exteriorPower 2)
          (Lambda2Coordinates.pluckerPairEquiv.symm j)))
        (Lambda2Coordinates.pluckerPairEquiv.symm i) := by
    simp only [Lambda4Coordinates.lex2, LinearMap.toMatrix_apply, Basis.reindex_apply,
      Basis.repr_reindex, Finsupp.mapDomain_equiv_apply]
  rw [hre, exterior_repr_map_eq_det]
  simp only [PluckerNaturality.compound2Lex, Matrix.of_apply, PluckerNaturality.pairEmb,
    hsymm]

end Exterior

/-- The order-two compound construction commutes with a ring map. -/
public theorem compound2Lex_map (M : Matrix (Fin 6) (Fin 6) A) :
    PluckerNaturality.compound2Lex (M.map φ) =
      (PluckerNaturality.compound2Lex M).map φ := by
  ext i j
  simp only [PluckerNaturality.compound2Lex, Matrix.of_apply, Matrix.map_apply,
    RingHom.map_det]
  congr 1

/-! ## The `15 × 15` matrices base-change entrywise -/

include hz in
public theorem toMatrix_weilLambda2_map (t : WeilLambda2.SLG) :
    LinearMap.toMatrix (Lambda4Coordinates.lex2 (uBasis B))
        (Lambda4Coordinates.lex2 (uBasis B)) (WeilLambda2.weilLambda2 B t) =
      (LinearMap.toMatrix (Lambda4Coordinates.lex2 (uBasis A))
        (Lambda4Coordinates.lex2 (uBasis A)) (WeilLambda2.weilLambda2 A t)).map φ := by
  rw [show WeilLambda2.weilLambda2 B t =
      exteriorPower.map 2 (WeilHom.weilUHom t) from rfl,
    show WeilLambda2.weilLambda2 A t =
      exteriorPower.map 2 (WeilHom.weilUHom t) from rfl,
    toMatrix_lex2_eq_compound2Lex, toMatrix_lex2_eq_compound2Lex,
    toMatrix_weilUHom_map φ hz, compound2Lex_map]

include hz in
public theorem toMatrix_ambientAct_map (g : WeilLambda2.PSL2F11) :
    LinearMap.toMatrix (Lambda4Coordinates.lex2 (uBasis B))
        (Lambda4Coordinates.lex2 (uBasis B)) (WeilLambda2.ambientAct B g) =
      (LinearMap.toMatrix (Lambda4Coordinates.lex2 (uBasis A))
        (Lambda4Coordinates.lex2 (uBasis A)) (WeilLambda2.ambientAct A g)).map φ := by
  obtain ⟨t, rfl⟩ :=
    QuotientGroup.mk_surjective (s := Subgroup.center WeilLambda2.SLG) g
  rw [show WeilLambda2.ambientAct B (QuotientGroup.mk t) =
      WeilLambda2.weilLambda2 B t from WeilLambda2.pslLambda2_mk B t,
    show WeilLambda2.ambientAct A (QuotientGroup.mk t) =
      WeilLambda2.weilLambda2 A t from WeilLambda2.pslLambda2_mk A t]
  exact toMatrix_weilLambda2_map φ hz t

/-! ## The character projector -/

public theorem map_chi10' (g : WeilLambda2.PSL2F11) :
    φ (WeilLambda2.chi10' A g) = WeilLambda2.chi10' B g := by
  have h : ∀ (E : Type) [Field E] [CharZero E] [HasCycl11 E],
      WeilLambda2.chi10' E g =
        (if orderOf g = 1 then 10 else if orderOf g = 2 then 2 else
          if orderOf g = 3 then 1 else if orderOf g = 5 then 0 else
          if orderOf g = 6 then -1 else if orderOf g = 11 then -1 else 0 : E) :=
    fun E => rfl
  rw [h A, h B]
  split_ifs <;> simp only [map_ofNat, map_one, map_zero, map_neg]

public theorem toMatrix_projectorM_expand (E : Type) [Field E] [CharZero E] [HasCycl11 E] :
    LinearMap.toMatrix (Lambda4Coordinates.lex2 (uBasis E))
        (Lambda4Coordinates.lex2 (uBasis E)) (WeilLambda2.projectorM E) =
      (10 * (660 : E)⁻¹) • ∑ g : WeilLambda2.PSL2F11, WeilLambda2.chi10' E g •
        LinearMap.toMatrix (Lambda4Coordinates.lex2 (uBasis E))
          (Lambda4Coordinates.lex2 (uBasis E)) (WeilLambda2.ambientAct E g) := by
  rw [show WeilLambda2.projectorM E =
      (10 * (660 : E)⁻¹) • ∑ g : WeilLambda2.PSL2F11, WeilLambda2.chi10' E g •
        (WeilLambda2.ambientAct E g : Module.End E (WeilLambda2.Lambda2U E)) from rfl,
    map_smul, map_sum]
  simp only [map_smul]

include hz in
/-- **The character projector base-changes entrywise.** -/
public theorem toMatrix_projectorM_map :
    LinearMap.toMatrix (Lambda4Coordinates.lex2 (uBasis B))
        (Lambda4Coordinates.lex2 (uBasis B)) (WeilLambda2.projectorM B) =
      (LinearMap.toMatrix (Lambda4Coordinates.lex2 (uBasis A))
        (Lambda4Coordinates.lex2 (uBasis A)) (WeilLambda2.projectorM A)).map φ := by
  have hconst : φ (10 * (660 : A)⁻¹) = 10 * (660 : B)⁻¹ := by
    rw [map_mul, map_inv₀, map_ofNat, map_ofNat]
  have hentry := fun g => congrFun₂ (toMatrix_ambientAct_map φ hz g)
  rw [toMatrix_projectorM_expand, toMatrix_projectorM_expand]
  ext i j
  simp only [Matrix.map_apply, Matrix.smul_apply, Matrix.sum_apply, smul_eq_mul,
    map_mul, map_sum, hconst, map_chi10' φ]
  refine congrArg (fun t => 10 * (660 : B)⁻¹ * t) (Finset.sum_congr rfl fun g _ => ?_)
  refine congrArg (fun t => WeilLambda2.chi10' B g * t) ?_
  simpa [Matrix.map_apply] using hentry g i j

/-! ## The bridge to the sealed `ℚ(ζ₁₁)` coordinates -/

public theorem lex2_uBasis_k :
    Lambda4Coordinates.lex2 (uBasis V14SchemeModel.k) = Lambda2Coordinates.lambda2Basis := by
  rw [uBasis_k]
  rfl

public theorem lambda2Matrix_k (g : WeilLambda2.PSL2F11) :
    LinearMap.toMatrix (Lambda4Coordinates.lex2 (uBasis V14SchemeModel.k))
        (Lambda4Coordinates.lex2 (uBasis V14SchemeModel.k))
        (WeilLambda2.ambientAct V14SchemeModel.k g) =
      (Lambda2Coordinates.lambda2MatrixRepresentation.ρ g :
        Matrix (Fin 15) (Fin 15) V14SchemeModel.k) := by
  rw [lex2_uBasis_k, Lambda2Coordinates.lambda2MatrixRepresentation_coe]
  rfl

public theorem projectorMatrix_k :
    LinearMap.toMatrix (Lambda4Coordinates.lex2 (uBasis V14SchemeModel.k))
        (Lambda4Coordinates.lex2 (uBasis V14SchemeModel.k))
        (WeilLambda2.projectorM V14SchemeModel.k) =
      V14SchemeModel.projectorMatrix := by
  rw [lex2_uBasis_k]
  rfl

/-! ## The payoff: the `k`-defined coordinate data, read over `F`

Let `F` be a field over `ℚ(ζ₁₁)` whose chosen primitive 11th root is the image
of the one in `ℚ(ζ₁₁)`.  Then the sealed `15 × 15` matrices — the group action
and the character projector — are the `algebraMap`-images of the `ℚ(ζ₁₁)` ones,
in the lex Plücker basis attached to `uBasis F`.
-/

section OverBase

variable (F : Type) [Field F] [CharZero F] [HasCycl11 F] [Algebra V14SchemeModel.k F]
  (hzF : algebraMap V14SchemeModel.k F (WeilRep.ζ : V14SchemeModel.k) = (WeilRep.ζ : F))

include hzF

/-- **The sealed action matrices, read over `F`.** -/
public theorem lambda2Matrix_map (g : WeilLambda2.PSL2F11) :
    LinearMap.toMatrix (Lambda4Coordinates.lex2 (uBasis F))
        (Lambda4Coordinates.lex2 (uBasis F)) (WeilLambda2.ambientAct F g) =
      (Lambda2Coordinates.lambda2MatrixRepresentation.ρ g :
        Matrix (Fin 15) (Fin 15) V14SchemeModel.k).map
        (algebraMap V14SchemeModel.k F) := by
  rw [← lambda2Matrix_k g]
  exact toMatrix_ambientAct_map (algebraMap V14SchemeModel.k F) hzF g

/-- **The sealed projector matrix, read over `F`.** -/
public theorem projectorMatrix_map :
    LinearMap.toMatrix (Lambda4Coordinates.lex2 (uBasis F))
        (Lambda4Coordinates.lex2 (uBasis F)) (WeilLambda2.projectorM F) =
      V14SchemeModel.projectorMatrix.map (algebraMap V14SchemeModel.k F) := by
  rw [← projectorMatrix_k]
  exact toMatrix_projectorM_map (algebraMap V14SchemeModel.k F) hzF

public theorem projectorMatrix_map_mulVec (v : WeilLambda2.Lambda2U F) :
    (V14SchemeModel.projectorMatrix.map (algebraMap V14SchemeModel.k F)).mulVec
        ((Lambda4Coordinates.lex2 (uBasis F)).equivFun v) =
      (Lambda4Coordinates.lex2 (uBasis F)).equivFun (WeilLambda2.projectorM F v) := by
  rw [← projectorMatrix_map F hzF]
  simpa only [Basis.equivFun_apply] using
    LinearMap.toMatrix_mulVec_repr (Lambda4Coordinates.lex2 (uBasis F))
      (Lambda4Coordinates.lex2 (uBasis F)) (WeilLambda2.projectorM F) v

/-- **The `ℚ(ζ₁₁)`-defined linear cuts vanish on the `10′` summand over `F`.**

This is the side condition `IntrinsicV14Compare.compare` asks of a projector
matrix — stated for the *`k`*-form of the matrix, which is what makes the
intrinsic `V₁₄` over `F` map to the coordinate `V₁₄` over `k`.  Idempotence is
imported from `ℚ(ζ₁₁)`; nothing has to be reproved over `F`. -/
public theorem projectorMatrix_map_mulVec_Msub
    (x : ↥(WeilLambda2.Msub F)) :
    (V14SchemeModel.projectorMatrix.map (algebraMap V14SchemeModel.k F)).mulVec
        ((Lambda4Coordinates.lex2 (uBasis F)).equivFun
          ((WeilLambda2.Msub F).subtype x)) =
      (Lambda4Coordinates.lex2 (uBasis F)).equivFun
        ((WeilLambda2.Msub F).subtype x) := by
  obtain ⟨w, hw⟩ := x.2
  have hx : ((WeilLambda2.Msub F).subtype x : WeilLambda2.Lambda2U F) =
      WeilLambda2.projectorM F w := hw.symm
  have hPP : (V14SchemeModel.projectorMatrix.map (algebraMap V14SchemeModel.k F)) *
      (V14SchemeModel.projectorMatrix.map (algebraMap V14SchemeModel.k F)) =
      V14SchemeModel.projectorMatrix.map (algebraMap V14SchemeModel.k F) := by
    rw [← Matrix.map_mul (f := (algebraMap V14SchemeModel.k F : _ →+* _)),
      V14SchemeModel.projectorMatrix_idempotent]
  rw [hx, ← projectorMatrix_map_mulVec F hzF w, Matrix.mulVec_mulVec, hPP]

/-- The coordinate form of the `PSL(2,11)`-action over `F`, against the
`ℚ(ζ₁₁)`-defined matrices. -/
public theorem lex2_equivFun_ambientAct (g : WeilLambda2.PSL2F11)
    (v : WeilLambda2.Lambda2U F) (j : Fin 15) :
    (Lambda4Coordinates.lex2 (uBasis F)).equivFun (WeilLambda2.ambientAct F g v) j =
      ∑ l : Fin 15,
        ((Lambda2Coordinates.lambda2MatrixRepresentation.ρ g :
          Matrix (Fin 15) (Fin 15) V14SchemeModel.k).map
            (algebraMap V14SchemeModel.k F)) j l *
          (Lambda4Coordinates.lex2 (uBasis F)).equivFun v l := by
  have h := LinearMap.toMatrix_mulVec_repr (Lambda4Coordinates.lex2 (uBasis F))
    (Lambda4Coordinates.lex2 (uBasis F)) (WeilLambda2.ambientAct F g) v
  rw [lambda2Matrix_map F hzF g] at h
  have hj := congrFun h j
  simpa [Matrix.mulVec, dotProduct, Basis.equivFun_apply] using hj.symm

end OverBase

end WeilModelBaseChange
end V14Formalization
