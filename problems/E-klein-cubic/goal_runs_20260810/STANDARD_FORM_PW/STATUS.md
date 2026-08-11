# Standard (toroidal) form of the source `P(W)` — status

Problem E remains **OPEN**. This packet has **no headline claim**: it is
source-side normal form only.

Packet: `goal_runs_20260810/STANDARD_FORM_PW/` · 2026-08-10.

## Exit ledger

```text
SOURCE-STANDARD-FORM-TOWER-SEALED
SOURCE-NONABELIAN-ELIMINATION-EXACT
SOURCE-TERMINUS-ATLAS-COMPLETE
SOURCE-NO-FABULOUS-CORNER-AT-MINIMAL-TERMINUS
SOURCE-ABELIAN-FLOOR-CONFIRMED
```

Machine marker: `STANDARD_FORM_PW_VERIFY_OK` + `ALLGREEN`
(`python3 verifier.py`, ~6 min, 158 CHECK lines, 0 failures).

## The result in one paragraph

The tower is **three blowups**: blow up every stratum of the level-0
stabilizer stratification of `P(W)`, in order of increasing dimension —
**940 points**, then **220 lines**, then **55 plus-planes**. The result is in
Duncan toroidal form (hence Reichstein–Youssin standard form), with a boundary
of **1215 divisors in 14 `G`-orbits**, of which exactly **110 in 2 orbits** have
a nontrivial (always `C2`) pointwise stabilizer. No point needs more than three
blowups. All nonabelian stabilizers are gone after two stages; the abelian atlas
`{1, C2, C3, V4, C5, C6, C11}` is the permanent core.

## Per-claim table

| # | Claim | Class | Status | Evidence |
|---|---|---|---|---|
| L0 | The level-0 stabilizer stratification of `P(W)` (11 labels, 14 `G`-orbits) and its tangent/normal characters, recomputed from scratch; matches `STRATA_EXACT.md:108–123` and `NORMAL_CHARACTERS.md:71–90` | COMPUTED (2 primes), independent of the sealed producers | **PASS** | `results/s1_level0.txt` (80 CHECK) |
| L0b | `PSL(2,11)` has 16 subgroup classes; its abelian subgroups are exactly `{1,C2,C3,V4,C5,C6,C11}`; **no stratum has stabilizer `S3`** (both `S3`-classes fix exactly one point each, a `D12`-point; `A5` and `11:5` fix nothing) | COMPUTED (2 primes) | **PASS** | `results/s1_level0.txt` |
| I | Incidence table: `A4`-points are the two residual-`C3` eigenpoints of `ℓ_V`; the three `ℓ_V` in a `P_σ` are concurrent at a `D12`-point (hence 7, not 9, `D12`-points per plus-plane); `ℓ_V ∩ L'_τ = ∅` (3025 pairs) | COMPUTED (2 primes, full orbits) | **PASS** | `results/s1_level0.txt` |
| B | Lemma B (`DUNCAN_CORNER_F2`) re-applied to every centre of the tower: only `P_σ` and `L'_σ` have isotypic normal bundles | COMPUTED | **PASS** | `results/s1_level0.txt`, `results/s5_terminus.txt` |
| N1 | **Elimination Lemma**: an `H`-fixed point survives a blowup iff the normal quotient has a 1-dim `H`-subrepresentation. `D12` and `D10` need **1** round; `A4` needs **2** | PROVED + COMPUTED (2 primes) | **PASS** | `results/s2_nonabelian.txt` |
| N2 | **`A4` rigidity / terminal cycle**: repeated point blowups at an `A4`-point regenerate it forever (`1'⊕3 → 1'⊕3`); the only eliminating centre is a curve tangent to the `1'`-line, i.e. `ℓ_V`. `P(3)^{A4} = ∅` | PROVED + COMPUTED | **PASS** | `results/s2_nonabelian.txt` |
| T | **The tower** T0 (940 points) → T1 (220 lines) → T2 (55 planes) is legal: every centre is a smooth disjoint union of `G`-orbits | COMPUTED (2 primes, exhaustive over all 1540 line pairs and 1485 plane pairs) | **PASS** | `results/s4_legality.txt` |
| A | The boundary-tracking multiset automaton (exact character arithmetic for every abelian stabilizer) reaches a toroidal terminus from **every** class, in **at most 2 rounds** per class; the reachable state space is finite (**245 states**); no dead ends | COMPUTED, prime independent | **PASS** | `results/s3_automaton.txt` |
| A2 | Rule R (blow up `Z^{D(x)}`, the fixed locus of the whole defect) reproduces **Lemma C** — at a general point of `ℓ_V` it returns `ℓ_V`, not the plus-plane — and selects exactly the centres of the geometric tower | COMPUTED | **PASS** | `results/s3_centres.json` |
| A3 | Invariant: for every subgroup `L` of every stabilizer, whenever `Fix(L)` is locally a divisor it is a boundary branch (so `Z_nt ⊆ D` and rule R always has codim ≥ 2). **0 violations** over all 245 states | COMPUTED | **PASS** | `results/s3_automaton.txt` |
| Ta | **Terminus (a)**: 1215 boundary divisors, 14 orbits; exactly 110 (2 orbits, `E_σ` and `E'_σ`) have `G_E = C2`; **no `C3`-, `C5`-, `C6`-, `C11`- or `V4`-stabilized boundary divisor** | COMPUTED (2 primes) | **PASS** | `results/s5_terminus.txt` |
| Tb | **Terminus (b)**: point stabilizers are exactly `{1,C2,C3,V4,C5,C6,C11}`; 42 distinct terminal local models. `V4`-points always lie on ≥ 2 branches; **`C6`-points need not** (4 of 16 models sit on a single order-6 branch) | COMPUTED | **PASS** | `results/s3_automaton.txt` |
| Tc | **Terminus (c)**: `\|I\| ≤ 3`; crossing stabilizers are `1` or `C2` at `\|I\|=2` and `C2` at `\|I\|=3`. **No non-cyclic crossing stabilizer ⇒ no fabulous corner at this terminus.** Over the unrestricted closure the only non-cyclic one reachable is `V4` — confirming `DUNCAN_CORNER_F2`'s inventory complete | COMPUTED; the word "fabulous" uses `thm:pairs` | **PASS** | `results/s3_automaton.txt` |
| Td | **Terminus (d)**: `dim Fix(C2) ∈ {1,2,3}`, `dim Fix(C3) ∈ {0,1,2}`, `dim Fix(V4) ∈ {0,1}`, and `Fix(C5)`, `Fix(C6)`, `Fix(C11)` are **0-dimensional throughout the recursion**, with component counts per exceptional divisor | COMPUTED (2 primes) | **PASS** | `results/s5_terminus.txt` |
| M2 | Exact `QQ` chart verification, one representative per stage genre (point / curve / surface blowup): chart equivariance, fixed loci as `ideal(g·x − x)`, `codim`, `isPrime` on the crossing, pointwise stabilizers | COMPUTED, exact over `QQ` | **PASS (24/24)** | `scripts/s6_charts.m2` |
| S | Source-class invariant: the `V4` row — the only non-cyclic entry of the abelian atlas, and the reason fabulous corners exist at all — is **absent for spin sources** (`P(U)^{V4} = ∅` since the `V4`-preimage is `Q8`) | CITED, proved in the sibling packet | **PASS** | `SPIN_SOURCE_NETWORK/KLEIN_SPIN_COMPLEX.md` §1; `theory/FIX_IX_v14.md:261–266` |

## Exact checks

```text
python3 verifier.py                          # STANDARD_FORM_PW_VERIFY_OK, ALLGREEN
```

Individually:

```text
python3 scripts/s1_level0.py                 # S1_LEVEL0_OK        (80 CHECK)
python3 scripts/s2_nonabelian.py             # S2_NONABELIAN_OK    (20 CHECK)
python3 scripts/s3_automaton.py              # S3_AUTOMATON_OK     (8 CHECK)
python3 scripts/s4_legality.py               # S4_LEGALITY_OK      (16 CHECK)
python3 scripts/s5_terminus.py               # S5_TERMINUS_OK      (6 CHECK)
M2 --script scripts/s6_charts.m2             # S6_CHARTS_OK        (24/24)
```

All group/geometry work runs at **both** split primes 331 and 661 (each coprime
to `|G| = 660`, and `5, 11 | p−1`, so every element order splits). The automaton
is exact character arithmetic and prime independent. The Macaulay2 part is exact
over `QQ`. Results are `.txt`/`.json` only.

## Honesty tiering — what is sampled rather than complete

1. **`def:toroidal`(a) globally.** Local transversality of the branches holds in
   every local model (Tier 1, exhaustive). The *global* smoothness and
   irreducibility of every crossing `D_I` is argued from the projective-bundle
   structure of the exceptional divisors and verified in Macaulay2 for **one
   representative crossing** (`E_V ∩ E_z`: `codim 2`, `isPrime`), not computed
   for all 1215 divisors. **Dependency:** the terminus tables (a)–(d) are
   statements about stabilizers and characters and are Tier 1; if some crossing
   were reducible, only the "smooth irreducible" clause of (a) would need a
   further blowup to repair, which by `cor:cofinal` changes nothing downstream.
2. **Transversality of plus-plane pairs** is machine-checked on a sample rather
   than all 1485 pairs — for linear subspaces the identity
   `dim(U+V) = dim U + dim V − dim(U∩V)` is a theorem, not a computation. The
   *incidence* half (that every pairwise intersection is an earlier centre) **is**
   exhaustive.
3. **Component counts in table (d)** are counted **at the moment of creation**
   inside each exceptional divisor. No component is destroyed later (no created
   locus is itself a later centre), but components created at T0 can be met by
   the T1/T2 centres. **CORRECTED 2026-08-11** (`TERMINUS_STRATA_PW` §7,
   confirmed at adjudication of PR #31): those counts are **lower bounds** —
   `s5_terminus.py` de-duplicates rows on a signature that merges distinct
   `G`-orbits. Exact values are in THEOREM.md §5(d). The dimension **profiles**
   and every exit string of this packet are unaffected.
4. The `X`-related annotations (which strata lie on the Klein cubic) are carried
   from `STRATA_EXACT.md` and re-verified only by the `F ≡ 0` test mod `p`.

## Not proved here

1. **`thm:pairs`** (fabulous ⟺ non-cyclic) is EXTERNAL-UNVERIFIED
   (`NOTEBOOK.md:4660–4670`). It is used for exactly one sentence — reading "no
   non-cyclic crossing stabilizer" as "no fabulous corner". The computed
   statement is unconditional.
2. No claim that this tower is canonical or minimal. Other toroidal models exist
   (`cor:cofinal`) and can carry things this one does not: a `C3`-stabilized
   boundary divisor, and the 330 fabulous `V4`-corners of `DUNCAN_CORNER_F2`
   (one further legal blowup — their T3).
3. Nothing about the target `X`: no landing constraint, no receiver analysis, no
   use of `prop:rcc_total`.

## Boundary in one line

The source has a three-step standard form and a permanent abelian core of seven
classes; the only non-cyclic one, `V4`, is the entire reason the Duncan corner
mechanism exists here — and it is exactly the row a spin source does not have.
