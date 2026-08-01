Q-UNDECIDED

# Generic Schur index-one descent: exact isolated status

## Binary verdict

Neither binding headline statement has been proved:

`X_Schur(K_Schur) != empty`

and

`X_Schur(K_Schur) = empty`.

Consequently this packet does not claim that the requested complete
resolution has been achieved.  The standard Picard, Albanese, Brauer,
higher-Amitsur, stable-cohomology, and ten genus-one-fibration branches remain
nonterminal for the reasons audited in `WORKLOG.md` and in the governing
repository.

## Persistent-goal status

`COMPLETION_AUDIT.md` verifies every binding positive and negative acceptance
item against the refreshed live worktree.  The same missing binary theorem
has recurred for at least three consecutive goal turns, and no current
bounded solver or sibling route can cross the all-degree/full-twist boundary.
The persistent goal is therefore **blocked, not complete**.  `Q-UNDECIDED`
remains the mathematical packet verdict.

## Exact advances in this packet

1. `QUARTIC_FRONTIER.md` proves

   `X_Schur(K_Schur) != empty OR X_Schur has an integral degree-4 point`.

   In the no-point branch the quartic residue extension is primitive and its
   Galois closure has group `A4` or `S4`; moreover the quartic point must span
   the full cubic-surface hyperplane `P3`.  It therefore lies on a
   `K_Schur`-defined twisted cubic whose no-point intersection ledger is one
   integral quartic plus one integral quintic.  This is the exact surviving
   descent boundary, not a rational point.
2. `QUARTIC_TANGENT_AUDIT.md` tests the natural twisted-cubic operation that
   is tangent at all four conjugates.  The tangent-curve scheme and its
   residual points can both be primitive `S4` quartics, and exact smooth
   counterexamples have noncoplanar residual quartics.  A separate exact
   degree-24 splitting-field calculation starts with a genuinely primitive,
   linearly independent `S4` input quartic and again obtains a noncoplanar
   residual.  Thus neither the operation nor primitivity automatically lowers
   the degree.
3. `FULL_FRAME_R8_REPORT.md` excludes the complete five-coordinate scalar
   `R8` frame ansatz in characteristic zero.
4. `FULL_FRAME_R10_REPORT.md` excludes the analogous complete `R10` ansatz;
   its good-fibre landing equations have the same rank-700 row space as the
   `R8` equations.
5. `FULL_FRAME_R12D5_REPORT.md` excludes one explicit 25-variable,
   five-dimensional scalar slice inside the 14-dimensional `R12` space.

All three computational results are bounded coefficient-space theorems.
They do not imply that the full twist is pointless and do not provide an
all-height cutoff.

## Isolation and live-repository boundary

This run writes only below
`Q_SCHUR_DESCENT_CODEX_ROOT_20260801_5F31/`.  The conventional shared folder
`Q_SCHUR_DESCENT/` was modified by another worker during this run and is used
only as read-only evidence.  The isolation waypoint was commit
`80f24697dd8fcb1ee0e8fff86e3d8e38a9cfc09c`; the later live audit through
`53e267a` added no Q-terminal theorem.

## Smallest honest successor

Either force the primitive, linearly independent `A4/S4` quartic into a
quadratic tower or a special Schur incidence that lowers degree, exclude it
on the genuine twist, exploit its canonical integral `4+5` twisted-cubic
intersection, or produce a verified landing covariant in the full non-scalar
Schur module.  A bounded support failure is not a substitute for either
theorem.
