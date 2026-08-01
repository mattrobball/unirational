# Exact structural theorem

Let \(G=\operatorname{PSL}_2(\mathbf F_{11})\), let \(W\) be its
five-dimensional irreducible representation, and put
\(K_0=\mathbf C(W)^G\).  Write

\[
 F(z_0,\ldots,z_4)=\sum_{i\in\mathbf Z/5}z_i^2z_{i+1}.
\]

The exact Problem E covariants \(x,C,D,E,K\) form a Hilbert--90 frame at the
generic point.  In the descended coordinates

\[
 z=a_0x+a_1C+a_2D+a_3E+a_4K,\qquad \Phi(a)=F(z),
\]

the generic twist is \(X=\{\Phi=0\}\subset\mathbf P^4_{K_0}\).

## Theorem

The plane \(\Pi=\{a_3=a_4=0\}\) meets \(X\) in a smooth plane cubic
\(C\).  Blowing up \(C\) resolves the hyperplane pencil through \(\Pi\) and
gives a type-I Sarkisov link

\[
 X \xleftarrow{\pi}Y=\operatorname{Bl}_C X
   \xrightarrow{f}\mathbf P^1_{K_0},\qquad f=[a_3:a_4].
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

it equals \(-295136920\).  Hence they form a \(K_0\)-basis, so \(\Pi\), its
pencil, and \(C\) are defined over \(K_0\).

Smoothness is open.  At the same exact specialization, the first three frame
columns are

\[
\begin{aligned}
x(w_0)&=(-2,-2,-2,-2,-1),\\
C(w_0)&=(280,369,336,272,208),\\
D(w_0)&=(212,92,32,181,172).
\end{aligned}
\]

The resulting plane cubic is recorded in
`links/plane_cubic_dp3/intersection_payload.json`.  The independent verifier
reconstructs it from literal \(x,C,D\) formulas and proves in all three
standard affine charts that its gradient ideal is the unit ideal.  Thus the
generic plane cubic is smooth.

Because \(C\) is the transverse intersection of two hyperplanes on the
smooth threefold \(X\),

\[
 N_{C/X}\simeq\mathcal O_C(1)\oplus\mathcal O_C(1).
\]

The blowup is smooth with discrepancy one.  Its graph model is

\[
 Y=\{\Phi(a)=0,\ a_3t-a_4s=0\}
 \subset\mathbf P^4_a\times\mathbf P^1_{[s:t]}.
\]

Over \([s:t]\), substitute \(a_3=su\), \(a_4=tu\).  The fibre is the
cubic surface

\[
 \Phi(a_0,a_1,a_2,su,tu)=0
 \subset\mathbf P^3_{[a_0:a_1:a_2:u]}.
\]

Smoothness of the total space and generic smoothness make the generic fibre
smooth.  With \(H=\pi^*\mathcal O_X(1)\), exceptional divisor \(E\), and
\(L=H-E=f^*\mathcal O_{\mathbf P^1}(1)\),

\[
 K_Y=-2H+E,\qquad -K_Y=2H-E=H+L.
\]

The product map \((\pi,f)\) is the graph embedding into
\(X\times\mathbf P^1\), so \(H+L\) is ample.  The exact cone computation in
`MORI_CONES.md` identifies \(f\) as the second extremal contraction with
relative Picard rank one.  On a fibre, \(-K_Y\) restricts to its hyperplane
class, the anticanonical class of a cubic surface.

## Arithmetic refinement in the same family

The parent involution-minus-line certificate gives a line with setwise
stabilizer \(D_{12}\).  Since \(|G|=660\) and \(|D_{12}|=12\), twisting its
orbit gives a connected finite etale degree-55 scheme of lines on the
generic twist.

Planes meeting a fixed geometric line form a proper incidence divisor in
\(\operatorname{Gr}(3,5)\).  The complement of the 55 incidence divisors
meets the Bertini open of planes with smooth cubic section.  This is a
nonempty open in a rational variety over the infinite field \(K_0\), so it
has a \(K_0\)-point.  Choose such a plane and run the same link.

Every orbit line is disjoint from the center plane, so projection maps it
isomorphically to the pencil base.  The generic cubic surface therefore has
a closed point of exact degree 55.  Voisin's 2026 theorem yields

\[
 S\bigl(K_0(\mathbf P^1)\bigr)\ne\varnothing
 \quad\text{or}\quad
 S\text{ has a point over an extension of degree }4.
\]

The first alternative is a rational section.  If it fails, quadratic
third-intersection descent excludes residue degree two, so closure gives a
genuine degree-four multisection.  `ARITHMETIC.md` records the exact boundary.

## Headline bridge, and no more

A rational section gives a \(K_0\)-point of \(Y\), and composition with
\(\pi\) gives a \(K_0\)-point of \(X\).  By the accepted generic-twist
criterion this is headline positive.  Conversely, one \(K_0\)-point of
\(X\) lies on only one member of the pencil and need not sweep out a section.
This packet proves neither a section nor a no-section theorem.
