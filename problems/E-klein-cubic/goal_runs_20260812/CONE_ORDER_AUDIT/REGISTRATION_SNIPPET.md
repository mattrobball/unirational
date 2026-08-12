# NOTEBOOK registration snippet — `CONE_ORDER_AUDIT`

**Not applied.** Paste by whoever holds the notebook lock. No
`NOTEBOOK.md` / `manifest.json` edit was made by this packet.

---

## 1. Text to append to the E56 Status paragraph

> **Cone-order premise audited at general degree, 2026-08-12**
> (`goal_runs_20260812/CONE_ORDER_AUDIT`, `CONE-ORDER-CONFIRMED-AT-GENERAL-DEGREE`;
> marker `CONE_ORDER_AUDIT_VERIFY_OK` + `ALLGREEN`). The unaudited premise
> scoping every window — `ord_{ℓ_V}(T) ≥ 6` along the 55 V4-triple-lines for
> every landing covariant — is **confirmed at general degree**. Sealed origin:
> FIX-N2 Theorem A (no `A₄`-equivariant landing family with plane order `≥ 1`
> and triple-line order `r ∈ {2,3,4,5}`, any line degree), plus H0-1 (`m` odd,
> `m ≥ 1`) and the Note II cone/propagation lemmas. Level: **tuple** (transport
> §5–6). Independent modular filtration at `d = 31..42` (all residues mod 6),
> primes `331` and `661`, with saturation: the `ord ≥ 6` slice reproduces the
> D34 ladder anchors exactly (`0` for `d ≤ 34`; `39,63,121,151,218,261,343,397`
> for `35..42`); exact-order upper bounds for `r = 2..5` inside the linear
> structure space are positive at every degree (non-landing room — structure
> does not encode `F(T)=0`); no landing witness with `r < 6` was found; random
> low-order samples all fail `F` at probe points. The workorder's parenthetical
> "dim(ord≥r)=dim(ord≥6) in structure" is false and is not the premise.
> `r0(d)=6` for all tested degrees. **No degree is excluded.** Problem E
> remains OPEN.

## 2. Manifest record

```json
{
 "path": "goal_runs_20260812/CONE_ORDER_AUDIT",
 "entry": "E56",
 "kind": "goal_run",
 "verification_class": "ALGEBRAIC-RECOMPUTE",
 "primary_exit": "CONE-ORDER-CONFIRMED-AT-GENERAL-DEGREE",
 "superseded_by": null,
 "char0_scope": "Sealed local FIX-N2 Theorem A is characteristic-zero (three engines in the parent packet). The global modular filtration uses rank mod p <= rank over K (slicelib semantics): computed dim 0 at ord>=6 for d<=34 is a char-0 emptiness of that linear slice; nonzero dims (exact-order cells r=2..5, and ord>=6 for d>=35) are upper bounds only. Both primes 331 and 661 agree exactly on every ord>=6 entry in d=31..42. Sampling functionals only enlarges kernels, so emptiness stays valid under saturation.",
 "tracked": true,
 "notes": "Audits the one unaudited premise scoping every window: ord_ell_V(T) >= 6 for every landing covariant. VERDICT CONFIRMED-AT-GENERAL-DEGREE. Provenance: FIX-N2 Theorem A quoted verbatim from CELL_TABLE.md sec.4.1; cone Lemma 2.1 and propagation from theory/FIX_II_jets.md; level classified tuple per EXCLUSION_TRANSPORT sec.5-6. Machine: produce_sweep.py at p=331,661 for d=31..42; D34 anchors reproduced; r0=6 always; linear exact cells r=2..5 positive (non-landing); no landing r<6 witness. Marker CONE_ORDER_AUDIT_VERIFY_OK + ALLGREEN. Headline OPEN; excludes no degree."
}
```

## 3. Secondary exits

```text
CONE-ORDER-SEALED-THEOREM-A-QUOTED
CONE-ORDER-LEVEL-TUPLE
CONE-ORDER-LINEAR-CELLS-R2TO5-NONEMPTY
CONE-ORDER-NO-LANDING-WITNESS-R-LT-6
CONE-ORDER-D34-ANCHORS-REPRODUCED
CONE-ORDER-R0-EQUALS-6-ALL-D
CONE-ORDER-NO-DEGREE-EXCLUSION
```
