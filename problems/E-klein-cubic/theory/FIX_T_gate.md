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

## T5 (pending)

- **T5** — non-overreach: recast the V4 trisection family
  (`goal_runs_after_f1f0be/.../THEOREM.md`) as a solution of every local
  constraint of `𝒞(P(U), X)` at its stratum — in particular of the T2-style
  chain constraints exported above — certifying the formalism cannot close
  the Klein case on local data. Director work; next.
