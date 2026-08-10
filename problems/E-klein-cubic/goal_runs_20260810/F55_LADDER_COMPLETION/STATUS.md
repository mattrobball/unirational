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
F55-LADDER-D7-<pending>
A5-LADDER-EMPTY-THROUGH-10
A5-LADDER-D11-D12-<pending>
F55-PC-COVERAGE-C-EQUIVALENT-TO-HEADLINE
F55-QUESTION-OPEN
```

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

## 2. The F55 landing ladder, rung d = 7

(pending)

## 3. The A5 landing ladder, rungs d = 11 and d = 12

(pending)

## 4. The coefficient (polar-circuit) obstruction — no gate remains

Not run, by adjudication rather than by cost.  See `GATES.md` Sec C:
`F55_COVERAGE_C_ADJUDICATION_20260808.md` withdrew Coverage Theorem C after
showing that under its natural reading it is equivalent to F55 pointlessness
itself, and that under the uniform reading no bound was ever stated.  The
`C0`-`C2` pipeline survives as a producer of short certificates for individual
supports; it carries no universal quantifier, so no finite number of runs on
that line can close the branch.

## 5. What this does and does not change

(pending)
