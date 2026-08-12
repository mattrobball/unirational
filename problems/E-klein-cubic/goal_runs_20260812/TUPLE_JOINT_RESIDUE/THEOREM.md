# Tuple-level joint residue system: σ-band ⋈ cone(ℓ_V) ⋈ depth menus

**Packet:** `goal_runs_20260812/TUPLE_JOINT_RESIDUE/` · opened 2026-08-12.
**Headline: Problem E remains OPEN; this packet excludes no degree.**

> # VERDICT: **NO CLASS-AT-INFINITY ZERO**
>
> The corrected σ-band, joined at **tuple level** with the cone-order layer
> (`ord_{ℓ_V} ≥ 6`), the sealed depth-table menus, and the two sealed parities,
> remains **strictly positive at every residue mod 6**. The cone layer does not
> cut the order-0 pattern count; depth menus **extend** it (period-3 level-2
> escapes). Trivialized join reproduces the corrected `K` table exactly. No
> degree is excluded; Corollary 3.4 is not triggered.

*(Filename note: the main document is `THEOREM.md`; the harness refuses the
literal name `REPORT.md`.)*

## Exit ledger

```text
TUPLE-JOINT-NO-ZERO
TUPLE-JOINT-ANCHOR-K
TUPLE-JOINT-PARITIES
TUPLE-JOINT-CONE-FREE
TUPLE-JOINT-DEPTH-EXTENDS
TUPLE-JOINT-SATURATION
TUPLE-JOINT-NO-DEGREE-EXCLUSION
```

Machine markers: `TUPLE_JOINT_RESIDUE_VERIFY_OK` / `ALLGREEN`
(`python3 verifier.py` — both primes `p = 331, 661`).

---

## Summary (≤ 25 lines)

1. **Join (tuple-level only):** corrected σ-band (`STAGE1_STRATIFIED`) ⋈ cone
   `ord_{ℓ_V} ≥ 6` (`CONE_ORDER_AUDIT`) ⋈ depth-table assertable levels
   (`DEPTH_TABLE_GENERAL`) ⋈ parities H0-1 / `ord_L ≡ d+1 (mod 2)`. STAGE2
   pinning excluded (map-level).
2. **Per-class joint `J(ρ)`** (both primes identical; `J = total/(23·IMM1)`):

   | `ρ` | sealed `K` | triv (=`K`) | +cone | +depth (=joint) | mechanism |
   |---:|---:|---:|---:|---:|---|
   | 0 | 11 068 | 11 068 | 11 068 | **11 594** | depth +526; cone 0 |
   | 1 | 1 178 | 1 178 | 1 178 | **1 408** | depth +230; cone 0 |
   | 2 | 1 512 | 1 512 | 1 512 | **2 018** | depth +506; cone 0 |
   | 3 | 6 216 | 6 216 | 6 216 | **10 752** | depth +4 536; cone 0 |
   | 4 | 1 344 | 1 344 | 1 344 | **1 596** | depth +252; cone 0 |
   | 5 | 756 | 756 | 756 | **1 264** | depth +508; cone 0 |

3. **No zero.** All six joint counts positive. No FLAG. Corollary 3.4 not armed.
4. **Anchors:** triv join = corrected `K` exactly (both primes). H0-1 (`m` odd on
   rid 1) and `ord_L` parity (`a0` odd on rid 2) fall out of full-flag modules.
5. **Cone / ℓ_V-band:** rid 4 (`ell_V`, slots `[2,2]`, free `ψ`) has a single
   usable child-pattern; it survives the filter `max(a_i) ≥ 6` at every residue
   (Theorem-S′ growth under `+6e_r` checked; up-set of FullSweep mins lifts).
6. **Depth:** filter retains every stratified pattern; period-3 `κ=2` escapes
   add patterns (menus from sealed table). Never a module-level degeneracy cut.
7. **Saturation:** full-flag up-set ok; ell_V `g_r|6` periodicity via `+6e_r`
   pattern stability; both primes.
8. **Not claimed:** no degree exclusion; joint `J` is still a relaxation upper
   bound on realized landing tuples; no transport closure.

---

## 0. Stakes and discipline

`theory/EXCLUSION_TRANSPORT_20260811.md` Corollary 3.4: a **tuple-level**
exclusion of a single residue class mod 6 at all large degrees closes Problem E
(unconditional — quintic invariant). Extraordinary-claims discipline: a zero is
FLAGGED, never claimed, pending an ODDZERO-standard adversarial audit. This
packet produces **no zero**.

Level audit of every layer used (§6 of the transport note):

| layer | level | source |
|---|---|---|
| σ-band / stratified full-flag | tuple-complete | `STAGE1_STRATIFIED` |
| cone `ord_{ℓ_V} ≥ 6` | tuple | `CONE_ORDER_AUDIT` / FIX-N2 Thm A |
| H0-1 / `ord_L` parity | tuple | module vanishing |
| depth-table menus | tuple (arc data of leading germs) | `DEPTH_TABLE_GENERAL` |
| STAGE2 pinning | **map — excluded** | — |

---

## 1. The join

### 1.1 Layers

```
   J(ρ)  =  coherent_count(
                base STAGE1 tables,
                full-flag := depth_menu(stratified contributions at ρ),
                ell_V     := cone-filtered SweepRow patterns
            )  /  (23 · 6⁸·4¹⁰·5⁴)
```

* **L1 stratified full-flag.** `contribution_stratified` on rid 1
  (`D_{P_σ}`, dims `3+2`) and rid 2 (`D_{L⁻_σ}`, dims `2+3`); residue from
  `Σ a_r ≡ ρ (mod 6)`. Yields the corrected `K` when used alone.
* **L2 depth menus.** Sealed assertable levels per class
  `(d mod 6, m mod 6)` / `(d mod 6, ν mod 6)`. Stratified patterns are
  retained iff every pinned value sits on an assertable cycle entry; period-3
  kids with assertable `κ=2` contribute additional escapes.
* **L3 cone on ℓ_V-band.** Census rid 4 = `ell_V` (setwise `V4`, children
  23/24 = `ell_V < P_σ`). Free `ψ` (slots sum to 4 < 5 — Prop 0.1). Filter
  multidegrees by `max(a_i) ≥ 6`. Single usable pattern, residue-blind,
  survives the filter.
* **L4 parities.** Not imposed by hand: every realized full-flag minimal
  multidegree has `a1` odd on rid 1 and `a0` odd on rid 2.

### 1.2 Configurations reported

| name | layers | role |
|---|---|---|
| `triv` | L1 only | anchor = corrected `K` |
| `cone_only` | L1 + L3 | cone cut (observed: 0) |
| `depth_only` | L1 + L2 | depth extension |
| `joint` | L1 + L2 + L3 | full join |

---

## 2. Results

### 2.1 Joint table (both primes identical)

See Summary table. Cross-prime agreement on every entry.

### 2.2 Mechanism attribution

* **Cone (L3):** cut = 0 at every residue. The unique ell_V order-0 pattern is
  already present in STAGE1 tables and remains attainable at
  multidegrees with `max(a_i) ≥ 6`.
* **Depth (L2):** cut ≤ 0 (extension). Level-2 escapes on period-3 children
  raise `J` above `K`, most sharply at `ρ = 3` (`+4536`).
* **Parities (L4):** automatic; no additional cut beyond L1's module support.

### 2.3 Saturation evidence

* Full-flag: realized set is the `+6e_r` up-set of the mins (box 11, both
  primes); `g_r | 6` inherited from Theorem S.
* ell_V SweepRow: 78 usable multidegrees in `maxdeg=12`; 60 meet
  `max(a_i)≥6`; pattern set under the filter equals the unfiltered set;
  `+6e_r` growth check passes (`pattern_growth_Sprime_ok`).
* FullSweep psi=1 shadow on rid 4: 18 mins, all `a1` odd, all admit an
  `r`-lift with `max ≥ 6` inside the up-set (not used in the live count —
  free `ψ` is required).

### 2.4 Anchors

| anchor | status |
|---|---|
| `triv(ρ) = K(ρ)` for all six ρ | **pass**, both primes |
| H0-1: `m = a1` odd on rid 1 | **pass** |
| `ord_L` parity: `a0` odd on rid 2 | **pass** |
| sharing-off / map-level `GLOBAL_COHERENCE` factors | **not in join** (tuple-only) |

---

## 3. If a class had been zero

Not applicable. Protocol (recorded for the next shot): FLAG, never claim;
conditional transport consequence via Corollary 3.4 subject to adversarial
audit; ODDZERO-standard audit as named gate; re-verify tuple-completeness of
every layer (σ-band model, cone order, parities — no map-normalized input).

---

## 4. Honesty tiering

**Tier 1 — sealed, quoted.** Cone order tuple-level (`CONE_ORDER_AUDIT`);
corrected `K` (`STAGE1_STRATIFIED`); depth-table shape and periods
(`DEPTH_TABLE_GENERAL`); Prop 0.1 full-flag dichotomy; transport Corollary 3.4.

**Tier 2 — two-prime finite exact.** Joint table; triv = `K`; ell_V single
pattern under cone; depth superset of stratified; parities from modules;
cross-prime agreement.

**Tier 3 — flagged.** Joint `J` counts coherent *boundary patterns* (a
relaxation); positivity of `J` is not existence of a landing tuple. Level-2
escape enumeration uses the same character-rule engine as stratified; it is
not a re-derivation of the depth table's cycles (those are consumed as sealed
menus).

---

## 5. Not claimed

* No headline. Problem E remains OPEN.
* No degree is excluded; no residue is tuple-empty.
* No claim that `J(ρ)` equals the number of dominant landing maps or tuples.
* No use of STAGE2 odd-order pinning, D10 weight splits, or other map-level
  factors inside the join.
* No transport-pairing claim (no zero to transport).

---

## 6. Replay

```sh
cd goal_runs_20260812/TUPLE_JOINT_RESIDUE
python3 scripts/joint_residue.py 331 661    # ~40 min total
python3 verifier.py
```

Artefacts: `results/joint_p{331,661}.json`, `results/summary.json`,
`results/joint_table.txt`.

## 7. Dependencies

| import | role |
|---|---|
| `STAGE1_STRATIFIED` | corrected `K`, stratified semantics, `s3jet` |
| `STAGE1_TIGHTEN` | `FullSweep`, `classes`, Theorem S |
| `STAGE1_COMPLEX_MAPS` | census, `SweepRow`, `coherent_count` |
| `DEPTH_TABLE_GENERAL` | sealed assertable-level menus |
| `CONE_ORDER_AUDIT` | tuple-level `ord_{ℓ_V} ≥ 6` |
| `theory/EXCLUSION_TRANSPORT_20260811.md` | Corollary 3.4, level audit |

## Director adjudication (2026-08-12, appended before sealing)

1. Replayed clean: `TUPLE_JOINT_RESIDUE_VERIFY_OK` / `ALLGREEN` (68).
2. Run history note: an intermediate `joint_table.txt` (observed mid-run)
   had the depth layer CUTTING; the final, principled semantics — menus
   exactly as the sealed depth table licenses — EXTEND the census
   (period-3 level-2 escapes). The final table is the record.
3. Consequences propagated: (a) the corrected σ-band `K` table is a
   LOWER bound on tuple-level coherent patterns (banner placed on
   `STAGE1_STRATIFIED` §3); the joint `J` table supersedes it as the
   tuple-level census; (b) at the degree-35 class the blueprint base
   grows by 508 (scope banner on `PAIR_ATTACK_D35`); the extended sieve
   is dispatched (`WORKORDER_D35_EXTENDED_BLUEPRINTS.md`).
4. Strategic readout, honest: no class-at-infinity zero, and the
   direction of the correction (counts GROW as semantics complete) says
   order-0 tuple-level systems will not produce one. The transport
   program's next targets are tuple-level REALIZATION layers (the Φ_J
   closure of Stage-2, transport note §8.4, remains the queued upgrade).
