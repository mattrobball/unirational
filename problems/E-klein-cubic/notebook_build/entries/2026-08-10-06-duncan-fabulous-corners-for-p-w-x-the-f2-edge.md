## 2026-08-10 Duncan fabulous corners for `P(W) ⇢ X`: the (F2) edge constraint

Packet `goal_runs_20260810/DUNCAN_CORNER_F2/` (entry [E56]; marker
`DUNCAN_CORNER_F2_VERIFY_OK`; `THEOREM.md`, `STATUS.md`, `verifier.py`,
`scripts/`, `results/`).  Exits:

```text
DUNCAN-CORNER-FABULOUS-VERIFIED
DUNCAN-CORNER-INVENTORY-COMPLETE
DUNCAN-F2-EDGE-CONSTRAINT-SEALED
DUNCAN-F2-SURVIVES-T5-TRISECTION
DUNCAN-NO-CLOSURE-AT-I2
```

`external_docs/duncan_higher_obstruction_20260805.tex` had been imported but
never run on the source side.  It now has been.

**Proposition A (the structural fact that decides everything).**  In toroidal
form `G_x` is abelian of rank `≤ |I(x)|` (Duncan lines 83–90), and fabulous ⟺
non-cyclic (`thm:pairs`, line 728).  **`PSL(2,11)` has exactly 55 non-cyclic
abelian subgroups and all of them are Klein four-groups** (exhaustive over the
660 matrices, two split primes).  So every fabulous corner has
`G_{D_ij} = V4` and its two divisorial stabilizers are two **commuting**
involutions `⟨z⟩, ⟨s⟩`.  No `C3`/`C5`/`C6`/`C11`-divisor can ever sit on one.

**Lemma B.**  `G_E = ker(H → PGL(N))`, so only the 55 plus-planes
(`sign^{⊕2}`) and 55 minus-lines (`sign^{⊕3}`) — the two isotypic normal
bundles — carry a boundary divisor with `G_D ≠ 1`.  `ℓ_V`, the `C3`-lines and
every point stratum give `G_E = 1` and are discarded.  On `P(W)` itself
`Fix(V4) = ℓ_V` has codim **3**: no fabulous corner exists before blowing up.

**Lemma C.**  `χ_z ⊕ χ_s ⊕ χ_r` is the irreducible 3-dim rep of `A4 = N_G(V)`,
so the first centre through a general point of `ℓ_V` must be `ℓ_V`.  The three
plus-planes cannot be separated asymmetrically at level 0 — which is exactly why
the corner is invisible until after that blowup, and free afterwards
(`Stab(M_τ^V) = V4`).

**The corner.**  Stabilizer-stratified tower T0 (points) → T1 (`ℓ_V`) → T2
(`P̃_σ`) → T3 (`M̃_τ^V`, where `M_τ = P(N_{ℓ_V} ∩ W_τ^-)` is a *new* codim-2
component of `Fix(τ)` inside `E_V ≅ P¹ × P²`).  Then
`D_ij = E_s^V ∩ Ẽ_z` has `G_{D_ij} = V4` — **non-cyclic, FABULOUS**.  Verified
twice: Macaulay2 blowup charts exact over `QQ` (45/45 checks, `isPrime` and
`codim 2` on the corner ideal, stabilizers read off the quotient rings) and
Duncan's own toric formula `H_τ = ∩_{m∈τ^⊥} ker χ^m` (exact `Z`,
`|H_τ| = 4`).  330 corners, 2 `G`-orbits of size 165.

**W1 (the load-bearing conditional, discharged).**  `D_ij` is
`P(N_{M̃_s}|_{C'})`, a `P¹`-bundle over `C' ≅ ℓ_V ≅ P¹` — irreducible, smooth,
connected, codim 2.  Chain: `E_V = P(O(1)^{⊕3}) ≅ P¹×P²`; `M_s ≅ P¹×P¹`;
`M_s ∩ P̃_z = S_z` is Cartier on `M_s` so `M̃_s ≅ M_s`; `C'` is the canonical
`χ_s`-section of `P(N_{P̃_z})|_{S_z}`.  All module inputs checked for all 55
`V4`s at both primes.

**(F1), re-derived not new.**  Any divisor with `G_D = ⟨σ⟩` and
`Stab_G(D) = C_G(σ) = D12` has `f(D) = L_σ` forced — from
`lem:fabulous_basics` + rationality of strata + `X^{D12} = ∅`, *without*
fabulousness.  This reproves "the σ-datum sweeps `L_σ`"
(`theory/FIX_V_construction.md:16`).

**(F2), NEW.**  `f(E_s^V) ∈ {L_s, [B], [C], [D]}`: the deep `s`-divisor sweeps
`L_s` or contracts to a **type-I** vertex, and is **never** contracted to a
**type-II** point.  Proof: `f(E_s^V)` is `V`-invariant and irreducible; if it
were a type-II point `Q` then, since the only rational curves in `X_nt` are the
55 lines and `ℓ_V ∩ L'_τ = ∅` (so `Q` is on no line), the RCC set of
`thm:fabulous`+`prop:rcc_total` collapses to `{Q}`, forcing `Q ∈ L_z` —
contradiction.  This is a new **adjacency constraint type** for the Note III
CSP (deep-normal-carrier vs plus-plane-carrier), pruning `x_{II}`; it is *not*
implied by the four sealed profile facts, since `M_s^V` is a level-3 stratum of
the tower, i.e. second-order data along `ℓ_V`.

**W7 — mandatory T5 test (`FIX_I_bcomplex.md:313–319`).**  Tested against the
[E33] trisection witness (`V4_SIMULTANEOUS_ODD_NORMALS_20260802/THEOREM.md` §4).
Both residual-`C3` eigenpoints of `ℓ_V` lie **off** `X` (110/110, two primes),
so the witness's slice `S_κ = X ∩ H` is disjoint from `ℓ_V` and never lands on a
type-II point.  **(F2) survives.**  Recorded honestly: the survival is
**vacuous** — the witness never populates the constrained stratum, so T5 shows
only non-overreach, not bite.  Note [E33]'s eq. (2.10) *is* the type-II locus
and its Thm 2.12 forbids landing there in the `m=1` stratum; (F2) forbids it at
a different stratum by a different mechanism — consistent and independent.

**Verdict `DUNCAN-NO-CLOSURE-AT-I2`.**  The mechanism cannot close Problem E at
`|I| = 2`, for a structural reason: at *every* fabulous corner `z` and `s`
commute, and precisely for commuting involutions `L_z ∩ L_s ≠ ∅` (the 55-line
graph is the commuting graph — 165 edges, 6-regular, connected, diameter 3).
So the default landing forced by (F1) already satisfies the chain condition with
the shortest possible chain.  Second escape: the three type-II points of a
`V`-triangle lie on all three of its elliptics.  Duncan's own `S_4`/dP2 endgame
works only because there `S_nt` has *no* rational curve; here `X_nt` is half
rational curves, and their incidence graph's edges are exactly the pairs a
fabulous corner can present.  `|I| ≥ 3` gives connectedness only, and `X_nt` is
connected, so it is vacuous.

**Dependencies (recorded).**  Both `thm:pairs` and `prop:rcc_total` are used
essentially and are graded EXTERNAL-UNVERIFIED, *"import candidates pending our
own proof review"* (NOTEBOOK.md, External sessions).  Every exit above is
conditional on them; if `prop:rcc_total` falls, (F2) and Theorem E fall while
Propositions A–D, the tower, W1–W3, W5–W6 and (F1) stand.

**Correction to three files (tex numbering drift).**  With the current
`.tex`'s shared `[section]` counter, `thm:fabulous = 3.8`, `prop:rcc = 3.9`,
`rem:toric_criterion = 3.12`, `thm:pairs = 4.1`, `prop:rcc_total = 4.11`,
`def:stratified_tower = 4.14`, `lem:rational_strata_propagate = 4.15`,
`cor:pn_resolved = 4.16`, `thm:no_map_to_dp2 = 4.18`.  The citations
"Thm 3.10 / Thm 4.2 / Prop 3.12 / Prop 3.24 / Thm 6.2 / Def 6.3 / Lemma 6.4"
in this notebook (§ External documents / [E56] status), `theory/FIX_I_bcomplex.md`
and `theory/FIX_T_gate.md` match an **earlier draft's** sectioning and point at
the wrong numbers.  Cite by label + line number.
