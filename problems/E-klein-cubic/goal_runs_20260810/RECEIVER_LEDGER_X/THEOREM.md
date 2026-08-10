# RECEIVER_LEDGER_X — the target-side fixed-locus ledger of the Klein cubic

**Primary exit: `RECEIVER-LEDGER-X-PASS`.**
**Problem E headline: OPEN.** Nothing here changes it.

Machine markers: `PRODUCE_LEDGER_OK` (55 checks), `RECEIVER_LEDGER_X_VERIFY_OK` +
`ALLGREEN` (101 checks), `LEDGER_IDEALS_M2_OK` (32 row checks over two primes).

---

## 0. What this packet is

One table row for **every** conjugacy class of subgroups `H ≤ G = PSL(2,11)`,
describing `X^H` completely, where

```
W = the 5-dimensional Klein representation of G over Q(zeta_11),
X = { F = 0 } subset P(W) = P^4,      F = sum_{i in Z/5} x_i^2 x_{i+1},
G = Aut(X) = PSL(2,11),  |G| = 660.
```

This is the **receiver** half of the equivariant fixed-locus program: FIX-A2
sealed the **source** side `P(W)^H` for all 16 classes, FIX-A0/A1 sealed the
`C2` and `V4` rows on `X`. This packet closes the remaining rows (`C3`, `C6`,
both `S3` classes, `C11`, and the empty deep rows), replays every sealed row by
two independent methods, and states the consequence that the obstruction
machine consumes.

### Theorem boundary

**Proved here.** For each of the 16 classes: `H`, `|H|`, `#conjugates`,
`C_G(H)`, `N_G(H)`; the complete component list of `X^H` with dimension, degree,
genus and reducedness; the residual `N_G(H)/H` action on those components; the
fixed-locus containment poset at component level; and the two obstruction
hypotheses per row. New exact results: `X^{C3}` (six reduced points, the
isolated `C3`-fixed point of `P^4` is **off** `X`), `X^{C6}` (two points, both on
the involution minus-line), `X^{S3} = ∅` for **both** classes, `X^{C11}` (five
points, a single `F55`-orbit). Corollary C3 below.

**Not proved here.** Anything about existence of equivariant maps into `X`;
normal jets; essential dimension; the Problem-E headline. No claim about `X`
beyond its `G`-fixed-point geometry.

---

## 1. Model, method, field

Representation: the exact `S`, `T` generators of
`certificates/exact_weil_check.py` over `Q(zeta_11)`; `T` diagonal with the five
quadratic-residue characters, `S` the Weil involution built from the Gauss sum
`g` with `g^2 = -11`. `F` is checked invariant under both generators
symbolically, and the Cayley closure gives 660 distinct matrices (element-order
profile `1,55,110,264,110,120` for orders `1,2,3,5,6,11`).

Working field for the eigen-analysis:
`K = Q(zeta_165) = Q(zeta_3) ⊗ Q(zeta_5) ⊗ Q(zeta_11)`, degree 80, exact
rational arithmetic (a tensor basis with per-prime cyclotomic reduction, and
inversion by successive norms down to `Q(zeta_11)`). Every eigenvalue of every
element of `G` (orders `1,2,3,5,6,11`) and every value of every linear character
of every subgroup lies in `K`.

**The one rule used for every row.** A point `[v]` is `H`-fixed iff `K·v` is an
`H`-stable line, i.e. iff `v` lies in a *character* eigenspace. Hence

```
P(W)^H  =  ⨆_chi  P(W_chi),     W_chi = { v : h.v = chi(h) v  for all h in H },
```

the union over the one-dimensional characters `chi` of `H` with `W_chi ≠ 0`, and

```
X^H  =  X ∩ P(W)^H  =  ⨆_chi  { F|_{W_chi} = 0 } .
```

`dim W_chi = 1` is one exact evaluation of `F`; `dim W_chi = 2` a binary cubic
(all four coefficients zero ⟺ the line lies in `X`; otherwise discriminant ≠ 0 ⟺
three distinct points); `dim W_chi = 3` a ternary cubic; `dim W_chi = 5` is `X`
itself.

---

## 2. The ledger

`W(H) := N_G(H)/H` is the residual group. "RCC" means *rationally chain
connected*. **Obstruction-readiness** is the pair of hypotheses

* **(a)** `X^H` contains **no** `N_G(H)`-stable positive-dimensional RCC
  subvariety;
* **(b)** `X^{N_G(H)} = ∅`.

`(a) ∧ (b)` is what the base-locus argument of §5 needs.

| # | `H` | `\|H\|` | #conj | `C_G(H)` | `N_G(H)` | `X^H` as a variety | residual `W(H)` action | rational comps? | (a) | (b) | provenance |
|---|-----|------:|------:|----------|----------|--------------------|------------------------|-----------------|:---:|:---:|------------|
| 0 | `1` | 1 | 1 | `G` | `G` | **`X`** itself: smooth cubic threefold, `dim 3`, `deg 3` | `G` acts faithfully | `X` is unirational, **not** rational (Clemens–Griffiths) | ✗ **fails** — `X` is RCC and `G`-stable | ✓ | classical + replayed |
| 1 | `C2` | 2 | 55 | `D12` | `D12` | **`E_sigma ⊔ L_sigma`** (disjoint): `E_sigma = X ∩ P(W^+)` a smooth plane cubic, `deg 3`, genus 1, `j = 8192/11`, no CM; `L_sigma = P(W^-) ≅ P^1`, `deg 1`, genus 0, `L_sigma ⊂ X` | `S3 = D12/C2` preserves each; on `W^-` the standard 2-dim irrep (`2,0,-1`), on `W^+` `triv ⊕ std` (`3,1,0`) | `L_sigma` rational; `E_sigma` not | ✗ **fails** — `L_sigma ≅ P^1` is `N`-stable and rational | ✓ | FIX-A0 `FIX-A0-ARRANGEMENT-PASS`, replayed |
| 2 | `C3` | 3 | 55 | `C6` | `D12` | **6 reduced points.** `P(W)^{C3} = pt ⊔ P^1 ⊔ P^1`; the isolated point is the `D12`-point and is **off `X`**; each eigenline meets `X` in 3 distinct points = 1 `C6`-point (on `X`) + 2 points with exact stabiliser `C3` | `V4 = D12/C3`; two orbits, sizes **2** (the `C6`-points) and **4** (the exact-`C3` points) | 0-dimensional | ✓ holds | ✓ (`X^{D12} = ∅`) | **NEW** |
| 3 | `V4` | 4 | 55 | `V4` | `A4` | **6 reduced points**: 3 type-I vertices `[chi_i]` + 3 type-II points `X ∩ ℓ_V` (`ℓ_V = P(W^{V4})` is **not** in `X`, `disc ≠ 0`) | `C3 = A4/V4`; **two free 3-orbits** | 0-dimensional | ✓ holds | ✓ (`X^{A4} = ∅`) | FIX-A1 `FIX-A1-V4-REPAIR-PASS`, replayed |
| 4 | `C5` | 5 | 66 | `C5` | `D10` | **4 points**: `v(w) = (1,w,w^2,w^3,w^4)` for the four primitive 5th roots `w`; the fifth eigenpoint `[1:1:1:1:1]` has `F = 5 ≠ 0` | `C2 = D10/C5` acts **freely**: two 2-orbits (`w ↔ w^{-1}`) | 0-dimensional | ✓ holds | ✓ (`X^{D10} = ∅`) | sealed (STRATA_EXACT), replayed |
| 5 | `S3` (a) | 6 | 55 | `C2` | `D12` | **∅** — `P(W)^{S3}` is the single `D12`-point, which is off `X` | — | — | ✓ holds (empty) | ✓ | **NEW** |
| 6 | `S3` (b) | 6 | 55 | `C2` | `D12` | **∅** — same reason | — | — | ✓ holds (empty) | ✓ | **NEW** |
| 7 | `C6` | 6 | 55 | `C6` | `D12` | **2 points**, both on the minus-line `L_t` of the involution `t = g^3`; they are exactly the two of the five `C6`-eigenpoints with `t`-eigenvalue `-1` | `C2 = D12/C6` swaps them: one 2-orbit | 0-dimensional | ✓ holds | ✓ (`X^{D12} = ∅`) | **NEW** |
| 8 | `D10` | 10 | 66 | `1` | `D10` | **∅** — the unique fixed point of `P^4` is the `C5`-invariant point, `F = 5` | — | — | ✓ holds (empty) | ✓ | sealed, replayed |
| 9 | `C11` | 11 | 12 | `C11` | `C11:C5` | **5 points** — the five `T`-eigenpoints (the coordinate points), **all on `X`** | `C5 = F55/C11` permutes them in a **single 5-cycle** | 0-dimensional | ✓ holds | ✓ (`X^{F55} = ∅`) | **NEW** (count + action) |
| 10 | `A4` | 12 | 55 | `1` | `A4` | **∅** — the two `A4`-character points lie on `ℓ_V` and are both off `X` | — | — | ✓ holds (empty) | ✓ | FIX-A1 `A1-C4'`, replayed |
| 11 | `D12` | 12 | 55 | `C2` | `D12` | **∅** — the unique `D12`-point is off `X` | — | — | ✓ holds (empty) | ✓ | sealed (CHECKS.md), replayed |
| 12 | `C11:C5` | 55 | 12 | `1` | `C11:C5` | **∅** — `W\|_{F55}` is irreducible, so already `P(W)^{F55} = ∅` | — | — | ✓ holds (empty) | ✓ | FIX-A2, replayed |
| 13 | `A5` (a) | 60 | 11 | `1` | `A5` | **∅** — `W\|_{A5}` irreducible; also `X^{A5} ⊆ X^{A4} = ∅` | — | — | ✓ holds (empty) | ✓ | FIX-A2 + FIX-A1 |
| 14 | `A5` (b) | 60 | 11 | `1` | `A5` | **∅** — same | — | — | ✓ holds (empty) | ✓ | FIX-A2 + FIX-A1 |
| 15 | `PSL(2,11)` | 660 | 1 | `1` | `G` | **∅** — `W` irreducible | — | — | ✓ holds (empty) | ✓ | classical |

Column **(a)** is the hypothesis "`X^H` contains no `N_G(H)`-stable
positive-dimensional RCC subvariety"; column **(b)** is "`X^{N_G(H)} = ∅`".
`✓` means the hypothesis holds.

Class sizes `1,55,55,55,66,55,55,55,66,12,55,55,12,11,11,1` sum to the 620
subgroups of `G`; the 16 classes and all normalisers were re-enumerated from the
660-element group (one-generator-at-a-time closure modulo conjugacy) and agree
exactly with FIX-A2's sealed layer.

### Point counts, globally

| `G`-orbit of points of `X` | stabiliser | size | check |
|---|---|---:|---|
| type-I `V4` vertices | `V4` | 165 | `55 × 3` |
| type-II points `X ∩ ℓ_V` | `V4` | 165 | `55 × 3` |
| `C6`-points on `X` | `C6` | 110 | `55 × 2` |
| exact-`C3` points | `C3` | 220 | `110 eigenlines × 2` |
| `C5`-points, two orbits | `C5` | 132 + 132 | `66 × 4` |
| `C11`-points | `C11` | 60 | `12 × 5` |

`X^{C3}` has `55 × 6 = 330` incidences, split `110 + 220`; `X^{V4}` has
`55 × 6 = 330 = 165 + 165`. All consistent with `STRATA_EXACT.md §3`.

---

## 3. The new rows in detail

### 3.1 `X^{C3}` — the decisive row

`W|_{C3} = triv ⊕ 2·omega ⊕ 2·omega^2`, so
`P(W)^{C3} = {pt} ⊔ P^1_omega ⊔ P^1_{omega^2}`.

1. **The isolated point is the `D12`-point and it is off `X`.** Its full
   projective stabiliser is computed to be `D12` (order 12) — this is forced:
   `N_G(C3) = D12` preserves the 1-dimensional `W^{C3}`, and `D12` is maximal in
   `G` while `W` is irreducible. Exact evaluation gives
   `F(v) = -(5 + 12 z + 15 z^2 + 12 z^3 + 5 z^4 + 0 + 7 z^6 + 18 z^7 + 18 z^8 + 7 z^9) ≠ 0`
   in `Q(zeta_11)` (the normalisation of `v` is the kernel normalisation; only
   non-vanishing is meaningful). Non-vanishing is confirmed independently mod
   331 and mod 661 — and a single non-vanishing modulo a prime is already a
   characteristic-zero proof.
2. **Neither eigenline lies in `X`** and each meets `X` in **three distinct**
   points (binary-cubic discriminant ≠ 0, exactly in `K`).
3. **Which three.** The centraliser `C_G(C3) = C6 = ⟨g⟩` preserves each
   eigenline and splits it into two `C6`-eigenpoints. Writing `t = g^3`, the
   `C6`-eigenpoint with `t`-eigenvalue `-1` lies on the minus-line `L_t ⊂ X`,
   hence **on `X`**; the one with `t`-eigenvalue `+1` lies in the plus-plane and
   is **off `X`**. So `X ∩ eigenline = {one C6-point} ⊔ {two points}`, and the
   two remaining points are not `t`-fixed, hence swapped by `t`; their exact
   stabiliser is therefore `C3`, giving a single `G`-orbit of
   `110 × 2 = 220` points (matching the sealed `orbit_hilbert_check.py` result
   "primitive C3 eigenpoint is simple and has projective orbit 220").
4. **Residual action.** Every element of `N_G(C3) = D12` outside `C_G(C3) = C6`
   inverts `C3` and therefore **swaps the two eigenlines** (verified for all six
   such elements). Hence `W(C3) = D12/C3 ≅ V4` acts on the six points with
   orbits of size **2** (the two `C6`-points) and **4** (the four exact-`C3`
   points). **No `D12`-fixed point among them** — and indeed `X^{D12} = ∅`.

Arithmetic remark (new): the two exact-`C3` points on one eigenline are *not*
individually rational over the field of definition of the line. Mod 331 all three
points of `X ∩ eigenline` are `F_p`-rational; mod 661 only the `C6`-point is, the
other two forming a conjugate quadratic pair. (Compare FIX-A1 item 9, where the
type-II points are invisible at 23, 67, 89, 331, 353 — reproduced here: 0
`F_p`-rational type-II points at both 331 and 661, 3 geometric.)

### 3.2 `X^{C6}`

`W|_{C6} = chi^0 ⊕ chi^1 ⊕ chi^2 ⊕ chi^4 ⊕ chi^5` (`chi^3` absent), so
`P(W)^{C6}` is 5 points: `chi^0` is the `D12`-point (off `X`), and the four
others have exact stabiliser `C6`. Their `t = g^3` eigenvalues are `(-1)^k`;
**exactly the two with `k` odd lie on `X`**, and those are the two points of
`L_t` fixed by `g`. So

```
X^{C6} = X^{C2} ∩ X^{C3}  =  2 points on the minus-line L_t,
```

a single free 2-orbit for the residual `C2 = D12/C6`. (The identity
`X^{C6} = X^{⟨t⟩} ∩ X^{⟨g^2⟩}` is definitional for the compatible pair
`C6 = ⟨t⟩ × ⟨g^2⟩`; the content is *which* two points, verified above.)

### 3.3 `X^{S3}` — both classes empty

There are **exactly two** conjugacy classes of `S3` in `G`, each of size 55, each
with `N_G(S3) = D12` and `C_G(S3) = C2` (they are the two index-2 subgroups of
`D12 ≅ C2 × S3` isomorphic to `S3`, both normal in `D12`, and they are not fused
because any element carrying one to the other would normalise their common `C3`
and hence lie in `D12`). The two classes are told apart by their `A5`-overgroups:
`S3(a)` lies only in the `A5`s of class (a) (10 copies in each) and `S3(b)` only
in those of class (b).

For either class: the linear characters of `S3` are `triv` and `sgn`, and both
`W_triv` and `W_sgn` are contained in `W^{C3}`, which is **1-dimensional**.
Hence `P(W)^{S3}` is the single `D12`-point — and that point is off `X`. So

```
X^{S3(a)} = X^{S3(b)} = ∅ .
```

### 3.4 `X^{C11}` and `X^{F55}`

`T = diag(zeta^{j^2})` with `j^2 mod 11 ∈ {1,9,4,3,5}`, five **distinct**
eigenvalues, so `P(W)^{C11}` is the five coordinate points. Every monomial of
`F` involves two distinct variables (there is no `x_i^3` term), so **all five lie
on `X`**: `X^{C11}` is 5 points, one `G`-orbit of 60. The normalising `C5`
(the 5-cycle `x_i ↦ x_{i+1}`) permutes them in a single 5-cycle (verified:
permutation `(0 2 3 4 1)`), so there is no `F55`-fixed point; independently,
`W|_{F55}` is irreducible, so `P(W)^{F55} = ∅` outright. Both give
`X^{F55} = ∅`.

### 3.5 The already-sealed rows, replayed

* `C2`: `F|_{W^-} ≡ 0` exactly (all four binary-cubic coefficients vanish over
  `Q(zeta_11)`), so `L_sigma ⊂ X`. On `W^+` the residual `C3 ⊂ D12` acts with
  the three distinct characters `1, omega, omega^2`; in that eigenbasis the
  plane cubic is `a u^3 + b v^3 + c w^3 + d uvw` with `a,b,c,d ≠ 0`, and
  `t := -d^3/(27abc) = -16/11 ∈ Q` **exactly**, whence
  `j = 27 t (t+8)^3/(t-1)^3 = 8192/11` and, since `t ≠ 1`, `E_sigma` is
  **smooth**. `j` has denominator 11, so it is not an algebraic integer:
  `E_sigma` has **no CM**. The three `C3`-eigenpoints of the plus-plane
  (the `D12`-point and the two `+1` `C6`-points) are all off `X` — which is
  exactly `a, b, c ≠ 0`. Independent modular confirmation: the plus-plane cubic
  is smooth over `F_331` and `F_661` (no common zero of the three induced
  partials), with `a_331 = -7` and `a_661 = 17`, matching the reference curve of
  `j = 8192/11` up to quadratic twist (`a_ref = -7`, `-17`).
* `V4`: `W|_{V4} = triv^2 ⊕ chi_1 ⊕ chi_2 ⊕ chi_3`, `Fix(V4) = ℓ_V ⊔ 3 pts`;
  `F|_{ℓ_V} ≢ 0` with non-zero discriminant (3 distinct type-II points); the two
  residual-`C3`-fixed points of `ℓ_V` (the `A4`-points) are off `X`, so the three
  type-II points form a **free** residual-`C3` orbit; the three type-I vertices
  are on `X` and form another free 3-orbit. Hence `X^{A4} = ∅`.
* `C5`, `D10`: `F(v(w)) = w · sum_i (w^3)^i = 0` for `w^5 = 1, w ≠ 1`, because
  `{3i+1 mod 5} = {0,1,2,3,4}`; and `F(1,1,1,1,1) = 5`. So 4 points on, 1 off.
* `D12`: single fixed point, `F ≠ 0` — see §3.1.

---

## 4. Closure and incidence

`H' ⊆ H ⟹ X^H ⊆ X^{H'}`. The full containment poset of the 16 classes was
recomputed; below is the component-level content of every edge that is not
vacuous (an edge into an empty row carries no information beyond `∅ ⊆ ·`).

### 4.1 Edges into the `C2` row (`X^{C2} = E_sigma ⊔ L_sigma`)

Overgroups of `C2` are `V4, C6, S3(a), S3(b), D10, D12, A4, A5(a), A5(b), G`.

* **`C2 ⊂ V4`** (3 involutions per `V4`). With
  `W|_{V4} = A ⊕ B ⊕ C ⊕ D`, dims `(2,1,1,1)`:
  * each **type-I** vertex is the `+1`-eigenvector of exactly **one** of the
    three involutions and the `-1`-eigenvector of the other two (verified:
    sign pattern `(+,-,-), (-,+,-), (-,-,+)`). So it lies on exactly **one**
    plus-plane cubic `E_{sigma_i}` and on exactly **two** minus-lines
    `L_{sigma_j}, L_{sigma_k}` — the vertices of the minus-line triangle;
  * `ℓ_V = P(A)` lies in **all three** plus-planes and meets **no** minus-line
    (verified: `A` is `+1` for all three involutions, `(2,0)` each). Hence each
    **type-II** point lies on **all three** `E_{sigma_i}` and on **no**
    `L_{sigma}`.
  This is FIX-A1's `CLAIM_1_TRUE_CLAIM_2_FALSE` verdict, reproduced
  independently. Per-involution counts (FIX-A1 item 7, cited): `E_t` carries
  3 type-I + 9 type-II, `L_t` carries 6 type-I + 0 type-II.
* **`C2 ⊂ C6`**: `X^{C6}` is the 2 points of `L_t` fixed by the order-6
  generator. They lie on the **line** component, never on `E_t`. (FIX-A2's
  ambient relation `C6/chi ⊂ C2/sgn ×1` is the source-side shadow of this.)
* **`C2 ⊂ S3, D10, D12, A4, A5, G`**: `X^{H} = ∅` for all of these, so these
  edges are vacuous. In particular the 55 `D12`-points, the 66 `D10`-points and
  the 110 `A4`-points, which do lie in the plus-planes ambiently, are **off `X`**
  and so contribute nothing to `E_sigma`.

### 4.2 Edges into the `C3` row (`X^{C3}` = 6 points)

Overgroups of `C3` are `C6, S3(a), S3(b), D12, A4, A5(a), A5(b), G`.

* **`C3 ⊂ C6`**: `X^{C6}` = the two `C6`-points of `X^{C3}`, one on each
  eigenline — precisely the `2`-orbit of the residual `V4 = D12/C3`.
* **`C3 ⊂ S3(a), S3(b), D12, A4, A5, G`**: all empty. Note in particular that
  the `4`-orbit of exact-`C3` points meets **no** deeper row at all: its points
  have stabiliser exactly `C3`, which contains no involution, so they lie on no
  `X^{C2}` and hence on no `E_sigma` or `L_sigma` **as fixed points**.

### 4.3 The remaining edges

* **`V4 ⊂ A4, D12, A5, G`**: all empty; so `X^{V4}` (6 points) contains no
  deeper fixed point, i.e. each of the 6 has exact stabiliser `V4`.
* **`C5 ⊂ D10, A5, F55`**: all empty; so all 4 points of `X^{C5}` have exact
  stabiliser `C5`, and the two `D10`-orbits of size 2 are free.
* **`C11 ⊂ F55, G`**: empty; the 5 points of `X^{C11}` have exact stabiliser
  `C11` and are poset-isolated (FIX-A2 Finding 4), forming a single free
  `C5 = F55/C11` 5-cycle.
* **`C6 ⊂ D12`**, **`S3 ⊂ D12`**, **`A4 ⊂ A5`**, **`D10 ⊂ A5`**,
  **`S3(a) ⊂ A5(a)`**, **`S3(b) ⊂ A5(b)`**, **everything `⊂ G`**: empty targets.

**Consistency with the sealed ambient incidence.** `ℓ_V` carries exactly 3
`D12`-points and 2 `A4`-points and nothing deeper (FIX-A2 Finding 8), all five
off `X`; the three points of `X ∩ ℓ_V` are therefore disjoint from every deeper
ambient stratum, which is why they have exact stabiliser `V4`. Likewise a
`C3`-eigenline carries exactly 2 `C6`-points and nothing deeper, one on `X`.

---

## 5. Consequences

### 5.1 Corollary C3 (the new one; it fires)

> **Corollary (C3 base locus).** Let `V` be any non-zero finite-dimensional
> complex representation of `G`, and let `phi : P(V) ⇢ X` be **any**
> `G`-equivariant rational map. Then the linear subspace `P(V^{C3}) ⊆ P(V)` is
> contained in the indeterminacy locus of `phi`.
>
> Moreover `V^{C3} ≠ 0` for **every** non-zero `V`, so the statement is never
> vacuous.

*Hypotheses, all verified in this packet.*

1. `X^{C3}` is **finite** (6 points) — §3.1.
2. `X^{N_G(C3)} = X^{D12} = ∅` — row 11.
3. `dim V^{C3} ≥ 1` for every irreducible `V`. Degrees of the eight
   irreducibles are `1, 5, 5, 10, 10, 11, 12, 12` (sum of squares 660), and

   | `V` | `1` | `5` | `5'` | `10` | `10'` | `11` (St) | `12` | `12'` |
   |---|---:|---:|---:|---:|---:|---:|---:|---:|
   | `dim V^{C3}` | 1 | 1 | 1 | 4 | 4 | 3 | 4 | 4 |

   computed **directly, not from a character table**: `dim W^{C3} = 1` from the
   eigen-decomposition (and `W^* ` likewise); `dim(10)^{C3} + 1 = ` the number of
   `C3`-orbits on the 11 cosets of `A5` `= 5`, for each of the two classes of
   `A5`; `dim St^{C3} + 1 = ` the number of `C3`-orbits on the 12 cosets of
   `F55` `= 4`; and for each degree-12 principal series
   `Ind_{F55}^G alpha`, Mackey plus `gcd(55,3) = 1` gives
   `dim = #(F55-orbits on G/C3) = 220/55 = 4`. Cross-check:
   `sum_i (dim V_i^{C3})·(dim V_i) = 220 = [G : C3]`. ✔

*Proof.* `P(V^{C3})` is pointwise `C3`-fixed and is `N := N_G(C3)`-stable
(`N` preserves `V^{C3}`). Suppose `phi` is defined somewhere on `P(V^{C3})`.
Equivariance forces `phi(P(V^{C3})) ⊆ X^{C3}` where defined; `P(V^{C3})` is
irreducible and `X^{C3}` is finite, so `phi` is constant `= p ∈ X^{C3}` on a
dense open `U ⊆ P(V^{C3})`. For `n ∈ N` and general `q ∈ U`,
`n·p = n·phi(q) = phi(n·q) = p`, so `p ∈ X^{N} = X^{D12} = ∅`. Contradiction. ∎

This has exactly the shape of the sealed `C5/D10` corollary, with
`(C5, D10)` replaced by `(C3, D12)`.

### 5.2 The general dichotomy this ledger produces

The same proof works verbatim whenever hypotheses (a) and (b) of §2 hold, and
the table shows they hold for **fourteen of the sixteen rows**:

> **Theorem (receiver dichotomy).** Let `H ≤ G` be any subgroup other than the
> trivial subgroup and other than a `C2`. Then `X^H` is a finite set (empty for
> ten of the twelve such classes) and `X^{N_G(H)} = ∅`. Consequently, for every
> representation `V` with `V^H ≠ 0` and every `G`-equivariant rational map
> `phi : P(V) ⇢ X`, the linear subspace `P(V^H)` lies in the indeterminacy locus
> of `phi`.
>
> The two exceptions are exactly:
> * `H = 1`, where `X^1 = X` is `G`-stable, positive-dimensional and rationally
>   connected;
> * `H = C2`, where `X^{C2} = E_sigma ⊔ L_sigma` contains the `N_G(C2) = D12`-stable
>   rational curve `L_sigma ≅ P^1`.

Note that `(b)` holds for **every** row without exception, including `H = 1`
(`X^G = ∅`): the whole obstruction is carried by `(a)`.

### 5.3 Summary for the obstruction machine

* **Obstruction-ready, non-empty target** (finite `X^H ≠ ∅`, `X^{N} = ∅`) — the
  rows where the funnel lands in a non-empty finite set and still cannot be
  `N`-equivariantly closed: **`C3` (6 pts), `V4` (6 pts), `C5` (4 pts),
  `C6` (2 pts), `C11` (5 pts)**.
* **Obstruction-ready, empty target** (`X^H = ∅`, so the conclusion is
  immediate): **`S3(a)`, `S3(b)`, `D10`, `A4`, `D12`, `C11:C5`, `A5(a)`,
  `A5(b)`, `G`** — nine rows.
* **Blocked, and by exactly what**:
  * **`C2` — blocked by `L_sigma`**, the minus-line. `L_sigma ≅ P^1` is
    `D12`-stable, rational (hence RCC), and contained in `X`. It is the *only*
    blocker in that row: the other component `E_sigma` is an elliptic curve of
    `j = 8192/11` with no CM, hence not RCC and not rational, and it cannot
    receive a dominant map from a rational variety. Any equivariant construction
    hoping to survive at `H = C2` must send `P(V^{C2}_{triv})` into `L_sigma`.
  * **`1` — blocked by `X` itself**, which is rationally connected and
    `G`-stable. This is the tautological blocker: it is the statement that a
    `G`-equivariant unirational parametrisation is not excluded by the fixed
    locus of the trivial subgroup, which is of course expected.

So the ledger says: **the only two doors in the whole subgroup lattice are the
trivial subgroup and the involutions, and the only positive-dimensional rational
target anywhere in the equivariant fixed-locus system of `X` is the 55-orbit of
minus-lines `L_sigma`.** Every other row is a hard funnel.

---

## 6. Verification

Three genuinely different routes; every number is produced by at least two.

| route | file | what it does | marker |
|---|---|---|---|
| exact char-0 eigen-analysis | `scripts/produce_ledger.py` (+ `scripts/klein_core.py`) | `K = Q(zeta_165)` degree-80 exact arithmetic; character eigenspaces; binary/ternary cubics; Hesse `j`; stabilisers; subgroup lattice | `PRODUCE_LEDGER_OK`, 55 checks |
| exact char-0 (independent) + two split primes, brute-force point counts | `verifier.py` | Part A: independent `Q(zeta_11)` rebuild, all "lies on `X`" claims exactly (plus purely combinatorial arguments for the `C5` and `C11` eigenpoints). Part B: `p = 331, 661` (both `≡ 1 mod 165`); fixed loci by intersecting kernels over **tuples of generator eigenvalues** (no character theory); `X`-points by **brute-force enumeration** of `P^1(F_p)` / `P^2(F_p)`; every "off `X`" claim certified by one non-vanishing mod `p` (a char-0 proof). Part C: residual actions, orbit sizes, containments. Part E: ingests the M2 output | `RECEIVER_LEDGER_X_VERIFY_OK`, `ALLGREEN`, 101 checks |
| ideal-theoretic (Macaulay2) | `scripts/emit_m2.py` → `scripts/ledger_ideals.m2` | `X^H = V(F) + sum_g minors_2( x \| g·x )`, saturated; reports projective dimension, degree and **radicality** for all 16 rows over `GF(331)` and `GF(661)` | `LEDGER_IDEALS_M2_OK`, 32/32 |

M2 row results (identical at both primes):

```
1: dim 3 deg 3     C2: dim 1 deg 4     C3: dim 0 deg 6     V4: dim 0 deg 6
C5: dim 0 deg 4    C6: dim 0 deg 2     C11: dim 0 deg 5
S3(a), S3(b), D10, D12, A4, F55, A5(a), A5(b), G: empty (unit ideal after saturation)
```

and **every** row's ideal equals its own radical — so every point count above is
a count of *reduced* points, verified a second way (the first being the
non-vanishing of binary-cubic discriminants exactly in `K`).

Replay:

```sh
python3 scripts/produce_ledger.py            # writes results/ledger_exact.json
python3 scripts/emit_m2.py                   # writes scripts/ledger_ideals.m2
M2 --script scripts/ledger_ideals.m2 > results/m2_ledger_ideals.txt
python3 verifier.py                          # writes results/verifier_output.json
```

Artifacts: `results/ledger_exact.json`, `results/verifier_output.json`,
`results/m2_ledger_ideals.txt`, `results/producer_stdout.txt`,
`results/verifier_stdout.txt`.

---

## 7. Relation to the sealed certificates

Nothing in this packet contradicts any sealed result. Explicit agreements:

| sealed statement | source | status here |
|---|---|---|
| 16 subgroup classes, 620 subgroups, class sizes and normalisers | `FIX-A2-SOURCE-COMPLEX-PASS` | **re-derived independently, exact match** |
| `P(W)^H` shapes for all 16 classes | FIX-A2 Part II table | **re-derived, exact match** (three routes) |
| `X^sigma = E_sigma ⊔ L_sigma`, `j = 8192/11`, non-CM, residual `S3` | `FIX-A0-ARRANGEMENT-PASS` | **replayed**, `t = -16/11`, `j = 8192/11`, smooth, plus modular `a_p` twist match |
| `X^{V4}` = 6 reduced points, two free `C3`-orbits, `X^{A4} = ∅` | `FIX-A1-V4-REPAIR-PASS` | **replayed**, incl. the type-I sign pattern and `ℓ_V ⊂` all three plus-planes |
| type-II points invisible at `p = 331` | FIX-A1 item 9 | **reproduced** (0 `F_p`-rational at 331 **and** 661, 3 geometric) |
| `D12`-, `D10`-, `A4`-character points off `X`; `F = 5` at `[1:1:1:1:1]` | `certificates/CHECKS.md`, `subgroup_orbit_check.py` | **replayed exactly** |
| primitive `C3`-eigenpoint orbit 220, on `X` | `certificates/orbit_hilbert_check.py` | **replayed** (2 per eigenline × 110) |
| `W\|_{A5}`, `W\|_{F55}` irreducible | `subgroup_orbit_check.py`, FIX-A2 | **replayed** (`P(W)^H = ∅`) |
| `C3` residual reducedness was a *named remainder* in `STRATA_EXACT.md §6.1` and `NORMAL_CHARACTERS.md §5.1` | — | **CLOSED**: `disc(F\|_{eigenline}) ≠ 0` exactly in `K`, and the `C3` row ideal is radical in M2 at two primes |

**No contradictions were found.**

---

## 8. Named remainders

1. The field of definition of the four exact-`C3` points per `C3` is not
   determined here beyond "at most quadratic over the eigenline's field"; the
   modular evidence (split at 331, inert at 661) says the quadratic extension is
   non-trivial, but the exact quadratic character is not computed.
2. Fine geometry *inside* `E_sigma` (which of the 220 exact-`C3` points, if any,
   happen to lie on a given `E_sigma` without being fixed by its involution) is
   not computed; only fixed-locus containments are.
3. The `S3`-orbit decomposition of `E_sigma` as a curve (beyond the residual
   module structure `triv ⊕ std` on `W^+`) is not computed.
4. Corollary C3 and the dichotomy of §5.2 are statements about indeterminacy
   loci; they are **not** by themselves an obstruction to equivariant
   unirationality, and no such claim is made.
