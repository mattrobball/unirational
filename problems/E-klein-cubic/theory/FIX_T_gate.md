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

If FIX-T34 passes, gate items T3, T4 close and the standing debt item
("OD16/Fermat session theorems never machine-checked") retires — with the
theorems now *stronger* than the sessions': proved via T3.1 from [I], not
via the unwritten sketches.

## T2, T5 (pending)

- **T2** — Problem F re-derivation: ingest `F-dp2-psl27/RESOLUTION.md`'s
  `V₄`-exceptional-path argument, recast as a chain-level unsolvability
  proof in the sense of Remark T1.4. Director work; next.
- **T5** — non-overreach: recast the V4 trisection family
  (`goal_runs_after_f1f0be/.../THEOREM.md`) as a solution of every local
  constraint of `𝒞(P(U), X)` at its stratum, certifying the formalism
  cannot close the Klein case on local data. Rides with T2.
