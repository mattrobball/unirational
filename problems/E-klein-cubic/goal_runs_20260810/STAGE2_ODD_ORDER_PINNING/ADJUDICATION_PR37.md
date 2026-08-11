# ADJUDICATION — PR #37, `agent/stage2-odd-order-pinning-20260810`

Adjudicator: director session, 2026-08-11. Branch merged up to `origin/main`
(`c8d5416`) before adjudication. Every verdict below is against the **final**
state of the branch.

**Overall verdict: SEALED AS CLAIMED. Merge-ready (READY-WITH-TRIMS —
the "trims" are additions, not retractions: nothing in the packet was refuted).**

---

## 1. What was replayed

| action | result |
|---|---|
| `python3 verifier.py` (both primes) | **95 checks, 0 failures**, `STAGE2_ODD_ORDER_PINNING_VERIFY_OK` / `ALLGREEN` |
| replay vs. `results/verifier_stdout.txt` | **byte-identical** (`diff` empty) |
| `scripts/check_manifest_parity.py` | PASS at the final commit (see §6) |

The packet's own claim of 95 checks and its check-group tally
(A 6 / B 38 / C 8 / D 12 / E 6 / F 5 / G 18 / H 2 = 95) are exact.

## 2. What the immune factor measures — adjudicated

The packet's framing is **correct and correctly scoped**.

`STAGE1_COMPLEX_MAPS` §15.5 isolates 22 rows of the terminus `Z` whose exact
stabiliser has **odd order** (8 `C3`-rows over the `A4`-points, 10 `C5`-rows,
4 `C11`-rows). Their defining property is that the **free stratum is their only
proper parent** (Stage-1 `verifier.py` H10), so no sweep evaluation — the entire
mechanism of Stage-1's coherence layer — can reach them. The immune factor

```
   6⁸ · 4¹⁰ · 5⁴  =  1 100 753 141 760 000  ≈  1.1 × 10¹⁵
```

is therefore **the number of order-0 boundary assignments on those 22 rows that
order-0 theory cannot cut** — a measurement of where Stage-2's work lives, not a
count of maps. Stage 2 reduces the admissible assignments on the *same* 22 rows
to `3⁸ = 6 561` using the degree/jet congruences.

**The one thing a reader must not slide over**, and the packet does say it
(§2.4 "Honest scope", §8 Tier 3(2)): the two numbers are not the same kind of
object. `1.1 × 10¹⁵` is unconditional at order 0; `3⁸` is conditional on a
**fixed `d` and a fixed map** (through the multiplicities `μ`, which are
invariants of the map, not free parameters). The "reduction by `2²⁸ · 5⁴`" is a
reduction bought by adding jet-level data, not a sharpening of the same
unconditional count. Verdict: **honestly stated, no repair needed.**

## 3. Per-claim verdicts

| # | claim | verdict |
|---|---|---|
| Lem 0.1 | no character twist (`G` perfect ⟹ `T ∈ (Sym^d W*⊗W)^G` exactly) | **CONFIRMED** (proof correct; `G` simple non-abelian) |
| §0 | `C11` weights on `W` = `Q = {1,3,4,5,9}`, all five eigenpoints on `X` | **CONFIRMED INDEPENDENTLY** — invariance of `F = Σ x_i²x_{i+1}` alone forces `a_{j+1} = −2a_j`, and `−2 ≡ 9` generates `Q`; and `F(e_j) = 0` for all `j` since no monomial is a pure power. Derived from scratch, no group model needed |
| Thm 1.2 | pinning: `w(R) = d·a_k + Σ μ_l c_l (mod n)`, else `R ⊆ Bs(T)` | **CONFIRMED** (Lem 1.1 + induction; two code paths, 47 736 cases, checks C1/C2) |
| §1.3 | five base-locus corollaries B(C11), B(C5), B(D10), B(D12), B(C3) | **CONFIRMED** (checks C3–C8); B(D10)/B(D12) genuinely re-derive sealed results from character arithmetic alone |
| Prop 1.3 | `P(W⁺_σ) ⊆ Bs(T)`; `m` odd; `ord(T⁺)` even and `≥ 2` | **CONFIRMED** (proof correct; uses `X^{D12} = ∅`) |
| Prop 1.4 | (i) `d` even ⟹ all 55 `L_σ ⊆ Bs(T)`; (ii) `ord_{L_σ}(T) ≡ d+1 (mod 2)` | **CONFIRMED**; genuinely new; (ii) consumes `STAGE1` Thm 3, which PR #32's adjudication confirms |
| Cor 1.5 | `X^{C6}`: fixed if `d ≡ 1 (6)`, swapped if `d ≡ 5`, in `Bs` otherwise | **CONFIRMED**; two independent proofs agree; no conflict with Prop 1.6 (a line can be contracted while `T` vanishes at a point of it) |
| Prop 1.6 | `C3`-eigenline contraction, `d`-dependent choice of `X^{C6}` point | **CONFIRMED** (uses `Stab_G(ℓ_w) = C6`, check B18) |
| **Thm 2.1** | `C11` quadruple obstruction: all four rows defined **iff `d ∈ Q` and `μ ≡ 0` or `d` (mod 11)**; max 3 if `d` a non-residue, max 2 if `11 ∣ d` | **CONFIRMED — SPOT-CHECK 1**, independent brute force over all `(d, μ) ∈ (Z/11)²` and all four `r ∈ Q∖{1}`: 0 disagreements, and the max-rows-defined column is `4 / 3 / 2` exactly as claimed for `d ∈ Q` / non-residue / `11 ∣ d` |
| §2.2 | ten `C5`-rows collapse `4¹⁰ → 1`; orbits preserved iff `d ≡ ±1 (5)`, swapped iff `d ≡ ±2` | **CONFIRMED — SPOT-CHECK 2**, independent |
| Prop 2.2 | the two `pt_D10` rows always land in **different** `C5`-orbits | **CONFIRMED — SPOT-CHECK 2**, for every `μ₀` with `5 ∤ μ₀` |
| §2.3 | eight `C3`-rows collapse `6⁸ → 3⁸`; residual 3 = the invisible `C6/C3` involution | **CONFIRMED**; the group-theoretic reason is correct (an odd-order source row carries no `t`), and the check D9 is the right check. Cross-check: the target-cell census is exactly reproduced by the order profile — 55 `C3`-subgroups × 4 exact-`C3` points = 220 = ledger `P3`, 55 `C6` × 2 = 110 = `P6`, 66 `C5` × 4 = 264 = `P5a+P5b`, 12 `C11` × 5 = 60 = `P11` (**SPOT-CHECK 3**, independent of the packet) |
| §2.4 | `1 100 753 141 760 000 → 3⁸ = 6 561`, reduction `2²⁸·5⁴ = 167 772 160 000` | **CONFIRMED — SPOT-CHECK 4**, exact integer arithmetic. Structurally: `6⁸ → 3⁸` is `2⁸`, `4¹⁰ → 1` is `2²⁰`, `5⁴ → 1` is `5⁴`; product `2²⁸·5⁴` ✓ |
| §2.4 | collapsed total `43 008 · 23 · 3⁸ = 6 490 036 224` | **ARITHMETIC CONFIRMED**; `43 008` and `23` are **inherited, not recounted** — see §4 |
| §3.1–3.3 | `F55` at `C11`, `D10` at `C5`, `D12/C3` at `C3` all **commute** | **CONFIRMED** (checks E1–E3); they are multiplications in an abelian group, so commutation is automatic — the packet says so |
| **Prop 3.1** | all six `C6`-children of `D_{P_σ}` non-degenerate **iff `d ≢ 0 (3)` and `m ≡ d (3)`**; else exactly two degenerate; all six when `3∣d` and `3∣m` | **CONFIRMED — SPOT-CHECK 5**, independent brute force over `d mod 6` × odd `m`, using `w(i,j) = (d−m)i + mj (mod 6)` and the on-`X` set `{1,5}`: 0 disagreements |
| Thm 4.1 | **no degree exclusion** — every residue `mod 165` (and `mod 330`) consistent | **CONFIRMED — SPOT-CHECK 7**; and it is the right verdict, because "undefined" is a legitimate branch (§8 Tier 3(4)) |
| §5 | the fourteen-row window table `d = 25 … 46`: `(3,5,11,6)` profiles, `C11`/`C5`/`C3` branches, `L_σ`, `X^{C6}` | **CONFIRMED — SPOT-CHECK 6**, all 14 rows recomputed from scratch, every cell agrees |
| §5/§6 | the `max rk dT` column (11/5/6) | **CONFIRMED — SPOT-CHECK 6**, and this was the sharpest test: I re-derived it independently from `dF` at a weight-`a` eigenpoint being supported on weight `−2a` (so `T_{[e_i]}X` drops the relative weight `−3a_i`), giving rank ≤ \|((Q−k)∖{0}) ∩ ((Q−dk)∖{0, −3dk})\| = **3, 0, 1, 1, 1** for `d ≡ 1, 3, 4, 5, 9 (mod 11)` — exactly the packet's column, and exactly checks F1/F2. Also confirmed independent of the eigenpoint `k` |
| §5 | `d = 25` dead (consumed), `d = 34` still the first open window, with four new conditions | **CONFIRMED**; nothing here revives `d = 25` and nothing here kills `d = 34` |
| §6 | first-order layer, Prop 6.1 | **CONFIRMED** (checks F1–F5) |

**No claim in this packet was refuted. Nothing was trimmed.**

## 4. The Stage-1 → Stage-2 dependency, adjudicated explicitly

Stage 2 **does** depend on Stage-1 sealed claims. The consumed inputs are:

| # | Stage-1 input consumed | where used | Stage-1 machine backing | PR #32 verdict |
|---|---|---|---|---|
| S1a | §15.5's identification of the **22 coherence-immune rows** (which rows have odd-order exact stabiliser and the free stratum as their only proper parent) | §2, the whole packet | Stage-1 `verifier.py` **H9, H10** | **CONFIRMED** |
| S1b | the per-row value counts **6 / 4 / 5** giving `6⁸·4¹⁰·5⁴` | §2.4, check D10 | Stage-1 **H9**; independently cross-checked here against the PSL(2,11) order profile (SPOT-CHECK 3) | **CONFIRMED** |
| S1c | **Theorem 3** (the three forced sweeps; `D_{L⁻_σ}` sweeps `L_σ`) | Prop. 1.4(ii), J2, J3 | Stage-1 **C3, C4** | **CONFIRMED** |
| S1d | **Theorem 6** (the `C6` pinning) | Prop. 1.6 (sharpened here) | Stage-1 **C9, E2, E3** | **CONFIRMED** |
| S1e | **Theorem 9(i)** (H0-1 parity, `m` odd) | Prop. 1.3 (re-derived here) | Stage-1 **F1, F2** | **CONFIRMED** |
| S1f | §15.3's **six `C6`-children of `D_{P_σ}`** (four over the plus-plane `C6`-points, two over the `D12`-points) | §3.4 / Prop. 3.1 | Stage-1 **H8, H11** | **CONFIRMED** |
| S1g | the factors **`43 008`** (σ-band) and **`23`** (the `D10` `C2`-line) | §2.4's collapsed total only | Stage-1 **H5, H6, H8** | **CONFIRMED**, but see below |

**Verdict on the dependency: sound.** Every Stage-1 row Stage 2 consumes is one
that PR #32's adjudication confirms, and the two most load-bearing (S1a, S1c) are
machine-checked on both sides. S1c, S1d, S1e are moreover **re-derived** inside
Stage 2 rather than merely imported, so a Stage-1 error there would surface as a
Stage-2 disagreement — it does not.

**The one honest caveat, correctly flagged by the packet (§2.4):** `43 008` and
`23` are carried into the collapsed total `6 490 036 224` **unchanged and not
recounted**. They are legitimate *upper bounds* (Stage 2 only adds constraints —
§3.4 removes `C6`-children when `m ≢ d (mod 3)`, Prop. 1.4 puts every `L_σ` in
the base locus when `d` is even — and added constraints can only shrink a count).
So `6 490 036 224` is an upper bound, not a count. The packet says exactly this.
**No repair required.**

Note also that `43 008` is a **post-coherence-revision** Stage-1 number. Had the
PR #32 coherence revision been wrong, this figure would be wrong. PR #32's
adjudication confirms the revision is a correction (Stage-1 H5–H8), so the
inheritance is safe. **Merge order therefore matters: PR #32 before PR #37.**

## 5. Findings and what was done

| # | finding | severity | action |
|---|---|---|---|
| F1 | **`STATUS.md` was missing.** Seven of the ten packets in `goal_runs_20260810/` carry one, and it is what `check_manifest_parity.py` uses to recognise a run dir | hygiene | **FIXED** — `STATUS.md` written, carrying the headline numbers, the full exit ledger, and the open items |
| F2 | **Only 2 of the 7 exits appeared verbatim in `NOTEBOOK.md`** (`STAGE2-ODD-ORDER-PINNING-SEALED`, `STAGE2-NO-DEGREE-EXCLUSION`). The parity checker only enforces the *primary* exit, so this passed while under-recording | hygiene | **FIXED** — the full exit ledger added to the notebook entry |
| F3 | Branch was behind `origin/main` | hygiene | **FIXED** — `origin/main` (`c8d5416`) merged in; manifest conflict resolved by record-union + `known_branches` union; notebook parent pin set to the merge parent |
| F4 | `agent/retract-landscape-20260811` was a live remote branch absent from `known_branches`, failing parity check 10 (pre-existing drift from another session, not this PR's doing) | hygiene | **FIXED** — added to `known_branches` |
| F5 | No load-bearing count or seal in this packet is a bare assertion. D8–D12 cover the collapse; C1–C8 the congruence engine; D1–D2 the residue table; G the brute-force covariant confirmation | — | none needed |

## 6. Merge readiness

**READY-WITH-TRIMS** — where the only changes are additions (`STATUS.md`, the
notebook exit ledger, this file) and branch hygiene. **No claim was retracted or
weakened.**

**Required merge order: PR #32 (`STAGE1_COMPLEX_MAPS`) must merge first.** Stage 2
consumes the post-revision Stage-1 numbers (S1a, S1f, S1g) and its
`ADJUDICATION` references them; merging PR #37 alone would land a packet whose
§10 dependency table points at a Stage-1 commit not on `main`.

`scripts/check_manifest_parity.py`: **PASS** at the final commit on this branch.
