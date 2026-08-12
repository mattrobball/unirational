## 2026-08-12 Cycle 5 dispatched: the landing system moves to invariant coordinates, and the transport program takes its first live shot

Problem E remains **OPEN**. Dispatch record plus one director probe.

Probe (`director_probes_20260812/`): every landing equation on a window
cell lands inside the degree-3d INVARIANTS, so the Molien engine bounds
the cubic span: `P3(d) <= I(3d)`. At d = 35 the ceiling is `I(105) =
8555` against the observed span 1380 -- far from attained, so no clean
closed form yet (the 7759-dimensional cubic kernel is an open structural
question), but the practical payoff stands: the invariant-side ambient
(8555 at 35; 9545 at 36 versus 43680 raw) is the right coordinate system
for the stalled Hilbert ladder.

- `WORKORDER_LANDING_INVARIANT_SIDE.md` (lane A): rebuild the sampled
  landing system in invariant coordinates; reproduce P3(35) = 1380 as
  control; make P3(36..38) exact where the sweep walled; push HF(4) at 35
  toward exactness; timeboxed look at the kernel question.

- `WORKORDER_TUPLE_JOINT_RESIDUE.md` (lane B, the strategic one): join,
  at TUPLE level only, the corrected sigma-band with the newly audited
  cone-order layer (ord >= 6 on the V4-lines, tuple-level at every
  degree), the parities, and the sealed depth table -- per residue class
  mod 6, all-degree semantics via saturation. The corrected sigma-band
  alone has no zeros; the join is the first computation that could
  produce a tuple-level class-at-infinity zero, and by the transport
  note's Corollary 3.4 (quintic invariant, unconditional) a single such
  zero -- surviving an ODDZERO-standard audit -- closes Problem E.
  Extraordinary-claims discipline is written into the brief: any zero is
  flagged, never claimed, audit named as gate, no map-normalized layer
  (STAGE2 pinning) may enter the join.

Exits: none (dispatch record).
