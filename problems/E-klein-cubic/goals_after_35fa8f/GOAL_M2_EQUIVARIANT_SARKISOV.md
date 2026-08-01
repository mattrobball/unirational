# Goal M2 — construct and descend a useful equivariant Sarkisov link

**Pinned state:** `35fa8f59b6a1423cc89300aeaceefe91552be5ba`  
**Priority:** 15  
**Possible headline directions:** positive or negative with a complete rigidity bridge

## Mission

Move beyond the Picard-rank-one prime Fano model by blowing up a genuine base-field or Galois-stable centre and running the exact two-ray game. Produce a Mori fibre space with a rational section/multisection, or prove an exhaustive equivariant birational rigidity theorem strong enough to obstruct every equivariant parametrization.

A statement that the original `F_14` has Picard rank one is already known and does not settle birational models after modification.

## Work packages

### M2.0 — admissible centre census

Rank centres available over the relevant base field:

- the degree-55 point/orbit;
- subgroup-stable lines or curves;
- rational curves produced by Goal R or S19;
- the Pfaffian projector/common-line incidence;
- Galois-stable centres from `A4`, `A5`, and `D12` geometry;
- singular/branch centres from the target model.

For each centre compute normal bundle, discrepancy, Picard jump, and field of definition. A centre existing only after algebraic closure needs an exact descent package.

### M2.1 — run the two-ray game

For each viable blowup:

- compute the Cox/Mori chamber decomposition;
- identify extremal contractions and flips/flops;
- track singularities and terminal/Q-factorial conditions;
- descend every step to the base field;
- identify the resulting Mori fibre space.

Do not infer a link from numerical divisor classes alone; construct the maps.

### M2.2 — exploit the output

Seek:

- conic/del Pezzo/genus-one fibrations with a rational section;
- rational base and odd-degree multisection;
- a simpler generic-twist point problem;
- a birational map to a known unirational variety;
- a rigidity obstruction excluding compression.

### M2.3 — headline bridge

#### Positive

Produce an explicit rational point/section or unirational model and trace it back to the genuine Klein twist.

#### Negative

Classify all equivariant Mori fibre spaces birational to the genuine twist and prove none admits the required compression. The classification must be exhaustive, not one failed link.

## Exits

```text
M2-SARKISOV-HEADLINE-POSITIVE
M2-RIGIDITY-HEADLINE-NEGATIVE
M2-EXPLICIT-LINK-PASS
M2-SELECTED-CENTRE-FAILS-SCOPED
M2-UNDECIDED
```

## Output contract

Write under

```text
problems/E-klein-cubic/goal_runs_after_35fa/M_SARKISOV/
```

Provide `CENTRE_CENSUS.md`, divisor/Cox payloads, exact links and descent checks, resulting fibration/rigidity theorem, independent verifiers, and `SEAL.json`.