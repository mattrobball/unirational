# Registration snippet — CONE_D36

**Not applied** to NOTEBOOK/manifest by this session (no notebook lock). Paste
when registering.

```json
{
  "entry": "E56",
  "kind": "goal_run",
  "tracked": true,
  "path": "goal_runs_20260812/CONE_D36/",
  "title": "Landing cone at d=36: post-cut 62-cell, P3=1850, dim V <= 32",
  "headline": "Problem E remains OPEN; this packet excludes no degree.",
  "exits": [
    "CONE-D36-CELL62-REPRODUCED",
    "CONE-D36-P3-1850-REPRODUCED",
    "CONE-D36-FREE-M21",
    "CONE-D36-MSOLVE-CLEARED",
    "CONE-D36-NO-DEGREE-EXCLUSION"
  ],
  "machine_markers": ["CONE_D36_VERIFY_OK", "ALLGREEN"],
  "primes": [331, 661],
  "summary": "d=36 window cell rebuilt from D34/LANDING_SWEEP; QR C11-cut post-dim 62 both primes (fatal). P3(36)=1850 on the 63-cell both primes (sealed LANDING_INVARIANT_SIDE); P3=1835 on the 62-cell both primes. Free rungs fill Sym^3 through m=21 both primes (dim V<=41, char-0). Full-span msolve -g 1: m=22,24,28,30 cleared both primes (dim V<=32); m=32 timeout 1200s, no verdict. Tightest bound dim V<=32. No emptiness, no degree excluded.",
  "char0_scope": "Cell dims, cut rank, P3, and free-rung full-span of Sym^3 are modular ranks; a zero kernel / full rank is characteristic-zero (slicelib). msolve leading-ideal zero-dimensionality is Tier-2 modular. Two-prime agreement on anchors, free rungs, and m=22,24. No Nullstellensatz on the 62-cell; no degree exclusion.",
  "depends_on": [
    "goal_runs_20260811/D34_GUIDED_SWEEP",
    "goal_runs_20260812/LANDING_SWEEP",
    "goal_runs_20260812/QR_POINT_CUTS",
    "goal_runs_20260812/LANDING_INVARIANT_SIDE",
    "director_probes_20260812",
    "DATA_SPEC_CONE_SWARM_20260812.md"
  ],
  "honesty_tier": 2,
  "outcome": "BOUND_ONLY",
  "flag": "no degree excluded; Problem E remains OPEN"
}
```

## ODDZERO-format status line

```text
entry: E56
kind: goal_run
tracked: true
path: problems/E-klein-cubic/goal_runs_20260812/CONE_D36/
primary_exit: CONE-D36-MSOLVE-CLEARED
headline: Problem E remains OPEN; this packet excludes no degree.
```
