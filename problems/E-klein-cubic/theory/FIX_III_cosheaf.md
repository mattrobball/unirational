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
