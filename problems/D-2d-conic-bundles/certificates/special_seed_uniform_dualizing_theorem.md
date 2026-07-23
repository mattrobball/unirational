# Uniform ample dualizing sheaf for every immersed rational seed

## Statement and exact boundary

Let

\[
X=\{F(x,y)=0\}\subset\mathbf P^2_x\times\mathbf P^2_y
\]

be general of bidegree \((2,d)\), with \(d\ge4\).  Fix any nonconstant
immersive map

\[
\nu:\mathbf P^1\longrightarrow\mathbf P^2_y
\]

of degree \(e\ge1\).  The scheme-theoretic tangent-residual incidence
\(Z_{F,\nu}\) is a finite flat degree-\((d-2)\) cover of its tangent-flag
surface.  It is an lci Gorenstein surface and

\[
\boxed{
\omega_{Z_{F,\nu}}
=\mathcal O\bigl(
3H+2J+(d-4)R+(e(2d-3)-2)F_0
\bigr).}
\tag{0.1}
\]

Here \(H\) is the \(x\)-plane class, \(F_0\) the parameter class on
\(\mathbf P^1\), \(J\) the tangent-line dual-plane class, and \(R\) the
residual-point plane class.  The dualizing sheaf in (0.1) is ample for every
such \(\nu\), simultaneously for a single general \(F\).

This is a scheme-level positivity theorem, not an all-seeds rationality
exclusion.  A special seed can make \(Z_{F,\nu}\) nonnormal or normal with
noncanonical singularities.  An ample dualizing sheaf can lose bigness after
normalization because of the conductor, or after resolution because of
negative discrepancies.  The general-pair theorem in
`tangent_residual_limits_theorem.md` supplies smoothness and therefore a
genuine general-type conclusion; the present theorem isolates exactly what
survives uniformly for special seeds.

## 1. The global tangent and residual flags

Put \(Y=\mathbf P^2_y\) and let \(Y^\vee\) be its dual plane.  Define

\[
\mathcal I=
\{(p,\ell,r)\in Y\times Y^\vee\times Y:p,r\in\ell\}.
\]

Write \(P,J,R\) for the three hyperplane classes.  The two incidence
equations have classes \(P+J\) and \(R+J\), so

\[
K_{\mathbf P^2_x\times\mathcal I}
=-3H-2P-J-2R.
\tag{1.1}
\]

On the universal line let

\[
D_{p,r}=2p+r.
\]

This is a flat relative divisor of length three, including on the diagonal
\(p=r\).  Its degree-\(d\) evaluations form a rank-three bundle
\(\mathscr E_d\) on \(\mathbf P^2_x\times\mathcal I\).  The equation \(F\)
gives a section, and its zero scheme is

\[
\mathcal Z_F=
\{(x,p,\ell,r):F_x|_\ell\text{ vanishes on }2p+r\}.
\tag{1.2}
\]

Similarly, vanishing on \(2p\) defines the global tangent flag

\[
\mathcal T_F=
\{(x,p,\ell):F_x|_\ell\text{ vanishes on }2p\}.
\tag{1.3}
\]

At every flag, variation of \(F\) surjects onto the length-two or
length-three evaluation: choose a quadric nonzero at \(x\), restrict plane
forms to \(\ell\), and use jet separation on \(\mathbf P^1\).  Thus for a
general \(F\), vector-bundle Bertini makes \(\mathcal T_F\) and
\(\mathcal Z_F\) smooth threefolds.

The reducible locus in the space of degree-\(d\) plane curves has codimension
\(d-1\).  Since \(x\) varies in dimension two, a general quadratic family
avoids it for \(d\ge4\).  Hence no tangent line is a component of any
\(C_x\).  After division by the imposed doubled point, the residual equation
has constant positive degree \(d-2\) on every line fiber.  Its zero scheme is
a relative effective Cartier divisor on the universal residual line.
Forgetting \(r\) therefore gives a finite flat map

\[
\rho:\mathcal Z_F\longrightarrow\mathcal T_F
\quad\text{of degree }d-2.
\tag{1.4}
\]

## 2. Base change by an arbitrary immersed rational curve

Base-change (1.3)--(1.4) along \(\nu\):

\[
\mathcal T_{F,\nu}=\mathcal T_F\times_Y\mathbf P^1,
\qquad
Z_{F,\nu}=\mathcal Z_F\times_Y\mathbf P^1.
\tag{2.1}
\]

The base-point locus \(\Sigma\times_Y\mathbf P^1\) is finite for every
nonconstant rational \(\nu\); this is proved in Section 4.  Consequently
\(\mathcal T_{F,\nu}\) has pure dimension two.  It is an lci in the smooth
fourfold of \((x,t,\ell)\): away from finitely many base points it is the
graph of the tangent-line map, and over a base point it has the expected
pencil of lines.  The finite flat map (1.4) remains finite flat after base
change, so \(Z_{F,\nu}\) is an lci Gorenstein surface in the smooth fivefold
of \((x,t,\ell,r)\).

No genericity assumption on \(\nu\) enters these scheme-theoretic
statements.

## 3. Adjunction and ampleness

The determinant of the length-three evaluation bundle is

\[
\boxed{
c_1(\det\mathscr E_d)
=6H+(2d-4)P+3J+(d-2)R.}
\tag{3.1}
\]

Here is the diagonal correction in full.  The conormal of the marked point
on the universal line has class \(J-2P\), so the doubled point contributes

\[
2dP+(J-2P)=(2d-2)P+J.
\]

Adding \(r\) contributes \(dR-2\Delta\), where the coincidence divisor is

\[
\Delta=\{p=r\},
\qquad
[\Delta]=P+R-J.
\]

Thus the degree-\(d\) part of the determinant is

\[
(2d-2)P+J+dR-2(P+R-J)
=(2d-4)P+3J+(d-2)R.
\]

Tensoring the three evaluations by \(\mathcal O(2H)\) adds \(6H\), proving
(3.1).  Global adjunction with (1.1) gives

\[
K_{\mathcal Z_F}
=3H+(2d-6)P+2J+(d-4)R.
\tag{3.2}
\]

After \(P\) is pulled back by \(\nu\), direct adjunction in the smooth
fivefold over \(\mathbf P^1\) gives (0.1).  Equivalently, the base-change
canonical correction is

\[
K_{\mathbf P^1}-\nu^*K_Y=(3e-2)F_0.
\]

On \(\mathcal T_{F,\nu}\), the class

\[
L=3H+2J+(e(2d-3)-2)F_0
\]

is the restriction of an ample product polarization: its three coefficients
are positive for \(d\ge4\), \(e\ge1\).  Since \(\rho_\nu\) is finite,
\(\rho_\nu^*L\) is ample on \(Z_{F,\nu}\).  The remaining class
\((d-4)R\) is nef.  The sum of an ample and a nef divisor is ample, proving
the assertion about \(\omega_{Z_{F,\nu}}\).

## 4. Uniform finiteness of the tangent base

Let

\[
\Sigma=\{F_{y_0}=F_{y_1}=F_{y_2}=0\}
\subset\mathbf P^2_x\times Y,
\qquad
M=2H+(d-1)P.
\]

For a general \(F\), this is a smooth connected, hence irreducible, complete
intersection curve of three ample divisors of class \(M\).  Adjunction and
intersection give

\[
K_\Sigma=(3H+(3d-6)P)|_\Sigma,
\]

\[
\deg K_\Sigma
=18(d-1)(3d-5),
\qquad
g(\Sigma)=1+9(d-1)(3d-5)>0.
\tag{4.1}
\]

Moreover,

\[
P\cdot M^3=12(d-1)>0,
\]

so \(\Sigma\to Y\) is nonconstant.  It is generically one-to-one: for two
distinct points \(x,x'\) over the same \(p\), the two gradient values impose
six independent conditions on \(F\).  The corresponding incidence has total
dimension equal to \(\dim\mathbf P(H^0(\mathcal O(2,d)))\), so for a general
\(F\) its double-pair fiber is zero-dimensional.  Thus only finitely many
double fibers occur for a fixed general \(F\).  The curve \(\Sigma\) is the
normalization of its irreducible image \(D\subset Y\).

If the tangent-base scheme on an immersed rational seed were
positive-dimensional, the irreducible curve \(\nu(\mathbf P^1)\) would equal
\(D\).  But the normalization of the former is rational, whereas the
normalization of \(D\) is the positive-genus curve \(\Sigma\).  This is
impossible.  Hence every nonconstant rational seed meets the tangent base in
only finitely many points.

## 5. Why this is not yet an all-seeds no-go theorem

For a finite normalization \(n:\overline Z\to Z\), the conductor formula is

\[
n^*K_Z=K_{\overline Z}+C,
\qquad C\ge0.
\]

Thus \(K_{\overline Z}=n^*K_Z-C\) can lose bigness even when \(K_Z\) is
ample.  Normal noncanonical singularities create the analogous discrepancy
loss on a resolution.  Stable surfaces with rational normalization and
ample dualizing sheaf show that this is a real logical boundary, not merely
a technicality.

Uniform smoothness is false: tangential base change along a discriminant
component can produce local models \(uv=z^m\).  The later ramification
comparison theorem proves that every residual discriminant component has
normalization of genus at least two, so no rational seed can be contained in
one.  The remaining input for an all-special-seeds general-type theorem is
therefore local: one must prove that every immersed rational seed gives at
worst canonical singularities (for example Du Val), including the fold/cusp,
mixed-\(\gamma\), higher-Morin, and isolated multiple-value strata.  See
[the ramification comparison theorem](special_seed_ramification_comparison.md).
