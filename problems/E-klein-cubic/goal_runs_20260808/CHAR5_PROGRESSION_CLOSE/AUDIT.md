# Independent audit of the characteristic-five progression branch

**Date:** 2026-08-08  
**Status:** `EXACT THROUGH COVARIANT DEGREE 45 / DEGREE-50 PREFLIGHT ONLY / ALL-DEGREE OPEN`

## 1. Exact coefficient audit

For

\[
 f=x^{a_d}H^5+x^{b_{d,r}}K^5,
 \qquad d,r\in\mathbf F_5^*,
\]

the coefficient construction in
`../CHAR5_PROGRESSION_LOW_DEGREE/verify.py` is sound for the following
reasons.

1. The convention
   \(\rho(e)_j=e_{j-1}\) is the required shift: with
   \(W=(1,9,4,3,5)\), it multiplies `C11` weight by nine.
2. Renaming the fifth powers of the coefficients loses no geometric points,
   because Frobenius is bijective over the algebraic closure.
3. There is one common projective scaling, not independent scalings of
   `H` and `K`.  Fixing one nonzero `H` coefficient to one and adjoining
   `z*B_j-1` for one nonzero `K` coefficient gives an exact cover of
   `H != 0, K != 0`.
4. The ordered expansion of the two copies of `rho^i(f)` correctly supplies
   the cross coefficient two in characteristic five.

The independent SymPy implementation `check_first_degree.py` reconstructs
the monomial bases and the full landing coefficients without importing the
Singular verifier.  It gives unit ideals in every chart for all available
families at root degree two and for all sixteen families at root degree
three.  A separate replay of the Singular verifier at root degree four gave

```text
ROOT_DEGREE 4 SURVIVOR_FAMILIES []
F55-CHAR5-PROGRESSION-LOW-DEGREE-AUDIT-DONE
```

Thus the exact bounded conclusion in the sibling packet -- no two-residue
progression landing through covariant degree thirty -- is independently
supported.  It is not an all-degree result.

The dependency-free support verifier `verify_n5_support_unsat.py` further
proves that the necessary nonzero-support system is UNSAT for every family
at root degree five.  Hence covariant degree thirty-five is empty as well;
see `N5_SUPPORT_THEOREM.md`.

The same exact verifier at root degree six visits 9,136 DPLL nodes and proves
all sixteen support systems UNSAT.  Thus covariant degree forty is empty as
well; see `N6_SUPPORT_THEOREM.md`.

The sealed packet `N7_STATIC_CERTIFICATE/` extends the exact obstruction to
root degree seven.  Its dependency-free checker reconstructs all sixteen
landing systems and strictly replays 141,092 semantic-DPLL tree nodes with
70,554 conflict leaves.  Independent replay ends with

```text
F55-CHAR5-DEGREE45-SUPPORT-UNSAT-CERTIFICATE-OK
```

Thus exact-two-residue covariant degree forty-five is empty.  The checked
combined bounded conclusion is

```text
F55-CHAR5-TWO-RESIDUE-EMPTY-THROUGH-45
```

At root degree eight, `N8_PREFLIGHT/preflight_cadical.py` reconstructed the
necessary support CNFs and CaDiCaL reported UNSAT in all sixteen cases.  No
DRAT/LRAT proof or static semantic certificate was produced, by design.
Accordingly this is `UNSAT_PREFLIGHT_ONLY`: it does not prove emptiness in
covariant degree fifty and does not extend the checked bound beyond degree
forty-five.

## 2. A useful four-pattern normalization

Put \(\delta=r/d\in\mathbf F_5^*\).  As ordinary exponent vectors,

\[
                     b_{d,r}=\rho^{-\delta}a_d.
\]

If \(J=\rho^\delta K\), then `J` has the same ordinary degree as `H`
(its weight is the correspondingly shifted target weight).  On writing

\[
 P_i=x^{\rho^ia_d}(\rho^iH)^5,
 \qquad Q_i=x^{\rho^ia_d}(\rho^iJ)^5,
\]

one has the exact identity

\[
                         f_i=P_i+Q_{i-\delta}.
\]

This displays the four possible relative-shift patterns, while the four
choices of `d` and their forced root weights must still be retained.  It
does not polarize the landing equation: landing is known only for the
single relative scale occurring in `f`, so the pure `P` and `Q` equations
cannot be separated.

## 3. Determinant/Newton boundary

For the four universal matrices `M_c(z)`, direct exact determinant expansion
gives standard total-degree blocks

\[
                         0,5,10,15,
\]

constant term one, top term \((z_0z_1z_2z_3z_4)^3\), and degree at most
three in each `z_i`.  The support sizes are respectively

```text
c=1,2,3,4: 124,154,154,124.
```

A convex-hull computation gives 62,72,72,62 vertices.  In every case the
strict interior lattice points are the 32 points `{1,2}^5`, which span the
full five-dimensional affine space.  This makes the nondegenerate toric
compactification a general-type candidate.

That observation is not an obstruction here:

- the determinantal hypersurface has special singular strata, so
  nondegeneracy/canonicity of its normalization is a separate theorem;
- the characteristic-five ratio coordinates are fifth-power/Kummer
  expressions, so their map can be highly inseparable (general type does
  not rule out inseparable unirationality in characteristic `p`); and
- a landing only forces the actual incidence image to have dimension at
  most three, whereas the determinant hypersurface has dimension four.

Consequently a successful use of this compactification still needs a theorem
forcing a four-dimensional generically separable incidence image, or a
classification excluding its possible threefold images.

## 4. Verdict

The finite target is closed exactly through covariant degree forty-five, and
the four-pattern normalization is exact.  Root degree eight has only an
UNSAT solver preflight; root degree at least eight and the all-degree
two-residue branch remain undecided.

The annotated 212-row degree-seven core does not expose a finite inductive
template: only 38 core rows contain a pure coefficient cube, no complete
cyclic row orbit lies in the core, and its orbit closure has 1,060 rows.
Multiplication of both roots by the cyclic invariant `Q` carries a landing
from root degree `n` to `n+5`, but gives no converse without a theorem forcing
a common `Q` divisor.  The existing coordinate-valuation counterconfiguration
shows that such a divisor does not follow formally from boundary valuations
alone.

No polynomial landing counterexample was found, and no characteristic-five
or headline verdict follows.
