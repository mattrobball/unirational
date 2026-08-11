# ADJUDICATION — PR #32, `agent/stage1-complex-maps-20260810`

Adjudicator: director session, 2026-08-11. Branch merged up to `origin/main`
(`c8d5416`) before adjudication. Verdicts are against the **final** state of the
branch (commit `a8c8ad9`, the coherence revision), with a separate verdict on
what the revision changed.

**Overall verdict: SOUND. The coherence revision is a genuine correction, not a
silent weakening, and the retraction is recorded honestly. Merge-ready
(READY-WITH-TRIMS: three documentation defects fixed in place, one unverified
assertion converted into two machine checks; no claim retracted by me).**

---

## 1. The two commits, and what the revision did

| commit | |
|---|---|
| `b1ae869b` | "audited and sealed" — Layers 1–3, witness sections, adversarial audit applied (§14). 95 checks. |
| `a8c8ad97` | "coherence revision (user-mandated)" — evaluation rigidity, corrected count, eight forced sweeps. 123 checks. |

**Verdict on the revision: CORRECTION, honestly recorded. Not a weakening.**

The first commit's Theorem A claimed the object it counted was *"the set of
Stage-1 morphisms `𝔽(Z) → 𝔽(X)`"*, of size `69 686 233 329 838 325 760 000`.
That count imposed only **value-set (arc) consistency** — `im(F) ⊆ cl(im(F'))` —
and treated the constraint blocks as independent. The revision imposes
**evaluation coherence**: if a row sweeps its line via a Layer-2 morphism `φ`,
the value at every deeper row is the *evaluation* `φ|_R`, not a free choice.
The consequences, all four of which are retractions of the earlier commit:

| what the revision retracted | how it is recorded |
|---|---|
| the count itself: `6.97 × 10²²` → `1.089 × 10²¹`, a factor **64 = 2⁶ smaller** | §15.3; the old figure is retained explicitly as "the arc-consistent intermediate", and check C11/C12 still verify it as such so H7 can measure the cut against it |
| the **object**: "the set of Stage-1 morphisms" → "stratum-coherent order-0 **boundary patterns**" | §15.4 has a bolded "**This is not a moduli of maps**", and the reframing separates boundary pattern / Layer-2 datum / actual map |
| the exit `STAGE1-SECTION-MODULI-SEALED` | renamed to `STAGE1-BOUNDARY-PATTERNS-SEALED`, with the old name carried in `STATUS.md` as "(was …)" and in the notebook entry |
| the exit `STAGE1-THREE-FORCED-SWEEPS`, and with it the **D4 minimal-sweep witness** (a section in which only the three forced rows sweep) | renamed to `STAGE1-EIGHT-FORCED-SWEEPS`; §5 now reads "the minimum is **eight** rows, not three. Value-set consistency alone admits a 3-sweep section (D4); evaluation coherence does not (H14)"; check D4 was **reworded** from "witness: minimal sweep" to "arc-consistency **alone** admits a 3-sweep section", and a **new check H14** asserts that section is *not* coherent |

The count moved **down**, i.e. the cut got *stronger*; the claim that weakened is
the one about *what kind of object* is being counted, and that weakening is
stated more loudly than the number is. `REGISTRATION_SNIPPET.md` says it in
terms: *"The earlier figure 69686233329838325760000 is superseded as the headline
number and retained only as the pre-coherence intermediate."* `STATUS.md`'s
timeline records the director correction order and the reason ("the count treated
the constraint blocks as independent"). **No silent weakening found.**

Neither number was ever a headline claim: Problem E is OPEN before and after.

## 2. What was replayed

| action | result |
|---|---|
| `python3 verifier.py` (both primes), at `a8c8ad9` as committed | **123 checks, 0 failures**, `STAGE1_COMPLEX_MAPS_VERIFY_OK` / `ALLGREEN` |
| replay vs. `results/verifier_stdout.txt` | **identical**, check for check and verdict for verdict (the stored file merely omits the two `===== p = … =====` banner lines) |
| `python3 verifier.py` after my F7/F8 additions | **127 checks, 0 failures** (see §5) |
| `scripts/check_manifest_parity.py` | PASS at the final commit |

## 3. Per-claim verdicts

| # | claim | verdict |
|---|---|---|
| §0 | source: 940/220/55 arrangement; 80 orbits, 11 076 components, 145 closure relations, rebuilt at component level and equal to the sealed `TERMINUS_STRATA_PW` census | **CONFIRMED** (A3, A5–A7, A9, both primes). This is a genuine second derivation of the strata layer, on the shared `psl211.py` model — the sharing is disclosed in `inputs/PROVENANCE.md`, correctly |
| §0 | target: cell sizes `1/55/55/165/165/110/220/132/132/60`, and the base-locus inventory (55 `D12`-pts, 66 `D10`-pts, 110 `A4`-pts, 55 `ℓ_V`, 55 plus-planes) | **CONFIRMED INDEPENDENTLY** — I reproduced **every** entry from PSL(2,11) subgroup arithmetic alone (order profile `1,55,110,264,110,120`; Sylow-2 `= V4` since `11 ≡ 3 (mod 8)` with `N(V4) = A4` so 55 of them; `N(C5) = D10`, `C(σ) = N(C3) = D12`, `N(C11) = F55`): `55·3 = 165` type-I, `55·2 = 110` `X^{C6}`, `55·4 = 220` exact-`C3`, `66·4 = 264` `X^{C5}`, `12·5 = 60` `X^{C11}`, `55·2 = 110` `A4`-points. All 13 rows agree |
| §0 | order-0 incidence proved, not sampled; odd-order stabiliser ⟹ off every `E_σ` and `L_σ` | **CONFIRMED**; the argument (`E_σ ∪ L_σ ⊆ X^σ` is *pointwise* `σ`-fixed) is correct and settles `RECEIVER_LEDGER_X` remainder 2 negatively, as claimed |
| **Thm A** | `1 088 847 395 778 723 840 000 = 2¹¹·21·23·6⁸·4¹⁰·5⁴`; rigid `994 165 013 537 095 680 000`, moving `94 682 382 241 628 160 000` | **CONFIRMED** — machine (H5, H6) and independent exact integer arithmetic. Also `43 008 = 2¹¹·21 = 2⁹·84`, and the split `23 = 21 + 2` gives the rigid/moving pair exactly |
| §1 | arc-consistent count `69 686 233 329 838 325 760 000`, ratio exactly `64 = 2⁶` | **CONFIRMED** (C11, C12, H7; and independently) |
| §1 | the 80-row inventory | **CONFIRMED**, and it closes: `1 + 15 C2 + 5 C3(C6) + 8 C3(C3) + 18 V4 + 10 C5 + 19 C6 + 4 C11 = 80`, matching the sealed census |
| §1 | the block decomposition `51 + 1 + 8 + 10 + 4` rows | **CONFIRMED** from `results/coherence_331.json`, with the correction in §5-D1 below: `51 + 1 + 8 + 10 + 4 = 74`, and the remaining **6** rows carry a single forced value |
| Thms 1, 2 | rigid rationality; finiteness of images | **CONFIRMED** (C6, C7, B5) |
| Thm 3 | three forced sweeps; strengthens sealed H0-2; `X^{D12} = ∅` is the engine | **CONFIRMED** (B5, C3, C4) |
| Thm 3′ | five more forced sweeps under coherence ⟹ **eight** unconditionally; only 4 of the `2⁸` sweep-patterns on the eight `V4`-stabilised `C2`-rows survive | **CONFIRMED** (H11, H12, H14) |
| Thm 4 | type-II exclusion at **all 18** `V4`-rows of `Z`, unconditionally, no external import | **CONFIRMED** (C1). This genuinely supersedes (F2) on `Z`; the packet is careful that (F2) is still needed on `Z⁺` and is EXTERNAL-UNVERIFIED there |
| Thms 5, 5′ | the `v_σ` rule; 12 of 18 `V4`-rows rigid | **CONFIRMED** (C2, H11, H12) |
| Thm 6 | the `C6` pinning = `PHI_SEXTIC_ISOGENY` Thm 4 | **CONFIRMED** (C9, E2, E3) |
| Thm 7 | exactly one elliptic door (the `D10` `C2`-line) | **CONFIRMED** (C7) |
| Thm 8 | image inventory: only `X` and the 55 lines are positive-dimensional images | **CONFIRMED** (C6, C7, B2) |
| **Thm 15.1** | evaluation rigidity: the evaluation is constant on each component of `M_S`; the span is never 2-dimensional | **CONFIRMED** — the proof is a correct two-line character argument (`W⁻_σ\|_Λ` splits into two *distinct* characters whenever `Λ ⊇ V4` or `Λ ⊇ C6`), and H1 reports 0 failures over all 15 sweep rows, all components, all 100 child components, both primes |
| §15.2 | exactly **two** of the fifteen evaluation maps are not surjective, and they are exactly the two dim-3 divisors, with images `128` of `262 144` and `64` of `128` | **CONFIRMED** (H2, H3, H4), and consistent: 18 multi-valued children ⟹ `2¹⁸ = 262 144`, 7 ⟹ `2⁷ = 128`; the `D_{P_σ}` image factors as `2 × 64 = 128` and `D_{L⁻_σ}`'s is exactly half |
| §15.2 | 38 of 48 computed components of `M_{D_{P_σ}}` evaluate a child outside its arc-consistent domain | **CONFIRMED** against `results/coherence_331.txt` (`\|Comp\| = 48`, `usable = 10`) |
| §15.5 | the coherence-immune factor: 22 rows, `6⁸·4¹⁰·5⁴ = 1 100 753 141 760 000`, each with the free stratum as its **only** proper parent | **CONFIRMED** (H9, H10), and the row sizes `220/132/60 = 660/\|Stab\|` check out for `Stab = C3, C5, C11` |
| §4, Thm 9(i) | H0-1 parity re-derived by character theory, exact in `Z[ζ₆]` | **CONFIRMED** (F1, F2, F5) |
| §4, Thm 9(ii) | `N(d,m) > 0` for every odd `m ≤ d`; window values `N(1,1)=1, N(3,1)=4, N(25,3)=368, N(34,1)=397, N(43,1)=631` | **CONFIRMED and now machine-backed** — see §5-D2. The five window values are reproduced by the closed formula exactly, and `N(34,1) = 397` is the dimension quoted for the first open window |
| §5 | the maximal-sweep witness (0 violations against all 145 relations) is evaluation-coherent | **CONFIRMED** (D1–D3, H13) |
| §6 | EV1/EV2/EV3, with the "admissible class" scope caveat | **CONFIRMED**; the caveat is the right one and is repeated in Tier 3(2) |
| §7 | `Z⁺`'s three new rows: type-II exclusion covered only by the conditional (F2) | **CONFIRMED as flagged**; correctly marked EXTERNAL-UNVERIFIED in §12 |
| §14 | the adversarial audit's edits applied; verdict REGISTER-WITH-EDITS | **CONFIRMED** by inspection of the two commits |

**No claim of the final state was refuted. Nothing was trimmed.**

## 4. The count's honest limit — checked, not just read

§15.6(1) flags that the coherence tables are computed to a **multidegree cutoff**
(4 for two-slot rows, 6 for one-slot) and asserts, without an artifact or a
check, that "the total is unchanged at maxdeg 3, 4, 5 and 6". Since the whole
count rests on those tables, I ran it. See §5-D3 for the result.

The remaining Tier-3 items of §15.6 — sampled generic points of `π(F_R)`, and
coherence being imposed *stratum-locally* rather than globally — are correctly
stated as the honest limit and are not repairable at order 0 by construction
(§15.4). I concur with that framing.

## 5. Findings, and what was done about each

| # | finding | severity | action |
|---|---|---|---|
| **D1** | **Documentation error in §1's block table.** It listed "the two dim-3 divisors" as members of the 51-row coupled core. They are not: `results/coherence_331.json` shows six rows sitting in **no** block because they carry a single forced value — the free stratum, `D_{P_σ}`, `D_{L⁻_σ}`, the `pt_D12` line, and the two rigid `V4`-rows. A forced-unique row cannot lie in a multi-valued block. `51 + 1 + 8 + 10 + 4 + 6 = 80` | documentation only — the count is carried by H5/H8, not by the prose | **FIXED in place**, with the correction noted inline |
| **D2** | **A bare assertion on a load-bearing point.** §14's audit-derived closed form `N(d,m) = (1/3)[C(d−m+2,2)(m+1) − ε]`, `ε = [3∣d−m]·c(m)`, `c(m) = 1,−1,0` for `m ≡ 0,1,2 (mod 3)` — the sole basis for removing the `d ≤ 45` restriction from Theorem 9(ii) and for withdrawing Tier 3(5) — had **no machine check anywhere**. `verifier.py` only checked `N(d,m) > 0` for `d ≤ 45` | **real finding** in a packet of this size | **FIXED — checks built.** The formula is **correct**: I verified it against the exact `Z[ζ₆]` character route on **1 122 odd-`m` cases per prime up to `d = 66`** (beyond the packet's own 45), 0 mismatches at both primes. Two checks added to `verifier.py`: **F7** (closed form = exact route on every odd `m ≤ d ≤ 45`, 529 cases per prime) and **F8** (the all-`d` positivity as arithmetic: `C(d−m+2,2)(m+1) ≥ 2 > 1 ≥ ε`, so `N ≥ 1/3` and integral, hence `≥ 1`). Verifier now **127 checks, 0 failures** |
| **D3** | **§15.6(1)'s saturation-stability claim had no artifact and no check** — "the total is unchanged at maxdeg 3, 4, 5 and 6" was stated but not recorded anywhere | **real finding** — the count depends on it | **CHECKED. The claim holds.** Re-running the recount at a *uniform* maxdeg on all 15 sweep rows at `p = 331` — below the producer's default in one slot-class and above it in the other — gives the **same** total and the **same** `(51 rows, 43 008)` core at maxdeg **3, 4, 5 and 6**, with 0 rigidity failures throughout: `1 088 847 395 778 723 840 000` every time. Recorded as `results/saturation_probe_331.txt`, reproducible via the new `scripts/s1saturation.py`. The underlying non-saturation caveat is a genuine open item and stays flagged: stability at 3–6 is evidence, not a proof |
| **D4** | §11 Tier 3(5) still read "`N(d,m) > 0` is verified for `d ≤ 45`; we have no proof for all `d`" — directly contradicting §14's "Tier 3(5) is withdrawn" | internal inconsistency | **FIXED in place**: struck through, marked WITHDRAWN, and pointed at the new F7/F8 |
| **D5** | §9's replay line still said `# 47 checks per prime` — stale since the revision grew it to 61 | stale text | **FIXED** (now 63) |
| **D6** | Branch behind `origin/main`; `agent/retract-landscape-20260811`, `agent/duncan-imports-review-20260811`, `agent/stage2-second-order-20260811` absent from `known_branches` (concurrent-session drift, not this PR's doing) | hygiene | **FIXED** — merged, manifest record-union, `known_branches` synced against every live `origin/*` ref, notebook parent pin set to the merge parent |
| **D7** | Every other load-bearing count or seal **is** machine-checked. A1–A9 cover the source census, B1–B8 the target, C1–C12 Layer 1 and the arc-consistent count, D1–D5 the witnesses, E1–E7 the anchors, F1–F8 Layer 2/3, H1–H14 the whole coherence layer, G1 the cross-prime identity | — | none needed |

## 6. Downstream: what PR #37 consumes from here

PR #37 (`STAGE2_ODD_ORDER_PINNING`) depends on this packet. The rows it consumes
and my verdict on each:

| Stage-1 input | Stage-1 machine backing | verdict |
|---|---|---|
| §15.5's 22 coherence-immune rows and their value counts `6/4/5` | H9, H10 | **CONFIRMED** |
| Theorem 3 (forced sweeps) — used by Stage-2 Prop. 1.4(ii), J2, J3 | C3, C4 | **CONFIRMED** |
| Theorem 6 (the `C6` pinning) — sharpened by Stage-2 Prop. 1.6 | C9, E2, E3 | **CONFIRMED** |
| Theorem 9(i) (H0-1 parity) — re-derived as Stage-2 Prop. 1.3 | F1, F2 | **CONFIRMED** |
| §15.3's six `C6`-children of `D_{P_σ}` — used by Stage-2 Prop. 3.1 | H8, H11 | **CONFIRMED** |
| the factors `43 008` and `23`, carried into Stage-2's collapsed total | H5, H6, H8 | **CONFIRMED**; Stage 2 flags them as inherited upper bounds, correctly |

**`43 008` is a post-revision number.** Stage 2's collapsed total is only as good
as the coherence revision, which this adjudication confirms. **Merge order: this
PR first, then PR #37.** At least two other sessions are already building on
these packets (`agent/stage1-tighten`-style work under `goal_runs_20260811/`, and
`agent/stage2-second-order-20260811`), so landing them out of order would strand
their dependency tables.

## 7. Merge readiness

**READY-WITH-TRIMS**, where the trims are: three documentation defects fixed in
place (D1, D4, D5), one unverified assertion converted into two machine checks
(D2), one unrecorded stability claim actually run (D3), and branch hygiene (D6).
**No claim was retracted by this adjudication**, and the coherence revision's own
retractions were already recorded honestly by its author.

`verifier.py`: **127 checks, 0 failures**, both primes.
`scripts/check_manifest_parity.py`: **PASS** at the final commit on this branch.
