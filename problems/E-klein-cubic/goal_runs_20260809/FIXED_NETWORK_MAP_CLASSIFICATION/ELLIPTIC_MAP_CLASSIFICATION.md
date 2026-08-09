# Classification of maps from fixed elliptic components

Fix an involution `t`, abbreviate `E=E_t`, `L=L_t`, and use the corrected residual action

\[
\tau(P)=P+q,\qquad \sigma(P)=-P,
\qquad q\in E[3]\setminus\{0\}.
\]

## 1. Nonconstant maps `E -> E`

The exact invariant

\[
j(E)=8192/11
\]

is not an algebraic integer, so `E` has no complex multiplication and

\[
End(E)=Z.
\]

Every nonconstant morphism is therefore uniquely

\[
u(P)=[n]P+a
\]

with `n != 0` and `a in E`.

Commutation with translation gives

\[
[n](P+q)+a=[n]P+a+q
\iff (n-1)q=0
\iff n\equiv1\pmod3.
\]

Commutation with reflection gives

\[
[-n]P+a=[-n]P-a
\iff 2a=0.
\]

Hence:

> **Elliptic self-map classification.** The nonconstant residual-`S_3`-equivariant maps `E -> E` are exactly
> \[
> P\mapsto[n]P+a,
> \qquad n\equiv1\pmod3,\quad a\in E[2].
> \]

There is no separate sign parameter; negative integers give the negative multiplications.

A constant equivariant map would have a value fixed by the free translation `tau`, so no residual-equivariant constant map to `E` exists.

## 2. Marked-point action

Every marked point is uniquely

\[
P=e+iq,
\qquad e\in E[2],\quad i\in Z/3.
\]

For `u=[n]+a`, under `n=1 mod 3`,

\[
u(e+iq)=(n\bmod2)e+a+iq.
\]

Consequences:

- if `n` is odd and `a=0`, every marked point is fixed;
- if `n` is odd and `a != 0`, the four `E[2]` labels are translated by `a`, so the type-I orbit is exchanged with one type-II orbit;
- if `n` is even, all four labels collapse to the single orbit `a+<q>`;
- the type-I orbit is preserved exactly when `a=0`;
- all twelve marked points are fixed pointwise exactly when
  \[
  a=0,\qquad n\equiv1\pmod6.
  \]

The first nonidentity integer of smallest absolute value in this last congruence class is

\[
n=-5.
\]

Residual equivariance alone does not isolate it: for example `n=4`, with any `a in E[2]`, is locally equivariant.

## 3. Permissible target components

Since `E` is pointwise fixed by `t`, equivariance implies

\[
u(E)\subset X^t=E\sqcup L.
\]

The image of an irreducible curve is irreducible. Thus a nonconstant strict map can land only in `E_t` or `L_t`; it cannot land nonconstantly in a fixed component for another involution unless that component is also an irreducible component of `X^t`.

## 4. Nonconstant maps `E -> L`

Choose a coordinate on `L` such that

\[
\tau(z)=\omega z,
\qquad \sigma(z)=z^{-1},
\qquad \omega^3=1,\ \omega\ne1.
\]

A morphism `u:E->L` is residual-equivariant exactly when

\[
u(P+q)=\omega u(P),
\qquad u(-P)=u(P)^{-1}.
\tag{4.1}
\]

This is an exact functional classification.

### Degree divisibility

Let `M=u^*O_{P^1}(1)` have degree `r`. The first equation gives `T_q^*M ~= M`. On `Pic^r(E)`, translation by `q` changes the divisor-sum class by `rq`. Hence

\[
rq=0,
\qquad 3\mid r.
\]

### Degree-three existence

Choose

\[
p=e+r_0\in E[6]
\]

with `0 != e in E[2]` and with the `E[3]` component `r_0` outside `<q>`. Put

\[
D=(p)+(p+q)+(p+2q),
\qquad D'=-D.
\]

The divisors are disjoint. Their group-law sums are `3p` and `-3p`; since `6p=0`, they are linearly equivalent. Choose a rational function with

\[
div(u)=D-D'.
\]

Translation by `q` preserves this divisor, so

\[
u(P+q)=\lambda u(P),
\qquad \lambda^3=1.
\]

If `lambda=1`, `u` descends through the degree-three etale quotient `E->E/<q>` and would induce a degree-one map from an elliptic curve to `P^1`, impossible. Thus `lambda` is a primitive cube root; reverse the orientation of `q` if necessary. Reflection exchanges `D` and `D'`, so after scaling `u`,

\[
u(-P)=u(P)^{-1}.
\]

This gives an actual degree-three residual-equivariant map `E->L`.

## 5. Branch constraints for `E -> L`

Let `e_P` be the local degree.

- Riemann-Hurwitz gives ramification degree `2r`.
- The ramification divisor is `S_3`-stable.
- At a reflection-fixed source point, the image is fixed by the same reflection and local equivariance forces
  \[
  e_P\equiv1\pmod2.
  \]
- Zeros and poles away from reflection-fixed points occur in `<q>`-orbits and are exchanged by reflection.
- A generic degree-three example has one free `S_3` orbit of six simple ramification points.

These conditions do not reduce the maps to a finite list.

## 6. Maps to rational exceptional components

Let `R=P^1` be stable under the full residual `S_3`. Up to conjugacy, the image of `S_3 -> PGL_2` is:

1. faithful `S_3`;
2. the sign quotient `C_2`;
3. trivial.

Accordingly, an equivariant map `E->R` is respectively:

1. governed by the functional equations (4.1) after conjugacy;
2. invariant under `<tau>` and hence factors through the elliptic quotient `E/<q>`;
3. invariant under all `S_3` and hence factors through `E/S_3 ~= P^1`.

If `R` has only a proper stabilizer, further cases occur. Therefore arbitrary equivariant resolutions can create infinitely many rational targets; a finite theorem must first identify the essential carriers of the actual Rees algebra.

## 7. Global incidence effect

The unbroken network excludes the local translation and `E->L` possibilities:

- adjacent nonconstant fixed lines force each type-I point to map to itself;
- this forces the elliptic image to lie in `E_t` and forces `a=0`;
- type-II triple incidence then forces `n` odd, hence `n=1 mod 6`.

An exceptional detour can remove the original elliptic branch or route through a line-valued exceptional component. Excluding that detour is exactly the missing ambient carrier theorem.
