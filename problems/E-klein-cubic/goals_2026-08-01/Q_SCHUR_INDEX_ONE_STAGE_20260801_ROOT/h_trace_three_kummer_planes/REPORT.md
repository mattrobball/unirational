# Ten three-Kummer planes: exact genus-one frontier

## Verdict

This packet proves a structural theorem about the ten three-coordinate
Kummer restrictions of the authoritative `H=11:5` trace model.  It does not
produce a rational point and does not prove pointlessness.

Let

\[
 K=\mathbf C(U_1,U_2,U_3,U_4),\qquad
 E=K(\alpha),\qquad \alpha^5=U_1,
 \qquad \sigma(\alpha)=\epsilon\alpha,
\]

where `epsilon` is a primitive fifth root of unity.  For every
`0 <= p < q < r <= 4`, the plane cubic

\[
 C_{pqr}:\quad
 \operatorname{Tr}_{E/K}\!\left(
 R_2R_3^2
 (X\alpha^p+Y\alpha^q+Z\alpha^r)^2
 \sigma(X\alpha^p+Y\alpha^q+Z\alpha^r)
 \right)=0
\]

is geometrically smooth.  Consequently each `C_pqr` is a geometrically
integral genus-one curve over `K`.  In particular, none of these ten generic
plane sections has a line component or a singular-point parametrization.

The previously verified full-`K` two-basis Newton theorem excludes points
with exactly two nonzero coordinates.  The reconstructed diagonal
coefficients are nonzero and exclude the three vertices.  Together these
facts show that a `K`-point on any `C_pqr`, if one exists, must satisfy
`XYZ != 0`.

## Compact exact equations

The authoritative normalization has

\[
 R_i=1+\epsilon^i\alpha+\epsilon^{2i}U_2\alpha^2
       +\epsilon^{3i}U_3\alpha^3+\epsilon^{4i}U_4\alpha^4
\]

and `sigma(R_i)=R_(i+1)`.  If `a=R_2 b`, cancellation of the trace
coefficient gives

\[
 r_2^{-1}a^2\sigma(a)
 =\frac{R_3}{R_2}(R_2b)^2(R_3\sigma(b))
 =H b^2\sigma(b),\qquad H=R_2R_3^2.
\]

Put

\[
 T_m=\operatorname{Tr}_{E/K}(H\alpha^m).
\]

Then `T_(m+5)=U1*T_m`, so the five seven-term polynomials
`T_0,...,T_4` serialized in `payload.json` determine every coefficient.
For variables indexed by Kummer exponents, the complete rule is

\[
\begin{aligned}
 [X_p^3]F&=\epsilon^pT_{3p},\\
 [X_p^2X_q]F&=(2\epsilon^p+\epsilon^q)T_{2p+q},\\
 [X_pX_q^2]F&=(\epsilon^p+2\epsilon^q)T_{p+2q},\\
 [X_pX_qX_r]F&=2(\epsilon^p+\epsilon^q+\epsilon^r)T_{p+q+r}.
\end{aligned}
\]

The verifier reconstructs `Q(epsilon)` as
`Q[e]/(e^4+e^3+e^2+e+1)` using only standard-library rational arithmetic.
It multiplies the three five-term factors defining `H`, obtains exactly 35
terms, reconstructs the five `T_m`, and compares the compact rule with an
ordered 27-term expansion cross-check for all ten triples.  The two paths
share the reconstructed `H` and trace arithmetic but implement the
combinatorics of `b^2*sigma(b)` separately.  Every one of the 100 resulting
ternary coefficients has the expected seven-term support.

## Geometric-smoothness certificate

Specialize exactly at

```text
(U1,U2,U3,U4) = (2,3,5,7)
```

over `Q(epsilon)`.  For each of the ten cubics, the verifier sends the exact
coefficient table to Singular.  If `J=(F_X,F_Y,F_Z)`, Singular proves that
each of

```text
J + (X-1),   J + (Y-1),   J + (Z-1)
```

is the unit ideal.  These three charts cover projective space, including
geometric points after extension of the coefficient field, so the
specialized cubic has no projective singular point.

Equivalently, its ternary-cubic discriminant is nonzero.  Therefore the
discriminant of the corresponding parameterized generic cubic is not the
zero polynomial.  It remains nonzero in `C(U1,U2,U3,U4)`, proving generic
geometric smoothness.  A reducible plane cubic over an algebraic closure is
singular at an intersection of its components, so geometric smoothness also
proves geometric integrality and rules out generic line components.

## Imported coordinate-line boundary

The packet is hash-bound to
`../h_trace_fourier_pair_k/`.  Its independently replayed marker is

```text
H_TRACE_FOURIER_TWO_BASIS_FULL_K_NEWTON_EXCLUSION_OK
```

That theorem treats every ratio in `K`, not only constants or Laurent
monomials.  Applying it to the three pairs in each coordinate plane excludes
every boundary point having exactly two nonzero coordinates.  At a coordinate
vertex, the cubic equals the corresponding nonzero diagonal polynomial
`epsilon^p*T_(3p)` times the nonzero cubed coordinate.  The verifier checks
these diagonal polynomials directly.  Thus the whole coordinate boundary has
no `K`-point.

## Exact scope

Proved:

- all ten compact plane-cubic equations;
- generic geometric smoothness and integrality for all ten;
- the coordinate boundary contains no `K`-point, by the imported full-`K`
  pair theorem together with the nonzero diagonal coefficients.

Not proved:

- a `K`-point or a pointlessness theorem for any `C_pqr`;
- a Jacobian, period, index, or torsor-class computation;
- a point or obstruction for the ambient twisted cubic threefold.

Thus the correct next arithmetic object is a list of ten smooth genus-one
torsors with explicit equations, not a rational parametrization.
