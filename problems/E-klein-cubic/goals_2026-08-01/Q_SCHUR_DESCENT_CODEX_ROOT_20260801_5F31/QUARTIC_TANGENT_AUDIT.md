# Tangent twisted cubics do not automatically descend the quartic

## Proposed operation

Work on the cubic-surface hyperplane containing the primitive quartic point
from `QUARTIC_FRONTIER.md`.  After splitting the point and changing
coordinates, its four linearly independent conjugates are the coordinate
vertices of \(\mathbf P^3\).  Twisted cubics through the vertices have the
following dense normal form:

\[
\begin{aligned}
x_0&=\lambda_0s(s-v)(s-tv),&
x_1&=\lambda_1v(s-v)(s-tv),\\
x_2&=\lambda_2sv(s-tv),&
x_3&=\lambda_3sv(s-v).
\end{aligned}
\]

The four marked parameters are \(\infty,0,1,t\).  If the cubic surface
contains the four vertices, tangency at a vertex is linear in the four
scales after dividing by the square of the corresponding nonzero scale.
The four tangency conditions therefore form a \(4\times4\) matrix
\(M_F(t)\).

The determinant has the boundary factor \(t^4(t-1)^4\).  After removing it,
the remaining tangency equation has degree at most four.  The exact smooth
examples in `quartic_tangent_twisted_cubic_probe.json` have degree exactly
four and Galois group `S4`, so this upper bound is sharp and the four tangent
curves need not include a ground-field curve.

For a root of the tangency quartic, the cubic pullback has double zeros at
all four marked parameters.  Bezout on the degree-three twisted cubic gives

\[
3\cdot3-4\cdot2=1,
\]

so each tangent twisted cubic has one residual intersection point.  Galois
equivariance packages the four residual points into another quartic cycle.
The hoped-for shortcut was that this residual quartic might always be
coplanar, because the planar-conic argument would then descend it to a
quadratic cycle and a rational point.

## Exact split-input counterexamples

`probe_quartic_tangent_twisted_cubics.py` deterministically constructs three
smooth cubic surfaces over \(\mathbf Q\) through the four coordinate
vertices.  For each surface it computes:

1. the primitive tangency quartic;
2. its discriminant and Galois group;
3. the residual point in the quartic algebra; and
4. the determinant of the four-by-four coefficient matrix of its four
   conjugates.

All three tangency polynomials are separable with Galois group `S4`, and all
three residual span determinants are nonzero.  Thus the residual points span
\(\mathbf P^3\); automatic coplanarity is false even for a primitive `S4`
residual quartic on an exact smooth cubic surface.  The four marked input
vertices in these first examples are individually rational, so this packet
alone refutes a universal polynomial coplanarity identity but not an identity
that might follow specifically from a nonsplit input descent datum.

`verify_quartic_tangent_probe.py` independently rebuilds the first surface,
checks projective smoothness, reconstructs the tangency determinant, checks
the double-contact factorization modulo its quartic, verifies the serialized
residual coordinates, and recomputes their nonzero span determinant.

## Primitive `S4` input counterexample

The descent-datum caveat is removed by a second exact calculation.  Let

\[
q(u)=u^4-u+1,
\qquad L=\mathbf Q[u]/(q),
\qquad \Gamma=[1:u:u^2:u^3].
\]

The quartic is irreducible with discriminant 229 and Galois group `S4`, and
the four conjugates of \(\Gamma\) span \(\mathbf P^3\).  They lie on the
smooth cubic surface given by

\[
\begin{aligned}
F={}&x_0^3-x_0^2x_1+x_0^2x_2-x_0^2x_3-x_0x_1^2
 +3x_0x_1x_2+x_0x_1x_3-3x_0x_2^2\\
 &+x_0x_2x_3+x_0x_3^2-2x_1^3+3x_1^2x_2+2x_1^2x_3
 -3x_1x_2^2+3x_1x_3^2-x_2^3-3x_2^2x_3.
\end{aligned}
\]

Indeed \(F(1,u,u^2,u^3)=q(u)\).  The GP script
`probe_primitive_quartic_tangent.gp` builds the degree-24 splitting field,
moves the four actual conjugates to the vertices, and repeats the complete
tangency and residual computation there.  Its exact output is:

```text
splitting_field_degree=24
tangency_degree=4
tangency_discriminant_nonzero=1
residual_span_nonzero=1
```

Thus even a primitive, linearly independent `S4` input quartic can be sent by
the tangent-twisted-cubic operation to a noncoplanar residual quartic.
`verify_primitive_quartic_tangent.py` independently verifies the quartic
Galois group, the incidence, projective smoothness, and a clean GP replay.

## Scope

This is a universal-shortcut refutation, not a pointlessness theorem.  The
primitive-input counterexample surface itself has a rational point (for
example `[0:0:0:1]`); producing a primitive quartic on a *pointless* cubic
surface would enter the unresolved Cassels--Swinnerton-Dyer branch.  The
Voisin quartic on the generic Schur twist is existential and its coordinates
are not installed.  The calculation proves that tangency by twisted cubics
is degree-preserving in general and that neither primitivity nor the `S4`
descent datum forces coplanarity.  Any positive successor needs genuinely
special Schur geometry or a new descent theorem.
