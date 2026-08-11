# Proposed registration for `goal_runs_20260811/GLOBAL_COHERENCE`

**Not applied.** Do not edit `NOTEBOOK.md` or `notebook_build/manifest.json`
from this session. Paste by whoever holds the notebook lock.

---

## 1. Text to append to the E56 Status paragraph

> **Global coherence (shared-μ + incidence join) landed 2026-08-11**
> (`goal_runs_20260811/GLOBAL_COHERENCE`, exits `GLOBAL-COHERENCE-SHARED-MU`,
> `GLOBAL-COHERENCE-F-ODD`, `GLOBAL-COHERENCE-JOIN`; marker
> `GLOBAL_COHERENCE_VERIFY_OK` + `ALLGREEN`, 116 checks). Replaces the
> independent product `K(d mod 6) × D10(μ₁) × 3⁸` by a shared-μ
> enumeration of the 22 immune rows and a global join with the corrected
> σ-band and the D10 branch. Six centre orbits share jet orders; A4 uses
> the sealed second-order residual table (`μ ≥ 2`; C6 excluded at `μ = 3`).
> `F_odd(d mod 330)` = distinct joint value-vectors (union over admissible
> `μ`): min 2 265 760, typical 2 492 336, max 58 798 784,
> **`F_odd(35) = 36 252 160`**. Sharing-off reproduces `3⁸` on the A4 block
> and single-pattern C5/C11/D10 (STAGE2 §4); Thm 4.1 consistency holds.
> Join: `G(d) = K(d mod 6) · H_immune_D10(d)` with D10 branch sum 46 over
> `μ₀ ∈ {1,2,3,4}`; trivialized join reproduces corrected
> `K = (11068, 1178, 1512, 6216, 1344, 756)`. **`G(35 mod 330) =
> 315 176 279 040`**. Incidence bindings immune ↔ σ-band = 0
> (coherence-immune). No residue has `G = 0` or `F_odd = 0`. **Problem E
> remains OPEN; this packet excludes no degree.** Map-level only; no
> transport pairing.

## 2. Manifest record

```json
{
 "path": "goal_runs_20260811/GLOBAL_COHERENCE",
 "entry": "E56",
 "kind": "goal_run",
 "verification_class": "ALGEBRAIC-RECOMPUTE",
 "primary_exit": "GLOBAL-COHERENCE-SHARED-MU",
 "superseded_by": null,
 "char0_scope": "Weight/character layer is exact integer arithmetic (prime-free): master formula w = d a_k + sum mu_l c_l, centre inventory, sharing-off 3^8, D10 branch parity from mu0, free product of coherence-immune rows with the sigma-band. Corrected K table consumed from STAGE1_STRATIFIED (sealed identical at p = 331 and p = 661). F_odd and G are finite Z-counts mod 330. Two-path w(R) crosscheck reused from s2pin (47736 cases, 0 mismatches).",
 "tracked": true,
 "notes": "Executes WORKORDER_GLOBAL_COHERENCE_SHARED_MU. Phase 1: shared-mu enumeration of 22 immune rows over 6 centre orbits with STAGE2_SECOND_ORDER residual constraints; F_odd = product of per-centre distinct value-subvector counts (union over mu). Phase 2: G = K * H_immune_D10 with D10 branch tied to mu0; incidence immune-sigma = 0. G(35) = 315176279040. Marker GLOBAL_COHERENCE_VERIFY_OK + ALLGREEN, 116 checks. No degree excluded."
}
```

## 3. Secondary exits

```text
GLOBAL-COHERENCE-F-ODD
GLOBAL-COHERENCE-JOIN
GLOBAL-COHERENCE-D10-MU-COUPLING
GLOBAL-COHERENCE-INCIDENCE-IMMUNE-FREE
GLOBAL-COHERENCE-NO-DEGREE-EXCLUSION
```
