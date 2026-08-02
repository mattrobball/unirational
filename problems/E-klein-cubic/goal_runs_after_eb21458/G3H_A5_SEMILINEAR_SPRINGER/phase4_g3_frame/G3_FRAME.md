# G3H phase 4 — degree-11 field and G3 frame

Marker: `G3H-SEMILINEAR-G3-FRAME-PASS`

## Field \(L_i/K_{\mathrm{proj}}\)

\[
L_i=k(\mathbf P(W))^{H_i},\qquad
K_{\mathrm{proj}}=k(\mathbf P(W))^G,\qquad
[L_i:K_{\mathrm{proj}}]=11.
\]

G4 supplies the executable coset action of \(G\) on \(G/H_i\) (image order 660).
A primitive element \(\theta_i\) is any separating \(H_i\)-invariant rational
function; its resolvent is monic of degree 11 over \(K_{\mathrm{proj}}\).
Multiplication, trace, and norm are the standard operations in
\(K_{\mathrm{proj}}[T]/(\mu_i)\) (equivalently, coset-basis linear algebra).

## Frame point

With covariant frame \(M=(x,C,D,E,K_7)\) of degrees \((1,4,5,6,7)\) and
\(\tau=f_3^2/f_5\),

\[
a_i=\overline M^{-1}(P_i/\tau^{33})
\]

on the open where \(\det M\ne0\), \(P_i\ne0\), and \(\tau\ne0\). Because both
\(M\) and \(P_i\) are \(H_i\)-equivariant of matching weight, \(a_i\) is
\(H_i\)-invariant and therefore \(L_i\)-valued. Power-basis reduction of each
coordinate uses the eleven Galois conjugates indexed by cosets.

## Direct landing

\[
\Phi(a_i)=0
\]

by the identity \(F(M a_i)=F(P_i)=0\) from phase 3 and the definition of
\(\Phi\) in G3A / `generic_cubic.json`.

This installs **executable G3-frame points over \(L_i\)** for both A5 classes.
It does **not** by itself give a \(K_{\mathrm{proj}}\)-point.
