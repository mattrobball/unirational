# Integral-quintic squares through an isolated quadratic base cluster

## Statement

Let \(\sigma\) be a primitive quadratic triple with a nonempty
zero-dimensional base scheme, and put

\[
B_\sigma=\sigma^t\operatorname {adj}(A)\sigma .
\]

For a general symmetric quartic matrix \(A\), there is no connected
factorization

\[
B_\sigma=T^2C,
\qquad T\text{ an integral quintic},
\qquad 0\ne C\text{ a reduced conic}.
\tag{0.1}
\]

This note treats precisely the cases left open by
[`k2_isolated_quintic_offbase_exclusion.md`](k2_isolated_quintic_offbase_exclusion.md)
and
[`k2_isolated_quintic_transverse_base_exclusion.md`](k2_isolated_quintic_transverse_base_exclusion.md):
singular contact at a proper simple base point, contact with a free or
satellite infinitely-near simple center, and contact with a
multiplicity-two base point.  Thus, together with those two notes, it
closes the integral-quintic square-root row on the primitive isolated-base
locus.

The conclusion is about (0.1).  In the degree-zero quotient boundary the
triple has rank two and the determinant is a pure square; this rules out a
*reduced* residual conic, but is not being advertised as an exclusion of
every possible quintic component of that pure square.

## 1. The resolved contact and the coefficient image

Resolve the base ideal and write

\[
R=2H-M,
\qquad
0\longrightarrow\mathscr K\longrightarrow O^3
\xrightarrow{\ \sigma\ }O(R)\longrightarrow0.
\tag{1.1}
\]

Let \(\overline T\) be the normalization of the strict transform of
\(T\).  If the base cluster is simple, write

\[
M=\sum_{i=1}^lE_i,
\qquad
a_i=\operatorname {mult}_{p_i}(T_i),
\qquad
s=\sum_i a_i.
\tag{1.2}
\]

Here \(p_i\) may be proper, free, or satellite, and \(T_i\) is the
strict transform at that stage.  At a multiplicity-two base point put
\(a=\operatorname {mult}_pT\) and \(s=2a\).  In either case the pullback
of the three quadrics has common-zero divisor of degree \(s\).  After
division it generates a line bundle of degree

\[
f=R\cdot\widetilde T=10-s,
\tag{1.3}
\]

and the dual kernel bundle

\[
F=\mathscr K^\vee|_{\overline T}
\]

is globally generated of degree \(f\).  Nefness gives \(s\le10\).

The ninety quartic coefficients induce on \(\overline T\) a space of
quadratic forms of dimension at least

\[
\boxed{I_s=72-3s.}
\tag{1.4}
\]

Here is a conductor-safe local justification, including singular and
infinitely-near contact.  Let \(A_T\) be the one-dimensional local ring of
the integral plane curve at one proper support, let \(K_T\) be its fraction
field, and put

\[
I=(\sigma_0,\sigma_1,\sigma_2)A_T.
\]

After a generic constant component change, the first component
\(g=\sigma_0\) has the minimum valuation of \(I\) on every normalization
branch.  If the total contact over this support is \(b\), the plane-curve
intersection formula gives

\[
\operatorname {length}_{A_T}(A_T/(g))=b.
\tag{1.5}
\]

Consider the symmetric-relation map

\[
P(\sigma):A_T^3\longrightarrow\operatorname {Sym}^2(A_T^3),
\qquad \tau\longmapsto\operatorname {sym}(\sigma\tau),
\]

and its saturation

\[
L=\bigl(\operatorname {im}P(\sigma)_{K_T}\bigr)
\cap\operatorname {Sym}^2(A_T^3).
\]

This definition includes coefficients which are integral on the
normalization branches but do not descend separately: no normality or
principal-part assumption is being made.  Project a symmetric matrix to
its \((00),(01),(02)\) coefficients.  On the three columns of
\(P(\sigma)\), the resulting square matrix is

\[
\begin{pmatrix}
2g&0&0\\
\sigma_1&g&0\\
\sigma_2&0&g
\end{pmatrix},
\qquad \det=2g^3.
\tag{1.6}
\]

The induced map from \(L/\operatorname {im}P(\sigma)\) to the cokernel of
(1.6) is injective.  Indeed, if the projected vector of
\(P(\sigma)\tau\) lies in the projected image of \(P(\sigma)A_T^3\), the
invertibility of (1.6) over \(K_T\) forces \(\tau\in A_T^3\).  Therefore

\[
\operatorname {length}
\bigl(L/\operatorname {im}P(\sigma)\bigr)
\le \operatorname {length}(\operatorname {coker}(1.6))
=3\operatorname {length}(A_T/(g))=3b.
\tag{1.7}
\]

The middle equality does not use a Smith normal form: projection to the
first coordinate gives a quotient \(A_T/(2g)\), and its kernel is
\((A_T/(g))^2\).  Thus the triangular matrix (1.6) has cokernel length
exactly \(3b\) over the possibly singular curve ring.

Away from the base divisor the polynomial relation module has dimension
eighteen, exactly as in the off-base certificate.  Summing (1.7) over the
proper supports bounds every additional saturated relation, including all
conductor/descent classes, by \(3s\).  This proves (1.4).  Free and
satellite centers are already included because their branch valuations
contribute to the total contact \(b\).

There is no omitted zero-form row.  Its fixed-coefficient codimension is
at least \(I_s\), and the parameter bounds below leave margin at least
twenty-five in the simple-cluster cases and twenty-six at a
multiplicity-two point.

## 2. Rank-one forms and quotient degree

If \(T\mid B_\sigma\), the nonzero restricted quadratic form has rank one.
Let \(M_T\subset F\) be its saturated image line and put

\[
m=\deg M_T,
\qquad
d=\deg(F/M_T)=f-m.
\tag{2.1}
\]

The quotient is globally generated, so \(d\ge0\).  A nonzero section of
\(M_T^2\otimes O_{\overline T}(4H)\) gives \(m\ge-10\), hence
\(d\le f+10\).  The standard Quot estimate bounds the affine dimension of
the fixed-\((\sigma,T,m)\) rank-one stratum by

\[
D(f,m)=
\max\{f-2m+1,0\}+\max\{2m+21,0\}.
\tag{2.2}
\]

For \(d>0\), the globally generated quotient gives a pencil of degree at
most \(d\) on \(\overline T\).  If \(\delta(T)=6-g(\overline T)\), the
same plane-quintic argument as in the earlier certificates gives

\[
\begin{array}{c|cccc}
d&\ge4&3&2&1\\ \hline
\delta(T)\ge\delta_d&0&1&3&6.
\end{array}
\tag{2.3}
\]

Indeed, \(d=3\) forces the plane quintic to be singular, \(d=2\) gives
genus at most three by Castelnuovo--Severi, and \(d=1\) makes the
normalization rational.

## 3. Marked cluster dimensions

For the selected simple base centers, Noether's delta formula gives

\[
\delta(T)\ge
\delta_B:=\sum_i\binom{a_i}{2}.
\tag{3.1}
\]

The equigeneric family of integral plane quintics with delta invariant at
least \(\delta\) has dimension at most \(20-\delta\).  We also retain the
incidence cost of matching the base cluster to the curve.  Relative to a
proper center, define

\[
\epsilon(a_i)=
\begin{cases}
0,&a_i=0,\\
1,&a_i=1,\\
2,&a_i\ge2.
\end{cases}
\tag{3.2}
\]

The first cost says that a marked smooth point moves in one dimension on
the curve rather than two in the plane.  If \(a_i\ge2\), the center is
one of finitely many singular points, giving cost two.

This same ledger is valid for arbitrary infinitely-near diagrams.  A free
successor has one base-cluster parameter and, once the curve and its
predecessors are fixed, only finitely many intersection points on the
exceptional curve; it costs one.  A satellite has no parameter and costs
zero.  Replacing a proper center by a free or satellite center lowers the
base-cluster dimension by respectively one or two, at least compensating
for any loss from (3.2).  Since the all-proper simple length-\(l\) triple
stratum has dimension \(17-l\), the combined curve-and-triple dimension
has the uniform upper bound

\[
(17-l)+20-max\{\delta_B,\delta_d\}
-\sum_i\epsilon(a_i)
\tag{3.3}
\]

for every proper, free, or satellite simple cluster.  This also explains
why no independence assertion for a special fat-point linear system is
being used here: (3.3) is an equigeneric marked-incidence bound.

An integral quintic has multiplicity at most four at every selected point;
multiplicity five at a proper point would make its degree-five tangent
cone the whole equation and factor it into lines.  Multiplicities do not
increase under blowup.  Thus it is enough to enumerate

\[
l=1,2,3,4,
\qquad 0\le a_i\le4,
\qquad 1\le s=\sum_i a_i\le10.
\tag{3.4}
\]

Subtracting (2.2) and (3.3) from the image bound (1.4), and maximizing
over every allowed \(d\), gives the following exact minimum margins:

\[
\begin{array}{c|rrrr}
l&d\ge4&d=3&d=2&d=1\\ \hline
1&3&2&1&1\\
2&3&3&2&2\\
3&3&3&3&3\\
4&3&3&3&3.
\end{array}
\tag{3.5}
\]

All are strict.  In particular, the two old borderline proper-point rows
are no longer equalities: the marked-singular incidence closes them.  The
worst rows are a triple point with \(d=2\) and a quadruple point with
\(d=1\), each on the length-one triple stratum; both have margin one.

## 4. A multiplicity-two base point

Here \(s=2a\), \(1\le a\le4\), and the rank-three and rank-two triple
strata have dimensions ten and nine.  Use

\[
\delta_B=\binom a2,
\qquad
\epsilon(a)=1\ (a=1),\quad 2\ (a\ge2).
\tag{4.1}
\]

The same calculation gives

\[
\begin{array}{c|rrrr}
\dim\{\sigma\}&d\ge4&d=3&d=2&d=1\\ \hline
10&2&2&2&2\\
9&3&3&3&3.
\end{array}
\tag{4.2}
\]

Thus every positive-degree quotient row is absent with strict margin.

## 5. The degree-zero quotient

It remains to treat \(d=0\).  The globally generated quotient \(F/M_T\)
is trivial.  Dualizing supplies a constant relation among the divided
triple on \(\overline T\).  Multiplying back by the common divisor says
that the corresponding constant linear combination of the plane quadrics
vanishes on \(T\); since \(T\) is an integral quintic, that quadric
vanishes on the plane.  Hence \(\sigma\) has rank two.

After a constant component change,

\[
\mathscr K=O\oplus O(-R),
\qquad
\mathscr K^\vee=O\oplus O(R).
\]

The constant relation is the global \(O\)-summand of \(\mathscr K\), even
when \(f=0\); its annihilator in \(\mathscr K^\vee\) is \(O(R)\).
Consequently the image line is the \(O(R)|_{\overline T}\) summand.  Writing the
quadratic form as

\[
q=\begin{pmatrix}a&b\\b&c\end{pmatrix},
\qquad a\in H^0(O(4H)),
\]

support on that image line gives \(a|_T=0\).  A plane quartic cannot
contain an integral quintic, so \(a=0\), and

\[
\det q=-b^2.
\tag{5.1}
\]

The residual determinant is a pure square and cannot have the nonzero
reduced residual conic required in (0.1).  Sections 3--5 exhaust the
simple, infinitely-near, and multiplicity-two base clusters, proving the
statement.

All finite ranges and margins in (3.5)--(4.2) are replayed by
[`k2_isolated_quintic_base_cluster_checks.py`](k2_isolated_quintic_base_cluster_checks.py).
