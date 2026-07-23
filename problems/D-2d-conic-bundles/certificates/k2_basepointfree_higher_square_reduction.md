# Higher square-root reduction on the base-point-free \(k=2\) locus

## Statement

Let \(\sigma\) be a base-point-free triple of plane quadrics and let

\[
B_\sigma=\sigma^t\operatorname {adj}(A)\sigma
\]

be its degree-twelve determinant branch.  For a general bidegree-\((2,4)\)
equation:

1. no factorization

   \[
   B_\sigma=G^2C
   \]

   occurs with \(\deg G=3\) or \(4\); and
2. if such a factorization occurs with \(\deg G=5\), then \(G\) is an
   integral quintic.

Thus the base-point-free square-factor rows \(e=3,4\) are empty, and the
only \(e=5\) subrow not already excluded is the integral-quintic square
root.  The rows \(e=1\), the integral-quintic part of \(e=5\), and all
isolated-base analogues remain outside this corollary.

Subsequent certificates close the base-point-free \(e=1,5\) rows, the
isolated-base \(e=2,3,4\) rows, and the connected isolated-base \(e=5\)
row.  The remaining primitive square-factor frontier is the isolated-base
squared-line row \(e=1\); see
[`k2_isolated_cubic_quartic_component_exclusion.md`](k2_isolated_cubic_quartic_component_exclusion.md)
and the consolidated ledger in
[`k2_double_dodecic_frontier.md`](k2_double_dodecic_frontier.md).

## 1. The two inputs

Two previously proved base-point-free results are used.

- Section 4 of
  [`k2_double_dodecic_frontier.md`](k2_double_dodecic_frontier.md)
  excludes every integral cubic or integral quartic component of
  \(B_\sigma\).  This includes a component appearing with multiplicity two.
- [`k2_basepointfree_degree2_square_exclusion.md`](k2_basepointfree_degree2_square_exclusion.md)
  excludes

  \[
  H^2\mid B_\sigma
  \tag{1.1}
  \]

  for every degree-two form \(H\).  The theorem includes an integral conic,
  two distinct lines, and a doubled line, and does not require the residual
  quotient in (1.1) to be squarefree.

Both statements are uniform after \(\sigma\) moves in the full
seventeen-dimensional base-point-free triple space.

## 2. Degrees three and four

Factor \(G\) into irreducible homogeneous forms over \(\mathbf C\).

Suppose first that \(\deg G=3\).  If \(G\) has an integral cubic factor,
then that cubic divides \(B_\sigma\), contrary to the first input.  In every
other factorization, all irreducible factors have degree at most two.  If
there is a quadratic factor, take it for \(H\); if all factors are linear,
take the product of any two, with multiplicity.  In either case
\(\deg H=2\) and

\[
H\mid G\quad\Longrightarrow\quad H^2\mid G^2\mid B_\sigma,
\]

contrary to (1.1).

Now let \(\deg G=4\).  An integral quartic factor is impossible by the
first input.  A cubic factor is likewise impossible, because it is an
integral cubic component of \(B_\sigma\).  In every remaining
factorization all irreducible factors have degree at most two, and the same
choice of a degree-two divisor \(H\) contradicts (1.1).  This exhausts both
degrees.

## 3. Degree five

Let \(\deg G=5\) and suppose that \(G\) is not integral.  If an irreducible
factor has degree four or three, it is an excluded integral quartic or
cubic component of \(B_\sigma\).  Otherwise every irreducible factor has
degree at most two.  A quadratic factor itself, or the product of two
linear factors counted with multiplicity, supplies a degree-two divisor
\(H\mid G\), again contradicting (1.1).

Therefore every surviving degree-five square root must be irreducible and
reduced, hence an integral quintic.  No existence is asserted for that last
subrow.

The exhaustive factor-degree routing is replayed by
[`k2_basepointfree_higher_square_checks.py`](k2_basepointfree_higher_square_checks.py).
