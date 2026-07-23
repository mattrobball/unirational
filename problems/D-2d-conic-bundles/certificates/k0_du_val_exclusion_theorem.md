# No rational class-\((1,0)\) divisor on a general \((2,4)\) member

## Theorem

Let

\[
X=\{F(x,y)=0\}\subset\mathbf P^2_x\times\mathbf P^2_y
\]

be a general hypersurface of bidegree \((2,4)\) over \(\mathbf C\).  For
every line \(\ell\subset\mathbf P^2_x\), the surface

\[
S_\ell=X\cap(\ell\times\mathbf P^2_y)
\]

is integral and normal and has only Du Val singularities.  Its minimal
resolution has

\[
p_g=3.
\]

In particular, no divisor of class \(H_x\) on a general \(X\) has rational
normalization.  Equivalently, the degree-two multisection class \((1,0)\)
does not contribute a rational surface.

Indeed, restriction identifies
\(H^0(\mathbf P^2_x\times\mathbf P^2_y,\mathcal O(1,0))\) with
\(H^0(X,\mathcal O_X(H_x))\), so every member of \(|H_x|\) is one of the
surfaces \(S_\ell\) above.

This is the first D-specific result in the exclusion frontier.  It does not
use the class-\((1,1)\) incidence theorems from Problem B.

## 1. The general net of plane quartics

Projection to the first factor gives

\[
\rho:X\longrightarrow\mathbf P^2_x,
\qquad
C_x=\{F(x,-)=0\}\subset\mathbf P^2_y.
\]

The fifteen coefficients of \(C_x\) are quadratic forms in \(x\).  For a
general equation they have no common zero, and hence define a morphism

\[
\phi_F:\mathbf P^2_x\longrightarrow
\mathbf P H^0(\mathbf P^2_y,\mathcal O(4))\simeq\mathbf P^{14}.
\]

Let \(\mathcal D\subset\mathbf P^{14}\) be the discriminant hypersurface of
singular plane quartics.  Its general point is a quartic with one ordinary
node.  The two codimension-two strata relevant to a general surface map are

- quartics with two ordinary nodes; and
- quartics with one ordinary cusp.

Quartics with a worse singularity, three singular points, a nonreduced
component, or a reducible decomposition form strata of codimension at least
three.  For example, the largest reducible stratum, line plus cubic, has
dimension \(2+9=11\), hence codimension three in \(\mathbf P^{14}\).

Fix a finite algebraic Whitney stratification refining the singularity
strata just listed.  The family of equations is sufficiently general for
stratified transversality.  At a fixed \((x,y)\), varying the coefficient of one
quadric in \(x\) that is nonzero at \(x\) permits an arbitrary variation of
the quartic in \(y\).  Variations of quadrics also separate first jets in
the \(x\)-directions.  Thus the universal evaluation map from the
coefficient space times \(\mathbf P^2_x\) to \(\mathbf P^{14}\) is a
submersion, including on the required first-jet spaces.  Algebraic generic
transversality therefore gives, for a general \(F\):

1. \(\phi_F\) is transverse to the one-node stratum;
2. it meets the two codimension-two strata transversely in finitely many
   points; and
3. it avoids every stratum of codimension at least three.

Consequently the discriminant curve

\[
D=\phi_F^{-1}(\mathcal D)\subset\mathbf P^2_x
\]

has only ordinary nodes and ordinary cusps.

## 2. Irreducibility and degree of the discriminant

There is a useful intrinsic check that no base line is contained in \(D\).
Let

\[
\Sigma=\{(x,y):F_{y_0}=F_{y_1}=F_{y_2}=0\}
\subset\mathbf P^2_x\times\mathbf P^2_y.
\]

Euler's identity puts \(\Sigma\) on \(X\).  For a general equation the three
partials cut transversely, so \(\Sigma\) is a smooth complete-intersection
curve of three ample divisors of class \((2,3)\).  The connectedness theorem
for ample complete intersections makes it connected; smoothness then makes
it irreducible.

The projection \(\Sigma\to D\) is generically one-to-one, because a general
singular plane quartic has one node.  Moreover,

\[
\deg D
=H_x(2H_x+3H_y)^3
=54.
\]

It follows that \(D\) is an irreducible plane curve of degree \(54\).  In
particular, no line \(\ell\subset\mathbf P^2_x\) is contained in \(D\).

## 3. Restriction to an arbitrary line

Fix any line \(\ell\subset\mathbf P^2_x\).  Away from \(D\), the fiber
\(C_x\) is smooth and the total surface \(S_\ell\) is smooth.  Since
\(\ell\not\subset D\), it remains to inspect finitely many points of
\(\ell\cap D\).

### A one-node fiber

Near the node, transversality gives analytic coordinates in which the total
family is

\[
uv=a(s,t),
\]

where \(D=\{a=0\}\) is smooth in the base.  If \(z\) is a parameter on
\(\ell\) and \(a|_\ell\) has order \(m\ge1\), the restricted surface is
analytically

\[
uv=z^m.
\]

For \(m=1\) it is smooth; for \(m\ge2\) it is the Du Val singularity
\(A_{m-1}\).  This covers transverse intersections, ordinary tangencies,
flex tangencies, and arbitrary higher finite contact of \(\ell\) with the
smooth part of \(D\).

### A two-node fiber

At a node of \(D\), the quartic has two ordinary nodes.  Their two smoothing
parameters \(a,b\) are local coordinates on the base.  At the two distinct
points of the fiber the local equations are independently

\[
u_1v_1=a(s,t),
\qquad
u_2v_2=b(s,t).
\]

Restriction to \(\ell\) again gives a smooth point or an \(A_k\) singularity
at each of them.  Neither smoothing parameter can vanish identically on
\(\ell\), because that would put \(\ell\) in the corresponding irreducible
branch of \(D\), hence in \(D\) itself.

### A cuspidal fiber

At a cusp of \(D\), the quartic has an \(A_2\) cusp, and transversality gives
the miniversal local equation

\[
u^2+v^3+a(s,t)v+b(s,t)=0,
\]

where \((a,b)\) are local coordinates on the base.  Along any line through
the point, at least one of \(a'(0),b'(0)\) is nonzero.  If \(b'(0)\ne0\),
the restricted total surface is smooth.  If \(b'(0)=0\), then
\(a'(0)\ne0\), and the quadratic part is

\[
u^2+a'(0)zv+b_2z^2,
\]

which is nondegenerate.  The restricted surface has an ordinary double
point, hence an \(A_1\) singularity.

These cases exhaust \(\ell\cap D\).  Therefore every singularity of
\(S_\ell\) is Du Val.  In particular the singular locus is finite.  The
divisor \(S_\ell\) is ample, hence connected.  If it were reducible, two of
its surface components would meet along a curve, which would lie in the
singular locus.  Thus it is irreducible.  A hypersurface is Cohen--Macaulay,
hence satisfies Serre's condition \(S_2\); because its singular locus is
zero-dimensional, it also satisfies \(R_1\).  Serre's criterion now makes
\(S_\ell\) normal.

## 4. The geometric genus

Adjunction on \(\ell\times\mathbf P^2_y\simeq\mathbf P^1\times\mathbf P^2\)
gives

\[
\omega_{S_\ell}=\mathcal O_{S_\ell}(0,1).
\]

The restriction sequence

\[
0\longrightarrow\mathcal O(-2,-3)
\longrightarrow\mathcal O(0,1)
\longrightarrow\mathcal O_{S_\ell}(0,1)
\longrightarrow0
\]

and Kunneth vanishing give

\[
h^0(S_\ell,\omega_{S_\ell})=3.
\]

Du Val resolutions are crepant and have rational singularities.  If
\(\widetilde S_\ell\to S_\ell\) is the minimal resolution, then

\[
p_g(\widetilde S_\ell)=3.
\]

A smooth rational surface has \(p_g=0\).  Hence
\(\widetilde S_\ell\), and therefore the normalization of \(S_\ell\), is
not rational for every \(\ell\).  This proves the theorem.

## Scope

The theorem excludes exactly class \((1,0)\) on a general \((2,4)\)
hypersurface.  It does not exclude \((1,k)\) for \(k\ge1\), higher
base-degree classes, or unirationality through a construction unrelated to
divisors of class \(H_x\).
