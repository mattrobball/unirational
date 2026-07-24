# Formalization status

Authoritative statement of what the Lean development does and does not prove.
Supersedes the status claims in `HANDOFF.md` wherever they conflict — `HANDOFF.md` is
substantially stale (it is written around `ResidualImageDominance.lean`, deleted in `cb34fbf`).

## Headline

The main theorem is now stated **faithfully** — no auxiliary hypotheses:

```lean
theorem smooth_bidegree23_hasUnirationalParametrization
    (k : Type u) [Field k] [IsAlgClosed k] [CharZero k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (Bidegree23ZeroLocus.toSpec k F)] :
    HasUnirationalParametrization 3 (Bidegree23ZeroLocus.toSpec k F)
```

It is **not fully proved**. The outstanding obligations are collected in four modules, one per
work package, inventoried in `BConicBundleMultisections/ResidualComponentAssembly.lean`, and
appear nowhere else. They are ordinary declarations named for their mathematical content, so
discharging one means deleting its `sorry` with no call site changing. Everything else in the tree
is complete, so

```
#print axioms smooth_bidegree23_hasUnirationalParametrization
  → [propext, sorryAx, Classical.choice, Quot.sound]
```

is now an exact measure of what is owed: `sorryAx` disappears precisely when the obligations are
discharged. This is a deliberate trade against the previous arrangement, where the tree was
`sorry`-free but the theorem carried a hypothesis `hXT` that was doing the same job invisibly —
and, worse, was false in general (see below). **Check the statement and the axiom list together.**

Build: `lake build` green, 3067 jobs, Lean `v4.32.1` / Mathlib `v4.32.1`.

`MainTheoremGuard.lean` mechanises both halves of that check. It pins the headline statement (an
added hypothesis breaks the build), allows `sorryAx` but no other axiom in the main theorem, and
asserts that the load-bearing proved results stay fully proved. Both guards are negative-tested.

## Why the argument runs on the residual *component*

`residualImage F` is the complete intersection `V(F) ∩ V(q_F)`. When the degree-ten coefficients
of `q_F` share a common factor, `V(q_F)` acquires a vertical divisor and `residualImage F` gains
components the residual map never meets. Since affine space is irreducible, the closure of its
image under any rational map is irreducible, so no dominant rational map onto a reducible target
exists. Hence, in that case:

- `HasUnirationalParametrization 2 (residualImageToSpec F)` is **false**, and
- so is `HasResidualBaseChangeUnirationalParametrization3 F`, because the base change
  `X ×_{ℙ²_y} residualImage F` inherits the extra components (the conic fibres over them are
  nonempty, `BiprojectiveFiberNonempty`).

The former was recorded here previously; the latter was not, and it is the more serious of the
two, because `hXT` was the hypothesis of the main theorem. The old headline theorem was therefore
*vacuous* in exactly the cases the tangent-residual argument is needed for.

`RESOLUTION.md:246` already took the class `aH_x + H_y` only "after removing their common factor
and any components over special x-curves"; the Lean definition never performed that removal.

The live argument instead runs on `residualComponent F hF v hv i j` — the scheme-theoretic image
of the localized residual chart map, i.e. the component the residual map actually dominates.
Dominance onto it is Mathlib's `IsDominant f.toImage`, not an assumption.

## Proved unconditionally

- **Tsen for ternary quadratics over `k[t]`**, `k` algebraically closed —
  `exists_isotropic_ternary_quadratic_poly` (`TsenConic.lean`). A full undetermined-coefficients
  proof; this is the substantive classical input and it is done.
- **The universal residual identity** `polarResultant + disc · cubicValue = W² · residualLinear`
  (`UniversalResidualIdentity.lean`).
- **No whole fibre in either projection** for smooth `F`, and surjectivity/dominance of both
  projections (WP2: `BiprojectiveNoWholeFiber`, `BiprojectiveProjectionDominant`).
- `residualImageXCoords_ne_zero_of_smooth` — residual `X`-coordinates nonvanishing from
  smoothness alone, via `specializedConicFreeDirForm_ne_zero_of_smooth`.
- `residual_baseChange_package_summary` — dominance of the residual multisection base change plus
  existence of a Tsen section.
- `hasUnirationalParametrization2_residualComponent` — the residual component `T_L` is unirational
  over `Spec k`, given a nonvanishing chart denominator (obligation 1 supplies that).
- `isDominant_residualComponentMultisection_baseChangeFst` — component horizontality upgrades to
  base-change dominance, via properness ⇒ surjectivity ⇒ stability under base change. **No
  flatness hypothesis on the conic bundle is used anywhere**; `Flat` is nowhere proved in the tree.
- The multisection principle and its dominance-form reduction.
- **The unirational tower** `hasUnirationalParametrization_succ_of_tower` (WP-A, closed), with
  `mapPartialMap`, `comp_hom_over`, `exists_isOver_representative` and
  `UnirationalParametrization.ofPartialMapOver`.
- `mapPartialMap` — transport of a *partial* map along `𝔸(n; -)`, which Mathlib provides only for
  morphisms, together with `range_affineSpace_map`, `isOpenImmersion_affineSpace_map` and
  `isDominant_mapPartialMap_hom`. This is the dominance half of the unirational tower, and the
  reason the tower needs no integrality hypotheses: the composite
  `𝔸(1; 𝔸(m; S)) → 𝔸(1; T) ⤏ Y` never base-changes the target.
- `residualComponentMultisection_baseChangeSnd_comp_toSpec` — the component compatibility that
  turns the general tower into the `2 + 1 = 3` instance the main theorem consumes.

## The remaining obligations

One per module, inventoried in `ResidualComponentAssembly.lean`; see each docstring for what the
real proof has to establish, and `PLAN.md` for the work packages.

| Module | Obligation | Nature | Risk |
|--------|-----------|--------|------|
| `ResidualYNonvanishing` | `exists_three_freeDir_polar_roots` (1a) | elementary | low |
| | `residualImageXCoords_two_ne_zero` (1b) | reindexing refactor | low |
| | `residualBinaryLine_ne_zero_of_singular_at_coordinateLinePoint` (1c) | plausibly vacuous | low |
| | `residualBinaryLine_ne_zero_of_tangent_not_coordinateLine` (1d) | **the crux** | highest |
| `ResidualComponentHorizontality` | `isDominant_residualImagePointOfNormalizedLoc_toBase` | coordinate computation | medium |
| `PointedConicRationalFamilies` | `isResidualComponentPointedConicRational_of_smooth` | pointed conics in families | large but classical |


`residualYCoords_ne_zero_of_smooth` is no longer an obligation: it is derived from 1a–1d by a
three-way case analysis on the residual tangent direction, with the case the development already
handled (tangent line *is* the coordinate line) proved outright.

Obligation 1d is the load-bearing blocker and the item to put to a human expert. Phase 0 of
`PLAN.md` traced what every hypothesis of the one written proof actually feeds and found the
blocker had been mis-scoped here and in `HANDOFF.md`. What was described as "the `freeDirPureT`
branch" is obligation 1a, and is elementary: those hypotheses serve *only* to produce three
distinct free-direction polar roots for a branch-free lemma that is already proved. The real
blocker is `hq2`, which by Euler's identity is equivalent to `g₁ = 0` — i.e. to the tangent line of
the residual cubic at the coordinate-line point *being* the coordinate line. That is non-generic,
it is the only case the written argument covers, and the generic case `g₁ ≢ 0` (obligation 1d) has
no argument at all.

**Correction (superseding the above).** Checking the natural-language proof shows this diagnosis
was wrong. `certificates/all_smooth_tangent_residual_theorem.md` §3–4 **chooses** the line `L`
subject to four nonempty open conditions, and normalises coordinates to `L = {W = 0}` only
afterwards (§5); its introduction states explicitly that "a fixed `L` can have a nontrivial common
factor". This development hardcodes `L = {Y₂ = 0}` with no genericity predicate anywhere.

So obligations 1c and 1d — which quantify over all smooth `F` with a fixed line — are not what the
paper proves and are plausibly false. Gap B is not research-level mathematics: §1 makes the generic
cubic fibre **smooth** by generic smoothness, and a smooth plane cubic contains no line, so the
degeneracy cannot arise for a general line. Generic smoothness is therefore **required**, as the
paper's first step, not avoidable. See `PLAN.md`, "Correction: the missing good line", and the new
work package WP-G.

## Not verified

No concrete `F` is exhibited in Lean together with a proof of
`Smooth (biprojectiveZeroLocusToSpec 2 2 k F)`. Every `_of_smooth` theorem is conditional on an
instance nobody has constructed, and an axiom check cannot detect a vacuous hypothesis. External
Macaulay2 certificates exist under `certificates/`, but there is no Lean-level witness. See
`PLAN.md` WP-E.

## Provenance

Lean sources are machine-generated. The claims above were checked by reading the statements, by
`#print axioms`, and by confirming compilation; the whole tree has not been line-by-line reviewed.
