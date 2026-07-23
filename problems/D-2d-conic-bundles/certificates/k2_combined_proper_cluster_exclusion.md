# Combined cubic exclusions in three squarefree profiles

## Statement and scope

Let

\[
0\longrightarrow \mathscr K\longrightarrow
\mathcal O_{\mathbf P^2}^{\oplus3}
\xrightarrow{\ \sigma\ }\mathcal O_{\mathbf P^2}(2)
\longrightarrow0
\]

be defined by a base-point-free quadratic triple, and put

\[
\mathcal Q_2=\operatorname {Sym}^2(\mathscr K^\vee)
\otimes\mathcal O_{\mathbf P^2}(4).
\]

For a general bidegree-\((2,4)\) equation on the base-point-free
quadratic-triple locus:

1. the squarefree profile

   \[
   \boxed{[4,2,2,2,2]}
   \tag{0.1}
   \]

   does not occur, for arbitrary proper or infinitely-near positions of its
   four \(t=2\) centers; and
2. the profile \([3,3,3,2]\) does not occur when all four of its essential
   centers are proper; and
3. an all-proper \([3,2^7]\) profile can occur only if every cubic through
   the double \(t=3\) center and six of the seven \(t=2\) centers is
   reducible or nonreduced.

These are genuinely combined-cluster exclusions.  In the first row, the
exact Hilbert function of every adjoint subcluster selects four distinct
plane lines through the necessarily proper \(t=4\) center, each with twelve
units of branch contact.  In the second row a length-nine quotient selects
the triangle on the three sixfold points, again with twelve units on each
side.  Its fourth, omitted proper center is not discarded: variations in
the cubic-restriction kernel make its multiplicity-four condition contribute
two further net conditions after the point moves.

The argument includes balanced and unbalanced restriction lines, zero
determinants on a selected line, and the strata on which an entire pencil of
lines is unbalanced.  It does **not** treat infinitely-near essential
centers in \([3^3,2]\) or \([3,2^7]\), triples with an isolated base scheme,
or the remaining reducible-cubic subrow in the third assertion.

There is one useful structural sharpening in the first profile.  Its
\(t=4\) center is necessarily proper.  If it were nonproper, then
\(e\le2\) would give strict multiplicity at least \(8-2=6\) there;
proximity would give an ancestor of strict, hence corrected, multiplicity
at least six.  That ancestor would be a second center with \(t\ge3\), which
does not occur in the profile \([4,2^4]\).  Section 5 treats arbitrary
positions of the four remaining \(t=2\) centers.

## 1. The adjoint clusters and their forced cubics

For a squarefree rational double dodecic, write

\[
D=\sum_i(t_i-1)E_i^*
\]

in the orthogonal total-transform basis.  Rationality requires

\[
H^0(\mathcal J_D(3))=0.
\tag{1.1}
\]

In either row of (0.1), when all essential centers are proper, the complete
cluster \(D\) has length ten.  Thus cubic evaluation is an isomorphism

\[
H^0(\mathcal O_{\mathbf P^2}(3))
  \xrightarrow{\sim} H^0(\mathcal O_D).
\tag{1.2}
\]

Deleting any one of the simple \(t=2\) summands gives a length-nine
quotient \(K\subset D\).  The cubics through \(K\) therefore form a
one-dimensional affine space, or a unique projective cubic \(C_K\).  The
omitted proper point \(z\) does not lie on \(C_K\), since otherwise
\(C_K\) would be a nonzero section of \(\mathcal J_D(3)\).

### 1.1 The profile \([4,2^4]\)

Let \(p\) be the \(t=4\) center and retain three of the four \(t=2\)
centers \(q_1,q_2,q_3\).  Then

\[
K=3p+q_1+q_2+q_3.
\tag{1.3}
\]

A cubic triple at \(p\) is its binary tangent cone, hence is a union of
three lines through \(p\), counted with multiplicity.  If two of the
directions \(pq_i\) coincided, the conditions in (1.3) would leave at least
two independent cubics.  The uniqueness following from (1.2) therefore
forces three distinct directions and

\[
C_K=L_1\cup L_2\cup L_3,
\qquad L_i=\overline{pq_i}.
\tag{1.4}
\]

At a proper canonical center there is no exceptional branch component, so
the plane branch multiplicities are at least eight at \(p\) and at least
four at every \(q_i\).  Consequently

\[
I_{p}(B,L_i)+I_{q_i}(B,L_i)\ge8+4=12.
\tag{1.5}
\]

This is the full degree of \(B|_{L_i}\).

### 1.2 The profile \([3^3,2]\)

Let \(p_1,p_2,p_3\) be the three \(t=3\) centers and omit the \(t=2\)
center \(z\).  Now

\[
K=2p_1+2p_2+2p_3.
\tag{1.6}
\]

The three points cannot be collinear: otherwise cubics containing the
square of their common line would contradict the uniqueness supplied by
(1.2).  The unique cubic is therefore the reduced triangle

\[
C_K=L_{12}\cup L_{23}\cup L_{31}.
\tag{1.7}
\]

Each side contains two proper branch points of multiplicity at least six,
so

\[
I_{p_i}(B,L_{ij})+I_{p_j}(B,L_{ij})\ge6+6=12.
\tag{1.8}
\]

Equations (1.5) and (1.8) remain valid when a selected line is a branch
component; in the restriction calculation this is the zero determinant.

## 2. Three-line determinant bounds

The symmetric presentation is

\[
0\longrightarrow3\mathcal O(2)\longrightarrow6\mathcal O(4)
\longrightarrow\mathcal Q_2\longrightarrow0,
\qquad h^0(\mathcal Q_2)=72.
\tag{2.1}
\]

For any reduced cubic \(C\), twisting (2.1) by \(-3\) gives

\[
h^0(\mathcal Q_2(-3))=18,
\qquad
\dim\operatorname {im}
\bigl(H^0(\mathcal Q_2)\to H^0(\mathcal Q_2|_C)\bigr)=54.
\tag{2.2}
\]

On a balanced line the three entries have degrees \((6,6,6)\), and every
fiber of \((a,b,c)\mapsto ac-b^2\) has dimension at most eight.  On an
unbalanced line the degrees are \((8,6,4)\), and every fiber has dimension
at most nine.  These are the UFD bounds from
[`k2_profile5_three_line_exclusion.md`](k2_profile5_three_line_exclusion.md),
including the zero fiber and all diagonal boundaries.

Degree-twelve determinants with the contact in (1.5) or (1.8) lie in a
vector space of dimension at most one.  Hence the inverse determinant
locus on a selected line has dimension at most nine in the balanced case
and ten in the unbalanced case.  Forgetting every matching condition at the
nodes of the three-line cubic only enlarges the locus.  Uniformly over all
balanced/unbalanced patterns, the bad part of the fifty-four-dimensional
restriction image therefore has dimension at most

\[
3\cdot10=30,
\qquad\text{hence codimension at least }24.
\tag{2.3}
\]

No assertion about independence of degree-twelve branch jets is being made:
(2.3) is an upper bound inside the actual determinant restriction image.

## 3. The omitted multiplicity-four point

The omitted point \(z\notin C_K\) supplies the strict margin missing from a
three-line count with all lines unbalanced.  Fix the restriction of
\(q\in H^0(\mathcal Q_2)\) to \(C_K\).  Its affine space of extensions has
translation space

\[
V=H^0(\mathcal Q_2(-3)),
\qquad \dim V=18.
\tag{3.1}
\]

Suppose first that some line \(M\) through \(z\) is balanced.  From

\[
0\to\mathcal Q_2(-4)\to\mathcal Q_2(-3)
  \to\mathcal Q_2(-3)|_M\to0
\]

and the twist of (2.1), one gets

\[
H^1(\mathcal Q_2(-4))=0,
\qquad
\mathcal Q_2(-3)|_M\simeq\mathcal O_M(3)^{\oplus3}.
\tag{3.2}
\]

Thus \(V\) maps onto arbitrary triples of four-jets at \(z\) along \(M\).
Multiplication by the equation of \(C_K\) is a unit at \(z\), so the same
is true for differences of extensions in \(H^0(\mathcal Q_2)\).

The following elementary jet lemma is exact:

\[
\operatorname {codim}_{\operatorname {Sym}^2(k[t]/(t^4))}
\{ac-b^2=0\bmod t^4\}=4.
\tag{3.3}
\]

Indeed, if one entry is a unit, choose that entry and \(b\) freely and solve
uniquely for the other diagonal entry, giving dimension eight.  If all
three entries lie in \((t)\), the ambient stratum has dimension nine; a
nonzero first coefficient gives two independent determinant equations,
while vanishing first coefficient leaves dimension six.  Neither boundary
exceeds eight.  Therefore multiplicity at least four at fixed \(z\) cuts
the extension fiber by at least four.  Allowing \(z\) to move costs two, so
its net contribution is at least two conditions.

It remains to include the locus on which every line through \(z\) is
unbalanced.  Section 3 of
[`k2_profile5_three_line_exclusion.md`](k2_profile5_three_line_exclusion.md)
proves that the projective pairs \((\sigma,z)\) in this locus have dimension
at most fifteen, instead of \(17+2=19\).  Forgetting the branch condition at
\(z\) on this exceptional stratum loses four parameter dimensions, again
at least the required net two.  Thus the omitted center contributes at
least two in every splitting stratum.

## 4. Incidence margins

For fixed \(\sigma\) and fixed selected roots, (2.3) gives codimension
twenty-four in the seventy-two-dimensional restricted-form space.  In the
ordinary balanced-through-\(z\) stratum, Section 3 raises this to twenty-eight
before parameters move.

For \([4,2^4]\), the selected roots \(p,q_1,q_2,q_3\) move in dimension at
most eight, the omitted point in dimension two, and \(\sigma\) in the full
projective dimension seventeen.  The remaining equation-space codimension
is

\[
28-(8+2+17)=\boxed1.
\tag{4.1}
\]

On the all-unbalanced-through-\(z\) stratum, use (2.3) and the
fifteen-dimensional pair bound instead:

\[
24-(8+15)=\boxed1.
\tag{4.2}
\]

For \([3^3,2]\), the three selected roots move in dimension at most six.
The two corresponding margins are

\[
28-(6+2+17)=\boxed3,
\qquad
24-(6+15)=\boxed3.
\tag{4.3}
\]

## 5. Uniform exclusion of \([4,2^4]\)

We now remove the proper-center hypothesis from the first profile.  Let
\(p\) be its proper \(t=4\) center, whose properness was proved in the
introduction, and let \(v_1,\ldots,v_4\) be its four \(t=2\) centers.
They may have arbitrary proper origins and arbitrary intervening
\(t=1\) centers.

For \(S\subset\{1,2,3,4\}\), put

\[
D_S=3E_p^*+\sum_{i\in S}E_{v_i}^*.
\tag{5.1}
\]

There is no hidden unloading defect in these subclusters.  Start with
\(D_\varnothing=3E_p^*\), whose ideal is \(\mathfrak m_p^3\) and whose
colength is six.  Adjoining one coefficient-one total-transform center
changes the complete-ideal colength by at most one: this is the standard
one-point unloading exact sequence, whether the center is proper, free, or
satellite.  Thus the full quotient has length at most ten.  On the other
hand, the vanishing \(H^0(\mathcal J_D(3))=0\) injects the ten-dimensional
cubic space into that quotient, so its length is at least ten.  All four
one-point increments are therefore exactly one.  Apply the same argument
after ordering the centers with an arbitrary subset \(S\) first.  The
quotient of the full cubic-evaluation isomorphism then gives

\[
\ell(\mathcal O/\mathcal J_{D_S})=6+|S|,
\qquad
h^0(\mathcal J_{D_S}(3))=4-|S|.
\tag{5.2}
\]

Every cubic in one of these spaces is triple at \(p\), hence is the cone on
a binary cubic: a union of three lines through \(p\), with multiplicity.
For \(S=\{i\}\), the three-dimensional space in (5.2) forces a unique
plane line \(L_i\) through \(p\) whose successive strict transforms follow
the cluster path to \(v_i\).  Indeed, a cone reaches that center exactly
when it contains such a line.  If no plane line followed the path, the
space would be zero; if reaching the center required a repeated line factor,
its dimension would be at most two.  Thus

\[
H^0(\mathcal J_{D_{\{i\}}}(3))
 =L_i\cdot H^0(\mathcal O_{\mathbf P^1}(2)).
\tag{5.3}
\]

The four lines are distinct.  If \(L_i=L_j\), that plane line follows both
marked cluster centers, so every cone divisible by it belongs to
\(H^0(\mathcal J_{D_{\{i,j\}}}(3))\).  This gives dimension at least three,
contrary to the value two in (5.2).  This argument includes two collinear
proper origins, nested infinitely-near centers, and paths with negligible
separators; it is precisely here that the complete-subcluster Hilbert
function prevents a repeated direction.

Each \(L_i\) has branch contact at least twelve along the marked path.  If
\(v_i\) is proper, its strict multiplicity is at least four and
\(m_p\ge8\).  If it is nonproper, a strict transform of a plane line follows
only free centers, so \(e_{v_i}\le1\) and \(m_{v_i}\ge3\).  For an immediate
successor, the value three can occur only when \(r_p=9\), again giving
\(m_p+m_{v_i}\ge12\).  If there is an intermediate center, nonincrease and
proximity give at least

\[
m_p+m_{\rm intermediate}+m_{v_i}\ge8+3+3>12.
\tag{5.4}
\]

Noether's formula therefore gives

\[
I(B,L_i)\ge12
\qquad(1\le i\le4).
\tag{5.5}
\]

The cluster attached to one \(L_i\) moves in dimension at most two after
\(p\) is fixed: one parameter chooses the direction, and at most one more
chooses a distinct proper origin on that line.  Every later free center on
the strict transform of the fixed plane line is then fixed.  Thus all four
marked paths, together with \(p\), move in dimension at most ten.

Let \(C=L_1\cup\cdots\cup L_4\).  Twisting (2.1) by \(-4\) gives

\[
h^0(\mathcal Q_2(-4))=6,
\qquad
\dim\operatorname {im}
\bigl(H^0(\mathcal Q_2)\to H^0(\mathcal Q_2|_C)\bigr)=66.
\tag{5.6}
\]

Suppose first that the pencil through \(p\) is not entirely unbalanced, and
that exactly \(j\) of the four selected lines are unbalanced.  Unbalanced
lines form a proper curve in the dual plane, so its intersection with this
pencil is finite.  Each unbalanced selected direction therefore removes one
of the ten cluster parameters.  Equations (2.2)--(2.3), now on four lines,
give restriction-image codimension at least

\[
66-\bigl((4-j)9+j10\bigr)=30-j.
\tag{5.7}
\]

After the cluster moves, the fixed-\(\sigma\) codimension is at least

\[
(30-j)-(10-j)=20.
\tag{5.8}
\]

Allowing the full seventeen-dimensional projective \(\sigma\)-space leaves
codimension three in the equation space.

Finally suppose every line through \(p\) is unbalanced.  The projective
pair \((\sigma,p)\) then moves in dimension at most fifteen by the
all-unbalanced-pencil lemma cited in Section 3.  The four remaining cluster
paths move in dimension at most eight, while the four unbalanced line loci
have total dimension at most forty.  The remaining equation-space margin is

\[
\bigl(66-40\bigr)-(15+8)=\boxed3.
\tag{5.9}
\]

This exhausts every proper and infinitely-near realization of
\([4,2^4]\).

## 6. The integral-cubic subrow of \([3,2^7]\)

Assume all eight essential centers are proper.  Let \(p\) be the \(t=3\)
center, choose six of the seven \(t=2\) centers
\(q_1,\ldots,q_6\), and omit the last one \(z\).  Cubic evaluation on the
full length-ten cluster is again an isomorphism.  Hence there is a unique
projective cubic

\[
C\in H^0(\mathcal I_{2p+q_1+\cdots+q_6}(3)),
\qquad z\notin C.
\tag{6.1}
\]

Suppose \(C\) is integral.  Its normalization is \(\mathbf P^1\).  The
marked branch contact on it is at least

\[
2\cdot6+6\cdot4=36=\deg(B|_C).
\tag{6.2}
\]

An integral cubic component of the branch is already excluded on the
base-point-free locus by the strict degree-three factor margin in
[`k2_double_dodecic_frontier.md`](k2_double_dodecic_frontier.md).
It remains to bound nonzero determinant fibers over the one-dimensional
target selected by (6.2).

On the normalization, write

\[
\nu^*\mathscr K^\vee\simeq
\mathcal O_{\mathbf P^1}(a)\oplus
\mathcal O_{\mathbf P^1}(6-a),
\qquad0\le a\le3.
\tag{6.3}
\]

In fact \(a\ge1\).  If \(a=0\), the dual kernel has a constant syzygy on
the normalization, so a nonzero constant linear combination of the three
quadrics \(\sigma_i\) vanishes on the integral cubic.  A conic cannot
contain an integral cubic, and a base-point-free quadratic triple has rank
three, a contradiction.

For \(a=1,2,3\), the three symmetric-form entries have degrees

\[
(12+2a,\ 18,\ 24-2a).
\tag{6.4}
\]

Every fixed **nonzero** determinant fiber in these binary spaces has
dimension at most twenty-three.  Here is the complete elementary bound.
Choose the diagonal entry \(c\) of lower degree \(d=12+2a\).  For
\(c\ne0\), first choose \(c\) in a space of dimension \(d+1\).  The
congruence \(b^2\equiv-f\pmod c\) has no unaccounted positive-dimensional
boundary.  More explicitly, if \(c\) and \(f\) have multiplicities \(m,n\)
at a root, the local solution scheme modulo \(t^m\) has dimension

\[
\delta(m,n)=
\begin{cases}
\lfloor m/2\rfloor,&n\ge m,\\
n/2,&n<m\text{ and }n\text{ is even},\\
\text{empty},&n<m\text{ and }n\text{ is odd}.
\end{cases}
\tag{6.5}
\]

In every nonempty case \(\delta(m,n)\le m\), while requiring the chosen
degree-\(d\) form \(c\) to have multiplicity \(m\) at that fixed root of
\(f\) loses \(m\) parameters.  Summing over the finite root set of \(f\)
shows that the choice of \(c\) together with a residue class of \(b\)
modulo \(c\) still has dimension at most \(d+1\).  Lifting the
degree-eighteen form \(b\) from its residue class adds
\(19-d\) parameters, and the higher diagonal entry is then determined.
This gives the bound twenty.

If the lower diagonal entry is zero, then \(b^2=-f\) has
only finitely many solutions and the higher diagonal entry is arbitrary;
this boundary has dimension

\[
(24-2a)+1\le23.
\tag{6.6}
\]

Allowing the scalar nonzero determinant target adds one, so the bad part of
the fifty-four-dimensional cubic restriction image has dimension at most
twenty-four and codimension at least thirty.  The omitted point \(z\) gives
the same four-jet contribution as in Section 3.  In the ordinary stratum the
remaining equation-space margin is

\[
(30+4)-(14+2+17)=\boxed1,
\tag{6.7}
\]

where fourteen is the dimension of \(p,q_1,\ldots,q_6\).  If every line
through \(z\) is unbalanced, forget its branch condition and use the
fifteen-dimensional \((\sigma,z)\)-stratum instead:

\[
30-(14+15)=\boxed1.
\tag{6.8}
\]

Thus no such integral \(C\) occurs for a general equation.  Since any of
the seven \(t=2\) centers could have been omitted, a surviving all-proper
\([3,2^7]\) realization must have all seven selected cubics reducible or
nonreduced.  No assertion that this residual locus occurs is made.

The map from the ninety-dimensional bidegree-\((2,4)\) equation space to
\(H^0(\mathcal Q_2)\) is onto for fixed base-point-free \(\sigma\), so all
these codimensions pull back unchanged.  The whole profile (0.1), and the
all-proper subrow of \([3^3,2]\), and the integral-cubic all-proper subrow
of \([3,2^7]\) therefore project to proper subsets of the equation space.
This proves the stated exclusions for a general equation.

The arithmetic and every displayed dimension margin are replayed by
[`k2_combined_proper_cluster_checks.py`](k2_combined_proper_cluster_checks.py).
