# Ambient normalized blowup versus the restricted carrier graph

## 1. The actual ambient ideal

Let
\[
P=\mathbf P(W_5),
\qquad
f:P\dashrightarrow X
\]
be a hypothetical landing map, and let `I_f` be the primitive homogeneous base
ideal of an actual landing tuple.  Put
\[
\widehat P=
\operatorname{Proj}_P\overline{\mathcal R(I_f)}.
\]
Equivalently, `widehat P` is the normalization of the closure `G_f` of the
graph of `f` in `P×X`.

The fixed-network problem concerns the dominant restriction
\[
g=f|_X:X\dashrightarrow X.
\]
Let `J` be the primitive ideal sheaf obtained by restricting the same landing
tuple to `X` and removing its common divisorial factor.  Removing that factor
does not change the rational map or its graph.  Write
\[
\Gamma=
\operatorname{Proj}_X\overline{\mathcal R(J)},
\]
the normalization of the graph closure `G_g⊂X×X`.

## 2. Dominant-transform theorem

Let `U⊂P` be the domain of `f`.  Inside `widehat P`, take the closure
\[
\widehat X_{\mathrm{dom}}
=
\overline{\pi^{-1}(X\cap U)}.
\]
It is the unique irreducible component of the inverse image of `G_g` that
dominates `X`.  Then there is a canonical `G`-equivariant isomorphism
\[
\bigl(\widehat X_{\mathrm{dom}}\bigr)^\nu
\simeq
\Gamma.
\tag{2.1}
\]
The source and landing morphisms on both sides agree.

### Proof

Over `X∩U`, both graph closures are the ordinary graph of `g`, hence are
isomorphic to the normal open set `X∩U`.  The finite normalization map
`widehat P→G_f` is therefore an isomorphism over that open graph.  Its closure
inside `widehat P` is the unique component dominating `G_g`, and its
normalization is finite and birational over `G_g`.  By uniqueness of
normalization it is `Gamma`.  All constructions are canonical and `G`-stable,
which gives equivariance.

## 3. Consequences for carriers

Equation (2.1) explains why the packet works with `J` without replacing the
genuine ambient ideal by an unrelated model.

1. Every intrinsic fixed or stable carrier on `Gamma` is an actual component or
   fixed slice on the normalized dominant transform of `X` inside the ambient
   normalized blowup of `I_f`.
2. For any equivariant principalization of the genuine ambient ideal, the
   normalization of the strict transform dominating `X` factors uniquely
   through `Gamma`.  Carrier maps on a refinement are pullbacks of the maps on
   `Gamma`.
3. An ambient exceptional component that does not meet the dominant transform
   in a landing-horizontal fixed or stable subvariety cannot alter the induced
   fixed-network map on `X`.
4. An intersection of an ambient exceptional component with the dominant
   transform can matter, but after normalization it is exactly a component,
   fixed slice, or contracted refinement divisor covered by the carrier
   definitions and the joint-residue theorem.

Thus the packet classifies what is presently provable about the actual
fixed-network carriers selected by `Proj(overline(Rees(I_f)))` along its
component dominating `X`.  It does not claim to classify ambient Rees divisors
that are disjoint from that component; such divisors are irrelevant to the
restricted fixed-network map.

## 4. Completed local ideal

At a type-I or type-II point `x∈X`, the completed ideal used in
`LOCAL_REES_MODEL.md` is precisely
\[
J_x=
\left(I_f\widehat{\mathcal O}_{X,x}\right)_{\mathrm{primitive}}
\subset
\widehat{\mathcal O}_{X,x}
\simeq\mathbf C[[u,v,w]].
\]
Consequently the local joint-residue survival test is a theorem about the
actual landing tuple restricted to the normalized dominant transform, not an
independent formal normal-cone ideal.
