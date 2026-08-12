# Registration snippet — DOMINANCE_D35

**Not applied** to NOTEBOOK/manifest by this session (no notebook lock). Paste
when registering.

## 1. Text to append to the E56 Status paragraph

> **Dominance route at d=35, 2026-08-12**
> (`goal_runs_20260812/DOMINANCE_D35`, `DOM35-I4-REWRITE-NONZERO`;
> marker `DOMINANCE_D35_VERIFY_OK` + `ALLGREEN`). Generic Jacobian rank on
> the 37-cell is 5 (Euler exact) at both primes. The 51060 products that
> span `I4` have only 17905 distinct pivot-leads (`P4 ≥ 17905`). All 25
> four-by-four minors of `J_T` at a generic `x` fail the `I4` lead-span
> rewrite (remainders rank 25); same at p=661 on 5 minors. Collision
> extras (33155) are new. Degree-5 lead-span (`|S5|=178811`) likewise
> misses `c_i Q`. Residual collision-span membership not closed. **No
> degree is excluded.** Problem E remains OPEN.

## 2. Manifest record

```json
{
  "entry": "E56",
  "kind": "goal_run",
  "tracked": true,
  "path": "goal_runs_20260812/DOMINANCE_D35/",
  "title": "Dominance route at d=35: 4x4 Jacobian minors versus I4/I5",
  "headline": "Problem E remains OPEN; this packet excludes no degree.",
  "exits": [
    "DOM35-CELL37-P3-1380",
    "DOM35-JAC-RANK-5-EULER",
    "DOM35-MINOR-SPAN",
    "DOM35-I4-LEAD-SPAN-17905",
    "DOM35-I4-REWRITE-NONZERO",
    "DOM35-I5-LEAD-REWRITE-NONZERO",
    "DOM35-NO-DEGREE-EXCLUSION"
  ],
  "machine_markers": ["DOMINANCE_D35_VERIFY_OK", "ALLGREEN"],
  "primes": [331, 661],
  "summary": "Lane 3 dominance test at d=35. Anchors: cell 37, P3=1380, generic Jac rank 5, Euler exact, both primes. I4 products have |S|=17905 distinct pivot-leads so P4>=17905 (HF4 in [40330,73485]). 25 4x4-minor quartics at one x fail the I4 lead rewrite (0/25 zero, rem rank 25) at p=331; 0/5 at p=661. 12/12 collision extras also have nonzero remainders (P4>17905). I5 lead span |S5|=178811; 4/4 linear*minor quintics miss it. Residual membership in the 33155 collision products not run (~19GB). No dominant-map exclusion. No degree excluded.",
  "char0_scope": "P4>=17905 and HF4>=40330 are characteristic-free (independent lead columns; domain count). Jac rank 5 and rewrite remainders are modular, agreed at two primes on the anchors and on the I4 rewrite. Extra and I5 samples are modular at p=331. Residual collision-span membership open. No char-0 Nullstellensatz. No degree exclusion.",
  "depends_on": [
    "goal_runs_20260811/PAIR_ATTACK_D35",
    "goal_runs_20260811/D35_LANDING",
    "director_probes_20260812",
    "DATA_SPEC_CONE_SWARM_20260812.md"
  ],
  "honesty_tier": 2,
  "outcome": "I4_LEAD_SPAN_OBSTRUCTION",
  "flag": "no degree excluded; Problem E remains OPEN; ODDZERO gate idle"
}
```

## 3. Secondary exits

```text
DOM35-CELL37-P3-1380
DOM35-JAC-RANK-5-EULER
DOM35-MINOR-SPAN
DOM35-I4-LEAD-SPAN-17905
DOM35-I4-REWRITE-NONZERO
DOM35-I5-LEAD-REWRITE-NONZERO
DOM35-NO-DEGREE-EXCLUSION
```

## 4. ODDZERO-format status line

```text
entry: E56
kind: goal_run
tracked: true
path: problems/E-klein-cubic/goal_runs_20260812/DOMINANCE_D35/
primary_exit: DOM35-I4-REWRITE-NONZERO
headline: Problem E remains OPEN; this packet excludes no degree.
zeros: none (degree not excluded)
FLAG: none (ODDZERO gate idle)
transport: not armed
```
