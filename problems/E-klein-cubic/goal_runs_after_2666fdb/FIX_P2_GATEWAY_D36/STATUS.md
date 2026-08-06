# FIX-P2 — the gateway window at `d = 36` (program FIX, [E56], Note V, Route 1)

**Problem E headline: OPEN.**

Packet `goal_runs_after_2666fdb/FIX_P2_GATEWAY_D36/`.
No git commits; nothing written outside this packet. Read-only on siblings
(`slicelib.py`, `produce_molien.py`, `produce_sieve.py` copied from FIX-P1;
`k0.py` copied from FIX-H1 — the same practice FIX-H2 used).

| exit | verdict |
|---|---|
| `FIX-P2-H11-LOCAL-CONFIRMED` | **Theorem H1-1's local content is re-proved by an unrelated machine.** On the degree-36 profile slice, *every* clause of H1-1 **at `c_σ`** is already FORCED by the plane/line orders alone: `Λ` vanishes to order exactly `2e = 10` at `c_σ` (ranks `0,0,…,0` through order 9, rank 1 at order 10), `λ_{10}` lands on the one-dimensional `L₀ = V[sgn^e]`, and `λ_{11}` lands on `L₁ = Im(ev_{v₀})`. The global covariant module and the local `S3`-representation theory agree on the nose. §3 |
| `FIX-P2-H11A-SCOPE-QUERY` | **FINDING P2-C — the one clause that does NOT hold.** H1-1(a)'s *"hence, by the residual `C3 = A4/K₁` …, at ALL THREE D12-points"* conflates the three `σ`-data. Measured at the same point `c₁` on the same slice: `ord_{c₁}Λ^{(1)} = 2e = 10` (forced) but `ord_{c₁}Λ^{(2)} = 1`. The `C3` permutes `c₁,c₂,c₃` **together with** `Λ^{(1)},Λ^{(2)},Λ^{(3)}`, so it reproduces one statement, not three. Two primes, two independent diagnostics, plus a structural proof. **The supported bound is `n ≥ 2e`, i.e. `d ≥ 3r − 2m`, not `d ≥ 7r − 6m`.** §4 |
| `FIX-P2-TIGHT-WINDOW-EMPTY` | **Theorem P2-A (exact, char 0) — conditional on H1-1(a) as published.** If `Λ` really does vanish to order `2e` at all three D12-points, then at the *tight* degree `d = 7r − 6m` it is forced to be `c·n₃^{2e} ⊗ v₀` with `v₀` constant, so `λ_{2e}` and `λ_{2e+1}` are proportional; `L₀ ∩ L₁ = 0` then gives `v₀ = 0`, contradicting `Λ ≠ 0` (H0-2). Computed for **69 of 69** profiles `(m,r)`, `m ≤ 11`, `r ≤ 20`: `dim(L₀ ∩ L₁) = 0` in every one. So every minimal degree `7r−6m` would be EMPTY — `d = 36` for `(1,6)`, `d = 43` for `(1,7)` (the FIX-D2 route's first window), `d = 24` for `(3,6)` — and the bound would sharpen to `d ≥ 7r−6m+1`. §5 |
| `FIX-P2-SWEEP2-EMPTY-THROUGH-30` | **Unconditional char-0 emptiness, profile by profile.** The corrected sieve (`n ≥ 2e`) admits **357** profile-slices over `d = 25…38` where FIX-P1's sieve admitted 21. All **107** profiles at `d = 25 … 30` have a **zero** slice — so `FIX-P1-WINDOW-25-EMPTY` and the sweep's verdicts at `d ≤ 30` are re-established on the wider profile list, unconditionally. `d = 31…38` were still running when this packet was written; every row computed so far below `d = 34` is zero. §6 |
| `FIX-P2-MINIMAL-WINDOW-MOVES-TO-34` | **The minimal open window is `d = 34`, not 36.** The `(1,6)` slice, which FIX-P1's sieve did not admit below `d = 36`, is **zero at every `d ≤ 33`** and first becomes nonzero at **`d = 34`** (`n = 28`, dim ≤ 16), then 46, 83, 127, 173 at `d = 35…38`. §6a |
| `FIX-P2-D36-SLICE-83` | FIX-P1's `(1,6)` slice at `d = 36` is **replicated exactly** (83, at `p = 67` and `p = 199`), and the H0-1 refinement `ord_{P_σ}T⁺ ≥ m+1` is shown **vacuous** — it is a parity identity, not a new condition. §2 |

---

## 1. Inputs (all sealed; nothing re-proved here except where §4 says otherwise)

- **(P1)** non-unirationality ⟺ no `G`-equivariant dominant `f` in any degree;
  the gcd-1 tuple satisfies `T(gv) = ρ(g)T(v)`, so `T ∈ M_d :=
  (Sym^d W* ⊗ W)^G`, `T ≠ 0`.
- **(P2)/H0-1** multi-order `(r; m,m,m)`, `m` odd,
  `ord_{P_σ}T⁻ = m < ord_{P_σ}T⁺`; all 55 plus-planes in the base locus.
- **(P3)/H0-2** the leading line datum `Λ ≠ 0`.
- **(P4)/Theorem H1-1** (FIX-H1 `payloads/PAYLOAD_theorem.txt`), with
  `e := r−m`, `V := Hom(Sym^m W⁻, W⁻)`,
  `Λ = ((y,z)-degree-m part of T⁻)/x^e ∈ H⁰(ℓ_V,O(d−r)) ⊗ V`:
  (a) `Λ` vanishes to order `≥ 2e` at the D12-point(s) of `ℓ_V`;
  (b) `λ_{2e} ∈ V[sgn^e]`; (c) `λ_{2e+k} ∈ Im(ev_{v₀})`, vacuous for `k ≥ 2`.
- **(P5)** cone bound `r ≥ (3m+1)/2`; Note II cell table
  (`(1,2),(1,3),(1,4),(1,5),(3,5)` and every odd-`m` bottom cell EMPTY).
- **FIX-P1**: `dim M_d` (Molien), the slice pipeline, and the sweep result
  that the `(1,6)` slice first becomes nonzero at `d = 36` (83).
- **§5.28**: the `w ≠ 0` jet-solvable locus is not killed by localization —
  respected; nothing here claims a localization kill.

## 2. Replication: the `d = 36` slice and the cascade (payload `CASCADE_p67_36_36.json`)

`dim M_36 = 706` (re-computed in-packet by character theory to `d = 50`;
agrees with FIX-P1 for every `d ≤ 40`).

| step | condition | dim |
|---|---|---|
| 0 | `M_36` | **706** |
| 1 | `ord_{P_σ}(T) ≥ 1` | **413** |
| 2 | `+ ord_{P_σ}(T⁺) ≥ 2` (H0-1 refinement) | **413** |
| 3 | `+ ord_{ℓ_V}(T) ≥ 6` | **83** |
| 4 | `+ H1-1(a)` at `c_σ` (`ord ≥ 2e = 10`) | **83** |
| 5 | `+ H1-1(b)` (`λ_{10} ∈ L₀`) | **83** |
| 6 | `+ H1-1(c)` (`λ_{11} ∈ L₁`) | **83** |

and every `m ≥ 3` profile at `d = 36` — `(3,6), (3,7), (5,9)` — is **0**
already at step 1. The 83 and the zeros reproduce FIX-P1 exactly.

**Step 2 is vacuous, and that is a theorem, not an accident.** `σ`-equivariance
makes `T⁺` even and `T⁻` odd in the `W⁻`-coordinates, so `ord_{P_σ}T⁺` is
automatically even: `≥ 1` already means `≥ 2`. (This is Note II Lemma 2.2's
parity table, re-derived; it also re-proves `m` odd.)

**Steps 4–6 are vacuous, and that is the interesting part** — see §3.

*Semantics, used only in the safe direction (`slicelib.__doc__`).* A computed
dimension `0` is a characteristic-zero emptiness verdict; a nonzero computed
dimension is an **upper bound** on the char-0 dimension and decides nothing.

## 3. `FIX-P2-H11-LOCAL-CONFIRMED` — Theorem H1-1 at `c_σ`, from the module side

`diag_d12.py` measures, on the step-3 slice, the rank of each Taylor
functional `T ↦ λ_k(Λ_T at c_i)`. Rank 0 means that order of vanishing is
*forced by the slice conditions alone*. At `c_1 = c_σ` (`p = 67`; `p = 199`
identical through order 11):

```
   k :       0    1    2    3    4    5    6    7    8    9   10   11
  c_1:       0    0    0    0    0    0    0    0    0    0    1    2
```

* orders `0 … 9` forced to zero — exactly `2e = 10`, and **sharp** (order 10 is
  not forced): Theorem H1-1(a) at `c_σ`, reproduced by a machine that knows
  nothing about mirror lines;
* rank 1 at order 10 means `λ_{10}` is confined to a **line** of the
  2-dimensional `V^{τ,sgn^e}` — and the cascade's step 5 shows that line is
  `L₀ = V[sgn^e]`: Theorem H1-1(b);
* the cascade's step 6 (which uses the `S3`-**linear** chart `w₀ + τ·v₀`, the
  only chart in which `λ_{2e+1}` is well defined) shows `λ_{11} ∈ L₁`:
  Theorem H1-1(c). *(In a generic chart `λ'_{11}` mixes `λ_{11}` with
  `λ_{10}` and spans `L₀+L₁` — the rank 2 above. Both readings agree.)*

Two further structural facts fall out, both matching the theory exactly:

* `Λ` is automatically **anti-diagonal** in the `(e_y,e_z)` basis (`e = 5` odd
  ⇒ `V^{τ,sgn}` = the anti-diagonal matrices) — this is the V4-character
  selection rule `(α+β, α+γ) mod 2`, verified on a real module for every
  bidegree by `verify_p2.py` check [B]. H1's "the `τ`-part is AUTOMATIC" is
  literally a character count.
* the leading `(1,6)` datum is **present** on the slice: the `[x⁵y]`,`[x⁵z]`
  block has full rank 12 at 6 sampled line points (`diag_leading.py`), while
  every V4-forbidden bidegree has rank 0.

## 4. `FIX-P2-H11A-SCOPE-QUERY` — FINDING P2-C (director adjudication requested)

### 4a. The measurement

Same slice, same script, at the other two D12-points of `ℓ_V`:

```
   k :       0    1    2    3    4    5    6    7    8    9   10   11
  c_1:       0    0    0    0    0    0    0    0    0    0    1    2
  c_2:       0    1    2    2    2    2    2    2    2    2    2    2
  c_3:       0    1    2    2    2    2    2    2    2    2    2    2
```

Only order **1** is forced at `c_2`, `c_3` — not `2e = 10`. Confirmed at
`p = 199`. And the decisive control (`diag_sigma2.py`), which puts the `σ_1`-
and `σ_2`-data side by side at **both** points:

```
   k :                      0    1    2    3    4    5    6    7    8    9   10   11
  Lambda^{(1)} at c_1 :     0    0    0    0    0    0    0    0    0    0    1    2
  Lambda^{(2)} at c_1 :     0    1    2    2    2    2    2    2    2    2    2    2
  Lambda^{(1)} at c_2 :     0    1    2    2    2    2    2    2    2    2    2    2
  Lambda^{(2)} at c_2 :     0    0    0    0    0    0    0    0    0    0    1    2
```

A perfect 2×2: **each `σ`-datum vanishes to order `2e` at its own D12-point and
to order 1 at the other.** The `2e` is attached to the (datum, point) *pair*,
not to the point.

### 4b. Why — the structural reason

`ℓ_V` lies in exactly three plus-planes `P_{σ_1}, P_{σ_2}, P_{σ_3}`, one per
involution of `K₁`, and `c_i := c_{σ_i}`. Each `σ_i` has its **own** leading
line datum; in V4-coordinates `(x,y,z) = (E_1,E_2,E_3)`

```
 Lambda^{(1)} = [x^{r-1}·(y or z)] of the (y,z)-components      (sigma_1)
 Lambda^{(2)} = [y^{r-1}·(z or x)] of the (z,x)-components      (sigma_2)
 Lambda^{(3)} = [z^{r-1}·(x or y)] of the (x,y)-components      (sigma_3)
```

— three **different** sets of coefficients of the one leading graded piece
`T_r`. The mirror-line argument on `P_{σ_i}` gives
`ord_{c_i}Λ^{(i)} ≥ 2e`, one statement per `i`. The residual
`C3 = A4/K₁` permutes `c₁,c₂,c₃` **and simultaneously** `Λ^{(1)},Λ^{(2)},
Λ^{(3)}` (it permutes the three involutions of `K₁` and the three characters
`χ₁,χ₂,χ₃` at once), so `Λ^{(2)} = θ·Λ^{(1)}` and
`ord_{c_2}Λ^{(2)} ≥ 2e ⟺ ord_{c_1}Λ^{(1)} ≥ 2e`. The transport therefore
**reproduces** the `c_σ` statement; it does not add two more.

*(The same bookkeeping is visible inside FIX-H1's own `(3,6)` formulas:
`Λ`'s entries are `ω g₁³` and `ω²g₂³` with `g₁ = Θf, g₂ = Θ²f` — the `C3`
translates appear inside one `Λ` only because there `e = m = 3`, i.e. only
when `m − b = e` has a solution `0 ≤ b ≤ m`. For `(1,6)`, `e = 5 > m = 1`,
and no entry of `Λ^{(1)}` maps to another entry of `Λ^{(1)}`.)*

### 4c. What survives, and what the corrected bound is

Unaffected (all use only `c_σ`): `FIX-H1-EQ-M3-EMPTY`, `FIX-H1-EQ-M1-EMPTY`,
`FIX-H1-D12-IS-THE-CHEBYSHEV-POINT`, H1-1(b)/(c), and **"no line-degree-0 cell
element is the leading datum of a global map"** (`Λ` constant and vanishing at
`c_σ` is already `Λ = 0`). Note II's cell table is untouched.

Affected: the degree bound. The safe consequence of `Φ = D^e Ψ`
(`deg Ψ = d − m − 3e ≥ 0`) is

> **`n = d − r ≥ 2e`, i.e. `d ≥ 3r − 2m`** — not `d ≥ 7r − 6m`.

Consequences to be adjudicated by the director: FIX-P1's Theorem P1-A
(`d ≥ 24`, and `(3,6)` forced at `d = 24,25,26`), its sieve table, the
`FIX-P1-MINIMAL-OPEN-WINDOW-36-CELL-(1,6)` exit, Note II's "map-relevant
regimes" line (`n ≥ 30` for `(1,6)`), Correction H1-C's `d−r ≥ 6e+9`, and
Note V §2's window arithmetic. The **covariant-ladder** cutoff (no landing
covariant in degrees `≤ 24`, [E25], char 0) is independent of H1-1 and stands.

*Empirically the slice forces one more order at each of `c_2, c_3`
(`n ≥ 2e+2`, `d ≥ 3r−2m+2`), consistently at both primes. That is a mod-`p`
observation about the slice, **not** a theorem, and is recorded as a lead, not
used anywhere.*

## 5. `FIX-P2-TIGHT-WINDOW-EMPTY` — Theorem P2-A (exact, characteristic zero)

*Hypothesis:* H1-1(a) as published (order `2e` at **all three** D12-points).
*(Given §4 this is the clause under query; the theorem is stated so that the
director can consume it the moment the clause is settled either way.)*

At the **tight** degree `d = 7r − 6m` the line degree is `n = 6e` exactly, so
each of the `dim V` component forms of `Λ` — degree `6e`, vanishing to order
`2e` at three distinct points — is a constant multiple of `n₃^{2e}`
(`deg n₃^{2e} = 6e`). Hence

```
        Lambda  =  c · n3^{2e} (x) v0 ,      v0 in V constant, v0 != 0 (H0-2).
```

Writing `n₃ = τ·h(τ)` in the `S3`-linear chart at `c_σ`,
`λ_{2e} = h(0)^{2e} v₀` and `λ_{2e+1} = 2e·h(0)^{2e−1}h'(0)·v₀`, and both
scalars are nonzero: exactly, from the D12 cubic `β³+3β²+κ₊ = 0` of FIX-H1 §4,
`h(0) = 3β(β+2) ≠ 0` (since `P(0) = κ₊ ≠ 0`, `P(−2) = 4+κ₊ ≠ 0`) and
`h'(0) = 3(β+1) = −3c ≠ 0` (`c` the Chebyshev uniformiser, `c = 0` would force
`κ₊ = −2`), and `disc(n₃) ≠ 0`. So (b) and (c) read

```
        v0 in L0 = V[sgn^e]        and        v0 in L1 = Im(ev_{v0})|_{k=1} ,
```

and `L₀ ∩ L₁ = 0` forces `v₀ = 0` — contradiction.

**The scan (`payloads/PAYLOAD_equalizer36.txt`).** `dim(L₀ ∩ L₁)` computed
exactly over `K₀ = Q(ω,ν)` for every profile with `m ≤ 11`, `r ≤ 20`:

| `m` | `dim V` | `dim L₀` | `dim L₁` | `dim(L₀ ∩ L₁)` | tight window `d = 7r−6m` |
|---|---|---|---|---|---|
| 1 | 4 | 1 | 1 | **0** | EMPTY, every `r` |
| 3 | 8 | 1 | 3 | **0** | EMPTY, every `r` |
| 5 | 12 | 2 | 4 | **0** | EMPTY, every `r` |
| 7 | 16 | 3 | 5 | **0** | EMPTY, every `r` |
| 9 | 20 | 3 | 7 | **0** | EMPTY, every `r` |
| 11 | 24 | 4 | 8 | **0** | EMPTY, every `r` |

**69 of 69.** In particular `(1,6)` at `d = 36`:
`L₀ = ⟨[[0,1],[(5−ν)/6,0]]⟩`, `L₁ = ⟨[[0,1],[−(5−ν)/6,0]]⟩` — the two lines
differ by the sign of one entry, and `(5−ν)/6 ≠ 0`.

**Controls that make this trustworthy.** The same code, run at `e = 6`
(`(1,7)`, `d = 43`), returns `L₀ = ⟨id⟩` and `L₁ = ⟨diag(1,−1)⟩` — FIX-H1 §9's
published branch-(ii) answer, verbatim — and at `(3,6)`, `e = 3`, the
published 3-dimensional order-1 span, verbatim. A second, **intrinsic modular**
engine (the frame's own `ρ|_{W⁻}, τ|_{W⁻}` at `p = 67,199,331`; no
normalisation, hence no choice of `√−11`) returns the same two lines and
`rank[L₀;L₁] = 2`; since a nonzero minor mod `p` is nonzero in characteristic
zero, **`L₀ ≠ L₁` is itself a two-engine char-0 fact**. A third engine
(Reynolds projectors instead of nullspaces) agrees — `verify_p2.py` [D].

## 6. The corrected sweep (payloads `SWEEP2_p67_*.json`)

Under `n ≥ 2e` the sieve admits far more profiles: **357** profile-slices over
`d = 25…38` against FIX-P1's 21. Each is one modular rank; a **zero** is an
unconditional characteristic-zero emptiness verdict for that `(d,m,r)`.

| `d` | profiles admitted (`n ≥ 2e`) | of which FIX-P1 admitted | result |
|---|---|---|---|
| 25 | 14 | 1 | **all 14 slices ZERO** |
| 26 | 15 | 1 | **all 15 slices ZERO** |
| 27 | 17 | 1 | **all 17 slices ZERO** |
| 28 | 19 | 1 | **all 19 slices ZERO** |
| 29 | 20 | 1 | **all 20 slices ZERO** |
| 30 | 22 | 1 | **all 22 slices ZERO** |
| 31–38 | 24 … 39 | 2–5 | in flight; live rows in §6a |

**FIX-P1's degree-25 verdict survives the correction**: all fourteen profiles
now admissible at `d = 25` — not just `(3,6)` — have a zero slice, so
`FIX-P1-WINDOW-25-EMPTY` is re-established on the wider profile list. The
same holds at `d = 26, 27, 28, 29, 30`.

### 6a. The `(1,6)` column, computed at every degree (payload `ONESIX_first_nonzero.json`)

FIX-P1 could not see this column below `d = 36` because its sieve did not
admit `(1,6)` there. Corrected, `(1,6)` is admissible from `d = 16` on, and:

| `d` | 16 … 33 | **34** | 35 | 36 | 37 | 38 |
|---|---|---|---|---|---|---|
| `n = d−6` | 10 … 27 | **28** | 29 | 30 | 31 | 32 |
| slice dim | **0** | **≤ 16** | ≤ 46 | ≤ 83 | ≤ 127 | ≤ 173 |

> **The minimal open window moves from `d = 36` to `d = 34`.** The first
> degree at which the `(1,6)` slice is nonzero is **34**, not 36; the profile
> is admissible there under the corrected bound and was not under the old one.
> (Whether `d = 34` is the first degree at which *any* profile has a nonzero
> slice depends on `d = 31, 32, 33`, whose remaining `m ≥ 3` rows were still
> running when this packet was written; every row computed at those degrees so
> far, and every row at `d ≤ 30`, is zero.)

Note also that the tight-window degree for `(1,6)` under the corrected bound
is `d = 3r−2m = 16`, where `n = 2e` exactly and `λ_{2e+1} = 0` automatically —
so Theorem P2-A's mechanism does **not** fire there, and `d = 16 … 33` are
closed by the slice being zero, not by the equalizer.

## 7. Controls

| control | expectation | result |
|---|---|---|
| replication | the `d = 36` `(1,6)` slice must be FIX-P1's 83 | 83 at `p = 67` and `p = 199` ✓ |
| non-unit | `ord_{P_σ} ≥ 1` must leave a positive-dimensional space | 413 ✓ |
| V4-character rule | every `[s^a t^b]` bidegree must be nonzero **exactly** when the character arithmetic allows | all 4 output characters × 2 directions × 25 bidegrees ✓ (`verify_p2.py` [B]) |
| bivariate jets | must agree with the univariate engine on both axes and on a mixed-degree identity | ✓ |
| the control `low`-block | the `[s^k t^1]`, `k < e`, must already vanish on the step-3 slice | ✓ (`control_low_x_free`) |
| published-answer control | the `e = 6` and `(3,6)` equalizer data must reproduce FIX-H1 §9 | verbatim ✓ |
| cross-engine (lines) | exact `K₀` vs intrinsic modular vs Reynolds projector | all agree ✓ |
| cross-prime | `p = 67, 199, 331` | identical ✓ |
| cross-engine (dims) | in-packet Molien vs FIX-P1's payload | identical, `d = 0…40` ✓ |
| rank engine | the fast rank must equal `slicelib`'s reference rank | ✓ on 63 random shapes/primes |
| frame self-tests | `g² = −11`, `S² = T¹¹ = (ST)³ = 1`, `|G| = 660`, `F` invariant, 55 involutions, `χ(2A) = 1`, `dim W^± = 3,2`, `dim W^{V4} = 2`, `|C_G(σ)| = 12`, `dim W^{D12} = 1`, `c_σ ∈ ℓ_V`, `τ|_{W⁻} = diag(1,−1)`, `tr ρ|_{W⁻} = −1`, the three D12-points distinct and a free `C3`-orbit | all ✓ |

## 8. What this packet does NOT claim

- **No candidate map.** Nothing here produces a tuple; the mission's Stage 3
  (landing equations `F(T) ≡ 0`) was never reached, because the linear stage
  turned up FINDING P2-C first.
- **No unconditional `d = 36` verdict.** `FIX-P2-TIGHT-WINDOW-EMPTY` is exact
  and characteristic-zero *given H1-1(a) as published*; §4 puts that clause
  under query. Both are reported; the director adjudicates.
- **No refutation of Theorem H1-1.** Clauses (b), (c), the `c_σ` half of (a),
  and every FIX-H1 verdict built on them are **confirmed** here by an
  independent machine. The query is confined to one inference step.
- **No all-degree theorem.** The sweep is a computed range. A nonzero modular
  slice bounds nothing in characteristic zero.
- **No localization kill**; §5.28 stands untouched.
- **The `(1,6)` cell**: this packet decides nothing about it. It measures that
  the *globally realizable* part of the cell at line degrees 28–32 is nonempty
  as a linear space (upper bounds 16, ·, 83, 127, 173) — upper bounds only, so
  neither population nor emptiness is claimed. What it *does* add to the cell
  ledger is structural: on the `(1,6)` slice the leading datum is forced
  anti-diagonal, vanishes to order exactly `2e` at its own D12-point, and its
  order-`2e` and order-`2e+1` coefficients are forced onto `L₀` and `L₁`.
- **Problem E headline: OPEN.**
- **The `d = 31 … 38` sweep rows were still being computed when this packet was
  written.** `produce_sweep2.py` writes `payloads/SWEEP2_p67_*.json`
  incrementally after every profile, so the payload is authoritative and the
  runs are resumable/regenerable exactly as REPLAY §5 says. Nothing in §6 is
  claimed for a row that has not been computed.

## 9. Files

```
produce_molien.py        exact Molien to d = 50        -> payloads/MOLIEN.json
produce_equalizer36.py   ENGINE 1: exact K0 equalizer + the tight-window scan
                                                       -> payloads/EQUALIZER36.json
                                                          payloads/PAYLOAD_equalizer36.txt
p2lib.py                 adapted V4/D12 frame, intrinsic L0/L1, bivariate jets
produce_cascade.py       ENGINE 2: the dimension cascade -> payloads/CASCADE_*.json
produce_sweep2.py        the corrected sieve x slice sweep -> payloads/SWEEP2_*.json
diag_leading.py          which bidegrees survive on the slice
diag_d12.py              the three D12-points, order by order       (FINDING P2-C)
diag_sigma2.py           the three sigma-data at one point          (FINDING P2-C)
verify_p2.py             INDEPENDENT verifier + self-tests   -> FIX_P2_VERIFY_OK
slicelib.py, produce_sieve.py, k0.py   copied read-only from FIX-P1 / FIX-H1
REPLAY.md                exact commands and expected output
logs/                    run logs (regenerable)
```
