# Status — representative V4 simultaneous odd normals

**Exit:** `V4-SIMULTANEOUS-CLASSIFICATION-PASS`  
**New all-degree stratum exit:** `M1-TRIPLE-ORDER3-ALL-LINE-DEGREE-EMPTY`  
**Scalar-quotient exit:** `V4-TRISECTION-GENUS2-QUOTIENT-PASS`  
**Bounded corollary:** `DEGREE25-LANDING-EMPTY`  
**Route exit:** `V4-LOCAL-PATH-HEADLINE-ROUTE-REFUTED`  
**Problem E headline:** **OPEN**

## Proved

1. The complete pointwise coefficient equations for common plane order one and exact triple-line order three.
2. For arbitrary line degree, the corresponding A4-equivariant projective landing stratum is empty.
3. Combining that theorem with the sealed degree-25 filtration closes the formerly surviving 37-dimensional exact-order-three branch; degree-25 landing self-covariants are empty.
4. The nondegenerate common-plane-order-three equations factor into the reciprocal trisection branch and one quadratic parameter equation.
5. Exact reconstruction of the five-dimensional Weil representation gives
   `kappa_+ + kappa_- = 13/8`, `kappa_+ kappa_- = -1/2`, and hence
   `kappa_±=(13±3 sqrt(33))/16`.
6. The reciprocal scalar quotient is a smooth genus-two curve.  Therefore its parameters are constant in every rational line family; all positive line degree comes from toric-boundary crossing in the diagonal-scaling directions.
7. An exact primitive projective line-degree-six simultaneous trisection family supplies such a boundary-crossing curve; the honest W-linearization adds only the known character factor.
8. Hence a bare V4 incompatibility, projectively meaningful common-factor, or resolution-path argument cannot prove the negative headline.

## Not proved

- emptiness for m=1 and triple-line order at least four in arbitrary total degree;
- emptiness above the first permissible common-line layer for odd m at least three;
- a uniform global nonlinear obstruction for every toric-boundary crossing or changed boundary datum;
- non-unirationality of the Klein cubic.

## Replay

```sh
python3 verify.py
python3 verify_kappa_genus2.py
```
