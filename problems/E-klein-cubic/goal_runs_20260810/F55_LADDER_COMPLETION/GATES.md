# The remaining exact gates, enumerated before running anything

Everything below is read off the four audit documents on the PR #7 line
(`F55_AUDIT_20260808.md`, `F55_POLAR_CIRCUIT_PROOF_REDUCTION_20260808.md`,
`F55_COVERAGE_C_ADJUDICATION_20260808.md`,
`F55_REPLACEMENT_OBSTRUCTION_20260808.md`) together with the packet
`goal_runs_after_88f0967/FIX_VIII_A5LADDER/` and Note IX Sec 8.8.  Anything not
listed here is out of scope for this branch.

## A. The A5 landing ladder — packet `FIX_VIII_A5LADDER`

Decides: is there a nonzero A5-equivariant `T : W -> W` of degree `d` with
`F(T) == 0`?  Such a `T` is an `L11`-point of the twisted cubic and collapses
the descent gap from 55 to 11.  The ladder was specified for `d = 2..12` at
`p = 67` and `p = 199`.  `d = 2..10` are finished at both primes (all branch
cones EMPTY).  The remaining gates are:

| gate | branches | Galois orbits | rep dimensions (multiplicity) | certificate marker | a-priori size |
|---|---|---|---|---|---|
| `d = 11, p = 67` | 80 | 30 | 45, 41(k=3), 39x9, 33x9(k=3), 22, 18x9 | `CHECK land_d11_p67 PASS` | quadric space 1035 at the top branch; cubic system in 45 unknowns, ~40 MB msolve input |
| `d = 11, p = 199` | 80 | 50 | 45, 41x3, 39x9, 33x27, 22, 18x9 | `CHECK land_d11_p199 PASS` | same, ~42 MB |
| `d = 12, p = 67` | 25 | 11 | 60, 59(k=3), 55(k=3), 54x4, 49(k=3), 31, 30(k=3), 25 | `CHECK land_d12_p67 PASS` | quadric space 1830 at the top branch; ~126 MB msolve input |
| `d = 12, p = 199` | 25 | 25 | 60, 59x3, 55x3, 54x10, 49x3, 31, 30x3, 25 | `CHECK land_d12_p199 PASS` | same |

Per-branch verdict vocabulary already in the packet: `EMPTY`,
`EMPTY-ALL-CUBICS`, `EMPTY-QUADRICS`, `EMPTY-QUADRICS-GB`, `EMPTY-IDENTITY`,
`EMPTY-SUBSPACE`, `EMPTY-GALOIS-CONJUGATE`, `ZEROMAP`; failure vocabulary
`HIT`, `UNDECIDED-TIMEOUT`.  Packet exits: `FIX-VIII-A5LADDER-HIT-D<d>` /
`FIX-VIII-A5LADDER-EMPTY-THROUGH-12` / `FIX-VIII-A5LADDER-DEVIATION`.

## B. The F55 landing ladder — Note IX Sec 8.8

Decides: is there a nonzero F55-equivariant `T : P(W) --> X` of degree `d`?
In the Klein normalization every character of F55 is trivial on `C11`, so
`T_i = omega^(s i) shift^i(T_0)` for a twist `s` in `Z/5`, and the landing
condition `F(T) = 0` is a cubic system in the `n_d` coefficients of `T_0`.
Note IX records `d = 2, 3, 4, 5` EMPTY and gates the ladder at `d = 7`.  The
remaining gates are:

| gate | unknowns | cubic generators | certificate marker | a-priori size |
|---|---|---|---|---|
| `d = 6`, twists `s = 0..4`, `p = 661` | 19 | 640 | `LADDER d=6 s=<s> ... EMPTY`, i.e. the reduced GB has a pure power of every variable as leading monomial | 220-250 KB msolve input per twist |
| `d = 7`, twists `s = 0..4`, `p = 661` | 30 | 1125 | `LADDER d=7 s=<s> ... EMPTY` | ~900 KB msolve input per twist |

`d = 6` is the rung the wave-32 status commit recorded stopped-not-finished:
the Macaulay2 form (`saturate(I, ideal vars R) == ideal(1_R)`) was killed after
~45 h CPU on `s = 0` and left no output.  `d = 8` and beyond are explicitly
outside the stop-rule gate and are NOT run here.

## C. The coefficient (polar-circuit) obstruction — no gate remains

`F55_POLAR_CIRCUIT_PROOF_REDUCTION_20260808.md` reduced the all-degree
coefficient obstruction to a computational DAG `C0` (compiler regression),
`C1` (polar determinant and binomial holonomy), `C2` (exact saturation on
surviving cores), gated behind a non-CAS theorem, "Coverage Theorem C".

`F55_COVERAGE_C_ADJUDICATION_20260808.md` then withdrew Coverage C: under its
natural reading its fourth alternative is exactly the assertion that the
exact-support torus is empty, so the statement is equivalent to F55
pointlessness itself, and under the uniform reading no bound was ever stated.
The adjudication's own status markers are

```text
F55-PC-CHEAP-COVERAGE-REFUTED
F55-PC-HIGHER-CIRCUITS-PASS
F55-PC-COVERAGE-C-EQUIVALENT-TO-HEADLINE
```

Consequently **there is no finite reduced gate list on this line**: `C0`-`C2`
are per-support checks with no universal quantifier attached, and running more
of them cannot close the branch.  Nothing from family C is run on this branch.
The two higher-circuit identities the adjudication contributed, (2.2) and
(4.1), are already verified by
`director_probes_20260808/f55_coverage_c_adjudicate.py`
(`F55_COVERAGE_C_ADJUDICATION_OK`) and are not re-run.

## D. Explicitly out of scope

`F55_AUDIT_20260808.md` Sec 2.5 also reports a separate commutative
reconstruction of the F55 landing equations whose **support** system (a binary
MILP, not the coefficient system above) is infeasible at `d = 6, 8, 9`,
certified at `d = 7`, and undecided at `d = 10`.  That is a different object
from the ladder in family B -- it decides supports, not coefficients -- and its
`d = 10` item is not on any reduced gate list, so it is not run here.
