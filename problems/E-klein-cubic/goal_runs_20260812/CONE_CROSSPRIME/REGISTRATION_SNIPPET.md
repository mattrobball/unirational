# Registration snippet — CONE_CROSSPRIME

**Not applied** to NOTEBOOK/manifest by this session. Paste when registering.
No git operation was performed; nothing outside
`goal_runs_20260812/CONE_CROSSPRIME/` was written.

```json
{
  "entry": "E56",
  "kind": "goal_run",
  "tracked": true,
  "path": "goal_runs_20260812/CONE_CROSSPRIME/",
  "title": "Cross-prime of the director cone-ladder at p=661 (independent sections, full-span m=20)",
  "headline": "Problem E remains OPEN; this packet excludes no degree.",
  "exits": [
    "CONE-CROSSPRIME-CELL-P3-REPRODUCED",
    "CONE-CROSSPRIME-RANKS-AGREE",
    "CONE-CROSSPRIME-FREE-M19",
    "CONE-CROSSPRIME-M20-FULLSPAN",
    "CONE-CROSSPRIME-NO-PRIME-DEPENDENCE",
    "CONE-CROSSPRIME-NO-DEGREE-EXCLUSION"
  ],
  "machine_markers": ["CONE_CROSSPRIME_VERIFY_OK", "ALLGREEN"],
  "primes": [661],
  "summary": "Independent p=661 reproduction of the director p=331 cone-ladder. Sealed cell 37x637, rank U=2, P3=1380. Independently drawn sections: m=6,8,10,18,19 fill Sym^3(L); m=20 and 22 have rank 1380. Full restricted span (1380 gens, never a subset) + msolve -g 1 -t 2 clears m=20 (pure powers of all 20 variables) => dim V<=17 modular. No prime-dependence vs director table. No degree excluded.",
  "char0_scope": "P3 and free-span ranks at p=661 match director p=331 (modular rank; full rank lifts). Zero-dimensionality is a leading-ideal test over F_661 on an F_661-generic section. Bound stated as modular. No characteristic-zero emptiness or degree exclusion claimed.",
  "depends_on": [
    "goal_runs_20260811/D34_GUIDED_SWEEP",
    "goal_runs_20260811/PAIR_ATTACK_D35",
    "director_probes_20260812",
    "DATA_SPEC_CONE_SWARM_20260812.md"
  ],
  "honesty_tier": 2,
  "outcome": "OBSERVATIONS_ONLY",
  "flag": "no degree excluded; Problem E remains OPEN"
}
```

## ODDZERO-format status line

```text
entry: E56
kind: goal_run
tracked: true
path: problems/E-klein-cubic/goal_runs_20260812/CONE_CROSSPRIME/
primary_exit: CONE-CROSSPRIME-NO-PRIME-DEPENDENCE
headline: Problem E remains OPEN; this packet excludes no degree.
```

## Honesty tiering

| tier | content |
|---|---|
| `[T2]` modular, two-prime | cell, P3, section ranks, full-span m=20 leading ideal vs director p=331 |
| not claimed | emptiness of V; any degree exclusion |
