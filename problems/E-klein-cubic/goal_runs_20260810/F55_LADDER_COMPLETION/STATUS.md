# F55 ladder completion — status

**Date:** 2026-08-10
**Branch:** `agent/f55-ladder-completion-20260810`
**Gate inventory:** `GATES.md` (written before anything was run)
**Companion packet:** `goal_runs_after_88f0967/FIX_VIII_A5LADDER/`
(the A5 ladder; its `PROVENANCE_20260810.md` records the salvage of the
interrupted session and `REPORT.md` its verdicts)

Problem E remains **OPEN**.

```text
F55-LADDER-D6-EMPTY-ALL-TWISTS
F55-LADDER-D7-UNDECIDED
FIX-VIII-A5LADDER-EMPTY-THROUGH-10
FIX-VIII-A5LADDER-D11-D12-UNDECIDED
F55-PC-COVERAGE-C-EQUIVALENT-TO-HEADLINE
F55-QUESTION-OPEN
```

Overall exit for this branch: **`F55-LADDER-PARTIAL`** — one gate family
(`d = 6`, five twists, two primes) run to completion with a verdict, the rest
stopped at recorded blowup points.

## 1. The F55 landing ladder, rung d = 6 — CLOSED

Note IX Sec 8.8 left `d = 6` as the open rung of the F55 ladder.  Its
Macaulay2 form — `saturate(I, ideal vars R) == ideal(1_R)` on 640 cubics in
19 unknowns over `F_661` — was killed after roughly 45 h CPU on the `s = 0`
twist and produced no output; NOTEBOOK wave 32 recorded it
stopped-not-finished, with the phrase "`d = 6`: running" left in place.

The same ideals were re-derived here from the F55 combinatorics
(`scripts/f55_ladder_msolve.py`, an independent implementation) and handed to
msolve's F4 rather than to M2's `saturate`.

```text
LADDER d=6 s=0 p=661  n=19  cubics=640  OK  EMPTY  (247.6s)
LADDER d=6 s=1 p=661  n=19  cubics=640  OK  EMPTY  (267.1s)
LADDER d=6 s=2 p=661  n=19  cubics=640  OK  EMPTY  (284.2s)
LADDER d=6 s=3 p=661  n=19  cubics=640  OK  EMPTY  (358.4s)
LADDER d=6 s=4 p=661  n=19  cubics=640  OK  EMPTY  (430.4s)
```

In every case the reduced graded-reverse-lexicographic Groebner basis is
**exactly** `(c0, c1, ..., c18)`.  That is stronger than the saturation
statement the M2 script asked for: the landing ideal *is* the irrelevant
ideal, so the only solution is the origin and the projective cone is empty.
The bases are transcribed in `GB_CERTIFICATES.md`.

Three independent controls:

* `scripts/check_against_m2.py` compares the systems solved here with the
  ideals in the original `f55land_d<d>_s<s>.m2` artifacts term for term.
  `PASS` at `d = 3, 4, 5, 6` and all five twists (60/60, 160/160, 350/350,
  640/640 generators).  The verdicts therefore attach to the same ideals the
  killed run was asked about.
* `d = 3, 4, 5` reproduce the `EMPTY` verdicts Note IX asserts, in under a
  second each.
* A second prime `p = 1301` repeats `d = 6`.

**Characteristic-zero scope.**  This is a char-0 result from a single good
prime, not a two-prime mod-p result.  `V(I)` is a closed subscheme of
`P^18` over `Z[zeta_5]`, so the image of its structure morphism to
`Spec Z[zeta_5]` is closed.  An empty fibre over a prime means that prime is
not in the image; if the generic fibre were nonempty, the image would contain
the generic point and hence, being closed, the whole base — including that
prime.  So the generic fibre is empty.  The second prime is redundancy, not
the basis of the claim.

## 2. The F55 landing ladder, rung d = 7 — UNDECIDED, blowup point recorded

`d = 7` is the last rung inside Note IX Sec 8.8's own stop-rule gate, so it was
attempted.  The system is 30 unknowns and 1125 cubics over `F_661` — a 900 KB
msolve generator file, against 19 unknowns and 640 cubics at `d = 6`.

Twist `s = 0` was run twice.  Both runs were `msolve -g 2` on two threads, and
neither returned:

```text
run 1: 58 min wall, no output, terminated externally
run 2: 60 min wall, no output, terminated externally (before its own 3600 s cap fired)
```

The `.out` file is 0 bytes in both cases, which under the packet's msolve
landmine rule is an error, not a verdict; `GB_CERTIFICATES.md` records it as
`NO-OUTPUT`.  Per the stop-rule, the rung is left here rather than ground on:

```text
F55-LADDER-D7-UNDECIDED
```

with the blowup point being *this*: the same F4 computation that finishes in
248-430 s at 19 unknowns does not return within an hour at 30 unknowns, and
twists `s = 1..4` were not started.  Note that the jump `19 -> 30` unknowns is
also the jump at which the M2 form stopped being tractable at all.

## 3. The A5 landing ladder, rungs d = 11 and d = 12 — UNDECIDED, boxed

Full detail in the companion packet's `REPORT.md`.  Summary:

* `d = 2 .. 10` are EMPTY at both primes and the independent verifier is
  `ALL PASS` at `VDMAX=10`, re-landing on every branch rather than one per
  Galois orbit.  There is no nonzero A5-equivariant `T` of degree `<= 10`
  with `F(T) == 0` at either prime.
* `d = 11` and `d = 12` are UNDECIDED.  The stopping point is structural and
  measured.  The packet's second-order linear certificate needs the landing
  quadrics to span all `r(r+1)/2` quadrics in the branch coordinates; the
  achieved rank saturates far below that and is independent of the sample
  count (400, 800, 1600 points give the same rank):

  ```
  d=10 top branch dim 19  quadric rank  190 / 190   certificate fires
  d=11 top branch dim 45  quadric rank  291 / 1035  deficit  744
  d=12 top branch dim 60  quadric rank  398 / 1830  deficit 1432
  ```

  `0 of 80` branches at `d = 11` and `0 of 25` at `d = 12` are settled by the
  certificate at `p = 199`.  The required span grows like `r^2/2`, the
  available second-order rank roughly linearly in `r`.
* msolve does not cover the gap: the top `d = 11` branch times out at the
  packet's 900 s cap on both the quadrics-only system (291 quadrics, 45
  variables) and the mixed cubic system (40 MB input) at both primes, and an
  uncapped run was stopped after 48 min wall, 60 min CPU, 8.6 GB resident,
  with no output.

**The boxed remaining statement.**

> Is there a nonzero A5-equivariant `T : W -> W` of degree 11 or 12 with
> `F(T) == 0`?  Equivalently, is the landing cone empty inside each of the 80
> (resp. 25) branch subspaces of `M_11^{A5}` (resp. `M_12^{A5}`), the largest
> of dimension 45 (resp. 60)?  Deciding it needs a certificate that is neither
> the second-order quadric span (provably insufficient from `d = 11`) nor a
> Groebner basis of the sampled ideal in 45-60 variables (not returning at the
> effort spent).

A `HIT` at either degree would be a point of `X_tw` over the degree-11 field
and would collapse the descent gap from 55 to 11; emptiness at 11 and 12 would
only extend a bounded search, and the brief's own exit
`FIX-VIII-A5LADDER-EMPTY-THROUGH-12` is therefore *not* claimed.

## 4. The coefficient (polar-circuit) obstruction — no gate remains

Not run, by adjudication rather than by cost.  See `GATES.md` Sec C:
`F55_COVERAGE_C_ADJUDICATION_20260808.md` withdrew Coverage Theorem C after
showing that under its natural reading it is equivalent to F55 pointlessness
itself, and that under the uniform reading no bound was ever stated.  The
`C0`-`C2` pipeline survives as a producer of short certificates for individual
supports; it carries no universal quantifier, so no finite number of runs on
that line can close the branch.

## 5. What this does and does not change

**Closed.**  One branch of the coefficient obstruction is closed: the F55
landing ladder has no degree-6 solution, for any of the five projective
twists, in characteristic zero.  Combined with the `d = 2, 3, 4, 5` rungs this
means

> there is no F55-equivariant rational map `P(W) --> X` of degree `<= 6`.

The stale "`d = 6`: running" flag in Note IX Sec 8.8 and the wave-32
stopped-not-finished record are superseded by a verdict.

**Not closed.**  The headline is untouched.  Note IX's own stop-rule gates the
ladder at `d = 7`; degrees above that need a structural argument, and no such
argument exists.  A bounded ladder cannot become an all-degree theorem, which
is the same boundary the Coverage-C adjudication drew for the polar-circuit
line.  The A5 route is likewise open at `d = 11, 12`.

So:

```text
F55-QUESTION-OPEN
TRACE-CUBIC-K-POINT-UNDECIDED
V14-F55-UNIRATIONALITY-UNDECIDED
```

unchanged.  What this branch changes is the bookkeeping: two rungs that were
recorded as "running" were in fact dead, and one of them now has a verdict.
