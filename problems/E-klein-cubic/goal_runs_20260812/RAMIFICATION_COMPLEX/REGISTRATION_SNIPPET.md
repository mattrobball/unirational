# NOTEBOOK registration snippet — `RAMIFICATION_COMPLEX`

**Not applied.** Paste by whoever holds the notebook lock. No
`NOTEBOOK.md` / `manifest.json` edit was made by this packet.

---

## 1. Text to append to the E56 Status paragraph

> **Equivariant ramification complex (morphism ledger L8), 2026-08-12**
> (`goal_runs_20260812/RAMIFICATION_COMPLEX`, `RAMCX-JOIN-NO-ZERO`;
> marker `RAMIFICATION_COMPLEX_VERIFY_OK` + `ALLGREEN`). Per-row conormal
> character tables and admissible `(χ ↦ χ′, k)` assignments for all 15
> sweep-capable and 22 coherence-immune census rows, under the tuple-level
> weight rule (Lemma quoting STAGE2 Thm 1.2). Receiver tangent-cone characters
> at coordinate / C5 / C6 / V4 special points (machine at 331, 661; coordinate
> hyperplane `x_{j+1}=0`). Joined onto sealed J census: **cut = 0 all ρ**
> (`J = 11594/1408/2018/10752/1596/1264` unchanged). No class-at-infinity zero;
> ODDZERO gate idle. At `d = 35` the sealed **22** reappear with **0 closed
> character-incompatibility kills**. **No degree is excluded.** Problem E
> remains OPEN.

## 2. Manifest record

```json
{
 "path": "goal_runs_20260812/RAMIFICATION_COMPLEX",
 "entry": "E56",
 "kind": "goal_run",
 "verification_class": "ALGEBRAIC-RECOMPUTE",
 "primary_exit": "RAMCX-JOIN-NO-ZERO",
 "superseded_by": null,
 "char0_scope": "Conormal tables and weight-rule assignments are finite prime-free character arithmetic (Z/n), cross-checked by PATH A/B and by modular F-gradient checks at p=331,661. Join multiplies sealed J by surviving immune-value fractions per residue mod 6; observed cut 0. No degree exclusion claimed. The 22-anchor at d=35 is content-hash presence, not char-0 emptiness.",
 "tracked": true,
 "notes": "WORKORDER_RAMIFICATION_COMPLEX (morphism ledger L8). Tuple-level generalisation of STAGE2 Thm 1.2; per-row (χ→χ',k) tables; receiver TC; join on J free; d=35 22 intact. Marker RAMIFICATION_COMPLEX_VERIFY_OK + ALLGREEN. Headline OPEN; excludes no degree."
}
```

## 3. Secondary exits

```text
RAMCX-CONORMAL-TABLES
RAMCX-WEIGHT-RULE-LEMMA
RAMCX-RECEIVER-TC
RAMCX-JOIN-FREE
RAMCX-D35-ANCHOR-22
RAMCX-NO-DEGREE-EXCLUSION
```

## 4. ODDZERO-format status line

```text
entry: E56
goal_run: goal_runs_20260812/RAMIFICATION_COMPLEX
tracked: true
primary_exit: RAMCX-JOIN-NO-ZERO
zeros: none
transport: Corollary 3.4 not armed
```
