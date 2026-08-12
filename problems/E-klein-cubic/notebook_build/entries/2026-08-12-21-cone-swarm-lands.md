## 2026-08-12 The cone swarm lands: the degree-35 landing cone bounded to dimension 9, the director's own probes audited, and the comparison nobody had made

Fourteen packets, all director-replayed ALLGREEN, from a swarm run
against director-pinned specifications. Problem E remains **OPEN**; no
degree is excluded.

**The landing cone at d = 35.** `CONE_LADDER_D35`: free rungs (where the
restricted cubics span all of Sym^3, so every t_i^3 is in the ideal and
the section locus is trivial with no solving) give dim V <= 18; msolve
rungs at m = 20, 24, 28 give **dim V <= 9 at both primes**. The sealed
record had only <= 33 this morning. `CONE_CROSSPRIME` reproduces the
director's single-prime results at 661 with no prime-dependence.
`CONE_D36` shows the instrument transfers to the next window (<= 34
there). The enabling lesson, now pinned in
`DATA_SPEC_CONE_SWARM_20260812.md`: use the FULL generator span,
never a subset -- for m cubics in 37 variables the degree of regularity
is 21 at m = 55, 7 at m = 520 (why the sealed attempt walled) and 5 at
m = 1380; with the full span an m = 20 rung finishes in seconds.

**The director's own probes audited.** `CONE_PROBE_AUDIT` rebuilt them
independently: R1/R2 confirmed, R3 corrected with the conclusion intact
(the free argument needs no genericity hypothesis), the
degree-of-regularity redirect confirmed. The director's claims of the
day survive an outside rebuild.

**The comparison nobody had made** (`CONE_VS_PATTERN`, prompted by the
user): the landing cone had been bounded with no reference to the
boundary-pattern data at all. A cone point is a counterexample only if
it realizes one of the 22 patterns, which requires that pattern's OPEN
demands -- readings required NONZERO -- to hold. Those demands are
vacuous on the ambient 37-cell and were therefore never imposed
anywhere; on the cone they need not be. The packet finds five linearly
distinct open-demand forms identically zero on the cell, hence on V, and
concludes under the sealed demand semantics that all 22 patterns are
unrealizable -- which would exclude d = 35 WITHOUT deciding emptiness,
a strictly weaker and cheaper target. **FLAGGED, not promoted.** The
director's adjudication names the one audit question: the vanishing is
established at jet levels 0-3, level 4 being excluded because it fails
transverse rigidity, and a non-rigid level is not a level where no value
exists -- it is a level where the character rule does not pin the value.
That is precisely the failure mode of this morning's retraction, one
level up.

**Also landed:** the Burnside and G-unirationality assessments (what
those literatures obstruct versus what this campaign needs), the V14
positive flank, the carrier gateway at the live window, the Smith
branches at orders 2 and 3, the deformation-theory item C6 that every
packet had deferred, the dominance minor test, the point-hunt
contingency pipeline, and the per-cell realization synthesis.

Exits: `CONE-LADDER-D35-DIM-LE-9`,
`CONE-CROSSPRIME-NO-PRIME-DEPENDENCE`,
`CONE-VS-PATTERN-22-DEAD-FLAGGED`,
`CONE-PROBE-AUDIT-DIRECTOR-CLAIMS-STAND`,
`CONE-D36-INSTRUMENT-TRANSFERS`, `CELL-SYNTHESIS-PER-CELL-VERDICT`,
`DOMINANCE-D35-MINOR-TEST`, `CARRIER-D35-GATEWAY`,
`BURNSIDE-ASSESS-VERDICT`, `GUNIRATIONALITY-FRAMING`,
`V14-POSITIVE-INGREDIENT`, `SMITH-ORDERS-23`, `POINT-HUNT-PIPELINE`,
`TANGENT-C6-DEFORMATION`.
