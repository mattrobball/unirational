# Goal V2 — transfer the new infinity obstruction to a genuine versal twist, or find another decisive valuation

**Pinned state:** `35fa8f59b6a1423cc89300aeaceefe91552be5ba`  
**Priority:** 12  
**Possible headline direction:** negative  
**Primary new input:** `F_CONIC_ALGEBRA/INFINITY_OBSTRUCTION.md`

## Mission

Use valuation theory to prove pointlessness of the genuine generic Klein twist or a proper-subgroup generic twist. The new fixed-frame infinity place is an exact model of the desired mechanism: residue degree one upstairs and residual cubic of index three. Determine whether it descends from or lifts to a valuation of a genuine versal twist; otherwise search systematically for a corresponding place on the genuine object.

This route is independent of proving the global `Cl/Pic` theorem on the target branch.

## Work packages

### V2.0 — extract the valuation template

Formalize the exact ingredients of the fixed-frame proof:

- a divisorial valuation of the base invariant field;
- an `(e,f)=(1,1)` place of the point field;
- a proper integral model of the relevant cubic;
- residual smooth cubic with index three;
- specialization of any hypothetical rational point.

State a reusable theorem with all henselian/properness hypotheses.

### V2.1 — compare valuations across the genuine incidence diagram

Using the exact object dictionary from Goal B, determine whether the reciprocal-leading divisor `D` defines a valuation on:

- the genuine generic Klein-twist field;
- the twisted Fano section;
- the full auxiliary projector cubic;
- only the selected fixed frame.

Compute ramification, residue fields, and centres on each model. A valuation after an uncontrolled field extension is insufficient.

### V2.2 — systematic genuine-twist boundary search

If the fixed-frame place does not transfer, construct boundary divisors of the genuine twist from:

- invariant-coordinate compactifications;
- discriminant/resultant divisors;
- toroidal/tropical compactifications of the versal torsor;
- subgroup-fixed valuations;
- degeneration of the five-dimensional representation;
- target-branch and Pfaffian incidence boundaries.

Rank candidates by residue degree and residual index. Use exact Newton polyhedra/tropical initial degenerations only when they correspond to honest valuations of the genuine function field.

### V2.3 — residual pointlessness

For a candidate `(e,f)=(1,1)` place, prove the residual variety is pointless using:

- an index-three class-group calculation;
- a norm-form obstruction;
- unramified Brauer or higher cohomology;
- a complete finite-field-to-characteristic-zero good-reduction argument;
- a proper-subgroup generic-twist theorem.

A special fibre with no visible point is not a proof.

### V2.4 — headline bridge

Prove every rational point on the genuine generic twist extends to the selected proper model and specializes to the impossible residual point. Then invoke the accepted versal or subgroup bridge.

## Exits

```text
V2-VALUATION-HEADLINE-NEGATIVE
V2-FIXED-FRAME-PLACE-TRANSFERS
V2-NEW-GENUINE-PLACE-PASS
V2-FIXED-FRAME-PLACE-NONTRANSFERABLE
V2-UNDECIDED
```

## Output contract

Write under

```text
problems/E-klein-cubic/goal_runs_after_35fa/V_GENUINE_VALUATION/
```

Provide `VALUATION_TEMPLATE.md`, field/ramification payloads, compactification and residual-index certificates, independent verifiers, and `SEAL.json`.