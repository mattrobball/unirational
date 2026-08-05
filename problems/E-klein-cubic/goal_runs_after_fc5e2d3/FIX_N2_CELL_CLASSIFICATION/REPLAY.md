# Replay — FIX-N2

All exact, characteristic zero except where a finite field is used deliberately
(and then only in the direction in which the implication to characteristic zero
is valid — see below).  Tools: `python3`/`sympy`, Macaulay2 and msolve by
absolute path.  No GAP/Sage/Magma/PARI.

## 0. Files

| file | role |
|---|---|
| `cell_lib.py` | conventions, monomial bases `basis(chi,r,m)`, general `K`-equivariant tuple, Klein normal form, landing system per cell |
| `produce_c3_equivariant.py` | the `C_3`-eigen-blocks of a cell (exact nullspace over `QQ(om)`), the landing equations on each block, `C_3`-orbit reduction of the equation set |
| `produce_c3_solve.py` | engine 1 — Macaulay2 `dim I` (and per-coefficient plane-order tests) |
| `produce_msolve.py` | engine 3 — msolve coordinate saturation `I + (v_i - 1)` |
| `produce_cells.py` | the *unreduced* per-cell system (no `C_3`), for the shapes and for cross-checking against the base packet |
| `produce_payloads.py` | writes the four `PAYLOAD_*.txt` files |
| `probe_order1_r6.py` | targeted msolve probe: can a given plane order occur on the `C_3`-equivariant cone at order `r`? (this found the populated cell `(2,6)`) |
| `verify_cells.py` | **independent verifier** (engine 2 for the cones: a from-scratch Macaulay rank certificate) |

## 1. One-command verification

```sh
cd goal_runs_after_fc5e2d3/FIX_N2_CELL_CLASSIFICATION
python3 verify_cells.py 5
```

Expected terminal line:

```
FIX_N2_CELL_CLASSIFICATION_VERIFY_OK
```

It checks, in order: the `V4` character partition from the explicit sign action;
`ord_{P_i}` by ideal membership; the cone bound `r >= ceil(3m/2)` for `m=1..6`;
the parity delay; the base packet's `(2.4),(2.5),(2.6),(2.7),(2.8)`; the
trisection identity in three free variables; the §4 family and the two new
witnesses (landing + residual-`C_3` equivariance with `lam = om^2` + the exact
`(m,r)`); both halves of the Specialisation Lemma on a generic bidegree-`(2,3)`
family; and finally the `C_3`-equivariant cone triviality for `r = 2..5` by an
independent Macaulay rank computation (argument `5` is the largest `r`; `6`
and beyond are slow in pure python — use engines 1/3 for those).

## 2. Payload regeneration

```sh
python3 produce_payloads.py
```

writes `PAYLOAD_dims.txt`, `PAYLOAD_shapes.txt`, `PAYLOAD_c3_blocks.txt`,
`PAYLOAD_witnesses.txt`.

## 3. The cone decisions, engine by engine

```sh
python3 produce_c3_solve.py ff 1 2 3 4 5 6     # Macaulay2, dim I
python3 produce_msolve.py   ff 1 2 3 4 5       # msolve, I + (v_i - 1)
python3 verify_cells.py 5                      # Macaulay rank certificate
```

`ff` is `ZZ/100057` with `om = 1140`, `kp = 74361`, `km = 63219`, which satisfy
`om^2+om+1 = 0`, `kp+km = 13/8`, `kp*km = -1/2` modulo `p` (asserted at import
in `verify_cells.py`).  `produce_c3_solve.py exact ...` runs the same decisions
over the exact number field `QQ[om,kp]/(om^2+om+1, 8kp^2-13kp-4)`; it is much
slower and was used only as a spot check.

**Why the finite field is legitimate here.**  Every decision we *use* is of the
form "the solution cone is `{0}`".  In `verify_cells.py` that is certified by
full rank of a degree-`D` Macaulay matrix mod `p`; full rank mod `p` implies
full rank in characteristic zero (the rank can only drop under reduction), hence
`(v_0,...,v_k)^D` lies in the ideal over `QQ(om,kappa)` and the cone is `{0}`
there.  Nontriviality claims are never taken from a finite field: every
populated cell in this packet is certified by an **explicit symbolic witness**
verified in characteristic zero (`PAYLOAD_witnesses.txt`,
`verify_cells.py::check_section4_and_generalisation`).

## 4. The `C_3`-orbit reduction

`produce_c3_equivariant.landing_eqs(forms)` returns one equation per `psi`-orbit
of monomials.  This is legitimate because every point of the parameter space is
by construction a `C_3`-equivariant tuple, for which `F(T)` is `C_3`-semi-
invariant, so the coefficients of `F(T)` at the monomials of one orbit are
proportional.  Moreover the reduced system is *weaker*, so a "cone `= {0}`"
verdict obtained from it holds a fortiori for the full system.  The verifier
deliberately uses the **full** system (`orbit_reduce=False`).

## 5. Logs kept as evidence

| log | content |
|---|---|
| `LOG_verify.log` | full run of `verify_cells.py` |
| `LOG_c3_cones_M2.log` | Macaulay2 `dim I` decisions, `r = 2..6` |
| `LOG_c3_cones_msolve.log` | msolve coordinate saturation, `r = 2..5` |
| `LOG_macaulay_rank.log` | the independent Macaulay rank certificates |
| `LOG_probe_r6_plane_orders.log` | the `r=6` plane-order probe that found `(2,6)` |
| `LOG_raw_cell_systems.log` | the raw (non-`C_3`) per-cell systems, small cells |

Generated Macaulay2 and msolve inputs/outputs are under `m2/` and `msolve/`.

## 6. Long-running items (not part of the one-command replay)

`r = 6` with `lam = om, om^2`, and `r >= 7`, are large Groebner computations.
`r = 6, lam = 1` completes (Macaulay2 and msolve agree: cone `= {0}`).  For
`r = 6` with `lam = om^2` the cone is *known* to be nontrivial without any
computation: the base packet's §4 family is an explicit point of it, and its
conjugate (on the `a = 0` character hyperplane) is a point of the `lam = om`
block.  The status of `r >= 7` is recorded in `STATUS.md`.
