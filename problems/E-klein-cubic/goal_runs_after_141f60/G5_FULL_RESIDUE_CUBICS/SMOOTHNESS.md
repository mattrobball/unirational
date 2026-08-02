# G5.1 — residue cubics, smoothness, and index

## Markers

```text
G5-F5-CUBIC-MODEL-PASS
G5-F6-CUBIC-MODEL-PASS
```

## Specialization

Start from the sealed affine Hilbert--90 cubic

\[
\Phi(a)=F(a_0x+a_1C+a_2D+a_3E+a_4K)\in R[a_0,\ldots,a_4],
\]

with all thirty-five symmetric coefficients reduced against the free secondary
basis over \(A=\mathbf Q[f_3,f_5,f_6,f_8,f_{11}]\)
(`generic_cubic.json`).

For each site \(f_i\in\{f_5,f_6\}\):

1. discard every primary monomial divisible by \(f_i\);
2. leave the remaining free-module expression as the residue coefficient in
   \(R/(f_i)\);
3. observe that **no coefficient is entirely divisible by \(f_5\)**, and that
   at \(f_6\) the single vanishing coefficient is `x*x*C` (the others retain
   valuation zero);
4. therefore no common uniformizer power needs to be cleared: the projective
   model is already integral with at least one unit coefficient on a dense
   open of the residue field.

Payloads:

```text
f5/residue_cubic.json
f6/residue_cubic.json
```

Each stores the exact remaining terms (numerator, denominator, residual
primary exponents, secondary index) for all 35 coefficients.

## Agreement with H90 reduction

The sealed cubic **is** the Hilbert--90 model of the genuine twist in the
frame \((x,C,D,E,K)\).  Coefficientwise reduction of that model is exactly
the reduction of the twisted cubic attached to the residue torsor of G5.0, on
the open where the frame determinant is a unit.  No auxiliary Pfaffian plane
or fixed ternary frame is substituted.

## Smoothness

### Geometric reason

The generic fibre \(X_T\) is the twist of the smooth Klein cubic.  At an
unramified place with free rank-five reduction, the special fibre is a cubic
hypersurface in a split \(\mathbf P^4\).  Smoothness of the generic fibre and
the unramified finite-étale model imply that the special fibre is smooth on a
dense open of the base divisor; equivalently, the discriminant of \(\Phi\) is
not divisible by \(f_5\) or \(f_6\) after unit renormalization (recorded in the
upstream gauge audit as \(\gcd(D,f_5f_6)=1\)).

### Modular Jacobian witness

Independent of that global discriminant claim, the producer/verifier modular
probe specializes residual primaries and secondary generators at \(p=67\),
finds a point of the specialized cubic, and checks that the gradient is
nonzero.  Across full trial batches, every found point was smooth:

| site | prime | trials | smooth points |
|---|---:|---:|---:|
| f5 | 67 | 40 | 40 |
| f6 | 67 | 40 | 40 |

This is a consistency check for the specialized fibres, not a substitute for
the geometric reduction argument.

## Index one without a point

The universal fixed-subgroup cycles of degrees

\[
60,\quad 132,\quad 165,\quad 220
\]

with Bézout identity

\[
-13\cdot60+3\cdot132+165+220=1
\]

survive every scalar extension, including \(\kappa_5\) and \(\kappa_6\).  Thus
both residue cubics have index one.  **Index one is not a rational point** and
is not used as a negative or positive decision.

## Compact equations for arithmetic lanes

Each residue coefficient is a finite \(\mathbf Z\)-linear combination of
symbols

\[
\text{(residual primary monomial)}\times\text{(secondary basis element)}.
\]

Chart, line/conic, and polar workers over the residue field may evaluate these
expressions via the free-module presentation (or via the reduced affine
multiplication table).  No further Gröbner basis is required to *state* the
model; solving the point problem is G5.2.
