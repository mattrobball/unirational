# FIX-VIII-A5LADDER — the A5 landing ladder (degree-11 point hunt)

**Exit: `PENDING`**

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

(pending)

## Semantics and scope

(pending)
