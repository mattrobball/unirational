# Stage 1: the complete classification of complex-level maps `Z ⇢ X`

**Packet:** `goal_runs_20260810/STAGE1_COMPLEX_MAPS/` · opened 2026-08-10.
**Headline: Problem E remains OPEN.** This packet contains no headline claim.

It classifies **every** morphism of decorated complexes of groups, in the
category of schemes, from the terminus source complex `F(Z)`
(`TERMINUS_STRATA_PW`), together with the order-0 delta for the corner
refinement `Z⁺` (§7) to the complex of the Klein cubic (`RECEIVER_LEDGER_X`),
under the sealed constraint rows, for a dominant `G`-equivariant
`P(W) ⇢ X` (`G = PSL(2,11)`, `|G| = 660`). Realization of such a morphism by an
honest map is **Stage 2 and out of scope** (§10).

*(Filename note: the main document is `THEOREM.md`; the harness refuses the
literal name `REPORT.md`.)*

## Exit ledger

```text
STAGE1-COMPLEX-MAPS-CLASSIFIED
STAGE1-BOUNDARY-PATTERNS-SEALED
STAGE1-EVALUATION-RIGIDITY
STAGE1-TYPE-II-EXCLUSION-ON-Z
STAGE1-EIGHT-FORCED-SWEEPS
STAGE1-NO-GENUS-BUYING-ADMISSIBLE
STAGE1-WITNESS-SECTION-VERIFIED
TERMINUS-CENSUS-INDEPENDENTLY-REPRODUCED
STAGE1-ORDER0-WINDOW-PARITY-ONLY
STAGE1-COHERENCE-IMMUNE-FACTOR-ISOLATED
```

Machine markers: `STAGE1_COMPLEX_MAPS_VERIFY_OK` / `ALLGREEN`
(`python3 verifier.py` — **127 checks, 0 failures**: 63 per prime at
`p = 331, 661`, including the exact `Z[ζ₆]` route and the 14-check
evaluation-coherence series, plus one cross-prime identity check).

---

## 0. Set-up: the two complexes, and what a Stage-1 morphism is

**Source.** `Z` = the terminus of the `STANDARD_FORM_PW` tower over
`P(W) ≅ P⁴`. `TERMINUS_STRATA_PW` proves `Z` is the maximal De Concini–Procesi
wonderful model of the level-0 arrangement `A` (940 points, 220 lines, 55 planes
of `P(W)`), and censuses its orbit-type strata: **80 `G`-orbits, 11 076
components, 145 closure relations**.

**This packet rebuilds that census from scratch, at component level** —
every one of the 11 076 components as an explicit flag + eigen datum over `F_p`,
with its exact pointwise stabilizer, its setwise stabilizer, an orbit
transversal and its closure incidences (`scripts/s1source.py`). The rebuild
reproduces the sealed census exactly: 940/220/55, 4901 flags, 11 076
components, 80 rows with the identical `(H, dim, #comp, Stab_G(F))` multiset,
145 closure relations. **That is an independent second derivation of the strata layer of
`TERMINUS_STRATA_PW`, on the shared `psl211.py` group model (byte-identical;
see `inputs/PROVENANCE.md`), at two primes.**

**Target.** `X` = the Klein cubic. `RECEIVER_LEDGER_X` gives its orbit-type
stratification; here it is re-erected as a decorated complex with ten cells:

| cell | what | `H` | `Stab_G` | #comps | dim | genus |
|---|---|---|---|---:|---:|---:|
| `X` | the free locus | `1` | `G` | 1 | 3 | rat. conn. |
| `E` | `E_σ = X ∩ P(W⁺_σ)` | `C2` | `D12` | 55 | 1 | **1** (`j = 8192/11`, no CM) |
| `L` | `L_σ = P(W⁻_σ) ⊂ X` | `C2` | `D12` | 55 | 1 | 0 |
| `PI` | type-I vertices `L_σ ∩ L_τ` | `V4` | `V4` | 165 | 0 | — |
| `PII` | type-II points `X ∩ ℓ_V` | `V4` | `V4` | 165 | 0 | — |
| `P6` | `X^{C6}` | `C6` | `C6` | 110 | 0 | — |
| `P3` | exact-`C3` points | `C3` | `C3` | 220 | 0 | — |
| `P5a`,`P5b` | `X^{C5}`, two orbits | `C5` | `C5` | 132+132 | 0 | — |
| `P11` | `X^{C11}` | `C11` | `C11` | 60 | 0 | — |

Order-0 incidence (all **proved**, not sampled): a type-I vertex lies on exactly
two `L`'s and one `E`; a type-II point on all three `E`'s of its `V4` and on
**no** `L`; a `C6`-point on `L_t` only. `P3`, `P5a`, `P5b`, `P11` lie on **no**
`E` and **no** `L` — because `E_σ ∪ L_σ ⊆ X^σ` is *pointwise* `σ`-fixed while
those points have odd-order exact stabilizer. (This also settles
`RECEIVER_LEDGER_X` named remainder 2 in the negative: **no** exact-`C3` point
lies on any `E_σ`.)

**Definition (Stage-1 morphism).** A `G`-equivariant assignment `α` sending each
source component `F` to the target stratum receiving the generic point of its
image, together with the image variety `im(F) ⊆ X`, such that

* **(A1) band injectivity** — `H_F` fixes `im(F)` pointwise, so `im(F) ⊆ X^{H_F}`;
* **(A2) equivariance** — `Stab_G(F)` stabilizes `im(F)`;
* **(A3) genus/rationality** — `F` can only dominate a target of its own or lower
  Kodaira type: a rational `F` cannot dominate a genus-1 curve;
* **(A4) closure monotonicity** — `F ⊆ closure(F′) ⟹ im(F) ⊆ closure(im(F′))`,
  checked at **component** level over all 145 relations;
* **(A5) dominance** — the free stratum maps onto `X`.

The enumeration is exact: for a row with setwise stabilizer `S` the admissible
values of a target cell with setwise stabilizer `S_t` are the `S`-fixed points of
the `G`-set `G/S_t` carrying the right pointwise stabilizer, computed by brute
force in the 660-element group.

**Where the sealed rows enter.** The *base-locus* rows are already built into
the source: the 66 `D10`-points, the 55 `D12`-points, the 110 `A4`-points, the
55 lines `ℓ_V` and the 55 plus-planes are all members of `A`, hence blown up in
`Z`, so the complex evaluates the map on their exceptional strata and never at
the centres. The *directional* constraint at those centres — the `D10`/`V4`
pairing of eigendirections with the matching finite receivers — **is** the
`G`-equivariance (A2) and needs no separate imposition: e.g. the two `C5`-rows in
the exceptional `P³` over a `D10`-point have `Stab_G = C5`, so the number of
equivariant assignments into one `G`-orbit of `X^{C5}` is
`|N_G(C5)/C5| = |D10/C5| = 2`, i.e. the involution's pairing `χ ↔ χ^{-1}` is
matched on both sides, and `2 × 2` target orbits gives the four points of
`X^{C5}` — exactly the ledger's row. The *sweep* row H0-2 is not assumed: it is
re-derived and strengthened (Theorem 3). `X^{D12} = ∅` is the engine of that
derivation. **(F2)** is re-derived unconditionally on `Z` (Theorem 4).

---

## 1. The classification (Layer 1)

> **Theorem A (the boundary-pattern count).** The set of **stratum-coherent
> order-0 boundary patterns** — Stage-1 morphisms `𝔽(Z) → 𝔽(X)` in which the
> value of every row lying in the closure of a swept row is the *evaluation* of
> one and the same Layer-2 component (§15) — is
>
> ```
>    N₀ · ( 21 isolated classes  ⊔  2 one-parameter families ) ,
>    N₀ = 2¹¹ · 21 · 6⁸ · 4¹⁰ · 5⁴ = 47 341 191 120 814 080 000 ,
> ```
>
> i.e. **1 088 847 395 778 723 840 000** patterns in all, of which
> **994 165 013 537 095 680 000** are rigid and
> **94 682 382 241 628 160 000** move in a one-parameter family. In particular
> the set is **non-empty**: Stage 1 does not close Problem E.

**This is not a moduli of maps.** It counts order-0 boundary data — see §15 for
the reframing, for the coherence layer that produces it, and for what the
remaining global cut is. Imposing only the weaker *value-set* consistency
(arc consistency) gives `69 686 233 329 838 325 760 000`; evaluation coherence
divides that by exactly **64 = 2⁶** (§15).

The count is a product over the connected components of the **augmented**
constraint graph — the closure constraints together with the coherence
hyper-edges joining each swept row to every row in its closure:

| block | rows | joint values |
|---|---|---:|
| the coupled core (the multi-valued part of the `σ`-band: the eight `V4`-stabilised and three `C6`-stabilised `C2`-rows, `ell_V`, sixteen `V4`-rows, and the 24-row `C6`-band — the 19 `C6`-rows together with the five `C3`-rows of `Stab = C6`) | 51 | **43 008 = 2¹¹ · 21** |
| the `D10` `C2`-line | 1 | **23** (21 points + 2 one-parameter) |
| eight `C3`-rows, ten `C5`-rows, four `C11`-rows — the **coherence-immune** factor | 1 each | 6, 4, 5 |

Before coherence the core was nine 3-row blocks (2 each), one 18-row block (84)
and six free `C6`-rows (2 each): `2⁹ · 84 · 2⁶ = 2 752 512`. After coherence it
is one 51-row block with `43 008 = 2⁹ · 84` — the six `C6`-rows inside
`D_{P_σ}` lose their independence, and fifteen further rows lose all freedom
(Theorems 3′, 5′).

Six of the 80 rows sit in **no** block, having a single forced value: the free
stratum; the two dim-3 divisors `D_{P_σ}` and `D_{L⁻_σ}` and the `pt_D12` line
(forced sweeps, unique — Theorem 3); and the two rigid `V4`-rows of Theorem 5.
`51 + 1 + 8 + 10 + 4 + 6 = 80`. *(The block membership of the two dim-3 divisors
was misstated in this table before the PR #32 adjudication: being forced-unique,
they cannot lie in a multi-valued block. The count is unaffected — it is
`verifier.py` H5/H8 that carries it, not this prose.)*

The full row-by-row table is `results/section_moduli_331.txt` (identical at
`p = 661`). *Row-index caveat:* the `#nn` indices in the results files are
ordering-dependent (rows with the same `(H, dim, #comp, Stab)` are tied); rows
are identified throughout by the tuple `(H, dim, #comp, Stab_G(F), chain)`,
which is prime-independent and is what the verifier compares. Compressed:

| source rows | `H` | `Stab_G(F)` | # rows | admissible target values |
|---|---|---|---:|---|
| free stratum | `1` | `G` | 1 | `X`, dominant — **forced** |
| `D_{P_σ}`, `D_{L⁻_σ}`, the central-involution line over `pt_D12` | `C2` | `D12` | 3 | `L_σ`, **onto** — **forced, unique** |
| `C2`-rows over `V4`-, `A4`-, `D12`-, type-I centres and on `ell_V` | `C2` | `V4` | 8 | `L_σ` onto **or** one type-I vertex — **2** (five of the eight collapse to **`L_σ` onto** under coherence, Thm 3′) |
| `C2`-rows over `C6`-centres | `C2` | `C6` | 3 | `L_σ` onto **or** one of the two `X^{C6}` points — **3** |
| the `C2`-line in `E_{pt_D10}` | `C2` | `C2` | 1 | `L_σ` onto; a generic point of `E_σ` or of `L_σ` (1-parameter each); 9 type-I; 9 type-II; 2 `C6`-points — **23** |
| `C3`-rows with `Stab = C6` | `C3` | `C6` | 5 | one of the two `X^{C6}` points — **2** |
| `C3`-rows with `Stab = C3` | `C3` | `C3` | 8 | one of the 6 points of `X^{C3}` — **6** |
| all `V4`-rows | `V4` | `V4` | 18 | **type-I vertices only** — **2** (two rows: **1**) |
| `C5`-rows | `C5` | `C5` | 10 | one of the 4 points of `X^{C5}` — **4** |
| `C6`-rows | `C6` | `C6` | 19 | one of the 2 points of `X^{C6}` — **2** |
| `C11`-rows | `C11` | `C11` | 4 | one of the 5 points of `X^{C11}` — **5** |

---

## 2. The forced features, as theorems

Each is a statement about any Stage-1 morphism — any map whose equivariant
resolution factors through `Z` or an admissible refinement of it. Only the
two divisorial rows `D_{P_σ}` and `D_{L⁻_σ}` carry conclusions valid on
EVERY equivariant model of ANY map: their proofs use only strict transforms
of named divisors, rationality of `P²×P¹`, and `X^{D12} = ∅` (a rational map
from a smooth variety is defined at the generic point of every divisor). For
the other 77 rows (codim ≥ 2 in `Z`) an arbitrary map need not be defined at
their generic points, and Correction I-C (`theory/FIX_I_bcomplex.md`) shows
non-admissible models can carry strata these theorems do not classify.

### Theorem 1 (rigid rationality; the genus never appears)

> Every stratum of `Z`, and of **every admissible refinement** of `Z`, is
> rational. Consequently no non-free stratum of any admissible refinement
> admits a non-constant map to any `E_σ`.

*Proof.* `TERMINUS_STRATA_PW` Thm 1–3 exhibit each stratum of `Z` as a smooth
blowup of a product of projective spaces. An admissible refinement blows up a
smooth `G`-invariant centre which is a union of closures of strata; the new
strata are the eigen-subbundles of `P(N)` over strata of the centre, hence
projective bundles over rational bases, hence rational; and strict transforms
stay rational. Induct on the number of rounds. A rational variety admits no
non-constant map onto a genus-1 curve. ∎

### Theorem 2 (finiteness of images)

> For every source row `R` with `H_R ∉ {1, C2}` the image is a **single point**
> of `X^{Stab_G(F)}`. For `H_R = C2` the image is a point of `X^{C2}` or all of
> `L_σ`. The free stratum is the only row with 3-dimensional image.

*Proof.* By the receiver dichotomy (`RECEIVER_LEDGER_X` §5.2), `X^H` is finite
for every `H ∉ {1, C2}`; the image of an irreducible variety in a finite set is a
point, fixed by `Stab_G(F)`. For `H = C2`, `X^{C2} = E_σ ⊔ L_σ` is 1-dimensional
and the image is irreducible, so it lands in one of them; landing onto `E_σ` is
excluded by Theorem 1. ∎

### Theorem 3 (three forced sweeps — H0-2 strengthened)

> Let `σ` be an involution. In **every** Stage-1 morphism the three rows of `Z`
> whose setwise stabilizer is `D12`, namely
>
> * `D_{P_σ} ≅ P(W⁺_σ) × P(W⁻_σ)` (dim 3, 55 components),
> * `D_{L⁻_σ} ≅ P(W⁻_σ) × P(W⁺_σ)` (dim 3, 55 components),
> * the central-involution line `P(W⁻_σ) ⊂ E_{pt_{D12}}` (dim 1, 55 components),
>
> map **onto** `L_σ`, surjectively, and the choice of `L_σ` is unique. No other
> row is forced to be non-constant.

*Proof.* `Stab_G(F) = D12 = N_G(⟨σ⟩)`. A constant image would be a `D12`-fixed
point of `X`, and `X^{D12} = ∅` (`STRATA_EXACT.md:123`, replayed here as the
non-vanishing of `F` at the `D12`-character point). So the image is
1-dimensional inside `X^{⟨σ⟩} = E_σ ⊔ L_σ`, hence all of `E_σ` or all of `L_σ`;
Theorem 1 kills `E_σ`. Uniqueness of `σ`: `⟨σ⟩ = Z(D12)` pins the conjugate. ∎

The sealed `H0-2` is the first of these three. The other two are new. Note the
proof needs **no** funnel, **no** fabulousness and **no** external import: it is
rationality + `X^{D12} = ∅` + closure.

### Theorem 4 (type-II exclusion — (F2), unconditionally, for all 18 rows)

> In every Stage-1 morphism, **all 18** `V4`-rows of `Z` (2 970 components) map
> to **type-I** vertices. **No type-II point of `X` is the image of any
> `V4`-stratum of `Z`.**

*Proof.* Each of the 18 `V4`-rows lies in the closure of `D_{P_σ}` or of
`D_{L⁻_σ}` for some involution `σ` (machine-verified over all 145 relations at
component level). By Theorem 3 that divisor's image is `L_σ`; closure
monotonicity puts the `V4`-row's image on `L_σ`. Type-II points lie on no `L`
(`ℓ_V ∩ L_τ = ∅`, `DUNCAN_CORNER_F2` W2.3b; proved and carried as a rule here, not replayed). ∎

`DUNCAN_CORNER_F2`'s **(F2)** is the same exclusion at **one** stratum — the new
divisor `E_s^V` of the corner refinement `Z⁺` — and rests on the
EXTERNAL-UNVERIFIED imports `thm:pairs` / `prop:rcc_total`. Theorem 4 covers a
strictly larger set of rows (all 18 `V4`-rows of the terminus) with **no**
external import; it does **not** cover `Z⁺`'s new divisor (§7).

### Theorem 5 (the `v_σ` rule, and two rigid rows)

> Write `v_τ` for the type-I vertex of a `V4` `K` that is the `+1`-eigenvector of
> `τ ∈ K`. If a `V4`-row's chain contains the boundary divisor of `σ` (`P_σ` or
> `L⁻_σ`), its image is **never** `v_σ`. Exactly two of the three vertices
> survive per such `σ`. Two of the twelve 0-dimensional `V4`-rows over the
> `D12`-points carry **two** independent `σ`-constraints and are therefore
> **pinned to a unique vertex**.

*Proof.* `v_σ` is the one type-I vertex of `K` lying on `E_σ` and not on `L_σ`
(sign pattern `(+,−,−)`, `RECEIVER_LEDGER_X` §4.1, replayed). Theorem 4's
argument gives `im ⊆ L_σ`. Two constraints for two distinct involutions
`σ ≠ σ′` of the same `V4` leave `L_σ ∩ L_{σ′}` = the single remaining vertex. ∎

### Theorem 3′ (five more forced sweeps, from evaluation coherence)

> Impose evaluation coherence (§15). Then **five further rows sweep in every
> Stage-1 morphism**, so that **eight** rows sweep unconditionally:
>
> * the three of Theorem 3, plus
> * `M^V_τ`, the `C2`-surface on `ℓ_V` (dim 2, 165 components, `Stab = V4`) —
>   the corner packet's T3 centre;
> * the two `C2`-curves over the `A4`-points (dim 1, 165 each);
> * the two `C2`-curves over the `D12`-points with `Stab = V4` (dim 1, 165 each).
>
> The remaining three sweep-capable `V4`-stabilised `C2`-rows are not free
> either: the two over the type-I `V4`-points are **locked to each other**
> (both sweep, or both contract), and only 4 of the 2⁸ sweep-patterns on the
> eight `V4`-stabilised `C2`-rows survive.

*Proof (machine, both primes).* `D_{P_σ}` sweeps `L_σ` (Theorem 3) via some
component of `M_{D_{P_σ}}`; §15's rigidity theorem makes the value of each of
its 18 multi-valued children a determinate function of that component; the
resulting joint image has 128 elements out of the 2¹⁸ that value-set
consistency allows. Intersecting with the closure constraints of the eight
triangle blocks leaves, for each of the five rows listed, only the sweeping
value. `verifier.py` H11, H12. ∎

### Theorem 5′ (twelve of the eighteen `V4`-rows are rigid)

> Under evaluation coherence, **12 of the 18 `V4`-rows have a unique value** — a
> single type-I vertex: the two on `ℓ_V < P_σ`, the four over `A4`-points in
> `P_σ`, and six of the eight over `D12`-points in `P_σ` (Theorem 5 already gave
> two of those six by pure order-0 reasoning). Only six `V4`-rows retain a
> binary choice, and they are correlated: the twelve multi-valued `V4`-children
> of `D_{P_σ}` realize **2** joint tuples, not 2¹².

---

### Theorem 6 (the `C6` pinning = the isogeny packet's Theorem 4, on the nose)

> `X^{C6}` is exactly the pair of `ρ`-fixed points of `L_t` (`C6 = ⟨t⟩ × ⟨ρ⟩`),
> freely swapped by the residual `C2 = D12/C6`. Every source row whose setwise
> stabilizer is `C6` — the 19 `C6`-rows, the 5 `C3`-rows with `Stab = C6`, and
> (when constant) the 3 `C2`-rows with `Stab = C6` — maps into that pair.

*Proof.* `X^{C6} = X^{⟨t⟩} ∩ X^{⟨ρ⟩}` sits on `L_t` (`RECEIVER_LEDGER_X` §3.2);
`ρ` acts on `L_t ≅ P¹` with exactly two fixed points, and `L_t ⊂ X`. Machine
check: the two `X^{C6}` points **are** those two `ρ`-fixed points, at both
primes. Then (A1)+(A2). ∎

This is `PHI_SEXTIC_ISOGENY` Theorem 4 verbatim on the target side: "`Φ` sends
`{P₁,P₂}` bijectively onto the two `ρ`-fixed points of `L_σ`". Its cell
(`C_σ ⊂ V14`, genus 1) does not occur in this source complex; what does occur is
its target classification, and it reappears unchanged.

### Theorem 7 (exactly one elliptic door)

> Exactly **one** of the 80 rows can have its generic point land on an `E_σ`:
> the `C2`-line inside the exceptional divisor over a `D10`-point
> (dim 1, 330 components — the *only* row of the whole census whose setwise
> stabilizer is as small as its pointwise stabilizer `⟨σ⟩`). Every other row's
> constant value is forced into a deeper cell or onto `L_σ`.
>
> Consequently: **Stage-1 sections exist in which no stratum lands in the `E`
> cell at all** (machine-verified), but **no** section avoids the elliptic
> curves entirely — every section sends all 18 `V4`-rows to type-I vertices, and
> each type-I vertex lies on exactly one `E_σ`.

*Proof.* A constant value must be fixed by `Stab_G(F)`. For a generic point of
`E_σ` or `L_σ` the stabilizer is exactly `⟨σ⟩`, so `Stab_G(F) = ⟨σ⟩` is
necessary; among the 80 rows only the `D10` row satisfies it. ∎

### Theorem 8 (the image inventory)

> The only positive-dimensional images occurring in any Stage-1 morphism are
> `X` (from the free stratum, by dominance) and the 55 lines `L_σ`. Exactly 15
> rows *may* sweep — precisely the 15 `C2`-rows — and at least **8** *must*:
> three by pure order-0 reasoning (Theorem 3) and five more by evaluation
> coherence (Theorem 3′). The maximum, 15, is realized by the witness section;
> the minimum, 8, is realized too. **Value-set consistency alone would have
> admitted a 3-sweep section; no such section is stratum-coherent**
> (`verifier.py` D2, D4, H12, H14).

---

## 3. Layer 2 — the per-cell moduli

By Theorem 8 the whole of Layer 2 is: for each sweeping row `F`, classify the
`Γ = Stab_G(F)`-equivariant dominant maps `F ⇢ L_σ = P¹`. Writing
`F = P(A₀) × … × P(A_k)` (blowups are birational, so they do not change the
moduli of rational maps), a map of multidegree `a` is a non-zero element of the
`ψ`-eigenspace, for a linear character `ψ` of `Γ`, of

```
S(a) = Sym^{a₀}(A₀*) ⊗ … ⊗ Sym^{a_k}(A_k*) ⊗ W⁻_σ ,
```

modulo scalars, minus the (proper closed) non-dominant locus. `results/
layer2_moduli_331.txt` tabulates `dim S(a)^{Γ,ψ}` for all 15 sweeping rows,
computed by exact linear algebra over `F_p` (`p ∤ |Γ|`, so the dimensions are the
characteristic-0 ones). Highlights:

* **`D_{P_σ} = P(W⁺) × P(W⁻)`, `Γ = D12`.** Non-empty in bidegree `(a,b)` for
  every `(a,b) ≠ (0,0)`; e.g. `(0,1) → 1`, `(1,0) → 1`, `(1,1) → 2`,
  `(3,1) → 7`, `(3,3) → 13`, `(5,5) → 42`. **The residual `S3` acts on `W⁺` as
  `triv ⊕ std` and on `W⁻` as `std`, and `std ⊗ sgn ≅ std`, so both linear
  characters give the same dimension** — the moduli always has two components of
  equal dimension.
* **`D_{L⁻_σ} = P(W⁻) × P(W⁺)`, `Γ = D12`.** Contains the *linear* solutions:
  bidegree `(1,0)` (dim 1) is the projection onto `L_σ`; bidegree `(0,1)`
  (dim 1) is the `S3`-projection `W⁺ = triv ⊕ std ↠ std ≅ W⁻`.
* **The `D12`-point line `P(W⁻_t) ⊂ E_{pt_{D12}}`, `Γ = D12`.** Here source and
  target are the *same* `S3`-representation `P(std)`; the moduli of degree-`n`
  equivariant self-maps has dimension `1,1,1,2,2,…` for `n = 1,…,5` per
  character, and `n = 1` (the identity) is a solution. **Contrast with the
  isogeny packet**: for a genus-1 source with a free `ρ`, every equivariant map
  to `L_σ` has degree divisible by 3 (`PHI_SEXTIC_ISOGENY` Thm 3(b)). For this
  rational source there is no such divisibility — degree 1 occurs. The
  divisibility is a property of the *source*, not of `L_σ`.
* All constant cells (every non-sweeping row) have moduli = a single reduced
  point: the value is the assignment itself, with no parameter.

---

## 4. Layer 3 — order-0 incidence and the corrected window arithmetic

**Order-0 incidence** is implemented exactly: all 145 closure relations are
imposed at component level, with the transversal bookkeeping, and they are what
produce Theorems 4–6 and the block structure of §1. Nothing beyond order 0 is
developed here.

**The multidegree dictionary.** Let `T ∈ (Sym^d W* ⊗ W)^G` be a landing
covariant of degree `d` and let `m = ord_{P_σ}(T⁻)`. In the `σ`-bigrading
`W* = W^{+*} ⊕ W^{-*}` the leading minus-half datum is the `(d−m, m)` piece

```
T_m ∈ Sym^{d−m}(W^{+*}) ⊗ Sym^{m}(W^{-*}) ⊗ W⁻ ,
```

and, because `T` is `G`-invariant and `D12 = C_G(σ)` preserves the bigrading,
`T_m` is `D12`-**invariant (no character twist)**. `T_m` is exactly the
multidegree-`(d−m, m)` map realizing the forced sweep of `D_{P_σ}` (Theorem 3).
Set

```
N(d,m)  := dim ( Sym^{d−m}(W^{+*}) ⊗ Sym^{m}(W^{-*}) ⊗ W⁻ )^{D12} ,
N⁺(d,m) := dim ( Sym^{d−m}(W^{+*}) ⊗ Sym^{m}(W^{-*}) ⊗ W⁺ )^{D12} .
```

> **Theorem 9 (order-0 window).**
> (i) `σ` acts on the first module by `(−1)^{m+1}` and on the second by
> `(−1)^m`. Hence `N(d,m) = 0` for **`m` even** and `N⁺(d,m) = 0` for **`m`
> odd**: the minus half's order along a plus-plane is always **odd** and the
> plus half's is always **even**. This is the character-theoretic form of the
> sealed parity theorem H0-1, obtained with no geometry.
> (ii) `N(d,m) > 0` for **every** odd `m ≤ d ≤ 45` — computed exactly in
> `Z[ζ₆]` and confirmed mod 331 and mod 661. **The order-0 leading-datum count
> therefore imposes no exclusion beyond the parity.**

Sample exact values: `N(1,1)=1`, `N(3,1)=4`, `N(3,3)=1`, `N(5,1)=10`,
`N(7,1)=19`, `N(12,3)=73`, `N(19,7)=243`, `N(25,3)=368`, `N(30,1)=310`,
`N(31,1)=331`, `N(34,1)=397`, `N(34,3)=704`, `N(43,1)=631`, `N(43,7)=1875`.

**The corrected profile constants used** (Correction H1-D, `NOTEBOOK.md:605`,
`theory/FIX_H1_coupling.md` §8 — **not** the numbers still printed in
`theory/FIX_V_construction.md`, which predates the correction):

| quantity | current value | superseded value |
|---|---|---|
| multi-order at the `V4`-lines | `(r; m,m,m)`, `m` **odd** | unchanged |
| cone bound | `r ≥ (3m+1)/2` | unchanged |
| line degree | `n = d − r ≥ 2e`, `e = r − m` | ~~`n ≥ 6e`~~ |
| degree bound | **`d ≥ 3r − 2m`** | ~~`d ≥ 7r − 6m`~~ **WITHDRAWN** |
| `Λ` vanishing at `D12`-points | order `2e` at its **own** point only | ~~`≥ 2e` at all three~~ |
| unconditional cutoff | **`d ≤ 30` empty** (31–33 near-complete, all computed rows zero) | ~~`d ≤ 35`~~ |
| first open window | **`d = 34` via `(m,r) = (1,6)`, `n = 28`** | ~~`d = 36`~~ |

Two consequences worth recording, both arithmetic:

* At the first open window `(d, m, r, n) = (34, 1, 6, 28)`, the plus-plane
  leading datum lives in a **397-dimensional** `D12`-invariant space. Order 0 is
  nowhere near rigid there; the sieve's bite at `d = 34` must come from higher
  order or from the line-degree bookkeeping, not from the sweep datum.
* `FIX_V_construction.md` §2 states "first `(1,7)`-window: `d = 43`". That figure
  used the withdrawn `d ≥ 7r − 6m`. Under the corrected bound the `(1,7)`
  profile — where the `FIX-D2` solvable jets live — is admissible from
  **`d ≥ 3·7 − 2·1 = 19`**, and `N(d,1) > 0` for every such `d`. The `(3,6)`
  profile is admissible from `d ≥ 12` (old: 24). **This packet does not re-run
  the slice sweep; the sealed empirical cutoff `d ≤ 30` stands and is what
  actually excludes those degrees.**

The remaining sealed row, "121-point `≥ 3m+1`" (`RESOLUTION.md:2721`), concerns the
121 multiple points of the 55-plane arrangement, which ARE the 66 `D10`- and 55
`D12`-points (`certificates/STRATA_MACHINE_INPUT_AUDIT.md:64`,
`HANDOFF.md:1704-1712`); the `≥ 3m+1` gate is a jet-order statement, not an
order-0 one, and this packet does not consume it. Whether it tightens the
corrected window is left open for Stage 2.

---

## 5. The witness section

`results/witness_331.txt` (identical structure at 661) records the explicit
**maximal-sweep** section, machine-verified against all 145 closure relations,
0 violations:

* free stratum `→ X`, dominant;
* **all 15 `C2`-rows sweep**, each onto its own `L_σ` (in particular the three
  forced ones);
* all 18 `V4`-rows `→` type-I vertices (never type-II);
* 24 rows `→ X^{C6}`; 8 rows `→` exact-`C3` points; 10 rows `→ X^{C5}`;
  4 rows `→ X^{C11}`;
* **no** stratum lands in the `E` cell; **no** stratum lands on a type-II point.

The maximal-sweep witness is **evaluation-coherent** (`verifier.py` H13): for
each of its 15 sweeping rows there is a component of that row's Layer-2 moduli
whose evaluations reproduce the witness's values at every row below it.

Two further sections are verified to exist:

* a section with **no** landing on any `E_σ` (D5);
* a **minimal-sweep** section — but the minimum is **eight** rows, not three.
  Value-set consistency alone admits a 3-sweep section (D4); evaluation
  coherence does not (H14), because `M^V_τ`, the two `A4`-point curves and the
  two `D12`-point curves are forced to sweep (Theorem 3′).

The witness realizes the sealed local data where they apply: the sweep of
`D_{P_σ}` is `H0-2`; the sweep of the `D12`-point line is the order-0 shadow of
`FIX-D2`'s non-degenerate branch at `c_σ`; the `ℓ_V` band that `T5`'s explicit
`A₄`-equivariant family `Q_{B,ℓ}` populates (rows `ell_V`, `ell_V<P_σ` ×2,
`pt_A4<ell_V` ×4) is populated in the witness as well.

---

## 6. The extension-variable report

**EV1 — does a section need a genus-buying centre?** **No, and it cannot have
one.** By Theorem 1 no admissible refinement of `Z` — blowup in a smooth
`G`-invariant centre that is a union of closures of strata, iterated — ever
produces a positive-genus stratum. So the extension variable "the refinement
buys genus, at such-and-such a centre" is identically **off**: it cannot be
switched on inside the refinement calculus the census uses, and therefore **no
Stage-1 morphism, on any admissible refinement, has a non-free stratum
dominating an `E_σ`.**

*Honest scope.* This is a statement about the admissible class. It does **not**
say that `P(W)` carries no `G`-invariant genus-1 curve at all; blowing up such a
curve (if one exists) is not an admissible refinement of a stabilized-strata
model, and no such centre appears anywhere in the tower. Deciding the general
question is out of scope.

**EV2 — can a section exist with no `X`-side elliptic landing at all?**
**In the cell sense yes; in the set sense no.** A section in which no stratum's
generic point lies in the `E` cell exists and is the generic case (only the
`D10` `C2`-line has that option at all, Theorem 7). But every section sends all
18 `V4`-rows to type-I vertices, and every type-I vertex lies on exactly one
`E_σ`; so the elliptic curves always receive points. The precise dichotomy:
`E_σ` is always met, never dominated, and its *open* part is optional.

**EV3 — is any row forced onto `E_σ`?** No. Coverage of `E_σ` is supplied by the
free stratum (a proper resolution of a dominant map is surjective), which is
unconstrained at this layer — as the brief instructs, no constraint is invented
there.

---

## 7. The corner refinement `Z⁺`, and where (F2) still does work

`TERMINUS_STRATA_PW` §8: `Z⁺ = Bl_M Z`, `M` the orbit of the 165 surfaces
`M^V_τ`. The three consumed rows are `M^V_τ` and the two `V4`-curves on
`ell_V < P_σ` — **exactly one constraint block of §1**, the triangle
`{ell_V, ell_V<P_σ, ell_V<P_σ}` with its 2 joint values. They are replaced by the
new divisor `E_τ^V` (`C2`, dim 3, 165, `Stab = V4`) and the two fabulous corners
(`V4`, dim 2, 165 each).

* The other **77** rows are strict transforms with unchanged decorations
  (Thm 2.1(i)) and unchanged relations to `D_{P_σ}`, `D_{L⁻_σ}`; **their whole
  Stage-1 classification, Theorems 3–8 included, carries over verbatim.** In
  particular the type-II exclusion still holds for the 16 surviving `V4`-rows.
* The new divisor `E_τ^V` has `Stab_G = V4`, **not** `D12`, so Theorem 3 does not
  apply and it is *not* forced to sweep; and it is not below `D_{P_σ}`, so
  Theorem 4's argument does not reach it. Its order-0 options are
  `{L_τ onto} ∪ {3 type-I} ∪ {3 type-II}` — seven.
* **This is exactly the gap `DUNCAN_CORNER_F2`'s (F2) fills**, and (F2) is
  conditional on the EXTERNAL-UNVERIFIED `thm:pairs` / `prop:rcc_total`. Granting
  (F2), the seven options drop to four, and the two fabulous corners inherit the
  type-I restriction (they lie in the closure of `E_τ^V`, so their value is
  either a point of `L_τ` or the constant value of `E_τ^V`).
* Not granting it, the honest statement is: **at order 0 the corner refinement
  adds three rows whose type-II options this packet cannot remove.**

We did **not** rebuild `Z⁺` at component level; the three-row delta is consumed
from the sealed census, and the statements above are the order-0 consequences of
that delta plus §1. This is flagged as Tier 3.

---

## 8. Anchors (all four demanded by the brief)

| # | anchor | status |
|---|---|---|
| 1 | the sweep rows have solutions (the witness section exists) | **PASS** — the witness has 0 violations over 145 relations; three independent sections verified (maximal sweep, minimal sweep, no-`E` sweep) |
| 2 | the isogeny packet's cell classification appears verbatim where its cell occurs | **PASS** — its Theorem 4 (`X^{C6}` = the two `ρ`-fixed points of `L_t`, swapped by `D12/C6`) is reproduced exactly (Theorem 6) and is what pins all 24 `C6`-band rows; its Theorem 3(a) (`X^σ` has no `S3`-fixed point) is `X^{D12} = ∅`, the engine of Theorem 3. Its own cell (`C_σ`, genus 1) does **not** occur as a source stratum, by Theorem 1 |
| 3 | the T5 / FIX-D2 local witnesses embed in some section | **PASS** at order 0 — the `ell_V` band that `T5`'s `Q_{B,ℓ}` populates (7 rows) and the `D12`-point band where `FIX-D2`'s germ at `c_σ` lives (13 rows) both have non-empty moduli in the classification, and the witness section assigns them values. **Caveat**: `T5`/`FIX-D2` are jet-level (orders `2e`, `2e+1`, …); the complex-level section only sees order 0, so this is a consistency check, not a lift |
| 4 | no section violates (F2), the base-locus rows, or `X^{D12} = ∅` | **PASS** — (F2)'s exclusion holds unconditionally at all 18 `V4`-rows (Theorem 4); `X^{D12} = ∅` is enforced (no `D12`-stabilized row has any constant option); the base-locus hypotheses `X^{D12} = X^{A4} = X^{D10} = X^{F55} = ∅` and `dim W^{C3} = dim W^{C5} = 1`, `dim W^{V4} = 2` are all replayed at both primes |

No anchor failed; nothing was adjusted.

---

## 9. Verification

```sh
python3 scripts/produce.py 331 661            # classification + tables + witness
python3 scripts/produce_coherence.py 331 661  # the evaluation-coherence layer
python3 scripts/run_layer2.py <cache> results/layer2_moduli_331.txt
python3 verifier.py                    # 63 checks per prime + exact route; ALLGREEN
```

`verifier.py` rebuilds everything from the 660 matrices, at `p = 331` and
`p = 661`, and checks:

* **A1–A9** group and source complex: `|G| = 660` and its order profile; the
  arrangement `940/220/55` and its closure under intersection; 11 076 components
  in 80 orbits; the row multiset **equal to the sealed `TERMINUS_STRATA_PW`
  census** (carried as `inputs/terminus_t2_strata.json`); **145** closure
  relations equal to the sealed poset; every exact stabilizer abelian;
  `#comp · |Stab| = 660` for every row.
* **B1–B8** target complex: cell sizes; `L_σ ⊂ X` at all `p+1` points; the 165
  type-I vertices on `X`, each on two `L`'s and one `E`; the 110 `C6`-points on
  `X` and on `L_t`; `X^{D12} = X^{A4} = X^{D10} = ∅`; the base-locus dimension
  hypotheses.
* **C1–C12** Layer 1: type-II exclusion on all 18 `V4`-rows; the `v_σ` kill
  rule; exactly 3 forced sweeps and 15 possible ones; no row dominates `E`;
  exactly one row with an `E`-cell option; no constant value for a
  `D12`-stabilized row; the `C6` pinning; the block structure
  `9 × (3 rows, 2 values) + 1 × (18 rows, 84 values)`; and the
  **pre-coherence** total `69 686 233 329 838 325 760 000` with its
  factorization (retained as the intermediate against which H7 measures the
  coherence cut).
* **D1–D5** the witness sections (0 violations; maximal, `E`-free; and D4 records
  that arc consistency *alone* would have admitted a 3-sweep section).
* **E1–E7** the four anchors.
* **F1–F8** Layer 2 / Layer 3: the parity theorem in both directions; `N(d,m) > 0`
  for all odd `m ≤ d ≤ 45`; the quoted window values; **§14's audit-derived
  closed form for `N(d,m)`, checked against the exact route on every odd
  `m ≤ d ≤ 45` and then used for the all-`d` positivity** (F7, F8 — added by
  the PR #32 adjudication, which found §14's strengthening asserted but
  unchecked); **agreement between the
  mod-`p` character route and the exact `Z[ζ₆]` route**; and agreement between
  the Layer-2 `F_p` linear-algebra module dimensions and the Layer-3 character
  dimensions on the `P_σ` row (two entirely independent implementations).
* **H1–H14** evaluation coherence (§15): **rigidity** (no evaluation span is ever
  2-dimensional — 0 failures over every sweep row, component and child); the
  per-chain surjectivity verdicts (exactly two fail, and they are the two dim-3
  divisors, with images 128 of 262 144 and 64 of 128); the coherent count
  `1 088 847 395 778 723 840 000` and its factorization; the reduction factor
  `64 = 2⁶` against the arc-consistent count; the 51-row coupled core with
  43 008 patterns; the coherence-immune factor and the proof that each of its
  rows has the free stratum as its only proper parent; the fifteen newly rigid
  rows (5 forced sweeps + 10 pinned `V4`-rows); the witness section's coherence;
  and the non-coherence of the 3-sweep section.
* **G1** the two primes give identical classifications.

Artifacts: `results/coherence_331.json`, `results/coherence_661.json`,
`results/coherence_331.txt`, `results/coherence_661.txt`,
`results/layer1_331.json`, `results/layer1_661.json`,
`results/section_moduli_331.txt`, `results/section_moduli_661.txt`,
`results/witness_331.txt`, `results/witness_661.txt`,
`results/layer2_moduli_331.txt`, `results/verifier_stdout.txt`.

---

## 10. The honest Stage-2 boundary

Stage 1 is **not** an existence statement about maps. What it delivers is: the
complete, finite list of order-0 landing patterns, with the forced features
above. What Stage 2 needs, against a *specific* section:

1. **All-order jets.** The complex-level section fixes order 0 only. Stage 2 must
   develop the jets along each swept `L_σ` and at each pinned point to the orders
   the sealed profile demands (`m` odd, `r ≥ (3m+1)/2`, `n ≥ 2e`, `Λ` of order
   `2e` at its own `D12`-point), and check the equalizer identities. That is the
   `FIX-D2`/`FIX-H1` layer; §4 shows order 0 alone excludes nothing beyond
   parity.
2. **Algebraization.** Jet and level solvability never implies a polynomial map
   (the **T5 gate**, `theory/FIX_T_gate.md:414–422`; the C1 calibration). A
   Stage-1 section plus solvable jets is boundary data, not a germ, and a germ is
   not a map.
3. **Dominance.** Even given a covariant tuple, dominance has to be certified
   separately ([E17]'s automatic-dominance route).
4. **The degree window.** The sealed slice sweep says `d ≤ 30` is empty and
   `d = 34` is the first open window; the section-moduli table is
   degree-blind and does not by itself select a `d`.
5. **The `Z⁺` corner rows** (§7): three rows whose type-II options are removed
   only by the conditional (F2).
6. **The cross-`V4` coupling through one `σ`** (`FIX_III_cosheaf.md` §6(iii)):
   the genuine remaining coupling identified by FIX-H0. Order 0 does not see it;
   it lives at the jet level.

---

## 11. Honesty tiering

**Tier 1 — complete and exact, independent of any prime.** The definition of a
Stage-1 morphism and constraints (A1)–(A5); Theorems 1, 2, 3, 7 (their proofs
use only rationality, the receiver dichotomy, `X^{D12} = ∅` and closure);
Theorem 9(i) (the parity, pure character theory, exact in `Z[ζ₆]`);
**Theorem 15.1 (evaluation rigidity)** — a two-line character argument, no
computation.

**Tier 2 — complete over all rows, read off at two split primes (331, 661,
both coprime to 660) and agreeing row-for-row.** The component-level rebuild of
the census; the 145 relations; every entry of the section-moduli table; Theorems
4, 5, 6, 8; the block structure and both counts (arc-consistent and coherent);
the witness sections; the Layer-2 dimension tables; the per-chain surjectivity
verdicts of §15.2 and Theorems 3′, 5′; Theorem 9(ii) for `d ≤ 45` (exact in
`Z[ζ₆]`, so Tier 1 for the listed range, but the range itself is finite —
§14 removes the range restriction).

**Tier 3 — flagged.**

1. The `Z⁺` delta (§7) is consumed from the sealed census, not rebuilt at
   component level; the three new rows' options are derived from that delta plus
   order-0 closure, and their type-II exclusion remains conditional on (F2)'s
   external imports.
2. Theorem 1 is proved for *admissible* refinements (blowups in unions of
   closures of strata). The general question — does `P(W)` carry a `G`-invariant
   positive-genus centre whose blowup is still a legal model? — is not decided
   here.
3. The type-II and exact-`C3`/`C5`/`C11` point cells are carried as abstract
   `G`-sets (they are not `F_p`-rational at 331 or 661 — `RECEIVER_LEDGER_X`
   §3.1, FIX-A1 item 9), with their incidence rules *proved* rather than sampled
   (odd-order stabilizer ⟹ off every `E_σ` and `L_σ`; type-II on all three `E`'s
   of its `V4` and no `L`). The rules are the load-bearing input, not the
   coordinates.
4. Anchor 3 is an order-0 consistency check with `T5`/`FIX-D2`, not a lift of
   their jets.
4b. The coherence layer carries its own Tier-3 items — the degree bound on the
   Layer-2 tables, the sampled generic points of `π(F_R)`, and the fact that
   coherence is imposed stratum-locally rather than globally. They are stated
   in §15.6 and are **the** honest limit of the new count.
5. ~~`N(d,m) > 0` is verified for `d ≤ 45`; we have no proof for all `d`.~~
   **WITHDRAWN** by §14's closed formula (as that section already states), and
   since the PR #32 adjudication the withdrawal is machine-backed: the closed
   form is checked against the exact `Z[ζ₆]` route on every odd `m ≤ d ≤ 45`
   at both primes (`verifier.py` F7) and the all-`d` positivity is checked as
   arithmetic (F8). Theorem 9(ii) is Tier 1 for every `d`.

---

## 12. Dependencies

| import | used for | grade |
|---|---|---|
| `TERMINUS_STRATA_PW` (branch `agent/terminus-strata-pw-20260810`) | the source census; the `Z⁺` delta | **re-derived here independently at component level**; delta consumed as sealed |
| `RECEIVER_LEDGER_X` (branch `agent/receiver-ledger-x-20260810`) | the target complex; the receiver dichotomy; Corollary C3 | rows re-verified at two primes; dichotomy consumed |
| `DUNCAN_CORNER_F2` | (F2); `ℓ_V ∩ L_τ = ∅`; the corner inventory | (F2) **superseded on `Z`** by Theorem 4 (unconditional, 18 rows); still needed on `Z⁺` |
| `PHI_SEXTIC_ISOGENY` | the per-cell method; Thms 3(a), 3(b), 4 | Thm 4 reproduced (Theorem 6); Thm 3(b)'s divisibility shown to be source-specific |
| `FIX_III_cosheaf.md` | the CSP this instantiates; Thm 5.1 (section-from-map); H0-1, H0-2 | H0-2 **strengthened** (Theorem 3); H0-1 **re-derived** by character theory (Theorem 9(i)) |
| `FIX_H1_coupling.md` §8 (Correction H1-D), `NOTEBOOK.md:499,605,3177` | the corrected profile constants | consumed as corrected |
| `theory/FIX_V_construction.md` | the construction blueprint | **its §1–§2 numbers are pre-correction**; superseded values listed in §4 |
| `theory/FIX_T_gate.md` T5 | the no-algebraization discipline | consumed |
| `goal_runs_after_354a548/FIX_D2_TERMINAL_SYSTEM` | the `(7;1,1,1)` / `(6;3,3,3)` jet survivors at `c_σ` | consumed as order-0 anchor only |
| `certificates/STRATA_EXACT.md:123` | `X^{D12} = ∅` | replayed |
| `thm:pairs`, `prop:rcc_total` (Duncan) | **only** (F2) on `Z⁺` (§7) | **EXTERNAL-UNVERIFIED** |

## 13. Not claimed

* **No headline.** Problem E remains OPEN. A non-empty Stage-1 moduli is not an
  existence statement about maps — the converse direction (section ⟹ map) is not
  claimed anywhere and is false as stated (`FIX_III_cosheaf.md` §3).
* No statement about which degree `d`, if any, carries a landing covariant.
* No jets beyond order 0, and no algebraization.
* No claim that this terminus or its refinements are canonical or minimal.
* No re-run of the slice sweep: the cutoff `d ≤ 30` and the window `d = 34` are
  consumed from the sealed FIX-P2 record, not re-derived.


## 14. Audit addendum (2026-08-10, adversarial audit applied before registration)

An independent adversarial audit (director-commissioned) re-derived the value
sets, the factorization (zero cross-block constraints; the count reproduced),
the Layer-2 tables, the window arithmetic against Correction H1-D, and the
census agreement, finding no numerical error. Edits applied on its orders:
the scope corrections in §§0, 2, the 121-point identification in §4, the
provenance qualifiers, and the two exit renames (`-ON-Z`, `-ADMISSIBLE`).
Clarifications it mandated: (i) TIERING — the geometric cores of Theorems
1-3, 7, 8 are prime-free, but their quantification over the 80-row census is
Tier-2 input (two split primes + exact chart layer); read §11 accordingly.
(ii) Verifier check A4 is constructional (the arrangement is
intersection-closed by construction); it is a regression guard, not a proof.
(iii) STRENGTHENING (audit-derived, adopted): Theorem 9(ii) holds for ALL
`d`, not only `d ≤ 45`: with `W⁺ = triv ⊕ std`, `W⁻ = std`,
`N(d,m) = (1/3)[C(d−m+2,2)·(m+1) − ε]`, `ε = [3 | d−m]·c(m)`,
`c(m) = 1, −1, 0` for `m ≡ 0, 1, 2 (mod 3)`; since `C(d−m+2,2)(m+1) ≥ 2`
for `m ≥ 1` and `ε ≤ 1`, `N(d,m) ≥ 1` for every odd `m ≤ d`. Tier 3(5) is
withdrawn. Audit verdict: REGISTER-WITH-EDITS; all required edits applied.

## 15. Coherence addendum (2026-08-10, second director correction order)

### 15.1 The gap, and the repair

The count of §1 as first published treated the blocks of the constraint graph as
independent. That is right for the constraint that was imposed — **value-set**
consistency, `im(F) ⊆ closure(im(F'))` — but every stratum-level assignment in a
Stage-1 morphism is the *restriction of a single morphism*, and the
stratum-local part of that coherence is stronger:

> if a row `S` sweeps its line via a Layer-2 morphism `φ`, then the value at
> every deeper row `R ⊂ cl(S)` is the **evaluation** `φ|_R`, not a free choice
> inside `L_σ`.

That is now imposed. `scripts/s1coherence.py` computes the evaluations exactly,
two independent ways; `scripts/s1recount.py` recounts.

> **Theorem 15.1 (evaluation rigidity).** Let `S` be a sweep-capable row,
> `Γ = Stab_G(F_S)`, and let `R ⊂ cl(F_S)` be a deeper row with pointwise
> stabilizer `H_R`. Fix a connected component `M_S(a, ψ)` of the Layer-2 moduli
> (multidegree `a`, linear character `ψ` of `Γ`). Then `ev_R` is **constant** on
> that component: for every `s ∈ M_S(a, ψ)`, `s(q)` lies in the single
> `Λ`-eigenline of `W⁻_σ` of character `ψ^{-1}·∏_r μ_r^{a_r}`, where
> `Λ = Γ ∩ H_R`, `q` is any point of `π(F_R)` and `μ_r` is the `Λ`-character on
> its `r`-th coordinate line — or `s(q) = 0`, in which case `φ` is undefined
> along `R` ("degenerate").
>
> *Proof.* `Λ` fixes `π(F_R)` pointwise, so `h·q̃_r = μ_r(h) q̃_r`. Equivariance
> `s(h·q) = ψ(h)·h·s(q)` and multi-homogeneity give
> `h·s(q̃) = ψ(h)^{-1}(∏_r μ_r(h)^{a_r})·s(q̃)`, so `s(q̃)` is a `Λ`-eigenvector
> of prescribed character. `W⁻_σ|_Λ` splits into two **distinct** characters in
> every case that occurs (`Λ ⊇ V4` or `Λ ⊇ C6`), so the eigenline is unique. ∎
>
> **Machine confirmation:** over all 15 sweep-capable rows, all components in
> the computed range, and all 100 child components, the span of the evaluated
> basis is 0- or 1-dimensional — **never 2**. 0 rigidity failures, both primes
> (`verifier.py` H1).

So the joint evaluation map `M_S → ∏_R (values of R)` is constant on each
connected component of `M_S`; the image of the whole moduli is the *union* over
components, and surjectivity onto the arc-consistent product is a real question.

### 15.2 Task (a): the per-chain evaluation-surjectivity verdicts

`results/coherence_331.txt` (identical at 661). "image" is taken over the
multi-valued rows below the sweep row, with a degenerate child expanded over its
full domain.

| swept row | children | multi-valued | \|image\| | \|arc-consistent\| | surjective? |
|---|---|---:|---:|---:|---|
| `D_{P_σ}` (dim 3) | 20 rows / 54 comps | 18 | **128** | 262 144 | **NO** |
| `D_{L⁻_σ}` (dim 3) | 7 rows / 18 comps | 7 | **64** | 128 | **NO** |
| `pt_D12` line (`Stab D12`) | 3 rows / 8 comps | 1 | 2 | 2 | yes |
| `pt_C6*` (`Stab C6`) | 4 | 4 | 16 | 16 | yes |
| `pt_C6`, `pt_C6<C3line` | 2 each | 2 | 4 | 4 | yes |
| the eight `V4`-stabilised `C2`-rows | 2 each | 2 | 1 | 1 | yes (image = the unique arc-consistent tuple) |
| the `D10` `C2`-line | 0 | 0 | — | — | vacuous |

**Two of the fifteen evaluation maps are not surjective, and they are exactly
the two dimension-3 divisors.** The proper images are recorded explicitly in
`results/coherence_331.json`; their structure is:

* `D_{P_σ}`: the image factors as (2 joint tuples on the twelve multi-valued
  `V4`-children) × (all 64 tuples on the six `C6`-children in `D_{P_σ}`). The
  `V4`-part is the binding cut.
* `D_{L⁻_σ}`: the image is exactly half of the arc-consistent product.

A second, sharper cut appears at the same time and is worth recording on its
own: **38 of the 48 computed components of `M_{D_{P_σ}}` evaluate some child
outside its arc-consistent domain.** Those are legitimate `D12`-equivariant
surjections `D_{P_σ} → L_σ` that **cannot be the restriction of any global
section**. Likewise 9 of 12 for each `V4`-stabilised `C2`-row and 38 of 48 for
`M^V_τ`. This is a cut on the Layer-2 moduli, not on the pattern count, and it
is the sharpest thing this packet says about Layer 2.

### 15.3 Task (b): the re-issued count

The evaluation maps are **not** all surjective, so the number changes:

```
  arc-consistent (value-set) patterns   69 686 233 329 838 325 760 000
  stratum-coherent patterns              1 088 847 395 778 723 840 000
  ratio                                                 64  =  2⁶
```

with the fibered-product structure

```
  1 088 847 395 778 723 840 000
     =  43 008          (the coupled core: 51 rows, one block)
      x  23             (the D10 C2-line: 21 points + 2 one-parameter families)
      x  6⁸ · 4¹⁰ · 5⁴  (the coherence-immune odd-order point rows)
     =  2¹¹ · 21 · 23 · 6⁸ · 4¹⁰ · 5⁴ .
```

The factor removed is `2⁶`: the six `C6`-rows lying inside `D_{P_σ}` (four over
the plus-plane `C6`-points, two over the `D12`-points) were counted as free
singletons and are in fact tied to the `σ`-band. Fifteen further rows lose all
freedom without changing the total (they were already correlated): five `C2`-rows
become forced sweeps (Theorem 3′) and ten `V4`-rows become rigid (Theorem 5′).

**Within-block confirmation.** Re-running the pre-coherence blocks with the
coherence tables switched off reproduces `2 752 512 = 2⁹ · 84 · 2⁶` on the same
51 rows, i.e. the published block counts; switching them on gives
`43 008 = 2⁹ · 84`. The old within-block correlations are therefore confirmed,
not revised (`verifier.py` H7, H8).

### 15.4 (i) The reframing

**The number counts stratum-coherent order-0 boundary patterns. It is not a
moduli of maps, and it is not a moduli of Stage-1 morphisms-with-their-Layer-2-
data.** Three separate things must be kept apart:

1. the **boundary pattern** — which target stratum receives each source stratum,
   and, for a constant row, which point. That is what Theorem A counts.
2. the **Layer-2 datum** on each swept row — a point of `M_S`, a positive-
   dimensional variety in each multidegree. §15.2 cuts this hard (most
   components are not restrictions of any section) but does not count it.
3. an actual **map** `P(W) ⇢ X`. Stage 2.

The only further *order-0* cut available is global single-map coherence: every
stratum lies in the closure of the free stratum, so the whole section is the
boundary datum of **one** morphism `q̃` on `Z̃`, and the values at the deep rows
are evaluations of `q̃` itself, not merely of the germs along the swept
divisors. That cut is **Stage 2 by definition** — it needs the map, or at least
its jets, and there is no order-0 surrogate for it. A `Z`-stratum whose only
proper parent is the free stratum is untouched by anything at order 0.

### 15.5 (ii) The coherence-immune factor — where Stage 2's work lives

Exactly 22 rows have the free stratum as their **only** proper parent
(`verifier.py` H10), so no sweep evaluation can ever reach them:

| rows | count | values each | factor |
|---|---:|---:|---|
| `C3`-rows with `Stab = C3` (over the `A4`-points and their `ell_V` crossings) | 8 | 6 | `6⁸` |
| `C5`-rows (over the `C5`- and `D10`-points) | 10 | 4 | `4¹⁰` |
| `C11`-rows (over the `C11`-points) | 4 | 5 | `5⁴` |

```
  6⁸ · 4¹⁰ · 5⁴  =  1 100 753 141 760 000  ≈  1.1 × 10¹⁵ .
```

These are precisely the rows whose exact stabilizer has **odd order**. Their
strata are the isolated eigen-direction points over the `A4`-, `C5`-, `D10`- and
`C11`-centres; they lie in no `E_σ` and no `L_σ` (odd-order stabilizer), in no
positive-dimensional stratum but the free one, and in each other's closures not
at all. **Nothing at order 0 can pin them** — not the sweeps, not the closure
poset, not (F2), not the window arithmetic. They are pinned only by the jets of
an actual map at those points, i.e. by the first-order character-containment
conditions of `[I, Lem 4.5]` and what follows.

So `1.1 × 10¹⁵` is a **measurement of where Stage 2's work lives**: the order-0
theory has, by construction, nothing to say about `6⁸ · 4¹⁰ · 5⁴` of the
freedom, and the `D10` `C2`-line contributes a further factor 23 (including the
two one-parameter families) for the same reason. Everything else — the entire
`σ`-band, 51 rows — is now down to 43 008 patterns.

### 15.6 Honesty on the coherence layer (Tier 3)

1. **Degree bound.** The tables are computed for multidegrees up to 4 (two-slot
   rows) / 6 (one-slot rows). Theorem 15.1 makes the *value* depend on `a` only
   through `a mod 6` per slot, so every character class is represented; what can
   still change with larger `a` is which children are degenerate. Empirically
   the image of `D_{P_σ}` is constant from maxdeg 3 and that of `D_{L⁻_σ}` from
   maxdeg 4, and **the total is unchanged at maxdeg 3, 4, 5 and 6**. That last
   statement now carries an artifact: the PR #32 adjudication found it asserted
   but unrecorded and ran it. `scripts/s1saturation.py` re-does the recount at a
   *uniform* maxdeg across all fifteen sweep rows — below the producer's default
   in one slot-class and above it in the other — and returns the same total
   `1 088 847 395 778 723 840 000` and the same `(51 rows, 43 008 patterns)` core
   at maxdeg 3, 4, 5 and 6, with 0 rigidity failures throughout
   (`results/saturation_probe_331.txt`). **We still do not
   have a proof of saturation** — this is evidence, and the flag stands.
2. The identification of `π(F_R)` (the image of a child stratum in the
   product-of-projective-spaces model of the swept row) uses the wonderful-model
   chart form of `TERMINUS_STRATA_PW` Thm 1; generic points of `π(F_R)` are
   sampled (four independent random points per coordinate, with the constancy of
   the evaluation checked across them, which is exactly Theorem 15.1's assertion).
3. The coherence layer is imposed **stratum-locally**, per swept row. Coherence
   between two different swept rows is imposed only through the values they
   share. Full single-map coherence is Stage 2 (§15.4).
