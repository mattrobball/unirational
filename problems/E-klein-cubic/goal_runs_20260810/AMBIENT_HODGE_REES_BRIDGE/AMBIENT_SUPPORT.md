# Ambient support on the normalized graph

## 1. The intrinsic ambient object

Let

\[
Y=\widehat P
=
\operatorname{Proj}_{\mathbf P^4}\overline{\mathcal R(I_A)},
\qquad
p:Y\to\mathbf P^4,
\qquad
q:Y\to X.
\]

The variety `Y` is normal and projective, and both morphisms are intrinsic to
the primitive ambient landing tuple.  Every smooth principalization of the
landing ideal factors through `Y` by the universal property of the blowup and
normality; in particular, every resolution used below does so.

The first point is that the landing Hodge structure is already visible before
choosing a resolution.

### Proposition 1.1 — injectivity on ordinary cohomology

The pullback

\[
q^*:H^3(X,\mathbf Q)\longrightarrow H^3(Y,\mathbf Q)
\tag{1.1}
\]

is injective.

#### Proof

For any resolution `r:Z→Y`, the landing morphism is `g=q\circ r`.  The accepted
relatively-ample splitting says that `g^*` is injective.  Since

\[
g^*=r^*q^*,
\]

`q^*` must be injective.  \(\square\)

This proposition already follows the actual image.  An abstract copy of the
same rational `G`-representation in some later blowup summand is irrelevant to
(1.1).

## 2. Canonical passage to intersection cohomology

Ordinary cohomology of a singular projective variety is mixed.  Because the
source of (1.1) is pure of weight three, strictness gives an injection

\[
H^3(X)
\hookrightarrow
\operatorname{Gr}^W_3H^3(Y).
\tag{2.1}
\]

Hanamura--Saito's middle-weight theorem gives a canonical injection

\[
\operatorname{Gr}^W_3H^3(Y)
\hookrightarrow
IH^3(Y).
\tag{2.2}
\]

Their theorem is stated for compactly supported cohomology of a variety and a
compactification.  Here `Y` is already proper, so compactly supported and
ordinary cohomology agree.  Combining (2.1) and (2.2) gives

\[
\alpha_A:H^3(X)\hookrightarrow IH^3(Y).
\tag{2.3}
\]

All maps in (2.3) are canonical and commute with automorphisms of the normalized
graph.  Thus `alpha_A` is `G`-equivariant.

### What (2.3) does and does not say

For a resolution `r:Z→Y`, the actual class in `H^3(Z)` remains

\[
g^*a=r^*q^*a.
\]

The class `alpha_A(a)` is its canonical pure intersection-cohomology shadow on
`Y`.  No canonical map

\[
IH^3(Y)\longrightarrow H^3(Z)
\]

is asserted.  A decomposition-theorem splitting of `IH^3(Y)` inside
`H^3(Z)` exists after choices, but is not the invariant used here.

## 3. The perverse filtration over \(\mathbf P^4\)

Use the perverse normalization for Hodge modules.  Thus `IC_Y^H` is the
polarizable pure Hodge module of weight four whose rational realization is
\(j_{!*}\mathbf Q_{Y_{\mathrm{reg}}}[4]\).  Put

\[
\mathcal P_j
={}^{p}H^j(Rp_*IC_Y^H).
\tag{3.1}
\]

Projective direct image, relative hard Lefschetz, and semisimplicity imply:

1. each `P_j` is a polarizable pure Hodge module of weight `4+j`;
2. each `P_j` has a canonical decomposition by strict support;
3. the perverse Leray spectral sequence degenerates;
4. the induced perverse filtration on `IH^3(Y)` is a filtration by rational
   Hodge substructures.

Index the filtration so that

\[
\operatorname{Gr}^P_jIH^3(Y)
\simeq
H^{-1-j}(\mathbf P^4,\mathcal P_j).
\tag{3.2}
\]

The filtration is canonical.  The direct-sum splitting of the filtered object
is not.

## 4. Why full support contributes nothing

Let `U` be the complement of the base locus.  On `U`, the morphism `p` is an
isomorphism, so

\[
(Rp_*IC_Y^H)|_U=\mathbf Q_U^H[4].
\]

Consequently:

- no `P_j` with `j≠0` has a full-support constituent;
- the unique full-support constituent of `P_0` is
  `Q_{P4}^H[4]`, with multiplicity one.

Its contribution to degree-three intersection cohomology is

\[
H^{-1}(\mathbf P^4,\mathbf Q[4])
=H^3(\mathbf P^4)=0.
\tag{4.1}
\]

Therefore every class in `IH^3(Y)` is assembled, on the associated graded of
the perverse filtration, from proper strict supports.

Because the landing tuple is primitive, its base locus has codimension at
least two.  Every proper strict support therefore has dimension at most two.
This is the precise place where the vanishing `H^3(P4)=0` enters.

## 5. Following the actual irreducible image

After the Tate twist, put

\[
V=H^3(X,\mathbf Q)(1).
\]

The accepted Klein calculation says that `V` is irreducible over `Q` as a
`G`-representation.  Intersect `alpha_A(V)` with the increasing perverse
filtration.  Each intersection is a `G`-subrepresentation, hence either zero
or all of `V`.  There is therefore a unique jump `j_0`, and the induced map

\[
V\hookrightarrow
\operatorname{Gr}^P_{j_0}IH^3(Y)(1)
\tag{5.1}
\]

is injective.

For an irreducible closed support `S`, let

\[
\mathcal M_{S,j_0}\subset\mathcal P_{j_0}
\]

be the maximal strict-support summand supported on `S`.  This is canonical.
If `H=Stab_G(S)`, then `H` acts on this whole block.  Grouping the supports in a
`G`-orbit gives a canonical `G`-stable direct summand of the associated graded.
At least one such orbit receives a nonzero projection of (5.1).  Frobenius
reciprocity gives

\[
\boxed{
\operatorname{Hom}_{\mathrm{HS},H}
\left(
\operatorname{Res}_H V,
H^{-1-j_0}(\mathbf P^4,\mathcal M_{S,j_0})(1)
\right)\ne0.
}
\tag{5.2}
\]

This is the completely canonical strict-support form of the ambient theorem.

If one decomposes `M_{S,j_0}` into simple constituents and chooses an orbit of
pairs `(S,\mathcal L)`, let `H'` be the stabilizer of that pair.  For
`s=dim S`, (5.2) refines to

\[
\operatorname{Hom}_{\mathrm{HS},H'}
\left(
\operatorname{Res}_{H'}V,
IH^{s-1-j_0}(\overline S,\mathcal L)(1)
\right)\ne0.
\tag{5.3}
\]

Using the whole support block in (5.2) avoids any ambiguity if the stabilizer
of `S` permutes isomorphic simple local-system constituents.

## 6. Canonical exceptional geometry

Attach to the support the reduced inverse image

\[
K_S=p^{-1}(\overline S)_{\mathrm{red}}.
\tag{6.1}
\]

The package

\[
\mathfrak S_A=(S,j_0,\mathcal M_{S,j_0},K_S)
\tag{6.2}
\]

is intrinsic to the ambient normalized graph and the actual landing map.  It is
unchanged under replacement of `Z` by any other resolution dominating `Y`.

The Hodge information need not be the ordinary `H^1` of `S` or `K_S`.  It may
come from:

- a nontrivial local system recording the cohomology of exceptional fibers;
- intersection cohomology of a singular support;
- a point-supported weight-three Hodge structure;
- a nonsemismall perverse degree.

Thus ordinary Rees divisors do not exhaust the support theorem.

## 7. The weight-one abelian factor

The image of `V` in (5.2), after the Tate twist, is a polarizable effective
Hodge structure of weight one.  Hence it is `H^1` of an abelian variety up to
isogeny.  Denote the resulting support abelian factor by

\[
A_{S,j_0}
\quad\text{(defined up to `H`-equivariant isogeny).}
\]

Then

\[
\operatorname{Hom}_{\mathrm{HS},H}
\left(
\operatorname{Res}_H V,
H^1(A_{S,j_0},\mathbf Q)
\right)\ne0.
\tag{7.1}
\]

The accepted Auto-CM theorem implies that `A_{S,j_0}` contains a nonzero
`E_{-11}`-isotypic factor.  This is the unconditional ordinary-`H^1`
replacement: the abelian factor is attached to the strict-support block, not
necessarily to the Albanese of a geometric support variety.  No primitive
principal polarization and no fivefold factor on a single representative are
claimed.

## 8. When a finite geometric cover suffices

Suppose a simple constituent satisfies

\[
s-1-j_0=1,
\qquad
\mathcal L=\mathcal U(-1),
\]

with `U` of finite monodromy.  Pass to a finite Galois cover of the smooth
support stratum that trivializes `U`, normalize the compactification, and take
an equivariant smooth projective model `tilde S`.  Finite direct image and the
decomposition theorem realize

\[
IH^1(\overline S,\mathcal U)
\]

as a direct summand of `H^1(tilde S)`.  Therefore the necessary condition takes
the familiar form

\[
\operatorname{Hom}
\left(
V,H^1(\widetilde S,\mathbf Q)
\right)\ne0,
\]

with the appropriate stabilizer or finite extension acting.

The classical blowup channels are:

\[
(s,j_0,\mathcal L)=(2,0,\mathbf Q(-1))
\]

for an irregular surface center and

\[
(s,j_0,\mathcal L)=(1,-1,\mathbf Q(-1))
\]

for a positive-genus curve center.

This reduction is conditional.  It cannot be imposed on arbitrary
nonsemismall normalized blowups.

## 9. The projector question

The accepted relatively-ample splitting produces a cohomological idempotent on
`H^3(Z)` with image `g^*H^3(X)`, but it depends on the chosen relatively ample
class.  The decomposition theorem supplies canonical filtration and
strict-support blocks, not a canonical splitting of the derived direct image.

Accordingly, the theorem proves:

```text
canonical actual sub-Hodge object
+ canonical perverse degree
+ canonical nonempty set of strict-support orbits receiving it.
```

It does not prove a canonical Chow-correspondence idempotent supported on
`K_S×K_S`.  General decomposition-theorem projectors are known to be absolute
Hodge and André motivated, but are not known to be algebraic Chow projectors
without additional hypotheses.  The semismall motivic theorem is inapplicable
because `p` is not known to be semismall.

## 10. Resolution invariance

Let `h:Z'→Z` be any further equivariant sequence of blowups.  Then

\[
(g h)^*V=h^*g^*V.
\]

The new blowup summands are orthogonal direct summands in the standard blowup
formula, and the actual pullback has zero component in them.  More importantly,
`Y`, `alpha_A`, the perverse filtration for `p`, and the support package (6.2)
are unchanged.

This proves the ambient support theorem in the resolution-independent category
where it is true.
