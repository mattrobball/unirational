# Data specification: pipeline flush (E-ledger, Stein/Leray, L12 order-11)

Issued 2026-08-12 (director). Three lanes, three packets, executed
against this spec by mid-tier models with flag-and-stop discipline; each
gets a Fable referee before sealing. Shared rules: python3 only (never
gap/gp/sage/magma — shell aliases trap); exact arithmetic (Fraction /
exact cyclotomic; no floats); primes 331/661 where modular; no git;
each lane writes ONLY its own packet directory; headline fixed:
"Problem E remains OPEN; this packet excludes no degree"; any zero or
all-dead outcome FLAGGED behind an ODDZERO-standard audit; packet
protocol per `goal_runs_20260811/ODDZERO_AUDIT/REGISTRATION_SNIPPET.md`
(THEOREM.md — never REPORT.md — scripts/, results/, replayable
verifier.py, REGISTRATION_SNIPPET.md, entry E56, goal_run, tracked
true, honesty tiering, "Not claimed"). Known errata to respect: the 22
cells share ONE σ-band group per prime (labels prime-dependent), unique
only at `content_hash`; immune-block data are MENUS (never collapse);
menu source `goal_runs_20260811/GLOBAL_COHERENCE/results/vectors_d35.json`.

## Lane 1 — E-ledger (packet `goal_runs_20260812/E_LEDGER/`)

Authority: `theory/SCHEME_MAP_CONSEQUENCES_20260812.md` §3.1 (E2
congruences, E3 movable-cone LP, E4 system). Pins:

- Intersection conventions: derive the blowup Chow relations from the
  standard presentation and CALIBRATE before use: on `Bl_pt P⁴`,
  `H³E = H²E² = HE³ = 0` and `E⁴ = −1` must come out of your
  implementation (fatal anchor); for curve centers use the standard
  `E`-ring with the normal-bundle degrees the census/frames give.
- The vanishing source is `(q*H_X)⁴ = 0` with `q*H_X = dH − Σ m_E E` at
  MAP level (`d = d_min`); the mod-p filter lemma (only orbits with
  `p | |Γ_S|` contribute mod `p ∈ {11, 5, 3}`) must be PROVED in-packet
  from orbit sizes `660/|Γ_S|` (census), not assumed.
- Cross-check anchor: the sealed C1 relation family
  (`theory/CONSTRAINT_ADDITIONS_20260811.md` C1) must be reproduced by
  your expansion at degree one lower (fatal if inconsistent).
- The d = 35 instance: report the `μ ≡ ±1 (mod 11)` statement EXACTLY as
  conditional as §3.1 states it (its nondegeneracy hypothesis named in
  the same sentence, every time).
- E3: the movable-cone LP in exact rational arithmetic (reuse the
  simplex discipline of `goal_runs_20260812/SMITH_I3/scripts` — exact
  Fractions, certificates stored); E4: emit the census-wide linear
  system machine-readably; solving it fully is NOT required — its rank
  and any forced entries are.

## Lane 2 — Stein/Leray on the 22 (packet `goal_runs_20260812/STEIN_LERAY/`)

Authority: `theory/SCHEME_MAP_CONSEQUENCES_20260812.md` §3.4 (J1–J3),
now COMBINED with the sealed Smith results
(`goal_runs_20260812/SMITH_I3`: at each C11-point `χ(fiber) ≡ 4 (mod
11)` with the five values equal; at C5-points `≡ 0 (mod 5)`). Pins:

- J1 re-derivation in-packet: `G`-invariant effective divisor degrees on
  `X` are exactly `k ≥ 5` (Molien on `X`: multiplicities of the trivial
  rep in `H⁰(X, O(k))`; anchors `M₁ = 1? — no: use the extraction's
  anchors M₁₁ = 12, M₂₅ = 189, M₃₄ = 576` — all must reproduce; the
  scratch `tmp/scheme_map_20260812/molien_branch.py` is the reference
  implementation, re-derive don't copy).
- The dichotomy ledger per cell: CONNECTED branch — J3's vanishing
  (`H⁰ = H¹(R¹q_*O) = 0`, `H⁰(R²) ≅ H²(R¹)`, hence no `h²(O)` in fibers
  over the pinned odd-order points, with the escape-locus caveat: the
  escape is itself an invariant divisor of degree ≥ 5); DISCONNECTED
  branch — the Stein factor's branch divisor costs degree ≥ 5, and you
  report what (if anything) in the sealed d = 35 data bounds or
  contradicts it — parametric honesty if nothing does.
- The deliverable with bite: per C11/C5 point, the joint menus for the
  fiber invariants `(h⁰, h¹)` implied by [Smith values] ∧ [J3 vanishing]
  ∧ [`χ = h⁰ − h¹`, `h⁰ ≥ 1`] — exact finite or parametric menus, per
  branch of the dichotomy, constant across the immune menus (verify
  that constancy rather than assert it).

## Lane 3 — L12 order-11 (packet `goal_runs_20260812/L12_ORDER11/`)

Authority: `WORKORDER_L12_ORDER11.md` (committed) plus
`theory/GLOBAL_LOCALIZATION_LEDGER_20260812.md` §8 (the refereed
formulas are binding: contribution `w/det(1 − dg|T)`; denominators
`Π_{k'∉{j,j+1}}(1 − ζ^{a_{k'}−a_j})`; the localized `k = 0` sum rule
first; derived-fiber flag). Additional pins:

- Tower data semantics: the C11 chains and value assignments per cell
  are MENUS from the F_odd vectors (same discipline as everywhere);
  STAGE2's non-residue branch (at most 3 of 4 first-level rows defined,
  towers need depth ≥ 2) is the branch at `d ≡ 2 (mod 11)`.
- Fatal anchors before use: untwisted total = 1 on `P⁴` AND after
  arbitrary random test towers; genus-0 right sides equal
  `χ_{Sym^k W*}(g)` for `k = 0, 1, 2` and `χ_{Sym³W*}(g) − 1` for
  `k = 3`, computed independently via the exact character engine
  (`director_probes_20260811/molien_director.py` conventions).
- Feed-in from Smith (sealed): the five fiber `χ`'s at the C11-points
  are EQUAL and `≡ 4 (mod 11)` — use as a constraint coupling the
  fiber-trace unknowns (`χ = 1 − tr H¹ + tr H²`-type bookkeeping under
  the derived-fiber flag; state the exact relation you use and tier it).
- Deliverables: the `k = 0` sum rule evaluated (fiber-trace constraint,
  pattern-free); the genus-0 closed test per (cell, menu entry) for
  `k = 1, 2, 3`; the bounded-menu pass; the symbolic `d mod 11` branch
  statements. Anything that dies dies at map level for its class —
  say exactly that.

## Sequencing

The three lanes are independent; run in parallel. Each writes for the
Fable referee that follows. Executor reports ≤ 25 lines each.
