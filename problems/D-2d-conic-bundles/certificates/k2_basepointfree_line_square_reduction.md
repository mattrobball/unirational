# Sharp reduction of the squared-line row on the base-point-free \(k=2\) locus

## Statement

Let \(\sigma\) be a base-point-free triple of plane quadrics and

\[
B_\sigma=\sigma^t\operatorname {adj}(A)\sigma .
\]

For a general symmetric quartic matrix \(A\), an incidence

\[
L^2\mid B_\sigma
\tag{0.1}
\]

can occur only in one of the following two extremal restriction strata.

1. The line is balanced,
   \(\mathscr K^\vee|_L\simeq O_L(1)^2\), and the nonzero leading
   rank-one form has a constant direction.  Equivalently, in the UFD
   expression below its moving pair has degree \(s=0\).
2. The line is unbalanced,
   \(\mathscr K^\vee|_L\simeq O_L\oplus O_L(2)\), and the leading form is
   supported on the square of the \(O_L(2)\) summand.  Its first normal
   coefficient has zero \(O_L(3)\) entry.

All other balanced and unbalanced first-neighborhood strata have strict
incidence margin and are absent for general \(A\).  The two displayed
strata are not excluded here.  Their margins are respectively zero and
minus two, so the first-neighborhood count alone cannot close the
square-factor row \(e=1\).

The associated inverse elementary transforms have

\[
(c_1,c_2)=(-1,3)\quad\text{and}\quad(-1,2),
\tag{0.2}
\]

respectively.  In particular, dividing the square does **not** directly
produce the base-point-free \(k=1\) kernel
\(\Omega^1_{\mathbf P^2}(1)\), whose Chern classes are \((-1,1)\).
This records the exact obstruction to routing (0.1) to the settled
\(k=1\) theorem.

## 1. Restriction to the first neighborhood

For

\[
0\longrightarrow\mathscr K\longrightarrow O^3
\xrightarrow{\ \sigma\ }O(2)\longrightarrow0,
\qquad
\mathcal Q_2=\operatorname {Sym}^2(\mathscr K^\vee)\otimes O(4),
\]

one has

\[
0\longrightarrow3O(2)\longrightarrow6O(4)
\longrightarrow\mathcal Q_2\longrightarrow0,
\qquad h^0(\mathcal Q_2)=72.
\tag{1.1}
\]

Twisting by \(-2L\) gives

\[
h^0(\mathcal Q_2(-2))=6h^0(O(2))-3h^0(O)=33,
\qquad H^1(\mathcal Q_2(-2))=0.
\]

Thus restriction to \(2L\) is onto a space of dimension

\[
\boxed{72-33=39.}
\tag{1.2}
\]

The space of base-point-free triples is projective of dimension seventeen,
and a line moves in dimension two.

The only splittings of the globally generated rank-two bundle of degree
two on \(L\simeq\mathbf P^1\) are

\[
\mathscr K^\vee|_L=O(1)^2
\quad\text{or}\quad
O\oplus O(2).
\tag{1.3}
\]

For a fixed line, the second condition is the determinant equation for the
three restricted quadrics.  Hence balanced pairs \((\sigma,L)\) move in
dimension nineteen, while unbalanced pairs move in dimension at most
eighteen.

## 2. Complete balanced stratification

On a balanced line write, modulo the square of a local equation \(t\),

\[
q=q_0+tq_1,
\qquad q_0\in H^0(O_L(6))^3,
\qquad q_1\in H^0(O_L(5))^3.
\tag{2.1}
\]

If \(q_0\ne0\) and \(\det q_0=0\), unique factorization gives

\[
q_0=h(u^2,uv,v^2),
\qquad
\deg u=\deg v=s,
\qquad
\deg h=6-2s,
\tag{2.2}
\]

where \(u,v\) are coprime and \(s=0,1,2,3\).  After the single scaling
redundancy, every leading stratum has affine dimension

\[
(7-2s)+2(s+1)-1=8.
\tag{2.3}
\]

The coefficient of \(t\) in the determinant is

\[
h\bigl(u^2c_1-2uvb_1+v^2a_1\bigr).
\]

The coprime-pair syzygy calculation gives kernel dimension

\[
12-2s
\tag{2.4}
\]

inside the eighteen-dimensional \(q_1\)-space.  Therefore the bad part of
the 39-dimensional first-neighborhood target has dimension

\[
20-2s.
\tag{2.5}
\]

After the nineteen parameters of \((\sigma,L)\) move, the remaining
equation-space codimension is

\[
\bigl(39-(20-2s)\bigr)-19=2s.
\tag{2.6}
\]

Every \(s\ge1\) stratum is absent for a general equation.  The extremal
\(s=0\) stratum has margin zero and remains.

If \(q_0=0\), then \(q_1\) is arbitrary and the bad target has dimension
eighteen.  Its moving margin is

\[
(39-18)-19=2,
\tag{2.7}
\]

so the rank-zero leading stratum is absent as well.

## 3. Complete unbalanced stratification

On an unbalanced line the two layers have degree patterns

\[
q_0:(4,6,8),
\qquad q_1:(3,5,7).
\tag{3.1}
\]

The nonboundary rank-one strata have the form

\[
q_0=h(u^2,uv,v^2),
\quad
(\deg h,\deg u,\deg v)=(4-2s,s,s+2),
\quad s=0,1,2.
\tag{3.2}
\]

Their leading dimension is again eight.  The elementary syzygy calculation
bounds the leading-plus-normal dimension by eighteen.  Thus their moving
margin is at least

\[
(39-18)-18=3.
\tag{3.3}
\]

There are two diagonal boundaries.  If only the degree-four entry of
\(q_0\) is nonzero, the leading space has dimension five and the
linearized equation kills the degree-seven entry of \(q_1\).  The other
two normal entries have dimensions four and six, so the total is

\[
5+4+6=15
\]

and the moving margin is six.

If only the degree-eight entry \(c_0\) is nonzero, the leading space has
dimension nine.  The linearized equation is

\[
c_0a_1=0,
\]

so the degree-three entry \(a_1\) vanishes, while the degree-five and
degree-seven entries are arbitrary.  This gives the largest bad stratum,

\[
9+6+8=23.
\tag{3.4}
\]

Its moving margin is

\[
(39-23)-18=-2,
\tag{3.5}
\]

and it remains.  Finally, \(q_0=0\) has target dimension eighteen and
margin three.  This exhausts the unbalanced zero-determinant cone and its
linearized first-neighborhood condition.

## 4. The elementary transform and the failed \(k=1\) shortcut

The two retained leading forms are nonzero and generically rank one along
\(L\).  Let

\[
U=\ker(q|_L)\subset\mathscr K|_L.
\]

Locally choose a frame whose second vector generates \(U\), and let \(t=0\)
be the line.  The kernel condition and \(t^2\mid\det q\) give

\[
q=
\begin{pmatrix}
a&t b\\
t b&t^2c
\end{pmatrix}.
\tag{4.1}
\]

Indeed, the off-diagonal entry is divisible by \(t\); after writing the
lower diagonal entry as \(tc_1\), divisibility of the determinant by
\(t^2\) forces \(a|_L\,c_1|_L=0\), and the nonzero polynomial \(a|_L\)
forces \(c_1|_L=0\).

Consequently the form extends regularly to the inverse elementary
transform

\[
\mathscr K'=\mathscr K[U/L],
\qquad
0\longrightarrow\mathscr K\longrightarrow\mathscr K'
\longrightarrow i_*(U(1))\longrightarrow0.
\tag{4.2}
\]

Its determinant is exactly \(B_\sigma/L^2\), a degree-ten form.  If
\(u=\deg U\), Grothendieck--Riemann--Roch in (4.2) gives

\[
c_1(\mathscr K')=-1,
\qquad
c_2(\mathscr K')=2-u.
\tag{4.3}
\]

In the retained balanced \(s=0\) stratum, \(U\simeq O_L(-1)\), hence
\(c_2(\mathscr K')=3\).  In the retained unbalanced high-diagonal
boundary, \(U\simeq O_L\), hence \(c_2(\mathscr K')=2\).  Neither is the
kernel \(\Omega^1(1)\) of a base-point-free linear triple, for which
\(c_2=1\).

Thus the residual degree-ten determinant is a genuine transformed-bundle
problem.  Applying the existing \(k=1\) theorem to it without a new
classification of these \(c_2=2,3\) bundles would be invalid.

All target dimensions, UFD strata, moving margins, and Chern classes are
replayed by
[`k2_basepointfree_line_square_checks.py`](k2_basepointfree_line_square_checks.py).
