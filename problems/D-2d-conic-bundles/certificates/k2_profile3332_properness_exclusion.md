# Properness and exclusion of the base-point-free \([3^3,2]\) profile

## Statement

Let \(B\subset\mathbf P^2\) be a reduced degree-twelve branch divisor whose
canonical double-cover resolution has correction profile

\[
[3,3,3,2]
\tag{0.1}
\]

and whose cubic adjoint system vanishes as required by rationality.  Then
the three \(t=3\) centers are proper, distinct, and noncollinear.

Consequently, for a general bidegree-\((2,4)\) equation, no
base-point-free quadratic triple has profile \([3^3,2]\).  The all-proper
case was excluded in
[`k2_combined_proper_cluster_exclusion.md`](k2_combined_proper_cluster_exclusion.md);
the theorem below proves that there is no other base-point-free subrow.

This properness theorem is intrinsic to the reduced branch and does not use
the determinantal presentation.  The final incidence exclusion here is
scoped to base-point-free triples.  The separate resolved-bundle incidence
in [`k2_isolated_base_retained_profile_exclusion.md`](k2_isolated_base_retained_profile_exclusion.md)
excludes the isolated-base strata as well.

## 1. Exact adjoint subcluster

In the orthogonal total-transform basis, the adjoint cluster is

\[
D=2E_{v_1}^*+2E_{v_2}^*+2E_{v_3}^*+E_z^*,
\tag{1.1}
\]

where the \(v_i\) are the three \(t=3\) centers and \(z\) is the
\(t=2\) center.  Rationality requires

\[
H^0(\mathcal J_D(3))=0.
\tag{1.2}
\]

A coefficient-two point condition has colength at most three and a
coefficient-one condition has colength at most one, including at free or
satellite infinitely-near points.  Thus the complete cluster quotient has
length at most

\[
3+3+3+1=10.
\]

The ten-dimensional cubic space injects into this quotient by (1.2), so
the length is exactly ten and cubic evaluation is an isomorphism.

Delete the last summand and put

\[
K=2E_{v_1}^*+2E_{v_2}^*+2E_{v_3}^*.
\tag{1.3}
\]

Its quotient has length at most nine, while adjoining \(E_z^*\) can raise
colength by at most one.  Since the full quotient has length ten, the
quotient for \(K\) has length exactly nine.  Projecting the cubic-evaluation
isomorphism for \(D\) onto the quotient for \(K\) proves

\[
\boxed{h^0(\mathcal J_K(3))=1.}
\tag{1.4}
\]

Let \(C\) be this unique projective cubic.  Its strict transform has
multiplicity at least two at each of \(v_1,v_2,v_3\).

## 2. Classification of the unique cubic

Suppose first that \(C\) is reduced.

- An irreducible cubic has arithmetic genus one.  Every proper or
  infinitely-near multiplicity-two center lowers the genus bound by at
  least one, so it has at most one such center.
- If \(C\) is an irreducible conic plus a line, its double centers occur
  where the two smooth components meet, including successive centers over
  a tangency.  Their total number, counted along the resolution, is at most
  the intersection number two.
- If \(C\) is a union of three distinct lines, three double centers occur
  only when the lines form a triangle.  They are then its three distinct
  proper vertices.  If the lines are concurrent, blowing up the common
  point separates their three distinct tangent directions, so there is
  only one double center.

Hence a reduced cubic with the three marked double centers must be a
triangle, and the \(v_i\) are proper, distinct, and noncollinear.

It remains to exclude a nonreduced \(C\).  Every nonreduced plane cubic has
the form

\[
C=2L+M,
\tag{2.1}
\]

where \(M\) may equal \(L\).  At any proper or infinitely-near center where
the strict transform of \(C\) has multiplicity at least two, the strict
transform of \(L\) must pass through that center: away from \(L\), the
single line \(M\) contributes multiplicity at most one.  Therefore the
double line \(2L\) alone satisfies all three coefficient-two conditions in
\(K\).  It follows that

\[
L^2H^0(\mathcal O_{\mathbf P^2}(1))
\subset H^0(\mathcal J_K(3)).
\tag{2.2}
\]

The left side has dimension three, contradicting (1.4).  Thus \(C\) is
reduced and the triangle case is forced.  This proves the intrinsic
properness statement.

## 3. Determinant incidence

For a base-point-free quadratic triple, the all-proper triangle incidence
is exactly Section 1.2 of
[`k2_combined_proper_cluster_exclusion.md`](k2_combined_proper_cluster_exclusion.md).
Each side of the triangle has branch contact at least twelve.  Restriction
of the quadratic-form bundle to the three-line cubic has image dimension
fifty-four.  Allowing every balanced/unbalanced splitting, including zero
determinants on a side, the bad part has dimension at most thirty.  Hence
the fixed-\((\sigma,v_1,v_2,v_3)\) codimension is at least twenty-four.

The three proper vertices move in dimension six and the projective
base-point-free triple moves in dimension seventeen.  Therefore the
remaining equation-space margin is

\[
24-(6+17)=1.
\tag{3.1}
\]

This count deliberately forgets the \(t=2\) center.  It therefore includes
proper and infinitely-near positions of that center without any additional
jet argument.  The margin is strict, so a general equation has no
base-point-free quadratic triple with profile \([3^3,2]\).

The colengths, cubic classification budget, and incidence margins are
replayed by
[`k2_profile3332_properness_checks.py`](k2_profile3332_properness_checks.py).
