# FIX-P1 — the guided degree-25 window (program FIX, [E56], Note V)

**Problem E headline: OPEN.**

Packet `goal_runs_after_063da5a/FIX_P1_DEGREE25_GUIDED/`.
Two stages, both decided. No git commits; nothing written outside this packet.

| exit | verdict |
|---|---|
| `FIX-P1-D25-CLOSED-BY-PROFILE` | **Stage 1.** `n = 19` is NOT admissible for the `(3,6)` evasion channel — and no `(3,6)` `D_B` member exists at line degree 19 at all. Every *classified* shape and the *entire* evasion channel die at `d = 25` by profile arithmetic. |
| `FIX-P1-WINDOW-25-EMPTY` | **Stage 2.** The forced-profile slice of the degree-25 covariant module `M_25` is **ZERO in characteristic zero** (three primes, two independent jet engines). Hence **there is no `G`-equivariant dominant rational map `P(W) ⇢ X` of degree 25.** |
| `FIX-P1-SWEEP-EMPTY-THROUGH-35` | **Stage 2, extended.** The same slice is zero for *every* admissible profile at every degree `24 ≤ d ≤ 35`; with `d ≥ 24` (Theorem P1-A) this closes **every degree `≤ 35`** in characteristic zero. The previous char-0 cutoff was 24. |
| `FIX-P1-MINIMAL-OPEN-WINDOW-36-CELL-(1,6)` | The sweep's first nonzero slice is at **`d = 36`, profile `(1,6)`, `n = 30`** — exactly the `(1,6)` hole of Note II's cell table, at exactly its `H1-1(a)` minimal degree `7·6−6 = 36`. Every `m ≥ 3` profile is still zero at `d = 36, 37, 38`. |
| `FIX-P1-DEGREE-BOUND-24` | **Theorem P1-A** (new, profile arithmetic alone): any `G`-equivariant dominant map has `d ≥ 24`; at `d = 24, 25, 26` the profile is *forced* to `(m,r) = (3,6)`. An independent re-derivation of the covariant ladder's `≤ 24` cutoff by a completely different machine. |
| `FIX-P1-MINIMAL-CLASSIFIED-WINDOW-33` | The first degree at which **any classified shape** survives every sealed constraint *as a germ* is **`d = 33`**: the `(3,6)` `D_B(f·yz)` family with `n = 27`, `μ = deg f = 9`, `f = c·n₃³` — rigid, zero moduli beyond the scalar and the branch parameter `B`. **The sweep then kills it globally**: the `d = 33` `(3,6)` slice is zero, as is `d = 36`'s (its only other degree `≤ 38`, since `3 ∣ n` forces `3 ∣ d`). Correction H1-C's undecided evasion sub-family is thus alive as a germ and dead as a global object throughout `d ≤ 38`. |

---

## 1. Inputs (all sealed, director-replayed; nothing re-proved here)

- **(P1)** reduction: non-unirationality ⟺ no equivariant dominant `f` in any
  degree ([E16]/[E37]). Since `PSL(2,11)` is simple it has no nontrivial linear
  character, so the gcd-1 tuple of `f` satisfies `T(gv) = ρ(g)T(v)` on the nose:
  `T ∈ M_d := (Sym^d W* ⊗ W)^G`, `T ≠ 0`.
- **(P2)/H0-1** parity: multi-order `(r; m,m,m)`, `m` odd,
  `ord_{P_σ}T⁻ = m < ord_{P_σ}T⁺` — hence `ord_{P_σ}(T) = m` — and all 55
  plus-planes in the base locus.
- **(P3)/H0-2** sweep: the leading line datum `Λ ≠ 0`.
- **(P4)/Theorem H1-1**: `Λ ∈ H⁰(ℓ_V, O(n)) ⊗ V_m`, `n = d−r`, `Λ` vanishes to
  order `≥ 2e` (`e = r−m`) at each of the three D12-points; conditions on
  `λ_{2e}`, `λ_{2e+1}` only, **inclusive of zero**; corollary `d ≥ 7r−6m`.
- **(P5)** cone bound `r ≥ (3m+1)/2` (Note II Lemma 2.1).
- **(P7)/Correction H1-C**: the `(3,6)` `D_B` family fails the order-0 equalizer
  at every line degree **except** the `n₃`-divisible sub-family, forced there to
  `d − r ≥ 6e + 9`.
- **Note II cell table**: `(1,2),(1,3),(1,4),(1,5)` and `(3,5)` EMPTY at all
  line degrees; Lemma 2.4 propagation `(m,r) → (m+2,r+3)` when `r ≤ 2m`.
- **§5.28 (FIX-D2 terminal verdict)**: the `w ≠ 0` jet-solvable locus is NOT
  killed by the `c_σ`-localized machinery at any degree. Respected throughout:
  nothing below claims a localization kill.

---

## 2. Stage 1 — the sieve at `d = 25` (payload `PAYLOAD_dictionary.txt`)

### 2a. The `(3,6)` line-degree dictionary (the question the mission posed)

Theorem N2B-2 builds the `(3,6)` family as `D_B(X)` with `X = f·yz` (`yz` is the
unique degree-2 `χ_x` form), and `D_B` is **cubic** in `X`. With `μ := deg f`:

> **Dictionary P1-2.** `(x,y,z)`-degree `= 3·2 = 6 = r`; line degree
> `n = d − r = 3μ`. **So the line degree of any `(3,6)` `D_B` member is
> divisible by 3**, and `d = 3(μ+2) ≡ 0 (mod 3)`.

Cross-checked against FIX-H1's own `Λ = ω g₁³(z³+B_eff y²z)E_y + ω² g₂³(…)E_z`
(`g₁ = Θf`, `g₂ = Θ²f`): the four coefficient forms `ωg₁³, ωBg₁g₂², ω²g₂³,
ω²B⁻¹g₁²g₂` all have degree `3μ`. Hence also

> **Dictionary P1-3.** `ord_p(Λ) = 3·min(ord_p g₁, ord_p g₂)` — **always a
> multiple of 3** in this family. So H1-1(a) (`ord ≥ 2e = 6`) ⟺ `n₃²|f`,
> `μ ≥ 6`, `n ≥ 18`; and **evasion** (`λ_{2e} = λ_{2e+1} = 0`, i.e. `ord ≥ 7`)
> ⟺ `ord ≥ 9` ⟺ `n₃³|f` ⟺ `μ ≥ 9` ⟺ `n ≥ 27 = 6e+9`, `d ≥ 33`.

The bound `n ≥ 6e+9` **reproduces Correction H1-C's own forced bound exactly** —
the independent confirmation that `n = 3μ` (not `n = μ`) is the right reading of
Theorem N2B-2's loose phrase "line degree `deg_{s,t} X`".

### 2b. The universal order window (new, shape-free)

> **Lemma P1-1.** With `o := ord_{p_i}(Λ)` (equal at all three D12-points, they
> are one free `C₃`-orbit): `2e ≤ o ≤ ⌊n/3⌋`. The upper bound is just
> `Λ ≠ 0`: `n₃^o | Λ` and `deg n₃^o = 3o ≤ n`.
> **Consequence: the evasion channel needs `n ≥ 6e+3`.** Below that,
> `λ_{2e} ≠ 0` is forced and the leading-layer equalizer is nonvacuous.

### 2c. VERDICT at `d = 25`

Only profile: `(m,r) = (3,6)`, `e = 3`, `n = 19`.

- **evasion, any shape:** `19 < 6e+3 = 21`, so `o = 6` exactly and
  `λ₆ ≠ 0`. *(If `λ₆ = 0` then `n₃⁷ | Λ`, `deg n₃⁷ = 21 > 19`, so `Λ = 0`,
  contradicting H0-2.)* **The evasion channel is closed at `d = 25`.**
- **classified `D_B` channel:** `3 ∤ 19`, so by Dictionary P1-2 **no member of
  the family exists at line degree 19 at all** (independently, its evasion
  sub-family needs `n ≥ 27`).

`FIX-P1-D25-CLOSED-BY-PROFILE`. Residual, stated honestly: an *unclassified*
`(3,6)` family at `n = 19` in the FIX-D2 `w ≠ 0` locus — hypothesis [U1], open
at every `d ≥ 24` by §5.28. **Stage 2 closes it globally.**

---

## 3. Stage 1 — the sieve table (payloads `SIEVE_TABLE.{json,txt}`)

Constraints: `m` odd; `r ≥ (3m+1)/2`; `d ≥ 7r−6m`; cell not proved empty;
`Λ ≠ 0`; evasion iff `n ≥ 6e+3`; the `(3,6)` `D_B` dictionary.

> **Corollary P1-B.** `m ≤ (2r−1)/3` gives `7r−6m ≥ 3r+2`, so **`d ≥ 3r+2`,
> i.e. `r ≤ (d−2)/3`** — a clean new bound on the triple-line order.

> **Corollary P1-C.** For every odd `m`, the bottom cell `(m,(3m+1)/2)` is EMPTY
> at all line degrees: `(1,2)` is EMPTY and `(3m+1)/2 ≤ 2m`, so Note II
> Lemma 2.4 propagates it up the whole odd column — `(3,5), (5,8), (7,11),
> (9,14), …`. *(This is what removes `(5,8)`, otherwise the second profile at
> `d = 26`.)*

> **Theorem P1-A.** Any `G`-equivariant dominant map has **`d ≥ 24`**, and
> `d = 24, 25, 26` force `(m,r) = (3,6)`. Every `(m,r)` with `7r−6m ≤ 23` is a
> cell proved EMPTY at all line degrees. This re-derives the covariant ladder's
> `≤ 24` cutoff from pure profile arithmetic — two unrelated machines, same
> number.

Sieve highlights (full table in the payload):

| `d` | admissible profiles `(m,r)` with `n = d−r` | evasion available (`n ≥ 6e+3`) | classified shape alive |
|---|---|---|---|
| `≤ 23` | **none** | — | — |
| 24 | (3,6) `n=18` | no | dead (non-evasive) |
| **25** | **(3,6) `n=19`** | **no** | **none exists (3∤19)** |
| 26 | (3,6) `n=20` | no | none exists |
| 27 | (3,6) `n=21` | yes (general shape) | dead (`D_B` needs `n≥27`) |
| 31 | (3,6) `n=25`, **(3,7) `n=24`** | mixed | — |
| **33** | (3,6) `n=27`, (3,7), (5,9) | yes | **ALIVE: `f = c·n₃³`** |
| 36 | +(1,6) `n=30` | — | alive |
| 43 | +(1,7) `n=36` (the FIX-D2 route) | — | — |

**Minimal open windows.** First degree with a live *classified* shape: **33**.
First degree admitting a profile other than `(3,6)`: **31**. First degree where
evasion is arithmetically possible at all: **27**.

---

## 4. Stage 2 — the ansatz slice at `d = 25` (payloads `MOLIEN.json`, `SLICE_p*.json`)

### 4a. The ansatz space, and the guidance payoff

`M_25 = (Sym^25 W* ⊗ W)^G` has **dim 189** — computed here exactly by character
theory in `Z[z]/Φ₃₃₀(z)` (`produce_molien.py`), agreeing with the repo's
independent `certificates/exact_molien.py`, and re-confirmed a third time as the
rank of a Reynolds-evaluation matrix. (The same script gives
`dim (Sym^75 W*)^G = 2343`, the number of scalar landing equations `F(T)=0`
would impose — never needed, see below.)

The forced profile `(3,6)` slices `M_25` by two **linear** conditions, each
imposed at ONE site and propagated to all 55 by `G`-equivariance:

```
    (A)  ord_{P_sigma}(T) >= 3      [ m = 3 for the minus half, >= 4 for plus ]
    (B)  ord_{ell_V}(T)   >= 6      [ the cone order r = 6 ]
```

**Nested dimensions (identical at `p = 67, 199, 331`):**

| condition | rank | dim of slice |
|---|---|---|
| — (raw equivariant module `M_25`) | — | **189** |
| `ord_{P_σ} ≥ 1` (55 plus-planes in the base locus) | 130 | **59** |
| `ord_{P_σ} ≥ 2` | 186 | **3** |
| `ord_{P_σ} ≥ 3` **(the forced `m = 3`)** | 189 | **0** |
| `ord_{ℓ_V} ≥ 6` **(the forced `r = 6`)**, alone | 189 | **0** |
| **(A) and (B) together — the profile slice** | 189 | **0** |

**The guidance payoff, quantified: 189 → 59 → 3 → 0.** The two intermediate
numbers 59 and 3 reproduce, from completely independent code, the repo's own
degree-25 ledger (`arrangement kernel K_25 = 59`, `first-jet kernel = 3`) — a
strong cross-validation of the pipeline. The two *new* numbers are the zeros.

### 4b. VERDICT

> **`FIX-P1-WINDOW-25-EMPTY`.** The profile slice of `M_25` is zero.
> Since every degree-25 `G`-equivariant dominant map supplies a **nonzero**
> element of that slice, **there is no `G`-equivariant dominant rational map
> `P(W) ⇢ X` of degree 25 — in characteristic zero.**

The landing equations `F(T) ≡ 0` were **never needed**: the *linear* profile
conditions alone are already empty. (So Stage 2(d)'s Gröbner branch is vacuous —
reported as such, not as an unattempted step.)

### 4c. Why a modular rank is a characteristic-zero verdict

Two asymmetries, both used only in the safe direction:

1. `rank_{F_p}(Φ mod P) ≤ rank_K(Φ)` for a matrix over `O = Z[ζ₃₃]_P`
   (`p ∤ 660`, so the Reynolds `1/|G|` is a unit — and it is dropped anyway,
   a unit rescaling of rows). A **full-rank** modular computation therefore
   proves full rank over `K`, hence a zero kernel over `K` and over `C`.
   *(A nonzero modular kernel proves nothing — respected: no such claim is made
   anywhere in this packet.)*
2. Using only a **subset** of the linear functionals cut out by a vanishing
   condition can only **enlarge** the computed kernel. A zero computed kernel is
   therefore decisive even though the sample points are random.

This is the same lifting argument FIX-N2b §2.4 used ("the mod-`p` matrix has
FULL column rank, and rank can only drop under reduction").

### 4d. Where the `E25` `F_67` branches went — the mission's explicit question

The degree-25 filtration of [E25] is indexed by **triple-line order**. The FIX
profile forces `r = 6`. Therefore:

- the **order-2 branch** would need `r = 2`, hence `m = 1` (cone bound), i.e.
  cell `(1,2)` — **EMPTY at all line degrees in char 0** (FIX-N2). *That branch
  was never inside the admissible profile at all*; its `F_67` evidence is
  irrelevant to the headline, and its exclusion is now char-0, not modular.
- the **order-3 branch**: `r = 3 ⇒ m = 1 ⇒` cell `(1,3)`, already char-0 closed
  (V4 Thm 2.12), independently re-closed by FIX-N2.
- the **order-≥4 branch**: at `d = 25` only `r = 6, m = 3` survives the sieve —
  and §4a shows that stratum is **zero**.

So the answer to "was the modular evidence ever IN the admissible profile?" is:
**only the order-≥4 branch was, and it is now char-0 empty.** The 63-chart route
(`goals_2026-08-01/P25_LANDING_SUPPORT`, `PREPARED_NOT_RUN`) is no longer needed
for the *dominant-map* question at degree 25.

*Scope note, deliberately narrow.* This packet excludes **dominant maps**, which
is exactly what (P1) needs. It does **not** claim "no degree-25 landing
covariant": a non-dominant `T` with `F(T)=0` need not satisfy H0-1/H0-2. Whether
[E17]'s automatic-dominance upgrades the statement is a director call, not made
here.

---

## 5. Stage 2, extended — the SIEVE × SLICE sweep (payload `SWEEP_p67_*.json`)

The same computation runs at every degree, for **every** profile the sieve
leaves admissible. Result (`p = 67`):

| `d` | dim `M_d` | admissible profiles → slice dimension |
|---|---|---|
| ≤ 23 | — | *no admissible profile at all* (Theorem P1-A) |
| 24 | 161 | (3,6) → **0** |
| **25** | **189** | **(3,6) → 0** |
| 26 | 217 | (3,6) → 0 |
| 27 | 245 | (3,6) → 0 |
| 28 | 284 | (3,6) → 0 |
| 29 | 320 | (3,6) → 0 |
| 30 | 361 | (3,6) → 0 |
| 31 | 410 | (3,6) → 0, (3,7) → 0 |
| 32 | 459 | (3,6) → 0, (3,7) → 0 |
| 33 | 511 | (3,6) → 0, (3,7) → 0, (5,9) → 0 |
| 34 | 576 | (3,6) → 0, (3,7) → 0, (5,9) → 0 |
| **35** | **637** | **(3,6) → 0, (3,7) → 0, (5,9) → 0** |
| 36 | 706 | **(1,6) → 83**, (3,6) → 0, (3,7) → 0, (5,9) → 0 |
| 37 | 786 | **(1,6) → 127**, (3,6) → 0, (3,7) → 0, (5,9) → 0 |
| 38 | 865 | **(1,6) → 173**, (3,6) → 0, (3,7) → 0, (3,8) → 0, (5,9) → 0 |

> **`FIX-P1-SWEEP-EMPTY-THROUGH-35`.** Every admissible profile at every degree
> `24 ≤ d ≤ 35` has a zero slice. With Theorem P1-A (`d ≥ 24`), **no
> `G`-equivariant dominant rational map `P(W) ⇢ X` of degree `≤ 35` exists, in
> characteristic zero.** The previous char-0 cutoff was **24**.

> **`FIX-P1-MINIMAL-OPEN-WINDOW-36-CELL-(1,6)`.** The first nonzero slice in the
> whole sweep is `d = 36`, `(m,r) = (1,6)`, `n = 30`, of dimension `≤ 83`. This
> is **exactly the `(1,6)` hole** of Note II's cell table ("OPEN above line
> degree 2"), appearing at **exactly** its `H1-1(a)` minimal degree
> `7·6 − 6·1 = 36` — the number Note II §4 already predicted (`n ≥ 30` for
> `(1,6)`). Two independent machines, same degree.

**The `m ≥ 3` world is dead through `d = 38`.** Every profile with `m ≥ 3` —
which is where *all* classified branches live (`D_B` and its relatives) — has a
zero slice at every degree computed, `24 … 38`. In particular:

> the `(3,6)` `D_B` `n₃`-divisible **evasion sub-family**, which Correction H1-C
> left undecided and which Stage 1 shows first becomes arithmetically possible
> at `d = 33`, **does not extend to a global equivariant tuple at `d = 33` or
> `36`** (its only degrees `≤ 38`, since `3 | n` forces `3 | d`). The evasion
> channel is alive as a *germ* and dead as a *global object* throughout the
> computed range.

Honest scoping: this is a **computed range**, not a theorem for all `d`. Degrees
`≥ 39` and the `(1,6)` stratum at `d ≥ 36` are **NOT DECIDED** here — a nonzero
modular slice bounds nothing (§4c). Nothing in this packet bounds all degrees;
the no-degree-bound problem is untouched. And a nonzero slice is not a candidate
map: it would still have to satisfy `F(T) ≡ 0` and be dominant.

### 5a. The crisp form of the degree-25 statement

The calibration ladder (`payloads/CALIBRATION_p199.json`, monotone, control):

```
   ord_{P_sigma} >= k :  189, 59, 3, 0, 0, 0        (k = 0,1,2,3,4,5)
   ord_{ell_V}   >= k :  189, 173, 153, 102, 50, 0  (k = 0,1,2,3,4,5)
```

> **At degree 25 the maximum plane order carried by any nonzero `G`-equivariant
> tuple is 2, and the maximum triple-line order is 4.** The forced profile
> demands `m = 3` and `r = 6`. Both fail — by one and by two.

---

## 6. Controls

| control | expectation | result |
|---|---|---|
| non-unit (arrangement kernel) | `ord_{P_σ} ≥ 1` must leave a *positive*-dimensional space, else the pipeline over-imposes | dim **59** > 0 ✓, and equals the repo's independently computed `K_25` |
| non-unit (first jet) | `ord_{P_σ} ≥ 2` must be 3 (repo ledger) | **3** ✓ |
| unit | an impossible order (`ord_{ℓ_V} ≥ 12` at degree 25) must give 0 | **0** ✓ |
| saturation | doubling the sampled `(w,y)` pairs must not change any rank | unchanged ✓ |
| calibration ladder | weakening each condition one order at a time must give a *monotone, strictly informative* ladder, not a collapse | `189,59,3,0` and `189,173,153,102,50,0` ✓ |
| positive detection | the sweep must be able to RETURN a nonzero slice when one exists | `(1,6)` at `d = 36,37,38` returns `83,127,173` ✓ |
| cross-prime | `p = 67, 199, 331` | identical, all rows ✓ |
| cross-engine (dimensions) | character-table Molien vs. explicit 660-element group sum vs. Reynolds-evaluation rank | all agree, `d = 0..40` ✓ |
| cross-engine (jets) | truncated power series (producer) vs. 26-point Vandermonde inversion (verifier) | agree ✓ |
| self-test | `dim M_d` for `d = 1,4,5,6,7,10,12,18` recovered by the same pipeline | ✓ |

Frame self-tests, re-run at every prime: `g² = −11`, `S² = T¹¹ = (ST)³ = 1`,
`|G| = 660`, `F = Σ xᵢ²xᵢ₊₁` invariant, exactly 55 involutions, `χ(2A) = 1`,
`dim W⁺ = 3`, `dim W⁻ = 2`, `dim W^{V4} = 2` (the triple line is a line).

---

## 7. What this packet does NOT claim

- Not an all-degree theorem. Degrees above the swept range are **NOT DECIDED**.
- No localization kill: §5.28's `FIX-D2-TERMINAL-SOLVABLE` stands untouched.
  The `w ≠ 0` jet-solvable locus is still not killed *by localization*; it is
  killed at `d ≤ 33` **globally**, by the equivariant module being too small to
  carry the forced vanishing — a different mechanism entirely.
- No claim about non-dominant landing covariants (§4d scope note).
- No claim that the `(3,6)` `D_B` evasion sub-family at `d = 33` is empty *as a
  cell*: it is alive as a **germ**; the slice result says only that no global
  degree-33 equivariant tuple realizes it.
- **Problem E headline: OPEN.**

## 8. Files

```
produce_sieve.py     Stage 1 sieve            -> payloads/SIEVE_TABLE.{json,txt}
produce_molien.py    exact character-theory Molien -> payloads/MOLIEN.json
slicelib.py          modular Weil frame + jet engine (self-testing)
produce_slice.py     the d = 25 profile slice -> payloads/SLICE_p{67,199,331}.json
produce_sweep.py     the sieve x slice sweep  -> payloads/SWEEP_p67_*.json
produce_calibration.py  the monotone order ladders (control) -> payloads/CALIBRATION_p199.json
verify_p1.py         INDEPENDENT verifier (own engines) + self-test
payloads/PAYLOAD_dictionary.txt   the (3,6) dictionary and the d=25 verdict
REPLAY.md            exact commands and expected output
logs/                run logs (regenerable)
```
