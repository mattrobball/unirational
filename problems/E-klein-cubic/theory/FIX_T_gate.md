# FIX T — The acceptance gate: instantiations T1, T3/T4 (T2, T5 to follow)

Program FIX ([E56]). Companion to `FIX_I_bcomplex.md` (cited as [I]).
Status discipline as in [I]: DRAFT-FOR-DERIVATION; nothing here is
headline-consumable until the full T1–T5 gate closes.

## T1. The dimension-2 instantiation (chains to chains)

Throughout: `G`-surfaces `S, S'` (smooth projective, char 0, `k = k̄`),
`f: S ⇢ S'` equivariant dominant. Write `g` for a nontrivial element,
`H = ⟨g⟩`.

**Classical inputs (dim 2 only).** (i) Indeterminacy of a rational map of
smooth projective surfaces is resolved by finitely many point blowups; done
equivariantly, the centers are `G`-orbits of points, so the resolved graph
`S̃ → S` of [I, Obs 4.0] is a *composition of orbit blowups*. (ii) The
pointwise stabilizer of a curve on a smooth surface is **cyclic** (it acts
faithfully on the 1-dimensional normal space). So the 1-dimensional part of
`𝔽(S̃)` is: fixed curves `C` with cyclic isotropy and a single normal
character `χ_C ≠ triv`; the 0-dimensional part: fixed points with a
2-dimensional normal representation (weights `(χ₁, χ₂)`).

**Definition T1.1 (g-chains).** For `g ∈ G`, a **g-chain** of `S̃` is a
connected component of `S̃^g` together with its induced decorations: the
1-dimensional members (fixed curves), the linking and terminal `g`-fixed
points, and at each point the weight pair. (A component that is a single
point is a degenerate chain.) By [I, Thm 2.1] (sanity check 2.2), one orbit
blowup transforms chains by the two local moves: at a fixed point of
distinct weights `(χ₁, χ₂)`, insert nothing 1-dimensional — the exceptional
curve joins the configuration with two new marked fixed points and updated
weights `(χ₁, χ₁⁻¹χ₂)`, `(χ₂⁻¹χ₁, χ₂)` (the chain's *combinatorial* type is
refined, its ends and their invariants transform by the toric rule); at a
scalar point (`χ₁ = χ₂ = χ`) a **new fixed curve** `E` with `χ_E = χ` is
inserted, lengthening the chain. These are the only moves: the calculus of
[I] closes in dimension 2.

**Theorem T1.2 (chains map to chains).** Let `f: S ⇢ S'` be equivariant
dominant. Then on the resolved graph `S̃` (a finite sequence of `G`-orbit
point blowups of `S`), `f` is an **honest** equivariant morphism
`q̃: S̃ → S'`, and for every `g ∈ G`:

1. `q̃` maps each `g`-chain of `S̃` either **onto a `g`-chain of `S'`** or
   **to a single `g`-fixed point of `S'`**;
2. member-wise: each fixed curve of the chain maps onto a fixed curve of
   the image chain or to a fixed point of it; linking points map to points
   of the image chain; **adjacency is preserved** (images of adjacent
   members are adjacent or equal);
3. rational members obey going-down [I, Lem 4.2]: a rational fixed curve
   cannot dominate a fixed curve of genus ≥ 1; in particular if every
   1-dimensional member of the target chain has genus ≥ 1, every rational
   member of the source chain is contracted;
4. the endpoint decorations transform under the equivariant differential
   [I, Lem 4.5]; under blowup moves on `S̃` the assignment is unchanged
   (composition with the calculus, [I, Prop 3.3]).

*Proof.* Honesty and equivariance of `q̃` are [I, Obs 4.0] plus classical
input (i). For (1)–(2): `q̃(S̃^g) ⊆ S'^g` (equivariance); a connected set
maps to a connected set, hence a chain lands in a single connected component
of `S'^g` — a chain or a point; a curve maps onto a curve or a point;
intersecting members have intersecting images. (3) is [I, Lem 4.2] verbatim
(a rational curve is RCC; RCC images are RCC; an RCC subvariety of a
genus-≥1 curve is a point). (4) is [I, Lem 4.5] and [I, Thm 2.1]. ∎

**Remark T1.3 (this is the collaborator's observation).** T1.2 is precisely
"for surfaces you can blow up and get honest maps mapping chains of
divisors and curves to these same chains" — derived from the general
definitions of [I], with the two blowup moves of T1.1 as the complete
bookkeeping of how chains change under further modification, and with (3)
and (4) as the two decorations (birational type; weights) that the dP-style
arguments consume. Gate item T1: **passed at the level of this derivation**;
flagged for collaborator review as specified.

**Remark T1.4 (where the dP engine sits).** An obstruction proof in dim 2 is
an unsolvability argument for the constraint system [I, Cor 5.1] on chains:
one propagates forced values (weights, parities, endpoint data) along a
chain using (2) and (4), and derives a contradiction with (3) or with the
target's chain inventory. Problem F's `V₄`-exceptional-path proof has
exactly this shape and is gate item T2 (pending; requires ingesting the
F-side resolution, then re-deriving inside this calculus).

## T3/T4. The central-obstruction corollary, and the two claimed cases

PSL(2,7) (Problem F) has trivial center; but the two session-claimed
closures (OD16 on the Fermat-quartic dP2; `C9⋊C3` on the Fermat cubic
threefold) both hinge on a **central** element. In the formalism they are
instances of:

**Corollary T3.1 (central obstruction).** Let `G` act faithfully on smooth
projective `Y`, and suppose there exists `z ∈ Z(G)`, `z ≠ 1`, with:

- (a) every component of `Y^z` of positive dimension has genus ≥ 1 /
  contains no rational curve (for us: `Y^z` = one genus-1 curve ⊔ finitely
  many points);
- (b) `Y^G = ∅`.

Then there is **no** equivariant dominant rational map `U ⇢ Y` from any
rationally connected `G`-variety `U` on which some model has a `z`-fixed
RCC stratum that is `G`-stable — in particular from `U = P(V)` with any
faithful linear `G`-action (equivalently: the `Y`-action is not
`G`-unirational from linear sources, hence not weakly versal).

*Proof.* Let `U = P(V)`. Since `z` is central, each `z`-eigenspace
projectivization `P(V_χ)` is `G`-stable, and at least one is nonempty; it
is a linear, hence RCC, stratum of `𝔽(U)` for `H = ⟨z⟩`. By [I, Lem 4.3]
every stratum over it on every model stays RCC and `G`-stable up to the
`G`-action on components; choose a `G`-stable one `F` (an orbit of
components has `G`-stable union; connectivity of the image argument below
only needs `G`-stability of the union). On the resolved graph,
`q̃(F) ⊆ Y^z` is an RCC, `G`-stable closed subvariety. By (a) and
[I, Lem 4.2], each irreducible component of `q̃(F)` is a **point**; the
image is a finite `G`-stable set of points, each lying in `Y^z`. If `F` is
connected the image is a single `G`-fixed point, contradicting (b). In
general: take `F` the stratum containing the image of one fixed connected
`P(V_χ)` — connected — so its image is one point, `G`-fixed since `P(V_χ)`
is `G`-stable. Contradiction with (b). ∎

The corollary upgrades the sessions' fixed-hyperplane sketches to a proved
statement resting only on [I]. What remains — and all that remains — to
re-derive T3 and T4 is the **finite verification of hypotheses (a), (b)**
for the actual groups and equations, which the sessions asserted but never
machine-checked (standing verification-debt item). Dispatched as packet
**FIX-T34** with the following pinned candidate instantiations (worker
verifies, adjusts, or refutes):

- **T3 (OD16 / dP2).** `S: w² = x₁⁴ + x₂⁴ + x₃⁴` (degree-2 del Pezzo,
  double cover of `P²` branched over the Fermat quartic;
  `Aut(S) ≅ μ₂ × (μ₄² ⋊ S₃)`, order 192). Identify the order-16 subgroups
  `G` ("OD16", Type-II per the sessions) with a central `z` such that
  `S^z` = genus-1 curve ⊔ points and `S^G = ∅`; expected `z`: a
  non-deck central involution whose fixed curve is the genus-1
  `w = 0`-section-type curve — worker determines the exact conjugacy
  classes for which (a)+(b) hold and certifies at least one class matching
  the sessions' "Type-II" description.
- **T4 (`C9⋊C3` / Fermat cubic threefold).** `X: x₁³ + ⋯ + x₅³ = 0 ⊂ P⁴`.
  Candidate: `G = ⟨a, b⟩ ≅ C9 ⋊ C3` of order 27 and exponent 9 inside
  `Aut(X)`, with `z = a³` central of order 3 acting as
  `diag(1,1,1,ζ₃,ζ₃²)`-type, so `Fix(z, P⁴) = P² ⊔ {pt} ⊔ {pt}` and
  `X^z = {x₁³+x₂³+x₃³ = 0} ⊂ P²` — the genus-1 Fermat plane cubic — with
  the two isolated eigenpoints off `X`; and `X^G = ∅`. Worker: realize
  `C9⋊C3` explicitly in `Aut(X)` (order-9 element = coordinate 3-cycle
  composed with scalars; verify exponent 9 and centrality of `a³`),
  verify (a) exactly, verify (b) by the full 27-element scan.

**FIX-T34 verdict (landed and director-replayed 2026-08-04):**
`FIX-T34-CENTRAL-HYPOTHESES-PASS` — gate items **T3 and T4 close**, with the
session claims corrected in substance, not merely verified:

- **T3 verified instantiation** (one of 13 passing classes out of 17
  order-16 classes in `Aut(S)`, `|Aut(S)| = 192` proved): class T3-C05
  (`D₈×C₂`), `z = diag(1,1,−1)`, `S^z` = smooth genus-1 curve
  `{w² = x₁⁴+x₂⁴}` ⊔ 2 points, `S^G = ∅`. Corrections: the deck
  involution's curve has genus **3** (not 1); the "genus-1 central curve"
  property holds in *all 17* classes and selects nothing — `S^G = ∅` is
  the discriminating hypothesis; indeed no automorphism of `S` has a
  rational curve in its fixed locus, so (a) is vacuous here.
- **T4 verified instantiation** (2 of 3 `C₉⋊C₃`-classes pass in
  `Aut(X)`, `|Aut(X)| = 9720` proved): class T4-C01,
  `a: e₁↦e₂, e₂↦e₃, e₃↦ζ₃e₁, e₅↦ζ₃e₅`, `b = diag(1,ζ₃,ζ₃²,1,1)`,
  `z = a³ = diag(ζ₃,ζ₃,ζ₃,1,1)`, `X^z` = genus-1 plane cubic ⊔ 3 points
  (on the fixed *line* `⟨e₄,e₅⟩` — `Fix(z,P⁴) = P²⊔P¹`, never `P²⊔pt⊔pt`),
  `X^G = ∅`. **Correction with teeth: the naive/pinned generator
  `a = diag(ζ,1,1,1,1)∘(x₁x₂x₃)` lies in class T4-C03, where
  `X^G` = 3 points and hypothesis (b) FAILS** — the obstruction does not
  hold for that action. Repair: twist the fifth coordinate.
- **Moral (recorded for all downstream citation):** both obstructions are
  properties of the **conjugacy class of the action**, not of the abstract
  group; citations must name the class. The standing debt item ("OD16 /
  Fermat-cubic session theorems never machine-checked") retires as
  RETIRED-WITH-CORRECTIONS: the results are now corollaries of T3.1 with
  exact, class-named, machine-verified hypotheses — and the sessions'
  displayed descriptions were wrong in three particulars (genus of the
  deck curve; the shape of `Fix(z)`; and, for the natural T4 generator
  choice, the truth of the theorem itself).

## T2. Problem F re-derived in the calculus

Source ingested: `F-dp2-psl27/certificates/WP3_ALL_DEGREE_PATH_OBSTRUCTION.md`
(+ the odd-degree structural bound it cites); the source's exact checker
replays clean (`WP3_ALL_DEGREE_PATH_OBSTRUCTION_OK`, director-replayed
2026-08-04). Setting: `G = PSL(2,7)`, `V` the 3-dimensional representation,
`S → P(V)` the anticanonical double cover branched over the Klein quartic
(the degree-2 del Pezzo), and — their generic-torsor reduction, the
E16-analogue — `G`-unirationality ⟺ an equivariant dominant
`P(V) ⇢ S`, WLOG primitive homogeneous `[p : h]`, `F(p) = h²`, with odd
degree separately excluded.

**The two new general lemmas the argument runs on** (both instances of
[I, Thm 2.1], now stated as calculus lemmas):

**Lemma T2.1 (scalar-birth lemma).** If a `K`-fixed point `x` of a surface
has scalar tangent action for some `k ∈ K` (`χ₁(k) = χ₂(k)`), the
exceptional curve of the blowup at `x` is **pointwise** `k`-fixed, and stays
so on strict transforms. (The `χ₁ = χ₂` case of [I, Thm 2.1(ii)] plus its
strict-transform clause.)

**Lemma T2.2 (`V₄`-chain lemma).** Let `K ≅ V₄` act on a smooth surface
germ fixing a point, and let `X → ⋯ →` (germ) be any finite `K`-equivariant
tower of point blowups. Then every `K`-stable exceptional curve is
pointwise fixed by some involution `t_C ∈ K`; and if two `K`-stable curves
are connected through the exceptional locus, every member of the unique
dual-tree path between them is `K`-stable, hence carries such a `t_C`.
*Proof.* Birth of a `K`-stable curve: final `K`-stability descends through
equivariant blowdowns to the birth exceptional curve and its center `x`
(the contracted image of a stable curve is a stable point). At `x`,
`T_x = χ₁ ⊕ χ₂` for characters of the abelian 2-torsion `K`; the action on
`P(T_x)` factors through `χ₁χ₂⁻¹`, a character to `{±1}` whose kernel
contains a nontrivial involution `t_C` (all of `K` if `χ₁ = χ₂`), which
acts scalarly on `T_x`, hence trivially on the exceptional `P¹` — pointwise
fixation persists on strict transforms (T2.1). Path stability: the dual
graph of the reduced local total transform over a point is a tree (one
edge initially; blowing a smooth point adds a leaf, a node subdivides an
edge), and a tree automorphism fixing both endpoints of a path fixes the
path vertex-wise. ∎

**Theorem T2.3 (Problem F, in the formalism).** No equivariant dominant
`P(V) ⇢ S` exists. *Proof, with each step tagged by the layer it spends:*

1. *(Target funnel data — CAS input, their checker.)* For every involution
   `t` (one class, 21 elements): `S^t` = smooth genus-1 curve
   `π⁻¹P(E₋(t))` ⊔ two points over `[e_t] = P(E₊(t))`. **No rational
   member.** Eigensplit convention here: `dim E₊ = 1, dim E₋ = 2` — the
   fixed *line* of the source is `L_t = P(E₋(t))`, and `S^t`'s curve lies
   over that same line.
2. *(Endpoint value on the source line — decoration layer, first spend.)*
   Even degree `d` plus equivariance gives, for `v ∈ E₋(s)`:
   `s·p(v) = p(sv) = p(−v) = p(v)`, so `p(v) ∈ E₊(s)` — the image of `L_s`
   lies in the **finite** fiber `π⁻¹([e_s])`, hence is a single constant
   `b_s` with `π(b_s) = [e_s]`. This is parity forcing: a constraint on the
   `⟨s⟩`-equivariant structure of the map along the stratum, invisible to
   RCC. (Margin note: the source's display `(h/a_s²)² = F(e_s)` is off by a
   factor of `a_s` as written; immaterial — constancy already follows from
   finiteness of the fiber.)
3. *(Forced basepoints — incidence layer.)* At each of the 21 quadruple
   points `q` of the 21-line arrangement (`Stab_G(q) ≅ D₈`, central
   involution `z`, `q = P(E₊(z))`): four incident lines carry four distinct
   constants `b_s` (distinct `[e_s]`), so no regular extension exists at
   `q` — the incidence structure of the source complex forces `q` into the
   base locus of **every** model on which it would otherwise be regular.
4. *(The calculus inserts a chain end — scalar case.)* `z` has scalar
   differential `−1` at `q` (`T_q = Hom(E₊(z), E₋(z))`, `z = (+1)⁻¹(−1)`),
   so by T2.1 the exceptional `A_q = P(T_q)` is pointwise `z`-fixed on
   every subsequent model.
5. *(Going-down + residual stability.)* `A_q ≅ P¹ → S^z` is constant by
   step 1 (RCC layer); `A_q` is `D₈`-stable, so the constant `a_q` is
   `D₈`-fixed; its projection is a `D₈`-invariant line in `V`, and
   `[D₈, D₈] = {1, z}` with `z = −1` on `E₋(z)` rules out any such line in
   `E₋(z)`: so `π(a_q) = q`. (The same "stability promotes the point" move
   as Cor T3.1, with the local stabilizer replacing the center.)
6. *(The chain closes the trap — T1.2 + T2.2.)* Fix incident `(q, L_s)`,
   `K = ⟨z, s⟩ ≅ V₄`. On the final model the strict transforms of `A_q`
   and `L_s` are joined through the exceptional tree over their meeting
   point; by T2.2 every member of the endpoint path is `K`-stable and
   pointwise fixed by some involution `t_C ∈ K`; by step 1 each `S^{t_C}`
   has no rational member, so **every member of the path maps to a point**
   (going-down member-wise); adjacency propagates equality of the
   constants along the path (T1.2(2)): `a_q = b_s`. But
   `π(a_q) = q ∈ P(E₋(s))` and `π(b_s) = [e_s] ∈ P(E₊(s))` are distinct.
   Contradiction. With the odd-degree theorem, all degrees are excluded. ∎

**Gate verdict T2: PASSED.** The proof is exactly a chain-level
unsolvability argument in the sense of Remark T1.4, and — the calibration
point of the whole exercise — it is the first theorem in this series that
**cannot** be proved from the RCC layer alone: steps 2 (parity/decoration)
and 3 (incidence) are essential, and step 6 needs the member-wise
involution structure of T2.2, not just connectedness. The session
assertion "the repo's PSL(2,7) result is the all-degree
`V₄`-exceptional-path obstruction" is hereby VERIFIED against the source
(retiring the last clause of debt item 15 except T5).

## T2′. The Duncan instance (S4 on the Fermat dP2), closed in the calculus

> **Citation-drift correction (2026-08-11, `DUNCAN_IMPORTS_REVIEW`).** The Duncan
> numbers in §T2′ are from an EARLIER draft; in the current
> `duncan_higher_obstruction_20260805.tex`: "Thm 6.2" = `thm:no_map_to_dp2` 4.18,
> "Thm 4.2" = `thm:pairs` 4.1, "Thm 3.10" = `thm:fabulous` 3.8, "Prop 3.12" =
> `prop:rcc` 3.9. ("Prop 4.3" = `prop:noncyclic_fabulous` 4.3 is still correct.)
> **Cite BY LABEL, not by number.**

Added 2026-08-05, on request, after ingesting
`external_docs/duncan_higher_obstruction_20260805.tex` (their Thm 6.2):
a THIRD sibling of the T2/T3 family — same Fermat-quartic dP2 target as
T3's OD16 claim, group `G = S4` (octahedral, in `SO(3)`), source `P²`.
Machine-checked group facts (scratch, 2026-08-05): `|G| = 24`, 9
involutions, `Stab[1:0:0] ≅ D8` (4 lines through it), `Stab[1:1:0] ≅ V4`
(2 lines), `Stab[1:1:1] ≅ S3`, two distinct Sylow-2s generate `G`,
`Σ|χ|² = 24` (irreducible ⇒ `(P²)^G = ∅ ⇒ S^G = ∅`).

**Theorem T2′.1.** There is no `S4`-equivariant rational map
`P² ⇢ S = {w² = x⁴+y⁴+z⁴}` (dominance not needed).

*Proof in the calculus, step-named.*
1. *(Source complex.)* Strata of `𝔽(P²)`: the 9 involution lines (`C2`),
   3 quadruple points (`D8`, nonabelian), 6 double points (`V4`), 4
   triple points (`S3`), plus cyclic-stabilizer imaginary points
   (severable — Duncan Thm 4.2 = the FIX-B removability boundary; they
   carry no needed constraint).
2. *(Target complex, decorated.)* For each involution `g`:
   `S^g = E_g ⊔ {2 pts}`, `E_g` = the genus-ONE double cover of `ℓ_g`
   branched at the 4 points `ℓ_g ∩ {Fermat}` (transversality checked:
   `x⁴+y⁴ = 0` and `2x⁴+z⁴ = 0` have 4 distinct roots). Decoration
   `δ_bir(E_g) = elliptic`: **the 1-dimensional part of `S_nt` contains
   no rational curve** — the exact OPPOSITE of the Klein target.
   `S^{S4} = ∅` (irreducibility, hypothesis checked in the T34
   discipline — by the generated group, not by assumption).
3. *(Scalar birth, T2.1.)* `v = [1:0:0]` has `G_v = D8` nonabelian with
   `T_v` its faithful 2-dim irrep; `Z(D8) = ⟨s₁⟩` acts on `T_v` by `−1`,
   so blowing up the orbit of `v` births `E_v = P(T_v)` with
   `G_{E_v} = ⟨s₁⟩ = C2` — a NEW divisorial `C2`-stratum invisible on
   `P²`. Crossing `q = E_v ∩ L̃_{z=0}`: `G_q = ⟨s₁,s₃⟩ ≅ V4`, branch
   characters generating `V4^` — a T2.2 chain node.
4. *(Everything contracts — Lem 4.2 + Cor 4.4, dim-2 scope.)* On any
   resolution `W → P²` of any equivariant `f` (surface: point blowups
   only, so every fixed stratum is a point, an exceptional `P¹`, or a
   rational strict transform — Correction I-C is VACUOUS in dim 2), each
   1-dim fixed stratum has rational RCC image inside some
   `S^g = E_g ⊔ pts` ⇒ image is a POINT. By the decorated pushforward
   (Thm 4.1) the image point of a contracted stratum is fixed by the
   stratum's full stabilizer: `q̃(Ẽ_v) = P_E ∈ S^{D8}`
   (`Stab(E_v) = G_v`), `q̃(L̃) = P_L ∈ S^{D8'}` (`Stab(line z=0) =
   C_G(s₃)`, the OTHER Sylow-2).
5. *(V4-chain, T1.2 + T2.2.)* Over the crossing `q`, on any further
   model the endpoint path of the fibre tree from the `Ẽ_v`-trace to the
   `L̃`-trace is member-wise stabilized by involutions of `V4` (`V4` has
   no faithful character — the member-wise involution mechanism, =
   Duncan Prop 4.3 specialized). Pushing forward: a connected chain of
   points/rational curves inside `∪_h(E_h ⊔ pts)`; every rational link
   in an elliptic-or-points target is a point ⇒ the chain is one point ⇒
   `P_E = P_L =: P`.
6. *(Central obstruction, Cor T3.1 pattern.)* `P ∈ S^{D8} ∩ S^{D8'}
   ⊆ S^{⟨D8,D8'⟩} = S^{S4} = ∅` (two distinct Sylow-2s generate `S4`:
   order `> 8`, divisible by 8, and `A4` has no order-8 subgroup;
   machine-checked). Contradiction. ∎

**Localization remark (the CSP view, matching Duncan's closing remark).**
The constraint system restricted to the ORIGINAL arrangement is
satisfiable: the `[1:1:0]`-type `V4`-chains only force
`P_{z=0} = P_{x+y=0} = …` into `S^{D8'}` — nonempty (the two points of
`φ⁻¹([0:0:1])`). The unsatisfiable constraint is exactly the one carried
by the scalar-birth stratum `E_v` — the obstruction is invisible on `P²`
and lives on the exceptional tree, which is T2.3's moral verbatim.

**Gate significance.** T2′ is a fresh instance neither T2 (PSL(2,7),
Klein quartic) nor T3 (order-16 claim, same target) covered verbatim;
the calculus closes it with no new lemmas — every step instantiates
T2.1/T2.2/T1.2/Lem 4.2/Cor 4.4/Cor T3.1. Independent confirmation:
Duncan's Thm 6.2 proves the same statement through fabulousness
(his Thm 4.2 + Thm 3.10 + Prop 3.12); the two proofs are
mechanism-isomorphic, as expected from the [E56] comparison.

**What T2 exports to Klein (recorded for Note III).** The same T2.2 chains
exist over the 165 V4-vertices of the Klein arrangement — but there the
member-wise conclusion is not constancy: `X^{t_C} = E_{t_C} ⊔ L_{t_C}`
*has* a rational member, so propagation yields a **constrained path
map** — each member lands in `E_{t_C} ⊔ L_{t_C}`, elliptic components
receiving only points — rather than a contradiction. The Klein analogue of
parity forcing on `L_σ` (step 2) with the residual `S3`-equivariance is an
open computation for Note II; the Klein analogue of step 3 (four distinct
forced values meeting at a vertex) is precisely the kind of local
consistency the trisection family must — and, by [E33], does — survive,
which is T5's business.

## T5. Non-overreach: the trisection family solves every local constraint

Witness: the exact positive-line-degree family of
`goal_runs_after_f1f0be/V4_SIMULTANEOUS_ODD_NORMALS_20260802/THEOREM.md` §4.
Setting (packet §1, matching FIX-A1 exactly): at a representative
`K ≅ V₄` with `N_G(K) ≅ A₄`, `W|_K = A ⊕ B ⊕ C ⊕ D` with `A = W^K`
2-dimensional — so the "triple line" `T = P(A)` **is** FIX-A1's `ℓ_V` —
the three plus-planes through `T` cut the ideals `(y,z), (x,z), (x,y)`,
and the Klein cubic takes the normal form (1.1) with the two `A₄`-stable
smooth cubic surfaces on the character hyperplanes, smooth iff
`κ_± ∉ {0, −4}`.

The witness family: with `κ = (B³−1)²/B³` and the trisection
`Q_B: w = −XYZ, uᵢ = (cyclic)`, satisfying the landing identity
`κw³ + w(u₀²+u₁²+u₂²) + u₀u₁u₂ = 0` symbolically (packet (4.1)–(4.2));
precomposed diagonally with the coprime, residually-`C₃`-permuted binary
forms `ℓᵢ = s − ωⁱt` on `T` to give
`Q_{B,ℓ} = Q_B(ℓ₀x, ℓ₁y, ℓ₂z)` — a **primitive, projective-character
`A₄`-equivariant simultaneous landing family of line degree six** along
the triple line (packet (4.3)–(4.4)), extended to every odd plane order
`m = 2r+1 ≥ 3` by `(xyz)^{r−1}`-multiplication.

**Claim (T5): `Q_{B,ℓ}` satisfies every local constraint of
`𝒞(P(W), X)` at this stratum — every layer the formalism has fielded to
date.** Layer by layer:

1. *Funnel/RCC (A2):* the family lands in `X` (identity (4.2)) and its
   involution-fixed source strata map into `E_t ⊔ L_t` as required; the
   elliptic components receive only points (e.g. the `t_B`-fixed plane
   maps to the single fixed point `[0:1:0:0]` of its surface), while the
   nonconstant rational images sweep line/trisection loci — legal
   precisely because the `L_t` are rational. The escape is not
   hypothetical: this family *uses* it.
2. *Chain constraints (T2 export):* over the type-I vertices the T2.2
   chains conclude only "each member lands in `E_{t_C} ⊔ L_{t_C}`"; the
   family, being an honest symbolically-verified local map, induces
   consistent chain data — and packet §5 states the exact point: it
   "supplies the missing rational bridges explicitly," so the Problem-F
   endpoint contradiction (`a_q = b_s` vs distinct projections) cannot
   arise — the analogous endpoint values here live on rational receptors
   and need not be constant at all.
3. *Decoration/parity layer:* the packet's own classification is the
   decoration computation at this stratum, and it is exactly calibrated:
   Theorem 2.12 (`m = 1`, exact triple-line order 3) shows the layer is
   nonvacuous at Klein — it kills an entire branch, all line degrees —
   while §4 populates the adjacent branch (order-3 plane / odd `m ≥ 3`,
   line degree 6) with this witness. No decoration constraint the
   formalism currently states excludes it.
4. *Residual equivariance:* `Q_{B,ℓ}` is `A₄`-equivariant by construction
   (the `ℓᵢ` are `C₃`-permuted up to one common scalar) — the constraint
   layer strictly above RCC is satisfied, not vacuously but by design of
   the witness.
5. *No finite constancy propagation:* packet §3: the local state space is
   the reciprocal cover `τ + τ⁻¹ = 2 + (κ₊p³+κ₋q³)/(p³+q³)` — a
   positive-dimensional (genus-2-quotient) family, "not a finite state
   space." In cosheaf language: the stalks of the compatibility cosheaf at
   this stratum have positive-dimensional sections; a Problem-F-style
   finite endpoint bookkeeping cannot even be formulated here.

**Gate verdict T5: PASSED.** The local layer of `𝒞(P(W), X)` at the
representative `V₄`-stratum is solvable, with an explicit, primitive,
residually-equivariant witness. The formalism therefore does not overreach:
it cannot close Problem E on local data — exactly as the boundary
conditions of [I, §5] demanded — and any FIX-side closure must come from
the global layer (Note III's `H⁰` over the whole arrangement) or from
strata the witness does not populate (packet §6: `m = 1` with triple-line
order ≥ 4; odd `m ≥ 3` above `(xyz)^{r−1}(J₃)₆`; changed boundary data;
mechanisms invisible to the plus-plane arrangement).

**Director verification note.** Packet replay: `verify.py` →
`V4_SIMULTANEOUS_ODD_NORMALS_VERIFY_OK` (clean). `verify_kappa_genus2.py`
fails on current sympy 1.14 with an `AssertionError` — diagnosed: the
sealed verifier compares `sp.factor(resultant)` **structurally** against
`64(κ₊−κ₋)³`, and this sympy factors to `−64(κ₋−κ₊)³`; the difference
simplifies to 0 and the identity is independently provable by hand
(`Res(at³+b, ct³+d) = (ad−bc)³`, `ad−bc = 4(κ₊−κ₋)`). The exit
`V4-TRISECTION-GENUS2-QUOTIENT-PASS` is mathematically sound; its
verifier is replay-brittle (structural equality instead of semantic).
Sealed packet left untouched; finding recorded in the notebook.

---

## Gate closed

**T1 ✓ T2 ✓ T3 ✓ T4 ✓ T5 ✓** (2026-08-04). Per the discipline set in [I]:
FIX results are now consumable for headline-facing work. The cleared
program, in order: **Note II** (the jet ladder along strata — must
reproduce the `ord ≥ (3m+1)/2` V4-line bounds and the packet's Theorem
2.12 as instances, and extend the decoration layer past the strata the
T5 witness populates); **Note III** (the compatibility cosheaf on the
verified 55-line arrangement and the global constraint-satisfaction
computation — where a Klein conclusion, positive or negative, would
actually live); **FIX-B** (the Burnside `H⁰`-shadow, cheap first).
