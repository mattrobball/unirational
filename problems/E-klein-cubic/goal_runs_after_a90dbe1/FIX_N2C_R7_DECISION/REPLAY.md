# Replay — FIX-N2C

Tools: `python3`/`sympy`/`mpmath`, Macaulay2 and msolve **by absolute path**
(`/opt/homebrew/bin/M2`, `/opt/homebrew/bin/msolve`).  No GAP/Sage/Magma/PARI.

**Read `MSOLVE_PARSER.md` before writing any msolve input.**  msolve 0.10.1
silently mis-parses parentheses; every input this packet writes is fully
expanded with integer coefficients, and `verify_n2c.py` asserts it.

## 0. One-command verification

```sh
cd goal_runs_after_a90dbe1/FIX_N2C_R7_DECISION
python3 -u verify_n2c.py
```

Expected terminal line:

```
FIX_N2C_R7_DECISION_VERIFY_OK
```

Runtime ~4 min, all of it sympy; it needs no Groebner engine, because the
verdict rests on an *exact identity*, not on an emptiness computation.
It checks, in order:

1. **Independent rebuild.**  `indep_r7.py` constructs the `(m,r) = (1,7)` cell,
   the residual-`C_3` eigenblocks and the 52 landing equations from the raw
   Klein normal form as explicit polynomials in `x,y,z` — it never imports
   FIX-N2B's engine — and the result is compared **termwise** with
   `n2b_lib.landing_cpoly` for all three `lam` (0 mismatches).
2. **Plane orders.**  `B5, B8` are recomputed to be exactly the plane-order-1
   parameters of the cell, from ideal-theoretic orders of the monomials.
3. **msolve parser regression** (the landmine), plus the assertion that this
   packet's two emitters are parenthesis-free and agree termwise mod `p`.
4. **The verdict** (`verdict_checks.py`):
   * `control_27.py` — FIX-N2B's `(2,7)` witness `e_2 D_B(x)` satisfies all 52
     rebuilt equations and has `m = 2` (positive control);
   * `witness.py` — the exact `(1,7)` witness: `F(T) = 0` on all 52 equations
     *and* as a raw `x,y,z` identity, `psi(T) = g(T)`, `r = 7`,
     `(ord_{P_1},ord_{P_2},ord_{P_3}) = (1,1,1)`, `a',b' != 0`, unit gcd; and
     Corollary N2C-2: `q^k T` (`q = x^2+y^2+z^2`) lands with `m = 1`,
     `r = 7+2k`, checked exactly for `k = 1, 2`;
   * `numeric_check.py` — mpmath at 40 dps, `kp+ = (13+3 sqrt 33)/16`,
     9 points x 5 random `(x,y,z)`, and the identification of the `c`-roots with
     `B + B^-1` over the six `D_B` parameters;
   * re-validation of the nine `F_100057` points by direct substitution.

## 1. Files

| file | role |
|---|---|
| `indep_r7.py` | **the independent engine**: the `(1,7)` cell, the `C_3`-eigenblocks, the landing equations, from the raw Klein normal form in `x,y,z` (sympy over `QQ[om,kp]/(...)`) |
| `n2c_systems.py` | the msolve/`K`-arithmetic layer: builds FIX-N2B's system, dehomogenises, eliminates linearly, emits `ff` / `fv` / `qq` inputs (**parenthesis-free**), split-prime search |
| `crosscheck.py` | termwise comparison of `indep_r7` with FIX-N2B's `n2b_lib` |
| `run_one.py` | one msolve run on a dehomogenised system |
| `decode_param.py` | decodes an msolve `-P 1` parametrization into explicit points, **validated by substitution** into the input system |
| `multiprime.py` | the multi-prime leading-ideal test (staircase, dimension, degree) |
| `linear_part.py` | linear forms in `(I : v^oo)` by exact linear algebra over `K` (and mod `p`) — a Groebner-free probe |
| `reduce_linear.py` | substitutes the nine linear relations into the exact system: 52 equations -> 10 cubics in `(B5,P0,P1,B2)` |
| `make_m2.py` | Macaulay2 input for the un-reduced systems (`nf` = exact number field, `qq`) |
| `exact_point.py` | the first exact point, via the degree-9 minimal polynomial of `P0` over `K` |
| **`witness.py`** | **the witness in closed form and its exact verification** |
| `point_tools.py` | generic exact checker for a candidate cone point |
| `numeric_check.py` | 40-digit numerical confirmation |
| `control_27.py` | positive control on FIX-N2B's `(2,7)` family |
| `verify_n2c.py`, `verdict_checks.py` | the verifier |

## 2. How the verdict was produced, step by step

```sh
# (a) reproduce FIX-N2B's alarm to an EXPLICIT modular point   (~20 min)
python3 -u run_one.py B1_ff100057_one_B5 one B5 ff:100057 --noelim -P 1
python3 decode_param.py msolve/B1_ff100057_one_B5.out msolve/B1_ff100057_one_B5.ms
#   -> 9 points over F_100057, each re-validated against the 18 cubics

# (b) further split primes: identical staircase, dim 0, degree 10  (~25 min each)
python3 -u multiprime.py one B5 2 100100      # p = 100153, 100189
python3 -u multiprime.py one B5 1 1048600    # p = 1048609

# (c) read the nine affine relations off the nine points, then substitute
#     them into the EXACT system over K and solve exactly
python3 reduce_linear.py one                       # 52 -> 10 cubics in 4 vars
M2 --script m2/RED_nf_one.m2                       # dim 0, degree 9, 1 % I != 0
M2 --script m2/RED_P0eq1_P1.m2                     # the two Chebyshev cubics
M2 --script m2/RED_P0eq1_B2.m2

# (d) THE PROOF: build the point in closed form and verify it exactly
#     against the ORIGINAL 52 equations                            (~2 min)
python3 -u witness.py
python3 -u numeric_check.py
```

`m2/RED_P0eq1_P1.m2` prints the whole ideal in the `P0 = 1` chart:

```
P1^3 + (-(8/9)*om*kp - (16/9)*om)*P1^2 + (32/27)*kp + 64/27
B2^3 + 9*B2 + 6*om*kp + 12*om + 3*kp + 6
B5 + (-(1/6)*om - 1/3)*B2*P1 - om
```

— two cubics in separate variables and one linear equation, hence exactly
`3 x 3 = 9` points, which is the whole `(1,7)` plane-order-1 locus for `lam = 1`.

## 3. Which computations are rigorous in characteristic zero

* **Rigorous, char 0, and sufficient on its own**: `witness.py`.  It is an exact
  identity check in `K(c,P1)`, reduced modulo a Groebner basis with pairwise
  coprime leading monomials (`c^3, P1^3, om^2, kp^2`), on equations rebuilt from
  the raw normal form.  A POPULATED verdict needs nothing else — no lifting
  theory, no primes.
* **Rigorous, char 0, corroborating**: Macaulay2 over
  `toField(QQ[om,kp]/(om^2+om+1, 8kp^2-13kp-4))` on the reduced system
  (`dim 0`, `degree 9`, `1 % I != 0`); msolve over `QQ` on the same system
  (`dim 0`, `degree 36 = 4 x 9`).
* **Search device only** (never the basis of a verdict): every `F_p`
  computation, and the nine linear relations read off the modular points.  They
  only told us where to look; step (d) is what proves it.
* **Numerical**: `numeric_check.py` is a confirmation, not a proof.

## 4. Long runs left going at close (redundant, logs kept)

`M_nf_one_B5` (M2 over `K`, un-reduced 12-variable system), `B3_qq_one_B5`
(msolve over `QQ`, un-reduced), `G1_ff100057_one_B5_gb` (`-g 2` reduced GB at
`p = 100057`), `MP_r7_one_B5_p100189`, `C2_ff100057_om_B5` (the `lam = om`
block), `M_nf_one_B5_B8zero` (the `B8 = 0` sub-stratum in char 0),
`LINP_modp_one_B5` (`N = 5` linear-forms probe).  None of them is needed for
the verdict.
