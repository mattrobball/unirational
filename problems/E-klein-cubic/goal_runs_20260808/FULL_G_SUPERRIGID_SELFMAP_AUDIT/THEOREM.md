# What full-\(G\) superrigidity says about rational selfmaps

**Date:** 2026-08-08  
**Field:** \(\mathbf C\)  
**Group:** \(G=\operatorname{PSL}_2(\mathbf F_{11})\)  
**Variety:** the smooth Klein cubic threefold \(X\subset\mathbf P^4\)  
**Verdict:** every Galois degree \(2\) through \(11\) is excluded; the
Noether--Fano theorem does not exclude an arbitrary deckless degree greater
than one

Assume that an ambient landing map has produced a dominant
\(G\)-equivariant rational selfmap

\[
 \varphi:X\dashrightarrow X
\]

of degree \(\delta>0\), as in `FULL_G_RESTRICTION_DOMINANCE`.  Put

\[
 L=\mathbf C(X),\qquad \theta=\varphi^*:L\hookrightarrow L,
 \qquad K=\theta(L).
\tag{0.1}
\]

Equivariance is exactly the identity \(g\theta=\theta g\), so \(K\) is
\(G\)-stable and \([L:K]=\delta\).

## 1. The mobile linear system gives canonicity, not degree one

Let \(H=\mathcal O_X(1)\), so \(-K_X=2H\).  Pull back the complete
hyperplane system by \(\varphi\), and remove its fixed divisorial part.
This gives a nonempty \(G\)-invariant mobile system

\[
 \mathcal M\subset |nH|
\tag{1.1}
\]

for some \(n>0\).  On a common resolution

\[
 p:T\longrightarrow X,
 \qquad q=\varphi\circ p:T\longrightarrow X,
\]

write

\[
 K_T=p^*K_X+\sum_E a_EE,
 \qquad
 q^*H\sim p^*(nH)-\sum_E m_EE.
\tag{1.2}
\]

The exact mobile-threshold consequence of full-\(G\) birational
superrigidity is

\[
 \left(X,\frac2n\mathcal M\right)\text{ is canonical},
 \qquad
 2m_E\leq n a_E\quad\text{for every exceptional }E.
\tag{1.3}
\]

This is the direction recorded explicitly in the proof of Theorem 10 of
Cheltsov--Krylov--Ma'u: failure of \(G\)-superrigidity is equivalent to the
existence of a \(G\)-invariant mobile
\(\mathcal M\subset|\mathcal O_X(n)|\) for which the pair with coefficient
\(2/n\) is not canonical.  Since the Klein cubic is
\(G\)-superrigid, the system induced by a hypothetical \(\varphi\) must
satisfy (1.3).

There is no degree in (1.3).  The degree is instead the full moving
self-intersection

\[
 3\delta=(q^*H)^3
 =\left(np^*H-\sum_E m_EE\right)^3,
\tag{1.4}
\]

which also depends on the intersection and proximity data of the actual
base ideal.  The upper bounds (1.3) do not make the right side equal to
\(3\).

The ramification formula makes the missing implication particularly
clear.  If \(R_q\) is the ramification divisor, then

\[
 R_q=K_T-q^*K_X
 \sim 2(n-1)p^*H+\sum_E(a_E-2m_E)E.
\tag{1.5}
\]

For a birational map to another Mori fibre space, the Noether--Fano
argument produces a noncanonical valuation.  For a generically finite map,
the horizontal ramification term in (1.5) is present, and no such
noncanonical valuation follows.  Thus applying the mobile-threshold theorem
to (1.1) proves (1.3); it does not prove \(\delta=1\).

## 2. The normalized-graph conditional theorem

Let

\[
 T\overset r\longrightarrow Y\overset\nu\longrightarrow X
\tag{2.1}
\]

be the Stein factorization of \(q\).  Then \(r\) is birational,
\(Y\) is normal and \(G\)-birational to \(X\), and \(\nu\) is finite of
degree \(\delta\).

If \(Y\) is terminal and \(\mathbf Q\)-factorial, \(-K_Y\) is ample, and
\(\operatorname{rk}\operatorname{Cl}(Y)^G=1\), then \(Y\) is a
\(G\)-Mori fibre space.  Full-\(G\) rigidity makes
\(X\dashrightarrow Y\) biregular.  Under this identification \(\nu\) is
a regular endomorphism of the smooth cubic threefold, so Beauville's
endomorphism theorem gives

\[
 \delta=1.
\tag{2.2}
\]

This conditional argument checks every hypothesis used by
Noether--Fano.  Normalized graphs of rational maps from smooth varieties
need not be canonical, terminal, \(\mathbf Q\)-factorial, or Fano; none of
these properties follows from Stein factorization or from the landing
identity alone.  Hence (2.2) is not an unconditional degree-one theorem.

## 3. An unconditional degree-two exclusion

**Theorem 3.1 (quadratic deck exclusion).**  The degree of a dominant
\(G\)-equivariant rational selfmap of the Klein cubic is not two.

**Proof.**  Suppose \([L:K]=2\).  Characteristic zero makes \(L/K\)
separable, and every separable quadratic extension is Galois.  Let

\[
 1\ne\tau\in\operatorname{Aut}_K(L)
\]

be its unique deck involution.  For \(g\in G\), stability of \(K\) gives

\[
 g\tau g^{-1}\in\operatorname{Aut}_K(L).
\]

The nonidentity element of this order-two group is unique, so
\(g\tau g^{-1}=\tau\).  Thus \(\tau\) commutes with \(G\), i.e. it lies in
the equivariant birational group
\(\operatorname {Bir}^G(X)=C_{\operatorname {Bir}(X)}(G)\).

In the convention of the cited rigidity papers, full-\(G\) birational
superrigidity gives

\[
 \operatorname {Bir}^G(X)=\operatorname {Aut}^G(X).
\]

The full automorphism group of the Klein cubic is \(G\), so the right side is
the centralizer \(C_G(G)=Z(G)=1\).  Hence

\[
 \tau=1,
\]

contradicting \(\tau\ne1\).  Therefore \(\delta\ne2\). \(\square\)

This argument does not require the normalized graph \(Y\) to have
canonical singularities.  It strictly strengthens the earlier statement
that a quadratic normalized graph would have to be noncanonical.

## 4. Exact extension and exact boundary of the deck argument

Let

\[
 D=\operatorname{Aut}_K(L)
\tag{4.1}
\]

for arbitrary \(\delta\).  Conjugation by \(G\) acts on \(D\).  Every
\(G\)-fixed element of \(D\) centralizes \(G\).  By the equivariant
centralizer equality above it is regular and belongs to
\(\operatorname {Aut}^G(X)=Z(G)\).
Therefore

\[
 D^G=1.
\tag{4.2}
\]

Since \(G\) is simple, if \(D\ne1\), the conjugation homomorphism

\[
 G\longrightarrow\operatorname{Aut}(D)
\tag{4.3}
\]

must be injective: its kernel is either trivial or all of \(G\), and the
latter would contradict (4.2).  Consequently:

* a nontrivial Galois deck group \(D\) is possible only if
  \(\operatorname{Aut}(D)\) contains \(G\);
* a cyclic Galois deck group is impossible, because
  \(\operatorname{Aut}(D)\) is abelian whereas \(G\) is perfect;
* the quadratic case is the first instance of this criterion.

There is a useful sharp finite consequence.

**Theorem 4.1 (small Galois degrees).**  A \(G\)-equivariant rational
selfmap of \(X\) whose restriction field extension is Galois cannot have

\[
 2\leq\delta\leq11.
\tag{4.4}
\]

**Proof.**  In the Galois case, \(|D|=\delta\).  If \(D\ne1\), (4.3) is
injective.  Every automorphism of \(D\) acts faithfully on
\(D\setminus\{1\}\), so (4.3) would give a faithful permutation action of
\(G\) on \(\delta-1\) points.

The least faithful permutation degree of
\(\operatorname{PSL}_2(\mathbf F_{11})\) is \(11\).  Indeed, the ATLAS
maximal-subgroup list consists of two classes of \(A_5\), one class of
\(11{:}5\), and one class of \(D_{12}\), of respective orders
\(60,60,55,12\).  Thus the largest proper subgroup has order \(60\), the
least proper-subgroup index is \(660/60=11\), and the two \(A_5\) classes
realize degree \(11\).  Because \(G\) is simple, every nontrivial orbit in
a permutation action is already faithful, so this is also the least degree
for possibly intransitive faithful actions.

For \(2\leq\delta\leq11\), one has \(\delta-1\leq10\), a contradiction.
\(\square\)

This does not extend to an arbitrary non-Galois degree.  Such an extension
may have \(D=1\).  For example,

\[
 \mathbf C(t)/\mathbf C(t^3-t)
\tag{4.5}
\]

has degree three and no nontrivial deck transformation.  Indeed a deck
transformation must preserve the unique pole above infinity, hence has the
form \(t\mapsto at+b\); comparing coefficients in
\((at+b)^3-(at+b)=t^3-t\) gives \(a=1,b=0\).  Taking the product with any
faithful \(G\)-variety gives a \(G\)-equivariant degree-three selfmap with
trivial deck group.  This is a field-theoretic boundary example, not a
selfmap of the Klein cubic.

Thus deck transformations close every Galois degree through \(11\) and all
cyclic-Galois degrees, but they do not turn superrigidity into a theorem
excluding all generically finite selfmaps.  For larger groups the exact
necessary condition is stronger than mere injectivity: \(G\) must act on
\(D\) through automorphisms with \(D^G=1\).  This condition is not formally
absurd.  For example, the nonabelian choice \(D=G\) with the conjugation
action has \(D^G=Z(G)=1\) and
\(G\subset\operatorname{Aut}(D)\).  There is also an abelian example that
passes both necessary group-theoretic tests.  The ATLAS supplies an
absolutely irreducible five-dimensional representation of \(G\) over
\(\mathbf F_3\).  Hence for

\[
 D=(C_3)^5,
\]

one has \(G\hookrightarrow\operatorname{GL}_5(3)=\operatorname{Aut}(D)\)
and \(D^G=1\).  (The representation is nontrivial, hence faithful because
\(G\) is simple, and absolute irreducibility excludes fixed vectors.)
Thus cyclic abelian deck groups are excluded, but arbitrary abelian deck
groups are not; the first displayed compatible abelian order here is
\(3^5=243\).  These are group-theoretic boundary examples, not
constructions of covers of the Klein cubic.

## 5. Result ledger

```text
FULL-G-MOBILE-SYSTEM-IS-CANONICAL
FULL-G-NOETHER-FANO-DOES-NOT-DETERMINE-DEGREE
FULL-G-STEIN-MORI-HYPOTHESES-GIVE-DEGREE-ONE
FULL-G-RESTRICTION-DEGREE-TWO-EXCLUDED
FULL-G-CYCLIC-GALOIS-RESTRICTION-EXCLUDED
FULL-G-GALOIS-DEGREES-TWO-THROUGH-ELEVEN-EXCLUDED
FULL-G-NONGALOIS-DECKLESS-BRANCH-OPEN
FULL-G-ARBITRARY-DEGREE-GREATER-ONE-GATE-OPEN
HEADLINE-OPEN
```

## Sources

* I. Cheltsov and C. Shramov, *Five embeddings of one simple group*,
  Theorem A.5, <https://arxiv.org/abs/0910.1783>.
* I. Cheltsov, I. Krylov, and S. Ma'u, *G-birationally rigid cubic
  threefolds*, especially the definition in the introduction, Theorem 3,
  Corollary 4(ii), Remark 5, and the mobile-system equivalence in the proof
  of Theorem 10, <https://arxiv.org/abs/2604.20426>.
* A. Beauville, *Endomorphisms of hypersurfaces and other manifolds*,
  <https://arxiv.org/abs/math/0008205>.
* ATLAS of Finite Group Representations, *Linear group \(L_2(11)\)*,
  especially the order, permutation representations, and complete maximal
  subgroup table,
  <https://brauer.maths.qmul.ac.uk/Atlas/v3/lin/L211/>.
  The absolutely irreducible representation of dimension five over
  \(\mathbf F_3\) is recorded at
  <https://brauer.maths.qmul.ac.uk/Atlas/v3/matrep/L211G1-f3r5aB0>.
