# Degree ranking

The ranking is `31 > 35 > 25`.  It prioritizes the first new residual class,
then module size; degree 25 is ranked last only because its smaller strict
space already has a substantially deeper dedicated support route that remains
undecided.

| degree | role | full covariants over char. 0 | scalar invariants | landing invariants in degree `3d` | arrangement / strict at `p=89,199` | admissible `(m,e)` | mixed ansatz |
|---:|---|---:|---:|---:|---:|---|---|
| 31 | first unresolved `e=1` | 410 | 89 | 5349 | 198 / 176 | `(1,25),(3,13),(5,1)` | 28 directions; cubic corank 24; quartic dual 0 |
| 35 | first unresolved `e=5` | 637 | 139 | 8555 | 361 / 335 | `(1,29),(3,17),(5,5)` | 32 directions; cubic corank 21; quartic dual 0 |
| 25 | first unrestricted `e>=7` | 189 | 43 | 2343 | 59 / 43 | `(1,19),(3,7)` | 18 directions; cubic corank 13; quartic dual 0 |

The exact Hilbert-series denominator uses hsop degrees `3,5,6,8,11`; its
numerators and all coefficient calculations are in `degree_ranking.json`.
There is no new Hironaka covariant secondary born in 25, 31, or 35 (the last
one is born in 26), but this does not say that arbitrary sums share a scalar
factor.

For every selected degree the full arrangement kernel has zero simultaneous
first/second normal-jet kernel in both displayed good fibres.  This injective
special-fibre fact, unlike mere equality of kernel dimensions, excludes a
characteristic-zero plane-order-at-least-three covariant.  Hence only the
`m=1` residual row remains globally possible in this list.

The arrangement-native cross families have dimensions `9,15,15` and full
cubic landing ranks `165,680,680` at primes 89 and 199.  The composition
families have dimensions `9,13,17`; degree 25 has full cubic rank, and degrees
31 and 35 have cubic corank one but full quartic closure.  The stronger mixed
families are tested at primes 199 and 353 and also have full quartic closure.

All emptiness conclusions concern the named integral ansätze.  They are not
emptiness results for the full degree spaces.
