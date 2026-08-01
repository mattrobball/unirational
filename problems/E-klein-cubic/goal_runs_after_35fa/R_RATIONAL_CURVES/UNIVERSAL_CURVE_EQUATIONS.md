# Universal Pfaffian elliptic-quintic equations

## Exact model

Let \(M(x)\) be the skew \(6\times6\) matrix serialized in
`pfaffian_quintic_universal.json`. Its fifteen upper-triangular entries are
linear forms in \(x_1,\ldots,x_5\) over
\(\mathbf Q(\zeta_{11})\). Let \(A(x)\) be its Pfaffian adjugate, so the
fifteen upper-triangular entries of \(A\) are quadratic forms and

\[
M(x)A(x)=\operatorname{Pf}(M(x))I_6.
\]

For a section covector \(\lambda=(\lambda_1,\ldots,\lambda_6)^t\), define

\[
C_\lambda=V(A(x)\lambda)\subset\mathbf P^4.
\]

The payload lists all six bihomogeneous equations of bidegree \((2,1)\) in
\((x,\lambda)\), not merely their hashes. One equation is redundant on each
coordinate section; for a general \(\lambda\), five quadrics generate the
elliptic normal quintic ideal.

## Why these are section-zero equations

At a point \(x\in X\), \(M(x)\) has rank four and
\(\operatorname{im}A(x)=\ker M(x)=\mathcal K_x\). Thus

\[
A(x)\lambda=0
\quad\Longleftrightarrow\quad
\lambda|_{\mathcal K_x}=0.
\]

This is exactly the zero locus of the section of
\(\mathcal K^*=E_0(1)\) represented by \(\lambda\in V_6^*\).

Multiplying \(M(x)A(x)=\operatorname{Pf}(M(x))I_6\) by a nonzero
\(\lambda\) shows that every such curve lies on the Pfaffian cubic. The
producer independently expands the Pfaffian and identifies that cubic with
the original Klein equation, up to a recorded nonzero scalar.

## Exact geometric check

At

\[
(p,\zeta_{11},\lambda)=(23,2,(1,0,0,0,0,0)),
\]

the independent verifier reconstructs the five nonzero quadrics and obtains:

```text
projective dimension: 1
degree: 5
Hilbert numerator: 1 - 5*t^2 + 5*t^3 - t^5
minimal associated primes: 1
projective singular locus: empty
tangent dimension in the Klein cubic: 10
```

The coordinate-ring resolution is

\[
0\to R(-5)\to R(-3)^5\to R(-2)^5\to R\to R/I_C\to0.
\]

The Hilbert numerator gives \(P_C(t)=5t\), hence arithmetic genus one. The
good-reduction curve is smooth and prime. Its degree is the prime number
five; a geometrically disconnected smooth form would have five conjugate
degree-one components and Euler characteristic five, contradicting
\(P_C(t)=5t\). Hence it is geometrically integral.

For an lci curve on a cubic threefold,

\[
\chi(N_{C/X})=(-K_X)\cdot C=10.
\]

Macaulay2 recomputes \(h^0(N_{C/X})=10\), so \(h^1(N_{C/X})=0\). This
verifies the required tangent-obstruction statement at an exact point of the
geometric component.

## Descent boundary

The equations are \(G\)-equivariant and descend as a universal family over
\(\operatorname{SB}(A_{\rm proj}^{op})\). They do not produce a
\(K_{\rm proj}\)-curve because that Severi--Brauer base has index two and no
\(K_{\rm proj}\)-point.

