## 2026-08-11 The pair attack opens at d=35: base slice pinned at 39, the multidegree layer kills 336 of 756, 420 m=1 cells live, value layer queued

Packet: `goal_runs_20260811/PAIR_ATTACK_D35/` (worker-built under
`WORKORDER_PAIR_ATTACK_D35.md`, director-adjudicated, section 10).
Problem E remains **OPEN**; no degree is excluded. This is the first
engagement of handoff queue item 4.

What is decided (both primes, cross-checked):

- **Layer 0:** the sealed "ambient dimension <= 39 after the sealed cuts"
  is reproduced as exactly **39**, independently, from the D34-ladder
  citation trail; the workorder's STOP rule did not fire. The A4
  `mu >= 2` input imposes nothing new (already consumed by the ladder).
- **Layer 1 (multidegree):** the 756 corrected sigma-band patterns at
  residue 5 split by the minus-slot multidegree as m=1: 420, m=3: 252,
  m=5: 84. For every `m in {3,5}` pattern the forced order cuts have full
  rank mod both primes, so those slices are EMPTY in characteristic 0 --
  **336 patterns are dead at d=35**.
- **Live:** the 420 `m=1` patterns, all at slice dimension bounded by 39
  (modular upper bounds), with shared Layer-0 basis stored per group.

What is NOT decided, stated plainly (packet sections 3.2 and 10.3): the
value assignments of each pattern `r` -- the load-bearing half of the pair
`(T, r)` -- are DEFERRED. The worker found that imposing them as global
annihilators is unsound and that pointwise child evaluation requires
aligning the STAGE1 sigma-adapted frames with the D34 Weil frame; it
refused to fake the cut (right call) and recorded the assignments
machine-readable for follow-up. Director adjudication corrects the
framing: after alignment these ARE ambient linear cuts, not merely
realization tests, so the next work unit is the frame-alignment derivation
(director-level) followed by the value linearization -- until then 420 is
an upper census under a sieve strictly weaker than the brief. C4/C6 also
defer to that stage; C13 is automatic on the slice.

Verifier: 1754 checks, 0 failures at both primes
(`PAIR_ATTACK_D35_VERIFY_OK` / `ALLGREEN`), director-replayed. The
GLOBAL_COHERENCE input consumed (`vectors_d35.json`) is invariant under
that packet's director correction, so no re-run was needed.

Cycle-2 queue status after this entry: items 1-3 done
(`STAGE1_STRATIFIED`, `GLOBAL_COHERENCE`); item 4 opened with 336/756
cells dead and the value layer as the queued continuation
(frame alignment, value linearization, then C1-C3/C5 realization tests on
whatever survives).

Exits: `PAIR-ATTACK-D35-BASE-SLICE-39`,
`PAIR-ATTACK-D35-MULTIDEGREE-KILL-336`,
`PAIR-ATTACK-D35-420-CELLS-LIVE-UPPER`,
`PAIR-ATTACK-D35-VALUE-LAYER-DEFERRED`,
`PAIR-ATTACK-D35-NO-DEGREE-EXCLUSION`.
