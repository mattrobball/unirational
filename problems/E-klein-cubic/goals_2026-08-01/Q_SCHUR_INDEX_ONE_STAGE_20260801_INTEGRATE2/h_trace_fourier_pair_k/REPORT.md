# Exact two-Kummer-basis exclusion over the full invariant field

## Theorem

Let

\[
 K=\mathbf C(U_1,U_2,U_3,U_4),\qquad
 E=K(\alpha),\qquad \alpha^5=U_1,
 \qquad\sigma(\alpha)=\epsilon\alpha,
\]

where `epsilon` is a primitive fifth root of unity.  Normalize

\[
 R_i=1+\epsilon^i\alpha+\epsilon^{2i}U_2\alpha^2
       +\epsilon^{3i}U_3\alpha^3+\epsilon^{4i}U_4\alpha^4.
\]

Then `sigma(R_i)=R_(i+1)`, `r_i=R_i/R_(i+1)`, and the genuine `11:5`
trace cubic is

\[
 \Phi(a)=\operatorname {Tr}_{E/K}
 \left(\frac{R_3}{R_2}a^2\sigma(a)\right).
\]

For every `0 <= p < q <= 4` and every `t in K`, one has

\[
 \boxed{\Phi\bigl(R_2(\alpha^p+t\alpha^q)\bigr)\ne0.}
\]

Equivalently, no point on the trace cubic is obtained from two distinct
Kummer basis vectors after the `R2` normalization, even when their
coefficient ratio is an **arbitrary rational function** in the full
invariant field `K`.

Multiplication of `a` by `K*` scales `Phi(a)` by a cube.  The result
therefore covers arbitrary nonzero coefficients on both displayed basis
vectors, after normalizing one coefficient to one.

## Exact trace reconstruction

Put `b=alpha^p+t*alpha^q`.  The coefficient denominator cancels literally:

\[
 \frac{R_3}{R_2}(R_2b)^2\sigma(R_2b)
 =R_2R_3^2b^2\sigma(b).
\]

The powers `t^k`, their alpha degrees, and their cyclotomic scalars in
`b^2*sigma(b)` are

\[
\begin{array}{c|c|c}
k&\text{alpha degree}&\text{scalar}\\ \hline
0&3p&\epsilon^p\\
1&2p+q&\epsilon^q+2\epsilon^p\\
2&p+2q&2\epsilon^q+\epsilon^p\\
3&3q&\epsilon^q.
\end{array}
\]

The verifier independently expands the 35 nonzero terms of
`H=R2*R3^2` in `Q(epsilon)[alpha,U2,U3,U4]`.  It applies

\[
 \operatorname {Tr}_{E/K}(\alpha^n)=
 \begin{cases}5U_1^{n/5},&5\mid n,\\0,&5\nmid n,\end{cases}
\]

and obtains

\[
 f_{p,q}(t)=A_0+A_1t+A_2t^2+A_3t^3\in K[t].
\]

Each `A_k` has exactly seven distinct, nonzero Laurent-monomial terms.

## Valuation certificate

For a primitive vector `w in Z^4`, let `v_w` be the monomial valuation on
`K`, defined on Laurent polynomials by

\[
 v_w\!\left(\sum_e c_eU^e\right)=\min_{c_e\ne0}\langle w,e\rangle.
\]

Because the `U_i` are algebraically independent, distinct terms in an
initial form do not cancel.  Primitivity gives `v_w(K*)=Z`.

For each of the ten pairs, `payload.json` records a primitive `w` and the
four exact values

```text
(v_w(A0), v_w(A1), v_w(A2), v_w(A3)).
```

Their lower Newton polygon is a single segment from abscissa zero to
abscissa three, of slope `s` with denominator three.  Explicitly:

| `(p,q)` | `w` | coefficient valuations | slope `s` |
|---|---|---|---|
| `(0,1)` | `(1,0,0,0)` | `(0,1,1,1)` | `1/3` |
| `(0,2)` | `(0,0,-1,0)` | `(-2,-2,-2,-3)` | `-1/3` |
| `(0,3)` | `(1,0,0,0)` | `(0,1,2,2)` | `2/3` |
| `(0,4)` | `(-1,0,-1,0)` | `(-4,-4,-5,-6)` | `-2/3` |
| `(1,2)` | `(0,0,-1,0)` | `(-2,-2,-2,-3)` | `-1/3` |
| `(1,3)` | `(-1,0,0,0)` | `(-3,-3,-3,-4)` | `-1/3` |
| `(1,4)` | `(0,0,0,-1)` | `(-3,-2,-2,-2)` | `1/3` |
| `(2,3)` | `(0,-1,0,0)` | `(-2,-2,-2,-3)` | `-1/3` |
| `(2,4)` | `(0,0,-1,0)` | `(-3,-2,-2,-2)` | `1/3` |
| `(3,4)` | `(0,-1,0,0)` | `(-3,-2,-2,-2)` | `1/3` |

If `t0 in K` were a root, put `m=v_w(t0) in Z`.  In the sum

\[
 A_0+A_1t_0+A_2t_0^2+A_3t_0^3
\]

the four term valuations are `v_w(A_k)+k*m`.  Cancellation requires their
minimum to occur at least twice.  A linear functional on a one-segment
lower Newton polygon has two minima only when `m=-s`.  But every recorded
`-s` has denominator three and is not in `Z`.  Hence one endpoint term has
strictly unique minimum for every `m in Z`, a contradiction.

This argument is over the actual algebraically closed constant field
`C`.  It does not rely on irreducibility over the smaller number field
`Q(epsilon)`.

## Scope boundary

The theorem excludes all two-basis expressions of the displayed form with
arbitrary `K` coefficients.  It does not exclude

- three or more Kummer basis vectors;
- another rational ansatz not reducible to this pair family;
- arbitrary `a in E`;
- a rational point or pointlessness on the full generic twist.

It is therefore a strict, exact narrowing of the positive gate, not the
binary Schur decision.

