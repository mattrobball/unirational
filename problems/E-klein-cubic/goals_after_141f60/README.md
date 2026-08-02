# Klein cubic — local-worker portfolio after `141f60`

**Pinned state:** `141f6042f628f984771fc79d8d16beb12cedcb94`  
**Headline:** **OPEN**  
**Binding reassessment:** [`REASSESSMENT.md`](REASSESSMENT.md)

This portfolio supersedes the pre-G2 dispatch ranking.  The structural G/G2
mission is complete: every homogeneous landing covariant in every degree is
now equivalent to a rational point on one explicit generic twisted cubic

\[
X_{\rm gen}=V(\Phi)\subset \mathbf P^4_{K_{\rm proj}}.
\]

Accordingly the primary mission is no longer a degree ladder.  It is the exact
arithmetic alternative

\[
X_{\rm gen}(K_{\rm proj})\ne\varnothing
\quad\text{versus}\quad
X_{\rm gen}(K_{\rm proj})=\varnothing.
\]

The V3 theorem also closes the general valuation mechanics.  Any henselian
nonpoint must be unramified, have non-`C1` residue, rational and Krull rank at
most two, and decomposition group `G` or maximal `11:5`.  Thus new negative
workers must decide one of the actual residue cubics; they may not return to
ramification, index, high-rank, or empty-tropicalization arguments.

## Dispatch order

| Priority | Goal | Direction | Decisive target |
|---:|---|---|---|
| 0 | `GOAL_R0_CANONICAL_REFRESH.md` | mechanical | repair the stale live ledger and bridge conventions |
| 1 | `GOAL_G3_UNIVERSAL_CUBIC_ARITHMETIC.md` | positive or negative | decide `V(Phi)(K_proj)` directly |
| 2 | `GOAL_C6_PALATINI_BIG_CELL.md` | positive | a point of the determinantal quartic/common-line model |
| 3 | `GOAL_G4_A5_INDEX11_TRANSFER.md` | positive | convert the induced degree-11 A5 point into a `K_proj`-point |
| 4 | `GOAL_H6_PROJECTIVE_11_ISOGENY.md` | negative or subgroup retirement | decide the genuine `11:5` trace cubic through its degree-11 torus isogeny |
| 5 | `GOAL_G5_FULL_RESIDUE_CUBICS.md` | negative | pointlessness of the full `f5` or `f6` residue twist |
| 6 | `GOAL_Q3_QUARTIC_RESOLVENT_STABLE_MAP.md` | positive | descend a degree-three stable map from the primitive quartic frontier |

Goals G3, C6, G4, H6, and Q3 may run concurrently in isolated directories.
G5 may run concurrently only if it does not duplicate H6.  At most one
unrelated memory-heavy CAS job may run at a time.  Existing T3 normalization
workers retain their own serialized heavy slot.

## Common worker contract

1. Work from the pinned state plus explicitly named post-pinned inputs.  Before
   starting, fetch `main` and record the actual consumed commit; if a named
   task has already returned, consume it rather than repeating it.
2. Run all CAS locally.  Do not create or invoke GitHub Actions or any hosted
   CAS runner.
3. Write only under

   ```text
   problems/E-klein-cubic/goal_runs_after_141f60/<GOAL_LABEL>/
   ```

   except R0, which may prepare replacement text for live ledgers but must not
   rewrite sealed historical packets.
4. Bind every load-bearing input by repository path and SHA-256 hash.
5. Separate producer and independent verifier.  The verifier must reconstruct
   the decisive algebra; reading stored ranks, dimensions, or success booleans
   is not verification.
6. Modular computation is discovery unless accompanied by exact
   reconstruction or a proved good-reduction/specialization implication.
7. A timeout, OOM, killed process, empty output, or solver crash is a
   nonverdict.
8. Every return must state one authorized exit from its goal file, its exact
   theorem boundary, replay commands, and peak memory for heavy jobs.
9. A headline candidate requires an explicit bridge ledger.  The worker stops
   after producing the bridge and independent replay; the director promotes
   the headline.
10. Do not use fixed-frame pointlessness after `B-BRIDGE-REFUTED`.  T3 may
    produce a valuable fixed-frame theorem but not the generic headline.

## New consumption rules after G2 and V3

- `G2-FINITE-GENERATION-PASS` is a completed structural theorem.  Do not ask
  for another universal object, multi-Rees finite-generation theorem, or
  finite first-degree bound.
- A point of `V(Phi)` yields a genuine equivariant rational map.  G3 must audit
  the existing essential-dimension argument showing dominance is automatic,
  or state the precise extra rank check if that argument has a gap.
- Finite degree-25/31/35 exclusions are not evidence for all-degree
  pointlessness.  P25/COV should now be used chiefly for positive witness
  reconstruction unless their already-authorized finite chart work is being
  completed.
- V3 leaves only the full `G` residue cubics at `f5=0`, `f6=0`, and the proper
  decomposition `11:5` trace cubic.  Plane sections, Hessian-kernel lines, and
  support-at-most-five searches are not exhaustive.
- Standard transfer-compatible descent obstructions are closed by Q2.1.
  A new obstruction must be genuinely point-dependent, nonlinear, gerbal, or
  an actual pointless residue cubic.
- The corrected C5 model is the five-alternating-form common-line problem.
  The old self-adjoint idempotent equations containing `e*S_0*e=0` are
  inconsistent and may not be reused.

## Expected output discipline

Each goal should return a compact sealed packet with, at minimum,

```text
INPUT_MANIFEST.json
STATUS.md
THEOREM.md or DECISION.md
produce.py
verify.py
REPLAY.md
SEAL.json
```

Additional exact models, maps, points, valuations, and bridge ledgers are
specified in the individual goals.
