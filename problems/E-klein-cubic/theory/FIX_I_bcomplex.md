# FIX I — The equivariant fixed-locus b-complex and its functoriality

Program FIX ([E56], method family 4). Note I of the series: definitions, the
blowup calculus, functoriality under equivariant dominant rational maps, and
the acceptance-test suite. Notes II (jet decorations / the automaton) and III
(the compatibility cosheaf and global obstructions) build on this one.

Author: director (Fable). Status: DRAFT-FOR-DERIVATION — every statement here
is to be treated as claimed-until-derived-or-checked; the acceptance tests
T1–T5 in §6 are the validation gate. No claim in this note is consumable for
headline routing until the gate passes.

> **Binding correction — 2026-08-09 (`FIX-I-BINDING-CORRECTION-20260809`).**
> The per-blowup character calculation in Theorem 2.1 and graph
> functoriality in Theorem 4.1 remain valid. The every-model conclusion
> formerly attached to Lemma 4.3 and the arbitrary-resolved-graph Klein
> funnel formerly stated as Corollary 5.2 are withdrawn. A legal smooth
> equivariant center can have positive-genus fixed part, and a type-I or
> type-II blowup in dimension three creates an exceptional `P^2` with
> disconnected subgroup-fixed loci and rational bypass lines. The corrected
> scope is stated below and in
> `goal_runs_20260809/FIXED_NETWORK_MAP_CLASSIFICATION/RESOLUTION_CATEGORY.md`.

---

## 0. Conventions

Base field `k` algebraically closed, characteristic 0. `G` a finite group. A
**G-variety** is a smooth projective integral `k`-variety with a regular
faithful `G`-action. Rational maps `f: X ⇢ Y` are `G`-equivariant and
dominant unless stated. For `H ≤ G`, `X^H = {x : hx = x ∀ h ∈ H}`; in
characteristic 0 with `X` smooth, `X^H` is smooth (linearization of the
`H`-action at a fixed point), so its irreducible components are its connected
components and are pairwise disjoint *for fixed `H`*. Characters of `H` are
denoted `χ`; `triv` is the trivial character. `N_{Z/X}` is the normal bundle.

Repo shadows this note is the roof over: the Problem-F path/parity engine
([E14]), Fable's trisection and `I^(m)/I^(m+2)` corrections ([E15]), the
WP-strata transition machine and its inverse limit ([E34]), the V4
simultaneous-normal classification and Theorem 2.12 ([E33]), the session
notions "normalized equivariant graph", "rational-chain going-down",
"transition cosheaf" (external sessions; unverified there, re-derived here).

## 1. The decorated fixed-locus complex of a model

**Definition 1.1.** For a `G`-variety `X`, the **fixed-locus complex**
`𝔽(X)` is the set of pairs `(H, F)` with `H ≤ G` and `F` an irreducible
component of `X^H`, equipped with:

1. **Partial order:** `(H, F) ≤ (H', F')` iff `H ⊇ H'` and `F ⊆ F'`.
   (Deeper isotropy = smaller stratum = lower in the order.)
2. **G-action:** `g·(H, F) = (gHg⁻¹, gF)`, order-preserving.
3. **Decorations:**
   - `δ_dim(H,F) = dim F`;
   - `δ_nr(H,F)` — the **normal type**: the isomorphism class of the fibre of
     `N_{F/X}` at the generic point of `F` as an `H`-representation. This is
     well defined: `H` acts on `N_{F/X}` fibrewise over the `H`-fixed `F`,
     and a representation of a finite group on a vector bundle over a
     connected base has locally constant character. At a general point of `F`
     the trivial character does not occur (`T_x X^H = (T_x X)^H` and `F` is a
     component of `X^H`).
   - `δ_res(H,F)` — the **residual action**: the group
     `W(H,F) = Stab_{N_G(H)}(F)/H` together with its action on `F`.
   - `δ_bir(H,F)` — the `W(H,F)`-equivariant birational class of `F`,
     recorded at least to the coarseness of: the equivariant MRC fibration
     `F ⇢ R(F)` (so in particular whether `F` is rationally chain connected,
     and if `dim F = 1`, the genus and, when relevant, the isomorphism class
     of the curve).

**Remark 1.2 (incidence is encoded by the order).** Components of `X^H` for
*fixed* `H` are disjoint, but strata for different subgroups meet. If
`x ∈ F ∩ F'` with `(H,F), (H',F') ∈ 𝔽(X)`, then `x` is fixed by `⟨H, H'⟩`,
hence lies on a stratum `(H'', F'')` with `(H'',F'') ≤ (H,F)` and
`≤ (H',F')`. So all intersections are witnessed below, and the order poset
(with dimensions) is the incidence combinatorics. The order complex (nerve)
of `𝔽(X)` is the dual-complex avatar; for the Klein cubic target this nerve
*is* the 55-plane / 55-line / point incidence complex already built in the
repo.

## 2. The blowup calculus

This is the engine that makes the structure computable across models.

**Theorem 2.1 (blowup calculus).** Let `Z ⊂ X` be a smooth `G`-stable
center, `π: X' = Bl_Z X → X`, `E = P(N_{Z/X})` the exceptional divisor. Fix
`H ≤ G`. Then the components of `X'^H` are:

**(i) Strict transforms.** For each `(H,F) ∈ 𝔽(X)` with `F ⊄ Z`: the strict
transform `F'` of `F`. Decorations: `δ_dim`, `δ_nr`, `δ_res` unchanged;
`δ_bir(F') = δ_bir(F)` (equivariantly birational).

**(ii) Exceptional strata.** For each component `F_Z` of `Z^H` and each
character `χ ≠ triv` of `H` occurring in the eigen-decomposition
`N_{Z/X}|_{F_Z} = ⊕_χ N^χ` (constant character decomposition along the
connected `F_Z`): the closure `P(N^χ) ⊆ E`, a projective subbundle over
`F_Z` at the generic point. Its decorations:

- `δ_dim = dim F_Z + rk N^χ − 1`;
- `δ_nr`: at a generic point `e = [v]`, `v` a `χ`-eigenvector over
  `z ∈ F_Z`, the tangent character computation from the Euler sequence gives

  ```
  char T_e X' = char T_z Z  ∪  { χ⁻¹μ : μ ∈ char N_z, minus one copy of χ }  ∪  { χ },
  ```

  where the final `χ` is the character of `N_{E/X'}|_e = O_E(−1)_e = ⟨v⟩.
  The fixed part is `T_z F_Z ⊕ Hom(⟨v⟩, N^χ_z/⟨v⟩)`, of dimension
  `dim F_Z + rk N^χ − 1 = δ_dim` — confirming `P(N^χ)` is generically a
  component (its own normal type is the multiset of the *nontrivial*
  characters in the display: the normal type of `F_Z` in `Z`, the twists
  `χ⁻¹μ` for `μ ≠ χ` including `χ⁻¹` from `μ = triv` when `N^triv ≠ 0`,
  and the `χ` from `O(−1)`);
- `δ_bir`: a projectivized-bundle over `F_Z`; in particular **rationally
  chain connected if `F_Z` is**.

**(iii) The trivial character adds nothing new:** `P(N^triv)` is the
exceptional locus of `Bl_{Z^H}(X^H)` inside the strict transform of the
component of `X^H` containing the relevant `F_Z`; it is not a new component.

**(iv)** Order, `G`-action, and residual actions update in the evident way
(the `G`-action permutes the data of (i)–(ii); `W(H, P(N^χ))` is the
stabilizer in `W(H,F_Z)`-covering data of the character `χ`).

*Proof.* Linearize the `H`-action along `Z` (char 0); the fibre statements
are the classical weight computation for a linear `H`-action on the blowup
of a vector space at a linear subspace, via the Euler sequence
`0 → O → p^*N ⊗ O(1) → T_{E/Z} → 0` and
`N_{E/X'} = O_E(−1)`; constancy of characters along connected bases globalizes
the fibre statement. The trivial-character case (iii) is the standard
identification `Bl_{Z^H}(X^H) ⊆ Bl_Z X` of the strict transform for smooth
`Z^H ⊂ X^H`. ∎

**Sanity check 2.2 (dimension 2, the classical picture).** `Z = z` a fixed
point of a cyclic `H`, `N_z` with characters `(χ₁, χ₂)`. If `χ₁ ≠ χ₂`:
`E^H` = two points `[e₁], [e₂]` with normal characters
`{χ₁, χ₁⁻¹χ₂}` and `{χ₂, χ₂⁻¹χ₁}` — the toric weight calculus, chains grow
by one link with two marked endpoints. If `χ₁ = χ₂ = χ`: `P(N^χ) = E` is an
entire new fixed curve with normal character `{χ}`. This is precisely the
surface chain calculus; the collaborator's chains-to-chains picture will be
*derived* from Theorem 2.1 + Theorem 4.1 in test T1, not assumed.

## 3. Models and the b-complex

**Definition 3.1.** `Mod_G(X)` is the category of **G-models**: proper
birational `G`-morphisms `X̃ → X` with `X̃` smooth (nonempty and cofiltered:
functorial resolution of singularities in char 0 is equivariant; fibre
products resolve equivariantly). For `ρ: X̃' → X̃` in `Mod_G(X)` there is a
**pushdown** `ρ_*: 𝔽(X̃') → 𝔽(X̃)`, `(H, F') ↦ (H, F)` where `F` is the
component of `X̃^H` containing `ρ(F')` (well defined: `ρ(F')` is irreducible,
`H`-fixed). It is monotone and `G`-equivariant.

**Definition 3.2.** The **fixed-locus b-complex** is the pro-object
`𝔽_b(X) = { 𝔽(X̃) }_{X̃ ∈ Mod_G(X)}` with the pushdown maps.

**Proposition 3.3 (computability).** Any single model computes `𝔽_b(X)`
relative to the calculus: by equivariant weak factorization (AKMW; the
functorial/toroidal form respects the `G`-action), any two `G`-models are
connected by a zigzag of blowups along smooth `G`-stable centers, and each
step transforms `𝔽` by Theorem 2.1. Consequently any invariant of `𝔽(X̃)`
that is (a) preserved under the moves of Theorem 2.1 in the blowup
direction, and (b) defined compatibly with pushdown, is an invariant of
`𝔽_b(X)`.

**Remark 3.4 (valuative avatar — deferred to Note II).** The inverse limit
of `G`-models is the `G`-equivariant Zariski–Riemann space; `𝔽_b` is its
fixed-locus structure, and the decorations become the `H`-action on graded
and residue data of the corresponding (systems of) valuations. This is the
model-free form in which statements should ultimately be phrased; in this
note everything is model-level, which is where computation happens.

## 4. Functoriality

The central point, and the precise sense in which "blowing up gives honest
maps" persists in higher dimension:

**Observation 4.0 (the graph is a model of the source).** Let `f: X ⇢ Y` be
`G`-equivariant dominant, `Γ ⊆ X × Y` the closure of the graph with its
diagonal `G`-action, and `Γ̃ → Γ` an equivariant resolution. The first
projection `p̃: Γ̃ → X` is proper birational, so `Γ̃ ∈ Mod_G(X)`; the second
projection `q̃: Γ̃ → Y` is an **honest** proper `G`-morphism. So on a cofinal
subsystem of `Mod_G(X)` (everything dominating one `Γ̃`), `f` is honest. No
target-side modification is needed for functoriality *into* `𝔽(Y)`; the
target-side b-structure enters later, in the cosheaf note.

**Theorem 4.1 (pushforward).** An equivariant dominant `f: X ⇢ Y` induces a
canonical monotone `G`-map

```
f_* : 𝔽_b(X) → 𝔽(Y),   (H, F) ↦ (H, the component of Y^H containing q̃(F)),
```

defined on any model dominating a resolved graph, independent of all choices,
and compatible with composition: `(f∘e)_* = f_* ∘ e_*` for equivariant
dominant `e: X' ⇢ X` (in particular for equivariant dominant self-maps —
the degree-256 quartic endomorphism stability axiom holds by construction).

*Proof.* Existence: `q̃(F)` is irreducible and `H`-fixed, hence contained in
a unique component of `Y^H`. Independence: two resolved graphs are dominated
by a third; pushdowns commute with images. Composition: resolve the
composite graph so that all three projections are honest, and use uniqueness
of the containing component. ∎

**Lemma 4.2 (rational-chain going-down).** If `F` is rationally chain
connected then `q̃(F)` is a rationally chain connected subvariety of `Y^H`.
Hence `f_*(H,F)` refines to a well-defined point of the set of RC-classes of
`Y^H`: if the component `f_*(H,F)` of `Y^H` contains no rational curves
(e.g. is a point, an elliptic curve, or any curve of genus ≥ 1), then
`q̃(F)` is a **single point** of it.

*Proof.* Chains of rational curves push forward to chains of rational curves
or points; connecting chains between general points of `F` map to connecting
chains between general points of `q̃(F)`. ∎

This is the session-asserted "going-down principle"; at this level it is a
two-line standard fact. Its power comes from pairing with:

**Lemma 4.3 (RCC propagation along a controlled tower).** In Theorem 2.1,
every exceptional stratum `P(N^χ)` is a projectivized bundle over `F_Z`,
hence RCC whenever `F_Z` is; strict transforms preserve `δ_bir`.
Consequently RCC propagates along a chosen equivariant blowup tower
**provided every fixed component of every center used in that tower is
RCC**. It does not follow that every fixed stratum on every equivariant
model is RCC. A later smooth invariant center may have fixed part of
arbitrary genus; see Correction I-C and the binding correction at the head
of this note.

**Corollary 4.4 (linear sources funnel into the rational part of the
target) — SCOPE-CORRECTED 2026-08-05, see the correction block below.**
Let `X = P(W)` with a linear `G`-action. Every stratum of `𝔽(P(W))` is a
linear subspace `P(W^χ-part)`, hence RCC; by Lemma 4.3 so is every stratum
on every **stabilizer-stratified model** (see below). Therefore, for
**any** equivariant dominant `f: P(W) ⇢ Y`, every `H ≠ 1`, and every
component `F` of the `H`-fixed locus of any stabilizer-stratified model:

```
q̃(F) is a point of Y^H, or an RCC subvariety of a rational-curve-containing
component of Y^H.
```

In particular, all genus-≥ 1 components of all `Y^H` are hit only in
points **by such strata**.

> **Correction I-C (director, 2026-08-05; prompted by A. Duncan's notes
> "Obstructions to equivariant rational maps",
> `external_docs/duncan_higher_obstruction_20260805.tex`).** Lemma 4.3's
> boxed consequence — and hence the original "every model" quantifier of
> Cor 4.4 and Cor 5.2 — is FALSE for arbitrary equivariant models. The
> per-blowup statement of Lemma 4.3 is correct as written (`P(N^χ)` is a
> bundle over `F_Z`, RCC **whenever `F_Z` is**), but the induction only
> closes when each center's fixed part `F_Z` is itself RCC — automatic
> when centers are (unions of components of) strata of the running model
> (**stabilizer-stratified towers**, = Duncan Def. 6.3, whose Lemma 6.4
> is the same propagation), and false in general. Two counterexamples:
> (i) Duncan's (remark after his Prop. 3.12): an involution with isolated
> `(−1,−1,−1)` point; blow up the point, then a smooth plane quartic in
> the exceptional `P²` — a genus-3 fixed component appears in one fibre.
> (ii) In-house, sharper: on `P(W)` itself blow up the `G`-orbit of a
> generic quartic curve `C ⊂ P_σ` (55 disjoint smooth quartics, a legal
> smooth `G`-stable center); over `C` the exceptional `P(N)` has σ-fixed
> part `{point} ⊔ P¹` fibrewise, whose point-part is a **section
> isomorphic to `C`** — a genus-3 stratum of `𝔽_b(P(W))` on a legitimate
> model. Consequences audited 2026-08-05: Thm 2.1, Thm 4.1, Lem 4.2,
> the per-blowup half of Lem 4.3, the gate T1–T5, FIX-H0/N2/H1 (all
> jet-theoretic, resolution-free) are untouched; Cor 4.4 holds on the
> stabilizer-stratified towers used in T1/T2 (these towers are **not** a
> cofinal class of arbitrary equivariant models); the former Cor 5.2 is
> withdrawn for actual graph resolutions; Note III §1's
> site justification is re-based on H0-2 (see the correction there). The
> fibre-based repair for arbitrary models is exactly Duncan's machinery
> (his Thm 3.10 + Prop 3.24 need no stratum-global RCC — only tree fibres
> over codim-2 strata, fabulousness, and rationality of the base stratum
> on one good resolution); import registered in the notebook.

**First-order decoration constraint (the door to Note II).**

**Lemma 4.5.** Let `γ` be a generic point of a stratum `(H,F)` on a resolved
graph, `y = q̃(γ)`. The differential `dq̃_γ: T_γΓ̃ → T_yY` is `H`-equivariant;
hence for every character `χ`,

```
mult_χ( im dq̃_γ ) ≤ min( mult_χ T_γΓ̃ , mult_χ T_yY ),
```

and if `q̃` is dominant then at a general point of `Γ̃` (the `H = 1` stratum)
`dq̃` is surjective. Along deeper strata the full statement is the
`H`-equivariant jet ladder of `q̃` along `F`; its systematic development —
which reproduces the repo's V4-line order bounds `ord_R(p) ≥ (3m+1)/2` and
Fable's `I^(m)/I^(m+2)` correction computations as special cases — is
Note II ("the automaton").

## 5. The obstruction principle, and what it must respect

**Corollary 5.1 (obstruction principle).** Every equivariant dominant
`f: X ⇢ Y` solves the constraint system `𝒞(X,Y)`: a monotone `G`-map
`𝔽_b(X) → 𝔽(Y)` satisfying (A1) equivariance and order-compatibility,
(A2) going-down (Lemma 4.2) at the level of RC-classes, (A3) the jet
constraints of Note II at every stratum, closed under (A4) precomposition by
equivariant dominant self-maps of `X` and postcomposition rules under
`G`-Sarkisov modifications of `Y`. If `𝒞(X,Y)` is unsolvable, no `f`
exists — and by the E16/E37 reduction, for `X = P(W)`, `Y` = the Klein
cubic, unsolvability is the negative headline.

**Boundary conditions the theory is already known to satisfy (repo ground
truth):**

1. **The escape is real (no cheap Klein contradiction).** For an involution
   `σ`, `X^σ = E_t ⊔ L_t` is a plane cubic and a line. RCC strata on a
   chosen stabilizer-stratified source tower map only to points of `E_t`,
   while line-valued images are permitted. This does **not** funnel the
   fixed strata of an arbitrary resolved graph away from `E_t`: legal
   centers can create positive-genus fixed carriers, and the actual landing
   ideal can create exceptional horizontal carriers over the forced
   plus-plane base. Any Klein obstruction must therefore classify those
   carriers and their global compatibility, not invoke local RCC for the
   entire b-complex.
2. **The V4 trisection counterexample bounds the method.** The computed
   family behind `V4-LOCAL-PATH-HEADLINE-ROUTE-REFUTED` ([E33]) solves every
   purely local path-style constraint; any draft obstruction theorem must be
   tested against it (T5 below) — if the draft "proves" nonexistence from
   local data alone, the draft is wrong.
3. **Endomorphism stability is built in** (Theorem 4.1's composition), so
   degree-scaling escapes of the `4ⁿd` kind cannot restore any finite-degree
   argument.

**Withdrawn Corollary 5.2 (arbitrary-model Klein funnel).** The former
statement quantified over every fixed stratum of every model and is false.
The exact replacement is conditional:

> On a specified stabilizer-stratified tower whose center-fixed components
> are RCC, each RCC fixed stratum maps to a point of an elliptic target
> component or to an RCC subvariety of a rational target component.

This conditional statement does not classify the fixed components of an
actual principalization of a landing base ideal and supplies no finite
fixed-network theorem. In dimension three the first blowup of a `V4` type-I
or type-II point has exceptional `P^2`; its involution-fixed lines can map
to the rational target lines, its `V4` fixed locus is disconnected, and it
contains rational curves with faithful `V4` action. The missing replacement
is a refinement-invariant normalized-Rees carrier theorem.

## 6. Acceptance tests (the validation gate)

- **T1 (surfaces — must be *derived*).** For `G`-surfaces, prove from §§2–4
  alone: on a suitable model every equivariant rational map is honest;
  `𝔽` is the classical chain complex (fixed curves + fixed points with
  weight pairs, exceptional trees as chains with endpoint data); `f_*` maps
  chains to chains. This must *reproduce, unprompted*, the collaborator's
  observation. Deliverable: a precise statement + proof, flagged for
  collaborator review.
- **T2 (Problem F dP).** Re-derive the `V₄`-exceptional-path obstruction
  proof of Problem F inside the formalism (parity/endpoint argument =
  unsolvability of `𝒞` on the chain complex).
- **T3 (OD16 dP2) and T4 (Fermat cubic, `C9⋊C3`).** Derive the two
  session-claimed closures inside the formalism — this simultaneously
  retires their standing verification debt (never machine- or
  hand-checked in-repo).
- **T5 (Klein non-overreach).** Exhibit the trisection family as a solution
  of every local constraint in `𝒞(P(U), X)` at its stratum — certifying the
  formalism does not prove false theorems, and localizing exactly which
  global constraint the family does or does not satisfy.

## 7. Comparison: equivariant Burnside groups (Kontsevich–Pestun–Tschinkel,
Kresch–Tschinkel)

Same substrate (strata, residual actions, normal weights) and the same
blowup calculus — used oppositely: `Burn_n(G)` linearizes and **quotients by
the calculus** (symbols modulo conjugation/vanishing/blowup relations),
producing a `G`-birational-type invariant computable on one model; `𝔽_b`
**keeps the calculus as structure**. Canonical relationship: the symbol sum
gives a map from the complex coequalizing the calculus — Burn is the
universal linearized calculus-invariant receiving `𝔽_b`; `𝔽_b` is its
categorification, Burn its `π₀`-shadow. Decisive divergence — variance:
Burn has no functoriality under dominant non-birational maps (a fortiori
none in relative dimension ≥ 1), so it addresses linearizability/type
questions, not `G`-unirationality; this note's Thm 4.1 exists precisely to
supply the map-variance the quotient cannot have (consistent with the E44
shelf audit). Further contrasts: Burn abelianizes stabilizers via standard
form (destroying the nonabelian incidence depth — `D12` on `E_t ⊔ L_t`,
`A4` on the triangle — that `δ_res` and the poset retain); Burn is
first-order (weights only) vs Note II's jet ladder; Burn's symbols retain
full residual function fields — richer than `δ_bir`'s MRC-coarsening, noted
for possible un-coarsening.

**Imports adopted:** (i) standard-form models as a preferred cofinal class
for Note III's computation; (ii) the vanishing relations as a first-order
classification of *removable* configurations — pruning the CSP to the
non-removable core of `𝔽_b`; (iii) incompressibility coefficients
(Reichstein–Youssin and Burnside refinements) as source-side constraints.
**Registered side-goal FIX-B (after the T1–T5 gate):** the relative
Burnside shadow — `[Γ̃] = [P(W)] ∈ Burn_4(G)` is explicitly computable, and
Thm 4.1 fibers `Γ̃`'s strata over the target arrangement, so "the fixed
class decomposes compatibly with the arrangement" is a finite
linear-algebra necessary condition: the abelianized `H⁰` of the cosheaf.
Expected weak (linearization loses the content — E44 caution transfers) but
cheap and diagnostic. **Margin note:** KPT's `B_2(C_N)` is governed by
level-`N` modular symbols; our `C_11`-strata live on a level-11 modular
threefold (Gross–Popescu) — two level-11 structures meeting at the same
strata; unexploited.

## 8. Immediate program

1. **FIX-A0** (CAS, dispatched): exact verification of the involution
   split `(3,2)`, `X^σ = E_t ⊔ L_t`, `j(E_t)`, normal types `(−1)^{⊕2}`,
   centralizer `D12` with residual `S3`-actions, and the consolidated
   55-plane/55-line/V4-triangle incidence tables, char 0, from the exact
   Weil representation.
2. **FIX-A1** (CAS, dispatched): ground-truth `V4` decomposition
   `W|_{V4} = triv² ⊕ χ₁ ⊕ χ₂ ⊕ χ₃` (each involution's line = span of the
   other two isolated `V4`-points; the `V4`-pointwise-fixed line `P(triv²)`
   common to the three involution planes), and repair of the type-I/type-II
   `V4` incidence inconsistency flagged in the strata inputs ([E34] debt).
3. **Note II**: the jet ladder along strata (decoration functoriality past
   first order), reproducing the V4-line order bounds and the Rees-power
   corrections as instances; valuative formulation.
4. **T1–T5.**
5. **Note III**: the compatibility cosheaf on the target arrangement and the
   Klein constraint-satisfaction computation (Corollary 5.2 made effective).
