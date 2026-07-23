# The degree-\(d\) flex incidence is of general type

## Statement

Let

\[
X=\{F(x,y)=0\}\subset\mathbf P^2_x\times\mathbf P^2_y
\]

be a general hypersurface of bidegree \((2,d)\), with \(d\ge4\).  Let
\(I_{F,d}\) parametrize
triples \((x,p,\ell)\) such that \(p\in\ell\subset\mathbf P^2_y\) and

\[
F(x,-)|_\ell\text{ vanishes on the length-three divisor }3p.
\tag{1.1}
\]

For a smooth fiber \(C_x\), this says exactly that \(p\) is a flex and
\(\ell=T_pC_x\).  A smooth plane curve of degree \(d\) has
\(3d(d-2)\) flexes counted with multiplicity.

For a general \(F\), the compactified flex incidence \(I_{F,d}\) is a smooth
surface and

\[
\boxed{K_{I_{F,d}}=3H+(3d-8)P+J.}
\]

Here \(H\) is pulled back from \(\mathbf P^2_x\), \(P\) from the marked
point plane \(\mathbf P^2_y\), and \(J\) from the dual plane of lines.
All three coefficients are positive for \(d\ge3\), so the canonical class
is ample.  Since (1.1) includes \(F(x,p)=0\), the map
\((x,p,\ell)\mapsto(x,p)\) lands in \(X\).  Thus the Hessian/flex marking is
not a rational surface source for the conic-bundle argument for any
\(d\ge4\).  At \(d=4\), one has \(K^2=1872\).

## 1. The flag space and the jet bundle

Let

\[
\mathcal F=\{(p,\ell):p\in\ell\}
\subset\mathbf P^2_y\times(\mathbf P^2_y)^\vee
\]

be the incidence flag threefold, and put

\[
T=\mathbf P^2_x\times\mathcal F.
\]

The flag is a divisor of class \(P+J\) in the product of the two planes.
Consequently,

\[
K_T=-3H-2P-2J.
\tag{1.2}
\]

Over \(\mathcal F\), the relative cotangent line to \(\ell\) at \(p\) has
class

\[
\Omega_{\ell,p}=J-2P.
\tag{1.3}
\]

Indeed, \(\mathcal F=\mathbf P_Y(\mathcal K)\) in the lines convention over
the dual plane \(Y\), and

\[
K_{\mathcal F/Y}=-2P+c_1(\mathcal K^*)=J-2P.
\]

Let \(\mathscr J_3\) be the rank-three bundle whose fiber at
\((x,p,\ell)\) is the restriction of \(\mathcal O(2,d)\) to \(3p\subset
\ell\).  Filtering \(\mathcal O_{3p}\) by powers of the ideal of \(p\)
and using (1.3), its three Chern roots are

\[
\begin{aligned}
L_0&=2H+dP,\\
L_1&=2H+(d-2)P+J,\\
L_2&=2H+(d-4)P+2J.
\end{aligned}
\tag{1.4}
\]

Evaluation gives

\[
H^0(\mathbf P^2_x\times\mathbf P^2_y,\mathcal O(2,d))
\otimes\mathcal O_T\longrightarrow\mathscr J_3.
\]

It is fiberwise surjective: choose a quadric nonzero at \(x\), restrict
plane degree-\(d\) forms to \(\ell\), and use that
\(\mathcal O_{\mathbf P^1}(d)\)
separates the length-three scheme \(3p\).  Vector-bundle Bertini therefore
makes the zero locus of a general section a smooth surface of dimension
\(5-3=2\).  This zero locus is precisely \(I_{F,d}\), including the flags
over singular degree-\(d\) fibers; no separate Hessian-boundary resolution
is needed.

## 2. Canonical class and degree

The class of the regular zero locus is

\[
[I_{F,d}]=L_0L_1L_2\in A^3(T).
\tag{2.1}
\]

The determinant of \(\mathscr J_3\) is

\[
c_1(\mathscr J_3)=L_0+L_1+L_2=6H+(3d-6)P+3J.
\]

Adjunction with (1.2) gives

\[
\boxed{K_{I_{F,d}}=3H+(3d-8)P+J.}
\tag{2.2}
\]

This is the restriction of an ample line bundle from
\(\mathbf P^2_x\times\mathbf P^2_y\times(\mathbf P^2_y)^\vee\).  It is
therefore ample on every connected component of \(I_{F,d}\).

At a fixed general \(x\), integrating (2.1) over \(\mathcal F\) gives

\[
\int_{\mathcal F}(dP)((d-2)P+J)((d-4)P+2J)
=3d(d-2).
\]

Thus \(I_{F,d}\to\mathbf P^2_x\) is generically finite of the classical
flex degree.  Full intersection in the flag Chow ring gives

\[
\boxed{K_{I_{F,d}}^2=9(3d-4)(17d-42).}
\]

For the inverse image \(C\) of a general line in \(\mathbf P^2_x\), one
also obtains

\[
C^2=3d(d-2),
\qquad
K_{I_{F,d}}C=3(17d^2-54d+32),
\qquad
g(C)=(3d-7)(9d-7).
\]

At \(d=4\), these specialize to \(K^2=1872\) and
\((C^2,K C,g)=(24,264,145)\).

These arithmetic checks are reproduced by
`flex_incidence_invariants.py`.

## Scope

The theorem closes the direct flex-point, or Hessian-marking, incidence for
every degree in Problem D.  It does not exclude constructions that add
auxiliary conics, combine flexes, or iterate a correspondence after choosing
a flex point.
