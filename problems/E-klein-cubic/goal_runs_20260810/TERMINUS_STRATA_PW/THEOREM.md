# The full stabilized-strata census of the terminus `Z` of the standard-form tower

**Packet:** `goal_runs_20260810/TERMINUS_STRATA_PW/` · opened 2026-08-10.
**Headline: Problem E remains OPEN.** This packet contains no headline claim.
It is a *complete source-side inventory*: the orbit-type (exact-stabilizer)
stratification of the terminus `Z` of the `STANDARD_FORM_PW` tower over
`P(W) ≅ P⁴`, `G = PSL(2,11)`, with every row's decorations, the closure poset,
the induced stratification of `Z/G`, and the delta to the corner refinement `Z⁺`.

*(Filename note: the main document is `THEOREM.md`; the harness refuses the
literal name `REPORT.md`.)*

## Exit ledger

```text
TERMINUS-ORBIT-STRATA-PW-PASS
TERMINUS-STRATA-ALL-16-CLASSES-CERTIFIED
TERMINUS-CLOSURE-POSET-SEALED
TERMINUS-QUOTIENT-STRATIFICATION-COMPLETE
TERMINUS-ZPLUS-DELTA-SEALED
STANDARD-FORM-PW-5D-COUNTS-CORRECTED
```

Machine marker: `TERMINUS_STRATA_PW_VERIFY_OK` / `ALLGREEN` (`python3 verifier.py`).

---

## 0. What is computed, and in what form

For every conjugacy class of subgroups `H ≤ G` the **orbit-type stratum**

> `Z_{=H} = { z ∈ Z : G_z = H exactly }`

is a smooth locally closed subvariety; its connected components are permuted by
`G`. This packet enumerates **every `G`-orbit of components of every `Z_{=H}`**,
at every stage of the tower, each row carrying

| field | meaning |
|---|---|
| `dim` | dimension of the stratum |
| `#comp` | number of components in the `G`-orbit ( `= 660/|Stab_G(F)|` ) |
| `#/fixedK` | number of them lying in `Z_{=H}` for **one fixed** `H` ( `= |N_G(H)|/|Stab_G(F)|` ) |
| `H` | the exact pointwise stabilizer, named |
| `Stab_G(F)` | the setwise stabilizer |
| `W(H,F)` | the residual action `Stab_{N_G(H)}(F)/H` (`Stab_G(F) ⊆ N_G(H)` always) |
| normal characters | the `H`-characters on `N_{F/Z}` at a general point, each flagged as a boundary branch (`*`) or free |
| provenance | which exceptional divisor of which blowup, over which anchor stratum |
| boundary position | the chain of boundary divisors containing `F`, and the toroidal local model |
| birational class | the closure of `F` is a smooth blowup of a **product of projective spaces** — hence rational |

`Z^H` appears only as a derived union, `Z^H = ⊔_{H' ⊇ H} Z_{=H'}` (§6).

**The fixed-locus complex `𝔽(Z)` of `FIX_I_bcomplex.md` Definition 1.1 is the
same data re-indexed** and is kept as the internal appendix `results/t2_strata.json`.

---

## 1. The structural theorem that makes the census finite and exact

Let `A` be the set of linear subspaces of `W` spanned by the level-0 fixed-locus
components. `scripts/t1`-level output (`results/t3_localmodels.txt` §1):

> **`A` consists of 940 lines, 220 planes and 55 3-spaces — 1215 subspaces in
> 14 `G`-orbits — and is closed under intersection.**

So the tower T0 (940 points) → T1 (220 lines) → T2 (55 plus-planes), which blows
up in order of increasing dimension, is **exactly the maximal De Concini–Procesi
wonderful model of `A`**. That identification is what this packet adds
structurally, and it gives a closed form for every point of `Z`.

> **Theorem 1 (chart form of the terminus).** Write `A_j` for the part of `A`
> blown up by the end of stage `j`. Then
> `Z_j = ⊔_C str°(C)` over the chains `C : U_1 ⊊ … ⊊ U_k` in `A_j`
> (`k ≤ 3`, plus the empty chain), where
>
> ```
> str°(C) = { (x, β_1, …, β_k) } ,
>   x   ∈ P(U_1)  minus the smaller elements of A_j,
>   β_i ∈ P(U_{i+1}/U_i)  minus the images of the elements of A_j strictly
>                          between U_i and U_{i+1}       (U_{k+1} := W).
> ```
>
> The boundary divisors through `z` are exactly `D_{U_1}, …, D_{U_k}`, so
> `D_{S_1} ∩ … ∩ D_{S_k} = ⊔_{C' ⊇ C} str°(C')` and `|I(z)| ≤ 3`.

> **Theorem 2 (tangent weights).** With `λ_0` the character of `G_z` on `⟨x⟩`
> and `λ_i` its character on the line `β_i ⊂ U_{i+1}/U_i`, the four tangent
> weights of `Z_j` at `z` are
>
> ```
> λ_0^{-1}·(U_1/x)                free
> λ_0^{-1}λ_1                     BOUNDARY   (the branch D_{U_1})
> λ_1^{-1}·((U_2/U_1)/β_1)        free
> λ_1^{-1}λ_2                     BOUNDARY   (the branch D_{U_2})
> …
> λ_k^{-1}·((W/U_k)/β_k)          free
> ```

> **Theorem 3 (the census criterion).** The `G`-orbits of components of the
> orbit-type strata of `Z_j` are in bijection with the data
> `(C ; A_0, A_1, …, A_k)` — `A_0 ⊆ U_1`, `A_i ⊆ U_{i+1}/U_i` the eigenspaces
> of the exact pointwise stabilizer `H` — modulo `G`, subject to
>
> * **validity:** the generic point really lies in `str°(C)`;
> * **openness:** `λ_{i-1} ≠ λ_i` as characters of `H`, for every `i = 1..k`.
>
> The stratum is `P(A_0) × P(A_1) × … × P(A_k)` (up to the later blowups it
> undergoes), of dimension `Σ_i (dim A_i − 1)`.

The openness condition **is** clause (iii) of `FIX_I_bcomplex.md` Theorem 2.1:
`λ_{i-1} = λ_i` means the `D_{U_i}`-normal weight is trivial on `H`, i.e. the
piece is the trivial-character eigen-subbundle `P(N^triv)`, which belongs to a
strict transform and is not a new component. Theorem 2.1(ii) is the case `i = k`.

Two immediate corollaries, both **new** relative to `STANDARD_FORM_PW`:

* **Every crossing `D_I` is smooth and irreducible of codimension `|I|`** — it
  is the projective bundle displayed in Theorem 1, with irreducible base and
  projective-space fibres. This *upgrades `STANDARD_FORM_PW` §7 Tier 3 item 1*
  (there argued for one representative and asserted for the rest) to a proof for
  all 1215 divisors and all their crossings.
* **Every stratum is rational.** Its closure is a smooth blowup of
  `P(A_0) × ∏ P(A_i)`, and blowup is birational. So
  `δ_bir(H,F) = rational` for **every** row — verified per row, not assumed from
  `lem:rational_strata_propagate`.

---

## 2. The census of the terminus `Z`, by exact stabilizer

`results/t2_strata.txt`, stage 3. Full rows (with weights, provenance,
birational model) are in that file; here the totals and the shape.

**80 `G`-orbits of orbit-type strata; 11 076 components in all.**

| `H` | `G`-orbits | components of `Z_{=H}` | by dimension | components for ONE fixed `H` |
|---|---:|---:|---|---:|
| `1` | 1 | 1 | `dim 4: 1` (the free open stratum) | 1 |
| `C2` | 15 | 2145 | `1: 1430 · 2: 605 · 3: 110` | 239 |
| `C3` | 13 | 2310 | `0: 1320 · 1: 880 · 2: 110` | 80 |
| `V4` | 18 | 2970 | `0: 1980 · 1: 990` | 54 |
| `C5` | 10 | 1320 | `0: 1320` | 20 |
| `C6` | 19 | 2090 | `0: 2090` | 38 |
| `C11` | 4 | 240 | `0: 240` | 20 |

The last column is `|N_G(H)|/|Stab_G(F)|` summed over the orbit; e.g. a fixed
`C11` fixes exactly 20 points of `Z` (its 5 eigenpoints on `P(W)`, each blown up
into 4 surviving directions).

### The seven occurring classes, row by row (compressed)

Boundary chains are written `smallest<…<largest`; `*` marks a boundary weight.

**`H = C2`** (15 orbits) — the only class with divisorial strata.

| dim | #comp | `Stab_G(F)` | `W(H,F)` | boundary chain | reading |
|---:|---:|---|---|---|---|
| 3 | 55 | `D12` | `S3` | `L'_σ` | `E'_σ = D_{L'_σ}`, `≅ P¹ × P²` |
| 3 | 55 | `D12` | `S3` | `P_σ` | `E_σ = D_{P_σ}`, `≅ P² × P¹` |
| 2 | 165 | `V4` | `C2` | `ell_V` | **`M_τ^V`** — the corner packet's T3 centre |
| 2 | 165 | `V4` | `C2` | `pt_V4I` | two orbits: the rank-3 minus-parts in `E_{V4-I}` |
| 2 | 165 | `V4` | `C2` | `pt_V4I` | |
| 2 | 110 | `C6` | `C3` | `pt_C6` | |
| 1 | 330 | `C2` | `1` | `pt_D10` | inside `E_{D10}` |
| 1 | 165 | `V4` | `C2` | `pt_A4(a)`, `pt_A4(b)` | 2 orbits |
| 1 | 165 | `V4` | `C2` | `pt_D12` | 2 orbits (the two reflection classes of `D12`) |
| 1 | 55 | `D12` | `S3` | `pt_D12` | the central involution's piece |
| 1 | 165 | `V4` | `C2` | `pt_V4I` | |
| 1 | 110 | `C6` | `C3` | `pt_C6` | |
| 1 | 110 | `C6` | `C3` | `pt_C6<C3line` | the only `C2` row on a **double crossing** |

**`H = C3`** (13 orbits): `dim 2` 110 on `C3line` (`Stab C6`, `W = C2`);
`dim 1` 110 each on `C3line`, `pt_C6(a)`, `pt_C6(b)`, `pt_D12` and 220 each on
`pt_A4(a)`, `pt_A4(b)`; `dim 0` 220 each on `pt_A4(a)`, `pt_A4(b)` and on the
four `pt_A4<ell_V` crossings.

**`H = V4`** (18 orbits): `dim 1` — six orbits of 165, on `ell_V<P_σ` (2),
`pt_V4I<L'_σ` (2), `pt_V4I<P_σ` (2); `dim 0` — twelve orbits of 165, on
`pt_A4<P_σ` (4), `pt_D12<P_σ` (6), `pt_V4I<L'_σ` (2). **Every `V4` row sits on a
crossing (`|I| ≥ 2`)** — forced, because `V̂4` is not cyclic and toroidality
needs two independent boundary characters.

**`H = C5`** (10 orbits of 132, all `dim 0`): 4 in each `E_{C5(a)}`, `E_{C5(b)}`,
2 in `E_{D10}`. **`H = C6`** (19 orbits of 110, all `dim 0`). **`H = C11`**
(4 orbits of 60, all `dim 0`, in `E_{C11}`).

### The nine classes that are EMPTY — certified, not assumed

`G` has **16** conjugacy classes of subgroups:
`1, C2, C3, V4, C5, S3, S3, C6, D10, C11, A4, D12, 11:5, A5, A5, PSL(2,11)`.
The census enumerates *all* `(chain, eigen-datum)` pairs on `Z` and computes the
exact stabilizer of each; the nine classes

> `S3` (both), `D10`, `A4`, `D12`, `11:5`, `A5` (both), `PSL(2,11)`

occur for **no** datum, so `Z_{=H} = ∅` for each. This is a *verified claim of
this packet*, at both primes, with three independent supports:

1. exhaustive enumeration (no datum has a nonabelian exact stabilizer:
   `results/t3_localmodels.txt`, "point types with NONABELIAN exact stabilizer: 0");
2. per-row explicit sampling — 79 sampled points, one per non-free row, each with
   its stabilizer computed by brute force in the 660-element group and found
   equal to the claimed `H` (`verifier.py`);
3. the structural reason: `def:toroidal`(c) forces `G_z` abelian, and the seven
   abelian classes are the only abelian subgroups of `PSL(2,11)`.

The three nonabelian classes that *did* occur at level 0 — `D12` (55 points),
`D10` (66), `A4` (110) — are removed at T0/T1 exactly as `STANDARD_FORM_PW` §2
predicts (`A4` needs two rounds); see the stage deltas in §4.

---

## 3. The setwise-stabilizer index over all 16 classes

Every row names its `Stab_G(F)`; the inverse index (`results/t2_strata.txt`,
"SETWISE-STABILIZER INDEX") is:

| `Stab_G(F)` | stratum orbits on `Z` | which |
|---|---:|---|
| `PSL(2,11)` | 1 | the free stratum `Z_{=1}` (`W = G` itself) |
| `D12` | 3 | `E_σ`, `E'_σ` (both `dim 3`, `W = S3`) and the central-involution line in `E_{D12}` |
| `C6` | 27 | the `C6`-point strata and the `C3`/`C2` strata whose centre is a `C6`- or `D12`-point or a `C3`-line |
| `V4` | 26 | every `V4` row, `M_τ^V`, and the `C2` rows over `A4`-, `D12`- and type-I-`V4`-points |
| `C5` | 10 | all the `C5` rows |
| `C3` | 8 | the `C3` rows over `A4`-points and their `ell_V` crossings |
| `C11` | 4 | all the `C11` rows |
| `C2` | 1 | the `dim 1` stratum in `E_{D10}` (330 components) |
| `1`, `S3`×2, `D10`, `A4`, `11:5`, `A5`×2 | **0** | do not occur |

> **Eight of the sixteen classes occur as setwise stabilizers on `Z`.**
> `A4` and `D10` occur at level 0 (as `Stab(ℓ_V)` and `Stab(D10\text{-point})`)
> but **not on the terminus**: the blowup replaces those centres by exceptional
> divisors whose eigen-decompositions break the symmetry — `A4` acts on
> `{χ_z, χ_s, χ_r}` by a 3-cycle and `D10` inverts the `C5`-characters, so no
> eigen-piece is preserved by more than `V4`, resp. `C5`. This corrects the
> expectation that "`A4` stabilizes the `ℓ_V`-family, `D10`/`11:5`/`A5` their
> point-descendants" on `Z`; the surviving nonabelian setwise stabilizer is
> `D12` alone (3 orbits), plus `G` itself on the free stratum.

`W(H,F)` takes only the values `1, C2, C3, S3` and `G` (on the free stratum).

---

## 4. The tower, stage by stage: what each blowup does to the census

`results/t2_strata.txt`, stages 0–3.

| stage | model | stratum orbits | components | setwise-stabilizer classes occurring |
|---|---|---:|---:|---|
| 0 | `P(W)` | 15 | 1216 | `A4`, `C6`, `D12`, `C5`, `C11`, `D10`, `V4`, `G` |
| 1 | `Z_1` (after T0) | 57 | 7336 | `+ C3, C2`; still `A4` |
| 2 | `Z_2` (after T1) | 70 | 9591 | `A4` and `D10` gone |
| 3 | `Z = Z_3` (after T2) | 80 | 11076 | `C2,C3,V4,C5,C6,C11,D12,G` |

Row-level deltas (`G`-orbits identified by their geometric data, so a strict
transform counts as the *same* row):

| stage | rows before → after | rows that cease to be valid | new rows | carried over |
|---|---|---:|---:|---:|
| T0 | 15 → 57 | 10 | 52 | 5 |
| T1 | 57 → 70 | 10 | 23 | 47 |
| T2 | 70 → 80 | 11 | 21 | 59 |

A row "ceases to be valid" for one of two reasons: the stratum **is** (or lies
inside) the new centre and is replaced by its exceptional pieces; or its generic
point acquires a new boundary branch, so it is **re-indexed** onto a longer
chain. Nothing is ever split, merged or lost.

**T0 (blow up the 940 points).** The 10 point-orbits are consumed; 52 new orbits
appear inside the 940 exceptional `E_p ≅ P³`. Orbit-type totals move
`C2: 110 → 1870`, `C3: 110 → 1320`, `V4: 220 → 1375`, `C5: 264 → 1320`,
`C6: 220 → 1100`, `C11: 60 → 240`; `D12` and `D10` vanish outright. Carried
over: `P̃_σ`, `L̃'_σ`, the `C3`-lines, `ℓ̃_V`, and the free stratum.
**`A4` survives** as 110 points, one in each `E_{A4pt}` — the fixed point of the
blowup automaton (`STANDARD_FORM_PW` §2).

**T1 (blow up the 220 lines).** Consumes the `C3`-line, `L'_σ` and `ℓ_V` rows,
and the **last `A4` points** (each lies on `ℓ̃_V`). 23 new orbits, among them the
first `dim 3` `C2` stratum (`E'_σ = D_{L'_σ}`, 55) and the 165 surfaces `M_τ^V`.
`V4` goes `220 → 660` in dimension 1; `C6` goes `1100 → 1760`. After T1 **no
point of the model has a nonabelian stabilizer**.

**T2 (blow up the 55 plus-planes).** Consumes the `P̃_σ` row and re-indexes ten
more; 21 new orbits, including the second `dim 3` `C2` stratum (`E_σ`, 55).
`V4` almost doubles (`1815 → 2970`): blowing up `P_σ` is what separates the three
involutions of a `V4` and produces the twelve `dim 0` `V4` orbits sitting on
`pt_· < P_σ` crossings.

Every centre of the tower is a whole component of a level-0 fixed locus, so no
stratum is ever split or merged; the census evolves only by replacement
(centre → exceptional pieces) and re-indexing.

---

## 5. The closure poset

`results/t4_poset.txt`. At `G`-orbit level: **145 strict containments** among the
80 orbits.

> **Closure rule.** `F(C, A) ⊆ closure F(C', A')` iff `C' ⊆ C` and, for every
> graded slot `r`, `A_r ⊆ Ind_r(A')`, where inserting `U_j` into `C'` splits the
> datum `A'` living in `U_{j+1}/U_{j-1}` as
> `A_{j-1} = A' ∩ (U_j/U_{j-1})` and `A_j = image of A' in U_{j+1}/U_j`;
> in lifted form `Ind_r = (Ã' ∩ U_{r+1}) + U_r`.

Structure of the order (all machine-checked):

* isotropy grows and dimension drops downward; no cycles; it is a strict partial
  order (`FIX_I_bcomplex.md` Definition 1.1(1) with `(H,F) ≤ (H',F')` iff
  `H ⊇ H'` and `F ⊆ F'`);
* **components of `Z^H` for a fixed `H` are pairwise disjoint** — verified as a
  poset statement: for every stratum and every `H` inside its stabilizer, the
  strata above it whose stabilizer contains `H` form a chain (0 incomparable
  pairs);
* the free stratum is the unique maximal element; **42 of the 80 orbits have
  nothing above them but `Z` itself** — the seven `dim 2` and two `dim 3`
  families (`E_σ`, `E'_σ`, `M_τ^V`, the two `pt_V4I` surfaces, the `pt_C6`
  surface, the `C3line` surface), fifteen `dim 1` families, and eighteen
  *isolated* `dim 0` families (all ten `C5` orbits, all four `C11` orbits and
  six `C3` orbits) that lie in no larger stratum at all;
* the **minimal** elements are the `dim 0` rows: 12 `V4` orbits, 6 `C3` orbits,
  10 `C5`, 19 `C6`, 4 `C11`.

**Blowup separation, made visible.** A type-I `V4`-point `[B]` carries three
involutions; the `⟨z⟩`-stratum through the corresponding `V4`-point of `E_{[B]}`
is a curve in `E_{[B]}`, the `⟨s⟩`-stratum is a surface in `E_{[B]}`, but the
`⟨r⟩`-stratum is **not** inside `E_{[B]}` at all — it is `D_{L'_r}`, met
transversally. Counting over the 12 `dim 0` `V4` row-orbits and the three involutions of each,
**26 of the 36 (row, involution) pairs make the `V4`-point an *isolated* point
of `Z^{⟨τ⟩}`** — no larger stratum above it has `τ` in its stabilizer, because
the T1/T2 blowups separate the strict transform of the ambient `C2`-locus from
the exceptional direction. That is the
mechanism by which the tower turns a single `A4`- or `D12`-orbit downstairs into
several inequivalent `G`-orbits upstairs.

### Crossings

* **19 `G`-orbits of double crossings** (`|I| = 2`), generic pointwise
  stabilizer `1` (7 orbits) or `C2` (12 orbits);
* **5 `G`-orbits of triple crossings** (`|I| = 3`), each of size 165 — two of
  type `pt_A4 < ell_V < P_σ` and three of type `pt_D12 < ell_V < P_σ` — all with
  generic stabilizer `C2`. **825 triple-crossing components in all.** This
  confirms and *locates* `STANDARD_FORM_PW` §6(iii)'s "new `|I| = 3` crossing
  type with generic stabilizer `C2`": every one of them lies on an
  `ℓ_V`-`P_σ` flag, over an `A4`- or a `D12`-point.
* `|I| ≤ 3` everywhere; **no crossing of `Z` has non-cyclic generic
  stabilizer**, so `Z` carries no fabulous corner (`thm:pairs`,
  EXTERNAL-UNVERIFIED) — `STANDARD_FORM_PW`'s
  `SOURCE-NO-FABULOUS-CORNER-AT-MINIMAL-TERMINUS`, re-derived globally.
* Finer than that packet: the stabilizers occurring at *some* point of a
  crossing are `{1, C2, C3, C6, V4}` at `|I| = 2` and `{C2, V4}` at `|I| = 3`.
  `V4` occurs on crossings — but never *generically*, which is exactly why the
  corners are not fabulous yet.

---

## 6. The dictionary `Z^H = ⊔_{H' ⊇ H} Z_{=H'}`, and the quotient `Z/G`

**Fixed loci as derived unions** (one fixed `H`; `results/t2_strata.txt`):

| `H` | components of `Z^H`, by dimension | total |
|---|---|---:|
| `C2` | `0: 146 · 1: 80 · 2: 11 · 3: 2` | 239 |
| `C3` | `0: 62 · 1: 16 · 2: 2` | 80 |
| `V4` | `0: 36 · 1: 18` | 54 |
| `C5` | `0: 20` | 20 |
| `C6` | `0: 38` | 38 |
| `C11` | `0: 20` | 20 |

Note that `Z^{C2}` and `Z^{C3}` acquire `dim 0` components — the deeper strata
(`V4`-, `C6`-points) that a single involution or a single `C3` fixes in
isolation. The **dimension profiles of the orbit-type strata themselves** are
`C2: {1,2,3}`, `C3: {0,1,2}`, `V4: {0,1}`, `C5, C6, C11: {0}` — **identical to
`STANDARD_FORM_PW` §5(d)**.

**The quotient.** `G` is finite, so `Z → Z/G` is finite and each stratum orbit
maps onto one locally closed piece of `Z/G` of the *same* dimension, with
generic fibre `G/H` of size `660/|H|`. Hence

> `Z/G` is stratified by **80 locally closed pieces**, one per row: 1 of
> dimension 4 (the free quotient, fibre `G`, 660 points), and 79 boundary
> pieces with fibres `G/C2` (330), `G/C3` (220), `G/V4` (165), `G/C5` (132),
> `G/C6` (110), `G/C11` (60).

The full `Z/G` table is `results/t2_strata.txt`, "THE QUOTIENT STRATIFICATION".

---

## 7. Cross-checks — and one CORRECTION to `STANDARD_FORM_PW`

`results/t3_localmodels.txt`, both primes.

**Agreements (all PASS).**

| checked against | statement | result |
|---|---|---|
| `certificates/STRATA_EXACT.md:108–123` | the level-0 orbit-type census: 11 labels, 14 orbits, 940 + 220 + 55 | reproduced exactly |
| `STANDARD_FORM_PW` §5(a) | 1215 boundary divisors in 14 `G`-orbits, with `H_C`, `G_E`, `Stab_G(E)` | reproduced exactly |
| `STANDARD_FORM_PW` §5(b) / `s3_automaton.txt` | **42 terminal local models**, split `1:2, C2:7, C3:9, V4:3, C5:1, C6:16, C11:4` | **reproduced exactly, independently** |
| `STANDARD_FORM_PW` §5(c) | `|I| ≤ 3`; generic crossing stabilizers `|I|=2 → 1, C2`, `|I|=3 → C2`; no fabulous corner | reproduced exactly |
| `STANDARD_FORM_PW` §5(d) | the dimension *profiles* per class | reproduced exactly |
| `STANDARD_FORM_PW` §2 / §4 | only `{1,C2,C3,V4,C5,C6,C11}` occur as point stabilizers; every point toroidal (defect `= 1`) | reproduced exactly |
| `DUNCAN_CORNER_F2` §4, W6 | `M_τ^V`: 165 surfaces, `G_M = ⟨τ⟩`, `Stab_G = V4`, `N_M` isotypic so `G_{E_τ^V} = ⟨τ⟩` | reproduced exactly |
| `DUNCAN_CORNER_F2` W2 | the 165 `M_τ^V` are pairwise disjoint on `Z` ("separated by T2") | re-derived (§8) |
| `DUNCAN_CORNER_F2` W3 PART 1 | 55 Klein four-groups, 330 corner labels | reproduced exactly |

The 42-local-model agreement is the strongest of these: that packet's automaton
is a purely *local* character recursion, while this packet's enumeration is
*global* (chains of an explicit subspace arrangement in `F_p^5`). They meet on
the nose, class by class.

**The correction.**

> **`STANDARD_FORM_PW` §5(d)'s component counts "created inside exceptional
> divisors" are LOWER BOUNDS, not exact counts.**
>
> Its producer `s5_terminus.py` de-duplicates its rows on the signature
> `(stabilizer name, dim, normal rank, orbit size)`; whenever two genuinely
> distinct `G`-orbits of eigen-pieces over the same centre share that signature,
> only one is counted. Corrected values (this packet, both primes, verified by
> explicit orbit enumeration and by per-row sampled stabilizers):

| class | `STANDARD_FORM_PW` §5(d) | corrected |
|---|---|---|
| `C2` | `1: 1155 · 2: 440 · 3: 110` | `1: 1320 · 2: 605 · 3: 110` |
| `C3` | `0: 440 · 1: 880 · 2: 110` | unchanged (agrees) |
| `V4` | `0: 660 · 1: 330` | `0: 1155 · 1: 330` |
| `C5` | `0: 396` | `0: 1320` |
| `C6` | `0: 330` | `0: 1100` |
| `C11` | `0: 60` | `0: 240` |

The cleanest witness is `C11`: a `C11`-point `p` has `W|_{C11}` a sum of **five
distinct** characters, so `E_p` contains **four** `C11`-fixed points (all but the
trivial-normal one), each with `Stab_G = C11` and hence orbit 60 — `4 × 60 = 240`
in four distinct `G`-orbits, not one orbit of 60. Likewise a `C5`-point gives 4,
a `D12`-point gives one `C2`-orbit of 55 and **two** of 165 (the two reflection
classes of `D12 ≅ C2 × S3`), a type-I `V4`-point gives **two** `dim 2` `C2`-orbits
and two `dim 0` `V4`-orbits.

**Nothing qualitative in `STANDARD_FORM_PW` changes.** Its exit strings, its
local-model table, its divisor table, its dimension profiles, its "no fabulous
corner" and "abelian floor" conclusions are all reproduced here exactly. Only the
five numeric cells above are revised, upward.

---

## 8. Appendix: the census delta `Z → Z⁺` (the corner refinement)

`results/t5_zplus.txt`. `Z⁺ = Bl_{M} Z` where `M` is the `G`-orbit of the 165
surfaces `M_τ^V` — `DUNCAN_CORNER_F2`'s T3.

**`M` as a row of this census:** `H = ⟨τ⟩ = C2`, `dim 2`, 165 components,
`Stab_G(M) = V4`, `W(H,M) = C2`, on the single boundary branch `D_{ell_V}`;
weights `(1, sign*, sign, 1)`. Its normal bundle `N_M = sign ⊕ sign` is
`⟨τ⟩`-**isotypic**, so by Lemma B of `DUNCAN_CORNER_F2` the new divisor
`E_τ^V = P(N_M)` has `G_{E_τ^V} = ⟨τ⟩`. Exactly one of the two normal directions
is the boundary branch `D_{ell_V}`. The 165 copies are **pairwise disjoint on
`Z`** (0 strata lie in two of them), so the blowup is legal in one round.

**Exactly three of the 80 rows lie inside `M`:**

| row | dim | #comp | `N_M` as a module over its own `H` |
|---|---:|---:|---|
| `[C2]` on `ell_V` (`= M` itself) | 2 | 165 | `sign ⊕ sign*` (isotypic) |
| `[V4]` on `ell_V<P_σ` (the section `S_·`) | 1 | 165 | `χ ⊕ χ*` (isotypic) |
| `[V4]` on `ell_V<P_σ` (the other section) | 1 | 165 | `χ ⊕ χ*` (isotypic) |

**The delta.**

* **77 of the 80 rows are unchanged** — strict transforms, with `dim`, `#comp`,
  `H`, `Stab_G(F)`, `W(H,F)` and normal characters all unchanged
  (`FIX_I_bcomplex.md` Thm 2.1(i)).
* **3 rows consumed** (the three above).
* **3 new rows** (Thm 2.1(ii); the trivial character contributes nothing by (iii),
  and here every normal bundle is isotypic so there is exactly one new row each):

| new row | dim | #comp | `H` | reading |
|---|---:|---:|---|---|
| over `M` | 3 | 165 | `C2` | the new divisor `E_τ^V`, `G_D = ⟨τ⟩`, `Stab_G = V4` |
| over `S_·` | 2 | 165 | `V4` | **a fabulous corner** |
| over `S_·` | 2 | 165 | `V4` | **a fabulous corner** |

> **`Z⁺` has 80 stratum orbits and carries 2 `G`-orbits of `V4`-fixed
> codimension-2 strata, `2 × 165 = 330` components — exactly
> `DUNCAN_CORNER_F2`'s 330 fabulous corners, in its 2 orbits of 165.**

So the whole corner phenomenon is, in census terms, a *three-row edit*: one
`C2`-surface orbit and two `V4`-curve orbits are replaced by one `C2`-divisor
orbit and two `V4`-surface orbits, and it is those two `V4` surfaces that are the
fabulous corners. Everything else on the terminus is untouched.

---

## 9. Honesty tiering

**Tier 1 — complete and exact.**
Theorems 1–3 (the chart form, the tangent weights, the census criterion) and
everything derived from them combinatorially: the smoothness/irreducibility of
every crossing, the rationality of every stratum, the closure rule, the poset
axioms, the `Z/G` stratification, the `Z⁺` delta.

**Tier 2 — complete over all `G`-orbits, read off mod `p` at two split primes
(331 and 661, both coprime to `|G| = 660`).**
Every row of every table: the arrangement (940/220/55), all chain orbits, all
eigen-decompositions, all orbit sizes, all setwise stabilizers, all residual
actions, all normal characters, the 145 poset relations, the 42 local models,
the corrected §5(d) counts. The two primes give **identical row sets at every
stage** (checked row-for-row).

**Tier 2+ — per-row explicit witness.**
For each of the 79 non-free rows the verifier constructs an explicit point of
the stratum as flag data `(x, β_1, …, β_k)` over `F_p` and computes its
stabilizer by brute force in the 660-element group; in every case, at both
primes, the stabilizer is **exactly** the claimed `H`. This is what certifies
the nine empty classes as a positive result rather than an absence of evidence.

**Tier 3 — sampled, and flagged.**

1. `scripts/t6_charts.m2` verifies Theorems 1–2 exactly over `QQ(ζ_6)` for
   **one representative of each of the four row genres** (point-, line-,
   plane-exceptional, and the `point < line < plane` triple crossing) — 18/18 —
   but not for all 80 rows. The decisive check there is non-circular: the
   transported group action is *forced* by equivariance against the geometric
   blowup map and the raw diagonal action, so the weight rule is tested rather
   than assumed. Global corroboration: §7's class-by-class agreement with
   `STANDARD_FORM_PW`'s independent local automaton.
2. The identification of `Z` with the maximal wonderful model of `A` is used
   structurally; it rests on `A` being closed under intersection, which **is**
   machine-checked, and on the standard De Concini–Procesi chart description,
   which is verified here in the local models but cited, not re-proved, as a
   general theorem.
3. The `Z⁺` delta computes normal bundles from the graded weight bookkeeping,
   not from an independent chart; it is cross-checked against
   `DUNCAN_CORNER_F2`'s independently derived corner inventory (330 labels,
   2 orbits of 165, `Stab = V4`, `G_D = ⟨τ⟩`) and agrees.

---

## 10. Dependencies

| import | used for | grade |
|---|---|---|
| `FIX_I_bcomplex.md` Def 1.1, Thm 2.1 | the shape of the census and the blowup calculus | re-derived here in the wonderful-model form (Theorems 1–3); Thm 2.1(ii),(iii) is *proved* in this setting, not assumed |
| `duncan_higher_obstruction_20260805.tex` `def:toroidal` | the acceptance criterion, the abelian-stabilizer floor | definition |
| `thm:pairs` (fabulous ⟺ non-cyclic) | **only** the word "fabulous" in §5 and §8 | **EXTERNAL-UNVERIFIED** (`NOTEBOOK.md:4660–4670`); the computed statements ("no non-cyclic generic crossing stabilizer on `Z`", "two `G`-orbits of `V4`-fixed codim-2 strata on `Z⁺`") are unconditional |
| `lem:rational_strata_propagate` | not load-bearing — rationality is **verified per row** here | superseded locally |
| `STANDARD_FORM_PW` (branch `agent/standard-form-pw-20260810`, commit `1430ffa`) | the tower, the automaton, the 42 local models, §5(a)–(d) | re-derived independently; §5(d) counts **corrected** (§7) |
| `DUNCAN_CORNER_F2` | Lemma B, `M_τ^V`, the corner inventory | reproduced; nothing contradicted |
| `certificates/STRATA_EXACT.md` | the level-0 census | reproduced from scratch |

**Provenance note.** `STANDARD_FORM_PW` is **not on `main`**: at the time of
writing it exists only on the unmerged branch `agent/standard-form-pw-20260810`
(commit `1430ffa`), and the working tree at `main` contains only stray
`__pycache__` files from it. This packet reads it from that commit and carries
its own copies of `psl211.py` and `sfcore.py` so as to be self-contained.

## 11. Not claimed

* **No headline claim.** Problem E remains OPEN. This is a source-side
  inventory; nothing here is a statement about `X`, about equivariant
  unirationality, or about `ed_C(PSL(2,11))`.
* No claim that this tower or terminus is canonical or minimal — only that its
  stabilized-strata complex is now completely described.
* No target-side statement: no landing constraint, no receiver analysis.
* The `Z⁺` appendix is a *delta*, not a full re-census of `Z⁺`; the 77 unchanged
  rows are asserted unchanged by Thm 2.1(i), not re-enumerated from scratch.
