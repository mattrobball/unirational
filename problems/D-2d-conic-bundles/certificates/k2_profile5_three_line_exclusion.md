# Exclusion of the base-point-free \([5]\) double-dodecic profile

## Statement and scope

Let

\[
0\longrightarrow \mathscr K\longrightarrow
\mathcal O_{\mathbf P^2}^{\oplus3}
\xrightarrow{\ \sigma\ }\mathcal O_{\mathbf P^2}(2)
\longrightarrow0
\tag{0.1}
\]

be defined by a base-point-free quadratic triple, and put

\[
\mathcal Q_2=\operatorname {Sym}^2(\mathscr K^\vee)
\otimes\mathcal O_{\mathbf P^2}(4).
\]

For a general bidegree-\((2,4)\) equation, no such triple can give a
squarefree branch whose canonical-resolution correction profile is

\[
\boxed{[5].}
\tag{0.2}
\]

Equivalently, the first of the six arithmetic profiles retained in
[`k2_double_dodecic_frontier.md`](k2_double_dodecic_frontier.md) is absent
on the base-point-free quadratic-triple locus.

This theorem does not treat primitive triples with an isolated base scheme,
and it does not exclude the other five squarefree profiles.  Its point is
that the two-line estimate in the frontier note is not optimal for the
single high-multiplicity row: three concurrent lines give a strict margin.

## 1. The restriction space on three concurrent lines

Dualizing and symmetrizing (0.1) gives

\[
0\longrightarrow3\mathcal O(2)\longrightarrow6\mathcal O(4)
\longrightarrow\mathcal Q_2\longrightarrow0,
\qquad h^0(\mathcal Q_2)=72.
\tag{1.1}
\]

If \(C=L_1\cup L_2\cup L_3\) is any reduced cubic, multiplication by its
equation identifies the kernel of restriction with
\(H^0(\mathcal Q_2(-3))\).  Twisting (1.1) by \(-3\) gives

\[
h^0(\mathcal Q_2(-3))=6h^0(\mathcal O(1))=18.
\]

Consequently the restriction image on three concurrent lines has dimension

\[
\boxed{I_C=72-18=54.}
\tag{1.2}
\]

The map from the ninety-dimensional equation space to
\(H^0(\mathcal Q_2)\) is onto: its kernel is the eighteen-dimensional space
of multiples of the linear equation \(L_\sigma\).  Thus every codimension
computed in the image below pulls back with the same codimension to the
equation space.

## 2. One-line determinant fibers

On a balanced line,

\[
\mathscr K^\vee|_L\simeq\mathcal O_L(1)^{\oplus2},
\qquad
\mathcal Q_2|_L\simeq\mathcal O_L(6)^{\oplus3}.
\tag{2.1}
\]

The determinant map is

\[
(a,b,c)\longmapsto ac-b^2:
H^0(\mathcal O_L(6))^{\oplus3}\longrightarrow
H^0(\mathcal O_L(12)).
\]

Every fiber has dimension at most eight.  For the zero fiber this follows
from the UFD parametrization

\[
(a,b,c)=h(u^2,uv,v^2)
\]

and its diagonal boundaries.  For a fixed nonzero target \(P\), the family
\(ac-b^2=tP\) has mutually isomorphic fibers for \(t\ne0\) after scalar
rescaling, while its fiber at \(t=0\) is the zero fiber.  Upper
semicontinuity therefore gives the same bound for every nonzero fiber.
Degree-twelve targets with contact at least
\(r\) at a fixed point form a vector space of dimension \(13-r\).  Hence
the bad locus on one balanced line has dimension at most

\[
8+(13-r)=21-r.
\tag{2.2}
\]

On an unbalanced line,

\[
\mathscr K^\vee|_L\simeq\mathcal O_L\oplus\mathcal O_L(2),
\qquad
\mathcal Q_2|_L\simeq
\mathcal O_L(4)\oplus\mathcal O_L(6)\oplus\mathcal O_L(8).
\tag{2.3}
\]

The same UFD calculation, now for binary degrees \((8,6,4)\), bounds every
determinant fiber by nine.  Thus the corresponding bad locus has dimension
at most

\[
9+(13-r)=22-r.
\tag{2.4}
\]

These bounds include the zero determinant, so a chosen line is allowed to
be a branch component.

## 3. When an entire pencil is unbalanced

Fix \(p\in\mathbf P^2\).  A line \(L\) is unbalanced precisely when the
three restricted quadrics \(\sigma_i|_L\) are linearly dependent, or,
equivalently, when some conic in the net

\[
V_\sigma=\langle\sigma_0,\sigma_1,\sigma_2\rangle
\]

contains \(L\).

There are two possibilities.

1.  Some three lines through \(p\) are balanced.  Since balancedness is
    open in the pencil, this is the case whenever the whole pencil is not
    unbalanced.
2.  Every line through \(p\) is unbalanced.  On the base-point-free locus
    this forces the projective first derivative of the morphism
    \([\sigma_0:\sigma_1:\sigma_2]\) to vanish at \(p\).

Here is an elementary proof of the second assertion.  Choose coordinates
\(p=[0:0:1]\), and let

\[
H=V_\sigma\cap\{q:q(p)=0\}.
\]

This is a pencil.  If every line through \(p\) occurs as a component, the
containing member of \(H\) is unique: two independent members containing
the same line would have that common component, and the third net member
would have a zero on it, producing a base point.  The resulting map from
the pencil of lines to \(\mathbf P(H)\) is regular, nonconstant, and hence
onto.  Thus every member of \(H\) is reducible with a
component through \(p\).  Write a member as

\[
q_t=z\ell_t(x,y)+b_t(x,y).
\]

If the two linear forms occurring in \(\ell_t\) are independent, take
\(\ell_t=x+ty\).  The identity
\(b_t(-t,1)=0\) for every \(t\) gives

\[
b_t=(x+ty)(Ax+By),
\]

so the whole pencil has the common line \(z+Ax+By=0\).  A third conic has a
zero on that line, producing a base point of the triple.  If the
\(\ell_t\)'s are nonzero and proportional, the pencil again has a common
line and gives the same contradiction.  Therefore base-point-freeness
forces \(\ell_t=0\) identically.  Both members of \(H\) then have zero
first jet at \(p\), so the three-by-three matrix of values and first
derivatives of \(\sigma\) has rank one.

For fixed \(p\), the space of three quadratic first jets is the full space
of three-by-three matrices.  Its rank-at-most-one locus has affine
dimension five rather than nine.  The remaining quadratic coefficients
contribute nine dimensions.  Hence the exceptional projective
\(\sigma\)-locus has dimension thirteen for fixed \(p\), and the pairs
\((\sigma,p)\) have dimension at most

\[
\boxed{13+2=15.}
\tag{3.1}
\]

## 4. The three-line incidence margins

Suppose first that the pencil through \(p\) contains balanced lines, and
choose three of them.  Restriction to their union embeds the
54-dimensional image (1.2) in the product of three 21-dimensional line
spaces.  Forgetting all gluing conditions only enlarges the bad locus.
By (2.2), branch multiplicity at least \(r\) at \(p\) therefore has fixed
\((\sigma,p)\) codimension at least

\[
54-3(21-r)=3r-9.
\tag{4.1}
\]

The full space of pairs \((\sigma,p)\) has dimension \(17+2=19\).  After
allowing both to move, the remaining codimension in the equation space is

\[
3r-9-19=3r-28.
\tag{4.2}
\]

For \(r=10,11\), these are respectively two and five.

If every line through \(p\) is unbalanced, use any three distinct lines.
Equations (1.2) and (2.4) give fixed codimension

\[
54-3(22-r)=3r-12.
\tag{4.3}
\]

Now (3.1), rather than nineteen, is the dimension of the moving
\((\sigma,p)\)-stratum.  The two remaining codimensions are

\[
(3r-12)-15=3r-27=3,6.
\tag{4.4}
\]

All four margins are strict.

The choice of the three lines costs no parameters.  Multiplicity at \(p\)
forces the contact condition on every line through \(p\); locally on the
\((\sigma,p)\)-parameter space one may choose any three balanced lines in
the first case, and any fixed three lines in the second.  These open sets
form a cover, so the fiberwise codimension estimates apply to the original
incidence without adjoining line parameters.

## 5. Application to the \([5]\) profile

In the profile \([5]\), the unique essential canonical-resolution center
has

\[
t=\left\lfloor\frac r2\right\rfloor=5,
\qquad r\in\{10,11\}.
\]

It is a proper point.  Indeed, an infinitely-near center of corrected
multiplicity at least ten has an essential predecessor, which would give a
second part in the correction profile.  Thus Sections 3--4 apply.

For either parity of \(r\), the incidence of an equation, a base-point-free
quadratic triple, and a branch with profile \([5]\) has strictly smaller
dimension than the full equation space.  A general equation therefore has
no such triple.  This proves (0.2).

The integer and dimension calculations are replayed by
[`k2_profile5_three_line_checks.py`](k2_profile5_three_line_checks.py).
