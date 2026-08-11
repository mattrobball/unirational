## 2026-08-11 Correction and completion at d=35: the all-dead census is retracted; the sound count is 756 blueprints down to 22 explicit survivors

CORRECTS the previous entry (value-layer engagement). Documents:
`goal_runs_20260811/PAIR_ATTACK_D35/WORKED_EXAMPLE.md` section 6 and
THEOREM.md section 12; scripts `director_finish_d35.py`,
`director_survivors22.py`. Both primes, all numbers identical,
saturation-checked. Problem E remains **OPEN**; degree 35 is NOT closed.

The retraction, plainly: the census killed blueprints for insisting on a
nonzero surface reading at places where every candidate's surface reading
vanishes. That reasoning is only correct where a deeper reading CHANGES
the demanded value -- which happens exactly at the six locations already
flipped by every blueprint, and nowhere else. Elsewhere the value is the
same at every depth, so a vanishing surface reading means "delivered
deeper", not "impossible". The "all 756 dead" headline is withdrawn; the
previous entry's flagged status did its job.

What stands, and what is new and sound:

- the universal cut (six forced flip equations, rank 2: every cell is at
  most 37-dimensional), with its 3,822 + 702 correctness checks per prime
  and the sealed rank-2 anchor reproduced ambiently;
- the vanishing table, reinterpreted correctly: at 14 of 18 value-carrying
  locations on the plus-row, readings live strictly deeper for every
  candidate (a realization constraint, not a value contradiction);
- NEW (the finisher): vanishing to order >= 2 along the 55 special lines
  is IMPOSSIBLE in the 39-dimensional space -- imposing it leaves
  dimension exactly 0 (rank 39, saturated, both primes). Every blueprint
  whose line-row branches all demand order >= 2 dies with certainty:
  **398 of the 420**;
- the 22 blueprints with an order-0 line branch survive; their line
  assignments add no further certain demands; each cell stands at
  dimension <= 37.

Final census at degree 35 this session: **336 dead (vanishing orders) +
398 dead (order-2 line vanishing impossible) + 22 LIVE** -- from 756 cells
to 22, entirely by closed, twice-computed, saturation-checked linear
algebra with no depth-parity caveats.

Next cycle (defined in THEOREM.md section 12.4 and the handoff): the
ODDZERO-standard adversarial audit of the two new impossibility tables
and of the corrected depth-parity semantics; the content-addressed
linkage repair; then the open-condition and realization layers (C4/C6
jets, dominance) on the 22 cells.

Exits: none new (corrections and certain kills recorded inside the
PAIR_ATTACK_D35 packet; the window statement is unchanged).
