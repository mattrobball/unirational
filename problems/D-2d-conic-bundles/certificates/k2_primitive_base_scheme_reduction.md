# Primitive quadratic triples with an isolated base scheme

## Status and theorem boundary

Let

\[
X=(x^tA(y)x=0)\subset \mathbf P^2_x\times\mathbf P^2_y
\]

be a general hypersurface of bidegree \((2,4)\), and let

\[
\sigma=(\sigma _0,\sigma _1,\sigma _2),\qquad
B_\sigma=\sigma^t\operatorname {adj}(A)\sigma .
\]

This note treats the part of the class-\((1,2)\) frontier in which the
quadrics \(\sigma_i\) have no common curve but do have a nonempty
zero-dimensional base scheme.  It proves the following.

1. The possible saturated base schemes, Hilbert--Burch types, cluster
   multiplicities, and dimensions of all such triple strata are exactly the
   ones in Sections 1--2 below.
2. On a principalization of the base ideal, the fixed square is exceptional
   and the residual branch has class

   \[
   12H-2M.
   \]

   Simple base centers make no canonical-invariant correction.  A unique
   multiplicity-two center changes the generic starting invariants from
   \((18,11,10,0,29)\) to \((16,10,9,0,26)\).
3. For a general \(A\), a multiplicity-two base center always has corrected
   half-multiplicity exactly \(t=2\), not \(t\geq3\).  Hence, in the
   squarefree row, the profile \([5]\) cannot occur on either
   multiplicity-two stratum.
4. For a general \(A\), no primitive quadratic triple with a nonempty
   isolated base scheme has an integral conic component in \(B_\sigma\).
5. No squarefree branch on an isolated-base stratum has profile \([5]\).
   The three possible positions of its unique high center--off the base
   scheme, at a multiplicity-two base point, and at a proper simple base
   point--are excluded separately in Sections 4, 7, and 8.

The conic theorem in item 4 is a genuine strict improvement over the
base-point-free ledger: its conic margin is seventeen there, equal to the
full triple-space dimension, whereas every nonempty-base stratum has
dimension at most sixteen.

At this stage this note did **not** exclude line components, doubled lines,
integral quintic square roots, or all combined branch/base clusters.  At an
infinitely-near simple base center, a special residual branch singularity
can also be worse than the generic forced double point.  Later certificates
close the connected integral-quintic row and reduce squared lines to the
explicit frontier recorded below; the combined branch/base problem remains.

## 1. Exhaustive algebraic classification

Put \(S=k[y_0,y_1,y_2]\), let \(W\subset S_2\) be the span of the three
entries of \(\sigma\), and write \(r=\dim W\).  Primitivity means that
\(W\) has no common curve.  Thus \(r\) is two or three.

Choose two general independent members \(q_0,q_1\in W\).  They form a
complete intersection of length four.  If \(Z\) is the saturated base
scheme of \(W\), then \(Z\subset V(q_0,q_1)\).  Consequently:

- if \(r=2\), then \(Z=V(q_0,q_1)\) is a \((2,2)\) complete intersection
  of length four;
- if \(r=3\), then \(\operatorname {length}Z\leq3\), because equality
  with the length-four complete intersection would put the third quadric in
  \(\langle q_0,q_1\rangle\).

A length-three base scheme for a rank-three net cannot lie on a line:
restriction to that line has degree two, so every conic through the scheme
would contain the line.  Conversely, a length-three scheme not lying on a
line imposes three independent conditions on conics.  The net is therefore
the complete space \(H^0(\mathcal I_Z(2))\).

The saturated ideals have the following exhaustive resolutions:

\[
\begin{array}{c|c|c}
\operatorname {length}Z&\text{type of }Z&\text{minimal resolution of }\mathcal I_Z\\ \hline
1&\text{one point}&
0\to O(-2)\to O(-1)^2\to\mathcal I_Z\to0\\
2&\text{a }(1,2)\text{ complete intersection}&
0\to O(-3)\to O(-1)\oplus O(-2)\to\mathcal I_Z\to0\\
3&\text{not contained in a line}&
0\to O(-3)^2\to O(-2)^3\to\mathcal I_Z\to0\\
4&r=2,\text{ a }(2,2)\text{ complete intersection}&
0\to O(-4)\to O(-2)^2\to\mathcal I_Z\to0.
\end{array}
\tag{1.1}
\]

The length-three row is the only saturated three-generator
Hilbert--Burch row.  For lengths one and two, the chosen net is respectively
a three-plane in the five- or four-dimensional quadratic part of the
saturated ideal; the three quadrics themselves need not generate that
saturated ideal in its minimal degrees.

## 2. Cluster types and exact parameter dimensions

Resolve the base ideal by ordinary point blowups

\[
\pi:S_\sigma\longrightarrow\mathbf P^2,
\qquad
M=\sum_i m_iE_i
\]

in the orthogonal total-transform basis.  The movable conic class is

\[
R=2H-M.
\tag{2.1}
\]

For a pencil, \(R^2=0\), hence \(\sum m_i^2=4\).  A primitive pencil has
exactly one of the two multiplicity patterns

\[
(m_i)=(1,1,1,1)\quad\text{or}\quad(m_i)=(2).
\tag{2.2}
\]

The first notation allows proper or infinitely-near centers and arbitrary
distribution among the supports.  Locally these are curvilinear complete
intersections.  The second case consists of a pencil in
\(H^0(\mathfrak m_p^2(2))\); its two leading binary quadrics have no common
root, so one blowup principalizes the ideal.

For a rank-three net, every base cluster is similarly either

\[
(1),\quad(1,1),\quad(1,1,1),\quad\text{or}\quad(2).
\tag{2.3}
\]

In the last case \(W=H^0(\mathfrak m_p^2(2))\), and the resolved map has
image a conic.  In the other length-three cases it is a quadratic Cremona
map.  The length-one and length-two maps have degrees three and two,
respectively.

Here are the dimensions inside the projective space \(\mathbf P^{17}\) of
ordered quadratic triples.  For rank three, a fixed net has an
eight-dimensional projective frame space.  If \(Z\) has length \(l\), the
net is chosen in \(\operatorname {Gr}(3,6-l)\).

\[
\begin{array}{c|c|c|c|c}
r&Z&\dim\{Z\}&\dim\operatorname {Gr}&\dim\{\sigma\}\\ \hline
3&\text{one point}&2&6&16\\
3&\text{two distinct points}&4&3&15\\
3&\text{one tangent vector}&3&3&14\\
3&\text{three distinct, noncollinear}&6&0&14\\
3&\text{tangent vector plus point, noncollinear}&5&0&13\\
3&\text{curvilinear triple not on a line}&4&0&12\\
3&\mathfrak m_p^2&2&0&10.
\end{array}
\tag{2.4}
\]

For rank two, pencils form the open primitive part of
\(\operatorname {Gr}(2,6)\), of dimension eight, and a projective spanning
triple in a fixed pencil has dimension five.  Thus

\[
\dim\{r=2\}=13.
\tag{2.5}
\]

The multiplicity-two subrow has dimension

\[
2+\dim\operatorname {Gr}(2,3)+5=2+2+5=9.
\tag{2.6}
\]

Equations (2.4)--(2.6) also show that the largest primitive isolated-base
stratum is the length-one rank-three stratum of dimension sixteen.

## 3. The resolved kernel bundle and branch class

On \(S_\sigma\), the divided triple generates \(O(R)\), so there is an
exact sequence

\[
0\longrightarrow\mathscr K\longrightarrow O^3
\xrightarrow{\ \sigma\ }O(R)\longrightarrow0.
\tag{3.1}
\]

For rank three this is the pullback of the Euler kernel
\(\Omega^1_{\mathbf P^2}(1)\) by the resolved quadratic map.  For rank two,
after a constant change of the three components,

\[
\mathscr K\simeq O\oplus O(-R).
\tag{3.2}
\]

Restriction of \(x^tA(y)x\) to \(\mathbf P(\mathscr K)\) is a section

\[
q_A\in H^0\left(S_\sigma,
\operatorname {Sym}^2(\mathscr K^\vee)\otimes O(4H)\right).
\]

Since \(\det\mathscr K^\vee=O(R)\), its determinant has class

\[
\boxed{
\Delta_\sigma=\det(q_A)\in|2R+8H|=|12H-2M|.}
\tag{3.3}
\]

Equivalently,

\[
\pi^*B_\sigma=2M+\Delta_\sigma.
\tag{3.4}
\]

Thus the square forced by the base ideal is exceptional.  Removing it in
the normalized double algebra does not put the triple into a positive
plane square-factor row \(e>0\).

The half-branch on \(S_\sigma\) is

\[
L=6H-M,
\qquad
K_{S_\sigma}+L=3H-\sum_i(m_i-1)E_i.
\tag{3.5}
\]

At every simple base center the pullback of \(B_\sigma\) has forced
multiplicity two.  At a terminal simple center, after the even exceptional
square is removed, a generic residual branch meets the final exceptional
curve in two distinct points.  This last description does not apply to a
nonterminal center: an infinitely-near successor forces the two points to
collide in its direction.  The full principalization still records one
\(t=1\) correction at each simple center.  A multiplicity-two base point
has forced multiplicity four; on its exceptional line the divided triple
is either the Veronese system of all binary quadrics (rank three) or a
base-point-free binary quadratic pencil (rank two).  A generic residual
branch therefore meets the exceptional line in four distinct points.

These statements describe the generic pair \((A,\sigma)\) on each stratum.
They do not assert that a special residual branch cannot acquire additional
infinitely-near singularities.

## 4. The multiplicity-two center is uniformly a \(t=2\) center

For a general symmetric quartic matrix \(A\), the plane discriminant

\[
D_A=(\det A=0)
\]

is smooth and \(A(y)\) has rank at least two at every point.  Indeed, the
rank-at-most-one locus has codimension three in the six-dimensional space
of symmetric matrices, so a general two-dimensional source avoids it.
Along the smooth rank-two part of the determinant hypersurface, first-jet
generation by quartics gives transversality.

Fix a multiplicity-two base point \(p\), and write the leading binary
quadratic triple on the exceptional line as \(\tau\).  Put

\[
C_0=\operatorname {adj}(A(p)).
\]

### 4.1 Rank three

Here \(\tau\) is a basis of \(\operatorname {Sym}^2T_p^*\), so its image is
a Veronese conic.  The degree-four tangent form is

\[
b_4=\tau^tC_0\tau.
\]

If \(A(p)\) has rank two, then \(C_0\) has rank one, and its conic cannot
contain a Veronese conic.  If \(A(p)\) is invertible, the restriction map

\[
\operatorname {Sym}^2(\operatorname {Sym}^2T_p^*)
\longrightarrow\operatorname {Sym}^4T_p^*
\]

is surjective with a one-dimensional kernel.  Thus \(b_4=0\) has
codimension five.  Conditional on it, the first derivative of
\(\operatorname {adj}(A)\) is arbitrary, and multiplication

\[
T_p^*\otimes\operatorname {Sym}^4T_p^*
\longrightarrow\operatorname {Sym}^5T_p^*
\]

is onto.  Vanishing of the degree-five term has six further independent
conditions.  Therefore branch multiplicity at least six has fixed-triple
codimension eleven.  The whole rank-three multiplicity-two triple stratum
has dimension ten, so a general \(A\) has no such incidence.

### 4.2 Rank two

The map \(\tau:\mathbf P^1\to\mathbf P^1\) is a finite map of degree two
onto a line in the component plane.  If \(A(p)\) is invertible, its adjugate
conic contains no line and \(b_4\ne0\).  If \(A(p)\) has rank two, then
\(C_0\) is the square of its kernel linear form.  The form \(b_4\) vanishes
identically exactly when the image line of \(\tau\) is that kernel line.
In this aligned case the degree-five term is a nonzero linear equation for
the normal displacement of \(A\); it is nonzero because \(D_A\) is smooth
at \(p\).

Consequently the branch multiplicity at a multiplicity-two base point is
always four or five for a general \(A\), in both ranks.  In the squarefree
row, where no plane square is removed first, its canonical
half-multiplicity is exactly

\[
\boxed{t=\left\lfloor \rho/2\right\rfloor=2,
\qquad \rho=\operatorname {mult}_p(B_\sigma)\in\{4,5\}.}
\tag{4.1}
\]

In particular, in the squarefree rationality row this root is a genuine
entry \(2\).  The profile \([5]\), the only retained profile without an
entry \(2\), is impossible on the two multiplicity-two base strata.

## 5. Starting invariants after the base resolution

Suppose first that the residual branch in (3.3) is smooth.  These are the
generic starting invariants before any extra branch specialization.  The
double-cover formulas and (3.5) give

\[
\begin{aligned}
K^2&=2\left(9-\sum_i(m_i-1)^2\right),\\
\chi&=11-\sum_i\binom{m_i}{2},\\
p_g&=h^0\left(3H-\sum_i(m_i-1)E_i\right),\\
q&=1+p_g-\chi.
\end{aligned}
\tag{5.1}
\]

The bicanonical system has invariant and anti-invariant pieces

\[
H^0\left(6H-2\sum_i(m_i-1)E_i\right),
\qquad
H^0\left(\sum_i(2-m_i)E_i\right).
\tag{5.2}
\]

For the two possible multiplicity patterns this is

\[
\begin{array}{c|ccccc}
(m_i)&K^2&\chi&p_g&q&P_2\\ \hline
(1,\ldots,1)&18&11&10&0&29\\
(2)&16&10&9&0&26.
\end{array}
\tag{5.3}
\]

Thus any number of simple base blowups is invisible to the birational
invariants, as expected for the forced \(t=1\) corrections.  A
multiplicity-two base point supplies one unit of the squarefree correction
sum.  Further singularities of \(\Delta_\sigma\) must still be resolved and
modify these starting values by the canonical-resolution formulas; in
particular, the table is not a final invariant calculation for a special
branch.

## 6. Exclusion of every integral conic component

Let \(C\subset\mathbf P^2\) be an integral conic and \(\widetilde C\) its
strict transform.  Then \(C\simeq\mathbf P^1\).  Put

\[
d=R\cdot\widetilde C.
\]

The dual of (3.1) restricts to

\[
0\to O_{\mathbf P^1}(-d)\to O_{\mathbf P^1}^3
\to\mathscr K^\vee|_{\widetilde C}\to0.
\tag{6.1}
\]

Hence \(\mathscr K^\vee|_{\widetilde C}\) is globally generated of degree
\(d\).  The kernel of
\(\operatorname {Sym}^2(O^3)\to
\operatorname {Sym}^2(\mathscr K^\vee|_{\widetilde C})\)
is the rank-three subbundle
\(O(-d)\otimes O^3\).  After twisting by
\(O_C(4)=O_{\mathbf P^1}(8)\), this gives the short exact sequence

\[
0\to3O(8-d)\to6O(8)
\to\mathcal Q_C\to0.
\tag{6.2}
\]

Every relevant value has \(0\leq d\leq4\), so
\(H^1(O(8-d))=0\).  Since quartics restrict surjectively to a conic, the
coefficient map from \(A\) onto \(H^0(\mathcal Q_C)\) is surjective.  Its
target dimension is

\[
V(d)=3d+27.
\tag{6.3}
\]

If \(C\mid B_\sigma\), then
\(\det(q_A|_{\widetilde C})=0\).  The rank-one-cone estimate gives the
following upper bound for the bad part of the target:

\[
R(d,8)=
\max_{-4\leq a\leq d}
\left(\max\{d-2a+1,0\}+\max\{2a+9,0\}\right).
\tag{6.4}
\]

For \(d=4,3,2,1,0\), these dimensions are respectively

\[
17,15,13,11,10.
\tag{6.5}
\]

Suppose first that the base cluster is simple and that \(C\) contains a
complete subcluster of length \(h\).  Then

\[
d=4-h,\qquad \dim\{C\}=5-h.
\]

The dimension statement is exact: every zero-dimensional scheme of length
at most three imposes independent conditions on conics, while the full
length-four primitive pencil base is a \((2,2)\) complete intersection and
has a two-dimensional vector space of conics through it.

For rank three one has \(0\leq h\leq3\), and the moving codimension is

\[
V(4-h)-R(4-h,8)-(5-h)=17.
\tag{6.6}
\]

For a rank-two pencil one may also have \(h=4\); that last margin is

\[
V(0)-R(0,8)-1=27-10-1=16.
\tag{6.7}
\]

At a multiplicity-two base point, conics avoiding the point again have
margin seventeen.  Conics through it have \(d=2\), move in dimension four,
and give

\[
V(2)-R(2,8)-4=33-13-4=16.
\tag{6.8}
\]

These margins must be compared with the dimensions of the corresponding
triple strata, not with seventeen.  Equations (2.4)--(2.6) give

\[
\begin{array}{c|c|c}
\text{triple stratum}&\dim\{\sigma\}&\text{smallest conic margin}\\ \hline
r=3,\ \text{simple nonempty base}&16&17\\
r=3,\ (m_i)=(2)&10&16\\
r=2,\ (m_i)=(1,1,1,1)&13&16\\
r=2,\ (m_i)=(2)&9&16.
\end{array}
\tag{6.9}
\]

Every inequality is strict.  The incidence therefore fails to dominate the
space of equations, proving

\[
\boxed{
\text{For general }A,\quad
C\nmid B_\sigma
\text{ for every integral conic }C
\text{ and every primitive isolated-base }\sigma.}
\tag{6.10}
\]

## 7. The \([5]\) point cannot lie off the base scheme

The companion three-line theorem
[`k2_profile5_three_line_exclusion.md`](k2_profile5_three_line_exclusion.md)
uses determinant fibers on three concurrent lines to exclude \([5]\) on
the base-point-free triple locus.  The same argument applies to an
isolated-base triple provided that the high point \(p\) is not in its base
scheme.  Here is the needed audit of the two changes in the parameter
count.

Choose three lines through \(p\) which avoid the finite proper and
infinitely-near base cluster.  Their union \(C\) is a reduced plane cubic,
and \(\sigma|_C\) is base-point-free.  On \(C\) one has

\[
0\to3O_C(2)\to6O_C(4)\to\mathcal Q_C\to0.
\tag{7.1}
\]

The plane restriction sequences give

\[
h^0(O_C(4))=15-3=12,
\qquad
h^0(O_C(2))=6.
\]

Moreover \(H^1(O_C(2))=0\).  Thus restriction from the equation space has
image dimension

\[
6\cdot12-3\cdot6=54,
\tag{7.2}
\]

exactly as in the base-point-free theorem.

On a balanced line the degree pattern is \((6,6,6)\), and the locus whose
determinant has contact at least \(\rho\) at \(p\) has dimension at most
\(21-\rho\).  On an unbalanced line the pattern is \((8,6,4)\), and the
corresponding dimension is at most \(22-\rho\).  These are the complete
UFD determinant-fiber bounds proved in Sections 2--3 of the companion
theorem, and they include the zero determinant.

If the pencil of lines through \(p\) contains balanced members, choose
three of them.  The fixed \((\sigma,p)\) codimension is at least

\[
54-3(21-\rho)=3\rho-9.
\tag{7.3}
\]

An isolated-base triple moves in dimension at most sixteen, and the
off-base point adds two parameters.  After both move, the margins for
\(\rho=10,11\) are therefore

\[
(3\rho-9)-18=3,6.
\tag{7.4}
\]

It remains to audit the case in which every line through \(p\) is
unbalanced.  Put

\[
W=\langle\sigma_0,\sigma_1,\sigma_2\rangle,
\qquad
H=W\cap H^0(\mathcal I_p(2)).
\]

Because \(p\) is not a base point, \(H\) is a pencil.  The elementary
line-component argument from the companion theorem has two outcomes once
isolated base points are allowed:

\[
H=M\cdot H^0(\mathcal I_p(1))
\quad\text{for a line }M,
\qquad\text{or}\qquad
H\subset H^0(\mathfrak m_p^2(2)).
\tag{7.5}
\]

For completeness, take \(p=[0:0:1]\) and write a member of \(H\) as

\[
q=z\ell(x,y)+b(x,y).
\]

If the projection \(H\to H^0(O_{\mathbf P^1}(1))\), \(q\mapsto\ell\),
has rank two, it is an isomorphism.  Write the corresponding binary part as
\(b=T(\ell)\).  The condition that every line \((\ell=0)\) occur as a
component says \(\ell\mid T(\ell)\) for every \(\ell\).  Comparing the
coefficients of \(T(x)\), \(T(y)\), and \(T(x+y)\) gives
\(T(\ell)=\ell m\) for one fixed linear form \(m\).  Hence
\(H=(z+m)H^0(\mathcal I_p(1))\), the first alternative.  Rank one is
impossible: the one-dimensional binary kernel could supply only the at
most two factors of one binary quadric for all lines outside the fixed
linear-term direction.  Rank zero is exactly the second alternative in
(7.5).

For the first alternative, the parameters are \(p\) (dimension two),
\(M\) (two), the one-dimensional extension of \(H\) to \(W\) (projective
dimension three), and a projective frame of \(W\) (eight).  The total is
fifteen.  In the second alternative, replace the choice of \(M\) by
\(\operatorname {Gr}(2,3)\), again of dimension two; the same bound
fifteen results.  Rank-two triples are already contained in this bound,
since they and the off-base point move in dimension \(13+2=15\).

Using three unbalanced lines, the fixed codimension is

\[
54-3(22-\rho)=3\rho-12.
\tag{7.6}
\]

After the at-most-fifteen-dimensional pair moves, the margins are again

\[
(3\rho-12)-15=3,6.
\tag{7.7}
\]

Thus a general \(A\) has no isolated-base triple with a branch point of
multiplicity ten or eleven away from the base scheme.

In a \([5]\) profile the unique essential center is proper: an
infinitely-near center of corrected half-multiplicity five has an essential
predecessor and would create another part of the profile.  Explicitly, at
most two branch exceptional curves pass through a canonical center, so
\(r_v\geq10\) gives strict multiplicity \(m_v\geq8\).  Proximity gives
\(m_u\geq m_v\) at its predecessor \(u\), hence \(r_u\geq8\) and
\(t_u\geq4\).  Combining this observation, the off-base exclusion, and
Section 4 gives the exact remaining \([5]\) boundary:

\[
\boxed{
\text{After Sections 4 and 7, the sole remaining }[5]\text{ position is a}
\text{ proper simple base point.}}
\tag{7.8}
\]

That last position is excluded next.

## 8. Excluding \([5]\) at a proper simple base point

Let \(p\) be a proper simple base point and
\(Z=\operatorname {Bl}_p\mathbf P^2\).  Write \(E\) for the exceptional
curve and \(H\) for the pullback of a line.  The divided quadratic triple
has class

\[
R=2H-E.
\]

Choose three distinct lines through \(p\) whose strict transforms avoid
every residual base point, and put

\[
D=L_1'+L_2'+L_3'\sim3H-3E.
\]

The three curves \(L_i'\) are disjoint.  On each of them the dual kernel
has splitting \(O\oplus O(1)\), so the quadratic-form degrees are

\[
(6,5,4),
\tag{8.1}
\]

in a target of dimension eighteen.

One must not assert that the equation space surjects onto the product of
these three targets.  The three values on \(E\) still come from the single
matrix \(A(p)\).  The loss is controlled on the first blowup as follows.
Let \(\mathcal Q\) denote the cokernel of the symmetric restriction map.  It
has a two-term presentation

\[
0\to3O_Z(2H+E)\to6O_Z(4H)\to\mathcal Q\to0.
\tag{8.2}
\]

The first line bundle has six sections and no \(H^1\), so the image of the
equation space in \(H^0(\mathcal Q)\) has dimension

\[
90-3\cdot6=72.
\tag{8.3}
\]

After twisting (8.2) by \(-D\), the two line bundles are

\[
A_0=-H+4E,
\qquad
B_0=H+3E.
\tag{8.4}
\]

Elementary exceptional-curve sequences give

\[
\begin{array}{c|ccc}
&h^0&h^1&\text{graded }H^1\text{ pieces along }E\\ \hline
A_0&0&6&H^1(O_E(-2))\oplus H^1(O_E(-3))\oplus H^1(O_E(-4))\\
B_0&3&3&H^1(O_E(-2))\oplus H^1(O_E(-3)).
\end{array}
\tag{8.5}
\]

There are three copies of the first row and six of the second.  Here one
must split according to the rank of the first-jet span at \(p\).  A simple
proper center only says that this rank is positive; it need not be two if
the base cluster has an infinitely-near successor.

If the first-jet rank is two, a component frame makes the restriction of
the divided triple to \(E\) equal to \((u,v,0)\).  On the associated graded
spaces, multiplication by this triple has ranks

\[
0,\quad5,\quad9
\tag{8.6}
\]

on the degree \(-2,-3,-4\) source pieces, whose dimensions are
\(3,6,9\).  If the first-jet rank is one, the normal form is instead
\((u,0,0)\), and the corresponding ranks are

\[
0,\quad3,\quad6.
\tag{8.7}
\]

The first piece maps to the absent degree \(-1\) target.  More precisely,
\(\operatorname {gr}(\ker f)\) injects into
\(\ker(\operatorname {gr}f)\) for the filtered cohomology map \(f\).
Thus the kernel of
\(3H^1(A_0)\to6H^1(B_0)\) has dimension at most four in first-jet rank
two and at most nine in first-jet rank one.  The cohomology sequence of
(8.2) gives, respectively,

\[
h^0(\mathcal Q(-D))\leq18+4=22,
\qquad
h^0(\mathcal Q(-D))\leq18+9=27.
\]

Consequently the restriction image on the three strict lines has dimension
at least

\[
\boxed{50\text{ in first-jet rank two},\qquad
45\text{ in first-jet rank one}.}
\tag{8.8}
\]

The second case is genuinely necessary: it contains, for example, the
tangent-vector base strata.  These losses are why the naive value
fifty-four is false at a proper base point.

The original branch has a forced square of the line parameter on each
\(L_i\).  If \(\rho=\operatorname {mult}_p(B_\sigma)\), the divided
degree-ten determinant must have contact at least \(\rho-2\).  The complete
binary determinant-fiber bound in degrees \((6,5,4)\) is seven.  Hence the
bad part of each eighteen-dimensional line target has dimension at most

\[
7+\bigl(11-(\rho-2)\bigr)=20-\rho.
\tag{8.9}
\]

For three lines the fixed-triple codimension is therefore at least

\[
\begin{array}{c|c|c|c}
\text{first-jet rank}&\text{restriction image}&
\text{fixed-triple codimension}&\text{triple-stratum dimension}\ \hline
2&50&3\rho-10&\leq16\\
1&45&3\rho-15&\leq14.
\end{array}
\tag{8.10}
\]

The last dimension bound follows directly from the classification in
Section 2: first-jet rank one forces an infinitely-near successor, so a
rank-three net lies in the tangent-vector-or-smaller rows (dimension at
most fourteen), while a rank-two pencil has dimension at most thirteen.
For \(\rho=10,11\), the remaining margins are respectively \(4,7\) in
first-jet rank two and \(1,4\) in first-jet rank one.  They are all strict.
The three lines cost no parameters: multiplicity at \(p\) gives the contact
condition in every direction, and locally one may choose any three
directions avoiding the residual finite cluster.  Together with Sections
4 and 7, this proves

\[
\boxed{
\text{No primitive isolated-base quadratic triple has squarefree profile }
[5]\text{ for a general }A.}
\tag{8.11}
\]

Combining (8.11) with the base-point-free theorem
[`k2_profile5_three_line_exclusion.md`](k2_profile5_three_line_exclusion.md)
excludes \([5]\) on the entire primitive quadratic-triple locus.

## 9. Exact reduction of the remaining frontier

The new conclusions had the following precise scope at this stage of the
analysis.

- In the squarefree row, \([5]\) is absent on every primitive stratum,
  including the base-point-free locus.  The independent proximity theorem
  [`k2_profile432_proximity_exclusion.md`](k2_profile432_proximity_exclusion.md)
  also excludes \([4,3,2]\).  The intermediate primitive squarefree list was
  therefore reduced to

  \[
  [4,2^4],\ [3^3,2],\ [3^2,2^4],\ [3,2^7].
  \]

- In every square-factor row, the square root has no integral conic
  component on an isolated-base stratum.  In particular, a degree-two
  square root must be a product of lines.
- The exceptional square \(2M\) in (3.4) is canceled on normalization and
  is not a plane square factor.

At this stage, what remained was not merely arithmetic.  One still had to
treat squared lines,
the other reducible square-root shapes, an integral quintic square root,
special residual singularities along infinitely-near simple base centers,
and the combined Enriques-diagram incidence for the retained squarefree
profiles.  No existence or exclusion is asserted for those loci.

> **Subsequent sharpening.**  The resolved-line and adjoint theorems later
> exclude \([4,2^4]\) and \([3^3,2]\) on every primitive stratum, so the
> actual primitive squarefree frontier is now
> \([3^2,2^4]\), \([3,2^7]\).  The primitive \(e=2\) row is also closed,
> and the transformed-bundle theorem closes every base-point-free
> square-factor row.  The cluster theorem, together with the earlier
> off-base and transverse-proper results, closes the connected
> isolated-base integral-quintic square-root row; its degree-zero quotient
> boundary is only routed to a disconnected pure square.  A conductor-safe
> component theorem likewise closes the isolated \(e=3,4\) rows, with its
> degree-zero boundary again routed to a disconnected pure square.  The isolated
> squared-line row is reduced to six explicit through-base positions and
> one off-base high-diagonal row for a rank-three two-point base.  See
> [k2 isolated retained profiles](k2_isolated_base_retained_profile_exclusion.md),
> [k2 isolated degree-two squares](k2_isolated_degree2_square_exclusion.md),
> [k2 transformed squared lines](k2_basepointfree_line_square_transformed_bundle_exclusion.md),
> [k2 isolated quintics off the base](k2_isolated_quintic_offbase_exclusion.md),
> [k2 isolated transverse quintics](k2_isolated_quintic_transverse_base_exclusion.md),
> [k2 isolated quintic base clusters](k2_isolated_quintic_base_cluster_exclusion.md),
> [k2 isolated cubic and quartic components](k2_isolated_cubic_quartic_component_exclusion.md),
> [k2 isolated squared-line base alignment](k2_isolated_line_square_base_aligned_frontier.md),
> and
> [k2 isolated squared lines](k2_isolated_line_square_offbase_reduction.md).

The dimension tables, invariant calculations, local representation ranks,
and all conic and three-line margins are replayed by
[`k2_primitive_base_scheme_checks.py`](k2_primitive_base_scheme_checks.py).
