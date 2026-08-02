# Exact `f5`, degree-16 small-support certificate

## 1. Scope

This packet advances the first timed-out bounded case in Goal V.  It concerns
homogeneous polynomial points in the primitive full frame on the residue
divisor `f5=0`.  It does not concern arbitrary rational residue coordinates.

A degree-16 candidate has the form

\[
P\,x+Q\,C+R\,D+S\,E+T\,K,
\]

where the frame degrees are `1,4,5,6,7`.  Modulo the degree-five primary
`f5`, the exact Hironaka quotient dimensions of the coefficient spaces are

| block | coefficient degree | dimension | variable indices |
|---|---:|---:|---|
| `P*x` | 15 | 7 | `0..6` |
| `Q*C` | 12 | 5 | `7..11` |
| `R*D` | 11 | 2 | `12..13` |
| `S*E` | 10 | 2 | `14..15` |
| `T*K` | 9 | 3 | `16..18` |

Thus the timed-out case has exactly nineteen coefficient variables.

## 2. Good-prime model

Work at the prime `67`, with an eleventh root of unity specialized to
`zeta_11=9`.  The replay reconstructs the two Weil-representation generators
and verifies

```text
ord(A)=2, ord(B)=11, ord(AB)=3,
|<A,B>|=660.
```

It also checks the four nontrivial primitive frame covariants against both
generators at every certificate point.  Nineteen Reynolds seeds give bases
of the five quotient coefficient spaces; their exponents are stored in the
payload.

At 151 explicitly stored `F_67`-points of `f5=0`, substitution in the Klein
cubic gives necessary homogeneous cubic equations in the nineteen
coefficients.  Their row span has rank `151` in the `1330`-dimensional space
of coefficient cubics.  The normalized row matrix has SHA-256

```text
0d77c030d4ed687c03f88c124534df6cf96cb964cafd7512c12af6eb325e7f67.
```

Any genuine degree-16 landing identity must satisfy these equations.

## 3. Exhaustive support ranks through size five

For a coefficient support `S` of size `s`, let `nu_3(P^{s-1})` be its cubic
Veronese image.  The sampled equations cut out a linear subspace in the
ambient space of `binomial(s+2,3)` cubic monomials.  A projective coefficient
point on support `S` can exist only if that linear kernel meets the Veronese.

The exhaustive ranks are:

| support size | supports | cubic dimension | rank histogram |
|---:|---:|---:|---|
| 1 | 19 | 1 | `1:19` |
| 2 | 171 | 4 | `4:171` |
| 3 | 969 | 10 | `10:969` |
| 4 | 3,876 | 20 | `20:3876` |
| 5 | 11,628 | 35 | `35:11620, 34:7, 30:1` |

Every full-rank support is projectively empty.

The seven rank-34 supports are

```text
{i,12,13,14,15},  i=0,...,6.
```

Each has a one-dimensional right kernel.  In every case the payload records
a `2 x 2` catalecticant minor with determinant `54 mod 67`; hence the kernel
line is not a cubic Veronese point, even after algebraic closure.

The remaining deficient support is the five-variable `Q*C` block

```text
{7,8,9,10,11}.
```

Here the exact identity is

\[
F(QC)=Q^3F(C)=Q^3f_{12}.
\]

At the first five stored `f5`-points, the five `f12` values are

```text
23, 57, 6, 42, 48,
```

all nonzero, while the `5 x 5` matrix of the `Q`-basis evaluations has
determinant `48 mod 67`.  Therefore no nonzero `Q` can satisfy the landing
equations on this support over an algebraic closure.

## 4. Characteristic-zero consequence

The nineteen Reynolds forms and the frame are integral at the chosen prime
above `67`.  Each fixed support defines a projective coefficient scheme over
the corresponding DVR.  A characteristic-zero point would extend after a
finite DVR extension and specialize to a geometric point whose support can
only shrink.  Since every special-fibre support of size at most five is
empty, all corresponding characteristic-zero support strata are empty.

Thus:

> **Certified conclusion.**  Every degree-16 polynomial landing candidate on
> `f5=0` using at most five of the nineteen quotient-basis coefficients is
> zero.  Any degree-16 survivor must use at least six coefficients.

This replaces the previous opaque timeout by a complete sparse-support
certificate.  It does **not** prove full degree-16 emptiness, arbitrary-degree
emptiness, residue pointlessness, or the Problem-E headline.
