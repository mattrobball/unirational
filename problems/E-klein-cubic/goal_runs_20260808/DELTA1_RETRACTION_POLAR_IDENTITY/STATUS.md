# Status

The degree-one rational-retraction branch has an exact algebraic normal form
and an exact boundary.

* Every primitive normalized retraction has `T = H*x + F*Q`, with `H`
  invariant, `Q` covariant, and `gcd(H,F)=1`.
* The landing equation is equivalent to three polarized identities and the
  complete factorization

  ```text
  F(x+tQ) = (H*t-F)*(S*t^2-R*t-1).
  ```

* If `R^2+4S` is a square, the residual quadratic gives two landing
  covariants of degree `d-3`.
* The nonsquare branch is genuine: an exact primitive degree-nine
  retraction onto an irreducible (singular, non-equivariant) cubic has
  nonsquare residual discriminant.
* On `B=(F=H=0)`, every noncollapsed exceptional fibre is a line in `X`, so
  the degree-six line-incidence cover splits rationally over `B`.
  Invariant split divisors of this cover occur in unbounded classes, so this
  fact alone is not a finite obstruction.
* Iteration gives `T(T)=H(T)T` and cancels back to `T` after saturation.

No finite CAS target is forced by these identities.  The smooth
full-`PSL(2,11)` theorem needed to exclude the nonsquare residual cover or
the actual covariant base ideal is open.

```text
DELTA1-RETRACTION-POLAR-IDENTITY-PACKET-OK
DELTA1-KLEIN-RETRACTION-BRANCH-OPEN
HEADLINE-OPEN
```
