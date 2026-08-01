# Arbitrary-rank valuation foundations

This note isolates the two valuation-theoretic steps used in `THEOREM.md`.
They are stated for arbitrary-rank henselian valuation rings; no noetherian
or discrete hypothesis is used.

## 1. Centrality of finite tame inertia

Let `(L,w)/(K,v)` be a finite Galois extension of henselian valued fields.
Let `D=Gal(L/K)` and let

\[
I=\ker(D\longrightarrow\operatorname{Gal}(Lw/Kv))
\]

be inertia.  Assume:

1. `char(Kv)=0`; and
2. `K` contains all roots of unity, all with value zero.

Then `I` is central in `D`.

Indeed, ramification theory supplies the pairing

\[
I\longrightarrow
\operatorname{Hom}(wL/vK,(Lw)^\times),\qquad
\sigma\longmapsto\left(
w(x)+vK\longmapsto\overline{\sigma(x)/x}
\right).
\]

Its kernel is the wild ramification group.  The characteristic exponent of
`Kv` is one, so the wild group is trivial and this map is injective.  This
is the arbitrary-rank ramification pairing; see Engler--Prestel, *Valued
Fields*, Springer 2005, Section 5.3: Lemmas 5.3.1--5.3.2 construct the
pairing and identify its kernel, Theorem 5.3.3(1) kills that kernel in
residue characteristic zero, and Corollary 5.3.8 gives the corresponding
finite-extension statement.

For `delta in D`, valuation preservation says `w(delta x)=w(x)`, and the
pairing is equivariant:

\[
\chi_{\delta\sigma\delta^{-1}}(\gamma)
=\bar\delta(\chi_\sigma(\gamma)).
\]

Every value of `chi_sigma` is a root of unity.  All roots of unity already
lie in `K`, have value zero, and reduce into the base residue field `Kv`.
Thus `bar(delta)` fixes them.  Hence
`chi_(delta sigma delta^-1)=chi_sigma`; injectivity gives

\[
\delta\sigma\delta^{-1}=\sigma.
\]

This proves `I subset Z(D)` without a rank-one value group or a noetherian
valuation ring.  In the Klein application, `C subset K_v^h`, the valuation
is trivial on `C`, and therefore both hypotheses hold.

## 2. Trivial inertia and the finite-etale model

Let `R` be the henselian valuation ring of `K_v^h`, with residue field
`kappa`.  A constant finite-group torsor over the fraction field is
represented by a continuous cocycle from the absolute Galois group.  If its
inertia image is trivial, the cocycle factors through the residue Galois
group.  It therefore defines a finite etale `G`-torsor `T_0/kappa`.

The required integral torsor is obtained by the equivalence

\[
\{\text{finite etale }R\text{-algebras}\}
\simeq
\{\text{finite etale }\kappa\text{-algebras}\}.
\]

This equivalence holds for every henselian local ring.  The precise
reference is the Stacks Project, Lemma 10.153.7, Tag
[`04GK`](https://stacks.math.columbia.edu/tag/04GK).  Applying it with the
finite `G`-action lifts `T_0` to a finite etale `G`-torsor `mathcal T/R`
whose generic fibre represents the original unramified torsor class.

This is deliberately **not** the assertion that the integral closure of an
arbitrary non-noetherian valuation ring in a finite field extension is a
finite module.  No such assertion is used.

Twisting the honest rank-five representation gives a finite locally free
`R`-module.  Every finite projective module over a local ring is free, so
its projectivization is `P4_R`.  Etale descent of the smooth invariant Klein
cubic gives the smooth model used in `THEOREM.md`.

Finally, smooth residue points lift over a henselian pair by the Stacks
Project, Lemma 15.13.3, Tag
[`0H74`](https://stacks.math.columbia.edu/tag/0H74).  Both Stacks lemmas are
ring-theoretic and do not impose noetherianity.

## 3. Scope consequence

The dichotomy used by this packet is therefore exact:

```text
nontrivial inertia
    -> central inertia -> exact PSL2(F11) centralizer point;
trivial inertia
    -> residue torsor -> finite-etale henselian model
    -> C1 residue point -> smooth lift.
```

It applies to `K_v^h` for any Krull valuation `v` trivial on `C`.  Claims
about a differently defined higher-rank completion require a separately
specified embedding or an explicit successive complete-DVR construction.
