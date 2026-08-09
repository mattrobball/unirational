# Ambient postcomposition dichotomy theorem

**Date:** 2026-08-09  
**Field:** `C`  
**Group:** `G = PSL_2(F_11)`  
**Threefold:** Klein cubic `X = V(F) subset P(W_5)`

## Theorem

Let

\[
\mathscr A_G(X)=\{A:\mathbf P(W_5)\dashrightarrow X:
A\text{ dominant and }G\text{-equivariant}\}
\]

and let

\[
\operatorname{End}^{\mathrm{rat,dom}}_G(X)
\]

be the monoid of dominant rational `G`-selfmaps of `X`.

> **Theorem (postcomposition closure).** There is a natural right action
> \[
> \mathscr A_G(X)\times
> \operatorname{End}^{\mathrm{rat,dom}}_G(X)
> \longrightarrow \mathscr A_G(X),
> \qquad (A,\sigma)\longmapsto \sigma\circ A.
> \]
> If `A|_X = phi`, then
> \[
> (\sigma\circ A)|_X=\sigma\circ\phi
> \]
> and
> \[
> \deg((\sigma\circ A)|_X)=\deg(\sigma)\deg(\phi).
> \]

### Proof

Represent `A` by a primitive homogeneous `G`-covariant tuple

\[
P=(P_0,\ldots,P_4)
\]

with the exact global identity

\[
F(P)=0.
\]

Represent `sigma` on `X` by homogeneous sections of `O_X(e)` and choose
ambient homogeneous lifts

\[
S=(S_0,\ldots,S_4).
\]

Because `sigma(X) subset X` and the homogeneous ideal of `X` is `(F)`, there is
a homogeneous polynomial `B` such that

\[
F(S)=F\,B.
\]

Now substitute the five forms `P_i` for the ambient variables:

\[
F(S(P))=F(P)B(P)=0.
\]

Thus `S(P)` is a homogeneous landing tuple on all of `W_5`. Equivariance is
preserved under composition. Since both maps are dominant, `sigma o A` is
dominant. If the five coordinates of `S(P)` have a common factor `h`, divide
by `h`; homogeneity of the cubic gives `F(S(P)/h)=0`, so primitive reduction
preserves the landing identity. This proves closure.

The restriction identity is tautological on the common domain. Since dominant
selfmaps of the threefold are generically finite, degrees multiply under
composition.

## Corollary: empty-or-unbounded dichotomy

The accepted tangent-residual theorem constructs a nonidentity dominant
`G`-selfmap `sigma` with

\[
q:=\deg\sigma\ge3.
\]

For any `A in mathscr A_G(X)` with `delta_0=deg(A|_X)`, the ambient maps

\[
A_m=\sigma^m\circ A
\]

have restriction degrees

\[
\deg(A_m|_X)=q^m\delta_0.
\]

Hence exactly one of the following occurs:

1. `mathscr A_G(X)=emptyset`; or
2. ambient-extendable restrictions have unbounded degree.

In particular, if `mathscr A_G(X)` is nonempty, then none of the following can
hold:

- every ambient restriction is the identity;
- every ambient restriction has degree one;
- ambient restrictions admit a finite exact list that records global degree.

## Consequence for the retraction branch

A rational `G`-retraction `A` with `A|_X=id_X`, if it exists, immediately
produces nonidentity ambient-extendable restrictions `sigma^m` by
postcomposition. Thus the former architecture

```text
ambient degree one -> identity -> retraction -> exclude retraction
```

cannot describe a nonempty ambient category. Proving an ambient degree-one
theorem would already imply that **no ambient landing map exists**, because
postcomposition would otherwise produce degree greater than one.

## Correct target

The meaningful negative theorem is therefore not an ambient selfmap
classification but

```text
NO-DOMINANT-G-AMBIENT-LANDING-MAP
```

which is precisely the negative solution of Problem E for the source
`P(W_5)`.

Normalized Rees geometry should henceforth be used as an obstruction to the
existence of the first ambient landing ideal, not as machinery expected to
classify a nonempty degree-one subclass.
