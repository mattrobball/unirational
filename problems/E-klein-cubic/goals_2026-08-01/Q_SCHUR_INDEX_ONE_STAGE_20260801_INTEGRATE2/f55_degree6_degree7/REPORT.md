# Exact degree-six and degree-seven `11:5` covariant exclusion

Work over the split good prime `p=331`, with a primitive fifth root `64`.
In the `C11` eigenbasis of weights `(1,9,4,3,5)`, a homogeneous degree-`d`
projective `11:5` covariant is determined by the weight-one monomials in its
first coordinate.  The other coordinates are cyclic translates, multiplied
by any one of the five `C5` characters.  Expanding

```text
F(q) = sum_i q_i^2 q_(i+1)
```

therefore gives the complete landing ideal in the covariant coefficients.

## Degree six

There are `19` coefficient variables and `640` nonzero source-monomial
equations.  The term support is identical for all five projective characters.
For every one of the `2^19-1 = 524287` nonempty coefficient supports, some
landing equation restricts to exactly one nonzero coefficient monomial.
That equation cannot vanish on the corresponding coefficient torus.  Hence
every degree-six projective landing scheme is empty.

## Degree seven

There are `30` coefficient variables and `1125` nonzero source-monomial
equations.  Singleton propagation is exhaustive: whenever an equation has
one active monomial `a*c_i*c_j*c_k`, at least one of `c_i,c_j,c_k` must be
zero, so branching on those variables covers every possible support.

The deletion tree reduces all `2^30-1` supports to exactly `32` supports on
which no singleton equation remains.  For each of those supports and each
of the five projective characters, two active binomial equations impose

```text
c^u = r_1,    c^u = r_2,    r_1 != r_2 in F_331.
```

The `160` explicit incompatible pairs are stored in `certificate.json`.
Thus every degree-seven projective landing scheme is empty as well.

## Characteristic-zero consequence and scope

These coefficient schemes are projective over the localization of the
appropriate cyclotomic integer ring at the split good prime.  A
characteristic-zero projective point would have proper closure meeting the
special fibre.  Empty special fibre therefore implies empty generic fibre.

This is a complete all-character exclusion in degrees `6` and `7`.  It is
not an all-degree exclusion, and by itself it is not a pointlessness theorem
for the generic `11:5` twist.

