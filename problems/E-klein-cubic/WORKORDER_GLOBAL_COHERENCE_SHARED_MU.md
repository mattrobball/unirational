# WORKORDER — Global coherence: shared-μ collapse and the incidence/Z⁺ join
# (handoff queue items 2 + 3, one packet)

Issued 2026-08-11 (director). python3 only (no gap/gp/sage/magma — shell
aliases trap); both primes `p = 331, 661` wherever arithmetic is modular;
the weight/character layer is exact integer arithmetic. No git operations;
no edits outside your new packet `goal_runs_20260811/GLOBAL_COHERENCE/`.

## A. Context

The current per-residue count multiplies INDEPENDENT factors
(`STAGE1_TIGHTEN` §2.4, corrected by `STAGE1_STRATIFIED`):

    count(d) = K(d mod 6) × D10(d, μ₁) × 3⁸ ,

where `K` is the corrected σ-band factor (11068/1178/1512/6216/1344/756 —
`goal_runs_20260811/STAGE1_STRATIFIED/results/residue_table.txt`),
`D10 ∈ {13, 10}` is the C2-line branch (`STAGE1_TIGHTEN` §2.3, Prop 2.1:
branch selected by the parity of `d·a_k + μ₁`), and `3⁸` is the odd-order
factor (`STAGE2_ODD_ORDER_PINNING` §4: the eight A4/C3-rows keep 3 values
each after pinning; the C5/C11 blocks are single-pattern per residue).

The independence is FALSE in two ways, and this packet removes both:

1. **Shared μ.** Every immune-row value is pinned by Theorem 1.2's master
   weight formula `w(R) = d·a_k + Σ_l μ_l·c_l (mod n)`, where the `μ_l` are
   jet orders of the SAME map `T` at the blowup chain over the center. Rows
   over the same center share its `μ`-sequence; the D10 branch parity uses
   the same `μ₁` as the `pt_D10` rows over that point. Enumerating rows
   independently overcounts.
2. **Incidence.** Cross-row coherence is currently imposed only through
   shared children within the σ-band (`STAGE1_COMPLEX_MAPS` §15.6(3)); the
   full order-0 incidence lattice (the 145 proved closure relations, §4 /
   Layer 3) and the positive-dimensional rows (`Z⁺`: the D10 C2-line and
   the two one-parameter families of §15.5) are not imposed globally.

## B. Phase 1 — shared-μ enumeration of the immune block

Read first: `STAGE2_ODD_ORDER_PINNING/THEOREM.md` §§0–4 and its
`scripts/s2pin.py` (REUSE the chain data and the two independent `w(R)`
code paths — 47 736 cases, 0 mismatches — do not rewrite them);
`STAGE2_SECOND_ORDER` (sealed second-order constraints; the packet is
`goal_runs_20260811/STAGE2_SECOND_ORDER/`).

1. Inventory the 22 immune rows by CENTER orbit (A4-points, C5-points,
   D10-points, C11-points) with their chains `(a_k; c_1, c_2, …)`.
2. Enumerate joint `μ`-assignments per center orbit — one `μ`-sequence per
   center, shared by every row over it — subject to the sealed constraints:
   `μ ≥ 2` at A4-points; the C6-point exclusion at `μ = 3`; `μ ≥ 1` at
   C11-points when `d` is a non-residue or `0 mod 11`; `5 ∤ μ` when
   `5 | d`; and the `μ_l = 0` collapse rule of Theorem 1.2 (defined and
   non-zero at the center ⟹ every stratum above takes the single value
   `T(p₀)`). Truncate each `μ_l` at the period of its weight contribution
   (values depend on `μ_l` only mod `n/gcd(c_l, n)`); record the truncation.
3. For each residue `d mod 330`, output
   `F_odd(d) = #{distinct joint value-vectors of the 22 rows}` and the
   vectors themselves (machine-readable, `results/`).

Anchors: with sharing DISABLED the counts must reproduce `3⁸` on the
A4-block and single-pattern C5/C11 blocks, matching `STAGE2` §4 exactly;
Theorem 4.1's residue-wise consistency must reproduce with sharing off.

## C. Phase 2 — the global join

Join, per residue class (mod 330 is enough; state if a finer lattice is
forced): the corrected σ-band patterns (regenerate via
`STAGE1_STRATIFIED/scripts/`), the D10-line branch with its `μ₁` taken from
Phase 1's assignment at the D10 centers, and the Phase-1 value-vectors —
imposing every shared-value incidence from the order-0 lattice (the 145
closure relations; reuse the Layer-3 machinery in
`STAGE1_COMPLEX_MAPS/scripts/s1coherence.py`, corrected semantics from
`STAGE1_STRATIFIED/scripts/s3jet.py`). `Z⁺` rows (the C2-line, the two
one-parameter families) enter with their value menus and any incidence
constraints their closures impose; document which relations actually bind.

Output: `G(d mod 330)` = the exact global order-0+pinning pattern count,
replacing the product formula, plus per-residue factorization diagnostics
(how far below `K × D10 × 3⁸` the truth sits, and which mechanism cut it).
Report `G` at the residue of `d = 35` (35 mod 330) prominently — it is the
r-list size for the pair attack.

## D. Levels, stakes, framing (mandatory)

The pinning inputs are stated for a REDUCED lift (STAGE2 §0), so
everything here is **map-level**: a residue with `G = 0` would exclude
minimal-presentation maps at that residue — it does NOT feed the
tuple-level transport pairing (`theory/EXCLUSION_TRANSPORT_20260811.md`
§6) without the `Φ_J`-closure upgrade (note §8.4), and you must say so.
Any `G(ρ) = 0` is FLAGGED, NOT CLAIMED, with an ODDZERO-standard
adversarial audit named as the promotion gate. Headline fixed: "Problem E
remains OPEN; this packet excludes no degree."

## E. Packet protocol

`goal_runs_20260811/GLOBAL_COHERENCE/` with `THEOREM.md` (main document —
the harness refuses the name `REPORT.md`; ≤ 500 lines), `scripts/`,
`results/`, replayable `verifier.py` (check groups: chain/weight replay
against s2pin, sharing-off anchors, Thm 4.1 reproduction, join anchors —
trivialized join must reproduce the corrected `K`; cross-prime), and
`REGISTRATION_SNIPPET.md` (ODDZERO snippet format, `entry: E56`,
`kind: goal_run`, `tracked: true`). Honesty tiering; exit ledger
(`GLOBAL-COHERENCE-*`); "Not claimed" section. Do not commit; leave the
tree for the director. Print a ≤ 30-line summary: `F_odd` profile, `G`
table highlights, `G(35 mod 330)`, verifier totals, flags.
