# Fourier/Kummer two-basis-term exclusion

## Exact setting

Use the installed cyclic presentation

\[
 K=\mathbf C(U_1,U_2,U_3,U_4),\qquad
 E=K(\alpha),\qquad \alpha^5=U_1,\qquad
 \sigma(\alpha)=\epsilon\alpha,
\]

where `epsilon` is a primitive fifth root of unity.  Normalize the inverse
Fourier coordinates by

\[
 R_i=1+\epsilon^i\alpha+\epsilon^{2i}U_2\alpha^2
       +\epsilon^{3i}U_3\alpha^3+\epsilon^{4i}U_4\alpha^4.
\]

Then `sigma(R_i)=R_(i+1)` and `r_i=R_i/R_(i+1)`.  In particular the trace
cubic is

\[
 \Phi(a)=\operatorname {Tr}_{E/K}
 \left(\frac{R_3}{R_2}a^2\sigma(a)\right).
\]

## Theorem

For every `0 <= p < q <= 4`, every exponent vector
`v=(v1,v2,v3,v4) in Z^4`, and every `lambda in C*`, put

\[
 t=\lambda U_1^{v_1}U_2^{v_2}U_3^{v_3}U_4^{v_4},\qquad
 a=R_2(\alpha^p+t\alpha^q).
\]

Then

```text
Phi(a) != 0.
```

Thus no rational point arises from two distinct Kummer basis vectors whose
coefficient ratio is one invariant Laurent monomial.  Multiplying `a` by a
nonzero element of `K` scales `Phi(a)` by its cube, so the theorem equally
covers two Kummer terms whose two coefficients are individually invariant
Laurent monomials.

## Finite exhaustive reduction

Write `b=alpha^p+t*alpha^q`.  The special factor `R2` removes the trace
coefficient denominator:

\[
 \frac{R_3}{R_2}(R_2b)^2\sigma(R_2b)
 =R_2R_3^2b^2\sigma(b).
\]

The four powers of `t` in `b^2*sigma(b)` are

\[
\begin{array}{c|c|c}
k&\text{alpha degree}&\text{cyclotomic scalar}\\ \hline
0&3p&\epsilon^p\\
1&2p+q&\epsilon^q+2\epsilon^p\\
2&p+2q&2\epsilon^q+\epsilon^p\\
3&3q&\epsilon^q.
\end{array}
\]

Expanding `H=R2*R3^2` gives 35 nonzero terms.  Since

\[
 \operatorname {Tr}_{E/K}(\alpha^n)=
 \begin{cases}5U_1^{n/5},&5\mid n,\\0,&5\nmid n,\end{cases}
\]

the trace has the form

\[
 A_0+A_1t+A_2t^2+A_3t^3
\]

with each `A_k` supported on exactly seven monomials in the algebraically
independent variables `U1,...,U4`.

After substituting `t=lambda*U^v`, the `k`th support translates by `k*v`.
If an identity existed, any fixed monomial of `A0` would have to collide
with a monomial of some `A_k`, `k=1,2,3`.  Therefore

\[
 v=(e_0-e_k)/k
\]

for a pair of stored support exponents, with componentwise integral
division.  This gives exactly 39 candidate shifts for each of the ten
choices `(p,q)`, hence 390 candidates in total.  This step is exhaustive
for arbitrary integer exponents; there is no search radius.

For each candidate, the verifier groups equal translated monomials.  Every
group gives a polynomial of degree at most three in `lambda` over
`Q(epsilon)`.  It computes their common gcd using exact arithmetic in

```text
Q[epsilon]/(epsilon^4+epsilon^3+epsilon^2+epsilon+1).
```

After removing the irrelevant root `lambda=0`, all 390 common gcds are
constant.  Hence no permitted nonzero scalar exists.

## Scope boundary

This is an exact all-exponent exclusion for one structured family.  It does
not cover

- a coefficient ratio that is a sum or quotient of invariant monomials;
- three or more Kummer basis terms;
- an arbitrary element of `E`;
- a pointlessness theorem for the generic twist.

Accordingly the result sharpens the rational-point search but does not
decide the binary Schur goal.

