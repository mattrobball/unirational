# Nonverdict computation ledger

None of the runs in this file is used as theorem evidence.

## Full 43-variable homogeneous F4

The border-ordered input was stopped after 1345 seconds.  Its runner report is
`landing_746_msolve_result.json` (`returncode=-15`, no leading output).

The standard-coordinate input completed degree four and one degree-five
block.  The degree-five matrix was `71471 x 1025063`; it took 2322.93 seconds,
added 512 basis elements, and had zero zero-reductions.  The next block opened
with 180898 queued pairs.  This measured rate made the bounded direct route
infeasible, so the process was terminated.  `landing_746_standard_msolve.log`
is a resource log only.  No missing solver output or truncated Hilbert
function is interpreted as emptiness.

## First boundary saturation

The first q-then-b Singular process on the 48 contracted equations terminated
without writing `syzygy_r48_boundary_singular_result.txt`.  It is therefore a
nonverdict regardless of why the process ended.  The controlled replacement
uses the equivalent b-then-q double saturation, a captured log, and explicit
time/RSS fencing.

## Structured boundary saturation floor

Exact b-then-q sequential saturation was tested on 43, 48, 96, and 256
verified syzygy contractions.  A standard affine-cover variant with
`b1_0=1` was also tested.  None returned the first saturated basis or wrote a
result file.  The strongest 256-equation run was interrupted after
`2572.24 s` wall / `1812.78 s` user CPU with sampled RSS `10710720 KiB`.

The exact scripts, hashes, and measurements are in
`saturation_attempts.json`.  All statuses are `incomplete_nonverdict`.
Neither a missing result nor an interrupted standard-basis computation is
used to infer emptiness.
