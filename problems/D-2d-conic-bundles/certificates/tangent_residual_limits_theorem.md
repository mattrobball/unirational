# The tangent-residual limits theorem for degree \(d\ge 4\)

## Scope and conventions

Work over \(\mathbf C\).  Fix a line
\(L\subset \mathbf P^2_y\), and let

\[
X=\{F(x,y)=0\}\subset \mathbf P^2_x\times \mathbf P^2_y
\]

be general of bidegree \((2,d)\).  Put

\[
S=X\cap(\mathbf P^2_x\times L).
\]

Thus \(S\) is the rational surface used as the marked source in the
tangent-residual construction.  Write \(H\) for the restriction of
\(\mathcal O(1,0)\) and \(F_0\) for the restriction of
\(\mathcal O(0,1)\) from
\(\mathbf P^2_x\times L\).  The subscript on \(F_0\) distinguishes this
divisor class from the equation \(F\).

This note proves two things.

1. The sign in the all-degree resultant identity in [`SPEC.md`](../SPEC.md) must
   alternate with \(d\).
2. After resolving the tangent-line map, the tangent-residual incidence
   surface is smooth with ample canonical class for every \(d\ge 4\).
   In particular, for \(d=4\) it is a nonrational double cover with
   \((K^2,\chi,p_g,q,P_2)=(608,127,126,0,735)\).  For each fixed
   \(e\ge1\), the same ampleness obstruction holds for the tangent residual
   attached to a general pair consisting of \(F\) and an immersive
   parametrized rational seed of degree \(e\).

This is a limits-of-the-method theorem.  It rules out this particular
tangent-residual correspondence as a rational source.  It does **not**
prove that a general \((2,d)\) threefold is non-unirational.

## The corrected resultant identity

Choose coordinates \((U,V,W)\) on \(\mathbf P^2_y\) with \(L=\{W=0\}\),
and write

\[
f(U,V,W)=g(U,V)+W h(U,V)+W^2 k(U,V,W).
\]

Here \(g\) is binary of degree \(d\), \(h\) is binary of degree \(d-1\),
and \(k\) has degree \(d-2\).  For binary variables \((u,v)\), set

\[
P_{U,V,W}(u,v)=U g_u(u,v)+V g_v(u,v)+W h(u,v).
\]

Let \(\Delta(g)\) be the standard discriminant
\(a^{2d-2}\prod_{i<j}(r_i-r_j)^2\) when
\(g(u,v)=a\prod_i(u-r_i v)\).  Then the correct identity is

\[
\boxed{
\operatorname {Res}_{u,v}(g,P)
-(-1)^{d(d-1)/2}\Delta(g)f
=W^2q_f.}
\tag{2.1}
\]

The form \(q_f\) has degree \(d-2\) in \((U,V,W)\), and its coefficients
are homogeneous of degree \(2d-1\) in the coefficients of \(f\).

Indeed, at \(W=0\),

\[
P_{U,V,0}(r_i,1)
=a\prod_{j\ne i}(r_i-r_j)(U-r_iV).
\]

The root formula for the resultant gives

\[
\begin{aligned}
\operatorname {Res}(g,P_{U,V,0})
&=a^{d-1}\prod_iP_{U,V,0}(r_i,1)\\
&=(-1)^{d(d-1)/2}\Delta(g)g(U,V).
\end{aligned}
\]

This proves divisibility by \(W\) in (2.1).  On the curve \(\{f=0\}\),
the resultant is the product of the \(d\) tangent-line equations at the
points of \(\{g=0\}\).  It therefore vanishes to order at least two at
each of those \(d\) points.  After division by one copy of \(W\), its
restriction to \(L\) is a binary form of degree \(d-1\) vanishing at
\(d\) distinct points.  It is zero, proving divisibility by \(W^2\).
The identity for arbitrary \(g\) follows by density.

Consequently, the plus sign in [`SPEC.md`](../SPEC.md) is correct for
\(d\equiv2,3\pmod4\) and wrong for \(d\equiv0,1\pmod4\).  In particular,
the quartic identity is

\[
\operatorname {Res}(g,P)-\Delta(g)f=W^2q_f.
\]

The coefficients of \(q_f\) are primitive in the universal coefficient
ring.  To see this, write

\[
q_f=q_0(g,h)-(-1)^{d(d-1)/2}\Delta(g)k.
\]

The coefficients of \(k\) are independent variables, so a common prime
divisor of all coefficients of \(q_f\) would have to divide
\(\Delta(g)\).  Specialize \(g\) to have exactly one double root \(p\)
and take \(h(p)\ne0\).  The root formula for the resultant has exactly a
factor \(W^2h(p)^2\) from the double root, and its quotient by \(W^2\)
is nonzero.  Hence \(\Delta\) is not a common divisor.

After the coefficients of \(f\) are replaced by general quadrics in
\(x\), \(q_f\) has bidegree

\[
(4d-2,d-2).
\]

On \(X\), equation (2.1) becomes
\(\operatorname {Res}=W^2q_f\).  Thus the residual divisor has class

\[
T\sim(4d-2)H_x+(d-2)H_y.
\]

For \(d=4\), this is \(14H_x+2H_y\), of degree \(28\) over
\(\mathbf P^2_y\).  The exact universal and specialized quartic checks
are in `quartic_tangent_residual_checks.py`.

## The tangent-map base scheme

On \(\mathbf P^2_x\times L\),

\[
[S]=2H+dF_0,
\qquad
K_S=-H+(d-2)F_0,
\]

and

\[
H^2=d,
\qquad
H F_0=2,
\qquad
F_0^2=0.
\tag{3.1}
\]

The three \(y\)-partials of \(F\), restricted to
\(\mathbf P^2_x\times L\), are sections of

\[
M=2H+(d-1)F_0.
\]

Let \(\Gamma\) be their common zero scheme.  Euler's identity implies
that \(\Gamma\subset S\).  For general \(F\),

\[
\boxed{\operatorname {length}(\Gamma)=M^3=12(d-1).}
\tag{3.2}
\]

Moreover, \(\Gamma\) is reduced, \(S\) is smooth at every point of
\(\Gamma\), and the plane curve \(C_x=\{F(x,-)=0\}\) has an ordinary node
at the marked point there.

Here is a transversality proof.  On the product of the parameter space of
forms with \(\mathbf P^2_x\times L\), evaluation of the full \(y\)-gradient
is fiberwise surjective: at a fixed \((x,p)\), a quadric in \(x\) can be
chosen nonzero at \(x\), and degree-\(d\) forms in \(y\) prescribe an
arbitrary gradient at \(p\).  Its universal zero locus is therefore
smooth of codimension three.  Generic smoothness gives a reduced
zero-dimensional fiber, and its length is the top Chern number in (3.2).

For completeness, the node assertion follows from the same universal
incidence with one extra jet.  Let \(N\) be the dimension of
the projective space of equations.  The universal gradient-zero incidence
has dimension \(N\).  Conditional on the three gradient equations, the
quadratic \(y\)-jet is arbitrary; degeneracy of its binary Hessian is one
further equation, so that bad incidence has dimension at most \(N-1\).
Since the base \(\mathbf P^2_x\times L\) is projective, the projection of
this bad incidence is a proper closed subset of the equation space.  Thus
every point of \(\Gamma\) is an ordinary node of \(C_x\).

Nor can such a curve have a second singular point.  For fixed
\((x,p,q)\), with \(p\in L\) and \(q\ne p\), the six conditions

\[
\nabla_yF(x,p)=0,
\qquad
\nabla_yF(x,q)=0
\]

are independent: \(\mathcal O_{\mathbf P^2}(d)\) separates the two
first-order jets for \(d\ge4\).  The choices of \((x,p,q)\) have dimension
five, so this bad incidence has dimension at most \(N+5-6=N-1\).  Its
diagonal limit is contained in the Hessian-degenerate incidence already
excluded.  Proper projection therefore shows that every nodal \(C_x\)
arising over \(\Gamma\) is smooth away from its marked node.

We will also use that every \(C_x\) is irreducible.  The reducible locus in
the projective space of degree-\(d\) plane curves has codimension \(d-1\):
its largest stratum is a line times a form of degree \(d-1\).  At each fixed
\(x\), evaluation \(F\mapsto F(x,-)\) is surjective.  Hence the universal
incidence of pairs \((F,x)\) with \(C_x\) reducible has dimension at most

\[
N+2-(d-1)\le N-1
\]

for \(d\ge4\).  Its projection is again proper.  A general quadratic family
therefore avoids the entire reducible locus, not merely its line-component
stratum.

At a point of \(\Gamma\), transversality says that

\[
d(\nabla_yF):T_{\mathbf P^2_x\times L}\longrightarrow V_y^*
\]

is an isomorphism.  Differentiating Euler's identity at a zero of the
gradient gives

\[
p\cdot d(\nabla_yF)(v)=d\,dF(v).
\]

The right side is a nonzero linear functional because
\(d(\nabla_yF)\) is an isomorphism.  Thus \(S\) is smooth, and the same
identity identifies \(T_S\) with the hyperplane
\(p^\perp\subset V_y^*\).  The restriction \(T_S\to p^\perp\) is an
isomorphism.  Hence the two local coordinates of the tangent-line map
generate the maximal ideal at every point of \(\Gamma\).  One ordinary
blow-up resolves it.

Let

\[
\mu:\widetilde S=\operatorname {Bl}_{\Gamma}S\longrightarrow S,
\qquad
E=\sum_{i=1}^{12(d-1)}E_i.
\]

The resolved tangent-line map is defined by the basepoint-free line
bundle

\[
A=2H+(d-1)F_0-E,
\tag{3.3}
\]

and \(A|_{E_i}=\mathcal O_{\mathbf P^1}(1)\).

## The resolved residual incidence

Let \(V_y\) be the three-dimensional vector space of \(y\)-coordinates.
The divided gradient gives a surjection

\[
V_y\otimes\mathcal O_{\widetilde S}\longrightarrow\mathcal O_{\widetilde S}(A).
\]

Let \(\mathcal K\) be its rank-two kernel.  The marked point
\(p\in L\) gives a subline

\[
\mathcal P=\mathcal O_{\widetilde S}(-F_0)\subset\mathcal K.
\]

For \(\mathcal Q=\mathcal K/\mathcal P\),

\[
c_1(\mathcal Q)=-2H-(d-2)F_0+E.
\]

Use the lines convention for
\(\mathbf P(\mathcal K)\to\widetilde S\), and put
\(\zeta=c_1(\mathcal O_{\mathbf P(\mathcal K)}(1))\).  The marked section
\(D_p\) has class

\[
[D_p]=\zeta-2H-(d-2)F_0+E.
\]

The restriction of the degree-\(d\) equation to the family of tangent
lines has class \(d\zeta+2H\) and contains \(2D_p\).  Therefore the
residual incidence surface has class

\[
\boxed{
[Z_d]=(d-2)\zeta+6H+2(d-2)F_0-2E.}
\tag{4.1}
\]

Put \(n=d-2\).  For a general form, the residual binary form is not
identically zero on any tangent line: the incidence calculation above shows
that every \(C_x\) is irreducible, including the nodal curves occurring over
\(\Gamma\).  Hence

\[
Z_d\longrightarrow\widetilde S
\]

is finite flat of degree \(n\).

### Smoothness lemma

For a general \(F\), \(Z_d\) is smooth.

There is a single global Bertini argument that includes the diagonal
\(r=p\), all flexes, and the exceptional curves.  Let

\[
\mathscr U_L=
\{(x,p,\ell,r):x\in\mathbf P^2_x,\ p\in L,\ p,r\in\ell\subset
\mathbf P^2_y\}.
\]

This is a smooth iterated \(\mathbf P^1\)-bundle of dimension five.  On the
universal line, let \(\mathscr D=2p+r\); when \(r=p\), this is the flat
length-three divisor \(3p\).  Restriction to \(\mathscr D\) defines a
rank-three vector bundle \(\mathscr E\) on \(\mathscr U_L\).  The evaluation
map

\[
H^0(\mathbf P^2_x\times\mathbf P^2_y,\mathcal O(2,d))
 \otimes\mathcal O_{\mathscr U_L}\longrightarrow\mathscr E
\tag{4.2}
\]

is fiberwise surjective.  Indeed, choose a quadric nonzero at \(x\), restrict
plane forms to \(\ell\), and use that \(\mathcal O_{\mathbf P^1}(d)\)
separates every length-three divisor for \(d\ge2\).  Vector-bundle Bertini
therefore makes the zero scheme of a general section smooth of dimension
\(5-3=2\).

The zero condition in (4.2) is exactly

\[
F_x|_\ell\text{ vanishes on }2p+r.
\]

Forgetting \(r\) first gives the tangent-flag surface cut out by vanishing
on \(2p\).  It maps birationally to \(S\), is the graph of the tangent-line
map away from \(\Gamma\), and has a full pencil of lines over each point of
\(\Gamma\).  Because the tangent-map base ideal is the maximal ideal there,
this surface is scheme-theoretically \(\operatorname{Bl}_\Gamma S=
\widetilde S\).  The zero scheme of (4.2) is consequently precisely the
resolved residual incidence \(Z_d\), including the diagonal flex points.
This proves its smoothness without a separate hyperflex assumption.

The same description also identifies the exceptional restriction.  Over a
node \((x,p)\in\Gamma\), the surface of pairs \((\ell,r)\) is
\(\operatorname{Bl}_p\mathbf P^2_y\), and division by the doubled marked
section subtracts the multiplicity-two exceptional divisor from the total
transform of \(C_x\).  Thus \(Z_d|_{E_i}\) is scheme-theoretically the strict
transform of the irreducible nodal curve \(C_x\), hence the graph of the
projection of its smooth normalization from \(p\).  In particular it is
reduced and smooth, in agreement with the global Bertini conclusion.

## Ample canonical class for every \(d\ge4\)

Since

\[
K_{\widetilde S}=-H+(d-2)F_0+E
\qquad\text{and}\qquad
\det(\mathcal K^*)=A,
\]

the canonical class of the projective bundle is

\[
K_{\mathbf P(\mathcal K)}
=-2\zeta+H+(2d-3)F_0.
\]

Adjunction with (4.1) gives

\[
\begin{aligned}
K_{Z_d}
&=\bigl((d-4)\zeta+7H+(4d-7)F_0-2E\bigr)|_{Z_d}\\
&=\bigl((d-4)\zeta+3H+(2d-5)F_0+2A\bigr)|_{Z_d}.
\tag{5.1}
\end{aligned}
\]

Each summand in the second line is nef.  The class \(\zeta\) is
basepoint-free because \(\mathcal K^*\) is a quotient of the trivial
bundle \(V_y^*\otimes\mathcal O\); \(A\) is basepoint-free by construction;
and \(H,F_0\) are nef.  The map \(S\to\mathbf P^2_x\) is finite for a
general form, since the \(d+1\) coefficient quadrics of \(F|_L\) have no
common zero.  Hence \(H\) has positive intersection with every
nonexceptional curve.  On the other hand, \(A\cdot E_i=1\).  Since
\(Z_d\to\widetilde S\) is finite, (5.1) has positive intersection with
every curve on \(Z_d\).

It is also big component by component.  If a connected component has degree
\(n_i\) over \(\widetilde S\), finiteness gives

\[
(H|_{Z_{d,i}})^2=n_i d>0.
\]

(Summing over the components recovers \((H|_{Z_d})^2=nd\).)

Nakai's criterion now gives

\[
\boxed{K_{Z_d}\text{ is ample for every }d\ge4.}
\tag{5.2}
\]

Thus every connected component of the general residual incidence is a
surface of general type.  No component can be rational or dominated by a
rational surface in characteristic zero.

For a numerical check, let

\[
C=6H+2(d-2)F_0-2E,
\qquad
G=7H+(4d-7)F_0-2E.
\]

Then \([Z_d]=(d-2)\zeta+C\) and
\(K_{Z_d}=(d-4)\zeta+G\).  The projective-bundle identities are

\[
\pi_*\zeta=1,
\qquad
\pi_*\zeta^2=A,
\qquad
\pi_*\zeta^3=A^2-c_2(\mathcal K)=0,
\]

because \(c_2(\mathcal K)=A^2\).  Using (3.1),
\(E_i^2=-1\), and \(\#\Gamma=12(d-1)\), one obtains

\[
A\cdot C=8d-4,
\quad
A\cdot G=20d-18,
\quad
C\cdot G=70d-92,
\quad
G^2=113d-148.
\]

Therefore

\[
\boxed{
K_{Z_d}^2=48d^3-91d^2-422d+680.}
\tag{5.3}
\]

At \(d=4\), this is \(608\).

## The general branch class and fiber genus

The residual binary degree-\(n\) form is a section of

\[
\operatorname {Sym}^n(\mathcal K^*)\otimes\mathcal O_{\widetilde S}(C).
\]

Its discriminant is a section of

\[
(\det\mathcal K^*)^{n(n-1)}\otimes
\mathcal O_{\widetilde S}((2n-2)C).
\]

Consequently, its branch class is

\[
\boxed{
B_n=(n-1)\bigl(2(n+6)H+n(n+5)F_0-(n+4)E\bigr).}
\tag{6.1}
\]

On each exceptional curve, the branch degree is
\((n-1)(n+4)\).  This agrees with Riemann-Hurwitz for projection of the
normalization of a nodal degree-\(d\) plane curve from its node.  Indeed,
that normalization has genus \(n(n+1)/2-1\) and the projection has degree
\(n\).

A general conic fiber of \(S\to L\) avoids \(\Gamma\).  Equation (6.1)
meets it in

\[
4(n-1)(n+6)
\]

as the degree of the branch/different divisor, counted with its
multiplicities.  Riemann--Hurwitz therefore gives the genus of the generic
fiber of \(Z_d\to L\):

\[
\boxed{
g=(n-1)(2n+11)=(d-3)(2d+7).}
\tag{6.2}
\]

This fiber is connected, so (6.2) is geometric genus rather than merely
arithmetic genus.  Indeed, on the ruled surface
\(\mathbf P(\mathcal K|_{S_t})\) over a general conic fiber \(S_t\), the
residual curve has class \(n\zeta+12f\), where \(f\) is the pullback of a
point on \(S_t\simeq\mathbf P^1\).  The class \(\zeta\) is nef, the
displayed divisor is positive on both the ruling and every horizontal
curve, and it has positive square.  It is ample, hence connected; the
smoothness lemma then makes it a connected smooth curve.

For \(d=4\), this gives genus \(15\), replacing the heuristic count in
[`SPEC.md`](../SPEC.md) by an exact calculation.

## Parametrized rational seed curves of arbitrary degree

For each fixed degree, the same obstruction applies to a general richer
rational seed of the kind proposed in the covariant-zoo part of
[`SPEC.md`](../SPEC.md).
Fix \(e\ge1\), and let

\[
\nu:\mathbf P^1\longrightarrow\mathbf P^2_y
\]

be an immersive parametrization of degree \(e\).  We work with a general
pair \((F,\nu)\), and form the
pullback marked surface

\[
S_e=X\times_{\mathbf P^2_y}\mathbf P^1
\subset\mathbf P^2_x\times\mathbf P^1.
\]

Using the parametrized pullback avoids any ambiguity at nodes of the plane
image of \(\nu\).  The surface \(S_e\) is a rational conic bundle and has
class

\[
[S_e]=2H+edF_0,
\qquad
K_{S_e}=-H+(ed-2)F_0.
\]

The pulled-back \(y\)-gradient has line-bundle class

\[
M_e=2H+e(d-1)F_0.
\]

For a fixed immersive \(\nu\), evaluation of the pulled-back full gradient
is still fiberwise surjective: variation of \(F\) prescribes an arbitrary
\(y\)-gradient at \(\nu(t)\).  Vector-bundle Bertini, followed by the same
Hessian, Euler/transversality, and two-singularity incidence counts as above,
gives for a general pair a reduced base scheme whose marked nodal fibers have
no other singularity:

\[
\Gamma_e
\quad\text{of length}\quad
M_e^3=12e(d-1).
\]

Blow it up, write \(E=\sum E_i\), and put

\[
A_e=2H+e(d-1)F_0-E.
\]

The marked tautological line is now
\(\mathcal P_e=\nu^*\mathcal O_{\mathbf P^2}(-1)
=\mathcal O(-eF_0)\).  If \(\mathcal K_e\) is the kernel of the divided
gradient, then

\[
c_1(\mathcal K_e/\mathcal P_e)
=-2H-e(d-2)F_0+E.
\]

Consequently, the residual incidence in
\(\mathbf P(\mathcal K_e)\) has class

\[
\boxed{
[Z_{d,e}]
=(d-2)\zeta+6H+2e(d-2)F_0-2E.}
\tag{6.3}
\]

The global reducibility-incidence argument above depends only on \(F\), so
the general pair has no reducible \(C_x\).  Thus
\(Z_{d,e}\to\operatorname {Bl}_{\Gamma_e}S_e\) is finite flat of degree
\(d-2\).  Smoothness has the same global flag proof.  Replace \(p\in L\) in
\(\mathscr U_L\) by \(p=\nu(t)\), keep the flat length-three divisor
\(2p+r\) on \(\ell\), and use the same fiberwise-surjective evaluation map
(4.2).  Its general zero scheme is smooth of dimension two.  The
tangent-flag base is scheme-theoretically
\(\operatorname {Bl}_{\Gamma_e}S_e\), because immersivity supplies the
marked local parameter and the reduced gradient zero has maximal base
ideal.  Hence this zero scheme is exactly \(Z_{d,e}\), including its
diagonal and exceptional loci.

Adjunction gives

\[
\begin{aligned}
K_{Z_{d,e}}
&=\bigl((d-4)\zeta+7H+
        (e(4d-5)-2)F_0-2E\bigr)|_{Z_{d,e}}\\
&=\bigl((d-4)\zeta+3H+
        (e(2d-3)-2)F_0+2A_e\bigr)|_{Z_{d,e}}.
\tag{6.4}
\end{aligned}
\]

For \(d\ge4\) and \(e\ge1\), the coefficient
\(e(2d-3)-2\) is positive.  The classes \(\zeta\) and \(A_e\) are
basepoint-free, while \(H\) and \(F_0\) are nef.  The projection
\(S_e\to\mathbf P^2_x\) is finite for a general pair.  More explicitly, the
restriction map

\[
H^0(\mathbf P^2,\mathcal O(d))
\longrightarrow H^0(\mathbf P^1,\mathcal O(ed))
\]

has rank at least \(d+1>2\): powers of two independent pulled-back linear
forms already give \(d+1\) independent sections.  The incidence where
\(F(x,-)|_\nu\) vanishes identically therefore has codimension greater than
the two-dimensional choice of \(x\).  As before, \(H\) is positive on
nonexceptional curves and \(A_e\cdot E_i=1\).  On each component formula
(6.4) is positive on every curve and has positive square, hence is ample by
Nakai.

Thus, for each fixed \(e\), the tangent residual from a **general pair
\((F,\nu)\)**, including the line, conic, and higher-degree cases, has
general-type total space when \(d\ge4\).  This does not quantify over a
special seed chosen as a function of \(X\), nor assert that one Zariski-open
set of equations works simultaneously for every \(e\).  What it proves is
that merely increasing the degree of a general vertical rational seed does
not evade the tangent-correspondence obstruction.

For completeness, the discriminant class is

\[
B_{n,e}
=(n-1)\bigl(2(n+6)H+en(n+5)F_0-(n+4)E\bigr),
\qquad n=d-2.
\tag{6.5}
\]

Its intersection with a general conic fiber of \(S_e\to\mathbf P^1\)
is again \(4(n-1)(n+6)\), so the exact fiber genus remains
\((d-3)(2d+7)\), independently of \(e\).

## The quartic double cover

Now take \(d=4\), so \(n=2\) and \(\#\Gamma=36\).  Formula (4.1) says

\[
[Z_4]=2\zeta+6H+4F_0-2E.
\]

It is a finite flat double cover of \(\widetilde S\).  Its trace line is

\[
L_Z=8H+7F_0-3E,
\]

and its smooth branch divisor is

\[
\boxed{
\widetilde B=2L_Z=16H+14F_0-6E.}
\tag{7.1}
\]

The branch is smooth because both \(Z_4\) and \(\widetilde S\) are smooth:
locally a flat double cover has equation \(z^2=s\), and smoothness along
\(z=s=0\) is exactly \(ds\ne0\).

Before blowing up, the branch has class \(16H+14F_0\).  Over each point
of \(\Gamma\), the exceptional restriction identified in the smoothness
proof is the normalization of the nodal plane quartic, which has genus two.
Projection from the node is a finite double cover of the pencil.  By
Riemann--Hurwitz it has six ramification points; in characteristic zero a
degree-two map has ramification index exactly two, and two ramification
points cannot have the same image in a degree-two fiber.  Hence the six
branch directions are distinct and reduced.  The strict branch meets each
\(E_i\) transversely in those six points.  Blowing down therefore gives an
ordinary sixfold point at each of the thirty-six centers and no other branch
singularity.

At a smooth marked point, the branch condition is also worth stating
precisely.  If
\(T_pC\cdot C=2p+r_1+r_2\), it is \(r_1=r_2\).  Thus the tangent line is
bitangent, \(2p+2r\), or is a hyperflex line, \(4p\).  An ordinary flex
\(3p+r\) leaves the two residual roots \(p,r\) distinct and is not a
branch point.

In particular, the branch is nonempty and reduced.  A smooth finite flat
double cover with nonempty branch cannot be disconnected: a disconnected
degree-two cover would be the disjoint union of two degree-one covers and
would be unramified.  Hence \(Z_4\) is connected, smooth, and irreducible.

Put

\[
D=K_{\widetilde S}+L_Z=7H+9F_0-2E.
\]

Notice the useful decomposition

\[
D=2A+3H+3F_0.
\]

It is ample: it has positive degree on every nonexceptional curve through
the pullback of \(H+F_0\), positive degree on every exceptional curve
through \(A\), and positive square.  The double-cover formula gives

\[
K_{Z_4}=\pi^*D.
\]

Using (3.1) and \(E_i^2=-1\),

\[
D^2=304,
\qquad
L_Z\cdot D=250.
\]

Therefore

\[
K_{Z_4}^2=2D^2=608
\]

and

\[
\chi(\mathcal O_{Z_4})
=2\chi(\mathcal O_{\widetilde S})+\frac12L_Z(L_Z+K_{\widetilde S})
=127.
\tag{7.2}
\]

It remains to separate \(p_g\) and \(q\).  On \(S\), let

\[
\mathcal R=(V_y/\mathcal P)|_S
=\mathcal O_S\oplus\mathcal O_S(F_0),
\qquad
\mathcal E=\mathcal R^*\otimes\mathcal O_S(2H+3F_0).
\]

The scheme \(\Gamma\) is the regular zero scheme of a section of the
rank-two bundle \(\mathcal E\).  The standard resolution of the square of
its ideal, twisted by \(7H+9F_0\), is

\[
\begin{split}
0\longrightarrow&
\mathcal O_S(H+F_0)\oplus\mathcal O_S(H+2F_0)\\
\longrightarrow&
\mathcal O_S(3H+3F_0)\oplus
\mathcal O_S(3H+4F_0)\oplus
\mathcal O_S(3H+5F_0)\\
\longrightarrow&
I_\Gamma^2(7H+9F_0)\longrightarrow0.
\end{split}
\tag{7.3}
\]

The needed \(H^1\) and \(H^2\) groups of the displayed line bundles
vanish by the hypersurface restriction sequence for
\(S\subset\mathbf P^2\times\mathbf P^1\).  Moreover,

\[
\begin{array}{c|ccccc}
\mathcal O_S(aH+bF_0)
&(1,1)&(1,2)&(3,3)&(3,4)&(3,5)\\ \hline
h^0&6&9&40&47&54.
\end{array}
\]

Since \(\mathcal O_{\widetilde S}(D)\) pushes forward to
\(I_\Gamma^2(7H+9F_0)\), equation (7.3) gives

\[
h^0(\widetilde S,D)=(40+47+54)-(6+9)=126,
\qquad
H^1(\widetilde S,D)=0.
\]

For the double cover,

\[
\pi_*\mathcal O_{Z_4}
=\mathcal O_{\widetilde S}\oplus L_Z^{-1}.
\]

Serre duality identifies
\(H^1(L_Z^{-1})^*\) with \(H^1(D)\), while
\(H^0(K_{\widetilde S})=0\).  It follows that

\[
\boxed{q(Z_4)=0,
\qquad
p_g(Z_4)=126.}
\tag{7.4}
\]

Finally, \(K_{Z_4}\) is ample, so Kodaira vanishing and Riemann-Roch give

\[
\boxed{
P_2(Z_4)=h^0(2K_{Z_4})
=\chi(\mathcal O_{Z_4})+K_{Z_4}^2
=735.}
\tag{7.5}
\]

As a further consistency check, the unblown branch has arithmetic genus
\(947\).  Each ordinary sixfold point lowers the genus by
\(\binom62=15\), so the smooth strict transform has genus

\[
947-36\cdot15=407.
\]

The intersection, cohomology, and double-cover arithmetic in this section
is independently checked by `quartic_residual_cover_invariants.py`.

## Consequence and non-consequence

The quartic tangent-residual double cover is a smooth surface of general
type with ample canonical class and large positive geometric genus.  It
is not rational.  More generally, the resolved tangent-residual incidence
has ample canonical class for every \(d\ge4\).  Thus this entire family of
correspondences cannot supply the rational source required by the conic
bundle base-change argument.

This conclusion is only a negative result about one construction.  A
general \((2,d)\) hypersurface could still be unirational through another
covariant, another rational vertical seed, or a construction unrelated to
the tangent-residual incidence.  Nothing here proves non-unirationality of
\(X\).
