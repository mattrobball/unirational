# Tangent-residual construction

## 1. Cubic identity

For a homogeneous cubic \(F\), write

\[
F(x+tv)=F(x)+tL+t^2Q+t^3C.
\]

Then

\[
F(Cx-Qv)=C^3F(x)-C^2QL.
\]

This follows by substituting \(t=-Q/C\) into the cubic expansion and clearing
denominators; it is a polynomial identity, so no nonvanishing assumption on
\(C\) is needed.

On \(X=V(F)\), a tangent direction satisfies \(L=0\). Therefore
\([Cx-Qv]\in X\). If both \(C\) and \(Q\) vanish, the whole line lies on the
cubic, and this is precisely the indeterminacy locus.

## 2. Well-definedness on \(\mathbf P(T_X)\)

Changing a representative by \(v'=av+bx\) gives, modulo \(F(x)=L(x,v)=0\),

\[
L'=aL+3bF,
\quad Q'=a^2Q,
\quad C'=a^3C+a^2bQ,
\]

and hence

\[
C'x-Q'v'=a^3(Cx-Qv).
\]

Scaling the base vector by \(x'=cx\) gives

\[
C(v)x'-Q(x',v)v=c\bigl(C(v)x-Q(x,v)v\bigr),
\]

because \(Q(cx,v)=cQ(x,v)\). Thus the formula is independent of all
choices in representing a point of \(\mathbf P(T_X)\).

## 3. Geometry of a fibre

For fixed general \(x\), a point \(y\in X\cap T_xX\), \(y\ne x\), determines
the line \(xy\), which has intersection multiplicity at least two at \(x\).
The residual point is \(y\). Conversely every tangent direction not
corresponding to a line contained in \(X\) produces such a \(y\). Therefore

\[
\mathbf P(T_xX)\dashrightarrow X\cap T_xX
\]

is birational for general \(x\). This is the classical tangent
parameterization of a cubic tangent hyperplane section.

## 4. Equivariance

The construction is defined by incidence, tangency, and residual
intersection. Every projective automorphism preserving \(X\) preserves these
data. In the Klein model the same conclusion follows directly from the
\(G\)-invariance of \(F\). Thus the map is \(G\)-equivariant.

## 5. Why this was not visible in the fixed-network packets

The map \(\rho\) lives on the fivefold \(\mathbf P(T_X)\), not on a selected
fixed curve. The eventual section is chosen over the free quotient. It can be
indeterminate along every positive-dimensional fixed locus. Consequently the
actual fixed component maps only appear after resolving its base ideal, and
need not be the strict restrictions to \(E_t\) or \(L_t\).
