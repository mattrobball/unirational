# Two-point jets on the \(n=2\) common-support frontier

## Verdict and exact scope

Continue with the \(n=2\) singleton stratum of
[`k2_profile327_multiple_nonproper_frontier.md`](k2_profile327_multiple_nonproper_frontier.md).
Write \(a_1,a_2\) for the two nonproper origins and \(T_1,T_2\) for
their marked tangent lines.  The two common-support possibilities left in
that note are

\[
C_{N_1}=L R_1,\qquad C_{N_2}=L R_2,
\tag{0.1}
\]

where \(L\) is the common branch line through the high origin and two
proper low origins, and

\[
C_{N_1}=Q M_1,\qquad C_{N_2}=Q M_2,
\tag{0.2}
\]

where \(Q\) is the common integral branch conic through the high origin
and all five proper low origins.  In (0.2) the \(M_i\) are lines.  In
(0.1) this note treats the open row in which the residual conic selected
below is integral.

Fix \(C=C_{N_1}\), so \(a_2\in C\) and \(a_1\notin C\).  Assume that
the residual component of \(C\) is integral and that the restricted binary
form has rank one at \(a_2\).  Then every row has strict incidence margin.
The apparent boundary

\[
\boxed{
T_2\text{ is unbalanced and }
\ker(q|_{T_2})\text{ agrees to order two with the constant summand of }
\mathscr K|_{T_2}.}
\tag{0.3}
\]

can lower the constant-matrix contribution from three to two only when
\(a_2\) is also a ramification point of the degree-two map defined by
\(\sigma|_{T_2}\).  Ramification is one further condition inside the
unbalanced-line hypersurface, so the final margin is again one.

The two-line coupling therefore does **not** itself lose a condition:
one first restricts to \(T_1\), and the exact six-dimensional kernel is a
space of constant symmetric matrices on \(T_2\).  On a balanced selected
line that six-dimensional space supplies the required four conditions.
On an unramified unbalanced selected line it supplies at least three.  The
only two-condition fiber is the simultaneous ramified flat-kernel boundary,
whose ramification pays for the loss.

The following bookkeeping is also complete.

1. If \(a_2\in T_1\) but \(T_1\ne T_2\), the selected condition loses
   one equation, while the cross-incidence costs one parameter.  Every
   such rank-one row is still strict, including (0.3).
2. The equality \(T_1=T_2\) is impossible: the two length-six contacts
   exhaust the degree-twelve restriction, while the distinct common
   branch support supplies an additional zero and hence forces a second
   branch line.
3. Tangency of the residual component of \(C\) to \(T_2\) forces that
   residual component to be a second branch component.  Thus the selected
   intersection is transverse in every survivor.
4. If the common and residual components of \(C\) are tangent at the high
   point, scheme-theoretic intersection supplies the same extra residual
   zero, while tangency costs one configuration parameter.  The margins
   only improve.

This is a frontier reduction, not an exclusion of the full \(n=2\)
stratum.  Applying the theorem with \(C=C_{N_i}\) excludes a row whenever
its residual component \(R_i\) is integral and the restricted form at the
other origin \(a_{3-i}\) has rank one.  Thus the exact uncovered complement
in the common-line alignment is

\[
\boxed{
(R_1\text{ reducible or }\operatorname {rk}q(a_2)=0)
\quad\text{and}\quad
(R_2\text{ reducible or }\operatorname {rk}q(a_1)=0).}
\tag{0.4}
\]

This includes the two mixed mismatches; it is not merely the union of the
``both reducible'' and ``both rank zero'' rows.  In the common-conic
alignment the two residual components are lines, hence integral, and the
exact uncovered complement is

\[
\boxed{\operatorname {rk}q(a_1)=\operatorname {rk}q(a_2)=0.}
\tag{0.5}
\]

No assertion about \(n=3\), repeated essential trees, a nonproper high
center, or isolated base schemes is made here.

> **Subsequent closure.**  The remaining rank-zero and reducible-residual
> complement is excluded in
> [`k2_profile327_n2_residual_boundary_exclusion.md`](k2_profile327_n2_residual_boundary_exclusion.md).
> Consequently the proper-high seven-distinct-singleton \(n=2\) row is
> absent.  That successor theorem does not enlarge the present note's scope.

## 1. The fixed reducible-cubic restriction costs twenty-five

The restriction image on a cubic has dimension fifty-four.  The uniform
fixed-determinant-fiber bounds on a line and an integral conic are,
respectively,

\[
F_L=9,\qquad F_Q=17.
\tag{1.1}
\]

The line bound includes the unbalanced splitting.  We may ignore the
matrix gluing between components when taking an upper bound; determinant
gluing will still be used to reduce the target on the residual component.

First suppose the common component is the line \(L\), and write
\(C=L\cup R\) with \(R\) an integral conic.  On \(R\), the visible
contact is

\[
6+3\cdot4+3=21.
\tag{1.2}
\]

Thus the determinant target initially has vector dimension
\(25-21=4\).  The two components meet at the high point and at a second
point.  The first point is already in (1.2), while determinant gluing with
\(\det(q|_L)=0\) forces a zero at the second point.  The residual target
therefore has dimension three.  The bad restriction locus has dimension
at most

\[
9+(17+3)=29.
\tag{1.3}
\]

Now suppose the common component is the conic \(Q\), and write
\(C=Q\cup M\).  The residual line contains the high point and \(a_2\),
so its visible contact is

\[
6+3=9.
\tag{1.4}
\]

Its target again starts in dimension \(13-9=4\), and the second point of
\(Q\cap M\) lowers this to three.  Hence the same bound is

\[
17+(9+3)=29.
\tag{1.5}
\]

Consequently the fixed restriction codimension is

\[
\boxed{54-29=25.}
\tag{1.6}
\]

The second intersection cannot be another marked origin in a survivor.
In the common-line row that would give the residual conic contact at least
twenty-five; in the common-conic row it would give the residual line
contact at least thirteen.  Either value forces the residual component.
If the two components are tangent at the high point, there is no second
reduced intersection, but the same extra zero is present
scheme-theoretically.  Write \(B=H B'\), where \(H\) is the common line or
conic.  Since \(B\) has multiplicity at least six at the high point,
\(B'\) has multiplicity at least five.  If
\(I_p(H,R)=2\), then

\[
\operatorname {ord}_p(B|_R)
\ge I_p(H,R)+I_p(B',R)\ge2+5=7.
\tag{1.7}
\]

Thus the order at the high point is already one above the visible six,
and the residual target still has dimension three.  The tangency itself
costs one configuration parameter, so this subrow is strictly smaller.

If the residual component follows \(T_2\), its contact acquires the
second nonproper multiplicity three.  It then has contact twenty-four on
the residual conic, or twelve on the residual line.  The additional
intersection with the common branch component makes its determinant zero,
so it is a second branch component.  The low-degree factor-pair theorem
excludes it.  Hence \(C\) is transverse to \(T_2\) at \(a_2\).

## 2. The exact six-dimensional coupling kernel

Put

\[
\mathcal E=\mathcal Q_2(-3).
\tag{2.1}
\]

The symmetrized presentation gives

\[
0\longrightarrow3O(-1)\longrightarrow6O(1)
\longrightarrow\mathcal E\longrightarrow0,
\qquad h^0(\mathcal E)=18.
\tag{2.2}
\]

For every line \(T\), restriction is onto and has a six-dimensional
kernel:

\[
0\longrightarrow H^0(\mathcal E(-1))
\longrightarrow H^0(\mathcal E)
\longrightarrow H^0(\mathcal E|_T)\longrightarrow0,
\qquad h^0(\mathcal E(-1))=6.
\tag{2.3}
\]

Indeed, after twisting (2.2), the kernel is represented by the six
constant entries of a symmetric \(3\times3\) matrix.  If \(\ell_1=0\)
is the equation of \(T_1\), then the kernel of restriction to \(T_1\) is

\[
\ell_1 M,\qquad M\in\operatorname {Sym}^2 k^3.
\tag{2.4}
\]

This is the useful replacement for a nonexistent surjectivity statement
on \(T_1\cup T_2\).  The latter restriction does have a
three-dimensional cohomological cokernel, but it is irrelevant after the
first line has been fixed.

At \(a_1\notin C\), multiplication by the cubic equation is a unit.  The
outside six-jet theorem therefore says that the bad locus in
\(H^0(\mathcal E|_{T_1})\) has codimension at least

\[
6\quad\text{if }T_1\text{ is balanced},\qquad
5\quad\text{if }T_1\text{ is unbalanced}.
\tag{2.5}
\]

After fixing a point of that bad locus, all remaining freedom is exactly
(2.4).  If \(a_2\notin T_1\), then \(\ell_1\) is a unit at \(a_2\).
Since \(C\) meets \(T_2\) simply at \(a_2\), the remaining variation is

\[
t\,u(t)\,M|_{\mathscr K|_{T_2}},\qquad u(0)\ne0.
\tag{2.6}
\]

If \(a_2\in T_1\) and \(T_1\ne T_2\), it is instead

\[
t^2u(t)\,M|_{\mathscr K|_{T_2}}.
\tag{2.7}
\]

## 3. Constant-matrix selected-jet lemma

Work in \(R=k[t]/(t^6)\), and suppose the value of the selected binary
form has rank one.  It can be diagonalized over \(R\), because one entry
is a unit and its determinant vanishes in \(R\).  Let \(v(t)\) generate
its kernel.  For a constant symmetric matrix \(M\), put

\[
c_M(t)=v(t)^tMv(t),\qquad
\Delta_M(t)=\det(M|_{\mathscr K|_{T_2}}).
\tag{3.1}
\]

Up to units, the selected condition for (2.6) is

\[
c_M+t u\Delta_M=0\pmod {t^5}.
\tag{3.2}
\]

### 3.1 Balanced selected line

Normalize the restricted quadratic triple to

\[
\sigma|_{T_2}=(1,t,t^2).
\tag{3.3}
\]

A kernel generator has the form

\[
v=(-ta-t^2b,a,b).
\tag{3.4}
\]

If \(a\) is a unit, divide by it and write \(\lambda=b/a\).  Write the
constant matrix as

\[
M=\begin{pmatrix}A&B&C\\B&D&E\\C&E&F\end{pmatrix}.
\tag{3.5}
\]

The coefficients of (3.2) in orders zero, one, and two successively solve
for \(D,B,A\).  After those substitutions, the order-three
coefficient is a polynomial in \(C,E,F\) whose \(C^2\)-coefficient is
\(-u(0)\ne0\).  Thus (3.2) has codimension at least four in the
six-dimensional space of \(M\)'s.  The case in which \(b\) is a unit is
the same after exchanging the two kernel generators.

For the cross variation (2.7), division by \(t^2\) gives

\[
c_M+t^2u\Delta_M=0\pmod {t^4}.
\tag{3.6}
\]

Its first three coefficients successively solve for \(D,B,A\), so its
codimension is at least three.

### 3.2 Unbalanced selected line

On an unbalanced line the three restricted quadrics span a base-point-free
pencil.  It defines a degree-two map

\[
\phi_{\sigma,T_2}:T_2\longrightarrow\mathbf P^1,
\qquad \mathscr K|_{T_2}=O(-2)\oplus O.
\tag{3.7}
\]

There are two different local normal forms at \(a_2\).  If \(a_2\) is
unramified for \(\phi_{\sigma,T_2}\), then, up to units and target change,

\[
\sigma|_{T_2}=(1,t,0).
\tag{3.8}
\]

The constant summand is generated by \((0,0,1)\), and a kernel generator
for the restricted rank-one form can be written

\[
v=(-ta,a,b).
\tag{3.9}
\]

If \(a(0)\ne0\), divide by \(a\) and put \(\lambda=b/a\).  The first
three coefficients of (3.2) successively solve for \(D,B,A\); the fourth
leaves a nonzero quadratic whose \(C^2\)-coefficient is \(-u(0)\).  The
selected locus therefore has codimension at least four.

If \(a(0)=0\) and \(b(0)\ne0\), divide by \(b\), put
\(\lambda=a/b\in(t)\), and use

\[
v=(-t\lambda,\lambda,1).
\tag{3.10}
\]

The first equation is \(F=0\), and the next is always the nonzero
quadratic

\[
E\bigl(2\lambda'(0)-u(0)E\bigr)=0.
\tag{3.11}
\]

On either component of this quadratic, one of the next two equations is
nonzero: if \(\lambda'(0)\ne0\), it contains a nonzero linear term in
\(C\) or \(D\), while if \(\lambda'(0)=0\), the order-three equation has
\(C^2\)-coefficient \(-u(0)\).  Thus these equations have height at least
three.  At \(\lambda=0\), the three leading nonzero terms are simply

\[
F,\qquad-u(0)E^2,\qquad-u(0)C^2.
\tag{3.12}
\]

Thus an unramified unbalanced selected line contributes at least three
conditions in every kernel orientation.

If \(a_2\) is ramified for \(\phi_{\sigma,T_2}\), then the local normal
form is instead

\[
\sigma|_{T_2}=(1,t^2,0).
\tag{3.13}
\]

Now a kernel generator is \(v=(-t^2a,a,b)\).  When \(a(0)\ne0\), the
selected locus has codimension at least four: after the value equation,
the next equation is the nonzero quadratic

\[
X\bigl(2\lambda'(0)-u(0)X\bigr),
\qquad X=E+F\lambda(0),\quad\lambda=b/a,
\tag{3.14}
\]

and later coefficients solve for \(B\) and \(A\).  When \(a(0)=0\), put
\(\lambda=a/b\in(t)\).  The locus has codimension at least three for
\(\operatorname {ord}(\lambda)=1,2\).  Only the order-two-flat row

\[
\lambda=0\pmod {t^3}
\tag{3.15}
\]

can have codimension two.  At \(\lambda=0\), for example, the five
coefficients have radical exactly \((F,E)\):

\[
F,\qquad-u(0)E^2,\qquad0,
\qquad2u(0)CE,\qquad0.
\tag{3.16}
\]

Thus the two-condition constant-matrix fiber requires both flatness and
ramification.

The ramification is a genuine extra condition in the moving
quadratic-triple space.  Fix \((T_2,a_2)\), choose a local coordinate with
\(a_2=(t=0)\), and write

\[
\sigma|_{T_2}=c_0+c_1t+c_2t^2,
\qquad c_i\in k^3.
\tag{3.17}
\]

Unbalancedness on the rank-two open set is
\(\operatorname {rk}[c_0\ c_1\ c_2]=2\), the open part of the irreducible
determinant hypersurface in the nine-dimensional restriction-matrix
space.  It has dimension eight.  Since \(c_0\ne0\), ramification at
\(a_2\) is exactly

\[
c_0\wedge c_1=0.
\tag{3.18}
\]

The matrices satisfying (3.18) have dimension
\(3+1+3=7\): choose \(c_0\), the scalar with \(c_1\in kc_0\), and
\(c_2\).  Hence ramification has codimension one inside the rank-two
unbalanced locus.  Restriction of triples of plane quadrics to a fixed
line is onto, so the same codimension statement holds in the
quadratic-triple space.  It remains genuine on the base-point-free open
set: for \(T_2=(z=0)\) and \(a_2=[1:0:0]\), the triples

\[
(x^2+y^2,xy,z^2),\qquad (x^2,y^2,z^2)
\tag{3.19}
\]

are respectively unramified and ramified there, and both are
base-point-free.

For two distinct marked lines, the unbalanced condition on \(T_1\) remains
independent after the ramified-unbalanced condition on \(T_2\) is imposed.
Indeed, fix a ramified rank-two restriction on \(T_2\).  Adding
\(\ell_2\) times arbitrary linear forms to the three quadrics does not
change that restriction.  On \(T_1\), these variations give all three
copies of the two-dimensional space of quadratics vanishing at
\(r=T_1\cap T_2\).  Base-point-freeness gives \(\sigma(r)\ne0\); after a
target change, its value is \((1,0,0)\), and two of the variations can be
chosen as a basis of the quadratics vanishing at \(r\).  The resulting
three restrictions span \(H^0(O_{T_1}(2))\), so \(T_1\) is balanced.
Thus its unbalanced determinant is not identically zero on the irreducible
ramified-\(T_2\) locus.  It either cuts that locus by one further condition
or the corresponding row is empty.

For the cross equation (3.6), both unbalanced normal forms have
codimension at least two in every kernel orientation.  That is sufficient
because the cross-incidence itself costs one parameter; ramification, when
present, only improves the margin.

## 4. Incidence margins

The eight proper origins of the pushed-down cluster move in dimension
sixteen, the two marked directions add two, and either common-support
alignment costs one.  Adding the seventeen-dimensional quadratic-triple
space gives the baseline

\[
16+2-1+17=34.
\tag{4.1}
\]

Let \(b_1\in\{0,1\}\) record whether \(T_1\) is unbalanced.  For distinct
lines, each unbalanced marked line cuts the quadratic-triple space by one,
and the two conditions are independent, including on the ramified
\(T_2\)-locus by the argument after (3.19).  The table uses the worst,
transverse common--residual row.  Tangency at the high point keeps fixed
codimension twenty-five by (1.7) and lowers the moving dimension by one.

The rows with the smallest margins are:

\[
\begin{array}{c|c|c|c}
T_2& a_2\in T_1&\text{fixed codimension}&\text{moving dimension}\\ \hline
\text{balanced}&\text{no}&25+(6-b_1)+4&34-b_1\\
\text{balanced}&\text{yes}&25+(6-b_1)+3&33-b_1\\
\text{unbalanced, unramified}&\text{no}&25+(6-b_1)+3&33-b_1\\
\text{unbalanced, ramified flat}&\text{no}&25+(6-b_1)+2&32-b_1\\
\text{unbalanced}&\text{yes}&25+(6-b_1)+2&32-b_1.
\end{array}
\tag{4.2}
\]

Every row has margin one.  In particular, in the ramified flat noncross
row the selected contribution is only two, but ramification lowers the
moving dimension once more:

\[
25+(6-b_1)+2=33-b_1>32-b_1.
\tag{4.3}
\]

Thus every rank-one integral-residual row in either common-support
alignment is excluded.  No codimension is assigned to flatness itself.

Finally, if \(T_1=T_2=T\), then \(B|_T\) has contact at least six at each
of the two distinct nonproper origins.  These contacts already exhaust
its degree twelve.  Since the common branch component contains neither
origin, it meets \(T\) elsewhere and supplies another zero.  Therefore
\(B|_T=0\), so \(T\) is a branch line distinct from the common component.
The low-degree factor-pair theorem excludes this row.

The cohomology dimensions, component targets, ramification dimension, and
every margin in (4.2)--(4.3) are replayed by
[`k2_profile327_n2_common_support_jet_checks.py`](k2_profile327_n2_common_support_jet_checks.py).
