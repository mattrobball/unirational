/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import BConicBundleMultisections.ChartHomogenization
public import Mathlib.Algebra.MvPolynomial.Nilpotent
public import Mathlib.Algebra.MvPolynomial.NoZeroDivisors
public import Mathlib.RingTheory.Ideal.Quotient.Basic

/-!
# Affine charts of an irreducible projective hypersurface

Dehomogenizing an irreducible homogeneous form on a standard projective chart gives either a
unit (the chart misses the hypersurface) or an irreducible affine equation.  Consequently every
nonempty standard chart has a domain coordinate ring.

This is the general-degree counterpart of the ternary-quadratic chart lemma in
`HomogeneousJacobianChart`.  It is useful for the irreducible target relation `H`, whose degree is
not fixed in advance.
-/

@[expose] public section

namespace BConicBundleMultisections

noncomputable section

universe u

open MvPolynomial

namespace ProjectiveSpace

variable {K : Type u} [Field K]

/-- Raising the homogenization degree only pads by a power of the chart variable. -/
theorem chartHomogenization_degree_change
    {n : ℕ} (i : Fin (n + 1)) (e d : ℕ) (p : MvPolynomial (Fin n) K)
    (hed : e ≤ d) (hp : p.totalDegree ≤ e) :
    chartHomogenization (R := K) i d p =
      X i ^ (d - e) * chartHomogenization (R := K) i e p := by
  let L := chartHomogenization (R := K) i d p
  let R := X i ^ (d - e) * chartHomogenization (R := K) i e p
  have hL : L.IsHomogeneous d := chartHomogenization_isHomogeneous i d p
  have hR : R.IsHomogeneous d := by
    have hXi : (X i ^ (d - e) : MvPolynomial (Fin (n + 1)) K).IsHomogeneous (d - e) :=
      by simpa only [one_mul] using (isHomogeneous_X K i).pow (d - e)
    simpa [R, Nat.sub_add_cancel hed] using
      hXi.mul (chartHomogenization_isHomogeneous i e p)
  have hdehL : chartDehomogenization n K i L = p := by
    exact chartDehomogenization_chartHomogenization i d p (hp.trans hed)
  have hdehR : chartDehomogenization n K i R = p := by
    dsimp only [R]
    rw [map_mul, map_pow, chartDehomogenization_X_self, one_pow, one_mul,
      chartDehomogenization_chartHomogenization i e p hp]
  have hdiff : chartDehomogenization n K i (L - R) = 0 := by
    rw [map_sub, hdehL, hdehR, sub_self]
  have hdiffHom : (L - R).IsHomogeneous d := hL.sub hR
  exact sub_eq_zero.mp
    (chartDehomogenization_eq_zero_of_isHomogeneous n i d (L - R) hdiffHom hdiff)

private theorem X_not_isUnit {n : ℕ} (i : Fin (n + 1)) :
    ¬ IsUnit (X i : MvPolynomial (Fin (n + 1)) K) := by
  intro h
  have hdegree := (isUnit_iff_totalDegree_of_isReduced.mp h).2
  rw [totalDegree_X] at hdegree
  omega

/-- An affine chart equation of an irreducible homogeneous form is either irreducible or a unit.
The unit case is exactly an empty chart of the projective hypersurface. -/
theorem irreducible_or_isUnit_chartDehomogenization
    {n d : ℕ} (i : Fin (n + 1)) (H : MvPolynomial (Fin (n + 1)) K)
    (hH : H.IsHomogeneous d) (hHirr : Irreducible H) :
    Irreducible (chartDehomogenization n K i H) ∨
      IsUnit (chartDehomogenization n K i H) := by
  let g := chartDehomogenization n K i H
  by_cases hgUnit : IsUnit g
  · exact Or.inr hgUnit
  left
  have hg0 : g ≠ 0 := by
    intro hg
    apply hHirr.ne_zero
    apply chartDehomogenization_eq_zero_of_isHomogeneous n i d H hH
    simpa only [g] using hg
  have hrec : chartHomogenization (R := K) i d g = H :=
    chartHomogenization_chartDehomogenization i d H hH
  have hgd : g.totalDegree ≤ d :=
    totalDegree_chartDehomogenization_of_isHomogeneous i d H hH
  have hdegree : g.totalDegree = d := by
    apply le_antisymm hgd
    by_contra hnot
    have hlt : g.totalDegree < d := lt_of_not_ge hnot
    have hfac : H = X i ^ (d - g.totalDegree) *
        chartHomogenization (R := K) i g.totalDegree g := by
      rw [← hrec]
      exact chartHomogenization_degree_change i g.totalDegree d g hgd le_rfl
    rcases (irreducible_iff.mp hHirr).2 hfac with hpow | hhom
    · have hne : d - g.totalDegree ≠ 0 := (Nat.sub_pos_of_lt hlt).ne'
      exact (X_not_isUnit i) ((isUnit_pow_iff hne).mp hpow)
    · apply hgUnit
      have hmap : IsUnit
          (chartDehomogenization n K i
            (chartHomogenization (R := K) i g.totalDegree g)) :=
        hhom.map (chartDehomogenization n K i)
      rwa [chartDehomogenization_chartHomogenization i g.totalDegree g le_rfl] at hmap
  refine (irreducible_iff).mpr ⟨hgUnit, ?_⟩
  intro a b hab
  have habg : g = a * b := by simpa only [g] using hab
  have ha0 : a ≠ 0 := by
    intro ha
    rw [ha, zero_mul] at habg
    exact hg0 habg
  have hb0 : b ≠ 0 := by
    intro hb
    rw [hb, mul_zero] at habg
    exact hg0 habg
  have habDegree : a.totalDegree + b.totalDegree = d := by
    rw [← hdegree, habg]
    exact (totalDegree_mul_of_isDomain ha0 hb0).symm
  have hfac : H =
      chartHomogenization (R := K) i a.totalDegree a *
        chartHomogenization (R := K) i b.totalDegree b := by
    rw [← hrec, habg, ← habDegree]
    exact chartHomogenization_mul i a.totalDegree b.totalDegree a b le_rfl le_rfl
  rcases (irreducible_iff.mp hHirr).2 hfac with haUnit | hbUnit
  · left
    have hmap := haUnit.map (chartDehomogenization n K i)
    rwa [chartDehomogenization_chartHomogenization i a.totalDegree a le_rfl] at hmap
  · right
    have hmap := hbUnit.map (chartDehomogenization n K i)
    rwa [chartDehomogenization_chartHomogenization i b.totalDegree b le_rfl] at hmap

/-- On a nonempty chart, dehomogenizing an irreducible homogeneous form preserves its degree.

If the degree dropped, rehomogenization would exhibit the original form as a positive power of
the chart variable times a nonunit, contradicting irreducibility. -/
theorem totalDegree_chartDehomogenization_eq_of_irreducible_of_not_isUnit
    {n d : ℕ} (i : Fin (n + 1)) (H : MvPolynomial (Fin (n + 1)) K)
    (hH : H.IsHomogeneous d) (hHirr : Irreducible H)
    (hnonempty : ¬ IsUnit (chartDehomogenization n K i H)) :
    (chartDehomogenization n K i H).totalDegree = d := by
  let g := chartDehomogenization n K i H
  have hrec : chartHomogenization (R := K) i d g = H :=
    chartHomogenization_chartDehomogenization i d H hH
  have hgd : g.totalDegree ≤ d :=
    totalDegree_chartDehomogenization_of_isHomogeneous i d H hH
  apply le_antisymm hgd
  by_contra hnot
  have hlt : g.totalDegree < d := lt_of_not_ge hnot
  have hfac : H = X i ^ (d - g.totalDegree) *
      chartHomogenization (R := K) i g.totalDegree g := by
    rw [← hrec]
    exact chartHomogenization_degree_change i g.totalDegree d g hgd le_rfl
  rcases (irreducible_iff.mp hHirr).2 hfac with hpow | hhom
  · have hne : d - g.totalDegree ≠ 0 := (Nat.sub_pos_of_lt hlt).ne'
    exact (X_not_isUnit i) ((isUnit_pow_iff hne).mp hpow)
  · apply hnonempty
    have hmap : IsUnit
        (chartDehomogenization n K i
          (chartHomogenization (R := K) i g.totalDegree g)) :=
      hhom.map (chartDehomogenization n K i)
    rwa [chartDehomogenization_chartHomogenization i g.totalDegree g le_rfl] at hmap

/-- Divisibility between homogeneous forms is detected on every nonempty affine chart of an
irreducible hypersurface.  Equivalently, if `H ∤ D`, then the residue of the dehomogenization of
`D` modulo the chart equation of `H` is nonzero.

The degree bookkeeping is essential: homogenizing a putative affine factorization introduces
only a power of the chart variable, and that power belongs to the complementary factor. -/
theorem not_dvd_chartDehomogenization_of_irreducible
    {n d e : ℕ} (i : Fin (n + 1))
    (H D : MvPolynomial (Fin (n + 1)) K)
    (hH : H.IsHomogeneous d) (hHirr : Irreducible H)
    (hD : D.IsHomogeneous e)
    (hnonempty : ¬ IsUnit (chartDehomogenization n K i H))
    (hnot : ¬ H ∣ D) :
    ¬ chartDehomogenization n K i H ∣ chartDehomogenization n K i D := by
  intro hdvd
  apply hnot
  let h := chartDehomogenization n K i H
  let q := chartDehomogenization n K i D
  obtain ⟨a, ha⟩ := hdvd
  have hqeq : q = h * a := by simpa only [h, q] using ha
  by_cases hq0 : q = 0
  · have hD0 : D = 0 := by
      apply chartDehomogenization_eq_zero_of_isHomogeneous n i e D hD
      simpa only [q] using hq0
    rw [hD0]
    exact dvd_zero H
  have hh0 : h ≠ 0 := by
    intro hh0
    apply hq0
    rw [hqeq, hh0, zero_mul]
  have ha0 : a ≠ 0 := by
    intro ha0
    apply hq0
    rw [hqeq, ha0, mul_zero]
  have hhdeg : h.totalDegree = d := by
    simpa only [h] using
      totalDegree_chartDehomogenization_eq_of_irreducible_of_not_isUnit
        i H hH hHirr hnonempty
  have hqdeg : q.totalDegree ≤ e := by
    simpa only [q] using totalDegree_chartDehomogenization_of_isHomogeneous i e D hD
  have hsumle : d + a.totalDegree ≤ e := by
    rw [← hhdeg, ← totalDegree_mul_of_isDomain hh0 ha0, ← hqeq]
    exact hqdeg
  let b := X i ^ (e - (d + a.totalDegree)) *
    chartHomogenization (R := K) i a.totalDegree a
  refine ⟨b, ?_⟩
  have hproddeg : (h * a).totalDegree ≤ d + a.totalDegree := by
    rw [totalDegree_mul_of_isDomain hh0 ha0, hhdeg]
  have hrecH : chartHomogenization (R := K) i d h = H := by
    simpa only [h] using chartHomogenization_chartDehomogenization i d H hH
  have hrecD : chartHomogenization (R := K) i e q = D := by
    simpa only [q] using chartHomogenization_chartDehomogenization i e D hD
  rw [← hrecD, hqeq,
    chartHomogenization_degree_change i (d + a.totalDegree) e (h * a)
      hsumle hproddeg,
    chartHomogenization_mul i d a.totalDegree h a hhdeg.le le_rfl,
    hrecH]
  dsimp only [b]
  ac_rfl

/-- Quotient-ring form of
`not_dvd_chartDehomogenization_of_irreducible`. -/
theorem quotient_mk_chartDehomogenization_ne_zero_of_not_dvd
    {n d e : ℕ} (i : Fin (n + 1))
    (H D : MvPolynomial (Fin (n + 1)) K)
    (hH : H.IsHomogeneous d) (hHirr : Irreducible H)
    (hD : D.IsHomogeneous e)
    (hnonempty : ¬ IsUnit (chartDehomogenization n K i H))
    (hnot : ¬ H ∣ D) :
    Ideal.Quotient.mk (Ideal.span {chartDehomogenization n K i H})
        (chartDehomogenization n K i D) ≠ 0 := by
  intro hz
  apply not_dvd_chartDehomogenization_of_irreducible
    i H D hH hHirr hD hnonempty hnot
  exact Ideal.mem_span_singleton.mp (Ideal.Quotient.eq_zero_iff_mem.mp hz)

/-- A nonempty affine chart of an irreducible projective hypersurface has a domain coordinate
ring.  Nonemptiness is expressed algebraically by the dehomogenized equation not being a unit. -/
theorem isDomain_chartDehomogenization_quotient_of_irreducible
    {n d : ℕ} (i : Fin (n + 1)) (H : MvPolynomial (Fin (n + 1)) K)
    (hH : H.IsHomogeneous d) (hHirr : Irreducible H)
    (hnonempty : ¬ IsUnit (chartDehomogenization n K i H)) :
    IsDomain
      (MvPolynomial (Fin n) K ⧸ Ideal.span {chartDehomogenization n K i H}) := by
  have hgirr : Irreducible (chartDehomogenization n K i H) :=
    (irreducible_or_isUnit_chartDehomogenization i H hH hHirr).resolve_right hnonempty
  letI : (Ideal.span {chartDehomogenization n K i H}).IsPrime :=
    (Ideal.span_singleton_prime hgirr.ne_zero).mpr hgirr.prime
  infer_instance

end ProjectiveSpace

end

end BConicBundleMultisections
