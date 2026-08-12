# The morphism ledger: every constraint layer of the complex-of-groups map

Opened 2026-08-12 (director; user directive: this structure is the only
source of results on the equivariant rationality questions — organize the
campaign as draining it). Status column: SPENT (fully imposed and
audited), PARTIAL, DISPATCHED (worker in flight), UNSPENT.

The object: a landing map induces, on any equivariant resolution, a
morphism from the source stratified complex (strata `S`, stabilizers
`Γ_S`, normal character data, closure poset with links, transversal/orbit
bookkeeping) to the receiver complex on `X`. Its full datum is far more
than a value assignment. The layers:

| # | layer | content | status |
|---|---|---|---|
| L1 | value assignment `τ` | which stratum lands where | SPENT (σ-band, arc-consistency, residue tables; J census) |
| L2 | tangential moduli on sweep rows | the `(a, ψ)`-classes; modules `V(a,ψ)` | SPENT (full-flag rows; Theorem S/S′) |
| L3 | depth structure at children | level vectors, value cycles | SPENT (stratified semantics; sealed depth table; arc-jet ladder — 62 kills FLAGGED behind the running audit) |
| L4 | odd-order weight pinning | master weight formula at point strata | SPENT at map level; tuple-level Φ_J closure UNSPENT (transport note §8.4) |
| L5 | pairwise child coherence | shared-value equality via transversals | SPENT |
| L6 | section-level gluing on shared positive-dim loci | cross-band equality of restricted sections | DISPATCHED (`WORKORDER_CROSSBAND_GLUING`) |
| L7 | 2-chain (triangle) cocycle coherence | transversal-twist consistency of the quotient-complex morphism | DISPATCHED (`WORKORDER_COCYCLE_COHERENCE`) |
| L8 | the equivariant ramification complex | per-stratum NORMAL response: which conormal characters of `S` map to which normal characters at `τ(S)`, with which orders — the `m_E`-data as `Γ_S`-representation constraints, not numbers; includes the receiver-side tangent-cone condition at special values | DISPATCHED (`WORKORDER_RAMIFICATION_COMPLEX`) |
| L9 | chain-level jet transitivity | along `S ⊇ S′ ⊇ S″`: the composite of the two level/value rules must agree with the direct one; pairwise arc-consistency does not imply it | UNSPENT — `WORKORDER_CHAIN_JET_TRANSITIVITY` (this cycle) |
| L10 | global cycle ledger | pushforward/projection-formula relations among the per-stratum mapping degrees across the whole poset (one linear system over the census) | UNSPENT — queued after L8/L9 |
| L11 | full functorial coherence | the single-morphism cut of STAGE1 §15.4 — the umbrella of L5–L10 | THEORY TARGET |
| L12 | global localization ledger | equivariant χ pushed through the map, both-ways evaluation per conjugacy class and twist — the first GLOBAL identity family, coupling the pattern census to the fiber complex | DERIVED (`theory/GLOBAL_LOCALIZATION_LEDGER_20260812.md`, director) — machine phase gated on referee |

Reading discipline: L1–L3 spending is what produced everything at d = 35
(1264 → 22); L4's tuple upgrade is the transport program's remaining
ammunition; L6–L9 are the four computable unspent layers, every one
degree-general in structure (their data are census/group-theoretic, with
the degree entering only through residue classes). The stone is not dry: L8–L10 and L12 have
never been machine-spent, and L12 is the first layer that is GLOBAL —
no failure of it can be localized to a stratum.
