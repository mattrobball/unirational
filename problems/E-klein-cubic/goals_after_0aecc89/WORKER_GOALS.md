# Local worker goals after `0aecc89`

All workers run from a fresh local fetch of `main`.  No worker may create or
invoke GitHub Actions.  Final result packets live only under

```text
problems/E-klein-cubic/goal_runs_after_0aecc89/
```

The goal files in this directory are authoritative.  This document assigns
nonoverlapping execution slices.

## Dependency graph

```text
G2 ─────> G3A ─────────────> G3P-POLAR ────────┐
                                                │
H2/H3 ──> G7A-DESIGN ──┐                       │
                       ├─> G7B-CYCLES ─> G7C-GEOMETRY ─> INTEGRATE
G4 induced cycles ─────┘                       │
                                                │
H6/G5/Q3/C6 returns ────────────────────────────┘
```

`G3A` and `G7A-DESIGN` start immediately and in parallel.  `G3P-POLAR` begins
after the arithmetic engine is frozen.  `G7B-CYCLES` waits for the minimum G4
induced-cycle output.  `G7C-GEOMETRY` waits for both the design and the two
cycles.

At most one unrelated job expected to exceed 8 GiB RSS may run at once.  None
of `G3A` or `G7A-DESIGN` should require the heavy slot.

---

## Worker G3A — exact field, cubic, and bridge

### Goal

Execute
[`GOAL_G3A_EXACT_ARITHMETIC_DOMINANCE.md`](GOAL_G3A_EXACT_ARITHMETIC_DOMINANCE.md)
without beginning a general point search.

### Required result

- authoritative exact `K_proj` arithmetic;
- independent reconstruction of all 35 coefficients of `Phi`;
- polarization and derivative APIs;
- exact smoothness boundary;
- dominance and negative-source bridge ledgers.

### Output

```text
goal_runs_after_0aecc89/G3A_EXACT_ARITHMETIC_DOMINANCE/
```

### Return values

```text
G3A-ARITHMETIC-DOMINANCE-PASS
G3A-ARITHMETIC-PASS-DOMINANCE-GAP
G3A-CANONICAL-INPUT-FAIL
G3A-BLOCKED
```

Do not report a point or pointlessness exit from this worker.

---

## Worker G7A-DESIGN — exact two-class design

### Goal

Complete G7.0 and G7.1 using only constant finite-group arithmetic.

### Tasks

1. Reconstruct both maximal-`A5` conjugacy classes from the installed group.
2. Compute all 121 cross-intersections and their isomorphism types.
3. Identify every cross-orbit and the five-regular incidence relation.
4. Verify or correct the `2-(11,5,2)` parameters.
5. Compute `N`, `N*N^t`, `N^t*N`, automorphisms, and the exact two
   permutation-module decompositions.
6. Identify the Klein and companion constituents and all incidence
   intertwiners over their exact fields.
7. Provide a verifier that regenerates the group, subgroups, incidence, and
   projectors without importing the producer.

### Output

```text
goal_runs_after_0aecc89/G7_DOUBLE_A5_BIPLANE/design/
```

### Return values

```text
G7-PALEY-BIPLANE-IDENTIFIED
G7-CROSS-CLASS-PROJECTOR-PASS
G7-DESIGN-CORRECTION
G7-CANONICAL-INPUT-FAIL
```

This worker may finish before G4.  It must not fabricate induced point
coordinates.

---

## Worker G3P-POLAR — tautological polar system

### Dependency

Consumes a frozen `G3A-ARITHMETIC-DOMINANCE-PASS` packet.

### Goal

Execute G3P.0–G3P.2 before any odd-degree descent attempt.

### Tasks

1. Reconstruct the canonical ambient point `q` and prove `Phi(q)` is a unit on
   one explicit open.
2. Build `H_q`, `Q_q`, `D_q`, and the resolved tangent incidence `I_q`.
3. Compute exact rank, Witt, discriminant, and Clifford data of every quadratic
   object actually used.
4. Search for rational singular loci, linear spaces, conic bundles, quadric
   bundles, and inverse projection formulas.
5. Return the smallest fibration even if no section is found.

### Output

```text
goal_runs_after_0aecc89/G3P_POLAR_ODD_DEGREE_DESCENT/
```

### Initial return values

```text
G3P-RATIONAL-FIBRATION-PASS
G3P-POLAR-SYSTEM-PASS
G3P-UNDECIDED
G3P-CANONICAL-INPUT-FAIL
```

After G4 returns, the same worker or a successor may execute G3P.3.  Springer
may be invoked only for an explicit quadratic object over an exact odd-degree
field.

---

## Worker G7B-CYCLES — compatible lifts and double induction

### Dependencies

Consumes

```text
G7-PALEY-BIPLANE-IDENTIFIED or the corrected exact design exit;
G4-INDUCED-DEGREE11-POINT-PASS for both A5 classes;
G3A-ARITHMETIC-DOMINANCE-PASS.
```

### Goal

Complete G7.2 and G7.3.

### Tasks

1. Audit the projective-scaling problem before taking any sum or trace.
2. Install either compatible cone lifts or a fully multihomogeneous tensor
   interface.
3. Materialize the two degree-eleven cycles in the same G3A field model.
4. Verify all 22 substitutions in `Phi` and both Galois actions.
5. Construct the incidence correspondence between the two finite-etale
   algebras.
6. Test the interface under independent rescaling of every geometric point.

### Output

```text
goal_runs_after_0aecc89/G7_DOUBLE_A5_BIPLANE/cycles/
```

### Return values

```text
G7-INDUCED-DOUBLE-CYCLE-PASS
G7-PROJECTIVE-SCALING-PASS
G7-CANONICAL-INPUT-FAIL
G7-UNDECIDED
```

Do not repeat G4's one-class low-arity or secant search.

---

## Worker G7C-GEOMETRY — cross operations and effective residual cycles

### Dependencies

Consumes the frozen G7A and G7B packets.

### Goal

Complete G7.4–G7.6.

### Tasks

1. Enumerate the complete design-generated operation space through cubic
   arity.
2. Evaluate every canonical output in `Phi`.
3. Construct and verify all incident and nonincident third-intersection cycles.
4. Compute their ideals, spans, orbit decompositions, moment tensors, and
   design-weighted residual geometry.
5. Search exhaustively within that finite operation space for:
   - a rational point;
   - a rational line on `X_gen`;
   - a plane conic with a rational residual line;
   - an effective length-two subscheme;
   - a one-parameter conic or genus-one equation with a rational section.
6. Perform scheme-theoretic multiplicity checks before reducing cycle degree.
7. Independently verify and bridge any point.

### Output

```text
goal_runs_after_0aecc89/G7_DOUBLE_A5_BIPLANE/geometry/
```

### Return values

```text
G7-POINT-HEADLINE-POSITIVE
G7-EFFECTIVE-DEGREE2-HEADLINE-POSITIVE
G7-RESIDUAL-GEOMETRY-PASS
G7-UNDECIDED
G7-CANONICAL-INPUT-FAIL
```

A signed degree-one cycle or a rational zero-cycle class is not an effective
length-two exit.

---

## Worker INTEGRATE — post-return headline decision

### Dependencies

Consumes every returned packet from

```text
G3A, G3P, G7A, G7B, G7C,
G3, G4, C6, H6, G5, Q3,
and the current T3 workers.
```

### Tasks

1. Fetch `main` and reject any stale result already superseded by a later
   packet.
2. Reconcile field models, projective conventions, opens, and input hashes.
3. Replay every load-bearing verifier from a clean checkout.
4. Check one semantic identity not tested by each verifier.
5. Promote a headline only after its bridge is exact and independent.
6. If no headline closes, identify the single smallest surviving arithmetic or
   geometric gate; do not mint another broad route survey.
7. Write the next folder only after recording which current goals have reached
   authorized exits.

### Successful exits

```text
PROBLEM-E-HEADLINE-POSITIVE
PROBLEM-E-HEADLINE-NEGATIVE
POST-0AECC-INTEGRATION-OPEN
```

The third exit must name the next decisive gate and explicitly retire every
completed structural mission.