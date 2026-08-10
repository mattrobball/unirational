# FIX-VIII-A5LADDER — the A5 landing ladder (degree-11 point hunt)

**Exit: `FIX-VIII-A5LADDER-EMPTY-THROUGH-10` +
`FIX-VIII-A5LADDER-D11-D12-UNDECIDED`** (see the last section)

## Question
A nonzero A5-equivariant `T : W -> W` of degree `d` with `F(T) == 0` is an
A5-equivariant rational map `P(W) --> X`, hence an `L11`-point of `X_tw` for
`L11 = C(P(W))^{A5}`.  Ladder searched: d = 2..12 at p = 67 and p = 199.

## Stage 1 (both primes)
G660 rebuilt from the GATE generators: order 660, profile
`1:1 2:55 3:110 5:264 6:110 11:120`, `F` invariant.  A5 = `<a,b>`,
`a^2 = b^3 = (ab)^5 = 1`, order 60, 15 involutions (generators in
`payload/stage1_p*.json`).  `dim Hom(S^d W, W)^{A5}`, d = 1..12:

```
 d     1  2  3  4  5  6  7  8  9 10  11  12
 dim   1  2  3  8 12 19 31 45 62 90 119 157
```

equal at both primes to the A5-Molien counts (`W|A5 = V5`,
chi = (5,1,-1,0,0)); every basis element passes `T(gx) = g T(x)`.

## Why plain LAND stops at d = 6
The sampled system has K variables and at most `C(3d+4,4)/60` independent
cubics; the semi-regular solving degree is 6 at d = 6 (K = 19) but 8 at
d = 7 (K = 31, a ~49M-column Macaulay matrix).  Direct msolve decides only
d <= 6, so each `M_d^{A5}` is first cut by EXACT conditions and LAND is run
on what survives.  (This is a strengthening of the briefed method, not a
substitute: LAND is still the decider inside every surviving branch.)

## The fixed-locus reduction
For `g` in A5 and `U` its `lam`-eigenspace, equivariance gives
`T(U) subset E_{lam^d}(g)`; landing then forces the induced map
`P(U) --> X cap P(E)` to be CONSTANT whenever the target carries no rational
curve.  Checked at both primes: `X` smooth; `F|_{V-} == 0` (V- is one of the
55 lines); `C+ = X cap P(V+)` a SMOOTH plane cubic (genus 1, so no nonconstant
map from `P^2` or `P^1`); `F(v0) != 0` at the isolated order-3 fixed point;
`F|_{W_chi0}, F|_{E_w} != 0`.  Each locus therefore gives `T|_U == 0` or
`T|_U = h.q`, `h != 0`, with `q` in an explicit finite candidate set (for
`V+`/`V-`: the V4-common eigenvectors on `C+`, at most 4 points).  Plus:
 * `T == 0` on `V+(a) cap V+(a')` for all pairs of distinct involutions
   (image points distinct: the A5-orbit of `q` has size 15, checked);
 * first order: `gradF(q)^t . DT(v) = 0` for `v` in `U`;
 * second order: `h(v) gradF(q).T_2(v,u) + 1/2 T_1^t HessF(q) T_1 = 0`,
   quadratic in the coefficients (validated against a direct eps-expansion).
Every branch is a linear subspace; the cone lies in their union; Galois
conjugate branches have conjugate verdicts, so one per orbit is tested.

## Verdicts

`payload/verdicts.json` carries the per-degree ledger and `results/checks.log`
every `CHECK` line.

```
 d    K    branches  max branch dim   verdict (both primes)
 2    2      0            0           EMPTY (linear certificate: every branch space is 0)
 3    3      0            0           EMPTY (linear certificate)
 4    8      0            0           EMPTY (linear certificate)
 5   12      0            0           EMPTY (linear certificate)
 6   19      0            0           EMPTY (linear certificate)
 7   31      0            0           EMPTY (linear certificate)
 8   45     80            1           EMPTY
 9   62      5           12           EMPTY
10   90    400           19           EMPTY
11  119     80           45           UNDECIDED — see below
12  157     25           60           UNDECIDED — see below
```

For d = 2..7 the exact conditions already collapse every branch space to zero,
so no solve is needed.  For d = 8, 9, 10 the ledger lines are

```
CHECK land_verdicts_d8_p67    PASS  [('EMPTY-GALOIS-CONJUGATE', 50), ('EMPTY-IDENTITY', 1), ('EMPTY-SUBSPACE', 29)]
CHECK land_d8_p67             PASS  all 80 branches EMPTY
CHECK land_verdicts_d9_p67    PASS  [('EMPTY', 1), ('EMPTY-GALOIS-CONJUGATE', 2), ('EMPTY-QUADRICS', 1), ('EMPTY-SUBSPACE', 1)]
CHECK land_d9_p67             PASS  all 5 branches EMPTY
CHECK land_verdicts_d10_p67   PASS  [('EMPTY-ALL-CUBICS', 1), ('EMPTY-GALOIS-CONJUGATE', 290), ('EMPTY-QUADRICS', 80), ('EMPTY-SUBSPACE', 29)]
CHECK land_d10_p67            PASS  all 400 branches EMPTY
CHECK land_verdicts_d8_p199   PASS  [('EMPTY-GALOIS-CONJUGATE', 30), ('EMPTY-IDENTITY', 1), ('EMPTY-SUBSPACE', 49)]
CHECK land_d8_p199            PASS  all 80 branches EMPTY
CHECK land_verdicts_d9_p199   PASS  [('EMPTY', 1), ('EMPTY-QUADRICS', 3), ('EMPTY-SUBSPACE', 1)]
CHECK land_d9_p199            PASS  all 5 branches EMPTY
CHECK land_verdicts_d10_p199  PASS  [('EMPTY-ALL-CUBICS', 1), ('EMPTY-GALOIS-CONJUGATE', 150), ('EMPTY-QUADRICS', 200), ('EMPTY-SUBSPACE', 49)]
CHECK land_d10_p199           PASS  all 400 branches EMPTY
```

No branch through d = 10 produced a `HIT`, and none was left
`UNDECIDED-TIMEOUT`.  There is no nonzero A5-equivariant `T` of degree
`d <= 10` with `F(T) == 0`, at either prime.

## d = 11 and d = 12: where the method stops

Both rungs are **UNDECIDED**.  The stopping point is structural, not a matter
of budget, and it is measured rather than asserted.

**1. The linear certificate provably cannot fire.**  `EMPTY-QUADRICS` fires
when the second-order landing quadrics span every quadric in the branch
coordinates.  `scripts/quadric_census.py` measures the achieved span on every
Galois-orbit representative (`payload/quadcensus_p*_11_12.json`):

```
 d=10  top branch dim 19   quadric rank  190 /  190   certificate FIRES
 d=11  top branch dim 45   quadric rank  291 / 1035   deficit  744
 d=12  top branch dim 60   quadric rank  398 / 1830   deficit 1432

CHECK quadric_census_d11_p199  PASS   0/80 branches settled by the linear certificate
CHECK quadric_census_d12_p199  PASS   0/25 branches settled by the linear certificate
```

The rank is a property of the branch, not of the sampling: 400, 800 and 1600
sample points give the identical rank at every branch tested.  The required
span grows like `r^2/2` while the available second-order rank grows roughly
linearly in `r`, so from `d = 11` on the certificate is out of reach for
*every* branch at both primes -- not merely the largest.

**2. msolve does not close the gap at the top branch.**  On
`V+:Wchi1|Ew:r0|Ew2:r0` (dim 45, `k_eff = 1`, 45 variables):

```
  d=11 V+:Wchi1|Ew:r0|Ew2:r0   dim 45 k 1 vars  45 -> UNDECIDED-TIMEOUT TIMEOUT   (p = 67)
  d=11 V+:Wchi1|Ew:r0|Ew2:r0   dim 45 k 1 vars  45 -> UNDECIDED-TIMEOUT TIMEOUT   (p = 199)
```

Both stages time out at the packet's 900 s cap: first the quadrics-only
system (291 quadrics in 45 variables), then the mixed system (150 mixed
cubics plus the 291 quadrics, a 40 MB / 42 MB generator file).  A separate
uncapped `msolve -g 2` on the quadrics-only system was stopped after 48 min
wall, 60 min CPU and 8.6 GB resident with no output.

**3. The all-cubics certificate is not a bounded gate either.**
`EMPTY-ALL-CUBICS` fires when the sampled landing ideal spans all
`C(47,3) = 16215` cubic monomials.  The sampled rank grows at about one per
sample point (400 points give rank 399), so a full span needs at least 16215
points and a dense 16215-column elimination -- about `4e12` field operations
with the packet's `rref`.  That is outside the bounded-gate discipline and was
not attempted beyond the measurement.

The honest reading: the fixed-locus reduction plus the second-order certificate
is a complete decision procedure through `d = 10` and stops being one at
`d = 11`, where the odd-degree branches are both larger (max dim 45 and 60
versus 19) and less constrained.

## Semantics and scope

* `EMPTY` at a degree means: no nonzero `T` in `M_d^{A5}` with `F(T) == 0`
  over `F_p`.  The sampled system contains the true landing ideal, so
  emptiness of the sampled variety is decisive for the cone; the branch
  decomposition is exhaustive because every fixed-locus condition is a linear
  subspace and the cone lies in the union of the branches.
* The scope is **mod p at two primes** (67 and 199), as declared in the
  manifest for this packet.  The `A5 < G660` realization, the eigenspace
  decomposition and the candidate image points are all constructed mod `p`, so
  this is evidence for the characteristic-zero statement, not a seal of it.
* The independent verifier rebuilds the group, the A5, the covariant spaces
  and the branch decomposition from scratch at both primes with different
  seeds and more sample points, and re-lands on **every** branch rather than
  one per Galois orbit.  With `VDMAX=10` it is `ALL PASS`:
  `v_land_d2..d10` at `p = 67` and `p = 199`
  (`results/verifier_d10_20260810.log`).
* Nothing here bears on degrees above 12, and nothing here is a statement
  about the F55 question itself; the A5 ladder is the `55 -> 11` descent
  route, and only a `HIT` would have moved it.

## Exit

```text
FIX-VIII-A5LADDER-EMPTY-THROUGH-10
FIX-VIII-A5LADDER-D11-D12-UNDECIDED
```

Not `FIX-VIII-A5LADDER-EMPTY-THROUGH-12`: `d = 11` and `d = 12` are undecided,
with the stopping point quantified above.  Not
`FIX-VIII-A5LADDER-DEVIATION`: the briefed method was followed and strengthened,
not replaced, and no briefed step was skipped.
