# Exact all-character degree-eight `11:5` exclusion

In the `C11` eigenbasis of weights `(1,9,4,3,5)`, a degree-eight
projective `11:5` covariant has `45` coefficients.  Expanding

```text
F(q)=sum_i q_i^2 q_(i+1)
```

gives `1845` source-monomial equations containing `232875` coefficient
monomials.  At the split good prime `331`, their coefficient-term support is
identical for all five projective `C5` characters.

For a putative nonzero coefficient vector, let `S` be its support.  If a
landing equation contains exactly one coefficient monomial supported in
`S`, it cannot vanish.  Deleting one variable from that singleton monomial
is an exhaustive branch: every solution support must lie in one of those
children.  Memoizing supports makes this a finite exact certificate.

Two different deterministic deletion orders independently return no
nonempty support on which every equation has zero or at least two active
terms:

| order | visited supports | result |
|---|---:|---|
| forward equations / high-occurrence variable first | 746332 | no stopping support |
| reverse equations / low-occurrence variable first | 142634 | no stopping support |

Thus every degree-eight landing scheme is projectively empty over
`algebraic closure(F_331)`.  Projectivity over the localization of the split
cyclotomic coefficient ring implies, by proper specialization, that the
characteristic-zero landing schemes are empty too.

Scope is exact but bounded: this excludes all degree-eight homogeneous
projective covariants for `11:5`.  It is not an all-degree result and does
not by itself prove the generic `11:5` twist pointless.

