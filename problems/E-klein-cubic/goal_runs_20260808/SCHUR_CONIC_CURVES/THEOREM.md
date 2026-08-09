# The Schur conic criterion and the first surviving degree

Date: 2026-08-08

## 1. Setup and verdict

Let

\[
G=\operatorname{PSL}_2(\mathbf F_{11})
\]

and let \(T\) be the genuine generic torsor obtained from a generically free
honest linear source. Its field is denoted by \(K\). Let

\[
\beta=\partial(T)\in\operatorname{Br}(K)[2]
\]

be the class of the six-dimensional projective spin representation. The
binding generic-class calculation gives

\[
\operatorname{per}(\beta)=\operatorname{ind}(\beta)=2.
\]

Thus the degree-six central simple algebra belonging to the projective
representation has the form

\[
A_\beta\simeq M_3(D),
\]

where \(D\) is the quaternion division algebra in the class \(\beta\). Put

\[
S=\operatorname{SB}(A_\beta),\qquad C=\operatorname{SB}(D).
\]

Here \(\operatorname{SB}(A)\) parametrizes right ideals of reduced
dimension one. Hence \(\dim S=5\), while \(C\) is the nonsplit conic of
class \(\beta\).

Let \(V_T\) be the twist of the genus-eight \(V_{14}\), and let \(Y_T\) be
the corresponding twist of the Klein cubic. The outcome is:

1. for every proper \(K\)-variety \(Z\),

   \[
   Z(K(S))\ne\varnothing
   \quad\Longleftrightarrow\quad
   \operatorname{Mor}_K(C,Z)\ne\varnothing;
   \]

2. in the present twin situation,

   \[
   V_T(K(S))\ne\varnothing
   \Longleftrightarrow
   \operatorname{Mor}_K(C,V_T)\ne\varnothing
   \Longleftrightarrow
   Y_T(K)\ne\varnothing;
   \]

3. if \(V_T(K)=\varnothing\), any such morphism may be replaced by the
   normalization map of its image. The image is a geometrically integral
   rational curve whose normalization is \(C\), and its anticanonical
   degree is even;
4. anticanonical degree two is impossible for the genuine full-\(G\)
   generic twist: a conic on \(V_T\) canonically produces a line on
   \(Y_T\), contradicting the binding generic no-line theorem;
5. no audited bend-and-break or Abel--Jacobi theorem reduces every higher
   even degree to degree two or four. The first surviving degree is four,
   and all higher even degrees remain genuine headline-equivalent cases.

Thus the conic route gives an exact all-degree reformulation and a genuine
degree-two exclusion, but not a proof of the negative headline.

## 2. Morita--conic criterion

### Theorem 2.1

Let \(K\) be an infinite field, let \(D\) be a quaternion division
algebra, let \(A=M_m(D)\), and put

\[
S_A=\operatorname{SB}(A),\qquad C_D=\operatorname{SB}(D).
\]

For every proper \(K\)-variety \(Z\),

\[
Z(K(S_A))\ne\varnothing
\quad\Longleftrightarrow\quad
\operatorname{Mor}_K(C_D,Z)\ne\varnothing.
\]

For \(m=3\), in particular,

\[
K(S_A)\simeq K(C_D)(t_1,t_2,t_3,t_4).
\]

### Proof

Choose a splitting field and a two-dimensional splitting space \(W\) for
\(D\). The algebra \(A=M_m(D)\) may be represented by the diagonal
projective cocycle on \(W^{\oplus m}\). Over the splitting field,

\[
C_D\simeq\mathbf P(W),\qquad
S_A\simeq\mathbf P(W^{\oplus m}).
\]

On the open locus where the first \(W\)-coordinate is nonzero, projection
to that coordinate is

\[
[w_1:\cdots:w_m]\longmapsto[w_1].
\]

Its fibre over the line \(L=Kw_1\) is

\[
\operatorname{Hom}(L,W)^{\oplus(m-1)},
\]

so this open is the total space of a vector bundle of rank \(2(m-1)\) on
\(\mathbf P(W)\). The construction is equivariant for the projective
cocycle: scalar changes in a lift cancel in the conjugation action on the
Hom bundles. It therefore descends to a dense open vector bundle

\[
U\longrightarrow C_D
\]

inside \(S_A\). Consequently

\[
K(S_A)=K(C_D)(t_1,\ldots,t_{2m-2}).
\]

Set \(F=K(C_D)\). An \(F(t_1,\ldots,t_r)\)-point of \(Z\) is a rational
map from \(\mathbf A_F^r\) to \(Z\), defined on a nonempty open subset.
Since \(F\) is infinite, that open subset has an \(F\)-point. Specializing
there gives an \(F\)-point of \(Z\). The converse follows by scalar
extension. Hence

\[
Z(K(S_A))\ne\varnothing
\quad\Longleftrightarrow\quad
Z(K(C_D))\ne\varnothing.
\]

An element of \(Z(K(C_D))\) is a rational map
\(C_D\dashrightarrow Z\). Because \(C_D\) is a regular curve and \(Z\) is
proper, the valuative criterion extends it across every missing closed
point. This proves the theorem. \(\square\)

The properness hypothesis is essential only for the final extension from
a rational map on \(C_D\) to a morphism.

## 3. Removing multiple covers and the Brauer formula

### Proposition 3.1

Let \(Z\) be a proper \(K\)-variety with \(Z(K)=\varnothing\), and suppose
\(f:C\to Z\) is a \(K\)-morphism. Let \(B\subset Z\) be its reduced image
and let \(Q\to B\) be the normalization. Then:

1. \(B\) is a geometrically integral curve and \(Q\) is a genus-zero
   curve;
2. \(f\) factors as

   \[
   C\longrightarrow Q\longrightarrow B
   \]

   with the first map finite of some degree \(e\ge1\);
3. if \(\alpha(Q)\in\operatorname{Br}(K)[2]\) denotes the conic class of
   \(Q\), then

   \[
   \boxed{\alpha(Q)=e\beta};
   \]

4. \(e\) is odd, \(\alpha(Q)=\beta\), and \(Q\simeq C\).

Consequently the original multiple cover can be discarded: the
normalization map \(C\simeq Q\to B\subset Z\) is again defined over \(K\).

### Proof

The morphism cannot be constant: a constant \(K\)-morphism from the
geometrically connected proper curve \(C\) has a \(K\)-rational image.
The image is therefore a curve. Properness and geometric integrality of
\(C\) imply geometric integrality of its reduced image. Normality of \(C\)
gives the factorization through \(Q\), and a nonconstant map of proper
curves is finite. After base change to an algebraic closure,
Riemann--Hurwitz for \(\mathbf P^1\to Q_{\bar K}\) shows that
\(Q_{\bar K}\simeq\mathbf P^1\).

Let \(\delta_C,\delta_Q\) be the Hochschild--Serre boundary maps from the
geometric Picard groups to \(\operatorname{Br}(K)\). Pullback by the
degree-\(e\) map is multiplication by \(e\) on
\(\operatorname{Pic}(\mathbf P^1)=\mathbf Z\). Naturality of the boundary
map gives

\[
\alpha(Q)=\delta_Q(1)=\delta_C(e)=e\delta_C(1)=e\beta.
\]

If \(e\) were even, then \(\alpha(Q)=0\), so
\(Q\simeq\mathbf P^1_K\). Evaluating \(Q\to Z\) at a \(K\)-point would
contradict \(Z(K)=\varnothing\). Thus \(e\) is odd and
\(\alpha(Q)=\beta\). A smooth genus-zero curve is determined by its
degree-two central simple algebra, so \(Q\simeq C\). \(\square\)

### Corollary 3.2

If \(H\) is a \(K\)-defined line bundle on \(Z\), then the \(H\)-degree of
\(B\) is even. Indeed, its pullback to the nonsplit conic \(C\) is a
\(K\)-line bundle, and

\[
\deg\operatorname{Pic}(C)=2\mathbf Z\subset\mathbf Z
=\operatorname{Pic}(C_{\bar K}).
\]

For \(Z=V_T\) and \(H=-K_{V_T}\), every candidate therefore has even
anticanonical degree.

## 4. Exact comparison with the Klein point problem

### Theorem 4.1

For the generic full-\(G\) torsor in Section 1,

\[
\boxed{
V_T(K(S))\ne\varnothing
\Longleftrightarrow
\operatorname{Mor}_K(C,V_T)\ne\varnothing
\Longleftrightarrow
Y_T(K)\ne\varnothing.}
\]

### Proof

The first equivalence is Theorem 2.1.

Tschinkel--Zhang construct a \(G\)-equivariant stable birational
equivalence

\[
Y\times\mathbf P^2\times\mathbf P(U)
\dashrightarrow
V\times\mathbf P^2\times\mathbf P(U),
\]

where \(\mathbf P(U)\) is the projective spin fivefold. Twisting by \(T\)
replaces this last factor by \(S\). Over \(F=K(S)\), the Severi--Brauer
variety \(S_F\) has a point and is split. The smooth proper varieties
\(Y_{T,F}\) and \(V_{T,F}\) are therefore stably birational. Applying
Lang--Nishimura in both directions gives

\[
V_T(F)\ne\varnothing
\quad\Longleftrightarrow\quad
Y_T(F)\ne\varnothing.
\]

It remains to descend a point on the cubic from \(F\) to \(K\). By
Theorem 2.1, a point in \(Y_T(F)\) gives a morphism \(g:C\to Y_T\). If it
is constant, it already gives a \(K\)-point. Otherwise choose a
\(K\)-rational anticanonical divisor of degree two on \(C\) whose
geometric points have distinct images. The line joining the two conjugate
image points is a line \(L\simeq\mathbf P^1_K\) in the split ambient
\(\mathbf P^4_K\). If \(L\subset Y_T\), it has \(K\)-points. Otherwise
\(L\cap Y_T\) is a degree-three divisor containing the given degree-two
divisor, and the residual degree-one divisor is a \(K\)-point of \(Y_T\).
Thus

\[
Y_T(F)\ne\varnothing\Longrightarrow Y_T(K)\ne\varnothing;
\]

the reverse implication is immediate. \(\square\)

This theorem is an exact reformulation, not a negative result. A curve in
any surviving degree would prove the positive Klein headline.

## 5. An all-degree splitting-type restriction

Let

\[
f:C\to V_T\subset\operatorname{SB}_2(A_\beta)
\]

be a normalization map as in Proposition 3.1, and put

\[
d=\deg f^*H,
\]

where \(H\) is the Pluecker, equivalently anticanonical, class.

### Proposition 5.1

Over \(\bar K\), the pullback of the tautological rank-two bundle, after
the natural Morita twist, has the form

\[
F\simeq\mathcal O_{\mathbf P^1}(-a)\oplus
        \mathcal O_{\mathbf P^1}(-b),
\qquad 0\le a\le b,
\]

with

\[
d=a+b.
\]

Necessarily

\[
\boxed{a=b\quad\text{or}\quad a,b\text{ are both odd}.}
\]

In particular \(d\) is even. The first possibilities are

\[
\begin{array}{c|c}
d&(a,b)\\ \hline
2&(1,1)\\
4&(1,3),(2,2)\\
6&(1,5),(3,3)\\
8&(1,7),(3,5),(4,4).
\end{array}
\]

### Proof

Let \(\mathcal I\) be the universal rank-two splitting bundle for \(D\) on
\(C=\operatorname{SB}(D)\). Then

\[
D_C\simeq\operatorname{End}(\mathcal I),\qquad
\mathcal I_{\bar K}\simeq\mathcal O_{\mathbf P^1}(-1)^{\oplus2},
\]

and Morita equivalence identifies

\[
\operatorname{SB}_2(A_\beta)\times_K C
\simeq
\operatorname{Gr}_C(2,\mathcal I^{\oplus3}).
\]

The graph of \(f\) gives a section of this relative Grassmannian and hence
a rank-two subbundle

\[
\mathcal E\subset\mathcal I^{\oplus3}.
\]

After base change to \(\bar K\), put

\[
F=\mathcal E_{\bar K}(1)\subset
\mathcal O_{\mathbf P^1}^{\oplus6}.
\]

Grothendieck splitting and the inclusion in a trivial bundle give the
displayed integers \(0\le a\le b\). The Pluecker degree is
\(\deg\det(F)^\vee=a+b\).

Now

\[
\mathcal E_{\bar K}\simeq
\mathcal O(-a-1)\oplus\mathcal O(-b-1).
\]

If \(a<b\), the maximal Harder--Narasimhan line subbundle is unique, hence
Galois-invariant and descends to a line bundle on \(C\); its quotient does
as well. Every line bundle on the nonsplit conic has even geometric
degree. Therefore both \(-a-1\) and \(-b-1\) are even, so \(a,b\) are
odd. If \(a=b\), no further parity follows from descent, but \(d=2a\) is
still even. \(\square\)

This is an all-degree necessary condition. It does not assert that every
listed splitting type lands in the five defining hyperplanes of \(V_T\).

## 6. Degree two is excluded

### Theorem 6.1

For the genuine generic full-\(G\) torsor, there is no morphism

\[
C\longrightarrow V_T
\]

whose normalized image has anticanonical degree two.

### Proof

An integral degree-two curve in the anticanonical embedding is a plane
conic. Geometric integrality makes it a smooth conic. Iliev--Manivel's
linear-algebra construction identifies the Fano surface of conics on a
smooth genus-eight \(V_{14}\) with the Fano surface of lines on its
orthogonal cubic:

\[
F_2(V)\simeq F_1(Y).
\]

For the forward direction used here, a conic \(q\subset V\) determines the
unique four-dimensional subspace \(L\) for which \(q\) is a linear section
of \(\operatorname{Gr}(2,L)\); orthogonal complement then cuts the
Pfaffian cubic in a line. This construction is canonical and
\(G\)-equivariant, so it survives twisting. A \(K\)-defined conic on
\(V_T\) would therefore give a \(K\)-defined line on \(Y_T\).

The binding generic no-line theorem excludes such a line: a line would
give a rational \(G\)-equivariant map from the generic honest source to
the Fano surface, producing a faithful very versal image of dimension at
most two, contrary to \(\operatorname{ed}(G)\ge3\). Hence the conic
cannot exist. \(\square\)

The first unresolved degree is therefore \(d=4\), with the two possible
ambient splitting types \((1,3)\) and \((2,2)\).

## 7. What bend-and-break would need, and why it does not supply it

Lehmann--Tanimoto prove, for a prime Fano threefold of index one and degree
between \(4\) and \(18\) that is **general in moduli**, that a dominant
component of birational degree-\(d\) stable maps contains a
codimension-one boundary of two free curves. Their induction shows, again
for a general threefold, that the main component contains the main
boundary

\[
M_2^{(1)}\times_V M_{d-2}^{(1)}.
\]

This does not give the desired arithmetic reduction for three independent
reasons.

1. The Klein-associated \(V_{14}\) is maximally special, with automorphism
   group \(G\). The theorem explicitly assumes generality in moduli.
2. It concerns dominant, generically birational free components. A given
   \(\beta\)-normalized curve need not be a point of such a component.
3. Most importantly, the conclusion is geometric existence of a boundary
   divisor. A \(K\)-point of the interior of a proper moduli component
   does not imply a \(K\)-point of that divisor. Even
   \(\mathbf P^1_K\) can have a \(K\)-point in the complement of a boundary
   consisting of one closed point of degree two.

The precise missing arithmetic statement can be seen as follows.

### Lemma 7.1 (conditional boundary obstruction)

Assume \(V_T(K)=\varnothing\) and \(V_T\) has no \(K\)-defined conic. A
\(K\)-rational stable map whose geometric domain has exactly two
noncontracted components of degrees \(2\) and \(d-2\), each mapped
birationally to its image, cannot exist.

### Proof

If \(d\ne4\), the two components have different degrees, so each is
Galois-stable. The degree-two component descends to a forbidden
\(K\)-conic. If \(d=4\), either the two components are individually
Galois-stable, with the same conclusion, or Galois exchanges them. In the
latter case their unique node is Galois-fixed; its image is a \(K\)-point
of \(V_T\), again impossible. \(\square\)

More generally, a finite group acting on the dual tree of a genus-zero
stable curve fixes a vertex or an edge. A fixed edge gives a \(K\)-rational
node, hence a \(K\)-point of the target. On a pointless target there must
instead be a fixed noncontracted component. This observation becomes
useful only after one has produced a \(K\)-rational boundary stable map;
geometric bend-and-break does not produce one.

The exact \(D_{12}\) packet is a warning against suppressing this descent
issue. At the subgroup level the \(V_{14}\) is spin-unirational although
it is not linearly unirational, and the source eigenspaces and the isolated
target fixed points occur in exchanged pairs. Thus a fixed-locus or
geometric-boundary argument that silently chooses one member of a pair is
false. This does **not** rule out a new theorem using genuine full-\(G\)
genericity, and the \(D_{12}\) packet does not determine the minimal degree
of its Schur-conic map; it rules out only a group-independent descent
shortcut.

## 8. Abel--Jacobi gives a zero-fibre condition, not degree reduction

The intermediate Jacobians of \(V\) and its orthogonal cubic \(Y\) are
canonically isomorphic, up to the conventional sign. On the genuine
generic twist the fixed-Jacobian packet gives

\[
J_T(K)=\{0\}.
\]

For a \(K\)-defined curve \(B\subset V_T\) of anticanonical degree \(d\),
the cycle

\[
14[B]-dH^2
\]

is homologically trivial, since \(H^3=14\). Its Abel--Jacobi value is a
\(K\)-point of \(J_T\), and therefore

\[
\operatorname{AJ}(14[B]-dH^2)=0.
\]

This is a necessary condition in every degree, but it does not see the
Brauer class of the normalization and does not lower degree. The known
degree-two theorem is special: the conic Abel--Jacobi map is an embedding,
and the entire conic surface is canonically the Fano surface of lines on
the cubic. No analogous theorem identifies the distinguished zero fibre
for rational quartics, or for arbitrary higher rational curves, on the
special Klein \(V_{14}\).

For an unobstructed rational curve the expected Hilbert dimension is \(d\),
while \(\dim J=5\). Thus from degree \(6\) onward a zero fibre is expected
to have nonnegative dimension; this is only a dimension warning, not an
existence theorem, but it shows why \(J_T(K)=0\) is not an emptiness
mechanism. Abel--Jacobi is additive on a reducible boundary and permits
Galois-stable sums of conjugate components; it does not select a
\(K\)-defined conic from such a sum.

The missing degree-four theorem would have to prove that the canonical
zero fibre in the rational-quartic component is empty, or that every point
of it degenerates over \(K\) to a forbidden conic boundary. Neither
statement is present in the audited literature. Consequently no finite
degree reduction has been obtained.

## 9. Final theorem boundary

The following statements are proved here:

- the exact Morita--conic criterion for all proper targets;
- the normalization formula \(\alpha(Q)=e\beta\) and removal of all
  multiple covers;
- evenness and the all-degree splitting-type restriction;
- exact equivalence with the Klein generic point problem;
- exclusion of anticanonical degree two.

The following are **not** proved:

- nonexistence of degree-four \(\beta\)-normalized curves;
- reduction of every higher even degree to degree two or four;
- a \(K\)-rational bend-and-break boundary point;
- emptiness of a distinguished Abel--Jacobi zero fibre;
- pointlessness of \(Y_T\), or the negative Klein headline.

Terminal marker:

    SCHUR-CONIC-CRITERION-AND-DEGREE2-EXCLUSION-OK
    HEADLINE-OPEN

## 10. Subsequent degree-four sharpening

The negative statement in Sections 7--9 that this packet itself supplies
no finite-degree reduction remains historically accurate, but it has been
superseded by the independent packet `../SCHUR_QUARTIC_MODULI/`.  There the
Pfaffian kernel fibre of any rational point on the twisted Klein cubic is
shown to map to the twisted \(V_{14}\) with tautological splitting

\[
 \mathcal O(-1)\oplus\mathcal O(-3)
\]

and hence with Pluecker degree four.  Together with the criterion proved
above, this gives

\[
 Y_T(K)\ne\varnothing
 \quad\Longleftrightarrow\quad
 \operatorname{Mor}_K(C_\beta,V_T)_{H\text{-degree }4}\ne\varnothing.
\]

This reduces the all-degree curve question to its first surviving quartic
case; it does not exclude that quartic and does not change `HEADLINE-OPEN`.
