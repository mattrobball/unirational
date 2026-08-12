# NOTEBOOK registration snippet — `CONE_PROBE_AUDIT`

**Not applied.** Paste by whoever holds the notebook lock. No
`NOTEBOOK.md` / `manifest.json` edit was made by this packet.

---

## 1. Text to append to the E56 Status paragraph

> **Director landing-cone probes audited, 2026-08-12**
> (`goal_runs_20260812/CONE_PROBE_AUDIT`; marker
> `CONE_PROBE_AUDIT_VERIFY_OK` + `ALLGREEN`). Hostile independent
> recompute (no `slicelib`) of the 2026-08-12 director probes on the
> `d = 35` landing cone. R1 Jacobian rank 5 with Euler
> `J(w)·w = 35 T(w)` **CONFIRMED** at `p = 331, 661`. R2 section ranks
> **CONFIRMED** (`56/120/220/1140/1330` full at `m = 6,8,10,18,19`;
> `1380` at `m = 20,22`; `P3 = 1380`). R3 free argument **CORRECTED**:
> `V ∩ L = {0}` at `m = 18,19` stands, but the upper bound
> `dim V ≤ 37 − m` holds for *any* linear section through the origin
> with that vanishing, not only a generic one; `dim V ≤ 18` stands
> after the fix. R4 `m = 20` leading-ideal criterion **CONFIRMED**
> (director artefact and own full-span `msolve -t 2` at both primes);
> `dim V ≤ 17` stands modularly. R5 semi-regular `dreg = 21/7/5` at
> `m = 55/520/1380` **CONFIRMED**; use the full generator span.
> **No degree is excluded.** Problem E remains OPEN.

## 2. Manifest record

```json
{
 "path": "goal_runs_20260812/CONE_PROBE_AUDIT",
 "entry": "E56",
 "kind": "goal_run",
 "verification_class": "ALGEBRAIC-RECOMPUTE",
 "primary_exit": "CONE-PROBE-AUDIT-R3-CORRECTED",
 "superseded_by": null,
 "char0_scope": "R3 full-rank Macaulay matrices lift from F_p to Q for the integer lift of the tested section. R4 msolve leading ideals are statements over F_p (two primes agree; Groebner bases need not lift). The 37-cell basis is modular. dim V <= 17 is a modular bound, not a sealed char-0 theorem. No degree exclusion.",
 "tracked": true,
 "notes": "Hostile audit of director_probes_20260812 landing-cone probes. Own Reynolds, own chain-rule Jacobian, own cubics; no slicelib. Verdicts: R1 CONFIRMED, R2 CONFIRMED, R3 CORRECTED (genericity not needed for the upper bound), R4 CONFIRMED, R5 CONFIRMED. dim V <= 17 stands modularly. Marker CONE_PROBE_AUDIT_VERIFY_OK + ALLGREEN. Headline OPEN; excludes no degree."
}
```

## 3. Secondary exits

```text
CONE-PROBE-AUDIT-R1-CONFIRMED
CONE-PROBE-AUDIT-R2-CONFIRMED
CONE-PROBE-AUDIT-R4-CONFIRMED
CONE-PROBE-AUDIT-R5-CONFIRMED
CONE-PROBE-AUDIT-DIMV-LE-17-MODULAR
CONE-PROBE-AUDIT-NO-DEGREE-EXCLUSION
```
