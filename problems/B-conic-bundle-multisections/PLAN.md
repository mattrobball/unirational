# Plan: completing the unirationality formalization

## The target, and what it does not claim

```lean
theorem smooth_bidegree23_hasUnirationalParametrization
    (k : Type u) [Field k] [IsAlgClosed k] [CharZero k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (Bidegree23ZeroLocus.toSpec k F)] :
    HasUnirationalParametrization 3 (Bidegree23ZeroLocus.toSpec k F)
```

Pinned by `MainTheoremGuard.lean`. `#print axioms` must end at
`propext, Classical.choice, Quot.sound`.

**It claims a dominant rational map from `𝔸³`. Nothing more** — no degree bound, no divisor class,
no birational model. This is the most load-bearing sentence here: three routing mistakes came from
importing machinery sized for the source proof's stronger conclusions.

## Two routing principles

1. **Read the source for the step you are formalizing.** Internal consistency of the Lean tree is
   not evidence the route is right. Cite the section in the obligation's docstring.
2. **Then ask whether the source's argument proves more than your statement needs.** Where it
   reaches a conclusion indirectly because it is computing something else along the way, find the
   concrete statement it is a proxy for and target that.

Principle 1 was in force when principle 2 was violated.

**Worked example.** The source proves horizontality with Grothendieck–Lefschetz,
`Pic X = ℤH_x ⊕ ℤH_y`, an intersection count and a restriction sequence. Mathlib has no Picard
group, no invertible sheaves, no dual varieties, no Lattès maps — so this looked research-scale.
But that apparatus exists to exclude one case, *"the image is a curve"*, while the class is being
computed for §5's degree bound. Our proxy: **no nonzero form vanishes on the residual
`Y`-coordinates** — explicit polynomials. Picard theory, invertible sheaves, biduality and Lattès
maps all come off the plan.

**But note the limit of this move, learned the hard way.** Replacing the *machinery* does not
replace the *hypothesis* it consumed. §4's Pic argument ends "contrary to the choice of `L`", so
horizontality genuinely depends on that choice; §5 confirms the two are equivalent. Dropping the
machinery while also dropping the hypothesis produced an obligation that is false for bad lines.
Principle 2 licenses targeting the concrete proxy — it does not license discarding inputs the
source's argument used.

## Invariants

1. **The headline statement never acquires a hypothesis.** Enforced by `MainTheoremGuard.lean`.
2. **`sorry` only — never `axiom`.** A `sorry` is greppable, shows as `sorryAx`, blocks completeness
   claims; an `axiom` is permanent and invisible.
3. **Definitions are built correctly; only theorems may be sorried.** A sorried *definition* makes
   everything downstream about the wrong object.
4. **Never state an obligation you believe might be false.**
5. **Push the sorry down.** The count is not the metric and will rise before it falls.
6. **Every `sorry` lives in an obligation module**, checked by
   `lake build 2>&1 | grep 'declaration uses \`sorry\`'`. Do not grep sources — the docstrings
   discuss it.
7. **Docstring every obligation**: what it says, why it is true, what is missing, which source
   section.

## Architecture

```
Standard/     borrowed mathematics absent from Mathlib. Definitions complete;
              theorems may be sorried; nothing novel; each statement in its natural
              generality so it can leave the project. Currently: GenericSmoothness.

main tree     the tangent-residual argument. Ours, proved outright. Obligations live one
              per module and are consumed by ResidualComponentAssembly → MainTheorem, so
              an obligation cannot gain a hypothesis without breaking the pinned statement.
```

## Current state

`lake build` green, 3067 jobs, Lean/Mathlib `v4.32.1`. **Four** `sorry`s, no `axiom`. WP-4 closed.

**Proved and load-bearing:** Tsen for ternary quadratics over `k[t]`; the universal residual
identity; no whole fibre in either projection; `residualImageXCoords_ne_zero_of_smooth`;
`hasUnirationalParametrization2_residualComponent`;
`isDominant_residualComponentMultisection_baseChangeFst` (properness ⇒ surjectivity ⇒ stable under
base change — **no flatness anywhere**); the multisection principle; the whole of WP-4 (see below);
`not_eq_rename_mul_rename_of_smooth` (source §1(b)).

| Module | Obligation | Nature |
|---|---|---|
| `Standard/GenericSmoothness` | `exists_nonempty_open_smooth_restrict` | borrowed; Hartshorne III.10.7 |
| `ResidualYNonvanishing` | `exists_nonsingular_stereo_cubicFiber_of_smooth` | ours, from the above |
| `ResidualComponentHorizontality` | `isDominant_…_toBase` | ours, concrete |
| `PointedConicRationalFamilies` | `isResidualComponentPointedConicRational_of_smooth` | ours, classical |

---

## WP-1 — Horizontality

Target `IsDominant (residualImagePointOfNormalizedLoc … ≫ residualImageToBase F)`. Everything
downstream is proved: `isDominant_residualComponentToBase_iff` makes it equivalent to component
horizontality, and `isDominant_residualComponentMultisection_baseChangeFst` finishes.

Image is not a point (fibres are 1-dimensional, `T_L` is a surface). Image is not a curve ⟺ no
nonzero form vanishes on the residual `Y`-coordinates ⟺ the two ratios are algebraically
independent in `k(t,s)`.

- **1a.** Factor through the standard chart of `ℙ²_y` at `j`, where `y_j = 1`. Assets:
  `ProjectiveCoordinateNormalization`, `residualImagePointOfNormalizedAlgebra`.
- **1b.** Chart → `ℙ²_y` by `Opens.isDominant_ι` (dense open of an irreducible scheme). Precedent:
  `Unirationality.lean:137`.
- **1c.** Affine part ⟺ injectivity of `k[u₀,u₁] → Away d`, via
  `isDominant_of_of_appTop_injective` (`Morphisms/ClosedImmersion.lean:243`; needs `CompactSpace` —
  source is affine). Transport via `Scheme.ΓSpecIso_naturality`.
- **1d.** Injectivity ⟺ algebraic independence. Char-0 Jacobian criterion reduces it to one explicit
  polynomial nonvanishing; Mathlib lacks the criterion, so build the special case or construct
  preimages.

**Chart density — route improved.** WP-1's second input is
`IsDominant (ProjectiveSpace.standardChartι 2 k j)`, which reduces to
`IrreducibleSpace (ProjectiveSpace 2 k)`. The first scoping proposed covering `ℙⁿ` by irreducible
charts; that needs a topology lemma Mathlib lacks **and** a projective chart cover that does not
exist in the tree (only the biprojective `iSup_standardChartAffineOpen`). **Use the generic point
instead:** `ProjectiveSpectrum` of a graded *domain* carries the point `⊥` — homogeneous, prime
because `MvPolynomial` over a field is a domain, and not containing the irrelevant ideal since
`X_j ≠ 0`. Its closure is `zeroLocus ⊥ = univ`, hence dense, and
`Standard.irreducibleSpace_of_dense_singleton` (**proved**, `Standard/GenericPoint.lean`) gives
irreducibility. `IsOpen.dense` on the chart's range — `Proj.basicOpen 𝒜 X_j` via Mathlib's
`opensRange_awayι` — finishes. What remains is constructing the `⊥` point and transporting
irreducibility from `ProjectiveSpectrum` to the scheme; `HomogeneousIdeal` API, no mathematics.

**Prior art:** `ResidualImageDominance.lean` (deleted `cb34fbf`, recoverable from `404658c`) has
1a–1c; retarget at the component. **Its `ker-bot-map` step is unsound** — needs
`f.ker ≤ (f.ker.map ι).comap ι`, Mathlib gives only the opposite `comap_map_le`. The recorded
timeout was masking that.

---

## WP-2 — Residual `Y` nonvanishing

One obligation, matching source §1. `residualYCoords_ne_zero_of_smooth` follows in one line from the
proved `residualYCoords_ne_zero_of_exists_nonsingular_stereo`.

**Scoped.** The glue is a three-link chain, and every link has tree support:

- **2a.** *Generic smoothness gives a smooth fibre.* `Standard.exists_nonempty_open_smooth_restrict`
  gives `Smooth (ρ ∣_ U)` for a nonempty open `U ⊆ ℙ²_x`. `Smooth` is stable under base change, so
  the fibre over a closed point of `U` is smooth over `k` (`k` algebraically closed, so the residue
  field is `k`). The fibre is identified with a subscheme by
  `zeroLocusFstFiberIsoSubscheme` (`BiprojectiveProjectionFiber.lean:164`) — that file also has
  `fstFiberIsoBaseChange` and the ideal/kernel API.
- **2b.** *Smooth fibre gives Jacobian nonvanishing.* `Hypersurface.exists_pderiv_ne_zero_at_of_smooth`
  (`BiprojectiveAffineJacobian.lean:272`) is exactly this, stated generally: from
  `RingHom.Smooth (algebraMap K (MvPolynomial σ K ⧸ span {f}))` and a zero `a` of `f`, some
  `pderiv i f` is nonzero at `a`. What must be supplied is that the *cubic fibre's* affine chart
  quotient is `RingHom.Smooth` — the projective analogue of
  `affineChartQuotient_smooth_of_global`, which does the same job in the biprojective case and is
  the model to copy.
- **2c.** *The stereo point lands in the good open.* This is the `X`-side of the same
  algebraic-independence question WP-1 faces on the `Y`-side. **Do not scope it separately** —
  settle WP-1's injectivity first and reuse the method.

So WP-2's residue is 2b's smoothness transfer plus 2c, and 2c is downstream of WP-1.

---

## WP-3 — Pointed conics in families

Largest by volume, classical throughout; risk is effort, not truth.

- **3a.** `IsIntegral (residualComponent …)` — scheme-theoretic image of `Spec` of a localisation of
  `MvPolynomial (Fin 2) k`. Needed for `Scheme.functionField`. **Scoped: build it by hand.**
  Mathlib has nothing about images of integral schemes (checked `AlgebraicGeometry/`, and
  `IdealSheaf/Subscheme.lean` carries no `IrreducibleSpace`/`IsIntegral` instance). Split it:
  *irreducible* is topological — the continuous image of an irreducible space is irreducible, and
  `Spec (Away d)` is irreducible because `Away d` is a domain (`IrreducibleSpace (PrimeSpectrum R)`
  for a domain **is** a Mathlib instance); *reduced* comes from the image's structure sheaf being a
  quotient by `Scheme.Hom.ker`, which embeds into functions on a reduced source. Note this needs
  `hdenom ≠ 0` so that `Away d` is nontrivial.
- **3b.** Generic fibre is a nondegenerate plane conic over `K = k(T_L)`.
- **3c.** Tautological section gives a `K`-point (proved).
- **3d.** Pointed conic birational to `ℙ¹`: **use `conicParametrization`** — proved, arbitrary form
  with an isotropic vector, no normal form. Do *not* route through the model conic `X₀X₂ = X₁²`;
  that needs a Witt/hyperbolic completion Mathlib does not have.
- **3e.** Spread out to a `Scheme.PartialIso` over `T_L`.
  `hasUnirationalParametrization1_residualComponentBaseChangeSnd` consumes the result. The API is
  in `Birational/Birational.lean`: `PartialIso` with `IsOver`, `symm`, `trans`, `restrictSource`,
  `restrictTarget`, `toPartialMap` — enough to build and transport the equivalence once 3d gives it
  over the function field.

---

## WP-4 — The unirational tower — **CLOSED**

`hasUnirationalParametrization_succ_of_tower` and its residual-component instance are proved,
axiom-clean, and guarded. Proved along the way and reusable: `mapPartialMap` (transport of a
partial map along `𝔸(n; -)`, absent from Mathlib), `comp_hom_over` (strictly-lying-over is
preserved by `PartialMap.comp`, stated for arbitrary schemes), `exists_isOver_representative`,
`UnirationalParametrization.ofPartialMapOver`, and `nonempty_of_hasUnirationalParametrization`.

The route ran entirely at the **partial map** level, which avoids `Scheme.RationalMap.comp_assoc`
and its irreducibility side conditions — the `IsOver`-class route sketched earlier was not needed.
Two lessons for the remaining packages: generalizing `comp_hom_over` beyond the case at hand made
the proof *shorter* and covered the transport step too; and several goals that `rw`/`simp` refused
were closed by `exact (Category.assoc _ _ _).symm`, because `𝔸(1; 𝔸(m; Spec R)) ↘ Spec R` is the
composite definitionally but not syntactically.

### Superseded notes

Remaining: the `isOver` identity. One friction is gone (`exists_isOver_representative` gives a
strict representative). The other is `Scheme.RationalMap.comp_assoc`'s irreducibility side
conditions on `𝔸(1; 𝔸(m; Spec R))` and `𝔸(1; T)`; `AffineSpace` reduces these to irreducibility of
`Spec R` and `T`, so adding those hypotheses is the expected resolution.

**Route:** strict representatives both sides, transport the base one with `mapPartialMap`, compose
with `Scheme.PartialMap.comp`, read `isOver` off the two strict identities plus
`AffineSpace.map_over`.

**Simpler alternative if WP-5 lands:** source §5 uses *rationality* of `T̃_L` (birational to `S_L`),
giving `T̃_L × ℙ¹` directly, and
`hasResidualBaseChangeUnirationalParametrization3_of_birational` is already in the tree.

---

## WP-5 — The good line

The source **chooses** `L` (§3–4) and normalises to `L = {W = 0}` only afterwards (§5); this
development hardcoded the normalisation across 14 modules without the choice.

| | Condition | Status |
|---|---|---|
| G1 | generic fibre of `ρ` is a smooth plane cubic (§1) | in `Standard/`; feeds WP-2 |
| G2 | `L` not in the conic discriminant (§4.1) | needed; small |
| G3 | `δ_C(L)` nonconstant (§3) | **REQUIRED — the earlier "verified unnecessary" verdict was wrong.** §4 proves horizontality by contradiction ending *"contrary to the choice of `L`"*: the Pic argument **is** the proof and it consumes the choice. §5's "horizontality, equivalently the nonconstancy of `δ_C(L)`" is an equivalence with the *conclusion*, which makes the condition **necessary** — for a fixed `L` with `δ_C(L)` constant, horizontality is false. **Concrete form, no Lattès needed:** for the coordinate line this says the residual-line map `x ↦ [q_U : q_V : q_W]` is nonconstant, i.e. the three degree-ten coefficient forms of `residualEquation F` are not proportional with constant ratios. |
| ~~§4(2),(3)~~ | ~~`C ∩ L` reduced; `[-2]` injective~~ | not needed — they make `S_L ⤏ T_L` birational, which our route does not use |

**Design.** Keep `L = {Y₂ = 0}`; add `IsGoodLine F` bundling what survives; supply it per `F` by a
`PGL₃` change plus invariance (`hasUnirationalParametrization_iff_of_iso` exists; missing piece is
that a `PGL₃` change induces an isomorphism of zero loci).

**G3 is now a Lean predicate.** `ResidualLineNonconstant.lean` defines `residualLineCoeff` (§5's
`q_U, q_V, q_W`, extracted from `residualEquation F` via `secondBlockCoeff`), `ResidualLineConstant`
and `ResidualLineNonconstant`. No `sorry`, and no Lattès map, dual variety or biduality is needed
to *state* the condition — those are needed only to prove a good `L` exists.

**Do not thread it yet.** Adding `ResidualLineNonconstant F` as a hypothesis to obligation 2 simply
moves the false statement up to `MainTheorem`, which would then need it for *arbitrary* smooth `F`.
Threading is only sound once the `PGL₃` half exists, so that the main theorem can *produce* a good
line rather than assume one. Order: build the `PGL₃` action on `F` and the induced isomorphism of
zero loci, then thread `IsGoodLine` down, then discharge obligation 2 under it.

**Warning recorded from a near miss.** The natural convenience lemma *"if `q_a` is not a constant
multiple of `q_b` then the line is nonconstant"* is **false** — constancy with `c b = 0`, `c a ≠ 0`
gives `q_b = 0 ≠ q_a` and no scalar works. The correct criterion is `k`-linear independence of two
of the three forms. Recorded in the module rather than guessed at.

### WP-5 progress

**Landed, all proved and axiom-clean:**

* `ResidualLineNonconstant.lean` — G3 as a checkable predicate (`residualLineCoeff` = §5's
  `q_U, q_V, q_W` via `secondBlockCoeff`; `ResidualLineConstant`; `ResidualLineNonconstant`). No
  Lattès map, dual variety or biduality is needed to *state* the condition.
* `LinearCoordinateChange.lean` — `PGL₃` acting on `ℙⁿ_k`: `linearSubst`, its homogeneity,
  `linearSubstGradedRingHom`, the composition law `linearSubstGradedRingHom_comp` (substituting one
  change into another multiplies the matrices), `linearSubstGradedRingHom_one`,
  `irrelevant_le_map_linearSubst`, `mapLinearSubst`, and **`mapLinearSubstIso`** — an invertible
  matrix gives an automorphism of `ℙⁿ_k`. Built on Mathlib's `Proj.map`, with
  `ProjectiveSpaceCoeffMap.lean` as the structural model.
* `not_eq_rename_mul_rename_of_smooth` — smooth `F` does not factor as `Q(x)·f₀(y)` (source §1(b)).

**Reusable gotcha:** `rw` cannot rewrite under `Proj.map`'s dependent hypothesis argument ("motive
is not type correct"). `LinearCoordinateChange.proj_map_congr` handles it — `subst` the ring-hom
equality, then `rfl` by proof irrelevance. Anything built on `Proj.map` will hit this.

**Next: lift the automorphism to `ℙ²×ℙ²`.** `BiprojectiveSpace m n R` is
`pullback (toSpec m R) (toSpec n R)`, so acting on the second factor alone is `pullback.map` with
the identity on the first — *provided* the automorphism is over `Spec R`, i.e.

```
mapLinearSubst n M N h ≫ ProjectiveSpace.toSpec n k = ProjectiveSpace.toSpec n k
```

That reduces to a **`Proj.map` / `Proj.toSpecZero` compatibility that Mathlib does not have** —
there is no such lemma in `ProjectiveSpectrum/Functor.lean`. It should follow the same pattern
Mathlib uses for `map_comp` and `map_id`: `mapAffineOpenCover … |>.openCover.hom_ext`, reducing to
the away charts, with `Proj.awayι_toSpecZero` (`ProjectiveSpectrum/Basic.lean:206`) as the local
input. No mathematics, but a genuine dig into `Proj` internals.

**Then: carry the zero locus** — the automorphism sends `V(F)` to `V(M·F)`, at the ideal-sheaf
level. This is the substantial remaining step, and the one everything else in WP-5 serves.

**Only then** thread `IsGoodLine` down, so that `MainTheorem` *produces* a good line rather than
assuming one. Threading earlier just relocates a false statement upward.

---

## WP-6 — Non-vacuity

No concrete `F` with a proved `Smooth` instance exists. Neither the axiom check nor the `sorry`
census can detect a vacuous hypothesis.

- **6a.** Converse of `BiprojectiveZeroLocusSmooth`: Jacobian criterion producing `Smooth` from
  chartwise gradient nonvanishing.
- **6b.** Instantiate at a Fermat-type `F` of bidegree `(2,3)`; record the `example`.

---

## WP-7 — Housekeeping

- `HANDOFF.md` is stale (built around `ResidualImageDominance.lean`, deleted; reports four `sorry`s
  that no longer exist). Keep §3, §4, §7; rewrite the rest to point here.
- Retire or `@[deprecated]` the `residualImage` track — `HasResidualImageUnirationalParametrization2`,
  `HasResidualBaseChangeUnirationalParametrization3`, `IsResidualPointedConicRational`,
  `hasResidualBaseChangeUnirationalParametrization3_ofHom`, the `has2` packaging in
  `ResidualYCoordsPureT`. Sound implications, hypotheses false in general.
- Six `probe_*.lean` scratch files tracked at the repo root.
- `Flat` is never proved and the live argument does not need it; the `[Flat π]` variants are dead.

---

## Sequencing

Integration cost is zero — finishing an obligation means deleting a `sorry`.

Start with **WP-2b** and **WP-4's `isOver`**: bounded, routes written out. WP-1 and WP-3 are
independent of those and of each other. WP-6 and WP-7 are independent of everything. Useful width
about four streams; WP-3 is the most divisible.

**Do not point an autonomous loop at anything whose route is not already written in the
obligation's docstring.** The failure mode is not a wrong proof — the guard catches those — it is a
plausible restatement that quietly weakens the claim.

## Missing from Mathlib

| Needed by | Missing | Resolution |
|---|---|---|
| WP-2a | generic smoothness of a morphism, char 0 | stated in `Standard/`; ours to prove |
| WP-1d | Jacobian criterion for algebraic independence, char 0 | build the special case, or construct preimages |
| WP-3d | Witt / hyperbolic decomposition | avoided — use `conicParametrization` |

Previously mis-guessed names: `Scheme.Spec_map_appTop_ΓSpecIso` does not exist (use
`Scheme.ΓSpecIso_naturality`); `Ideal.ker_lift_eq_bot_iff` and
`IsBihomogeneousOfBidegree.eval_smul_right` do not exist; `Hom.ker_comp` gives
`(f ≫ g).ker = f.ker.map g` only, no `⊔` term.

## Dead ends — do not reopen

- The `freeDirPureT` branch analysis of obligation 1 (four sub-obligations, two plausibly false).
  In git history; superseded by WP-2.
- `Disc ∘ stereo ≢ 0` and the freeDir-singularity route (`HANDOFF.md` §4.1). The freeDir form
  nonvanishing itself is green — do not re-derive `specializedConicFreeDirForm_ne_zero_of_smooth`.
- Bulk appends to `SpecializedConicFreeDir.lean` (4208 lines) and `ResidualImageAlgebraPoint.lean`.
  Land in thin modules.
- Raising `maxHeartbeats` to force a proof through. The `ker-bot-map` timeout was masking an unsound
  sketch, not slow elaboration.

## Working rules

Mathlib's [contribution values](https://leanprover-community.github.io/contribute/values.html)
apply. The ones that bite here:

- **"Definitions and theorem statements are what a mathematician would expect."** The `hXT` episode
  type-checked, was `sorry`-free, passed an axiom check, and assumed something false. Check
  `#check` and `#print axioms` together.
- **"Zero `sorry`s is a starting point, not an end point."**
- **Weakest hypotheses.** Standing smell: `residualComponent` is indexed by *proofs* (`hF`, `hv`) as
  well as data, which lengthens every downstream signature.
- **Strongest conclusion** — but general in the direction your statement needs, not the direction
  the source happened to go (routing principle 2).
- **A definition lands with its API.** Thin modules. Name for content, never for status.
- **`maxHeartbeats` is a symptom.**

### Prompt preamble for execution agents

> Lean 4 / Mathlib-style development. For this task:
>
> 1. **Read the source proof for your step** (`certificates/all_smooth_tangent_residual_theorem.md`
>    or `RESOLUTION.md`) before routing. Then ask whether that argument proves *more* than the
>    target needs; if so, target the concrete statement it is a proxy for. Cite the section.
> 2. **State it as a mathematician would**; verify with `#check` and `#print axioms` together.
> 3. **Never state a lemma you believe might be false.** An assumption you cannot justify is a
>    finding to report, not a hypothesis to add.
> 4. **`sorry` only, never `axiom`.** Definitions built correctly; borrowed theorems go in
>    `Standard/`.
> 5. **Push the sorry down**; docstring every `sorry` with what/why/missing/source-section.
> 6. **Weakest hypotheses, strongest conclusion**, subject to (1).
> 7. **A definition lands with its API.** Thin modules, content-based names.
> 8. **`maxHeartbeats` is a symptom** — suspect the mathematics.
> 9. **Report honestly.** Blocked means say so and why; never narrow the task silently.

## Definition of done

1. No obligation module contains a `sorry`, `Standard/` included.
2. `grep -rnE '\b(admit|axiom|native_decide)\b' BConicBundleMultisections/` empty; `lake build`
   reports no `declaration uses \`sorry\``.
3. `#print axioms smooth_bidegree23_hasUnirationalParametrization` →
   `[propext, Classical.choice, Quot.sound]`. Tightening `MainTheoremGuard` from
   `#guard_axioms_standard` to `#guard_no_sorry` *is* the definition of done.
4. Statement unchanged from the top of this file, verified by `#check`.
5. WP-6 has produced one `F` with a proved `Smooth` instance.
6. `lake build` green.

Check 3 and 4 **together**.

## Appendix: corrections log

Three errors, all the same shape — adopting the source's *machinery* instead of asking what our
*statement* requires. Each was caught by an outside question, not by internal checking.

1. **`hXT` was false, not unproved.** It assumed a dim-3 parametrization of the base change of the
   *reducible* `residualImage F`; affine space is irreducible, so no such map exists. The theorem
   was vacuous in exactly the hard cases. Fixed by retargeting to the residual component and pinning
   the statement.
2. **The good line was dropped.** The source chooses `L`; the development kept §5's normalisation
   without §3–4's hypotheses, making two obligations plausibly false. Fixed by WP-5 and by
   withdrawing the branch analysis.
3. **Picard theory was never needed.** Inherited from a route that computes a divisor class for a
   degree bound we do not claim. Removed Picard, invertible sheaves, biduality and Lattès.
4. **But G3 was then wrongly dropped along with them.** Having replaced the Pic *machinery*, I read
   §5's "horizontality, equivalently the nonconstancy of `δ_C(L)`" as showing the *hypothesis* was
   also unneeded, and recorded it "verified unnecessary". It is an equivalence with the conclusion,
   so it makes the condition necessary. Caught by a subagent that was instructed to read the source
   for its step — the instruction working as intended, on the author of the instruction.
