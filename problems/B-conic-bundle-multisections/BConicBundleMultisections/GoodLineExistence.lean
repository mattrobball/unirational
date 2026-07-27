/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import BConicBundleMultisections.LinearSubstitutionNonsingular
public import BConicBundleMultisections.GoodLine
public import BConicBundleMultisections.ProjectiveCommonZero
public import BConicBundleMultisections.ResidualHorizontalityLine
public import BConicBundleMultisections.ResidualLineBasePointFree
public import BConicBundleMultisections.StereoJacobian
public import BConicBundleMultisections.Standard.ResidualLineMapInjective
public import Mathlib.Algebra.MvPolynomial.Funext

/-!
# Existence of a good multisection line

Work package WP-G of `PLAN.md`, second half.  `GoodLine.lean` proves §1(b) for the *degenerate*
factorisation `F = Q(x)·f₀(y)`; this module proves the same obstruction for a **pencil**
`F = A(x)·f₀(y) + B(x)·f₁(y)`, and then assembles the good-line existence statement.

## The pencil finish

Two conics in `ℙ²` always meet, so the quadratic forms `A` and `B` have a common nonzero zero `x₀`.
The entire cubic fibre of `X` over `x₀` is then the whole of `ℙ²_y`, which a smooth `X` forbids
(`not_specializeFirstCoordinates_eq_zero_of_smooth_bidegree23`).  This is exactly the argument of
`not_eq_rename_mul_rename_of_smooth` with one equation replaced by two.

**The boundary is sharp.**  The same argument for a *net* `A·f₀ + B·f₁ + C·f₂` would need three
conics in `ℙ²` to have a common zero, which is false.  Nothing here generalises past a pencil, and
nothing downstream should try to.

## The reduction, and what it drops

`exists_good_line` is proved by contradiction from the following chain.  Suppose every `k`-rational
line `L` is bad, i.e. `ResidualLineConstantOn` holds for every frame (every matrix is a frame,
`lineFrame_of_matrix`).

1. **Bridge**, proved:
   `hasCommonResidualLineMap_specializeFirstCoordinates_of_forall_residualLineConstantOn`.
   Badness of `L` says the three degree-ten coefficient forms of `δ_{C_x}(L)` are
   `c_a · g` for constants `c_a`; evaluating at `x` makes `δ_{C_x}(L)` the fixed linear form
   `∑ c_a y_a` scaled by `g(x)`.  So all the cubic fibres have the same residual-line map.
2. **Generic smoothness** (§1, proved).  Off a nonzero certificate polynomial `D` the fibre `C_x`
   is a smooth plane cubic.
3. **Residual-map rigidity** (§2, proved —
   `Standard.exists_pencil_of_hasCommonResidualLineMap`).  A checked Hesse-normal-form and finite
   residual-covariant certificate put smooth plane cubics with a common residual-line map in one
   pencil (in fact in one projective scalar class).
4. **Pencil coordinates are quadratic forms** (`exists_isHomogeneous_pencil_coefficients`, proved).
   A dual basis for the pencil reads the coordinates off as second-block coefficients of `F`, which
   are homogeneous of degree two because `F` has bidegree `(2,3)`.
5. **Descent** (`eq_pencil_of_forall_specializeFirstCoordinates`, proved) and the pencil finish.

The source instead reaches this contradiction through §3: it shows `δ_C` is not defined over `k`
and applies its Lemma 3.1 (constant-values descent through `k`-derivations of `K/k`) to extract a
good `L`.  **Lemma 3.1 is not used here.**  Step 1 works with honest fibres `C_x` over `k`-points
rather than with the generic fibre `C_η`, so no descent from `K = k(ℙ²_x)` to `k` is ever performed;
what replaces it is that the *hypothesis* being contradicted already quantifies over `k`-rational
lines, and `ResidualLineConstantOn` is a statement about polynomials in `x`, not about a single
fibre.  Lemma 3.1 is doing work in the source for §5's degree bookkeeping over `k`, which this
development does not claim.

The conclusion supplied here is condition **G3** only.  The source's separate conditions (2) and
(3), that the generic intersection `C ∩ L` be reduced and that `[-2]` be injective on its three
points, are neither stated nor proved by `exists_good_line`; they remain a separate strengthening
if source-faithful birationality of the vertical surface is required.
-/

@[expose] public section

open scoped AlgebraicGeometry

namespace BConicBundleMultisections

noncomputable section

universe u

open AlgebraicGeometry MvPolynomial BiprojectiveSpace
open _root_.MvPolynomial

variable {k : Type u} [Field k]

/-! ### §1(b) for a pencil -/

/--
**The cubic fibration of a smooth `(2,3)` hypersurface does not lie in a pencil.**

If `F = A(x)·f₀(y) + B(x)·f₁(y)` with `A, B` quadratic forms in `x`, then every cubic fibre `C_x`
lies in the fixed pencil `⟨f₀, f₁⟩` of plane cubics.  Two conics in `ℙ²` always have a common
point, so there is `x₀ ≠ 0` with `A(x₀) = B(x₀) = 0`; the cubic fibre over `x₀` is then identically
zero, i.e. the whole of `ℙ²_y` lies in `X`, and
`not_specializeFirstCoordinates_eq_zero_of_smooth_bidegree23` says a smooth `X` has no such fibre.

Source: `certificates/all_smooth_tangent_residual_theorem.md` §1, second half — there stated for
the rank-one degeneration `F = Q(x) f₀(y)` (that case is `not_eq_rename_mul_rename_of_smooth`), and
used again in §3 for the pencil that Lemma 2.1 produces.

Only homogeneity of `A` and `B` is used; no hypothesis on `f₀`, `f₁` is needed, and neither `A` nor
`B` has to be nonzero.

**Do not generalise this to a net.**  `exists_common_nonzero_zero_pair` is a statement about *two*
forms in three homogeneous coordinates; three conics in `ℙ²` need not meet, and the conclusion is
false for a net (a general net of plane cubics has no member with a whole-fibre degeneration).
-/
theorem not_eq_pencil_of_smooth [IsAlgClosed k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (biprojectiveZeroLocusToSpec 2 2 k F)]
    (A B f₀ f₁ : MvPolynomial (Fin 3) k)
    (hA : A.IsHomogeneous 2) (hB : B.IsHomogeneous 2) :
    F ≠ rename Sum.inl A * rename Sum.inr f₀ + rename Sum.inl B * rename Sum.inr f₁ := by
  intro hsplit
  obtain ⟨x, hx0, hxA, hxB⟩ :=
    exists_common_nonzero_zero_pair hA hB (by norm_num) (by norm_num) (by simp)
  obtain ⟨i, hi⟩ := exists_normalizing_coordinate x hx0
  have hx1i : normalizeCoordinateRepresentative x i i = 1 :=
    normalizeCoordinateRepresentative_apply x i hi
  have hx1A : eval (normalizeCoordinateRepresentative x i) A = 0 :=
    eval_normalizeCoordinateRepresentative_eq_zero hA x i hxA
  have hx1B : eval (normalizeCoordinateRepresentative x i) B = 0 :=
    eval_normalizeCoordinateRepresentative_eq_zero hB x i hxB
  refine not_specializeFirstCoordinates_eq_zero_of_smooth_bidegree23 k F hF hF0 i
    (normalizeCoordinateRepresentative x i) hx1i ?_
  rw [hsplit, map_add, map_mul, map_mul,
    specializeFirstCoordinates_rename_inl, specializeFirstCoordinates_rename_inr,
    specializeFirstCoordinates_rename_inl, specializeFirstCoordinates_rename_inr,
    hx1A, hx1B, map_zero, zero_mul, zero_mul, add_zero]

/-! ### Reading the second-block linear coefficients

`residualLineCoeffOn` is defined through `ResidualDivisor.secondBlockCoeff`, which nothing in the
tree had ever unfolded.  Condition **G3** is a statement about those coefficients, while everything
downstream — `eval_residualEquationOn` in particular — is about the residual *line* `δ_{C_x}(L)` of
the cubic fibre.  The lemmas here connect the two: the residual equation along `L` is linear in the
second block, and its coefficients are exactly `residualLineCoeffOn`.
-/

namespace ResidualDivisor

variable {R : Type u} [CommRing R]

/-- The biprojective multi-index with first block `n` and second block `m`.  Inverse to the pair
`(firstPart, secondPart)`. -/
def biIndex (n m : Fin 3 →₀ ℕ) : BiprojectiveCoordinate 2 2 →₀ ℕ :=
  Finsupp.equivFunOnFinite.symm (Sum.elim ⇑n ⇑m)

@[simp] theorem biIndex_apply_inl (n m : Fin 3 →₀ ℕ) (j : Fin 3) :
    biIndex n m (.inl j) = n j := by simp [biIndex]

@[simp] theorem biIndex_apply_inr (n m : Fin 3 →₀ ℕ) (j : Fin 3) :
    biIndex n m (.inr j) = m j := by simp [biIndex]

@[simp] theorem firstPart_biIndex (n m : Fin 3 →₀ ℕ) : firstPart (biIndex n m) = n := by
  ext j; simp

@[simp] theorem secondPart_biIndex (n m : Fin 3 →₀ ℕ) : secondPart (biIndex n m) = m := by
  ext j; simp

theorem biIndex_firstPart_secondPart (d : BiprojectiveCoordinate 2 2 →₀ ℕ) :
    biIndex (firstPart d) (secondPart d) = d := by
  ext z; cases z <;> simp

theorem eq_biIndex_iff (d : BiprojectiveCoordinate 2 2 →₀ ℕ) (n m : Fin 3 →₀ ℕ) :
    d = biIndex n m ↔ secondPart d = m ∧ firstPart d = n := by
  constructor
  · rintro rfl; simp
  · rintro ⟨h1, h2⟩
    conv_lhs => rw [← biIndex_firstPart_secondPart d]
    rw [h1, h2]

/-- **`secondBlockCoeff` is a coefficient of `F`.**  Extracting the `y^m` coefficient and then the
`x^n` coefficient reads off the single biprojective coefficient at the multi-index with those two
blocks. -/
theorem coeff_secondBlockCoeff (F : MvPolynomial (BiprojectiveCoordinate 2 2) R)
    (m n : Fin 3 →₀ ℕ) :
    coeff n (secondBlockCoeff F m) = coeff (biIndex n m) F := by
  classical
  rw [secondBlockCoeff, coeff_sum]
  have h : ∀ d ∈ F.support,
      coeff n (if secondPart d = m then monomial (firstPart d) (coeff d F) else 0)
        = if d = biIndex n m then coeff d F else 0 := by
    intro d _
    by_cases h1 : secondPart d = m
    · by_cases h2 : firstPart d = n
      · have hd : d = biIndex n m := (eq_biIndex_iff d n m).mpr ⟨h1, h2⟩
        rw [if_pos h1, coeff_monomial, if_pos h2, if_pos hd]
      · have hd : d ≠ biIndex n m := fun h => h2 (by rw [h]; simp)
        rw [if_pos h1, coeff_monomial, if_neg h2, if_neg hd]
    · have hd : d ≠ biIndex n m := fun h => h1 (by rw [h]; simp)
      rw [if_neg h1, coeff_zero, if_neg hd]
  rw [Finset.sum_congr rfl h,
    Finset.sum_ite_eq' F.support (biIndex n m) fun d => coeff d F]
  split_ifs with hmem
  · rfl
  · exact (notMem_support_iff.mp hmem).symm

theorem secondBlockCoeff_sum {ι : Type*} (s : Finset ι)
    (F : ι → MvPolynomial (BiprojectiveCoordinate 2 2) R) (m : Fin 3 →₀ ℕ) :
    secondBlockCoeff (∑ i ∈ s, F i) m = ∑ i ∈ s, secondBlockCoeff (F i) m := by
  ext n
  simp [coeff_secondBlockCoeff, coeff_sum]

theorem biIndex_sub_single_inr (n m : Fin 3 →₀ ℕ) (j : Fin 3) :
    biIndex n m - Finsupp.single (Sum.inr j : BiprojectiveCoordinate 2 2) 1
      = biIndex n (m - Finsupp.single j 1) := by
  ext z
  cases z with
  | inl i => simp [Finsupp.tsub_apply]
  | inr l => simp [Finsupp.tsub_apply, Finsupp.single_apply]

theorem biIndex_zero_right (n : Fin 3 →₀ ℕ) :
    biIndex n 0 = Finsupp.mapDomain (Sum.inl : Fin 3 → BiprojectiveCoordinate 2 2) n := by
  ext z
  cases z with
  | inl i => simp [Finsupp.mapDomain_apply Sum.inl_injective]
  | inr l => simp [Finsupp.mapDomain_notin_range]

/-- **The second-block coefficients of a linear lift.**  `liftSecondLinear p j` is `p(x)·y_j`, so
its `y^m` coefficient is `p` when `m` is the exponent of `y_j` and zero otherwise. -/
theorem secondBlockCoeff_liftSecondLinear (p : MvPolynomial (Fin 3) R) (j : Fin 3)
    (m : Fin 3 →₀ ℕ) :
    secondBlockCoeff (liftSecondLinear p j) m = if m = Finsupp.single j 1 then p else 0 := by
  classical
  by_cases hm : m = Finsupp.single j 1
  · subst hm
    rw [if_pos rfl]
    ext n
    rw [coeff_secondBlockCoeff, liftSecondLinear, liftFirstBlock, coeff_mul_X', if_pos,
      biIndex_sub_single_inr, tsub_self, biIndex_zero_right,
      coeff_rename_mapDomain _ Sum.inl_injective]
    simp [Finsupp.mem_support_iff]
  · rw [if_neg hm]
    ext n
    rw [coeff_secondBlockCoeff, coeff_zero, liftSecondLinear, liftFirstBlock, coeff_mul_X']
    split_ifs with hmem
    · have hmj : m j ≠ 0 := by simpa [Finsupp.mem_support_iff] using hmem
      have hne : m - Finsupp.single j 1 ≠ 0 := by
        intro h0
        refine hm (Finsupp.ext fun i => ?_)
        have hi := DFunLike.congr_fun h0 i
        rw [Finsupp.tsub_apply] at hi
        simp only [Finsupp.coe_zero, Pi.zero_apply] at hi
        rcases eq_or_ne i j with rfl | hij
        · rw [Finsupp.single_eq_same] at hi ⊢; omega
        · rw [Finsupp.single_eq_of_ne hij] at hi ⊢; omega
      obtain ⟨l, hl⟩ := Finsupp.ne_iff.mp hne
      rw [biIndex_sub_single_inr]
      refine coeff_rename_eq_zero _ _ _ fun u hu => ?_
      exfalso
      have hval := DFunLike.congr_fun hu (Sum.inr l)
      rw [Finsupp.mapDomain_notin_range u (Sum.inr l) (by simp), biIndex_apply_inr] at hval
      exact hl (by simpa using hval.symm)
    · rfl

theorem liftSecondLinear_sum {ι : Type*} (s : Finset ι) (p : ι → MvPolynomial (Fin 3) R)
    (l : Fin 3) :
    liftSecondLinear (∑ i ∈ s, p i) l = ∑ i ∈ s, liftSecondLinear (p i) l := by
  simp [liftSecondLinear, liftFirstBlock, map_sum, Finset.sum_mul]

/-! #### `secondBlockCoeff` as the coefficient of the cubic fibre

The cubic fibre `C_x = specializeFirstCoordinates x F` is a cubic form in `y`; its `y^m` coefficient
is `secondBlockCoeff F m` evaluated at `x`.  That is the statement making the second-block
coefficients of `F` the *pencil coordinates* of the fibration, and it is what forces those
coordinates to be quadratic forms. -/

theorem biIndex_eq_zero_iff (n m : Fin 3 →₀ ℕ) : biIndex n m = 0 ↔ n = 0 ∧ m = 0 := by
  constructor
  · intro h
    refine ⟨Finsupp.ext fun i => ?_, Finsupp.ext fun j => ?_⟩
    · simpa using DFunLike.congr_fun h (Sum.inl i)
    · simpa using DFunLike.congr_fun h (Sum.inr j)
  · rintro ⟨rfl, rfl⟩
    ext z; cases z <;> simp

theorem biIndex_sub_single_inl (n m : Fin 3 →₀ ℕ) (i : Fin 3) :
    biIndex n m - Finsupp.single (Sum.inl i : BiprojectiveCoordinate 2 2) 1
      = biIndex (n - Finsupp.single i 1) m := by
  ext z
  cases z with
  | inl l => simp [Finsupp.tsub_apply, Finsupp.single_apply]
  | inr l => simp [Finsupp.tsub_apply]

theorem secondBlockCoeff_add (F G : MvPolynomial (BiprojectiveCoordinate 2 2) R)
    (m : Fin 3 →₀ ℕ) :
    secondBlockCoeff (F + G) m = secondBlockCoeff F m + secondBlockCoeff G m := by
  ext n; simp [coeff_secondBlockCoeff]

theorem secondBlockCoeff_C (a : R) (m : Fin 3 →₀ ℕ) :
    secondBlockCoeff (C a : MvPolynomial (BiprojectiveCoordinate 2 2) R) m
      = if m = 0 then C a else 0 := by
  classical
  ext n
  have key : ((0 : BiprojectiveCoordinate 2 2 →₀ ℕ) = biIndex n m) ↔ (n = 0 ∧ m = 0) := by
    rw [eq_comm, biIndex_eq_zero_iff]
  rw [coeff_secondBlockCoeff, coeff_C, apply_ite (coeff n), coeff_C, coeff_zero]
  by_cases hm : m = 0
  · rw [if_pos hm]
    by_cases hn : (0 : Fin 3 →₀ ℕ) = n
    · rw [if_pos hn, if_pos (key.mpr ⟨hn.symm, hm⟩)]
    · rw [if_neg hn, if_neg fun hc => hn (key.mp hc).1.symm]
  · rw [if_neg hm, if_neg fun hc => hm (key.mp hc).2]

theorem secondBlockCoeff_mul_X_inl (F : MvPolynomial (BiprojectiveCoordinate 2 2) R) (i : Fin 3)
    (m : Fin 3 →₀ ℕ) :
    secondBlockCoeff (F * X (Sum.inl i)) m = secondBlockCoeff F m * X i := by
  classical
  ext n
  have hmem : ((Sum.inl i : BiprojectiveCoordinate 2 2) ∈ (biIndex n m).support)
      ↔ i ∈ n.support := by simp [Finsupp.mem_support_iff]
  rw [coeff_secondBlockCoeff, coeff_mul_X', coeff_mul_X']
  by_cases hi : i ∈ n.support
  · rw [if_pos (hmem.mpr hi), if_pos hi, biIndex_sub_single_inl, coeff_secondBlockCoeff]
  · rw [if_neg fun hc => hi (hmem.mp hc), if_neg hi]

theorem secondBlockCoeff_mul_X_inr (F : MvPolynomial (BiprojectiveCoordinate 2 2) R) (j : Fin 3)
    (m : Fin 3 →₀ ℕ) :
    secondBlockCoeff (F * X (Sum.inr j)) m
      = if j ∈ m.support then secondBlockCoeff F (m - Finsupp.single j 1) else 0 := by
  classical
  ext n
  have hmem : ((Sum.inr j : BiprojectiveCoordinate 2 2) ∈ (biIndex n m).support)
      ↔ j ∈ m.support := by simp [Finsupp.mem_support_iff]
  rw [coeff_secondBlockCoeff, coeff_mul_X', apply_ite (coeff n), coeff_zero]
  by_cases hj : j ∈ m.support
  · rw [if_pos (hmem.mpr hj), if_pos hj, biIndex_sub_single_inr, coeff_secondBlockCoeff]
  · rw [if_neg fun hc => hj (hmem.mp hc), if_neg hj]

/-- **The `y^m` coefficient of the cubic fibre over `x` is `secondBlockCoeff F m` at `x`.** -/
theorem coeff_specializeFirstCoordinates (x : Fin 3 → R)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) R) :
    ∀ m : Fin 3 →₀ ℕ,
      coeff m (specializeFirstCoordinates (n := 2) x F) = eval x (secondBlockCoeff F m) := by
  classical
  induction F using MvPolynomial.induction_on with
  | C a =>
      intro m
      rw [specializeFirstCoordinates_C, secondBlockCoeff_C]
      by_cases hm : m = 0
      · subst hm; simp
      · rw [if_neg hm, map_zero, coeff_C, if_neg (Ne.symm hm)]
  | add p q hp hq =>
      intro m
      rw [map_add, coeff_add, hp, hq, secondBlockCoeff_add, map_add]
  | mul_X p z hp =>
      intro m
      cases z with
      | inl i =>
          have hcm : specializeFirstCoordinates (n := 2) x (p * X (Sum.inl i))
              = C (x i) * specializeFirstCoordinates (n := 2) x p := by
            rw [map_mul, specializeFirstCoordinates_X_inl, mul_comm]
          rw [hcm, coeff_C_mul, hp, secondBlockCoeff_mul_X_inl, map_mul, eval_X]
          ring
      | inr j =>
          rw [map_mul, specializeFirstCoordinates_X_inr, coeff_mul_X',
            secondBlockCoeff_mul_X_inr, apply_ite (eval x), map_zero]
          by_cases hj : j ∈ m.support
          · rw [if_pos hj, if_pos hj, hp]
          · rw [if_neg hj, if_neg hj]

theorem weight_leftDegreeWeight_biIndex (n m : Fin 3 →₀ ℕ) :
    Finsupp.weight (leftDegreeWeight (m := 2) (n := 2)) (biIndex n m)
      = Finsupp.weight (1 : Fin 3 → ℕ) n := by
  classical
  rw [Finsupp.weight_apply, Finsupp.weight_apply, Finsupp.sum_fintype _ _ fun _ => by simp,
    Finsupp.sum_fintype _ _ fun _ => by simp, Fintype.sum_sum_type]
  simp [leftDegreeWeight]

/-- **The second-block coefficients of a bidegree-`(2,3)` form are quadratic forms.**  Every
monomial of `F` has first-block degree two, and `secondBlockCoeff F m` collects exactly the
first-block parts of those monomials. -/
theorem isHomogeneous_secondBlockCoeff {F : MvPolynomial (BiprojectiveCoordinate 2 2) R}
    (hF : IsBidegree23 F) (m : Fin 3 →₀ ℕ) :
    (secondBlockCoeff F m).IsHomogeneous 2 := by
  intro n hn
  rw [coeff_secondBlockCoeff] at hn
  have h := hF.isWeightedHomogeneous_left hn
  rwa [weight_leftDegreeWeight_biIndex] at h

end ResidualDivisor

open ResidualDivisor in
/-- Second-block substitution fixes anything pulled back from the first block. -/
theorem secondBlockSubst_rename_inl {R : Type u} [CommRing R] (N : Matrix (Fin 3) (Fin 3) R)
    (p : MvPolynomial (Fin 3) R) :
    secondBlockSubst N (rename Sum.inl p) = rename Sum.inl p := by
  induction p using MvPolynomial.induction_on with
  | C a => simp [secondBlockSubst]
  | add p q hp hq => simp [hp, hq]
  | mul_X p i hp =>
      have hr : rename (R := R) (Sum.inl : Fin 3 → BiprojectiveCoordinate 2 2) (p * X i)
          = rename Sum.inl p * X (.inl i) := by simp
      rw [hr, map_mul, hp, secondBlockSubst_X_inl]

open ResidualDivisor in
/-- **The residual equation along `L` is linear in the second block.**

`residualEquation` is linear in `y` by construction, and `secondBlockSubst N` substitutes linear
forms for the second-block variables, so linearity survives.  Only the existence of the coefficient
vector is recorded; its explicit value `∑ j, N j l · q_j` is not needed downstream. -/
theorem exists_residualEquationOn_eq_sum {R : Type u} [CommRing R]
    (M N : Matrix (Fin 3) (Fin 3) R) (F : MvPolynomial (BiprojectiveCoordinate 2 2) R) :
    ∃ p : Fin 3 → MvPolynomial (Fin 3) R,
      residualEquationOn M N F = ∑ l : Fin 3, liftSecondLinear (p l) l := by
  classical
  set G := secondBlockSubst M F with hG
  set q : Fin 3 → MvPolynomial (Fin 3) R :=
    ![residualCoeffU_of G, residualCoeffV_of G, residualCoeffW_of G] with hq
  refine ⟨fun l => ∑ j : Fin 3, C (N j l) * q j, ?_⟩
  have hres : residualEquation G = ∑ j : Fin 3, liftSecondLinear (q j) j := by
    rw [residualEquation, Fin.sum_univ_three]
    simp [hq]
  have hstep : ∀ j : Fin 3, secondBlockSubst N (liftSecondLinear (q j) j)
      = ∑ l : Fin 3, liftSecondLinear (C (N j l) * q j) l := by
    intro j
    rw [liftSecondLinear, liftFirstBlock, map_mul, secondBlockSubst_rename_inl,
      secondBlockSubst_X_inr, Finset.mul_sum]
    refine Finset.sum_congr rfl fun l _ => ?_
    rw [liftSecondLinear, liftFirstBlock, map_mul, rename_C]
    ring
  rw [residualEquationOn, ← hG, hres, map_sum, Finset.sum_congr rfl fun j _ => hstep j,
    Finset.sum_comm]
  exact Finset.sum_congr rfl fun l _ => (liftSecondLinear_sum _ _ l).symm

open ResidualDivisor in
/-- The coefficients of the linear form in the previous lemma are `residualLineCoeffOn`. -/
theorem residualLineCoeffOn_eq_of_eq_sum {R : Type u} [CommRing R]
    (M N : Matrix (Fin 3) (Fin 3) R) (F : MvPolynomial (BiprojectiveCoordinate 2 2) R)
    (p : Fin 3 → MvPolynomial (Fin 3) R)
    (h : residualEquationOn M N F = ∑ l : Fin 3, liftSecondLinear (p l) l) (a : Fin 3) :
    residualLineCoeffOn M N F a = p a := by
  classical
  have hiff : ∀ l : Fin 3,
      ((Finsupp.single a 1 : Fin 3 →₀ ℕ) = Finsupp.single l 1) ↔ a = l := by
    intro l
    exact ⟨fun h => Finsupp.single_left_injective one_ne_zero h, fun h => by rw [h]⟩
  rw [residualLineCoeffOn, h, secondBlockCoeff_sum,
    Finset.sum_congr rfl fun l _ => secondBlockCoeff_liftSecondLinear (p l) l _]
  simp only [hiff]
  rw [Finset.sum_ite_eq Finset.univ a p]
  simp

open ResidualDivisor in
/-- **The residual equation along `L`, evaluated, is the dual pairing of `residualLineCoeffOn` with
the second-block coordinates.**  This is the identity that makes condition **G3** — a statement
about the coefficient forms — a statement about the residual line `δ_{C_x}(L)`. -/
theorem eval_residualEquationOn_eq_sum {R : Type u} [CommRing R]
    (M N : Matrix (Fin 3) (Fin 3) R) (F : MvPolynomial (BiprojectiveCoordinate 2 2) R)
    (x y : Fin 3 → R) :
    eval (Sum.elim x y) (residualEquationOn M N F)
      = ∑ a : Fin 3, eval x (residualLineCoeffOn M N F a) * y a := by
  obtain ⟨p, hp⟩ := exists_residualEquationOn_eq_sum M N F
  rw [hp, map_sum]
  refine Finset.sum_congr rfl fun l _ => ?_
  rw [eval_liftSecondLinear, residualLineCoeffOn_eq_of_eq_sum M N F p hp l]

/-! ### From "every line is bad" to a common residual line map -/

/-- Every `3 × 3` matrix is the frame of a line: its columns are the two spanning vectors and the
completion.  This is what makes the quantifier `∀ M N, M * N = 1` in
`Standard.HasCommonResidualLineMap` the same as a quantifier over lines with a chosen frame. -/
theorem lineFrame_of_matrix {R : Type u} [CommRing R] (M : Matrix (Fin 3) (Fin 3) R) :
    lineFrame (fun j => M j 0) (fun j => M j 1) (fun j => M j 2) = M := by
  ext j l
  fin_cases l <;> simp

/--
**If every line is bad, all the cubic fibres share one residual-line map.**

`ResidualLineConstantOn M N F` says the three coefficient forms `q_U, q_V, q_W` of `δ_{C_x}(L)` are
`c_a · g` for one form `g` and constants `c_a`.  Evaluating at `x` therefore makes `δ_{C_x}(L)` the
fixed linear form `∑ c_a y_a` scaled by `g(x)` — the same point of `(ℙ²_y)^∨` for every `x` at which
the scalar is nonzero, and the zero vector elsewhere.  That is exactly
`Standard.HasCommonResidualLineMap`.

The scalar being allowed to vanish is deliberate and is why base-point-freeness is a separate
hypothesis downstream: `ResidualLineConstantOn` is satisfied *vacuously* by `g = 0`, i.e. by a line
along which the residual coefficient vector vanishes identically.
-/
theorem hasCommonResidualLineMap_specializeFirstCoordinates_of_forall_residualLineConstantOn
    [Infinite k] (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (hbad : ∀ M N : Matrix (Fin 3) (Fin 3) k, M * N = 1 → ResidualLineConstantOn M N F) :
    Standard.HasCommonResidualLineMap
      (fun x : Fin 3 → k => specializeFirstCoordinates (n := 2) x F) := by
  intro M N hMN
  obtain ⟨g, c, hgc⟩ := hbad M N hMN
  refine ⟨∑ a : Fin 3, C (c a) * X a, fun x => ⟨eval x g, ?_⟩⟩
  refine MvPolynomial.funext fun y => ?_
  rw [← eval_residualEquationOn, eval_residualEquationOn_eq_sum]
  simp only [hgc, map_mul, eval_C, map_sum, eval_X, Finset.mul_sum]
  exact Finset.sum_congr rfl fun a _ => by ring

/-! ### Base-point-freeness of the residual line map

`ResidualLineBasePointFree` proves that the residual line of a smooth plane cubic is a genuine
line, both on the coordinate line and along an arbitrary line.  The general form is stated on the
*transported* cubic `aeval (linearSubst 2 M) G`, so turning it into
`Standard.ResidualLineMapBasepointFree` — a statement about `G` — needs exactly one further fact:
that an invertible linear substitution carries smooth plane cubics to smooth plane cubics. -/

/--
**An invertible linear substitution preserves smoothness of a plane cubic.**

This is the chain rule for the Jacobian criterion: `∇(G ∘ M)(r) = Mᵀ · ∇G(M r)`, and `M` invertible
makes the two gradients vanish together.

It is taken as a hypothesis rather than proved here: it is being supplied separately, and
duplicating it would fork the statement.  Everything downstream threads it under the name `(isSmoothPlaneCubicSubstInvariant k)`.
-/
def IsSmoothPlaneCubicSubstInvariant (k : Type u) [Field k] : Prop :=
  ∀ M N : Matrix (Fin 3) (Fin 3) k, M * N = 1 →
    ∀ g : MvPolynomial (Fin 3) k, Standard.IsSmoothPlaneCubic g →
      Standard.IsSmoothPlaneCubic ((aeval (linearSubst 2 M) : MvPolynomial (Fin 3) k →ₐ[k] _) g)

/-- **The hypothesis above holds unconditionally**, so it need never be assumed.

An invertible linear substitution preserves homogeneity (`isHomogeneous_aeval_linearSubst`) and
nonsingularity (`nonsingular_aeval_linearSubst_iff`); the latter is the chain rule
`∇(G∘M)(r) = Mᵀ · ∇G(M *ᵥ r)` together with invertibility of `M` and of `Mᵀ`. -/
theorem isSmoothPlaneCubicSubstInvariant (k : Type u) [Field k] :
    IsSmoothPlaneCubicSubstInvariant k := by
  intro M N hMN g hg
  exact ⟨isHomogeneous_aeval_linearSubst M hg.1,
    (nonsingular_aeval_linearSubst_iff 2 M N hMN g).mpr hg.2⟩

/--
**The residual line map of a smooth plane cubic is base-point free.**

`Standard.ResidualLineMapBasepointFree f` is `δ_f(L) ≠ 0` for every line `L`; it is the hypothesis
that stops `Standard.HasCommonResidualLineMap` from being satisfied vacuously.  Given
`IsSmoothPlaneCubicSubstInvariant`, it follows from
`residualLinearFormOn_ne_zero_of_nonsingular` — which needs no hypothesis on the characteristic.
-/
theorem residualLineMapBasepointFree_of_isSmoothPlaneCubic [IsAlgClosed k]
    (f : MvPolynomial (Fin 3) k) (hf : Standard.IsSmoothPlaneCubic f) :
    Standard.ResidualLineMapBasepointFree f := by
  intro M N hMN
  obtain ⟨hhom, hns⟩ := (isSmoothPlaneCubicSubstInvariant k) M N hMN f hf
  exact residualLinearFormOn_ne_zero_of_nonsingular M N hMN f hhom hns

/-! ### §1: the generic cubic fibre is smooth -/

/--
**A principal open of smooth cubic fibres, in coordinates.**

*What it says.*  For a smooth `(2,3)` hypersurface there is a nonzero form `D` in `x` — the
discriminant of the cubic fibration — off whose zero locus every plane cubic fibre
`C_x = specializeFirstCoordinates x F` is a smooth plane cubic.

*Why it is true.*  `FirstProjectionSmoothFiber` proves directly that at least one fibre is
nonsingular.  If every fibre were singular, projective elimination at the generic parameter point
would produce a singular cubic point over an algebraic closure of the rational function field.
Extending the three coordinate derivations and differentiating the fibre equation forces the
first-block derivatives to vanish as well, contradicting the total-space smoothness certificate.

The finite elimination-certificate set in `CubicFiberSingularLocus` cuts out the singular-fibre
locus.  The nonsingular fibre therefore supplies one certificate polynomial that is not identically
zero; its principal open is the required locus.
-/
theorem exists_ne_zero_isSmoothPlaneCubic_specializeFirstCoordinates [IsAlgClosed k]
    [NeZero (2 : k)] [NeZero (3 : k)]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (biprojectiveZeroLocusToSpec 2 2 k F)] :
    ∃ D : MvPolynomial (Fin 3) k, D ≠ 0 ∧
      ∀ x : Fin 3 → k, eval x D ≠ 0 →
        Standard.IsSmoothPlaneCubic (specializeFirstCoordinates (n := 2) x F) := by
  obtain ⟨S, _, hS⟩ := exists_defining_set_nonsingular_cubicFiber_of_bidegree23 F hF
  obtain ⟨x₀, hx₀⟩ := exists_nonsingularCubicFiber_of_smooth F hF hF0
  obtain ⟨D, hDS, hxD⟩ := (hS x₀).mpr hx₀
  have hD0 : D ≠ 0 := by
    intro hD
    rw [hD, map_zero] at hxD
    exact hxD rfl
  refine ⟨D, hD0, ?_⟩
  intro x hx
  exact ⟨hF.specializeFirstCoordinates_isHomogeneous x,
    (hS x).mp ⟨D, hDS, hx⟩⟩

/-! ### §3: every line bad forces the cubic fibration into a pencil -/

/--
**If every line is bad, the cubic fibres generically lie in a fixed pencil.**

This is the source's §3 with Lemma 3.1 replaced by density of `k`-points; see the module docstring
of `Standard/ResidualLineMapInjective.lean`.  The three inputs are: the bridge
`hasCommonResidualLineMap_specializeFirstCoordinates_of_forall_residualLineConstantOn`, the
principal-open smooth-fibre theorem, and the axiom-clean Hesse residual-map rigidity theorem.  All
three inputs are proved in the current tree.
-/
theorem exists_pencil_basis_of_forall_residualLineConstantOn [IsAlgClosed k]
    [NeZero (2 : k)] [NeZero (3 : k)]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (biprojectiveZeroLocusToSpec 2 2 k F)]
    (hbad : ∀ M N : Matrix (Fin 3) (Fin 3) k, M * N = 1 → ResidualLineConstantOn M N F) :
    ∃ D f₀ f₁ : MvPolynomial (Fin 3) k,
      D ≠ 0 ∧ f₀.IsHomogeneous 3 ∧ f₁.IsHomogeneous 3 ∧
        ∀ x : Fin 3 → k, eval x D ≠ 0 →
          ∃ a b : k, specializeFirstCoordinates (n := 2) x F = C a * f₀ + C b * f₁ := by
  obtain ⟨D, hD0, hDsm⟩ :=
    exists_ne_zero_isSmoothPlaneCubic_specializeFirstCoordinates F hF hF0
  have hcommon :=
    hasCommonResidualLineMap_specializeFirstCoordinates_of_forall_residualLineConstantOn F hbad
  obtain ⟨f₀, f₁, hh0, hh1, hmem⟩ :=
    Standard.exists_pencil_of_hasCommonResidualLineMap
      (fun s : {x : Fin 3 → k // eval x D ≠ 0} =>
        specializeFirstCoordinates (n := 2) s.1 F)
      (fun s => hDsm s.1 s.2)
      (fun s => residualLineMapBasepointFree_of_isSmoothPlaneCubic _ (hDsm s.1 s.2))
      (fun M N hMN => by
        obtain ⟨ℓ, hℓ⟩ := hcommon M N hMN
        exact ⟨ℓ, fun s => hℓ s.1⟩)
  exact ⟨D, f₀, f₁, hD0, hh0, hh1, fun x hx => hmem ⟨x, hx⟩⟩

/-! ### From generic pencil membership to a pencil factorisation of `F` -/

/-- Rescaling a polynomial by a unit and its inverse. -/
private theorem C_mul_inv_cancel (c : k) (hc : c ≠ 0) (α : k) (f : MvPolynomial (Fin 3) k) :
    C (α * c) * (C c⁻¹ * f) = C α * f := by
  rw [C_mul, mul_assoc, ← mul_assoc (C c), ← C_mul, mul_inv_cancel₀ hc, C_1, one_mul]

/-- If two coefficient functionals form a dual basis for `(g₀, g₁)`, they read off the pencil
coordinates of any member of the pencil. -/
private theorem eq_of_dualBasis (g₀ g₁ : MvPolynomial (Fin 3) k) (m₀ m₁ : Fin 3 →₀ ℕ)
    (h00 : coeff m₀ g₀ = 1) (h01 : coeff m₁ g₀ = 0)
    (h10 : coeff m₀ g₁ = 0) (h11 : coeff m₁ g₁ = 1) (p q : k) :
    C p * g₀ + C q * g₁
      = C (coeff m₀ (C p * g₀ + C q * g₁)) * g₀ + C (coeff m₁ (C p * g₀ + C q * g₁)) * g₁ := by
  rw [coeff_add, coeff_add, coeff_C_mul, coeff_C_mul, coeff_C_mul, coeff_C_mul,
    h00, h01, h10, h11]
  simp

/--
**Gaussian elimination for a pencil of polynomials.**

For any pair `f₀, f₁` there are `g₀, g₁` spanning the same subspace and two multi-indices `m₀, m₁`
such that the coefficient functionals at `m₀` and `m₁` recover the coordinates of every member of
the span.  When `f₀, f₁` are independent this is the usual dual basis obtained by clearing a pivot;
in the degenerate cases (span of dimension one or zero) one of the `gᵢ` is taken to be zero and the
identity still holds.

This is what makes the pencil coordinates of the cubic fibration *coefficients* of `F`, hence
polynomials in `x`.
-/
theorem exists_dualBasis_of_pencil (f₀ f₁ : MvPolynomial (Fin 3) k) :
    ∃ (g₀ g₁ : MvPolynomial (Fin 3) k) (m₀ m₁ : Fin 3 →₀ ℕ), ∀ a b : k,
      C a * f₀ + C b * f₁
        = C (coeff m₀ (C a * f₀ + C b * f₁)) * g₀
          + C (coeff m₁ (C a * f₀ + C b * f₁)) * g₁ := by
  classical
  by_cases hf₀ : f₀ = 0
  · subst hf₀
    by_cases hf₁ : f₁ = 0
    · subst hf₁
      exact ⟨0, 0, 0, 0, fun a b => by simp⟩
    · obtain ⟨m₁, hv0⟩ := MvPolynomial.ne_zero_iff.mp hf₁
      refine ⟨0, C (coeff m₁ f₁)⁻¹ * f₁, 0, m₁, fun a b => ?_⟩
      simp only [mul_zero, zero_add, coeff_C_mul]
      exact (C_mul_inv_cancel _ hv0 b f₁).symm
  · obtain ⟨m₀, hu0⟩ := MvPolynomial.ne_zero_iff.mp hf₀
    set u : k := coeff m₀ f₀ with hu
    clear_value u
    set f₁' : MvPolynomial (Fin 3) k := f₁ - C (coeff m₀ f₁ * u⁻¹) * f₀ with hf₁'
    have hcoeff₀ : coeff m₀ f₁' = 0 := by
      rw [hf₁', coeff_sub, coeff_C_mul]
      simp only [← hu]
      rw [mul_assoc, inv_mul_cancel₀ hu0, mul_one, sub_self]
    have hcomb : ∀ a b : k, C a * f₀ + C b * f₁
        = C (a + b * (coeff m₀ f₁ * u⁻¹)) * f₀ + C b * f₁' := by
      intro a b
      rw [hf₁']
      simp only [C_add, C_mul]
      ring
    clear_value f₁'
    by_cases hz : f₁' = 0
    · refine ⟨C u⁻¹ * f₀, 0, m₀, m₀, fun a b => ?_⟩
      rw [hcomb a b, hz]
      simp only [mul_zero, add_zero, coeff_C_mul, ← hu]
      exact (C_mul_inv_cancel u hu0 _ f₀).symm
    · obtain ⟨m₁, hv0⟩ := MvPolynomial.ne_zero_iff.mp hz
      set v : k := coeff m₁ f₁' with hv
      clear_value v
      set w : k := coeff m₁ f₀ with hw
      clear_value w
      set f₀' : MvPolynomial (Fin 3) k := f₀ - C (w * v⁻¹) * f₁' with hf₀'
      have h00 : coeff m₀ (C u⁻¹ * f₀') = 1 := by
        rw [hf₀', coeff_C_mul, coeff_sub, coeff_C_mul, hcoeff₀, mul_zero, sub_zero]
        simp only [← hu]
        rw [inv_mul_cancel₀ hu0]
      have h01 : coeff m₁ (C u⁻¹ * f₀') = 0 := by
        rw [hf₀', coeff_C_mul, coeff_sub, coeff_C_mul]
        simp only [← hv, ← hw]
        rw [mul_assoc w, inv_mul_cancel₀ hv0, mul_one, sub_self, mul_zero]
      have h10 : coeff m₀ (C v⁻¹ * f₁') = 0 := by
        rw [coeff_C_mul, hcoeff₀, mul_zero]
      have h11 : coeff m₁ (C v⁻¹ * f₁') = 1 := by
        rw [coeff_C_mul]
        simp only [← hv]
        rw [inv_mul_cancel₀ hv0]
      have hf₀eq : f₀ = C u * (C u⁻¹ * f₀') + C w * (C v⁻¹ * f₁') := by
        rw [hf₀', ← mul_assoc, ← mul_assoc, ← C_mul, ← C_mul, mul_inv_cancel₀ hu0, C_1, one_mul]
        ring
      clear_value f₀'
      have hbv : ∀ b : k, C b * f₁' = C (b * v) * (C v⁻¹ * f₁') := fun b =>
        (C_mul_inv_cancel v hv0 b f₁').symm
      have hpq : ∀ α b : k, C α * f₀ + C b * f₁'
          = C (α * u) * (C u⁻¹ * f₀')
            + C (α * w + b * v) * (C v⁻¹ * f₁') := by
        intro α b
        conv_lhs => rw [hf₀eq, hbv b]
        simp only [C_add, C_mul]
        ring
      refine ⟨C u⁻¹ * f₀', C v⁻¹ * f₁', m₀, m₁, fun a b => ?_⟩
      rw [hcomb a b, hpq _ b]
      exact eq_of_dualBasis _ _ m₀ m₁ h00 h01 h10 h11 _ _

/--
**The pencil coordinates of the cubic fibres are quadratic forms in `x`.**

*What it says.*  If the cubic fibres of `F` lie generically in the pencil `⟨f₀, f₁⟩`, then the two
pencil coordinates are given by *polynomials* in `x` — indeed by quadratic forms, since `F` has
bidegree `(2, 3)` — after replacing `f₀, f₁` by a basis of the same pencil adapted to two
coefficient functionals.

*Why it is true.*  Elementary linear algebra.  Gaussian elimination on the pair `(f₀, f₁)` produces
`g₀, g₁` spanning the same subspace together with two `y`-monomials `m₀, m₁` such that
`coeff m₀ g₀ = 1`, `coeff m₁ g₀ = 0`, `coeff m₀ g₁ = 0`, `coeff m₁ g₁ = 1` (in the degenerate cases,
where the pencil has dimension `≤ 1`, a weaker but sufficient normalisation).  Then the pencil
coordinates of any member are read off by those two functionals, so for the fibre `C_x` they are
`coeff m₀ C_x` and `coeff m₁ C_x`, which are `eval x (secondBlockCoeff F m₀)` and
`eval x (secondBlockCoeff F m₁)`; and `secondBlockCoeff F m` is homogeneous of degree two because
every monomial of `F` has first-block degree two.

The proof is `exists_dualBasis_of_pencil` (Gaussian elimination), `coeff_specializeFirstCoordinates`
and `isHomogeneous_secondBlockCoeff`.
-/
theorem exists_isHomogeneous_pencil_coefficients
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (D f₀ f₁ : MvPolynomial (Fin 3) k)
    (h : ∀ x : Fin 3 → k, eval x D ≠ 0 →
      ∃ a b : k, specializeFirstCoordinates (n := 2) x F = C a * f₀ + C b * f₁) :
    ∃ A B g₀ g₁ : MvPolynomial (Fin 3) k, A.IsHomogeneous 2 ∧ B.IsHomogeneous 2 ∧
      ∀ x : Fin 3 → k, eval x D ≠ 0 →
        specializeFirstCoordinates (n := 2) x F = C (eval x A) * g₀ + C (eval x B) * g₁ := by
  obtain ⟨g₀, g₁, m₀, m₁, hdual⟩ := exists_dualBasis_of_pencil f₀ f₁
  refine ⟨ResidualDivisor.secondBlockCoeff F m₀, ResidualDivisor.secondBlockCoeff F m₁, g₀, g₁,
    ResidualDivisor.isHomogeneous_secondBlockCoeff hF m₀,
    ResidualDivisor.isHomogeneous_secondBlockCoeff hF m₁, fun x hx => ?_⟩
  obtain ⟨a, b, hab⟩ := h x hx
  rw [← ResidualDivisor.coeff_specializeFirstCoordinates x F m₀,
    ← ResidualDivisor.coeff_specializeFirstCoordinates x F m₁, hab]
  exact hdual a b

/--
**A generic pencil factorisation is a pencil factorisation.**

If `C_x = A(x)·f₀ + B(x)·f₁` off the zero locus of a nonzero `D`, then `F = A ⊗ f₀ + B ⊗ f₁`
outright.  The difference `Δ = F - (A ⊗ f₀ + B ⊗ f₁)` satisfies `D(x)·Δ(x, y) = 0` at *every* point,
so `D ⊗ 1 · Δ = 0` because `k` is infinite; and the polynomial ring is a domain with `D ⊗ 1 ≠ 0`.

No smoothness, no homogeneity, no algebraic closure — only that `k` is infinite.
-/
theorem eq_pencil_of_forall_specializeFirstCoordinates [Infinite k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (D A B f₀ f₁ : MvPolynomial (Fin 3) k)
    (hD0 : D ≠ 0)
    (h : ∀ x : Fin 3 → k, eval x D ≠ 0 →
      specializeFirstCoordinates (n := 2) x F = C (eval x A) * f₀ + C (eval x B) * f₁) :
    F = rename Sum.inl A * rename Sum.inr f₀ + rename Sum.inl B * rename Sum.inr f₁ := by
  set G : MvPolynomial (BiprojectiveCoordinate 2 2) k :=
    rename Sum.inl A * rename Sum.inr f₀ + rename Sum.inl B * rename Sum.inr f₁ with hG
  have hspec : ∀ x : Fin 3 → k, specializeFirstCoordinates (n := 2) x G
      = C (eval x A) * f₀ + C (eval x B) * f₁ := by
    intro x
    rw [hG, map_add, map_mul, map_mul, specializeFirstCoordinates_rename_inl,
      specializeFirstCoordinates_rename_inr, specializeFirstCoordinates_rename_inl,
      specializeFirstCoordinates_rename_inr]
  have hzero : rename Sum.inl D * (F - G) = 0 := by
    refine MvPolynomial.funext fun z => ?_
    have hz : z = Sum.elim (z ∘ Sum.inl) (z ∘ Sum.inr) := by
      funext w; cases w <;> rfl
    set x : Fin 3 → k := z ∘ Sum.inl with hx
    set y : Fin 3 → k := z ∘ Sum.inr with hy
    rw [map_zero, map_mul, map_sub, hz]
    rcases eq_or_ne (eval x D) 0 with hD | hD
    · rw [eval_rename]
      simp [Function.comp_def, hD]
    · have := h x hD
      rw [← eval_specializeFirstCoordinates x y F, ← eval_specializeFirstCoordinates x y G,
        this, hspec x, sub_self, mul_zero]
  have hDne : (rename Sum.inl D : MvPolynomial (BiprojectiveCoordinate 2 2) k) ≠ 0 := by
    intro hcon
    exact hD0 (rename_injective _ Sum.inl_injective (by simpa using hcon))
  have := (mul_eq_zero.mp hzero).resolve_left hDne
  exact sub_eq_zero.mp this

/-! ### The good line exists -/

/--
**Some line of `ℙ²_y` is good**: for a smooth `(2,3)` hypersurface there is a line `L` along which
the residual line `δ_{C_x}(L)` moves with `x`.

This is condition **G3** of `PLAN.md` WP-G supplied rather than assumed, and it is the hypothesis
`hgood` of `eq_zero_of_aeval_residualYCoordsOn_of_isHomogeneous`.

*The argument.*  Suppose every `k`-rational line is bad.  Every matrix is a line frame
(`lineFrame_of_matrix`), so `ResidualLineConstantOn` holds for every frame; the bridge turns that
into "all the cubic fibres have the same residual-line map"; generic smoothness restricts attention
to the smooth fibres; Lemma 2.1 in its pencil form puts all those fibres in one pencil of plane
cubics; the pencil coordinates are quadratic forms in `x`, so `F = A(x)·f₀(y) + B(x)·f₁(y)`; and
`not_eq_pencil_of_smooth` says a smooth `F` is not of that shape, because the two conics `A` and `B`
meet.

*What it stands on.*  The concrete principal-open smooth-fibre theorem
`exists_ne_zero_isSmoothPlaneCubic_specializeFirstCoordinates`, the Hesse-normal-form residual
rigidity theorem `Standard.exists_pencil_of_hasCommonResidualLineMap`, invertible-substitution
invariance, and residual-line base-point-freeness.  These dependencies are proved and the focused
audit `GoodLineExistenceAxiomAudit.lean` checks the final theorem without `sorryAx`.

*The line produced is not canonical.*  The conclusion is `∃` a good line, which is what §3 asks for
and what `eq_zero_of_aeval_residualYCoordsOn_of_isHomogeneous` consumes; no claim is made about
*which* lines are good, and in particular the coordinate line `{Y₂ = 0}` need not be one.
-/
theorem exists_good_line [IsAlgClosed k] [NeZero (2 : k)] [NeZero (3 : k)]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (biprojectiveZeroLocusToSpec 2 2 k F)] :
    ∃ (p₀ q₀ r : Fin 3 → k) (N : Matrix (Fin 3) (Fin 3) k),
      lineFrame p₀ q₀ r * N = 1 ∧ ResidualLineNonconstantOn (lineFrame p₀ q₀ r) N F := by
  by_contra hcon
  push Not at hcon
  have hbad : ∀ M N : Matrix (Fin 3) (Fin 3) k, M * N = 1 → ResidualLineConstantOn M N F := by
    intro M N hMN
    have hframe := lineFrame_of_matrix M
    have := hcon (fun j => M j 0) (fun j => M j 1) (fun j => M j 2) N (by rw [hframe]; exact hMN)
    rw [hframe] at this
    exact not_not.mp this
  obtain ⟨D, f₀, f₁, hD0, hf₀, hf₁, hpencil⟩ :=
    exists_pencil_basis_of_forall_residualLineConstantOn F hF hF0 hbad
  obtain ⟨A, B, g₀, g₁, hA, hB, hcoef⟩ :=
    exists_isHomogeneous_pencil_coefficients F hF D f₀ f₁ hpencil
  exact not_eq_pencil_of_smooth F hF hF0 A B g₀ g₁ hA hB
    (eq_pencil_of_forall_specializeFirstCoordinates F D A B g₀ g₁ hD0 hcoef)

end

end BConicBundleMultisections
