# Audited degree-eight transform and descent criterion

## Scope and status

This is now an alternative, unnecessary route: the headline unirationality
question is settled affirmatively by
[`tangent_residual_theorem.md`](tangent_residual_theorem.md).  The arithmetic
gap stated here remains a gap only inside this degree-eight contact method.

This note records the coefficient calculation behind the degree-eight
reduction, its precise relation to the dense equal-tangent locus constructed by
Casarotti--Gammelgaard--Massarenti (CGM), the coupled incidence needed for one
fixed general \((2,3)\) threefold, and the exact arithmetic condition that
would make the construction descend over \(K=\mathbf C(t)\).  The geometric
membership question is settled below.  The remaining gap is arithmetic:
no \(K\)-point of the ordered incidence or admissible unordered contact
quotient is known.  For the original threefold, a rational finite base change
\(\mathbf C(t)\subset\mathbf C(s)\) carrying an admissible contact point would
also suffice, but no such rational cover is known either; see
[`descent_work/contact_curve_model.md`](descent_work/contact_curve_model.md),
Section 4.

The relevant results of CGM are [Propositions 3.2 and 3.6 and Theorem
3.10](https://arxiv.org/abs/2511.17213).

The contact curve is made explicit as a binary-sextic factorization incidence
in [`descent_work/contact_curve_model.md`](descent_work/contact_curve_model.md).
That note also records the conditional Chow calculations, the marked-tangent
and type-`(3,1,0)` checks, and the distinction between an actual rational
finite base change and a general closed point.  The broader all-class and
unramified-invariant limits are in
[`alternate_work/program_limits.md`](alternate_work/program_limits.md).

## 1. The elementary transform, including its inverse

Let \(u\) be a linear form on the pencil line whose zero is the marked
singular fiber.  Write the restricted degree-three conic as

\[
q=\sum_{0\leq i\leq j\leq2}A_{ij}x_ix_j,
\qquad A_{ij}\in H^0(\mathbf P^1,\mathcal O(3)).
\]

Choose one component of the rank-two fiber and choose fiber coordinates so
that it is \(x_1=0\).  The assertion that this line is a component of
\(q|_{u=0}\) is exactly

\[
A_{00},A_{02},A_{22}\in
uH^0(\mathbf P^1,\mathcal O(2)).
\]

Substitute

\[
x_1=u y_0,\qquad x_0=y_1,\qquad x_2=y_2
\]

and divide the equation by \(u\).  The resulting balanced equation is

\[
a y_0^2+b y_0y_1+c y_0y_2+d y_1^2+g y_1y_2+h y_2^2=0,
\]

where

\[
\boxed{
(a,b,c,d,g,h)=
(uA_{11},A_{01},A_{12},A_{00}/u,A_{02}/u,A_{22}/u).
}
\]

Their degrees are \((4,3,3,2,2,2)\).  Conversely, if \(a\) vanishes at
\(u=0\), then

\[
\boxed{
(A_{11},A_{01},A_{12},A_{00},A_{02},A_{22})
=(a/u,b,c,ud,ug,uh)
}
\]

recovers the degree-three equation.  Thus, with the base point, component,
and coordinates fixed, the transform is a linear isomorphism between two
21-dimensional vector spaces, or projectively onto the hyperplane

\[
H_z=\{a(0)=0\}\simeq\mathbf P^{20}
\subset \mathbf P(V_{4,3,3,2,2,2})=\mathbf P^{21}.
\]

Here \(z=([u=0],[1:0:0])\) is the marked point of the transformed fiber,
and \(a(0)=0\) is simply \(Q(z)=0\).

The necessary open condition is

\[
\det Q(0)\ne0.
\]

Indeed, after the same permutation of coordinates as above, the determinant
identity is

\[
\det(q)=u\det(Q).
\]

Consequently \(\det Q(0)\ne0\) says simultaneously that the original
discriminant has a simple zero at \(u=0\) and that the transformed marked
fiber is smooth.  All statements below concern this open subset
\(H_z^\circ\).

## 2. What CGM dominance proves geometrically

CGM use the projective coefficient space

\[
V:=\mathbf P(V_{4,3,3,2,2,2})\simeq\mathbf P^{21}.
\]

In their coefficient notation, their fixed equal-tangent locus is

\[
U=\{a_0=a_1=a_3=a_4=0,\ b_0c_3-c_0b_3=0\}\subset V.
\]

It is an irreducible rational quadric of dimension \(16\).  For

\[
G=\operatorname{Aut}(T_{2,1,1}),
\]

one has \(\dim G=11\), and CGM Proposition 3.6 proves that

\[
\chi:G\times U\longrightarrow V,
\qquad (g,Q_0)\longmapsto gQ_0,
\]

is dominant.  Hence its geometric generic fiber has dimension

\[
11+16-21=6.
\]

Let \(D=G\cdot U\), the constructible dense image of \(\chi\), and let
\(T^\circ=T_{2,1,1}\setminus\{y_0=0\}\).  The group \(G\) acts transitively
on \(T^\circ\).  Consider the universal incidence

\[
J=\{(Q,z)\in V\times T^\circ:Q(z)=0\}.
\]

It is an irreducible \(\mathbf P^{20}\)-bundle over \(T^\circ\).  Since
\(D\) is dense, the subincidence \(J_D\) obtained by requiring \(Q\in D\)
is dense in \(J\).  It is \(G\)-invariant.  Transitivity on \(T^\circ\)
therefore makes all of its fibers have the generic dimension \(20\).  For
every fixed \(z\in T^\circ\), it follows that

\[
\boxed{D\cap H_z\text{ is dense in }H_z.}
\]

We now include the coupling with a fixed general threefold.  Put

\[
W=\operatorname{Sym}^2(\mathbf C_x^3)^*\otimes
H^0(\mathbf P_y^2,\mathcal O(3)),
\qquad \mathbf P(W)=\mathbf P^{59}.
\]

Let \((\mathbf P_x^2)^*\) parametrize lines in the conic fiber and define

\[
\widetilde{\mathcal C}=
\{(A,p,L)\in\mathbf P(W)\times\mathbf P_y^2
\times(\mathbf P_x^2)^*:A(p)|_L=0\}.
\]

For fixed \((p,L)\), restriction of a quadratic form to \(L\) has three
coefficients, and the corresponding evaluation map from \(W\) is
surjective.  Thus \(A(p)|_L=0\) imposes three independent linear conditions:

\[
\widetilde{\mathcal C}\longrightarrow
\mathbf P_y^2\times(\mathbf P_x^2)^*
\]

is a \(\mathbf P^{56}\)-bundle.  In particular it is irreducible of
dimension \(60\).  Its projection to \(\mathbf P(W)\) is dominant, and over
the open locus where \(\Delta_A\) is smooth and all its conics have rank two,
the fiber is the one-dimensional incidence of a point
\(p\in\Delta_A\) and one of the two components \(L\) of the singular conic.

Pass to the irreducible framed incidence \(\mathcal F\) that additionally
chooses base and fiber projective coordinates taking

\[
p\longmapsto[0:0:1],
\qquad L\longmapsto\{x_1=0\}.
\]

The frame fibers are torsors under parabolic stabilizers in projective linear
groups, hence are irreducible.  They do not change dominance over
\(\mathbf P(W)\).

The parameter \(t\) is the coordinate on the pencil of lines through \(p\),
so it is already the coefficient-field parameter.  Over
\(K=\mathbf C(t)\), the generic pencil line is

\[
[u:v]\longmapsto[tu:u:v].
\]

On the framed slice, the entrywise restriction maps are

\[
H^0(\mathbf P^2,\mathcal O(3))\longrightarrow
H^0(\mathbf P_K^1,\mathcal O(3))
\]

for \(A_{11},A_{01},A_{12}\), and

\[
H^0(\mathbf P^2,\mathcal I_p(3))\longrightarrow
uH^0(\mathbf P_K^1,\mathcal O(2))
\]

for \(A_{00},A_{02},A_{22}\).  Both maps are surjective: the monomials in
the last two base coordinates restrict to the standard binary monomial basis.
Together with the explicit elementary-transform isomorphism in Section 1,
this proves that the rational map

\[
\Phi:\mathcal F_K\dashrightarrow H_z^\circ
\]

is dominant.

Let \(U^\circ\subset U\) be the open on which the CGM construction has all
of its stated generality properties, and put

\[
D^\circ=G\cdot U^\circ.
\]

The restriction of \(\chi\) to \(G\times U^\circ\) is still dominant, so
\(D^\circ\) contains a nonempty open of \(V\).  Saturating that open under
\(G\) gives a nonempty \(G\)-invariant open \(O\subset D^\circ\).  The same
incidence argument used above gives

\[
O\cap H_z^\circ\ne\varnothing,
\]

and it is open dense in \(H_z^\circ\).  Dominance of \(\Phi\) now makes
\(\Phi^{-1}(O)\) dense open in \(\mathcal F_K\).

Finally project to \(\mathbf P(W)_K\).  Since \(\mathcal F\) is irreducible
and dominates \(\mathbf P(W)\), the dense open \(\Phi^{-1}(O)\) meets the
generic fiber in a nonempty open.  Constructibility then gives the same
conclusion after shrinking \(\mathbf P(W)_K\).

This is an ordinary complex open condition, not merely one over the generic
field.  Indeed, after spreading over the direction line \(\mathbf P_t^1\),
failure at its generic point says that finitely many cleared coefficient
polynomials in \(t\) vanish identically, which is closed on the framed
incidence.  Thus, for a general fixed coefficient matrix \(A\), a nonempty
open subset of the incidence of \(p\in\Delta_A\) and a chosen component \(L\)
has elementary transform in the geometric CGM good image
\(D^\circ_{\overline K}\).  Equivalently, the earlier universal coefficient
dominance persists on the general fixed-\(A\) fiber.

Changes of frame induce automorphisms of \(T_{2,1,1}\) (and changes of the
coordinate \(t\)); the invariance of \(O\) makes the conclusion independent
of those choices.

This closes geometric membership for a general fixed \(X\).  It still does
**not** produce a \(K\)-point of \(\chi^{-1}(Q)\): dominance gives only a
\(\overline K\)-point.

## 3. The ordered incidence has rational five-dimensional fibers

Let \(\phi:Q\to X_4\subset\mathbf P^3\) be the CGM quartic blowdown, whose
exceptional curve \(\{y_0=0\}\) maps to the double line \(\Lambda\).
Let \(C_Q^{\mathrm{ord},\circ}\) be the curve of ordered pairs \((p,q)\)
such that

- \(p,q\in Q\setminus\{y_0=0\}\);
- they lie on distinct conic-bundle fibers; and
- their images on the quartic-with-double-line model have the same tangent
  plane \(\Pi\).

Write \(p'=\phi(p)\), \(q'=\phi(q)\),
\(x=\Pi\cap\Lambda\), and \(C_4=X_4\cap\Pi\).  In the superscript
\(\circ\) we further require that \(\Pi\not\supset\Lambda\), that
\(p',q',x\) are three distinct noncollinear points, that \(C_4\) is
geometrically integral with ordinary nodes at those three points, and that
the quadratic Cremona transform through them is a geometrically integral
plane conic.  These are the open generality conditions used below.  Put

\[
I_Q^\circ=
\{g\in G:g^{-1}Q\in U^\circ\}.
\]

Sending \(g\) to the images of the two fixed points used in the definition of
\(U\) gives

\[
I_Q^\circ\longrightarrow C_Q^{\mathrm{ord},\circ}.
\]

On \(y_0\ne0\), an automorphism consists birationally of a base
\(\operatorname{PGL}_2\)-transformation, a \(\operatorname{GL}_2\) linear
change in the two affine fiber coordinates, and translation by two sections
of \(\mathcal O(1)\).  Fixing two ordered points on distinct fibers leaves a
one-dimensional diagonal subgroup on the base and an arbitrary
\(\operatorname{GL}_2\), hence a rational stabilizer of dimension \(5\).
Conversely, the base transformation and the two translation sections can be
chosen rationally by interpolation.  Therefore, on dense opens,

\[
\boxed{I_Q^\circ\text{ is a rational five-dimensional bundle over }
C_Q^{\mathrm{ord},\circ}.}
\]

In particular \(I_Q^\circ\) has dimension \(6\).  This statement does not say
that its total space is rational, nor does it supply a rational point on its
base curve.

## 4. Exact unordered-pair descent criterion

Let

\[
C_Q^{\mathrm{un},\circ}
=C_Q^{\mathrm{ord},\circ}/\langle(p,q)\leftrightarrow(q,p)\rangle
\]

be the admissible open of the unordered quotient.  A rational point of this
quotient is enough even when the two contact points are conjugate rather than
individually \(K\)-rational.

**Proposition.**  If
\(C_Q^{\mathrm{un},\circ}(K)\ne\varnothing\), then \(Q\) has a
geometrically integral rational two-section and is \(K\)-unirational.

**Proof.**  A point of the unbranched quotient gives a reduced degree-two
étale subscheme on \(Q\)

\[
Z=p+q
\]

defined over \(K\).  The common tangent plane \(\Pi\) is fixed by Galois and
is therefore defined over \(K\).  Since the pair is in the admissible open,
\(\Pi\) does not contain the double line \(\Lambda\), and

\[
x=\Pi\cap\Lambda
\]

is a \(K\)-point.  Since \(\phi\) is an isomorphism away from the exceptional
curve, \(Z'=\phi(Z)=p'+q'\) is a reduced degree-two étale subscheme of
\(\Pi\) over \(K\).  The plane quartic \(C_4=X_4\cap\Pi\) has ordinary nodes
at the noncollinear length-three \(K\)-subscheme \(Z'+x\).  The
three-dimensional vector space of conics through \(Z'+x\) defines a
quadratic Cremona transformation over \(K\).  It maps \(C_4\) birationally to
a geometrically integral plane conic \(C_2/K\).  Because
\(K=\mathbf C(t)\) is \(C_1\), \(C_2(K)\ne\varnothing\), so \(C_2\) and
\(C_4\) are \(K\)-rational.  As in CGM Proposition 3.2, \(C_4\) is a
rational two-section, and their Proposition 2.13 gives the
\(K\)-unirationality of \(Q\). \(\square\)

The word “admissible” is essential.  A rational point lying only on a
compactification may represent coincident contacts, contacts on
\(\{y_0=0\}\), two contacts on the same fiber, a plane containing
\(\Lambda\), or another degeneration for which the preceding construction
does not apply.

Thus either of the following would finish this route:

1. a \(K\)-point of \(I_Q^\circ\), giving an ordered pair; or
2. more weakly, a \(K\)-point of \(C_Q^{\mathrm{un},\circ}\), giving a
   possibly conjugate unordered pair.

Dominance of \(\chi\) supplies neither.  The \(C_1\) property controls the
final conic, not an arbitrary contact curve or the six-dimensional incidence
fiber above it.

## 5. Warning about a tempting genus calculation

Universal multisingularity formulas can formally assign genera and counts to
the ordered and unordered contact curves.  They require a versality condition
through codimension three that has not been proved for this non-very-ample
linear system.  In addition, the full Gauss double-contact divisor contains
the elliptic boundary component lying over the line of planes containing
\(\Lambda\); it must be removed before discussing the admissible CGM contact
curve.  No such conditional number is used in `RESOLUTION.md`.
