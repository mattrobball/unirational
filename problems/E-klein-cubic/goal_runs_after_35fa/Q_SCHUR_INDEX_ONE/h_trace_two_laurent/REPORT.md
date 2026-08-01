# Exact two-Laurent-term exclusion for the `11:5` trace cubic

## Theorem

Let

\[
 E=\mathbf C(r_0,\ldots,r_4)/(r_0r_1r_2r_3r_4-1),
 \qquad \sigma(r_i)=r_{i+1},
\]

and put

\[
 \Phi(a)=\operatorname {Tr}_{E/E^{\langle\sigma\rangle}}
 \bigl(r_2^{-1}a^2\sigma(a)\bigr).
\]

If `a` is a Laurent polynomial supported on at most two monomials and its
coefficients lie in `C`, then

```text
a != 0  ==>  Phi(a) != 0.
```

The Laurent exponents are unrestricted integers.  Thus this is an
all-exponent theorem, not a bounded exponent search.

Equivalently, after removing a nonzero overall scalar, write

\[
 a=m+t n,\qquad m=r^u,\quad n=r^v,\quad t\in\mathbf C^*.
\]

The only collision pattern for which the trace can vanish has `u=v` in
`Z^5/Z(1,1,1,1,1)` and `t=-1`; this gives the zero function `a=0`.

## Exact classification

Use the quotient-lattice coordinates `(r0,r1,r2,r3)`, with
`r4=(r0*r1*r2*r3)^-1`.  The cyclic action and the coefficient exponent are

\[
 S=\begin{pmatrix}
 0&0&0&-1\\
 1&0&0&-1\\
 0&1&0&-1\\
 0&0&1&-1
 \end{pmatrix},\qquad
 C=(0,0,-1,0)^T.
\]

Expanding `(m+t*n)^2*(sigma(m)+t*sigma(n))` gives six base terms with
coefficients

```text
1, t, 2*t, 2*t^2, t^2, t^3.
```

Put `w=v-u`.  Their exponent vectors are

\[
 C+(2I+S)u+A_iw,
\]

where

```text
A_i = 0, S, I, I+S, 2I, 2I+S.
```

Distinct cyclic Laurent-orbit sums have disjoint monomial support and are
linearly independent over `C`.  Consequently cancellation determines a set
partition of the six base terms into common cyclic exponent orbits.  The
verifier enumerates all Bell-number `B_6=203` partitions.  Exactly nine have
block coefficient sums with a common nonzero root.  For every such
partition it enumerates all possible shifts `0,...,4` relating exponents in
each block, for `7125` integer-lattice systems in total.

Each system is solved over `Z` by Smith normal form.  There are nine hits,
all duplicate presentations of the same degenerate case.  In each hit the
particular solution has `w=0`, and the entire rational nullspace has zero
`w`-projection.  Hence every integral solution has `w=0`.  Every common
coefficient factor is supported only at `t=-1`, so `a=0`.

The verifier separately re-merges the six exponents by their actual cyclic
orbit.  This makes accidental mergers between nominal partition blocks
harmless.

## Scope boundary

This theorem does **not** cover

- two monomials with coefficients that are nonconstant elements of
  `K=E^<sigma>`;
- three or more Laurent monomials;
- arbitrary rational functions in `E`.

The distinction in the first bullet is essential: different Laurent-orbit
sums are independent over `C`, but they are not independent over `K`.
Accordingly this packet is an exact ansatz exclusion, not a rational-point
or pointlessness decision for the generic twist.

