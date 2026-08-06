# REPLAY — FIX-H2, packet `goal_runs_after_cbdff0a/FIX_H2_HOLE_CLOSURE/`

All commands are run from inside the packet directory.  Nothing outside it is
written; the sibling packets `goal_runs_after_541e12f/FIX_H1_EQUALIZER`,
`goal_runs_after_fa02f05/FIX_N2B_M1_ROW` and
`goal_runs_after_a90dbe1/FIX_N2C_R7_DECISION` are used **read-only** (the
FIX-H1 `holes_*.py` and `k0.py` were *copied* into this packet, per the brief,
and the copies are what run).

Toolchain: `python3` + sympy, `/opt/homebrew/bin/M2`, `/opt/homebrew/bin/msolve`
(0.10.1).  No GAP/Sage/Magma/PARI.  `NTH` sets the msolve thread count
(default 8); it was lowered when other jobs were live on the machine.

```
cd goal_runs_after_cbdff0a/FIX_H2_HOLE_CLOSURE
```

## 0. Engine controls (run these first)

```
NTH=4 python3 h2_engines.py --selftest       # -> SELFTEST PASS
```
Both directions on all four engines (msolve-qq, Macaulay2/K, sympy, msolve
mod p) plus the `-g` `#`-header parser on synthetic strings.  The
degree-bounded probe and the M2-over-QQ engine have their own controls
appended to `logs/H2_SELFTEST.log`; the degree-bounded probe must return
`None` (NOT-DECIDED), never `False`, on the non-unit control — it is
one-sided by construction.

## 1. Reproduce FIX-H1's six residual leaves (foundation check)

```
python3 h2_leaves.py 8            # -> logs/H2_LEAVES_R8.log
```
Leaf counts A 6 / B 44 / C 4 / D 42 per eigenblock, and the two hard leaves
`B_43`, `D_41` at 11 variables / 22 generators — identical to FIX-H1.
Note that neither has `X0` or `Y1` among its variables.

## 2. The licence and the structure

```
python3 h2_licence.py 8           # -> logs/H2_LICENCE_R8.log   (15 vars, 26 cubics)
python3 h2_struct.py  8           # -> logs/H2_STRUCT_R8.log    (anchor, grading)
python3 h2_levels.py show 8       # -> logs/H2_LEVELS_SHOW_R8.log
python3 h2_face.py   show 8       # -> logs/H2_FACE_SHOW_R8.log (the closed face)
```
`h2_struct.py` establishes (a) that the type-II anchor cubic
`kp A^3 + km B^3` is irreducible over `K` but **vacuous** on the `(1,r)` cell
(`U^{r/2}` is not in the a,b-slot support), and (b) that the licensed system
has grading lattice of rank 0.

## 3. The dichotomy

```
python3 - < /dev/null             # (see logs/H2_DICHOTOMY.log for the exact snippet)
```
The recorded run is reproduced by the block in `logs/H2_DICHOTOMY.log`:
running FIX-H1's exact branch-and-reduce on the FACE generators with `Y0 = 0`
returns a single leaf on which `X1 = X2 = Y2 = 0`, in all three eigenblocks.

## 4. Re-certify the two strata the licence rests on

```
NTH=3 python3 h2_strataAC.py 8 one,om,om2    # -> logs/H2_STRATA_AC.log
```
Independent re-run of FIX-H1's strata A and C with msolve-over-QQ, Macaulay2
over `K` and sympy.  Result written to `payloads/strataAC_r8.json`.

## 5. TASK A — the decision

Two cases per eigenblock (`Z`: `Y0 = 0`; `N`: `Y0 != 0`).  **The two sides are
run separately**, because msolve and Macaulay2 want different presentations of
the same set:

```
NTH=6 python3 run_msolve_all.py                # -> logs/H2_MSOLVE_ALL.log
python3 run_m2_final.py                        # -> logs/H2_M2_FINAL.log
NTH=4 python3 h2_cuberoot.py 8 one,om,om2      # -> logs/H2_CUBEROOT.log
```
`run_msolve_all.py` distinguishes **whole-case** presentations (one unit-ideal
answer settles the case) from **cover** presentations (`reduced*`, the leaves
of the branch-and-reduce — every one must be empty).  `h2_cuberoot.py` is the
cube-root cover that splits `X1^3 = -Y0^3 B9^2`, the actual obstruction on
CASE N.

Runs kept for the record, including the ones that failed:
```
NTH=8 python3 h2_final.py 8 one,om,om2 --timeout=1500   # -> logs/H2_FINAL_R8.log
NTH=8 python3 h2_decide.py 8 one,om,om2 --timeout=1800  # -> logs/H2_DECIDE_R8_ALL.log
NTH=6 python3 h2_taskA.py triage 8                      # -> logs/H2_TASKA_TRIAGE.log
NTH=1 python3 h2_homog.py 8 one --timeout=1800          # -> logs/H2_HOMOG_R8.log
python3 h2_homprobe.py 8 one --dlim=6,8,10              # -> logs/H2_HOMPROBE.log
```
The triage run records the **negative** result that the un-split licensed
system defeats msolve mod `p` (stopped at ~26 min / 15 GB); `h2_homog.py`
records that the homogeneous saturation route times out at 1800 s.

**Two toolchain traps found here** (both now guarded in the code):
* Macaulay2 parses `inv_Y0` as the indexed variable `inv` subscript `Y0`, so
  any slack variable whose name contains `_` makes the M2 run die in ~1 s.
  Renaming to `invY0` turned an apparent M2 failure into an 11 s success.
* `saturate(I, {f,g})` in M2 is *successive* saturation, i.e. `I : (f*g)^inf`,
  not `I : (f,g)^inf` — checked on a discriminating example,
  `m2/probe_sat2.m2`.

## 6. TASK B — the (1,6) characteristic-zero form

```
python3 h2_taskB.py check 3       # -> logs/H2_TASKB_CHECK.log  (TASKB-CHECK PASS)
python3 h2_taskB.py sizes 5       # -> logs/H2_TASKB_SIZES.log
NTH=4 python3 run_taskB_qq.py     # -> logs/H2_TASKB_QQ.log   CHARACTERISTIC ZERO
NTH=3 python3 run_taskB_ff.py     # -> logs/H2_TASKB_FF.log   mod p (a FINDING)
```
`run_taskB_qq.py` is the one that produces **verdicts**: four runs per `(n,λ)`
over `QQ` with `om, kp, B_0, B_n` as variables and all four minimal
polynomials adjoined.  `run_taskB_ff.py` is the same construction mod
`p = 100057` — kept because it is already a strictly stronger *finding* than
FIX-H1's (four runs covering all six `B`-roots at once, instead of 144
pointwise cone-line pairs).
`check` is the build's own validation: the exact symbolic `r = 6` cone lines
(polynomial in the endpoint parameter `B` over `K`) reproduce FIX-N2B's /
FIX-H1's mod-`p` cone lines term for term at all 24 lines, and levels `0` and
`3n` vanish **modulo the endpoint minimal polynomial** `B^6-(kap+2)B^3+1`
(they do not vanish identically — landing *is* that relation).

## 7. Verifier

```
python3 verify_h2.py              # -> terminal marker FIX_H2_VERIFY_OK
```
Independent recompute of every structural claim (cell support, the two sparse
generators, the licence, the closed face, the leaf-cover bookkeeping), a
re-parse of every stored msolve output with a freshly written parser, a
parenthesis audit of every msolve input, and a **harness self-test** in which
deliberately corrupted inputs must make the corresponding checks fail.

## Markers

| marker | meaning |
|---|---|
| `SELFTEST PASS` | engine controls, both directions |
| `M2V SELFTEST PASS`, `M2D SELFTEST PASS` | the two added M2 engines |
| `TASKB-CHECK PASS` | the exact `(1,6)` build matches the mod-`p` reference |
| `FIX_H2_VERIFY_OK` | the verifier |

## Files

| file | role |
|---|---|
| `h2_licence.py` | the licensed system `V(cone, B6-1, X0, Y1)` |
| `h2_levels.py` | the U-degree stratification of the licensed generators |
| `h2_face.py` | the closed U-exponent-0 face and the face-driven solver |
| `h2_final.py` | **the decision run** (two cases x two presentations) |
| `h2_decide.py`, `h2_taskA.py` | earlier, more granular drivers (kept) |
| `h2_reduce.py` | the licensed elimination cascade (`R3+`, unit coefficients) |
| `h2_struct.py` | anchor cubic, gradings, irreducibility over `K` |
| `h2_strataAC.py` | re-certification of strata A and C |
| `h2_engines.py` | msolve-qq / M2-over-K / M2-over-QQ / degree-bounded / sympy |
| `h2_leaves.py` | reproduction of FIX-H1's leaf table |
| `h2_taskB.py` | the exact char-0 `(1,6)` line-degree build |
| `h2_summary.py` | collects every verdict from the logs and payloads |
| `run_taskB_qq.py`, `run_taskB_ff.py` | TASK B drivers (char-0 / mod-p) |
| `probe_sympy2.py`, `probe_sympy_z4.py`, `probe_taskB_qq.py` | the timing probes quoted in `STATUS.md` |
| `verify_h2.py` | the independent verifier |
| `holes_*.py`, `k0.py` | FIX-H1 scripts, **copied** (not modified in place) |
| `payloads/` | the licence derivation, the reduced systems, the JSON verdicts |
| `logs/`, `msolve/`, `m2/` | every input, output and log |
