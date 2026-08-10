# Theorem package

## 1. Setup and conventions

Let

\[
A:\mathbf P^4\dashrightarrow X
\]

be a hypothetical dominant `G`-equivariant ambient landing map.  Let `I_A` be
its primitive landing ideal and write

\[
Y=\widehat P
=
\operatorname{Proj}_{\mathbf P^4}\overline{\mathcal R(I_A)}.
\]

The normalized graph has canonical morphisms

\[
p:Y\to\mathbf P^4,
\qquad
q:Y\to X.
\]

Let `r:Z→Y` be any smooth `G`-equivariant resolution and `g=q\circ r`.  Put

\[
V=H^3(X,\mathbf Q)(1).
\]

For Hodge modules we use perverse normalization: `IC_Y^H` is the polarizable
pure Hodge module of weight four whose rational realization is
\(j_{!*}\mathbf Q_{Y_{\mathrm{reg}}}[4]\).

## 2. Ambient normalized-graph Hodge-support theorem

### Theorem A — canonical pure lift of the actual image

There is a canonical `G`-equivariant injection of rational Hodge structures

\[
\alpha_A:
H^3(X,\mathbf Q)
\hookrightarrow
IH^3(Y,\mathbf Q)
\tag{2.1}
\]

defined by

\[
H^3(X)
\xrightarrow{q^*}
H^3(Y)
\longrightarrow
\operatorname{Gr}^W_3H^3(Y)
\hookrightarrow
IH^3(Y).
\tag{2.2}
\]

For every resolution `r:Z→Y`,

\[
g^*H^3(X)=r^*q^*H^3(X).
\tag{2.3}
\]

Thus (2.1) is the resolution-independent pure intersection-cohomology shadow
of the actual canonical subspace (2.3), not of an abstract occurrence of an
isomorphic Hodge structure in `H^3(Z)`.

#### Proof

The accepted relatively-ample splitting proves that `g^*` is injective.  Since
`g^*=r^*q^*`, the map `q^*` is injective.  Its source is pure of weight three,
so strictness identifies its image with a pure weight-three sub-Hodge structure
of `Gr^W_3H^3(Y)`.  For a proper complex variety, Hanamura--Saito's canonical
map

\[
\operatorname{Gr}^W_3H^3(Y)\longrightarrow IH^3(Y)
\]

is injective.  Every map is functorial for automorphisms of the graph, hence
`G`-equivariant.  Equation (2.3) is functoriality of ordinary pullback.
\(\square\)

### Theorem B — canonical proper strict support

Let

\[
\mathcal P_j={}^{p}H^j(Rp_*IC_Y^H)
\]

and index the perverse Leray filtration so that

\[
\operatorname{Gr}^P_jIH^3(Y)
\simeq
H^{-1-j}(\mathbf P^4,\mathcal P_j).
\tag{2.4}
\]

There is a unique perverse jump `j_0` at which the irreducible
`G`-representation `alpha_A(V)` enters this filtration.  Its map to

\[
\operatorname{Gr}^P_{j_0}IH^3(Y)(1)
\]

is injective.

For an irreducible closed support `S`, let

\[
\mathcal M_{S,j_0}\subset\mathcal P_{j_0}
\]

be the maximal strict-support summand supported on `S`, and let
`H=Stab_G(S)`.  At least one `G`-orbit of proper supports receives a nonzero
projection of `alpha_A(V)`.  For a representative in such an orbit,

\[
\boxed{
\operatorname{Hom}_{\mathrm{HS},H}
\left(
\operatorname{Res}_H V,
H^{-1-j_0}(\mathbf P^4,\mathcal M_{S,j_0})(1)
\right)\ne0.
}
\tag{2.5}
\]

Moreover,

\[
S\subset\operatorname{Bs}(I_A),
\qquad
\dim S\le2.
\tag{2.6}
\]

The perverse degree `j_0` and the nonempty set of `G`-orbits of
strict-support blocks with nonzero `V`-projection are intrinsic to `(Y,p,q)`.

If one chooses a simple constituent

\[
IC_{\overline S}^H(\mathcal L)
\subset\mathcal M_{S,j_0}
\]

and lets `H'` be the stabilizer of the pair \((S,\mathcal L)\), then for
`s=dim S` the corresponding refinement is

\[
\operatorname{Hom}_{\mathrm{HS},H'}
\left(
\operatorname{Res}_{H'}V,
IH^{s-1-j_0}(\overline S,\mathcal L)(1)
\right)\ne0.
\tag{2.7}
\]

#### Proof

Over the complement of the ambient base locus, `p` is an isomorphism.  Hence
the only full-support constituent among all `P_j` is

\[
\mathbf Q_{\mathbf P^4}^H[4]\subset\mathcal P_0,
\]

with multiplicity one.  Its degree-three contribution is

\[
H^{-1}(\mathbf P^4,\mathbf Q[4])
=H^3(\mathbf P^4)=0.
\]

Every associated-graded contribution to `IH^3(Y)` therefore has proper strict
support in the non-isomorphism locus of `p`.  The primitive tuple has no common
divisorial factor, so this locus has codimension at least two, proving (2.6).

The perverse filtration is `G`-stable and consists of rational Hodge
substructures.  Since `V` is irreducible over `Q` as a `G`-module, its
intersection with a filtration step is either zero or all of `V`.  This gives
the unique jump and the injection to the associated graded.

Pure perverse Hodge modules decompose canonically by strict support.  Grouping
supports in `G`-orbits gives canonical `G`-stable blocks.  At least one orbit
block receives a nonzero map, which is injective because `V` is irreducible.
Frobenius reciprocity gives (2.5).  Decomposing the support block into simple
intersection-complex constituents and taking the stabilizer of a constituent
pair gives (2.7).  \(\square\)

## 3. Geometric and abelian support

Attach to `S` the canonical reduced exceptional inverse image

\[
K_S=p^{-1}(\overline S)_{\mathrm{red}}.
\tag{3.1}
\]

The intrinsic support package is

\[
\mathfrak S_A=(S,j_0,\mathcal M_{S,j_0},K_S).
\tag{3.2}
\]

The relevant Hodge information may be carried by fiber cohomology and monodromy
inside `M_{S,j_0}`, rather than by the ordinary Albanese of `S` or `K_S`.

The image of `V` in (2.5) is a polarizable effective Hodge structure of weight
one.  It therefore defines an abelian variety

\[
A_{S,j_0}
\]

up to `H`-equivariant isogeny, with

\[
\operatorname{Hom}_{\mathrm{HS},H}
\left(
\operatorname{Res}_H V,H^1(A_{S,j_0},\mathbf Q)
\right)\ne0.
\tag{3.3}
\]

The accepted Auto-CM theorem implies that this support abelian factor contains
a nonzero `E_{-11}`-isotypic factor.  A single representative support need not
contain all five copies.

## 4. Ordinary geometric \(H^1\) under finite monodromy

### Corollary C

Suppose a selected simple constituent satisfies

\[
s-1-j_0=1,
\qquad
\mathcal L\simeq\mathcal U(-1),
\tag{4.1}
\]

where `U` has finite monodromy.  After passing to a finite Galois cover of the
support stratum that trivializes `U`, normalizing the compactification, and
resolving equivariantly, the Hodge structure in (2.7) is a direct summand of
`H^1(tilde S,Q)` for a smooth projective finite cover `tilde S`.  Hence the
ordinary finite-cover carrier condition holds, with the appropriate stabilizer
or its finite extension.

The classical channels are

\[
(s,j_0,\mathcal L)=(2,0,\mathbf Q(-1))
\]

for an irregular surface center and

\[
(s,j_0,\mathcal L)=(1,-1,\mathbf Q(-1))
\]

for a positive-genus curve center.

### Nonclaim

The hypotheses (4.1) are not automatic.  A nonsemismall birational map may
produce point-supported weight-three Hodge structures, non-Tate variations,
and higher-degree support cohomology.  Theorem B and (3.3), not an ordinary
finite-cover statement, are unconditional.

## 5. Projector boundary

The accepted relatively-ample splitting produces a cohomological idempotent on
`H^3(Z)` whose image is `g^*H^3(X)`, but the idempotent depends on the chosen
ample class.  Theorems A and B canonically localize the actual sub-Hodge object,
its perverse jump, and the nonempty set of strict-support orbits receiving it.
They do not construct a canonical Chow-correspondence projector on `Y` or
`K_S`.

General decomposition-theorem projectors are absolute Hodge and André
motivated; algebraicity as Chow projectors is not known in this generality.  The
semismall Chow-motive theorem is unavailable because `p` is not known to be
semismall.

## 6. Restricted normalized graph

Let

\[
\Gamma
=
\operatorname{Proj}_X\overline{\mathcal R(J)}
\]

be the normalized graph of the primitive restricted map, with

\[
\pi_\Gamma,q_\Gamma:\Gamma\to X.
\]

### Theorem D — intrinsic survival on the whole restricted graph

The maps

\[
q_\Gamma^*:V\hookrightarrow H^3(\Gamma,\mathbf Q)(1)
\tag{6.1}
\]

and

\[
\alpha_\Gamma:V\hookrightarrow IH^3(\Gamma,\mathbf Q)(1)
\tag{6.2}
\]

are injective.

#### Proof

Resolve `Gamma`.  The resulting morphism to `X` is dominant and generically
finite, so the trace identity makes its pullback injective.  Factorization
through ordinary cohomology of `Gamma` proves (6.1); the same middle-weight
argument as in Theorem A gives (6.2).  \(\square\)

### Conditional ambient-to-restricted transfer

Let `i:X→P4`.  A selected ambient support block transfers to a proper support
on `Gamma` if all of the following hold.

1. Its inverse image meets the component of `Y×_{P4}X` dominating `X`, and the
   relevant component survives normalization.
2. Restriction by `i` is non-characteristic for the selected Hodge module on a
   dense open, with no `V`-isotypic vanishing-cycle kernel.
3. The comparison through proper base change, dominant-component selection,
   and normalization is nonzero on the selected `V`-isotypic perverse graded
   piece.

Under these hypotheses, a strict-support block for `pi_Gamma` receives a
nonzero map from `V`; under (4.1) it yields a finite-cover `H^1` carrier.

These hypotheses are not proved for an arbitrary landing ideal.  In
particular, the full-support `IC_X` term for `pi_Gamma` already contributes
`H^3(X)`, so the restricted decomposition theorem does not force the actual
class into a proper exceptional support.

## 7. Final theorem boundary

```text
AMBIENT-HODGE-SUPPORT-PROVED
RESTRICTED-TRANSFER-UNDECIDED
```

The exact remaining theorem is nonvanishing of the selected ambient
`V`-isotypic support block after derived restriction, dominant-component
selection, and normalization.
