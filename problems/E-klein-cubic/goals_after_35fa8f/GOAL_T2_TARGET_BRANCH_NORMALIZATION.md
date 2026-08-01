# Goal T2 — normalize the genuine target branch and settle `Cl/Pic mod 3`

**Pinned state:** `35fa8f59b6a1423cc89300aeaceefe91552be5ba`  
**Priority:** 6  
**Possible headline direction:** negative  
**Relation to Goal B:** run independently; consume Goal B if it identifies the infinity divisor with the versal target branch

## Mission

Complete `BR-T-NEG` on the genuine multiplicity-one target branch: construct its normalization and conductor on one exact open, prove the generic residual cubic retains index three, and conclude that the genuine generic Klein twist is pointless.

The dead chart `(P_B,P_Y,P_Z)` must not be reused with the old gate set. Exact special fibres of degree six are discovery only.

## Binding input

- the primitive sextic equation and target branch are exact in characteristic zero;
- the fold is finite birational on the accepted open and is `S_2`;
- normality and a horizontal height-one fold singular component remain undecided;
- the raw target branch is nonnormal in codimension one;
- ordinary binodal contacts contribute no 3-primary local class;
- the ordinary Picard group of the cubic incidence is known;
- the missing object is the horizontal three-primary part of `Cl/Pic` after normalization.

## Work packages

### T2.0 — choose the correct global model

Select one route and prove it is equivalent on the common open:

1. a finite algebra for the full gate-saturated singular ideal over `Q(A,u)` or another valid parameter pair;
2. a different local-complete-intersection chart whose zero locus equals the full singular scheme;
3. direct normalization of the target branch from its exact primitive equation, bypassing the fold.

Every gate must be proved a unit by exact norm/inverse. Do not expand the full gate product.

### T2.1 — horizontal component and normalization

Construct the dominant height-one singular/branch components exactly. For each:

- prime ideal and field of definition;
- generic multiplicity and residue degree;
- integral closure and conductor;
- completed local model with a determinacy or integral-basis certificate;
- branch and contact multiplicities.

A finite list of slices does not prove a horizontal component.

### T2.2 — local three-primary class groups

For every codimension-one or codimension-two contact meeting the generic residual cubic, compute the local class group or at least its 3-primary part. Treat:

- split/nonsplit `xy=pi^m` models;
- nonnormal crossings and conductor gluing;
- higher `cA` models suggested by the vanishing cubic/quartic jets;
- multiple residual components;
- vertical exceptional classes.

Finite jet vanishing is not an all-orders local normal form.

### T2.3 — global horizontal degree image

On the normalized dominant incidence, prove that vertical and exceptional classes do not introduce a degree prime to three. Assemble the localization/conductor sequence and prove

\[
(\operatorname{Cl}/\operatorname{Pic})[3]_{\rm horiz}=0
\]

or directly

\[
\deg_{\rm horiz}=3\mathbf Z.
\]

### T2.4 — headline bridge

Verify residue degree one, proper specialization, versality, and the exact field identifications required by `BR-T-NEG`. State the non-`G`-unirationality and essential-dimension consequences separately.

## Exits

```text
T2-INDEX3-HEADLINE-NEGATIVE
T2-DANGEROUS-3-CLASS
T2-HORIZONTAL-BRANCH-PASS
T2-ROUTE-REFUTED
T2-UNDECIDED
```

A proof of fold nonnormality alone is structural, not the headline.

## Output contract

Write under

```text
problems/E-klein-cubic/goal_runs_after_35fa/T_TARGET_BRANCH/
```

Provide `COMMON_OPEN.md`, exact component/normalization payloads, `LOCAL_CLASS_GROUPS.md`, `GLOBAL_DEGREE_IMAGE.md`, bridge ledger, independent verifiers, and `SEAL.json`.