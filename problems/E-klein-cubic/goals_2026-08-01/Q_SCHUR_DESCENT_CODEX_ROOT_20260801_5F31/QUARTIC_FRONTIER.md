# The exact quartic frontier

Let

\[
K=K_{\rm Schur},\qquad X=X_{\rm Schur}\subset\mathbf P^4_K.
\]

The installed (D_{12})-line has full stabilizer (D_{12}), so its orbit is
a connected (K)-scheme of 55 geometric lines.  Choose a general
(K)-hyperplane (H\subset\mathbf P^4_K).  The following conditions are
simultaneously open and nonempty:

1. (S=X\cap H) is a smooth cubic surface;
2. (H) contains none of the 55 lines; and
3. every intersection with an orbit line is transverse and avoids every
   intersection between two orbit lines.

The field (K) is infinite.  Hence such an (H) exists.  Intersecting the
55-line orbit with (H) gives a reduced transitive degree-55 point

\[
z_{55,H}\subset S.
\]

Its geometric stabilizer is still (D_{12}), its residue field is
(E^{D_{12}}), and its Galois closure is the connected generic (G)-torsor
(E/K).  A general line in (H\simeq\mathbf P^3_K) gives the usual
degree-three zero-cycle on (S).  Thus (S) has index one.

Claire Voisin's current theorem for cubic surfaces in characteristic zero
states that a smooth cubic surface with a point over an extension of degree
coprime to three either has a ground-field point or has a point over an
extension of degree four.  Applying it to (z_{55,H}) gives

\[
S(K)\ne\varnothing
\quad\text{or}\quad
S(L)\ne\varnothing\text{ for some }[L:K]=4.
\]

Source: C. Voisin, *Rank 2 vector bundles and degrees of points of del Pezzo
surfaces*, Theorem 1.5 / Proposition 4.3,
<https://arxiv.org/abs/2509.17996>.

Because (S\subset X), the first alternative is the accepted Q-positive
exit.  In the second alternative, an effective degree-four cycle on (S)
exists.  If it had a degree-one component, it would already give a
(K)-point.  If it had a degree-two component, the line through the
quadratic conjugate pair on the cubic would give a residual (K)-point.
Every other nontrivial partition of four contains a degree-one component.
Consequently, under the hypothesis (X(K)=\varnothing), the Voisin
alternative is necessarily one integral closed point of exact degree four.

Therefore the exact strengthened frontier is

\[
\boxed{X(K)\ne\varnothing\quad\text{or}\quad
       X\text{ has an integral closed point of degree }4.}
\]

There is a further exact restriction in the no-point branch.  Let `L/K` be
the residue field of that quartic point.  If `L` contained an intermediate
quadratic field `M`, quadratic third-intersection first over `M` would turn
the `L`-point into an `M`-point; applying the same construction to the two
`K`-conjugates of that `M`-point would then give a `K`-point.  Hence under
`X(K)=empty`, `L/K` has no intermediate field.  The transitive degree-four
Galois-closure group is therefore primitive, so it is `A4` or `S4` (the
other transitive groups `C4`, `V4`, and `D4` preserve a two-block system).

Thus the no-point side can be sharpened to one primitive quartic point whose
Galois closure has group `A4` or `S4`.

There is also an exact projective-span restriction.  Let
\(\Gamma\subset S\subset\mathbf P^3_K\) be the integral quartic point.  Its
linear span is defined over \(K\).  A span of dimension zero is already a
\(K\)-point.  A span of dimension one is a \(K\)-line; Bezout says that the
line is contained in the cubic if it contains the degree-four scheme, and
then the line supplies \(K\)-points.

If \(\Gamma\) spans a plane \(\Pi\), the vector space of conics in \(\Pi\)
through \(\Gamma\) has dimension at least two.  Since \(K\) is infinite, one
can choose such a conic with no component in common with the plane cubic
\(S\cap\Pi\).  (Otherwise every conic in that vector space would have a
fixed curve component containing the integral orbit, forcing the span to be
a line.)  Bezout then gives a residual effective cycle of degree

\[
2\cdot3-4=2.
\]

Quadratic secant descent turns that cycle into a \(K\)-point.  Consequently,
under \(X(K)=\varnothing\), the quartic point must span the full
\(K\)-hyperplane \(\mathbf P^3\).

The full-span conclusion supplies a canonical rational-curve interface.  Let
\(L/K\) be the quartic residue field and write the point as
\([x_0:x_1:x_2:x_3]\), with \(x_i\in L\).  Full span says that the four
coordinates form a \(K\)-basis of \(L\).  Choose a primitive element
\(u\in L\).  Expressing the \(x_i\) in the power basis
\(1,u,u^2,u^3\) gives a matrix in \(\operatorname{GL}_4(K)\).  Transporting
the rational normal cubic

\[
[s:v]\longmapsto[s^3:s^2v:sv^2:v^3]
\]

by this matrix produces a \(K\)-defined twisted cubic \(C_\Gamma\) through
the quartic point.

If \(C_\Gamma\subset S\), its normalization \(\mathbf P^1_K\) immediately
supplies a point of \(S(K)\).  Otherwise Bezout gives an effective
intersection cycle of degree nine containing \(\Gamma\), hence a residual
effective cycle of degree

\[
3\cdot3-4=5.
\]

In the no-point branch this residual is one integral quintic point: every
nontrivial partition of five other than `5` contains a component of degree
one or two, and either such component descends to a \(K\)-point.  Likewise,
the quartic factor occurs with multiplicity one; double contact would leave a
linear residual factor.  Thus the no-point ledger contains a concrete
\(K\)-twisted cubic whose intersection is exactly a reduced integral `4+5`
cycle.

This does **not** decide which side occurs.  A quartic point on a cubic
surface is precisely the surviving Coray/Cassels--Swinnerton-Dyer boundary;
it must not be relabelled as a rational or quadratic point.  Likewise, the
fact that (G) has no subgroup of index four does not eliminate the quartic:
its residue field need not lie inside the degree-660 splitting field (E).

The smallest constructive successor is now exact: force an intermediate
quadratic field (which immediately descends to a point), force the quartic
into a plane, descend this primitive linearly independent quartic by the
55-line geometry, exploit the canonical integral `4+5` twisted-cubic
intersection, or prove that no primitive `A4/S4` quartic point can occur on
the full generic Schur twist.  Any such successor crosses the binary Q
boundary.
