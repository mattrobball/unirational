# SMITH_ORDERS_23 — the two parametric Smith branches against χ₀ and L12

**Packet:** `goal_runs_20260812/SMITH_ORDERS_23/` · opened 2026-08-12.
**Headline: Problem E remains OPEN; this packet excludes no degree.**

The two branches `SMITH_I3` left parametric — order 2 over `L^X_σ` (widened
by the referee to include unforced dominating rows) and the whole of order 3 —
are reconstructed from that packet and its `REFEREE_REPORT.md`, then tested
against the seals that landed after it: `STEIN_LERAY` (the `χ₀ ≡ 35 (mod 55)`
dichotomy, Proposition PIN, invariant divisor degrees exactly `{k ≥ 5}`) and
`L12_ORDER11` (all 60 order-11 points based at every degree, forced tower
depths, genus-0 branch dead).

*(Filename note: main document is `THEOREM.md`; the harness refuses
`REPORT.md`.)*

## Exit ledger

```text
SMITH-O23-BRANCHES-RECONSTRUCTED
SMITH-O23-CRT-GAP
SMITH-O23-LOCUS-L-NOT-IN-U
SMITH-O23-LOCUS-C3-SURFACES-NOT-IN-U
SMITH-O23-CHI0-DOES-NOT-PIN
SMITH-O23-L12-NO-ORDER23-PIN
SMITH-O23-ORDER2-L-STILL-PARAMETRIC
SMITH-O23-ORDER3-STILL-PARAMETRIC
SMITH-O23-ESCAPE-STILL-LIVE
SMITH-O23-NO-DEGREE-EXCLUSION
```

Machine markers: `SMITH_ORDERS_23_VERIFY_OK` / `ALLGREEN`
(`python3 verifier.py` — **60 checks, 0 failures, 0 skips**; groups
A = 16, B = 18, C = 26). Exact integer arithmetic; python3 standard library
only; no git; nothing outside this packet directory was written.

---

## 0. What is and is not claimed

**Claimed.** (i) An exact reconstruction of the two open `SMITH_I3` branches,
including the director-adopted S4 widening of the `L^X_σ` display. (ii) The
CRT fact: `χ₀ = 35 + 55k` does not determine `2χ₀ (mod 3)` on either branch
of the Stein dichotomy. (iii) The locus fact: `L^X_σ ∩ U = ∅`, and the
receiver points of the two `C3`-surfaces lie outside `U`. (iv) The joint
verdict: neither post-I3 seal pins the two parametric Smith branches.
(v) The exact remaining unknowns, named.

**Not claimed.** See §8. In particular nothing here cuts any of the 22 live
`d = 35` cells and no degree is excluded. No numeric order-2 or order-3
congruence is claimed. No exclusion is claimed; none is flagged for an
ODDZERO audit, because nothing here returns a zero or an all-dead outcome.

---

## 1. Reconstruction of the two open branches

Consumed by citation from `goal_runs_20260812/SMITH_I3` (THEOREM.md including
the director corrections, `REFEREE_REPORT.md` S3–S4, `results/f2f3_congruences.json`).
Re-read by the verifier (group A).

### 1.1 What SMITH_I3 closed (not reopened here)

At each of the five `C11`-points of `X`, `χ_top(q^{-1}(x)) ≡ 4 (mod 11)` and
the five values are equal; `n_x = 4` on the terminus `Z`; F3 closes
`5·4 = 20 = χ(Z^{C11})`. At each of the four `C5`-points,
`χ_top ≡ 0 (mod 5)`; `n_x = 5` on `Z`; F3 closes `4·5 = 20`. Both are constant
across the full `F_odd(35) = 36 252 160` menu and all 22 cells.

### 1.2 Order 2 — one branch closed, one parametric (widened)

`X^σ = E^X_σ ⊔ L^X_σ` with `χ = 0 + 2 = 2`. `Z^σ` has
`{0: 146, 1: 80, 2: 11, 3: 2}` components for one fixed involution.

**Over `E^X_σ` — CLOSED on `Z` and on admissible refinements.** Lemma R: no
rational component of `Z^σ` dominates the genus-1 curve `E^X_σ` (`j = 8192/11`,
non-CM). Smith at `p = 2` therefore gives `χ(q^{-1}(x)) ≡ 0 (mod 2)` for all
but finitely many `x ∈ E^X_σ`.

**The named escape, still live.** A `σ`-fixed *irrational* stratum dominating
`E^X_σ`. Group G forces some irrational centre, so the escape is not
hypothetical. Both branches are carried; neither is claimed shut.

**Over `L^X_σ` — PARAMETRIC, widened.** `STAGE1_COMPLEX_MAPS` Theorem 3 forces
three rows onto `L_σ`:

* `D_{P_σ} ≅ P(W⁺) × P(W⁻)` (dim 3, 55 components),
* `D_{L⁻_σ} ≅ P(W⁻) × P(W⁺)` (dim 3, 55 components),
* the central-involution line in `E_{pt_{D12}}` (dim 1, 55 components).

No other row is *forced* non-constant. The referee (S4, adopted) widened the
display: Theorem 3 does not forbid further unforced `σ`-fixed dominating rows.
For generic `x ∈ L^X_σ`,

```
   χ(q^{-1}(x))  ≡  χ(F_1) + χ(F_2) + n_3 + Σ_j χ(F_j)   (mod 2),
```

with `F_1, F_2` the generic fibres of the two divisorial rows, `n_3` the degree
of the third row, and the sum over any further unforced dominating rows.
No sealed `d = 35` bound pins any of these (`C1` is a genus *identity*).
All 22 cells share the same `σ`-band: `ord_{L'_σ}(T) = 0`, `ord_{P_σ}(T) = 1`.

**F3 at order 2 is not closable** from the census: the 11 surfaces and 2
threefolds of `Z^σ` have unpinned Euler characteristics.

### 1.3 Order 3 — fully parametric

`X^{C3}` = 6 isolated points (`χ = 6`). `Z^{C3}` has
`{0: 62, 1: 16, 2: 2}` components for one fixed `C3`. Every component is
contracted to one receiver point. The 16 curves are rational, hence `P¹` with
`χ = 2`. The two surfaces have `χ = 2 + b_2` with `b_2` **not** pinned: the
census tag is a *birational* model (`P¹ × P¹` for the `C3line` surfaces), and
`TERMINUS_STRATA_PW` Theorem 3 states the closure is that product *up to the
later blowups it undergoes*. Hence

```
   χ(Z^{C3})  =  62 + 32 + χ(S_1) + χ(S_2)  =  94 + χ(S_1) + χ(S_2),
   χ(S_i) ≥ 3,
```

and the six mod-3 congruences are parametric in that split. The
`A4a × A4b` menu (`238 × 238 = 56 644`) is classified by receiver labels;
nothing numeric is claimed.

---

## 2. What has been sealed since SMITH_I3

### 2.1 STEIN_LERAY (consumed, not re-derived)

On the open locus `U = {x ∈ X : dim q^{-1}(x) = 1}`, miracle flatness makes
`χ(O_{q^{-1}(x)})` one integer `χ₀` (Lemma FL). The Smith inputs at the nine
pinned points (`n_x = 4` at `C11`, `n_x = 5` at `C5`, read on `Z`) plus the
bridge `χ_top = 2χ(O) + D − 2χ(N)` give, in the *smooth* row `D = N = 0`,

```
   2χ₀ ≡ 4 (mod 11)    and    2χ₀ ≡ 0 (mod 5)    ⇒    χ₀ ≡ 35 (mod 55).
```

Dichotomy: `χ₀ ≤ −20` (connected: genus `≥ 21`) or `χ₀ ≥ 35` (Stein degree
`s ≥ 35`). Scope, stated by that packet and respected here: nine pinned
points 1-dimensional, smooth fibres, `n_x` read on `Z`. On a 2-dimensional
fibre `χ₀` does not bind; 3-dimensional fibres are FLAGGED.

Proposition PIN: a `G`-invariant divisor of degree `k` on `X` contains all
five `C11`-points unless `11 | k` and all four `C5`-points unless `5 | k`;
missing every pinned point forces `55 | k`. The unique degree-5 invariant
divisor is `{det Hess F = 0} ∩ X` and contains every `C11`-point and no
`C5`-point. Invariant divisor degrees on `X` are exactly `{k ≥ 5}`.

### 2.2 L12_ORDER11 (consumed, not re-derived)

All 60 `C11`-points lie in `Bs(T)` at every degree (QR half dies by algebraic
integrality of the localization-forced fibre trace). Forced resolution depth
over every `C11`-point at `d = 35`: `≥ 3` (`≥ 4` for `μ₁ ∈ {6,9}`, `≥ 5` for
`μ₁ = 7`; point-blowup towers, FLAG-P). The genus-0 fibre branch is dead
through the extended tower scope (0 of 2674). L12 itself records that
orders 5, 3, 2, 6 are untouched. On a further model `n_x = 4 + Δ/5`.

---

## 3. The CRT gap — `χ₀ ≡ 35 (mod 55)` does not determine `χ_top (mod 3)`

Write `χ₀ = 35 + 55k`. Then `2χ₀` is always even, and

```
   2χ₀  =  70 + 110k  ≡  1 + 2k   (mod 3).
```

As `k` runs, `1 + 2k` takes all three residues mod 3. The same holds when
`k` is restricted to either dichotomy branch (`k ≤ −1` for A, `k ≥ 0` for B):

| `k` | `χ₀` | `2χ₀` | `2χ₀ mod 3` | branch |
|---:|---:|---:|---:|---|
| −3 | −130 | −260 | 1 | A (`g = 131`) |
| −2 | −75 | −150 | 0 | A (`g = 76`) |
| −1 | −20 | −40 | 2 | A (`g = 21`) |
| 0 | 35 | 70 | 1 | B (`s ≥ 35`) |
| 1 | 90 | 180 | 0 | B |
| 2 | 145 | 290 | 2 | B |

Pinning `2χ₀ (mod 3)` would require `χ₀` mod `165 = 55·3`. The sealed
constraint does not supply that. Independently, `2χ₀` even makes Smith at
`p = 2` tautological on `U` in the smooth row: it does not evaluate
`χ(F_1) + χ(F_2) + n_3 + Σ χ(F_j)`.

---

## 4. The locus obstruction — `χ₀` does not bind where the unknowns live

`U` is the locus of *1-dimensional* fibres. Lemma FL and the joint menu apply
only on `U`.

**`L^X_σ ∩ U = ∅`.** Theorem 3 puts two 3-dimensional rows onto the curve
`L^X_σ`. A 3-fold mapping onto a curve has generic fibre dimension 2. So for
generic `x ∈ L^X_σ`, `dim q^{-1}(x) ≥ 2`. STEIN_LERAY's own dim-2 menu says
`χ₀` does not bind there. The order-2 `L`-display is therefore not a
constraint on the integer `χ₀`.

**The two `C3`-surfaces put their receiver points outside `U`.** `X^{C3}` is
finite, so every component of `Z^{C3}` is contracted to one of the six points.
A surface contracted to a point gives fibre dimension `≥ 2` at that point.
Those 1 or 2 of the 6 `C3`-points lie in `X \ U`. `χ₀` does not bind there,
which is exactly where `χ(S_i)` is charged.

(The remaining `C3`-points *might* lie in `U`. Even then the CRT gap of §3
prevents a numeric mod-3 residue.)

---

## 5. What L12 and PIN do not spend on these branches

* All 60 `C11`-points based is already the STEIN_LERAY pinning. It does not
  evaluate `χ(F_i)` or `χ(S_i)`.
* Forced depths `≥ 3` mean the actual model is a refinement of `Z`, so
  `n_x = 4 + Δ/5` and the residue `χ₀ ≡ 35 (mod 55)` is *Z-scoped*. That
  moves the joint constraint; it does not pin order 2 or 3.
* The genus-0 death (0 of 2674) is at order 11. On `U` it is consistent with
  the dichotomy (`χ₀ = 1` and `χ₀ = 2` are not `35 (mod 55)`), already
  recorded by STEIN_LERAY. It does not evaluate the order-2/3 unknowns.
* PIN and J1 constrain `G`-invariant *divisors on `X`*. The order-2 escape is
  a source stratum dominating a curve; the order-3 unknowns are Euler
  characteristics of source surfaces. Neither is a divisor-degree question.

---

## 6. Verdict

**Neither post-I3 seal pins the two parametric Smith branches.**

| branch | SMITH_I3 status | after STEIN_LERAY + L12 |
|---|---|---|
| order 2, `E^X_σ` | closed `≡ 0 (mod 2)` on `Z` and admissible refinements | unchanged |
| order 2, escape | live (irrational `σ`-fixed stratum) | still live |
| order 2, `L^X_σ` | parametric, widened | still parametric (`L ⊄ U`; CRT tautological at `p = 2`) |
| order 2, F3 | not closable (`χ` of 11 surfaces + 2 threefolds) | still not closable |
| order 3 | parametric in `χ(S_1), χ(S_2)` | still parametric (CRT + surfaces off `U`) |

What would close them, still: promote the `t2_strata.txt` per-component
models to actual closures (the remainder `SMITH_I3` §7.3 already named), or
run the wonderful-blowup delta over the 14-orbit centre inventory.

---

## 7. Flags

### 7.1 The joint menu is conditional and Z-scoped

`χ₀ ≡ 35 (mod 55)` assumes the nine pinned points lie in `U`, smooth fibres,
and `n_x = 4, 5` on `Z`. L12's forced depths make the actual model a
refinement; the residue may move. Nothing in this packet assumes those
hypotheses in order to claim a pin — the CRT and locus facts show that even
*under* them the order-2/3 data stay free.

### 7.2 Census models are not isomorphism types

The `C3line` surfaces are tagged `P¹ × P¹`. `TERMINUS` Theorem 3 says this is
the product *up to later blowups*. Promoting that tag to `χ = 4` would be a
judgement call; it is not made. Same for the two dim-3 `σ`-divisors
(`P² × P¹`).

### 7.3 Zero / all-dead audit

Nothing here returns a zero or an all-dead outcome (check `C20`/`C26`): 22
cells stay live, both Stein branches stay live, both parametric Smith
branches stay parametric, `n_x = 4` and `n_x = 5` stay positive. No
ODDZERO-standard audit is triggered; none is claimed.

---

## 8. Not claimed

* **No headline.** Problem E remains **OPEN**. This packet **excludes no
  degree** and cuts **none** of the 22 live `d = 35` cells.
* No numeric order-2 congruence over `L^X_σ`. No numeric order-3 congruence
  at any of the six points. No value of `χ(Z^σ)` or `χ(Z^{C3})`.
* No claim that the escape over `E^X_σ` is dead, or that it is forced.
* No claim that `L^X_σ` or any `C3`-point *must* have 2-dimensional fibres on
  every model — only that on the terminus, Theorem 3 and the two `C3`-surfaces
  force that on `Z`. Further models can add components; they cannot drop the
  existing dim-2 pieces coming from those rows while those rows still dominate.
* No claim that PIN, J1, or the Hessian quintic constrain `χ(F_i)` or `χ(S_i)`.
* No transport of the `d = 35` genus-0 death, no correction of any sealed
  number, no `F_odd` recount.
* No git operation; nothing outside this packet directory was written.

---

## 9. Remaining unknowns (exact)

1. `χ(F_1)`, `χ(F_2)`, `n_3`, and `χ(F_j)` for unforced `σ`-fixed rows
   dominating `L^X_σ`.
2. Whether a `σ`-fixed irrational stratum dominates `E^X_σ`.
3. `χ(S_1)`, `χ(S_2)`, and the assignment of the 80 `Z^{C3}`-components to
   the 6 receiver points.
4. Euler characteristics of the 11 surfaces and 2 threefolds of `Z^σ`.
5. Whether generic points of `E^X_σ`, or any `C3`-point that does not receive
   a surface, lie in `U`.
6. Bridge defects `D(F)`, `χ(N_F)` on non-smooth fibres.
7. Stein degree `s`.
8. The refinement delta `Δ` at `C11` (`n_x = 4 + Δ/5`).

---

## 10. Verification

```sh
python3 scripts/produce.py    # writes results/audit.json
python3 verifier.py           # 60 checks -> results/verifier_output.json
```

| group | n | covers |
|---|---:|---|
| **A** | 16 | reconstruction of both SMITH_I3 branches, the S4 widening, the census counts, `n_x = 4, 5` on `Z`, the 22 × `F_odd` bookkeeping |
| **B** | 18 | every post-I3 seal consumed: `χ₀ ≡ 35 (mod 55)` and its hypotheses, dim-2/dim-3 flags, J1, PIN, L12's 60 base points / 0-of-2674 / forced depths / "orders 2 and 3 untouched", STAGE1 Theorem 3, the TERMINUS dictionary and blowup-not-iso wording |
| **C** | 26 | the CRT table (both dichotomy branches hit all three residues mod 3; `2χ₀` always even; modulus 165 would be needed), the locus facts, the verdict (both branches still parametric, escape live, no exclusion, eight named unknowns) |

Artifacts: `results/audit.json`, `results/verifier_output.json`,
`results/verifier_stdout.txt`.

## 11. Dependencies consumed as sealed

`goal_runs_20260812/SMITH_I3` (THEOREM.md incl. director corrections,
`REFEREE_REPORT.md` S3–S4, `results/f2f3_congruences.json`);
`goal_runs_20260812/STEIN_LERAY` (THEOREM.md, `results/menus.json`
`JOINT_flat_smooth`, `results/pinned_points.json`);
`goal_runs_20260812/L12_ORDER11` (THEOREM.md director adjudication);
`goal_runs_20260810/STAGE1_COMPLEX_MAPS` (Theorem 3);
`goal_runs_20260810/TERMINUS_STRATA_PW` (Theorem 3; `results/t2_strata.txt`
DICTIONARY);
`theory/SCHEME_MAP_CONSEQUENCES_20260812.md` §3.2 (F2/F3);
`HANDOFF_2026-08-12.md` (campaign state).

External-classical imports, named: Smith theory (via SMITH_I3), miracle
flatness / Lemma FL (via STEIN_LERAY), Lüroth (via SMITH_I3 Lemma R). No
unverified external mathematics enters any claim.

## Honesty tiering

| tier | content |
|---|---|
| `[T1]` complete argument here | the CRT gap; the locus facts (dim 3 onto a curve ⇒ generic fibre dim 2; surface onto a point ⇒ fibre dim 2); the non-implication "χ₀ ≢ a pin of the two branches" |
| `[T2]` machine-verified, exact | reconstruction of the sealed SMITH_I3 / STEIN_LERAY / L12 / STAGE1 / TERMINUS inputs; the CRT table over `k ∈ [−12, 12]`; the 60-check verifier |
| `[T3]` stated with an explicit gap | membership of generic `E^X_σ` in `U`; the value of `Δ`; anything about a further model that *drops* a dominating row (not claimed) |
| `[EXT]` via sealed packets | Smith, miracle flatness, Lüroth, Kempf (unused here) |
