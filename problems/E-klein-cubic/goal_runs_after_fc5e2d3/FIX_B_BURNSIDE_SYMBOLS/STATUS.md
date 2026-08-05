# FIX-B — the equivariant Burnside symbol list of `P(W)`, the removability audit, and the `C11` weight data

**Primary exit: `FIX-B-SYMBOLS-PASS`**

**Problem E headline: OPEN.**

**SCOPE (not a computed claim).** *The unrelativized class-level shadow carries no
map-compatibility information — relativization is Note III.* This packet computes the two
durable objects (the symbol list and the removability audit) plus the `C11` margin-note data.
It says nothing about the existence of an equivariant dominant `P(W) ⇢ X_Klein`.

**Packet:** `goal_runs_after_fc5e2d3/FIX_B_BURNSIDE_SYMBOLS/`
**Program:** FIX ([E56]); side-goal FIX-B registered in `theory/FIX_I_bcomplex.md` §7.
**Input:** `goal_runs_after_bc93561/FIX_A2_SOURCE_COMPLEX/source_complex.json` (sealed,
SHA-256 `dc65b752…`) — read by the producer only.
**Verification class:** ALGEBRAIC-RECOMPUTE. `verify_burnside_symbols.py` rebuilds the
representation from the `S, T` construction of `certificates/exact_weil_check.py` and
recomputes the subgroup lattice, the strata, every decoration and every Theorem-2.1 delta by
deliberately different methods, **without reading `source_complex.json`** — so it
re-validates FIX-A2 a second time. **20 checks, 0 failures**, plus a harness self-test that
must fail and does. Terminal marker `FIX_B_BURNSIDE_SYMBOLS_VERIFY_OK`.
**Toolchain:** `python3` standard library only; exact arithmetic in `Q(ζ_330)`. No GAP, Sage,
Magma, PARI/GP, M2, msolve. Characteristic 0. Producer 2 s, verifier 132 s. No git commits.

---

## Part I — per-task verdicts

| Task | Claim | Verdict | Evidence |
|---|---|---|---|
| **B-1** | **Symbol list.** All 20 `G`-orbits of strata of `𝔽(P(W))` carry an explicit symbol `s = ([H]_G ; W(H,F) ⟳ k(F) ; β)`. Every `F` is a linear `P^d` (`d ≤ 2` for `H ≠ 1`, `d = 4` for the open orbit), so `k(F) = k(x_1,…,x_d)` with an explicit projective linear `W(H,F)`-action, recorded both as FIX-A2's action matrices and basis-freely as the character of `Stab_{N_G(H)}(F)` on `W_χ`. `dim F + \|β\| = 4` on **all 20**. The 20 orbits carry **19 distinct symbols**: `C5/χ` and `C5/χ²` (orbits 8, 9) are different `G`-orbits of 132 points each but the **same** symbol `(C5; 1 ⟳ k; {1,2,3,4})` | **PASS** | producer: `(H,χ)` rebuilt from the abelianization + character key, `δ_nr` cross-checked against the payload's stored class values; verifier `C1–C4`, `D1–D3` |
| **B-2** | **Abelian/nonabelian split.** `14` orbits have abelian `H` (`1, C2, C3, V4, C5, C6, C11`); `6` have nonabelian `H` (`S3` twice, `D10`, `D12`, `A4` twice) and are recorded as *outside the abelian-symbol subgroup; enters via standard form*. The 20 orbits sit on only **15 isotropy strata** (FIX-A2 FINDING 9): the open stratum, 4 positive-dimensional families and 10 point orbits; **11** of the 15 have abelian generic stabiliser (**10 distinct symbols**), **4** do not (`D10`-points, `D12`-points, `A4/ω`, `A4/ω²`) | **PASS** | `symbols.json → reduced_isotropy_stratification`; verifier `E1` recomputes the 10 point orbits from full stabilisers |
| **B-3** | **Refinement of the nonabelian point-strata.** For each of the 6 nonabelian orbits, every `H`-class of abelian subgroups `A ≤ H` with the stratum of `A` through the point, its dimension and orbit, `β_A` on `N_{F_A}` and the full `A`-weight multiset on `T_p` | **PASS** | `symbols.json → abelian_refinements_of_nonabelian_strata` |
| **B-4** | **Enumeration of admissible centers.** A center is smooth, `G`-stable, of codimension `≥ 2` (`dim Z ≤ 2` in `P^4`). Among unions of `G`-orbits of strata closures: **every positive-dimensional stratum orbit self-intersects** (plus-planes meet along `ℓ_V`, minus-lines at `V4`-vertices, `C3`-lines at `A4`-points, `V4`-lines at `D12`-points), so the admissible centers are exactly the **1023** non-empty unions of the **10** point orbits; deltas are additive since the point orbits are disjoint and Thm 2.1 is local | **PASS** | `removability.json → move_set_enumeration`; verifier `E1`, `E3` |
| **B-5** | **Exact Theorem-2.1 deltas.** For each of the 10 centers: the destroyed 0-dimensional strata and all exceptional strata `P(N^χ)` with `dim = m_χ − 1`, `δ_nr = δ_nr(F_Z⊂Z) ⊎ (χ^{-1}⊗(N_z/⟨v⟩))^{nontriv} ⊎ {χ}` and residual group `{g ∈ N_G(H) ∩ Stab(p) : χ^g = χ}/H`. **54** new `G`-orbits of strata across the ten centers, **29** distinct symbols of which **7** already occur in `𝔽(P(W))`. `dim + \|β\| = 4` on every one | **PASS** | verifier `E2`, `E4` re-derive the `(\|H\|, dim, \|β\|)` multiset of every center independently |
| **B-6** | **Removability table.** `11` of the 20 symbols are **REMOVABLE** with an explicit witnessing center; `9` form the **non-removable core**, of which `2` are unconditionally rigid and `7` are rigid within the enumerated move set | **PASS** | `removability.json → verdicts`, `non_removable_core` |
| **B-7** | **`C11` weight data.** All 12 Sylow-11 subgroups with a canonical generator, the exponent set `J` (always a quadratic-residue coset), and all **60** points with their weight quadruples mod 11, `±`-pairings, `(a,b)`-pair form, weight sums and full QR-orbits | **PASS** | `c11_weights.json`; verifier `F1–F3` |

## Part II — the 20-symbol table

`s = ( [H]_G ; W(H,F) ⟳ k(F) ; β )`. For cyclic `H = ⟨g⟩` of order `n`, `β` is written as
residues mod `n` (`χ(g) = ζ_n^j ↦ j`); for `V4` as multiplicities of the three nontrivial
characters; for nonabelian `H` as (linear part) + (nonlinear part).

| id | FIX-A2 label | `dim F` | `\|orbit\|` | `[H]_G` | `W(H,F)` | `β` | note |
|---|---|---|---|---|---|---|---|
| 0 | `1/triv` | 4 | 1 | `1` | `PSL(2,11)` on `k(P⁴)` | `∅` | the open symbol |
| 1 | `C2/triv` (plus-plane) | 2 | 55 | `C2` | `S3` on `k(P²)` | `{1,1}` | |
| 2 | `C2/sgn` (minus-line) | 1 | 55 | `C2` | `S3` on `k(P¹)` | `{1,1,1}` | |
| 3 | `C3/triv` | 0 | 55 | `C3` | `V4` | `{1,1,2,2}` | |
| 4 | `C3/ω` | 1 | 110 | `C3` | `C2` on `k(P¹)` | `{1,1,2}` | |
| 5 | `V4/triv` (`ℓ_V`) | 1 | 55 | `V4` | `C3` on `k(P¹)` | `χ₁+χ₂+χ₃` | |
| 6 | `V4/χᵢ` (vertex) | 0 | 165 | `V4` | `1` | `2χ₁+χ₂+χ₃` | |
| 7 | `C5/triv` | 0 | 66 | `C5` | `C2` | `{1,2,3,4}` | |
| 8 | `C5/χ` | 0 | 132 | `C5` | `1` | `{1,2,3,4}` | same symbol as 9 |
| 9 | `C5/χ²` | 0 | 132 | `C5` | `1` | `{1,2,3,4}` | same symbol as 8 |
| 10 | `S3/triv` (A) | 0 | 55 | `S3(A)` | `C2` | `0` lin + 4-dim nonlinear | **standard form** |
| 11 | `S3/triv` (B) | 0 | 55 | `S3(B)` | `C2` | `0` lin + 4-dim nonlinear | **standard form** |
| 12 | `C6/triv` | 0 | 55 | `C6` | `C2` | `{1,2,4,5}` | |
| 13 | `C6/χ` | 0 | 110 | `C6` | `1` | `{1,3,4,5}` | |
| 14 | `C6/χ²` | 0 | 110 | `C6` | `1` | `{2,3,4,5}` | |
| 15 | `D10/triv` | 0 | 66 | `D10` | `1` | `0` lin + 4-dim nonlinear | **standard form** |
| 16 | `C11/χ` | 0 | 60 | `C11` | `1` | `{4,5,6,8}` | 4 distinct nontrivial weights |
| 17 | `D12/triv` | 0 | 55 | `D12` | `1` | `0` lin + 4-dim nonlinear | **standard form** |
| 18 | `A4/ω` | 0 | 55 | `A4` | `1` | `ω` + 3-dim nonlinear | **standard form** |
| 19 | `A4/ω²` | 0 | 55 | `A4` | `1` | `ω²` + 3-dim nonlinear | **standard form** |

“standard form” = *outside the abelian-symbol subgroup of the Kresch–Tschinkel formalism;
enters via standard form.* No standard-form reduction is performed here (it needs relations
that are not verified in this repository); the abelian refinement of each such point is
recorded instead.

**Abelian part of `[P(W)]`.** Assembling from the 15 isotropy strata, the abelian-stabiliser
part is the sum of the 11 symbols with orbit ids `0, 1, 2, 4, 5, 6, 8, 9, 13, 14, 16`
(10 distinct, since `8 = 9`). The four remaining isotropy strata — the 66 `D10`-points,
the 55 `D12`-points, and the two orbits of 55 `A4`-points — enter only via standard form.

## Part III — the removability verdicts

Move set: a single blowup of `P(W)` along an admissible smooth `G`-stable center from the
enumerated class (Part I, B-4), evaluated over **all 1023** such centers.

| id | label | verdict | witness / reason |
|---|---|---|---|
| 0 | `1/triv` | **RIGID (unconditional)** | `X̃^1 = X̃` on every model |
| 1 | `C2/triv` | **RIGID (unconditional)** | no smooth `G`-stable center of *any* kind contains a plus-plane (proof below) |
| 2 | `C2/sgn` | RIGID-IN-CLASS | not contained in any admissible center; Thm 2.1(i) |
| 3 | `C3/triv` | REMOVABLE | `Z` = the 55 `D12`-points |
| 4 | `C3/ω` | RIGID-IN-CLASS | not contained in any admissible center |
| 5 | `V4/triv` | RIGID-IN-CLASS | not contained in any admissible center |
| 6 | `V4/χᵢ` | **RIGID-UNDER-BLOWUP** | blowing up the 165 vertices **re-creates** the symbol: the `m_χ = 1` exceptional points have `β = 2χ_k + χ_i + χ_j`, which `N_G(V4) = A4` conjugates back to `2χ_i + χ_j + χ_k` |
| 7 | `C5/triv` | REMOVABLE | `Z` = the 66 `D10`-points |
| 8, 9 | `C5/χ`, `C5/χ²` | REMOVABLE | `Z` = the 132 + 132 `C5`-points **together** (blowing up only one leaves the other carrying the same symbol) |
| 10, 11 | `S3/triv` (A, B) | REMOVABLE | `Z` = the 55 `D12`-points |
| 12 | `C6/triv` | REMOVABLE | `Z` = the 55 `D12`-points |
| 13 | `C6/χ` | **RIGID-UNDER-BLOWUP** | blowing up the 110 points re-creates `β = {1,3,4,5}` from the weight `c = 4` |
| 14 | `C6/χ²` | REMOVABLE | `Z` = the 110 `C6/χ²`-points (the four replacements are `{1,2,2,3}, {1,2,3,5}, {1,4,4,5}, {3,4,5,5}`) |
| 15 | `D10/triv` | REMOVABLE | `Z` = the 66 `D10`-points |
| 16 | `C11/χ` | REMOVABLE | `Z` = the 60 `C11`-points |
| 17 | `D12/triv` | REMOVABLE | `Z` = the 55 `D12`-points |
| 18, 19 | `A4/ω`, `A4/ω²` | **RIGID-UNDER-BLOWUP** | `T_p\|_{A4} = ω ⊕ 3`; the only admissible `χ` is `ω` with `m = 1`, and `β_new = (ω^{-1}⊗3) ⊎ {ω} = 3 ⊕ ω = β` |

**The non-removable core (9 symbols):** `1/triv`, `C2/triv`, `C2/sgn`, `C3/ω`, `V4/triv`,
`V4/χᵢ`, `C6/χ`, `A4/ω`, `A4/ω²` — seven of them abelian symbols.

**The unconditional plus-plane argument (in-repo, Thm 2.1(i) + FIX-A2 incidences).**
Let `Z` be a smooth `G`-stable center of `P(W)` containing one plus-plane. A center has
codimension `≥ 2`, so `dim Z ≤ 2`. `Z` smooth ⇒ its connected components are irreducible;
the component containing the plane is irreducible of dimension `≤ 2` and contains a
2-dimensional irreducible closed subvariety, hence **equals that plane**. So every plus-plane
would be a connected component of `Z`, and `G`-stability forces all 55 into `Z` as **pairwise
disjoint** components — contradicting the verified incidence that each `V4`-line `ℓ_V` lies
in **3** plus-planes. Hence no smooth `G`-stable center of any kind contains a plus-plane and
Thm 2.1(i) preserves the symbol under **every** blowup of `P(W)`.

**Scope of `RIGID-IN-CLASS` / `RIGID-UNDER-BLOWUP` (honest).** These are rigid for the
enumerated move set. Going further would require ruling out every other smooth `G`-stable
`Z` with `dim Z ≤ 2` containing the stratum orbit — for orbits 2, 4, 5 that means a smooth
`G`-stable **surface** in `P^4` containing 55 (resp. 110, 55) lines, necessarily carrying a
faithful `PSL(2,11)`-action. That geometric input is **not established in this repository**
and is recorded, not used.

## Part IV — the `C11` margin-note data (Task 3, no interpretation)

12 Sylow-11 subgroups; canonical generator `g` = the lexicographically least non-identity
element of the subgroup in the `(a,b,c,d) mod 11` encoding; characters `χ_j : g ↦ ζ_11^j`;
`J = { j : W_{χ_j} ≠ 0 }`; the point `p_a` (`a ∈ J`) has
`β(a) = { b − a mod 11 : b ∈ J, b ≠ a }`.

* `J` is a **quadratic-residue coset** for all 12 subgroups: **6** have `J = QR = {1,3,4,5,9}`
  and **6** have `J = 2·QR = {2,6,7,8,10}` (the split is an artefact of the canonical
  generator choice; all 60 points are one `G`-orbit).
* Every `β(a)` has **4 distinct** nontrivial weights; `Σβ(a) ≡ −5a (mod 11)`.
* The 60 rows realise exactly **10 distinct quadruples** — the full `F₁₁^×`-orbit of
  `{2,3,4,8}`; the `N_G(C11)`-induced automorphisms are only the QR-multiplications, so the
  symbol is the **QR-orbit** `{2,3,4,8}, {1,2,6,9}, {1,5,8,10}, {4,7,9,10}, {3,5,6,7}`
  (`J = QR`) resp. its non-residue partner (`J = 2·QR`).
* For `J = QR`: `β(1)={2,3,4,8}`, `β(3)={1,2,6,9}`, `β(4)={1,5,8,10}`, `β(5)={4,7,9,10}`,
  `β(9)={3,5,6,7}`, with weight sums `6, 7, 2, 8, 10`.
* **Blowing up the 60 `C11`-points replaces each point by 4 points** with
  `β_new(c) = {μ − c : μ ∈ β(a), μ ≠ c} ⊎ {c}`. For the payload's labelling the four
  replacements of `β = {4,5,6,8}` are `{1,2,4,4}`, `{1,3,5,10}`, `{2,6,9,10}`, `{7,8,8,9}` —
  four **new** symbols (two with a repeated weight), none in the QR-orbit of `{4,5,6,8}`.
  This is the whole delta: the only subgroups of `C11` are `1` and `C11`, so this blowup
  changes **nothing else** in the complex.

Full table: `c11_weights.json` (`subgroups[]` with per-point `beta_weights_mod_11`,
`beta_as_ordered_pairs_(a,b)_weight_b_minus_a`, `plus_minus_pairing`, `weight_sum_mod_11`;
`flat_table[]` with 60 rows carrying `J`, the quadruple, its `±`-pairing, its sum and its
full QR-orbit).

## FINDINGS

1. **Two distinct `G`-orbits of strata carry the same Burnside symbol.** `C5/χ` and `C5/χ²`
   (orbits 8 and 9, 132 points each) both give `(C5 ; 1 ⟳ k ; {1,2,3,4})`: the normal weight
   set at a `C5`-point is *all four* nontrivial characters regardless of which eigenline the
   point is. Consequence for the audit: neither can be removed alone — the witnessing center
   must be the union of both point orbits. This is the only symbol collision among the 20.

2. **The `C11` symbol is removable, and removing it is surgically clean.** The 60
   poset-isolated `C11`-points are an admissible smooth `G`-stable center whose blowup
   destroys the `C11` symbol and — because `C11` has no proper non-trivial subgroups —
   perturbs no other symbol at all. So the level-11 stratum, the one with the modular-symbol
   flavour, is *not* part of the non-removable core of `𝔽_b(P(W))`.

3. **A four-symbol rigid nucleus among the point strata.** `V4/χᵢ` (165 vertices), `C6/χ`
   (110 points) and the two `A4`-orbits (55 + 55 points) are contained in admissible centers
   yet **survive their own blowups**, because the Euler-sequence weight rule of Thm 2.1(ii)
   reproduces their own `β` among the exceptional strata. For `V4` and `A4` this is forced by
   `N_G(H)`: the `A4`-action on `Hom(V4,k^×)` fuses `2χ_i+χ_j+χ_k` with `2χ_k+χ_i+χ_j`, and
   for `A4` the identity `3 ⊗ ω ≅ 3` makes `β_new = β` exactly. For `C6/χ` it is an
   arithmetic accident of the weight set `{1,3,4,5} ⊂ Z/6`: the weight `c = 4` regenerates it,
   while the sibling `C6/χ²` with `{2,3,4,5}` is regenerated by nothing and *is* removable.

4. **The non-removable core is dominated by positive-dimensional strata.** Of the 9 core
   symbols, 5 have `dim F ≥ 1` (the open `P⁴`, the plus-planes, the minus-lines, the
   `C3`-lines, the `V4`-lines) and they are rigid for a *geometric* reason with no weight
   content: no admissible center contains them, because in `P^4` a smooth `G`-stable center
   has dimension `≤ 2` and every positive-dimensional stratum orbit self-intersects. The
   plus-plane case is unconditional over all centers.

5. **The blowup calculus mixes the strata layers.** The 55 `D12`-points are the richest
   center: their blowup destroys **five** stratum orbits at once (`C3/triv`, both `S3/triv`,
   `C6/triv`, `D12/triv` — all five labels of the same 55 points) and creates 9 new orbits
   for `H` of orders 2, 3, 4, 6, among them a **new copy of the minus-line symbol**
   `(C2; S3 ⟳ k(P¹); sgn³)` and **three** new copies of the `V4`-vertex symbol. So symbol
   multiplicities are not monotone under the calculus even when the symbol itself is rigid.

6. **45 exceptional configurations sit exactly where a Kresch–Tschinkel vanishing relation
   would be applied.** Across the ten centers, 45 of the 54 new stratum orbits have a
   **repeated weight** in `β_new`. These are recorded in
   `removability.json → honesty.literature_dependent_configurations` and marked
   **LITERATURE-DEPENDENT**: the KT relation set (conjugation / blow-up / vanishing) is not
   verified in this repository, so **no** symbol is declared zero and every verdict above is
   derived from `theory/FIX_I_bcomplex.md` Theorem 2.1 alone.

7. **Cross-validation of FIX-A2 by a third route.** The verifier rebuilds `ρ` from the Gauss
   sum, recovers 16 subgroup classes / 620 subgroups / 1502 strata / 20 orbits, and reproduces
   every `dim F`, every `|Stab_{N_G(H)}(F)|` (by an honest **subspace** stabiliser test rather
   than the character test), every orbit size, every `β` multiplicity vector, the scalar action
   of `H` on `W_χ` and every residual trace. Nothing in FIX-A2 is contradicted or amended.

## Honesty constraints observed

* **Only in-repo mathematics is used for the verdicts.** `theory/FIX_I_bcomplex.md`
  Theorem 2.1 (i)–(iv) is implemented verbatim and exactly; nothing else about Burnside
  groups is assumed.
* **No Kresch–Tschinkel relation is applied.** No symbol is set to zero; no symbol identity
  beyond exact `G`-conjugacy of the decorated data is used. The configurations where a
  vanishing relation would be the natural next move are recorded and flagged.
* The precise KT normalisation of the residual datum (`Stab_{N_G(H)}(F)/H` on a single
  component versus `N_G(H)/H` on the whole fixed locus) is **LITERATURE-DEPENDENT**; this
  packet follows the brief's convention `W(H,F) = Stab_{N_G(H)}(F)/H` and records enough data
  (the full stabiliser, its elements, its projective action) to re-normalise later.
* The symbol records the `W(H,F)`-action on `k(F)`, i.e. the **projective** action; the
  canonical symbol key is therefore minimised over twists by linear characters of
  `Stab_{N_G(H)}(F)` as well as over `N_G(H)`-conjugacy. `β` is **not** twisted.

## Deliverables

| File | Role | SHA-256 |
|---|---|---|
| `produce_burnside_symbols.py` | producer (exact; 2 s) | `c49bffcf…` |
| `verify_burnside_symbols.py` | independent verifier, ALGEBRAIC-RECOMPUTE (132 s, 20 checks, 0 failures) | `5b8cdc65…` |
| `symbols.json` | the 20 symbols with full decorations, the 15 isotropy strata, the abelian part of the class, the abelian refinements | `522d9b96…` |
| `removability.json` | the center enumeration, the exact Thm-2.1 deltas of all 10 centers, the verdict table, the non-removable core, the honesty block | `fab7a84f…` |
| `c11_weights.json` | 12 subgroups, 60 points, weight quadruples mod 11 and their pair data | `86060643…` |
| `STATUS.md` | this file | |
| `REPLAY.md` | replay instructions, markers, hashes, independence note | |

No repository file outside this packet was edited or deleted; nothing was committed. The
FIX-A2 payload was read read-only by the producer and not read at all by the verifier.
