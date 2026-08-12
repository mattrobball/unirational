# Registration snippet — CONE_LADDER_D35

**Not applied** to NOTEBOOK/manifest by this session. Paste when registering.
No git operation was performed; nothing outside
`goal_runs_20260812/CONE_LADDER_D35/` was written.

```json
{
  "entry": "E56",
  "kind": "goal_run",
  "tracked": true,
  "path": "goal_runs_20260812/CONE_LADDER_D35/",
  "title": "Section ladder for the d=35 landing cone (full-span msolve)",
  "headline": "Problem E remains OPEN; this packet excludes no degree.",
  "exits": [
    "CONE-LADDER-D35-CELL-P3-REPRODUCED",
    "CONE-LADDER-D35-FREE-M19",
    "CONE-LADDER-D35-M20-CONTROL",
    "CONE-LADDER-D35-FULLSPAN-MSOLVE",
    "CONE-LADDER-D35-TIGHTEST-BOUND",
    "CONE-LADDER-D35-NO-DEGREE-EXCLUSION"
  ],
  "machine_markers": ["CONE_LADDER_D35_VERIFY_OK", "ALLGREEN"],
  "primes": [331, 661],
  "summary": "Lane 1 of DATA_SPEC_CONE_SWARM_20260812. Landing cone V in the sealed 37-cell. Anchors: cell 37x637, rank U=2, P3=1380 at p=331 and 661. Free rungs m=18,19 fill Sym^3(L) both primes => dim V<=18. Director m=20 control (240 gens) re-parsed zero-dim. Full restricted span (1380 gens, never a subset) + msolve -g 1 -t 4: m=20,22,24,28 zero-dim both primes. Tightest two-prime bound dim V<=9. m=32 no verdict (killed at deg-5 F4 start, 13.6 GB / 15 GB cap). Modular; no degree excluded.",
  "char0_scope": "P3 and free-span ranks agree at p=331 and 661 (modular rank; full rank lifts). Zero-dimensionality is a leading-ideal test over F_p on an F_p-generic section. Bound stated as modular. No characteristic-zero emptiness or degree exclusion claimed.",
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
path: problems/E-klein-cubic/goal_runs_20260812/CONE_LADDER_D35/
primary_exit: CONE-LADDER-D35-TIGHTEST-BOUND
headline: Problem E remains OPEN; this packet excludes no degree.
```

## Honesty tiering

| tier | content |
|---|---|
| `[T2]` modular, two-prime | cell, P3, free rungs, full-span leading ideals |
| `[T2]` one-prime until 661 lands | any higher rung cleared only at 331 |
| not claimed | emptiness of V; any degree exclusion |
