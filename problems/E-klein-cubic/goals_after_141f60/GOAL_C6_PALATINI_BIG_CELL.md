# Goal C6 — solve the corrected Fano section through its determinantal big cell

**Pinned state:** `141f6042f628f984771fc79d8d16beb12cedcb94`  
**Priority:** 2  
**Headline direction:** positive  
**Accepted bridge:** `BR-FANO-POS`

## Mission

Construct a `K_proj`-point of the genuine twisted degree-14 Fano threefold by
replacing the inconsistent idempotent presentation with the corrected
common-line problem for five alternating forms.

Let `V` be the six-dimensional split ambient space after the authoritative
Hilbert--90/Morita descent, and let

\[
\omega_1,\ldots,\omega_5\in\wedge^2V^*
\]

be the exact distinguished five-plane.  The target consists of two-planes
`L=<u,v>` satisfying

\[
\omega_i(u,v)=0\qquad(i=1,\ldots,5).
\]

For fixed `u`, these are five linear equations in `v`.  The alternating
property puts `u` in their common kernel.  A second independent kernel vector
exists exactly when the associated `5 x 6` matrix has rank at most four.
This produces a determinantal hypersurface in `P(V)` whose rank-four open is a
`P^1`-bundle over the Fano section.  Build and exploit this model exactly.

## Binding inputs

Consume and hash the corrected C5 artifacts, in particular

```text
goals_after_bd610a/C5_PROJECTOR_INCIDENCE/STATUS.md
goals_after_bd610a/C5_PROJECTOR_INCIDENCE/generic_pluecker_incidence.json
goals_after_bd610a/C5_PROJECTOR_INCIDENCE/morita_generic_dag.json
goals_after_bd610a/C5_PROJECTOR_INCIDENCE/morita_generic_split_dag.json
```

and every authoritative field/algebra dependency named by their manifests.
Do not use the refuted equations

```text
e^2=e, Trd(e)=2, e*S_0*e=0.
```

## C6.0 — exact five-form matrix

Choose one exact six-dimensional convention and build skew matrices `A_i`
with

\[
\omega_i(u,v)=u^tA_iv.
\]

Construct

\[
M(u)=
\begin{pmatrix}
 u^tA_1\\
 \vdots\\
 u^tA_5
\end{pmatrix}.
\]

Verify independently that:

1. every coefficient belongs to `K_proj` in the authoritative secondary
   basis;
2. `M(u)u=0` identically;
3. the equations agree coefficientwise with the generic Pluecker
   hyperplanes on all 15 Grassmann charts;
4. the three Morita division-algebra charts and the split model describe the
   same descended target.

Required marker:

```text
C6-FIVE-FORM-MATRIX-PASS
```

## C6.1 — Palatini/determinantal hypersurface

Compute the six signed maximal minors of `M(u)`.  Since their vector lies in
the right kernel and the generic kernel is `<u>`, prove an exact identity

\[
(\operatorname{minor}_0,\ldots,\operatorname{minor}_5)
=Q(u)(u_0,\ldots,u_5)
\]

on a common open, with one homogeneous quartic `Q`.  If the actual degree or
common factor differs, record the corrected equation rather than forcing the
classical name.

Prove scheme-theoretically on the stated open that

\[
D=V(Q)\subset\mathbf P^5
\]

is the image of the pointed-line incidence

\[
\{(L,[u]):[u]\in L,\ L\in F_{14,T}\},
\]

and that on `rank M(u)=4` the second kernel direction reconstructs the unique
common line through `u`.  Audit rank-at-most-three and boundary strata
separately.

Deliver exact inverse formulas on a finite principal-open cover.  A numerical
or good-prime degree check is not enough.

Required marker:

```text
C6-DETERMINANTAL-BIRATIONAL-MODEL-PASS
```

## C6.2 — rational-point attack on the quartic

Run the following exact lanes.

### Lane A — singular and linear loci

Compute the singular locus of `D`, all `K_proj`-defined linear spaces of small
codimension found by the five-form geometry, and the rank-at-most-three locus.
A rational singular point or rational linear space may make projection from
`D` birational to a quadric/conic bundle.  Verify any resulting point lies in
the Fano-reconstructible open or treat the lower-rank line directly.

### Lane B — coordinate and invariant slices

Search all symmetry-distinct coordinate `P^2`, `P^3`, and `P^4` slices and
all low-complexity invariant linear slices.  Factor the restricted quartics
over `K_proj`; follow rational components, conic bundles, and singular
quadrics.  Bounded empty slices are only scoped exclusions.

### Lane C — modular seed reconstruction

The existing C5 packets contain smooth common-line seeds at good primes.  Map
them to `D`, classify their exact component and tangent data at at least two
additional primes, and attempt rational reconstruction over the secondary
basis.  Verify `Q(u)=0`, the rank condition, the reconstructed kernel vector,
and all five original alternating equations exactly.

### Lane D — direct kernel parameterization

On each nonzero `4 x 4` minor chart solve four of the five equations for four
coordinates of `v`; impose the final equation and independence from `u`.
Eliminate only after this linear reduction.  Search for a rational fibration
or section, not an unstructured Groebner basis in all Pluecker variables.

## C6.3 — headline bridge

For any exact `u` and reconstructed common line `L`:

1. substitute `L` into all five authoritative Pluecker hyperplanes and all
   Pluecker quadrics;
2. verify the exact field is `K_proj` and every denominator/open condition;
3. identify the point with the genuine twisted `F_{14,T}`;
4. replay the stable Pfaffian/Fano bridge to the genuine generic Klein twist;
5. invoke the G3 dominance ledger, or independently prove dominance.

Deliver `BRIDGE_FANO_POS.md`.  A point on an auxiliary characteristic cubic,
a line common to only two forms, or a good-prime line is not sufficient.

## Deliverables

Write under

```text
problems/E-klein-cubic/goal_runs_after_141f60/C6_PALATINI_BIG_CELL/
```

Provide at least:

```text
INPUT_MANIFEST.json
FIVE_FORM_MATRIX.md
five_form_matrix.json
DETERMINANTAL_MODEL.md
quartic.json
RANK_STRATA.md
POINT_SEARCH.md
POINT.md when obtained
BRIDGE_FANO_POS.md when applicable
produce.py
verify_matrix.py
verify_model.py
verify_point.py
REPLAY.md
SEAL.json
STATUS.md
```

## Authorized exits

```text
C6-POINT-HEADLINE-POSITIVE
C6-DETERMINANTAL-BIRATIONAL-MODEL-PASS
C6-FIVE-FORM-MATRIX-PASS
C6-RANK-STRATUM-REDUCTION-PASS
C6-UNDECIDED
C6-CANONICAL-INPUT-FAIL
```

Only the first exit is a headline candidate.  Emptiness of one chart or of the
entire sufficient Fano section is not a negative Problem-E headline.
