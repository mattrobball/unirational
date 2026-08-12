# NOTEBOOK registration snippet — `TUPLE_JOINT_RESIDUE`

**Not applied.** Paste by whoever holds the notebook lock. No
`NOTEBOOK.md` / `manifest.json` edit was made by this packet.

---

## 1. Text to append to the E56 Status paragraph

> **Tuple-level joint residue system, 2026-08-12**
> (`goal_runs_20260812/TUPLE_JOINT_RESIDUE`, `TUPLE-JOINT-NO-ZERO`;
> marker `TUPLE_JOINT_RESIDUE_VERIFY_OK` + `ALLGREEN`). First live shot of
> the transport program: join, at **tuple level only**, the corrected σ-band
> (`K = 11068/1178/1512/6216/1344/756`) with cone-order `ord_{ℓ_V} ≥ 6`, the
> sealed depth-table menus, and the two sealed parities. **No class-at-infinity
> zero.** Joint counts (both primes): `J = 11594/1408/2018/10752/1596/1264`.
> Cone cuts nothing (ell_V single pattern survives `max(a)≥6`); depth menus
> extend via period-3 level-2 escapes (largest at `ρ=3`: `+4536`). Trivialized
> join reproduces corrected `K` exactly; H0-1 and `ord_L` parity fall out of
> full-flag modules. STAGE2 pinning excluded. Corollary 3.4 not triggered.
> **No degree is excluded.** Problem E remains OPEN.

## 2. Manifest record

```json
{
 "path": "goal_runs_20260812/TUPLE_JOINT_RESIDUE",
 "entry": "E56",
 "kind": "goal_run",
 "verification_class": "ALGEBRAIC-RECOMPUTE",
 "primary_exit": "TUPLE-JOINT-NO-ZERO",
 "superseded_by": null,
 "char0_scope": "Joint counts are finite exact modular arithmetic at p=331 and p=661 (split primes for PSL(2,11) orders). Pattern positivity is characteristic-free combinatorial content of the Stage-1 constraint graph with stratified/depth-menu tables; it is a relaxation upper bound on landing tuples, not existence. Cone order consumed as sealed tuple-level theorem (CONE_ORDER_AUDIT). No degree exclusion claimed.",
 "tracked": true,
 "notes": "WORKORDER_TUPLE_JOINT_RESIDUE (cycle 5, lane B). Join of corrected sigma-band with cone ord>=6, depth menus, parities — tuple level only. No zero; J>K from depth level-2 escapes; cone free; triv=K anchor; parities fall out. Marker TUPLE_JOINT_RESIDUE_VERIFY_OK + ALLGREEN. Headline OPEN; excludes no degree."
}
```

## 3. Secondary exits

```text
TUPLE-JOINT-ANCHOR-K
TUPLE-JOINT-PARITIES
TUPLE-JOINT-CONE-FREE
TUPLE-JOINT-DEPTH-EXTENDS
TUPLE-JOINT-SATURATION
TUPLE-JOINT-NO-DEGREE-EXCLUSION
```

## 4. ODDZERO-format status line

```text
entry: E56
goal_run: goal_runs_20260812/TUPLE_JOINT_RESIDUE
tracked: true
primary_exit: TUPLE-JOINT-NO-ZERO
zeros: none
transport: Corollary 3.4 not armed
```
