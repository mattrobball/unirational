# Literature audit

This audit records only results whose hypotheses were checked against the
projective birational fourfold map

\[
p:Y=\widehat P\to\mathbf P^4
\]

and the closed restriction to the Klein cubic.  It also records exactly what
each result does **not** supply.

## 1. Pure and mixed Hodge modules

### Morihiko Saito, *Modules de Hodge polarisables* (1988)

Saito constructs polarizable pure Hodge modules, their strict-support
decomposition, projective direct image, and relative hard Lefschetz.  Applied
to the pure Hodge module `IC_Y^H`, this gives pure semisimple perverse
cohomology modules

\[
{}^pH^j(Rp_*IC_Y^H).
\]

**Hypotheses here:** `p` is projective and `IC_Y^H` is pure.  Smoothness of `Y`
and semismallness of `p` are not required.

**Use in this packet:** canonical strict-support blocks and semisimplicity.

### Morihiko Saito, *Mixed Hodge Modules* (1990)

This supplies the mixed category and the functorial mixed Hodge structures on
ordinary cohomology, together with the six operations used to compare ordinary
and intersection cohomology.

**Use:** strictness of the morphism `q^*` and the Hodge-theoretic nature of the
perverse filtration.

## 2. Decomposition theorem and perverse Hodge structures

### de Cataldo--Migliorini, *The Hodge theory of algebraic maps* (2005)

The paper proves, over the complex numbers, relative hard Lefschetz,
decomposition, semisimplicity, purity of intersection cohomology, and the Hodge
structure theorem for the perverse filtration of a projective algebraic map.
It explicitly treats direct images of intersection complexes when the source
is singular.

**Hypotheses here:** exactly satisfied by projective `p:Y→P4`.

**Use:**

\[
Rp_*IC_Y
\simeq
\bigoplus_j{}^pH^j(Rp_*IC_Y)[-j]
\]

(noncanonically), while each perverse cohomology object decomposes
semisimply by strict support.  The perverse filtration and its Hodge
substructures are canonical.

**Nonconsequence:** the derived direct-sum splitting is not canonical.  The
packet therefore localizes the subobject by its filtration jump and
strict-support block rather than selecting a canonical direct-sum projector.

### de Cataldo--Migliorini, *The perverse filtration and the Lefschetz
hyperplane theorem* (2010)

This gives a geometric description of the perverse filtration.  It confirms
that the filtration is intrinsic, but it does not make restriction to an
arbitrary fixed hypersurface exact on intersection complexes.  The Klein cubic
is not a general flag chosen after the map.

## 3. Canonical middle weight in intersection cohomology

### Hanamura--Saito, *Weight filtration on the cohomology of algebraic
varieties* (2006)

Their Theorem 1 gives the canonical injection

\[
\operatorname{Gr}^W_jH^j_c(U)
\hookrightarrow IH^j(\overline U).
\]

For proper `Y`, this is

\[
\operatorname{Gr}^W_3H^3(Y)
\hookrightarrow IH^3(Y).
\]

**Hypotheses here:** `Y` is proper over `C`; satisfied.

**Use:** this is the canonical step turning the actual pure image of `q^*` in
ordinary cohomology into an intrinsic sub-Hodge structure of `IH^3(Y)`.

**Nonconsequence:** their separate lift of intersection complexes along a
general morphism is noncanonical.  It does not give the missing functorial
restriction from the ambient support to `Gamma`.

## 4. Semismall versus nonsemismall resolutions

### de Cataldo--Migliorini, *The hard Lefschetz theorem and the topology of
semismall maps* (2002)

For a semismall map, all decomposition-theorem information lies in perverse
degree zero and is governed by relevant strata and intersection forms.

**Why it is not enough:** the normalized blowup of an arbitrary landing ideal
is not known to be semismall.  Curve-centered or point-centered fibers in a
fourfold can have positive defect.  Nonzero `P_j` for `j≠0`, point supports,
and non-Tate local systems must be allowed.

## 5. Restriction, nearby cycles, and vanishing cycles

Saito's six-functor formalism expresses closed pullback through nearby and
vanishing cycles.  More recent explicit treatments include
Chen--Dirks--Saito, *Verdier specialization and restrictions of Hodge modules*,
and Chen--Dirks--Olano, *Restrictions of mixed Hodge modules using generalized
V-filtrations*.

The relevant conclusion is negative but precise:

\[
i^*IC_Y
\]

is not generally the intersection complex of `Y×_{P4}X`.  A clean formula
requires non-characteristic, local-acyclicity, or explicit `V`-filtration
hypotheses.

**Why this is load-bearing:** proper base change applies to the raw fiber
product, but the desired graph is obtained only after selecting one component
and normalizing it.  No cited restriction theorem makes the selected
`V`-isotypic map automatically nonzero through those operations.

## 6. Weak factorization and blowup formulas

### Abramovich--Karu--Matsuki--Wlodarczyk (2002)

Weak factorization connects two smooth birational models by blowups and
blowdowns with smooth centers.

**Use:** it explains why a theorem phrased in terms of a first or minimal
blowup center is not invariant.

**Nonconsequence:** weak factorization does not identify a center common to all
factorizations and does not track the actual subspace `g^*V` without additional
functorial data.

### Manin, *Correspondences, motifs and monoidal transformations* (1968)

The blowup formula for motives, and hence for cohomology, accounts for the
`H^1` of curve and irregular-surface centers in `H^3` of a smooth blowup tower.

**Use:** accepted N2 and the resolution-level center condition.

**Nonconsequence:** the decomposition is tied to the chosen tower; it does not
descend individual center motives through contractions to the normalized
graph.

## 7. Motivic projectors

### de Cataldo--Migliorini, *The projectors of the decomposition theorem are
motivic* (2015)

For projective maps, the decomposition-theorem projectors are absolute Hodge,
André motivated, Tate, and Ogus classes.

**Exact consequence:** the strict-support projectors have strong realization-
theoretic and motivated status.

**Exact nonconsequence:** the paper does not prove that all these projectors are
algebraic Chow correspondences.  Therefore this packet does not claim an
unconditional Chow-motive projector supported on the normalized exceptional
locus.

### de Cataldo--Migliorini, *The Chow motive of semismall resolutions* (2004)

A Chow-motivic decomposition is proved for semismall resolutions under suitable
stratification hypotheses.

**Why inapplicable:** semismallness of `p` is neither known nor expected for an
arbitrary ambient landing ideal.

## 8. Rees valuations and normalized blowups

Abhyankar--Heinzer's work on Rees valuations, together with the standard
normalized-blowup theory used in the repository, identifies divisorial Rees
valuations with exceptional prime divisors of the normalized blowup.

**Use:** canonical divisorial centers and the residue-field dimension test.

**Nonconsequence:** decomposition-theorem supports need not be divisorial.
They may be curves, points, or local systems on strata, and odd cohomology may
come from the fibers over those strata.  Rees valuations alone do not encode
this data.

## 9. Coniveau one, cylinders, and algebraic representatives

### Voisin, *On the coniveau of rationally connected threefolds* (2022)

For a rationally connected threefold, integral cohomology modulo torsion is of
strong coniveau one and is produced by a cylinder homomorphism from a smooth
curve.

**Relevance:** it confirms that the target `H^3(X)` can be represented by
curve geometry.

**Nonconsequence:** the parameter curve is not selected by the ambient landing
ideal, its normalized Rees algebra, or the actual pullback `q^*`.  The theorem
therefore does not supply an ambient support or an ambient-to-restricted
transfer.

Work on algebraic representatives and intermediate Jacobians similarly
associates an abelian variety to coniveau-one `H^3`.  This supports the abelian
factor in `AMBIENT_SUPPORT.md`, but does not locate it on a canonical Rees
stratum.

## 10. Intermediate Jacobians of rational maps

For a resolved rational selfmap, the graph correspondence gives a
resolution-independent endomorphism of the intermediate Jacobian.  The
repository correctly records that exceptional center terms prevent the clean
finite-morphism Rosati identity from being applied to a rational map.

No general theorem found in the literature computes the exceptional correction
from the normalized Rees algebra of an arbitrary ambient landing ideal.  The
Hodge-module support theorem identifies where that correction lives
categorically, but not its numerical correspondence on the Klein intermediate
Jacobian.

## 11. Literature boundary

The literature proves the ambient theorem in exactly the category used here:

```text
canonical middle-weight class in IH
+ canonical perverse filtration
+ canonical strict-support blocks.
```

It does not prove the missing statement:

```text
nonzero clean restriction of the selected V-block to the normalized dominant
component Gamma.
```

That statement requires special geometry of the actual landing ideal, or an
explicit non-characteristic/vanishing-cycle calculation.  It is not an
off-the-shelf consequence of decomposition, motives, coniveau, or Rees
valuation theory.
