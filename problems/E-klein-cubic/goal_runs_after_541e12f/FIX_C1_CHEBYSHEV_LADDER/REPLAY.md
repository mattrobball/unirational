# Replay — FIX-C1

All exact, characteristic zero. `python3` + `sympy` only for the ladder;
Macaulay2 only for the obstruction locus of §3. No msolve, no GAP/Sage/Magma.
(`gap` and `gp` are git aliases in this repo and must not be invoked; the
absolute path `/opt/homebrew/bin/gp` is not used by this packet either.)

## 1. Verifier (the acceptance run)

```sh
cd goal_runs_after_541e12f/FIX_C1_CHEBYSHEV_LADDER
python3 verify_c1.py
```

Expected terminal line:

```
FIX_C1_VERIFY_OK
```

Runtime ≈ 10–20 min. The verifier rebuilds all four seeds, re-proves the
parameter split, re-derives the level operators from the **symmetric trilinear
polarisation** `Phi` (a different route from the producer's Taylor
derivatives), reduces with the rows in the opposite order, cross-checks every
rank modulo three primes at every point of the relevant part of `Spec R`, and
certifies the level-2 obstruction at the `K`-rational point with an explicit
**left-kernel functional** obtained from the transposed system. It also runs
the closed-form calibration ladder `p0 ∘ (id + eps·V)`, `V = (yz,zx,xy)`, which
must solve levels 0–3 identically for both seeds.

## 2. Producers

```sh
python3 produce_c1.py m1 0 A     # the (1,7) Chebyshev seed, lam = 1,  K-rational point
python3 produce_c1.py m1 0 B     #   "                              , c = c_0, P1 quadratic
python3 produce_c1.py m1 0 C     #   "                              , c quadratic, P1 = P1_0
python3 produce_c1.py m1 0 D     #   "                              , both quadratic
python3 produce_c1.py m1 1 A     # lam = om    block, K-rational point
python3 produce_c1.py m1 2 A     # lam = om^2  block, K-rational point
python3 produce_c1.py control    # the (3,6) D_B seed (T5 witness)
```

Each writes `payloads/LADDER_<tag>.json` + `.txt` and `logs/LADDER_<tag>.log`.
Runtimes on the machine used: control ≈ 10 min, part A ≈ 3 min (obstruction
found at level 2, so level 3 is not attempted), parts B/C/D ≈ 20–40 min.

Without the third argument, `produce_c1.py m1 <j>` runs on the **whole**
36-dimensional parameter ring; it deliberately aborts with
`c1_ring.ZeroDivisorPivot: column 14 has only zero-divisor entries` — that
abort *is* the discovery of the parameter split of §3 (the ladder differential
has non-constant rank over the nine-point scheme, so no unit pivot exists in
that column). The four parts A–D are the Galois-stable pieces on which the rank
*is* constant. `logs/LADDER_m1_lam0_pass1.log` keeps that abort.

## 3. Obstruction locus (Macaulay2)

```sh
python3 obstruction_locus.py m1_lam0_A
python3 obstruction_locus.py m1_lam1_A
python3 obstruction_locus.py m1_lam2_A
```

prints the five obstruction quadrics and runs
`m2/OBS_<tag>.m2` (saturation at the origin over
`QQ[om,kp,t0..t3]/(om^2+om+1, 8kp^2-13kp-4)`), which reports

```
dim (affine cone incl. om,kp) = 3
degree = 4
```

i.e. the zero locus of `Ob_2` is one hyperplane of `ker D_{p0}` over each of
the four `(om,kp)`-points. Logs in `logs/OBS_<tag>.log`.

```sh
python3 -c "import obstruction_locus as OL; OL.report_factor('m1_lam0_A')"
```

recomputes the common-linear-factor space exactly over `K`.

## 4. Ring structure probe

```sh
M2 --script m2/RING_STRUCTURE.m2      # dim 0, degree 9 per eigenblock
```

(`isPrime` is not applicable over `toField` in Macaulay2 1.26.06 and errors;
the log records this. The reducibility question it was meant to answer is
settled exactly and constructively in §3 of `STATUS.md` instead.)

## 5. Files

| file | role |
|---|---|
| `c1_lib.py` | conventions, `F`, the polarisation, graded pieces, the two seeds, the parameter split |
| `c1_ring.py` | exact arithmetic in the finite `QQ`-algebras of branch parameters; unit-pivot linear algebra; the guided exact `analyze_R` |
| `c1_ladder.py` | assembling a level into an `R`-linear system; `psi`-orbit reduction; coordinates in a graded piece |
| `c1_points.py` | points of `Spec R` over finite fields (pivot guessing + modular cross-checks only) |
| `produce_c1.py` | the ladder driver |
| `obstruction_locus.py` | the zero locus and the common linear factor of `Ob_2` |
| `verify_c1.py` | independent verifier |
| `payloads/` | the ladder tables, the special point, the obstruction's linear factor |

## 6. Reproducibility notes

* The exact linear algebra uses **unit pivots**: a pivot is accepted only when
  its multiplication operator on the branch ring is invertible, so a
  row-echelon form is valid simultaneously at every point of `Spec R` and the
  rank/solvability verdicts are uniform in the branch parameters. Rank
  *upper* bounds are certified by reducing every remaining row of the matrix to
  zero against the echelon rows.
* Modular data (primes 1021, 1039, 1123, and 10^13-size primes for the
  reconstruction of `ℓ_0`) is used only to *guess* pivot rows and to
  cross-check; every verdict in `STATUS.md` is certified by exact
  characteristic-zero arithmetic afterwards.
* `sympy` 1.14 on `python3` 3.14 was used. The producers accumulate polynomial
  products through `sympy.Poly` rather than `Expr.expand` (the latter is a
  performance trap at level 3 — an early run took > 25 min without finishing a
  level-3 assembly that now takes ≈ 3 min).
