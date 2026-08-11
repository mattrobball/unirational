# Registration snippet — PAIR_ATTACK_D35

```json
{
  "entry": "E56",
  "kind": "goal_run",
  "tracked": true,
  "path": "goal_runs_20260811/PAIR_ATTACK_D35/",
  "title": "Pair attack at d=35: r-side hierarchical compiler over 756 sigma-band patterns",
  "headline": "Problem E remains OPEN; this packet excludes no degree.",
  "exits": [
    "PAIR-ATTACK-D35-LAYER0-REPRODUCED",
    "PAIR-ATTACK-D35-PATTERNS-756",
    "PAIR-ATTACK-D35-HIERARCHICAL-COMPILER",
    "PAIR-ATTACK-D35-SURVIVORS-OR-ALLDEAD-FLAG",
    "PAIR-ATTACK-D35-NO-DEGREE-EXCLUSION"
  ],
  "machine_markers": ["PAIR_ATTACK_D35_VERIFY_OK", "ALLGREEN"],
  "primes": [331, 661],
  "summary": "Map-level pair attack (T,r) at d_min=35. Layer 0 reproduces sealed ambient dim 39 (D34 structure+(1,6) + A4 mu>=2). Regenerates K(5)=756 sigma-band patterns. Hierarchical prune: m in {3,5} kills 336 patterns (ord_P>=m empties the slice); m=1 keeps 420 survivors at dim<=39. Value linearization deferred (frame alignment). GLOBAL_COHERENCE vectors_d35 consumed (F_odd=36252160). RT T-side 27 cells cite-only. No degree excluded.",
  "char0_scope": "dim M_35=637 exact Molien. Layer-0 dim 39 is a modular upper bound matching the sealed D34 ladder at both primes; emptiness of ord_P>=3 and ord_P>=5 on that slice is modular rank=full hence characteristic-zero (slicelib semantics). Survivor dims are upper bounds only. No degree exclusion claimed.",
  "depends_on": [
    "goal_runs_20260811/D34_GUIDED_SWEEP",
    "goal_runs_20260811/STAGE1_STRATIFIED",
    "goal_runs_20260810/STAGE2_ODD_ORDER_PINNING",
    "goal_runs_20260811/STAGE2_SECOND_ORDER",
    "goal_runs_20260811/GLOBAL_COHERENCE",
    "goal_runs_20260811/RT_ACTUAL_LANDING/D35_BRANCH_TABLE.md",
    "theory/CONSTRAINT_ADDITIONS_20260811.md"
  ]
}
```
