# R2.2 evaluation and point extraction

## 1. Genus-zero extraction, valid in every degree

Let \(C\subset X_T\) be a geometrically integral \(K\)-curve with genus-zero
normalization \(\widetilde C\). The anticanonical system on
\(\widetilde C\) has a \(K\)-rational effective divisor \(D\) of degree two.
Its image spans a \(K\)-line \(L\subset\mathbf P^4_K\).

- If \(L\subset X_T\), then \(L(K)\ne\varnothing\).
- Otherwise \(L\cap X_T\) is a cubic divisor containing the degree-two
  subscheme \(\nu(D)\); its residual degree-one divisor is a \(K\)-point.

Thus any descended geometrically rational curve, split or nonsplit, gives an
exact point of the genuine twist. This is why rational quartic and quintic
Hilbert points are headline-positive rather than intermediate outputs.

## 2. Selected elliptic-quintic route

For an elliptic normal quintic \(E\subset X_T\), cubic-scroll residuation
requires a degree-two divisor class, equivalently a point of
\(\operatorname{Pic}^2(E)\). The scroll then leaves a residual rational
quartic, to which the genus-zero extraction above applies.

This extra choice cannot bypass the missing point on \(E\). If
\(\alpha\in H^1(K,\operatorname{Jac}(E))\) is its torsor class, then

\[
5\alpha=0
\]

because the embedding supplies a degree-five polarization, while
\(\operatorname{Pic}^2(E)(K)\ne\varnothing\) gives \(2\alpha=0\). Since
\(\gcd(2,5)=1\), both imply \(\alpha=0\), so \(E(K)\ne\varnothing\) already.

On the genuine projective generic twist, the route stops one gate earlier:
the Hilbert fibre itself is the nonsplit
\(\operatorname{SB}(A_{\rm proj}^{op})\), so no \(K\)-defined elliptic
quintic exists.

## 3. Marked quartic incidence

The incidence of a rational quartic with a marked chord line contained in
\(X\) maps to the Fano surface. Its generic twist has no \(K\)-point because
the twisted Fano surface has none. The unmarked quartic has a degree-16 chord
scheme, so absence of a rational marked chord does not exclude an unmarked
\(K\)-quartic.

## 4. Outcome

No point-extraction execution occurs in this packet: the selected Hilbert
component is proved empty over \(K_{\rm proj}\). The algorithms above state
exactly what would be executed for a rational-curve Hilbert point and why the
elliptic-scroll detour cannot weaken the descent requirement.

