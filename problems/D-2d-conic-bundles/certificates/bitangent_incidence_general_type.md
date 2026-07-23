# The quartic bitangent incidence is of general type

## Statement

Let

\[
X=\{F(x,y)=0\}\subset\mathbf P^2_x\times\mathbf P^2_y
\]

be a general hypersurface of bidegree \((2,4)\).  Let \(Y=(\mathbf
P^2_y)^\vee\) be the plane of lines in \(\mathbf P^2_y\).  The bitangent
surface parametrizes triples \((x,\ell,[q])\) for which

\[
F(x,-)|_\ell\quad\text{is projectively equal to}\quad q^2,
\]

where \(q\) is a nonzero binary quadratic on \(\ell\).  For a smooth
quartic fiber this is the usual set of its twenty-eight bitangent lines,
with a hyperflex counted by a quadratic having a double root.

For a general \(F\), the bitangent surface \(B_F\) is smooth and

\[
K_{B_F}\equiv4(H+J),
\qquad
K_{B_F}^2=1728,
\]

where \(H\) and \(J\) are pulled back from \(\mathbf P^2_x\) and \(Y\).
In particular, every connected component of \(B_F\) has ample canonical
class.

Marking one of the two roots of \(q\) gives a finite degree-two incidence
\(M_F\to B_F\) and a natural map \(M_F\to X\).  Every component of the
normalization of \(M_F\) that dominates a component of \(B_F\) is again of
general type.  Thus the bitangent-point correspondence cannot supply the
rational surface required by the conic-bundle base-change argument.

## 1. The relative square-quartic surface

On \(Y\), let \(\mathcal K\) be the universal rank-two subbundle:

\[
0\longrightarrow\mathcal K\longrightarrow
V_y\otimes\mathcal O_Y\longrightarrow\mathcal O_Y(1)
\longrightarrow0.
\]

Put

\[
\mathcal E=\operatorname {Sym}^4\mathcal K^*,
\qquad
\mathcal G=\operatorname {Sym}^2\mathcal K^*.
\]

We use the lines convention for projective bundles.  Squaring binary
quadratics gives a closed immersion

\[
v:\mathbf P_Y(\mathcal G)\hookrightarrow\mathbf P_Y(\mathcal E).
\tag{1.1}
\]

Fiberwise this is the smooth projected Veronese surface in \(\mathbf P^4\).
It is an embedding: if two binary quadratics have proportional squares, they
are proportional, and the differential of squaring has no projective kernel.

Let \(H=c_1\mathcal O_{\mathbf P^2_x}(1)\) and
\(J=c_1\mathcal O_Y(1)\).  Restriction of \(F\) to the universal line is a
section of

\[
\mathcal O_{\mathbf P^2_x}(2)\boxtimes\mathcal E.
\]

For a general \(F\), it is nowhere zero.  Indeed, at fixed \((x,\ell)\),
the condition \(F_x|_\ell=0\) imposes five independent linear conditions on
\(F\), while \((x,\ell)\) varies in dimension four.  The corresponding
proper incidence cannot dominate the equation space.

The section therefore defines

\[
s_F:\mathbf P^2_x\times Y\longrightarrow\mathbf P_Y(\mathcal E),
\]

and

\[
B_F=s_F^{-1}\bigl(v(\mathbf P_Y(\mathcal G))\bigr).
\tag{1.2}
\]

At every \((x,\ell)\), variation of \(F\) gives an arbitrary binary quartic
on \(\ell\): choose a quadric nonzero at \(x\), then use the surjection from
plane quartics to binary quartics on \(\ell\).  The universal map is thus a
submersion in the parameter directions.  Parametric transversality makes
(1.2) a smooth codimension-two pullback for a general \(F\).
For a general \(x\), the fiber \(C_x\) is a smooth plane quartic and has the
classical twenty-eight bitangents.  Thus \(B_F\) is nonempty and dominates
\(\mathbf P^2_x\).  No connectedness assertion is needed below; every smooth
component has the same ample-canonical conclusion.

## 2. Canonical class

Put

\[
\xi=c_1\mathcal O_{\mathbf P(\mathcal E)}(1),
\qquad
\eta=c_1\mathcal O_{\mathbf P(\mathcal G)}(1).
\]

The square embedding satisfies \(v^*\xi=2\eta\), while the section defined
by \(F\) satisfies \(s_F^*\xi=2H\).  Hence on \(B_F\)

\[
2\eta=2H,
\qquad
\eta\equiv H
\tag{2.1}
\]

numerically.

From the universal-subbundle sequence,

\[
c_1(\mathcal E)=10J,
\qquad
c_1(\mathcal G)=3J.
\]

For the lines convention,

\[
K_{\mathbf P(\mathcal E)/Y}=-5\xi+c_1(\mathcal E^*),
\qquad
K_{\mathbf P(\mathcal G)/Y}=-3\eta+c_1(\mathcal G^*).
\]

Relative adjunction for (1.1) gives

\[
c_1\bigl(\det N_v\bigr)
=K_{\mathbf P(\mathcal G)/Y}-v^*K_{\mathbf P(\mathcal E)/Y}
=7\eta+7J.
\tag{2.2}
\]

The normal bundle of the transverse inverse image (1.2) is the pullback of
\(N_v\).  Since

\[
K_{\mathbf P^2_x\times Y}=-3H-3J,
\]

adjunction and (2.1)--(2.2) give

\[
K_{B_F}=-3H+4J+7\eta
\equiv4H+4J.
\tag{2.3}
\]

The restriction of \(H+J\) is ample.  Ampleness is numerical, so (2.3)
proves that \(K_{B_F}\) is ample on every component.

## 3. Class and numerical checks

The following computation also recovers the number twenty-eight.  The
relative square surface has class

\[
[v(\mathbf P(\mathcal G))]
=4\xi^2+16\xi J+28J^2
\tag{3.1}
\]

in \(A^2(\mathbf P_Y(\mathcal E))\).  Pulling back by \(s_F\) gives

\[
\boxed{
[B_F]=16H^2+32HJ+28J^2.}
\tag{3.2}
\]

The coefficient of \(J^2\) shows that \(B_F\to\mathbf P^2_x\) has generic
degree \(28\).  Equations (2.3) and (3.2) give

\[
K_{B_F}^2
=16(H+J)^2[B_F]
=16(16+64+28)
=1728.
\]

As a consistency check, for the inverse image \(C\) of a general line in
\(\mathbf P^2_x\),

\[
C^2=28,
\qquad
K_{B_F}C=240,
\qquad
g(C)=135.
\]

This agrees with the classical monodromy count: a nodal degeneration acts
on the twenty-eight odd theta characteristics with sixteen fixed points and
six transpositions, so a general degree-54 discriminant slice contributes
\(54\cdot6=324\) simple ramification points and Riemann--Hurwitz gives
\(g=135\).  The monodromy check is not needed for the proof.

The Chern and intersection arithmetic in this section is reproduced by
`bitangent_incidence_invariants.py`.

## 4. Marking a bitangency point

Over \(B_F\), the universal quadratic \(q\) is nonzero on its universal
line.  Its zero scheme

\[
M_F=\{(b,r):r\in\ell_b,\ q_b(r)=0\}
\]

is finite flat of degree two over \(B_F\), including at a double root.  Since
\(F_x|_\ell=q^2\), every such root lies on \(C_x\), giving a natural map
\(M_F\to X\).

Kodaira dimension does not decrease under a dominant generically finite map
in characteristic zero.  Thus every normalization component of \(M_F\)
dominating a component of \(B_F\) has Kodaira dimension two.  None is
rational or rationally dominated.  This closes the bitangent entry of the
non-tangent covariant zoo, but it does not address the Hessian, osculating,
or iterated correspondences.
