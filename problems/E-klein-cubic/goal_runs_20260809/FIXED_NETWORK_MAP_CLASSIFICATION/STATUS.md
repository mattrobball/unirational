# Fixed-network map classification: status

**Date:** 2026-08-09  
**Repository base:** `091d4f5d4314c556da96d1804c49be13f48a78c8` (`main`)  
**Problem:** `E-klein-cubic`  
**Exit:** **FIXED-NETWORK-CLASSIFICATION-UNDECIDED**

## Executive verdict

The requested finite classification of the **actual** component maps on an arbitrary resolved graph is not presently proved. The obstruction is structural, not computational.

1. The marked residual action on `E_t` recorded in `certificates/MARKED_S3_GEOMETRY.md` contains a group-law error. After correction, residual equivariance permits nonzero `E_t[2]` translations.
2. The abstract reduced fixed-curve network admits an explicit infinite family of genuine `G`-equivariant morphisms.
3. The first blowup of a type-I or type-II `V_4` point has exceptional divisor `P^2`; its involution-fixed lines provide rational bypasses absent from the surface argument for Problem F.
4. Every involution plus-plane is a forced ambient base component, so the headline map on the fixed locus is carried by exceptional geometry rather than simply by the original elliptics and lines.
5. Polarization gives an exact base-corrected identity. It gives `d=n^2` only after a still-unproved vanishing of the base correction on the canonical elliptic carrier.

Consequently this packet does **not** claim:

- `FIXED-NETWORK-FINITE-PROFILE-THEOREM`;
- `FIXED-NETWORK-UNIQUE-PROFILE`;
- `FIXED-NETWORK-ALL-PROFILES-IMPOSSIBLE`;
- `KLEIN-PSL2(11)-NONUNIRATIONAL`.

## Proved results

### Corrected residual `S_3` model

Choose a type-I point as origin. Then

\[
\tau(P)=P+q,\qquad \sigma(P)=-P,
\qquad q\in E_t[3]\setminus\{0\},
\]

and the three reflections are

\[
\tau^i\sigma(P)=iq-P,\qquad i=0,1,2.
\]

Their fixed sets satisfy `2P=iq`, and their union is exactly

\[
E_t[2]+\langle q\rangle.
\]

The old assertion that the three reflections are `P -> e-P` for the three nonzero `e in E_t[2]` is incompatible with the `S_3` multiplication table.

### Strict elliptic maps

Every nonconstant residual-`S_3`-equivariant self-map is

\[
P\longmapsto[n]P+a,
\qquad n\equiv1\pmod3,\quad a\in E_t[2].
\]

There is no equivariant constant map to `E_t`. The type-I orbit is preserved exactly when `a=0`; all twelve marked points are fixed pointwise exactly when

\[
a=0,\qquad n\equiv1\pmod6.
\]

The first nonidentity multiplier of smallest absolute value under this additional marked condition is `n=-5`.

### Strict line maps

In a coordinate with

\[
\tau(z)=\omega z,\qquad \sigma(z)=z^{-1},
\]

the nonconstant commuting maps are exactly

\[
R(z)=zA(z^3),\qquad A(u)A(u^{-1})=1.
\]

This is an infinite family. In particular `R_m(z)=z^m` is equivariant whenever `m=1 mod 3`; if `m=1 mod 6`, it fixes the six type-I points pointwise. Thus incidence and residual symmetry do not force the identity on `L_t`.

### Actual maps `E_t -> L_t`

Such maps are not merely formal states. They are the functions satisfying

\[
u(P+q)=\omega u(P),\qquad u(-P)=u(P)^{-1}.
\]

Their degree is divisible by three, and degree-three examples exist by an explicit divisor construction.

### Infinite unbroken-network family

Let `N` be the reduced union of all fixed elliptics and fixed lines. For every

\[
n\equiv1\pmod6,\qquad m\equiv1\pmod6,
\]

the component maps

\[
E_t\xrightarrow{[n]}E_t,
\qquad L_t\xrightarrow{z^m}L_t
\]

glue at all type-I and type-II points to a genuine `G`-equivariant morphism

\[
\Phi_{n,m}:N\to N.
\]

The proposed profile is `Phi_{-5,1}`, but it is not isolated by the network.

### Polarization

For a primitive degree-`d` ambient covariant, after principalization with base divisor `F`,

\[
q^*O_X(1)=p^*O_X(d)\otimes O(-F).
\]

On an elliptic carrier `C` mapping by `[n]+a`,

\[
3n^2=3d-F\cdot C.
\]

Hence `d=n^2` requires the additional theorem `F.C=0` on the canonical carrier.

## Smallest missing structural theorem

The remaining problem is an **ambient base-carrier rigidity theorem** for the actual principalized Rees algebra. It must:

1. construct canonical refinement-invariant horizontal elliptic and rational carriers;
2. show how every exceptional surface above a type-I or type-II point factors through them;
3. exclude the explicit `P^2` bypasses and faithful-`V_4` rational curves when they are incompatible with an ambient covariant;
4. compute the base intersections `F.C`;
5. couple the carriers over all 55 `V_4` configurations.

Formal inverse-limit states and associated-graded normal jets do not provide these acceptance conditions.

## Verification

Run:

```text
python3 verify_profiles.py
```

Terminal marker:

```text
FIXED_NETWORK_PROFILE_VERIFY_OK
```
