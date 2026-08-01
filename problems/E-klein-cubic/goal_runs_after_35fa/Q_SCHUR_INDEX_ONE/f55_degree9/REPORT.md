# Exact degree-nine `11:5` singleton-support theorem

Let `H=11:5=C11 semidirect C5`.  In the order-eleven eigenbasis with
weights `(1,9,4,3,5)`, an `H`-projectively equivariant homogeneous map of
degree nine is determined by the weight-one monomials in its first
coordinate.  Cyclic translation, with any one of the five `C5` projective
characters, determines the remaining coordinates.

At the split good prime `331`, expansion of

```text
F(q) = sum_i q_i^2 q_(i+1)
```

has the following complete size:

- `65` covariant coefficient variables;
- `2860` source-monomial landing equations;
- `697125` coefficient monomials across those equations.

The coefficient-term support is identical for all five projective
characters.  The self-contained producer regenerates the `11165448`-byte
support instance with SHA-256

```text
6d76ef7393f5a03131787ec149b9e6f3c43d39464befac19c8bebe312730be03
```

without checking in that generated binary.

## Exact deletion proof

For a nonzero coefficient vector, let `S` be the set of its nonzero
coefficients.  If some landing equation has exactly one coefficient
monomial supported in `S`, that equation cannot vanish.  Thus a solution
support would have to be a nonempty *stopping support*: every landing
equation has either zero or at least two active coefficient monomials.

Whenever a singleton `c_a c_b c_c` occurs, any possible child support must
delete at least one of its distinct coefficient variables.  Branching on
those deletions is exhaustive.  The frozen reverse-order checker memoizes
supports and uses incremental exact active-term counts.  It terminated with

```text
RESULT NO_STOPPING_SUPPORT NODES=26912397 SEEN=26912397
```

Therefore every nonempty coefficient support has a singleton landing
equation.  All five degree-nine projective landing schemes are empty over
the algebraic closure of `F_331`.  Since these are projective coefficient
schemes over the localization of the split cyclotomic integer ring, proper
specialization implies their characteristic-zero generic fibres are empty.

## Scope

This is exactly a complete, all-projective-character degree-nine
homogeneous-covariant exclusion for `H=11:5`.  It is not an all-degree
exclusion, not a pointlessness theorem for the generic `11:5` twist, and not
a decision of the genuine Schur twist.

