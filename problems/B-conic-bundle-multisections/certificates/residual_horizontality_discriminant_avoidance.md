# Residual horizontality without Grothendieck--Lefschetz

This note gives an elementary replacement for the Picard-group step in
`ResidualHorizontalityLine.det_residualYCoordsOn_ne_zero`.  It changes the line-selection
interface, not the headline theorem: besides G3, choose the multisection line so that its residual
surface is not contained in the discriminant of the second (conic) projection.

## 1. The extra condition

Let

\[
  \pi_y:X\longrightarrow \mathbf P^2_y
\]

be the conic projection and let \(\Delta\subset\mathbf P^2_y\) be its degree-nine discriminant.
For a framed line \(L\), write \(q_L(x,y)\) for the residual equation.  It is bihomogeneous of
bidegree \((10,1)\), before removal of a possible common factor in the \(x\)-coefficients.  Let
\(T_L\) be the irreducible closure of the tangent-residual image of the nondegenerate stereo
chart.

Add the condition

\[
  \tag{G4} T_L\not\subseteq \pi_y^{-1}(\Delta).
\]

In the coordinate chart used by Lean, G4 can be stated without first constructing \(T_L\): the
homogeneous conic-discriminant form evaluated on `residualYCoordsOn` is a nonzero polynomial.  It
is independent of the choice of nondegenerate Tsen parametrization because every such chart is
dense in the same vertical surface.

## 2. G3 plus G4 implies horizontality

Assume that the image of \(T_L\) in \(\mathbf P^2_y\) is not dense.  It cannot be a point: the
stereo-Jacobian theorem makes \(T_L\to\mathbf P^2_x\) dominant, whereas a fibre of \(\pi_y\) is a
curve.  Thus its image is an irreducible plane curve \(D=V(H)\), with \(H\) irreducible and
homogeneous of degree \(d>0\).

By G4, \(D\) is not contained in \(\Delta\).  Hence the generic conic of

\[
  X_D=X\times_{\mathbf P^2_y}D\longrightarrow D
\]

is smooth and geometrically integral.  The conic projection is flat: it is a relative quadratic
hypersurface and smoothness of \(X\) rules out a whole \(\mathbf P^2_x\)-fibre.  Flatness is
preserved by base change.  The standard flat-base plus geometrically-integral-generic-fibre lemma
therefore shows that \(X_D\) is integral.

Now \(T_L\subseteq X_D\), and both dominate \(\mathbf P^2_x\).  On the generic fibre over
\(\mathbf P^2_x\), the integral scheme \(X_D\) is zero-dimensional, hence the spectrum of a
field.  The nonempty closed generic fibre of \(T_L\) is consequently the whole generic fibre.
Taking closures gives

\[
  T_L=X_D.
\]

The residual identity says that \(q_L\) vanishes on \(T_L\), so it vanishes on all of \(X_D\).
Equivalently, after the usual irrelevant-ideal saturation,

\[
  q_L\in(F,H).
\]

There is no saturation ambiguity in the bidegree \((10,1)\) piece: the flatness/no-whole-fibre
condition makes \((F,H)\) the bihomogeneous prime defining \(X_D\).  Thus there are bihomogeneous
forms \(A,B\) with

\[
  q_L=A F+B H.
\]

Degree comparison is decisive.  The \(y\)-degrees are

\[
  \deg_y(q_L)=1,\qquad \deg_y(F)=3,\qquad \deg_y(H)=d>0.
\]

The `AF` term is impossible.  The `BH` term is possible only for \(d=1\), and then \(B\) has
bidegree \((10,0)\).  Therefore

\[
  q_L(x,y)=B(x)H(y).
\]

This is exactly `ResidualLineConstantOn`, contradicting G3.  Hence \(T_L\) is horizontal.  One
may feed this geometric dominance directly to the residual-component consumer; the reverse
Jacobian criterion is unnecessary.  If the old determinant API is retained, characteristic-zero
separability then converts dominance back to the nonzero projective Jacobian.

## 3. A line satisfying G3 and G4 exists

Work first with the generic smooth plane cubic

\[
  C=X_{k(\mathbf P^2_x)}\subset\mathbf P^2_{y,k(\mathbf P^2_x)}.
\]

The already formalized first-projection theorem makes \(C\) smooth.  It is not a constant cubic:
a constant generic fibre would make \(F=Q(x)f(y)\), contradicting smoothness.  Consequently
\(C\) is not a component of the constant discriminant curve \(\Delta\).  Choose
\(y'\in C\setminus\Delta\) after algebraic closure of the generic field.

The tangent-residual map \(g:C\to C\) is nonconstant (in fact finite of degree four).  Use the
Hesse/Weierstrass normal-form bridge: after choosing a flex as origin, the chord-and-tangent law
identifies \(g\) with \([-2]\).  In Hesse coordinates this can alternatively be checked from the
explicit quartic residual formulas already used by `HesseResidualCertificate`.  Therefore the
image of \(g\) is dense in \(C\), so some \(p\in C\) has \(g(p)\notin\Delta\).  Any sufficiently
general line through \(p\) has this point among its three line-section points and consequently has
a residual point outside \(\Delta\).  Thus G4 is a nonempty open condition on the dual plane of
lines.

The tempting shortcut using the two equations

\[
  f(p)=0,\qquad \sum_i y'_i\,\partial_i f(p)=0
\]

is not sufficient by itself: \(p=y'\) is always a common zero by Euler's identity, so a bare
projective common-zero theorem does not produce a distinct tangent preimage.  A formal proof must
use nonconstancy/degree of the residual map (or control the remaining intersection multiplicity),
not just existence of a common zero.

G3 is also open.  Concretely, write the three degree-ten coefficient forms of \(q_L\) as the rows
of a `3 x 66` coefficient matrix.  `ResidualLineConstantOn` is rank at most one, so G3 is witnessed
by a nonzero `2 x 2` minor.  Starting with the line already supplied by `exists_good_line`, fix one
minor which is nonzero there.

For a Lean-friendly avoidance argument, join a G3 line and a G4 line by a one-parameter family of
frames.  After clearing powers of the determinant in the inverse frame:

* the chosen G3 minor is a univariate polynomial nonzero at one endpoint;
* the residual-discriminant witness is a univariate polynomial nonzero at the other endpoint;
* the frame determinant is another nonzero polynomial.

Their product is nonzero.  Since the algebraically closed ground field is infinite, choose one
parameter where the product does not vanish.  The resulting frame satisfies G3, G4, and
invertibility simultaneously.  This replaces the source's general appeal to intersecting finitely
many nonempty open conditions by a finite polynomial argument.

## 4. Lean decomposition

The intended implementation is split at the following exact interfaces.

1. Define the homogeneous second-projection discriminant
   `sndConicDiscriminant F : MvPolynomial (Fin 3) k` as the determinant of the polar matrix of the
   universal ternary quadratic over `MvPolynomial (Fin 3) k`.  Prove homogeneity of degree nine and
   compatibility with `genericSndConicChartZero`.
2. Define `ResidualAvoidsConicDiscriminantOn` by nonvanishing after evaluation on
   `residualYCoordsOn`, and prove invariance under a nondegenerate stereo reparametrization.
3. Prove the flat, geometrically-integral base-change lemma for an integral plane curve not
   contained in the discriminant.  Reuse `IntegralOpenCover`, `ConicFlatnessBricks`, and the
   geometric-integrality result being developed for `PointedConicRationalFamilies`.
4. Prove the bihomogeneous low-`y`-degree lemma:

   ```text
   q has bidegree (a,1), F has bidegree (2,3), H is homogeneous of degree d>0,
   q in (F,H)  ==>  d=1 and q=B(x)H(y).
   ```

   This is coefficient bookkeeping, not divisor theory.
5. Package Sections 1--2 as direct scheme dominance of the residual component.  Keep the current
   determinant theorem only as a corollary if it remains useful elsewhere.
6. Strengthen `exists_good_line` to return G3 and G4 using the one-parameter avoidance argument of
   Section 3, then thread the new witness through `MainTheorem`.

This route uses no Picard group, Lefschetz theorem, effective-cone calculation, line-bundle
cohomology, or reverse Jacobian criterion.
