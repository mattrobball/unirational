# Route 2 — Structured direct arithmetic on `V(Phi)`

**Repository:** `mattrobball/unirational`

**Parent state:** `eb21458bea684d2399ad18f003e2be8ebdd161ce`

**Priority:** 1

**Direction:** positive/negative decision on a direct `K_proj`-point search.

## Mission

G3B/C installed the equations of the generic Klein cubic in the exact
`K_proj` frame. This task is not another unrestricted line/conic scan. It must
exploit the available exact structures:

- the `PSL(2,11)` and maximal `A5` representation theory;
- the polar system around the tautological ambient point;
- determinantal/Fano geometry;
- trace tensors from degree-11 subgroup constructions.

The target is either an explicit

\[
r\in X_{gen}(K_{proj})
\]

or a scoped obstruction/no-go theorem for the structured families tested.

## Forbidden searches

Do not spend computation on:

- random projective charts;
- arbitrary low-degree line/conic enumeration;
- isolated finite-field point searches without characteristic-zero transfer;
- modular emptiness claims without a good-reduction theorem.

## G3S.0 — exact arithmetic base

Consume:

```text
goal_runs_after_0aecc89/G3A_EXACT_ARITHMETIC_DOMINANCE/
goal_runs_after_0aecc89/G3P_POLAR_ODD_DEGREE_DESCENT/
goal_runs_after_0aecc89/C6_DETERMINANTAL_FANO/
```

Maintain the exact rank-12 `K_proj` arithmetic model.

All candidate points must be verified directly in the 35 coefficient generic
cubic:

\[
\Phi(a)=0.
\]

## G3S.1 — A5-equivariant point ansatz

For each maximal `A5` class:

1. compute all small-degree equivariant maps
   \[
   W\dashrightarrow W
   \]
   arising from Reynolds covariants;
2. classify the invariant parameter space before searching coefficients;
3. impose
   \[
   \Phi(F)=0
   \]
   exactly over `K_proj`;
4. verify whether a solution gives a genuine homogeneous landing covariant.

Use the known degree bounds only as an input to organize the search. Do not
reopen the all-degree theorem.

Deliver:

```text
A5_ANSATZ_CLASS1.json
A5_ANSATZ_CLASS2.json
A5_ANSATZ_REPORT.md
```

Exit:

```text
G3S-A5-ANSATZ-PASS
```

only if an exact family is produced.

## G3S.2 — polar/determinantal intersection

Use the canonical ambient point

\[
q=[1:0:0:0:0]
\]

and its polar data:

\[
H_q:B(q,q,v)=0,
\qquad
Q_q:B(q,v,v)=0.
\]

Search only structured loci:

1. singular or low-rank fibres of the polar pencil;
2. maximal isotropic subspaces of the polar quadric;
3. determinantal Fano components;
4. planes forced by representation theory.

For every candidate subspace `Pi`:

- restrict `Phi` exactly;
- factor the restricted cubic;
- record whether a component lies inside `X_gen`;
- record the induced map back to the cubic.

A quadric point without a map back to `X_gen` is not a success.

Deliver:

```text
POLAR_STRUCTURED_SEARCH.md
polar_structured_results.json
```

## G3S.3 — trace tensor descent search

Consume genuine degree-11 structures when available.

Given an `L/K_proj` point:

\[
a\in X(L),
\]

form exact trace tensors:

\[
Tr(a),\quad Tr(a\otimes a),\quad Tr(B(a,a,-)).
\]

Search their kernels and images for canonical rational planes or conics.

For each candidate:

1. construct the residual equation;
2. verify it over `K_proj`;
3. test whether it has an `L`-point inherited from the degree-11 point;
4. if quadratic, invoke Springer only with an explicit map back.

Deliver:

```text
TRACE_TENSOR_PLANES.md
trace_tensor_results.json
```

## G3S.4 — C6 determinantal route

Continue the determinantal/Fano direction only through exact structures.

Tasks:

1. reconstruct the determinantal model;
2. identify its Fano parameter spaces;
3. determine whether a rational point/line/plane in the structured Fano family
   produces a point of `X_gen`;
4. verify all maps explicitly.

Deliver:

```text
DETERMINANTAL_STRUCTURES.md
fano_structured_results.json
```

## CAS policy

CAS is required for this route.

Allowed local tools:

```text
SageMath
Singular
Magma (local)
Macaulay2 (local)
FLINT via Sage
```

Do not use GitHub Actions runners for CAS.

Required CAS uses:

- exact Gröbner/elimination for structured ideals;
- invariant-space linear algebra;
- determinantal minors;
- exact factorization;
- trace-tensor reduction.

Record:

- commands;
- input hashes;
- exact outputs;
- peak memory;
- timeouts as nonverdicts.

## Required verifier discipline

The verifier must independently reconstruct:

- representation actions;
- invariant spaces;
- candidate equations;
- claimed point identities.

Stored booleans are not certificates.

## Deliverables

Write under:

```text
problems/E-klein-cubic/goal_runs_after_eb21458/G3S_STRUCTURED_DIRECT_ARITHMETIC/
```

Minimum files:

```text
INPUT_MANIFEST.json
STATUS.md
A5_ANSATZ_REPORT.md
POLAR_STRUCTURED_SEARCH.md
TRACE_TENSOR_PLANES.md
DETERMINANTAL_STRUCTURES.md
produce.py
verify_all.py
REPLAY.md
SEAL.json
```

## Authorized exits

```text
G3S-POINT-HEADLINE-POSITIVE
G3S-STRUCTURED-COVARIANT-PASS
G3S-DETERMINANTAL-PASS
G3S-STRUCTURED-NO-GO
G3S-UNDECIDED
```

Only `G3S-POINT-HEADLINE-POSITIVE` is a Problem-E headline candidate.
