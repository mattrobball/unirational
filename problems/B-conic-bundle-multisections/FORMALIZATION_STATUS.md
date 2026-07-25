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

Build: `lake build` green, 3077 jobs, Lean `v4.32.1` / Mathlib `v4.32.1`. Five `sorry`s across
four modules; no `axiom`, `admit` or `native_decide` anywhere.

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
- **The residual construction for an arbitrary multisection line**
  (`PlaneCubicResidualTransport.lean`). The source chooses the line `L` in §3 and normalises it to
  `{W = 0}` only in §5; the development had only the normalised form, which is what made two
  obligations false-or-suspect. Now proved in general:
  `eval_residualAmbientRep_residualLinearFormOn_linePointOf` — for any line, given its frame, the
  tangent-residual point of a plane cubic at a point of that line lies on the cubic's residual
  line. Established by *transport*, without re-deriving any of the ~990 lines of §5 coefficient
  identities: the plane cubic fibre is carried into the frame where `L = {W = 0}`
  (`binaryLineRestriction_aeval_linearSubst`), the existing identities are applied there, and the
  conclusion is carried back. The ambient biprojective scheme is never transported, so none of the
  parked `Proj.map`/ideal-sheaf machinery is needed. Two supporting facts carry the weight:
  `residualAmbientRep_reparam` (rescaling the direction scales the residual point by `α³`, so it is
  projectively unchanged) and the choice to *define* the general tangent direction as the transport
  of the canonical one (`frameTangentDir`), which avoids cross-product equivariance — that holds
  only modulo the span of the point. `residualLinearFormOn_coordinateLine` checks the general
  construction reduces to the existing one on the coordinate line, so nothing was replaced.

## The remaining obligations

Six `sorry`s in five modules, verified by `lake build 2>&1 | grep 'declaration uses'`. Each is
documented at its site; `PLAN.md` has the work packages and the corrections log.

| Module | Obligation | Nature |
|--------|-----------|--------|
| `Standard/ResidualLineMapInjective` | `exists_pencil_of_hasCommonResidualLineMap` | **borrowed** — Lemma 2.1 in pencil form. Do not attempt |
| `Standard/GenericSmoothness` | `exists_nonempty_open_smooth_restrict` | **borrowed** — Hartshorne III.10.7. Do not attempt |
| `GoodLineExistence` | `exists_ne_zero_isSmoothPlaneCubic_specializeFirstCoordinates` | generic smoothness in coordinates |
| `ResidualHorizontalityLine` | `det_residualYCoordsOn_ne_zero` | **§4** — the last mathematical content of horizontality |
| `ResidualYNonvanishing` | `exists_isotropic_stereoNondegenerate` | §4(1); the good line |
| `ResidualYNonvanishing` | `exists_stereo_param_nonsingularCubicFiber` | §4(1); the good line |
| `PointedConicRationalFamilies` | `isIntegral_pullback_biprojectiveZeroLocusSnd` | two dimension estimates Mathlib lacks |
| `PointedConicRationalFamilies` | `exists_conicChart_openImmersion` | chart bookkeeping; two conditions left of four |
| `ResidualComponentHorizontality` | `eq_zero_of_aeval_residualYCoords_of_isHomogeneous` | **superseded and unprovable** — coordinate line, no hypothesis on `L`. Retire once call sites thread `L` |

**Closed since the last revision:** projective elimination on points
(`CubicFiberSingularLocus.lean`) — the singular cubic fibres form a closed set, unconditionally,
with explicit certificates and **no scheme theory**, where the expected route through relative `Proj`
was blocked by missing Mathlib machinery; the binary quadratic normal form
(`BinaryQuadraticNormalForm.lean`); substitution-invariance of nonsingularity
(`LinearSubstitutionNonsingular.lean`), which discharged `exists_good_line`'s last side hypothesis;
`ProjectiveSpace.isDominant_standardChartι`, together with a general `Proj.irreducibleSpace` for
graded domains that Mathlib lacks; and the whole classical content of obligation 3 —
`PointedConicAffineModel.lean`, 738 lines and zero sorries, proving that a pointed affine conic over
a domain is relatively birational to the affine line, with **no normal form and no Witt
decomposition**. Obligation 3 now rests on one bookkeeping leaf.

**Base-point-freeness of the residual line is proved** (`ResidualLineBasePointFree.lean`, ~900
lines, zero sorries). `ResidualLineConstant` and `ResidualLineConstantOn` say the three coefficient
forms are `C (c a) · g`; both hold **vacuously** at `g = 0`, so every argument concluding something
from "the residual line is constant" was unsound until this landed. Nothing in the tree covered it —
the existing nonvanishing results are all about the residual *point*. Proved with **no
characteristic hypothesis**: algebraic closure alone suffices. Includes a Fermat witness
(`residualLinearForm = linearForm3 0 0 (-27)`), which independently refutes "the residual
coefficients vanish identically". The proof reads the tree's universal residual identity backwards:
each factor of the polar resultant is the tangent line of `G` at a point of `L ∩ C`.

Four results there are Mathlib-shaped and absent upstream: scheme-theoretic images of integral
schemes; `BirationalOver` base-change (`Birational.lean` has `refl/symm/trans` and no transport);
the pointed-conic material itself, stated for an arbitrary `CommRing`; and `dense_basicOpen`.

**Good-line existence is assembled** (`GoodLineExistence.lean`). `exists_good_line` produces a line
whose residual line moves with `x` — the condition four of the obligations traced to. It rests on
two leaves, both known quantities: Lemma 2.1 in **pencil** form, borrowed and documented
(`Standard/ResidualLineMapInjective.lean`), and generic smoothness packaged in coordinates. Proved
outright along the way: the pencil finish (`not_eq_pencil_of_smooth` — a *net* would not close it),
the bridge from condition G3 to the residual line of the fibre, and the `secondBlockCoeff` algebra,
which nothing in the tree had ever unfolded.

**Lemma 3.1 of the source is not needed.** Its job is to descend a morphism from `k(ℙ²_x)` to `k`,
and it is needed only because the source argues with the *generic* fibre. This chain never forms the
generic fibre — it uses honest fibres over closed points, which are already `k`-objects — so nothing
needs descending. Two costs of that route are made explicit rather than hidden: smoothness is needed
for a dense set of closed points, not merely generically, and base-point-freeness becomes an
explicit hypothesis where the source uses it implicitly.

### The one thing to read first

**The `[Smooth …]` hypothesis is satisfiable and the theorem is not vacuous.**
`Bidegree23Example.smooth_F` exhibits a concrete smooth bidegree-(2,3) hypersurface with a proved,
**axiom-clean** `Smooth` instance, pinned in `MainTheoremGuard`. This is the one guard `#print
axioms` on the headline theorem structurally cannot give: a vacuous theorem passes every axiom check
and every `sorry` census. The obvious Fermat candidate is *singular* — machine-checked, not assumed
(`not_smooth_fermatF`) — and the working witness has to couple every `x` to every `y` via a
Vandermonde matrix.

**Four statements in this development were found false during one working session**, each by
counterexample or by explicit degeneration; see `PLAN.md` corrections 6–8 and the docstrings on
`exists_ne_zero_nonsingular_stereo_cubicFiber_of_smooth` and
`eq_zero_of_aeval_residualYCoordsOn_of_isHomogeneous`. Two were quantifier faults, one was a lifting
fault. All are repaired, and the repairs *converged*: obligation B's counterexample and obligation
D's degeneration analysis independently produced the **same** condition — that the polar
`B_Q(v, w)` of the Tsen section against the stereo direction must not vanish
(`StereoNondegenerate`, and its general-line form `lineStereoPolarForm ≠ 0`). Two routes reaching
one hypothesis from opposite directions is the strongest evidence available here that the repairs
are right.

That is the **fourth** appearance of the same fault: adopting §5's normalisation of the line while
dropping §3's choice of it. It has also appeared as `hXT`, as obligations 1c/1d, and as a hidden
dependency of WP-3 on WP-1. **Any statement here that mentions the hardcoded coordinate line and
carries no condition on `L` should be assumed false until checked.** Four of the six remaining
obligations trace to this root, which makes good-line existence the highest-value target.


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
