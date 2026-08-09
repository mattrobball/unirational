# Classification of maps on the fixed rational lines

Fix an involution `t` and write `L=L_t=P^1`. The residual group is `S_3` with its faithful dihedral action.

## 1. Standard coordinate and marked points

Choose a coordinate `z` such that

\[
\tau(z)=\omega z,
\qquad \sigma(z)=z^{-1},
\qquad \omega^3=1,\ \omega\ne1.
\]

Then:

- the two residual-`C_3` fixed points are `0` and `infinity`; these are the two `C_6` points and are exchanged by every reflection;
- the fixed points of `sigma` are `+1,-1`;
- the fixed points of `tau^i sigma` solve `z^2=omega^i`;
- the six type-I points are therefore `mu_6`, split into two residual `S_3` orbits of size three.

This coordinate is unique up to conjugation by the centralizer of the displayed `S_3`; all classification statements below are coordinate-independent.

## 2. Complete commuting-map classification

Let `R:P^1->P^1` be a nonconstant rational map. Commutation with `tau` is

\[
R(\omega z)=\omega R(z).
\]

Therefore `R(z)/z` is invariant under `z->omega z`, so

\[
R(z)=zA(z^3)
\]

for a rational function `A(u)`.

Commutation with `sigma` gives

\[
R(z^{-1})=R(z)^{-1},
\]

which is equivalent to

\[
A(u^{-1})=A(u)^{-1}.
\tag{2.1}
\]

Thus:

> **Line-map theorem.** The nonconstant residual-`S_3`-equivariant maps `L_t->L_t` are exactly
> \[
> R(z)=zA(z^3),
> \qquad A(u)A(u^{-1})=1.
> \]

By Hilbert 90 for the involution `iota(u)=u^{-1}`, after cancelling common factors every solution is

\[
A(u)=\frac{B(u)}{B(u^{-1})}
\]

for a nonzero rational function `B`.

There is no equivariant constant map because the faithful `S_3` action on `P^1` has no common fixed point.

## 3. Monomial family

For any nonzero integer `m`, the rational map

\[
R_m(z)=z^m
\]

commutes with reflection automatically. It commutes with rotation exactly when

\[
\omega^m=\omega
\iff m\equiv1\pmod3.
\]

Its algebraic degree is `|m|`.

Marked behavior:

- `0,infinity` are preserved individually for `m>0` and exchanged for `m<0`;
- every `z in mu_6` is fixed pointwise exactly when
  \[
  z^{m-1}=1\text{ for all }z\in\mu_6
  \iff m\equiv1\pmod6.
  \]

Examples:

- `z^{-5}` has degree five, fixes all six type-I points, and swaps the two `C_6` points;
- `z^7` has degree seven and fixes all eight marked points individually;
- `z^{1+6k}` gives arbitrarily large degree while fixing the complete marked set on the line.

Thus the identity is not forced by residual symmetry or by pointwise type-I incidence.

## 4. Divisor form and branch data

The equation `A(u)A(u^{-1})=1` means the divisor of `A` is anti-invariant under `u->u^{-1}`. Equivalently, zeros and poles are paired by inversion, with possible contributions at the fixed points `u=+1,-1` constrained to cancel.

For `R` itself:

- the critical divisor is `S_3`-stable;
- local degrees are constant on `S_3` orbits;
- at a type-I point fixed by a reflection, local equivariance compares two sign coordinates and forces the local degree to be odd;
- the two `C_6` points form an `S_3` orbit and have equal local degree if exchanged by reflection.

These restrictions still leave positive-dimensional families in every sufficiently large allowed degree.

## 5. Compatibility with the six type-I incidences

Each type-I point of `L_t` is also the intersection with two other fixed lines and one elliptic belonging to a `V_4` configuration. On the unbroken reduced network, the adjacent component maps force that point to map to itself. Hence the relevant line maps are the subfamily satisfying

\[
R(\zeta)=\zeta
\qquad(\zeta\in\mu_6).
\]

This is still infinite. The monomials `z^{1+6k}` and `z^{-5+6k}` already give infinitely many examples (omitting exponent zero).

The two `C_6` points are not intersections with another positive-dimensional involution-fixed component, so the reduced fixed-curve network alone need not fix them individually.

## 6. Maps from a fixed line to an elliptic target

Every morphism `P^1->E_t` is constant. A residual-equivariant constant would be a global fixed point of the residual `S_3` on `E_t`, but translation by nonzero `q_t` is fixed-point-free. Therefore no residual-equivariant map `L_t->E_t` exists.

This is the key directional rigidity used at type-I points: a nonconstant surviving line must map to the rational component `L_t`.

## 7. Exceptional rational components

A rational component born in a resolution can carry:

- faithful `S_3` action, reducing to the same classification after conjugacy;
- sign-quotient `C_2` action;
- trivial residual action;
- only a proper subgroup action.

The latter three cases have still larger families of equivariant maps. Therefore a finite all-resolution list cannot be obtained by classifying abstract `P^1` actions. One must prove that the actual principalized base ideal selects a finite collection of essential horizontal carriers.

## 8. Conclusion

The actual fixed-line classification is infinite in all degree. The expected identity restriction is one member, not a consequence of the marked `S_3` geometry. Any unique `([-5],id)` profile theorem must derive line identity from ambient carrier and polarization data, not from the line network itself.
