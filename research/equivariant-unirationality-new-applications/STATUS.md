# New applications of the fixed-locus obstruction machinery

**Date:** 2026-08-09  
**Status:** two new negative theorems proved; one general obstruction theorem proved; broader audit remains open-ended.

## Exits

```text
FIXED-LOCUS-OBSTRUCTION-GENERALIZED
NEW-EQUIVARIANT-NONUNIRATIONALITY-THEOREM
NEW-APPLICATIONS-TOP-CANDIDATES-CLASSIFIED
```

The `NEW-EQUIVARIANT-NONUNIRATIONALITY-THEOREM` exit is obtained for two independent classes.

## Theorem 1 — a smooth quartic double solid

Let

\[
B=\{2x_0^4+6x_0x_1x_2x_3+x_1x_3^3+x_1^3x_2+x_2^3x_3=0\}\subset\mathbf P^3
\]

be the unique smooth quartic invariant under the primitive
\(\operatorname{PSL}_2(\mathbf F_7)\)-action, and let

\[
X=\{w^2=B(x)\}\subset\mathbf P(1,1,1,1,2).
\]

Put \(H=C_7\rtimes C_3\), acting by

\[
a=[1,\zeta^4,\zeta^2,\zeta],\qquad
b(x_0,x_1,x_2,x_3)=(x_0,x_2,x_3,x_1),
\]

and let \(\tau\) be the deck involution. For

\[
G=H\times\langle\tau\rangle
\]

the action satisfies Condition (A), its equivariant universal-torsor obstruction vanishes, and hence all higher Amitsur groups vanish. Nevertheless

\[
\boxed{X\text{ is not weakly }G\text{-versal}.}
\]

In particular, the smooth unirational quartic double solid \(X\) is not \(G\)-unirational. The proof uses the new residual-RCC central obstruction: \(X^\tau=B\) is a K3 surface with no \(H\)-stable rational curve and \(B^H=\varnothing\).

See `THEOREM_KLEIN_QUARTIC_DOUBLE_SOLID.md`.

## Theorem 2 — an infinite family of rational conic-bundle surfaces

For every odd \(g\ge3\), let \(S_g\) be the minimal resolution of

\[
T_0T_1(T_0^{2g}+T_1^{2g})+T_2T_3=0
\subset\mathbf P(1,1,g+1,g+1).
\]

This is a rational exceptional conic bundle. Let \(D_{2g}\) act on the base by

\[
r(T_0,T_1)=(\xi T_0,\xi^{-1}T_1),\qquad
s(T_0,T_1)=(T_1,T_0),
\]

where \(\xi\) is a primitive \(2g\)-th root, and let

\[
j(T_2,T_3)=(T_3,T_2).
\]

For

\[
G_g=D_{2g}\times\langle j\rangle
\]

the action satisfies Condition (A), while

\[
S_g^j=\{U^2=-T_0T_1(T_0^{2g}+T_1^{2g})\}
\]

is a smooth hyperelliptic curve of genus \(g\), and \(S_g^{G_g}=\varnothing\). Therefore

\[
\boxed{S_g\text{ is not weakly }G_g\text{-versal}}
\]

for every odd \(g\ge3\). This gives an infinite family of rational \(G\)-conic bundles for which Condition (A) is not sufficient for equivariant unirationality.

See `THEOREM_ODD_EXCEPTIONAL_CONIC_BUNDLES.md`.

## General theorem

The original central and centralizer criteria required that positive-dimensional components of \(Y^\sigma\) contain no rational curve. The proof only needs the following weaker condition:

> every \(C_G(\sigma)\)-stable irreducible rationally chain connected subvariety of \(Y^\sigma\) is a point.

Together with \(Y^{C_G(\sigma)}=\varnothing\), this excludes every equivariant rational map from a faithful linear source and proves non-weak-versality. This is proved in `GENERALIZATIONS.md` using the accepted fixed-stratum survivor argument from the repository.

## Best unresolved target after the two theorems

The highest-ranked remaining case is the special rational Fano threefold of Mori–Mukai family No. 2.18 whose conic-bundle discriminant is the Fermat quartic. Abe gives an explicit model and computes an automorphism group of order \(192\). The deck-fixed surface is rational, so the one-stratum central theorem cannot apply; the missing theorem is a residual-network classification of invariant rational curves on that surface together with the fixed curves of nondeck involutions.

## Exact limits

This packet does **not** prove:

- a complete classification of equivariantly unirational degree-1 or degree-2 del Pezzo actions;
- a Kummer-double-solid theorem beyond the cases already excluded by higher Amitsur groups;
- a second index-one Fano-threefold theorem beyond the repository's \(V_{14}\) result;
- a general three-dimensional exceptional-network theorem.

Those boundaries and the finite next computations are recorded in the thematic files and `TOP5.md`.
