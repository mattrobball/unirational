# `11:5` trace-cubic all-degree audit

## Verdict

No unrestricted rational point and no all-points obstruction is proved here.
The exact point problem remains

\[
 \exists\,0\ne a\in E:\quad
 \operatorname{Tr}_{E/K}(r_2^{-1}a^2\sigma(a))=0.
\]

The new rigorous result is that neither finite module generation nor a
universal unique-exposed-monomial argument upgrades the degree-at-most-seven
calculation to all degrees.

## Exact covariant Hilbert series

For any of the five projective `C5` characters, a degree-`d` covariant is
determined by the monomials of total degree `d` and `C11` weight one for
weights `(1,9,4,3,5)`.  Direct residue counting gives dimensions

```text
d = 0..19
0,1,1,3,7,11,19,30,45,65,91,124,166,216,278,353,440,544,665,805.
```

Using the invariant-theory input that the full-`G` invariants of degrees
`(3,5,6,8,11)` form an algebraically independent homogeneous system of
parameters, restriction from `G` to `H=11:5` is finite and the
characteristic-zero module of `H`-covariants is free over this polynomial
hsop.  The verifier does not reconstruct that hsop or freeness premise; it
independently checks the resulting residue counts and numerator.  Multiplying
the Hilbert series by

\[
 (1-t^3)(1-t^5)(1-t^6)(1-t^8)(1-t^{11})
\]

gives secondary multiplicities in degrees `1..26`

```text
1,1,3,6,10,15,21,30,36,44,50,56,58,
59,59,54,50,43,37,28,22,16,10,6,3,2.
```

Their sum is `720 = (3*5*6*8*11)*5/55`, the expected generic rank.
Thus generators continue through degree 26.  More importantly, after
passing to the invariant field, arbitrary invariant-coefficient combinations
recover the same five-dimensional trace cubic; module generation supplies
no height bound for a rational solution.

Dividing invariant common factors does not repair this.  Let `e1,e2` be
free secondary generators of degrees one and two, whose existence is read
off from the numerator, and let `f3,f5` be hsop elements of degrees three
and five.  For every `k >= 0`,

\[
 f_3^{2+5k}e_1+f_5^{1+3k}e_2
\]

is homogeneous of degree `7+15k`, while its two `S`-coefficients are
coprime.  Thus even `S`-primitive homogeneous covariants have unbounded
degree.  These are not claimed to land on the cubic; they exactly refute a
module-theoretic primitive cutoff without using the landing equation.

## Exact failure of the naive Newton cutoff

The verifier stores the maximal 18-monomial degree-seven support surviving
singleton propagation.  Every landing equation on this coefficient torus
has either zero or at least two active coefficient monomials.  Nevertheless
the support is impossible because two literal equations are

\[
 c_0^2c_2+c_0c_{23}^2=0,
 \qquad
 2c_0c_2c_3+c_3c_{23}^2=0.
\]

All four displayed coefficients are nonzero on the support torus, so these
reduce to `A+B=0` and `2A+B=0`, a contradiction in characteristic zero.

Now translate every exponent in the support by
`k*(1,1,1,1,1)`.  This is multiplication by the honest `H`-invariant
monomial `(x0*x1*x2*x3*x4)^k`, changes the degree from `7` to `7+5k`, and
translates every source exponent by `3k*(1,1,1,1,1)`.  It preserves the
complete coefficient-equation pattern.  Hence there are no-singleton
supports in infinitely many degrees.  Any all-degree proof based on a
unique exposed monomial is therefore false unless invariant common factors
are removed first.

After removing that common factor the example returns to degree seven, but
this does not yield a primitive-degree cutoff: invariant-field combinations
of the 720 secondary covariants can have arbitrarily high polynomial height
without a common invariant divisor.  Proving that every primitive landing
covariant reduces to one of finitely many coefficient schemes would be a
new theorem and is not supplied by the Hilbert series.

## Literature boundary

Kaur--Reichstein, *Essential Dimension of Small Finite Groups*,
<https://arxiv.org/abs/2407.21449>, section 8, table row `GAP (55,1)`, records
`C11 semidirect C5` with representation dimension 5 and essential dimension
`3-4`.  Thus the current classification itself leaves precisely the binary
needed here open; it is not an external all-degree shortcut.

## Remaining exact gate

A genuine closure still requires either:

1. a rational `a` in the displayed trace equation; or
2. a primitive all-support theorem which goes beyond exposed vertices and
   controls every binomial-or-higher leading cycle, including invariant-field
   recombinations.

The bounded exclusions through degree eight are evidence only.
