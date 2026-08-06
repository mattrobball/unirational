# FIX-VIII-A5LADDER — the A5 landing ladder (degree-11 point hunt)

**Exit: `PENDING`**

## Question
A nonzero A5-equivariant `T : W -> W` of degree `d` with `F(T) == 0` is an
A5-equivariant rational map `P(W) --> X`, i.e. an `L11`-point of `X_tw` for
`L11 = C(P(W))^{A5}` (degree 11 over `K_proj`).  Ladder searched: d = 2..12,
at p = 67 and p = 199.

## Stage 1 (both primes)
G660 rebuilt from the GATE generators: order 660, profile
`1:1 2:55 3:110 5:264 6:110 11:120`, `F` invariant.  A5 = `<a,b>` with
`a^2 = b^3 = (ab)^5 = 1`, order 60, 15 involutions.  `dim Hom(S^d W, W)^{A5}`
for d = 1..12 is `1 2 3 8 12 19 31 45 62 90 119 157`, equal to the A5-Molien
counts (`W|A5 = V5`, chi = (5,1,-1,0,0)) at both primes; every basis element
passes `T(gx) = g T(x)` at random points.

## Why plain LAND stops at d = 6
The sampled cubic system has K variables and at most `C(3d+4,4)/60`
independent cubics; the semi-regular solving degree is 6 at d = 6 (K = 19)
but 8 at d = 7 (K = 31, ~49M-column Macaulay matrix).  A direct msolve run
therefore decides only d <= 6.  The ladder is climbed instead by cutting each
`M_d^{A5}` with EXACT conditions first and running LAND on what survives.

## The fixed-locus reduction
For `g` in A5 and `U` its `lam`-eigenspace, equivariance gives
`T(U) subset E_{lam^d}(g)`; landing then forces the induced rational map
`P(U) --> X cap P(E)` to be CONSTANT whenever the target carries no rational
curve.  Verified hypotheses (both primes): `X` smooth; `F|_{V-} == 0` (the
55 lines); `C+ = X cap P(V+)` a SMOOTH plane cubic (genus 1); `F(v0) != 0`
for the isolated order-3 fixed point; `F|_{W_chi0}, F|_{E_w} != 0`.  So each
locus splits into `T|_U == 0` or `T|_U = h.q`, `h != 0`, with `q` in an
explicit finite candidate set (for `V+` and `V-`: the V4-common eigenvectors
on `C+`, at most 4 points).  Three further exact conditions are used:
 * `T == 0` on `V+(a) cap V+(a')` for every pair of distinct involutions
   (their image points `q_a`, `q_{a'}` are distinct: the A5-orbit of `q` has
   size 15, checked);
 * first order: `grad F(q)^T . DT(v) = 0` for all `v` in `U`;
 * second order: `h(v) gradF(q).T_2(v,u) + 1/2 T_1^t HessF(q) T_1 = 0`,
   quadratic in the coefficients (validated against a direct eps-expansion).
Every branch is a linear subspace of `M_d^{A5}`, and the landing cone is
contained in their union.

## Verdicts
(placeholder)

## Semantics
(placeholder)
