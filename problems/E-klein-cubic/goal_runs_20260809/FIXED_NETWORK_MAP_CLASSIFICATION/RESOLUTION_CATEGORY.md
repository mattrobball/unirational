# Resolution category for actual fixed-component maps

## 1. Principalize the actual base ideal

Represent a hypothetical dominant `G`-equivariant map

\[
f:P(W_5)\dashrightarrow X
\]

by a primitive six-tuple of homogeneous forms of common degree `d`, subject to the equation of the Klein cubic. Let `I` be their common base ideal. It is `G`-stable.

In characteristic zero, functorial principalization can be chosen equivariantly for a finite group. Thus there is a sequence

\[
\widetilde Y=Y_r\to Y_{r-1}\to\cdots\to Y_0=P(W_5)
\]

such that:

- every center is smooth and `G`-stable;
- every center has normal crossings with the accumulated exceptional boundary;
- `I O_{\widetilde Y}=O_{\widetilde Y}(-F)` for an effective SNC divisor `F`;
- the rational map lifts to a `G`-morphism `q:\widetilde Y->X`.

Equivalently, one may normalize and equivariantly resolve the graph. For the component analysis, principalizing the actual ideal is preferable because it retains the base multiplicities needed for polarization.

No claim is made that the centers are unions of fixed strata. Canonical principalization chooses centers from the singularity data of the ideal, and their fixed parts can have positive genus.

## 2. Exact fixed-locus blowup formula

Let `pi:Bl_C(Y)->Y` be one blowup in the tower, with `C` smooth and `G`-stable. Fix an abelian subgroup `H` and a connected component `S` of `C^H`. Along `S`, decompose the normal bundle into character subbundles

\[
N_{C/Y}|_S=\bigoplus_{\chi\in H^\vee}N_\chi.
\]

The exceptional divisor is `P(N_{C/Y})`. A projective point is fixed by `H` exactly when its line lies in one character subbundle. Therefore the exceptional fixed locus over `S` is

\[
\coprod_{N_\chi\ne0}P(N_\chi).
\]

The `chi=1` term is the exceptional divisor inside the blowup of the old fixed component and is not an additional irreducible fixed component. Each nontrivial character contributes a genuinely new fixed projective bundle.

At a point represented by a line `ell subset N_chi`, the tangent characters are obtained from

\[
T P(N)|_{[\ell]}=T S\oplus Hom(\ell,N/\ell)
\]

together with the exceptional normal line `ell`. Thus the normal characters are the nontrivial characters among

\[
\chi^{-1}\mu\quad(\mu\text{ occurring in }N,\ \mu\ne\chi),
\qquad \chi,
\]

plus the normal characters of `S` in `C`. This is the rigorous part of the calculus in `FIX_I_bcomplex.md`.

For a nonabelian subgroup, a projective fixed point corresponds to a one-dimensional subrepresentation. The present type-I/type-II applications use `C_2` and `V_4`, so the character formula is sufficient.

## 3. First `V_4` blowup

At every type-I or type-II point `x`, the installed tangent calculation is

\[
T_xX=\chi_z\oplus\chi_s\oplus\chi_r.
\]

Blowing up `x` creates

\[
D=P(\chi_z\oplus\chi_s\oplus\chi_r)=P^2.
\]

For an involution `z`, one character has `z`-eigenvalue `+1` and the other two have the common eigenvalue `-1`, hence

\[
D^z=P(\chi_z)\sqcup P(\chi_s\oplus\chi_r).
\]

For the whole `V_4`,

\[
D^{V_4}=\{P(\chi_z),P(\chi_s),P(\chi_r)\}.
\]

This fixed locus is disconnected even though `D` is connected and rationally connected.

## 4. Why arbitrary-model RCC propagation is false

The per-blowup assertion

> `P(N_chi)` is a projective bundle over `S`, hence RCC whenever `S` is RCC`

is correct. The induction to all equivariant models is false because a later legal smooth `G`-stable center may have a fixed component `S` of arbitrary genus. Blowing up that center creates a fixed projective bundle over `S`.

This is the correction already inserted into `FIX_I_bcomplex.md`. It has two consequences here:

1. one cannot claim that every fixed component on every resolution is rationally connected;
2. the requested literal finite list of all components on all resolutions is not a meaningful refinement-invariant object.

## 5. Correct morphisms to classify

On any fixed principalization, every irreducible component `C` of `\widetilde Y^H` has an actual morphism

\[
q|_C:C\to X^H.
\]

These maps are honest and can be classified when `C` is a known elliptic or rational curve. Under a further equivariant blowup, however, new vertical components are inserted. A theorem invariant under refinement should therefore distinguish:

- **horizontal carriers:** components or valuations on which the induced function field map is nonconstant and which persist birationally under refinement;
- **vertical refinements:** components created inside fibers solely to resolve indeterminacy or SNC intersections;
- **incidence connectors:** fixed curves or surfaces joining horizontal carriers.

The pushforward of a fixed component to the containing component of `X^H` is refinement-invariant. Its genus, number of inserted components, and dual complex are not.

## 6. Essential-carrier formulation

A viable all-resolution theorem should be phrased using the normalized Rees algebra

\[
\overline{\bigoplus_{m\ge0} I^m t^m}
\]

and its `H`-stable divisorial valuations. A one-dimensional carrier is essential when the restriction of the resolved map to its normalization is nonconstant and the associated valuation/divisorial component is not created solely by further refinement.

Acceptance conditions for an essential-carrier theorem are:

1. existence and uniqueness up to common domination;
2. compatibility with `N_G(H)/H`;
3. functorial identification of marked specializations at type-I and type-II strata;
4. computation of the multiplicity of `F` on the carrier;
5. stability under further equivariant blowups.

None of the formal transition-state packages proves these conditions. They classify possible associated-graded leading terms, not horizontal components of the normalized Rees algebra.

## 7. Polarized resolved-map identity

Principalization gives the base-point-free line bundle defining `q`:

\[
q^*O_X(1)
\simeq
p^*O_{P(W_5)}(d)\otimes O_{\widetilde Y}(-F).
\]

This identity is invariant under further blowup: both `F` and the carrier transform, and their intersection records the same pullback degree. It is the correct bridge between component maps and ambient degree.

## 8. Boundary

The resolved-map category is therefore rigorous at the level of:

- existence of an equivariant principalization;
- the fixed-locus blowup formula;
- actual component restrictions on a chosen model;
- the base-corrected polarization identity.

It does not supply a finite all-model list. The missing input is a theorem identifying the essential horizontal carriers of the actual base ideal and controlling the exceptional `P^2` bypasses.
