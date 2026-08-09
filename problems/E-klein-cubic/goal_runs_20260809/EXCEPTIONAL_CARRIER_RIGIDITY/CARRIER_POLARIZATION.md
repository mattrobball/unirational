# Carrier polarization and base correction

## 1. Divisor identity

Let
\[
\rho:Y\to\Gamma
\]
be an equivariant principalization on which the landing map is a morphism.
Write
\[
\widetilde q^*\mathcal O_X(1)
\simeq
\widetilde\pi^*\mathcal O_X(d)\otimes\mathcal O_Y(-B),
\tag{1.1}
\]
where `B` is the effective base divisor determined by the pulled-back ideal.
All intersection formulas below are consequences of (1.1).  They do not depend
on the chosen principalization once the strict transform of a named intrinsic
curve is fixed.

## 2. Secondary elliptic-target carrier

Let `C_t` be a one-dimensional fixed carrier such that
\[
C_t\xrightarrow{\pi}E_t
\]
has degree `delta_t` and the target map is
\[
P\longmapsto[n]P+a
\]
on `E_t`.  Since `O_X(1)|E_t` has degree three,
\[
3n^2=3d\delta_t-B\cdot C_t.
\tag{2.1}
\]
This formula applies to a genuine elliptic-target curve carrier, not to a
surface before choosing a noncanonical section.

The ordinary carrier over `E_t` has source degree one when it is a curve, but
the accepted odd-jet theorem makes it line-valued.  Thus its degree-one result
does not prove `delta_t=1` for a hypothetical secondary elliptic selfcarrier.

## 3. Ordinary line-valued carrier over `E_t`

Suppose the ordinary carrier `K_{E_t}` is a curve.  Then it is birational to
`E_t` and maps to `L_t` with degree `ell_t`.  Since
\[
\deg\mathcal O_X(1)|_{E_t}=3,
\qquad
\deg\mathcal O_X(1)|_{L_t}=1,
\]
(1.1) gives
\[
\ell_t=3d-B\cdot K_{E_t}.
\tag{3.1}
\]
Residual equivariance forces `3 | ell_t`.  Equation (3.1) therefore gives only
a congruence on the base correction; it does not make the correction vanish.

If `K_{E_t}` is a surface, (1.1) is a divisor identity on that surface.  Its
Stein quotient is canonical, but a curve section is not.  No scalar formula may
be extracted by choosing an arbitrary section.

## 4. Carrier over `L_t`

Let `R_t` be a curve carrier birational to the original line and let the target
line map have degree `r_t`.  Then
\[
r_t=d-B\cdot R_t.
\tag{4.1}
\]
This includes the strict-transform case, where isolated base points on the
source line may still contribute to `B.R_t`.  Only a line completely disjoint
from the base scheme has correction zero.

If a fixed line has a surface ordinary carrier, use the divisor identity and
its Stein quotient; again there is no intrinsic section formula.

## 5. What the Rees theorem does force

For every **ordinary curve** carrier over an original fixed curve,
\[
\delta=1.
\]
This follows from the relative algebraic closure argument in the joint-residue
theorem.  The result is birational, not merely numerical.

The theorem does not force:

- existence of an elliptic-target ordinary carrier;
- degree one for a secondary fixed multisection inside a carrier surface;
- zero intersection with `B`;
- equality of the line and elliptic corrections.

## 6. The `[-5]` arithmetic

For a secondary elliptic carrier with multiplier `n=-5`, (2.1) is
\[
75=3d\delta_t-B\cdot C_t.
\tag{6.1}
\]
The familiar conclusion
\[
d=25
\]
requires both
\[
\delta_t=1
\qquad\text{and}\qquad
B\cdot C_t=0.
\]
Neither follows from the current normalized-Rees analysis.  Exceptional
carrier geometry may change the arithmetic by either a multisection degree or
a positive base correction.

## 7. Exact remaining polarization theorem

A degree-25 reduction would follow from the following explicit proposition.

> Every elliptic-target essential fixed carrier over `E_t` is the unique
> degree-one fixed curve in the normalized ordinary carrier, and the pullback
> base divisor is disjoint from it.

The first clause is a normalized-fiber/fixed-locus statement.  The second is a
multiplicity statement about the actual ideal.  Neither can be inferred from
the abstract fixed network.
