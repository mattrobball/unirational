# Goal T3 — normalize the genuine target branch and decide the mod-3 defect

**Pinned state:** `bd610a032bb9561d2daeb91a2cb60c48c082ca2f`  
**Priority:** 3  
**Possible headline direction:** negative  
**Accepted bridge:** `BR-T-NEG`

## Mission

Supply the exact local and global facts missing from the target-branch
argument.  On the normalized dominant cubic incidence, prove either

```text
(Cl/Pic)[3]_horizontal = 0
```

and hence that every horizontal divisor has degree divisible by three, or
exhibit an explicit dangerous three-primary class.

Vanishing closes the Klein-cubic headline negatively because the selected
versal target divisor has residue degree one and the residual cubic has index
three.  A dangerous class refutes this negative route at the selected branch
but does not prove a positive headline.

## Binding state

The following are accepted inputs and must be replayed, not reproved from
scratch:

- over `F=C(A,B,Y,Z)`, the fixed-frame cubic has index three, no `F`-point,
  and trivial `Pic^0(F)`;
- `K_proj/F` has degree six and geometric/arithmetic monodromy `S_6`;
- the selected genuine target divisor has residue degree one and smooth
  generic residual cubic;
- ordinary Picard theory gives

  ```text
  Pic(T_D) = Z H_z + Z H_lambda;
  ```

- the raw irreducible target branch is nonnormal in codimension one;
- Cramer saturation selects the simple multiplicity-one fold and removes the
  squared Cramer factors;
- the exact primitive model is `P(A,B,Y,Z,u)` with fold equations
  `P=P_u=0` on the open where `P_uu`, the Cramer minor `delta`, the content
  `C`, and the other accepted gates are units;
- on the slice `A=0, B=2`, the full critical ideal has dimension one and
  degree fourteen; the twelve RUR points lie on that curve and are not
  isolated nodes;
- the old `(P_B,P_Y,P_Z)` chart has extraneous components and is prohibited
  with the old gate set.

The exact unresolved group is the three-primary non-Cartier defect after
normalization.  Ordinary normality or Picard rank two is not enough.

## Required fact packets

### T3.A — one correct global normalization model

Choose exactly one model and prove equivalence on a common exact open:

1. direct normalization of the irreducible target branch;
2. integral closure of the Cramer-saturated fold algebra;
3. a new local-complete-intersection chart whose saturated zero locus equals
   the full singular/fold scheme;
4. a finite algebra over a valid generic parameter pair, followed by descent
   to the branch.

For the chosen model, provide:

- a finite birational algebra with the same fraction field;
- exact unit certificates for every inverted gate;
- an integral basis or explicit generators with monic equations;
- a proof of normality by `R_1+S_2`, an exact integral-closure computation,
  or mutually inverse local models;
- the conductor and its height-one support.

A list of exact special fibres is discovery only.  The slice critical curve
must not be promoted to a global component without an exact dominance proof.

### T3.B — exhaustive dominant singular and conductor components

On the valid common open, determine every height-one component relevant to the
normalization or cubic-discriminant pullback.  For each component record:

```text
prime ideal,
field of definition,
dimension and degree,
generic multiplicity,
residue degree,
generic Jacobian rank,
gate norms,
conductor exponent.
```

Use modular decomposition and interpolation only for discovery.  Prove the
characteristic-zero list exhaustive by exact membership plus a degree,
Hilbert-polynomial, Fitting, or associated-cycle calculation.

Required output:

```text
DOMINANT_COMPONENTS.md
components.json
verify_components.py
```

### T3.C — generic local normalization and local class groups

At the generic point of every component from T3.B:

1. take a transverse one- or two-dimensional local model over the component
   function field;
2. compute the integral closure, number of branches, ramification indices,
   residue extensions, delta invariant, and conductor;
3. identify the completed local equation, with a determinacy bound or exact
   integral-basis certificate;
4. compute the local divisor class group or at least its three-primary part;
5. distinguish split and nonsplit forms, nonnormal crossings, and higher
   `cA` behaviour.

Finite vanishing of cubic and quartic jets is not an all-orders normal form.
If the model is formally `xy-h(z,w)`, determine enough of `h` to prove the
class-group conclusion; do not infer `h=0` from long residual vanishing.

### T3.D — pull back the cubic discriminant and compute contact orders mod 3

On the normalized base:

1. pull back the authoritative fixed-frame cubic discriminant;
2. factor its height-one support on every chart meeting the dominant branch;
3. compute the exact valuation `m_E=v_E(Delta_cub)` at every prime;
4. record `m_E mod 3`, splitting data, and the corresponding local cubic
   incidence model;
5. prove that the list is exhaustive, including components at chart infinity
   and along the conductor.

For a nodal model `xy=pi^m`, the dangerous local torsion is detected by
`3|m`; for more complicated models compute the actual local group rather than
forcing this template.

A random line screen or a reduced modular pullback is not the required
characteristic-zero contact ledger.

### T3.E — residual codimension-three Picard audit

After removing the codimension-two contact and conductor strata, determine the
residual singular locus of the normalized fourfold incidence.  Prove one of:

- residual codimension at least four and lci parafactoriality;
- every punctured local Picard group in codimension three has exponent prime
  to three;
- an explicit localization sequence showing that residual classes cannot
  change the horizontal degree image.

If a three-primary residual class survives, exhibit it as an exact local or
global Weil divisor class.

### T3.F — global assembly and headline bridge

Assemble normalization, conductor, local class groups, and discriminant
contacts into the exact localization/conductor sequence.  Compute the image
of the horizontal degree map.

The negative exit requires all of:

```text
residue degree of target divisor = 1,
generic residual cubic smooth,
index of residual cubic = 3,
(Cl/Pic)[3]_horizontal = 0,
deg_horizontal = 3 Z,
proper specialization and versality.
```

Write `BRIDGE_TARGET_NEG.md` checking these hypotheses one by one.

## Parallel worker assignments

The fact packets may be split among Sol Ultra workers as follows:

- **Worker T-NORM:** T3.A and T3.B;
- **Worker T-LOCAL:** candidate integral bases and local class groups for
  each component discovered by T-NORM;
- **Worker T-DISC:** T3.D using the candidate normalization, with independent
  factorization and valuation code;
- **Worker T-PIC:** T3.E and the local-to-global exact sequence;
- **Worker T-INTEGRATE:** reconcile all coordinate changes, opens, and seals,
  then execute T3.F.

T-LOCAL, T-DISC, and T-PIC may perform modular or specialized discovery before
T-NORM finishes, but their final theorems must use the authoritative normal
model.

## Exits

```text
T3-INDEX3-HEADLINE-NEGATIVE
T3-DANGEROUS-3-CLASS
T3-NORMALIZATION-PASS
T3-LOCAL-MOD3-LEDGER-PASS
T3-GLOBAL-MODEL-REFUTED
T3-UNDECIDED
T3-CANONICAL-INPUT-FAIL
```

Nonnormality alone, a long formal residual, or a finite collection of slices
is not a headline exit.

## Output contract

Write under

```text
problems/E-klein-cubic/goal_runs_after_bd610a/T3_TARGET_BRANCH_MOD3/
```

Provide at least:

```text
INPUT_MANIFEST.json
COMMON_OPEN.md
NORMALIZATION.md
normalization_payload.json
DOMINANT_COMPONENTS.md
LOCAL_MODELS.md
LOCAL_CLASS_GROUPS.md
DISCRIMINANT_CONTACTS_MOD3.md
RESIDUAL_PICARD.md
GLOBAL_DEGREE_IMAGE.md
BRIDGE_TARGET_NEG.md when applicable
produce_*.py or exact CAS scripts
independent verify_*.py
SEAL.json
STATUS.md
```

The seal must include exact integral bases, component ideals, contact
valuations, local class-group data, and all coordinate/open certificates used
by the global conclusion.