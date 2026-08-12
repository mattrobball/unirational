# NOTEBOOK registration snippet — `CARRIER_D35`

**Not applied.** Paste by whoever holds the notebook lock. No
`NOTEBOOK.md` / `manifest.json` edit was made by this packet.

---

## 1. Text to append to the E56 Status paragraph

> **Canonical-carrier gateway at d = 35, 2026-08-12**
> (`goal_runs_20260812/CARRIER_D35`, `CARRIER-ANSATZ-LINEARLY-ALIVE`;
> marker `CARRIER_D35_VERIFY_OK` + `ALLGREEN`). The Hessian restriction
> of the sealed 37-cell has value rank **1** at `p = 331` and `661`.
> Character bound `on-curve W̄ = 5` forces kernel dimension in
> **{32,…,36}**. The 22 meet the closed constraints. Landing cone not
> computed. **No degree is excluded.** Problem E remains OPEN.

## 2. Manifest record

```json
{
  "entry": "E56",
  "kind": "goal_run",
  "tracked": true,
  "path": "goal_runs_20260812/CARRIER_D35/",
  "title": "Canonical-carrier gateway at the live d=35 37-cell",
  "headline": "Problem E remains OPEN; this packet excludes no degree.",
  "exits": [
    "CARRIER-D34-RECONSTRUCTED",
    "CARRIER-WINDOW-D35",
    "CARRIER-IC-331-661",
    "CARRIER-SEXTET-FP2",
    "CARRIER-RESTRICTION-RANK-1",
    "CARRIER-KERNEL-INTERVAL-32-36",
    "CARRIER-ANSATZ-LINEARLY-ALIVE",
    "CARRIER-22-MEET-CLOSED",
    "CARRIER-NO-DEGREE-EXCLUSION"
  ],
  "machine_markers": ["CARRIER_D35_VERIFY_OK", "ALLGREEN"],
  "primes": [331, 661],
  "summary": "d=34 GATE/LAND reconstructed (16-3=13, landing empty). d=35 window: on-curve W-bar multiplicity 5, so any carrier kernel on the 37-cell has dim >= 32. I_C dim 1 deg 20 HF(35)=675 both live primes. Hessian sextet not F_p-rational (6 F_p2 points at 331; two cubics at 661). 37-cell vanishes at C11 and at the 331-sextet; extra F_p2-points of C give value rank 1 both primes. Kernel dim over K is in {32..36}. 22 meet closed constraints (keep-pass rank 0 on the 37-cell). Landing cone not computed. No degree excluded.",
  "char0_scope": "On-curve multiplicity 5 is a character-field fact (Atiyah-Bott). Value rank 1 is modular and is a lower bound on rank_K, so the restriction is nonzero over K and the kernel has dim in [32,36] over K. Exact rank in {1,2,3,4,5} not isolated. Landing emptiness is not addressed. No char-0 Nullstellensatz. No degree exclusion.",
  "depends_on": [
    "theory/FIX_VII_carrier.md",
    "goal_runs_after_ac61998/FIX_VII_GATE",
    "goal_runs_after_10804b2/FIX_VII_LAND",
    "goal_runs_20260812/D35_EXTENDED_SIEVE",
    "goal_runs_20260811/PAIR_ATTACK_D35",
    "goal_runs_20260812/DEPTH_TABLE_GENERAL"
  ],
  "honesty_tier": 2,
  "outcome": "CANONICAL_CARRIER_D35_LINEARLY_ALIVE",
  "flag": "no degree excluded; Problem E remains OPEN; ODDZERO gate idle"
}
```

## 3. Secondary exits

```text
CARRIER-D34-RECONSTRUCTED
CARRIER-WINDOW-D35
CARRIER-IC-331-661
CARRIER-SEXTET-FP2
CARRIER-RESTRICTION-RANK-1
CARRIER-KERNEL-INTERVAL-32-36
CARRIER-ANSATZ-LINEARLY-ALIVE
CARRIER-22-MEET-CLOSED
CARRIER-NO-DEGREE-EXCLUSION
```

## 4. ODDZERO-format status line

```text
entry: E56
kind: goal_run
tracked: true
path: problems/E-klein-cubic/goal_runs_20260812/CARRIER_D35/
primary_exit: CARRIER-ANSATZ-LINEARLY-ALIVE
headline: Problem E remains OPEN; this packet excludes no degree.
zeros: none (degree not excluded)
FLAG: none (kernel dim in {32..36}; ODDZERO gate idle)
transport: not armed
```
