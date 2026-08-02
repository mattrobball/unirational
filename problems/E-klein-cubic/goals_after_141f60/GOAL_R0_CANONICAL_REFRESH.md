# Goal R0 — refresh the canonical live ledger after G2 and V3

**Pinned state:** `141f6042f628f984771fc79d8d16beb12cedcb94`  
**Priority:** 0  
**Class:** mechanical audit  
**Headline direction:** none

## Mission

Repair the current live status map so subsequent workers consume the actual
post-G2/post-V3 state rather than stale dispatch text.  This goal may correct
live ledgers and unresolved merge-conflict artifacts, but it may not edit or
reseal historical proof packets.

## Required corrections to audit

At the pinned state, check rather than blindly assume each item below.

1. `REMAINING_GOALS_NOTE.md` still describes H5 as having no sealed run, while
   `goal_runs_after_bd610a/H5_11_5_TRACE_CUBIC/STATUS.md` records
   `H5-UNDECIDED` and an independent replay.
2. The A0 bulk P25 projection payload records successful counts for all 4,140
   `T_i` tests and 315 commutator tests, while A0's first-line status may still
   say the job is running.
3. `goals_after_bd610a/M3_SARKISOV_SECTION/STATUS.md` has contained unresolved
   merge-conflict markers even though its mathematical exit is unchanged.
4. G/G2 is structurally complete at `G2-FINITE-GENERATION-PASS`; only the
   arithmetic binary on `V(Phi)` remains.
5. V3 mechanics are complete at `V3-RESIDUE-NORMAL-FORM-PASS`; only the full
   `f5`, `f6`, and `11:5` residue point binaries remain.
6. Task B is terminal at `B-BRIDGE-REFUTED` and must not remain in any active
   dispatch list.
7. C5 must point to the corrected alternating-form/Pluecker incidence, not the
   inconsistent idempotent equations.
8. T3's local-worker directory and dependency graph must replace references to
   an undifferentiated scratch task.

If a newer commit has already repaired an item, record its commit and leave it
untouched.

## Work packages

### R0.1 — authoritative packet inventory

Enumerate every live or recently terminal packet under

```text
goal_runs_after_35fa/
goal_runs_after_bd610a/
goals_2026-08-01/
goals_after_5899d0/
```

Read first-line exits, seals, replay markers, and consumed commits.  Deduplicate
by mathematical front and identify superseded status files.  Do not infer an
exit from directory names.

### R0.2 — replay the lightweight decisive verifiers

Replay at least:

```text
G_UNIVERSAL/verify.py
V3_VALUATION_RESIDUE_CLOSEOUT_20260802/verify.py
H5_11_5_TRACE_CUBIC/verify.py
B_FIXED_FRAME_EXHAUSTIVENESS_20260802/verify.py
```

and the completed A0 bulk projection verifier.  If a replay is too expensive,
verify hashes and the smallest independent decisive subcheck, then record the
unreplayed command explicitly.  Never change a mathematical exit solely
because a status file says `PASS`.

### R0.3 — publish one canonical state

Produce a machine-readable and human-readable state with fields

```text
front;
canonical packet;
exact exit;
headline relevance;
remaining binary;
replay command;
superseded packets;
consumed commit.
```

Update only live orientation files whose purpose is current state.  Historical
sealed artifacts remain byte-identical.  Remove merge-conflict markers from
M3 only after choosing the text that preserves its existing mathematical
exit.

### R0.4 — dispatch reconciliation

Replace the old Wave A/Wave B plan with the portfolio in

```text
goals_after_141f60/README.md.
```

Existing heavy P25, COV, and T3 jobs remain available, but the live ranking
must make G3 the primary arithmetic headline target and must not describe G2
or V3 mechanics as open missions.

## Deliverables

Write the audit packet under

```text
problems/E-klein-cubic/goal_runs_after_141f60/R0_CANONICAL_REFRESH/
```

Provide:

```text
INPUT_MANIFEST.json
CANONICAL_STATE.md
canonical_state.json
SUPERSEDED_STATUS.md
REPLAY.md
verify.py
SEAL.json
STATUS.md
```

Prepare exact replacement contents for any parent live ledger edited.  The
independent verifier must compare those tables to the packet inventory and
reject stale active goals.

## Authorized exits

```text
R0-CANONICAL-REFRESH-PASS
R0-REPLAY-FAIL
R0-STATE-CONFLICT
```

No R0 exit is a Problem-E headline.
