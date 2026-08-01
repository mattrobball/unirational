# Lossless 105-by-20 marked-incidence compression

Fix a split good fiber with 55 distinct target points `p_i in P3`.  Choose a
target coordinate `y0` nonzero at every point and complete it to coordinates
`(y0,y1,y2,y3)`.  Put `r_ji=yj(p_i)/y0(p_i)` for `j=1,2,3`.

Let `tau_i` be 55 distinct affine source parameters and

`B(T)=product_i(T-tau_i)`, `w_i=1/B'(tau_i)`.

The dual of the length-55 degree-at-most-19 evaluation code says that a
vector `(v_i)` is evaluated by a polynomial of degree at most 19 precisely
when

`sum_i w_i v_i tau_i^m=0` for `0<=m<=34`.

If a marked degree-19 map exists, write its `y0` form as

`q(T)=sum_{k=0}^{19} q_k T^k`.

After pointwise projective scaling, the other coordinate values are
`q(tau_i) r_ji`.  Therefore the remaining 105 conditions are the linear
system

`H(tau) q = 0`,

where

`H[(j,m),k] = sum_i w_i r_ji tau_i^(m+k)`,

with `j=1,2,3`, `0<=m<=34`, and `0<=k<=19`.  Thus `H` has shape 105 by 20.

Conversely, a kernel polynomial `q` nonzero at every `tau_i` makes each
vector `q(tau_i)r_ji` interpolate in degree at most 19.  Together with `q`
these four polynomials give the marked map.  Hence, on this chart,

`marked incidence <=> rank H(tau)<20 and some kernel q avoids all tau_i`.

This is lossless: any 55 distinct points of `P1` can be moved away from
infinity, and a target coordinate can be chosen away from the finite marked
set.  It replaces the nonlinear 220-equation interpolation block by one
structured maximal-rank test while retaining immediate reconstruction.

## Exact modular reconnaissance

At `p=397`, `zeta_11=256`, and `h=(1,1,1,2,7)`, the independent replay gets
the exact Hilbert function `1,4,10,19,31,45,55`.  Here `X3` is nonzero at all
55 points and can be used as `y0`.

The deterministic probe first tested 5,305 distinct parameter vectors:

- 5,000 unrestricted random permutations of 55 field elements;
- 305 distinct evaluations arising in bounded target-polynomial searches of
  degrees one through six.

It then adds bounded rational-function evaluations of target degree one
through four.  Degree one includes arbitrary target linear projections to
`P1`, rather than only the fixed-denominator affine chart.  The exact count
of distinct tests is recorded in `hankel_probe.json` and independently
checked to exceed 5,305.

Every matrix had rank 20; no modular candidate was found.  A planted
degree-19 map independently produces a rank drop and reconstructs all four
forms, so the test is live.

This is reconnaissance, not emptiness.  It neither covers extension-field
points of the modular incidence nor lifts a characteristic-zero statement.
