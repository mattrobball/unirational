# G3 — Terminal free-fibre residual pattern across (1,7), (1,13), (3,19)

**Headline: OPEN.**  
**Path G3 exit: `G-PATTERN`.**  
**Degree-13/19 sample exits (corrected labels):** `G13-SAMPLE-RESIDUAL`, `G19-SAMPLE-RESIDUAL`
(historical package strings `G13-OBSTRUCTION` / `G19-OBSTRUCTION` remain in sealed
JSON as computation records; they are **not** degree-wide obstruction theorems —
`REPAIR.md` §§11–12).  
**Not claimed: `G-PERIODIC-NEGATIVE` (no all-degree proof).**  
**Not claimed: `G-POLYNOMIAL` (no tower closes to a polynomial covariant).**

Gate G1 remains **PASS** (finite truncation: tower terminates by normal order `3d`).  
G4 architecture is enforced at every nonautomatic stage:

```text
plane normalization -> triple-line equalizer -> residual point kernel
```

Local free-module surjectivity is **never** promoted to global solvability.

---

## 1. Comparison table (deliverable)

| quantity | (m,d)=(1,7) | (1,13) | (3,19) |
|----------|------------:|-------:|-------:|
| **d − 6m** | **1** | **7** | **1** |
| d mod 6 | 1 | 1 | 1 |
| terminal F-order `3d` | 21 | 39 | 57 |
| multi-Rees total dim (C2 free) | 722 | 5649 | 19236 |
| last isolable E+ F-order | 8 | 14 | 24 |
| **first stage without E+ poly isolator** | **10** | **16** | **26** |
| formula `d + 2m + 1` | 10 | 16 | 26 |
| stage type at first non-isolable | mixed_residual | mixed_residual | mixed_residual |
| formal newest E+ needed there | 8 (>7) | 14 (>13) | 20 (>19) |
| free L_r on sample (all isolable r) | surjective | surjective | surjective |
| ker L1 generic nullity | 4 | 4 | 4 |
| leading sample | a_triv (S3-triv) | a_triv (S3-triv) | pure powers |
| based_zero first nonzero residual | None | None | None |
| **ker-L1 first nonzero residual F-order** | **10** | **16** | **26** |
| residual norm² at first nonzero | 1296 | 156816 | 15968016 |
| residual support size | 1 | 1 | 1 |
| residual C3 weight(s) | {0} | {0} | {2} |
| residual monomial (model) | y₀⁸ y₁² | y₀¹⁴ y₁² | y₀²³ y₁³ |
| package exit (corrected) | G7-OBSTRUCTION (degree-7 global landing empty; independent) | G13-SAMPLE-RESIDUAL | G19-SAMPLE-RESIDUAL |
| historical JSON label | G7-OBSTRUCTION | G13-OBSTRUCTION | G19-OBSTRUCTION |
| G-global landing exclusion | empty (septic) | not re-proved here | not re-proved here |

All free-fibre residuals are exact over **Q** (Fraction arithmetic). Finite fields are not used as characteristic-zero claims.

---

## 2. What the numbers say about each candidate invariant

### 2.1 `d + 2m + 1` (first non-isolable F-order) — **predicts the stage**

For odd `m` and odd `d`, the free-module isolation pattern has

- last even E+ jet order within degree: `d − 1`,
- last isolable F-order: `(d − 1) + 2m`,
- **first stage without E+ polynomial isolator:**

\[
N_\star(m,d) \;=\; d + 2m + 1.
\]

This is pure combinatorics of the stage ledger (G1 + C2 parity + free isolation).  
It is **proved** as a formula for the isolation cutoff; it is **not** by itself a proof that the residual is nonzero.

On every ker-L1 free-fibre sample computed here, the first nonzero residual sits **exactly** at `N_★`:

| (m,d) | N_★ | first nonzero residual |
|------:|----:|-----------------------:|
| (1,7) | 10 | 10 |
| (1,13) | 16 | 16 |
| (3,19) | 26 | 26 |

### 2.2 `d − 6m` — **does not predict the residual order**

| (m,d) | d−6m | first residual order |
|------:|-----:|---------------------:|
| (1,7) | 1 | 10 |
| (3,19) | 1 | 26 |

Same `d − 6m`, different terminal free-fibre residual order.  
Therefore **`d − 6m` is not the invariant controlling the free-fibre residual order**.  
(It may still appear in other global/equalizer contexts; it does not classify the three free-fibre terminals.)

### 2.3 `d mod N`

All three director bidegrees have `d ≡ 1 (mod 6)`. The data set **cannot** separate a genuine mod-6 periodicity from the coarser formula `N_★ = d+2m+1`.  
No modulus `N` is claimed as proved.

### 2.4 `m` alone

Fails: (1,7) vs (1,13) share `m=1` but residual at 10 vs 16.

### 2.5 Source-line ledger

Samples use **based-style** pure E− relative jets zero (`a_odd = 0` for orders `> m`).  
The pure based_zero branch (all E+ particular solutions zero / L1 kernel zero) has **vanishing** free-fibre `F` (triple-E− / odd-order vanishing).  
The nonzero sample residual appears on the **nontrivial ker-L1** free open.  
A residual ledger with nonzero `a_d` was not needed to kill these free-fibre samples; it remains a separate global constraint layer.

### 2.6 Residual S3 / C3 type of the residual form

| (m,d) | leading type | residual C3 weights at first nz |
|------:|--------------|----------------------------------|
| (1,7) | residual S3-trivial a_triv | weight 0 only |
| (1,13) | residual S3-trivial a_triv | weight 0 only |
| (3,19) | pure powers | weight 2 only |

For `m=1`, both residuals are multiples of `y0^{N-2} y1^2` (single term).  
For `m=3`, the first residual is a multiple of `y0^{N-3} y1^3`.  
So the **shape** of the residual depends on `m` (and the leading sample), not only on `d−6m`.

---

## 2.7 P25.1 confirms the sample-residual correction (`REPAIR.md` §12)

At \((m,d)=(1,25)\), the particular terminal residual is nonzero on sample
directions, but later high-order kernel freedom cancels it: an affine-linear
map of **rank 27** into a **29-dimensional** residual codomain leaves a
nonempty zero locus in both live free-fibre families
(`certificates/degree25_tower/TOWER.md`, exit `P25-TOWER-SURVIVES`).

Thus terminal nonzero sample values are **not** evidence of an empty global
zero locus.  The decisive object is always \(\Theta^{-1}(0)\), with all global
equalizers and coefficient couplings imposed.  G4.1's symbolic free-fibre
recurrence remains useful at its stated free-fibre boundary; G4.2 correctly
stops because finite generation of the full equalizer/Fitting layers over the
proposed pure \((m,d)\)-semigroup grading has not been proved.

## 3. Mechanism (why formal smoothness does not algebraize)

1. On the free open where every odd-stage `L_r` is surjective, the polar tower admits **power series** solutions in the normal variable (accepted rank / higher polar recursion).
2. A homogeneous degree-`d` map truncates jets at order `≤ d`. The last E+ isolator is `b_{d-1}` at F-order `(d−1)+2m`.
3. From F-order `N_★ = d+2m+1` the free isolator would need E+ order `≥ d+1`, unavailable as a polynomial correction.
4. Based coefficient coupling kills `a_d` on the based ledger.
5. Explicit ker-L1 free-fibre samples retain a nonzero residual at `N_★` (and typically at many higher even orders).
6. Full `G`-equivariance is a separate layer (Molien / modular scans). Degree 7 is empty projectively; degrees 13 and 19 are not re-excluded globally in this package.

No formal jet or free-fibre lift is called a **covariant**.

---

## 4. Exit classification (strict)

### Claimed: `G-PATTERN`

A **finite combinatorial classification is conjectured** with exact supporting data at three bidegrees:

> **Conjecture (free-fibre terminal stage).**  
> For every odd `m ≥ 1` and odd `d ≥ m` on the residual-trivial / pure-powers free open where all isolable `L_r` are surjective, after solving isolable stages with based-style `a_odd=0` and a nontrivial element of `ker L_1`, the free-fibre residual of `F(p)` first becomes nonzero at
>
> \[
> N_\star(m,d)=d+2m+1,
> \]
>
> and remains a nonzero binary form at that order (exact over `Q`).

**Supporting data:** (1,7), (1,13), (3,19) as in the table.  
**Proved part:** the isolation cutoff formula `N_★` itself.  
**Not proved:** nonzero residual for all odd `(m,d)`; global equalizer / point-kernel / full `G` promotion; any headline `ed_C(G)` statement.

### Not claimed: `G-PERIODIC-NEGATIVE`

Three bidegrees do **not** upgrade to a proved periodic residual pattern covering all degrees and families,
let alone a degree-wide obstruction.  
No chain to `ed_C(G)=4` is asserted.

### Not claimed: `G-POLYNOMIAL`

No finite tower closed with all residuals zero and a polynomial landing self-map.

---

## 5. Resource note for (3,19)

| item | value |
|------|------:|
| multi-Rees total dim | 19236 |
| largest free `L_r` shape (isolable) | 25 × 57 |
| dense multi-Rees equalizer | **not built** |
| exceeded 8 GiB | **False** |
| strategy | free-fibre exact residual certificate |

If a future dispatch densifies multi-Rees equalizers, use `degree19/resource_floor.json` (dimensions, floors, certificate format, checkpoint plan, verifier design).

---

## 6. Files

```text
certificates/global_finite_lifting/degree7/*          # G2 (prior)
certificates/global_finite_lifting/degree13/*         # G3
certificates/global_finite_lifting/degree19/*         # G3
certificates/global_finite_lifting/common_g3.py
certificates/global_finite_lifting/TERMINAL_PATTERN.md
certificates/global_finite_lifting/SEAL.json
certificates/global_finite_lifting/FINITE_TRUNCATION_THEOREM.md
```

### Terminal markers

```text
FINITE_TRUNCATION_G1_PASS
G7_TOWER_VERIFY_OK
G13_TOWER_PRODUCE_OK
G13_TOWER_VERIFY_OK
G19_TOWER_PRODUCE_OK
G19_TOWER_VERIFY_OK
G3_PATTERN_SEAL_OK
```

---

## 7. Boundary

| Proved | Not proved |
|--------|------------|
| G1 finite truncation for all d | All-degree nonzero residual at N_★ |
| Isolation cutoff N_★ = d+2m+1 (odd m,d) | Periodicity in d mod N |
| Exact free-fibre sample residuals at (1,7),(1,13),(3,19) | Degree-wide emptiness of Θ^{-1}(0) at those bidegrees |
| G4 architecture tables at every live stage | Global multi-Rees equalizer elimination |
| d−6m does **not** control free-fibre residual order | G-global Molien landing empty for d=13,19 |
| P25.1: nonzero sample residual can still leave nonempty zero locus | Headline ed_C(G) |

**Retained:** finite truncation, isolation cutoff \(N_\star=d+2m+1\), G4.1
symbolic free-fibre recurrence at its stated free-fibre boundary, exact sample
data.  
**Headline remains OPEN. Exit `G-PATTERN` only (sample residuals, not
degree-wide obstructions).**
