# Theorem: an infinite family of unirational cubic-surface bundles that are not weakly versal

## 1. The family and the action

Fix an odd integer \(n\ge 3\). Let

\[
D_{2n}=\langle r,s\mid r^n=s^2=1,\ srs=r^{-1}\rangle
\]

be the dihedral group of order \(2n\), and let \(\epsilon\) be a primitive
\(n\)-th root of unity. On the base \(\mathbf P^1_{S,T}\), put

\[
r[S:T]=[\epsilon S:\epsilon^{-1}T],
\qquad
s[S:T]=[T:S].
\tag{1.1}
\]

Let \(z\) generate a cyclic group \(C_3\), let \(\omega\) be a primitive
cube root of unity, and let

\[
z[U:V:X:Y]=[\omega U:\omega^2V:X:Y]
\tag{1.2}
\]

on \(\mathbf P^3_{U,V,X,Y}\). The dihedral group acts trivially on the
fiber coordinates and \(C_3\) acts trivially on the base. Set

\[
G_n=C_3\times D_{2n}.
\tag{1.3}
\]

The two base forms

\[
A_0=S^{2n}+T^{2n},
\qquad
A_1=(ST)^n
\tag{1.4}
\]

are \(D_{2n}\)-invariant and have no common zero. For binary cubics
\(F_0,F_1\in \mathbf C[X,Y]_3\), define the bidegree-\((2n,3)\)
hypersurface

\[
\begin{aligned}
\mathcal X_{n,F_0,F_1}=\{\Phi=0\}
\subset \mathbf P^1\times\mathbf P^3,
\qquad
\Phi={}&A_0(U^3+V^3)\\
&+UV(A_0X+A_1Y)\\
&+A_0F_0(X,Y)+A_1F_1(X,Y).
\end{aligned}
\tag{1.5}
\]

Every monomial in (1.5) has \(z\)-weight zero, so (1.5) is
\(G_n\)-invariant.

## 2. Main theorem

> **Theorem.** For every odd \(n\ge3\), there is a nonempty Zariski-open
> subset
> \[
> \mathcal U_n\subset
> \mathbf C[X,Y]_3\oplus\mathbf C[X,Y]_3
> \]
> such that, for every \((F_0,F_1)\in\mathcal U_n\):
>
> 1. \(\mathcal X_{n,F_0,F_1}\) is a smooth projective threefold with a
>    faithful generically free \(G_n\)-action;
> 2. the projection
>    \(\mathcal X_{n,F_0,F_1}\to\mathbf P^1\) is a cubic-surface bundle;
> 3. \(\mathcal X_{n,F_0,F_1}\) is ordinarily unirational;
> 4. the action satisfies Condition (A);
> 5. the equivariant universal-torsor obstruction and every higher
>    Amitsur group vanish;
> 6. nevertheless
>    \[
>    \boxed{
>    \mathcal X_{n,F_0,F_1}
>    \text{ is not weakly }G_n\text{-versal}.}
>    \]
>    In particular it is not \(G_n\)-unirational.

This is an infinite family both in the integer \(n\) and in the parameters
\((F_0,F_1)\).

## 3. Smoothness

Let \(Z\subset\mathbf P^1\times\mathbf P^3\) be the line-bundle base locus

\[
Z=\{X=Y=0\}.
\]

As \((F_0,F_1)\) vary, the moving part

\[
A_0F_0(X,Y)+A_1F_1(X,Y)
\]

is base-point-free away from \(Z\): \(A_0,A_1\) do not vanish
simultaneously, and binary cubics separate every point of
\(\mathbf P^1_{X,Y}\). Hence Bertini gives smoothness of a general member
away from \(Z\).

It remains to check the intersection with \(Z\). There the equation is

\[
A_0(U^3+V^3)=0.
\tag{3.1}
\]

The relevant derivatives along \(Z\) are

\[
\Phi_X=UV A_0,
\qquad
\Phi_Y=UV A_1,
\qquad
\Phi_U=3A_0U^2,
\qquad
\Phi_V=3A_0V^2,
\tag{3.2}
\]

and the base differential contains

\[
dA_0\,(U^3+V^3).
\tag{3.3}
\]

If \(A_0\ne0\), equation (3.1) forces \(U,V\ne0\), and
\(\Phi_X\ne0\). If \(A_0=0\) and \(UV\ne0\), then \(A_1\ne0\), so
\(\Phi_Y\ne0\). Finally, if \(A_0=0\) and \(UV=0\), then
\(U^3+V^3\ne0\), and \(dA_0\ne0\) because \(S^{2n}+T^{2n}\) is
squarefree. Thus every member is smooth along its intersection with
\(Z\). The Bertini-open set of smooth total spaces is therefore nonempty.

The same argument, now on \(\mathbf P^1_{S,T}\times\mathbf P^1_{X,Y}\),
shows that a general curve

\[
C_{n,F_0,F_1}:
A_0F_0(X,Y)+A_1F_1(X,Y)=0
\tag{3.4}
\]

is smooth. It has ample bidegree \((2n,3)\), hence is connected; smoothness
then makes it irreducible. Intersecting the two nonempty Bertini-open sets
defines \(\mathcal U_n\).

## 4. Ordinary unirationality

The projection to \(\mathbf P^1\) has cubic-surface generic fiber. It has
three rational sections

\[
[S:T]\longmapsto
([S:T],[1:-\rho:0:0]),
\qquad \rho^3=1,
\tag{4.1}
\]

because \(1+(-\rho)^3=0\). For \((F_0,F_1)\in\mathcal U_n\), the generic
fiber is smooth. Kollár's theorem on cubic hypersurfaces therefore gives a
dominant rational map

\[
\mathbf P^2_{\mathbf C(\mathbf P^1)}
\dashrightarrow
(\mathcal X_{n,F_0,F_1})_{\eta}.
\]

Spreading this map over a nonempty open subset of the base yields a
dominant rational map from \(\mathbf P^1\times\mathbf P^2\). Hence the
total threefold is unirational.

## 5. The central fixed locus

The projective fixed locus of \(z\) in the fiber is

\[
\mathbf P(\langle X,Y\rangle)
\ \sqcup\
\{[1:0:0:0]\}
\ \sqcup\
\{[0:1:0:0]\}.
\]

Consequently

\[
\mathcal X_{n,F_0,F_1}^{z}
=
C_{n,F_0,F_1}
\ \sqcup\
P_U
\ \sqcup\
P_V,
\tag{5.1}
\]

where \(C_{n,F_0,F_1}\) is the smooth curve (3.4), and each of \(P_U,P_V\)
consists of one point over every zero of \(A_0\). Thus

\[
|P_U|=|P_V|=2n.
\tag{5.2}
\]

The curve has bidegree \((2n,3)\) in \(\mathbf P^1\times\mathbf P^1\), so
adjunction gives

\[
g(C_{n,F_0,F_1})=(2n-1)(3-1)=4n-2.
\tag{5.3}
\]

In particular, the only positive-dimensional component of
\(\mathcal X^z\) contains no rational curve.

## 6. Empty full fixed locus

Any \(G_n\)-fixed point would project to a point of \(\mathbf P^1\) fixed
by all of \(D_{2n}\). The rotation fixes exactly \(0\) and \(\infty\),
and the reflection interchanges these two points. Hence

\[
(\mathbf P^1)^{D_{2n}}=\varnothing
\qquad\text{and therefore}\qquad
\mathcal X_{n,F_0,F_1}^{G_n}=\varnothing.
\tag{6.1}
\]

## 7. Condition (A)

For odd \(n\), every abelian subgroup of \(D_{2n}\) is cyclic. Indeed, if
a rotation \(r^k\) commutes with a reflection, then
\(r^k=r^{-k}\), so \(2k=0\pmod n\), hence \(k=0\).

Let \(A\le G_n\) be abelian, and let \(B\) be its projection to
\(D_{2n}\). The cyclic group \(B\) fixes a point \(b\in\mathbf P^1\).
Above \(b\), equation (3.4) is a homogeneous binary cubic, hence has a
projective root over \(\mathbf C\) (or vanishes identically). Choose such a
point \(c\in C_{n,F_0,F_1}\). The dihedral group acts trivially on the
fiber coordinates, and \(z\) acts trivially on the curve. Therefore
\(c\in\mathcal X^A\). This proves

\[
\mathcal X^A\ne\varnothing
\qquad\text{for every abelian }A\le G_n.
\tag{7.1}
\]

## 8. Fixed-locus obstruction

The element \(z\) is central in \(G_n\). By (5.1)--(5.3), every
positive-dimensional component of \(\mathcal X^z\) is a curve of genus
\(4n-2\), and by (6.1) the full fixed locus is empty. The central form of
the residual-RCC obstruction in `GENERALIZATIONS.md` therefore excludes
every \(G_n\)-equivariant rational map from a faithful linear source.
Thus \(\mathcal X\) is not weakly \(G_n\)-versal.

Notice that dominance is not used: the obstruction kills even
nondominant maps from faithful linear sources.

## 9. Cohomological obstruction audit

The divisor \(\mathcal X\subset\mathbf P^1\times\mathbf P^3\) has ample
class \((2n,3)\). Grothendieck--Lefschetz gives

\[
\operatorname{Pic}(\mathcal X)
\simeq
\operatorname{Pic}(\mathbf P^1\times\mathbf P^3)
\simeq \mathbf Z\mathcal O(1,0)\oplus\mathbf Z\mathcal O(0,1).
\tag{9.1}
\]

Both generators carry honest \(G_n\)-linearizations induced by the two
linear representations (1.1) and (1.2). Hence a \(G_n\)-equivariant
universal torsor exists and its obstruction class is zero. By the theorem
of Scavia--Tschinkel--Zhang,

\[
\operatorname{Am}^m(\mathcal X,G_n)=0
\qquad\text{for every }m\ge2.
\tag{9.2}
\]

Thus Condition (A) and the complete higher-Amitsur hierarchy are silent.
No intermediate-Jacobian-torsor vanishing is claimed here.

## 10. Literature boundary

The current cubic-surface-bundle literature principally studies ordinary
stable rationality and unramified cohomology. Auel--Böhning--Pirutka treat
bidegree-\((2,3)\) bundles over \(\mathbf P^2\), and Pirutka studies Brauer
classes of cubic-surface bundles over rational surfaces. Kollár supplies
the ordinary unirationality theorem used in Section 4. The targeted search
found no source treating the exact actions (1.1)--(1.5), their weak
versality, or this central fixed-curve obstruction.

The pre-packet literature label is therefore
`LITERATURE-STATUS-UNCERTAIN`, not `OPEN-CONFIRMED`: absence from a targeted
search is not itself a proof that the exact family has never appeared.

## 11. Verification

Run

```text
python3 verify_cubic_surface_bundle_family.py --n 3
python3 verify_cubic_surface_bundle_family.py --n 5
python3 verify_cubic_surface_bundle_family.py --n 7
```

The script checks the finite character, invariant-form, squarefreeness,
fixed-locus count, genus, dihedral-abelian-subgroup, and rational-section
inputs. Smoothness for the full parameter-open family is the Bertini
argument in Section 3, not a finite CAS assertion.

Expected marker:

```text
CUBIC_SURFACE_BUNDLE_FAMILY_VERIFY_OK n=<n>
```

## Exit

```text
NEW-EQUIVARIANT-NONUNIRATIONALITY-THEOREM
```
