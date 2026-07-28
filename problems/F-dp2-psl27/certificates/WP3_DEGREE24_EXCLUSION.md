# WP-3 certificate: exact exclusion of degree 24

Date: 2026-07-28.

## Verdict

The complete degree-24 homogeneous Klein-covariant space contains no
dominant landing covariant.  Together with
[WP3_STRUCTURAL_BOUND.md](WP3_STRUCTURAL_BOUND.md), this moves the first
degree not excluded by the direct \(V\)-covariant route from \(24\) to
\(28\): degree \(26\) is also structurally impossible because it would
require a nonzero invariant of degree \(2\).

The later [degree-28](WP3_DEGREE28_EXCLUSION.md),
[degree-30](WP3_DEGREE30_EXCLUSION.md), and
[degree-32](WP3_DEGREE32_EXCLUSION.md) certificates exclude the next
spaces as well, so the current first open degree is \(34\).

This is still a bounded result.  It does not exclude all even degrees
\(d\ge34\), and is not a resolution of Problem F.  The exhaustiveness
lemma in [WP3_STRUCTURAL_BOUND.md](WP3_STRUCTURAL_BOUND.md) shows that the
remaining homogeneous degrees are the full generic-twist frontier, rather
than merely one optional construction route.

## Complete degree-24 space

With the invariant and covariant normalizations of
[WP3_COVARIANT_EXCLUSIONS.md](WP3_COVARIANT_EXCLUSIONS.md), every
degree-24 covariant is

\[
p=aF^4\psi+bFD^2\psi+cF^2\phi+dDf. \tag{1}
\]

The structural Jacobian theorem says that a primitive degree-24 landing
covariant satisfying \(F(p)=h^2\) must obey

\[
J_p=\kappa Xh,\qquad \kappa\ne0. \tag{2}
\]

The exact checker expands \(J_p\), divides each cubic coefficient block by
\(X\), decomposes the quotient in \(\mathbf Q[F,D,C]\), and reconstructs
the full polynomial.  It finds

\[
[DC^3]\,(J_p/X)=0. \tag{3}
\]

Thus (2) forces \([DC^3]h=0\).  In weighted degree \(48\), the remaining
ten invariant monomials have pairwise exponent sums that do not include
\((0,9,3)\).  Consequently

\[
[D^9C^3]\,h^2=0. \tag{4}
\]

On the other hand, the independent exact decomposition of the quartic
pullback of the complete family (1) gives

\[
[D^9C^3]\,F(p)=-2919616\,d^4. \tag{5}
\]

Equations (4) and (5) force \(d=0\).  The remaining covariant is

\[
p=F\bigl(aF^3\psi+bD^2\psi+cF\phi\bigr).
\]

Removing this common invariant factor reduces the landing identity to a
primitive degree-20 identity.  The structural theorem requires a primitive
even landing degree to be at least \(24\), a contradiction.

Hence the whole degree-24 space is excluded.

## Replay

From the certificates directory, with Python 3 and SymPy installed:

    python3 wp3_degree24_jacobian.py

It must end with

    EXACT d=24: coeff_(D*C^3)(J_p/X) = 0
    EXACT d=24: coeff_(D^9*C^3)(F(p)) = -2919616*R^4
    EXACT d=24: R=0 branch has common factor F and reduces to degree 20
    WP3_DEGREE24_EXCLUSION_OK

The computation is exact over \(\mathbf Z\) and \(\mathbf Q\).  It uses no
finite-field inference or floating-point calculation.
