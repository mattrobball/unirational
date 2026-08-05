# Replay — FIX-H1, the S3-equalizer at the D12-points

Working directory: this packet.
Toolchain: `python3` (sympy), `M2` (Macaulay2), `/opt/homebrew/bin/msolve`.
No GAP/Sage/Magma/PARI. Everything is exact and characteristic 0 except where
a run is explicitly labelled a modular FINDING.

## Primary task — the equalizer

```
python3 produce_h1_frame.py        # ~2 s   -> payloads/PAYLOAD_frame.txt,   FIX_H1_FRAME_OK
python3 produce_h1_equalizer.py    # ~3 s   -> payloads/PAYLOAD_equalizer.txt, FIX_H1_EQUALIZER_OK
python3 produce_h1_branch1.py      # ~1 s   -> payloads/PAYLOAD_branch1.txt, FIX_H1_BRANCH1_OK
python3 produce_h1_branch2.py      # ~70 s  -> payloads/PAYLOAD_branch2.txt, FIX_H1_BRANCH2_OK
python3 verify_h1.py               # ~3 s   -> logs/VERIFY.log,             FIX_H1_VERIFY_OK
```

Terminal markers, in order: `FIX_H1_FRAME_OK`, `FIX_H1_EQUALIZER_OK`,
`FIX_H1_BRANCH1_OK`, `FIX_H1_BRANCH2_OK`, `FIX_H1_VERIFY_OK`
(the verifier prints `43 OK, 0 FAIL` and, inside it, Macaulay2 prints
`FIX_H1_M2_OK`).

* `k0.py` — self-contained exact arithmetic in `K0 = QQ(om, sqrt(-11))`
  (the second engine; independent of `klein_exact.py`).
* `m2/branch2_equalizer.m2` — emitted by `verify_h1.py`, run automatically;
  log in `logs/M2_BRANCH2.log`.

Read-only dependencies (never modified):
`goal_runs_after_6519c0b/FIX_H0_GLOBAL_SECTIONS/klein_exact.py`,
`goal_runs_after_a90dbe1/FIX_N2C_R7_DECISION/{indep_r7,witness,witness_om,witness_om2}.py`,
`goal_runs_after_fa02f05/FIX_N2B_M1_ROW/n2b_lib.py` (secondary task only).

## Secondary task — the two odd-row holes

```
python3 holes_setup_r8.py                    # block dims / plane orders, r = 6..10
python3 holes_show_r8.py 8 one               # the (1,8) equations by sparsity
python3 holes_xy.py                          # the (P,R) -> (X,Y) change of coordinates
python3 holes_indep.py 8                     # independent sympy rebuild, 82 = 82, 0 mismatches
python3 holes_controls.py                    # both char-0 engines, both directions
python3 holes_certify2.py 8 one  --spmax=4   # TASK 6: r = 8, lam = 1     -> logs/C2_R8_one.log
python3 holes_certify2.py 8 om   --spmax=4   #         r = 8, lam = om    -> logs/C2_R8_om.log
python3 holes_certify2.py 8 om2  --spmax=4   #         r = 8, lam = om^2  -> logs/C2_R8_om2.log
python3 holes_certify2.py 10 one --spmax=4   #         r = 10 (partial)   -> logs/C2_R10_one.log
python3 holes_ld.py                          # TASK 5: r=6 cone lines, mu_j, ladder kernels
python3 holes_task5.py 3 om,om2              #         line degree 3      -> logs/TASK5_n3.log
python3 holes_task5.py 4 one                 #         line degree 4      -> logs/TASK5_n4.log
python3 holes_task5.py 5 one                 #         line degree 5      -> logs/TASK5_n5.log
python3 holes_task5.py 6 om,om2              #         line degree 6      -> logs/TASK5_n6.log
```

Each leaf line in `logs/C2_R*.log` reads
`mod-p …:UNIT,… | qq=<msolve/QQ> | M2=<Macaulay2/K> | sympy=<Groebner> | EMPTY`.
The TASK 5 runs are **modular findings only** — see `STATUS.md` §6b for why and
for the characteristic-0 upgrade. `payloads/HOLES_REPORT.md` has the full
account, the four-strata decomposition, and the file-by-file role table.

**msolve landmine.** Every msolve input emitted here is fully expanded with
bare integer coefficients and is asserted to contain no `(` before the call;
a 0-byte msolve output is treated as an ERROR, never as a verdict
(see `goal_runs_after_a90dbe1/FIX_N2C_R7_DECISION/MSOLVE_PARSER.md`).

## What each file is

| file | role |
|---|---|
| `produce_h1_frame.py` | Part A: the exact sigma-frame, `c_sigma`, `rho`/`tau` on `W^-`, `kp`, the D12-point ratio |
| `produce_h1_equalizer.py` | Part B: `V[sgn^e]`, the D_B quadric, the order-by-order codimension pattern |
| `produce_h1_branch1.py` | Part D: branch (i) at every classified odd-`m` D_B member |
| `produce_h1_branch2.py` | Part C: branch (ii), all three eigenblocks, with Nullstellensatz certificates |
| `verify_h1.py` | independent verifier, 43 checks, Reynolds projectors + sympy + Macaulay2 + 40-digit numerics + harness self-test |
| `k0.py` | exact `QQ(om, sqrt(-11))` engine |
| `payloads/PAYLOAD_theorem.txt` | the derivation of the equalizer criterion (Theorem H1-1) and both verdicts |
| `payloads/HOLES_REPORT.md` | the secondary task |

## Finishing the secondary task

Two things were still computing when the packet closed:

```
# the 6 residual (1,8) leaves -- the only gap between the packet and
# FIX-H1-HOLE-1EVEN-EMPTY.  One 11-variable / 22-generator generic leaf per
# eigenblock per chart: B_43 and D_41 for each of lam = 1, om, om^2.
tail -f logs/HARD6.log logs/HARD6b.log        # if still running
python3 holes_certify2.py 8 one  --leaf=B_43  # otherwise re-launch per leaf
python3 holes_certify2.py 8 one  --leaf=D_41
#   ... and the same for om, om2

# TASK 5, line degree 6
python3 holes_task5.py 6 om,om2               # -> logs/TASK5_n6.log
```

`logs/M2PASS_R8.log` ends in a `BrokenPipeError` — a multiprocessing crash in
the driver, not a mathematical failure; the Macaulay2 pass it drove is
therefore incomplete (40 of the leaves carry an M2 verdict, 48 carry all three
engines, and there are **zero** disagreements among engines anywhere).
