module

public import Mathlib.Algebra.Polynomial.Module.TensorProduct
public import Mathlib.Algebra.TrivSqZeroExt.Basic
public import Mathlib.Algebra.MvPolynomial.Equiv
public import Mathlib.RingTheory.Flat.Equalizer
public import Mathlib.RingTheory.Ideal.Quotient.Operations
public import Mathlib.RingTheory.LocalProperties.Exactness
public import Mathlib.RingTheory.MvPolynomial.Localization
public import Mathlib.RingTheory.Polynomial.ContentIdeal

/-!
# Flatness input for primitive hypersurfaces

This file isolates two universal-algebra facts used in the flatness route for
conic projections.

* A cokernel of a universally injective map into a flat module is flat.
* A univariate polynomial whose coefficients generate the unit ideal acts
  injectively on `M[X]` for every module `M`.

The second statement is the module-valued form of McCoy's theorem.  We reduce
it to Mathlib's ring-valued McCoy theorem by adjoining `M` as a square-zero
ideal.
-/

@[expose] public section

noncomputable section

open Polynomial TensorProduct

universe u v

namespace BConicBundleMultisections.PrimitiveHypersurfaceFlatness

section FlatCokernel

variable {R : Type u} [CommRing R]
variable {K F P : Type u}
variable [AddCommGroup K] [AddCommGroup F] [AddCommGroup P]
variable [Module R K] [Module R F] [Module R P]

/--
Let `K → F → P → 0` be exact, with `F` flat.  If tensoring the first
map with every module is injective, then `P` is flat.

This is the exact-sequence bridge needed after a module-valued McCoy theorem.
-/
theorem flat_of_exact_of_lTensor_injective [Module.Flat R F]
    (g : K →ₗ[R] F) (p : F →ₗ[R] P)
    (hp : Function.Surjective p) (hgp : Function.Exact g p)
    (hg : ∀ (N : Type u) [AddCommGroup N] [Module R N],
      Function.Injective (g.lTensor N)) : Module.Flat R P := by
  rw [Module.Flat.iff_rTensor_preserves_injective_linearMap]
  intro N N' _ _ _ _ f hf z z' hzz'
  apply sub_eq_zero.mp
  let x := z - z'
  have hx : f.rTensor P x = 0 := by
    dsimp [x]
    rw [map_sub, hzz', sub_self]
  let C := N' ⧸ LinearMap.range f
  let π : N' →ₗ[R] C := Submodule.mkQ (LinearMap.range f)
  have hπ : Function.Surjective π := Submodule.mkQ_surjective _
  have hfπ : Function.Exact f π := LinearMap.exact_map_mkQ_range f
  have hK : Function.Exact (f.rTensor K) (π.rTensor K) :=
    _root_.rTensor_exact K hfπ hπ
  have hgN' : Function.Exact (g.lTensor N') (p.lTensor N') :=
    _root_.lTensor_exact N' hgp hp
  obtain ⟨y, hy⟩ := LinearMap.lTensor_surjective N hp x
  have hfpy : p.lTensor N' (f.rTensor F y) = 0 := by
    rw [← LinearMap.comp_apply, LinearMap.lTensor_comp_rTensor,
      ← LinearMap.rTensor_comp_lTensor, LinearMap.comp_apply, hy, hx]
  have hfymem : f.rTensor F y ∈ LinearMap.ker (p.lTensor N') := by
    simpa [LinearMap.mem_ker] using hfpy
  rw [hgN'.linearMap_ker_eq] at hfymem
  obtain ⟨w, hw⟩ := hfymem
  have hπw : π.rTensor K w = 0 := hg C (by
    rw [← LinearMap.comp_apply, LinearMap.lTensor_comp_rTensor,
      ← LinearMap.rTensor_comp_lTensor, LinearMap.comp_apply, hw,
      ← LinearMap.comp_apply, ← LinearMap.rTensor_comp, hfπ.linearMap_comp_eq_zero]
    simp)
  have hwmem : w ∈ LinearMap.ker (π.rTensor K) := by
    simpa [LinearMap.mem_ker] using hπw
  rw [hK.linearMap_ker_eq] at hwmem
  obtain ⟨v, hv⟩ := hwmem
  have hy' : y = g.lTensor N v :=
    (Module.Flat.rTensor_preserves_injective_linearMap f hf) (by
      rw [← hw, ← hv, ← LinearMap.comp_apply, LinearMap.lTensor_comp_rTensor,
        ← LinearMap.rTensor_comp_lTensor, LinearMap.comp_apply])
  change x = 0
  rw [← hy, hy', ← LinearMap.comp_apply, ← LinearMap.lTensor_comp,
    hgp.linearMap_comp_eq_zero]
  simp

end FlatCokernel

section UnivariateMcCoy

variable {A : Type u} [CommRing A]
variable {M : Type v} [AddCommGroup M] [Module A M]

local instance : Module Aᵐᵒᵖ M :=
  Module.compHom M ((RingHom.id A).fromOpposite mul_comm)

local instance : IsCentralScalar A M := ⟨fun _ _ ↦ rfl⟩

private def toSquareZeroPolynomial (q : PolynomialModule A M) :
    Polynomial (TrivSqZeroExt A M) :=
  PolynomialModule.equivPolynomial
    (PolynomialModule.map A (TrivSqZeroExt.inrHom A M) q)

@[simp]
private lemma coeff_toSquareZeroPolynomial (q : PolynomialModule A M) (n : ℕ) :
    (toSquareZeroPolynomial q).coeff n = TrivSqZeroExt.inr (q.coeff n) := by
  rfl

@[simp]
private lemma toSquareZeroPolynomial_zero :
    toSquareZeroPolynomial (0 : PolynomialModule A M) = 0 := by
  ext n <;> simp [coeff_toSquareZeroPolynomial]

private lemma toSquareZeroPolynomial_injective :
    Function.Injective (toSquareZeroPolynomial : PolynomialModule A M →
      Polynomial (TrivSqZeroExt A M)) := by
  intro q q' h
  ext n
  have hn := congr_arg
    (fun p : Polynomial (TrivSqZeroExt A M) ↦ (p.coeff n).snd) h
  simpa using hn

private lemma map_mul_toSquareZeroPolynomial (g : Polynomial A)
    (q : PolynomialModule A M) :
    g.map (TrivSqZeroExt.inlHom A M) * toSquareZeroPolynomial q =
      toSquareZeroPolynomial (g • q) := by
  ext n <;>
    simp [coeff_mul, PolynomialModule.smul_apply,
      TrivSqZeroExt.fst_sum, TrivSqZeroExt.snd_sum]

private lemma scalar_eq_zero_of_smul_map_eq_zero (g : Polynomial A)
    (hg : g.contentIdeal = ⊤) (r : TrivSqZeroExt A M)
    (hr : r • g.map (TrivSqZeroExt.inlHom A M) = 0) : r = 0 := by
  have hcoeff : ∀ n : ℕ, g.coeff n • r = 0 := by
    intro n
    have hn := congr_arg
      (fun p : Polynomial (TrivSqZeroExt A M) ↦ p.coeff n) hr
    apply TrivSqZeroExt.ext
    · have hfst := congr_arg TrivSqZeroExt.fst hn
      simpa [mul_comm] using hfst
    · have hsnd := congr_arg TrivSqZeroExt.snd hn
      simpa [mul_comm] using hsnd
  have hg' : Ideal.span (↑g.coeffs : Set A) = ⊤ := by
    simpa [Polynomial.contentIdeal_def] using hg
  have hrbot : r ∈ (⊥ : Submodule A (TrivSqZeroExt A M)) :=
    Submodule.mem_of_span_top_of_smul_mem ⊥ (↑g.coeffs : Set A) hg' r fun a ↦ by
      rw [Submodule.mem_bot]
      obtain ⟨n, _, hn⟩ := Polynomial.mem_coeffs_iff.mp a.property
      rw [hn]
      exact hcoeff n
  simpa using hrbot

/--
Module-valued McCoy theorem for a primitive univariate polynomial: if the
coefficients of `g` generate the unit ideal, multiplication by `g` on `M[X]`
is injective for every `A`-module `M`.
-/
theorem polynomialModule_smul_injective_of_contentIdeal_eq_top
    (g : Polynomial A) (hg : g.contentIdeal = ⊤) :
    Function.Injective
      (g • · : PolynomialModule A M → PolynomialModule A M) := by
  intro q q' hqq'
  apply sub_eq_zero.mp
  apply toSquareZeroPolynomial_injective
  rw [toSquareZeroPolynomial_zero]
  apply Polynomial.eq_zero_of_mul_eq_zero_of_smul
    (g.map (TrivSqZeroExt.inlHom A M))
    (scalar_eq_zero_of_smul_map_eq_zero g hg)
  rw [map_mul_toSquareZeroPolynomial]
  simpa [smul_sub] using
    congr_arg toSquareZeroPolynomial (sub_eq_zero.mpr hqq')

end UnivariateMcCoy

section UnivariateQuotient

variable {A : Type u} [CommRing A]

private def mulBy (g : Polynomial A) : Polynomial A →ₗ[A] Polynomial A :=
  LinearMap.mulLeft A g

private lemma polynomialTensorProductLEquiv_mulBy (g : Polynomial A)
    {N : Type u} [AddCommGroup N] [Module A N]
    (x : Polynomial A ⊗[A] N) :
    PolynomialModule.polynomialTensorProductLEquivPolynomialModule A N
        ((mulBy g).rTensor N x) =
      g • PolynomialModule.polynomialTensorProductLEquivPolynomialModule A N x := by
  induction x with
  | zero => simp
  | tmul p n =>
      simp only [LinearMap.rTensor_tmul]
      change (g * p) • PolynomialModule.lsingle A 0 n =
        g • p • PolynomialModule.lsingle A 0 n
      rw [mul_smul]
  | add x y hx hy => simp [hx, hy]

private lemma rTensor_mulBy_injective_of_contentIdeal_eq_top
    (g : Polynomial A) (hg : g.contentIdeal = ⊤)
    (N : Type u) [AddCommGroup N] [Module A N] :
    Function.Injective ((mulBy g).rTensor N) := by
  intro x y hxy
  apply (PolynomialModule.polynomialTensorProductLEquivPolynomialModule A N).injective
  apply polynomialModule_smul_injective_of_contentIdeal_eq_top g hg
  simpa only [polynomialTensorProductLEquiv_mulBy] using
    congr_arg (PolynomialModule.polynomialTensorProductLEquivPolynomialModule A N) hxy

private lemma exact_mulBy_mkQuotient (g : Polynomial A) :
    Function.Exact (mulBy g)
      (Ideal.Quotient.mkₐ A
        (Ideal.span ({g} : Set (Polynomial A)))).toLinearMap := by
  rw [LinearMap.exact_iff]
  ext x
  simp only [LinearMap.mem_ker, AlgHom.toLinearMap_apply,
    Ideal.Quotient.mkₐ_eq_mk, Ideal.Quotient.eq_zero_iff_mem,
    LinearMap.mem_range]
  constructor
  · intro hx
    obtain ⟨a, ha⟩ := Ideal.mem_span_singleton'.mp hx
    exact ⟨a, by simpa [mulBy, mul_comm] using ha⟩
  · rintro ⟨a, rfl⟩
    exact Ideal.mem_span_singleton'.mpr ⟨a, by simp [mulBy, mul_comm]⟩

/--
The quotient by a primitive univariate polynomial is flat over the coefficient
ring.
-/
theorem flat_quotient_span_singleton_of_contentIdeal_eq_top
    (g : Polynomial A) (hg : g.contentIdeal = ⊤) :
    Module.Flat A
      (Polynomial A ⧸ Ideal.span ({g} : Set (Polynomial A))) := by
  apply flat_of_exact_of_lTensor_injective (mulBy g)
    (Ideal.Quotient.mkₐ A
      (Ideal.span ({g} : Set (Polynomial A)))).toLinearMap
    (Ideal.Quotient.mkₐ_surjective A _) (exact_mulBy_mkQuotient g)
  intro N _ _
  exact (LinearMap.lTensor_inj_iff_rTensor_inj N (mulBy g)).mpr
    (rTensor_mulBy_injective_of_contentIdeal_eq_top g hg N)

end UnivariateQuotient

section MultivariateRegular

variable {A : Type u} [CommRing A]

/-- A multivariate polynomial with a unit coefficient is a non-zero-divisor.

The proof peels off one variable with `MvPolynomial.finSuccEquiv` and uses
the univariate McCoy theorem at each step.  This formulation is useful after
localizing a primitive polynomial at a maximal ideal: at least one of its
coefficients then becomes a unit.
-/
theorem mvPolynomial_mul_injective_of_isUnit_coeff :
    ∀ (n : ℕ) (g : MvPolynomial (Fin n) A) (d : Fin n →₀ ℕ),
      IsUnit (g.coeff d) → Function.Injective (g * ·) := by
  intro n
  induction n with
  | zero =>
      intro g d hd q q' hqq'
      have hd0 : d = 0 := Subsingleton.elim _ _
      let e := MvPolynomial.isEmptyRingEquiv A (Fin 0)
      have heg : IsUnit (e g) := by
        rw [MvPolynomial.isEmptyRingEquiv_eq_coeff_zero]
        simpa only [hd0] using hd
      apply e.injective
      exact heg.mul_left_cancel (by
        simpa only [map_mul] using congr_arg e hqq')
  | succ n ih =>
      intro g d hd q q' hqq'
      let p : Polynomial (MvPolynomial (Fin n) A) :=
        MvPolynomial.finSuccEquiv A n g
      let r : Polynomial (MvPolynomial (Fin n) A) :=
        MvPolynomial.finSuccEquiv A n (q - q')
      have hcoeff : IsUnit ((p.coeff (d 0)).coeff d.tail) := by
        dsimp only [p]
        rw [MvPolynomial.finSuccEquiv_coeff_coeff, Finsupp.cons_tail]
        exact hd
      have hcoeffRegular : Function.Injective ((p.coeff (d 0)) * ·) :=
        ih (p.coeff (d 0)) d.tail hcoeff
      have hscalar : ∀ a : MvPolynomial (Fin n) A, a • p = 0 → a = 0 := by
        intro a ha
        apply hcoeffRegular
        have haCoeff := congr_arg (fun z : Polynomial (MvPolynomial (Fin n) A) ↦
          z.coeff (d 0)) ha
        simpa [smul_eq_C_mul, mul_comm] using haCoeff
      have hmul : p * r = 0 := by
        dsimp only [p, r]
        rw [← map_mul]
        have hsource : g * (q - q') = 0 := by
          simpa only [mul_sub] using sub_eq_zero.mpr hqq'
        simpa only [map_zero] using
          congr_arg (MvPolynomial.finSuccEquiv A n) hsource
      have hr : r = 0 :=
        Polynomial.eq_zero_of_mul_eq_zero_of_smul p hscalar r hmul
      apply sub_eq_zero.mp
      apply (MvPolynomial.finSuccEquiv A n).injective
      exact hr

/-- A primitive multivariate polynomial is a non-zero-divisor.

Here primitive means that all coefficient values generate the unit ideal. At
each maximal localization one coefficient becomes a unit, so the preceding
theorem applies. Equality is then detected coefficientwise at all maximal
localizations.
-/
theorem mvPolynomial_mul_injective_of_span_range_coeff_eq_top
    {n : ℕ} (g : MvPolynomial (Fin n) A)
    (hg : Ideal.span (Set.range fun d ↦ g.coeff d) = ⊤) :
    Function.Injective (g * ·) := by
  intro q q' hqq'
  ext d'
  apply Module.eq_of_localization_maximal
    (fun P : Ideal A ↦ Localization.AtPrime P)
    (fun P _ ↦ Algebra.linearMap A (Localization.AtPrime P))
  intro P hP
  letI : P.IsPrime := hP.isPrime
  have hex : ∃ d, g.coeff d ∉ P := by
    by_contra h
    push Not at h
    have hle : Ideal.span (Set.range fun d ↦ g.coeff d) ≤ P :=
      Ideal.span_le.mpr fun x hx ↦ by
        obtain ⟨d, rfl⟩ := hx
        exact h d
    exact hP.ne_top (top_unique (hg ▸ hle))
  obtain ⟨d, hd⟩ := hex
  let gP : MvPolynomial (Fin n) (Localization.AtPrime P) :=
    MvPolynomial.map (algebraMap A (Localization.AtPrime P)) g
  have hunit : IsUnit (gP.coeff d) := by
    dsimp only [gP]
    rw [MvPolynomial.coeff_map]
    exact IsLocalization.map_units (Localization.AtPrime P)
      (⟨g.coeff d, hd⟩ : P.primeCompl)
  have hlocal :
      MvPolynomial.map (algebraMap A (Localization.AtPrime P)) q =
        MvPolynomial.map (algebraMap A (Localization.AtPrime P)) q' := by
    apply mvPolynomial_mul_injective_of_isUnit_coeff n gP d hunit
    simpa only [map_mul] using congr_arg
      (MvPolynomial.map (algebraMap A (Localization.AtPrime P))) hqq'
  change algebraMap A (Localization.AtPrime P) (q.coeff d') =
    algebraMap A (Localization.AtPrime P) (q'.coeff d')
  simpa only [MvPolynomial.coeff_map] using
    congr_arg (MvPolynomial.coeff d') hlocal

end MultivariateRegular

section MultivariateTensorMcCoy

variable {A : Type u} [CommRing A]
variable {M : Type v} [AddCommGroup M] [Module A M]

local instance : Module Aᵐᵒᵖ M :=
  Module.compHom M ((RingHom.id A).fromOpposite mul_comm)

local instance : IsCentralScalar A M := ⟨fun _ _ ↦ rfl⟩

private def toSquareZeroMvPolynomial {n : ℕ}
    (x : MvPolynomial (Fin n) A ⊗[A] M) :
    MvPolynomial (Fin n) (TrivSqZeroExt A M) :=
  MvPolynomial.scalarRTensorAlgEquiv
    (TensorProduct.map (TrivSqZeroExt.inrHom A M) LinearMap.id
      (TensorProduct.comm A (MvPolynomial (Fin n) A) M x))

private def fromSquareZeroMvPolynomial {n : ℕ}
    (z : MvPolynomial (Fin n) (TrivSqZeroExt A M)) :
    MvPolynomial (Fin n) A ⊗[A] M :=
  TensorProduct.comm A M (MvPolynomial (Fin n) A)
    (TensorProduct.map (TrivSqZeroExt.sndHom A M) LinearMap.id
      ((MvPolynomial.scalarRTensorAlgEquiv).symm z))

private lemma from_toSquareZeroMvPolynomial {n : ℕ}
    (x : MvPolynomial (Fin n) A ⊗[A] M) :
    fromSquareZeroMvPolynomial (toSquareZeroMvPolynomial x) = x := by
  induction x with
  | zero => simp [fromSquareZeroMvPolynomial, toSquareZeroMvPolynomial]
  | tmul p m => simp [fromSquareZeroMvPolynomial, toSquareZeroMvPolynomial]
  | add x y hx hy =>
      have hto : toSquareZeroMvPolynomial (x + y) =
          toSquareZeroMvPolynomial x + toSquareZeroMvPolynomial y := by
        simp [toSquareZeroMvPolynomial]
      have hfrom : fromSquareZeroMvPolynomial
          (toSquareZeroMvPolynomial x + toSquareZeroMvPolynomial y) =
          fromSquareZeroMvPolynomial (toSquareZeroMvPolynomial x) +
            fromSquareZeroMvPolynomial (toSquareZeroMvPolynomial y) := by
        simp [fromSquareZeroMvPolynomial]
      rw [hto, hfrom, hx, hy]

private lemma toSquareZeroMvPolynomial_injective {n : ℕ} :
    Function.Injective
      (toSquareZeroMvPolynomial : MvPolynomial (Fin n) A ⊗[A] M →
        MvPolynomial (Fin n) (TrivSqZeroExt A M)) :=
  fun x y hxy ↦ by
    rw [← from_toSquareZeroMvPolynomial x, ← from_toSquareZeroMvPolynomial y, hxy]

private lemma toSquareZeroMvPolynomial_tmul {n : ℕ}
    (p : MvPolynomial (Fin n) A) (m : M) :
    toSquareZeroMvPolynomial (p ⊗ₜ[A] m) =
      MvPolynomial.map (TrivSqZeroExt.inlHom A M) p *
        MvPolynomial.C (TrivSqZeroExt.inr m) := by
  simp only [toSquareZeroMvPolynomial, TensorProduct.comm_tmul,
    TensorProduct.map_tmul, LinearMap.id_apply,
    MvPolynomial.scalarRTensorAlgEquiv,
    AddMonoidAlgebra.scalarTensorEquiv_tmul]
  change TrivSqZeroExt.inr m •
      MvPolynomial.map (Algebra.ofId A (TrivSqZeroExt A M)).toRingHom p = _
  rw [show (Algebra.ofId A (TrivSqZeroExt A M)).toRingHom =
    TrivSqZeroExt.inlHom A M by
      exact TrivSqZeroExt.algebraMap_eq_inlHom A M]
  simp [Algebra.smul_def, mul_comm]

private def mvMulBy {n : ℕ} (g : MvPolynomial (Fin n) A) :
    MvPolynomial (Fin n) A →ₗ[A] MvPolynomial (Fin n) A :=
  LinearMap.mulLeft A g

private lemma toSquareZeroMvPolynomial_rTensor_mvMulBy {n : ℕ}
    (g : MvPolynomial (Fin n) A)
    (x : MvPolynomial (Fin n) A ⊗[A] M) :
    toSquareZeroMvPolynomial ((mvMulBy g).rTensor M x) =
      MvPolynomial.map (TrivSqZeroExt.inlHom A M) g *
        toSquareZeroMvPolynomial x := by
  induction x with
  | zero => simp [toSquareZeroMvPolynomial]
  | tmul p m =>
      simp only [LinearMap.rTensor_tmul]
      rw [toSquareZeroMvPolynomial_tmul, toSquareZeroMvPolynomial_tmul]
      change MvPolynomial.map (TrivSqZeroExt.inlHom A M) (g * p) *
        MvPolynomial.C (TrivSqZeroExt.inr m) = _
      rw [map_mul]
      ring
  | add x y hx hy =>
      have hto : ∀ z z' : MvPolynomial (Fin n) A ⊗[A] M,
          toSquareZeroMvPolynomial (z + z') =
            toSquareZeroMvPolynomial z + toSquareZeroMvPolynomial z' := by
        intro z z'
        simp [toSquareZeroMvPolynomial]
      rw [map_add, hto, hto, hx, hy, mul_add]

private lemma span_range_coeff_map_inl_eq_top {n : ℕ}
    (g : MvPolynomial (Fin n) A)
    (hg : Ideal.span (Set.range fun d ↦ g.coeff d) = ⊤) :
    Ideal.span (Set.range fun d ↦
      (MvPolynomial.map (TrivSqZeroExt.inlHom A M) g).coeff d) = ⊤ := by
  let J : Ideal (TrivSqZeroExt A M) :=
    Ideal.span (Set.range fun d ↦
      (MvPolynomial.map (TrivSqZeroExt.inlHom A M) g).coeff d)
  have hmaple : Ideal.map (TrivSqZeroExt.inlHom A M)
      (Ideal.span (Set.range fun d ↦ g.coeff d)) ≤ J := by
    rw [Ideal.map_le_iff_le_comap]
    apply Ideal.span_le.mpr
    rintro x ⟨d, rfl⟩
    change TrivSqZeroExt.inl (g.coeff d) ∈ J
    have hdJ :
        (MvPolynomial.map (TrivSqZeroExt.inlHom A M) g).coeff d ∈ J :=
      Ideal.subset_span (Set.mem_range_self d)
    simpa only [MvPolynomial.coeff_map, TrivSqZeroExt.inlHom_apply] using hdJ
  have hmaptop : Ideal.map (TrivSqZeroExt.inlHom A M)
      (Ideal.span (Set.range fun d ↦ g.coeff d)) = ⊤ := by
    rw [hg, Ideal.map_top]
  rw [hmaptop] at hmaple
  exact top_unique hmaple

private lemma rTensor_mvMulBy_injective_of_span_range_coeff_eq_top {n : ℕ}
    (g : MvPolynomial (Fin n) A)
    (hg : Ideal.span (Set.range fun d ↦ g.coeff d) = ⊤) :
    Function.Injective ((mvMulBy g).rTensor M) := by
  intro x y hxy
  apply toSquareZeroMvPolynomial_injective
  apply mvPolynomial_mul_injective_of_span_range_coeff_eq_top
    (MvPolynomial.map (TrivSqZeroExt.inlHom A M) g)
    (span_range_coeff_map_inl_eq_top g hg)
  simpa only [toSquareZeroMvPolynomial_rTensor_mvMulBy] using
    congr_arg toSquareZeroMvPolynomial hxy

end MultivariateTensorMcCoy

section MultivariateQuotient

variable {A : Type u} [CommRing A]

private lemma exact_mvMulBy_mkQuotient {n : ℕ}
    (g : MvPolynomial (Fin n) A) :
    Function.Exact (mvMulBy g)
      (Ideal.Quotient.mkₐ A
        (Ideal.span ({g} : Set (MvPolynomial (Fin n) A)))).toLinearMap := by
  rw [LinearMap.exact_iff]
  ext x
  simp only [LinearMap.mem_ker, AlgHom.toLinearMap_apply,
    Ideal.Quotient.mkₐ_eq_mk, Ideal.Quotient.eq_zero_iff_mem,
    LinearMap.mem_range]
  constructor
  · intro hx
    obtain ⟨a, ha⟩ := Ideal.mem_span_singleton'.mp hx
    exact ⟨a, by simpa [mvMulBy, mul_comm] using ha⟩
  · rintro ⟨a, rfl⟩
    exact Ideal.mem_span_singleton'.mpr
      ⟨a, by simp [mvMulBy, mul_comm]⟩

/-- The quotient by a primitive multivariate polynomial is flat over its
coefficient ring. -/
theorem flat_mvPolynomial_quotient_span_singleton_of_span_range_coeff_eq_top
    {n : ℕ} (g : MvPolynomial (Fin n) A)
    (hg : Ideal.span (Set.range fun d ↦ g.coeff d) = ⊤) :
    Module.Flat A
      (MvPolynomial (Fin n) A ⧸
        Ideal.span ({g} : Set (MvPolynomial (Fin n) A))) := by
  apply flat_of_exact_of_lTensor_injective (mvMulBy g)
    (Ideal.Quotient.mkₐ A
      (Ideal.span ({g} : Set (MvPolynomial (Fin n) A)))).toLinearMap
    (Ideal.Quotient.mkₐ_surjective A _) (exact_mvMulBy_mkQuotient g)
  intro N _ _
  exact (LinearMap.lTensor_inj_iff_rTensor_inj N (mvMulBy g)).mpr
    (rTensor_mvMulBy_injective_of_span_range_coeff_eq_top g hg)

end MultivariateQuotient

end BConicBundleMultisections.PrimitiveHypersurfaceFlatness

end
