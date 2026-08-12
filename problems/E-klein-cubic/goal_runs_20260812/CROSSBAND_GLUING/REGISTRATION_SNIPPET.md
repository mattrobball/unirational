# NOTEBOOK registration snippet — `CROSSBAND_GLUING`

**Not applied.** Paste by whoever holds the notebook lock. No
`NOTEBOOK.md` / `manifest.json` edit was made by this packet.

---

## 1. Text to append to the E56 Status paragraph

> **Cross-band gluing on shared loci, 2026-08-12**
> (`goal_runs_20260812/CROSSBAND_GLUING`, `CROSSBAND-GLUING-D35`;
> marker `CROSSBAND_GLUING_VERIFY_OK` + `ALLGREEN`). Inventories the unique
> positive-dimensional cross-band locus orbit: 55 lines `ℓ_V` (stab A4) as
> `P_σ ∩ P_τ` for commuting involution pairs. Primary gluing of plus-plane
> `(d−1,1)` leading data along each `ℓ_V` has rank 0 on the d=35 universal
> 37-cell and the d=36 63-cell (both primes 331/661, saturation-checked):
> both bands restrict to the zero section (leading form vanishes on `ℓ_V`),
> so they agree automatically. All 22 survivors stay live at dim ≤ 37. Depth-6
> bulk-jet diagnostic recorded, not used as a kill. **No degree is excluded.**
> Problem E remains OPEN.

## 2. Manifest record

```json
{
 "path": "goal_runs_20260812/CROSSBAND_GLUING",
 "entry": "E56",
 "kind": "goal_run",
 "verification_class": "ALGEBRAIC-RECOMPUTE",
 "primary_exit": "CROSSBAND-GLUING-D35",
 "superseded_by": null,
 "char0_scope": "Locus inventory (arrangement) is characteristic-zero geometry verified modularly at two primes. Gluing rank 0 on sealed cells means sampled conditions are dependent on Layer-0 (no new cut); dual-prime and saturation agree. Depth-6 bulk observations are Tier-2 modular diagnostics only. No degree exclusion; 22 remain live at dim<=37. No transport zero.",
 "tracked": true,
 "notes": "WORKORDER_CROSSBAND_GLUING. Inventory L1 ell_V orbit 55 stab A4; primary (d-1,1) gluing rank 0 at d=35 (37-cell) and d=36 (63-cell); 0 deaths among 22; depth-6 diagnostic. Marker CROSSBAND_GLUING_VERIFY_OK + ALLGREEN. Headline OPEN; excludes no degree. Exits CROSSBAND-*."
}
```

## 3. Secondary exits

```text
CROSSBAND-LOCI-INVENTORY
CROSSBAND-GLUING-D36
CROSSBAND-DEPTH6-DIAGNOSTIC
CROSSBAND-NO-DEATHS-22
CROSSBAND-NO-DEGREE-EXCLUSION
```

## 4. ODDZERO-format status line

```text
entry: E56
goal_run: goal_runs_20260812/CROSSBAND_GLUING
tracked: true
primary_exit: CROSSBAND-GLUING-D35
zeros: none (degree not excluded)
FLAG: none (gluing automatic rank 0; 22 live)
transport: Corollary 3.4 not armed
```
