# WP-3 certificate: exact exclusion of degree 30

Date: 2026-07-28.

## Verdict and boundary

The complete degree-30 homogeneous Klein-covariant space contains no
dominant landing covariant. The proof combines the structural Jacobian
identity with exact reduction modulo \(D\) and a seven-coefficient
elimination. Together with the separate degree-32 certificate, the first
homogeneous degree not yet excluded is \(34\).

This remains a bounded exclusion, not a resolution of Problem F: every
even degree \(34\) and higher remains part of the exhaustive homogeneous
problem until separately decided or controlled uniformly.

## 1. Complete family and the \(D\)-residue split

Every degree-30 covariant is

\[
\begin{aligned}
p={}&AF^4D\psi+BFD^3\psi+QF^2C\psi+RC\phi\\
   &+SF^2D\phi+TF^3f+UD^2f. \tag{1}
\end{aligned}
\]

The structural theorem gives

\[
J_p=\lambda XDh,\qquad F(p)=h^2, \tag{2}
\]

because the residual invariant has degree \(30-24=6\), hence is a
multiple of \(D\). In particular, \(D\mid J_p/X\).

The checker restricts exactly to \(x=y=1\) modulo \(D(1,1,z)\). The
weight-66 invariant space modulo \(D\) has basis \(F^{13}C,F^6C^3\).
The \(F^{13}C\) coefficient has a factor \(T\), while after \(T=0\) the
other coefficient is

\[
-90(Q-48R)
 (14AR-5Q^2+312QR-14QS+2816R^2). \tag{3}
\]

On the landing side, the first two coefficients modulo \(D\) are

\[
[F^{30}]F(p)=0,\qquad
[F^{23}C^2]F(p)=9834496T^4. \tag{4}
\]

An invariant \(h\) of weight 60 has, modulo \(D\), support
\(F^{15},F^8C^2,FC^4\). Equation (4) first kills its \(F^{15}\)
coefficient and then forces \(T=0\). The remaining three coefficients
of \(F(p)\) are

\[
\begin{aligned}
L_4={}&-256(Q+8R)^4,\\
L_6={}&-3Q^4+800Q^3R-54912Q^2R^2
       +2473984QR^3-45113344R^4,\\
L_8={}&-2744R^3(Q-34R).
\end{aligned} \tag{5}
\]

They must be the three coefficients of a binary square, so

\[
\begin{aligned}
L_6^2-4L_4L_8
={}&(Q-48R)^4
 (Q^2-320QR+19328R^2)\\
&\mathrel{}\cdot(9Q^2-192QR+19840R^2)=0. \tag{6}
\end{aligned}
\]

If \(R=0\), (6) forces \(Q=0\). With \(Q=R=T=0\), every coordinate
of (1) has the common factor \(D\), contrary to primitive normalization.
Thus normalize \(R=1\). Equation (3) leaves exactly:

- \(Q=48\), with \(A\) initially free;
- the two roots of \(Q^2-320Q+19328=0\);
- the two roots of \(9Q^2-192Q+19840=0\).

On either quadratic pair,

\[
A=QS+\frac{(Q+8)(5Q-352)}{14}. \tag{7}
\]

## 2. Seven high-\(C\) equations

Put \(K=J_p/(XD)\). Equation (2) implies

\[
K^2=\rho F(p) \tag{8}
\]

for a nonzero scalar \(\rho\). The highest coefficients begin with

\[
[FC^4]K=-23520R(Q-34R)(3R+U),\qquad
[F^2C^8]F(p)=-2744R^3(Q-34R). \tag{9}
\]

None of the five ratios in (6) equals \(34\). Consequently \(U=-3\)
would make the first coefficient in (9) zero while the second is
nonzero, and is impossible.

The checker reconstructs six coefficients of \(K\), through \(C^2\),
and seven coefficients of \(F(p)\), through \(C^6\). If these are

\[
\begin{aligned}
K={}&k_4FC^4+(k_{31}F^3D+k_{30}D^3)C^3\\
 &+(k_{20}F^8+k_{21}F^5D^2+k_{22}F^2D^4)C^2+\cdots,
\end{aligned}
\]

and the matching landing coefficients are
\(L_8,L_{41},L_{13},L_{90},L_{62},L_{34},L_{06}\), then (8) gives

\[
\begin{gathered}
2k_4k_{31}L_8-k_4^2L_{41}=0,
\quad2k_4k_{30}L_8-k_4^2L_{13}=0,\\
2k_{20}k_4L_8-k_4^2L_{90}=0,\\
(k_{31}^2+2k_{21}k_4)L_8-k_4^2L_{62}=0,\\
(2k_{31}k_{30}+2k_{22}k_4)L_8-k_4^2L_{34}=0,\\
k_{30}^2L_8-k_4^2L_{06}=0. \tag{10}
\end{gathered}
\]

The Jacobian reconstruction is exact and exhaustive, not sampling
evidence. By the structural theorem \(J_p/X\) is known in advance to be
an invariant of weight 66. That invariant space has dimension 18, and
the checker asserts that its 18-by-18 evaluation matrix is invertible;
hence its exact values at those points uniquely determine all invariant
coefficients. The landing coefficients come from the cached universal
even-covariant quartic, an exact polynomial over \(\mathbf Z[F,D,C]\).

## 3. Exact elimination of all five ratios

For \(Q=48\), make the shifts

\[
A=a-448,\qquad B=b+2048,\qquad U=u-12.
\]

Here \(u=9\) is precisely the already-impossible value \(U=-3\).
For \(u\ne9\), two equations in (10) force

\[
a=48S,\qquad S(u-18)+28(u-6)=0. \tag{11}
\]

At \(u=18\), the second left side is \(336\), so
\(S=-28(u-6)/(u-18)\). The three remaining equations reduce to

\[
\begin{aligned}
P={}&11u^4-312u^3+414u^2+41832u-264600,\\
G={}&-9b^2u+162b^2+456bu^2-35256bu+486864b\\
   &-2352u^4+216096u^3-6887744u^2
     +62676096u-33191424,\\
H={}&-b^2-136bu-1008b+784u^3-25792u^2
     +132160u-856128.
\end{aligned}
\]

The exact Gröbner basis of
\((P,G,H)\subset\mathbf Q[b,u]\) is \([1]\), excluding \(Q=48\).

For either quadratic in (6), the checker substitutes (7), reduces every
equation (10) in \(\mathbf Q[Q]/(r(Q))\), and removes the
already-excluded factor \(U+3\). The first and third equations solve
uniquely for \(B,S\). Every denominator is checked coprime to \(r(Q)\),
so neither conjugate root is lost. Substitution in the last three
equations gives

\[
\operatorname{GB}_{\mathbf Q[Q,U]}
 (r(Q),E_3,E_4,E_5)=[1]
\]

for each of

\[
r(Q)=Q^2-320Q+19328,\qquad
r(Q)=9Q^2-192Q+19840.
\]

Thus all five residue ratios are impossible, completing the degree-30
exclusion.

## Replay

From the repository root, with Python 3 and SymPy installed:

    python3 certificates/wp3_degree30_exclusion.py

It must end with

    EXACT d=30: D-free equations leave ratio 48 and two quadratics
    EXACT d=30: exceptional U=-3 has k4=0 while L8 is nonzero
    EXACT d=30: ratio Q/R=48 has unit ideal
    EXACT d=30: Q^2-320Q+19328 conjugate ratio pair has unit ideal
    EXACT d=30: 9Q^2-192Q+19840 conjugate ratio pair has unit ideal
    WP3_DEGREE30_EXCLUSION_OK

All load-bearing arithmetic is over \(\mathbf Q\); no finite-field or
floating-point inference is used.
