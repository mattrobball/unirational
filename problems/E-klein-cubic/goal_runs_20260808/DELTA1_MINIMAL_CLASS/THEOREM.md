# The degree-one branch: the Klein minimal class is algebraic

**Date:** 2026-08-08  
**Field:** \(\mathbf C\)  
**Verdict:** the ordinary decomposition-of-the-diagonal obstruction does
**not** exclude a rational retraction

Let \(X\) be the Klein cubic threefold and \((J(X),\Theta)\) its principally
polarized intermediate Jacobian.  Put

\[
 \nu=\frac{-1+\sqrt{-11}}2,\qquad
 \mathcal O=\mathbf Z[\nu],\qquad E=\mathbf C/\mathcal O.
\]

Roulleau computes the period lattice of \(J(X)\) and, in particular, proves
that the underlying abelian variety is isomorphic to \(E^5\).  The
isomorphism is not an isomorphism with the product principally polarized
abelian variety; that distinction is retained below.

## 1. General Hermitian lemma

**Lemma 1.1.**  Let \(E\) be an elliptic curve and let
\(A=E^g\).  If \(L\) is any principal polarization on \(A\), then

\[
 \gamma_L=\frac{c_1(L)^{g-1}}{(g-1)!}\in H^{2g-2}(A,\mathbf Z)
 \tag{1.1}
\]

is the cohomology class of an integral algebraic one-cycle.

**Proof.**  Let \(\lambda_0:A\to A^\vee\) be the product principal
polarization.  Then

\[
 M=\lambda_0^{-1}\lambda_L\in\operatorname{End}(A)
\]

is a positive Rosati-symmetric automorphism.  Relative to the product, it is
an integral Hermitian matrix; because it is an automorphism, its inverse
\(B=M^{-1}\) is integral Hermitian as well.

For a column \(a\in\operatorname{End}(E)^g\), let
\(C_a=a_*[E]\) be the algebraic one-cycle obtained from the homomorphism
\(a:E\to A\).  If \(D_N\) is the divisor associated with a Hermitian matrix
\(N\), then

\[
 D_N\cdot C_a=\deg(a^*D_N)=a^*Na.
 \tag{1.2}
\]

Integral Hermitian matrices are integrally spanned by rank-one matrices
\(aa^*\).  For \(\mathcal O=\mathbf Z[\nu]\), an explicit spanning set is

\[
 e_i e_i^*,\quad
 (e_i+e_j)(e_i+e_j)^*,\quad
 (e_i+\bar\nu e_j)(e_i+\bar\nu e_j)^*.
 \tag{1.3}
\]

Thus \(B=\sum n_a aa^*\) gives an integral algebraic cycle
\(Z_B=\sum n_aC_a\).  On the other hand, Riemann--Roch and differentiation
of the polarization determinant give

\[
 \begin{aligned}
 D_N\cdot\gamma_L
 &=\left.\frac{d}{dt}\det(M+tN)\right|_{t=0}\\
 &=\det(M)\operatorname{tr}(M^{-1}N)
  =\operatorname{tr}(BN),
 \end{aligned}
 \tag{1.4}
\]

because \(L\) is principal.  Equations (1.2)--(1.4) show that
\(Z_B\) and \(\gamma_L\) have the same pairing with every divisor.  On
\(E^g\), the Hodge classes of degrees \(2\) and \(2g-2\) both have rank
\(g^2\), and their Poincare pairing is nondegenerate.  Hence
\([Z_B]=\gamma_L\).  \(\square\)

The argument does **not** replace \(\Theta\) by the product polarization.
It uses the inverse of the actual integral Hermitian matrix of \(\Theta\).

## 2. Exact Klein matrix and an explicit cycle

The verifier starts from Roulleau's displayed \(\mathcal O\)-basis

\[
 \begin{aligned}
 u_1&=\frac{v_0-3v_1+3v_2-v_3}{1+2\nu},&
 u_2&=\frac{v_1-3v_2+3v_3-v_4}{1+2\nu},\\
 u_3&=v_0,&u_4&=v_1,&u_5&=v_2,
 \end{aligned}
\]

where
\(v_k=(\xi^k,\xi^{9k},\xi^{3k},\xi^{4k},\xi^{5k})\) and
\(\xi^{11}=1\).  From Roulleau's Hermitian form
\((2/\sqrt{11})I_5\) in the ambient eigenbasis, it obtains the actual
polarization matrix in the \(u_i\)-basis:

\[
M=\begin{pmatrix}
10&-6+3\nu&-3+\nu&-3\nu&3+3\nu\\
-9-3\nu&10&3&-3+\nu&-3\nu\\
-4-\nu&3&5&\nu&-1-\nu\\
3+3\nu&-4-\nu&-1-\nu&5&\nu\\
-3\nu&3+3\nu&\nu&-1-\nu&5
\end{pmatrix}.
\tag{2.1}
\]

Exact inversion in \(\mathbf Q(\sqrt{-11})\) gives

\[
B=M^{-1}=\begin{pmatrix}
220&60-12\nu&-37\nu&48+97\nu&-30-79\nu\\
72+12\nu&22&6-10\nu&29\nu&3-23\nu\\
37+37\nu&16+10\nu&19&-41+8\nu&35-5\nu\\
-49-97\nu&-29-29\nu&-49-8\nu&118&-98-4\nu\\
49+79\nu&26+23\nu&40+5\nu&-94+4\nu&79
\end{pmatrix}.
\tag{2.2}
\]

All entries are in \(\mathcal O\).  To make algebraicity completely
explicit, write the upper entry \(B_{ij}=a_{ij}+b_{ij}\nu\).  Then

\[
 \frac{\theta^4}{4!}=[Z_B],
 \tag{2.3}
\]

where

\[
 Z_B=\sum_{i=1}^5 c_i C_{e_i}
 +\sum_{i<j}\left(a_{ij}C_{e_i+e_j}
 +b_{ij}C_{e_i+\bar\nu e_j}\right),
 \qquad
 (c_1,\ldots,c_5)=(173,-7,157,-189,502).
 \tag{2.4}
\]

The signed coefficients are allowed: Voisin's criterion asks for an
algebraic one-cycle, not an effective curve.  `verify.py` reconstructs
\(B\) from (2.4), as well as recomputing (2.1) from the cyclotomic period
lattice.

## 3. Consequence for the degree-one restriction branch

Applying Lemma 1.1 with \(A=J(X)\simeq E^5\) proves:

**Theorem 3.1.**  The minimal integral class

\[
 \frac{\theta^4}{4!}\in H^8(J(X),\mathbf Z)
\]

is algebraic.  By Voisin's cubic-threefold criterion, the Klein cubic has
universally trivial \(CH_0\), equivalently it admits a Chow-theoretic
decomposition of the diagonal.

Therefore a hypothetical degree-one ambient restriction, which would give a
rational \(G\)-retraction, is **not** contradicted by ordinary universal
\(CH_0\) or decomposition-of-the-diagonal theory.  The conclusion is only
that this necessary obstruction passes.  It does not prove retract
rationality and it does not construct a rational retraction.

```text
KLEIN-IJ-MINIMAL-CLASS-ALGEBRAIC
KLEIN-CUBIC-UNIVERSALLY-CH0-TRIVIAL
DELTA1-ORDINARY-DECOMPOSITION-DIAGONAL-OBSTRUCTION-PASSES
DELTA1-RATIONAL-G-RETRACTION-EXISTENCE-OPEN
```

