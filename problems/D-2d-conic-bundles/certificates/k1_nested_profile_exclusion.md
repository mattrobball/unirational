# Exclusion of the nested \([3,2,2,2]\) double-decic profile

## Statement

Let \(X\subset\mathbf P^2_x\times\mathbf P^2_y\) be a general hypersurface
of bidegree \((2,4)\).  No rank-two or rank-three bilinear section
\(\sigma\) has a squarefree branch decic

\[
B_\sigma=\sigma^t\operatorname {adj}(A)\sigma
\]

whose canonical resolution has correction profile \([3,2,2,2]\) with the
\(t=3\) center nonproper and preceded by an essential \(t=2\) center.

Consequently, at this stage of the analysis, the only unresolved
class-\((1,1)\) profile was the squarefree six-\(t=2\) family from
[the double-decic frontier](k1_double_decic_frontier.md).  That family is
subsequently closed in
[the uniform six-center theorem](k1_uniform_six_center_conic_exclusion.md),
so \(k=1\) is now complete.

## 1. The forced local type

Let \(q\) be the unique center with \(t_q=3\), and suppose it is nonproper.
Let \(p\) be its immediate predecessor.  Write

\[
m_v=\operatorname {mult}_v(B_v^{\mathrm {strict}}),\qquad
e_v=\#\{\text{exceptional branch curves through }v\},\qquad
r_v=m_v+e_v.
\]

Since \(e_q\le2\), one has \(m_q\ge4\).  Hence
\(m_p\ge m_q\ge4\), so \(p\) is essential.  In this profile it must have
\(t_p=2\), and therefore \(r_p\in\{4,5\}\).

Put

\[
\epsilon=r_p\bmod2.
\]

This is the branch status of the new exceptional curve \(E_p\).  If \(q\)
is satellite, let \(\delta\) be the branch status of its other exceptional
curve; if \(q\) is free, put \(\delta=0\).  Then

\[
e_q=\epsilon+\delta,\qquad e_p\ge\delta,\qquad
m_p=r_p-e_p,\qquad m_q=r_q-\epsilon-\delta.
\tag{1.1}
\]

The inequality \(m_p\ge m_q\) now makes the numerical possibilities
exhaustive.

- If \(r_p=4\), then \(m_p\le4\), whereas \(m_q\ge5\), impossible.
- If \(r_p=5,r_q=7\), then \(\delta=0\) gives \(m_q=6>m_p\), while
  \(\delta=1\) gives \(m_q=5\) and \(m_p\le4\), again impossible.
- Thus \(r_p=5,r_q=6\).  Equation (1.1) forces \(e_p=\delta\).

If \(e_p=\delta=1\), let \(u\) be the center that created the older branch
exceptional through \(p\) and \(q\).  Both \(p\) and \(q\) are proximate to
\(u\), so proximity gives

\[
m_u\ge m_p+m_q=4+4=8.
\]

This would create a center with \(t_u\ge4\), contradicting the profile.
Therefore \(e_p=\delta=0\) and \(m_p=m_q=5\).

If \(p\) were nonproper, its immediate-predecessor exceptional would be
nonbranch.  Its creator \(v\) would consequently have even \(r_v\), while
\(m_v\ge m_p=5\).  Hence \(r_v\ge6\), producing a second center with
\(t\ge3\).  Thus \(p\) is proper.  With no older exceptional through \(p\),
\(q\) is free.  We have proved

\[
\boxed{
(r_p,r_q)=(5,6),\qquad
(m_p,m_q)=(5,5),\qquad
p\text{ proper},\ q\text{ free first-near}.}
\tag{1.2}
\]

Proximity at \(p\) is saturated by \(m_p=m_q=5\), so no other center can
be proximate to \(p\).

Let \(\tau\) be the tangent direction represented by \(q\), and choose a
line \(L\) through \(p\), transverse to \(\tau\).  On a finite open
stratification, \(L\) can be chosen as a rational function of
\((p,\tau)\), and of the rank-two base point below, so it contributes no
parameter.  The infinitely-near intersection formula gives

\[
I_p(B,\tau)\ge m_p+m_q=10,\qquad
I_p(B,L)\ge m_p=5.
\tag{1.3}
\]

Zero restrictions, when a test line is a branch component, are included.

## 2. A binary determinant-fiber lemma

For \(A+C=2B\), put

\[
V_{A,B,C}
=H^0(\mathcal O_{\mathbf P^1}(A))
\oplus H^0(\mathcal O_{\mathbf P^1}(B))
\oplus H^0(\mathcal O_{\mathbf P^1}(C)),
\qquad
(a,b,c)\longmapsto ac-b^2.
\]

Every fiber over a fixed determinant, including zero, has dimension at most
\(B+2\) for the two patterns used below.  Start with the zero fiber.  Its
nonboundary locus has the exhaustive UFD form

\[
(a,b,c)=h(u^2,uv,v^2),
\]

and direct degree comparison gives dimension at most \(B+2\).  The diagonal
boundaries \((a,0,0),(0,0,c),0\) are no larger.  Thus

\[
\dim\det^{-1}(0)\le B+2.
\tag{2.1}
\]

Now fix a nonzero determinant \(f\).  Let \(Z\) be an irreducible component
of \(\det^{-1}(f)\), of dimension \(d_Z\), and consider the closed family

\[
\mathfrak X_f=
\{((a,b,c),s):ac-b^2=sf\}
\longrightarrow\mathbf A^1_s.
\]

Take the closure \(C_Z\) in \(\mathfrak X_f\) of

\[
\{((\lambda a,\lambda b,\lambda c),\lambda^2):
       (a,b,c)\in Z,\ \lambda\in\mathbf G_m\}.
\]

It is irreducible of dimension \(d_Z+1\), contains the origin, and the
coordinate \(s\) is a nonzero nonunit on \(C_Z\).  The
principal ideal theorem therefore makes every component of
\(C_Z\cap\{s=0\}\) have dimension \(d_Z\).  This intersection lies in the
zero-determinant fiber.  Consequently

\[
d_Z\le\dim\det^{-1}(0)\le B+2.
\]

Since this holds for every irreducible component \(Z\), it proves the same
bound for \(\det^{-1}(f)\).

This argument automatically includes nonreduced entries, vanished leading
coefficients, the zero matrix, and every truncated-degree stratum.
Applying the fiber-dimension theorem to the inverse image of a linear
determinant target \(U\) gives

\[
\dim\det^{-1}(U)\le B+2+\dim U
\tag{2.2}
\]

for every linear determinant target \(U\).  In particular,

\[
V_{6,5,4}:\ 7,\qquad V_{4,4,4}:\ 6
\tag{2.3}
\]

are fixed-fiber bounds.

In \(V_{6,5,4}\), degree-ten determinant targets with contact at least ten
or five have dimensions one and six, so their inverse images have dimensions
at most eight and thirteen.  In \(V_{4,4,4}\), the analogous degree-eight
targets with contact at least eight or three also have dimensions one and
six, giving bounds seven and twelve.  The identically-zero determinant
locus in \(V_{4,4,4}\) has dimension at most six.

## 3. Rank three

For fixed rank-three \(\sigma\), the restricted quadratic form is a section
of

\[
\mathcal Q
=\operatorname {Sym}^2(\Omega^1_{\mathbf P^2}(1)^\vee)
\otimes\mathcal O(4).
\]

The symmetric Euler resolution gives \(H^1(\mathcal Q(-2))=0\).  Restriction
to \(\tau\cup L\) is therefore onto the fiber product of two copies of
\(V_{6,5,4}\) over the common three-dimensional fiber at \(p\).  Its
dimension is

\[
18+18-3=33.
\]

By (1.3) and (2.2), the bad product has dimension at most

\[
8+13=21.
\]

The common-value condition can only lower this dimension.  The fixed
\((p,\tau)\) codimension is at least twelve.  Since \((p,\tau)\) moves in
dimension three, the fixed-\(\sigma\) codimension is at least nine.  This
is larger than the rank-three projective matrix-orbit dimension eight.

## 4. Rank two

Let \(b\) be the base point of a fixed rank-two \(\sigma\), and put
\(Z=\operatorname {Bl}_b\mathbf P^2\), with classes \(H,E\).  The complete
restricted quadratic-form space is

\[
W_2=
H^0(\mathcal O(6H-2E))
\oplus H^0(\mathcal O(5H-E))
\oplus H^0(\mathcal O(4H)),
\qquad
\dim W_2=25+20+15=60.
\tag{4.1}
\]

A line avoiding \(b\) has pattern \(V_{6,5,4}\); a strict transform of a
line through \(b\) has pattern \(V_{4,4,4}\).

### 4.1 The tangent line avoids the base point

Suppose \(p\ne b\) and \(b\notin\tau\), and choose \(L\) avoiding \(b\).
Restriction to the two-line union is onto.  Componentwise its kernel
dimensions are \((12,9,6)\), so its image dimensions are
\((13,11,9)\), totaling \(33\).  The fixed codimension is twelve.
The configuration \((p,\tau)\) has dimension three, and

\[
12-3=9>7.
\]

### 4.2 The tangent line contains the base point

Suppose \(p\ne b\) and \(b\in\tau\), and choose \(L\) avoiding \(b\).
The componentwise kernel dimensions are \((14,10,6)\), so the image
dimensions are \((11,10,9)\), totaling \(30\).  Along \(\tau\), the branch
has the forced square at \(b\); after removing it, the determinant has
degree eight.  Since \(p\ne b\), order ten at \(p\) forces this determinant
to vanish identically.  The bad-product dimension is at most

\[
6+13=19.
\]

The fixed codimension is at least eleven.  Here \(\tau\) is the line
\(\overline{pb}\), so the configuration has dimension two, and

\[
11-2=9>7.
\]

### 4.3 The quintuple point is the base point

Finally suppose \(p=b\).  On every line through \(b\),

\[
B|_{\rm line}=t^2\det(q_{\rm line}).
\]

The two conditions in (1.3) become orders at least eight and three for the
degree-eight determinants.  For two distinct lines through \(b\), the image
of (4.1) has dimension \(29\): the first two entries restrict independently
with image dimensions ten and ten, while the two quartic last entries share
exactly their scalar value at \(b\), giving image dimension nine.
Equivalently, the kernel dimensions are \((15,10,6)\).

The bad product has dimension at most

\[
7+12=19,
\]

so the fixed codimension is at least ten.  Only \(\tau\) moves, in dimension
one, and

\[
10-1=9>7.
\]

All rank-two and rank-three positions are exhausted.  Therefore a general
class-\((2,4)\) equation has no nested \([3,2,2,2]\) branch profile.
