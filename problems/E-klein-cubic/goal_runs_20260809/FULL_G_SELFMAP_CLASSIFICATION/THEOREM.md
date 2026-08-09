# Actual full-group rational selfmaps: tangent-residual existence theorem

**Date:** 2026-08-09  
**Field:** \(\mathbf C\)  
**Group:** \(G=\operatorname{PSL}_2(\mathbf F_{11})\)  
**Threefold:** the smooth Klein cubic \(X=V(F)\subset\mathbf P(W_5)\)

## Executive theorem

The proposed identity and degree-one classifications are false for **arbitrary**
dominant rational selfmaps.

> **Theorem (tangent-residual selfmaps).** There exists a dominant,
> nonidentity, \(G\)-equivariant rational selfmap
> \[
> \varphi:X\dashrightarrow X.
> \]
> Every such map produced below has degree \(\delta\ge 3\). Consequently its
> iterates have degrees \(\delta^m\), and
> \[
> \operatorname{End}^{\mathrm{rat,dom}}_G(X)
> \]
> is infinite and contains maps of unbounded degree.

Thus

```text
FULL-G-SELFMAP-IDENTITY-THEOREM       FALSE
FULL-G-SELFMAP-DEGREE-ONE-THEOREM     FALSE
FULL-G-SELFMAP-FINITE-DEGREE-LIST      FALSE
```

The construction is intrinsic to \(X\). It does **not** produce an ambient
landing map \(\mathbf P(W_5)\dashrightarrow X\). The ambient-extendable
submonoid remains open.

---

## 1. The tangent-residual map is an actual rational map

Write the cubic expansion along a line as

\[
F(x+tv)=F(x)+tL(x,v)+t^2Q(x,v)+t^3C(v),
\qquad C(v)=F(v).
\tag{1.1}
\]

Here \([x]\in X\), and a projective tangent direction at \([x]\) is represented
by a vector \(v\) modulo \(\langle x\rangle\) satisfying

\[
L(x,v)=dF_x(v)=0.
\tag{1.2}
\]

Define

\[
R(x,v)=C(v)x-Q(x,v)v.
\tag{1.3}
\]

For every homogeneous cubic, direct expansion gives the polynomial identity

\[
\boxed{
F(R(x,v))=C(v)^3F(x)-C(v)^2Q(x,v)L(x,v).
}
\tag{1.4}
\]

Therefore \(F(R(x,v))=0\) whenever \(F(x)=L(x,v)=0\). Moreover, if
\(v'=av+bx\), then on the same equations

\[
R(x,v')=a^3R(x,v).
\tag{1.5}
\]

Scaling the base vector \(x\) also only rescales \(R\), since
\(Q(cx,v)=cQ(x,v)\). Thus (1.3) is independent of every choice used to
represent a point of the projective tangent bundle. It defines a rational map

\[
\rho:\mathbf P(T_X)\dashrightarrow X.
\tag{1.6}
\]

Geometrically, \(\rho(x,[v])\) is the residual third point of the line through
\(x\) in direction \([v]\):

\[
\ell_{x,v}\cap X=2x+\rho(x,[v]).
\]

The map is undefined exactly where \(Q(x,v)=C(v)=0\), equivalently where the
whole line \(\ell_{x,v}\) is contained in \(X\).

The construction uses only the cubic equation and is functorial under
projective automorphisms of \(X\). Hence \(\rho\) is \(G\)-equivariant.

For a general \(x\), restriction to the fibre is the inverse of projection
from the double point \(x\) of the tangent hyperplane section:

\[
\rho_x:\mathbf P(T_xX)\dashrightarrow X\cap T_xX.
\tag{1.7}
\]

It is generically birational onto this surface. In particular \(\rho\) is
dominant.

The exact Klein identity (1.4) and representative independence (1.5) are
replayed by `verify_tangent_residual.py`.

---

## 2. A dominant-section lemma

> **Lemma.** Let \(B\) be a smooth irreducible \(n\)-fold over an algebraically
> closed field of characteristic zero, let
> \[
> \pi:Z=\mathbf P(\mathcal E)\to B
> \]
> be a projective bundle of relative dimension \(r\), and let
> \(h:Z\dashrightarrow B\) be dominant. If \(h\ne\pi\) as rational maps, then
> there exists a rational section \(s:B\dashrightarrow Z\) such that
> \[
> h\circ s:B\dashrightarrow B
> \]
> is dominant and is not the identity.

**Proof.** Choose a point \(z\) where \(h\) is defined and smooth, and with
\(h(z)\ne\pi(z)\). Put

\[
V=\ker(d\pi_z),\qquad K=\ker(dh_z).
\]

Both have dimension \(r\) inside the \((n+r)\)-dimensional space \(T_zZ\).
In \(\operatorname{Gr}(n,T_zZ)\), the loci of \(n\)-planes complementary to
\(V\) and to \(K\) are nonempty open sets. Their intersection is nonempty.
Choose an \(n\)-plane \(L\) complementary to both.

Trivialize the projective bundle in an affine chart around \(z\). A local
section through \(z\) is the graph of \(r\) regular functions on \(B\). Since
\(B\) is smooth, their first jets can be prescribed so that the tangent space
of the graph at \(z\) is \(L\). This local section is a rational section of
\(\pi\). For it,

\[
d(h\circ s)_{\pi(z)}=dh_z|_L\circ(d\pi_z|_L)^{-1}
\]

is an isomorphism, so \(h\circ s\) is dominant. Its value at \(\pi(z)\) is
\(h(z)\ne\pi(z)\), so it is not the identity. \(\square\)

This lemma is algebraic and requires neither rationality nor unirationality of
\(B\).

---

## 3. Descent through the free quotient

Let \(U\subset X\) be a nonempty \(G\)-stable open set on which the finite,
faithful \(G\)-action is free, and let

\[
\alpha:U\to B=U/G
\tag{3.1}
\]

be the finite étale \(G\)-torsor. Since \(\alpha\) is étale,
\(T_U\simeq\alpha^*T_B\). Equivalently, the \(G\)-linearized tangent bundle
descends to \(T_B\), and

\[
\mathbf P(T_U)/G\simeq\mathbf P(T_B)=:Z.
\tag{3.2}
\]

Shrink only the domain of the rational map so that \(\rho\) is defined and
lands in \(U\). Equivariance gives a dominant descended rational map

\[
\bar\rho:Z\dashrightarrow B.
\tag{3.3}
\]

Let \(\pi:Z\to B\) be the bundle projection. The two maps are not equal. For
a general \(x\in U\), the image of the fibre
\(\mathbf P(T_xX)\) under \(\rho_x\) is a surface, whereas equality
\(\bar\rho=\pi\) would force every residual point into the finite orbit
\(Gx\).

Apply the dominant-section lemma to obtain a rational section

\[
s:B\dashrightarrow Z
\tag{3.4}
\]

such that

\[
\psi:=\bar\rho\circ s:B\dashrightarrow B
\tag{3.5}
\]

is dominant and nonidentity.

Base change (3.4) along the torsor \(U\to B\). Under (3.2) this gives a
\(G\)-equivariant rational section

\[
\widetilde s:U\dashrightarrow\mathbf P(T_U).
\tag{3.6}
\]

Now set

\[
\varphi=\rho\circ\widetilde s:U\dashrightarrow U.
\tag{3.7}
\]

It extends uniquely to a rational map \(X\dashrightarrow X\). It is
\(G\)-equivariant. Since its quotient is the dominant map \(\psi\), it is
dominant. Since \(\psi\ne\operatorname{id}_B\), it is not the identity.
This proves existence of an **actual** dominant rational selfmap, not a formal
fixed-graph or degree datum.

---

## 4. Degree and iteration

Let \(\delta=\deg\varphi\). Dominance gives \(\delta>0\).

The accepted full-\(G\) rigidity theorem says that a degree-one
\(G\)-equivariant rational selfmap is the identity. Our map is not the
identity, so \(\delta\ne1\). The accepted deck-involution argument excludes
\(\delta=2\). Hence

\[
\boxed{\delta\ge3.}
\tag{4.1}
\]

Degrees of generically finite rational maps multiply under composition, so

\[
\deg(\varphi^m)=\delta^m.
\tag{4.2}
\]

The iterates are pairwise distinct. Therefore

\[
\boxed{
\operatorname{End}^{\mathrm{rat,dom}}_G(X)
\text{ is infinite and has unbounded degrees.}
}
\tag{4.3}
\]

No exact value of \(\delta\), monodromy group, or base ideal is claimed for
the section selected in Section 3.

---

## 5. Exact generic-torsor classification

The free quotient also gives the correct abstract classification target. Let

\[
K=\mathbf C(B)=\mathbf C(X)^G,
\qquad L=\mathbf C(X),
\]

and let \(\alpha\in H^1(K,G)\) be the generic torsor.
Dominant \(G\)-equivariant rational selfmaps of \(X\) are equivalent to pairs

\[
(\psi,\iota),
\tag{5.1}
\]

where

1. \(\psi:B\dashrightarrow B\) is a dominant rational map; and
2. \(\iota:\psi^*\alpha\xrightarrow\sim\alpha\) is an isomorphism of generic
   \(G\)-torsors.

Indeed, an equivariant selfmap descends to \(\psi\), and on generic fibres it
is an equivariant map between two finite \(G\)-torsors, hence an isomorphism.
Conversely such an isomorphism gives the required semilinear embedding
\(L\hookrightarrow L\). The degree of the selfmap equals the degree of
\(\psi\).

This is an exact field-theoretic classification, but it is not a finite
geometric list. The tangent-residual construction supplies nontrivial pairs
(5.1).

---

## 6. Consequences for the requested routes

### 6.1 Normalized graph and Mori hypotheses

Let \(Y\) be the normalized Stein model of one of the maps above. If \(Y\)
were simultaneously terminal, \(\mathbf Q\)-factorial, \(G\)-Fano, and of
invariant Picard rank one, the accepted conditional superrigidity argument
would force \(\delta=1\). Since \(\delta\ge3\), at least one hypothesis fails.
Thus the non-Mori graph obstruction is not merely hypothetical: actual
\(G\)-selfmaps force it.

### 6.2 Noether--Fano

The canonicality of the scaled mobile pair does not imply degree one. The
maps above are actual counterexamples to that inference. Exceptional terms in

\[
3\delta=
\left(np^*H-\sum m_EE\right)^3
\]

cannot be discarded.

### 6.3 Fixed loci

The section was selected on the free quotient. It need not extend across any
fixed curve or point. On a resolution, fixed-locus maps may therefore live
entirely on exceptional horizontal carriers. This is exactly the category
left open by the fixed-network and normalized-Rees packets.

### 6.4 Intermediate Jacobian

The graph gives an honest correspondence endomorphism of \(J(X)\), but for a
rational map with curve-centre exceptional cohomology there is no general
identity \(u^\dagger u=[\delta]\). The existence theorem proves that no such
uncorrected identity can force all equivariant rational selfmaps to have
\(\delta=1\).

### 6.5 Birational rigidity

Birational rigidity controls the degree-one case. It does not prohibit the
maps constructed here, whose degrees are at least three.

---

## 7. Ambient-extendable selfmaps are still special

Every rational selfmap is represented on \(X\) by five sections of
\(\mathcal O_X(n)\). Projective normality lifts them to homogeneous forms
\(P_0,\ldots,P_4\) on \(\mathbf P(W_5)\), but only gives

\[
F(P_0,\ldots,P_4)=F(x)A(x)
\tag{7.1}
\]

for some polynomial \(A\). An ambient landing map requires the much stronger
identity

\[
F(P_0,\ldots,P_4)=0
\tag{7.2}
\]

on all of \(\mathbf P(W_5)\).

Nothing in Sections 1--4 solves this nonlinear normal-extension equation.
The tangent-residual maps therefore do not settle the ambient subclass

\[
\mathcal S_{\mathrm{amb}}.
\]

The exact ambient boundary remains the actual normalized Rees algebra of a
landing ideal, including the forced plus-plane base components and their
horizontal exceptional carriers.

---

## 8. Final verdict

The strongest honest exit is

```text
FULL-G-NONTRIVIAL-RATIONAL-SELFMAPS-EXIST
FULL-G-SELFMAP-DEGREES-UNBOUNDED
TARGET-A-REFUTED
TARGET-B-REFUTED
ARBITRARY-SELFMAP-ROUTE-CANNOT-CLOSE-PROBLEM-E
FULL-G-AMBIENT-SELFMAP-CLASSIFICATION-OPEN
FULL-G-SELFMAP-CLASSIFICATION-UNDECIDED
```

The smallest remaining theorem relevant to Problem E is no longer a
classification of arbitrary \(G\)-selfmaps. It is:

> classify or exclude the **ambient-extendable** pairs (5.1), equivalently
> those whose five lifted sections can be modified to satisfy the global
> landing identity (7.2), with the actual normalized-Rees carrier structure
> imposed.
