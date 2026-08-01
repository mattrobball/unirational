# Exact descended elliptic-normal-quintic component

## 1. Geometric component

For every smooth complex cubic threefold \(X\), the smooth elliptic normal
quintics form a smooth 10-dimensional Hilbert locus. Serre construction maps
it to the 5-dimensional moduli open \(M_X\) of stable rank-two bundles
\(E\) with \(c_1(E)=0,c_2(E)=2\). The fibre is

\[
\mathbf P(H^0(E(1)))\simeq\mathbf P^5,\qquad h^0(E(1))=6.
\]

The bundle-moduli Abel--Jacobi map is an open embedding into the degree-two
cycle torsor \(J_2\).

## 2. The Klein Pfaffian bundle

The exact representation alignment gives

\[
B_5\hookrightarrow\bigwedge^2V_6^*.
\]

Writing \(x=(x_1,\ldots,x_5)\), this is a skew \(6\times6\) matrix of linear
forms \(M(x)\). The producer and independent verifier prove

\[
\operatorname{Pf}(M(x))
=c\bigl(x_1^2x_2+x_2^2x_3+x_3^2x_4+x_4^2x_5+x_5^2x_1\bigr),
\qquad c\ne0.
\]

On the smooth Pfaffian cubic, \(\mathcal K=\ker M(x)\) is a rank-two bundle.
The corresponding stable Serre bundle satisfies

\[
E_0(1)=\mathcal K^*,\qquad H^0(E_0(1))=V_6^*.
\]

The moduli point \([E_0]\) is \(G\)-fixed. Its projective section space has
the honest projective \(G\)-action induced by the Schur representation; the
central involution acts by a scalar and disappears in projective space.

## 3. Unique Abel--Jacobi value

The exact period-lattice computation gives \(J(\mathbf C)^G=0\). The full
660-element derivation computation gives

\[
H^1(G,J[3])=0.
\]

The invariant cycle \(H^2\) is a point of the degree-three torsor, so the
class of \(J_1\) is 3-torsion. Kummer exactness and the displayed vanishing
force every \(J_e\) to split as a \(G\)-torsor. Its fixed-point set is a
torsor under \(J^G=0\), hence consists of exactly one point \(q_e\).

In particular, any \(K_{\rm proj}\)-point of the twisted elliptic-quintic
Hilbert component must map to \(q_2\). Since \(M_X\to J_2\) is an open
embedding and \(E_0\) lies over \(q_2\), \(E_0\) is the only possible
descended bundle.

## 4. Brauer obstruction in the fibre

The Schur double cover

\[
1\to\mu_2\to\operatorname{SL}_2(\mathbf F_{11})\to G\to1
\]

defines a Brauer class \(\alpha_{\rm proj}\) on the genuine generic
projective torsor. The pinned exact certificate proves

\[
0\ne\alpha_{\rm proj}\in\operatorname{Br}(K_{\rm proj})[2],\qquad
\operatorname{ind}(A_{\rm proj})=2.
\]

Consequently

\[
{}^T\mathbf P(H^0(E_0(1)))
={}^T\mathbf P(V_6^*)
=\operatorname{SB}(A_{\rm proj}^{\rm op})
\]

has no \(K_{\rm proj}\)-point. Dualization replaces the Brauer class by its
negative, equal to itself because it is 2-torsion. The Severi--Brauer
fivefold has zero-cycle index two, so the obstruction and its exact degree
are both controlled.

It follows that

\[
{}^T\mathcal H_{5,1}(K_{\rm proj})=\varnothing.
\]

This is emptiness of the selected Hilbert component, not pointlessness of
the cubic threefold.

## 5. Galois and universal-family statement

Over the split torsor field, the universal incidence is the zero locus of
\(A(x)\lambda\), with \([\lambda]\in\mathbf P(V_6^*)\). Exact covariance of
\(B_5\subset\bigwedge^2V_6^*\) makes this incidence \(G\)-stable. It
therefore descends to

\[
\mathcal C_T\subset X_T\times\operatorname{SB}(A_{\rm proj}^{\rm op}).
\]

The family exists over \(K_{\rm proj}\); a member over \(K_{\rm proj}\)
does not, because the base Severi--Brauer variety has no rational point.
That distinction is the exact R2 descent obstruction.

