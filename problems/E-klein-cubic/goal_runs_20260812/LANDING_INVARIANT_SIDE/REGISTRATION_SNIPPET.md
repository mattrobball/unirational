# Registration snippet — LANDING_INVARIANT_SIDE

**Not applied** to NOTEBOOK/manifest by this session (no notebook lock). Paste
when registering.

```json
{
  "entry": "E56",
  "kind": "goal_run",
  "tracked": true,
  "path": "goal_runs_20260812/LANDING_INVARIANT_SIDE/",
  "title": "Landing system in invariant coordinates: exact P3(35..38), HF4 bounds, kernel probe",
  "headline": "Problem E remains OPEN; this packet excludes no degree.",
  "exits": [
    "LANDING-INV-P3-CONTROL-D35",
    "LANDING-INV-P3-EXACT-36-38",
    "LANDING-INV-CEILINGS-I3D",
    "LANDING-INV-HF4-BOUNDS-D35",
    "LANDING-INV-KERNEL-PROBE",
    "LANDING-INV-NO-DEGREE-EXCLUSION"
  ],
  "machine_markers": ["LANDING_INV_VERIFY_OK", "ALLGREEN"],
  "primes": [331, 661],
  "summary": "Invariant-side inv_eval_matrix rank of c↦F(T_c) in Inv^{3d}. Control P3(35)=1380 HF3=7759 both primes (D35_LANDING reproduced). Exact saturated P3(36)=1850, P3(37)=2642, P3(38)=3285 (both primes; prior sweep left 36 unsaturated ≥1500). Vs Molien ceilings I(105)=8555, I(108)=9545, I(111)=10614, I(114)=11776: P3/I rises ~0.16→0.28, deficit I−P3 grows slowly 7175→8491; ceiling never attained. HF4 at d=35: domain lb HF4≥40330 exact (37·1380<N4); sketch P4≥6000 two seeds both primes (Tier 2), HF4≤85390; exact P4 not reached. Kernel probe: nested r-planes full rank for r≤15, image saturates at 1380 by r≈25; full M_35 P3≥5400; partial_structural verdict. No degree excluded; Tier-2 modular; not claimed.",
  "char0_scope": "P3 dimensions agree at p=331 and p=661 (modular rank). HF4 domain lower bound 40330 is characteristic-free linear algebra (mult map domain). Sketch P4 lower bounds are modular. Kernel nested ranks are modular. No characteristic-zero Nullstellensatz or degree exclusion claimed.",
  "depends_on": [
    "goal_runs_20260811/D34_GUIDED_SWEEP",
    "goal_runs_20260811/PAIR_ATTACK_D35",
    "goal_runs_20260811/D35_LANDING",
    "goal_runs_20260812/LANDING_SWEEP",
    "director_probes_20260812",
    "WORKORDER_LANDING_INVARIANT_SIDE.md"
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
path: problems/E-klein-cubic/goal_runs_20260812/LANDING_INVARIANT_SIDE/
primary_exit: LANDING-INV-P3-EXACT-36-38
headline: Problem E remains OPEN; this packet excludes no degree.
```
