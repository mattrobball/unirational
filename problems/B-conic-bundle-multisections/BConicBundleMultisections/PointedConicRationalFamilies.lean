/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import BConicBundleMultisections.PointedConicAffineModel
public import BConicBundleMultisections.ResidualComponentHorizontality
public import BConicBundleMultisections.Standard.GenericSmoothness

/-!
# Obligation 3: the base-changed conic bundle is pointed and rational

One of the four outstanding obligations of the unirationality proof; see
`ResidualComponentAssembly.lean` for the inventory and `PLAN.md` WP-3 (= WP-D) for the work
package.  This is the largest of the four by volume, but classical throughout.

## What has to be produced

`IsResidualComponentPointedConicRational F hF v hv i j` unfolds, through
`IsPointedConicRationalOver`, to

```
BirationalOver (pullback.snd (biprojectiveZeroLocusSnd 2 2 k F) (residualComponentToBase …))
               (𝔸(ULift (Fin 1); T_L) ↘ T_L)
```

that is: a partial isomorphism, over `T_L := residualComponent F hF v hv i j`, between the
base-changed conic bundle `X ×_{ℙ²_y} T_L` and relative affine `1`-space.  Note that the
`PullbackSection` argument of `IsPointedConicRationalOver` does not appear in the unfolded
statement — it records *why* the assertion is expected to hold (source §5: "after base change to
this normalization, the conic bundle has its tautological point and is birational to
`T̃_L × ℙ¹`"), and it is a hypothesis of the general theorem below rather than part of its
conclusion.

## The decomposition implemented here

The obligation is reduced to **one** leaf, `exists_pointedConicAffineModel` — the *spreading-out*
step — by four groups of results that are proved outright:

1. `AlgebraicGeometry.Scheme.isIntegral_image` — the scheme-theoretic image of an integral scheme
   under a quasi-compact morphism is integral.  Stated in natural generality; Mathlib has nothing
   about images of integral schemes (`PLAN.md` WP-3a).  Its specialization
   `isIntegral_residualComponent` gives `IsIntegral T_L`, which is what makes
   `Scheme.functionField T_L` — the field over which the generic conic lives — available at all.
2. `exists_dense_open_smooth_biprojectiveZeroLocusSnd` — the conic bundle `X → ℙ²_y` is smooth
   over a *dense* open of `ℙ²_y`.  This is generic smoothness (`Standard.GenericSmoothness`,
   source §1, and the reason `CharZero` is carried) plus irreducibility of `ℙ²_y`.  It is what
   rules out the generic fibre being a degenerate conic — a line pair or a double line — for which
   the conclusion would be **false**, not merely unproved (see the warning below).
3. `isDominant_residualComponentToBase_of_smooth` — horizontality of `T_L`, i.e. that `T_L` maps
   *dominantly* to `ℙ²_y` and hence that its generic point sees the generic, smooth, conic.  This
   is obligation 2 (`isDominant_residualImagePointOfNormalizedLoc_toBase`, WP-B) fed through the
   already-proved reduction `isDominant_residualComponentToBase`.  Obligation 2 has exactly the
   hypotheses of obligation 3, so nothing new is assumed; but the dependency is real and is
   recorded here deliberately.
4. **The classical mathematics itself**, in `PointedConicAffineModel.lean`:
   `PointedConic.birationalOver_conicScheme_affineSpace` proves, for an arbitrary commutative
   base ring, that the pointed affine conic `a x² + b x y + c y² + d x + e y = 0` over a domain
   `A` is `Spec A`-birational to `𝔸(1; Spec A)`.  Stereographic projection from the marked point
   is written as an explicit isomorphism of localizations
   `(A[x,y]/(f))_{x (dx+ey)} ≅ A[z]_{Q(z) L(z)}`, with `z = y/x` and `x = −L(z)/Q(z)`.  There is
   no `sorry` in it, and — as `PLAN.md` WP-3d requires — no normal form and no Witt decomposition.
   Transport back to `T` is `Scheme.BirationalOver.comp` and
   `Scheme.birationalOver_affineSpace_comp`, both proved here and both absent from Mathlib.

On the abstract-quadratic-form side, `conicParametrization_smul_or_isotropic_span` (now in
`PointedConicRational.lean`, together with `eval_isotropic_of_polar_eq_zero`) supplies the
surjectivity half of WP-3d for an arbitrary form on an arbitrary module, again with no normal
form.

## Correction: the affine-model leaf was false without global smoothness

The first version of `exists_pointedConicAffineModel` (and of
`isPointedConicRationalOver_of_dense_open_smooth`) assumed only `hF0 : F ≠ 0` together with
smoothness of `π` over a dense open `U` of `ℙ²_y`.  **That is false.**  Explicit counterexample,
over an arbitrary field `k`:

```
F = Y₀³ · (X₀ X₁ − X₂²)          -- bidegree (2,3), nonzero
U = D(Y₀)                         -- dense open of ℙ²_y
T = ℙ²_y,  t = 𝟙                  -- integral, dominant
σ : y ↦ ([1:0:0], y)              -- a section, since 1·0 − 0² = 0
```

On `U` the ideal `(Y₀³ (X₀X₁ − X₂²))` equals `(X₀X₁ − X₂²)`, so `π ∣_ U` is the constant smooth
conic bundle `V(X₀X₁ − X₂²) × U → U`: every hypothesis holds.  But `pullback.snd π t ≅ X` is
`ℙ²_x × {Y₀ = 0}` together with `V(X₀X₁ − X₂²) × ℙ²_y`, and is non-reduced along `Y₀ = 0`.  A dense
open of a reducible space is reducible, while every nonempty open of `𝔸(1; T)` — and of the
pointed affine conic over a domain — is integral, so no `BirationalOver` can exist.

The missing hypothesis is exactly the one this development already isolates: a *whole* `ℙ²_x`
fibre.  `BiprojectiveSpace.not_specializeSecondCoordinates_eq_zero_of_smooth_bidegree23` says that
global smoothness of `X` over `Spec k` forbids one, and that is the only thing the counterexample
violates (its `X` is visibly singular along `Y₀ = 0`).  Both statements therefore now carry
`[IsAlgClosed k]` and `[Smooth (biprojectiveZeroLocusToSpec 2 2 k F)]`, which the obligation's call
site supplies anyway.  With no whole fibre, every component of `X ×_{ℙ²_y} T` dominates `T`; its
generic fibre is a smooth plane conic, hence geometrically integral; so the base change is integral
and the statement is true.

This is the same fault as `PLAN.md` correction 7 and its predecessors: when the classical statement
was lifted out of its setting, a hypothesis that the source's geometry supplies for free
(here: `X` is smooth, which is the standing hypothesis of the whole theorem) was silently dropped.
The lesson recorded for the next generalization: *smoothness of the morphism over a dense open of
the base does not imply anything about the fibres outside that open*, and birationality is a
statement about the total space, which those fibres can wreck.

## Warning: horizontality is not decoration, it is load-bearing

The statement of obligation 3 carries no hypothesis relating `T_L` to the discriminant of the
conic bundle, and **it is not provable without one**.  If the image of `T_L` in `ℙ²_y` were a
curve contained in the discriminant, the fibre of `X ×_{ℙ²_y} T_L → T_L` over the generic point of
`T_L` would be a singular conic over `K = k(T_L)`, and in each of the three cases the conclusion
fails:

* two `K`-rational lines: `X ×_{ℙ²_y} T_L` is reducible, while every nonempty open of
  `𝔸(1; T_L)` is irreducible;
* two conjugate lines: the only `K`-point is the node, and the normalization is `ℙ¹` over a
  quadratic extension of `K`, not over `K`;
* a double line: `X ×_{ℙ²_y} T_L` is non-reduced, while `𝔸(1; T_L)` is reduced.

The bad configuration is exactly the one source §4 excludes.  In the source's geometry: if
`T_L → ℙ²_y` is not dominant its image cannot be a point (the fibres of `X → ℙ²_y` are curves
while `T_L` is a surface), so it is a curve `Z`; the fibres of `T_L → Z` are then whole conics, so
`T_L` is the preimage of `Z`, and §4's class computation `[T_L] = a H_x + H_y` forces `deg Z = 1`.
So `Z` is a line `M` and `δ_C(L) ≡ M` is constant — precisely what §4 rules out with "contrary to
the choice of `L`".  A line *can* be a component of the degree-nine discriminant of a conic
bundle, so non-horizontality does not by itself make the obligation false; but nothing in its
hypotheses excludes the bad configuration, and there is no proof without doing so.

This is the same phenomenon that made obligations 1c and 1d false as stated: the source
**chooses** the multisection line `L` (§3–§4) and normalises it to `{W = 0}` only in §5, whereas
this development hardcodes the normalisation.  Here the dependency is made explicit rather than
hidden: obligation 3 is discharged *modulo obligation 2*, which is where the choice of `L` is
owed.  Note that this couples work packages WP-B and WP-D, which were previously independent; it
costs nothing, because `MainTheorem` consumes both anyway and obligation 2 has exactly the
hypotheses of obligation 3.

## What is left

`exists_pointedConicAffineModel` — and nothing else.  It says that over a dense affine open of the
base the pointed conic bundle *is* a pointed affine conic, i.e. it is the spreading-out step: delete
the line at infinity through the section, translate the section to the origin, and read off the five
coefficients.  This is bookkeeping with the biprojective chart machinery of this development
(`BiprojectiveChart`, `chartZeroLocusIsoPullback`, `BiprojectiveDehomogenization`), not new
mathematics; Mathlib supplies no spreading-out machinery for schemes and no
"birational ⇔ isomorphic function fields" bridge at the pinned revision, so it cannot be shortcut.

-/

@[expose] public section

open CategoryTheory Limits
open scoped AlgebraicGeometry

universe u

namespace AlgebraicGeometry.Scheme

/-! ### Integrality of scheme-theoretic images

`PLAN.md` WP-3a.  Mathlib knows that `f.toImage` is dominant and quasi-compact, but records
nothing about the image of an integral scheme.  Both halves are short once the right Mathlib
lemma is located, and both are stated for an arbitrary quasi-compact morphism of schemes.
-/

variable {X Y : Scheme.{u}}

/-- **The scheme-theoretic image of an irreducible scheme is irreducible.**

`f.toImage : X ⟶ f.image` is dominant for quasi-compact `f`, so the image space is the closure of
the continuous image of an irreducible space. -/
theorem irreducibleSpace_image (f : X ⟶ Y) [QuasiCompact f] [IrreducibleSpace X] :
    IrreducibleSpace f.image := by
  have hdense : DenseRange (f.toImage.base) := IsDominant.denseRange (f := f.toImage)
  have huniv : IsIrreducible (Set.univ : Set X) := IrreducibleSpace.isIrreducible_univ X
  have hrange : IsIrreducible (Set.range ⇑f.toImage.base) := by
    simpa [Set.image_univ] using
      huniv.image (⇑f.toImage.base) (Scheme.Hom.continuous f.toImage).continuousOn
  have hclosure : IsIrreducible (closure (Set.range ⇑f.toImage.base)) := hrange.closure
  rw [hdense.closure_range] at hclosure
  exact { toPreirreducibleSpace := ⟨hclosure.2⟩, toNonempty := ⟨hclosure.1.choose⟩ }

/-- **The scheme-theoretic image of a reduced scheme is reduced.**

On an affine open `U` of the target, the sections of the image are `Γ(Y, U) ⧸ ker (f.app U)`
(`Scheme.Hom.ker_apply`, which needs quasi-compactness), and that quotient embeds in the reduced
ring `Γ(X, f ⁻¹ᵁ U)`.  These affine opens cover the image. -/
theorem isReduced_image (f : X ⟶ Y) [QuasiCompact f] [IsReduced X] :
    IsReduced f.image := by
  haveI hquot : ∀ U : Y.affineOpens,
      _root_.IsReduced ((Γ(Y, (U : Y.Opens)) : Type u) ⧸ f.ker.ideal U) := by
    intro U
    have hker : f.ker.ideal U = RingHom.ker (f.app U).hom := Scheme.Hom.ker_apply f U
    haveI : _root_.IsReduced (Γ(X, f ⁻¹ᵁ (U : Y.Opens))) := IsReduced.component_reduced _
    haveI : _root_.IsReduced ((Γ(Y, (U : Y.Opens)) : Type u) ⧸ RingHom.ker (f.app U).hom) :=
      isReduced_of_injective (RingHom.kerLift (f.app U).hom) (RingHom.kerLift_injective _)
    exact isReduced_of_injective (Ideal.quotEquivOfEq hker).toRingHom
      (Ideal.quotEquivOfEq hker).injective
  apply +allowSynthFailures @IsReduced.of_openCover
    (𝒰 := f.ker.subschemeCover.openCover)
  intro U
  haveI : _root_.IsReduced ((f.ker.subschemeCover.X U : CommRingCat.{u}) : Type u) := hquot U
  exact inferInstanceAs (IsReduced (Spec (f.ker.subschemeCover.X U)))

/-- **The scheme-theoretic image of an integral scheme is integral** (`PLAN.md` WP-3a).

Integrality is irreducibility plus reducedness (`isIntegral_iff_irreducibleSpace_and_isReduced`),
and both are inherited by the image of a quasi-compact morphism. -/
theorem isIntegral_image (f : X ⟶ Y) [QuasiCompact f] [IsIntegral X] :
    IsIntegral f.image := by
  haveI := irreducibleSpace_image f
  haveI := isReduced_image f
  exact isIntegral_of_irreducibleSpace_of_isReduced _

/-! ### Transport of relative birationality along a change of base

Two small general lemmas, both absent from Mathlib's `Birational/Birational.lean`, needed to move
a birational equivalence from a dense affine open of the base to the base itself. -/

/-- A partial isomorphism over `S` is a partial isomorphism over any scheme `S` maps to. -/
theorem PartialIso.IsOver.comp {S S' X Y : Scheme.{u}} {sX : X ⟶ S} {sY : Y ⟶ S}
    {f : X.PartialIso Y} (h : f.IsOver sX sY) (g : S ⟶ S') :
    f.IsOver (sX ≫ g) (sY ≫ g) := by
  have h' := congrArg (fun φ => φ ≫ g) h
  simpa only [PartialIso.IsOver, Category.assoc] using h'

/-- Birationality over `S` implies birationality over any scheme `S` maps to. -/
theorem BirationalOver.comp {S S' X Y : Scheme.{u}} {sX : X ⟶ S} {sY : Y ⟶ S}
    (h : BirationalOver sX sY) (g : S ⟶ S') : BirationalOver (sX ≫ g) (sY ≫ g) :=
  ⟨h.partialIso, (h.partialIso_isOver sX sY).comp g⟩

/-- Relative affine space over a dense open of the base is birational, over the base, to relative
affine space over the whole base. -/
theorem birationalOver_affineSpace_comp {S T : Scheme.{u}} (n : Type u) (ψ : S ⟶ T)
    [IsOpenImmersion ψ] [IsDominant ψ] :
    BirationalOver ((𝔸(n; S) ↘ S) ≫ ψ) (𝔸(n; T) ↘ T) := by
  haveI : IsOpenImmersion (AffineSpace.map n ψ) := by
    have hpb := AffineSpace.isPullback_map (n := n) ψ
    have h : AffineSpace.map n ψ =
        hpb.isoPullback.hom ≫ Limits.pullback.fst (𝔸(n; T) ↘ T) ψ :=
      hpb.isoPullback_hom_fst.symm
    rw [h]; infer_instance
  haveI : IsDominant (AffineSpace.map n ψ) :=
    BConicBundleMultisections.isDominant_affineSpace_map n ψ
  exact Scheme.Hom.birationalOver (AffineSpace.map n ψ) (𝔸(n; T) ↘ T)
    ((𝔸(n; S) ↘ S) ≫ ψ) (AffineSpace.map_over (n := n) ψ)

end AlgebraicGeometry.Scheme

namespace BConicBundleMultisections

noncomputable section

open AlgebraicGeometry MvPolynomial BiprojectiveSpace
open _root_.MvPolynomial

/-! ### The residual component is integral -/

variable {k : Type u} [Field k]
  (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
  (v : Fin 3 → Polynomial k)
  (hv : TernaryQuadraticPoly.eval (coordinateLineTernaryQuadraticPoly F) v = 0)
  (i j : Fin 3)

/-- The localized residual chart ring is a domain when the chart denominator is nonzero: it is a
localization of the polynomial ring `k[t,s]` at the powers of a nonzero element. -/
theorem isDomain_residualChartLoc (hdenom : residualChartDenom F v i j ≠ 0) :
    IsDomain (residualChartLoc F v i j) :=
  IsLocalization.isDomain_localization
    (powers_le_nonZeroDivisors_of_noZeroDivisors hdenom)

/-- **The residual component `T_L` is integral** (`PLAN.md` WP-3a).

`T_L` is the scheme-theoretic image of `Spec` of the localized residual chart ring, which is a
domain as soon as the chart denominator is nonzero; images of integral schemes under quasi-compact
morphisms are integral (`AlgebraicGeometry.Scheme.isIntegral_image`).

This is what makes `Scheme.functionField T_L` — the field over which the generic fibre of the
base-changed conic bundle is a conic — available. -/
theorem isIntegral_residualComponent (hdenom : residualChartDenom F v i j ≠ 0) :
    IsIntegral (residualComponent F hF v hv i j) := by
  haveI := isDomain_residualChartLoc F v i j hdenom
  exact AlgebraicGeometry.Scheme.isIntegral_image
    (residualImagePointOfNormalizedLoc F hF v hv i j)

/-! ### The conic bundle is smooth over a dense open of its base -/

/-- **Generic smoothness for the conic bundle** (source §1).

For `k` algebraically closed of characteristic zero and `X = V(F)` smooth over `k`, the second
projection `X → ℙ²_y` is smooth over some nonempty open of `ℙ²_y`; since `ℙ²_y` is irreducible
that open is dense.

Characteristic zero is essential and this is where it is used: in positive characteristic the
generic fibre of a dominant morphism from a smooth variety can be everywhere singular.

Geometrically this says the *generic conic* of the bundle is smooth, i.e. the discriminant of the
conic bundle is not identically zero.  It is the input that excludes the degenerate cases in which
obligation 3 would be false; see the module docstring. -/
theorem exists_dense_open_smooth_biprojectiveZeroLocusSnd
    {k : Type u} [Field k] [IsAlgClosed k] [CharZero k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    [Smooth (biprojectiveZeroLocusToSpec 2 2 k F)] :
    ∃ U : (ProjectiveSpace 2 k).Opens,
      Dense (U : Set (ProjectiveSpace 2 k)) ∧
        Smooth (biprojectiveZeroLocusSnd 2 2 k F ∣_ U) := by
  obtain ⟨U, hU, hsmooth⟩ :=
    Standard.exists_nonempty_open_smooth_restrict
      (biprojectiveZeroLocusToSpec 2 2 k F) (ProjectiveSpace.toSpec 2 k)
      (biprojectiveZeroLocusSnd 2 2 k F) (biprojectiveZeroLocusSnd_toSpec 2 2 k F)
  refine ⟨U, ?_, hsmooth⟩
  exact U.isOpen.dense (Set.nonempty_coe_sort.mp hU)

/-! ### The remaining leaf: spreading out the affine model -/

/--
**Spreading out: the pointed conic bundle has a pointed *affine* model over a dense open of the
base** (source §4–§5; `PLAN.md` WP-3e).

*Statement.*  Let `F` be a nonzero bidegree-`(2,3)` form, so the fibres of
`π := biprojectiveZeroLocusSnd 2 2 k F : X → ℙ²_y` are plane conics in `ℙ²_x`; let `T` be integral
and dominate `ℙ²_y`; let `s` be a section of the base change; and let the bundle be smooth over a
dense open `U` of `ℙ²_y`.  Then there is a domain `A`, a dominant open immersion
`ψ : Spec A ⟶ T`, and coefficients `a, b, c, d, e'` such that the base change `X ×_{ℙ²_y} T → T` is
`T`-birational to the pointed affine conic `a x² + b x y + c y² + d x + e' y = 0` over `Spec A`,
that conic being integral with nonzero slope polynomials and nonempty stereographic chart.

*Why it is true, and why this is all that is left.*  `T` is integral, so it has a generic point `η`
and a function field `K := k(T)`.  Dominance of `t` and density of `U` put `t η` at the generic
point of `ℙ²_y`, which lies in `U`; smoothness of `π ∣_ U` therefore makes the fibre `X_{t η}` a
*smooth* plane curve.  It is a *conic*, i.e. cut out by a nonzero quadratic form: the coefficients
of `F(·, y)` are the cubics in `y` obtained from the bihomogeneous coefficients of `F`, so they
vanish at the generic point of `ℙ²_y` only if `F = 0`, which `hF0` excludes.  A nonzero quadratic
form whose projective zero locus is smooth is nondegenerate — a double line gives a non-reduced
scheme, a line pair a singular point — and smoothness survives base change to `K`.  So the generic
fibre of `pullback.snd π t → T` is a smooth plane conic over `K` with a `K`-point, namely `s`.
Shrinking `T` to a small enough affine open `Spec A` makes all of this spread out: the conic bundle
becomes a conic in `ℙ²_A`, the section becomes an `A`-point, one may delete the line at infinity
through that point and translate it to the origin, and the result is exactly
`PointedConic.conicPoly a b c d e'`.  Integrality of the conic ring and nonvanishing of the slope
polynomials `Q(z) = a + bz + cz²` and `L(z) = d + e' z` hold after further shrinking, because they
hold at the generic point (an integral conic with a nondegenerate quadratic part).

The stereographic chart is automatically nonempty
(`PointedConic.conicMk_conicChartDenom_ne_zero`: substituting `y = z x` sends `f` to a polynomial
of degree `2` in `x` while `x` and `d x + e' y` go to polynomials of degree `1`, and degrees add
over a domain), so it is not among the data to be produced.

Everything downstream of this statement is *proved*: the pointed affine conic over a domain is
`Spec A`-birational to `𝔸(1; Spec A)` by stereographic projection
(`PointedConic.birationalOver_conicScheme_affineSpace`, no `sorry`, no normal form and no Witt
decomposition), and the two transports back to `T` are
`Scheme.BirationalOver.comp` and `Scheme.birationalOver_affineSpace_comp`.

*What Mathlib is missing.*  At the pinned revision there is no spreading-out machinery for schemes
and no "birational ⇔ isomorphic function fields" bridge, so the reduction above has to be performed
by hand with the biprojective chart machinery of this development
(`BiprojectiveChart`, `chartZeroLocusIsoPullback`, `BiprojectiveDehomogenization`).

*Hypotheses that are not decoration.*  Each of `hF0`, `[Smooth …]`, `[IsDominant t]` and the
smoothness of `π ∣_ U` is needed for the conclusion to be *true*, not merely for this proof to
work.

* Without `hF0` there is no affine conic model: for `F = 0` the "zero locus" is all of
  `ℙ²_x × ℙ²_y` and the base change is `ℙ²_T`, which is not `T`-birational to a curve over `T`.
* Without `[Smooth (biprojectiveZeroLocusToSpec 2 2 k F)]` the statement is **false**, by the
  explicit counterexample `F = Y₀³ (X₀X₁ − X₂²)` recorded in the module docstring: some fibre of
  `π` is then the whole of `ℙ²_x`, the base change acquires a vertical component, and no dense open
  of it is integral.  This hypothesis is used only through
  `BiprojectiveSpace.not_specializeSecondCoordinates_eq_zero_of_smooth_bidegree23` (whence also
  `[IsAlgClosed k]`), i.e. only to rule out a whole fibre; every component of `X ×_{ℙ²_y} T` then
  dominates `T`.
* `[IsDominant t]` together with density of `U` is what puts the generic point of `T` over a point
  where the conic is nondegenerate.  Over a base whose image lies in the discriminant the generic
  conic is a line pair or a double line, and the base change is respectively reducible,
  non-`K`-rational, or non-reduced — see the module docstring.

*The section is not over-quantified.*  `s` is arbitrary, and that is safe here precisely because
the generic fibre is a **smooth** conic: stereographic projection from *any* rational point of a
smooth conic is birational, so no choice of section can collapse it.  (Contrast `PLAN.md`
correction 7, where an arbitrary Tsen section could be a base point of the family.)
-/
theorem exists_pointedConicAffineModel
    {k : Type u} [Field k] [IsAlgClosed k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (biprojectiveZeroLocusToSpec 2 2 k F)]
    {T : Scheme.{u}} [IsIntegral T] (t : T ⟶ ProjectiveSpace 2 k) [IsDominant t]
    (s : PullbackSection (biprojectiveZeroLocusSnd 2 2 k F) t)
    (U : (ProjectiveSpace 2 k).Opens) (hU : Dense (U : Set (ProjectiveSpace 2 k)))
    (hsmooth : Smooth (biprojectiveZeroLocusSnd 2 2 k F ∣_ U)) :
    ∃ (A : Type u) (_ : CommRing A) (_ : IsDomain A) (a b c d e' : A)
      (_ : IsDomain (PointedConic.conicRing a b c d e'))
      (_ : PointedConic.slopeQuad a b c ≠ 0) (_ : PointedConic.slopeLin d e' ≠ 0)
      (ψ : Spec (CommRingCat.of A) ⟶ T) (_ : IsOpenImmersion ψ) (_ : IsDominant ψ),
      Scheme.BirationalOver
        (Limits.pullback.snd (biprojectiveZeroLocusSnd 2 2 k F) t)
        (PointedConic.conicSchemeToSpec a b c d e' ≫ ψ) :=
  sorry

/--
**Obligation 3, reduced to the spreading-out step.**

Given the affine model of `exists_pointedConicAffineModel`, the conclusion is now pure transport:
the model is `Spec A`-birational to `𝔸(1; Spec A)` by the *proved*
`PointedConic.birationalOver_conicScheme_affineSpace`, birationality over `Spec A` gives
birationality over `T` (`Scheme.BirationalOver.comp`), and `𝔸(1; Spec A)` over a dense open is
birational over `T` to `𝔸(1; T)` (`Scheme.birationalOver_affineSpace_comp`).
-/
theorem isPointedConicRationalOver_of_dense_open_smooth
    {k : Type u} [Field k] [IsAlgClosed k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (biprojectiveZeroLocusToSpec 2 2 k F)]
    {T : Scheme.{u}} [IsIntegral T] (t : T ⟶ ProjectiveSpace 2 k) [IsDominant t]
    (s : PullbackSection (biprojectiveZeroLocusSnd 2 2 k F) t)
    (U : (ProjectiveSpace 2 k).Opens) (hU : Dense (U : Set (ProjectiveSpace 2 k)))
    (hsmooth : Smooth (biprojectiveZeroLocusSnd 2 2 k F ∣_ U)) :
    IsPointedConicRationalOver (biprojectiveZeroLocusSnd 2 2 k F) t s := by
  obtain ⟨A, instCR, instID, a, b, c, d, e', instCD, hQ, hL, ψ, instOI, instDom, hbir⟩ :=
    exists_pointedConicAffineModel F hF hF0 t s U hU hsmooth
  letI := instCR
  letI := instID
  letI := instCD
  haveI := instOI
  haveI := instDom
  have hden : PointedConic.conicMk a b c d e' (PointedConic.conicChartDenom d e') ≠ 0 :=
    PointedConic.conicMk_conicChartDenom_ne_zero a b c d e' hQ hL
  refine hbir.trans (((PointedConic.birationalOver_conicScheme_affineSpace
    a b c d e' hQ hL hden).comp ψ).trans ?_)
  exact Scheme.birationalOver_affineSpace_comp (ULift.{u} (Fin 1)) ψ

/-! ### Horizontality of the residual component -/

/-- Horizontality of the residual component, packaged from obligation 2.

`isDominant_residualImagePointOfNormalizedLoc_toBase` (WP-B, `ResidualComponentHorizontality`) is
the concrete coordinate statement that the localized residual map dominates `ℙ²_y`;
`isDominant_residualComponentToBase` (proved) transfers it to the component.  Obligation 2 has
exactly the hypotheses of obligation 3, so this adds no assumption — but obligation 3 now depends
on obligation 2, which is where the source's **choice of the multisection line** is owed. -/
theorem isDominant_residualComponentToBase_of_smooth
    {k : Type u} [Field k] [IsAlgClosed k] [CharZero k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (biprojectiveZeroLocusToSpec 2 2 k F)]
    (v : Fin 3 → Polynomial k) (hv0 : v ≠ 0)
    (hv : TernaryQuadraticPoly.eval (coordinateLineTernaryQuadraticPoly F) v = 0)
    (i j : Fin 3) (hdenom : residualChartDenom F v i j ≠ 0) :
    IsDominant (residualComponentToBase F hF v hv i j) :=
  isDominant_residualComponentToBase F hF v hv i j
    (isDominant_residualImagePointOfNormalizedLoc_toBase F hF hF0 v hv0 hv i j hdenom)

/-! ### Obligation 3 -/

/--
**Obligation 3.**  The conic bundle base-changed to the residual component is birational over that
component to relative affine `1`-space.

*Status.* Reduced to the single leaf `isPointedConicRationalOver_of_dense_open_smooth`; see the
module docstring for the decomposition and for why the horizontality input is load-bearing rather
than decorative.

Downstream of this obligation everything is already wired:
`hasUnirationalParametrization1_residualComponentBaseChangeSnd` consumes it directly.
-/
theorem isResidualComponentPointedConicRational_of_smooth
    {k : Type u} [Field k] [IsAlgClosed k] [CharZero k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (biprojectiveZeroLocusToSpec 2 2 k F)]
    (v : Fin 3 → Polynomial k) (hv0 : v ≠ 0)
    (hv : TernaryQuadraticPoly.eval (coordinateLineTernaryQuadraticPoly F) v = 0)
    (i j : Fin 3) (hdenom : residualChartDenom F v i j ≠ 0) :
    IsResidualComponentPointedConicRational F hF v hv i j := by
  haveI : IsIntegral (residualComponent F hF v hv i j) :=
    isIntegral_residualComponent F hF v hv i j hdenom
  haveI : IsDominant (residualComponentToBase F hF v hv i j) :=
    isDominant_residualComponentToBase_of_smooth F hF hF0 v hv0 hv i j hdenom
  obtain ⟨U, hU, hsmooth⟩ := exists_dense_open_smooth_biprojectiveZeroLocusSnd F
  exact isPointedConicRationalOver_of_dense_open_smooth F hF hF0
    (residualComponentToBase F hF v hv i j)
    (residualComponentMultisection F hF v hv i j).tautologicalPullbackSection U hU hsmooth

end

end BConicBundleMultisections
