# Replay — FIX-U1-FIN7

Packet `goal_runs_after_9094303/FIX_U1_FIN7/`.  Working dir = this directory
(all scripts use absolute paths for the read-only imports of sibling packets).

```
cd /Users/worker/unirational/problems/E-klein-cubic/goal_runs_after_9094303/FIX_U1_FIN7
python3 produce_fin7.py          # ~50 min ; terminal line FIX_U1_FIN7_PRODUCE_OK
python3 verify_fin7.py           # ~15 min ; terminal line FIX_U1_FIN7_VERIFY_OK
python3 make_payloads.py         # renders payloads/PAYLOAD_*.txt from the JSON
python3 c3_and_curve.py          # (3a) C3-stability, (3b) rational curve
python3 xyz_form.py              # the (X,Y,Z) reformulation + completing the square
python3 thm59_checks.py          # Theorem 5.9 (a)(b)(c) convention cross-checks
python3 kuranishi.py             # Ob_2, Ob_3 symbolically; emits m2/kur_*.m2
python3 arc_scan.py 10 8         # Kuranishi ray-lifting scan, all 27 points
python3 partA_tc.py 10 8         # part A: the quadratic tangent cone
python3 arc_pade.py 16           # rational-reconstruction attempt (negative)
M2 --script m2/kur_j0A_OB2.m2    # -> dim 5, degree 1 : V(Ob_2) is a 5-plane
```

Second engine (Macaulay2, exact ranks over the residue number fields):

```
python3 make_m2.py 0A 0B 0C 0D 1A 1B 1C 1D 2A 2B 2C 2D
M2 --script m2/rank_j0A.m2       # -> rank J = 31, corank = 8
M2 --script m2/rank_j0B.m2       # -> rank J = 34, corank = 5
```

`make_m2.py` hands Macaulay2 only the raw data (the 52 cubics in the 39
parameters over `K`, and the 39 point coordinates as polynomials in `B2, P1`);
M2 does its own differentiation, substitution and `rank` over
`toField(QQ[om,kp,B2,P1]/(om^2+om+1, 8kp^2-13kp-4, gB2, gP1))`.

## Files

| file | content |
|---|---|
| `fin7_lib.py` | the non-equivariant `(m,r) = (1,7)` system: 39 parameters, 52 equations, two independent builders, the plane-order witnesses, the `Theta` operator, the torus weights |
| `fin7_equiv.py` | the residual-`C3` eigenblock embeddings and the 27 classified FIX-N2C points placed in the 39-parameter chart |
| `fin7_points.py` | the Galois `1+2+2+4` split of each nine-point block and its residue fields |
| `exalg.py` | exact arithmetic in `QQ[om,kp,B2,P1]/(4 relations)` (structure constants, exact inversion) |
| `fin7_jac.py` | Jacobian / rank / nullspace over any ring; `F_p` ring |
| `fin7_theta.py` | the `Theta`-eigenspace decomposition `39 = 13+13+13` |
| `fin7_tangent.py` | the exact tangent computation at one `(block, part)` |
| `fin7_modular.py` | split primes, modular points, modular ranks (cross-checks and certified lower bounds) |
| `fin7_slice.py` | linear-slice generators for the global dimension attempt |
| `make_m2.py` | Macaulay2 second-engine inputs |
| `produce_fin7.py`, `verify_fin7.py` | producer, verifier |
| `c3_and_curve.py` | (3a) `Θ ∘ g_{s,t,w} = g_{w,s,t} ∘ Θ`; (3b) the explicit rational curve |
| `xyz_form.py` | exact `F(T) = xyz·G` and the completing-the-square normal form |
| `thm59_checks.py` | Note IV Theorem 5.9 (a)(b)(c) against this build |
| `kuranishi.py`, `arc_scan.py`, `partA_tc.py`, `arc_pade.py` | the level-0 Kuranishi map, the ray-lifting scan, part A's tangent cone, the rational-reconstruction attempt |
| `make_payloads.py` | renders the payload text files |
| `payloads/` | `PAYLOAD_results.json`, `PAYLOAD_tangent_table.txt`, `PAYLOAD_uv_check.txt` |
| `logs/` | all run logs |

## Read-only imports of sibling packets

* `goal_runs_after_a90dbe1/FIX_N2C_R7_DECISION/indep_r7.py` — used ONLY as a
  cross-check target in `produce_fin7.py` §1 (the eigenblock restriction of
  this packet's 52 equations must equal FIX-N2C's 52 equations, coefficient by
  coefficient, in all three eigenblocks).  Nothing else is imported; the
  classified points are rebuilt here from FIX-N2C's *published* closed forms
  (Theorem N2C-1' plus the per-block linear relations) and re-verified against
  this packet's own equations.

## Toolchain notes obeyed

* msolve inputs (`msolve/*.ms`) are fully expanded with bare integer
  coefficients and are asserted parenthesis-free
  (`FIX_N2C_R7_DECISION/MSOLVE_PARSER.md`).
* No underscores in Macaulay2 variable names.
* Every unit/non-unit decision ships a positive control (a known unit) and a
  negative control (a known non-unit) through the same code path, plus
  `ck_must_fail` controls in the verifier that the harness must report false.
* Modular runs are never verdicts: they appear only as cross-checks or as
  certified LOWER bounds on ranks (rank can only drop under reduction).
