# FIX-A2 — the complete decorated fixed-locus complex of the SOURCE `P(W) = P⁴`

**Primary exit: `FIX-A2-SOURCE-COMPLEX-PASS`**

**Problem E headline: OPEN.**

**Packet:** `goal_runs_after_bc93561/FIX_A2_SOURCE_COMPLEX/`
**Program:** FIX ([E56]); foundation packet 3, after FIX-A0/A1 (`goal_runs_after_2880a28/`).
**Object:** `𝔽(P(W))` of `theory/FIX_I_bcomplex.md` Definition 1.1, for `X = P(W) = P⁴`
with `G = PSL(2,11)` acting by the exact 5-dimensional Weil representation of
`certificates/exact_weil_check.py` (rebuilt in-file, never imported).
**Verification class:** ALGEBRAIC-RECOMPUTE — `verify_source_complex.py` rebuilds every
statement from scratch by deliberately different methods (see §Independence), 44 checks,
0 failures, plus a harness self-test that must fail and does. Terminal marker
`FIX_A2_SOURCE_COMPLEX_VERIFY_OK`.
**Toolchain:** `python3` exact cyclotomic arithmetic in `Q(ζ_n)`, `n | 330`, and integer
arithmetic in `PSL(2,F₁₁)`. No GAP, no Sage, no Magma, no PARI/GP, no M2 (none needed:
every computation is exact linear algebra over cyclotomic fields).
**Characteristic 0 throughout.** Producer 19 s, verifier 163 s.

**Theorem boundary.** This packet certifies the fixed-locus complex of the SOURCE `P⁴`
only: subgroup lattice, eigenstrata, decorations `δ_dim / δ_nr / δ_res / δ_bir`, incidence
poset. It says nothing about the Klein cubic `X`, about landing covariants, about dominant
equivariant maps, or about unirationality; the only target-side statement it touches is
the invariance of the Klein cubic under `S, T`, used solely to identify `ρ` with the
repo's representation.

---

## Part I — per-item verdicts (the six mission items)

| Item | Claim | Verdict | Evidence |
|---|---|---|---|
| **A2-1** | **Subgroup inventory.** `G` has exactly **620 subgroups in 16 conjugacy classes**: `1, C2, C3, V4, C5, S3 (two classes), C6, D10, C11, A4, D12, C11:C5, A5 (two classes), G`, with class sizes `1,55,55,55,66,55,55,55,66,12,55,55,12,11,11,1` and normalizers `G, D12, D12, A4, D10, D12, D12, D12, D10, C11:C5, A4, D12, C11:C5, A5, A5, G` | **PASS** | producer: coset-representative BFS from the trivial subgroup (all element orders are squarefree ⇒ prime-order extensions suffice); verifier: `(cyclic, element)` closures with a completeness certificate, in a brute-force model of `PSL(2,11)`; both give the same 620 element sets (`V3.1–V3.7`) |
| **A2-2** | **Eigenstrata.** `P(W)^H = ⊔_χ P(W_χ)` over the **one-dimensional** characters `χ` of `H` with `W_χ ≠ 0` (a point is `H`-fixed iff it spans an `H`-stable line). Every `W|_H` computed exactly; shapes in the table below; **`P(W)^H = ∅` exactly for `C11:C5`, both `A5`, and `G`** — precisely the four classes with `W|_H` irreducible | **PASS** | producer: images of the projectors `P_χ = (1/|H|)Σ χ(h)⁻¹ρ(h)` (idempotency `P² = P` asserted); verifier: kernels of the stacked systems `[ρ(g₁)−λ₁; …; ρ(g_k)−λ_k]` over all eigenvalue tuples (`V4.1–V4.4`) |
| **A2-3** | **Decorations.** For every stratum: `δ_dim`; `δ_nr = χ⁻¹ ⊗ (W/W_χ)` with exact character values on the classes of `H`, multiplicities of all linear characters, and a **certified** decomposition into irreducibles (all 20 orbits); `δ_res = W(H,F) = Stab_{N_G(H)}(F)/H` with exact action matrices on a basis of `W_χ`; `δ_bir` = linear ⇒ rational ⇒ RCC, MRC base a point; plus the **pointwise (isotropy) stabiliser** of each stratum | **PASS** | producer: character identity `ν(h) = χ̄(h)χ_W(h) − dim W_χ`, stabiliser of the subspace, irreducibles by induction-from-cyclic + sieve (certified by `#irr = #classes` and `Σ deg² = |H|`), pointwise stabiliser by the scalar-action test; verifier: honest quotient matrices on `W/W_χ` in a completed basis, stabiliser of the **character**, `dim(linear part) = dim N^{[H,H]}`, and pointwise-stabiliser maximality read off the poset (`V5.1–V5.6`) |
| **A2-4** | **Incidence poset.** `1502` strata, `5197` edges, `20` `G`-orbits, `46` orbit-level relations with up/down multiplicities. For every stratum `(H,F)` and every proper subgroup `H' ⊊ H` there is **exactly one** stratum `(H',F') ≥ (H,F)`; the whole order relation is **character restriction**: `(H,F) ≤ (H',F')  ⟺  H ⊇ H'` and `χ_{F'} = χ_F|_{H'}` | **PASS** | producer: exact subspace containment on class representatives, `G`-transported, then re-described by restriction; verifier: independent containment on its own eigen-solved bases with orbits identified by explicit conjugation, plus two independent counts of `1502` and `5197` (`V6.1–V6.4`, `V7.1–V7.2`) |
| **A2-5** | **Sanity identities.** `Σ_F (dim F + 1) = 5` for every **cyclic** `H` (Lefschetz: `χ_top(Fix(g,P⁴)) = 5` for all 660 elements, `G` acting trivially on `H^*(P⁴)`), `= 5` exactly for abelian `H`; `|G-orbit| = |G|/|Stab_{N_G(H)}(F)|` for all 20 orbits; double counting `|O_low|·up = |O_up|·down` on all 46 relations; the trivial character never occurs in `δ_nr` (Def. 1.1) | **PASS** | `sanity` block of the payload; verifier `V8.1–V8.2`, `V5.2` |
| **A2-6** | **Machine-readable payload** `source_complex.json` (5.1 MB, byte-reproducible, no timestamps): group + character table data, 16 subgroup classes, all 620 subgroups with conjugators, all 1502 strata, 20 orbits with full exact decorations and bases, all 5197 poset edges, the orbit-level table, and the sanity block | **PASS** | two producer runs give identical SHA-256 `dc65b7528aa9f442…` |

## Part II — the source complex (compact)

### Subgroup classes and fixed-locus shapes

| # | `H` | `\|H\|` | #conj | `N_G(H)` | `W\|_H` | `P(W)^H` | strata |
|---|---|---|---|---|---|---|---|
| 0 | `1` | 1 | 1 | `G` | `W` | `P⁴` | 1 |
| 1 | `C2` | 2 | 55 | `D12` | `triv³ ⊕ sgn²` | `P² ⊔ P¹` | 110 |
| 2 | `C3` | 3 | 55 | `D12` | `triv ⊕ 2ω ⊕ 2ω²` | `pt ⊔ P¹ ⊔ P¹` | 165 |
| 3 | `V4` | 4 | 55 | `A4` | `triv² ⊕ χ₁ ⊕ χ₂ ⊕ χ₃` | `P¹ ⊔ 3 pts` | 220 |
| 4 | `C5` | 5 | 66 | `D10` | regular (all 5 characters once) | `5 pts` | 330 |
| 5 | `S3` (class A) | 6 | 55 | `D12` | `triv ⊕ 2·(2-dim)` | `1 pt` | 55 |
| 6 | `S3` (class B) | 6 | 55 | `D12` | `triv ⊕ 2·(2-dim)` | `1 pt` | 55 |
| 7 | `C6` | 6 | 55 | `D12` | `χ⁰⊕χ¹⊕χ²⊕χ⁴⊕χ⁵` (**`χ³` absent**) | `5 pts` | 275 |
| 8 | `D10` | 10 | 66 | `D10` | `triv ⊕ 2a ⊕ 2b` | `1 pt` | 66 |
| 9 | `C11` | 11 | 12 | `C11:C5` | the 5 characters `ζ^{j}`, `j` in one `QR`-coset | `5 pts` | 60 |
| 10 | `D12` | 12 | 55 | `D12` | `triv ⊕ 2 ⊕ 2` | `1 pt` | 55 |
| 11 | `A4` | 12 | 55 | `A4` | `ω ⊕ ω² ⊕ 3` (**no trivial part**) | `2 pts` | 110 |
| 12 | `C11:C5` | 55 | 12 | `C11:C5` | irreducible (5) | **∅** | 0 |
| 13 | `A5` (class A) | 60 | 11 | `A5` | irreducible (the 5 of `A5`) | **∅** | 0 |
| 14 | `A5` (class B) | 60 | 11 | `A5` | irreducible (the 5 of `A5`) | **∅** | 0 |
| 15 | `PSL(2,11)` | 660 | 1 | `G` | irreducible | **∅** | 0 |

Total: **1502 strata**, `20` `G`-orbits.

### The 20 stratum orbits with decorations

| id | label | `dim F` | `\|orbit\|` | `W(H,F)` | `δ_nr` (as `H`-module) |
|---|---|---|---|---|---|
| 0 | `1/triv` | 4 | 1 | `PSL(2,11)` | `0` |
| 1 | `C2/triv` (plus-plane) | 2 | 55 | `S3` | `sgn²` |
| 2 | `C2/sgn` (minus-line) | 1 | 55 | `S3` | `sgn³` |
| 3 | `C3/triv` | 0 | 55 | `V4` | `2ω ⊕ 2ω²` |
| 4 | `C3/ω` (and `ω²`) | 1 | 110 | `C2` | `2ω ⊕ ω²` |
| 5 | `V4/triv` (`ℓ_V`) | 1 | 55 | `C3` | `χ₁ ⊕ χ₂ ⊕ χ₃` |
| 6 | `V4/χᵢ` (vertices) | 0 | 165 | `1` | `2χᵢ ⊕ χⱼ ⊕ χₖ` |
| 7 | `C5/triv` | 0 | 66 | `C2` | `χ ⊕ χ² ⊕ χ³ ⊕ χ⁴` |
| 8,9 | `C5/χ`, `C5/χ²` | 0 | 132 each | `1` | the four other characters |
| 10,11 | `S3/triv` (both classes) | 0 | 55 each | `C2` | `2·(2-dim)` |
| 12 | `C6/triv` | 0 | 55 | `C2` | `χ¹⊕χ²⊕χ⁴⊕χ⁵` |
| 13,14 | `C6/χ`, `C6/χ²` | 0 | 110 each | `1` | four characters |
| 15 | `D10/triv` | 0 | 66 | `1` | `(2a) ⊕ (2b)` |
| 16 | `C11/χ` | 0 | 60 | `1` | four nontrivial characters |
| 17 | `D12/triv` | 0 | 55 | `1` | `(2) ⊕ (2)` |
| 18,19 | `A4/ω`, `A4/ω²` | 0 | 55 each | `1` | `ω^{∓1} ⊕ (3-dim)` |

### The incidence poset (all 46 orbit-level relations, up-multiplicities)

Every stratum lies in `P⁴` (orbit 0) with multiplicity 1. The remaining relations:

```
V4/triv  ⊂ C2/triv ×3          S3/triv(A) ⊂ C2/triv ×3, C3/triv ×1
V4/χᵢ    ⊂ C2/triv ×1, C2/sgn ×2   S3/triv(B) ⊂ C2/triv ×3, C3/triv ×1
C6/triv  ⊂ C2/triv ×1, C3/triv ×1  D10/triv  ⊂ C2/triv ×5, C5/triv ×1
C6/χ     ⊂ C2/sgn  ×1, C3/ω   ×1   D12/triv  ⊂ C2/triv ×7, C3/triv ×1,
C6/χ²    ⊂ C2/triv ×1, C3/ω   ×1              V4/triv ×3, S3/triv(A) ×1,
A4/ω     ⊂ C2/triv ×3, C3/ω   ×4,             S3/triv(B) ×1, C6/triv ×1
           V4/triv ×1                C11/χ    ⊂ (nothing but P⁴)
A4/ω²    ⊂ C2/triv ×3, C3/ω   ×4, V4/triv ×1
```

Containments read downward (`lower = deeper isotropy`); dually, e.g. a `C2`-plus-plane
`P²` contains `3 ℓ_V`, `3` `V4`-vertices, `3+3` `S3`-points, `1` `C6/triv`, `2` `C6/χ²`,
`6` `D10`-points, `7` `D12`-points, `3+3` `A4`-points; a `C2`-minus-line `P¹` contains
`6` `V4`-vertices and `2` `C6/χ`-points; `ℓ_V` contains exactly `3` `D12`-points and
`2` `A4`-points.

## FINDINGS

1. **There are two conjugacy classes of `S3` in `PSL(2,11)`, not one** (the brief listed
   `S3/D6?` as uncertain). Each class has 55 members, normalizer `D12`, and exactly one
   fixed point in `P⁴`. They are fused by the outer automorphism (as are the two `A5`
   classes), so `𝔽(P(W))` has **16** subgroup classes and **20** stratum orbits.
2. **A distinguished orbit of 55 points carries five different strata labels.** For each
   of the 55 `D12`s the unique `D12`-fixed point equals the `C6/triv`, both `S3/triv`
   and the `C3/triv` points; its full stabiliser is exactly `D12` (`D12` is maximal and
   `P(W)^G = ∅`). It is the deepest point of the complex: `7` plus-planes, `3` `V4`-lines
   and `1+1+1` further positive-dimensional strata pass through it.
3. **The deep strata are empty:** `P(W)^{C11:C5} = P(W)^{A5} = P(W)^{G} = ∅`, and this is
   *equivalent* to `W|_H` being irreducible, which holds for exactly those four classes
   (`W|_{A5}` is the 5-dimensional irreducible of `A5`; `W|_{C11:C5} = Ind_{C11}^{C11:C5}χ`).
   In particular `W^{A5} = 0`: no point of `P⁴` has stabiliser containing an `A5` or an
   `11:5`. This is the source-side counterpart of FIX-A1's `X^{A4} = ∅`.
4. **The `C11`-points are poset-isolated.** The 60 points fixed by the order-11 elements
   (12 Sylow-11s × 5 eigenlines each, one single `G`-orbit, trivial residual group) lie on
   **no** other stratum whatsoever: they are related only to `(1, P⁴)`. They are the only
   stratum orbit with this property. (In the model of `certificates/exact_weil_check.py`,
   where `T` is diagonal, these are the `G`-orbit of the 5 coordinate points.)
5. **The entire complex is the character-restriction poset.** Exactly,
   `𝔽(P(W)) ≅ {(H,χ) : H ≤ G, χ ∈ Hom(H,k^×), W_χ ≠ 0}` ordered by
   `(H,χ) ≤ (H',χ') ⟺ H ⊇ H' and χ|_{H'} = χ'`, with `G` acting by
   `g·(H,χ) = (gHg⁻¹, χ∘c_g⁻¹)`. Both the producer (linear algebra) and the verifier
   (character theory) confirm this on all 5197 edges. Downstream (Notes II/III) the source
   side of the constraint system is therefore purely combinatorial: no geometry of `P⁴`
   beyond the multiplicity data `dim W_χ` is needed.
6. **Corollary 4.4's hypothesis is verified as computed fact, not just by fiat:** every one
   of the 1502 strata is a linear subspace `P^{d}` (`d ≤ 2` for `H ≠ 1`), hence rational,
   hence RCC; the maximum dimension of a proper stratum is **2** (the 55 plus-planes).
7. **`W|_{C6}` omits exactly one character.** `W|_{C6} = χ⁰⊕χ¹⊕χ²⊕χ⁴⊕χ⁵`; the missing
   `χ³` is the character with kernel the `C3`, i.e. the one that would give a sixth
   `C6`-fixed point. This is why a `C6` has 5 fixed points and not 6, and it is the reason
   the involution in a `C6` has its `(3,2)` split arranged as `(triv,χ²,χ⁴ | χ¹,χ⁵)`.
8. **Cross-check with FIX-A1 is exact and complete** (8 independent comparisons, all PASS):
   `W|_{V4} = triv²⊕χ₁⊕χ₂⊕χ₃`; `Fix(V4) = ℓ_V ⊔ 3` points; involutions split `(3,2)`;
   `N_{ℓ_V/P⁴} = χ₁⊕χ₂⊕χ₃` with no trivial summand; exactly two `A4`-points, both on `ℓ_V`;
   `ℓ_V` carries exactly `3 D12 + 2 A4` deeper points and nothing else; each `V4`-vertex
   lies on 1 plus-plane and 2 minus-lines, each `ℓ_V` in 3 plus-planes, each minus-line
   carries 6 vertices. Nothing in FIX-A0/A1's `P⁴`-level data is contradicted or amended.

9. **The complex determines the full isotropy stratification of `P⁴`,** and it is *not*
   read off the labels: for four of the twenty orbits the pointwise stabiliser of the
   stratum is strictly larger than `H`. Recorded exactly in `pointwise_stabiliser`:

   | orbit | `H` | pointwise stabiliser | orbit size |
   |---|---|---|---|
   | `C3/triv`, `C6/triv`, `S3/triv` (both classes), `D12/triv` | `C3, C6, S3, S3, D12` | **`D12`** | one common orbit of 55 points |
   | `C5/triv`, `D10/triv` | `C5`, `D10` | **`D10`** | one common orbit of 66 points |
   | `V4/χᵢ` | `V4` | `V4` | 165 points |
   | `C5/χ`, `C5/χ²` | `C5` | `C5` | 132 + 132 points |
   | `C6/χ`, `C6/χ²` | `C6` | `C6` | 110 + 110 points |
   | `C11/χ` | `C11` | `C11` | 60 points |
   | `A4/ω`, `A4/ω²` | `A4` | `A4` | 55 + 55 points |
   | `C2/triv`, `C2/sgn` | `C2` | `C2` | 55 + 55 (generic point of the plane / line) |
   | `C3/ω`, `V4/triv` | `C3`, `V4` | `C3`, `V4` | 110, 55 (generic point of the line) |

   The fifteen 0-dimensional orbits therefore comprise only **ten distinct `G`-orbits of
   points**, `940` points in all: `165` with stabiliser `V4`, `132+132` with `C5`,
   `110+110` with `C6`, `66` with `D10`, `60` with `C11`, `55` with `D12`, `55+55` with
   `A4`. Together with the four positive-dimensional families (`55` planes and `55` lines
   with generic stabiliser `C2`, `110` lines with `C3`, `55` lines with `V4`) and `P⁴`
   itself, this is the complete isotropy stratification of the source. In particular the
   `V4`-vertices have exact stabiliser `V4` — reproducing FIX-A1's brute-force stabiliser
   scan (`A1-C3d′`) from the poset alone.

## Independence of the verifier (ALGEBRAIC-RECOMPUTE)

| Object | producer method | verifier method |
|---|---|---|
| `Q(ζ_n)` | integer numerator tuples + precomputed power-reduction table; inversion by extended Euclid | `Fraction` coefficient lists + explicit polynomial remainder mod `Φ_n`; inversion by solving the multiplication-matrix system; rank by division-free elimination |
| the group | Cayley-graph BFS from `S,T` | brute-force enumeration of the 1320 determinant-1 matrices over `F₁₁` modulo `±1` |
| subgroups | coset-representative BFS from `1` | `(cyclic subgroup, element)` closures + closure-under-extension certificate |
| strata | images of character projectors | kernels of stacked eigenvalue systems |
| multiplicities | projector ranks / character inner products | `dim V^{[H,H]}` = average of `χ_V` over the derived subgroup |
| normal types | `ν = χ̄·χ_W − dim W_χ` | quotient matrices of `ρ(h)` on `W/W_χ` in a completed basis |
| residual group | stabiliser of the **subspace** | stabiliser of the **character** |
| poset | subspace containment | containment on independently solved bases + orbit identification by explicit conjugation |
| counts | direct | two independent recounts of 1502 and 5197 |

The verifier additionally re-identifies `ρ` with the repo's representation (`g² = −11`,
`S² = T¹¹ = (ST)³ = 1`, homomorphism property, `⟨χ_W,χ_W⟩ = 1`, invariance of the Klein
cubic under `S` and `T`), and contains a harness self-test (`P(W)^{A5} ≠ ∅`) which is
recorded as a failure, as it must be.

## Deliverables

| File | Role |
|---|---|
| `produce_source_complex.py` | producer (exact; 19 s) |
| `verify_source_complex.py` | independent verifier, ALGEBRAIC-RECOMPUTE (163 s, 44 checks, 0 failures) |
| `source_complex.json` | **the canonical source-complex payload** — group, 16 subgroup classes, 620 subgroups, 1502 strata, 20 decorated orbits, 5197 poset edges, orbit-level table, sanity block. SHA-256 `dc65b7528aa9f442f5b8e3420a80e5e9d7ed1f22405c454b4c4f415c2ea57e49`, byte-reproducible |
| `STATUS.md` | this file |
| `REPLAY.md` | replay instructions, markers, hashes, independence note |

No repository file outside this packet was read into the computation, edited or deleted;
nothing was committed. The sibling packets in `goal_runs_after_2880a28/` were read only
by the verifier's cross-check (`v4_exact.json`, read-only) and not modified.
