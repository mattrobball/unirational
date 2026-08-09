# Generic fibres, quotient torsors, and the normalized-Stein gate

**Date:** 2026-08-08  
**Field:** \(\mathbf C\)  
**Group:** \(G=\operatorname{PSL}_2(\mathbf F_{11})\)  
**Verdict:** several degree-free identities and a conditional degree-one
theorem; the Mori hypotheses on the normalized graph are not forced

Let \(W\) be the irreducible five-dimensional Klein representation and
let

\[
 X=V(F)\subset \mathbf P(W),\qquad K_X=-2H,qquad H^3=3.
\]

Assume that

\[
 f:\mathbf P(W)\dashrightarrow X
\tag{0.1}
\]

is a dominant \(G\)-equivariant rational map.  By
`FULL_G_RESTRICTION_DOMINANCE`, its restriction

\[
 \varphi=f|_X:X\dashrightarrow X
\tag{0.2}
\]

is dominant and generically finite of degree \(\delta>0\).

## 1. The quotient degree and generic torsor are tautological

Put

\[
 L=\mathbf C(X),\qquad N=L^G,qquad \theta=\varphi^*:L\hookrightarrow L.
\]

Then \(\theta(N)\subset N\), and the induced quotient selfmap has exactly
the same degree as \(\varphi\):

\[
 \boxed{[N:\theta(N)]=[L:\theta(L)]=\delta.}
\tag{1.1}
\]

Indeed, generic freeness gives

\[
 [L:N]=[\theta(L):\theta(N)]=|G|,
\]

and the two tower computations of \([L:\theta(N)]\) prove (1.1).

Let \(\alpha_X\in H^1(N,G)\) be the generic torsor of \(X\to X/G\).
The equivariant map \(\varphi\) gives an isomorphism

\[
 \theta_N^*\alpha_X\simeq\alpha_X.
\tag{1.2}
\]

This is automatic: on coordinate fields the pullback torsor maps to
\(L\) by \(a\otimes b\mapsto a\theta(b)\), and both sides have degree
\(|G|\) over \(N\).

There is an analogous exact statement for the ambient map.  Put

\[
 K=\mathbf C(\mathbf P(W)),\qquad M=K^G.
\]

Then

\[
 f^*L\cap M=f^*N,\qquad K=Mf^*L,
\tag{1.3}
\]

and the generic linear torsor satisfies

\[
 \alpha_W=\bar f^{\,*}\alpha_X\quad\hbox{in }H^1(M,G).
\tag{1.4}
\]

Thus passing to quotients preserves \(\delta\), but supplies neither a
congruence nor a bound.  Equations (1.2) and (1.4) are the field-theoretic
form of equivariance, not a new obstruction.

## 2. Exact generic-fibre identities

Choose a smooth equivariant resolution

\[
 \pi:Z\longrightarrow\mathbf P(W),\qquad q:Z\longrightarrow X.
\]

Let \(\Gamma\) be a smooth general fibre, possibly disconnected, and set
\(h=\pi^*H\).  If the primitive coordinates of (0.1) have homogeneous
degree \(d\), write

\[
 q^*H=dh-\sum_\nu m_\nu E_\nu,
\quad
 \pi^*X=\widetilde X+\sum_\nu c_\nu E_\nu,
\quad
 K_Z=-5h+\sum_\nu k_\nu E_\nu.
\tag{2.1}
\]

Put

\[
 a=h\cdot\Gamma>0,qquad e_\nu=E_\nu\cdot\Gamma\geq0.
\]

Only exceptional divisors which dominate the target have \(e_\nu>0\).
Intersecting (2.1) with \(\Gamma\) gives the three exact identities

\[
 \boxed{
 \sum_\nu m_\nu e_\nu=da,
 \qquad
 \delta=3a-\sum_\nu c_\nu e_\nu,
 \qquad
 \deg K_\Gamma=-5a+\sum_\nu k_\nu e_\nu.
 }
\tag{2.2}
\]

Since \((\mathbf P^4,X)\) is plt, every exceptional valuation also
satisfies

\[
 k_\nu-c_\nu\geq0.
\tag{2.3}
\]

These relations are degree-free, but they do not determine \(\delta\).
The unknown horizontal Rees valuations carry precisely the four integers
\((m_\nu,c_\nu,k_\nu,e_\nu)\).

Adjunction gives the parallel ramification identity.  After making
\(D=\widetilde X\) smooth, write \(q_D=q|_D\).  Its ramification divisor is

\[
 R_{q_D}=K_D-q_D^*K_X
 \equiv
 2(d-1)h|_D+
 \sum_\nu(k_\nu-c_\nu-2m_\nu)E_\nu|_D.
\tag{2.4}
\]

The left side is effective, but this does not make the displayed
coefficients nonnegative: \(h|_D,E_\nu|_D\) are not the prime-component
basis of the effective cone.  Turning (2.4) into a numerical bound requires
the Segre/proximity data of the actual base ideal.

For comparison, take any smooth cubic threefold, a classical degree-two
unirational parametrization \(u:\mathbf P^3\dashrightarrow X\), and
projection \(\Pi_x:\mathbf P^4\dashrightarrow\mathbf P^3\) from a point
\(x\in X\).  Then

\[
 f=u\circ\Pi_x
\]

is an ambient dominant rational map and

\[
 \deg(f|_X)=2\cdot2=4.
\]

A general hyperplane not through \(x\) maps isomorphically to
\(\mathbf P^3\), so \(a=2\).  Consequently (2.2) reads

\[
 3a=6=4+2.
\tag{2.5}
\]

This example is not \(G\)-equivariant.  Its precise force is that ambient
extendability, the cubic source divisor, and the generic-fibre identities
alone allow a positive horizontal correction and degree greater than one.

## 3. The normalized Stein graph

Resolve (0.2) on the strict transform of the source cubic and take Stein
factorization:

\[
 D\overset r\longrightarrow Y\overset\nu\longrightarrow X.
\tag{3.1}
\]

Here \(D\) is smooth and birational to \(X\), \(Y\) is normal,
\(r\) is birational, and \(\nu\) is finite of degree \(\delta\).  The
construction is \(G\)-equivariant.  Equivalently, a rational selfmap of
degree \(\delta\) produces a finite model \(Y\to X\) whose source is
\(G\)-birational to \(X\).

**Conditional Mori lemma.**  Suppose in addition that

1. \(Y\) is terminal and \(\mathbf Q\)-factorial;
2. \(-K_Y\) is ample; and
3. \(\rho(Y)^G=1\).

Then \(\delta=1\).

Indeed, \(Y\to\operatorname{Spec}\mathbf C\) is then a \(G\)-Mori fibre
space.  Full-\(G\) birational superrigidity identifies the
\(G\)-birational map \(X\dashrightarrow Y\) with a biregular isomorphism.
After this identification, \(\nu\) is an endomorphism of the smooth cubic
threefold.  Beauville's theorem excludes endomorphisms of degree greater
than one, so \(\delta=1\).

Thus a degree-greater-than-one restriction can survive only if its finite
Stein model fails at least one of terminality, \(\mathbf Q\)-factoriality,
Fano ampleness, or invariant Picard rank one.

## 4. A sharp Galois refinement

The exact invariant-ring data give

\[
 H^0(X,\mathcal O_X(m))^G=0\qquad(1\leq m\leq4).
\tag{4.1}
\]

Indeed, below degree five the ambient invariant ring contains only the
Klein cubic \(F\) in degree three, and it restricts to zero on \(X\).
Since \(G\) is perfect, a stable divisor has an invariant, not merely
semi-invariant, defining section.  Hence every nonzero effective
\(G\)-invariant integral divisor on \(X\) has class \(mH\) with
\(m\geq5\).

**Galois-canonical lemma.**  If \(\nu:Y\to X\) in (3.1) is Galois and
\(Y\) has canonical singularities, then \(\delta=1\).

For a nontrivial branched Galois cover, Hurwitz gives

\[
 K_Y=\nu^*(K_X+\Delta),
\qquad
 \Delta=\sum_B(1-1/e_B)B.
\tag{4.2}
\]

The branch orbifold \(\Delta\) is \(G\)-invariant and every nonzero
coefficient is at least \(1/2\).  Decomposing its support into \(G\)-orbits
of prime divisors and applying (4.1) gives

\[
 \Delta\equiv rH,\qquad r\geq\frac52.
\tag{4.3}
\]

Therefore \(K_X+\Delta\equiv(r-2)H\) is ample, and so is \(K_Y\).  If
\(Y\) is canonical, this makes its birational Kodaira dimension equal to
three, contradicting the fact that \(Y\) is birational to the Fano
threefold \(X\).  If the cover is unbranched, purity makes it etale and
the Lefschetz theorem gives \(\pi_1(X)=1\), so again its degree is one.

There is a stronger deck-group argument which does not assume that \(Y\)
is canonical.  It excludes every Galois restriction degree from \(2\)
through \(11\).  In the quadratic case, the nontrivial automorphism of
\(\mathbf C(X)/\varphi^*\mathbf C(X)\) is unique, hence centralized by \(G\).
It would lie in \(\operatorname {Bir}^G(X)\), which full-\(G\)
superrigidity identifies with \(\operatorname {Aut}^G(X)\).  Since
\(\operatorname{Aut}(X)=G\) and \(Z(G)=1\), this equivariant regular group is
trivial.  In particular,

\[
 \boxed{\delta\ne2.}
\tag{4.4}
\]

See `FULL_G_SUPERRIGID_SELFMAP_AUDIT/THEOREM.md` for the complete deck
argument, the minimal-permutation-degree extension through \(11\), and its
exact non-Galois boundary.  The Galois-canonical lemma above remains useful
for larger noncyclic Galois groups whose conjugation action can be faithful.

## 5. Why Stein factorization does not supply the missing hypotheses

There is no general theorem making the finite model in (3.1) terminal,
canonical, or even \(\mathbf Q\)-Gorenstein merely because both the source
and target of the rational map are smooth.

An exact three-dimensional model illustrates the point.  For \(n\geq4\),
put

\[
 Y_n=\mathbf P(1,1,1,n)
\]

with coordinates \([u:v:w:z]\).  The four sections of
\(\mathcal O_{Y_n}(n)\)

\[
 [u^n:v^n:w^n:z]
\]

define a finite morphism

\[
 \nu_n:Y_n\longrightarrow\mathbf P^3
\tag{5.1}
\]

of degree \(n^2\).  On the chart \(w\ne0\), it is the field extension

\[
 (a,b,c)\longmapsto(a^n,b^n,c).
\]

The variety \(Y_n\) is rational, but its vertex is the quotient
singularity \(\frac1n(1,1,1)\), which is noncanonical for \(n\geq4\)
because its age is \(3/n<1\).  If a smooth resolution of \(Y_n\), birational
to \(\mathbf P^3\), is used as the source of (5.1), its Stein factor is
still \(Y_n\).  Equivalently, composing any birational map
\(\mathbf P^3\dashrightarrow Y_n\) with \(\nu_n\) gives a rational selfmap
of \(\mathbf P^3\) whose normalized Stein graph is \(Y_n\).  Thus a rational
map from a smooth rational threefold to a smooth target can have a
noncanonical normalized finite graph.

For the Klein problem, the landing equation \(F(P)=0\) does not by itself
control the discrepancies of this Stein model.  In the notation of (2.2),
one would need a theorem about the actual horizontal Rees valuations of the
landing ideal which forces the normalized graph into the Mori class (or at
least into the canonical Galois class).  Neither generic-fibre intersection
theory, quotient torsors, nor Stein factorization provides that theorem.

## 6. Exact stopping boundary

```text
FULL-G-QUOTIENT-DEGREE-EQUALS-RESTRICTION-DEGREE
FULL-G-GENERIC-TORSOR-PRESERVATION-IS-TAUTOLOGICAL
FULL-G-GENERIC-FIBRE-THREE-EXACT-IDENTITIES
FULL-G-STEIN-MORI-CONDITIONAL-DEGREE-ONE
FULL-G-GALOIS-CANONICAL-GRAPH-DEGREE-ONE
FULL-G-DEGREE-TWO-EXCLUDED-BY-DECK-INVOLUTION
FULL-G-GALOIS-DEGREES-TWO-THROUGH-ELEVEN-EXCLUDED
FULL-G-STEIN-MORI-HYPOTHESES-NOT-FORCED
FULL-G-ACTUAL-LANDING-BASE-IDEAL-STILL-REQUIRED
HEADLINE-OPEN
```

## Sources

* A. Beauville, *Endomorphisms of hypersurfaces and other manifolds*,
  <https://arxiv.org/abs/math/0008205>.
* I. Cheltsov, I. Krylov, S. Ma'u, *G-birationally rigid cubic
  threefolds*, <https://arxiv.org/abs/2604.20426>.
* N. Chen, D. Stapleton, *Rational endomorphisms of Fano hypersurfaces*,
  <https://arxiv.org/abs/2103.12207>.
