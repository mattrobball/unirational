# NOTEBOOK registration snippet — `D35_AUDIT`

Paste into the repository manifest. **No manifest or NOTEBOOK edit was made by
this packet.**

```yaml
- path: problems/E-klein-cubic/goal_runs_20260811/D35_AUDIT/
  entry: E56
  kind: goal_run
  verification_class: independent rebuild (own Reynolds-sum evaluation engine;
    own Weil frame and F_p linear algebra; own V4 children and line samples) at
    three split primes 331, 661, 991 for T1/T2/T5; two primes 331, 661 for T3/T4
    and the content-addressed pattern re-emission. Sealed slicelib.jet_rows is
    NOT used for T1–T3. Layer-0 seeds A,C and nullspaces at 331/661 consumed
    read-only; null at 991 rebuilt.
  primary_exit: D35-AUDIT-T4-DEPTH-PARITY-REFUTED
  superseded_by: null
  char0_scope: |
    Char-0 unconditional: T1 (ord ≥ 2 has rank 39 on the sealed 39-slice at
    three primes — modular full rank); T2 (six flip functionals have ambient
    rank 2 and slice rank 2 at three primes).
    Three-prime finite exact: T5 (flips in span of line-evals; V1 rank 10;
    V1 on 37-cell rank 8).
    Two-prime finite exact: T3 (14 of 18 rid-1 rows forced deeper; row ids
    prime-dependent); T4 REFUTATION (period histogram 36/6/12; six period-3
    kids with lab0 ≠ lab1); linkage repair (content-addressed 756 patterns,
    split 336+398+22, 22 ids match survivors22).
    NOT claimed: any degree exclusion; decision of the 22 survivors; a
    corrected global pattern count at odd residue.
  tracked: true
  notes: |
    Adversarial audit, director-commissioned (WORKORDER_D35_ADVERSARIAL_AUDIT),
    of the five machine facts behind the PAIR_ATTACK_D35 degree-35 collapse
    756 → 22 (THEOREM §§10–12; WORKED_EXAMPLE including the §6 retraction).

    VERDICTS.
      T1 ord≥2 impossibility:     CONFIRMED (331, 661, 991).
      T2 six-flip cut:             CONFIRMED (331, 661, 991).
      T3 14-of-18 vanishing table: CONFIRMED (331, 661; interpretation pinned).
      T4 depth-parity semantics:   REFUTED   (period-3 kids alternate).
      T5 flips ⊂ line-evals:       CONFIRMED (331, 661, 991).
      Linkage repair:              REPAIRED  (3-run content-identical).

    Headline: Problem E remains OPEN; this packet excludes no degree.
    The 336 + 398 closed kills stand; the 22 live cells are untouched by any
    open-condition analysis here. T4's refutation means any future keep-kill
    on the 22 must use the full period table (period 2 and 3), not "only six
    alternate".

    Exits: D35-AUDIT-T1-ORD2-CONFIRMED, D35-AUDIT-T2-SIXFLIP-CONFIRMED,
    D35-AUDIT-T3-VANISHING-CONFIRMED, D35-AUDIT-T4-DEPTH-PARITY-REFUTED,
    D35-AUDIT-T5-FLIP-SPAN-CONFIRMED, D35-AUDIT-LINKAGE-REPAIRED,
    D35-AUDIT-CENSUS-336-398-22-REPRODUCED, D35-AUDIT-NO-DEGREE-EXCLUSION.
    Machine markers: D35_AUDIT_VERIFY_OK, ALLGREEN.
```
