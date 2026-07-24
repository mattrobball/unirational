/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import BConicBundleMultisections.ResidualComponent

/-!
# The unirational tower `m + 1`

See `ResidualComponentAssembly.lean` for the inventory of obligations and `PLAN.md` WP-A for the
work package.

## What is here

`AffineSpace.map` is available in Mathlib only for *morphisms*, but both halves of a unirational
tower are genuinely *rational* maps, which is why the two parametrizations cannot simply be
composed.  This module supplies the missing transport, `mapPartialMap`, together with everything
needed to know it is dominant:

* `range_affineSpace_map` — `Set.range (AffineSpace.map n f)` is the preimage of `Set.range f`
  under the projection.  This was previously buried inside the proof of
  `isDominant_affineSpace_map`; it is the computation that makes the transport work.
* `isOpenImmersion_affineSpace_map` — `AffineSpace.map n f` is an open immersion when `f` is, by
  base change along `𝔸(n; T) ↘ T`.
* `mapPartialMap` — transport of a partial map along `𝔸(n; -)`.  Its domain is the open subscheme
  of `𝔸(n; X)` lying over the domain of `f`, dense because the projection is an open map.
* `isDominant_mapPartialMap_hom` — the transported map is dominant.

**The composition path never base-changes the target.**  It is
`𝔸(1; 𝔸(m; S)) → 𝔸(1; T) ⤏ Y`: only the *base* parametrization is mapped up, `Y` is untouched.
That is why no integrality hypotheses are needed, and why the tower lemma below is true as stated
for arbitrary `T` and `Y`.
-/

@[expose] public section

open CategoryTheory Limits
open scoped AlgebraicGeometry

namespace BConicBundleMultisections

noncomputable section

universe u

open AlgebraicGeometry MvPolynomial BiprojectiveSpace

/-! ### Transporting a partial map along `𝔸(n; -)` -/

section Transport

variable {S T : Scheme.{u}} (n : Type u)

/-- The range of `AffineSpace.map n f` is the preimage of the range of `f`.

Factored out of the proof of `isDominant_affineSpace_map`, where it was inlined; it is the
geometric content behind both that lemma and `dense_mapDomain`. -/
theorem range_affineSpace_map (f : S ⟶ T) :
    Set.range (AffineSpace.map n f) = (𝔸(n; T) ↘ T) ⁻¹' Set.range f := by
  have hpb := AffineSpace.isPullback_map (n := n) f
  have hfst := hpb.isoPullback_hom_fst
  have hr := Scheme.Pullback.range_fst (𝔸(n; T) ↘ T) f
  have hfun :
      (⇑(AffineSpace.map n f) : _) =
        (⇑(Limits.pullback.fst (𝔸(n; T) ↘ T) f) : _) ∘ (⇑hpb.isoPullback.hom : _) := by
    funext y
    have h := congr_arg (fun (φ : 𝔸(n; S) ⟶ 𝔸(n; T)) => (φ : _) y) hfst.symm
    simpa only [Scheme.Hom.comp_apply, Function.comp_apply] using h
  have hsurj : Function.Surjective (⇑hpb.isoPullback.hom) :=
    (inferInstance : Surjective hpb.isoPullback.hom).1
  rw [hfun, Set.range_comp, Set.range_eq_univ.mpr hsurj, Set.image_univ, hr]

/-- `AffineSpace.map` of an open immersion is an open immersion: it is a base change of `f` along
`𝔸(n; T) ↘ T`. -/
instance isOpenImmersion_affineSpace_map (f : S ⟶ T) [IsOpenImmersion f] :
    IsOpenImmersion (AffineSpace.map n f) := by
  have hpb := AffineSpace.isPullback_map (n := n) f
  have h : AffineSpace.map n f
      = hpb.isoPullback.hom ≫ Limits.pullback.fst (𝔸(n; T) ↘ T) f :=
    hpb.isoPullback_hom_fst.symm
  rw [h]; infer_instance

end Transport

section MapPartialMap

variable {X Y : Scheme.{u}}

/-- The open subscheme of `𝔸(n; X)` lying over the domain of a partial map. -/
def mapDomain (n : Type u) (g : X.PartialMap Y) : (𝔸(n; X)).Opens :=
  (AffineSpace.map n g.domain.ι).opensRange

/-- The domain of the transported partial map is dense: it is the preimage of a dense open under
the projection `𝔸(n; X) ↘ X`, which is an open map. -/
theorem dense_mapDomain (n : Type u) (g : X.PartialMap Y) :
    Dense (mapDomain n g : Set 𝔸(n; X)) := by
  have hrange : ((mapDomain n g : (𝔸(n; X)).Opens) : Set 𝔸(n; X))
      = (𝔸(n; X) ↘ X) ⁻¹' (g.domain : Set X) := by
    show Set.range (AffineSpace.map n g.domain.ι) = _
    rw [range_affineSpace_map]
    congr 1
    exact g.domain.range_ι
  rw [hrange]
  exact g.dense_domain.preimage (AffineSpace.isOpenMap_over (n := n) (S := X))

/-- **Transport of a partial map along `𝔸(n; -)`.**  The counterpart of `AffineSpace.map` for
maps that are only rational, which Mathlib does not provide. -/
def mapPartialMap (n : Type u) (g : X.PartialMap Y) : (𝔸(n; X)).PartialMap (𝔸(n; Y)) where
  domain := mapDomain n g
  dense_domain := dense_mapDomain n g
  hom := (Scheme.Hom.isoOpensRange (AffineSpace.map n g.domain.ι)).inv ≫
    AffineSpace.map n g.hom

instance isDominant_mapPartialMap_hom (n : Type u) (g : X.PartialMap Y) [IsDominant g.hom] :
    IsDominant (mapPartialMap n g).hom := by
  show IsDominant ((Scheme.Hom.isoOpensRange (AffineSpace.map n g.domain.ι)).inv ≫
    AffineSpace.map n g.hom)
  haveI : IsDominant (AffineSpace.map n g.hom) := isDominant_affineSpace_map n g.hom
  infer_instance

end MapPartialMap

/-! ### Representatives that lie over the base on the nose -/

/-- **Every chosen unirational parametrization has a representative partial map that lies over the
base strictly**, not merely up to equivalence of partial maps.

`UnirationalParametrization.isOver` is an equation between *rational* maps, so a representative
`g` of the parametrization satisfies `g.hom ≫ sX = g.domain.ι ≫ (𝔸 ↘ S)` only after restricting
to a dense open on which the two agree.  This lemma performs that restriction once and for all;
without it, every `isOver` computation downstream has to redo it. -/
theorem exists_isOver_representative {S X : Scheme.{u}} {n : ℕ} {sX : X ⟶ S}
    (q : UnirationalParametrization n sX) :
    ∃ g : (𝔸(ULift.{u} (Fin n); S)).PartialMap X,
      IsDominant g.hom ∧ g.toRationalMap = q.map ∧
      g.hom ≫ sX = g.domain.ι ≫ (𝔸(ULift.{u} (Fin n); S) ↘ S) := by
  obtain ⟨g, hg⟩ := Scheme.PartialMap.toRationalMap_surjective q.map
  haveI : IsDominant g.hom := by
    refine g.isDominant_toRationalMap_iff.mp ?_
    rw [hg]; exact q.isDominant
  have hover : (g.compHom sX).toRationalMap =
      ((𝔸(ULift.{u} (Fin n); S) ↘ S)).toRationalMap := by
    rw [Scheme.RationalMap.compHom_toRationalMap, hg]
    exact q.isOver
  obtain ⟨W, hW, hWl, hWr, e⟩ := Scheme.PartialMap.toRationalMap_eq_iff.mp hover
  have hWg : W ≤ g.domain := hWl
  refine ⟨g.restrict W hW hWg, ?_, ?_, ?_⟩
  · refine (g.restrict W hW hWg).isDominant_toRationalMap_iff.mp ?_
    rw [Scheme.PartialMap.toRationalMap_eq_iff.mpr (g.restrict_equiv W hW hWg), hg]
    exact q.isDominant
  · exact (Scheme.PartialMap.toRationalMap_eq_iff.mpr (g.restrict_equiv W hW hWg)).trans hg
  · have hι : W.ι = (𝔸(ULift.{u} (Fin n); S)).homOfLE hWr ≫
        (𝔸(ULift.{u} (Fin n); S)).topIso.hom := by
      rw [Scheme.topIso_hom]
      exact (Scheme.homOfLE_ι _ hWr).symm
    simp only [Scheme.PartialMap.compHom, Scheme.Hom.toPartialMap,
      Scheme.PartialMap.restrict_hom] at e
    show ((𝔸(ULift.{u} (Fin n); S)).homOfLE hWg ≫ g.hom) ≫ sX
        = W.ι ≫ (𝔸(ULift.{u} (Fin n); S) ↘ S)
    rw [Category.assoc, hι, Category.assoc]
    exact e

/-- **The transported base parametrization lies over the base strictly.**

The first half of the tower's `isOver` identity, and the only part with any content: given a
representative `g` of the base parametrization that lies over `Spec R` strictly
(`exists_isOver_representative`), its transport along `𝔸(1; -)` again lies over `Spec R` strictly.

Two applications of `AffineSpace.map_over` reduce both sides to `g.hom ≫ sT` and
`g.domain.ι ≫ (𝔸(m; Spec R) ↘ Spec R)`, which `hg` identifies.

Note the final step is a *term-level* `Category.assoc`, not a rewrite: `𝔸(1; 𝔸(m; Spec R)) ↘ Spec R`
is definitionally the composite `(… ↘ 𝔸(m; Spec R)) ≫ (𝔸(m; Spec R) ↘ Spec R)`, but not
syntactically, so `rw`/`simp` cannot match it while `exact` accepts it by defeq. -/
theorem mapPartialMap_hom_over
    {R : CommRingCat.{u}} {T : Scheme.{u}} {m : ℕ} (sT : T ⟶ Spec R)
    (g : (𝔸(ULift.{u} (Fin m); Spec R)).PartialMap T)
    (hg : g.hom ≫ sT = g.domain.ι ≫ (𝔸(ULift.{u} (Fin m); Spec R) ↘ Spec R)) :
    (mapPartialMap (ULift.{u} (Fin 1)) g).hom ≫ ((𝔸(ULift.{u} (Fin 1); T) ↘ T) ≫ sT)
      = (mapPartialMap (ULift.{u} (Fin 1)) g).domain.ι ≫
        (𝔸(ULift.{u} (Fin 1); 𝔸(ULift.{u} (Fin m); Spec R)) ↘ Spec R) := by
  have key : AffineSpace.map (ULift.{u} (Fin 1)) g.hom ≫ (𝔸(ULift.{u} (Fin 1); T) ↘ T) ≫ sT
      = AffineSpace.map (ULift.{u} (Fin 1)) g.domain.ι ≫
        (𝔸(ULift.{u} (Fin 1); 𝔸(ULift.{u} (Fin m); Spec R)) ↘
          𝔸(ULift.{u} (Fin m); Spec R)) ≫ (𝔸(ULift.{u} (Fin m); Spec R) ↘ Spec R) := by
    rw [← Category.assoc, AffineSpace.map_over, Category.assoc, hg, ← Category.assoc,
      ← AffineSpace.map_over, Category.assoc]
  have hdom : (mapPartialMap (ULift.{u} (Fin 1)) g).domain.ι
      = (Scheme.Hom.isoOpensRange (AffineSpace.map (ULift.{u} (Fin 1)) g.domain.ι)).inv ≫
        AffineSpace.map (ULift.{u} (Fin 1)) g.domain.ι :=
    (Scheme.Hom.isoOpensRange_inv_comp _).symm
  show ((Scheme.Hom.isoOpensRange (AffineSpace.map (ULift.{u} (Fin 1)) g.domain.ι)).inv ≫
      AffineSpace.map (ULift.{u} (Fin 1)) g.hom) ≫ _ = _
  rw [hdom]
  simp only [Category.assoc]
  rw [key]
  exact (Category.assoc _ _ _).symm

/-- **Strictly lying over the base is preserved by composition of partial maps.**

If `f` and `g` each satisfy the strict identity `hom ≫ (structure map) = domain.ι ≫ (structure map)`
then so does `f.comp g`.

Three Mathlib facts do it: `morphismRestrict_ι` turns `f.hom ∣_ g.domain ≫ g.domain.ι` into
`(f.hom ⁻¹ᵁ g.domain).ι ≫ f.hom`; the two hypotheses rewrite what follows; and
`Scheme.Hom.isoImage_inv_ι_assoc` collapses the prefix to the inclusion of `comp`'s domain.

Working at the *partial map* level rather than with `Scheme.RationalMap.comp_assoc` avoids that
lemma's irreducibility side conditions; the instance hypotheses here are exactly the ones
`Scheme.PartialMap.comp` itself requires. -/
theorem comp_hom_over {S X Y Z : Scheme.{u}} [PreirreducibleSpace X] [Nonempty Y]
    (f : X.PartialMap Y) [IsDominant f.hom] (g : Y.PartialMap Z)
    (sX : X ⟶ S) (sY : Y ⟶ S) (sZ : Z ⟶ S)
    (hf : f.hom ≫ sY = f.domain.ι ≫ sX)
    (hg : g.hom ≫ sZ = g.domain.ι ≫ sY) :
    (f.comp g).hom ≫ sZ = (f.comp g).domain.ι ≫ sX := by
  show ((f.domain.ι.isoImage _).inv ≫ (f.hom ∣_ g.domain) ≫ g.hom) ≫ sZ = _
  rw [Category.assoc, Category.assoc, hg,
    ← Category.assoc ((f.hom ∣_ g.domain)) g.domain.ι, morphismRestrict_ι,
    Category.assoc, hf, Scheme.Hom.isoImage_inv_ι_assoc]
  rfl

/-- A dominant partial map from affine `n`-space that lies over the base *strictly* is a
unirational parametrization.  Converse of `exists_isOver_representative`, and the packaging step
of the tower. -/
def UnirationalParametrization.ofPartialMapOver {S X : Scheme.{u}} {n : ℕ} (sX : X ⟶ S)
    (g : (𝔸(ULift.{u} (Fin n); S)).PartialMap X) [IsDominant g.hom]
    (hg : g.hom ≫ sX = g.domain.ι ≫ (𝔸(ULift.{u} (Fin n); S) ↘ S)) :
    UnirationalParametrization n sX where
  map := g.toRationalMap
  isDominant := g.isDominant_toRationalMap_iff.mpr ‹_›
  isOver := by
    rw [← Scheme.RationalMap.compHom_toRationalMap]
    refine Scheme.PartialMap.toRationalMap_eq_iff.mpr ?_
    refine ⟨g.domain, g.dense_domain, le_rfl, le_top, ?_⟩
    have hι : g.domain.ι = (𝔸(ULift.{u} (Fin n); S)).homOfLE (le_top : g.domain ≤ ⊤) ≫
        (𝔸(ULift.{u} (Fin n); S)).topIso.hom := by
      rw [Scheme.topIso_hom]; exact (Scheme.homOfLE_ι _ _).symm
    simp only [Scheme.PartialMap.restrict_hom, Scheme.PartialMap.compHom,
      Scheme.Hom.toPartialMap, Scheme.homOfLE_rfl, Category.id_comp]
    rw [hg, hι, Category.assoc]

/-- Affine space over a nonempty base is nonempty: the projection is surjective. -/
instance nonempty_affineSpace {S : Scheme.{u}} (n : Type u) [Nonempty S] :
    Nonempty (𝔸(n; S)) := by
  obtain ⟨s⟩ := ‹Nonempty S›
  obtain ⟨y, -⟩ := (inferInstance : Surjective (𝔸(n; S) ↘ S)).1 s
  exact ⟨y⟩

/-- A scheme carrying a unirational parametrization by a nonempty affine space is nonempty: the
parametrization's domain is dense, hence nonempty, and maps into it. -/
theorem nonempty_of_hasUnirationalParametrization {S X : Scheme.{u}} {n : ℕ} {sX : X ⟶ S}
    [Nonempty (𝔸(ULift.{u} (Fin n); S))] (h : HasUnirationalParametrization n sX) :
    Nonempty X := by
  obtain ⟨q⟩ := h
  obtain ⟨g, -⟩ := Scheme.PartialMap.toRationalMap_surjective q.map
  obtain ⟨x, hx⟩ := g.dense_domain.nonempty
  exact ⟨g.hom ⟨x, hx⟩⟩

/-! ### The tower -/

/--
**The unirational tower.**  A dimension-`m` parametrization of `T` over `Spec R` together with a
dimension-`1` parametrization of `Y` over `T` compose to a dimension-`m + 1` parametrization of
`Y` over `Spec R`.

*Status: proved.*  It is the classical tower; on function fields the chain
`k(Y) ↪ k(T)(t) ↪ k(𝔸ᵐ)(t) = k(𝔸ᵐ⁺¹)`.

*How.*  Entirely at the **partial map** level, which avoids `Scheme.RationalMap.comp_assoc` and
its irreducibility side conditions.  `exists_isOver_representative` gives strict representatives of
both parametrizations; `mapPartialMap_hom_over` transports the base one; `comp_hom_over` composes
the two strict identities twice — once for `𝔸(1; 𝔸(m; Spec R)) ⤏ 𝔸(1; T) ⤏ Y`, once to transport
along `AffineSpaceProduct.affineOneOverAffineIso`; and `UnirationalParametrization.ofPartialMapOver`
packages the result.

*Hypotheses.*  The `PreirreducibleSpace` and `Nonempty` instances are exactly what
`Scheme.PartialMap.comp` requires, no more.  At the call site they are discharged automatically
except `Nonempty T`, which `nonempty_of_hasUnirationalParametrization` derives from `h2` — a
parametrization out of a nonempty affine space forces its target nonempty.

*Statement scope.*  `Spec R` rather than an arbitrary base scheme, because
`AffineSpaceProduct.affineOneOverAffineIso` is stated there; fibre dimension `1` because that is
the only case the residual argument needs and the only case that iso covers.
-/
theorem hasUnirationalParametrization_succ_of_tower
    {R : CommRingCat.{u}} {T Y : Scheme.{u}} {m : ℕ}
    [PreirreducibleSpace (𝔸(ULift.{u} (Fin 1); 𝔸(ULift.{u} (Fin m); Spec R)))]
    [PreirreducibleSpace (𝔸(ULift.{u} (Fin (m + 1)); Spec R))]
    [Nonempty (𝔸(ULift.{u} (Fin 1); T))]
    [Nonempty (𝔸(ULift.{u} (Fin 1); 𝔸(ULift.{u} (Fin m); Spec R)))]
    (sT : T ⟶ Spec R) (p : Y ⟶ T)
    (h2 : HasUnirationalParametrization m sT)
    (h1 : HasUnirationalParametrization 1 p) :
    HasUnirationalParametrization (m + 1) (p ≫ sT) := by
  obtain ⟨q2⟩ := h2
  obtain ⟨q1⟩ := h1
  obtain ⟨g2, hg2d, -, hg2o⟩ := exists_isOver_representative q2
  obtain ⟨g1, hg1d, -, hg1o⟩ := exists_isOver_representative q1
  haveI := hg2d; haveI := hg1d
  haveI : IsDominant (mapPartialMap (ULift.{u} (Fin 1)) g2).hom :=
    isDominant_mapPartialMap_hom _ g2
  -- the composite `𝔸(1; 𝔸(m; Spec R)) ⤏ 𝔸(1; T) ⤏ Y` lies over `Spec R` strictly
  have hψover := comp_hom_over (mapPartialMap (ULift.{u} (Fin 1)) g2) g1
    (𝔸(ULift.{u} (Fin 1); 𝔸(ULift.{u} (Fin m); Spec R)) ↘ Spec R)
    ((𝔸(ULift.{u} (Fin 1); T) ↘ T) ≫ sT) (p ≫ sT)
    (mapPartialMap_hom_over sT g2 hg2o)
    (by rw [← Category.assoc, hg1o, Category.assoc])
  -- transport to `𝔸(m + 1; Spec R)`
  set e := AffineSpaceProduct.affineOneOverAffineIso R m with he
  have heinv : e.inv ≫ (𝔸(ULift.{u} (Fin 1); 𝔸(ULift.{u} (Fin m); Spec R)) ↘ Spec R)
      = (𝔸(ULift.{u} (Fin (m + 1)); Spec R) ↘ Spec R) := by
    rw [he, ← AffineSpaceProduct.affineOneOverAffineIso_hom_over R m, Iso.inv_hom_id_assoc]
  have hχover := comp_hom_over e.inv.toPartialMap
    ((mapPartialMap (ULift.{u} (Fin 1)) g2).comp g1)
    (𝔸(ULift.{u} (Fin (m + 1)); Spec R) ↘ Spec R)
    (𝔸(ULift.{u} (Fin 1); 𝔸(ULift.{u} (Fin m); Spec R)) ↘ Spec R) (p ≫ sT)
    (by
      simp only [Scheme.Hom.toPartialMap]
      rw [Category.assoc, heinv, Scheme.topIso_hom])
    hψover
  exact ⟨UnirationalParametrization.ofPartialMapOver _ _ hχover⟩

/-! ### The residual component instance -/

section Component

variable {k : Type u} [Field k]
  (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
  (v : Fin 3 → Polynomial k)
  (hv : TernaryQuadraticPoly.eval (coordinateLineTernaryQuadraticPoly F) v = 0)
  (i j : Fin 3)

/-- Going down to `Spec k` through the residual component agrees with going down through the total
space.  Component analogue of `residualMultisection_baseChangeSnd_comp_residualImageToSpec`. -/
theorem residualComponentMultisection_baseChangeSnd_comp_toSpec :
    (residualComponentMultisection F hF v hv i j).baseChangeSnd ≫
        residualComponentToSpec F hF v hv i j =
      (residualComponentMultisection F hF v hv i j).baseChangeFst ≫
        biprojectiveZeroLocusToSpec 2 2 k F := by
  have hw := (residualComponentMultisection F hF v hv i j).baseChange_isPullback.w
  have hπ := biprojectiveZeroLocusSnd_toSpec 2 2 k F
  have hT : residualComponentToBase F hF v hv i j ≫ ProjectiveSpace.toSpec 2 k =
      residualComponentToSpec F hF v hv i j := by
    simp only [residualComponentToBase, residualComponentToSpec, residualImageToBase,
      residualImageToSpec, Category.assoc, BiprojectiveSpace.snd_toSpec]
  have hw' := congrArg (· ≫ ProjectiveSpace.toSpec 2 k) hw
  simp only [Category.assoc] at hw'
  rw [← hT, ← hπ]
  exact hw'.symm

/-- The `2 + 1 = 3` instance of the tower for the residual component: this is what
`ResidualComponentAssembly` consumes.  Now **derived** from the general tower lemma together with
the compatibility above, rather than assumed. -/
theorem hasUnirationalParametrization3_of_component_tower
    (h2 : HasUnirationalParametrization 2 (residualComponentToSpec F hF v hv i j))
    (h1 : HasUnirationalParametrization 1
      (residualComponentMultisection F hF v hv i j).baseChangeSnd) :
    HasUnirationalParametrization 3
      ((residualComponentMultisection F hF v hv i j).baseChangeFst ≫
        biprojectiveZeroLocusToSpec 2 2 k F) := by
  haveI : Nonempty (residualComponent F hF v hv i j) :=
    nonempty_of_hasUnirationalParametrization h2
  rw [← residualComponentMultisection_baseChangeSnd_comp_toSpec F hF v hv i j]
  exact hasUnirationalParametrization_succ_of_tower (R := CommRingCat.of k)
    (residualComponentToSpec F hF v hv i j)
    (residualComponentMultisection F hF v hv i j).baseChangeSnd h2 h1

end Component

end

end BConicBundleMultisections
