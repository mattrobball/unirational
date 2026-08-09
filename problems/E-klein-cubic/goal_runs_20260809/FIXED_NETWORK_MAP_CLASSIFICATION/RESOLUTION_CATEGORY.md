# The resolved-map category

## 1. Ambient principalization

Let \(Y=\mathbf P(W_5)\). Choose a primitive homogeneous representative of a
hypothetical map

\[
f=[f_0:\cdots:f_4]\colon Y\dashrightarrow X\subset\mathbf P(W_5)
\]

of degree \(d\). The tuple spans a \(G\)-stable linear system and defines a
\(G\)-stable coherent base ideal \(\mathcal I\subset\mathcal O_Y\).

Canonical principalization in characteristic zero may be applied
equivariantly because the construction is functorial for automorphisms.
Thus there is a sequence

\[
Y_r\stackrel{\pi_r}{\longrightarrow}Y_{r-1}
\longrightarrow\cdots\longrightarrow Y_0=Y
\]

such that:

- each center \(C_i\subset Y_i\) is smooth and \(G\)-stable;
- a center may be disconnected, but its connected components form
  \(G\)-orbits;
- \(C_i\) has normal crossings with the accumulated exceptional divisor;
- after including the strict transform of any chosen boundary, the centers
  can be taken to have normal crossings with that boundary as well;
- \(\mathcal I\mathcal O_{Y_r}=\mathcal O_{Y_r}(-F)\) for an effective
  SNC divisor \(F\);
- the transformed linear system is base-point-free and defines
  \(\widetilde f\colon Y_r\to\mathbf P(W_5)\);
- because the cubic equation vanishes on the rational-map image, it vanishes
  identically after pullback, so \(\widetilde f\) factors through \(X\).

One may instead resolve the normalized graph. The two constructions have a
common \(G\)-equivariant refinement.

## 2. Restriction to the cubic

The installed `FULL_G_RESTRICTION_DOMINANCE` theorem gives a dominant
rational self-map

\[
\varphi=f|_X\colon X\dashrightarrow X.
\]

Let \(\Gamma^\nu\) be the normalized closure of its graph and let
\(Z\to\Gamma^\nu\) be a smooth \(G\)-equivariant resolution. Then

\[
p\colon Z\to X
\]

is proper birational and

\[
q\colon Z\to X
\]

is a morphism. An ambient principalization can be chosen so that its
restriction dominates this graph resolution.

The actual component-map problem belongs to the quadruple

\[
(Z,p,q,\operatorname{Exc}(p)),
\]

not to an associated-graded transition state.

## 3. Fixed-locus blowup formula

Let \(H\le G\) be abelian, let \(C\subset Y_i\) be a smooth \(H\)-stable
center, and let \(S\) be a connected component of \(C^H\). Since \(H\) is
linearly reductive,

\[
N_{C/Y_i}|_S=\bigoplus_{\chi\in H^\vee}N_\chi
\]

as vector bundles. The exceptional divisor is
\(\mathbf P(N_{C/Y_i})\). A point \([v]\) over \(S\) is fixed by \(H\)
exactly when the line \(\langle v\rangle\) is an \(H\)-subrepresentation.
Therefore

\[
\mathbf P(N_{C/Y_i})^H|_S
=
\coprod_{\chi:\,N_\chi\ne0}\mathbf P(N_\chi).
\]

The trivial-character piece is part of the blowup of the old fixed locus.
Each nontrivial-character piece is a new fixed component, with dimension

\[
\dim S+\operatorname{rk}N_\chi-1.
\]

For a nonabelian \(H\), the same statement uses the one-dimensional
\(H\)-subrepresentations of the normal bundle; higher-dimensional
irreducibles do not contribute projectively fixed points.

This is the valid part of the blowup calculus in
`theory/FIX_I_bcomplex.md`.

## 4. What cannot be assumed about centers

Principalization centers are smooth and \(G\)-stable, but one cannot assume
without proof that they are:

- unions of pre-existing fixed strata;
- rational;
- rationally connected;
- pointwise fixed by their stabilizers;
- contained in the positive-dimensional fixed-curve network;
- chosen only from the first normal cone.

This distinction is decisive. If a later center has a genus-\(g\) fixed
component \(S\), then \(\mathbf P(N_\chi)\to S\) is not rationally chain
connected for \(g>0\). The correction already recorded in
`FIX_I_bcomplex.md` gives genus-three examples.

Accordingly, the global assertion in that draft that every fixed component
on every model of a linear source is rationally chain connected is false.
Only the following conditional statement is valid:

> If every fixed component of every chosen center is rationally chain
> connected, then the newly born projective fixed bundles are rationally
> chain connected.

This closes under stabilizer-stratified towers, not under arbitrary
principalizations.

## 5. Refinement category

Define \(\mathsf{Res}_G(\varphi)\) as follows.

An object is a smooth resolved graph

\[
(X\stackrel p\longleftarrow Z\stackrel q\longrightarrow X)
\]

together with an SNC divisor containing \(\operatorname{Exc}(p)\), such
that \(p\) is proper birational and \(q\) is a \(G\)-morphism.

A morphism

\[
(Z',p',q')\longrightarrow(Z,p,q)
\]

is a sequence of smooth \(G\)-equivariant blowups
\(\rho\colon Z'\to Z\) satisfying

\[
p'=p\circ\rho,\qquad q'=q\circ\rho.
\]

The category is cofiltered: two graph resolutions admit a common
equivariant refinement.

## 6. Why raw component lists are not invariants

A further blowup can create new fixed projective bundles and fixed curves.
The map on each new component is simply the restriction of \(q\circ\rho\),
but the number, dimension, genus, and residual action of these pieces need
not be bounded by the original network data. Therefore a “profile” listing
every component on one selected resolution is not invariant.

A resolution-independent profile must instead be formulated using one of:

- divisorial valuations over \(X\);
- generic horizontal components over a fixed source stratum;
- a minimal carrier extracted from the principalized Rees algebra;
- an equivalence class of component diagrams under refinement.

The repository's formal inverse-limit states record leading characters, but
they do not construct any of these objects.

## 7. Essential carrier definition and missing existence theorem

For a fixed involution \(t\), call an irreducible \(N_G(\langle
t\rangle)\)-stable subvariety \(C\subset Z^t\) an **elliptic carrier** if:

1. \(p(C)\) dominates \(E_t\);
2. the generic fiber of \(C\to E_t\) is connected;
3. \(q(C)\) dominates \(E_t\).

Define a **line carrier** similarly with \(L_t\).

These definitions are invariant under strict transform, but existence,
uniqueness, and dimension are not automatic. In particular, blowing up
\(E_t\) produces an exceptional ruled surface, not a preferred section.

The missing theorem must prove that the actual base ideal singles out a
canonical carrier (usually a curve or a factorization through one) and that
all other fixed exceptional pieces are subordinate to it. Without that
theorem there is no well-defined finite global profile.

## 8. Forced plus-plane base and its consequence

`LOCAL_TRANSITION_MODULES.md` proves that every involution plus-plane

\[
\mathbf P(E_+(t))\simeq\mathbf P^2
\]

is an ambient base component and that the first nonzero transverse order is
odd with leading image in \(L_t\). Hence \(E_t\subset X\cap\mathbf
P(E_+(t))\) is not a base-free strict source curve for the ambient map.

This prevents a direct use of the strict classification as the headline
classification. The desired \([-5]\) map, if it occurs, must be recovered
from a later exceptional carrier and coupled to the first normal map. That
is precisely the unproved carrier problem.

## 9. Resolution invariance actually established

The following statements survive every further equivariant blowup:

- the morphism \(q\) on the resolved graph;
- the image component of any fixed irreducible component under \(q\);
- the pullback identity
  \(q^*H=d\,p^*H-F\);
- strict residual-equivariance equations whenever a stable carrier curve
  exists;
- the local fixed-projective-bundle formula above.

The following do not survive without an equivalence relation:

- the number of fixed exceptional components;
- their genera;
- their dual complex;
- a selected path through a three-dimensional fiber;
- a componentwise degree list.

This is the exact resolved-map category used in the rest of the packet.
