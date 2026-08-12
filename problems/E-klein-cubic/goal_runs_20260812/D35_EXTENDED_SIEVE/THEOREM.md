# Sieving the 508 extended blueprints at d = 35

**Packet:** `goal_runs_20260812/D35_EXTENDED_SIEVE/` · opened 2026-08-12.
**Headline: Problem E remains OPEN; this packet excludes no degree.**

> # VERDICT: **22 LIVE AT dim ≤ 37; THE 508 ARE ALL DEAD (FLAGGED)**
>
> Joint residue J(5) = 1264 = 756 stratified + 508 period-3 level-2 extensions.
> Sealed kill layers (multidegree, line-order finisher, universal six flips)
> plus the arc-jet ladder at the 12 period-3 children (κ = 3,4,5 and 8) leave
> exactly the sealed **22** survivors, unchanged, at dim ≤ 37. The 508 are
> all dead under closed conditions — **FLAGGED**, never claimed as a degree
> exclusion (the 22 remain; ODDZERO-standard audit is the promotion gate).

*(Filename note: the main document is `THEOREM.md`; the harness refuses the
literal name `REPORT.md`.)*

## Exit ledger

```text
D35-EXT-SIEVE-MATERIALIZED-508
D35-EXT-SIEVE-MULTIDEGREE
D35-EXT-SIEVE-LINE-ORDER
D35-EXT-SIEVE-SIX-FLIPS
D35-EXT-SIEVE-ARC-JET-LADDER
D35-EXT-SIEVE-CENSUS-1264
D35-EXT-SIEVE-ANCHOR-22
D35-EXT-SIEVE-508-ALL-DEAD-FLAGGED
D35-EXT-SIEVE-NO-DEGREE-EXCLUSION
```

Machine markers: `D35_EXTENDED_SIEVE_VERIFY_OK` / `ALLGREEN`
(`python3 verifier.py` — both primes `p = 331, 661`).

---

## Summary (≤ 25 lines)

1. **Materialized 508** content-addressed blueprints (assignments + level
   assertions) as the joint-minus-stratified core at residue 5: J(5)=1264,
   K=756 overlap, ext=508. Both primes; 22 sealed sol-hashes present.
2. **Per-layer deaths over the 508** (identical both primes):

   | layer | deaths | mechanism |
   |---|---:|---|
   | multidegree `m ∈ {3,5}` | **298** | sealed empty slices |
   | line-order `ν ≥ 2` | **148** | finisher rank 39 on 39-slice |
   | arc-jet ladder (period-3) | **62** | κ≡1/κ≡2 keeps, all admissible levels vanish on 37-cell |
   | **live among 508** | **0** | — |

3. **Final census 1264:** dead 634 (multi) + 546 (line) + 62 (arc-jet) +
   **live 22** at dim ≤ 37. Formula checks: 634+546+62+22 = 1264.
4. **22-anchor:** sealed ids/hashes reappear unchanged among stratified live
   after multidegree+line-order+six-flips; DEPTH keep-pass (0 closed deaths)
   stands. Cross-prime agree.
5. **FLAG:** 508 all-dead is modular finite-exact, **not** a degree exclusion.
   Problem E remains OPEN; this packet excludes no degree.

---

## 0. Inputs consumed (read-only)

| source | use |
|---|---|
| `TUPLE_JOINT_RESIDUE` | J(5)=1264; ρ=5 depth menus extend K by 508 |
| `PAIR_ATTACK_D35` §§10–12, `WORKED_EXAMPLE` §7 | sealed layers; 336+398+22; scope of 508 |
| `DEPTH_TABLE_GENERAL` | period menus; level-1/2 free on 37-cell at p3 rows |
| `D35_AUDIT` | content-addressed blueprint format; T1/T2 ranks |
| Layer-0 seeds `layer0_{A,C,null}_p*` | 39-slice |

---

## 1. Materialize (task 1)

`scripts/materialize_508.py` rebuilds residue-5 full-flag tables via
`contribution_depth_menu` (stratified + period-3 κ=2 escapes), enumerates the
51-row core (1264 solutions), content-hashes each pattern with embedded
assignment dicts and per-row `level_assertions` (match levels on the depth
cycle). Difference against sealed `patterns_r5` sol-hashes isolates the 508.

| quantity | 331 | 661 |
|---:|---:|---:|
| joint patterns | 1264 | 1264 |
| stratified overlap | 756 | 756 |
| extended | 508 | 508 |
| ext: min_m≠1 | 298 | 298 |
| ext: m=1, ν≥2 only | 148 | 148 |
| ext: m=1, has ν=0 | 62 | 62 |
| 22 hashes present | yes | yes |

Artefacts: `results/patterns_ext508_p*.json`, `patterns_joint1264_p*.json`,
`materialize_summary_p*.json`.

---

## 2. Sealed kill layers (task 2)

`scripts/sieve_layers.py`, order fixed:

1. **Multidegree.** `min_m ∈ {3,5}` → dead. Sealed: m∈{3,5} order cuts have
   full rank on the 39-slice (PAIR_ATTACK §3.1).
2. **Line-order finisher.** All L-options have transverse order ν≥2 → dead.
   Reconfirmed in-run: ord≥2 along one minus-line has rank 39 → dim 0
   (D35_AUDIT T1).
3. **Universal six flips.** Rank 2 on the 39-slice → every remaining cell at
   dim ≤ 37. Rigidity 0; 37-cell basis saved for the ladder.

Stratified 756 reproduces **336 + 398 + 22**. Anchor: all 22 sealed sol-hashes
sit in strat-live. Extended 508: **298 + 148 + 62** to ladder.

---

## 3. Arc-jet ladder at 12 period-3 children (task 3)

`scripts/arc_jet_ladder.py`. On the 37-cell, jets through order 9 along each
period-3 attaching pair `(w,y)`; rigidity anchors hard at κ ∈ {0,1,2,5,8}
(0 violations of 637×12 per level per prime). κ=4 records residual transverse
components (not used as a closed kill).

**Cell facts (both primes):** among the 12 period-3 kids, κ=5 vanishes on all
12; κ=2 and κ=8 vanish on 4/12 (the forced-deeper rows 68/69 family at p=331;
prime-dependent ids at p=661). Level-1/2 free on the 37-cell at those rows
matches DEPTH keep-pass.

**Closed death mechanism** for a keep of a cycle label attained only at
levels κ ≡ r (mod 3), r∈{1,2}: if every admissible level in the arithmetic
progression {r, r+3, r+6} (checked at 1,4,7 and 2,5,8) has identically zero
character-component on the 37-cell, the keep is impossible — DEAD. Both r=1
and r=2 sites fire on every one of the 62 (124+124 closed sites at p=331).

Outcome: **62 dead, 0 live** among the extended ladder inputs. Open
nonvanishing demands are recorded, not used to kill.

---

## 4. Final census (task 4)

| fate | count | source |
|---|---:|---|
| dead multidegree | 634 = 336+298 | sealed + ext |
| dead line-order | 546 = 398+148 | sealed + ext |
| dead arc-jet (ext only) | 62 | period-3 ladder |
| **live** | **22** | sealed survivors, dim ≤ 37 |

**1264 = 634 + 546 + 62 + 22.** Cross-prime identical. The 22 reappear
unchanged (anchor).

---

## 5. Honesty tiering

| claim | tier |
|---|---|
| J(5)=1264, ext=508 materialization | two-prime finite exact |
| multidegree / line-order / six-flip ranks | char-0 unconditional where modular full rank (sealed + reconfirmed) |
| 22-anchor reappearance | two-prime finite exact |
| 62 arc-jet deaths by κ≡r all-vanish | two-prime finite exact on the 37-cell |
| 508 all-dead | **FLAGGED** modular; not a degree exclusion |
| any degree exclusion | **not claimed** |

---

## 6. Not claimed

* Degree 35 is **not** closed. The 22 remain live at dim ≤ 37 under closed
  conditions (open keeps, C4/C6, dominance untouched).
* The all-dead status of the 508 is **FLAGGED** behind an ODDZERO-standard
  adversarial audit (rebuild of level assertions, jet frames, and the
  κ≡r vanishing table). It is not promoted to a transport input.
* No residue-class zero; Corollary 3.4 not armed.
* Char-0 emptiness claimed only where modular rank is full.

---

## 7. Reproduction

```sh
cd goal_runs_20260812/D35_EXTENDED_SIEVE

python3 scripts/materialize_508.py 331 661    # ~3–4 min each
python3 scripts/sieve_layers.py 331
python3 scripts/sieve_layers.py 661
python3 scripts/arc_jet_ladder.py 331
python3 scripts/arc_jet_ladder.py 661
python3 scripts/census.py 331 661
python3 verifier.py
# expect: D35_EXTENDED_SIEVE_VERIFY_OK / ALLGREEN
```

Hard constraints: python3 only; primes 331, 661; no git; writes only inside
this packet.

---

## 8. Dependencies

| import | role |
|---|---|
| `PAIR_ATTACK_D35` / `D34_GUIDED_SWEEP` | Layer-0, slicelib jets, sealed 756/22 |
| `STAGE1_STRATIFIED` / `TIGHTEN` / `COMPLEX_MAPS` | Stage-1 engine |
| `DEPTH_TABLE_GENERAL` / `TUPLE_JOINT_RESIDUE` | menus, depth contrib, J(5) |
| `D35_AUDIT` | content-address format, T1/T2 |

## Director adjudication (2026-08-12, appended before sealing)

1. Replayed clean: ALLGREEN, both primes. The 22-anchor (sealed hashes
   reappearing unchanged) is the decisive integrity check and passes.
2. The arc-jet ladder to κ = 5/8 at the twelve period-3 children is a
   NEW instrument (62 kills rest on it); per the standing rule its kills
   are FLAGGED pending an ODDZERO-standard adversarial audit — queued as
   the next audit unit together with this packet's frame-construction
   novelty (period-3 kids without level-0 values).
3. State of degree 35 after this packet: the tuple-complete census
   (J-semantics, post-T4) is 1264 = 1242 dead by closed conditions + 22
   live at dim ≤ 37. Every closed instrument currently known is
   exhausted; the remaining paths to the verdict are the landing-cubic
   certificate (inconclusive, leaning empty) and the open-condition
   realization layer, plus the audits gating the flagged kills.
