# Representative \(V_4\) simultaneous odd normal maps

**Date:** 2026-08-02  
**Pinned base:** `f1f0be57a74f356b88b9e13f8ca343e6fc4a5c10`  
**Primary exits:**

```text
V4-SIMULTANEOUS-CLASSIFICATION-PASS
M1-TRIPLE-ORDER3-ALL-LINE-DEGREE-EMPTY
V4-LOCAL-PATH-HEADLINE-ROUTE-REFUTED
```

**Problem E headline:** **OPEN**

This packet gives a complete exact classification of two decisive strata at a
representative \(V_4\)-triple line.  It proves a new all-line-degree emptiness
theorem for common involution-plane order one and exact triple-line order
three.  It also proves that the analogous order-three-plane branch has a
positive-dimensional trisection locus and contains primitive projective
families of positive line degree.  Consequently a bare \(V_4\) incompatibility,
common-factor, or Problem-F-style resolution-path argument cannot prove that
the Klein cubic is not \(\operatorname{PSL}_2(\mathbf F_{11})\)-unirational.

The last conclusion is a theorem boundary, not a failure to search: the local
positive family is written explicitly and its landing identity is verified
symbolically.

---

## 1. The representative \(V_4\) normal form

Let

\[
G=\operatorname{PSL}_2(\mathbf F_{11}),\qquad K\simeq V_4,
\qquad N_G(K)\simeq A_4.
\]

Over a characteristic-zero field containing a primitive cube root
\(\omega\), the five-dimensional Klein representation restricts as

\[
W=A\oplus B\oplus C\oplus D,
\qquad \dim A=2,\quad \dim B=\dim C=\dim D=1,
\]

where \(A=W^K\), and \(B,C,D\) are the three nontrivial characters of
\(K\).  The quotient \(A_4/K\simeq C_3\) cyclically permutes
\(B,C,D\).  Choose coordinates \(a,b\) on \(A\) of residual weights
\(\omega,\omega^2\), and coordinates \(u_0,u_1,u_2\) on
\(B\oplus C\oplus D\) which are cyclically permuted.

After nonzero diagonal rescaling, the unique invariant Klein cubic has the
normal form

\[
\begin{aligned}
F={}&\kappa_+a^3+\kappa_-b^3\\
&+a\bigl(u_0^2+\omega u_1^2+\omega^2u_2^2\bigr)
+b\bigl(u_0^2+\omega^2u_1^2+\omega u_2^2\bigr)
+u_0u_1u_2. \tag{1.1}
\end{aligned}
\]

The two character hyperplanes \(b=0\) and \(a=0\) cut the two genuine
\(A_4\)-stable smooth cubic surfaces.  Their smoothness gives

\[
\kappa_\pm\ne0,-4. \tag{1.2}
\]

Indeed, in the standard surface

\[
S_\kappa:\quad
\kappa w^3+w(u_0^2+u_1^2+u_2^2)+u_0u_1u_2=0,
\]

\(\kappa=0\) makes \([1:0:0:0]\) singular, while \(\kappa=-4\) makes
\([1:-2:-2:-2]\) singular.

Let \(x,y,z\) be normal coordinates of \(K\)-characters \(B,C,D\).  The
three involution plus-planes through the triple line
\(T=\mathbf P(A)\) have ideals

\[
(y,z),\qquad (x,z),\qquad (x,y). \tag{1.3}
\]

---

## 2. Common plane order one, exact triple-line order three

### 2.1 Complete pointwise form

A homogeneous degree-three simultaneous normal tuple having order at least
one on all three planes has the unique \(K\)-equivariant form

\[
\begin{aligned}
a'&=p\,xyz,& b'&=q\,xyz,\\
u_0'&=x(\alpha y^2+\beta z^2),&
 u_1'&=y(\gamma x^2+\delta z^2),&
 u_2'&=z(\varepsilon x^2+\varphi y^2). \tag{2.1}
\end{aligned}
\]

Put

\[
U=x^2,\qquad V=y^2,\qquad W=z^2,
\]

and

\[
\begin{aligned}
L_0&=\alpha V+\beta W,\\
L_1&=\gamma U+\delta W,\\
L_2&=\varepsilon U+\varphi V,\\
r_0&=p+q,\\
r_1&=\omega p+\omega^2q,\\
r_2&=\omega^2p+\omega q,\\
c&=\kappa_+p^3+\kappa_-q^3.
\end{aligned} \tag{2.2}
\]

Since

\[
r_0r_1r_2=p^3+q^3, \tag{2.3}
\]

substitution in (1.1), followed by division by \(xyz\), gives the single
cubic identity

\[
L_0L_1L_2+r_0UL_0^2+r_1VL_1^2+r_2WL_2^2+cUVW=0. \tag{2.4}
\]

Its seven coefficient equations are

\[
\begin{array}{lll}
\gamma(\alpha\varepsilon+\gamma r_1)=0,
&\varepsilon(\beta\gamma+\varepsilon r_2)=0,
&\alpha(\alpha r_0+\gamma\varphi)=0,\\[2mm]
\beta(\beta r_0+\delta\varepsilon)=0,
&\varphi(\alpha\delta+\varphi r_2)=0,
&\delta(\beta\varphi+\delta r_1)=0,
\end{array} \tag{2.5}
\]

and

\[
2\alpha\beta r_0+\alpha\delta\varepsilon
+\beta\gamma\varphi+c
+2\delta\gamma r_1+2\varepsilon\varphi r_2=0. \tag{2.6}
\]

These equations are reconstructed exactly by `verify.py`.

### 2.2 Classification on the generic character chart

Assume first that \(r_0r_1r_2\ne0\).  If any one of

\[
\alpha,\beta,\gamma,\delta,\varepsilon,\varphi
\]

is nonzero, equations (2.5) force all six to be nonzero.  For example,

\[
\alpha\ne0\Rightarrow\gamma,\varphi\ne0
\Rightarrow\varepsilon,\delta\ne0
\Rightarrow\beta\ne0,
\]

and the other starting variables give the same closure.  Solving (2.5) then
gives

\[
\beta=\frac{r_1r_2}{\alpha},\qquad
\varepsilon=-\frac{\gamma r_1}{\alpha},\qquad
\varphi=-\frac{\alpha r_0}{\gamma},\qquad
\delta=\frac{r_0r_2}{\gamma}. \tag{2.7}
\]

After this substitution, (2.6) is exactly

\[
c+4r_0r_1r_2=0. \tag{2.8}
\]

Using (2.3), the nondegenerate branch therefore lies over the three-point
subscheme

\[
(\kappa_++4)p^3+(\kappa_-+4)q^3=0
\quad\subset\quad\mathbf P(A). \tag{2.9}
\]

If all six transverse coefficients vanish, (2.4) instead gives

\[
\kappa_+p^3+\kappa_-q^3=0, \tag{2.10}
\]

which is the type-II triple \(X\cap\mathbf P(A)\).

If one of \(r_0,r_1,r_2\) vanishes identically, then \([p:q]\) is one of
three further points cyclically permuted by \(A_4/K\).

Finally, if \(p=q=0\), equation (2.4) becomes

\[
L_0L_1L_2=0. \tag{2.11}
\]

Thus the image lies in one of the three edges of the triangle
\(u_0u_1u_2=0\).

### 2.3 All-line-degree emptiness theorem

Let the coefficients in (2.1) now be homogeneous binary forms of an arbitrary
line degree \(n\) on

\[
T=\mathbf P(A)\simeq\mathbf P^1.
\]

Cancel their common binary divisor.  Because a common zero on \(\mathbf P^1\)
is the same as a common linear factor, the resulting tuple defines a
basepoint-free projective family over \(T\).  Projective equivariance is
unaffected if the cancelled divisor is semi-invariant.

On the dense open where \((p,q)\ne(0,0)\), the classification above says that
\([p:q]\) lies in one of the finite residual-\(C_3\)-stable sets (2.9),
(2.10), or \(r_i=0\).  Since \(T\) is connected, \([p:q]\) is constant.
But the only fixed points of the residual \(C_3\)-action on
\(\mathbf P(A)\) are the two character points \([1:0]\) and \([0:1]\).
Condition (1.2) shows that neither character point occurs in (2.9) or (2.10),
and neither occurs in \(r_i=0\).  Hence no such equivariant family exists.

If \(p=q=0\), the image of the irreducible total source in the triangle is
irreducible and residual-\(C_3\)-stable.  The residual \(C_3\) cyclically
permutes the three edges and the three vertices; the triangle contains no
nonempty irreducible \(C_3\)-stable subvariety.  This branch is impossible as
well.

We have proved:

> **Theorem 2.12 (all line degrees).**  There is no nonzero
> \(A_4\)-equivariant simultaneous landing family with common involution-plane
> order \(m=1\) and exact triple-line transverse order three, for any positive
> or zero line degree.  Equivalently, the entire projective order-three
> common-line landing stratum is empty before any degree cutoff.

This is stronger than every bounded degree-25 chart calculation on this
stratum.  It does **not** exclude common plane order one with triple-line
order at least four.

---

## 3. Common plane order three: the nondegenerate trisection branch

The situation changes at common plane order three.  Set

\[
X=yz,\qquad Y=zx,\qquad Z=xy,
\qquad U=X^2,\quad V=Y^2,\quad W=Z^2.
\]

The degree-six part of

\[
J_3=(y,z)^3\cap(x,z)^3\cap(x,y)^3
\]

contains ten monomials.  Their \(K\)-character multiplicities are

\[
1_{\mathrm{triv}}+3_B+3_C+3_D. \tag{3.1}
\]

Consequently every \(K\)-equivariant degree-six tuple has the unique form

\[
\begin{aligned}
a'&=p(xyz)^2,&b'&=q(xyz)^2,\\
u_0'&=X L_0(U,V,W),&
 u_1'&=Y L_1(U,V,W),&
 u_2'&=Z L_2(U,V,W), \tag{3.2}
\end{aligned}
\]

where the \(L_i\) are arbitrary linear forms.  After division by
\(XYZ=(xyz)^2\), the landing equation is again (2.4).

Suppose the diagonal coefficients

\[
d_0=[U]L_0,\qquad d_1=[V]L_1,\qquad d_2=[W]L_2
\]

and the three \(r_i\) are nonzero.  Normalize

\[
\begin{aligned}
L_0&=d_0(U+AV+BW),\\
L_1&=d_1(CU+V+DW),\\
L_2&=d_2(EU+FV+W).
\end{aligned} \tag{3.3}
\]

Writing

\[
R_0=r_0d_0/(d_1d_2),\quad
R_1=r_1d_1/(d_0d_2),\quad
R_2=r_2d_2/(d_0d_1),\quad
C_0=c/(d_0d_1d_2),
\]

the three pure-cube coefficients give

\[
R_0=-CE,\qquad R_1=-AF,\qquad R_2=-BD. \tag{3.4}
\]

The six mixed noncentral coefficients factor as

\[
\begin{aligned}
&(AC-1)(CF+E)=0,&&(AC-1)(AE+F)=0,\\
&(BE-1)(C+DE)=0,&&(BE-1)(BC+D)=0,\\
&(DF-1)(A+BF)=0,&&(DF-1)(AD+B)=0. \tag{3.5}
\end{aligned}
\]

Because all six off-diagonal factors appearing in (3.4) are nonzero, (3.5)
forces

\[
AC=BE=DF=1. \tag{3.6}
\]

Thus

\[
C=A^{-1},\qquad E=B^{-1},\qquad F=D^{-1}. \tag{3.7}
\]

The central coefficient reduces to

\[
\tau^2-\left(2+\frac{c}{p^3+q^3}\right)\tau+1=0,
\qquad \tau=\frac{AD}{B}. \tag{3.8}
\]

Here we used

\[
R_0R_1R_2=-1,\qquad d_0d_1d_2=-(p^3+q^3).
\]

Therefore the nondegenerate simultaneous-normal space is, up to a finite
étale diagonal-scaling cover, a \((\mathbf G_m)^2\)-bundle over the double
cover

\[
\tau+\tau^{-1}
=2+\frac{\kappa_+p^3+\kappa_-q^3}{p^3+q^3}. \tag{3.9}
\]

In particular, it is not a finite state space and it cannot support a
Problem-F-style constancy argument.

---

## 4. Exact positive-line-degree family

On a character hyperplane, put

\[
\kappa=\frac{(B^3-1)^2}{B^3}.
\]

The exact trisection is

\[
\begin{aligned}
w&=-XYZ,\\
u_0&=X(X^2+B Y^2+B^{-1}Z^2),\\
u_1&=Y(Y^2+B Z^2+B^{-1}X^2),\\
u_2&=Z(Z^2+B X^2+B^{-1}Y^2). \tag{4.1}
\end{aligned}
\]

Direct expansion gives

\[
\kappa w^3+w(u_0^2+u_1^2+u_2^2)+u_0u_1u_2=0. \tag{4.2}
\]

Let \([s:t]\) be coordinates on the triple line and let

\[
\ell_i=s-\omega^i t,\qquad i=0,1,2.
\]

The forms \(\ell_i\) are pairwise coprime and are cyclically permuted, up to
one common scalar, by the residual \(C_3\)-action.  Diagonal precomposition

\[
Q_{B,\ell}([s:t];x,y,z)
=Q_B(\ell_0x,\ell_1y,\ell_2z) \tag{4.3}
\]

therefore gives a projective-character \(A_4\)-equivariant simultaneous
landing family.  Every coefficient is a binary form of degree six.  The
coefficients of the three pure terms \(X^3,Y^3,Z^3\) contain respectively

\[
\ell_1^3\ell_2^3,\qquad
\ell_2^3\ell_0^3,\qquad
\ell_0^3\ell_1^3, \tag{4.4}
\]

whose gcd is one.  Hence (4.3) is primitive as a projective family and has
positive line degree six.

For the honest \(W\)-linearization one multiplies by the appropriate
inverse-character linear form, producing the familiar common character
factor and line degree seven.  That factor disappears after projectivization;
it is not a resolution-path obstruction.

For every odd common plane order

\[
m=2r+1\ge3,
\]

the first permissible common-line layer satisfies

\[
(J_m)_{3r+3}=(xyz)^{r-1}(J_3)_6.
\]

Thus multiplication of (4.3) by \((xyz)^{r-1}\) gives a simultaneous local
landing state at every odd \(m\ge3\).  Cubic homogeneity preserves (4.2).

---

## 5. Why the Problem-F resolution path cannot close Problem E

For the degree-two del Pezzo example, every rational component in the
resolution path mapped constantly because every relevant involution fixed
locus contained no rational curve.  Here each involution fixed locus is

\[
X^t=E_t\sqcup L_t,
\]

with \(E_t\) elliptic and \(L_t\simeq\mathbf P^1\).  At a representative
\(V_4\), the three \(L_t\) form the triangle of type-I vertices.  Formula
(4.3) is an exact nonconstant simultaneous map through that configuration.
It supplies the missing rational bridges explicitly.

Therefore none of the following can be true:

1. every simultaneous odd normal map is incompatible;
2. every positive-line-degree simultaneous projective map is constant;
3. every such map has a projectively meaningful common factor;
4. every equivariant resolution path propagates one constant value.

The only unconditional all-line-degree exclusion obtained here is Theorem
2.12, the \(m=1\), exact triple-order-three stratum.

This agrees with the repository's stronger global evidence: high-twist
\(G\)-compatible symbolic classes with the prescribed projective trisections
exist, and one such class satisfies the nonlinear Klein equation through
\(I^{(11)}\).  The fixed boundary/normal-order-three-four continuation is
obstructed at the next gate, but changed boundary data, higher triple-line
order, and other leading orders remain possible.

---

## 6. Exact remaining theorem boundary

A proof of the negative headline would still have to exclude all of the
following:

- common plane order \(m=1\) with triple-line order at least four;
- odd \(m\ge3\) whose first nonzero common-line layer occurs above
  \((xyz)^{r-1}(J_3)_6\);
- changed boundary data not covered by the closed fixed-germ Fable branch;
- global landing mechanisms not detected by the plus-plane arrangement.

The classification above proves that the requested bare local route cannot
supply those exclusions.  Consequently this packet does **not** assert that
the Klein cubic is not \(G\)-unirational.

---

## 7. Replay

```sh
python3 verify.py
```

Expected terminal line:

```text
V4_SIMULTANEOUS_ODD_NORMALS_VERIFY_OK
```

No external CAS is used.  The verifier uses exact symbolic algebra in SymPy.
