# Exact binary and ternary Kummer screens for the `11:5` trace cubic

## Setting

Use the installed minimal presentation

\[
K=\mathbf C(U_1,U_2,U_3,U_4),\qquad
E=K(\alpha),\qquad \alpha^5=U_1,\qquad
\sigma(\alpha)=\epsilon\alpha,
\]

and

\[
R_i=1+\epsilon^i\alpha+\epsilon^{2i}U_2\alpha^2
 +\epsilon^{3i}U_3\alpha^3+\epsilon^{4i}U_4\alpha^4.
\]

For `a=R2*b`, the genuine `11:5` equation is

\[
\Phi(a)=\operatorname {Tr}_{E/K}
 \left(R_2R_3^2b^2\sigma(b)\right)=0.
\]

All statements below concern this genuine trace model, not an auxiliary
specialization.

## 1. Every two-Kummer-basis slice is pointless

For every `0 <= p < q <= 4`, define

\[
P_{pq}(t)=\Phi\bigl(R_2(\alpha^p+t\alpha^q)\bigr)\in K[t].
\]

Then `P_pq` is an absolutely irreducible cubic in `K[t]`.  In particular,

\[
P_{pq}(t)\ne0\qquad\text{for every }t\in K.
\]

This is strictly stronger than the earlier Laurent-monomial ratio screen:
the coefficient ratio `t` may be an arbitrary rational function of all four
invariants.

The exact expansion has four `t`-coefficients, each supported on seven
invariant monomials.  Singular first factors every primitive polynomial over
`Q(epsilon)[U1,U2,U3,U4,t]`; all ten have one cubic factor and only possible
`U1` content.

Absolute irreducibility is certified independently of that relative
factorization.  For nine pairs, a one-parameter specialization has a single
Newton segment of horizontal length three and coprime vertical height.  The
exact valuation rows are:

| pair | retained variable | other constants | place | valuations of `t^0,t^1,t^2,t^3` |
|---|---:|---|---|---|
| `(0,1)` | `U1` | `(-2,-2,-2)` | `0` | `(0,1,1,1)` |
| `(0,2)` | `U1` | `(-2,0,-2)` | infinity | `(-2,-2,-2,-3)` |
| `(0,3)` | `U1` | `(-2,-2,-2)` | `0` | `(0,1,2,2)` |
| `(1,2)` | `U1` | `(-2,-2,0)` | infinity | `(-2,-2,-2,-3)` |
| `(1,3)` | `U1` | `(-2,-2,-2)` | infinity | `(-3,-3,-3,-4)` |
| `(1,4)` | `U1` | `(-2,0,-2)` | infinity | `(-3,-3,-3,-4)` |
| `(2,3)` | `U1` | `(-2,0,0)` | infinity | `(-2,-2,-2,-3)` |
| `(2,4)` | `U1` | `(-2,-2,0)` | infinity | `(-3,-3,-3,-4)` |
| `(3,4)` | `U2` | `(-2,-2,-2)` | infinity | `(-3,-2,-2,-2)` |

The Newton denominator forces every factor degree to be divisible by three.
For `(0,4)`, specialize `U2=U3=U4=-1` and retain `U1`.  Taking the norm from
`Q(epsilon)` to `Q` gives a 105-term bivariate polynomial.  Singular proves
that norm irreducible over `Q` and computes exactly four absolute factors.
They are one Galois orbit and have equal `t`-degree, hence are precisely the
four absolutely irreducible conjugate cubics.

If a generic `P_pq` factored over `C(U1,...,U4)`, normalize a factor to be
monic in `t`.  Its coefficients lie in the integrally closed localization at
the leading coefficient of `P_pq`; every displayed specialization keeps that
coefficient nonzero.  The factorization would therefore survive the
specialization, contradicting its absolute irreducibility.

## 2. No three-basis point with Laurent-monomial ratios

For every `0 <= p < q < r <= 4`, every `u,v in Z^4`, and every
`c,d in C*`, put

\[
b=\alpha^p+cU^u\alpha^q+dU^v\alpha^r.
\]

Then

\[
\Phi(R_2b)\ne0.
\]

The expansion has the ten parameter degrees

\[
\Delta_3=\{(i,j):i,j\ge0,\ i+j\le3\},
\]

and every parameter component has exactly seven invariant monomials.  Thus
there are 70 labelled support terms.  If the identity vanished, every
translated exponent would occur at least twice.

The collision differences in `Delta_3` cannot span rank zero.  Rank one is
also impossible: for each of the twelve primitive directions determined by
two points of `Delta_3`, at least one parameter vertex is isolated on every
line in that direction; its seven distinct terms cannot collide.

In rank two, one collision involving a fixed anchor and any independent
collision determine `u,v` uniquely.  Exact enumeration produces 66,144
integral candidates across the ten triples.  None makes every support group
have size at least two.  This precludes cancellation before the nonzero
constants `c,d` even enter.

## Boundary

These results do not cover arbitrary rational-function ratios in a
three-term vector, or any four- or five-basis vector.  They construct neither
a `K`-point nor a pointlessness obstruction for the full trace cubic.  The
generic `11:5` twist and the governing Schur twist remain undecided.

