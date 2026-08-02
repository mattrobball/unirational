# Light section-scheme and binary-secant search

## Replayed exact model

`produce_section_search.py` reconstructs the pinned exact Schur and Weil
representations directly from their cyclotomic formulas.  It enumerates all
660 projective group elements and evaluates the degree-eight Reynolds frame
at two split primes:

| prime | \(\zeta_{11}\) | source point | \(\det Q\) | \(I_8\) | line-incidence product |
|---:|---:|---|---:|---:|---:|
| 23 | 2 | `(17,11,6,10,20,10)` | 2 | 21 | 5 |
| 67 | 9 | `(5,25,23,45,12,0)` | 10 | 34 | 43 |

At both points the three projective singularity charts for the center cubic
are unit ideals and all 55 involution-line incidence determinants are
nonzero.  The complete frames, center equations, determinant lists, and
hashes are in `section_search_payload.json`.

## Degree-three section component

For \(d=3\), write

\[
A_i=\sum_{j=0}^3 a_{ij}s^{3-j}t^j,
\qquad U=u_0s^2+u_1st+u_2t^2.
\]

Substitution gives ten cubic equations in fifteen affine coefficients.  The
producer finds the following basepoint-free witnesses, displayed as the five
binary cubics in coefficient order
\((s^3,s^2t,st^2,t^3)\):

### Modulo 23

Pair `(0,2)` gives

```text
A0 = ( 1,  6, 11,  1)
A1 = (13, 21,  6,  3)
A2 = (16, 17,  5,  5)
a3 = ( 9,  9, 15,  0)
a4 = ( 0,  9,  9, 15)
```

Thus `U=(9,9,15)`.  All ten equations vanish, the relative Jacobian has rank
10, and the first pivot minor has determinant `6 mod 23`.

### Modulo 67

Pair `(1,43)` gives

```text
A0 = ( 1, 33, 36, 30)
A1 = (18,  6, 11, 36)
A2 = (65, 16, 58,  2)
a3 = (12, 36, 38,  0)
a4 = ( 0, 12, 36, 38)
```

Thus `U=(12,36,38)`.  The relative Jacobian again has rank 10; the pivot
minor is `44 mod 67`.

Because the minors use only section variables, these are standard-smooth
points of the relative coefficient scheme over the source-parameter base.
The affine local dimension is five and the projective local dimension is
four.  The corresponding component is horizontal and survives in geometric
characteristic zero.  This proves geometric existence, not a rational point
on the descended component over \(K\).

## All binary secants of the 55 line sections

Each involution line avoids the center and therefore gives a horizontal line
section after splitting.  For every unordered pair \((P,Q)\), the cubic on
the fibrewise secant is

\[
F(zP+wQ)=zw(c_{21}z+c_{12}w),
\]

so the third point is represented by

\[
c_{12}P-c_{21}Q.
\]

The scripts cancel the common binary-form gcd and compare the resulting
rational sections projectively.  All 1,485 pairs are defined at both good
specializations.

The six group orbits on unordered pairs have sizes

\[
330,330,165,165,165,330
\]

in the deterministic payload order.  Their secant-image cardinalities are

\[
330,330,55,165,165,330
\]

at both primes.  Thus five orbit maps are injective at the chosen fibres and
the remaining orbit is exactly three-to-one there; most importantly, none is
constant.  The total number of distinct outputs is 1,375 at each prime.

A characteristic-zero singleton collapse would impose projective polynomial
identities between all outputs in an orbit.  Such identities would survive
at every denominator-open good specialization, contradicting either exact
finite-field computation.  Hence no binary secant orbit of the installed
55-line cover descends a rational section.

## Scope

This search does not exclude:

- a point on the exceptional center cubic;
- a \(K\)-point of the degree-three or a higher section component;
- constructions using tangencies, auxiliary divisors, or higher-arity
  residual operations;
- the integral quartic multisection supplied abstractly when no section
  exists.
