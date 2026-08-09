# Covariant osculating cover: exact finite bounds

**Date:** 2026-08-08  
**Result:** `OSCULATING-COVARIANT-COVER-EXACT-SUPPORT-BOUNDED`  
**Headline:** `F55-QUESTION-OPEN`

## Exact system

Start with the covariant slice of the degree-nine Hermite contact system

\[
 A_k=r_k,\qquad f_k=1.
\]

Its fibre over the ordered-root base has ten variables

\[
 (d_0,\ldots,d_4,e_0,\ldots,e_4)
\]

and ten cubic equations, the five remaining `J3` and five remaining `J4`
contacts.  Their exact generic Newton-support sizes alternate

\[
                    9,31,9,31,9,31,9,31,9,31.
\]

Let `L_i` be the leading coefficient of `H_i`.  The top-degree open is
represented by the Rabinowitsch equation

\[
               z\prod_{i=0}^4L_i-1=0.                 \tag{1}
\]

This gives eleven equations in eleven variables.  Equation (1) has 244
terms: 243 terms from the product and the constant `-1`.

The support statement is replayed at two exact rational root tuples,

\[
 (1,2,3,4,1/24),\qquad (1,2,-1,-2,1/4),
\]

where the eleven supports agree term for term.  Since every displayed
coefficient is nonzero at either specialization, these terms occur on the
generic ordered-root base.  The structural Hermite formulas show that no
other monomials occur.

## Exact finite bounds

`gfan_mixedvolume` gives the exact mixed volume

\[
                         \operatorname{MV}=26264.       \tag{2}
\]

Thus the torus part of this particular saturated slice has at most 26264
isolated geometric points, counted with multiplicity, whenever Bernstein's
finite-intersection hypotheses apply.  This is a theorem-forced finite CAS
target, not an unbounded support or degree sweep.

The ordinary affine total-degree Bezout bound for the eleven-equation
Rabinowitsch system is

\[
                         6\cdot3^{10}=354294.            \tag{3}
\]

Unlike (2), (3) also bounds isolated affine points on coordinate
hyperplanes.  Neither bound asserts that the cover has that degree.

## What was not decided

The exact affine generic degree and factorization were not obtained.  In
particular, this packet neither produces nor excludes a degree-one
component, and it does not decide cyclic descent of such a component.

A degree-one cyclicly descended branch would give a rational degree-nine
contact construction and hence a point on the trace cubic, proving the
opposite of the requested negative headline.  Failure of this slice could
not prove the negative headline, because `A_k=r_k, f_k=1` is a slice rather
than a quotient of the full contact space.

`F55-QUESTION-OPEN`
