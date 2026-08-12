# Registration snippet — CONE_VS_PATTERN

**Not applied** to NOTEBOOK/manifest by this session. Paste when registering.
No git operation was performed; nothing outside
`goal_runs_20260812/CONE_VS_PATTERN/` was written.

```json
{
  "entry": "E56",
  "kind": "goal_run",
  "tracked": true,
  "path": "goal_runs_20260812/CONE_VS_PATTERN/",
  "title": "Landing cone versus the 22 patterns' open demands at d=35",
  "headline": "Problem E remains OPEN; this packet excludes no degree.",
  "exits": [
    "CONE-VS-PATTERN-EXTRACT-RIGID",
    "CONE-VS-PATTERN-Z37-KILLS",
    "CONE-VS-PATTERN-I3-NO-EXTRA",
    "CONE-VS-PATTERN-RABIN-TAUTOLOGY",
    "CONE-VS-PATTERN-22-DEAD-FLAGGED",
    "CONE-VS-PATTERN-NO-DEGREE-EXCLUSION"
  ],
  "machine_markers": ["CONE_VS_PATTERN_VERIFY_OK", "ALLGREEN"],
  "primes": [331, 661],
  "summary": "First intersection of the d=35 landing cone V with the 22 patterns' OPEN (required-nonzero) readings. Functionals from director frames with rigidity 0 at levels 0..3 both primes. Five distinct forms are the zero form on the 37-cell (Z37): rid-2 T(w) at 4 of 7 assigned line-row children; all rigid deeper jets of the 36 period-1 forced-deeper keeps; period-3 non-mod-0 and lab0-recurrence readings. I3 membership of lam^3 adds no extra vanishing. Rabinowitsch on the cleared m=20 section is tautological (V∩L={0}; same answer for a random linear form). All 22 patterns are unrealizable on the 37-cell, hence on V. That outcome is FLAGGED as a possible d=35 exclusion without emptiness of V; it is not claimed. Problem E remains OPEN.",
  "char0_scope": "Z37 is a statement on the sealed modular 37-cell (full-rank corank-2 cut of the 39-slice). Two-prime agreement on counts and on 22/22 death. No characteristic-zero Nullstellensatz. No degree exclusion claimed.",
  "depends_on": [
    "goal_runs_20260811/PAIR_ATTACK_D35",
    "goal_runs_20260811/D35_AUDIT",
    "goal_runs_20260811/D35_LANDING",
    "goal_runs_20260812/DEPTH_TABLE_GENERAL",
    "goal_runs_20260812/CONE_LADDER_D35"
  ],
  "honesty_tier": 2,
  "outcome": "OBSERVATIONS_ONLY",
  "flag": "22/22 unrealizable on V is FLAGGED, not claimed; no degree excluded; Problem E remains OPEN"
}
```

## ODDZERO-format status line

```text
entry: E56
kind: goal_run
tracked: true
path: problems/E-klein-cubic/goal_runs_20260812/CONE_VS_PATTERN/
primary_exit: CONE-VS-PATTERN-22-DEAD-FLAGGED
headline: Problem E remains OPEN; this packet excludes no degree.
```

## Honesty tiering

| tier | content |
|---|---|
| `[T2]` two-prime | rigidity; Z37 zeros; 22/22 unrealizable on the 37-cell |
| `[T2]` two-prime | I3 of λ^3; Rabinowitsch tautology |
| not claimed | emptiness of V; any degree exclusion |
| `[FLAG]` | all 22 miss V (would exclude d=35 without V={0}) |
