# Registration snippet — LANDING_SWEEP

**Not applied** to NOTEBOOK/manifest by this session (no notebook lock). Paste
when registering.

```json
{
  "entry": "E56",
  "kind": "goal_run",
  "tracked": true,
  "path": "goal_runs_20260812/LANDING_SWEEP/",
  "title": "Landing endgame instruments swept across degrees 34-42",
  "headline": "Problem E remains OPEN; this packet excludes no degree.",
  "exits": [
    "LANDING-SWEEP-DEGREE-TABLE",
    "LANDING-SWEEP-D34-CONTROL-ZERO",
    "LANDING-SWEEP-FINISHER-KILL-35-36",
    "LANDING-SWEEP-SIXFLIP-RANK-2-ODD",
    "LANDING-SWEEP-P3-D35-REPRODUCED",
    "LANDING-SWEEP-SECTIONS-ORIGIN-ONLY",
    "LANDING-SWEEP-NO-DEGREE-EXCLUSION"
  ],
  "machine_markers": ["LANDING_SWEEP_VERIFY_OK", "ALLGREEN"],
  "primes": [331, 661],
  "summary": "Degree-general run of the d=35 endgame instruments on the (1,6) Layer-0 cells for d=34..42. Control d=34 reproduces cell_dim=0. Cell dims match the D34 alive-table (39,63,121,151,218,261,343,397). Finisher full-rank kill only at d=35 (ord>=2) and d=36 (ord>=3); residual positive for d>=37. Six-flip rank constantly 2 on every odd d in range (post=cell-2). P3=1380 HF3=7759 at d=35 both primes (D35_LANDING reproduced); larger K deferred. All 10+10 random P1/P2 sections origin-only at every alive degree both primes. Observations only; no degree excluded; Tier-2 modular.",
  "char0_scope": "d=34 cell_dim=0 is a characteristic-zero emptiness verdict (modular rank full => char-0). Nonzero cell dims and finisher/flip ranks are modular upper bounds. d=35 P3 agrees at p=331 and p=661. Section origin-only certificates are modular msolve GBs on reduced subsystems. No char-0 Nullstellensatz for live cells claimed.",
  "depends_on": [
    "goal_runs_20260811/D34_GUIDED_SWEEP",
    "goal_runs_20260811/PAIR_ATTACK_D35",
    "goal_runs_20260811/D35_LANDING",
    "WORKORDER_LANDING_DEGREE_SWEEP.md",
    "WORKORDER_CONE_ORDER_T6_GENERAL.md"
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
path: problems/E-klein-cubic/goal_runs_20260812/LANDING_SWEEP/
primary_exit: LANDING-SWEEP-DEGREE-TABLE
headline: Problem E remains OPEN; this packet excludes no degree.
```
