# Binary-sextic model for the degree-eight contact descent

## Status

The headline problem is now solved by the independent tangent--residual
theorem in
[`../tangent_residual_theorem.md`](../tangent_residual_theorem.md).  This note
retains the exact model and unresolved arithmetic internal to the alternative
degree-eight route.

This note replaces the abstract phrase “unordered contact quotient” by an
explicit binary-sextic factorization problem.  It also distinguishes three
different arithmetic statements:

1. a \(K=\mathbf C(t)\)-point of the unordered contact curve;
2. a closed point whose residue field is a rational finite extension
   \(\mathbf C(s)/\mathbf C(t)\); and
3. an arbitrary closed point.

The first two are sufficient for the intended construction on the original
threefold.  The third is not: if the residue curve has positive genus, the
spread of the rational two-section is a ruled surface over that curve and is
not a rational surface.

The binary-sextic calculation below is unconditional on the open locus of
smooth fibers and proper plane sections.  The arithmetic-genus calculations
for the projective fiber products are exact **provided** the displayed maps
are morphisms there, the inverse image of the diagonal has the expected
codimension six, and the resulting compactification is a regular local
complete intersection.  Smoothness/transversality for the special family
coming from a fixed \((2,3)\) threefold has not been proved.  Consequently the
numbers below are not used as a proof that the actual contact curve has those
geometric genera.

The construction in Section 3 of
[Casarotti--Gammelgaard--Massarenti](https://arxiv.org/abs/2511.17213)
is the source of the equal-tangent criterion.

## 1. The branch sextic of a plane section

Let

\[
Q=\{a y_0^2+b y_0y_1+c y_0y_2+d y_1^2+g y_1y_2+h y_2^2=0\}
   \subset T_{2,1,1},
\]

where, on the conic-bundle base \(\mathbf P^1_{(s_0:s_1)}\),

\[
\deg(a,b,c,d,g,h)=(4,3,3,2,2,2).
\]

Put

\[
M(s)=
\begin{pmatrix}
a&b/2&c/2\\
b/2&d&g/2\\
c/2&g/2&h
\end{pmatrix}.
\]

Under the quartic blowdown

\[
(s_0,s_1,y_0,y_1,y_2)
 \longmapsto [s_0y_0:s_1y_0:y_1:y_2],
\]

the image has double line \(\Lambda=\{z_0=z_1=0\}\).  Let

\[
\Pi=\{\ell_0z_0+\ell_1z_1+\ell_2z_2+\ell_3z_3=0\}
\]

be a plane not containing \(\Lambda\).  In the fiber plane over
\(s=(s_0:s_1)\), the line cut out by \(\Pi\) has coefficient vector

\[
L_{\Pi,s}=(\ell_0s_0+\ell_1s_1,\ell_2,\ell_3).
\]

Define

\[
\boxed{R_\Pi(s)=L_{\Pi,s}^{\mathsf T}\operatorname{adj}(M(s))L_{\Pi,s}.}
\]

Every term has degree six in \(s_0,s_1\), and \(R_\Pi\) is quadratic in
\(\ell_0,\ldots,\ell_3\).  Up to the harmless scalar factor four, its
expanded form is

\[
\begin{aligned}
4R_\Pi={}&l^2(4dh-g^2)
 +l\ell_2(2cg-4bh)+l\ell_3(2bg-4cd)\\
&+\ell_2^2(4ah-c^2)+\ell_2\ell_3(2bc-4ag)
 +\ell_3^2(4ad-b^2),
\end{aligned}
\]

where \(l=\ell_0s_0+\ell_1s_1\).

The strict transform \(\widetilde C_\Pi\subset Q\) of the plane quartic
\(X_4\cap\Pi\) is a degree-two cover of the conic-bundle base.  The usual
dual-conic criterion says that its branch divisor is exactly
\(\{R_\Pi=0\}\).  One can also check its degree intrinsically.  If \(H\) is
the pullback of a plane and \(F\) a conic-bundle fiber, then

\[
H^2=4,\qquad H\cdot F=2,\qquad K_Q=F-H,
\]

so adjunction gives \(p_a(H)=2\).  A smooth member is therefore a genus-two
double cover of \(\mathbf P^1\), branched at six points.

Locally write the plane section as a quadratic equation in a fiber
coordinate.  A simple root of its discriminant \(R_\Pi\) is ordinary
ramification of the smooth curve \(\widetilde C_\Pi\).  A double root is a
node precisely when the corresponding fiber and tangency are otherwise
general.  It follows that, on the open locus excluding singular fibers,
planes containing \(\Lambda\), coincident points, and nonordinary contacts,

\[
\boxed{
\Pi\text{ has two distinct equal-tangent contacts}
\iff R_\Pi=g_2^2h_2,
}
\]

where \(g_2,h_2\) are binary quadratics, both are square-free, and
\(\gcd(g_2,h_2)=1\).  Equivalently, one must also require that \(R_\Pi\) is
not a square, so that the plane section remains geometrically integral.  The
roots of \(g_2\) are the two conic-bundle fibers containing the contacts.  The
two nodes lower the genus from two to zero; after the additional open
conditions in `degree8_descent.md`, this is exactly the rational two-section
used by CGM.

## 2. Ordered versus unordered contact curves

Let

\[
\rho_Q:\mathbf P^3_\Pi\dashrightarrow
\mathbf P H^0(\mathbf P^1,\mathcal O(6))=\mathbf P^6,
\qquad \Pi\longmapsto[R_\Pi].
\]

Away from its base locus,

\[
\rho_Q^*\mathcal O_{\mathbf P^6}(1)=\mathcal O_{\mathbf P^3}(2).
\]

Also define

\[
\mu:\mathbf P^2_g\times\mathbf P^2_h\longrightarrow\mathbf P^6,
\qquad(g,h)\longmapsto[g^2h].
\]

It satisfies

\[
\mu^*\mathcal O_{\mathbf P^6}(1)=\mathcal O(2,1).
\]

Let \(U_Q\subset\mathbf P^3_\Pi\) be the domain on which \(\rho_Q\) is
defined.  The factorization incidence over this open set is

\[
Y_Q^{\mathrm{fac}}=(\rho_Q|_{U_Q},\mu)^{-1}(\Delta_{\mathbf P^6}).
\]

When a projective compactification is needed, `Y_Q` below means the closure
of this incidence in
\(\mathbf P^3_\Pi\times\mathbf P^2_g\times\mathbf P^2_h\), computed via the
graph of \(\rho_Q\) (or a resolution of that graph).  It is not a literal
global fiber product on \(\mathbf P^3_\Pi\) unless \(\rho_Q\) is first
extended to a morphism; exceptional or excess components are precisely one
of the qualifications on the Chow calculation below.

Let \(Y_Q^\circ\subset Y_Q^{\mathrm{fac}}\) be the open where \(g\) and
\(h\) are square-free and coprime and where all the geometric admissibility
conditions of Section 1 hold.  Its point records the plane and the
**unordered** pair of contact fibers.  Thus this open is birational to the
admissible unordered contact curve \(C_Q^{\mathrm{un},\circ}\) in
`degree8_descent.md`.

The ordered curve is obtained by the degree-two base change

\[
\mathbf P^1\times\mathbf P^1\longrightarrow
\operatorname{Sym}^2\mathbf P^1\simeq\mathbf P^2_g,
\qquad(r_1,r_2)\longmapsto r_1r_2.
\]

Over the square-free locus this cover is etale and its involution exchanges
the two contact points.  It is therefore the ordered contact curve, not a
second unrelated incidence.

The image of \(\mu\) is the coincident-root locus for the partition
\((2,2,1,1)\) of a binary sextic.  Hilbert's degree formula gives

\[
\deg\Sigma_{(2,2,1,1)}
=\frac{4!\,(2\cdot2\cdot1\cdot1)}{2!\,2!}=24.
\]

Consequently a proper pullback by the quadratic map \(\rho_Q\) has degree
\(24\cdot2^2=96\) in plane space.  This agrees with the full Chow
calculation below.

## 3. Chow class and virtual arithmetic genus

There is a useful transversality check on the admissible open.  Fix a plane
not containing \(\Lambda\).  A low-weight \(\operatorname{GL}_2\) change and
a translation by linear multiples of \(y_0\) put its equation in the form
\(y_2=0\).  The branch sextic is then, up to a nonzero scalar,

\[
R=b^2-4ad,
\]

with \(\deg(a,b,d)=(4,3,2)\).  Its differential in coefficient directions is

\[
(\dot a,\dot b,\dot d)\longmapsto
2b\dot b-4d\dot a-4a\dot d.
\]

If \(a,b,d\) have no common zero on \(\mathbf P^1\), this map onto
\(H^0(\mathcal O(6))\) is surjective.  Indeed, let \(E\) be the kernel of

\[
\mathcal O(-4)\oplus\mathcal O(-3)\oplus\mathcal O(-2)
 \xrightarrow{(a,b,d)}\mathcal O.
\]

It is a rank-two bundle of degree \(-9\).  If
\(E\simeq\mathcal O(-r)\oplus\mathcal O(-(9-r))\), both summand degrees are
at most \(-2\), because no line bundle of degree greater than \(-2\) maps
nontrivially to the displayed source.  Hence \(2\le r\le7\), and
\(H^1(E(6))=0\).  Taking global sections after twisting by six gives the
claimed surjectivity.

A common zero of \(a,b,d\) means that the line \(y_2=0\) is a component of
the conic in that fiber.  The corresponding plane section then contains
that component line and is not geometrically integral.  Thus this is absent
on the admissible locus.  It follows that the universal
branch-sextic evaluation is a submersion there.  In characteristic zero,
generic transversality therefore proves that the admissible contact curve is
smooth for a general coefficient tuple.  This does **not** establish
transversality of a chosen projective compactification at its boundary, which
is the missing hypothesis in the arithmetic-genus calculation below.

Write \(A,B,C\) for the hyperplane classes on

\[
P=\mathbf P^3_\Pi\times\mathbf P^2_g\times\mathbf P^2_h.
\]

The diagonal in \(\mathbf P^6\times\mathbf P^6\) has class

\[
[\Delta]=\sum_{i=0}^6 H_1^iH_2^{6-i}.
\]

Therefore, whenever the pullback has the expected codimension,

\[
\boxed{
[Y_Q]=\sum_{i=0}^6(2A)^i(2B+C)^{6-i}.
}
\]

Extracting the coefficient of \(A^3B^2C^2\) gives

\[
\deg A|_{Y_Q}=96,\qquad
\deg B|_{Y_Q}=48,\qquad
\deg C|_{Y_Q}=96.
\]

If the diagonal pullback is a regular embedding, its normal bundle is the
pullback of \(T_{\mathbf P^6}\).  Hence

\[
\begin{aligned}
\omega_{Y_Q}
&=\bigl(K_P+7(2A)\bigr)|_{Y_Q}\\
&=(10A-3B-3C)|_{Y_Q}.
\end{aligned}
\]

On the fiber product the two pullbacks of \(\mathcal O_{\mathbf P^6}(1)\)
are isomorphic, so

\[
2A=2B+C\quad\text{in }\operatorname{Pic}(Y_Q).
\]

Thus

\[
\omega_{Y_Q}=(4A+3B)|_{Y_Q},
\qquad
\deg\omega_{Y_Q}=4\cdot96+3\cdot48=528.
\]

If \(Y_Q\) is connected and Gorenstein, this gives

\[
\boxed{p_a(Y_Q)=265.}
\]

If \(\rho_Q\) has three-dimensional image and \(\mu\) has
four-dimensional image, the map from \(P\) to
\(\mathbf P^6\times\mathbf P^6\) has seven-dimensional image.
Fulton--Hansen connectedness then makes the inverse image of the diagonal
connected.  If it is also transverse, it is smooth and hence geometrically
irreducible of genus \(265\).  The connectedness theorem used here is
[Fulton--Hansen, Annals of Mathematics 110 (1979), 159--166](https://annals.math.princeton.edu/1979/110-1/p06).

What is proved without transversality is only the factorization equivalence
on the admissible open and the displayed *expected* Chow/adjunction
calculation.  Boundary points can change the geometric genus of the
normalization, and base points of \(\rho_Q\) require resolving the rational
map before applying the formula.

In particular, neither \(Y_Q\) nor the six-dimensional CGM incidence fiber
should be declared rationally connected from dimension alone.  On the
transverse model, the latter is a rational five-dimensional bundle over the
ordered double cover of a high-genus curve.

## 4. Rational finite base change is sufficient

The strongest sufficient condition in `degree8_descent.md` is an
**admissible** \(K\)-point of \(Y_Q^\circ\).  A boundary point of a
compactification need not give contacts usable in the CGM construction.
There is a weaker condition relevant to the original threefold.

Suppose a rational curve \(D\simeq\mathbf P^1_s\) in the total contact
surface dominates the pencil-direction line \(\mathbf P^1_t\).  Then

\[
K=\mathbf C(t)\subset L=\mathbf C(s)
\]

is a finite rational extension, and the generic point of \(D\) supplies an
admissible contact pair over \(L\).  CGM's construction gives a rational
two-section over \(L\): its final conic has an \(L\)-point because
\(L=\mathbf C(s)\) is \(C_1\).  Spreading this curve over
\(\mathbf P^1_s\) produces a ruled surface with a rational generic fiber and
a section, hence a rational surface.  Its map to the original \((2,3)\)
threefold is horizontal.  Thus a rational multisection of the contact
fibration is sufficient even when there is no \(K\)-section.

By contrast, even a generically admissible closed point of \(Y_Q^\circ/K\)
may have residue field \(\mathbf C(D)\) for a finite cover
\(D\to\mathbf P^1_t\).  If \(g(D)>0\), spreading gives a ruled surface over
\(D\), whose irregularity is \(g(D)\); it is not a rational surface.  Such a
point does not settle the original problem.  A point supported only on the
boundary is weaker still.

## 5. The expected degree-48 fixed-root correspondence

The pencil of lines through the fixed discriminant point must be compactified
on the incidence ruled surface, not on a product of two projective lines.
Let \(T\) be the hyperplane class on the direction line and let \(U\) be the
pullback of \(\mathcal O_{\mathbf P^2_y}(1)\) to
\[
\mathbb F_1=\operatorname{Bl}_p\mathbf P^2_y.
\]
With coordinates
\[
[t_0:t_1],\ [u:v]\longmapsto[t_0u:t_1u:v],
\]
the coordinate divisors have classes
\[
[u=0]=U-T,\qquad[v=0]=U,\qquad U(U-T)=0.
\]
The globally transformed coefficients consequently have classes
\[
a:4U-T,\qquad b,c:3U,\qquad d,g,h:2U+T.
\]
This is the reason that treating every coefficient as a degree-three
polynomial in an affine parameter \(t\) gives the wrong compactified genus.

Let \(A\) be the relative hyperplane class of the bundle of planes in the
quartic model.  The four plane-coordinate divisors have classes
\[
A,\ A,\ A,\ A-T,
\qquad\text{so}\qquad A^3(A-T)=0.
\]
Let \(C\) be the relative hyperplane class for a binary quadratic \(h\).
Its three coefficient divisors have classes \(C,C+T,C+2T\), and hence
\[
C(C+T)(C+2T)=0.
\]

Fix one root of \(g\), namely the marked fiber \(u=0\), and write
\(g=u\,m\).  If \(M\) is the relative hyperplane class for the other linear
factor \(m\), its two coordinate divisors have classes \(M,M+T\), so
\[
M(M+T)=0.
\]

The target of the branch map is the relative projective bundle of binary
sextics.  Choose its relative hyperplane \(H\) so that its seven coordinate
divisors have classes
\[
H,H+T,\ldots,H+6T.
\]
Thus
\[
H^7+21TH^6=0.
\]
With this convention the relative diagonal has class
\[
\boxed{
[\Delta_T]
=\sum_{i=0}^6H_1^iH_2^{6-i}
+21T\sum_{i=0}^5H_1^iH_2^{5-i}.
}
\]
The correction term is forced by the identity
\(\pi_*(H^7)=-21T\): it makes
\((\operatorname{pr}_1)_*([\Delta_T]H_2^k)=H_1^k\).

For the branch-sextic map and the fixed-root factorization map one has
\[
H_1=2A,\qquad H_2=2M+C-2T.
\]
The term \(-2T\) reflects that the fixed factor \(u\) has class \(U-T\).
Let \(D\) be the pullback of the relative diagonal inside the fiber product
of the plane, linear-factor, and quadratic-factor bundles over
\(\mathbf P^1_T\).  In its ambient Chow ring,
\[
T^2=0,\quad A^3(A-T)=0,\quad M(M+T)=0,\quad
C(C+T)(C+2T)=0.
\]
Pulling back the displayed diagonal class and reducing with these relations
gives
\[
\boxed{
T\cdot[D]=48,\quad A\cdot[D]=168,\quad
M\cdot[D]=64,\quad C\cdot[D]=304.
}
\]
Thus the refined expected intersection number over the pencil-direction line
is \(48\).  It is the actual degree only after the branch-map base locus,
expected-codimension condition, and absence of excess components have been
checked.

The canonical class of the ambient sevenfold is
\[
K_{\mathrm{amb}}=-4A-2M-3C-5T.
\]
The relative diagonal has normal bundle the pullback of the relative tangent
bundle of the sextic projective bundle, whose first Chern class is
\[
c_1(T_{\mathrm{rel}})=7H+21T.
\]
Under the same expected-codimension and regularity assumptions as before,
adjunction therefore gives
\[
\begin{aligned}
\omega_D
&=(10A-2M-3C+16T)|_D\\
&=(4A+4M+10T)|_D,
\end{aligned}
\]
where the second equality uses \(2A=2M+C-2T\) on \(D\).  Hence
\[
\deg\omega_D
=4\cdot168+4\cdot64+10\cdot48
=1408.
\]
For a connected Gorenstein compactification,
\[
\boxed{\deg(D/\mathbf P^1_T)=48,\qquad p_a(D)=705.}
\]

Thus even the transverse connected model is a high-arithmetic-genus curve,
not a forced rational base change.  For the special family coming from a
fixed \((2,3)\) equation, one must still resolve the branch-map base locus,
check the expected-degree, boundary, and regularity hypotheses, and decide
whether a rational component dominates \(\mathbf P^1_T\).  The intersection
calculation by itself neither proves nor excludes such an exceptional
component.  No such component is presently known.

## 6. The marked tangent plane does not give a new rational section

Use the notation of the elementary transform in `degree8_descent.md`:

\[
(a,b,c,d,g,h)
=(uA_{11},A_{01},A_{12},A_{00}/u,A_{02}/u,A_{22}/u).
\]

At \(u=0\), the chosen component of the old singular conic is
\(L=\{x_1=0\}\), and the transformed point is
\(z=[1:0:0]\).  In the affine chart \(y_0=1\), the transformed equation near
\(z\) begins

\[
a'(0)u+b(0)y_1+c(0)y_2+\text{quadratic terms}.
\]

Since \(a'(0)=A_{11}(0)\), its tangent plane is

\[
A_{11}(0)x_1+A_{01}(0)x_0+A_{12}(0)x_2=0.
\]

But the old singular fiber is

\[
x_1\bigl(A_{11}(0)x_1+A_{01}(0)x_0+A_{12}(0)x_2\bigr)=0.
\]

Thus the tangent plane at \(z\) is exactly the *other* component line of the
old fiber.  On the original threefold it cuts the constant class-\((1,0)\)
surface already covered by the certified \(k=0\) analysis.  For a general
threefold its minimal resolution is a K3 surface, not a rational surface.
There is no elliptic/tangent-plane shortcut here.

## 7. Why the type \((3,1,0)\) theorem does not follow by a formal shift

A tempting determinant-preserving lattice change from weights
\((2,1,1)\) to \((3,1,0)\) is

\[
D=\operatorname{diag}(u,1,u^{-1}).
\]

It sends the coefficient tuple to

\[
\boxed{
(a,b,c,d,g,h)\longmapsto
(u^2a,ub,c,d,g/u,h/u^2),
}
\]

whose degrees would be

\[
(6,4,3,2,1,0),
\]

the type \((3,1,0)\) degrees.  Since \(\det D=1\), the determinant and the
degree-eight discriminant would be unchanged.  However the new quadratic
form is regular at \(u=0\) only if, after choosing a direction in the old
low-weight rank-two summand,

\[
\boxed{g(0)=0,\qquad h\in u^2H^0(\mathcal O_{\mathbf P^1}).}
\]

Equivalently, the chosen low-weight direction must be isotropic to second
order and orthogonal at first order to its complementary low-weight
direction.  These are extra jet conditions.

The marked transformed point \(z=[1:0:0]\) lies off the invariant divisor
\(E=\{y_0=0\}\), whereas the direction that is shifted down from weight one
to weight zero lies in the low-weight subbundle defining \(E\).  Automorphisms
of \(T_{2,1,1}\) preserve \(E\).  Therefore the existence of \(z\) does not
imply either divisibility condition.  For a general tuple they fail.

This rules out the formal argument “marked point \(\Rightarrow\) type
\((3,1,0)\) \(\Rightarrow\) CGM Proposition 5.1.”  It does not classify all
possible birational modifications of the conic bundle, but any successful
alternative must construct the missing integral lattice/jet data rather than
invoke the marked point alone.

## 8. Exact remaining tasks for this route

Either of the following would complete the descent construction:

1. produce a \(K\)-point of \(Y_Q^\circ\);
2. produce a rational curve in the total admissible contact surface that
   dominates \(\mathbf P^1_t\); or
3. give a different birational transformation to a conic-bundle type whose
   unirationality theorem applies over \(K\), including all integral lattice
   and generality checks.

The binary-sextic model shows why the standard shortcuts do not supply these:
the contact base is not forced to have genus zero, the expected fixed-root
model has degree \(48\) and virtual genus \(705\), \(C_1\) applies only to
the final conic, and the marked point does not provide the two-jet required
for a type \((3,1,0)\) shift.
