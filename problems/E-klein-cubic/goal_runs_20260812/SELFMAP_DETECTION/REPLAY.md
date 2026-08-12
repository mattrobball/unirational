# Replay

## Two commands

```
cd problems/E-klein-cubic/goal_runs_20260812/SELFMAP_DETECTION
python3 verify_selfmap_audit.py ; echo "EXIT=$?"
python3 verify_phi8_degree.py   ; echo "EXIT=$?"
```

The second expects

```text
  delta(phi_8) = 208 = 2^4 * 13   -- NOT a norm  => phi_8 is NOT CLEAN
  delta(phi_9) = 288 = 2^5 * 3^2  -- NOT a norm  => phi_9 is NOT CLEAN
  checks run : 149
  failures   : 0

RESULT: PASS
EXIT=0
```

Runtime ~175 s, of which ~135 s is the single characteristic-zero msolve run.
It needs **msolve** (`>= 0.10`) on `PATH` in addition to Python 3; nothing else.
Everything is exact: Python integers, `Fraction`, `F_p`, and msolve over `Q` and
over `F_p`.

> **msolve input format — read this before editing any system.** msolve's parser
> does **not** understand parentheses. A polynomial written `(3)*x1^2*x2+(-8)`
> is silently mis-read, and msolve then reports "no solution" for a system with
> obvious solutions. This cost a full debugging cycle and would have produced a
> wrong (and norm-representable) answer. Every system is therefore emitted fully
> expanded in the plain form `3*x1^2*x2-8`, and block (C) of
> `verify_phi8_degree.py` contains a live regression test for the mis-parse.

| block | content | why it is a real assertion |
|---|---|---|
| (0)(A) | `V_8`, `V_9` boxed over `Q`; degrees; `tau`-weight covariance; `grad F . V = 0 (mod F)` by exact division; `x ^ V != 0 (mod F)`; `deg F(V)`, `deg Q`, `deg R = 25, 28` | a wrong integral model fails the exact division immediately |
| (B) | the sealed `F_p` model rebuilt (machinery copied verbatim), `|G| = 660`, the boxed `D_5` cross-check, `N(8) = N(9) = 1`, and the boxed tuple lands in `Cov_m` and not in `Z_m` | this is what identifies the boxed object with *the* sealed minimal equivariant field |
| (B') | `iota`-covariance at eleven primes `> 10^18` plus an explicit archimedean height bound | upgrades (B) from `F_p` to an identity over `Q(zeta_11)` |
| (C) | msolve plain/parenthesised regression | guards the format bug described above |
| (D1) | the degeneracy locus is positive-dimensional; two random slices give `72` distinct points | settles preliminary issue (i) — against the audit's expectation |
| (D1') | Hilbert function of the leading ideal `= 72d + 147` for `24 <= d <= 30`; three slice factor-degree profiles at `p = 1 mod 11` | pins degree and `chi`, and forces an extra `0`-dimensional part of length `>= 75` |
| (D1'') | `D_8(F_23)` is one `G`-orbit of `60` points, `V_8 = 0` at each | an independent confirmation of equivariance, and orbit data for the carrier question |
| (D2) | ROUTE A: `209` points / minimal polynomial `210` off `D_8`; `208` / `208` after also removing `x = y`; five flag charts; two targets; two random inversions | measures both the count and the tangency multiplicity |
| (D3) | ROUTE B: `208` in the chart `x_0 != 0` and **empty** in the other four flag charts, at three targets, two primes, and over `Q` | the flag charts make the fiber count complete, not a sample |
| (D3') | ROUTE B at three random targets of `X(F_p)`, `p ~ 10^6` | the genericity guard for the upper bound |
| (D4) | the two routes agree: `210 - 2 = 208`; and `delta(phi_9) = 288` | the only place the two routes are compared |
| (D5) | at every target: `V_8(y) ^ y != 0` and `grad F(y) . V_8(y) = 0` | the structural reason the multiplicity at `x = y` is `2` |
| (E) | the inert-prime valuation criterion against brute force on `1..400`; `208 = 2^4·13`, `13` inert, `v_13` odd; `288`, `2` inert, `v_2` odd; iterates and composites; and that the **naive** `1753` *would* have been a norm | the detection test, plus the adversarial check that the excess correction was decisive |
| (F) | `3 <= delta <= d'^3-d'`; the sealed excess identity admits `zeta <= 616`, `a >= 0` | consistency with `COMBINED_DEGREE_SIEVE` |

---

## The earlier verifier

```
cd problems/E-klein-cubic/goal_runs_20260812/SELFMAP_DETECTION
python3 verify_selfmap_audit.py ; echo "EXIT=$?"
```

Expected tail, verbatim:

```text
  checks run : 133
  failures   : 0

RESULT: PASS
EXIT=0
```

Runtime ~12 s on the reference machine. Python 3 only — `fractions`, `math`,
`random`, `time`, `sys` from the standard library. No numpy, no sympy, no
Macaulay2, no msolve, no network. No floating point anywhere. Deterministic:
the two primes are found by a deterministic search from `10^6` and `3·10^6`, and
every `random` draw is seeded from the prime.

## What each block asserts

| block | content | why it is a real assertion |
|---|---|---|
| (A) | exact Molien / character arithmetic over `Z` and `Z[(1+sqrt(-11))/2]`: `I(k)`, `C(k)`, `S(n)` | compared entry-by-entry against the sealed published tables (`I`,`C` for `k = 0..24`; `S` for `n = 0..12`; the invariant-degree set `{0} ∪ {5,...}` for `k <= 80`). A wrong class datum or a wrong recurrence fails here |
| (B) | the tangent-section count `N(m) = Chat(m) - S(m+2) - S(m-1)` | asserts `N(m) = 0` for all `m <= 7`, `N(8) = 1`, `N(9) = 1`, `N(10) = 2`, and that the minimum of `{m : N(m) > 0}` is `8`. A different minimal degree fails |
| (C) | the group over `F_p` | `order(sigma) = 5`, `order(tau) = 11`, `order(iota) = 2`, Gauss sum squares to `-11`, `\|<sigma,tau,iota>\| = 660` by enumeration, `F(gx) = F(x)` for all three generators |
| (D) | `dim Cov_m` and `dim Inv_m` for `m <= 10` by explicit linear algebra | compared against the exact Molien values. Also: **the repository's boxed `D_5` spans the computed `Cov_5`** — this pins the model to the sealed one, and a wrong `iota` fails it |
| (E) | `dim K_m`, `dim Z_m`, `N(m)` recomputed from scratch for `m <= 10` | independent of `FOLIATION_REFORMULATION.md` Prop 5.1; agreement with (B) is a confirmation of that proposition, not an assumption of it |
| (F) | construction of `V_8` | re-verifies covariance by **direct substitution** for `sigma`, `tau`, `iota` (not by the seed construction that produced it), and `grad F·V_8 = c·F·h_7` in five variables |
| (G) | the plane section, and `deg_coord = 25` (resp. `28`) | asserts `deg R = 25`, that `Res_w(F\|_P, R_0\|_P)` has the full degree `75`, that `gcd(Res_w(F,R_0), Res_w(F,R_1))` is a **nonzero constant**, and that there is no common root on the line `v = 0`. A nonempty divisorial base locus fails all of these |
| (H) | dominance and nonidentity | an exact point `q in X(F_p)`; asserts `F(R(q)) = 0`, `Q(q,V_8(q)) != 0`, that `d tau_q` maps `T_qC(X)` into `T_{R(q)}C(X)`, and that its `4 x 4` determinant is nonzero |
| (I) | the tangent-residual cubic identity `F(R) = C^3F - C^2QL` on the plane | a degree-75 ternary polynomial identity, checked coefficient by coefficient |
| (J) | the audit arithmetic | the surviving `(d,k)` cells for `d' = 25, 28, 1`; the sealed exclusion set; the retraction-composition cells `(n d_0, n(d_0-1), n)` against `d = k+d'`, `k in {0}∪{5,...}`, `d >= 35`; the CLEAN norm form representing `1,3,4,5,9,11` and not `2,6,7,8,10`, and no value `≡ 2 (mod 4)` |

Blocks (C)–(I) run **twice**, at `p = 1000033` and `p = 3000229`, and block (G')
asserts that the two primes return the same coordinate degrees.

## Reproducing the two headline numbers by hand

`N(m)` from the sealed tables alone (`FOLIATION_REFORMULATION.md` §2 for `C`,
`I`; `S(n) = I(n)-I(n-3)`):

```
Chat(m) = C(m) - C(m-3):  m = 1..10  ->  1, 0, 0, 1, 1, 2, 2, 4, 4, 6
S(m+2):                                  0, 0, 1, 1, 1, 1, 1, 2, 2, 3
S(m-1):                                  1, 0, 0, 0, 0, 1, 1, 1, 1, 1
N(m):                                    0, 0, 0, 0, 0, 0, 0, 1, 1, 2
```

so the minimal equivariant tangent field has degree `8`, and

```
deg_coord(phi_8) <= 3*8 + 1 = 25,    with equality iff no divisorial base locus,
```

which block (G) certifies.

## Provenance of the model

`F = x_0^2x_1 + x_1^2x_2 + x_2^2x_3 + x_3^2x_4 + x_4^2x_0`;
`sigma : x_i -> x_{i+1}`; `tau = diag(z^{a_i})` with `a = (1,9,4,3,5) = (-2)^i
mod 11`; `iota` from the repository's Gauss-sum formula with index vector
`[1,3,2,5,4]` and sign vector `[1,1,-1,1,1]`, exactly as in
`goal_runs_20260811/RT_ACTUAL_LANDING/verify_d35_cells.py` §§B–C — reimplemented
over `F_p` here rather than imported, and cross-validated by recovering the
sealed `D_5`.

## If a check fails

Every `check(...)` prints its own `FAIL` line with the observed and expected
values before the summary, and the script exits `1`. The most informative single
failure mode is `dim Cov_m != C(m)`, which means the group model is wrong
(usually `iota`); the `D_5` cross-check is placed immediately after it for that
reason.
