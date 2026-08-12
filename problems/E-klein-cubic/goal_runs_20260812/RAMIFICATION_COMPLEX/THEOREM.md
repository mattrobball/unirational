# The equivariant ramification complex (morphism ledger L8)

**Packet:** `goal_runs_20260812/RAMIFICATION_COMPLEX/` · opened 2026-08-12.
**Headline: Problem E remains OPEN; this packet excludes no degree.**

> # VERDICT: **RAMIFICATION LAYER ENUMERATED; J UNCUT; 22 ANCHOR INTACT**
>
> Per-row conormal character tables and admissible `(χ ↦ χ′, k)` assignments
> are computed for all 15 sweep-capable and 22 coherence-immune census rows
> under the tuple-level weight rule (Lemma 1.1, quoting STAGE2 Theorem 1.2).
> Receiver tangent-cone characters at type-I/II and `X^{C6}` / coordinate
> points are machine-checked. Joined onto the sealed J census: **cut = 0 at
> every residue mod 6** (no class-at-infinity zero; Corollary 3.4 not armed).
> At `d = 35` the sealed **22** reappear with **0 closed character-incompatibility
> kills**. Problem E remains OPEN; this packet excludes no degree.

*(Filename note: the main document is `THEOREM.md`; the harness refuses the
literal name `REPORT.md`.)*

## Exit ledger

```text
RAMCX-CONORMAL-TABLES
RAMCX-WEIGHT-RULE-LEMMA
RAMCX-RECEIVER-TC
RAMCX-JOIN-NO-ZERO
RAMCX-JOIN-FREE
RAMCX-D35-ANCHOR-22
RAMCX-NO-DEGREE-EXCLUSION
```

Machine markers: `RAMIFICATION_COMPLEX_VERIFY_OK` / `ALLGREEN`
(`python3 verifier.py` — both primes `p = 331, 661`).

---

## Summary (≤ 25 lines)

1. **Layer L8.** Per-stratum normal response: conormal `χ` of `S` maps at
   order `k_χ ≥ 0` into receiver normal `χ′` under the weight rule
   `χ′ = ψ_S · χ^{k} · (slot factors)` — additive form
   `w ≡ w_tang + Σ k_ℓ c_ℓ (mod n)`.
2. **Lemma 1.1 (tuple-level weight rule).** Leading normal jets of any
   landing tuple obey it. Proof = equivariance argument of STAGE2 Theorem 1.2
   (quoted), with tangential multiform character `ψ_S` in place of `d·a_k`
   on positive-dim strata. PATH A/B: 1200 cases, 0 mismatches.
3. **Tables.** 37 rows (15 sweep + 22 immune); 159 live value-options;
   **0 degree-free dead**. Conormal weights: C2 → `{1}`; immune from STAGE2
   chains (C11: `{3,5,6,7}`; C5: `{1..4}`; C3: length 1–2).
4. **Receiver TC.** Coordinate pts: `T_{e_j}X = {x_{j+1}=0}`, conormal weight
   `≡ −3a_j` (cycle `1→9→4→3→5`). C5/C6 via spectrum. Machine at 331/661.
5. **Join on J.** Before = sealed `J = 11594/1408/2018/10752/1596/1264`.
   After = **same** (cut 0 all `ρ`). No zero. FLAG discipline idle.
   ODDZERO gate named, not triggered.
6. **d = 35 on the 22.** Anchor intact both primes; 0 closed kills on the 22.
   Immune rows still admit on-`X` weights at some `(k_ℓ)` (no closed
   char-incompat). Map-level B(C11)/B(C5) recorded as reference only.
7. **Not claimed:** no degree exclusion; J still a relaxation upper bound;
   no transport closure; STAGE2 pinning not re-imposed at tuple level.

---

## 0. Stakes and inputs

Morphism ledger L8 (`theory/MORPHISM_LEDGER_20260812.md`): the equivariant
map of normal cones `N_S → N_{τ(S)}`. Prior campaign used only the numeric
shadow `m_E` (C1) and the point-strata case (STAGE2). This packet enumerates
the per-character, per-stratum tables at **tuple level**.

| input | use |
|---|---|
| `STAGE1_COMPLEX_MAPS` | census rows, sweep/immune, value cells |
| `STAGE2_ODD_ORDER_PINNING` Thm 1.2, `s2pin.py` | master weight formula; immune chains |
| `TERMINUS_STRATA_PW` / stage-3 frames | `normal_chars`, B-marked weights |
| `RECEIVER_LEDGER_X` | special points; on-`X` weights |
| `TUPLE_JOINT_RESIDUE` | sealed J census to join onto |
| `D35_EXTENDED_SIEVE` / `PAIR_ATTACK_D35` | 1264/22 anchor |

Hard constraints: python3 only; primes 331, 661 for modular checks; core is
prime-free character arithmetic; no git; write only inside this packet.

---

## 1. The weight rule (tuple level)

### 1.1 Quote: STAGE2 Theorem 1.2

> **Theorem 1.2 (pinning).** The value of `T` at the generic point of a
> `g`-fixed stratum `R` reached by the chain (centre weight `a_k`, relative
> weights `c_ℓ`, orders `μ_ℓ`) is a `g`-fixed point of `X` of weight
>
> ```
>      w(R)  =  d · a_k  +  Σ_l  μ_l · c_l      (mod n) ,
> ```
>
> or `0`. *Proof.* Level 0 = monomial character (Lemma 1.1). Inductive step:
> expand `v = e_k + Σ y_j e_j`, blow up, read the exceptional map. Landing
> forces a point of `X`; equivariance forces `g`-fixed. ∎

### 1.2 Lemma (tuple-level weight rule)

> **Lemma 1.1 (this packet).** Let `T` be any `G`-equivariant reduced landing
> lift. Let `S` be a `g`-fixed source stratum with conormal characters of
> relative weights `c_ℓ` and leading orders `k_ℓ ≥ 0`. Let `w_tang ∈ Z/n` be
> the tangential contribution (`d·a_k` at a point centre; the evaluation
> character weight of `ψ_S^{-1} · ∏ μ_r^{a_r}` on a positive-dim stratum).
> Then the value of `T` at the generic point of `S` lies in weight
>
> ```
>      w(S)  ≡  w_tang  +  Σ_ℓ  k_ℓ · c_ℓ     (mod n) ,
> ```
>
> or is `0`. Multiplicatively: `χ′ = ψ_S · χ^{k} · (slot factors)`.
>
> *Proof.* Identical to the equivariance argument of Theorem 1.2: the same
> expansion in the eigenchart and the same blowup induction apply, with the
> centre monomial of degree `d` replaced by the `Γ_S`-equivariant multiform
> of character `ψ_S` and multidegree `(a_r)` on the tangential slots. Lemma 0.1
> of STAGE2 (`G` perfect ⇒ no character twist: `T(gv) = g T(v)`) is used
> exactly once, as there. Landing is Lemma 0.2. ∎

PATH A implements the closed form; PATH B rebuilds the same weight from a
global monomial's exponents (Lemma 1.1 of STAGE2). **1200 random cases, 0
mismatches.** Agreement with `s2pin.pathA_weight` on shared specialisations.

### 1.3 First-order differential blocks (Prop 6.1, reused)

`dT` preserves relative weight; `T_p X` drops relative weight `−3a` at a
weight-`a` eigenpoint of `X`. Admissible `k = 1` blocks = `src ∩ tgt \ {−3a}`.

---

## 2. Per-row conormal tables

Tabulated rows: STAGE1 `rows_that_may_sweep` (15) ∪ coherence-immune free
blocks (22) = **37**.

| block | ids | `n_χ` | `n_val` each | live | dead |
|---|---|---:|---:|---:|---:|
| sweep C2 | 1,2,3,4,5,6,8–16 | 1 | 1–23 | all | 0 |
| immune C3 | 21,22,29–34 | 1–2 | 6 | all | 0 |
| immune C5 | 47–56 | 1 | 4 | all | 0 |
| immune C11 | 76–79 | 1 | 5 | all | 0 |
| **total** | **37** | — | — | **159** | **0** |

Immune conormal weights from STAGE2 chains (canonical relative weights over
representative bases). Sweep C2: single sign character weight `1`. Full
machine tables: `results/conormal_tables_p{331,661}.json`, sizes in
`conormal_table_sizes.txt`.

For each row and each Stage-1 value cell, the set of admissible
`(χ ↦ χ′, k)` (equivalently tuples `(k_ℓ)` with `w_tang + Σ k c ≡ a_val`)
is enumerated over `d = 0..11` (covers all residues mod 3,5,6,11 partial).
**No value option is degree-free dead.**

---

## 3. Receiver tangent-cone layer

`X = {F = 0}`, `F = Σ_{i∈Z/5} x_i² x_{i+1}`, smooth. Tangent cone at `p` =
tangent hyperplane `ker(dF_p)`.

### 3.1 Coordinate / C11 points

C11-invariance of `F` forces `a_{i+1} ≡ −2 a_i (mod 11)`. Coordinate cycle of
weights: `1 → 9 → 4 → 3 → 5 → 1`. At `e_j`:

* `∇F(e_j)` has single nonzero entry `∂F/∂x_{j+1} = 1`
* tangent hyperplane: **`x_{j+1} = 0`**
* conormal relative weight `a_{j+1} − a_j ≡ −3 a_j` (matches Prop 6.1)
* `T_{e_j}X` characters = ambient relative weights minus `{−3 a_j}`

Machine: both primes, all five points, hyperplane check passes.

### 3.2 C5 / C6 / V4

| locus | on-`X` weights | `T_X` chars |
|---|---|---|
| `X^{C5}` | `{1,2,3,4}` (weight 0 off) | ambient rel minus `−3a` |
| `X^{C6}` | `{1,5}` | same |
| type-I (PI) | three V4 character lines | residual C3 orbits; template in results |
| type-II (PII) | `X ∩ ℓ_V` (3 pts) | residual C3; Stage-1 excludes on `Z` |

Admissible `χ′` at special values must land in the `T_X` character set
(intersection with the weight-rule image). No Stage-1-allowed special value
loses all `χ′` under this cut.

---

## 4. Join onto the J census

```
   J_ram(ρ)  =  J(ρ) · ∏_{immune rows} (n_live(ρ) / n_opts)
```

where `n_live(ρ)` = number of value options of the row that admit some
weight-rule assignment for at least one `d ≡ ρ (mod 6)`.

| `ρ` | sealed `J` | `J_ram` | cut | zero |
|---:|---:|---:|---:|:---:|
| 0 | 11594 | **11594** | 0 | no |
| 1 | 1408 | **1408** | 0 | no |
| 2 | 2018 | **2018** | 0 | no |
| 3 | 10752 | **10752** | 0 | no |
| 4 | 1596 | **1596** | 0 | no |
| 5 | 1264 | **1264** | 0 | no |

**No class-at-infinity zero.** Corollary 3.4 of the transport note is not
armed. Zero-class discipline (FLAG, never claim, ODDZERO audit as gate)
stands ready and is idle.

Sweep-band values carry no additional degree-free kill (Stage-1 already
character-filters them; the cone and depth layers are upstream in J).
STAGE2 map-level pinning is **not** re-imposed (tuple-level join only).

---

## 5. Degree-35 effects on the 22

`d = 35 ≡ 5 (mod 6)`, `≡ 0 (mod 5)`, `≡ 2 (mod 11)`, `≡ 2 (mod 3)`.

| check | result |
|---|---|
| sealed 22 sol-hashes present | **yes** (both primes; 22 each) |
| closed char-incompat kills on the 22 | **0** |
| anchor intact | **yes** |
| immune-row closed kills (all on-`X` weights unreachable) | **0** |

Mechanism note. The 22 are stratified σ-band survivors at dim ≤ 37. Their
value assignments avoid every degree-free character incompatibility of this
layer. Immune rows still admit at least one on-`X` value weight for some
`(k_ℓ)` at `d = 35` (e.g. C11 base 9, `w_tang ≡ 7`, chain `c = 3`: order
`k = 9` hits weight 1). Map-level base-locus corollaries B(C11) / B(C5)
(`35 ∉ Q`, `5 ∣ 35`) force level-0 centres into `Bs(T)` but do not produce a
**closed** tuple-level character-incompatibility on the 22 sol-hashes; they
are recorded as reference only and not used to kill.

Any future death among the 22 from this layer must state a closed
character-incompatibility mechanism and re-check the anchor.

---

## 6. Honesty tiering

**Tier 1 — exact, prime-free.** Lemma 1.1 (quote of Thm 1.2); PATH A
formula; C11 cycle `a_{i+1} ≡ −2a_i`; tangent hyperplane `x_{j+1} = 0`;
join arithmetic; no-zero verdict.

**Tier 2 — finite integer / two primes.** PATH A/B cross-check; conormal
tables matched to STAGE2 chains + terminus frames; TC machine at 331/661;
J_ram vs sealed J; 22-anchor hash counts.

**Tier 3 — not claimed.** Existence of maps; char-0 emptiness of the 22;
degree exclusion; transport closure; map-level STAGE2 pinning as a tuple cut.

---

## 7. Not claimed

* No degree is excluded.
* `J_ram = J` is still a relaxation upper bound on realized landing tuples.
* The ramification tables constrain jets; they do not by themselves produce
  a residue-class zero or a kill among the 22.
* L9 (chain-jet transitivity) and L10 (global cycle ledger) remain unspent.

---

## 8. Replay

```sh
cd goal_runs_20260812/RAMIFICATION_COMPLEX
python3 scripts/produce_all.py
python3 verifier.py
# expect: RAMIFICATION_COMPLEX_VERIFY_OK / ALLGREEN
```

Artefacts under `results/`: `summary.json`, `conormal_tables_p*.json`,
`receiver_tangent_cone.json`, `join_summary.json`, `d35_effects.json`,
`pathAB_crosscheck.json`, `joint_table.txt`, `conormal_table_sizes.txt`.

---

## 9. Dependencies (read-only)

* `goal_runs_20260810/STAGE1_COMPLEX_MAPS/`
* `goal_runs_20260810/STAGE2_ODD_ORDER_PINNING/`
* `goal_runs_20260810/RECEIVER_LEDGER_X/`
* `goal_runs_20260810/TERMINUS_STRATA_PW/`
* `goal_runs_20260812/TUPLE_JOINT_RESIDUE/`
* `goal_runs_20260812/D35_EXTENDED_SIEVE/`
* `goal_runs_20260811/PAIR_ATTACK_D35/`
* `theory/MORPHISM_LEDGER_20260812.md`, `theory/EXCLUSION_TRANSPORT_20260811.md`

## Director adjudication (2026-08-12, appended before sealing)

Replayed clean: ALLGREEN. Provenance: executed by a weak-model lane
before the Fable-only rule for morphism work was instituted; the
execution is mechanically sound (verifier replayed by the director) and
the result is an honest null — this layer is now SPENT WITH NO CUT at
the current depth. Landed for the ledger's completeness, not for bite.
