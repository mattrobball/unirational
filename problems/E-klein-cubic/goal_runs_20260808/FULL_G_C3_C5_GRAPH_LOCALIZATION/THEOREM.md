# `C3` and `C5` fixed-graph localization imposes no degree congruence

**Date:** 2026-08-08

**Field:** \(\mathbf C\)

**Group:** \(G=\operatorname {PSL}_2(\mathbf F_{11})\)

**Verdict:** the exact normalizer-coupled fixed-point pushforward equations are
formally soluble for every degree residue modulo three and modulo five

Let \(X\) be the Klein cubic threefold and suppose, only to derive necessary
cycle-class conditions, that

\[
 \varphi:X\dashrightarrow X
\]

is a dominant `G`-equivariant rational selfmap of degree \(\delta>0\).  For
the closure \(\Gamma\subset X\times X\) of its graph,

\[
 (\operatorname {pr}_1)_*[\Gamma]=[X],\qquad
 (\operatorname {pr}_2)_*[\Gamma]=\delta[X].
 \tag{0.1}
\]

This packet computes (0.1) after restriction to `C3` and `C5` fixed points,
including the full normalizer action.  All coefficients below are formal
equivariant-Chow restrictions.  They are not asserted to come from an
effective irreducible graph.

## 1. A normalization common to both primes

Let \(P=C_p\), let \(t=c_1(\chi)\), and write

\[
 e_x=e(T_xX)/t^3\in\mathbf F_p^*.
\]

At a pair of isolated fixed points put

\[
 i_{x,y}^*[\Gamma]=c_{xy}t^3,
 \qquad m_{xy}=c_{xy}/e_y.
 \tag{1.1}
\]

Fixed-point pushforward along the two projections gives

\[
 \boxed{\quad
   \sum_y m_{xy}=1,
   \qquad
   e_y\sum_x\frac{m_{xy}}{e_x}=\delta.
 \quad}
 \tag{1.2}
\]

If a normalizer element inverts \(P\), then it sends \(t\) to \(-t\), and
both \(c_{xy}\) and \(e_y\) change sign.  Therefore the normalized matrix
\(m\), rather than \(c\), is an ordinary invariant matrix for the diagonal
normalizer action.

For mixed intersections

\[
 a_b=\int_\Gamma H_1^{3-b}H_2^b,
 \qquad 0\le b\le3,
 \tag{1.3}
\]

the same normalization gives

\[
 a_b\equiv
 \sum_{x,y}\frac{h_x^{3-b}h_y^b}{e_x}m_{xy}\pmod p,
 \qquad H|_x=h_xt.
 \tag{1.4}
\]

## 2. The six `C3` fixed points

For a generator of \(P=C_3\),

\[
 W=L_0\oplus U_1\oplus U_2,
 \qquad (\dim L_0,\dim U_1,\dim U_2)=(1,2,2).
 \tag{2.1}
\]

The invariant point \(\mathbf P(L_0)\) is off \(X\).  Each eigenline
\(\mathbf P(U_i)\) meets \(X\) transversally in three reduced points.  Thus
\(X^P\) has six points: two have exact stabilizer `C6` and four have exact
stabilizer `C3`.

At a point of \(X\cap\mathbf P(U_1)\), the ambient tangent weights are
\(0,2,1,1\).  Transversality removes the zero weight, so

\[
 T_xX=(2,1,1),\qquad e_x=2,qquad h_x=-1=2.
 \tag{2.2}
\]

On \(\mathbf P(U_2)\), cyclically,

\[
 T_xX=(1,2,2),\qquad e_x=1,qquad h_x=-2=1.
 \tag{2.3}
\]

In particular \(h_x=e_x\) at all six points.

The exact normalizer quotient is

\[
 Q=N_G(P)/P\cong V_4.
 \tag{2.4}
\]

Let \(\alpha:Q\to\mathbf F_2\) be its nontrivial action on `C3` by
inversion.  The two `C6` points form \(A=Q/\ker\alpha\), while the four
exact-`C3` points form the regular orbit \(B=Q\).  Label

\[
 Q=\{(a,b):a,b\in\mathbf F_2\},\qquad
 e(A_a)=e(B_{a,b})=(-1)^a.
 \tag{2.5}
\]

There are ten diagonal `Q`-orbitals.  In the following order, let their
matrix coefficients be \(u_0,\ldots,u_9\):

\[
\begin{array}{c|cccccccccc}
 r&0&1&2&3&4&5&6&7&8&9\\ \hline
 \text{representative}
 &(A_0,A_0)&(A_0,A_1)&(A_0,B_{00})&(A_0,B_{10})
 &(B_{00},A_0)&(B_{00},A_1)&(B_{00},B_{00})
 &(B_{00},B_{01})&(B_{00},B_{10})&(B_{00},B_{11}).
\end{array}
 \tag{2.6}
\]

Equations (1.2) reduce exactly to

\[
\begin{aligned}
 u_0+u_1+2u_2+2u_3&=1,\\
 u_4+u_5+u_6+u_7+u_8+u_9&=1,\\
 u_0+2u_1+2u_4+u_5&=\delta,\\
 u_2+2u_3+u_6+u_7+2u_8+2u_9&=\delta
\end{aligned}
\qquad\text{in }\mathbf F_3.
 \tag{2.7}
\]

### Theorem 2.1: formal surjectivity modulo three

For the three degree residues, (2.7) has the following two-orbital solutions:

\[
\begin{array}{c|c}
 \delta\bmod3&(u_0,\ldots,u_9)\\ \hline
 0&(0,0,0,2,0,0,0,0,0,1)\\
 1&(0,0,0,2,0,1,0,0,0,0)\\
 2&(0,0,2,0,1,0,0,0,0,0).
\end{array}
 \tag{2.8}
\]

For every row in (2.8), formula (1.4) gives

\[
 (a_0,a_1,a_2,a_3)\equiv(0,0,0,0)\pmod3.
 \tag{2.9}
\]

This includes the graph-specific condition \(a_1=3d\equiv0\pmod3\), not
merely the two projection equations.  Hence `C3` localization eliminates no
degree residue.

Every point in \(X^{C_3}\) determines its unique `C3` subgroup: an exact
`C3` point has that stabilizer, and a `C6` point lies in the unique index-two
cyclic overgroup of its unique `C3`.  Consequently transporting (2.8) over
`G` creates no overlap equation between distinct Sylow-three presentations.

## 3. The four `C5` fixed points

Choose a generator so that

\[
 W|_{C_5}=\bigoplus_{a=0}^4\chi^a.
 \tag{3.1}
\]

The invariant eigenpoint \(p_0\) is off \(X\), and the four points
\(p_a\), \(a=1,2,3,4\), lie on \(X\).  At \(p_a\), the ambient projective
tangent weights are \(b-a\), \(b\ne a\).  The invariant cubic normal has
weight \(-3a\), so smoothness removes the direction \(b=3a\).  Therefore

\[
 e_a=\prod_{b\in\mathbf F_5\setminus\{a,3a\}}(b-a)
     =2a^{-1},
 \qquad h_a=-a.
 \tag{3.2}
\]

In the order \(a=1,2,3,4\),

\[
 (e_a)=(2,1,4,3).
 \tag{3.3}
\]

As a check,

\[
 \sum_{a=1}^4\frac{(-a)^3}{e_a}=3\pmod5.
 \tag{3.4}
\]

Here \(N_G(C_5)/C_5=C_2\) acts by \(a\mapsto-a\).  Thus

\[
 m_{-a,-b}=m_{ab}.
 \tag{3.5}
\]

Order the eight orbitals as

\[
\begin{array}{c|cccccccc}
 r&0&1&2&3&4&5&6&7\\ \hline
 \text{representative}
 &(1,1)&(1,4)&(1,2)&(1,3)&(2,1)&(2,4)&(2,2)&(2,3),
\end{array}
 \tag{3.6}
\]

and call their coefficients \(v_0,\ldots,v_7\).  Equations (1.2) are

\[
\begin{aligned}
 v_0+v_1+v_2+v_3&=1,\\
 v_4+v_5+v_6+v_7&=1,\\
 v_0+4v_1+2v_4+3v_5&=\delta,\\
 3v_2+2v_3+v_6+4v_7&=\delta
\end{aligned}
\qquad\text{in }\mathbf F_5.
 \tag{3.7}
\]

### Theorem 3.1: formal surjectivity modulo five

Exact sparse solutions of (3.7) for all five residues are:

\[
\begin{array}{c|c|c}
 \delta\bmod5&(v_0,\ldots,v_7)&(a_0,a_1,a_2,a_3)\bmod5\\ \hline
 0&(0,0,0,1,0,0,2,4)&(3,4,0,0)\\
 1&(1,0,0,0,0,0,1,0)&(3,3,3,3)\\
 2&(0,0,0,1,1,0,0,0)&(3,4,2,1)\\
 3&(0,0,1,0,0,1,0,0)&(3,1,2,4)\\
 4&(0,1,0,0,0,0,0,1)&(3,2,3,2).
\end{array}
 \tag{3.8}
\]

The following positive integral lifts satisfy \(a_1=3d\),
\(a_3=3\delta\), and both Khovanskii--Teissier inequalities:

\[
\begin{array}{c|c|c}
 \delta\bmod5&\text{chosen positive }\delta&(a_0,a_1,a_2,a_3)\\ \hline
 0&5&(3,9,15,15)\\
 1&1&(3,3,3,3)\\
 2&2&(3,9,12,6)\\
 3&3&(3,6,12,9)\\
 4&4&(3,12,13,12).
\end{array}
 \tag{3.9}
\]

Thus projection multiplicities, integrality, positivity, and immediate
log-concavity do not turn (3.7) into a degree congruence.

Every point of \(X^{C_5}\) has exact stabilizer `C5`, hence belongs to the
fixed set of a unique Sylow-five subgroup.  Full-`G` transport of (3.8)
therefore adds no overlap equation.

## 4. Simultaneous degree-two counterconfiguration

For \(\delta=2\), the earlier `C11` packet has mixed residues

\[
 (a_0,a_1,a_2,a_3)\equiv(3,4,2,6)\pmod {11}.
 \tag{4.1}
\]

The `C5` row of (3.8) gives \((3,4,2,1)\pmod5\), and (2.9) gives zero
modulo three.  The single positive integral vector

\[
 \boxed{(a_0,a_1,a_2,a_3)=(3,114,57,6)}
 \tag{4.2}
\]

satisfies all three sets of congruences simultaneously.  Moreover

\[
 a_1=3\cdot38,qquad a_3=3\cdot2,qquad
 114^2\ge3\cdot57,qquad 57^2\ge114\cdot6.
 \tag{4.3}
\]

Equations (2.8), (3.8), the `C11` coefficient vector, and (4.2) are a
**simultaneous formal localization counterconfiguration only**.  They do not
define a compatible integral equivariant cycle, much less a graph.

## 5. Exhaustion of cyclic classes

The element orders in `G` are \(2,3,5,6,11\).

* `C11` was treated in `FULL_G_GRAPH_DEGREE_LOCALIZATION` and is formally
  surjective modulo eleven.
* `C3` and `C5` are treated above.
* `C2` has positive-dimensional fixed locus \(E_\sigma\sqcup L_\sigma\), so
  it is not an isolated fixed-point calculation.  The finite `V4` refinement
  already gives a formally soluble parity matrix.
* The two on-\(X\) `C6` fixed points lie in the size-two `C6` orbit inside
  \(X^{C_3}\).  Modulo three they are already included in §2; modulo two the
  tangent Euler class has a zero weight because \(X^{C_2}\) is
  positive-dimensional.  Hence isolated `C6` localization supplies no new
  independent prime equation.

Consequently every cyclic prime-order fixed-graph gate, with full normalizer
coupling, is formally surjective in the degree variable.  This does not prove
that a graph exists.  It proves only that these finite localization equations
cannot establish non-`G`-unirationality.  The headline remains open.

