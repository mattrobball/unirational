# Exact structural theorem

Let \(G=\operatorname{PSL}_2(\mathbf F_{11})\), let \(W\) be its
five-dimensional irreducible representation, and put
\(K_0=\mathbf C(W)^G\).  Write

\[
 F(z_0,\ldots,z_4)=\sum_{i\in\mathbf Z/5}z_i^2z_{i+1}.
\]

The covariants \(x,C,D,E,K\) from the Problem E exact certificate form a
Hilbert--90 frame at the generic point.  In the descended coordinates

\[
 z=a_0x+a_1C+a_2D+a_3E+a_4K,
 \qquad \Phi(a)=F(z),
\]

the generic twist is the cubic \(X=\{\Phi=0\}\subset\mathbf P^4_{K_0}\).

## Theorem

The plane

\[
 \Pi=\{a_3=a_4=0\}\subset\mathbf P^4_{K_0}
\]

meets \(X\) in a smooth plane cubic \(C\).  Blowing up \(C\) resolves the
hyperplane pencil through \(\Pi\) and gives a type-I Sarkisov link

\[
 X \xleftarrow{\pi}Y=\operatorname{Bl}_{C}X
   \xrightarrow{f}\mathbf P^1_{K_0},
 \qquad f=[a_3:a_4].
\]

The variety \(Y\) is smooth, \(\rho(Y)=2\), and \(f\) is a Mori fibre space
whose generic fibre is a smooth cubic surface.  In particular
\(\rho(Y/\mathbf P^1)=1\) and \(-K_Y\) is relatively ample.

## Proof

Equivariance of the five covariants makes their generic values invariant
vectors in the twisted vector space.  Their determinant is not the zero
rational function: at

\[
 w_0=(-2,-2,-2,-2,-1)
\]

it equals \(-295136920\).  Hence they are a \(K_0\)-basis, so \(\Pi\), its
hyperplane pencil, and \(C\) are all defined over \(K_0\).

Smoothness is open.  At the same exact specialization, the first three frame
columns are

\[
\begin{aligned}
x(w_0)&=(-2,-2,-2,-2,-1),\\
C(w_0)&=(280,369,336,272,208),\\
D(w_0)&=(212,92,32,181,172).
\end{aligned}
\]

The resulting plane cubic is the polynomial recorded in
`links/plane_cubic_dp3/intersection_payload.json`.  The independent verifier
checks that its three partial derivatives have no common projective zero by
computing the unit ideal in each of the three standard affine charts.
Therefore the generic discriminant is nonzero and \(C/K_0\) is smooth.

Because \(C\) is the transverse intersection of the two hyperplanes
\(a_3=0\) and \(a_4=0\) on the smooth threefold \(X\),

\[
 N_{C/X}\simeq\mathcal O_C(1)\oplus\mathcal O_C(1).
\]

Thus the ordinary blowup is smooth, with discrepancy one.  Its graph model is

\[
 Y=\{\Phi(a)=0,\ a_3t-a_4s=0\}
 \subset \mathbf P^4_a\times\mathbf P^1_{[s:t]}.
\]

Over \([s:t]\), substitute \(a_3=su\), \(a_4=tu\).  The fibre is

\[
 \Phi(a_0,a_1,a_2,su,tu)=0\subset\mathbf P^3_{[a_0:a_1:a_2:u]},
\]

a cubic surface.  Smoothness of the total space and generic smoothness imply
that its generic fibre is smooth.

Let \(H=\pi^*\mathcal O_X(1)\), let \(E\) be the exceptional divisor, and let
\(L=H-E=f^*\mathcal O_{\mathbf P^1}(1)\).  Then

\[
 K_Y=\pi^*K_X+E=-2H+E,\qquad -K_Y=2H-E=H+L.
\]

Both \(H\) and \(L\) are semiample.  The morphism defined by their product is
the graph embedding into \(X\times\mathbf P^1\), so \(H+L\) is ample.  The
cone calculation in `MORI_CONES.md` then shows that \(f\) is the second
extremal contraction and has relative Picard rank one.  On a fibre,
\(-K_Y|_{Y_\eta}=H|_{Y_\eta}\), the anticanonical class of a cubic surface.
This proves the theorem.

## Headline bridge, and no more

A rational section of \(f\) gives a \(K_0\)-point of \(Y\) and hence, after
composition with \(\pi\), a \(K_0\)-point of \(X\).  By the accepted generic
twist criterion, that would imply a dominant rational map from a
representation to the Klein cubic. Conversely, a \(K_0\)-point of \(X\) away
from \(C\) lies on only one member of the pencil and does not itself sweep out
a section. This packet does not settle existence of points or sections. The
valid conclusion is precisely the structural Mori-fibre exit.

The generic fibre contains \(C_{K_0(\mathbf P^1)}\) as a hyperplane section,
so it has a degree-three zero-cycle and index dividing three. The full
arithmetic audit, including why unrelated degree-55 cycles cannot be used to
force index one, is in `ARITHMETIC.md`.
