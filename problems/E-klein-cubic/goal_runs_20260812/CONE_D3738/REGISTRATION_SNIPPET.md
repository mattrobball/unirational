# Registration snippet — CONE_D3738

**Not applied** to NOTEBOOK/manifest by this session. Paste when registering.
No git operation was performed; nothing outside
`goal_runs_20260812/CONE_D3738/` was written.

```json
{
  "entry": "E56",
  "kind": "goal_run",
  "tracked": true,
  "path": "goal_runs_20260812/CONE_D3738/",
  "title": "Landing-cone section ladder at d=37 and d=38 (full-span msolve)",
  "headline": "Problem E remains OPEN; this packet excludes no degree.",
  "exits": [
    "CONE-D3738-CELL-120-150-REPRODUCED",
    "CONE-D3738-P3-2642-3285-REPRODUCED",
    "CONE-D3738-FREE-RUNGS",
    "CONE-D3738-FULLSPAN-MSOLVE",
    "CONE-D3738-TIGHTEST-BOUND",
    "CONE-D3738-NO-DEGREE-EXCLUSION"
  ],
  "machine_markers": ["CONE_D3738_VERIFY_OK", "ALLGREEN"],
  "primes": [331, 661],
  "summary": "Extension of DATA_SPEC_CONE_SWARM_20260812 to the d=37 and d=38 windows. Anchors: post-C11 cells 120 and 150 (QR_POINT_CUTS); P3=2642 on the d=37 post-flip 119-cell and P3=3285 on the d=38 151-cell (LANDING_INVARIANT_SIDE). Free rungs fill Sym^3(L) up to the last m with C(m+2,3) <= P3_cut. Later rungs use the FULL restricted cubic span (never a subset) + msolve -g 1 -t 2. Tightest proven bound is N-m on the post-cut cell. Modular; no degree excluded.",
  "char0_scope": "P3 and free-span ranks that agree at p=331 and 661 are modular ranks (full rank lifts). Zero-dimensionality is a leading-ideal test over F_p on an F_p-generic section. Bound stated as modular. No characteristic-zero emptiness or degree exclusion claimed.",
  "depends_on": [
    "goal_runs_20260811/D34_GUIDED_SWEEP",
    "goal_runs_20260812/LANDING_SWEEP",
    "goal_runs_20260812/QR_POINT_CUTS",
    "goal_runs_20260812/LANDING_INVARIANT_SIDE",
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
path: problems/E-klein-cubic/goal_runs_20260812/CONE_D3738/
primary_exit: CONE-D3738-TIGHTEST-BOUND
headline: Problem E remains OPEN; this packet excludes no degree.
```

## Honesty tiering

| tier | content |
|---|---|
| `[T2]` modular, two-prime | cell dims, P3, free rungs, full-span leading ideals |
| `[T2]` one-prime until 661 lands | any rung cleared only at 331 |
| not claimed | emptiness of V; any degree exclusion |
