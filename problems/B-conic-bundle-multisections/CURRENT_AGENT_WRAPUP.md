# Stop work now: wrap-up instructions for the active agent

Date issued: 2026-07-25

## Directive

Stop proof development immediately. Do not start a repair, refactor, cleanup pass, literature
search, or new experiment. Your remaining task is only to preserve and explain the current state so
that a fresh agent can resume safely.

The next agent must not have to reconstruct what you changed, which parts compile, which statements
are known false, or what remains unverified. Finish the documentation and minimal checks below,
then yield.

## Safety rules

1. Preserve every existing tracked and untracked change. Treat the dirty working tree as valuable
   work belonging to the user.
2. Do not run `git reset`, `git checkout --`, `git clean`, recursive deletion, or any equivalent
   destructive command.
3. Do not replace a `sorry` with an `axiom`, weaken the headline theorem, or hide an incomplete
   dependency behind a definition.
4. Do not attempt to prove or repair any statement listed below. Record its status exactly.
5. Do not commit, push, open a PR, or stage files unless the user separately gives explicit
   instructions to do so.
6. The Git root is `/Users/worker/unirational`, larger than this problem directory. Do not touch or
   stage the sibling `problems/E-klein-cubic/` tree.
7. Do not claim the formalization complete merely because `lake build` succeeds. The build accepts
   `sorry` and the current tree contains false sorried declarations.

## Required wrap-up actions

Perform these actions in order and do nothing broader.

### 1. Freeze and inventory the working tree

Run:

```bash
cd /Users/worker/unirational/problems/B-conic-bundle-multisections
git status --short --branch
git diff --stat
git diff --name-only
git ls-files --others --exclude-standard
git rev-parse HEAD
```

For every modified or untracked file under `B-conic-bundle-multisections`, write one line explaining:

- what you changed or intended to change;
- whether the file is complete, partial, exploratory, or dead code;
- whether it is imported by the root module;
- whether it compiled in the final build;
- any theorem or API boundary the next agent must know.

Do not give only a filename list. The large files, especially `StereoJacobian.lean`,
`PointedConicRationalFamilies.lean`, and `GoodLineCondition.lean`, need meaningful summaries.

Snapshot seen immediately before this instruction was created:

- branch `main`, tracking `origin/main`;
- HEAD `d0adc218e9116e300c4a6219df70c3995289b612`;
- 14 modified tracked source files, about 5,513 insertions and 460 deletions;
- four untracked source files:
  `ConicDiscriminantAssembly.lean`, `HomogeneousJacobianChart.lean`, `IsotropicCone.lean`, and
  `SndResidueFiberNonzero.lean`;
- `HANDOFF.md` was a stale 2026-07-24 snapshot of a superseded residual-image architecture.

If your final state differs, record the exact difference rather than silently using this snapshot.

### 2. Replace `HANDOFF.md` with the current handoff

The existing `HANDOFF.md` is obsolete. Replace it with a self-contained cold-start document for the
next agent. Git history preserves the old version; do not retain stale claims merely to avoid a
large documentation diff.

The new `HANDOFF.md` must contain all of the following:

1. Current date, branch, HEAD, Git root, problem path, Lean/Mathlib pin, and whether anything was
   committed or pushed.
2. The complete changed/untracked-file inventory from step 1, including the purpose and completion
   status of every file.
3. Exact final build and verification commands with exit status and job count.
4. The exact `sorry` census below, updated if the tree changes during wrap-up.
5. A prominent warning that the current headline proof is invalid because it consumes a false
   declaration. Do not say that the headline mathematical theorem itself has been refuted.
6. The two definite counterexamples below, with exact file/theorem locations.
7. The suspect but not disproved statements below, preserving the confidence distinctions.
8. A short map of which proved infrastructure is reusable and which path is obsolete.
9. A prioritized repair plan for the next agent.
10. Safe re-entry commands and a list of dead ends or fragile files that should not be casually
    reformatted.
11. Any running processes, temporary files, external state, or unavailable evidence. If none,
    state `none` explicitly.

### 3. Run only the minimal final verification

Run these commands from the problem directory:

```bash
lake build
lake build 2>&1 | rg 'declaration uses'
lake env lean /tmp/bconic_residual_constant_probe.lean
git diff --check
git status --short --branch
```

Record exit codes. The last verified full build before this instruction succeeded with 3,106 jobs.
The scratch counterexample verifier also exited successfully and reported:

```text
'BConicBundleMultisections.example_residualLineConstant' depends on axioms:
[propext, Classical.choice, Quot.sound]

'BConicBundleMultisections.false_of_exists_residualChart_of_smooth' depends on axioms:
[propext, sorryAx, Classical.choice, Quot.sound]
```

If the temporary verifier is missing, do not spend time reconstructing it during wrap-up. State
that it was ephemeral and copy the mathematical witness into `HANDOFF.md`. If it is present, record
its path and result, but do not treat a `/tmp` file as durable repository evidence.

Do not run `lake --wfail build` as a completion gate: the tree has many pre-existing linter
warnings. Ordinary `lake build`, the exact `sorry` census, and the counterexample audit are the
relevant checks.

## Non-negotiable mathematical findings

These findings have already been independently audited. Preserve them verbatim in substance.

### A. Definite falsehood: fixed coordinate line declared good

`BConicBundleMultisections/ResidualComponentAssembly.lean:125-149`, theorem
`exists_residualChart_of_smooth`, concludes `ResidualLineNonconstant F` for the hardcoded line
`Y₂ = 0` for every smooth `F`.

This is false. The repository's proved-smooth example
`Bidegree23Example.F` (`Bidegree23Example.lean:67-79`, smooth instance at lines 356-363) has cubic
fibres

```text
A(x) Y₀^3 + D(x) Y₁^3 + K(x) Y₂^3.
```

The universal residual formulas give

```text
q_U = 0,
q_V = 0,
q_W = -27 A^2 D^2 K.
```

Hence the coordinate residual line is constantly `Y₂ = 0`. An axiom-clean Lean proof witnesses
`ResidualLineConstant (Bidegree23Example.F k)`. The current sorried theorem contradicts it.

`MainTheorem.lean:302-307` consumes this false declaration. Therefore the current Lean proof of
`smooth_bidegree23_hasUnirationalParametrization` is invalid. This does not by itself refute the
intended unirationality theorem.

Required future repair: use `GoodLineExistence.exists_good_line` and either transport the entire
residual construction through a `GL₃` change of `y`-coordinates or formulate the residual component
along the arbitrary chosen line. Do not try to prove that the fixed coordinate line is always good.

### B. Definite falsehood: generic smoothness in excessive generality

`BConicBundleMultisections/Standard/GenericSmoothness.lean:161-167`, theorem
`exists_nonempty_open_smooth_restrict`, is false as stated.

Counterexample over an algebraically closed characteristic-zero field `k`:

```text
Y = Spec(k[ε]/(ε²)),
X = Spec(k),
f : X -> Y induced by k[ε]/(ε²) -> k.
```

Then `X` is smooth over `k` and `f` is finite, hence locally of finite type. The only nonempty open
of `Y` is `Y`, but `f` is not flat and therefore not smooth. The declaration also assumes only
`LocallyOfFiniteType f`, although its docstring claims finite type.

The concrete consumers have target `P²` and are plausibly repairable. Replace the false general
theorem with a correctly hypothesized finite-type/integral version or with the exact projective-space
specializations actually needed.

### C. Serious source-fidelity concern: residual horizontality

`ResidualHorizontalityLine.det_residualYCoordsOn_ne_zero` at lines 277-291 is not disproved, but the
cited source proof chooses additional conditions:

- `C ∩ L` is reduced;
- `[-2]` is injective on those three points;
- the relevant vertical surface/generic conic has the integrality and smoothness needed for the
  degree-three argument.

The Lean theorem explicitly omits the first two and supplies no replacement proof for the source's
birationality and degree bookkeeping. The next agent must either prove the stronger statement by a
new argument or strengthen `exists_good_line` and the theorem hypotheses. Do not classify this as
false without a counterexample, and do not classify it as faithful merely because its docstring
says the extra conditions are unnecessary.

### D. Mis-scoped admitted proof: nonsingular cubic fibre

`StereoJacobian.exists_nonsingularCubicFiber_of_smooth` at lines 1783-1810 is plausible, but its
local hole executes

```lean
clear hS hUdense hUsm
sorry
```

while proving that the certificate set contains a nonzero polynomial. Those cleared hypotheses are
the evidence named by the documented argument. Retain them, choose a closed `k`-point of the smooth
open, identify the fibre with the coordinate cubic, and then use the certificate characterization.

### E. Mis-scoped admitted proof: total pullback integrality

`PointedConicRationalFamilies.isIntegral_pullback_biprojectiveZeroLocusSnd` at lines 1396-1411 is
plausible, but clears `hU` and `hsmooth` immediately before its `sorry` although its justification
uses smoothness of the generic conic. A likely clean route is:

1. prove the conic projection is flat as a relative Cartier divisor with no whole fibre;
2. prove the generic fibre is geometrically integral using the supplied smooth open;
3. inject affine coordinate rings into the generic fibre using flatness over a domain.

Do not present the current local hole as the documented dimension argument.

## Exact unproved-declaration census at issuance

The last build reported eight direct declarations using `sorry`, in seven modules:

| File | Declaration | Audit verdict |
|---|---|---|
| `Standard/GenericSmoothness.lean:161` | `exists_nonempty_open_smooth_restrict` | false as stated |
| `Standard/ResidualLineMapInjective.lean:180` | `exists_pencil_of_hasCommonResidualLineMap` | plausible classical lemma |
| `GoodLineExistence.lean:560` | `exists_ne_zero_isSmoothPlaneCubic_specializeFirstCoordinates` | plausible concrete generic smoothness |
| `StereoJacobian.lean:1783` | `exists_nonsingularCubicFiber_of_smooth` | plausible statement, mis-scoped hole |
| `ResidualHorizontalityLine.lean:277` | `det_residualYCoordsOn_ne_zero` | serious source-fidelity concern |
| `PointedConicRationalFamilies.lean:1229` | `isIntegral_genericFiber_pullback_biprojectiveZeroLocusSnd` | plausible scheme/Proj packaging gap |
| `PointedConicRationalFamilies.lean:1396` | `isIntegral_pullback_biprojectiveZeroLocusSnd` | plausible statement, mis-scoped hole |
| `ResidualComponentAssembly.lean:125` | `exists_residualChart_of_smooth` | false; headline dependency |

There were no source `axiom` or `admit` declarations found in the audit. Do not use source-text
`rg sorry` as the census because docstrings discuss `sorry`; use build warnings.

## Lower-severity interface mismatches to record

- `MultisectionPrinciple.IsPointedConicRationalOver` ignores its `_sec` argument and formally means
  only `BirationalOver`. This is not a false theorem, but the name/docstring overstate the interface.
- `PointedConicRationalFamilies.isIntegral_proj_of_nonsingular_ternary` proves only
  `IsDomain (K[X]/(Q))`, not integrality of `Proj`; its own target comment calls it a placeholder.
- `FORMALIZATION_STATUS.md`, `PLAN.md`, and the existing `HANDOFF.md` contain stale and mutually
  inconsistent `sorry` counts and architecture descriptions. The new handoff must state that these
  documents are not authoritative until repaired.

## Prioritized next-agent repair order

Record this order in `HANDOFF.md`; do not execute it now.

1. Re-run the audit on the exact inherited tree and preserve the axiom-clean diagonal counterexample
   as a tracked regression test.
2. Remove or restate the false generic-smoothness declaration, preferably at the concrete `P²`
   consumer level first.
3. Delete the false fixed-coordinate-line conclusion from `exists_residualChart_of_smooth`.
4. Thread the arbitrary good line produced by `exists_good_line` through the Tsen section, residual
   chart, component, and main theorem, or prove a complete coordinate-change transport theorem.
5. Decide whether the residual-horizontality determinant needs the source's reduced-intersection and
   `[-2]`-injectivity hypotheses; strengthen good-line existence if it does.
6. Repair the two mis-scoped holes without clearing their load-bearing hypotheses.
7. Finish the two pointed-conic integrality interfaces using flatness/generic-fibre arguments and
   maximum Mathlib reuse.
8. Only after the statements are sound, work on eliminating the remaining faithful `sorry`s.
9. Update `FORMALIZATION_STATUS.md`, `PLAN.md`, guards, and the final handoff from an exact build
   census. Completion requires the headline theorem's axiom list to omit `sorryAx`.

## Required final message from the departing agent

After updating `HANDOFF.md` and running the minimal checks, respond with only a concise wrap-up that
contains:

- the clickable path to the new `HANDOFF.md`;
- branch and HEAD;
- full-build exit status and job count;
- exact `sorry` count;
- whether `git diff --check` passed;
- whether anything was committed or pushed;
- a statement that the dirty tree was preserved;
- any command that could not be run and why.

Then stop. Do not continue into the repair.
