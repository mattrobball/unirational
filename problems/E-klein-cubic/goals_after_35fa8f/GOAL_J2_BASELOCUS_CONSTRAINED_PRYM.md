# Goal J2 — a base-locus-constrained Albanese/Prym obstruction

**Pinned state:** `35fa8f59b6a1423cc89300aeaceefe91552be5ba`  
**Priority:** 11  
**Possible headline direction:** negative

## Mission

Develop a fixed-centre/Albanese/Prym obstruction that applies to the actual resolution of a landing covariant, not to the unrestricted category of equivariant blowups.

Goal D has already constructed unrestricted free-orbit curve centres whose blowup contributions reproduce the target rational Hodge structure and motive. Therefore a pure Hodge-character, isogeny-factor, or unrestricted blowup-centre argument is refuted. The new theorem must show that such reproducing centres cannot occur in the base locus/resolution of a primitive landing covariant, or must impose a finer integral/polarized compatibility they fail.

## Binding inputs

- the corrected split injection `H^3(X)->H^3(Z)` for a resolved dominant map;
- the exact stabilizer and normal-cone transition system;
- target intermediate Jacobian/Prym data for involutions;
- Goal D's explicit unrestricted reproducing centre system;
- the 55 fixed elliptics, residual `S3` action, and marked type-I/type-II points;
- the requirement that every resolution centre arise from the successive singular/base ideals of one global covariant.

## Work packages

### J2.0 — audit and defeat the unrestricted countermodel

Reconstruct Goal D's free-orbit Prym curves and identify exactly why they are allowed as abstract equivariant blowup centres. Determine which properties are incompatible, if any, with centres appearing in a landing-covariant resolution:

- containment in a five-form base ideal;
- degree and regularity bounds;
- incidence with the 55 forced planes;
- stabilizer and orbit constraints;
- normal-bundle characters;
- conductor/exceptional multiplicities;
- primitive minimality.

If none can be excluded, record that the Prym route is refuted at this level.

### J2.1 — construct the resolved fixed-centre 1-motive

For every subgroup/fixed component in the actual blowup tree, define a functorial system of:

- `Alb^1` torsors and `Pic^0` varieties;
- norm and restriction maps;
- incidence lattices from marked components;
- exceptional-divisor corrections;
- residual normalizer actions.

Prove blowup functoriality and invariance under changing the equivariant resolution. For involutions, recover the order-three affine torsor and the normal-slice Prym.

### J2.2 — couple to the global coefficient/base ideal

Translate the 1-motive/Prym classes into exact equations or congruences on:

- symbolic plane order;
- transition divisors;
- horizontal degeneracy curves;
- point-link multiplicities;
- nonlinear coefficients of `F(p)=0`.

A nonzero invariant of an arbitrary centre is irrelevant unless every hypothetical covariant induces it.

### J2.3 — integral/polarized refinement

Test whether the required target factor can occur with the correct:

- integral lattice and polarization;
- CM `-11` endomorphism structure;
- residual `S3` parity;
- Prym type;
- Mackey induction across exchanged centres.

Rational character containment alone is known to have too much slack.

### J2.4 — contradiction or route refutation

Prove every admissible centre system fails the refined invariant, or construct an admissible base-locus centre system reproducing it and retire the route.

## Exits

```text
J2-HEADLINE-NEGATIVE
J2-BASELOCUS-PRYM-OBSTRUCTION
J2-UNRESTRICTED-COUNTERMODEL-EXTENDS
J2-ROUTE-REFUTED
J2-UNDECIDED
```

## Output contract

Write under

```text
problems/E-klein-cubic/goal_runs_after_35fa/J_BASELOCUS_PRYM/
```

Provide `D_COUNTERMODEL_AUDIT.md`, `FIXED_CENTRE_1MOTIVE.md`, exact centre/base-ideal constraints, polarization/isogeny payloads, independent verifiers, and `SEAL.json`.