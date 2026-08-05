# CORRECTION — the type-I / type-II `V4` incidence of the Klein cubic

**Packet:** `goal_runs_after_2880a28/FIX_A1_V4_INCIDENCE_REPAIR/`
**Program:** FIX ([E56]), foundation packet FIX-A1 (`theory/FIX_I_bcomplex.md` §7.2).
**Exit:** `FIX-A1-V4-REPAIR-PASS`. **Problem E headline: OPEN.**
**Verification class:** ALGEBRAIC-RECOMPUTE (`verify_v4_ground_truth.py`, 56 checks,
independent of the producer; terminal marker `FIX_A1_V4_REPAIR_VERIFY_OK`).

This file does not edit any existing artifact. It supersedes the text quoted
below; the supersession is stated explicitly in §6 for the notebook's
supersession map.

---

## 1. The old claims, verbatim, with sources

**(S1)** `WORKORDER_STRATA_MACHINE.md`, lines 157–167, "Mandatory input
reconciliation" (reproducing the primary external input `strata.md`, which the
environment addendum records as `LOCAL-MISSING`, SHA-256 `df9b12df…37512`):

> The supplied `strata.md` is candidate input, not yet a characteristic-zero
> certificate. It also contains an internal inconsistency:
>
> - its incidence table says that every type-II `V4` point lies on three fixed
>   elliptic curves;
> - its final sentence says that two positive-dimensional fixed-locus closures
>   can meet only at type-I points.
>
> These statements cannot both be correct. No later work package may silently
> choose one. **WP-1 must decide the exact incidence and update the theorem
> statement accordingly.**

Same file, house rule 2 (line 828): "**No silent repair of the strata table.**
Resolve its type-II incidence inconsistency explicitly."

**(S2)** `NOTEBOOK.md` line 1536, [E34] status block:

> - type-I/type-II `V4` incidence inconsistency in the supplied `strata.md`
>   flagged **unresolved** [WORK]

and, in the same entry: "NOT established: … a `V4` incidence inconsistency in
the input stratification is unresolved."

**(S3)** `certificates/STRATA_EXACT.md` §4, "Verdict":

> | (1) type-II on three elliptics | **SURVIVES** |
> | (2) positive-dim fixed loci meet only at type-I | **REFUTED** |
>
> **Corrected statement.** Positive-dimensional fixed-locus closures meet at
> type-II points: each type-II point is a triple intersection of the three local
> plus-plane elliptics (and lies on the V4 fixed line `P(A)`). Type-I points are
> the triangle vertices where one elliptic meets two minus-lines.
>
> Code marker in JSON: `CLAIM_1_SURVIVES_CLAIM_2_REFUTED`.

with the self-declared caveat (§5, item 2):

> **The type-II incidence is single-representative plus symmetry.** The "three
> fixed elliptics" verdict is verified exactly on one representative
> `V4 = <z,s>` and extended to all 55 subgroups / 165 points by the
> single-conjugacy-class orbit argument … Any downstream use requiring
> pointwise-independent verification at all 165 points must say so and redo it.

**(S4)** `certificates/strata/incidence_exact.json`, key `type_I_type_II_verdict`:

> "surviving_statement": "Each type-II V4 point is a triple intersection of the
> three plus-plane elliptics of its V4 (and lies on the V4 fixed line P(A)).
> Positive-dimensional fixed-locus closures therefore meet at type-II points as
> well as at type-I points."

**(S5)** `certificates/MARKED_S3_GEOMETRY.md` §3 ("Marked `V4` points on `E_t`"):

> | type I | 3 | one `Q`-vertex per `V4` through `t`, lying in `E_+` |
> | type II | 9 | three per `V4` through `t` (`R=X∩P(A)`) |
>
> Agrees with Gate 1: type-II points are triple elliptic meetings; on a fixed
> `E_t`, nine type-II points arise as 3 `V4`s × 3 type-II each.

but `certificates/strata/marked_s3_geometry.json` simultaneously records

> `"observed_typeII_at_67": 0`, `"observed_typeII_at_331": 0`,
> `"typeII_S3_orbit_sizes_67": []`, `"typeII_found": 0` (both primes),
> against `"typeII_count_per_Et": 9`

and asserts

> `"Gate1_typeII_consistency": "S3 decomposition on E_t agrees with Gate 1:
> type-II points are triple elliptic meetings; nine type-II points on E_t =
> 3 V4s × 3 type-II per V4."`

`certificates/strata/verify_marked_s3.py` checks that string only for the
substrings `"triple"`/`"type-II"` (lines 345–346); it never compares the claimed
9 against the observed 0.

**(S6)** `WORKORDER_STRATA_MACHINE.md` WP-3 tasks: "the six type-I `V4` points"
(line 443, tasks *on `L_t`*) and "Locate the three type-I and nine type-II `V4`
points exactly" (line 457, tasks *on `E_t`*). Read out of context these look like
a second contradiction (six versus three type-I points per involution).

---

## 2. The precise mathematical point at issue

Fix a `V4 = {1, σ₁, σ₂, σ₃} ≤ PSL(2,11)` and write, exactly,

```
W|_{V4} = A ⊕ B ⊕ C ⊕ D = triv² ⊕ χ₁ ⊕ χ₂ ⊕ χ₃          dims (2,1,1,1)
ℓ_V     = P(A) = P(W^{V4})                  the pointwise V4-fixed line in P⁴
p_i     = [χ_i]                             the three isolated V4-fixed points
L_{σ_i} = P(χ_j ⊕ χ_k)                      the minus-line of σ_i  (⊂ X)
E_{σ_i} = X ∩ P(A ⊕ χ_i)                    the plus-plane cubic (smooth)
```

The disagreement is about which V4-fixed points of `X` are the meeting points of
the positive-dimensional components of the fixed loci `X^{σ}`. It is settled by
two containments, both of which are pure linear algebra:

* `ℓ_V ⊂ P(A ⊕ χ_i)` for **every** `i` — so `R := X ∩ ℓ_V` lies on **all three**
  plane cubics `E_{σ₁}, E_{σ₂}, E_{σ₃}` (candidate claim 1);
* `ℓ_V ∩ L_{σ_i} = ∅` and `p_i ∈ L_{σ_j} ∩ L_{σ_k}` — so the type-I points are
  the vertices of the triangle of minus-lines and are **also** meeting points of
  positive-dimensional fixed closures (refuting the word "only" in claim 2).

## 3. The corrected statement

> **Theorem (FIX-A1).** For every one of the 55 Klein four-groups `V4 ≤ PSL(2,11)`:
>
> 1. `W|_{V4} = triv² ⊕ χ₁ ⊕ χ₂ ⊕ χ₃`, so `Fix(V4, P⁴) = ℓ_V ⊔ {p₁,p₂,p₃}`.
> 2. `X^{V4}` is **six reduced isolated points**: the three type-I vertices
>    `p₁,p₂,p₃` and the three type-II points `R = X ∩ ℓ_V`. At each of the six,
>    `T_pX ≅ χ₁ ⊕ χ₂ ⊕ χ₃` (no trivial summand).
> 3. **Type-I** `p_i` lies on exactly **one** plus-plane cubic (`E_{σ_i}`) and on
>    exactly **two** minus-lines (`L_{σ_j}, L_{σ_k}`), which are contained in `X`
>    and meet only there. It lies on **no** V4-fixed line.
> 4. **Type-II** points lie on **all three** plus-plane cubics, on **no**
>    minus-line, and on the V4-fixed line `ℓ_V` — which is a positive-dimensional
>    component of `Fix(V4, P⁴)` but is **not** contained in `X`.
> 5. Hence **candidate claim 1 is TRUE and candidate claim 2 is FALSE**;
>    positive-dimensional fixed-locus closures meet at *both* types of V4-point,
>    in the two structurally different patterns of (3) and (4).
> 6. Both types have exact stabiliser `V4`, giving two `G`-orbits of size
>    `660/4 = 165`; the flag counts close (`55·9 = 165·3 = 495` type-II/cubic
>    flags, `55·3·2 = 165·2 = 330` type-I/minus-line flags).
> 7. On a fixed involution's locus `X^t = E_t ⊔ L_t`: `E_t` carries **3 type-I +
>    9 type-II**, `L_t` carries **6 type-I + 0 type-II**. (Each of the 3 `V4`s
>    through `t` contributes one vertex to `E_t` and two to `L_t`.)

### The new part: the arithmetic of `R = X ∩ ℓ_V`

> 8. In the eigenbasis `(U,V)` of the residual `C3 = A4/V4 = N_G(V4)/V4` acting on
>    `A` (a matrix of trace `−1`, determinant `1`, eigenvalues `ω, ω²`),
>    ```
>    F|_A = α U³ + β V³        with α ≠ 0 and β ≠ 0   (exactly, for all 55)
>    ```
>    Consequences, all certified exactly:
>    * `disc(F|_A) ≠ 0`: `R` is **three distinct reduced points**, so `ℓ_V` meets
>      `X` transversally and the type-II points are isolated in `X^{V4}`;
>    * the two `C3`-fixed points of `ℓ_V` are exactly the two `A4`-fixed points of
>      `P⁴` on that line, and `α, β ≠ 0` says both are **off** `X`;
>    * therefore `R` is a **single free residual-`C3` orbit**;
>    * `ℓ_V` carries exactly five points of deeper isotropy — three `D12`-points
>      (fixed points of `C_G(σ_i)`; full stabiliser order 12, order profile
>      `1+7·2+2·3+2·6`) and the conjugate pair of `A4`-points — and **all five are
>      off `X`**, so `R` avoids every deeper stratum as well as the whole triangle.

### The repair of the modular observation (S5)

> 9. `F|_A` is either totally split or irreducible over any field over which the
>    residual `C3` is defined (that `C3` permutes the three roots simply
>    transitively). Over `Q(ζ₁₁)` it is **irreducible**: at `p = 67` the integral
>    reduction has unit leading coefficient and **no root in `F_p`, for all 55
>    lines**, so no root can lie in `Q(ζ₁₁)`.
>    Hence **no type-II point is individually rational over the field of the
>    representation**, and a modular fixed-point search sees the whole `R` or none
>    of it. Measured root-count histograms over the 55 lines:
>
>    | p | 23 | 67 | 89 | 331 | 353 | 397 | 419 |
>    |---|---|---|---|---|---|---|---|
>    | # `F_p`-rational type-II points per line | 0 | **0** | 0 | **0** | 0 | 3 | 3 |
>
>    The two primes used by the WP-3 marked-`S3` packet, 67 and 331, are exactly
>    primes at which the type-II points are invisible. Its
>    `observed_typeII_at_67 = observed_typeII_at_331 = 0` is therefore **correct
>    as an observation and consistent with the geometric count 9** — but it is not
>    evidence for it, and the packet's `Gate1_typeII_consistency` string asserts a
>    consistency it did not observe. **Any future regression must use a split
>    prime: `p = 397` or `p = 419` (both `≡ 1 mod 11`) show all 9 type-II points on
>    `E_t`.**

## 4. The exact evidence

| Statement | Where certified | Method |
|---|---|---|
| 55 involutions, 55 `V4` = Sylow-2, 3 per involution, `N_G(V4) ≅ A4` order 12, one conjugacy class | `v4_exact.json:group_layer` | exact 660-element closure over `Q(ζ₁₁)`; order profile has **no** element of order 4; normaliser profile `1+3·2+8·3` |
| `W|_{V4} = triv²⊕χ₁⊕χ₂⊕χ₃`, all 55 | `v4_exact.json:character_decomposition`, `per_V4[*].joint_dims` | producer: iterated kernels; verifier: isotypic projectors `¼Σχ(g)g` and ranks; plus the integer solution of `a₀+a_i−a_j−a_k=1, Σa=5` being uniquely `(2,1,1,1)` |
| all 165 minus-lines ⊂ `X`; all 165 vertices ∈ `X` | `per_V4[*].minus_lines_in_X`, `.vertices_on_X` | producer: all four coefficients of the restricted binary cubic vanish; verifier: vanishing at 5 distinct points of `P¹` |
| triangle, plus-planes ⊇ `ℓ_V`, `ℓ_V` ∩ edges = ∅ | `per_V4[*].triangle`, `.line_in_plus_planes`, `.line_disjoint_from_edges` | exact ranks over `Q(ζ₁₁)` |
| `disc(F|_{ℓ_V}) ≠ 0`, all 55 | `x_cap_v4line_scheme.json:scheme` | producer: symbolic restriction; verifier: Lagrange interpolation from 4 values, then the binary-cubic discriminant |
| `F|_A = αU³+βV³`, `α,β ≠ 0`, all 55 | `x_cap_v4line_scheme.json:residual_C3` | exact diagonalisation of `ρ|_A` over `Q(ζ₃₃)=Q(ζ₁₁)[w]/(w²+w+1)` |
| exact stabiliser of every type-II point is `V4` | `v4_exact.json:stabiliser_scan` (0 for all 55) | producer: `gcd(F|_A, all 2×2 minors of [g·a \| a]) = 1` for all 656 `g ∉ V4`; verifier: unit-ideal test for the same minors in the cubic residue algebra `Q(ζ₁₁)[t]/(F|_A)` |
| the five deeper points of `ℓ_V` (3 `D12` + 2 `A4`) are off `X` | `x_cap_v4line_scheme.json:position_on_the_line` | gcd of the minor system per element, then `α,β ≠ 0` |
| `T_pX = χ₁⊕χ₂⊕χ₃` at all six points; `N_{ℓ_V/P⁴} = χ₁⊕χ₂⊕χ₃` | `x_cap_v4line_scheme.json:tangent_data` | `dF` along `ℓ_V` annihilates `B,C,D` identically (identity of binary quadratics) and `dF` at a vertex kills `B,C,D` and is nonzero on `A` |
| the plus-plane cubics `E_t` are **smooth** for all 55 involutions | `cubic_smoothness.m2` → `FIX_A1_PLUS_PLANE_SMOOTH_OK` | Macaulay2 over `toField(QQ[a]/Φ₁₁)`: the ideal of partials has `dim = 0`, i.e. empty projective singular locus |

## 5. What is *not* claimed here

* No `j`-invariant, no Weierstrass model, no `E[2]`-charge statement. The
  `E[2]`-charge labelling of `MARKED_S3_GEOMETRY.md` §3 is untouched by this
  packet except for the visibility correction in §3.9; its arithmetic content
  (`j(E_t)=8192/11`, freeness of the residual order three) remains WP-3/FIX-A0
  material and is neither confirmed nor refuted here.
* Nothing about landing covariants, dominant maps, or unirationality. The
  headline stays **OPEN**.
* The smoothness of `E_t` is certified here, but its identification as *the*
  elliptic component of `X^t` (i.e. `X^t = E_t ⊔ L_t` with nothing else) is
  FIX-A0's statement; this packet re-derives only the parts it uses:
  `W^{t,+}` is 3-dimensional, `W^{t,−}` is 2-dimensional, and `P(W^{t,−}) ⊂ X`.

## 6. Supersession map (for the notebook)

| Superseded text | Status after FIX-A1 |
|---|---|
| `WORKORDER_STRATA_MACHINE.md` 157–167 — "these statements cannot both be correct … WP-1 must decide" | **DISCHARGED.** Claim 1 TRUE, claim 2 FALSE; corrected statement in §3. |
| `NOTEBOOK.md` 1536 — "flagged **unresolved** [WORK]" | **SUPERSEDED.** The inconsistency is resolved with an exact characteristic-zero certificate; [E34]'s "NOT established" line should now read *resolved by FIX-A1*. |
| `certificates/STRATA_EXACT.md` §4 + `strata/incidence_exact.json` — `CLAIM_1_SURVIVES_CLAIM_2_REFUTED` | **CONFIRMED and EXTENDED.** Independently re-derived; extended from one representative `V4` to all 55 (retiring §5 caveat 2); refined by the observation that type-I points are *also* meetings of positive-dimensional closures, and by §3.8–3.9. |
| `certificates/MARKED_S3_GEOMETRY.md` §3 / `marked_s3_geometry.json` — 9 type-II per `E_t` with `observed_typeII_* = 0` and an unqualified `Gate1_typeII_consistency` | **CORRECTED in scope.** The count 9 is right, the observation 0 is right, and the two are compatible only through the irrationality of `R`; the consistency string overstates what was observed. Future regressions must use `p = 397` or `419`. |
| `WORKORDER_STRATA_MACHINE.md` 443 vs 457 — "six type-I" vs "three type-I" | **NOT a contradiction.** Six on `L_t`, three on `E_t`; §3.7. |

## 7. Consequences for the FIX b-complex ([E56], Note I)

* `(V4, ℓ_V)` is a 1-dimensional stratum of `𝔽(P⁴)` with `δ_nr = χ₁⊕χ₂⊕χ₃`
  (no trivial summand, as Def. 1.1 requires) and `δ_res = C3` acting on `P¹`
  with two fixed points — both off `X`.
* `𝔽(X)` has **no** positive-dimensional `V4`-stratum: `X^{V4}` is six reduced
  points. So Corollary 4.4's funnel, applied to `H = V4`, lands in a
  **six-point** set, and the residual `C3` at a `V4`-line stratum of any model of
  `P(W)` must map to a `C3`-stable subset of those six points. The three type-II
  points form a *free* `C3`-orbit; the three type-I vertices form another free
  `C3`-orbit. Hence **no** `V4`-fixed point of `X` is `A4`-fixed, which is the
  exact sense in which the `A4`-fixed points of `P⁴` (the two points of
  `ℓ_V` off `X`) fail to be available as images. This is the certified form of
  the hypothesis used in `WORKORDER_STRATA_MACHINE.md` WP-4C item 1.
