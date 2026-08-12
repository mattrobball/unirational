# STEIN_LERAY — the Stein dichotomy and the Leray package on the 22 live d = 35 cells

**Packet:** `goal_runs_20260812/STEIN_LERAY/` · opened 2026-08-12 (Lane 2).
**Headline: Problem E remains OPEN; this packet excludes no degree.**

Executed against `DATA_SPEC_PIPELINE_FLUSH_20260812.md` Lane 2. Mathematical
authority: `theory/SCHEME_MAP_CONSEQUENCES_20260812.md` §3.4 (J1–J3), combined
with the SEALED `goal_runs_20260812/SMITH_I3` (including its *Director
corrections and adjudication*: at each `C11`-point `χ(fibre) ≡ 4 (mod 11)` with
the five values equal; at each `C5`-point `≡ 0 (mod 5)`; `n_x = 4` and `n_x = 5`
read on the terminus model `Z`).

*(Filename note: main document is `THEOREM.md`; the harness refuses `REPORT.md`.)*

## Exit ledger

```text
STEIN-LERAY-J1-REDERIVED
STEIN-LERAY-MOLIEN-ANCHORS-PASS
STEIN-LERAY-PIN-PROPOSITION
STEIN-LERAY-QUINTIC-EXPLICIT
STEIN-LERAY-LERAY-PACKAGE-STRENGTHENED
STEIN-LERAY-DICHOTOMY-LEDGER-22
STEIN-LERAY-MENUS-JOINT-CHI0
STEIN-LERAY-MENU-CONSTANCY-VERIFIED
STEIN-LERAY-DISC-BRANCH-UNBOUNDED-BY-SEALED-D35
STEIN-LERAY-NO-DEGREE-EXCLUSION
```

Machine markers: `STEIN_LERAY_VERIFY_OK` / `ALLGREEN`
(`python3 verifier.py` — **92 checks, 0 failures, 0 skips**; groups A = 25
(fatal gate), B = 26, C = 41). Exact integer / cyclotomic arithmetic
throughout; python3 standard library only; **no floats anywhere**; no git
operation; nothing outside this packet directory was written.

---

## 0. What is and is not claimed

**Claimed.** (i) A from-scratch in-packet re-derivation of J1's invariant-degree
fact, with all six Molien anchors reproducing (§2 — the lane's fatal gate).
(ii) **Proposition PIN** (new): a `G`-invariant divisor on `X` of degree `k`
contains *all five* `C11`-pinned points unless `11 | k`, and *all four*
`C5`-pinned points unless `5 | k`; so missing every pinned point forces
`55 | k`, hence degree `≥ 55` (§2.3). (iii) The unique degree-5 invariant
divisor is written down explicitly — `det Hess F` — and its incidence with the
pinned points is settled exactly (§2.4). (iv) The Leray package restated with
two additions proved here: the three J3 vanishing statements survive the
presence of `R³q_*O`, and `H⁰(R¹q_*O) = 0` forbids *isolated* points in
`supp R¹q_*O` (§3). (v) The flat-locus constancy of `χ(O_fibre)` (§3.4) and the
`χ_top ↔ χ(O)` bridge with its exact defect (§3.5). (vi) The per-cell dichotomy
ledger over all 22 cells (§5). (vii) The `(h⁰, h¹)` menus per pinned point class
per branch, and the joint constraint `χ₀ ≡ 35 (mod 55)` (§6). (viii) Verified —
not asserted — constancy of every menu input across all `797 547 520`
(cell, menu-entry) pairs (§4).

**Not claimed.** See §8. In particular nothing here cuts any of the 22 live
d = 35 cells and no degree is excluded; both branches of the Stein dichotomy
remain live in every one of the 22 rows.

---

## 1. Setting and conventions

`X = {F = 0} ⊂ P(W) = P⁴` is the Klein cubic threefold,
`F = Σ_{i∈Z/5} x_i² x_{i+1}`, `G = PSL(2,11) ⊂ SL(W)` (`G` is perfect, so it has
no nontrivial characters and the representation lands in `SL`). `Z̃` is a smooth
projective `G`-equivariant model dominating `P(W)`, `dim Z̃ = 4`, and
`q : Z̃ → X` is the resolved landing map: proper, surjective, `G`-equivariant,
with 1-dimensional generic fibre.

**Pinned odd-order points.** `X^{C11}` = 5 points (one `C11` fixed; a single
`G`-orbit of 60 in `X`, since a point stabiliser containing `C11` is `C11`
itself), `X^{C5}` = 4 points (the weight-0 eigenpoint is off `X`). Both facts
re-derived here (§2.4) and re-read from the sealed `RECEIVER_LEDGER_X`
(checks `B1`, `B2`, `B6`).

**Fibre dimension.** Every non-empty fibre of `q` has *every* component of
dimension `≥ dim Z̃ − dim X = 1` (fibre-dimension theorem). There are therefore
no finite fibres; a 1-dimensional fibre is pure of dimension 1. This is used
throughout and is why the "punctual fibre" case never appears in the menus.

---

## 2. J1 re-derived in-packet (the fatal gate) — `scripts/j1_molien.py`

Nothing is imported or copied from the scratch reference
`tmp/scheme_map_20260812/molien_branch.py` (sympy + power-sum recurrences over
`Q(√−11)`). The route here is different and integer-only.

### 2.1 The group and the 5-dimensional character, derived

`PSL(2,11)` is built explicitly as permutations of `P¹(F₁₁)` (12 points);
conjugacy classes, sizes, orders and power maps come out by brute force:
sizes `(1, 55, 110, 132, 132, 110, 60, 60)` of orders `(1, 2, 3, 5, 5, 6, 11, 11)`
(checks `A3`–`A5`).

The `C11` weight datum is **derived, not assumed**: `x_i ↦ ζ¹¹^{b_i} x_i`
preserves `F` iff `2b_i + b_{i+1} ≡ 0`, i.e. `b_i = (−2)^i`, and
`(−2)⁵ ≡ 1 (mod 11)` makes that consistent with `i ∈ Z/5`. So
`b = (1, 9, 4, 3, 5)` — exactly the quadratic residues mod 11 (`A6`). The other
order-11 class carries the non-residues (its square, `2` being a non-residue).

Given that datum, the rest of the eigenvalue data is obtained by exhaustive
search over multisets of roots of unity subject to `det = 1`, exact order,
power-map coherence, and the two orthogonality relations `⟨χ,1⟩ = 0`,
`⟨χ,χ⟩ = 1` computed exactly in `Z[ζ₃₀]`/`Z[ζ₁₁]`. **The completion is unique**
(`A7`), and it reproduces the sealed §3.3 restriction table line for line:

| class | derived eigenvalues | `SCHEME_MAP` §3.3 | check |
|---|---|---|---|
| `C2` | `1,1,1,−1,−1` | `3(+1) ⊕ 2(−1)` | `A8` |
| `C3` | `1, ω, ω, ω², ω²` | `1 ⊕ 2ω ⊕ 2ω²` | `A9` |
| `C5` | all five 5th roots | `1 ⊕ ζ₅ ⊕ … ⊕ ζ₅⁴` | `A10` |
| `C6` | `1, ζ₆, ζ₆², ζ₆⁴, ζ₆⁵` | `1 ⊕ (−ω) ⊕ (−ω²) ⊕ ω ⊕ ω²` | `A11` |
| `C11` | `ζ^r, r ∈ QR` / `r ∈ NQR` | same | `A12` |

### 2.2 Molien, and the anchors

`i_k = dim (Sym^k W*)^G`, `a_k = i_k − i_{k−3} = dim` of the degree-`k`
invariants of `C[X] = C[x]/(F)`, and `M_k = dim (Sym^k W* ⊗ W)^G`, all computed
for `k ≤ 46` by exact convolution in `Z[ζ_{n_c}]` per class, summed in
`Z[ζ₃₃₀]` and reduced modulo `Φ₃₃₀`.

**All six anchors reproduce** (checks `A anchor …`):

| `M₁` | `M₁₁` | `M₁₂` | `M₂₅` | `M₃₄` | `M₃₅` |
|---|---|---|---|---|---|
| **1** | **12** | **16** | **189** | **576** | **637** |

`i_3 = 1` (the invariant cubic is unique — it *is* `F`), and

```
a_1 = a_2 = a_3 = a_4 = 0 ,      a_k ≥ 1 for every 5 ≤ k ≤ 46 .
```

Since `Pic X = Z·H` (Lefschetz) and `G` perfect kills the character ambiguity,
an effective `G`-invariant divisor of degree `k` on `X` is the same thing as a
nonzero element of `(C[X]_k)^G`. **J1's fact is therefore re-derived: the
degrees carrying a `G`-invariant effective divisor on `X` are exactly
`{k ≥ 5}`** (`A14`–`A16`), and the branch bound `deg B ≥ 5` follows. As an
independent cross-check the *ambient* invariant degrees in `[1,40]` come out as
`{3} ∪ [5,40]`, matching the director probe of `EXCLUSION_TRANSPORT` §7 exactly
(`A17`). Two further numbers are used below: `a₅ = 1` (the degree-5 invariant
divisor is **unique**) and `a₁₁ = 2` (`A18`, `A19`).

### 2.3 Proposition PIN (new)

> **Proposition PIN.** Let `D` be a `G`-invariant effective divisor on `X` of
> degree `k`, with equation `f ∈ (C[X]_k)^G`.
> (a) If `11 ∤ k` then `D` contains all five `C11`-fixed points of `X`
> (equivalently the whole 60-point `G`-orbit).
> (b) If `5 ∤ k` then `D` contains all four `C5`-fixed points of `X`.
> (c) Consequently `D` misses every pinned odd-order point only if `55 | k`,
> hence `deg D ≥ 55`.

*Proof.* Let `p = [v]` be a fixed point of a cyclic `C_m ≤ G` (`m ∈ {11,5}`)
acting on the line `Cv` by a character of order `m/gcd`, i.e. `g·v = ζ^a v` with
`a ≢ 0 (mod m)` — for `m = 11` this is `a = b_c ≠ 0` at the coordinate point
`e_c`, for `m = 5` it is the eigenvalue weight `a = j ∈ {1,2,3,4}` of the four
on-`X` eigenpoints (§2.4). For `f` invariant,
`f(v) = f(g^{-1}v) = ζ^{−ak} f(v)`, so `f(v) = 0` unless `m | ak`, i.e. unless
`m | k`. ∎

Machine form: for `k ≤ 59`, the vanishing is forced exactly on the `k` with
`11 ∤ k` resp. `5 ∤ k`, and `55` is the least degree at which no pinned point is
forced onto `D` (`C1`–`C3`).

PIN is the *negative* half of the escape-locus question and it is the half that
matters: one cannot argue that an invariant "bad" divisor (branch divisor,
`h⁰`-jump divisor) generically avoids the pinned points. Unless its degree is
divisible by 11 (resp. 5) it is **forced through them**.

*Honest converse.* PIN gives a necessary condition only. Whether some invariant
of degree `55` actually misses the pinned points is **not settled here** — it
needs explicit `G`-invariants at degree 55, which this packet does not build.
The one degree where the question *is* settled is `k = 5`, next.

### 2.4 The unique invariant quintic, explicitly — `scripts/pinned_points.py`

`a₅ = 1`, so `X` carries exactly one `G`-invariant divisor of degree 5. It is
identified classically: for `F` cubic in five variables, `det Hess F` has degree
5 and transforms by `det(A)²`, hence is `G`-invariant for `G ⊂ SL(W)`; being
nonzero (computed: 11 monomials) and `i₅ = 1`, it *is* the invariant quintic.
It is not divisible by `F` (`i₂ = 0`), so it restricts to a nonzero quintic on
`X`. The computation also confirms, independently of the sealed record, that
the `C5` eigenpoints `[v_j] = [Σ_i ζ₅^{−ij}e_i]` satisfy `F(v_0) = 5 ≠ 0` and
`F(v_j) = 0` for `j = 1,…,4` — the sealed "weight-0 point off `X`, four on
`X`" (`C6`, `B6`).

> **The unique degree-5 invariant divisor `D₅ = {det Hess F = 0} ∩ X` contains
> all five `C11`-pinned points and NO `C5`-pinned point.**

(`C9`, `C10`; the values at the four `C5`-points are nonzero elements of
`Z[ζ₅]`, cross-checked by an independent evaluation of the `5×5` Hessian
determinant directly in `Z[ζ₅]`, `C11`, `C12`.) Both halves are exactly what
PIN allows: `11 ∤ 5` forces the first, `5 | 5` permits the second — and the
second is now known, not merely permitted.

---

## 3. The Leray package, restated and slightly strengthened

Inputs, all `[EXT]` classical and all named: Leray spectral sequence;
`H^i(Z̃,O) = 0` for `i > 0` (`Z̃` smooth projective rational);
`H^i(X,O_X) = 0` for `i > 0` (smooth cubic threefold); Grothendieck vanishing;
the theorem on formal functions; miracle flatness; Zariski's connectedness /
Stein factorisation.

### 3.1 The three J3 statements survive `R³q_*O`

In the connected branch (`q_*O_{Z̃} = O_X`), `E₂^{p,q} = H^p(X, R^q q_*O)`
with `H^p = 0` for `p > 3`. Then:

* `E₂^{0,1} = H⁰(R¹)` has no incoming differential (`E^{−r,r} = 0`) and its only
  outgoing one lands in `H²(X,O_X) = 0`; it survives to `E_∞` inside
  `H¹(Z̃,O) = 0`, so `H⁰(R¹q_*O) = 0`.
* `E₂^{1,1} = H¹(R¹)` likewise has zero source and target and dies in
  `H²(Z̃,O) = 0`, so `H¹(R¹q_*O) = 0`.
* `d₂ : E₂^{0,2} = H⁰(R²) → E₂^{2,1} = H²(R¹)` must be injective (`H²(Z̃,O)=0`)
  and surjective (`E_∞^{2,1} = 0` inside `H³(Z̃,O) = 0`, no other differential
  touching it), so `H⁰(R²q_*O) ≅ H²(R¹q_*O)`.

None of these three arguments uses `R³q_*O = 0`. This matters because a
3-dimensional fibre (a contracted divisor) is not excluded here: **the J3
vanishing package is valid whether or not `q` has 3-dimensional fibres**; only
the `h²`-corollary below is stated on the 2-dimensional case. The
3-dimensional-fibre case is carried as a FLAG (§7.2), never silently dropped.

### 3.2 No punctual `R¹` (new, one line)

> **Lemma NP.** `supp(R¹q_*O)` has no isolated point, and `R¹q_*O` has no
> nonzero subsheaf with 0-dimensional support.

*Proof.* A nonzero coherent sheaf with 0-dimensional support has nonzero global
sections, and sections of a subsheaf inject into `H⁰(R¹q_*O) = 0`. ∎

### 3.3 `h¹` of a 1-dimensional fibre detects the support

> **Lemma FF.** If `dim q^{-1}(x) = 1` and `h¹(O_{q^{-1}(x)}) ≠ 0`, then
> `x ∈ supp R¹q_*O`.

*Proof.* Theorem on formal functions: `(R¹q_*O)^∧_x = lim_n H¹(F_n, O_{F_n})`
over the infinitesimal neighbourhoods. Because `dim F_x = 1`, the obstruction
`H²(F_x, I^n/I^{n+1})` vanishes, so the inverse system is surjective, so the
limit surjects onto `H¹(F_x, O_{F_x})`. ∎

Combined with Lemma NP: an `h¹`-jump at a pinned point forces a
**positive-dimensional `G`-invariant** subvariety of `supp R¹q_*O` through that
point (the support is canonically attached to `q`, hence `G`-invariant), and if
that component is a divisor, Proposition PIN prices it.

### 3.4 Flat-locus constancy of `χ(O_fibre)`

> **Lemma FL.** `U := {x ∈ X : dim q^{-1}(x) = 1}` is open, `q` is flat over
> `U`, and `χ(O_{q^{-1}(x)})` takes one and the same value `χ₀` for every
> `x ∈ U`.

*Proof.* `Z̃` is smooth hence Cohen–Macaulay, `X` is regular, and over `U` the
fibre dimension equals `dim Z̃ − dim X = 1`; miracle flatness gives flatness
there. `χ` of a flat proper family is locally constant, and `U` is a non-empty
open subset of the *irreducible* variety `X`, hence connected. ∎

This is the hinge of §6: the nine pinned points, when they carry 1-dimensional
fibres, all see the **same** `χ₀`, so the mod-11 and mod-5 Smith data are
constraints on one integer.

### 3.5 The bridge: `χ_top` versus `χ(O)`

The Smith datum is a **topological** Euler characteristic; the menu unknowns
`(h⁰, h¹)` are **coherent**. They are not the same invariant, and the packet
does not pretend otherwise. For a fibre `F` of pure dimension 1:

> **Lemma BR.** `χ_top(F) = 2·χ(O_F) + D(F) − 2·χ(N_F)`, where `N_F` is the
> nilradical sheaf and `D(F) := 2δ − Σ_{p}(n_p − 1) ≥ 0` with `δ` the total
> delta invariant of `F_red` and `n_p` the number of branches at `p`.
> `D = 0` iff `F_red` is smooth; `D = #nodes` if `F_red` is nodal.

*Proof.* `χ(O_F) = χ(O_{F_red}) + χ(N_F)`. Normalisation
`0 → O_{F_red} → π_*O_{F̃} → (length δ) → 0` gives
`χ(O_{F_red}) = Σ_i(1−g_i) − δ`, while
`χ_top(F) = χ_top(F_red) = Σ_i(2−2g_i) − Σ_p(n_p−1)`. Eliminate `Σ(1−g_i)`;
`δ_p ≥ n_p − 1` gives `D ≥ 0`. ∎

(Sanity: a double line in `P²` has `χ_top = 2`, `χ(O) = 1`, `D = 0`,
`N ≅ O_{P¹}(−1)` with `χ = 0` — the identity holds. Two lines meeting: `3 = 2 +
1`.)

For a 2-dimensional fibre **no such bridge exists** and the packet says so; the
`dim 2` menu row is parametric by design, not by omission.

---

## 4. Constancy across the immune menus — VERIFIED — `scripts/menus.py`

The Smith inputs are re-derived from the sealed census and receiver data, and
their constancy over the menu is *recomputed*, not quoted.

* **`C11` factor (10 entries).** The four immune `C11` rows have 60 components
  each with 5 for one fixed `C11` (census re-read, `B9`), total `4 × 5 = 20 =
  |Z^{C11}|` (`B7`). The residual `C5 = N_G(C11)/C11` acts on `X^{C11}` as the
  5-cycle `[2,0,3,4,1]` (`B3`), hence transitively, so each row's five points
  map bijectively onto the five receiver points: **one per row per point,
  `n_x = 4` at all five points on every one of the 10 entries** (`C14`). The
  entry labels decide *which* row lands where and never the count. Recomputed
  by-product: the number of defined rows per entry is
  `[0,2,2,2,3,2,3,2,2,2]` — **never 4**, an independent reproduction of
  `STAGE2_ODD_ORDER_PINNING` Thm 2.1 (`C15`).
* **`C5` factor (64 entries).** Ten immune `C5` rows, 132 components each, 2 for
  one fixed `C5` (`B10`), total 20 (`B8`). Each of the 64 `(μ_a, μ_b, μ_0)`
  entries was expanded and its deposit vector over the four receiver points
  computed: `2·#{a-rows at w} + 2·#{b-rows at w} + #{D10 slots at w}` with the
  `D10` rows split over `w` and `−w` (the sealed reflection `w ↦ −w`, `B4`).
  **All 64 give `(5,5,5,5)`** (`C16`); `4 × 5 = 20 = |Z^{C5}|` closes F3 (`C17`).
* **The 22 cells.** Ids and 22 distinct `content_hash@p331` re-read (`B13`,
  `C19`); the σ-band group is shared across the 22 at each prime (sealed
  erratum, `B20`). **No per-cell datum enters any Lane-2 input**: the branches
  and menus below are functions of `X^{C11}, X^{C5}, Z^{C11}, Z^{C5}`, the
  residual permutations and the immune row shapes only. Hence one and the same
  menu object holds for all `22 × 36 252 160 = 797 547 520` (cell, menu-entry)
  pairs (`C13`, `C18`).

---

## 5. The dichotomy ledger (per cell) — `results/dichotomy_ledger.json`

One row per cell, keyed `(cell_id, content_hash@p331)`; all 22 rows are
identical, which is a *result* of §4, recorded per cell rather than abbreviated.

### 5.1 Branch CONNECTED (`q_*O_{Z̃} = O_X`, Stein degree `s = 1`)

* All fibres are connected (Zariski/Stein) — J2.
* J3 holds in the strengthened form of §3.1.
* **Corollary at the pinned points.** If `dim supp R¹q_*O ≤ 1` then
  `H²(R¹) = 0` (Grothendieck) and therefore `H⁰(R²q_*O) = 0`: `R²q_*O` has no
  punctual part, so a pinned point — which by the sealed incidence lies on no
  line and on no `E^X_σ` (`B24`), hence is isolated in the 2-dimensional-fibre
  locus — carries **`h²(O_fibre) = 0`**. Contracted surface packets with
  `h²(O) ≠ 0` over pinned points are excluded, and over a swept `L^X_σ` the
  `R²`-sheaf restricts with `h⁰ = h¹ = 0`.
* **Escape locus, with PIN.** The hypothesis can fail only through a divisorial
  component of `supp R¹q_*O` — the `h⁰`-jump divisor `D_J`, `G`-invariant, so of
  degree `≥ 5` (J1). Two things are new here. First, by Lemma NP the *punctual*
  escape is impossible: `supp R¹q_*O` has no isolated points, so an `h¹`-jump at
  a pinned point drags a positive-dimensional invariant subvariety through it.
  Second, by Proposition PIN the divisorial escape **cannot be dodged by general
  position**: unless `11 | deg D_J` the divisor `D_J` passes through *all five*
  `C11`-pinned points, and unless `5 | deg D_J` through *all four* `C5`-pinned
  points. At the cheapest degree, `deg D_J = 5`, the divisor is forced to be
  `D₅ = {det Hess F = 0} ∩ X` and then it contains every `C11`-pinned point and
  no `C5`-pinned point (§2.4).

### 5.2 Branch DISCONNECTED (`s ≥ 2`)

* Cost, from J1: a finite `G`-equivariant `ν : Y → X` of degree `s ≥ 2`, `Y`
  normal, branched along a `G`-invariant divisor `B` with `deg B ≥ 5`
  (re-derived §2.2).
* **PIN sharpening (new).** `B` misses every pinned odd-order point only if
  `55 | deg B`, i.e. `deg B ≥ 55`. At `deg B = 5` the branch divisor is
  *uniquely determined*: `B = D₅ = {det Hess F = 0} ∩ X`, which contains all
  five `C11`-pinned points and no `C5`-pinned point — so `ν` is ramified over
  every `C11`-pinned point and étale over every `C5`-pinned point in that case.
* **How much of J3 survives.** `ν` finite ⟹ `R^q q_*O = ν_*R^q q̃_*O` for
  `q ≥ 1` and `H^p(X, ν_*·) = H^p(Y, ·)`. So the *whole* argument of §3.1 runs
  verbatim with `X` replaced by `Y` **iff `H^i(Y,O_Y) = 0` for `i > 0`** — e.g.
  if `Y` has rational singularities (a resolution of `Y` is a smooth unirational
  threefold, where those groups vanish). This is a genuine extra hypothesis and
  is carried as such, not assumed.
* **Fibre bookkeeping.** `q^{-1}(x) = ⊔_{y ∈ ν^{-1}(x)} q̃^{-1}(y)` with each
  `q̃`-fibre connected, so the number of connected components of `q^{-1}(x)`
  equals `#ν^{-1}(x) ≤ s`, and `h⁰(O_{q^{-1}(x)}) ≥ #ν^{-1}(x)`.

### 5.3 What the sealed d = 35 data bounds — honest report: **nothing**

Searched first-hand and by an independent sweep of the record:

| item | status in the sealed record |
|---|---|
| connectedness of the generic fibre / Stein degree `s` | **not pinned anywhere.** `theory/GLOBAL_LOCALIZATION_LEDGER_20260812.md` §8 Flag 1 explicitly instructs that the Stein degree be *carried as a menu variable*; `L12_REFEREE` confirms that reading. `theory/MORPHISM_LEDGER_20260812.md` row L13 is **UNSPENT** |
| `deg B` | the only pinned bound is `deg B ≥ 5`, and it is a degree-independent fact about `X`'s invariant ring — re-derived here and sharpened by PIN |
| fibre genus / `p_a` / component count at d = 35 | **not pinned.** `CONSTRAINT_ADDITIONS` C1 is a genus *identity* package (`2g−2 = 65ν + Σ(a_E−2m_E)e_E`) in unpinned `a_E, m_E, e_E, ν` — as `SMITH_I3` §7.3 states in terms (`B26`) |
| degree of the fibre curve / `(q*H_X)³` | **not pinned.** `SCHEME_MAP` E1 is an identity in the same unpinned Rees data, marked machine-UNSPENT |
| `GENERIC_FIBER_STEIN_MORI` (2026-08-08) | a *conditional* Mori lemma forcing `δ = 1` under terminal / Q-factorial / Fano / `ρ(Y)^G = 1`, with its own banner `FULL-G-STEIN-MORI-HYPOTHESES-NOT-FORCED`; it predates the d = 35 census and is not tied to it |
| `SMITH_I3` | F2/F3 are connectedness-free by construction and the packet says so (`B25`): they bound neither branch |

**Verdict: parametric honesty.** No sealed d = 35 datum bounds or contradicts
the disconnected branch. The one new coupling produced here is §6.4's
`χ₀ ≥ 35 ⟹ s ≥ 35`, which is derived in this packet, not read from the record.

---

## 6. The `(h⁰, h¹)` menus at the pinned points — `results/menus.json`

Unknowns: `h^i = h^i(O_{F_x})` for the scheme fibre `F_x = q^{-1}(x)`;
`h⁰ ≥ 1` always. Inputs: `[Smith]` `χ_top(F_x) ≡ n_x (mod p)` with
`(p, n_x) = (11, 4)` at the five `C11`-points (the five `χ_top` moreover
*equal*) and `(5, 5)` at the four `C5`-points, both read on the terminus `Z`;
`[J3]` §5.1; `[BR]` the bridge; `[FL]` the flat-locus constant.

### 6.1 One-dimensional fibres — the exact rows

`dim F_x = 1 ⟹ h² = h³ = 0 ⟹ χ(O_{F_x}) = h⁰ − h¹ = χ₀` (Lemma FL).

| row | hypothesis | menu |
|---|---|---|
| **smooth** | `F_x` smooth (`D = 0`, `N = 0`), connected branch ⟹ irreducible | `h⁰ = 1`, `h¹ = g` with `2−2g ≡ n_x (mod p)`: at `C11` `g ≡ 10 (mod 11)`, at `C5` `g ≡ 1 (mod 5)` |
| **smooth, RH-sharpened** | same, plus `n_x` used as an exact fixed-point count | `g = 11a + 10 ≥ 10` at a `C11`-point; `g = 5b + 6 ≥ 6` at a `C5`-point |
| **reduced nodal** | `F_x` reduced with `δ` nodes | `h⁰ = 1`, `h¹ ≡ (2 + δ − n_x)·2^{-1} (mod p)` |
| **general** | none beyond `dim 1` | `2χ₀ + D − 2χ(N) ≡ n_x (mod p)`, `D ≥ 0` |

The RH-sharpened row is an independent confirmation of the Smith input, not an
extra assumption: for a smooth connected `F` with `C_p` acting with exactly
`n_x` fixed points and quotient genus `a`, Riemann–Hurwitz gives
`2g − 2 = p(2a − 2) + n_x(p − 1)`, whose `χ_top = 2 − 2g` automatically
satisfies the Smith congruence (`C23`, `C24`) — and it removes the spurious
small solutions the congruence alone would allow (e.g. `g = 1` at a `C5`-point).

**Hurwitz existence rule, used and stated.** A faithful `C_p` action on a smooth
projective curve can never have exactly **one** fixed point: the local rotation
numbers satisfy `Σ a_i ≡ 0 (mod p)` because `π₁` of the punctured quotient kills
the product of commutators. This prunes the disconnected menus below (`C20`).

### 6.2 Two- and three-dimensional fibres

`dim F_x = 2`: `q` is not flat at `x`, so `χ₀` does not bind; `h⁰ ≥ 1` and
`h² = 0` under the two named conditions of §5.1; `h¹` is free — **no bridge
exists for a surface and none is invented** (`C35`). `dim F_x = 3`: FLAGGED
(§7.2), `R³q_*O` enters and the `h²` corollary is not the one proved (`C36`).

### 6.3 Disconnected branch — the finite splits

Components of `F_x` correspond to the points of `ν^{-1}(x)`; `C_p` permutes them
in orbits of size 1 or `p`; the `n_x` fixed points sit on the stable components;
`h⁰ = #components`, `h¹ = Σ genera` for a disjoint union of smooth curves. With
the Hurwitz rule (no part equal to 1) the fixed-point splits are **finite and
short**:

| point class | splits | component genera | cheapest disconnected `(h⁰, h¹)` |
|---|---|---|---|
| `C11` (`n_x = 4`) | `[2,2]`, `[4]` | `r=2: g = 11a`; `r=4: g = 11a + 10`; `r=0` (free): `g = 11(a−1)+1 ≥ 1` | `(2, 0)` — two `P¹`s each meeting `Z̃^{C11}` twice |
| `C5` (`n_x = 5`) | `[2,3]`, `[5]` | `r=2: g = 5a`; `r=3: g = 5a+2`; `r=5: g = 5a+6`; `r=0`: `g = 5(a−1)+1 ≥ 1` | `(2, 2)` |

plus optionally extra stable components with no fixed point (genus `≥ 1` each)
and free `C_p`-orbits of `p` components (adding `(p, p·g')`). Every enumerated
type satisfies the Smith congruence identically (`C27`–`C29`).

### 6.4 The joint menu — the one place with real bite

If all nine pinned points carry 1-dimensional fibres, Lemma FL makes `χ₀` a
single integer, and the two Smith congruences combine. With smooth fibres
(`D = 0`, `N = 0`) the bridge is `χ_top = 2χ₀` and

```
      2χ₀ ≡ 4 (mod 11)   and   2χ₀ ≡ 0 (mod 5)    ⟹    χ₀ ≡ 35 (mod 55).
```

Because `h⁰ = χ₀ + h¹` and `h¹ ≥ 0`, this is a dichotomy (`C30`–`C33`):

* **A. `χ₀ ≤ −20`** — then at *every* pinned point `h¹ = h⁰ − χ₀ ≥ h⁰ + 20`. In
  the connected branch `h⁰ = 1`, so **`h¹ ≡ 21 (mod 55)`, i.e.
  `h¹ ∈ {21, 76, 131, …}` and the fibre genus over every pinned point is at
  least 21.** Cross-check: `g = 11a + 10` and `g = 5b + 6` have smallest common
  solution `g = 21` (`C32`).
* **B. `χ₀ ≥ 35`** — then `h⁰ ≥ 35`, and `h⁰ = #ν^{-1}(x) ≤ s`, so **the Stein
  degree satisfies `s ≥ 35`.** This is impossible in the connected branch
  (`h⁰ = 1`), so branch B is a *disconnected-only* option and an expensive one.

With defects the same computation reads
`2χ₀ + D_x − 2χ(N_x) ≡ 4 (mod 11)` at the five `C11`-points and `≡ 0 (mod 5)` at
the four `C5`-points; and since the five `C11` values of `χ_top` are *equal*
(sealed), `D_x − 2χ(N_x)` is one and the same integer at all five.

**Model caveat, carried.** `n_x = 4` and `n_x = 5` are read on the terminus `Z`
(sealed director correction). On a further equivariant model `n_x = 4 + Δ/5`
with `Δ ≥ 0`; the *equality of the five* survives every refinement, the common
residue moves, and every menu above then re-runs with `n_x` in place of 4 and 5.
Nothing in §6 is claimed model-independently.

---

## 7. Flags

### 7.1 Topological versus coherent Euler characteristic — the load-bearing gap

`DATA_SPEC` Lane 2 writes "`χ = h⁰ − h¹`" as if the Smith value were the
coherent Euler characteristic. It is not: Smith theory
(`χ_c(Y) ≡ χ_c(Y^g) mod p`) is topological, while `(h⁰, h¹)` are coherent.
This packet does **not** silently identify them. It derives Lemma BR
(`χ_top = 2χ(O) + D − 2χ(N)` on 1-dimensional fibres, with `D ≥ 0` and `D = 0`
iff `F_red` is smooth) and reports every menu with the defect visible. All the
sharp numbers of §6 (`g ≥ 10`, `g ≥ 6`, `χ₀ ≡ 35 mod 55`, `h¹ ≥ 21`,
`s ≥ 35`) are stated **in the zero-defect (smooth-fibre) row** and are false as
stated without it. The director should adjudicate the spec wording; nothing
here is stopped by it, since both the defect-free and the parametric forms are
delivered.

### 7.2 Named remainders (blockers, not failures)

* **3-dimensional fibres are not excluded.** A contracted divisor over a pinned
  point would introduce `R³q_*O`. The three J3 vanishings survive (§3.1) but the
  `h²`-corollary is stated only for `dim ≤ 2`. Nothing in the record excludes a
  3-dimensional fibre; the row is FLAGGED, not closed.
* **PIN's converse is open.** `55 | k` is necessary to miss every pinned point;
  sufficiency at `k = 55` needs explicit degree-55 `G`-invariants, not built
  here. Settled only at `k = 5` (§2.4). At `k = 11`, `a₁₁ = 2`, so a pencil of
  invariant divisors exists and the evaluation at a `C11`-point is one linear
  condition on it — whether that condition is nonzero is **not decided here**.
* **The disconnected branch's Leray transfer needs `H^i(Y,O_Y) = 0`.** Stated as
  a hypothesis (§5.2), not assumed. Without it only J1/J2 apply on that branch.
* **Cohomology and base change is not available.** `q` is not flat in general;
  §3.3 uses the theorem on formal functions instead, which is why Lemma FF is
  restricted to 1-dimensional fibres.
* **`χ₀` is a single unknown but is not determined.** The joint constraint fixes
  it mod 55 only.

### 7.3 Spec ↔ record notes

The Lane-2 spec quotes the anchor list as "`M₁₁ = 12, M₂₅ = 189, M₃₄ = 576`"
with a struck-out `M₁`; all six sealed anchors (`M₁, M₁₁, M₁₂, M₂₅, M₃₄, M₃₅`)
were reproduced, and the derived Molien table also matches the independent
director probe `E ∩ [1,40] = {3} ∪ [5,40]`. The `SMITH_I3` errata (one shared
σ-band group per prime; `content_hash`/`sealed_hash`, no `sol_hash`) were
re-checked and are respected here (`B20`).

### 7.4 Zero / all-dead audit

Nothing in this packet returns a zero or an all-dead outcome (`C37`): all 22
cells stay live, both Stein branches stay live in every row, `n_x = 4` and
`n_x = 5` are positive, every menu is non-empty, and every invariant-degree
statement is a *positive* existence from degree 5 up. The check is wired into
the verifier so a future replay cannot silently produce one.

---

## 8. Not claimed

* **No headline.** Problem E remains **OPEN**. This packet **excludes no
  degree** and cuts **none** of the 22 live d = 35 cells.
* No claim that the fibres of `q` are connected, or disconnected. Both branches
  are carried in all 22 ledger rows.
* No claim that a `G`-invariant divisor of degree 55 missing every pinned point
  exists (only that `55 | deg` is necessary for one).
* No claim about `h¹` or `h²` at a pinned point carrying a 2- or 3-dimensional
  fibre beyond `h² = 0` under the two named conditions.
* The sharp menu numbers (`g ≥ 10`, `g ≥ 6`, `χ₀ ≡ 35 mod 55`, `h¹ ≥ 21`,
  `s ≥ 35`) hold in the smooth-fibre row of the bridge and are **not** claimed
  for singular or non-reduced fibres, where the defect terms are carried.
* No claim that these menus are non-empty *for a realisation* — no realisation
  is exhibited or excluded. They are necessary conditions.
* No correction to any sealed number; no `F_odd` or `G` recount; no
  transport-pairing claim; no re-derivation of the d = 35 census.
* No git operation was performed and nothing outside this packet directory was
  written.

---

## 9. Verification

```sh
python3 scripts/j1_molien.py       # the fatal gate: group, character, Molien, anchors
python3 scripts/pinned_points.py   # Proposition PIN and the explicit quintic
python3 scripts/menus.py           # constancy, the menus, the per-cell ledger
python3 verifier.py                # 92 checks -> results/verifier_output.json
```

| group | n | covers |
|---|---:|---|
| **A** (gate) | 25 | the group data, the derived C11 weight datum, uniqueness of the character completion, its agreement with the sealed §3.3 restriction table, all six Molien anchors, `i₃ = 1`, the `a_k` profile, J1's statement, the `EXCLUSION_TRANSPORT` probe, `a₅ = 1`, `a₁₁ = 2`. If any A check fails the verifier refuses to run B and C |
| **B** | 26 | every sealed constant consumed, re-read at source: receiver point counts and residual permutations, the Klein normal form and the `C5` standard model, the census `Z^{C11} = Z^{C5} = 20` and the immune row shapes, `F_odd` and its factorisation, the 22 ids/hashes and the pair count, the sealed Smith values and their menu-uniformity, the director's "read on `Z`" correction, the shared σ-band group keys, and the verbatim J1/J3/escape-caveat/incidence statements of the authority |
| **C** | 41 | Proposition PIN over `k ≤ 59`, the quintic (invariance, `C11`-vanishing, `C5`-non-vanishing, plus an independent `Z[ζ₅]` determinant evaluation), the recomputed menu constancy (10 `C11` entries, all 64 `C5` entries, F3 closure, cell-independence, the 22 ids), the Riemann–Hurwitz layer including the `r ≠ 1` rule, the finite splits, the joint `χ₀ ≡ 35 (mod 55)` dichotomy and both of its consequences, the `h²`/`h³` rows, the FLAGGED `dim 3` case, the 22-row ledger, and the zero/all-dead audit |

Artifacts: `results/j1_molien.json`, `results/pinned_points.json`,
`results/menus.json`, `results/dichotomy_ledger.json`,
`results/verifier_output.json`, `results/verifier_stdout.txt`.

## 10. Dependencies consumed as sealed

`DATA_SPEC_PIPELINE_FLUSH_20260812.md` (Lane 2);
`theory/SCHEME_MAP_CONSEQUENCES_20260812.md` (§3.3 restriction table, §3.4
J1–J3, E1, §4, §7); `goal_runs_20260812/SMITH_I3` (THEOREM.md incl. the director
corrections, `results/f2f3_congruences.json`);
`goal_runs_20260810/RECEIVER_LEDGER_X` (`results/ledger_exact.json`);
`goal_runs_20260810/TERMINUS_STRATA_PW` (`results/t2_strata.txt` census);
`goal_runs_20260811/GLOBAL_COHERENCE` (`results/vectors_d35.json`);
`theory/GLOBAL_LOCALIZATION_LEDGER_20260812.md` §8 Flag 1;
`theory/MORPHISM_LEDGER_20260812.md` (L13);
`theory/CONSTRAINT_ADDITIONS_20260811.md` (C1);
`theory/EXCLUSION_TRANSPORT_20260811.md` §7 (the invariant-degree probe);
`goal_runs_20260812/L12_REFEREE`; `goal_runs_20260808/GENERIC_FIBER_STEIN_MORI`
(read for §5.3 only, and reported as not d = 35-tied);
`goal_runs_20260811/ODDZERO_AUDIT/REGISTRATION_SNIPPET.md` (registration format).

External-classical imports, marked at point of use: **Leray** spectral sequence,
**Grothendieck** vanishing, **theorem on formal functions**, **miracle
flatness**, **Zariski connectedness / Stein factorisation**, **Zariski–Nagata**
purity and **Lefschetz** (via J1 in the authority), **Riemann–Hurwitz** with the
cyclic-cover existence rule, **Smith** theory (via the sealed SMITH_I3), and the
classical fact that `det Hess` of a cubic form transforms by `det(A)²`. No
unverified external mathematics enters any `[T1]`/`[T2]` claim.

## Director adjudication (2026-08-12, appended at sealing)

Referee: `REFEREE_REPORT.md` — all six targets CONFIRMED (its 82 checks
pass; the packet verifier replays 92/92 byte-identical for referee and
director). The three non-blocking corrections are ADOPTED:

1. **Window-free form of J1 (substantive):** since `a_k ≥ 1` for
   `k = 5..9` and the invariant coordinate ring of `X` is a domain,
   multiplicativity closes the semigroup: `a_k ≥ 1 for ALL k ≥ 5`, so
   "invariant divisor degrees on X are exactly {k ≥ 5}" holds with no
   window cap — the degree-≥5 branch-divisor cost of the dichotomy is
   unconditional in `k`.
2. The verifier's C14 constancy check rests on the (referee-verified)
   transitivity ingredients rather than a direct menus.py replay — to be
   recomputed at next packet touch; recorded, not blocking.
3. The garbled "order m/gcd" phrase in the PIN proof reads as the
   referee's report specifies; the argument is unaffected.

Sealed content stands as delivered, scope as stated at every occurrence
(terminus model, nine pinned points one-dimensional, smooth-fiber row
labeled; map level, d = 35 class, cell-uniform): **the χ₀ ≡ 35 (mod 55)
dichotomy — fibers with χ₀ ≤ −20 (connected: genus ≥ 21) or Stein degree
≥ 35 — plus Proposition PIN with the explicit Hessian quintic D₅.**
