# Exclusion of integral quintic components on the base-point-free \(k=2\) locus

## Statement

Let \(\sigma=(\sigma _0,\sigma _1,\sigma _2)\) be a base-point-free
triple of plane quadrics and put

\[
B_\sigma=\sigma ^t\operatorname {adj}(A)\sigma .
\]

For a general symmetric matrix \(A\) of plane quartics, no integral plane
quintic divides \(B_\sigma\), for any such \(\sigma\).  In particular, the
integral-quintic square-root subrow in degree five is empty.  Together with
the factor routing in
[`k2_basepointfree_higher_square_reduction.md`](k2_basepointfree_higher_square_reduction.md),
this excludes the entire base-point-free square-factor row \(e=5\).

The theorem is only about base-point-free quadratic triples.  It makes no
claim about a primitive triple with a nonempty isolated base scheme.

## 1. The quadratic-form space and restriction to a quintic

For a fixed base-point-free triple, let

\[
0\longrightarrow\mathscr K\longrightarrow O^3
\xrightarrow{\ \sigma\ }O(2)\longrightarrow0,
\qquad
\mathcal Q_2=\operatorname {Sym}^2(\mathscr K^\vee)\otimes O(4).
\]

The symmetric presentation is

\[
0\longrightarrow3O(2)\longrightarrow6O(4)
\longrightarrow\mathcal Q_2\longrightarrow0,
\qquad h^0(\mathcal Q_2)=72.
\tag{1.1}
\]

The ninety-dimensional equation space maps onto this
seventy-two-dimensional space; its kernel consists of the eighteen
multiples of the selected equation \(L_\sigma\).  Thus codimensions in
\(H^0(\mathcal Q_2)\) pull back unchanged to equations.

The zero quadratic form causes no omitted stratum.  For fixed \(\sigma\)
its inverse image is precisely that eighteen-dimensional kernel, so after
allowing the projective seventeen-dimensional family of triples its total
incidence has dimension at most thirty-five inside the affine
ninety-dimensional equation space.  A general equation therefore avoids
it.  We may henceforth work with a nonzero global quadratic form.

Let \(T\) be an integral plane quintic.  Twisting (1.1) by \(O(-5)\)
gives

\[
0\longrightarrow3O(-3)\longrightarrow6O(-1)
\longrightarrow\mathcal Q_2(-5)\longrightarrow0.
\]

Since \(H^0(O(-3))=H^0(O(-1))=H^1(O(-3))=0\),

\[
H^0(\mathcal Q_2(-5))=0.
\tag{1.2}
\]

Consequently restriction of a global quadratic form to \(T\) is
injective.  Pulling farther to the normalization
\(\nu:\overline T\to T\) is still injective.

Put

\[
F=\nu^*(\mathscr K^\vee|_T),
\qquad N=\nu^*O_T(4).
\]

The bundle \(F\) is globally generated and

\[
\deg F=10,
\qquad \deg N=20.
\tag{1.3}
\]

If \(T\mid B_\sigma\), the nonzero restricted form

\[
q_T\in H^0(\overline T,\operatorname {Sym}^2F\otimes N)
\]

has zero determinant.  It is nonzero by (1.2).

## 2. Rank-one strata and their quotient pencils

Let \(M\subset F\) be the saturated generic image line of \(q_T\), and
write

\[
m=\deg M,
\qquad d=\deg(F/M)=10-m.
\tag{2.1}
\]

The rank-one-cone estimate used in the earlier factor certificates bounds
the local affine dimension of the stratum with fixed \(m\) by

\[
D_m=
\max\{11-2m,0\}+\max\{2m+21,0\}.
\tag{2.2}
\]

Indeed, the first term bounds the Quot tangent space
\(H^0((F/M)\otimes M^{-1})\), and the second bounds
\(H^0(M^2\otimes N)\).  Since \(F/M\) is a quotient of the globally
generated bundle \(F\), it is globally generated and \(d\ge0\), so
\(m\le10\).  A nonzero section of \(M^2\otimes N\) also gives
\(m\ge-10\).

For the only values near the maximum one obtains

\[
\begin{array}{c|ccccc}
m&\le6&7&8&9&10\\ \hline
D_m&\le33&35&37&39&41\\
d&\ge4&3&2&1&0.
\end{array}
\tag{2.3}
\]

The small values of \(d\) force the normalization of \(T\) into smaller
plane-quintic strata.  If \(d>0\), the globally generated line bundle
\(F/M\) supplies a morphism to \(\mathbf P^1\) of degree at most \(d\):
take a general two-dimensional subsystem, or equivalently project the
image of its complete linear system from a general codimension-two linear
space.  Hence

\[
\operatorname {gon}(\overline T)\le d.
\tag{2.4}
\]

We use the following standard plane-curve dimension facts in characteristic
zero.  The arithmetic genus of a plane quintic is six, and the locus of
integral degree-five curves of geometric genus at most \(g\) has dimension
at most

\[
20-(6-g)=14+g.
\tag{2.5}
\]

This is the usual equigeneric codimension bound: a \(\delta\)-constant
stratum in the projective space of plane curves has codimension at least
\(\delta=p_a-g\).  We only need the consequences

\[
\begin{array}{c|c}
\text{quintic type}&\text{parameter dimension}\\ \hline
\text{arbitrary integral}&20\\
\text{singular integral}&\le19\\
g(\overline T)\le3&\le17\\
g(\overline T)=0&\le14.
\end{array}
\tag{2.6}
\]

For clarity, here are the gonality-to-genus implications used below.

- A smooth plane quintic has gonality four.  Thus gonality at most three
  forces \(T\) to be singular.
- If \(\overline T\) has gonality at most two, then it is rational or
  hyperelliptic.  In the hyperelliptic case choose a general smooth point
  of the plane model and project from it.  This gives a degree-four pencil
  independent of the degree-two pencil.  Castelnuovo--Severi gives
  \(g(\overline T)\le(2-1)(4-1)=3\).  Independence fails for at most one
  center: otherwise the degree-five plane series minus two distinct points
  would equal the same twice-hyperelliptic series.
- Gonality at most one means \(\overline T\simeq\mathbf P^1\).

Finally, \(d=0\) cannot occur.  A globally generated degree-zero quotient
of \(F\) is trivial.  Dualizing it gives a nonzero section of
\(\nu^*(\mathscr K|_T)\).  From

\[
0\longrightarrow\nu^*(\mathscr K|_T)
\longrightarrow O_{\overline T}^3
\xrightarrow{\ \sigma\ }\nu^*O_T(2)
\]

that section is a constant vector \(\lambda\in\mathbf C^3\) satisfying
\(\lambda\cdot\sigma|_T=0\).  A plane quadric cannot contain an integral
quintic, so \(\lambda\cdot\sigma=0\) on \(\mathbf P^2\).  The triple would
then span at most a pencil of quadrics, which necessarily has a nonempty
base scheme.  This contradicts base-point-freeness.

## 3. The four strict incidence margins

The projective space of ordered base-point-free quadratic triples has
dimension seventeen.  For fixed \((\sigma,T)\), injectivity (1.2) and
(2.2) bound the bad locus inside the affine 72-dimensional quadratic-form
space by \(D_m\).  We may therefore add the dimension of the appropriate
quintic stratum and the seventeen parameters of \(\sigma\).

The complete calculation is

\[
\begin{array}{c|c|c|c|c}
m&D_m&\dim\{T\}&
72-D_m-\dim\{T\}-17&\text{reason for }\dim\{T\}\\ \hline
m\le6&\le33&20&\ge2&\text{arbitrary integral quintic}\\
7&35&19&1&d=3\Rightarrow T\text{ singular}\\
8&37&17&1&d=2\Rightarrow g(\overline T)\le3\\
9&39&14&2&d=1\Rightarrow g(\overline T)=0.
\end{array}
\tag{3.1}
\]

Every margin is strict, and the remaining value \(m=10\) was excluded at
the end of Section 2.  Hence the incidence of triples and integral
quintics whose determinant restriction has rank at most one does not
dominate the equation space.  In particular,

\[
\boxed{
\text{For general }A,\quad
T\nmid B_\sigma
\text{ for every integral quintic }T
\text{ and every base-point-free }\sigma.}
\tag{3.2}
\]

The square-root condition \(T^2\mid B_\sigma\) is a sublocus of the
incidence just excluded, so no separate first-neighborhood estimate is
needed.

The rank-one dimensions, gonality/genus routing, and strict margins are
replayed by
[`k2_basepointfree_quintic_component_checks.py`](k2_basepointfree_quintic_component_checks.py).
