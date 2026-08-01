# Degree-six character isomorphism

Work over the split good field `F_331`, and let `zeta=64`, a primitive fifth
root of unity.  For an exponent vector `e=(e_0,...,e_4)`, put

```text
s(e) = sum_j j*e_j mod 5.
```

The first coordinate of a degree-six covariant has the 19 monomials of
`C_11`-weight one as its basis.  If their coefficients are `c_e`, the
character-`k` landing equations are obtained from

```text
sum_i zeta^(k*(3*i+1)) q_i^2 q_(i+1) = 0.
```

Consider a term using basis exponents `e_a,e_b,e_c` in cyclic summand `i`.
Its source exponent is

```text
E = shift_i(e_a) + shift_i(e_b) + shift_(i+1)(e_c).
```

Because each basis exponent has total degree six, hence degree one modulo
five,

```text
s(E) = s(e_a)+s(e_b)+s(e_c)+3*i+1 mod 5.
```

Consequently the diagonal coefficient substitution

```text
c_e |-> zeta^(-k*s(e)) c_e
```

sends the character-zero equation indexed by `E`, multiplied by the harmless
nonzero scalar `zeta^(k*s(E))`, to the character-`k` equation indexed by `E`.
It is an invertible linear change of the 19 projective coefficient
coordinates.  Thus all five degree-six landing schemes are isomorphic over
`F_331`; one complete character-zero scheme computation decides all five.

`verify_degree6_character_isomorphism.py` reconstructs all 3,200 coefficient
equations and checks this relation on all 90,250 nonzero coefficient terms.
It also checks the degree, prime, dimensions, and row ranks recorded in
`degree6_inputs.json`.

This is only a degree-six reduction.  It neither proves an all-degree
statement nor decides the rational-point problem for the genuine Schur
twist.
