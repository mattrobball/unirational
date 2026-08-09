# Global theorem for an irreducible retraction base

Assume that the retraction base

\[
B=V_X(H),\qquad \deg H=d-1,
\]

is irreducible.  By the noncollapse theorem, the canonical line map

\[
\lambda:B\dashrightarrow S=F(X)
\]

is nonconstant.  Let `Y` be a smooth model of its normalized graph.
Since `B` and `S` are surfaces, its image has dimension one or two.

## 1. The two structural alternatives

### Surface-image branch

If `lambda(Y)=S`, the map is generically finite.  Pullback of holomorphic
forms is injective, and numerical pullback is injective after tensoring with
`Q`.  The Klein Fano surface has

\[
q(S)=5,\qquad p_g(S)=10,\qquad \rho(S)=25.
\]

Therefore

\[
q(Y)\ge5,\qquad p_g(Y)\ge10,\qquad \rho(Y)\ge25.
\tag{1.1}
\]

If one normalized carrier above any `E_t` is fixed by `t`, then its image is
the genus-four curve `R_t`.  Equivariance supplies all 55 conjugate curves in
the image, so this branch is forced.

### Curve-image branch

Suppose that the image is an irreducible curve `Sigma subset S`.  For a
general line `ell in Sigma`, the fibre of `Y -> Sigma` maps birationally onto
`ell`; hence

\[
Y\sim_{\rm bir}\mathbf P(T_S)|_{\Sigma^\nu}.
\tag{1.2}
\]

The action of `G` on `Sigma^nu` is faithful.  Riemann--Hurwitz and the element
orders `2,3,5,6,11` give

\[
g(\Sigma^\nu)\ge26,
\tag{1.3}
\]

with equality only for signature `(2,3,11)`.

Roulleau's 55 genus-two curves span `NS(S)_Q`, and their permutation module
has a one-dimensional invariant subspace.  Thus

\[
NS(S)^G=\mathbf Z[C],
\]

where `C` is an incidence class, and

\[
[\Sigma]=nC.
\tag{1.4}
\]

Adjunction excludes `n=1`, so `n>=2`.  The tangent-bundle theorem gives

\[
\deg B=K_S\cdot\Sigma=15n.
\]

Since `B sim (d-1)H_X`, also `deg B=3(d-1)`.  Therefore

\[
d=5n+1,
\qquad n\ge2.
\tag{1.5}
\]

## 2. Every ruled family must meet all 55 fixed elliptics

Fix an involution `t`.  Since `E_t subset B`, the inverse image of `E_t` in
`Y` contains a curve dominating `Sigma^nu`.  Otherwise `E_t` would be
contained in a finite union of fibres of (1.2), hence in a finite union of
lines, which is impossible for an irreducible plane cubic.

Consequently every general line parametrized by `Sigma` meets `E_t`.  Let

\[
M_t=\{[\ell]\in S:\ell\cap E_t\ne\varnothing\}.
\]

Then

\[
\Sigma\subset M_t
\qquad\text{for all }t.
\tag{2.1}
\]

Let

\[
\pi:\mathcal I=\mathbf P(T_S)\to S,
\qquad e:\mathcal I\to X,
\qquad \xi=e^*H_X.
\]

Because `E_t` is a two-hyperplane section of `X`,

\[
[E_t]=H_X^2.
\]

Hence

\[
[M_t]=\pi_*e^*[E_t]
      =\pi_*(\xi^2)
      =c_1(\Omega_S)
      =K_S
      =3C.
\tag{2.2}
\]

Since `Sigma` is an irreducible component of the effective curve `M_t`,
intersecting the residual cycle with the ample class `C` gives

\[
0\le C\cdot(M_t-\Sigma)=5(3-n).
\]

Therefore

\[
n\le3.
\tag{2.3}
\]

Combining (1.5) and (2.3), the curve-image branch can occur only at

\[
(n,d)=(2,11)\quad\text{or}\quad(3,16).
\tag{2.4}
\]

## 3. The ruled branch is empty

The durable characteristic-zero self-covariant certificates exclude every
homogeneous `G`-equivariant landing tuple through coordinate degree 24.  The
degree-11 case also has its own direct complete Macaulay2 certificate.
Therefore both degrees in (2.4) are impossible.

### Theorem 3.1 — irreducible-base dominance

For every hypothetical rational `G`-retraction with irreducible base,

\[
\boxed{
Y\longrightarrow F(X)
\text{ is dominant and generically finite}.}
\tag{3.1}
\]

In particular,

\[
q(Y)\ge5,\qquad p_g(Y)\ge10,\qquad \rho(Y)\ge25.
\tag{3.2}
\]

The one-dimensional image escape is completely excluded in all degrees; it
is not merely reduced to a congruence class.

## 4. Remaining scope

The theorem assumes that the full Cartier divisor `B` is irreducible.  For a
reducible invariant `H`, components may be permuted by `G`, individual
components may be fixed components of the Pluecker system, and the 55
elliptics may be distributed among distinct component orbits.  That branch
requires an orbitwise conductor analysis.

Exact exits:

```text
DELTA1-IRREDUCIBLE-BASE-RULED-BRANCH-EXCLUDED
DELTA1-IRREDUCIBLE-BASE-DOMINATES-FANO-SURFACE
```
