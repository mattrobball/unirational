# Global dichotomy for an irreducible retraction base

Assume that the retraction base

\[
B=V_X(H),\qquad \deg H=d-1,
\]

is irreducible.  By the noncollapse theorem, the canonical line map

\[
\lambda:B\dashrightarrow S=F(X)
\]

is nonconstant.  Let `Y` be a smooth model of its normalized graph.
Since `B` and `S` are surfaces, exactly two alternatives remain.

## 1. Surface-image branch

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
`R_t`.  Equivariance supplies all 55 conjugate curves `R_s` in the image.
An irreducible curve cannot contain two distinct `R_s`, so the existence of a
single fixed carrier forces this surface-image branch.

## 2. Curve-image branch is a ruled incidence surface

Suppose that the image is an irreducible curve `Sigma subset S`.  For a
general line `ell in Sigma`, the fibre of `Y -> Sigma` has dimension one and
its source points lie on `ell`.  Hence the fibre maps birationally onto `ell`,
and

\[
Y\dashrightarrow\mathbf P(T_S)|_{\Sigma^\nu}
\]

is birational.  Equivalently, `B` is the ruled incidence surface swept out by
the lines parametrized by `Sigma`.

The action of `G` on `Sigma^nu` is faithful.  Its kernel is normal in the
simple group `G`; a trivial action of all of `G` would make every line in
`Sigma` a `G`-stable two-dimensional subspace of the irreducible module `W_5`.

### Minimal genus

The element orders in `G` are `2,3,5,6,11`.  Riemann--Hurwitz shows that the
smallest positive orbifold Euler characteristic possible for a faithful
`G`-curve is

\[
1-\frac12-\frac13-\frac1{11}=\frac5{66},
\]

coming from signature `(2,3,11)`.  Four or more branch points give a larger
value, and positive quotient genus gives a larger value as well.  Thus

\[
g(\Sigma^\nu)\ge
1+\frac{|G|}{2}\frac5{66}=26.
\tag{2.1}
\]

### Invariant Neron--Severi class

Let `C` be an incidence divisor class on `S`.  Roulleau's 55 genus-two curves
span `NS(S)_Q`, and their permutation module has a one-dimensional invariant
subspace.  Since `C` is invariant,

\[
NS(S)_Q^G=\mathbf Q C.
\]

The integral invariant lattice is exactly `Z C`.  Indeed, if an integral
invariant class is `qC`, then intersection with `C` and with a genus-two curve
gives `5q` and `2q`; their integrality forces `q in Z`.

Consequently

\[
[\Sigma]=nC
\qquad(n\ge1).
\tag{2.2}
\]

Adjunction gives

\[
p_a(\Sigma)
=1+\frac{(nC)^2+K_S\cdot nC}{2}
=1+\frac{5n^2+15n}{2}.
\tag{2.3}
\]

For `n=1` this is 11, contradicting (2.1).  Hence

\[
n\ge2.
\tag{2.4}
\]

If `n=2`, then `p_a=26`, so `Sigma` is smooth of genus 26 and the action has
minimal signature `(2,3,11)`.

### Coordinate-degree congruence

Let

\[
\pi:\mathcal I=\mathbf P(T_S)\to S,
\qquad e:\mathcal I\to X
\]

be the universal family, and put `xi=e^*H_X`.  The tangent-bundle theorem gives

\[
\pi_*(\xi^2)=c_1(\Omega_S)=K_S.
\]

Since `Y` is birational to the universal family over `Sigma` and to `B`,

\[
\deg B
=K_S\cdot\Sigma
=3C\cdot nC
=15n.
\tag{2.5}
\]

On the other hand `B sim (d-1)H_X` on the cubic threefold, so

\[
\deg B=3(d-1).
\tag{2.6}
\]

Combining (2.5) and (2.6) yields the exact congruence

\[
\boxed{d=5n+1,\qquad n\ge2.}
\tag{2.7}
\]

In this branch

\[
q(Y)=g(\Sigma^\nu)\ge26,\qquad p_g(Y)=0.
\tag{2.8}
\]

Moreover no carrier over an involution elliptic can be fixed by that
involution; otherwise the image would contain `R_t` and the map would be in
the surface-image branch.

## 3. Exact dichotomy

For an irreducible retraction base, exactly one of the following holds.

### Dominant Fano branch

\[
Y\to S\text{ generically finite},
\qquad q(Y)\ge5,\ p_g(Y)\ge10,\ \rho(Y)\ge25.
\]

### Ruled curve branch

\[
Y\sim_{\rm bir}\mathbf P(T_S)|_{\Sigma^\nu},
\qquad [\Sigma]=nC,\qquad d=5n+1,\qquad n\ge2,
\]

with `G` acting faithfully on `Sigma^nu`, `g(Sigma^nu)>=26`, and every
involution boundary carrier occurring in a nonfixed paired orbit.

This is an all-degree structural classification of the one-dimensional-image
escape.  It does not assert that either branch exists.
