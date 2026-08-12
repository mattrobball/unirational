# Data specification: I3 + F2/F3 execution (director-pinned semantics)

Issued 2026-08-12 (director). This file pins the meaning of every input
the I3/Smith execution touches. The executor follows it literally; any
input whose meaning is not pinned here and not unambiguous in its source
file is a FLAG, not a judgment call.

## 1. I3 (semistability prefilter)

- Objects: candidate tuples `T ∈ (Sym^d W* ⊗ W)`; monomial support =
  pairs `(α, c)`, `α ∈ Z^5_{≥0}` with `|α| = d` (exponent of `x^α`),
  `c ∈ {0..4}` (target coordinate). The compiler's seed encoding is
  exactly this: `layer0_A_p331.npy` rows are `α`, `layer0_C_p331.npy`
  entries are `c` (see `D34_GUIDED_SWEEP/slicelib.py`, `jet_rows`
  docstring: seed `s = X^α e_{c0}`).
- Hilbert–Mumford convention TO USE: for a 1-parameter subgroup with
  integer weights `r ∈ Z^5`, `Σ r_i = 0`, acting by
  `x_i ↦ t^{-r_i} x_i` on coordinates (so `e_i ↦ t^{r_i} e_i` on `W`),
  the weight of the support element `(α, c)` is `⟨r, α⟩ − r_c`. `T` is
  UNSTABLE iff some `r` makes the weight of EVERY support element
  strictly positive. CALIBRATION ANCHORS (must pass before any use):
  (i) the tuple `F·x` (support: `α = e_i + e_{i+1}·2`-type... compute
  from `F = Σ x_i²x_{i+1}` times `x_c e_c`) must test SEMISTABLE;
  (ii) the single-seed tuple `x_0^d e_0` must test UNSTABLE
  (destabilized by `r = (4,−1,−1,−1,−1)`); if either anchor fails, the
  sign convention is wrong — fix the convention, do not proceed.
- The theorem (make packet-grade): every nonzero `G`-covariant is
  semistable. Proof skeleton to write out: instability ⟹ Kempf's
  canonical destabilizing 1-PS/flag, unique up to the parabolic ⟹
  `G`-invariance of `T` makes the flag `G`-stable ⟹ a proper `G`-stable
  filtration of `W` exists — contradicting irreducibility of `W`.
- Where it can bite, pinned: NOT on any tuple already known equivariant
  (the theorem makes the filter vacuous there — if the current d = 35
  pipeline only ever handles equivariant objects, the correct verdict is
  SUBSUMED with the statement of exactly that). Potential bite: any
  pipeline stage enumerating supports before symmetrization (seed
  generation, ansatz searches, the RT lane's restricted tuples). Check
  `produce_d34.py:basis_seeds` and the RT packets; report where
  non-semistable supports are currently admitted, if anywhere.

## 2. F2/F3 (Smith congruences)

- The lemma (state and cite in the packet): for `g` of prime order `p`
  on a projective variety `Y`: `χ(Y) ≡ χ(Y^g) (mod p)`. Applied to
  fibers: for `x ∈ X^g`, `χ(q^{-1}x) ≡ χ((q^{-1}x)^g) (mod p)`, and
  `(q^{-1}x)^g = (q|_{Z^g})^{-1}(x)`.
- Receiver constants: read from `goal_runs_20260810/RECEIVER_LEDGER_X/
  results/ledger_exact.json` — the fixed-locus strata of `X` per class
  with their χ data. Do not re-derive; cite.
- Source-side χ(Z^g) baselines: `χ(P(W)^g)` from the eigenstructure
  (order 11: 5 points; order 5: per the C5 frame; orders 2/3/6: the
  plane/line/point loci — take the census values from
  `TERMINUS_STRATA_PW` / `STAGE1_COMPLEX_MAPS`, cite rows). Blowup
  delta, pinned: blowing up a `g`-stable center `Y` with normal bundle
  `N` changes `χ(Z^g)` by `χ(Y^g) · (χ(P(N)^g_{fiber}) − 1)` where
  `P(N)^g_{fiber}` is the `g`-fixed locus of the projectivized normal
  fiber at a fixed point of `Y` (for isolated centers: the number of
  eigen-directions of `N`).
- The 22 cells' data — THE CRITICAL PIN: each cell's σ-band pattern is
  UNIQUE (content-addressed files in `goal_runs_20260811/D35_AUDIT/
  results/`, the canonical 756/22; key by `sol_hash`). Each cell's
  immune-block data (C11/C5/A4/D10 chains and values) is a MENU, not a
  choice: the admissible entries are the F_odd vectors of
  `goal_runs_20260811/GLOBAL_COHERENCE/results/vectors_d35.json` at the
  residue of 35. Every per-cell result is therefore per-(cell, menu
  entry); never collapse the menu. If the linkage between a cell and its
  admissible menu subset is not determined by the files, treat the FULL
  menu as admissible and say so.
- Fiber unknowns: `χ` of `g`-fixed fibers enters as free integers
  constrained by (i) the congruences themselves, (ii) `χ ≤ 2` for a
  connected curve fiber, `χ = 2 − 2g ≥ 2 − 2g_max` with `g_max` bounded
  ONLY if a sealed bound applies at d = 35 (check C1 in
  `theory/CONSTRAINT_ADDITIONS_20260811.md`; if no sealed bound binds,
  report menus parametrically in `χ` — do not invent bounds), (iii)
  disconnected/surface-component caveats stated per
  `theory/SCHEME_MAP_CONSEQUENCES_20260812.md` §3.4 (J1: a disconnected
  Stein factor costs an invariant branch divisor of degree ≥ 5 — cite,
  may be assumed AWAY only where that packet's J1 hypotheses are
  checked, else carry both branches).
- Orders: 11 and 2 first (isolated receiver points / the σ-band
  geometry), then 3 and 5. Exact integer arithmetic throughout.

## 3. Framing (binding)

Headline: "Problem E remains OPEN; this packet excludes no degree."
Packet `goal_runs_20260812/SMITH_I3/`, protocol per
`goal_runs_20260811/ODDZERO_AUDIT/REGISTRATION_SNIPPET.md` format
(entry E56, goal_run, tracked true); THEOREM.md (never REPORT.md);
replayable verifier (calibration anchors of §1 as check group A; every
receiver/census constant consumed as group B; the congruence evaluations
as group C); honesty tiering; exits `SMITH-I3-*`; "Not claimed". Any
zero/all-dead outcome: FLAG behind an ODDZERO-standard audit. A Fable
referee pass follows delivery; write for that referee.
