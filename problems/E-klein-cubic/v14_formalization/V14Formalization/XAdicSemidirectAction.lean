/-
Copyright (c) 2026 V14Formalization contributors.
Released under Apache 2.0 license.
-/
import V14Formalization.LinearNormalValuation
import Mathlib.GroupTheory.SemidirectProduct

/-!
# Semidirect automorphisms of the X-adic normal valuation

A coefficient automorphism together with a unit rescaling of the normal
parameter acts on the rational function field, preserves its X-adic
valuation ring, and induces the coefficient action on the residue field.
-/

noncomputable section

open Polynomial IsLocalRing IsDedekindDomain

namespace V14Formalization.SchemeGeometry

universe u

/-- Ring automorphisms act on units. -/
def ringAutUnitsAction (κ : Type u) [Field κ] :
    (κ ≃+* κ) →* MulAut κˣ where
  toFun tau := Units.mapEquiv tau.toMulEquiv
  map_one' := by
    ext x
    rfl
  map_mul' tau eta := by
    ext x
    rfl

/-- The semilinear polynomial automorphism which acts on coefficients by
`tau` and sends `X` to `u * X`. -/
noncomputable def xAdicPolynomialEquiv
    (κ : Type u) [Field κ] (tau : κ ≃+* κ) (u : κˣ) :
    κ[X] ≃+* κ[X] :=
  RingEquiv.ofRingHom
    (eval₂RingHom ((C : κ →+* κ[X]).comp tau.toRingHom)
      (C (u : κ) * X))
    (eval₂RingHom ((C : κ →+* κ[X]).comp tau.symm.toRingHom)
      (C (tau.symm (↑u⁻¹ : κ)) * X))
    (by
      ext a
      · simp
      · simp)
    (by
      ext a
      · simp
      · simp)

@[simp]
theorem xAdicPolynomialEquiv_C
    (κ : Type u) [Field κ] (tau : κ ≃+* κ) (u : κˣ) (a : κ) :
    xAdicPolynomialEquiv κ tau u (C a) = C (tau a) := by
  simp [xAdicPolynomialEquiv]

@[simp]
theorem xAdicPolynomialEquiv_X
    (κ : Type u) [Field κ] (tau : κ ≃+* κ) (u : κˣ) :
    xAdicPolynomialEquiv κ tau u X = C (u : κ) * X := by
  simp [xAdicPolynomialEquiv]

/-- The coefficient automorphism and the unit scaling form the expected
semidirect action on the polynomial ring. -/
noncomputable def xAdicSemidirectPolynomialAction
    (κ : Type u) [Field κ] :
    (κˣ ⋊[ringAutUnitsAction κ] (κ ≃+* κ)) →* (κ[X] ≃+* κ[X]) where
  toFun g := xAdicPolynomialEquiv κ g.right g.left
  map_one' := by
    apply RingEquiv.toRingHom_injective
    apply Polynomial.ringHom_ext
    · intro a
      simp
    · simp [xAdicPolynomialEquiv]
  map_mul' g h := by
    apply RingEquiv.toRingHom_injective
    apply Polynomial.ringHom_ext
    · intro a
      change xAdicPolynomialEquiv κ (g.right * h.right)
          (g.left * (ringAutUnitsAction κ g.right) h.left) (C a) =
        xAdicPolynomialEquiv κ g.right g.left
          (xAdicPolynomialEquiv κ h.right h.left (C a))
      rw [xAdicPolynomialEquiv_C, xAdicPolynomialEquiv_C,
        xAdicPolynomialEquiv_C]
      rfl
    · change xAdicPolynomialEquiv κ (g.right * h.right)
          (g.left * (ringAutUnitsAction κ g.right) h.left) X =
        xAdicPolynomialEquiv κ g.right g.left
          (xAdicPolynomialEquiv κ h.right h.left X)
      rw [xAdicPolynomialEquiv_X, xAdicPolynomialEquiv_X, map_mul,
        xAdicPolynomialEquiv_C, xAdicPolynomialEquiv_X]
      change C ((g.left : κ) * g.right (h.left : κ)) * X =
        C (g.right (h.left : κ)) * (C (g.left : κ) * X)
      simp only [map_mul]
      ring

@[simp]
theorem xAdicPolynomialEquiv_symm_X
    (κ : Type u) [Field κ] (tau : κ ≃+* κ) (u : κˣ) :
    (xAdicPolynomialEquiv κ tau u).symm X =
      C (tau.symm (↑u⁻¹ : κ)) * X := by
  simp [xAdicPolynomialEquiv]

/-- The induced automorphism of the rational function field. -/
noncomputable def xAdicRatFuncEquiv
    (κ : Type u) [Field κ] (tau : κ ≃+* κ) (u : κˣ) :
    RatFunc κ ≃+* RatFunc κ :=
  IsFractionRing.ringEquivOfRingEquiv (K := RatFunc κ)
    (xAdicPolynomialEquiv κ tau u)

/-- The semidirect polynomial action extended to `κ(X)`. -/
noncomputable def xAdicSemidirectRatFuncAction
    (κ : Type u) [Field κ] :
    (κˣ ⋊[ringAutUnitsAction κ] (κ ≃+* κ)) →*
      (RatFunc κ ≃+* RatFunc κ) :=
  (IsFractionRing.ringEquivOfRingEquivHom κ[X] (RatFunc κ)).comp
    (xAdicSemidirectPolynomialAction κ)

theorem xAdicSemidirectRatFuncAction_apply
    (κ : Type u) [Field κ]
    (g : κˣ ⋊[ringAutUnitsAction κ] (κ ≃+* κ)) :
    xAdicSemidirectRatFuncAction κ g =
      xAdicRatFuncEquiv κ g.right g.left := rfl

@[simp]
theorem xAdicRatFuncEquiv_algebraMap
    (κ : Type u) [Field κ] (tau : κ ≃+* κ) (u : κˣ) (p : κ[X]) :
    xAdicRatFuncEquiv κ tau u (algebraMap κ[X] (RatFunc κ) p) =
      algebraMap κ[X] (RatFunc κ) (xAdicPolynomialEquiv κ tau u p) :=
  IsFractionRing.ringEquivOfRingEquiv_algebraMap
    (xAdicPolynomialEquiv κ tau u) p

theorem xAdicPolynomialEquiv_mem_idealX_iff
    (κ : Type u) [Field κ] (tau : κ ≃+* κ) (u : κˣ) (p : κ[X]) :
    p ∈ (idealX κ).asIdeal ↔
      xAdicPolynomialEquiv κ tau u p ∈ (idealX κ).asIdeal := by
  simp only [idealX_span, Ideal.mem_span_singleton]
  constructor
  · rintro ⟨q, rfl⟩
    refine ⟨C (u : κ) * xAdicPolynomialEquiv κ tau u q, ?_⟩
    simp [mul_assoc, mul_left_comm]
  · rintro ⟨q, hq⟩
    have hp := congrArg (xAdicPolynomialEquiv κ tau u).symm hq
    refine ⟨C (tau.symm (↑u⁻¹ : κ)) *
      (xAdicPolynomialEquiv κ tau u).symm q, ?_⟩
    calc
      p = (C (tau.symm (↑u⁻¹ : κ)) * X) *
          (xAdicPolynomialEquiv κ tau u).symm q := by
        simpa using hp
      _ = X * (C (tau.symm (↑u⁻¹ : κ)) *
          (xAdicPolynomialEquiv κ tau u).symm q) := by ring

private theorem mem_xAdic_of_polyEquiv
    (κ : Type u) [Field κ]
    (pe : κ[X] ≃+* κ[X])
    (hideal : ∀ p : κ[X],
      p ∈ (idealX κ).asIdeal ↔ pe p ∈ (idealX κ).asIdeal)
    (x : RatFunc κ)
    (hx : x ∈ ((idealX κ).valuation (RatFunc κ)).valuationSubring) :
    IsFractionRing.ringEquivOfRingEquiv (K := RatFunc κ) pe x ∈
      ((idealX κ).valuation (RatFunc κ)).valuationSubring := by
  let v := (idealX κ).valuation (RatFunc κ)
  have hvx : v x ≤ 1 :=
    (Valuation.mem_valuationSubring_iff v x).1 hx
  obtain ⟨n, ⟨d, hd⟩, hxd⟩ :=
    HeightOneSpectrum.exists_primeCompl_mul_eq_of_integer
      (idealX κ) x hvx
  let fe : RatFunc κ ≃+* RatFunc κ :=
    IsFractionRing.ringEquivOfRingEquiv (K := RatFunc κ) pe
  have hd' : pe d ∉ (idealX κ).asIdeal := by
    exact fun h ↦ hd ((hideal d).mpr h)
  have hden : v (algebraMap κ[X] (RatFunc κ) (pe d)) = 1 :=
    (HeightOneSpectrum.valuation_eq_one_iff_notMem
      (v := idealX κ)).2 hd'
  have hnum : v (algebraMap κ[X] (RatFunc κ) (pe n)) ≤ 1 :=
    HeightOneSpectrum.valuation_le_one (idealX κ) (pe n)
  have hmapped := congrArg fe hxd
  dsimp only [fe] at hmapped
  simp only [map_mul,
    IsFractionRing.ringEquivOfRingEquiv_algebraMap] at hmapped
  rw [Valuation.mem_valuationSubring_iff]
  calc
    v (fe x) = v (fe x) * v (algebraMap κ[X] (RatFunc κ) (pe d)) := by
      rw [hden, mul_one]
    _ = v (fe x * algebraMap κ[X] (RatFunc κ) (pe d)) := by
      rw [map_mul]
    _ = v (algebraMap κ[X] (RatFunc κ) (pe n)) := by rw [hmapped]
    _ ≤ 1 := hnum

/-- The semilinear automorphism `a ↦ tau a`, `X ↦ uX` preserves the X-adic
valuation ring. -/
theorem xAdicRatFuncEquiv_mem_iff
    (κ : Type u) [Field κ] (tau : κ ≃+* κ) (u : κˣ)
    (x : RatFunc κ) :
    x ∈ ((idealX κ).valuation (RatFunc κ)).valuationSubring ↔
      xAdicRatFuncEquiv κ tau u x ∈
        ((idealX κ).valuation (RatFunc κ)).valuationSubring := by
  constructor
  · exact mem_xAdic_of_polyEquiv κ (xAdicPolynomialEquiv κ tau u)
      (xAdicPolynomialEquiv_mem_idealX_iff κ tau u) x
  · intro hx
    have hidealSymm : ∀ p : κ[X],
        p ∈ (idealX κ).asIdeal ↔
          (xAdicPolynomialEquiv κ tau u).symm p ∈
            (idealX κ).asIdeal := by
      intro p
      have h := (xAdicPolynomialEquiv_mem_idealX_iff κ tau u
        ((xAdicPolynomialEquiv κ tau u).symm p)).symm
      rw [RingEquiv.apply_symm_apply] at h
      exact h
    have hback := mem_xAdic_of_polyEquiv κ
      (xAdicPolynomialEquiv κ tau u).symm
      hidealSymm
      (xAdicRatFuncEquiv κ tau u x) hx
    change (xAdicRatFuncEquiv κ tau u).symm
      (xAdicRatFuncEquiv κ tau u x) ∈
        ((idealX κ).valuation (RatFunc κ)).valuationSubring at hback
    simpa using hback

/-- Restriction of a semidirect coefficient/scaling automorphism to the
X-adic valuation ring. -/
noncomputable def xAdicSemidirectValuationEquiv
    (κ : Type u) [Field κ]
    (g : κˣ ⋊[ringAutUnitsAction κ] (κ ≃+* κ)) :
    XAdicIntegers κ ≃+* XAdicIntegers κ where
  toFun x := ⟨xAdicSemidirectRatFuncAction κ g x,
    (xAdicRatFuncEquiv_mem_iff κ g.right g.left x).mp x.property⟩
  invFun x := ⟨(xAdicSemidirectRatFuncAction κ g).symm x,
    (xAdicRatFuncEquiv_mem_iff κ g.right g.left
      ((xAdicSemidirectRatFuncAction κ g).symm x)).mpr (by
        simpa [xAdicSemidirectRatFuncAction_apply] using x.property)⟩
  left_inv x := Subtype.ext ((xAdicSemidirectRatFuncAction κ g).symm_apply_apply x)
  right_inv x := Subtype.ext ((xAdicSemidirectRatFuncAction κ g).apply_symm_apply x)
  map_mul' x y := Subtype.ext
    ((xAdicSemidirectRatFuncAction κ g).map_mul (x : RatFunc κ) y)
  map_add' x y := Subtype.ext
    ((xAdicSemidirectRatFuncAction κ g).map_add (x : RatFunc κ) y)

@[simp]
theorem xAdicSemidirectValuationEquiv_coe
    (κ : Type u) [Field κ]
    (g : κˣ ⋊[ringAutUnitsAction κ] (κ ≃+* κ))
    (x : XAdicIntegers κ) :
    (xAdicSemidirectValuationEquiv κ g x : RatFunc κ) =
      xAdicSemidirectRatFuncAction κ g x := rfl

/-- The semidirect coefficient/scaling group acts on the X-adic valuation
ring. -/
noncomputable def xAdicSemidirectValuationAction
    (κ : Type u) [Field κ] :
    (κˣ ⋊[ringAutUnitsAction κ] (κ ≃+* κ)) →*
      (XAdicIntegers κ ≃+* XAdicIntegers κ) where
  toFun g := xAdicSemidirectValuationEquiv κ g
  map_one' := by
    ext x
    change xAdicSemidirectRatFuncAction κ 1 x = x
    simp
  map_mul' g h := by
    ext x
    change xAdicSemidirectRatFuncAction κ (g * h) x =
      xAdicSemidirectRatFuncAction κ g
        (xAdicSemidirectRatFuncAction κ h x)
    rw [map_mul]
    rfl

theorem xAdicSemidirectValuationAction_apply
    (κ : Type u) [Field κ]
    (g : κˣ ⋊[ringAutUnitsAction κ] (κ ≃+* κ)) :
    xAdicSemidirectValuationAction κ g =
      xAdicSemidirectValuationEquiv κ g := rfl

theorem xAdicSemidirect_fraction_ring
    (κ : Type u) [Field κ]
    (g : κˣ ⋊[ringAutUnitsAction κ] (κ ≃+* κ)) :
    (xAdicSemidirectRatFuncAction κ g).toRingHom.comp
        (algebraMap (XAdicIntegers κ) (RatFunc κ)) =
      (algebraMap (XAdicIntegers κ) (RatFunc κ)).comp
        ((xAdicSemidirectValuationAction κ g).toRingHom) := by
  ext x
  rw [xAdicSemidirectValuationAction_apply]
  rfl

theorem xAdicSemidirect_maps_constants
    (κ : Type u) [Field κ]
    (g : κˣ ⋊[ringAutUnitsAction κ] (κ ≃+* κ)) (a : κ) :
    xAdicSemidirectValuationAction κ g (constToXAdic κ a) =
      constToXAdic κ (g.right a) := by
  apply Subtype.ext
  rw [xAdicSemidirectValuationAction_apply]
  change xAdicSemidirectRatFuncAction κ g
      (algebraMap κ[X] (RatFunc κ) (C a)) =
    algebraMap κ[X] (RatFunc κ) (C (g.right a))
  rw [xAdicSemidirectRatFuncAction_apply,
    xAdicRatFuncEquiv_algebraMap, xAdicPolynomialEquiv_C]

/-- The induced action on the residue field is exactly the coefficient
automorphism; the unit scaling of `X` disappears modulo `X`. -/
theorem xAdicSemidirect_residue
    (κ : Type u) [Field κ]
    (g : κˣ ⋊[ringAutUnitsAction κ] (κ ≃+* κ))
    (x : XAdicIntegers κ) :
    g.right (xAdicResidue κ x) =
      xAdicResidue κ (xAdicSemidirectValuationAction κ g x) := by
  let er := xAdicSemidirectValuationAction κ g
  let a := xAdicResidue κ x
  have hx : x - constToXAdic κ a ∈ maximalIdeal (XAdicIntegers κ) := by
    rw [← xAdicResidue_ker]
    simp [a, xAdicResidue_const]
  have himage : er (x - constToXAdic κ a) ∈
      maximalIdeal (XAdicIntegers κ) := by
    rw [← IsLocalRing.map_ringEquiv_maximalIdeal er]
    exact Ideal.mem_map_of_mem er.toRingHom hx
  have hconst : er (constToXAdic κ a) =
      constToXAdic κ (g.right a) :=
    xAdicSemidirect_maps_constants κ g a
  rw [map_sub, hconst, ← xAdicResidue_ker] at himage
  change g.right (xAdicResidue κ x) = xAdicResidue κ (er x)
  exact (sub_eq_zero.mp (by
    simpa [a, map_sub, xAdicResidue_const] using himage)).symm

theorem xAdicSemidirect_residue_ring
    (κ : Type u) [Field κ]
    (g : κˣ ⋊[ringAutUnitsAction κ] (κ ≃+* κ)) :
    g.right.toRingHom.comp (xAdicResidue κ) =
      (xAdicResidue κ).comp
        ((xAdicSemidirectValuationAction κ g).toRingHom) := by
  ext x
  exact xAdicSemidirect_residue κ g x

/-- Base-ring naturality is reduced to the statement that the residual
coefficient automorphism fixes the chosen base embedding. -/
theorem xAdicSemidirect_base_ring
    (Omega : Type u) [CommRing Omega]
    (κ : Type u) [Field κ]
    (base : Omega →+* κ)
    (g : κˣ ⋊[ringAutUnitsAction κ] (κ ≃+* κ))
    (hbase : ∀ a, g.right (base a) = base a) :
    (xAdicSemidirectValuationAction κ g).toRingHom.comp
        ((constToXAdic κ).comp base) =
      (constToXAdic κ).comp base := by
  ext a
  have h := congrArg (fun z : XAdicIntegers κ ↦ (z : RatFunc κ))
    (xAdicSemidirect_maps_constants κ g (base a))
  simpa [hbase a] using h

end V14Formalization.SchemeGeometry

