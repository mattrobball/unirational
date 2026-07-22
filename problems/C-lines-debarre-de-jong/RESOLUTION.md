# Degree-nine Debarre--de Jong sweep: audited status

Date of audit: 2026-07-22.

## Verdict

There are two different answers, depending on the field convention.

1. **The literal field-unspecified displayed statement in `SPEC.md` is
   false.**  Over
   \(\overline{\mathbf F}_2\) (with equation and witness line already defined
   over \(\mathbf F_2\)), the Fermat hypersurface
   \[
   X:\quad x_0^9+\cdots+x_9^9=0\subset\mathbf P^9
   \]
   is smooth, while \(F_1(X)\) has local dimension 12 at the explicit line
   recorded by the calibration harness.  The expected dimension is 6.
2. **The intended characteristic-zero (in particular complex) statement is
   still open.**  No characteristic-zero counterexample was found.  The work
   below is a certified partial null result and a substantial reduction of the
   search space; it is not a proof of the conjecture and it is not the broad
   exhaustive sweep originally proposed in `SPEC.md`.

The positive-characteristic counterexample is exact, not a modular heuristic.
In characteristic two the partial derivatives of the Fermat equation are
\(x_i^8\), so they have no common projective zero.  On the displayed affine
Grassmann chart, only four coefficient equations remain and their Jacobian has
rank four at the fixture line.  Krull's lower bound and the tangent-space upper
bound therefore both give local dimension \(16-4=12\).  See
[`calibration/calibrate.m2`](calibration/calibrate.m2) and
[`results/calibration.md`](results/calibration.md).  The regular-local
dimension is unchanged after extending scalars from \(\mathbf F_2\) to its
algebraic closure.

The standard formulation explicitly works over an algebraically closed field
of characteristic zero; see Landsberg--Tommasi, Conjecture 1.2 and their field
convention ([arXiv:0810.4158](https://arxiv.org/abs/0810.4158)).  Everything
below about the open problem uses that convention.

The sharpest characteristic-zero conclusion proved below is this.  It is
enough to work in \(\mathbf P^9\), and any counterexample there has an
integral singular sixfold \(Y\) swept by a reduced line component of
dimension **exactly seven**.  Its span is \(\mathbf P^8\) or \(\mathbf P^9\).
In span eight, the normalization of \(Y\) is singular, the entire
eight-dimensional component branch is excluded, and the seven-dimensional
branch has \(\epsilon\in\{2,3\}\); the \(\epsilon=4,5\) rows are excluded.
The surviving \(\epsilon=2,3\) geometry is reduced to the explicit finite
list below.  In span nine, the unresolved cases are the Landsberg--Tommasi
boundary rows and signed defect classes recorded below.  None of these
reductions is being promoted to a proof of the complex conjecture.

## Corrections to the search brief

Several points in `SPEC.md` need correction before its computational protocol
can be treated as a certificate protocol.

- The base field must be stated.  Small-characteristic examples are actual
  counterexamples to a field-free conjecture, even though they say nothing by
  themselves about the complex conjecture.
- The correct Beheshti--Riedl reference for \(N\geq 2d-4\) is
  *Linear subspaces of hypersurfaces*, Corollary 2.5
  ([arXiv:1903.02481](https://arxiv.org/abs/1903.02481)), not
  arXiv:2002.04713.  The latter is Samir Canning's paper on Fano complete
  intersections.
- Degree nine is the **first unresolved degree**.  The five pairs
  \((d,N)=(9,9),\ldots,(9,13)\) are the unresolved degree-nine strip, not the
  complete global open frontier: unresolved cases also remain in higher
  degrees.
- For homogeneous smoothness in arbitrary characteristic, use
  \((F,\partial_0F,\ldots,\partial_NF)\), saturated by the irrelevant ideal.
  Omitting \(F\) is unsafe when the characteristic divides \(d\).
- Two or three random Grassmann charts are a screen, not a global upper-bound
  certificate.  The 45 standard pivot charts cover \(G(1,9)\); all 45, or an
  equivalent homogeneous/Stiefel saturation, are required for a global null
  certificate.  Conversely, one exact local computation of dimension at least
  seven is enough for a counterexample lower bound.
- The claim that thousands of slice tests are feasible was not validated.  The
  sub-second calibration run only evaluates smoothness and the Jacobian at a
  supplied line; it does not perform the proposed seven-hyperplane elimination.

The prior degree bound is Beheshti's Corollary 3.3, which proves \(d\leq8\)
([paper](https://www.math.wustl.edu/~beheshti/hl.pdf)).  Beheshti--Riedl then
proves the conjecture for \(N\geq2d-4\).  The 2024 Erman--Riedl strength result
only proves a weakened form, as its abstract itself says
([arXiv:2410.20051](https://arxiv.org/abs/2410.20051)).  The literature audit
found no later result settling degree nine through the date above.

## The five degree-nine cases reduce to one

It is enough to settle \(N=9\).  Suppose a smooth degree-nine
\(X\subset\mathbf P^N\) has a component \(B\subset F_1(X)\) of dimension at
least
\[
2N-11=(2N-12)+1.
\]
For a general \(L\simeq\mathbf P^9\), the sub-Grassmannian
\(G(1,L)\subset G(1,N)\) has codimension \(2N-18\).  Hence every proper
intersection has
\[
\dim(B\cap G(1,L))\geq (2N-11)-(2N-18)=7.
\]
Bertini makes \(X\cap L\) smooth.  It is therefore a degree-nine
counterexample in \(\mathbf P^9\).  This turns the table in `SPEC.md` into one
boundary problem rather than five independent searches.

## Geometry forced on a characteristic-zero counterexample

Assume from now on that
\[
X_9\subset\mathbf P^9
\]
is smooth and that an irreducible component \(B\subset F_1(X)\) has dimension
at least seven.  Let \(Y\) be the integral locus swept out by its lines.

### 1. The swept locus has dimension six

Write \(a=\dim Y\).  A seven-dimensional family of lines cannot live on a
variety of dimension at most four, since \(\dim F_1(Y)\leq2a-2\).  If
\(a=5\), Beheshti's Theorem 3.2(a) applies because
\[
7\geq\frac{(2a-8)(2a-7)}2=3,
\]
and says that the component has expected dimension.  If \(a=7\) or \(a=8\),
Beheshti's Theorem 3.2(b) treats families sweeping a locus of codimension at
most one.  Thus excess is possible only for
\[
\boxed{\dim Y=6.}
\]

### 2. Rogora gives a span split, not a uniform dimension-seven conclusion

Let \(b\) be the dimension of the reduced component of \(F_1(Y)\) that
sweeps out \(Y\), and write \(\langle Y\rangle=\mathbf P^s\).  Then
\(7\leq b\leq10\) and \(7\leq s\leq9\).  The upper bound for \(b\) comes
from the fact that lines through a general smooth point of an integral
sixfold have at most five parameters.  The case \(s=6\) would be
\(Y=\mathbf P^6\), which cannot lie in a smooth degree-nine hypersurface.

Rogora's corrected Theorem \(2'\) has an essential alternative:
the ambient span may have dimension at most \(\dim Y+2\).  Thus it classifies
the present \(b\geq8\) situation only in the nondegenerate branch \(s=9\),
not when \(s=7\) or \(8\).  In the \(s=9\) branch its remaining possibilities
are:

- a \(\mathbf P^6\) or a family of \(\mathbf P^5\)'s;
- a quadric sixfold or a one-parameter family of quadric fivefolds;
- a two-parameter family of \(\mathbf P^4\)'s; or
- \(\operatorname{Gr}(2,5)\subset\mathbf P^9\).

All are impossible inside a smooth degree-nine hypersurface.  A
\(\mathbf P^5\) is already too large.  A smooth hypersurface of degree at least
three in \(\mathbf P^9\) has only finitely many \(\mathbf P^4\)'s (Starr,
Corollary 0.5, [paper](https://www.math.stonybrook.edu/~jstarr/papers/appendix3.pdf)).
Each listed quadric is cut out by at most four equations in \(\mathbf P^9\),
and \(\operatorname{Gr}(2,5)\) by five quadrics, so the low-generator lemma
below excludes them.  Consequently

\[
\boxed{s=9\Longrightarrow b=7\text{ and the general incidence fiber has
dimension }2.}
\]

For Rogora, use Definition 5 and Theorems \(1'\) and \(2'\), p. 209; the
second theorem's explicit alternative is \(n\leq k+2\)
([primary scan](https://gdz.sub.uni-goettingen.de/download/pdf/PPN365956996_0082/LOG_0021.pdf)).

The span-\(\mathbf P^7\) branch can nevertheless be eliminated directly.
Write \(L=\langle Y\rangle\simeq\mathbf P^7\), with ideal
\((z_0,z_1)\).  Since \(Y\) is an integral hypersurface in \(L\), let \(G\)
be its irreducible equation.  The restriction of the degree-nine equation
\(F\) of \(X\) has the form

\[
F|_L=GH.
\]

If \(F|_L=0\), the two degree-eight normal derivatives
\((\partial F/\partial z_j)|_L\) have a common projective zero, where all
tangential derivatives vanish too; this would make \(X\) singular.  If
\(\deg H>0\), the three positive-degree forms consisting of \(H|_Y\) and the
two normal derivatives have a common zero on the sixfold \(Y\).  At that point
\(G=H=0\), so the tangential derivatives of \(GH\) vanish as well, again
making \(X\) singular.  Hence \(H\) is a nonzero constant:

\[
\deg Y=9,\qquad Y=X\cap L\quad\text{scheme-theoretically}.
\]

Let \(S=\operatorname{Sing}(Y)\).  The Gauss morphism
\(\gamma_X:X\to(\mathbf P^9)^*\) is finite because
\(\gamma_X^*\mathcal O(1)=\mathcal O_X(8)\) is ample.  At a point of \(S\),
the tangent hyperplane to \(X\) contains \(L\), so

\[
S\subset\gamma_X^{-1}(L^\perp),\qquad L^\perp\simeq\mathbf P^1,
\]

and therefore \(\dim S\leq1\).

Now suppose a general line \(\ell\) of the \(b\)-dimensional component avoided
\(S\).  It would lie in \(Y_{\rm sm}\), with

\[
0\longrightarrow N_{\ell/Y}\longrightarrow
\mathcal O_{\mathbf P^1}(1)^6\longrightarrow
\mathcal O_{\mathbf P^1}(9)\longrightarrow0.
\]

Thus \(N_{\ell/Y}\) has rank five and degree \(-3\).  Generic smoothness of
the dominating universal incidence over \(Y\) says that, at a general point
of \(\ell\), the image of
\(T_{[\ell]}B\subset H^0(N_{\ell/Y})\) generates the normal fiber.  After
splitting on \(\mathbf P^1\), this requires every summand of
\(N_{\ell/Y}\) to have nonnegative degree, a contradiction.  Hence a general
component line meets \(S\).

Choose an incidence component
\(D\subset\{(\ell,q)\in B\times S:q\in\ell\}\) dominating \(B\).  Its image
in \(S\) cannot be a point, since lines through one point of \(\mathbf P^7\)
form only a \(\mathbf P^6\).  It is therefore a curve \(C\), and
\(D\to B\) is generically finite.  For general \(q\in C\), the fiber \(D_q\)
is a closed subset of the \(\mathbf P^6\) of lines through \(q\).  Consequently

\[
b=\dim D\leq1+6=7.
\]

Equality holds, so \(D_q=\mathbf P^6\): every line of \(L\) through \(q\)
would lie in \(Y\), forcing \(Y=L\), a final contradiction.  Thus

\[
\boxed{s=7\text{ is impossible}.}
\]

Rogora's Theorem \(1'\), which has no low-span exception, controls the two
larger values globally.  If \(\dim F_1(Y)=10\), its type-\(R_0\) conclusion
is \(Y=\mathbf P^6\).  Once this is excluded, the existence of a
nine-dimensional component would make \(Y\) type \(R_1\), hence either a
scroll in \(\mathbf P^5\)'s or an irreducible quadric.  The scroll would put
a \(\mathbf P^5\) in \(X\), and the quadric spans at most
\(\mathbf P^7\); neither is possible.  Thus in fact
\(\dim F_1(Y)\leq8\), including components that do not sweep \(Y\).

The only remaining low-span branch is therefore

\[
\boxed{s=8,\quad b\in\{7,8\},\qquad
\dim\{\ell\in B:y\in\ell\}=b-5\text{ for general }y\in Y.}
\]

### 3. Factorial complete-intersection structure in span eight

The span-eight branch has substantially more structure.  Put
\(L=\langle Y\rangle\simeq\mathbf P^8\) and \(Z=X\cap L\).  In coordinates
with \(L=V(x_9)\), the singular scheme of the degree-nine hypersurface
\(Z\subset L\) is exactly the fiber of the Gauss morphism of \(X\) over the
hyperplane \([L]\):

\[
\operatorname{Sing}(Z)=\gamma_X^{-1}([L]).
\]

Indeed, both schemes are cut out by
\(F_0,\ldots,F_8\); Euler's identity supplies \(F=0\) on \(L\), while on the
Gauss fiber smoothness makes \(F_9\) invertible and Euler's identity forces
\(x_9=0\).  Since
\(\gamma_X^*\mathcal O(1)=\mathcal O_X(8)\) is ample, the Gauss morphism is
finite.  Thus \(\operatorname{Sing}(Z)\) is finite.

It follows that \(Z\) is integral: a factorization of its equation would make
it singular along the intersection of two positive-degree hypersurfaces,
which has dimension at least six.  A hypersurface is Cohen--Macaulay, so the
finite singular locus also makes \(Z\) normal.  At a singular point its
seven-dimensional local ring is a complete intersection and all proper
localizations are regular.  Grothendieck's factoriality theorem and the
projective Grothendieck--Lefschetz theorem therefore give

\[
\operatorname{Cl}(Z)=\operatorname{Pic}(Z)=\mathbf Z[H].
\]

The precise inputs are SGA 2, Exposé XI, Corollary 3.14, and Exposé XII,
Corollary 3.7
([updated SGA 2 text](https://arxiv.org/pdf/math/0511279)).  In particular,
the prime divisor \(Y\subset Z\) satisfies \(Y\sim mH\) for a unique
\(m>0\).  Its defining section lifts from \(Z\) to a degree-\(m\) form \(G\)
on \(L\), because
\(H^1(\mathbf P^8,\mathcal O_{\mathbf P^8}(m-9))=0\).  Consequently

\[
\boxed{Y=V_L(F|_L,G)\text{ scheme-theoretically},\qquad
I_{Y/\mathbf P^9}=(x_9,F,G),\qquad \deg Y=9m.}
\]

The equality \(m=1\) would put \(Y\) in a second hyperplane, contrary to
\(\langle Y\rangle=L\).  Hence \(m\geq2\), \(\deg Y\geq18\), and adjunction
gives

\[
\omega_Y\simeq\mathcal O_Y(m).
\]

There is also an exact linewise constraint.  A general line of \(B\) avoids
the finite set \(\operatorname{Sing}(Z)\).  For \(b=8\) this follows from the
seven-dimensional space of all lines in \(L\) through a fixed point.  For
\(b=7\), equality would force all such lines through one point to lie in
\(Y\), and hence would force \(Y=L\).  Thus, for a general
\(\ell\in B\),

\[
0\longrightarrow N_{\ell/Z}\longrightarrow
\mathcal O_{\mathbf P^1}(1)^7\xrightarrow{\,dF\,}
\mathcal O_{\mathbf P^1}(9)\longrightarrow0,
\qquad \deg N_{\ell/Z}=-2.
\]

Let \(D_\ell\) be the divisorial zero scheme of
\(dG:N_{\ell/Z}\to\mathcal O_\ell(m)\), equivalently the scheme-theoretic
intersection of \(\ell\) with \(\operatorname{Sing}(Y)\) inside
\(Z_{\rm sm}\), and put \(\delta=\deg D_\ell\).  Its image is the invertible
subsheaf
\(\mathcal O_\ell(m)(-D_\ell)\simeq\mathcal O_\ell(m-\delta)\); factoring
through that image gives

\[
0\longrightarrow E_\ell\longrightarrow N_{\ell/Z}\longrightarrow
\mathcal O_\ell(m-\delta)\longrightarrow0.
\]

Generic smoothness of the dominating universal incidence says that
\(E_\ell\) is generically generated by the image of
\(T_{[\ell]}B\).  Since \(E_\ell\) has rank five and embeds in
\(\mathcal O(1)^7\), its splitting has only zero and one as summand degrees.
Writing their number of ones as \(\epsilon\), degree comparison and the
vanishing of the relevant \(\operatorname{Ext}^1\) give

\[
\begin{aligned}
E_\ell&\simeq\mathcal O(1)^\epsilon\oplus
                 \mathcal O^{\,5-\epsilon},\\
N_{\ell/Z}&\simeq\mathcal O(1)^\epsilon\oplus
                 \mathcal O^{\,5-\epsilon}\oplus
                 \mathcal O(-\epsilon-2),\\
\delta&=m+\epsilon+2,
\qquad b\leq h^0(E_\ell)=5+\epsilon.
\end{aligned}
\]

Therefore

\[
\boxed{b-5\leq\epsilon\leq5,\qquad
       m+b-3\leq\delta\leq m+7.}
\]

This has a concrete Jacobian interpretation.  Along \(\ell\), write the two
normal differential rows of \(F|_L\) and \(G\) as a \(2\times7\) matrix.
Its normal Jacobian minors are binary forms of degree \(m+7\), and their gcd
divisor is \(D_\ell\).  After its equation is removed, every nonzero residual
minor is a section of \(\mathcal O_\ell(m+7-\delta)\), where

\[
m+7-\delta=5-\epsilon\leq10-b,
\]

so it is at most three for \(b=7\), and at most two for \(b=8\).  Moreover,
the full Zariski tangent space to \(F_1(Y)\) at \([\ell]\) is
\(H^0(E_\ell)\).  Thus the Fano scheme is generically reduced along \(B\)
exactly when \(\epsilon=b-5\).  In that case the two possibilities specialize
to

\[
\begin{array}{c|c|c|c}
b&\epsilon&\delta&\text{residual-minor degree}\\ \hline
7&2&m+4&3\\
8&3&m+5&2.
\end{array}
\]

Larger \(\epsilon\) records a tangent-nonreduced Fano scheme along the
component.  More invariantly, divide the decomposable wedge of the two
normal Jacobian rows by the equation of \(D_\ell\).  The resulting minors
have no common zero and define

\[
\phi_\ell:\mathbf P^1\longrightarrow
\operatorname{Gr}(2,7),\qquad
\phi_\ell^*\mathcal O_{\operatorname{Gr}}(1)
=\mathcal O_{\mathbf P^1}(5-\epsilon).
\]

This is the extension across \(D_\ell\) of the conormal Gauss map of \(Y\)
along \(\ell\).  Thus, when \(b=8\), the value \(\epsilon=5\) is impossible
even before using the LT table: every general component line would be
contracted by the Gauss map.  The reduced three-dimensional family of such lines
through a general point sweeps a fourfold inside its Gauss fiber.  In
characteristic zero a general Gauss fiber is a linear subvariety
([Furukawa, abstract](https://arxiv.org/abs/1310.5387)), so its closure here
is a \(\mathbf P^k\subset Y\) with \(k\geq4\).  It therefore contains a
\(\mathbf P^4\) through the general point.  Such \(\mathbf P^4\)'s must vary
to cover the sixfold (and a larger linear fiber already contains infinitely
many of them), contradicting Starr's finiteness theorem.

The same value \(\epsilon=5\) is impossible for \(b=7\), although one more
step is needed.  The two-dimensional family of \(B\)-lines through a general
point sweeps a threefold inside its linear Gauss fiber.  A Gauss fiber of
dimension at least four again contradicts Starr, so the general fiber is a
\(\mathbf P^3\), and these \(\mathbf P^3\)'s form a three-dimensional family
generically partitioning \(Y\).

If a general member \(\Lambda=\mathbf P^3\) avoids
\(\operatorname{Sing}(Z)\), its characteristic map
\[
\mathcal O_\Lambda^3\longrightarrow E=N_{\Lambda/Z}
\]
has generic rank three.  Here
\[
0\longrightarrow E\longrightarrow\mathcal O_\Lambda(1)^5
\longrightarrow\mathcal O_\Lambda(9)\longrightarrow0,
\qquad \det E=\mathcal O_\Lambda(-4).
\]
Thus its third exterior power would be a nonzero section of \(E^*(-4)\).
Dualizing and twisting the displayed sequence gives
\[
0\longrightarrow\mathcal O_\Lambda(-13)
\longrightarrow\mathcal O_\Lambda(-5)^5
\longrightarrow E^*(-4)\longrightarrow0,
\]
but \(H^0(\mathcal O(-5))=H^1(\mathcal O(-13))=0\) on
\(\mathbf P^3\), a contradiction.

Otherwise finiteness of \(\operatorname{Sing}(Z)\) supplies one fixed
\(p\) contained in every general Gauss fiber, making \(Y\) a cone with
vertex \(p\).  A Bertini-general \(\mathbf P^7\subset\mathbf P^8\) avoiding
\(p\) and \(\operatorname{Sing}(Z)\) cuts out a smooth degree-nine hypersurface and
a three-dimensional family of \(\mathbf P^2\)'s generically partitioning its
intersection with \(Y\).  The identical characteristic-map calculation on
\(\mathbf P^2\) gives the same forbidden section; here too
\(H^1(\mathbf P^2,\mathcal O(-13))=0\).  Hence, at this preliminary stage,
\[
\boxed{b=7\Longrightarrow\epsilon\leq4.}
\]

Thus the generically reduced \(b=7\) and \(b=8\) cases produce respectively
maps of Plücker degree three and two; the
\(b=8\), \(\epsilon=4\) tangent-nonreduced case produces a Grassmannian line.
Finally,
if a component of \(\operatorname{Sing}(Y)\) met by the general lines has
dimension \(h\), the family through a general point of that component has
dimension at most five: a six-dimensional family of distinct lines through
one point has a seven-dimensional union, which cannot lie in the sixfold
\(Y\).  Hence

\[
\dim\operatorname{Sing}(Y)\geq b-5,
\]

namely at least two for \(b=7\) and at least three for \(b=8\).

There are two useful sharpenings.  First, the \(b=8\) lower bound is actually
four.  If a three-dimensional singular component \(S\) were met by the
general lines, then for general \(q\in S\) the incidence fiber \(B_q\) would
have dimension \(8-3=5\).  Its universal family has dimension six and its
evaluation away from \(q\) is generically injective, because \(q\) and a
second point determine the line.  Its closed image is therefore all of
\(Y\), so \(q\) is a vertex of the cone \(Y\).  The vertex locus of an
integral projective variety is a closed linear space.  It contains
\(\langle S\rangle\), hence has dimension at least three, and the joins of
this vertex with points outside it give a moving family of
\(\mathbf P^4\)'s in \(Y\).  Starr's theorem again gives a contradiction.
Thus

\[
\boxed{b=8\Longrightarrow
\dim(\text{every singular component met by general }B\text{-lines})\geq4.}
\]

Second, if the support of a general \(D_\ell\) contains two distinct points,
a generically finite base change can choose an ordered pair on components
\(S_1,S_2\subset\operatorname{Sing}(Y)\).  The resulting map to
\(S_1\times S_2\) is generically injective, since two distinct points
determine \(\ell\).  Hence
\[
b\leq\dim S_1+\dim S_2,
\]
so at least one component met by the general lines has dimension at least
four.  In
the complementary case \(D_\ell\) has one geometric support point, with its
entire length
\(\delta=m+\epsilon+2\) concentrated there.

Normality makes the linewise calculation still more restrictive.  Assume
temporarily that \(Y\) is normal, and let
\(\pi:\widetilde Y\to Y\) be a log resolution of its Jacobian ideal.  Write
\[
\operatorname{Jac}_Y\mathcal O_{\widetilde Y}=\mathcal O_{\widetilde Y}(-J),
\qquad \widehat K=\widehat K_{\widetilde Y/Y}
\]
for the Jacobian and Mather-discrepancy divisors.  The strict transforms of
the general \(B\)-lines form a covering family on the smooth sixfold
\(\widetilde Y\), so its general member \(\widetilde\ell\) is free.  Its
complete Hilbert component still has dimension \(b\): every deformation has
degree one for \(\pi^*H\), maps to a line of \(Y\), and the strict transform
of such a line is unique.  Therefore
\[
-K_{\widetilde Y}\cdot\widetilde\ell=b-3.
\]
The restriction of \(\operatorname{Jac}_Y\) to \(\ell\) is generated by the
normal \(2\times2\) minors above, so
\(J\cdot\widetilde\ell=\delta\).  Since \(Y\) is locally a complete
intersection, Mather--Jacobian adjunction gives
\[
K_{\widetilde Y}=\pi^*K_Y+\widehat K-J
\]
([de Fernex--Docampo, Corollary 3.5](https://arxiv.org/pdf/1106.2172)).
Consequently
\[
\boxed{\widehat K\cdot\widetilde\ell
=\delta-m-b+3=\epsilon-(b-5).}
\]

Every exceptional divisor over a normal \(Y\) has positive Mather
coefficient when it meets this curve: its center has codimension at least
two, so the birational differential has positive-dimensional kernel along
the divisor and its Jacobian vanishes there.  Since every general line meets
\(\operatorname{Sing}(Y)\), the boxed number cannot be zero.  Thus a normal
\(Y\) has
\[
\boxed{\epsilon>b-5;}
\]
in particular, **neither generically reduced span-eight case is normal**.
More precisely, the number of distinct singular support points on a general
line is at most \(\epsilon-(b-5)\).  Combining this with the Gauss-map
exclusion of \(\epsilon=5\), at this stage a normal \(b=8\) survivor could
only have \(\epsilon=4\): its divisor \(D_\ell\), of length \(m+6\), is
supported at one point on a four-dimensional singular component.  The
characteristic-map argument below ultimately eliminates that case and then
all of \(b=8\).  For normal \(b=7\), the intermediate values
\(\epsilon=3,4\) allow at most one and two support points respectively; the
later conormal-kernel argument eliminates \(\epsilon=4\) altogether.

For \(b=7\), the birational differential gives a still sharper linewise
description.  Freeness on the resolution gives
\[
A_\ell:=N_{\widetilde\ell/\widetilde Y}
\simeq\mathcal O(1)^2\oplus\mathcal O^3.
\]
Its map to the saturated tangent kernel
\[
E_\ell=\mathcal O(1)^\epsilon\oplus\mathcal O^{5-\epsilon}
\]
is injective with a torsion cokernel \(T_\ell\) of length
\(\epsilon-2\).  Thus the two remaining normal cases have
\[
\begin{array}{c|c|c}
\epsilon&E_\ell&T_\ell\\ \hline
3&\mathcal O(1)^3\oplus\mathcal O^2&k_p\\
4&\mathcal O(1)^4\oplus\mathcal O&\text{length two, supported at most two points.}
\end{array}
\]
In the first row, the quotient must be nonzero on the
\(\mathcal O(1)^3\) block; otherwise the kernel would split as
\(\mathcal O(1)^3\oplus\mathcal O\oplus\mathcal O(-1)\).
After bundle automorphisms, the injection is therefore
\(\operatorname{diag}(1,1,L,1,1)\), with \(L\) vanishing at the unique
singular support point \(p\).  In the second row, write the source and target
so that two \(\mathcal O(1)\)-summands and one \(\mathcal O\)-summand map by
the identity.  The remaining block
\(\mathcal O^2\to\mathcal O(1)^2\) is, up to bundle automorphisms, exactly
one of
\[
\begin{pmatrix}L_p&0\\0&L_q\end{pmatrix}\quad(p\ne q),
\qquad
\begin{pmatrix}L_p&0\\0&L_p\end{pmatrix},
\qquad
\begin{pmatrix}-s&0\\t&s\end{pmatrix}\quad(p=(s=0)).
\]
Their cokernels are respectively \(k_p\oplus k_q\), \(k_p^2\), and
\(\mathcal O_{2p}\).  To see completeness, twist the injection by
\(\mathcal O(-1)\): the map from the four constant sections of the positive
target block must surject onto the length-two quotient.  Conversely that
rank-two condition forces the kernel splitting displayed in the table.
This is a finite local model for the remaining normal \(b=7\) branch, not a
global exclusion.

The Mather number also locates the normal \(\epsilon=3\) singularity.  If an
exceptional divisor \(E\) has center of codimension \(c\), reduce the
differential matrix at the generic point of \(E\) modulo a local equation of
\(E\).  Tangential directions map into the center and the one transverse
direction adds at most one rank, so the reduced matrix has rank at most
\(6-c+1\).  Smith normal form therefore gives
\(\widehat k_E\geq c-1\).  Normality makes \(c\geq2\), while
\(\widehat K\cdot\widetilde\ell=1\) when \(\epsilon=3\).  It follows that
exactly one exceptional divisor meeting a general lifted line contributes:
\[
\widehat k_E=1,\qquad E\cdot\widetilde\ell=1,
\qquad\operatorname{codim}_Y\operatorname{center}(E)=2.
\]
Thus the unique support point on a general line lies on a fixed fourfold
\(S\subset\operatorname{Sing}(Y)\), and
\[
\boxed{b=7,\ Y\text{ normal},\ \epsilon=3
       \Longrightarrow\dim\operatorname{Sing}(Y)=4.}
\]
The rational support map \(B\dashrightarrow S\) has three-dimensional
general fiber; its lines sweep a four-dimensional cone in \(Y\) with vertex
the chosen general point of \(S\).

There are useful support restrictions in the normal \(\epsilon=4\) row as
well.  If the length-two divisor has one geometric support point on a
component \(S\), then \(\dim S\) is three or four.  Indeed normality gives
\(\dim S\leq4\), while \(\dim S=2\) would leave a five-dimensional family of
component lines through a general \(q\in S\).  Their union is all of \(Y\),
so every such \(q\) is a vertex.  The linear vertex locus would then contain
\(\langle S\rangle\) and give a covering family of \(\mathbf P^3\)'s, which
the characteristic-map obstruction below excludes.

If instead the two support points are distinct, on components \(S_1,S_2\),
the map \(B\dashrightarrow S_1\times S_2\) is generically injective, so
\(\dim S_1+\dim S_2\geq7\), with each dimension at most four.  The pair
\((3,4)\) cannot occur: equality would make this map dominant, hence
\(Y=J(S_1,S_2)\).  Terracini's lemma makes the tangent space of this join
constant along a general joining line, contradicting the Pluecker degree one
of its conormal map.  Therefore a two-point normal survivor has
\[
\boxed{\dim S_1=\dim S_2=4,}
\]
and the image of \(B\) is a divisor correspondence in
\(S_1\times S_2\) (also when the two ordered points lie on the same
component).

There is also no log-canonical normal survivor.  If
\(\widehat k_E-j_E\geq-1\) for every exceptional divisor, and
\(n_E=E\cdot\widetilde\ell\), then
\[
\delta=\sum j_En_E\leq
\sum(\widehat k_E+1)n_E
\leq2\widehat K\cdot\widetilde\ell.
\]
Substitution would require
\(\epsilon\geq m+2b-8>5\), impossible.  Thus every normal survivor is
necessarily worse than log canonical.  This conclusion uses the standard
identity \(\widehat K-J=K_{\widetilde Y/Y}\) for normal lci varieties,
not an unproved positivity assertion.

The complementary nonnormal branch admits a parallel exact calculation.
Let \(\nu:\bar Y\to Y\) be the normalization and let \(\mathfrak c\) be
the conductor.  Since \(Y\) is Gorenstein, finite duality gives the
reflexive divisor identity
\[
K_{\bar Y}+C=\nu^*K_Y=mH,
\]
where \(\mathfrak c\mathcal O_{\bar Y}=\mathcal O_{\bar Y}(-C)\) whenever
the latter is invertible.  Suppose first that \(\bar Y\) is smooth.  Then
\(\mathfrak c\mathcal O_{\bar Y}\) is invertible, so \(C\) is an
effective Cartier divisor.  A general \(B\)-line has a unique strict
transform \(\bar\ell\simeq\mathbf
P^1\), and these curves form a covering family of the same dimension
\(b\).  They are free.  Conversely, every deformation of \(\bar\ell\) has
\(H\)-degree one and descends to a line of \(Y\), so its Hilbert component
still has dimension \(b\).  Therefore
\[
-K_{\bar Y}\cdot\bar\ell=b-3,
\qquad
C\cdot\bar\ell=m+b-3,
\]
and the differential of the finite map to \(\mathbf P^8\) gives
\[
N_{\bar\ell/\bar Y}\simeq
\mathcal O(1)^{\,b-5}\oplus\mathcal O^{\,10-b}.
\]

Piene's formula for a finite desingularization of a local complete
intersection is
\[
\operatorname{Jac}_Y\mathcal O_{\bar Y}
 =\mathfrak R_\nu\mathfrak c,
\]
where \(\mathfrak R_\nu=\operatorname{Fitt}_0
\Omega_{\bar Y/Y}\) is the ramification ideal
([Piene, Theorem 1 and Corollary 1](https://doi.org/10.1007/BFb0066659)).
Restricting to the general lifted line gives the exact numerical meaning of
the tangent-nonreduced excess:
\[
\boxed{
\operatorname{ord}_{\bar\ell}(\mathfrak R_\nu)
:=\operatorname{length}\bigl(
 \mathcal O_{\bar\ell}/\mathfrak R_\nu\mathcal O_{\bar\ell}\bigr)
=\delta-C\cdot\bar\ell=\epsilon-(b-5).}
\]

The smooth-normalization possibilities can then be classified globally.  The
\(H\)-degree-one family is unsplit, and the theorem of Novelli--Occhetta
applies because
\[
-K_{\bar Y}\cdot\bar\ell=b-3\geq
\frac{\dim\bar Y-1}{2}.
\]
It says that \([\bar\ell]\) spans an extremal ray of
\(\overline{NE}(\bar Y)\)
([Theorem 4.3](https://arxiv.org/pdf/0805.2069)).  Let
\(\pi:\bar Y\to T\) be its elementary contraction.  Since the curves cover
\(\bar Y\), this is a fiber-type contraction.  Its length is exactly \(b-3\):
if a rational curve \(C\) belongs to the ray, then
\([C]=(H\cdot C)[\bar\ell]\), and hence
\(-K_{\bar Y}\cdot C=(b-3)H\cdot C\geq b-3\), with equality on
\(\bar\ell\).

The base cannot be a point.  Otherwise \(\rho(\bar Y)=1\), so \(\bar Y\)
would be a Picard-rank-one Fano sixfold of index \(b-3\).  But
\[
H^6=\deg Y=9m\geq18,
\]
whereas a del Pezzo sixfold has degree at most five and a Mukai sixfold has
degree at most sixteen; these are the Fujita and Mukai classifications cited
below.  Thus \(\dim T>0\).  Over the smooth locus of \(\pi\), let \(P\) be a
general fiber and put \(f=\dim P\).  The fiber-locus inequality and adjunction
give
\[
b-4\leq f\leq5,
\qquad N_{P/\bar Y}\simeq\mathcal O_P^{\,6-f},
\qquad -K_P=(b-3)H|_P.
\]
Indeed, for every curve \(C\subset P\), extremal numerical proportionality
and \(H\cdot\bar\ell=1\) give
\([C]=(H\cdot C)[\bar\ell]\) in \(N_1(\bar Y)\); intersecting with
\(-K_{\bar Y}\) proves the displayed equality.  It makes \(P\) Fano, and
the numerical equality upgrades to an equality in \(\operatorname{Pic}(P)\);
the polarization is primitive because it has degree one on the family
curves.  No claim that \(\rho(P)=1\) is needed here: monodromy can permute
several intrinsic curve classes on \(P\).  The Kobayashi--Ochiai and Fujita
classifications apply to this polarized Fano pair.
For each resulting fiber type, the dimension of the restricted \(B\)-family
equals the dimension of its full Fano scheme of lines.  Thus the general
\(\pi\)-fiber is the chain-equivalence class of the original lines; \(\pi\)
is the global realization of their rationally connected quotient.

There is a uniform obstruction whenever the restriction of \(\nu\) embeds a
general fiber \(P\).  Put \(i=b-3\), \(c=6-\dim P\), and
\(E=N_{P/Z}\).  A general \(P\) avoids the finite set
\(\nu^{-1}(\operatorname{Sing}(Z))\), so
\[
0\longrightarrow E\longrightarrow N_{P/\mathbf P^8}
\longrightarrow\mathcal O_P(9)\longrightarrow0
\]
is an exact sequence of vector bundles.  Here \(\operatorname{rank}E=c+1\);
since \(K_Z=0\) and \(K_P=-iH\), adjunction gives
\(\det E=\mathcal O_P(-i)\).  Over the smooth locus of \(\pi\),
\[
N_{P/\bar Y}\simeq\mathcal O_P^c.
\]
The differential of \(\nu\) induces a generically injective characteristic
map \(\alpha:\mathcal O_P^c\to E\): away from the conductor, \(\nu\) is an
isomorphism onto the generically smooth sixfold \(Y\).  Therefore
\[
0\ne\bigwedge^c\alpha\in
H^0\!\left(P,\bigwedge^cE\right)
=H^0(P,E^*(-i)).
\]
On the other hand, dualizing the normal sequence and twisting by \(-i\)
gives
\[
0\longrightarrow\mathcal O_P(-9-i)
\longrightarrow N^*_{P/\mathbf P^8}(-i)
\longrightarrow E^*(-i)\longrightarrow0.
\]
The conormal bundle embeds in
\(\Omega_{\mathbf P^8}|_P\), and the restricted Euler sequence gives
\(H^0(N^*_{P/\mathbf P^8}(-i))=0\).  Moreover,
\[
H^1(\mathcal O_P(-9-i))^\vee
=H^{\dim P-1}(\mathcal O_P(9))=0
\]
by Serre duality and Kodaira vanishing.  Hence
\(H^0(P,E^*(-i))=0\), a contradiction.

For \(b=8\), the two possibilities are \(P\simeq\mathbf P^4\) and
\(P\simeq Q^5\).  The restriction of \(\nu\) is the full linear embedding in
both cases: a subsystem on \(Q^5\) with only six sections would map
finitely onto \(\mathbf P^5\) with degree \(H^5=2\), contradicting generic
injectivity.
The uniform obstruction excludes both.

For \(b=7\), fibers of dimensions three and four give respectively
\(\mathbf P^3\)-fibers over a threefold and \(Q^4\)-fibers over a surface.
Both restrictions are full linear embeddings (five sections on \(Q^4\)
would instead give a degree-two map onto \(\mathbf P^4\)), so the same
obstruction excludes them.  A five-dimensional fiber would be a del Pezzo
fivefold.  For degree \(d\), one has \(h^0(H|_F)=d+4\).  A finite birational
image cannot span only \(\mathbf P^5\), because then it would have degree
one rather than \(H^5=d>1\).  Thus the possible subsystems use from seven
through \(d+4\) sections, making the following list exhaustive.  Fujita's
degrees one through five can all be eliminated:

- in degree one, \(H|_F\) is not globally generated;
- in degree two, its morphism has degree two and cannot be the restriction
  of the finite birational normalization map;
- degree three is a cubic in \(\mathbf P^6\), while degree four is either a
  \((2,2)\) in \(\mathbf P^7\) or its birational quartic projection to
  \(\mathbf P^6\); the low-generator lemma excludes all three;
- in degree five, a seven-section image is a quintic hypersurface in
  \(\mathbf P^6\), again excluded by that lemma.  The complete system is
  the del Pezzo fivefold \(V_5\subset\mathbf P^8\).  The rank-four bundle
  \[
  E=N^*_{V_5/\mathbf P^9}(9)
  \]
  is an ample quotient of
  \(\mathcal O_{V_5}(8)\oplus\mathcal O_{V_5}(7)^5\), and the exact
  Schubert calculation gives
  \[
  \int_{V_5}c_4(E)H=15856>0.
  \]
  A smooth degree-nine hypersurface containing \(V_5\) would make its
  normal differential a nowhere-zero section of \(E\), forcing
  \(c_4(E)=0\), a contradiction.

It remains in degree five to consider an eight-section system, equivalently
a projection \(V_5\to W^5\subset\mathbf P^7\) from an external point.  The
stabilizer of the hyperplane section \(V_5=\operatorname{Gr}(2,5)\cap
\mathbf P^8\) has exactly two orbits of external centers.  Direct elimination
at one representative of each orbit gives a prime image of degree five whose
ideal is minimally generated by five cubics.  In the first orbit all five
cubics lie in \((d,g,h,i)^2\), and in the second they lie in
\((a,c,f,i)^2\).  Thus in either case \(W\) contains a \(\mathbf P^3=R\)
along which every cubic generator and its differential vanish.  In
\(\mathbf P^9\), write
\[
I_W=(L_1,L_2,G_1,\ldots,G_5).
\]
Every degree-nine equation containing \(W\) has the form
\[
F=A_1L_1+A_2L_2+\sum B_jG_j.
\]
On \(R\), its differential is \(A_1dL_1+A_2dL_2\).  The two degree-eight
forms \(A_1|_R,A_2|_R\) have a common zero, at which \(dF=0\).  Hence this
last case is also impossible.  The two orbit eliminations and the Chern
number are recorded in
[`experiments/projected_v5_fivefold.m2`](experiments/projected_v5_fivefold.m2)
and
[`results/projected_v5_fivefold.md`](results/projected_v5_fivefold.md).

All possible general fibers have now been excluded.  Thus the
smooth-normalization branch is empty:
\[
\boxed{b\in\{7,8\}\Longrightarrow\bar Y\text{ is singular}.}
\]

If \(\bar Y\) is itself singular, one still gets a useful exact boundary
identity.  On a log resolution \(g:\widetilde Y\to\bar Y\), write
\[
K_{\widetilde Y}+\widetilde C
=g^*(K_{\bar Y}+C)+\sum_Ea_EE.
\]
The strict transforms of the general lines again form a free
\(b\)-dimensional covering family, and intersection with such a line gives
\[
\boxed{
\widetilde C\cdot\widetilde\ell-
\sum_Ea_E(E\cdot\widetilde\ell)=m+b-3.}
\]
Thus the conductor or negative pair discrepancies must absorb the entire
positive number \(m+b-3\).  Log canonicity of the pair alone does not
contradict uniruledness, so a direct BDPP argument stops at this identity.

One additional classification result narrows, but does not eliminate, the
case \(b=8\).  Here \(\dim F_1(Y)=8=2\dim Y-4\), because Rogora's
Theorem \(1'\) excluded every component of dimension nine or ten above.
Landsberg--Robles, Corollary 1.3, says that if the quadratic-contact locus
\(C_{2,y}\subset\mathbf P(T_yY)\) has one component, or if the contact loci
satisfy \(C_{2,y}=C_{3,y}\) scheme-theoretically (equivalently their defining
ideals agree), then \(Y\) is one of four types
([paper](https://arxiv.org/pdf/math/0509227)).  None can occur here: a
\((2,2)\) complete intersection has degree four rather than \(9m\); their
quadric-leaf and Segre-cone cases are excluded by the low-generator lemma;
and their remaining local-product case supplies a positive-dimensional
family of \(\mathbf P^4\)'s, contrary to Starr's finiteness theorem cited
above.  Thus any surviving \(b=8\) case must have a multicomponent
\(C_{2,y}\) and a strict scheme-theoretic containment
\(C_{3,y}\subsetneq C_{2,y}\).  This is a conditional structural reduction,
not an exclusion of \(b=8\).

The residual conormal map makes that multicomponent escape finite.  Let
\(A_y\subset C_{2,y}\subset\mathbf P(T_yY)=\mathbf P^5\) be a
three-dimensional component of reduced \(B\)-line directions through a
general smooth point.

If \(\epsilon=4\), then \(\phi_\ell\) has Plücker degree one and maps
\(\ell\) isomorphically to a Grassmannian line.  For the direction
\([v]\in A_y\), its differential is
\[
d\phi_\ell(v)=\mathrm{II}_y(v,-):
N_y^*Y\longrightarrow (T_yY/\langle v\rangle)^*.
\]
A tangent vector to a line in a Grassmannian has rank one, so the two
quadrics \(q_0,q_1\) of \(\mathrm{II}_y\) have dependent gradients at the
general point of \(A_y\).  If they were coprime,
\(V(q_0,q_1)\) would be an unmixed \((2,2)\) complete intersection of
cycle degree four, and \(A_y\) would be a generically nonreduced support
component.  With another support component, degree counting forces
\(A_y=\mathbf P^3\), whose cone from \(y\) is a moving
\(\mathbf P^4\subset Y\), contrary to Starr.  With only one support
component, Landsberg--Robles already applies; this includes the nonlinear
double-quadric normal form
\((Q+HL,H^2)\).

If the two quadrics are proportional, change basis to \((q,0)\).  For
\(\operatorname{rank}q\geq3\), the quadratic-contact locus has one reduced
support component and Landsberg--Robles applies.  Ranks at most two have a
common radical of vector dimension at least four, so their linear Gauss
fibers are excluded by Starr or by the characteristic-map argument below.
Thus a genuinely multicomponent common divisor has degree one and independent
residual factors.

Thus the sole multicomponent \(\epsilon=4\) pencil has
\[
q_0=La,\qquad q_1=Lb
\]
with \(L,a,b\) independent.  Set-theoretically
\[
C_{2,y}=\mathbf P^4_{L=0}\ \cup\
        \mathbf P^3_{a=b=0},
\]
and \(A_y\) is a higher-contact hypersurface in the first component; it
cannot be the second component, again by Starr.  The common-factor form
also gives
\[
\ker(d\gamma_Y)=\ker(L,a,b),
\]
of vector dimension three.  Hence \(Y\) is developable with general
Gauss-fiber closure \(\mathbf P^3\).  Along a general \(B\)-line its
tangent \(\mathbf P^6\)'s contain a fixed \(\mathbf P^5\) and lie in a
fixed \(\mathbf P^7\); this is a tangency statement, not containment of
either larger linear space in \(Y\).

The general Gauss-fiber closures are therefore linear \(\mathbf P^3\)'s and
form a covering family of \(Y\).  If a general fiber
\(\Lambda=\mathbf P^3\) avoids \(\operatorname{Sing}(Z)\), its characteristic
map has rank three.  With
\[
0\longrightarrow E=N_{\Lambda/Z}\longrightarrow
\mathcal O_\Lambda(1)^5\longrightarrow\mathcal O_\Lambda(9)
\longrightarrow0,
\qquad\det E=\mathcal O_\Lambda(-4),
\]
this would give a nonzero section of \(E^*(-4)\).  The dual sequence
\[
0\longrightarrow\mathcal O_\Lambda(-13)
\longrightarrow\mathcal O_\Lambda(-5)^5
\longrightarrow E^*(-4)\longrightarrow0
\]
has no such section.  Otherwise finiteness of \(\operatorname{Sing}(Z)\)
fixes one point \(p\) on all general Gauss fibers, making \(Y\) a cone.  A
Bertini-general \(\mathbf P^7\) avoiding \(p\) and
\(\operatorname{Sing}(Z)\) cuts the fibers to a covering family of planes;
the identical rank-three calculation on \(\mathbf P^2\) again gives
\(H^0(E^*(-4))=0\).  Hence
\[
\boxed{\text{there is no \(b=8,\epsilon=4\) survivor}.}
\]

For \(\epsilon=3\), the Fano component is generically reduced and
\(\phi_\ell\) has Plücker degree two.  At a general direction its tangent
homomorphism has rank one or two; rank zero generically would make this
separable degree-two map constant.  Suppose first that \(q_0,q_1\) are
coprime.  In rank two their gradients are independent along \(A_y\), so
\(A_y\) is a multiplicity-one threefold component of the degree-four
complete-intersection cycle \(V(q_0,q_1)\).  Degree one gives a
\(\mathbf P^3\), whose cone is a moving \(\mathbf P^4\), and degree four
uses the whole support, so Landsberg--Robles applies.  Degree two gives a
quadric in a \(\mathbf P^4\).  In degree three the span must be
\(\mathbf P^5\): for a cubic hypersurface in \(V(L)=\mathbf P^4\), every
ambient quadric in its ideal is divisible by \(L\), contradicting
coprimeness.  The minimal-degree classification then gives a rational normal
cubic scroll.  Thus the exact remaining rank-two list is

\[
\begin{array}{ll}
\text{a quadric threefold:}&
(q_0,q_1)=(Q,LL'),\quad A_y=V(Q,L),\\
\text{a rational normal cubic scroll:}&
A_y=S(1,1,1),\ S(0,1,2),\text{ or }S(0,0,3),
\end{array}
\]

the cubic scroll having a residual \(\mathbf P^3\).  At a general point of
either nonlinear component the two gradients are independent, so the
conormal curve is the standard nonschubert conic
\[
W_{[s:t]}=\langle se_0+te_1,\ se_2+te_3\rangle,
\qquad
\mathcal S|_{\phi_\ell(\ell)}
\simeq\mathcal O(-1)\oplus\mathcal O(-1).
\]
If the tangent homomorphism has rank one while the quadrics remain coprime,
then \(A_y\) is generically a multiple component of the degree-four cycle.
Hence \(2\deg A_y\leq4\): degree one is the already excluded
\(\mathbf P^3\), while degree two consumes the whole cycle and has one
reduced support component, so Landsberg--Robles applies.  A rank-one survivor
must therefore come from a common factor.

In fact both coprime types are impossible by the characteristic-map
obstruction.  In the quadric case, the cone \(K_y\) from \(y\) over
\(A_y=Q^3\) is a quadric fourfold in a \(\mathbf P^5\), and these cones cover
\(Y\).  If a general \(K_y\) avoids \(\operatorname{Sing}(Z)\), the
characteristic map to \(E=N_{K_y/Z}\) has rank at least two.  Since
\[
0\longrightarrow E\longrightarrow
\mathcal O_{K_y}(1)^3\oplus\mathcal O_{K_y}(2)
\longrightarrow\mathcal O_{K_y}(9)\longrightarrow0,
\qquad\det E=\mathcal O_{K_y}(-4),
\]
its second exterior power would give a nonzero section of \(E^*(-4)\).
Dualizing and twisting instead gives
\[
0\longrightarrow\mathcal O_{K_y}(-13)
\longrightarrow\mathcal O_{K_y}(-5)^3\oplus
                   \mathcal O_{K_y}(-6)
\longrightarrow E^*(-4)\longrightarrow0,
\]
whose outer cohomology vanishes because a quadric is arithmetically
Cohen--Macaulay.  If all general \(K_y\)'s meet the finite singular set, one
fixed \(p\in\operatorname{Sing}(Z)\) lies on all of them; their cone
structure makes \(Y\) a cone with vertex \(p\).  A Bertini-general
\(\mathbf P^7\) avoiding \(p\) and the singular set cuts them to covering
quadric threefolds on a smooth degree-nine hypersurface, where the identical
rank-two calculation again contradicts the same vanishing.

For a cubic-scroll direction threefold, its ruling planes join with \(y\) to
a covering family of linear \(\mathbf P^3\)'s in \(Y\).  The
\(\mathbf P^3\)/hyperplane-section \(\mathbf P^2\) obstruction already used
above excludes that family, including the case in which every member meets
\(\operatorname{Sing}(Z)\).

If the \(\epsilon=3\) pencil instead has a common linear factor, write
\(q_0=La,q_1=Lb\).  When \(L,a,b\) are independent,
\[
\operatorname{rad}(q_0)\cap\operatorname{rad}(q_1)=\ker(L,a,b)
\]
of vector dimension three.  Thus the general Gauss-fiber closure is a linear
\(\mathbf P^3\), and its covering family is excluded by the same
\(\mathbf P^3\)/\(\mathbf P^2\) characteristic-map argument.  If
\(L,a,b\) are dependent while the pencil is still two-dimensional, the
common radical has vector dimension at least four and is even easier.  The
remaining one-dimensional pencil can be written \((q,0)\).  If
\(\operatorname{rank}q\geq3\), its quadric has one reduced support component
and Landsberg--Robles applies.  If \(\operatorname{rank}q=2\), write
\(q=La\); its radical \(\ker(L,a)\) has vector dimension four and gives
larger linear Gauss fibers.  Rank one is a double hyperplane, again with one
reduced support component and a five-dimensional radical.  Thus proportional
and additionally degenerate pencils produce no fourth type.

The three types exhaust \(\epsilon=3\), while \(\epsilon=4,5\) were already
excluded.  Therefore the span-eight component cannot have dimension eight:
\[
\boxed{s=8\Longrightarrow b=7.}
\]
Together with the span-nine result and the exclusion of span seven, this is
the global component-dimension conclusion
\[
\boxed{\text{every characteristic-zero counterexample has }
       s\in\{8,9\}\text{ and }b=7.}
\]

#### Eliminating the \(b=7,\epsilon=4\) row

There is a parallel finite reduction for the top tangent-nonreduced row when
\(b=7\).  It first leaves two exceptional second-fundamental-form types; a
conormal-kernel argument then eliminates both.  At a general smooth point
\(y\), let
\[
A_y\subset\mathbf P(T_yY)=\mathbf P^5
\]
be the reduced two-dimensional family of directions of the component lines
through \(y\).  The residual conormal map on a general line has Pluecker
degree one.  Hence, for the two quadrics \(q_0,q_1\) of the second fundamental
form, the two gradients are dependent at a general \([v]\in A_y\).  If both
gradients vanish generically, their common kernel has vector dimension at
least three; the linear Gauss fibers then contain a covering family of
\(\mathbf P^3\)'s, which is excluded below.  Otherwise there is a rational
map
\[
\lambda:A_y\dashrightarrow\mathbf P^1,
\qquad dq_{\lambda(v)}(v)=0.
\]

First record the covering-cone obstruction used in the classification.  A
covering family in \(Y\) whose general member is either a linear
\(\mathbf P^3\), or a three-dimensional quadric cone obtained by joining
\(y\) to a quadric direction surface, cannot exist.  Indeed, if a general
member \(K\) avoids \(\operatorname{Sing}(Z)\), generic smoothness of the
universal evaluation makes the characteristic map to
\(E=N_{K/Z}\) have rank at least three, independently of whether two general
members overlap.  For \(K=\mathbf P^3\), this would give the forbidden section
of \(E^*(-4)\) computed above.  For a quadric threefold
\(K=Q^3\subset\mathbf P^4\), one has
\[
0\longrightarrow E\longrightarrow
\mathcal O_K(1)^4\oplus\mathcal O_K(2)
\longrightarrow\mathcal O_K(9)\longrightarrow0,
\qquad \det E=\mathcal O_K(-3).
\]
Thus the third exterior power of the characteristic map would be a nonzero
section of \(E^*(-3)\), whereas
\[
0\longrightarrow\mathcal O_K(-12)
\longrightarrow\mathcal O_K(-4)^4\oplus\mathcal O_K(-5)
\longrightarrow E^*(-3)\longrightarrow0
\]
and the arithmetically Cohen--Macaulay property of a quadric give
\(H^0(E^*(-3))=0\).  If every general member meets the finite set
\(\operatorname{Sing}(Z)\), incidence supplies a fixed point \(p\) on all of
them.  Since these members are cones with vertex \(y\), the lines \(py\) lie
in \(Y\), so \(Y\) is a cone.  A Bertini-general hyperplane avoiding \(p\)
and \(\operatorname{Sing}(Z)\) cuts the family to covering planes or quadric
surfaces on a smooth degree-nine hypersurface in \(\mathbf P^7\); the same
rank-three exterior-power calculation gives the same contradiction.  This
also proves directly that the overlap of the original family creates no
escape.

Suppose now that \(\lambda\) is dominant.  Over its generic point write
\(r=\operatorname{corank}(q_\lambda)\) and
\(K_\lambda=\ker(q_\lambda)\).  Differentiating
\(q_\lambda(u(\lambda),-) =0\) for a local kernel section and pairing with a
second kernel section shows that the other pencil member vanishes on
\(\mathbf P(K_\lambda)\).  Hence the kernel scroll is contained in the
quadratic base and rank-one loci.  The symmetric Kronecker form writes its
singular part as blocks of sizes \(2a_i+1\), one for each generic kernel
direction; thus
\[
\sum_{i=1}^r(2a_i+1)\leq6.
\]
For the canonical form and this block count, see De Teran--Dopico--Mackey,
Section 2
([paper](https://gauss.uc3m.es/fdopico/papers/jst2018.pdf)).

For \(r=2\), the only two-dimensional kernel-scroll images are
\[
S(0,1)=\mathbf P^2,\qquad
S(1,1)=Q^2,\qquad S(0,2)=\text{a quadric cone};
\]
the covering-cone obstruction excludes all three.  For \(r=3\), the block
count leaves \((a_1,a_2,a_3)=(0,0,0)\), which has a three-dimensional common
Gauss kernel and is excluded, or \((1,0,0)\).  For \(r\geq4\), at least three
minimal indices are zero, again giving the excluded common Gauss kernel.
Consequently the only dominant-\(\lambda\) survivor has type
\((1,0,0)\).  Its radical planes sweep a \(\mathbf P^3\), and
\(A_y\) is a higher-contact hypersurface of some degree \(\rho\) in that
\(\mathbf P^3\).

For completeness, the constant-\(\lambda\) branch has an equally short
linear-algebra table.  Put \(R=\operatorname{rad}(q_\lambda)\).  Since it
contains the surface \(A_y\), \(\dim R\geq3\).  If \(\dim R=3\), then
\(A_y=\mathbf P(R)\), already excluded.  If \(\dim R=4\), a nonzero
restriction \(q_\mu|_R\) gives a plane or an integral quadric-surface
component, also excluded; the zero restriction leaves a higher-contact
hypersurface in \(\mathbf P(R)=\mathbf P^3\).  If \(\dim R=5\), then
\(q_\lambda=L^2\) and the unresolved direction surface is a proper
higher-contact surface in
\[
Q^3=V(L,q_\mu)\subset\mathbf P^4.
\]
Finally \(\dim R=6\) means that one pencil member is zero, so the second
fundamental form is one-dimensional and \(A_y\) is a higher-contact surface
inside the remaining quadric \(Q^4\subset\mathbf P^5\).  Thus, apart from
the last two cases, every still unclassified entry is a surface spanning a
\(\mathbf P^3\).

Those \(\mathbf P^3\)-spanning surfaces can in fact be eliminated by the
VMRT Frobenius tensor.  There is a small but important irreducibility step.
Let \(U\to B\) be the universal \(\mathbf P^1\)-bundle over the general
locus, after replacing \(B\) by its normalization.  Resolve the normalized
projective closure of \(U\) and factor the resulting proper evaluation as
\[
U\longrightarrow Y'\xrightarrow{\tau}Y
\]
with connected fibers followed by a finite map; the Stein target \(Y'\) is
normal.  Since \(U\) is irreducible, so is \(Y'\).  After shrinking to the
smooth locus where \(\tau\) is etale, proper generic smoothness makes the
connected general fiber over \(Y'\) smooth and hence irreducible.  Thus it
selects exactly one irreducible component of the direction surface.  On each
fiber \(\mathbf P^1\) of \(U\to B\), the first map is nonconstant and its
composition with the finite map \(\tau\) is the original line.  Hyperplane
degree one forces both maps to have degree one.  The integral lifted curve is
finite birational over the normal line \(\ell\simeq\mathbf P^1\), hence is
isomorphic to it; the first map is then an isomorphism as well.  Choose the
resolution of \(Y'\) by smooth blowups.  The strict transform of this general
noncontained smooth curve remains an immersed \(\mathbf P^1\), so its tangent
\(\mathcal O(2)\) is a subbundle below.

Take a resolution \(h:\widetilde Y'\to Y'\).  The strict transform \(C\) of a
general lifted line belongs to a complete seven-dimensional covering family:
nearby curves still have pullback-hyperplane degree one and map to lines of
\(Y\), while a line has a unique lift in this family and a unique strict
transform.  The family dominates \(\widetilde Y'\), so its general
normalization map \(f:\mathbf P^1\to\widetilde Y'\) is free and
\(\deg f^*T_{\widetilde Y'}=4\).  At a general point where \(h\) and \(\tau\)
are local isomorphisms, the tangent-direction map from curves through the
point is generically one-to-one--a projective line is determined by its point
and tangent--and hence generically immersive in characteristic zero.  Its
differential kernel is
\[
H^0(f^*T_{\widetilde Y'}(-2))/H^0(T_{\mathbf P^1}(-2)),
\]
so \(h^0(f^*T_{\widetilde Y'}(-2))=1\).  Among the nonnegative rank-six,
degree-four splittings containing the tangent \(\mathcal O(2)\), this forces
\[
f^*T_{\widetilde Y'}
=\mathcal O(2)\oplus\mathcal O(1)^2\oplus\mathcal O^3.
\]
Thus \(C\) is an unbendable rational curve.  On the open set where \(h\) is
an isomorphism and \(\tau\) is etale, the now irreducible VMRTs have affine
spans defining a rank-four distribution \(D\subset T_{\widetilde Y'}\).  The
local deformations of
\(C\) are subordinate to \(D\).  The VMRT Levi identity says that the
Frobenius tensor
\[
\operatorname{Levi}_D:\bigwedge^2D\longrightarrow T_{\widetilde Y'}/D
\]
annihilates every bivector \(v\wedge w\) with \([v]\) a general VMRT point
and \(v,w\) tangent to its affine cone; see Hwang, Theorem 1.4
([paper](https://arxiv.org/pdf/2204.09927)).

Here the VMRT is an integral hypersurface \(A=V(f)\subset\mathbf P(D)=
\mathbf P^3\) of degree at least two.  Test the Levi tensor against any
linear functional on its target, obtaining a skew form \(\omega\) on the
four-space \(D\).  If \(\omega\) has rank four, the identity would make the
tangent planes of \(A\) integral planes of the contact distribution on
\(\mathbf P^3\), which is impossible.  If it has rank two with radical
\(R_0\), every tangent plane contains \(\mathbf P(R_0)\); hence every
directional derivative of \(f\) along \(R_0\) vanishes.  Then \(f\) is a
binary form and is reducible over \(\mathbf C\), unless it is linear.  Both
possibilities contradict the hypotheses, so \(\operatorname{Levi}_D=0\)
and \(D\) is integrable.

Projective chain loci now algebraize the local four-dimensional leaves.  The
one-step locus from a general point is the projective
threefold cone over \(A_y\).  At its general point its tangent space is a
proper subspace of the four-space \(D\), while the directions of all component
lines span \(D\).  Therefore the closed two-step chain locus has dimension at
least four.  Locally every chain is tangent to the Frobenius leaf, so its
dimension is at most four.  An irreducible dominating component is consequently
an integral projective fourfold \(F\).  Now form the projective three-step
chain space.  The component obtained by adjoining a general component line
at a general endpoint of a two-step chain has closed image containing \(F\).
On the dense locus of smooth junctions its evaluation differential is still
contained in the rank-four distribution \(D\), so this image has dimension at
most four.  It must therefore equal \(F\).  Thus \(F\) is saturated by the
general component lines through a general \(w\in F\); their two-dimensional
family gives a line component on \(F\) of dimension at least five.

The image of \(F\) in \(Y\), again denoted \(F\), is an integral projective
fourfold carrying the same at-least-five-dimensional family of distinct
image lines.  Rogora's Theorem \(1'\) now says that \(F\) is a \(\mathbf P^4\), a scroll in
\(\mathbf P^3\)'s, or an irreducible quadric fourfold.  The first gives a
moving family of \(\mathbf P^4\)'s in \(X\), contrary to Starr.  The second
gives a covering family of \(\mathbf P^3\)'s, excluded above.  In the third
case the leaves themselves are a covering family of quadric fourfolds.  A
general leaf avoiding \(\operatorname{Sing}(Z)\) is excluded by the rank-two
quadric characteristic-map calculation used for \(b=8\); if every leaf meets
the finite singular set, a Bertini-general hyperplane avoiding that set and
a fixed common point cuts them to the same forbidden covering family of
quadric threefolds in a smooth degree-nine hypersurface.  This exhausts the
alternatives.

Consequently the exact second-fundamental-form remnants at this stage are
\[
\boxed{
q_\lambda=L^2,\ A_y\subset Q^3\text{ a higher-contact surface};
\quad\text{or}\quad
\dim\langle q_0,q_1\rangle=1,\ A_y\subset Q^4
\text{ a higher-contact surface}.}
\]

We now eliminate these last two types.  Write the span as
\(\mathbf P(V)=\mathbf P^8\), and let \(\ell=\mathbf P(U)\) be a general
component line.  The conormal Gauss map
\[
g_\ell:\ell\longrightarrow\operatorname{Gr}(2,U^\perp),
\qquad y\longmapsto N_y^*Y
\]
is a Grassmannian line.  It therefore has a fixed flag
\[
A_\ell\subset N_y^*Y\subset B_\ell\subset U^\perp,
\qquad \dim(A_\ell,B_\ell)=(1,3).
\]
Equivalently, the infinitesimal homomorphism describing the variation of
\(N_y^*Y\) has kernel \(A_\ell\).

This flag defines an intrinsic rational conormal-kernel map
\[
\kappa:Y\dashrightarrow\mathbf P(V^*)
\]
which is constant on a general line of \(B\).  In the one-dimensional-II
case, \(\kappa_y\) is the line
\(\ker(\mathrm{II}_y:N_y^*Y\to S^2T_y^*Y)\); it lies in the kernel of the
conormal variation along every line through \(y\), and hence equals
\(A_\ell\).  In the square-member case, \(\kappa_y\) is the unique conormal
member satisfying
\[
\mathrm{II}_{\kappa_y}=L_y^2.
\]
It is unique on a dense open set: two independent rank-one members would
have a common radical of vector dimension four and produce the already
excluded covering linear Gauss \(\mathbf P^4\)'s.  Since every direction in
\(A_y\) lies in \(\ker L_y\), the same conormal-variation identity again
gives \(\kappa_y=A_\ell\).  This also removes any possible monodromy in the
choice of the rank-one member.

The one-dimensional-II case now has a short contradiction.  Choose a local
nonzero covector \(H(y)\) representing \(\kappa_y\).  The standard conormal
variation formula says
\[
dH_y(u)|_{\widehat T_yY}=-\mathrm{II}_{H(y)}(u,-)=0.
\]
Thus \(dH_y(u)\in N_y^*Y\), and the projective differential of \(\kappa\)
takes values in the one-dimensional quotient
\(N_y^*Y/\langle H(y)\rangle\).  Hence \(\operatorname{rank}\kappa\leq1\).
Rank zero would give a fixed hyperplane containing \(Y\), contrary to
\(\langle Y\rangle=\mathbf P^8\).  In rank one, normalize the image curve
and write its local hyperplanes as \(H_t\).  On an integral component of a
general five-dimensional fiber \(F_t\), both \(H_t\) and \(H'_t\) belong to
\(N_y^*Y\), so
\[
N_y^*Y=\langle H_t,H'_t\rangle
\]
is constant.  The closure of a characteristic-zero Gauss fiber is linear;
therefore \(Y\), and hence \(X\), would contain a moving linear space of
dimension at least five.  This contradicts the earlier Starr bound on
linear spaces in \(X\).

It remains to treat the square-member case.  The \(\mathbf P^3\)-span
argument above shows that its genuine remnant has
\(\langle A_y\rangle=\mathbf P(\ker L_y)=\mathbf P^4\).  Constancy on the
component lines therefore makes \(d\kappa\) vanish on the five-dimensional
space \(\ker L_y\).  On the other hand,
\[
dH_y(u)|_{T_yY}=-L_y(u)L_y
\]
is nonzero for \(u\notin\ker L_y\).  Consequently
\(\operatorname{rank}\kappa=1\).

After normalizing its image curve and, if necessary, making a finite base
change to select geometrically integral components, let \(F_t\) be a
five-dimensional component of a general fiber and let \(B_t\) be the
six-dimensional family of component lines covering it.  Differentiating
\(H_t(y(t))=0\), with \(H_t\) tangent to \(Y\), gives
\[
F_t\subset R_t:=H_t\cap H'_t\simeq\mathbf P^6.
\]
Thus \(F_t\) is an integral hypersurface of some degree \(\rho\) in \(R_t\),
with ideal
\[
I_{F_t/\mathbf P^8}=(h_0,h_1,f_\rho).
\]
Let \(z\) be the degree-nine equation of \(Z=X\cap\mathbf P^8\).  For
\(\rho\leq9\), write
\[
z=A_0h_0+A_1h_1+C f_\rho,
\qquad \deg(A_0,A_1,C)=(8,8,9-\rho).
\]
If \(\rho<9\), the three positive-degree coefficients have a common zero
locus of dimension at least two on the fivefold \(F_t\), and every such
point is singular on \(Z\), contradicting the finiteness of
\(\operatorname{Sing}(Z)\).  If \(\rho>9\), or if \(\rho=9\) and \(C=0\),
then \(z=A_0h_0+A_1h_1\); the common zero locus of \(A_0,A_1\) in
\(R_t\simeq\mathbf P^6\) gives a singular locus of dimension at least four.
Hence necessarily
\[
\rho=9,\qquad C\ne0,\qquad F_t=Z\cap R_t=X\cap R_t
\]
scheme-theoretically.

Set \(S_t=\operatorname{Sing}(F_t)\).  Since \(X\) is smooth,
\[
S_t=R_t\cap\gamma_X^{-1}\bigl(\mathbf P(R_t^\perp)\bigr),
\]
where \(\gamma_X\) is the finite Gauss morphism and
\(\mathbf P(R_t^\perp)=\mathbf P^2\).  Thus \(\dim S_t\leq2\).  If a general
line \(\ell\in B_t\) avoided \(S_t\), then
\[
0\longrightarrow N_{\ell/F_t}\longrightarrow
\mathcal O_\ell(1)^5\longrightarrow\mathcal O_\ell(9)
\longrightarrow0
\]
would give \(\operatorname{rank}N_{\ell/F_t}=4\) and
\(\deg N_{\ell/F_t}=-4\).  But generic smoothness of the normalization of
the dominant reduced universal evaluation for \(B_t\) makes its actual
line-deformation sections generically generate the normal fibers, forcing
nonnegative determinant degree.  This is impossible, so a general line of
\(B_t\) meets \(S_t\).

Consider the resulting incidence of pairs \((\ell,q)\) with
\(q\in\ell\cap S_t\).  A general component line cannot be contained in
\(S_t\), since \(\dim S_t\leq2\) and such lines could not cover \(F_t\).
The incidence therefore has dimension six and maps to some
\(C_0\subset S_t\) of dimension \(h\leq2\).  For a general \(q\in C_0\),
its fiber has dimension \(6-h\) inside the \(\mathbf P^5\) of all lines in
\(R_t\) through \(q\), so \(h\geq1\).  If \(h=1\), the fiber is all of that
\(\mathbf P^5\), forcing \(F_t=R_t\).  If \(h=2\), its four-dimensional
family of lines has five-dimensional union and fills \(F_t\), making every
general \(q\in C_0\) a vertex.  The vertex locus of a hypersurface is linear,
so it contains \(\langle C_0\rangle\supset\mathbf P^2\).  After a finite
base change, choose a relative \(\mathbf P^2\) in these linear vertex spaces.
Its joins with the quotient points give an algebraic covering family of
\(\mathbf P^3\)'s in the \(F_t\); as \(t\) varies they cover \(Y\),
contradicting the characteristic-map obstruction above.

Both exceptional types are therefore impossible, and we obtain the sharper
linewise reduction
\[
\boxed{b=7\Longrightarrow\epsilon\leq3.}
\]

#### Further reductions for \(b=7,\epsilon=3\)

The degree-two conormal curve is either nonschubert, an \(\alpha\)- or
\(\beta\)-conic, or a separable double cover of a Grassmannian line.  A common
linear factor in the second fundamental form is impossible in every case:
as above, \(q_0=La,q_1=Lb\) has a three-dimensional common radical and hence
covering linear Gauss \(\mathbf P^3\)'s.

For each of the three rank-one conormal types, dependent gradients define the
same rational map \(\lambda:A_y\dashrightarrow\mathbf P^1\) used in the
\(\epsilon=4\) analysis.  If it is dominant, the symmetric Kronecker table
leaves only planes, quadric surfaces, or a surface spanning a \(\mathbf P^3\).
The characteristic-map and VMRT arguments above exclude all three.  If it is
constant, the same radical table leaves only higher-contact surfaces in the
square-member \(Q^3\) or one-dimensional-II \(Q^4\) configurations.  The
degree-one conormal-kernel argument used for \(\epsilon=4\) does not apply to
this degree-two conormal curve.  Thus there is no dominant-dependency or
common-factor survivor, but these two constant cases remain.

There is a separate useful test for the nonschubert type, where the two
gradients are independent along \(A_y\).  Put
\(C=V(q_0,q_1)\subset\mathbf P^5\).  Suppose that \(C\) is factorial with
\(\operatorname{Cl}(C)=\mathbf Z[H]\), as for a smooth \((2,2)\) threefold,
and write \(A_y\sim\rho H\).  The two Fubini cubics vanish on every line
direction.  If at least one restricts nontrivially to \(C\), then
\(\rho\leq3\).  The cone from \(y\) over \(A_y\) is then the threefold
complete intersection of type \((2,2,\rho)\) in its \(\mathbf P^6\), and its
covering family would give a rank-three characteristic section of
\(E^*(\rho-3)\).  But
\[
0\longrightarrow\mathcal O(\rho-12)
\longrightarrow
\mathcal O(\rho-4)^2\oplus\mathcal O(\rho-5)^2
                 \oplus\mathcal O(-3)
\longrightarrow E^*(\rho-3)\longrightarrow0
\]
on that complete intersection has vanishing outer cohomology for
\(\rho\leq3\).  If every cone meets \(\operatorname{Sing}(Z)\), fixing one
singular point and taking a Bertini-general hyperplane section gives the
identical ACM contradiction on the resulting complete-intersection surfaces.
Consequently a nonschubert survivor must satisfy
\[
\boxed{C\text{ singular or nonfactorial},\qquad\text{or}\qquad
I(C_{2,y})=I(C_{3,y}).}
\]
This alternative is not an exclusion: unlike the \(b=8\) row, the
seven-dimensional line component does not put it directly under the
Landsberg--Robles equality case.

There is also a sharp conditional reduction in the normal
\(b=7,\epsilon=3\) row.  If its direction surface is a rational normal cubic
scroll, it is either \(S(1,2)\) or the cone \(S(0,3)\).  The ruling lines of
the scroll produce a covering family of planes in \(Y\).  If a general plane
avoids \(\operatorname{Sing}(Z)\), the characteristic map has rank four and
would give a nonzero section of \(E^*(-3)\), but
\[
0\longrightarrow\mathcal O_{\mathbf P^2}(-12)
\longrightarrow\mathcal O_{\mathbf P^2}(-4)^6
\longrightarrow E^*(-3)\longrightarrow0
\]
shows that no such section exists.  Otherwise finiteness fixes a point
\(p\in\operatorname{Sing}(Z)\) on every general ruling plane.  For
\(S(1,2)\), the corresponding planes in the cone over the scroll intersect
only at \(y\), an immediate contradiction.  For \(S(0,3)\), their common
intersection is the vertex line, so it must be \(py\); hence \(Y\) is a cone
with vertex \(p\).

In the latter case a Bertini-general \(\mathbf P^7\) avoiding \(p\) and
\(\operatorname{Sing}(Z)\) cuts out a normal fivefold \(Y_0\) in a smooth
degree-nine hypersurface.  Projection from the
vertex descends \(B\) to a component \(B_0\subset F_1(Y_0)\).  Indeed, away
from vertex lines the map
\[
F_1(\operatorname{Cone}_pY_0)\longrightarrow F_1(Y_0)
\]
has a smooth two-dimensional fiber: for a base line \(\ell_0\), these are the
lines in \(\langle p,\ell_0\rangle\simeq\mathbf P^2\) not passing through
\(p\).  Both reduced and tangent dimensions therefore drop by two, from
\((7,8)\) to \((5,6)\).  Thus \(B_0\) is reduced five-dimensional with
tangent dimension six.  Along a general base
line its saturated tangent kernel is
\[
\mathcal O(1)^2\oplus\mathcal O^2,
\]
and the same Mather calculation gives one codimension-two support center, now
of dimension three.  The quotient of the \(S(0,3)\) direction surface by the
vertex direction is a twisted cubic.  Thus the smooth-scroll case is
excluded, while the normal fivefold/twisted-cubic cone descent is an exact
remaining branch.

#### Exact structure of the \(b=7,\epsilon=2\) row

The generically reduced row is not removed by a linewise splitting
calculation.  In fact its splitting is forced and compatible with both
unequal Landsberg--Tommasi types.  Along a general component line,
\[
N_{\ell/Z}\simeq
\mathcal O(1)^2\oplus\mathcal O^3\oplus\mathcal O(-4).
\]
The extension
\[
0\longrightarrow N_{\ell/Z}\longrightarrow N_{\ell/X}
\longrightarrow\mathcal O(1)\longrightarrow0
\]
is controlled only by
\[
e\in H^1(\mathcal O(-5))\simeq H^0(\mathcal O(3))^*.
\]
Here \(h^0(N_{\ell/X})=7\), already accounted for by
\(\mathcal O(1)^2\oplus\mathcal O^3\), so the connecting map
\[
H^0(\mathcal O(1))\longrightarrow H^1(\mathcal O(-4))
\]
is injective.  This is precisely the assertion that the first catalecticant
of \(e\) has rank two, or equivalently that \(e\) is not on the twisted-cubic
pure-cube locus.
Consequently
\[
N_{\ell/X}\simeq
\mathcal O(1)^2\oplus\mathcal O^3
\oplus\mathcal O(-1)\oplus\mathcal O(-2).
\]
Generic Hilbert--Burch matrices with maximal-minor generator degrees
\((5,8,8)\) or \((6,7,8)\) and syzygy degrees \((10,11)\) have coprime first
two minors, so both normal forms are genuinely compatible at a point.

The span hyperplane nevertheless identifies their exact residual types.
Let \(L=\mathbf P(\widehat L)=\mathbf P^8\) and \(Z=X\cap L\).  Since
\(T_{[\ell]}B\subset U^*\otimes(\widehat L/U)\), the transverse direction to
\(\widehat L\) in the ambient vector space is absent from the component
tangent space.  More explicitly, after quotienting by the incidence block,
the three-dimensional constant-rank space lies in
\(U^*\otimes K\subset U^*\otimes V\), with \(\dim(K,V)=(5,6)\).  A functional
\(V\to V/K\) annihilating a Kronecker tangent space must vanish on every
coordinate occurring in a nontrivial chain.  The transverse direction is
therefore a singleton Kronecker block.  Deleting it gives
\[
411_X\longmapsto41_Z,
\qquad
321_X\longmapsto32_Z.
\]
More concretely,
\[
\begin{array}{c|c|c}
X\text{-type}&Z\text{-generators}&\text{transverse generator}\\ \hline
411&(p_5,q_8)&h_8=(\partial_\perp F)|_\ell\\
321&(p_6,q_7)&h_8=(\partial_\perp F)|_\ell.
\end{array}
\]
The two displayed generators for \(Z\) are coprime on every general line
avoiding \(\operatorname{Sing}(Z)\): a common root would make all derivatives
of \(Z\) vanish at that point.  Landsberg--Tommasi Lemma 6.1 gives the exact
dichotomy.  Either the first-root divisor dominates \(Y\), which is the
unresolved **surjective first-root-divisor** subcase, or every general
direction cone meets the finite set \(\operatorname{Sing}(Z)\).  In the
second case incidence fixes one point \(p\) generically, and \(Y\) is a cone
with vertex \(p\).

The normalization behavior is also exact.  The case \(\epsilon=2\) cannot
be normal by the Mather calculation above.  Since the integral lci sixfold
\(Y\) is \(S_2\), its nonnormal locus contains a codimension-one component,
and hence
\[
\boxed{\dim\operatorname{Sing}(Y)=5.}
\]
On a resolution of the normalization, the normal bundle of a general lifted
line and its saturated image bundle are both
\[
N_{\widetilde\ell/\widetilde Y}
\simeq E_\ell\simeq\mathcal O(1)^2\oplus\mathcal O^3.
\]
The birational differential has a torsion cokernel of degree zero and is
therefore an isomorphism.  In particular the general lifted line misses the
exceptional locus and lies over the smooth locus of the normalization, where
the resolution is locally the finite normalization.  Piene's identity
\(\operatorname{Jac}_Y\mathcal O_{\bar Y}=\mathfrak R_\nu\mathfrak c\),
localized along this line, then says that the normalization is unramified and
immersed there.  The whole Jacobian length \(m+4\) is conductor intersection
length rather than ramification length.

There is a further direction-surface reduction, provided one works on the
same relative-component/Stein cover used in the VMRT argument above rather
than assuming that the general incidence fiber is irreducible.  For a chosen
integral component of the direction surface, spans \(\mathbf P^2\) and
\(\mathbf P^3\) are excluded by the characteristic-map and VMRT arguments.
If it spans a \(\mathbf P^4\), the scalar Levi forms of its rank-five span
distribution have rank zero, two, or four.  For rank two, choose coordinates
with \(\omega=dx_0\wedge dx_1\); the VMRT identity
\(\omega(v,dv)=0\) makes \(x_1/x_0\) locally constant on the integral
surface, putting it in a \(\mathbf P^3\).  In rank four, differentiating the
same identity makes every affine tangent three-space isotropic.  Such a
three-space must contain the fixed one-dimensional radical of \(\omega\),
so the surface is a cone with that radical point as vertex.  Its ruling
planes are excluded by the characteristic-map wedge unless they all contain
one fixed point of \(\operatorname{Sing}(Z)\), which is precisely the cone
descent.  Rank zero leaves integrable rank-five leaves.  Thus the exact
geometric remainder consists of
\(\mathbf P^5\)-spanning direction components, integrable
\(\mathbf P^4\)-span leaves, or the fixed-singular-vertex cone descent.

The cone descent has a useful numerical endpoint.  Choose a
Bertini-general \(\mathbf P^7\subset L\) avoiding the vertex and
\(\operatorname{Sing}(Z)\), and put
\[
Y_0=Y\cap\mathbf P^7,
\qquad Z_0=Z\cap\mathbf P^7.
\]
The hypersurface \(Z_0\) is smooth.  The connected shear group of the cone
preserves the irreducible component \(B\) and acts transitively on the
two-dimensional family of graph lines above every base line.  Hence the
induced map \(B\to B_0\subset F_1(Y_0)\) has smooth general fiber of dimension
two.  Both component and tangent dimensions drop from seven to five.  Thus
\(B_0\) is a generically reduced five-dimensional component sweeping the
fivefold \(Y_0\), with residual LT type \(41\) or \(32\).  Since \(Z_0\) is
smooth, any surviving descended first-root divisor must be surjective.

On the compactified direction curve put
\(h=\deg\mathcal O_C(1)>0\) and \(\mu_i=\deg M_i\) for the two LT root line
bundles.  Smoothness of \(Z_0\) makes the corresponding resultant nowhere
zero, so its degree gives
\[
40h-8\mu_1-5\mu_2=0\quad(41),
\qquad
42h-7\mu_1-6\mu_2=0\quad(32).
\]
Writing \(\eta=\mu_1+\mu_2\), these become
\[
3\mu_1+5\eta=40h,
\qquad
\mu_1+6\eta=42h,
\]
respectively.  A clean endpoint flag would have \(\eta=0\) and
\(M_1\subset\mathcal O_C^2\): explicitly, it would extend as
\[
0\longrightarrow M_1\longrightarrow\mathcal O_C^2
\longrightarrow M_2\longrightarrow0.
\]
This forces \(\mu_1\leq0\), whereas the two identities force respectively
\(\mu_1=40h/3>0\) or \(\mu_1=42h>0\).  Therefore every cone survivor requires
a nontrivial,
large signed endpoint or first-root defect.  Local DVR models allow such
defects with no available one-sided bound, so this is an exact finite
reduction rather than an exclusion.

### 4. The sixfold must still be singular

The span split does not affect this conclusion.  Suppose \(Y\) were
smooth.  A general member of its dominating \(b\)-dimensional line component
would be free.  Thus \(H^1(N_{\ell/Y})=0\), the Hilbert scheme is smooth at
\([\ell]\), and \(h^0(N_{\ell/Y})=b\).  The normal bundle has rank five and
degree \(b-5\); global generation and its injection into
\(N_{\ell/\mathbf P^9}=\mathcal O(1)^8\) force

\[
N_{\ell/Y}\simeq
\mathcal O_{\mathbf P^1}(1)^{\,b-5}\oplus
\mathcal O_{\mathbf P^1}^{\,10-b}.
\]

Hence \(-K_Y\cdot\ell=b-3\).  Barth--Larsen gives
\(\operatorname{Pic}(Y)=\mathbf Z[H]\), so \(-K_Y=(b-3)H\).  Zak's
linear-normality theorem (*Tangents and Secants of Algebraic Varieties*,
Corollary II.2.17) makes the embedding in its span complete.  The
Kobayashi--Ochiai classification first shows that \(b=10\) forces
\(\mathbf P^6\), and
\(b=9\) a quadric in \(\mathbf P^7\); both contradict \(s\geq8\).  The
Fujita and Mukai classifications leave only the following models:

| \(b\) | index | possible embedded models for \(Y\) |
|---:|---:|---|
| 8 | 5 | \((2,2)\) in \(\mathbf P^8\), or \(\operatorname{Gr}(2,5)\) in \(\mathbf P^9\) |
| 7 | 4 | \((2,3)\) in \(\mathbf P^8\), or \((2,2,2)\) in \(\mathbf P^9\) |

Every ideal in the table, after adding the linear equations of its span, is
generated by at most five forms, all of degree below nine.  The next lemma
therefore excludes every row.  Mukai's Remark 2(i), p. 3001, says that the
index-four models of genus at most five are complete intersections.  Their
codimension \(g-2\), degree \(2g-2\), and adjunction
\(\sum e_i=g+1\) give a quartic in \(\mathbf P^7\), \((2,3)\) in
\(\mathbf P^8\), and \((2,2,2)\) in \(\mathbf P^9\); the first has already
been eliminated and the latter two appear in the table
([PNAS paper](https://www.math.stonybrook.edu/~mmovshev/BOOKS/PNAS-1989-Mukai-3000-2.pdf));
the degree-three and degree-four del Pezzo cases are in Fujita's
[Part I](https://www.jstage.jst.go.jp/article/jmath1948/32/4/32_4_709/_pdf),
and the degree-five case is his
[Part II](https://www.jstage.jst.go.jp/article/jmath1948/33/3/33_3_415/_pdf).

Therefore a counterexample requires

\[
\boxed{Y^6\subset\mathbf P^9\text{ singular and integral, with }
\dim F_1(Y)\geq7.}
\]

It is codimension three as a subvariety of \(\mathbf P^9\), but it may be
degenerate: in span \(\mathbf P^9\) its relevant reduced line component has
dimension exactly seven, while in span \(\mathbf P^8\) it has dimension
exactly seven and \(\epsilon\in\{2,3\}\), with the complete-intersection and
linewise Jacobian structure proved above.  Span \(\mathbf P^7\) is
impossible.

## Correct low-generator obstruction

The version in `SPEC.md` is false without a degree condition: if
\(W=X\cap H\), then \(I_W=(F,H)\), and one of the displayed generators is
already the degree-\(d\) equation \(F\).

The usable statement is the following.

**Lemma.**  Let \(W\subset\mathbf P^N\) be projective and integral.  Suppose
\(I_W\) is generated by \(r\) forms \(G_i\) of degrees \(e_i<d\), with
\(r\leq\dim W\).  Then every degree-\(d\) hypersurface containing \(W\) is
singular.

**Proof.**  Write \(F=\sum_i A_iG_i\), where every \(A_i\) has positive
degree.  The \(r\) ample divisors \(A_i|_W=0\) have a common point because
\(r\leq\dim W\).  At such a point, both \(A_i\) and \(G_i\) vanish, and hence
\[
dF=\sum_i(A_i\,dG_i+G_i\,dA_i)=0.
\]
Thus the containing hypersurface is singular. \(\square\)

No independence of the differentials \(dG_i\) is needed.  When \(W\) is a
local complete intersection, the intrinsic obstruction is the zero locus of
\(dF|_W\in H^0(W,N^*_{W/\mathbf P^N}(d))\).  For a complete intersection of
type \((e_1,\ldots,e_c)\), its top Chern class is
\(\prod_i(d-e_i)H^c\).

This changes the search heuristic.  "High codimension" is not the relevant
condition--the desired \(Y\) already has codimension three.  Its ideal must
instead avoid **every** generating set of at most six forms all of degree below
nine.  This makes ideals with many generators and nontrivial syzygies natural
targets; deficiency modules are one possible source of that complexity, not a
proved necessity.

## Exact Landsberg--Tommasi remainder

The tangent-space normal form makes the surviving theoretical obstruction
finite.  Let

- \(t=\dim T_{[\ell]}F_1(X)\) at a general point of the component;
- \(R\) be the rank of the universal-incidence differential there;
- \(c=t+1-R\) be the tangent dimension of the family through a point;
- \(r=9-R\), and \(q=7-t+R\).

Then the constant-rank normal form is indexed by a partition of \(q\) into
\(r\) positive parts.  Because the reduced incidence image has dimension six,
\(R\in\{6,7,8\}\) and \(c\geq2\).  The complete list is:

| \(R\) | possible \(t\) | partitions | status |
|---:|---:|---|---|
| 8 | 9--14 | one part, of size 6 down to 1 | excluded; LT Theorem 3.2 applies directly to every one-block size |
| 7 | 8 | \(51,42,33\) | \(33\) excluded; unequal cases remain only in the surjective subcase below |
| 7 | 9 | \(41,32\) | same unequal two-line-bundle issue |
| 7 | 10 | \(31,22\) | \(22\) excluded; \(31\) conditional |
| 7 | 11 | \(21\) | conditional |
| 7 | 12 | \(11\) | excluded |
| 6 | 7 | \(411,321,222\) | \(222\) excluded; \(411,321\) remain |
| 6 | 8 | \(311,221\) | remain |
| 6 | 9 | \(211\) | remains |
| 6 | 10 | \(111\) | excluded |

For \(R=7\), the unequal partitions consist of two line bundles.  LT Lemma
6.1 excludes them if the first-root divisor \(Z(s_1)\to Y\) is not
surjective.  Surjectivity does **not** itself produce a singular point:
LT Proposition 3.4 requires all normal-form polynomials to vanish at one point
of a line.  This is the remaining subcase.

In the nondegenerate \(s=9\) branch, a generically reduced Fano component has
\((R,t)=(6,7)\).  Its only block types are
\[
(4,1,1),\quad(3,2,1),\quad(2,2,2),
\]
with binary generator degrees respectively
\[
(5,8,8),\quad(6,7,8),\quad(7,7,7).
\]
LT Theorem 3.6 excludes the equal type \((2,2,2)\).  The first two are genuine
global Chern-class problems.  Section 6 does not settle \((3,2,1)\): its
two-line-bundle argument cannot simply be iterated to the third root.

In the remaining span-eight branch one now has \(b=7\).  The generically
reduced row is therefore \((R,t)=(6,7)\), with types \(411,321,222\); the
equal type \(222\) is excluded.  The \(311,221\) row can occur there through
\(\epsilon=3\).  The \(211\) and \(111\) rows would require
\(\epsilon=4,5\), respectively, and are excluded in span eight by the
conormal-kernel and Gauss-fiber arguments above.  The \(211\) row remains
only in span nine; \(111\) is retained in the complete table but is excluded
globally.

### The two reduced Chern numbers explicitly

For the nondegenerate reduced branch, the two residual intersection problems
can be written without any formal projective-bundle variables.  Let
\(C=\mathbf C_x\) be the compactified LT
surface over the direction surface of lines through a general point, and put
\(H=c_1(\mathcal O_C(1))\).  A choice
\(W=\widehat x\oplus W'\) splits the pulled-back tautological bundle as

\[
\mathcal S|_C\simeq\mathcal O_C\oplus\mathcal O_C(-H).
\]

For \(q:\mathbf P(\mathcal S)\to C\) and
\(\xi=c_1(\mathcal O_{\mathbf P(\mathcal S)}(1))\), the projective-bundle
relation is \(\xi^2=H\xi\).  Thus
\(q_*\xi=1\), \(q_*\xi^2=H\), and \(q_*\xi^3=H^2\).

For type \(321\), the three \(M_i\) are line bundles and the binary-generator
degrees are \((6,7,8)\).  Writing \(m_i=c_1(M_i)\), the required zero-cycle
class (whose integral over \(C\) is the Chern number) is

\[
\begin{aligned}
q_*\bigl((6\xi-m_1)(7\xi-m_2)(8\xi-m_3)\bigr)
={}&336H^2-H(56m_1+48m_2+42m_3)\\
 &+8m_1m_2+7m_1m_3+6m_2m_3.
\end{aligned}
\]

Equivalently, for \(A_i=\delta_iH-m_i\), it is

\[
336H^2-56HA_1-48HA_2-42HA_3
 +8A_1A_2+7A_1A_3+6A_2A_3.
\]

For type \(411\), let \(M_1\) be the line bundle attached to generator degree
five and \(M_2\) the rank-two bundle attached to generator degree eight.  Put
\(a=c_1(M_1)\), \(b=c_1(M_2)\), and \(c=c_2(M_2)\).  Splitting \(M_2\)
formally and pushing down gives

\[
320H^2-H(64a+40b)+8ab+5c.
\]

If \(L=M_1^*\otimes\mathcal O_C(5H)\), \(\lambda=c_1(L)\),
\(A=M_2^*\otimes\mathcal O_C(8H)\),
\(p=c_1(A)\), and \(q_2=c_2(A)\), the same class is

\[
320H^2-64H\lambda-40Hp+8\lambda p+5q_2.
\]

These formulas do not close the proof from the positivity presently known.
LT Lemma 4.1 makes
\(\widehat M_j^*\otimes\mathcal O_C(\delta_jH)\) generically ample, whereas
the displayed products involve the later minimal-generator bundles \(M_j\).
For example, in type \(411\),

\[
0\longrightarrow M_1\otimes\operatorname{Sym}^3\mathcal S^*
 \longrightarrow\widehat M_2\longrightarrow M_2\longrightarrow0.
\]

After dualizing and twisting, the required rank-two bundle is a subbundle of
the generically ample enlarged bundle; generic ampleness is not inherited by
subbundles.  Already in type \(321\), the analogous sequence

\[
0\longrightarrow M_1\otimes\mathcal S^*
 \longrightarrow\widehat M_2\longrightarrow M_2\longrightarrow0
\]

has the same defect, followed by a third minimal-generator line bundle.
Consequently the known positivity supplies neither the needed slopes nor, in
type \(411\), control of \(c_2(M_2)\).  Hodge index alone cannot replace those
missing hypotheses, and the modification \(C\to C_x\) may introduce
\(H\)-trivial exceptional classes.

There is a useful numerical check that this is a real logical gap, not merely
a failure to arrange the terms attractively.  Even if the *actual* factor
bundles were assumed ample, the \(321\) polynomial vanishes on a rank-one
intersection lattice for
\(H=h\) and \((A_1,A_2,A_3)=(8h,3h,2h)\).  The \(411\) polynomial vanishes
for

\[
H=13h,\qquad \lambda=78h,\qquad
A=\mathcal O(13h)\oplus\mathcal O(56h).
\]

These are numerical countermodels to a positivity-only argument; they are
not asserted to arise from LT geometry.  VMRT classification does not add a
missing constraint here: the swept sixfold is necessarily singular, while
neither its direction surface nor the compactification \(C\) is known to be
smooth, Picard-rank one, or bounded in degree and genus.

There is, however, additional structure on the constant-normal-form locus
which identifies the precise remaining boundary problem.  For a general line
in the reduced nondegenerate component,
\[
N_{\ell/X}\simeq
\mathcal O(1)^2\oplus\mathcal O^3\oplus
\mathcal O(-1)\oplus\mathcal O(-2).
\]
Indeed, this rank-seven bundle has degree \(-1\), \(h^0=7\), evaluation
rank five, and no summand above one; those data force the displayed
splitting.

For both \(411\) and \(321\), the three binary generators are basepoint-free,
since a common root would be a singular point of \(X\) by LT
Propositions 3.4--3.5.  Their degrees sum to \(21\).  If the two
Hilbert--Burch syzygy degrees are \(\alpha\leq\beta\), then
\(\alpha+\beta=21\).
There is no syzygy of degree at most nine: after multiplication to degree
nine it would contradict
\(\operatorname{rank}\sigma=9\).  Hence
\[
\boxed{(\alpha,\beta)=(10,11),}
\]
matching the two negative normal-bundle summands after expansion to degree
eight.

More significantly, let \(N_x=W/\widehat T_xY\), a fixed
three-dimensional vector space.  Evaluation at the fixed general point
\(x\) identifies the quotient of each LT normal-form block by its incidence
block with the corresponding minimal-generator bundle \(M_i\).  The
admissible changes of normal form are triangular in increasing generator
degree.  Thus, on the constant-rank/type open surface, the trivial excess
bundle \(N_x\otimes\mathcal O\) has the filtrations
\[
\begin{array}{ll}
411:&0\longrightarrow M_1\longrightarrow
N_x\otimes\mathcal O\longrightarrow M_2\longrightarrow0,\\[2mm]
321:&0\longrightarrow M_1\longrightarrow F_2\longrightarrow M_2
\longrightarrow0,\quad
0\longrightarrow F_2\longrightarrow N_x\otimes\mathcal O
\longrightarrow M_3\longrightarrow0.
\end{array}
\]

This closes both Chern calculations under one explicit hypothesis:
assume that, on a smooth common compactification of the direction surface,
these block identifications and the excess flag extend without a
divisorial elementary transform or ramification correction.  Then
\[
c(M_1)c(M_2)=1\quad(411),\qquad
c(M_1)c(M_2)c(M_3)=1\quad(321).
\]
The determinant comparison with the incidence tangent sequence also gives
\[
K_C=3m_1+3H\quad(411),\qquad
K_C=2m_1+m_2+H\quad(321).
\]

For \(411\), put \(D=-m_1\).  The excess sequence makes \(D\) nef and gives
\[
c_1(M_2)=D,\qquad c_2(M_2)=D^2,\qquad K_C=3H-3D.
\]
The LT zero-cycle becomes
\[
T_{411}=320H^2+24HD-3D^2.
\]
If \(d=H^2\), adjunction on a general integral hyperplane section gives
\(HD\leq(4d+2)/3\leq2d\), while Hodge index gives \(D^2\leq4d\).
Consequently
\[
\deg T_{411}\geq308d>0.
\]

For \(321\), put \(D=-m_1\) and \(W=m_3\).  Both are nef, and the flag gives
\[
m_2=D-W,\qquad D^2-DW+W^2=0,\qquad K_C=H-D-W.
\]
Here
\[
T_{321}=336H^2+8HD+6HW-D^2+W^2.
\]
Adjunction gives \(H(D+W)\leq2d+2\leq4d\), and Hodge index gives
\(D^2\leq16d\).  Therefore
\[
\deg T_{321}\geq320d>0.
\]
Thus neither reduced nondegenerate type can occur under the no-boundary-defect
hypothesis.

This is not yet unconditional.  LT's Grassmann compactification records
limits of the enlarged \(\widehat M_i\), but it does not simultaneously
compactify the incidence subspace \(\Pi\), the individual blocks, and their
evaluation identifications with a fixed flag in \(N_x\).  On a common
resolution, generically isomorphic extensions can differ along boundary
divisors.  Precisely, a counterexample must make at least one of the
following clean identities acquire a nonzero boundary or elementary-transform
defect:
\[
\begin{array}{ll}
411:&
m_1+c_1(M_2),\quad
c_2(M_2)+m_1c_1(M_2),\quad
K_C-(3m_1+3H),\\[2mm]
321:&
m_1+m_2+m_3,\quad
m_1m_2+m_1m_3+m_2m_3,\quad
K_C-(2m_1+m_2+H).
\end{array}
\]

The dependence on these defects is exact.  In type \(411\), set
\[
D=-m_1,\qquad
\mathfrak e=m_1+c_1(M_2),\qquad
\mathfrak z=c_2(M_2)+m_1c_1(M_2),\qquad
\mathfrak r=K_C-(3m_1+3H).
\]
Direct substitution gives
\[
\boxed{\begin{aligned}
T_{411}={}&320H^2+24HD-3D^2
 -40H\mathfrak e-3D\mathfrak e+5\mathfrak z,\\
K_C={}&3H-3D+\mathfrak r.
\end{aligned}}
\]
In type \(321\), set
\[
D=-m_1,\quad W=m_3,\quad
\mathfrak e=m_1+m_2+m_3,\quad
\mathfrak z=m_1m_2+m_1m_3+m_2m_3,
\]
and \(\mathfrak r=K_C-(2m_1+m_2+H)\).  Then
\[
D^2-DW+W^2=\mathfrak e(W-D)-\mathfrak z
\]
and
\[
\boxed{\begin{aligned}
T_{321}={}&336H^2+8HD+6HW-D^2+W^2
 -48H\mathfrak e-\mathfrak e(D+W)+7\mathfrak z,\\
K_C={}&H-D-W+\mathfrak e+\mathfrak r.
\end{aligned}}
\]
These formulas show why the clean lower bounds do not survive formally.
After choosing a saturated flag on a common resolution, the generic
identifications give only a \(K\)-theory identity
\[
[\mathop{\bigoplus}M_i]-[\mathcal O^3]=[T_+]-[T_-]
\]
for boundary torsion sheaves.  Consequently
\[
\mathfrak e=\operatorname{ch}_1(T_+)-\operatorname{ch}_1(T_-),\qquad
\mathfrak z=\frac{\mathfrak e^2}{2}
 -\operatorname{ch}_2(T_+)+\operatorname{ch}_2(T_-).
\]
Neither class has a sign; changing a boundary lattice by
\(\mathcal O(\Gamma)\) or \(\mathcal O(-\Gamma)\) realizes either determinant
valuation.  Likewise \(\mathfrak r\) is the divisor of a rational determinant
trivialization, hence zeros minus poles rather than an effective divisor.
LT's product of Grassmannians compactifies the enlarged polynomial subspaces
\(\widehat M_i\), but not the incidence subspace, the endpoint flag in
\(N_x\), or their identifications.  Passing to the graph of the flag supplies
tautological graded bundles but still only rational identifications with the
\(M_i\); it therefore gives no preferred one-sided saturation.

The lack of a bound is visible already over a boundary DVR.  With binary
coordinates \(x,y\), consider
\[
M_t=
\begin{pmatrix}
x&0&0\\
-y&x&0\\
0&-y&t^n x\\
0&0&x-y\\
0&0&0\\
0&0&0
\end{pmatrix}.
\]
For \(t\ne0\), the cokernel of
\(\mathcal O_{\mathbf P^1}(-1)^3\xrightarrow{M_t}\mathcal O^6\) is
\(\mathcal O(3)\oplus\mathcal O^2\), the \(411\) splitting.  At \(t=0\),
its torsion-free part is \(\mathcal O(2)\oplus\mathcal O^2\), with
torsion of length one.  Up to signs, the four nonzero cofactors are
\[
\bigl(y^2(x-y),\,xy(x-y),\,x^2(x-y),\,-t^nx^3\bigr).
\]
Multiplying them by any quintic and adjoining the two derivative forms
\(x^8,y^8\) gives a degree-eight derivative row annihilating \(M_t\) and
having no common root for any \(t\).  Replacing \(t\) by \(t^n\) makes the
relative-lattice valuation arbitrarily large without violating this
linewise smoothness condition.  This is a local boundary model, not an
asserted global counterexample.

The earlier numerical positivity countermodels violate the clean excess
identities.  They still correctly disprove a positivity-only argument, but
they no longer describe the constant-type geometry.  The unresolved
nondegenerate problem is now precisely the control of
\((\mathfrak e,\mathfrak z,\mathfrak r)\) across the divisorial normal-form
boundary.

This table is a reduction, not a proof.  Landsberg--Tommasi explicitly say
that they could not prove the required product of top Chern classes nonzero in
general; see their equation (5), Theorem 3.6, and Lemma 6.1
([paper](https://arxiv.org/pdf/0810.4158)).

## Reproducible computation completed

Run

```sh
python3 tools/run_calibrations.py
```

to regenerate 12 exact rows over \(\mathbf Q\), \(\mathbf F_2\), and
\(\mathbf F_7\).  The four rational fixtures--Fermat, a ten-cycle Klein form,
five two-cycles, and a chain--are projectively smooth and have certified local
dimension six at the supplied lines.  This says nothing about other components
of their Fano schemes, so their global status is deliberately recorded as
`not_checked`.

The smooth characteristic-two Fermat, Klein, and five-two-cycle fixtures have
certified local dimension 12.  Smooth characteristic-seven Fermat and chain
fixtures have certified local dimension 10.  These rows both calibrate the
harness and demonstrate why modular excess cannot be treated as evidence for
characteristic zero.

The separate line-family-first experiment in
[`experiments/mukai_inner_projection.m2`](experiments/mukai_inner_projection.m2)
tests a projected genus-six Mukai sixfold.  Its result and the precise scope of
the certificate are recorded in
[`results/mukai_inner_projection.md`](results/mukai_inner_projection.md).

A second line-family-first experiment projects the same smooth source from an
external point.  The resulting prime degree-ten sixfold really does escape the
low-generator lemma: its eight minimal ideal generators have degrees

\[
2,2,4,4,4,4,4,4.
\]

Its seven-dimensional family of lines survives projection.  However, exact
elimination finds a target point at which every ideal generator and every
generator differential vanishes.  Thus every hypersurface containing this
sixfold is singular at that point, in every degree.  The standalone
certificate and proof are
[`experiments/mukai_external_projection.m2`](experiments/mukai_external_projection.m2)
and
[`results/mukai_external_projection.md`](results/mukai_external_projection.md).

The genus-eight experiment starts with a smooth codimension-two linear section
of \(\operatorname{Gr}(2,6)\subset\mathbf P^{14}\) and projects it from an
external plane to \(\mathbf P^9\).  Four equations on the
eleven-dimensional flag variety of Grassmannian lines, together with an
explicit source line, certify a line-family component of dimension at least
seven; finiteness of the projection preserves that dimension.  Nevertheless,
two explicit source points have the same image and their projected tangent
spaces span all of \(\mathbf P^9\).  Every containing hypersurface is therefore
singular at that double image.  The same Terracini argument rules out a general
external plane projection of a general genus-eight section, because its secant
variety is the restricted Pfaffian cubic.  See
[`experiments/genus8_secant_obstruction.m2`](experiments/genus8_secant_obstruction.m2)
and
[`results/genus8_secant_obstruction.md`](results/genus8_secant_obstruction.md).

Finally, the smooth-normalization analysis above produced a complete exact
check of the two one-point projection orbits of the quintic del Pezzo
fivefold.  In both orbits the projected prime fivefold has degree five and
five cubic generators vanishing to second order along a \(\mathbf P^3\),
which is the forced-singularity obstruction used above.  The same package
checks
\(\int_{V_5}c_4(N^*_{V_5/\mathbf P^9}(9))H=15856\) for the unprojected
model.  See
[`experiments/projected_v5_fivefold.m2`](experiments/projected_v5_fivefold.m2),
[`tools/v5_chern.py`](tools/v5_chern.py), and
[`results/projected_v5_fivefold.md`](results/projected_v5_fivefold.md).

## What remains worth doing

The highest-value routes are now much narrower than the original coefficient
sweep.

1. In the nondegenerate span-nine branch, extend the fixed excess flag for
   reduced types \(411\) and \(321\) across the divisorial normal-form
   boundary, or control the exact signed classes
   \((\mathfrak e,\mathfrak z,\mathfrak r)\) displayed above.  The clean
   extension gives positive Chern numbers, but LT's compactification supplies
   no one-sided saturation, so those lower bounds are not unconditional.  The
   unequal \(R=7\) surjective cases and the surviving tangent-nonreduced rows
   of the LT table also require separate treatment.
2. In span eight, only \(b=7\) with \(\epsilon\in\{2,3\}\) remains; the
   entire \(b=8\) branch and the \(\epsilon=4,5\) rows are excluded.  For
   \(\epsilon=3\), common-factor and dominant-dependency pencils are gone;
   the constant square-member \(Q^3\) and one-dimensional-II \(Q^4\) cases
   remain, the nonschubert branch requires a singular/nonfactorial
   quadratic-contact threefold or \(I(C_2)=I(C_3)\), and the normal
   cubic-cone case descends to the fivefold/twisted-cubic problem above.  The
   generically reduced \(\epsilon=2\) row consists of the unequal LT types
   \(411/321\), equivalently \(41/32\) after deleting the transverse singleton
   block, with a surjective first-root divisor either directly or after cone
   descent.  It is necessarily nonnormal with a five-dimensional singular
   locus, unramified normalization along the general lifted line, and
   conductor intersection length \(m+4\); its cone descent requires a signed
   endpoint defect satisfying the two resultant identities above.
3. Search line-family first: construct singular integral sixfolds
   \(Y\subset\mathbf P^9\) with a seven-dimensional family of lines and enough
   low-degree ideal complexity to escape the lemma; only then search the
   degree-nine vector space \(I_Y(9)\) for a smooth member.  For projected
   smooth sources, first apply the secant-tangent test above: the general
   genus-eight Mukai projection already has a full-tangent double point before
   any ideal elimination is attempted.
4. If returning to hypersurface-first computation, require a genuine global
   certificate for every reported null and retain the cheaper one-chart local
   certificate for hits.

At present there is no \(\mathbf Q\)-certified hit and no proof of the complex
degree-nine conjecture.  The defensible outcome is therefore: **literal
field-free refutation, characteristic-zero partial null, and an exact reduction
to singular line-rich sixfolds and the LT cases above.**
