# Local worker goals

All workers run on the local checkout. No worker may create or invoke a
GitHub Actions workflow. Final files are integrated only under
`goal_runs_after_5899d0/T3_NORMALIZATION_CLPIC3/`.

## Dependency graph

```text
T3-RUR ──────> T3-NORM ──────> T3-INTEGRATE
    │              │                  ^
    └────> T3-DISC ┴────> T3-PIC ─────┘
```

`T3-DISC` may replay existing contact packets immediately, but its final
factorization must use the authoritative normalization from `T3-NORM`.
`T3-PIC` may prepare abstract localization sequences early, but may not close
the global group before the normalized component/contact lists are frozen.

---

## Worker T3-RUR — exhaustive dominant singular component

### Goal

Prove or refute that the corrected degree-six RUR prime is the complete
generic gate-saturated singular fibre over `Q(A,u)`.

### Required computations

1. Replay the six exact RUR identities and irreducibility of `QZ`.
2. Run the unconstrained generic mod-101 saturation locally.
3. Save the reduced Groebner basis, leading ideal, Hilbert function, and six
   standard monomials.
4. Compute exact norms/inverses for every gate and chart determinant.
5. Prove finite flat degree six after one explicit localization.
6. Compare ideals exactly and account for every gate divisor.

### Deliverables

```text
cas/rur_*
DOMINANT_COMPONENTS.md
components.json
verify_components.py
RUR_RETURN.md
```

### Return values

```text
T3-RUR-EXHAUSTIVE
T3-RUR-NOT-EXHAUSTIVE
T3-RUR-BLOCKED
```

Do not report `T3-RUR-EXHAUSTIVE` from special fibres or interpolation alone.

---

## Worker T3-NORM — stable-ideal normalization and conductor

### Dependency

Consumes `T3-RUR-EXHAUSTIVE` and its frozen prime/gate ledger.

### Goal

Construct the exact integral closure on the common open and compute the
normalization conductor.

### Required computations

1. Find a two-generator chart `p=(c,d)` or a finite principal-open cover.
2. Certify `p^2=c*p` and `(c:d)=p`.
3. Produce `alpha,beta` with
   `d^2=alpha*c^2+beta*c*d`.
4. Build `T=S_G[d/c]` and prove equality with `End_S(p)`.
5. Prove `R_1+S_2` on the same open.
6. Prove `cond(S_G subset T)=p`.
7. Compute generic branch/residue/ramification/delta/conductor data.
8. Descend nonsquareness from the exact `(-6,-6)` witness through a regular
   flat model.

### Deliverables

```text
cas/normalization_*
COMMON_OPEN.md
NORMALIZATION.md
normalization_payload.json
CONDUCTOR.md
verify_normalization.py
NORM_RETURN.md
```

### Return values

```text
T3-NORMALIZATION-PASS
T3-NORMALIZATION-REFUTED
T3-NORMALIZATION-BLOCKED
```

---

## Worker T3-DISC — normalized discriminant and local class groups

### Goal

Produce the exhaustive normalized height-one contact ledger and actual-field
three-primary local class groups.

### Immediate independent tasks

1. Replay the authoritative discriminant and exact contacts `S:2`, `E:4`.
2. Compute `c4,c6` valuations on both Newton branches over `E` and determine
   the minimal local cubic type.
3. Replay the generic local models on `L`, `D`, and `C`.
4. Prepare normalized-chart calculations for `J1`, `J2`, and `F15`.

### Tasks after T3-NORM

1. Pull `Delta_cub` into every normalization chart.
2. Factor its full height-one support in characteristic zero.
3. Compute every valuation and residue-field splitting datum.
4. Prove the list exhaustive by exact norm/Fitting/degree calculations.
5. Classify all conductor/discriminant and boundary intersections.
6. Compute the actual-field local `Cl[3]`, not only geometric split groups.

### Deliverables

```text
cas/discriminant_*
DISCRIMINANT_CONTACTS_MOD3.md
LOCAL_MODELS.md
LOCAL_CLASS_GROUPS.md
contacts.json
verify_contacts.py
DISC_RETURN.md
```

### Return values

```text
T3-LOCAL-MOD3-ZERO
T3-LOCAL-DANGEROUS-3-CLASS
T3-DISCRIMINANT-BLOCKED
```

---

## Worker T3-PIC — residual Picard and global degree image

### Goal

Convert the normalized local ledger into the horizontal global
`Cl/Pic[3]` decision.

### Tasks

1. State the exact localization/conductor sequence for the normalized total
   incidence.
2. Identify the vertical and exceptional divisor lattice explicitly.
3. Prove every non-Cartier class is detected by the audited strata.
4. Control the residual codimension-three locus by parafactoriality,
   prime-to-three punctured Picard groups, or an exact localization argument.
5. Insert the accepted ordinary Picard theorem at its precise scope.
6. Compute the horizontal three-primary quotient and degree image.

### Deliverables

```text
RESIDUAL_PICARD.md
GLOBAL_DEGREE_IMAGE.md
global_class_group_payload.json
verify_global_assembly.py
PIC_RETURN.md
```

### Return values

```text
T3-GLOBAL-CLPIC3-ZERO
T3-GLOBAL-DANGEROUS-3-CLASS
T3-GLOBAL-PICARD-BLOCKED
```

No global vanishing may be inferred merely from a list of local groups; the
exact sequence and exhaustiveness step are mandatory.

---

## Worker T3-INTEGRATE — theorem, scope, and seal

### Dependencies

Consumes the frozen outputs of all preceding workers.

### Tasks

1. Reconcile all opens, coordinates, fields, and source hashes.
2. Reject any local claim made on a chart not covering its advertised prime.
3. Run all independent verifiers from a clean checkout.
4. Assemble `STATUS.md`, `THEOREM.md`, `verify_all.py`, `SHA256SUMS`, and
   `SEAL.json`.
5. State the Task-B scope fence prominently.

### Successful theorem

If the global quotient vanishes, prove

```text
(Cl/Pic)[3]_horizontal=0,
deg_horizontal=3 Z,
ind(C_fix/k(D))=3.
```

Then exit `T3-FIXED-FRAME-INDEX3-PASS`, explicitly without a generic-Klein
headline claim.

### Alternative theorem

If a class survives, exit `T3-DANGEROUS-3-CLASS` with its exact divisor,
actual-field order, horizontal survival, and corrected degree image.

### Integrity rule

Integration may downgrade a worker return but may never strengthen it without
a new exact verifier.
