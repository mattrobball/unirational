# Registration snippet — POINT_HUNT

**Not applied** to NOTEBOOK/manifest by this session. Paste when registering.
No git operation was performed; nothing outside
`goal_runs_20260812/POINT_HUNT/` was written.

```json
{
  "entry": "E56",
  "kind": "goal_run",
  "tracked": true,
  "path": "goal_runs_20260812/POINT_HUNT/",
  "title": "Point hunt on the d=35 landing cone (extract + Jacobian dominance)",
  "headline": "Problem E remains OPEN; this packet excludes no degree.",
  "exits": [
    "POINT-HUNT-SELFTEST",
    "POINT-HUNT-CELL-P3-REPRODUCED",
    "POINT-HUNT-JACOBIAN-EULER-CONTROL",
    "POINT-HUNT-FULLSPAN-EXTRACT",
    "POINT-HUNT-DOMINANCE-OR-INFEASIBLE",
    "POINT-HUNT-NO-DEGREE-EXCLUSION"
  ],
  "machine_markers": ["POINT_HUNT_VERIFY_OK", "ALLGREEN"],
  "primes": [331, 661],
  "summary": "Contingency lane if the d=35 landing cone V is nonempty. Full-span restricted cubics (never a subset) on a section L; affine-chart msolve extract of F_p-points of V∩L; independent landing check F(T_c(x))=0; Jacobian rank + fatal Euler J(w)·w=35·T(w). Rank<=3 is not dominant. Sibling bound dim V<=9 makes m=29 the first section that can contain a nonzero point. At m=29 both primes: V∩L={0} (empty charts + complementary zero-dim slices); no point extracted. Extraction became infeasible at m=30 (p=331 chart killed at 8.1 GiB). Modular; no degree excluded.",
  "char0_scope": "P3 and Jacobian Euler/rank are modular. Extracted points are F_p-points of an F_p-section. No characteristic-zero existence or degree exclusion claimed.",
  "depends_on": [
    "goal_runs_20260811/D34_GUIDED_SWEEP",
    "goal_runs_20260811/PAIR_ATTACK_D35",
    "director_probes_20260812",
    "goal_runs_20260812/CONE_LADDER_D35",
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
path: problems/E-klein-cubic/goal_runs_20260812/POINT_HUNT/
primary_exit: POINT-HUNT-DOMINANCE-OR-INFEASIBLE
headline: Problem E remains OPEN; this packet excludes no degree.
zeros: none (degree not excluded)
FLAG: none (no new dim is 0; ODDZERO gate idle)
transport: not armed
```

## Honesty tiering

| tier | content |
|---|---|
| `[T2]` modular | cell, P3, Euler, Jacobian ranks, msolve extracts |
| `[T2]` two-prime when present | extracts run at 331 and 661 |
| not claimed | emptiness of V; any degree exclusion; char-0 landing maps |
