/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import BConicBundleMultisections.Standard.TangentResidualAvoidance
public import BConicBundleMultisections.ResidualDiscriminantAvoidance
public import BConicBundleMultisections.ResidualEquationLine
public import BConicBundleMultisections.GenericCubicNondegeneracy
public import Mathlib.FieldTheory.IsAlgClosed.AlgebraicClosure
public import Mathlib.LinearAlgebra.Dimension.RankNullity
public import Mathlib.RingTheory.Nullstellensatz

/-!
# The G3--G4 line-selection interface

This module connects tangent-residual surjectivity to the degree-nine discriminant and isolates the
remaining descent step in line selection.

There are three algebraic layers.

1. If a homogeneous target `H` is not in the radical of the principal ideal of a cubic `g`, the
   affine Nullstellensatz produces a nonzero projective point of `g` outside `H`.  Tangent-residual
   surjectivity then produces a tangent line with residual point outside `H`.
2. A linearly independent tangent pair can be completed to a framed projective line with an
   explicit matrix inverse.  Specializing `H` to `sndConicDiscriminant F` gives the direct G4
   witness expected by the geometric argument.
3. Once determinant, G3, and G4 have been represented by nonzero univariate certificates along a
   one-parameter family, their open conditions meet over an infinite field.  The final theorems
   prove this polynomial interpolation step without hiding the still-missing construction of
   those certificates.

Thus the family-specific open boundary is precise: for the generic smooth cubic one must prove
that the mapped conic discriminant is not in the radical of its principal ideal, and then express
the framed-line witnesses along a polynomial one-parameter family.  No elliptic-curve
surjectivity, Nullstellensatz, frame completion, or finite-open-intersection argument remains past
that interface.
-/

@[expose] public section

open scoped Matrix

namespace BConicBundleMultisections.Standard

noncomputable section

universe u

open _root_.MvPolynomial

/-! ## Pointwise properness from principal-radical noncontainment -/

/-! ### Coefficient base change for the G4 target -/

/-- Formation of the second-conic discriminant commutes with an arbitrary coefficient map. -/
theorem map_sndConicDiscriminant
    {R S : Type u} [CommRing R] [CommRing S]
    (f : R →+* S) (F : MvPolynomial (BiprojectiveCoordinate 2 2) R) :
    map f (sndConicDiscriminant F) = sndConicDiscriminant (map f F) := by
  have huniversal :
      map (map f) (universalSndConic F) = universalSndConic (map f F) := by
    rw [universalSndConic, universalSndConic,
      map_specializeSecondCoordinates, MvPolynomial.map_map]
    have hcoeff :
        (map f).comp (C : R →+* MvPolynomial (Fin 3) R) =
          (C : S →+* MvPolynomial (Fin 3) S).comp f := by
      ext a
      simp
    rw [hcoeff]
    congr 1
    · ext z
      rcases z with i | j <;> simp
    · simp only [MvPolynomial.map_map]
  rw [sndConicDiscriminant, sndConicDiscriminant, RingHom.map_det]
  congr 1
  change (polarMatrix (universalSndConic F)).map (map f) = _
  rw [← polarMatrix_map, huniversal]

/-! ### The actual generic-fibre interface -/

/-- The algebraic closure of the rational function field of a standard first-projective chart. -/
abbrev FstGenericAlgebraicClosure (k : Type u) [Field k] :=
  AlgebraicClosure (MvPolynomialFractionRing.FstFunctionField (k := k))

/-- The generic first-projection cubic, base changed to an algebraically closed field. -/
def genericFstCubicOverClosure
    {k : Type u} [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (i : Fin 3) :
    MvPolynomial (Fin 3) (FstGenericAlgebraicClosure k) :=
  map (algebraMap
      (MvPolynomialFractionRing.FstFunctionField (k := k))
      (FstGenericAlgebraicClosure k))
    (MvPolynomialFractionRing.genericFstCubic F i)

/-- The global G4 target, base changed to the same algebraic closure as the generic cubic. -/
def sndConicDiscriminantOverGenericClosure
    {k : Type u} [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) :
    MvPolynomial (Fin 3) (FstGenericAlgebraicClosure k) :=
  map (algebraMap k (FstGenericAlgebraicClosure k)) (sndConicDiscriminant F)

/-- The precise pointwise G4 input on the generic first-projection cubic.  This is the remaining
family-specific factor-descent assertion: the degree-nine target must not lie in the radical of
the generic cubic's principal ideal after passing to an algebraic closure. -/
def GenericFstG4RadicalNoncontainment
    {k : Type u} [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (i : Fin 3) : Prop :=
  sndConicDiscriminantOverGenericClosure F ∉
    (Ideal.span ({genericFstCubicOverClosure F i} :
      Set (MvPolynomial (Fin 3) (FstGenericAlgebraicClosure k)))).radical

/-- Divisibility form of the generic G4 interface.  It makes the remaining factor-descent task
explicit: no power of the constant degree-nine target may acquire the generic cubic as a factor. -/
theorem genericFstG4RadicalNoncontainment_iff_forall_not_dvd_pow
    {k : Type u} [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (i : Fin 3) :
    GenericFstG4RadicalNoncontainment F i ↔
      ∀ n : ℕ, ¬ genericFstCubicOverClosure F i ∣
        sndConicDiscriminantOverGenericClosure F ^ n := by
  constructor
  · intro hproper n hdiv
    apply hproper
    exact ⟨n, Ideal.mem_span_singleton.mpr hdiv⟩
  · intro hpow hrad
    obtain ⟨n, hn⟩ := hrad
    exact hpow n (Ideal.mem_span_singleton.mp hn)

/-- If the generic cubic ideal is prime, it is enough to rule out divisibility of the target
itself; no separate argument for all powers is needed. -/
theorem genericFstG4RadicalNoncontainment_of_prime_of_not_dvd
    {k : Type u} [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (i : Fin 3)
    (hprime : (Ideal.span ({genericFstCubicOverClosure F i} :
      Set (MvPolynomial (Fin 3) (FstGenericAlgebraicClosure k)))).IsPrime)
    (hnodiv : ¬ genericFstCubicOverClosure F i ∣
      sndConicDiscriminantOverGenericClosure F) :
    GenericFstG4RadicalNoncontainment F i := by
  rw [GenericFstG4RadicalNoncontainment, hprime.radical]
  intro hmem
  exact hnodiv (Ideal.mem_span_singleton.mp hmem)

/-- The base-changed G4 target remains homogeneous of degree nine. -/
theorem sndConicDiscriminantOverGenericClosure_isHomogeneous
    {k : Type u} [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F) :
    (sndConicDiscriminantOverGenericClosure F).IsHomogeneous 9 := by
  exact (sndConicDiscriminant_isHomogeneous F hF).map
    (algebraMap k (FstGenericAlgebraicClosure k))

/-- Coefficient base change identifies the generic-closure target with the second-conic
discriminant of the base-changed bidegree-`(2,3)` equation. -/
theorem sndConicDiscriminantOverGenericClosure_eq
    {k : Type u} [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) :
    sndConicDiscriminantOverGenericClosure F =
      sndConicDiscriminant
        (map (algebraMap k (FstGenericAlgebraicClosure k)) F) := by
  exact map_sndConicDiscriminant
    (algebraMap k (FstGenericAlgebraicClosure k)) F

/-- A positive-degree homogeneous target which is not in the radical of `(g)` misses some
nonzero projective point of `g`.

This is the affine Nullstellensatz applied to the cone.  The origin causes no extra hypothesis:
positive homogeneity makes `H` vanish there automatically. -/
theorem exists_projective_point_off_target_of_not_mem_radical
    {K : Type u} [Field K] [IsAlgClosed K]
    (g H : MvPolynomial (Fin 3) K) {d : ℕ}
    (hH : H.IsHomogeneous d) (hd : 0 < d)
    (hnot : H ∉ (Ideal.span ({g} : Set (MvPolynomial (Fin 3) K))).radical) :
    ∃ y : Fin 3 → K, y ≠ 0 ∧ eval y g = 0 ∧ eval y H ≠ 0 := by
  by_contra hex
  apply hnot
  rw [← MvPolynomial.vanishingIdeal_zeroLocus_eq_radical (K := K)]
  rw [MvPolynomial.mem_vanishingIdeal_iff]
  intro y hy
  rw [MvPolynomial.mem_zeroLocus_iff] at hy
  have hyg : eval y g = 0 := hy g (Ideal.subset_span (by simp))
  by_cases hy0 : y = 0
  · subst y
    have hscale := eval_smul_point_of_isHomogeneous hH (0 : K) (0 : Fin 3 → K)
    simpa [zero_pow hd.ne'] using hscale
  · by_contra hyH
    exact hex ⟨y, hy0, hyg, hyH⟩

/-- Divisibility form of principal-radical noncontainment.  This is often the most convenient
generic-fibre interface: it is enough to rule out `g ∣ H^n` for every `n`. -/
theorem exists_projective_point_off_target_of_forall_not_dvd_pow
    {K : Type u} [Field K] [IsAlgClosed K]
    (g H : MvPolynomial (Fin 3) K) {d : ℕ}
    (hH : H.IsHomogeneous d) (hd : 0 < d)
    (hnodiv : ∀ n : ℕ, ¬ g ∣ H ^ n) :
    ∃ y : Fin 3 → K, y ≠ 0 ∧ eval y g = 0 ∧ eval y H ≠ 0 := by
  apply exists_projective_point_off_target_of_not_mem_radical g H hH hd
  intro hrad
  obtain ⟨n, hn⟩ := hrad
  exact hnodiv n (Ideal.mem_span_singleton.mp hn)

/-! ## Completing the tangent line to an invertible frame -/

/-- Two independent vectors in `K³` extend to the columns of an invertible line frame. -/
theorem exists_lineFrame_inverse_of_pair_linearIndependent
    {K : Type u} [Field K] (p q : Fin 3 → K)
    (hpq : LinearIndependent K ![p, q]) :
    ∃ (r : Fin 3 → K) (N : Matrix (Fin 3) (Fin 3) K),
      lineFrame p q r * N = 1 := by
  have hlt : 2 < Module.finrank K (Fin 3 → K) := by simp
  obtain ⟨r, hlin⟩ := exists_linearIndependent_snoc_of_lt_finrank hpq hlt
  let M : Matrix (Fin 3) (Fin 3) K := lineFrame p q r
  have hcols : LinearIndependent K M.col := by
    have hfamily : M.col = Fin.snoc ![p, q] r := by
      funext i j
      fin_cases i <;> rfl
    rw [hfamily]
    exact hlin
  have hunitM : IsUnit M := Matrix.linearIndependent_cols_iff_isUnit.mp hcols
  have hunitDet : IsUnit M.det := M.isUnit_iff_isUnit_det.mp hunitM
  exact ⟨r, M⁻¹, M.mul_nonsing_inv hunitDet⟩

/-! ## Framed tangent avoidance -/

/-- A smooth cubic has a framed tangent line whose residual point avoids every positive-degree
homogeneous target not contained in the cubic in the principal-radical sense. -/
theorem exists_framed_tangentResidual_avoids_target_of_not_mem_radical
    {K : Type u} [Field K] [CharZero K] [IsAlgClosed K]
    (g : MvPolynomial (Fin 3) K) (hsmooth : IsSmoothPlaneCubic g)
    (H : MvPolynomial (Fin 3) K) {d : ℕ}
    (hH : H.IsHomogeneous d) (hd : 0 < d)
    (hnot : H ∉ (Ideal.span ({g} : Set (MvPolynomial (Fin 3) K))).radical) :
    ∃ (p q r : Fin 3 → K) (N : Matrix (Fin 3) (Fin 3) K),
      lineFrame p q r * N = 1 ∧
      p ≠ 0 ∧
      eval p g = 0 ∧
      LinearIndependent K ![p, q] ∧
      q ∈ tangentHyperplaneCone g p ∧
      eval (residualAmbientRep p q (binaryLineRestriction p q g)) H ≠ 0 := by
  have hproper :=
    exists_projective_point_off_target_of_not_mem_radical g H hH hd hnot
  obtain ⟨p, q, hp0, hp, hpq, hq, havoid⟩ :=
    exists_tangentResidualRep_avoids_homogeneous_target_of_isSmoothPlaneCubic
      g hsmooth H hH hproper
  obtain ⟨r, N, hMN⟩ := exists_lineFrame_inverse_of_pair_linearIndependent p q hpq
  exact ⟨p, q, r, N, hMN, hp0, hp, hpq, hq, havoid⟩

/-- **G4 for the actual degree-nine conic discriminant.**

Once the generic cubic is known not to be contained in the constant conic discriminant, there is
a framed tangent line whose residual point lies outside that discriminant. -/
theorem exists_framed_tangentResidual_avoids_sndConicDiscriminant
    {K : Type u} [Field K] [CharZero K] [IsAlgClosed K]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) K) (hF : IsBidegree23 F)
    (g : MvPolynomial (Fin 3) K) (hsmooth : IsSmoothPlaneCubic g)
    (hnot : sndConicDiscriminant F ∉
      (Ideal.span ({g} : Set (MvPolynomial (Fin 3) K))).radical) :
    ∃ (p q r : Fin 3 → K) (N : Matrix (Fin 3) (Fin 3) K),
      lineFrame p q r * N = 1 ∧
      p ≠ 0 ∧
      eval p g = 0 ∧
      LinearIndependent K ![p, q] ∧
      q ∈ tangentHyperplaneCone g p ∧
      eval (residualAmbientRep p q (binaryLineRestriction p q g))
        (sndConicDiscriminant F) ≠ 0 := by
  exact exists_framed_tangentResidual_avoids_target_of_not_mem_radical
    g hsmooth (sndConicDiscriminant F)
      (sndConicDiscriminant_isHomogeneous F hF) (by norm_num) hnot

/-- **The generic-fibre G4 bridge with its exact unresolved input exposed.**

If the generic first-projection cubic is smooth and satisfies
`GenericFstG4RadicalNoncontainment`, tangent-residual surjectivity produces an invertibly framed
tangent whose residual point avoids the actual base-changed conic discriminant.  Thus, after this
theorem, the family-specific pointwise task is exactly the radical-noncontainment hypothesis (and
the separately stated generic smoothness hypothesis); there is no further tangent geometry. -/
theorem exists_genericFst_framed_tangentResidual_avoids_sndConicDiscriminant
    {k : Type u} [Field k] [CharZero k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (i : Fin 3)
    (hsmooth : IsSmoothPlaneCubic (genericFstCubicOverClosure F i))
    (hproper : GenericFstG4RadicalNoncontainment F i) :
    ∃ (p q r : Fin 3 → FstGenericAlgebraicClosure k)
        (N : Matrix (Fin 3) (Fin 3) (FstGenericAlgebraicClosure k)),
      lineFrame p q r * N = 1 ∧
      p ≠ 0 ∧
      eval p (genericFstCubicOverClosure F i) = 0 ∧
      LinearIndependent (FstGenericAlgebraicClosure k) ![p, q] ∧
      q ∈ tangentHyperplaneCone (genericFstCubicOverClosure F i) p ∧
      eval
          (residualAmbientRep p q
            (binaryLineRestriction p q (genericFstCubicOverClosure F i)))
          (sndConicDiscriminantOverGenericClosure F) ≠ 0 := by
  exact exists_framed_tangentResidual_avoids_target_of_not_mem_radical
    (genericFstCubicOverClosure F i) hsmooth
    (sndConicDiscriminantOverGenericClosure F)
    (sndConicDiscriminantOverGenericClosure_isHomogeneous F hF)
    (by norm_num) hproper

/-! ## A finite coefficient witness for G3 -/

/-- A nonzero `2 × 2` coefficient minor forces the residual-line coefficient forms to span a
space of dimension at least two, hence the residual line is nonconstant. -/
theorem residualLineNonconstantOn_of_coeff_minor_ne_zero
    {K : Type u} [Field K]
    (M N : Matrix (Fin 3) (Fin 3) K)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) K)
    (a b : Fin 3) (m n : Fin 3 →₀ ℕ)
    (hminor :
      coeff m (residualLineCoeffOn M N F a) *
          coeff n (residualLineCoeffOn M N F b) -
        coeff n (residualLineCoeffOn M N F a) *
          coeff m (residualLineCoeffOn M N F b) ≠ 0) :
    ResidualLineNonconstantOn M N F := by
  intro hconstant
  obtain ⟨h, c, hc⟩ := hconstant
  apply hminor
  rw [hc a, hc b]
  simp only [coeff_C_mul]
  ring

/-! ## Intersecting finitely many polynomial open conditions -/

/-- A predicate on the affine line has a certified nonempty principal-open subset. -/
def HasPolynomialOpenCertificate
    {K : Type u} [Field K] (P : K → Prop) : Prop :=
  ∃ f : Polynomial K, f ≠ 0 ∧ ∀ t : K, f.eval t ≠ 0 → P t

/-- A polynomial nonzero at one endpoint supplies a nonempty principal-open certificate. -/
theorem hasPolynomialOpenCertificate_of_eval_ne_zero
    {K : Type u} [Field K] {P : K → Prop}
    (f : Polynomial K) (t₀ : K) (hf : f.eval t₀ ≠ 0)
    (hP : ∀ t : K, f.eval t ≠ 0 → P t) :
    HasPolynomialOpenCertificate P := by
  refine ⟨f, ?_, hP⟩
  intro hzero
  apply hf
  rw [hzero, Polynomial.eval_zero]

/-- Three nonzero univariate polynomials are simultaneously nonzero somewhere over an infinite
field. -/
theorem exists_eval_three_polynomials_ne_zero
    {K : Type u} [Field K] [Infinite K]
    (f₁ f₂ f₃ : Polynomial K) (hf₁ : f₁ ≠ 0) (hf₂ : f₂ ≠ 0) (hf₃ : f₃ ≠ 0) :
    ∃ t : K, f₁.eval t ≠ 0 ∧ f₂.eval t ≠ 0 ∧ f₃.eval t ≠ 0 := by
  let f : Polynomial K := f₁ * f₂ * f₃
  have hf : f ≠ 0 := mul_ne_zero (mul_ne_zero hf₁ hf₂) hf₃
  have hcard : f.natDegree < Cardinal.mk K :=
    Cardinal.natCast_lt_aleph0.trans_le (Cardinal.aleph0_le_mk K)
  obtain ⟨t, ht⟩ := f.exists_eval_ne_zero_of_natDegree_lt_card hf hcard
  refine ⟨t, ?_⟩
  simpa only [f, Polynomial.eval_mul, mul_ne_zero_iff, and_assoc] using ht

/-- The intersection of three certified nonempty principal opens is nonempty. -/
theorem exists_of_three_hasPolynomialOpenCertificate
    {K : Type u} [Field K] [Infinite K]
    {P₁ P₂ P₃ : K → Prop}
    (h₁ : HasPolynomialOpenCertificate P₁)
    (h₂ : HasPolynomialOpenCertificate P₂)
    (h₃ : HasPolynomialOpenCertificate P₃) :
    ∃ t : K, P₁ t ∧ P₂ t ∧ P₃ t := by
  obtain ⟨f₁, hf₁, hP₁⟩ := h₁
  obtain ⟨f₂, hf₂, hP₂⟩ := h₂
  obtain ⟨f₃, hf₃, hP₃⟩ := h₃
  obtain ⟨t, ht₁, ht₂, ht₃⟩ :=
    exists_eval_three_polynomials_ne_zero f₁ f₂ f₃ hf₁ hf₂ hf₃
  exact ⟨t, hP₁ t ht₁, hP₂ t ht₂, hP₃ t ht₃⟩

/-! ## Concrete G3--G4 family endpoint -/

/-- A one-parameter family of framed lines and residual charts contains a member satisfying
invertibility, G3, and G4 as soon as each condition has a nonempty polynomial-open certificate.

This is the exact endpoint needed after clearing the inverse-frame denominators in the proposed
interpolation argument. -/
theorem exists_frame_with_G3_G4_of_polynomial_open_certificates
    {K : Type u} [Field K] [Infinite K]
    (p₀ q₀ r : K → Fin 3 → K)
    (N : K → Matrix (Fin 3) (Fin 3) K)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) K)
    (v : K → Fin 3 → Polynomial K)
    (hframe : HasPolynomialOpenCertificate (fun t =>
      lineFrame (p₀ t) (q₀ t) (r t) * N t = 1))
    (hG3 : HasPolynomialOpenCertificate (fun t =>
      ResidualLineNonconstantOn
        (lineFrame (p₀ t) (q₀ t) (r t)) (N t) F))
    (hG4 : HasPolynomialOpenCertificate (fun t =>
      ResidualAvoidsConicDiscriminantOn
        (p₀ t) (q₀ t) (r t) (N t) F (v t))) :
    ∃ t : K,
      lineFrame (p₀ t) (q₀ t) (r t) * N t = 1 ∧
      ResidualLineNonconstantOn
        (lineFrame (p₀ t) (q₀ t) (r t)) (N t) F ∧
      ResidualAvoidsConicDiscriminantOn
        (p₀ t) (q₀ t) (r t) (N t) F (v t) := by
  exact exists_of_three_hasPolynomialOpenCertificate hframe hG3 hG4

/-- Endpoint-value form of the preceding G3--G4 interpolation theorem.  The determinant, chosen
G3 minor, and residual-discriminant witness may be nonzero at three different parameter values. -/
theorem exists_frame_with_G3_G4_of_endpoint_polynomial_certificates
    {K : Type u} [Field K] [Infinite K]
    (p₀ q₀ r : K → Fin 3 → K)
    (N : K → Matrix (Fin 3) (Fin 3) K)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) K)
    (v : K → Fin 3 → Polynomial K)
    (fdet fG3 fG4 : Polynomial K) (tdet tG3 tG4 : K)
    (hfdet : fdet.eval tdet ≠ 0)
    (hfG3 : fG3.eval tG3 ≠ 0)
    (hfG4 : fG4.eval tG4 ≠ 0)
    (hdet : ∀ t, fdet.eval t ≠ 0 →
      lineFrame (p₀ t) (q₀ t) (r t) * N t = 1)
    (hminor : ∀ t, fG3.eval t ≠ 0 →
      ResidualLineNonconstantOn
        (lineFrame (p₀ t) (q₀ t) (r t)) (N t) F)
    (hdisc : ∀ t, fG4.eval t ≠ 0 →
      ResidualAvoidsConicDiscriminantOn
        (p₀ t) (q₀ t) (r t) (N t) F (v t)) :
    ∃ t : K,
      lineFrame (p₀ t) (q₀ t) (r t) * N t = 1 ∧
      ResidualLineNonconstantOn
        (lineFrame (p₀ t) (q₀ t) (r t)) (N t) F ∧
      ResidualAvoidsConicDiscriminantOn
        (p₀ t) (q₀ t) (r t) (N t) F (v t) := by
  apply exists_frame_with_G3_G4_of_polynomial_open_certificates p₀ q₀ r N F v
  · exact hasPolynomialOpenCertificate_of_eval_ne_zero fdet tdet hfdet hdet
  · exact hasPolynomialOpenCertificate_of_eval_ne_zero fG3 tG3 hfG3 hminor
  · exact hasPolynomialOpenCertificate_of_eval_ne_zero fG4 tG4 hfG4 hdisc

end

end BConicBundleMultisections.Standard
