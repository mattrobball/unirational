# The complete branch table at the first open degree `d = 35`

Exits: `D35-BRANCH-TABLE-EXACT`,
`D35-COMMON-FACTOR-CELLS-K32-AND-K33-EXCLUDED`,
`D35-ONE-DIMENSIONAL-RAMIFICATION-CELLS-IDENTIFIED`.

> **Update, 2026-08-11 (`D35_K30_K31_CELLS.md`).** The two one-dimensional cells
> registered below as "immediately actionable" — `k = 31` (`d' = 4`) and
> `k = 30` (`d' = 5`) — have since been **decided DEAD**, and by a route one
> step earlier than the ramification test §3 proposes: the space of candidate
> restricted tuples is one-dimensional in each cell (not the two-dimensional
> pencil §3.1 expects — `F·x` is in the kernel of restriction), and the single
> candidate fails `F(B) = 0` on `X`. The exclusion is degree-uniform and needs
> no dominance hypothesis. The table's `k = 30, 31` rows and the surviving-set
> line (39) are corrected in place below; §3 is left standing as the record of
> what was registered, with the outcome marked.

Provenance: external round 5, section 7 (unaudited). Verdict: **CONFIRMED**;
every number recomputed exactly in `verify_d35_dimensions.py` (`RESULT: PASS`,
112 checks, exact character arithmetic over `Z[(1+sqrt(-11))/2]`, no floating
point). One presentational correction: the source's tables (42) and (43) are
**the same table**, not two.

---

## 1. What fixes the table

The repository boundary is unchanged: all ambient coordinate degrees `d <= 34`
are excluded, `d = 35` is the first open degree.

Three inputs cut the `k`-range, where `k = deg H` is the common-factor degree
and `d' = 35 - k` the restricted coordinate degree:

| input | statement | source |
|---|---|---|
| invariant-degree lemma | `k in {0} ∪ {5,6,7,...}` | sealed, `COMBINED_DEGREE_SIEVE` Lemma 2.3 |
| ramification exclusion | `d' != 2, 3` | `EXCLUSION_DPRIME_2_3.md` (new) |
| covariant-space exclusion | `d' != 4, 5` | `D35_K30_K31_CELLS.md` (2026-08-11) |
| restricted-transfer | `k = 0 => CARRIER`; retraction `=> k != 0` | sealed, `THEOREM_ACTUAL_TRANSFER.md` |

## 2. The table

`Delta_T|_X` lives in `H^0(X,O_X(68))^G`, and `j_phi` in
`H^0(X,O_X(2d'-2))^G`. Because `68 - 2k = 2(35-k) - 2 = 2d'-2`, the space that
`Delta_T/H^2` lives in **is** the space that `j_phi` lives in — the source's
(42) and (43) are one table, indexed once by `k` and once by `d'`.

```
dim H^0(X, O_X(68))^G = 254.
```

| `k` | `d' = 35-k` | `dim H^0(X,O_X(2d'-2))^G` | status |
|---:|---:|---:|---|
| 0 | 35 | 254 | possible; necessarily **CARRIER** (`RT-DX0-PROVED`) |
| 5 | 30 | 160 | open |
| 6 | 29 | 145 | open |
| 7 | 28 | 131 | open |
| 8 | 27 | 117 | open |
| 9 | 26 | 105 | open |
| 10..29 | 25..6 | 93, 82, 73, 64, 56, 48, 42, 35, 30, 26, 20, 17, 14, 11, 9, 7, 5, 4, 3, 2 | open |
| **30** | **5** | **1** | **EXCLUDED** (`D35_K30_K31_CELLS.md`) — was "one-dimensional, actionable" |
| **31** | **4** | **1** | **EXCLUDED** (`D35_K30_K31_CELLS.md`) — was "one-dimensional, actionable" |
| 32 | 3 | **0** | **EXCLUDED** (`EXCLUSION_DPRIME_2_3.md`) |
| 33 | 2 | **0** | **EXCLUDED** (`EXCLUSION_DPRIME_2_3.md`) |
| 34 | 1 | 1 | retraction branch, `phi = id_X`, `D_X != 0` |
| `>= 35` | `<= 0` | — | impossible |

The `k = 5..9` row of the source, `160, 145, 131, 117, 105`, is confirmed
exactly, as is `254`, and the two `1`s at `k = 30, 31`.

**Open cells at `d = 35`: 27** — `k = 0` (CARRIER), `k = 5..29`, `k = 34`
(retraction). Down from `29` after `k = 30, 31` were excluded.

The three shapes of the tangency identity are then:

```
 k = 0        :  Delta_T|_X = j_phi                   (CARRIER)
 5 <= k <= 31 :  Delta_T|_X = (35/d') H^2 j_phi
 k = 34       :  Delta_T|_X = 35 H^2                  (phi = id_X, j_phi = 1)
```

The `k = 34` line is a sharp, checkable normal form: the retraction branch has
`H` of degree `34` and `Delta_T|_X = 35 H^2` on the nose, with **no** free
ramification factor. (The constant `35 = d/d'` comes from Lemma 3.1 of
`THEOREM_SOURCE_TANGENCY.md`; the source's unspecified `c` hides it.)

## 3. The two one-dimensional cells — immediately actionable

> **OUTCOME (`D35_K30_K31_CELLS.md`): both DEAD.** What follows is left as
> written, as the record of what this packet registered. Two things in it are
> corrected there. (i) The candidate space at `d' = 4` is **not** the
> two-dimensional `C(4) = 2`: `B` lives on `X`, i.e. modulo `F`, and `F·x` — one
> of the two basis members named in §3.1 below — restricts to `0`. The right
> count is `C(d') - C(d'-3)`, giving `1` at `d' = 4` and `1` at `d' = 5`. (ii)
> The ramification-locus test §3.1 proposes is never reached: the single
> candidate in each cell fails the *earlier* necessary condition `F(B) = 0` on
> `X`, so there is no restricted selfmap and no ramification divisor to compare.

> **`k = 31`, `d' = 4`.** `j_phi in H^0(X,O_X(6))^G`, which is
> **one-dimensional**. So `j_phi` is, up to scalar, a single named invariant
> sextic on `X` — the restriction of the degree-`6` invariant `D` of the frame
> `(x, C, D, E, K_7)`, modulo `F^2`. Concretely: `I(6) = 2` with basis
> `{F^2, D}`, and `I(3) = 1`, so `H^0(X,O_X(6))^G = C·D|_X`.
>
> **`k = 30`, `d' = 5`.** `j_phi in H^0(X,O_X(8))^G`, also
> **one-dimensional**: `I(8) = 2`, `I(5) = 1`, and the kernel of restriction is
> `F·(degree-5 invariants) = C·(F·C)`, so `H^0(X,O_X(8))^G` is spanned by the
> image of any invariant octic not proportional to `F·C`.

These are not searches. Each is one named section, and the tests they license
are finite and small:

1. **Ramification-locus test.** In cell `k = 31`, the ramification divisor of
   the restricted selfmap is forced to be `div_X(D|_X)` — a single, explicitly
   computable `G`-invariant surface in `X` of class `6H_X`. A degree-`4`
   `G`-equivariant selfmap of `X` whose ramification is not that divisor does
   not exist. This is a rigid condition on a `4`-dimensional-coordinate-degree
   selfmap, and it can be attacked directly: classify `G`-equivariant
   `B in (Sym^4 W^v ⊗ W)^G` with `F(B) = 0` on `X`. The relevant covariant
   space is `C(4) = 2`, i.e. **two-dimensional** (`FOLIATION_REFORMULATION.md`
   §2), spanned by `F·x` and the degree-`4` covariant already written down in
   `verify_d4_covariant.py`.
2. Likewise cell `k = 30` needs `B in (Sym^5W^v ⊗ W)^G`, `C(5) = 1`: a
   **one-dimensional** space of candidates.
3. In both cells `H` is an invariant of degree `31`, resp. `30`, on `X`, and
   `Delta_T|_X = (35/d') H^2 j_phi` becomes a single scalar equation between
   named objects once `B` is pinned.

Recorded as the concrete next computation. **Not done in this packet.** What is
done: the cells are identified, their dimensions are exact, and the objects they
require are named.

**Done in `D35_K30_K31_CELLS.md`, 2026-08-11.** The degree-`5` generator `D_5`
was constructed and audited, the two candidate spaces on `X` came out
one-dimensional, and `F(B) not in (F)` for both generators — with exact point
certificates on `X` and under both equivariance conventions. Both cells DEAD;
`d' = 4, 5` excluded in every ambient degree, with no dominance hypothesis.

## 4. Cross-checks performed

* `I(k)` and `C(k)` for `k = 0..24` reproduce the table of
  `FOLIATION_REFORMULATION.md` §2 exactly (independent implementation:
  integer/`Z[sqrt(-11)]` linear recurrences from the characteristic polynomials,
  versus the packet's `Q(zeta_330)` computation).
* `dim H^0(X,O_X(n))^G` for `n = 0..12` reproduces the sealed sieve table
  `1,0,0,0,0,1,1,1,1,1,2,2,3`.
* The invariant-degree set `{k : H^0(X,O_X(k))^G != 0} = {0} ∪ {5,...}` is
  reconfirmed for `k <= 80`.
* The eigenvalue multisets of the classes `2A, 3A, 5A, 6A` are **derived**, not
  assumed, by brute-force enumeration against the character values on all
  powers; the elementary symmetric functions of the quadratic residues mod `11`
  (`e = (a1, -1, -1, a2, 1)`) are derived likewise, and
  `charpoly(11A)·charpoly(11B) = 1 + t + ... + t^10` is checked.
* The divergence-free count at `d = 35`: `C(66) = 6992`, `I(65) = 1357`,
  `dim ker(div)^G = 5635` — the source's (50), confirmed. Divergence-freeness
  alone is therefore far too weak, as the source says.

## 5. Generic-fibre consequences: `ind(C) | delta`, and `4 | delta` when even

Exit: `GENERIC-FIBRE-INDEX-DIVIDES-DELTA-PROVED`,
`CLEAN-EVEN-DELTA-IS-DIVISIBLE-BY-FOUR-PROVED`.

Round 5 section 10, confirmed. Let `C/K(X)` be the generic fibre of the ambient
landing map `q : Y -> X` (a curve, since `dim Y = 4`).

> **(52)** `ind(C) | delta`.

*Proof.* `THEOREM_ACTUAL_TRANSFER.md` (1.1) supplies a finite `h : Gamma -> Y`
with `q h = q_Gamma`, and `q_Gamma : Gamma -> X` is generically finite of degree
`delta`. The fibre of `q_Gamma` over the generic point of `X` is a
zero-dimensional `K(X)`-scheme of degree `delta` mapping into `C = Y_gen`;
i.e. `C` carries a closed point of degree dividing `delta`. Hence
`ind(C) | delta`. ∎

Consequences, at the granularity the trichotomy supports:

* `g(C) = 0`: `C` is a conic, `ind(C) in {1,2}`, and period `=` index. If
  `delta` is **odd** then `ind(C) = 1` and `C(K(X)) != ∅`.
* `g(C) = 1`: the Jacobian torsor has period and index dividing `delta`.
* `g(C) >= 2`: the variation `R^1 q_* Q` must coexist with the ambient
  Hodge-support localisation.

> **(53)** In the CLEAN branch, `delta = x^2 + xy + 3y^2` (the sealed norm form
> of `Q(sqrt(-11))`, `RT_SPLIT_AND_DICHOTOMY/THEOREM_RESTRICTED_DICHOTOMY.md`
> (4.4)). `-11 ≡ 5 (mod 8)`, so **2 is inert** in `Q(sqrt(-11))` and the
> `2`-adic valuation of any norm is even. Hence an even `delta` is divisible by
> `4`, and a **nonsplit genus-zero CLEAN fibre requires `4 | delta`**.

Both checked in `verify_d35_dimensions.py` block (H): no value of
`x^2+xy+3y^2` in `[1,400]` is `2 (mod 4)`; `3` is a norm and `2` is not.

**Honest note, and it points the other way.** A genus-zero `delta = 3` survivor
would give `C(K(X)) != ∅`, i.e. a rational generic fibre, i.e. a stable
birational factorization of `P^4` over `X`. That is a **positive** consequence,
not a contradiction. The sealed sieve's surviving cell is precisely
`delta = 3` at every `d >= 31` (`COMBINED-SIEVE-NO-PERIODIC-CLOSURE-PROVED`),
so this observation says the surviving cell is the one where the construction
would *succeed*, not the one where it is nearly dead. Recorded as such.

## 6. Non-claims

* No cell is realised and, apart from `k = 32, 33`, none is excluded.
* The one-dimensionality of the `k = 30, 31` cells is a statement about
  `j_phi`, not about the tuple: the ambient covariant space at `d = 35` is
  large.
* The identification of the spanning invariants in §3 with the named frame
  elements `D`, `C·D` is by degree bookkeeping only; no explicit form is
  computed here.

**Problem E headline: OPEN.**
