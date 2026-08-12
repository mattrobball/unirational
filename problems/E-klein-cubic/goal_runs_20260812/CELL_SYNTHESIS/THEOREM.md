# CELL_SYNTHESIS — joint realization verdict for the 22 live cells at d = 35

**Packet:** `goal_runs_20260812/CELL_SYNTHESIS/` · opened 2026-08-12.
**Headline: Problem E remains OPEN; this packet excludes no degree.**

Mechanical assembly of sealed realization constraints on the 22 surviving
cells at degree 35.  No new morphism is derived.  Menus stay menus.  A
contradiction, if the intersection of sealed constraints were empty, would
be a FLAG_KILL and would not be claimed.  The intersection is nonempty on
every cell and every admissible menu entry.

*(Filename note: main document is `THEOREM.md`; the harness refuses
`REPORT.md`.)*

## Exit ledger

```text
CELL-SYNTHESIS-22-IDENTITY
CELL-SYNTHESIS-MENUS-UNCOLLAPSED
CELL-SYNTHESIS-INVARIANT-TABLE
CELL-SYNTHESIS-PER-CELL-VERDICT
CELL-SYNTHESIS-INTERSECTION
CELL-SYNTHESIS-NO-CLAIMED-KILL
CELL-SYNTHESIS-NO-DEGREE-EXCLUSION
```

Machine markers: `CELL_SYNTHESIS_VERIFY_OK` / `ALLGREEN`
(`python3 verifier.py` — **79 checks, 0 failures, 0 skips**; groups
A = 24, B = 29, C = 26).  Exact integer arithmetic; python3 standard
library only; no git; nothing outside this packet directory was written.

---

## 0. What is and is not claimed

**Claimed.** (i) The 22 cells are identified by `content_hash` at `p = 331`,
with the D35_AUDIT / SMITH_I3 / STEIN_LERAY pairings in exact agreement.
(ii) The immune menu is the uncollapsed `F_odd(35)` product
`10 × 4 × 4 × 4 × 238 × 238 = 36 252 160`, admissible in full for every
cell (no cell-to-menu linkage exists).  (iii) A factored table of every
fiber-structure invariant the sealed inputs constrain, intersected per
cell and per menu entry.  (iv) A single must-look-like verdict, identical
on all 22 cells.  (v) A mechanical emptiness scan: no row has empty
intersection; no kill is claimed.

**Not claimed.** See §8.  In particular: no cell dies, no degree is
excluded, and the FLAG-M smooth-trace near-kill is not promoted.

---

## 1. Inputs, all sealed

| packet | consumed for |
|---|---|
| `SMITH_I3` | `χ_top ≡ 4 (mod 11)` at the five `C11`-points, five values EQUAL; `≡ 0 (mod 5)` at the four `C5`-points; σ-band of the 22; full-menu admissibility |
| `STEIN_LERAY` | `χ₀` one integer on the 1-dimensional-fibre locus; `χ₀ ≡ 35 (mod 55)` in the smooth row; dichotomy; Proposition PIN; invariant degrees `{k ≥ 5}` |
| `L12_ORDER11` | all 60 `C11`-points in `Bs(T)` at every degree; forced depths; genus-0 C14 branch dead (0 of 2674) |
| `DEPTH_TABLE_GENERAL` | closed keep-pass: 0 deaths, 22 live at dim `≤ 37`; period histograms |
| `D35_AUDIT/results/patterns_r5_content_p331.json` | the 22 ids / `content_hash` / `sealed_hash` |
| `GLOBAL_COHERENCE/results/vectors_d35.json` | the six-factor immune menus, uncollapsed |

Two different words named “depth” appear in the inputs and are never mixed:
`L12` depths are blowup depths of point-towers over `C11`-points;
`DEPTH_TABLE_GENERAL` depths are jet levels on the σ-rows.

---

## 2. The 22 cells

Identity is by `content_hash` at `p = 331` (HANDOFF).  The three sealed
lists agree:

```
id    content_hash_p331   sealed_hash_p331
  5   1c9110f65f5bbba3    2955f30c0593ff1d
  7   3150d84bef191573    29bd5a4e397c0790
 13   3618971b26ff55c3    2c7513acc00d7368
 15   3f5a2ac32819ba6f    2f9b8e8ba5ba6288
 21   4719753a11bf778e    337226b957ffdc34
 23   5a83d267319fa23e    6635c24184e4be43
 29   60e0986d49bee8f8    6ae7ffa6dbd79c50
 31   6250d74a687cb983    6fb4d2d4d5a56413
 37   6d86d9d5001c7e2e    88ca456f7d4537e6
 39   936cc3c107447118    8b6af44c6a58b736
 45   9b53e234676b5956    a51f1461a34945c2
 47   a604f5628e9236ba    a6a8ab1ae0fdfe22
 53   b55e098db7f81575    aac84803b75ad54e
 55   bbb7766320c5cd5a    b357be64b49d4511
 61   c1aa082c6d18a709    bdbc702f4f11afa8
 63   cc5dcc73af916c94    be7f55ce39e664a6
 69   cda89047957f1b38    c197d9761918cc70
 71   d0d84b4f9163e092    cbc5e8bf02feaf22
697   db1cfded50b57ffb    d743d7a4fc7d0414
699   f3d6a4eaa956f29f    e87fb26421304593
701   f728b33a2e34714b    f24058be9349945b
703   fcf626911737b157    f2639db1fe05652f
```

All 22 carry the same σ-band:
`m_options_L = [35]`, `m_options_P = [1]`,
`a35_L = (35, 0)`, `a35_P = (34, 1)`, `min_m = max_m = 1`,
group key `0bbfc90a9b60` at `p = 331`.  So
`ord_{L'_σ}(T) = 0` (minus-line not in the base locus) and
`ord_{P_σ}(T) = 1`.

They sit in one shared 37-dimensional candidate cell.  The closed
keep-pass of `DEPTH_TABLE_GENERAL` kills 0 of them at both primes.

**FLAG (hygiene, not a fiber constraint).**
`keep_pass_22_p331.json` has the same 22 ids and the same
`content_hash` / `sealed_hash` *sets*, but the three fields are not
synchronously paired with D35_AUDIT.  This packet keys cells by the
D35_AUDIT / SMITH / STEIN pairing (those three agree).  The keep-pass
verdict is uniform (LIVE, dim `≤ 37`) so the intersection does not
depend on the pairing.

---

## 3. Menus are menus

There is no cell → menu-subset linkage in the sealed record
(`SMITH_I3` §7.2).  The full product is admissible for every cell:

```
F_odd(35) = C11:10 × C5a:4 × C5b:4 × D10:4 × A4a:238 × A4b:238
          = 36 252 160
22 × 36 252 160 = 797 547 520 (cell, menu-entry) pairs.
```

Factoring the report is not collapsing a menu: every entry of every
factor is listed in `results/`, and `covered × free = F_odd(35)` holds
by construction of the product.

The ten `C11` vectors of `vectors_d35.json` are the same set as the
SMITH μ-table, in a different order.  Both orders are kept.  μ is
attached by exact vector match:

| μ | defined rows `c=3,5,6,7` | # defined | forced depth |
|--:|---|--:|--:|
| 1 | –, `e(1)`, –, `e(3)` | 2 | 3 |
| 2 | –, –, –, – | 0 | 3 |
| 3 | `e(5)`, –, `e(3)`, – | 2 | 3 |
| 4 | –, `e(5)`, `e(9)`, – | 2 | 3 |
| 5 | –, –, `e(4)`, `e(9)` | 2 | 3 |
| 6 | `e(3)`, `e(4)`, –, `e(5)` | 3 | 4 |
| 7 | –, `e(9)`, `e(5)`, `e(1)` | 3 | 5 |
| 8 | `e(9)`, `e(3)`, –, – | 2 | 3 |
| 9 | `e(1)`, –, –, `e(4)` | 2 | 4 |
| 10 | `e(4)`, –, `e(1)`, – | 2 | 3 |

Maximum defined is 3, never 4 (STAGE2 Thm 2.1, independently reproduced
by SMITH and L12).  The 64 `C5` triples all deposit `n_x = (5,5,5,5)`.
The 238 + 238 A4 vectors are stored uncollapsed in
`results/a4_vectors.json`.

---

## 4. Invariants the sealed results constrain

| id | invariant | joint constraint |
|---|---|---|
| `BS_C11_ALL_DEGREES` | base locus at the 60 `C11`-points | all 60 lie in `Bs(T)` at every degree (L12, genus-free) |
| `ORD_L_ZERO` | order on the minus-line | `= 0` (not a base point) |
| `ORD_P_ONE` | order on the plus-plane | `= 1` |
| `CHI_TOP_C11` | `χ_top` at the five `C11`-points | `≡ 4 (mod 11)`, five values EQUAL; `n_x = 4` on `Z`; constant on all 10 `C11` entries |
| `CHI_TOP_C5` | `χ_top` at the four `C5`-points | `≡ 0 (mod 5)`; `n_x = 5` on `Z`; constant on all 64 triples |
| `CHI_TOP_E_SIGMA` | generic fibre over `E^X_σ` | `≡ 0 (mod 2)` on the closed branch; irrational-stratum escape carried |
| `CHI_TOP_L_SIGMA` | generic fibre over `L^X_σ` | PARAMETRIC |
| `CHI_TOP_C3` | fibre at the six `C3`-points | PARAMETRIC in the 56 644 A4 entries |
| `CHI0_SINGLE` | coherent `χ(O_fibre)` on the 1-dimensional-fibre locus | one integer `χ₀` (miracle flatness) |
| `CHI0_MOD_55` | that integer, smooth-fibre row | `χ₀ ≡ 35 (mod 55)` (in-packet CRT of `2χ₀ ≡ 4 (mod 11)` and `2χ₀ ≡ 0 (mod 5)`) |
| `STEIN_DICHOTOMY` | genus vs Stein degree | `χ₀ ≤ −20` ⇒ connected genus `≥ 21`; or `χ₀ ≥ 35` ⇒ Stein degree `s ≥ 35` |
| `GENUS0_C14_DEAD` | C14 genus-0 branch at order 11 | DEAD: 0 of 2674 towers (extended); 0 of 1540 at depth `≤ 3` |
| `C11_FORCED_DEPTH` | blowup depth over every `C11`-point | `≥ 3`; `≥ 4` for `μ ∈ {6,9}`; `≥ 5` for `μ = 7` |
| `PIN_AND_J1` | invariant divisors on `X` | degrees exactly `{k ≥ 5}`; PIN forces the pinned points unless `11 \| k` / `5 \| k`; miss-all needs `deg ≥ 55`; unique quintic is `det Hess F` |
| `KEEP_PASS_CLOSED` | σ-row jet keep-pass | 0 closed deaths; dim `≤ 37` |
| `CELL_DIM` | ambient cell | one shared 37-cell |

The CRT is recomputed here: `2^{-1} ≡ 6 (mod 11)` sends `4` to `2`;
`2^{-1} ≡ 3 (mod 5)` sends `0` to `0`; the unique class mod 55 is 35.
Then `χ₀ = 35 + 55k` is `≤ −20` for `k ≤ −1` and `≥ 35` for `k ≥ 0`.
Connected smooth genera solving both Riemann–Hurwitz congruences
`g ≡ 10 (mod 11)` and `g ≡ 1 (mod 5)` start at `21, 76, 131, 186, …`.
The C11-alone menu starts at `g = 10`; the joint menu kills `g = 10`.
That is an intersection tightening, not a cell death.

Sharp `χ₀` numbers live in the zero-defect (smooth, 1-dimensional, nine
pinned points, terminus `Z`) row.  The defect form
`2χ₀ + D_x − 2χ(N_x)` is carried and is not collapsed onto `2χ₀`.

---

## 5. Per cell: what a surviving map must look like

The fiber-structure verdict is **identical on all 22 cells**.  That is a
result: the 22 are σ-band data with no `C11` token, the Smith / Stein /
L12 inputs are cell-independent, and there is no cell-to-menu linkage.

A surviving degree-35 map on any of the 22 **must**:

1. Vanish at all 60 order-11 points, and not vanish on the minus-line,
   and vanish simply on the plus-plane.
2. Resolve the order-11 vanishings to blowup depth at least 3 (4 if the
   `C11` label is 6 or 9; 5 if the label is 7).
3. Have `χ_top ≡ 4 (mod 11)` at each of the five order-11 points, the
   five values equal, and `χ_top ≡ 0 (mod 5)` at each of the four
   order-5 points.
4. If those nine fibres are ordinary curves: carry a single `χ₀ ≡ 35
   (mod 55)`, hence either connected fibres of genus `≥ 21` or a Stein
   factor of degree `≥ 35`.
5. Not be the C14 genus-0 branch (0 of 2674 towers).
6. Live in the shared 37-cell, where the closed keep-pass is already
   satisfied.

Both Stein branches remain live in every STEIN ledger row.  Order-2
over `L^X_σ` and order-3 stay parametric.  Three-dimensional fibres stay
FLAGGED as in STEIN §7.2.

Per-`C11`-entry census at depth `≤ 3` (L12 json, uncollapsed):

| μ | towers | genus-0 PASS | integral | C7 menu PASS | forced depth |
|--:|--:|--:|--:|--:|--:|
| 1 | 21 | 0 | 1 | 0 | 3 |
| 2 | 1134 | 0 | 85 | 0 | 3 |
| 3 | 90 | 0 | 8 | 0 | 3 |
| 4 | 126 | 0 | 11 | 0 | 3 |
| 5 | 30 | 0 | 3 | 0 | 3 |
| 6 | 3 | 0 | 0 | 0 | 4 |
| 7 | 7 | 0 | 0 | 0 | 5 |
| 8 | 90 | 0 | 7 | 0 | 3 |
| 9 | 9 | 0 | 0 | 0 | 4 |
| 10 | 30 | 0 | 3 | 0 | 3 |
| | **1540** | **0** | **118** | **0** | |

`μ ∈ {6,7,9}` have no integrality survivor at depth `≤ 3` because none
is allowed: `R ≡ 0` is first reachable at the forced depth.  Consistent,
not a kill.  Extended scope (L12 director adjudication): 2674 / 226 / 0 / 0.

---

## 6. Contradiction scan — FLAG, never claimed

A KILL is an empty intersection of sealed constraint sets.  The scanner
checks, per cell and per menu entry:

* genus-0 is dead, but nothing *requires* genus 0;
* the Stein dichotomy is an OR, not an AND;
* `g = 10` dies by CRT, not by a cell dying;
* empty integrality at `μ ∈ {6,7,9}` sits strictly below the forced depth;
* no row of the 22 × 10 `C11` table or the 64 `C5` table is empty.

**Result: `n_flagged_kills = 0`, `claimed_kills = 0`,
`ODDZERO_audit_triggered = false`.**

Recorded FLAGS, not claims:

1. **FLAG-M near-kill.**  0 of 118 (depth `≤ 3`) and 0 of 226 (extended)
   integrality survivors lie in the smooth-fibre C7 trace menu.  Against
   STEIN’s smooth 1-dimensional row this is a near-kill of that *row* at
   the enumerated tower scope.  L12 states it is a model-dependent menu
   verdict (FLAG-M, FLAG-P, TIER B), not a closed death.  The
   leading-order obstruction saturates at depth `≥ 4`.  Not a cell death
   and not a degree exclusion.
2. **STEIN window miss.**  The `χ₀ = 35` C5 witness is absent from a
   bounded enumeration window that the source labels as a window, not an
   impossibility.
3. **keep-pass pairing hygiene**, §2.

No ODDZERO-standard audit is triggered: the outcome is not an all-22
death and not a degree exclusion.

---

## 7. Plain-language paragraph

If a degree-35 landing map exists, it must vanish at all sixty
order-11 points of the Klein cubic, and those vanishings cannot be
resolved in fewer than three blowups (four blowups when the order-11
menu label is 6 or 9; five when the label is 7).  Over each of the five
order-11 points the topological Euler characteristic of the fiber is
the same integer, congruent to 4 modulo 11; over each of the four
order-5 points it is divisible by 5.  When those nine fibers are
ordinary curves they all share one coherent Euler characteristic
`χ₀` congruent to 35 modulo 55: either every such fiber is a connected
curve of genus at least 21, or the map factors through a cover of
degree at least 35.  The genus-0 fiber branch is already ruled out
(none of 2674 resolution towers survive it).  The map does not vanish
along the distinguished minus-line, and it vanishes simply along the
distinguished plus-plane.
None of these requirements, taken together, empties any of the 22
remaining candidate cells, and no degree is excluded.

---

## 8. Not claimed

* **No headline.**  Problem E remains **OPEN**.  This packet **excludes
  no degree** and cuts **none** of the 22 cells.
* No claimed contradiction, no claimed cell death, no claimed
  all-22 death.  FLAG-M is not a kill.
* No claim that the fibres are connected, or disconnected.  Both
  branches stay live.
* No claim that the sharp `χ₀` numbers hold for singular, non-reduced,
  or higher-dimensional fibres.
* No claim of an all-depth genus-0 death (L12 proves the leading-order
  obstruction saturates at depth `≥ 4`).
* No claim that a degree-55 invariant divisor missing every pinned
  point exists.
* No new census, no `F_odd` / `G` recount, no transport-pairing claim,
  no correction of any sealed number except the recorded keep-pass
  pairing hygiene FLAG.
* No git operation; nothing outside this packet directory was written.

---

## 9. Honesty tiering

| item | tier | basis |
|---|---|---|
| 22-cell identity, AUDIT/SMITH/STEIN pairing | **A** | three sealed lists agree byte-for-byte |
| uncollapsed `F_odd(35)` product | **A** | re-read `vectors_d35.json` |
| Smith `χ_top` congruences, σ-band | **A** | sealed SMITH_I3 |
| `χ₀ ≡ 35 (mod 55)` CRT | **A** | exact in-packet |
| joint genera `21 + 55ℤ` | **A** | exact |
| forced depths 3 / 4 / 5 | **A** | L12 `min_extra_depth_for_R0 + 1` |
| genus-0 C14 death, 0 of 2674 | **A within scope** | sealed L12 (extended scope) |
| keep-pass 0 deaths, dim `≤ 37` | **two-prime finite exact** | DEPTH_TABLE_GENERAL |
| emptiness scan, no claimed kill | **A** | mechanical |
| FLAG-M smooth-trace near-kill | **B / FLAG** | L12 TIER B, FLAG-M, FLAG-P |
| any degree exclusion | **not claimed** | — |

---

## 10. Replay

```sh
cd goal_runs_20260812/CELL_SYNTHESIS
python3 scripts/assemble.py    # writes results/*.json
python3 verifier.py            # 79 checks -> results/verifier_output.json
# expect: CELL_SYNTHESIS_VERIFY_OK / ALLGREEN
```

| group | n | covers |
|---:|---:|---|
| **A** | 24 | 22-cell identity, three-packet pairing, shared σ-band, uncollapsed six-factor menus, `F_odd` product, 797 547 520 pairs, A4 sha, no cell-to-menu linkage |
| **B** | 29 | every sealed constant consumed: Smith `n_x`, Stein `χ₀` / dichotomy / ledger, L12 json totals and per-μ zeros, L12 THEOREM 2674 / 226, keep-pass both primes, period histograms, AUDIT 756 = 336+398+22, keep-pass hash SET, pairing FLAG |
| **C** | 26 | CRT, joint genera, forced depths, per-row emptiness, 22 identical must-look-like, no claimed kill, headline, plain paragraph, `g = 10` vs `g = 21`, no `REPORT.md` |

Artefacts: `results/synthesis.json`, `identity.json`, `menus.json`,
`per_c11_menu.json`, `per_c5_menu.json`, `per_cell_verdicts.json`,
`invariants.json`, `contradiction_scan.json`, `a4_vectors.json`,
`plain_paragraph.txt`, `verifier_output.json`, `verifier_stdout.txt`.

## 11. Dependencies consumed as sealed

`HANDOFF_2026-08-12.md`;
`goal_runs_20260812/SMITH_I3`;
`goal_runs_20260812/STEIN_LERAY`;
`goal_runs_20260812/L12_ORDER11` (including the director adjudication:
extended scope 2674 / 226);
`goal_runs_20260812/DEPTH_TABLE_GENERAL`;
`goal_runs_20260811/D35_AUDIT` (`patterns_r5_content_p331.json`);
`goal_runs_20260811/GLOBAL_COHERENCE` (`vectors_d35.json`);
`goal_runs_20260811/ODDZERO_AUDIT/REGISTRATION_SNIPPET.md` (registration
format).

No unverified external mathematics enters any claim.  The only
in-packet derivation is the CRT for `χ₀ (mod 55)` and the emptiness
scan of already-sealed constraint sets.
