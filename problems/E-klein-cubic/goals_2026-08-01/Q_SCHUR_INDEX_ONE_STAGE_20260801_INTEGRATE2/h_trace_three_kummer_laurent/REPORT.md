# Three-Kummer Laurent-monomial exclusion

## Exact theorem

Let

\[
 K=\mathbf C(U_1,U_2,U_3,U_4),\qquad
 E=K(\alpha),\qquad \alpha^5=U_1,
\]

and use the exact `H=11:5` normalization from
`../h_trace_three_kummer_planes/`:

\[
 \Phi(R_2b)=\operatorname{Tr}_{E/K}(H b^2\sigma(b)),
 \qquad H=R_2R_3^2.
\]

For every `0 <= p < q < r <= 4`, all nonzero constants
`c_p,c_q,c_r in C`, and all exponent vectors
`m_p,m_q,m_r in Z^4`, one has

\[
 \Phi\!\left(R_2\left(
 c_pU^{m_p}\alpha^p+c_qU^{m_q}\alpha^q+c_rU^{m_r}\alpha^r
 \right)\right)\ne0.
\]

Here `U^m=U1^m1 U2^m2 U3^m3 U4^m4`, with negative exponents
allowed.  Thus none of the ten three-Kummer planes has a point whose three
nonzero coordinates are each a single Laurent monomial, even with arbitrary
complex constants and arbitrary exponent size.

## Finite support proof

Homogeneity permits division by `c_p U^m_p`, so write the three coordinates
as

```text
(X,Y,Z) = (1, c*U^a, d*U^b),  a,b in Z^4,  c,d in C*.
```

The upstream exact coefficient formula has ten ternary-cubic monomials, and
each coefficient has seven distinct nonzero Laurent terms.  After the above
substitution there are therefore 70 individually nonzero contributions.  A
contribution with ternary exponents `(i,j,k)` and coefficient-support exponent
`e in Z^4` lands at

\[
 e+j a+k b.
\]

If the polynomial vanished, every one of these 70 contributions would have
to collide with at least one other contribution.  A possible collision gives
an exact vector equation

\[
 A a+B b=\delta,
\]

where `(A,B)` is the difference of the two `(j,k)` pairs and `delta` is the
difference of the two coefficient-support exponents.  Terms belonging to the
same ternary monomial have distinct support and cannot collide with each
other, so `(A,B)` is never `(0,0)` for an actual collision.

There are two exhaustive cases.

1. Two realized collision directions are nonparallel.  Their equations
   uniquely determine all eight integer entries of `(a,b)`.  The verifier
   enumerates every pair of nonparallel equations, retains every integral
   solution, reconstructs all 70 shifted exponents, and tests for singleton
   support groups.
2. All realized directions are parallel to one primitive pair `(A0,B0)`.
   Then every collision depends only on
   `h=A0*a+B0*b`.  The verifier enumerates every possible `h` coming from a
   collision equation and checks whether all 70 contributions can be matched
   using that same direction and `h`.

For each of the ten planes the exact counts are:

```text
distinct collision equations             1046
nonparallel equation pairs              474832
integral (a,b) candidates                67301
finite candidates with no singleton          0
parallel support families with no singleton   0
```

Thus support cancellation is impossible before the constants `c,d` are even
considered.  The result is consequently valid for arbitrary nonzero constants
in the full algebraically closed constant field `C`.

## Scope boundary

This theorem does not treat a coordinate that is a sum of two or more Laurent
monomials, and it does not treat an arbitrary rational function in `K`.
It supplies neither a point nor a pointlessness theorem for any whole genus-one
plane, and therefore does not decide the ambient Schur twist.
