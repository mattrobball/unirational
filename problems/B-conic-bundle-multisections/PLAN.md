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

`lake build` green, 3088 jobs, Lean/Mathlib `v4.32.1`. **Ten** `sorry`s, all leaves, no `axiom`.

**WP-6 is closed: the theorem is not vacuous.** `Bidegree23Example.smooth_F` is a concrete smooth
bidegree-(2,3) hypersurface with an axiom-clean `Smooth` instance, pinned in `MainTheoremGuard`.
The obvious Fermat candidate is *singular* — machine-checked — and the witness has to couple every
`x` to every `y` through a Vandermonde matrix.

Also closed: WP-4; chart density (`isDominant_standardChartι`); the arbitrary-line residual
construction; base-point-freeness of the residual line; substitution-invariance of nonsingularity;
the classical mathematics of pointed conics in families; and good-line existence, assembled
(`exists_good_line`, no auxiliary hypotheses).

The count rose from five because obligations were **split and repaired**, which is the intended
direction. Four statements were found false and fixed in one session — see corrections 6–8.

**Proved and load-bearing:** Tsen for ternary quadratics over `k[t]`; the universal residual
identity; no whole fibre in either projection; `residualImageXCoords_ne_zero_of_smooth`;
`hasUnirationalParametrization2_residualComponent`;
`isDominant_residualComponentMultisection_baseChangeFst` (properness ⇒ surjectivity ⇒ stable under
base change — **no flatness anywhere**); the multisection principle; the whole of WP-4 (see below);
`not_eq_rename_mul_rename_of_smooth` (source §1(b)).

| Module | Obligation | Nature |
|---|---|---|
| `Standard/GenericSmoothness` | `exists_nonempty_open_smooth_restrict` | borrowed; Hartshorne III.10.7. One consumer: WP-3 |
| `ResidualYNonvanishing` | `exists_ne_zero_nonsingular_stereo_cubicFiber_of_smooth` | ours. Singular stereo parameters are a proper closed subset of `𝔸²` |
| `ResidualComponentHorizontality` | `eq_zero_of_aeval_residualYCoords_of_isHomogeneous` | **superseded** — coordinate-line, no hypothesis on `L`, unprovable. Retire once call sites thread `L` |
| `ResidualHorizontalityLine` | `eq_zero_of_aeval_residualYCoordsOn_of_isHomogeneous` | ours. General line, G3 explicit. Reduced to one determinant by `AlgebraicIndependenceJacobian` |
| `PointedConicRationalFamilies` | `isPointedConicRationalOver_of_dense_open_smooth` | ours. Spreading out a function-field birational equivalence |

**Closed since the last revision:** `ProjectiveSpace.isDominant_standardChartι` (WP-1's chart
density), sorry-free — see `ProjectiveSpaceChartDominance.lean`.

**Four of the five trace to the good line.** WP-1's obligation needs it; WP-3's needs it (correction
6); WP-2's remaining leaf has it as its second input. Good-line existence is therefore the single
highest-value target, and it reduces to Lemma 2.1 in pencil form plus base-point-freeness of `δ_C`.

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

**Scheme-level transport: parked.** Lifting `mapLinearSubstIso` to `ℙ²×ℙ²` needs
`mapLinearSubst n M N h ≫ ProjectiveSpace.toSpec n k = ProjectiveSpace.toSpec n k`, i.e. a
`Proj.map`/`Proj.toSpecZero` compatibility Mathlib does not have, and then carrying the zero locus
at the ideal-sheaf level. Both are real digs. **Neither is needed** — see below.

### The line is a parameter; the transport is on the cubic, not the scheme

Landed, all proved and axiom-clean:

* `MultisectionLine.lean` — a line as two independent spanning vectors with `t ↦ base + t·dir`, its
  points over any `k`-algebra, and `coordinateLine` as the hardcoded instance.
* `ResidualBaseChangeUnirational` — `line{SpecializedConic, SpecializedConicPoly,
  TernaryQuadraticPoly}` over an arbitrary commutative ring, with `coordinateLine*` identified as
  the `p = (1,0,0)`, `q = (0,1,0)` case. `map_eval_lineSpecializedConicPoly` is *uniform* in the
  second-block index; the coordinate version's three-way `fin_cases` on `1, t, 0` was an artefact.
* `BiprojectiveFiberPolynomial.map_specializeSecondCoordinates` — coefficient change commutes with
  second-block specialization, any `m, n`. Subsumed a `Fin 3`-only copy inside `SpecializedConicFreeDir`.
* `LinearSubstitution.lean` — the polynomial half of `LinearCoordinateChange`, split off so it does
  not drag in `Proj`. `eval_aeval_linearSubst` (substitution is precomposition with the matrix) and
  `binaryLineRestriction_aeval_linearSubst` (restricting the substituted polynomial to a line is
  restricting the original to the image line).
* `PlaneCubicResidualEquivariance.lean` — `binaryLineRestriction_reparam` and
  `residualAmbientRep_reparam`: rescaling the direction `q ↦ α·q + β·p` scales the residual point by
  `α³`, so it is unchanged projectively.

**Where the hardcoding actually lives.** Not in the coordinate arithmetic: a probe making both
hardcoded line definitions opaque to `simp` broke exactly one proof in the tree. It is
`PlaneCubicResidual.residualLinearForm`, built from the `U, V, W` monomial basis — the residual line
`δ_C(L)` for the one line `{W = 0}`. That dependence is carried as `p 0 = 1` / `p 2 = 0` hypotheses
through ~60 sites in `PlaneCubicResidualVanishing` (527 lines) and `PlaneCubicResidualIdentity`
(463 lines), which end in `UniversalResidual.residualLinear_complementary_eq_zero`.

Everything else is already frame-independent: `binaryLineRestriction p q` takes arbitrary vectors,
`complementaryTangentDir G p = cross3 p (tangentGradient G p)`, `residualAmbientRep p q`.

**The transport is done** (`PlaneCubicResidualTransport.lean`, all proved and axiom-clean). The §5
statement now holds for an arbitrary line:

```lean
eval_residualAmbientRep_residualLinearFormOn_linePointOf
    (p₀ q₀ r) (N) (hMN : lineFrame p₀ q₀ r * N = 1)
    (G) (hG : G.IsHomogeneous 3) (t) (hp : eval (linePointOf p₀ q₀ t) G = 0) :
  eval (residualAmbientRep …) (residualLinearFormOn (lineFrame p₀ q₀ r) N G) = 0
```

* `residualLinearFormOn M N G` — `δ_C(L)` for general `L`: carry the cubic into `L`'s frame, take
  the normalised residual line, carry back. Equals the normalised one for the identity frame.
* `lineFrame p q r` — columns the spanning vectors; carries `[1 : t : 0]` to `p + t·q`.
* `frameTangentDir` — **the key definitional choice.** Defining the direction as the *transport of*
  the canonical one, rather than as `p × ∇G(p)`, discharges the span hypothesis outright
  (`α = 1, β = 0`). Cross-product equivariance holds only modulo the span of `p`, so defining it the
  other way would have needed a nondegeneracy hypothesis; this way needs none.
* For `M = lineFrame`, the normalisation hypotheses discharge automatically — in `L`'s own frame the
  point of `L` at parameter `t` *is* `(1, t, 0)`.

None of the ~990 lines of §5 coefficient identities were re-derived; they are used verbatim in the
normalised frame.

**The residual chart chain is general too.** The Tsen/stereo half was threaded in the same pass, so
nothing in the chain below assumes the coordinate line:

| general | coordinate-line original |
|---|---|
| `affineTwoLinePoint` | `affineTwoCoordinateLineY` |
| `lineSpecializedConicPullback` | `specializedConicPullback` |
| `stereoFirstCoordsOn` | `stereoFirstCoords` |
| `eval_cubicFiber_line_of_stereo` | `eval_cubicFiber_coordinateLine_of_stereo` |
| `residualYCoordsOn` | `residualYCoords` |
| `eval_residualYCoordsOn_residualLinearFormOn` | `eval_residualYCoords_residualLinearForm` |

`lineSpecializedConicPullback_eq_map` — the affine-plane conic along `L` is the base change of the
generic conic along `L` — is again `map_specializeSecondCoordinates`, the third place that one
general lemma has paid for itself.

Two facts make the hypotheses come out right rather than accumulating: `mulVec_affineTwoLinePoint`
(in `L`'s own frame the generic point of `L` *is* `(1, t, 0)`, so no normalisation hypothesis
survives the transport) and `frameTangentDir` (the direction is transported, so no span hypothesis
survives either).

**Remaining: the residual image and component.** `residualEquation`, `residualImage` and
`residualComponent` are still built from the coordinate-line chart. The chart-level inputs they
consume now exist in general form, so this is substitution rather than new mathematics.

**Then: good-line existence** (§3, Lemma 2.1 + biduality) — still open, and the one place real
difficulty remains.

**Only then** thread `IsGoodLine` down, so that `MainTheorem` *produces* a good line rather than
assuming one. Threading earlier just relocates a false statement upward.

### WP-5's last step: good-line *existence*

This is the only research-scale item left in the project. Its content reduces further than the
source's packaging suggests.

**The reduction.** A line `L` is *bad* when `x ↦ δ_{C_x}(L)` is constant — `ResidualLineConstant`.
Suppose **every** `k`-rational `L` is bad. Then for each such `L` and all `x, x' ∈ ℙ²_x(k)`,
`δ_{C_x}(L) = δ_{C_{x'}}(L)`. Both are morphisms `(ℙ²_y)^∨ → (ℙ²_y)^∨` and `k` is algebraically
closed, so `(ℙ²_y)^∨(k)` is dense and they agree as morphisms: `δ_{C_x} = δ_{C_{x'}}`. Lemma 2.1
(`δ_C` determines `C`) then gives `C_x = C_{x'}` for all `x, x'` in the dense open where `C_x` is
smooth, so the cubic fibration is constant. §1 turns that into `F(x, y) = Q(x)·f₀(y)` by comparing
one nonzero coefficient — and `not_eq_rename_mul_rename_of_smooth` (**proved**) says a smooth `F` is
not of that form. Contradiction, so some `L` is good.

**What this drops.** The source reaches the same contradiction through §3: it proves `δ_C` is not
defined over `k`, and applies Lemma 3.1 (constant-values descent, via `k`-derivations of `K/k`) to
extract a good `L`. The reduction above replaces Lemma 3.1 by density of `k`-points and works with
honest fibres `C_x` rather than the generic fibre `C_η`. **Lemma 3.1 is then not needed at all.**

Consistent with principle 2 — Lemma 3.1 is doing work for §5's degree bookkeeping over `k`, which we
do not claim. *Verify this against §1 and §3 once more before building on it*: dropping a step the
source uses is exactly the shape of corrections 3 and 4.

**What remains: Lemma 2.1 only.** `δ_C` determines the embedded smooth plane cubic `C`. The source
proves it via: the flex-origin group law with `g = [-2]`; `π : C × C → (ℙ²)^∨` as the `S₃`-quotient;
`μ = [-2] × [-2]` étale with `π ∘ μ = δ_C ∘ π`; the ramification formula, giving that the
critical-value curve of `δ_C` is the dual sextic `C^∨`; then biduality `(C^∨)^∨ = C`.

Mathlib has the elliptic-curve group law but not: the plane-cubic ↔ elliptic-curve dictionary in
usable projective form, dual varieties, biduality, or ramification/branch divisors for a degree-four
map of surfaces. Formalised directly this is research-scale.

**Before attempting it, probe for a cheaper injectivity argument.** What is needed is only that
`C ↦ δ_C` is *injective*, not the identification of the critical-value curve. Worth asking an
expert: *is there a direct argument that `δ_C = δ_{C'}` forces `C = C'` for smooth plane cubics in
characteristic zero, avoiding dual curves and the ramification computation?* If not, Lemma 2.1 is
the project's remaining research content and should be `sorry`ed in `Standard/` with this docstring
while everything else is completed around it.

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

Start with **WP-2b** and **WP-4's `isOver`**: bounded, routes written out. WP-6 and WP-7 are
independent of everything. Useful width about four streams.

**WP-1 and WP-3 are NOT independent**, contrary to what this section said. WP-3's obligation is not
provable from its stated hypotheses: if the image of `T_L` in `ℙ²_y` were a curve inside the
conic-bundle discriminant, the generic fibre over `k(T_L)` would be a line pair or a double line,
and `BirationalOver … (𝔸(1; T_L) ↘ T_L)` would be **false**. Nothing in WP-3's hypotheses excludes
that. It is therefore discharged modulo WP-1's obligation 2, which costs nothing — `MainTheorem`
consumes obligation 2 anyway and obligation 2 has exactly WP-3's hypotheses.

Per source §4 the bad configuration is exactly `δ_C(L) ≡ M` constant, i.e. the bad-line case. So
this is the **good-line gap again**, in a third place.

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

Eight errors. Six are the same shape — adopting the source's *machinery* instead of asking what our
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
5. **WP-3 was recorded as independent of WP-1, and is not.** Its obligation is false for a line
   whose residual line is constant, exactly as obligations 1c/1d were. The plan listed the two work
   packages as parallel streams, so the dependency would have been discovered only on integration.
   Found by an agent that was told to check the source for its own step. This is the good-line
   deviation surfacing for the **third** time, after `hXT` and after 1c/1d — the recurring structural
   fault of this development is not any individual false statement but the habit of adopting §5's
   normalisation while dropping §3's choice.
6. **Obligation B was false, with an explicit counterexample.** It quantified over *every* nonzero
   isotropic Tsen section `v`. For `a₀₁ = 0`, `a₁₁ = y₂·h`, every conic over the coordinate line
   passes through `(0:1:0)`, so `v = (0,1,0)` is isotropic, the polar vanishes, and the stereographic
   map collapses to a point; the cubic fibre is then `A²·y₂·h`, a line union a conic, singular for
   every parameter. Found by an agent told to stop rather than prove a suspect statement — the house
   rule working as intended. Repaired by `StereoNondegenerate` plus
   `exists_isotropic_stereoNondegenerate`: the construction must **choose** its section. This is the
   good-line deviation for the **fourth** time.
7. **Obligation 3's leaf was false: a standing hypothesis was dropped on lifting.** When the
   classical pointed-conic statement was lifted out of its setting it kept *"smooth over a dense open
   of the base"* — which constrains no fibre outside that open — and silently dropped the ambient
   `[Smooth …]` on `X`. Counterexample `F = Y₀³·(X₀X₁ − X₂²)`: on `D(Y₀)` the bundle is a constant
   smooth conic, yet `V(F)` is non-reduced along `Y₀ = 0`, so no `BirationalOver` with anything
   integral exists. Found by the agent auditing **its own** statement from the previous round before
   building on it. Repaired by restoring the ambient hypothesis; the consumer supplies it, so the
   obligation above was unchanged.

   **The distinct lesson.** Corrections 6 and 7 were quantifier faults — the statement said `∀`
   where the construction needed a *chosen* object. This one is a *lifting* fault: a true statement
   became false when moved to a more general setting because an input its original context supplied
   for free was not carried along. Both share a root: **when a statement is restated, re-derive its
   hypotheses from the new context rather than transcribing them.** Smoothness of a morphism over a
   dense open says nothing about the total space, and birationality is about the total space.
8. **The parameterise-by-`L` refactor was scoped in the wrong place.** The scoping pass counted
   `simp` sites unfolding the two hardcoded line definitions — 108 of them in the 4208-line
   `SpecializedConicFreeDir` alone — and predicted a large, fragile migration. A probe replacing both
   definitions by `simp`-opaque equivalents broke **one** proof in the whole tree, and generalising
   that proof shortened it. Counting *syntactic occurrences* measured how often the definitions are
   mentioned, not how much anything depends on their content. The real dependence was in
   `residualLinearForm`'s monomial basis, which the occurrence count never touched, and which was
   found by reading the definitions instead. Corrected before the migration started, so nothing was
   built on the bad estimate.
