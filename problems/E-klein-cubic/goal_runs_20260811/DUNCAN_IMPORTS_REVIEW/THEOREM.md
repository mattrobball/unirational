# `DUNCAN_IMPORTS_REVIEW` — in-repo proof review of the two EXTERNAL-UNVERIFIED
# Duncan imports, plus the citation-drift fix and the Tschinkel–Zhang pin

**Date:** 2026-08-11 · **Class:** ANALYTIC-PROOF-REVIEW + spot CAS ·
**Entry:** E56 · **Headline:** unchanged, Problem E remains OPEN.

Source under review: `external_docs/duncan_higher_obstruction_20260805.tex`
("Obstructions to equivariant rational maps", A. Duncan + AI assistants,
received 2026-08-05, 1553 lines).  All line numbers below are lines of that
file as it stands in the working tree.

---

## 0. Verdicts

| import | label | number | verdict |
|---|---|---|---|
| pairs criterion | `thm:pairs` (via `prop:noncyclic_fabulous`, `lem:number_theory`, `prop:cyclic_not_fabulous`) | **4.1** (4.3, 4.4, 4.5) | **REVIEWED-SOUND** |
| total-RCC theorem | `prop:rcc_total` (via `lem:tree`, Serre's tree lemma, Tsen) | **4.11** (4.2) | **REVIEWED-SOUND** |

**No gap was found in either proof.**  Neither `(F2)` on `Z⁺`
(`STAGE1_COMPLEX_MAPS` §7) nor Theorem E of `DUNCAN_CORNER_F2` is demoted;
both may be re-graded from EXTERNAL-UNVERIFIED to **IMPORT-REVIEWED (in-repo,
analytic)** — still an import, but no longer unverified.

Four **statement-hygiene** items and three **usage conditions** are recorded in
§4.  None of them is a gap; two of them are conditions the *dependent packets*
must supply, and one of them (`prop:rcc_total` is about `T_I^†`, not `T_I`) is
worth checking downstream.

Two secondary deliverables:

* **§6 — citation drift.** All 31 labels re-verified from the tex by script
  (`scripts/chk0_tex_numbering.py` → `results/chk0_tex_numbering.txt`, 0
  mismatches); three correction banners inserted in the working tree.
* **§7 — Tschinkel–Zhang pin for `V14_MAP_DICHOTOMY` Theorem B.**  Verdict:
  **no complex-analytic step** — the construction is linear algebra, so the
  Theorem-B step is not flagged on that ground — but the pin is **PARTIAL**, for
  two reasons stated prominently there (TZ's declared base field is
  *algebraically closed*, and the terminal source of the map is Kuznetsov
  [Kuz04, Rem. 2.19], which is not in `external_docs/`).

---

## 1. What the dependent packets actually import

`DUNCAN_CORNER_F2/STATUS.md:63–67` and `STAGE1_COMPLEX_MAPS/THEOREM.md:720`
(branch `agent/stage1-complex-maps-20260810`) name the two imports:

* **`thm:pairs`** carries claim A of the corner packet: at a codimension-2
  corner of the source, "fabulous" is decided by one group-theoretic test, and
  for `G = PSL(2,11)` that test selects exactly the Klein four-groups (the 55
  non-cyclic abelian subgroups).  If it fell, the *fabulous* verdict of every
  corner would fall.
* **`prop:rcc_total`** (with `thm:fabulous` 3.8 and `prop:rcc` 3.9) carries
  `(F2)` — the target-side edge constraint — and Theorem E.  If it fell, `(F2)`
  and Theorem E would fall, while Propositions A–D, the tower, W1–W3, W5–W6 and
  `(F1)` would stand (`NOTEBOOK.md:6453–6457`).

Both statements sit inside the standing hypotheses of §§3–4 of the tex, which
the review treats as hypotheses, not as claims:

> **(T)** `X` smooth projective, `G` finite acting faithfully, `X` in **toroidal
> form** with respect to a `G`-stable divisor `D = D_1 ∪ … ∪ D_n`
> (`def:toroidal` 2.1: every `D_I` empty or smooth irreducible of codimension
> `|I|`; `X_nt ⊆ D`; each `G_x` preserves the branches through `x` and acts
> **faithfully** on `⊕_{i∈I(x)} T_xX/T_xD_i`), **and** the standing convention
> `G_{D_k} ≠ 1` for every `k` (tex 240–243).

Condition (T) forces every `G_x` to be abelian of rank `≤ |I(x)|` (tex 83–90);
that abelianness is used at exactly one point of each proof and is flagged
there.

---

## 2. `thm:pairs` (4.1) — "`D_ij` is fabulous ⟺ `G_{D_ij}` is not cyclic"

### 2.0 The local setup (tex 703–725) — checked

`H := G_{D_ij}`, `x ∈ D_ij` general so `G_x = H` and `I(x) = {i,j}`.

* "`H` preserves `D_i` and `D_j` — it does not interchange them" is literally
  `def:toroidal`(c). ✔
* `H` acts on the two normal lines by characters `χ_1, χ_2`, and faithfulness of
  the normal representation says `ker χ_1 ∩ ker χ_2 = 1`, which by duality is
  exactly `⟨χ_1, χ_2⟩ = Ĥ`. ✔
* `H` acts trivially on the remaining coordinates because `H = G_{D_ij}` fixes
  `D_ij = {u_1 = u_2 = 0}` pointwise, hence acts trivially on `T_xD_ij`. ✔
  (The tex asserts this at 720–721 without the one-line reason; supplied here.)
* `G_{D_i} = ker χ_2` and `G_{D_j} = ker χ_1`: an element fixing `D_i = {u_1=0}`
  pointwise fixes `x`, hence lies in `H`, and acts trivially on `u_2`. ✔
  **This is where the standing convention bites**: `G_{D_i}, G_{D_j} ≠ 1` says
  *neither* `χ_1` *nor* `χ_2` is injective.  (Machine consequence, checked:
  a cyclic `H` satisfying this and generating `Ĥ` can never have prime order —
  `results/chk2_number_theory_lemma.txt`, last line.)

### 2.1 `prop:noncyclic_fabulous` (4.3): non-cyclic ⟹ fabulous — step by step

| # | step (tex line) | check |
|---|---|---|
| 1 | reduce to `π : W → X` with `W` smooth (764, via `lem:fabulous_cofinal` 3.5 + `cor:cofinal` 2.3) | **OK.** 3.5 says the condition for `π∘μ` at `x` implies it for `π` at `x`; smooth-source morphisms are cofinal by equivariant resolution in char 0.  The `μ(D̃_i^{W'} ∩ π'^{-1}(x)) = D̃_i^{W} ∩ π^{-1}(x)` step of 3.5 is an equality, not just `⊆`, because `D̃_i^{W'} → D̃_i^{W}` is proper surjective. ✔ |
| 2 | `Φ = π^{-1}(x)` a single point `w` ⟹ done (766–768) | **OK.** `π` equivariant and the fibre a point ⟹ `G_x ⊆ G_w ⊆ G_{π(w)} = G_x`, so `G_w = H ≠ 1`; `D̃_i ∩ π^{-1}(x) ≠ ∅` by 3.1(c). ✔ |
| 3 | otherwise `Φ` is a **tree of smooth rational curves** (`lem:tree` 4.2) | **OK**, see §2.2. (Pedantic: 4.2 gives the statement for `Φ_red`; only the support is used.) |
| 4 | `A_i := D̃_i ∩ Φ`, `A_j := D̃_j ∩ Φ` are non-empty, connected, `⊆ W_nt`, `H`-stable (771–775) | **OK.**  Non-empty + connected is `lem:fabulous_basics` 3.1(c) (Zariski's main theorem, using `D_i` smooth hence normal); `⊆ W_nt` is 3.1(b) and **uses `G_{D_i} ≠ 1`**; `H`-stable because `H` preserves `D_i`, `D_j` and fixes `x`. ✔ |
| 5 | each of `A_i, A_j` is a point or a connected union of components (774–775) | **OK.** A closed subset of a curve is (components) ∪ (finite set); if connected and containing no component it is a single point, and any extra point of a connected such set lies on a chosen component. ✔ |
| 6 | `Γ` := the smallest connected closed subset containing `A_i ∪ A_j` exists and is unique because `Φ` is a **tree** (777–782) | **OK.**  In a tree the convex hull of two connected subtrees is the union with the unique joining path.  (Note the degenerate case where `A_i` is one point in the interior of a component `B`: then any connected *closed* subset containing it and the neighbouring node contains all of `B`, so `B` is on the path — consistent.) ✔ |
| 7 | `Γ` is `H`-stable and `H` fixes each component `B_{l_t}` of the path (782–787) | **OK.**  Uniqueness gives `H`-stability; `H` preserves `A_i` and `A_j` *separately*, so it cannot reverse the linear order of the path, hence fixes every element of it. ✔ |
| 8 | each `B := B_{l_t}` meets its path-neighbour `Λ` in exactly one **`H`-fixed** point `q` (789–794) | **OK.**  `B ≠ Λ` by minimality of `Γ`; distinct components of a tree meet transversally in one point, and adjacency gives exactly one; both sets are `H`-stable so `Hq = q`. ✔ |
| 9 | `H` acting on `B ≅ P¹` fixing `q` acts through a **character** `ψ_B` (796–801) | **OK.**  In char 0 a finite-order element of `PGL_2` is semisimple; a finite abelian group of semisimple elements of a Borel is simultaneously diagonalizable, hence lies in a maximal torus.  **This step uses that `H` is abelian**, which (T) supplies. ✔ |
| 10 | **the decisive step:** `H` non-cyclic ⟹ `ker ψ_B ≠ 1` ⟹ `B ⊆ W_nt` (802–803) | **OK** — the image of a character is a finite subgroup of `C^*`, hence cyclic.  This single fact is the entire content of the direction.  Machine-checked as a statement over all abelian groups of order ≤ 100 with ≤ 3 factors: `results/chk1_no_faithful_character.txt`, 322 groups, 0 failures. ✔ |
| 11 | `Γ ⊆ W_nt` connected containing `A_i, A_j` ⟹ Definition 3.2 at `x` (805–809) | **OK**, and "general `x`" is a genuine dense open: `{x : I(x) = {i,j}}` is open dense in `D_ij`, and `{x : dim π^{-1}(x) ≤ 1}` is open (semicontinuity) and non-empty by `lem:fibre_dimension` 3.6. ✔ |

**Decisive quotation** (tex 802–803):

> Since $H$ is not cyclic, no character of $H$ is injective, so
> $\ker\psi_B \neq 1$ and $B \subseteq W_{nt}$.

### 2.2 `lem:tree` (4.2) — the tree structure

`Φ` connected (3.1(c)), `dim Φ ≤ 1` (3.6); `X` smooth ⟹ rational singularities
⟹ `R¹π_*O_W = 0`; formal functions [Hartshorne III.11.1] gives
`lim H¹(Φ_m, O) = 0`; the transition maps are surjective because the kernels
`I^m/I^{m+1}` live on a curve so `H² = 0`, and a surjective inverse system with
zero limit is zero termwise (Mittag-Leffler); `O_{Φ_m} ↠ O_{Φ_red}` with the
same `H²`-vanishing gives `p_a(Φ_red) = 0`; a connected reduced curve of
arithmetic genus 0 is a tree of smooth rational curves meeting transversally.
**Every step checks.** ✔

### 2.3 `lem:number_theory` (4.4) — the weight arithmetic

Statement: `H` cyclic, `χ_1, χ_2` generating `Ĥ` ⟹ ∃ **coprime** `a, b > 0`
with `χ_1^b χ_2^{-a}` injective.

Proof audit.  `Ĥ ≅ Z/m`, `χ_k = c_k`; the hypothesis is `gcd(c_1,c_2,m) = 1`,
and `χ_1^bχ_2^{-a}` is injective iff `gcd(bc_1 - ac_2, m) = 1`.  Pick `s,t` with
`sc_1 + tc_2 ≡ 1 (m)`; then `a ≡ -t`, `b ≡ s` give `bc_1 - ac_2 ≡ 1`.
`gcd(s,t,m) = 1` because a common prime would divide `sc_1 + tc_2 - km = 1`.
Take `a > 0` with `a ≡ -t (m)`, and by CRT `b > 0` with `b ≡ s (m)` and
`b ≡ 1 (q)` for every prime `q | a`, `q ∤ m` (legal: those `q` are coprime to
`m` and to each other).  Then `gcd(a,b) = 1`: a common prime `q` with `q ∤ m`
contradicts `b ≡ 1 (q)`; with `q | m` it forces `q | t` and `q | s`,
contradicting `gcd(s,t,m) = 1`. ✔

**Machine replay:** the construction was executed for **all 483 672** triples
`(m, c_1, c_2)` with `m ≤ 120` and `gcd(c_1,c_2,m) = 1`; both conclusions hold
in every case, 0 failures, and an independent brute-force search confirms the
*existence* statement for `m ≤ 60` with no missing witness
(`results/chk2_number_theory_lemma.txt`).

### 2.4 `prop:cyclic_not_fabulous` (4.5): cyclic ⟹ not fabulous — step by step

| # | step (tex line) | check |
|---|---|---|
| 1 | `J := ∏_{g∈G}(I_{gD_i}^b + I_{gD_j}^a)` is a non-zero `G`-invariant ideal (844–848) | **OK.** `h` sends the factor indexed by `g` to the factor indexed by `hg`. ✔ |
| 2 | `π :=` normalisation of `Bl_J X` is proper, birational, equivariant (849–851) | **OK.** Both operations are canonical; birational because `J` is the unit ideal near a general point of `X`. ✔ |
| 3 | near a general `x ∈ D_ij`, `J = (u_1^b,u_2^a)^e` or `(u_1^b,u_2^a)^e(u_2^b,u_1^a)^e`, `e ≥ 1` (853–862) | **OK.** The factor for `g` is the unit ideal at `x` unless `x ∈ gD_i ∩ gD_j`, which forces `{gD_i,gD_j} = {D_i,D_j}` since `I(x) = {i,j}`.  The two index sets are a subgroup and a coset of it, so the exponents agree and `e ≥ 1` (the identity). ✔ |
| 4 | so `π` is locally the product of a **toric modification of the `(u_1,u_2)`-plane** with the germ of `D_ij`, with fan = normal fan of the Newton polyhedron (862–870) | **OK.**  Normalised blowup of a monomial ideal = the toric variety of the normal fan of its Newton polyhedron [Fulton]; the ideal is monomial in `u_1,u_2` alone in the linearising analytic coordinates, so the modification is pulled back from `A²`. ✔ |
| 5 | the Newton polyhedron of `(u_1^b,u_2^a)` has an edge with inner normal `v = (a,b)`; products ↦ Minkowski sums ↦ common refinement, so `v` is a ray of the fan (866–870) | **OK**, and machine-verified from scratch for all 91 coprime `(a,b)` with `a,b ≤ 12`, in the one-factor and two-factor forms and for `e = 1,2,3` (`results/chk4_newton_fan_severing.txt`). ✔ |
| 6 | `Φ` is the chain `E_{v_1}, …, E_{v_s}` over the interior rays ordered by slope, with `D̃_i ∩ Φ` and `D̃_j ∩ Φ` the two ends (872–877) | **OK** (standard toric surface geometry; `{u_1=0}` is the `e_1`-divisor and meets the smallest-slope end). ✔ |
| 7 | the subgroup acting trivially on `E_{v_l}`, `v_l = (a_l,b_l)`, is `ker(χ_1^{b_l}χ_2^{-a_l})`, and this is the exact stabilizer off the two nodes (877–880) | **OK.**  `H` acts through the torus, so the stabilizer of a point of `O_τ` is `⋂_{m∈τ^⊥∩M} ker χ^m`; for a primitive ray `v=(a_l,b_l)` the rank-1 lattice `τ^⊥∩M` is generated by `(b_l,-a_l)`.  Recomputed from the definition (intersection over a lattice box), and the generator claim checked, for every configuration in `results/chk3_toric_criterion.txt` — 0 failures. ✔ |
| 8 | `H_v = 1` for `v = (a,b)`, so `E_v` is **free off its two nodes**, so `Φ ∩ W_nt` is severed and the two ends lie in different components (880–886) | **OK**, with one step the tex leaves implicit: a point `w ∈ π^{-1}(x)` has `G_w ⊆ G_x = H`, so "trivial stabilizer **in `H`**" really is `w ∉ W_nt`.  The nodes remain in `W_nt` because maximal cones have `σ^⊥ = 0`, `H_σ = H ≠ 1`. ✔ |
| 9 | this holds for every general `x`, hence no dense open `U` as in Def. 3.2 exists (885–886) | **OK** — two dense opens meet. ✔ |

**Decisive quotation** (tex 880–884):

> One of the $v_l$ is our $v = (a,b)$, for which this group is trivial; so the
> points of $E_{v}$ other than its two nodes do not lie in $W_{nt}$, and
> $\Phi \cap W_{nt}$ is disconnected by the removal of $E_v$.

**Machine replay of the whole severing:** for all **940** configurations
`(H = Z/m, χ_1, χ_2)` with `m ≤ 40` satisfying (T)'s conventions, the ray
produced by `lem:number_theory` is a ray of the computed fan, `E_v` is free, and
the two ends of the chain are in different components — 0 failures.  The
contrast predicted by `rem:toric_criterion`(a) is confirmed on **6366**
non-cyclic configurations: every wall survives and the chain stays connected.
The tex's own `Z/6` instance reproduces
(`results/chk4_newton_fan_severing.txt`, "worked instance").

### 2.5 Conventions cross-check

Both worked examples of the tex were recomputed independently
(`results/chk3_toric_criterion.txt`): `ex:not_a_complex` (3.13,
`G = Z/6 × Z/2` on `P³`) gives `G_{D_0} = 1`, `G_{D_1} ≅ Z/3`,
`G_{D_2} ≅ Z/2`, `G_{D_3} ≅ Z/2`, `G_{D_{12}} ≅ Z/6`, `G_{D_{123}} ≅ Z/2 × Z/6`;
`ex:no_converse` (4.8) gives `G_{D_1} ≅ Z/3`, `G_{D_2} ≅ Z/2`, `G_{D_3} ≅ Z/6`,
`G_{D_{12}} ≅ Z/6`, `G_{D_{13}} ≅ Z/3 × Z/6`, `G_{D_{23}} ≅ Z/2 × Z/6`.
**All match the tex.**  This is a check on our reading of the conventions as
much as on the paper.

### 2.6 Verdict

**`thm:pairs` (4.1): REVIEWED-SOUND.**  The two directions are independent and
each rests on one crisp fact: *a non-cyclic abelian group has no faithful
character* (⟸), and *for cyclic `H` there is a coprime weighted blowup whose
exceptional curve `H` acts on faithfully* (⟹).  Both were re-derived and
machine-checked here.

---

## 3. `prop:rcc_total` (4.11) — the total-RCC theorem

**Statement as used:** `|I| = 2`, `D_I` **rational** (and `D_I` **fabulous**, see
§4(A)); `f : X ⇢ Y` equivariant, `Y` proper; `p : Z_I → D_I`, `q : Z_I → Y`,
`T_I = q(Z_I)` from `thm:fabulous` 3.8.  Let `Z_I^†` be the union of the
components of `Z_I` **dominating** `D_I` and `T_I^† := q(Z_I^†)`.  Then `T_I^†`
is a closed subvariety of `Y_nt` containing every `F_σ`, and **`T_I^†` is
rationally chain connected**.

| # | step (tex line) | check |
|---|---|---|
| 1 | `T_I^† ⊆ Y_nt` closed (1071–1072) | **OK.** `Z_I^†` is closed in `Z_I`, proper over the projective `D_I`; `q(Z_I^†)` closed in the separated `Y`; `⊆ Y_nt` by 3.8(a). ✔ |
| 2 | `A_σ ⊆ Z_I^†`, hence `F_σ ⊆ T_I^†` (1072–1075) | **OK.**  `A_σ ∩ π^{-1}(x) ⊆ p^{-1}(x)` for `x ∈ U_0` (this is 3.8(c)'s inclusion), `A_σ` dominates `D_I` so those slices are dense in `A_σ`, and `Z_I` is closed; `A_σ` irreducible and dominating ⟹ it lies in a dominating component. ✔ |
| 3 | reduce to `Z_I^†` (1075–1077) | **OK**, images of RCC are RCC. ✔ |
| 4 | for general `x`, `p^{-1}(x)` is a connected component of `π^{-1}(x) ∩ W_nt`, hence a point or a **tree** of smooth rational curves (1079–1082) | **OK**, this is where `|I| = 2` and `lem:tree` are used, and where `W` smooth (from 3.8's resolution of indeterminacy) is needed. ✔ |
| 5 | if the general fibre is a point, `p|_{Z_I^†}` is birational onto the rational `D_I` (1082–1084) | **OK** — then only one component can dominate, so `Z_I^†` is irreducible and rational; a proper rational variety is RCC (via step 10's closedness). ✔ |
| 6 | choose an irreducible rational curve `C ⊆ D_I` through two general `b_1, b_2` **meeting the good open set** (1088–1092) | **OK**, with one wording caveat (§4(C)): the line through two points is unique, so "general" refers to `b_1,b_2`; since they are general, `C` is the image of a general line and meets any prescribed dense open.  Correctly *arranged*, and it is exactly what step 7 needs. ✔ |
| 7 | the geometric generic fibre of `Z_C := Z_I^† ×_{D_I} P¹ → P¹` is a tree of smooth rational curves (1097–1098) | **OK** *because* of step 6: `C` meets the good open set `U_1`, so the generic point of `C` lies in `U_1`, and by spreading out the geometric generic fibre of `Z_C → P¹` has the shape of the general closed fibre.  Without the "meeting" clause of step 6 this would be a gap; the tex puts it in. ✔ |
| 8 | Galois acts on the dual tree through a finite quotient; a finite group on a finite tree fixes a **vertex or an edge** [SerreTrees] (1098–1100) | **OK.** Serre's lemma in the form "a finite group acting on a tree fixes a vertex or inverts an edge". ✔ |
| 9 | edge case ⟹ the node is a Galois-stable `K̄`-point ⟹ a `K`-point (1100–1103) | **OK**, and correct even when the edge is *inverted*: the two components are swapped, but their unique intersection point is fixed, and in char 0 `X(K̄)^{Gal} = X(K)`. ✔ |
| 10 | vertex case ⟹ a Severi–Brauer curve over `K = C(P¹)`; **Tsen** ⟹ `Br(K) = 0` ⟹ a `K`-point (1102–1106) | **OK.**  The fixed vertex's component is Galois-stable hence defined over `K` (char 0, so reduction commutes with base change), a genus-0 form of `P¹`, i.e. a conic; `K` is `C_1`. ✔ |
| 11 | a `K`-point ⟹ a rational section ⟹ (valuative criterion, `P¹` regular) a morphism `P¹ → Z_C`, whose image `Σ ⊆ Z_I^†` is a rational curve meeting `p^{-1}(b_1)` and `p^{-1}(b_2)` (1106–1110) | **OK.** `Σ` is a curve, not a point, because `p∘s = ν` is non-constant; `b_k ∈ ν(P¹)`. ✔ |
| 12 | join `z_1 → Σ → z_2` through the trees `p^{-1}(b_k)` (1112–1115) | **OK.** ✔ |
| 13 | two general points RCC + closedness of RC-equivalence on a proper variety ⟹ all closed points [KollarRationalCurves] (1115–1118) | **OK** over `C` (uncountable, char 0).  Note this also *supplies* connectedness of `Z_I^†`: the construction joins general points of any two dominating components. ✔ |

**Decisive quotations** (tex 1097–1106):

> The geometric generic fibre of $Z_C \to \mathbb{P}^1$ is a tree of smooth
> rational curves, and $\mathrm{Gal}(\overline{K}/K)$ acts on its dual tree
> through a finite quotient.  A finite group acting on a finite tree fixes a
> vertex or an edge \cite{SerreTrees}.  In the second case the corresponding
> node is a $\overline{K}$-point stable under the Galois action, hence a
> $K$-point of $Z_C$.  In the first case the corresponding component is a
> geometrically integral curve over $K$ which becomes $\mathbb{P}^1$ over
> $\overline{K}$, that is, a Severi–Brauer curve; as $K$ is the function field
> of a curve over $\mathbb{C}$, Tsen's theorem gives $\mathrm{Br}(K) = 0$ and
> again a $K$-point.

**Verdict: `prop:rcc_total` (4.11): REVIEWED-SOUND.**

The `thm:fabulous` (3.8) machinery `prop:rcc_total` sits on was audited in the
same pass, since 4.11 uses not only its statement but the objects built in its
proof (`N`, the Stein factorization `N → S → D_I`, the component `S_0`, the open
`U_0`, and the inclusion `A_σ ∩ π^{-1}(x) ⊆ p^{-1}(x)`).  No defect found:
surjectivity of `N → D_I` comes from 3.1(b)(c), `ν(B)` has a unique dominating
component because it is bijective over `U`, `h|_{S_0}` is finite birational onto
the smooth (hence normal) `D_I`, `Z_I = ν^{-1}(S_0)` is connected because `ν` is
proper surjective with connected fibres, and 3.8(c) uses that the distinguished
component contains `D̃_{i_0}` and `D̃_{i_1}` **simultaneously** — which is why
Definition 3.2 quantifies over all `i ∈ I` at once.

---

## 4. Hygiene items and usage conditions (none is a gap)

**(A) `prop:rcc_total` does not restate "`D_I` is fabulous".**  Its statement
says "let `p, q, T_I` be as in Theorem 3.8", and those objects exist only under
fabulousness; the proof uses "`p^{-1}(x)` is a connected component of
`π^{-1}(x) ∩ W_nt`", which is 3.8(b) + its proof.  So fabulousness is an
inherited hypothesis.  `cor:pn_resolved` 4.16 supplies it correctly (via
`thm:pairs`), and so does `DUNCAN_CORNER_F2`.  *Anyone citing 4.11 directly must
supply it.*

**(B) `prop:rcc_total` does not treat `dim D_I = 0`.**  With `D_I` a point there
is no "general line" (step 6).  The conclusion is immediate in that case —
`Z_I^† = p^{-1}(pt)` is itself a tree of rational curves, hence RCC — so this is
a writing gap of one sentence, not a mathematical one.  Irrelevant for
`X = P^N` with `|I| = 2` and `N ≥ 3`, which is the case in use.

**(C) Wording, `prop:rcc_total` step 6.**  "take the image of a general line
through two general preimages": the line through two points is unique; the
genericity is in `b_1, b_2`.  The argument is correct as intended.

**(D) Wording, `prop:noncyclic_fabulous`.**  "let `Φ = B_1 ∪ … ∪ B_N` be its
irreducible components, a tree of smooth rational curves by `lem:tree`" — 4.2
gives the tree structure for `Φ_red`.  Only the support is used.

**Usage conditions the dependent packets must satisfy** (checked as conditions,
not verified here for the packets themselves):

1. **`G_{D_i} ≠ 1` for *both* divisors of a corner.**  If either divisor of the
   pair has trivial generic stabilizer, `D̃_i ⊄ W_nt` and `thm:pairs` simply does
   not apply — the standing convention at tex 240–243 discards such components
   from the list, which changes which `I` are even considered.
2. **The conclusion is about `T_I^†`, not `T_I`.**  `prop:rcc_total` asserts RCC
   for the image of the *dominating* components only.  Any downstream use of
   "the receiver is a connected union of rational curves in `Y_nt`" must use
   `T_I^†` (or `cor:union_of_rc` 4.12, which is stated for `T_I^†`).
3. **On a resolution of `P^N`, rationality of `D_I` needs a
   stabilizer-stratified tower.**  `lem:linear_strata` 4.10 applies only when
   `P^N` is *itself* in toroidal form.  After a resolution, rationality of the
   strata comes from `lem:rational_strata_propagate` 4.15, whose hypothesis is
   `def:stratified_tower` 4.14 (every centre a union of components of
   `X_k^H ∩ D_J^{(k)}`); the packaged statement is `cor:pn_resolved` 4.16.
   `STANDARD_FORM_PW`'s tower (blow up every stratum of the level-0 stabilizer
   stratification in order of increasing dimension) is of that shape, and
   `DUNCAN_CORNER_F2`'s extra blowup of `M_τ^V ⊆ E_V` is a fixed-locus-inside-a-
   stratum centre, i.e. also of that shape — but the packets should cite 4.14–4.16
   explicitly rather than 4.11 alone.

**External inputs used but not proved in the tex** (all standard, char 0):
equivariant resolution of singularities and of indeterminacy
[ReichsteinYoussin]; Zariski's main theorem; rational singularities of a smooth
variety + the theorem on formal functions [Hartshorne III.11.1]; finite abelian
subgroups of `PGL_2` fixing a point lie in a torus; normalised blowup of a
monomial ideal = toric variety of the normal fan of its Newton polyhedron
[Fulton]; Serre's tree fixed-point lemma [SerreTrees]; Tsen's theorem; closedness
of RC-equivalence classes on a proper variety [KollarRationalCurves].  Note that
**`thm:pairs` and `prop:rcc_total` do not themselves use Bergh–Rydh** — that
enters only through `thm:toroidal_resolution` 2.2, i.e. through the *hypothesis*
that `X` is in toroidal form.

---

## 5. Machine checks

All scripts are `python3`, no external dependencies, deterministic; run from the
packet root.  Outputs in `results/`.

| script | what it checks | scale | result |
|---|---|---|---|
| `chk0_tex_numbering.py` | recomputes the tex's shared-counter numbering and cross-checks it against every number used in this repo (§6) | 31 labels | **PASS** (0 mismatches) |
| `chk1_no_faithful_character.py` | "non-cyclic abelian ⟹ no injective character" — the single fact carrying `prop:noncyclic_fabulous` | 322 abelian groups, order ≤ 100, ≤ 3 factors | **PASS** (0 failures) |
| `chk2_number_theory_lemma.py` | the construction of `lem:number_theory` 4.4, both conclusions; plus an independent existence search; plus "cyclic `H` of prime order is impossible under (T)" | 483 672 triples `(m,c_1,c_2)`, `m ≤ 120` | **PASS** (0 failures) |
| `chk3_toric_criterion.py` | `H_τ = ⋂_{m∈τ^⊥∩M} ker χ^m` recomputed from the definition vs the closed form `ker(χ_1^{b}χ_2^{-a})`; the rank-1 generator claim; `H_σ = H` for maximal cones; `rem:toric_criterion`(a),(b); the two projective examples 3.13 and 4.8 | 81 groups, 8302 `(χ_1,χ_2)` configurations | **PASS** (0 failures; both examples match the tex) |
| `chk4_newton_fan_severing.py` | Newton polyhedra and normal fans of `(u_1^b,u_2^a)^e` and its two-factor product computed from scratch; `(a,b)` is a ray; `e` does not change the fan; the chain-severing combinatorics for cyclic `H` and its failure for non-cyclic `H` | 91 `(a,b)` pairs; 940 cyclic and 6366 non-cyclic configurations | **PASS** (0 failures) |

Nothing here proves a theorem; these are spot checks of the finite arithmetic
the two proofs assert in passing, and of our reading of the conventions.

---

## 6. Citation drift (deliverable 2)

**Numbering re-verified from the tex**, not taken from the earlier note
(`scripts/chk0_tex_numbering.py`, full listing in
`results/chk0_tex_numbering.txt`: 31 labels, 0 mismatches).  The tex uses one
shared `[section]` counter for `theorem/lemma/proposition/corollary/definition/
example/remark/…` (preamble lines 17–33), so the numbers are obtained by
counting every such environment per section.  Recomputed:

| label | number | tex line |
|---|---|---|
| `def:toroidal` | 2.1 | 66 |
| `thm:toroidal_resolution` | 2.2 | 92 |
| `cor:cofinal` | 2.3 | 202 |
| `lem:fabulous_basics` | 3.1 | 259 |
| `def:fabulous` | 3.2 | 287 |
| `lem:fabulous_cofinal` | 3.5 | 326 |
| `lem:fibre_dimension` | 3.6 | 352 |
| `lem:flag` | 3.7 | 391 |
| **`thm:fabulous`** | **3.8** | 443 |
| **`prop:rcc`** | **3.9** | 534 |
| **`rem:toric_criterion`** | **3.12** | 613 |
| `ex:not_a_complex` | 3.13 | 642 |
| **`thm:pairs`** | **4.1** | 727 |
| `lem:tree` | 4.2 | 736 |
| `prop:noncyclic_fabulous` | 4.3 | 759 |
| `lem:number_theory` | 4.4 | 814 |
| `prop:cyclic_not_fabulous` | 4.5 | 837 |
| `ex:no_converse` | 4.8 | 936 |
| `prop:converse` | 4.9 | 995 |
| `lem:linear_strata` | 4.10 | 1041 |
| **`prop:rcc_total`** | **4.11** | 1058 |
| `cor:union_of_rc` | 4.12 | 1121 |
| **`def:stratified_tower`** | **4.14** | 1162 |
| **`lem:rational_strata_propagate`** | **4.15** | 1186 |
| **`cor:pn_resolved`** | **4.16** | 1232 |
| `thm:no_map_to_dp2` | 4.18 | 1275 |

**All eight numbers recorded at `NOTEBOOK.md:6459–6467` are confirmed correct.**

Old-draft → current map for the numbers actually used in the three files:

| cited as | means | current |
|---|---|---|
| "Thm 3.10" | the main theorem (fabulous ⟹ connected `T_I ⊆ Y_nt`) | `thm:fabulous` **3.8** |
| "Prop 3.12" | RCC of the fibre for `\|I\| = 2` | `prop:rcc` **3.9** |
| "Prop 3.24" | the total-RCC theorem | `prop:rcc_total` **4.11** |
| "Thm 4.2" | pairs: fabulous ⟺ non-cyclic | `thm:pairs` **4.1** |
| "Def 6.3" | stabilizer-stratified towers | `def:stratified_tower` **4.14** |
| "Lemma 6.4" | rationality propagates along such towers | `lem:rational_strata_propagate` **4.15** |
| "Thm 6.2" | no `S_4`-equivariant `P² ⇢` Fermat dP2 | `thm:no_map_to_dp2` **4.18** |
| "Prop 4.3" | non-cyclic ⟹ fabulous | `prop:noncyclic_fabulous` **4.3** — *accidentally still correct* |

**Banners inserted** (working tree; banner insertions only, nothing else
changed — exact line numbers in the run report):

* `NOTEBOOK.md` — file head (the drifted citations occur in three separate
  places, so a head banner is the only single-point fix).
* `theory/FIX_I_bcomplex.md` — immediately before the Correction I-C block,
  which is the first affected citation.
* `theory/FIX_T_gate.md` — immediately after the `## T2′` heading, which is the
  first affected citation.

Each banner is ≤ 6 lines, maps old-draft numbers to current labels, and ends
with the recommendation to **cite by label**.  No history was rewritten and no
existing citation text was edited.

---

## 7. Pin: the soft input of `V14_MAP_DICHOTOMY` Theorem B (deliverable 3)

**What is being pinned.**  `V14_MAP_DICHOTOMY/REPORT.md:51–63`, step (3) of
Theorem B: *"over `L`, after a splitting `U_{T,L} = L⁶`, the twisted pair
`(^T X, ^T V14)` is an honest Pfaffian–Grassmannian pair, and for a general
`L`-rational hyperplane `Π` in `P(U_{T,L}) = P⁵_L` the classical hyperplane
construction gives a birational `χ_Π : ^T V14_L ⇢ ^T X_L`."*
Source: `external_docs/tschinkel_zhang_stable_equivariant_arxiv2409.08392.pdf`
(Tschinkel–Zhang, *Stable equivariant birationalities of cubic and degree 14
Fano threefolds*, arXiv:2409.08392v1, 12 Sep 2024, 22 pages).

**Naming hazard, first.**  TZ's letters are the **opposite** of the packet's:
in TZ, `Y` = the cubic threefold and `X` = the degree-14 Fano threefold; in the
packet, `X` = the Klein cubic and `V14` = the degree-14 Fano.  TZ's map goes
`Y_f ⇢ Π ∩ P(Q_f) ⇠ X_f`, i.e. cubic ⇢ · ⇠ V14; the packet's `χ_Π` is the
composite read in the other direction.

**(1) The exact statement supplying `χ_Π`** — TZ §3 "Pfaffian–Grassmannian
correspondence", p. 7, equation (3.3):

> As explained in [Kuz04, Remark 2.19], fixing a hyperplane `Π ⊂ P(V)`, there
> are induced birational maps
> `(3.3)   ϱ_Π : Y_f ⇢ Π ∩ P(Q_f) ⇠ X_f.`

with the supporting statements on pp. 6–7: `Y_f = P(f(A)) ∩ Gr(2,V)^∨` (a cubic
threefold) and `X_f = P(f(A)^⊥) ∩ Gr(2,V)` (a degree-14 Fano threefold) for an
injective `f : A → ∧²(V^∨)` with `dim A = 5`, `dim V = 6`, *regular* meaning
`rk f(a) ≥ 4` for all non-zero `a`; the diagram (3.2) of vector bundles
`E_f^∨ → Y_f`, `U_f → X_f` with `ψ, φ` to `V` [Kuz04, Thm 2.18];
`ψ(E_f^∨) = φ(U_f) = Q_f`, a quartic hypersurface singular along the affine cone
over a curve `C_f`, with `ψ, φ` isomorphisms on `Q_f \ C̃_f` [Kuz04,
Prop. 2.11, 2.15; Put82, Thm B]; and `θ := φ^{-1}∘ψ` a flop in a ruled surface
[Kuz04, Thm 2.17].

**(2) Genericity.**  TZ attaches **no genericity hypothesis to `Π`** — (3.3) is
stated for "fixing a hyperplane `Π ⊂ P(V)`".  Genericity in TZ attaches instead
to the **net** `f` ("which are smooth for generic `f`", p. 6) and to the
regularity condition.  So the packet's "for a general `L`-rational hyperplane"
is *more* conservative than the source, and it is safe over `L`: `L` has
characteristic 0, hence is infinite, so `L`-rational hyperplanes are Zariski
dense in `(P⁵_L)^∨` and a general one can be chosen over `L`.

**(3) THE BASE FIELD — this is the item to record.**  TZ's standing convention,
p. 1, verbatim:

> In this paper, we work over an algebraically closed field `k` of
> characteristic zero and focus on equivariant birationalities.

There is no other field convention in the paper, and §3 opens "Let `A` and `V`
be vector spaces over `k` of dimension 5, respectively, 6" — i.e. §3 inherits
*algebraically closed*.  **The packet applies the construction over `L`, a
degree-≤ 2 extension of `F = C(V14)^G`, which is not algebraically closed.  That
is a use beyond the letter of the cited hypothesis, and it should be recorded as
such rather than read off TZ.**

**(4) Why it nevertheless descends — and this is *not* a complex-analytic
worry.**  Every ingredient of (3.2)/(3.3) is defined by linear algebra over the
base field: the net `f` and the subspaces `f(A)`, `f(A)^⊥`; `Gr(2,V)` and its
projective dual, cut out by the Pfaffian cubic form `Pf ∈ Sym³(∧²(V^∨))`; the
theta bundle `E_f^∨ = {(y,v) ∈ Y_f × V : v ∈ ker(y)}` (a kernel of a linear map,
so defined wherever `f` is); the tautological `U_f`; the projections `ψ, φ`; the
image `Q_f`; the curve `C_f`.  TZ says so explicitly in **Remark 3.1, p. 7**:

> In the literature, the existence of the diagram (3.2) and the birationality of
> `θ` are proved for the projectivizations `P(E_f^∨)`, `P(U_f)` and `P(V)`.
> However, the underlying linear algebra proof applies to the vector bundles
> verbatim.

and it leans on exactly that canonicity to get equivariance (p. 8: "the
corresponding birational maps `ψ, φ` and `θ` in (3.2) are `G̃`-equivariant since
their constructions are canonical").  Canonical/functorial in that sense is also
what makes them commute with field extension and descend.  The side conditions
("regular", "smooth") are geometric, i.e. checkable after base change to `L̄` and
insensitive to it.

**Search result, stated plainly:** the paper contains **no complex-analytic,
Hodge-theoretic, transcendental, monodromy or topological step anywhere in its
own text** — no periods, no intermediate Jacobians as complex tori, no Torelli,
no analytic families.  The only Hodge-flavoured item in the PDF is the *title* of
the cited reference [IM00] ("The Abel–Jacobi map for a cubic threefold and
periods of Fano threefolds of degree 14"), which TZ cites for two purely
algebraic facts: existence of the theta bundle (p. 6, [IM00, Thm 2.2]) and
"a `G`-stable elliptic quintic ⟹ equivariant birationality" (p. 8, [IM00,
Thm 1.1]) — the latter is **not** used by the packet.  **So Theorem B is not
flagged for a complex-analytic step.**

**(5) The real arithmetic caveat, which TZ does record.**  Remark 3.2, p. 8:

> Recall that every smooth cubic threefold over `C` admits a Pfaffian
> representation [AR96], [MT01]; in fact, this holds also for singular cubics
> [Com20].  By [Bea00, Theorem 8.2], a smooth cubic threefold `Y` over a
> nonclosed field `k` is Pfaffian if and only if there is an arithmetically
> Cohen–Macaulay curve `C ⊂ Y`, not contained in a hyperplane, with
> `K_C = O_C`, i.e., an elliptic normal quintic, defined over `k`.

Over a non-closed field, *being Pfaffian is a condition, not automatic.*  The
packet's step (3) does not merely need `χ_Π` to descend; it needs the pair over
`L` to **be** a Pfaffian–Grassmannian pair over `L`, i.e. an `L`-rational
regular net `f : A_L → ∧²(U_{T,L}^∨)` with `^T V14_L = Gr(2,U_{T,L}) ∩ P(f(A)^⊥)`
and `^T X_L = Gr(2,U_{T,L})^∨ ∩ P(f(A))`.  The packet asserts this ("after a
splitting `U_{T,L} = L⁶`, the twisted pair … is an honest Pfaffian–Grassmannian
pair"), which is plausible because the net is `G`-derived data carried along by
the twist, but the assertion is where the arithmetic actually lives.
**Recommendation:** `V14_MAP_DICHOTOMY` should state where the `L`-rational net
comes from, and cite Beauville [Bea00, Thm 8.2] (via TZ Remark 3.2) as the
criterion in the background, rather than citing TZ for a non-closed-field
statement TZ does not make.

**(6) The pin cannot be closed inside TZ.**  TZ *cites*, and does not prove, the
map: (3.3) is attributed to [Kuz04, Remark 2.19], and the diagram to [Kuz04,
Thms 2.17, 2.18], building on [Put82] and [IM00].  Kuznetsov, *Derived category
of a cubic threefold and the variety `V_14`*, Tr. Mat. Inst. Steklova **246**
(2004) 183–207, is **not in `external_docs/`**.  Closing the pin — in
particular, confirming whether Kuznetsov states Rem. 2.19 for every `Π` or a
general one, and over which field — requires ingesting it.

**Pin verdict: `TZ-CHI-PI-PIN-PARTIAL`.**  Theorem B is **not** silently passed
and **not** flagged for analyticity.  Two open items, both recorded:
(i) TZ's declared base field is algebraically closed, so the non-closed-field
use is ours, justified by the algebraicity of the construction (TZ Rem. 3.1) but
not by a TZ statement; (ii) the terminal source [Kuz04, Rem. 2.19] is
un-ingested.  Neither is a refutation; both are the difference between "pinned"
and "pinned tight".

---

## 8. What changes for the dependent packets

Nothing falls.  Concretely:

* `DUNCAN_CORNER_F2`: claim A's "fabulous ⟺ `V4`" reading of `thm:pairs`, and
  `(F2)` + Theorem E's use of `prop:rcc_total`, both stand.  Its residual
  uncertainty item 1 ("the two EXTERNAL-UNVERIFIED imports") may be re-graded to
  IMPORT-REVIEWED, subject to the three usage conditions of §4.
* `STAGE1_COMPLEX_MAPS`: `Z⁺`'s three new rows (§7) keep their type-II exclusion
  through `(F2)`; the conditionality label on that exclusion changes from
  EXTERNAL-UNVERIFIED to IMPORT-REVIEWED.  Theorem 4's *unconditional*
  re-derivation on `Z` is untouched either way.
* `V14_MAP_DICHOTOMY` Theorem B: unchanged, with the pin note of §7 attached and
  one recommendation (state the source of the `L`-rational net).
