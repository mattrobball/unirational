/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import BConicBundleMultisections.GenericConicDescent
public import BConicBundleMultisections.HomogeneousQuadraticEval
public import Mathlib.AlgebraicGeometry.Fiber
public import Mathlib.AlgebraicGeometry.FunctionField
public import Mathlib.AlgebraicGeometry.Morphisms.SchemeTheoreticallyDominant
public import Mathlib.RingTheory.LocalRing.ResidueField.Basic

/-!
# Local flatness bricks for relative plane conics

This file isolates a small algebraic step used by the expected proof that the second projection
of a smooth bidegree-`(2,3)` hypersurface is flat.  On a suitable projective chart, the conic
equation is a binary polynomial.  If the coefficient of a pure power in one affine variable is a
unit and the total degree is bounded by that power, then that coefficient is the leading
coefficient after viewing the equation as a univariate polynomial.  The quotient is consequently
free over the polynomial ring in the other variable, hence flat over the coefficient ring.

The global geometric assembly still has to produce such charts locally on the base.  For a ternary
quadratic this is done classically by choosing a vector where the specialized quadratic is nonzero,
making that vector a homogeneous coordinate, and covering the conic by either of the other two
standard charts.
-/

@[expose] public section

universe u

namespace BConicBundleMultisections

noncomputable section

open MvPolynomial

open AlgebraicGeometry CategoryTheory CategoryTheory.Limits TopologicalSpace

/-! ## Density from a flat integral generic fibre -/

/-- A flat family over an integral base has irreducible total space if its generic fibre is
irreducible.

The generic-point morphism is scheme-theoretically dominant because the base is reduced.  Flat
base change therefore makes the generic fibre dense in the total space.  The closure of the image
of its irreducible underlying space is the whole total space.  This is the topological half of the
usual integrality transport theorem and does not require reducedness of the generic fibre. -/
theorem irreducibleSpace_of_flat_of_irreducibleSpace_genericFiber
    {X S : Scheme.{u}} (f : X ⟶ S) [Flat f] [IsIntegral S]
    [IrreducibleSpace (f.fiber (genericPoint S))] :
    IrreducibleSpace X := by
  let η : S := genericPoint S
  let g : Spec (S.residueField η) ⟶ S := S.fromSpecResidueField η
  haveI hqc_g : QuasiCompact g :=
    ⟨fun _ _ _ ↦ (Set.toFinite _).isCompact⟩
  haveI hdom_g : IsDominant g := by
    rw [isDominant_iff, DenseRange, Scheme.range_fromSpecResidueField,
      dense_iff_closure_eq]
    exact (genericPoint_spec S).def
  haveI hstd_g : IsSchemeTheoreticallyDominant g :=
    IsSchemeTheoreticallyDominant.of_isDominant g
  let p : Limits.pullback (C := Scheme.{u}) f g ⟶ X := pullback.fst f g
  haveI hp_std : IsSchemeTheoreticallyDominant p := by
    dsimp only [p]
    infer_instance
  haveI hp_qc : QuasiCompact p := by
    dsimp only [p]
    infer_instance
  haveI hp_dom : IsDominant p := inferInstance
  haveI hp_irreducible : IrreducibleSpace (Limits.pullback (C := Scheme.{u}) f g) := by
    change IrreducibleSpace (f.fiber (genericPoint S))
    infer_instance
  have hdense : DenseRange p.base := IsDominant.denseRange (f := p)
  have huniv : IsIrreducible
      (Set.univ : Set (Limits.pullback (C := Scheme.{u}) f g)) :=
    IrreducibleSpace.isIrreducible_univ _
  have hrange : IsIrreducible (Set.range ⇑p.base) := by
    simpa [Set.image_univ] using
      huniv.image (⇑p.base) (Scheme.Hom.continuous p).continuousOn
  have hclosure : IsIrreducible (closure (Set.range ⇑p.base)) := hrange.closure
  rw [hdense.closure_range] at hclosure
  exact
    { toPreirreducibleSpace := ⟨hclosure.2⟩
      toNonempty := ⟨hclosure.1.choose⟩ }

/-- Consumer form for an explicit affine conic chart.  If `j : U → X` is an open immersion,
its composite with a flat family `f : X → S` dominates the integral base, and the generic fibre
of `f` is irreducible, then `j` itself is dominant. -/
theorem isDominant_openImmersion_of_comp_isDominant_of_flat_of_irreducibleSpace_genericFiber
    {U X S : Scheme.{u}} (j : U ⟶ X) (f : X ⟶ S)
    [IsOpenImmersion j] [Flat f] [IsIntegral S]
    [IrreducibleSpace (f.fiber (genericPoint S))]
    [IsDominant (j ≫ f)] :
    IsDominant j := by
  letI : IrreducibleSpace X :=
    irreducibleSpace_of_flat_of_irreducibleSpace_genericFiber f
  haveI : Nonempty U := by
    have hdense : DenseRange (j ≫ f).base := IsDominant.denseRange (f := j ≫ f)
    exact hdense.nonempty
  refine ⟨?_⟩
  exact ((Scheme.Hom.isOpenEmbedding j).isOpen_range).dense (Set.range_nonempty _)

/-- A quasi-compact dominant morphism into a reduced base remains dominant after flat base change.
This is the companion needed for the first projection from `X ×_S T`: dominance gives
scheme-theoretic dominance over a reduced target, flat base change preserves it, and
quasi-compact scheme-theoretic dominance implies topological dominance. -/
theorem isDominant_pullback_fst_of_flat_of_isDominant
    {X T S : Scheme.{u}} (f : X ⟶ S) (t : T ⟶ S)
    [Flat f] [IsReduced S] [QuasiCompact t] [IsDominant t] :
    IsDominant (Limits.pullback.fst f t) := by
  haveI : IsSchemeTheoreticallyDominant t :=
    IsSchemeTheoreticallyDominant.of_isDominant t
  haveI : IsSchemeTheoreticallyDominant (Limits.pullback.fst f t) := inferInstance
  haveI : QuasiCompact (Limits.pullback.fst f t) := inferInstance
  infer_instance

/-- If a binary polynomial has total degree at most `d` and its `X₀^d` coefficient is a unit, then
its leading coefficient as a polynomial in `X₀` is a unit. -/
theorem isUnit_leadingCoeff_finSuccEquiv_of_totalDegree_le_of_isUnit_coeff_single
    {A : Type u} [CommRing A] [IsDomain A]
    (g : MvPolynomial (Fin 2) A) (d : ℕ) (hdeg : g.totalDegree ≤ d)
    (hcoeff : IsUnit (g.coeff (Finsupp.single 0 d))) :
    IsUnit (MvPolynomial.finSuccEquiv A 1 g).leadingCoeff := by
  let p : Polynomial (MvPolynomial (Fin 1) A) := MvPolynomial.finSuccEquiv A 1 g
  have hcoeffAt : p.coeff d = MvPolynomial.C (g.coeff (Finsupp.single 0 d)) := by
    have hcoeffAt0 : (p.coeff d).coeff 0 = g.coeff (Finsupp.single 0 d) := by
      dsimp only [p]
      rw [MvPolynomial.finSuccEquiv_coeff_coeff]
      rw [Finsupp.cons_zero_eq_single_zero]
    have hcoeffAt_ne : p.coeff d ≠ 0 := by
      intro hzero
      have : (p.coeff d).coeff 0 = 0 := by rw [hzero, MvPolynomial.coeff_zero]
      exact hcoeff.ne_zero (hcoeffAt0.symm.trans this)
    have htd : (p.coeff d).totalDegree = 0 := by
      have hbound := MvPolynomial.totalDegree_coeff_finSuccEquiv_add_le g d hcoeffAt_ne
      change (p.coeff d).totalDegree + d ≤ g.totalDegree at hbound
      omega
    rw [(MvPolynomial.totalDegree_eq_zero_iff_eq_C.mp htd), hcoeffAt0]
  have hpNatDegree_le : p.natDegree ≤ d := by
    calc
      p.natDegree = MvPolynomial.degreeOf 0 g := MvPolynomial.natDegree_finSuccEquiv g
      _ ≤ g.totalDegree := MvPolynomial.degreeOf_le_totalDegree g 0
      _ ≤ d := hdeg
  have hpCoeff_ne : p.coeff d ≠ 0 := by
    rw [hcoeffAt]
    exact MvPolynomial.C_ne_zero.mpr hcoeff.ne_zero
  have hpNatDegree : p.natDegree = d :=
    Polynomial.natDegree_eq_of_le_of_coeff_ne_zero hpNatDegree_le hpCoeff_ne
  change IsUnit p.leadingCoeff
  rw [Polynomial.leadingCoeff, hpNatDegree, hcoeffAt]
  exact hcoeff.map MvPolynomial.C

/-- A binary hypersurface chart with a unit pure top-degree coefficient is flat over its
coefficient ring.  This is the form directly consumed after a projective coordinate choice. -/
theorem flat_binaryChartQuotient_of_totalDegree_le_of_isUnit_coeff_single
    {A : Type u} [CommRing A] [IsDomain A]
    (g : MvPolynomial (Fin 2) A) (d : ℕ) (hdeg : g.totalDegree ≤ d)
    (hcoeff : IsUnit (g.coeff (Finsupp.single 0 d))) :
    Module.Flat A (MvPolynomial (Fin 2) A ⧸ Ideal.span {g}) := by
  apply flat_binaryChartQuotient_of_isUnit_leadingCoeff
  exact isUnit_leadingCoeff_finSuccEquiv_of_totalDegree_le_of_isUnit_coeff_single
    g d hdeg hcoeff

/-! ## A finite coordinate pivot for ternary quadratics -/

private theorem finThree_degree_two_cases (s : Fin 3 →₀ ℕ)
    (h : ∑ i : Fin 3, s i = 2) :
    s = Finsupp.single (0 : Fin 3) 2 ∨
      s = Finsupp.single (1 : Fin 3) 2 ∨
      s = Finsupp.single (2 : Fin 3) 2 ∨
      s = Finsupp.single (0 : Fin 3) 1 + Finsupp.single 1 1 ∨
      s = Finsupp.single (0 : Fin 3) 1 + Finsupp.single 2 1 ∨
      s = Finsupp.single (1 : Fin 3) 1 + Finsupp.single 2 1 := by
  have hsum : s 0 + s 1 + s 2 = 2 := by
    rwa [Fin.sum_univ_three (fun i ↦ s i)] at h
  have : s 0 ≤ 2 := by omega
  have : s 1 ≤ 2 := by omega
  have : s 2 ≤ 2 := by omega
  interval_cases h0 : s 0 <;> interval_cases h1 : s 1 <;> interval_cases h2 : s 2
  all_goals try omega
  · refine Or.inr (Or.inr (Or.inl ?_))
    ext i
    fin_cases i <;> simp_all
  · refine Or.inr (Or.inr (Or.inr (Or.inr (Or.inr ?_))))
    ext i
    fin_cases i <;> simp_all
  · refine Or.inr (Or.inl ?_)
    ext i
    fin_cases i <;> simp_all
  · refine Or.inr (Or.inr (Or.inr (Or.inr (Or.inl ?_))))
    ext i
    fin_cases i <;> simp_all
  · refine Or.inr (Or.inr (Or.inr (Or.inl ?_)))
    ext i
    fin_cases i <;> simp_all
  · refine Or.inl ?_
    ext i
    fin_cases i <;> simp_all

/-- Six fixed vectors detect a nonzero homogeneous ternary quadratic: one of the three basis
vectors or one of the three pairwise sums has nonzero value.  This is the finite coordinate
selection used in the local flatness proof; importantly, it requires no division by `2`. -/
theorem exists_eval_basis_or_pair_ne_zero
    {A : Type u} [CommRing A] {Q : MvPolynomial (Fin 3) A}
    (hQ : Q.IsHomogeneous 2) (hQ0 : Q ≠ 0) :
    (∃ i : Fin 3, eval (Pi.single i 1) Q ≠ 0) ∨
      ∃ i j : Fin 3, i < j ∧ eval (Pi.single i 1 + Pi.single j 1) Q ≠ 0 := by
  classical
  obtain ⟨d, hd⟩ := MvPolynomial.exists_coeff_ne_zero hQ0
  have hdDegree : d.degree = 2 := by
    by_contra hne
    exact hd (hQ.coeff_eq_zero hne)
  have hdSum : ∑ i : Fin 3, d i = 2 := by
    rwa [← Finsupp.degree_eq_sum]
  rcases finThree_degree_two_cases d hdSum with rfl | rfl | rfl | rfl | rfl | rfl
  · left
    refine ⟨0, ?_⟩
    simpa [eval_eq_ternaryQuadraticCoeff_sum hQ, ternaryQuadraticCoeff,
      Fin.sum_univ_three, Pi.single_apply] using hd
  · left
    refine ⟨1, ?_⟩
    simpa [eval_eq_ternaryQuadraticCoeff_sum hQ, ternaryQuadraticCoeff,
      Fin.sum_univ_three, Pi.single_apply] using hd
  · left
    refine ⟨2, ?_⟩
    simpa [eval_eq_ternaryQuadraticCoeff_sum hQ, ternaryQuadraticCoeff,
      Fin.sum_univ_three, Pi.single_apply] using hd
  · by_cases h0 : eval (Pi.single (0 : Fin 3) 1) Q = 0
    · by_cases h1 : eval (Pi.single (1 : Fin 3) 1) Q = 0
      · right
        refine ⟨0, 1, by decide, ?_⟩
        rw [eval_eq_ternaryQuadraticCoeff_sum hQ] at h0 h1 ⊢
        simp only [ternaryQuadraticCoeff, Fin.sum_univ_three, Pi.single_apply] at h0 h1 ⊢
        norm_num at h0 h1 ⊢
        grind
      · exact Or.inl ⟨1, h1⟩
    · exact Or.inl ⟨0, h0⟩
  · by_cases h0 : eval (Pi.single (0 : Fin 3) 1) Q = 0
    · by_cases h2 : eval (Pi.single (2 : Fin 3) 1) Q = 0
      · right
        refine ⟨0, 2, by decide, ?_⟩
        rw [eval_eq_ternaryQuadraticCoeff_sum hQ] at h0 h2 ⊢
        simp only [ternaryQuadraticCoeff, Fin.sum_univ_three, Pi.single_apply] at h0 h2 ⊢
        norm_num at h0 h2 ⊢
        grind
      · exact Or.inl ⟨2, h2⟩
    · exact Or.inl ⟨0, h0⟩
  · by_cases h1 : eval (Pi.single (1 : Fin 3) 1) Q = 0
    · by_cases h2 : eval (Pi.single (2 : Fin 3) 1) Q = 0
      · right
        refine ⟨1, 2, by decide, ?_⟩
        rw [eval_eq_ternaryQuadraticCoeff_sum hQ] at h1 h2 ⊢
        simp only [ternaryQuadraticCoeff, Fin.sum_univ_three, Pi.single_apply] at h1 h2 ⊢
        norm_num at h1 h2 ⊢
        grind
      · exact Or.inl ⟨2, h2⟩
    · exact Or.inl ⟨1, h1⟩

/-- Local-ring form of `exists_eval_basis_or_pair_ne_zero`.  If the residue quadratic is
nonzero, one of the same six values is a unit upstairs.  Thus a single one of six constant
linear coordinate changes supplies a unit pure-square coefficient near any chosen base point. -/
theorem exists_isUnit_eval_basis_or_pair_of_map_residue_ne_zero
    {A : Type u} [CommRing A] [IsLocalRing A]
    {Q : MvPolynomial (Fin 3) A} (hQ : Q.IsHomogeneous 2)
    (hQres : MvPolynomial.map (IsLocalRing.residue A) Q ≠ 0) :
    (∃ i : Fin 3, IsUnit (eval (Pi.single i 1) Q)) ∨
      ∃ i j : Fin 3, i < j ∧ IsUnit (eval (Pi.single i 1 + Pi.single j 1) Q) := by
  classical
  have htests := exists_eval_basis_or_pair_ne_zero
    (hQ.map (IsLocalRing.residue A)) hQres
  rcases htests with ⟨i, hi⟩ | ⟨i, j, hij, hijQ⟩
  · left
    refine ⟨i, (IsLocalRing.residue_ne_zero_iff_isUnit _).mp ?_⟩
    have hvec : (IsLocalRing.residue A) ∘ (Pi.single i (1 : A)) =
        Pi.single i (1 : IsLocalRing.ResidueField A) := by
      funext k
      simp [Pi.single_apply]
    rw [MvPolynomial.map_eval, hvec]
    exact hi
  · right
    refine ⟨i, j, hij, (IsLocalRing.residue_ne_zero_iff_isUnit _).mp ?_⟩
    have hvec : (IsLocalRing.residue A) ∘
        (Pi.single i (1 : A) + Pi.single j 1) =
        Pi.single i (1 : IsLocalRing.ResidueField A) + Pi.single j 1 := by
      funext k
      simp [Pi.single_apply]
    rw [MvPolynomial.map_eval, hvec]
    exact hijQ

end

end BConicBundleMultisections
