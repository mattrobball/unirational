# Problem E — explicit-map resolution (2026-09-09)

## Verdict

**RESOLVED AFFIRMATIVELY.**  Let

\[
G=\operatorname{PSL}_2(\mathbf F_{11}),\qquad
X=\Bigl\{\sum_{j\bmod5}y_j^2y_{j+1}=0\Bigr\}\subset\mathbf P(A),
\]

where \(A\) is the faithful five-dimensional Klein representation.  There is
an explicit dominant \(G\)-equivariant rational map

\[
\boxed{\Phi:\mathbf P(A^{\oplus4})=\mathbf P^{19}\dashrightarrow X.}
\]

Consequently the Klein cubic is \(G\)-unirational and

\[
\boxed{\operatorname{ed}_{\mathbf C}(G)=3.}
\]

The proof is independent of the surface Cassels--Swinnerton-Dyer theorem and
of the earlier all-twists argument.  It is an explicit Pfaffian construction
with an exact differential certificate for dominance.

## 1. Fixed Pfaffian model

In bases \(A=\mathbf C^5\), \(U=\mathbf C^6\), write

\[
M(y)=\begin{pmatrix}
0&-y_1&-y_3&-y_2&-y_0&-y_4\\
y_1&0&-y_0&0&0&y_3\\
y_3&y_0&0&0&-y_2&0\\
y_2&0&0&0&y_4&-y_1\\
y_0&0&y_2&-y_4&0&0\\
y_4&-y_3&0&y_1&0&0
\end{pmatrix}.
\]

Then

\[
\operatorname{Pf}M(y)=\sum_{j\bmod5}y_j^2y_{j+1}.
\]

The six-dimensional even Weil action and the honest five-dimensional Klein
action satisfy the exact covariance identity

\[
M(gy)=\widetilde g^{-t}M(y)\widetilde g^{-1}
\]

for the standard generators.  This is the equivariant Pfaffian presentation
used by Tschinkel--Zhang.

## 2. Geometric construction

For input \((a_0,a_1,a_2,a_3)\in A^{\oplus4}\), put \(B_i=M(a_i)\).
For an alternating form \(B\) define

\[
C(B)(e_i\wedge e_j\wedge e_k)
=B_{jk}e_i-B_{ik}e_j+B_{ij}e_k.
\]

The common isotropic three-planes for \(B_0,B_1,B_2\) are the decomposable
points in the kernel of

\[
\mathcal C=\begin{pmatrix}C(B_0)\\C(B_1)\\C(B_2)\end{pmatrix}:
\Lambda^3U\to U^{\oplus3}.
\]

On a nonempty open this kernel is two-dimensional and its intersection with
\(\operatorname{Gr}(3,U)\) is a reduced degree-two scheme.  For either point
\(P\), the restriction \(B_3|_P\) has a nonzero radical vector \(v\).  The four
covectors \(B_i(v,-)\) lie in the three-dimensional annihilator of \(P\), so
there is a unique projective relation \((x_0:x_1:x_2:x_3)\) with

\[
\Bigl(\sum_{i=0}^3x_iB_i\Bigr)v=0.
\]

Thus the two isotropic planes produce two conjugate points of the Klein cubic.
The output \(\Phi\) is the residual third intersection of their line with the
cubic.  Every operation in this description is intrinsic, so the resulting
rational map is \(G\)-equivariant.

## 3. Explicit coordinate formula

The complete basis-dependent formula is in
[`explicit_map/klein_rational_coordinates.pdf`](explicit_map/klein_rational_coordinates.pdf)
and its TeX source.  Briefly, order

```text
012,013,014,015,023,024,025,034,035,045,
123,124,125,134,135,145,234,235,245,345.
```

Write \(\mathcal C=(N\mid r\mid s)\) with \(N\) the first 18 columns and use
Cramer's rule to form polynomial kernel vectors \(u,v\).  From one fixed
Pluecker quadratic obtain scalar polynomials \(q_0,q_1,q_2\).  Four fixed
\(3\times3\) cofactor polynomials then produce vectors \(P,Q\in A\), and the
five output coordinates are

\[
R_j=q_2SP_j+(q_1S-q_2T)Q_j,
\]

where

\[
S=\sum_m Q_m^2Q_{m+1},\qquad
T=\sum_m(2Q_mQ_{m+1}+Q_{m-1}^2)P_m.
\]

These \(R_j\) are homogeneous polynomials of common degree 568 before
cancelling common factors, and

\[
\Phi=[R_0:R_1:R_2:R_3:R_4].
\]

No algebraic root is selected anywhere in the final formula.

## 4. Nonempty domain and dominance

At

\[
\begin{aligned}
b_0&=(1,1,0,0,1),& b_1&=(0,1,-1,1,0),\\
b_2&=(-1,-1,1,-1,-1),& b_3&=(-1,1,-1,0,0),
\end{aligned}
\]

one has

\[
\det N=1,\qquad q(z)=z^2+3z+1,
\qquad \Phi(b_0,b_1,b_2,b_3)=[3:-2:2:-1:2].
\]

In the affine target chart \(y_0\neq0\), differentiating with respect to
\((a_0)_0,(a_0)_2,(a_1)_0\) gives

\[
J=\begin{pmatrix}
13/3&26/9&52/9\\
0&-17/9&-16/9\\
1/3&19/9&29/9
\end{pmatrix},\qquad
\det J=-\frac{221}{27}\neq0.
\]

Therefore the differential has rank three at this point.  Since the image lies
in the smooth irreducible threefold \(X\), \(\Phi\) is dominant.

## 5. Consequences and compatibility with the earlier campaign

The source \(A^{\oplus4}\) is an honest linear \(G\)-representation, so the
dominant map proves \(G\)-unirationality directly.  The known lower bound
\(\operatorname{ed}_{\mathbf C}(G)\ge3\) then gives equality.

The following older results remain compatible and are retained:

- the direct standard-source homogeneous landing search is empty through
  coordinate degree 34;
- the formalized theorem excluding maps from honest linear sources into the
  degree-fourteen Fano partner remains valid;
- the many fixed-locus, valuation, and subgroup calculations retain their
  stated bounded or structural conclusions.

They do not obstruct the present map from \(\mathbf P(A^{\oplus4})\) to the
cubic itself.

## 6. Certification scope

The `explicit_map/` directory contains the one-page coordinate note and exact
verification programs.  The programs recompute the Pfaffian identity and
covariance, the stated example, and the Jacobian certificate.  This resolution
is **not yet Lean formalized** and should not be described as such.

Historical files predating 2026-09-09 may still say `OPEN`; for the Problem E
headline they are superseded by this document.
