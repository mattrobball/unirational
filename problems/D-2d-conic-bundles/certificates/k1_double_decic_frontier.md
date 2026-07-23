# The class-\((1,1)\) double-decic frontier

## Status

Let \(X\subset\mathbf P^2_x\times\mathbf P^2_y\) be a general hypersurface
of bidegree \((2,4)\).  This note gives the exact canonical-resolution table
for divisors in \(|H_x+H_y|\), proves the needed low-factor incidence
exclusions, and records the finite frontier subsequently closed by the
companion conic theorems.

This note by itself proves:

1. the smooth double-decic invariants and the exact necessary-and-sufficient
   rationality profiles after every proper and infinitely-near correction;
2. no rank-two or rank-three incidence has a proper branch point of
   multiplicity at least six;
3. no such incidence has a squared line factor; and
4. no such incidence has an integral component of degree one through five.

The companion nested-profile theorem excludes the remaining
\([3,2,2,2]\) case, and the companion six-proper-center theorem excludes the
all-proper part of the other squarefree row.  The quintic-factor theorem
makes every retained reduced decic integral.  The singleton-root and
two-essential-partition theorems exclude the six-root and five-root
partitions.  The uniform six-center conic theorem then classifies every
remaining essential span and excludes all nine root partitions with at most
four proper-origin trees.  Thus the class-\((1,1)\) case is now closed; see
[`k1_uniform_six_center_conic_exclusion.md`](k1_uniform_six_center_conic_exclusion.md).

## 1. The double-decic model

Write

\[
F=x^tA(y)x,
\]

where \(A\) is a symmetric \(3\times3\) matrix of quartic forms.  A section
of \(\mathcal O(1,1)\) is

\[
L_\sigma=\sigma(y)^t x,
\]

where \(\sigma(y)\) is a triple of linear forms, equivalently a projective
\(3\times3\) matrix.  For ranks two and three, the normalized Stein model of
\(W_\sigma=X\cap\{L_\sigma=0\}\) over \(\mathbf P^2_y\) is the connected
double plane with branch

\[
\boxed{
B_\sigma=\sigma^t\operatorname {adj}(A)\sigma,
\qquad \deg B_\sigma=10.}
\tag{1.1}
\]

For rank two, the original projection has one isolated nonfinite point; the
statement concerns its normalized Stein/function-field double plane.

If the branch is smooth, its half-branch is \(5H\), and the standard
double-cover formulas give

\[
\boxed{
(K^2,\chi,p_g,q,P_2)=(8,7,6,0,15).}
\tag{1.2}
\]

Equivalently, adjunction on \(W_\sigma\) gives
\(K_{W_\sigma}=\mathcal O_{W_\sigma}(0,2)\).

Rank one has \(L_\sigma=l(y)h(x)\).  The divisor is the union of a vertical
class-\((0,1)\) component and a horizontal class-\((1,0)\) component.  The
former is irrelevant to the conic-bundle source, and the latter is excluded
by `k0_du_val_exclusion_theorem.md`.

## 2. Canonical resolution and the exact rationality table

Factor the maximal square:

\[
B_\sigma=G^2C,
\qquad e=\deg G,
\qquad \deg C=2m=10-2e,
\]

with \(C\ne0\) reduced.  Resolve the reduced branch canonically.  At each
proper or infinitely-near center, let \(r_i\) be the multiplicity of the
corrected total branch, including the exceptional component when the
preceding multiplicity was odd, and put

\[
t_i=\left\lfloor\frac{r_i}{2}\right\rfloor,
\qquad
D=\sum_i(t_i-1)E_i.
\]

If \(f:Y\to\mathbf P^2\) is the resulting blowup and

\[
\mathcal J_D=f_*\mathcal O_Y(-D),
\qquad
\mathcal J_{2D}=f_*\mathcal O_Y(-2D),
\]

then

\[
\begin{aligned}
\chi(\mathcal O_{\widetilde W})
 &=1+\binom{m-1}{2}-\sum_i\binom{t_i}{2},\\
p_g(\widetilde W)
 &=h^0(\mathcal J_D(m-3)),\\
q(\widetilde W)
 &=p_g+\sum_i\binom{t_i}{2}-\binom{m-1}{2},\\
P_2(\widetilde W)
 &=h^0(\mathcal J_{2D}(2m-6)).
\end{aligned}
\tag{2.1}
\]

The anti-invariant bicanonical summand has plane degree \(m-6<0\) and
vanishes.  The ideals in (2.1) are complete cluster ideals in the
total-transform basis.  They must be unloaded, and in general
\(\mathcal J_{2D}\ne\mathcal J_D^2\).

Castelnuovo's criterion and (2.1) give the following exhaustive table for a
connected normalized double plane.

| \(e\) | \(\deg C\) | exact rationality data |
|---:|---:|---|
| 0 | 10 | \(\sum\binom{t_i}{2}=6\), \(H^0(\mathcal J_D(2))=0\), and \(H^0(\mathcal J_{2D}(4))=0\).  The essential profile is \([4]\), \([3,3]\), \([3,2,2,2]\), or \([2,2,2,2,2,2]\). |
| 1 | 8 | Sum \(3\), with \(H^0(\mathcal J_D(1))=H^0(\mathcal J_{2D}(2))=0\); profile \([3]\) or \([2,2,2]\). |
| 2 | 6 | Exactly one essential \(t=2\); all other centers have \(t=1\). |
| 3 | 4 | Every center has \(t=1\). |
| 4 | 2 | Automatic for a nonzero reduced conic. |

For \(e=5\), the branch is a pure square.  The double algebra splits and
does not give an integral degree-two multisection.  On the smooth threefold,
any putative horizontal component would have odd degree over
\(\mathbf P^2_y\), contradicting \(\operatorname {Pic}(X)=\mathbf ZH_x
\oplus\mathbf ZH_y\) and the even-degree formula for horizontal divisors.

## 3. Proper multiplicity six is absent

Fix a rank-two or rank-three matrix \(\sigma\).  Restriction to
\(Y_\sigma=\{L_\sigma=0\}\) is surjective:

\[
0\to H^0(\mathcal O(1,3))
\xrightarrow{L_\sigma}H^0(\mathcal O(2,4))
\to H^0(Y_\sigma,\mathcal O(2,4))\to0.
\]

The dimensions are \(30,90,60\).  Hence all fixed-\(\sigma\) codimensions
may be computed in the sixty-dimensional restriction space.  The projective
matrix-rank orbits have dimensions

\[
\dim O_3=8,\qquad \dim O_2=7.
\tag{3.1}
\]

For rank three, normalize
\(L_\sigma=x_0y_0+x_1y_1+x_2y_2\).  With
\(E=\Omega^1_{\mathbf P^2}(1)\), the restricted form is a section of

\[
\mathcal Q=\operatorname {Sym}^2(E^\vee)\otimes\mathcal O(4),
\qquad h^0(\mathcal Q)=60.
\]

The symmetric Euler resolution is

\[
0\to V_x^\vee\otimes\mathcal O(3)
\to\operatorname {Sym}^2V_x^\vee\otimes\mathcal O(4)
\to\mathcal Q\to0.
\tag{3.2}
\]

After twisting by \(\mathcal O(-2)\), it gives
\(H^1(\mathcal Q(-2))=0\).  Thus for two distinct lines
\(D=L_1+L_2\) through a fixed point \(p\), restriction to \(D\) is onto.
On either line

\[
\mathcal Q|_L=\mathcal O(6)\oplus\mathcal O(5)\oplus\mathcal O(4).
\]

Therefore \(h^0(\mathcal Q|_D)=18+18-3=33\); the two triples share their
constant symmetric matrix at \(p\).

We use the following elementary contact lemma.  Let \(V_{654}\), respectively
\(V_{444}\), denote triples \((a,b,c)\) of one-variable polynomials of the
indicated degrees, and put \(\det q=ac-b^2\).

1. In either space, \(\operatorname {ord}_0(\det q)\ge6\) has codimension
   at least six.  Conditional on a fixed nonzero rank-one constant matrix,
   the tail codimension is at least five; conditional on the zero matrix, it
   is at least four.
2. In \(V_{444}\), \(\operatorname {ord}_0(\det q)\ge4\) has codimension
   at least four.  The same bound holds after one specified diagonal
   constant is fixed to zero.

Here is the complete jet proof.  A rank-two constant matrix is impossible.
On the nonzero rank-one stratum, whose codimension in
\(\operatorname {Sym}^2(k^2)\) is one, constant congruence for \(V_{444}\)
or the two diagonal orientations for \(V_{654}\) reduce to a unit diagonal
entry.  In the untruncated \(V_{654}\) orientation, the coefficients of
orders one through five solve successively for five coefficients of the
opposite diagonal.  In either \(V_{444}\) orientation, and in the truncated
\(V_{654}\) orientation \(a_0\ne0,\ b_0=c_0=0\), the first four equations
solve the four available opposite-diagonal coefficients and the order-five
equation supplies one more condition.  Explicitly, if
\(\nu=\operatorname {ord}(b)\), then for \(\nu=1\) this last equation is a
genuine tail equation; for \(\nu=2\), the condition \(b_1=0\) and the
order-five equation give the needed excess; and for \(\nu\ge3\), the two
conditions \(b_1=b_2=0\) already replace it.  Thus every truncated stratum
still has tail codimension at least five.

If the constant matrix is zero, factor \(q=tq_1\).  The remaining order-four
condition has codimension at least four: over a rank-one constant of \(q_1\)
there is one determinant condition and three successive tail equations;
over \(q_1(0)=0\), three constants vanish and the factored order-two
determinant condition has codimension at least two.  Stopping the same
argument after four coefficients proves assertion 2.  This includes every
zero-jet and truncated-degree stratum.

For two restrictions with the same constant matrix, stratifying by its rank
therefore gives codimension

\[
\min\{1+5+5,\ 3+4+4\}=11.
\tag{3.3}
\]

A fixed rank-three \(\sigma\) and fixed \(p\) thus impose codimension at
least eleven.  Allowing \(p\) to move costs two, leaving nine; by (3.1),
\(9>8\), so this incidence cannot dominate the equation space.

For rank two, normalize
\(L_\sigma=x_0y_0+x_1y_1\), with base point \(b=[0:0:1]\).  Away from
\(b\), the stabilizer is transitive.  At \(p=[1:0:0]\), use
\(u=y_1/y_0,\ v=y_2/y_0\) and eliminate \(x_0=-ux_1\).  On the \(u\)-axis
the quadratic has degrees \((6,5,4)\); on the \(v\)-axis it has degrees
\((4,4,4)\).  The map from the sixty-dimensional restriction space onto
the fiber product of these triples over their common constant matrix is
surjective.  Indeed, \(A_{11},A_{12},A_{22}\) prescribe arbitrary quartic
triples on the two axes with shared constants, while
\(u^2A_{00}-2uA_{01}\) supplies the two extra degree-six coefficients and
\(-uA_{02}\) the extra degree-five coefficient.  The target dimension is
\(18+15-3=30\).  Equation (3.3) again gives moving-point codimension nine,
which is larger than seven.

At \(b\), put \(y_2=1\) and write \(u=y_0,v=y_1\).  Then

\[
B=u^2C_{00}+2uvC_{01}+v^2C_{11}.
\]

If \(\operatorname {mult}_b(B)\ge6\), necessarily

\[
\operatorname {ord}_u C_{00}(u,0)\ge4,\qquad
\operatorname {ord}_v C_{11}(0,v)\ge4.
\tag{3.4}
\]

These are order-four determinant conditions for the two quartic triples
\((A_{11},A_{12},A_{22})|_{v=0}\) and
\((A_{00},A_{02},A_{22})|_{u=0}\).  Their coefficient map is onto the
product with the single shared scalar \(A_{22}(b)\), a space of dimension
\(15+15-1=29\).  If that scalar is nonzero, four determinant coefficients
on each axis solve successively in the other diagonal, giving codimension
eight.  If it is zero, fixing it costs one and the contact lemma gives
conditional codimension at least four for each triple, hence total
codimension at least nine.  The minimum is eight.  The point \(b\) is fixed
by \(\sigma\), so \(8>7\) excludes the base-point incidence.

Consequently a general \(A\) has no rank-two or rank-three \(\sigma\) for
which \(B_\sigma\) has a proper point of multiplicity at least six.
The squarefree consequences must respect proximity: \([4]\) and \([3,3]\)
are removed; \([3,2,2,2]\) is removed when its \(t=3\) center is proper,
while a nonproper \(t=3\) center can only follow an earlier essential
\(t=2\) ancestor and is not excluded by the proper-point theorem alone.
It is excluded by the separate two-line incidence theorem
[`k1_nested_profile_exclusion.md`](k1_nested_profile_exclusion.md).

## 4. Squared lines and conic factors are absent

### 4.1 Squared lines

For rank three, (3.2) and \(H^1(\mathcal Q(-2))=0\) make restriction to
every doubled line surjective.  Choosing a normal coordinate \(z\), write

\[
q=q_0+zq_1\pmod {z^2},
\qquad
q_0:(6,5,4),\quad q_1:(5,4,3).
\]

The double-line data space has dimension \(18+15=33\), and
\(L^2\mid\det(q)\) is equivalent to

\[
\det q_0=0,\qquad
\langle\operatorname {adj}(q_0),q_1\rangle=0.
\tag{4.1}
\]

The determinant-zero cone for \(q_0\) has dimension at most seven.  Its
nonboundary points have the UFD form

\[
(a,b,c)=h(u^2,uv,v^2),
\]

where

\[
\deg v=r,\qquad \deg u=r+1,\qquad \deg h=4-2r,
\qquad r=0,1,2.
\]

Every such affine family has dimension seven.  The diagonal boundaries
\((a,0,0),(0,0,c),0\) have dimensions seven, five, and zero.  On a
nonboundary family the linear map in \(q_1\) has rank at least six
(multiplication by the nonzero \(v^2\) already injects the six-dimensional
\(\alpha\)-space).  On the three boundaries its ranks are four, six, and
zero.  The solution-stratum dimensions are therefore at most

\[
7+(15-6)=16,\quad
7+(15-4)=18,\quad
5+(15-6)=14,\quad
15.
\]

The maximum is eighteen.  A fixed line has codimension at least
\(33-18=15\); after the line moves, \(15-2=13>8\).

For rank two and a line avoiding \(b\), restriction is again onto the same
thirty-three-dimensional data.  On \(Y_\sigma\), use

\[
0\to\mathcal O_Y(2,2)\to\mathcal O_Y(2,4)
\to\mathcal O_{Y|2L}(2,4)\to0;
\]

the ambient hypersurface sequence gives
\(H^1(Y,\mathcal O_Y(2,2))=0\).  Thus the same margin thirteen applies.

If \(L\) passes through \(b\), normalize \(L=\{y_1=0\}\).  Put
\(a=A_{11}|_L,\ b_1=A_{12}|_L,\ c=A_{22}|_L\), let
\(\alpha,\beta,\gamma\) be their first normal derivatives, and put
\(r=A_{01}|_L,\ s=A_{02}|_L\).  The first triple consists of quartics, the
derivative triple of cubics, and \(r,s\) of quartics.  These
\(15+12+10=37\) coefficients are independent images of \(A\).  The two
equations are

\[
ac-b_1^2=0,
\]

\[
\Phi=y_0(c\alpha+a\gamma-2b_1\beta)+2(sb_1-rc)=0.
\tag{4.2}
\]

The determinant-zero quartic triple has nonboundary UFD families of
dimension six and diagonal boundaries of dimensions five, five, and zero.
On every nonboundary family the \(r\)-term has rank at least five; on
\((a,0,0)\) the \(\gamma\)-term has rank four; on \((0,0,c)\) the
\(r\)-term has rank five; at zero (4.2) vanishes.  Since the auxiliary
space has dimension twenty-two, the total dimensions are at most

\[
6+(22-5)=23,\quad
5+(22-4)=23,\quad
5+(22-5)=22,\quad
22.
\]

Thus a fixed line through \(b\) has codimension \(37-23=14\); the pencil
of such lines leaves \(14-1=13>7\).  The two line positions are exhaustive,
so no squared-line factor occurs.

### 4.2 Irreducible conics

For a smooth conic \(C\), identify its normalization with \(\mathbf P^1\),
so \(\mathcal O_C(1)=\mathcal O(2)\).  In rank three,

\[
E^\vee|_C=\mathcal O(1)\oplus\mathcal O(1),
\qquad
\mathcal Q|_C=\mathcal O(10)^3.
\]

Restriction is onto by \(H^1(\mathcal Q(-2))=0\).  In rank two away from
\(b\), the resolved kernel dual is \(\mathcal O(2)\oplus\mathcal O\),
giving pattern \((12,10,8)\); restriction is onto by the same
\(H^1(Y,\mathcal O_Y(2,2))=0\) calculation.  If \(C\) passes through
\(b\), \(y_0|_C,y_1|_C\) have one common linear factor.  Removing it gives
kernel dual \(\mathcal O(1)\oplus\mathcal O\) and pattern \((10,9,8)\).
Direct multiplication is onto:

\[
H^0(\mathcal O(8))H^0(\mathcal O(2))=H^0(\mathcal O(10)),
\quad
H^0(\mathcal O(8))H^0(\mathcal O(1))=H^0(\mathcal O(9)),
\]

and the final entry is \(H^0(\mathcal O(8))\).  Moreover
\(B|_C=s^2\det(q_C)\), so \(C\mid B\) is exactly
\(\det(q_C)=0\); no condition is lost at the base point.

For a triple of binary forms satisfying \(ac=b^2\), UFD factorization plus
the diagonal boundaries gives the exhaustive table

\[
\begin{array}{c|c|c|c|c|c}
\text{rank/position}&\text{degrees}&\dim V&
\max\dim\{ac=b^2\}&\dim\{C\}&\text{moving codim}\\ \hline
3&(10,10,10)&33&12&5&16\\
2,\ b\notin C&(12,10,8)&33&13&5&15\\
2,\ b\in C&(10,9,8)&30&11&4&15.
\end{array}
\tag{4.3}
\]

In the nonboundary locus, degree comparison in
\((a,b,c)=h(u^2,uv,v^2)\) gives dimensions \(12,12,11\) in the three
rows.  The longest diagonal boundaries have dimensions \(11,13,11\),
respectively, producing the displayed maxima.  Thus \(16>8\) in rank three
and \(15>7\) in both rank-two cases.  No irreducible conic divides
\(B_\sigma\) for a general \(A\).  Reducible conics have a line component,
while a doubled conic is a doubled line, so the squared-line result handles
their square-factor applications.

These are characteristic-zero dimension arguments.  They are the quartic
degree shifts of the complete UFD proofs in Problem B's
[proper-sixfold](../../B-conic-bundle-multisections/certificates/k1_work/proper_sixfold_theorem.md),
[squared-line](../../B-conic-bundle-multisections/certificates/k1_work/square_line_theorem.md),
and
[conic-factor](../../B-conic-bundle-multisections/certificates/k1_work/conic_factor_theorem.md)
theorems; the degree patterns and margins above are the only changed
numerical inputs.

## 5. Cubic and quartic factors are absent

The remaining factor exclusions use one uniform rank-one-cone estimate.
Let \(T\) be a smooth projective curve, let \(\mathscr F\) be a globally
generated rank-two bundle of degree \(f\), and let \(N\) be a line bundle of
degree \(n\).  If a nonzero

\[
q\in H^0(T,\operatorname {Sym}^2\mathscr F\otimes N)
\]

has zero determinant, its generic image saturates to a line subbundle
\(M\subset\mathscr F\).  If \(m=\deg M\), then

\[
q\in H^0(T,M^2\otimes N).
\]

The local dimension of the family of such saturated inclusions is at most
the Quot tangent dimension

\[
h^0((\mathscr F/M)\otimes M^{-1}).
\]

The quotient is globally generated, so \(m\le f\); the nonzero scalar
section forces \(2m+n\ge0\).  Since
\(h^0(L)\le\max\{\deg L+1,0\}\) for a line bundle on a smooth curve, the
affine rank-one cone has dimension at most

\[
\boxed{
R(f,n)=
\max_{\lceil-n/2\rceil\le m\le f}
\bigl(
\max\{f-2m+1,0\}+\max\{2m+n+1,0\}
\bigr).}
\tag{5.1}
\]

The values used below are

\[
\begin{array}{c|ccc}
(f,n)&(3,12)&(2,12)&(1,12)\\ \hline
R(f,n)&19&17&15
\end{array},
\qquad
\begin{array}{c|cccc}
(f,n)&(4,16)&(3,16)&(2,16)&(1,16)\\ \hline
R(f,n)&25&23&21&19.
\end{array}
\tag{5.2}
\]

The same bound applies after pulling a quadratic form on an integral plane
curve to its normalization.  Pullback is injective on global sections, and
the estimate deliberately uses only degree and global generation, not the
genus.

### 5.1 Integral cubic factors

For rank three, set

\[
\mathcal Q=\operatorname {Sym}^2(E^\vee)\otimes\mathcal O(4),
\qquad E=\Omega^1_{\mathbf P^2}(1).
\]

The symmetric Euler resolution is

\[
0\longrightarrow V_x^\vee\otimes\mathcal O(3)
\longrightarrow\operatorname {Sym}^2V_x^\vee\otimes\mathcal O(4)
\longrightarrow\mathcal Q\longrightarrow0.
\tag{5.3}
\]

Thus \(h^0(\mathcal Q)=60\).  If \(D\) is an integral cubic, twisting
(5.3) by \(\mathcal O(-3)\) gives

\[
0\longrightarrow3\mathcal O
\longrightarrow6\mathcal O(1)
\longrightarrow\mathcal Q(-3)\longrightarrow0,
\]

so \(h^0(\mathcal Q(-3))=15\), \(H^1(\mathcal Q(-3))=0\), and restriction
to \(D\) has image rank \(45\).  On the normalization,
\(\deg(E^\vee|_D)=3\) and \(\deg\mathcal O_D(4)=12\).  Equations
(5.1)--(5.2) bound the determinant-zero part of this image by \(19\)
dimensions.  Integral cubics move in \(\mathbf P^9\), leaving fixed-\(\sigma\)
codimension at least

\[
45-19-9=17>8=\dim O_3.
\tag{5.4}
\]

For rank two, write \(b\) for the base point of \(\sigma\).  If \(b\notin D\),
the kernel on the restricted incidence has dimension

\[
h^0(\mathcal O_Y(2,1))
=h^0(\mathcal O(2,1))-h^0(\mathcal O(1,0))
=18-3=15,
\]

and the same \(45\)-dimensional image and bound (5.4) apply.

If \(b\in D\), work on \(Z=\operatorname {Bl}_b\mathbf P^2\), write \(H\)
for the pullback of a line, \(E_b\) for the exceptional curve, and
\(R=H-E_b\).  The resolved kernel is
\(\mathcal O\oplus\mathcal O(-R)\), so the complete quadratic-form space is

\[
H^0(\mathcal O(6H-2E_b))\oplus
H^0(\mathcal O(5H-E_b))\oplus H^0(\mathcal O(4H)),
\tag{5.5}
\]

of dimension \(25+20+15=60\).  It is genuinely the complete space:
the three groups of coefficients of \(A\) generate respectively
\((y_0,y_1)^2H^0(\mathcal O(4))\),
\((y_0,y_1)H^0(\mathcal O(4))\), and
\(H^0(\mathcal O(4))\).

If \(D\) is smooth at \(b\), its strict transform is \(3H-E_b\).
The spaces in (5.5) vanishing on it have dimensions

\[
h^0(3H-E_b)+h^0(2H)+h^0(H+E_b)=9+6+3=18.
\]

Hence the restriction image has rank \(42\), while
\(\deg(\mathcal O(R)|_{\widetilde D})=2\).  Cubics through \(b\) move in
dimension eight, and the remaining codimension is

\[
42-R(2,12)-8=17>7=\dim O_2.
\tag{5.6}
\]

If \(D\) is singular at \(b\), it has multiplicity two and strict transform
\(3H-2E_b\).  The corresponding kernel dimensions are

\[
h^0(3H)+h^0(2H+E_b)+h^0(H+2E_b)=10+6+3=19.
\]

The image rank is \(41\), the normalized kernel dual has degree one, and
such cubics form a six-dimensional family.  Thus

\[
41-R(1,12)-6=20>7.
\tag{5.7}
\]

This exhausts integral cubics: multiplicity three at a point would make a
plane cubic a reducible cone.

### 5.2 Integral quartic factors

For rank three, twisting (5.3) by \(\mathcal O(-4)\) gives

\[
0\longrightarrow3\mathcal O(-1)
\longrightarrow6\mathcal O
\longrightarrow\mathcal Q(-4)\longrightarrow0.
\]

Thus \(h^0(\mathcal Q(-4))=6\), \(H^1(\mathcal Q(-4))=0\), and the
restriction image on an integral quartic has rank \(54\).  On its
normalization \(f=4,n=16\), so the rank-one part has dimension at most
\(25\).  Quartics move in \(\mathbf P^{14}\), and

\[
54-R(4,16)-14=15>8.
\tag{5.8}
\]

For rank two away from \(b\), the restriction kernel is
\(\mathcal O_Y(2,0)\), with

\[
h^0(\mathcal O_Y(2,0))
=h^0(\mathcal O(2,0))-h^0(\mathcal O(1,-1))=6.
\]

Hence the same rank \(54\) and margin (5.8) apply.  If the quartic has
multiplicity \(\mu=1,2,3\) at \(b\), subtracting its strict transform
\(4H-\mu E_b\) from the three summands in (5.5) gives

\[
\begin{array}{c|c|c|c|c}
\mu&\text{kernel }h^0\text{ dimensions}&
\text{image rank}&R(4-\mu,16)&
\dim\{\text{quartics of multiplicity }\ge\mu\}\\ \hline
1&5+3+1&51&23&13\\
2&6+3+1&50&21&11\\
3&6+3+1&50&19&8.
\end{array}
\]

The resulting fixed-\(\sigma\) codimensions are respectively

\[
51-23-13=15,\qquad
50-21-11=18,\qquad
50-19-8=23,
\tag{5.9}
\]

all larger than seven.  An integral quartic cannot have multiplicity four:
such a quartic is a reducible cone.

For every integral strict transform used above,
\(H^0(\widetilde D,L|_{\widetilde D})\) injects into the corresponding
space on the normalization.  Thus singular cubics and quartics do not cause
the computed restriction-image ranks to drop.  A reducible cubic has a line
or integral-conic component; a reducible quartic has a line, integral-conic,
or integral-cubic component.  The squared-line theorem and the degree-two,
three, and four factor exclusions therefore remove every square-factor row.

## 6. Exact surviving frontier

The factor exclusions remove every row with \(e\ge1\).  The proper-sixfold
theorem removes the squarefree rows exactly to the extent stated in
Section 3.

The nested \([3,2,2,2]\) profile is absent.  Its unique local numerical
possibility is a proper corrected quintuple followed by a free first-near
corrected sextuple,

\[
(r_p,r_q;m_p,m_q)=(5,6;5,5).
\]

Restriction to its tangent and a transverse line leaves fixed-\(\sigma\)
codimension nine after the local configuration moves, larger than both
matrix-rank orbit dimensions.  The complete proof is in
[`k1_nested_profile_exclusion.md`](k1_nested_profile_exclusion.md).

The sole intermediate possibility is therefore a squarefree decic with six
essential \(t=2\) centers whose complete cluster systems satisfy

\[
H^0(\mathcal J_D(2))=0,\qquad
H^0(\mathcal J_{2D}(4))=0.
\]

Its branch has no integral component of degree one through five and is
therefore integral.
Sections 4--5 treat degrees two through four.  The line-factor incidence,
together with the exclusion of the all-proper six-center subrow, is proved in
[`k1_six_proper_centers_exclusion.md`](k1_six_proper_centers_exclusion.md).
The degree-five factor exclusion is
[`k1_quintic_factor_exclusion.md`](k1_quintic_factor_exclusion.md).
The stronger
[`k1_singleton_root_exclusion.md`](k1_singleton_root_exclusion.md) excludes
the complete root partition \([1,1,1,1,1,1]\).  The essential-span
classification and conic incidence in
[`k1_two_essential_tree_classification.md`](k1_two_essential_tree_classification.md)
and
[`k1_two_essential_partition_exclusion.md`](k1_two_essential_partition_exclusion.md)
exclude \([2,1,1,1,1]\).  Thus every diagram left at this stage has at most four
proper-origin trees.

The required finite complete Enriques-diagram incidence is carried out in
[`k1_uniform_six_center_conic_exclusion.md`](k1_uniform_six_center_conic_exclusion.md).
It includes predecessor \(t=1\) centers, proximity, both unloadings, every
root partition, and every smooth/nodal rank-two base-point stratum.  Its
fixed-rank codimensions are at least nine in rank three and eight in rank
two, so it excludes every row left above and closes \(k=1\).

The global shortcut audit in
[`k1_repeated_root_frontier.md`](k1_repeated_root_frontier.md) originally
identified \([2,1,1,1,1]\) as the first repeated partition.  It records why
the raw class \(5H-2D\), despite having square one, need not be the mobile
class after unloading, and why the tempting global curve-dimension count
still requires an unproved jet-independence theorem.  The direct partition
theorems and the later uniform conic theorem bypass that missing global
independence statement.

The arithmetic table and all displayed dimension margins are replayed by
`k1_double_decic_frontier_checks.py`.
