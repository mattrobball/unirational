# Generic-fibre arithmetic and section audit

Put \(K=K_0(\mathbf P^1)\), and let \(S/K\) be the generic cubic-surface
fibre.

## Degree-three cycle

The plane \(u=0\) cuts out the center cubic after extending scalars to \(K\).
A transverse line in that plane gives a degree-three zero-cycle on \(S\), so
\(\operatorname{ind}(S)\mid3\).

## Degree-55 point for a general center plane

The exact involution-minus-line certificate proves that the Klein cubic
contains a line whose setwise stabilizer is \(D_{12}\).  Its orbit has

\[
[G:D_{12}]=660/12=55
\]

members.  On the connected generic twist this is a connected finite etale
scheme of 55 lines.

A plane meeting a fixed line belongs to a proper incidence divisor in
\(\operatorname{Gr}(3,5)\).  The complement of the 55 such divisors meets
the open of smooth cubic plane sections.  Since \(K_0\) is infinite and the
Grassmannian is rational, this open has a \(K_0\)-point.  For that choice,
projection maps each line isomorphically to the base, and their generic
intersections with the fibres form a closed point of exact degree 55 on
\(S\).

Hence

\[
\operatorname{ind}(S)\mid\gcd(3,55)=1.
\]

This proves index one, not a rational point.

## Section-or-quartic theorem

Voisin proves that a cubic surface over a characteristic-zero field which has
a point over an extension of degree prime to three either has a rational
point or has a point over an extension of degree four.  Applying this to the
degree-55 point gives:

1. \(S(K)\ne\varnothing\), hence a rational section and a headline-positive
   \(K_0\)-point of the generic Klein twist; or
2. \(S\) has a point over an extension of degree four.

In the second case, closure and normalization give a quartic multisection.
If the first case fails, it cannot secretly have residue degree one.  It
cannot have residue degree two either: the line through a quadratic conjugate
pair on a cubic in split projective space gives a ground-field residual third
point.  Thus the remaining multisection is genuinely degree four.

No theorem used here descends that quartic multisection to a section.  That
descent, or an obstruction to every section, is the smallest hard theorem
left by this link.

## Exceptional divisor

The exceptional divisor is \(C\times\mathbf P^1\).  It contains a section
exactly when \(C(K_0)\ne\varnothing\).  A degree-\(m\) point of \(C\) gives
only a degree-\(m\) exceptional multisection.  Sections outside the
exceptional divisor are not classified.
