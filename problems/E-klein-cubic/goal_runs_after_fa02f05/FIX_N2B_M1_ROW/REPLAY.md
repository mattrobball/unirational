# Replay — FIX-N2B

Tools: `python3`/`sympy`, Macaulay2 and msolve **by absolute path**
(`/opt/homebrew/bin/M2`, `/opt/homebrew/bin/msolve`).  No GAP/Sage/Magma/PARI.
Everything characteristic zero except where a finite field is used deliberately
(and then only in a direction in which the implication to characteristic zero is
valid, or as a declared *search* device — see §4).

## 0. Files

| file | role |
|---|---|
| `n2b_lib.py` | the from-scratch engine: exact arithmetic in `K = QQ(om,kp)`, the `U,V,W` cell shapes, the `C_3`-eigenblocks by explicit eigenvectors, the landing polynomial, plane orders |
| `fullspace.py` | the FULL `K`-equivariant cell space (no `C_3`), its landing polynomial and the embeddings of the three eigenblocks — needed because the `t`-adic pieces `T_j` live in *different* blocks |
| `ladder_lib.py` | the polarisation `e -> Phi(T_0,T_0,e)`, the plane order of the degree-`3r` monomials, exact kernels over `K` |
| `produce_cones.py` | engine A — Macaulay2 `dim I` (mode `ff` = `F_100057`, mode `exact` = the number field `QQ[om,kp]/(om^2+om+1,8kp^2-13kp-4)`) |
| `produce_gb.py` | engine B — msolve in Groebner mode (`-g`), cone dimension from the leading ideal, coordinate saturation |
| `produce_po1.py`, `produce_po1_dehom.py` | the decisive saturation: can a plane-order-1 parameter be nonzero on the cone? (slack-variable and dehomogenised formulations) |
| `produce_leading.py` | the level-4 plane-order-graded obstruction, exact over `K` (result: **solvable**, i.e. not an obstruction) |
| `produce_ladder.py` | the ladder-rigidity matrices `M(t)` of Lemma S2 |
| `probe_tangent.py` | the level-1 ladder condition `Phi(T_0,T_0,T_1) = 0` solved in the full cell space and intersected with each eigenblock |
| `probe_family.py` | the line-degree-2 family search at `r = 6` (all 144 pairs of cone lines) |
| `witness_lib.py` | the `G · D_B(X)` construction inside the full cell space |
| `modular.py` | modular evaluation helpers (`p = 100057`, `om = 1140`, `kp = 74361`) |
| `produce_payloads.py` | writes `PAYLOAD_*.txt` |
| `probe_r7_substratum.py` | the `r = 7` sub-stratum tests (fix any subset of the block parameters, hand the rest to msolve) |
| `probe_r7_elim.py` | eliminates `P0, B0, R1` from the `r = 7`, `lam = 1`, `B5 = 1` system and hands the 9-variable remainder to msolve |
| `reparse_sat.py` | re-reads the msolve saturation `.out` files on disk and prints the verdicts |
| `verify_n2b.py` | **the independent verifier** (see §1) |

## 1. One-command verification

```sh
cd goal_runs_after_fa02f05/FIX_N2B_M1_ROW
python3 -u verify_n2b.py
```

Expected terminal line:

```
FIX_N2B_M1_ROW_VERIFY_OK
```

It checks, in order:

1. **SMOKE** — FIX-N2's own `cell_lib` / `produce_c3_equivariant` are imported
   and their cell dimensions, eigenblock dimensions and landing-equation counts
   are compared termwise with this packet's independent `U,V,W` engine
   (`r = 2..9`).  Then FIX-N2's own Macaulay-rank certificate is re-run to
   reproduce **`(1,2),(1,3),(1,4)` EMPTY** (full rank mod `p` implies full rank
   in char 0, so this direction is rigorous); `(1,5)` EMPTY is re-decided by
   this packet's msolve and Macaulay2 engines (`logs/SMOKE_*`, `logs/GB_*`) and
   is FIX-N2's own rank-certified result.
2. every `A_4`-invariant used has **even** `ord_{P_i}` (recomputed from
   explicit ideal-theoretic orders).
3. the eleven witnesses of `PAYLOAD_witnesses.txt`: landing identity with
   `kp = (B^3-1)^2/B^3`, residual `C_3`-equivariance with `lam = om^2`, and the
   exact `(m,r)` — **exact, characteristic zero**, over `QQ(om)(B)`.
4. **Theorem N2B-2**: the same construction with `X` carrying binary
   coefficients is `A_4`-equivariant and lands, at line degrees 1, 2, 3.
5. the `r = 6` reduced cone system `E1..E7`, re-derived by sympy from the raw
   Klein normal form (a code path independent of `n2b_lib`), and the exact
   branch classification, including the `kp = -4` exclusion.
6. the exact `K`-arithmetic self-tests, the 2-dimensionality of the
   plane-order-1 part of every eigenblock (`r = 4..11`), and the parity fact
   that makes the `rho = 2` ladder step vacuous for even `r`.
7. the `ord_{P_1}` parity table (`r = 3..11`).
8. the **refutation** of FIX-N2's proposed closing step for `(1,6)`,
   recomputed at two independent primes.

## 2. The cone computations

```sh
python3 produce_gb.py     ff 2 3 4 5           # instant; CONE-DIM 0 throughout
python3 produce_gb.py     ff 6                 # r=6: 0 / 1 / 1  (+ saturations)
python3 produce_cones.py  m2 ff    2 3 4 5 6   # Macaulay2 dim I, same verdicts
python3 produce_cones.py  m2 exact 2 3 4       # characteristic zero, number field
python3 produce_po1.py       ff 7 8 9          # LONG (did not terminate)
python3 produce_po1_dehom.py ff 7 8 9          # r = 7 terminates (11-20 min each)
```

Logs kept: `logs/SMOKE_m2_ff_r2-5.log`, `logs/SMOKE_m2_exact_r2-5.log`,
`logs/GB_ff_r6_r7.log`, `logs/CONE_m2_ff_r6.log`, `logs/PO1_ff_r7-9.log`,
`logs/PO1D_ff_r7-9.log`, `logs/VERIFY.log`.
Generated Macaulay2 and msolve inputs/outputs live under `m2/` and `msolve/`.

**Reading the msolve output.**  `-g 1` prints the leading ideal; the ideal is
the unit ideal exactly when the bracketed body is `1`.  `reparse_sat.py` re-reads
the saturation `.out` files already on disk and prints the verdicts.

## 3. The ladder and the family searches

```sh
python3 produce_leading.py 6 7 8      # level-4 graded obstruction: SOLVABLE
python3 produce_ladder.py  6 2 3      # Lemma S2 matrices (rho = 2 has 0 rows!)
python3 probe_family.py              # line degree 2 at r = 6: no family
```

`probe_tangent.py` is used as a library (see `verify_n2b.py` §8) and can be
driven directly for a chosen cone point.

## 4. Which computations are rigorous in characteristic zero

* **Rigorous, char 0**: everything in `verify_n2b.py` — exact `sympy`
  identities over `QQ(om)(B)`, exact linear algebra over `K = QQ(om,kp)` with
  the from-scratch field arithmetic, and FIX-N2's full-rank Macaulay
  certificate mod `p` (full rank mod `p` => full rank in char 0).  Also the
  `r = 6` reduced-cone classification of §2.2 of `STATUS.md`.
* **Modular filter only** (declared as such, never the sole basis of an EMPTY
  verdict): msolve/Macaulay2 over `F_100057`.  A `[-1]`/unit-ideal verdict mod
  `p` does *not* by itself lift to characteristic zero; at `r = 6` the same
  statements are re-proved exactly in `verify_n2b.py`, which is why the `r = 6`
  results are stated as theorems and the `r = 7,8,9` ones are not.
* **Search device**: `probe_family.py`, `probe_tangent.py` (`F_100057`).  A
  *positive* find is always re-verified exactly.  The `r = 6`, line-degree-2
  exclusion is an exception that *does* lift: it is the statement that a matrix
  has FULL COLUMN RANK mod `p`, and rank can only drop under reduction, so the
  characteristic-zero kernel is zero as well.
* Conversely, `CAN-BE-NONZERO` (a *non*-unit ideal mod `p`) never lifts by
  itself — which is exactly why the `r = 7` finding of `STATUS.md` §2.7 is
  flagged and not promoted to a verdict.

## 5. The `r = 7` alarm (STATUS.md §2.7)

```sh
python3 produce_po1_dehom.py ff 7            # CAN-BE-NONZERO for B5 and B8
python3 probe_r7_substratum.py one 7 B5=1 B8=0   # unit ideal: B8 must be nonzero
python3 probe_r7_elim.py                     # eliminates P0,B0,R1 and solves (LONG)
```

The last one had not terminated when the packet closed; `logs/R7_ELIM.log`,
`logs/R7_ELIM2.log` record the reduced systems (10 resp. 9 variables) that were
handed to msolve.  The `r = 7` block landing polynomial is validated
independently by evaluating the `(2,7)` witness `e_2 · D_B(x)` in block
coordinates (all 52 equations vanish; plane order 2).

## 6. Note on the stored msolve outputs

The six full Groebner bases `msolve/gb_r{5,6}_*_ff.out` (2 000 – 6 000 elements,
~200 MB in total) have been **truncated to their headers** to keep the packet
small; regenerate them with `python3 produce_gb.py ff <r>`.  All the *decision*
outputs — the leading ideals of the saturations `gb_r6_*_sat_*.out` and
`po1d_r7_*.out` — are stored in full and are what `reparse_sat.py` reads.
