# WORKORDER — L12 machine phase, order 11 (refereed formulas only)

Issued 2026-08-12 (director). python3 only (never gap/gp/sage/magma —
shell aliases trap); exact cyclotomic arithmetic in Q(zeta_11) (sympy or
hand-rolled Z[x]/(Phi_11) with Fraction coefficients — NO floating
point); no git; packet `goal_runs_20260812/L12_ORDER11/` only.

Authority: `theory/GLOBAL_LOCALIZATION_LEDGER_20260812.md` WITH ITS §8
REFEREE CORRECTIONS (contribution `w/det(1 − dg|T)`; denominators
`Π_{k'∉{j,j+1}}(1 − ζ^{a_{k'} − a_j})`; the localized k = 0 sum rule
`Σ_j (tr_j − 1)/D_j = 0` as the FIRST target; derived-fiber flag). Read
also: `goal_runs_20260810/STAGE2_ODD_ORDER_PINNING` (the chain data
defining each pattern's order-11 tower — reuse s2pin's chains),
`goal_runs_20260812/D35_EXTENDED_SIEVE` + `D35_AUDIT` (the canonical 22
and the census), `goal_runs_20260812/L12_REFEREE` (the conventions you
must match — its verifier has the spot checks).

Tasks:
1. Implement the order-11 tower localization sum for a pattern's chain
   data (values, μ-chains) under the corrected conventions; verify the
   pattern-free anchor: the untwisted total over P⁴'s five points equals
   1, and after any test blowup sequence still equals 1 (the k = 0
   Z-side sanity).
2. **Genus-0 closed test** (fiber traces = their genus-0 values) for
   k = 0, 1, 2, 3 against each of the 22 cells' order-11 data at d = 35
   (residues: 35 ≡ 2 mod 11, all five source points based, μ ≥ 1): which
   cells FAIL the identity in the genus-0 branch (= that branch of C14
   is dead for them — state exactly this, no more); cross-check the
   k = 0 sum rule first.
3. The bounded fiber-trace menus (traces in Z[ζ] constrained by C7
   Riemann–Hurwitz for 11-curves — derive the finite menu honestly; if
   the menu is not finite without a genus bound, say so and bound by the
   C1 genus identity's value at d = 35): which cells survive NO menu
   entry (dead outright at order 11) versus survive some (record which).
4. All-degree probe: the same test with the residue data symbolic
   (d mod 11 ∈ QR/NQR/0 branches) — state which verdicts are class-wide.
Flags 1–5 of the note bind: carry the Stein-degree and derived-fiber
unknowns explicitly where they enter; never assume them away silently.

Framing: map-level; headline "Problem E remains OPEN; this packet
excludes no degree"; any all-branch death of a cell is a closed verdict
(state plainly); an all-22 death is FLAGGED behind an ODDZERO-standard
audit. Packet protocol as always (THEOREM.md — never REPORT.md —
scripts/, results/, replayable verifier.py, REGISTRATION_SNIPPET.md,
ODDZERO format, entry E56, goal_run, tracked true; tiering; exits
`L12-O11-*`; "Not claimed"). Summary ≤ 25 lines: anchor status, k = 0
sum-rule results, genus-0 verdicts per cell, menu verdicts, class-wide
statements.
