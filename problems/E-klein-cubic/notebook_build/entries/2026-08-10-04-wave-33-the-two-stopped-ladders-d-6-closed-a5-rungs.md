## 2026-08-10 Wave 33 — the two stopped ladders: d = 6 closed, A5 rungs 11 and 12 boxed

Packets: `goal_runs_20260810/F55_LADDER_COMPLETION/` (new) and
`goal_runs_after_88f0967/FIX_VIII_A5LADDER/` (closed in place).
Problem E remains **OPEN**.

```text
F55-LADDER-D6-EMPTY-ALL-TWISTS
F55-LADDER-D7-UNDECIDED
FIX-VIII-A5LADDER-EMPTY-THROUGH-10
FIX-VIII-A5LADDER-D11-D12-UNDECIDED
F55-PC-COVERAGE-C-EQUIVALENT-TO-HEADLINE
F55-QUESTION-OPEN
```

Two "running" flags recorded in wave 32 and earlier were both dead. Wave 32
already annotated the F55 ladder's `d = 6` rung as stopped-not-finished; the
A5LADDER packet was never annotated at all and still read IN-FLIGHT /
PROPOSAL-UNRUN / `Exit: PENDING`. Both are now resolved, one by a verdict and
one by a boxed statement.

**The F55 ladder rung `d = 6` is EMPTY at all five twists, in characteristic
zero.** The Macaulay2 form of the question — `saturate(I, ideal vars R) ==
ideal(1_R)` on 640 cubics in 19 unknowns over `F_661` — was killed after ~45 h
CPU on `s = 0` and left no output. The same ideals, re-derived from the F55
combinatorics by an independent implementation and handed to msolve's F4
instead, return in 248–430 s per twist. In every case the reduced
graded-reverse-lex Groebner basis is exactly `(c0,...,c18)`: not merely a
saturation statement, the landing ideal *is* the irrelevant ideal, so the only
solution is the origin. `check_against_m2.py` verifies term for term that the
systems solved are the same ideals the M2 scripts asked about, at `d = 3, 4,
5, 6` and all five twists; `d = 3, 4, 5` reproduce Note IX's asserted verdicts
in under a second each. A second prime `p = 1301` repeats `d = 6`. The
characteristic-zero claim rests on properness — `V(I)` is closed in `P^18`
over `Z[zeta_5]`, so an empty fibre at one good prime forces an empty generic
fibre — not on the two primes. Consequence: there is no F55-equivariant
rational map `P(W) --> X` of degree at most 6.

**The `d = 7` rung is `F55-LADDER-D7-UNDECIDED`, with its blowup point
recorded.** It is the last rung inside Note IX's own stop-rule gate, so it was
attempted: 30 unknowns and 1125 cubics, a 900 KB generator file. Twist `s = 0`
was run twice, 58 and 60 min wall, and neither returned; both `.out` files are
0 bytes, which under the landmine rule is an error and not a verdict. Twists
`s = 1..4` were not started. The blowup point is the jump `19 -> 30` unknowns:
the same F4 computation that finishes in 248-430 s at `d = 6` does not return
within an hour at `d = 7`. Per the stop-rule the rung is left there rather
than ground on. So this closes a rung, not the line.

**The A5 ladder is EMPTY and verified through `d = 10`, and stops there.** The
interrupted session had finished `d = 2..10` at both primes; the independent
verifier — which rebuilds the group, the A5, the covariant spaces and the
branch decomposition from scratch with different seeds and lands on every
branch rather than one per Galois orbit — is ALL PASS at `VDMAX=10`. Scope is
mod `p` at 67 and 199, as the manifest already declared for this packet.

`d = 11` and `d = 12` are undecided, and the stopping point is measured rather
than asserted. The packet's decisive tool below `d = 11` is a pure
linear-algebra certificate: the second-order landing quadrics span every
quadric in the branch coordinates. A new census script runs that certificate
on every branch with no Groebner basis at all:

```text
d = 10  top branch dim 19   quadric rank  190 / 190   certificate fires
d = 11  top branch dim 45   quadric rank  291 / 1035  deficit  744
d = 12  top branch dim 60   quadric rank  398 / 1830  deficit 1432
```

The rank is a property of the branch, not of the sampling — 400, 800 and 1600
points give the identical rank — so this is a proof that the certificate
cannot fire from `d = 11` on at any budget: `0 of 80` branches at `d = 11` and
`0 of 25` at `d = 12` are settled by it. The required span grows like `r^2/2`
while the available second-order rank grows roughly linearly in `r`. msolve
does not cover the gap: the top `d = 11` branch times out at the packet's
900 s cap on both the quadrics-only system (291 quadrics, 45 variables) and
the mixed cubic system (40 MB generator file) at both primes, and an uncapped
run was stopped after 48 min wall, 60 min CPU and 8.6 GB resident with no
output. The all-cubics certificate would need at least 16215 sample points and
a dense 16215-column elimination. The brief's exit
`FIX-VIII-A5LADDER-EMPTY-THROUGH-12` is therefore **not** claimed.

**No gate was run on the coefficient (polar-circuit) line, by adjudication
rather than by cost.** `F55_COVERAGE_C_ADJUDICATION_20260808.md` withdrew
Coverage Theorem C: under its natural reading its fourth alternative is exactly
the assertion that the exact-support torus is empty, so the statement is
equivalent to F55 pointlessness itself, and under the uniform reading no bound
was ever stated. The `C0`–`C2` pipeline survives as a producer of short
certificates for individual supports and carries no universal quantifier, so no
finite number of runs on that line can close the branch. This is recorded in
`GATES.md` Sec C so that a later reader does not mistake "not run" for
"not yet run".

The interrupted session's uncommitted working tree was adjudicated file by file
against `main` before anything was taken; `PROVENANCE_20260810.md` records each
decision. Its four 0-byte-output msolve artifacts at `d = 11, 12` were
rejected — under the packet's own landmine rule a 0-byte output is an error,
not a verdict — and are the record of where the session died, not results.

`verifier.py` (VDMAX=10, both primes) and `scripts/check_manifest_parity.py`
both pass. The work is on `agent/f55-ladder-completion-20260810`, draft PR #25.
This notebook revision was authored against parent head
`b011091f50db52de98adc7c9b7cec94624a404a7`.
