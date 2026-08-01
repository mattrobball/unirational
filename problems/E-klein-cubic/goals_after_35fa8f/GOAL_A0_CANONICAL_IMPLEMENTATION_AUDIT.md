# Goal A0 — canonicalize and independently audit the August goal packets

**Pinned state:** `35fa8f59b6a1423cc89300aeaceefe91552be5ba`  
**Priority:** 0  
**Headline direction:** none; this is a theorem-boundary and reproducibility gate  
**Required exit:** one canonical state ledger for every dispatched route

## Mission

Turn the concurrent August outputs into one authoritative, replayable state before later workers consume them. Resolve duplicate workspaces, rerun independent verifiers in a clean checkout, repair misleading exit labels, quarantine invalid or stale artifacts, and record exactly which claims may be used as theorems.

This is not a hash-only audit. Every load-bearing mathematical claim must be paired with an independently recomputed certificate of the scope asserted.

## Intake

Audit all 15 goals under

```text
problems/E-klein-cubic/goals_2026-08-01/
```

and every post-dispatch packet through the pinned commit, especially:

```text
certificates/degree25_p25v/
C_PFAFFIAN_FANO*/
COV_STRUCTURED_SEARCH*/
D_EQUIVARIANT_MOTIVE/
F_CONIC_ALGEBRA/
H_SUBGROUP_TWISTS_ROOT_019FBE10/
```

Use `IMPLEMENTATION_AUDIT.md` in this directory as the initial allegation ledger, not as a substitute for replay.

## Tasks

### A0.1 — inventory and requirement matrix

For every original goal, list:

- exact goal-file requirements and authorized exits;
- produced directories and commits;
- first line of every `STATUS.md`;
- producer, independent verifier, seal, and original-equation checks;
- whether the route is unimplemented, partial, completed, refuted, or duplicated.

A missing packet must be recorded as `NOT IMPLEMENTED`, not silently inherited from older work.

### A0.2 — clean replay

From a clean checkout at the pinned commit, replay every claimed producer/verifier pair that is practical under the declared resource floor. For jobs above 8 GiB, verify the saved matrix hashes and build an independent smaller structural certificate, or record that full replay remains required.

Mandatory exact rechecks:

1. **P25:** independently recompute the quartic-level nonmembership conclusion, not merely the 126 cubic remainders. Rebuild the map `S_1 tensor (V_0+W) -> S_4` or an equivalent certificate and confirm the 4,140 and 315 conclusions.
2. **C:** merge the exact lazy multiplication interface, involution, and distinguished five-plane. Identify and quarantine every invalid cyclotomic-conjugate RUR or namespace-mutated artifact.
3. **COV:** reconcile the two packets. Confirm that the theorem is only higher-plane-order emptiness plus named-ansatz emptiness, while every `m=1` degree remains open.
4. **F:** rerun the exact infinity-place, residual-net, normality/class-group, and specialization checks. Distinguish the fixed-frame cubic from the genuine generic twist.
5. **D/H:** replay seals and confirm corrected commit bindings.

### A0.3 — canonical packet selection

Create one canonical directory map. Do not delete historical artifacts, but add `CANONICAL.md` files that state:

- authoritative files and hashes;
- superseded/invalid files and reasons;
- theorem boundary;
- exact unresolved dependency.

Required semantic repair:

```text
COV-STRUCTURED-DEGREES-EMPTY-SCOPED
```

must not be consumed as degree-wide emptiness. Canonicalize it as higher-plane-order branch emptiness or as `COV-NEW-ANSATZ-STRUCTURAL`.

### A0.4 — bridge audit

Recheck every claimed headline bridge. In particular:

- determine whether the original Goal F mission overstated the relation between the fixed-frame cubic and the genuine generic Klein twist;
- keep the auxiliary Morita projector distinct from the genuine Fano section;
- keep finite-degree and finite-ansatz exclusions scoped;
- confirm `BR-SUBGROUP-NEG` for the installed generic subgroup torsors.

### A0.5 — publish canonical state

Produce:

```text
CANONICAL_STATE.md
CANONICAL_STATE.json
ROUTE_REQUIREMENTS.csv
SUPERSEDED_ARTIFACTS.md
VERIFIER_REPLAY.md
SEAL.json
```

`CANONICAL_STATE.md` must give a one-line exact status for every one of the 15 original goals and a dependency graph for the next round.

## Exits

```text
A0-CANONICAL-AUDIT-PASS
A0-AUDIT-FAIL
A0-RESOURCE-BLOCKED
```

`A0-CANONICAL-AUDIT-PASS` requires resolution of the P25 verifier gap and the C/COV duplicate-authority questions. If a claimed theorem fails replay, issue `A0-AUDIT-FAIL` with the smallest counterexample and repair the downstream dependency graph.

## Output contract

Write only under

```text
problems/E-klein-cubic/goal_runs_after_35fa/A0_CANONICAL_AUDIT/
```

Do not rewrite sealed historical packets. New canonical marker files beside them are allowed only when their content and purpose are recorded in the audit seal.