module

public import V14Formalization.D12GeneratorSRow0Nonzero
public import V14Formalization.D12ProjectorReduction

noncomputable section

open Matrix Module

namespace V14Formalization.D12RestrictedProjector

open D12PolynomialData D12PolynomialEvaluation
open D12GeneratorPolynomialCore D12GeneratorInvariance
open D12GeneratorT2Relations

def eigenResidue : Fin 10 → ZMod 11 := fun i => eigenExponent i

theorem eigenResidue_injective : Function.Injective eigenResidue := by
  decide

theorem psi_injective : Function.Injective WeilRep.ψ := by
  rw [AddChar.injective_iff]
  intro a ha
  exact (AddChar.IsPrimitive.zmod_char_eq_one_iff
    11 WeilRep.ψ_primitive a).mp ha

theorem pow_eigen_eq_psi (i : Fin 10) :
    WeilRep.ζ ^ eigenExponent i = WeilRep.ψ (eigenResidue i) := by
  rw [WeilRep.ψ_apply]
  change WeilRep.ζ ^ eigenExponent i =
    WeilRep.ζ ^ (eigenExponent i % 11)
  exact pow_eq_pow_mod _ WeilRep.ζ_pow_eleven

public theorem eigenPower_injective :
    Function.Injective (fun i : Fin 10 =>
      WeilRep.ζ ^ eigenExponent i) := by
  intro i j hij
  apply eigenResidue_injective
  apply psi_injective
  simpa only [← pow_eigen_eq_psi] using hij

theorem offDiagonal_eq_zero_of_commutes_diagonal
    {K d : Type*} [Field K] [Fintype d] [DecidableEq d]
    (e : d → K) (he : Function.Injective e)
    (A : Matrix d d K) (hA : A * Matrix.diagonal e = Matrix.diagonal e * A)
    {i j : d} (hij : i ≠ j) : A i j = 0 := by
  have hijEntry := congrArg (fun M : Matrix d d K => M i j) hA
  rw [Matrix.mul_diagonal, Matrix.diagonal_mul] at hijEntry
  have hne : e j - e i ≠ 0 := sub_ne_zero.mpr (he.ne (Ne.symm hij))
  apply mul_right_cancel₀ hne
  rw [zero_mul]
  calc
    A i j * (e j - e i) = A i j * e j - e i * A i j := by ring
    _ = 0 := sub_eq_zero.mpr hijEntry

public theorem eq_diagonal_const_of_two_commutants
    {K d : Type*} [Field K] [Fintype d] [DecidableEq d]
    (e : d → K) (he : Function.Injective e)
    (S A : Matrix d d K) (r : d)
    (hrow : ∀ j, S r j ≠ 0)
    (hAD : A * Matrix.diagonal e = Matrix.diagonal e * A)
    (hAS : A * S = S * A) :
    A = Matrix.diagonal (fun _ => A r r) := by
  have hdiag : A = Matrix.diagonal (fun i => A i i) := by
    ext i j
    by_cases hij : i = j
    · subst j
      simp
    · rw [Matrix.diagonal_apply_ne _ hij]
      exact offDiagonal_eq_zero_of_commutes_diagonal e he A hAD hij
  have hconst : ∀ j, A r r = A j j := by
    intro j
    have hentry := congrArg (fun M : Matrix d d K => M r j) hAS
    rw [hdiag, Matrix.diagonal_mul, Matrix.mul_diagonal] at hentry
    apply mul_left_cancel₀ (hrow j)
    calc
      S r j * A r r = A r r * S r j := mul_comm _ _
      _ = S r j * A j j := hentry
  rw [hdiag]
  ext i j
  by_cases hij : i = j
  · subst j
    simp only [Matrix.diagonal_apply_eq]
    exact (hconst i).symm
  · simp [Matrix.diagonal_apply_ne _ hij]

public def restrictedProjector : Matrix (Fin 10) (Fin 10) WeilRep.K :=
  evalMatrixK L_poly * V14SchemeModel.projectorMatrix * evalMatrixK B_poly

public theorem projector_mul_B_eq_restrictedProjector :
    V14SchemeModel.projectorMatrix * evalMatrixK B_poly =
      evalMatrixK B_poly * restrictedProjector := by
  obtain ⟨A, hA⟩ := projector_mul_B_eq
  calc
    V14SchemeModel.projectorMatrix * evalMatrixK B_poly =
        evalMatrixK B_poly * A := hA
    _ = evalMatrixK B_poly * (evalMatrixK L_poly * evalMatrixK B_poly) * A := by
      rw [evalMatrixK_left_inverse, Matrix.mul_one]
    _ = evalMatrixK B_poly * evalMatrixK L_poly *
        (evalMatrixK B_poly * A) := by simp only [Matrix.mul_assoc]
    _ = evalMatrixK B_poly * evalMatrixK L_poly *
        (V14SchemeModel.projectorMatrix * evalMatrixK B_poly) := by rw [hA]
    _ = evalMatrixK B_poly * restrictedProjector := by
      simp only [restrictedProjector, Matrix.mul_assoc]

theorem canonical_restriction_commutes
    {K m n : Type*} [CommRing K]
    [Fintype m] [DecidableEq m] [Fintype n] [DecidableEq n]
    (P R : Matrix m m K) (B : Matrix m n K) (L : Matrix n m K)
    (A : Matrix n n K)
    (hLB : L * B = 1) (hPB : P * B = B * (L * P * B))
    (hPR : P * R = R * P) (hRB : R * B = B * A) :
    (L * P * B) * A = A * (L * P * B) := by
  calc
    (L * P * B) * A = L * P * (B * A) := by simp only [Matrix.mul_assoc]
    _ = L * P * (R * B) := by rw [hRB]
    _ = L * (P * R) * B := by simp only [Matrix.mul_assoc]
    _ = L * (R * P) * B := by rw [hPR]
    _ = L * R * (P * B) := by simp only [Matrix.mul_assoc]
    _ = L * R * (B * (L * P * B)) := by rw [hPB]
    _ = L * (R * B) * (L * P * B) := by simp only [Matrix.mul_assoc]
    _ = L * (B * A) * (L * P * B) := by rw [hRB]
    _ = (L * B) * A * (L * P * B) := by simp only [Matrix.mul_assoc]
    _ = A * (L * P * B) := by rw [hLB, Matrix.one_mul]

theorem restrictedProjector_commutes_S :
    restrictedProjector * SrestrictedAction =
      SrestrictedAction * restrictedProjector := by
  exact canonical_restriction_commutes
    V14SchemeModel.projectorMatrix
    (Lambda2Coordinates.lambda2MatrixRepresentation.ρ
      (QuotientGroup.mk PSLCard.Smat) : Matrix (Fin 15) (Fin 15) WeilRep.K)
    (evalMatrixK B_poly) (evalMatrixK L_poly) SrestrictedAction
    evalMatrixK_left_inverse projector_mul_B_eq_restrictedProjector
    (V14SchemeModel.projectorMatrix_commutes _) actualS_mul_B_eq

theorem restrictedProjector_commutes_T2 :
    restrictedProjector * T2restrictedAction =
      T2restrictedAction * restrictedProjector := by
  exact canonical_restriction_commutes
    V14SchemeModel.projectorMatrix
    (Lambda2Coordinates.lambda2MatrixRepresentation.ρ
      (QuotientGroup.mk (PSLCard.Tmat ^ 2)) :
        Matrix (Fin 15) (Fin 15) WeilRep.K)
    (evalMatrixK B_poly) (evalMatrixK L_poly) T2restrictedAction
    evalMatrixK_left_inverse projector_mul_B_eq_restrictedProjector
    (V14SchemeModel.projectorMatrix_commutes _) actualT2_mul_B_eq

theorem restrictedProjector_eq_diagonal_const :
    restrictedProjector =
      Matrix.diagonal (fun _ => restrictedProjector 0 0) := by
  apply eq_diagonal_const_of_two_commutants
    (fun i : Fin 10 => WeilRep.ζ ^ eigenExponent i)
    eigenPower_injective SrestrictedAction restrictedProjector 0
  · exact D12GeneratorSRow0Nonzero.SrestrictedAction_row0_ne_zero
  · rw [← T2restrictedAction_eq_diagonal]
    exact restrictedProjector_commutes_T2
  · exact restrictedProjector_commutes_S

theorem restrictedProjector_idempotent :
    restrictedProjector * restrictedProjector = restrictedProjector := by
  calc
    restrictedProjector * restrictedProjector =
        evalMatrixK L_poly *
          (V14SchemeModel.projectorMatrix * evalMatrixK B_poly) *
            restrictedProjector := by
      simp only [restrictedProjector, Matrix.mul_assoc]
    _ = evalMatrixK L_poly * V14SchemeModel.projectorMatrix *
          (evalMatrixK B_poly * restrictedProjector) := by
      simp only [Matrix.mul_assoc]
    _ = evalMatrixK L_poly * V14SchemeModel.projectorMatrix *
          (V14SchemeModel.projectorMatrix * evalMatrixK B_poly) := by
      rw [← projector_mul_B_eq_restrictedProjector]
    _ = evalMatrixK L_poly *
          (V14SchemeModel.projectorMatrix * V14SchemeModel.projectorMatrix) *
            evalMatrixK B_poly := by simp only [Matrix.mul_assoc]
    _ = restrictedProjector := by
      rw [V14SchemeModel.projectorMatrix_idempotent]
      rfl

theorem restrictedProjector_scalar_idempotent :
    restrictedProjector 0 0 * restrictedProjector 0 0 =
      restrictedProjector 0 0 := by
  have hentry := congrArg
    (fun M : Matrix (Fin 10) (Fin 10) WeilRep.K => M 0 0)
    restrictedProjector_idempotent
  rw [restrictedProjector_eq_diagonal_const,
    Matrix.diagonal_mul] at hentry
  exact hentry

theorem restrictedProjector_scalar_eq_zero_or_one :
    restrictedProjector 0 0 = 0 ∨ restrictedProjector 0 0 = 1 := by
  have hmul : restrictedProjector 0 0 *
      (restrictedProjector 0 0 - 1) = 0 := by
    rw [mul_sub, mul_one, restrictedProjector_scalar_idempotent, sub_self]
  rcases mul_eq_zero.mp hmul with hzero | hone
  · exact Or.inl hzero
  · exact Or.inr (sub_eq_zero.mp hone)

theorem restrictedProjector_ne_zero : restrictedProjector ≠ 0 := by
  intro hzero
  have hPBzero : V14SchemeModel.projectorMatrix * evalMatrixK B_poly = 0 := by
    rw [projector_mul_B_eq_restrictedProjector, hzero, Matrix.mul_zero]
  let b : (Fin 10 → WeilRep.K) →ₗ[WeilRep.K] (Fin 15 → WeilRep.K) :=
    (evalMatrixK B_poly).toLin'
  let p : (Fin 15 → WeilRep.K) →ₗ[WeilRep.K] (Fin 15 → WeilRep.K) :=
    V14SchemeModel.projectorMatrix.toLin'
  have hpcomp : p.comp p = p := by
    rw [← Matrix.toLin'_mul, V14SchemeModel.projectorMatrix_idempotent]
  have hpProj : LinearMap.IsProj (LinearMap.range p) p :=
    { map_mem := fun x => LinearMap.mem_range_self p x
      map_id := by
        rintro _ ⟨x, rfl⟩
        exact LinearMap.congr_fun hpcomp x }
  have hrangePCast :
      (Module.finrank WeilRep.K (LinearMap.range p) : WeilRep.K) = 10 := by
    rw [← hpProj.trace]
    simpa [p] using D12ProjectorReduction.projectorMatrix_trace
  have hrangeP : Module.finrank WeilRep.K (LinearMap.range p) = 10 :=
    Nat.cast_injective hrangePCast
  have hrankNull := p.finrank_range_add_finrank_ker
  have hkerP : Module.finrank WeilRep.K (LinearMap.ker p) = 5 := by
    have hambient : Module.finrank WeilRep.K (Fin 15 → WeilRep.K) = 15 := by
      simp
    omega
  have hb_inj : Function.Injective b := by
    intro x y hxy
    have h := congrArg (evalMatrixK L_poly).toLin' hxy
    simpa [b, ← Matrix.toLin'_mul, evalMatrixK_left_inverse] using h
  have hrangeB : Module.finrank WeilRep.K (LinearMap.range b) = 10 := by
    rw [LinearMap.finrank_range_of_inj hb_inj]
    simp
  have hle : LinearMap.range b ≤ LinearMap.ker p := by
    rintro _ ⟨x, rfl⟩
    change V14SchemeModel.projectorMatrix.mulVec
      ((evalMatrixK B_poly).mulVec x) = 0
    calc
      V14SchemeModel.projectorMatrix.mulVec
          ((evalMatrixK B_poly).mulVec x) =
        (V14SchemeModel.projectorMatrix * evalMatrixK B_poly).mulVec x :=
          Matrix.mulVec_mulVec x _ _
      _ = 0 := by rw [hPBzero, Matrix.zero_mulVec]
  have hmono := Submodule.finrank_mono hle
  omega

theorem restrictedProjector_scalar_eq_one : restrictedProjector 0 0 = 1 := by
  rcases restrictedProjector_scalar_eq_zero_or_one with hzero | hone
  · exfalso
    apply restrictedProjector_ne_zero
    rw [restrictedProjector_eq_diagonal_const, hzero]
    ext i j
    simp
  · exact hone

public theorem restrictedProjector_eq_one : restrictedProjector = 1 := by
  rw [restrictedProjector_eq_diagonal_const,
    restrictedProjector_scalar_eq_one]
  ext i j
  simp [Matrix.one_apply]

public theorem projector_factor :
    evalMatrixK B_poly * evalMatrixK L_poly *
        V14SchemeModel.projectorMatrix =
      V14SchemeModel.projectorMatrix := by
  have hPBfix : V14SchemeModel.projectorMatrix * evalMatrixK B_poly =
      evalMatrixK B_poly := by
    rw [projector_mul_B_eq_restrictedProjector,
      restrictedProjector_eq_one, Matrix.mul_one]
  let b : (Fin 10 → WeilRep.K) →ₗ[WeilRep.K] (Fin 15 → WeilRep.K) :=
    (evalMatrixK B_poly).toLin'
  let p : (Fin 15 → WeilRep.K) →ₗ[WeilRep.K] (Fin 15 → WeilRep.K) :=
    V14SchemeModel.projectorMatrix.toLin'
  have hpcomp : p.comp p = p := by
    rw [← Matrix.toLin'_mul, V14SchemeModel.projectorMatrix_idempotent]
  have hpProj : LinearMap.IsProj (LinearMap.range p) p :=
    { map_mem := fun x => LinearMap.mem_range_self p x
      map_id := by
        rintro _ ⟨x, rfl⟩
        exact LinearMap.congr_fun hpcomp x }
  have hrangePCast :
      (Module.finrank WeilRep.K (LinearMap.range p) : WeilRep.K) = 10 := by
    rw [← hpProj.trace]
    simpa [p] using D12ProjectorReduction.projectorMatrix_trace
  have hrangeP : Module.finrank WeilRep.K (LinearMap.range p) = 10 :=
    Nat.cast_injective hrangePCast
  have hb_inj : Function.Injective b := by
    intro x y hxy
    have h := congrArg (evalMatrixK L_poly).toLin' hxy
    simpa [b, ← Matrix.toLin'_mul, evalMatrixK_left_inverse] using h
  have hrangeB : Module.finrank WeilRep.K (LinearMap.range b) = 10 := by
    rw [LinearMap.finrank_range_of_inj hb_inj]
    simp
  have hle : LinearMap.range b ≤ LinearMap.range p := by
    rintro _ ⟨x, rfl⟩
    refine ⟨b x, ?_⟩
    dsimp [p, b]
    change V14SchemeModel.projectorMatrix.mulVec
      ((evalMatrixK B_poly).mulVec x) = (evalMatrixK B_poly).mulVec x
    calc
      V14SchemeModel.projectorMatrix.mulVec
          ((evalMatrixK B_poly).mulVec x) =
        (V14SchemeModel.projectorMatrix * evalMatrixK B_poly).mulVec x :=
          Matrix.mulVec_mulVec x _ _
      _ = (evalMatrixK B_poly).mulVec x := by rw [hPBfix]
  have heq : LinearMap.range b = LinearMap.range p := by
    apply Submodule.eq_of_le_of_finrank_eq hle
    rw [hrangeB, hrangeP]
  apply Matrix.toLin'.injective
  rw [Matrix.toLin'_mul, Matrix.toLin'_mul]
  apply LinearMap.ext
  intro x
  change (evalMatrixK B_poly).mulVec
      ((evalMatrixK L_poly).mulVec
        (V14SchemeModel.projectorMatrix.mulVec x)) =
    V14SchemeModel.projectorMatrix.mulVec x
  have hmem : p x ∈ LinearMap.range b := by
    rw [heq]
    exact LinearMap.mem_range_self p x
  obtain ⟨y, hy⟩ := hmem
  change (evalMatrixK B_poly).mulVec y =
    V14SchemeModel.projectorMatrix.mulVec x at hy
  rw [← hy]
  have hLy : (evalMatrixK L_poly).mulVec
      ((evalMatrixK B_poly).mulVec y) = y := by
    calc
      (evalMatrixK L_poly).mulVec ((evalMatrixK B_poly).mulVec y) =
        (evalMatrixK L_poly * evalMatrixK B_poly).mulVec y :=
          Matrix.mulVec_mulVec y _ _
      _ = y := by rw [evalMatrixK_left_inverse, Matrix.one_mulVec]
  rw [hLy]

end V14Formalization.D12RestrictedProjector
