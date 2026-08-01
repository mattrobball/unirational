# Goal KLS2 — prove the missing minimality-to-discrepancy/conductor theorem

**Pinned state:** `35fa8f59b6a1423cc89300aeaceefe91552be5ba`  
**Priority:** 10  
**Possible headline direction:** negative

## Mission

Supply the analytic theorem that the earlier KLS computations require: a primitive minimal rank-four landing covariant must have its conductor and logarithmic/foliation defect in a finite, explicitly classifiable list. Then eliminate every configuration using exact representation-specific data.

No August worker implemented this goal. Do not begin a new finite CAS table until the theorem reducing to that table is proved.

## Binding state

- literal and squarefree-multiple `P22` conductor branches are already excluded at their stated scope;
- normality, lc, canonical, or plt hypotheses alone do not imply the needed cancellation; exact countermodels are recorded;
- pair-lc can leave a reduced copy at a zero-discrepancy place;
- pair-plt only controls certain exceptional codimension-at-least-two centres;
- the missing input is representation-specific primitive minimality and conductor-support control.

## Work packages

### KLS2.0 — exact minimality notion and bridge

Define primitive minimality among homogeneous landing covariants modulo:

- scalar invariant factors;
- precomposition by known equivariant endomorphisms;
- common projective factors;
- birational changes that preserve the map.

Prove that a hypothetical parametrization admits a representative satisfying this notion.

### KLS2.1 — discrepancy/conductor theorem

Relate the logarithmic derivation/foliation attached to a minimal covariant to:

- divisorial zeros of the Jacobian determinant;
- conductor pullback on normalization;
- discrepancies of the induced pair or foliation;
- ramification of the rational map;
- the exact invariant polynomial factors available for `PSL(2,11)`.

Prove a theorem forcing every conductor-dominating component into a finite list of invariant/support configurations. The theorem must survive the known countermodels and explain exactly where representation-specific minimality enters.

### KLS2.2 — finite configuration ledger

Only after KLS2.1, enumerate the resulting configurations. For each record:

- invariant factor and multiplicity;
- stabilizer/orbit support;
- normalization and conductor behaviour;
- discrepancy and residue constraints;
- compatibility with the 55-plane arrangement and fixed-locus orders;
- whether quartic precomposition or scalar multiplication violates minimality.

### KLS2.3 — exact elimination

Use existing `P22` packets where applicable and build new exact certificates for the remaining configurations. Every elimination must be characteristic zero or transferred by a proved proper/generic-freeness argument.

### KLS2.4 — headline bridge

Prove that exhaustion of the finite list excludes every primitive landing covariant, then invoke the accepted exhaustive covariant reduction.

## Exits

```text
KLS2-HEADLINE-NEGATIVE
KLS2-MINIMALITY-THEOREM-PASS
KLS2-COUNTEREXAMPLE
KLS2-NO-FINITE-REDUCTION
KLS2-UNDECIDED
```

If the proposed minimality theorem is false, a certified counterexample is the correct terminal result; do not hide it behind more computation.

## Output contract

Write under

```text
problems/E-klein-cubic/goal_runs_after_35fa/KLS_MINIMALITY/
```

Provide `MINIMALITY.md`, `DISCREPANCY_THEOREM.md`, counterexample audits, finite configuration payloads, exact eliminations, independent verifiers, and `SEAL.json`.