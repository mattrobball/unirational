# L12, order 11: the global localization identity, machine-instantiated

**Packet:** `goal_runs_20260812/L12_ORDER11/` · opened 2026-08-12.
**Executed against:** `DATA_SPEC_PIPELINE_FLUSH_20260812.md` Lane 3,
`WORKORDER_L12_ORDER11.md`, and
`theory/GLOBAL_LOCALIZATION_LEDGER_20260812.md` **including its §8**.

> # Headline: Problem E remains OPEN; this packet excludes no degree.

*(Filename note: main document is `THEOREM.md`; the harness refuses
`REPORT.md`.)*

Machine markers: `L12_ORDER11_VERIFY_OK` / `ALLGREEN`
(`python3 verifier.py` — **93 checks, 0 failures**). Exact `Q(ζ₁₁)`
arithmetic on the power basis of `Φ₁₁` with `Fraction` coefficients; python3
standard library only; no floating point anywhere; no `gap`/`gp`/`sage`/
`magma`; no git.

## Exit ledger

```text
L12-O11-ANCHORS-PASS
L12-O11-CONVENTION-CORRECTION-FLAG-A
L12-O11-K0-SUMRULE-EVALUATED-CONSISTENT
L12-O11-K0-MODPI-CONTENT-EXACT
L12-O11-GENUS0-DEAD-DEPTH-LE-3
L12-O11-INTEGRALITY-GENUS-FREE-TEST
L12-O11-QR-MU0-BRANCH-DEAD-ALL-DEGREES
L12-O11-FORCED-BLOWUP-DEPTH
L12-O11-MENU-PASS-EMPTY-DEPTH-LE-3
L12-O11-LEMMA-U-DEPTH2-COUNTEREXAMPLE
L12-O11-MENU-REPRODUCED-FROM-THM12
L12-O11-NO-DEGREE-EXCLUSION
```

---

## 1. Conventions, pinned — and one correction to §8 (FLAG-A)

`g` of order 11 acts on `W` with eigenbasis `e₀..e₄`, `g e_i = ζ^{a_i}`. The
ledger writes `a` as "the QR set `(1,3,4,5,9)`". **The index ORDER is
load-bearing and is not free:** `F = Σ x_i² x_{i+1}` is `g`-semi-invariant iff
`2a_i + a_{i+1} ≡ c`, and `Σ a_i ≡ 0` forces `c = 0`, i.e.

```
        a_{i+1} = −2 a_i ,        a = (1, 9, 4, 3, 5)  (a_i = 9^i mod 11)
```

which is the same set, differently ordered. With this ordering `F` is
**invariant** (weight 0), `T_{e_j}X` has weights `a_k − a_j` for `k ∉ {j,j+1}`,
and the normal weight is `a_{j+1} − a_j = −3a_j` — reproducing `s2pin`'s
`forbidden_relative_weight(11,a) = −3a` on the nose. (`L12_REFEREE`'s R2
checks used the literal tuple `(1,3,4,5,9)`; they never test `F`-invariance,
so they do not see this. Nothing in R2's verdict changes.)

**FLAG-A (a correction to §8, machine-proved).** §8.1+§8.2 as *literally
written* pair the numerator `w_k(e_j) = ζ^{−k a_j}` (§3, explicitly reconfirmed
in R1) with the denominator `Π_{k'∉{j,j+1}}(1 − ζ^{a_{k'}−a_j})`. **That pair
is not a consistent Atiyah–Bott pair**: with it the `P⁴` total fails to equal
`χ_{Sym^k W*}(g)` for `k = 1,2,3` (anchor A6). Exactly one of the two signs
must flip. The two consistent completions are

```
 (A)  ζ^{−k a_j} / Π (1 − ζ^{a_j − a_{k'}})   =  χ_{Sym^k W*}(g)     [adopted]
 (B)  ζ^{+k a_j} / Π (1 − ζ^{a_{k'} − a_j})   =  χ_{Sym^k W }(g)
```

and (B) = `σ_{−1}`(A) (machine-checked), so **every PASS/FAIL verdict in this
packet is convention-independent**. (A) is adopted because the workorder's
fatal anchor is stated as `χ_{Sym^k W*}(g)`; (A) is also exactly the ledger's
§3 display, and (B) is exactly what R1's `P¹` calibration table computes. The
substance of the referee's R1 correction — *the denominator is a determinant
over the honest tangent weights, in one fixed sign convention on both sides* —
stands; only the sign pairing in the §8 display needs the fix.

## 2. The fatal anchors (36 checks, all green)

| anchor | statement | status |
|---|---|---|
| A0 | frame: QR weights, `a_{i+1} = −2a_i`, `F` invariant, `Σa ≡ 0`, normal `= −3a` | PASS |
| A1 | untwisted total on `P⁴` `= 1` | PASS |
| A5 | local blowup mass identity, 1320 blowups incl. **682 positive-dimensional fixed components** | PASS |
| A2 | untwisted total `= 1` after 12 arbitrary random test towers | PASS |
| A3 | `P⁴` twisted totals `= χ_{Sym^k W*}(g)`, `k = 0..6` | PASS |
| A4 | `X` twisted totals `= χ_{Sym^k W*}(g)` (`k=0,1,2`), `= χ_{Sym³W*}(g) − 1` (`k=3`) | PASS |
| A6 | the §8 convention audit above | PASS |

The `Sym^k W*` characters are recomputed here from scratch in `Q(ζ₁₁)` in the
conventions of `director_probes_20260811/molien_director.py`
(`χ_W(11A) = Σ_{q∈QR} ζ^q`); A4's `k = 3` shift is *derived* from the Koszul
sequence `0 → O(k−3) →^F O(k) → O_X(k) → 0` with `F` of weight 0.

## 3. Tower model and one structural finding (FLAG-T)

A tower node carries its tangent multiset and the Stage-2 value weight
`w = d a_k + Σ_l μ_l c_l`; it is **terminal** iff `w ∈ QR` (then `T` is defined,
the value is that eigenpoint, and every further exceptional fibre over it is
contracted — so its localization mass is already final). `N_G(C11) = C11:C5`
acts transitively on the five points, so the tower over `e_k` is the
`a_k`-multiple of the tower over `e_0` and its AB terms are the `σ_{a_k}`
images (machine-verified); everything is enumerated over `e_0` and transported.

**FLAG-T / `L12-O11-LEMMA-U-DEPTH2-COUNTEREXAMPLE`.** `SMITH_I3` Lemma U(a)
argues that a blowup tower keeps *pairwise distinct* tangent weights, hence a
finite `C11`-fixed locus, at every stage. **This fails at depth 2.** Example:
over `e₀` (weight 1) in the direction of `e₃` (weight 3) the level-1 tangent
multiset is `(2, 6, 1, 2)` — the weight 2 is repeated, and blowing that point
up produces a fixed `P¹`, not four isolated points. Since `d = 35` forces
depth `≥ 2` this is on the live branch. Consequences: (i) Lemma U(a)'s
induction needs repair (Lemma U(b), constancy of `n_x`, is untouched and is
independently *reproduced* here: `n_x` came out equal at all five receiver
points in **every** one of the 1540 towers); (ii) the localization must carry
positive-dimensional components. It does: `ab_component` implements the
characteristic-class integral over `P^{m−1}` and it satisfies the exact mass
identity in all 1320 tested blowups.

## 4. The `k = 0` sum rule (§8.4) — EVALUATED, CONSISTENT

`Σ_j (tr_j − 1)/D_j = 0`, `tr_j = χ_g(Z_{e_j}, O)` (derived fibre, flag 5).
Proved and machine-checked (21 checks):

* `v_π(D_j) = 3` and `D_j = π³δ_j` with `δ_j` a unit, `δ̄ = (9,5,4,1,3)` in
  `F₁₁` (`δ̄_j = Π_{k'∉{j,j+1}}(a_j − a_{k'})`), `π = 1 − ζ`.
* **Complete mod-`π` content.** The rule is solvable with prescribed residues
  `ū_j = (tr_j − 1) mod π` **iff** `Σ_j ū_j/δ̄_j ≡ 0 (mod 11)` — necessity by
  reduction, sufficiency by an explicit lift, both machine-checked over all
  admissible residue vectors.
* `Σ_j 1/δ̄_j ≡ 0`, forced by `Σ_j 1/D_j = 1`. Hence **constant residue
  vectors always solve it**: the rule is *vacuous* exactly on the Smith
  configuration, and its entire content is on the **differences** `tr_j − tr_{j'}`.

**χ-to-trace relation used (TIER A, proved in-packet).** For a projective
`Y` with a `C11`-action, `Σ_{m=0}^{10} χ_{g^m}(Y,O_Y) = 11·(an integer)` and
the `m ≠ 0` terms are the Galois conjugates of `χ_g`, so
`Tr_{Q(ζ)/Q}(χ_g) = 11ℤ − χ(O_Y)`; since `Tr(x) ≡ −x (mod π)`,

```
        χ_g(Y, O_Y)  ≡  χ(O_Y)   (mod π = (1 − ζ)) .
```

**Verdict.** With the sealed Smith feed-in (the five fibre `χ`'s equal, `≡ 4
mod 11`), the `k = 0` sum rule is **CONSISTENT** — it kills nothing. What it
would take to kill: **if** the five `tr_j` were equal *in `Z[ζ]`* (a
strengthening of "the five `χ`'s are equal", NOT sealed), then
`Σ(t−1)/D_j = (t−1)·1 = 0` forces `t = 1`, i.e. `χ(O of the fibre) ≡ 1 (mod 11)`
at all five points — contradicting any reading in which the sealed `≡ 4` is the
**coherent** `χ(O)`. TIER C (the strengthening is not sealed and the sealed
`4` is `n_x`/`χ_top`, not `χ(O)`); recorded, **not claimed**.

## 5. The genus-0 closed test at `d = 35` — DEAD on the whole depth-≤3 menu

`35 ≡ 2 (mod 11)`, a non-residue: all five points are base points, `μ₁ ≥ 1`,
and at most 3 of the 4 first-level rows carry a value, so **no tower closes at
depth 1**. Only `μ₁ = 7` closes at depth 2; every `μ₁` closes at depth 3.
Exhaustive enumeration at total blowup depth `≤ 3`:

| `μ₁` | defined `C11` rows (`c = 3,5,6,7`) | towers | genus-0 PASS | integral | menu PASS |
|---:|---|---:|---:|---:|---:|
| 1 | –, `e(1)`, –, `e(3)` | 21 | **0** | 1 | 0 |
| 2 | –, –, –, – | 1134 | **0** | 85 | 0 |
| 3 | `e(5)`, –, `e(3)`, – | 90 | **0** | 8 | 0 |
| 4 | –, `e(5)`, `e(9)`, – | 126 | **0** | 11 | 0 |
| 5 | –, –, `e(4)`, `e(9)` | 30 | **0** | 3 | 0 |
| 6 | `e(3)`, `e(4)`, –, `e(5)` | 3 | **0** | 0 | 0 |
| 7 | –, `e(9)`, `e(5)`, `e(1)` | 7 | **0** | 0 | 0 |
| 8 | `e(9)`, `e(3)`, –, – | 90 | **0** | 7 | 0 |
| 9 | `e(1)`, –, –, `e(4)` | 9 | **0** | 0 | 0 |
| 10 | `e(4)`, –, `e(1)`, – | 30 | **0** | 3 | 0 |
| | | **1540** | **0** | **118** | **0** |

The "defined rows" column is *reproduced from Stage-2 Thm 1.2 alone* and
matches the sealed 10-entry `C11` menu of `vectors_d35.json` **exactly**
(verifier check `X`), so the menu is consumed as a menu and never collapsed.

> **Verdict (map level).** For `d = 35`, for **every** one of the 10 `C11`
> menu entries and hence for **every** one of the 22 canonical cells, **the
> genus-0 branch of the C14 trichotomy is dead at order 11 among towers of
> total blowup depth ≤ 3**. Nothing else dies: this kills that branch for
> those patterns at their own degree class `d = d_min = 35`. It excludes no
> degree, and it does not touch the genus-1 or genus-≥2 branches.

**Constancy across the 22 cells is verified, not asserted.** The canonical 22
(`D35_AUDIT/results/patterns_r5_content_p331.json`, `content_hash`-keyed) are
σ-band (order-2) data; their assigned rows carry no `C11`/`P11` token at all.
The order-11 datum of a `(cell, menu entry)` pair is therefore the menu entry
alone, and the verdict is literally constant over the 22.

**Scope, stated plainly.** Depth `≤ 3`. A depth-independent version was
attempted and *does not close*: the leading-order mod-`π` obstruction (§6)
saturates all of `F₁₁` once depth `≥ 4` is allowed (proved by a finite
fixed-point iteration over the tower state graph). So **no all-depth genus-0
death is claimed**.

## 6. A genus-free consequence: integrality, and forced blowup depth

Inverting the Vandermonde `(ζ^{−k a_j})_{k=0..4}` in the twist family gives,
with no genus hypothesis at all,

```
        tr_j = D^X_j · M(a_j) ,      M(W) = Σ_{sites z ↦ W} AB(z) .
```

`tr_j` is a trace of `g` on finite-dimensional cohomology, hence an **algebraic
integer**. Every site term has `v_π = −4` (isolated points *and* components),
`v_π(D^X_j) = 3`, so integrality **requires** `R_V := res_π(π⁴M(V)) = 0` for
all five `V`. Two payoffs:

* **`L12-O11-QR-MU0-BRANCH-DEAD-ALL-DEGREES`.** For every `d ≡ QR (mod 11)`
  the branch "`μ = 0` at the `C11`-points, no blowup over them" forces
  `v_π(tr_j) = −1` at all five points — not algebraic integers. That branch is
  **dead in every QR degree class**, genus-free, map level. (It is the branch
  `STAGE2` §2.1 calls "`μ = 0` is open"; the L12 identity closes it.)
* **`L12-O11-FORCED-BLOWUP-DEPTH`.** `R ≡ 0` is first reachable at total
  blowup depth **3** for `μ₁ ∈ {1,2,3,4,5,8,10}`, **4** for `μ₁ ∈ {6,9}`, and
  **5** for `μ₁ = 7`. So the identity forces the resolution over every
  `C11`-point to have depth ≥ 3 — strictly more than `STAGE2`'s "depth ≥ 2".

118 of the 1540 towers survive integrality, so **the identity does not kill the
`C11` class outright**: no all-22 death, no ODDZERO-standard audit is triggered.

## 7. The bounded fibre-trace menu (C7) — pass is empty at depth ≤ 3

For a smooth 11-curve fibre, holomorphic Lefschetz gives
`tr = Σ_{y} 1/(1 − ζ^{−u_y})` over the `b = n_x` fixed points, and C7's
Riemann–Hurwitz `p_a = 11γ' − 10 + 5b` makes the menu finite once `b` is
bounded. **The menu is in fact finite without any genus bound**: the ten
elements `1/(1−ζ^{−u})` span a 6-dimensional `Q`-space whose kernel is spanned
by `(e_u+e_{−u}) − (e_v+e_{−v})`, so a trace determines **both** `b = Σn_u`
**and** the antisymmetric parts `D_i = n_u − n_{−u}`, and membership is exactly

```
   tr in the span,  b, D_i integral,  b ≥ Σ|D_i|,  b ≡ ΣD_i (mod 2).
```

(validated against brute-force `MENU_b`, `b = 2..5`, 1914 entries). Two
corollaries worth having: `tr = 1` forces `b = 2` — the genus-0 branch demands
exactly **two** `C11`-fixed points in the fibre, whereas the sealed Smith count
is `n_x = 4` on the sealed model and `≥ 6` in every enumerated tower; and
`tr = 2` forces `b = 4`.

**Result.** Of the 118 integrality survivors, **none** has all five forced
traces in the menu with the tower's own `n_x`; the dominant failure is
structural — the forced trace does not lie in the 6-dimensional span at all
(117 of 118), one case gives `b = −4 < 0`. TIER B: this is the *smooth-fibre*
model of the derived fibre of flag 5; reducible / non-reduced / genuinely
derived fibres are carried as unknowns, not assumed away (FLAG-M). So this is
a **menu verdict under a stated model**, not a closed death.

## 8. Symbolic `d mod 11` — class-wide statements

| class | `d mod 11` | max `C11` rows carrying a value (over all `μ`) | class-wide L12 statement |
|---|---|---:|---|
| QR | 1,3,4,5,9 | 4 | `μ = 0` branch **DEAD in every QR class** (§6), genus-free, all degrees |
| NQR | 2,6,7,8,10 | 3 | `μ ≥ 1` forced; no depth-1 tower closes; `d = 35` instance as in §5 |
| 0 | 0 | 2 | `μ ≥ 1` forced; at most 2 rows land; not otherwise evaluated here |

The row counts 4 / 3 / 2 are an independent reproduction of
`STAGE2_ODD_ORDER_PINNING` Thm 2.1 from Thm 1.2 alone (verifier `X`). The
`d = 35` genus-0 verdict of §5 is **not** transported to the other NQR
residues: the tower combinatorics depend on the residue, and only `d ≡ 2` was
enumerated.

## 9. Flags carried (none assumed away)

1. **Stein degree** (flag 1) — not assumed 1: everything is phrased through
   `Rq_*O` and the trace `tr_j`, which absorbs a non-trivial Stein factor; the
   genus-0 branch is entered only as an explicit hypothesis `tr_j = 1`.
2. **Fibre jumps / `R²`** (flag 2) — carried inside `tr_j`; never set to zero.
3. **Map level** (flag 3) — every verdict is at `d = d_min`; no tuple-level
   transport is claimed.
4. **Lift consistency** (flag 4) — one SL lift throughout, `Σ a_i ≡ 0 (mod 11)`;
   order 11 is odd, so safe.
5. **Derived fibre** (flag 5) — `tr_j = χ_g(Z_{e_j}, O)` by derived base
   change, never `1 − tr H¹`; the χ-to-trace relation used is the mod-`π`
   identity of §4 and is proved, not assumed.
6. **FLAG-A** (new) — the §8 numerator/denominator sign pairing, §1.
7. **FLAG-T** (new) — Lemma U(a)'s induction fails at depth 2; positive-
   dimensional fixed components are implemented, not excluded.
8. **FLAG-P** (new) — the tower model is **point** blowups. Resolutions with
   positive-dimensional centres are *not* enumerated; the exact mass identity
   holds for them too, but their value combinatorics are outside this packet.
9. **FLAG-M** (new) — the fibre-trace menu is the smooth-fibre model, §7.

## 10. Not claimed

* No degree is excluded. The first open window stays at `d = 35`.
* No cell is dead outright at order 11: 118 towers survive integrality.
* The genus-0 death of §5 is **depth ≤ 3**; the all-depth version is explicitly
  *not* established (§5, last paragraph), and the leading-order obstruction is
  shown to saturate at depth ≥ 4.
* §4's "equal traces ⇒ `tr = 1`" is a conditional, TIER C, and the sealed Smith
  `4` is `n_x`/`χ_top`, not the coherent `χ(O)` the relation consumes.
* §7's menu verdict holds under the smooth-fibre model (FLAG-M).
* Orders 5, 3, 2, 6 are untouched; so is the genus-1 / genus-≥2 side of C14.

## 11. Honesty tiering

| item | tier | basis |
|---|---|---|
| anchors A0–A6, mass identity, `σ`-transport | **A** | exact machine proof in `Q(ζ₁₁)` |
| `k = 0` mod-`π` content (§4 P1–P5) | **A** | proved + machine-checked |
| χ-to-trace mod `π` (§4) | **A** | proved in-packet |
| FLAG-A, FLAG-T | **A** | explicit machine counterexamples |
| §6 integrality, QR `μ=0` death, forced depth | **A** | exact; genus-free |
| §5 genus-0 death at `d = 35` | **A within scope** | exhaustive over depth ≤ 3; scope stated |
| §7 menu verdict | **B** | smooth-fibre model of the derived fibre |
| §4 "equal traces ⇒ contradiction with `≡ 4`" | **C** | strengthening not sealed; `χ_top` vs `χ(O)` |

## 12. Replay

```
cd goal_runs_20260812/L12_ORDER11 && python3 verifier.py      # 93 checks
cd scripts && python3 main.py                                 # results/l12_order11.json
```

## Director adjudication (2026-08-12, appended at sealing)

Referee: `REFEREE_REPORT.md` — R1/R2/R3/R5/R6 CONFIRMED, R4 CORRECTED
with conclusions standing; packet verifier replayed 93/93 by referee and
director; the referee's independent engine reproduced everything and
CLOSED the one real gap itself (the μ ≡ 0 (mod 11) residues were
unenumerated: extended scope 2674 towers / 226 integrality-survivors —
still 0 genus-0 passes and 0 menu passes). Corrections C1–C6 of the
report are ADOPTED verbatim (extended-scope numbers in force; saturation
profile 3/4/5; `v_π ≥ −4` wording; the fourth sign-pairing noted; the
Lemma-U(b) reproduction downgraded to vacuous-by-construction; label
hygiene). No exit-ledger truth value changes.

**Sealed yields:**
1. **The QR-class kill (general degree, map level, model- and
   convention-independent):** at every degree in a quadratic-residue
   class mod 11, no landing map is defined at the C11-points — the
   μ = 0 branch dies by algebraic integrality of the Vandermonde-forced
   fiber trace. Combined with the sealed non-residue branch: **all 60
   C11-points lie in the base locus of every landing map at every
   degree.** Banner placed on `STAGE2_ODD_ORDER_PINNING` (its B(C11)
   "iff" and the §4 QR row are strengthened, not contradicted).
2. Forced resolution depths over every C11-point at d = 35: ≥ 3 always,
   ≥ 4 for μ₁ ∈ {6, 9}, ≥ 5 for μ₁ = 7 (scope: point-blowup towers,
   FLAG-P).
3. The genus-0 fiber branch at d = 35 is dead through the extended
   tower scope (0 of 2674) — that branch of the C14 trichotomy is
   closed for these patterns at map level.
4. Tier-B (smooth-fiber model): 0 of 226 integrality-survivors pass the
   trace menu — near-kill, honestly model-dependent.
5. FLAG-A adopted into the L12 note as §9: the §8 display pairing is
   sign-inconsistent as written; the two consistent completions are
   Galois conjugate, so every verdict is convention-independent.
