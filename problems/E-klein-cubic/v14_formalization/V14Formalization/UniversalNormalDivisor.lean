/-
Copyright (c) 2026 V14Formalization contributors.
Released under Apache 2.0 license.
-/
module

public import V14Formalization.Definitions
public import V14Formalization.SchemeProjectiveAction
public import V14Formalization.BiprojectiveIntegral
public import BConicBundleMultisections.BiprojectiveSpaceProperties
public import BConicBundleMultisections.ProjectiveSpaceChartDominance
public import Mathlib.LinearAlgebra.Basis.Prod
public import Mathlib.LinearAlgebra.Dimension.Free

/-!
# The universal normal divisor with its centralizer action

For an involution `sigma` in an honest linear representation, its centralizer
preserves both eigenspaces.  After choosing bases, their projectivizations
carry genuine scheme actions and their fiber product is the exceptional
normal divisor

`P(V₊) × P(V₋)`.

This file constructs that action.  It deliberately makes no claim that a
chosen affine valuation chart, or the whole projective carrier, is already
fixed pointwise by `sigma`; those are separate compatibility statements.
-/

noncomputable section

open CategoryTheory CategoryTheory.Limits
open scoped AlgebraicGeometry

namespace V14Formalization
namespace SchemeGeometry

open AlgebraicGeometry BConicBundleMultisections Module

attribute [local instance] MvPolynomial.gradedAlgebra

universe u

variable {k : Type u} [Field k] {G : Type u} [Group G]
  {V : Type u} [AddCommGroup V] [Module k V]

/-- Matrix coordinates for the full representation in a chosen basis. -/
@[expose] public def ambientMatrixRepresentation
    (R : FaithfulLinearRep k G V) (d : ℕ)
    (b : Basis (Fin (d + 1)) k V) :
    MatrixRepresentation (k := k) (G := G) d :=
  (Matrix.GeneralLinearGroup.toLin' b).symm.toMonoidHom.comp
    R.ρ.toHomUnits

/-- The source projective space with its honest full-group scheme action. -/
@[expose] public def ambientProjectiveActionOver
    (R : FaithfulLinearRep k G V) (d : ℕ)
    (b : Basis (Fin (d + 1)) k V) :
    Action (Over (Spec (.of k))) G :=
  projectiveActionOver d (ambientMatrixRepresentation R d b)

@[simp]
theorem ambientProjectiveActionOver_carrier
    (R : FaithfulLinearRep k G V) (d : ℕ)
    (b : Basis (Fin (d + 1)) k V) :
    (ambientProjectiveActionOver R d b).V.left =
      ProjectiveSpace d k := rfl

/-- The source projective scheme is integral. -/
@[expose] public instance ambientProjectiveActionOver_isIntegral
    (R : FaithfulLinearRep k G V) (d : ℕ)
    (b : Basis (Fin (d + 1)) k V) :
    IsIntegral (ambientProjectiveActionOver R d b).V.left := by
  change IsIntegral (ProjectiveSpace d k)
  infer_instance

public abbrev CentralizerPlus (R : FaithfulLinearRep k G V) (sigma : G) :=
  R.plusEigenspace sigma

public abbrev CentralizerMinus (R : FaithfulLinearRep k G V) (sigma : G) :=
  R.minusEigenspace sigma

/-- The honest centralizer representation on the plus eigenspace. -/
@[expose] public def plusCentralizerRepresentation
    (R : FaithfulLinearRep k G V) (sigma : G) :
    Representation k (centralizer sigma) (CentralizerPlus R sigma) where
  toFun n := (R.act (n : G)).restrict fun x hx ↦
    R.plusEigenspace_centralizer_stable sigma n hx
  map_one' := by
    ext x
    simp [FaithfulLinearRep.act_one]
  map_mul' n m := by
    ext x
    simp [FaithfulLinearRep.act_mul, LinearMap.comp_apply]

/-- The honest centralizer representation on the minus eigenspace. -/
@[expose] public def minusCentralizerRepresentation
    (R : FaithfulLinearRep k G V) (sigma : G) :
    Representation k (centralizer sigma) (CentralizerMinus R sigma) where
  toFun n := (R.act (n : G)).restrict fun x hx ↦
    R.minusEigenspace_centralizer_stable sigma n hx
  map_one' := by
    ext x
    simp [FaithfulLinearRep.act_one]
  map_mul' n m := by
    ext x
    simp [FaithfulLinearRep.act_mul, LinearMap.comp_apply]

/-- Matrix coordinates for the plus restriction in a chosen basis. -/
@[expose] public def plusCentralizerMatrixRepresentation
    (R : FaithfulLinearRep k G V) (sigma : G) (p : ℕ)
    (b : Basis (Fin (p + 1)) k (CentralizerPlus R sigma)) :
    MatrixRepresentation (k := k) (G := centralizer sigma) p :=
  (Matrix.GeneralLinearGroup.toLin' b).symm.toMonoidHom.comp
    (plusCentralizerRepresentation R sigma).toHomUnits

/-- Matrix coordinates for the minus restriction in a chosen basis. -/
@[expose] public def minusCentralizerMatrixRepresentation
    (R : FaithfulLinearRep k G V) (sigma : G) (q : ℕ)
    (b : Basis (Fin (q + 1)) k (CentralizerMinus R sigma)) :
    MatrixRepresentation (k := k) (G := centralizer sigma) q :=
  (Matrix.GeneralLinearGroup.toLin' b).symm.toMonoidHom.comp
    (minusCentralizerRepresentation R sigma).toHomUnits

/-- The distinguished involution as an element of its centralizer. -/
@[expose] public def sigmaCentralizer (sigma : G) : centralizer sigma :=
  ⟨sigma, mem_centralizer_iff.mpr (Commute.refl sigma)⟩

public theorem plusCentralizerRepresentation_sigma
    (R : FaithfulLinearRep k G V) (sigma : G) :
    plusCentralizerRepresentation R sigma (sigmaCentralizer sigma) =
      LinearMap.id := by
  ext x
  exact (R.mem_plusEigenspace_iff sigma).mp x.2

public theorem minusCentralizerRepresentation_sigma
    (R : FaithfulLinearRep k G V) (sigma : G) :
    minusCentralizerRepresentation R sigma (sigmaCentralizer sigma) =
      -LinearMap.id := by
  ext x
  exact (R.mem_minusEigenspace_iff sigma).mp x.2

public theorem plusCentralizerMatrixRepresentation_sigma
    (R : FaithfulLinearRep k G V) (sigma : G) (p : ℕ)
    (b : Basis (Fin (p + 1)) k (CentralizerPlus R sigma)) :
    plusCentralizerMatrixRepresentation R sigma p b (sigmaCentralizer sigma) = 1 := by
  change (Matrix.GeneralLinearGroup.toLin' b).symm
      ((plusCentralizerRepresentation R sigma).toHomUnits
        (sigmaCentralizer sigma)) = 1
  rw [← (Matrix.GeneralLinearGroup.toLin' b).symm.map_one]
  apply congrArg (Matrix.GeneralLinearGroup.toLin' b).symm
  apply Units.ext
  exact plusCentralizerRepresentation_sigma R sigma

public theorem minusCentralizerMatrixRepresentation_sigma
    (R : FaithfulLinearRep k G V) (sigma : G) (q : ℕ)
    (b : Basis (Fin (q + 1)) k (CentralizerMinus R sigma)) :
    minusCentralizerMatrixRepresentation R sigma q b (sigmaCentralizer sigma) = -1 := by
  change (Matrix.GeneralLinearGroup.toLin' b).symm
      ((minusCentralizerRepresentation R sigma).toHomUnits
        (sigmaCentralizer sigma)) = -1
  apply Units.ext
  ext i j
  change LinearMap.toMatrix b b
      (minusCentralizerRepresentation R sigma (sigmaCentralizer sigma)) i j = _
  rw [minusCentralizerRepresentation_sigma]
  simp [Matrix.one_apply]

/-- The plus eigenspace projective scheme with its centralizer action. -/
@[expose] public def plusProjectiveActionOver
    (R : FaithfulLinearRep k G V) (sigma : G) (p : ℕ)
    (b : Basis (Fin (p + 1)) k (CentralizerPlus R sigma)) :
    Action (Over (Spec (.of k))) (centralizer sigma) :=
  projectiveActionOver p (plusCentralizerMatrixRepresentation R sigma p b)

/-- The minus eigenspace projective scheme with its centralizer action. -/
@[expose] public def minusProjectiveActionOver
    (R : FaithfulLinearRep k G V) (sigma : G) (q : ℕ)
    (b : Basis (Fin (q + 1)) k (CentralizerMinus R sigma)) :
    Action (Over (Spec (.of k))) (centralizer sigma) :=
  projectiveActionOver q (minusCentralizerMatrixRepresentation R sigma q b)

/-- Diagonal action morphism on a fiber product. -/
@[expose] public def diagonalPullbackActionHom {S : Scheme.{u}} {N : Type u} [Group N]
    (A B : Action (Over S) N) (n : N) :
    pullback A.V.hom B.V.hom ⟶ pullback A.V.hom B.V.hom :=
  pullback.lift
    (pullback.fst A.V.hom B.V.hom ≫ (A.ρ n).left)
    (pullback.snd A.V.hom B.V.hom ≫ (B.ρ n).left)
    (by simpa using pullback.condition (f := A.V.hom) (g := B.V.hom))

@[simp]
public theorem diagonalPullbackActionHom_fst
    {S : Scheme.{u}} {N : Type u} [Group N]
    (A B : Action (Over S) N) (n : N) :
    diagonalPullbackActionHom A B n ≫ pullback.fst A.V.hom B.V.hom =
      pullback.fst A.V.hom B.V.hom ≫ (A.ρ n).left := by
  dsimp [diagonalPullbackActionHom]
  erw [pullback.lift_fst]

@[simp]
public theorem diagonalPullbackActionHom_snd
    {S : Scheme.{u}} {N : Type u} [Group N]
    (A B : Action (Over S) N) (n : N) :
    diagonalPullbackActionHom A B n ≫ pullback.snd A.V.hom B.V.hom =
      pullback.snd A.V.hom B.V.hom ≫ (B.ρ n).left := by
  dsimp [diagonalPullbackActionHom]
  erw [pullback.lift_snd]

public theorem diagonalPullbackActionHom_one
    {S : Scheme.{u}} {N : Type u} [Group N]
    (A B : Action (Over S) N) :
    diagonalPullbackActionHom A B 1 = 𝟙 _ := by
  apply pullback.hom_ext
  · rw [diagonalPullbackActionHom_fst]
    simp
  · rw [diagonalPullbackActionHom_snd]
    simp

public theorem diagonalPullbackActionHom_mul
    {S : Scheme.{u}} {N : Type u} [Group N]
    (A B : Action (Over S) N) (m n : N) :
    diagonalPullbackActionHom A B (m * n) =
      diagonalPullbackActionHom A B n ≫ diagonalPullbackActionHom A B m := by
  apply pullback.hom_ext
  · rw [diagonalPullbackActionHom_fst, Category.assoc,
      diagonalPullbackActionHom_fst, ← Category.assoc,
      diagonalPullbackActionHom_fst]
    simp
  · rw [diagonalPullbackActionHom_snd, Category.assoc,
      diagonalPullbackActionHom_snd, ← Category.assoc,
      diagonalPullbackActionHom_snd]
    simp

/-- Diagonal action on a fiber product of two schemes over the same base. -/
@[expose] public def diagonalPullbackActionOver {S : Scheme.{u}} {N : Type u} [Group N]
    (A B : Action (Over S) N) : Action (Over S) N where
  V := Over.mk (pullback.fst A.V.hom B.V.hom ≫ A.V.hom)
  ρ :=
    { toFun := fun n ↦ Over.homMk (diagonalPullbackActionHom A B n) (by
        change diagonalPullbackActionHom A B n ≫
            (pullback.fst A.V.hom B.V.hom ≫ A.V.hom) =
          pullback.fst A.V.hom B.V.hom ≫ A.V.hom
        rw [← Category.assoc, diagonalPullbackActionHom_fst,
          Category.assoc, (A.ρ n).w])
      map_one' := by
        apply Over.OverMorphism.ext
        exact diagonalPullbackActionHom_one A B
      map_mul' := fun m n ↦ by
        apply Over.OverMorphism.ext
        exact diagonalPullbackActionHom_mul A B m n }

/-- The universal normal-divisor carrier with its diagonal centralizer action,
after choosing bases of the two eigenspaces. -/
@[expose] public def normalDivisorActionOver
    (R : FaithfulLinearRep k G V) (sigma : G) (p q : ℕ)
    (bp : Basis (Fin (p + 1)) k (CentralizerPlus R sigma))
    (bm : Basis (Fin (q + 1)) k (CentralizerMinus R sigma)) :
    Action (Over (Spec (.of k))) (centralizer sigma) :=
  diagonalPullbackActionOver
    (plusProjectiveActionOver R sigma p bp)
    (minusProjectiveActionOver R sigma q bm)

@[simp]
theorem normalDivisorActionOver_carrier
    (R : FaithfulLinearRep k G V) (sigma : G) (p q : ℕ)
    (bp : Basis (Fin (p + 1)) k (CentralizerPlus R sigma))
    (bm : Basis (Fin (q + 1)) k (CentralizerMinus R sigma)) :
    (normalDivisorActionOver R sigma p q bp bm).V.left =
      BiprojectiveSpace p q k := rfl

@[simp]
theorem normalDivisorActionOver_toSpec
    (R : FaithfulLinearRep k G V) (sigma : G) (p q : ℕ)
    (bp : Basis (Fin (p + 1)) k (CentralizerPlus R sigma))
    (bm : Basis (Fin (q + 1)) k (CentralizerMinus R sigma)) :
    (normalDivisorActionOver R sigma p q bp bm).V.hom =
      BiprojectiveSpace.toSpec p q k := rfl

/-- The normal divisor is integral. -/
@[expose] public instance normalDivisorActionOver_isIntegral
    (R : FaithfulLinearRep k G V) (sigma : G) (p q : ℕ)
    (bp : Basis (Fin (p + 1)) k (CentralizerPlus R sigma))
    (bm : Basis (Fin (q + 1)) k (CentralizerMinus R sigma)) :
    IsIntegral (normalDivisorActionOver R sigma p q bp bm).V.left := by
  change IsIntegral (BiprojectiveSpace p q k)
  infer_instance

/-- The ambient representation splits equivariantly into its two eigenspaces. -/
@[expose] public def plusMinusLinearEquiv [CharZero k]
    (R : FaithfulLinearRep k G V) (sigma : G) (hσ : IsInvolution sigma) :
    V ≃ₗ[k] (R.plusEigenspace sigma × R.minusEigenspace sigma) :=
  ((R.plusEigenspace sigma).prodEquivOfIsCompl
    (R.minusEigenspace sigma) (R.isCompl_plus_minus hσ)).symm

public theorem plusMinusLinearEquiv_centralizer [CharZero k]
    (R : FaithfulLinearRep k G V) (sigma : G)
    (hσ : IsInvolution sigma) (n : centralizer sigma) (v : V) :
    plusMinusLinearEquiv R sigma hσ (R.act (n : G) v) =
      (⟨R.act (n : G) (plusMinusLinearEquiv R sigma hσ v).1.1,
          R.plusEigenspace_centralizer_stable sigma n
            (plusMinusLinearEquiv R sigma hσ v).1.2⟩,
        ⟨R.act (n : G) (plusMinusLinearEquiv R sigma hσ v).2.1,
          R.minusEigenspace_centralizer_stable sigma n
            (plusMinusLinearEquiv R sigma hσ v).2.2⟩) := by
  let e := (R.plusEigenspace sigma).prodEquivOfIsCompl
    (R.minusEigenspace sigma) (R.isCompl_plus_minus hσ)
  apply e.injective
  change e (e.symm (R.act (n : G) v)) = _
  rw [e.apply_symm_apply]
  rw [Submodule.coe_prodEquivOfIsCompl']
  change R.act (n : G) v =
    R.act (n : G) (plusMinusLinearEquiv R sigma hσ v).1.1 +
      R.act (n : G) (plusMinusLinearEquiv R sigma hσ v).2.1
  rw [← map_add]
  congr 1
  symm
  calc
    (plusMinusLinearEquiv R sigma hσ v).1.1 +
        (plusMinusLinearEquiv R sigma hσ v).2.1 =
      e (plusMinusLinearEquiv R sigma hσ v) :=
        (Submodule.coe_prodEquivOfIsCompl'
          (R.plusEigenspace sigma) (R.minusEigenspace sigma)
          (R.isCompl_plus_minus hσ)
          (plusMinusLinearEquiv R sigma hσ v)).symm
    _ = v := e.apply_symm_apply v

/-- The block-order identification used for plus coordinates followed by
minus coordinates. -/
@[expose] public def finSumFinEquiv (m n : ℕ) : Fin m ⊕ Fin n ≃ Fin (m + n) where
  toFun := Sum.elim (Fin.castAdd n) (Fin.natAdd m)
  invFun := Fin.addCases Sum.inl Sum.inr
  left_inv x := by cases x <;> simp
  right_inv i := by
    refine Fin.addCases ?_ ?_ i
    · intro j
      simp
    · intro j
      simp

/-- The concrete block order has ambient projective dimension `p + q + 1`. -/
@[expose] public def plusMinusFinEquiv (p q : ℕ) :
    Fin (p + 1) ⊕ Fin (q + 1) ≃ Fin ((p + q + 1) + 1) :=
  (finSumFinEquiv (p + 1) (q + 1)).trans
    (Equiv.cast (congrArg Fin (by omega)))

/-- The ambient basis formed by concatenating the plus and minus bases and
transporting across the eigenspace decomposition.  These are the homogeneous
coordinates used by the normal valuation chart. -/
@[expose] public def plusMinusAmbientBasis [CharZero k]
    (R : FaithfulLinearRep k G V) (sigma : G) (hσ : IsInvolution sigma)
    (p q : ℕ)
    (bp : Basis (Fin (p + 1)) k (R.plusEigenspace sigma))
    (bm : Basis (Fin (q + 1)) k (R.minusEigenspace sigma)) :
    Basis (Fin ((p + q + 1) + 1)) k V :=
  ((bp.prod bm).map (plusMinusLinearEquiv R sigma hσ).symm).reindex
    (plusMinusFinEquiv p q)

/-- Nondegeneracy of the involution supplies projective bases for both
eigenspaces. -/
public theorem exists_plus_minus_projective_bases [CharZero k]
    (R : FaithfulLinearRep k G V) (sigma : G)
    (hσ : IsInvolution sigma)
    (hnd : ¬ R.DegeneratesToPlusMinusId sigma) :
    ∃ (p q : ℕ),
      Nonempty (Basis (Fin (p + 1)) k (R.plusEigenspace sigma)) ∧
      Nonempty (Basis (Fin (q + 1)) k (R.minusEigenspace sigma)) := by
  letI : FiniteDimensional k V := R.finiteDimensional
  have hne := R.both_eigenspaces_nontrivial hσ hnd
  let Sp := R.plusEigenspace sigma
  let Sm := R.minusEigenspace sigma
  letI : Nontrivial Sp := Submodule.nontrivial_iff_ne_bot.mpr hne.1
  letI : Nontrivial Sm := Submodule.nontrivial_iff_ne_bot.mpr hne.2
  let p := finrank k Sp - 1
  let q := finrank k Sm - 1
  have hp : p + 1 = finrank k Sp := Nat.sub_add_cancel Module.finrank_pos
  have hq : q + 1 = finrank k Sm := Nat.sub_add_cancel Module.finrank_pos
  refine ⟨p, q, ⟨(Module.finBasis k Sp).reindex
      (Equiv.cast (congrArg Fin hp.symm))⟩,
    ⟨(Module.finBasis k Sm).reindex
      (Equiv.cast (congrArg Fin hq.symm))⟩⟩

/-- The same nondegeneracy hypothesis also supplies homogeneous coordinates
for the full source projective space. -/
public theorem exists_ambient_projective_basis [CharZero k]
    (R : FaithfulLinearRep k G V) (sigma : G)
    (hσ : IsInvolution sigma)
    (hnd : ¬ R.DegeneratesToPlusMinusId sigma) :
    ∃ d : ℕ, Nonempty (Basis (Fin (d + 1)) k V) := by
  letI : FiniteDimensional k V := R.finiteDimensional
  have hne := R.both_eigenspaces_nontrivial hσ hnd
  obtain ⟨x, _hxmem, hx⟩ :=
    Submodule.exists_mem_ne_zero_of_ne_bot hne.1
  letI : Nontrivial V := ⟨⟨x, 0, by simpa [ne_eq] using hx⟩⟩
  let d := finrank k V - 1
  have hd : d + 1 = finrank k V :=
    Nat.sub_add_cancel Module.finrank_pos
  exact ⟨d, ⟨(Module.finBasis k V).reindex
    (Equiv.cast (congrArg Fin hd.symm))⟩⟩

end SchemeGeometry
end V14Formalization
