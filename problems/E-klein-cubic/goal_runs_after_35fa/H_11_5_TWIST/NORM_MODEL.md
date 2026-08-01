# Cyclic/Kummer norm model and exact remaining theorem

## 1. The degree-eleven layer

With `beta=y2/y3`, direct monomial calculation gives

\[
 \beta^{11}=b=\frac{r_0^2r_1r_3^4}{r_2^4},
 \qquad \sigma(\beta)=\frac1{r_2\beta^2}.
\]

Conversely, on `y0 != 0`,

\[
 \frac{y_1}{y_0}=\frac{r_0r_3}{r_2\beta^3},\quad
 \frac{y_2}{y_0}=\frac{r_2\beta^3}{r_3},\quad
 \frac{y_3}{y_0}=\frac{r_2\beta^2}{r_3},\quad
 \frac{y_4}{y_0}=\frac{r_2^2\beta^4}{r_3}.
\]

Thus `L=E(beta)` and the displayed formulas are inverse to the `r_i,beta`
construction.  They also give

\[
 \sigma(b)=r_2^{-11}b^{-2},\qquad \sigma^5(\beta)=\beta,
\]

which is the explicit compatibility of the degree-eleven Kummer layer with
the degree-five quotient.

## 2. The cyclic trace form

The twist is

\[
 \Phi(a)=\operatorname{Tr}_{E/K}\!\left(c\,a^2\sigma(a)\right)=0,
 \qquad c=\beta^2\sigma(\beta)=r_2^{-1}.
\]

Its coefficient has norm one:

\[
 N_{E/K}(c)=\prod_i r_i^{-1}=1.
\]

This does not remove `c`.  The relevant multiplicative map is

\[
 \psi:E^*\longrightarrow E^*,\qquad \psi(d)=d^2\sigma(d),
\]

not `d/sigma(d)`.  On the five-dimensional character lattice its matrix is
`2I+sigma`, of determinant `33`.

The class of `r2` in `E^*/psi(E^*)` has exact order eleven.  For
nontriviality, suppose `psi(d)=r2`.  Take divisors on the affine norm-one
torus.  Since `r2` is a unit there, `(2+sigma) div(d)=0`.  Every prime-divisor
orbit has size one or five, and the corresponding operator has determinant
`3` or `33`; hence `div(d)=0`.  Normality then makes `d` a unit of the torus,
so it is a constant times a Laurent character.  Modulo `product r_i=1`, its
exponent equation is

\[
 (2I+\sigma)v=e_2+n(1,1,1,1,1).
\]

The sum forces `n=1 mod 3`; changing `n` by three adds an integral diagonal
vector.  For `n=1` the unique solution is

\[
 v=(3,4,9,1,5)/11,
\]

so no integral character solves it.  On the other hand,

\[
 d=r_1r_2^6r_3^{-2}r_4^2
 \quad\Longrightarrow\quad
 d^2\sigma(d)=r_2^{11}.
\]

Since eleven is prime, the class has exact order eleven.  Norm one kills
only the visible norm constraint; it does not solve the coefficient
isogeny.

## 3. Exact point boundary

For nonzero `a in E`, the trace equation is equivalent to

\[
 c\,\psi(a)\in\ker(\operatorname{Tr}_{E/K}).
\]

Consequently

\[
 X_T(K)\ne\varnothing
 \quad\Longleftrightarrow\quad
 c\,\psi(E^*)\cap\ker(\operatorname{Tr}_{E/K})\ne\varnothing.
\]

This intersection statement is the smallest remaining theorem.  The
nontrivial order-eleven multiplicative class alone is not a pointlessness
obstruction because the target condition is additive trace zero.

## 4. Exact degree-five point and monomial screen

Over `E`, let

\[
 Z_0(T)=\prod_{k=1}^4(T-r_k).
\]

The trace frame sends its coefficient vector to

\[
 [\beta_0Z_0(r_0):0:0:0:0]\in X(E).
\]

This is the five-eigenpoint orbit expressed in the new coordinates.  It is
a degree-five closed point over `K`, not a `K`-point.

There is also an all-monomial scoped exclusion.  If `a` is one nonzero
Laurent monomial in the `r_i`, then `Phi(a)` is the `C5` orbit sum of a
single Laurent monomial.  The orbit has size one or five; in the first case
the sum is `5m`, and in the second its terms are distinct.  It is therefore
nonzero in characteristic zero.  This excludes every pure Laurent-monomial
ansatz, but not sums or general rational functions.
