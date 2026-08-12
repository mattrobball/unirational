# WORKORDER — The equivariant ramification complex (morphism ledger L8)

Issued 2026-08-12 (director). python3 only (never gap/gp/sage/magma —
shell aliases trap); primes 331, 661 for any modular checks (the core is
character arithmetic, prime-free); no git; packet
`goal_runs_20260812/RAMIFICATION_COMPLEX/` only.

## A. The layer

For each source stratum `S` (census row) with stabilizer `Γ_S`, the
morphism carries a NORMAL response: the `Γ_S`-equivariant map of normal
cones `N_S → N_{τ(S)}`. Its combinatorial shadow: each conormal
character `χ` of `S` (the census/frame data give the character
decomposition of the normal directions) is sent, at its leading order
`k_χ ≥ 1`, into normal characters `χ′` at the value satisfying the
weight rule `χ′ = ψ_S · χ^{k_χ} · (slot factors)` — the master weight
formula generalized from point strata (STAGE2 §1.2) to ALL strata, per
character. Additionally the RECEIVER side constrains: at values that are
special points of `X`'s stratification, the arriving 2-jet must lie in
the tangent cone of `X` there compatibly with the receiver's character
decomposition (`RECEIVER_LEDGER_X` data).

So far the campaign used: the numeric shadow (`m_E` in the C1 ledger,
map-level) and the point-strata case (Stage 2, reduced lifts). The
per-character, per-stratum tables at TUPLE level have never been
enumerated. They are finite character arithmetic.

## B. Tasks

1. For every sweep-capable row and every immune row of the census:
   tabulate the conormal character decomposition (from the frames) and,
   for each value option the J census allows the row, the set of
   admissible `(χ ↦ χ′, k_χ)` assignments under the weight rule and the
   receiver's character table at the value. State the general rule as a
   lemma (tuple level: the leading normal jets of any landing tuple obey
   it — prove via the same equivariance argument as Thm 1.2, quoting it).
2. Receiver tangent-cone layer: at type-I/II vertices and the `X^{C6}`
   points, intersect the admissible `χ′` sets with the tangent-cone
   character data of `X` at those points (compute the tangent cone of
   the Klein cubic at each special point in its eigenframe — machine).
3. JOIN: add the admissible-ramification tables as a new layer on the
   tuple-level J census (`TUPLE_JOINT_RESIDUE` semantics): per residue
   mod 6, the joint count before/after. All-degree verdicts. A class
   ZERO is the transport scenario: FLAG, never claim, ODDZERO-standard
   audit named as gate.
4. Degree-35 application: effects on the 22 (anchor discipline; any
   death is a closed character-incompatibility — state the mechanism).

## C. Framing

Headline: "Problem E remains OPEN; this packet excludes no degree."
Packet protocol as always (`THEOREM.md` — never REPORT.md — scripts/,
results/, replayable `verifier.py`, `REGISTRATION_SNIPPET.md`, ODDZERO
format, entry E56, goal_run, tracked true; tiering; exits
`RAMCX-*`; "Not claimed"). Summary ≤ 25 lines: per-row table sizes, J
before/after per class, effects at 35.
