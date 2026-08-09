# Independent audit of the terminal-Fano addendum

**Date:** 2026-08-08  
**Audited file:** `TERMINAL_FANO_AUDIT_ADDENDUM.md`  
**Verdict:** `PASS WITH EXPLICIT BRIDGES; NO GLOBAL VERDICT`

The four eliminations in the audited addendum are valid under its stated
geometric hypothesis

```text
rank Cl(X_bar)^C11 = 1.
```

They do not apply to an arithmetic MMP output for which only the combined
Galois/action invariant class group has rank one, and they do not eliminate
the smooth Klein/Pfaffian-Klein branch or the seven remaining
non-Gorenstein baskets.  Thus they do not prove `ed_K(A)=4`.

## 1. Prokhorov's `rho>1` branch

This application is exact.  Prokhorov's definition of a `G`-Fano is the
geometric condition on `Cl(X)^G` used here.  Namikawa smoothing preserves
`Pic`, and the paragraph preceding Prokhorov's Theorem 6.5 applies Theorem
1.2 to put the smoothing in the eight listed types, whose Picard ranks are
`2,3,4`.  A rational representation of `C11` of dimension at most four is
trivial.  Hence `Pic(X)^C11=Pic(X)`, and

```text
Pic(X)_Q -> Cl(X)_Q
```

contradicts `rank Cl(X)^C11=1` whenever `rho(X)>1`.  No equivariant
smoothing is being assumed: only the induced action on the identified
Picard lattice is used, exactly as in Prokhorov's proof.

## 2. Local indices `11` and `22`

The canonical-cover argument is valid after making the following standard
details explicit.

* Work with the completed or strictly henselian terminal germ.  Every
  automorphism lifts to the canonical index-one cover; all lifts preserve
  its grading, so the deck group is central.
* For index `22`, the order-`11` Sylow subgroup of the full lift group is
  unique (its number divides two and is congruent to one modulo eleven),
  hence is defined over the residue field.
* A central extension of `C11` by `C11` is either `C121` or `C11^2`.  The
  cyclic case is impossible because an automorphism of `C121` induces the
  same scalar modulo eleven on its unique subgroup and its quotient,
  whereas descent acts by `1` on the deck subgroup and by `9` on the
  quotient.
* In the elementary-abelian case the character module has Galois
  eigenvalues `1,9`.  Semisimplicity follows because `5` is invertible
  modulo `11`.  Every nonfixed character has a five-element orbit, so a
  Galois-stable tangent multiset of size at most four lies in the single
  fixed line and cannot be faithful.

The index-one cover is a terminal Gorenstein cDV germ of embedding
dimension at most four.  Formal linearization in characteristic zero makes
faithfulness on the germ equivalent to faithfulness on its tangent space,
which yields the contradiction.  The residue-field argument for the four
baskets is also exact: a unique index-`11` or index-`22` point is rational,
and the two index-`11` points in `{11^2}` split over an extension of degree
at most two, disjoint from the degree-five splitting field.  Therefore the
remaining seven-basket list is correct, conditional on the already-audited
eleven-basket necessary list.

## 3. BKM applicability and the genus-six/seven modules

Bayer--Kuznetsov--Macri, Theorem 1.1 and Corollary 6.10, apply to prime
Fano threefolds with factorial terminal singularities.  This includes the
branches at issue.  Indeed a terminal Gorenstein threefold germ is an
isolated hypersurface germ, and its punctured-spectrum Picard group is
torsion-free; hence local `Q`-factoriality implies local factoriality.  The
global rank-one hypotheses then give the factorial prime Fano required by
BKM.  This torsion-freeness is a real theorem (for example H. Dao,
*Picard groups of punctured spectra of dimension three local hypersurfaces
are torsion-free*, arXiv:1004.0471), not merely a formal consequence of the
term cDV.

BKM's uniqueness of the Mukai bundle/model makes the construction
functorial for automorphisms, up to the harmless scalar ambiguity that is
already encoded by projective weights.  In genus six one must additionally
observe that the induced `C11` action on `V5` is faithful: the ordinary
Gushel map is an embedding, while the special Gushel map has generic degree
two, so its automorphism kernel has order at most two.  Thus an odd
order-`11` subgroup cannot disappear in that kernel.

After centering the affine descent action, a faithful five-dimensional
projective representation has weights `R` (or `-R`), and

```text
wedge^2(V5) = U_+ + U_-.
```

Its descended subspaces have dimensions only `0,5,10`, excluding both the
ordinary eight-dimensional image and the special seven-dimensional image.

For genus seven, orthogonality forces the ten vector weights to be
`R union -R`; there is no alternative consisting partly of zero weights,
because nonzero weights occur in opposite pairs and in five-element Galois
orbits.  The chosen half-spin representation has

```text
Delta_+ = 1 + 2 U_+ + U_-
```

(the other chirality swaps the signs).  Even allowing arbitrary subspaces
inside the multiplicity-two isotypic component, the possible descended
dimensions are

```text
0,1,5,6,10,11,15,16,
```

so the required nine-dimensional anticanonical subspace cannot occur.

## 4. Genus eight and the Pfaffian-zero dichotomy

The BKM model is exactly

```text
X = Gr(2,V6) intersect P(W),   dim(V6)=6, dim(W)=10,
B = W^perp,                    dim(B)=5.
```

The centered weights of `V6` are `{0} union R`, whence
`wedge^2(V6)=2U_+ + U_-` up to exchanging signs.  Therefore `B` is one
five-cycle, including when it is a graph inside the multiplicity-two
isotypic summand.  The restriction of the Pfaffian has exactly the five
possible invariant monomials `x_i^2 x_(i+1)`.  Galois permutes their lines
transitively, so either every coefficient is zero or none is.  In the
nonzero case the determinant-`33` diagonal rescaling gives the smooth
Klein cubic.  Standard projective duality then implies that `X` is smooth.

The zero case is also valid, but one omitted implication should be read as
follows.  If `omega in B` has rank four and `U=ker(omega)`, then

```text
d(pf)_omega is proportional to wedge^2(U).
```

Since `pf|B` is identically zero, its derivative annihilates `B`; hence
`wedge^2(U) lies in B^perp=W`.  Thus `[U]` lies on `X`, and `omega`
annihilates its Grassmannian tangent space, so `[U]` is singular on `X`.
Terminality makes the singular locus finite, forcing the kernel map on the
dense rank-four locus of `P(B)` to be constant.  The common two-plane is
Galois- and `A`-stable, impossible in the module `{0} union R`.

If all forms in `B` have rank at most two, `P(B)` is a linear `P4` in
`Gr(2,V6^*)`.  The elementary classification of linear spaces in this
Grassmannian says that such a `P4` is an alpha-space
`P(ell wedge V6^*)`; the beta-spaces have dimension only two.  Hence
`W=wedge^2 ker(ell)` and the purported threefold section contains, in fact
equals at the linear-section level, `Gr(2,ker(ell))` of dimension six,
contradicting dimensional transversality.

## Replay scope

The existing fixed replay

```text
/opt/homebrew/bin/python3 \
  goal_runs_20260808/KERNEL_BIRATIONAL/verify_terminal_fano_audit.py
```

passes.  It checks only the finite character-orbit, half-spin, invariant
cubic, and basket arithmetic used above.  It is not evidence for the
classification, canonical-cover, or projective-duality theorems; those
parts were checked against the primary sources and the analytic arguments
given above.

## Primary sources checked

* Yu. Prokhorov, *G-Fano threefolds, II*, Definition 1.1, Theorems 1.2 and
  6.5: <https://arxiv.org/abs/1101.3854>.
* A. Bayer, A. Kuznetsov, E. Macri, *Mukai models of Fano varieties*,
  Theorem 1.1 and Corollary 6.10:
  <https://arxiv.org/abs/2501.16157>.
* H. Dao, *Picard groups of punctured spectra of dimension three local
  hypersurfaces are torsion-free*: <https://arxiv.org/abs/1004.0471>.
* M. Reid, *Young person's guide to canonical singularities*, for the
  canonical index-one cover and cDV description.

