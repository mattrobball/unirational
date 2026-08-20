/-
Copyright (c) 2026 V14Formalization contributors.
Released under Apache 2.0 license.
-/
module

public import V14Formalization.V14SchemeModel
public import V14Formalization.Ord11CharacterSum
public import V14Formalization.PSLGenerators
public import Mathlib.LinearAlgebra.Trace
public import Mathlib.LinearAlgebra.FixedSubmodule
public import Mathlib.LinearAlgebra.Dimension.Finrank
public import Mathlib.Algebra.Module.Submodule.Pointwise

/-!
# A structural reduction for the D12 projector factor

The finite D12 certificate only needs `B * L * P = P`.  For the genuine
character projector, it is enough to prove that the ten-dimensional image of
`B` is invariant and that the induced projector has trace ten.  The arguments
below turn those two bounded representation-theoretic obligations into the
required factorization; no matrix-entry expansion of the character sum occurs.
-/

noncomputable section

open Matrix Module MulAction
open scoped Pointwise

namespace V14Formalization
namespace D12ProjectorReduction

variable {K : Type*} [Field K]

/-- A matrix relation `gB = BA` says exactly that the column space of `B` is
stabilized by the linear equivalence represented by `g`.  Equality, rather
than merely inclusion, follows from preservation of finite dimension. -/
public theorem mem_stabilizer_range_of_mul_eq
    {m n : Type*} [Fintype m] [DecidableEq m]
    [Fintype n] [DecidableEq n]
    (g : GL m K) (B : Matrix m n K) (A : Matrix n n K)
    (h : (g : Matrix m m K) * B = B * A) :
    (Matrix.GeneralLinearGroup.toLin g).toLinearEquiv ∈
      stabilizer ((m → K) ≃ₗ[K] (m → K))
        (LinearMap.range B.toLin') := by
  rw [Submodule.mem_stabilizer_submodule_iff_map_eq]
  let e : (m → K) ≃ₗ[K] (m → K) :=
    (Matrix.GeneralLinearGroup.toLin g).toLinearEquiv
  have hmap : Submodule.map e.toLinearMap (LinearMap.range B.toLin') ≤
      LinearMap.range B.toLin' := by
    rintro y ⟨x, ⟨v, rfl⟩, rfl⟩
    refine ⟨A.mulVec v, ?_⟩
    dsimp [e]
    change B.mulVec (A.mulVec v) =
      (g : Matrix m m K).mulVec (B.mulVec v)
    rw [Matrix.mulVec_mulVec, ← h, Matrix.mulVec_mulVec]
  apply Submodule.eq_of_le_of_finrank_eq hmap
  exact e.finrank_map_eq (LinearMap.range B.toLin')

noncomputable def matrixRepresentationLinearEquiv
    {m G : Type*} [Fintype m] [DecidableEq m] [Group G]
    (R : G →* GL m K) : G →* ((m → K) ≃ₗ[K] (m → K)) :=
  (LinearMap.GeneralLinearGroup.generalLinearEquiv K (m → K)).toMonoidHom.comp
    ((Matrix.GeneralLinearGroup.toLin :
      GL m K ≃* LinearMap.GeneralLinearGroup K (m → K)).toMonoidHom.comp R)

/-- If two elements generate the group, two bounded restriction identities
imply invariance of the column space under the entire representation. -/
public theorem all_mul_eq_of_two_generators
    {m n G : Type*} [Fintype m] [DecidableEq m]
    [Fintype n] [DecidableEq n] [Group G]
    (R : G →* GL m K) (s t : G)
    (hgen : Subgroup.closure ({s, t} : Set G) = ⊤)
    (B : Matrix m n K) (L : Matrix n m K)
    (hLB : L * B = 1)
    (As At : Matrix n n K)
    (hS : (R s : Matrix m m K) * B = B * As)
    (hT : (R t : Matrix m m K) * B = B * At) :
    ∀ g : G, ∃ A : Matrix n n K, (R g : Matrix m m K) * B = B * A := by
  let W : Submodule K (m → K) := LinearMap.range B.toLin'
  let Rlin : G →* ((m → K) ≃ₗ[K] (m → K)) :=
    matrixRepresentationLinearEquiv R
  let H : Subgroup G := (stabilizer ((m → K) ≃ₗ[K] (m → K)) W).comap Rlin
  have hsH : s ∈ H := by
    change Rlin s ∈ stabilizer ((m → K) ≃ₗ[K] (m → K)) W
    change (Matrix.GeneralLinearGroup.toLin (R s)).toLinearEquiv ∈
      stabilizer ((m → K) ≃ₗ[K] (m → K))
        (LinearMap.range B.toLin')
    exact mem_stabilizer_range_of_mul_eq (R s) B As hS
  have htH : t ∈ H := by
    change Rlin t ∈ stabilizer ((m → K) ≃ₗ[K] (m → K)) W
    change (Matrix.GeneralLinearGroup.toLin (R t)).toLinearEquiv ∈
      stabilizer ((m → K) ≃ₗ[K] (m → K))
        (LinearMap.range B.toLin')
    exact mem_stabilizer_range_of_mul_eq (R t) B At hT
  have htop : H = ⊤ := by
    apply top_unique
    rw [← hgen]
    apply (Subgroup.closure_le H).2
    intro g hg
    simp only [Set.mem_insert_iff, Set.mem_singleton_iff] at hg
    rcases hg with (rfl | rfl)
    · exact hsH
    · exact htH
  intro g
  have hgH : g ∈ H := by rw [htop]; exact Subgroup.mem_top g
  have hgstab : Rlin g ∈
      stabilizer ((m → K) ≃ₗ[K] (m → K)) W := hgH
  have hmap : Submodule.map (Rlin g).toLinearMap W = W :=
    Submodule.mem_stabilizer_submodule_iff_map_eq.mp hgstab
  refine ⟨L * (R g : Matrix m m K) * B, ?_⟩
  rw [Matrix.ext_iff_mulVec]
  intro x
  have hmem : (R g : Matrix m m K).mulVec (B.mulVec x) ∈
      LinearMap.range B.toLin' := by
    change (Rlin g) (B.mulVec x) ∈ W
    rw [← hmap]
    exact ⟨B.mulVec x, ⟨x, rfl⟩, rfl⟩
  obtain ⟨y, hy⟩ := hmem
  change ((R g : Matrix m m K) * B).mulVec x =
    (B * (L * (R g : Matrix m m K) * B)).mulVec x
  rw [← Matrix.mulVec_mulVec x (R g : Matrix m m K) B]
  rw [← Matrix.mulVec_mulVec x B (L * (R g : Matrix m m K) * B)]
  rw [← Matrix.mulVec_mulVec x (L * (R g : Matrix m m K)) B]
  rw [← Matrix.mulVec_mulVec (B.mulVec x) L (R g : Matrix m m K)]
  change (R g : Matrix m m K).mulVec (B.mulVec x) =
    B.mulVec (L.mulVec ((R g : Matrix m m K).mulVec (B.mulVec x)))
  rw [← hy]
  change B.mulVec y = B.mulVec (L.mulVec (B.mulVec y))
  have hLy : L.mulVec (B.mulVec y) = y := by
    rw [Matrix.mulVec_mulVec, hLB, Matrix.one_mulVec]
  rw [hLy]

variable [CharZero K]

/-- An idempotent square matrix whose trace is the full dimension is the
identity. -/
public theorem idempotent_eq_one_of_trace_eq_card
    {d : Type*} [Fintype d] [DecidableEq d]
    (A : Matrix d d K) (hA : A * A = A)
    (htr : A.trace = (Fintype.card d : K)) : A = 1 := by
  let f : (d → K) →ₗ[K] (d → K) := A.toLin'
  have hf : f.comp f = f := by
    rw [← Matrix.toLin'_mul, hA]
  have hp : LinearMap.IsProj (LinearMap.range f) f :=
    { map_mem := fun x => LinearMap.mem_range_self f x
      map_id := by
        rintro _ ⟨x, rfl⟩
        exact LinearMap.congr_fun hf x }
  have htrace : LinearMap.trace K (d → K) f = (Fintype.card d : K) := by
    simpa [f] using htr
  have hrangeCast : (Module.finrank K (LinearMap.range f) : K) =
      (Fintype.card d : K) := by
    rw [← hp.trace, htrace]
  have hrange : Module.finrank K (LinearMap.range f) = Fintype.card d :=
    Nat.cast_injective hrangeCast
  have htop : LinearMap.range f = ⊤ := by
    apply Submodule.eq_top_of_finrank_eq
    simpa using hrange
  have hsurj : Function.Surjective f := LinearMap.range_eq_top.mp htop
  apply Matrix.toLin'.injective
  rw [Matrix.toLin'_one]
  apply LinearMap.ext
  intro x
  obtain ⟨y, rfl⟩ := hsurj x
  exact LinearMap.congr_fun hf y

/-- A rank-ten invariant image with restricted projector trace ten is exactly
the image of a rank-ten ambient projector. -/
theorem projector_factor_of_invariant_trace_aux
    (P : Matrix (Fin 15) (Fin 15) K)
    (B : Matrix (Fin 15) (Fin 10) K)
    (L : Matrix (Fin 10) (Fin 15) K)
    (hLB : L * B = 1)
    (hP : P * P = P)
    (hPB : ∃ A : Matrix (Fin 10) (Fin 10) K, P * B = B * A)
    (htr : (L * P * B).trace = 10)
    (hPtr : P.trace = 10) :
    B * L * P = P := by
  let A : Matrix (Fin 10) (Fin 10) K := L * P * B
  obtain ⟨A0, hA0⟩ := hPB
  have hPB' : P * B = B * A := by
    calc
      P * B = B * A0 := hA0
      _ = B * (L * B) * A0 := by rw [hLB, Matrix.mul_one]
      _ = B * L * (B * A0) := by simp only [Matrix.mul_assoc]
      _ = B * L * (P * B) := by rw [hA0]
      _ = B * (L * P * B) := by simp only [Matrix.mul_assoc]
      _ = B * A := rfl
  have hAidem : A * A = A := by
    calc
      A * A = L * (P * B) * A := by simp only [A, Matrix.mul_assoc]
      _ = L * P * (B * A) := by simp only [Matrix.mul_assoc]
      _ = L * P * (P * B) := by rw [← hPB']
      _ = L * (P * P) * B := by simp only [Matrix.mul_assoc]
      _ = A := by rw [hP]
  have hAtr : A.trace = (Fintype.card (Fin 10) : K) := by
    simpa [A] using htr
  have hAone : A = 1 := idempotent_eq_one_of_trace_eq_card A hAidem hAtr
  have hPBfix : P * B = B := by rw [hPB', hAone, Matrix.mul_one]
  let b : (Fin 10 → K) →ₗ[K] (Fin 15 → K) := B.toLin'
  let p : (Fin 15 → K) →ₗ[K] (Fin 15 → K) := P.toLin'
  have hpcomp : p.comp p = p := by
    rw [← Matrix.toLin'_mul, hP]
  have hpProj : LinearMap.IsProj (LinearMap.range p) p :=
    { map_mem := fun x => LinearMap.mem_range_self p x
      map_id := by
        rintro _ ⟨x, rfl⟩
        exact LinearMap.congr_fun hpcomp x }
  have hrangePCast : (Module.finrank K (LinearMap.range p) : K) = 10 := by
    rw [← hpProj.trace]
    simpa [p] using hPtr
  have hrangeP : Module.finrank K (LinearMap.range p) = 10 :=
    Nat.cast_injective hrangePCast
  have hb_inj : Function.Injective b := by
    intro x y hxy
    have := congrArg L.toLin' hxy
    simpa [b, ← Matrix.toLin'_mul, hLB] using this
  have hrangeB : Module.finrank K (LinearMap.range b) = 10 := by
    rw [LinearMap.finrank_range_of_inj hb_inj]
    simp
  have hle : LinearMap.range b ≤ LinearMap.range p := by
    rintro _ ⟨x, rfl⟩
    refine ⟨b x, ?_⟩
    dsimp [p, b]
    change P.mulVec (B.mulVec x) = B.mulVec x
    calc
      P.mulVec (B.mulVec x) = (P * B).mulVec x := Matrix.mulVec_mulVec x P B
      _ = B.mulVec x := by rw [hPBfix]
  have heq : LinearMap.range b = LinearMap.range p := by
    apply Submodule.eq_of_le_of_finrank_eq hle
    rw [hrangeB, hrangeP]
  apply Matrix.toLin'.injective
  rw [Matrix.toLin'_mul, Matrix.toLin'_mul]
  apply LinearMap.ext
  intro x
  change B.mulVec (L.mulVec (P.mulVec x)) = P.mulVec x
  have hmem : p x ∈ LinearMap.range b := by
    rw [heq]
    exact LinearMap.mem_range_self p x
  obtain ⟨y, hy⟩ := hmem
  change B.mulVec y = P.mulVec x at hy
  rw [← hy]
  have hLy : L.mulVec (B.mulVec y) = y := by
    calc
      L.mulVec (B.mulVec y) = (L * B).mulVec y := Matrix.mulVec_mulVec y L B
      _ = y := by rw [hLB, Matrix.one_mulVec]
  rw [hLy]

open GeometricV14Carrier Lambda2Coordinates V14SchemeModel

/-- Coordinate form of the character-average definition of the genuine
projector.  This equality is structural: it is functoriality of `toMatrix`
for sums and scalar multiples. -/
public theorem projectorMatrix_eq_character_sum :
    V14SchemeModel.projectorMatrix =
      (10 * (660 : V14SchemeModel.k)⁻¹) •
        ∑ g : V14SchemeModel.G,
          GeometricV14Carrier.chi10' g •
            (Lambda2Coordinates.lambda2MatrixRepresentation.ρ g :
              Matrix (Fin 15) (Fin 15) V14SchemeModel.k) := by
  unfold V14SchemeModel.projectorMatrix GeometricV14Carrier.projectorM
    WeilLambda2.projectorM
  simp only [map_smul, map_sum]
  rfl

/-- Invariance under every group matrix implies invariance under their
character-weighted projector. -/
public theorem projector_invariant_of_all_representation
    (B : Matrix (Fin 15) (Fin 10) V14SchemeModel.k)
    (hAll : ∀ g : V14SchemeModel.G,
      ∃ A : Matrix (Fin 10) (Fin 10) V14SchemeModel.k,
        (Lambda2Coordinates.lambda2MatrixRepresentation.ρ g :
          Matrix (Fin 15) (Fin 15) V14SchemeModel.k) * B = B * A) :
    ∃ A : Matrix (Fin 10) (Fin 10) V14SchemeModel.k,
      V14SchemeModel.projectorMatrix * B = B * A := by
  classical
  choose A hA using hAll
  refine ⟨(10 * (660 : V14SchemeModel.k)⁻¹) •
    ∑ g : V14SchemeModel.G, GeometricV14Carrier.chi10' g • A g, ?_⟩
  rw [projectorMatrix_eq_character_sum, Matrix.smul_mul]
  have hsum :
      (∑ g : V14SchemeModel.G,
          GeometricV14Carrier.chi10' g •
            (Lambda2Coordinates.lambda2MatrixRepresentation.ρ g :
              Matrix (Fin 15) (Fin 15) V14SchemeModel.k)) * B =
        ∑ g : V14SchemeModel.G,
          (GeometricV14Carrier.chi10' g •
            (Lambda2Coordinates.lambda2MatrixRepresentation.ρ g :
              Matrix (Fin 15) (Fin 15) V14SchemeModel.k)) * B := by
    exact Matrix.sum_mul Finset.univ _ B
  rw [hsum]
  simp_rw [Matrix.smul_mul, hA, Matrix.mul_smul]
  have hmul :
      B * (∑ g : V14SchemeModel.G,
          GeometricV14Carrier.chi10' g • A g) =
        ∑ g : V14SchemeModel.G,
          B * (GeometricV14Carrier.chi10' g • A g) := by
    exact Matrix.mul_sum Finset.univ _ B
  rw [hmul]
  simp_rw [Matrix.mul_smul]

/-- Consequently, only the two standard generator restriction identities are
needed to prove invariance under the genuine character projector. -/
public theorem projector_invariant_of_standard_generators
    (B : Matrix (Fin 15) (Fin 10) V14SchemeModel.k)
    (L : Matrix (Fin 10) (Fin 15) V14SchemeModel.k)
    (hLB : L * B = 1)
    (As At : Matrix (Fin 10) (Fin 10) V14SchemeModel.k)
    (hS : (Lambda2Coordinates.lambda2MatrixRepresentation.ρ
        (QuotientGroup.mk PSLCard.Smat) :
          Matrix (Fin 15) (Fin 15) V14SchemeModel.k) * B = B * As)
    (hT : (Lambda2Coordinates.lambda2MatrixRepresentation.ρ
        (QuotientGroup.mk PSLCard.Tmat) :
          Matrix (Fin 15) (Fin 15) V14SchemeModel.k) * B = B * At) :
    ∃ A : Matrix (Fin 10) (Fin 10) V14SchemeModel.k,
      V14SchemeModel.projectorMatrix * B = B * A := by
  apply projector_invariant_of_all_representation B
  exact all_mul_eq_of_two_generators
    Lambda2Coordinates.lambda2MatrixRepresentation.ρ
    (QuotientGroup.mk PSLCard.Smat) (QuotientGroup.mk PSLCard.Tmat)
    PSLGenerators.closure_mk_Smat_Tmat B L hLB As At hS hT

/-- Version matching the exporter/Weil convention: `S₆` represents the PSL
class of `Smat`, and `T₆` represents the PSL class of `Tmat²`.  Thus the
generated restriction certificates can be used directly, without extracting a
matrix square root or expanding the full projector. -/
public theorem projector_invariant_of_standard_generators_pow_two
    (B : Matrix (Fin 15) (Fin 10) V14SchemeModel.k)
    (L : Matrix (Fin 10) (Fin 15) V14SchemeModel.k)
    (hLB : L * B = 1)
    (As At2 : Matrix (Fin 10) (Fin 10) V14SchemeModel.k)
    (hS : (Lambda2Coordinates.lambda2MatrixRepresentation.ρ
        (QuotientGroup.mk PSLCard.Smat) :
          Matrix (Fin 15) (Fin 15) V14SchemeModel.k) * B = B * As)
    (hT2 : (Lambda2Coordinates.lambda2MatrixRepresentation.ρ
        (QuotientGroup.mk (PSLCard.Tmat ^ 2)) :
          Matrix (Fin 15) (Fin 15) V14SchemeModel.k) * B = B * At2) :
    ∃ A : Matrix (Fin 10) (Fin 10) V14SchemeModel.k,
      V14SchemeModel.projectorMatrix * B = B * A := by
  apply projector_invariant_of_all_representation B
  exact all_mul_eq_of_two_generators
    Lambda2Coordinates.lambda2MatrixRepresentation.ρ
    (QuotientGroup.mk PSLCard.Smat)
    (QuotientGroup.mk (PSLCard.Tmat ^ 2))
    PSLGenerators.closure_mk_Smat_Tmat_pow_two
    B L hLB As At2 hS hT2

/-- The genuine coordinate character projector has trace ten. -/
public theorem projectorMatrix_trace :
    Matrix.trace V14SchemeModel.projectorMatrix = (10 : V14SchemeModel.k) := by
  unfold V14SchemeModel.projectorMatrix
  rw [← LinearMap.trace_eq_matrix_trace V14SchemeModel.k
    Lambda2Coordinates.lambda2Basis GeometricV14Carrier.projectorM]
  rw [GeometricV14Carrier.projectorM_trace_eq_finrank,
    Ord11CharacterSum.finrank_Msub_eq_ten]
  norm_num

/-- For the genuine V14 projector, only invariance of the emitted ten-space
and the trace of its restricted projector remain. -/
public theorem projector_factor_of_invariant_trace
    (B : Matrix (Fin 15) (Fin 10) V14SchemeModel.k)
    (L : Matrix (Fin 10) (Fin 15) V14SchemeModel.k)
    (hLB : L * B = 1)
    (hPB : ∃ A : Matrix (Fin 10) (Fin 10) V14SchemeModel.k,
      V14SchemeModel.projectorMatrix * B = B * A)
    (htr : (L * V14SchemeModel.projectorMatrix * B).trace = 10) :
    B * L * V14SchemeModel.projectorMatrix =
      V14SchemeModel.projectorMatrix :=
  projector_factor_of_invariant_trace_aux
    V14SchemeModel.projectorMatrix B L hLB
    V14SchemeModel.projectorMatrix_idempotent hPB htr projectorMatrix_trace

end D12ProjectorReduction
end V14Formalization
