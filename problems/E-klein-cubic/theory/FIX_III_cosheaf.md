# FIX III — The landing cosheaf and the global constraint problem (skeleton)

Program FIX ([E56]). Note III skeleton; depends on [I], [II], [T] and the
verified complexes (FIX-A0/A1/A2). DRAFT-FOR-DERIVATION. This note becomes
full when the FIX-N2 stalk classification lands; the skeleton fixes the
definitions, the site inventory, the quotient reduction, and the honest
logical strength of `H⁰`.

## 1. The site: where images can land

By the funnel ([I, Cor 4.4] + FIX-A0): every fixed stratum of every model
of `P(W)` maps into the target arrangement, with genus-1 components
receiving points only. The landing **site** `𝒜` is the incidence complex:

- the 55 lines `L_σ` (positive-dimensional receptors);
- the 165 type-I vertices (`L_σ ∩ L_τ`, on `X`);
- the 165 type-II points (`X ∩ ℓ_V`, 3 per V4, on all three `E`'s);
- point-sites on the elliptics `E_σ`: **not** arbitrary points — the
  residual-stability argument ([T], step 5 pattern: the constant value of
  a `W`-stable connected stratum is fixed by the residual symmetry) pins
  elliptic landing sites to the fixed loci of subgroups of the residual
  `S3` acting on `E_σ`. Since `S3` acts on `P(W⁺) = P²` through
  `triv ⊕ std` (FIX-A0 claim 5), these are explicit finite sets —
  **inventory to be computed exactly (packet FIX-A3, small)**; the three
  `L_τ ∩ P_σ` points (which lie on `E_σ`, FIX-A0 finding 6a) and the
  type-II points are already-known members.

## 2. Stalks and corestrictions

For a site stratum `s`, the stalk `𝒯_s` is the set of **germ-level landing
data at `s`**: for `s = L_σ` — the ladder-cell solution varieties of [II]
(the FIX-N2 classification) with residual `S3`-equivariance for the
standard action; for point-sites — point-landing data constrained by the
first-order character containment ([I, Lem 4.5]) at that point.
Corestrictions along incidences of `𝒜` are the adjacency and jet-matching
constraints ([T], T1.2(2); [II] ladder gradings): germ data at a line and
at a vertex on it must agree at the vertex to the working order.

A **global landing section** is an assignment over all of `𝒜`, compatible
with all corestrictions, `G`-equivariant, and *nontrivial* in the dominance
sense (at least the generic-stratum datum is a dominant-map germ; the
degenerate all-points section is excluded by dominance of `f`). Write
`H⁰(𝒜, 𝒯^land)` for the set of these.

## 3. Logical strength (honest)

- **Existence of `f` ⇒ `H⁰ ≠ ∅`** (Thm [I, 4.1] + the gate machinery
  produce a section from a map). So `H⁰ = ∅` is the search-free negative
  headline.
- **`H⁰ ≠ ∅` concludes nothing by itself** (sections are necessary data
  only), but a section is *candidate global landing data*: input for the
  constructive programs (C6 common-line, Fable-redesign, G3 interface) —
  the reduction exit of E56.
- T5 lives one level down: it certifies rich sections over the **star of a
  single V4-stratum**. The open content of `H⁰` is exactly the
  simultaneous compatibility over the whole arrangement.

## 4. The quotient reduction (the feasibility theorem-to-be)

`G`-equivariance of sections means `H⁰` is computed on the **quotient
complex `𝒜/G` with stabilizer decorations**: one line class (stabilizer
`D12`, residual `S3` on the line), one type-I vertex class (stabilizer
`V4`, residual data from `A4`), one type-II class, one elliptic class, one
`ℓ_V`-class off `X`, and the finitely many deep point classes (from
FIX-A2/A0: `D12`- and `D10`-points off `X`, the distinguished 55-point
`D12`-orbit, the poset-isolated `C11`-points). **The CSP therefore has a
handful of orbit-variables** — germ-class choices per quotient stratum —
with constraints: (i) residual equivariance at each stratum; (ii)
adjacency matching at the two incidence types (vertex-on-line ×2 lines;
type-II-on-three-elliptics); (iii) triangle compatibility under the
`C3 = A4/V4` rotation; (iv) the [II] cone/parity gradings; (v) the
dominance nontriviality. Statement to prove in the full note: `H⁰` is the
solution set of this finite decorated CSP — with the subtlety that stalks
are varieties (the genus-2-cover parameter of the populated cell), so
"finite CSP" means finitely many variety-valued variables and algebraic
compatibility conditions: `H⁰` is a constructible set, computable by exact
elimination.

## 4b. The assembled CSP (structure fixed 2026-08-05; stalk populations
plug in from FIX-N2/N2b)

The site is now closed (FIX-A3): `𝒜` = 55 lines ∪ 165 type-I ∪ 165
type-II, nothing else; `𝒜/G` has **three strata classes** plus the
elliptic class acting purely as a relay (its only sites are the type-I/II
points already listed). The orbit-variables of the CSP:

- `x_L` — the germ class along the representative line `L_σ`: an element
  of the stalk variety `𝒮_L` = (the populated cells of the [II] table,
  fibered over their parameters: the odd-`m` branches over the genus-2
  reciprocal cover; the even-`m` `(2k, 3δ+3k)` branches; the `m = 1,
  r ≥ 6` cells as the FIX-N2b flag) **∪ {pt}** (the constant/point-image
  option), all with the residual `S3`-equivariance for the standard
  action imposed;
- `x_I` — the germ class at the representative type-I vertex: point-landing
  data at a vertex lying on two lines and one elliptic, constrained by
  first-order character containment ([I, Lem 4.5]) for the `V₄`-normal
  data (FIX-A0 claim 4: both receptors have normal type `(−1)^{⊕2}` in
  `X`);
- `x_{II}` — the germ class at the representative type-II point (on three
  elliptics, off every line; stabilizer `V₄`);
- implicit relay conditions on each `E_σ`: any elliptic-valued datum is a
  point among its 12 sites — no free variable.

The constraint equations (all finite, all exact):

1. **(Line self-consistency)** `x_L ∈ 𝒮_L` with `S3`-equivariance — the
   packet-verified standard action; nonconstant options exist iff the
   corresponding cell is populated ([II] table).
2. **(Vertex gluing, ×2)** at the type-I vertex, the two incident lines'
   germs and the vertex datum agree to the working order: the T2-chain
   adjacency ([T], T1.2(2)) plus the jet matching of the ladder gradings
   ([II, §2]) in the `V₄`-normal coordinates.
3. **(Triangle rotation)** the `C₃ = A₄/V₄` action permutes the three
   incident line-germs at a triangle compatibly (the `λ = ω²` residual
   scalar mechanics pinned by FIX-N2's re-verification).
4. **(Type-II relay)** `x_{II}` is consistent as a point-image on all
   three elliptics simultaneously (three character-containment conditions
   at one point; fields of definition per FIX-A3 — degree-3 over
   `Q(ζ₁₁)`).
5. **(Dominance)** the generic-stratum datum is a dominant-map germ; the
   all-points section is excluded.
6. **(Cone/parity admissibility)** every germ obeys [II, Lemmas 2.1–2.2]
   — built into `𝒮_L` by construction.

`H⁰(𝒜, 𝒯^land)` = the constructible set of solutions
`(x_L, x_I, x_{II})` — **three variety-valued variables and six finite
constraint families**. Computation: exact elimination, stratum class by
stratum class, starting from `x_L` (the only positive-dimensional
receptor). Two exits, both live: empty ⇒ negative headline; nonempty ⇒
the solution set is the moduli of candidate global landing data, handed
to method families 1/3.

**What remains before the computation runs:** (i) FIX-N2b's answer on the
`m = 1` row (changes `𝒮_L`'s component list, not the CSP shape); (ii) the
section-from-map theorem written to Note-I rigor (the easy direction —
every `f` induces a solution; the machinery is all in [I]/[T], the
writing is bookkeeping); (iii) the working order for constraint 2 fixed
high enough to be decisive — the ladder gradings tell us the first order
at which the vertex data distinguishes branches; take the maximum over
the populated cells' leading orders, finite by the [II] table.

## 4c. The section-from-map theorem (the easy direction, at full rigor)

**Theorem 5.1.** Every `G`-equivariant dominant rational map
`f: P(W) ⇢ X` induces a solution `(x_L, x_I, x_{II})` of the CSP of §4b.

*Proof.* Resolve the graph ([I, Obs 4.0]): `q̃: Γ̃ → X` honest equivariant,
`Γ̃ ∈ Mod_G(P(W))`. Assignments:

- `x_L`: fix the representative involution `σ` and consider the strata of
  `Γ̃^σ` whose `q̃`-image meets `L_σ` in a dense subset of its image. If
  none exists, set `x_L = pt` with value the (finitely many,
  residually-pinned) image points — a legal stalk element by the funnel.
  If one exists, restrict `q̃` to the formal neighborhood of that stratum:
  by definition this is an equivariant landing family along the source
  stratum with values in `X` near `L_σ`, i.e. an element of a cell of the
  [II] ladder — the stalk `𝒮_L` was *defined* as the union of these cell
  varieties, so the restriction is a point of `𝒮_L`. Residual
  `S3`-equivariance: `C_G(σ)` stabilizes both the stratum orbit and
  `L_σ`, and `q̃` is `C_G(σ)`-equivariant, so the germ is `S3`-equivariant
  for the standard action (FIX-A0 claim 5). Constraint 1 holds; constraint
  6 holds because the germ of an actual map satisfies the cone/parity
  bounds ([II, Lemmas 2.1–2.2] are theorems about any equivariant family,
  in particular this one).
- `x_I`: the value and jet of `q̃` at the strata over the representative
  type-I vertex. Constraint 2: the two incident lines' germs and the
  vertex jet all arise from the *same* map `q̃`, so they agree wherever
  they overlap — adjacency ([T, T1.2(2)]) and jet matching are literal
  restrictions of one function. Constraint 3: the `A₄`-equivariance of
  `q̃` conjugates the three edge germs by the `C₃`-rotation with the
  scalar mechanics forced by the character bookkeeping (the `λ`-scalars
  are determined by equivariance, as FIX-N2's re-verification exhibited).
- `x_{II}`: the value of `q̃` on the strata funneled to the representative
  type-II point; constraint 4's three character-containment conditions
  are [I, Lem 4.5] applied to `dq̃` at that point, which holds for any
  honest equivariant map.
- Constraint 5: `f` dominant ⇒ the generic-stratum germ of `q̃` is a
  dominant-map germ; the section is not the all-points section. ∎

Hence `H⁰ = ∅ ⇒` no `f` exists `⇒` (by [E37]/[E16]) the negative
headline. The converse direction — from a section to a map — is NOT
claimed; a nonempty `H⁰` yields candidate data only.

**Working order (constraint 2), fixed.** The vertex gluing must be imposed
to the first order at which the populated cells' germs differ at a vertex:
by the [II] table the populated branches have leading orders in
`{(2k, 3δ+3k)} ∪ {(m₀+2k, ·) : m₀ ≥ 3}` (and the `m = 1, r ≥ 6` flag);
the discriminating order is the maximum of the finitely many leading
`r`-values that occur at or below the working cells, plus one — finite,
and computable from the table once FIX-N2c lands. The elimination will be
run at that order, with the order recorded in the packet so the
computation is replayable.

## 6. Corrections and upgrades after FIX-H0 (2026-08-05)

The FIX-H0 packet (director-replayed) corrected §4b in three places and
proved the program's first unconditional global theorems:

**Theorem 6.1 (= H0-1, plus-plane parity).** For any equivariant dominant
`f: P(W) ⇢ X` and every involution `σ`: writing `T⁺ = (a′,b′,u₀′)`,
`T⁻ = (u₁′,u₂′)` for the halves of the germ along the plus-plane,
`ord_{P_σ}(T⁻) < ord_{P_σ}(T⁺)`; hence the common plane order `m` is
**odd**. (σ-parity gives the two halves opposite parities; if the plus
half led, the exceptional `D_σ ≅ P² × P¹` over the blown-up plus-plane
would map into `E_σ` — rational into genus 1 forces a constant, which
must be a `C_G(σ)`-fixed point of `E_σ`, and `Fix(S3, P(W⁺_σ)) = {[triv]}`
is off `X`.) **Consequence: every even-`m` stalk branch is globally
excluded, unconditionally** — including the entire `(2, r)` row and the
`(0,3)` seed. The `m = 1` classification holes (even `r`, `(1,6)` above
degree 2) cease to gate anything: oddness is robust to undiscovered
witnesses.

**Theorem 6.2 (= H0-2, forced line surjection).** `x_L = pt` is
impossible: `D_σ` maps **onto** `L_σ` (a constant image would be a
`C_G(σ)`-fixed point of `P(W⁻_σ)`, and `W⁻_σ` is `C_G(σ)`-irreducible).
Every hypothetical map *must* sweep every line — the funnel's rational
receptors are mandatory, not optional. (Direct input for the common-line
program: forced line-surjections from the σ-exceptional divisors.)

**Corrections to §4b.** (i) The drafted constraints 1, 3, 6 and the
within-triangle vertex gluing are already discharged by any populated
Note-II cell — the cell germ lives at `ℓ_V`, which lies in all three
plus-planes and is `A₄`-equivariant by construction; the drafted order-8
within-triangle elimination has no residual content. (ii) The §4b list
was **missing a constraint class** — the plus-plane leading-half
constraint of Theorem 6.1, the only constraint that removed stalk
components; the elliptics are not mere relays. (iii) The genuine
remaining coupling is **across the three V4's through one σ**: certified
exactly that `C_G(σ) ∩ N_G(V4) = V4` with the three residual images
being three distinct transpositions generating `S3`, and that
`ℓ_V ∩ L_σ = ∅` — so the binding constraint transports the three
`ℓ_V`-germs into the `σ`-frame along disjoint strata. This is the
remaining computation (FIX-H1); it was not run in FIX-H0 (no degree
bound was available).

**Uniformization (task D), fully confirmed.** One trace geometry:
`(B³−1)²/B³ = B³ + B⁻³ − 2`, the `m = 1` Chebyshev root is
`c = ω^k B + ω^{−k}B⁻¹`, and the genus-2 reciprocal cover at
`[p:q] = [1:0]` gives `τ = B^{±3}` — the `m = 1` point sits over the
odd-`m` point **under the cubic isogeny `τ ↦ τ³`**. The exact Klein
identity `(κ₊+2)(κ₋+2) = 27/4` makes the second Chebyshev cubic the
trace-cubic of the *other* character surface; the `m = 1` stalk is the
fibre product of the two cube-root covers (degree `3×3 = 9`, matching).

**State after FIX-H0.** Surviving stalk branches: the odd rows only —
the `(3, ·)` `D_B`-family branch (T5 witness and relatives) and the
`(1, odd r ≥ 7)` primitive Chebyshev branch. `H⁰` reduces to the
cross-V4 coupling of §(iii) for these two branches.

## 5. Dependencies and plan

1. **FIX-N2** (in flight): the stalk classification at the line/V4 level —
   the cell table of [II, §4].
2. **FIX-A3** (to dispatch, small): the elliptic landing-site inventory
   (fixed loci of `S3`-subgroups on `E_σ`, exactly), completing the site.
3. Full Note III: assemble the CSP per §4; prove the section-from-map
   construction (the easy direction of §3) with all constraint classes
   included; then the **computation**: exact elimination over the
   orbit-variables. Output: either `H⁰ = ∅` (negative headline) or an
   explicit constructible family of candidate global landing data
   (handed to method families 1/3).
4. **FIX-B** (in flight, scoped): the symbol list and the non-removable
   core — the latter constrains which stalk supports can appear in any
   model, pruning §4's CSP before it is assembled. Structural finding
   already recorded: the unrelativized Burnside class is map-blind; the
   cosheaf **is** the correct relativization.
