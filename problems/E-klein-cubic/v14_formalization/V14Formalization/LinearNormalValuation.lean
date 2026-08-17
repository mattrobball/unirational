/-
Copyright (c) 2026 V14Formalization contributors.
Released under Apache 2.0 license.
-/
module

public import V14Formalization.SchemeNormalSpecialization
public import BConicBundleMultisections.ProjectiveSpace
public import Mathlib.Algebra.Polynomial.Div
public import Mathlib.Algebra.Polynomial.Eval.Defs
public import Mathlib.FieldTheory.RatFunc.AsPolynomial
public import Mathlib.RingTheory.DedekindDomain.AdicValuation
public import Mathlib.RingTheory.DiscreteValuationRing.Basic
public import Mathlib.RingTheory.LocalRing.ResidueField.Basic
public import Mathlib.RingTheory.Valuation.ValuationSubring

/-!
# Linear normal valuation data (affine model)

This module constructs the **explicit affine/ring** normal valuation underlying the
blowup of projective space along a coordinate linear subspace, without asserting a
general Mathlib blowup API.

## Geometric picture (not packaged as a blowup)

Over a field `Ω`, let `X = ℙⁿ_Ω` and let `L ⊂ X` be the coordinate projective
subspace cut by the first `r` homogeneous coordinates (`1 ≤ r ≤ n`).  The blowup
of `X` along `L` has exceptional divisor `E` of dimension `n-1`.  In an affine
chart transverse to `L`, the normal directions are linearized by a single
uniformizer `T` over a residual function field `κ` of transcendence degree
`n-1`, and the order of vanishing along `E` is the `T`-adic (X-adic) valuation
on `κ(T)`.

## What is proved here

* Full axiom-free package for the **X-adic valuation ring** of `κ(T)`:
  valuation ring structure, fraction field `RatFunc κ`, residue map with
  kernel equal to the maximal ideal, and residue field ≃ `κ`.
* Linear residual field for ambient projective dimension `n`:
  `κ = FractionRing (MvPolynomial (Fin (n-1)) Ω)`.
* The ambient carrier `X = ℙⁿ_Ω` and an auxiliary rational comparison
  carrier `ℙⁿ⁻¹_Ω` over `Spec Ω`.

## Remaining gate

Assembling a full `NormalValuationData` requires identifying the actual source
and exceptional-divisor function fields with the explicit rational function
fields above and checking the `toBase` commuting squares.  The downstream
constructor `linearNormalDataOfChart` exposes those identifications directly.

For a center `ℙ(V₊) ⊂ ℙ(V)`, the actual exceptional divisor is
`ℙ(V₊) × ℙ(V₋)`.  It is generally not `ℙⁿ⁻¹`; the latter appears here
only as a birational comparison model for a rational field of the same
transcendence degree.
-/

noncomputable section

open CategoryTheory
open scoped AlgebraicGeometry
open Polynomial IsLocalRing IsDedekindDomain

namespace V14Formalization
namespace SchemeGeometry

open AlgebraicGeometry BConicBundleMultisections

universe u

/-! ## Kernel of evaluation at zero -/

/-- Evaluation at `0` has kernel `(X)`. -/
theorem ker_eval_zero {κ : Type u} [Field κ] :
    RingHom.ker (evalRingHom (0 : κ)) = Ideal.span {X} := by
  ext p
  constructor
  · intro hp
    have hroot : IsRoot p 0 := by
      simpa [IsRoot, RingHom.mem_ker, coe_evalRingHom] using hp
    have hdvd : X ∣ p := by
      simpa [sub_eq_add_neg, add_comm, zero_add] using (dvd_iff_isRoot.mpr hroot)
    exact Ideal.mem_span_singleton.mpr hdvd
  · intro hp
    have hdiv : X ∣ p := Ideal.mem_span_singleton.mp hp
    have : eval 0 p = 0 := eval_eq_zero_of_dvd_of_eval_eq_zero hdiv (by simp)
    simpa [RingHom.mem_ker, coe_evalRingHom] using this

/-- Quotient isomorphism `κ[X] / (X) ≃+* κ`. -/
def quotByXEquiv (κ : Type u) [Field κ] :
    (κ[X] ⧸ Ideal.span ({X} : Set κ[X])) ≃+* κ :=
  let e := RingHom.quotientKerEquivOfRightInverse
    (f := evalRingHom (0 : κ))
    (g := (C : κ →+* κ[X]))
    (fun _ => by simp)
  (Ideal.quotEquivOfEq (ker_eval_zero (κ := κ)).symm).trans e

/-! ## X-adic integers of a rational function field -/

/-- Valuation ring of the X-adic place on `κ(T)`.

This is the discrete valuation ring of order of vanishing at `T = 0`, which is
the affine model of the blowup-normal valuation along a linear center after a
transverse chart change of coordinates. -/
public abbrev XAdicIntegers (κ : Type u) [Field κ] : Type u :=
  ((idealX κ).valuation (RatFunc κ)).valuationSubring

@[expose] public instance (κ : Type u) [Field κ] : CommRing (XAdicIntegers κ) := inferInstance
@[expose] public instance (κ : Type u) [Field κ] : IsDomain (XAdicIntegers κ) := inferInstance
@[expose] public instance (κ : Type u) [Field κ] : ValuationRing (XAdicIntegers κ) := inferInstance
@[expose] public instance (κ : Type u) [Field κ] : Algebra (XAdicIntegers κ) (RatFunc κ) := inferInstance
@[expose] public instance (κ : Type u) [Field κ] : IsFractionRing (XAdicIntegers κ) (RatFunc κ) :=
  inferInstance
@[expose] public instance (κ : Type u) [Field κ] : IsLocalRing (XAdicIntegers κ) := inferInstance

/-- Constants of `κ` land in the X-adic integers. -/
public theorem const_mem_XAdic {κ : Type u} [Field κ] (a : κ) :
    (algebraMap κ[X] (RatFunc κ) (C a)) ∈
      ((idealX κ).valuation (RatFunc κ)).valuationSubring := by
  rw [Valuation.mem_valuationSubring_iff]
  exact HeightOneSpectrum.valuation_le_one (idealX κ) (C a)

/-- Canonical map from constants into the X-adic integers. -/
@[expose] public def constToXAdic (κ : Type u) [Field κ] : κ →+* XAdicIntegers κ where
  toFun a := ⟨algebraMap κ[X] (RatFunc κ) (C a), const_mem_XAdic a⟩
  map_one' := Subtype.ext (by simp)
  map_mul' _ _ := Subtype.ext (by simp)
  map_zero' := Subtype.ext (by simp)
  map_add' _ _ := Subtype.ext (by simp)

theorem constToXAdic_apply {κ : Type u} [Field κ] (a : κ) :
    (constToXAdic κ a : RatFunc κ) = algebraMap κ[X] (RatFunc κ) (C a) :=
  rfl

/-- Nonzero constants are units in the X-adic integers. -/
theorem isUnit_constToXAdic {κ : Type u} [Field κ] {a : κ} (ha : a ≠ 0) :
    IsUnit (constToXAdic κ a) := by
  refine isUnit_iff_exists_inv.2 ⟨constToXAdic κ a⁻¹, ?_⟩
  apply Subtype.ext
  calc
    (constToXAdic κ a * constToXAdic κ a⁻¹ : RatFunc κ) =
        algebraMap κ[X] (RatFunc κ) (C a) *
          algebraMap κ[X] (RatFunc κ) (C a⁻¹) := rfl
    _ = algebraMap κ[X] (RatFunc κ) (C a * C a⁻¹) := by simp
    _ = algebraMap κ[X] (RatFunc κ) (C (a * a⁻¹)) := by simp
    _ = algebraMap κ[X] (RatFunc κ) (C 1) := by simp [ha]
    _ = (1 : RatFunc κ) := by simp

/-- Composition of constants with the residue map. -/
@[expose] public def constToResidue (κ : Type u) [Field κ] :
    κ →+* ResidueField (XAdicIntegers κ) :=
  (residue (XAdicIntegers κ)).comp (constToXAdic κ)

public theorem constToResidue_injective (κ : Type u) [Field κ] :
    Function.Injective (constToResidue κ) := by
  rw [injective_iff_map_eq_zero]
  intro a ha
  by_contra hne
  have hunit : IsUnit (constToXAdic κ a) := isUnit_constToXAdic hne
  have hnz : residue (XAdicIntegers κ) (constToXAdic κ a) ≠ 0 :=
    (residue_ne_zero_iff_isUnit _).2 hunit
  exact hnz (by simpa [constToResidue] using ha)

/-- Polynomials land in the X-adic integers. -/
theorem poly_mem_XAdic {κ : Type u} [Field κ] (p : κ[X]) :
    (algebraMap κ[X] (RatFunc κ) p) ∈
      ((idealX κ).valuation (RatFunc κ)).valuationSubring := by
  rw [Valuation.mem_valuationSubring_iff]
  exact HeightOneSpectrum.valuation_le_one (idealX κ) p

/-- Canonical map from polynomials into the X-adic integers. -/
def polyToXAdic {κ : Type u} [Field κ] (p : κ[X]) : XAdicIntegers κ :=
  ⟨algebraMap κ[X] (RatFunc κ) p, poly_mem_XAdic p⟩

/-- Residue of a polynomial equals the residue of its constant term. -/
theorem residue_poly_eq_const {κ : Type u} [Field κ] (p : κ[X]) :
    residue (XAdicIntegers κ) (polyToXAdic p) =
      constToResidue κ (eval 0 p) := by
  rw [constToResidue, RingHom.comp_apply]
  apply Ideal.Quotient.eq.2
  rw [← ValuationSubring.coe_mem_nonunits_iff]
  let v := (idealX κ).valuation (RatFunc κ)
  let A := v.valuationSubring
  have heq : (polyToXAdic p - constToXAdic κ (eval 0 p) : RatFunc κ) =
      algebraMap κ[X] (RatFunc κ) (p - C (eval 0 p)) := by
    simp [polyToXAdic, constToXAdic, map_sub]
  have hdiv : X ∣ p - C (eval 0 p) := by
    have : IsRoot (p - C (eval 0 p)) 0 := by simp [IsRoot]
    simpa [sub_eq_add_neg, add_comm, zero_add] using (dvd_iff_isRoot.mpr this)
  have hmem : p - C (eval 0 p) ∈ (idealX κ).asIdeal := by
    simpa [idealX_span, Ideal.mem_span_singleton] using hdiv
  have hlt : v (algebraMap κ[X] (RatFunc κ) (p - C (eval 0 p))) < 1 :=
    (HeightOneSpectrum.valuation_lt_one_iff_mem (idealX κ)
      (p - C (eval 0 p))).2 hmem
  have hlt' : v (polyToXAdic p - constToXAdic κ (eval 0 p) : RatFunc κ) < 1 := by
    rwa [heq]
  have hequiv : v.IsEquiv A.valuation := Valuation.isEquiv_valuation_valuationSubring v
  have hA : A.valuation (polyToXAdic p - constToXAdic κ (eval 0 p) : RatFunc κ) < 1 :=
    (Valuation.IsEquiv.lt_one_iff_lt_one hequiv).1 hlt'
  exact (ValuationSubring.mem_nonunits_iff A).2 hA

theorem eval_ne_zero_of_not_mem_idealX {κ : Type u} [Field κ] {d : κ[X]}
    (hd : d ∉ (idealX κ).asIdeal) : eval 0 d ≠ 0 := by
  intro h
  have : X ∣ d := by
    have : IsRoot d 0 := h
    simpa [sub_eq_add_neg, add_comm, zero_add] using (dvd_iff_isRoot.mpr this)
  exact hd (by simpa [idealX_span, Ideal.mem_span_singleton] using this)

/-- Constants surject onto the residue field of the X-adic integers. -/
public theorem constToResidue_surjective (κ : Type u) [Field κ] :
    Function.Surjective (constToResidue κ) := by
  intro y
  obtain ⟨x, rfl⟩ :=
    (residue_surjective : Function.Surjective (residue (XAdicIntegers κ))) y
  let v := (idealX κ).valuation (RatFunc κ)
  have hv : v (x : RatFunc κ) ≤ 1 :=
    (Valuation.mem_valuationSubring_iff v _).1 x.property
  obtain ⟨n, ⟨d, hd⟩, hnd⟩ :=
    HeightOneSpectrum.exists_primeCompl_mul_eq_of_integer (idealX κ)
      (x : RatFunc κ) hv
  have hd' : d ∉ (idealX κ).asIdeal := hd
  have hdeval : eval 0 d ≠ 0 := eval_ne_zero_of_not_mem_idealX hd'
  have hmul :
      residue (XAdicIntegers κ) x * residue (XAdicIntegers κ) (polyToXAdic d) =
        residue (XAdicIntegers κ) (polyToXAdic n) := by
    have heq : (x * polyToXAdic d : XAdicIntegers κ) = polyToXAdic n := by
      apply Subtype.ext
      simpa [polyToXAdic] using hnd
    rw [← map_mul, heq]
  rw [residue_poly_eq_const d, residue_poly_eq_const n] at hmul
  refine ⟨eval 0 n * (eval 0 d)⁻¹, ?_⟩
  have hresd_ne : constToResidue κ (eval 0 d) ≠ 0 := by
    intro h0
    have : constToResidue κ (eval 0 d) = constToResidue κ 0 := by simpa using h0
    exact hdeval (constToResidue_injective κ this)
  have hform :
      residue (XAdicIntegers κ) x =
        constToResidue κ (eval 0 n) * (constToResidue κ (eval 0 d))⁻¹ :=
    (eq_mul_inv_iff_mul_eq₀ hresd_ne).2 hmul
  calc
    constToResidue κ (eval 0 n * (eval 0 d)⁻¹) =
        constToResidue κ (eval 0 n) * constToResidue κ ((eval 0 d)⁻¹) := by
      rw [map_mul]
    _ = constToResidue κ (eval 0 n) * (constToResidue κ (eval 0 d))⁻¹ := by
      rw [map_inv₀]
    _ = residue (XAdicIntegers κ) x := hform.symm

/-- Residue field of the X-adic integers is canonically isomorphic to `κ`. -/
@[expose] public def residueFieldEquiv (κ : Type u) [Field κ] :
    ResidueField (XAdicIntegers κ) ≃+* κ :=
  (RingEquiv.ofBijective (constToResidue κ)
    ⟨constToResidue_injective κ, constToResidue_surjective κ⟩).symm

/-- Residue map of the X-adic integers (surjective, kernel = maximal ideal). -/
@[expose] public def xAdicResidue (κ : Type u) [Field κ] : XAdicIntegers κ →+* κ :=
  (residueFieldEquiv κ).toRingHom.comp (residue (XAdicIntegers κ))

theorem xAdicResidue_surjective (κ : Type u) [Field κ] :
    Function.Surjective (xAdicResidue κ) := by
  intro a
  obtain ⟨x, hx⟩ :=
    (residue_surjective : Function.Surjective (residue (XAdicIntegers κ)))
      ((residueFieldEquiv κ).symm a)
  refine ⟨x, ?_⟩
  simp [xAdicResidue, hx]

public theorem xAdicResidue_ker (κ : Type u) [Field κ] :
    RingHom.ker (xAdicResidue κ) = maximalIdeal (XAdicIntegers κ) := by
  ext x
  simp only [xAdicResidue, RingHom.mem_ker, RingHom.coe_comp, Function.comp_apply,
    RingEquiv.toRingHom_eq_coe, RingHom.coe_coe]
  constructor
  · intro hx
    have : residue (XAdicIntegers κ) x = 0 := by
      apply (residueFieldEquiv κ).injective
      simpa using hx
    exact (residue_eq_zero_iff _).1 this
  · intro hx
    have : residue (XAdicIntegers κ) x = 0 := (residue_eq_zero_iff _).2 hx
    simp [this]

/-- Residue of a constant recovers the constant. -/
public theorem xAdicResidue_const (κ : Type u) [Field κ] (a : κ) :
    xAdicResidue κ (constToXAdic κ a) = a := by
  change residueFieldEquiv κ (constToResidue κ a) = a
  exact (RingEquiv.ofBijective (constToResidue κ)
    ⟨constToResidue_injective κ, constToResidue_surjective κ⟩).symm_apply_apply a

/-! ## Linear residual field for projective ambient dimension `n` -/

/-- Residual function field for the normal valuation of `ℙⁿ` along a linear
center: after a transverse chart change of coordinates, there are `n-1`
free residual variables (ratios of normal directions plus free directions
along the center). -/
public abbrev LinearResidualField (n : ℕ) (Ω : Type u) [Field Ω] : Type u :=
  FractionRing (MvPolynomial (Fin (n - 1)) Ω)

/-- X-adic integers over the residual field of ambient dimension `n`.

Requires `n ≥ 1` for the residual index type to match the exceptional
function-field dimension `n-1`. -/
public abbrev LinearNormalValuationRing (n : ℕ) (Ω : Type u) [Field Ω] : Type u :=
  XAdicIntegers (LinearResidualField n Ω)

@[expose] public instance (n : ℕ) (Ω : Type u) [Field Ω] :
    CommRing (LinearNormalValuationRing n Ω) := inferInstance
@[expose] public instance (n : ℕ) (Ω : Type u) [Field Ω] :
    IsDomain (LinearNormalValuationRing n Ω) := inferInstance
@[expose] public instance (n : ℕ) (Ω : Type u) [Field Ω] :
    ValuationRing (LinearNormalValuationRing n Ω) := inferInstance
@[expose] public instance (n : ℕ) (Ω : Type u) [Field Ω] :
    Algebra (LinearNormalValuationRing n Ω)
      (RatFunc (LinearResidualField n Ω)) := inferInstance
@[expose] public instance (n : ℕ) (Ω : Type u) [Field Ω] :
    IsFractionRing (LinearNormalValuationRing n Ω)
      (RatFunc (LinearResidualField n Ω)) := inferInstance

/-- Affine model of the fraction field of `ℙⁿ` after one standard chart and
linear normal form: `κ(T)` with `κ` the residual field of dimension `n-1`. -/
public abbrev LinearNormalFractionField (n : ℕ) (Ω : Type u) [Field Ω] : Type u :=
  RatFunc (LinearResidualField n Ω)

/-- Affine model of the exceptional function field: the residual field itself. -/
public abbrev LinearExceptionalFunctionField (n : ℕ) (Ω : Type u) [Field Ω] : Type u :=
  LinearResidualField n Ω

/-- Residue map of the linear normal valuation ring onto the residual field. -/
@[expose] public def linearNormalResidue (n : ℕ) (Ω : Type u) [Field Ω] :
    LinearNormalValuationRing n Ω →+* LinearExceptionalFunctionField n Ω :=
  xAdicResidue (LinearResidualField n Ω)

public theorem linearNormalResidue_surjective (n : ℕ) (Ω : Type u) [Field Ω] :
    Function.Surjective (linearNormalResidue n Ω) :=
  xAdicResidue_surjective _

public theorem linearNormalResidue_ker (n : ℕ) (Ω : Type u) [Field Ω] :
    RingHom.ker (linearNormalResidue n Ω) =
      maximalIdeal (LinearNormalValuationRing n Ω) :=
  xAdicResidue_ker _

theorem linearNormalResidue_const (n : ℕ) (Ω : Type u) [Field Ω]
    (a : LinearResidualField n Ω) :
    linearNormalResidue n Ω
        (constToXAdic (LinearResidualField n Ω) a) = a :=
  xAdicResidue_const _ a

/-! ## Base-field embeddings and Spec morphisms over `Spec Ω` -/

/-- Canonical map `Ω → κ` into the residual field. -/
@[expose] public def baseToResidualField (n : ℕ) (Ω : Type u) [Field Ω] :
    Ω →+* LinearResidualField n Ω :=
  algebraMap Ω (LinearResidualField n Ω)

/-- Canonical map `Ω → R` into the linear normal valuation ring (constants). -/
@[expose] public def baseToLinearNormalRing (n : ℕ) (Ω : Type u) [Field Ω] :
    Ω →+* LinearNormalValuationRing n Ω :=
  (constToXAdic (LinearResidualField n Ω)).comp (baseToResidualField n Ω)

/-- Canonical map `Ω → κ(T)` into the affine ambient function field. -/
@[expose] public def baseToLinearNormalFractionField (n : ℕ) (Ω : Type u) [Field Ω] :
    Ω →+* LinearNormalFractionField n Ω :=
  (algebraMap (LinearResidualField n Ω) (LinearNormalFractionField n Ω)).comp
    (baseToResidualField n Ω)

/-- Spec of the valuation ring, as an `Ω`-scheme via the constant map. -/
@[expose] public def linearNormalValuation_toBase (n : ℕ) (Ω : Type u) [Field Ω] :
    Spec (.of (LinearNormalValuationRing n Ω)) ⟶ Spec (.of Ω) :=
  Spec.map (CommRingCat.ofHom (baseToLinearNormalRing n Ω))

/-- Generic point map `Spec κ(T) → Spec R` from the fraction field. -/
@[expose] public def linearNormalValuation_generic (n : ℕ) (Ω : Type u) [Field Ω] :
    Spec (.of (LinearNormalFractionField n Ω)) ⟶
      Spec (.of (LinearNormalValuationRing n Ω)) :=
  Spec.map (CommRingCat.ofHom
    (algebraMap (LinearNormalValuationRing n Ω) (LinearNormalFractionField n Ω)))

/-- Special fiber map `Spec κ → Spec R` from the residue field. -/
@[expose] public def linearNormalValuation_special (n : ℕ) (Ω : Type u) [Field Ω] :
    Spec (.of (LinearExceptionalFunctionField n Ω)) ⟶
      Spec (.of (LinearNormalValuationRing n Ω)) :=
  Spec.map (CommRingCat.ofHom (linearNormalResidue n Ω))

/-- Residue of base constants recovers the residual base map. -/
theorem linearNormalResidue_base (n : ℕ) (Ω : Type u) [Field Ω] (a : Ω) :
    linearNormalResidue n Ω (baseToLinearNormalRing n Ω a) =
      baseToResidualField n Ω a := by
  change linearNormalResidue n Ω
      (constToXAdic _ (algebraMap Ω (LinearResidualField n Ω) a)) =
    algebraMap Ω (LinearResidualField n Ω) a
  exact linearNormalResidue_const n Ω _

private theorem baseToLinearNormalRing_comp_eq (n : ℕ) (Ω : Type u) [Field Ω] :
    (linearNormalResidue n Ω).comp (baseToLinearNormalRing n Ω) =
      baseToResidualField n Ω :=
  RingHom.ext (linearNormalResidue_base n Ω)

private theorem algebraMap_baseToLinearNormalRing_eq
    (n : ℕ) (Ω : Type u) [Field Ω] :
    (algebraMap (LinearNormalValuationRing n Ω) (LinearNormalFractionField n Ω)).comp
        (baseToLinearNormalRing n Ω) =
      baseToLinearNormalFractionField n Ω := by
  ext a
  simp only [RingHom.comp_apply, baseToLinearNormalRing, baseToLinearNormalFractionField,
    baseToResidualField, constToXAdic_apply]
  rfl

/-- The special map lies over `Spec Ω`. -/
public theorem linearNormalValuation_special_toBase (n : ℕ) (Ω : Type u) [Field Ω] :
    linearNormalValuation_special n Ω ≫ linearNormalValuation_toBase n Ω =
      Spec.map (CommRingCat.ofHom (baseToResidualField n Ω)) := by
  dsimp [linearNormalValuation_special, linearNormalValuation_toBase]
  rw [← Spec.map_comp, ← CommRingCat.ofHom_comp, baseToLinearNormalRing_comp_eq]

/-- The generic map lies over `Spec Ω`. -/
public theorem linearNormalValuation_generic_toBase (n : ℕ) (Ω : Type u) [Field Ω] :
    linearNormalValuation_generic n Ω ≫ linearNormalValuation_toBase n Ω =
      Spec.map (CommRingCat.ofHom (baseToLinearNormalFractionField n Ω)) := by
  dsimp [linearNormalValuation_generic, linearNormalValuation_toBase]
  rw [← Spec.map_comp, ← CommRingCat.ofHom_comp,
    algebraMap_baseToLinearNormalRing_eq]

/-! ## Ambient and auxiliary rational comparison carriers -/

/-- Ambient projective space of dimension `n` over the base field. -/
public abbrev linearAmbient (n : ℕ) (Ω : Type u) [Field Ω] : Scheme.{u} :=
  ProjectiveSpace n Ω

/-- Auxiliary rational carrier of dimension `n-1`.

This has the same rational function-field shape as a linear exceptional
divisor, but it is not asserted to be that divisor.  The actual exceptional
scheme is supplied separately to `linearNormalDataOfChart`. -/
public abbrev linearResidueRationalModel (n : ℕ) (Ω : Type u) [Field Ω] : Scheme.{u} :=
  ProjectiveSpace (n - 1) Ω

/-- Base scheme `Spec Ω`. -/
public abbrev linearBase (Ω : Type u) [Field Ω] : Scheme.{u} :=
  Spec (.of Ω)

@[expose] public instance (n : ℕ) (Ω : Type u) [Field Ω] :
    (linearAmbient n Ω).Over (linearBase Ω) :=
  inferInstance

@[expose] public instance (n : ℕ) (Ω : Type u) [Field Ω] :
    (linearResidueRationalModel n Ω).Over (linearBase Ω) :=
  inferInstance

abbrev linearAmbient_toBase (n : ℕ) (Ω : Type u) [Field Ω] :
    linearAmbient n Ω ⟶ linearBase Ω :=
  ProjectiveSpace.toSpec n Ω

abbrev linearResidueRationalModel_toBase (n : ℕ) (Ω : Type u) [Field Ω] :
    linearResidueRationalModel n Ω ⟶ linearBase Ω :=
  ProjectiveSpace.toSpec (n - 1) Ω

/-! ## Packaged algebraic interfaces for specialization

These are the concrete ring / function-field / residue / Spec maps that
`NormalValuationData` and `EquivariantNormalValuationData` consume once the
scheme function fields are identified with the affine models.  Everything in
this section is fully constructed.
-/

/-- Valuation ring endpoint. -/
public abbrev LinearNormalAlgebraic.R (n : ℕ) (Ω : Type u) [Field Ω] : Type u :=
  LinearNormalValuationRing n Ω

/-- Fraction-field endpoint (affine model of `K(X)`). -/
public abbrev LinearNormalAlgebraic.K (n : ℕ) (Ω : Type u) [Field Ω] : Type u :=
  LinearNormalFractionField n Ω

/-- Residue-field endpoint (affine model of `K(E)`). -/
public abbrev LinearNormalAlgebraic.residueField (n : ℕ) (Ω : Type u) [Field Ω] : Type u :=
  LinearExceptionalFunctionField n Ω

/-- Residue map endpoint. -/
public abbrev LinearNormalAlgebraic.residue (n : ℕ) (Ω : Type u) [Field Ω] :
    LinearNormalAlgebraic.R n Ω →+* LinearNormalAlgebraic.residueField n Ω :=
  linearNormalResidue n Ω

public theorem LinearNormalAlgebraic.residue_surjective
    (n : ℕ) (Ω : Type u) [Field Ω] :
    Function.Surjective (LinearNormalAlgebraic.residue n Ω) :=
  linearNormalResidue_surjective n Ω

public theorem LinearNormalAlgebraic.residue_ker
    (n : ℕ) (Ω : Type u) [Field Ω] :
    RingHom.ker (LinearNormalAlgebraic.residue n Ω) =
      maximalIdeal (LinearNormalAlgebraic.R n Ω) :=
  linearNormalResidue_ker n Ω

/-- Spec structure map endpoint. -/
public abbrev LinearNormalAlgebraic.toBase (n : ℕ) (Ω : Type u) [Field Ω] :
    Spec (.of (LinearNormalAlgebraic.R n Ω)) ⟶ Spec (.of Ω) :=
  linearNormalValuation_toBase n Ω

/-- Spec generic map endpoint. -/
abbrev LinearNormalAlgebraic.genericMap (n : ℕ) (Ω : Type u) [Field Ω] :
    Spec (.of (LinearNormalAlgebraic.K n Ω)) ⟶
      Spec (.of (LinearNormalAlgebraic.R n Ω)) :=
  linearNormalValuation_generic n Ω

/-- Spec special map endpoint. -/
abbrev LinearNormalAlgebraic.specialMap (n : ℕ) (Ω : Type u) [Field Ω] :
    Spec (.of (LinearNormalAlgebraic.residueField n Ω)) ⟶
      Spec (.of (LinearNormalAlgebraic.R n Ω)) :=
  linearNormalValuation_special n Ω

theorem LinearNormalAlgebraic.specialMap_toBase
    (n : ℕ) (Ω : Type u) [Field Ω] :
    LinearNormalAlgebraic.specialMap n Ω ≫ LinearNormalAlgebraic.toBase n Ω =
      Spec.map (CommRingCat.ofHom (baseToResidualField n Ω)) :=
  linearNormalValuation_special_toBase n Ω

theorem LinearNormalAlgebraic.genericMap_toBase
    (n : ℕ) (Ω : Type u) [Field Ω] :
    LinearNormalAlgebraic.genericMap n Ω ≫ LinearNormalAlgebraic.toBase n Ω =
      Spec.map (CommRingCat.ofHom (baseToLinearNormalFractionField n Ω)) :=
  linearNormalValuation_generic_toBase n Ω

/-! ## Public summary endpoints -/

theorem linearNormalValuationRing_isValuationRing
    (n : ℕ) (Ω : Type u) [Field Ω] :
    ValuationRing (LinearNormalValuationRing n Ω) :=
  inferInstance

theorem linearNormalValuationRing_isFractionRing
    (n : ℕ) (Ω : Type u) [Field Ω] :
    IsFractionRing (LinearNormalValuationRing n Ω)
      (LinearNormalFractionField n Ω) :=
  inferInstance

theorem linearNormalResidue_is_surjective
    (n : ℕ) (Ω : Type u) [Field Ω] :
    Function.Surjective (linearNormalResidue n Ω) :=
  linearNormalResidue_surjective n Ω

theorem linearNormalResidue_ker_eq_maximalIdeal
    (n : ℕ) (Ω : Type u) [Field Ω] :
    RingHom.ker (linearNormalResidue n Ω) =
      maximalIdeal (LinearNormalValuationRing n Ω) :=
  linearNormalResidue_ker n Ω

end SchemeGeometry
end V14Formalization

/-! ## Axiom audit for every public endpoint -/

open V14Formalization.SchemeGeometry

#print axioms ker_eval_zero
#print axioms quotByXEquiv
#print axioms const_mem_XAdic
#print axioms constToXAdic
#print axioms isUnit_constToXAdic
#print axioms constToResidue_injective
#print axioms constToResidue_surjective
#print axioms residueFieldEquiv
#print axioms xAdicResidue
#print axioms xAdicResidue_surjective
#print axioms xAdicResidue_ker
#print axioms xAdicResidue_const
#print axioms linearNormalResidue
#print axioms linearNormalResidue_surjective
#print axioms linearNormalResidue_ker
#print axioms linearNormalResidue_const
#print axioms baseToLinearNormalRing
#print axioms linearNormalValuation_toBase
#print axioms linearNormalValuation_generic
#print axioms linearNormalValuation_special
#print axioms linearNormalResidue_base
#print axioms linearNormalValuation_special_toBase
#print axioms linearNormalValuation_generic_toBase
#print axioms LinearNormalAlgebraic.residue_surjective
#print axioms LinearNormalAlgebraic.residue_ker
#print axioms LinearNormalAlgebraic.specialMap_toBase
#print axioms LinearNormalAlgebraic.genericMap_toBase
#print axioms linearNormalValuationRing_isValuationRing
#print axioms linearNormalValuationRing_isFractionRing
#print axioms linearNormalResidue_is_surjective
#print axioms linearNormalResidue_ker_eq_maximalIdeal
