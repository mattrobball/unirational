# The standard (toroidal) form of the source `P(W)`: the complete tower and its terminus

**Packet:** `goal_runs_20260810/STANDARD_FORM_PW/` · opened 2026-08-10.
**Headline: Problem E remains OPEN.** This packet contains no headline claim.
It builds and verifies the *source-side* normal form only: the equivariant
blowup tower that puts `P(W) ≅ P⁴` with its `PSL(2,11)`-action into Duncan's
toroidal form, and documents its terminus completely.

*(Filename note: the main document is `THEOREM.md`, matching the sibling
packets in `goal_runs_20260810/`; the harness refuses the literal name
`REPORT.md`.)*

## Exit ledger

```text
SOURCE-STANDARD-FORM-TOWER-SEALED
SOURCE-NONABELIAN-ELIMINATION-EXACT
SOURCE-TERMINUS-ATLAS-COMPLETE
SOURCE-NO-FABULOUS-CORNER-AT-MINIMAL-TERMINUS
SOURCE-ABELIAN-FLOOR-CONFIRMED
```

Machine marker: `STANDARD_FORM_PW_VERIFY_OK` / `ALLGREEN` (`python3 verifier.py`).

---

## 0. The statement being realized

`external_docs/duncan_higher_obstruction_20260805.tex`, `def:toroidal`
(lines 66–82), verbatim:

> Let `X` be a smooth projective variety with a faithful action of `G` and let
> `D = D_1 ∪ … ∪ D_n` be a `G`-stable divisor with distinct irreducible
> components `D_i`. We say `X` is in **toroidal form** with respect to `D` if
> (a) for every `I ⊆ {1,…,n}` the intersection `D_I := ∩_{i∈I} D_i` is either
> empty or a smooth irreducible subvariety of codimension exactly `|I|`; in
> particular `D` has simple normal crossings;
> (b) `X_nt ⊆ D`; and
> (c) for every `x ∈ X`, writing `I(x) := {i | x ∈ D_i}`, the stabilizer `G_x`
> preserves each `D_i` with `i ∈ I(x)`, and the resulting representation of
> `G_x` on `⊕_{i∈I(x)} (T_xX/T_xD_i)` is faithful.

The commentary at lines 83–90 records that (c) forces `G_x` abelian of rank
`≤ |I(x)|`, acting diagonally in suitable local coordinates with the branches of
`D` as coordinate hyperplanes. `thm:toroidal_resolution` (line 92) guarantees a
toroidal model exists; `cor:cofinal` (line 202) that they are cofinal. This
packet *constructs* one for `P(W)` and reads off its complete atlas. Because all
stabilizers in toroidal form are abelian, this is simultaneously a
Reichstein–Youssin **standard form** for the source.

**Local acceptance criterion (the form used throughout).** At `x` with abelian
stabilizer `K` and tangent weights `w_0,…,w_3` (characters of `K`), let
`B(x) = {w_j : {u_j = 0}` is a branch of `D}`. Then

> **`x` is toroidal ⟺ `B(x)` generates `K̂` ⟺ `D(x) := ∩_{β∈B(x)} ker β = 1`.**

Condition (c) is literally `∩_{β∈B(x)} ker β = 1`; and (c) **implies** (b)
pointwise, because for `h ≠ 1` in `K` the local fixed locus
`Fix(h) = ∩_{j : w_j(h)≠0}{u_j = 0}` lies inside `{u_β = 0}` for any `β ∈ B(x)`
with `β(h) ≠ 0`, and such a `β` exists exactly when `h ∉ D(x)`. Condition (a)
is local transversality (automatic in the diagonal model) plus the global
smoothness/irreducibility of the crossings (see §7, honesty tiering). We call
`D(x)` the **defect**.

---

## 1. The level-0 atlas of `P(W)` — re-verified, not imported

`scripts/s1_level0.py`, both split primes 331 and 661; `results/s1_level0.txt`
(80 CHECK lines, 0 failures). Independent of
`certificates/strata/exact_strata.py`; it rebuilds the subgroup lattice by
cyclic extension, computes linear characters of each subgroup by scanning
admissible values on a generating set, and takes joint eigenspaces.

* `G = PSL(2,11)` has **16 conjugacy classes of subgroups**, and its abelian
  subgroups are exactly of types **`{1, C2, C3, V4, C5, C6, C11}`**.
* The full pointwise-stabilizer stratification of `P(W)`, with generic
  stabilizer `H`, setwise stabilizer, and `G`-orbit sizes — this reproduces
  `certificates/STRATA_EXACT.md:108–123` exactly:

| stratum | `dim` | `H` | `Stab_G` | orbits | on `X`? |
|---|---:|---|---|---|:--:|
| plus-plane `P_σ = P(W_σ^+)` | 2 | `C2` | `D12` | 55 | no |
| minus-line `L'_σ = P(W_σ^-)` | 1 | `C2` | `D12` | 55 | yes |
| `C3`-eigenline | 1 | `C3` | `C6` | 110 | no |
| `V4`-line `ℓ_V = P(A)` | 1 | `V4` | `A4` | 55 | no |
| type-I `V4`-point | 0 | `V4` | `V4` | 165 | yes |
| `C5`-point (a), (b) | 0 | `C5` | `C5` | 132 + 132 | yes |
| `C6`-point (a), (b) | 0 | `C6` | `C6` | 110 + 110 | no / yes |
| `C11`-point | 0 | `C11` | `C11` | 60 | yes |
| `D10`-point | 0 | `D10` | `D10` | 66 | no |
| `A4`-point (a), (b) | 0 | `A4` | `A4` | 55 + 55 | no |
| `D12`-point | 0 | `D12` | `D12` | 55 | no |

  **11 labels, 14 `G`-orbits, 940 points + 220 lines + 55 planes.** Machine-
  checked completeness of the list: `A5` (both classes) and `11:5` have **no**
  fixed point on `P(W)`, and each of the two `S3`-classes fixes exactly one
  point, which is a `D12`-point — so **no stratum has pointwise stabilizer
  `S3`**, and the eleven labels above are all of them.

* Tangent and normal characters (matching `NORMAL_CHARACTERS.md:71–90`) and
  **Lemma B** of `DUNCAN_CORNER_F2` — `G_E = ker(H → PGL(N))`, so `G_E ≠ 1` iff
  `N` is `H`-isotypic — re-verified for every stratum:

| centre | normal rep `N` as `H`-module | isotypic? | `G_E` |
|---|---|:--:|---|
| `P_σ` | `sign^{⊕2}` | **yes** | `⟨σ⟩` |
| `L'_σ` | `sign^{⊕3}` | **yes** | `⟨σ⟩` |
| `ℓ_V` | `χ_z ⊕ χ_s ⊕ χ_r` | no | `1` |
| `C3`-line | `ω̄ ⊕ ω ⊕ ω` | no | `1` |
| type-I `V4` | `χ_z^{⊕2} ⊕ χ_s ⊕ χ_r` | no | `1` |
| `C5`, `C6`, `C11` points | 4 **distinct** nontrivial characters | no | `1` |
| `D12` point | `2 ⊕ ε·2` (two 2-dim irreps) | no | `1` |
| `D10` point | `2_a ⊕ 2_b` | no | `1` |
| `A4` point | `1' ⊕ 3` | no | `1` |

* The **incidence table** the schedule turns on (all counts exhaustive over the
  full `G`-orbits, both primes):

| point orbit | on `C3`-lines | on `P_σ` | on `L'_σ` | on `ℓ_V` |
|---|---:|---:|---:|---:|
| `A4`(a), `A4`(b) | 4 | 3 | 0 | **1** |
| `C6`(a) (off `X`) | 1 | 1 | 0 | 0 |
| `C6`(b) (on `X`) | 1 | 0 | 1 | 0 |
| `D10` | 0 | 5 | 0 | 0 |
| `D12` | 0 | 7 | 0 | **3** |
| type-I `V4` | 0 | 1 | **2** | 0 |
| `C5`, `C11` | — | — | — | — (isolated) |

  and: `ℓ_V ⊂ P_σ` for the three `σ ∈ V∖1`; **`ℓ_V ∩ L'_τ = ∅` for all 3025
  pairs** (re-derives `DUNCAN_CORNER_F2` W2.3b); the 55 `ℓ_V` meet 6 siblings
  each, always at a `D12`-point.

  Two facts worth naming, both new here: **the two `A4`-points of a `V4` are
  exactly the two residual-`C3` eigenpoints of `ℓ_V`** (`W^{V4} = 1' ⊕ 1''` as
  an `A4`-module), and **the three `ℓ_V` inside a plus-plane `P_σ` are
  concurrent at the `D12`-point of `C_G(σ)`** (`P_σ = P(triv ⊕ 2)` as a
  `D12`-module, and the three `ℓ_V` all contain the trivial line) — which is why
  `P_σ` carries `1 + 3·2 = 7` `D12`-points, not 9.

---

## 2. Elimination of the nonabelian stabilizers — exact, with a rigidity

Toroidal form forces `G_x` abelian, so `D12`, `D10` and `A4` must be destroyed.
`scripts/s2_nonabelian.py` (both primes; `results/s2_nonabelian.txt`).

> **Elimination Lemma.** Let `C` be a smooth `H`-invariant centre through `x`
> with `T_xC = S` an `H`-submodule and `N = T_xZ/S` of rank `≥ 2`. The
> `H`-fixed points of the exceptional fibre `P(N)` over `x` are exactly the
> 1-dimensional `H`-subrepresentations of `N`. **So the `H`-fixed point at `x`
> disappears iff `N` has no 1-dimensional `H`-subrepresentation.**

For each of the three, `⟨χ_T, χ_T⟩ = 2` with distinct constituents, so the
submodule lattice of `T_x` is `{0, A, B, T_x}` and the legal centres are
completely enumerated:

| `H` | `T_x P(W)` | 1-dim submodules | legal centres of codim `≥ 2` | rounds |
|---|---|---:|---|---:|
| `D12` | `2 ⊕ ε·2` | **0** | the point (codim 4), each `2` (codim 2) — all eliminate | **1** |
| `D10` | `2_a ⊕ 2_b` | **0** | the point, each `2` — all eliminate | **1** |
| `A4` | `1' ⊕ 3` | **1** | the point (codim 4) **regenerates**; the curve tangent to `1'` (codim 3) eliminates | **2** |

> **`A4` rigidity.** Blowing up an `A4`-point is a **fixed point of the
> blowup automaton**: `T_q = 1' ⊕ 3` reproduces itself
> (`O(-1)|_q ⊕ Hom(1',3) = 1' ⊕ (3 ⊗ 1'') = 1' ⊕ 3`), so the `A4`-stabilizer
> survives forever under repeated point blowups. The **only** eliminating centre
> is a smooth `A4`-invariant **curve** tangent to the `1'`-line. On `P(W)` that
> curve is `ℓ_V` — because `W^{V4} = 1' ⊕ 1''`, so `ℓ_V = P(W^{V4})` is the line
> joining the two `A4`-points, and `T_p ℓ_V` is the `1'`-line. Machine-checked:
> `P(3)` has **0** `A4`-fixed points, so the second round finishes.

This is the exhibited **terminal cycle** the work order asks for: length 1, at
the `A4`-point, under the naive "blow up the deepest stratum" rule; broken only
by taking the fixed locus of a *proper* subgroup (`V4 ⊂ A4`) as the centre.

The same computation lists the strata of every exceptional `P³` by exact
pointwise stabilizer; these are the extra seeds of §4. Notable: `E_{D12}` carries
three `V4`-points at which the `E_{D12}`-branch has **trivial** normal character
(the three `ℓ̃_V` meeting it) — these are the deepest non-toroidal points of the
whole tower.

---

## 3. The tower

> **Theorem (source standard form).** Let `Z → P(W)` be the composite of the
> three `G`-equivariant blowups
>
> * **T0** — the **940 points** of the point strata (10 `G`-orbits: `D12` 55,
>   `A4` 55+55, `C11` 60, `D10` 66, `C6` 110+110, `C5` 132+132, type-I `V4` 165);
> * **T1** — the strict transforms of the **220 lines** (3 `G`-orbits: 55 `ℓ_V`,
>   110 `C3`-eigenlines, 55 minus-lines `L'_σ`);
> * **T2** — the strict transforms of the **55 plus-planes** `P_σ`;
>
> with `D` the total exceptional divisor. Then `Z` is in toroidal form with
> respect to `D`, hence in Reichstein–Youssin standard form. `D` has
> **1215 irreducible components in 14 `G`-orbits**.

In one sentence: **blow up every stratum of the level-0 stabilizer
stratification, in order of increasing dimension.** Nothing else is needed —
the recursion demands no centre that is not already a strict transform of a
level-0 stratum (§4).

**Legality** (`scripts/s4_legality.py`, both primes, `results/s4_legality.txt`):

* T0 is smooth: the 940 points are pairwise distinct (their stabilizer orders
  are `{4,5,6,10,11,12}`, so no two coincide).
* T1 is smooth: all `1540` incident pairs among the 220 lines meet in a **single
  point**, and every one of those points is a T0 centre (stabilizer orders
  `{4: 165, 6: 110, 12: 1265}` — type-I `V4`, `C6`, and `A4`/`D12`). Distinct
  lines through a common point have distinct tangent directions, so their strict
  transforms hit the exceptional `P³` in distinct points.
* T2 is smooth: the `1485` plus-plane pairs meet in an `ℓ_V` (165 pairs, blown
  up at T1) or in a single `D10`/`D12`-point (1320 pairs, blown up at T0); the
  transversality identity `dim(U+V) = dim U + dim V − dim(U∩V)` holds, which is
  exactly the statement that the strict transforms separate. (For linear
  subspaces this is automatic, and it is verified.)
* Each centre is a connected component of `Z_k^H ∩ D_J^{(k)}`, so the tower is
  **stabilizer-stratified** in the sense of `def:stratified_tower` (line 1162),
  and every stratum is rational (`lem:rational_strata_propagate`, line 1186),
  since every `P(W)^H` is a union of linear subspaces.

**Depth.** No point of `P(W)` needs more than three blowups. The deepest chain
is `D12`-point `→` `ℓ̃_V` `→` `P̃_σ` (T0, T1, T2).

`scripts/s6_charts.m2` re-does one representative per stage genre exactly over
`QQ` (24/24 checks): the chart maps and transported actions, the fixed loci as
`ideal(g·x − x)` with their codimensions, `isPrime` on the crossing, and the
pointwise stabilizers by testing which automorphisms act trivially.

---

## 4. The automaton, and the recursion run to acceptance

`scripts/s3_automaton.py` (exact character arithmetic, prime independent;
`results/s3_automaton.txt`).

**State.** `(K, [(w_0,f_0),…,(w_3,f_3)])`, `w_j` a character of the abelian
stabilizer `K` written as its value vector on the sorted elements of `K`, `f_j`
the boundary flag. States are canonicalized: `K` is re-expressed in the
canonical group of its isomorphism type, values are rescaled to `exp(K)`, and
the labelling is reduced modulo `Aut(K)`.

**Transition (the `DUNCAN_CORNER_F2` rule, generalized).** Blow up the centre
with tangent slots `S`, `|S| ≤ 2`, `N` = complement. For `Σ ⊆ N` (a point `[v]`
generic in the span of the `Σ`-slots):

```
K'  = { h ∈ K : w_j(h) equal for all j ∈ Σ }
χ   = w_{j0}|K'   (j0 ∈ Σ)
slots' = [ (w_j|K', f_j) : j ∈ S ]          # branches containing C survive
       + [ (χ, BOUNDARY) ]                  # the new divisor E
       + [ (0, free) : j ∈ Σ∖{j0} ]         # directions inside the Σ-block
       + [ ((w_l − χ)|K', f_l) : l ∈ N∖Σ ]  # branches twisted by O(-1)
```

The consumed slot `j0` is exactly the branch whose strict transform misses
`[v]`; `E` replaces it. Forgetting the flags and specializing `K = V4` gives
`DUNCAN_CORNER_F2`'s `w3_corner_inventory.py` PART 2 rule verbatim.

**Resolution rule R.** At a non-toroidal `x`, blow up the component through `x`
of `Z^{D(x)}` — the fixed locus of the **whole defect group**:
`S = {j : w_j|_{D(x)} = 0}`. Its codimension is `≥ 2`: a codim-1 `D(x)`-fixed
locus would be a `D(x)`-fixed **divisor**, hence a component of `Z_nt ⊆ D`,
hence a branch whose normal character is nontrivial on `D(x)` — contradicting
the definition of the defect. That invariant is machine-checked for every
subgroup `L ⊆ K` over the whole reachable set (**0 violations**).

Taking the fixed locus of the whole defect, rather than of one element of it, is
exactly what makes **Lemma C** of `DUNCAN_CORNER_F2` come out: at a general
point of `ℓ_V` the defect is `V4` and the rule returns `ℓ_V = Z^{V4}` (codim 3),
**not** the plus-plane `Z^{⟨z⟩}` (codim 2) whose `G`-orbit is not disjoint there.
Rule R and the geometric tower of §3 select the same centres at every point.

**The run.** 9 level-0 abelian seeds + 39 distinct abelian strata created inside
the `D12`/`D10`/`A4` exceptional divisors. Every one reaches a toroidal terminus;
**at most 2 rounds each**:

| class | rounds under R | what the rounds are |
|---|---:|---|
| `C11`-point | 1 | T0 |
| `C5`-point | 1 | T0 |
| `C3`-eigenline | 1 | T1 |
| minus-line `L'_σ` | 1 | T1 |
| plus-plane `P_σ` | 1 | T2 |
| `C6`-point (a) and (b) | 2 | T0, then T1 (`C̃3`-line or `L̃'_σ`) or T2 (`P̃_σ`) |
| type-I `V4`-point | 2 | T0, then T2 (`P̃_z`) |
| `ℓ_V` | 2 | T1, then T2 (`P̃_z`) |
| `V4`-point of `E_{D12}` on `ℓ̃_V` | 2 | T1, then T2 |
| `D12`-point, `D10`-point | 1 | T0 (nonabelian; §2) |
| `A4`-point | 2 | T0, then T1 (`ℓ̃_V`) (nonabelian; §2) |

**Finiteness and no dead ends.** The exhaustive closure under *every*
stabilizer-stratified centre (not just rule R's) has **245 states**, 63 of them
non-toroidal, and rule R applies at every one. **At most 3 boundary branches
pass through any point** — `def:toroidal`(a) is never strained.

---

## 5. The terminus tables

`scripts/s5_terminus.py` (both primes; `results/s5_terminus.txt`).

### (a) Boundary divisor classes

| stage | centre | count | `H_C` | normal rep | **`G_E`** | `Stab_G(E)` | lies over |
|---|---|---:|---|---|:--:|---|---|
| T0 | `D12`-point | 55 | `D12` | `2 ⊕ ε·2` | `1` | `D12` | `P(W^{C3})` |
| T0 | `A4`-point (a) | 55 | `A4` | `1' ⊕ 3` | `1` | `A4` | `C3`-eigenpoint of `ℓ_V` |
| T0 | `A4`-point (b) | 55 | `A4` | `1' ⊕ 3` | `1` | `A4` | the other one |
| T0 | `C11`-point | 60 | `C11` | 4 distinct | `1` | `C11` | on `X` |
| T0 | `D10`-point | 66 | `D10` | `2_a ⊕ 2_b` | `1` | `D10` | `[1:1:1:1:1]`-orbit |
| T0 | `C6`-point (a) | 110 | `C6` | 4 distinct | `1` | `C6` | on `C3`-line ∩ `P_σ` |
| T0 | `C6`-point (b) | 110 | `C6` | 4 distinct | `1` | `C6` | on `C3`-line ∩ `L'_σ` |
| T0 | `C5`-point (a) | 132 | `C5` | 4 distinct | `1` | `C5` | on `X` |
| T0 | `C5`-point (b) | 132 | `C5` | 4 distinct | `1` | `C5` | on `X` |
| T0 | type-I `V4`-point | 165 | `V4` | `χ_z^{⊕2}⊕χ_s⊕χ_r` | `1` | `V4` | `P_z ∩ L'_s ∩ L'_r` |
| T1 | `ℓ_V` | 55 | `V4` | `χ_z⊕χ_s⊕χ_r` | `1` | `A4` | `P(W^{V4})` |
| T1 | `C3`-eigenline | 110 | `C3` | `ω̄⊕ω⊕ω` | `1` | `C6` | `P(W_ω)` |
| T1 | minus-line `L'_σ` | 55 | `C2` | `sign^{⊕3}` | **`⟨σ⟩`** | `D12` | `P(W_σ^-) ⊂ X` |
| T2 | plus-plane `P_σ` | 55 | `C2` | `sign^{⊕2}` | **`⟨σ⟩`** | `D12` | `P(W_σ^+)` |

**1215 boundary divisors in 14 `G`-orbits. Exactly 110 of them, in 2 orbits,
have nontrivial pointwise stabilizer, and it is always `C2`.**

> **No `C3`-, `C5`-, `C6`-, `C11`- or `V4`-stabilized boundary divisor is ever
> created.** Machine-checked two ways: by Lemma B on the table above (no centre
> of the tower has an isotypic normal representation except `P_σ` and `L'_σ`),
> and over the whole tower state set (**only `1` and `C2` occur**).
> *Honest caveat:* over the **unrestricted** closure — every stabilizer-stratified
> centre, not just this tower's — a **`C3`-stabilized divisor is possible**
> (blow up a centre whose normal bundle is `C3`-isotypic of rank 2; this becomes
> available only once two boundary branches are present, e.g. inside `E_{C3\text{-line}}`).
> So "no `C3`-divisor" is a property of *this* terminus, not of all toroidal models.

### (b) Point-stabilizer classes on the terminus

All seven abelian subgroup types occur, and only those:
**`{1, C2, C3, V4, C5, C6, C11}`** — exactly the abelian subgroups of
`PSL(2,11)`, as forced by `def:toroidal`(c) and §2. 42 distinct terminal local
models. Where each one sits:

| `K` | # terminal local models | # boundary branches through the point | reading |
|---|---:|---|---|
| `1` | 2 | 1 or 2 | free points on `D`, and on double crossings |
| `C2` | 7 | 1, 2 or 3 | on a `C2`-divisor; on `C2`∩`C2`; and on one triple crossing |
| `C3` | 9 | 1 or 2 | a single branch of normal character `ω`, or a `1`∩`ω` pair |
| `V4` | 3 | **2 or 3 (never 1)** | forced: `V̂4` is not cyclic, so at least two independent normal characters are needed |
| `C5` | 1 | 1 | a single branch of normal character of order 5 |
| `C6` | 16 | 1 or 2 | either one branch of normal character of order 6, or a pair generating `Z/6` |
| `C11` | 4 | 1 | a single branch of normal character of order 11 |

The work order's expectation "`V4` on `C2∩C2` crossings; `C6` on `C2∩C3`" is
**half right and is corrected here**: `V4`-points do always lie on a crossing of
two branches with independent characters, but `C6`-points need **not** — 4 of
the 16 `C6` terminal models sit on a *single* divisor whose normal character has
order 6.

### (c) Crossing combinatorics

* `|I| ≤ 3` everywhere. Crossings occur with `|I| = 2` and `|I| = 3`.
* Generic pointwise stabilizers of the crossings: `|I| = 2 → 1` or `C2`;
  `|I| = 3 → C2`.
* **No crossing of the terminus has a non-cyclic generic stabilizer.** By
  `thm:pairs` (line 728, fabulous ⟺ non-cyclic) this means:

> **The terminus of this tower carries NO fabulous corner.**

  This *sharpens rather than contradicts* `DUNCAN_CORNER_F2`. That packet's 330
  corners (2 `G`-orbits of 165, all with `G_{D_ij} = V4`) are created by **one
  further legal blowup** — their T3, the surface `M̃_τ^V = P(N_{ℓ_V} ∩ W_τ^-)`
  inside `E_V`. That surface has generic pointwise stabilizer `⟨τ⟩` and is
  already toroidal at the terminus of §3, so the toroidal condition does not
  *require* blowing it up; blowing it up is legal (it is a component of
  `Z^{⟨τ⟩} ∩ E_V`, so stabilizer-stratified) and by `cor:cofinal` one may always
  pass to such a further model. The automaton's exhaustive closure confirms the
  inventory: **the only non-cyclic crossing stabilizer reachable at all is `V4`**,
  at `|I| = 2` and `|I| = 3`. `DUNCAN_CORNER_F2`'s inventory is complete; what
  this packet adds is *where in the tower* those corners live — strictly below
  the minimal standard form.

### (d) Dimension profile of the fixed loci at the terminus

Local dimensions of `Fix(A)` at terminal points, and the components the tower
creates inside the exceptional divisors (`G`-orbit counts, exact at both primes):

| `A` | `dim Fix(A)` at terminal points | components created inside exceptional divisors, by dimension |
|---|---|---|
| `C2` | **1, 2, 3** | `dim 1`: 1155 · `dim 2`: 440 · `dim 3`: 110 (`= E_σ ⊔ E'_σ`) |
| `C3` | **0, 1, 2** | `dim 0`: 440 · `dim 1`: 880 · `dim 2`: 110 |
| `V4` | **0, 1** | `dim 0`: 660 · `dim 1`: 330 |
| `C5` | **0 only** | `dim 0`: 396 |
| `C6` | **0 only** | `dim 0`: 330 |
| `C11` | **0 only** | `dim 0`: 60 |

Two answers to questions the work order posed as open:

1. **`C5`-fixed loci stay zero-dimensional through the whole recursion**, and so
   do `C6`- and `C11`-fixed loci. The reason is structural, not accidental: for
   `A ∈ {C5, C6, C11}` the tangent weights at every `A`-fixed point of `P(W)`
   are **four distinct nontrivial characters** (§1), the twisted multiset
   `{χ} ∪ {ν − χ}` never acquires a trivial weight, and `A` never appears as the
   stabilizer of a positive-dimensional level-0 stratum. Repeats *do* appear in
   the twisted multisets (e.g. `(1,1,2,3)` for `C5`), but they raise the rank of a
   **nontrivial** eigenspace, not of the trivial one — which is what a
   positive-dimensional fixed locus would need.
2. **`Fix(C2)` is not purely divisorial at the terminus.** Besides the 110
   `C2`-fixed divisors it has 2-dimensional and 1-dimensional components: e.g.
   the "minus part" `P(T_p^-)` inside every `E_p` for a point `p` of `Fix(σ)`,
   which is a genuinely new stratum created by the tower and not the transform of
   anything on `P(W)`. Toroidal form does not require these to be blown up: they
   already lie inside a boundary divisor whose normal character is `sign`.

---

## 6. Consequences

### (i) The permanent core, and the Reichstein–Youssin floor

> **What the tower removes.** *All* nonabelian stabilizers: `D12` (1 round),
> `D10` (1 round), `A4` (2 rounds, with a forced centre). `S3` never occurs as a
> stabilizer on `P(W)` at all. After T0–T1 no point of any model in the tower
> has a nonabelian stabilizer.
>
> **What survives every model.** The abelian atlas
> `{1, C2, C3, V4, C5, C6, C11}`. By Reichstein–Youssin invariance an abelian
> stabilizer that occurs on one smooth model occurs on every smooth birational
> model — equivariant blowups can move, split and re-dimension the fixed loci,
> but cannot delete an abelian conjugacy class from the atlas. Concretely: an
> abelian `A` has fixed points on `P(W)` because `W|_A` splits into characters,
> and every model dominating `P(W)` inherits them.

This is the **permanent core of the source**: the seven abelian classes, with
`V4` the unique non-cyclic one. Everything the obstruction machine can ever see
from the source side is a decoration of that list.

### (ii) The source-class invariant: the `V4` row and spin sources

The unique non-cyclic entry of the atlas, `V4`, is precisely what makes fabulous
corners possible at all (Proposition A of `DUNCAN_CORNER_F2`: fabulous ⟺
`G_{D_ij}` non-cyclic, and the 55 Klein four-groups are the only non-cyclic
abelian subgroups of `PSL(2,11)`). It is also exactly the row that is **absent
for spin sources**:

| source | abelian atlas | non-cyclic entry | fabulous corners available? |
|---|---|---|---|
| **linear** `P(W)`, `W` the 5-dim `PSL(2,11)`-irrep | `1, C2, C3, V4, C5, C6, C11` | **`V4`** (55 of them) | yes |
| **spin** `P(U)`, `U` a faithful `SL(2,11)`-rep | `V4` **absent** | none | no |

For a spin source the preimage of a Klein four-group in `SL(2,11)` has order 8
and contains the unique involution `−I`, hence is `Q8`; `U|_{Q8}` is a multiple
of the 2-dimensional quaternionic irreducible, which has **no** 1-dimensional
summand, so `P(U)^{V4} = ∅`. Predicted at `theory/FIX_IX_v14.md:261–266`
("`U|_{Q8}` is expected quaternionic (no 1-dim summands ⟹ `P(U)^{V4} = ∅`)")
and **proved** in today's sibling packet
`goal_runs_20260810/SPIN_SOURCE_NETWORK/KLEIN_SPIN_COMPLEX.md` §1 (all 55 Klein
four-groups, `U|_{Q8} = 3·H`), with the general statement in its
`THEORY_SPIN_ENGINE.md` Prop 2.2 / Cor 2.3. **The presence or absence of the
`V4` row is a birational invariant of the source class**, and it is what decides
whether the Duncan corner mechanism has any purchase at all.

### (iii) New crossing types beyond the corner packet

* **New:** a `|I| = 3` crossing type with generic stabilizer `C2` (a `C2`-fixed
  divisor meeting two further branches). `DUNCAN_CORNER_F2` worked only at
  `|I| = 2` and did not see it. It is not fabulous (`C2` is cyclic), and
  `|I| ≥ 3` gives only connectedness, not RCC (`prop:rcc` remark, lines 572–586),
  so it carries no new landing constraint.
* **New:** the `C2`-fixed loci of dimensions 1 and 2 inside the point
  exceptional divisors (the "minus parts" `P(T_p^-)`), 1155 + 440 components.
  These are the natural carriers of deep normal data of the kind (F2) constrains,
  and none of them was in the corner packet's inventory.
* **Completeness confirmation:** the only non-cyclic crossing stabilizer
  reachable by *any* stabilizer-stratified tower over `P(W)` is `V4`
  (exhaustive closure, 245 states). The corner packet's fabulous inventory
  stands complete.
* **Correction of emphasis:** the fabulous corners are **not** present on the
  minimal standard form; reaching them costs one extra blowup beyond
  toroidality. Any argument that uses them must say "pass to a further toroidal
  model", which `cor:cofinal` licenses.

---

## 7. Honesty tiering

**Complete and exact (Tier 1).** Everything local: the multiset automaton and
its exhaustive closure (exact character arithmetic, no primes involved), the
acceptance criterion, the elimination lemma and the tangent representations of
the nonabelian points, Lemma B applications, the terminus tables (a)–(d) as
statements about local models, the divisor and crossing stabilizers.

**Complete over all `G`-orbits, read off mod `p` at two split primes
(Tier 2).** The level-0 stratification and its orbit counts; the tangent/normal
characters; the incidence table; the legality checks of §3 (all 1540 line pairs,
all 1485 plane pairs, all 940 points). Primes 331 (the repo's own full-split
prime, `STRATA_EXACT.md:98`) and 661 (`11 | p−1`, `5 | p−1`); both are coprime to
`|G| = 660`, so reduction is a bijection on irreducible characters and on the
lattice of subrepresentations, and every rank/dimension/incidence statement used
is stable under reduction.

**Exact over `QQ` (Tier 1).** `scripts/s6_charts.m2`: one representative chart
per stage genre, 24/24, including `isPrime` and `codim` on the crossing.

**Sampled, and flagged as such (Tier 3).**

1. **Global smoothness and irreducibility of the crossings `D_I`
   (`def:toroidal`(a)) is verified locally (transversality in every local model)
   and in M2 for one representative crossing, not globally for all 1215
   divisors.** The centres are linear or bundles over linear subspaces, so the
   exceptional divisors are projective bundles and their pairwise crossings are
   sub-bundles; that argument is written out for the `E_V ∩ E_z` genre and
   asserted for the rest. **Dependency:** the terminus statements in §5 are
   statements about the *stabilizer/character data*, which is Tier 1; if a
   crossing turned out reducible, the divisor and stabilizer tables would stand
   and only the "smooth irreducible of codimension `|I|`" clause of
   `def:toroidal`(a) would need a further blowup to repair — which by
   `cor:cofinal` does not change anything downstream.
2. The transversality identity for plus-plane pairs is checked on a sample
   (`i` step 7, `j` step 11) rather than all 1485 pairs, because for linear
   subspaces it is a theorem, not a computation.
3. `Stab_G` of the strata created *inside* exceptional divisors is computed as
   the stabilizer of the corresponding subspace pair `(U, V_λ)` in `G`; the
   resulting orbit counts in §5(d) are exact, but they count components **at the
   moment of creation**. Components created at T0 can be met (not destroyed) by
   the T1/T2 centres; no component is destroyed, since no created locus is
   itself a later centre.

---

## 8. Dependencies

**Imports, and their grade.**

| import | label / lines | used for | grade |
|---|---|---|---|
| toroidal form, its existence and cofinality | `def:toroidal` 66–90, `thm:toroidal_resolution` 92, `cor:cofinal` 202 | the target of the whole construction | definition + existence; this packet *constructs* the model, so only the definition is load-bearing |
| stabilizer-stratified towers, rationality of strata | `def:stratified_tower` 1162, `lem:rational_strata_propagate` 1186 | §3 legality framing | not load-bearing for the tables |
| fabulous ⟺ non-cyclic | `thm:pairs` 728 | **only** the sentence "no fabulous corner at the terminus" in §5(c) | **EXTERNAL-UNVERIFIED** (`NOTEBOOK.md:4660–4670`) |
| Reichstein–Youssin standard form | cited by name | §6(i) vocabulary | classical |

`thm:pairs` is the only EXTERNAL-UNVERIFIED import that touches a conclusion,
and it touches exactly one: the *interpretation* of "no non-cyclic crossing
stabilizer" as "no fabulous corner". The computed statement — every crossing of
the terminus has cyclic generic stabilizer — is unconditional.

**Repo certificates re-verified (not merely pinned).**
`certificates/STRATA_EXACT.md:39, 108–123, 205–233`;
`certificates/NORMAL_CHARACTERS.md:42–45, 71–90`. Both are reproduced from
scratch by `scripts/s1_level0.py` without importing their producers.

**Repo results consumed and extended.**
`goal_runs_20260810/DUNCAN_CORNER_F2/`: Lemma B (§2 of its `THEOREM.md`),
Lemma C (§3), the transition rule (`w3_corner_inventory.py` PART 2), the W2
disjointness checks (extended here from `{ℓ_V, P_σ}` to all 940 + 220 + 55
centres), Proposition A (the 55 `V4`s are the only non-cyclic abelian
subgroups). Nothing in that packet is contradicted.
`goal_runs_20260810/SPIN_SOURCE_NETWORK/KLEIN_SPIN_COMPLEX.md` §1 and
`THEORY_SPIN_ENGINE.md` Cor 2.3 for §6(ii); `theory/FIX_IX_v14.md:261–266` for
the prediction those close.

---

## 9. Not claimed

* **No headline claim.** Problem E remains OPEN. This is source-side normal
  form only; nothing here is a statement about `X`, about equivariant
  unirationality, or about `ed_C(PSL(2,11))`.
* No claim that this tower is *the* canonical or minimal one — only that it is a
  legal stabilizer-stratified tower reaching toroidal form, and that its
  terminus is completely described. Other toroidal models exist (`cor:cofinal`)
  and may carry, for instance, `C3`-stabilized boundary divisors and fabulous
  corners, both of which this one does not.
* No claim about the target side: no landing constraint, no receiver analysis,
  no use of `prop:rcc_total`.
* The global irreducibility of every crossing `D_I` is argued by the bundle
  structure and checked on one representative, not computed for all 1215
  divisors (§7, Tier 3).
