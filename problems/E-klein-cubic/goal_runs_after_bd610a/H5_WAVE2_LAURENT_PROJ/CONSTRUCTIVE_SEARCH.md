# H5 WAVE2 — constructive multi-support search

## Structure theorem (menu necessity)

A Laurent monom `m = ∏ r_i^{e_i}` is fixed by `σ` for all product-one `r` if
and only if `e` is diagonal. On `r0⋯r4=1` every diagonal monom is the constant
`1`. Hence **the only Laurent-monomial elements of `K` are constants**.

Consequence: multi-support ansätze with coefficients in `K` must take
coefficients from genuine cyclic invariants (power sums, adjacent monomials
sums, products of those, …), not from nonconstant Laurent monoms in the `r_i`.

## Method

A candidate formula for `a∈E` is a K-point only if `Phi(a)=0` identically on
the product-one torus. Multi-prime random specializations:

- one specialization with `Phi≠0` **refutes** the identity;
- survival on all samples would require exact follow-up (none survived).

Modular zeros on individual fibres are **not** promoted to K-points.

## Screens (`constructive_search.json`)

| Screen | Scope | Tested (approx) | Hits |
|---|---|---:|---:|
| structure K-Laurent monoms | σ-fixed exponents bound 2 | structure | n/a |
| named formulas | 10 closed forms | 10 | 0 |
| additive H90 × K menu | bound 1 monoms | 336 | 0 |
| multiplicative H90 × K | bound 1 | 168 | 0 |
| binary `1+s m`, s in menu | bound 1 | 336 | 0 |
| two-support `c1 m1+c2 m2` | bound 1, 7-coeff menu | ~42k | 0 |
| three-cyclic K coeffs | bound 1 | ~20k | 0 |
| four-cyclic K coeffs | bound 1 | ~25k | 0 |
| sparse z invariants | support ≤3, 15-name menu | ~36k | 0 |
| local cyclic poly deg≤2 | coeffs ±1, supp≤3 | 1160 | 0 |

**Points over K:** none.

## Elimination note (binary)

For fixed monom `m`, `Phi(1 + s m)` is a cubic polynomial in `s` with
coefficients in `K`. Solubility over `K` is equivalent to that binary cubic
having a K-root. Menu specialization finds no root; a full function-field
rational-root / resolvent analysis remains open (next gate).

## Modular fibres

Twelve primes including holdouts `199,211,227`: specialized fibres routinely
admit random `z` with `Phi(z)=0`. Honest nonverdict for the binary decision.
